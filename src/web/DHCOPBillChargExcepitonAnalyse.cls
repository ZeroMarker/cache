/// Creator:xiongwang
/// CreatDate:2018-03-10
/// Desc:门诊收费异常捕获分析
Class web.DHCOPBillChargExcepitonAnalyse Extends %RegisteredObject
{

/// Creator: xiongwang
/// CreatDate: 2018-03-10
/// Description: 记录结算医嘱数据及参数信息到进程Global
/// Input: AdmStr:结算就诊串,UserId:结算用户,UnBillOrdStr:不参与结算医嘱串,InsType,结算费别;PatPaySum,前台金额;ExpStr
/// Return: 
/// Debug: w ##class(web.DHCOPBillChargExcepitonAnalyse).SaveChargeOrdLog("3600","5","","4","1.00","122^49^^Y^F^^^0^4^^^^")
ClassMethod SaveChargeOrdLog(AdmStr, UserId, UnBillOrdStr, InsType, PatPaySum, ExpStr)
{
	set ^TMP("SaveChargeOrdLog")=$lb(AdmStr, UserId, UnBillOrdStr, InsType, PatPaySum, ExpStr)

	set GroupId=$p(ExpStr,"^",1)
	set CTLocId=$p(ExpStr,"^",2)
	set FarType=$p(ExpStr,"^",5)
	set AdmLGFlag=$p(ExpStr,"^",11)
	set HospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(CTLocId)
	set SessionStr=UserId_"^"_GroupId_"^"_CTLocId_"^"_HospId
	
	//循环就诊
	for i=1:1:$l(AdmStr,"^"){
		set AdmRowID=$p(AdmStr,"^",i)
		continue:(AdmRowID="")
		;取Adm保存的挂号优惠类别
		set RCDRowID=$p($g(^PAADM(AdmRowID,"DHC")),"^",25)
		;根据不同医院取价格
		set AdmDep=$p(^PAADM(AdmRowID),"^",4)
		set HospID=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmDep)
		;通过门诊收费结算query获取需结算医嘱
		set RSet=##class(%ResultSet).%New("web.DHCOPAdmFind:GetADMOrder")
		set Columns=RSet.GetColumnCount()
		set OrdItmStr=""
		set Rs=RSet.Execute(AdmRowID, InsType, UnBillOrdStr, SessionStr)
		while (RSet.Next()) {
			set OEOrdRowID=$g(RSet.Data("OrdRowId"))
			continue:(OEOrdRowID="")
			set BillFlag=$g(RSet.Data("OPOrdBillFlag"))
			continue:(BillFlag=0)	 //过滤不能缴费医嘱
			set OrdRowID=$p(OEOrdRowID,"||",1)
			set ItmSub=$p(OEOrdRowID,"||",2)
			//continue:(("^"_UnBillOrdStr_"^")[("^"_OEOrdRowID_"^"))					//不参与结算医嘱
			set RecDepDR=$p($g(^OEORD(+OrdRowID,"I",+ItmSub,3)),"^",6)
			set Billed=$p($g(^OEORD(OrdRowID,"I",ItmSub,3)),"^",5)
			set ItmStatDR=$p($g(^OEORD(OrdRowID,"I",ItmSub,1)),"^",13)
			set StatCode=$s((+ItmStatDR'=0):$p($g(^OEC("OSTAT",ItmStatDR)),"^",1),1:"")
			set StatDesc=$s((+ItmStatDR'=0):$p($g(^OEC("OSTAT",ItmStatDR)),"^",2),1:"")
			set InsTypeDR=##class(web.DHCBillCons1).GetCurrentOrdInsType(OEOrdRowID, InsType, HospId)
			set OEOrdRowID=OrdRowID_"||"_ItmSub
			set ArcimRowID=$p($g(^OEORD(OrdRowID,"I",ItmSub,1)),"^",2)
			set PackQty=+$g(RSet.Data("OPOrdQty"))
			set PackQty=$fn(PackQty,"N")
			set PackUom=$g(RSet.Data("OPOrdUnit"))
			set OrdPatPrice=+$g(RSet.Data("OPOrdPrice"))
			set OrdPatPrice=$fn(OrdPatPrice,"",6)
			set Amount=+$g(RSet.Data("OPOrdBillSum"))
			set Amount=$fn(Amount,"",2)
			set INCIDR=$o(^INCI(0,"ARCIM_DR",+ArcimRowID,""))				;INC_Itm->RowID
			set INCIQty=..GetINICQtyByOrdItm(OEOrdRowID)					;打包数量
			
			//保存数据到进程Global
			//医嘱项^库存项^医嘱状态^医嘱账单状态^医嘱费别^接收科室
			set Data=ArcimRowID_"^"_INCIDR_"^"_StatDesc_"^"_Billed_"^"_InsTypeDR_"^"_RecDepDR
			//数量^单价^单位^金额^打包数量
			set Data=Data_"^"_PackQty_"^"_OrdPatPrice_"^"_PackUom_"^"_Amount_"^"_INCIQty
			set ^||TMP("Charge",$j,"OrderItem",AdmRowID,OEOrdRowID,"ChargeLog")=Data
			set ^||TMP("Charge",$j,"ChargeLog","Count")=$i(^||TMP("Charge",$j,"ChargeLog","Count"))
		}
	}
	set ^||TMP("Charge",$j,"ChargeLog","InsType")=InsType		         ;结算费别
	set ^||TMP("Charge",$j,"ChargeLog","AdmStr")=AdmStr		             ;结算就诊
	set ^||TMP("Charge",$j,"ChargeLog","PatPaySum")=PatPaySum	         ;总费用
	set ^||TMP("Charge",$j,"ChargeLog","ExpStr")=UserId_"^"_ExpStr		 ;扩展串

	quit 0
}

/// Creator: xiongwang
/// CreatDate: 2018-03-10
/// Description: 记录结算后医嘱数据信息到进程Global
/// Input: PrtRowIDStr:结算后发票串 DHC_INVPRT
/// Return: 
/// Debug: w ##class(web.DHCOPBillChargExcepitonAnalyse).SaveReBillOrdLog("222763")
ClassMethod SaveReBillOrdLog(PrtRowIDStr As %String) As %String
{
	for i=1:1:$l(PrtRowIDStr,"^") {
		set PrtRowID=$p(PrtRowIDStr,"^",i)
		continue:(+PrtRowID=0)
		set PrtPatAmt=$p(^DHCINVPRT(PrtRowID),"^",16)
		set BCIRowID=0
		while($o(^DHCBCI(0,"INV",PrtRowID,BCIRowID))) {
			set BCIRowID=$o(^DHCBCI(0,"INV",PrtRowID,BCIRowID))
			set Bill=$p(^DHCBCI(BCIRowID),"^",2)
			set AdmDR=$p(^DHCBCI(BCIRowID),"^",3)
			set PBO=0
			while($o(^DHCPB(Bill,"O",PBO))) {
				set PBO=$o(^DHCPB(Bill,"O",PBO))
				set PBOData=$g(^DHCPB(Bill,"O",PBO))
				continue:(PBOData="")
				set ArcimDR=$p(PBOData,"^",3)
				set BillUomDR=$p($g(^ARCIM(+ArcimDR,1,8)),"^",14) 		;单位
				set Uom=$p($g(^CT("UOM",+BillUomDR)),"^",2)
				set INCIDR=$o(^INCI(0,"ARCIM_DR",+ArcimDR,""))
				set ArcimDesc=$p($g(^ARCIM(+ArcimDR,1,1)),"^",2)
				set OrdItem=$p(PBOData,"^",4)
				set BillFlag=$p($g(^OEORD(+OrdItem,"I",+$p(OrdItem,"||",2),3)),"^",5)
				set OrdStatusDR=$p($g(^OEORD(+OrdItem,"I",+$p(OrdItem,"||",2),1)),"^",13)
				set OrdStatCode=$p($g(^OEC("OSTAT",OrdStatusDR)),"^",1)
				continue:(" V E "'[(" "_OrdStatCode_" "))
				set OrdStatDesc=$p($g(^OEC("OSTAT",OrdStatusDR)),"^",2)
				set RecDepDR=$p($g(^OEORD(+OrdItem,"I",+$p(OrdItem,"||",2),3)),"^",6)
				set OrdInsType=$p($g(^OEORD($p(OrdItem,"||",1),"I",$p(OrdItem,"||",2),11)),"^",18)
				set ConFac=##class(web.DHCBillCommon).GetUomConvFactor(ArcimDR, OrdItem)
				set PackQty=$p(PBOData,"^",5)
				set PackQty=PackQty/ConFac
				set PackQty=$fn(PackQty,"N")
				set OrdBillQty=+$p(PBOData,"^",5)
				set OrdRefQty=+$p(PBOData,"^",6)
				set OrdUnitPrice=$p(PBOData,"^",7)
				set OrdUnitPrice=$fn((OrdUnitPrice*ConFac),"",6)
				set OrdPatShare=$p(PBOData,"^",11)
				set OrdPatShare=$fn(OrdPatShare,"",2)
				set INCIQty=..GetINICQtyByOrdItm(OrdItem)					//打包数量
				//保存数据到进程Global
				//医嘱项^库存项^医嘱状态^医嘱账单状态^医嘱费别^接收科室
				set Data=ArcimDR_"^"_INCIDR_"^"_OrdStatDesc_"^"_BillFlag_"^"_OrdInsType_"^"_RecDepDR
				//数量^单价^单位^金额^打包数量
				set Data=Data_"^"_PackQty_"^"_OrdUnitPrice_"^"_Uom_"^"_OrdPatShare_"^"_INCIQty
				set ^||TMP("Charge",$j,"OrderItem",AdmDR,OrdItem,"ReBillLog")=Data
				set ^||TMP("Charge",$j,"ReBillLog","Count")=$i(^||TMP("Charge",$j,"ReBillLog","Count"))	
			}
		}
		set ^||TMP("Charge",$j,"ReBillLog","PatShareAmt")=$g(^||TMP("Charge",$j,"ReBillLog","PatShareAmt"))+PrtPatAmt
	}
	
	quit 0
}

ClassMethod CopyReBillOrdLog(Job)
{
	kill ^TMPDHCOPBILL("Charge",Job)
	merge ^TMPDHCOPBILL("Charge",Job)=^||TMP("Charge",Job)
}

/// Creator: xiongwang
/// CreatDate: 2018-03-10
/// Description: 根据医嘱明细取打包数量
/// Input: OEOrdRowID:医嘱明细表 OE_OrdItem 表RowID
/// Return: 打包表DHC_OEDispensing数量
/// Debug: w ##class(web.DHCOPBillChargExcepitonAnalyse).GetINICQtyByOrdItm("222763")
ClassMethod GetINICQtyByOrdItm(OEOrdRowID)
{
	set Qty=0
	set ArcimRowID=$p($g(^OEORD(+OEOrdRowID,"I",$p(OEOrdRowID,"||",2),1)),"^",2)
	quit:(ArcimRowID="") Qty
	set INCIDR=$o(^INCI(0,"ARCIM_DR",+ArcimRowID,""))
	quit:(INCIDR="") Qty
	
	//配液中心药品取药房接口程序
	set OEFlag=$p($g(^OEORD(+OEOrdRowID,"I",$p(OEOrdRowID,"||",2),"DHC")),"^",16)
 	if (OEFlag="Y") {
	 	set Qty=##class(BILL.Interface.Inside.Invoke).GetEffectiveQtyForOPIVAS(OEOrdRowID)
	}else {
		set Dsp=0
		while($o(^DHCOEDISQTY(0,"OEORI",OEOrdRowID,Dsp))) {
			set Dsp=$o(^DHCOEDISQTY(0,"OEORI",OEOrdRowID,Dsp))
			set DspData=^DHCOEDISQTY(Dsp)
			set DspStatus=$p(DspData,"^",7)
			continue:(DspStatus="R")
			set DspQty=$p(DspData,"^",11)
			set Qty=Qty+DspQty
		}
	}
	
	quit $fn(Qty,"N")
}

/// Creator: xiongwang
/// CreatDate: 2018-03-10
/// Description: 查询结算前后记录的医嘱明细信息
/// Input: Job,进程号;Flag(ChargeLog结算前数据,ReBillLog结算后数据)
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCOPBillChargExcepitonAnalyse","FindOrdItem","11964","")
Query FindOrdItem(Job As %String, Flag As %String) As websys.Query(ROWSPEC = "TOrdItem1:%String,TArcimDesc1:%String,TINCIFlag1:%String,TOrdStatDesc1:%String,TBillFlag1:%String,TBBExtCode1:%String,TRecDepDesc1:%String,TOrdUnitPrice1:%String,TBillUOM1:%String,TPackQty1:%String,TOrdPatShare1:%String,TINCIQty1:%Float,TOrdItem2:%String,TArcimDesc2:%String,TINCIFlag2:%String,TOrdStatDesc2:%String,TBillFlag2:%String,TBBExtCode2:%String,TRecDepDesc2,TOrdUnitPrice2:%String,TBillUOM2:%String,TPackQty2:%String,TOrdPatShare2:%String,TINCIQty2:%String,TSame:%String")
{
}

ClassMethod FindOrdItemExecute(ByRef qHandle As %Binary, Job As %String, Flag As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindOrdItem")=$lb(Job, Flag)
    if (Job="")	quit $$$OK

    set AdmDR=""
    for  set AdmDR=$o(^TMPDHCOPBILL("Charge",Job,"OrderItem",AdmDR)) quit:(AdmDR="")  do
    .set OrdItem=""
    .for  set OrdItem=$o(^TMPDHCOPBILL("Charge",Job,"OrderItem",AdmDR,OrdItem)) quit:(OrdItem="")  do
    ..set (OrdItem1,ArcimDesc1,INCIFlag1,OrdStatDesc1,BillFlag1,BBExtCode1,RecDepDesc1,OrdUnitPrice1,BillUOM1,PackQty1,OrdPatShare1,INCIQty1)=""
    ..set (OrdItem2,ArcimDesc2,INCIFlag2,OrdStatDesc2,BillFlag2,BBExtCode2,RecDepDesc2,OrdUnitPrice2,BillUOM2,PackQty2,OrdPatShare2,INCIQty2)=""
    ..set OrdItem1=OrdItem,OrdItem2=OrdItem
    ..set ChargeOrd=$g(^TMPDHCOPBILL("Charge",Job,"OrderItem",AdmDR,OrdItem,"ChargeLog"))
    ..set ReBillOrd=$g(^TMPDHCOPBILL("Charge",Job,"OrderItem",AdmDR,OrdItem,"ReBillLog"))
    ..if (ChargeOrd'="")  do
    ...set ArcimDR=$p(ChargeOrd,"^",1)
    ...set ArcimDesc1=$p($g(^ARCIM(+ArcimDR,1,1)),"^",2)
    ...set INCIDR=$p(ChargeOrd,"^",2)
    ...set INCIFlag1=$s((INCIDR'=""):"是",1:"否")
    ...set OrdStatDesc1=$p(ChargeOrd,"^",3)
    ...set BillFlag1=$p(ChargeOrd,"^",4)
    ...set BillFlag1=$s((" TB B "[(" "_BillFlag1_" ")):"未收费",1:$case(BillFlag1,"P":"已收费","I":"待退费","R":"已退费",:""))
    ...set InsTypeDR=$p(ChargeOrd,"^",5)
    ...set BBExtCode1=$p($g(^PAC("ADMREA",+InsTypeDR)),"^",2)
    ...set RecDepDR=$p(ChargeOrd,"^",6)
	...set RecDepDesc1=$p($g(^CTLOC(+RecDepDR)),"^",2)
    ...set PackQty1=$p(ChargeOrd,"^",7)
    ...set OrdUnitPrice1=$p(ChargeOrd,"^",8)
    ...set BillUOM1=$p(ChargeOrd,"^",9)
    ...//set BillUOM1=$p(^CT("UOM",+BillUomDR),"^",2)
    ...set OrdPatShare1=$p(ChargeOrd,"^",10)
    ...set OrdPatShare1=$fn(OrdPatShare1,"",2)
    ...set INCIQty1=$p(ChargeOrd,"^",11)
    ..if (ReBillOrd'="") do
    ...set ArcimDR=$p(ReBillOrd,"^",1)
    ...set ArcimDesc2=$p($g(^ARCIM(+ArcimDR,1,1)),"^",2)
    ...set INCIDR=$p(ReBillOrd,"^",2)
    ...set INCIFlag2=$s((INCIDR'=""):"是",1:"否")
    ...set OrdStatDesc2=$p(ReBillOrd,"^",3)
    ...set BillFlag2=$p(ReBillOrd,"^",4)
    ...set BillFlag2=$s((" TB B "[(" "_BillFlag2_" ")):"未收费",1:$case(BillFlag2,"P":"已收费","I":"待退费","R":"已退费",:""))
    ...set InsTypeDR=$p(ReBillOrd,"^",5)
    ...set BBExtCode2=$p($g(^PAC("ADMREA",+InsTypeDR)),"^",2)
    ...set RecDepDR=$p(ReBillOrd,"^",6)
	...set RecDepDesc2=$p($g(^CTLOC(+RecDepDR)),"^",2)
    ...set PackQty2=$p(ReBillOrd,"^",7)
    ...set OrdUnitPrice2=$p(ReBillOrd,"^",8)
    ...set BillUOM2=$p(ReBillOrd,"^",9)
    ...set OrdPatShare2=$p(ReBillOrd,"^",10)
    ...set OrdPatShare2=$fn(OrdPatShare2,"",2)
    ...set INCIQty2=$p(ReBillOrd,"^",11)
    ..set Arg1=OrdItem1_"^"_ArcimDesc1_"^"_INCIFlag1_"^"_OrdStatDesc1_"^"_BillFlag1_"^"_BBExtCode1_"^"_RecDepDesc1_"^"_OrdUnitPrice1_"^"_BillUOM1_"^"_PackQty1_"^"_OrdPatShare1_"^"_INCIQty1
    ..set Arg2=OrdItem2_"^"_ArcimDesc2_"^"_INCIFlag2_"^"_OrdStatDesc2_"^"_BillFlag2_"^"_BBExtCode2_"^"_RecDepDesc2_"^"_OrdUnitPrice2_"^"_BillUOM2_"^"_PackQty2_"^"_OrdPatShare2_"^"_INCIQty2
    ..set Same=..CompareArg(Arg1, Arg2)
    ..do OutputOrdItem

	quit $$$OK
OutputOrdItem
	set Data=$lb(OrdItem1,ArcimDesc1,INCIFlag1,OrdStatDesc1,BillFlag1,BBExtCode1,RecDepDesc1,OrdUnitPrice1,BillUOM1,PackQty1,OrdPatShare1,INCIQty1,OrdItem2,ArcimDesc2,INCIFlag2,OrdStatDesc2,BillFlag2,BBExtCode2,RecDepDesc2,OrdUnitPrice2,BillUOM2,PackQty2,OrdPatShare2,INCIQty2,Same)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: xiongwang
/// CreatDate: 2018-03-10
/// Description: 根据进程号获取结算的就诊信息
/// Input: Job,进程号
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCOPBillChargExcepitonAnalyse","GetChargeAdmList",3492)
Query GetChargeAdmList(Job As %String) As websys.Query(ROWSPEC = "Tind:%String,TLocDesc:%String,TAdmDate:%String,TAdmTime:%String")
{
}

ClassMethod GetChargeAdmListExecute(ByRef qHandle As %Binary, Job As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
    if (Job="")  quit $$$OK
    
    set AdmStr=$g(^TMPDHCOPBILL("Charge",Job,"ChargeLog","AdmStr"))
    if (AdmStr="") quit $$$OK
    
	set Len=$l(AdmStr,"^")
	for i=1:1:Len {
		set Adm=$p(AdmStr,"^",i)
		continue:(Adm="")
		set LocDR=$p(^PAADM(Adm),"^",4)
		set LocDesc=$p($g(^CTLOC(+LocDR)),"^",2)
		set AdmDate=$p(^PAADM(Adm),"^",6)
		set AdmTime=$p(^PAADM(Adm),"^",7)
		set AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
		set AdmTime=##class(websys.Conversions).TimeLogicalToHtml(AdmTime, 1)
	   	do OutputAdmList
	}
	
	quit $$$OK
OutputAdmList
	set Data=$lb(ind,LocDesc,AdmDate,AdmTime)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: xiongwang
/// CreatDate: 2018-03-10
/// Description: 根据进程号获取结算及参数信息
/// Input: Job,进程号
/// Output: 前台医嘱条数^后台医嘱条数^数量差^前台金额^后台金额^差额^收费员^安全组^结算费别^^^^^^
/// Debug: w ##class(web.DHCOPBillChargExcepitonAnalyse).GetChargeBasePara(8272)
ClassMethod GetChargeBasePara(Job As %String)
{
	set InsTypeDR=$g(^TMPDHCOPBILL("Charge",Job,"ChargeLog","InsType"))
	set InsType=$p($g(^PAC("ADMREA",+InsTypeDR)),"^",2)
	set PayNum=$g(^TMPDHCOPBILL("Charge",Job,"ChargeLog","Count"))	
	set PaySum=$g(^TMPDHCOPBILL("Charge",Job,"ChargeLog","PatPaySum"))		;支付总费用
	set PatNum=$g(^TMPDHCOPBILL("Charge",Job,"ReBillLog","Count"))
	set PatShareAmt=$g(^TMPDHCOPBILL("Charge",Job,"ReBillLog","PatShareAmt"))
	set DNum=PayNum-PatNum
	set BalanceAmt=$fn((PaySum-PatShareAmt),"",2)
	set ExpStr=$g(^TMPDHCOPBILL("Charge",Job,"ChargeLog","ExpStr"))	
	set (User, Group)=""
	set UserID=+$p(ExpStr,"^",1)
	set:(UserID'=0) User=$p($g(^SSU("SSUSR",UserID)),"^",2)
	set GroupID=$p(ExpStr,"^",2)
	set:(GroupID'="") Group=$p($g(^SSU("SSGRP",GroupID)),"^",1)
	set CTLocDR=$p(ExpStr,"^",3)
	set RecLocStr="1"
	if ((GroupID'="")&&(CTLocDR'="")) {
		set HospID=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(CTLocDR)
		set RecLocStr=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(GroupID, HospID, CTLocDR)
	}
	if (RecLocStr'="") set RecLocFlag="部分"
	else  set RecLocFlag="全部"

	set Rtn="{""PaySum"":"""_PaySum_""""_","_"""PatShareAmt"":"""_PatShareAmt_""""_","_"""BalanceAmt"":"""_BalanceAmt_""""_","_"""User"":"""_User_""""_","_"""Group"":"""_Group_""""_","
	set Rtn=Rtn_"""PayNum"":"""_PayNum_""""_","_"""PatNum"":"""_PatNum_""""_","_"""DNum"":"""_DNum_""""_","_"""InsType"":"""_InsType_""""_","_"""RecLocFlag"":"""_RecLocFlag_"""}"
	quit Rtn
}

/// Creator: xiongwang
/// CreatDate: 2018-03-10
/// Description: 判断结算前后医嘱信息是否一致
/// Input: Job,进程号;OEOrdItem
/// Output: Y 一致,N 不一致
/// Debug: w ##class(web.DHCOPBillChargExcepitonAnalyse).CompareOrdItem(9692,"272||9")
ClassMethod CompareOrdItem(Job, OEOrdItem)
{
	set Adm=$p($g(^OEORD(+OEOrdItem)),"^",1)
	set ChargeLog=$g(^TMPDHCOPBILL("Charge",+Job,"OrderItem",+Adm,OEOrdItem,"ChargeLog"))
	set ReBillLog=$g(^TMPDHCOPBILL("Charge",+Job,"OrderItem",+Adm,OEOrdItem,"ReBillLog"))
	set Rtn=..CompareArg(ChargeLog, ReBillLog)
	quit Rtn
}

ClassMethod CompareArg(Arg1, Arg2)
{
	set Rtn="Y"
	set Len=$l(Arg1,"^")
	for i=1:1:Len {
		set Arg1Value=$p(Arg1,"^",i)
		set Arg2Value=$p(Arg2,"^",i)
		if (Arg1Value'=Arg2Value) {
			set Rtn="N"
			quit
		}
	}
	quit Rtn
}

/// Creator: xiongwang
/// CreatDate: 2018-03-10
/// Description: 根据进程号获取结算的就诊信息
/// Input: Job,进程号;OEOrdItem
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCOPBillChargExcepitonAnalyse","GetOrdItemProperty",8020,"264||4")
Query GetOrdItemProperty(Job As %String, OEOrdItem) As websys.Query(ROWSPEC = "Property:%String,ChargeValue:%String,ReBillValue:%String,Same:%String")
{
}

ClassMethod GetOrdItemPropertyExecute(ByRef qHandle As %Binary, Job As %String, OEOrdItem) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
    if ((Job="")||(OEOrdItem=""))  quit $$$OK
    
	set Adm=$p($g(^OEORD(+OEOrdItem)),"^",1)
	set Title="医嘱名称^是否库存^医嘱状态^账单状态^医嘱费别^接收科室^数量^单价^单位^金额^打包数量"
	set ChargeLog=$g(^TMPDHCOPBILL("Charge",+Job,"OrderItem",+Adm,OEOrdItem,"ChargeLog"))
	set ReBillLog=$g(^TMPDHCOPBILL("Charge",+Job,"OrderItem",+Adm,OEOrdItem,"ReBillLog"))
	if ($p(ChargeLog,"^",1)'="") do
	.set $p(ChargeLog,"^",1)=$p($g(^ARCIM(+$p(ChargeLog,"^",1),1,1)),"^",2)
	if ($p(ReBillLog,"^",1)'="") do
	.set $p(ReBillLog,"^",1)=$p($g(^ARCIM(+$p(ReBillLog,"^",1),1,1)),"^",2)

	if ($p(ChargeLog,"^",2)'="") set $p(ChargeLog,"^",2)="是"
	else  set $p(ChargeLog,"^",2)="否"
	if ($p(ReBillLog,"^",2)'="") set $p(ReBillLog,"^",2)="是"
	else  set $p(ReBillLog,"^",2)="否"
	
	/*
	if ($p(ChargeLog,"^",3)'="") do
	.set $p(ChargeLog,"^",3)=$p($g(^OEC("OSTAT",+$p(ChargeLog,"^",3))),"^",2)
	if ($p(ReBillLog,"^",3)'="") do
	.set $p(ReBillLog,"^",3)=$p($g(^OEC("OSTAT",+$p(ReBillLog,"^",3))),"^",2)
	*/
    if $p(ChargeLog,"^",4)="TB" set $p(ChargeLog,"^",4)="未收费"
    if $p(ChargeLog,"^",4)="B" set $p(ChargeLog,"^",4)="未收费"
    if $p(ChargeLog,"^",4)="P" set $p(ChargeLog,"^",4)="已收费"
    if $p(ChargeLog,"^",4)="I" set $p(ChargeLog,"^",4)="待退费"
    if $p(ChargeLog,"^",4)="R" set $p(ChargeLog,"^",4)="已退费"
    
    if $p(ReBillLog,"^",4)="TB" set $p(ReBillLog,"^",4)="未收费"
    if $p(ReBillLog,"^",4)="B" set $p(ReBillLog,"^",4)="未收费"
    if $p(ReBillLog,"^",4)="P" set $p(ReBillLog,"^",4)="已收费"
    if $p(ReBillLog,"^",4)="I" set $p(ReBillLog,"^",4)="待退费"
    if $p(ReBillLog,"^",4)="R" set $p(ReBillLog,"^",4)="已退费"

    if ($p(ChargeLog,"^",5)'="")  do
    .set $p(ChargeLog,"^",5)=$p($g(^PAC("ADMREA",+$p(ChargeLog,"^",5))),"^",2)
    if ($p(ReBillLog,"^",5)'="")  do
    .set $p(ReBillLog,"^",5)=$p($g(^PAC("ADMREA",+$p(ReBillLog,"^",5))),"^",2)
    
    if ($p(ChargeLog,"^",6)'="")  do
    .set RecDepDesc=$p($g(^CTLOC(+$p(ChargeLog,"^",6))),"^",2)
    .set $p(ChargeLog,"^",6)=RecDepDesc
    if ($p(ReBillLog,"^",6)'="")  do
    .set DepDesc=$p($g(^CTLOC(+$p(ReBillLog,"^",6))),"^",2)
    .set $p(ReBillLog,"^",6)=DepDesc
    /*
    if $p(ChargeLog,"^",9)'=""  do
    .set $p(ChargeLog,"^",9)=$p(^CT("UOM",+$p(ChargeLog,"^",9)),"^",2)
    if $p(ReBillLog,"^",9)'=""  do
    .set $p(ReBillLog,"^",9)=$p(^CT("UOM",+$p(ReBillLog,"^",9)),"^",2)
    */
    
    ;输出
    set Len=$l(Title,"^")
    for i=1:1:Len {
	    set Property=$p(Title,"^",i)
	    set ChargeValue=$p(ChargeLog,"^",i)
		set ReBillValue=$p(ReBillLog,"^",i)
		set Same=$s((ChargeValue=ReBillValue):"是",1:"否")
	   	do OutputProperty
    }
	quit $$$OK
OutputProperty
	set Data=$lb(Property,ChargeValue,ReBillValue,Same)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

}
