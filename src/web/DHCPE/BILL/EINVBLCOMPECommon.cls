/// 创建人   ：朱飞
/// 创建时间 ：2022-02-22
/// 说明     ：供计费电子发票调用
///          ：替换之前的类BILL.EINV.BL.COM.PECommon（闫栋创建）
///          ：此类在##class(BILL.EINV.BL.COM.Common).GetInvPrtInfo()方法中调用
/// 注释     ：BILL.EINV.DTO.COM.PEBaseInfo这个类今后由计费医保组维护，体检组不允许再修改
Class web.DHCPE.BILL.EINVBLCOMPECommon Extends %RegisteredObject
{

/// 功能说明：根据发票Rowid获取体检发票相关信息
/// 入参说明: HISPrtRowID     --> HIS发生业务发票ID
///           ObjInvPrt 	  --> 发票信息对象
///           InvociePam	  --> 参数对象[出参]
/// 返 回 值: 0 成功 其他值代表失败
/// 修改履历：徐保保 2019 09 19 新做成
/// ///  2020-9-28 yandong
/// ##class(web.DHCPE.BILL.EINVBLCOMPECommon).GetPEInvPrtInfoObjByPrtId(HISPrtRowID,.ObjInvPrt,.InvociePam)
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
	
	s ObjInvPrt.PEBaseInfo=##class(BILL.EINV.DTO.COM.PEBaseInfo).%New()    //BILL.EINV.DTO.COM.PEBaseInfo 这个类计费医保组维护，体检不再改动了。 20220222 zhufei
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
	s flag=..GetPEPayModeInfoByDr(HISPrtRowID,  .ObjInvPrt)
	s:flag'="0" InvociePam.ErrMsgInfo="获取体检发票支付方式对象失败"
	q:flag'="0" RtnFlag
	
	//根据体检发票rowid获取门诊大类相关信息     -->DHC_TarOC(门诊分类)
	s flag=..GetPECatFeeInfoByDr(HISPrtRowID,  .ObjInvPrt)
	s:flag'="0" InvociePam.ErrMsgInfo="获取体检发票收费大类对象失败"
	q:flag'="0" RtnFlag
	
	//根据发票rowid获取费用明细相关信息    -->DHC_PE_Invprt  ^DHCPEOEITEM
	s flag=..GetPEFeeDetailInfo(HISPrtRowID, .ObjInvPrt)
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
/// w ##class(web.DHCPE.BILL.EINVBLCOMPECommon).GetPEPayModeStrByInvDr("2246","")
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
/// w ##class(web.DHCPE.BILL.EINVBLCOMPECommon).GetInvDetailsInfoByPapmi("1")
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
/// w ##class(web.DHCPE.BILL.EINVBLCOMPECommon).GetPEFeeDetailByPrtId("2111")
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
	
	s InsuType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AdmReasonDrToTariType",admreasonId,6,InvPrtInfoObj.PrtHospDr)  ;获取医保类型
	
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

/// 功能说明：根据发票Rowid获取体检发票相关信息
/// 入参说明: HISPrtRowID     --> HIS发生业务发票ID
///           ObjInvPrt 	  --> 发票信息对象
///           InvociePam	  --> 参数对象[出参]
/// 返 回 值: 0 成功 其他值代表失败
/// 修改履历：徐保保 2019 09 19 新做成
/// ///  2020-9-28 yandong
/// ##class(web.DHCPE.BILL.EINVBLCOMPECommon).GetPEInvPrtInfoObjByPrtId(HISPrtRowID,.ObjInvPrt,.InvociePam)
ClassMethod GetPEDepInvPrtInfoObjByPrtId(HISPrtRowID As %String, ByRef ObjInvPrt As BILL.EINV.DTO.COM.InvPrtInfo, ByRef InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	b ;GetPEDepInvPrtInfoObjByPrtId
	s RtnFlag="-1"
	
	s InvPrtInfo=$g(^DHCPEAP(+HISPrtRowID,"AC",$P(HISPrtRowID,"||",2)))  ; 体检表->DHC_PE_APAmountChange 
	s:InvPrtInfo="" InvociePam.ErrMsgInfo="体检发票表无相关数据"
	q:InvPrtInfo="" RtnFlag
	//给发票对象赋值
	s ObjInvPrt.BusinessNo=""						;流水号
	s ObjInvPrt.BusDate=$P(InvPrtInfo,"^",5)   	;缴费日期
	s ObjInvPrt.BusTime=$P(InvPrtInfo,"^",6)  	    ;缴费时间
	s ObjInvPrt.InvAmt=$fn($P(InvPrtInfo,"^",2) ,"",2)			;总金额
	s ObjInvPrt.InvShareAmt="0"						;自付金额
	s ObjInvPrt.BusUserId=$P(InvPrtInfo,"^",7)		;结算人ID	
	s ObjInvPrt.BusUserCode=$p($g(^SSU("SSUSR",ObjInvPrt.BusUserId)),"^",1)  ;结算人编码
	s ObjInvPrt.BusUserDesc=$p($g(^SSU("SSUSR",ObjInvPrt.BusUserId)),"^",2)  ;结算人名称
	s ObjInvPrt.InvNo=""  		;发票号
	s ObjInvPrt.InvFlag=$P(InvPrtInfo,"^",1)    		;结算状态
	s ObjInvPrt.InvInit=$P(InvPrtInfo,"^",4)    		;正记录ID
	s ObjInvPrt.PrtHospDr=$P(InvPrtInfo,"^",15)     ;院区指针
	s ObjInvPrt.InvoceType="EH"
	s ObjInvPrt.GroupDr=""
	
	
	///发票信息
	s InvName="",TaxpayerNum="",InvType="G"
	s APCardType=$P(^DHCPEAP(+HISPrtRowID),"^",3)
	i APCardType="R" d
	.s APRegNo=$P(^DHCPEAP(+HISPrtRowID),"^",1)
	.s PatMasId=$O(^PAPERi("PAPMI_PatNo",APRegNo,0))
	.s InvName=$P(^PAPER(PatMasId,"ALL"),"^",1)
	
	i $D(^DHCPEDataEx("AdvancePayment","InvName",HISPrtRowID)) d
	.s InvName=^DHCPEDataEx("AdvancePayment","InvName",HISPrtRowID)
	e  d
	.s:InvName'="" ^DHCPEDataEx("AdvancePayment","InvName",HISPrtRowID)=InvName
	
	i $D(^DHCPEDataEx("DHCPEAD","TaxpayerNo",HISPrtRowID)) d
	.s TaxpayerNum=$G(^DHCPEDataEx("DHCPEAD","TaxpayerNo",HISPrtRowID))
	s PEBaseInfoObj=##class(BILL.EINV.DTO.COM.PEBaseInfo).%New()
	s PEBaseInfoObj.InvType=InvType
	s PEBaseInfoObj.PrintName=InvName
	s PEBaseInfoObj.TaxpayerNum=TaxpayerNum

	
	
	//add by xubaobao 2020 09 08
	//通过医保结算表ID获取医保结算数据
	s InvPrtRowid=HISPrtRowID
	i ObjInvPrt.InvInit'="" s InvPrtRowid=ObjInvPrt.InvInit
	s flag=##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr(InvPrtRowid,  .ObjInvPrt)
	s:(flag'="0")&&(ObjInvPrt.InsTypeDr'="") InvociePam.ErrMsgInfo="获取体检医保结算信息对象失败"
	q:(flag'="0")&&(ObjInvPrt.InsTypeDr'="") RtnFlg
	//根据体检发票rowid获取支付方式相关信息  -->AR_Receipts;R_RcptPayMode(发票表的支付方式表) 
	s flag=..GetPEDepPayModeInfoByDr(HISPrtRowID,  .ObjInvPrt)
	s:flag'="0" InvociePam.ErrMsgInfo="获取体检发票支付方式对象失败"
	q:flag'="0" RtnFlag
	//根据体检发票rowid获取门诊大类相关信息     -->DHC_TarOC(门诊分类)
	s flag=..GetPEDepCatFeeInfoByDr(HISPrtRowID,  .ObjInvPrt)
	s:flag'="0" InvociePam.ErrMsgInfo="获取体检发票收费大类对象失败"
	q:flag'="0" RtnFlag
	//根据发票rowid获取费用明细相关信息    -->DHC_PE_Invprt  ^DHCPEOEITEM
	;s flag=..GetPEDepFeeDetailInfo(HISPrtRowID, .ObjInvPrt)
	;s:flag'="0" InvociePam.ErrMsgInfo="获取体检发票费用明细对象失败"
	;q:flag'="0" RtnFlag

	
	s RtnFlag="0"
	q RtnFlag
}

/// yandong
/// 2020-6-23
/// 获取体检支付方式信息
/// 修改履历：徐保保 2020 08 07 新加
/// ///  2020-9-28 yandong
/// w ##class(web.DHCPE.BILL.EINVBLCOMPECommon).GetPEPayModeStrByInvDr("2246","")
ClassMethod GetPEDepPayModeInfoByDr(InvDr As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo) As %String
{
	s RtnFlg="-1"
	s InvPrtInfo=$g(^DHCPEAP(+InvDr,"AC",$P(InvDr,"||",2)))  ; 体检表->DHC_PE_APAmountChange 
	
	q:(InvDr="") RtnFlg
	//支付方式信息对象赋值
	s PayMode=$P(InvPrtInfo,"^",10)
 	s PayModeCode=$P(^CT("CTPM",PayMode),"^",1)
	s PayModeDesc=$P(^CT("CTPM",PayMode),"^",2)	
	s PayAmount=$P(InvPrtInfo,"^",2)
	s PayModeStr=PayModeCode_":"_PayModeDesc_":"_PayAmount
	
	
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
/// w ##class(web.DHCPE.BILL.EINVBLCOMPECommon).GetInvDetailsInfoByPapmi("1")
ClassMethod GetPEDepCatFeeInfoByDr(InvDr As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo) As %String
{
	s RtnFlg="-1"
	q:(InvDr="") RtnFlg
	
	//0 给第三方传门诊子分类；1 给第三方传门诊分类
	s CatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case", "OPFeeCate_Source", 5)
	//第三方电子发票不区分门诊、住院分类时，his传分类编码时需要做区分
	s FeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case", "OPFeeCate_Source", 6)
	k PECateList	 
	s FH=1
	s APACType=$P($g(^DHCPEAP(+InvDr,"AC",$P(InvDr,"||",2))),"^",1)
	i APACType="RF" d
	.s InvDr=$P($g(^DHCPEAP(+InvDr,"AC",$P(InvDr,"||",2))),"^",4)
	.s FH=-1
	s amount=$P($g(^DHCPEAP(+InvDr,"AC",$P(InvDr,"||",2))),"^",2)
	s TarId=$G(^DHCPESetting("DHCPE","InvPrtElectronic","DepTar"))
	s OPSubCat=$P(^DHCTARI(TarId),"^",15)			//门诊收费子分类
	s OPCat=$P(^DHCTarC("OC",OPSubCat),"^",3)		//门诊收费大类
	s:CatFlag="0" PECateList(OPSubCat)=+$g(PECateList(OPSubCat))+amount   ;按照门诊子分类统计
	s:CatFlag="1" PECateList(OPCat)=+$g(PECateList(OPCat))+amount         ;按照门诊大类统计

	
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
	b ;CatePayStr
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
/// w ##class(web.DHCPE.BILL.EINVBLCOMPECommon).GetPEFeeDetailByPrtId("2111")
ClassMethod GetPEDepFeeDetailInfo(InvPrtDr As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo)
{
	s RtnFlg="-1"
	q:InvPrtDr="" RtnFlg
	
	//体检费用明细信息存入到临时global
	s EINVPID=$I(^CacheTemp("BILLEINV","GetFeeDetailSum"))
	k ^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID)
	
	
	s APACType=$P($g(^DHCPEAP(+InvPrtDr,"AC",$P(InvPrtDr,"||",2))),"^",1)
	i APACType="RF" d
	.s RefundId=$P($g(^DHCPEAP(+InvPrtDr,"AC",$P(InvPrtDr,"||",2))),"^",4)
	.i RefundId'="" s InvPrtDr=RefundId
	s admreasonId="1" 	;跟体检组沟通，如果为空,为自费
	
	s InsuType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AdmReasonDrToTariType",admreasonId,6)  ;获取医保类型
	
	//取门诊大类标记(1：取门诊大类,0：取门诊子分类)
	s OPCatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","OPFeeCate_Source",5)
	s OPFeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","OPFeeCate_Source",6)
	//取住院大类标记(1：取住院大类,0：取住院子分类)
	s IPCatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeCate_Source",5)
	s IPFeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeCate_Source",6)
    
    s InvPrtInfo=$g(^DHCPEAP(+InvPrtDr,"AC",$P(InvPrtDr,"||",2)))  ; 体检表->DHC_PE_APAmountChange 
    s tarid=$G(^DHCPESetting("DHCPE","InvPrtElectronic","DepTar"))
    s ItemSubCat=$p($g(^DHCTARI(tarid)),"^",15)		;费用子类id
	s ItemCat=$p(^DHCTarC("SC",ItemSubCat),"^",3)		;门诊费用大类id
    s CateCode="",CateDesc=""
    i OPCatFlag="1" d
	.s CateCode=OPFeeType_$p($g(^DHCTarC("TOC",ItemCat)),"^",1)  	;门诊分类编码
	.s CateDesc=$p($g(^DHCTarC("TOC",ItemCat)),"^",2)  			;门诊分类名称
	e  d
	.s CateCode=OPFeeType_$p($g(^DHCTarC("OC",ItemSubCat)),"^",1)  ;门诊子分类编码
	.s CateDesc=$p($g(^DHCTarC("OC",ItemSubCat)),"^",2)  			;门诊子分类名称
	s TarCode=$p($g(^DHCTARI(tarid)),"^",1)       ;项目编码
	s TarDesc=$p($g(^DHCTARI(tarid)),"^",2)       ;项目名称

    s num=1,DetailNo=1,PresNo=""
    s Form="" ;剂型
    s Spec="" ;规格
    s UomID=$p(^DHCTARI(tarid),"^",3)					;单位id
	s ItemUom=$p(^CT("UOM",UomID),"^",2)				;单位名称
    s amount=$P(InvPrtInfo,"^",2)
    s BillDate=$P(InvPrtInfo,"^",5)
    s Qty=1
    s Price=amount
    s Amt=amount
    s TarItemInsuInfo=""
    i InsuType'="" d
    .s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
 	.s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(tarid,InsuType,BillDate,TariInsuFlag)
    .s InsuScale=1-(+$p(TarItemInsuInfo,"^",18))	;报销比例
    .s:TarItemInsuInfo="" InsuScale="0"
 	.s Insutjdm=$p(TarItemInsuInfo,"^",23)			;项目等级
 	.s Remark=$p(TarItemInsuInfo,"^",22)			;备注
 	.s SelfAmt=amount*(1-(+InsuScale))   			;自费金额
 	.s Insuxmlb=$Case($p(TarItemInsuInfo,"^",7),"1":"药品","2":"诊疗项目","3":"服务设施",:"")	;项目类型	
   	e  d
   	.s InsuScale=0
   	.s Insutjdm=""
   	.s Remark=""
   	.s SelfAmt=amount
   	.s Insuxmlb="2"
    s BillDetailsRow=num_"^"_DetailNo_"^"_CateCode_"^"_CateDesc_"^"_PresNo_"^"_TarCode_"^"_TarDesc_"^"_Form_"^"_Spec_"^"_ItemUom_"^"_Price_"^"_Qty_"^"_Amt_"^"_SelfAmt_"^"_Insutjdm_"^"_Insuxmlb_"^"_InsuScale_"^"_Remark
    b ;BillDetailsRow a
    s ^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,num)=BillDetailsRow

    s num=""
    f  s num=$o(^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,num)) q:num=""  d
    .s FeeInfo=$g(^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,num))
    .d ##class(BILL.EINV.BL.COM.Common).SetInvPrtDetailInfo(FeeInfo, .InvPrtInfoObj)
     
    k ^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID)
	s RtnFlg="0"
	q RtnFlg
}

