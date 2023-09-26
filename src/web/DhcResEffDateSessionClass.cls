Class web.DhcResEffDateSessionClass Extends DHCDoc.Util.RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(web.DhcResEffDateSessionClass).Update("2678||2||1^星期一^NoChange^NoChange^2071^50^47^0^1")
ClassMethod Update(Data)
{
	s ^UpdateDateSessionxj=Data
	;UpdateData=SessRowid+"^"+SessDOW+"^"+SessTimeStart+"^"+SessTimeEnd+"^"+SessSlotLength+"^"+SessLoad+"^"+SessNoSlots+"^"+SessNoApptSlot;
	;UpdateData=UpdateData+"^"+SessNumberOfWeeks+"^"+SessNoOverbookAll+"^"+SessRoom+"^"+SessType+"^"+SessClinicGroup+"^"+SessPatientType+"^"+SessNo+"^"+SessScheduleGenerFlag;
    ;UpdateData=UpdateData+"^"+TRFlag+"^"+TRStartTime+"^"+TREndTime+"^"+TRLength+"^"+TRRegNum+"^"+TRRegNumStr+"^"+TRRegInfoStr+"^"+AutoLoad+"^"+ExtLoad
	q:Data="undefined" ""
	s DateSessionRowid=$p(Data,"^",1)
	q:DateSessionRowid="" ""
	;$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",19)

	s RBID=+DateSessionRowid
	s REDSub=$p(DateSessionRowid,"||",2)
	s REDSSub=$p(DateSessionRowid,"||",3)
	;s trinfo=^RB("RES",3270,"DATE",4,"SESS",1,"DHC")
	//星期
	s SessDowName=$p(Data,"^",2)
	I SessDowName="星期一" S SessDowRouid=1
    I SessDowName="星期二" S SessDowRouid=2
    I SessDowName="星期三" S SessDowRouid=3
    I SessDowName="星期四" S SessDowRouid=4
    I SessDowName="星期五" S SessDowRouid=5
    I SessDowName="星期六" S SessDowRouid=6
    I SessDowName="星期日" S SessDowRouid=7
	s SessDOW=SessDowRouid_$c(1)_SessDowName
	//职称
	s SessType=$p(Data,"^",3)
	i SessType="NoChange" s SessType=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",9)
	s SessType=SessType_$c(1)_$p(^RBC("SESS",SessType),"^",2)
	//时段
	s SessNoDr=$p(Data,"^",4)
	i SessNoDr="NoChange" s SessNoDr=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",3)
	s SessNo=SessNoDr_$c(1)_$p(^DHCTimeRange(SessNoDr),"^",2)
	//诊室
	s SessRoom=$p(Data,"^",5)
	i SessRoom="NoChange" s SessRoom=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",19)
	q:SessRoom="" "原诊室为空"
	s SessRoom=SessRoom_$c(1)_$p(^CTLOC(SessRoom),"^",2)
	//正号限额
	s SessLoad=$p(Data,"^",6)
	//预约限额
	s SessNoApptSlot=$p(Data,"^",7)
	//加号限额
	s AutoLoad=$p(Data,"^",8)
	S ExtLoad=""
	//限额
	s SessNoSlots=SessLoad-SessNoApptSlot
	//预约起始号
	s SessNumberOfWeeks=4
	//模板状态
	s SessScheduleGenerFlag=$p(Data,"^",9)
	i SessScheduleGenerFlag=1 s SessScheduleGenerFlag="Y"
	e  s SessScheduleGenerFlag="N"
	//SessTimeStr
	s SessTimeStr=##class(web.DHCRBResSession).GetTRTimeStrByRowId(SessNoDr)
	s SessTimeStart=$p(SessTimeStr,"^",1)
	s SessTimeEnd=$p(SessTimeStr,"^",2)
	s TRStartTime=SessTimeStart
	s TREndTime=SessTimeEnd
	//SessSlotLength
	s SessSlotLength=""
	//SessNoOverbookAll
	s SessNoOverbookAll=""
	//亚专业
	s SessClinicGroup=""
	//病人类型
	s SessPatientType="O"
	//TRFlag
	s TRFlag="Y"
	//TRLength
	s TRLength=""
	s TRRegNum=SessNoApptSlot
	s TRInfo=##class(web.DHCRBResSession).TRInfoCalculateNew(SessTimeStart,SessTimeEnd,TRRegNum,SessNumberOfWeeks)
	s TRRegNumStr=$p(TRInfo,"^",2)
	s TRRegInfoStr=$p(TRInfo,"^",3)
	s UpdateData=DateSessionRowid_"^"_SessDOW_"^"_SessTimeStart_"^"_SessTimeEnd_"^"_SessSlotLength_"^"_SessLoad_"^"_SessNoSlots_"^"_SessNoApptSlot
	s UpdateData=UpdateData_"^"_SessNumberOfWeeks_"^"_SessNoOverbookAll_"^"_SessRoom_"^"_SessType_"^"_SessClinicGroup_"^"_SessPatientType_"^"_SessNo_"^"_SessScheduleGenerFlag
    s UpdateData=UpdateData_"^"_TRFlag_"^"_TRStartTime_"^"_TREndTime_"^"_TRLength_"^"_TRRegNum_"^"_TRRegNumStr_"^"_TRRegInfoStr_"^"_AutoLoad_"^"_ExtLoad
	s ret=##class(web.DHCRBResSession).Update(UpdateData)
	s flag=$p(ret,"^",1)
	s sameRoom=$p(ret,"^",2)
	q:sameRoom'="" "同时段同诊室已有医生排班"
}

