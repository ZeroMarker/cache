Class DHCEPRFS.Test.TestGetPDFCreateScheme Extends %RegisteredObject
{

/// d ##class(DHCEPRFS.Test.TestGetPDFCreateScheme).Test1()
ClassMethod Test1()
{
	s para = ^CacheTempDHCEPRDebug("GetPDFCreateScheme","Input")
	s p1 = $p(para,"^",1)
	s p2 = $p(para,"^",2)
	s p3 = $p(para,"^",3)
	s p4 = $p(para,"^",4)
	s p5 = $p(para,"^",5)
	s p6 = $p(para,"^",6)
	
	d ##class(DHCEPRFS.web.eprajax.GetPDFCreateScheme).GetPDFCreateSchemeJson(p1,p2,p3,p4,p5,p6)
}

}
