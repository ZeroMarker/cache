Class web.DHCOPAdmFind Extends BILL.COM.Abstract
{

/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPAdmFind","AdmQuery","2022-06-21","2022-06-24","88","绿通","","17275^239^3^2^20","0")
Query AdmQuery(stDate As %String, endDate As %String, patientId As %String, patientName As %String, admDeptId As %String, sessionStr As %String, expStr As %String) As websys.Query(ROWSPEC = "TPatientId:%String:患者ID,TPatientNo:%String:登记号,TPatName:%String:患者姓名,TSex:%String:性别,TAge:%String:年龄,TAdm:%String:就诊ID,TAdmDate:%String:就诊日期,TAdmTime:%String:就诊时间,TAdmLoc:%String:就诊科室,TAdmDoc:%String:就诊医生,TAdmReason:%String:费别,TCardNo:%String:卡号")
{
}

ClassMethod AdmQueryExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, patientId As %String, patientName As %String, admDeptId As %String, sessionStr As %String, expStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("AdmQuery")=$lb(stDate, endDate, patientId, patientName, admDeptId, sessionStr, expStr)
	if ((stDate="")||(endDate="")) quit $$$OK
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	set isPayAfterTreat=$p(expStr,"^",1)   //是否"先诊疗后付费"(1:是,0:否)
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	do ##class(BILL.Interface.Inside.Invoke).GetMultiHospCfg(hospId, "OPCharge", .mulHospAry)
	
	if ((patientId'="")||(patientName'="")) {
		kill patIdAry
		if (patientId'="") {
			set patIdAry(patientId)=""
		}elseif (patientName'="") {
			do ##class(BILL.COM.PAPatMas).GetPatientByName(patientName, .patIdAry)
		}
		set patId=0
		while($o(patIdAry(patId))) {
			set patId=$o(patIdAry(patId))
			set admType=""
			while($o(^PAPERdr(patId,"ADM",admType))'="") {
				set admType=$o(^PAPERdr(patId,"ADM",admType))
				continue:(" O E "'[(" "_admType_" "))
				set adm=0
				while($o(^PAPERdr(patId,"ADM",admType,adm))) {
					set adm=$o(^PAPERdr(patId,"ADM",admType,adm))
					do GetAdmList
				}
			}
		}
		
		quit $$$OK
	}
	
	for date=stDate:1:endDate {
		set adm=0
		while($o(^PAADMi("PAADM_AdmDate",date,adm))) {
			set adm=$o(^PAADMi("PAADM_AdmDate",date,adm))
			set admType=$p(^PAADM(adm),"^",2)
			continue:(" O E "'[(" "_admType_" "))
			do GetAdmList
		}
	}
	
	quit $$$OK
	
GetAdmList
	set visitStatus=$p($g(^PAADM(adm)),"^",20)
	quit:(visitStatus="C")
	set stayInfo=##class(web.DHCBillInterface).IGetStayStatusByEpisodeID(adm)
	set stayFlag=$p(stayInfo,"^",1)
	quit:(" 1 2 "[(" "_+stayFlag_" "))        //门诊收费界面过滤急诊留观就诊记录，留观病人必须在留观结算界面结算
	set admDeptDR=$p($g(^PAADM(adm)),"^",4)
	quit:((admDeptId'="")&&(admDeptDR'=admDeptId))
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
	if ($d(mulHospAry("JZ"))) {
		quit:('$d(mulHospAry("JZ",hospDR)))
		if ($d(mulHospAry("JZ",hospDR,"LOC"))) {
			quit:('$d(mulHospAry("JZ",hospDR,"LOC",admDeptDR)))
		}
	}else {
		quit:('$d(mulHospAry(hospDR)))
	}
	if (isPayAfterTreat=1) {
		set rtnValue=##class(BILL.OP.COM.Method).ChkGreenAndPayAfterTreatByAdm(adm)   //就诊记录是否是绿色通道、先诊疗后付费
		set payAfterTreatFlag=$p(rtnValue,"^",2)   //是否"先诊疗后付费"
		quit:(payAfterTreatFlag'=1)
	}
	set admDate=$p($g(^PAADM(adm)),"^",6)
	set admTime=$p($g(^PAADM(adm)),"^",7)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
	set admDept=$p($g(^CTLOC(admDeptDR)),"^",2)
	set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
	set papmi=$p(^PAADM(adm),"^",1)
	set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
	set cardInfo=##class(web.DHCBL.CARD.UCardRefInfo).GetDefaultCardNoByPMI(papmi)
	set cardNo=$p(cardInfo,"^",2)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set sexDR=$p($g(^PAPER(papmi,"ALL")),"^",7)
	set sex=$s((+sexDR'=0):$p($g(^CT("SEX",sexDR)),"^",2),1:"")
	set sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", sex, langId)
	set age=##class(web.DHCBillInterface).GetPapmiAge(papmi, adm)
	set admDocDR=$p($g(^PAADM(adm)),"^",9)
	set admDoc=$s((+admDocDR'=0):$p($g(^CTPCP(admDocDR,1)),"^",2),1:"")
	set admDoc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", admDoc, langId)
	set admReaDR=$p($g(^PAADM(adm,1)),"^",7)
	set admReaDesc=$s((+admReaDR'=0):$p($g(^PAC("ADMREA",admReaDR)),"^",2),1:"")
	set admReaDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", admReaDesc, langId)
	do OutputAdmList
	quit
OutputAdmList
	set Data=$lb(papmi,regNo,patName,sex,age,adm,admDate,admTime,admDept,admDoc,admReaDesc,cardNo)
	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Description: 门诊收费医嘱明细查询
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPAdmFind","GetADMOrder","3578","1","","17275^239^3^2^20")
Query GetADMOrder(AdmStr As %String, InsTypeId As %String, UnBillStr As %String, SessionStr As %String) As websys.Query(ROWSPEC = "TGroup:%String:组别,OPOrdItemDesc:%String:医嘱,OPOrdUnit:%String:单位,OPOrdPrice:%Float:单价,OPOrdQty:%String:数量,OPOrdBillSum:%Float:金额,OPOrdItemRecLoc:%String:接收科室,PrescriptionNo:%String:处方号,OrdRowId:%String:医嘱ID,OPOrdItemRecLocRID:%String:接收科室ID,OPOrdDiscPrice:%Float:折扣价格,OPOrdInsPrice:%Float:记账价格,OPOrdPatPrice:%Float:自付价格,OPOrdType:%String:医嘱类型,OPOrdInsRowId:%String:费别ID,OPOrdInsType:%String:费别,OPOrdBillFlag:%String:是否可以收费标识,OPOrdItemRowID:%String:医嘱项ID,LimitItmFlag:%String:是否可以勾选标识,GrpOEFlag:%String:组符号,OEORIDR:%String:主医嘱ID,OPLabPlacerCode:%String:检验容器,OEOrdDoctorDR:%String:开单医生ID,LabEpisodeNo:%String:处方/标本号,OPOrdPrescSum:%Float:处方金额,TPreOeoriPrescno:%String:关联医嘱处方号,ArcimInsu:%String,OPOrdBBExtCode:%String,DiscAmt:%Float:折扣金额,PayorAmt:%Float:记账金额,BillSubType:%String,InsuDicCode:%String:病种编码,InsuDicDesc:%String:病种,UnBillReason:%String:不能收费原因,IsReChged:%String:是否重收")
{
}

ClassMethod GetADMOrderExecute(ByRef qHandle As %Binary, AdmStr As %String, InsTypeId As %String, UnBillStr As %String, SessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (AdmStr="") quit $$$OK
	set ^TMP("GetADMOrder")=$lb(AdmStr, InsTypeId, UnBillStr, SessionStr)
	
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CTLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)
	set LangId=$p(SessionStr,"^",5)
	
	if (HospId="") {
		set HospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(CTLocId)
	}
	set HospCode=$s((+HospId'=0):$p($g(^CT("HOSP",HospId)),"^",1),1:"")
	
	//2020-11-16 ZhYW 取门诊系统参数配置
	set ParCfgInfo=##class(web.DHCOPConfig).ReadOPSPConfig(HospId)
	set ZeroPriceChargeFlag=$p(ParCfgInfo,"^",23)
	
	//取门诊结算费用配置
	set myRecLocStr=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(GroupId, HospId, CTLocId)
	
	set AdmCnt=$l(AdmStr,"^")
	for i=1:1:AdmCnt {
		set Adm=$p(AdmStr,"^",i)
		continue:(+Adm=0)
		set StayInfo=##class(web.DHCBillInterface).IGetStayStatusByEpisodeID(Adm)
		set StayFlag=$p(StayInfo,"^",1)
		continue:(" 1 2 "[(" "_+StayFlag_" "))     //押金模式的急诊留观需要在【急诊留观结算】界面收费
		set Order=..GetPAADMOrderRowid(Adm)
		continue:(Order="")
		do OutputOrdItmList
	}
	
	quit $$$OK
	
OutputOrdItmList
	kill ^||TMP($j)
	set RegArcimNum=0       //挂号医嘱数量
	set OPSFArcimNum=0      //门诊收费医嘱
	set Itm=0
	while($o(^OEORD(Order,"I",Itm))) {
		set Itm=$o(^OEORD(Order,"I",Itm))
		continue:('$d(^OEORD(Order,"I",Itm,1)))
		set OEORIRowid=Order_"||"_Itm
		continue:(##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(OEORIRowid)=1)    //将急诊转出到住院的医嘱退出
		set myPriorFlag=##class(web.UDHCOEORDOP1).ReadOECPriorityFlag(OEORIRowid)
		continue:(+myPriorFlag=1)      //自备药医嘱退出
		set ItemGroup=$p($g(^OEORD(+Order,"I",Itm,6)),"^",1)    //组别
		set UnBillReason=""            //不能结算原因
		set BillFlag=1                 //能否结算标识(1:能结算，0:不能结算)
		if (("^"_UnBillStr_"^")[("^"_OEORIRowid_"^")) set BillFlag=0
		set mySkinFlag=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(OEORIRowid)
		set BillFlag=$case(mySkinFlag,"Y":0,:BillFlag)   //判断皮试标志
		set myLOrdFlag=mySkinFlag     //是否可以勾选标识("Y":不能勾选，"N":可以勾选)
		set billed=$p($g(^OEORD(Order,"I",Itm,3)),"^",5)
		continue:(" P I "[(" "_billed_" "))
		set statDR=$p($g(^OEORD(Order,"I",Itm,1)),"^",13)
		set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
		continue:(" V E "'[(" "_statCode_" "))
		set RecLocDR=$p($g(^OEORD(+Order,"I",Itm,3)),"^",6)    //接收科室
		continue:((myRecLocStr'="")&&(myRecLocStr'[("^"_RecLocDR_"^")))
		set RecLocDesc=$s((RecLocDR'=""):$p($g(^CTLOC(RecLocDR)),"^",2),1:"")
		set RecLocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", RecLocDesc, LangId)
		set OrdInsTypeDR=$p($g(^OEORD(+Order,"I",Itm,11)),"^",18)     //OEORI_BBExtCode
		set OPOrdBBExtCode=$s((+OrdInsTypeDR'=0):$p($g(^PAC("ADMREA",OrdInsTypeDR)),"^",2),1:"")
		set InsTypeDR=##class(web.DHCBillCons1).GetCurrentOrdInsType(OEORIRowid, InsTypeId, HospId)
		continue:((InsTypeId'="")&&(InsTypeId'=InsTypeDR))
		set InsTypeDesc=$s((InsTypeDR'=""):$p(^PAC("ADMREA",InsTypeDR),"^",2),1:InsTypeDR)
		set InsTypeDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", InsTypeDesc, LangId)
		set ArcimRowid=$p($g(^OEORD(Order,"I",Itm,1)),"^",2)
		set ArcimDesc=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",2)
		set ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", ArcimDesc, LangId)
		set ArcimDateTo=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),7)),"^",1)   
		if ((ArcimDateTo'="")&&(ArcimDateTo<+$h)) {
			//超期医嘱不能结算
			set BillFlag=0
			set myLOrdFlag="Y"
			set UnBillReason="该医嘱项目已停用，不能结算"
		}
		set IsAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(OEORIRowid)
		if (IsAppRep="Y") {
			set PartDesc=##class(web.DHCAPPInterface).GetExaReqPartDesc(OEORIRowid)
			set ArcimDesc=ArcimDesc_PartDesc                                  //名称 + 部位
		}
		if (mySkinFlag="Y") set ArcimDesc=ArcimDesc_"(皮试)"
		set ActionDR=$p($g(^OEORD(Order,"I",Itm,11)),"^",21)	   //OEORI_Action_DR->OEC_Action 皮试备注
		set ActionDesc=$s((+ActionDR'=0):$p($g(^OEC("ACT",ActionDR)),"^",2),1:"")
		if (ActionDesc'="") set ArcimDesc=ArcimDesc_"("_ActionDesc_")"
		set DoctorDR=$p($g(^OEORD(Order,"I",Itm,1)),"^",11)		  //OEORI_Doctor_DR 开单医生ID
		set PackUOM=##class(web.DHCBillCommon).GetPackUom(ArcimRowid, OEORIRowid)
		set PackUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", PackUOM, LangId)
		set PackQty=##class(BILL.OP.COM.Method).GetOrdEffectivePackQty(OEORIRowid)
		continue:(+PackQty=0)  //过滤数量为0的记录
		set IsReChged=##class(BILL.OP.COM.Method).IsReChgedOEORI(OEORIRowid)   //是否退费后重新收费标识(1:是,0:否)
		set CostAmtStr=##class(BILL.OP.COM.Method).GetPendPayOrdItmCost(OEORIRowid, InsTypeDR, HospId)
		set TotalAmt=$p(CostAmtStr,"^",1)
		set DiscAmt=$p(CostAmtStr,"^",2)
		set PayorAmt=$p(CostAmtStr,"^",3)
		set PatAmt=$p(CostAmtStr,"^",4)
		set Price=TotalAmt/PackQty
		set Price=$fn(Price,"",6)
		continue:((+Price=0)&&(+ZeroPriceChargeFlag=0))               //2020-11-16 ZhYW 0价格医嘱不进账单时过滤
		set OrdDiscPrice=DiscAmt/PackQty
		set OrdDiscPrice=$fn(OrdDiscPrice,"",6)
		set OrdInsPrice=PayorAmt/PackQty
		set OrdInsPrice=$fn(OrdInsPrice,"",6)
		set OrdPatPrice=$fn((Price-OrdDiscPrice-OrdInsPrice),"",6)
		//
		set Prescno=$p($g(^OEORD(+Order,"I",Itm,1)),"^",14)     //处方号
		set myGrpInfo=##class(web.UDHCOEORDOPIF).ReadOEGrpFlag(OEORIRowid)
		set myGrpOEFlag=$p(myGrpInfo,"^",1)
		set myOEORIDR=$p(myGrpInfo,"^",2)
		set LabPlacerCode="", LabEpisodeNo=""
		set OrderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(ArcimRowid, 0)
		if (OrderType="L") {
			set LabPlacerCode=$$GetLabPlacerCode(OEORIRowid, HospId)
			set LabEpisodeNo=$p($g(^OEORD(+Order,"I",Itm,3)),"^",20)
		}else {
			set LabEpisodeNo=Prescno
		}
		set myOrdPrescSum=""
		if ((OrderType="R")&&(Prescno'="")) {
			if ('$d(^||TMP($j,"OPOrdPrescno",Prescno))) {
				set myOrdPrescSum=..GetOrdPrescSum(Prescno, HospId, InsTypeDR)
				set ^||TMP($j,"OPOrdPrescno",Prescno)=""
			}
			if ($g(^||TMP($j,"PrescnoSkin",Prescno))="Y") {
				set BillFlag=0
				set myLOrdFlag="Y"
			}else {
				set myPrescSkinFlag=##class(web.DHCOPAdmFind).CheckPrescnoSkinFlag(Prescno, "", "")
				if (myPrescSkinFlag="Y") {
					set BillFlag=0	             //处方上有皮试医嘱且皮试医嘱不是阴性时，该处方上的医嘱都不能缴费
					set myLOrdFlag="Y"
					set ^||TMP($j,"PrescnoSkin",Prescno)=myPrescSkinFlag
					set RtnValue=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag2(OEORIRowid)
					set UnBillReason=$p(RtnValue,"^",2)
				}
			}
		}
		set OEORIOEORIDR=$p($g(^OEORD(+Order,"I",Itm,11)),"^",39)   //OEORI_OEORI_DR
		set PreOeoriPrescno=$s((OEORIOEORIDR'=""):$p($g(^OEORD(+OEORIOEORIDR,"I",$p(OEORIOEORIDR,"||",2),1)),"^",14),1:Prescno)   //处方号
		set ArcimInsu=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(ArcimRowid, InsTypeDR, HospId, "", 7)
		set OrdDRGOrder=$p($g(^OEORD(+Order,"I",Itm,"DHC")),"^",66)		//OE_OrdItemExt.OEORI_ChronicDiagCode
		set ChronicInfo=##class(insuqc.service.ServicePort).GetChronicNameByCode(OrdDRGOrder, InsTypeDR, HospCode)
		set InsuDicCode=$p(ChronicInfo,"^",1)      //病种编码
		set InsuDicDesc=$p(ChronicInfo,"^",2)      //病种描述
		set myBillSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimRowid, HospId)   //调用医生站接口判断是否是挂号费性质医嘱
		set BillSubType=""
		if (myBillSubType'="NotRegFee") {
			set RegArcimNum=$i(RegArcimNum)                        //挂号医嘱数量
			set BillSubType=Order_"RegFee"
		}else {
			set OPSFArcimNum=$i(OPSFArcimNum)                      //门诊收费医嘱
		}
		set ^||TMP($j,"OPOrdItem",Order,Itm)=$lb(ItemGroup,ArcimDesc,PackUOM,Price,PackQty,PatAmt,RecLocDesc,Prescno,OEORIRowid,RecLocDR,OrdDiscPrice,OrdInsPrice,OrdPatPrice,OrderType,InsTypeDR,InsTypeDesc,BillFlag,ArcimRowid,myLOrdFlag,myGrpOEFlag,myOEORIDR,LabPlacerCode,DoctorDR,LabEpisodeNo,myOrdPrescSum,PreOeoriPrescno,ArcimInsu,OPOrdBBExtCode,DiscAmt,PayorAmt,BillSubType,InsuDicCode,InsuDicDesc,UnBillReason,IsReChged)
	}

	//+2018-05-31 ZhYW
	set BaseCfgStr=##class(web.UDHCOPGSConfig).ReadCFByGRowID(GroupId, HospId)
	set RegBillCfg=$p(BaseCfgStr,"^",22)
	set Itm=0
	while($o(^||TMP($j,"OPOrdItem",Order,Itm))) {
		set Itm=$o(^||TMP($j,"OPOrdItem",Order,Itm))
		set Data=$g(^||TMP($j,"OPOrdItem",Order,Itm))
		set BillFlag=$lg(Data,17)
		set ArcimRowid=$lg(Data,18)
		set myBillSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimRowid, HospId)   //调用医生站接口判断是否是挂号费性质医嘱
		if ((+RegArcimNum>0)&&(+OPSFArcimNum>0)&&(+RegBillCfg=0)&&(myBillSubType="NotRegFee")) {
			set BillFlag=0
		}
		set $li(Data,17)=BillFlag
		set ^CacheTemp(repid,ind)=Data
		set ind=$i(ind)
	}
	
	kill ^||TMP($j)
	quit
GetLabPlacerCode(oeitm, hospId)
    set retno=""
    set ord=$p(oeitm,"||",1)
    set itm=$p(oeitm,"||",2)
    quit:(ord="") retno
    quit:'$d(^OEORD(ord,"I",itm,1)) retno
    
    set arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
    quit:(arcim="") retno
    set arcSub=$p(arcim,"||",2)
    quit:(arcSub="") retno
    
	set specCode=$p($g(^OEORD(ord,"I",itm,"SPEC",1)),"^",1)
  	quit:(specCode="") retno

    set excode=""
    set chl=0
     while($o(^ARCIM(+arcim,arcSub,"EXT",chl))) {
	    set chl=$o(^ARCIM(+arcim,arcSub,"EXT",chl))
	    set chlData=$g(^ARCIM(+arcim,arcSub,"EXT",chl))
	    set tod=$p(chlData,"^",2)
		continue:((tod'="")&&(tod<+$h))
		set excode=$p(chlData,"^",4)
	}
  	quit:(excode="") retno
  	
  	set hospCode=$s((+hospId'=0):$p($g(^CT("HOSP",hospId)),"^",1),1:"")
  	set retno=##class(DHCLIS.DHCCommon).GetTSContainer(excode, specCode, hospCode)
  	//set retno=$p(retno,$c(2),2)    //ContainerCode
  	set retno=$p(retno,$c(2),3)
  	
	quit retno
}

ClassMethod GetPAADMOrderRowid(EpisodeID As %String) As %String
{
	quit $o(^OEORD(0,"Adm",+EpisodeID,""))
}

/// do ##class(%ResultSet).RunQuery("web.DHCOPAdmFind","GetOPDocUser","李一平")
Query GetOPDocUser(UserCodeName As %String = "") As websys.Query(ROWSPEC = "UserRowID:%String:用户,DocName:%String:医生姓名,DocCode:%String:工号")
{
}

ClassMethod GetOPDocUserExecute(ByRef qHandle As %Binary, UserCodeName As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (UserCodeName="") quit $$$OK
	
	//按照UserCode,模糊查询
	if (UserCodeName'="") {
		set UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(UserCodeName,"U"),""))
		if (UserId'="") {
			set myUserData=$g(^SSU("SSUSR",UserId))
			set UserName=$p(myUserData,"^",2)
			set myOPProvCode=$p(myUserData,"^",1)
			set myCareProvDR=$p(myUserData,"^",14)
			set myUserRID=UserId
			set myOPProvName=UserName
			if (myCareProvDR'=""){
				do OutputDocList
			}
		}
	}
	
	//按照UserName 模糊查询
	set myName=""
	while($o(^SSU("SSUSR",0,"SSUSR_Name",myName))'="") {
		set myName=$o(^SSU("SSUSR",0,"SSUSR_Name",myName))
		continue:(myName'[UserCodeName)
		set myUserID=0
		while($o(^SSU("SSUSR",0,"SSUSR_Name",myName,myUserID))) {
			set myUserID=$o(^SSU("SSUSR",0,"SSUSR_Name",myName,myUserID))
			set myUserData=$g(^SSU("SSUSR",myUserID))
			set myCareProvDR=$p(myUserData,"^",14)
			continue:(myCareProvDR="")
			set UserName=$p(myUserData,"^",2)
			set myOPProvCode=$p(myUserData,"^",1)
			set myUserRID=myUserID
			set myOPProvName=UserName
			do OutputDocList
		}
	}
	
	quit $$$OK

OutputDocList
	set Data=$lb(myUserRID,myOPProvName,myOPProvCode)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Description: 获取处方金额
/// Debug: w ##class(web.DHCOPAdmFind).GetOrdPrescSum()
ClassMethod GetOrdPrescSum(PrescNo As %String, HospId As %String, InsTypeId As %String = "") As %String
{
	set PrescSum=0
	quit:(PrescNo="") PrescSum

	//循环取出医嘱
	set Order=0
	while($o(^OEORD(0,"PrescNo",PrescNo,Order))) {
		set Order=$o(^OEORD(0,"PrescNo",PrescNo,Order))
		set Adm=$p(^OEORD(Order),"^",1)
		set Itm=0
		while($o(^OEORD(0,"PrescNo",PrescNo,Order,Itm))) {
			set Itm=$o(^OEORD(0,"PrescNo",PrescNo,Order,Itm))
			set OEORIRowid=Order_"||"_Itm
			set billed=$p($g(^OEORD(Order,"I",Itm,3)),"^",5)
			continue:(" P I "[(" "_billed_" "))
			set statDR=$p($g(^OEORD(Order,"I",Itm,1)),"^",13)
			set statCode=$s((statDR'=""):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
			continue:(" V E "'[(" "_statCode_" "))
			set ArcimRowid=$p($g(^OEORD(Order,"I",Itm,1)),"^",2)
			set OrderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(ArcimRowid, 0)
			continue:(OrderType'="R")
			set CostAmtStr=##class(BILL.OP.COM.Method).GetPendPayOrdItmCost(OEORIRowid, InsTypeId, HospId)
			set PatAmt=$p(CostAmtStr,"^",4)
			set PrescSum=$i(PrescSum, PatAmt)
		}
	}
	
	set PrescSum=$fn(PrescSum,"",2)
	
	quit PrescSum
}

/// Creator: Lid
/// CreatDate: 2012-04-11
/// Description: 判断处方上有没有皮试医嘱，如果有,是否为阴性
/// Input: PrescNo处方号,OEORIDR医嘱指针(暂传空),ExtStr:扩展串("^^^^^^")
/// Return: Y:没有皮试或皮试阳性，非Y:皮试阴性
/// Debug: w ##class(web.DHCOPAdmFind).CheckPrescnoSkinFlag("O12041200033","","")
ClassMethod CheckPrescnoSkinFlag(PrescNo As %String, OEORIDR As %String, ExtStr As %String = "") As %String
{
	set SkinFlag=""
	quit:(PrescNo="") SkinFlag
	
	set myOEORDDR=0
	while($o(^OEORD(0,"PrescNo",PrescNo,myOEORDDR))&&(SkinFlag'="Y")) {
		set myOEORDDR=$o(^OEORD(0,"PrescNo",PrescNo,myOEORDDR))
		set myOEORDSub=0
		while($o(^OEORD(0,"PrescNo",PrescNo,myOEORDDR,myOEORDSub))&&(SkinFlag'="Y")) {
			set myOEORDSub=$o(^OEORD(0,"PrescNo",PrescNo,myOEORDDR,myOEORDSub))
			set myOEORIDR=myOEORDDR_"||"_myOEORDSub
			set myPriorFlag=##class(web.UDHCOEORDOPIF).ReadOECPriorityFlag(myOEORIDR)
			continue:(+myPriorFlag=1)      //自备药医嘱退出
			set statDR=$p($g(^OEORD(myOEORDDR,"I",myOEORDSub,1)),"^",13)
			set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
			continue:((" V E ")'[(" "_statCode_" "))
			set SkinFlag=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(myOEORIDR)
		}
	}
	
	quit SkinFlag
}

/// Descripion: 根据根据Adm获取病人的医嘱信息
/// Debug: w ##class(web.DHCOPAdmFind).GetOeditemInfoByAdm("2^13")
ClassMethod GetOeditemInfoByAdm(admStr As %String) As %String
{
	set ordItmStr=""
	for i=1:1:$l(admStr,"^") {
		set Adm=$p(admStr,"^",i)
		continue:(+Adm=0)
		set AdmDate=$p($g(^PAADM(Adm)),"^",6)
		//continue:((AdmDate="")||(AdmDate<+$h))
		set visitStatus=$p($g(^PAADM(Adm)),"^",20)
		continue:(visitStatus'="A")
		set Ord=..GetPAADMOrderRowid(Adm)
		continue:(+Ord=0)
		set Itm=0
		while($o(^OEORD(Ord,"I",Itm))) {
			set Itm=$o(^OEORD(Ord,"I",Itm))
			continue:('$d(^OEORD(Ord,"I",Itm,1)))
			set OEORI=Ord_"||"_Itm
			set Billed=$p($g(^OEORD(Ord,"I",Itm,3)),"^",5)
			continue:(" P I "[(" "_Billed_" "))
			set OrdStat=$p($g(^OEORD(Ord,"I",Itm,1)),"^",13)
			set StatCode=$s((+OrdStat'=0):$p($g(^OEC("OSTAT",OrdStat)),"^",1),1:"")
			continue:(" V E "'[(" "_StatCode_" "))			
			set ordItmStr=$s((ordItmStr=""):OEORI,1:(ordItmStr_"^"_OEORI))
		}
	}
	quit:(ordItmStr="") ""
	
	set rtn=##class(web.DHCENS.EnsHISService).GetAmountOfTube(ordItmStr)
	quit +rtn
}

}
