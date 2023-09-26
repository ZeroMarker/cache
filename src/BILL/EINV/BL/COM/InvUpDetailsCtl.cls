Import SQLUser

/// 名称: 		BILL.EINV.BL.COM.InvUpDetailsCtl.cls
/// 描述: 		计费发票交易数据维护
/// 编写日期: 	2019-09-16
Class BILL.EINV.BL.COM.InvUpDetailsCtl Extends %RegisteredObject
{

/// 功能说明：保存服务返回结果信息到交易表中
/// 入参说明：ObjInvUpDetail --> 交易业务对象
///           InvociePam     --> 入参对象
/// 返 回 值：0 成功 负值代表失败
/// 修改履历：董科锋  2019-09-18 新做成
///           董科锋  2019-09-24 冲红、换开纸质、换开纸质冲红等交易发生时 更新原交易表的状态标志
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).SaveServiceResult
ClassMethod SaveServiceResult(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtnFlg="0"
	
	tstart   ;开始事务
	
	s objInv=ObjInvUpDetail.ToInvUpDetails()   ;转换为实体类对象
	if $isobject(objInv) {
		s sc=objInv.%Save()
		if ($System.Status.IsError(sc)) {
			s rtnFlg="-1"
		}else{
			s rtnFlg=..UpdateOriTradeFlg(ObjInvUpDetail, InvociePam)  ;更新原交易表的状态标志
		}
	}
	
	
	i rtnFlg="0" d
	.tcommit     ;提交事务
	e  d
	.trollback   ;回滚事务
	
	q rtnFlg
}

/// 功能说明：更新原交易表的状态标志
///           换开交易时 把原来电子票据交易数据的状态标志修改为 已换开
///           冲红电子票据时 把原来的电子票据交易数据的状态改为 被冲红
///           换开纸质发票冲红时 把原来换开纸质发票交易的状态修改为 被冲红 并且把最初的电子发票交易数据的状态修改为 被冲红
/// 入参说明：ObjInvUpDetail --> 交易业务对象
///           InvociePam     --> 入参对象
/// 返 回 值：0 成功 负值代表失败
ClassMethod UpdateOriTradeFlg(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlg="0"

	s PathCode=InvociePam.PathCode  ;申请路径代码
	s OrgTradeFlg=..HaveOrgTradeFlg(PathCode)   ;当前发票业务是否有原交易
	q:OrgTradeFlg'="1" RtnFlg
	
	s EInvFlg="B"  ;被冲红 电子票据冲红的场合及作废已换开票据的场合 原交易表标志修改为被冲红 
	s:PathCode="PrintPaper" EInvFlg="H"       ;已换开 打印纸质发票，原电子票据的标志设置为已换开状态
	s:PathCode="RePrintPaper" EInvFlg="H"   ;已换开 重新打印纸质票据，原电子票据的标志设置为已换开状态
	
	//原交易表Dr  
	//电子票据冲红的场合 这里是原电子票据开具交易表Dr  
	//作废已换开纸质票据 这里是原来换开纸质票据交易表Dr
	//打印纸质发票       这里是原电子票据交易表Dr
	//重新打印纸质票据   这里是原电子票据交易表Dr
	s IUDInitRowID=ObjInvUpDetail.IUDInitRowID
	q:IUDInitRowID="" "-1"
	
	s objInvSrc=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDInitRowID)
	s objInvSrc.EInvFlg=EInvFlg
	s:PathCode="PrintPaper" objInvSrc.IUDPrintFlag="1"   ;add by xubaobao 2019-10-09已换开,打印纸质发票时，更新原电子发票打印状态 
	s sc1=objInvSrc.%Save()  ;更新原交易表 状态标志
	if $System.Status.IsError(sc1){
		s RtnFlg="-1"
	}
	q:RtnFlg="-1" RtnFlg
	
	//作废已换开票据的情况下，也需要把最初的电子发票标志 由"已换开" 变为 "被冲红"状态
	if (PathCode="InvalidPaperInv") {
		s EInvFlg="B"  ;被冲红
		s IUDInitRowID=ObjInvUpDetail.OriInvUpDetail.IUDInitRowID  ;最初的电子票据 对应的交易表Dr
		s:IUDInitRowID="" RtnFlg="-1"
		q:RtnFlg="-1"
		
		s objInvSrcE=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDInitRowID,0)
		s objInvSrcE.EInvFlg=EInvFlg
		s objInvSrc.IUDPrintFlag="0"
		s sc2=objInvSrcE.%Save()   ;更新最初的电子票据交易的 状态标志
		if $System.Status.IsError(sc2){
			s RtnFlg="-1"
		}
	}
	
	// 重新打印纸质票据场合, 需要把 原来的打印纸质发票交易状态改为已作废
	if (PathCode="RePrintPaper") {
		s OriPaperUpDetailDr=InvociePam.OriPaperUpDetailDr  ;原已换开纸质票据 交易表Dr (重新换开纸质票据的时候使用)
		s:OriPaperUpDetailDr="" RtnFlg="-1"
		q:RtnFlg="-1"
		
		s EInvFlg="A"  ;作废
		s objInvSrcE=##class(BILL.EINV.PO.InvUpDetails).%OpenId(OriPaperUpDetailDr,0)
		s objInvSrcE.EInvFlg=EInvFlg
		s sc3=objInvSrcE.%Save()   ;更新最初的电子票据交易的 状态标志
		if $System.Status.IsError(sc3){
			s RtnFlg="-1"
		}
	}
	
	q RtnFlg
}

/// 功能说明：获取交易表中是否成功的状态标志
/// 入参说明: PayAdmType      --> 票据业务类型
///                               IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
///           HISPrtRowID     --> HIS发生业务发票ID
///           IUDPrintType    --> 票据模式 E-电子票据 P-纸质发票
/// 返 回 值：Y 成功 N失败
/// 修改履历：董科锋  2019-09-20 新做成
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetTradeUplodeFlag()
ClassMethod GetTradeUplodeFlag(PayAdmType As %String, HISPrtRowID As %String, IUDPrintType As %String = "E") As %String
{
	s RtnFlg="N"
	q:(PayAdmType="")||(HISPrtRowID="")||(IUDPrintType="") RtnFlg
	
	
	;上传成功数据成功的数据是否存在
	s rowid=$o(^BILL.EINV.PO.InvUpDetailsI("IdxIUDUplodeFlag", PayAdmType, HISPrtRowID, IUDPrintType, "Y", ""))
	s:rowid'="" RtnFlg="Y"
	
	/*-dongkf 2019 09 20
	s rowid=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR", PayAdmType, HISPrtRowID, ""))
	q:rowid="" RtnFlg  ;无交易数据时候认为本次交易未成功
	
	s objInvUpDetails=##class(BILL.EINV.PO.InvUpDetails).%OpenId(rowid)
	q:$isobject(objInvUpDetails)=0 RtnFlg
	s RtnFlg=objInvUpDetails.IUDUplodeFlag  ;上传标志 Y:上传成功，N:上传失败
	s:RtnFlg="" RtnFlg="N"
	*/
	
	q RtnFlg
}

/// 功能说明：根据业务类型、发票号、票据类型获取 交易明细表的最新一条数据的Dr和票据状态标志
/// 入参说明：PayAdmType   --> 业务类型
///           HISPrtRowID  --> His发票表Dr
///           IUDPrintType --> 票据类型 E-电子票据 P-纸质发票
///           OrgHISPrtRowID  --> 原纪录ID
///           PathCode 		  --> 接口业务类型
/// 返 回 值：交易表Dr^交易表状态
/// 修改履历：董科锋 2019-09-26  新做成
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetTradeDrAndFlg
ClassMethod GetTradeDrAndFlg(PayAdmType As %String, HISPrtRowID As %String, IUDPrintType As %String, OrgHISPrtRowID As %String, PathCode As %String) As %String
{
	s RtnInfo=""
	s IUDRowId=""
	s EInvFlg=""
	
	s rowid=""
	f  s rowid=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey",PayAdmType,HISPrtRowID,IUDPrintType,rowid),-1) q:((rowid="")||(EInvFlg'=""))  d
	.s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(rowid,0)
	.s EInvFlg=objUpDetail.EInvFlg     ;票据标志 I 正常开具 B 被冲红 S 冲红 H 已换开
	.s IUDRowId=rowid
	
	//冲红时要根据原业务表id，查找是否有新的开具业务
	if (PathCode="InvalidInv") {
		s EInvFlgTmp=""
		s Orgrowid=""
		f  s Orgrowid=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey",PayAdmType,OrgHISPrtRowID,IUDPrintType,Orgrowid),-1) q:((Orgrowid="")||(EInvFlgTmp'=""))  d
		.s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(Orgrowid,0)
		.s EInvFlgTmp=objUpDetail.EInvFlg  ;票据标志 I 正常开具 B 被冲红 S 冲红 H 已换开
		
		s EInvFlg=EInvFlgTmp
	}
	
	/*
	s IUDRowId=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey",PayAdmType,HISPrtRowID,IUDPrintType, ""), -1)
	if (IUDRowId'="") {
		s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDRowId)
		if $IsObject(objUpDetail){
			s EInvFlg=objUpDetail.EInvFlg  ;票据标志 I 正常开具 B 被冲红 S 冲红 H 已换开
		}
	}
	
	//冲红时要根据原业务表id，查找是否有新的开具业务
	if PathCode="InvalidInv" {
		s Orgrowid=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey", PayAdmType, OrgHISPrtRowID, IUDPrintType, ""), -1) 
		if (Orgrowid'="") {
			s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(Orgrowid)
			if $IsObject(objUpDetail){
				s EInvFlg=objUpDetail.EInvFlg  ;票据标志 I 正常开具 B 被冲红 S 冲红 H 已换开
			}
		}
	}
	*/
	
	s RtnInfo=IUDRowId_"^"_EInvFlg
	q RtnInfo
}

