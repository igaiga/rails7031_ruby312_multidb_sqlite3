class WriteLogsController < ApplicationController
  before_action :set_write_log, only: %i[ show edit update destroy ]

  # GET /write_logs or /write_logs.json
  def index
    @write_logs = WriteLog.all
  end

  # GET /write_logs/1 or /write_logs/1.json
  def show
  end

  # GET /write_logs/new
  def new
    @write_log = WriteLog.new
  end

  # GET /write_logs/1/edit
  def edit
  end

  # POST /write_logs or /write_logs.json
  def create
    @write_log = WriteLog.new(write_log_params)

    respond_to do |format|
      if @write_log.save
        format.html { redirect_to write_log_url(@write_log), notice: "Write log was successfully created." }
        format.json { render :show, status: :created, location: @write_log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @write_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /write_logs/1 or /write_logs/1.json
  def update
    respond_to do |format|
      if @write_log.update(write_log_params)
        format.html { redirect_to write_log_url(@write_log), notice: "Write log was successfully updated." }
        format.json { render :show, status: :ok, location: @write_log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @write_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /write_logs/1 or /write_logs/1.json
  def destroy
    @write_log.destroy

    respond_to do |format|
      format.html { redirect_to write_logs_url, notice: "Write log was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_write_log
      @write_log = WriteLog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def write_log_params
      params.require(:write_log).permit(:memo)
    end
end
