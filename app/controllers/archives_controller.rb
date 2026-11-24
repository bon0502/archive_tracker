class ArchivesController < ApplicationController
  before_action :set_archive, only: %i[show edit update destroy]

  def index
    @archives = current_user.archives
  end

  def new
    @archive = Archive.new
  end

  def show
    @viewing_position = ViewingPosition.find_or_initialize_by(user: current_user, archive: @archive)
  end

  def create
    @archive = current_user.archives.new(archive_params)
    video_fetched = fetch_youtube_data(@archive)

    if @archive.save
      message = video_fetched ? "動画を登録し、YouTube情報を自動取得しました。" : "動画を登録しましたが、YouTube情報の自動取得に失敗しました。"
      redirect_to archives_path, success: message
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    fetch_youtube_data(@archive)

    if @archive.update(archive_params)
      redirect_to archives_path, success: "動画を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @archive.destroy!
    redirect_to archives_path, success: "動画を削除しました。"
  end

  private

  def set_archive
    @archive = current_user.archives.find(params[:id])
  end

  def fetch_youtube_data(archive)
    video_id = archive.youtube_video_id
    return false unless video_id.present?

    video_data = YoutubeVideoFetcher.new(video_id).fetch
    return false unless video_data

    archive.assign_attributes(video_data)
    archive.video_id = video_id
    true
  end

  def archive_params
    params.require(:archive).permit(:video_url, :status)
  end
end
