Import SQLUser

Class web.DHCBillConsNewTest Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 189;

/// 此类解决的只是算法问题?
/// 此类的功能?
/// 回执的数量?
/// 打印费用项明细的数量
/// 手工设置需要结帐的医嘱?传入的字符串是不需要结帐的医嘱RowID
/// 在手工设置中?原来的分组功能等可以取消?利用不结算医嘱来达到分组功能?
/// 把所有的账单生成tmp  G
ClassMethod GetBillData(billstr As %String, itemFlag As %String, reclocFlag As %String, ordItmridstr As %String, Instype As %String, SFlag As %String) As %String
{
	;标志=0 表示无效?不根据此标志分账	  此项目为定值?
	;标志=1 表示表示有效?必须根据此标志分账
	;k ^TMP1("OPITEM",$j)
	;k ^TMP1("OPOrdITEM",$j)
	;设置节点变量?
	;ordItmridstr   OE_OrdItem  RowID串?
	;;  SFlag=1  表示退费过程?  =0  表示正常的收费过程?
	n (billstr, itemFlag, reclocFlag, ordItmridstr, Instype, SFlag)	;;能够保证下面的变量是私有的?
	s $ZT="ERROR^DHCSSERR"

	d ..KTMP()
	
	s HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig()
	s rtn=$p(HerbConfig,$c(2))
	q:rtn 104   ;配置错误
	
	
	s instypenot=Instype			;;结算一种费用类型;
	s itemsubnot="",reclocnot=""
	s ordrowNo=""		;;打印医嘱明细时,用来区分在
	s billidCount=$l(billstr,"^")
	f billidnum=1:1:billidCount  d
	.s bill=$p(billstr,"^",billidnum)
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
	..s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	..s OrderType=$p(^ARC("IC",ARCCATRowid),"^",7)
	..i OrderType'="R" s PresIdxNo="ZOI"		;;取消非药物医嘱
	..;原因?得到一个完全有效的临时Gloab;
	..s partflag=1		;代表部分结帐标志?false 表示不结帐   true表示结帐?
	..if ((ordItmridstr_"^")[(OEORI_"^")) s partflag=0     ;如果包含?代表不结帐?
	..s ordinstype=$p(^OEORD($p(OEORI,"||",1),"I",$p(OEORI,"||",2),11),"^",18)  ;OE_OrdItem->OEORI_BBExtCode
	..i ordinstype="" d  s ordinstype=##class(web.DHCBillCons).ReadDefInsType()		;按照默认费别; instypenot
	..s ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR
	..s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType
	..;^OEC("OSTAT",0,"Code",$$ALPHAUP({OSTAT_Code}),{OSTAT_RowId})
	..s mytmpordtype=$o(^OEC("OSTAT",0,"Code","D",""))
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
	...;这个状态还需要与周志强商量?zhaocz  2005-09-14
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
		.. ...s itemsubnot=PBDCatsub
	....if $d(^DHCTarC("TOC",PBDCat))  d  s PBCCatdesc=$p(^DHCTarC("TOC",PBDCat),"^",2) ;DHC_TarOC->
	....;w PBCCatdesc,!
	....s Price=OEPrice
	....s OEQtyUom=OEQty_$c(1)_PBDItemUomDesc
	....s itmnum=itmnum+1
	....s ^TMP1("OPITEM",$j,instypenot,PBOrderRowid,reclocnot,itemsubnot,itmnum)=Arcim_"^"_OEORI_"^"_recdepcode_"^"_recdepdesc_"^"_PBDItemDR_"^"_PBDItemdesc_"^"_Price_"^"_PBDQty_"^"_PBDCat_"^"_PBCCatdesc_"^"_PBDCatsub_"^"_PBDUnitprice_"^"_PBDPatShare
	...s PBOrderRowid=bill_"||"_PBOChildsub
	...s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	...s OrderType=$p(^ARC("IC",ARCCATRowid),"^",7)
	...s ^TMP1("OPOrdITEM",$j,instypenot,PBOrderRowid,"ItmNum")=itmnum	;费用项数量;
	...s ^TMP1("OPOrdITEM",$j,instypenot,PBOrderRowid,"ItmNum")=1		;医嘱数量;
	...s ^TMP1("OPOrdITEM",$j,instypenot,PBOrderRowid)=ArcimDesc_"^"_OEORI_"^"_recdepcode_"^"_recdepdesc_"^"_PBOrderRowid_"^"_OrderUnitPrice_"^"_OrderBillQty_"^"_OrderSum_"^"_OrderType_"^"_Prescno_"^"_ORCATDesc_"^"_ItemGroup_"^"_loctype_"^"_bill_"^"_OrdPatShare
	...s ^TMP1("OPOrdPresNo",$j,instypenot,PresIdxNo,PBOrderRowid)=Prescno	;增加一个索引
	q 0
}

ClassMethod GetreceipNO(UserRowid As %String) As %String
{
	;;##class(web.DHCBillCons).GetreceipNO("")
	s rcptno="",rid="",availno=""
	&sql(select min(inv_rowid) into:inid from dhc_invoice 
	     where inv_usr= :UserRowid and INV_Finalflag='Y' and INV_type='O')
	q:SQLCODE SQLCODE
	&sql(select inv_lastnum,inv_rowid,inv_EndInv into:rcptno,:rid,:endno from dhc_invoice 
	     where inv_rowid=:inid)
	i SQLCODE=0 d
	.s rid=$p($g(rid),$c(1))
	.s rcptno=$p($g(rcptno),$c(1))
	.s availno =rcptno
	q availno
}

ClassMethod InsertINVPrt() As %String
{
	
	q:rtn rtn
}

ClassMethod KCalTMP(sUser As %String) As %String
{
	;d ##class(web.DHCBillCons).KCalTMP("10137")
	;删除计算器功能
	q:sUser=""
	
	k ^TMP1("OPCal",sUser)
	;^TMP1("OPCal",User,"FS")	;结算金额
	;^TMP1("OPCal",User,"UFS")	;未结算金额
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

ClassMethod ParDataToBill(RecInvCount As %String, printCount As %String) As %String
{
	///RecInvCount 回执数量? RecInvCount=0  表示发票不打印回执?  <>0  要打印?
	///printCount  每张票据打印的行数?=0表示不打印明细?<>0表示打印明细需要判断?
	///返回字符串再去生成账单和保存票据过程?
	///按照医嘱循环?因为每条医嘱必须结算到一张票据上?
	n (RecInvCount,printCount)
	s $ZT="ERROR^DHCSSERR"
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
			...;w mIdx
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
	s $ZT="ERROR^DHCSSERR"
	
	s CBIPNum=$g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid,"ItmNum"))  ;需要打印的明细数量
	s printFlag=0
	s RecpFlag=0
	s CBIIviFlag=0
	s CBICurIdx=""
	//分票算法;
	//说明:  1:表示此医嘱可以放在此票据内;0 表示不能放在此票据内;
	s CBIinvidx=""
	f  s CBIinvidx=$o(^TMP1("BillINV",$j,CBIinvidx)) q:((CBIinvidx="")||((printFlag=1)&(RecpFlag=1)))  d
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
		.s INVRecNum=^TMP1("BillINV",$j,CBIinvidx,"RecInvCount")			;回执
		.s cbrecloc=""
		.f  s cbrecloc=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc)) q:cbrecloc=""  d  ;;CheckBill
		..q:tmpRecInvCount=0		;不再判断;
		..s cbitmsub=""
		..f  s cbitmsub=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc,cbitmsub)) q:cbitmsub=""  d
		...s CBIitmnum=""
		...f  s CBIitmnum=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc,cbitmsub,CBIitmnum)) q:CBIitmnum=""  d
			....;s CBIRecNum=""
			....s rtn=0
			....;在当前票据下循环回执联
			....s tmprec=""
			....s tmpINVrec=""
			....f  s tmpINVrec=$o(^TMP1("BillINV",$j,CBIinvidx,"RecInvCount","RecLoc",tmpINVrec)) q:((tmpINVrec="")||(rtn=1))  d
		 		.....s INVRecLoc=^TMP1("BillINV",$j,CBIinvidx,"RecInvCount","RecLoc",tmpINVrec)
				.....s INVItem=^TMP1("BillINV",$j,CBIinvidx,"RecInvCount","ItemSub",tmpINVrec)
				.....i (INVRecLoc=cbrecloc)&&(INVItem=cbitmsub) d
					......s rtn=1		;
				.....q:rtn=1			///rtn=1说明存在这个科目退回上个循环?
			....if (rtn=0) d  s INVRecNum=INVRecNum+1		;使科目加一?
		.;;验证当前票据能否放下
		.i (RecpFlag=0) d
			..i (INVRecNum<=tmpRecInvCount) d  s RecpFlag=1
		.i (printFlag=0) d
			..i (INVPNum<=tmpprintCount) d  s printFlag=1
		.i ((printFlag=1)&(RecpFlag=1)) d  s CBIIviFlag=1
	i (CBIIviFlag=0) d  s CBICurIdx=CBICurIdx+1		;没有合适票据,加一
	q CBICurIdx
	;
