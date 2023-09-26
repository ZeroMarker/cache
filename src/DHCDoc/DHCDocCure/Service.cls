/// Desc:his调用治疗站接口方法类
Class DHCDoc.DHCDocCure.Service Extends %RegisteredObject
{

/// 判断医嘱是否是治疗项目
/// w ##class(DHCDoc.DHCDocCure.Service).CheckItem("8935||1")
ClassMethod CheckItem(ItemMastId As %String, LocId As %String, HospID As %String = "")
{
	Q ##class(DHCDoc.DHCDocCure.Apply).CheckItem(ItemMastId,LocId,HospID)
}

/// 自动生成治疗申请单
ClassMethod SaveDHCDocCureApply(EpisodeID As %String, OrdItemStr As %String, UserID As %String) As %String
{
    f k=1:1:$l(OrdItemStr,"^")-1 {
		s OrdID=$p($p(OrdItemStr,"^",k),"*",2)
		i OrdID="" continue
		s DCARowId=$o(^DHCDocCure(0,"OEORI",OrdID,""))
		;8.3版本治疗申请是先插入的,医嘱插入完成后将医嘱与治疗申请进行关联
		if (DCARowId=""){
			s ArcimID=$P($G(^OEORD(+OrdID,"I",$P(OrdID,"||",2),1)),"^",2)
			s ReLocId=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),3)),"^",6)
			set OrderAddDeptDr="",HospID=""
			Set OrderAddDeptDr=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),7)),"^",2)
			if OrderAddDeptDr'=""{
				s HospID=$p(^CTLOC(OrderAddDeptDr),"^",22)	
			}
			s CureItemFlag=##class(DHCDoc.DHCDocCure.Apply).CheckItem(ArcimID,ReLocId,HospID)
			;取用是否手动申请配置
			s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ArcimID,HospID)
			s ManualApply=""
			if DDCISRowid'=""{
				s ManualApply=$p(^DHCDocCureItemSet(DDCISRowid),"^",8)
			}
			if (CureItemFlag=1)&&(ManualApply'="Y"){
				d ##class(DHCDoc.DHCDocCure.Apply).CreateCureApply(EpisodeID,OrdID,UserID,"",HospID)
			}
      	}
    }
    Q 0
}

/// Desc:判断治疗医嘱是否无需生成执行记录，在预约时按治疗预约记录生成对应的医嘱执行记录
/// Output:0 需要生成执行记录 1 不需要生成
ClassMethod GetCureAppGenFlag(OEORIRowId) As %Boolean
{
	;走治疗申请单的临时治疗项目不生成执行记录,长期继续产生执行记录)
	s EpisodeID=$P(^OEORD(+OEORIRowId),"^",1)
	s ADMHOSPID=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	;配置了预约允许直接执行，则全部生成执行记录
	s CurerRecLocID=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),3)),"^",6)
	;Modify:20221012  默认全部预约允许直接执行，开医嘱正常生成执行记录
	;配置已默认固定返回1，实际CureItemIsGenExe方法已调用不到
	s DHCDocCureAppointAllowExec=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig("","CureLocAppAllowExec",CurerRecLocID)
	Q:DHCDocCureAppointAllowExec 0
	Q ##class(DHCDoc.DHCDocCure.Service).CureItemIsGenExe(OEORIRowId)
}

