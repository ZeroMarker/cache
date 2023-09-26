Import SQLUser

/// 修正 处方拆分发票概念
/// zhaocz 2010-09-19
Class web.DHCBillCons8 Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetBillData(billstr As %String, itemFlag As %String, reclocFlag As %String, ordItmridstr As %String, Instype As %String, SFlag As %String, ULocDRStr As %String, OrdSIFlag As %String, OECatStr As %String) As %String
{
	;标志=0 表示无效?不根据此标志分账	  此项目为定值?
	;标志=1 表示表示有效?必须根据此标志分账
	;k ^TMP1("OPITEM",$j)
	;k ^TMP1("OPOrdITEM",$j)
	;设置节点变量?
	;ordItmridstr   OE_OrdItem  RowID串?
	;;  SFlag=1  表示退费过程?  =0  表示正常的收费过程?
	n (billstr, itemFlag, reclocFlag, ordItmridstr, Instype, SFlag, ULocDRStr, OrdSIFlag, OECatStr)
	;s $ZT="ERROR^DHCSSERR"
	
	d ..KTMP()
	
	;Flag_$c(2)_OPFC_HerbalFlag_$c(2)_OPFC_HerbalDesc_$c(2)_OPFC_HerbalNum_$c(2)_HerbRange
	s HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig()
	s rtn=$p(HerbConfig,$c(2))
	q:rtn 104   ;配置错误
	
	;get Recloc RID Str
	;s RecLocStr=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(
	
	s FCHerbFlag=$p(HerbConfig,$c(2),2)		;OPFC_HerbalFlag
	s FCHerbDesc=$p(HerbConfig,$c(2),3)
	s FCHerbNum=$p(HerbConfig,$c(2),4)
	s FCHerbRange=$p(HerbConfig,$c(2),5)
	s myConStr=##class(web.DHCOPConfig).GetOPYBConfig()
	s YBConFlag=+$p(myConStr,"^",2)		;YBConFlag
	s FCAdmFlag=+$p(myConStr,"^",3)		;AdmFlag
	s FCICDXFlag=+$p(myConStr,"^",4)		;ICDFlag
	s mySubConStr=##class(web.DHCOPConfig).GetOPSubAvailConfig()
	s FCSubAvailFlag=+$p(mySubConStr,"^",2)		;SubAvailFlag
	
	s FCPresNoFlag=$p($g(^DHCSOPFCON(1)),"^",5)
	
	s instypenot=Instype			;;结算一种费用类型;
	s itemsubnot="",reclocnot=""
	s myadmrowid=""
	s ordrowNo=""		;;打印医嘱明细时,用来区分在
	s billidCount=$l(billstr,"^")
	f billidnum=1:1:billidCount  d
	.s bill=$p(billstr,"^",billidnum)
	.q:bill=""             ;分科室结算修改
	.q:'$d(^DHCPB(bill))   ;分科室结算修改
	.s AdmDR=$p(^DHCPB(bill), "^", 1)			;DHC_PatientBill->PB_Adm_Dr
	.i ((FCAdmFlag=0)) d
	..s AdmDR="AdmID"
	.s PBOChildsub=0  f  s PBOChildsub=$o(^DHCPB(bill,"O",PBOChildsub)) q:PBOChildsub=""  d
	..q:($d(^DHCPB(bill,"O",PBOChildsub))=10)		;;zhao防止错误?
	..s Prescno=""
	..s Arcim=$p(^DHCPB(bill,"O",PBOChildsub),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
	..s BillSubDR=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",9) 
	..;s OrdCatDR=$p(^ARC("IC",ItemCatDR),"^",8)
	..s ORCATDesc=$p(^ARCBG($p(BillSubDR,"||",1)),"^",2)
	..s ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2) ;名称
	..s ItmCatSub=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10) 	;ARC_ItmMast->ARCIM_ItemCat_DR
	..s ArcimUomrowid=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),8)),"^",14) ;计价单位  库存单位?
	..i ArcimUomrowid'="" d
	...s PBDItemUomDesc=$p($g(^CT("UOM",ArcimUomrowid)),"^",2) ;计价单位描述
	..e  d
	...s PBDItemUomDesc=""	
	..s OEORI=$p(^DHCPB(bill,"O",PBOChildsub),"^",4) ;DHC_PatBillOrder->PBO_OEORI_DR
	..s billflag=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",5)
	..s oederstatus=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",13)
	..;
	..;2015-03-24 Lid 作废医嘱按停止医嘱处理，防止收费时报“102”错误
	..s oederstatus=##class(web.DHCBillCons1).ResetOrderStatus(oederstatus)
	..;
	..s Prescno=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",14) ;处方号
	..s PresIdxNo=Prescno
	..i PresIdxNo=""  s PresIdxNo="ZOI"
	..s myRecDepDR=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6)
	..q:((ULocDRStr'="")&&(ULocDRStr'[("^"_myRecDepDR_"^")))
	..s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	..s OrderType=$p(^ARC("IC",ARCCATRowid),"^",7)
	..i OrderType'="R" s PresIdxNo="ZOI"		;;取消非药物医嘱
	..;原因?得到一个完全有效的临时Gloab;
	..s partflag=1		;代表部分结帐标志?false 表示不结帐   true表示结帐?
	..if ((ordItmridstr_"^")[(OEORI_"^")) s partflag=0     ;如果包含?代表不结帐?
	..s ordinstype=$p(^OEORD($p(OEORI,"||",1),"I",$p(OEORI,"||",2),11),"^",18)  ;OE_OrdItem->OEORI_BBExtCode
	..i ordinstype="" d  s ordinstype=##class(web.DHCBillCons).ReadDefInsType()		;按照默认费别; instypenot
	..s ordinstype=##class(web.DHCBillCons1).GetCurrentOrdInsType(OEORI, instypenot,"")
	..s ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR
	..s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType
	..s mytmpordtype=$o(^OEC("OSTAT",0,"Code","D",""))	;---Stop Order RID
	..s myOECatDR=$p(^ARC("IC",ItemCatDR),"^",8)		;ARC_ItemCat->ARCIC_OrdCat_DR
	..;
	..s mySubAvailDR="SAID"
	..i +FCSubAvailFlag=0 d
	...s mySubAvailDR=##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetDefaultAvailDR()
	...i mySubAvailDR="" d
	....s mySubAvailDR="SAID"
	..e  d
	...s mySubAvailDR=##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetSubHospByRecDep(myRecDepDR)
	..;i ((OrderType="R")) d
	..;b		;;;GetBillData
	..;(billflag="B")&(oederstatus'="4")||(oederstatus="4")
	..;添加条件?zhaocz
	..;停止的药物医嘱和非停止的bill状态医嘱  ((OrderType="R")&&(oederstatus="4"))||
	..i SFlag=0 d
	...;收费过程
	...s tmpflag=SFlag
	..e  d
	...s tmpflag=((billflag="B")&&(OrderType="R")&&(oederstatus=mytmpordtype))
	...s OEORDExecQty = ##class(web.UDHCOEORDOPIF).ReadOEORDExecQty("",OEORI, "")
	...i ((OrderType'="R")&&(billflag="B")&&(+OEORDExecQty>0)&&(oederstatus=mytmpordtype)) d
	....s tmpflag=1
	...;申请退费
	...s ApplyRefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORI,"")
	...s ApplyRefQty=$p(ApplyRefQtyInfo,"^",2)
	...s TotalApplyRefQty=$p(ApplyRefQtyInfo,"^",1)
	...s Doseqty=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",12)
	...i (OrderType'="R")&&(billflag="B")&&(+ApplyRefQty'=0)&&(Doseqty'=TotalApplyRefQty)&&(oederstatus=mytmpordtype) d	; 申请退费金额不为0时，需要要再收费
	....s tmpflag=1
	..i (tmpflag||((billflag="B")&&(oederstatus'=mytmpordtype)))&&(partflag=1)&&(ordinstype=instypenot)  d
	...s OrderBillQty=$p(^DHCPB(bill,"O",PBOChildsub),"^",5)
	...s OrdRefQty=+$p(^DHCPB(bill,"O",PBOChildsub),"^",6)
	...;全部退?退出?部分退继续?
	...;
	...q:(+OrderBillQty=0)
	...;过滤掉中途结算生成的负帐单?OEITEm  为Paid  ;但是医嘱被医生站停止?
	...q:(+OrderBillQty<0)
	...Q:(OrderType="R")&&(oederstatus=mytmpordtype)&&(+OrderBillQty=-OrdRefQty)
	...s ItemGroup=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),6)),"^",1) ;组别
	...s OEQty=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),9)),"^",4) ;整包装数量
	...i (OEQty="")!(OEQty="0")  d 
	....s OEQty=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",12) ;OE_OrdItem->OEORI_PhQtyOrd
	...s recdepcode=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6) ;接收科室
	...s recdepdesc=$p(^CTLOC(recdepcode),"^",2)
	...i (reclocFlag=0) d
		....s reclocnot="RecID"				;;定值
	...e  d
		....s reclocnot=recdepcode
	...s loctype=$p(^CTLOC(recdepcode),"^",13) 
	...s OrderUnitPrice=$p(^DHCPB(bill,"O",PBOChildsub),"^",7)
	...s OrdPatShare=$p(^DHCPB(bill,"O",PBOChildsub),"^",11)
	...s OrderBillQty=$p(^DHCPB(bill,"O",PBOChildsub),"^",5)
	...s OrderSum=OrderUnitPrice*OrderBillQty
	...;Add 2008-07-18
	...s myICDXDR=""
	...if (+FCICDXFlag=0) d
	....s myICDXDR="ICDXDR"
	...e  d
	....s myICDXDR=+$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),6)),"^",6)			;ICDX  DR  ->DRGOrder
	....i (myICDXDR="") d
	.....s myICDXDR="ICDXDR"
	...s itmnum=0
	...s PBOrderRowid=bill_"||"_PBOChildsub       ;把账单医嘱考虑在内
	...s PBDChildsub=0 f  s PBDChildsub=$o(^DHCPB(bill,"O",PBOChildsub,"D",PBDChildsub)) q:PBDChildsub=""  d
	....s PBDRowid=bill_"||"_PBOChildsub_"||"_PBDChildsub
	....s PBDItemDR=$p(^DHCPB(bill,"O",PBOChildsub,"D",PBDChildsub),"^",3)
	....s PBDUnitprice=$p(^DHCPB(bill,"O",PBOChildsub,"D",PBDChildsub),"^",4)
	....s PBDPatShare=$p(^DHCPB(bill,"O",PBOChildsub,"D",PBDChildsub),"^",10)
	....s OEPrice=$p(^DHCPB(bill,"O",PBOChildsub,"D",PBDChildsub),"^",7)
	....;s OEunitPrice=OEPrice/OEQty
	....s PBDQty=$p(^DHCPB(bill,"O",PBOChildsub,"D",PBDChildsub),"^",5)
	....s PBDItemdesc=$p(^DHCTARI(PBDItemDR),"^",2) ;收费项目描述
	....;s PBDItemUom=$p(^DHCTARI(PBDItemDR),"^",3) ;收费项目单位rowid
	....;s PBDItemUomDesc=$p(^CT("UOM",PBDItemUom),"^",2) ;收费项目单位描述
	....i itemFlag=0 
	....s PBDCatsub=$p(^DHCTARI(PBDItemDR),"^",15) ;门诊子类DHC_TarItem->TARI_OutpatCate	
	....i PBDCatsub="" d
	.....&sql(select taroc_tartoc_dr into :PBDCat from DHC_TarOutpatCate where taroc_desc='其他费')
	.....s PBDCat=$p(PBDCat,$C(1))
	.....if $d(^DHCTarC("TOC",PBDCat)) d  s PBCCatdesc=$p(^DHCTarC("TOC",PBDCat),"^",2)
	....e  d
	.....s PBDCat=$p(^DHCTarC("OC",PBDCatsub),"^",3) ;门诊大类DHC_TarOutpatCate->TAROC_TARTOC_DR
	....i (itemFlag=0) d
		.. ...s itemsubnot="ItemID"	;;定值
	....e  d
	.....;s itemsubnot=PBDCatsub
	.....s itemsubnot=PBDCat    //yyx 2010-04-01 按门诊大类拆分发票
	....;按照医嘱项拆分发票
	....i ((+OrdSIFlag=1)&(($c(2)_OECatStr_$c(2))[($c(2)_myOECatDR_$c(2)))) d
	.....s myordsubnot=PBOrderRowid
	....e  d
	.....s myordsubnot="OrdItem"
	....if $d(^DHCTarC("TOC",PBDCat))  d  s PBCCatdesc=$p(^DHCTarC("TOC",PBDCat),"^",2) ;DHC_TarOC->
	....;;w PBCCatdesc,!
	....s Price=OEPrice
	....s OEQtyUom=OEQty_$c(1)_PBDItemUomDesc
	....s itmnum=itmnum+1
	....s ^TMP1("OPITEM",$j,instypenot,PBOrderRowid,reclocnot,itemsubnot,itmnum)=Arcim_"^"_OEORI_"^"_recdepcode_"^"_recdepdesc_"^"_PBDItemDR_"^"_PBDItemdesc_"^"_Price_"^"_PBDQty_"^"_PBDCat_"^"_PBCCatdesc_"^"_PBDCatsub_"^"_PBDUnitprice_"^"_PBDPatShare_"^"_myordsubnot
	...s PBOrderRowid=bill_"||"_PBOChildsub
	...s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	...s OrderType=$p(^ARC("IC",ARCCATRowid),"^",7)
	...i ((+$g(FCHerbFlag)=1)&&(FCHerbRange[("^"_ItmCatSub_"^"))) d
	....s ^TMP1("OPOrdITEM",$j,instypenot,PBOrderRowid,"ItmNum")=+$g(FCHerbNum)		;草药的医嘱数量;
	....s FCHerbNum=0
	...e  d
	....;区别分类
	....s myOFFlag=""
	....;F   打印计费项；O  打印医嘱项
	....s myOFFlag=##class(web.DHCOPConfig).ReadOESpPrtFlag(Arcim)
	....i myOFFlag="F" d
	.....s ^TMP1("OPOrdITEM",$j,instypenot,PBOrderRowid,"ItmNum")=itmnum+1	;费用项数量+医嘱项;
	....e  d
	.....s ^TMP1("OPOrdITEM",$j,instypenot,PBOrderRowid,"ItmNum")=1		;医嘱数量;
	...s ^TMP1("OPOrdITEM",$j,instypenot,PBOrderRowid)=ArcimDesc_"^"_OEORI_"^"_recdepcode_"^"_recdepdesc_"^"_PBOrderRowid_"^"_OrderUnitPrice_"^"_OrderBillQty_"^"_OrderSum_"^"_OrderType_"^"_Prescno_"^"_ORCATDesc_"^"_ItemGroup_"^"_loctype_"^"_bill_"^"_OrdPatShare_"^"_AdmDR_"^"_mySubAvailDR_"^"_myICDXDR_"^"_PresIdxNo
	...s ^TMP1("OPOrdPresNo",$j,instypenot,PresIdxNo,PBOrderRowid)=Prescno	;增加一个索引
	...;增加一个针对药品处方的数量, zhaocz 2010-09-19
	...;修正非药物出现的   "处方编号"  问题
	...i ((+$g(FCPresNoFlag)=1)&&(Prescno'="")&&((PresIdxNo'="ZOI")||((PresIdxNo="ZOI")&&(Prescno'="")))) d
	....s ^TMPDHCCFCPresNoFlag(Prescno)=""
	....q:((+$g(FCHerbFlag)=1)&&(FCHerbRange[("^"_ItmCatSub_"^")))
	....s ^TMP1("OPOrdPresNoCount",$j,instypenot,Prescno) = +$g(^TMP1("OPOrdPresNoCount",$j,instypenot,Prescno)) + 1
	;check the Data
	i '$d(^TMP1("OPOrdPresNo",$j)) d
	.d ##class(web.UDHCOPFError).BConGetBillDataErr(billstr)
	
	q 0
}

/// RecInvCount 回执数量? RecInvCount=0  表示发票不打印回执?  <>0  要打印?
/// printCount  每张票据打印的行数?=0表示不打印明细?<>0表示打印明细需要判断?
/// 返回字符串再去生成账单和保存票据过程?
/// 按照医嘱循环?因为每条医嘱必须结算到一张票据上?
ClassMethod ParDataToBill(RecInvCount As %String, printCount As %String) As %String
{
	n (RecInvCount, printCount)
	s $ZT="ERROR^DHCSSERR"
	
	s rtn=0
	
	s myinstype=""
	f  s myinstype=$o(^TMP1("OPOrdPresNo",$j,myinstype)) q:((myinstype="")&&(rtn=0))  d
	.s myPresNo=""
	.f  s myPresNo=$o(^TMP1("OPOrdPresNo",$j,myinstype,myPresNo)) q:((myPresNo="")&&(rtn=0))  d
	..s myPBORowID=""
	..f  s myPBORowID=$o(^TMP1("OPOrdPresNo",$j,myinstype,myPresNo,myPBORowID)) q:((myPBORowID="")&&(rtn=0))  d
	...;循环费用项目	;返回票据的索引数
	...s mIdx=$$CheckBill(myinstype, myPBORowID, RecInvCount, printCount)
	...s billrtn=$$BuildBillData(mIdx, myinstype, myPBORowID, RecInvCount, printCount)	
	
	q rtn

CheckBill(tmpinstype,tmpPBORowID,tmpRecInvCount,tmpPrintCount)
	n (tmpinstype, tmpPBORowID, tmpRecInvCount, tmpPrintCount)
	
	s CBIPNum=$g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID,"ItmNum"))  ;需要打印的明细数量
	s printFlag=0
	s RecpFlag=0
	s mySubAvailFlag=0
	s CBIIviFlag=0
	s CBICurIdx=""
		
	;修正耗材带处方号码问题  只有药物医嘱的 才取PresNo，其他都为 空
	s myOrderType=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID)),"^",9)
	s myPresNo=""
	i (myOrderType="R") {
		s myPresNo=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID)),"^",10)
	}
	;当前医嘱的AdmDR
	s myCurAdmDR=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID)),"^",16)
	s myCurSubAvailDR=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID)),"^",17)
	s myCurICDXDR=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID)),"^",18)	;ICDXDR

	s mytmppresnocount=0
	i (myPresNo'="") {
		s mytmppresnocount=+$g(^TMP1("OPOrdPresNoCount",$j,tmpinstype,myPresNo))
	}
	
	s myICDXFlag=0
	s myPresNoFlag=0
	
	k ^TMPColPrt("TMPLI",$j)
	//分票算法;
	//说明:  1:表示此医嘱可以放在此票据内;0 表示不能放在此票据内;
	s CBIinvidx=""
	f  s CBIinvidx=$o(^TMP1("BillINV",$j,CBIinvidx)) q:((CBIinvidx="")||((printFlag=1)&(RecpFlag=1)&&(myAdmFlag=1)&&(+mySubAvailFlag=1)&&(+myICDXFlag=1)&&(+myPresNoFlag=1)))  d
	.k ^TMPColPrt("TMPLI",$j)		;必须在每张发票中删除
	.s CBICurIdx=CBIinvidx		;记录下当前的票据编号;1,2,3,等等与原始票据无关;
	.s cbitmnum=""
	.s INVPNum=CBIPNum+^TMP1("BillINV",$j,CBIinvidx,"PrintCount")		;记录数
	.;判断是否有条件参数;
	.i tmpPrintCount=0 d
	..s printFlag=1
	.else  d
	..s printFlag=0
	.i (tmpRecInvCount=0) d  
	..s RecpFlag=1	
	.else  d
	..s RecpFlag=0
	.s myAdmFlag=0
	.s mySubAvailFlag=0
	.s myICDXFlag=0
	.s INVRecNum=^TMP1("BillINV",$j,CBIinvidx,"RecInvCount")			;回执
	.s cbrecloc=""
	.f  s cbrecloc=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBORowID,cbrecloc)) q:cbrecloc=""  d  ;;CheckBill
	..q:tmpRecInvCount=0		;不再判断;
	..s cbitmsub=""
	..f  s cbitmsub=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBORowID,cbrecloc,cbitmsub)) q:cbitmsub=""  d
	...s cborditem=""
	...s CBIitmnum=""
	...f  s CBIitmnum=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBORowID,cbrecloc,cbitmsub,CBIitmnum)) q:CBIitmnum=""  d
	....;s CBIRecNum=""
	....s cborditem=$p(^TMP1("OPITEM",$j,tmpinstype,tmpPBORowID,cbrecloc,cbitmsub,CBIitmnum),"^",14)
	....s rtn=0
	....;在当前票据下循环回执联
	....s tmprec=""
	....s tmpINVrec=""
	....f  s tmpINVrec=$o(^TMP1("BillINV",$j,CBIinvidx,"RecInvCount","RecLoc",tmpINVrec)) q:((tmpINVrec="")||(rtn=1))  d
	.....s INVRecLoc=^TMP1("BillINV",$j,CBIinvidx,"RecInvCount","RecLoc",tmpINVrec)
	.....s INVItem=^TMP1("BillINV",$j,CBIinvidx,"RecInvCount","ItemSub",tmpINVrec)
	.....s INVOrdItem=^TMP1("BillINV",$j,CBIinvidx,"RecInvCount","ORDItem",tmpINVrec)
	.....s mytmpli=$g(^TMPColPrt("TMPLI",$j,cbrecloc,cbitmsub))
	.....i (((INVRecLoc=cbrecloc)&&(INVItem=cbitmsub)&&(INVOrdItem=cborditem))||(mytmpli'="")) d
	......s rtn=1		;
	.....q:rtn=1			///rtn=1说明存在这个科目退回上个循环?
	....if (rtn=0) d
	.....s INVRecNum=INVRecNum+1		;使科目加一?
	.....s ^TMPColPrt("TMPLI",$j,cbrecloc,cbitmsub)=cbrecloc	;这个必需存在，否则不能判断
	.;;验证当前票据能否放下
	.;b		;验证当前票据能否放下
	.i (RecpFlag=0) d
	..i (INVRecNum<=tmpRecInvCount) d  s RecpFlag=1
	.i (printFlag=0) d
	..i (INVPNum<=tmpPrintCount) d  s printFlag=1
	.i ($g(^TMP1("BillINV",$j,CBIinvidx,"AdmDR"))="") d
	..s ^TMP1("BillINV",$j,CBIinvidx,"AdmDR")=myCurAdmDR			;如果属性为空，现赋值
	.s myINVAdmDR=$g(^TMP1("BillINV",$j,CBIinvidx,"AdmDR"))			;;property
	.i (myCurAdmDR=myINVAdmDR) d
	..s myAdmFlag=1
	.;
	.i ($g(^TMP1("BillINV",$j,CBIinvidx,"SubAvail"))="") d
	..s ^TMP1("BillINV",$j,CBIinvidx,"SubAvail")=myCurSubAvailDR			;
	.s mySubAvailDR=$g(^TMP1("BillINV",$j,CBIinvidx,"SubAvail"))			;;property
	.i (myCurSubAvailDR=mySubAvailDR) d
	..s mySubAvailFlag=1
	.i $g(^TMP1("BillINV",$j,CBIinvidx,"ICDXDR"))="" d
	..s ^TMP1("BillINV",$j,CBIinvidx,"ICDXDR")=myCurICDXDR
	.s myICDXDR=$g(^TMP1("BillINV",$j,CBIinvidx,"ICDXDR"))			;;property
	.i (myICDXDR=myCurICDXDR) d
	..s myICDXFlag=1
	.;如果当前处方号码在本发票中，不用比较条数， 否则比较条数
	.s myPresNoFlag=0
	.i ((myPresNo'="")&&(myPresNo'="ZOI")) d
	..i (+$d(^TMP1("BillINV",$j,CBIinvidx,"PresNo",myPresNo))=1) d
	...s myPresNoFlag=1
	...;不管一个处方有多少条医嘱， 都要放在一张发票中
	...s printFlag=1
	..e  d
	...;判断一个新的处方 是否能加载到当前页面
	...i ((INVPNum+mytmppresnocount)<=tmpPrintCount) s myPresNoFlag=1
	.e  d
	..s myPresNoFlag=1
	.i (((printFlag=1)&&(RecpFlag=1))&&(myAdmFlag=1)&&(+mySubAvailFlag=1)&&(+myICDXFlag=1)&&(+myPresNoFlag=1)) d
	..s CBIIviFlag=1
	
	i (CBIIviFlag=0) s CBICurIdx=CBICurIdx+1		;没有合适票据,加一
	
	k ^TMPColPrt("TMPLI",$j)
	
	q CBICurIdx
	;
BuildBillData(invIdx, tmpinstype, tmpPBORowID, tmpRecInvCount, tmpPrintCount)
	;把医嘱装载在票据中;
	n (invIdx, tmpinstype, tmpPBORowID, tmpRecInvCount, tmpPrintCount)
	
	s myIdx=$g(^TMP1("BillINV",$j))
	i (invIdx>myIdx) {
		d BuildBlankBill()
	} 
	s myIdx=invIdx
	
	s myPCount=$g(^TMP1("BillINV",$j,myIdx,"PrintCount"))
	
	;此处校正了非药物医嘱处方号问题，  只有药物医嘱的 才取PresNo，其他都为 空
	s myOrderType=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID)),"^",9)
	s myPresNo=""
	i (myOrderType="R"){
		s myPresNo=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID)),"^",10)
	}
	
	s myAdmDR=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID)),"^",16)
	s mySubAvail=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID)),"^",17)
	s myICDXDR=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID)),"^",18)
	
	;验证数据
	;加打印条数
	s ^TMP1("BillINV",$j,myIdx,"PrintCount")=myPCount+$g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID,"ItmNum"))		;已经分配打印条数?
	;票据钱数?患者支付?
	s myordpay=$p(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID),"^",15)
	s ^TMP1("BillINV",$j,myIdx,"PatPaySum")=+myordpay+$g(^TMP1("BillINV",$j,myIdx,"PatPaySum"))
	s mytopay=$p(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID),"^",15)
	s ^TMP1("BillINV",$j,myIdx,"TotSum")=+mytopay+$g(^TMP1("BillINV",$j,myIdx,"TotSum"))
	
	i ($g(^TMP1("BillINV",$j,myIdx,"AdmDR"))="") d
	.s ^TMP1("BillINV",$j,myIdx,"AdmDR")=myAdmDR
	i ($g(^TMP1("BillINV",$j,myIdx,"PresNo"))="") d
	.s ^TMP1("BillINV",$j,myIdx,"PresNo")=myPresNo
	
	i (myPresNo'="")&&(myPresNo'="ZOI") d
	.s ^TMP1("BillINV",$j,myIdx,"PresNo",myPresNo)=myPresNo
	
	i ($g(^TMP1("BillINV",$j,myIdx,"SubAvail"))="") d
	.s ^TMP1("BillINV",$j,myIdx,"SubAvail")=mySubAvail

	i ($g(^TMP1("BillINV",$j,myIdx,"ICDXDR"))="") d
	.s ^TMP1("BillINV",$j,myIdx,"ICDXDR")=myICDXDR
	
	s cbrecloc=""
	f  s cbrecloc=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBORowID,cbrecloc)) q:cbrecloc=""  d
	.q:tmpRecInvCount=0
	.s cbitmsub=""
	.f  s cbitmsub=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBORowID,cbrecloc,cbitmsub)) q:cbitmsub=""  d
	..s cborditem=""
	..s CBIitmnum=""
	..f  s CBIitmnum=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBORowID,cbrecloc,cbitmsub,CBIitmnum)) q:CBIitmnum=""  d
	...s myItemSum=$p(^TMP1("OPITEM",$j,tmpinstype,tmpPBORowID,cbrecloc,cbitmsub,CBIitmnum),"^",13)
	...s cborditem=$p(^TMP1("OPITEM",$j,tmpinstype,tmpPBORowID,cbrecloc,cbitmsub,CBIitmnum),"^",14)
	...s rtn=0
	...;在当前票据下循环回执联
	...s tmprec=""
	...s tmpCurRecIdx=0
	...s tmpINVrec=""
	...f  s tmpINVrec=$o(^TMP1("BillINV",$j,myIdx,"RecInvCount","RecLoc",tmpINVrec)) q:tmpINVrec=""  d
	....s tmpCurRecIdx=tmpINVrec
	....s INVRecLoc=^TMP1("BillINV",$j,myIdx,"RecInvCount","RecLoc",tmpINVrec)
	....s INVItem=^TMP1("BillINV",$j,myIdx,"RecInvCount","ItemSub",tmpINVrec)
	....s INVOrdItem=^TMP1("BillINV",$j,myIdx,"RecInvCount","ORDItem",tmpCurRecIdx)
	....i (INVRecLoc=cbrecloc)&&(INVItem=cbitmsub)&&(INVOrdItem=cborditem) d
	.....s rtn=1		;
	.....s mydepSum=$g(^TMP1("BillINV",$j,myIdx,"RecInvCount","ItmMoney",tmpINVrec))
	.....s ^TMP1("BillINV",$j,myIdx,"RecInvCount","ItmMoney",tmpINVrec)=mydepSum+myItemSum
	....q:rtn=1			///rtn=1说明存在这个科目退回上个循环?
	...if (rtn=0) d  		;;增加科目
	....;写数据;
	....s tmpCurRecIdx=tmpCurRecIdx+1		;使科目加一?
	....s ^TMP1("BillINV",$j,myIdx,"RecInvCount")=tmpCurRecIdx
	....s ^TMP1("BillINV",$j,myIdx,"RecInvCount","RecLoc",tmpCurRecIdx)=cbrecloc
	....s ^TMP1("BillINV",$j,myIdx,"RecInvCount","ItemSub",tmpCurRecIdx)=cbitmsub
	....s ^TMP1("BillINV",$j,myIdx,"RecInvCount","ORDItem",tmpCurRecIdx)=cborditem
	....s ^TMP1("BillINV",$j,myIdx,"RecInvCount","ItmMoney",tmpCurRecIdx)=myItemSum
	....s ^TMP1("BillINV",$j,myIdx,"AdmDR")=myAdmDR
	....s ^TMP1("BillINV",$j,myIdx,"PresNo")=myPresNo
	....i (myPresNo'="")&&(myPresNo'="ZOI") d
	.....s ^TMP1("BillINV",$j,myIdx,"PresNo",myPresNo)=myPresNo
	....s ^TMP1("BillINV",$j,myIdx,"SubAvail")=mySubAvail
	....s ^TMP1("BillINV",$j,myIdx,"ICDXDR")=myICDXDR
	
	;票据结算数据
	s ordrid=$p(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID),"^",2)
	;这里保存中途结算的需要参数?	票据数据;
	;;节点:费别,账单RowID,医嘱RowID(OE_OrdItem)
	s ^TMP1("BillINV",$j,myIdx,"INT",tmpinstype,"BR",+tmpPBORowID,"ORD",tmpPBORowID)=^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBORowID)
	q 0