/// 功能说明：判断当前交易是否已经存在(由于换开纸质票据业务后，
///           还允许有重新换开纸质业务所以这里也记录了原换开纸质票据业务表Dr)
/// 入参说明：InvociePam --> 交易入参对象
/// 返 回 值：0 合法 -1 不合法
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).CheckTradeExistFlg
ClassMethod ChecNowkTradeFlg(InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlg="0"
	s ErrMsg=""
	
	s PayAdmType = InvociePam.PayAdmType
	s HISPrtRowID= InvociePam.HISPrtRowID
	s OrgHISPrtRowID= InvociePam.OrgHISPrtRowID
	s PathCode =InvociePam.PathCode
	s IUDPrintType=InvociePam.IUDPrintType         ;票据类型
	
	s TradeDrAndFlg=..GetTradeDrAndFlg(PayAdmType, HISPrtRowID,IUDPrintType,OrgHISPrtRowID,PathCode)  ;根据业务类型、发票号、票据类型获取 交易明细表的最新一条数据的Dr和票据状态标志
	s TradeDr=$p(TradeDrAndFlg, "^", 1)    ;交易明细表Dr
	s DrAndFlg=$p(TradeDrAndFlg, "^", 2)   ;票据状态标志
	
	//票据开具
	if PathCode="Invoice" {
		s:(DrAndFlg="I")||(DrAndFlg="H") RtnFlg="-1"
		s:RtnFlg="-1" InvociePam.ErrMsgInfo="[电子票据开具]业务已经存在,请不要重复操作!"
		;s:(DrAndFlg="B") RtnFlg="-2"	;add by xubaobao 2020 04 27
		;s:RtnFlg="-2" InvociePam.ErrMsgInfo="[电子票据开具]业务已经被冲红,请不要重复操作!"
		
		//2.9判断当前发票是否可以开具电子发票  add 2023-02-02 guoyunlong
        //主要控制重复开票,主要控制被作废发票在terminal里面运行开票，导致重复开票问题
        s EinvFlag=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetPrtInvBillFlag(PayAdmType, HISPrtRowID,IUDPrintType)
	    i (EinvFlag="N") d			;过滤已经上传成功
	    .s InvociePam.ErrMsgInfo="业务类型:"_PayAdmType_",发票ID:"_HISPrtRowID_",不允许开具电子发票,请核对发票数据"
	    .s RtnFlg="-1"	
	}
	q:(RtnFlg'="0") RtnFlg
	//作废冲红票据
	if PathCode="InvalidInv" {
		;s:(DrAndFlg="S") RtnFlg="-1"
		s:(DrAndFlg="S")||(DrAndFlg="B") RtnFlg="-1"         ;add by xubaobao 2019 09 26
		;s:DrAndFlg="I" InvociePam.UpDetailDr=TradeDr 
		s InvociePam.ErrMsgInfo="[作废冲红电子票据]业务已经存在,请不要重复操作!"
	}
	q:RtnFlg'="0" RtnFlg
	
	//+dongkf 2019 12 19 start
	//作废冲红票据(仅仅冲红第三方的票据,his未发生退费)
	if PathCode="InvalidInvSvr" {
		s:(DrAndFlg="S")||(DrAndFlg="B") RtnFlg="-1"
		;s:DrAndFlg="I" InvociePam.UpDetailDr=TradeDr
		s InvociePam.ErrMsgInfo="当前票据已经[作废冲红],请不要重复操作(仅冲红第三方数据)!"
	}
	q:RtnFlg'="0" RtnFlg
	//+dongkf 2019 12 19 end
	
	//打印纸质票据/换开纸质票据
	if PathCode="PrintPaper" {
		s:DrAndFlg="I" RtnFlg="-1"
		s InvociePam.ErrMsgInfo="[打印纸质票据/换开纸质票据]业务已经存在,请不要重复操作!"
	}
	q:RtnFlg'="0" RtnFlg
	
	//作废已换开纸质票据
	if PathCode="InvalidPaperInv" {
		s:DrAndFlg="S" RtnFlg="-1"
		s InvociePam.ErrMsgInfo="[作废已换开纸质票据]业务已经存在,请不要重复操作!"
	}
	q:RtnFlg'="0" RtnFlg
	
	//重新打印纸质票据
	if PathCode="RePrintPaper" {
		/*
		s:DrAndFlg="I" RtnFlg="1"
		s InvociePam.ErrMsgInfo="[重新打印纸质票据/重新换开纸质票据]业务已经存在,请不要重复操作!"
		if ((TradeDr'="")&&(DrAndFlg="I")) { ;原来 已换开纸质票据对应的交易信息
			s InvociePam.OriPaperUpDetailDr=TradeDr
		}
		*/
		if TradeDr'="" { ;原来 已换开纸质票据对应的交易信息
			s Rerowid=0
			f  s Rerowid=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey", PayAdmType, HISPrtRowID, IUDPrintType, Rerowid)) q:(Rerowid="")  d 
			.s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(Rerowid,0)
			.s:objUpDetail.EInvFlg="I" InvociePam.OriPaperUpDetailDr=Rerowid
		}
		
		//add by xubaobao 2020 09 11 增加控制：如果换开未成功，不允许进行重新换开操作
		if (InvociePam.OriPaperUpDetailDr=""){
			s RtnFlg="-1"
			s InvociePam.ErrMsgInfo="[换开]业务不存在,不能进行重新换开操作!"
		}
	}
	q:RtnFlg'="0" RtnFlg		;add by xubaobao 2020 09 11 增加控制：如果换开未成功，不允许进行重新换开操作
	
	/*
	//状态标志为空代表没有完成的交易数据,本次交易继续使用，不用重新new一个[BILL.EINV.PO.InvUpDetails]对象
	if (DrAndFlg=""){
		b ;需要查看值
		s InvociePam.UpDetailDr=TradeDr
	}
	*/
	
	//状态标志为空代表没有完成的交易数据,本次交易继续使用，不用重新new一个[BILL.EINV.PO.InvUpDetails]对象
	s TradeDr=..GetCurrTradeDr(PayAdmType, HISPrtRowID,IUDPrintType,OrgHISPrtRowID,PathCode)  ;根据业务类型、发票号、票据类型获取当前交易未完成交易记录
	s InvociePam.UpDetailDr=TradeDr
	
	q RtnFlg
}

/// 功能说明：根据业务类型、发票号、票据类型获取 当前交易是否已存在未完成交易
/// 入参说明：PayAdmType   --> 业务类型
///           HISPrtRowID  --> His发票表Dr
///           IUDPrintType --> 票据类型 E-电子票据 P-纸质发票
///           OrgHISPrtRowID  --> 原纪录ID
///           PathCode 		  --> 接口业务类型
/// 返 回 值：未完成交易DR
/// 修改履历：王建 2020-03-26  新做成
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetTradeDrAndFlg
ClassMethod GetCurrTradeDr(PayAdmType As %String, HISPrtRowID As %String, IUDPrintType As %String, OrgHISPrtRowID As %String, PathCode As %String) As %String
{
	s RtnInfo=""
	s rowid=""
	s tmprowid=""
	for {
		
		set tmprowid=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey", PayAdmType, HISPrtRowID, IUDPrintType, tmprowid), -1)
		quit:(tmprowid="")||(rowid'="")
		set tmpPathCode="",tmpEInvFlg=""
		set objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(tmprowid)
		if $isobject(objUpDetail){
			s tmpPathCode=objUpDetail.IUDUploadPathCode
			s tmpEInvFlg=objUpDetail.EInvFlg  ;票据标志 I 正常开具 B 被冲红 S 冲红 H 已换开
		}
		Continue:tmpEInvFlg'=""
		Continue:tmpPathCode'=PathCode
		set rowid=tmprowid
	}  
	q rowid
}

/// 功能说明：判断当前业务是否应该存在对应前置交易，存在的时候判断前置交易时否在交易表中，在交易表中的时候获取前置交易Dr.
///           不应该存在对应前置交易时,不需要验证前置交易, 本次验证直接返回值为 0
///           应该存在对应前置交易并且前置交易数据存在时, 本次验证返回值为 0
///           应该存在对应前置交易且前置交易数据不存在时, 本次验证返回值为 -1
/// 返 回 值：0 合法  -1 违规
/// 修改履历：董科锋 2019 09 26 新做成
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).CheckOriTradeFlg
ClassMethod CheckOriTradeFlg(InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlg="0"
	
	s PathCode=InvociePam.PathCode              ;发票业务
	s OriTradeName=""
	s OrgTradeFlg=..HaveOrgTradeFlg(PathCode, .OriTradeName)   ;当前发票业务是否有原交易(前置交易)
	q:OrgTradeFlg'="1" RtnFlg                                  ;无原交易的时候 就不需要判断原交易是否存在
	
	s OrgTradeDr=..GetIUDInitRowIdByPam(InvociePam)	  ;获取当前交易的原交易Dr
	if OrgTradeDr="" {
		s InvociePam.ErrMsgInfo="原交易["_OriTradeName_"]不存在, 不能进行当前交易。"
		s RtnFlg="-1"
	}else{
		s InvociePam.OriUpDetailDr=OrgTradeDr         ;把原交易表Dr设置到参数对象中
	}
	
	q RtnFlg
}

