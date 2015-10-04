class KaminariResourceCollection < Kaminari::PaginatableArray
  def initialize(collection)
    super collection,
      limit: collection.http_response['X-limit'].to_i,
      offset: collection.http_response['X-offset'].to_i,
      total_count: collection.http_response['X-total'].to_i
  end
end