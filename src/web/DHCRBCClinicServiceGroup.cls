Class web.DHCRBCClinicServiceGroup Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod ClinicServiceGroupBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 &sql(SELECT %ID,CLSGRP_Code,CLSGRP_Desc into :id,:code,:Name FROM SQLUSER.RBC_ClinicServiceGroup where CLSGRP_Code =:val) 
 if SQLCODE'=0 quit 0
 set retval=itmjs_"('"_$ZCVT(Name,"O","JS")_"');"
 if itmjsex'="""" set retval=retval_itmjsex_"('"_$ZCVT(id,"O","JS")_"^"_$ZCVT(code,"O","JS")_"^"_$ZCVT(Name,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod DeleteClinicServiceGroupByID(id As %String)
{
	set result=##class(User.RBCClinicServiceGroup).%DeleteId(id)
		
	if ($System.Status.IsError(result))
	{
		d $System.Status.DisplayError(result)
		quit "0"
		
	}
	else
	{
		quit "1"	
	}
}

ClassMethod InsertClinicServiceGroup(code As %String, name As %String, begindate As %String, enddate As %String, HospID = "")
{
	set count=0
	&sql(select count(CLSGRP_Code) into :count from SQLUSER.RBC_ClinicServiceGroup where CLSGRP_Code=:code)
	if (count>0)
	{
		quit "2"
	}
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("RBC_ClinicServiceGroup",HospID)
	set clinic=##class(User.RBCClinicServiceGroup).%New()
	set clinic.CLSGRPCode=code
	set clinic.CLSGRPDesc=name
	set:begindate'="" clinic.CLSGRPDateFrom=..%ZDH(begindate) //$zdh(begindate,4)
	set:enddate'="" clinic.CLSGRPDateTo=..%ZDH(enddate) //$zdh(enddate,4)
	set result=clinic.%Save()
	if ($System.Status.IsError(result))
	{
		d $System.Status.DisplayError(result)
		quit "0"
		
	}
	else
	{
		d ##class(DHCDoc.Common.Hospital).SaveHOSP("RBC_ClinicServiceGroup",clinic.%Id(),HospID)
		quit "1"	
	}
}

ClassMethod UpdateClinicServiceGroup(id As %String, code As %String, name As %String, begindate As %String, enddate As %String)
{
	set count=0
	&sql(select count(CLSGRP_Code) into :count from SQLUSER.RBC_ClinicServiceGroup where CLSGRP_Code=:code and %id!=:id)
	if (count>0)
	{
		quit "2"
	}
	set clinic=##class(User.RBCClinicServiceGroup).%OpenId(id)
	set clinic.CLSGRPCode=code
	set clinic.CLSGRPDesc=name
	S:begindate'="" begindate=..%ZDH(begindate) //$zdh(begindate,4)
	s:enddate'="" enddate=..%ZDH(enddate) //$zdh(enddate,4)
	i begindate'="" s clinic.CLSGRPDateFrom=begindate
	s clinic.CLSGRPDateTo=enddate
	set result=clinic.%Save()
	if ($System.Status.IsError(result))
	{
		d $System.Status.DisplayError(result)
		quit "0"
		
	}
	else
	{
		quit "1"	
	}
}

Query GetAllClinicServiceGroup(CLSGRPCode As %String, CLSGRPDesc As %String) As %SQLQuery
{
SELECT %id AS ID,CLSGRP_Code AS CLSGRPCode,CLSGRP_Desc AS CLSGRPDesc,CLSGRP_DateFrom AS CLSGRPDateFrom,CLSGRP_DateTo AS CLSGRPDateTo FROM SQLUSER.RBC_ClinicServiceGroup 
where (CLSGRP_Code %STARTSWITH :CLSGRPCode) and (CLSGRP_Desc %STARTSWITH:CLSGRPDesc)
}

