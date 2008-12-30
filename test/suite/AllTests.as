package suite {
  
  import flexunit.framework.TestSuite;  
  
  public class AllTests extends TestSuite {
    
    public function AllTests() {
      super();
      // Add tests here
      // For examples, see: http://code.google.com/p/as3flexunitlib/wiki/Resources
      addTest( OAuthUtilTest.suite()            );
      addTest( OAuthTokenTest.suite()           );
      addTest( OAuthSignatureMethodTest.suite() );
      addTest( OAuthRequestTest.suite()         );
      addTest( OAuthConsumerTest.suite()        );
      addTest( OAuthTermieTest.suite()          );
    }
    
  }
  
}

