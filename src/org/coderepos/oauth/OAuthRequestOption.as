/*
Copyright (c) Lyo Kato (lyo.kato _at_ gmail.com)

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
*/

package org.coderepos.oauth {

  import flash.utils.ByteArray;

  /**
   * Class represents request-options
   */
  public class OAuthRequestOption {
    /**
     * realm
     */
    public var realm:String;
    /**
     * token
     */
    public var token:OAuthToken;
    /**
     * extra parameters as an Object
     */
    public var extraParams:Object;
    /**
     * oauth parameters as an Object
     */
    public var oauthParams:Object;
    /**
     * HTTP headers as an Object
     */
    public var headers:Object;
    /**
     * httpMethod(GET, POST, PUT, DELETE, HEAD)
     */
    public var httpMethod:String;
    /**
     * request body for POST or PUT request
     */
    public var content:ByteArray;

    /**
     * Constructor
     *
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function OAuthRequestOption() { }

    public function getAllParams():Object {
        var obj:Object = new Object();
        var prop:String;
        if (extraParams != null) {
            for (prop in extraParams) {
                obj[prop] = extraParams[prop];
            }
        }
        if (oauthParams != null) {
            for (prop in oauthParams) {
                obj[prop] = oauthParams[prop];
            }
        }
        return obj;
    }
  }
}

