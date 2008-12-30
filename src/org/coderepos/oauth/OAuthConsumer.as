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

  import flash.events.*;
  import flash.utils.ByteArray;
  import org.httpclient.*;
  import org.httpclient.events.*;
  import org.coderepos.oauth.*;
  import org.coderepos.oauth.events.*;
  import org.coderepos.oauth.signaturemethods.*;
  import com.adobe.net.URI;
  import com.adobe.utils.StringUtil;
  /**
   * OAuth consumer agent class
   *
   * @example
   * <listing version="3.0">
   *
   * var consumer:OAuthConsumer = new OAuthConsumer('consumerKey', 'consumerSecret');
   * consumer.addEventListener(OAuthEvent.GET_REQUEST_TOKEN_COMPLETED, onCompletedToGetRequestToken);
   * consumer.addEventListener(OAuthEvent.GET_REQUEST_TOKEN_FAILED, onFailedToGetRequestToken);
   * consumer.getRequestToken(new URI("http://exmaple.org/request_token"));
   *
   * private function onCompletedToGetRequestToken(e:OAuthEvent):void {
   *   var requestToken:OAuthToken = e.result.token;
   *   myApp.saveRequestToken(requestToken);
   *   var authorizeURI:URI = new URI("http://example.org/authorize");
   *   authorizeURI.setQueryValue("token", requestToken.token);
   *   navigateToURL(authorizeURL);
   * }
   *
   * private function onFailedToGetRequestToken(e:OAuthEvent):void {
   *   showError("[" + String(e.result.code) + "] " + e.result.message);
   * }
   *
   * consumer.addEventListener(OAuthEvent.GET_ACCESS_TOKEN_COMPLETED, onCompletedToGetAccessToken);
   * consumer.addEventListener(OAuthEvent.GET_ACCESS_TOKEN_FAILED, onFailedToGetAccessToken);
   * var requestToken:OAuthToken = myApp.loadRequestToken();
   * consumer.getAccessToken(new URI("http://example.org/access_token"), requestToken);
   *
   * private function onCompletedToGetAccessToken(e:OAuthEvent):void {
   *   var accessToken:OAuthToken = e.result.token;
   *   myApp.saveAccessToken(accessToken);
   * }
   *
   * private function onFailedToGetAccessToken(e:OAuthEvent):void {
   *   showError("[" + String(e.result.code) + "] " + e.result.message);
   * }
   *
   * consumer.addEventListener(OAuthEvent.REQUEST_COMPLETED, onCompletedToRequest);
   * consumer.addEventListener(OAuthEvent.REQUEST_FAILED, onFailedToRequest);
   * consumer.request(new URI("http://example.org/resource"));
   *
   * private function onCompletedToRequest(e:OAuthEvent):void {
   *   var content:ByteArray = e.result.content;
   * }
   *
   * private function onFailedToRequest(e:OAuthEvent):void {
   *   showError("[" + String(e.result.code) + "] " + e.result.message);
   * }
   *
   *
   * </listing>
   */
  public class OAuthConsumer extends EventDispatcher {

    private var _consumerKey:String;
    private var _consumerSecret:String;
    private var _isFetching:Boolean;
    private var _signatureMethod:Class;
    private var _paramMethod:uint;
    private var _httpMethod:String;
    private var _realm:String;
    private var _agent:String;
    private var _timeout:int;
    private var _client:HttpClient;
  
    private var _lastRequest:OAuthRequest;
    private var _lastRequestURI:URI;
    private var _lastResponse:HttpResponse;
    private var _lastResponseBody:ByteArray;
    private var _lastRealm:String;
    private var _lastRequestToken:OAuthToken;
    private var _lastAccessToken:OAuthToken;

    /**
     * Constructor
     *
     * @param consumerKey
     * @param consumerSecret
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function OAuthConsumer(consumerKey:String='', consumerSecret:String='') {
      _consumerKey = consumerKey;
      _consumerSecret = consumerSecret;
      _isFetching = false;
      _paramMethod = OAuthParamMethod.AUTH_HEADER;
      _httpMethod = "POST";
      _signatureMethod = HMAC_SHA1;
      _agent = "as3oauth";
      _timeout = -1;
      clear();
    }

    /**
     * Clear last request and response.
     *
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function clear():void {
      _lastResponse = null;
      _lastResponseBody = new ByteArray();
      _lastRequest = null;
      _lastRequestURI = null;
      _lastRealm = null;
    }

    /**
     * Setter for httpMethod
     *
     * @param method
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function set httpMethod(method:String):void {
      _httpMethod = method.toUpperCase();
    }

    /**
     * Setter for paramMethod
     *
     * @param method
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function set paramMethod(method:uint):void {
      _paramMethod = method;
    }

    /**
     * Setter for signature method
     *
     * @param method OAuthSignatureMethod subclass
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function set signatureMethod(method:Class):void {
      _signatureMethod = method;
    }

    /**
     * Setter for realm
     *
     * @param realm
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function set realm(r:String):void {
      _realm = r;
    }

    /**
     * Initialize HttpClient object
     *
     * @param callback called when request is completed.
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    private function initializeHttpClient(onComplete:Function):void {
      _client = new HttpClient(); 
      _client.listener.onClose = onClose;
      _client.listener.onComplete = onComplete;
      _client.listener.onData = onData;
      _client.listener.onError = onError;
      _client.listener.onStatus = onStatus;
      _client.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
      _client.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
    }

    /**
     * Returns if the http client is fetching or not.
     *
     * @returns Boolean
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function get isFetching():Boolean {
      return _isFetching;
    }

    /**
     * Returns the OAuthRequest object used for last request.
     *
     * @returns request OAuthRequest object
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function get lastRequest():OAuthRequest {
      return _lastRequest;
    }

    /**
     * Returns the URI object used for last request.
     *
     * @returns uri URI object
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function get lastRequestURI():URI {
      return _lastRequestURI;
    }

    /**
     * Returns the HttpResponse object obtained by last request.
     *
     * @returns response HttpResponse object
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function get lastResponse():HttpResponse {
      return _lastResponse;
    }

    /**
     * Returns the ByteArray object obtained by last request.
     *
     * @returns body ByteArray object
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function get lastReponseBody():ByteArray {
      return _lastResponseBody;
    }

    /**
     * Returns the request token obtained by last request.
     *
     * @returns requestToken OAuthToken object
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function get lastRequestToken():OAuthToken {
      return _lastRequestToken;
    }

    /**
     * Returns the access token obtained by last request.
     *
     * @returns accessToken OAuthToken object
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function get lastAccessToken():OAuthToken {
      return _lastAccessToken;
    }

    private function onClose():void {
      _isFetching = false;
    }

    private function onData(e:HttpDataEvent):void {
      _lastResponseBody.writeBytes(e.bytes);
    }

    private function onError(e:Error):void {
      _isFetching = false;
      var result:OAuthEventResult = new OAuthEventResult();
      result.message = e.message;
      dispatchEvent(new OAuthEvent(OAuthEvent.TIMEOUT, result));
    }

    private function onIOError(e:IOErrorEvent):void {
      _isFetching = false;
      dispatchEvent(e.clone());
    }

    private function onSecurityError(e:SecurityErrorEvent):void {
      _isFetching = false;
      dispatchEvent(e.clone());
    }

    private function onStatus(res:HttpResponse):void {
      _lastResponse = res;
    }

    /**
     * Getter for agent name.
     *
     * @returns agentName
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function get agent():String {
      return _agent;
    }

    /**
     * Setter for agent name.
     *
     * @param agentName
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function set agent(a:String):void {
      _agent = a;
    }

    /**
     * Setter for timeout-seconds.
     *
     * @param seconds
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function set timeout(t:int):void {
      _timeout = t;
    }

    private function sendRequest(uri:URI, option:OAuthRequestOption=null):void {

      if (option == null)
        option = new OAuthRequestOption();

      var pMeth:uint = _paramMethod;
      var httpMeth:String = (option.httpMethod != null) ?
        option.httpMethod.toUpperCase() : _httpMethod;

      var realm:String = (option.realm != null) ? option.realm : _realm;
      if (realm == null) realm = findRealmFromLastResponse();
      if (realm == null) realm = '';

      var req:OAuthRequest = new OAuthRequest(httpMeth);

      if (httpMeth == "POST" || httpMeth == "PUT") {

        if (_paramMethod != OAuthParamMethod.POST_BODY)
          pMeth = OAuthParamMethod.AUTH_HEADER;

      } else {

        if (_paramMethod != OAuthParamMethod.URL_QUERY)
          pMeth = OAuthParamMethod.AUTH_HEADER;

      }

      var query:String;
      var content:ByteArray;
      var currentQuery:String;

      if (pMeth == OAuthParamMethod.URL_QUERY) {

        query = genOAuthQuery(req.method, uri, option.token, option.extraParams);
        currentQuery = uri.queryRaw;
        uri.queryRaw = (currentQuery.length > 0) ? currentQuery + '&' + query : query;

      } else if (pMeth == OAuthParamMethod.POST_BODY) {

        query = genOAuthQuery(req.method, uri, option.token, option.extraParams); 
        content = new ByteArray();
        content.writeUTFBytes(query);
        option.content = content;

      } else {

        var header:String = genOAuthHeader(req.method, uri, realm, option.token);
        req.addHeader("Authorization", header);

        if (option.extraParams != null) {

          var pairs:Array = new Array();
          for (var prop:String in option.extraParams) {
            var pair:String = OAuthUtil.encode(prop) + '=' + OAuthUtil.encode(option.extraParams[prop]);
            pairs.push(pair);
          }

          var data:String = pairs.join('join');

          if (httpMeth == "POST" || httpMeth == "PUT") {

            content = new ByteArray();
            content.writeUTFBytes(data);
            option.content = content;

          } else {

            currentQuery = uri.queryRaw;
            uri.queryRaw = (currentQuery.length > 0) ? currentQuery + '&' + data : data;

          }
        }
      }

      if (option.headers != null) {
        for (var headerName:String in option.headers)
          req.addHeader(headerName, option.headers[headerName]);
      }

      if (option.content != null)
        req.body = option.content;

      if (httpMeth == "POST" || httpMeth == "PUT") {
        var type:String = req.header.getValue("Content-Type");  
        if (type == null)
          req.addHeader("Content-Type", "application/x-www-form-urlencoded");
      }

      req.addHeader("User-Agent", _agent);
      _isFetching = true;
      _lastRequestURI = uri;
      _lastRequest = req;
      _client.request(uri, req, _timeout)
    }

    /**
     * Request protected-resource.
     *
     * @param uri protected resource uri
     * @param option OAuthRequestOption object
     * @eventType org.coderepos.oauth.events.OAuthEvent.REQUEST_COMPLETE
     * @eventType org.coderepos.oauth.events.OAuthEvent.REQUEST_FAILED
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function request(uri:URI, option:OAuthRequestOption=null):void {
      if (_isFetching) return;
      clear();
      initializeHttpClient(onCompletedToRequest);
      sendRequest(uri, option);
    }

    private function onCompletedToRequest():void {
      var code:uint = uint(_lastResponse.code);
      var result:OAuthEventResult = new OAuthEventResult();
      _isFetching = false;
      result.code = code;
      result.message = _lastResponse.message;
      if (code == 200) {
        _lastResponseBody.position = 0;
        var response:ByteArray = new ByteArray();
        response.readBytes(_lastResponseBody);
        result.content = response;
        dispatchEvent(new OAuthEvent(OAuthEvent.REQUEST_COMPLETED, result));
      } else {
        dispatchEvent(new OAuthEvent(OAuthEvent.REQUEST_FAILED, result));
      }
    }

    /**
     * Starts to get request token.
     *
     * @param uri request token uri
     * @param realm optional
     * @eventType org.coderepos.oauth.events.OAuthEvent.GET_REQUEST_TOKEN_COMPLETED
     * @eventType org.coderepos.oauth.events.OAuthEvent.GET_REQUEST_TOKEN_FAILED
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function getRequestToken(uri:URI, realm:String=null):void {
      if (_isFetching) return;
      clear();
      initializeHttpClient(onCompletedToGetRequestToken);
      var option:OAuthRequestOption = new OAuthRequestOption();
      option.realm = realm;
      sendRequest(uri, option);
    }

    private function onCompletedToGetRequestToken():void {
      var code:uint = uint(_lastResponse.code);
      var result:OAuthEventResult = new OAuthEventResult();
      _isFetching = false;
      result.code = code;
      result.message = _lastResponse.message;
      if (code == 200) {
        _lastResponseBody.position = 0;
        var response:String = _lastResponseBody.readUTFBytes(_lastResponseBody.bytesAvailable);
        var token:OAuthToken = OAuthToken.fromString(response);
        result.token = token;
        _lastRequestToken = token;
        dispatchEvent(new OAuthEvent(OAuthEvent.GET_REQUEST_TOKEN_COMPLETED, result));
      } else {
        dispatchEvent(new OAuthEvent(OAuthEvent.GET_REQUEST_TOKEN_FAILED, result));
      }
    }

    /**
     * Starts to get access token.
     *
     * @param uri request token uri
     * @param token request token
     * @param realm optional
     * @eventType org.coderepos.oauth.events.OAuthEvent.GET_ACCESS_TOKEN_COMPLETED
     * @eventType org.coderepos.oauth.events.OAuthEvent.GET_ACCESS_TOKEN_FAILED
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function getAccessToken(uri:URI, token:OAuthToken,
      realm:String=null):void {
      if (_isFetching) return;
      clear();
      initializeHttpClient(onCompletedToGetAccessToken);
      var option:OAuthRequestOption = new OAuthRequestOption();
      option.realm = realm;
      option.token = token;
      sendRequest(uri, option);
    }

    private function onCompletedToGetAccessToken():void {
      var code:uint = uint(_lastResponse.code);
      var result:OAuthEventResult = new OAuthEventResult();
      _isFetching = false;
      result.code = code;
      result.message = _lastResponse.message;
      if (code == 200) {
        _lastResponseBody.position = 0;
        var response:String = _lastResponseBody.readUTFBytes(_lastResponseBody.bytesAvailable);
        var token:OAuthToken = OAuthToken.fromString(response);
        result.token = token;
        _lastAccessToken = token;
        dispatchEvent(new OAuthEvent(OAuthEvent.GET_ACCESS_TOKEN_COMPLETED, result));
      } else {
        dispatchEvent(new OAuthEvent(OAuthEvent.GET_ACCESS_TOKEN_FAILED, result));
      }
    }

    /**
     * If the last response includes WWW-Authenticate header,
     * and it requires OAuth, get realm value from the header.
     *
     * @returns realm
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function findRealmFromLastResponse():String {
      if (_lastRealm != null)
        return _lastRealm;
      if (_lastResponse == null)
        return null;
      var authHeader:String = StringUtil.trim(_lastResponse.header.getValue("WWW-Authenticate"));
      if (authHeader && authHeader.match(/^\s*OAuth/)) return null;
      var params:Object = OAuthUtil.parseAuthHeader(authHeader);
      _lastRealm = params['realm'];
      return _lastRealm;
    }

    /**
     * Generate query-string that includes OAuth params,
     * this query-string is required in case the param-method URL_QUERY is choosed.
     * 
     * @param httpMethod
     * @param url
     * @param token
     * @param extraParams
     * @returns query query-string which includes oauth params.
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function genOAuthQuery(httpMethod:String, url:URI,
      token:OAuthToken=null, extraParams:Object=null):String {
      var params:Object = genOAuthParams(httpMethod, url, token);     
      var merged:Object = (extraParams == null) ? new Object() : extraParams;
      var prop:String;
      for (prop in params) {
        merged[prop] = params[prop];
      }
      var pairs:Array = new Array();
      for (prop in merged) {
        var pair:String = OAuthUtil.encode(prop) + '=' + OAuthUtil.encode(merged[prop]);
        pairs.push(pair);
      }
      pairs.sort();
      return pairs.join('&');
    }

    /**
     * Generate HTTP Authorization header for OAuth
     * 
     * @param httpMethod
     * @param url
     * @param realm
     * @param token
     * @returns header HTTP Authorization header for OAuth
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function genOAuthHeader(httpMethod:String, url:URI,
      realm:String='', token:OAuthToken=null):String {
      var params:Object = genOAuthParams(httpMethod, url, token);
      var header:String = OAuthUtil.buildAuthHeader(realm, params);
      return header;
    }

    /**
     * Generate object that includes each parameters OAuth spec requires.
     * 
     * @param httpMethod
     * @param url
     * @param token
     * @returns params
     * @langversion ActionScript 3.0
     * @playerversion 9.0
     */
    public function genOAuthParams(httpMethod:String, url:URI,
      token:OAuthToken=null):Object {
      var params:Object = new Object();
      params.oauth_consumer_key = _consumerKey;
      params.oauth_timestamp = Math.floor((new Date()).getTime() * 1000);
      params.oauth_nonce = OAuthUtil.getRandom(16);
      params.oauth_version = "1.0";
      if (token != null) {
        params.oauth_token = token.token;
      }
      var tokenSecret:String = (token != null) ? token.secret : '';
      var method:OAuthSignatureMethod = new _signatureMethod(_consumerSecret, tokenSecret);
      params.oauth_signature_method = method.methodName;
      var baseString:String = OAuthUtil.createSignatureBaseString(httpMethod, url, params);
      params.oauth_signature = method.sign(baseString);
      return params;
    }

  }

}