/// 判断治疗项目是否为直接执行项目
/// 1 不是直接执行,0 是直接执行
ClassMethod CureItemIsGenExe(OEORERowID)
{
	s NoExecFlag=0
	Q:OEORERowID="" NoExecFlag
	s UserAddLocId=$p($g(^OEORD(+OEORERowID,"I",$p(OEORERowID,"||",2),7)),"^",2)
	s OrdRecLocId=$p($g(^OEORD(+OEORERowID,"I",$p(OEORERowID,"||",2),3)),"^",6)
	s OrdDHCAADr=$p($g(^OEORD(+OEORERowID,"I",$p(OEORERowID,"||",2),"DHC")),"^",74)
	;OrdDHCAADr:本医嘱的治疗申请信息 & 主医嘱的治疗申请信息
	;治疗申请信息 治疗申请ID # 治疗评定申请ID
 	s DCARowId=$p(OrdDHCAADr,"&",1)
	if DCARowId'=""{
		s AssScaleID=$p(DCARowId,"#",2)
		if AssScaleID'="" Q NoExecFlag
	}
 	
 	s UserAddHospID="",RecLocHospID=""
 	if UserAddLocId'=""{
		s UserAddHospID=$p(^CTLOC(UserAddLocId),"^",22)	
	}
	if OrdRecLocId'=""{
		s RecLocHospID=$p(^CTLOC(OrdRecLocId),"^",22)	
	}
	s DocCureUseBase=##class(DHCDoc.DHCDocCure.VersionControl).UseBaseControl(RecLocHospID)
	Q:DocCureUseBase=1 NoExecFlag
	s ArcimId=$p($g(^OEORD(+OEORERowID,"I",$p(OEORERowID,"||",2),1)),"^",2)
 	s ReLocId=$p($g(^OEORD(+OEORERowID,"I",$p(OEORERowID,"||",2),3)),"^",6)
 	s priorityId=$p($g(^OEORD(+OEORERowID,"I",$p(OEORERowID,"||",2),1)),"^",8)
 	s IsLongFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(priorityId)
 	;Q:IsLongFlag=1 NoExecFlag
 	s PAAdmRowid=$p($g(^OEORD(+OEORERowID)),"^",1)
 	s PAADMType=##class(web.DHCDocOrderEntry).GetPAAdmType(PAAdmRowid)
	;取用是否预约直接执行;
	s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ArcimId,RecLocHospID)
	s ApplyExecFlag="",IPApplyExecFlag=""
	if DDCISRowid'=""{
 		;治疗医嘱维护的直接执行标志
		s ApplyExecFlag=$p($g(^DHCDocCureItemSet(DDCISRowid)),"^",9)
		s IPApplyExecFlag=$p($g(^DHCDocCureItemSet(DDCISRowid)),"^",11)
	}
	s CureItemFlag=..CheckItem(ArcimId,ReLocId,UserAddHospID)
	i CureItemFlag=1{
		if (PAADMType'="I")&&(ApplyExecFlag'="Y") s NoExecFlag=1
		if (PAADMType="I")&&(IPApplyExecFlag'="Y") s NoExecFlag=1
	}
	s DCARowId=$p($p(OrdDHCAADr,"&",2),"#",1)
	if DCARowId'=""{
		;主医嘱不生成则本医嘱也不生成
		s AppExecFlag=$p($g(^DHCDocCure(DCARowId)),"^",19)
		if AppExecFlag'="Y" s NoExecFlag=1
	}
	
	Q NoExecFlag
}

ClassMethod CancelCureApplyByStopOrd(OEORDRowId As %String, UserID As %String, ByRef ErrMsg As %String = "")
{
	s ret=##class(DHCDoc.DHCDocCure.Apply).CancelCureApplyByStopOrd(OEORDRowId,UserID,.ErrMsg)
	Q ret
}

ClassMethod GetExecCureAppStatus(OEORERowId As %String)
{
	s ret=##class(DHCDoc.DHCDocCure.Appointment).GetExecCureAppStatus(OEORERowId)
	Q ret
}

ClassMethod AppCancelHUI(DCAARowId As %String, UserDR As %String = "", SpecFlag As %String = "")
{
	s ret=##class(DHCDoc.DHCDocCure.Appointment).AppCancelHUI(DCAARowId,UserDR,SpecFlag)
	Q ret
}

ClassMethod GetCureAppListNum(EpisodeID As %String)
{
	s ListNum=0
	s rset=##Class(%ResultSet).%New("DHCDoc.DHCDocCure.Apply.FindEMRCureApplyList")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(EpisodeID)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		if (columns=0) Quit
		While (rset.Next()) {
			s ListNum=ListNum+1
		}
	}
	Q ListNum
}