ClassMethod GetResourceById(DocId As %String, js As %String)
{
	set reource = ##Class(User.DHCRBResource).%OpenId(DocId)
	set result =""
	if ($IsObject(reource.RESClinicGroupDR)){
		set result=reource.RESClinicGroupDR.%Id()
	}
	
	if ($IsObject(reource.RESSessionTypeDR)){
		set result=result_"^"_reource.RESSessionTypeDR.%Id()
	}else{
		set result=result_"^"_""
	}
	set result=result_"^"_reource.RESLoad
	set result=result_"^"_reource.RESAppLoad
	set result=result_"^"_reource.RESAppStartNum
	set result=result_"^"_reource.RESAddLoad
	set result=result_"^"_reource.RESDiagnosCatStr
	set result=result_"^"_reource.RESFeeType
	set result=result_"^"_reource.RESReAdmFeeFlag
	set result=result_"^"_reource.RESEPMarkFlag
	set result=result_"^"_reource.RESTimeRangeFlag
	set result=result_"^"_reource.RESTimeRangeLength
	set result=result_"^"_reource.RESTimeRangeRegNum
	set result=result_"^"_reource.RESAllowGetSeqNoFlag
	set result=result_"^"_reource.RESLoadXW
	
	
	q result
 //s retval=js_"('"_$ZCVT(reource.RESClinicGroupDR.SESSDesc,"O","JS")_"');"
 // s retval= retval_"("_reource.RESClinicGroupDR.SESSDesc
 // &javascritp<#(retval)#>
}

ClassMethod GetSessTypeByDocId(DocId As %String, LocId)
{
	s findRBRowId=""
	q:LocId="" ""
	s RBRowId="" f  s RBRowId=$o(^RB("RES",0,"CTLOC",LocId,RBRowId)) Q:RBRowId=""  d 
	.s DoctorId=$p(^RB("RES",RBRowId),"^",2)
	.q:DoctorId'=DocId
	.s findRBRowId=RBRowId
	set SessTypeDR = ""
	if findRBRowId'=""{
		set reource = ##Class(User.DHCRBResource).%OpenId(findRBRowId)
		if ($IsObject(reource.RESSessionTypeDR)){
			set SessTypeDR=reource.RESSessionTypeDR.%Id()
		}else{
			set SessTypeDR=""
		}
		if SessTypeDR=""{
			s ContrastStr=##CLASS(web.DHCDocSessContrast).GetResSessType(findRBRowId)
			if (ContrastStr'="") s SessTypeDR=$p(ContrastStr,"^",1)
			else  s SessTypeDR=""
		}
	}
	
	q SessTypeDR
}

ClassMethod GetSessTypeDescById(SessTypeDR As %String) As %String
{
	Q:SessTypeDR="" ""
	s SessTypeDdesc=$p($g(^RBC("SESS",SessTypeDR)),"^",2)
	Q SessTypeDdesc
}

ClassMethod GetDataStrByDocIdAndLocId(DocId As %String, LocId As %String, TimeRange As %String = "")
{
	s ret = "",findRBRowId=""
	s RBRowId="" f  s RBRowId=$o(^RB("RES",0,"CTLOC",LocId,RBRowId)) Q:RBRowId=""  d 
	.s DoctorId=$p(^RB("RES",RBRowId),"^",2)
	.q:DoctorId'=DocId
	.//set reource = ##Class(User.DHCRBResource).%OpenId(RBRowId)
	.s findRBRowId=RBRowId
	q:findRBRowId="" ret
	if (TimeRange'=""){
		set reource = ##Class(User.DHCRBResource).%OpenId(findRBRowId)
		set SessTypeDR = ""
		if ($IsObject(reource.RESSessionTypeDR)){
			set SessTypeDR=reource.RESSessionTypeDR.%Id()
		}else{
			set SessTypeDR=""
		}
		if ($IsObject(reource.RESClinicGroupDR)){
			set ClinicGroupDR=reource.RESClinicGroupDR.%Id()
		}else{
			set ClinicGroupDR=""
		}
		s RESAddLoad = reource.RESAddLoad
		s RESTRLength = reource.RESTimeRangeLength
		s RESTRRegNum = reource.RESTimeRangeRegNum
		
		s RESTRowId=""
		f  s RESTRowId=$o(^RB("RES",findRBRowId,"REST",RESTRowId)) q:RESTRowId=""  d
		.s RESTTimeRange=$p(^RB("REST",RESTRowId),"^",2)
		.q:RESTTimeRange'=TimeRange
		.s RESLoad=$p(^RB("REST",RESTRowId),"^",3)
		.s RESAppLoad=$p(^RB("REST",RESTRowId),"^",4)
		.s RESAppStartNum=$p(^RB("REST",RESTRowId),"^",5)
		.s RESTAutoLoad=$p(^RB("REST",RESTRowId),"^",6)
		.s RESTExtLoad=$p(^RB("REST",RESTRowId),"^",7)
		.s ret = SessTypeDR_"^"_RESLoad_"^"_RESAppLoad_"^"_RESAppStartNum_"^"_RESAddLoad_"^"_RESTRLength_"^"_RESTRRegNum_"^"_RESTAutoLoad_"^"_RESTExtLoad_"^"_ClinicGroupDR
	}
	if (ret="")||(TimeRange=""){
		set reource = ##Class(User.DHCRBResource).%OpenId(findRBRowId)
		set SessTypeDR = ""
		if ($IsObject(reource.RESSessionTypeDR)){
			set SessTypeDR=reource.RESSessionTypeDR.%Id()
		}else{
			set SessTypeDR=""
		}		
		if ($IsObject(reource.RESClinicGroupDR)){
			set ClinicGroupDR=reource.RESClinicGroupDR.%Id()
		}else{
			set ClinicGroupDR=""
		}
		s RESLoad = reource.RESLoad
		s RESAppLoad = reource.RESAppLoad
		s RESAppStartNum = reource.RESAppStartNum
		s RESAddLoad = reource.RESAddLoad
		s RESTRLength = reource.RESTimeRangeLength
		s RESTRRegNum = reource.RESTimeRangeRegNum
		s ret = SessTypeDR_"^"_RESLoad_"^"_RESAppLoad_"^"_RESAppStartNum_"^"_RESAddLoad_"^"_RESTRLength_"^"_RESTRRegNum_"^"_ClinicGroupDR
	}
	q ret
}

