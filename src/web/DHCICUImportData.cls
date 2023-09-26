/// 创 建 者：lijie
/// 描    述：web.DHCICUImportData是从第三方HIS获取的数据分开，检查和处理的，与第三方HIS相关，
/// 	          此方法可以用WebService调用。
/// 	
/// 创建日期：2015年11月15日
Class web.DHCICUImportData Extends %RegisteredObject
{

/// 保存或插入病人信息，就诊信息，转科信息
/// para=PatientNo_"^"_InpNO_"^"_Name_"^"_Sex_"^"_DateOfBirth_"^"_Citizenship_"^"_Nation_"^"_IDNO_"^"_
/// 		ChargeType_"^"_PhoneNumberHome_"^"_PhoneNumbeBusiness_"^"_NextOfKin_"^"_MotherPatientID_"^"_NextOfKinPhome_"^"_
/// 		MedicareNo_"^"_paadmNo_"^"_admType_"^"_deptCode_"^"_wardCode_"^"_bedCode_"^"_admDate_"^"_receiveDocCode_"^"_
/// 		residentDocCode_"^"_attendingDocCode_"^"_mrcidDesc_"^"_transId_"^"_transDateTime_"^"_BedCode2_"^"_transUpdateUserCode_"^"_
/// 		transDocCtcpCode_"^"_transBedCode_"^"_updateDateTime_"^"_bloodType
/// 
/// w ##class(web.DHCICUImportData).SaveTransAdmInfo(para)
ClassMethod SaveTransAdmInfo(para As %String, serialNo As %String = "") As %String
{
	set para=$tr(para,$c(0))
	
	quit:para="" "-1^para不能为空"
	
	set dateTime=$p(para,"^",34)
	//quit:$g(^tmpTransAdm(dateTime))=para 0
	
	set ^tmpTransAdm(dateTime)=para

	do ##class(web.DHCCLImportData).Log("Record","开始SaveTransAdmInfo，para="_para)
	
	do ##class(web.DHCCLImportData).LogNew("Trans","1.插入转科数据",serialNo,"开始插入转科数据，para="_para,"Success")
	
	set $zt="ERROR"
	set PatientNo=$p(para,"^",2)
	set InpNO=$p(para,"^",3)
	set Name=$p(para,"^",4)
	set Sex=$p(para,"^",5)
	set DateOfBirth=$p(para,"^",6)
	set Citizenship=$p(para,"^",7)
	set Nation=$p(para,"^",8)
	set IDNO=$p(para,"^",9)
	set ChargeType=$p(para,"^",10)
	set PhoneNumberHome=$p(para,"^",11)
	set PhoneNumbeBusiness=$p(para,"^",12)
	set NextOfKin=$p(para,"^",13)
	set MotherPatientID=$p(para,"^",14)
	set NextOfKinPhome=$p(para,"^",15)
	set BloodType=$p(para,"^",16)
	set MedicareNo=$p(para,"^",17)
	set paadmNo=$p(para,"^",18)
	set admType=$p(para,"^",19)
	set deptCode=$p(para,"^",20)
	set wardCode=$p(para,"^",21)
	set bedCode=$p(para,"^",22)
	set admDate=$p(para,"^",23)
	set receiveDocCode=$p(para,"^",24)
	set residentDocCode=$p(para,"^",25)
	set attendingDocCode=$p(para,"^",26)
	set mrcidDesc=$p(para,"^",27)
	set transId=$p(para,"^",28)
	set transDateTime=$p(para,"^",29)
	set OpBedCode=$p(para,"^",30)
	set transUpdateUserCode=$p(para,"^",31)
	set transDocCtcpCode=$p(para,"^",32)
	set transBedCode=$p(para,"^",33)
	set updateDateTime=$p(para,"^",34)
	
	//----------------病人基本信息----------------
	set DateOfBirth=##class(web.DHCICUImportData).GetDate(DateOfBirth)
	if Sex="" set Sex=0 //未知性别
	if Citizenship="" set Citizenship=1
	if (Nation="01")!(Nation="") set Nation=1
	if BloodType="" set BloodType=5 //未知血型
	else  if '$d(^PAC("BLDT",BloodType)) set BloodType=5 
	set len=$l(admDate," ")
	if len'=2 do ##class(web.DHCCLImportData).LogNew("Trans","2.就诊日期",serialNo,"就诊日期格式不对，admDate="_admDate,"Error")
	quit:len'=2 "就诊日期格式不对，admDate="_admDate
	set DateOfBirth=##class(web.DHCICUImportData).GetDate(DateOfBirth)
	
	
	//-----------------就诊医生Id及用户Id-----------------------------------------------
	set receiveDocId=""
	if receiveDocCode'="" set receiveDocId=$o(^CTPCP(0,"Code",receiveDocCode,""))
	set transDocCtcpId=""
	if transDocCtcpCode'="" set transDocCtcpId=$o(^CTPCP(0,"Code",transDocCtcpCode,"")) 
	if receiveDocId="" set receiveDocId=transDocCtcpId
	
	set transUpdateUserId=""
	if transUpdateUserCode'="" set transUpdateUserId=$o(^CTPCP(0,"Code",transUpdateUserCode,""))
	if receiveDocId="" set receiveDocId=transUpdateUserId
	
	set attendingDocId=""
	if attendingDocCode'="" set attendingDocId=$o(^CTPCP(0,"Code",attendingDocCode,""))
	if receiveDocId="" set receiveDocId=attendingDocId
	
	if receiveDocId="" do ##class(web.DHCCLImportData).Log("Error","SaveTransAdmInfo--receiveDocId为空,PatientNo="_PatientNo_",transId="_transId)
	if receiveDocId="" do ##class(web.DHCCLImportData).LogNew("Trans","3.就诊医生",serialNo,"就诊医生Id为空，transId="_transId,"Error")
	quit:receiveDocId="" "-1^就诊医生Id为空"
	
	set userId=##class(web.DHCCLImportData).GetUserIdByCtcpId(receiveDocId)
	if userId="" do ##class(web.DHCCLImportData).LogNew("Trans","4.用户Id",serialNo,"用户Id为空，receiveDocId="_receiveDocId,"Error")
	if userId="" do ##class(web.DHCCLImportData).Log("Error","SaveTransAdmInfo-userId为空,receiveDocId="_receiveDocId_",PatientNo="_PatientNo_",transId="_transId)
	
	//-----------------就诊日期和病人病区，科室，床位-----------------------------------
	set admDate=$p(admDate,".",1)
	set deptId="" 
	if deptCode'="" set deptId=$o(^CTLOC(0,"Code",deptCode,""))
	if deptId="" do ##class(web.DHCCLImportData).LogNew("Trans","5.科室",serialNo,"科室Id为空，deptCode="_deptCode,"Error")
	if deptId="" do ##class(web.DHCCLImportData).Log("Error","SaveTransAdmInfo--deptId为空"_",PatientNo="_PatientNo_",transId="_transId)
	q:deptId="" "-2^科室ID为空"
	
	set wardId=""
	if wardCode'="" set wardId=$o(^PAWARD(0,"WARD_Code",wardCode,""))
	if wardId="" do ##class(web.DHCCLImportData).Log("Error","SaveTransAdmInfo--wardId为空"_",PatientNo="_PatientNo_",transId="_transId)
	q:wardId="" "-3^病区Id为空"
	
	set bedId=##class(web.DHCCLImportData).GetBedIdByWardIdAndBedCode(wardId,bedCode)
	
	//------------------------------------------------------------------------------------
	set PAPMIDr=##class(web.DHCCLImportData).GetPAPMIDrByPatientID(PatientNo)
	do ##class(web.DHCCLImportData).LogNew("Trans","插入转科数据",serialNo,"开始保存病人信息！！"_"PAPMIDr="_PAPMIDr_",Name="_Name_",Sex="_Sex_",DateOfBirth="_DateOfBirth_",Citizenship="_Citizenship_",Nation="_Nation_",IDNO="_IDNO_",PhoneNumberHome="_PhoneNumberHome_",PhoneNumbeBusiness="_PhoneNumbeBusiness_",BloodType="_BloodType,"Success")
	do ##class(web.DHCCLImportData).Log("Record","开始保存病人信息！！"_"PAPMIDr="_PAPMIDr_",Name="_Name_",Sex="_Sex_",DateOfBirth="_DateOfBirth_",Citizenship="_Citizenship_",Nation="_Nation_",IDNO="_IDNO_",PhoneNumberHome="_PhoneNumberHome_",PhoneNumbeBusiness="_PhoneNumbeBusiness_",BloodType="_BloodType)
	if PAPMIDr=""
	{
		set ret=##class(web.DHCCLImportData).SavePatInfo("",Name,Sex,DateOfBirth,Citizenship,Nation,IDNO,PhoneNumberHome,PhoneNumbeBusiness,BloodType,userId,MedicareNo)
		if ret<0  do ##class(web.DHCCLImportData).Log("Error","新建病人信息报错SQLCODE--"_ret)
		else  set PAPMIDr=ret
		
		if PAPMIDr'="" set ret2=##class(web.DHCCLImportData).SavePatMapped(PAPMIDr,PatientNo)
	}
	else
	{
		set ret=##class(web.DHCCLImportData).SavePatInfo(PAPMIDr,Name,Sex,DateOfBirth,Citizenship,Nation,IDNO,PhoneNumberHome,PhoneNumbeBusiness,BloodType,userId,MedicareNo)
		if ret<0  d ##class(web.DHCCLImportData).Log("Error","保存病人信息报错SQLCODE--"_ret)
	}
	
	if PAPMIDr="" do ##class(web.DHCCLImportData).Log("Error","SaveTransAdmInfo--插入或保存病人信息失败")  
	q:PAPMIDr="" "-4^病人Id为空"
	
	do ##class(web.DHCCLImportData).LogNew("Trans","插入转科数据",serialNo,"插入病人信息完成！!PAPMIDr="_PAPMIDr,"Success")
	do ##class(web.DHCCLImportData).Log("Record","插入病人信息完成！!--PAPMIDr="_PAPMIDr)
	
	//--------------------------------------------------------------------------
	set EpisodeID=##class(web.DHCCLImportData).GetAdmDrByMappedAdmNo(paadmNo)
	do ##class(web.DHCCLImportData).LogNew("Trans","插入就诊信息",serialNo,"开始插入就诊信息！！papmiDr="_PAPMIDr_",admDate="_admDate_",deptId="_deptId_",receiveDocId="_receiveDocId_",userId="_userId_",wardId="_wardId_",bedId="_bedId_",mrcidDesc="_mrcidDesc,"Success")
	do ##class(web.DHCCLImportData).Log("Record","开始插入就诊信息！！papmiDr="_PAPMIDr_",admDate="_admDate_",deptId="_deptId_",receiveDocId="_receiveDocId_",userId="_userId_",wardId="_wardId_",bedId="_bedId_",mrcidDesc="_mrcidDesc)
	if EpisodeID=""
	{
		set ret=##class(web.DHCCLImportData).InsertAdmInfo(PAPMIDr, admDate, deptId, receiveDocId, userId, wardId, bedId, mrcidDesc)
		if +$p(ret,"^",1)<0 do ##class(web.DHCCLImportData).Log("Error","InsertAdmInfo Error--"_ret)
		else  set EpisodeID=ret
		
		if EpisodeID'="" set ret2=##class(web.DHCCLImportData).SavePaAdmMapped(EpisodeID,paadmNo)
	}
	
	if EpisodeID=""  do ##class(web.DHCCLImportData).Log("Error","SaveTransAdmInfo--插入就诊信息失败")
	q:EpisodeID="" "-5^就诊号为空"
	
	//保存诊断
	set ret=##class(web.DHCCLImportData).SaveMrcidDesc(EpisodeID,mrcidDesc)
	
	do ##class(web.DHCCLImportData).LogNew("Trans","插入就诊数据",serialNo,"插入就诊信息完成！!EpisodeID="_EpisodeID,"Success")
	do ##class(web.DHCCLImportData).Log("Record","插入就诊信息完成！!--EpisodeID="_EpisodeID)
	
	//-----------------------------------------------------------------------------------
	quit:(EpisodeID="")!(wardId="")!(userId="") "-6^EpisodeID, wardId, userId都不能为空"
	do ##class(web.DHCCLImportData).LogNew("Trans","插入转科数据",serialNo,"开始插入转科信息！！"_"EpisodeID="_EpisodeID_",userId="_userId_",wardId="_wardId_",bedId="_bedId_",deptId="_deptId_",transId="_transId,"Success")
	do ##class(web.DHCCLImportData).Log("Record","开始插入转科信息！！"_"EpisodeID="_EpisodeID_",userId="_userId_",wardId="_wardId_",bedId="_bedId_",deptId="_deptId_",transId="_transId)
	set ret=0
	//if (transId'="") do
	if '$d(^tmp("transId",transId)) do
	.do ##class(web.DHCCLImportData).Log("Record","开始转科,EpisodeID="_EpisodeID_",userId="_userId_",wardId="_wardId_",bedId="_bedId_",deptId="_deptId_",transId="_transId)
	.set ret=##class(web.DHCCLImportData).TransAdm(EpisodeID, userId, wardId, bedId, deptId)
	.do ##class(web.DHCCLImportData).Log("Record","转科结果,ret="_ret)
	.if $p(ret,"^",1)=0 s ^tmp("transId",transId)=$p(ret,"^",2)
	else  do
	.do ##class(web.DHCCLImportData).Log("Record","转科Id已存在,transId="_transId)
	
	q ret
		
ERROR	;
	set ErrorMsg=$ZE
	do ##class(web.DHCCLImportData).LogNew("Trans","插入转科数据报错",serialNo,"ErrorMsg:"_ErrorMsg,"ExternalError")
	if ErrorMsg'="" do ##class(web.DHCCLImportData).Log("Error","SaveTransAdmInfo Error--"_ErrorMsg_",transId="_$g(transId))
	q ErrorMsg
}

/// 插入医嘱信息
/// para=paadmNo_"^"_arcimCode_"^"_arcimDesc_"^"_startDateTime_"^"_endDateTime_"^"_dose_"^"_doseUnitCode_"^"_qty_"^"_
/// 		qtyUnitCode_"^"_oecprCode_"^"_phcinCode_"^"_phcfrCode_"^"_ostatCode_"^"_ctcpCode_"^"_ctcpdatetime_"^"_disconDateTime_"^"_
/// 		disconCtctCode_"^"_dayExecTimes_"^"_reclocCode_"^"_oeoreExpDateTime_"^"_oeoreDateTime_"^"_oeoreCtcpCode_"^"_updateDateTime_"^"_ID
/// w ##class(web.DHCICUImportData).InsertOeordItem(para)
ClassMethod InsertOeordItem(para As %String, serialNo As %String = "") As %String
{
	set para=$tr(para,$c(0))
	
	quit:para="" "-1^para不能为空"
	
	set testID=$p(para,"^",1)
	//quit:$g(^tmpOeori(testID))=para 0
	
	set ^tmpOeori(testID)=para
	
	do ##class(web.DHCCLImportData).Log("Record","开始InsertOeordItem，para="_para)
	set $zt="ERROR"
	set paadmNo=$p(para,"^",2)
	set oeoriNo=$p(para,"^",3)
	set arcimCode=$p(para,"^",4)
	set arcimDesc=$p(para,"^",5)
	set startDateTime=$p(para,"^",6)
	set endDateTime=$p(para,"^",7)
	set dose=$p(para,"^",8)
	set doseUnitCode=$p(para,"^",9)
	set qty=$p(para,"^",10)
	set qtyUnitCode=$p(para,"^",11)
	set oecprCode=$p(para,"^",12)
	set phcinCode=$p(para,"^",13)
	set phcfrCode=$p(para,"^",14)
	set seqNo=$p(para,"^",15)
	set ostatCode=$p(para,"^",16)
	set ctcpCode=$p(para,"^",17)
	set ctcpdatetime=$p(para,"^",18)
	set disconDateTime=$p(para,"^",19)
	set disconCtcpCode=$p(para,"^",20)
	set dayExecTimes=$p(para,"^",21)
	set reclocCode=$p(para,"^",22)
	set oeoreNo=$p(para,"^",23)
	set oeoreExpDateTime=$p(para,"^",24)
	set oeoreDateTime=$p(para,"^",25)
	set oeoreCtcpCode=$p(para,"^",26)
	set updateDateTime=$p(para,"^",27)
	set ID=oeoriNo
		
	set isDebug=$g(^tmp("isDebug"))
	
	//病人就诊号
	set EpisodeID=##class(web.DHCCLImportData).GetAdmDrByMappedAdmNo(paadmNo)
	if EpisodeID="" do ##class(web.DHCCLImportData).LogNew("Oeori","插入医嘱信息",serialNo,"病人就诊号不存在,paadmNo="_paadmNo,"Error")
	if EpisodeID="" do ##class(web.DHCCLImportData).Log("Error","InsertOeordItem 病人就诊号不存在,paadmNo="_paadmNo)
	q:EpisodeID="" "-1^就诊号为空"
	
	if isDebug do ##class(web.DHCCLImportData).Log("Record","1. EpisodeID="_EpisodeID)
	
	//下医嘱用户Id
	set ctcpId=""
	if ctcpCode'="" set ctcpId=$o(^CTPCP(0,"Code",ctcpCode,""))
	if ctcpId="" do ##class(web.DHCCLImportData).Log("Error","InsertOeordItem 下医嘱医护人员Id不存在,ctcpCode="_ctcpCode) 
	q:ctcpId="" "-2^医护人员号为空"
	
	set userId=##class(web.DHCCLImportData).GetUserIdByCtcpId(ctcpId)
	if userId="" do ##class(web.DHCCLImportData).Log("Error","InsertOeordItem 下医嘱用户Id为空,ctcpCode="_ctcpCode)
	q:userId="" "-3^用户Id为空"
	
	if isDebug do ##class(web.DHCCLImportData).Log("Record","2. ctcpCode="_ctcpCode)
	
	//医嘱码Id
	set arcimId=##class(web.DHCCLImportData).GetArcimIdByCode(arcimCode)
	//if arcimId="" do ##class(web.DHCCLImportData).Log("Error","InsertOeordItem 医嘱码id不存在,arcimCode="_arcimCode_",arcimDesc="_arcimDesc)
	q:arcimId="" "-1^医嘱码不存在"
	
	if isDebug do ##class(web.DHCCLImportData).Log("Record","3. arcimCode="_arcimCode)
	
	//医嘱优先级Id
	set oecprId=""
	if oecprCode'="" set oecprId=$o(^OECPR(0,"Code",$$ALPHAUP^SSUTIL4(oecprCode),""))
	if oecprId="" set oecprId=$o(^OECPR(0,"Code",$$ALPHAUP^SSUTIL4("NORM"),""))  //临时医嘱
	q:oecprId="" "-4^医嘱优先级Id为空"
	
	if isDebug do ##class(web.DHCCLImportData).Log("Record","4.oecprCode="_oecprCode)
	
	//医嘱状态Id
	set oecStatusId=""
	//if ostatCode'="" set oecStatusId=$o(^OEC("OSTAT",0,"Code",$$ALPHAUP^SSUTIL4(ostatCode),""))
	//医嘱状态默认为V（核实）
	if oecStatusId="" set oecStatusId=$o(^OEC("OSTAT",0,"Code",$$ALPHAUP^SSUTIL4("V"),""))
	if oecStatusId="" do ##class(web.DHCCLImportData).Log("Error","InsertOeordItem 医嘱状态Id为空,ostatCode="_ostatCode)
	q:oecStatusId="" "-5^医嘱状态Id为空"
	
	if isDebug do ##class(web.DHCCLImportData).Log("Record","5.ostatCode="_ostatCode)
	
	//医嘱频次Id
	set freqNote=""
	//set phcfrCode=$select(phcfrCode["tid":"Tid",phcfrCode["qh":"Qh",phcfrCode["q3h":"Q3h",phcfrCode["st!":"St",phcfrCode["q12h":"Q12h",phcfrCode["qod":"Qod",phcfrCode["prn":"Prn",phcfrCode["bid":"Bid",phcfrCode["qn":"Qn",phcfrCode["q4h":"Q4h",phcfrCode["q6h":"Q6h",phcfrCode["q8h":"Q8h",phcfrCode["q2h":"Q2h",phcfrCode["qd":"Qd",1:"")
	set phcFreqId=""
	if phcfrCode'="" set phcFreqId=$o(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(phcfrCode),""))
	if phcFreqId="" set phcFreqId=$o(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4("Qd"),""))  //默认为Qd
	if phcFreqId="" do ##class(web.DHCCLImportData).Log("Error","InsertOeordItem 医嘱频次Id为空")
	q:phcFreqId="" "-6^医嘱频次Id为空"
	
	if isDebug do ##class(web.DHCCLImportData).Log("Record","6.phcfrCode="_phcfrCode)
	
	//医嘱用法Id
	set phcInId=""
	if phcinCode'="" set phcInId=$o(^PHCIN(0,"Code",$$ALPHAUP^SSUTIL4(phcinCode),""))
	if phcInId="" do ##class(web.DHCCLImportData).Log("Error","InsertOeordItem 医嘱用法Id为空 phcinCode="_phcinCode_",ID="_testID_",arcimDesc="_arcimDesc)
	q:phcInId="" "-7^医嘱用法Id为空"
	
	if isDebug do ##class(web.DHCCLImportData).Log("Record","7.phcinCode="_phcinCode)
	
	//单位
	set uomId=""
	if doseUnitCode'="" set uomId=$o(^CT("UOM",0,"Code",$$ALPHAUP^SSUTIL4(doseUnitCode),""))
	//如果单位为空，则取药品的默认单位
	if uomId="" set uomId=$p(##class(web.DHCCLImportData).GetEqUomQty(arcimId),"^",1)     //$o(^CT("UOM",0,"Code",$$ALPHAUP^SSUTIL4("ml"),""))   //ml
	if uomId="" do ##class(web.DHCCLImportData).Log("Error","InsertOeordItem 单位Id为空 doseUnitCode="_doseUnitCode)
	q:uomId="" "-8^单位Id为空"
	
	if isDebug do ##class(web.DHCCLImportData).Log("Record","8.doseUnitCode="_doseUnitCode)
	
	//剂量 如果剂量为0，则取药品的默认剂量
	set dose=$tr(dose," ")
	set dose=+dose
	if dose=0 set dose=$p(##class(web.DHCCLImportData).GetEqUomQty(arcimId),"^",2)
	if dose="" do ##class(web.DHCCLImportData).Log("Error","InsertOeordItem 剂量为空 dose="_dose)
	quit:dose="" "dose为空"
	//中南医院这边Dose是一个基本单位的药品的剂量
	set qty=$tr(qty," ")
	set qty=+qty
	if qty=0 set qty=1
	set doseQty=dose*qty
	q:doseQty="" "-8^doseQty为空"
	
	//疗程
	set phDuratId=$o(^PHCDU(0,"Code",$$ALPHAUP^SSUTIL4("1天"),""))  //1天
	q:phDuratId="" "-9^疗程为空"
	
	if isDebug do ##class(web.DHCCLImportData).Log("Record","9.phDuratId="_phDuratId)
	
	//开医嘱科室
	set userDeptId=""
	if reclocCode'="" set userDeptId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(reclocCode),""))
	if userDeptId="" do ##class(web.DHCCLImportData).Log("Error","InsertOeordItem 开医嘱科室Id为空 reclocCode="_reclocCode)
	q:userDeptId="" "-10^用户科室Id为空"
	
	if isDebug do ##class(web.DHCCLImportData).Log("Record","10.userDeptId="_userDeptId)
	
	//医嘱备注
	set notes=""
	
	//接受科室
	set recDepID=""
	if reclocCode'="" set recDepID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(reclocCode),""))
	if recDepID="" do ##class(web.DHCCLImportData).Log("Error","InsertOeordItem 接受科室Id为空 reclocCode="_reclocCode)
	q:recDepID="" "-11^接受科室Id为空"
	
	if isDebug do ##class(web.DHCCLImportData).Log("Record","11.recDepID="_recDepID)
	
	//首日次数
	set dayExecTimes=$tr(dayExecTimes," ")
	set dayExecTimes=+dayExecTimes
	
	if isDebug do ##class(web.DHCCLImportData).Log("Record","12.dayExecTimes="_dayExecTimes)
	
	if isDebug do ##class(web.DHCCLImportData).Log("Record","GetRelateOrdItemId,EpisodeID="_EpisodeID_",seqNo"_seqNo)
	//关联医嘱
	set relateOrdItemDr=##class(web.DHCICUImportData).GetRelateOrdItemId(EpisodeID,seqNo)
	do ##class(web.DHCCLImportData).LogNew("Oeori","插入医嘱信息",serialNo,"关联医嘱, seqNo="_seqNo_",relateOrdItemDr="_relateOrdItemDr,"Success")
	
	if isDebug do ##class(web.DHCCLImportData).Log("Record","13.relateOrdItemDr="_relateOrdItemDr)
	
	///执行医嘱用户Id
	set oeoreCtcpId=""
	if oeoreCtcpCode'="" set oeoreCtcpId=$o(^CTPCP(0,"Code",oeoreCtcpCode,""))
	set oeoreUserId=""
	if oeoreCtcpId'="" set oeoreUserId=##class(web.DHCCLImportData).GetUserIdByCtcpId(oeoreCtcpId)
	
	set stDate=##class(web.DHCICUImportData).GetDate(startDateTime)
	set stDate=$zdh(stDate,3)
	set stTime=##class(web.DHCICUImportData).GetTime(startDateTime)
	set stTime=$zth(stTime)
	
	//set execDate=##class(web.DHCICUImportData).GetDate(oeoreExpDateTime)
	set execDate=+$h
	
	do ##class(web.DHCCLImportData).LogNew("Oeori","插入医嘱信息",serialNo,"保存医嘱信息,EpisodeID="_EpisodeID_",userId="_userId_",arcimId="_arcimId_",oecprId="_oecprId_",oecStatusId="_oecStatusId_",phcFreqId="_phcFreqId_",phcInId="_phcInId_",uomId="_uomId_",doseQty="_doseQty_",phDuratId="_phDuratId_",userDeptId="_userDeptId_",notes="_notes_",recDepID="_recDepID_",dayExecTimes="_dayExecTimes_",relateOrdItemDr="_relateOrdItemDr_",stDate="_stDate_",stTime="_stTime,"Success")
	do ##class(web.DHCCLImportData).Log("Record","保存医嘱信息!!"_",EpisodeID="_EpisodeID_",userId="_userId_",arcimId="_arcimId_",oecprId="_oecprId_",oecStatusId="_oecStatusId_",phcFreqId="_phcFreqId_",phcInId="_phcInId_",uomId="_uomId_",doseQty="_doseQty_",phDuratId="_phDuratId_",userDeptId="_userDeptId_",notes="_notes_",recDepID="_recDepID_",dayExecTimes="_dayExecTimes_",relateOrdItemDr="_relateOrdItemDr_",stDate="_stDate_",stTime="_stTime)
	set oeoriId=##class(web.DHCCLImportData).GetOEOrdExecDrByMappedOeoreNo(ID)
	if (oeoriId="")
	{
		do ##class(web.DHCCLImportData).LogNew("Oeori","插入医嘱信息",serialNo,"医嘱不存在，开始插入医嘱，ID="_ID,"Success")
		do ##class(web.DHCCLImportData).Log("Record","开始插入医嘱信息!!，ID="_ID)
		set ret=##class(web.DHCCLImportData).InsertOrdItem(EpisodeID,userId,arcimId,oecprId,oecStatusId,phcFreqId,phcInId,uomId,doseQty,phDuratId,userDeptId,notes,recDepID,dayExecTimes,relateOrdItemDr,stDate,stTime)
		do ##class(web.DHCCLImportData).Log("Record","InsertOrdItem-->ret="_ret)
		if ($p(ret,"^",1)=0) d
		.set oeoriId=$p(ret,"^",2)
		.do ##class(web.DHCCLImportData).Log("Record","插入医嘱成功!!,oeoriId="_oeoriId)
		.set ret2=##class(web.DHCCLImportData).SaveOEOrdExecMapped(oeoriId,ID)
		.set ret3=##class(web.DHCICUImportData).SaveRelateOrdItem(EpisodeID,seqNo,oeoriId)
		.set ret4=##class(web.DHCCLImportData).GenOeordExec(oeoriId,execDate)
		.
		.set relateOrdItemDr=##class(web.DHCICUImportData).GetRelateOrdItemId(EpisodeID,seqNo,oeoriId)
		.if relateOrdItemDr'="" do
		..do ##class(web.DHCCLImportData).LogNew("Oeori","开始更新关联医嘱",serialNo,"开始更新关联医嘱，oeoriId="_oeoriId_",relateOrdItemDr="_relateOrdItemDr_",seqNo="_seqNo,"Success")
		..set ret=##class(web.DHCCLImportData).UpdateOrdItem(oeoriId,relateOrdItemDr)
		..do ##class(web.DHCCLImportData).LogNew("Oeori","更新关联医嘱",serialNo,"更新关联医嘱完成,ret="_ret,"Success")
		.
		.if (oeoreUserId'="") do
		..do ##class(web.DHCCLImportData).Log("Record","开始执行医嘱，oeoriId="_oeoriId_",oeoreUserId="_oeoreUserId_",ID="_ID)
		..set ret5=##class(web.DHCCLImportData).ExecOrdItem(oeoriId,oeoreUserId)
		..do ##class(web.DHCCLImportData).Log("Record","执行医嘱,ret="_ret5)
		else  d
		.do ##class(web.DHCCLImportData).Log("Error","InsertOeordItem--插入医嘱失败，SQLCode="_$p(ret,"^",1)_",ID="_ID)
		
	}
	else
	{
		do ##class(web.DHCCLImportData).LogNew("Oeori","插入医嘱信息",serialNo,"该医嘱已存在，oeoriId="_oeoriId_",ostatCode="_ostatCode_",oecprCode="_oecprCode_",oeoreUserId="_oeoreUserId_",ID="_ID,"Success")
		do ##class(web.DHCCLImportData).Log("Record","该医嘱已存在，oeoriId="_oeoriId_",ostatCode="_ostatCode_",oecprCode="_oecprCode_",oeoreUserId="_oeoreUserId_",ID="_ID)
		//执行医嘱
		if (ostatCode="E") do
		.do ##class(web.DHCCLImportData).Log("Record","产生医嘱执行记录，oeoriId="_oeoriId_",execDate="_execDate)
		.set ret2=##class(web.DHCCLImportData).GenOeordExec(oeoriId,execDate)
		.do ##class(web.DHCCLImportData).Log("Record","产生医嘱执行结果,ret="_ret2)
		.if (oeoreUserId'="") do
		..do ##class(web.DHCCLImportData).Log("Record","开始执行医嘱，oeoriId="_oeoriId_",oeoreUserId="_oeoreUserId_",ID="_ID)
		..set ret=##class(web.DHCCLImportData).ExecOrdItem(oeoriId,oeoreUserId)
		..do ##class(web.DHCCLImportData).Log("Record","执行医嘱,ret="_ret)
		
		
		//停医嘱
		if (ostatCode="D")&(oecprCode="S") do
		.set disconCtcpId=""
		.if disconCtcpCode'="" set disconCtcpId=$o(^CTPCP(0,"Code",disconCtcpCode,""))
		.if disconCtcpId="" set disconCtcpId=ctcpId
		.set disconUserId=##class(web.DHCCLImportData).GetUserIdByCtcpId(disconCtcpId)
		.do ##class(web.DHCCLImportData).Log("Record","停医嘱医生,disconCtcpCode="_disconCtcpCode_",disconUserId="_disconUserId)
		.//长期医嘱停医嘱
		.if (disconUserId'="") do
		..set expectEndDate=##class(web.DHCICUImportData).GetDate(disconDateTime)
		..set expectEndDate=$zdh(expectEndDate,3)
		..set expectEndTime=##class(web.DHCICUImportData).GetTime(disconDateTime)
		..set expectEndTime=$zth(expectEndTime)
		..do ##class(web.DHCCLImportData).Log("Record","StopOrdItem 开始停医嘱！，oeoriId="_oeoriId_",disconUserId="_disconUserId_",expectEndDate="_expectEndDate_",expectEndTime="_expectEndTime)
		..set ret=##class(web.DHCCLImportData).StopOrdItem(oeoriId,disconUserId,expectEndDate,expectEndTime)
		..if ret'=0 do ##class(web.DHCCLImportData).Log("Error","InsertOeordItem--停医嘱失败，ret="_ret_",ID="_ID)
		..else  do ##class(web.DHCCLImportData).Log("Record","停医嘱成功！，oeoriId="_oeoriId) 
		
	}
	
	q 0
	
ERROR	;
	set ErrorMsg=$ZE
	do ##class(web.DHCCLImportData).LogNew("Oeori","插入医嘱信息报错","0","ErrorMsg:"_ErrorMsg_",ID="_testID,"ExternalError")
	if ErrorMsg'="" do ##class(web.DHCCLImportData).Log("Error","InsertOeordItem Error--"_ErrorMsg_",ID="_testID)
	q ErrorMsg
}

/// w ##class(web.DHCICUImportData).ImportArcimData(para)
/// RowStr=ArcimCode_"^"_ArcimDesc_"^"_ArcimGenericDesc_"^"_ArcimAlia_"^"_ArcimUom_"^"_
/// 		   ArcimEqualQty_"^"_ArcimEqualUom_"^"_ArcimDefaultQty_"^"_ArcimControlCat_"^"_
/// 		   ArcimSubCat_"^"_ArcimPHCSubCat_"^"_ArcimPHCForm_"^"_ArcimPHCSpec
/// 同步药品数据
ClassMethod ImportArcimData(para As %String, serialNo As %String = "") As %String
{
	set $zt="ERROR"
	
	set para=$tr(para,$c(0))
	quit:para="" "-1^para为空"
	set ArcimCode=$p(para,"^",2)
	quit:ArcimCode="" "-2^ArcimCode为空"
	quit:$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcimCode))) "ArcimCode已存在"
	do ##class(web.DHCCLImportData).LogNew("Arcim","1.导入药品数据",serialNo,"开始导入药品数据，ArcimCode="_ArcimCode_",para="_para,"Success")
	set ret=##class(web.DHCCLImportData).ImportArcim("",para)
	if ret=0 do ##class(web.DHCCLImportData).LogNew("Arcim","2.导入药品数据",serialNo,"导入成功，ret="_ret,"Success")
	else  do ##class(web.DHCCLImportData).LogNew("Arcim","3.导入药品数据",serialNo,"导入报错，ret="_ret,"Error")
	quit ret
	
ERROR	
	set ErrorMsg=$ZE
	if ErrorMsg'="" do ##class(web.DHCCLImportData).Log("Error","ImportArcimData Error--"_ErrorMsg)
	q ErrorMsg
}

/// w ##class(web.DHCICUImportData).ImportCtcpData(para)
/// RowStr=CtcpLocCode_"^"_CtcpLocDesc_"^"_CtcpCode_"^"_CtcpDesc_"^"_
///       CtcpType_"^"_CtcpGroup_"^"_CtcpMark
/// 同步医护人员数据
ClassMethod ImportCtcpData(para As %String, serialNo As %String = "") As %String
{
	set $zt="ERROR"
	
	set para=$tr(para,$c(0))
	quit:para="" "-1^para为空"
	set CtcpCode=$p(para,"^",4)
	quit:CtcpCode="" "-2^CtcpCode为空"
	quit:$d(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(CtcpCode))) "CtcpCode已存在"
	do ##class(web.DHCCLImportData).Log("ImportData","开始导入医护人员数据，CtcpCode="_CtcpCode_",para="_para) 
	set ret=##class(web.DHCCLImportData).ImportCtcp("",para)
	do ##class(web.DHCCLImportData).Log("ImportData","导入结果，ret="_ret)
	quit ret
	
ERROR	
	set ErrorMsg=$ZE
	if ErrorMsg'="" do ##class(web.DHCCLImportData).Log("Error","ImportCtcpData Error--"_ErrorMsg)
	q ErrorMsg
}

/// w ##class(web.DHCICUImportData).ImportCtlocData(para)
/// RowStr=LocCode_"^"_LocDesc_"^"_LocType_"^"_
///       HospitalCode_"^"_LinkLoc_"^"_LocTel_"^"_LocContactName
/// 同步科室数据
ClassMethod ImportCtlocData(para As %String, serialNo As %String = "") As %String
{
	set $zt="ERROR"
	
	set para=$tr(para,$c(0))
	quit:para="" "-1^para为空"
	set LocCode=$p(para,"^",2)
	quit:LocCode="" "-2^LocCode为空"
	quit:$d(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode))) "-3^LocCode已存在"
	do ##class(web.DHCCLImportData).Log("ImportData","开始导入科室数据，LocCode="_LocCode_",para="_para) 
	set ret=##class(web.DHCCLImportData).ImportCtloc("",para)
	do ##class(web.DHCCLImportData).Log("ImportData","导入结果，ret="_ret)
	quit ret
	
