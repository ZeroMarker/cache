/// 未提交病案
Class DtPortal.Doctor.D02ClinicPrompt.D0211UnSubmitMedical Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0211UnSubmitMedical","D021101UnSubmitList","P","601","","2")

/// 未提交病案首页  by limushuang
/// Type:1:科主任   2：医生
/// 
Query D021101UnSubmitList(QueryType As %String, UserCode As %String = "", LocId As %String = "", Type As %String = "") As DtPortal.Query(ROWSPEC = "regNo:%String,medicareNo:%String,name:%String,patLoc:%String,InTime:%String,outTime:%String,DocDes:%String,groupdesc:%String") [ SqlProc ]
{
}

ClassMethod D021101UnSubmitListExecute(ByRef qHandle As %Binary, QueryType As %String, UserCode As %String = "", LocId As %String = "", Type As %String = "") As %Status
{
	n (qHandle,QueryType,UserCode,LocId,Type)
	
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set MUDocIDs=""
	if (UserCode'=""){
		Set UserID=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
		set DocId=##class(DtPortal.Common.PublicService).GetDocIDByUserCode(UserCode)
		Quit:UserID="" $$$OK
		if QueryType="PG" SET MUDocIDs=##Class(DtPortal.Common.PublicService).GetMUDocList(DocId)
    	else  s MUDocIDs="^"_DocId_"^"
	}
	
	
	
	s DocLoc=""
	if (LocId'=""){
		s:LocId["||" DocLoc=##class(DtPortal.DD.DD00PublicService).getLittleDDloc(LocId)   //传入的如果是二级科室
		s:(LocId'["||")&&(LocId'="") DocLoc=##class(DtPortal.DD.DD00PublicService).getDDloc(LocId,"I")  //传入的如果是一级科室
		Quit:DocLoc="" $$$OK
	}
	
	s days=##Class(DtPortal.Common.PublicService).getValueByCode("UNSUBMITDAYS")
	
	s startdate=(+$h)-days
	s enddate=+$h
	f date=startdate:1:enddate d
	.s PAAdm=""
	.f  s PAAdm=$o(^PAADMi("EstDisch",date,PAAdm)) q:PAAdm=""  d
	..s loc=$p(^PAADM(PAAdm),"^",4)
	..s FistPageFlag=##Class(EMRservice.BL.BLAdmRecordStatus).GetAdmRecordStatus(PAAdm)
	..q:FistPageFlag="1"   //判断病案首页数据是否提交
	..i Type=1  d  //科主任角色
	...q:loc'=DocLoc
	...s groupdesc=..GetAdmDocOutGroup(PAAdm)
	...d patinfo
	..i Type=2  d  //医师角色
	...s admDocDR=$P($g(^PAADM(PAAdm)),"^",9)
	...q:admDocDR=""
	...q:MUDocIDs'[("^"_admDocDR_"^")
	...s groupdesc=..GetAdmDocOutGroup(PAAdm)
	...d patinfo

	Quit $$$OK
patinfo
	s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(PAAdm)
	s regNo=$p(patInfoStr,"^",7)    //登记号
	s medicareNo=$p(patInfoStr,"^",5)   //病案号
	s name=$p(patInfoStr,"^",2)		//姓名
	s patLoc=$P($g(^CTLOC(loc)),"^",2) //就诊科室
	i patLoc["-" s patLoc=$p(patLoc,"-",2)  //就诊科室
	
	s inDateTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(PAAdm)
	s InDate=$p(inDateTimeStr,"^",1)
	s InTime=$p(inDateTimeStr,"^",2)
	i InDate'="" s InDate=$zd(InDate,3)
	i InTime'="" s InTime=$zt(InTime,2)
	s InTime=InDate_"&nbsp;"_InTime  //入院时间
	
	s outDateTimeStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(PAAdm)
	s outDate=$p(outDateTimeStr,"^",1)
	s outTime=$p(outDateTimeStr,"^",2)
	i outDate'="" s outDate=$zd(outDate,3)
	i outTime'="" s outTime=$zt(outTime,2)
	s outTime=outDate_"&nbsp;"_outTime //出院时间
	
	s DocDes=""
	i admDocDR'="" s DocDes=$p(^CTPCP(admDocDR,1),"^",2)   //管床医师
	
	s Data=$lb(regNo,medicareNo,name,patLoc,InTime,outTime,DocDes,groupdesc)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

///       IntPut: AdmRowid
///       OutPut: AdmDocOutGroup
///  DesCription: 获取病人出院医生所在医疗小组
///        Table: PA_AdmTransaction
///         Date: 2018-03-09
///      Creator: liubaoshi---来自南大二院项目20181030
///        Debug: w ##class(web.DHCENS.BLL.CostAccounting.Method.Query.BaseMethod).GetAdmDocOutGroup("18252")
///        Debug: w ##class(DtPortal.Doctor.D02ClinicPrompt.D0211UnSubmitMedical).GetAdmDocOutGroup("18252")
ClassMethod GetAdmDocOutGroup(AdmRowid As %String) As %String
{
	Quit:AdmRowid="" ""
	Set AdmDept=$p($g(^PAADM(AdmRowid)),"^",4)
	Set AdmDoc=$p($g(^PAADM(AdmRowid)),"^",9)
	Set AdmAdmDischgDate=$p($g(^PAADM(AdmRowid)),"^",17) 
	Set AdmDocOutGroupID=..GetMedUnitRowId(AdmDept,AdmDoc,AdmAdmDischgDate) 
	If (AdmDocOutGroupID'="") {
 				Set AdmDocOutGroup=$p(^CTLOC(+AdmDocOutGroupID,"MU",$p(AdmDocOutGroupID,"||",2)),"^",2) 
				}
 			Else{
 				Set AdmDocOutGroup=""
 			}
 	Quit $g(AdmDocOutGroup)
}

/// Description:	通过医生(CT_PCP)RowId、科室(CT_Loc)的RowId取科室小组(DHC_CTLoc_MedUnit)RowId
/// Table:	 DHC_CTLoc_MedUnit,DHC_CTLoc_MedUnitCareProv
/// Index:	 ^CTLOC(CTMU_CTLOC_ParRef,"MU",CTMU_Childsub), ^CTLOC(0,"CTPCP",{MUCP_Doctor_DR},{DHC_CTLoc_MedUnit.CTMU_CTLOC_ParRef},"MU",{DHC_CTLoc_MedUnit.CTMU_Childsub},"CP",{MUCP_Childsub})	
/// Input:	 mLocDr:科室RowId; mDocDr:医生RowId; date:查询日期
///      Creator: $$GetMedUnitRowId3^DHCWLBuildKPIDataNDEFY(AdmDept,AdmDoc,AdmAdmDischgDate) 来自南大二院项目20181030
ClassMethod GetMedUnitRowId(mLocDr As %String, mDocDr As %String, date As %String) As %String
{
	 new (mLocDr,mDocDr,date)
	 quit:(mLocDr="")||(mDocDr="") ""
	 quit:'$data(^CTLOC(mLocDr)) ""
	 quit:'$data(^CTPCP(mDocDr)) ""
	 ;set medUnitRowid=""
	 set ctmuChildSub="" for  set ctmuChildSub=$order(^CTLOC(mLocDr,"MU",ctmuChildSub)) quit:ctmuChildSub=""  do
	 .set isLocActive="FALSE"	;验证查询的日期,对应的科室小组是否生效
	 .set isDocActive="FALSE"	;验证查询的日期,对应的科室小组中的医生分组是否生效
	 .set mucpChildSub="" for  set mucpChildSub=$order(^CTLOC(0,"CTPCP",mDocDr,mLocDr,"MU",ctmuChildSub,"CP",mucpChildSub)) quit:mucpChildSub=""  do
	 ..set mucpDateFrom=$piece($get(^CTLOC(mLocDr,"MU",ctmuChildSub,"CP",mucpChildSub)),"^",5)
	 ..set mucpDateTo=$piece($get(^CTLOC(mLocDr,"MU",ctmuChildSub,"CP",mucpChildSub)),"^",6)
	 ..if (mucpDateFrom<=date)&&(mucpDateTo="") set isDocActive="TRUE"
	 ..else  if (mucpDateFrom<=date)&&(date<=mucpDateTo) set isDocActive="TRUE"
	 ..;s isDocActive="TRUE"            //2018-09-30 注释掉，这句话将医生对应工作小组强制改为了生效状态
	 .quit:(isDocActive="FALSE")
	 .set ctmuDateFrom=$piece($get(^CTLOC(mLocDr,"MU",ctmuChildSub)),"^",4)
	 .set ctmuDateTo=$piece($get(^CTLOC(mLocDr,"MU",ctmuChildSub)),"^",5)
	 .if (ctmuDateFrom<=date)&&(ctmuDateTo="")&&(isDocActive="TRUE") set isLocActive="TRUE"
	 .else  if (ctmuDateFrom<=date)&&(date<=ctmuDateTo)&&(isDocActive="TRUE") set isLocActive="TRUE"
	 .;s isLocActive="TRUE"				//2018-09-30 注释掉，这句话将对应工作小组强制改为了生效状态
	 .if isLocActive="TRUE" set medUnitRowid=mLocDr_"||"_ctmuChildSub
	 quit $get(medUnitRowid)
}

}
