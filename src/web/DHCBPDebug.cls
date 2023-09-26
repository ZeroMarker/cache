Import SQLUser

Class web.DHCBPDebug Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// 备份数据

// fromRowId:从哪一个Id开始备份

// 备份是增量备份,第一次使用传入数据,之后

ClassMethod BackupBPRecord(fromRowId = 518447)
{
	// d ##class(web.DHCBPDebug).BackupBPRecord()
	s sub=fromRowId
	s lastRowId=+$g(^DhcClBpRecordBackup("lastRowId"))
	i lastRowId'=0 s sub=lastRowId
	
	f  s sub=$O(^DHCBPRecord(sub)) q:sub=""  d
	.s date=$List(^DHCBPRecord(sub),5)
	.s time=$List(^DHCBPRecord(sub),6)
	.s ^DhcClBpRecordBackup(date,time,sub)=^DHCBPRecord(sub)
	.s ^DhcClBpRecordBackup("lastRowId")=sub
	.
	.w "backup:"_sub,!
	q "LastSub:"_sub
}

// 恢复数据

ClassMethod RecoveryBpRecord(fromDate, fromTime, toTime)
{
	// d ##class(web.DHCBPDebug).RecoveryBpRecord(64155,48081,48081)
	i '$ISVALIDNUM(fromDate) s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	i '$ISVALIDNUM(fromTime) s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	i '$ISVALIDNUM(toTime) s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	s time=fromTime
	
	s time="" f  s time=$O(^DhcClBpRecordBackup(fromDate,time)) q:time=""  d
	.s sub="" f  s sub=$O(^DhcClBpRecordBackup(fromDate,time,sub)) q:sub=""  d
	..
	..d InsertBpRecord
	..i time>toTime goto QuitAll
	..
	q "Over"
QuitAll
	q
	
InsertBpRecord
	s item=^DhcClBpRecordBackup(fromDate,time,sub)
	s bpaId=$List(item,1)
	s recordItemId=$List(item,2)
	s date=$List(item,5)
	s time=$List(item,6)
	q:$$IsRepeated(bpaId,recordItemId,date,time)=1 ""
	
	s record=##class(User.DHCBPRecord).%New()
	d record.BPRBPArrangeDrSetObjectId($List(item,1))
	d record.BPRBPCRecordItemDrSetObjectId($List(item,2))
	d record.BPRBPCRecordCatDrSetObjectId($List(item,3))
	q:$List(item,1)="" ""
	w $List(item,1),",",$List(item,2),",",$List(item,3),!
	s record.BPRStartDate=$List(item,5)
	s record.BPRStartTime=$List(item,6)
	s record.BPREditStatus=$List(item,10)
	
	s record.BPRSource=$List(item,12)
	s record.BPRQty=$List(item,14)
	s record.BPRNote=$List(item,15)
	s record.BPRUpdateUserDr=$List(item,21)
	s record.BPRUpdateDate=$List(item,22)
	s record.BPRUpdateTime=$List(item,23)
	s rowId=record.%Save()
	d record.%Close()
	s id=record.%Id()
	w "Insert:"_record.%Id(),!
	s ^DhcClBpDebugRecovery(fromDate,id)=id
	q
IsRepeated(bpaId,recordItemId,date,time)
	s count=0
	&SQL(select Count(*) into :count from SQLUser.DHC_BP_Record where BPR_BPArrange_Dr=:bpaId 
	and BPR_BPCRecordItem_Dr=:recordItemId and BPR_StartDate=:date and BPR_StartTime=:time)
	i count>0 w "Repeated:",count,! 
	
	q:count>0 1
	q 0
}

