module PictureTag
  module Instructions
    # Builds instances of all source images.
    class SourceImages < Instruction
      def source
        {
          source_names: PictureTag.params.source_names,
          media_presets: PictureTag.params.media_presets
        }
      end

      def coerce
        sources = [PictureTag::SourceImage.new(source[:source_names].shift)]

        while source[:source_names].any?
          sources << PictureTag::SourceImage.new(
            source[:source_names].shift, source[:media_presets].shift
          )
        end

        sources
      end
    end

    # Which crop to use for a given media query. Can be given either in params
    # or preset.
    class Crop < ConditionalInstruction
      def source
        super.merge(
          { params: PictureTag.params.geometries }
        )
      end

      def coerce(media = nil)
        raise ArgumentError unless valid?

        source[:params][media] || value_hash[media]
      end

      def setting_basename
        'crop'
      end

      def setting_prefix
        'media'
      end

      def acceptable_types
        super + [String]
      end
    end

    # Which gravity to use for a given media query. Can be given either in
    # params or preset.
    class Gravity < ConditionalInstruction
      def source
        super.merge(
          { params: PictureTag.params.gravities }
        )
      end

      def coerce(media = nil)
        raise ArgumentError unless valid?

        source[:params][media] || super(media)
      end

      def setting_basename
        'gravity'
      end

      def setting_prefix
        'media'
      end

      def acceptable_types
        super + [String]
      end
    end
  end
end
