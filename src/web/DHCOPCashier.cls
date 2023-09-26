Class web.DHCOPCashier Extends BILL.COM.Abstract
{

/// 门诊收费大类显示栏数
Parameter CATECOLNUM [ Final ] = 4;

/// Description: 门诊收费员插入医嘱接口
/// Input: Adm: PA_Adm.RowId, OrdItemStr: 医嘱项Id^数量^接收科室Id^单价^单位Id^费别Id$c(1)..., User:SS_User.RowId, Loc:登录科室Id(CT_Loc.RowId), DocUserId:就诊医生(CT_CareProv.RowId)
/// Return: 
/// Debug: w ##class(web.DHCOPCashier).CashierInsertOrdItem("2121","2086||1^1^181^1.840000^18^4^","17275","3","1608","")
ClassMethod CashierInsertOrdItem(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, DocUserId As %String, OSRID As %String = "") As %Status
{
	set ^TMP("CashierInsertOrdItem")=$lb(Adm, OrdItemStr, User, Loc, DocUserId, OSRID)
	set Ret=0, CMRet=0
	set CurrDate=+$h, CurrTime=$p($h,",",2)
	set HospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(Loc)
	
	//区分草药医嘱及非草药医嘱
	set OrdStr="", CMOrdStr=""
	set Count=$l(OrdItemStr,$c(1))
	for ind=1:1:Count {
		set OrdItem=$p(OrdItemStr,$c(1),ind)
		continue:(+OrdItem=0)
		set OrderARCIMRowid=$p(OrdItem,"^",1)	   //医嘱项指针(ARC_ItmMast)
		set ItemCatDR=$p(^ARCIM($p(OrderARCIMRowid,"||",1),$p(OrderARCIMRowid,"||",2),1),"^",10)
		set OrderType=$p(^ARC("IC",ItemCatDR),"^",7)	            //医嘱项类型代码(ARC_ItemCat->ARCIC_OrderType)	各级医嘱项取
		set PriorityCode=$$ALPHAUP^SSUTIL4("NORM")
		set OrderPriorRowid=$o(^OECPR(0,"Code",PriorityCode,0))	   //医嘱优先级(OEC_Priority)
		
		//判断是否是草药医嘱
		set IsHerbFlag=..IsHerb(OrderARCIMRowid, HospId)
		if (IsHerbFlag=1) {
			//草药
			//处方信息串
			set PrescDurRowid=""	                    //疗程指针(PHC_Duration),指的草药副数
			set PrescInstrRowid=""	                    //用法指针(PHC_Instruc),指的草药使用方式
			set PrescFreqRowid=""	                    //频次指针(PHC_Freq)
			set PrescCookMode=""	                    //煎药方式(01 自煎, 02 代煎),传01或02
			set PrescOrderQty=""	                    //一次用量
			set OrderRecDepRowid=$p(OrdItem,"^",3)	    //接收科室指针(CT_Loc)
			set OrderBillTypeRowid=$p(OrdItem,"^",6)	//费别指针(PAC_AdmReason)
			set PrescNotes=""	     //备注
			set PrescEmergency=""	 //加急
			set PrescStartDate=$zd(CurrDate,4)	     //开始日期
			set PrescStartTime=$zt(CurrTime,1)	     //开始时间
			set ARCOSRowId=$p(OrdItem,"^",7)	     //医嘱套(ARC_OrdSets)
			set OrderBindSource=$p(OrdItem,"^",11)   //绑定来源
			set PrescWeight=""
			set AddLongOrder=""
			set CMPrescTypeCode=""                 //草药处方类型
			
			//医嘱信息串
			set OrderARCIMRowid=OrderARCIMRowid	      //医嘱项指针(ARC_ItmMast)
			set OrderDoseQty=$p(OrdItem,"^",2)	      //单次剂量
			set OrderDoseUOMRowid=$p(OrdItem,"^",5)   //单次剂量单位
			set OrderPhSpecInstr=""	  //草药用法备注
			set Phcdf=$p($g(^ARCIM(+OrderARCIMRowid,$P(OrderARCIMRowid,"||",2),1)),"^",12)
			set billuomDr=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
			set ConFac=##class(PHA.FACE.OUT.Com).UOMFac(OrderDoseUOMRowid, billuomDr)
			set SumQty=OrderDoseQty*ConFac
			set INCIPackCombStr=##class(web.DHCDocOrderEntryCM).CheckINCIPackSum(Adm, OrderARCIMRowid, OrderRecDepRowid, SumQty)
			set INCIPackCombStr=$p(INCIPackCombStr,$c(2),2)
			//处方信息
			set CFStr=OrderPriorRowid_"^"_PrescDurRowid_"^"_PrescInstrRowid_"^"_PrescFreqRowid_"^"_PrescCookMode	   ;1--5
			set CFStr=CFStr_"^"_PrescOrderQty_"^"_OrderRecDepRowid_"^"_OrderBillTypeRowid_"^"_PrescNotes_"^"_PrescEmergency   ;6--10
			set CFStr=CFStr_"^"_PrescStartDate_"^"_PrescStartTime_"^"_ARCOSRowId_"^"_PrescWeight_"^"_AddLongOrder       ;11--15
			set CFStr=CFStr_"^"_CMPrescTypeCode    //16
			
			//医嘱信息
			set SingleOrderItemStr=OrderARCIMRowid_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid_"^"_OrderPhSpecInstr_"^^^"_INCIPackCombStr
			set $p(SingleOrderItemStr,"^",14)=OrderBindSource
			
			if (CMOrdStr="") {
				set CMOrdStr=CFStr_$c(2)_SingleOrderItemStr
			}else {
				set CMOrdStr=CMOrdStr_$c(1)_SingleOrderItemStr
			}
		}else {
			//非草药
			set OrderStartDate=$zd(CurrDate,4)	    //开始日期(格式: DD/MM/YYYY)	计费界面录入的医嘱日期默认当前日期
			set OrderStartTime=$zt(CurrTime,1)	    //开始时间(格式: HH:MM)	计费界面录入的医嘱日期默认当前时间
			set OrderPackQty=$p(OrdItem,"^",2)	    //医嘱数量
			set OrderRecDepRowid=$p(OrdItem,"^",3)	//接收科室指针(CT_Loc)
			set OrderPrice=$p(OrdItem,"^",4)	    //自定义价格
			set OrderPackUOMRowid=$p(OrdItem,"^",5)	//协议包装单位
			set BillTypeRowid=$p(OrdItem,"^",6)	    //费别指针(PAC_AdmReason)
			set OrderDrugFormRowid=""	            //药学关联指针(PHC_DrgForm)
			set OrderDepProcNotes=""	            //备注
			set OrderDoseQty=$p(OrdItem,"^",12)	        //单次剂量
			set OrderDoseUOMRowid=$p(OrdItem,"^",13)	//单次剂量单位
			set OrderQtySum=$p(OrdItem,"^",14)	        //基本单位总数量
			set OrderFreqRowid=""	    //频次指针(PHC_Freq)	
			set OrderDurRowid=""	    //疗程指针(PHC_Duration)	
			set OrderInstrRowid=""	    //用法指针(PHC_Instruc)	
			set PHPrescType=""	        //处方类型	
			set OrderMasterSeqNo=""	    //关联的主医嘱序号，数字型	
			set OrderSeqNo=ind	        //医嘱序号，数字型，根据OrderItemStr以$c(1)分割的顺序从1开始累加	计费组默认顺序号
			set OrderSkinTest=""	    //是否皮试(Y/N)
			set OrderPhSpecInstr=""	    //草药用法备注	
			set OrderCoverMainIns=""	//是否医保	
			set OrderActionRowid=""	    //皮试备注	
			set OrderARCOSRowid=$p(OrdItem,"^",7)	 //医嘱套(ARC_OrdSets)
			set OrderBindSource=$p(OrdItem,"^",11)   //绑定来源
			set OrderEndDate=""	        //预停日期(格式: DD/MM/YYYY)
			set OrderEndTime=""	        //预停时间(格式: HH:MM)
			set SpecDesc=##class(web.DHCDocOrderCommon).GetLabSpec(OrderARCIMRowid)
			set SpecDesc=$p(SpecDesc,$c(3),1)
			set OrderLabSpecRowid=SpecDesc	  //标本指针(LAB.CT_TestSetSpecimen-> CTTSS_Specimen_DR)	
		 	set SingleOrderItemStr=OrderARCIMRowid_"^"_OrderType_"^"_OrderPriorRowid_"^"_OrderStartDate_"^"_OrderStartTime	;1--5
		 	set SingleOrderItemStr=SingleOrderItemStr_"^"_OrderPackQty_"^"_OrderPrice_"^"_OrderRecDepRowid_"^"_BillTypeRowid_"^"_OrderDrugFormRowid	;6--10
		 	set SingleOrderItemStr=SingleOrderItemStr_"^"_OrderDepProcNotes_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid_"^"_OrderQtySum_"^"_OrderFreqRowid ;11-15
		 	set SingleOrderItemStr=SingleOrderItemStr_"^"_OrderDurRowid_"^"_OrderInstrRowid_"^"_PHPrescType_"^"_OrderMasterSeqNo_"^"_OrderSeqNo ;16--20
		 	set SingleOrderItemStr=SingleOrderItemStr_"^"_OrderSkinTest_"^"_OrderPhSpecInstr_"^"_OrderCoverMainIns_"^"_OrderActionRowid_"^"_OrderARCOSRowid ;21--25
		 	set SingleOrderItemStr=SingleOrderItemStr_"^"_OrderEndDate_"^"_OrderEndTime_"^"_OrderLabSpecRowid ;26--28
			set $p(SingleOrderItemStr,"^",55)=OrderPackUOMRowid
			set $p(SingleOrderItemStr,"^",58)=OrderBindSource
			
			set OrdStr=$s((OrdStr=""):SingleOrderItemStr,1:(OrdStr_$c(1)_SingleOrderItemStr))
		}
	}

	if (OrdStr'=""){
		set Ret=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.ord.SaveOrderItems", Adm, OrdStr, User, Loc, DocUserId)
	}
	if (CMOrdStr'=""){
		set CMRet=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.ord.SaveOrderItemsCM", Adm, CMOrdStr, User, Loc, DocUserId)
	}

	//此处分返回值怎么控制？？？待讨论！！
	if ((Ret'=100)&&(CMRet=100)) {
		set Ret=Ret
	}
	if ((Ret=100)&&(CMRet'=100)) {
		set Ret=CMRet
	}
	if ((Ret'=100)&&(CMRet'=100)) {
		set Ret=Ret_"^"_CMRet
	}
	
	quit Ret
}

/// Description: 根据医嘱项rowid判断是否草药
/// Return: 1:是草药，0:不是草药
/// Debug: w ##class(web.DHCOPCashier).IsHerb("5245||1",2)
ClassMethod IsHerb(Arcim As %String, HospId As %String) As %String
{
	quit ##class(web.DHCDocOrderCommon).IsCNMedItem(Arcim, HospId)
}

/// 判断库存
ClassMethod CheckStockEnough(Arcim As %String, PackQty As %String, RecLoc As %String, ExpStr As %String = "") As %Status
{
	quit ##class(web.DHCDocOrderCommon).CheckStockEnough(Arcim, PackQty, RecLoc, "", ExpStr)
}

/// Debug: w ##class(web.DHCOPCashier).CreatePrescNo()
ClassMethod CreatePrescNo(Adm As %String, UserID As %String, ExpStr As %String = "") As %Status
{
	do ##class(DHCDoc.Interface.Inside.ServiceOrd).GenPresno(Adm, UserID, ExpStr)
}

/// Debug: w ##class(web.DHCOPCashier).FormatPatientNo()
ClassMethod FormatPatientNo(PAPMINo As %String) As %String
{
	quit ##class(web.UDHCJFBaseCommon).regnocon(PAPMINo)
}

/// Debug: w ##class(web.DHCOPCashier).GetAdmDetail("1765^1761^1760", "2^")
ClassMethod GetAdmDetail(AdmStr As %String, ExpStr As %String = "") As %String
{
	set ^TMP("GetAdmDetail")=$lb(AdmStr, ExpStr)
	set HospId=$p(ExpStr,"^",1)
	set AdmDetailStr=""
	quit:(AdmStr="") AdmDetailStr
	
	set AdmCount=$L(AdmStr,"^")
	for i=1:1:AdmCount {
		set Adm=$p(AdmStr,"^",i)
		continue:(+Adm=0)
		set AdmDate=$p($g(^PAADM(Adm)),"^",6)
	 	set AdmDateDesc=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
	 	set AdmDept=$p($g(^PAADM(Adm)),"^",4)
	 	set AdmDeptDesc=$p($g(^CTLOC(AdmDept)),"^",2)
	 	set AdmDoc=$p($g(^PAADM(Adm)),"^",9)
	 	set myHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmDept)
	 	continue:((HospId'="")&&(HospId'=myHospDR))
	 	set AdmDocName=$s((AdmDoc'=""):$p($g(^CTPCP(AdmDoc,1)),"^",2),1:"")
	 	set AdmDocDept=AdmDeptDesc_AdmDocName
	 	set MRADM=$p($g(^PAADM(Adm)),"^",61)
	 	set PAPMI=$p($g(^PAADM(Adm)),"^",1)
	 	set AdmReason=$p($g(^PAADM(Adm,1)),"^",7)
	 	if (AdmReason="") set AdmReason=..GetInsTypeFromPat(PAPMI)
	 	set admSource=+$p(^PAC("ADMREA",AdmReason),"^",9)    //大于0，为医保病人
	 	set admSource=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(Adm)
	 	if ($p(admSource,"!",1)=1)&&($p(admSource,"^",12)="A") set AdmDocDept="(医)"_AdmDocDept
	 	set AdmDetail=AdmDocDept_"^"_Adm_"^"_MRADM_"^"_AdmDateDesc_"^"_AdmDept_"^"_AdmDoc_"^"_AdmDocName_"^"_AdmReason
	 	set AdmBillSum=..GetToBillSum(Adm, HospId)
	 	set AdmDetail=AdmDetail_"^"_$p(AdmBillSum,"^",1)_"^"_$p(AdmBillSum,"^",4)
		set AdmDetailStr=$s((AdmDetailStr=""):AdmDetail,1:(AdmDetailStr_$c(2)_AdmDetail))
	}
 	
 	quit AdmDetailStr
}

/// w ##class(web.DHCOPCashier).GetAdmInsCost()
ClassMethod GetAdmInsCost(Adm As %String, InsType As %String, OrdItemStr As %String) As %String
{
	set ToBillSum=0
	set ToBillPatSum=0
	set ToBillDiscSum=0
	set ToBillInsSum=0
	set HospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)

	set Ord=##class(web.DHCOPAdmFind).GetPAADMOrderRowid(Adm)
	quit:(Ord="") $fn(ToBillSum,"",2)_"^"_$fn(ToBillDiscSum,"",2)_"^"_$fn(ToBillInsSum,"",2)_"^"_$fn(ToBillPatSum,"",2)
	
	set Itm=0
	while($o(^OEORD(Ord,"I",Itm))) {
		set Itm=$o(^OEORD(Ord,"I",Itm))
		continue:('$d(^OEORD(Ord,"I",Itm,1)))
		set OEORI=Ord_"||"_Itm
		continue:((OrdItemStr'="")&&(OrdItemStr[("^"_OEORI_"^")))
		set billed=$p($g(^OEORD(Ord,"I",Itm,3)),"^",5)
		continue:(" P I "[(" "_billed_" "))
		continue:(##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(OEORI)=1)  //将转出的医嘱退出
		set StatDR=$p($g(^OEORD(Ord,"I",Itm,1)),"^",13)
		set StatCode=$s((+StatDR'=0):$p($g(^OEC("OSTAT",StatDR)),"^",1),1:"")
		continue:(" V E "'[(" "_StatCode_" "))
		set InsTypeDR=##class(web.DHCBillCons1).GetCurrentOrdInsType(OEORI, InsType, HospId)
		continue:((InsType'="")&&(InsTypeDR'=InsType))
		set mySkinFlag=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(OEORI)
		continue:(mySkinFlag="Y")				//限制医嘱不计费
		set OEORICost=..GetOrderItemDetail(OEORI, InsTypeDR, HospId)
		set OEORISum=$p(OEORICost,"^",1)
		set OEORIDiscSum=$p(OEORICost,"^",2)
		set OEORIInsSum=$p(OEORICost,"^",3)
		set OEORIPatSum=$p(OEORICost,"^",4)
		set ToBillSum=$i(ToBillSum, OEORISum)
		set ToBillInsSum=$i(ToBillInsSum, OEORIDiscSum)
		set ToBillDiscSum=$i(ToBillDiscSum, OEORIDiscSum)
		set ToBillPatSum=$i(ToBillPatSum, OEORIPatSum)
	}
	
	quit $fn(ToBillSum,"",2)_"^"_$fn(ToBillDiscSum,"",2)_"^"_$fn(ToBillInsSum,"",2)_"^"_$fn(ToBillPatSum,"",2)
}

ClassMethod GetInsTypeFromPat(PatientId As %String) As %String
{
	set PatSocialStatus=$P(^PAPER(PatientId,"PER",1),"^",10)
	quit:(PatSocialStatus="") ""
	set PToAdm=$o(^DHCPACADM(0,"Social",PatSocialStatus,0))
	quit:(PToAdm="") ""
	set PatInsType=$p(^DHCPACADM(PToAdm),"^",2)
	quit PatInsType
}

ClassMethod GetOPAdmBillSumBroker(AdmStr As %String) As %String
{
	set TotalSum=0
	set AdmCount=$l(AdmStr,"^")
	for i=1:1:AdmCount {
		set Adm=$p(AdmStr,"^",i)
		continue:(Adm="")
		set AdmBillSum=..GetToBillSum(Adm)
		set ToBillSum=$p(AdmBillSum,"^",1)
		set TotalSum=$i(TotalSum, ToBillSum)
	}
	quit TotalSum
}

ClassMethod GetOrderItemDetail(OEORI As %String, InsTypeId As %String, HospId As %String) As %String
{
	set TotalAmt=0
	set DiscAmt=0
	set PayorAmt=0
	set PatAmt=0
	
	set Ord=+OEORI
	set Itm=$p(OEORI,"||",2)
	set ARCIM=$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	quit:(ARCIM="") $fn(TotalAmt,"",2)_"^"_$fn(DiscAmt,"",2)_"^"_$fn(PayorAmt,"",2)_"^"_$fn(PatAmt,"",2)
	
	set PackQty=##class(BILL.OP.COM.Method).GetOrdEffectivePackQty(OEORI)
	if (+PackQty=0) {
		quit $fn(TotalAmt,"",2)_"^"_$fn(DiscAmt,"",2)_"^"_$fn(PayorAmt,"",2)_"^"_$fn(PatAmt,"",2)
	}
	
	//2020-11-16 ZhYW 取门诊系统参数配置
	set ParCfgInfo=##class(web.DHCOPConfig).ReadOPSPConfig(HospId)
	set ZeroPriceChargeFlag=$p(ParCfgInfo,"^",23)
		
	set CostAmtStr=##class(BILL.OP.COM.Method).GetPendPayOrdItmCost(OEORI, InsTypeId, HospId)
	set TotalAmt=$p(CostAmtStr,"^",1)
	set Price=TotalAmt/PackQty
	if (+Price=0) {
		set isZeroPriceOrd=##class(BILL.OP.COM.Method).IsZeroPriceOrd(OEORI, HospId)
		if ((+ZeroPriceChargeFlag=0)&&(isZeroPriceOrd=1)) {
			do ##class(web.DHCOPCashier1).UpdateOeoriBilled(OEORI, "P")
		}
	}
	set DiscAmt=$p(CostAmtStr,"^",2)
	set PayorAmt=$p(CostAmtStr,"^",3)
	set PatAmt=$p(CostAmtStr,"^",4)
	
	quit TotalAmt_"^"_DiscAmt_"^"_PayorAmt_"^"_PatAmt
}

ClassMethod GetPAPMIByNo(PAPMINo As %String) As %String
{
	set PAPMI=""
	set PAPMINo=##class(web.UDHCJFBaseCommon).regnocon(PAPMINo)
	quit:(PAPMINo="") PAPMI
	set PAPMI=$o(^PAPERi("PAPMI_PatNo",PAPMINo,""))
	quit PAPMI
}

/// Debug: w ##class(web.DHCOPCashier).GetPatPrescTypeList("138","1127","")
ClassMethod GetPatPrescTypeList(PatientId As %String, AdmStr As %String = "", SessionStr As %String = "") As %String
{
	set ^TMP("GetPatPrescTypeList")=$lb(PatientId, AdmStr, SessionStr)
	
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CTLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)
	
	set PrescList=""
	quit:((PatientId="")&&(AdmStr="")) PrescList
	
	if (AdmStr'="") {
		kill tmpList
		set defautInsType=""
		set count=$l(AdmStr,"^")
		for i=1:1:count {
			set adm=$p(AdmStr,"^",i)
			continue:(+adm=0)
			set billTypeID=$p($g(^PAADM(adm,1)),"^",7)
			//调用医生站组的接口
			//ID!Code!Desc!可录入医嘱子类!费别ID!限制金额!可开数量!默认标志
			//set value=PrescTypeRowid_"!"_PrescTypeCode_"!"_PrescTypeDesc_"!"_PrescItemCat_"!"_PrescBillTypeRowid_"!"_PrescLimitSum_"!"_PrescLimitCount_"!"_PrescTypeDefault
			set prescTypes=##class(web.DHCPAADMPrescType).GetPrescTypeByPAADM("O", billTypeID, HospId)
			for k=1:1:$l(prescTypes,"||") {
				set presType=$p(prescTypes,"||",k)
				set admReaDR=$p(presType,"!",5)
				continue:(+admReaDR=0)
				set isDefault=$p(presType,"!",8)
				if ((defautInsType="")&&(isDefault="Y")) {
					set defautInsType=admReaDR      //多个Adm时有多个默认费别，我们取第一个就诊的默认费别
				}
				set insTypeName=$p(^PAC("ADMREA",admReaDR),"^",2)
				set admSource=$p(^PAC("ADMREA",admReaDR),"^",9)		//REA_AdmSource
				set tmpList(admReaDR)=insTypeName_"^"_admReaDR_"^"_defautInsType_"^"_admSource
			}
		}
		
		set PrescList=""
		set insTypeDR=""
		while($o(tmpList(insTypeDR))) {
			set insTypeDR=$o(tmpList(insTypeDR))
			set tmpStr=tmpList(insTypeDR)
			set PrescList=$s((PrescList=""):tmpStr,1:(PrescList_$c(2)_tmpStr))
		}
	}else{
		set PrescList=..GetPatPrescTypeListByPAPMI(PatientId, SessionStr)
	}
	
	//Lid 2015-01-15 追加科研用药费别
	set myExpStr="O"
	set PilotAdm=##class(web.DHCBillPilot).GetPilotInsuType(PatientId, myExpStr)
	set IsPilotFlag=$p(PilotAdm,"!",1)
	if (+IsPilotFlag=1) {
		set PrescTypeInsCode="KYYY"
		set PrescTypeInsCode=$$ALPHAUP^SSUTIL4(PrescTypeInsCode)
		set PrescTypeIns=$o(^PAC("ADMREA",0,"Code",PrescTypeInsCode,0))
		set InsTypeName=$p(^PAC("ADMREA",PrescTypeIns),"^",2)
		set myYBFlag=$p(^PAC("ADMREA",PrescTypeIns),"^",9)		//REA_AdmSource
		set DefPatInsType=""
		set tmpStr=InsTypeName_"^"_PrescTypeIns_"^"_DefPatInsType_"^"_myYBFlag
		set PrescList=$s((PrescList=""):tmpStr,1:(PrescList_$c(2)_tmpStr))
	}
	
	quit PrescList
}

/// Debug: w ##class(web.DHCOPCashier).GetPatPrescTypeListByPAPMI("38","122^49^2")
ClassMethod GetPatPrescTypeListByPAPMI(PatientId As %String, SessionStr As %String) As %String
{
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CTLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)
	
	set PrescList=""
	quit:(PatientId="") PrescList
	
	set PatSocialStatus=$p($g(^PAPER(PatientId,"PER",1)),"^",10)
	set DefPatInsType=""
	if (PatSocialStatus'="") {
		set GroupHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_PACADM", HospId)
		set PToAdm=0
		while($o(^DHCPACADM(0,"Social",PatSocialStatus,PToAdm))) {
			set PToAdm=$o(^DHCPACADM(0,"Social",PatSocialStatus,PToAdm))
			set myInsType=$p($g(^DHCPACADM(PToAdm)),"^",2)
			continue:(myInsType="")
			set myHospDR=$p($g(^DHCPACADM(PToAdm)),"^",5)
			continue:(myHospDR'=GroupHospId)
			set DefPatInsType=$p($g(^DHCPACADM(PToAdm)),"^",2)
			set PatInsType(myInsType)=1
		}
	}else {
		set DefInsType=##class(web.DHCBillCons).ReadDefInsType(HospId)
		if (DefInsType'="") set PatInsType(DefInsType)=1
	}
	quit:('$d(PatInsType)) PrescList
	
	set GroupHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_PAADMPrescType", HospId)

	set InsTypeList=""
	set InsToPresc=0
	while($o(^DHCPAADMPrescType(0,"PAADMType","O",InsToPresc))) {
		set InsToPresc=$o(^DHCPAADMPrescType(0,"PAADMType","O",InsToPresc))
		set InsToPresData=$g(^DHCPAADMPrescType(InsToPresc))
		set InsType=$p(InsToPresData,"^",2)
		continue:(InsType="")
		continue:('$d(PatInsType(InsType)))
		set PrescTypeHospDR=$p(InsToPresData,"^",5)
		continue:(PrescTypeHospDR'=GroupHospId)
		set PrescType=$p(InsToPresData,"^",3)
		set PrescTypeIns=$p(^DHCPrescriptType(PrescType),"^",9)
		continue:(("^"_InsTypeList_"^")[("^"_PrescTypeIns_"^"))
		set InsTypeList=$s((InsTypeList=""):PrescTypeIns,1:(InsTypeList_"^"_PrescTypeIns))
		set InsTypeName=$p(^PAC("ADMREA",PrescTypeIns),"^",2)
		set myYBFlag=$p(^PAC("ADMREA",PrescTypeIns),"^",9)		 //REA_AdmSource
		set tmpStr=InsTypeName_"^"_PrescTypeIns_"^"_DefPatInsType_"^"_myYBFlag
		set PrescList=$s((PrescList=""):tmpStr,1:(PrescList_$c(2)_tmpStr))
	}

	quit PrescList
}

/// w ##class(web.DHCOPCashier).GetPatientByRowId(2253)
ClassMethod GetPatientByRowId(PAPMI As %String, ExpStr As %String) As %String
{
	set HospId=$p(ExpStr,"^",1)
	
 	set PAPMINo=$p($g(^PAPER(PAPMI,"PAT",1)),"^",1)
 	set PatientName=$p($g(^PAPER(PAPMI,"ALL")),"^",1)
 	set PatientDOB=$p($g(^PAPER(PAPMI,"ALL")),"^",6)
 	set PatientDOB=##class(websys.Conversions).DateLogicalToHtml(PatientDOB)
 	
 	set SexDR=$p($g(^PAPER(PAPMI,"ALL")),"^",7)
 	set Sex=$s((+SexDR'=0):$p($g(^CT("SEX",SexDR)),"^",2),1:"")
 	
 	set PatSocialStausDR=$p($g(^PAPER(PAPMI,"PER",1)),"^",10)
 	set PatType=$s((+PatSocialStausDR'=0):$p($g(^CT("SS",PatSocialStausDR)),"^",2),1:"")
 	
 	set PatientCompany=$g(^PAPER(PAPMI,"PER","ADD",1))
 	set PatientComAdd=$p($g(^PAPER(PAPMI,"PER",4)),"^",18)
 	set EmployeeNO=$P($g(^PAPER(PAPMI,"EMP")),"^",5)
 	set PatientMaritalDr=$p($g(^PAPER(PAPMI,"PER",2)),"^",3)
 	set PatientMarital=$s((+PatientMaritalDr'=0):$p($g(^CT("MAR",PatientMaritalDr)),"^",2),1:"")
 	set PatCategoryRowid=$p($g(^PAPER(PAPMI,"PAT",1)),"^",8)
 	set MrNo=""
 	
 	set AgeYear=""
 	set AgeMonth=""
 	set AgeDay=""
 	set AgeDesc=##class(web.DHCBillInterface).GetPapmiAge(PAPMI, "", HospId)

 	set MyAcc=""
 	set AccBal=0
 	set AccDr=0
 	while($o(^DHCACDi("AccM",0,"PAPMI",PAPMI,AccDr))&&(MyAcc="")) {
	 	set AccDr=$o(^DHCACDi("AccM",0,"PAPMI",PAPMI,AccDr))
	 	set Stat=$p(^DHCACD("AccM",AccDr),"^",13)
 		continue:(Stat'="N")
 		set MyAcc=AccDr
 		set AccBal=$p(^DHCACD("AccM",AccDr),"^",8)
	}
	set AccBal=$fn(AccBal,"",2)

	set QFTotal=##class(web.DHCOPQFPat).GetQFTotal(PAPMI, HospId)      //add  by zhl  取病人当前欠费消费金额
 
 	//add by wangjian 2015-01-15 增加病人密级和级别
    set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PAPMI, "")
    set EncryptLevel=$p(PatEncryptLevel,"^",1)
    set PatLevel=$p(PatEncryptLevel,"^",2)
 	
 	set rtn=PAPMI_"^"_PAPMINo_"^"_PatientName_"^"_Sex_"^"_AgeDesc_"^"_PatientDOB_"^"_PatType
 	set rtn=rtn_"^"_PatSocialStausDR_"^"_SexDR_"^"_PatientDOB_"^"_PatientCompany_"^"_AgeYear
 	set rtn=rtn_"^"_AgeMonth_"^"_AgeDay_"^"_PatientComAdd_"^"_EmployeeNO_"^"_PatientMarital_"^"_PatCategoryRowid
 	set rtn=rtn_"^"_MrNo_"^"_MyAcc_"^"_AccBal_"^"_QFTotal_"^"_EncryptLevel_"^"_PatLevel
 	
 	quit rtn
}

ClassMethod GetToBillSum(PAADM As %String, HospId As %String = "") As %String
{
	set ToBillSum=0
	set ToBillPatSum=0
	set ToBillDiscSum=0
	set ToBillInsSum=0
	
	set Ord=##class(web.DHCOPAdmFind).GetPAADMOrderRowid(PAADM)
	quit:(Ord="") $fn(ToBillSum,"",2)_"^"_$fn(ToBillDiscSum,"",2)_"^"_$fn(ToBillInsSum,"",2)_"^"_$fn(ToBillPatSum,"",2)

	if (HospId="") {
		set HospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADM)
	}
	
	set Itm=0
	while($o(^OEORD(Ord,"I",Itm))) {
		set Itm=$o(^OEORD(Ord,"I",Itm))
		set OEORI=Ord_"||"_Itm
		set billed=$p($g(^OEORD(Ord,"I",Itm,3)),"^",5)
		continue:(" P I "[(" "_billed_" "))
		set statDR=$p($g(^OEORD(Ord,"I",Itm,1)),"^",13)
		set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
		continue:((" V E ")'[(" "_statCode_" "))
		set mySkinFlag=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(OEORI)
		continue:(mySkinFlag="Y")				//限制医嘱不计费
		set InsTypeDR=$p($g(^OEORD(Ord,"I",Itm,11)),"^",18)
		set OEORICost=..GetOrderItemDetail(OEORI, InsTypeDR, HospId)
		set OEORISum=$p(OEORICost,"^",1)
		set OEORIDiscSum=$p(OEORICost,"^",2)
		set OEORIInsSum=$p(OEORICost,"^",3)
		set OEORIPatSum=$p(OEORICost,"^",4)
		set ToBillSum=$i(ToBillSum, OEORISum)
		set ToBillInsSum=$i(ToBillInsSum, OEORIDiscSum)
		set ToBillDiscSum=$i(ToBillDiscSum, OEORIDiscSum)
		set ToBillPatSum=$i(ToBillPatSum, OEORIPatSum)
	}
	
	quit $fn(ToBillSum,"",2)_"^"_$fn(ToBillDiscSum,"",2)_"^"_$fn(ToBillInsSum,"",2)_"^"_$fn(ToBillPatSum,"",2)
}

ClassMethod ReturnItemStock(OEORI As %String) As %String
{
	set Ret=0
	set Config=##class(websys.Configuration).%OpenId(1)
	set MEDDATA=Config.DataNamespace
	set Template=Config.PathToReports
	set CurrentNS=$ZNSPACE
	zn MEDDATA
	set PharmStatus=$$phstat^DHCOrdItem(OEORI)
	if (PharmStatus="P") {
		set Ret=$$collect^DHCOrdItem(OEORI)
		set Ret=$$returnal^DHCOrdItem(OEORI)
	}
	zn CurrentNS
	quit Ret
}

/// Description: 挂号时插入医嘱
/// Debug: w ##class(web.DHCOPCashier).Insert(1238, 2)
ClassMethod Insert(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, DocUserId As %String, OSRID As %String) As %String
{
	set RtnValue=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.ord.SaveOrderItems", Adm, OrdItemStr, User, Loc, DocUserId)	
	quit RtnValue
}

/// Debug: w ##class(web.DHCOPCashier).GetSkinRtnFlag("3789", "2")
ClassMethod GetSkinRtnFlag(AdmStr As %String, HospId As %String) As %String
{
	set ^TMP("GetSkinRtnFlag")=$lb(AdmStr, HospId)
	set SkinRtnFlag="N", SkinRtnDesc=""
	quit:(AdmStr="") $$GetRtn(SkinRtnFlag, SkinRtnDesc)
	
	set myCfgInfo=##class(web.DHCOPConfig).ReadOPSPConfig(HospId)
	set myOESkinRtnFlag=$p(myCfgInfo,"^",29)     //OPFC_OESkinRtnFlag
	quit:(+myOESkinRtnFlag'=1) $$GetRtn(SkinRtnFlag, SkinRtnDesc)
	
	set count=$l(AdmStr,"^")
	for i=1:1:count {
		set Adm=$p(AdmStr,"^",i)
		continue:(+Adm=0)
		set Ord=##class(web.DHCOPAdmFind).GetPAADMOrderRowid(Adm)
		continue:(+Ord=0)
		set Itm=0
		while($o(^OEORD(Ord,"I",Itm))) {
			set Itm=$o(^OEORD(Ord,"I",Itm))
			continue:('$d(^OEORD(Ord,"I",Itm,1)))
			set OEORI=Ord_"||"_Itm
			set billed=$p($g(^OEORD(Ord,"I",Itm,3)),"^",5)
			continue:(" P I "[(" "_billed_" "))
			set StatDR=$p($g(^OEORD(Ord,"I",Itm,1)),"^",13)
			set StatCode=$s((+StatDR'=0):$p($g(^OEC("OSTAT",StatDR)),"^",1),1:"")
			continue:(" V E "'[(" "_StatCode_" "))
			set myPriorFlag=##class(web.UDHCOEORDOPIF).ReadOECPriorityFlag(OEORI)
			continue:(+myPriorFlag=1)      //自备药医嘱退出
			set SkinRtnInfo=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag2(OEORI)
			set SkinRtnFlag=$p(SkinRtnInfo,"^",1)
			set SkinRtnDesc=$p(SkinRtnInfo,"^",2)
			quit:(SkinRtnFlag="Y")
		}
		quit:(SkinRtnFlag="Y")
	}
	
	quit $$GetRtn(SkinRtnFlag, SkinRtnDesc)

GetRtn(Flag, Desc)
	quit Flag_"^"_Desc
}

/// Creator: wanghc
/// Description: 获取有未结算医嘱的费别
/// Input: adm, type("ALL"或"FIRST"), sessionStr：操作员^安全组^科室^医院
/// Return: type=ALL时 返回adm下所有的insTypeId
///         type=FIRST时 返回adm下的第一个insTypeId
/// Debug: w ##class(web.DHCOPCashier).GetInsTypeIdStrOfHaveOrd()
ClassMethod GetInsTypeIdStrOfHaveOrd(adm As %String, type As %String, sessionStr As %String) As %String
{
	set ^TMP("GetInsTypeIdStrOfHaveOrd")=$lb(adm, type, sessionStr)
	set insTypeIdStr=""
	set ord=##class(web.DHCOPAdmFind).GetPAADMOrderRowid(adm)
	quit:(ord="") insTypeIdStr
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	//取出门诊结算费用配置
	set myRecLocStr=""
	if ((groupId'="")&&(ctLocId'="")) {
		set myRecLocStr=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(groupId, hospId, ctLocId)
	}
	
	set itm=0
	while($o(^OEORD(ord,"I",itm))) {
		set itm=$o(^OEORD(ord,"I",itm))
		continue:('$d(^OEORD(ord,"I",itm,1)))
		set oeitm=ord_"||"_itm
		set billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)
		continue:((" P I "[(" "_billed_" ")))
		set statDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
		set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
		continue:((" V E "'[(" "_statCode_" ")))
		set recDeptDR=$p($g(^OEORD(+ord,"I",itm,3)),"^",6)    //接收科室
		continue:((myRecLocStr'="")&&(myRecLocStr'[("^"_recDeptDR_"^")))
		continue:(##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(oeitm)=1)  //将转出的医嘱退出
		set myPriorFlag=##class(web.UDHCOEORDOP1).ReadOECPriorityFlag(oeitm)
		continue:(+myPriorFlag=1)      //自备药医嘱退出
		set bbCodeDR=$p($g(^OEORD(ord,"I",itm,11)),"^",18)
		continue:(+bbCodeDR=0)
		if (("^"_insTypeIdStr_"^")'[("^"_bbCodeDR_"^")) {
			set insTypeIdStr=$s((insTypeIdStr=""):bbCodeDR,1:(insTypeIdStr_"^"_bbCodeDR))
			if (type="FIRST") {
				quit
			}
		}
	}
	
	quit insTypeIdStr
}

/// Creator: ZhYW
/// CreatDate: 2018-08-31
/// Description: 取就诊费别
/// Input: admStr: PA_Adm.RowID 串(多个就诊按"^"分隔)
/// Return: 
/// Debug: w ##class(web.DHCOPCashier).GetPatAdmInsTypeList("4400^4399^4398")
ClassMethod GetPatAdmInsTypeList(admStr As %String) As %String
{
	kill tmpList
	set count=$l(admStr,"^")
	for i=1:1:count {
		set adm=$p(admStr,"^",i)
		continue:(+adm=0)
		set admReaDR=$p($g(^PAADM(adm,1)),"^",7)
		continue:(+admReaDR=0)
		set insTypeName=$p(^PAC("ADMREA",admReaDR),"^",2)
		set admSource=$p(^PAC("ADMREA",admReaDR),"^",9)
		set defInsTypeDR=""
		set tmpList(admReaDR)=insTypeName_"^"_admReaDR_"^"_defInsTypeDR_"^"_admSource
	}

	set insTypeStr=""
	set insTypeId=0
	while($o(tmpList(insTypeId))) {
		set insTypeId=$o(tmpList(insTypeId))
		set tmpStr=tmpList(insTypeId)
		set insTypeStr=$s((insTypeStr=""):tmpStr,1:(insTypeStr_$c(2)_tmpStr))
	}

	quit insTypeStr
}

/// Creator: ZhYW
/// CreatDate: 2019-04-23
/// Description: 查询患者处方类型
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPCashier","QryPatPrescTypeList", "607","3577^3578","17275^239^3^2^20")
Query QryPatPrescTypeList(papmi As %String, episodeIdStr As %String = "", sessionStr As %String) As websys.Query(ROWSPEC = "insType:%String,insTypeId:%String,admSource:%String,selected:%Boolean")
{
}

ClassMethod QryPatPrescTypeListExecute(ByRef qHandle As %Binary, papmi As %String, episodeIdStr As %String = "", sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("QryPatPrescTypeList")=$lb(papmi, episodeIdStr, sessionStr)
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	set prescTypeList=##class(web.DHCOPCashier).GetPatPrescTypeList(papmi, episodeIdStr, sessionStr)

	set insTypeIdStr=..GetToPayOrdInsTypeIdStr(episodeIdStr, "ALL", sessionStr)
	
	kill prescTypeAry
	set hasToPayOrd=0     //+2022-10-17 ZhYW
	set index=0
	set maxIndex=9999
	for i=1:1:$l(prescTypeList,$c(2)) {
		set prescTypeStr=$p(prescTypeList,$c(2),i)
		continue:(prescTypeStr="")
		set insTypeDR=$p(prescTypeStr,"^",2)
		continue:(+insTypeDR=0)
		if (("^"_insTypeIdStr_"^")[("^"_insTypeDR_"^")) {
			set hasToPayOrd=1
			set prescTypeAry($i(index))=prescTypeStr
		}else {
			set prescTypeAry($i(maxIndex))=prescTypeStr
		}
	}
	
	set defIdx=""
	set idx=0
	while($o(prescTypeAry(idx))) {
		set idx=$o(prescTypeAry(idx))
		set prescTypeStr=$g(prescTypeAry(idx))
		continue:(prescTypeStr="")
		set insType=$p(prescTypeStr,"^",1)
		set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, langId)
		set insTypeDR=$p(prescTypeStr,"^",2)
		continue:(+insTypeDR=0)
		set defInsTypeId=$p(prescTypeStr,"^",3)
		if (hasToPayOrd=1) {
			set selected=$s((defIdx=""):"true",1:"false")
			set defIdx=idx
		}else {
			set selected=$s((+defInsTypeId=+insTypeDR):"true",1:"false")
		}
		set admSource=$p(prescTypeStr,"^",4)
		do OutputPrescType
	}

	quit $$$OK
OutputPrescType
	set Data=$lb(insType,insTypeDR,admSource,selected)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-06-04
/// Description: 查询患者就诊信息
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPCashier","FindAdmDtlList","5038","1","5^122^49^2^1")
Query FindAdmDtlList(episodeIdStr As %String, insTypeId As %String, sessionStr As %String) As websys.Query(ROWSPEC = "adm:%String,admDate:%String,admDeptDR:%String,admDept:%String,admDocDR:%String,admDoc:%String,hasOrd:%String,admTotalSum:%Float,admDiscSum:%Float,admPayOrSum:%Float,admPatSum:%Float,limitOrdStr:%String")
{
}

ClassMethod FindAdmDtlListExecute(ByRef qHandle As %Binary, episodeIdStr As %String, insTypeId As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindAdmDtlList")=$lb(episodeIdStr, insTypeId, sessionStr)
	if (episodeIdStr="") quit $$$OK
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	do ##class(BILL.Interface.Inside.Invoke).GetMultiHospCfg(hospId, "OPCharge", .mulHospAry)
	
	set count=$l(episodeIdStr,"^")
	for i=1:1:count {
		set adm=$p(episodeIdStr,"^",i)
		continue:(+adm=0)
		set admDate=$p($g(^PAADM(adm)),"^",6)
		set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
		set admDeptDR=$p($g(^PAADM(adm)),"^",4)
		set hospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
		if ($d(mulHospAry("JZ"))) {
			continue:('$d(mulHospAry("JZ",hospDR)))
			if ($d(mulHospAry("JZ",hospDR,"LOC"))) {
				continue:('$d(mulHospAry("JZ",hospDR,"LOC",admDeptDR)))
			}
		}else {
			continue:('$d(mulHospAry(hospDR)))
		}
	 	set admDept=$s((+admDeptDR'=0):$p($g(^CTLOC(admDeptDR)),"^",2),1:"")
	 	set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
	 	set admDocDR=$p($g(^PAADM(adm)),"^",9)
	 	set admDoc=$s((+admDocDR'=0):$p($g(^CTPCP(admDocDR,1)),"^",2),1:"")
	 	set admDoc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", admDoc, langId)
	 	set fstOrdBBExtCodeDR=##class(web.DHCOPCashierIF).GetInsTypeIdStrOfHaveOrd(adm, "FIRST", sessionStr)
	 	set hasOrd=(fstOrdBBExtCodeDR'="")
	 	set admBillInfo=..GetToBillInfo(adm, insTypeId, sessionStr)
	 	set admTotalSum=$lg(admBillInfo,1)
	 	set admDiscSum=$lg(admBillInfo,2)
	 	set admPayOrSum=$lg(admBillInfo,3)
	 	set admPatSum=$lg(admBillInfo,4)
	 	set limitOrdStr=$lg(admBillInfo,5)
		do OutputAdmDtlList
	}

	quit $$$OK
OutputAdmDtlList
	set Data=$lb(adm,admDate,admDeptDR,admDept,admDocDR,admDoc,hasOrd,admTotalSum,admDiscSum,admPayOrSum,admPatSum,limitOrdStr)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-04-23
/// Description: 查询患者处方类型
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPCashier","FindChargeInsTypeList", "38","","122^49^2")
Query FindChargeInsTypeList(papmi As %String, insTypeId As %String, sessionStr As %String) As websys.Query(ROWSPEC = "insType:%String,insTypeId:%String,admSource:%String,selected:%Boolean")
{
}

ClassMethod FindChargeInsTypeListExecute(ByRef qHandle As %Binary, papmi As %String, insTypeId As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindChargeInsTypeList")=$lb(papmi, insTypeId, sessionStr)
	set langId=$p(sessionStr,"^",5)
	set prescTypeList=##class(web.DHCOPCashier).GetPatPrescTypeList(papmi, "", sessionStr)
	
	set count=$l(prescTypeList,$c(2))
	for i=1:1:count {
		set prescTypeStr=$p(prescTypeList,$c(2),i)
		continue:(prescTypeStr="")
		set insType=$p(prescTypeStr,"^",1)
		set insType=##class(User.PACAdmReason).GetTranByDesc("READesc",insType,langId)
		set insTypeDR=$p(prescTypeStr,"^",2)
		continue:(+insTypeDR=0)
		set selected=$case(insTypeDR,insTypeId:"true",:"false")
		set admSource=$p(prescTypeStr,"^",4)
		do OutputChargeInsType
	}

	quit $$$OK
OutputChargeInsType
	set Data=$lb(insType,insTypeDR,admSource,selected)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-06-11
/// Description: 查询医护人员
/// Table: CT_CareProv
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPCashier","FindCTCareProv", "汪", "")
Query FindCTCareProv(desc As %String, sessionStr As %String) As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindCTCareProvExecute(ByRef qHandle As %Binary, desc As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (desc'="") {
		set desc=$$ALPHAUP^SSUTIL4(desc)
	}
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
    
	set today=+$h
	set id=0
	while($o(^CTPCP(id))) {
		set id=$o(^CTPCP(id))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_CareProv", id, hospId)
		continue:(showFlag="N")
		set myActive=$p($g(^CTPCP(id,1)),"^",9)
		continue:(myActive'="Y")
		set myDateFrom=$p($g(^CTPCP(id,2)),"^",14)
		set myDateTo=$p($g(^CTPCP(id,2)),"^",15)
		continue:((myDateFrom'="")&&(myDateFrom>today))
		continue:((myDateTo'="")&&(myDateTo<today))
		set myCode=$p($g(^CTPCP(id,1)),"^",1)
		set myDesc=$p($g(^CTPCP(id,1)),"^",2)
		set myOtherName=$p($g(^CTPCP(id,3)),"^",28)
		continue:((desc'="")&&($$ALPHAUP^SSUTIL4(myCode)'[desc)&&($$ALPHAUP^SSUTIL4(myDesc)'[desc)&&($$ALPHAUP^SSUTIL4(myOtherName)'[desc))
		set deptDesc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", myDesc, langId)
		do OutputCareProv
	}

	quit $$$OK
OutputCareProv
	set Data=$lb(id,myDesc)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// w ##class(web.DHCOPCashier).GetToBillInfo()
ClassMethod GetToBillInfo(Adm As %String, InsTypeId As %String, SessionStr As %String) As %String
{
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CtLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)

	set (ToBillSum, ToBillDiscSum, ToBillPayOrSum, ToBillPatSum)=0
	set (RegArcimNum, RegSum, RegDiscSum, RegPayOrSum, RegPatShareSum)=0
	set (OPSFArcimNum, OPSFSum, OPSFDiscSum, OPSFPayOrSum, OPSFPatShareSum)=0
	
	set LimitOrdStr=""
		
	set StayInfo=##class(web.DHCBillInterface).IGetStayStatusByEpisodeID(Adm)
	set StayFlag=$p(StayInfo,"^",1)
	if (" 1 2 "[(" "_StayFlag_" ")) {
		quit $lb($fn(ToBillSum,"",2), $fn(ToBillDiscSum,"",2), $fn(ToBillPayOrSum,"",2), $fn(ToBillPatSum,"",2), LimitOrdStr)
	}
	
	set Ord=##class(web.DHCOPAdmFind).GetPAADMOrderRowid(Adm)
	if (Ord="") {
		quit $lb($fn(ToBillSum,"",2), $fn(ToBillDiscSum,"",2), $fn(ToBillPayOrSum,"",2), $fn(ToBillPatSum,"",2), LimitOrdStr)
	}
	
	set BaseCfgStr=##class(web.UDHCOPGSConfig).ReadCFByGRowID(GroupId, HospId)
	set RegBillCfg=$p(BaseCfgStr,"^",22)
	
	set OPSFOrdStr=""
	set Itm=0
	while($o(^OEORD(Ord,"I",Itm))) {
		set Itm=$o(^OEORD(Ord,"I",Itm))
		continue:('$d(^OEORD(Ord,"I",Itm,1)))
		set OEORI=Ord_"||"_Itm
		continue:(##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(OEORI)=1)   //将急诊转入住院的医嘱退出
		set billed=$p($g(^OEORD(Ord,"I",Itm,3)),"^",5)
		continue:(" P I "[(" "_billed_" "))
		set StatDR=$p($g(^OEORD(Ord,"I",Itm,1)),"^",13)
		set StatCode=$s((+StatDR'=0):$p($g(^OEC("OSTAT",StatDR)),"^",1),1:"")
		continue:(" V E "'[(" "_StatCode_" "))
		set InsTypeDR=##class(web.DHCBillCons1).GetCurrentOrdInsType(OEORI, InsTypeId, HospId)
		continue:((InsTypeId'="")&&(InsTypeId'=InsTypeDR))
		set SkinFlag=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(OEORI)
		continue:(SkinFlag="Y")				//限制医嘱不计费
		set ArcimDR=$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
		set ArcimDateTo=$p($g(^ARCIM(+ArcimDR,$p(ArcimDR,"||",2),7)),"^",1)
		continue:((ArcimDateTo'="")&&(ArcimDateTo<+$h))     //超期医嘱不能结算
		set OEORICost=..GetOrderItemDetail(OEORI, InsTypeDR, HospId)
		set OEORIAmt=$p(OEORICost,"^",1)
		set OEORIDiscAmt=$p(OEORICost,"^",2)
		set OEORIPayOrAmt=$p(OEORICost,"^",3)
		set OEORIPatAmt=$p(OEORICost,"^",4)
		set Arcim=$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
		set BillSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(Arcim, HospId)
		if (BillSubType'="NotRegFee") {
			set RegArcimNum=$i(regArcimNum)
			set RegSum=$i(RegSum,OEORIAmt)
			set RegDiscSum=$i(RegDiscSum,OEORIDiscAmt)
			set RegPayOrSum=$i(RegPayOrSum,OEORIPayOrAmt)
			set RegPatShareSum=$i(RegPatShareSum,OEORIPatAmt)
		}else {
			set OPSFArcimNum=$i(OPSFArcimNum)
			set OPSFSum=$i(OPSFSum,OEORIAmt)
			set OPSFDiscSum=$i(OPSFDiscSum,OEORIDiscAmt)
			set OPSFPayOrSum=$i(OPSFPayOrSum,OEORIPayOrAmt)
			set OPSFPatShareSum=$i(OPSFPatShareSum,OEORIPatAmt)
			set OPSFOrdStr=$s(($ll(OPSFOrdStr)=0):$lb(OEORI),1:(OPSFOrdStr_$lb(OEORI)))
		}
	}

	if (+RegBillCfg'=0) {
		set ToBillSum=RegSum+OPSFSum
		set ToBillDiscSum=RegDiscSum+OPSFDiscSum
		set ToBillPayOrSum=RegPayOrSum+OPSFPayOrSum
		set ToBillPatSum=RegPatShareSum+OPSFPatShareSum
	}elseif(RegArcimNum'=0) {
		set ToBillSum=RegSum
		set ToBillDiscSum=RegDiscSum
		set ToBillPayOrSum=RegPayOrSum
		set ToBillPatSum=RegPatShareSum
		//配置了挂号费和收费医嘱不能一起结算，当有挂号费时，收费医嘱不能结算
		set LimitOrdStr=$lts(OPSFOrdStr,"^")
	}else {
		set ToBillSum=OPSFSum
		set ToBillDiscSum=OPSFDiscSum
		set ToBillPayOrSum=OPSFPayOrSum
		set ToBillPatSum=OPSFPatShareSum
	}
	
	quit $lb($fn(ToBillSum,"",2), $fn(ToBillDiscSum,"",2), $fn(ToBillPayOrSum,"",2), $fn(ToBillPatSum,"",2), LimitOrdStr)
}

/// Creator: ZhYW
/// CreatDate: 2019-06-13
/// Description: 查询门急诊科室
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPCashier","FindOPAdmLoc", "", "2")
Query FindOPAdmLoc(desc As %String, sessionStr As %String) As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindOPAdmLocExecute(ByRef qHandle As %Binary, desc As %String, sessionStr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
	set desc=$$ALPHAUP^SSUTIL4(desc)

 	set hospId=$p(sessionStr,"^",4)
 	set langId=$p(sessionStr,"^",5)
 	
    set admTypeStr="O^E"
	for i=1:1:$l(admTypeStr,"^") {
		set admType=$p(admTypeStr,"^",i)
		continue:(admType="")
		set deptId=0
		while($o(^PAC("ADMLOC",0,"AdmType",admType,deptId))) {
			set deptId=$o(^PAC("ADMLOC",0,"AdmType",admType,deptId))
			set deptData=$g(^CTLOC(deptId))
			continue:(deptData="")
			set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", deptId, hospId)
			continue:(showFlag="N")
			set deptDesc=$p(deptData,"^",2)
			set contactName=$p(deptData,"^",43)   //科室检索码
			continue:((desc'="")&&($$ALPHAUP^SSUTIL4(deptDesc)'[desc)&&($$ALPHAUP^SSUTIL4(contactName)'[desc))
			set deptDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", deptDesc, langId)
			do OutputOPAdmLoc
		}
	}
	
	quit $$$OK
OutputOPAdmLoc
	set Data=$lb(deptId,deptDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-06-15
/// Description: 获取未确认完成的结算记录
/// Input: prtRowIdStr:DHC_INVPRT.RowId串
/// Return: prtRowId_"^"_insTypeDR_"^"_admSource_"^"_insuDivDR，多个之间以$c(2)分割
/// Debug: w ##class(web.DHCOPCashier).GetInvalidPrtIDStr()
ClassMethod GetInvalidPrtIDStr(prtRowIdStr As %String) As %String
{
	set rtn=""
	set count=$l(prtRowIdStr,"^")
	for i=1:1:count {
		set prtRowId=$p(prtRowIdStr,"^",i)
		continue:(+prtRowId=0)
		set data=$g(^DHCINVPRT(prtRowId))
		continue:(data="")
		set prtFlag=$p(data,"^",8)
		continue:(prtFlag'="TP")
		set insTypeDR=$p(data,"^",9)
		set admSource=$s((+insTypeDR'=0):$p(^PAC("ADMREA",insTypeDR),"^",9),1:"")
		set insuDivDR=$p(data,"^",30)
		set singleStr=prtRowId_"^"_insTypeDR_"^"_admSource_"^"_insuDivDR
		set rtn=$s((rtn=""):singleStr,1:(rtn_$c(2)_singleStr))
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2021-01-26
/// Description: 判断该医嘱项能否录入小数
/// Input: arcim: ARC_ItmMast.RowId, hospId: CT_Hospital.RowId
/// Return: 1: 允许录入小数，0: 只能录入非0整数
/// Debug: w ##class(web.DHCOPCashier).IsAllowedDecimalQty("1961||2", 2)
ClassMethod IsAllowedDecimalQty(arcim As %String, hospId As %String) As %String
{
	quit:(+arcim=0) 0
	set itemCatDR=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
	set allowEntryDecimalItemCatStr=##class(web.DHCDocConfig).GetConfigNode("AllowEntryDecimalItemCat", hospId)
	quit ("^"_allowEntryDecimalItemCatStr_"^"[("^"_itemCatDR_"^"))
}

/// Creator: ZhYW
/// CreatDate: 2021-05-05
/// Description: 根据就诊查询待结算费用和不能结算的医嘱
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPCashier","GetLOrdItmList", "1301","122^49^2")
Query GetLOrdItmList(episodeIdStr As %String, insTypeId As %String, sessionStr As %String) As websys.Query(ROWSPEC = "adm:%String,totalSum:%Float,discSum:%Float,payOrSum:%Float,patSum:%Float,limitOrdStr:%String")
{
}

ClassMethod GetLOrdItmListExecute(ByRef qHandle As %Binary, episodeIdStr As %String, insTypeId As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindLimitOrdItmList")=$lb(episodeIdStr, insTypeId, sessionStr)
	if (episodeIdStr="") quit $$$OK

	set count=$l(episodeIdStr,"^")
	for i=1:1:count {
		set adm=$p(episodeIdStr,"^",i)
		continue:(+adm=0)
	 	set admBillInfo=..GetToBillInfo(adm, insTypeId, sessionStr)
	 	set totalSum=$lg(admBillInfo,1)
	 	set discSum=$lg(admBillInfo,2)
	 	set payOrSum=$lg(admBillInfo,3)
	 	set patSum=$lg(admBillInfo,4)
	 	set limitOrdStr=$lg(admBillInfo,5)
		do OutputLOrdItmList
	}

	quit $$$OK
OutputLOrdItmList
	set Data=$lb(adm,totalSum,discSum,payOrSum,patSum,limitOrdStr)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2021-07-28
/// Description: 查询门急诊患者待缴费门诊收费大类金额信息
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPCashier", "QryAdmCateFee", "7836","4",$c(2)_"7836"_$c(2)_"^7154||3^"_$c(2)_"7836"_$c(2),"17275^239^3^2^20")
Query QryAdmCateFee(adm As %String, insTypeId As %String, unBillStr As %String, sessionStr As %String) As websys.Query(ROWSPEC = "CateDesc1:%String,CateSum1:%Float,CateDiscSum1:%Float,CatePayOrSum1:%Float,CatePatSum1:%Float,CateDesc2:%String,CateSum2:%Float,CateDiscSum2:%Float,CatePayOrSum2:%Float,CatePatSum2:%Float,CateDesc3:%String,CateSum3:%Float,CateDiscSum3:%Float,CatePayOrSum3:%Float,CatePatSum3:%Float,CateDesc4:%String,CatSum4:%Float,CateDiscSum4:%Float,CatePayOrSum4:%Float,CatePatSum4:%Float")
{
}

ClassMethod QryAdmCateFeeExecute(ByRef qHandle As %Binary, adm As %String, insTypeId As %String, unBillStr As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (adm="") quit $$$OK
	set ^TMP("QryAdmCateFee")=$lb(adm, insTypeId, unBillStr, sessionStr)
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	kill tariAry, cateAry, itmAry
	set rset=##class(%ResultSet).%New("web.DHCOPCashier:QryAdmOrdItmList")
	if ('rset.QueryIsValid()) quit $$$OK
	do rset.Execute(adm, insTypeId, unBillStr, sessionStr)
	while (rset.Next()) {
		set oeitm=rset.Get("OEORI")
		set priceDate=##class(BILL.OP.COM.Method).GetPendPayOrdPriceDate(oeitm)
		do ##class(BILL.OP.COM.Method).GetOrdTarItmCost(oeitm, insTypeId, priceDate, hospId, .tariAry)
	}
	
	set tari=0
	while($o(tariAry(tari))) {
		set tari=$o(tariAry(tari))
		set data=$g(tariAry(tari))
		set totalAmt=$lg(data,1)
		set discAmt=$lg(data,2)
		set payorAmt=$lg(data,3)
		set patAmt=$lg(data,4)
		set subCateDR=$p(^DHCTARI(tari),"^",15)
		set cateDR=$p(^DHCTarC("OC",subCateDR),"^",3)
		set $li(cateAry(cateDR),1)=$lg($g(cateAry(cateDR)),1)+totalAmt
		set $li(cateAry(cateDR),2)=$lg($g(cateAry(cateDR)),2)+discAmt
		set $li(cateAry(cateDR),3)=$lg($g(cateAry(cateDR)),3)+payorAmt
		set $li(cateAry(cateDR),4)=$lg($g(cateAry(cateDR)),4)+patAmt
	}
	
	set maxCateId=$o(cateAry(""),-1)
	set num=0
	set (totalSum, discSum, payorSum, patSum)=0
	set cateId=0
	while($o(cateAry(cateId))) {
		set cateId=$o(cateAry(cateId))
		set cateData=$g(^DHCTarC("TOC",cateId))
		continue:(cateData="")
		set cateDesc=$p(cateData,"^",2)
		set cateDesc=##class(User.DHCTarOC).GetTranByDesc("TARTOCDesc", cateDesc, langId)
		set cateFeeData=$g(cateAry(cateId))
		set totalAmt=$lg(cateFeeData,1)
		set discAmt=$lg(cateFeeData,2)
		set payorAmt=$lg(cateFeeData,3)
		set patAmt=$lg(cateFeeData,4)
		set totalAmt=$fn(totalAmt,"",2)
		set discAmt=$fn(discAmt,"",2)
		set payorAmt=$fn(payorAmt,"",2)
		set patAmt=$fn(patAmt,"",2)
		
		set totalSum=$i(totalSum, totalAmt)
		set discSum=$i(discSum, discAmt)
		set payorSum=$i(payorSum, payorAmt)
		set patSum=$i(patSum, patAmt)
		
		set mod=$i(num)#..#CATECOLNUM
		set itmAry($case(mod, 0:..#CATECOLNUM, :mod))=$$GetData()
		if ((mod=0)||(cateId=maxCateId)) {
			do OutputCateFee
			do InitCateFee
		}
	}
	
	do InitCateFee
	set cateDesc=##class(websys.Translation).Get("", "合计", langId)
	set totalAmt=$fn(totalSum,"",2)
	set discAmt=$fn(discSum,"",2)
	set payorAmt=$fn(payorSum,"",2)
	set patAmt=$fn(patSum,"",2)
	set itmAry(1)=$$GetData()
	do OutputCateFee
	
	kill tariAry, cateAry, itmAry
	quit $$$OK

InitCateFee()
	set (cateDesc, totalAmt, discAmt, payorAmt, patAmt)=""
	for i=1:1:..#CATECOLNUM {
		set itmAry(i)=$$GetData()
	}
	quit
GetData()
	set cateData=$lb(cateDesc, totalAmt, discAmt, payorAmt, patAmt)
	quit cateData
OutputCateFee
	set Data=""
	for i=1:1:..#CATECOLNUM {
		set Data=Data_$g(itmAry(i))
	}
	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-08-31
/// Description: 验证就诊下医嘱完整性
/// Input: adm: PA_Adm.RowId, unBillOrdStr: 不结算医嘱
/// Return: 0: 数据完整，1: 数据不全
/// Debug: w ##class(web.DHCOPCashier).IsValidAdmOrd("268345","")
ClassMethod IsValidAdmOrd(admStr As %String, unBillOrdStr As %String = "") As %String
{
	set rtn=0
	set msg=""
	for i=1:1:$l(admStr,"^") {
		set adm=$p(admStr,"^",i)
		continue:(+adm=0)
		set ord=$o(^OEORD(0,"Adm",adm,0))
		continue:(+ord=0)
		set itm=0
		while($o(^OEORD(ord,"I",itm))) {
			set itm=$o(^OEORD(ord,"I",itm))
			continue:'$d(^OEORD(ord,"I",itm,1))
			set oeitm=ord_"||"_itm
			continue:(("^"_unBillOrdStr_"^")[("^"_oeitm_"^"))
			set billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)
			continue:(" P I "[(" "_billed_" "))
			set statDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
			set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
			continue:(" V E "'[(" "_statCode_" "))
			set skinFlag=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(oeitm)
			continue:(skinFlag="Y")				//限制医嘱不计费
			set rtnValue=##class(BILL.OP.COM.Method).IsValidOrd(oeitm)
			set isValid=$p(rtnValue,"^",1)
			if ('isValid) {
				set rtn=1
				set msg=$s((msg=""):("医嘱："_$p(rtnValue,"^",2)),1:(msg_"，"_$p(rtnValue,"^",2)))
			}
		}
	}
	
	quit rtn_"^"_msg
}

/// Creator: ZhYW
/// CreatDate: 2021-09-27
/// Description: 获取已结算发票找零信息
/// Input: prtRowIdStr:DHC_INVPRT.RowId串
/// Return: 
/// Debug: w ##class(web.DHCOPCashier).GetChgedChangeInfo("44801^44802")
ClassMethod GetChgedChangeInfo(prtRowIdStr As %String) As %String
{
	set patSum=0
	set insuSum=0
	set selfSum=0
	set preSum=0
	set changeSum=0
	for i=1:1:$l(prtRowIdStr,"^") {
		set prtRowId=$p(prtRowIdStr,"^",i)
		continue:(+prtRowId=0)
		set data=$g(^DHCINVPRT(prtRowId))
		continue:(data="")
		set patAmt=$p(data,"^",16)
		set patSum=$i(patSum,patAmt)
		set insuAmt=$p(data,"^",31)      //医保支付金额
		set insuSum=$i(insuSum,insuAmt)
		set selfAmt=patAmt-insuAmt
		set selfSum=$i(selfSum,selfAmt)
		set preAmt=$p(data,"^",35)
		set preSum=$i(preSum,preAmt)
		set changeAmt=$p(data,"^",36)
		set changeSum=$i(changeSum,changeAmt)
	}
	set json={}
	set json."总金额"=$fn(patSum,"",2)
	set json."医保支付"=$fn(insuSum,"",2)
	set json."实际支付"=$fn(selfSum,"",2)
	set json."实收"=$fn(preSum,"",2)
	set json."找零"=$fn(changeSum,"",2)
	quit json.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2022-03-31
/// Description: 查询门急诊医嘱对应的收费项信息
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPCashier", "QryOrdTarItmList", "1563||2","1","5^122^3^2^20")
Query QryOrdTarItmList(oeitm As %String, insTypeId As %String, sessionStr As %String) As websys.Query(ROWSPEC = "tarItmId:%String,tarItmDesc:%String,uomDesc:%String,price:%Float,discPrice:%Float,payorPrice:%Float,patPrice:%Float,qty:%Float,totalAmt:%Float,discAmt:%Float,payorAmt:%Float,patAmt:%Float")
{
}

ClassMethod QryOrdTarItmListExecute(ByRef qHandle As %Binary, oeitm As %String, insTypeId As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (oeitm="") quit $$$OK
	set ^TMP("QryOrdTarItmList")=$lb(oeitm, insTypeId, sessionStr)
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	kill tariAry
	do ##class(BILL.OP.COM.Method).GetOrdTarItmList(oeitm, insTypeId, +$h, hospId, .tariAry)
	
	set index=0
	while($o(tariAry(index))) {
		set index=$o(tariAry(index))
		set data=$g(tariAry(index))
		set tari=$lg(data,1)
		set tarDesc=$p($g(^DHCTARI(tari)),"^",2)
		set tarDesc=##class(User.DHCTarItem).GetTranByDesc("TARIDesc", tarDesc, langId)
		set uomDR=$p(^DHCTARI(tari),"^",3)          //单位
    	set uomDesc=$s((+uomDR'=0):$p($g(^CT("UOM",uomDR)),"^",2),1:"")
    	set uomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", uomDesc, langId)
		set price=$lg(data,2)
		set price=$fn(price,"N")
		set discPrice=$lg(data,3)
		set discPrice=$fn(discPrice,"N")
		set payorPrice=$lg(data,4)
		set payorPrice=$fn(payorPrice,"N")
		set patPrice=$lg(data,5)
		set patPrice=$fn(patPrice,"N")
		set qty=$lg(data,6)
		set qty=$fn(qty,"N")
		set totalAmt=$lg(data,7)
		set totalAmt=$fn(totalAmt,"",2)
		set discAmt=$lg(data,8)
		set discAmt=$fn(discAmt,"",2)
		set payorAmt=$lg(data,9)
		set payorAmt=$fn(payorAmt,"",2)
		set patAmt=$lg(data,10)
		set patAmt=$fn(patAmt,"",2)
		do OutputTarItmList
	}
	kill tariAry
	quit $$$OK
OutputTarItmList
	set Data=$lb(tari,tarDesc,uomDesc,price,discPrice,payorPrice,patPrice,qty,totalAmt,discAmt,payorAmt,patAmt)
	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// Description: 获取就诊串中有未结算医嘱的费别
/// Input: episodeIdStr:PA_Adm.RowId串(多以就诊之间以"^"分隔), type("ALL"或"FIRST"), sessionStr：扩展串(操作员^安全组^科室^医院)
/// Return: type=ALL时 返回adm下所有的insTypeId
///         type=FIRST时 返回adm下的第一个insTypeId
/// Debug: w ##class(web.DHCOPCashier).GetToPayOrdInsTypeIdStr()
ClassMethod GetToPayOrdInsTypeIdStr(episodeIdStr As %String, type As %String, sessionStr As %String) As %String
{
	set insTypeIdStr=""
	for i=1:1:$l(episodeIdStr,"^") {
		set episodeId=$p(episodeIdStr,"^",i)
		continue:(+episodeId=0)
		set rtnValue=##class(web.DHCOPCashierIF).GetInsTypeIdStrOfHaveOrd(episodeId, type, sessionStr)
		for j=1:1:$l(rtnValue,"^") {
			set insTypeId=$p(rtnValue,"^",j)
			continue:(insTypeId="")
			continue:(("^"_insTypeIdStr_"^")[("^"_insTypeId_"^"))
			set insTypeIdStr=$s((insTypeIdStr=""):insTypeId,1:(insTypeIdStr_"^"_insTypeId))
		}
	}
	quit insTypeIdStr
}

/// Creator: TianZJ
/// CreatDate: 2022-11-30
/// Description: 查询患者结算费别
/// Input: 
/// Output: 费别描述, 费别id, admSource, 是否默认
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPCashier","QryChgInsTypeList", "1","2")
Query QryChgInsTypeList(insTypeId As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "insType:%String,insTypeId:%String,admSource:%String,selected:%Boolean")
{
}

ClassMethod QryChgInsTypeListExecute(ByRef qHandle As %Binary, insTypeId As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("QryChgInsTypeList")=$lb(insTypeId, hospId)
	if (+insTypeId=0) quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set rset=##class(%Library.ResultSet).%New("BILL.CFG.COM.GeneralCfg:GetResultForQuery")
	do rset.Execute("OPCHRG.OPChrg.CFFBYJSFBDDZ", insTypeId, "", hospId)
	while(rset.Next()) {
		set insTypeDR=rset.Get("ID")
		continue:(+insTypeDR=0)
		set insTypeData=$g(^PAC("ADMREA",insTypeDR))
		set insType=$p(insTypeData,"^",2)
		set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, langId)
		set admSource=$p(insTypeData,"^",9)		 //REA_AdmSource
		set selected=$case(insTypeDR,insTypeId:"true",:"false")
		do OutputChgInsTypeList
	}
	
	quit $$$OK
OutputChgInsTypeList
	set Data=$lb(insType,insTypeDR,admSource,selected)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2023-02-20
/// Description: 验证就诊下医嘱当前库存是否足够
/// Input: adm: PA_Adm.RowId, unBillOrdStr: 不结算医嘱
/// Return: 0: 库存足够，1: 库存不足
/// Debug: w ##class(web.DHCOPCashier).IsStockEnoughAdmOrd("2462", "", 2)
ClassMethod IsStockEnoughAdmOrd(admStr As %String, unBillOrdStr As %String, hospId As %String, langId As %String = "") As %String
{
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	set rtn=0
	if ('..IsChkStockEnough(hospId)) quit rtn
	
	for i=1:1:$l(admStr,"^") {
		set adm=$p(admStr,"^",i)
		continue:(+adm=0)
		set ord=$o(^OEORD(0,"Adm",adm,0))
		continue:(+ord=0)
		set itm=0
		while($o(^OEORD(ord,"I",itm))) {
			set itm=$o(^OEORD(ord,"I",itm))
			continue:'$d(^OEORD(ord,"I",itm,1))
			set oeitm=ord_"||"_itm
			continue:(("^"_unBillOrdStr_"^")[("^"_oeitm_"^"))
			set billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)
			continue:(" P I "[(" "_billed_" "))
			set statDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
			set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
			continue:(" V E "'[(" "_statCode_" "))
			set skinFlag=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(oeitm)
			continue:(skinFlag="Y")				//限制医嘱不计费
			set arcim=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
			continue:(arcim="")
			set inci=$o(^INCI(0,"ARCIM_DR",+arcim,0))
			continue:(inci="")
			continue:(##class(BILL.OP.COM.Method).IsReChgedOEORI(oeitm)=1)  //如果是退费后重新收费的医嘱，不判断库存
			set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
			set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId)
			set orderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(arcim, 0)
			continue:(orderType'="R")    //先只判断药品库存
			set isEnough=##class(PHA.FACE.OUT.Com).IsStockEnough4Oeori(oeitm)
			set rtn=('isEnough)
			if (+rtn) {
				set rtn=rtn_"^"_##class(websys.Translation).Get("", "医嘱", langId)_"："_arcimDesc_##class(websys.Translation).Get("", "当前库存不足", langId)
				quit
			}
		}
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-02-21
/// Description: 收费时是否判断药品库存
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置->门诊收费系统->门诊收费->收费时是否判断药品库存
/// Debug: w ##class(web.DHCOPCashier).IsChkStockEnough(2)
ClassMethod IsChkStockEnough(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPChrg.SFSSFPDYPKC", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: ZhYW
/// CreatDate: 2022-02-22
/// Description: 收费时获取医嘱自付金额，用于收费时的验证
/// Input: admStr:就诊RowId串, insTypeId:PAC_AdmReason.RowId, unBillStr:不结算的医嘱串, sessionStr:操作员^安全组^科室^医院
/// Return: 自付金额
/// Debug: w ##class(web.DHCOPCashier).GetPatOrdPaySum("7829","1",$c(2)_"7829"_$c(2)_"^7149||3^"_$c(2)_"7829"_$c(2),"17275^239^3^2^20")
ClassMethod GetPatOrdPaySum(admStr As %String, insTypeId As %String, unBillStr As %String, sessionStr As %String) As %String
{
	set paySum=0
	set rset=##class(%ResultSet).%New("web.DHCOPCashier:QryAdmOrdItmList")
	quit:('rset.QueryIsValid()) paySum
	do rset.Execute(admStr, insTypeId, unBillStr, sessionStr)
	while (rset.Next()) {
		set patAmt=rset.Get("PatAmt")
		set paySum=$i(paySum, patAmt)
	}
	set paySum=$fn(paySum,"",2)
	quit paySum
}

/// Creator: ZhYW
/// CreatDate: 2022-02-23
/// Description: 获取就诊下未结算医嘱信息
/// Input: admStr:就诊RowId串, insTypeId:PAC_AdmReason.RowId, unBillStr:不结算的医嘱串, sessionStr:操作员^安全组^科室^医院
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPCashier","QryAdmOrdItmList","7836","4",$c(2)_"7836"_$c(2)_"^7154||3^"_$c(2)_"7836"_$c(2),"17275^239^3^2^20")
Query QryAdmOrdItmList(admStr As %String, insTypeId As %String, unBillStr As %String, sessionStr As %String) As websys.Query(ROWSPEC = "OEORI:%String:医嘱ID,TotalAmt:%Float:金额,DiscAmt:%Float:折扣金额,PayorAmt:%Float:记账金额,PatAmt:%String:自付金额")
{
}

ClassMethod QryAdmOrdItmListExecute(ByRef qHandle As %Binary, admStr As %String, insTypeId As %String, unBillStr As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (admStr="") quit $$$OK
	set ^TMP("QryAdmOrdItmList")=$lb(admStr, insTypeId, unBillStr, sessionStr)
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)

	if (hospId="") {
		set hospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(ctLocId)
	}
	//取门诊结算费用配置
	set cfgRecLocStr=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(groupId, hospId, ctLocId)
	
	set admCnt=$l(admStr,"^")
	for i=1:1:admCnt {
		set adm=$p(admStr,"^",i)
		continue:(+adm=0)
		set ord=$o(^OEORD(0,"Adm",adm,0))
		continue:(ord="")
		do OutputItmList
	}
	
	quit $$$OK

OutputItmList
	kill ^||TMP($j)
	set itm=0
	while($o(^OEORD(ord,"I",itm))) {
		set itm=$o(^OEORD(ord,"I",itm))
		continue:('$d(^OEORD(ord,"I",itm,1)))
		set oeitm=ord_"||"_itm
		continue:(##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(oeitm)=1)    //将急诊转出到住院的医嘱退出
		set priorFlag=##class(web.UDHCOEORDOP1).ReadOECPriorityFlag(oeitm)
		continue:(+priorFlag=1)      //自备药医嘱退出
		continue:(("^"_unBillStr_"^")[("^"_oeitm_"^"))
		set billFlag=1                 //能否结算标识(1:能结算，0:不能结算)
		if (("^"_unBillStr_"^")[("^"_oeitm_"^")) {
			set billFlag=0
		}
		set mySkinFlag=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(oeitm)
		set billFlag=$case(mySkinFlag,"Y":0,:billFlag)   //判断皮试标志
		set billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)
		continue:(" P I "[(" "_billed_" "))
		set statDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
		set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
		continue:(" V E "'[(" "_statCode_" "))
		set recDeptDR=$p($g(^OEORD(+ord,"I",itm,3)),"^",6)    //接收科室
		continue:((cfgRecLocStr'="")&&(cfgRecLocStr'[("^"_recDeptDR_"^")))
		set insTypeDR=##class(web.DHCBillCons1).GetCurrentOrdInsType(oeitm, insTypeId, hospId)
		continue:((insTypeId'="")&&(insTypeId'=insTypeDR))
		set arcim=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
		set arcimDateTo=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),7)),"^",1)   
		continue:((arcimDateTo'="")&&(arcimDateTo<+$h))   //超期医嘱不能结算
		set prescno=$p($g(^OEORD(+ord,"I",itm,1)),"^",14)     //处方号
		set orderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(arcim, 0)
		if ((orderType="R")&&(prescno'="")) {
			if ($g(^||TMP($j,"PrescnoSkin",prescno))="Y") {
				set billFlag=0
			}else {
				set prescSkinFlag=##class(web.DHCOPAdmFind).CheckPrescnoSkinFlag(prescno, "", "")
				if (prescSkinFlag="Y") {
					set billFlag=0	             //处方上有皮试医嘱且皮试医嘱不是阴性时，该处方上的医嘱都不能缴费
					set ^||TMP($j,"PrescnoSkin",prescno)=prescSkinFlag
				}
			}
		}
		continue:('billFlag)
		set costAmtStr=##class(BILL.OP.COM.Method).GetPendPayOrdItmCost(oeitm, insTypeDR, hospId)
		set totalAmt=$p(costAmtStr,"^",1)
		set discAmt=$p(costAmtStr,"^",2)
		set payorAmt=$p(costAmtStr,"^",3)
		set patAmt=$p(costAmtStr,"^",4)
		set ^CacheTemp(repid,ind)=$lb(oeitm,totalAmt,discAmt,payorAmt,patAmt)
		set ind=$i(ind)
	}
	kill ^||TMP($j)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-10-20
/// Description: 取是否按选择的病种自动勾选对应医嘱配置
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置->门诊收费系统->门诊收费->是否按选择的病种自动勾选对应医嘱
/// Debug: w ##class(web.DHCOPCashier).IsChkOrdByChronicCode(2)
ClassMethod IsChkOrdByChronicCode(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPChrg.SFAXZDBZZDGXDYYZ", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: ZhYW
/// CreatDate: 2023-03-15
/// Description: 取成组医嘱是否一起收费配置
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置->门诊收费系统->门诊收费->成组医嘱是否一起收费
/// Debug: w ##class(web.DHCOPCashier).IsTgtChrgGroupOrd(2)
ClassMethod IsTgtChrgGroupOrd(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPChrg.CZYZSFYQSF", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: ZhYW
/// CreatDate: 2023-03-15
/// Description: 取安全组与结算用户对照的配置值
///        业务场景：诊间支付时，将收费操作员算到固定的操作员，日结时根据此固定操作员做账
/// Input: groupId:SS_Group.RowId, hospId:CT_Hospital.RowId
/// Return: SS_User.RowId
/// Others: 通用配置->门诊收费系统->诊间医嘱收费->安全组与结算用户对照
/// Debug: w ##class(web.DHCOPCashier).GetGrupContFootUser(33, 2)
ClassMethod GetGrupContFootUser(groupId As %String, hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.CnstroomChrg.AQZYJSYHDZ", groupId, "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit $p(cfgData,"^",1)
}

}
