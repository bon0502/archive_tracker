class ViewingPositionsController < ApplicationController

  def update
    archive = Archive.find(params[:archive_id])
    viewing_position = ViewingPosition.find_or_initialize_by(user: current_user, archive: archive)
    viewing_position.update(viewing_position_params)
    if @viewing_position.update(viewing_position_params)
      redirect_to archive_path(archive), notice: "視聴位置を保存しました。"
    else
      redirect_to archive_path(archive), alert: "保存に失敗しました。"
    end
  end

  private

  def viewing_position_params
    params.require(:viewing_position).permit(:current_position_seconds)
  end
end