ClassMethod InitArcim(groupId)
{
	s resultSet=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	d resultSet.Execute("",groupId,"","","","","","","","","","","","","","")
	while(resultSet.Next())
	{
		s arcimType=resultSet.GetData(4)
		continue:(arcimType'="ARCIM")
		s arcimId=resultSet.GetData(2)
		s arcimCode=resultSet.GetData(29)
		s arcimAlias=resultSet.GetData(5)
		s arcimMainId=+arcimId,arcimVersion=+$p(arcimId,"||",2)
		s arcimDesc=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",2)
		s itemCatId=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",10)
		s equalUomInfo=##class(web.DHCICUOrder).GetEqUomQty(arcimId)
		s equalUomIdInfo=$p(equalUomInfo,"^",1)
		s defaultDoseInfo=$p(equalUomInfo,"^",2)
		s baseUomId=$p(equalUomInfo,"^",3)
		s equalQtyInfo=$p(equalUomInfo,"^",4)
		s volume=$p(equalUomInfo,"^",5)
		s defaultInstrId=""
		s instrId=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",12)
		s instrMainId=+instrId,instrSubId=+$p(instrId,"||",2)
		i (instrSubId'="")
		{
			s defaultInstrId=+$p($g(^PHCD(instrMainId,"DF",instrSubId,1)),"^",5)	
		}
		i arcimId="32454||1" b 
		s freqId=$o(^PHCFR(0,"Code","1ONCE",""))
		s itemPrice=+##Class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimId,+$h,"","","","")
		s defaultRecvLoc="" //##class(web.DHCANCall).GetOrderItemRecloc(opaId,arcimId,"",ctLocId)
		s defaultRecvLoc=$tr(defaultRecvLoc,"^","#")
		s Data=$lb(arcimId,arcimCode,arcimDesc,arcimAlias,arcimType,itemCatId,equalUomIdInfo,defaultDoseInfo,baseUomId,equalQtyInfo,volume,freqId,defaultInstrId,itemPrice,defaultRecvLoc)
		s ^TMPBPLib(groupId,arcimId)=Data
		s ^TMPBPLIbUpdateDate(groupId)=+$h
	}
}

/// Creator：      	陈长青
/// CreatDate：    	2014-03-12
/// Description： 	根据拼音码或名称字符串查找医嘱项
/// Table：        	
/// Input:			filterDesc：医嘱项名称或别名过滤字符串，groupId：用户安全组ID，ctLocId：用户登录位置ID，opaId：手术病人申请排班ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCClinicCom","FindArcim","amxl","153","120","43757")
Query FindArcim(filterDesc As %String, groupId As %String, ctLocId As %String, opaId As %String) As %Query(ROWSPEC = "Id,Code,Description,Alias,ItemType,ItemCatId,EqualUomIdInfo,DefaultDoseInfo,BaseUomId,EqualQtyInfo,Volume,DefaultFreqId,DefaultInstrId,Price,DefaultRecvLoc") [ SqlProc ]
{
}

ClassMethod FindArcimExecute(ByRef qHandle As %Binary, filterDesc As %String, groupId As %String, ctLocId As %String, opaId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s filterDesc=$$ALPHAUP^SSUTIL4(filterDesc)
	// s ^TMPBPLibQurery(groupId)=$h_" "
	//i $g(^TMPBPLIbUpdateDate(groupId))=+$h k ^TMPBPLib(groupId)
	i $O(^TMPBPLib(groupId,""))=""  d ..InitArcim(groupId)
	s sub="" f  s sub=$o(^TMPBPLib(groupId,sub)) q:sub=""  d
	.s code=$List(^TMPBPLib(groupId,sub),4)
	.s desc=$List(^TMPBPLib(groupId,sub),3)
	.s code=$$ALPHAUP^SSUTIL4(code)
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.;w "code:",code,!
	.if ((code[filterDesc)||(desc[filterDesc)) d
    ..d OutputRow
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=^TMPBPLib(groupId,sub)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimExecute ]
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

ClassMethod FindArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod AddItem(admId, ordItemId, LABDATA)
{
	// w ##class(web.DHCBPDebug).AddItem(arcimRowId)
	s oderRowId=$p(ordItemId,"||",1)
	s ordChildSub=$p(ordItemId,"||",2)
	s arcimRowId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",2)
	s arcSubCatDr=$P($G(^ARCIM(+arcimRowId,$P(arcimRowId,"||",2),1)),"^",10)
	s ordLabNo=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",20)
	s labRelatId=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",35)
    s ordItemDesc=$P($G(^ARCIM(+arcimRowId,$P(arcimRowId,"||",2),1)),"^",2)
    s arcExCode=##class(web.DHCBPLab).GetExCode(arcimRowId)
    s reportDate="",reportUser="",reportTime="",reportException=""
    i labRelatId'="" d
    .s labTSCode=$p(labRelatId,"||",2)
    .s labTSId=$p(labRelatId,"||",3)
    .q:labTSId=""
    .s reportDate=$P($G(^TEPI(ordLabNo,1,labTSCode,labTSId)),"\",4)
    .i reportDate'="" s reportDate=$ZD(reportDate,3)
    .s reportTime=$P($G(^TEPI(ordLabNo,1,labTSCode,labTSId)),"\",5)
    .i reportTime'="" s reportTime=$ZT(reportTime)
    .s reportUserCode=$P($G(^TEPI(ordLabNo,1,labTSCode,labTSId)),"\",6)
    .
    .i (reportUserCode'="") s reportUser=$P($G(^SSU("SSUSR",1,reportUserCode)),"^",2)
    .s labstatus=##class(web.DHCBPLab).IflabnoVer(ordLabNo,arcExCode)
    .s labCpt=$P(labstatus,"^",1)
    .s labDate=$E($P(labstatus,"^",2),6,10)
    .s labTime=$P(labstatus,"^",3)
    s ordLabSpec="",specChildSub=0
    i $d(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub))'=0 d
    .s specChildSub=0 f  s specChildSub=$o(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub)) q:specChildSub=""  d
    ..s labSpecCode=$g(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub))
    ..s labSpecCode=$p(labSpecCode,"^",1)
    ..s labSpec=$p(^[LABDATA]TTAB("SPEC",labSpecCode),"\",1)
    ..i ordLabSpec="" s ordLabSpec=labSpec
    ..e  s ordLabSpec=ordLabSpec_","_labSpec

    s reportStatus="报告未出"
    i reportDate'="" s reportStatus="报告已出"
    s reportValuStatus=##Class(DWR.BL.LisReport).GetLisReportState(admId,ordLabNo)
    i reportValuStatus="报告未出" s reportStatus="报告未出"
    s reportException=##Class(DWR.BL.LisReport).GetLisReportExp(admId,ordLabNo)
    i reportException'="" s reportException=1
    e  s reportException=0
    i reportStatus="报告未出" s reportException=0

    s recDeparmentDr=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",6)
    s recDept=""
    i recDept'="" s recDept=$p($g(^CTLOC(recDeparmentDr)),"^",2)

    s ordStartDate=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",9)
    s ordDate=$ZD(ordStartDate,3)
    s ordStartTime=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",9)
    s ordTime=$ZT(ordStartTime)

    s ordLabSpec=ordLabSpec
    s reportStatus=reportStatus
    s reportUser=reportUser
    s reportDate=reportDate
    s reportTime=reportTime
    s reportException=reportException

    s ordIndex=0
    w "Add:",ordItemDesc," ",ordDate,ordTime,reportDate,reportTime,reportStatus,!

    set Data=$lb(ordIndex,recDept,ordLabNo,ordItemId,arcimRowId,ordItemDesc,ordStatus,ordDate,ordTime,ordLabSpec,reportStatus,reportUser,reportDate,reportTime,reportException)
    s ^tmpClLabMedOrder(regNo,"TimeIndex",ordStartDate,ordStartTime,arcimRowId,ordItemId)=""
    s ^tmpClLabMedOrder(regNo,"MedOrderCodeIndex",arcimRowId,ordStartDate,ordStartTime,ordItemId)=""
    s ^tmpClLabMedOrder(regNo,"Data",ordItemId)=Data
    q Data
}

/// Creator：     马福成
/// CreatDate：   2017-03-03
/// Description： 移植旧数据使用，把扩展表的字段透析前治疗备注的值，移植到安排表的治疗备注字段中
/// Input:        code：扩展表字段code，bpaId安排表ID
/// w ##class(web.DHCBPArrangeExtend).SetArrangeNoteByExtendValue("DialysisBeforeNote","49001")
ClassMethod SetArrangeNoteByExtendValue(code As %String, bpaId As %String = "") As %String
{
	q:code="" ""
	s arrangeId=""
	f  s arrangeId=$o(^DHCBPArrange(arrangeId)) q:arrangeId=""  d
		.q:(bpaId'="")&&(bpaId'=arrangeId)
		.s extendId=$o(^DHCBPArrangeExtend(0,"BPACode",arrangeId,code,""))
		.q:extendId=""
		.s value=$li(^DHCBPArrangeExtend(extendId),6)
		.q:value=""
		.s arrange=##class(User.DHCBPArrange).%OpenId(arrangeId)
		.s arrange.BPADialysisBeforeNote=value
		.s saveStatus=arrange.%Save()
		.s result=arrange.%Id()
		.w result,!
		.d arrange.%Close()	
	q 0
}

/// Creator：      	马福成
/// CreatDate：    	2017-03-07
/// Description： 	获取抗凝方式为无肝素、绝无肝素的透析人数和透析次数
/// Table：        	
/// Input:			fromDate：开始日期，toDate：结束日期，locId：科室ID
/// Return：       	"抗凝"_"/"_"凝血"_"/"_"人数"_"/"_"透析次数"
/// w ##class(web.DHCBPDebug).getAntModeAndGrumeCount("2016-12-01","2017-02-31",15)
ClassMethod getAntModeAndGrumeCount(fromDate As %String, toDate As %String, locId As %String = "")
{
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s titleIndex=0,ipapmiIdList="",iipapmiIdList="",iiipapmiIdList="",nopapmiIdList="",absipapmiIdList="",absiipapmiIdList="",absiiipapmiIdList="",absnopapmiIdList=""
	s papmiIdList=""
	s bpaId=""
	f curDate=fromDate:1:toDate d
	  .s bpaId=""
	  .f  s bpaId=$o(^DHCBPArrange(0,"Date",curDate,bpaId)) q:bpaId=""  d
			..q:bpaId=""	
			..s bpprId=$lg(^DHCBPArrange(bpaId),1)
			..q:bpprId=""	
			..s bpaStatus=$lg(^DHCBPArrange(bpaId),9)	
			..q:bpaStatus'="F"
			..s admId=$lg(^DHCBPPatRegister(bpprId),26)
			..q:admId=""
			..s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
			..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
			..s admDeptId=$p($g(^PAADM(admId)),"^",4)	
			..s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)	
    		..q:((locId'="")&&(bpprPatLocationDr'="")&&($p($g(^CTLOC(locId)),"^",22)'=$p($g(^CTLOC(bpprPatLocationDr)),"^",22))) //病人所在医院判断
    		..q:(bpprPatLocationDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_bpprPatLocationDr_"^"))
    		..s bpaDate=$lg(^DHCBPArrange(bpaId),4)
			..s bpaTime=$lg(^DHCBPArrange(bpaId),5)
			..q:(bpaDate'="")&(bpaDate>toDate)
			..q:(bpaDate'="")&(bpaDate<fromDate)
    		..;s bpaBPCBPModeDr=$lg(^DHCBPArrange(bpaId),26)
			..;s bpaBPCBPModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+bpaBPCBPModeDr)),2)
			..s bpaAnticoagulantModeDr=$lg(^DHCBPArrange(bpaId),77)
			..q:bpaAnticoagulantModeDr=""
			..s tBPCAMDesc=$lg(^DHCBPC("AnticoagulantMode",bpaAnticoagulantModeDr),2)
			..s tBPCAMCode=$lg(^DHCBPC("AnticoagulantMode",bpaAnticoagulantModeDr),1)
			..q:(tBPCAMCode'="4")&&(tBPCAMCode'="5") //无肝素、绝无肝素
			..;q:(tBPCAMCode'="1") //全身肝素化
			..s extendId=$o(^DHCBPArrangeExtend(0,"BPACode",bpaId,"DialyzerGrume",""))
			..i extendId'="" s value=$li(^DHCBPArrangeExtend(extendId),6)
			..e  s value=""
			..;q:value=""
			..i (tBPCAMCode="4")&&(value="I度") d
			...i ("^"_ipapmiIdList_"^")'[("^"_papmiId_"^") d
			....i ipapmiIdList'="" s ipapmiIdList=ipapmiIdList_"^"
			....s ipapmiIdList=ipapmiIdList_papmiId			
			..i (tBPCAMCode="4")&&(value="II度") d
			...i ("^"_iipapmiIdList_"^")'[("^"_papmiId_"^") d
			....i iipapmiIdList'="" s iipapmiIdList=iipapmiIdList_"^"
			....s iipapmiIdList=iipapmiIdList_papmiId	
			..i (tBPCAMCode="4")&&(value="III度") d
			...i ("^"_iiipapmiIdList_"^")'[("^"_papmiId_"^") d
			....i iiipapmiIdList'="" s iiipapmiIdList=iiipapmiIdList_"^"
			....s iiipapmiIdList=iiipapmiIdList_papmiId
			..i (tBPCAMCode="4")&&(value="") d
			...i ("^"_nopapmiIdList_"^")'[("^"_papmiId_"^") d
			....i nopapmiIdList'="" s nopapmiIdList=nopapmiIdList_"^"
			....s nopapmiIdList=nopapmiIdList_papmiId		
			..i (tBPCAMCode="5")&&(value="I度") d
			...i ("^"_absipapmiIdList_"^")'[("^"_papmiId_"^") d
			....i absipapmiIdList'="" s absipapmiIdList=absipapmiIdList_"^"
			....s absipapmiIdList=absipapmiIdList_papmiId
			..i (tBPCAMCode="5")&&(value="II度") d
			...i ("^"_absiipapmiIdList_"^")'[("^"_papmiId_"^") d
			....i absiipapmiIdList'="" s absiipapmiIdList=absiipapmiIdList_"^"
			....s absiipapmiIdList=absiipapmiIdList_papmiId
			..i (tBPCAMCode="5")&&(value="III度") d
			...i ("^"_absiiipapmiIdList_"^")'[("^"_papmiId_"^") d
			....i absiiipapmiIdList'="" s absiiipapmiIdList=absiiipapmiIdList_"^"
			....s absiiipapmiIdList=absiiipapmiIdList_papmiId
			..i (tBPCAMCode="5")&&(value="") d
			...i ("^"_absnopapmiIdList_"^")'[("^"_papmiId_"^") d
			....i absnopapmiIdList'="" s absnopapmiIdList=absnopapmiIdList_"^"
			....s absnopapmiIdList=absnopapmiIdList_papmiId
			..i ("^"_papmiIdList_"^")'[("^"_papmiId_"^") d
			...i papmiIdList'="" s papmiIdList=papmiIdList_"^"
			...s papmiIdList=papmiIdList_papmiId
			..
	;w papmiIdList,!
	s titleIndex=0,iCount=0,iiCount=0,iiiCount=0,noCount=0,absiCount=0,absiiCount=0,absiiiCount=0,absnoCount=0
	f i=1:1:$l(papmiIdList,"^") d	
		.s papmiId=$p(papmiIdList,"^",i)
		.q:papmiId=""
		.s bpprId=""
		.f  s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,bpprId)) q:bpprId=""  d
			..s bpaId=""
			..f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",bpprId,bpaId)) q:bpaId=""  d		

				...s bpprId=$lg(^DHCBPArrange(bpaId),1)
				...q:bpprId=""	
				...s bpaStatus=$lg(^DHCBPArrange(bpaId),9)	
				...q:bpaStatus'="F"
				...s admId=$lg(^DHCBPPatRegister(bpprId),26)
				...q:admId=""
				...s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
				...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
				...s admDeptId=$p($g(^PAADM(admId)),"^",4)	
				...s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)	
    			...q:((locId'="")&&(bpprPatLocationDr'="")&&($p($g(^CTLOC(locId)),"^",22)'=$p($g(^CTLOC(bpprPatLocationDr)),"^",22))) //病人所在医院判断
    			...q:(bpprPatLocationDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_bpprPatLocationDr_"^"))
    			...s bpaDate=$lg(^DHCBPArrange(bpaId),4)
				...s bpaTime=$lg(^DHCBPArrange(bpaId),5)
				...q:(bpaDate'="")&(bpaDate>toDate)
				...q:(bpaDate'="")&(bpaDate<fromDate)
			
				...s bpaAnticoagulantModeDr=$lg(^DHCBPArrange(bpaId),77)
				...q:bpaAnticoagulantModeDr=""
				...s tBPCAMDesc=$lg(^DHCBPC("AnticoagulantMode",bpaAnticoagulantModeDr),2)
				...s tBPCAMCode=$lg(^DHCBPC("AnticoagulantMode",bpaAnticoagulantModeDr),1)
				...q:(tBPCAMCode'="4")&&(tBPCAMCode'="5") //无肝素、绝无肝素
				...s extendId=$o(^DHCBPArrangeExtend(0,"BPACode",bpaId,"DialyzerGrume",""))
				...i extendId'="" s value=$li(^DHCBPArrangeExtend(extendId),6)
				...e  s value=""
				...;q:value=""
				...i (tBPCAMCode="4")&&(value="I度") d
				....s iCount=iCount+1 ;w patName_"/"_tBPCAMDesc_"/"_value_"/"_iCount_"/"_$zd(bpaDate,3)_"/"_papmiId,!
				...i (tBPCAMCode="4")&&(value="II度") d
				....s iiCount=iiCount+1 ;w patName_"/"_tBPCAMDesc_"/"_value_"/"_iiCount_"/"_$zd(bpaDate,3)_"/"_papmiId,!
				...i (tBPCAMCode="4")&&(value="III度") d
				....s iiiCount=iiiCount+1 ;w patName_"/"_tBPCAMDesc_"/"_value_"/"_iiiCount_"/"_$zd(bpaDate,3)_"/"_papmiId,!
				...i (tBPCAMCode="4")&&(value="") d
				....s noCount=noCount+1 ;w patName_"/"_tBPCAMDesc_"/"_"无"_"/"_noCount_"/"_$zd(bpaDate,3)_"/"_papmiId,!
				...i (tBPCAMCode="5")&&(value="I度") d
				....s absiCount=absiCount+1 ;w patName_"/"_tBPCAMDesc_"/"_value_"/"_absiCount_"/"_$zd(bpaDate,3)_"/"_papmiId,!
				...i (tBPCAMCode="5")&&(value="II度") d
				....s absiiCount=absiiCount+1 ;w patName_"/"_tBPCAMDesc_"/"_value_"/"_absiiCount_"/"_$zd(bpaDate,3)_"/"_papmiId,!
				...i (tBPCAMCode="5")&&(value="III度") d
				....s absiiiCount=absiiiCount+1 ;w patName_"/"_tBPCAMDesc_"/"_value_"/"_absiiiCount_"/"_$zd(bpaDate,3)_"/"_papmiId,!
				...i (tBPCAMCode="5")&&(value="") d
				....s absnoCount=absnoCount+1 ;w patName_"/"_tBPCAMDesc_"/"_"无"_"/"_absnoCount_"/"_$zd(bpaDate,3)_"/"_papmiId,!
	w "抗凝"_"/"_"凝血"_"/"_"人数"_"/"_"透析次数",!
	i (ipapmiIdList="") w "无肝素"_"/"_"I度"_"/"_0_"/"_iCount,!
	e  w "无肝素"_"/"_"I度"_"/"_$l(ipapmiIdList,"^")_"/"_iCount,!
	i (iipapmiIdList="") w "无肝素"_"/"_"II度"_"/"_0_"/"_iiCount,!
	e  w "无肝素"_"/"_"II度"_"/"_$l(iipapmiIdList,"^")_"/"_iiCount,!
	i (iiipapmiIdList="") w "无肝素"_"/"_"III度"_"/"_0_"/"_iiiCount,!
	e  w "无肝素"_"/"_"III度"_"/"_$l(iiipapmiIdList,"^")_"/"_iiiCount,!
	i (nopapmiIdList="") w "无肝素"_"/"_"无"_"/"_0_"/"_noCount,!
	e  w "无肝素"_"/"_"无"_"/"_$l(nopapmiIdList,"^")_"/"_noCount,!
	i (absipapmiIdList="") w "绝无肝素"_"/"_"I度"_"/"_0_"/"_absiCount,!
	e  w "绝无肝素"_"/"_"I度"_"/"_$l(absipapmiIdList,"^")_"/"_absiCount,!
	i (absiipapmiIdList="") w "绝无肝素"_"/"_"II度"_"/"_0_"/"_absiiCount,!
	e  w "绝无肝素"_"/"_"II度"_"/"_$l(absiipapmiIdList,"^")_"/"_absiiCount,!
	i (absiiipapmiIdList="") w "绝无肝素"_"/"_"III度"_"/"_0_"/"_absiiiCount,!
	e  w "绝无肝素"_"/"_"III度"_"/"_$l(absiiipapmiIdList,"^")_"/"_absiiiCount,!
	i (absnopapmiIdList="") w "绝无肝素"_"/"_"无"_"/"_0_"/"_absnoCount,!
	e  w "绝无肝素"_"/"_"无"_"/"_$l(absnopapmiIdList,"^")_"/"_absnoCount,!
}

/// Creator：     马福成
/// CreatDate：   2017-03-13
/// Description： 移植旧数据使用，把方案表的置换方式和置换量，移植到方案安排表的对应字段中
/// Input:        schId:透析方案表ID
/// w ##class(web.DHCBPDebug).SetArrangeSchemeBySchemeValue("55")
ClassMethod SetArrangeSchemeBySchemeValue(schId As %String = "") As %String
{
	s schemeId=0
	f  s schemeId=$o(^DHCBPScheme(schemeId)) q:schemeId=""  d
		.q:(schId'="")&&(schId'=schemeId)
		.q:('$d(^DHCBPScheme(schemeId)))
		.s filterReplaceMode=$lg($g(^DHCBPScheme(schemeId)),22)
		.s filterReplaceAmount=$lg($g(^DHCBPScheme(schemeId)),23)
		.w filterReplaceMode_"/"_filterReplaceAmount,!
		.s arrangeSchemeId=""
     	.f  s arrangeSchemeId=$o(^DHCBPArrangeScheme(0,"Scheme",schemeId,arrangeSchemeId)) q:arrangeSchemeId=""  d
			..s arrangeScheme=##class(User.DHCBPArrangeScheme).%OpenId(arrangeSchemeId)
			..s arrangeScheme.BPASFilterReplaceMode=filterReplaceMode
			..s arrangeScheme.BPASFilterReplaceAmount=filterReplaceAmount
			..s saveStatus=arrangeScheme.%Save()
			..s result=arrangeScheme.%Id()
			..w result,!
			..d arrangeScheme.%Close()	
	q 0
}

}