ClassMethod GetTRLengthByASRowid(ASRowid As %String)
{
	s RBID=$P(ASRowid,"||",1)
	s DocId=$p(^RB("RES",RBID),"^",2)
	set reource = ##Class(User.DHCRBResource).%OpenId(DocId)
	s TRLength = reource.RESTimeRangeLength
	s TRRegNum = reource.RESTimeRangeRegNum
	
	
	q TRLength_"^"_TRRegNum
}

/// 判断该科室同医生同时段是否已经有排班
/// w ##class(web.DhcResEffDateSessionClass).IsSameResEffDateSess(46,1730,1,1,"Y")
ClassMethod IsSameResEffDateSess(LocId, DocId, DOW, TimeRange, status)
{
	s ret = 0
	/*s RBRowId="" f  s RBRowId=$o(^RB("RES",0,"CTLOC",LocId,RBRowId)) Q:RBRowId=""  d 
	.s DoctorId=$p(^RB("RES",RBRowId),"^",2)
	.q:DoctorId'=DocId
	.s ResDateSub=$o(^RB("RES",RBRowId,"DATE",""),-1)
	.q:ResDateSub=""
	.s ResDateSessSub = 0  f  s ResDateSessSub = $o(^RB("RES",RBRowId,"DATE",ResDateSub,"SESS",ResDateSessSub)) q:ResDateSessSub=""  d
	..s getDOW = $p(^RB("RES",RBRowId,"DATE",ResDateSub,"SESS",ResDateSessSub),"^",2)
	..s getSessNo = $p(^RB("RES",RBRowId,"DATE",ResDateSub,"SESS",ResDateSessSub),"^",3)
	..s SESSScheduleGenerFlag = $p(^RB("RES",RBRowId,"DATE",ResDateSub,"SESS",ResDateSessSub),"^",16)
	..s:((getDOW=DOW)&&(getSessNo=TimeRange)&&(SESSScheduleGenerFlag="Y")&&(status="Y")) ret=1*/
	s LocId=0
	f  s LocId=$o(^RB("RES",0,"CTPCP",DocId,LocId)) q:LocId=""  d
	.s RBRowId="" f  s RBRowId=$o(^RB("RES",0,"CTPCP",DocId,LocId,RBRowId)) Q:RBRowId=""  d 
	..s ResDateSub=$o(^RB("RES",RBRowId,"DATE",""),-1)
	..q:ResDateSub=""
	..s ResDateSessSub = 0  f  s ResDateSessSub = $o(^RB("RES",RBRowId,"DATE",ResDateSub,"SESS",ResDateSessSub)) q:ResDateSessSub=""  d
	...s getDOW = $p(^RB("RES",RBRowId,"DATE",ResDateSub,"SESS",ResDateSessSub),"^",2)
	...s SESSHolidayWeek = $p(^RB("RES",RBRowId,"DATE",ResDateSub,"SESS",ResDateSessSub),"^",41)
	...i SESSHolidayWeek'="" s getDOW=SESSHolidayWeek
	...s getSessNo = $p(^RB("RES",RBRowId,"DATE",ResDateSub,"SESS",ResDateSessSub),"^",3)
	...s SESSScheduleGenerFlag = $p(^RB("RES",RBRowId,"DATE",ResDateSub,"SESS",ResDateSessSub),"^",16)
	...s:((getDOW=DOW)&&(getSessNo=TimeRange)&&(SESSScheduleGenerFlag="Y")&&(status="Y")) ret=1
	q ret
}

