class ViewingPositionsController < ApplicationController
  before_action :require_login

  def update
    archive = Archive.find(params[:archive_id])
    viewing_position = ViewingPosition.find_or_initialize_by(user: current_user, archive: archive)

    if viewing_position.update(viewing_position_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def viewing_position_params
    params.require(:viewing_position).permit(:current_position_seconds)
  end
end
