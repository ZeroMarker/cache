/// 无菌包业务类
Class CIS.AN.BL.SterilityPack Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2018-08-5
/// Description： 	获取无菌包卡片图片
/// Table：        	CIS_AN.SterilityPack
/// Input:			recordSheetId:手术麻醉记录表单
/// Return：       	
/// w ##class(CIS.AN.BL.SterilityPack).GetSterilityPackImage("479")
ClassMethod GetSterilityPackImage(recordSheetId As %String) As %String
{
	quit:(##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId)=0) "E^不存在ID为"_recordSheetId_"的手术麻醉记录表单。"
	set packId=0
	set len=1000
	w "S^"
	for
	{
		set packId=$order(^CIS.AN.SterilityPackI("RecordSheet",recordSheetId,packId))
		quit:(packId="")
		set pack=##class(CIS.AN.SterilityPack).%OpenId(packId)
		do pack.CardImage.Rewind()
		while(pack.CardImage.AtEnd=0)
		{
			w pack.CardImage.Read(.len)	
		}
		w "&&&"
	}	
	quit ""
}

/// w ##class(CIS.AN.BL.SterilityPack).GetBarCodeList(1432)
ClassMethod GetBarCodeList(recordSheetId As %String, splitChar As %String = ",") As %String
{
	set result=""
	&sql(declare PackCursor cursor for select BarCode into :BarCode from CIS_AN.SterilityPack where RecordSheet=:recordSheetId)
	&sql(open PackCursor)
	for
	{
		&sql(fetch PackCursor)
		quit:(SQLCODE'=0)
		set:(BarCode'="")&(result'="") result=result_splitChar
		set result=result_BarCode	
	}	
	&sql(close PackCursor)
	quit result
}

/// Creator：      	yangguobin
/// CreatDate：    	2020-06-03
/// Description： 	保存无菌包信息
/// Table：        	CIS.AN.SterilityPack  CIS.AN.SterilityItem
/// Input:			dataPara:数据
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.SterilityPack).SaveSterilityPack(^TMPYGB("SaveSterilityPack",1),^TMPYGB("SaveSterilityPack",2),^TMPYGB("SaveSterilityPack",3))
ClassMethod SaveSterilityPack(PackNodataPara As %String, SterilityItemdataPara As %String, operInfo) As %String
{
	set $zt="Error"
	set ^TMPYGB("SaveSterilityPack",1)=PackNodataPara
	set ^TMPYGB("SaveSterilityPack",2)=SterilityItemdataPara
	set ^TMPYGB("SaveSterilityPack",3)=operInfo
	set sc=##class(CIS.AN.COM.String).ToArray(PackNodataPara,.array)
	
	m firstData=array(1)
	tstart
	set:$get(firstData("RecordSheet"))'="" recordSheetId=firstData("RecordSheet")
	if (##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId)=0)
	{
		trollback
		quit "E^"_recordSheetId	
	}
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set opsId=recordSheet.OperSchedule.%Id()
	
	set dataIndex=0,saveResult="",packNo=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		m SterilityPackData=array(dataIndex)
		set SterilityPackData("RecordSheet")=recordSheetId
		set packNo=SterilityPackData("BarCode")
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.SterilityPackData)
		quit:($piece(saveResult,"^",1)'="S")
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	b ;002
	//if ($piece(saveResult,"^",2)>0)
	set sc=##class(CIS.AN.COM.String).ToArray(SterilityItemdataPara,.array)
	m firstData=array(1)
	set ItemdataIndex=0,saveItemResult=""
	for
	{
		set ItemdataIndex=$order(array(ItemdataIndex))
		quit:(ItemdataIndex="")
		m SterilityItemData=array(ItemdataIndex)
		set SterilityItemData("RecordSheet")=recordSheetId
		set SterilityItemData("SterilityPack")=$piece(saveResult,"^",2)
		set saveItemResult=##class(CIS.AN.COM.DataService).SaveData(.SterilityItemData)
		quit:($piece(saveItemResult,"^",1)'="S")
	}
	b ;001
	if ($piece(saveItemResult,"^",1)'="S")
	{
		trollback
		quit saveItemResult	
	}
	///回传消毒供应
	set sc=##class(CIS.AN.COM.String).ToArray(operInfo,.operInfoarray)
	set dateTime=+$h
	set PatientID=operInfoarray(1,"PatientID")
	set opaId=operInfoarray(1,"OPAID")
	set CircualNurse=operInfoarray(1,"CircualNurse")
	set CircualNurse=$P(CircualNurse,",",1)
	set ScrubNurse=operInfoarray(1,"ScrubNurse")
	set ScrubNurse=$P(ScrubNurse,",",1)
	set ArrOperRoom=operInfoarray(1,"ArrOperRoom")
	set PatName=operInfoarray(1,"PatName")
	set AppCareProvID=operInfoarray(1,"AppCareProvID")
	set OperDesc=operInfoarray(1,"OperDesc")
	
	s yg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",29)						//OPA_PATestHBsAg  	免疫乙肝表面抗原
	s bg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",34)						//OPA_PATestHCVAb 	免疫丙型肝炎抗体
	s az=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",35)						//OPA_PATestHivAb 	免疫艾滋病毒抗体
	s md=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",36)						//OPA_PATestTPAb 	免疫梅毒
	s PATestOther=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",2)				//OPA_PATestOther	检其它阴阳性
	s infectName=""
	i yg="阳性" s infectName="乙肝阳性"_" "
	i bg="阳性" s infectName=infectName_"丙肝阳性"_" "
	i az="阳性" s infectName=infectName_"艾滋病阳性"_" "
	i md="阳性" s infectName=infectName_"梅毒阳性"_" "
	i PATestOther="阳性" s infectName=infectName_"其他阳性"_" "
	set RtnObj=##class(web.CSSDHUI.Interface.CSSDTransOP).InsertRec(packNo,dateTime,PatientID,opaId,OperDesc,infectName,AppCareProvID,ArrOperRoom,ScrubNurse,CircualNurse,PatName)
	
	if (RtnObj.success'="0")
	{
		set retcssd=RtnObj.msg
		trollback
		quit "E^手术回传失败原因："	_retcssd
	}
	tcommit
	quit "S^"
	
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator: ygb
/// CreatDate: 2020-06-02
/// Description: 获取消毒包信息
/// Table：DHC_ANC_OPCount,DHC_ANC_OPCountType
/// Input：
/// Return：项目代码,项目描述,清点类型,项目ID,清点类型ID
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindCSSDItemByPackNo","001001020000001")
Query FindCSSDItemByPackNo(packNo As %String = "") As %Query(ROWSPEC = "SurgicalMaterial:%String,SurgicalMaterialDesc:%String,DefaultQty:%String,packNo:%String,packName:%String,ItemId:%String")
{
}

ClassMethod FindCSSDItemByPackNoExecute(ByRef qHandle As %Binary, packNo As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s packageDr=""
	&sql(SELECT CSSDT_Package_DR into:packageDr FROM sqluser.CSSD_Trans WHERE CSSDT_Label=:packNo)
	//&sql(SELECT CSSDCD_PackDR,CSSDCD_PackName into:packageDr,:packName FROM sqluser.cssd_codedict WHERE CSSDCD_Code=:packNo)
	q:packageDr="" "不存在此消毒包"
	&sql(SELECT CSSDP_Desc into:packName FROM sqluser.CSSD_Package WHERE CSSDP_Rowid=:packageDr)
	set packName=##class(CIS.AN.COM.String).GetTranslationByBDP("User.CSSDPackage","CSSDPDesc",packName)  //多语言改造翻译后台数据 YL 20230414
	s id="" f  s id=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",packageDr,id)) q:id=""  d
	.s objPackageItem=""
	.s objPackageItem=##class(User.CSSDPackageItem).%OpenId(id)
	.q:objPackageItem=""
	.s itmDr=objPackageItem.CSSDPIItmDR.%Id()
	.q:itmDr=""
	.s SurgicalMaterial=""
	.s SurgicalMaterialDesc=objPackageItem.CSSDPIItmDR.CSSDIDesc
	.s SurgicalMaterialDesc=##class(CIS.AN.COM.String).GetTranslationByBDP("User.CSSDItem","CSSDIDesc",SurgicalMaterialDesc)  //多语言改造翻译后台数据 YL 20230414
	.s ItemId=itmDr
	.s DefaultQty=objPackageItem.CSSDPIQty
	.d OutputRow  
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(SurgicalMaterial,SurgicalMaterialDesc,DefaultQty,packNo,packName,ItemId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCSSDItemByPackNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCSSDItemByPackNoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCSSDItemByPackNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCSSDItemByPackNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(CIS.AN.BL.SterilityPack).JudgeCSSDValid("001001004000005","I")
ClassMethod JudgeCSSDValid(packNo As %String, packType As %String) As %String
{
	q:(packNo="")||(packType="") "包号与包类型不能为空"
	s SterilityPackId=$O(^CIS.AN.SterilityPackI("IBarCode"," "_packNo,""))
	q:+SterilityPackId>0 "该消毒包已绑定病人，请更换消毒包重新扫码！！"
	s packageDr="",packStatus=""
	&sql(SELECT CSSDT_Package_DR,CSSDT_Status into:packageDr,:packStatus FROM sqluser.CSSD_Trans WHERE CSSDT_Label=:packNo)
	q:packageDr="" "不存在此消毒包"
	q:"DR"'[packStatus "消毒包未接收或发放"
	&sql(SELECT CSSDP_PackTypeDetail into:PackTypeDetail FROM sqluser.CSSD_Package WHERE CSSDP_Rowid=:packageDr)
	q:(packType="I")&&(PackTypeDetail'=1) "非手术器械包"
	q:(packType="D")&&(PackTypeDetail'=7) "非敷料包"   //1-手术器械包，2-普通包，3-清洗筐，4-清洗车，5-灭菌筐，6-灭菌车，7-辅料包，8-一次性，9-急救包，10-专科器械包
	q 0
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.SterilityPack","FindOperScheduleList","12")
Query FindOperScheduleList(opsId As %String = "") As %Query(ROWSPEC = "HospitalID,HospitalNumber,PatientName,OperationDepartmentID,OperationDepartmentName,DepartmentID,DepartmentName,Gender,Age,BedNumber,OperationNameID,OperationName,OperationRoom,OperationOrder,OperationDate,OperatorID,Operator,Position,OperatonState,Anesthesia,AnesthesiaUserID,AnesthesiaUserName,CirculatingNurseID,CirculatingNurse,ScrubNurseID,ScrubNurse,InumentNurseID,InumentNurse,IsUseExternalInstrument,CreateTime,Remark") [ SqlProc ]
{
}

ClassMethod FindOperScheduleListExecute(ByRef qHandle As %Binary, opsId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set HospitalID="",HospitalNumber="",PatientName="",OperationDepartmentID="",OperationDepartmentName="",DepartmentID="",DepartmentName="",Gender="",Age=""
	set BedNumber="",OperationNameID="",OperationName="",OperationRoom="",OperationOrder="",OperationDate="",OperatorID="",Operator="",Position="",OperatonState=""
	set Anesthesia="",AnesthesiaUserID="",AnesthesiaUserName="",CirculatingNurseID="",CirculatingNurse="",ScrubNurseID="",ScrubNurse="",InumentNurseID="",InumentNurse="",IsUseExternalInstrument=""
	set CreateTime="",Remark=""
	
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set EpisodeID=operSchedule.EpisodeID
	set ExtAnaestID=operSchedule.ExtAnaestID
	set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",EpisodeID)
	
	set HospitalID=patInfoObj.GetValue("MedcareNo")	
	set HospitalID=patInfoObj.GetValue("MedcareNo")
	set PatientName=patInfoObj.GetValue("PatName")
	set OperationDepartmentID=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCCode",operSchedule.OperDeptID)
	set OperationDepartmentName=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.OperDeptID)
	set DepartmentID=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCCode",operSchedule.PatDeptID)
	set DepartmentName=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
	set Gender=patInfoObj.GetValue("PatGender")
	set Age=patInfoObj.GetValue("PatAge")
	
	set BedNumber=##class(CIS.AN.COM.String).GetDescByID("User.PACBed","BEDCode",operSchedule.PatBedID)
	set:(BedNumber="") BedNumber=operSchedule.PatBedID
	set planOperData=##class(CIS.AN.BL.OperScheduleList).GetPlanOperList(opsId,.planOperData)		// 拟施手术
	set OperationNameID=planOperData(1,"Operation")
	set OperationName=planOperData(1,"OperationDesc")
	if (operSchedule.OperRoom'="")
	{
		set OperationRoom=operSchedule.OperRoom.Description			// 手术间名称
	}
	set OperationOrder=operSchedule.OperSeq
	set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")			// 手术日期(计划)
	set OperTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.OperTime,"")	
	set OperationDate=OperDate_" "_OperTime
	set OperatorID=planOperData(1,"Surgeon")
	set Operator=planOperData(1,"SurgeonDesc")
	set Position=planOperData(1,"BodySiteDesc")
	set OperatonState=operSchedule.Status.Description
	set Anesthesia=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",operSchedule.PrevAnaMethod,"+","Y")
	set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
	set AnesthesiaUserID=anaestObj.GetValue("Anesthesiologist")
	set AnesthesiaUserName=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",operSchedule.PrevAnaMethod,"+","Y")
	set CirculatingNurseID=operSchedule.CircualNurse
	set CirculatingNurse=##class(CIS.AN.BL.OperationList).GetCareProvDesc(CirculatingNurseID)
	set ScrubNurseID=ScrubNurse=operSchedule.ScrubNurse
	set ScrubNurse=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ScrubNurseID)
	set InumentNurseID=operSchedule.ScrubNurse
	set InumentNurse=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ScrubNurseID)
	set IsUseExternalInstrument="0"
	
	set CreateTime=$ZD(+$h,3)_" "_$ZT($P($h,",",2))
	set Remark=""
	set data=$lb(HospitalID,HospitalNumber,PatientName,OperationDepartmentID,OperationDepartmentName,DepartmentID,DepartmentName,Gender,Age,BedNumber,OperationNameID,OperationName,OperationRoom,OperationOrder,OperationDate,OperatorID,Operator,Position,OperatonState,Anesthesia,AnesthesiaUserID,AnesthesiaUserName,CirculatingNurseID,CirculatingNurse,ScrubNurseID,ScrubNurse,InumentNurseID,InumentNurse,IsUseExternalInstrument,CreateTime,Remark)
	
	Set ^CacheTemp(repid,ind)=data
	s qHandle=$lb(0,repid,0)
	q $$$OK
}

ClassMethod FindOperScheduleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperScheduleListExecute ]
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

ClassMethod FindOperScheduleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperScheduleListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// w ##class(CIS.AN.BL.SterilityPack).GetOperInfotoJson(12)
ClassMethod GetOperInfotoJson(opId)
{
	quit:##class(CIS.AN.OperSchedule).%ExistsId(opId)=0 "手术Id不存在"
	set JsonData=##class(CIS.AN.COM.String).QueryToJSON("CIS.AN.BL.SterilityPack","FindOperScheduleList",opId)
	quit JsonData
}

/// Creator：        冯涛
/// CreatDate：      2023-1-16
/// Description：    获取已扫描消毒包信息
/// Table：          CIS_AN.SterilityPack
/// Input:           recordSheetId:表单ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.SterilityPack","FindUsedPackList","1432")
Query FindUsedPackList(recordSheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
       Description,
       BarCode
       from CIS_AN.SterilityPack
       where RecordSheet=:recordSheetId
}

/// w ##class(CIS.AN.BL.SterilityPack).CancelPackage(446, "100024002000001")
/// w ##class(web.CSSDHUI.Interface.CSSDTransOP).CancelPackageBind("100024002000001")
ClassMethod CancelPackage(opsId, packageNo)
{
	if (opsId="")
	{
		return "opsId为空"
	}
	if (packageNo="")
	{
		return "包号为空"
	}
	&sql(delete FROM CIS_AN.SurgicalInventory 
	WHERE RecordSheet->OperSchedule=:opsId and SterilityPack->BarCode=:packageNo)
	&sql(DELETE FROM CIS_AN.SterilityPack WHERE RecordSheet->OperSchedule=:opsId AND BarCode=:packageNo)
	set res=##class(web.CSSDHUI.Interface.CSSDTransOP).CancelPackageBind(packageNo)  //##class(CIS.AN.SRV.OPCountWebServiceClient).Get().CacelPackage(opaId,packageNo)
	return res.msg
	/*if res=0
	{
		return "成功"
	}
	else 
	{
		return "失败"_res
	}*/
}

/// w ##class(CIS.AN.BL.SterilityPack).GetPackIdByBarCode("10001900100000501")
ClassMethod GetPackIdByBarCode(packNo As %String) As %String
{
	set result = ""
	try
	{
		set result = $O(^CIS.AN.SterilityPackI("IBarCode"," "_packNo,""))
		return result
	}
	catch exp
	{
		return result
	}
}

}