/// w ##Class(DHCDoc.DHCDocCure.Service).GetCureAppGridData(35)
ClassMethod GetCureAppGridData(EpisodeID As %String) As %String
{
	s $ZT="GetCureAppGridDataErr"
	s ^tmpnk("GetCureAppGridData")=EpisodeID
	s rset=##Class(%ResultSet).%New("DHCDoc.DHCDocCure.Apply.FindEMRCureApplyList")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(EpisodeID)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		if (columns=0) Quit
		While (rset.Next()) {
			s DCARowId=rset.GetData(1)
			s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
			s StatusCode=$CASE(ApplyStatus,"A":"A","D":"A","F":"B",:"C")
			s Info=""
			for i=1:1:columns{
				if (i=1){
					s Info=rset.GetData(i)
				}else{
					s Info=Info_$C(2)_rset.GetData(i)
				}
			}
			s CureAppInfo(StatusCode,DCARowId)=Info
		}
	}
	s JsonObj=[]
	s Index=1
	s StatusCode=""
	for {
		s StatusCode=$O(CureAppInfo(StatusCode))
		q:StatusCode=""
		s ApplyStatus=""
		s JsonData={}
		s SubJsonObj=[]
		s Sub=""
		for {
			s Sub=$O(CureAppInfo(StatusCode,Sub))
			q:Sub=""
			s Val=CureAppInfo(StatusCode,Sub)
			//DCARowId,PatNo,PatName,PatSex,PatAge,PatTel,AdmType,AdmDep,ArcimDesc,OrdQty,
			;OrdBillUOM,OrdReLoc,ApplyStatus,ApplyUser,ApplyDateTime,
			;ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,OrdPrice,
			;OrdBilled,ServiceGroup,ServiceGroupID,CallStatus,ApplyExec,
			;ControlFlag,HistoryTriRes,PatOther,OrdUnitPrice,ApplyNo,
			;OrdReLocId,OrdOtherInfo,ApplyPlan,ApplyAssessment
			s DCARowId=$P(Val,$C(2),1)
			s AdmType=$P(Val,$C(2),7)
			s AdmDep=$P(Val,$C(2),8)
			s ArcimDesc=$P(Val,$C(2),9)
			s OrdQty=$P(Val,$C(2),10)
			s OrdBillUOM=$P(Val,$C(2),11)
			s OrdReLoc=$P(Val,$C(2),12)
			s ApplyStatus=$P(Val,$C(2),13)
			s ApplyUser=$P(Val,$C(2),14)
			s ApplyDateTime=$P(Val,$C(2),15)
			s ApplyAppedTimes=$P(Val,$C(2),16)
			s ApplyNoAppTimes=$P(Val,$C(2),17)
			s ApplyFinishTimes=$P(Val,$C(2),18)
			s ApplyNoFinishTimes=$P(Val,$C(2),19)
			s OrdPrice=$P(Val,$C(2),20)
			s OrdBilled=$P(Val,$C(2),21)
			s ServiceGroup=$P(Val,$C(2),22)
			s OrdUnitPrice=$P(Val,$C(2),29)
			s ApplyNo=$P(Val,$C(2),30)
			s OrdOtherInfo=$P(Val,$C(2),32)
			s ApplyPlan=$P(Val,$C(2),33)
			s ApplyAssessment=$P(Val,$C(2),34)
			s ApplyDateTime=##class(ext.util.String).EvalJSON(ApplyDateTime)
			s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
			s OrdOtherInfo=##class(ext.util.String).EvalJSON(OrdOtherInfo)
			s Index=Index+1
			d InitJsonData
			do JsonData.%Set("Index",Index)
			do JsonData.%Set("DCARowId",DCARowId),JsonData.%Set("AdmType",AdmType)
			do JsonData.%Set("AdmDep",AdmDep),JsonData.%Set("ArcimDesc",ArcimDesc)
			do JsonData.%Set("OrdQty",OrdQty),JsonData.%Set("OrdBillUOM",OrdBillUOM)
			do JsonData.%Set("OrdReLoc",OrdReLoc),JsonData.%Set("ApplyStatus",ApplyStatus)
			do JsonData.%Set("ApplyUser",ApplyUser),JsonData.%Set("ApplyDateTime",ApplyDateTime)
			do JsonData.%Set("ApplyAppedTimes",ApplyAppedTimes),JsonData.%Set("ApplyNoAppTimes",ApplyNoAppTimes)
			do JsonData.%Set("ApplyFinishTimes",ApplyFinishTimes),JsonData.%Set("ApplyNoFinishTimes",ApplyNoFinishTimes)
			do JsonData.%Set("OrdPrice",OrdPrice),JsonData.%Set("OrdBilled",OrdBilled)
			do JsonData.%Set("ServiceGroup",ServiceGroup),JsonData.%Set("OrdUnitPrice",OrdUnitPrice)
			do JsonData.%Set("ApplyNo",ApplyNo),JsonData.%Set("OrdOtherInfo",OrdOtherInfo)
			do JsonData.%Set("ApplyPlan",ApplyPlan),JsonData.%Set("ApplyAssessment",ApplyAssessment)
			do SubJsonObj.%Push(JsonData,"")
		}
		s Index=Index+1
		d InitJsonData
		do JsonData.%Set("Index",Index),JsonData.%Set("Title",ApplyStatus)
		s QueryJsonData=JsonData
		
		d QueryJsonData.%Set("children",SubJsonObj)
		do JsonObj.%Push(QueryJsonData,"")
	}
	s obj=##class(%Library.GlobalCharacterStream).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	//s JsonStr=$replace(JsonStr,"""","'")
	q JsonStr
