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

package org.coderepos.oauth
{
    public class OAuthResponse
    {
        public static function fromString(encoded:String):OAuthResponse
        {
            var pairs:Array = encoded.split(/&/);
            var response:OAuthResponse = new OAuthResponse();
            var token:OAuthToken = new OAuthToken();
            for(var i:uint=0; i < pairs.length; i++) {
                var pair:Array = pairs[i].split(/=/);
                if (pair.length == 2) {
                    var key:String   = pair[0];
                    var value:String = OAuthUtil.decode(pair[1]);
                    if (key == "oauth_token")
                        token.token = pair[1];
                    else if (key == "oauth_token_secret")
                        token.secret = pair[1];
                    else
                        response.setParam(key, OAuthUtil.decode(pair[1]));
                }
            }
            response.token = token;
            return response;
        }

        public var token:OAuthToken;
        public var _params:Object;

        public function OAuthResponse()
        {
            _params = {};
        }

        public function hasParam(key:String):Boolean
        {
            return (key in _params);
        }

        public function getParam(key:String):String
        {
            return (key in _params) ? _params[key] : null;
        }

        public function setParam(key:String, value:String):void
        {
            _params[key] = value;
        }
    }
}
