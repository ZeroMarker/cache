/// 病理接口业务
Class CIS.AN.BL.Pathology Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2016-12-26
/// Description： 	查询手术等级
/// Table：        	OperClass
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Pathology","FindPathRecord","1708")
Query FindPathRecord(opsId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   Frost,
	   RptStatusDesc,
	   DiagRes,
	   RecvDate As RecvDateH,
	   %ODBCOUT(RecvDate) As RecvDate
	   from CIS_AN.PathologyRecord where OperSchedule=:opsId
}

/// Creator：      	陈长青
/// CreatDate：    	2016-12-26
/// Description： 	查询手术等级
/// Table：        	OperClass
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Pathology","FindSpecimen","PIS2019040400009")
Query FindSpecimen(flowID As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	   %External(Status) As StatusDesc
	   from CIS_AN.Specimen where PathologyRecord->FlowID=:flowID
}

/// Creator：      	陈长青
/// CreatDate：    	2018-09-17
/// Description： 	获取病理诊断结果
/// Table：        	
/// Input:			opsId：手术计划ID
/// Return：       	ResultSet
/// w ##class(CIS.AN.BL.Pathology).GetPathDiangosis("5856")
ClassMethod GetPathDiangosis(opsId As %String) As %String
{
	set diagnosis=""
	//do ##class(web.DHCANImportDataNew).GetPathologyResult(operSchedule.EpisodeID)
	set rset=##class(%ResultSet).%New("CIS.AN.BL.Pathology:FindPathRecord")
	set sc=rset.Execute(opsId)
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	while(rset.%Next())
	{
		set:(diagnosis'="") diagnosis=diagnosis_";"
		set diagnosis=diagnosis_rset.Get("DiagRes")
	}
	
	quit diagnosis
}

/// w ##class(CIS.AN.BL.Pathology).SavePathologyRecord(^TMPYGB("SavePathologyRecord"))
ClassMethod SavePathologyRecord(dataPara As %String) As %String
{
	set $zt="Error"
	set ^TMPYGB("SavePathologyRecord")=dataPara
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)
	k firstData
	m firstData=array(1)
	tstart
	set flowID=firstData("FlowID")
	set pathRecordID=""
	&sql(select RowId into :pathRecordID from CIS_AN.pathologyrecord where FlowID=:flowID)
	if (##class(CIS.AN.PathologyRecord).%ExistsId(pathRecordID))
	{
		set firstData("RowId")=pathRecordID	
	}
	else
	{
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.firstData)
		if ($p(saveResult,"^",1)="E")
		{
			trollback
			quit saveResult	
		}	
		set pathRecordID=$p(saveResult,"^",2)
	}
	
	set dataIndex=1,saveResult=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		k operData
		m operData=array(dataIndex)
		set operData("PathologyRecord")=pathRecordID
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operData)
		quit:($piece(saveResult,"^",1)'="S")
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	quit "S^"
Error
	set $zt=""
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.Pathology).RemoveSpecimen("19")
ClassMethod RemoveSpecimen(specimenId As %String) As %String
{
	quit:(##class(CIS.AN.Specimen).%ExistsId(specimenId)=0) "E^未找到需要删除的标本信息！"
	set specimen=##class(CIS.AN.Specimen).%OpenId(specimenId)
	quit:(specimen.Status="R") "E^标本已被病理科接收，不能删除！"
	tstart
	set $zt="Error"
	
	
	if (##class(User.DHCAppPisSpec).%ExistsId(specimen.ExternalID))
	{
		b //ccq
		set sc=##class(User.DHCAppPisSpec).%DeleteId(specimen.ExternalID)
		if ($System.Status.IsError(sc))
		{
			trollback
			quit "E^"_$System.Status.GetErrorText(sc)	
		}	
	}
	set sc=##class(CIS.AN.Specimen).%DeleteId(specimenId)
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.Pathology).SubmitSpecimen(1,^TMPYGB("SubmitSpecimen"))
ClassMethod SubmitSpecimen(PisID As %String, dataPara As %String) As %String
{
	quit:(##class(User.DHCAppPisMaster).%ExistsId(PisID)=0) "E^病理申请不存在！"
	set $zt="Error"
	s ^TMPYGB("SubmitSpecimen")=dataPara
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)	
	set index=0,specimenStr="",specimenCount=0,saveResult="S^"
	tstart
	for
	{
		set index=$o(array(index))
		quit:(index="")
		k operData
		m operData=array(index)	
		s specimenRowId=$get(operData("RowId"))
		s specimen=##class(CIS.AN.Specimen).%OpenId(specimenRowId)
		continue:(specimen.Status="R")		// 已接收的标本不能再修改
		s seqNo=specimen.SeqNo,desc=specimen.Description,qty=specimen.Qty,note=specimen.Note
		if (##class(User.DHCAppPisSpec).%ExistsId(specimen.ExternalID))
		{
			set appSpecId=specimen.ExternalID
			&sql(update SQLUser.DHC_AppPisSpec set AP_NO=:seqNo,AP_Name=:desc,AP_Qty=:qty,AP_Remark=:note where %ID=:appSpecId)	
		}
		else
		{
			s specChild=$o(^DHCAPPPM(PisID,"S",""),-1)+1
			&sql(insert into SQLUser.DHC_AppPisSpec(AP_ParRef_Dr,AP_ChildSub,AP_NO,AP_Name,AP_Qty,AP_Remark) values (:PisID,:specChild,:seqNo,:desc,:qty,:note))
		}
		s:(SQLCODE'=0) saveResult="E^"_$System.SQL.SQLCODE(SQLCODE)
		quit:(SQLCODE'=0)
		s specimen.ExternalID=%ROWID
		s specimen.Status="A"
		s sc=specimen.%Save()
		s:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))	
		s specimenCount=specimenCount+1
	}
	b ;99
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	set orderId=""
	&sql(select OrderID into :orderId from CIS_AN.pathologyrecord where ExternalID=:PisID)
	///调用第三方病理，暂时先屏蔽  ygb 20200203
	// 调用平台接口将病理标本信息传给第三方病理系统(不用事务)
	;set ret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDPISSPECRECEIVE",orderId)
	//set ret=##class(CIS.AN.COM.String).StreamToString(ret)
	set ret=0
	if ($p(ret,"^",1)'=0)
	{
		//trollback
		quit "E^提交标本信息到病理科失败("_$p(ret,"^",2)_")。"	
	}
	quit:(specimenCount=0) "E^未找到任何需要提交的标本信息！"
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod SyncPathData(EpisodeID As %String) As %String
{
	do ##class(web.DHCANImportDataNew).GetPathologyResult(EpisodeID)
	quit "0"
}

ClassMethod GetPathologyAppInfo(EpisodeID As %String) As %String
{
	set pisRowId="",pisInfoStr=""
	for
	{
		set pisRowId=$o(^DHCAPPPM(0,"Adm",EpisodeID,pisRowId))
		quit:(pisRowId="")
		set xuser=$p(^DHCAPPPM(pisRowId),"^",10)
		set xdate=$p(^DHCAPPPM(pisRowId),"^",11)
		set xtime=$p(^DHCAPPPM(pisRowId),"^",12)
		continue:(xuser'="")&(xdate'="")&(xtime'="")
		set pisInfo=##class(CIS.AN.BL.Pathology).JsGetPisNoObj(pisRowId)	
		set:(pisInfoStr'="") pisInfoStr=pisInfoStr_","
		set pisInfoStr=pisInfoStr_pisInfo
	}
	set pisInfoStr="["_pisInfoStr_"]"
	quit pisInfoStr
}

ClassMethod GetPathologyAppInfoByePisId(PisId As %String) As %String
{
	
	set pisInfo=^DHCAPPPM(PisId,"JsonInfo")
	//##class(CIS.AN.BL.Pathology).JsGetPisNoObj(pisRowId)	
	//set pisInfo="["_pisInfo_"]"
	quit pisInfo
}

/// Descript: 取病理申请数据
/// w ##Class(web.DHCAppPisMaster).JsGetPisNoObj("20")
ClassMethod JsGetPisNoObj(PisID) As %String
{
	s ^tempztw("JsGetPisNoObj")=PisID
	b ;pis
	Q:'$D(^DHCAPPPM(PisID)) ""
	s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)   /// 就诊ID
	s FrostFlag=$p(^DHCAPPPM(PisID),"^",2)   /// 冰冻标志
	s EmgFlag=$p(^DHCAPPPM(PisID),"^",3)     /// 加急标志
	s createDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime($p(^DHCAPPPM(PisID),"^",6),$p(^DHCAPPPM(PisID),"^",7))
	s createDate=##class(CIS.AN.COM.DateTime).ConvertToDate($p(^DHCAPPPM(PisID),"^",6))
	s createTime=##class(CIS.AN.COM.DateTime).ConvertToTime($p(^DHCAPPPM(PisID),"^",7))
	s CommonFlag=$p(^DHCAPPPM(PisID),"^",22)  /// 普通标志 ztw 2018.10.23
	s No=$p(^DHCAPPPM(PisID),"^",4)          /// 申请单号
	s PisNo=$p(^DHCAPPPM(PisID),"^",13)      /// 病理号
	s MedRecord=$p(^DHCAPPPM(PisID),"^",14)  /// 临床病历
	s MedDiag=$p(^DHCAPPPM(PisID),"^",15)    /// 临床诊断
	s HepatitisB=$p(^DHCAPPPM(PisID),"^",16) /// 乙肝病史
	s OperRes=$p(^DHCAPPPM(PisID),"^",17)    /// 手术所见
	s InfDisHis=$p(^DHCAPPPM(PisID),"^",18)  /// 传染病史
	s FoundDate=$p(^DHCAPPPM(PisID),"^",19)  /// 首次发现人乳头瘤病毒时间
	s:FoundDate'="" FoundDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(FoundDate)
	s ApplyDocDesc=""
	s ApplyDocId=$p(^DHCAPPPM(PisID),"^",5)	 /// 申请医生(UserID)
	s:ApplyDocId'="" ApplyDocDesc=$p(^SSU("SSUSR",ApplyDocId),"^",2) 
	s ApplyLocId=$p(^DHCAPPPM(PisID),"^",8)	 /// 申请科室
	s:ApplyLocId'="" ApplyLocDesc=$p(^CTLOC(ApplyLocId),"^",2)
	s SendPisFlag=##Class(web.DHCAppPisMasterQuery).GetSendPisFlag(PisID)
	s PisArcList=##Class(web.DHCAppPisMaster).GetPisArc(PisID) /// 病理申请医嘱项目内容
	s ItemDesc=$p(PisArcList,"^"),LocID=$p(PisArcList,"^",2),LocDesc=$p(PisArcList,"^",3),arcimid=$p(PisArcList,"^",4),Oeori=$p(PisArcList,"^",5)

	s PisAutoPsy=##Class(web.DHCAppPisMaster).GetPisAutoPsy(PisID) /// 病理申请尸检信息内容
	s MorToDeaPro=$p(PisAutoPsy,"^"),DisAndTrePro=$p(PisAutoPsy,"^",2),PhyAndLabTest=$p(PisAutoPsy,"^",3),FinTakRes=$p(PisAutoPsy,"^",4)

	s PisConsult=##Class(web.DHCAppPisMaster).GetPisConsult(PisID) /// 病理申请会诊信息内容
	s InsDoc=$p(PisConsult,"^"),InsHosp=$p(PisConsult,"^",2),SpecExaRes=$p(PisConsult,"^",3),ConsNote=$p(PisConsult,"^",4),ConsStaff=$p(PisConsult,"^",5)

	s PisGynWon=##Class(web.DHCAppPisMaster).GetPisGynWon(PisID)  /// 病理申请妇科信息内容
	s LastMensDate=$p(PisGynWon,"^"),MensDate=$p(PisGynWon,"^",2),PreTimes=$p(PisGynWon,"^",3),LyTimes=$p(PisGynWon,"^",4),PauFlag=$p(PisGynWon,"^",5)
	//细胞申请界面新增妇科信息 ztw 2018.10.26
	s Duration=$p(PisGynWon,"^",6),Preg=$p(PisGynWon,"^",7),Smooth=$p(PisGynWon,"^",8),Hype=$p(PisGynWon,"^",9),Light=$p(PisGynWon,"^",10)
	s Middle=$p(PisGynWon,"^",11),Heavy=$p(PisGynWon,"^",12),Bleeding=$p(PisGynWon,"^",13),CureDate=$p(PisGynWon,"^",14),AbortDate=$p(PisGynWon,"^",15),Endocrine=$p(PisGynWon,"^",16),EndoDate=$p(PisGynWon,"^",17),EndoDose=$p(PisGynWon,"^",18)

	s PisCutBas=##Class(web.DHCAppPisMaster).GetPisCutBas(PisID)  /// 病理申请取材信息内容
	s SepDate=$p(PisCutBas,"^"),SepTime=$p(PisCutBas,"^",2),FixDate=$p(PisCutBas,"^",3),FixTime=$p(PisCutBas,"^",4),BLocDesc=$p(PisCutBas,"^",5)	
	s DocName=$p(PisCutBas,"^",6),BLocID=$p(PisCutBas,"^",9),BDocID=$p(PisCutBas,"^",10),OperName=$p(PisCutBas,"^",11),OperPart=$p(PisCutBas,"^",12)
	s OperDate=$p(PisCutBas,"^",13),OperTime=$p(PisCutBas,"^",14),OperUser=$p(PisCutBas,"^",15),OperUTel=$p(PisCutBas,"^",16),OperRoom=$p(PisCutBas,"^",17)
	s SepDate=SepDate_" "_SepTime i +SepDate=0 s SepDate=""
	s FixDate=FixDate_" "_FixTime i +FixDate=0 s FixDate=""
	s OperDate=OperDate_" "_OperTime i +OperDate=0 s OperDate=""
	
	s PisTumour=##Class(web.DHCAppPisMaster).GetPisTumour(PisID)  /// 病理申请肿瘤信息内容
	s TFoundDate=$p(PisTumour,"^"),TumPart=$p(PisTumour,"^",2),TumSize=$p(PisTumour,"^",3),TransFlag=$p(PisTumour,"^",4),TransPos=$p(PisTumour,"^",5)	
	s RadCureFlag=$p(PisTumour,"^",6),CheCureFlag=$p(PisTumour,"^",7),Remark=$p(PisTumour,"^",8),TumShape=$p(PisTumour,"^",9),TumActivity=$p(PisTumour,"^",10),TumGrowthRate=$p(PisTumour,"^",11),TumTexture=$p(PisTumour,"^",12)
	
	s PisSpec="" /// 病理申请标本信息内容(分子病理用)##Class(web.DHCAppPisMasterQuery)
	s Position=$p(PisSpec,"^",1),Type=$p(PisSpec,"^",2)
	
	//曾在何处做病理检查 ztw 2018.10.26
	s OtherHospital=$p(^DHCAPPPM(PisID),"^",23)
	s OtherDate=$p(^DHCAPPPM(PisID),"^",24)
	s OtherPathology=$p(^DHCAPPPM(PisID),"^",25)
	s OtherResult=$p(^DHCAPPPM(PisID),"^",26)
	
	
    s ListData=PisID_"^"_EpisodeID_"^"_FrostFlag_"^"_EmgFlag_"^"_createDT_"^"_createDate_"^"_createTime_"^"_No_"^"_PisNo_"^"_MedRecord_"^"_MedDiag_"^"_HepatitisB_"^"_OperRes_"^"_InfDisHis
    s ListData=ListData_"^"_FoundDate_"^"_arcimid_"^"_Oeori_"^"_ItemDesc_"^"_LocID_"^"_LocDesc_"^"_MorToDeaPro_"^"_DisAndTrePro_"^"_PhyAndLabTest_"^"_FinTakRes
    s ListData=ListData_"^"_InsDoc_"^"_InsHosp_"^"_SpecExaRes_"^"_ConsNote_"^"_ConsStaff_"^"_LastMensDate_"^"_MensDate_"^"_PreTimes
    s ListData=ListData_"^"_LyTimes_"^"_PauFlag_"^"_SepDate_"^"_FixDate_"^"_BLocDesc_"^"_DocName_"^"_Position_"^"_Type
    s ListData=ListData_"^"_TFoundDate_"^"_TumPart_"^"_TumSize_"^"_TransFlag_"^"_TransPos_"^"_RadCureFlag_"^"_CheCureFlag_"^"_Remark_"^"_SendPisFlag
    s ListData=ListData_"^"_BLocID_"^"_BDocID_"^"_ApplyDocId_"^"_ApplyDocDesc_"^"_ApplyLocId_"^"_ApplyLocDesc_"^"_OperName_"^"_OperPart_"^"_OperDate_"^"_OperUser_"^"_OperUTel_"^"_OperRoom_"^"_CommonFlag
    s ListData=ListData_"^"_Duration_"^"_Preg_"^"_Smooth_"^"_Hype_"^"_Light_"^"_Middle_"^"_Heavy_"^"_OtherHospital_"^"_OtherDate_"^"_OtherPathology_"^"_OtherResult_"^"_TumShape_"^"_TumActivity_"^"_TumGrowthRate_"^"_TumTexture
	s ListData=ListData_"^"_Bleeding_"^"_CureDate_"^"_AbortDate_"^"_Endocrine_"^"_EndoDate_"^"_EndoDose
	
	s ListTitle="PisID^EpisodeID^FrostFlag^EmgFlag^CreateDT^CreateDate^CreateTime^No^PisNo^MedRecord^MedDiag^HepatitisB^OperRes^InfDisHis^FoundDate^arcimid^Oeori^ItemDesc^LocID^LocDesc^MorToDeaPro^DisAndTrePro^PhyAndLabTest^FinTakRes^InsDoc"
	s ListTitle=ListTitle_"^InsHosp^SpecExaRes^ConsNote^ConsStaff^LastMensDate^MensDate^PreTimes^LyTimes^PauFlag^SepDate^FixDate^BLocDesc^DocName^Position^Type"
	s ListTitle=ListTitle_"^TFoundDate^TumPart^TumSize^TransFlag^TransPos^RadCureFlag^CheCureFlag^Remark^SendPisFlag^BLocID^BDocID^ApplyDocId^ApplyDocDesc^ApplyLocId^ApplyLocDesc"
	s ListTitle=ListTitle_"^OperName^OperPart^OperDate^OperUser^OperUTel^OperRoom^CommonFlag"
	s ListTitle=ListTitle_"^Duration^Preg^Smooth^Hype^Light^Middle^Heavy^OtherHospital^OtherDate^OtherPathology^OtherResult^TumShape^TumActivity^TumGrowthRate^TumTexture"
	s ListTitle=ListTitle_"^Bleeding^CureDate^AbortDate^Endocrine^EndoDate^EndoDose"
	s ret=##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ret
}

/// w ##class(CIS.AN.BL.Pathology).GetPathSpecimenInfo("65")
ClassMethod GetPathSpecimenInfo(PisID As %String) As %String
{
	set specimenSub="",count=1
	k dataArr
	set pathRecordID=""
	&sql(select RowId into :pathRecordID from CIS_AN.pathologyrecord where ExternalID=:PisID)
	set jsondata=^DHCAPPPM(PisID,"JsonInfo")
	set i=1
	for
	{
		set specimenSub=$o(^DHCAPPPM(PisID,"S",specimenSub))
		quit:(specimenSub="")
		set appSpecId=PisID_"||"_specimenSub
		set appSpec=##class(User.DHCAppPisSpec).%OpenId(appSpecId)
		set dataArr(count,"Description")=appSpec.APName
		set dataArr(count,"Qty")=appSpec.APQty
		set dataArr(count,"Note")=appSpec.APRemark
		set dataArr(count,"SeqNo")=appSpec.APNO
		set dataArr(count,"ExternalID")=appSpecId
		
		set specRowId=""
		&sql(select RowId into :specRowId from CIS_AN.specimen where ExternalID=:appSpecId)
		set dataArr(count,"RowId")=specRowId
		if (##class(CIS.AN.Specimen).%ExistsId(specRowId))
		{
			set specimen=##class(CIS.AN.Specimen).%OpenId(specRowId)
			set dataArr(count,"Status")=specimen.Status	
			set dataArr(count,"StatusDesc")=##class(CIS.AN.Specimen).StatusLogicalToDisplay(specimen.Status)
			set dataArr(count,"Description")=specimen.Description
			set dataArr(count,"Qty")=specimen.Qty
			set dataArr(count,"Note")=specimen.Note
			set dataArr(count,"SeqNo")=specimen.SeqNo
		}
		else
		{
			set dataArr(count,"Status")="N"	
			set dataArr(count,"StatusDesc")="未提交"
		}
		set count=count+1
	}	
	if (##class(CIS.AN.PathologyRecord).%ExistsId(pathRecordID))
	{
		set specRowId=""
		for
		{
			set specRowId=$o(^CIS.AN.SpecimenI("IPath",pathRecordID,specRowId))
			quit:(specRowId="")
			set specimen=##class(CIS.AN.Specimen).%OpenId(specRowId)
			continue:(specimen.ExternalID'="")
			set dataArr(count,"Status")=specimen.Status	
			set dataArr(count,"StatusDesc")=##class(CIS.AN.Specimen).StatusLogicalToDisplay(specimen.Status)
			set dataArr(count,"Description")=specimen.Description
			set dataArr(count,"Qty")=specimen.Qty
			set dataArr(count,"Note")=specimen.Note
			set dataArr(count,"SeqNo")=specimen.SeqNo	
			set dataArr(count,"RowId")=specRowId
			set count=count+1
		}	
	}
	set ret=##class(CIS.AN.COM.String).ToJson(.dataArr)
	quit ret
}

}