BuildBillData(invIdx,tmpinstype,tmpPBordrid,tmpRecInvCount,tmpprintCount)
	;把医嘱装载在票据中;
	n (invIdx,tmpinstype,tmpPBordrid,tmpRecInvCount,tmpprintCount)
	s $ZT="ERROR^DHCSSERR"
	
	s myIdx=$g(^TMP1("BillINV",$j))
	if (invIdx>myIdx) d 
		.d BuildBlankBill()
	s myIdx=invIdx   ;
	s myPCount=$g(^TMP1("BillINV",$j,myIdx,"PrintCount"))
	;验证数据
	;加打印条数
	s ^TMP1("BillINV",$j,myIdx,"PrintCount")=myPCount+$g(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid,"ItmNum"))		;已经分配打印条数?
	;票据钱数?患者支付?
	s myordpay=$p(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid),"^",15)
	s ^TMP1("BillINV",$j,myIdx,"PatPaySum")=+myordpay+$g(^TMP1("BillINV",$j,myIdx,"PatPaySum"))
	s mytopay=$p(^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid),"^",15)
	s ^TMP1("BillINV",$j,myIdx,"TotSum")=+mytopay+$g(^TMP1("BillINV",$j,myIdx,"TotSum"))
	s cbrecloc=""
	f  s cbrecloc=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc)) q:cbrecloc=""  d
		.q:tmpRecInvCount=0
		.s cbitmsub=""
		.f  s cbitmsub=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc,cbitmsub)) q:cbitmsub=""  d
		..s CBIitmnum=""
		..f  s CBIitmnum=$o(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc,cbitmsub,CBIitmnum)) q:CBIitmnum=""  d
			...s myItemSum=$p(^TMP1("OPITEM",$j,tmpinstype,tmpPBordrid,cbrecloc,cbitmsub,CBIitmnum),"^",13)
			...s rtn=0
			...;在当前票据下循环回执联
			...s tmprec=""
			...s tmpCurRecIdx=0
			...s tmpINVrec=""
			...f  s tmpINVrec=$o(^TMP1("BillINV",$j,myIdx,"RecInvCount","RecLoc",tmpINVrec)) q:tmpINVrec=""  d
		 		....s tmpCurRecIdx=tmpINVrec
		 		....s INVRecLoc=^TMP1("BillINV",$j,myIdx,"RecInvCount","RecLoc",tmpINVrec)
				....s INVItem=^TMP1("BillINV",$j,myIdx,"RecInvCount","ItemSub",tmpINVrec)
				....i (INVRecLoc=cbrecloc)&&(INVItem=cbitmsub) d
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
				....s ^TMP1("BillINV",$j,myIdx,"RecInvCount","ItmMoney",tmpCurRecIdx)=myItemSum
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

