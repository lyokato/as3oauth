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

package org.coderepos.oauth.events {

  import org.coderepos.oauth.OAuthResponse;
  import flash.utils.ByteArray;

  /**
   * Class represents object that includes various data passed from dispatcher.
   */
  public class OAuthEventResult {

    /**
     * HTTP status code
     */
    public var code:uint;
    /**
     * HTTP status message
     */
    public var message:String;
    /**
     * Request/Access response
     */
    public var response:OAuthResponse;
    /**
     * response body
     */
    public var content:ByteArray;

    /**
     * Constructor
     *
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function OAuthEventResult() { }

  }

}