InitJsonData
	s JsonData={}
	do JsonData.%Set("DCARowId",""),JsonData.%Set("AdmType","")
	do JsonData.%Set("AdmDep",""),JsonData.%Set("ArcimDesc","")
	do JsonData.%Set("OrdQty",""),JsonData.%Set("OrdBillUOM","")
	do JsonData.%Set("OrdReLoc",""),JsonData.%Set("ApplyStatus","")
	do JsonData.%Set("ApplyUser",""),JsonData.%Set("ApplyDateTime","")
	do JsonData.%Set("ApplyAppedTimes",""),JsonData.%Set("ApplyNoAppTimes","")
	do JsonData.%Set("ApplyFinishTimes",""),JsonData.%Set("ApplyNoFinishTimes","")
	do JsonData.%Set("OrdPrice",""),JsonData.%Set("OrdBilled","")
	do JsonData.%Set("ServiceGroup",""),JsonData.%Set("OrdUnitPrice","")
	do JsonData.%Set("ApplyNo",""),JsonData.%Set("OrdOtherInfo","")
	do JsonData.%Set("ApplyPlan",""),JsonData.%Set("ApplyAssessment","")
	q
GetCureAppGridDataErr
	q "[{'err':'"_$ZE_"'}]"
}

/// Desc:治疗执行CA认证时获取需加密的治疗记录信息
/// Debug:w ##Class(DHCDoc.DHCDocCure.Service).GetCureRecordXMLToCA("1||1")
ClassMethod GetCureRecordXMLToCA(DCRRowID)
{
	s RecordXML=""
	s RecordInfo=##class(DHCDoc.DHCDocCure.Record).GetCureRecord(DCRRowID)	
	Q:RecordInfo="" RecordXML
	s Object=##class(DHCDoc.DHCDocCure.Entity.Record).%New()
	s Object.DCRTitle=$p(RecordInfo,"^",3)
	s Object.DCRContent=$p(RecordInfo,"^",4)
	s Object.DCRCreateUserDR=$p(RecordInfo,"^",5)
	s Object.DCRCreateUserName=$p(RecordInfo,"^",6)
	s Object.DCRCreateDateTime=$p(RecordInfo,"^",7)
	s Object.DCRCureDateTime=$p(RecordInfo,"^",12)
	s Object.DCRResponse=$p(RecordInfo,"^",13)
	s Object.DCREffect=$p(RecordInfo,"^",14)
	s Object.DCRCureEndDateTime=$p(RecordInfo,"^",16)
	s Object.DCRLastUpdateUserName=$p(RecordInfo,"^",9)
	s Object.DCRLastUpdateDateTime=$p(RecordInfo,"^",10)
	s Object.DCRCurePOAID=$p(RecordInfo,"^",18)
	s Object.DCRActiveFlag=$p(RecordInfo,"^",20)
	s RecordXML=""
	d Object.XMLExportToString(.RecordXML)	
	Q RecordXML
}

/// Desc:治疗评估CA认证时获取需加密的治疗评估信息
/// Debug:w ##Class(DHCDoc.DHCDocCure.Service).GetCureAssessmentXMLToCA("4||1")
ClassMethod GetCureAssessmentXMLToCA(DCAssRowID)
{
	s AssXML=""
	s AssInfo=##class(DHCDoc.DHCDocCure.Assessment).GetCureAssessment(DCAssRowID)	
	Q:AssInfo="" AssXML

	s DCAssUserDr=$p($g(^DHCDocCure(+DCAssRowID,"ASS",$p(DCAssRowID,"||",2))),"^",1)
	s Object=##class(DHCDoc.DHCDocCure.Entity.Assessment).%New()
	s Object.DCAssCreateUserDR=DCAssUserDr
	s Object.DCAssCreateUserName=$p(AssInfo,"^",1)
	s Object.DCAssCreateDateTime=$p(AssInfo,"^",2)
	s Object.DCAssContent=$p(AssInfo,"^",3)
	s Object.DCAssLastUpdateUserName=$p(AssInfo,"^",4)
	s Object.DCAssLastUpdateDateTime=$p(AssInfo,"^",5)
	s Object.DCAssActiveFlag=$p(AssInfo,"^",7)
	s Object.DCAssContentJsonStr=$p(AssInfo,"^",9)
	s AssXML=""
	d Object.XMLExportToString(.AssXML)	
	Q AssXML
}