/// 功能说明：根据Pathcode获取当前进行的是电子票据业务还是换开的纸质票据业务
/// 返 回 值：票据模式 E-电子票据 P-纸质发票
/// 修改履历：董科锋 2019-09-24 新做成
/// w  ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetPrintTypeByPathCode
ClassMethod GetPrintTypeByPathCode(PathCode As %String) As %String
{
	s PrintType=""
	
	s rowid=$o(^BILL.EINV.PO.InvLogicPathI("IDataKey", "I", PathCode, ""))
	q:rowid="" PrintType
	
	s objPath=##class(BILL.EINV.PO.InvLogicPath).%OpenId(rowid,0)
	s PrintType=objPath.IUDPrintType  ;票据模式 E-电子票据 P-纸质发票
	
	q PrintType
}

/// 功能说明：参与结算的所有押金是否都已经上传成功
/// 入参说明: PayAdmType      --> 票据业务类型
///                               IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
///           HISPrtRowID     --> HIS发生业务发票ID
/// 返 回 值：Y 全部上传成功  N 存在未上传成功的押金
/// 修改履历：董科锋  2019-09-20 新做成
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetAllDepositUpFlg
ClassMethod GetAllDepositUpFlg(PayAdmType As %String, HISPrtRowID As %String) As %String
{
	s RtnFlg="N"
	q:(PayAdmType'="IP")||(HISPrtRowID="") RtnFlg
	
	s InvPrtInfo=$g(^DHCINVPRTZY(HISPrtRowID))       ;住院发票表->DHC_INVPRTZY
	q:InvPrtInfo="" RtnFlg
	s PbDr=$p(InvPrtInfo,"^",5)                      ;账单号
	q:PbDr="" RtnFlg
	
	s AllDepositDr=##class(BILL.EINV.BL.COM.Common).GetIPPreDepositRowIDByBillDr(PbDr)   ;获取已参与结算的所有押金Dr拼串
	for i=1:1:$l(AllDepositDr,"^") q:RtnFlg="N"  d
	.s InvRowid=$p(AllDepositDr,"^",i)
	.s UpdetailDr=$o(^BILL.EINV.PO.InvUpDetailsI("IdxIUDUplodeFlag", "DEP", InvRowid, "E", "Y", ""))  ;上传成功的数据是否存在
	.s:UpdetailDr="" RtnFlg="N"  ;不存在的情况下 代表存在未上传成功的押金票据
	.;???????????????????????  这里不会存在 红冲的记录算到参与结算中把
	
	q RtnFlg
}

/// 功能说明：调用电子发票服务前保存业务数据
/// 入参说明：ObjInvPrtInfo --> 发票数据对象
///           InvociePam    --> 入参对象
///           ObjInv        --> 发票交易数据对象
/// 返 回 值：0 成功 其他值失败 
/// 修改履历：苏惠德  2019 09 17  新做成
///           董科锋  2019 09 18  修改入参、交易对象中发票信息从发票对象获取
///           董科锋  2019 09 19  交易表中的数据存在的时候 直接打开不能再重新生成一条新数据，以此保证一个发票对应一个交易表数据
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).InertInvocieBill
ClassMethod InertInvocieBill(ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef ObjInv As BILL.EINV.DTO.COM.InvUpDetailInfo) As %String
{
	s RtnFlg="0"
	if $isobject(ObjInv)=0 {
		set ObjInv=##class(BILL.EINV.DTO.COM.InvUpDetailInfo).%New()
	}
	
	s PayAdmType=InvociePam.PayAdmType
	s HISPrtRowID=InvociePam.HISPrtRowID
	s ConfigObj=InvociePam.ObjUPConfig
	s PathCode=InvociePam.PathCode
	s OrgIUDRowID=InvociePam.OrgHISPrtRowID
	s ExpStr=InvociePam.ExpStr
	q:(HISPrtRowID="")!(PayAdmType="") RtnFlg
	
	Set UserID=$p(ExpStr,"^",1)
	Set GroupID=$p(ExpStr,"^",2)
	Set GLocID=$p(ExpStr,"^",3)
	Set HospitalID=$p(ExpStr,"^",4)
	
	/*
	//取当前电子票据代码和电子票据号码 +Add by Suhuide at 2019-12-30
	//1.根据业务类型获取票据类型
	s PrtInvType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("EInvTypeAndAdmTypeCon",PayAdmType,5)   ;获取对照的票据种类
	//2.组织获取当前票号得入参串
	//操作员^票据类型^安全组^费别^院区
	s InputData=ObjInvPrtInfo.BusUserId_"^"_PrtInvType_"^"_ObjInvPrtInfo.GroupDr_"^"_ObjInvPrtInfo.InsTypeDr_"^"_ObjInvPrtInfo.PrtHospDr
	//返回值格式 当前号码^发放表id^结束号码^票据代码
	s OutStr=##class(BILL.EINV.BL.COM.Common).GetPaperBillNo(InputData)
	//+end;
	*/
	
	Set Err=0
	Set PrintType=ConfigObj.IUCInvoiceType     	;票据监管类型 E-电子票据 P-纸质发票(系统配置)
	Set InvStyle=ConfigObj.IUCStyle				;票据种类  V-增值税发票 C-普票
	
	Set PrintFlag=0,RateStatus=0				;PrintFlag:是否打印纸质票据(0未打印，1已打印),RateStatus:纸质生成状态(0未生成、1已生成、2失败 )
	If PrintType="P" Set PrintFlag="1",RateStatus=1
	
	s IUDPrintType=InvociePam.IUDPrintType  ;票据模式 E-电子票据 P-纸质发票
	s rowid=InvociePam.UpDetailDr           ;未完成的交易Dr
	if (rowid="") {  //不存在交易数据时
		Set obj=##class(BILL.EINV.PO.InvUpDetails).%New()
		Set UploadDate=+$h
		Set UploadTime=$p($h,",",2)
		Set obj.IUDDate=UploadDate					 ;IUDDate	上传日期
		Set obj.IUDTime=UploadTime					 ;IIUDTime	上传时间
		Set obj.IUDInvDr=HISPrtRowID				 ;IUDInvDr	;发票表指针
		Set obj.OrgIUDInvDr=OrgIUDRowID              ;原发票指针
		Set obj.IUDUser=ObjInvPrtInfo.BusUserId		 ;IUDUser上传人
		Set obj.IUDPayAdmType=PayAdmType			 ;IUDPayAdmType	;票据类型
		Set obj.IUDUplodeFlag="N"					 ;IUDUplodeFlag ;上传标志 Y:上传成功，N:上传失败
		//Set obj.IUDBillBatchCode=ObjInvPrtInfo.InvNo ;IUDBillBatchNo ;票据号码		????????
		Set obj.IUDHospDr=ObjInvPrtInfo.PrtHospDr	 ;IUDHospDr ;院区指针
		Set obj.IUDCreatAmt=ObjInvPrtInfo.InvAmt	 ;IUDCreatAmt ;开票金额
		Set obj.IUDPrintFlag=PrintFlag				;IUDPrintFlag ;是否打印纸质票据(0未打印，1已打印)
		Set obj.IUDRateStatus=RateStatus			;IUDRateStatus ;纸质生成状态(0未生成、1已生成、2失败 )
		Set obj.IUDBillBatchStatus="1"				;IUDBillBatchStatus 票据状态(状态：1正常，2作废)
		Set obj.IUDPrtDate=ObjInvPrtInfo.BusDate	;IUDPrtDate 创建日期
		Set obj.IUDPrtTime=ObjInvPrtInfo.BusTime	;IUDPrtTime	;创建时间
		Set obj.IUDStyle=InvStyle					;IUDStyle 票据种类 V-增值税发票 C-普票
		;Set obj.IUDPrintType=PrintType				;IUDPrintType 票据模式 E-电子票据 P-纸质发票
		Set obj.IUDUploadPathCode=PathCode			;IUDUploadPathCode 申请路径代码 DHC_InvUploadPath表
		Set obj.IUDPrintType=IUDPrintType           ;IUDPrintType 票据模式 E-电子票据 P-纸质发票 ;+dongkf 2019 09 24
		
		;add  guoyunlong 2023-02-20  电子发票流水表增加基本信息表ID，方便通过登记号查询电子发票信息
		Set obj.IUDPaPmiDr=ObjInvPrtInfo.PatBaseInfo.PaPmiDr   
		//add by xubaobao 2021 10 28 此处只存换开记录对应的原电子票交易表id
		if (PathCode="PrintPaper")||(PathCode="RePrintPaper") Do
		.Set obj.IUDInitDr=..GetEInvIUDRowIdByInvDr(PayAdmType, HISPrtRowID)	;根据原发票ID获取原交易ID
		;If OrgIUDRowID'="" Do
		;.Set obj.IUDInitDr=OrgIUDRowID				;IUDInitDr 换票（包含电子换纸质）原业务表指向/换票（包含电子换纸质）原电子票指向
		;.;-dongkf 2019 09 24 start
		;.;Set IUDInitRowId=..GetIUDInitRowId(PayAdmType, OrgIUDRowID)	;根据原发票ID获取原交易ID
		;.;Set obj.IUDInitRowID=IUDInitRowId					;IUDInitRowID 原交易记录ID
		;.;-dongf 2019 09 24 end
		
		Set obj.IUDInitRowID=InvociePam.OriUpDetailDr  ;原交易Dr(前置交易Dr)
		Set obj.IUDBusNo=##class(BILL.EINV.COM.Common).CreateBusinessNo(PayAdmType, 30, HISPrtRowID)  ;生成唯一的流水号
		/*
		;+ Add by Suhuide at 2019-12-30 增加票据代码和号码
		Set obj.IUDBillBatchCode=$p(OutStr,"^",4)  	;票据代码
		Set obj.IUDBillBatchNo=$p(OutStr,"^",1)		;票据号码
		;+end;
		*/
		;set obj.IUDHospDr=HospitalID        ;保存院区
		;update  guoyunlong 2023-02-20 
		;电子发票院区取业务数据表院区
		set obj.IUDHospDr=ObjInvPrtInfo.PrtHospDr        ;保存院区
		//+dongkf 2020 01 06 start
		//当前业务需要走号并且 不论第三方服务是否成功都需要走号的情况下，才需要把把当前票号保存到业务交易表中
		////在ADP层组织参数的时候为了保持一致 请使用 InvociePam.pBillBatchCode 和 InvociePam.pBillNo
		if (InvociePam.JumpEnvNoFlg="1")&&(InvociePam.JumpNoType="0") {
			s obj.IUDBillBatchCode=InvociePam.pBillBatchCode    ;票据代码
			s obj.IUDBillBatchNo=InvociePam.pBillNo             ;票据号码
		}
		tstart   ;开始事务
		//+dongkf 2020 01 06 end
		
		Set sc=obj.%Save()  ;保存交易表信息
		If $System.Status.IsError(sc) {
			Set info=$system.Status.GetErrorText(sc)
			s InvociePam.ErrMsgInfo=info
			s RtnFlg="-1"
		}else{
			d ObjInv.SetValues(obj)   ;给交易对象赋值
		}
		
		//+dongkf 2020 01 06 start
		//判断开具前是否需要走号，需要走号的情况下 走号
		if (RtnFlg="0") {
			if (InvociePam.JumpEnvNoFlg="1")&&(InvociePam.JumpNoType="0") { //开具发票前走号
				s RtnFlg=##class(BILL.EINV.BL.COM.Common).JumpEnvCodeAndNoDo(InvociePam)   ;走号
			}
		}
		
		//是否提交/回滚
		if (RtnFlg="0") {
			tcommit     ;提交事务
		}else{
			trollback   ;回滚事务
		}
		//+dongkf 2020 01 06 end
		
	}else{  //存在交易数据时
		Set obj=##class(BILL.EINV.PO.InvUpDetails).%OpenId(rowid,0)  ;已经存在的叫数据直接打开原数据,继续后续的操作
		d ObjInv.SetValues(obj)   ;给交易对象赋值
		
		//+dongkf 2020 01 06 start
		//当前业务需要走号并且不论第三方服务是否成功的场合都需要走号的情况下，这里需要使用之前占用的号码
		//在ADP层组织参数的时候为了保持一致 请使用 InvociePam.pBillBatchCode 和 InvociePam.pBillNo
		i (InvociePam.JumpEnvNoFlg="1")&&(InvociePam.JumpNoType="0") d
		.s InvociePam.pBillBatchCode=obj.IUDBillBatchCode    ;票据代码
		.s InvociePam.pBillNo=obj.IUDBillBatchNo             ;票据号码
		//+dongkf 2020 01 06 end
	}
		
	q RtnFlg
}

