class TourneysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tourney, only: [:show, :edit, :update, :destroy]
  
  # GET /tourneys
  # GET /tourneys.json
  def index
    @tourneys = current_user.tourneys.order('playDate desc')
  end

  # GET /tourneys/1
  # GET /tourneys/1.json
  def show
  end

  # GET /tourneys/new
  def new
    @tourney = current_user.tourneys.new
  end

  # GET /tourneys/1/edit
  def edit
  end

  # POST /tourneys
  # POST /tourneys.json
  def create
    @tourney = current_user.tourneys.new(tourney_params)

    respond_to do |format|
      if @tourney.save
        format.html { redirect_to tourneys_url, notice: t('tourneyCreated') }
        format.json { render action: 'show', status: :created, location: @tourney }
      else
        format.html { render action: 'new' }
        format.json { render json: @tourney.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tourneys/1
  # PATCH/PUT /tourneys/1.json
  def update
    respond_to do |format|
      if @tourney.update(tourney_params)
        format.html { redirect_to tourney_rounds_url(@tourney), notice: t('tourneyUpdated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tourney.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tourneys/1
  # DELETE /tourneys/1.json
  def destroy
    @tourney.destroy
    respond_to do |format|
      format.html { redirect_to tourneys_url }
      format.json { head :no_content }
    end
  end
  
  def report
    @tourney = current_user.tourneys.find(params[:tourney_id])
    render layout: false
    filename = @tourney.titulo.camelize + ".txt"
    headers['Pragma'] = 'public'
    headers["Content-type"] = "text/plain" 
    headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
    headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
    headers['Expires'] = "0" 
  end
  
  def printInscribed
    @tourney = current_user.tourneys.find(params[:tourney_id])
    render :layout => 'printable'
  end
  
  def printRanking
    @tourney = current_user.tourneys.find(params[:tourney_id])
    render :layout => 'printable'
  end
  
  def elimination
    @tourney = current_user.tourneys.find(params[:tourney_id])
  end
  
  def startElimination
    @tourney = current_user.tourneys.find(params[:tourney_id])
    
    # check last round is filled completely
    @lastRound = @tourney.lastRound
    if !@lastRound.nil? and !@lastRound.allMatchesFilled?
      respond_to do |format|
        format.html { redirect_to :back, alert: t('lastRoundNotFinished') }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
      return
    end
    
    respond_to do |format|
      if params[:numberOfPlayersForTop].nil? or params[:numberOfPlayersForTop] == "" or params[:numberOfPlayersForTop].to_i <= 0
        format.html { redirect_to tourney_elimination_url(@tourney), alert: t('numberOfPlayersNeeded') }
      else
        numberOfPlayers = params[:numberOfPlayersForTop].to_i
        @tourney.startEliminationRounds(numberOfPlayers)
         # Create new round
        format.html { redirect_to tourney_createAndSeedRound_url(@tourney), notice: t('tourneyUpdated') }
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tourney
      @tourney = current_user.tourneys.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tourney_params
      params.require(:tourney).permit(:state, :titulo, :playDate, :publicId, :seedType)
    end
end
