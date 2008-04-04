class FastSnippetExtension < Radiant::Extension
  version "1.0"
  description "Makes <r:snippet> go faster (in some cases)"
  url "http://github.com/AndrewO/fast_snippet/tree/master"
  
  def activate
    Page.class_eval {
      include FastSnippet
    }
  end
  
  def deactivate
  end
  
end