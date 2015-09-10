class FacilityInstancesController < ApplicationController
  before_action :set_facility_instance, only: [:show, :edit, :update, :destroy]

  # GET /facility_instances
  # GET /facility_instances.json
  def index
    @facility_instances = FacilityInstance.all
  end

  # GET /facility_instances/1
  # GET /facility_instances/1.json
  def show
  end

  # GET /facility_instances/new
  def new
    @facility_instance = FacilityInstance.new
  end

  # GET /facility_instances/1/edit
  def edit
  end

  # POST /facility_instances
  # POST /facility_instances.json
  def create
    @facility_instance = FacilityInstance.new(facility_instance_params)

    respond_to do |format|
      if @facility_instance.save
        format.html { redirect_to @facility_instance, notice: 'Facility instance was successfully created.' }
        format.json { render :show, status: :created, location: @facility_instance }
      else
        format.html { render :new }
        format.json { render json: @facility_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facility_instances/1
  # PATCH/PUT /facility_instances/1.json
  def update
    respond_to do |format|
      if @facility_instance.update(facility_instance_params)
        format.html { redirect_to @facility_instance, notice: 'Facility instance was successfully updated.' }
        format.json { render :show, status: :ok, location: @facility_instance }
      else
        format.html { render :edit }
        format.json { render json: @facility_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facility_instances/1
  # DELETE /facility_instances/1.json
  def destroy
    @facility_instance.destroy
    respond_to do |format|
      format.html { redirect_to facility_instances_url, notice: 'Facility instance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facility_instance
      @facility_instance = FacilityInstance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def facility_instance_params
      params.require(:facility_instance).permit(:facility_id, :ship_id, :count, :create_count, :start_time)
    end
end
