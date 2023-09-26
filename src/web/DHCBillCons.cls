Import SQLUser

Class web.DHCBillCons Extends BILL.COM.Abstract
{

/// 0:收费项数量, 1:收费项数量+医嘱项
Parameter ITMNUM [ Final ] = 1;

/// Description: 判断是否打印票据
/// Input: insTypeId:PAC_AdmReason.RowId, groupId:SS_Group.RowId, hospId:CT_Hospital.RowId,
///        printInvFlag:(N/Y:此参数优先级最高,为N时不打印,Y时再根据其他配置判断是否打印)
/// Return: prtFlag(=0:打印, =1:不打印)
/// Debug: w ##class(web.DHCBillCons).CheckPrtFlag("3","46", 2, "Y")
ClassMethod CheckPrtFlag(insTypeId As %String, groupId As %String, hospId As %String, printInvFlag As %String)
{
	quit:(printInvFlag'="Y") 1
	
	set qualifStatus=##class(web.DHCOPConfig).GetReasonConfig(insTypeId)
	quit:(+qualifStatus'=0) 1    //该费别不打印
	
	//增加条件判断是否需要打印发票?还是直接打印一个小条?由配置来定
	set rtnValue=##class(web.UDHCOPGSConfig).ReadCFByGRowID(groupId, hospId)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtn
	set myGUPrt=$p(rtnValue,"^",5)
	//判断患者类型打印票据前提下, 此安全组中是否打印发票
	set prtFlag=$case(+myGUPrt,1:0,:1)
	
	quit prtFlag
}

/// 此类解决的只是算法问题? 
/// 此类的功能?
/// 回执的数量?
/// 打印费用项明细的数量
/// 手工设置需要结帐的医嘱?传入的字符串是不需要结帐的医嘱RowID
/// 在手工设置中?原来的分组功能等可以取消?利用不结算医嘱来达到分组功能?
/// 把所有的账单生成临时Global
/// Modify 2020-03-13 ZhYW 增加按病种拆分，拆分挂号医嘱规则。
/// Debug: w ##class(web.DHCBillCons).GetBillData()
ClassMethod GetBillData(billStr As %String, ordItmIdStr As %String, insTypeId As %String, SFlag As %String, ExpStr As %String = "") As %String
{
	;标志=0 表示无效?不根据此标志分账   此项目为定值?
	;标志=1 表示表示有效?必须根据此标志分账
	;设置节点变量?
	;ordItmIdStr   OE_OrdItem  RowID串?
	;SFlag=1  表示退费过程?  =0  表示正常的收费过程?
	set $zt="ERROR"
	
	set myGroupId=$p(ExpStr,"^",1)
	set myCTLoc=$p(ExpStr,"^",2)
	set myAdmLGFlag=$p(ExpStr,"^",11)
	set myInsuDicCode=$p(ExpStr,"^",13)		    ;ZhYW 病种编码
	
	set myHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myCTLoc)  ;根据科室取医院DR
	
	set ULocDRStr=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(myGroupId, myHospDR, myCTLoc)
	
	//取出基本配置
	set myBCInfo=##class(web.DHCOPConfig).GetOPBaseConfigForGroup(myGroupId, myHospDR)
	set rtn=$p(myBCInfo,"^")
	quit:(+rtn) 104_"^"_"取门诊基本配置信息失败"
	set itemFlag=$p(myBCInfo,"^",5)		    //是否按门诊大类拆分发票(0:否,1:是)，配合OPFC_RecInvCount(回执数量)使用
	set recLocFlag=$p(myBCInfo,"^",6)		//是否按接收科室拆分发票(0:否,1:是)，配合OPFC_RecInvCount(回执数量)使用
	set presNoFlag=$p(myBCInfo,"^",7)		//是否按处方拆分发票(0:否,1:是)
	set ordSIFlag=$p(myBCInfo,"^",15)		//是否按单独的医嘱大类拆分发票(0:否,1:是)
	set OECatStr=$p(myBCInfo,"^",16)		//需要拆分发票的医嘱大类
	set ICDXFlag=$p(myBCInfo,"^",38)        //是否按按病种拆分标识(0:否,1:是)
	set RegOrdFlag=$p(myBCInfo,"^",39)      //是否单独拆分挂号医嘱标识(0:否,1:是)
	
	set sCfgId=##class(web.DHCOPConfig).GetSOPFCfgId(myHospDR)
	quit:(+sCfgId=0) 104_"^"_"取门诊基本配置信息失败"
	&SQL(
		SELECT OPFC_HerbalFlag, OPFC_HerbalNum, OPFC_AdmFlag
		INTO :HerbbalFlag, :HerbalNum, :AdmFlag
		FROM DHC_SOPFConfig
		WHERE %ID = :sCfgId
	)
	set rtn=SQLCODE
	quit:(+rtn) +rtn_"^"_$g(%msg)
	
	set HerbRange=$s((HerbbalFlag=1):##class(web.DHCDocOrderCommon).GetCNMedItemCatStr(myHospDR),1:"")
	
	//选择了病种时不能按病种拆分发票
	if (myInsuDicCode'="") {
		set ICDXFlag=0
	}
	//保证退费再收或急诊留观病人不拆分发票
	if ((+SFlag=1)||(myAdmLGFlag="Y")) {
		set itemFlag=0, recLocFlag=0, presNoFlag=0, ordSIFlag=0
		set AdmFlag=0
		set ICDXFlag=0
		set RegOrdFlag=0
	}
	set stopStatusDR=$o(^OEC("OSTAT",0,"Code","D",0))	   //停止状态字典RowID
	
	kill OPOrdItmAry

	for Idx=1:1:$l(billStr,"^") {
		
		set PB=$p(billStr,"^",Idx)
		continue:(+PB=0)
		set PBData=$g(^DHCPB(PB))
		continue:(PBData="")
		set AdmDR=$p(PBData,"^",1)		//DHC_PatientBill->PB_Adm_Dr
		set AdmID=AdmDR
		if (+AdmFlag=0) {
			set AdmDR="AdmID"
		}
		set PBO=0
		while($o(^DHCPB(PB,"O",PBO))) {
			set PBO=$o(^DHCPB(PB,"O",PBO))
			set PBOData=$g(^DHCPB(PB,"O",PBO))
			continue:(PBOData="")
			set PBORowID=PB_"||"_PBO
			set Arcim=$p(PBOData,"^",3)    //DHC_PatBillOrder->PBO_ARCIM_DR
			set BillSubDR=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",9)
			set ORCATDesc=$p(^ARCBG($p(BillSubDR,"||",1)),"^",2)
			set ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2)   
			set ItmCatSub=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10) 	 //ARC_ItmMast->ARCIM_ItemCat_DR
			set OEORI=$p(PBOData,"^",4)                              //DHC_PatBillOrder->PBO_OEORI_DR
			b ;11
			continue:(("^"_ordItmIdStr_"^")[("^"_OEORI_"^"))               //过滤不结账的医嘱
			set mySkinFlag=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(OEORI)    //add by zhl  2010.08.27  限制医嘱不计费
			continue:((mySkinFlag="Y")&&(myAdmLGFlag'="Y"))			//add by tangt 20150409 急诊留观不限制限制医嘱结算
			set myRecDepDR=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6)
			b ;12
			continue:((ULocDRStr'="")&&(("^"_ULocDRStr_"^")'[("^"_myRecDepDR_"^")))
			set ordInsType=##class(web.DHCBillCons1).GetCurrentOrdInsType(OEORI, insTypeId, myHospDR)
			b ;13
			continue:(ordInsType'=insTypeId)
			set OrdBillQty=$p(PBOData,"^",5)
			set OrdRefQty=$p(PBOData,"^",6)
			set OrdQty=OrdBillQty+OrdRefQty
			b ;14
			continue:(OrdQty'>0)
			
			set ordStatus=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",13)
			//2015-03-24 Lid 作废医嘱按停止医嘱处理，防止收费时报“102”错误
			set ordStatus=##class(web.DHCBillCons1).ResetOrderStatus(ordStatus)
			set Prescno=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",14)    //处方号
			set PresIdxNo=Prescno
			set OrderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(Arcim, 0)
			if ((PresIdxNo="")||(OrderType'="R")) {
				set PresIdxNo="ZOI"
			}
			set billflag=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",5)
			set tmpflag=0
			if (SFlag=0) {
				//收费过程
				set tmpflag=SFlag
				if (myAdmLGFlag="Y") set tmpflag=1    //+2019-04-18 ZhYW 急诊留观押金模式时，需要收费
			}else {
				if ((billflag="B")&&(ordStatus=stopStatusDR)) {
					if (OrderType="R") {
						set tmpflag=1
					}else {
						set OrdExecQty=##class(web.UDHCJFBILL).GetOrdExecQty(OEORI)
						set ApplyRefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORI, "")
						set ApplyRefQty=$p(ApplyRefQtyInfo,"^",2)
						//执行数量或申请退费数量>0时，需要再收费
						if ((+OrdExecQty>0)||(+ApplyRefQty>0)) {
							set tmpflag=1
						}
					}
				}
			}
			continue:('((tmpflag=1) || ((billflag="B")&&(ordStatus'=stopStatusDR))))
			set ItemGroup=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),6)),"^",1)     //组别
			set recDeptDR=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6)     //接收科室
			set recDept=$s((+recDeptDR'=0):$p(^CTLOC(recDeptDR),"^",2),1:"")
			set locType=$s((+recDeptDR'=0):$p(^CTLOC(recDeptDR),"^",13),1:"")
			//按接收科室拆分
			set recLocNot="RecID"
			if (+recLocFlag'=0) {
				set recLocNot=recDeptDR
			}
			//按医嘱项拆分
			set ordSubNot="OrdItem"			
			set myOECatDR=$p(^ARC("IC",ItmCatSub),"^",8)		     //ARC_ItemCat->ARCIC_OrdCat_DR
			if ((+ordSIFlag'=0)&&(($c(2)_OECatStr_$c(2))[($c(2)_myOECatDR_$c(2)))) {
				set ordSubNot=PBORowID
			}
			//2022-11-10 ZhYW 按药品处方拆分
			set PresNoNot="ZOI"
			if ((+presNoFlag'=0)&&(Prescno'="")&&(OrderType="R")) {
				set PresNoNot=Prescno
			}
			//按慢病病种拆分
			set myICDXDR=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),"DHC")),"^",66)		//OE_OrdItemExt.OEORI_ChronicDiagCode
			set ICDXNot="ICDXDR"
			if ((+ICDXFlag'=0)&&(myICDXDR'="")) {
				set ICDXNot=myICDXDR
			}
			//拆分挂号医嘱
			set RegOrdNot="RegOrd"
			if (+RegOrdFlag'=0) {
				set billSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(Arcim, myHospDR)
				if (billSubType'="NotRegFee") {
					set RegOrdNot=AdmID_"RegOrd"	   //考虑多次挂号医嘱一起结算，需拆分?
				}
			}
			set OrdPrice=$p(PBOData,"^",7)
			set OrdPatShare=$p(PBOData,"^",11)
			set OrderSum=$p(PBOData,"^",8)
			set ItmNum=0, OrdItmNum=0                    //add by zhl 20111011
			set PBD=0
			while($o(^DHCPB(PB,"O",PBO,"D",PBD))) {
				set PBD=$o(^DHCPB(PB,"O",PBO,"D",PBD))
				set PBDData=$g(^DHCPB(PB,"O",PBO,"D",PBD))
				set PBDItemDR=$p(PBDData,"^",3)
				set PBDUnitprice=$p(PBDData,"^",4)
				set PBDPatShare=$p(PBDData,"^",10)
				set PBDPrice=$p(PBDData,"^",7)
				set PBDQty=$p(PBDData,"^",5)
				set PBDItemDesc=$p(^DHCTARI(PBDItemDR),"^",2)       //收费项目描述
				set PBDCatsub=$p(^DHCTARI(PBDItemDR),"^",15)        //门诊子类DHC_TarItem->TARI_OutpatCate
				set PBDCat=$p(^DHCTarC("OC",PBDCatsub),"^",3)       //门诊大类DHC_TarOutpatCate->TAROC_TARTOC_DR
				set PBCCatDesc=$p($g(^DHCTarC("TOC",PBDCat)),"^",2)
				//按门诊收费大类拆分
				set itemSubNot="ItemID"
				if (+itemFlag'=0) {
					//set itemSubNot=PBDCatsub
					set itemSubNot=PBDCat    //yyx 2010-04-01 按门诊大类拆分发票
				}
				b ;(OPOrdItmAry(ordInsType,PBORowID,PBDItemDR))
				if ('$d(OPOrdItmAry(ordInsType,PBORowID,PBDItemDR))) {      //add by zhl 20111011  start
					set OPOrdItmAry(ordInsType,PBORowID,PBDItemDR)=$i(OrdItmNum)    //add by zhl 20111011  end
				}
				set ^||TMP("OPITEM",$j,ordInsType,PBORowID,recLocNot,itemSubNot,$i(ItmNum))=$lb(Arcim, OEORI, recDeptDR, recDept, PBDItemDR, PBDItemDesc, PBDPrice, PBDQty, PBDCat, PBCCatDesc, PBDCatsub, PBDUnitprice, PBDPatShare, ordSubNot)
			}
			//
			if ((+HerbbalFlag=1)&&(("^"_HerbRange_"^")[("^"_ItmCatSub_"^"))) {
				set ^||TMP("OPOrdITEM",$j,ordInsType,PBORowID,"ItmNum")=+HerbalNum		//草药的医嘱数量
				set HerbalNum=0
				b ;//草药的医嘱数量
			}else {
				b  //F:打印计费项; O:打印医嘱项
				set myOFFlag=##class(web.DHCOPConfig).ReadOESpPrtFlag(Arcim)
				set ^||TMP("OPOrdITEM",$j,ordInsType,PBORowID,"ItmNum")=$case(myOFFlag,"F":(OrdItmNum+..#ITMNUM),:1)	//医嘱数量
			}
			set ^||TMP("OPOrdITEM",$j,ordInsType,PBORowID)=$lb(ArcimDesc, OEORI, recDeptDR, recDept, PBORowID, OrdPrice, OrdBillQty, OrderSum, OrderType, Prescno, ORCATDesc, ItemGroup, locType, PB, OrdPatShare, AdmDR, ICDXNot, RegOrdNot, PresNoNot)
			set ^||TMP("OPOrdPresNo",$j,ordInsType,PresIdxNo,PBORowID)=Prescno	   //增加一个索引
			b ;//增加一个索引
		}
	}
	kill OPOrdItmAry
	
	//check the Data
	if '$d(^||TMP("OPOrdPresNo",$j)) {
		do ##class(web.UDHCOPFError).BConGetBillDataErr(billStr)
		b ;BConGetBillDataErr
	}
	
	quit 0

ERROR
	quit ..AppException()
}

/// RecInvCount 回执数量? RecInvCount=0  表示发票不打印回执?  <>0  要打印?
/// printCount  每张票据打印的行数?=0表示不打印明细?<>0表示打印明细需要判断?
/// 返回字符串再去生成账单和保存票据过程?
/// 按照医嘱循环?因为每条医嘱必须结算到一张票据上?
ClassMethod ParDataToBill(RecInvCount As %String, PrintCount As %String) As %String
{
	set $zt="ERROR"

	set rtn=0
	
	set InsTypeId=""
	for  set InsTypeId=$o(^||TMP("OPOrdPresNo",$j,InsTypeId)) quit:((InsTypeId="")||(rtn))  do
	.set PresNo=""
	.for  set PresNo=$o(^||TMP("OPOrdPresNo",$j,InsTypeId,PresNo)) quit:((PresNo="")||(rtn))  do
	..set PBORowID=""
	..for  set PBORowID=$o(^||TMP("OPOrdPresNo",$j,InsTypeId,PresNo,PBORowID)) quit:((PBORowID="")||(rtn))  do
	...b ;d CheckBill//循环费用项目，返回票据的索引数
	...set mIdx=$$CheckBill(InsTypeId, PBORowID)
	...b ;d BuildBillData
	...set rtn=$$BuildBillData(mIdx, InsTypeId, PBORowID)
	
	quit rtn
	
CheckBill(tmpInsType, tmpPBORowID)
	set CBIPNum=$g(^||TMP("OPOrdITEM",$j,tmpInsType,tmpPBORowID,"ItmNum"))  //需要打印的明细数量
	set PrintFlag=0
	set RecpFlag=0
	set CBIIviFlag=0
	set CBICurIdx=""
	
	set myOrdItemStr=$g(^||TMP("OPOrdITEM",$j,tmpInsType,tmpPBORowID))
	set myCurAdmDR=$lg(myOrdItemStr,16)
	set myCurICDXDR=$lg(myOrdItemStr,17)
	set myCurRegOrd=$lg(myOrdItemStr,18)
	set myCurPresNo=$lg(myOrdItemStr,19)

	kill ^||TMP("TMPLI",$j)
	
	//分票算法
	//说明:  1:表示此医嘱可以放在此票据内; 0:表示不能放在此票据内
	set CBIinvidx=""
	for  set CBIinvidx=$o(^||TMP("BillINV",$j,CBIinvidx)) quit:((CBIinvidx="")||(CBIIviFlag=1))  do
	.kill ^||TMP("TMPLI",$j)	     //必须在每张发票中删除
	.set CBICurIdx=CBIinvidx		 //记录下当前的票据编号;1,2,3,等等与原始票据无关;
	.set INVPNum=CBIPNum+$g(^||TMP("BillINV",$j,CBIinvidx,"PrintCount"))		//记录数
	.//判断是否有条件参数
	.if (PrintCount=0) do
	..set PrintFlag=1
	.else  do
	..set PrintFlag=0
	.if (RecInvCount=0) do
	..set RecpFlag=1
	.else  do
	..set RecpFlag=0
	.;
	.set INVRecNum=$g(^||TMP("BillINV",$j,CBIinvidx,"RecInvCount"))			//回执
	.set cbrecloc=""
	.for  set cbrecloc=$o(^||TMP("OPITEM",$j,tmpInsType,tmpPBORowID,cbrecloc)) quit:((cbrecloc="")||(RecInvCount=0))  do
	..set cbitmsub=""
	..for  set cbitmsub=$o(^||TMP("OPITEM",$j,tmpInsType,tmpPBORowID,cbrecloc,cbitmsub)) quit:(cbitmsub="")  do
	...set itmNum=""
	...for  set itmNum=$o(^||TMP("OPITEM",$j,tmpInsType,tmpPBORowID,cbrecloc,cbitmsub,itmNum)) quit:(itmNum="")  do
	....set itmStr=$g(^||TMP("OPITEM",$j,tmpInsType,tmpPBORowID,cbrecloc,cbitmsub,itmNum))
	....set cborditem=$lg(itmStr,14)
	....set rtn=0
	....//在当前票据下循环回执联
	....set tmpINVrec=""
	....for  set tmpINVrec=$o(^||TMP("BillINV",$j,CBIinvidx,"RecInvCount","RecLoc",tmpINVrec)) quit:((tmpINVrec="")||(rtn=1))  do
	.....set INVRecLoc=$g(^||TMP("BillINV",$j,CBIinvidx,"RecInvCount","RecLoc",tmpINVrec))
	.....set INVItem=$g(^||TMP("BillINV",$j,CBIinvidx,"RecInvCount","ItemSub",tmpINVrec))
	.....set INVOrdItem=$g(^||TMP("BillINV",$j,CBIinvidx,"RecInvCount","ORDItem",tmpINVrec))
	.....set mytmpli=$g(^||TMP("TMPLI",$j,cbrecloc,cbitmsub))
	.....if (((INVRecLoc=cbrecloc)&&(INVItem=cbitmsub)&&(INVOrdItem=cborditem))||(mytmpli'="")) do
	......set rtn=1
	.....quit:(rtn=1)			//rtn=1说明存在这个科目退回上个循环?
	....quit:(rtn=1)
	....set INVRecNum=$i(INVRecNum)		//使科目加一
	....set ^||TMP("TMPLI",$j,cbrecloc,cbitmsub)=cbrecloc	  //这个必需存在，否则不能判断
	.//验证当前票据能否放下
	.if (RecpFlag=0) do
	..if (INVRecNum<=RecInvCount) set RecpFlag=1
	.;
	.if (PrintFlag=0) do
	..if (INVPNum<=PrintCount) set PrintFlag=1
	.;
	.set myAdmFlag=0
	.if ($g(^||TMP("BillINV",$j,CBIinvidx,"AdmDR"))="") do
	..set ^||TMP("BillINV",$j,CBIinvidx,"AdmDR")=myCurAdmDR			//如果属性为空，先赋值
	.set myINVAdmDR=$g(^||TMP("BillINV",$j,CBIinvidx,"AdmDR"))
	.if (myCurAdmDR=myINVAdmDR) do
	..set myAdmFlag=1
	.;
	.set myICDXFlag=0
	.if ($g(^||TMP("BillINV",$j,CBIinvidx,"ICDXDR"))="") do
	..set ^||TMP("BillINV",$j,CBIinvidx,"ICDXDR")=myCurICDXDR
	.set myICDXDR=$g(^||TMP("BillINV",$j,CBIinvidx,"ICDXDR"))
	.if (myICDXDR=myCurICDXDR) do
	..set myICDXFlag=1
	.;
	.set myRegOrdFlag=0
	.if ($g(^||TMP("BillINV",$j,CBIinvidx,"RegOrd"))="") do
	..set ^||TMP("BillINV",$j,CBIinvidx,"RegOrd")=myCurRegOrd
	.set myRegOrd=$g(^||TMP("BillINV",$j,CBIinvidx,"RegOrd"))
	.if (myRegOrd=myCurRegOrd) do
	..set myRegOrdFlag=1
	.;
	.//2022-11-10 ZhYW 按处方拆票
	.set myPresNoFlag=0
	.if ($g(^||TMP("BillINV",$j,CBIinvidx,"PresNo"))="") do
	..set ^||TMP("BillINV",$j,CBIinvidx,"PresNo")=myCurPresNo
	.set myPresNo=$g(^||TMP("BillINV",$j,CBIinvidx,"PresNo"))
	.if (myPresNo=myCurPresNo) do
	..set myPresNoFlag=1
	.;
	.if (((PrintFlag=1)&&(RecpFlag=1))&&(myAdmFlag=1)&&(myICDXFlag=1)&&(myRegOrdFlag=1)&&(myPresNoFlag=1)) do
	..set CBIIviFlag=1
	
	if (CBIIviFlag=0) set CBICurIdx=$i(CBICurIdx)		//没有合适票据，加一
	
	kill ^||TMP("TMPLI",$j)
	
	quit CBICurIdx
	
BuildBillData(invIdx, tmpInsType, tmpPBORowID)
	//把医嘱装载在票据中
	set myIdx=$g(^||TMP("BillINV",$j))
	if (invIdx>myIdx) {
		do BuildBlankBill()
	}
	set myIdx=invIdx
	
	set myOrdItemStr=$g(^||TMP("OPOrdITEM",$j,tmpInsType,tmpPBORowID))
	set myOrdTotAmt=$lg(myOrdItemStr,8)
	set myOrdPatAmt=$lg(myOrdItemStr,"^",15)
	set myAdmDR=$lg(myOrdItemStr,16)
	set myICDXDR=$lg(myOrdItemStr,17)
	set myRegOrd=$lg(myOrdItemStr,18)
	set myPresNo=$lg(myOrdItemStr,19)
	b ;1
	//加打印条数
	set myItmCount=+$g(^||TMP("OPOrdITEM",$j,tmpInsType,tmpPBORowID,"ItmNum"))
	set ^||TMP("BillINV",$j,myIdx,"PrintCount")=$i(^||TMP("BillINV",$j,myIdx,"PrintCount"), myItmCount)	//已经分配打印条数?
	//票据钱数
	set ^||TMP("BillINV",$j,myIdx,"TotSum")=$i(^||TMP("BillINV",$j,myIdx,"TotSum"), myOrdTotAmt)
	//患者支付
	set ^||TMP("BillINV",$j,myIdx,"PatPaySum")=$i(^||TMP("BillINV",$j,myIdx,"PatPaySum"), myOrdPatAmt)
	
	if ($g(^||TMP("BillINV",$j,myIdx,"AdmDR"))="") {
		set ^||TMP("BillINV",$j,myIdx,"AdmDR")=myAdmDR
	}
	if ($g(^||TMP("BillINV",$j,myIdx,"PresNo"))="") {
		set ^||TMP("BillINV",$j,myIdx,"PresNo")=myPresNo
	}
	if ($g(^||TMP("BillINV",$j,myIdx,"ICDXDR"))="") {
		set ^||TMP("BillINV",$j,myIdx,"ICDXDR")=myICDXDR
	}
	if ($g(^||TMP("BillINV",$j,myIdx,"RegOrd"))="") {
		set ^||TMP("BillINV",$j,myIdx,"RegOrd")=myRegOrd
	}
	
	set cbrecloc=""
	for  set cbrecloc=$o(^||TMP("OPITEM",$j,tmpInsType,tmpPBORowID,cbrecloc)) quit:((cbrecloc="")||(RecInvCount=0))  do
	.set cbitmsub=""
	.for  set cbitmsub=$o(^||TMP("OPITEM",$j,tmpInsType,tmpPBORowID,cbrecloc,cbitmsub)) quit:(cbitmsub="")  do
	..set itmNum=""
	..for  set itmNum=$o(^||TMP("OPITEM",$j,tmpInsType,tmpPBORowID,cbrecloc,cbitmsub,itmNum)) quit:(itmNum="")  do
	...set itmStr=$g(^||TMP("OPITEM",$j,tmpInsType,tmpPBORowID,cbrecloc,cbitmsub,itmNum))
	...set myItemSum=$lg(itmStr,13)
	...set cborditem=$lg(itmStr,14)
	...set rtn=0
	...//在当前票据下循环回执联
	...set tmpCurRecIdx=0
	...set tmpINVrec=""
	...for  set tmpINVrec=$o(^||TMP("BillINV",$j,myIdx,"RecInvCount","RecLoc",tmpINVrec)) quit:(tmpINVrec="")  do
	....set tmpCurRecIdx=tmpINVrec
	....set INVRecLoc=$g(^||TMP("BillINV",$j,myIdx,"RecInvCount","RecLoc",tmpINVrec))
	....set INVItem=$g(^||TMP("BillINV",$j,myIdx,"RecInvCount","ItemSub",tmpINVrec))
	....set INVOrdItem=$g(^||TMP("BillINV",$j,myIdx,"RecInvCount","ORDItem",tmpINVrec))
	....if ((INVRecLoc=cbrecloc)&&(INVItem=cbitmsub)&&(INVOrdItem=cborditem)) do
	.....set rtn=1
	.....set ^||TMP("BillINV",$j,myIdx,"RecInvCount","ItmMoney",tmpINVrec)=$i(^||TMP("BillINV",$j,myIdx,"RecInvCount","ItmMoney",tmpINVrec), myItemSum)
	....quit:(rtn=1)			//rtn=1说明存在这个科目退回上个循环
	...quit:(rtn=1)
	...//增加科目
	...set tmpCurRecIdx=$i(tmpCurRecIdx)	 //使科目加一
	...set ^||TMP("BillINV",$j,myIdx,"RecInvCount")=tmpCurRecIdx
	...set ^||TMP("BillINV",$j,myIdx,"RecInvCount","RecLoc",tmpCurRecIdx)=cbrecloc
	...set ^||TMP("BillINV",$j,myIdx,"RecInvCount","ItemSub",tmpCurRecIdx)=cbitmsub
	...set ^||TMP("BillINV",$j,myIdx,"RecInvCount","ORDItem",tmpCurRecIdx)=cborditem
	...set ^||TMP("BillINV",$j,myIdx,"RecInvCount","ItmMoney",tmpCurRecIdx)=myItemSum
	
	//这里保存中途结算的需要参数?	票据数据
	set ^||TMP("BillINV",$j,myIdx,"INT",tmpInsType,"BR",+tmpPBORowID,"ORD",tmpPBORowID)=myOrdItemStr
	b ;12
	quit 0
	
BuildBlankBill()
	set bbIdx=$i(^||TMP("BillINV",$j))
	set ^||TMP("BillINV",$j)=bbIdx
	set ^||TMP("BillINV",$j,bbIdx,"PrintCount")=0		//已经分配打印条数
	set ^||TMP("BillINV",$j,bbIdx,"RecInvCount")=0		//已经分配回执数量
	set ^||TMP("BillINV",$j,bbIdx,"PatPaySum")=0		//票据中患者支付额
	set ^||TMP("BillINV",$j,bbIdx,"TotSum")=0			//票据总额
	set ^||TMP("BillINV",$j,bbIdx,"AdmDR")=""
	set ^||TMP("BillINV",$j,bbIdx,"PresNo")=""
	set ^||TMP("BillINV",$j,bbIdx,"ICDXDR")=""
	set ^||TMP("BillINV",$j,bbIdx,"RegOrd")=""
	
	quit bbIdx

ERROR
	quit ..AppException()
}

ClassMethod KTMP() As %String
{
	kill ^||TMP("Pres",$j)
	kill ^||TMP("Loc",$j)
	kill ^||TMP("OPITEM",$j)
	kill ^||TMP("OPOrdITEM",$j)
	kill ^||TMP("BillINV",$j)
	//处方索引  这样优先结算药物处方?
	kill ^||TMP("OPOrdPresNo",$j)
}

/// Description: 获取默认的费别
/// Debug: w ##class(web.DHCBillCons).ReadDefInsType(2)
ClassMethod ReadDefInsType(hospId As %String) As %String
{
	set insTypeId=""
	set cfgId=##class(web.DHCBillCommon).GetTarParaId(hospId)
	quit:(+cfgId=0) insTypeId
	set insTypeId=$p($g(^DHCTarC("CF",cfgId)),"^",3)
	quit insTypeId
}

}