/// 功能说明：根据发票表ID获取电子票据ID
/// 入参说明：OrgIUDRowID --> 原发票ID 
///           PayAdmType  --> 交易类型
/// 返 回 值：原交易ID
/// 修改履历：徐保保 2021 10 29  新做成
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetEInvIUDRowIdByInvDr("") 
ClassMethod GetEInvIUDRowIdByInvDr(IUDPayAdmType As %String, IUDInvDr As %String) As %String
{
	q:(IUDPayAdmType="")||(IUDInvDr="") ""
	s OrgIUDInitDr=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey",IUDPayAdmType,IUDInvDr,"E",""),-1)
	q OrgIUDInitDr
}

/// 功能说明：根据原发票ID获取原交易ID
/// 入参说明：OrgIUDRowID --> 原发票ID 
///           PayAdmType  --> 交易类型
/// 返 回 值：原交易ID
/// 修改履历：苏惠德  2019 09 18  新做成
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetIUDInitRowId("") 
ClassMethod GetIUDInitRowId(PayAdmType As %String, OrgIUDRowID As %String) As %String
{
	/*
	q:'$d(^BILL.Invoice.PO.InvUpDetailsI("IdxInitDR",OrgIUDRowID))
	s OrgIUDRowID=$o(^BILL.Invoice.PO.InvUpDetailsI("IdxInitDR",OrgIUDRowID,""))
	q OrgIUDRowID
	*/
	
	q:(PayAdmType="")||(OrgIUDRowID="") ""
	s OrgIUDRowID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR",PayAdmType,OrgIUDRowID,""))
	q OrgIUDRowID
}

/// 功能说明：获取当前交易的的原交易ID
/// 入参说明：InvociePam --> 入参对象
/// 返 回 值：原交易ID
/// 修改履历：董科锋  2019 09 24  新做成
ClassMethod GetIUDInitRowIdByPam(InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s OrgTradeDr=""
	
	s PathCode=InvociePam.PathCode              ;发票业务
	s OriTradeName=""
	s OrgTradeFlg=..HaveOrgTradeFlg(PathCode, .OriTradeName)   ;当前发票业务是否有原交易
	q:OrgTradeFlg'="1" OrgTradeDr                              ;无原交易的时候 返回
	
	
	s PayAdmType=InvociePam.PayAdmType          ;交易类型   
	s HISPrtRowID=InvociePam.HISPrtRowID        ;发票ID
	s OrgIUDRowID=InvociePam.OrgHISPrtRowID     ;冲红时 原发票ID
	
	s HISPrtRowIDTmp=""     ;原交易his发票号
	s IUDPrintTypeTmp=""    ;原交易 票据模式  E-电子票据 P-纸质发票
	s EInvFlgTmp=""         ;原交易 票据标志  I 正常开具 B 被冲红 S 冲红 H 已换开
	
	//电子发票冲红 原交易应该为原电子票据交易
	if (PathCode="InvalidInv") {
		s HISPrtRowIDTmp=OrgIUDRowID
		s IUDPrintTypeTmp="E"  ;票据模式 E-电子票据 P-纸质发票
		s EInvFlgTmp="I"       ;I 正常开具
	}
	
	//+dongkf 2019 12 19 start
	//作废冲红电子票据(仅冲红第三方数据,his不发生退费)
	if PathCode="InvalidInvSvr" {
		s HISPrtRowIDTmp=HISPrtRowID
		s IUDPrintTypeTmp="E"  ;票据模式 E-电子票据 P-纸质发票
		s EInvFlgTmp="I"       ;I 正常开具
	}
	//+dongkf 2019 12 19 end
	
	
	//作废已换开纸质票据 原交易应该是换开的纸质票交易
	if (PathCode="InvalidPaperInv") {
		s HISPrtRowIDTmp=OrgIUDRowID
		s IUDPrintTypeTmp="P"  ;票据模式 E-电子票据 P-纸质发票
		s EInvFlgTmp="I"       ;I 正常开具
	}
	
	//电子票据换开纸质票据 原交易应该是原电子票据开具的交易
	if (PathCode="PrintPaper") {
		s HISPrtRowIDTmp=HISPrtRowID
		s IUDPrintTypeTmp="E"  ;票据模式 E-电子票据 P-纸质发票
		s EInvFlgTmp="I"       ;I 正常开具
	}
	
	//重新打印纸质票据 原交易应该是原电子票据开具的交易
	if (PathCode="RePrintPaper") {
		s HISPrtRowIDTmp=HISPrtRowID
		;add by xubaobao 2021 10 28 重新换开纸质票据原交易应该指向上次换开的纸质票据交易 此处将E-->P 
		;s IUDPrintTypeTmp="E"  ;票据模式 E-电子票据 P-纸质发票
		s IUDPrintTypeTmp="P"
		s EInvFlgTmp="I|H"       ;I 正常开具
	}
	q:((HISPrtRowIDTmp="")||(IUDPrintTypeTmp="")||(EInvFlgTmp="")) OrgTradeDr   ; IUDPrintTypeTmp-->OrgTradeDr update by xubaobao 2019 09 27
	
	//获取原交易(前置交易Dr)
	s OrgTradeDr=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey", PayAdmType, HISPrtRowIDTmp, IUDPrintTypeTmp, ""), -1)
	;+dongkf 2019 12 20 start 
	if PathCode="InvalidInvSvr" {  ;根据当前交易表Dr 获取前置交易Dr
		s OrgTradeDr=""
		s NowTradeDr=InvociePam.UpDetailDr   ;当前交易表Dr
		b ;当前交易表Dr  仅冲红第三方数据。。。
		s OrgTradeDr=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey", PayAdmType, HISPrtRowIDTmp, IUDPrintTypeTmp, NowTradeDr), -1)  ;根据当前交易表Dr 获取前置交易Dr
		b ;前置交易Dr
	}
	;+dongkf 2019 12 20 start
	if OrgTradeDr'="" {
		s objOrgUpdetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(OrgTradeDr,0)
		s EInvFlg=objOrgUpdetail.EInvFlg       ;票据标志 I 正常开具 B 被冲红 S 冲红 H 已换开
		;s:EInvFlg'=EInvFlgTmp OrgTradeDr=""    ;票据状态不合法,认为不存在原交易(前置交易)
		s:EInvFlgTmp'[EInvFlg OrgTradeDr=""    ;票据状态不合法,认为不存在原交易(前置交易)
	}
	
	q OrgTradeDr
}

