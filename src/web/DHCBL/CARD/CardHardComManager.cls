Class web.DHCBL.CARD.CardHardComManager Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod CardHardComManagerQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardHardComManagerQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Insert(Code As %String, Desc As %String, GroupId As %String, ClassID As %String, ObjectID As %String, Version As %String, CodeBase As %String, EquipPort As %String, JsFunctionName As %String, DLLType As %String, DateFrom As %String, DateTo As %String) As %String
{
	TStart
	set ComManager=##class(User.DHCCardHardComManager).%New()
	set ComManager.CCMCode=Code
	set ComManager.CCMDesc=Desc
	do ComManager.CCMComGroupDRSetObjectId(GroupId)
	set ComManager.CCMCLASSID=ClassID
	set ComManager.CCMOBJECTID=ObjectID
	set ComManager.CCMVersion=Version
	set ComManager.CCMCodeBase=CodeBase
	set ComManager.CCMEquipPort=EquipPort
	set ComManager.CCMJSFunctionName=JsFunctionName
	set ComManager.CCMDLLType=DLLType
	if (DateFrom="")
	{
		set ComManager.CCMDateFrom=..%SysDate()
	}
	else
	{
		set ComManager.CCMDateFrom=..%ZDH(DateFrom)
	}
	if DateTo'=""
	{
		set ComManager.CCMDateTo=..%ZDH(DateTo)
	}
	set sc=ComManager.%Save()
		If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit -100
	}
	TCommit
	
	Quit ComManager.%Id()
}

