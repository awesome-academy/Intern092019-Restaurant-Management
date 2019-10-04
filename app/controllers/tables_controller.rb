class TablesController < ApplicationController
  def new
    @table = Table.new
  end

  def create
    @table = Table.new table_params
    if @table.save
      flash[:success] = t "create_table_suc"
      redirect_to new_table_path
    else
      render :new
    end
  end

  private

  def table_params
    params.require(:table).permit :table_number, :max_size, :status
  end
end
