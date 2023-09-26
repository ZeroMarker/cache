Import SQLUser

Class web.DHCBillCons7 Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
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
	s mySubConStr=##class(web.DHCOPConfig).GetOPSubAvailConfig()
	s FCSubAvailFlag=+$p(mySubConStr,"^",2)		;SubAvailFlag
	
	s instypenot=Instype			;;结算一种费用类型;
	s itemsubnot="",reclocnot=""
	s myadmrowid=""
	s ordrowNo=""		;;打印医嘱明细时,用来区分在
	s billidCount=$l(billstr,"^")
	f billidnum=1:1:billidCount  d
	.s bill=$p(billstr,"^",billidnum)
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
	...s ^TMP1("OPOrdITEM",$j,instypenot,PBOrderRowid)=ArcimDesc_"^"_OEORI_"^"_recdepcode_"^"_recdepdesc_"^"_PBOrderRowid_"^"_OrderUnitPrice_"^"_OrderBillQty_"^"_OrderSum_"^"_OrderType_"^"_Prescno_"^"_ORCATDesc_"^"_ItemGroup_"^"_loctype_"^"_bill_"^"_OrdPatShare_"^"_AdmDR_"^"_mySubAvailDR
	...s ^TMP1("OPOrdPresNo",$j,instypenot,PresIdxNo,PBOrderRowid)=Prescno	;增加一个索引
	;check the Data
	i '$d(^TMP1("OPOrdPresNo",$j)) d
	.d ##class(web.UDHCOPFError).BConGetBillDataErr(billstr)
	
	q 0
}

ClassMethod ParDataToBill(RecInvCount As %String, printCount As %String) As %String
{
	///RecInvCount 回执数量? RecInvCount=0  表示发票不打印回执?  <>0  要打印?
	///printCount  每张票据打印的行数?=0表示不打印明细?<>0表示打印明细需要判断?
	///返回字符串再去生成账单和保存票据过程?
	///按照医嘱循环?因为每条医嘱必须结算到一张票据上?
	n (RecInvCount,printCount)
	;s $ZT="ERROR^DHCSSERR"
	
	s rtn=0
	s myinstype=""
	;w "RecInvCount:"_RecInvCount_"^printCount:"_printCount,!
	;s invnum=0	;票据数量   索引与数据分开
	f  s myinstype=$o(^TMP1("OPOrdPresNo",$j,myinstype)) q:((myinstype="")&(rtn=0))  d
		.s myPresNo=""
		.f  s myPresNo=$o(^TMP1("OPOrdPresNo",$j,myinstype,myPresNo)) q:myPresNo=""  d
		..s myPBordrid=""
		..f  s myPBordrid=$o(^TMP1("OPOrdPresNo",$j,myinstype,myPresNo,myPBordrid)) q:myPBordrid=""  d
			...;循环费用项目	;返回票据的索引数
			...;w "tmpPBordrid:"_myPBordrid,!
			...s mIdx=$$CheckBill(myinstype,myPBordrid,RecInvCount,printCount)
			...;b		;CheckBill
			...s billrtn=$$BuildBillData(mIdx,myinstype,myPBordrid,RecInvCount,printCount)	
			...i billrtn'=0 d  s rtn=-1
			...q:billrtn'=0
	Quit rtn
	
	;f  s myinstype=$o(^TMP1("OPOrdITEM",$j,myinstype)) q:((myinstype="")&(rtn=0))  d
	;	.s myPBordrid=""
	;	.f  s myPBordrid=$o(^TMP1("OPOrdITEM",$j,myinstype,myPBordrid)) q:myPBordrid=""  d
	;		..;循环费用项目	;返回票据的索引数
	;		..;w "tmpPBordrid:"_myPBordrid,!
	;		..s mIdx=$$CheckBill(myinstype,myPBordrid,RecInvCount,printCount)
	;		..;w mIdx
	;		..s billrtn=$$BuildBillData(mIdx,myinstype,myPBordrid,RecInvCount,printCount)	
	;		..i billrtn'=0 d  s rtn=-1
	;		..q:billrtn'=0
	;normal =0  err=-1
	;Quit rtn
	;
	;
CheckBill(tmpinstype,tmpPBordrid,tmpRecInvCount,tmpprintCount)
	n (tmpinstype,tmpPBordrid,tmpRecInvCount,tmpprintCount)
	;s $ZT="ERROR^DHCSSERR"
	
	s CBIPNum=$g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid,"ItmNum"))  ;需要打印的明细数量
	s printFlag=0
	s RecpFlag=0
	s mySubAvailFlag=0
	s CBIIviFlag=0
	s CBICurIdx=""
	;当前医嘱的AdmDR
	s myCurAdmDR=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid)),"^", 16)
	s myCurSubAvailDR=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid)),"^", 17)
	
	k ^TMPColPrt("TMPLI",$j)
	//分票算法;
	//说明:  1:表示此医嘱可以放在此票据内;0 表示不能放在此票据内;
	s CBIinvidx=""
	f  s CBIinvidx=$o(^TMP1("BillINV",$j,CBIinvidx)) q:((CBIinvidx="")||((printFlag=1)&(RecpFlag=1)&&(myAdmFlag=1)&&(+mySubAvailFlag=1)))  d
		.k ^TMPColPrt("TMPLI",$j)		;必须在每张发票中删除
		.s CBICurIdx=CBIinvidx		;记录下当前的票据编号;1,2,3,等等与原始票据无关;
		.s cbitmnum=""
		.s INVPNum=CBIPNum+^TMP1("BillINV",$j,CBIinvidx,"PrintCount")		;记录数
		.;判断是否有条件参数;
		.i tmpprintCount=0 d
			..s printFlag=1
		.else  d
			..s printFlag=0
		.i (tmpRecInvCount=0) d  
			..s RecpFlag=1	
		.else  d
			..s RecpFlag=0
		.s myAdmFlag=0
		.s mySubAvailFlag=0
		.s INVRecNum=^TMP1("BillINV",$j,CBIinvidx,"RecInvCount")			;回执
		.s cbrecloc=""
		.f  s cbrecloc=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc)) q:cbrecloc=""  d  ;;CheckBill
		..q:tmpRecInvCount=0		;不再判断;
		..s cbitmsub=""
		..f  s cbitmsub=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc,cbitmsub)) q:cbitmsub=""  d
		...s cborditem=""
		...s CBIitmnum=""
		...f  s CBIitmnum=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc,cbitmsub,CBIitmnum)) q:CBIitmnum=""  d
			....;s CBIRecNum=""
			....s cborditem=$p(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc,cbitmsub,CBIitmnum),"^",14)
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
			..i (INVPNum<=tmpprintCount) d  s printFlag=1
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
		.
		.i (((printFlag=1)&&(RecpFlag=1))&&(myAdmFlag=1)&&(+mySubAvailFlag=1)) d  s CBIIviFlag=1
	i (CBIIviFlag=0) d  s CBICurIdx=CBICurIdx+1		;没有合适票据,加一
	k ^TMPColPrt("TMPLI",$j)
	q CBICurIdx
	;
