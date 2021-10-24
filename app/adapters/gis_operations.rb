module GisOperations
  # More at https://en.wikipedia.org/wiki/Spatial_reference_system
  APPLICATION_SRID = 4326

  def self.factory
    RGeo::Geographic.spherical_factory(srid: APPLICATION_SRID)
  end

  def self.to_rgeo_point(lat, lon)
    factory.point(lon, lat)
  end

  def self.hash_to_point(coords_hash)
    return unless coords_hash.is_a?(Hash)

    coords = coords_hash.symbolize_keys
    return if coords[:lat].blank? || (coords[:lng].blank? && coords[:lon])

    to_rgeo_point(coords[:lat], (coords[:lng] || coords[:lon]))
  end

  # @param a [RGeo::Geographic::SphericalPointImpl] Точка А
  # @param b [RGeo::Geographic::SphericalPointImpl] Точка Б
  # @return [Float] Расстояние между точками, в метрах
  def self.distance_between_points(a:, b:)
    a.distance(b)
  end

  # @ param arr [Array] Array of points
  def self.track_distance(arr)
    linestring = factory.line_string(arr)
    linestring.length
  end

  # Outputs the direction of second point relative to the first point
  # @param a [RGeo::Geographic::SphericalPointImpl] Точка А
  # @param b [RGeo::Geographic::SphericalPointImpl] Точка Б
  # @return [String] ('N'|'S'|'W'|'E')
  def self.direction_of_point(a:, b:)
    x = b.coords.x - a.coords.x
    y = b.coords.y - a.coords.y
    atan = Math.atan2(x, y)
    if -0.7853981633974483 <= atan && 0.7853981633974483 >= atan
      return 'N'
    elsif 0.7853981633974483 <= atan && 2.356194490192345 >= atan
      return 'E'
    elsif -2.356194490192345 <= atan && -0.7853981633974483 >= atan
      return 'W'
    else
      return 'S'
    end
  end
end
