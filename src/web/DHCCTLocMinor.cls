Class web.DHCCTLocMinor Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 根据科室描述得到医院名称
ClassMethod GetHospitalByLocDesc(LocDesc)
{
	s HospitalDesc=""
	s RowId=##class(web.CTLoc).GetIdFromCodeDescriptionHosp(LocDesc,"")
	i RowId'="" {
		s HospitalId=$p($g(^CTLOC(RowId)),"^",22)
		i HospitalId'="" s HospitalDesc=$p(^CT("HOSP",HospitalId),"^",2)
	}
	Q HospitalDesc
}

ClassMethod DeleteMinorLoc(ID As %String) As %Boolean
{
 Quit:((ID="")||(+ID=0)) 0
 Set CTLocId=$P($g(^DHCCTLoc(+ID,"MINOR",$p(ID,"||",2))),"^",1)
 Set IsDeleted=##class(User.DHCCTLocMinor).%DeleteId(ID)
 
 ;调用号源平台接口
 if IsDeleted=1 {
	 s $ZT="DelServiceErr"
	 s inputObj=##class(DTRClientService.DepartmentDataManage.s0.DelDepGrpRt).%New()
	 s inputObj.UserID=""
	 s inputObj.TradeCode=""
	 s inputObj.ClientType=""
	 s CTHospCode=""
	 I CTLocId'="" {
		 s CTHospId=$p($g(^CTLOC(CTLocId)),"^",22)
		 i CTHospId'="" s CTHospCode=$p($g(^CT("HOSP",CTHospId)),"^",1)
	 }
	 s inputObj.HospitalId=CTHospCode
	 s inputObj.ExtOrgCode=""
	 s inputObj.ExtUserID=""
	 s inputObj.DepartmentGroupCode=+ID
	 s inputObj.DepartmentCode=CTLocId
	 s outputObj=##class(DTRClientService.DepartmentDataManage.s0.DelDepGrpRp).%New()
	 s ServiceObj=##class(DTRClientService.DepartmentDataManage.DTRXTPSDepartmentDataManageSoap).%New()
	 s outputObj=ServiceObj.DelDepartmentGrp(inputObj)
 }
 Quit:IsDeleted=1 1
 Quit:IsDeleted=0 0
 
DelServiceErr
	s LogId=$I(^DTRClientServiceErrLog("DepartmentDataManage","DelDepartmentGrp"))
	s ^DTRClientServiceErrLog("DepartmentDataManage","DelDepartmentGrp",+$H,LogId)=$h_"^"_$ze
	q 1
}

ClassMethod UpdateMinor(ID, ParRef, CTLocID, IsActive) As %Boolean
{
	 q:(ID=""||(+ID=0)||($d(^DHCCTLoc(ParRef))=0)) 0
	 s SaveResult=0
	 s CTLMNRowID=ParRef_"||"_ID
	 s count=0
	 &sql(select count(CTLMN_CTLocDR) into :count from SQLUser.DHC_CTLoc_Minor where CTLMN_CTLocDR=:CTLocID and CTLMN_RowID <> :CTLMNRowID and CTLMN_ChildSub <> '0')
	 Quit:count>0 "该科室已存在!"
	 q:$d(^DHCCTLoc(ParRef,"MINOR",ID))=0 0
	 s:$g(^CTLOC(CTLocID))'="" $p(^DHCCTLoc(ParRef,"MINOR",ID),"^",1)=CTLocID
	 s $p(^DHCCTLoc(ParRef,"MINOR",ID),"^",2)=IsActive
     q 1
}

ClassMethod InsertMinor(ParRef, CTLocID, IsActive) As %Boolean
{
	
	 s $ZT="InsertServiceErr"
	 Quit:(ParRef=""||($d(^DHCCTLoc(ParRef))=0)) 0
	 s count=0
	 &sql(select count(CTLMN_CTLocDR) into :count from SQLUser.DHC_CTLoc_Minor where CTLMN_CTLocDR=:CTLocID and CTLMN_ChildSub<>'0')
	 ;Quit:count>0 "该科室已存在!"
	 if count>0{
		&sql(select CTLMN_ParRef->CTLMJ_Name into :MJName from SQLUser.DHC_CTLoc_Minor where CTLMN_CTLocDR=:CTLocID and CTLMN_ChildSub<>'0' GROUP BY CTLMN_ParRef)
		Q "该科室已存在! 存在于一级科室:"_MJName
	 }
	 Set Obj=##class(User.DHCCTLocMinor).%New(ParRef)
	 Do:$g(^CTLOC(CTLocID))'="" Obj.CTLMNCTLocDRSetObjectId(CTLocID)
	 Do Obj.CTLMNParRefSetObjectId(ParRef)
	 Set Obj.CTLMNIsActive=IsActive	
	 Set SaveResult=Obj.%Save()
	 s ^tmpgry("DepartmentDataManage",SaveResult)=SaveResult
	 ;调用号源平台接口
	 if SaveResult=1 {
		 
		 s ID=Obj.%Id()
		 s inputObj=##class(DTRClientService.DepartmentDataManage.s0.InsDepGrpRt).%New()
		 s inputObj.UserID=""
		 s inputObj.TradeCode=""
		 s inputObj.ClientType=""
		 s CTHospCode=""
		 s CTLocId=$P(^DHCCTLoc(+ID,"MINOR",$p(ID,"||",2)),"^",1)
		 I CTLocId'="" {
			 s CTHospId=$p($g(^CTLOC(CTLocId)),"^",22)
			 i CTHospId'="" s CTHospCode=$p($g(^CT("HOSP",CTHospId)),"^",1)
		 }
		 s inputObj.HospitalId=CTHospCode
		 s inputObj.ExtOrgCode=""
		 s inputObj.ExtUserID=""
		 s inputObj.DepartmentGroupCode=+ID
		 s inputObj.DepartmentGroupName=$p(^DHCCTLoc(+ID),"^",1)
		 s inputObj.DepartmentCode=CTLocId
		 s inputObj.DepartmentName=$P($g(^CTLOC(CTLocId)),"^",2)
		 s outputObj=##class(DTRClientService.DepartmentDataManage.s0.InsDepGrpRp).%New()
		 s ServiceObj=##class(DTRClientService.DepartmentDataManage.DTRXTPSDepartmentDataManageSoap).%New()
		 s outputObj=ServiceObj.InsDepartmentGrp(inputObj)
		 s ^tmpgry("DepartmentDataManage")=inputObj_","_ServiceObj_","_outputObj
	 }
	 Quit:SaveResult=1 1
	 Quit 0
