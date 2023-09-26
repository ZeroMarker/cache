Class BILL.EINV.BL.COM.PECommon Extends %RegisteredObject
{

/// 功能说明：根据发票Rowid获取体检发票相关信息
/// 入参说明: HISPrtRowID     --> HIS发生业务发票ID
///           ObjInvPrt 	  --> 发票信息对象
///           InvociePam	  --> 参数对象[出参]
/// 返 回 值: 0 成功 其他值代表失败
/// 修改履历：徐保保 2019 09 19 新做成
/// ///  2020-9-28 yandong
/// ##class(BILL.EINV.BL.COM.PECommon).GetPEInvPrtInfoObjByPrtId(HISPrtRowID,.ObjInvPrt,.InvociePam)
ClassMethod GetPEInvPrtInfoObjByPrtId(HISPrtRowID As %String, ByRef ObjInvPrt As BILL.EINV.DTO.COM.InvPrtInfo, ByRef InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	s InvPrtInfo=$g(^DHCPEINVPRT(HISPrtRowID))       ; 体检表->DHC_PE_INVPRT
	s:InvPrtInfo="" InvociePam.ErrMsgInfo="体检发票表无相关数据"
	q:InvPrtInfo="" RtnFlag
	
	//给发票对象赋值
	s ObjInvPrt.BusinessNo=""						;流水号
	s ObjInvPrt.BusDate=$p(InvPrtInfo,"^",11)   	;缴费日期
	s ObjInvPrt.BusTime=$p(InvPrtInfo,"^",12)  	    ;缴费时间
	s ObjInvPrt.InvAmt=$fn(+$p(InvPrtInfo,"^",7),"",2)			;总金额
	s ObjInvPrt.InvShareAmt="0"						;自付金额
	s ObjInvPrt.BusUserId=$p(InvPrtInfo,"^",10)		;结算人ID	
	s ObjInvPrt.BusUserCode=$p($g(^SSU("SSUSR",ObjInvPrt.BusUserId)),"^",1)  ;结算人编码
	s ObjInvPrt.BusUserDesc=$p($g(^SSU("SSUSR",ObjInvPrt.BusUserId)),"^",2)  ;结算人名称
	s ObjInvPrt.InvNo=$p(InvPrtInfo,"^",1)   		;发票号
	s ObjInvPrt.InvFlag=$p(InvPrtInfo,"^",8)   		;结算状态
	s ObjInvPrt.InvInit=$p(InvPrtInfo,"^",9)   		;正记录ID
	s ObjInvPrt.PrtHospDr=$p(InvPrtInfo,"^",26)    ;院区指针
	s ObjInvPrt.InvoceType="EH"
	s ObjInvPrt.GroupDr=""
	
	///发票信息
	s InvName="",TaxpayerNum="",InvType="I"
	if $D(^DHCPEDataEx("TaxpayerNum",HISPrtRowID)) d
	.s TaxpayerNum=$G(^DHCPEDataEx("TaxpayerNum",HISPrtRowID))
	s paadm=$p($G(^DHCPEINVPRT(HISPrtRowID)),"^",2)
	s patid=$p($g(^PAADM(paadm)),"^",1)
	s giadmid=""
	s giadmid=$o(^DHCPEIADM(0,"PAADM",paadm,""))
	i giadmid'=""  d
	.s InvType="I"
	e  d
	.s InvType="G"
	s patname=$p($g(^PAPER(patid,"ALL")),"^",1)
	if $D(^DHCPEDataEx("InvName",HISPrtRowID)) d
	.s InvName=$G(^DHCPEDataEx("InvName",HISPrtRowID))
	s:InvName="" InvName=patname
	
	s ObjInvPrt.PEBaseInfo=##class(BILL.EINV.DTO.COM.PEBaseInfo).%New()
	s ObjInvPrt.PEBaseInfo.InvType=InvType
	s ObjInvPrt.PEBaseInfo.PrintName=InvName
	s ObjInvPrt.PEBaseInfo.TaxpayerNum=TaxpayerNum
	
	;s ObjInvPrt.InsTypeDr=$p($g(^DHCPEOEITEM(HISPrtRowID)),"^",4)
	;s:ObjInvPrt.InsTypeDr="" ObjInvPrt.InsTypeDr="1"
	
	//根据发票rowid获取医保结算相关信息  -->Insu_Divide(医保结算表);Insu_AdmInfo(医保登记表)
	//add by xubaobao 2020 08 10 结算对象赋初始值
	//如果为退费需要通过正票ID获取医保结算数据
	;s InvPrtRowid=HISPrtRowID
	;i ObjInvPrt.InvInit'="" s InvPrtRowid=ObjInvPrt.InvInit
	;s flag=##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr(InvPrtRowid, "", .ObjInvPrt,"PE")
	;s:(flag'="0")&&($d(^DHCINDIV("0","DHCInvPrt",HISPrtRowID))) InvociePam.ErrMsgInfo="获取体检医保结算信息对象失败"
	;q:(flag'="0")&&($d(^DHCINDIV("0","DHCInvPrt",HISPrtRowID))) RtnFlg
	
	//add by xubaobao 2020 09 08
	//通过医保结算表ID获取医保结算数据
	s DivDr=$p($g(^DHCPEOEITEM(HISPrtRowID)),"^",4)
	d ##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr(DivDr, .ObjInvPrt)
	;s:(flag'="0")&&(+admNationalCode>0)&&(ObjInvPrt.InvAmt>0) InvociePam.ErrMsgInfo="获取医保结算信息对象失败"
	;q:(flag'="0")&&(+admNationalCode>0)&&(ObjInvPrt.InvAmt>0) RtnFlg
	
	//根据体检发票rowid获取支付方式相关信息  -->AR_Receipts;R_RcptPayMode(发票表的支付方式表) 
	s flag=##class(BILL.EINV.BL.COM.PECommon).GetPEPayModeInfoByDr(HISPrtRowID,  .ObjInvPrt)
	s:flag'="0" InvociePam.ErrMsgInfo="获取体检发票支付方式对象失败"
	q:flag'="0" RtnFlag
	
	//根据体检发票rowid获取门诊大类相关信息     -->DHC_TarOC(门诊分类)
	s flag=##class(BILL.EINV.BL.COM.PECommon).GetPECatFeeInfoByDr(HISPrtRowID,  .ObjInvPrt)
	s:flag'="0" InvociePam.ErrMsgInfo="获取体检发票收费大类对象失败"
	q:flag'="0" RtnFlag
	
	//根据发票rowid获取费用明细相关信息    -->DHC_PE_Invprt  ^DHCPEOEITEM
	s flag=##class(BILL.EINV.BL.COM.PECommon).GetPEFeeDetailInfo(HISPrtRowID, .ObjInvPrt)
	s:flag'="0" InvociePam.ErrMsgInfo="获取体检发票费用明细对象失败"
	q:flag'="0" RtnFlag
	

	
	s RtnFlag="0"
	
	q RtnFlag
}

/// yandong
/// 2020-6-23
/// 获取体检支付方式信息
/// 修改履历：徐保保 2020 08 07 新加
/// ///  2020-9-28 yandong
/// w ##class(BILL.EINV.BL.COM.PECommon).GetPEPayModeStrByInvDr("2246","")
ClassMethod GetPEPayModeInfoByDr(InvDr As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo) As %String
{
	s RtnFlg="-1"
	q:(InvDr="") RtnFlg

	s PayModeStr=""
	s ARRCPID=$P(^DHCPEINVPRT(InvDr),"^",4)
	s PAADM=$P(^DHCPEINVPRT(InvDr),"^",2)
	s PapmiID=$P(^PAADM(PAADM),"^",1)
	q:ARRCPID="" PayModeStr
	s PAYMSub=0
	f  s PAYMSub=$O(^ARRCP(ARRCPID,"PAYM",PAYMSub)) q:PAYMSub=""  d
	.s PayModeID=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",1)
	.s PayMode=$P(^CT("CTPM",PayModeID),"^",1)
	.s PayModeDesc=$P(^CT("CTPM",PayModeID),"^",2)
	.s Amt=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",3)
	.q:+Amt=0
	.
	.i PayModeStr="" d
	..s PayModeStr=PayMode_":"_PayModeDesc_":"_Amt
	.e  d
	..s PayModeStr=PayModeStr_","_PayMode_":"_PayModeDesc_":"_Amt
	
	
	q:PayModeStr="" RtnFlg
	
	//支付方式信息对象赋值
	f num=1:1:$l(PayModeStr,",") d
	.s PayModeInfo=$p(PayModeStr,",",num)
	.s PayModeObj=##class(BILL.EINV.DTO.COM.InvPayModeInfo).%New()
	.s PayModeObj.Code=$p(PayModeInfo,":",1)      //支付方式编码
	.s PayModeObj.Desc=$p(PayModeInfo,":",2)      //支付方式名称
	.s PayModeObj.Amt=$p(PayModeInfo,":",3)       //支付方式金额
	.q:(+PayModeObj.Amt)=0		;add by xubaobao 2020 08 10 支付方式金额为空或者为0时补上传(包括当住院结算除了冲退预交金在没有支付方式时)
	.s PayModeObj.Amt=$fn(PayModeObj.Amt,"",2)
	.d InvPrtInfoObj.PayModeInfo.Insert(PayModeObj)
	.;d PayModeObj.%Close()
	
	s RtnFlg="0"
	
	q RtnFlg
}

/// 功能说明：根据发票ID获大类(子分类)ID、名称和金额、编码
/// 修改履历：徐保保 2020 08 07 新加
/// ////  2020-9-28 yandong
/// 修改时间：2020 09 28 yandong
/// 入参：Papmi		病人ID
/// 	  PrtInvType  票据类型(PI：住院票据,PO：门诊票据,PR：挂号票据,PD：押金票据,PH:体检票据)
/// 	  StaDate	开始日期
/// 	  EndDate	结束日期
/// 出参：进程号^数量
/// w ##class(BILL.EINV.BL.COM.PECommon).GetInvDetailsInfoByPapmi("1")
ClassMethod GetPECatFeeInfoByDr(InvDr As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo) As %String
{
	s RtnFlg="-1"
	q:(InvDr="") RtnFlg
	
	//0 给第三方传门诊子分类；1 给第三方传门诊分类
	s CatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case", "OPFeeCate_Source", 5)
	//第三方电子发票不区分门诊、住院分类时，his传分类编码时需要做区分
	s FeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case", "OPFeeCate_Source", 6)
	k PECateList	 
	s FH=1
	s RefundId=$P(^DHCPEINVPRT(InvDr),"^",9)	//退费ID
	i RefundId'="" d
	.s InvDr=RefundId,FH=-1
	
	s PreItemID=""
  	f  s PreItemID=$O(^DHCPEOEITEM(InvDr,"OEITEM",PreItemID)) q:PreItemID=""  d			 //,"TARITEM",itmsub)
	.s TARITEMSub=""
	.f  s TARITEMSub=$O(^DHCPEOEITEM(InvDr,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	..s InvDetailInfo=$G(^DHCPEOEITEM(InvDr,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..s TarId=$P(InvDetailInfo,"^",1)
	..s amount=(+$P(InvDetailInfo,"^",4))*FH
	..q:(TarId="")||(+amount=0)
	..s OPSubCat=$P(^DHCTARI(TarId),"^",15)			//门诊收费子分类
	..s OPCat=$P(^DHCTarC("OC",OPSubCat),"^",3)		//门诊收费大类
	..s:CatFlag="0" PECateList(OPSubCat)=+$g(PECateList(OPSubCat))+amount   ;按照门诊子分类统计
	..s:CatFlag="1" PECateList(OPCat)=+$g(PECateList(OPCat))+amount         ;按照门诊大类统计
	
	s catedr="",CatePayStr="",cateCode="",cateDesc=""
	f  s catedr=$o(PECateList(catedr)) q:(catedr="")  d
	.s:CatFlag="0" cateDesc=$p(^DHCTarC("OC",catedr),"^",2)        ;门诊子分类描述
	.s:CatFlag="0" cateCode=$p(^DHCTarC("OC",catedr),"^",1)		   ;门诊子分类编码
	.s:CatFlag="1" cateDesc=$p(^DHCTarC("TOC",catedr),"^",2)       ;门诊分类描述
	.s:CatFlag="1" cateCode=$p(^DHCTarC("TOC",catedr),"^",1)	   ;门诊分类编码
	.s CateFee=$g(PECateList(catedr))
	.s CateFee=$fn(CateFee,"",2)       	 ;保留两位小数
	.i (CatePayStr="") d
	..s CatePayStr=FeeType_catedr_"^"_cateDesc_"^"_CateFee_"^"_FeeType_cateCode  
	.e  d
	..s CatePayStr=CatePayStr_","_FeeType_catedr_"^"_cateDesc_"^"_CateFee_"^"_FeeType_cateCode
	
	q:CatePayStr="" RtnFlg
	//支付方式信息对象赋值
	f num=1:1:$l(CatePayStr,",") d
	.s CatFeeInfo=$p(CatePayStr,",",num)
	.s CatFeeObj=##class(BILL.EINV.DTO.COM.InvCateInfo).%New()
	.s CatFeeObj.Code=$p(CatFeeInfo,"^",4)      //分类编码--默认取分类编码
	.s CatFeeObj.Desc=$p(CatFeeInfo,"^",2)      //分类名称
	.s CatFeeObj.Amt=$fn(+$p(CatFeeInfo,"^",3),"",2)       //分类总金额
	.d InvPrtInfoObj.InvCateInfo.Insert(CatFeeObj)
	s RtnFlg="0"
	q RtnFlg
}

/// 通过体检发票表ID获取体检费用明细信息
/// 徐保保
///  2020-9-28 yandong
/// 2020 08 07
/// Input:InvPrtDr -发票ID
/// 返回值  ：成功：进程号,""：失败  
/// w ##class(BILL.EINV.BL.COM.PECommon).GetPEFeeDetailByPrtId("2111")
ClassMethod GetPEFeeDetailInfo(InvPrtDr As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo)
{
	s RtnFlg="-1"
	q:InvPrtDr="" RtnFlg
	
	//体检费用明细信息存入到临时global
	s EINVPID=$I(^CacheTemp("BILLEINV","GetFeeDetailSum"))
	k ^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID)
	
	s RefundId=$p($g(^DHCPEINVPRT(InvPrtDr)),"^",9)
	i RefundId'="" s InvPrtDr=RefundId
	s admreasonId=$p($g(^DHCPEOEITEM(InvPrtDr)),"^",4)
	s:admreasonId="" admreasonId="1" 	;跟体检组沟通，如果为空,为自费
	
	s InsuType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AdmReasonDrToTariType",admreasonId,6)  ;获取医保类型
	
	//取门诊大类标记(1：取门诊大类,0：取门诊子分类)
	s OPCatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","OPFeeCate_Source",5)
	s OPFeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","OPFeeCate_Source",6)
	//取住院大类标记(1：取住院大类,0：取住院子分类)
	s IPCatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeCate_Source",5)
	s IPFeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeCate_Source",6)
	
	s num=1
	s PreItemID=""
  	f  s PreItemID=$O(^DHCPEOEITEM(InvPrtDr,"OEITEM",PreItemID)) q:PreItemID=""  d //,"TARITEM",itmsub)
	.s PresNo=""
	.s OEORI=$p($g(^DHCPEOEITEM(InvPrtDr,"OEITEM",PreItemID)),"^",1)	;医嘱id
	.s Arcim=$p($g(^DHCPEOEITEM(InvPrtDr,"OEITEM",PreItemID)),"^",5)	;医嘱项id
	.s BillDate=$p($g(^DHCPEOEITEM(InvPrtDr,"OEITEM",PreItemID)),"^",7)	;体检项目预约日期
	.s ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR  医嘱子类id
	.s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType  医嘱类型
	.i OrderType["R" d
	..s PresNo=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",14)		;处方号
	.s TARITEMSub=""
	.f  s TARITEMSub=$o(^DHCPEOEITEM(InvPrtDr,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	..s InvDetailInfo=$g(^DHCPEOEITEM(InvPrtDr,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..q:InvDetailInfo="" 
	..s tarid=$p(InvDetailInfo,"^",1)
	..s amount=+$p(InvDetailInfo,"^",4)
	..q:amount=0 ;金额为0的不上传
	..s ItemSubCat=$p($g(^DHCTARI(tarid)),"^",15)		;费用子类id
	..s ItemCat=$p(^DHCTarC("SC",ItemSubCat),"^",3)		;门诊费用大类id
	..s UomID=$p(^DHCTARI(tarid),"^",3)					;单位id
	..s ItemUom=$p(^CT("UOM",UomID),"^",2)				;单位名称
	...;//医嘱结构改造后需要从药房接口取
	..s OeTraFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","Drug_INCI_Flg",5)      ;医嘱改造标志，改造传"1"，未改造传其他，默认传"1"
	..s DrugInfo=##class(BILL.EINV.BL.COM.Common).GetDrugInfo(Arcim,tarid,OeTraFlag)   
	..s:DrugInfo="" DrugInfo="^^^^^^^^^"  ;规格^基本单位^入库单位^剂型dr^剂型^厂家^每次用量(等效单位)^频次^剂量单位^批准文号 
	..;获取门诊分类编码,分类名称
    ..s CateCode="",CateDesc=""
    ..i OPCatFlag="1" d
	...s CateCode=OPFeeType_$p($g(^DHCTarC("TOC",ItemCat)),"^",1)  	;门诊分类编码
	...s CateDesc=$p($g(^DHCTarC("TOC",ItemCat)),"^",2)  			;门诊分类名称
	..e  d
	...s CateCode=OPFeeType_$p($g(^DHCTarC("OC",ItemSubCat)),"^",1)  ;门诊子分类编码
	...s CateDesc=$p($g(^DHCTarC("OC",ItemSubCat)),"^",2)  			;门诊子分类名称
	..;获取目录对照关系
    ..s TarItemInsuInfo=""
    ..i InsuType'="" d
    ...s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
 	...s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(tarid,InsuType,BillDate,TariInsuFlag)
    ..s InsuScale=1-(+$p(TarItemInsuInfo,"^",18))	;报销比例
    ..s:TarItemInsuInfo="" InsuScale="0"
 	..s Insutjdm=$p(TarItemInsuInfo,"^",23)			;项目等级
 	..s Remark=$p(TarItemInsuInfo,"^",22)			;备注
 	..s ChrgType=$p(TarItemInsuInfo,"^",1)			;费用类型
 	..s Insuxmlb=$Case($p(TarItemInsuInfo,"^",7),"1":"药品","2":"诊疗项目","3":"服务设施",:"")	;项目类型				
	..s SelfAmt=$fn(amount*(1-(+InsuScale)),"",2)	;自费金额
    ..s DetailNo=TARITEMSub              			;流水号
	..s TarCode=$p($g(^DHCTARI(tarid)),"^",1)       ;项目编码
	..s TarDesc=$p($g(^DHCTARI(tarid)),"^",2)       ;项目名称
	..s Form=$p(DrugInfo,"^",5)       				;剂型
	..s Spec=$p(DrugInfo,"^",1)       				;规格
	..s Price=$p(InvDetailInfo,"^",2)				;单价
	..s Qty=$p(InvDetailInfo,"^",3)					;数量
	..s Amt=amount									;金额
	..s SelfAmt=amount*(1-(+InsuScale))   			;自费金额
    ..s BillDetailsRow=num_"^"_DetailNo_"^"_CateCode_"^"_CateDesc_"^"_PresNo_"^"_TarCode_"^"_TarDesc_"^"_Form_"^"_Spec_"^"_ItemUom_"^"_Price_"^"_Qty_"^"_Amt_"^"_SelfAmt_"^"_Insutjdm_"^"_Insuxmlb_"^"_InsuScale_"^"_Remark
    ..s ^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,num)=BillDetailsRow
    ..s num=num+1
    
    s num=""
    f  s num=$o(^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,num)) q:num=""  d
    .s FeeInfo=$g(^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,num))
    .d ##class(BILL.EINV.BL.COM.Common).SetInvPrtDetailInfo(FeeInfo, .InvPrtInfoObj)
     
    k ^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID)
	s RtnFlg="0"
	q RtnFlg
}

}
