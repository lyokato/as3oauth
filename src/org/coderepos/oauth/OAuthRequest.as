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
  import org.httpclient.HttpRequest;

  /**
   * HttpRequest wrapper class for OAuth
   */
  public class OAuthRequest extends HttpRequest {

    /**
     * Constructor
     *
     * @param httpMethod
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function OAuthRequest(method:String) {
      super(method);
      var empty:String = "";
      _body = new ByteArray();
      _body.writeUTFBytes(empty);
    }

    /**
     * Returns if this request should has body or not
     *
     * @returns Boolean
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    override public function get hasRequestBody():Boolean {
      return (_method == "POST" || _method == "PUT") ? true : false
    }

    /**
     * Returns if the response for this request should has body or not
     *
     * @returns Boolean
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    override public function get hasResponseBody():Boolean {
      return (_method == "HEAD") ? false : true;
    }

    /**
     * Setter for body data
     *
     * @param body
     * @langversion ActionScript 3.0
     * @playerversion 9.0
    public function set body(_data:ByteArray):void {
      _body = new ByteArray();
      _body.writeBytes(_data);
      addHeader("Content-Length", _body.length);
    }
     */
  }

}