BuildBlankBill()
	n (ab)
	s ^TMP1("BillINV",$j)=$g(^TMP1("BillINV",$j))+1
	s bbIdx=$g(^TMP1("BillINV",$j))
	s ^TMP1("BillINV",$j,bbIdx,"PrintCount")=0		;已经分配打印条数?
	s ^TMP1("BillINV",$j,bbIdx,"RecInvCount")=0		;已经分配回执数量?
	s ^TMP1("BillINV",$j,bbIdx,"PatPaySum")=0		;票据中患者支付额	
	s ^TMP1("BillINV",$j,bbIdx,"TotSum")=0			;票据总额?
	s ^TMP1("BillINV",$j,bbIdx,"AdmDR")=""
	s ^TMP1("BillINV",$j,bbIdx,"PresNo")=""
	s ^TMP1("BillINV",$j,bbIdx,"SubAvail")=""
	s ^TMP1("BillINV",$j,bbIdx,"ICDXDR")=""
	
	// 账单RowID? 医嘱RowID?费别?
	//s ^TMP1("BillINV",$j,myIdx)=""					;这里保存中途结算的需要参数?	
	q bbIdx

	;s ^TMP1("BillINV",$j)=0						;打印的票据数量?
	;s ^TMP1("BillINV",$j,i,"PrintCount")=0		;已经分配打印条数?
	;s ^TMP1("BillINV",$j,i,"RecInvCount")=0		;已经分配回执数量?
	;s ^TMP1("BillINV",$j,i,"RecInvCount","RecLoc",j)=""
	;s ^TMP1("BillINV",$j,i,"RecInvCount","ItemName",j)=""
	;s ^TMP1("BillINV",$j,i)=0					;这里保存中途结算的需要参数?
}

ClassMethod KTMP() As %String
{
	k ^TMP1("Pres",$j)
	k ^TMP1("Loc",$j)
	k ^TMP1("OPITEM",$j)
	k ^TMP1("OPOrdITEM",$j)
	k ^TMP1("BillINV",$j)
	k ^TMP1("Bill",$j)
	;处方索引  这样优先结算药物处方?
	k ^TMP1("OPOrdPresNo",$j)
	k ^TMP1("OPOrdPresNo",$j)
	k ^TMP1("OPOrdPresNoCount",$j)
}

}
