Class web.DHCRBCClinicGroup Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod ClinicGroupBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 &sql(SELECT %ID,CLGRP_Code,CLGRP_Desc into :id,:code,:Name FROM SQLUSER.RBC_ClinicGroup where CLGRP_Code =:val) 
 if SQLCODE'=0 quit 0
 set retval=itmjs_"('"_$ZCVT(Name,"O","JS")_"');"
 if itmjsex'="""" set retval=retval_itmjsex_"('"_$ZCVT(id,"O","JS")_"^"_$ZCVT(code,"O","JS")_"^"_$ZCVT(Name,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod DeleteClinicGroupByID(id As %String)
{
	set result=##class(User.RBCClinicGroup).%DeleteId(id)
		
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

ClassMethod InsertClinicGroup(code As %String, name As %String, begindate As %String, enddate As %String, HospID = "")
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("RBC_ClinicGroup",HospID)
	set count=0
	&sql(select count(CLGRP_Code) into :count from SQLUSER.RBC_ClinicGroup where CLGRP_Code=:code)
	if (count>0)
	{
		quit "2"
	}
	set clinic=##class(User.RBCClinicGroup).%New()
	set clinic.CLGRPCode=code
	set clinic.CLGRPDesc=name
	set:begindate'="" clinic.CLGRPDateFrom=..%ZDH(begindate) //$zdh(begindate,4)
	set:enddate'="" clinic.CLGRPDateTo=..%ZDH(enddate) //$zdh(enddate,4)
	set result=clinic.%Save()
	if ($System.Status.IsError(result)){
		d $System.Status.DisplayError(result)
		quit "0"
		
	}else{
		d ##class(DHCDoc.Common.Hospital).SaveHOSP("RBC_ClinicGroup",clinic.%Id(),HospID)
		quit "1"	
	}
}

