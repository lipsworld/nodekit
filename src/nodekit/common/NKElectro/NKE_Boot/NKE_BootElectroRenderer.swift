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

class NKE_BootElectroRenderer: NSObject {
    
    static func bootTo(context: NKScriptContext) {
        let url = NSBundle(forClass: NKE_BootElectroRenderer.self).pathForResource("_nke_renderer", ofType: "js", inDirectory: "lib-electro")
        let appjs = try? NSString(contentsOfFile: url!, encoding: NSUTF8StringEncoding) as String
        let script = "function loadbootstrap(){\n" + appjs! + "\n}\n" + "loadbootstrap();" + "\n"
        let item = context.NKinjectJavaScript(NKScriptSource(source: script, asFilename: "io.nodekit.electro/lib-electro/_nke_renderer.js", namespace: "io.nodekit.electro.renderer"))
        
        objc_setAssociatedObject(context, unsafeAddressOf(NKE_BootElectroRenderer), item, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        NKE_IpcRenderer.attachTo(context);
        
        let script2Source = "io.nodekit.electro.ipcRenderer.on('channel', function(msg){console.log(msg);}); ";
        let script2 = context.NKinjectJavaScript(NKScriptSource(source: script2Source, asFilename: "startup.js"))
        objc_setAssociatedObject(context, unsafeAddressOf(HelloWorldTest), script2, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        

    }
}