/// 功能说明：当前发票业务是否有原交易,原交易名称
/// 入参说明：PathCode --> 开票业务类型
///           OrgTradeName --> 原交易名称
/// 返 回 值：1 有 0 无
ClassMethod HaveOrgTradeFlg(PathCode As %String, ByRef OrgTradeName As %String) As %String
{
	s RtnFlg="0"
	
	if PathCode="InvalidInv" {        ;作废冲红票据        
		s OrgTradeName="电子票据开具"
		s RtnFlg="1" 
	}
	
	//+dongkf 2019 12 19 start
	if PathCode="InvalidInvSvr" {     ;作废冲红票据(仅冲红第三方数据,his不发生退费)
		s OrgTradeName="票据开具"
		s RtnFlg="1"
	}
	//+dongkf 2019 12 19 end
	
	if PathCode="InvalidPaperInv" {   ;作废已换开纸质票据
		s OrgTradeName="已换开纸质票据"
		s RtnFlg="1"  
	} 
	 
	if PathCode="PrintPaper" {           ;电子票据换开纸质票据
		s OrgTradeName="电子票据开具"
		s RtnFlg="1"   
	}
	
	 
	;重新打印纸质票据   
	if PathCode="RePrintPaper" {       
		s OrgTradeName="电子票据开具"
		s RtnFlg="1"
	}     
	
	q RtnFlg
}

/// 功能说明：通过账单号获取所有参与结算的押金表Dr,并根据押金表Dr获取对应的上传交易数据。设置到发票的押金属性中。      
/// 入参说明：rcptrowid--> 押金表ID  
///           ObjInvPrtInfo   发票表对象        
/// 返 回 值：0 成功     "-1"  失败 
/// 编写：    guoyunlong
ClassMethod GetDepositUpdetailByBill(PbDr As %String, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo) As %String
{
	set rtn="-1"
	q:PbDr="" rtn
	 ; 通过账单号获取参与结算的预交金表ID
	s StrRowID=##class(BILL.EINV.BL.COM.Common).GetIPPreDepositRowIDByBillDr(PbDr)
	;q:StrRowID="" rtn
	
	for i=1:1:$l(StrRowID,"^") d
	.Set rcptrowid=$p(StrRowID,"^",i)
	.Quit:(rcptrowid="")
	.set IUDRowID=""
	.for  set IUDRowID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR","DEP",rcptrowid,IUDRowID))  quit:(IUDRowID="")  do
	..set objInvUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDRowID,0)
	..quit:(objInvUpDetail.IUDUplodeFlag'="Y")
	..;set VoucherBatchCode=$LIST(^BILL.Invoice.PO.InvUpDetailsD(IUDRowID),37)    ;电子票据代码-->IUD_BillBatchCode
	..;set VoucherBatchNo=$LIST(^BILL.Invoice.PO.InvUpDetailsD(IUDRowID),38)
	..set obj=##class(BILL.EINV.DTO.COM.IPPreDepositInfo).%New()
	..set obj.voucherBatchCode=objInvUpDetail.IUDBillBatchCode                         ;电子票据代码
	..set obj.voucherNo=objInvUpDetail.IUDBillBatchNo                                   ;电子票据号码
	..set obj.voucherAmt=$p(^DHCSFPRINTDETAIL(rcptrowid),"^",6)			;押金金额
	..d ObjInvPrtInfo.IPPreDepositInfo.Insert(obj)
	set rtn="0"
	q rtn
}

/// Creator：      ZhaoZW
/// CreatDate：    2019-09-20 
/// update   ：    2019-09-24    guoyunlong
/// Description:   查询一段时间内未上传成功的电子票据信息
/// Input：        IUDStDate ->开始时间    IUDEdDate->结束时间   IUDAdmType->票据类型
/// Output：       IUDBusNo : 业务流水号 IUDCreatAmt : 开票金额 IUDBillBatchCode : 电子票据代码
/// 			   IUDBillBatchNo : 电子票据号码 IUDPayAdmType : 票据类型 IUDUser : 上传人
/// 			   IUDDate : 上传日期 IUDUplodeFlag : 上传标志,IUDCreatDate 开票日期 
///                IUDCreatTime:  开票时间 
/// Debug:	d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.InvUpDetailsCtl","QueryBillIUDInfo","2019-09-06","2019-09-20")
Query QueryBillIUDInfo(IUDStDate As %String, IUDEdDate As %String, IUDAdmType As %String = "") As %Query(ROWSPEC = "ind,ID:%String,IUDBusNo:%String,IUDCreatAmt:%String,IUDBillBatchCode:%String,IUDBillBatchNo:%String,IUDPayAdmType:%String,USRName:%String,IUDDate:%String,IUDUplodeFlag:%String,IUDHospDr:%String,IUDCreatDate:%String,IUDCreatTime:%String,IUDBillBatchStatus:%String,IUDBillisScarlet:%String,IUDInvDr:%String,PrintType:%String,InvStyle:%String,PrintFlag:%String,RateStatus:%String")
{
}

ClassMethod QueryBillIUDInfoExecute(ByRef qHandle As %Binary, IUDStDate As %String, IUDEdDate As %String, IUDAdmType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    q:(IUDStDate="")||(IUDEdDate="") $$$OK	
	//获取发票业务信息
	set OutStr=##class(BILL.EINV.BL.EInvoiceLogic).GetNotINVInfo(IUDStDate,IUDEdDate)
	set PIDKey=$p(OutStr,"^",1)
	//遍历global数据,根据不同的业务类型调用票据监管业务进行票据补交易
	set PayAdmType=""
	for  set PayAdmType=$o(^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType)) quit:(PayAdmType="")  do
	.q:(IUDAdmType'="")&&(IUDAdmType'=PayAdmType)   ;过滤票据类型
	.set HISPrtRowID="0",IUDID=""
	.for  set HISPrtRowID=$o(^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,HISPrtRowID))  quit:(HISPrtRowID="")  do
    ..for  s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey",PayAdmType,HISPrtRowID,"E",IUDID)) q:IUDID=""  d
    ...s ObjIUDInfo=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID,0)
    ...s IUDUplodeFlag=ObjIUDInfo.IUDUplodeFlag  			   ;上传标志（Y:上传成功，N:上传失败）
    ...q:IUDUplodeFlag'="N"                                     ;过滤已经上传的
    ...s IUDPayAdmType=ObjIUDInfo.IUDPayAdmType  				;票据类型
    ...;q:(IUDPayAdmType'="")&&(IUDPayAdmType'=IUDAdmType)         ;过滤不满足的票据类型
    ...s IUDBusNo=ObjIUDInfo.IUDBusNo    						;业务流水号
    ...s IUDCreatAmt=ObjIUDInfo.IUDCreatAmt 						;开票金额
    ...s IUDBillBatchCode=ObjIUDInfo.IUDBillBatchCode 		    ;电子票据代码
    ...s IUDBillBatchNo=ObjIUDInfo.IUDBillBatchNo				;电子票据号码
    ...s IUDUser=ObjIUDInfo.IUDUser                				 ;指向SS_User
    ...s USRName=$p($g(^SSU("SSUSR",IUDUser)),"^",2)			     ;上传人
    ...s IUDHospDr=ObjIUDInfo.IUDHospDr                           ;院区指针
    ...s IUDCreatDate=$zd(ObjIUDInfo.IUDCreatDate,3)              ;开票日期  
    ...s IUDCreatTime=$zt(ObjIUDInfo.IUDCreatTime)                ;开票时间 
    ...s IUDBillBatchStatus=ObjIUDInfo.IUDBillBatchStatus         ;电子票据状态(状态：1正常，2作废)
    ...s IUDBillisScarlet=ObjIUDInfo.IUDBillisScarlet             ;是否已开红票  
    ...s IUDInvDr=ObjIUDInfo.IUDInvDr                             ;发票表指针
    ...s PrintType= ObjIUDInfo.IUDPrintType                       ;票据模式 E-电子票据 P-纸质发票
    ...s InvStyle=ObjIUDInfo.IUDStyle	                		; 票据种类 V-增值税发票 C-普票
    ...s PrintFlag=ObjIUDInfo.IUDPrintFlag				        ;是否打印纸质票据(0未打印，1已打印)
	...s RateStatus=ObjIUDInfo.IUDRateStatus			        ;纸质生成状态(0未生成、1已生成、2失败 )
    ...d OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ind,ID,IUDBusNo,IUDCreatAmt,IUDBillBatchCode,IUDBillBatchNo,IUDPayAdmType,USRName,$zd(IUDDate,3),IUDUplodeFlag,IUDHospDr,IUDCreatDate,IUDCreatTime,IUDBillBatchStatus,IUDBillisScarlet,IUDInvDr,PrintType,InvStyle,PrintFlag,RateStatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind_1
	q
}

