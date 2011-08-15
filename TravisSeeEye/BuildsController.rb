class BuildsController
  
  attr_accessor :webView
    
  def showBuild(build)
    url = NSURL.URLWithString("http://travis-ci.org/#{build['slug']}/builds/#{build['last_build_id']}")
    requestObj = NSURLRequest.requestWithURL(url)
    @webView.mainFrame.loadRequest(requestObj)
  end

end