Class web.UDHCJFARREARSMANAGE Extends BILL.COM.Abstract
{

/// Debug: w ##class(web.UDHCJFARREARSMANAGE).CheckArrearsLevel("12","A","预警")
/// Debug: w ##class(web.UDHCJFARREARSMANAGE).CheckArrearsLevel(4601,"G","预警 部分控制 完全控制")
ClassMethod CheckArrearsLevel(adm As %String, type As %String, level As %String)
{
	quit:(adm="") 0
	set admType=$p($g(^PAADM(adm)),"^",2)
	quit:(" I E "'[(" "_admType_" ")) 0
	
	//+2023-02-20 ZhYW 判断是否"绿色通道"和"先诊疗后付费"
	set rtnValue=##class(BILL.COM.PAAdm).ChkGreenAndPayAfterTreatByAdm(adm, +$h, $p($h,",",2))
	set isGreen=$p(rtnValue,"^",1)           //是否"绿色通道"
	set isPayAfterTreat=$p(rtnValue,"^",2)   //是否"先诊疗后付费"
	set admCatCode=$s((isGreen=1):"01",1:"02")
	set admCatId=$o(^PAC("ADMCAT",0,"Code",admCatCode,0))
	if (admCatId="") {
		quit 0
	}
	if ((isGreen=1)&&("G"=type)) {
		quit 1
	}
    quit:("G"=type) 0

    set admLoc=$p($g(^PAADM(adm)),"^",4)
    set notCtrlLoc=..CheckLoc(admLoc)
    quit:(notCtrlLoc=1) 0    //0:控制，1:不控制
    
	quit:('$d(^DHCJFARREARS(0,"AdmReason",admCatId)))&&(type="G") 1
	set rtn=..CheckArrears(adm, "", "")
	quit:(rtn=0) 0
	
	set P2=$p(rtn,"^",2)
	set P4=$p(rtn,"^",4)
	quit:((type=P2)&&(level=P4)) 1
	
	quit 0
}

/// Creator: Lid
/// Creatdate: 2017-06-05
/// Description: 判断患者是否欠费
/// Input: (按顺序):AdmRowid, ordStr, flag, loginLocId
/// 		(1)	ordStr: 医嘱rowid串或金额
/// 			门急诊、急诊留观传医嘱rowid, 格式："医嘱明细记录$c(2)数量,不支持传医嘱串.
/// 			住院传执行记录rowid，格式："医嘱执行记录1$c(2)数量1^医嘱执行记录2$c(2)数量2^医嘱执行记录3^$c(2)数量3...")
/// 		(2)	flag:调用标志
/// 			OE:医生(传OE时，ordStr传金额),CR:药房,NE:护士,RIS:检查,LIS:检验
/// 		(3)	loginLocId:科室rowid
/// 			默认为空，一般为登录科室，用于欠费控制不受限科室功能。
/// 	Return: flag 或 P1^P2^P3^P4^P5^P6^P7^P8^P9
///  flag: 0不控制
///  P1：押金余额/押金总额
///  P2：A/D/G (按押金余额控制/按押金总额控制/绿色通道)
///  P3：控制等级rowid
///  P4：控制等级名称
///  P5：控制等级类型 W/C (预警/控制) 
///  P6：是否允许开医嘱Y/N(允许/不允许)
///  P7：是否允许执行医嘱 Y/N(允许/不允许)
///  P8：允许开医嘱的单价
///  P9：是否允许发药 Y/N(允许/不允许)
///  
///  注意：
///  P5=”W”预警，不控制
///       P5=”C”控制，P6=”N” 不允许开医嘱
///       P5=”C”控制，P7=”N” 不允许执行医嘱
///       P5=”C”控制，P9=”N” 不允许发药
/// Other: 
/// Debug: w ##class(web.UDHCJFARREARSMANAGE).CheckArrears("483","","","")
/// 	   w ##class(web.UDHCJFARREARSMANAGE).CheckArrears("1271","1164||1"_$c(2)_"1","NE","")
///        w ##class(web.UDHCJFARREARSMANAGE).CheckArrears("2096","250","OE","")
ClassMethod CheckArrears(adm As %String, str As %String, flag As %String, loginLocId As %String = "")
{
	set ^TMP("CheckArrears")=$lb(adm, str, flag, loginLocId)
    
  	quit:(adm="") 0
  	quit:'$d(^PAADM(adm)) 0
  	
	//判断科室是否要欠费控制，如配置了科室不欠费控制则不再判断其它配置。
	//0是控制，1:不控制。
	set checkLoc=..CheckLoc(loginLocId)
	quit:((loginLocId'="")&&(checkLoc=1)) 0
	
	set admType=$p(^PAADM(adm),"^",2)
	set visitStatus=$p(^PAADM(adm),"^",20)

	set oeitm=$p(str,$c(2),1)	   //有多条时也只判断第一条
	if ((admType'="I")&&($l(oeitm,"||")=2)) {
		set billed=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3),"^",5)    //医嘱已结算时不控制
		if (billed="P") {
			quit 0
		}
		set rtnValue=##class(DHCDoc.Interface.Inside.Service).GetPreCureAfterPayFlag(oeitm, "")
		set isPayAfterTreat=$p(rtnValue,"^",1)   //"Y": 先诊疗后付费
		set isStay=$p(rtnValue,"^",3)            //"Y": 押金模式的急诊留观
		if (isPayAfterTreat="N") {
			if (flag'="OE") {
				quit "^^^^C^^N^^N"         //非急诊留观未结算时执行科室控制
			}
		}
	}
	
	//+2023-03-07 ZhYW
	if ((admType="I")&&(visitStatus'="P")) {
		set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		set patBedInfo=##class(BILL.Interface.Inside.Invoke).GetIPAssignedBedDate(adm)
		set bedDate=$p(patBedInfo,"^",1)   //分床日期
		set bedTime=$p(patBedInfo,"^",2)   //分床时间
		if (bedDate="") {
			set isCtrl=..IsCtrlUnAssBed(hospDR)
			quit:(isCtrl=0) 0   //未分床患者不受欠费控制
		}else {
			set cfgHours=..GetCtrlAssBedStHours(hospDR)
			quit:($SYSTEM.SQL.DATEDIFF("ss", bedDate_","_bedTime, $h)<(+cfgHours*60*60)) 0
		}
	}
	
	//婴儿的欠费控制判断母亲的费用和预交金
	set motherAdm=$p(^PAADM(adm),"^",75)
	if (motherAdm'="") {
		set adm=motherAdm
	}
	quit:((adm="")||('$d(^PAADM(adm)))) 0

	set arrrowid=..GetAdmArrears(adm)
	quit:(+arrrowid'>0) 0
	
	kill mPLIST, pPLIST
	set rtn=..GetArrearsVal(arrrowid, .mPLIST)
	quit:(+rtn) 0
	
	set arcimStr=..GetArcim(str, flag)

	set billamount=..GetAdmBillAmount(adm, str)
	set orderamount=..GetOderAmount(adm, str, flag)
	set totalamount=billamount+orderamount
	//set totalamount=..GetAdmTotalAmount(adm)

	set deposit=..GetDeposit(adm)
	set warrAmt=..GetWarrAmt(adm)
	//set balance=deposit+warrAmt-totalamount

	//将婴儿的费用算到一起
	set cldAdm=0
	while($o(^PAADMi("Mother",adm,cldAdm))) {
		set cldAdm=$o(^PAADMi("Mother",adm,cldAdm))
		set cldAdmType=$p(^PAADM(cldAdm),"^",2)
		continue:(" I E "'[(" "_cldAdmType_" "))
		set babyTotalAmt=..GetAdmBillAmount(cldAdm)
		set babyDeposit=..GetDeposit(cldAdm)
		set babyWarrAmt=..GetWarrAmt(cldAdm)
		//set babyBalance=babyDeposit+babyWarrAmt-babyTotalAmt
		set totalamount=totalamount+babyTotalAmt
		set deposit=deposit+babyDeposit
		set warrAmt=warrAmt+babyWarrAmt
		//set balance=balance+babyBalance
	}
	
	set typelen=$l(mPLIST(0),"^")
	for i=1:1:typelen {
		set arrtype=$p(mPLIST(0),"^",i)
		continue:(arrtype="")
		set n=""
		while($o(mPLIST(arrtype,n))) {
			set n=$o(mPLIST(arrtype,n))
			set arrData=$g(mPLIST(arrtype,n))
			set levelrowid=$p(arrData,"^",1)
			set operator1=$p(arrData,"^",2)
			set value1=$p(arrData,"^",3)
			set operator2=$p(arrData,"^",4)
			set value2=$p(arrData,"^",5)
			set feeRate=+$p(arrData,"^",6)   //modify 2011-01-14 增加按总费用和比例相乘后的金额计算费用与预交金比较
			if (feeRate=0) set feeRate=1
			set totalamount1=totalamount*feeRate
			set totalamount1=$fn(totalamount1,"",2)
			set balance=deposit+warrAmt-totalamount1
			set value=$case(arrtype,"A":balance,:deposit)   //"A":balance, "D":deposit
			set value=$fn(value,"",2)
			set rtn=..CheckValue(value, operator1, value1, operator2, value2)
			if (rtn=1) {
				set tmpStr=..GetArrearsLevelVal(levelrowid)
				set pPLIST(arrtype)=value_"^"_arrtype_"^"_levelrowid_"^"_tmpStr_"^"_totalamount1
			}
		}
	}

	set typeflag=""
	if ($g(pPLIST("A"))'="")&&($g(pPLIST("D"))'="") {
		if ((" "_$p(pPLIST("D"),"^",4)_" C ")[(" "_$p(pPLIST("A"),"^",4)_" ")) {
			set typeflag="A"
		}elseif ($p(pPLIST("D"),"^",4)="C") {
			set typeflag="D"
		}
	}
	
	set myrtn=0
	if (typeflag'="") set myrtn=pPLIST(typeflag)
	if ($g(pPLIST("A"))'="") set myrtn=pPLIST("A")
	if ($g(pPLIST("D"))'="") set myrtn=pPLIST("D")

	//Lid 2014-12-25 由于医生站组调用时传的str是金额，所以要单独调用CheckOrderE接口,
	//护士站、药房传的医嘱执行记录串，可以不用再单独调用CheckOrderE接口.
	if (flag'="OE") {
		set clevelrowid=$p(myrtn,"^",3)
		set control=$p(myrtn,"^",5)
		set isOrder=$p(myrtn,"^",6)
		set isExecute=$p(myrtn,"^",7)
		set isDispensing=$p(myrtn,"^",9)
		set isFlag=$case(flag, "CR":"PHA", "NE":"EXE", :"")
		set isControl=..CheckOrderEByArcimStr(adm, clevelrowid, arcimStr, isFlag)
		if ((control="C")&&(flag="NE")&&(isExecute="Y")) {
			if ((isControl=0)&&(arcimStr'="")) {
				set $p(myrtn,"^",7)="N"
			}
		}
		if (control="C")&&(flag="CR")&&(isDispensing="Y") {
			if ((isControl=0)&&(arcimStr'="")) {
				set $p(myrtn,"^",9)="N"
			}
		}
	}
	
	quit myrtn
}

/// Description: 判断金额是否是设定的区间
/// Debug: w ##class(web.UDHCJFARREARSMANAGE).CheckValue("-619.00","<","500",">=","0")
ClassMethod CheckValue(value, operator1, value1, operator2, value2)
{
	set rtn=0
	quit:((operator1="")||(operator2="")) rtn
	quit:((value1="")||(value2="")) rtn
	set value1=+value1, value2=+value2, value=+value
	quit:(value1>value2) rtn
	quit:((operator1=">=")&&(value<value1)) rtn
	quit:((operator1=">")&&(value'>value1)) rtn
	quit:((operator2="<=")&&(value>value2)) rtn
	quit:((operator2="<")&&(value'<value2)) rtn
	quit 1
}

/// Modify: ZhYW 2022-07-21
/// Description: 取已经账单的患者自付费用
/// Debug: w ##class(web.UDHCJFARREARSMANAGE).GetAdmBillAmount("1682")
ClassMethod GetAdmBillAmount(adm As %String, str As %String = "") As %String
{
	set totalAmt=0
	
  	set admType=$p($g(^PAADM(adm)),"^",2)
  	//住院患者费用从账单取
  	if (admType="I") {
	  	quit $$GetBillAmt()
	}
	//押金模式的急诊留观费用从账单取
	if (admType="E") {
		set isStay=..GetPatAdmStayStat(adm)
		if (isStay="Y") {
			quit $$GetBillAmt()
		}
	}
	
	quit $$GetPendPayAmt()   //普通门、急诊根据未结算医嘱实时计算
	
GetBillAmt()
	set pb=0
	while($o(^DHCPB(0,"ADM",adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",adm,pb))
		set pbData=$g(^DHCPB(pb))
		continue:(pbData="")
		set payedFlag=$p(pbData,"^",16)
		continue:(payedFlag="P")
		set amt=+$p(pbData,"^",12)
		set totalAmt=$i(totalAmt,amt)
	}
	quit $fn(totalAmt,"",2)
	
GetPendPayAmt()
	//普通门、急诊根据未结算医嘱实时计算
	set ord=$o(^OEORD(0,"Adm",adm,0))
	quit:(ord="") totalAmt
	set hospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	set itm=""
	while($o(^OEORD(ord,"I",itm),-1)) {
		set itm=$o(^OEORD(ord,"I",itm),-1)
		continue:('$d(^OEORD(ord,"I",itm,1)))
		set oeitm=ord_"||"_itm
		continue:(("^"_str_$c(2))[("^"_oeitm_$c(2)))  //过滤当前传入医嘱，传入医嘱单独计算
		continue:(##class(web.UDHCOEORDOP1).ReadOECPriorityFlag(oeitm)=1)      //自备药医嘱退出
		set billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)
		continue:(" P I "[(" "_billed_" "))
		set statDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
		set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
		continue:(" V E "'[(" "_statCode_" "))
		set insTypeDR=$p($g(^OEORD(+ord,"I",itm,11)),"^",18)     //OEORI_BBExtCode
		set costAmtStr=##class(BILL.OP.COM.Method).GetPendPayOrdItmCost(oeitm, insTypeDR, hospId)
		set itmAmt=$p(costAmtStr,"^",1)
		set totalAmt=$i(totalAmt, itmAmt)
	}
	quit $fn(totalAmt,"",2)
}

/// 取多个医嘱的患者自付费用总计
ClassMethod GetOderAmount(adm As %String, str As %String, flag As %String) As %String
{
	quit:(str="") 0
	quit:(flag="OE") +str
	set totalamount=0
	set priceDate=+$h
	set admType=$p(^PAADM(adm),"^",2)
	set RCDRowID=$p($g(^PAADM(adm,"DHC")),"^",25)
	set epiSubType=$p(^PAADM(adm,1),"^",6)
	set admreason=$p(^PAADM(adm,1),"^",7)
	set hospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	set len=$l(str,"^")
	for i=1:1:len {
		set tmpStr=$p(str,"^",i)
		set oeore=$p(tmpStr,$c(2),1)
		set qty=+$p(tmpStr,$c(2),2)
		set oeprice=$p(tmpStr,$c(2),3)
		//+2018-09-05 ZhYW
		set regLoc=""
		set oeitm=""
		set OEExecRowID=""
		continue:(flag'="OE")&&(oeore'["||")
		if (admType="I") {
			set billed=$p($g(^OEORD(+oeore,"I",$p(oeore,"||",2),"X",$p(oeore,"||",3))),"^",6)
		} else {
			set billed=$p(^OEORD(+oeore,"I",$p(oeore,"||",2),3),"^",5)
		}
	 	continue:(billed="B")
	 	if (flag'="OE") {
		 	continue:('$d(^OEORD(+oeore,"I",$p(oeore,"||",2),1)))
		 	continue:($d(^DHCPBi(0,"OEORI",oeore)))
		 	set arcim=$p(^OEORD(+oeore,"I",$p(oeore,"||",2),1),"^",2)
			set oeprice=$p(^OEORD(+oeore,"I",$p(oeore,"||",2),3),"^",25)
			set oeitm=$p(oeore,"||",1,2)
			if ($l(oeore,"||")=3) set OEExecRowID=oeore
		}else {
			set arcim=oeore
		}
		set itmPriceExpStr=RCDRowID_"^"_oeitm_"^"_OEExecRowID_"^"_adm_"^"_regLoc_"^"_""
		set price=##class(web.UDHCJFPRICE).GetOrderPrice(epiSubType, admreason, arcim, priceDate, "", "", "", oeprice, hospId, itmPriceExpStr)
		set patprice=$p(price,"^",4)
		set amt=qty*patprice
		set amt=$fn(amt,"",2)
		set totalamount=$i(totalamount, amt)
	}

	quit $fn(totalamount,"",2)
}

/// Description: 取非医保患者实际发生的自付费用
ClassMethod GetAdmTotalAmount(adm As %String) As %String
{
	set billamt=..GetAdmBillAmount(adm)
	set amtstr=..GetAdmAmtThreeDays(adm)
	set amt1=+$p(amtstr,"^",1)
	set amt2=+$p(amtstr,"^",2)
	set totalamt=billamt+amt1-amt2
  	quit totalamt
}

/// Description: 取患者3天内的已执行未计费和已计费未执行的自付费用
ClassMethod GetAdmAmtThreeDays(adm As %String) As %String
{
	set amt1=0, amt2=0
	quit:(adm="") amt1_"^"_amt2
	quit:'$d(^PAADM(adm)) amt1_"^"_amt2
	set oeord=$o(^OEORD(0,"Adm",adm,""))
	quit:(oeord="") amt1_"^"_amt2
	quit amt1_"^"_amt2
}

/// Description: 取患者未结算的押金总额
ClassMethod GetDeposit(adm As %String) As %String
{
	set stayFlag=..GetPatAdmStayStat(adm)   //+2015-02-13 hujunbin 判断是否留观，获取留观押金
	if (stayFlag="Y") {
		set depInfo=##class(web.DHCOPBillEPManageCLS).getCurrAcountID(adm)
		set depositAmt=+$p(depInfo,"^",3)
	}else {
		set depositAmt=##class(web.UDHCJFBaseCommon).deposit(adm)
	}
  	quit depositAmt
}

/// Description: 取患者有效的担保金额
ClassMethod GetWarrAmt(adm As %String) As %String
{
	set admType=$p(^PAADM(adm),"^",2)
	set rtn=##class(web.DHCBillInterface).IGetWarramt(adm, admType)
	set warrFlag=$p(rtn,"^",1)
	set warrAmt=$p(rtn,"^",2)
	if (warrFlag'="Y") set warrAmt=0
	quit warrAmt
}

/// Description: 取患者有效的欠费管理设置
/// Table: DHC_JFArrears
/// Debug: w ##class(web.UDHCJFARREARSMANAGE).GetAdmArrears(357)
ClassMethod GetAdmArrears(adm As %String) As %String
{
	quit:(adm="") -100
	quit:'$d(^PAADM(adm)) -100
	
	//+2023-02-20 ZhYW 判断是否"绿色通道"和"先诊疗后付费"
	set rtnValue=##class(BILL.COM.PAAdm).ChkGreenAndPayAfterTreatByAdm(adm, +$h, $p($h,",",2))
	set isGreen=$p(rtnValue,"^",1)           //是否"绿色通道"
	set isPayAfterTreat=$p(rtnValue,"^",2)   //是否"先诊疗后付费"
	set admCatCode=$s((isGreen=1):"01",1:"02")
	set admCatId=$o(^PAC("ADMCAT",0,"Code",admCatCode,0))
	
	set admType=$p(^PAADM(adm),"^",2)
	if (admType'="I") {
		set isStay=..GetPatAdmStayStat(adm)      //是否押金模式急诊留观
		if ((isStay'="Y")&&(isPayAfterTreat'=1)) {
			quit 0                    //非急诊留观且非"先诊疗后付费"的退出
		}
	}
	
	if (admCatId="") {
		set admCatId=$o(^PAC("ADMCAT",0,"Code",$$ALPHAUP^SSUTIL4("02"),0))   //默认"非绿色通道"
	}
	quit:(admCatId="") 0
  	
	set admreason=$p(^PAADM(adm,1),"^",7)
	set epiSubType=$p(^PAADM(adm,1),"^",6)
	set visitStatus=$p(^PAADM(adm),"^",20)    //+2018-07-27 ZhYW
	if (visitStatus="P") {
		set admType=visitStatus
	}
	set admLoc=$p(^PAADM(adm),"^",4)
	set ward=$p(^PAADM(adm),"^",70)
	set mrAdm=$p(^PAADM(adm),"^",61)
	set dia=$s((mrAdm'=""):$o(^MR(mrAdm,"DIA",0,"Link","")),1:"")
	set diaCat=$s((dia'=""):$o(^DHCDiagnosCatI("0","Diagose",dia,"")),1:"")
	
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	
	//+tangzf 2023-02-09 未医保登记的患者按自费校验
    set insuRegCfg=..GetArrearInsuRegCfg(adm, hospDR)
    if (insuRegCfg=1) set admreason=1
    
	set cfgId=##class(web.DHCBillCommon).GetTarParaId(hospDR)
	if (cfgId'="") {
		if (admreason="") set admreason=$p($g(^DHCTarC("CF",cfgId)),"^",3)
		if (epiSubType="") set epiSubType=$p($g(^DHCTarC("CF",cfgId)),"^",2)
	}
	quit:(admreason="") 0
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_Arrears", hospDR)
	kill arrAry
	set rowid=0
	while($o(^DHCJFARREARS("0","AdmReason",admCatId,admreason,rowid))) {
		set rowid=$o(^DHCJFARREARS("0","AdmReason",admCatId,admreason,rowid))
		set arrData=$g(^DHCJFARREARS(rowid))
		set arrHospDR=$p(arrData,"^",20)
		continue:(arrHospDR'=defHospId)
		set eps=$p(arrData,"^",19)
		continue:((eps'="")&&(eps'=epiSubType))
		set arrType=$p(arrData,"^",4)
		continue:((arrType'="")&&(arrType'=admType))
		set arrDiaCat=$p(arrData,"^",5)
		continue:((arrDiaCat'="")&&(arrDiaCat'=diaCat))
		set arrLoc=$p(arrData,"^",6)
	 	set arrWard=$p(arrData,"^",7)
		continue:((arrLoc'="")&&(arrWard'="")&&((arrWard'=ward)||(arrLoc'=admLoc)))
		continue:((arrLoc'="")&&(arrWard="")&&(arrLoc'=admLoc))
		continue:((arrLoc="")&&(arrWard'="")&&(arrWard'=ward))
		set arrAry("AdmRea",admreason)=rowid
		if (eps'="") {
			set arrAry("EPS",eps)=rowid
		}
		if (arrType'="") {
			set arrAry("AdmType",arrType)=rowid
		}
		if (arrLoc'="") {
			set arrAry("Loc",arrLoc)=rowid
		}
		if (arrWard'="") {
			set arrAry("Ward",arrWard)=rowid
		}
	}
  	
  	//优先级：病区->科室->就诊类型->就诊子类->费别
	set arrears=0
  	if (ward'="") {
	  	set arrears=$g(arrAry("Ward",ward))
	  	quit:(arrears>0) arrears
	}
  	
  	if (admLoc'="") {
	  	set arrears=$g(arrAry("Loc",admLoc))
	  	quit:(arrears>0) arrears
	}
  	
  	if (admType'="") {
	  	set arrears=$g(arrAry("AdmType",admType))
	  	quit:(arrears>0) arrears
	}
  	
  	if (epiSubType'="") {
		set arrears=$g(arrAry("EPS",epiSubType))
  		quit:(arrears>0) arrears
	}
  	
  	set arrears=+$g(arrAry("AdmRea",admreason))
	quit arrears
}

/// Table: DHC_JFArrearsMoney
/// Description: 取欠费管理设置的值
/// Debug: w ##class(web.UDHCJFARREARSMANAGE).GetArrearsVal(199, "")
ClassMethod GetArrearsVal(rowid As %String, ByRef mPLIST) As %String
{
	quit:(rowid="") 100
	quit:'$d(^DHCJFARREARS(rowid)) 100
	quit:'$d(^DHCJFARREARS(0,"AM",rowid)) 100
	
	set mPLIST(0)=""
	set type=""
	while($o(^DHCJFARREARS(0,"AM",rowid,type))'="") {
		set type=$o(^DHCJFARREARS(0,"AM",rowid,type))
		set mPLIST(0)=mPLIST(0)_"^"_type
		set seq=0
		set al=0
		while($o(^DHCJFARREARS(0,"AM",rowid,type,al))) {
			set al=$o(^DHCJFARREARS(0,"AM",rowid,type,al))
			set sub=$o(^DHCJFARREARS(0,"AM",rowid,type,al,""))
			set str=$g(^DHCJFARREARS(rowid,"M",sub))
			set str1=$p(str,"^",3,6)
			set feeRate=$p(str,"^",17)   //modify 2011-01-14 增加费用比例取值
			set mPLIST(type,$i(seq))=al_"^"_str1_"^"_feeRate
		}
	}
	
	quit 0
}

/// Description: 取欠费等级的值
ClassMethod GetArrearsLevelVal(rowid As %String) As %String
{
	quit:(rowid="") 100
	quit:'$d(^DHCJFARREARSLEVEL(rowid)) 100
	set str=$g(^DHCJFARREARSLEVEL(rowid))
	set Name=$p(str,"^",1)
	set JFALType=$p(str,"^",3)
	set OrdEntry=$p(str,"^",4)
	set OrdExec=$p(str,"^",5)
	set DrugFlag=$p(str,"^",6)
	set LimitPrice=$p(str,"^",7)
	set tmpStr=Name_"^"_JFALType_"^"_OrdEntry_"^"_OrdExec_"^"_LimitPrice_"^"_DrugFlag
	
	quit tmpStr
}

/// Table: DHC_JFArrearsOrdCat
/// Description: 取控制等级内的医嘱大类和医嘱子类
ClassMethod GetOrdCatStr(rowid As %String) As %String
{
	quit:(rowid="") 100
	quit:'$d(^DHCJFARREARSLEVEL(rowid)) 100
	quit:'$d(^DHCJFARREARSLEVEL(rowid,"O")) ""
	
	set ordCatStr="", ordSubCatStr=""
	
	set sub=0
	while($o(^DHCJFARREARSLEVEL(rowid,"O",sub))) {
		set sub=$o(^DHCJFARREARSLEVEL(rowid,"O",sub))
		set subData=$g(^DHCJFARREARSLEVEL(rowid,"O",sub))
		set ordcat=$p(subData,"^",1)
		set ordsubcat=$p(subData,"^",2)
		if (ordcat'="") set ordCatStr=ordCatStr_"^"_ordcat
		if (ordsubcat'="") set ordSubCatStr=ordSubCatStr_"^"_ordsubcat
	}
	
	quit:((ordCatStr="")&&(ordSubCatStr="")) ""
	
	quit ordCatStr_$c(2)_ordSubCatStr
}

/// Creator: Lid
/// CreatDate: 2014-12-24
/// Description: 取医嘱项指针
///              orderStr格式："医嘱执行记录1$c(2)数量1^医嘱执行记录2$c(2)数量2^医嘱执行记录3^$c(2)数量3..."
/// Other: 注意：医生站传过来的orderStr是所开医嘱的金额
ClassMethod GetArcim(orderStr As %String, flag As %String) As %String
{
	set arcimStr=""
	quit:(orderStr="") arcimStr
	quit:(flag="OE") arcimStr
	set orderLen=$l(orderStr,"^")
	for i=1:1:orderLen {
		set tmp=$p(orderStr,"^",i)
		set oeore=$p(tmp,$c(2),1)
		set arcim=$p(^OEORD(+oeore,"I",$p(oeore,"||",2),1),"^",2)
		set arcimStr=$s((arcimStr=""):arcim,1:(arcimStr_"^"_arcim))
	}
	quit arcimStr
}

/// Creator: Lid
/// CreatDate: 2014-12-24
/// Description: 0: 不允许开医嘱, 1: 允许开医嘱
/// Debug: w ##class(web.UDHCJFARREARSMANAGE).CheckOrderEByArcimStr("2096","35","OE","")
ClassMethod CheckOrderEByArcimStr(adm As %String, cLevelRowID As %String, arcimStr As %String, execFlag As %String = "") As %String
{
	quit:(cLevelRowID="") 0
	quit:(arcimStr="") 0
	
	set rtn=1
	set arcimLen=$l(arcimStr,"^")
	for i=1:1:arcimLen {
		set arcim=$p(arcimStr,"^",i)
		set isControl=..CheckOrderE(adm, cLevelRowID, arcim, execFlag)
		set rtn=isControl
		quit:(rtn=0)
	}
	quit rtn
}

/// 判断医嘱在某控制级别内可否开医嘱或执行医嘱
/// Lid 2014-12-16 修改，去掉医嘱反选功能
/// Debug: w ##class(web.UDHCJFARREARSMANAGE).CheckOrderE(2,"1034||1","")
ClassMethod CheckOrderE(adm As %String, rowid As %String, arcim As %String, execFlag As %String = "") As %String
{
	quit:((adm="")||(rowid="")||(arcim="")) 0
	quit:'$d(^ARCIM(+arcim,1,1)) 0
	
	set rtn=..GetOrdCatStr(rowid)
	quit:(rtn=100) 1
	set ordcatstr=$p(rtn,$c(2),1)
	set ordsubcatstr=$p(rtn,$c(2),2)

	set str=$g(^DHCJFARREARSLEVEL(rowid))
    set JFALType=$p(str,"^",3)
    set OrdEntry=$p(str,"^",4)
    set OrdExec=$p(str,"^",5)
    set PhaDisp=$p(str,"^",6)
 	set LimitPrice=$p(str,"^",7)
	quit:(JFALType'="C") 1
	//quit:(OrdEntry'="Y") 0
	quit:((OrdEntry'="Y")&&(execFlag="")) 0
	quit:((OrdExec'="Y")&&(execFlag="EXE")) 0
	quit:((PhaDisp'="Y")&&(execFlag="PHA")) 0
	
	set RCDRowID=$p($g(^PAADM(adm,"DHC")),"^",25)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	set regLoc=""
	set itmPriceExpStr=RCDRowID_"^"_""_"^"_""_"^"_adm_"^"_regLoc_"^"_arcim
	set arcimprice=+##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcim, +$h, "", "", "", "", hospDR, itmPriceExpStr)
	quit:((LimitPrice'="")&&(arcimprice>+LimitPrice)) 0
	
	//set ordCatReverse=$p(^DHCJFARREARSLEVEL(rowid),"^",9)
	//quit:((ordCatReverse="N")&&(rtn="")) 1
	//quit:((ordCatReverse="Y")&&(rtn="")) 0
	
	set arcsubcat=$p(^ARCIM(+arcim,1,1),"^",10)
	set arccat=$p(^ARC("IC",arcsubcat),"^",8)
	
	//quit:((ordCatReverse="N")&&(ordcatstr'="")&&(("^"_ordcatstr_"^")[("^"_arccat_"^"))) 1
	//quit:((ordCatReverse="N")&&(ordsubcatstr'="")&&(("^"_ordsubcatstr_"^")[("^"_arcsubcat_"^"))) 1
	//quit:((ordCatReverse="Y")&&(ordcatstr'="")&&(("^"_ordcatstr_"^")'[("^"_arccat_"^"))) 1
	//quit:((ordCatReverse="Y")&&(ordsubcatstr'="")&&(("^"_ordsubcatstr_"^")'[("^"_arcsubcat_"^"))) 1
	
	quit:(rtn="") 1
	quit:((ordcatstr'="")&&(("^"_ordcatstr_"^")'[("^"_arccat_"^"))) 1
	quit:((ordsubcatstr'="")&&(("^"_ordsubcatstr_"^")'[("^"_arcsubcat_"^"))) 1
	
	quit 0
}

/// Debug: w ##class(web.UDHCJFARREARSMANAGE).GetWarningValue(124)
ClassMethod GetWarningValue(adm As %String) As %String
{
	set warningValue=0
	set arrrowid=..GetAdmArrears(adm)
	quit:(+arrrowid'>0) 0
	
	kill mPLIST, pPLIST
	set rtn=..GetArrearsVal(arrrowid, .mPLIST)
  	quit:(+rtn) 0
  	
	set typelen=$l(mPLIST(0),"^")
	for i=1:1:typelen {
		set arrtype=$p(mPLIST(0),"^",i)
		continue:(arrtype="")
		set n=""
		while($o(mPLIST(arrtype,n))) {
			set n=$o(mPLIST(arrtype,n))
			set arrData=$g(mPLIST(arrtype,n))
			set levelrowid=$p(arrData,"^",1)
			set operator1=$p(arrData,"^",2)
			set value1=$p(arrData,"^",3)
			set operator2=$p(arrData,"^",4)
			set value2=$p(arrData,"^",5)
			set tmpStr=..GetArrearsLevelVal(levelrowid)
			set contype=$p(tmpStr,"^",2)
			if ((arrtype="A")&&(contype="W")) set warningValue=value2
		}
	}
	
	quit warningValue
}

/// Description: 判断科室是否受欠费控制
/// Return: 0:控制，1:不控制
/// Debug: w ##class(web.UDHCJFARREARSMANAGE).CheckLoc(124)
ClassMethod CheckLoc(loc As %String) As %String
{
	set flag=0
	quit:(loc="") flag
	quit:'$d(^CTLOC(loc)) flag
	set hospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(loc)
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_ArrearsLocExcept", hospId)
	
	set locExcId=""
	set id=0
	while($o(^DHCJFARREARSLOCEXCEPT(0,"LOC",loc,id))) {
		set id=$o(^DHCJFARREARSLOCEXCEPT(0,"LOC",loc,id))
		set data=$g(^DHCJFARREARSLOCEXCEPT(id))
		set hospDR=$p(data,"^",7)
		continue:(hospDR'=defHospId)
		set locExcId=id
		quit
	}
	quit:(locExcId="") flag
	
	set locExcData=$g(^DHCJFARREARSLOCEXCEPT(locExcId))
	set stDate=$p(locExcData,"^",2)
	set endDate=$p(locExcData,"^",3)
	quit:((stDate'="")&&(stDate>+$h)) flag
	quit:((endDate'="")&&(endDate<+$h)) flag
	
	quit 1
}

ClassMethod CheckNursePDALevel(adm As %String) As %String
{
	quit:(adm="") 0
	quit:'$d(^PAADM(adm)) 0
	
	set rtn=0
	set ord=$o(^OEORD(0,"Adm",adm,0))
	set itm=0
	while($o(^OEORD(ord,"I",itm))) {
		set itm=$o(^OEORD(ord,"I",itm))
		continue:'$d(^OEORD(ord,"I",itm,1))
		set ordDate=$p(^OEORD(ord,"I",itm,3),"^",7)
		continue:(ordDate'=+$h)
		set itemStat=$p(^OEORD(ord,"I",itm,1),"^",13)
		set statCode=$s((+itemStat'=0):$p($g(^OEC("OSTAT",itemStat)),"^",1),1:"")
		continue:(" V "'[(" "_statCode_" "))
		set arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
		set levId=0
		while($o(^User.DHCNurLevelTYPD(levId))) {
			set levId=$o(^User.DHCNurLevelTYPD(levId))
			set levData=$g(^User.DHCNurLevelTYPD(levId))
			set levDesc=$lg(levData,3)
			set levArcimStr=$lg(levData,4)
			if (levArcimStr[arcim) set rtn=levDesc_"^"_arcim
		}
	}

	quit rtn
}

/// Creator: hujunbin
/// CreatDate: 2015-02-13
/// Description: 判断就诊是否留观
/// Input: adm: PA_Adm.RowId
/// Return:	rtn: 是否留观状态 Y:留观 N:非留观
/// 			没单调web.UDHCJFBaseCommon方法而单写是为了加陷阱防止床位图报错
/// Debug:	w ##class(web.UDHCJFARREARSMANAGE).GetPatAdmStayStat(309)
ClassMethod GetPatAdmStayStat(adm As %String) As %String
{
	set $zt="AdmStayStatErr"
	//判断留观是否走押金模式
	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	set isDepMode=##class(web.DHCBillInterface).IGetStayPayMode(admHospDR)
	quit:(isDepMode=0) "N"
	set stayInfo=##class(web.UDHCJFBaseCommon).GetPatAdmStayStat(adm)
	set rtn=$p(stayInfo,"^",1)
	quit rtn
AdmStayStatErr
	quit "N"
}

/// Creator: Lid
/// CreatDate: 2017-06-05
/// Description: ordStr: 医嘱rowid串(注意：门诊传医嘱rowid，住院传执行记录rowid，如果有多条医嘱或执行记录时用"^"分割)
/// 		flag: 调用标志(OE:医生,CR:药房,NE:护士,RIS:检查,LIS:检验)
/// 		loginLocId: 登录科室rowid,如果传空，默认取第一条医嘱的接受科室rowid
/// Return: flag|P1^P2^P3^P4^P5^P6^P7^P8^P9
/// 		flag:0：不控制,1:根据欠费配置判断是否控制.	
/// 		P1：押金余额/押金总额
/// 		P2：A/D/G (按押金余额控制/按押金总额控制/绿色通道)
/// 		P3：控制等级rowid
/// 		P4：控制等级名称
/// 		P5：控制等级类型 W/C (预警/控制) 
/// 		P6：是否允许开医嘱Y/N(允许/不允许)
/// 		P7：是否允许执行医嘱 Y/N(允许/不允许)
/// 		P8：允许开医嘱的单价
/// 		P9：是否允许发药 Y/N(允许/不允许)
/// 		
/// 		注意：
/// 			P5=”W”预警，不控制
///      		P5=”C”控制，P6=”N” 不允许开医嘱
///      		P5=”C”控制，P7=”N” 不允许执行医嘱
///      		P5=”C”控制，P9=”N” 不允许发药
/// Other: 
/// Debug: w ##class(web.UDHCJFARREARSMANAGE).IsArrears("", "")
ClassMethod IsArrears(ordStr As %String, flag As %String, loginLocId As %String = "") As %String
{
	set arrearFlag=0, retDetail=""
	quit:(ordStr="") arrearFlag
	
	set adm=$p(^OEORD(+ordStr),"^",1)
	set admType=$p(^PAADM(adm),"^",2)
	set oeitm=$p(ordStr,"^",1)	 //默认取第一个
	
	if (loginLocId="") {
		set recDeptDR=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3),"^",6)	//OEORI_RecDep_DR
		set loginLocId=recDeptDR
	}
	
	//判断科室是否要欠费控制，如配置了科室不欠费控制则不再判断其它配置。
	//0是控制，其它是不控制。
	set checkLoc=..CheckLoc(loginLocId)
	if (checkLoc=0) {
		set retDetail=..CheckArrears(adm, ordStr, flag)
		if (retDetail'=0) {
			set arrearFlag=1
		}
	}
	
	set rtn=arrearFlag_"|"_retDetail
	
	quit rtn
}

/// Creator: tangzf
/// CreatDate: 2023-02-09
/// Description: 未进行医保登记的患者是否按自费进行欠费管理
/// Input: adm:PA_Adm.RowId, hospId:CT_Hospital.RowId
/// Return: 0:否, 1:是
/// Others: 通用配置-住院收费系统-欠费管理-未医保登记的患者按自费校验
/// Debug: w ##class(web.UDHCJFARREARSMANAGE).GetArrearInsuRegCfg("2096", "2")
ClassMethod GetArrearInsuRegCfg(adm As %String, hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.ArrearsMgt.YBHZWBLYBDJAZFHZJHQFKZ", "", "", hospId)
    set cfgVal=##class(%DynamicObject).%FromJSON(jsonStr).value
    quit:(+cfgVal=0) 0
    set regActInfo=##class(web.DHCINSUPort).CheckRegActFlag(adm, "")
    set isInsuReg=$p(regActInfo,"!",1)
    quit:(isInsuReg="Y") 0
    quit 1
}

/// Creator: ZhYW
/// CreatDate: 2023-03-07
/// Description: 获取未分床患者是否需要欠费管理配置
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置-住院收费系统-欠费管理-未分床患者是否需要欠费管理
/// Debug: w ##class(web.UDHCJFARREARSMANAGE).IsCtrlUnAssBed(2)
ClassMethod IsCtrlUnAssBed(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.ArrearsMgt.WFCHZSFXYQFGL", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: ZhYW
/// CreatDate: 2023-03-07
/// Description: 获取患者分床后受欠费管理的起始小时数
/// Input: hospId: CT_Hospital.RowId
/// Return: 
/// Others: 通用配置-住院收费系统-欠费管理-患者分床后受欠费管理的起始小时数
/// Debug: w ##class(web.UDHCJFARREARSMANAGE).GetCtrlAssBedStHours(2)
ClassMethod GetCtrlAssBedStHours(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.ArrearsMgt.HZFCHSQFGLDQSXSS", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).value
	quit cfgData
}

}
