Class web.DHCBL.CARD.CardHardComGroup Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Insert(code As %String, desc As %String, type As %String) As %String
{
	;^DHCCARDHARDCOMi("GROUP",0,{CCG_Type},{CCG_RowID})
	s myGroupID=$o(^DHCCARDHARDCOMi("GROUP",0,type,0))
	if (myGroupID'=""){
		quit -100
	}
	
	set cardHardComGroup=##class(User.DHCCardHardComGroup).%New()
	set cardHardComGroup.CCGCode=code
	set cardHardComGroup.CCGDesc=desc
	set cardHardComGroup.CCGType=type
	set result=cardHardComGroup.%Save()
	
	if ($System.Status.IsError(result))
	{
		d $System.Status.DisplayError(result)
		quit "-104"
	}
	else
	{
		quit "0"	
	}
}

ClassMethod Update(rid As %String, code As %String, desc As %String, type As %String)
{
	set cardHardComGroup=##class(User.DHCCardHardComGroup).%OpenId(rid)
	set cardHardComGroup.CCGCode=code
	set cardHardComGroup.CCGDesc=desc
	set cardHardComGroup.CCGType=type
	set result=cardHardComGroup.%Save()
	
	if ($System.Status.IsError(result))
	{
		d $System.Status.DisplayError(result)
		quit "-104"
	}
	else
	{
		quit "0"	
	}
}

ClassMethod Delete(rowid As %String)
{
	set result=##class(User.DHCCardHardComGroup).%DeleteId(rowid)
		
	if ($System.Status.IsError(result))
	{
		d $System.Status.DisplayError(result)
		quit "-104"		
	}
	else
	{
		quit "0"	
	}
}

Query SelectByCondition(code As %String, desc As %String, type As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID as ID,CCG_Code as Code,CCG_Desc as Name,CCG_Type as Type 
FROM SQLUser.DHC_CardHardComGroup
where (CCG_Code %STARTSWITH :code) and (CCG_Desc %STARTSWITH :desc) and (CCG_Type %STARTSWITH :type)
}

Query CardHardGroupQuery(Name As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT CCG_Desc AS Name,CCG_Code,%ID AS ID,CCG_Type as Type FROM SQLUSER.DHC_CardHardComGroup where CCG_Desc %STARTSWITH :Name
}

ClassMethod CardHardGroupQueryBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 &sql(SELECT %ID,CCG_Code,CCG_Desc,CCG_Type into :id,:code,:Name,:type FROM SQLUSER.DHC_CardHardComGroup where CCG_Code =:val) 
 if SQLCODE'=0 quit 0
 set retval=itmjs_"('"_$ZCVT(Name,"O","JS")_"');"
 if itmjsex'="""" set retval=retval_itmjsex_"('"_$ZCVT(id,"O","JS")_"^"_$ZCVT(code,"O","JS")_"^"_$ZCVT(Name,"O","JS")_"^"_$ZCVT(type,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod SaveByJson(RowId As %String, JsonStr As %String)
{
	s ^dhcInsertByJson=JsonStr
	s jsonObj={}
	s jsonObj=jsonObj.%FromJSON(JsonStr)
	
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCCardHardComGroup")
	s myCount = myobj.Properties.Count()
	k PLIST
	s myParList="",type=""
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
		if (sqlNum=4){
			s type=val
		}
	}
	s myGroupID=$o(^DHCCARDHARDCOMi("GROUP",0,type,0))
	if (myGroupID'="")&&(myGroupID'=RowId){
		quit -100
	}
	if '$d(PLIST) Quit -1
	if RowId=""{
		&sql(insert into SQLUSER.DHC_CardHardComGroup values :PLIST())
	}else{
		&sql(update SQLUSER.DHC_CardHardComGroup values :PLIST() where CCG_RowID=:RowId)
	}
	Quit SQLCODE
}

/// w ##class(web.DHCBL.CARD.CardHardComManager).GetDataJson(13,^dhcGetCardTypeDataJson)
ClassMethod GetDataJson(RowId As %String, jsonFiledStr As %String)
{
	s ^dhcGetCardTypeDataJson=jsonFiledStr
	&sql(select * into :PLIST() from SQLUSER.DHC_CardHardComGroup where CCG_RowID=:RowId)
	if SQLCODE'=0 Quit ""
	s jsonFiled=##class(%Library.DynamicObject).%FromJSON(jsonFiledStr)
	s jsonData={}
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCCardHardComGroup")
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