ClassMethod GetPEDepPatInfo(PayAdmType As %String, HISPrtRowID As %String)
{
	s APCardType=$P(^DHCPEAP(+HISPrtRowID),"^",3)
	i APCardType="R" d
	.s APRegNo=$P(^DHCPEAP(+HISPrtRowID),"^",1)
	.s Papmi=$O(^PAPERi("PAPMI_PatNo",APRegNo,0))
	e  d
	.s Papmi=$G(^DHCPESetting("DHCPE","InvPrtElectronic","PEDepPatMas"))
	s admDr=$G(^DHCPESetting("DHCPE","InvPrtElectronic","PEDepPaAdm"))
	q Papmi_"^"_admDr
}

/// 功能说明：根据业务类型和发票信息获取患者基本信息及就诊信息  体检卡充值
/// 入参说明: PayAdmType      --> 票据业务类型
///                               IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
///           HISPrtRowID     --> DHC_PE_APAmountChange
///           ObjPatBaseInfo  --> 患者基本信息
///           ObjPatBaseInfo  --> 患者就诊信息
/// 返 回 值: 0 成功 其他值代表失败
/// 修改履历：靳雷 2020 10 22 
/// w ##class(BILL.EINV.BL.COM.Common).GetPEAPInfoByAPRowId()
ClassMethod GetPEAPInfoByAPRowId(PayAdmType As %String, HISPrtRowID As %String, ByRef ObjPatBaseInfo As BILL.EINV.DTO.COM.PatBaseInfo, ByRef ObjPatAdmInfo As BILL.EINV.DTO.COM.PatAdmInfo) As %String
{
	s RtnFlg="-1"
	s APInfo=..getAPInfo(HISPrtRowID)
	i $isObject(ObjPatBaseInfo)=0  d
	.set ObjPatBaseInfo=##class(BILL.EINV.DTO.COM.PatBaseInfo).%New() 
	s ObjPatBaseInfo.PAPMINO=$p(APInfo,"^",1)     ;登记号
	s ObjPatBaseInfo.PatName=$p(APInfo,"^",2)     ;姓名
	s ObjPatBaseInfo.PatID=$p(APInfo,"^",9)       ;身份证号
	s ObjPatBaseInfo.Sex=$p(APInfo,"^",3)         ;性别
	s ObjPatBaseInfo.Age=$p(APInfo,"^",4)         ;年龄
	s ObjPatBaseInfo.Mobphone=""    ;电话
	s ObjPatBaseInfo.PatEmail=""    ;邮箱
	s ObjPatBaseInfo.CardType="01" //"99" //$G(^DHCPESetting("DHCPE","CardType"))    ;卡类型
	s ObjPatBaseInfo.CardNo="无"      ;卡号
	s ObjPatBaseInfo.Address=""      ;地址
	
	s admDr=$G(^DHCPESetting("DHCPE","InvPrtElectronic","PEDepPaAdm"))
	s AdmNo=$p(^PAADM(admDr),"^",81)
	i $isObject(ObjPatAdmInfo)=0  d
	.s ObjPatAdmInfo=##class(BILL.EINV.DTO.COM.PatAdmInfo).%New()
	s ObjPatAdmInfo.AdmDr=HISPrtRowID     			    ;住院就诊编号
	s ObjPatAdmInfo.AdmNo=""      ;患者就诊编号
	s ObjPatAdmInfo.AdmDate=$p(APInfo,"^",8)    ;就诊日期(住院日期)(格式:yyyy-MM-dd) 
	s APLoc=$p(^PAADM(admDr),"^",4)
	s APDepCode=$P(^CTLOC(APLoc),"^",1)
	s APDepDesc=$P(^CTLOC(APLoc),"^",2)

	s ObjPatAdmInfo.DepCode=APDepCode     ;就诊科室编码
	s ObjPatAdmInfo.DepDesc=APDepDesc     ;就诊科室名称
	s ObjPatAdmInfo.IPNo=""       ;患者住院号
	s ObjPatAdmInfo.MedicalCode=""  ;病历号
	s ObjPatAdmInfo.OutDate=""     ;出院日期
	s ObjPatAdmInfo.OutDepCode=""   ;出院科室编码
	s ObjPatAdmInfo.OutDepDesc=""   ;出院科室名称
	s ObjPatAdmInfo.SpecDesc=""     ;特殊病种名称
	s ObjPatAdmInfo.WardDesc=""     ;病区
	s ObjPatAdmInfo.IPDays=""       ;住院天数
	s ObjPatAdmInfo.BedCode=""      ;床号
	
	q "0"
	
	;s Papmi=$G(^DHCPESetting("DHCPE","InvPrtElectronic","PEDepPatMas"))
	;s admDr=$G(^DHCPESetting("DHCPE","InvPrtElectronic","PEDepPaAdm"))
	;^DHCPESetting("DHCPE","InvPrtElectronic","DepTar")
}

