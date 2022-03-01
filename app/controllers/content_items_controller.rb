# frozen_string_literal: true

class ContentItemsController < SecureController
  def index
    @content_items = current_user.content_items
    base_events = current_user
      .publishing_targets
      .includes(:content_item, :social_network)

    if params[:text].present?
      base_events = base_events
        .joins(content_item: :rich_text_body)
        .where("content_items.title ILIKE :text OR action_text_rich_texts.body ILIKE :text", { text: "%#{params[:text]}%" })
    end

    if params[:network].present?
      base_events = base_events
        .joins(:social_network)
        .where("social_networks.description = :network", { network: params[:network] })
    end

    @events = base_events
  end

  def show
    @content_item = ContentItem.find(params[:id])
  end

  def new
    @content_item = ContentItem.new
    @content_item.user = current_user
  end

  def create
    @content_item = ContentItem.new(content_item_params)
    @content_item.user = current_user

    if @content_item.save
      redirect_to content_items_path, notice: "#{@content_item.title} added"
    else
      render :new
    end
  end

  def edit
    @content_item = ContentItem.find(params[:id])
  end

  def update
    @content_item = ContentItem.find(params[:id])
    @content_item.assign_attributes(content_item_params)

    if @content_item.save
      redirect_to content_items_path, notice: "#{@content_item.title} updated"
    else
      render :edit
    end
  end

  def destroy
    @content_item = current_user.content_items.find(params[:id])
    @content_item.destroy

    redirect_to content_items_path, notice: "#{@content_item.title} deleted"
  end

  private

  def content_item_params
    content_params = params
      .require(:content_item)
      .permit(
        :title,
        :body,
        publishing_targets_attributes: [
          :social_network_id,
          publishing_date: %i[year month day hour minute]
        ]
    )

    parse_publishing_dates(content_params)
  end

  # Rejects unselected social networks and parses dates for each network
  def parse_publishing_dates(content_params)
    publishing_targets = content_params[:publishing_targets_attributes]
      .to_h
      .filter_map do |_, p_target|
        if p_target[:social_network_id].present?
          time_parts = p_target[:publishing_date].values_at(:year, :month, :day, :hour, :minute)
          date = Time.new(*time_parts)

          p_target.merge({ publishing_date: date })
        end
      end

    content_params.merge({ publishing_targets_attributes: publishing_targets })
  end
end
