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

  import flash.events.*;

  /**
   * Class represents events that is dispatched around processes on OAuth.
   */
  public class OAuthEvent extends Event {
    /**
     * Event type that is for an event dispatched when consumer completes request successfully.
     */
    public static const REQUEST_COMPLETED:String = "requestCompleted";
    /**
     * Event type that is for an event dispatched when consumer fails request.
     */
    public static const REQUEST_FAILED:String = "requestFailed";
    /**
     * Event type that is for an event dispatched when consumer completes to get request token successfully.
     */
    public static const GET_REQUEST_TOKEN_COMPLETED:String = "getRequestTokenCompleted";
    /**
     * Event type that is for an event dispatched when consumer fails to get request token successfully.
     */
    public static const GET_REQUEST_TOKEN_FAILED:String = "getRequestTokenFailed";
    /**
     * Event type that is for an event dispatched when consumer completes to get access token successfully.
     */
    public static const GET_ACCESS_TOKEN_COMPLETED:String = "getAccessTokenCompleted";
    /**
     * Event type that is for an event dispatched when consumer fails to get access token.
     */
    public static const GET_ACCESS_TOKEN_FAILED:String = "getAccessTokenFailed";
    /**
     * Event type that is for an event dispatched when consumer's request goes tim eout.
     */
    public static const TIMEOUT:String = "timeout";

    private var _result:OAuthEventResult;

    /**
     * Constructor
     *
     * @param tyep event type
     * @param result OAuthEventResult object
     * @param bubbles use bubbling
     * @param cancelable use cancel
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function OAuthEvent(type:String, result:OAuthEventResult=null, bubbles:Boolean=false, cancelable:Boolean=false) {
      super(type, bubbles, cancelable);
      _result = result;
    }

    /**
     * Returns the result object that is made by dispatcher.
     *
     * @returns OAuthEventResult object
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function get result():OAuthEventResult {
      return _result;
    }

  }

}

