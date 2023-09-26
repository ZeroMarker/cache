Class web.DHCBL.CARD.CardHardDLLFunction Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Query CardHardDLLFunctionQuery(ParentRowID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT CDF_RowID AS ID,CDF_DLLFunctionName AS FunctionName,
CDF_DLLInPara1 AS InParaOne,CDF_DLLInPara2 AS InParaTwo,
CDF_DLLInPara3 AS InParaThree,CDF_DLLFunctionType AS DLLFunctionType 
FROM sqluser.DHC_CardHardDLLFunction where CDF_CCM_ParRef=:ParentRowID
}

ClassMethod Insert(ParentRowID As %String, FunctionName As %String, InParaOne As %String, InParaTwo As %String, InParaThree As %String, DLLFunctionType As %String) As %String
{
	TStart
	set DLLManager=##class(User.DHCCardHardComManager).%OpenId(ParentRowID)
	set DLLFunction=##class(User.DHCCardHardDLLFunction).%New(ParentRowID)
	set DLLFunction.CDFDLLFunctionName=FunctionName
	set DLLFunction.CDFCCMParRef=DLLManager
	set DLLFunction.CDFDLLInPara1=InParaOne
	set DLLFunction.CDFDLLInPara2=InParaTwo
	set DLLFunction.CDFDLLInPara3=InParaThree
	set DLLFunction.CDFDLLFunctionType=DLLFunctionType

	set sc=DLLFunction.%Save()
		If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit -100
	}
	TCommit
	
	Quit DLLFunction.%Id()
}

ClassMethod Update(RowID As %String, ParentRowID As %String, FunctionName As %String, InParaOne As %String, InParaTwo As %String, InParaThree As %String, DLLFunctionType As %String) As %String
{
	TStart
	set DLLFunction=##class(User.DHCCardHardDLLFunction).%OpenId(RowID)
	set DLLFunction.CDFDLLFunctionName=FunctionName
	do DLLFunction.CDFCCMParRefSetObjectId(ParentRowID)
	set DLLFunction.CDFDLLInPara1=InParaOne
	set DLLFunction.CDFDLLInPara2=InParaTwo
	set DLLFunction.CDFDLLInPara3=InParaThree
	set DLLFunction.CDFDLLFunctionType=DLLFunctionType

	set sc=DLLFunction.%Save()
		If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit -100
	}
	TCommit
	
	Quit DLLFunction.%Id()
}

ClassMethod Delete(RowId As %String) As %String
{
	TStart
	set sc=##class(User.DHCCardHardDLLFunction).%DeleteId(RowId)
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit -100
	}
	TCommit
	Quit 1
}

ClassMethod SaveByJson(Rowid As %String, JsonStr As %String, ParRef As %String)
{
	s ^dhcInsertByJson=JsonStr
	s jsonObj={}
	s jsonObj=jsonObj.%FromJSON(JsonStr)
	
	
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCCardHardDLLFunction")
	s myCount = myobj.Properties.Count()
	k PLIST
	s myParList=""
	f i=1:1:myCount {
		s mypropobj=myobj.Properties.GetAt(i)
		s PropertyName=mypropobj.Name
		continue:jsonObj.%GetTypeOf(PropertyName)="unassigned" 
		s val=jsonObj.%Get(PropertyName)
		s dataType=mypropobj.Type
		if dataType="%Library.Date"{
			s val=..%ZDH(val)	
		}
		s sqlNum=mypropobj.SqlColumnNumber
		s PLIST(sqlNum)=val
	}
	if '$d(PLIST) Quit -1
	if Rowid=""{ 
		s PLIST(0)=ParRef
		&sql(insert into SQLUSER.DHC_CardHardDLLFunction values :PLIST())
	}else{
		&sql(update SQLUSER.DHC_CardHardDLLFunction values :PLIST() where CDF_RowID=:Rowid)
	}
	Quit SQLCODE
}

/// w ##class(web.DHCBL.CARD.CardHardDLLFunction).GetJsonData("13||1",^dhcGetCardTypeDataJson)
ClassMethod GetJsonData(RowId As %String, jsonFiledStr As %String)
{
	s ^dhcGetCardTypeDataJson=jsonFiledStr
	&sql(select * into :PLIST() from SQLUSER.DHC_CardHardDLLFunction where CDF_RowID=:RowId)
	if SQLCODE'=0 Quit ""
	s jsonFiled=##class(%Library.DynamicObject).%FromJSON(jsonFiledStr)
	s jsonData={}
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCCardHardDLLFunction")
	s myCount = myobj.Properties.Count()
	//k PLIST
	s myParList=""
	f i=1:1:myCount {
		s mypropobj=myobj.Properties.GetAt(i)
		s PropertyName=mypropobj.Name
		s dataType=mypropobj.Type
		
		continue:jsonFiled.%GetTypeOf(PropertyName)="unassigned" 
		s sqlNum=mypropobj.SqlColumnNumber
		continue:sqlNum=""
		s val=$g(PLIST(sqlNum))
		if dataType="%Library.Date"{
			s val=..%ZD(val)
		}
		
		s filedName=jsonFiled.%Get(PropertyName)
		do jsonData.%Set(filedName,val)
	}
	
	Quit jsonData.%ToJSON()
}

}