/// w ##class(web.DHCPE.BILL.EINVBLCOMPECommon).getAPInfo("179||1")
ClassMethod getAPInfo(APACRowId)
{
	
	s APRowId=+APACRowId
	s APType=$P(^DHCPEAP(APRowId),"^",3)
	s APNo=$S(
		APType="R":$P(^DHCPEAP(APRowId),"^",1),
		APType="C":$P(^DHCPEAP(APRowId),"^",2)
	)
	//RegNo_"^"_Name_"^"_DOB_"^"_Sex_"^"_CardNo_"^"_RowID_"^"_Status
	s APInfo=##class(web.DHCPE.AdvancePayment).GetPatientInfo(APNo,APType)
	s Name=$P(APInfo,"^",2)
	s Sex=$P(APInfo,"^",4)
	s Age=$P(APInfo,"^",3)
	s IDCard=""
	s Mobphone=""
	s EMail=""
	s CardType=""
	s CardNo=""
	s Address=""
	s AdmDr=""
	s AdmNo=""
	s AdmDate=""
	s APLoc=$P(^DHCPEAP(APRowId),"^",11)
	s APDepCode=$P(^CTLOC(APLoc),"^",1)
	s APDepDesc=$P(^CTLOC(APLoc),"^",2)
	s Date=$P(^DHCPEAP(+APACRowId,"AC",$P(APACRowId,"||",2)),"^",5)
	s:Date'="" Date=##class(websys.Conversions).DateLogicalToHtml(Date)
	i APType="C" s APNo=""
	s TaxpayerNo=""
	i APType="R" s TaxpayerNo=$G(^DHCPEDataEx("DHCPEAD","TaxpayerNo",APACRowId))
	s AType=$P(^DHCPEAP(+APACRowId,"AC",$P(APACRowId,"||",2)),"^",1)
	i AType="RF" d
	.s OrgAPACRowId=$P(^DHCPEAP(+APACRowId,"AC",$P(APACRowId,"||",2)),"^",4)
	.s TaxpayerNo=$G(^DHCPEDataEx("DHCPEAD","TaxpayerNo",OrgAPACRowId))
	
	q APNo_"^"_Name_"^"_Sex_"^"_Age_"^"_APLoc_"^"_APDepCode_"^"_APDepDesc_"^"_Date_"^"_TaxpayerNo
}