ClassMethod CardHardComManagerQueryExecute(ByRef qHandle As %Binary, CodeSearch As %String, NameSearch As %String, GroupNameSearch As %String, DLLTypeSearch As %String, JSFuncNameSearch As %String, DLLFuncSearch As %String, DLLFuncTypeSearch As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCBL.CARD.CardHardComManager","CardHardComManagerQuery","","","")
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	set condition=""
	if (CodeSearch'="") set condition=" AND (A.CCM_Code %STARTSWITH '"_CodeSearch_"')"
	if (NameSearch'="") set condition=condition_" AND (A.CCM_Desc %STARTSWITH '"_NameSearch_"')"
	if (GroupNameSearch'="") set condition=condition_" AND (A.CCM_ComGroup_DR->CCG_Desc %STARTSWITH '"_GroupNameSearch_"')"
	if (DLLTypeSearch'="") set condition=condition_" AND (A.CCM_DLLType = '"_DLLTypeSearch_"')"
	if (JSFuncNameSearch'="") set condition=condition_" AND (A.CCM_JSFunctionName %STARTSWITH '"_JSFuncNameSearch_"')"
	if (DLLFuncSearch'="") set condition=condition_" AND (B.CDF_DLLFunctionName %STARTSWITH '"_DLLFuncSearch_"')"
	if (DLLFuncTypeSearch'="") set condition=condition_" AND (B.CDF_DLLFunctionType = '"_DLLFuncTypeSearch_"')"
	
	set sql="SELECT distinct A.CCM_RowID As ID,A.CCM_Code As Code,"_
	"A.CCM_Desc As Name,A.CCM_ComGroup_DR->CCG_Desc As GroupName,"_
	"A.CCM_CLASSID As ClassID,A.CCM_OBJECTID As ObjectID,"_
	"A.CCM_Version As Version,A.CCM_CodeBase As CodeBase,"_
	"A.CCM_EquipPort As EquipPort,A.CCM_JSFunctionName As JSFunctionName,"_
	"A.CCM_DLLType As DLLType,A.CCM_DateFrom As DateFrom,"_
	"A.CCM_DateTo As DateTo,A.CCM_ComGroup_DR->%ID As GroupID "_
	" From DHC_CardHardComManager A,DHC_CardHardDLLFunction B "_
	" Where (A.CCM_RowID=*B.CDF_CCM_ParRef) "_condition	
	
	set ^ozrtest(100)=sql
	set rst=##class(%Library.ResultSet).%New()
	do rst.Prepare(sql)
	do rst.Execute()
	
	while(rst.Next())
	{
		set ID=rst.Data("ID")
		set Code=rst.Data("Code")
		set Desc=rst.Data("Name")
		set GroupName=rst.Data("GroupName")
		set ClassID=rst.Data("ClassID")
		set ObjectID=rst.Data("ObjectID")
		set Version=rst.Data("Version")
		set CodeBase=rst.Data("CodeBase")
		set EquipPort=rst.Data("EquipPort")
		set JSFunctionName=rst.Data("JSFunctionName")
		set DLLType=rst.Data("DLLType")
		set DateFrom=..%ZD(rst.Data("DateFrom")) //$zd(rst.Data("DateFrom"),4)
		set DateTo=rst.Data("DateTo")
		if (DateTo'="")
		{
			set DateTo=..%ZD(rst.Data("DateTo")) //$zd(rst.Data("DateTo"),4)
		}
		set GroupID=rst.Data("GroupID")
			
		set Data=$ListBuild(ID,Code,Desc,GroupName,ClassID,ObjectID,Version,CodeBase,EquipPort,JSFunctionName,DLLType,DateFrom,DateTo,GroupID)
		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod Update(RowId As %String, Code As %String, Desc As %String, GroupId As %String, ClassID As %String, ObjectID As %String, Version As %String, CodeBase As %String, EquipPort As %String, JsFunctionName As %String, DLLType As %String, DateFrom As %String, DateTo As %String) As %String
{
	//set ^ozrtest(111)="aa"
	TStart
	set ComManager=##class(User.DHCCardHardComManager).%OpenId(RowId)
	set ComManager.CCMCode=Code
	set ComManager.CCMDesc=Desc
	do ComManager.CCMComGroupDRSetObjectId(GroupId)
	set ComManager.CCMCLASSID=ClassID
	set ComManager.CCMOBJECTID=ObjectID
	set ComManager.CCMVersion=Version
	set ComManager.CCMCodeBase=CodeBase
	set ComManager.CCMEquipPort=EquipPort
	set ComManager.CCMJSFunctionName=JsFunctionName
	set ComManager.CCMDLLType=DLLType
	if (DateFrom'=""){
		set ComManager.CCMDateFrom=..%ZDH(DateFrom)
	}else{
		set ComManager.CCMDateFrom=""
    }
	if DateTo'=""
	{
		set ComManager.CCMDateTo=..%ZDH(DateTo)
	}else{
		set ComManager.CCMDateTo=""
	}
	if DateFrom'=""
	{
		set ComManager.CCMDateFrom=..%ZDH(DateFrom)
	}else{
		set ComManager.CCMDateFrom=""
	}
	set sc=ComManager.%Save()
		If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit -100
	}
	TCommit
	Quit ComManager.%Id()
}

ClassMethod CardHardComManagerQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardHardComManagerQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod Delete(RowId As %String) As %String
{
	TStart
	set sc=##class(User.DHCCardHardComManager).%DeleteId(RowId)
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit -100
	}
	TCommit
	Quit ComManager.%Id()
}

Query CardHardComManagerQuery(CodeSearch As %String, NameSearch As %String, GroupNameSearch As %String, DLLTypeSearch As %String, JSFuncNameSearch As %String, DLLFuncSearch As %String, DLLFuncTypeSearch As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,GroupName:%String,ClassID:%String,ObjectID:%String,Version:%String,CodeBase:%String,EquipPort:%String,JSFunctionName:%String,DLLType:%String,DateFrom:%String,DateTo:%String,GroupID:%String")
{
}

/// w ##class(web.DHCBL.CARD.CardHardComManager).GetComManagerDataJson(13,^dhcGetCardTypeDataJson)
ClassMethod GetComManagerDataJson(ComManagerId As %String, jsonFiledStr As %String)
{
	s ^dhcGetCardTypeDataJson=jsonFiledStr
	&sql(select * into :PLIST() from SQLUSER.DHC_CardHardComManager where CCM_RowID=:ComManagerId)
	if SQLCODE'=0 Quit ""
	s jsonFiled=##class(%Library.DynamicObject).%FromJSON(jsonFiledStr)
	s jsonData={}
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCCardHardComManager")
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

ClassMethod SaveByJson(ComManagerId As %String, JsonStr As %String)
{
	
	s ^dhcInsertByJson=JsonStr
	s jsonObj={}
	s jsonObj=jsonObj.%FromJSON(JsonStr)
	
	
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCCardHardComManager")
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
	if ComManagerId=""{
		&sql(insert into SQLUSER.DHC_CardHardComManager values :PLIST())
	}else{
		&sql(update SQLUSER.DHC_CardHardComManager values :PLIST() where CCM_RowID=:ComManagerId)
	}
	Quit SQLCODE
}

}
