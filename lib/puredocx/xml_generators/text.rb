require 'cgi'

module PureDocx
  module XmlGenerators
    class Text < Base
      DEFAULT_TEXT_SIZE  = 28
      DEFAULT_TEXT_ALIGN = 'left'.freeze
      attr_reader :bold_enable, :italic_enable, :align, :size, :underline_enable,
        :list_level, :list_type, :list_num_id

      def initialize(content, rels_constructor, arguments = {})
        super(nil, rels_constructor)
        @content          = CGI.escapeHTML(content)
        @bold_enable      = [*arguments[:style]].include?(:bold)
        @italic_enable    = [*arguments[:style]].include?(:italic)
        @underline_enable = [*arguments[:style]].include?(:underline) ? 'single' : ''
        @list_type        = arguments.has_key?(:list_level) ? 'ListParagraph' : ''
        @list_level       = arguments.has_key?(:list_level) ? arguments[:list_level] : ''
        @list_num_id      = arguments.has_key?(:list_level) ? '2' : ''
        @align            = arguments[:align] || DEFAULT_TEXT_ALIGN
        @size             = arguments[:size]  || DEFAULT_TEXT_SIZE
      end

      def params
        {
          '{TEXT}'             => content,
          '{ALIGN}'            => align,
          '{BOLD_ENABLE}'      => bold_enable,
          '{ITALIC_ENABLE}'    => italic_enable,
          '{UNDERLINE_ENABLE}' => underline_enable,
          '{LIST_TYPE}'        => list_type,
          '{LIST_LEVEL}'       => list_level,
          '{LIST_NUM_ID}'      => list_num_id,
          '{SIZE}'             => size
        }
      end

      def template
        File.read(DocArchive.template_path('paragraph.xml'))
      end
    end
  end
end
