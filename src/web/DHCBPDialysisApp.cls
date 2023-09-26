Import User

Class web.DHCBPDialysisApp Extends web.DHCClinicCom
{

/// Descript:格式化Json数据串
ClassMethod getJsonData(ListTitle As %String, ListData As %String, Deli As %String = "^") As %String
{
	//N (ListTitle,ListData,Deli)
	S del=""""
	S jsonStr=""
	S HLen=$L(ListTitle,Deli)  //列
	S DLen=$L(ListData,Deli) //值
	F i=1:1:HLen  d
	.S Name=$p(ListTitle,Deli,i)
	.S value=$p(ListData,Deli,i)
	.;s value = ##Class(ext.util.String).Replace(value,"\", "\\")
	.s value = ..EvalJSONNew(value)
	.S:value'["[{" value=del_value_del
	.i i=1 d
	..S jsonStr="{"_del_Name_del_":"_value
	.e  d
	..S jsonStr=jsonStr_","_del_Name_del_":"_value
	S jsonStr=jsonStr_"}"
	S jsonStr=$tr(jsonStr,$c(13,10))
	Q jsonStr
}

/// 按标准JSON来处理字符转义
ClassMethod EvalJSONNew(instr As %String) As %String
{
	s mystr = instr
	q:(mystr="") mystr
	s mystr = ..Replace(mystr,"\", "\\")
	s mystr = ..Replace(mystr,"""", "\""")
	s mystr = ..Replace(mystr,$c(8), "\b") 			// 退格(BS)
	s mystr = ..Replace(mystr,$c(9), "\t")
	s mystr = ..Replace(mystr,$c(10), "\n")
	s mystr = ..Replace(mystr,$c(12), "") // FF(NP from feed, new page)
	s mystr = ..Replace(mystr,$c(13), "\r")
	s mystr = ..Replace(mystr,$c(14), "") //SO(shift out)  
	s mystr = ..Replace(mystr,$c(0), "")
	q mystr
}

/// Descript:获取病人基本就诊信息
/// W ##Class(web.DHCBPDialysisApp).GetPatEssInfo("","2")
ClassMethod GetPatEssInfo(PatientID As %String, EpisodeID As %String) As %String
{
	//n (PatientID, EpisodeID)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)  /// 出生日期
	s PatAge=..CalAge(PatBDay,+$h) //年龄
	s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") /// 诊断
	i $L(PatDiagDesc)>80 s PatDiagDesc=$E(PatDiagDesc,1,50)_"..."
	s PatType=$p(^PAADM(EpisodeID),"^",2) 	           /// 就诊类型
	s EncryptLevelInfo=""
 	s EncryptLevel=""
 	s PatLevel=$p(EncryptLevelInfo,"^",2)
 	s mradm=$p(^PAADM(EpisodeID),"^",61)          	  /// 就诊类型
    s BedId=$p($g(^PAADM(EpisodeID)),"^",73)
    s BedSub=$p(BedId,"||",2)
    s PatBed=$p($g(^PAWARD(+BedId,"BED",+BedSub)),"^",1)  /// 床号
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)

	s ListData=PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_$g(PatSex)_"^"_PatAge_"^"_PatBDay_"^"_PatDiagDesc_"^"_PatType_"^"_EncryptLevel_"^"_PatLevel_"^"_mradm_"^"_PatBed_"^"_BillType
	
	s ListTitle="PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatBDay^PatDiagDesc^PatType^PatSLv^PatLv^mradm^PatBed^PatBill"
	w ..getJsonData(ListTitle,ListData)
	q ""
}

ClassMethod SaveBPDialysisApp(arrangePara, anticoagulantPara)
{
	//W ##Class(web.DHCBPDialysisApp).SaveBPDialysisApp("123","HBV",3879,"A","20/08/2019")
	//s ^tempmfcbp("20200220")=arrangePara_";"_anticoagulantPara
	s obj=##class(Nur.JSON).Decode(arrangePara)
	s admId=obj.GetAt("admId")
	s dialysisApp="",result=""
	//s admId=$p(appInfoPara,$c(3),1) //就诊号
	q:(admId="") result
	;q "手工返回"
	s papmiId=$p(^PAADM(admId),"^",1)
	//s userId=$p(appInfoPara,$c(3),2) //用户
	s ctlocId=$p(^PAADM(+admId),"^",4)
	//s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
	s wardId=$p($g(^PAADM(admId)),"^",70)
	//s wardDesc=$p($g(^PAWARD(+wardId)),"^",2)
	s bedId=$p($g(^PAADM(admId)),"^",73)
    //s bedSub=$p(bedId,"||",2)
    //s bedDesc=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",1)    
    //s appDate=$p(appInfoPara,$c(3),3) //透析日期
    s appDate=##class(web.DHCClinicCom).ConvertToDateH(obj.GetAt("appDate"))
    s appTime=$p($h,",",2) //透析时间
    s updateDate=+$h
    s updateTime=$p($h,",",2)    
    //s infectious=$p(appInfoPara,$c(3),4) //传染病
	s dialysisApp=##class(User.DHCBPDialysisApp).%New()
	s dialysisApp.AdmId=##class(User.PAAdm).%OpenId(admId)
	s dialysisApp.UserId=obj.GetAt("userId")
	//s userDesc=##class(web.DHCClinicCom).GetUserTypeName(userId)
	//s userDesc=$p(userDesc,"^",2)	
	s dialysisApp.LocId=ctlocId
	s dialysisApp.WardId=wardId
	s dialysisApp.BedId=bedId
	s dialysisApp.AppDate=appDate
	s dialysisApp.AppTime=appTime	
	s dialysisApp.UpdateDate=updateDate
	s dialysisApp.UpdateTime=updateTime	
	s dialysisApp.InfectiousDiseaseInfo=obj.GetAt("infectious")	
	s dialysisApp.Status=obj.GetAt("status")	
	s dialysisApp.DialysisStatus=obj.GetAt("dialysisStatus")
	s dialysisApp.ArrangePlan=obj.GetAt("arrangePlan")	
	s dialysisApp.VascularAccess=##class(User.DHCBPCVascularAccess).%OpenId(obj.GetAt("vascularAccess"))	
	s dialysisApp.BodySite=##class(User.DHCCLCBodySite).%OpenId(obj.GetAt("bodySite"))	
	s dialysisApp.AnticoagulantMode=##class(User.DHCBPCAnticoagulantMode).%OpenId(obj.GetAt("anticoagulantMode"))	
	s dialysisApp.AnticoagulantDrug=obj.GetAt("anticoagulantDrug")
	s dialysisApp.BloodPurificationMode=##class(User.DHCBPCBloodPurificationMode).%OpenId(obj.GetAt("bpMode"))	
	s planTherapyDuration=obj.GetAt("planTherapyDuration")
	i planTherapyDuration'="" s dialysisApp.PlanTherapyDuration=planTherapyDuration*60
	s dialysisApp.BFR=obj.GetAt("bpBFR")	
	s dialysisApp.DewaterAmount=obj.GetAt("dewaterAmount")
	s dialysisApp.K=obj.GetAt("bpK")	
	s dialysisApp.Ca2=obj.GetAt("bpCa2")	
	s dialysisApp.Na=obj.GetAt("bpNa")
	s dialysisApp.Note=obj.GetAt("bpNote")	
	s dialysisApp.PhoneNum=obj.GetAt("bpPhoneNum")
	TSTART
	s saveStatus=dialysisApp.%Save()
	i +saveStatus=0 TROLLBACK  q "保存数据失败!"
	s result=dialysisApp.%Id()
	d dialysisApp.%Close()
	s result=##class(web.DHCBPDialysisApp).SaveAnticoagulantDrug(result,anticoagulantPara)
    i +result'=1 TROLLBACK  q "保存抗凝药品错误"
    TCOMMIT
	q result
}

ClassMethod SaveAnticoagulantDrug(dialysisAppId, anticoagulantPara)
{
	// w ##class(web.DHCBPDialysisApp).Save(paramStr)
	s d=##class(Nur.JSON).Decode(anticoagulantPara)	
	s drugs=d.GetAt("Drug")
	s count=drugs.Count()
	&sql(update DHC_BP_DiaAppAntDrug set BPDAAD_IfAbandon='Y' WHERE BPDAAD_BPDialysisApp_Dr=:dialysisAppId)
	For i=1:1:count  {
		s drug=drugs.GetAt(i)
		//s drugDesc=drug.GetAt("DrugDesc")
		s drugId=drug.GetAt("DrugId")
		//s drugDataId=drug.GetAt("DrugDataId")
		s options=drug.GetAt("Options")
		
		s drugObj=##class(User.DHCBPDiaAppAntDrug).%New()
		s drugObj.BPDAADIfAbandon="N"
		s drugObj.BPDAADBPDialysisAppDr=##class(User.DHCBPDialysisApp).%OpenId(dialysisAppId)
		s drugObj.BPDAADBPCADDr=##class(User.DHCBPCAnticoagulantDrug).%OpenId(drugId)
		For j=1:1:options.Count() {
			s option=options.GetAt(j)
			s code=option.GetAt("Code")
			s value=option.GetAt("Value")
			if (code="Duration") s drugObj.BPDAADDuration=value
			if (code="Dose") s drugObj.BPDAADDose=value
			if (code="Amount") s drugObj.BPDAADAmount=value
			if (code="FirstAmount") s drugObj.BPDAADFirstAmount=value
			if (code="Frequency") s drugObj.BPDAADFrequency=value
			if (code="IntervalMinute") s drugObj.BPDAADIntervalMinute=value
			if (code="Note") s drugObj.BPDAADNote=value
		}
		d drugObj.%Save()
	}
	q "1"
}

ClassMethod UpdateBPDialysisApp(arrangePara, anticoagulantPara)
{
	s ^tempmfcbp("20200220")=arrangePara_";"_anticoagulantPara
	s obj=##class(Nur.JSON).Decode(arrangePara)
	s id=obj.GetAt("id")
	q:id="" "未选中已经申请的血液净化记录"
	//q:infectious="" "未选择传染病信息"
	s appDate=obj.GetAt("appDate") 
	q:appDate="" "未选择血液净化日期" 
	s dialysisApp="",result=""
	//s status=$lg($g(^User.DHCBPDialysisAppD(id)),15)
	//q:status'="A" "只能修改状态为申请的记录"
    s appDate=##class(web.DHCClinicCom).ConvertToDateH(appDate)
    s updateDate=+$h
    s updateTime=$p($h,",",2)    
    //s infectious=$p(appInfoPara,$c(3),4) //传染病
	s dialysisApp=##class(User.DHCBPDialysisApp).%OpenId(id)
	s dialysisApp.UserId=obj.GetAt("userId")	
	s dialysisApp.AppDate=appDate	
	s dialysisApp.UpdateDate=updateDate
	s dialysisApp.UpdateTime=updateTime
	s dialysisApp.InfectiousDiseaseInfo=obj.GetAt("infectious")
	s dialysisApp.DialysisStatus=obj.GetAt("dialysisStatus")
	s dialysisApp.ArrangePlan=obj.GetAt("arrangePlan")
	s dialysisApp.VascularAccess=##class(User.DHCBPCVascularAccess).%OpenId(obj.GetAt("vascularAccess"))	
	s dialysisApp.BodySite=##class(User.DHCCLCBodySite).%OpenId(obj.GetAt("bodySite"))	
	s dialysisApp.AnticoagulantMode=##class(User.DHCBPCAnticoagulantMode).%OpenId(obj.GetAt("anticoagulantMode"))	
	s dialysisApp.AnticoagulantDrug=obj.GetAt("anticoagulantDrug")	
	s dialysisApp.BloodPurificationMode=##class(User.DHCBPCBloodPurificationMode).%OpenId(obj.GetAt("bpMode"))	
	s planTherapyDuration=obj.GetAt("planTherapyDuration")
	i planTherapyDuration'="" s dialysisApp.PlanTherapyDuration=planTherapyDuration*60
	s dialysisApp.BFR=obj.GetAt("bpBFR")	
	s dialysisApp.DewaterAmount=obj.GetAt("dewaterAmount")
	s dialysisApp.K=obj.GetAt("bpK")	
	s dialysisApp.Ca2=obj.GetAt("bpCa2")	
	s dialysisApp.Na=obj.GetAt("bpNa")
	s dialysisApp.Note=obj.GetAt("bpNote")	
	s dialysisApp.PhoneNum=obj.GetAt("bpPhoneNum")		
	TSTART
	s saveStatus=dialysisApp.%Save()
	i +saveStatus=0 TROLLBACK  q "保存数据失败!"
	s result=dialysisApp.%Id()
	d dialysisApp.%Close()
	s result=##class(web.DHCBPDialysisApp).SaveAnticoagulantDrug(result,anticoagulantPara)
    i +result'=1 TROLLBACK  q "保存抗凝药品错误"
    TCOMMIT
	q result
}

ClassMethod DeleteBPDialysisApp(id, userId)
{
	//W ##Class(web.DHCBPDialysisApp).SaveBPDialysisApp("","HBV",3879)
	q:id="" "未选中已经申请的血液净化记录"
	s dialysisApp="",result=""
	s status=$lg($g(^User.DHCBPDialysisAppD(id)),15)
	q:status'="A" "只能删除状态为申请的记录"
    s updateDate=+$h
    s updateTime=$p($h,",",2)    
    //s infectious=$p(appInfoPara,$c(3),4) //传染病
	s dialysisApp=##class(User.DHCBPDialysisApp).%OpenId(id)
	s dialysisApp.UserId=userId	
	s dialysisApp.UpdateDate=updateDate
	s dialysisApp.UpdateTime=updateTime	
	s dialysisApp.Status="D"
	d dialysisApp.%Save()
	s result=dialysisApp.%Id()
	q result
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPDialysisApp","FindBPDialysisApp","","","26928910","40")
Query FindBPDialysisApp(fromDate As %String = "", toDate As %String = "", admId As %String = "", locId As %String = "", name As %String = "", patRegNo As %String = "", MedicareNo As %String = "") As %Query(ROWSPEC = "id,admId,patName,regNo,papmiMedicare,PatientID,patSex,patBirth,age,patAddress,patTelphone,personID,ctlocId,ctlocDesc,wardId,wardDesc,bedId,bedDesc,infectiousCode,infectiousDesc,status,statusDesc,appDate,appTime,userId,userDesc,updateDate,updateTime,dialysisStatus,dialysisStatusDesc,arrangePlan,arrangePlanDesc,vascularAccess,vascularAccessDesc,bodySite,bodySiteDesc,anticoagulantMode,anticoagulantModeDesc,anticoagulantDrug,bpMode,bpModeDesc,planTherapyDuration,bpBFR,dewaterAmount,bpK,bpCa2,bpNa,bpNote,bpPhoneNum")
{
}

ClassMethod FindBPDialysisAppExecute(ByRef qHandle As %Binary, fromDate As %String = "", toDate As %String = "", admId As %String = "", locId As %String = "", name As %String = "", patRegNo As %String = "", MedicareNo As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i fromDate'="" s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	i toDate'="" s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	if admId'=""   
	{	
 		s date=""
		f  s date=$o(^User.DHCBPDialysisAppI("AdmIndex",admId,date)) q:date=""  d
			.q:(fromDate'="")&&(date<fromDate)
			.q:(toDate'="")&&(date>toDate)
			.s time=""
			.f  s time=$o(^User.DHCBPDialysisAppI("AdmIndex",admId,date,time)) q:time=""  d
				..s rowId=""
				..f  s rowId=$o(^User.DHCBPDialysisAppI("AdmIndex",admId,date,time,rowId)) q:rowId=""  d
					...q:$$GetDialysisApp()<0
					...d OutputRow1
	}
	else
	{
		f curDate=fromDate:1:toDate d
			.s rowId=""
			.f  s rowId=$o(^User.DHCBPDialysisAppI("AppDate",curDate,rowId)) q:rowId=""  d
				..;w curDate_"/"_rowId,!
				..;q:(fromDate'="")&&(curDate<fromDate)
				..;q:(toDate'="")&&(curDate>toDate)
				..q:$$GetDialysisApp()<0
				..d OutputRow1
			
	}   
 	s qHandle=$lb(0,repid,0)
	q $$$OK
GetDialysisApp()
	q:rowId="" -1
	s id=rowId
	s status=$lg($g(^User.DHCBPDialysisAppD(rowId)),15)
	q:status="D" -2
	s admId=$lg($g(^User.DHCBPDialysisAppD(rowId)),1)
	s userId=$lg($g(^User.DHCBPDialysisAppD(rowId)),2)
	s userDesc=##class(web.DHCClinicCom).GetUserTypeName(userId)
	s userDesc=$p(userDesc,"^",2)	
	s ctlocId=$lg($g(^User.DHCBPDialysisAppD(rowId)),3)
	q:(locId'="")&&(locId'=ctlocId) -3
	s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)
	s papmiId=$p(^PAADM(admId),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	q:(name'="")&&(name'=patName) -4	
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	q:(patRegNo'="")&&(patRegNo'=regNo) -5
	s admType=""
	i admId'="" s admType=$p($g(^PAADM(admId)),"^",2)
	s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,admType,.ErrMsg)
	s ^dhcbpmfc(admId)= admId_"/"_admType_"/"_papmiMedicare_"/"_MedicareNo
	//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	q:(MedicareNo'="")&&(MedicareNo'=papmiMedicare) -6	
	s sexId=$p(^PAPER(papmiId,"ALL"),"^",7)    /// 姓别
	i sexId'="" s patSex=$p(^CT("SEX",sexId),"^",2)	
	
	s paersonLX=$p($g(^PAPER(papmiId,"PER",2)),"^",13) //联系人	
	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	s age=..CalAge(patBirth,+$h) //年龄
	i patBirth'="" s patBirth=$zd(patBirth,3)	//出生日期
	s personID=$p($G(^PAPER(papmiId,"ALL")),"^",9)  //身份证
	s patAddress=$g(^PAPER(papmiId,"PER","ADD",1)) //家庭住址
	
	s patTelphone=$p($g(^PAPER(papmiId,"PER",4)),"^",21)   //手机
	i patTelphone="" s patTelphone=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //家庭电话
	i patTelphone="" s patTelphone=$p($g(^PAPER(papmiId,"PER",1)),"^",9)    //工作电话

	s wardId=$lg($g(^User.DHCBPDialysisAppD(rowId)),4)
	s wardDesc=$p($g(^PAWARD(+wardId)),"^",2)				
	s bedId=$lg($g(^User.DHCBPDialysisAppD(rowId)),5)
	s bedSub=$p(bedId,"||",2)
    s bedDesc=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",1)
    			
    s appDate=$lg($g(^User.DHCBPDialysisAppD(rowId)),6)
    i appDate'="" s appDate=##class(web.DHCClinicCom).ConvertToDate(appDate)
    ;i appDate'="" s appDate=$zd(appDate,4)
    s appTime=$lg($g(^User.DHCBPDialysisAppD(rowId)),7)
    i appTime'="" s appTime=##class(web.DHCClinicCom).ConvertToTime(appTime)
    			    			
    s updateDate=$lg($g(^User.DHCBPDialysisAppD(rowId)),8)
    i updateDate'="" s updateDate=##class(web.DHCClinicCom).ConvertToDate(updateDate)
    //i updateDate'="" s updateDate=$zd(updateDate,4)
    s updateTime=$lg($g(^User.DHCBPDialysisAppD(rowId)),9)
    i updateTime'="" s updateTime=##class(web.DHCClinicCom).ConvertToTime(updateTime)
				
	s infectious=$lg($g(^User.DHCBPDialysisAppD(rowId)),11)
	s infectiousCode="",infectiousDesc="",code="",desc=""
	f i=1:1:$l(infectious,",") d
		.s code=$p(infectious,",",i)
		.i code="HBV" s desc="乙肝"
		.i code="HCV" s desc="丙肝"
		.i code="HIV" s desc="艾滋病"
		.i code="SP" s desc="梅毒"
		.i code="Negative" s desc="阴性"
    	.i infectiousCode="" s infectiousCode=code
    	.e  d  s infectiousCode=infectiousCode_","_code
		.i infectiousDesc="" s infectiousDesc=desc
    	.e  d  s infectiousDesc=infectiousDesc_","_desc	
	s statusDesc=""
	i status="A" s statusDesc="申请"
	i status="R" s statusDesc="已登记"
	i status="D" s statusDesc="删除"
	
	s vascularAccess=$lg($g(^User.DHCBPDialysisAppD(rowId)),10)
	s vascularAccessDesc=""
	i vascularAccess'="" s vascularAccessDesc=$lg($g(^DHCBPC("VascularAccess",vascularAccess)),2)
	s bodySite=$lg($g(^User.DHCBPDialysisAppD(rowId)),16)
	s bodySiteDesc=""
	i bodySite'="" s bodySiteDesc=$lg($g(^DHCCLC("BodySite",bodySite)),2)	
	s bpPhoneNum=$lg($g(^User.DHCBPDialysisAppD(rowId)),13)	
	s bpNote=$lg($g(^User.DHCBPDialysisAppD(rowId)),14)
	s dialysisStatus=$lg($g(^User.DHCBPDialysisAppD(rowId)),17)
	s dialysisStatusDesc=""
	i dialysisStatus'="" d
		.i dialysisStatus="G" s dialysisStatusDesc="诱导透析"
		.e  i dialysisStatus="K" s dialysisStatusDesc="维持透析"
		.e  i dialysisStatus="T" s dialysisStatusDesc="过渡期"	
	s arrangePlan=$lg($g(^User.DHCBPDialysisAppD(rowId)),18)
	s arrangePlanDesc=""
	i arrangePlan'="" d
		.i arrangePlan="G3" s arrangePlanDesc="诱导3次"
		.e  i arrangePlan="K3" s arrangePlanDesc="维持3次1周"
		.e  i arrangePlan="T1" s arrangePlanDesc="临时1次,之后按需"
		.e  i arrangePlan="T2" s arrangePlanDesc="临时2次,之后按需"
		.e  i arrangePlan="T3" s arrangePlanDesc="临时3次,之后按需"
	s vascularAccessOther=$lg($g(^User.DHCBPDialysisAppD(rowId)),19)	
	s anticoagulantMode=$lg($g(^User.DHCBPDialysisAppD(rowId)),20)
	s anticoagulantModeDesc=""
	i anticoagulantMode'="" s anticoagulantModeDesc=$lg($g(^DHCBPC("AnticoagulantMode",anticoagulantMode)),2)
	s anticoagulantDrug=$lg($g(^User.DHCBPDialysisAppD(rowId)),21)
	s bpMode=$lg($g(^User.DHCBPDialysisAppD(rowId)),22)
	s bpModeDesc=""
	i bpMode'="" s bpModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",bpMode)),2)
	s planTherapyDuration=$lg($g(^User.DHCBPDialysisAppD(rowId)),23)
	i planTherapyDuration'="" s planTherapyDuration=planTherapyDuration/60
	s bpBFR=$lg($g(^User.DHCBPDialysisAppD(rowId)),24)	
	s bpK=$lg($g(^User.DHCBPDialysisAppD(rowId)),25)
	s bpCa2=$lg($g(^User.DHCBPDialysisAppD(rowId)),26)
	s bpNa=$lg($g(^User.DHCBPDialysisAppD(rowId)),27)
	s dewaterAmount=$lg($g(^User.DHCBPDialysisAppD(rowId)),28)
	//id,admId,patName,regNo,papmiMedicare,ctlocId,ctlocDesc,wardId,wardDesc,bedId,bedDesc,infectiousCode,infectiousDesc,status,statusDesc,appDate,appTime,userId,userDesc,updateDate,updateTime,phoneNum,dialysisStatus,dialysisStatusDesc,arrangePlan,arrangePlanDesc,vascularAccess,vascularAccessDesc,bodySite,bodySiteDesc,anticoagulantMode,anticoagulantModeDesc,anticoagulantDrug,bpModeDesc,planTherapyDuration,bpBFR,dewaterAmount,bpK,bpCa2,bpNa,bpNote,bpPhoneNum
	//id,admId,patName,regNo,papmiMedicare,ctlocId,ctlocDesc,wardId,wardDesc,bedId,bedDesc,infectiousCode,infectiousDesc,status,statusDesc,appDate,appTime,userId,userDesc,updateDate,updateTime,phoneNum,dialysisStatus,arrangePlan,vascularAccess,bodySite,anticoagulantMode,anticoagulantDrug,bpMode,planTherapyDuration,bpBFR,dewaterAmount,bpK,bpCa2,bpNa,bpNote,bpPhoneNum
	q 0		
OutputRow1
	s Data=$lb(id,admId,patName,regNo,papmiMedicare,papmiId,patSex,patBirth,age,patAddress,patTelphone,personID,ctlocId,ctlocDesc,wardId,wardDesc,bedId,bedDesc,infectiousCode,infectiousDesc,status,statusDesc,appDate,appTime,userId,userDesc,updateDate,updateTime,dialysisStatus,dialysisStatusDesc,arrangePlan,arrangePlanDesc,vascularAccess,vascularAccessDesc,bodySite,bodySiteDesc,anticoagulantMode,anticoagulantModeDesc,anticoagulantDrug,bpMode,bpModeDesc,planTherapyDuration,bpBFR,dewaterAmount,bpK,bpCa2,bpNa,bpNote,bpPhoneNum)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBPDialysisAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPDialysisAppExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindBPDialysisAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPDialysisAppExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod SetBPDialysisAppRegStatus(admId, status, appId) As %String
{
	//W ##Class(web.DHCBPDialysisApp).SetBPDialysisAppRegStatus("27065968","R")
	;q:admId="" "未获取病人的就诊号"
	q:status="" "登记状态不能为空" 	
	s dialysisApp="",result=""
	s id=""
	i appId="" d
		.s date=""
		.f  s date=$o(^User.DHCBPDialysisAppI("AdmIndex",admId,date)) q:date=""  d
			..s time=""
			..f  s time=$o(^User.DHCBPDialysisAppI("AdmIndex",admId,date,time)) q:time=""  d
				...s id=$o(^User.DHCBPDialysisAppI("AdmIndex",admId,date,time,""))
	e  s id=appId
	q:id="" "透析申请没有找到相关就诊号"
	s statusCode=$lg($g(^User.DHCBPDialysisAppD(id)),15)
	q:statusCode'="A" "只能登记状态为申请的记录"
	s dialysisApp=##class(User.DHCBPDialysisApp).%OpenId(id)
	s dialysisApp.Status=status
	d dialysisApp.%Save()
	s result=dialysisApp.%Id()
	d dialysisApp.%Close()
	q result
}

// Creator：add mfc 20200214

// Input：arrangeId安排id，antId抗凝方式和抗凝药品关联表id

// Return: 返回json数据根式(stream转换为json)

// Description：根据抗凝模式获取药品

// w ##class(web.DHCBPDialysisApp).GetDrugByModeId(1,1)

ClassMethod GetDrugByModeId(dialysisAppId, antId) As %String
{
	s globalStream = ##class(web.DHCBPDialysisApp).GetDrugOptionsByAntModeId(dialysisAppId,antId)	
	//w globalStream,!
	s retStream=""
	if (globalStream'="")
	{
		while(globalStream.AtEnd=0)
		{
			set len=20000
			s retStream= globalStream.Read(.len)
		}
	}
	//b	
	q retStream
}

// w ##class(web.DHCBPDialysisApp).GetDrugOptionsByAntModeId(5,3)

ClassMethod GetDrugOptionsByAntModeId(dialysisAppId, antId) As %GlobalBinaryStream
{
	// w ##class(web.DHCBPDialysisApp).GetDrugOptionsByAntModeId(2)
	&sql(DECLARE d CURSOR FOR
	SELECT BPCAMD_BPCAD_Dr into:drugId
	FROM DHC_BPC_AnticoagulantModeDrug WHERE BPCAMD_BPCAM_Dr=:antId)

	&sql(OPEN d)
	
    FOR { &sql(FETCH d)
        QUIT:SQLCODE 
        s drug=##class(User.DHCBPCAnticoagulantDrug).%OpenId(drugId)
        s Array(drugId,"Id")=drugId
        s Array(drugId,"Code")=drug.BPCADCode
        s Array(drugId,"Desc")=drug.BPCADDesc
       	s Array(drugId,"Cat")=drug.BPCADCatDr        
        d drug.%Close()
       	d ..GetDrugOptions(dialysisAppId,drugId,.DrugData)
		m Array(drugId,"Options")=DrugData
	}
    &sql(Close d) 
    q ..ToJson(.Array)
}

ClassMethod GetDrugOptions(dialysisAppId, drugId, Array) As %GlobalBinaryStream
{
	// w ##class(web.DHCBPDialysisApp).GetDrugOptions(1)
	k Array
	s drug=##class(User.DHCBPCAnticoagulantDrug).%OpenId(drugId)
	s dataId=0,drugData=""
	i (dialysisAppId'="") s dataId=$$GetDataId()
	if (dataId>0){		
	   s drugData=##class(User.DHCBPDiaAppAntDrug).%OpenId(dataId)
	}
	s drugDesc=drug.BPCADDesc	
	s uomId=drug.BPCADUomDr
	s uomDesc=""
	if (uomId){
	  s uom=##class(User.CTUOM).%OpenId(uomId)
	  if uom'="" s uomDesc=uom.CTUOMDesc
	}
	s speedUnitId=drug.BPCADBPCSUDr
	s speedUnitDesc=""
	if (speedUnitId){
		//s speedUnit=##class(User.DHCBPCSpeedUnit).%OpenId(speedUnitId)
		//if speedUnit'="" s speedUnitDesc=speedUnit.BPCSUDesc
		s speedUnitDesc = speedUnitId.BPCSUDesc
	}
	//w drug.BPCADDesc,!
	//w drugData.BPDAADFirstAmount,!
	if (drug.BPCADFirstAmount>-1){
		//w drug.BPCADDesc_"/"_"BPCADFirstAmount"_"/"_drug.BPCADFirstAmount,!
		s Array("A_FirstAmount","Desc")="首推"
		s Array("A_FirstAmount","Code")="FirstAmount"
		s Array("A_FirstAmount","Unit")=uomDesc		
		if (drugData) s Array("A_FirstAmount","Value")=drugData.BPDAADFirstAmount		
	}
	if (drug.BPCADDose>-1){
		//w drug.BPCADDesc_"/"_"BPCADDose"_"/"_drug.BPCADDose,!
		if ((drug.BPCADCode["Saline") || (drug.BPCADCode["CitriciAcid") || (drug.BPCADCode["CalciumGluconate")) d
			.s Array("B_Dose","Desc")="剂量"	
		else  d
			.s Array("B_Dose","Desc")="维持剂量"
		s Array("B_Dose","Code")="Dose"
		s Array("B_Dose","Unit")=speedUnitDesc
		if (drugData) s Array("B_Dose","Value")=drugData.BPDAADDose		
	}
	if (drug.BPCADDuration>-1){
		//w drug.BPCADDesc_"/"_"BPCADDuration"_"/"_drug.BPCADDuration,!
		s Array("E_Duration","Desc")="维持时间"
		s Array("E_Duration","Code")="Duration"
		s Array("E_Duration","Unit")="分钟"
		if (drugData) s Array("E_Duration","Value")=drugData.BPDAADDuration
	}
	if (drug.BPCADFrequency>-1){
		//w drug.BPCADDesc_"/"_"BPCADFrequency"_"/"_drug.BPCADFrequency,!
		s Array("D_Frequency","Desc")="频率"
		s Array("D_Frequency","Code")="Frequency"
		s Array("D_Frequency","Unit")="分钟"
		if (drugData) s Array("D_Frequency","Value")=drugData.BPDAADDuration
	}
	if (drug.BPCADNote>-1){
		//w drug.BPCADDesc_"/"_"BPCADNote"_"/"_drug.BPCADNote,!
		s Array("F_Note","Desc")=""
		s Array("F_Note","Code")="Note"
		s Array("F_Note","Unit")=""
		if (drugData) s Array("F_Note","Value")=drugData.BPDAADNote
	}	
	if (drug.BPCADIntervalMinute>-1){
		//w drug.BPCADDesc_"/"_"BPCADIntervalMinute"_"/"_drug.BPCADIntervalMinute,!
		s Array("G_IntervalMinute","Desc")="间隔时间"
		s Array("G_IntervalMinute","Code")="IntervalMinute"
		s Array("G_IntervalMinute","Unit")="分钟"
		if (drugData) s Array("G_IntervalMinute","Value")=drugData.BPDAADIntervalMinute
	}
	if (drug.BPCADAmount>-1){
		//w drug.BPCADDesc_"/"_"BPCADAmount"_"/"_drug.BPCADAmount,!
		s Array("C_Amount","Desc")="总量"
		s Array("C_Amount","Code")="Amount"
		s Array("C_Amount","Unit")=uomDesc
		if (drugData) s Array("C_Amount","Value")=drugData.BPDAADAmount
	}
	//w 1_Array("A_FirstAmount","Desc"),!
	//q ..ToJson(.Array)
GetDataId()
    &sql(SELECT BPDAAD_RowId into:dataId FROM DHC_BP_DiaAppAntDrug 
    WHERE BPDAAD_BPDialysisApp_Dr=:dialysisAppId AND BPDAAD_BPCAD_Dr=:drugId AND BPDAAD_IfAbandon="N")
    q dataId
}

Query GetDialysisAppAntDrugList(dialysisAppId As %String) As %SQLQuery(CONTAINID = 1)
{
	 SELECT 
	 BPDAAD_RowId As Id,
	 BPDAAD_BPCAD_Dr As AnticoagulantDrugId,
	 BPDAAD_Amount As Amount,
	 BPDAAD_FirstAmount As FirstAmount,
	 BPDAAD_Dose As Dose,
	 BPDAAD_Frequency As Frequency,
	 BPDAAD_Note As Note,
	 BPDAAD_Duration As Duration,
	 BPDAAD_IntervalMinute As IntervalMinute,
	 BPDAAD_Concentration As Concentration,
	 BPDAAD_LastReservation As LastReservation
	 from DHC_BP_DiaAppAntDrug where BPDAAD_BPDialysisApp_Dr=:dialysisAppId and (BPDAAD_IfAbandon='N' or BPDAAD_IfAbandon is null) and BPDAAD_BPCAD_Dr is not null
}

// w ##class(web.DHCClinicCom).ToJson(.Array)

//  w ##class(web.DHCClinicCom).Between("""abc""","""")

ClassMethod Between(value, split, from)
{
	s sIndex=$Find(value,split,from)
	q:sIndex=0 ""
	s eIndex=$Find(value,split,sIndex+1)-$L(split)
	
	q:eIndex<=0 ""
	s from=eIndex
	q $E(value,sIndex,eIndex-1)
}

ClassMethod SetByJson(obj, jsonStr, preName = "")
{
	s jsonObj=##class(Nur.JSON).Decode(jsonStr)
	set clsName=$p(obj,"@",2)
	s cdef = ##class(%Dictionary.ClassDefinition).%OpenId(clsName)
	Set count = cdef.Properties.Count()
	s key=""
	do{
		s key=jsonObj.Next(key)
		q:key="" 
		s value=jsonObj.GetAt(key)
		For i = 1:1:count {
		     Set propertyName=cdef.Properties.GetAt(i).Name
		     s name=preName_key
		     if (propertyName=name){
			     Set type=cdef.Properties.GetAt(i).Type
			     if (type="%Date"){
				     s value=##class(web.DHCClinicCom).ConvertToDateH(value)
			     }
			     elseif (type="%Time"){
				     s value=##class(web.DHCClinicCom).ConvertToTimeH(value)
			     }
			     elseif (type["User."){
				     if value'="" {
					     s excuteStr="(objValue)s objValue=##class("_type_").%OpenId("""_value_""")"
		                 XECUTE (excuteStr,.objValue)
					     s value=objValue
				     }
			     }
			     Set $PROPERTY(obj,propertyName)=value
			 }
		  }
		
	}
	while(key)
}

ClassMethod SetByJson21016(obj, dynamical, preName = "")
{
	set iter = dynamical.%GetIterator()
	set clsName=$p(obj,"@",2)
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(clsName)
	Set count = cdef.Properties.Count()
	while iter.%GetNext(.key,.value) {
		  s name=preName_key
		  For i = 1:1:count {
		     Set propertyName=cdef.Properties.GetAt(i).Name
		     if (propertyName=name){
			     Set type=cdef.Properties.GetAt(i).Type
			     if (type="%Date"){
				     s value=##class(web.DHCClinicCom).ConvertToDateH(value)
			     }
			     elseif (type="%Time"){
				     s value=##class(web.DHCClinicCom).ConvertToTimeH(value)
			     }
			     elseif (type["User."){
				     if value'="" {
					     s excuteStr="(objValue)s objValue=##class("_type_").%OpenId("""_value_""")"
		                 XECUTE (excuteStr,.objValue)
					     s value=objValue
				     }
			     }
			     Set $PROPERTY(arrange,propertyName)=value
			 }
		  }
	}
	q obj
}

ClassMethod ToJSONArray(obj, Array, preName = "")
{
	set clsName=$p(obj,"@",2)
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(clsName)
	Set count = cdef.Properties.Count()
	For i = 1:1:count {
		Set propertyName=cdef.Properties.GetAt(i).Name
		Set value=$PROPERTY(obj,propertyName)
		s name=$p(propertyName,preName,2)
		Set type=cdef.Properties.GetAt(i).Type
		if (type="%Date"){
			s value=##class(web.DHCClinicCom).ConvertToDate(value)
			s Array(name)=value
		}
		elseif (type="%Time"){
			s value=##class(web.DHCClinicCom).ConvertToTime(value)
			s Array(name)=value
		}
		elseif (type["User."){
			s Array(name)=value
			// 设置Code和描述
			if value'="" {
				s excuteStr="(objValue)s objValue=##class("_type_").%OpenId("""_value_""")"
				XECUTE (excuteStr,.objValue)
				s value=objValue
				s Array(name_"Code")=..GetValueByPropertyName(objValue,"Code")
				s Array(name_"Desc")=..GetValueByPropertyName(objValue,"Desc")
			}
		}
	}
}

ClassMethod GetValueByPropertyName(obj, subName)
{
   set clsName=$p(obj,"@",2)
   Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(clsName)
   Set count = cdef.Properties.Count()
   s value=""
   // 获取以subName结束的值
   For j=1:1:count {
	   Set propertyName=cdef.Properties.GetAt(i).Name
	   if ((propertyName_";")[(subName_";"))
	   {
		   Set value=$PROPERTY(obj,propertyName)
		   s j=count+1
	   }
   }
   q value
}

ClassMethod ToJsonObj(jsonStr)
{
	q ##class(Nur.JSON).Decode(jsonStr)
}

// w ##class(web.DHCClinicCom).ToJson(.Array)

ClassMethod ToJson(Array, stream = "")
{
	//b // ToJson
	if stream="" {
	   s stream=##class(%GlobalCharacterStream).%New()
	   d stream.Rewind()
	}
	if ..IsArray(.Array) {
		d ProArray
	}
	else {
		s isFirst=1
		s name=""
		;b //
		d stream.Write("{")
		For{
			s name=$O(Array(name))
			q:name=""		
			if (isFirst'=1){
				d stream.Write(",")
			}			
			k tmpArray
			m tmpArray=Array(name)
			if (..IsArray(.tmpArray)=1)
			{
				d stream.Write(""""_name_""":")
				d ..ToJson(.tmpArray,stream)
			}
			else
			{
				if ($d(Array(name))=10){
					// 该结点不含有值,但含有子节点
					d stream.Write(""""_name_""":")
				    d ..ToJson(.tmpArray,stream)
				}
				else {
					s value=Array(name)
				    d stream.Write(""""_name_""":"""_value_"""")
				    //w """"_name_""":"""_value_"""",!
				}
			}
			s isFirst=isFirst+1
		}
		d stream.Write("}")
	}
	//d stream.OutputToDevice()
	q stream
ProArray
    d stream.Write("[")
		s id=""
		s isFirst=1
		For{
			s id=$O(Array(id))
			q:id=""
			k tmpArray
			m tmpArray=Array(id)			
			q:$d(tmpArray)=1			
			if isFirst'=1 d stream.Write(",")
			d ..ToJson(.tmpArray,stream)
			s isFirst=isFirst+1
		}
		d stream.Write("]")
	q
}

ClassMethod IsArray(Array)
{
	q:$d(Array)=1 0  ; 变量
    // 第一个节点全不含值
    s sub=""
    s isArray=1
    For{
	    s sub=$O(Array(sub))
	    q:((sub="")||(isArray=0))
	    s r=$d(Array(sub))
	    if r=1 {
		    s isArray=0 
	    }
	    elseif r=10 {
		    s isArray=10  // 该结点不含有值,但含有子节点
	    }
	    elseif r=11 {
		    s a=b  // 该结点含有值且含有子节点
	    }
    }
    //w "Array"_isArray,!
    q isArray
}

}