ERROR	
	set ErrorMsg=$ZE
	if ErrorMsg'="" do ##class(web.DHCCLImportData).Log("Error","ImportCtlocData Error--"_ErrorMsg)
	q ErrorMsg
}

/// 第三方传来的日期时间格式类似这样   2012-01-17 10:05:27.000
/// w ##class(web.DHCICUImportData).GetDate("2012-01-17 10:05:27.000")
ClassMethod GetDate(dt As %String) As %String
{
	quit:dt="0001-01-01" $zd(+$h,3)
	quit:dt="" $zd(+$h,3)
	set date=$p(dt," ",1)
	quit date
}

/// w ##class(web.DHCICUImportData).GetTime("2012-01-17 10:05:27.000")
ClassMethod GetTime(dt As %String) As %String
{
	quit:dt="" $zt($p($h,",",2))
	set time=$p($p(dt," ",2),".",1)
	quit time
}

/// 获取关联医嘱ID
/// w ##class(web.DHCICUImportData).GetRelateOrdItemId(79,3,22)
ClassMethod GetRelateOrdItemId(EpisodeID As %String, seqNo As %String, oeordiId As %String = "") As %String
{
	quit:EpisodeID="" ""
	quit:seqNo="" ""
	
	quit:'$d(^tmp("RelateOrd",EpisodeID,+$h)) ""
	
	set seqNo=+seqNo 

	set ret=""
	set ifFind=0
	set relateOriId=""
	for  set relateOriId=$o(^tmp("RelateOrd",EpisodeID,+$h,relateOriId)) quit:relateOriId=""  do
	.set seqNo2=^tmp("RelateOrd",EpisodeID,+$h,relateOriId)
	.quit:(seqNo2=seqNo)&(ifFind=1)
	.if seqNo2=seqNo set ret=relateOriId,ifFind=1
	
	quit:(oeordiId'="")&(oeordiId=ret) ""
	
	set flag=0
	if (oeordiId'="")&(ret'="") do
	.set arcimId=$p($g(^OEORD(+oeordiId,"I",$p(oeordiId,"||",2),1)),"^",2)
	.set targetArcimId=$p($g(^OEORD(+ret,"I",$p(ret,"||",2),1)),"^",2)
	.if arcimId=targetArcimId set flag=1
	quit:flag=1 ""

	quit ret
}

ClassMethod SaveRelateOrdItem(EpisodeID As %String, seqNo As %String, oeordiId As %String) As %String
{
	quit:EpisodeID=""
	quit:seqNo="" ""
	quit:oeordiId="" ""
	
	set seqNo=+seqNo
	
	set ^tmp("RelateOrd",EpisodeID,+$h,oeordiId)=seqNo
	
	q ""
}

/// w ##class(web.DHCICUImportData).SaveInOutRecord(para)
/// set para=HISKey_"^"_PatientNo_"^"_Name_"^"_Sex_"^"_DateOfBirth_"^"_Citizenship_"^"_Nation_"^"_
/// 		 IDNo_"^"_PhoneNumberHome_"^"_PhoneNumbeBusiness_"^"_MedicareNo_"^"_PaadmNo_"^"_DeptCode_"^"_
/// 		 WardCode_"^"_BedCode_"^"_AttendingDocCode_"^"_MrcidDesc_"^"_InUserCode_"^"_OutUserCode_"^"_
/// 		 AdmDateTime_"^"_DischDateTime_"^"_DischCondition_"^"_DeceaseDateTime_"^"_UpdateDateTime
/// 保存或插入病人入院和出院记录
ClassMethod SaveInOutRecord(para As %String, serialNo As %String = "") As %String
{
	set para=$tr(para,$c(0))
	
	quit:para="" "-1^para不能为空"
	
	set dateTime=$p(para,"^",24)
	//quit:$g(^tmpInOutRecord(dateTime))=para 0
	
	set ^tmpInOutRecord(dateTime)=para
	
	do ##class(web.DHCCLImportData).LogNew("InOut","1.开始出入院",serialNo,"开始SaveInOutRecord，para="_para,"Success")
	do ##class(web.DHCCLImportData).Log("Record","开始SaveInOutRecord，para="_para)
	
	set $zt="ERROR"
	set PatientNo=$p(para,"^",2)
	set Name=$p(para,"^",3)
	set Sex=$p(para,"^",4)
	set DateOfBirth=$p(para,"^",5)
	set Citizenship=$p(para,"^",6)
	set Nation=$p(para,"^",7)
	set IDNO=$p(para,"^",8)
	set PhoneNumberHome=$p(para,"^",9)
	set PhoneNumbeBusiness=$p(para,"^",10)
	set MedicareNo=$p(para,"^",11)
	set PaadmNo=$p(para,"^",12)
	set DeptCode=$p(para,"^",13)
	set WardCode=$p(para,"^",14)
	set BedCode=$p(para,"^",15)
	set AttendingDocCode=$p(para,"^",16)
	set MrcidDesc=$p(para,"^",17)
	set InUserCode=$p(para,"^",18)
	set OutUserCode=$p(para,"^",19)
	set AdmDateTime=$p(para,"^",20)
	set DischDateTime=$p(para,"^",21)
	set DischCondition=$p(para,"^",22)
	set DeceaseDateTime=$p(para,"^",23)
	set UpdateDateTime=$p(para,"^",24)
	
	//----------------病人基本信息----------------
	set DateOfBirth=##class(web.DHCICUImportData).GetDate(DateOfBirth)
	if Sex="" set Sex=0 //未知性别
	if Citizenship="" set Citizenship=1
	if (Nation="01")!(Nation="") set Nation=1
	set BloodType=5 //未知血型
	quit:AdmDateTime="" "就诊日期时间不能为空"
	
	quit:PatientNo="" "-1^PatientNo为空"
	
	set inUserId=""
	if InUserCode'="" set inUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(InUserCode),""))
	if inUserId="" do ##class(web.DHCCLImportData).Log("Error","SaveInOutRecord-办理入院手续操作人为空，InUserCode="_InUserCode)
	quit:inUserId="" "-2^inUserId为空"
	
	set deptId=""
	if DeptCode'="" set deptId=$o(^CTLOC(0,"Code",DeptCode,""))
	if deptId="" do ##class(web.DHCCLImportData).Log("Error","SaveInOutRecord-科室为空，DeptCode="_DeptCode)
	quit:deptId="" "-3^deptId为空"
	
	set wardId=""
	if WardCode'="" set wardId=$o(^PAWARD(0,"WARD_Code",WardCode,""))
	if wardId="" do ##class(web.DHCCLImportData).Log("Error","SaveInOutRecord-wardId为空，WardCode="_WardCode)
	quit:wardId="" "-3^病区Id为空"
	
	set attendingDocId=""
	if AttendingDocCode'="" set attendingDocId=$o(^CTPCP(0,"Code",AttendingDocCode,""))
	set receiveDocId=attendingDocId
	if receiveDocId="" do ##class(web.DHCCLImportData).Log("Error","SaveInOutRecord-receiveDocId为空，AttendingDocCode="_AttendingDocCode)
	quit:receiveDocId="" "-4^主治医生Id为空"
	
	set bedId=##class(web.DHCCLImportData).GetBedIdByWardIdAndBedCode(wardId,BedCode)  

	//--------------------------------------------
	set PAPMIDr=##class(web.DHCCLImportData).GetPAPMIDrByPatientID(PatientNo)
	do ##class(web.DHCCLImportData).Log("Record","SaveInOutRecord-开始保存病人信息！！"_"PAPMIDr="_PAPMIDr_",Name="_Name_",Sex="_Sex_",DateOfBirth="_DateOfBirth_",Citizenship="_Citizenship_",Nation="_Nation_",IDNO="_IDNO_",PhoneNumberHome="_PhoneNumberHome_",PhoneNumbeBusiness="_PhoneNumbeBusiness_",BloodType="_BloodType)
	if PAPMIDr="" do
	.set ret=##class(web.DHCCLImportData).SavePatInfo("",Name,Sex,DateOfBirth,Citizenship,Nation,IDNO,PhoneNumberHome,PhoneNumbeBusiness,BloodType,inUserId,MedicareNo)
	.if ret<0  do ##class(web.DHCCLImportData).Log("Error","SaveInOutRecord-新建病人信息报错，SQLCODE="_ret)
	.else  set PAPMIDr=ret
	.
	.if PAPMIDr'="" set ret2=##class(web.DHCCLImportData).SavePatMapped(PAPMIDr,PatientNo)
	if PAPMIDr="" do ##class(web.DHCCLImportData).Log("Error","SaveInOutRecord-保存病人信息失败,PatientNo="_PatientNo)
	quit:PAPMIDr="" "-5^保存病人信息失败"

	//----------------保存就诊信息-----------------------------
	set EpisodeID=##class(web.DHCCLImportData).GetAdmDrByMappedAdmNo(PaadmNo)
	do ##class(web.DHCCLImportData).Log("Record","SaveInOutRecord-开始插入就诊信息！！papmiDr="_PAPMIDr_",AdmDateTime="_AdmDateTime_",deptId="_deptId_",receiveDocId="_receiveDocId_",userId="_inUserId_",wardId="_wardId_",bedId="_bedId_",MrcidDesc="_MrcidDesc)
	if EpisodeID="" do
	.set ret=##class(web.DHCCLImportData).InsertAdmInfo(PAPMIDr, AdmDateTime, deptId, receiveDocId, inUserId, wardId, bedId, MrcidDesc)
	.if +$p(ret,"^",1)<0 do ##class(web.DHCCLImportData).Log("Error","SaveInOutRecord Error--"_ret)
	.else  set EpisodeID=ret
	.	
	.if EpisodeID'="" set ret2=##class(web.DHCCLImportData).SavePaAdmMapped(EpisodeID,PaadmNo)
	if EpisodeID="" do ##class(web.DHCCLImportData).Log("Error","SaveInOutRecord-保存就诊信息失败,PaadmNo="_PaadmNo)
	quit:EpisodeID="" "-6^保存就诊信息失败"

	//保存诊断
	set ret3=##class(web.DHCCLImportData).SaveMrcidDesc(EpisodeID,MrcidDesc)
	
	//出院时间为空表示入院，否则为出院
	if DischDateTime="" do
	.do ##class(web.DHCCLImportData).Log("Record","SaveInOutRecord-病人入院！EpisodeID="_EpisodeID_",inUserId="_inUserId_",wardId="_wardId_",bedId="_bedId_",deptId="_deptId)
	.set ret4=##class(web.DHCCLImportData).AdmissionToHospital(EpisodeID,inUserId,wardId,bedId,deptId)
	.do ##class(web.DHCCLImportData).Log("Record","入院结果,ret="_ret4)
	else  do
	.set outUserId=""
	.if OutUserCode'="" set outUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(OutUserCode),""))
	.if outUserId'="" do
	..do ##class(web.DHCCLImportData).Log("Record","SaveInOutRecord-病人出院！EpisodeID="_EpisodeID_",outUserId="_outUserId_",wardId="_wardId_",deptId="_deptId)
	..set ret4=##class(web.DHCCLImportData).DischargeFromHospital(EpisodeID,outUserId,wardId,deptId)
	..do ##class(web.DHCCLImportData).Log("Record","出院结果,ret="_ret4)
	
	quit 0
	
ERROR	;
	set ErrorMsg=$ZE
	if ErrorMsg'="" do ##class(web.DHCCLImportData).Log("Error","SaveInOutRecord Error--"_ErrorMsg_",dateTime="_$g(dateTime))
	q ErrorMsg
}

/// w ##class(web.DHCICUImportData).SaveLabInfo(para)
/// 保存检验信息
ClassMethod SaveLabInfo(para As %String, serialNo As %String = "") As %String
{
	set para=$tr(para,$c(0))
	
	quit:para="" "-1^para不能为空"
	
	set $zt="ERROR"
	do ##class(web.DHCCLImportData).Log("Record","开始SaveLabInfo，para="_para)
	
	set splitChar=##class(web.DHCCLImportData).GetSplitChar()
	set len=$l(para,splitChar)
	
	set i=0
	set HISKey=$p(para,splitChar, i+1)
	set PaadmNo=$p(para,splitChar, i+2)
	set TestCode=$p(para,splitChar, i+3)
	set TestCodeDesc=$p(para,splitChar, i+4)
	set LabNo=$p(para,splitChar, i+5)
	set OeoriCode=$p(para,splitChar, i+6)
	set SpecimenCode=$p(para,splitChar, i+7)
	set CollectDateTime=$p(para,splitChar, i+8)
	set ReceivedDateTime=$p(para,splitChar, i+9)
	set ResultDateTime=$p(para,splitChar, i+10)
	set TestResult=$p(para,splitChar, i+11)
	set TestResultUnitCode=$p(para,splitChar, i+12)
	//考虑到检验结果单位里面有"^"
	if (len=17)&(splitChar="^") do
	.set TestResultUnitCode=$p(para,splitChar, i+12)_"^"_$p(para,splitChar, i+13)
	.set i=i+1
	set TestResultRange=$p(para,splitChar, i+13)
	set TestConclusion=$p(para,splitChar, i+14)
	set LabLocCode=$p(para,splitChar, i+15)
	set UpdateDateTime=$p(para,splitChar, i+16)
	
	quit:$g(^tmpLabInfo(HISKey))=para 0
	set ^tmpLabInfo(HISKey)=para
	
	set RowId=##class(web.DHCCLImportData).GetLabRowIdByLabNo(LabNo)
	set LabResultNo=LabNo
	set PaadmDr=##class(web.DHCCLImportData).GetAdmDrByMappedAdmNo(PaadmNo)
	quit:PaadmDr="" "-1^就诊号不对，PaadmNo="_PaadmNo
	set OeoriNo=OeoriCode
	
	set SpecimenDr=##class(web.DHCCLImportData).GetSpecimenRowIdByCode(SpecimenCode)
	if SpecimenDr="" do
	.set ret1=##class(web.DHCCLImportData).SaveLabSpecimen(SpecimenCode,SpecimenCode)
	.set SpecimenDr=##class(web.DHCCLImportData).GetSpecimenRowIdByCode(SpecimenCode)
	quit:SpecimenDr="" "-2^检验标本类型不对，SpecimenCode="_SpecimenCode
	
	set TestCodeDr=##class(web.DHCCLImportData).GetLabTestRowIdByCode(TestCode)
	if TestCodeDr="" do
	.set ret2=##class(web.DHCCLImportData).SaveLabTestCode(TestCode,TestCodeDesc,TestCode,TestCode)
	.set TestCodeDr=##class(web.DHCCLImportData).GetLabTestRowIdByCode(TestCode)
	quit:TestCodeDr="" "-3^检验项目代码不对, TestCode="_TestCode	
	
	set CollectDate=##class(web.DHCICUImportData).GetDate(CollectDateTime)
	set CollectDate=$zdh(CollectDate,3)
	set CollectTime=##class(web.DHCICUImportData).GetTime(CollectDateTime)
	set CollectTime=$zth(CollectTime)
	
	set ReceivedDate=##class(web.DHCICUImportData).GetDate(ReceivedDateTime)
	set ReceivedDate=$zdh(ReceivedDate,3)
	set ReceivedTime=##class(web.DHCICUImportData).GetTime(ReceivedDateTime)
	set ReceivedTime=$zth(ReceivedTime)
	
	set ResultDate=##class(web.DHCICUImportData).GetDate(ResultDateTime)
	set ResultDate=$zdh(ResultDate,3)
	set ResultTime=##class(web.DHCICUImportData).GetTime(ResultDateTime)
	set ResultTime=$zth(ResultTime)
	
	set MicroorganismType=""
	
	set ret=##class(web.DHCCLImportData).SaveLabInfo(RowId, LabResultNo, PaadmDr, OeoriNo, LabNo, SpecimenDr, TestCodeDr, TestCodeDesc, CollectDate, CollectTime, ReceivedDate, ReceivedTime, ResultDate, ResultTime, TestResult, TestResultUnitCode, TestResultRange, TestConclusion, MicroorganismType, LabLocCode)
	if (+ret>0) do ##class(web.DHCCLImportData).Log("Record","插入检验数据成功 ,RowId="_ret)
	else  do ##class(web.DHCCLImportData).Log("Error","插入检验数据失败 ,ret="_ret)
	
	quit 0
	
ERROR	;
	set ErrorMsg=$ZE
	if ErrorMsg'="" do ##class(web.DHCCLImportData).Log("Error","SaveLabInfo Error--"_ErrorMsg_",HISKey="_$g(HISKey))
	q ErrorMsg
}

/// w ##class(web.DHCICUImportData).SaveClinicData("className","inputFlag","propertyPara","valuePara")
ClassMethod SaveClinicData(className As %String, inputFlag As %String, propertyPara As %String, valuePara As %String) As %String [ WebMethod ]
{
	quit:inputFlag="" "inputFlag为空"
	
	set $zt="ERROR"
	set tmpNum=$o(^TMPDHCENS("ClinicData",""),-1)
	set serialNo=+tmpNum+1
	set ^TMPDHCENS("ClinicData",serialNo)=valuePara
	
	set HISKey=$p(valuePara,"^",1)
	if HISKey'="" set ^tmpData(inputFlag,HISKey)=valuePara
	
	set ret=0
	if inputFlag="Loc" do
	.set ret=##class(web.DHCICUImportData).ImportCtlocData(valuePara, serialNo)
	
	if inputFlag="CareProv" do
	.set ret=##class(web.DHCICUImportData).ImportCtcpData(valuePara, serialNo)
	
	if inputFlag="Arcim" do
	.set ret=##class(web.DHCICUImportData).ImportArcimData(valuePara, serialNo)
	
	if inputFlag="Trans" do
	.set ret=##class(web.DHCICUImportData).SaveTransAdmInfo(valuePara, serialNo)
	
	if inputFlag="InOut" do
	.set ret=##class(web.DHCICUImportData).SaveInOutRecord(valuePara, serialNo)
	
	if inputFlag="Oeori" do
	.set ret=##class(web.DHCICUImportData).InsertOeordItem(valuePara, serialNo)
	
	if inputFlag="Lab" do
	.set ret=##class(web.DHCICUImportData).SaveLabInfo(valuePara, serialNo)
	
	set ^TMPDHCENS("ClinicData",serialNo,"ret")=ret
	quit ret
	
ERROR	
	set ErrorMsg=$ZE
	if ErrorMsg'="" do ##class(web.DHCCLImportData).Log("Error","SaveClinicData Error--"_ErrorMsg_",HISKey="_$g(HISKey))
	quit ErrorMsg
}

}