/// w ##class(web.DHCPE.BILL.EINVBLCOMPECommon).GetAPInvInfo(533,0,"","PEDep",65727,65727,"210497")
ClassMethod GetAPInvInfo(InvPID, num, UserID, PayAdmType, StaDate, EndDate, Papmi) As %String
{
	s ^TMPDHCPE("GetAPInvInfo")=$LB(InvPID, num, UserID, PayAdmType, StaDate, EndDate, Papmi)
	q:InvPID="" ""
	q:PayAdmType'="PEDep" ""
	
	s $ZT="GetAPInvInfoErr"
	s Flag="N"
	i UserID'="" d
	.f date=StaDate:1:EndDate  d
	..s APRowid=""
	..f  s APRowid=$O(^DHCPEAP(0,"UserDate",UserID,date,APRowid)) q:APRowid=""  d
	...s APSub=0 f APSub=$O(^DHCPEAP(0,"UserDate",UserID,date,APRowid,APSub)) q:APSub=""  d
	....s APACType=$P($g(^DHCPEAP(+APRowid,"AC",APSub)),"^",1)
	....q:((APACType'="B")&(APACType'="R"))
	....s PrtRowid=APRowid_"||"_APSub
	....s Papmi=""
	....s APType=$P(^DHCPEAP(APRowid),"^",3)
	....s num=num+1
	....b ;a
	....s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	e  i Papmi'="" d
	.s APRegNo=$P(^PAPER(Papmi,"PAT",1),"^",1)
	.s APRowid="" f  s APRowid=$O(^DHCPEAP(0,"RegNo",APRegNo,APRowid))  q:APRowid=""  d
	..s APSub=0 f  s APSub=$O(^DHCPEAP(APRowid,"AC",APSub)) q:APSub=""  d
	...s APACType=$P($g(^DHCPEAP(+APRowid,"AC",APSub)),"^",1)
	...b ;aa
	...q:((APACType'="B")&(APACType'="R"))
	...s PrtRowid=APRowid_"||"_APSub
	...s Papmi=""
	...s APType=$P(^DHCPEAP(APRowid),"^",3)
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	b ;^TMP("BILLEINVUPLOAD",InvPID)
	q 0
GetAPInvInfoErr
	;s $ZE=""
	q "-1^"_$ZE
}