InsertServiceErr
	s LogId=$I(^DTRClientServiceErrLog("DepartmentDataManage","DelDepartmentGrp"))
	s ^DTRClientServiceErrLog("DepartmentDataManage","DelDepartmentGrp",+$H,LogId)=$h_"^"_$ze
	q 1
}

Query GetMinorLocList(parref As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "RowID:%String,CTLocDR:%String,CTLOCDesc:%String,IsActive:%String")
{
	SELECT CTLMN_RowID,CTLMN_CTLocDR,CTLMN_CTLocDR->CTLOC_Desc , CTLMN_IsActive
	FROM SQLUser.DHC_CTLoc_Minor where CTLMN_ParRef=:parref and CTLMN_ChildSub>0
}

Query GetMinorList(parref As %String, HUIFlag As %String = "", HospID As %String = "") As %Query(ROWSPEC = "RowID:%String,CTLocDR:%String,CTLocDesc:%String,IsActive:%String,Hospital:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCCTLocMinor","GetMinorList",1)

ClassMethod GetMinorListExecute(ByRef QHandle As %Binary, parref As %String, HUIFlag As %String = "", HospID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	q:(parref="")||($d(^DHCCTLoc(parref))=0) $$$OK
	b
    s MinorID=0
	f  s MinorID=$o(^DHCCTLoc(parref,"MINOR",MinorID)) q:MinorID=""  d
	.s RowID=MinorID
	.s CTLocDR=$p(^DHCCTLoc(parref,"MINOR",MinorID),"^",1)
	.s CTLocDesc=$p(^CTLOC(CTLocDR),"^",2)
	.s HospitalDR=$p(^CTLOC(CTLocDR),"^",22)
	.s Hospital=""
	.s:HospitalDR'="" Hospital=$P(^CT("HOSP",HospitalDR),"^",2)
	.q:((HospID'="")&&(HospitalDR'=HospID))
	.s IsActive=$p(^DHCCTLoc(parref,"MINOR",MinorID),"^",2)	
	.s:IsActive=0 IsActive=""
	.if HUIFlag="HUI" d
	..if IsActive="" s IsActive="N"
	..else  s IsActive="Y" 
	.s ^CacheTemp(repid,ind)=$lb(RowID,CTLocDR,CTLocDesc,IsActive,Hospital)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod GetMinorListClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetMinorListExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMinorListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMinorListExecute ]
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

Query GetOPLocList(Desc As %String, Type As %String = "") As %Query(ROWSPEC = "CTLocID:%String,CTLocDesc:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCCTLocMinor","GetOPLocList","","NurseAdd")

ClassMethod GetOPLocListExecute(ByRef QHandle As %Binary, Desc As %String, Type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
    s ^GetOPLocListExecute=Desc_","_Type_","_%session.Get("LOGON.USERID")
      s userid=%session.Get("LOGON.USERID")
	  s CTLocID=0
	  f  s CTLocID=$o(^CTLOC(CTLocID))	q:CTLocID=""  d
	  .s CTLocDesc=$p($g(^CTLOC(CTLocID)),"^",2)
	  .q:(($d(^PAC("ADMLOC",0,"AdmType","O",CTLocID))'=10)&&(Type'="ALL"))
	  .q:(Type="NurseAdd")&&($d(^DHCNurseAddLicense(userid,CTLocID))'=10) //护士诊间加号权限
	  .s CTLocContactName=$P(^CTLOC(CTLocID),"^",43)
	  .//科室检索码
	  .s CTLocContactName=$$ALPHAUP^SSUTIL4(CTLocContactName)
	  .//s:((Type="NurseAdd")&&(CTLocDesc["-")) CTLocDesc=$p(CTLocDesc,"-",2)
	  .s ^CacheTemp(repid,ind)=$lb(CTLocID,CTLocContactName_" "_CTLocDesc)
	  .s ind=ind+1
	
	Quit $$$OK
}

ClassMethod GetOPLocListClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetOPLocListExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetOPLocListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPLocListExecute ]
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
