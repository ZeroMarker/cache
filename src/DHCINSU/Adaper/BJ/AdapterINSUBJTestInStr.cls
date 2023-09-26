Import SQLUser

Class DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr Extends %RegisteredObject [ LegacyInstanceContext ]
{

/// w ##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStringForPersonOutput("D:\ReadCard.xml")
ClassMethod XMLToStringForPersonOutput(FileName As %String)
{
	q ##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStrForOutput(FileName,"DHCINSU.Model.BJ.INSUCardInfo","output")
}

/// w ##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStringForDivideInput("D:\DivideIn.xml")
ClassMethod XMLToStringForDivideInput(FileName As %String)
{
	q ##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStrForOutput(FileName,"DHCINSU.Model.BJ.INSUDivideInput","input")
}

/// w ##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStringForDivideOutput("D:\DivideOut.xml")
ClassMethod XMLToStringForDivideOutput(FileName As %String)
{
	q ##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStrForOutput(FileName,"DHCINSU.Model.BJ.INSUDivideOutput","output")
}

/// w ##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStringForTradeOutput("D:\TradeOut.xml")
ClassMethod XMLToStringForTradeOutput(FileName As %String)
{
	q ##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStrForOutput(FileName,"DHCINSU.Model.BJ.INSUTradeOutput","output")
}

/// w ##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStringForDivideOutput("D:\RefundmentDivideOut.xml")
ClassMethod XMLToStringForRefundmentDivideOutput(FileName As %String)
{
	q ##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStrForOutput(FileName,"DHCINSU.Model.BJ.INSURefundmentDivideOutput","output")
}

/// w ##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).XMLToStrForOutput("D:\InsuOPRegPersonInfo.Xml","DHCINSU.Model.BJ.INSUCardInfo","output")
ClassMethod XMLToStrForOutput(FileName As %String, ByRef ClassName As %String, XMLNode As %String)
{
	
	q:($g(FileName)="")
	q:($g(ClassName)="")
	q:($g(XMLNode)="")
	if ClassName="DHCINSU.Model.BJ.INSUCardInfo" d
	.s object=##class(DHCINSU.Model.BJ.INSUCardInfo).%New()
	if ClassName="DHCINSU.Model.BJ.INSUDivideOutput" d
	.s object=##class(DHCINSU.Model.BJ.INSUDivideOutput).%New()
	if ClassName="DHCINSU.Model.BJ.INSUTradeOutput" d
	.s object=##class(DHCINSU.Model.BJ.INSUTradeOutput).%New()
	if ClassName="DHCINSU.Model.BJ.INSUDivideInput" d
	.s object=##class(DHCINSU.Model.BJ.INSUDivideInput).%New()
	if ClassName="DHCINSU.Model.BJ.INSURefundmentDivideOutput" d
	.s object=##class(DHCINSU.Model.BJ.INSUDivideOutput).%New()
	
	

	

	s ExistsFlag=##Class(%File).Exists(FileName)
	i ExistsFlag'=1  d
	.w "Error: "_FileName_"  does not exist !"
	q:ExistsFlag'=1  d
	s reader = ##class(%XML.Reader).%New()
	s stream=##class(%FileCharacterStream).%New()
	s stream.Filename=FileName
	
	s sc=reader.OpenStream(stream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	
	
	//可以获取Object的类名
	//和其他信息
	//##this   来替换
	;n myClassName, myNode
	//s myClassName=%this_""
	//s myClassName=$P(myClassName,"@",2)
	s myClassName=object.%ClassName(1)
	s myNode=$g(XMLNode) 			;$p(myClassName,".",mylen)
	// Associate a class name with the XML element name
	Do reader.Correlate(myNode, myClassName)
	
	;n myDesobj
	// read Sample.Person objects from xml file
	Set Count=0
	if reader.Next(.myDesobj,.sc) {
	    Set Count=Count+1
	    s object=myDesobj
	    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	}
	
	if ($ISOBJECT(myDesobj)){
		d myDesobj.%Close()
		s myDesobj=""
	}

	d object.RepairPropertyValue(object)
	Set OutputXML=""
   	Do object.XMLExportToString(.OutputXML,XMLNode)
	q OutputXML
}

/// s a=##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).test("")
ClassMethod test(InputXml As %String) As %String
{
    s Input="<input><tradeinfo><curetype>17</curetype><illtype>0</illtype><feeno>201603021318105</feeno><operator>cashier</operator></tradeinfo><recipearray><recipe><diagnoseno>1</diagnoseno><recipeno>1</recipeno><recipedate>20160302131810</recipedate><diagnosename></diagnosename><diagnosecode></diagnosecode><medicalrecord></medicalrecord><sectioncode>0401</sectioncode><sectionname>普通外科专业</sectionname><hissectionname>PTWKMZ-普通外科门诊</hissectionname><drid></drid><drname></drname><recipetype>1</recipetype><drlevel></drlevel><registertradeno></registertradeno><billstype>1</billstype></recipe></recipearray></input>"
	Set InputObj=##class(DHCINSU.Model.BJ.INSUDivideInput).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"input",Input)
	
    w "InputObj.tradeinfo.feeno="_InputObj.tradeinfo.feeno,!
    q 0
}

/*

/// Creator：      朱平宣
/// CreatDate：    2015-10-13
/// Description:   
/// Input：        XML string
/// Output：       
/// Return：       成功返回 0
/// Others：
/// w ##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).Test1("<detail><yylsh>1111</yylsh><fphm>2222</fphm><ryxm>3333</ryxm><czy>4444</czy></detail>") 
ClassMethod Test1(Input As %String) As %String
{
	;<detail><yylsh>1111</yylsh><fphm>2222</fphm><ryxm>3333</ryxm><czy>4444</czy></detail>
	Set reader=##class(%XML.Reader).%New()
	;Set sc=reader.OpenStream(Input)		;打开数据流	
	Set sc=reader.OpenString(Input)		;打开string串
	Do reader.Correlate("detail","web.NXInsuRecipeLockDetail")		;根节点，实体类
	s Mainobj=##class(web.NXInsuRecipeLockDetail).%New()	;new实体类对象
	While reader.Next(.obj,.sc) {	;解析XML
		s Mainobj=obj
		;b ;1
	}
	w !,"Mainobj.yylsh:"_Mainobj.yylsh,!
	w !,"Mainobj.fphm:"_Mainobj.fphm,!
	;q Mainobj
	q 0 ;Mainobj.czy
}

/// w ##class(DHCINSU.Adaper.BJ.AdapterINSUBJTestInStr).testFeeitem("")
ClassMethod testFeeitem(InputXml As %String)
{
	//Set InputXml="<input><feeitem itemno=1 recipeno=1 hiscode=w0101010403 itemname=特约门诊挂号费(副主任医师) itemtype=1 unitprice=3 count=1 fee=3 dose= specification= unit= howtouse= dosage= packaging= minpackage= conversion= days=/></input>"
	Set InputXml="<feeitem itemno=1></feeitem>"
	//Set InputObj=##class(DHCINSU.Model.BJ.INSUFeeitem).%New()
	//Do InputObj.XMLNodeDeserialize(.InputObj, "feeitem", InputXml)
	Set reader=##class(%XML.Reader).%New()
	;Set sc=reader.OpenStream(Input)		;打开数据流	
	Set sc=reader.OpenString(InputXml)		;打开string串
	
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	Do reader.Correlate("feeitem","DHCINSU.Model.BJ.INSUFeeitem")		;根节点，实体类
	s Mainobj=##class(DHCINSU.Model.BJ.INSUFeeitem).%New()	;new实体类对象
	w sc,!
	While reader.Next(.obj,.sc) {b	;解析XML
		s Mainobj=obj
		
	b
	w Mainobj.itemno,!
	//w InputObj.feeitem.itemname,!

	b 
	q 
}
}
*/
}