Query GetClinicServiceGroupByName(CLSGRPDesc As %String) As %SQLQuery
{
SELECT %id AS ID,CLSGRP_Code AS CLSGRPCode,CLSGRP_Desc AS CLSGRPDesc FROM SQLUSER.RBC_ClinicServiceGroup 
where (CLSGRP_Desc %STARTSWITH :CLSGRPDesc) and (CLSGRP_DateFrom<=current_date) and ((CLSGRP_DateTo>=current_date) or (CLSGRP_DateTo is null) )
}

Query GetAllClinicServiceGroupNew(CLSGRPCode As %String, CLSGRPDesc As %String, HospID = "") As %Query(ROWSPEC = "ID:%String,CLSGRPCode:%String,CLSGRPDesc:%String,CLSGRPDateFrom:%String,CLSGRPDateTo:%String")
{
}

ClassMethod GetAllClinicServiceGroupNewExecute(ByRef QHandle As %Binary, CLSGRPCode As %String, CLSGRPDesc As %String, HospID = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s RowId=0 f  s RowId=$o(^RBC("CLSGRP",RowId)) q:RowId=""  d
	.;科室与专业组设置-服务组、排班服务组维护共用此query，但前者需要按照院区过滤
	.Q:(HospID'="")&&("N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_ClinicServiceGroup",RowId,HospID))
	.s ArrStr=$g(^RBC("CLSGRP",RowId))
	.s Code=$p(ArrStr,"^",1)
	.s Desc=$p(ArrStr,"^",2)
	.s DateFrom=$p(ArrStr,"^",3)
	.s DateTo=$p(ArrStr,"^",4)
	.q:(CLSGRPCode'="")&&(CLSGRPCode'=Code)
	.q:(CLSGRPDesc'="")&&(CLSGRPDesc'=Desc)
	.s:DateFrom'="" DateFrom=..%ZD(DateFrom)
	.s:DateTo'="" DateTo=..%ZD(DateTo)
	.s Data=$lb(RowId,Code,Desc,DateFrom,DateTo)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	Quit $$$OK
}

ClassMethod GetAllClinicServiceGroupNewClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetAllClinicServiceGroupNewExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAllClinicServiceGroupNewFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllClinicServiceGroupNewExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetAllClinicServiceGroupLocSpec(CLSGRPCode As %String, CLSGRPDesc As %String, HospID = "") As %Query(ROWSPEC = "ID:%String,CLSGRPCode:%String,CLSGRPDesc:%String,CLSGRPDateFrom:%String,CLSGRPDateTo:%String")
{
}

ClassMethod GetAllClinicServiceGroupLocSpecExecute(ByRef QHandle As %Binary, CLSGRPCode As %String, CLSGRPDesc As %String, HospID = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s RowId=0 f  s RowId=$o(^RBC("CLSGRP",RowId)) q:RowId=""  d
	.;科室与专业组设置-服务组、排班服务组维护共用此query，但前者需要按照院区过滤
	.Q:(HospID'="")&&("N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_ClinicServiceGroup",RowId,HospID))
	.s ArrStr=$g(^RBC("CLSGRP",RowId))
	.s Code=$p(ArrStr,"^",1)
	.s Desc=$p(ArrStr,"^",2)
	.s DateFrom=$p(ArrStr,"^",3)
	.s DateTo=$p(ArrStr,"^",4)
	.q:(CLSGRPCode'="")&&(CLSGRPCode'=Code)
	.q:(CLSGRPDesc'="")&&(CLSGRPDesc'=Desc)
	.q:(DateFrom'="")&&(DateFrom>+$h)
	.q:(DateTo'="")&&(DateTo<+$h)
	.s:DateFrom'="" DateFrom=..%ZD(DateFrom)
	.s:DateTo'="" DateTo=..%ZD(DateTo)
	.s Data=$lb(RowId,Code,Desc,DateFrom,DateTo)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	Quit $$$OK
}

ClassMethod GetAllClinicServiceGroupLocSpecClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetAllClinicServiceGroupLocSpecExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAllClinicServiceGroupLocSpecFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllClinicServiceGroupLocSpecExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
