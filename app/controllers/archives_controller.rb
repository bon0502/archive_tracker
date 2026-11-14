class ArchivesController < ApplicationController
  def index
    @archives = current_user.archives
  end

  def new
    @archive = Archive.new
  end

  def show
    @archive = Archive.find(params[:id])
    @viewing_position = ViewingPosition.find_or_initialize_by(user: current_user, archive: @archive)
  end

  def create
    @archive = current_user.archives.new(archive_params)

    if @archive.save
      redirect_to archives_path, success: "動画を登録しました。"
    else
      render :new
    end
  end

  def edit
    @archive = Archive.find(params[:id])
  end

  def update
    @archive = Archive.find(params[:id])

    if @archive.update(archive_params)
      redirect_to archives_path, success: "動画を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @archive = Archive.find(params[:id])
    @archive.destroy!
    redirect_to archives_path, success: "動画を削除しました。"
  end

  private

  def archive_params
    params.require(:archive).permit(:title, :streamer_name, :video_url, :video_id, :duration_seconds, :status)
  end
end