ClassMethod GetPEDepINVInfo(HISPrtRowID As %String, UPFlag As %String = "")
{
	s InvStr=""
	s InvPrtInfo=$g(^DHCPEAP(+HISPrtRowID,"AC",$P(HISPrtRowID,"||",2)))  ; 体检表->DHC_PE_APAmountChange 
	s InitRowid=""		;原纪录ID
	s InitRowid=$P(InvPrtInfo,"^",4)
	s PayAdmType="PEDep"	
	//根据发票号和就诊类型判断票据上传标志
	if (UPFlag=""){
		set uploadFlag=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetTradeUplodeFlag(PayAdmType,HISPrtRowID)
		quit:(uploadFlag="Y") ""			;过滤已经上传成功
	}
		
	set prtUser=$P(InvPrtInfo,"^",7)		;操作员ID  体检组存的操作员位置换了 取第10个位置操作员
	set prtGroup=""	;安全组ID
	set prtHosp=$P(InvPrtInfo,"^",15)		;院区ID
	set PrtAmount=$fn($P(InvPrtInfo,"^",2) ,"",2)   ;金额
	set PrtDate=$P(InvPrtInfo,"^",5)		;结算日期
	set PrtTime=$P(InvPrtInfo,"^",6)		;结算时间
	set:(PrtDate'="") PrtDate=$zd(PrtDate,3)
	set:(PrtTime'="") PrtTime=$zt(PrtTime,1)
	set prtLocDr=""			;科室ID
	set ExpStr=prtUser_"^"_prtGroup_"^"_prtHosp_"^"_prtLocDr_"^"_PrtAmount_"^"_PrtDate_"^"_PrtTime
	set InvStr=ExpStr_"&"_InitRowid_"&"_PayAdmType
	quit InvStr
}

}