BuildBillData(invIdx,tmpinstype,tmpPBordrid,tmpRecInvCount,tmpprintCount)
	;把医嘱装载在票据中;
	n (invIdx,tmpinstype,tmpPBordrid,tmpRecInvCount,tmpprintCount)
	;s $ZT="ERROR^DHCSSERR"
	
	s myIdx=$g(^TMP1("BillINV",$j))
	if (invIdx>myIdx) d 
		.d BuildBlankBill()
	s myIdx=invIdx   ;
	s myPCount=$g(^TMP1("BillINV",$j,myIdx,"PrintCount"))
	s myPresNo=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid)),"^",10)
	s myAdmDR=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid)),"^",16)
	s mySubAvail=$p($g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid)),"^",17)
	
	;验证数据
	;加打印条数
	s ^TMP1("BillINV",$j,myIdx,"PrintCount")=myPCount+$g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid,"ItmNum"))		;已经分配打印条数?
	;票据钱数?患者支付?
	s myordpay=$p(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid),"^",15)
	s ^TMP1("BillINV",$j,myIdx,"PatPaySum")=+myordpay+$g(^TMP1("BillINV",$j,myIdx,"PatPaySum"))
	s mytopay=$p(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid),"^",15)
	s ^TMP1("BillINV",$j,myIdx,"TotSum")=+mytopay+$g(^TMP1("BillINV",$j,myIdx,"TotSum"))
	
	i ($g(^TMP1("BillINV",$j,myIdx,"AdmDR"))="") d
	.s ^TMP1("BillINV",$j,myIdx,"AdmDR")=myAdmDR
	i ($g(^TMP1("BillINV",$j,myIdx,"PresNo"))="") d
	.s ^TMP1("BillINV",$j,myIdx,"PresNo")=myPresNo
	
	i ($g(^TMP1("BillINV",$j,myIdx,"SubAvail"))="") d
	.s ^TMP1("BillINV",$j,myIdx,"SubAvail")=mySubAvail
	
	s cbrecloc=""
	f  s cbrecloc=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc)) q:cbrecloc=""  d
		.q:tmpRecInvCount=0
		.s cbitmsub=""
		.f  s cbitmsub=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc,cbitmsub)) q:cbitmsub=""  d
		..s cborditem=""
		..s CBIitmnum=""
		..f  s CBIitmnum=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc,cbitmsub,CBIitmnum)) q:CBIitmnum=""  d
			...s myItemSum=$p(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc,cbitmsub,CBIitmnum),"^",13)
			...s cborditem=$p(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc,cbitmsub,CBIitmnum),"^",14)
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
				....s ^TMP1("BillINV",$j,myIdx,"SubAvail")=mySubAvail
	;票据结算数据
	s ordrid=$p(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid),"^",2)
	;这里保存中途结算的需要参数?	票据数据;
	;;节点:费别,账单RowID,医嘱RowID(OE_OrdItem)
	s ^TMP1("BillINV",$j,myIdx,"INT",tmpinstype,"BR",+tmpPBordrid,"ORD",tmpPBordrid)=^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid)
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

