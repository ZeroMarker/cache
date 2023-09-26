Class DHCEPRFS.Test.TestSrvPlatform Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "TestSrvPlatform";

/// debug: w ##class(DHCEPRFS.Test.TestSrvPlatform).GetXML()
ClassMethod GetXML(AInput As %String) As %String [ WebMethod ]
{
 	s ret ="<Request>"
	s ret = ret_"<Header>"
	s ret = ret_"<SourceSystem>EMR</SourceSystem>"
 	s ret = ret_"<MessageID>M0012020484检查</MessageID>"
	s ret = ret_"</Header>"
	s ret = ret_"<Body>"
    s ret = ret_"<RegisterDocumentRt>"
    s ret = ret_"<OrganizationCode>600012</OrganizationCode>"
    s ret = ret_"<PATPatientID>M001202048</PATPatientID>"
    s ret = ret_"<PAADMVisitNumber>M001202048|4</PAADMVisitNumber>"
    s ret = ret_"<DocumentType>EMR001</DocumentType>"
    s ret = ret_"<DocumentID>M00120204841检查1</DocumentID>"
    s ret = ret_"<DocumentContent>6Zmi55eF5qGI6aaW6aG15Lit5Y+v5LiN5aGr5YaZ4oCc5L2P6Zmi6LS555So4oCd44CCPC90ZXh0PjwvQ0RSPg==</DocumentContent>"
    s ret = ret_"<DocumentPath>ftp://ftptest:ftptest@127.0.0.1:2121/2017-08-18/1.pdf</DocumentPath>"
    s ret = ret_"<UpdateUserCode>JHEMR</UpdateUserCode>"
    s ret = ret_"<UpdateDate>2017-08-16</UpdateDate>"
    s ret = ret_"<UpdateTime>04:28:20</UpdateTime>"
    s ret = ret_"</RegisterDocumentRt>"
    s ret = ret_"<RegisterDocumentRt>"
    s ret = ret_"<OrganizationCode>600012</OrganizationCode>"
    s ret = ret_"<PATPatientID>M001202048</PATPatientID>"
    s ret = ret_"<PAADMVisitNumber>M001202048|4</PAADMVisitNumber>"
    s ret = ret_"<DocumentType>EMR001</DocumentType>"
    s ret = ret_"<DocumentID>M00120204842检查2</DocumentID>"
    s ret = ret_"<DocumentContent>6Zmi55eF5qGI6aaW6aG15Lit5Y+v5LiN5aGr5YaZ4oCc5L2P6Zmi6LS555So4oCd44CCPC90ZXh0PjwvQ0RSPg==</DocumentContent>"
    s ret = ret_"<DocumentPath>ftp://ftptest:ftptest@127.0.0.1:2121/2017-08-18/2.pdf</DocumentPath>"
    s ret = ret_"<UpdateUserCode>JHEMR</UpdateUserCode>"
    s ret = ret_"<UpdateDate>2017-08-16</UpdateDate>"
    s ret = ret_"<UpdateTime>04:28:20</UpdateTime>"
    s ret = ret_"</RegisterDocumentRt>"
    s ret = ret_"<RegisterDocumentRt>"
    s ret = ret_"<OrganizationCode>600012</OrganizationCode>"
    s ret = ret_"<PATPatientID>M001202048</PATPatientID>"
    s ret = ret_"<PAADMVisitNumber>M001202048|4</PAADMVisitNumber>"
    s ret = ret_"<DocumentType>EMR001</DocumentType>"
    s ret = ret_"<DocumentID>M00120204843检查3</DocumentID>"
    s ret = ret_"<DocumentContent>6Zmi55eF5qGI6aaW6aG15Lit5Y+v5LiN5aGr5YaZ4oCc5L2P6Zmi6LS555So4oCd44CCPC90ZXh0PjwvQ0RSPg==</DocumentContent>"
    s ret = ret_"<DocumentPath>ftp://ftptest:ftptest@127.0.0.1:2121/2017-08-18/3.pdf</DocumentPath>"
    s ret = ret_"<UpdateUserCode>JHEMR</UpdateUserCode>"
    s ret = ret_"<UpdateDate>2017-08-16</UpdateDate>"
    s ret = ret_"<UpdateTime>04:28:20</UpdateTime>"
    s ret = ret_"</RegisterDocumentRt>"
    s ret = ret_"<RegisterDocumentRt>"
    s ret = ret_"<OrganizationCode>600012</OrganizationCode>"
    s ret = ret_"<PATPatientID>M001202048</PATPatientID>"
    s ret = ret_"<PAADMVisitNumber>M001202048|4</PAADMVisitNumber>"
    s ret = ret_"<DocumentType>EMR001</DocumentType>"
   	s ret = ret_"<DocumentID>M00120204844检查4</DocumentID>"
    s ret = ret_"<DocumentContent>6Zmi55eF5qGI6aaW6aG15Lit5Y+v5LiN5aGr5YaZ4oCc5L2P6Zmi6LS555So4oCd44CCPC90ZXh0PjwvQ0RSPg==</DocumentContent>"
    s ret = ret_"<DocumentPath>ftp://ftptest:ftptest@127.0.0.1:2121/2017-08-18/4.pdf</DocumentPath>"
    s ret = ret_"<UpdateUserCode>JHEMR</UpdateUserCode>"
    s ret = ret_"<UpdateDate>2017-08-16</UpdateDate>"
    s ret = ret_"<UpdateTime>04:28:20</UpdateTime>"
    s ret = ret_"</RegisterDocumentRt>"
    s ret = ret_"<RegisterDocumentRt>"
    s ret = ret_"<OrganizationCode>600012</OrganizationCode>"
    s ret = ret_"<PATPatientID>M001202048</PATPatientID>"
    s ret = ret_"<PAADMVisitNumber>M001202048|4</PAADMVisitNumber>"
    s ret = ret_"<DocumentType>EMR001</DocumentType>"
    s ret = ret_"<DocumentID>M00120204845检查5</DocumentID>"
    s ret = ret_"<DocumentContent>6Zmi55eF5qGI6aaW6aG15Lit5Y+v5LiN5aGr5YaZ4oCc5L2P6Zmi6LS555So4oCd44CCPC90ZXh0PjwvQ0RSPg==</DocumentContent>"
    s ret = ret_"<DocumentPath>ftp://ftptest:ftptest@127.0.0.1:2121/2017-08-18/5.pdf</DocumentPath>"
    s ret = ret_"<UpdateUserCode>JHEMR</UpdateUserCode>"
    s ret = ret_"<UpdateDate>2017-08-16</UpdateDate>"
    s ret = ret_"<UpdateTime>04:28:20</UpdateTime>"
    s ret = ret_"</RegisterDocumentRt>"
    s ret = ret_"</Body>"
    s ret = ret_"</Request>"
    
    q ret
}

}
