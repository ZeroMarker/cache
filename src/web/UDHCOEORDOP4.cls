Class web.UDHCOEORDOP4 Extends BILL.COM.Abstract
{

/// Description: 皮试医嘱的限制
/// Debug: w ##class(web.UDHCOEORDOP4).ReadLimitOrdItmStr()
ClassMethod ReadLimitOrdItmStr(PAADMStr As %String, AdmInsType As %String, gLoc As %String, UloadDR As %String) As %String
{
	quit:(PAADMStr="") ""
	
	set myLOrdStr=""
	set myLSOrdStr=""
	
	set HospID=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(UloadDR)
	set myRecLocStr=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(gLoc, HospID, UloadDR)
		
	for i=1:1:$l(PAADMStr,"^") {
		set PAADMRowid=$p(PAADMStr,"^",i)
		continue:(+PAADMRowid=0)
		set myADMLOrdStr=""
		set OrderRowid=$o(^OEORD(0,"Adm",+PAADMRowid,""))
		continue:(+OrderRowid=0)
		set itemSub=0
		while($o(^OEORD(OrderRowid,"I",itemSub))) {
			set itemSub=$o(^OEORD(OrderRowid,"I",itemSub))
			set OEORIRowid=OrderRowid_"||"_itemSub
			set billed=$p($g(^OEORD(OrderRowid,"I",itemSub,3)),"^",5)
			continue:(" P I "[(" "_billed_" "))
			set statDR=$p($g(^OEORD(OrderRowid,"I",itemSub,1)),"^",13)
			set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
			continue:(" V E "'[(" "_statCode_" "))
			set InsTypeDR=$p(^OEORD(+OrderRowid,"I",itemSub,11),"^",18)    //OEORI_BBExtCode
			set JfCF=##class(web.DHCBillCommon).GetTarParaId(HospID)
			if (InsTypeDR="")&&(JfCF'="") set InsTypeDR=$P(^DHCTarC("CF",JfCF),"^",3)
			continue:((AdmInsType'="")&&(AdmInsType'=InsTypeDR))
			set RecLocDR=$p($g(^OEORD(+OrderRowid,"I",itemSub,3)),"^",6)    //接收科室
			continue:((myRecLocStr'="")&&(myRecLocStr'[("^"_RecLocDR_"^")))
			//增加皮试标志
			set mySkinTest=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(OEORIRowid)
			continue:(mySkinTest'="Y")			//非皮试医嘱退出
			set myLOrdStr=myLOrdStr_"^"_OEORIRowid
			set myADMLOrdStr=myADMLOrdStr_"^"_OEORIRowid
		}
		//形成一个符合规则的字符串
		set myADMLOrdStr="^"_myADMLOrdStr_"^"
		set mySplit=$c(2)_PAADMRowid_$c(2)
		set myLSOrdStr=myLSOrdStr_mySplit_myADMLOrdStr_mySplit
	}
	
	if (myLOrdStr'="") {
		set myLOrdStr=myLOrdStr_"^"
	}
	if (myLOrdStr="") {
		set myLSOrdStr=""
	}
	
	quit myLOrdStr_$c(3)_myLSOrdStr
}

/// Modify by ZhYW 2020-04-17
/// 1. 药房配置为控制例外的皮试医嘱，可以缴费
/// 2. 皮试医嘱配置了皮试用法，可以缴费
///    皮试医嘱非皮试用法且皮试备注为空，不能缴费
/// Debug: w ##class(web.UDHCOEORDOP4).ReadSkinRtnFlag("1174||5")
ClassMethod ReadSkinRtnFlag(OEItmRowID As %String) As %String
{
	set mySkinOERowID=""			//皮试医嘱的rowId
	set myGrpFlag="N"				//表示本医嘱在此组标志
	set myOEORIDR=0
	for  set myOEORIDR=$o(^OEORDi(0,"OEORI",+OEItmRowID,myOEORIDR)) quit:((myOEORIDR="")||(myGrpFlag="Y"))  do
	.set mySkinOERowID=""			//皮试医嘱的rowId
	.set myGrpFlag="N"				//表示本医嘱在此组标志
	.set:(OEItmRowID=myOEORIDR) myGrpFlag="Y"			//如果是主医嘱，标志为成组医嘱
	.set myGrpSkinTest=$p($g(^OEORD(+myOEORIDR,"I",$p(myOEORIDR,"||",2),5)),"^",2)		//皮试标志
	.set:(myGrpSkinTest="Y") mySkinOERowID=myOEORIDR
	.set myGrpSub=0
	.for  set myGrpSub=$o(^OEORDi(0,"OEORI",+OEItmRowID,myOEORIDR,myGrpSub)) quit:(myGrpSub="")  do
	..set:(myGrpSkinTest'="Y") myGrpSkinTest=$p($g(^OEORD(+OEItmRowID,"I",myGrpSub,5)),"^",2)
	..set:(OEItmRowID=(+OEItmRowID_"||"_myGrpSub)) myGrpFlag="Y"
	..quit:(myGrpSkinTest'="Y")
	..quit:(mySkinOERowID'="")
	..set mySkinOERowID=+OEItmRowID_"||"_myGrpSub
	
	set:(myGrpFlag="N") mySkinOERowID=""
	set:(mySkinOERowID="") mySkinOERowID=OEItmRowID
	
	set myFlag=""
	set OrderRowid=+mySkinOERowID
	set itemSub=$p(mySkinOERowID,"||",2)
	
	//+2022-12-30 ZhYW 需皮试医嘱停止时，不再判断判断皮试状态
	set statDR=$p($g(^OEORD(OrderRowid,"I",itemSub,1)),"^",13)
	set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
	quit:(" V E "'[(" "_statCode_" ")) myFlag
	
	set myAdm=$p(^OEORD(+OrderRowid),"^",1)
	set myHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(myAdm)
	
	set mySkinTest=$p($g(^OEORD(OrderRowid,"I",itemSub,5)),"^",2)    //OEORI_AdministerSkinTest 
	quit:(mySkinTest'="Y") myFlag    //非皮试医嘱退出
	
	set mySkinRtn=$p($g(^OEORD(OrderRowid,"I",itemSub,11)),"^",3)    //OEORI_Abnormal 皮试结果
	quit:(mySkinRtn="N") myFlag
	
	set myEcptFlag=##class(PHA.FACE.OUT.Com).GetSkinTestExceptFlag(mySkinOERowID)   //控制例外的医嘱退出
	quit:(myEcptFlag="Y") myFlag
	
	set myOrdInstrRowid=$p($g(^OEORD(+OrderRowid,"I",itemSub,2)),"^",7)     //皮试用法
	set mySkinTestInstr=##class(web.DHCDocConfig).GetConfigNode("SkinTestInstr", myHospDR)
	if ((mySkinTestInstr'="") && (("^"_mySkinTestInstr_"^")[("^"_myOrdInstrRowid_"^"))) {    //皮试医嘱
		quit myFlag
	}
	
	//皮试医嘱中的原液和免试
	set myActionDR=$p($g(^OEORD(OrderRowid,"I",itemSub,11)),"^",21)		//OEORI_Action_DR->OEC_Action
	if (+myActionDR=0) {
		set myFlag="Y"    //皮试备注为空的不可以缴费
	}
	
	quit myFlag
}

/// Modify by ZhYW 2020-04-17
/// 1. 药房配置为控制例外的皮试医嘱，可以缴费
/// 2. 皮试医嘱配置了皮试用法，可以缴费
///    皮试医嘱非皮试用法且皮试备注为空，不能缴费
/// Debug: w ##class(web.UDHCOEORDOP4).ReadSkinRtnFlag2("2815||5")
ClassMethod ReadSkinRtnFlag2(OEItmRowID As %String) As %String
{
	set ^TMP("ReadSkinRtnFlag2")=OEItmRowID
	set mySkinOERowID=""			//皮试医嘱的rowId
	set myGrpFlag="N"				//表示本医嘱在此组标志
	set myOEORIDR=0
	for  set myOEORIDR=$o(^OEORDi(0,"OEORI",+OEItmRowID,myOEORIDR)) quit:((myOEORIDR="")||(myGrpFlag="Y"))  do
	.set mySkinOERowID=""			//皮试医嘱的rowId
	.set myGrpFlag="N"				//表示本医嘱在此组标志
	.set:(OEItmRowID=myOEORIDR) myGrpFlag="Y"			//如果是主医嘱，标志为成组医嘱
	.set myGrpSkinTest=$p($g(^OEORD(+myOEORIDR,"I",$p(myOEORIDR,"||",2),5)),"^",2)		//皮试标志
	.set:(myGrpSkinTest="Y") mySkinOERowID=myOEORIDR
	.set myGrpSub=0
	.for  set myGrpSub=$o(^OEORDi(0,"OEORI",+OEItmRowID,myOEORIDR,myGrpSub)) quit:(myGrpSub="")  do
	..set:(myGrpSkinTest'="Y") myGrpSkinTest=$p($g(^OEORD(+OEItmRowID,"I",myGrpSub,5)),"^",2)
	..set:(OEItmRowID=(+OEItmRowID_"||"_myGrpSub)) myGrpFlag="Y"
	..quit:(myGrpSkinTest'="Y")
	..quit:(mySkinOERowID'="")
	..set mySkinOERowID=+OEItmRowID_"||"_myGrpSub
	
	set:(myGrpFlag="N") mySkinOERowID=""
	set:(mySkinOERowID="") mySkinOERowID=OEItmRowID
	
	set myFlag=""
	set skinRtnDesc=""
	set OrderRowid=+mySkinOERowID
	set itemSub=$p(mySkinOERowID,"||",2)
	
	set myAdm=$p(^OEORD(+OrderRowid),"^",1)
	set myHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(myAdm)
	
	set mySkinTest=$p($g(^OEORD(OrderRowid,"I",itemSub,5)),"^",2)
	quit:(mySkinTest'="Y") $$GetRtn(myFlag, skinRtnDesc)    //非皮试医嘱退出
	
	set mySkinRtn=$p($g(^OEORD(OrderRowid,"I",itemSub,11)),"^",3)    //OEORI_Abnormal 皮试结果("":未做皮试，N:阴性，Y:阳性)
	quit:(mySkinRtn="N") $$GetRtn(myFlag, skinRtnDesc)
	
	set myEcptFlag=##class(PHA.FACE.OUT.Com).GetSkinTestExceptFlag(mySkinOERowID)   //控制例外的医嘱退出
	quit:(myEcptFlag="Y") $$GetRtn(myFlag, skinRtnDesc)

	set myOrdInstrRowid=$p($g(^OEORD(+OrderRowid,"I",itemSub,2)),"^",7)     //皮试用法
	set mySkinTestInstr=##class(web.DHCDocConfig).GetConfigNode("SkinTestInstr", myHospDR)
	if ((mySkinTestInstr'="") && (("^"_mySkinTestInstr_"^")[("^"_myOrdInstrRowid_"^"))) {    //皮试医嘱
		quit $$GetRtn(myFlag, skinRtnDesc)
	}
	
	set skinRtnDesc=$case(mySkinRtn, "Y":"皮试阳性医嘱，不能结算。", "":"未做皮试医嘱，请先做皮试。", :"")
	
	//皮试医嘱中的原液和免试
	set myActionDR=$p($g(^OEORD(OrderRowid,"I",itemSub,11)),"^",21)		//OEORI_Action_DR->OEC_Action
	if (+myActionDR=0) {
		set myFlag="Y"    //皮试备注为空的不可以缴费
	}
	
	quit $$GetRtn(myFlag, skinRtnDesc)

GetRtn(flag, desc)
	quit flag_"^"_desc
}

}