/// Desc:治疗评定CA认证时获取需加密的治疗评估信息
/// Debug:w ##Class(DHCDoc.DHCDocCure.Service).GetCureAssScaleXMLToCA("5")
ClassMethod GetCureAssScaleXMLToCA(RowID)
{
	s AssXML=""
	s AssInfo=##class(DHCDoc.DHCDocCure.AssScale).GetAssScoreInfo(RowID)
	if AssInfo=""{
		Q AssXML
	}
	
	;set Info=DCASAdmDr_"^"_DCASPatientDr_"^"_DCASDate_"^"_DCASTime_"^"_DCASUserDr
	;set Info=Info_"^"_DCASUser_"^"_DCASType_"^"_DCASAssScaleDR_"^"_DCASAssScaleDesc_"^"_DCASScoreVal
	;set Info=Info_"^"_DCASOEORIDR_"^"_DCASStatus
	s DCASFormJsonStr=##Class(DHCDoc.DHCDocCure.AssScale).JsGetFormItem(RowID)
	s Object=##class(DHCDoc.DHCDocCure.Entity.AssScore).%New()
	s Object.DCASCreateUserDR=$p(AssInfo,"^",5)
	s Object.DCASCreateUserName=$p(AssInfo,"^",6)
	s Object.DCASCreateDateTime=$p(AssInfo,"^",3)_" "_$p(AssInfo,"^",4)
	s Object.DCASScoreID=$p(AssInfo,"^",8)
	s Object.DCASScoreVal=$p(AssInfo,"^",10)
	s Object.DCASStatus=$p(AssInfo,"^",12)
	s Object.DCASFormJsonStr=DCASFormJsonStr
	s AssXML=""
	d Object.XMLExportToString(.AssXML)	
	Q AssXML
}

/// Desc:治疗相关CA认证时获取需加密的XML信息
/// Debug:w ##Class(DHCDoc.DHCDocCure.Service).GetCureAssessmentXMLToCA("4||1")
ClassMethod GetCureXMLToCA(RowID As %String, ByRef OperationType As %String)
{
	s XmlInfo=""
	if ((OperationType="CureRecord")||(OperationType="CancelCureRecord")){
		s XmlInfo=..GetCureRecordXMLToCA(RowID)
		s OperationType=$case(OperationType,"CureRecord":"CR","CancelCureRecord":"CCR")
	}elseif ((OperationType="CureAss")||(OperationType="DelCureAss")){
		s XmlInfo=..GetCureAssessmentXMLToCA(RowID)
		s OperationType=$case(OperationType,"CureAss":"CA","DelCureAss":"DCA")
	}elseif ((OperationType="CureScale")||(OperationType="CancelCureScale")){
		s XmlInfo=..GetCureAssScaleXMLToCA(RowID)
		s OperationType=$case(OperationType,"CureScale":"CS","CancelCureScale":"DCS")
	}
	q XmlInfo
}

/// 长期治疗自动预约
/// d ##class(DHCDoc.DHCDocCure.Service).LongCureAppTask()
ClassMethod LongCureAppTask(adm As %String, day As %String = "")
{
	s $zt="AppTaskErr"
	s:day="" day=+$h
	k TaskPatAry
	if adm=""{
		for {
			s adm=$o(^PAADMi("AdmTypeCurr","I",adm)) 
			q:adm=""
			d oneAdm
		}
	}else{
		d oneAdm
	}
	s PatientID=""
	for{
		s PatientID=$o(TaskPatAry(PatientID))
		s PreInfoStr=TaskPatAry(PatientID)
		s len=$l(PreInfoStr,$c(1))
		;w PreInfoStr,!
		for j=1:1:len {
			s PreInfo=$p(PreInfoStr,$c(1),j)
			s PreASRowId=$p(PreInfo,"^",1)
			s PreTimeRange=$p(PreInfo,"^",2)
			s PreUser=$p(PreInfo,"^",3)
			
			s CurrASRowId=$$GetASRowId(PreASRowId,PreTimeRange,day)
			;b:PreASRowId=10660
			continue:CurrASRowId=""
			s DDCRSLocDR=$p($g(^DHCDocCureRBCResSchdule(CurrASRowId)),"^",2)  //排班科室ID
			s RecLocHospID=$p(^CTLOC(DDCRSLocDR),"^",22)	
			s ExpStr=PreUser_"^^"_RecLocHospID
			s ret=##class(DHCDoc.DHCDocCure.AppointmentV2).AppInsert(PatientID,CurrASRowId,"LA","",PreTimeRange,"",ExpStr)
			if +ret'=0 {
				s ^DHCTASKCureApp("Error",PatientID,day)=ret
			}
		}	
	}
	q 0