ClassMethod QueryBillIUDInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBillIUDInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryBillIUDInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBillIUDInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 功能描述：收费员选择未上传成功的电子票据进行上传，调用电子票据开具接口上传
///  ????   是否调用开具接口
/// 调用电子票据批量上传接口
///  input:
///  Output: 0成功，非0失败
ClassMethod DealData(dataStr As %String) As %String
{
	s rtn="-1"
	q:dataStr="" rtn
	s IUDAdmType=$p(dataStr,"^",1)
	s IUDInvDr=$p(dataStr,"^",3)
	;调用开具接口
	s Flag=##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill(IUDAdmType,IUDInvDr,"","","")
	q Flag
}

/// 获取病人已开具的电子票据信息
ClassMethod GetInvUpDetailInfo(ObjEInvPam As BILL.EINV.DTO.ZZJ.EInvDetailInfoReq, ObjPatEInv As BILL.EINV.DTO.ZZJ.PatEInvDetailInfo, RtnMsg As %String) As %String
{
	s RtnFlg="0"
	
	//业务验证
	//根据病人身份证号获取病人发票ID
	If (ObjEInvPam.PatID'="")&&(ObjEInvPam.CardNo=""){
		s PatID=$$ALPHAUP^SSUTIL4(ObjEInvPam.PatID)
		s:'$d(^PAPERi("DVA",PatID)) RtnFlg="-1",RtnMsg="病人身份证号错误"
		q:RtnFlg="-1" 
		s Papmi=$o(^PAPERi("DVA",PatID,""),-1)
		s PrtRowid=##class(BILL.EINV.BL.COM.Common).GetPrtRowidByPapmi(Papmi)
	}elseif (ObjEInvPam.CardNo'="")&&(ObjEInvPam.PatID=""){     //根据病人卡号获取病人发票ID
		s CardNo=$$ALPHAUP^SSUTIL4(ObjEInvPam.CardNo)_Z
		s:'$d(^PAPERi("Govern",CardNo)) RtnFlg="-1",RtnMsg="病人卡号错误"
		q:RtnFlg="-1" 
		s Papmi=$o(^PAPERi("Govern",CardNo,""),-1)
		s PrtRowid=##class(BILL.EINV.BL.COM.Common).GetPrtRowidByPapmi(Papmi)
	}elseif(ObjEInvPam.BillBatchCode'="")&&(ObjEInvPam.BillBatchNo'=""){
		s:'$d(^BILL.EINV.PO.InvUpDetailsI("IdxInvoiceNo",ObjEInvPam.BillBatchCode,ObjEInvPam.BillBatchNo)) RtnFlg="-1",RtnMsg="根据票据号码未查到电子票据信息"
		q:RtnFlg="-1" 	
		s rowid=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvoiceNo",ObjEInvPam.BillBatchCode,ObjEInvPam.BillBatchNo,""),-1)
		s EInvobj=##class(BILL.EINV.PO.InvUpDetails).%OpenId(rowid,0)
		s PrtRowid=EInvobj.IUDInvDr
	}
	
	s:PrtRowid="" RtnFlg="-1",RtnMsg="未获取到病人结算信息"
	q:RtnFlg="-1"
	
	d ..GetInvUpDetailByPrtRowid(PrtRowid, .ObjPatEInv)
	s:+ObjPatEInv.EInvNum=0 RtnFlg="-1",RtnMsg="未获取到病人已开具的电子票据信息"
	
	q RtnFlg
}

/// 	功能描述：根据发票表ID获取病人电子票据信息
/// 	入参：PrtRowid  发票ID
/// 出参：ObjPatEInvDetail 病人电子票据对象
ClassMethod GetInvUpDetailByPrtRowid(PrtRowid As %String, ByRef ObjPatEInv As BILL.EINV.DTO.ZZJ.PatEInvDetailInfo) As %String
{
	s rtn="0"
	s PayAdmType=""
	f  s PayAdmType=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR",PayAdmType)) q:PayAdmType=""  d
	.f i=1:1:$l(PrtRowid,"^")  d
	..s id=""
	..f  s id=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR",PayAdmType,$p(PrtRowid,"^",i),id)) q:id=""  d
	...s obj=##class(BILL.EINV.PO.InvUpDetails).%OpenId(id,0)
	...q:(obj.EInvFlg'="I")||(obj.IUDPrintType'="E")				;过滤纸质票据、不是正常的电子票据
	...s ObjPatEInv.EInvNum=+ObjPatEInv.EInvNum+1			;总票据条目
	...s ObjPatEInv.EInvAmt=+ObjPatEInv.EInvAmt+obj.IUDCreatAmt		;总票据金额
	...s ObjPatEInvDetail=##class(BILL.EINV.DTO.COM.InvUpDetailInfo).%New()
	...d ObjPatEInvDetail.SetValues(obj)
	...s PrtType=obj.IUDPrintType_"_"_obj.IUDPayAdmType
	...s ObjPatEInvDetail.PrtInvType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("BusinessToPrtInvType",PrtType,5)      
	...d ObjPatEInv.EInvList.Insert(ObjPatEInvDetail)
	
	q rtn
}

/// 功能说明：根据电子票据代码+电子票据号码的拼接字符串查询票据his票据表Rowid
/// 入参说明: PayAdmType --> 票据业务类型
///                          IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
///           EinvNo     --> 票据号码(票据代码+票据号码)
///           ExtStr     --> 备用参数
/// 返 回 值：his票据表Dr
/// 修改履历：董科锋 2020 04 03 新做成
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetInvprtDrByEInvNo("510601200000031293")
ClassMethod GetInvprtDrByEInvNo(EinvNo As %String, ExtStr As %String = "", PayAdmType As %String = "") As %String
{
	s RtnDrs=""
	q:(EinvNo="") RtnDrs
	
	s PayAdmTypeTmp=""
	f  s PayAdmTypeTmp=$o(^BILL.EINV.PO.InvUpDetailsI("IdxEinvprtNo", PayAdmTypeTmp)) q:PayAdmTypeTmp=""  d
	.q:(PayAdmType'="")&&(PayAdmType'=PayAdmTypeTmp)
	.s rowid=""
	.f  s rowid=$o(^BILL.EINV.PO.InvUpDetailsI("IdxEinvprtNo", PayAdmTypeTmp, EinvNo, rowid), -1) q:rowid=""  d
	..s objInvUpDetails=##class(BILL.EINV.PO.InvUpDetails).%OpenId(rowid,0)
	..s EInvFlg=objInvUpDetails.EInvFlg  ;票据标志 I 正常开具 B 被冲红 S 冲红 H 已换开 A 作废
	..q:EInvFlg=""
	..s RtnDr=objInvUpDetails.IUDInvDr   ;发票表指针
	..i RtnDrs="" d
	...s RtnDrs=RtnDr
	..e  d
	...s RtnDrs=RtnDrs_"^"_RtnDr
	
	q RtnDrs
}

/// 功能说明：根据发票表表dr获取当前最新一条电子票据相关信息
/// 入参说明: PayAdmType --> 票据业务类型
///                          IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
///           HisInvprtDr --> 票据表Dr
///           ExtStr      --> 备用参数
/// 返 回 值：电子票据信息(发票号码(票据代码+票据号码)^票据代码^票据号码^票据模式^票据标志^开票人^开票日期^开票时间^打印人^打印日期^打印时间)
///           票据模式 E-电子票据 P-纸质发票
///           票据标志 I 正常开具 B 被冲红 S 冲红 H 已换开 A 作废
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetEInvInfoByHisInvDr("OP","5629432")
ClassMethod GetEInvInfoByHisInvDr(PayAdmType As %String, HisInvprtDr As %String, ExtStr As %String = "") As %String
{
 
	s RtnInfo=""
	q:(PayAdmType="")||(HisInvprtDr="") RtnInfo
	
	s rowid=""
	f  s rowid=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR", PayAdmType, HisInvprtDr, rowid), -1) q:((rowid="")||(RtnInfo'=""))  d
	.s objInvUpDetails=##class(BILL.EINV.PO.InvUpDetails).%OpenId(rowid,0)
	.s EInvFlg=objInvUpDetails.EInvFlg
	.q:EInvFlg=""
	.s EinvprtNo=objInvUpDetails.EinvprtNo   ;发票号码(发票编码+发票号码)
	.s IUDBillBatchCode=objInvUpDetails.IUDBillBatchCode  ;票据代码
	.s IUDBillBatchNo=objInvUpDetails.IUDBillBatchNo      ;票据号码
	.s IUDPrintType=objInvUpDetails.IUDPrintType          ;票据模式 E-电子票据 P-纸质发票
	.s IUDUser=objInvUpDetails.IUDUser               ;开票人
	.s IUDCreatDate=objInvUpDetails.IUDCreatDate     ;开票日期
	.s IUDCreatTime=objInvUpDetails.IUDCreatTime     ;开票时间
	.s IUDEInvPrintUsr=objInvUpDetails.IUDEInvPrintUsr              ;电子发票打印人");
    .s IUDEInvPrintDate=objInvUpDetails.IUDEInvPrintDate ;电子发票打印日期");
    .s IUDEInvPrintTime=objInvUpDetails.IUDEInvPrintTime ;电子发票打印时间");
    .s EWM=objInvUpDetails.IUDBillQRCode              ;二维码  --base64
    .s IUDPictureUrl=objInvUpDetails.IUDPictureUrl    ;链接地址
	.s RtnInfo=EinvprtNo_"^"_IUDBillBatchCode_"^"_IUDBillBatchNo_"^"_IUDPrintType_"^"_EInvFlg_"^"_IUDUser
	.s RtnInfo=RtnInfo_"^"_$zd(IUDCreatDate,3)_"^"_$zt(IUDCreatTime,1)_"^"_IUDEInvPrintUsr_"^"_$zd(IUDEInvPrintDate,3)_"^"_$zt(IUDEInvPrintTime,1)_"^"_EWM_"^"_IUDPictureUrl  
	
	q RtnInfo
}

