RAILS_ENV = 'test'
require File.expand_path(File.join(File.dirname(__FILE__), "../../../../../config/boot"))
require(File.join(RAILS_ROOT, 'config', 'environment'))
require 'benchmark'

class Page
  tag 'slow_snippet' do |tag|
    if name = tag.attr['name']
      if snippet = Snippet.find_by_name(name.strip)
        tag.globals.page.render_snippet(snippet)
      else
        raise TagError.new('snippet not found')
      end
    else
      raise TagError.new("`snippet' tag must contain `name' attribute")
    end
  end
end

Snippet.delete_all

snippet_name = "test-snippet"
Snippet.create(:name => snippet_name, :content => "<r:title/>")
page = Page.new(:title => "Slow test page", :slug => "slow-test-page", :breadcrumb => "Slow test page", :status_id => 100)

Benchmark.bmbm do |b|
  num_snippet_calls = 300
  
  num_snippet_calls.times do |i|
    fast_string = %{<r:snippet name="#{snippet_name}"/>} * (i + 1)
    b.report("#{i + 1} fast snippets") {page.send(:parse, fast_string)}
  end
  
  num_snippet_calls.times do |i|
    slow_string = %{<r:slow_snippet name="#{snippet_name}"/>} * (i + 1)
    b.report("#{i + 1} slow snippets") {page.send(:parse, slow_string)}
  end

end

Page.delete_all
PagePart.delete_all
Snippet.delete_all