oneAdm		
	s PatientID=$p($g(^PAADM(+adm)),"^",1)
	Q:PatientID=""
	s DCARowId="" 
	for {
		s DCARowId=$o(^DHCDocCure(0,"Adm",adm,DCARowId))
		q:DCARowId=""
		q:$d(TaskPatAry(PatientID))
		s OrderID=$p(^DHCDocCure(DCARowId),"^",2)
		continue:OrderID=""
		s Priority=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),1),"^",8)
		s IsLong=##class(appcom.OEOrdItem).ISLongOrderPrior(Priority)
		continue:IsLong'=1
		s Status=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),1),"^",13)
		s:Status'="" Status=$p(^OEC("OSTAT",Status),"^",1)
		continue:(Status="D")!(Status="C")!(Status="U")
		s PreInfoStr=$$GetPreDayASRowId(PatientID, day-1, "")
		continue:PreInfoStr=""
		s TaskPatAry(PatientID)=PreInfoStr
	}
	Q
	
GetPreDayASRowId(PatientID, Day, Time)
	s RBASIDStr="",QueNo="",TimeRange="", UserId=""
	s QueId=0 
	for{
		s QueId=$o(^User.DHCDocCureQueueI("IndexPAPMI",PatientID,QueId))
		q:QueId=""
		s QueDate=$lg(^User.DHCDocCureQueueD(QueId),5)
		continue:(QueDate'=Day)
		s QueState=""
		s QueStatusDr=$lg(^User.DHCDocCureQueueD(QueId),9)
		s:QueStatusDr'="" QueState=$p($g(^DHCDocCurePS(QueStatusDr)),"^",1)
		continue:QueState="Cancel"
		s RBASID=$lg(^User.DHCDocCureQueueD(QueId),2)
		s QueNo=$lg(^User.DHCDocCureQueueD(QueId),4)
		s UserId=$lg(^User.DHCDocCureQueueD(QueId),7)
		s TimeRange=##class(DHCDoc.DHCDocCure.ScheduleTR).GetTimeRange(RBASID,QueNo)
		if RBASIDStr="" s RBASIDStr=RBASID_"^"_TimeRange_"^"_UserId
		else  s RBASIDStr=RBASIDStr_$c(1)_RBASID_"^"_TimeRange_"^"_UserId
	}
	q RBASIDStr
	
GetASRowId(RBASId,TimeRange,ResDate)
	s Res=$p(^DHCDocCureRBCResSchdule(RBASId),"^",3)
	s Loc=$p(^DHCDocCureRBCResSchdule(RBASId),"^",2)
	s NewRowId="", NewTimeRange="", StTime="", EdTime=""
	if TimeRange'="" {
		s StTime=$p(TimeRange,"-",1)
		s StTime=$zth(StTime)
		s EdTime=$p(TimeRange,"-",2)
		s EdTime=$zth(EdTime)
	}else{
		s StTime = $p(^DHCDocCureRBCResSchdule(RBASId),"^",6)
		s EdTime = $p(^DHCDocCureRBCResSchdule(RBASId),"^",7)
	}
	s ASRowId=0 f {
		s ASRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",Loc,Res,ResDate,ASRowId))
		q:ASRowId=""
		s Active=$p(^DHCDocCureRBCResSchdule(ASRowId),"^",9)
		continue:Active'="N"
		s SttTime=$p(^DHCDocCureRBCResSchdule(ASRowId),"^",6)
		s EddTime=$p(^DHCDocCureRBCResSchdule(ASRowId),"^",7)
		continue:(SttTime>StTime)&&(StTime'="")
		continue:(EddTime<EdTime)&&(EdTime'="")
		s NewRowId=ASRowId
		q
	}
	q NewRowId
	
AppTaskErr
	s $zt=""
	q $ze
}

}