/// 下一步进入中途结算函数?
/// 
/// 
/// 下一步进入票据保存阶段?
/// 
/// 解析Global过程,同时生成票据的过程;
/// 中途结算  这个过程只在后台运行不与Client交互?
ClassMethod ReBill(userno As %String, PARowid As %String, myPayor As %String, myPatPaySum As %String, rbPayinfo As %String, rbgloc As %String, SFlag As %String, OldINVRID As %String = "") As %String
{
	///arpbl As %String, idatestr As %String, iorderstr As %String, 
	;n (userno, PARowid, myPayor, myTotalSum, rbPayinfo, rbgloc, SFlag)
	i ('$g(^TMP1("BillINV",$j))) q 101		;门诊结算没有数据
	
	s $ZT="ERROR^DHCSSERR"
	
	s rtn=0
	s rbinvnum=$g(^TMP1("BillINV",$j))	
	;在此处增加验证票据钱数?
	s patpaysum=0
	s mytosum=0	;
	s myIdx=""
	;f  s myIdx=$o(^TMP1("BillINV",$j,myIdx)) q:myIdx=""  d
	;	.s patpaysum=patpaysum+$g(^TMP1("BillINV",$j,myIdx,"PatPaySum"))
	;	.s mytosum=mytosum+$g(^TMP1("BillINV",$j,myIdx,"TotSum"))
	;q:(+myTotalSum'=+mytosum) myTotalSum_"="_mytosum  ;-102		;;钱数误差?
	
	s myRecNoStr=""
	s myrbpatsum=0	;
	;正式科室结算
	d ..tb()
	;;s ^TMP1("BillINV",$j,myIdx,"INT",tmpinstype,"BR",+tmpPBordrid,"ORD",ordrid)=^TMP1("OPOrdITEM",$j,tmpinstype,tmpPBordrid)
	s rbInvIdx=""
	f  s rbInvIdx=$o(^TMP1("BillINV",$j,rbInvIdx)) q:((rbInvIdx="")||(rtn'=0))  d
		.s nbillrid=""				;新账单RowID的字符串?
		.s rbinstype=""
		.s myinstypenew=""
		.f  s rbinstype=$o(^TMP1("BillINV",$j,rbInvIdx,"INT",rbinstype)) q:((rbinstype="")||(rtn'=0))  d
		..s myinstypenew=rbinstype
		..s rbarcpbstr=""			;对于每个账单重新结算?账单层?
		..f  s rbarcpbstr=$o(^TMP1("BillINV",$j,rbInvIdx,"INT",rbinstype,"BR",rbarcpbstr)) q:((rbarcpbstr="")||(rtn'=0))  d
		...s paadmdate=$p(^DHCPB(rbarcpbstr),"^",2)
		...s pbupdatedate=$p(^DHCPB(rbarcpbstr),"^",19)
		...i (paadmdate="")!(pbupdatedate="") d
		....s rtn=1			;
		...q:rtn'=0			;不再往下执行了?
		...i paadmdate'="" d  s paadmdate=$zd(paadmdate,4)
		...i pbupdatedate'="" d  s pbupdatedate=$zd(pbupdatedate,4)
		...s idatestr=paadmdate_"^"_pbupdatedate
		...s rbordrid=""
		...s myordrid=""
		...f  s rbordrid=$o(^TMP1("BillINV",$j,rbInvIdx,"INT",rbinstype,"BR",rbarcpbstr,"ORD",rbordrid)) q:((rbordrid="")||(rtn'=0))  d
		....s myordrid=myordrid_rbordrid_"^"
		...i myordrid'="" d
		....;;重新结算此账单?  这个函数需要更换?
		....;b	;重新结算此账单?
		....s billvalue=##class(web.UDHCJFIntBill).RINBILL(rbarcpbstr,idatestr,myordrid,userno,rbinstype)
		....;b		;;rtn
		....s rtn=$p(billvalue,"^",1)
		....;取得新账单的RowID
		....s nbillrid=nbillrid_$p(billvalue,"^",2)_$c(2)
		.;这一层是票据层;把这个循环完毕,一张票据
		.	;取得发票号
		.s myReceiptNo=""
		.s prtflag=##class(web.DHCOPConfig).GetReasonConfig(myinstypenew)
		.i +prtflag=0 d
		..&sql(select inv_lastnum,inv_rowid,inv_EndInv into:myReceiptNo,:rid,:endno from dhc_invoice 
	     		where inv_rowid=(select min(inv_rowid)  from dhc_invoice 
	     	where inv_usr= :userno and INV_Finalflag='Y' and INV_type='O'))
		.;当前的票据金额?
		.s CurBillSum=^TMP1("BillINV",$j,rbInvIdx,"PatPaySum")
		.s rtnvalue=..SaveINV(userno,CurBillSum,rbPayinfo,rbgloc,PARowid,nbillrid,myReceiptNo,rbInvIdx,myinstypenew,SFlag,OldINVRID)
		.s ^TMP1("BillINV",$j,rbInvIdx,"RNO")= myReceiptNo		;票据号码
		.s rtn=$p(rtnvalue,"^")
		.i rtn=0 d
		..s myIvtRID=$p(rtnvalue,"^",2)
		.q:+rtn'=0
		.s myrbpatsum=+myrbpatsum+$p(^DHCINVPRT(myIvtRID),"^",16)
		.s myRecNoStr=myRecNoStr_$g(myIvtRID)_"^"
		.q:+rtn'=0
		.;完成票据
	
	b  ;判断价格?此处的风险最低
	;判断价格?此处的风险最低
	s:+myrbpatsum'=+myPatPaySum rtn=102
	
	b	;+myrbpatsum'=+myPatPaySum
	d ..KTMP()	
	
	;不打印票据时返回RID=""
	i prtflag=1 s myRecNoStr=""
	
	i rtn=0 d ..tc()
	else  TRollBack
	
	;累加结算金额
	i ((rtn=0)&&(userno'="")) d
	.s ^TMP1("OPCal",userno,"FS")=+$g(^TMP1("OPCal",userno,"FS"))+myrbpatsum
	
	Q rtn_"^"_myRecNoStr
}

ClassMethod ReadDefInsType() As %String
{
	/////获取默认的非别?
	/////w ##class(web.DHCBillCons).ReadDefInsType()
	s $ZT="ERROR^DHCSSERR"
	
	s InsTypeDR=""
	Set JfCF=$o(^DHCTarC("CF",""))
	If (InsTypeDR="")&(JfCF'="") Set InsTypeDR=$P($g(^DHCTarC("CF",JfCF)),"^",3)
	q InsTypeDR
}

ClassMethod ReadPatFSum(sUser As %String) As %String
{
	///w ##class(web.DHCBillCons).ReadPatFSum("10137")
	q:$d(^TMP1("OPCal",sUser,"FS"))=0 $fn(0,"",2)
	s myFSum=+$g(^TMP1("OPCal",sUser,"FS"))
	s myFSum=$fn(myFSum,"",2)
	q myFSum
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
	....s Total=Total+Sum
	....i loctype="D"  d
	.....;统计接收科室?药房?
	.....i $d(^TMP1("Loc",$j,myIdx))=0  s ^TMP1("Loc",$j,myIdx)=reloc
	.....i $d(^TMP1("Loc",$j,myIdx,reloc,Presno))=0  s ^TMP1("Loc",$j,myIdx,reloc,Presno)=Presno
	q 0
}

ClassMethod SaveINV(suser As %String, InvAcount As %String, Payinfo As %String, gloc As %String, PARowid As %String, newBillRID As %String, ReceipNO As %String, myIdx As %String, myrbinstype As %String, SFlag As %String, OldINVRID As %String = "") As %String
{
	;suser   SS_User->RowID
	;InvAcount	当前票据钱数   此钱是患者支付钱数?
	;Payinfo 	界面传入的支付方式和支票号码
	;gloc		操作员登陆科室
	;PARowid	Pa_PatMas->rowid
	;newBillRID	当前票据下的新的账单RowID串
	;ReceipNO	当前的票据号码?
	;myrbinstype		费别类型?
	;;n (suser,InvAcount,Payinfo,gloc,PARowid,newBillRID,ReceipNO,myIdx,myrbinstype, SFlag)
	
	s $ZT="ERROR^DHCSSERR"
	s suser=$g(suser)
	s InvAcount=$g(InvAcount)
	s gloc=$g(gloc)
	s PARowid=$g(PARowid)
	
	;write AR_Receipts table  and PayMode
	s rtn=0
	s myarPayInfo=InvAcount_"^"_Payinfo
	s ret=##class(web.udhcOPBill).InsertReceipts(myarPayInfo,suser,gloc,PARowid)
	
	set rtn=$p(ret,"^")
	q:rtn		;
	
	s ARRCP=$p(ret,"^",2)
	s INVRowid=""
	
	;取得发票号
	s prtflag=##class(web.DHCOPConfig).GetReasonConfig(myinstypenew)
	i +prtflag=0 d
	.&sql(select inv_lastnum,inv_rowid,inv_EndInv into:ReceipNO,:rid,:endno from dhc_invoice 
	     where inv_rowid=(select min(inv_rowid)  from dhc_invoice 
	     where inv_usr= :suser and INV_Finalflag='Y' and INV_type='O'))
	.s rtn=SQLCODE
	q:rtn rtn
	
	s totsum=0
	s patsum=0
	s discsum=0
	s paysum=0
	;分别计算票据金额?
	s mylen=$l(newBillRID,$c(2))-1
	f i=1:1:mylen q:rtn'=0  d
		.s mybillnoRid=$p(newBillRID,$c(2),i)		;循环取出新账单RowID
		.s myPaADMRowid=$p(^DHCPB(mybillnoRid),"^",1)		;DHC_PatientBill->PB_Adm_Dr
		.;获取此票据金额
		.s totsum=+totsum+$p(^DHCPB(mybillnoRid),"^",8)
		.s discsum=+discsum+$p(^DHCPB(mybillnoRid),"^",9)
		.s paysum=+paysum+$p(^DHCPB(mybillnoRid),"^",11)
		.s patsum=+patsum+$p(^DHCPB(mybillnoRid),"^",12)
	
	;插入DHC_INVPRT
	s InvDate=+$h
	s InvTime=$p($h,",",2)
	&sql(insert into DHC_INVPRT 
	(PRT_Acount,PRT_ARRCP_DR,PRT_Date,PRT_Flag,PRT_PAPMI_DR,PRT_UseINVType,
			PRT_SocialStatus,PRT_Time,PRT_Usr,PRT_inv,PRT_PayorShare,
			PRT_DiscAmount, PRT_PatientShare, PRT_InsType_DR, PRT_OldINV_DR)
	     values(:totsum,:ARRCP,:InvDate,'N',:PARowid,'O','',:InvTime,:suser,
	     :ReceipNO,:paysum,:discsum,:patsum,:myrbinstype, :OldINVRID))
	s rtn=SQLCODE
	q:rtn rtn
	
	;票据RowID
	s INVRowid=$g(%ROWID)
	
	;保存发票表与帐单表的关系
	s mylen=$l(newBillRID,$c(2))-1
	f i=1:1:mylen q:rtn'=0  d
		.s mybillnoRid=$p(newBillRID,$c(2),i)		;循环取出新账单RowID
		.s myPaADMRowid=$p(^DHCPB(mybillnoRid),"^",1)		;DHC_PatientBill->PB_Adm_Dr
		.&sql(insert into DHC_BillConINV (DHCBCI_ADMDR,DHCBCI_INVDR,DHCBCI_PatBillDR)
	     values (:myPaADMRowid,:INVRowid,:mybillnoRid))
		.s rtn=SQLCODE	;
		.q:rtn	;
		.;设置账单为Paid
		.s rtn=##class(web.udhcOPBill).Updatearpbl(mybillnoRid,suser)
		.q:rtn	;
	q:rtn rtn
	
	;更新发票表
	i +prtflag=0 d
	.s ReceipNew=+ReceipNO+1
	.s rtn=##class(web.udhcOPBill).UpdateReceipNO(suser,ReceipNew)
	Q:rtn rtn
	
	;向药房传接口信息
	;收费过程中  在收费过程中向门诊药房传递数据?退费过程在退费中完成;
	i SFlag=0  d
	.i $d(^TMP1("Loc",$j,myIdx))'=0  d
	..s Loc="" f  s Loc=$o(^TMP1("Loc",$j,myIdx,Loc)) q:((Loc="")||(rtn'=0))  d
	...s phwinfo=^TMP1("Loc",$j,Loc)
	...s phl=$p(phwinfo,"^",1)
	...s phw=$p(phwinfo,"^",2)
	...s phwno=$p(phwinfo,"^",4)
	...s ddate=$p($h,",",1)
	...s ttime=$p($h,",",2)
	...s PhaPrescno="" f  s PhaPrescno=$o(^TMP1("Loc",$j,Loc,PhaPrescno)) q:((PhaPrescno="")||(rtn'=0))  d
	....&sql(insert into DHC_PHARWIN 
			(PHA_PRT_DR,PHA_PrescNo,PHA_DATE,PHA_TIME,PHA_PHW_DR,PHA_PHL_DR,pha_lcdserialno)
				values(:INVRowid,:PhaPrescno,:ddate,:ttime,:phw,:phl,:phwno))
	....s rtn=SQLCODE

		
	q:rtn rtn
	
	Quit rtn_"^"_INVRowid
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
 n SQLCODE
 TCOMMIT  s SQLCODE=$zu(34)
 q
}

}