ClassMethod UpdateClinicGroup(id As %String, code As %String, name As %String, begindate As %String, enddate As %String)
{
	set count=0
	&sql(select count(CLGRP_Code) into :count from SQLUSER.RBC_ClinicGroup where CLGRP_Code=:code and %id!=:id)
	if (count>0)
	{
		quit "2"
	}
	set clinic=##class(User.RBCClinicGroup).%OpenId(id)
	set clinic.CLGRPCode=code
	set clinic.CLGRPDesc=name
	S:begindate'="" begindate=..%ZDH(begindate) //$zdh(begindate,4)
	s:enddate'="" enddate=..%ZDH(enddate) //$zdh(enddate,4)
	i begindate'="" s clinic.CLGRPDateFrom=begindate
	s clinic.CLGRPDateTo=enddate
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

Query GetAllClinicGroup(CLGRPCode As %String, CLGRPDesc As %String) As %SQLQuery
{
SELECT %id AS ID,CLGRP_Code AS CLGRPCode,CLGRP_Desc AS CLGRPDesc,CLGRP_DateFrom AS CLGRPDateFrom,CLGRP_DateTo AS CLGRPDateTo FROM SQLUSER.RBC_ClinicGroup 
where (CLGRP_Code %STARTSWITH :CLGRPCode) and (CLGRP_Desc %STARTSWITH:CLGRPDesc)
}

Query GetClinicGroupByName(CLGRPDesc As %String) As %SQLQuery
{
SELECT %id AS ID,CLGRP_Code AS CLGRPCode,CLGRP_Desc AS CLGRPDesc FROM SQLUSER.RBC_ClinicGroup 
where (CLGRP_Desc %STARTSWITH :CLGRPDesc) and (CLGRP_DateFrom<=current_date) and ((CLGRP_DateTo>=current_date) or (CLGRP_DateTo is null) )
}

Query GetAllClinicGroupNew(CLGRPCode As %String, CLGRPDesc As %String, HospId As %String = "", AllFlag = "") As %Query(ROWSPEC = "ID:%String,CLGRPCode:%String,CLGRPDesc:%String,CLGRPDateFrom:%String,CLGRPDateTo:%String")
{
}

ClassMethod GetAllClinicGroupNewExecute(ByRef QHandle As %Binary, CLGRPCode As %String, CLGRPDesc As %String, HospId As %String = "", AllFlag = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s RowId=0 f  s RowId=$o(^RBC("CLGRP",RowId)) q:RowId=""  d
	.s ShowDataFlag=##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_ClinicGroup",RowId,HospId)
	.Q:(HospId'="")&&(ShowDataFlag="N")
	.s ArrStr=$g(^RBC("CLGRP",RowId))
	.s Code=$p(ArrStr,"^",1)
	.s Desc=$p(ArrStr,"^",2)
	.s DateFrom=$p(ArrStr,"^",3)
	.s DateTo=$p(ArrStr,"^",4)
	.q:((DateFrom="")||(DateFrom>+$H))&&(AllFlag'=1)
	.q:((DateTo'="")&&(DateTo<+$H))&&(AllFlag'=1)
	.q:(CLGRPCode'="")&&(CLGRPCode'=Code)
	.q:(CLGRPDesc'="")&&(Desc'[CLGRPDesc)
	.s:DateFrom'="" DateFrom=..%ZD(DateFrom)
	.s:DateTo'="" DateTo=..%ZD(DateTo)
	.s Data=$lb(RowId,Code,Desc,DateFrom,DateTo)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	Quit $$$OK
}

ClassMethod GetAllClinicGroupNewClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetAllClinicGroupNewExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAllClinicGroupNewFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllClinicGroupNewExecute ]
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

/// w ##class(web.DHCRBCClinicGroup).SaveLimit("2","1","NotSex!1^SamllAge!1^BigAge!1")
ClassMethod SaveLimit(HospId, ClinicGroupID, Coninfo As %String)
{
	s ^tempqujian("SaveLimit")=$lb(HospId, ClinicGroupID, Coninfo)
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ConNum=$l(Coninfo,"^")
		f i=1:1:ConNum  d
		.s evNoteinfo=$p(Coninfo,"^",i)
		.s Node=$p(evNoteinfo,"!",1)
		.s Info=$p(evNoteinfo,"!",2)
		.s ^DHCOPRegConfig(HospCodeNode,"ClinicGroup_"_ClinicGroupID,Node)=Info
	}
}

ClassMethod ShowLimit(HospId, ClinicGroupID)
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	s NotSex=$G(^DHCOPRegConfig(HospCodeNode,"ClinicGroup_"_ClinicGroupID,"NotSex"))
	s SamllAge=$G(^DHCOPRegConfig(HospCodeNode,"ClinicGroup_"_ClinicGroupID,"SamllAge"))
	s BigAge=$G(^DHCOPRegConfig(HospCodeNode,"ClinicGroup_"_ClinicGroupID,"BigAge"))
	s rtn=NotSex_$C(1)_SamllAge_$C(1)_BigAge
	q rtn
}

ClassMethod CheckClinicGroupLimitConfig(PatientID, ClinicGroupID, HospId)
{
	q:ClinicGroupID="" 0
	s ret=0
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	s NotSex=$G(^DHCOPRegConfig(HospCodeNode,"ClinicGroup_"_ClinicGroupID,"NotSex"))
	s SamllAge=$G(^DHCOPRegConfig(HospCodeNode,"ClinicGroup_"_ClinicGroupID,"SamllAge"))
	s BigAge=$G(^DHCOPRegConfig(HospCodeNode,"ClinicGroup_"_ClinicGroupID,"BigAge"))
	s PatDOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
	s Age=$$CalAge^at182(PatDOB,+$H,"","","")
	s Age=$p(Age,"|",12)
	s PatSex=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	if (NotSex'=""){
		if ((","_NotSex_",")[(","_PatSex_",")){
				s ret=1_"^"_"该专业组限制了性别!"
			}
		}
	if (SamllAge'=""){
		if (Age<SamllAge){
			s ret=1_"^"_"该排班限制了不能小于"_SamllAge_"岁!"
		}
		}
	if (BigAge'=""){
		if (Age>BigAge){
			s ret=1_"^"_"该排班限制了不能大于"_BigAge_"岁!"
		}
	}
	q ret
}

ClassMethod ReadSex(JSFunName As %String = "", ListName As %String = "", HospId As %String = "") As %String
{
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.UDHCOPOtherLB).ReadBankListBroker("","")
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	s DefaultSex=$G(^DHCDocCardConfig(HospCodeNode,"DefaultSex"))
	
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s json="["
	f  s myBMRowid=$o(^CT("SEX",myBMRowid)) q:(myBMRowid="")  d
	.s DataFrom=$p(^CT("SEX",myBMRowid),"^", 4)
	.q:(DataFrom'="")&&(DataFrom>+$h)
	.s DateTo=$p(^CT("SEX",myBMRowid),"^", 5)
	.q:(DateTo'="")&&(DateTo<=..%SysDate())
	.s mydes=$p(^CT("SEX",myBMRowid),"^", 2)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^CT("SEX",myBMRowid),"^", 1)
	.i DefaultSex=myBMRowid d 
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.i JSFunName="GetSexToHUIJson" d
	..s AliasAtr=##class(DHCDoc.Util.Base).GetAliasByTabName("CT_Sex",myBMRowid)
	..s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(myBMRowid)_""",""AliasAtr"":"""_$g(AliasAtr)_""""
	..;i mySelFlag=1 s OneJsonData=OneJsonData_",""selected"":true"
	..s OneJsonData=OneJsonData_"}"
	..i myIdx=0 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
	.e  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	s json=json_"]"    
	if (JSFunName="GetSexToHUIJson"){
		q json
	}
	q 0
}

}
