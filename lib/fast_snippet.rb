module FastSnippet
  include Radiant::Taggable
     
  class TagError < StandardError; end

  desc %{
    Renders the snippet specified in the @name@ attribute within the context of a page.
    
    *Usage:*
    <pre><code><r:snippet name="snippet_name" /></code></pre>
  }
  tag 'snippet' do |tag|
    if name = tag.attr['name']
      if snippet = snippet_cache(name.strip)
        tag.globals.page.render_snippet(snippet)
      else
        raise TagError.new('snippet not found')
      end
    else
      raise TagError.new("`snippet' tag must contain `name' attribute")
    end
  end
  
  private
  def snippet_cache(name)
    @snippet_cache ||= {}
    
    if snippet = @snippet_cache[name]
      # We've got what we need already; however, I'd rather not have a side-effect in an unless statement...
    else
      snippet = Snippet.find_by_name(name)
      @snippet_cache[name] = snippet
    end
    snippet
  end
end