/// 功能说明：根据住院账单表dr获取电子票据相关信息
/// 入参说明: PayAdmType --> 票据业务类型
///                          IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
///           HisBillDr  --> 住院账单表Dr
///           ExtStr      --> 备用参数
/// 返 回 值：电子票据信息(格式参照方法GetEInvInfoByHisInvDr)
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetEInvInfoByHisBillDr("IP","4537035")
ClassMethod GetEInvInfoByHisBillDr(PayAdmType As %String, HisBillDr As %String, ExtStr As %String = "") As %String
{
	s RtnInfo=""
	q:(PayAdmType="")||(HisBillDr="") RtnInfo
	
	s HisInvprtDr=$o(^DHCINVPRTZY(0,"AR", HisBillDr,""),-1)  ;住院发票表Dr
	q:HisInvprtDr="" RtnInfo
	
	s RtnInfo=..GetEInvInfoByHisInvDr(PayAdmType, HisInvprtDr, ExtStr)
	q RtnInfo
}

/// 功能说明：获取发票的代码列表
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetEInvBatchCode("")
ClassMethod GetEInvBatchCode(HospitalDr As %String) As %String
{
	s RtnInvCodes=""
	
	s IUDBillBatchCode=""
	f  s IUDBillBatchCode=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvoiceNo", IUDBillBatchCode),-1) q:IUDBillBatchCode=""  d
	.i RtnInvCodes="" d
	..s RtnInvCodes=IUDBillBatchCode
	.e  d
	..s RtnInvCodes=RtnInvCodes_"^"_IUDBillBatchCode
	
	q RtnInvCodes
}

/// 功能说明：标记二次报销的数据
/// 入参说明：HisBillDr --> 账单Dr
///           BXFlg     --> 标记数据标志 1 标记 0 取消标记
///           UserId    --> 操作员ID
/// 返 回 值：操作状态^消息
///           状态标记 0 成功 -1 失败
ClassMethod SaveInvInsuAgain(HisBillDr As %String, BXFlg As %String, UserId As %String) As %String
{
	s RtnStatus="-1"
	s ErrMsg=""
	
	s HisInvprtDr=$o(^DHCINVPRTZY(0,"AR", HisBillDr,""),-1)  ;住院发票表Dr
	s:HisInvprtDr="" ErrMsg="获取结算信息失败"
	q:HisInvprtDr="" RtnStatus_"^"_ErrMsg
	
	s objInvUpDetails=""
	s BXFlgTmp=""
	s EInvFlg=""
	s rowid=""
	f  s rowid=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR", "IP", HisInvprtDr, rowid), -1) q:((rowid="")||(EInvFlg'=""))  d
	.s objInvUpDetails=##class(BILL.EINV.PO.InvUpDetails).%OpenId(rowid,0)
	.s EInvFlg=objInvUpDetails.EInvFlg
	.q:EInvFlg=""
	.s BXFlgTmp=objInvUpDetails.Xstr2   ;报销标志
	.s:BXFlgTmp="" BXFlgTmp="0"
	
	q:(EInvFlg="")||(rowid="") ErrMsg="没有电子票据记录,不能报销/取消报销票据."
	q:(EInvFlg="")||(rowid="") RtnStatus_"^"_ErrMsg
	
	s:(BXFlg="1")&&(BXFlgTmp=BXFlg) ErrMsg="已经报销过的票据,请不要重复报销."
	s:(BXFlg="0")&&(BXFlgTmp=BXFlg) ErrMsg="票据尚未报销,不需要取消."
	q:BXFlgTmp=BXFlg RtnStatus_"^"_ErrMsg
	
	s UpdRtn=..SaveInvInsuAgainDo(objInvUpDetails, BXFlg, UserId)   ;保存二次报销标志
	s:UpdRtn'="0" ErrMsg="保存数据失败."
	q:UpdRtn'="0" RtnStatus_"^"_ErrMsg
	
	s RtnStatus="0"
	s:BXFlg="1" ErrMsg="票据报销成功"
	s:BXFlg="0" ErrMsg="取消票据报销成功"
	s OutMsgInfo=..FormatInsuAgainMsg(objInvUpDetails.Xstr2, objInvUpDetails.Xstr2, objInvUpDetails.Xstr3)  ;格式化消息
	q RtnStatus_"^"_ErrMsg_"^"_objInvUpDetails.Xstr2_"^"_OutMsgInfo
}

ClassMethod FormatInsuAgainMsg(BXFlg As %String, UserId As %String, DataTime As %String) As %String
{
	s OutMsg=""
	s UserName=""
	i UserId'="" d
	.s UserName=$p($g(^SSU("SSUSR",UserId)), "^", 2)  ;操作员名称
	.s:UserName="" UserName=UserId
	
	i BXFlg="" d
	.s OutMsg="未报销"
	
	i BXFlg="1" d
	.s OutMsg=UserName_" "_DataTime_" 报销了当前票据."
	
	i BXFlg="0" d
	.s OutMsg=UserName_" "_DataTime_" 取消了报销标记."
	
	q OutMsg
}

/// 功能说明：保存二次报销标志
/// 入参说明：objInvUp  --> 票据流水表对象
///           BXFlg     --> 报销标志 1 已报销 0 报销取消
///           UserId    --> 操作员id
/// 返 回 值：0 保存成功 1 保存失败
ClassMethod SaveInvInsuAgainDo(objInvUp As BILL.EINV.PO.InvUpDetails, BXFlg As %String, UserId As %String) As %String
{
	s RtnFlg="-1"
	q:$isobject(objInvUp)=0 RtnFlg
	
	s NowDateStr=$h
	s iNowDate=$p(NowDateStr, ",", 1)   ;日期
	s iNowTime=$p(NowDateStr, ",", 2)   ;时间
	s NowDate=$zd(iNowDate, 3)
	s NowTime=$zt(iNowTime)
	
	s objInvUp.Xstr2=BXFlg     ;已报销标志 1 已报销 0 未报销
	s objInvUp.Xstr3=UserId    ;操作员ID
	s objInvUp.Xstr4=NowDate_" "_NowTime   ;更新日期
	s sc=objInvUp.%Save()
	if '($System.Status.IsError(sc)) {
		s RtnFlg="0"
	}
	
	q RtnFlg
}

/// 根据业务类型,票据类型,发票ID获取最新一条电子票据信息
/// 开发人：  	徐保保
/// 开发时间：  2020-08-03
/// 入参：		PayAdmType    业务类型
/// 		  	HISPrtRowID   发票ID
/// 		  	IUDPrintType  票据类型(默认传"E")(E 电子票，P 纸质票)
/// 出参：		票据代码^票据号码^校验码
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetEInvBillNoStr(PayAdmType,HISPrtRowID,IUDPrintType)
ClassMethod GetEInvBillNoStr(PayAdmType As %String, HISPrtRowID As %String, IUDPrintType As %String = "E") As %String
{
	q:(PayAdmType="")||(HISPrtRowID="")||(IUDPrintType="") ""
	
	s ID=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey", PayAdmType, HISPrtRowID, IUDPrintType, ""),-1)
	q:ID="" ""
	s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(ID,0)
	s EInvFlg=objUpDetail.EInvFlg
	q:EInvFlg="" ""
	s BillBatchCode=objUpDetail.IUDBillBatchCode			;票据代码
	s BillNo=objUpDetail.IUDBillBatchNo						;票据号码
	s Random=objUpDetail.IUDCheckCode						;校验码
	
	s EInvStr=BillBatchCode_"^"_BillNo_"^"_Random
	
	q EInvStr
}

/// 功能说明：根据电子票据代码、电子票据号码更新电子票据打印次数
/// 入参说明: IUDBillBatchCode --> 票据代码
///           IUDBillBatchNo   --> 票据号码
///           UserId     --> 打印人
/// 返 回 值：成功 0  ，失败 -1^失败原因
/// 修改履历：guoyunlong  2021-11-25
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).UPDatePrintNumByEinvCode("123","456","1")
ClassMethod UPDatePrintNumByEinvCode(IUDBillBatchCode As %String, IUDBillBatchNo As %String, UserId As %String) As %String
{
	s rtnFlg="-1"
	q:((IUDBillBatchCode="")||(IUDBillBatchNo="")||(UserId="")) rtnFlg_"票据号码,票据代码或操作员为空"
	s InvUpID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvoiceNo", IUDBillBatchCode, IUDBillBatchNo,  ""),-1)
	s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(InvUpID,0)
	s objUpDetail.IUDEInvPrintNum=+objUpDetail.IUDEInvPrintNum+1
	s objUpDetail.IUDEInvPrintDate=+$h
	s objUpDetail.IUDEInvPrintTime=$p($h,",",2)
	s objUpDetail.IUDEInvPrintUsr=UserId
    s sc=objUpDetail.%Save()
		if ($System.Status.IsError(sc)) {
			s rtnFlg="-1"_"^"_$System.Status.GetErrorText(sc)
		}else{
			s rtnFlg="0"
		}
	q rtnFlg
}

