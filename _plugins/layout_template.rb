module Jekyll
  module Tags
    class Layout < Liquid::Block

      INCLUDES_VARIABLE_SYNTAX = %r!
       ({%\sinclude\s(?<variable>.*?.html))
       (?<params>.*[^\s%}])
      !x

      def initialize(tag_name, markup, tokens)
        super
        @attributes = {}

        markup.scan(Liquid::TagAttributes) do |key, value|
          @attributes[key] = value.gsub(/^'|"/, '').gsub(/'|"$/, '')
        end
      end

      # Renders nested includes component if it exists
      def render_variable(context)
        if @template.match(INCLUDES_VARIABLE_SYNTAX)
          partial = @site
                      .liquid_renderer
                      .file(@includes)
                      .parse(@includes_file)
          partial.render!(context)
        end
      end

      def render(context)
        @site = context.registers[:site]
        converter = @site.find_converter_instance(::Jekyll::Converters::Markdown)
        content = converter.convert(super(context))

        # Read layout template
        dir = File.join(@site.source, '_includes')
        file_system = Liquid::LocalFileSystem.new(dir, "%s.html")
        @template = file_system.read_template_file(@attributes['layout'])

        # Looks for includes tag within layout template
        matched = @template.strip.match(INCLUDES_VARIABLE_SYNTAX)
        if matched
          @includes = matched["variable"].strip
          @includes_stripped = @includes.gsub(".html", "")
          @includes_file = file_system.read_template_file(@includes_stripped)
        end

        file = render_variable(context)
        partial = Liquid::Template.parse(file)

        context.stack do
          begin
            context['include'] = partial
            context['content'] = content

            # Rendering custom params
            @attributes.each do |key, value|
              context[key] = value
            end

            template = Liquid::Template.parse(@template).render(context)
          end
        end
      end
    end
  end
end

Liquid::Template.register_tag('layout', Jekyll::Tags::Layout)