ClassMethod InsertPHWINV(INVIndx As %String, INVRowid As %String) As %String
{
	n (DD, INVIndx, INVRowid)
	s myrtn=0
	s myIdx=INVIndx
	
	;PHL_"^"_WIn^PHWNo^PhaPrescno_^CTLoc_$c(1)
	i $d(^TMP1("Loc",$j,myIdx))'=0  d
	.s Loc="" f  s Loc=$o(^TMP1("Loc",$j,myIdx,Loc)) q:((Loc="")||(myrtn'=0))  d
	..s PhaPrescno=""
	..f  s PhaPrescno=$o(^TMP1("Loc",$j,myIdx,Loc,PhaPrescno)) q:((PhaPrescno="")||(myrtn'=0))  d
	...;s ^TMP1("Loc",$j,myIdx,reloc,Presno,"PHWindow")=myCurWinInfo
	...s phwinfo=$g(^TMP1("Loc",$j,myIdx, Loc, PhaPrescno,"PHWindow"))
	...s phl=$p(phwinfo,"^",1)
	...s phw=$p(phwinfo,"^",2)
	...s phwno=$p(phwinfo,"^",3)
	...s ddate=$p($h,",",1)
	...s ttime=$p($h,",",2)
	...&sql(insert into DHC_PHARWIN 
			(PHA_PRT_DR,PHA_PrescNo,PHA_DATE,PHA_TIME,PHA_PHW_DR,PHA_PHL_DR,pha_lcdserialno)
				values(:INVRowid,:PhaPrescno,:ddate,:ttime,:phw,:phl,:phwno))
	...s myrtn=SQLCODE
	
	q myrtn
}

ClassMethod STATphwINlocalINV() As %String
{
	;为科室传递数据准备?
	;s ^TMP1("BillINV",$j,myIdx,"INT",tmpinstype,"BR",+tmpPBordrid,"ORD",tmpPBordrid)
	s myIdx=""
	f  s myIdx=$o(^TMP1("BillINV",$j,myIdx)) q:myIdx=""  d
	.s tmpinstype="" f  s tmpinstype=$o(^TMP1("BillINV",$j,myIdx,"INT",tmpinstype)) q:tmpinstype=""  d
	..s tmpPBparref="" f  s tmpPBparref=$o(^TMP1("BillINV",$j,myIdx,"INT",tmpinstype,"BR",tmpPBparref)) q:tmpPBparref=""  d
	...s tmpPBordrid="" f  s tmpPBordrid=$o(^TMP1("BillINV",$j,myIdx,"INT",tmpinstype,"BR",tmpPBparref,"ORD",tmpPBordrid)) q:tmpPBordrid=""  d
	....s info=^TMP1("BillINV",$j,myIdx,"INT",tmpinstype,"BR",tmpPBparref,"ORD",tmpPBordrid)
	....s loctype=$p(info,"^",13)
	....s Presno=$p(info,"^",10)
	....s reloc=$p(info,"^",3)
	....s Sum=$p(info,"^",8)
	....s billno=$p(info,"^",14)
	....s Total=+$g(Total)+$g(Sum)
	....i ((loctype="D")&&(Presno'=""))  d
	.....;统计处方
	.....;统计接收科室?药房?
	.....i $d(^TMP1("Loc",$j,myIdx))=0  s ^TMP1("Loc",$j,myIdx)=reloc
	.....i $d(^TMP1("Loc",$j,myIdx,reloc,Presno))=0  s ^TMP1("Loc",$j,myIdx,reloc,Presno)=Presno
	.....;获取当前处方的窗口信息
	.....s myCurWinInfo=$g(^TMP1("Pres",$j,Presno,"PHWindow"))
	.....s ^TMP1("Loc",$j,myIdx,reloc,Presno,"PHWindow")=myCurWinInfo
	
	q 0
}

ClassMethod UpdatePHWINV(INVStr As %String) As %String
{
	n (INVStr)
	s myrtn=0
	s mylen=$l(INVStr,"^")
	
	;更新
	f myIdx=1:1:mylen  d
	.s myRowID=$p(INVStr,"^", myIdx)
	.q:(myRowID="")
	.q:(+myRowID=0)
	.
	
	q myrtn
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
}

}
