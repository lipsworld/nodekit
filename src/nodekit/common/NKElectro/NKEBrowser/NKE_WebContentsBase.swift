/*
* nodekit.io
*
* Copyright (c) 2016 OffGrid Networks. All Rights Reserved.
* Portions Copyright (c) 2013 GitHub, Inc. under MIT License
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation
import WebKit

// MUST INHERIT
@objc class NKE_WebContentsBase: NSObject {
    internal weak var _window: NKE_BrowserWindow? = nil
    internal var _id : Int = 0
    internal var _type : String = ""
}

extension NKE_WebContentsBase: NKScriptPlugin {
    
    private static var loaded: Bool = false;
    
    static func attachTo(context: NKScriptContext) {
        let principal = NKE_WebContentsUI()
        context.NKloadPlugin(principal, namespace: "io.nodekit.WebContentsJSC", options: [String:AnyObject]());
        let principal2 = NKE_WebContentsWK()
        context.NKloadPlugin(principal2, namespace: "io.nodekit.WebContentsNitro", options: [String:AnyObject]());
    }
    
    func rewriteGeneratedStub(stub: String, forKey: String) -> String {
        switch (forKey) {
        case ".global":
            if (NKE_WebContentsBase.loaded) { return stub; }
            NKE_WebContentsBase.loaded = true;
            let url = NSBundle(forClass: NKEApp.self).pathForResource("web-contents", ofType: "js", inDirectory: "lib-electro")
            let appjs = try? NSString(contentsOfFile: url!, encoding: NSUTF8StringEncoding) as String
            return "function loadplugin(){\n" + appjs! + "\n}\n" + stub + "\n" + "loadplugin();" + "\n"
        default:
            return stub;
        }
    }
    
    class func scriptNameForSelector(selector: Selector) -> String? {
        return selector == Selector("initWithOptions:") ? "" : nil
    }
    
    internal class func NotImplemented(functionName: String = __FUNCTION__) -> Void {
        log("!WebContents.\(functionName) is not implemented");
    }
    
    internal func _getURLRequest(url: String, options: [String: AnyObject]) -> NSURLRequest {
        let httpReferrer = options["httpReferrer"] as? String
        let userAgent = options["userAgent"] as? String
        let extraHeaders = options["extraHeaders"] as? [String: AnyObject]
        
        let url = NSURL(string: url)!
        let request = NSMutableURLRequest(URL: url)
        
        if ((userAgent) != nil)
        {
            request.setValue(userAgent!, forHTTPHeaderField: "User-Agent")
        }
        
        if ((httpReferrer) != nil)
        {
            request.setValue(httpReferrer!, forHTTPHeaderField: "Referrer")
        }
        
        if ((extraHeaders != nil) && (!(extraHeaders!.isEmpty))) {
            for (key, value) in extraHeaders! {
                request.setValue(value as? String, forHTTPHeaderField: key)
            }
        }
        return request;
    }
}