/// 通过传ASRowid判断该科室同医生同时段是否已经有排班
/// w ##class(web.DhcResEffDateSessionClass).IsSameResEffDateSessByREDSRowid("2682||2||8",230,2063,1,2,"Y")
ClassMethod IsSameResEffDateSessByREDSRowid(REDSRowid, LocId, DocId, DOW, TimeRange, status)
{
	s ret = 0
	s RBRowId="" f  s RBRowId=$o(^RB("RES",0,"CTLOC",LocId,RBRowId)) Q:RBRowId=""  d 
	.s DoctorId=$p(^RB("RES",RBRowId),"^",2)
	.q:DoctorId'=DocId
	.s ResDateSub=$o(^RB("RES",RBRowId,"DATE",""),-1)
	.s ResDateSessSub = ""  f  s ResDateSessSub = $o(^RB("RES",RBRowId,"DATE",ResDateSub,"SESS",ResDateSessSub)) q:ResDateSessSub=""  d
	..s getDOW = $p(^RB("RES",RBRowId,"DATE",ResDateSub,"SESS",ResDateSessSub),"^",2)
	..s getSessNo = $p(^RB("RES",RBRowId,"DATE",ResDateSub,"SESS",ResDateSessSub),"^",3)
	..s SESSScheduleGenerFlag = $p(^RB("RES",RBRowId,"DATE",ResDateSub,"SESS",ResDateSessSub),"^",16)
	..s:((getDOW=DOW)&&(getSessNo=TimeRange)&&((RBRowId_"||"_ResDateSub_"||"_ResDateSessSub)'=REDSRowid)&&(SESSScheduleGenerFlag="Y")&&(status="Y")) ret=1
	q ret
}

/// 根据科室和医生获取排班
/// w ##class(web.DhcResEffDateSessionClass).GetResEffDateByLocIdAndDocId(253,2333)
ClassMethod GetResEffDateByLocIdAndDocId(LocId, DocId)
{
	s ResRowid="",Ressub=""
  	s RBRowId="" f  s RBRowId=$o(^RB("RES",0,"CTLOC",LocId,RBRowId)) Q:RBRowId=""  d 
	.s DoctorId=$p(^RB("RES",RBRowId),"^",2)
	.q:DoctorId'=DocId
    .s REDSub=$o(^RB("RES",RBRowId,"DATE",""),-1)
    .s ResRowid=RBRowId
    .s Ressub=REDSub
	if +Ressub=0 s ResEffDate=##class(web.DHCRBResSession).InsertEffDate(ResRowid,$zd(+$h,4)) i $p(ResEffDate,"^",1)=0 s ResEffDate=$p(ResEffDate,"^",2)
 	else  s ResEffDate=ResRowid_"||"_Ressub
	if +ResEffDate<=0 q ""
	Q ResEffDate
}

/// 根据资源ID获取医生ID
/// w ##class(web.DhcResEffDateSessionClass).GetDocIDByRBRowid(2678)
ClassMethod GetDocIDByRBRowid(RBRowid)
{

	Q $p(^RB("RES",RBRowid),"^",2)
}

/// 根据医生ID获取医生默认排版信息
/// w ##class(web.DhcResEffDateSessionClass).GetRSDocByLocID(6)
ClassMethod GetDocInfoByDocID(DocID)
{

	q:LocID="" ""
	S count=0
	s ret="["
	s RBRowId="" f  s RBRowId=$o(^RB("RES",0,"CTLOC",LocID,RBRowId)) Q:RBRowId=""  d 
	.s Docdr=$p(^RB("RES",RBRowId),"^",2)
	.S DocDesc=$p(^CTPCP(Docdr,1),"^",2)
	.s tmp="'id'^'name'"
	.s count = count+1
	.s Data=Docdr_"^"_DocDesc
	.s ret=ret_..SerializeJsonData(tmp,Data,count)
	s ret=ret_"]"
	Q ret
}

/// 根据科室ID获取医生
/// w ##class(web.DhcResEffDateSessionClass).GetRSDocByLocID(6)
ClassMethod GetRSDocByLocID(LocID, userid As %String = "")
{

	q:LocID="" ""
	S count=0
	s ret="["
	s RBRowId="" f  s RBRowId=$o(^RB("RES",0,"CTLOC",LocID,RBRowId)) Q:RBRowId=""  d 
	.s Docdr=$p(^RB("RES",RBRowId),"^",2)
	.Q:Docdr=""
	.q:('$d(^CTPCP(Docdr,1)))
	.Q:(userid'="")&&('##class(web.DHCUserGroup).UserCanDo(userid,LocID,Docdr))
	.s DateTo=$p(^RB("RES",RBRowId),"^",19)
	.Quit:(DateTo'="")&&(DateTo<(+$h))
	.s ScheSt=$p(^RB("RES",RBRowId),"^",6)
	.Q:(ScheSt'="Y")
	.s ActiveFlag=$p($g(^CTPCP(Docdr,1)),"^",9)
	.Q:ActiveFlag'="Y"
	.s DocDateTo=$p($g(^CTPCP(Docdr,2)),"^",15)
	.q:(DocDateTo'="")&&(DocDateTo<+$h)
	.S DocDesc=$p(^CTPCP(Docdr,1),"^",2)
	.s tmp="'id'^'name'^'code'"
	.s count = count+1
	.i $d(^CTPCP(Docdr,3)) d
	..s DocOtherName=$p(^CTPCP(Docdr,3),"^",28)
	..i DocOtherName'="" s DocDesc=DocDesc
	.s Data=Docdr_"^"_DocDesc_"^"_DocOtherName
	.s ret=ret_..SerializeJsonData(tmp,Data,count)
	s ret=ret_"]"
	Q ret
}

/// 根据科室ID获取医生
/// w ##class(web.DhcResEffDateSessionClass).GetRSDocByLocIDNew(274)
ClassMethod GetRSDocByLocIDNew(LocID, userid As %String = "")
{
	
	q:LocID="" ""
	S count=0
	s ret="["
	s RBRowId="" f  s RBRowId=$o(^RB("RES",0,"CTLOC",LocID,RBRowId)) Q:RBRowId=""  d 
	.Q:'($D(^RB("RES",RBRowId)))
	.s ScheSt=$p(^RB("RES",RBRowId),"^",6)
	.Q:(ScheSt'="Y")
	.S EQID=$p(^RB("RES",RBRowId),"^",3)
	.Q:EQID=""
	.Q:'$D(^RBC("EQ",EQID))
	.S EQID=$p(^RB("RES",RowId),"^",3)
	.s Docdr=$p(^RB("RES",RBRowId),"^",2)
	.Q:(userid'="")&&('##class(web.DHCUserGroup).UserCanDo(userid,LocID,Docdr))
	.S DocDesc=$p(^CTPCP(Docdr,1),"^",2)
	.s tmp="'id'^'name'"
	.s count = count+1
	.s Data=Docdr_"^"_DocDesc
	.s ret=ret_..SerializeJsonData(tmp,Data,count)
	s ret=ret_"]"
	Q ret
}

ClassMethod GetLocByBoruID(BoruID)
{
	//q:BoruID="" ""
	S count=0
	s ret="["
	if (BoruID="Other"){
		s AdmTypeStr="O^E"
		for i=1:1:$l(AdmTypeStr,"^"){
			s AdmType=$p(AdmTypeStr,"^",i)
			s DeptID=0
			for  {
				s DeptID=$o(^PAC("ADMLOC",0,"AdmType",AdmType,DeptID)) 
				q:DeptID=""
				continue:$d(^User.DHCExaBorDepI("BordDepDrIndex"," "_DeptID))
				;科室排班权限判断
				continue:('##class(web.DHCUserGroup).UserCanDo(%session.Get("LOGON.USERID"),DeptID))
				d OutDepJson
			}
		}
	}elseif(BoruID'=""){
		s ID="" f  s ID=$o(^User.DHCExaBorDepI("BordBorDrIndex",BoruID,ID)) q:ID=""  do
		.s DeptID=$list(^User.DHCExaBorDepD(ID),7)
		.d OutDepJson
	}else{
		s AdmTypeStr="O^E"
		for i=1:1:$l(AdmTypeStr,"^"){
			s AdmType=$p(AdmTypeStr,"^",i)
			s DeptID=0
			for  {
				s DeptID=$o(^PAC("ADMLOC",0,"AdmType",AdmType,DeptID)) 
				q:DeptID=""
				;科室排班权限判断
				continue:('##class(web.DHCUserGroup).UserCanDo(%session.Get("LOGON.USERID"),DeptID))
				d OutDepJson
			}
		}
	}
	
	s ret=ret_"]"
	Q ret
OutDepJson
	q:DeptID="" 
	q:'$d(^CTLOC(DeptID))
	s CTLocDateTo=$p($g(^CTLOC(DeptID)),"^",25)
	q:(CTLocDateTo'="")&&(CTLocDateTo<+$h)
	s LocDesc=$P(^CTLOC(DeptID),"^",2)
	s tmp="'id'^'name'^'code'"
	s count = count+1
	s CTAliasTem=""
	i $l(LocDesc,"-")>1 d
	.s LocDesc=$P(CTDesc,"-",2)
	.s CTAliasTem=$P(CTDesc,"-",1)
	s CTAlias=$P(^CTLOC(DeptID),"^",43)
	i CTAlias="" s CTAlias=CTAliasTem
	s:CTAlias'="" LocDesc=LocDesc
	s Data=DeptID_"^"_LocDesc_"^"_CTAlias
	s ret=ret_..SerializeJsonData(tmp,Data,count)
}

/// 根据ASRowid通过获取信息字符串
/// w ##class(web.DhcResEffDateSessionClass).GetSessionTypeIDByASRowid()
ClassMethod GetDataStrByASRowid(ASRowid) As %String
{
    s RBID=$P(ASRowid,"||",1)
    s REDSub=$P(ASRowid,"||",2)
    s REDSSub=$P(ASRowid,"||",3)
	s LocDr=$p(^RB("RES",RBID),"^",1)
	s Docdr=$p(^RB("RES",RBID),"^",2)
	s ASSessionType=""
	s ASSessionTypeDR=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",9)
	i ASSessionTypeDR'="" s ASSessionType=$p(^RBC("SESS",ASSessionTypeDR),"^",2)
	s ASTimeRangeDR=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",3)
	q:ASTimeRangeDR=""
	s ASRoom=""
	s TimeRange=$p(^DHCTimeRange(ASTimeRangeDR),"^",2)
	s ASRoomDr=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",19)
	i ASRoomDr'="" s ASRoom=$p(^CTLOC(ASRoomDr),"^",2)
	s ASAppLoad=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",1)  ;预约 
	s ASLoad=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",8) ;正号
	s SESSDOWDR=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",2) ;周
	i SESSDOWDR'=""  d
	.S DowName=$P(^CT("DOW",1,SESSDOWDR),"^",1)
	e  d 
	.s SessHoliDOWDR = $P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",41)
	.s DowName = ..GetHoliDOWDesc(SessHoliDOWDR)
	s AddLoad=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",14)         ;加号
	i AddLoad="" s AddLoad=0
    s ScheduleGenerFlag=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",16)
    i ScheduleGenerFlag="Y" s ScheduleGenerFlag=1
    e  s ScheduleGenerFlag=0 
    s NumofWeek= $P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",21)
    s ClinicGroupDR= $P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",35)
    s ClinicGroupDR=..CheckClinicGroupDR(LocDr,ClinicGroupDR)
    i NumofWeek="" s NumofWeek=0
    
    ;lxz 分时段信息获取
    s TRFlag=$P($G(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub,"DHC")),"^",1) ;分时段就诊标志
    s StTime=$P($G(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub,"DHC")),"^",2) ;开始时间
    s EnTime=$P($G(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub,"DHC")),"^",3) ;结束时间
    
    s TRLenghth=$P($G(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub,"DHC")),"^",4) ;间隔时间数
    S SDHS=$P($G(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub,"DHC")),"^",5)   ;时段号数
   	s TRRegNumStr=$P($G(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub,"DHC")),"^",6)
	s TRRegInfoStr=$P($G(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub,"DHC")),"^",7)
	
    s autoLoad= "" //$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub,"DHC"),"^",8)
    s extload="" //$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub,"DHC"),"^",9)
    s ret=LocDr_"^"_Docdr_"^"_ASSessionTypeDR_"^"_ASTimeRangeDR_"^"_ASRoomDr
    s ret=ret_"^"_ASLoad_"^"_ASAppLoad_"^"_AddLoad_"^"_ScheduleGenerFlag  
    s ret=ret_"^"_NumofWeek_"^"_SDHS_"^"_TRRegNumStr_"^"_TRRegInfoStr
    s ret=ret_"^"_autoLoad_"^"_extload_"^"_ClinicGroupDR_"^"_TRLenghth
    s ret=ret_"^"_TRFlag_"^"_StTime_"^"_EnTime
    q ret
}

ClassMethod CheckClinicGroupDR(LocDr As %String, ClinicGroupDR As %String) As %String
{
	q:ClinicGroupDR="" ClinicGroupDR
	s DHCLSRowId=0,FindClinicGroup=0
    f  s DHCLSRowId=$o(^DHCLocSubject(DHCLSRowId)) q:DHCLSRowId=""  d
    .s DHCLSLoc=$p(^DHCLocSubject(DHCLSRowId),"^",1)
    .q:DHCLSLoc'=LocDr
    .s DHCLSCliGroup=$p(^DHCLocSubject(DHCLSRowId),"^",2)
    .q:DHCLSCliGroup'=ClinicGroupDR
    .s DateFrom=$p(^RBC("CLGRP",DHCLSCliGroup),"^",3)
    .q:(DateFrom'="")&&(DateFrom>+$h)
    .s DateTo=$p(^RBC("CLGRP",DHCLSCliGroup),"^",4)
    .q:(DateTo'="")&&(DateTo<=..%SysDate())
    .s FindClinicGroup=1
    q:FindClinicGroup=1 ClinicGroupDR
    q ""
}

/// 获取各个预约机构限额
ClassMethod GetAppClientNum(RowId As %String, Type As %String) As %String
{
	s AQQty=0
	if (Type="Template"){
		&sql(Select sum(AQ_Qty) into:AQQty From SQLUser.DHC_RBResEffDateSessAppQty Where AQ_ParRef=:RowId)
	    q AQQty
	}else{
		&sql(Select sum(ASQ_Qty) into:AQQty From SQLUser.DHC_RBApptScheduleAppQty Where ASQASParRef=:RowId and ASQ_LastUpUser_DR is null)
	    q AQQty
	}
}

ClassMethod CheckAppClientNum(RowId As %String, Type As %String, BookNum As %String)
{
	s AQQty=0
	s rtn=0
	if (Type="Template"){
		s AQResDR=+RowId
		s AQDateChildsub=$P(RowId,"||",2)
		s AQSessChildsub=$P(RowId,"||",3)
		s AQChildsub=0 for{
			s AQChildsub=$O(^RB("RES",AQResDR,"Date",AQDateChildsub,"SESS",AQSessChildsub,"AQ",AQChildsub))
			q:AQChildsub=""
			s AppMaxQty=$P(^RB("RES",AQResDR,"Date",AQDateChildsub,"SESS",AQSessChildsub,"AQ",AQChildsub),"^",4)
			s AppReserveQty=$P(^RB("RES",AQResDR,"Date",AQDateChildsub,"SESS",AQSessChildsub,"AQ",AQChildsub),"^",2)
			s AQQty=AQQty+AppReserveQty
			if (AppMaxQty>BookNum) s rtn=1
			}
		}else{
		s ResRowId=+RowId
		s Childsub=$P(RowId,"||",2)
		s ASQSub=0 for{
			s ASQSub=$O(^RBAS(ResRowId,Childsub,"AQ",ASQSub))
			q:ASQSub=""
			s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
			s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
			s AQQty=AQQty+AppReserveQty
			if (AppMaxQty>BookNum) s rtn=1
		}
	}
	if (AQQty>BookNum) s rtn=2

	q rtn
}

/// 根据分诊台获取诊室
/// w ##class(web.DhcResEffDateSessionClass).GetConsultingRoomByBoruID(1)
ClassMethod GetConsultingRoomByBoruID(BoruID)
{
    q:BoruID="" "[]"
	S count=0
	s ret="["
	s ID="" f  s ID=$o(^User.DHCBorExaRoomI("BordBorDrIndex",BoruID,ID)) q:ID=""  do
	.s DeptID=$list(^User.DHCBorExaRoomD(ID),6)
	.q:DeptID=""
	.q:'$d(^CTLOC(DeptID))
	.s LocDesc=$P(^CTLOC(DeptID),"^",2)
	.s LocType=$P(^CTLOC(DeptID),"^",13)
	.Q:LocType'="OR"
	.s tmp="'id'^'name'"
	.s count = count+1
	.s Data=DeptID_"^"_LocDesc
	.s ret=ret_..SerializeJsonData(tmp,Data,count)
	s ret=ret_"]"
	Q ret
}

/// 获取时段
/// d ##class(web.DhcResEffDateSessionClass).GetTimeRange()
ClassMethod GetTimeRange()
{

	S count=0
	s ret="["
	s ID="" f  s ID=$o(^DHCTimeRange(ID)) q:ID=""  do
	.q:'$d(^DHCTimeRange(ID))
	.s DHCTimeRangeDesc=$P(^DHCTimeRange(ID),"^",2)
	.s tmp="'id'^'name'"
	.s count = count+1
	.s Data=ID_"^"_DHCTimeRangeDesc
	.s ret=ret_..SerializeJsonData(tmp,Data,count)
	s ret=ret_"]"
	Q ret
}

/// 获取职称
/// w ##class(web.DhcResEffDateSessionClass).GetSessionTypeStr()
ClassMethod GetSessionTypeStr() As %String
{
	s ret="[",count=0
	S RowId=0 f  s RowId=$O(^RBC("SESS",RowId)) Q:(RowId="")  d
	.s Desc=$P(^RBC("SESS",RowId),"^",2)
	.s tmp="'id'^'name'"
	.s count = count+1
	.s Data=RowId_"^"_Desc
    .s ret=ret_..SerializeJsonData(tmp,Data,count)
	s ret=ret_"]"
	Q ret
}

/// 公共json序列化方法
ClassMethod SerializeJsonData(Title As %String, Data As %String, Count As %String) As %String
{
	n (Title,Data,Count)
	s len=$length(Title,"^")
	s jsonData=""
	i Count>1 s jsonData=","
	f i=1:1:len d
	.s Index=$p(Title,"^",i)
	.s IndexData=$p(Data,"^",i)
	.i i=1 s jsonData=jsonData_"{"_Index_":'"_IndexData_"'"
	.e  s jsonData=jsonData_","_Index_":'"_IndexData_"'"
	s jsonData=jsonData_"}"
	q $tr(jsonData,$c(39),$c(34))
}

/// 排班审核查询界面新版
Query GetApptSchedule(Loc As %String, Doc As %String, DOW1 As %String, DOW2 As %String, userid As %String = "", groupid As %String = "", ResID As %String = "", ExaID As %String = "") As %Query(ROWSPEC = "LocDesc :%String,DocDesc :%String,ASSessionType :%String,TimeRange :%String,ASRoom :%String,ASQueueNoCount :%String,ASAppLoad :%String,ASLoad :%String,AddLoad :%String,LoginTime :%String,LoginStatus:%String,RBDSROWID:%String,ScheduleGenerFlag:%String,AutoLoad:%String,ExtLoad:%String,ASAppStart:%String")
{
}

// D ##class(%ResultSet).RunQuery("web.DhcResEffDateSessionClass","GetApptSchedule",54,"","星期一",1,1,1,"",54)

ClassMethod GetApptScheduleExecute(ByRef qHandle As %Binary, Loc As %String, Doc As %String, DOW1 As %String, DOW2 As %String, userid As %String = "", groupid As %String = "", ResID As %String = "", ExaID As %String = "") As %Status
{
	s ^tempGetApptScheduleExecute1=Loc_","_Doc_","_DOW1_","_DOW2_","_userid_","_groupid_","_ResID_","_ExaID
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i Loc'=""  {
	  s CTLocDateTo=$p($g(^CTLOC(Loc)),"^",25)
	  i (CTLocDateTo'="")&&(CTLocDateTo<+$h) Quit $$$OK
	}
	s DefaultLoc=102 //%session.Get("LOGON.CTLOCID")
	/*s flag=0
	if groupid'="" {
		s groupdesc=$p($g(^SSU("SSGRP",groupid)),"^",1)
		if groupdesc["门办" s flag=1
	}*/
	// 按操作员诊区对照限制
	s DepStr="" 
	if ExaID'="" {
		//未进行诊区科室对照的科室列表
		if (ExaID="Other"){
			s AdmTypeStr="O^E"
			for i=1:1:$l(AdmTypeStr,"^"){
				s AdmType=$p(AdmTypeStr,"^",i)
				s myrowid=0
				for  {
					s myrowid=$o(^PAC("ADMLOC",0,"AdmType",AdmType,myrowid)) 
					q:myrowid=""
					if '$d(^CTLOC(myrowid)) continue
					continue:$d(^User.DHCExaBorDepI("BordDepDrIndex"," "_myrowid))
					s DepDateTo=$p($g(^CTLOC(myrowid)),"^",25)
					continue:(DepDateTo'="")&&(DepDateTo<+$H)
					continue:("^"_DepStr_"^")[("^"_myrowid_"^")
					if DepStr="" s DepStr=myrowid
					else  s DepStr=DepStr_"^"_myrowid
				}
			}
		}else{
			s ExaBorough=ExaID
			d GetDepStr
		}
		
	}elseif userid'="" {
	 	s BoruID="" f  s BoruID=$o(^User.DHCBorUserI("BoruUseDrIndex"," "_userid,BoruID)) q:BoruID=""  do
		.s ExaBorough=$list(^User.DHCBorUserD(BoruID),2)
		.q:ExaBorough=""
		.s DHCExaBorDep=$o(^User.DHCExaBorDepI("BordDepDrIndex"," "_DefaultLoc,""))
		.q:DHCExaBorDep=""
		.s ExaBoroughExp=$list(^User.DHCExaBorDepD(DHCExaBorDep),6)
		.//q:(ExaBorough'=ExaBoroughExp)&&(ExaBoroughExp'="")&&(flag'=1)	
		.d GetDepStr
	}
	If (ResID'="") {
		d sdsd(ResID)
	}elseif (Loc'=""){
		s RBRowId="" f  s RBRowId=$o(^RB("RES",0,"CTLOC",Loc,RBRowId)) Q:RBRowId=""  d 
		.d sdsd(RBRowId)
	}elseif (ExaID'=""){
		for i=1:1:$length(DepStr,"^"){
			s Loc=$p(DepStr,"^",i)
			continue:Loc=""
			s RBRowId="" f  s RBRowId=$o(^RB("RES",0,"CTLOC",Loc,RBRowId)) Q:RBRowId=""  d 
			.d sdsd(RBRowId)
		}
	}else{ 
		s RBRowId=0
		for  Set RBRowId=$o(^RBAS(RBRowId)) Quit:RBRowId=""  do
		.d sdsd(RBRowId)
	}	
	s qHandle=$lb(0,repid,0) 
	Quit $$$OK

GetDepStr
	s ID="" f  s ID=$o(^User.DHCExaBorDepI("BordBorDrIndex",ExaBorough,ID)) q:ID=""  do
	.s DeptID=$list(^User.DHCExaBorDepD(ID),7)
	.q:DeptID="" 
	.q:'$d(^CTLOC(DeptID))
	.s DepDateTo=$p($g(^CTLOC(DeptID)),"^",25)
	.Q:(DepDateTo'="")&&(DepDateTo<+$H)
	.q:("^"_DepStr_"^")[("^"_DeptID_"^")
	.if DepStr="" s DepStr=DeptID
	.else  s DepStr=DepStr_"^"_DeptID
	quit
	
sdsd(RBID)
  	if RBID'="" do
  	.s ScheSt=$p(^RB("RES",RBID),"^",6)
  	.s DateTo=$p(^RB("RES",RBID),"^",19)
  	.//Quit:(DateTo'="")&&(DateTo<(+$h))
	.//q:ScheSt'="Y"
  	.s REDSub=""
	.f  s REDSub=$O(^RB("RES",RBID,"DATE",REDSub),-1) q:REDSub=""  d
	..s REDSSub=0
	..f  s REDSSub=$O(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub)) q:REDSSub=""  d
	...S rebrowid=RBID_"||"_REDSub_"||"_REDSSub
	...s LocDr=$p(^RB("RES",RBID),"^",1)
	...s locDesc=$p(^CTLOC(LocDr),"^",2)
	...s Docdr=$p(^RB("RES",RBID),"^",2)
	...q:(Doc'="")&&(Docdr'=Doc)
	...s ActiveFlag=$p($g(^CTPCP(Docdr,1)),"^",9)
	...Q:ActiveFlag'="Y"
	...s DocDateTo=$p($g(^CTPCP(Docdr,2)),"^",15)
	...q:(DocDateTo'="")&&(DocDateTo<+$h)
	...S DocDesc=$p(^CTPCP(Docdr,1),"^",2)
	...s ASSessionType=""
	...s ASSessionTypeDR=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",9)
	...i ASSessionTypeDR'="" s ASSessionType=$p(^RBC("SESS",ASSessionTypeDR),"^",2)
	...s ASTimeRangeDR=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",3)
	...q:ASTimeRangeDR=""
	...s ASRoom=""
	...s TimeRange=$p(^DHCTimeRange(ASTimeRangeDR),"^",2)
	...s ASRoomDr=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",19)
	...i ASRoomDr'="" s ASRoom=$p(^CTLOC(ASRoomDr),"^",2)
	...s ASAppLoad=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",1)  ;预约 
	...s ASAppStart=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",21)  ;预约起始号
	...s ASReason=""
	...s ASLoad=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",8) ;正号
	...s SESSDOWDR=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",2) ;周
	...s DowName=""
	...if SESSDOWDR'="" do
	....S DowName=$P(^CT("DOW",1,SESSDOWDR),"^",1)
	...s SESSHoliDOWDR=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",41) //假日排班
	...q:(DOW2<=7)&&(SESSDOWDR'=DOW2)
	...q:(DOW2>7)&&(SESSHoliDOWDR'=DOW2)
	...;w RBID_"||"_REDSub_"||"_REDSSub_","
	...//q:(DOW1'="")&(DowName'=DOW1)&&(DOW2<=7)
	...//q:(DOW2>7)&&(SESSDOWDR'="")
	...//q:(DOW2>7)&&(DOW2'="")
	
	...s AddLoad=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",14)         ;加号
    ...s ScheduleGenerFlag=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",16)
    ...i ScheduleGenerFlag="Y" s ScheduleGenerFlag=1
    ...e  s ScheduleGenerFlag=0                                    
	...S ASQueueNoCount = AddLoad + ASLoad //ASAppLoad + AddLoad + ASLoad
	...s LoginStr=##class(web.DHCApptScheduleNew).GetUserLoginTime(LocDr,Docdr,ASTimeRangeDR,+$h)  
	...s DocDesc=##class(web.DHCOPAdmReg).CutLetter(DocDesc) 
	...s LoginTime=$p(LoginStr,"^",1)
    ...s LoginStatus=$p(LoginStr,"^",2)
    ...s str=$g(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub,"DHC"))
    ...if ($p(str,"^",1)'="Y")&&($p(str,"^",1)'="N") s ^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub,"DHC")=""
    ...s AutoLoad="" //$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub,"DHC"),"^",8)
    ...s ExtLoad="" //$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub,"DHC"),"^",9)
    ...Set data = $lb(locDesc,DocDesc,ASSessionType,TimeRange,$g(ASRoom),ASQueueNoCount,ASAppLoad,ASLoad,AddLoad,LoginTime,LoginStatus,rebrowid,ScheduleGenerFlag,AutoLoad,ExtLoad,ASAppStart)
	...set ^CacheTemp(repid,ind)=data
	...set ind=ind+1       
    q
}

ClassMethod GetApptScheduleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApptScheduleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 }
	 Else      {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetApptScheduleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApptScheduleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryGetLocByBoruID(BoruID As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String") [ SqlProc ]
{
}

// D ##class(%ResultSet).RunQuery("web.DhcResEffDateSessionClass","QueryGetLocByBoruID","1")

ClassMethod QueryGetLocByBoruIDExecute(ByRef qHandle As %Binary, BoruID As %String) As %Status
{

	s ind=1
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)

	q:BoruID="" $$$OK
	s ID="" f  s ID=$o(^User.DHCExaBorDepI("BordBorDrIndex",BoruID,ID)) q:ID=""  do
	.s DeptID=$list(^User.DHCExaBorDepD(ID),7)
	.q:DeptID="" 
	.q:'$d(^CTLOC(DeptID))
	.s LocDesc=$P(^CTLOC(DeptID),"^",2)
	.;s tmp="'id'^'name'"
	.;s count = count+1
	.;s Data=DeptID_"^"_LocDesc
	.;s ret=ret_..SerializeJsonData(tmp,Data,count)
    .d test	   
test
    Set data = $lb(DeptID,LocDesc)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1       
    q $$$OK
}

ClassMethod QueryGetLocByBoruIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGetLocByBoruIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 }
	 Else      {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryGetLocByBoruIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGetLocByBoruIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 获取假日模板星期名称
ClassMethod GetHoliDOWDesc(HoliDOWDR) As %String
{
	i HoliDOWDR=8 q "假日模板一"
	i HoliDOWDR=9 q "假日模板二"
	i HoliDOWDR=10 q "假日模板三"
	i HoliDOWDR=11 q "假日模板四"
	i HoliDOWDR=12 q "假日模板五"
	i HoliDOWDR=13 q "假日模板六"
	i HoliDOWDR=14 q "假日模板七"
}

}