/// 功能说明：根据电子票据代码、电子票据号码获取打印次数
/// 入参说明: IUDBillBatchCode --> 票据代码
///           IUDBillBatchNo   --> 票据号码
///           UserId     --> 打印人
/// 返 回 值：成功 打印次数  ，失败 -1^失败原因
/// 修改履历：guoyunlong  2021-11-25
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetPrintNumByEinvCode("123","456")
ClassMethod GetPrintNumByEinvCode(IUDBillBatchCode As %String, IUDBillBatchNo As %String) As %String
{
	s rtnFlg="-1"
	q:((IUDBillBatchCode="")||(IUDBillBatchNo="")) rtnFlg_"票据号码,票据代码为空"
	s InvUpID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvoiceNo", IUDBillBatchCode, IUDBillBatchNo,  ""),-1)
	s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(InvUpID,0)
	s rtnFlg=+objUpDetail.IUDEInvPrintNum
	q rtnFlg
}

/// 功能说明：根据票据代码、票据号码获取当前最新一条电子票据相关信息
/// 入参说明: IUDBillBatchCode --> 票据代码
///           IUDBillBatchNo   --> 票据号码
///           ExtStr      --> 备用参数
/// 返 回 值：电子票据信息(发票号码(票据代码+票据号码)^票据代码^票据号码^票据模式^票据标志^开票人^票据地址^开票日期^开票时间^打印人^打印日期^打印时间)
///           票据模式 E-电子票据 P-纸质发票
///           票据标志 I 正常开具 B 被冲红 S 冲红 H 已换开 A 作废
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetEInvInfoByEInvCodeAndNO("123","456")
ClassMethod GetEInvInfoByEInvCodeAndNO(IUDBillBatchCode As %String, IUDBillBatchNo As %String, ExtStr As %String = "") As %String
{
 
	s RtnInfo=""
	q:(IUDBillBatchCode="")||(IUDBillBatchNo="") RtnInfo
	s rowid=""
	s rowid=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvoiceNo", IUDBillBatchCode, IUDBillBatchNo, rowid), -1) 
	s objInvUpDetails=##class(BILL.EINV.PO.InvUpDetails).%OpenId(rowid,0)
	s EInvFlg=objInvUpDetails.EInvFlg  ;票据标志 I 正常开具 B 被冲红 S 冲红 H 已换开 A 作废
	q:EInvFlg=""
	s EinvprtNo=objInvUpDetails.EinvprtNo   ;发票号码(发票编码+发票号码)
	s BillBatchCode=objInvUpDetails.IUDBillBatchCode  ;票据代码
	s DBillBatchNo=objInvUpDetails.IUDBillBatchNo      ;票据号码
	s IUDPrintType=objInvUpDetails.IUDPrintType          ;票据模式 E-电子票据 P-纸质发票
	s Pictureurl=objInvUpDetails.IUDPictureUrl      ;电子票据地址
	s IUDUser=objInvUpDetails.IUDUser               ;开票人
	s IUDCreatDate=objInvUpDetails.IUDCreatDate     ;开票日期
	s IUDCreatTime=objInvUpDetails.IUDCreatTime     ;开票时间
	s IUDEInvPrintUsr=objInvUpDetails.IUDEInvPrintUsr              ;电子发票打印人");
    s IUDEInvPrintDate=objInvUpDetails.IUDEInvPrintDate ;电子发票打印日期");
    s IUDEInvPrintTime=objInvUpDetails.IUDEInvPrintTime ;电子发票打印时间");
	s RtnInfo=EinvprtNo_"^"_BillBatchCode_"^"_DBillBatchNo_"^"_IUDPrintType_"^"_EInvFlg_"^"_IUDUser_"^"_Pictureurl
	s RtnInfo=RtnInfo_"^"_$zd(IUDCreatDate,3)_"^"_$zt(IUDCreatTime,1)_"^"_IUDEInvPrintUsr_"^"_$zd(IUDEInvPrintDate,3)_"^"_$zt(IUDEInvPrintTime,1)
	q RtnInfo
}

/// 功能说明：根据业务类型、业务发票ID判断该条记录是否允许开具电子发票
/// 入参说明: PayAdmType --> 业务类型(IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金,CF:卡费)
///           HISPrtRowID   --> HIS发生业务发票ID
/// 			  IUDPrintType -->票据类型(默认传"E")(E 电子票，P 纸质票)
/// 返 回 值：Y:允许开具 N:不允许
/// 修改履历：Suhuide  2023-02-01
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetPrtInvBillFlag("OP","458932")
ClassMethod GetPrtInvBillFlag(PayAdmType As %String, HISPrtRowID As %String, IUDPrintType As %String = "E") As %String
{
	set billFlag="Y"
	quit:(PayAdmType="")||(HISPrtRowID="") "N"
	set ID=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey", PayAdmType, HISPrtRowID, IUDPrintType, ""),-1)
	quit:ID="" billFlag
	set objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(ID,0)
	set EInvFlg=objUpDetail.EInvFlg
	quit:EInvFlg="" billFlag
	if (EInvFlg="B"){
		//1.门诊(挂号、收费)
		if (PayAdmType="OP")||(PayAdmType="REG"){
			set InvFlag=$p($g(^DHCINVPRT(HISPrtRowID)),"^",8)		;结算状态
			if (InvFlag'="N"){		//存在退费或其它业务
				set billFlag="N"
			}	
		}elseif(PayAdmType="API"){		
			set InvFlag=$p($g(^DHCINVPRTAP(HISPrtRowID)),"^",2)
			if (InvFlag'="N"){		//存在撤销集中打印或其它业务
				set billFlag="N"
			}
			
		}elseif(PayAdmType="CF"){		//卡费
			set InvFlag=$p($g(^DHCCARDINVPRT(HISPrtRowID)),"^",2)
			if (InvFlag'="N"){		//存在退卡或其它业务
				set billFlag="N"
			}
			
		}elseif(PayAdmType="IP"){
			if $d(^DHCINVPRTZY(0,"InitInv",HISPrtRowID)){
				set AbortRowId=""
				set AbortRowId=$o(^DHCINVPRTZY(0,"InitInv",HISPrtRowID,""))
				quit:(+AbortRowId=0)
				set prtAmount=$p(^DHCINVPRTZY(AbortRowId),"^",6)
				if (+prtAmount<0){
					set billFlag="N"
				}
				
			}
			
		}elseif(PayAdmType="DEP"){
			set InvFlag=$p($g(^DHCSFPRINTDETAIL(HISPrtRowID)),"^",8)
			if (InvFlag'=1){	//存在退押金或其他业务
				set billFlag="N"
			}
			
		}elseif(PayAdmType="PE"){
			//由于体检发票表正记录被退费后，该正记录的状态并未发生变化，是否需要找体检组提供接口，根据业务类型及体检发票正记录ID判断该正记录是否被退费？？
			if $d(^DHCPEINVPRT(0,"REF",HISPrtRowID)){		//该方法是否可判断原纪录存在退费业务？？
				set AbortRowId="" 
				set AbortRowId=$o(^DHCPEINVPRT(0,"REF",HISPrtRowID,""))
				quit:(+AbortRowId=0)
				set prtAmount=$p(^DHCPEINVPRT(AbortRowId),"^",7)
				if (+prtAmount<0){
					set billFlag="N"
				}
			}
		
		}else{
			
		}
	}
	
	quit billFlag
}

/// 功能说明：根据发票表表dr获取当前最新一条电子票据相关信息
/// 入参说明: PayAdmType --> 票据业务类型
///                          IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
///           HisInvprtDr --> 票据表Dr
///           ExtStr      --> 备用参数
/// 返 回 值：Json串   base64二维码   ，票据地址
///           {"QrCode":"base64二维码","IUDPictureUrl":"票据地址"}         
/// w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetEInvQrCodeByHisInvDr("OP","5629432")
ClassMethod GetEInvQrCodeByHisInvDr(PayAdmType As %String, HisInvprtDr As %String) As %String
{
 
	s EinvInfo=##class(%DynamicObject).%New()
	q:(PayAdmType="")||(HisInvprtDr="") EinvInfo
	s rowid="",IUDPictureUrl="",QrCode=""
	f  s rowid=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR", PayAdmType, HisInvprtDr, rowid), -1) q:((rowid="")||(IUDPictureUrl'=""))  d
	.s objInvUpDetails=##class(BILL.EINV.PO.InvUpDetails).%OpenId(rowid,0)
	.s EInvFlg=objInvUpDetails.EInvFlg
	.q:EInvFlg=""
    .s QrCode=objInvUpDetails.IUDBillQRCode              ;二维码  --base64
    .s IUDPictureUrl=objInvUpDetails.IUDPictureUrl    ;链接地址
	.s EinvInfo.QrCode=QrCode
	.s EinvInfo.IUDPictureUrl=IUDPictureUrl
	q EinvInfo.%ToJSON()
}

}
