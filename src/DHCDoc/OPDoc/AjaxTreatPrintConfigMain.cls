Class DHCDoc.OPDoc.AjaxTreatPrintConfigMain Extends (%CSP.Page, DHCDoc.Util.RegisteredObject)
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("action",1),"")
	if (action = "GetTreatPIdConfigData")
	{
  		w ..GetTreatPIdConfigData()
  		
	}
   if (action = "RemoveTreatPrintConfigData")
	{
		w ..RemoveTreatPrintConfigData()	
	}
	if (action="IsActive")
	{
		w ..IsActive()	
	}
	Quit $$$OK
}

/// creator:宋春莉
/// date:2017-12-31
/// desc:返回就显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatPrintConfigMain).GetTreatPIdConfigData()     
ClassMethod GetTreatPIdConfigData(HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s json="["_"{""id"":"""_0_""",""des"":"""_"无"_"""}"
	s count=0
    s result=##class(%Library.ResultSet).%New()
    s sqlBase="SELECT TreatPrintMainID, DirectoryName FROM SQLUser.DocCFTreatPrintMainInfo where PId=0 "
    _" and HospDr='"_HospId_"'"
	d result.Prepare(sqlBase)
	d result.Execute()
	while(result.Next())
	{ 
		//if count>0 s json=json_","
		s json=json_","
		s json=json_"{""id"":"""_result.Data("TreatPrintMainID")_""",""des"":"""_result.Data("DirectoryName")_"""}"
		s count=count+1
	}
	q json_"]"
}

/// creator:宋春莉
/// date:2017-12-31
/// desc:保存配置数据
/// w ##class(DHCDoc.OPDoc.AjaxTreatPrintConfigMain).SaveTreatPrintConfigData() 
ClassMethod SaveTreatPrintConfigData(Str As %String, HospId As %String = "") As %String
{
	s ^tempscl("str")=Str
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s selID=$p(Str,$c(1),1)
	s PId=$p(Str,$c(1),2)
	s DirectoryName = $p(Str,$c(1),3)
	s ElementId     = $p(Str,$c(1),4)
	s Value         = $p(Str,$c(1),5)
	s noCheckbox    = ##class(%Library.Boolean).XSDToLogical($p(Str,$c(1),6))
	s CheckAble     = ##class(%Library.Boolean).XSDToLogical($p(Str,$c(1),7))
	s IsExpand      = ##class(%Library.Boolean).XSDToLogical($p(Str,$c(1),8))
	s ExpandMethodForLoadingTable = $p(Str,$c(1),9)
	s IsSendMessage = ##class(%Library.Boolean).XSDToLogical($p(Str,$c(1),10))
	s IconStyle     = $p(Str,$c(1),11)
	s FontStyle     = $p(Str,$c(1),12)
	s ClickEvent    = $p(Str,$c(1),13)
	s URLObject     = $p(Str,$c(1),14)
	s URLStyle      = $p(Str,$c(1),15)
	if (URLStyle="iframe_1") s URLStyle="iframe"
	s IconExpression= $p(Str,$c(1),16)
	s PreviewXMLName= $p(Str,$c(1),17)
	s PrintMethod   = $p(Str,$c(1),18)
	if (selID=""){
		&sql(select max(DisplayNum) into:num from SQLUser.DocCFTreatPrintMainInfo where HospDr=:HospId)
		i num="" d
		.s DisplayNum=1
		e  d
		.s DisplayNum=num+1
		&SQL(INSERT INTO SQLUser.DocCFTreatPrintMainInfo (PId, DirectoryName, ElementId, Value, DisplayNum, noCheckbox, CheckAble, 
	 IsActive, IsExpand, ExpandMethodForLoadingTable, IsSendMessage, IconStyle, FontStyle, ClickEvent, URLObject, URLStyle, IconExpression, PreviewXMLName, PrintMethod,HospDr) 
		values (:PId,:DirectoryName,:ElementId,:Value,:DisplayNum,:noCheckbox,:CheckAble,'1',:IsExpand,:ExpandMethodForLoadingTable,:IsSendMessage,:IconStyle,
		:FontStyle,:ClickEvent,:URLObject,:URLStyle,:IconExpression,:PreviewXMLName,:PrintMethod,:HospId))
	}else{
		&SQL(Update SQLUser.DocCFTreatPrintMainInfo set PId=:PId,DirectoryName=:DirectoryName,ElementId=:ElementId,Value=:Value,noCheckbox=:noCheckbox,
		CheckAble=:CheckAble,IsExpand=:IsExpand,ExpandMethodForLoadingTable=:ExpandMethodForLoadingTable,IsSendMessage=:IsSendMessage,IconStyle=:IconStyle,
		FontStyle=:FontStyle,ClickEvent=:ClickEvent,URLObject=:URLObject,URLStyle=:URLStyle,IconExpression=:IconExpression,PreviewXMLName=:PreviewXMLName,PrintMethod=:PrintMethod
		 WHERE TreatPrintMainID=:selID)
	}
	q SQLCODE
}

/// creator:宋春莉
/// date:2017-12-31
/// desc:返回就显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatPrintConfigMain).RemoveTreatPrintConfigData() 
ClassMethod RemoveTreatPrintConfigData(Str As %String) As %String
{
	for i=1:1:$l(Str,"^"){
		s OneStr=$p(Str,"^",i)
		s ID=$p(OneStr,$C(1),1)
		s index=$p(OneStr,$C(1),2)
		s nowdt=..%SysDate()
		&SQL(Update SQLUser.DocCFTreatPrintMainInfo set DisplayNum=:index WHERE TreatPrintMainID=:ID)
	}
	Q SQLCODE
}

/// creator:宋春莉
/// date:2017-12-27
/// desc:返回就显示配置json数据 
/// w ##class(DHCDoc.OPDoc.AjaxTreatPrintConfigMain).IsActive() 
ClassMethod IsActive(ID As %String, IsActive As %String) As %String
{
	&SQL(Update SQLUser.DocCFTreatPrintMainInfo set IsActive=:IsActive WHERE TreatPrintMainID=:ID)
	q SQLCODE
}

/// 提供给新产品的新增接口
/// 入参：name:名称 Code:代码 HospId:医院ID
/// w ##class(DHCDoc.OPDoc.AjaxTreatPrintConfigMain).CreatNewTreatPrintConfig(Name, Code, HospId)    
ClassMethod CreatNewTreatPrintConfig(Name, Code, HospId)
{
	s selID=""
	s PId=1
	s DirectoryName = Name
	s ElementId     = ""
	s Value         = Code
	s noCheckbox    = "true"
	s CheckAble     = "true"
	s IsExpand      = "false"
	s ExpandMethodForLoadingTable = ""
	s IsSendMessage = "false"
	s IconStyle     = ""
	s FontStyle     = ""
	s ClickEvent    = ""
	s URLObject     = ""
	s URLStyle      = ""
	if (URLStyle="iframe_1") s URLStyle="iframe"
	s IconExpression= ""
	s PreviewXMLName= ""
	s PrintMethod   = "DHCDoc.OPDoc.TreatPrint.PrescriptPrintData?prescriptPrintDataArgs"
	s Str=selID_$c(1)_PId_$c(1)_DirectoryName_$c(1)_ElementId_$c(1)_Value_$c(1)_noCheckbox_$c(1)_CheckAble_$c(1)_IsExpand
	s Str=Str_$c(1)_ExpandMethodForLoadingTable_$c(1)_IsSendMessage_$c(1)_IconStyle_$c(1)_FontStyle_$c(1)_ClickEvent_$c(1)_URLObject_$c(1)_URLStyle
	s Str=Str_$c(1)_IconExpression_$c(1)_PreviewXMLName_$c(1)_PrintMethod
	s rtn=..SaveTreatPrintConfigData(Str)
	q 0
}

}
