package suite {

  import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
  import org.coderepos.oauth.*;
  import org.coderepos.oauth.signaturemethods.*;

  public class OAuthSignatureMethodTest extends TestCase {

    public function OAuthSignatureMethodTest(method:String) {
      super(method);
    }

    public static function suite():TestSuite {
      var ts:TestSuite = new TestSuite();
      ts.addTest( new OAuthSignatureMethodTest("testPlainText") );
      ts.addTest( new OAuthSignatureMethodTest("testHmacSha1") );
      // ts.addTest( new OAuthSignatureMethodTest("testRsaSha1") );
      return ts;
    }

    public function testPlainText():void {
      var baseString:String = "hogehogehoge";
      var signer:OAuthSignatureMethod = new PLAINTEXT('foo', 'bar');
      var signature:String = signer.sign(baseString);
      assertEquals("foo&bar", signature);

      var verifier:OAuthSignatureMethod = new PLAINTEXT('foo', 'bar');
      var invalidVerifier:OAuthSignatureMethod = new PLAINTEXT('foo', 'invalid');
      assertTrue(verifier.verify(baseString, signature));
      assertFalse(invalidVerifier.verify(baseString, signature));

      var signer2:OAuthSignatureMethod = new PLAINTEXT('foo');
      var signature2:String = signer2.sign(baseString);
      assertEquals("foo&", signature2);

      var verifier2:OAuthSignatureMethod = new PLAINTEXT('foo');
      assertTrue(verifier2.verify(baseString, signature2));
      assertFalse(invalidVerifier.verify(baseString, signature2));
    }

    public function testHmacSha1():void {
      var baseString:String = "hogehogehoge";
      var signer:OAuthSignatureMethod = new HMAC_SHA1('foo', 'bar');
      var signature:String = signer.sign(baseString);
      assertEquals('TdSY8Tl5G/ihzaO8aRnIIdc7Wkc=', signature);

      var verifier:OAuthSignatureMethod = new HMAC_SHA1('foo', 'bar');
      var invalidVerifier:OAuthSignatureMethod = new HMAC_SHA1('foo', 'invalid');
      assertTrue(verifier.verify(baseString, signature));
      assertFalse(invalidVerifier.verify(baseString, signature));

      var signer2:OAuthSignatureMethod = new HMAC_SHA1('foo');
      var signature2:String = signer2.sign(baseString);
      assertEquals('ietxdwnHDniD+idyuFYk7MVQxHY=', signature2);

      var verifier2:OAuthSignatureMethod = new HMAC_SHA1('foo');
      assertTrue(verifier2.verify(baseString, signature2));
      assertFalse(invalidVerifier.verify(baseString, signature2));
    }

    /*
    public function testRsaSha1():void {
      var publicKey:String = "-----BEGIN RSA PUBLIC KEY-----\n"
        + "MIGJAoGBAN4jFZ1OxLALdJcirP0eQ0ydoZ8Dc3yc/UfWMRP5Jc3rN0zwKSelZkog\n"
        + "I/cDdg/aXuZwdHFwwI2rfqrptkughT3pPJqmMx8zAx1nx9CRpjhLfoFbem+wa9hc\n"
        + "TXHlr9JvRoRAAnbdjvHE5DT+niQzp2E/H9B4a9N3thDitC/VTSFXAgMBAAE=\n"
        + "-----END RSA PUBLIC KEY-----\n";

      var privateKey:String = "-----BEGIN RSA PRIVATE KEY-----\n"
       + "MIICWwIBAAKBgQDeIxWdTsSwC3SXIqz9HkNMnaGfA3N8nP1H1jET+SXN6zdM8Ckn\n"
       + "pWZKICP3A3YP2l7mcHRxcMCNq36q6bZLoIU96TyapjMfMwMdZ8fQkaY4S36BW3pv\n"
       + "sGvYXE1x5a/Sb0aEQAJ23Y7xxOQ0/p4kM6dhPx/QeGvTd7YQ4rQv1U0hVwIDAQAB\n"
       + "AoGAQHpwmLO3dd4tXn1LN0GkiUWsFyr6R66N+l8a6dBE/+uJpsSDPaXN9jA0IEwZ\n"
       + "5eod58e2lQMEcVrZLqUeK/+RDOfVlZSVcPY0eBG+u+rxmUwPVqh9ghsC7JfdmQA6\n"
       + "cQ14Rf/Rmlm7N3+tF83CrlBnwaNEhvHk6cJrMSSyKRF5xFECQQD7rd23/SsWqLOP\n"
       + "uSSy9jkdSKadsDDbJ0pHgOaRSJ3WNgJbEwLdSu6AQwy6vB0Ell4p9ixJD4MbCW46\n"
       + "IBrPyKapAkEA4fNhWcaBawvVAJf33jyHdGVExkQUpo6JHkitU06g5Af++sFRo8rT\n"
       + "aj+ZImGFvGwGGMfNoMt9d3ttdoNKW6yH/wJARoHW84yBXb+1TjZYCarhJUsNInAR\n"
       + "v9OqA44hCeKGFVTcJBeXXdd4KYafMlEw7/AQQUEt9unZmOFzd+U2na9gwQJAXYPR\n"
       + "YsqZfahj+97po30Bwta25CgBM/4CGhqSQcxlInt8uGOSWmvznCG+S1B5fUZoL5Fi\n"
       + "NY6C2xSmdUpZWB/MGQJAVxI4gD+kYTYvqPqU7UEu+d68aMttqJeZUbIYd4ydMWFB\n"
       + "CHT/dnHG/dX4b8GOOTFz1y9r2x3Org43CQOZvDy/HA==\n"
       + "-----END RSA PRIVATE KEY-----\n";

      var invalidPublicKey:String = "-----BEGIN RSA PUBLIC KEY-----\n"
      + "MIGJAoGBAMmsdxC0oP3E7yD9PX5vxUblyBEhUY9brNhJbJS55+8rxjBdo7iImoSd\n"
      + "lRxOVeest+mBRKqPrEgKYpsjiduIT0MiqHFdGR7DhYGtV1Sgn75+WoLj/S9t58wg\n"
      + "a5eBaoJl/UzNBxENLgWoI3TtdYiZoXFysMjqsFIqQKFo/fLCyZ3pAgMBAAE=\n"
      + "-----END RSA PUBLIC KEY-----\n";

      var baseString:String = "hogehogehoge";
      var signer:OAuthSignatureMethod = new RSA_SHA1(privateKey);
      var signature:String = signer.sign(baseString);
      assertEquals('rNZSaVtKK3Gkp6T9AwolAyMIng5xVr3TOYrTGGR8zAbUv4T4+oUQYecXf9dOBg0xrvNkkjKqJJda\nyFLYdqmK1d7JfGDzS5hzK65q2XghJjU7xlbgQQXKz0YPvk9KHSI9oO5XqlJPIGkrBNTRBn+iHeh8\npoNt4wYRZ/lICtjI/9I=', signature);

      var verifier:OAuthSignatureMethod = new RSA_SHA1(publicKey);
      var invalidVerifier:OAuthSignatureMethod = new RSA_SHA1(invalidPublicKey);

      assertTrue(verifier.verify(baseString, signature));
      assertFalse(invalidVerifier.verify(baseString, signature));
    }
    */

  }

}

