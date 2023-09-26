Import SQLUser

/// 名称: web.DHCIPBillCheckAdmCost.cls
/// 描述: 住院费用核查类
/// 编写者：ZhYW
/// 编写日期: 2017-07-21
Class web.DHCIPBillCheckAdmCost Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 查询已做医疗结算，未作最终结算的在院病人
/// Input: adm:PA_Adm.RowId, deptId:CT_Loc.RowId, wardId:PAC_Ward.RowId
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillCheckAdmCost","FindCurInPatient", "", "", "", "", "Y")
Query FindCurInPatient(episodeIDStr As %String, deptId As %String, wardId As %String, insTypeId As %String, oneKeyCheckFlag As %String, roleLevel As %String, sessionStr As %String) As websys.Query(ROWSPEC = "id:%String,patName:%String,patNo:%String")
{
}

ClassMethod FindCurInPatientExecute(ByRef qHandle As %Binary, episodeIDStr As %String, deptId As %String, wardId As %String, insTypeId As %String, oneKeyCheckFlag As %String, roleLevel As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set ^TMP("FindCurInPatient")=$lb(episodeIDStr, deptId, wardId, insTypeId, oneKeyCheckFlag, roleLevel, sessionStr)

	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	if (episodeIDStr'="") {
		set count=$l(episodeIDStr,"^")
		for i=1:1:count {
			set adm=$p(episodeIDStr,"^",i)
			continue:(+adm=0)
			set admData=$g(^PAADM(adm))
			continue:(admData="")
			set visitStatus=$p(admData,"^",20)
			continue:(visitStatus="C")
			set medDiscDate=$p(admData,"^",59)
			//continue:(medDiscDate="")              //未做医疗结算的过滤
			set papmi=$p(admData,"^",1)
			set patNo=$p(^PAPER(papmi,"PAT",1),"^",1)
			set patName=$p(^PAPER(papmi,"ALL"),"^",1)
			set sexDR=$p(^PAPER(papmi,"ALL"),"^",7)
			set sex=$s((+sexDR'=0):$p($g(^CT("SEX",sexDR)),"^",2),1:"")
			do OutputCurInPatient
		}
		quit $$$OK
	}
	
	set adm=0
	while($o(^PAADMi("AdmTypeCurr","I",adm))) {
		set adm=$o(^PAADMi("AdmTypeCurr","I",adm))
		set admData=$g(^PAADM(adm))
		continue:(admData="")
		set visitStatus=$p(admData,"^",20)
		continue:(visitStatus="C")             //退院
		set medDiscDate=$p(admData,"^",59)
		continue:(medDiscDate="")              //未做医疗结算的过滤
		set admReasonDR=$p(^PAADM(adm,1),"^",7)
		continue:((+insTypeId'=0)&&(+insTypeId'=admReasonDR))
		set admLocDR=$p(admData,"^",4)
		continue:((deptId'="")&&(deptId'=admLocDR))
		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admLocDR)
		continue:(admHospDR'=hospId)
		set wardDR=$p(admData,"^",70)
		continue:((+wardId'=0)&&(+wardId'=wardDR))
		set papmi=$p(admData,"^",1)
		set patNo=$p(^PAPER(papmi,"PAT",1),"^",1)
		set patName=$p(^PAPER(papmi,"ALL"),"^",1)
		if (oneKeyCheckFlag="Y") {
			do ..GetIPBillCheckFeeData(adm, $j)
			set num=..CheckExistErrData(adm, $j, roleLevel)
			continue:(+num=0)
		}
		set sexDR=$p(^PAPER(papmi,"ALL"),"^",7)
		set sex=$s((+sexDR'=0):$p($g(^CT("SEX",sexDR)),"^",2),1:"")
		do OutputCurInPatient
	}
	
	quit $$$OK
OutputCurInPatient
	set Data=$lb(adm,patName,patNo)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 住院费用核查
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetIPBillCheckFeeData("15","4172")
ClassMethod GetIPBillCheckFeeData(adm As %String, pid As %String) As %String
{
	set ^TMP("GetIPBillCheckFeeData")=$lb(adm, pid)
	set rtn=0
	quit:((+adm=0)||(+pid=0)) rtn
	
	do ..KillTMP(pid, adm)
	
	set ord=$o(^OEORD(0,"Adm",adm,0))
	quit:(+ord=0) rtn
	
	do ##class(web.UDHCJFBILL).BILLN(adm, 1)
	
	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)

	do ..GetMonitorPointCfg(adm, pid, admHospDR)
	set MPCCode="09"
	set itm=0
	while($o(^OEORD(ord,"I",itm))) {
		set itm=$o(^OEORD(ord,"I",itm))
		continue:('$d(^OEORD(ord,"I",itm,1)))
		set oeori=ord_"||"_itm
		set nullDataFlag=..GetNullDataFlag(adm, pid, oeori, MPCCode, admHospDR)
		continue:(+nullDataFlag)     //有空数据时不再往下执行
		do ..GetOEOREInfo(adm, pid, oeori, admHospDR)
	}
	
    //婴儿和母亲一个账单的核查
    set conf=##class(web.DHCBillCommon).GetTarParaId(admHospDR)
    set babyToMother=$s((+conf'=0):$p($g(^DHCTarC("CF",conf)),"^",5),1:"")
    if (babyToMother="Y") {
	 	set babyAdm=0
	 	while($o(^PAADMi("Mother",adm,babyAdm))) {
		 	set babyAdm=$o(^PAADMi("Mother",adm,babyAdm))
		 	do ..KillTMP(pid, babyAdm)
			do ..GetMonitorPointCfg(babyAdm, pid, admHospDR)
			set ord=$o(^OEORD(0,"Adm",babyAdm,0))
			continue:(+ord=0)
			set itm=0
			while($o(^OEORD(ord,"I",itm))) {
				set itm=$o(^OEORD(ord,"I",itm))
				continue:('$d(^OEORD(ord,"I",itm,1)))
				set oeori=ord_"||"_itm
				set nullDataFlag=..GetNullDataFlag(babyAdm, pid, oeori, MPCCode, admHospDR)
				continue:(+nullDataFlag)	   //有空数据时不再往下执行
				do ..GetOEOREInfo(babyAdm, pid, oeori, admHospDR)
			}
		}
    }
    
    quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 获取进程号
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetPID(33)
ClassMethod GetPID() As %String
{
	quit $i(^TMP("IPBILL","Check"))
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: kill临时global
/// Input: pid:进程号, adm:PA_Adm.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).KillTMP(33)
ClassMethod KillTMP(pid As %String, adm As %String = "") As %String
{
	quit:(+pid=0) 0
	if (adm>0) {
		kill ^TMP("IPBILL","Check",pid,adm)
		quit 0
	}
	kill ^TMP("IPBILL","Check",pid)
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 根据监控点代码取RowID
/// Input: MPCCode:DHC_BillMonitorPointConfig.MPC_Code, hospId:CT_Hospital.RowId
/// Return: MPCRowID:DHC_BillMonitorPointConfig.MPC_RowID
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetMPCRowIDByCode("01", 2)
ClassMethod GetMPCRowIDByCode(code As %String, hospId As %String) As %String
{
	set rowId=""
	quit:(code="") rowId
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_IP_MonitorPoint", hospId)	
	set code=$$ALPHAUP^SSUTIL4(code)
	set myId=0
	while ($o(^DHCMPConfigi(0,"CODE",code,myId))) {
		set myId=$o(^DHCMPConfigi(0,"CODE",code,myId))
		set data=$g(^DHCMPConfig(myId))
		set hospDR=$p(data,"^",6)
		continue:(hospDR'=defHospId)
		set rowId=myId
		quit
	}
	
	quit rowId
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 取监控点配置
/// Input: adm:PA_Adm.RowID, pid:进程号
/// Return: 
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetMonitorPointCfg()
ClassMethod GetMonitorPointCfg(adm As %String, pid As %String, hospId As %String) As %String
{
	set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(adm)
 	set admDate=$p(admInOutDateInfo,"^",1)
	if (admDate="") set admDate=$p(^PAADM(adm),"^",6)
	set disChgDate=$p(admInOutDateInfo,"^",4)
	if (disChgDate="") set disChgDate=+$h
	
	set isChkBedFees=..IsChkAdmBedFees(adm)  //+2023-04-23 ZhYW 是否核查床位费、级别护理费、诊查费、空调(取暖)费
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_IP_MonitorPoint", hospId)
	set MPCRowID=0
	while($o(^DHCMPConfig(MPCRowID))) {
		set MPCRowID=$o(^DHCMPConfig(MPCRowID))
		set MPCData=$g(^DHCMPConfig(MPCRowID))
		continue:(MPCData="")
		set hospDR=$p(MPCData,"^",6)
		continue:(hospDR'=defHospId)
		set isActive=$p(MPCData,"^",4)
		continue:(isActive'="Y")          //过滤停用的
		set MPCCode=$p(MPCData,"^",1)
		continue:(" 01 02 03 04 06 "'[(" "_MPCCode_" "))
		continue:((" 01 02 03 04 "[(" "_MPCCode_" ")) && ('isChkBedFees))  //+2023-02-27 ZhYW 不核查床位费、级别护理费、诊查费、空调(取暖)费
		
		set jsonStr=##class(web.DHCIPBillCostMonitorConfig).GetCheckDataByConfId(MPCRowID)
		set jsonObj=##class(%DynamicObject).%FromJSON(jsonStr)
		set endDate=disChgDate-(jsonObj.CDDaysMode=1)   //配置为算入不算出时endDate=disChgDate-1
		if (+endDate<+admDate) set endDate=admDate
		
		if (" 01 02 03 "[(" "_MPCCode_" ")) {     //床位/级别护理/诊查
			for date=admDate:1:endDate {
				set ^TMP("IPBILL","Check",pid,adm,MPCRowID,"YSNUM",date)=1   //每天应收数量为1
			}
			continue
		}
		if (MPCCode="04") {             //空调费(调用医生站接口)
			set KTDocConfig=jsonObj.CDAirMode
			if (KTDocConfig=1) {    //配置为走医生站配置时
				set docCofigRtn=..GetAirDocCfg(adm, hospId)
				set KTStDate=$p(docCofigRtn,"#",1)
				set KTEndDate=$p(docCofigRtn,"#",2)
			}else {
				set KTStDate=jsonObj.CDAirStDate
				set KTEndDate=jsonObj.CDAirEndDate
				set KTStDate=##class(websys.Conversions).DateHtmlToLogical(KTStDate)
				set KTEndDate=##class(websys.Conversions).DateHtmlToLogical(KTEndDate)
			}
			//调用医生站接口取空调费起止日期
		 	for date=KTStDate:1:KTEndDate {
		  		continue:((date>disChgDate)||(date<admDate))
				set ^TMP("IPBILL","Check",pid,adm,MPCRowID,"YSNUM",date)=1    //每天应收数量为1
		 	}
		 	continue
		}
		if (MPCCode="06") {
			do ..GetOperOrdStatInfo(adm, pid, MPCRowID)
			continue
		}
	}
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 判断已做手术安排但是没有手术室计费
/// Input: adm:PA_Adm.RowID, pid:进程号, MPCRowID:DHC_BillMonitorPointConfig.RowID
/// Return: 
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetOperOrdStatInfo()
ClassMethod GetOperOrdStatInfo(adm As %String, pid As %String, MPCRowID As %String) As %String
{
	quit:((+adm=0)||(+MPCRowID=0)) 0
	set operOrdStatInfo=##class(web.DHCANAdaptor).GetOperOrdStatByAdmId(adm)
	set togetherFlag=$p(operOrdStatInfo,"@",1)
	set operOrdStatStr=$p(operOrdStatInfo,"@",2)
	if (" Y N " '[ (" "_togetherFlag_" ")) {
		quit 0
	}
	
	if (togetherFlag="Y") {
		set myOperLocBilled=$p(operOrdStatStr,"^",1)
		set myOperOrdItm=$p(operOrdStatStr,"^",2)
		set myOperDept=$p(operOrdStatStr,"^",3)
		set myOperOrdStat=$p(operOrdStatStr,"^",4)
		if ((myOperLocBilled=0)&&(" A D "'[(" "_myOperOrdStat_" "))) {    //"A":申请, "D":拒绝
			set ^TMP("IPBILL","Check",pid,adm,MPCRowID,myOperOrdItm)=myOperDept
		}
		quit 0
	}
	
	set count=$l(operOrdStatStr,"~")
	for i=1:1:count {
		set myOperOrdStatStr=$p(operOrdStatStr,"~",i)
		continue:(myOperOrdStatStr="")
		set myOperLocBilled=$p(myOperOrdStatStr,"^",1)
		set myAnesLocBilled=$p(myOperOrdStatStr,"^",2)
		set myOperOrdItm=$p(myOperOrdStatStr,"^",4)
		set myOperDept=$p(myOperOrdStatStr,"^",5)
		set myOperOrdStat=$p(myOperOrdStatStr,"^",6)
		if (((+myOperLocBilled=0)||(+myAnesLocBilled=0))&&(" A D "'[(" "_myOperOrdStat_" "))) {
			set ^TMP("IPBILL","Check",pid,adm,MPCRowID,myOperOrdItm)=myOperDept
		}
	}
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 判断医嘱项, 医嘱子分类, 医嘱大类, 医嘱状态是否有空数据
/// Input: oeori:OE_OrdItem.OEORI_RowId, pid:进程号, MPCCode:DHC_BillMonitorPointConfig.MPC_Code
/// Return: nullDataFlag: 0:没有空数据, 1:有空数据
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetNullDataFlag()
ClassMethod GetNullDataFlag(adm As %String, pid As %String, oeori As %String, MPCCode As %String, hospId As %String) As %String
{
	set ord=$p(oeori,"||",1)
	set itm=$p(oeori,"||",2)
	set arcimDR=$p(^OEORD(ord,"I",itm,1),"^",2)
	
	set nullDataFlag=0
	set MPCRowID=..GetMPCRowIDByCode(MPCCode, hospId)
	quit:(+MPCRowID=0) nullDataFlag
	
	if (arcimDR="") {
		set nullDataFlag=1
		set ^TMP("IPBILL","Check",pid,adm,MPCRowID,oeori)=""
	}else {
		set itemCatDR=$p($g(^ARCIM($p(arcimDR,"||",1),$p(arcimDR,"||",2),1)),"^",10)    //医嘱子分类
		if (itemCatDR="") {
			set nullDataFlag=1
			set ^TMP("IPBILL","Check",pid,adm,MPCRowID,oeori)=""
		}else {
			set oecCatDR=$p(^ARC("IC",itemCatDR),"^",8)  //医嘱大类
			if (oecCatDR=""){
				set nullDataFlag=1
				set ^TMP("IPBILL","Check",pid,adm,MPCRowID,oeori)=""
			}
		}
	}
	
	set ordStatDR=$p(^OEORD(ord,"I",itm,1),"^",13)
	if (ordStatDR=""){
		set nullDataFlag=1
		set ^TMP("IPBILL","Check",pid,adm,MPCRowID,oeori)=""
	}
	
	quit nullDataFlag
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 滚执行记录模式下取数据
/// Input: MPCCode:DHC_BillMonitorPointConfig.MPC_Code
/// Return: 
/// Debug: 
ClassMethod GetOEOREInfo(adm As %String, pid As %String, oeori As %String, hospId As %String) As %String
{
	set ord=$p(oeori,"||",1)
	set itm=$p(oeori,"||",2)
	set ordPriorDR=$p(^OEORD(ord,"I",itm,1),"^",8)
	set ordPriorCode=$s((+ordPriorDR'=0):$p($g(^OECPR(+ordPriorDR)),"^",1),1:"")
	quit:(ordPriorCode["OM")   //自备药医嘱退出
	
	set arcimDR=$p(^OEORD(ord,"I",itm,1),"^",2)
	set itemCatDR=$p($g(^ARCIM($p(arcimDR,"||",1),$p(arcimDR,"||",2),1)),"^",10)    //医嘱子分类
	set ordCateType=$p(^ARC("IC",itemCatDR),"^",7)        //医嘱类型
	set oecCatDR=$p(^ARC("IC",itemCatDR),"^",8)           //医嘱大类
    
    set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_IP_MonitorPoint", hospId)
    
    set CP=##class(BILL.IP.COM.Method).GetBillPoint(oeori)     //取计费点
	
	//2021-05-25 ZhYW
	set insTypeDR=$p(^PAADM(adm,1),"^",7)
	set nationalCode=$p(^PAC("ADMREA",insTypeDR),"^",5)
	set mainInsMPCID=""
	set ordMainIns=-1   //是否验证医保患者医嘱医保属性为空
	if (nationalCode>0) {
		set rtnValue=##class(web.DHCINSUPort).GetOEMainInsCfg(insTypeDR, hospId)
		set ordMainIns=+rtnValue
	}
	
	set exec=0
	while($o(^OEORD(ord,"I",itm,"X",exec))) {
		set exec=$o(^OEORD(ord,"I",itm,"X",exec))
		set execData=$g(^OEORD(ord,"I",itm,"X",exec))
		set execStDate=$p(execData,"^",1)
		set oeore=ord_"||"_itm_"||"_exec
		set oeoreStatDR=$p(^OEORD(ord,"I",itm,"X",exec,"BILL"),"^",1)    // OE_OrdExecExt.OEORE_OrderStatus_DR
		set oeoreStatCode=$s((+oeoreStatDR'=0):$p($g(^OEC("OSTAT",oeoreStatDR)),"^",1),1:"")
		//取实际计费数量
		set pboBillInfo=..GetOrderBillInfo(oeore)
		set pboUnitPrice=$p(pboBillInfo,"^",1)
		set pboTotalQty=$p(pboBillInfo,"^",2)
		set pboTotalAmount=$p(pboBillInfo,"^",3)
		//取实际发药数量
		set dspTotalQty=..GetDspQty(oeore)
		//判断账单医嘱表中单价是否为0
		set zeroPriceFlag=..CheckOrderBillPrice(oeore)
		set MPCRowID=0
		while($o(^DHCMPConfig(MPCRowID))) {
			set MPCRowID=$o(^DHCMPConfig(MPCRowID))
			set MPCData=$g(^DHCMPConfig(MPCRowID))
			continue:(MPCData="")
			set hospDR=$p(MPCData,"^",6)
			continue:(defHospId'=hospDR)
			set MPCCode=$p(MPCData,"^",1)
			if (MPCCode="11") {          //医嘱账单价格为0, (此规则不判断启用状态，强制启用)
				if (zeroPriceFlag=1) {
					set ^TMP("IPBILL","Check",pid,adm,MPCRowID,oeore)=""
				}
			}
			set isActive=$p(MPCData,"^",4) 
			continue:(isActive'="Y")           //过滤停用的
			set cate=""
			set MPCSub=""
			if ($d(^DHCMPConfigi(0,"ARCType",MPCRowID,"OECCAT",oecCatDR))=10) {
				set cate="OECCAT"_$c(2)_oecCatDR
				set MPCSub=$o(^DHCMPConfigi(0,"ARCType",MPCRowID,"OECCAT",oecCatDR,0))
			}
			if ($d(^DHCMPConfigi(0,"ARCType",MPCRowID,"ARCIC",itemCatDR))=10) {
				set cate="ARCIC"_$c(2)_itemCatDR
				set MPCSub=$o(^DHCMPConfigi(0,"ARCType",MPCRowID,"ARCIC",itemCatDR,0))
			}
			if ($d(^DHCMPConfigi(0,"ARCType",MPCRowID,"ARCIM",arcimDR))=10) {
				set cate="ARCIM"_$c(2)_arcimDR
				set MPCSub=$o(^DHCMPConfigi(0,"ARCType",MPCRowID,"ARCIM",arcimDR,0))
			}
			if ((cate'="")&&(+pboTotalQty'=0)) {
				if (" 01 02 03 04 "[(" "_MPCCode_" ")) {      //床位/护理级别/诊查/空调
					set ^TMP("IPBILL","Check",pid,adm,MPCRowID,"SSNUM",execStDate)=$g(^TMP("IPBILL","Check",pid,adm,MPCRowID,"SSNUM",execStDate))+pboTotalQty
					set ^TMP("IPBILL","Check",pid,adm,MPCRowID,"SSNUM",execStDate,"CATE")=cate
				}elseif ((MPCCode="12")&&(MPCSub'="")) {
					set maxQty=$p($g(^DHCMPConfig(MPCRowID,"D",MPCSub)),"^",7)
					set ^TMP("IPBILL","Check",pid,adm,MPCRowID,"SSNUM",execStDate,cate)=$g(^TMP("IPBILL","Check",pid,adm,MPCRowID,"SSNUM",execStDate,cate))+pboTotalQty
					set ^TMP("IPBILL","Check",pid,adm,MPCRowID,"YSNUM",execStDate,cate)=maxQty
				}
			}
			if (MPCCode="05") {         //实际发药数量与收费数量是否相符
				if ((CP="CR")&&(ordCateType="R")) {
					if (+pboTotalQty'=+dspTotalQty) {
						set ^TMP("IPBILL","Check",pid,adm,MPCRowID,oeore)=""
					}
				}
			}
			if (MPCCode="07") {          //需计费医嘱未停止未计费
				if (" V E "[(" "_oeoreStatCode_" ")) {
					if ((CP="CR")&&(ordCateType="R")) {
						set dspTCQty=..GetTCDspQty(oeore)   //取未发的药品的数量
						if (+dspTCQty'=0) {
							set ^TMP("IPBILL","Check",pid,adm,MPCRowID,oeore)=""
						}
					}
					if (+pboTotalQty=0) {
						set ^TMP("IPBILL","Check",pid,adm,MPCRowID,oeore)=""
					}
				}
			}
			if ((MPCCode="10")&&(+pboTotalAmount<0)) {   //医嘱账单数量小于0的医嘱(判断负数金额)
				if ('##class(web.UDHCJFIntBill).JudgeArcIsorNot(arcimDR, hospId)) {   //过滤自定义价格医嘱
					set ^TMP("IPBILL","Check",pid,adm,MPCRowID,oeore)=""
				}
			}
			if (MPCCode="13") {
				set mainInsMPCID=MPCRowID
				set oeoreCoverMainIns=$p(execData,"^",49)     //OE_OrdExec.OEORE_CoverMainIns
				if ((ordMainIns=0)&&(oeoreCoverMainIns="")) {
					set ^TMP("IPBILL","Check",pid,adm,MPCRowID,oeore)=""
				}
			}
		}
	}
	
	//医嘱没有执行记录
	set MPCCode="08"
	set MPCRowID=..GetMPCRowIDByCode(MPCCode, hospId)
	quit:(+MPCRowID=0)
	kill missExecAry
	set missFlag=##class(web.DHCDocMain).CheckExecValidity(oeori, .missExecAry)
	if (missFlag=1) {
		set ^TMP("IPBILL","Check",pid,adm,MPCRowID,oeori)=""
	}
	
	if ((ordMainIns=1)&&(+mainInsMPCID'=0)) {
		set ordCoverMainIns=$p($g(^OEORD(ord,"I",itm,3)),"^",3)   //OE_OrdItem.OEORI_CoverMainIns
		if (ordCoverMainIns="") {
			set ^TMP("IPBILL","Check",pid,adm,mainInsMPCID,oeori)=""
		}
	}
				
	quit
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 取医嘱账单单价、数量、金额
/// Input: OEExecRowID:OE_OrdExec.OEORE_RowId
/// Return: pboUnitPrice: 单价, totalQty: 计费数量, pboTotalAmount: 账单金额
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetOrderBillInfo("1641||1||1")
ClassMethod GetOrderBillInfo(oeore As %String) As %String
{
	set (unitPrice, qty, totalAmt)=0
	set ord=+oeore, itm=$p(oeore,"||",2), exec=$p(oeore,"||",3)
	set pboRowId=$p($g(^OEORD(ord,"I",itm,"X",exec,"BILL")),"^",2)
	if (pboRowId'="") {
		set pboData=$g(^DHCPB(+pboRowId,"O",$p(pboRowId,"||",2)))
		if (pboData'="") {
			set billQty=$p(pboData,"^",5)
			set refQty=$p(pboData,"^",6)
			set unitPrice=$p(pboData,"^",7)
			set totalAmt=$p(pboData,"^",8)
			set qty=$i(billQty, refQty)
		}
	}
	
	quit unitPrice_"^"_qty_"^"_totalAmt
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 取实际发药数量
/// Input: oeore:OE_OrdExec.OEORE_RowId
/// Return: dspTotalQty: 实际发药数量
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetDspQty("1641||3||1")
ClassMethod GetDspQty(oeore As %String) As %String
{
	set dspTotalQty=0
	quit:(oeore="") dspTotalQty
	set dsp=0
	while($o(^DHCOEDISQTY(0,"OEORE",oeore,dsp))) {
		set dsp=$o(^DHCOEDISQTY(0,"OEORE",oeore,dsp))
		set dspData=$g(^DHCOEDISQTY(dsp))
		set dspStatus=$p(dspData,"^",7)
		continue:(dspStatus="TC")
		set dspQty=$p(dspData,"^",11)
		if (dspStatus="C") {
			set dspTotalQty=$i(dspTotalQty, dspQty)
		}else {
			set dspTotalQty=$i(dspTotalQty, -dspQty)
		}
	}
	
	quit dspTotalQty
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 取待发药数量
/// Input: oeore:OE_OrdExec.OEORE_RowId
/// Return: retQty
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetTCDspQty()
ClassMethod GetTCDspQty(oeore As %String) As %String
{
	set retQty=0
	quit:(oeore="") retQty
	set ord=$p(oeore,"||",1)
	set itm=$p(oeore,"||",2)
	set exec=$p(oeore,"||",3)
	quit:((ord="")||(itm="")||(exec="")) retQty
	
	//判断医嘱优先级(是否自备药)	
	set prioDR=$p(^OEORD(ord,"I",itm,1),"^",8)
	quit:(prioDR="") retQty
	set priority=$p(^OECPR(prioDR),"^",1)
	quit:(priority="") retQty  
	quit:($zcvt(priority,"U")["OM") retQty
	//判断医嘱状态(医嘱核实、未核实、停止状态)
	set oeoreStatusDR=$p(^OEORD(ord,"I",itm,"X",exec,"BILL"),"^",1) 
	quit:(+oeoreStatusDR=0) retQty
	set oeoreStatCode=$p($g(^OEC("OSTAT",oeoreStatusDR)),"^",1)
	quit:(" V E "'[(" "_oeoreStatCode_" ")) retQty
 	
 	set arcimDR=$p(^OEORD(ord,"I",itm,1),"^",2)
 	quit:(arcimDR="") retQty
 	set inci=$o(^INCI(0,"ARCIM_DR",+arcimDR,""))
 	quit:(inci="") retQty
 	set UomDR=$p(^INCI(inci,1),"^",10)
 	quit:(UomDR="") retQty
 	
 	set dsp=0
 	while($o(^DHCOEDISQTY(0,"OEORE",oeore,dsp))) {
	 	set dsp=$o(^DHCOEDISQTY(0,"OEORE",oeore,dsp))
	 	set dspData=$g(^DHCOEDISQTY(dsp))
	 	set dspStatus=$p(dspData,"^",7)
		continue:(dspStatus'="TC")        //状态不是"TC"的退出
		set dspQty=$p(dspData,"^",11)
		set retQty=retQty+dspQty
	}

	quit retQty
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 判断账单医嘱表中单价是否为0(根据其关联的收费项价格判断)
/// Input: oeore:OE_OrdExec.OEORE_RowId
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).CheckOrderBillPrice("1641||1||1")
ClassMethod CheckOrderBillPrice(oeore As %String) As %String
{
	set rtn=0
	set ord=+oeore, itm=$p(oeore,"||",2), exec=$p(oeore,"||",3)
	set pboRowId=$p($g(^OEORD(ord,"I",itm,"X",exec,"BILL")),"^",2)
	quit:(pboRowId="") rtn
	
	set pb=+pboRowId
	set pbo=$p(pboRowId,"||",2)
	set pboData=$g(^DHCPB(pb,"O",pbo))
	quit:(pboData="") rtn
	set billQty=$p(pboData,"^",5)
	set refQty=$p(pboData,"^",6)
	set qty=billQty+refQty
	quit:(qty=0) rtn
	
	set arcim=$p(pboData,"^",3)
	set price=$p(pboData,"^",7)
	
	set adm=$p($g(^DHCPB(pb)),"^",1)
	if ($d(%AdmHosp(adm))) {
		set hospDR=$g(%AdmHosp(adm))
	}else {
		set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		set %AdmHosp(adm)=hospDR
	}

	if (+price=0)&&(##class(BILL.DC.BL.UnAuditItmCtl).CheckUnAuditItm(hospDR, "", "ArcItm", arcim)'="Y") {
		quit 1
	}
	
	set pbd=0
	while($o(^DHCPB(pb,"O",pbo,"D",pbd))) {
		set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd))
		set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
		set tariDR=$p(pbdData,"^",3)
		set price=$p(pbdData,"^",4)   //PBD_UnitPrice
		continue:(+price'=0)
		if (##class(BILL.DC.BL.UnAuditItmCtl).CheckUnAuditItm(hospDR, "", "TarItem", tariDR)'="Y") {
			set rtn=1
			quit
		}
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 住院病人错误数据查询
/// Input: adm:PA_Adm.RowID, pid:进程号, isAudit:审核标志(住院费用核查界面传空或不传)
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillCheckAdmCost", "FindCheckFee", "35","233","")
Query FindCheckFee(adm As %String, pid As %String, isAudit As %String, roleLevel As %String, langId As %String = "") As websys.Query(ROWSPEC = "TAdm:%String:就诊ID,TMPCRowID:%String:监控点ID,TMPCCode:%String:监控点编码,TMPCDesc:%String:监控点描述,TErrMsg:%String:核查结果")
{
}

ClassMethod FindCheckFeeExecute(ByRef qHandle As %Binary, adm As %String, pid As %String, isAudit As %String, roleLevel As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("FindCheckFee")=$lb(adm, pid, isAudit, roleLevel)
	if ((+adm=0)||(+pid=0)) quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	set conf=##class(web.DHCBillCommon).GetTarParaId(admHospDR)
	set babyToMother=$s((+conf'=0):$p($g(^DHCTarC("CF",conf)),"^",5),1:"")
	set isBaby=""
	
	set myMPCRowID=0
	while($o(^TMP("IPBILL","Check",pid,adm,myMPCRowID))) {
		set myMPCRowID=$o(^TMP("IPBILL","Check",pid,adm,myMPCRowID))
		do GetAdmCheckFee(adm, myMPCRowID)
	}
	if (babyToMother'="Y")  quit $$$OK
	
	//婴儿明细
	set isBaby="Y"
	set babyAdm=0
	while($o(^PAADMi("Mother",adm,babyAdm))) {
		set babyAdm=$o(^PAADMi("Mother",adm,babyAdm))
		set myMPCRowID=0
		while($o(^TMP("IPBILL","Check",pid,babyAdm,myMPCRowID))) {
			set myMPCRowID=$o(^TMP("IPBILL","Check",pid,babyAdm,myMPCRowID))
			do GetAdmCheckFee(babyAdm, myMPCRowID)
		}
	}
	
	quit $$$OK

GetAdmCheckFee(myAdm, myMPCRowID)
	set MPCData=$g(^DHCMPConfig(myMPCRowID))
	quit:(MPCData="")
	set MPCCode=$p(MPCData,"^",1)
	set MPCDesc=$p(MPCData,"^",2)
	set MPCDesc=##class(User.DHCBillMonitorPointConfig).GetTranByDesc("MPCDesc", MPCDesc, langId)
	if (isBaby="Y") {
		set papmi=$p(^PAADM(myAdm),"^",1)
		set patName=$s((+papmi'=0):$p(^PAPER(papmi,"ALL"),"^",1),1:"")
		set MPCDesc="<font color='red'>"_patName_"</font>"_MPCDesc
	}
	
	if (" 01 02 03 04 "[(" "_MPCCode_" ")) {
		//01 02 03 04 床位/级别护理/诊查/空调费收费天数
		do InitCheckFeeVariables
		set typeCode="DATE"
		set date=""
		while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"YSNUM",date))'="") {
			set date=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"YSNUM",date))
			set myYSNum=$g(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"YSNUM",date))
			set typeDR=myMPCRowID_date
			set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
			set auditLevel=$lg(auditInfo,5)
			continue:((isAudit="Y")&&(roleLevel'=auditLevel))
			continue:((isAudit="N")&&(roleLevel=auditLevel))
			set YSNum=$i(YSNum, myYSNum)
		}
		set date=""
		while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"SSNUM",date))'="") {
			set date=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"SSNUM",date))
			set mySSNum=$g(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"SSNUM",date))
			set typeDR=myMPCRowID_date
			set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
			set auditLevel=$lg(auditInfo,5)
			continue:((isAudit="Y")&&(roleLevel'=auditLevel))
			continue:((isAudit="N")&&(roleLevel=auditLevel))
			set SSNum=$i(SSNum, mySSNum)
		}
		quit:(+YSNum=+SSNum)         //应收天数等于实收天数时退出
		set errMsg=##class(websys.Translation).Get("", "应收天数", langId)_"："_YSNum_"，"_##class(websys.Translation).Get("", "实收天数", langId)_"："_SSNum
		do OutputCheckFee
	}elseif (MPCCode="05") {
		//05 实际发药数量与收费是否相符
		do InitCheckFeeVariables
		set typeCode="OEORE"
		set oeore=""
		while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeore))'="") {
			set oeore=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeore))
			set typeDR=oeore
			set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
			set auditLevel=$lg(auditInfo,5)
			continue:((isAudit="Y")&&(roleLevel'=auditLevel))
			continue:((isAudit="N")&&(roleLevel=auditLevel))
			set billInfo=..GetOrderBillInfo(oeore)
			set totalQty=$p(billInfo,"^",2)
			set dspQty=..GetDspQty(oeore)          //实际发药数量
			set billQtySum=$i(billQtySum, totalQty)
			set dspQtySum=$i(dspQtySum, dspQty)
		}
		quit:(+billQtySum=+dspQtySum)
		set errMsg=##class(websys.Translation).Get("", "计费数量", langId)_"："_billQtySum_"，"_##class(websys.Translation).Get("", "发药数量", langId)_"："_dspQtySum
		do OutputCheckFee
	}elseif (MPCCode="06") {
		//06 已做手术安排但是没有手术室计费
		do InitCheckFeeVariables
		set typeCode="OEORI"
		set oeori=""
		while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeori))'="") {
			set oeori=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeori))
			set typeDR=oeori
			set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
			set auditLevel=$lg(auditInfo,5)
			continue:((isAudit="Y")&&(roleLevel'=auditLevel))
			continue:((isAudit="N")&&(roleLevel=auditLevel))
			set ANOPNoBillNum=$i(ANOPNoBillNum)
		}
		quit:(+ANOPNoBillNum=0)
		set errMsg=##class(websys.Translation).Get("", "未计费医嘱数量", langId)_"："_ANOPNoBillNum
		do OutputCheckFee
	}elseif (MPCCode="07") {
		//07 需计费医嘱未停止未计费
		do InitCheckFeeVariables
		set typeCode="OEORE"
		set oeore=""
		while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeore))'="") {
			set oeore=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeore))
			set typeDR=oeore
			set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
			set auditLevel=$lg(auditInfo,5)
			continue:((isAudit="Y")&&(roleLevel'=auditLevel))
			continue:((isAudit="N")&&(roleLevel=auditLevel))
			set noBillNum=$i(noBillNum)
		}
		quit:(+noBillNum=0)
		set errMsg=##class(websys.Translation).Get("", "未计费执行记录数量", langId)_"："_noBillNum
		do OutputCheckFee
	}elseif (MPCCode="08") {
		//08 医嘱没有执行记录
		do InitCheckFeeVariables
		set typeCode="OEORI"
		set oeori=""
		while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeori))'="") {
			set oeori=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeori))
			set typeDR=oeori
			set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
			set auditLevel=$lg(auditInfo,5)
			continue:((isAudit="Y")&&(roleLevel'=auditLevel))
			continue:((isAudit="N")&&(roleLevel=auditLevel))
			set execNullNum=$i(execNullNum)
		}
		quit:(+execNullNum=0)
		set errMsg=##class(websys.Translation).Get("", "缺少执行记录的医嘱数量", langId)_"："_execNullNum
		do OutputCheckFee
	}elseif (MPCCode="09") {
		//09 查找数据不全的医嘱
		do InitCheckFeeVariables
		set typeCode="OEORI"
		set oeori=""
		while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeori))'="") {
			set oeori=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeori))
			set typeDR=oeori
			set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
			set auditLevel=$lg(auditInfo,5)
			continue:((isAudit="Y")&&(roleLevel'=auditLevel))
			continue:((isAudit="N")&&(roleLevel=auditLevel))
			set dataNullNum=$i(dataNullNum)
		}
		quit:(+dataNullNum=0)
		set errMsg=##class(websys.Translation).Get("", "数据不全医嘱数量", langId)_"："_dataNullNum
		do OutputCheckFee
	}elseif (MPCCode="10") {
		//10 医嘱账单数量小于0的医嘱
		do InitCheckFeeVariables
		set typeCode="OEORE"
		set oeore=""
		while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeore))'="") {
			set oeore=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeore))
			set typeDR=oeore
			set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
			set auditLevel=$lg(auditInfo,5)
			continue:((isAudit="Y")&&(roleLevel'=auditLevel))
			continue:((isAudit="N")&&(roleLevel=auditLevel))
			set pboNegativeNum=$i(pboNegativeNum)
		}
		quit:(+pboNegativeNum=0)
		set errMsg=##class(websys.Translation).Get("", "医嘱账单数量小于0的数量", langId)_"："_pboNegativeNum
		do OutputCheckFee
	}elseif (MPCCode="11") {
		//11 医嘱账单价格为0
		do InitCheckFeeVariables
		set typeCode="OEORE"
		set oeore=""
		while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeore))'="") {
			set oeore=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeore))
			set typeDR=oeore
			set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
			set auditLevel=$lg(auditInfo,5)
			continue:((isAudit="Y")&&(roleLevel'=auditLevel))
			continue:((isAudit="N")&&(roleLevel=auditLevel))
			set pboZeroPriceNum=$i(pboZeroPriceNum)
		}
		quit:(+pboZeroPriceNum=0)
		set errMsg=##class(websys.Translation).Get("", "医嘱账单价格为0的数量", langId)_"："_pboZeroPriceNum
		do OutputCheckFee
	}elseif (MPCCode="12") {
		//医嘱每日最大数量
		do InitCheckFeeVariables
		set date=""
		while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"YSNUM",date))'="") {
			set date=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"YSNUM",date))
			set cate=""
			while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"YSNUM",date,cate))'="") {
				set cate=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"YSNUM",date,cate))
				set type=$p(cate,$c(2),1)
				set cateDR=$p(cate,$c(2),2)
				set typeCode=type
				set typeDR=cateDR
				set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
				set auditLevel=$lg(auditInfo,5)
				continue:((isAudit="Y")&&(roleLevel'=auditLevel))
				continue:((isAudit="N")&&(roleLevel=auditLevel))
				set YSNum=$g(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"YSNUM",date,cate))
				set SSNum=$g(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"SSNUM",date,cate))
				continue:(+YSNum>=+SSNum)
				set errMsg=##class(websys.Translation).Get("", "应收", langId)_"："_YSNum_"，"_##class(websys.Translation).Get("", "实收", langId)_"："_SSNum
				do OutputCheckFee
			}
		}
	}elseif (MPCCode="13") {
		//住院医保患者医嘱医保属性为空
		do InitCheckFeeVariables
		set itm=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,""))
		set typeCode=$s(($l(itm,"||")=3):"OEORE",1:"OEORI")
		set itm=""
		while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,itm))'="") {
			set itm=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,itm))
			set typeDR=itm
			set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
			set auditLevel=$lg(auditInfo,5)
			continue:((isAudit="Y")&&(roleLevel'=auditLevel))
			continue:((isAudit="N")&&(roleLevel=auditLevel))
			set mainInsNullNum=$i(mainInsNullNum)
		}
		quit:(+mainInsNullNum=0)
		set errMsg=##class(websys.Translation).Get("", "医保属性为空的医嘱数量", langId)_"："_mainInsNullNum
		do OutputCheckFee
	}
	
	quit
	
OutputCheckFee
	set Data=$lb(myAdm,myMPCRowID,MPCCode,MPCDesc,errMsg)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit

InitCheckFeeVariables
	set errMsg=""
	set (YSNum, SSNum, billQtySum, dspQtySum, ANOPNoBillNum, noBillNum, execNullNum, dataNullNum, pboNegativeNum, pboZeroPriceNum, mainInsNullNum)=0
	quit
}

/// Creator: ZhYW
/// CreatDate: 2017-07-21
/// Description: 住院病人错误数据查询
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillCheckAdmCost", "FindCheckFeeDtl", "80","190","29","")
Query FindCheckFeeDtl(adm As %String, pid As %String, MPCRowID As %String, isAudit As %String, roleLevel As %String, langId As %String = "") As websys.Query(ROWSPEC = "TAdm:%String:就诊ID,TMPCRowID:%String:监控点ID,TMPCDesc:%String:监控点描述,TMPCReviewed:%String,TArcimDesc:%String:医嘱,TItemCatDesc:%String:医嘱子类,TOECCatDesc:%String:医嘱大类,TOEEXDatTime:%String:要求执行时间,TOrdStatDesc:%String:医嘱状态,TOEEXStatDesc:%String:执行记录状态,TBilledStatus:%String:计费状态,TUnitPrice:%Float:单价,TTotalQty:%String:数量,TTotalAmt:%Float:金额,TDspTotalQty:%String:实际发药数量,TOrdDoc:%String:开单医生,TRecDept:%String:接收科室,TAuditId:%String:审核ID,TAuditUser:%String:审核人,TAuditDate:%String:审核日期,TAuditTime:%String:审核时间,TAuditLevel:%String:审核级别,TTypeCode:%String,TTypeDR:%String,TReviewUser:%String:二级审核人,TReviewDate:%String:二级审核日期,TReviewTime:%String:二级审核时间")
{
}

ClassMethod FindCheckFeeDtlExecute(ByRef qHandle As %Binary, adm As %String, pid As %String, MPCRowID As %String, isAudit As %String, roleLevel As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("FindCheckFeeDtl")=$lb(adm, pid, MPCRowID, isAudit, roleLevel, langId)
	if ((+adm=0)||(+pid=0))  quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	set conf=##class(web.DHCBillCommon).GetTarParaId(admHospDR)
	set babyToMother=$s((+conf'=0):$p($g(^DHCTarC("CF",conf)),"^",5),1:"")
	set isBaby=""
	
	if (+MPCRowID'=0) {
		do GetAdmCheckFeeDtl(adm, MPCRowID)
		quit $$$OK
	}

	set myMPCRowID=0
	while($o(^TMP("IPBILL","Check",pid,adm,myMPCRowID))) {
		set myMPCRowID=$o(^TMP("IPBILL","Check",pid,adm,myMPCRowID))
		do GetAdmCheckFeeDtl(adm, myMPCRowID)
	}
	if (babyToMother'="Y")  quit $$$OK
	
	//婴儿明细
	set isBaby="Y"
	set babyAdm=0
	while($o(^PAADMi("Mother",adm,babyAdm))) {
		set babyAdm=$o(^PAADMi("Mother",adm,babyAdm))
		set myMPCRowID=0
		while($o(^TMP("IPBILL","Check",babyAdm,pid,myMPCRowID))) {
			set myMPCRowID=$o(^TMP("IPBILL","Check",babyAdm,pid,myMPCRowID))
			do GetAdmCheckFeeDtl(babyAdm, myMPCRowID)
		}
	}
	
	quit $$$OK

GetAdmCheckFeeDtl(myAdm, myMPCRowID)
	set MPCData=$g(^DHCMPConfig(myMPCRowID))
	quit:(MPCData="")
	set MPCCode=$p(MPCData,"^",1)
	set MPCDesc=$p(MPCData,"^",2)
	set MPCDesc=##class(User.DHCBillMonitorPointConfig).GetTranByDesc("MPCDesc", MPCDesc, langId)
	set MPCReviewed=$p(MPCData,"^",7)   //+2022-04-28 ZhYW 监控点能否审核标识
	if (isBaby="Y") {
		set papmi=$p(^PAADM(myAdm),"^",1)
		set patName=$s((+papmi'=0):$p(^PAPER(papmi,"ALL"),"^",1),1:"")
		set MPCDesc="<font color='red'>"_patName_"</font>"_MPCDesc
	}

	if (" 01 02 03 04 "[(" "_MPCCode_" ")) {
		//01 02 03 04 床位/级别护理/诊查/空调费收费天数
		do InitDtlVariables
		set typeCode="DATE"
		set date=""
		while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"YSNUM",date))'="") {
			set date=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"YSNUM",date))
			set mySSNum=$g(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"SSNUM",date))
			continue:(+mySSNum'=0)        //本日有医嘱时退出
			set typeDR=myMPCRowID_date
			set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
			set auditId=$lg(auditInfo,1)
			set auditUser=$lg(auditInfo,2)
			set auditDate=$lg(auditInfo,3)
			set auditTime=$lg(auditInfo,4)
			set auditLevel=$lg(auditInfo,5)
			set reviewUser=$lg(auditInfo,6)
			set reviewDate=$lg(auditInfo,7)
			set reviewTime=$lg(auditInfo,8)
			continue:((isAudit="Y")&&(roleLevel'=auditLevel))
			continue:((isAudit="N")&&(roleLevel=auditLevel))
			set myYSNum=$g(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"YSNUM",date))
			set arcimDesc=##class(websys.Translation).Get("", "未找到医嘱", langId)
			set OEEXDatTime=##class(websys.Conversions).DateLogicalToHtml(date)
			set totalQty=mySSNum
			do OutputDtl
		}

		set date=""
		while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"SSNUM",date))'="") {
			set date=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"SSNUM",date))
			set myYSNum=$g(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"YSNUM",date))
			set mySSNum=$g(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"SSNUM",date))
			continue:(myYSNum=mySSNum)
			set typeDR=myMPCRowID_date
			set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
			set auditId=$lg(auditInfo,1)
			set auditUser=$lg(auditInfo,2)
			set auditDate=$lg(auditInfo,3)
			set auditTime=$lg(auditInfo,4)
			set auditLevel=$lg(auditInfo,5)
			set reviewUser=$lg(auditInfo,6)
			set reviewDate=$lg(auditInfo,7)
			set reviewTime=$lg(auditInfo,8)
			continue:((isAudit="Y")&&(roleLevel'=auditLevel))
			continue:((isAudit="N")&&(roleLevel=auditLevel))
			set cate=$g(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"SSNUM",date,"CATE"))
			set itmDesc=$p(cate,$c(2),1)
			set itmDR=$p(cate,$c(2),2)
			if (itmDesc="ARCIM") {
				set arcimDesc=$p($g(^ARCIM(+itmDR,$p(itmDR,"||",2),1)),"^",2)
				set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId)
				set itemCatDR=$p($g(^ARCIM(+itmDR,$p(itmDR,"||",2),1)),"^",10)
				set itemCatDesc=$s((+itemCatDR'=0):$p($g(^ARC("IC",itemCatDR)),"^",2),1:"")
				set itemCatDesc=##class(User.ARCItemCat).GetTranByDesc("ARCICDesc", itemCatDesc, langId)
				set OECCatDR=$s((+itemCatDR'=0):$p($g(^ARC("IC",itemCatDR)),"^",8),1:"")
				set OECCatDesc=$s((+OECCatDR'=0):$p($g(^OEC("ORCAT",OECCatDR)),"^",2),1:"")
				set OECCatDesc=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc", OECCatDesc, langId)
			}
			if (itmDesc="ARCIC") {
				set itemCatDesc=$p(^ARC("IC",itmDR),"^",2)
				set itemCatDesc=##class(User.ARCItemCat).GetTranByDesc("ARCICDesc", itemCatDesc, langId)
				set OECCatDR=$p(^ARC("IC",itmDR),"^",8)
				set OECCatDesc=$s((+OECCatDR'=0):$p($g(^OEC("ORCAT",OECCatDR)),"^",2),1:"")
				set OECCatDesc=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc", OECCatDesc, langId)
			}
			if (itmDesc="OECCAT") {
				set OECCatDesc=$p(^OEC("ORCAT",itmDR),"^",2)
				set OECCatDesc=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc", OECCatDesc, langId)
			}
			set OEEXDatTime=##class(websys.Conversions).DateLogicalToHtml(date)
			set totalQty=mySSNum
			do OutputDtl
		}
	}elseif (MPCCode="05") {
		//05 实际发药数量与收费是否相符
		do InitDtlVariables
		do OEOREDtl
	}elseif (MPCCode="06") {
		//06 已做手术安排但是没有手术室计费
		do InitDtlVariables
		do OEORIDtl
	}elseif (MPCCode="07") {
		//07 需计费医嘱未停止未计费
		do InitDtlVariables
		do OEOREDtl
	}elseif (MPCCode="08") {
		//08 医嘱没有执行记录
		do InitDtlVariables
		do OEORIDtl
	}elseif (MPCCode="09") {
		//09 查找数据不全的医嘱
		do InitDtlVariables
		do OEORIDtl
	}elseif (" 10 11 "[(" "_MPCCode_" ")) {
		//10 医嘱账单数量小于0的医嘱; 11 医嘱账单价格为0
		do InitDtlVariables
		do OEOREDtl
	}elseif (MPCCode="12") {
		//12 医嘱每日最大数量
		do InitDtlVariables
		do ARCIMDtl
	}elseif (MPCCode="13") {
		//13.住院医保患者医嘱医保属性为空
		do InitDtlVariables
		set itm=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,""))
		if ($l(itm,"||")=3) {
			do OEOREDtl
		}else {
			do OEORIDtl
		}
	}
	
	quit

OEORIDtl
	set typeCode="OEORI"
	set oeori=""
	while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeori))'="") {
		set oeori=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeori))
		set typeDR=oeori
		set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
		set auditId=$lg(auditInfo,1)
		set auditUser=$lg(auditInfo,2)
		set auditDate=$lg(auditInfo,3)
		set auditTime=$lg(auditInfo,4)
		set auditLevel=$lg(auditInfo,5)
		set reviewUser=$lg(auditInfo,6)
		set reviewDate=$lg(auditInfo,7)
		set reviewTime=$lg(auditInfo,8)
		continue:((isAudit="Y")&&(roleLevel'=auditLevel))
		continue:((isAudit="N")&&(roleLevel=auditLevel))
		set ord=$p(oeori,"||",1)
		set itm=$p(oeori,"||",2)
		set arcimDR=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
		set depProcNotes=$g(^OEORD(ord,"I",itm,"DEP",1))
		set arcimDesc=$s((arcimDR'=""):$p($g(^ARCIM(+arcimDR,$p(arcimDR,"||",2),1)),"^",2),1:"医嘱项为空")
		set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId)
		set itemCatDR=$s((arcimDR'=""):$p($g(^ARCIM(+arcimDR,$p(arcimDR,"||",2),1)),"^",10),1:"")    //医嘱子分类
		set itemCatDesc=$s((+itemCatDR'=0):$p($g(^ARC("IC",itemCatDR)),"^",2),1:"医嘱子分类为空")
		set itemCatDesc=##class(User.ARCItemCat).GetTranByDesc("ARCICDesc", itemCatDesc, langId)
		set ordCateType=$s((+itemCatDR'=0):$p($g(^ARC("IC",itemCatDR)),"^",7),1:"")                 //医嘱类型
		set OECCatDR=$s((+itemCatDR'=0):$p($g(^ARC("IC",itemCatDR)),"^",8), 1:"")       //医嘱大类
		set OECCatDesc=$s((OECCatDR'=""):$p($g(^OEC("ORCAT",OECCatDR)),"^",2),1:"医嘱大类为空")
		set OECCatDesc=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc", OECCatDesc, langId)
		if (MPCCode="06") {
			//已做手术安排但是没有手术室计费, 显示手术室
			set operDept=$g(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeori))
			set arcimDesc=arcimDesc_" "_depProcNotes_" "_operDept
		}
		set ordDocDR=$p($g(^OEORD(ord,"I",itm,1)),"^",11)
		set ordDoc=$s((+ordDocDR'=0):$p($g(^CTPCP(ordDocDR,1)),"^",2),1:"")
		set ordDoc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", ordDoc, langId)
		set recDeptDR=$p($g(^OEORD(ord,"I",itm,3)),"^",6)
		set recDept=$s((+recDeptDR'=0):$p($g(^CTLOC(recDeptDR)),"^",2),1:"")
		set recDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", recDept, langId)
		set ordStatusDR=$p(^OEORD(ord,"I",itm,1),"^",13)
		set ordStatDesc=$s((+ordStatusDR'=0):$p(^OEC("OSTAT",ordStatusDR),"^",2),1:"医嘱状态为空")
		set ordStatDesc=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc", ordStatDesc, langId)
		do OutputDtl
	}
	
	quit
	
OEOREDtl
	set typeCode="OEORE"
	set oeore=""
	while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeore))'="") {
		set oeore=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,oeore))
		set typeDR=oeore
		set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
		set auditId=$lg(auditInfo,1)
		set auditUser=$lg(auditInfo,2)
		set auditDate=$lg(auditInfo,3)
		set auditTime=$lg(auditInfo,4)
		set auditLevel=$lg(auditInfo,5)
		set reviewUser=$lg(auditInfo,6)
		set reviewDate=$lg(auditInfo,7)
		set reviewTime=$lg(auditInfo,8)
		continue:((isAudit="Y")&&(roleLevel'=auditLevel))
		continue:((isAudit="N")&&(roleLevel=auditLevel))
		set ord=$p(oeore,"||",1)
		set itm=$p(oeore,"||",2)
		set exec=$p(oeore,"||",3)
		set oeori=ord_"||"_itm
		set depProcNotes=$g(^OEORD(ord,"I",itm,"DEP",1))
		set arcimDR=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
		set arcimDesc=$s((arcimDR'=""):$p($g(^ARCIM(+arcimDR,$p(arcimDR,"||",2),1)),"^",2),1:"医嘱项为空")
		set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId)
		if (depProcNotes'="") {
			set arcimDesc=arcimDesc_" "_depProcNotes
		}
		set itemCatDR=$s((arcimDR'=""):$p($g(^ARCIM(+arcimDR,$p(arcimDR,"||",2),1)),"^",10),1:"")    //医嘱子分类
		set itemCatDesc=$s((+itemCatDR'=0):$p($g(^ARC("IC",itemCatDR)),"^",2),1:"医嘱子分类为空")
		set itemCatDesc=##class(User.ARCItemCat).GetTranByDesc("ARCICDesc", itemCatDesc, langId)
		set ordCateType=$s((+itemCatDR'=0):$p($g(^ARC("IC",itemCatDR)),"^",7),1:"")                 //医嘱类型
		set OECCatDR=$s((+itemCatDR'=0):$p($g(^ARC("IC",itemCatDR)),"^",8), 1:"")       //医嘱大类
		set OECCatDesc=$s((OECCatDR'=""):$p($g(^OEC("ORCAT",OECCatDR)),"^",2),1:"医嘱大类为空")
		set OECCatDesc=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc", OECCatDesc, langId)
		set ordDocDR=$p($g(^OEORD(ord,"I",itm,1)),"^",11)
		set ordDoc=$s((+ordDocDR'=0):$p($g(^CTPCP(ordDocDR,1)),"^",2),1:"")
		set ordDoc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", ordDoc, langId)
		set recDeptDR=$p($g(^OEORD(ord,"I",itm,3)),"^",6)
		set recDept=$s((+recDeptDR'=0):$p($g(^CTLOC(recDeptDR)),"^",2),1:"")
		set recDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", recDept, langId)
		set billStatStr=##class(web.DHCBillInterface).IGetOrdItmBilled(oeore)
		set billedStatus=$p(billStatStr,"^",2)
		set OEEXStDate=$p(^OEORD(ord,"I",itm,"X",exec),"^",1)
		set OEEXStTime=$p(^OEORD(ord,"I",itm,"X",exec),"^",2)
		set OEEXStDate=##class(websys.Conversions).DateLogicalToHtml(OEEXStDate)
		set OEEXStTime=##class(websys.Conversions).TimeLogicalToHtml(OEEXStTime, 1)
		set OEEXDatTime=OEEXStDate_" "_OEEXStTime
		set ordStatusDR=$p(^OEORD(ord,"I",itm,1),"^",13)
		set ordStatDesc=$s((ordStatusDR'=""):$p(^OEC("OSTAT",ordStatusDR),"^",2), 1:"医嘱状态为空")
		set ordStatDesc=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc", ordStatDesc, langId)
		set oeoreBillStr=$g(^OEORD(+ord,"I",itm,"X",exec,"BILL"))
		set OEEXStatDR=$p(oeoreBillStr,"^",1)
		set OEEXStatDesc=$s((+OEEXStatDR'=0):$p($g(^OEC("OSTAT",+OEEXStatDR)),"^",2),1:"")
		set OEEXStatDesc=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc", OEEXStatDesc, langId)
		set billInfo=..GetOrderBillInfo(oeore)
		set unitPrice=$p(billInfo,"^",1)
		set totalQty=$p(billInfo,"^",2)
		set totalAmt=$p(billInfo,"^",3)
		set dspTotalQty=$s((ordCateType="R"):..GetDspQty(oeore),1:"")   //实际发药数量
		set PBORowID=$p(oeoreBillStr,"^",2)
		do OutputDtl
	}
	
	quit

ARCIMDtl
	set typeCode="ARCIM"
	set date=""
	while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"SSNUM",date))'="") {
		set date=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"SSNUM",date))
		set OEEXStDate=##class(websys.Conversions).DateLogicalToHtml(date)
		set OEEXDatTime=OEEXStDate
		set cate=""
		while($o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"SSNUM",date,cate))'="") {
			set cate=$o(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"SSNUM",date,cate))
			set type=$p(cate,$c(2),1)
			set cateDR=$p(cate,$c(2),2)
			set typeDR=cateDR
			set auditInfo=..GetAuditInfo(myAdm, myMPCRowID, typeCode, typeDR)
			set auditId=$lg(auditInfo,1)
			set auditUser=$lg(auditInfo,2)
			set auditDate=$lg(auditInfo,3)
			set auditTime=$lg(auditInfo,4)
			set auditLevel=$lg(auditInfo,5)
			set reviewUser=$lg(auditInfo,6)
			set reviewDate=$lg(auditInfo,7)
			set reviewTime=$lg(auditInfo,8)
			continue:((isAudit="Y")&&(roleLevel'=auditLevel))
			continue:((isAudit="N")&&(roleLevel=auditLevel))
			set mySSNum=$g(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"SSNUM",date,cate))
			set myYSNum=$g(^TMP("IPBILL","Check",pid,myAdm,myMPCRowID,"YSNUM",date,cate))
			continue:(+myYSNum>=+mySSNum)
			set totalQty=mySSNum
			if (type="OECCAT") {        //医嘱大类
				set OECCatDesc=$p($g(^OEC("ORCAT",cateDR)),"^",2)
			}
			if (type="ARCIC") {   //医嘱子分类
				set itemCatDesc=$p($g(^ARC("IC",cateDR)),"^",2)
				set OECCatDR=$p($g(^ARC("IC",cateDR)),"^",8)
				set OECCatDesc=$s((+OECCatDR'=0):$p($g(^OEC("ORCAT",OECCatDR)),"^",2),1:"")
			}
			if (type="ARCIM") {
				set arcimDesc=$p($g(^ARCIM(+cateDR,$p(cateDR,"||",2),1)),"^",2)
				set itemCatDR=$p($g(^ARCIM(+cateDR,$p(cateDR,"||",2),1)),"^",10)    //医嘱子分类
				if (itemCatDR'="") {
					set itemCatDesc=$p(^ARC("IC",itemCatDR),"^",2)
					set OECCatDR=$p(^ARC("IC",itemCatDR),"^",8)       //医嘱大类
					set OECCatDesc=$s((+OECCatDR'=0):$p($g(^OEC("ORCAT",OECCatDR)),"^",2),1:"")
				}
			}
			do OutputDtl
		}
	}
	
	quit

InitDtlVariables
	set (arcimDesc, itemCatDesc, OECCatDesc, OEEXDatTime, ordStatDesc, OEEXStatDesc, billedStatus, unitPrice, totalQty, totalAmt, dspTotalQty, ordDoc, recDept, auditId, auditUser, auditDate, auditTime, auditLevel, typeCode, typeDR, reviewUser, reviewDate, reviewTime)=""
	quit

OutputDtl
	set Data=$lb(myAdm,myMPCRowID,MPCDesc,MPCReviewed,arcimDesc,itemCatDesc,OECCatDesc,OEEXDatTime,ordStatDesc,OEEXStatDesc,billedStatus,unitPrice,totalQty,totalAmt,dspTotalQty,ordDoc,recDept,auditId,auditUser,auditDate,auditTime,auditLevel,typeCode,typeDR,reviewUser,reviewDate,reviewTime)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2017-07-30
/// Description: 获取基本信息
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetPatientInfo("", "", 9, "", "")
ClassMethod GetPatientInfo(adm As %String, patientNo As %String, medicareNo As %String, hospId As %String, langId As %String = "") As %String
{
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	set json=##class(%DynamicObject).%New()
	set patientId=""
	if (+adm'=0) {
		set patientId=$p($g(^PAADM(adm)),"^",1)
	}elseif (patientNo'="") {
	    set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
	    set patientId=$o(^PAPERi("PAPMI_PatNo",patientNo,""))
	}elseif (medicareNo'="") {
		set patientId=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(medicareNo, "I", hospId, "")
	}
	quit:(patientId="") json.%ToJSON()

    set patName=$p($g(^PAPER(patientId,"ALL")),"^",1)
    set patientNo=$p($g(^PAPER(patientId,"PAT",1)),"^",1)
    if (medicareNo=""){
	    set medicareNo=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patientId, "I", hospId, "")
	}
	if (adm="") {
		set myAdm=""
		while($o(^PAPERdr(patientId,"ADM","I",myAdm),-1)) {
			set myAdm=$o(^PAPERdr(patientId,"ADM","I",myAdm),-1)
			set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(myAdm)
			continue:(admHospDR'=hospId)
			set visitStatus=$p(^PAADM(myAdm),"^",20)
			continue:(" C P "[(" "_visitStatus_" "))
			set adm=myAdm
			quit
		}
	}
	
	do json.%Set("patientId", patientId).%Set("patientNo", patientNo)
	do json.%Set("patName", patName).%Set("medicareNo", medicareNo)
	do json.%Set("episodeId", adm)
	
    quit json.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2017-07-30
/// Description: 获取基本信息
/// Input: 
/// Return: 
/// Debug:	w ##class(web.DHCIPBillCheckAdmCost).GetAdmInfo("", "", 94)
ClassMethod GetAdmInfo(adm As %String, langId As %String = "") As %String
{
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	set json=##class(%DynamicObject).%New()
	quit:((+adm=0)||('$d(^PAADM(adm)))) json.%ToJSON()
	
	set patientId=$p($g(^PAADM(adm)),"^",1)
	quit:(+patientId=0) json.%ToJSON()
	
	set patJsonStr=##class(BILL.COM.PAPatMas).GetPatientInfo(patientId)
	set patJson=##class(%DynamicObject).%FromJSON(patJsonStr)
	
	set admJsonStr=##class(BILL.COM.PAAdm).GetAdmInfo(adm)
	set admJson=##class(%DynamicObject).%FromJSON(admJsonStr)
	
	do json.%Set("patientId", patientId).%Set("patientNo", patJson.PatientNo)
	do json.%Set("patName", patJson.PatName).%Set("medicareNo", admJson.MedicareNo)
	do json.%Set("sex", ##class(User.CTSex).GetTranByDesc("CTSEXDesc", patJson.Sex, langId))
	do json.%Set("sexIconCls", patJson.SexIconCls).%Set("bed", admJson.Bed)
	do json.%Set("dept", ##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admJson.Dept, langId))
	do json.%Set("ward", ##class(User.PACWard).GetTranByDesc("WARDDesc", admJson.Ward, langId))
	do json.%Set("insType", ##class(User.PACAdmReason).GetTranByDesc("READesc", admJson.InsType, langId))
	do json.%Set("admDate", admJson.AdmDate).%Set("disChgDate", admJson.DiscDate)
	
    quit json.%ToJSON()
}

ClassMethod CheckExistErrData(adm As %String, pid As %String, roleLevel As %String) As %String
{
	set rtn=0
	quit:((+adm=0)||(+pid=0)) rtn
	set isAudit=""
	set rs=##class(%ResultSet).%New("web.DHCIPBillCheckAdmCost:FindCheckFee")
	do rs.Execute(adm, pid, isAudit, roleLevel)
	quit rs.Next()
}

/// Creator: ZhYW
/// CreatDate: 2017-08-02
/// Description: 住院费用审核
/// Input: sessionStr: 用户Id^安全组Id^登录科室Id^医院Id
/// Return: 
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).Audit(15, "")
ClassMethod Audit(auditList As %ArrayOfDataTypes, sessionStr As %String) As %String
{
	set $zt="ERROR"
	set rtn=0

	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	ts

	set i=0
	while($o(auditList(i))) {
		set i=$o(auditList(i))
		set tmpStr=$g(auditList(i))
		continue:(tmpStr="")
		set myAdm=$p(tmpStr,"^",1)
		set myMPCRowID=$p(tmpStr,"^",2)
		set myType=$p(tmpStr,"^",3)
		set myTypeDR=$p(tmpStr,"^",4)
		set myAuditId=$p(tmpStr,"^",5)   //+2022-11-14 ZhYW 审核RowId，二级审核使用
		set roleLevel=$p(tmpStr,"^",6)   //+2022-11-14 ZhYW 审核级别
		set myMPCData=$g(^DHCMPConfig(myMPCRowID))
		set myMPCDesc=$p(myMPCData,"^",2)
		set myMPCReviewed=$p(myMPCData,"^",7)   //+2022-04-28 ZhYW 监控点能否审核标识
		if (myMPCReviewed'="Y") {
			set rtn=-1_"^"_"监控点"_myMPCDesc_"配置不能审核"
			quit
		}
		if (+myAuditId=0) {
			&SQL(
				INSERT INTO DHC_JFCheckAdmFee (
					JFCAF_Adm_Dr, JFCAF_MPC_Dr, JFCAF_TypeCode, JFCAF_Type_Dr, JFCAF_User_Dr, JFCAF_Level
				)
				VALUES (
					:myAdm, :myMPCRowID, :myType, :myTypeDR, :userId, :roleLevel
				)
			)
		}else {
			&SQL(
				UPDATE DHC_JFCheckAdmFee
				SET JFCAF_Level = :roleLevel, JFCAF_UpdtUser_Dr = :userId, JFCAF_UpdtDate = CONVERT(DATE, NOW()), JFCAF_UpdtTime = CONVERT(TIME, NOW())
				WHERE %ID = :myAuditId
			)
		}
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2017-08-02
/// Description: 撤销住院费用审核
/// Input: sessionStr: 用户Id^安全组Id^登录科室Id^医院Id
/// Return: 
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).CancelAudit(^TMP("CancelAudit"), "17275^241^2^2^20")
ClassMethod CancelAudit(auditList As %ArrayOfDataTypes, sessionStr As %String) As %String
{
	set $zt="ERROR"
	set rtn=0
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	ts
	
	set i=0
	while($o(auditList(i))) {
		set i=$o(auditList(i))
		set tmpStr=$g(auditList(i))
		continue:(tmpStr="")
		set auditId=$p(tmpStr,"^",1)
		continue:(+auditId=0)
		set roleLevel=$p(tmpStr,"^",2)   //+2022-11-14 ZhYW 审核级别
		set auditData=$g(^DHCJFCheckAdmFee(auditId))
		set auditLevel=$p(auditData,"^",9)   //JFCAF_Level
		if (roleLevel'=auditLevel) {
			set rtn=-1_"^"_"不能跨级撤销"
			quit
		}
		if (roleLevel>1) {
			set updUserDR=$p(auditData,"^",10)   //JFCAF_UpdtUser_Dr
			if (updUserDR'=userId) {
				set rtn=-1_"^"_"不能撤销非本人的审核记录"
				quit
			}
			//二级审核撤销时，将其改为一级审核
			&SQL(
				UPDATE DHC_JFCheckAdmFee
				SET JFCAF_Level = (:roleLevel - 1), JFCAF_UpdtUser_Dr = :userId, JFCAF_UpdtDate = CONVERT(DATE, NOW()), JFCAF_UpdtTime = CONVERT(TIME, NOW())
				WHERE %ID = :auditId
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
			continue
		}
		
		//一级审核撤销
		set auditUserDR=$p(auditData,"^",5)   //JFCAF_User_Dr
		if (auditUserDR'=userId) {
			set rtn=-1_"^"_"不能撤销非本人的审核记录"
			quit
		}
		//删除
		&SQL(DELETE FROM DHC_JFCheckAdmFee WHERE %ID = :auditId)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
   
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2017-08-02
/// Description: 获取审核信息
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetAuditInfo(6, 1, "DATE", "166303")
ClassMethod GetAuditInfo(adm As %String, MPCRowID As %String, typeCode As %String, typeDR As %String, langId As %String = "") As %String
{
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	set auditUser=""
	set auditDate=""
	set auditTime=""
	set auditLevel=""
	set reviewUser=""
	set reviewDate=""
	set reviewTime=""
	set auditId=$o(^DHCJFCheckAdmFee(0,"TypeDR",adm,MPCRowID,typeCode,typeDR,""),-1)
	if (+auditId'=0) {
		&SQL(
			SELECT JFCAF_User_Dr, JFCAF_Date, JFCAF_Time, JFCAF_Level, JFCAF_UpdtUser_Dr, JFCAF_UpdtDate, JFCAF_UpdtTime
			INTO :auditUserDR, :auditDate, :auditTime, :auditLevel, :updtUserDR, :updtDate, :updtTime
			FROM DHC_JFCheckAdmFee
			WHERE %ID = :auditId
		)
		set auditUser=$s((+auditUserDR'=0):$p($g(^SSU("SSUSR",auditUserDR)),"^",2),1:"")
		set auditUser=##class(User.SSUser).GetTranByDesc("SSUSRName", auditUser, langId)
		set auditDate=##class(websys.Conversions).DateLogicalToHtml(auditDate)
		set auditTime=##class(websys.Conversions).TimeLogicalToHtml(auditTime)
		if (auditLevel>1) {
			set reviewUser=$s((+updtUserDR'=0):$p($g(^SSU("SSUSR",updtUserDR)),"^",2),1:"")
			set reviewUser=##class(User.SSUser).GetTranByDesc("SSUSRName", reviewUser, langId)
			set reviewDate=##class(websys.Conversions).DateLogicalToHtml(updtDate)
			set reviewTime=##class(websys.Conversions).TimeLogicalToHtml(updtTime)
		}
	}
	quit $lb(auditId, auditUser, auditDate, auditTime, auditLevel, reviewUser, reviewDate, reviewTime)
}

/// Creator: ZhYW
/// CreatDate: 2017-08-04
/// Description: 取医生站配置的空调费开始/结束日期
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetAirDocCfg(420)
ClassMethod GetAirDocCfg(adm As %String, hospId As %String) As %String
{
	quit:(+adm=0) ""
	
	//启用空调费,暖气费全局收取开关
	set enableAir=##class(web.DHCDocConfig).GetConfigNode("EnableAir", hospId)
	set enableHeat=##class(web.DHCDocConfig).GetConfigNode("EnableHeat", hospId)
	set feeFlag="N"  //删除设置的费用的时候;0节点未作减少操作

 	set stDate=""
 	set endDate=""
 	set admData=$g(^PAADM(adm))
 	quit:(+admData="") ""
 	set ward=$p(admData,"^",70)
	set bed=$p(admData,"^",73)
	quit:((+ward=0)||(bed="")) ""
	set bedType=$p(^PAWARD(ward,"BED",+$p(bed,"||",2)),"^",2)
	set today=+$h
	//根据个别的床位进行遍历收费项目
 	set bedOnlyFeeNum=$g(^PAWARD(ward,"BED",+$p(bed,"||",2),"FEE",0))  //制定规则,床位优先
 	quit:(bedOnlyFeeNum="") ""
 	if (bedOnlyFeeNum'="") {
	 	for bedFeeIdx=1:1:bedOnlyFeeNum {
		 	set bedFeeData=$g(^PAWARD(ward,"BED",+$p(bed,"||",2),"FEE",bedFeeIdx))   //DHC_PAC_BedFeeItem
		 	set arcim=$p(bedFeeData,"^",2)
		 	continue:(arcim="")
			set feeTypeDR=$p(bedFeeData,"^",1)
		 	set feeTypeCode=$s((+feeTypeDR'=0):$p($g(^PAC("FEETP",feeTypeDR)),"^",1),1:"")
		 	continue:((enableAir'="Y")&&(feeTypeCode="AC"))
		 	continue:((enableHeat'="Y")&&(feeTypeCode="H"))
		 	set feeFlag="Y"    //只要有医嘱项说明可以优先
			set stDate=$p(bedFeeData,"^",3)
		 	set endDate=$p(bedFeeData,"^",4)
		 	set:(endDate="") endDate=(today+1)
		 	continue:((today>endDate)||(today<stDate))
	 	}
 	}
 	
 	//根据床的类型遍历该类型的床的收费项目
 	set bedTypeFeeNum=$g(^PAC("BEDTP",bedType,"FEE",0))
	quit:(bedTypeFeeNum="") ""
	
 	if (feeFlag="N") {
	 	for typeFeeIdx=1:1:bedTypeFeeNum {
		 	set typeFeeData=$g(^PAC("BEDTP",bedType,"FEE",typeFeeIdx))     //DHC_PAC_BedTypeFeeItem
		 	continue:(typeFeeData="")
		 	set arcim=$p(typeFeeData,"^",2)
		 	continue:(arcim="")
		 	set feeTypeDR=$p(typeFeeData,"^",1)
		 	set feeTypeCode=$s((+feeTypeDR'=0):$p($g(^PAC("FEETP",feeTypeDR)),"^",1),1:"")
		 	continue:((enableAir'="Y")&&(feeTypeCode="AC"))
		 	continue:((enableHeat'="Y")&&(feeTypeCode="H"))
		 	set stDate=$p(typeFeeData,"^",3)
		 	set endDate=$p(typeFeeData,"^",4)
		 	if (endDate="") set endDate=(today+1)
		 	continue:((today>endDate)||(today<stDate))
	 	}
 	}
 	
	quit stDate_"#"_endDate
}

/// Creator: ZhYW
/// CreatDate: 2017-08-04
/// Description: 出院结算前或医嘱费用查询时根据账单号和就诊rowid 判断病人费用是否有问题
/// Input: episodeId:PA_Adm.RowId, billId:DHC_PatientBill.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).AdmSettlementCheck(420)
ClassMethod AdmSettlementCheck(episodeId As %String, billId As %String) As %String
{
	quit:(+episodeId=0) ""
	
	set errCode=0
	set errMsg=""
	
	set pid=..GetPID()
	
	set hospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(episodeId)
	set roleLevel=..GetLevelCfg(hospId)

	do ..GetIPBillCheckFeeData(episodeId, pid)
	set isAudit="N"   //审核标志(N为未审核)
	set rs=##class(%ResultSet).%New("web.DHCIPBillCheckAdmCost:FindCheckFee")
	do rs.Execute(episodeId, pid, isAudit, roleLevel)
	while (rs.Next()) {
		set errCode=rs.Get("TMPCRowID")   //这里故意将监控点ID作为错误代码
		set errMsg=rs.Get("TMPCDesc")_": "_rs.Get("TErrMsg")
		quit:(+errCode)
	}
	
	//判断病人账单费用是否有问题
	set (PBFeeErrNum, PBOrdFeeErrNum)=0
	if (+billId'=0) {
		set billErrStr=..AdmBillCheck(billId)
		set PBFeeErrNum=$p(billErrStr,"^",1)
		set PBOrdFeeErrNum=$p(billErrStr,"^",2)
	}else {
		set pb=""
		while($o(^DHCPB(0,"ADM",episodeId,pb),-1)) {
			set pb=$o(^DHCPB(0,"ADM",episodeId,pb),-1)
			set payedFlag=$p(^DHCPB(pb),"^",16)
			continue:(payedFlag="P")
			set billErrStr=..AdmBillCheck(pb)
			set myPBFeeErrNum=$p(billErrStr,"^",1)
			set myPBOrdFeeErrNum=$p(billErrStr,"^",2)
			set PBFeeErrNum=PBFeeErrNum+myPBFeeErrNum
			set PBOrdFeeErrNum=PBOrdFeeErrNum+PBOrdFeeErrNum
		}
	}
	
	if (errCode=0) {
		if (PBFeeErrNum'=0) {
			set errCode=-1
			set errMsg="患者账单不平不能结算"
		}elseif (PBOrdFeeErrNum'=0) {
			set errCode=-2
			set errMsg="患者医嘱账单金额不平不能结算"
		}
	}

	set rtn=errCode_$c(2)_errMsg
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2017-08-04
/// Description：判断病人的账单是否有问题
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).AdmBillCheck()
ClassMethod AdmBillCheck(pb As %String) As %String
{
	quit:(+pb=0) 0
    
	set payedFlag=$p(^DHCPB(pb),"^",16)
	quit:(payedFlag="P") 0
	
 	set pbTotalAmt=$p(^DHCPB(pb),"^",8)
 	set pbTotalAmt=$fn(pbTotalAmt,"",2)
	set pbPatShareAmt=$p(^DHCPB(pb),"^",12)
   	set pbPatShareAmt=$fn(pbPatShareAmt,"",2)

	set pbdTotalSum=0, pbdPatShareTotalSum=0
   	set PBOrdFeeErrNum=0
   	set pbo=0
   	while($o(^DHCPB(pb,"O",pbo))) {
	   	set pbo=$o(^DHCPB(pb,"O",pbo))
	   	set pboData=$g(^DHCPB(pb,"O",pbo))
	   	continue:(pboData="")
	   	set oeori=$p(pboData,"^",4)
		set pboTotalAmt=$p(pboData,"^",8)
		set pboTotalAmt=$fn(pboTotalAmt,"",2)
		set pboPatShareAmt=$p(pboData,"^",11)
		set pboPatShareAmt=$fn(pboPatShareAmt,"",2)
		set pbdSum=0, pbdPatShareSum=0
		set pbd=0
		while($o(^DHCPB(pb,"O",pbo,"D",pbd))) {
			set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd))
			set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
			continue:(pbdData="")
			set pbdTotalAmt=$p(pbdData,"^",7)
			set pbdPatShareAmt=$p(pbdData,"^",10)
			set pbdSum=pbdSum+pbdTotalAmt
			set pbdPatShareSum=pbdPatShareSum+pbdPatShareAmt
			set pbdTotalSum=pbdTotalSum+pbdTotalAmt
			set pbdPatShareTotalSum=pbdPatShareTotalSum+pbdPatShareAmt
		}
		set pbdSum=$fn(pbdSum,"",2)
		set pbdPatShareSum=$fn(pbdPatShareSum,"",2)
		if ((+pboTotalAmt'=+pbdSum)||(+pboPatShareAmt'=+pbdPatShareSum)) {
			set PBOrdFeeErrNum=$i(PBOrdFeeErrNum)
		}
	}
   
   	set pbdTotalSum=$fn(pbdTotalSum,"",2)
   	set pbdPatShareTotalSum=$fn(pbdPatShareTotalSum,"",2)
   	set PBFeeErrNum=0
	if ((+pbTotalAmt'=+pbdTotalSum)||(+pbPatShareAmt'=+pbdPatShareTotalSum)) {
		set PBFeeErrNum=1
	}
	
	//病人不平的账单^账单中不平的医嘱数量
	quit PBFeeErrNum_"^"_PBOrdFeeErrNum
}

/// Creator: ZhYW
/// CreatDate: 2022-11-14
/// Description: 获取审核级别配置
/// Input: hospId:CT_Hospital.RowId
/// Return: 审核级别
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).GetLevelCfg(2)
ClassMethod GetLevelCfg(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.PatFeeChk.SHJB", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).value
	quit $s((cfgData>1):cfgData,1:1)
}

/// Creator: ZhYW
/// CreatDate: 2023-04-23
/// Description: 是否核查床位费、级别护理费、诊查费、空调(取暖)费
/// Table: DHC_PAC_BedTypeFeeItem
/// Input: adm: PAC_Adm.RowId
/// Return: 1: 是, 0:否
/// Debug: w ##class(web.DHCIPBillCheckAdmCost).IsChkAdmBedFees(9728)
ClassMethod IsChkAdmBedFees(adm As %String) As %String
{
	set rtn=0
	set bedId=##class(BILL.IP.COM.Method).GetTransBedId(adm)
	quit:(bedId="") rtn
	set bedTypeId=$p(^PAWARD(+bedId,"BED",+$p(bedId,"||",2)),"^",2)
	quit:(bedTypeId="") rtn
	set typeFeeId=0
	while($o(^PAC("BEDTP",bedTypeId,"FEE",typeFeeId))) {
		set typeFeeId=$o(^PAC("BEDTP",bedTypeId,"FEE",typeFeeId))
		set typeFeeData=$g(^PAC("BEDTP",bedTypeId,"FEE",typeFeeId))
		continue:(typeFeeData="")
		set arcim=$p(typeFeeData,"^",2)
		continue:(arcim="")
		set rtn=1
		quit
	}
	quit rtn
}

ClassMethod MonitorPointCode()
{
	set MPCCode="01"     	 //床位费收费天数与实际住院天数是否相符
	set MPCCode="02"     	 //级别护理收费天数与实际住院天数是否相符
	set MPCCode="03"     	 //住院诊查收费天数与实际住院天数是否相符
	set MPCCode="04"     	 //空调费收费天数与实际空调开放天数是否相符
	set MPCCode="05"         //实际发药数量与收费数量是否相符
	set MPCCode="06"         //已做手术安排但是没有手术室计费, 已做手术安排但是没有麻醉科计费
	set MPCCode="07"         //需计费医嘱未停止未计费
	set MPCCode="08"		 //医嘱没有执行记录
	set MPCCode="09" 	     //数据不全的医嘱
	set MPCCode="10"     	 //医嘱账单数量小于0的医嘱
	set MPCCode="11"     	 //医嘱账单价格为0
	set MPCCode="12"     	 //医嘱每日最大数量
	set MPCCode="13"     	 //住院医保患者医嘱医保属性为空
}

}
