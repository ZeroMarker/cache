Class BILL.EINV.BL.EInvoiceLogic Extends %RegisteredObject [ LegacyInstanceContext ]
{

/// 功能说明：生成票据上传监管业务明细
/// 入参说明: PayAdmType      --> 票据业务类型
///                               IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金,CF:卡费
///                               自助机传什么类型？参数怎么传，业务流程是什么样的？
///           HISPrtRowID     --> HIS发生业务发票ID
///           OrgHISPrtRowID  --> 原业务ID(正业务为空)
///           PathCode        --> 申请路径代码 参照BILL_EINV_PO.InvLogicPath表Code 
///                               Invoice	票据开具 Invalid 退票业务 InvalidBlank 开具空票……
///           ExpStr          --> 扩展字符串(1操作员ID^2安全组^3科室^4院区^5票据代码^6票据号码^7费别) 
/// 返 回 值：成功标志^错误信息
///           成功标志(0 成功 其他值代表失败) 
/// 表 信 息: BILL_EINV_PO.InvUpDetails
/// 修改履历：王建     2019-08-23   新做成
///           董科锋   2019-09-17   梳理程序结构 抽取功能小方法
///           董科锋   2019-09-19   his业务成功,但是业务交易表中没有保存数据的情况(电子开票没开始) 
///                                 his业务成功,业务交易表中已经保存了数据,开票没有成功的情况利用原有的交易表数据
///                                 his业务成功,业务交易表中也保存了入参信息，返回结果没有保存成功的情况(Adp层中调用主业务之前查询一下结果)
///                                 由于本业务相对于his的结算本来就是一个异步的调用，所以这里异步的job调用没有必要了,改了成同步调用
/// 其    他: 项目如需调整业务流水号长度，请与计费医保组-董科峰或徐保保、郭云龙联系，不得擅自修改流水号长度----##class(BILL.EINV.COM.Common).CreateBusinessNo("IP","32","123456") 
/// 其    他：w ##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill("OP",16,"","","") 
/// 	w ##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill("OP",6839122,6839121,"","")
///     w ##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill("OP",5629459,"","InvalidInvSvr","")
///     w ##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill("OP",3786062,"","InvalidInvSvr","")
///     w ##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill("OP",5629467,"","PrintPaper","102^^^^151060117^00004340")
///     w ##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill("OP",5629467,"","RePrintPaper","102^5^17^^151060117^000043408")
/// 	w ##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill("REG",6839095,"","","")
/// 	w ##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill("REG",6838864,6838863,"","") 
/// 	w ##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill("IP",214467,"","","")
/// 	w ##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill("IP",132270,132269,"","") 
/// 	w ##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill("IP",132283,"","PrintPaper","1698^^^^31301^1805465510")
/// 	w ##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill("IP",132283,"","RePrintPaper","1698^^^^31301^1805465511") 
/// 	w ##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill("IP",132284,132283,"InvalidPaperInv","") 
ClassMethod InvocieBill(PayAdmType As %String, HISPrtRowID As %String, OrgHISPrtRowID As %String, PathCode As %String, ExpStr As %String) As %String
{
	s ErrCode="-1"  ;错误代码
	set $ZT="InvocieBillET"
	
	s QuitMsg=""
	s InputpamInfo="PayAdmType:"_PayAdmType_",HISPrtRowID:"_HISPrtRowID_",OrgHISPrtRowID:"_OrgHISPrtRowID_",PathCode:"_PathCode_",ExpStr:"_ExpStr
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill开始."_InputpamInfo,PayAdmType,HISPrtRowID)
	if (PayAdmType="")||(HISPrtRowID="") {
		s QuitMsg=ErrCode_"^票据业务类型和业务发票ID不能为空."
		d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error(QuitMsg,PayAdmType,HISPrtRowID)
	}
	q:(PayAdmType="")||(HISPrtRowID="") QuitMsg
	
	
	//1.电子发票服务商基本配置信息获取
	s ObjConfig=""
	s RtnConfig=##class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	if (RtnConfig'="1"){
		s QuitMsg=ErrCode_"^获取电子票据服务的全局配置失败."
		d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error(QuitMsg,PayAdmType,HISPrtRowID)
	}
	q:(RtnConfig'="1") QuitMsg
	
	//2 add guoyunlong  增加校验门诊发票和挂号发票数据
	s PayAdmType=##class(BILL.EINV.BL.EInvoiceLogic).CheckOPInvPam(PayAdmType, HISPrtRowID)
	
	//add by xubaobao 2020 09 07 将入参验证、业务逻辑验证功能放在取患者基本信息和就诊信息之前
	//3.业务入参验证、业务逻辑验证
	s InvociePam = ##class(BILL.EINV.DTO.COM.InvocieInputPam).%New()
	s ObjPatBaseInfo=""   ;基本信息对象
	s ObjPatAdmInfo=""    ;就诊信息对象
	s CheckRtn=..CheckInvocie(PayAdmType, HISPrtRowID, OrgHISPrtRowID, PathCode, ExpStr, ObjConfig, ObjPatBaseInfo, ObjPatAdmInfo, .InvociePam)  ;业务逻辑验证
	if (CheckRtn'="0"){
		s QuitMsg=ErrCode_"^"_InvociePam.ErrMsgInfo
		d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error(QuitMsg,PayAdmType,HISPrtRowID)
	}
	q:(CheckRtn'="0") QuitMsg
	
	;add by xubaobao 2020 09 07 如果体检数据存储类型为0时,从门诊发票表取数据
	s:InvociePam.PEStorageType="0" PayAdmType="OP" 
	
	//2.基本信息和就诊信息
	;s ObjPatBaseInfo=""   ;基本信息对象
	;s ObjPatAdmInfo=""    ;就诊信息对象
	s PatRtn=##class(BILL.EINV.BL.COM.Common).GetPatInfoByInv(PayAdmType, HISPrtRowID, .ObjPatBaseInfo, .ObjPatAdmInfo)  ;根据发票票信息获取患者基本信息及就诊信息
	if (PatRtn'="0"){
		s QuitMsg=ErrCode_"^获取患者的基本信息或就诊信息失败."
		d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error(QuitMsg,PayAdmType,HISPrtRowID)
	}
	q:(PatRtn'="0") QuitMsg
	
	//4.发票数据对象获取
	s ObjInvPrtInfo=##class(BILL.EINV.DTO.COM.InvPrtInfo).%New()
	s InvRtn=##class(BILL.EINV.BL.COM.Common).GetInvPrtInfo(ObjPatBaseInfo, ObjPatAdmInfo, InvociePam, .ObjInvPrtInfo)
	if (InvRtn'="0"){
		s QuitMsg=ErrCode_"^发票信息获取失败:"_InvociePam.ErrMsgInfo
		d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error(QuitMsg,PayAdmType,HISPrtRowID)
	}
	q:(InvRtn'="0") QuitMsg
	
	//判断当前业务是否需要获取票据代码/票据号码信息
	s InvCodeNoRtn=##class(BILL.EINV.BL.COM.Common).SetInvCodeAndNo(InvociePam, ObjInvPrtInfo)
	b ;InvCodeNoRtn 
	if (InvCodeNoRtn'="0") {
		s QuitMsg=ErrCode_"^"_"获取票号失败."_InvociePam.ErrMsgInfo
		d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error(QuitMsg,PayAdmType,HISPrtRowID)
	}
	q:(InvCodeNoRtn'="0") QuitMsg
		
	//5.调用服务前给交易表保存信息
	s ObjInvUpDetail=##class(BILL.EINV.DTO.COM.InvUpDetailInfo).%New()  ;交易对象
	s SaveRtn=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).InertInvocieBill(ObjInvPrtInfo, InvociePam, .ObjInvUpDetail)  ;调用开票等服务前，保存业务数据。
	if (SaveRtn'="0"){
		s QuitMsg=ErrCode_"^"_"调用服务前保存交易数据失败."_InvociePam.ErrMsgInfo
		d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error(QuitMsg,PayAdmType,HISPrtRowID)
	}
	q:(SaveRtn'="0") QuitMsg
	
	//6.调用开票或者红冲服务
	s SerciceRtn=..InvocieService(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;调用电子发票服务
	if (SerciceRtn'="0"){
		s QuitMsg=ErrCode_"^"_"调用服务失败."_InvociePam.ErrMsgInfo
		d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error(QuitMsg,PayAdmType,HISPrtRowID)
	}
	q:(SerciceRtn'="0") QuitMsg
	
	//7.服务成功后,保存交易结果
	s UpdRtn=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).SaveServiceResult(ObjInvUpDetail, InvociePam)
	if (UpdRtn'="0"){
		s QuitMsg=ErrCode_"^"_"保存开票结果信息失败."
		d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error(QuitMsg,PayAdmType,HISPrtRowID)
	}
	q:(UpdRtn'="0") QuitMsg
	
	//add by xubaobao 2020 09 11 判断换开成功后的第三方票号与传入的当前票号是否一致，一致走号，不一致不走号
	s:((InvociePam.PathCode="PrintPaper")&&(InvociePam.pBillNo'=ObjInvUpDetail.IUDBillBatchNo)) InvociePam.JumpEnvNoFlg="0"
	
	//8.走号(根据业务类型判断是否需要走号,需要走号的情况下 执行走号操作)
	s UpdRtn=##class(BILL.EINV.BL.COM.Common).JumpEnvCodeAndNo(InvociePam)
	if (UpdRtn'="0"){
		s QuitMsg=ErrCode_"^"_"更新发放表数据失败(走号)."
		d ##class(BILL.EINV.BL.COM.LogInfoCtl).Error(QuitMsg,PayAdmType,HISPrtRowID)
	}
	q:(UpdRtn'="0") QuitMsg

	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill结束.",PayAdmType,HISPrtRowID)
	s ErrCode="0"
	q ErrCode_"^成功"_"^"_ObjInvUpDetail.RowId
	
InvocieBillET
	s ErrCode="-1"
	q ErrCode_"^电子票据业务执行失败^"
}

/// 功能：校验门诊，挂号发票ID和业务类型不匹配问题（收费发票-业务类型传REG,挂号发票-业务类型传OP）
/// 时间：2022-07-22
/// input:PayAdmType     --业务类
///       HISPrtRowID    --发票ID
/// return: PayAdmType--业务类型
/// debug: w ##class(BILL.EINV.BL.EInvoiceLogic).CheckOPInvPam("IP","123")
ClassMethod CheckOPInvPam(PayAdmType, HISPrtRowID) As %String
{
	if (PayAdmType="OP")||(PayAdmType="REG"){
	    s FariType=$p($g(^DHCINVPRT(HISPrtRowID)),"^",34)	 ;收费类型F-收费，R-挂号
	    s PayAdmType=$case(FariType,"R":"REG",:"OP")
	}
	q PayAdmType
}

/// 功能说明：电子票据业务相关的验证处理
/// 入参说明: PayAdmType      --> 票据业务类型
///                               IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
///           HISPrtRowID     --> HIS发生业务发票ID
///           OrgHISPrtRowID  --> 原业务ID(正业务为空)
///           PathCode        --> 申请路径代码 参照BILL_EINV_PO.InvLogicPath表Code 
///                               Invoice	票据开具 Invalid 退票业务 InvalidBlank 开具空票……
///           ExpStr          --> 扩展字符串(1操作员ID^2安全组^3科室^4院区^5票据代码^6票据号码^7费别) 
///           ConfigObj       --> 服务配置信息
///           ObjPatBaseInfo  --> 患者基本信息
///           ObjPatAdmInfo   --> 患者就诊信息
///           InvociePam      --> 参数对象[出参]
/// 返 回 值：0 成功 其他值为失败
/// 修改履历：董科锋   2019-09-18  新做成
///           董科锋   2019-09-20  判断红冲票据对应的正票是否已经上传成功、参与住院结算的押金票是否都已经上传成功
ClassMethod CheckInvocie(PayAdmType As %String, HISPrtRowID As %String, OrgHISPrtRowID As %String, PathCode As %String, ExpStr As %String, ConfigObj As BILL.EINV.PO.InvUpConfig, ByRef ObjPatBaseInfo As BILL.EINV.DTO.COM.PatBaseInfo, ObjPatAdmInfo As BILL.EINV.DTO.COM.PatAdmInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlg="0"
	
	//01 保存入参
	i $isobject(InvociePam)=0 d
	.s InvociePam=##class(BILL.EINV.DTO.COM.InvocieInputPam).%New()
	
	s InvociePam.ObjUPConfig=ConfigObj    ;服务器的配置信息(地址、端口号、密钥等信息)
	s InvociePam.PayAdmType=PayAdmType
	s InvociePam.HISPrtRowID=HISPrtRowID
	s InvociePam.OrgHISPrtRowID=OrgHISPrtRowID
	s InvociePam.PathCode=PathCode
	s InvociePam.ExpStr=ExpStr                  ;原始的扩展参数
	s InvociePam.UserID=$p(ExpStr, "^", 1)      ;操作员ID
	s InvociePam.GroupID=$p(ExpStr, "^", 2)     ;安全组ID
	s InvociePam.CTLocID=$p(ExpStr, "^", 3)     ;科室ID
	s InvociePam.HospitalID=$p(ExpStr, "^", 4)  ;院区ID
	s InvociePam.pBillBatchCode=$p(ExpStr, "^", 5)     ;纸质票据代码   ;add by xubaobao 2019 09 27 纸质票据使用
	s InvociePam.pBillNo=$p(ExpStr, "^", 6)            ;纸质票据号
	s InvociePam.AdmreasonDr=$p(ExpStr, "^", 7)        ;费别
	
	;;;;;对于第三方，传进来的是UserCode需要转一下
	;if $d(^SSU("SSUSR",0,"SSUSR_Initials",InvociePam.UserID)) d
	;.s InvociePam.UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",InvociePam.UserID,""))
	i InvociePam.UserID'="" d
	.s InvociePam.UserCode=$p($g(^SSU("SSUSR",InvociePam.UserID)),"^",1)        ;操作员编码
	.s InvociePam.UserDesc=$p($g(^SSU("SSUSR",InvociePam.UserID)),"^",2)		;操作员名称
	
	i InvociePam.PathCode="" d  ;票据开具、作废冲红票据、作废空白票据的PathCode为空，需要票据业务类型、发生业务发票ID、原业务发票ID来计算
	.s PathCode=..JudgePatCode(PayAdmType,HISPrtRowID,OrgHISPrtRowID)    ;计算电子票据PatchCode编码
	.s InvociePam.PathCode=PathCode
	
	//add by xubaobao 2021 03 02 调用方式;		1：调用平台组请求，2：通过webservice请求调用，其他：http请求调用
	s RequestType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","BILLEINV_RequestType",5)
	s InvociePam.RequestType=RequestType
	
	
	//add  guoyunlong 2022-02-25  增加是否多院区的一个配置,8.3之后取基础数据需要传院区
	s HospitalFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","BILLEINV_HospitalFlag",5)
	s InvociePam.HospitalFlag=HospitalFlag
	
	//add  guoyunlong 2023-03-10  增加安全组到开票点对照
    s GPlaceCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Group_Con_PlaceCode",InvociePam.GroupID,5)
	s:GPlaceCode'="" InvociePam.UserCode=GPlaceCode
	 
	;add 2022-11-22 开票点对照，HIS工号和开票点对照（主要是自助机多个工号对照一个开票点）
	s ExitFlag=##class(%Dictionary.MethodDefinition).%ExistsId("BILL.CFG.COM.GeneralCfg||GetResultByRelaCode")
	if (+ExitFlag>0){
	  s CfgJsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("INVMNGM.OPBill.ZZJYHDZ",InvociePam.UserID,"1",InvociePam.HospitalID)
	  s JsonStr=##class(%DynamicAbstractObject).%FromJSON(CfgJsonStr)
	  s data=JsonStr.data
	  s placeCode=$p(data,"^",1)
	  s:placeCode'="" InvociePam.UserCode=$p(data,"^",1)
	}
	;end
	//02 业务验证
	//2-1 业务类型编码是否为空
	i PathCode="" d
	.s InvociePam.ErrMsgInfo="业务类型编码[PathCode]为空."
	.s RtnFlg="-1"
	q:RtnFlg'="0" RtnFlg
	
	//2-2 服务是否开启验证
	s ActiveFlag=ConfigObj.IUCActiveFlag		;启用标志 Y启用 N 关闭
	i ActiveFlag'="Y" d
	.s InvociePam.ErrMsgInfo="全局配置未开启"
	.s RtnFlg="-1"
	q:RtnFlg'="0" RtnFlg
	
	//2-3 业务类型对应的处理类是否配置
	s ObjInvLogicPath=""
	s LogicPathFlg=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetInvLogicPath(InvociePam.PathCode, ConfigObj.FactoryCode, .ObjInvLogicPath)  ;获取业务处理配置信息
	i LogicPathFlg'="0" d
	.s InvociePam.ErrMsgInfo="票据业务的处理类及方法信息没有配置,请联系信息科."
	.s RtnFlg="-1"
	q:RtnFlg'="0" RtnFlg
	s InvociePam.ObjInvLogicPath=ObjInvLogicPath             ;业务处理类配置对象
	s InvociePam.IUDPrintType=ObjInvLogicPath.IUDPrintType   ;票据模式 E-电子票据 P-纸质发票
	
	//2-4 判断当前交易是否已经存在(由于换开纸质票据业务后，还允许有重新换开纸质业务所以这里也记录了原换开纸质票据业务表Dr)
	s RtnFlg=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).ChecNowkTradeFlg(InvociePam)  ;判断当前业务是否存在
	q:RtnFlg'="0" RtnFlg
	
	//2-5 判断当前业务是否应该存在对应前置交易，存在的时候判断前置交易时否在交易表中，在交易表中的时候获取前置交易Dr
	s RtnFlg=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).CheckOriTradeFlg(InvociePam)
	q:RtnFlg'="0" RtnFlg
	
	//2-6 住院发票开具时需要判断 已参与结算的预交金发票是否全部上传成功
	//CheckDepFlag:住院押金是否开票(1:开票  0:不开票)
	s CheckDepFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPDeposit_Invocie_Flg",5)
	i (PayAdmType="IP")&&(PathCode="Invoice")&&(CheckDepFlag="1") d
	.s AlltAllDepositUpFlg=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetAllDepositUpFlg(PayAdmType, HISPrtRowID)
	.s AlltAllDepositUpFlg="Y"            //宁波鄞州测试时使用，测试完注释
	.i AlltAllDepositUpFlg'="Y" d
	..s InvociePam.ErrMsgInfo="存在未上传成功的已参与结算的押金票据."
	..s RtnFlg="-1"
	q:RtnFlg'="0" RtnFlg
	
	//2-7 税控的设备编码验证及获取(有税控设备的时候 才需要这个字段)  ;+dongkf 2019 12 12
	s RtnFlg=..CheckTaxDevice(InvociePam)
	;q:RtnFlg'="0" RtnFlg
	
	//下边继续写验证逻辑
	//+dongkf 2019 12 25 stat
	s hospitalNo=""
	s hospitalInfoNum=##class(BILL.EINV.COM.Common).GetHospitalInfoByDic(InvociePam.HospitalInfoMap, hospitalNo)  ;获取医院的配置信息
	//+dongkf 2019 12 25 stat
	
	;add by xubaobao 2020 09 07 start
	//获取体检数据存储类型 1:体检发票表取数据  0 门诊发票表取数据
	s CheckPEType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","PEStorage_Type",5)
	s:CheckPEType="" CheckPEType="1"  ;如果体检存储类型未维护默认从体检发票表取数据
	s InvociePam.PEStorageType=CheckPEType
	;add by xubaobao 2020 09 07 end
	;add 2022-09-09    增加不允许开票支付方式校验
	s PayModeFlag=##class(BILL.EINV.BL.COM.Common).GetPayModeInfoByInvPrt(PayAdmType,HISPrtRowID)
	i PayModeFlag'="0" d
	.s InvociePam.ErrMsgInfo="该发票包含不允许开票支付方式"
	.s RtnFlg="-1"
	
	q RtnFlg
}

/// 功能说明：发票设备/税控设备验证/设备编码是否存在
///           设置设备编码
/// 返 回 值：0 验证成功 小于0代表验证失败
/// 修改履历：2019 12 12 董科锋 新做成
/// s InvociePam=##class(BILL.EINV.DTO.COM.InvocieInputPam).%New()
/// w ##class(BILL.EINV.BL.EInvoiceLogic).CheckTaxDevice(InvociePam)
ClassMethod CheckTaxDevice(InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlg="-1"
	
	s HaveRateDeviceFlg=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","Have_RateDevice_Flg", 5)   ;是否有税控设备标志 1 有 0 无
	s:HaveRateDeviceFlg="" HaveRateDeviceFlg="0"  ;默认无税控设备
	q:HaveRateDeviceFlg="0" "0"                   ;无税控设备 默认验证成功
	
	s IPAddress=##class(%SYSTEM.Process).ClientIPAddress()    ;获取IP地址
	if (IPAddress'="") {
		s SBBH=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ClientIP_TO_SBBH", IPAddress, 5)  ;设备编码
		if (SBBH'=""){
			s InvociePam.TaxSBBM=SBBH
			s RtnFlg="0"
		}else{
			s InvociePam.ErrMsgInfo="IP地址为["_IPAddress_"]的机器没有配置设备编号,不能开票!"
		}
	}else{
		s InvociePam.ErrMsgInfo="客户端IP地址获取失败,不能开票!"
	}
	
	q RtnFlg
}

/// 功能说明：调用电子发票相关服务，并保存返回结果
ClassMethod InvocieService(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	;-dongkf 2019 09 30 start
	;s PathCode=ObjInvUpDetail.IUDUploadPathCode
	;s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode,"I")
	;s ClassName=$p(IUPConInfo,"^",1)
	;s MethodName=$p(IUPConInfo,"^",2)
	;-dongkf 2019 09 30 start
	
	s ClassName=InvociePam.ObjInvLogicPath.IUPClassName    ;业务处理类
	s MethodName=InvociePam.ObjInvLogicPath.IUPMethodName   ;业务处理方法
	q:(ClassName="")||(MethodName="") "-9999^未配置开票接口类"	;未配置Adapter类
	
	Set Rtn=$ZOBJCLASSMETHOD(ClassName,MethodName,ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	
	q Rtn
}

/// w ##class(BILL.EINV.BL.EInvoiceLogic).SetBusinessNo(1,"OP")
ClassMethod SetBusinessNo(IUDRowID, BusinessExp) As %String
{
	//new (IUDRowID, BusinessExp)
	Set BusinessNo=""
	Set PayAdmType=$p(BusinessExp,"^",1)
	Set Hosp=$p(BusinessExp,"^",2)
	Set IUPMethodCode="BusinessNo"
	Set IUPConInfo=##class(BILL.Invoice.BL.base.Config).GetUploadPath(IUPMethodCode,"I")
	Set ClassName=$p(IUPConInfo,"^",1)
	Set MethodName=$p(IUPConInfo,"^",2)
	If (ClassName'="")&&(MethodName'=""){
		Set BusinessNo=$ZOBJCLASSMETHOD(MethodName,MethodName,IUDRowID,BusinessExp)
	}Else{
		
	
	Set CurrDate=$zd(+$h,8)	
	Set CurrTime=$tr($zt($p($h,",",2),2),":","")
	Set Tmp="000000"
	If $l(IUDRowID)>6 Set Serial=$e(IUDRowID,$l(IUDRowID)-5,$l(IUDRowID))
	Else  Set Serial=IUDRowID
	Set FormatSerial=$e(Tmp,1,$l(Tmp)-$l(Serial))_Serial
	Set BusinessNo=CurrDate_CurrTime_PayAdmType_FormatSerial	
	}
	Quit BusinessNo
}

/// Creator：	wangjian
/// CreatDate：	2019-09-01
/// Desc:		任务接口 根据配置的业务类型和参数调用对应的任务方法，如果有多个任务需要在任务列表中配置多个
/// Input:		Args(1) IUPMethodCode 任务代码
/// 	 		ExpStr:扩展(备用)
/// Return:		
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).TaskService("BatchInvoice","2019-09-01","2019-09-01")
ClassMethod TaskService(Args...) As %String
{
	Set IUPMethodCode=$g(Args(1))
	Quit:IUPMethodCode="" "-9999^任务代码不能为空"
	Set ParCount=($zutil(141))
	
	Set IUPConInfo=##class(BILL.Invoice.BL.base.Config).GetUploadPath(IUPMethodCode,"T")  
	Set ClassName=$p(IUPConInfo,"^",1)
	Set MethodName=$p(IUPConInfo,"^",2)
	If (ClassName'="")&&(MethodName'=""){
		
		If ParCount=2 s Rtn=$ZOBJCLASSMETHOD(ClassName,MethodName,$g(Args(2)))
		If ParCount=3 s Rtn=$ZOBJCLASSMETHOD(ClassName,MethodName,$g(Args(2)),$g(Args(3)))
		If ParCount=4 s Rtn=$ZOBJCLASSMETHOD(ClassName,MethodName,$g(Args(2)),$g(Args(3)),$g(Args(4)))
		If ParCount=5 s Rtn=$ZOBJCLASSMETHOD(ClassName,MethodName,$g(Args(2)),$g(Args(3)),$g(Args(4)),$g(Args(5)))
		
	}Else{
		Set Rtn="-9999^未配置开票接口类"	;未配置Adapter类
	}
	Quit Rtn
}

/// Creator：	Suhuide
/// CreatDate：	2019-09-17
/// Desc:		根据PayAdmType,HISPrtRowID,ReHISPrtRowID获取电子票据PatchCode编码
/// Input:		PayAdmType:票据业务类型(IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金)
/// 			HISPrtRowID:HIS发生业务ID
/// 			ReHISPrtRowID 原业务ID(正业务为空)
/// Return:
/// 修改履历：董科锋 2019 09 29 业务流程梳理 增加冲红业务时, 走电子票据冲红还是作废已换开票据业务的判断		
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).JudgePatCode("","","")
ClassMethod JudgePatCode(PayAdmType, HISPrtRowID, OrgHISPrtRowID) As %String
{
	quit:(PayAdmType="") ""
	set PatchCode="Invoice"
	
	if (OrgHISPrtRowID'="") {  ;原票据Dr不为空时,属于冲红业务
		s PatchCode="InvalidInv"    ;票据冲红时默认为[冲红电子票据]
		
	}else{                     ;正常情况 没有传原票据Dr时,属于开具业务; 特殊情况下，需要考虑住院时,收费员未日结 产生的作废状态票据属于冲红业务
		//这里后续写作 住院时有作废情况的特殊处理
	}
	
	
	//判断是否存在有效的已换开票据,存在的情况下,需要做的是 [作废已换开纸质票据]业务
	if (PatchCode="InvalidInv"){
		s rowid=$o(^BILL.EINV.PO.InvUpDetailsI("IdxEInvFlg", PayAdmType, OrgHISPrtRowID, "P", "I", ""), -1)
		s:rowid'="" PatchCode="InvalidPaperInv" ;存在有效的已换开纸质票据时, 冲红业务需要调用[作废已换开纸质票据]业务
	}

	quit PatchCode
}

/*
ClassMethod JudgePatCode(PayAdmType, HISPrtRowID, OrgHISPrtRowID) As %String
{
	quit:(PayAdmType="") ""
	set PatchCode="Invoice"
	quit:(PayAdmType="OT")||(PayAdmType="IT") "InvalidBlankInv"			;作废空白票据
	quit:OrgHISPrtRowID'="" "InvalidInv"				;票据冲红
	set HISInitDR="",PrtAcount=0
	if (PayAdmType="OP")||(PayAdmType="REG"){
		set PrtAcount=$p(^DHCINVPRT(HISPrtRowID),"^",1)
		set HISInitDR=$p(^DHCINVPRT(HISPrtRowID),"^",13) 	
	}elseif(PayAdmType="API"){
		set PrtAcount=$p(^DHCINVPRTAP(HISPrtRowID),"^",1)	
		set HISInitDR=$p(^DHCINVPRTAP(HISPrtRowID),"^",10)
	}elseif(PayAdmType="PE"){
		set PrtAcount=$p(^DHCPEINVPRT(HISPrtRowID),"^",7)
		set HISInitDR=$p(^DHCPEINVPRT(HISPrtRowID),"^",9)	
	}elseif(PayAdmType="IP"){
		set PrtAcount=$p(^DHCINVPRTZY(HISPrtRowID),"^",6)	
		set HISInitDR=$p(^DHCINVPRTZY(HISPrtRowID),"^",13)
	}elseif(PayAdmType="DEP"){
		set PrtAcount=$p(^DHCSFPRINTDETAIL(HISPrtRowID),"^",6)	
		set HISInitDR=$p(^DHCSFPRINTDETAIL(HISPrtRowID),"^",43)
	}else{
		set PrtAcount=0
		set HISInitDR=""
	
	}
	
	if (HISInitDR'="")&&(+PrtAcount<0){
			set PatchCode="InvalidInv"				;票据冲红
	}
	quit PatchCode
}
*/
/// Creator：	Suhuide
/// CreatDate：	2019-09-19
/// Desc:		票据批量上传
/// Input:		endDate:结束日期
/// 返 回 值：	成功标志^错误信息
///           	成功标志(0 成功 其他值代表失败) 
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).BatchInvoiceUpload()
ClassMethod BatchInvoiceUpload(WorkDate As %String = "") As %String
{
	set ErrCode="-1"  ;错误代码
	
	s iWorkDate=+$h-1
	i WorkDate '="" d
	.s iWorkDate=$zdh(WorkDate, 3)
	
	//获取发票业务信息
	s stDate=iWorkDate        ;开始日期
	s endDate=iWorkDate       ;结束日期
	set OutStr=..GetNotINVInfo(stDate,endDate)
	set PIDKey=$p(OutStr,"^",1)
	
	//^TMPERREINV("NotSuccssUpdetails",PIDKey,prtrowid,PayAdmType)=ExpStr_"&"_InitRowid
	//遍历global数据,根据不同的业务类型调用票据监管业务进行票据补交易
	set PayAdmType=""
	for  set PayAdmType=$o(^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType)) quit:(PayAdmType="")  do
	.;+dognkf 2020 07 02 start
	.s UploadFlgTmp=..GetAutoUploadFlg(PayAdmType, "")   ;判断当前业务是否自动上传
	.q:UploadFlgTmp'="1"
	.;+dognkf 2020 07 02 end
	.set HISPrtRowID="0"
	.for  set HISPrtRowID=$o(^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,HISPrtRowID))  quit:(HISPrtRowID="")  do
	..set EINVStr=$g(^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,HISPrtRowID))
	..set ExpStr=$p(EINVStr,"&",1)
	..set InitRowId=$p(EINVStr,"&",2)
	..;+dognkf 2020 07 02 start
	..s InvUpFlgTmp=..GetAutoUploadInvFlg(PayAdmType, HISPrtRowID, InitRowId)  ;当前票据是否自动上传
	..q:InvUpFlgTmp'="1"
	..;+dognkf 2020 07 02 end
	..set ErrCode=..InvocieBill(PayAdmType,HISPrtRowID,InitRowId, "",ExpStr)    ;？？？PathCode未定义
	 
	kill ^TMPERREINV("NotSuccssUpdetails",PIDKey)
	quit ErrCode
}

/// Creator：	guoyunlong
/// CreatDate：	2022-09-02
/// Desc:		适用于开票和查询是异步的，上海美中嘉和，电子发票开票和查询是异步的，医院需要自动任务查询
/// Input:		endDate:结束日期
/// 返 回 值：	成功标志^错误信息
///           	成功标志(0 成功 其他值代表失败) 
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).BatchInvoiceUpload()
ClassMethod InvoiceUploadNow(WorkDate As %String = "") As %String
{
	set ErrCode="-1"  ;错误代码
	
	s iWorkDate=+$h
	i WorkDate '="" d
	.s iWorkDate=$zdh(WorkDate, 3)
	
	//获取发票业务信息
	s stDate=iWorkDate        ;开始日期
	s endDate=iWorkDate       ;结束日期
	s IUDID="",InitRowId=""
	for date=stDate:1:endDate  d
	.for  s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxDate",date,IUDID)) q:IUDID=""  d
	..q:IUDID=""
	..s IUDInfo=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID,0)
	..s PayAdmType=IUDInfo.IUDPayAdmType
	..s HISPrtRowID=IUDInfo.IUDInvDr
	..s Amont=IUDInfo.IUDCreatAmt
	..s IUDUplodeFlag=IUDInfo.IUDUplodeFlag
	..q:IUDUplodeFlag="Y"
	..s EInvFlg=IUDInfo.EInvFlg
	..q:EInvFlg'=""
	..i Amont<0  d
	...s ORGIUDInfo=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDInfo.IUDInitRowID,0)
	...s InitRowId=ORGIUDInfo.IUDInvDr
	..s UploadFlgTmp=..GetAutoUploadFlg(PayAdmType, "")   ;判断当前业务是否自动上传
	..q:UploadFlgTmp'="1"
	..s InvUpFlgTmp=..GetAutoUploadInvFlg(PayAdmType, HISPrtRowID, InitRowId)  ;当前票据是否自动上传
	..q:InvUpFlgTmp'="1"
	..;+dognkf 2020 07 02 end
	..s ExpStr=""
	..s ErrCode=..InvocieBill(PayAdmType,HISPrtRowID,InitRowId, "",ExpStr)    
	quit ErrCode
}

/// 功能说明：判断当前业务的发票是否利用任务上传电子票据(业务及票据)
///           在电子票据的字典数据中创建一个自动上传的业务节点
/// 入参说明：PayAdmType  --> 业务类型
///           InvprtDr    --> 发票表Dr
///           InitInvDr   --> 原发票表Dr
/// 返 回 值：1 自动上传 0 不自动上传
/// 修改履历：董科锋 2020 07 02 新做成
/// w ##class(BILL.EINV.BL.EInvoiceLogic).GetAutoUploadFlg("OP","")
ClassMethod GetAutoUploadFlg(PayAdmType As %String, ExtStr As %String) As %String
{
	s UploadFlg="0"
	s UploadDicInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Auto_Upload_PayAdmType",PayAdmType, 5)  ;是否属于自动上传的业务
	s:UploadDicInfo'="" UploadFlg="1"
	
	q UploadFlg
}

/// 功能说明：判断当前业务的发票是否利用任务上传电子票据(仅票据)
/// 入参说明：PayAdmType  --> 业务类型
///           InvprtDr    --> 发票表Dr
///           InitInvDr   --> 原发票表Dr
/// 返 回 值：1 自动上传 0 不自动上传
/// 修改履历：董科锋 2020 07 02 新做成
ClassMethod GetAutoUploadInvFlg(PayAdmType As %String, InvprtDr As %String, InitInvDr As %String) As %String
{
	s InvUpFlg="1"
	
	q InvUpFlg
}

/// Creator：	Suhuide
/// CreatDate：	2019-09-19
/// Desc:		获取未上传成功(冲红数据)并存入临时globle中
/// Input:		stDate:开始日期
/// 			endDate:结束日期
/// Globle:		^TMPERREINV("NotSuccssUpdetails")
/// 返 回 值：	进程号^条数
/// Modify:		增加登记号查询条件   +Add by suhuide at 2021-12-27     	
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).GetNotINVInfo()
ClassMethod GetNotINVInfo(stDate As %String, endDate As %String, patientNo As %String = "") As %String
{
	set PIDKey=$i(^TMPERREINV("NotSuccssUpdetails"))
	kill ^TMPERREINV("NotSuccssUpdetails",PIDKey)
	set Invindex=0
	set InvStr=""
	;set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set:endDate="" endDate=+$h
	set:(stDate="") stDate=endDate-1
	if (patientNo'=""){
		set PatientNO=$zcvt(patientNo,"U")
		set PatientID=$o(^PAPERi("PAPMI_PatNo",patientNo,""))
		quit:(PatientID="")
		//1.获取门诊、挂号发票信息
		set PrtRowid=""
		for  set PrtRowid=$o(^DHCINVPRT(0,"PAPMI",PatientID,PrtRowid),-1) quit:(PrtRowid="")  do
		.set InvStr=##class(BILL.EINV.BL.COM.Common).GetOPINVInfo(PrtRowid)
		.quit:InvStr=""
		.set ExpStr=$p(InvStr,"&",1)
		.set InitRowid=$p(InvStr,"&",2)
		.set PayAdmType=$P($p(InvStr,"&",3),"^",1)
		.set ^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,PrtRowid)=ExpStr_"&"_InitRowid   ;1
		.set Invindex=Invindex+1
		
		//2.获取获取集中打印发票信息
		set PrtRowid=""
		for  set PrtRowid=$o(^DHCINVPRTAPi(0,"PAPMI",PatientID,PrtRowid)) quit:(PrtRowid="")  do
		.set InvStr=##class(BILL.EINV.BL.COM.Common).GetAPIINVInfo(PrtRowid)
		.quit:InvStr=""
		.set ExpStr=$p(InvStr,"&",1)
		.set InitRowid=$p(InvStr,"&",2)
		.set PayAdmType=$P($p(InvStr,"&",3),"^",1)
		.set ^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,PrtRowid)=ExpStr_"&"_InitRowid   ;1
		.set Invindex=Invindex+1

		//3.获取体检发票信息
    	set Adm=""
    	for  set Adm=$o(^PAPERdr(PatientID,"ADM","H",Adm),-1) quit:(Adm="")  do
    	.set PrtRowid=""
    	.for  set PrtRowid= $o(^DHCPEINVPRT(0,"ADM",Adm,PrtRowid))	quit:(PrtRowid="")  do
    	..set InvStr=##class(BILL.EINV.BL.COM.Common).GetPEINVInfo(PrtRowid)
    	..quit:InvStr=""
		..set ExpStr=$p(InvStr,"&",1)
		..set InitRowid=$p(InvStr,"&",2)
		..set PayAdmType=$P($p(InvStr,"&",3),"^",1)
		..set ^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,PrtRowid)=ExpStr_"&"_InitRowid   ;1
		..set Invindex=Invindex+1

		//4.获取住院预交金信息
		set type=""
	 	for  set type=$o(^PAPERdr(PatientID,"ADM",type))  quit:(type="")  do
	 	.set admid=0
	 	.for  set admid=$o(^PAPERdr(PatientID,"ADM",type,admid))  quit:(admid="")  do
		..set visitStatus=$p($g(^PAADM(admid)),"^",20)
		..;quit:((admType="P")&&(visitStatus'="P"))
		..;quit:((admType="I")&&((visitStatus="P")||(type'="I")))
		..set PrtRowid=""
		..for  set PrtRowid=$o(^DHCSFPRINTDETAIL(0,"adm",admid,PrtRowid)) quit:(PrtRowid="")  do
		...set InvStr=##class(BILL.EINV.BL.COM.Common).GetDEPDepInfo(PrtRowid)
		...quit:InvStr=""
		...set ExpStr=$p(InvStr,"&",1)
		...set InitRowid=$p(InvStr,"&",2)
		...set PayAdmType=$P($p(InvStr,"&",3),"^",1)
		...set ^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,PrtRowid)=ExpStr_"&"_InitRowid   ;1
		...set Invindex=Invindex+1

		//5.获取住院发票信息
		set episodeId=##class(BILL.EINV.BL.COM.Common).GetAdmByPapmi(PatientID)
		if (+episodeId>0){
			set PrtRowid=""
			for  set PrtRowid=$o(^DHCINVPRTZY(0,"ADM",episodeId,PrtRowid))  quit:(PrtRowid="")  do
			.set InvStr=##class(BILL.EINV.BL.COM.Common).GetIPINVInfo(PrtRowid)
			.quit:InvStr=""
			.set ExpStr=$p(InvStr,"&",1)
			.set InitRowid=$p(InvStr,"&",2)
			.set PayAdmType=$P($p(InvStr,"&",3),"^",1)
			.set ^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,PrtRowid)=ExpStr_"&"_InitRowid   ;1
			.set Invindex=Invindex+1
		}
	}else{
		for date=stDate:1:endDate do
		.//1.获取门诊、挂号发票信息
		.set prtrowid=0
		.for  set prtrowid=$o(^DHCINVPRT(0,"Date",date,prtrowid)) quit:(prtrowid="")   do
		..set InvStr=##class(BILL.EINV.BL.COM.Common).GetOPINVInfo(prtrowid)
		..quit:InvStr=""
		..set ExpStr=$p(InvStr,"&",1)
		..set InitRowid=$p(InvStr,"&",2)
		..set PayAdmType=$P($p(InvStr,"&",3),"^",1)
		..set ^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,prtrowid)=ExpStr_"&"_InitRowid   ;1
		..set Invindex=Invindex+1
		
		.//2.获取集中打印发票信息
		.set prtrowid=0
		.for  set prtrowid=$o(^DHCINVPRTAPi(0,"Date",date,prtrowid)) quit:(prtrowid="")   do
		..set InvStr=##class(BILL.EINV.BL.COM.Common).GetAPIINVInfo(prtrowid)
		..quit:InvStr=""
		..set ExpStr=$p(InvStr,"&",1)
		..set InitRowid=$p(InvStr,"&",2)
		..set PayAdmType=$P($p(InvStr,"&",3),"^",1)
		..set ^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,prtrowid)=ExpStr_"&"_InitRowid   ;1
		..set Invindex=Invindex+1
		
		.//3.获取体检发票信息
		.set prtrowid=0
		.for  set prtrowid=$o(^DHCPEINVPRT(0,"DATE",date,prtrowid)) quit:(prtrowid="")   do
		..set InvStr=##class(BILL.EINV.BL.COM.Common).GetPEINVInfo(prtrowid)
		..quit:InvStr=""
		..set ExpStr=$p(InvStr,"&",1)
		..set InitRowid=$p(InvStr,"&",2)
		..set PayAdmType=$P($p(InvStr,"&",3),"^",1)
		..set ^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,prtrowid)=ExpStr_"&"_InitRowid   ;1
		..set Invindex=Invindex+1
		
		.//4.获取住院预交金信息
		.set prtrowid=0
		.for  set prtrowid=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,prtrowid)) quit:(prtrowid="")   do
		..set InvStr=##class(BILL.EINV.BL.COM.Common).GetDEPDepInfo(prtrowid)
		..quit:InvStr=""
		..set ExpStr=$p(InvStr,"&",1)
		..set InitRowid=$p(InvStr,"&",2)
		..set PayAdmType=$P($p(InvStr,"&",3),"^",1)
		..set ^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,prtrowid)=ExpStr_"&"_InitRowid   ;1
		..set Invindex=Invindex+1
		
		.//5.获取住院发票信息
		.set prtrowid=0
		.for  set prtrowid=$o(^DHCINVPRTZY(0,"DATE",date,prtrowid)) quit:(prtrowid="")   do
		..s InvStr=##class(BILL.EINV.BL.COM.Common).GetIPINVInfo(prtrowid)
		..quit:InvStr=""
		..set ExpStr=$p(InvStr,"&",1)
		..set InitRowid=$p(InvStr,"&",2)
		..set PayAdmType=$P($p(InvStr,"&",3),"^",1)
		..set ^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,prtrowid)=ExpStr_"&"_InitRowid   ;1
		..set Invindex=Invindex+1
		
	}
	quit PIDKey_"^"_Invindex
}

/// Creator：	Suhuide
/// CreatDate：	2019-09-19
/// Desc:		获取纸质/电子票据领用号段
/// Input:		UserID(收费员ID)
/// 			billCode:票据类型(O:门诊发票类型,R:挂号发票类型,I:住院发票类型,D:住院押金类型)
///             billBatchCode:票据代码(是否纸质票据/电子票据)
/// 返 回 值：	成功标志^错误信息
///           	成功标志(0 成功 其他值代表失败) 
///           	
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).GetBillParagraphNo("102^^")
ClassMethod GetBillParagraphNo(InputPam As %String) As %String
{
	s ErrCode="-1"  ;错误代码
	s UserID=$p(InputPam,"^",1)         ;收费员人ID
	s billCode=$p(InputPam,"^",2)       ;票据类型
	s billBatchCode=$p(InputPam,"^",3)  ;票据代码(是否纸质票据/电子票据)
	s InvType=$p(InputPam,"^",4)		;票据种类(O:门诊发票类型,R:挂号发票类型,I:住院发票类型,D:住院押金类型)
	//1.根据his票据类型对照博思票据种类代码
	//组织接口入参
	
	;s $p(InputPam,"^",1)=$p($g(^SSU("SSUSR",UserID)),"^",1)
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:RtnConfig'="1" ErrCode_"^获取电子发票服务配置失败."
	
	;s $p(InputPam,"^",3)=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("LogicIUDTypeCon"_ObjConfig.FactoryCode,billCode,5)   ;获取对照的票据类型
	//2.根据his自定义的纸质票据/电子票据类型对照博思票据代码
	;q:(placeCode="")||(billCode="")||(billBatchCode="") ErrCode
	
	s PathCode="InvReceive"			;票据领取PathCode
	s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode,"I")
	s ClassName=$p(IUPConInfo,"^",1)
	s MethodName=$p(IUPConInfo,"^",2)
	q:(ClassName="")||(MethodName="") "-9999^未配置开票接口类"	;未配置Adapter类
	b ;00
	//3.调用Adapter层类方法
	s ObjValidBillNo=##class(BILL.EINV.DTO.COM.ValidBillNo).%New()  ;交易对象
	s SerciceRtn=$ZOBJCLASSMETHOD(ClassName,MethodName,InputPam,.ObjValidBillNo, ObjConfig)
	q:SerciceRtn'="0" ErrCode_"^"_"调用服务失败."
	
	b ;GetBillParagraphNo save 1
	//4.服务成功后,保存交易结果
	s SaveRtn=##class(BILL.EINV.BL.COM.InvoiceCtl).SaveServiceResult(ObjValidBillNo)
	b ;GetBillParagraphNo save 2
	q:SaveRtn'="0" ErrCode_"^"_"保存发票号段失败."
	b ;GetBillParagraphNo save 3
	
	s ErrCode="0"
	q ErrCode_"^成功"

	q ErrCode
}

/// Creator：	Suhuide
/// CreatDate：	2019-09-26
/// Desc:		获取当前纸质票据可用号码
/// Input:		InputPam(操作人ID^票据类型代码^...)
///  			PathCode :接口业务类型
/// 返 回 值：	成功标志^错误信息
///           	成功标志(0 成功 其他值代表失败) 
///           	
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).GetStockBillNo("7^O","PaperNo")
ClassMethod GetStockBillNo(InputPam As %String, PathCode As %String) As %String
{
	s ErrCode="-1"  ;错误代码
	
	s UserID=$p(InputPam,"^",1)      ;收费员人ID
	s pBillBatchCode=$p(InputPam,"^",2)  ;纸质票据代码(O:门诊发票类型,R:挂号发票类型,I:住院发票类型,D:住院押金类型)
	//1.根据his票据类型对照博思票据种类代码
	q:(UserID="")||(pBillBatchCode="")||(PathCode="") ErrCode
	
	//1.电子发票服务商基本配置信息获取
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(RtnConfig'="1") ErrCode_"^获取电子发票服务配置失败."
	
	//组织接口入参
	s $p(InputPam,"^",1)=$p($g(^SSU("SSUSR",UserID)),"^",1)
	//s $p(InputPam,"^",2)=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("LogicIUDTypeCon"_ObjConfig.FactoryCode,pBillBatchCode,5)   ;获取对照的票据类型
	
	//业务处理配置信息你获取 +dongkf 2019 09 30
	s ObjInvLogicPath=""
	s LogicPathFlg=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetInvLogicPath(PathCode, ObjConfig.FactoryCode, .ObjInvLogicPath)  ;获取业务处理配置信息
	q:LogicPathFlg'="0" "-9999"
	s ClassName=ObjInvLogicPath.IUPClassName     ;类方法
	s MethodName=ObjInvLogicPath.IUPMethodName	
	q:(ClassName="")||(MethodName="") "-9999"  ;"-9999^未配置开票接口类"	;未配置Adapter类
	
	//3.调用Adapter层类方法
	s ObjPaperBillNo=##class(BILL.EINV.DTO.COM.PaperBillNo).%New()  ;交易对象
	s SerciceRtn=$ZOBJCLASSMETHOD(ClassName,MethodName,InputPam, ObjConfig, .ObjPaperBillNo)
	q:SerciceRtn'="0" ErrCode_"^"_"调用服务失败."
	
	s ErrCode= ObjPaperBillNo.pBillBatchCode_"^"_ObjPaperBillNo.pBillNo
	
	q ErrCode
}

/// Creator：	xubaobao
/// CreatDate：	2019 09 28
/// Desc:		空白纸质票据作废
/// Input:		InputPam(收费员ID^纸质票据代码^起始纸质票据号^终止纸质票据号^作废原因...)
/// 返 回 值：	成功标志^错误信息
///           	成功标志(0 成功 其他值代表失败) 
///           	
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).InvalidBlankBillNo("1698^31301^1805465506^1805465509","InvalidBlankInv")  //住院
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).InvalidBlankBillNo("7^31101^4311304116^4311304119","InvalidBlankInv")  //门诊
ClassMethod InvalidBlankBillNo(InputPam As %String, PathCode As %String, IUDADMType As %String = "") As %String
{
	s ErrCode="-1"  
	s UserID=$p(InputPam,"^",1)      ;操作员ID
	s pBillBatchCode=$p(InputPam,"^",2)  ;第三方接口纸质票据代码
	s pBillNoStart=$p(InputPam,"^",3)      //起始纸质票据号
	s pBillNoEnd=$p(InputPam,"^",4)	       //终止纸质票据号
	s reason=$p(InputPam,"^",5)	           //作废原因
	//1.根据his票据类型对照博思票据种类代码
	;s pBillBatchCode=$case(pBillBatchCode,"O":"31101","R":"31101","I":"31301",:"")
	q:(UserID="")||(pBillBatchCode="")||(pBillNoStart="")||(pBillNoEnd="")||(PathCode="") ErrCode_"^入参错误."
	
	//1.电子发票服务商基本配置信息获取
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:RtnConfig'="1" ErrCode_"^获取电子发票服务配置失败."
	
	//组织接口入参
	//s $p(InputPam,"^",1)=$p($g(^SSU("SSUSR",UserID)),"^",1)
	//s:"O^R^I^D"[pBillBatchCode $p(InputPam,"^",2)=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("LogicIUDTypeCon"_ObjConfig.FactoryCode,pBillBatchCode,5)
	
	//业务处理配置信息你获取 +dongkf 2019 09 30
	s ObjInvLogicPath=""
	s LogicPathFlg=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetInvLogicPath(PathCode, ObjConfig.FactoryCode, .ObjInvLogicPath)  ;获取业务处理配置信息
	q:LogicPathFlg'="0" "-9999"
	s ClassName=ObjInvLogicPath.IUPClassName     ;类方法
	s MethodName=ObjInvLogicPath.IUPMethodName	
	q:(ClassName="")||(MethodName="") "-9999"    ; "-9999^未配置开票接口类"	;未配置Adapter类
	
	//3.调用Adapter层类方法
	s SerciceRtn=$ZOBJCLASSMETHOD(ClassName,MethodName,InputPam, ObjConfig)
	q:SerciceRtn'="0" ErrCode_"^"_"调用服务失败."
	
	//4.服务成功后,保存交易结果
	s SaveRtn=##class(BILL.EINV.BL.COM.InvoiceCtl).SaveVoidInvResult(InputPam_"^"_IUDADMType)
	q:SaveRtn'="0" ErrCode_"^"_"保存纸质票据跳号失败."

	q ErrCode
}

/// 4.6.2.2	开票点数据核对接口（查询某一段时间一个开票点编码(收费员编码)对账数据）
/// 4.6.2.6	根据开票日期获取开票点数据核对接口
/// 入参：InputPam   （busDate业务日期^placeCode开票点编码^isReturnList是否返回列表^pageNo页码^pageSize每页条数）
/// 出参：成功：0^成功   失败： -1^
/// 编写：guoyunlong
/// 时间：2019-09-29 
/// /// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic). DLEInvBillAcList("")
ClassMethod DLEInvBillAcList(InputPam As %String) As %String
{
	s ErrCode="-1"  ;错误代码
	
	s busDate=$p(InputPam,"^",1)         ;业务日期
	s placeCode=$p(InputPam,"^",2)       ;开票点编码
	s busType=$p(InputPam,"^",3)         ;业务标识
	s isReturnList=$p(InputPam,"^",4)    ;是否返回列表(0:不返回，1:返回，空:返回)
	s pageNo=$p(InputPam,"^",5)          ;页码(传入值为1代表第一页,传入值为2代表第二页,依此类推
	//.默认返回的数据是从第一页开始；第二次传入的页码计算由返回值中的总条数/每页条数)
	s pageSize=$p(InputPam,"^",6)  ;每页条数(每页返回最多返回200条)
	s DateFlag=$p(InputPam,"^",7)        //根据时间标志判断是根据业务时间查询还是根据开票时间查询
	
	s:DateFlag="" DateFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","DateFlag",5)
	q:(busDate="")||(placeCode="")||(pageNo="")||(pageSize="") ErrCode
	//1.电子发票服务商基本配置信息获取
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(RtnConfig'="1") ErrCode_"^获取电子发票服务配置失败."
	;2.获取调用类名、方法名
	
	//业务处理配置信息你获取 +dongkf 2019 09 30
	if DateFlag="1"  d
	.s PathCode="checkDataByPlace"          //4.6.2.2	开票点数据核对接口
	else  d
	.s PathCode="checkDataPlaceByIvcDate"  //4.6.2.6	根据开票日期获取开票点数据核对接口
	
	s ObjInvLogicPath=""
	s LogicPathFlg=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetInvLogicPath(PathCode, ObjConfig.FactoryCode, .ObjInvLogicPath)  ;获取业务处理配置信息
	q:LogicPathFlg'="0" "-9999"
	s ClassName=ObjInvLogicPath.IUPClassName     ;类方法
	s MethodName=ObjInvLogicPath.IUPMethodName
	q:(ClassName="")||(MethodName="") "-9999^未配置开票接口类"	;未配置Adapter类
	//3.调用Adapter层类方法
	s ObjCheckData=##class(BILL.EINV.DTO.COM.CheckData).%New()  ;交易对象
	s SerciceRtn=$ZOBJCLASSMETHOD(ClassName,MethodName,InputPam,.ObjCheckData, ObjConfig,DateFlag)
	q:SerciceRtn'="0" ErrCode_"^"_"调用服务失败."
	
	//4.服务成功后,保存交易结果
	s SaveRtn=##class(BILL.EINV.BL.COM.InvoiceCtl).SaveDLDataResult(ObjCheckData, ObjConfig,DateFlag)
	q:SaveRtn'="0" ErrCode_"^"_"保存对账数据失败."
	
	s ErrCode="0"
	q ErrCode_"^成功"

	q ErrCode
}

/// 4.6.2.1	根据业务日期获取总笔数核对接口()
/// 4.6.2.5	根据开票日期获取总笔数核对接口
/// 入参：InputPam   （busDate业务日期^isReturnList是否返回列表^pageNo页码^pageSize每页条数）
/// 出参：成功：0^成功   失败： -1^ 
/// 编写：guoyunlong
/// 时间：2019-09-29
///       xubaobao 2019 10 10 更改  
/// w ##class(BILL.EINV.BL.EInvoiceLogic).DLEInvBillList("2019-10-09^1^1^200")
ClassMethod DLEInvBillList(InputPam As %String) As %String
{
	s ErrCode="-1"  ;错误代码
	s busDate=$p(InputPam,"^",1)       ;业务日期
	s busType=$p(InputPam,"^",2)	   ;业务标识
	s placeCode=$p(InputPam,"^",3)	   ;开票点编码
	s isReturnList=$p(InputPam,"^",4)  ;是否返回列表(0:不返回，1:返回，空:返回)
	s pageNo=$p(InputPam,"^",5)        ;页码(传入值为1代表第一页,传入值为2代表第二页,依此类推
	//.默认返回的数据是从第一页开始；第二次传入的页码计算由返回值中的总条数/每页条数)
	s pageSize=$p(InputPam,"^",6)  ;每页条数(每页返回最多返回200条)
	s DateFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","DateFlag",5)  ;  用于区分时间格式（1-业务时间，2-开票时间）
	q:(busDate="")||(pageNo="")||(pageSize="") ErrCode
	//业务日期格式转换YYYY-MM-DD
	s $p(InputPam,"^",1)=$zd(##class(websys.Conversions).DateHtmlToLogical(busDate), 3)
	
	//1.电子发票服务商基本配置信息获取
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:RtnConfig'="1" ErrCode_"^获取电子发票服务配置失败."
	
	
	s PathCode="checkTotalData"            //4.6.2.1	总笔数核对接口
	
	
	s ObjInvLogicPath=""
	s LogicPathFlg=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetInvLogicPath(PathCode, ObjConfig.FactoryCode, .ObjInvLogicPath)  ;获取业务处理配置信息
	q:LogicPathFlg'="0" "-9999"
	s ClassName=ObjInvLogicPath.IUPClassName     ;类方法
	s MethodName=ObjInvLogicPath.IUPMethodName
	q:(ClassName="")||(MethodName="") "-9999^未配置开票接口类"	;未配置Adapter类
	
	do{
		//3.调用Adapter层类方法
		s ObjCheckData=##class(BILL.EINV.DTO.COM.CheckData).%New()  ;交易对象
		s SerciceRtn=$ZOBJCLASSMETHOD(ClassName,MethodName,InputPam,.ObjCheckData,ObjConfig,DateFlag)
		;q:SerciceRtn'="0" ErrCode_"^"_"调用服务失败."
	
		//4.服务成功后,保存交易结果
		s SaveRtn=##class(BILL.EINV.BL.COM.InvoiceCtl).SaveDLDataResult(ObjCheckData,ObjConfig,DateFlag)
		;q:SaveRtn'="0" ErrCode_"^"_"保存对账数据失败."
		s $p(InputPam,"^",3)=+$p(InputPam,"^",3)+1
	}while ObjCheckData.CopyNum\pageSize>0,SerciceRtn=0,SaveRtn=0
	
	
	q:SerciceRtn'="0" ErrCode_"^"_"调用服务失败."
	q:SaveRtn'="0" ErrCode_"^"_"保存对账数据失败."
	
	s ErrCode="0"
	;q ErrCode_"^成功"

	q ErrCode
}

/// 4.6.2.4	根据业务时间获取开票信息接口
/// 4.6.2.8	根据开票日期获取开票信息接口
/// 入参：InputPam   （busDate业务日期^isReturnList是否返回列表^pageNo页码^pageSize每页条数）
/// 出参：成功：0^成功   失败： -1^ 
/// 编写：guoyunlong
/// 时间：2019-09-29 
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).DLEInvBillMXList("") 
ClassMethod DLEInvBillMXList(InputPam As %String) As %String
{
	s ErrCode="-1"  ;错误代码
	s busBgnDate=$p(InputPam,"^",1)      ;业务起始日期
	s busEndDate=$p(InputPam,"^",2)  ;业务截止日期
	s placeCode=$p(InputPam,"^",3)       ;开票点编码
	s dataType=$p(InputPam,"^",4)  ;数据类型
	s pageNo=$p(InputPam,"^",5)      ;页码
	s pageSize=$p(InputPam,"^",6)  ;每页条数
	s DateFlag=$p(InputPam,"^",7)  ;时间标志  （1-业务时间，2-开票时间）
	
	q:(busBgnDate="")||(busEndDate="")||(pageNo="")||(pageSize="") ErrCode
	
	//业务日期格式转换yyyyMMddHHmmssSSS
	s $p(InputPam,"^",1)=$replace($zd(##class(websys.Conversions).DateHtmlToLogical(busBgnDate),3),"-","")_"000000000"
	s $p(InputPam,"^",2)=$replace($zd(##class(websys.Conversions).DateHtmlToLogical(busEndDate),3),"-","")_"000000000"
	s:(placeCode'="") $p(InputPam,"^",3)=$p($g(^SSU("SSUSR",placeCode)),"^",1)
	//1.电子发票服务商基本配置信息获取
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(RtnConfig'=1) ErrCode_"^获取电子发票服务配置失败."
	
	//业务处理配置信息你获取 +dongkf 2019 09 30
	if DateFlag=1  d
	.s PathCode="BillBalance"        //4.6.2.4	根据业务时间获取开票信息接口
	else  if DateFlag=2  d
	.s PathCode="getBillByIvcDate"   //4.6.2.8	根据开票日期获取开票信息接口
	s ObjInvLogicPath=""
	s LogicPathFlg=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetInvLogicPath(PathCode, ObjConfig.FactoryCode, .ObjInvLogicPath)  ;获取业务处理配置信息
	q:(LogicPathFlg'=0) "-9999"
	s ClassName=ObjInvLogicPath.IUPClassName     ;类方法
	s MethodName=ObjInvLogicPath.IUPMethodName
	q:(ClassName="")||(MethodName="") "-9999^未配置开票接口类"	;未配置Adapter类
	
	do{
		//3.调用Adapter层类方法
		s ObjCheckData=##class(BILL.EINV.DTO.COM.CheckData).%New()  ;交易对象
		s SerciceRtn=$ZOBJCLASSMETHOD(ClassName,MethodName,InputPam,.ObjCheckData,ObjConfig,DateFlag)
		;q:SerciceRtn'="0" ErrCode_"^"_"调用服务失败."
	
		//4.服务成功后,保存交易结果
		b ;ObjCheckData.InvBillNoList.Size
		s SaveRtn=##class(BILL.EINV.BL.COM.InvoiceCtl).SaveDLMXDataResult(ObjCheckData, ObjConfig,DateFlag)
		;q:$p(SaveRtn,"^",1)'="0" ErrCode_"^"_"保存对账数据失败."
		
		s $p(InputPam,"^",5)=+$p(InputPam,"^",5)+1
	}while ObjCheckData.InvBillNoList.Size\pageSize>0,SerciceRtn=0,SaveRtn=0
	
	q:SerciceRtn'="0" ErrCode_"^"_"调用服务失败."
	q:($p(SaveRtn,"^",1)'=0) ErrCode_"^"_"保存对账数据失败."
	
	s ErrCode=SaveRtn
	q ErrCode
}

/// 功能：作废空白纸质发票，同步HIs作废发票和博思作废发票
/// 入参：InputPam=UserID：操作员ID
///                Group: 安全组
///                StPaperNo：作废开始号段
///                CancleReason: 作废原因
///                EndPaperNo：作废结束号段
///                CancelNum：作废数量
///                endInvNo: 结束发票号
///                title:
///                admReason: 费别ID
///                receiptType: 收费类型
///                Hospital: 院区
///      pBillBatchCode:第三方纸质票据代码
///  返回值：rtn->0 成功  其他失败
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).ValidPaper("") 
ClassMethod ValidPaper(InputPam As %String, pBillBatchCode As %String) As %String
{
	s rtn="-1"
	q:$p(InputPam,"^",1)="" rtn_"^"_"操作员不能为空"
	;q:$p(InputPam,"^",2)="" rtn_"^"_"安全组不能为空"
	q:$p(InputPam,"^",3)="" rtn_"^"_"开始发票号不能为空"
	q:$p(InputPam,"^",4)="" rtn_"^"_"作废原因不能为空"
	q:$p(InputPam,"^",5)="" rtn_"^"_"结束发票号不能为空"
	q:$p(InputPam,"^",6)="" rtn_"^"_"作废数量不能为空"
	q:$p(InputPam,"^",10)="" rtn_"^"_"就诊类型不能为空"
	s HospId=$p(InputPam,"^",11)
	q:(HospId="") rtn_"^"_"院区不能为空"
	
	;就诊类型和票据类型做一个对照
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig(HospId, .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(RtnConfig'=1) ErrCode_"^获取电子发票服务配置失败."
	;获取空白纸质作废票据配置0:先作废HIs的票据，在调用第三方的作废发票   1:调用第三方作废票据  2:只作废 HIs的票据
	;s Flag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("ValidPaper_Flag", 4)
	s Flag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case", "ValidPaper_Flag", 5)
	s:(Flag="") Flag="0"
	
	;0-先调用第三方的作废发票 再作废HIs的票据
	if Flag="0" d
	.s InputStr=$p(InputPam,"^",1)_"^"_pBillBatchCode_"^"_$p(InputPam,"^",3)_"^"_$p(InputPam,"^",5)_"^"_$p(InputPam,"^",4)
	.s rtn=##class(BILL.EINV.ADP.BSA).InvalidBlankInv(InputStr, ObjConfig)
	.q:(rtn'="0")
	.;InputPam=收费员ID^纸质票据代码^起始纸质票据号^终止纸质票据号^作废原因^作废张数^票据类型
	.s Input=$p(InputPam,"^",1)_"^"_pBillBatchCode_"^"_$p(InputPam,"^",3)_"^"_$p(InputPam,"^",5)_"^"_$p(InputPam,"^",4)_"^"_$p(InputPam,"^",6)_"^"_$p(InputPam,"^",10)
	.s rtn=##class(BILL.EINV.BL.EInvoiceLogic).SaveValidAndUpdateInvoice(Input)
	
	/*
	.;s rtn= ##class(web.DHCBillSkipInvoice).SkipInvoice(InputPam) ;调用HIs作废发票接口
	.;InputPam=收费员ID^纸质票据代码^起始纸质票据号^终止纸质票据号^作废原因^作废张数^票据类型
	.s Input=$p(InputPam,"^",1)_"^"_pBillBatchCode_"^"_$p(InputPam,"^",3)_"^"_$p(InputPam,"^",5)_"^"_$p(InputPam,"^",4)_"^"_$p(InputPam,"^",6)_"^"_$p(InputPam,"^",10)
	.s rtn=##class(BILL.EINV.BL.EInvoiceLogic).SaveValidAndUpdateInvoice(Input)
	.if (rtn="0")  d
	..;调用博思接口作废空白纸质票据
	..;InputPam(收费员ID^纸质票据代码^起始纸质票据号^终止纸质票据号^作废原因...)
	..s InputStr=$p(InputPam,"^",1)_"^"_pBillBatchCode_"^"_$p(InputPam,"^",3)_"^"_$p(InputPam,"^",5)_"^"_$p(InputPam,"^",4)
	..;调用adp层
	..s Srtn=##class(BILL.EINV.ADP.BSA).InvalidBlankInv(InputStr, ObjConfig)
	..i (Srtn="0") d
	...;调用第三方成功之后在发票发放表增加同步标志
	...s OutMessage=""
	...s InStr=$p(InputPam,"^",1)_"^"_$p(InputPam,"^",10)
    ...;获取当前收费员的当前可用发票的发放表ID
    ...s PaPerInfo=##class(BILL.EINV.BL.EInvoiceLogic).GetPaperBillNo(InStr)
    ...q:$p(PaPerInfo,"^",1)="-1" 
    ...s rowID=$p(OutMessage,"^",2)
	...s rtn=##class(BILL.EINV.BL.EInvoiceLogic).UpdateInvoiceFlag(rowID)
	*/
	
	;1-调用第三方作废票据
	;直接调用第三方作废空白纸质票据
	if (Flag="1") d
	.s InputData=$p(InputPam,"^",1)_"^"_pBillBatchCode_"^"_$p(InputPam,"^",3)_"^"_$p(InputPam,"^",5)_"^"_$p(InputPam,"^",4)
	.s rtn=##class(BILL.EINV.BL.EInvoiceLogic).InvalidBlankBillNo(InputData, "InvalidBlankInv")
	
	;2只作废his的发票
	if (Flag="2") d
	.s StrInput=$p(InputPam,"^",1)_"^"_pBillBatchCode_"^"_$p(InputPam,"^",3)_"^"_$p(InputPam,"^",5)_"^"_$p(InputPam,"^",4)_"^"_$p(InputPam,"^",6)_"^"_$p(InputPam,"^",10)
	.s rtn=##class(BILL.EINV.BL.EInvoiceLogic).SaveValidAndUpdateInvoice(StrInput)
	
	q rtn
}

/// 获取HIS当前纸质票据可用号码(DHC_INVOICE)
/// 入参说明：InputData -->  操作员^票据类型^安全组^费别^院区…… 
///           OutMsg      -->  错误信息
/// 返 回 值：票据号码
/// w ##class(BILL.EINV.BL.EInvoiceLogic).GetPaperBillNo("102^PO^^")
/// w ##class(BILL.EINV.BL.EInvoiceLogic).GetPaperBillNo("102^PI^^")
ClassMethod GetPaperBillNo(InputData As %String) As %String
{
	s rtnFlag="-1^^"
	s UserID=$p(InputData,"^",1)			;操作员ID
	s PrtInvType=$p(InputData,"^",2)		;票据类型
	s GroupDr=$p(InputData,"^",3)			;安全组
	s AdmreasonDr=$p(InputData,"^",4)		;费别
	s HospitalDr=$p(InputData,"^",5)		;院区
	
	q:(UserID="")||(PrtInvType="") "-1^入参错误,请检查^"
	
	s (rowid,DHCinvoiceId,LastNum,EndInv, INVBillInvCode)=""
	f  s rowid=$o(^DHCINVOICE(0,"USER",UserID,rowid)) q:rowid=""  d
	.;s StartInv=$p(^DHCINVOICE(rowid),"^",1)     //起始号段
	.s Finalflag=$p(^DHCINVOICE(rowid),"^",7)    //启用标识
	.s Type=$p(^DHCINVOICE(rowid),"^",8) 		 //票据类型
	.s hosDr=$p(^DHCINVOICE(rowid),"^",26)       //院区指针
	.q:Finalflag'="Y"             //过滤未启用号段
	.q:Type'=PrtInvType
	.q:(hosDr'=HospitalDr)&&(HospitalDr'="")
	.s EndInv=$p(^DHCINVOICE(rowid),"^",2)     //终止号段
	.s LastNum=$p(^DHCINVOICE(rowid),"^",6)      //可用号码
	.s DHCinvoiceId=rowid
	.s INVBillInvCode=$p(^DHCINVOICE(rowid),"^",27)      //票据代码-->如果无27节点，将27节点改为17
	
	q:LastNum="" "-1^该操作员无可用票号^"
	
	s rtnFlag=LastNum_"^"_DHCinvoiceId_"^"_EndInv_"^"_INVBillInvCode
	q rtnFlag
}

/// 功能说明：将作废的纸质票号保存到跳号表中并更新发票发放表
/// 入参说明：InputPam --> 收费员ID^纸质票据代码^起始纸质票据号^终止纸质票据号^作废原因^作废张数^票据类型
/// 返 回 值：0 成功 其他代表失败
/// 修改履历：苏惠德  2019-09-29
/// w ##class(BILL.EINV.BL.EInvoiceLogic).SaveValidAndUpdateInvoice("11857^1641160^00022228^00022229^发票破损^2^EO")
ClassMethod SaveValidAndUpdateInvoice(InputPam As %String) As %String
{
	//收费员ID^纸质票据代码^起始纸质票据号^终止纸质票据号^作废原因^作废张数^票据类型
	set guser=$p(InputPam,"^",1)
	set paperCode=$p(InputPam,"^",2)
	set abortStartNo=$p(InputPam,"^",3)
	set abortEndNo=$p(InputPam,"^",4)
	set voidReason=$p(InputPam,"^",5)
	set abortNum=$p(InputPam,"^",6)
	set endInvNo=$p(InputPam,"^",4)
	set hospID=""

	set rtn=0
	quit:((abortEndNo-abortStartNo+1)'=abortNum) -4
	quit:(((abortEndNo-abortStartNo)<0)||((endInvNo-abortEndNo)<0)) -5
	
	set len=$l(endInvNo)
	for curNo=abortStartNo:1:abortEndNo  quit:(+rtn'=0)  do
	.set receiptNo=##class(web.UDHCJFBaseCommon).FormatINVNO(curNo, len)
    .kill PLIST
 	.set PLIST(2)=+$h
 	.set PLIST(3)=$p($h,",",2)
 	.set PLIST(4)=receiptNo
 	.set PLIST(6)=guser
 	.set PLIST(7)=voidReason
 	.set PLIST(11)=paperCode
 	.&SQL(INSERT INTO SQLUser.DHC_VoidInv VALUES :PLIST())
    .set rtn=SQLCODE
    s InputPam=$p(InputPam,"^",1)_"^"_$p(InputPam,"^",4)_"^"_$p(InputPam,"^",7)
    s trn=##class(BILL.EINV.BL.EInvoiceLogic).UpdateINVoice(InputPam)
	quit rtn
}

/// 更新发票发放表
/// 收费员ID^终止纸质票据号^票据类型
/// w ##class(BILL.EINV.BL.EInvoiceLogic).UpdateINVoice("7^00010002^R")
ClassMethod UpdateINVoice(InputPam As %String)
{
    s rtn="-1"
    s guser=$p(InputPam,"^",1)
    s StarInvNo=$p(InputPam,"^",2)  ;当前发票号
    s IUDADMTYpe=$p(InputPam,"^",3)
    s OutMessage=""
    s InStr=guser_"^"_IUDADMTYpe
    ;获取当前收费员的当前可用发票的结束号以及当前可用发票的发放表ID
    s PaperInfo=##class(BILL.EINV.BL.EInvoiceLogic).GetPaperBillNo(InStr)
    q:$p(PaperInfo,"^",1)="-1" rtn
    
    s endNo=$p(PaperInfo,"^",3)
    s rowID=$p(PaperInfo,"^",2)
    if (+StarInvNo=+endNo) d        //如果是最后一张领取的发票,标记为已用完
	.set rtn=##class(web.UDHCAccAddDeposit).InvToFinal(rowID, StarInvNo, $p(InputPam,"^",1), $p(InputPam,"^",3))
	else  d
	.set lastNum=##class(web.UDHCAccAddDeposit).incre(StarInvNo)
	.;更新发票发放表
    .&SQL(UPDATE SQLUser.DHC_INVOICE SET INV_LastNum=:lastNum WHERE INV_rowid=:rowID)
    .set rtn=SQLCODE
	q rtn
}

/// 更新发票发放表增加一个标志是否同步了第三方的发票作废数量
/// w ##class(BILL.EINV.BL.EInvoiceLogic).UpdateInvoiceFlag("11857^EO", "")
ClassMethod UpdateInvoiceFlag(rowID) As %String
{
    s rtn=-1
    q:(rowID="") rtn
	&SQL(UPDATE SQLUser.DHC_INVOICE SET INV_comment2="Y" WHERE INV_rowid=:rowID)
	i (SQLCODE=0) s rtn=0
	q rtn
}

/// 作废的是最后一张发票时候更新发票发放表
ClassMethod InvToFinal(rid As %String, invno As %String, usr As %String, ReceiptType As %String, Flag As %String = "") As %String
{
	  &sql(update SQLUser.DHC_INVOICE set inv_lastnum=:invno,inv_finalflag='N',INV_comment2=:Flag where inv_rowid=:rid)
	  &sql(select count(*) into :num from SQLUser.DHC_INVOICE where inv_usr=:usr and inv_type=:ReceiptType and (inv_finalflag='' or inv_finalflag is null) and inv_rowid<>'0')
	  i (num'=0)  d
	  .&sql(select min(inv_rowid) into :rowid1  from SQLUser.DHC_INVOICE where inv_usr=:usr and inv_type=:ReceiptType and (inv_finalflag='' or inv_finalflag is null) and inv_rowid<>'0')
	  .&sql(update SQLUser.DHC_INVOICE set inv_finalflag='Y' where inv_rowid=:rowid1)
	  q SQLCODE
}

/// 获取电子票据明细
/// 入参说明：InputData -->  电子票据代码^电子票据号码^电子校验码
/// 返 回 值：成功标识^票据明细
/// w ##class(BILL.EINV.BL.EInvoiceLogic).GetPaperBillNo("11857^EO", "")
ClassMethod GetBillDetailInfo(InputPam As %String) As %String
{
	s RtnFlg="-1"  
	s billBatchCode=$p(InputPam,"^",1)         ;电子票据代码
	s billNo=$p(InputPam,"^",2)      		 	;电子票据号码
	s random=$p(InputPam,"^",3)  				;电子校验码
	s ObjConfig=""
	
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(RtnConfig'=1) RtnFlg_"^获取电子发票服务配置失败."
	
	q:(billBatchCode="")||(billNo="")||(random="") RtnFlg_"^参数错误"
	
	s PathCode="getBillDetail"			;票据领取PathCode
	s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode, "I")
	s ClassName=$p(IUPConInfo,"^",1)
	s MethodName=$p(IUPConInfo,"^",2)
	q:(ClassName="")||(MethodName="") "-9999^未配置开票接口类"	;未配置Adapter类
	
	//3.调用Adapter层类方法
	s OutJsonStream=""
	s SerciceRtn=$ZOBJCLASSMETHOD(ClassName, MethodName, InputPam, ObjConfig, .OutJsonStream)
	q:(SerciceRtn'=0) RtnFlg_"^"_"调用服务失败."_OutJsonStream
	
	s ErrCode="0^"_OutJsonStream

	q ErrCode
}

/// 获取电子票据种类查询
/// 入参说明：ExpStr-->  扩展串信息
/// 返 回 值：成功标识
/// 开 发 人：苏惠德
/// w ##class(BILL.EINV.BL.EInvoiceLogic).GetEBillTypeInfo("")
ClassMethod GetEBillTypeInfo(InputPam As %String, ByRef ErrMsg As %String) As %String
{
	s ErrCode="-1"
	s ObjConfig=""
	s SaveRtn=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(SaveRtn'=1) ErrCode_"^获取电子发票服务配置失败."
	
	s PathCode="QueryEBillType"			;票据种类PathCode
	s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode, "I")
	s ClassName=$p(IUPConInfo,"^",1)
	s MethodName=$p(IUPConInfo,"^",2)
	q:(ClassName="")||(MethodName="") "-9999^未配置开票接口类"	;未配置Adapter类
	
	//3.调用Adapter层类方法
	s OutputJsonStr=""
	s SaveRtn=$ZOBJCLASSMETHOD(ClassName,MethodName, InputPam, ObjConfig, .OutputJsonStr, .ErrMsg)
	q:(SaveRtn'=0) ErrCode_"^"_"调用服务失败."
	
	s ErrCode="0^"_OutputJsonStr

	q ErrCode
}

/// 获取电子票据电子票据申请单提交
/// 入参说明：InputPam  -->  入参信息串(电子票据种类代码^电子票据种类名称^电子票据种类数量^...)申请主要信息(1票据种类^2票据种类名称^3申请数量^4开始号码^5结束号码^6申请人^7安全组^8登陆科室)
///           ApplyCommon -->申请备注信息
/// 返 回 值：成功标识
/// 开 发 人：苏惠德
/// w ##class(BILL.EINV.BL.EInvoiceLogic).InvBuyApply("320601^江苏省医疗门诊收费票据（电子）^100^^^1^1^90","财务要求。")
ClassMethod InvBuyApply(InputPam As %String, ApplyCommon As %String, ByRef ErrMsg As %String) As %String
{
	s ErrCode="-1"  ;错误代码
	s EBillTypeCode=$p(InputPam,"^",1)          ;电子票据种类代码
	s EBillTypeName=$p(InputPam,"^",2)       	;电子票据种类名称
	s EBillTypeCount=$p(InputPam,"^",3)  		;电子票据种类数量
	
	s ObjConfig=""
	s SaveRtn=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(SaveRtn'=1) ErrCode_"^"_"获取电子发票服务配置失败."
	
	q:(EBillTypeCode="")||(EBillTypeName="")||(EBillTypeCount="") ErrCode_"^参数错误"
	
	///申请前验证一下 例如同一天 同一个人对相同类型的票据是否可以多次申请  申请的号段是否已经申请过了等等。。。。。。。。。。。。。。。。。。。。。。。
   	s CheckRtn=..CheckEBillApply(InputPam, .ErrMsg)
   	q:(CheckRtn'=0) ErrCode_"^"_ErrMsg
   	
	s PathCode="EBILLApply"			;电子票据申请PathCode
	s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode,"I")
	s ClassName=$p(IUPConInfo,"^",1)
	s MethodName=$p(IUPConInfo,"^",2)
	q:(ClassName="")||(MethodName="") "-9999^未配置开票接口类"	;未配置Adapter类
	
	//3.调用Adapter层类方法
	s ObjBuyApply=##class(BILL.EINV.PO.InvBuyApply).%New()  ;购入申请对象
	s SaveRtn=$ZOBJCLASSMETHOD(ClassName, MethodName, InputPam, ApplyCommon, .ObjBuyApply, .ObjConfig, .ErrMsg)     ;把入参中需要保存的信息也 在Adp中赋值？？？？？？？？？？？？？？？？？？？？？
	q:(SaveRtn'=0) ErrCode_"^"_ErrMsg
	
	//4.服务成功后,保存交易结果
	s SaveRtn=##class(BILL.EINV.BL.COM.InvBuyApplyCtl).SaveApplyBuyData(.ObjBuyApply)  ;+dongkf 2019 12 18
	s:(SaveRtn<0) ErrMsg="申请请求发送成功,但是保存申请数据失败!"
	
	s ErrCode=SaveRtn
	q ErrCode
}

/// 获取电子票据申请单取消
/// 入参说明：InputPam  -->  撤销申请主要信息(1申请记录Dr^2操作员^3安全组^4登陆科室)????????????????????????????????
///           RevokeCommon --> 撤销申请备注 ???????????????????????????????????
/// 返 回 值：成功标识
/// 开 发 人：苏惠德
/// w ##class(BILL.EINV.BL.EInvoiceLogic).EBillApplyRevoke("","")
ClassMethod InvBuyApplyRevoke(InputPam As %String, RevokeCommon As %String, ByRef ErrMsg As %String) As %String
{
	s ErrCode="-1"  ;错误代码
	s ApplyRowid=$p(InputPam,"^",1)         	;电子票据申请单id
	
	s ObjConfig=""
	s SaveRtn=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:SaveRtn'="1" ErrCode_"^"_"获取电子发票服务配置失败."
	
	q:(ApplyRowid="") ErrCode_"^参数错误"
	
	//这里需要check 一下 当前记录是否可以撤销 入参是否正确等 
   	s CheckRtn=..CheckApplyRevoke(InputPam, .ErrMsg)
   	q:(CheckRtn'="0") ErrCode_"^"_ErrMsg

	s PathCode="StockApplyNo"			;电子票据申请单撤销PathCode
	s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode,"I")
	s ClassName=$p(IUPConInfo,"^",1)
	s MethodName=$p(IUPConInfo,"^",2)
	q:(ClassName="")||(MethodName="") "-9999^未配置开票接口类"	;未配置Adapter类
	
	//3.调用Adapter层类方法
	// 在这里打开申请记录对象？？？？？？？？？？？？
	s ObjInvBuyApply=##class(BILL.EINV.PO.InvBuyApply).%OpenId(ApplyRowid)		;打开申请表对象
	s SaveRtn=$ZOBJCLASSMETHOD(ClassName,MethodName, InputPam, RevokeCommon, .ObjInvBuyApply, .ObjConfig, .ErrMsg)   ; 需要在adp层更新申请状态为撤销状态 这里是否要调用第三方服务先获取一下 最新的状态  如果第三方 已经审核过的是不是不能再申请撤销
	q:(SaveRtn'=0) ErrCode_"^"_ErrMsg
	
	//4.服务成功后,更新交易数据
	s SaveRtn=##class(BILL.EINV.BL.COM.InvBuyApplyCtl).SaveApplyBuyData(.ObjInvBuyApply)   ;修改为统一的更新方法即可？？？？？？？？？？
	s:(SaveRtn<0) ErrMsg="撤销申请请求发送成功,但是保存数据失败!"
	
	s ErrCode=SaveRtn
	q ErrCode
}

/// 获取电子票据申请单查询
/// 入参说明：InputPam  --> 查询记录信息(1申请记录Dr^2申请人^3安全组^4登陆科室)
///           
/// 返 回 值：更新购入申请表后rowid
/// 开 发 人：苏惠德
/// w ##class(BILL.EINV.BL.EInvoiceLogic).EBillApplyRevoke("","")
ClassMethod SearchBuyApplyResult(InputPam As %String, ByRef ErrMsg As %String) As %String
{
	s ErrCode="-1"  ;错误代码
	s ApplyRowid=$p(InputPam,"^",1)         	;购入申请表id
	q:(ApplyRowid="") ErrCode_"^参数错误"

	s ObjConfig=""
	s SaveRtn=##class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(SaveRtn'="1") ErrCode_"^"_"获取电子发票服务配置失败."


	s PathCode="ApplyNoQuery"			;电子票据申请单查询PathCode
	s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode,"I")
	s ClassName=$p(IUPConInfo,"^",1)
	s MethodName=$p(IUPConInfo,"^",2)
	q:(ClassName="")||(MethodName="") "-9999^未配置开票接口类"	;未配置Adapter类
	
	//3.调用Adapter层类方法
	s ObjInvBuyApply=##class(BILL.EINV.PO.InvBuyApply).%OpenId(ApplyRowid)		;打开申请表对象
	s SaveRtn=$ZOBJCLASSMETHOD(ClassName,MethodName, InputPam, .ObjInvBuyApply, .ObjConfig, .ErrMsg)  ; 在adp中给 申请记录状态赋值 
	q:(SaveRtn'=0) ErrCode_"^"_ErrMsg
	
	//考虑下 如果查询出来是申请通过的话，是不是同时需要把 入库状态修改为待入库状态。 在这里做成一个配置
	
	//4.服务成功后,更新交易数据
	s SaveRtn=##class(BILL.EINV.BL.COM.InvBuyApplyCtl).SaveApplyBuyData(.ObjInvBuyApply)   ;修改为共通的方法？？？？？？？？
	s:(SaveRtn<0) ErrMsg="申请单查询发送成功,但是更新申请单数据失败!"
	
	s ErrCode=SaveRtn
	q ErrCode
}

/// 获取电子票据待入库列表查询
/// 入参说明：InputPam-->  暂时为空
/// 返 回 值：返回标识
/// 开 发 人：苏惠德
/// w ##class(BILL.EINV.BL.EInvoiceLogic).GetEBillTypeInfo("")
ClassMethod SearchNotStockData(InputPam As %String, ByRef ErrMsg As %String) As %String
{
	s ErrCode="-1"
	
	s ObjConfig=""
	s SaveRtn=##class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(SaveRtn'=1) ErrCode_"^"_"获取电子发票服务配置失败."
	
	s PathCode="QueryEBillWarehous"			;票据待入库PathCode
	s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode, "I")
	s ClassName=$p(IUPConInfo,"^",1)
	s MethodName=$p(IUPConInfo,"^",2)
	q:(ClassName="")||(MethodName="") "-9999^未配置开票接口类"	;未配置Adapter类
	
	//3.调用Adapter层类方法
	s ObjCheckData=##class(BILL.EINV.DTO.COM.CheckData).%New()  ;创建待入库数据对象
	s SaveRtn=$ZOBJCLASSMETHOD(ClassName, MethodName, InputPam, .ObjConfig, .ObjCheckData, .ErrMsg)   ;adp 层把第三方的待入库信息获取出来放到list中 list中的对象一定要是我们自己的对象 不能直接用第三方返回的对象
	q:(SaveRtn'=0) ErrCode_"^"_ErrMsg
	
	//根据第三方的放回结果 查看我们的申请记录的待入库状态是否已经更新，仅仅更新不一致的记录，有更新的记录 返回具体的更新数目
	s CountIdx=##class(BILL.EINV.BL.COM.InvBuyApplyCtl).JudgeEBillStatus(InputPam, .ObjCheckData, .ErrMsg)
	q:(CountIdx<0) ErrCode_"^"_ErrMsg
	
	q ErrCode
}

/// 获取电子票据库存入库
/// 入参说明：InputPam  --> 入库主要信息(1申请记录Dr^2申请人^3安全组^4登陆科室)
/// 返 回 值：成功标识
/// 开 发 人：苏惠德
/// w ##class(BILL.EINV.BL.EInvoiceLogic).GetEBillPurchase("")
ClassMethod SaveApplyInvResult(InputPam As %String, ByRef ErrMsg As %String) As %String
{
	s ErrCode="-1"  ;错误代码
	s ApplyRowid=$p(InputPam,"^",1)         	;购入申请表id
	q:(ApplyRowid="") ErrCode_"^参数错误"

	s ObjConfig=""
	s SaveRtn=##class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(SaveRtn'="1") ErrCode_"^"_"获取电子发票服务配置失败."
	
	s PathCode="EBILLPurchase"			;电子票据购入PathCode
	s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode,"I")
	s ClassName=$p(IUPConInfo,"^",1)
	s MethodName=$p(IUPConInfo,"^",2)
	q:((ClassName="")||(MethodName="")) "-9999^未配置开票接口类"	;未配置Adapter类
	
	// 加一个check 方法？？？？？？？？？？验证是否可以入库
	s CheckRtn=..CheckEBillIsStock(InputPam, .ErrMsg)
   	q:(CheckRtn'=0) ErrCode_"^"_ErrMsg
 
	//3.调用Adapter层类方法
	s ObjInvBuyApply=##class(BILL.EINV.PO.InvBuyApply).%OpenId(ApplyRowid)		;打开申请表对象
	s EBillBuyObj=##class(BILL.EINV.DTO.COM.EBillBuyInfo).%New()				;创建购入表对象
	s SaveRtn=$ZOBJCLASSMETHOD(ClassName, MethodName, InputPam, .ObjConfig, .EBillBuyObj, .ObjInvBuyApply, .ErrMsg)     ;申请表对象辅助 购入表逻辑对象赋值 第三方入库成功后 在adp方法中给中给申请记录 入库状态 修改状态
	q:(SaveRtn'=0) ErrCode_"^"_ErrMsg
	
	//4.服务成功后,保存交易结果
	s SaveRtn=##class(BILL.EINV.BL.COM.InvBuyApplyCtl).SaveApplyBuyData(.ObjInvBuyApply)   ; 调用共通方法 修改申请表信息
	q:(SaveRtn<0) ErrCode_"^"_"申请入库发送成功,但是更新申请单数据失败!"
	
	//5.真正的给 我们的购入表中保存数据。。。。。。
	s RtnCode=##class(BILL.EINV.BL.COM.InvBuyApplyCtl).SaveAMTMAGData(InputPam, .EBillBuyObj)
	q:(+RtnCode'=0) ErrCode_"^"_"更新his购入表数据失败!"
	
	s ErrCode=SaveRtn
	q ErrCode
}

/// 功能说明:同一个人对相同类型的票据是否可以多次申请  申请的号段是否已经申请过了等
ClassMethod CheckEBillApply(InputPam As %String, ByRef ErrMsg As %String) As %String
{
	s RtnFalg="0"
	
	q RtnFalg
}

/// 功能说明:判断当前申请单是否可以撤销
ClassMethod CheckApplyRevoke(InputPam As %String, ByRef ErrMsg As %String) As %String
{
	s RtnFalg="0"
	s ApplyRowid=$p(InputPam,"^",1)			;申请购入表id
	s InvBuyApplyObj=##class(BILL.EINV.PO.InvBuyApply).%OpenId(ApplyRowid)		;打开申请表对象
	s ApplyStatus=InvBuyApplyObj.IBAApplyStatus				;申请状态
	i (ApplyStatus'="1") d
	.s ErrMsg="该申请单状态不为已申请,无法撤销申请."
	.s RtnFalg="-1"
	s StockStatus=InvBuyApplyObj.IBAStockStatus				;票据库存状态
	i (StockStatus="9") d
	.s ErrMsg="该申请单入库状态为已撤销,无法撤销申请."
	.s RtnFalg="-1"
	
	q RtnFalg
}

/// 功能说明:验证是否可以入库
ClassMethod CheckEBillIsStock(InputPam As %String, ByRef ErrMsg As %String) As %String
{
	s RtnFalg="0"
	s ApplyRowid=$p(InputPam,"^",1)			;申请购入表id
	s InvBuyApplyObj=##class(BILL.EINV.PO.InvBuyApply).%OpenId(ApplyRowid)		;打开申请表对象
	s ApplyStatus=InvBuyApplyObj.IBAApplyStatus				;申请状态
	i (ApplyStatus'="2") d
	.s ErrMsg="该申请单状态不为已审核,无法入库操作."
	.s RtnFalg="-1"
	s StockStatus=InvBuyApplyObj.IBAStockStatus				;票据库存状态
	i (StockStatus="2") d
	.s ErrMsg="该申请单入库状态为已入库,无法重复入库操作."
	.s RtnFalg="-1"
	
	q RtnFalg
}

/// 功能说明：批量删除多余的日志信息
/// 修改履历：董科锋 2020-03-17 新做成
/// w ##class(BILL.EINV.BL.EInvoiceLogic).DelLogTast()
ClassMethod DelLogTast() As %String
{
	q ##class(BILL.EINV.BL.COM.LogInfoCtl).DelLogTast()
}

/// 获取电子票据清单总页数接口(供打印电子票据清单使用)
/// 时间:     2020 08 03
/// 开发人：  徐保保
/// 入参：	  PayAdmType    业务类型
/// 		  HISPrtRowID   发票ID
/// 出参：	  成功标识^电子票据清单总页数
/// w ##class(BILL.EINV.BL.EInvoiceLogic).GetElectBilllListTotal("", "")
ClassMethod GetElectBilllListTotal(PayAdmType As %String, HISPrtRowID As %String) As %String
{
	
	s PageNum="0"    
	q:(PayAdmType="")||(HISPrtRowID="") PageNum
	
	//根据业务类型和发票ID获取电子票据票号信息
	s EInvStr=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetEInvBillNoStr(PayAdmType,HISPrtRowID)
	q:EInvStr="" PageNum
	
	//获取服务配置信息
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:RtnConfig'="1" PageNum

	//3.调用Adapter层类方法
	s PageNum=##class(BILL.EINV.ADP.BSA).GetElectBilllListTotal(EInvStr,ObjConfig)
	q:+PageNum<0 PageNum

	q PageNum
}

/// Creator：	xubaobao
/// CreatDate：	2020 09 07
/// Desc:		根据纸质/电子票据领用号段接口获取当前票号
/// Input:		UserID(收费员ID)
/// 			billCode:票据类型(O:门诊发票类型,R:挂号发票类型,I:住院发票类型,D:住院押金类型)
///             billBatchCode:票据代码(是否纸质票据/电子票据)
/// 返 回 值：	当前票号
///           	
///           	
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).GetCurBillNoByEndInv("6497^^428111LA^43529000")
ClassMethod GetCurBillNoByEndInv(InputPam As %String) As %String
{
	s BillNo=""  ;当前票号
	s UserID=$p(InputPam,"^",1)         ;收费员人ID
	s billCode=$p(InputPam,"^",2)       ;票据类型(O:门诊发票类型,R:挂号发票类型,I:住院发票类型,D:住院押金类型)
	s billBatchCode=$p(InputPam,"^",3)  ;票据代码(是否纸质票据/电子票据)
	s EndInv=$p(InputPam,"^",4)			;结束票号
	
	q:(UserID="")||(billBatchCode="")||(EndInv="") BillNo
	
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:RtnConfig'="1" BillNo
	
	s PathCode="InvReceive"			;票据领取PathCode
	s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode,"I")
	s ClassName=$p(IUPConInfo,"^",1)
	s MethodName=$p(IUPConInfo,"^",2)
	q:(ClassName="")||(MethodName="") BillNo

	//3.调用Adapter层类方法
	s ObjValidBillNo=##class(BILL.EINV.DTO.COM.ValidBillNo).%New()  ;交易对象
	s SerciceRtn=$ZOBJCLASSMETHOD(ClassName,MethodName,InputPam,.ObjValidBillNo, ObjConfig)
	q:SerciceRtn'="0" BillNo
	
	//4.服务成功后,保存交易结果
	s BillNo=##class(BILL.EINV.BL.COM.InvoiceCtl).CheckBillNoByEndInv(EndInv,ObjValidBillNo)
	
	q BillNo
}

/// Creator：	xubaobao
/// CreatDate：	2020-10-19
/// Desc:		单位(医院)信息下载
/// 返 回 值：	单位信息 
///           	
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).GetCurBillNoByEndInv("6497^^428111LA^43529000")
ClassMethod GetHospitalInfo() As %String
{
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:RtnConfig'="1" ""
	
	s PathCode="getHospitalInfo"			;票据领取PathCode
	s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode,"I")
	s ClassName=$p(IUPConInfo,"^",1)
	s MethodName=$p(IUPConInfo,"^",2)
	q:(ClassName="")||(MethodName="") ""

	//3.调用Adapter层类方法
	s HospitalStr=$ZOBJCLASSMETHOD(ClassName,MethodName)
	
	q HospitalStr
}

/// Creator：	xubaobao
/// CreatDate：	2020-10-19
/// Desc:		单位可用项目查询
/// 返 回 值：	单位可用项目 
///           	
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).GetFeeInfo("7250")
ClassMethod GetFeeInfo(UserID) As %String
{
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:RtnConfig'="1" ""
	
	//3.调用兴财http票据查询服务请求
	s InvociePam = ##class(BILL.EINV.DTO.COM.InvocieInputPam).%New()
	i UserID'="" d
	.s InvociePam.UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)        ;操作员编码
	.s InvociePam.UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)		;操作员名称
	s InvociePam.ObjUPConfig=ObjConfig
	
	s PathCode="getFeeInfo"			;票据领取PathCode
	s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode,"I")
	s ClassName=$p(IUPConInfo,"^",1)
	s MethodName=$p(IUPConInfo,"^",2)
	q:(ClassName="")||(MethodName="") ""

	//3.调用Adapter层类方法
	s FeeInfo=$ZOBJCLASSMETHOD(ClassName,MethodName,InvociePam)
	
	q FeeInfo
}

/// Creator：	xubaobao
/// CreatDate：	2020-11-09
/// Desc:		电子票据单张下载接口
/// 返 回 值：	电子票据文件base64 
///           	
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).GetFeeInfo("7250")
ClassMethod EInvPrint(UserID, InputPam) As %String
{
	q:(UserID="")||($l(InputPam,"^")<3) ""
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:RtnConfig'="1" ""
	
	//3.调用兴财http票据查询服务请求
	s InvociePam = ##class(BILL.EINV.DTO.COM.InvocieInputPam).%New()
	i UserID'="" d
	.s InvociePam.UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)        ;操作员编码
	.s InvociePam.UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)		;操作员名称
	s InvociePam.ObjUPConfig=ObjConfig
	
	s PathCode="EInvPrint"			;票据领取PathCode
	s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode,"I")
	s ClassName=$p(IUPConInfo,"^",1)
	s MethodName=$p(IUPConInfo,"^",2)
	q:(ClassName="")||(MethodName="") ""

	//3.调用Adapter层类方法
	s EInvPrint=$ZOBJCLASSMETHOD(ClassName,MethodName,InputPam,InvociePam)
	
	q EInvPrint
}

/// Creator：	xubaobao
/// CreatDate：	2020-12-22
/// Desc:		票据号码初始化接口(同步天成)
/// InputPam:	用户ID^业务类型^院区^
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).GetFeeInfo("7250")
ClassMethod PaperStockInit(InputPam) As %String
{
	q:InputPam="" "-1"
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:RtnConfig'="1" ""
	
	//3.调用兴财http票据查询服务请求
	s InvociePam = ##class(BILL.EINV.DTO.COM.InvocieInputPam).%New()
	s UserID=$p(InputPam,"^",1)
	i UserID'="" d
	.s InvociePam.UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)        ;操作员编码
	.s InvociePam.UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)		 ;操作员名称
	s InvociePam.ObjUPConfig=ObjConfig
	
	;(mzpj门诊票据、zypj 住院票据、zzpj 自助票据、zcpj 诊查票据 zyyjj 住院预交金、zyzz 住 院自助)
	s PayAdmType=$p(InputPam,"^",2)   ;业务类型
	s $p(InputPam,"^",2)=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("InvTypeCon"_ObjConfig.FactoryCode,PayAdmType,5)

	;//获取HIS当前纸质票据可用号码(DHC_INVOICE)
	;s LogicIUDType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("BusinessToPrtInvType","P"_PayAdmType,5)
	;s InputData=UserID_"^"_LogicIUDType_"^^^^"
	;s InvStr=##class(BILL.EINV.BL.EInvoiceLogic).GetPaperBillNo(InputData)
	;q:+$p(InvStr,"^",1)<"-1"
	
	s PathCode="PaperStockInit"			;票据领取PathCode
	s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode,"I")
	s ClassName=$p(IUPConInfo,"^",1)
	s MethodName=$p(IUPConInfo,"^",2)
	q:(ClassName="")||(MethodName="") ""

	//3.调用Adapter层类方法
	s rtn=$ZOBJCLASSMETHOD(ClassName,MethodName,InputPam,InvociePam)
	
	q rtn
}

/// Creator：	xubaobao
/// CreatDate：	2020-12-31
/// Desc:		旧系统票作废(同步天成)
/// 入参:	PayAdmType  业务类型
/// 			HISPrtRowID  发票ID
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).InvalidOldSystemPaper()
ClassMethod InvalidOldPaper(PayAdmType As %String, HISPrtRowID As %String, UserID As %String) As %String
{
	q:(PayAdmType="")||(HISPrtRowID="")||(UserID="") "-1"
	
	//获取第三方参数信息
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:RtnConfig'="1" ""
	
	s InvociePam = ##class(BILL.EINV.DTO.COM.InvocieInputPam).%New()
	s InvociePam.UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)        ;操作员编码
	s InvociePam.UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)		;操作员名称
	s InvociePam.ObjUPConfig=ObjConfig
	
	//根据业务类型和发票ID获取需要作废的票据信息,此方法需要自己根据项目进行增加
	s OldInvStr=##class(BILL.EINV.BL.COM.Common).GetPOldInvInfo(PayAdmType,HISPrtRowID)
	q:OldInvStr="" "-1"
	
	s PathCode="InvalidOldPaper"			;票据领取PathCode
	s IUPConInfo=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetUploadPath(PathCode,"I")
	s ClassName=$p(IUPConInfo,"^",1)
	s MethodName=$p(IUPConInfo,"^",2)
	q:(ClassName="")||(MethodName="") ""

	//3.调用Adapter层类方法
	s rtn=$ZOBJCLASSMETHOD(ClassName,MethodName,OldInvStr,InvociePam)
	
	q rtn
}

/// 3.2.3	打印电子票据清单接口(供打印电子票据清单使用)
/// 时间:     2021-10-22
/// 开发人：  guoyunlong
/// 入参：	  PayAdmType    业务类型
/// 		  HISPrtRowID   发票ID
/// 出参：	  成功标识^电子票据清单总页数
/// w ##class(BILL.EINV.BL.EInvoiceLogic).PrintElectBilllList("IP","23682")
ClassMethod PrintElectBilllList(PayAdmType As %String, HISPrtRowID As %String) As %String
{
	s $zt="PrintElectBilllListErr"
	s ReturnData="-1"    
	q:(PayAdmType="")||(HISPrtRowID="") ReturnData
	
	//根据业务类型和发票ID获取电子票据票号信息
	s EInvStr=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetEInvBillNoStr(PayAdmType,HISPrtRowID)
	q:EInvStr="" ReturnData
	
	//获取服务配置信息
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:RtnConfig'="1" ReturnData

    ///获取电子票据清单总页数
    s PageNum=##class(BILL.EINV.BL.EInvoiceLogic).GetElectBilllListTotal(PayAdmType,HISPrtRowID)
    if (PageNum<1){
	     s ReturnData="-1^未获取到电子票据清单信息"   
	     q ReturnData
	}
    s EInvStr=EInvStr_"^"_PageNum
	b //3.调用Adapter层类方法
	s ReturnData=##class(BILL.EINV.ADP.BSA).PrintElectBilllList(EInvStr,ObjConfig)
	q ReturnData
PrintElectBilllListErr
    s $zt=""
    q -1
}

/// 3.2.3	打印电子票据接口(供打印电子票据使用)
/// 时间:     2021-10-22
/// 开发人：  guoyunlong
/// 入参：	  PayAdmType    业务类型
/// 		  HISPrtRowID   发票ID
/// 出参：	  成功标识^电子票据清单总页数
/// w ##class(BILL.EINV.BL.EInvoiceLogic).PrintElectBill("OP","4781237")
ClassMethod PrintElectBill(PayAdmType As %String, HISPrtRowID As %String) As %String
{
	s $zt="PrintElectBilllErr"
	s ReturnCode="-1"    
	q:(PayAdmType="")||(HISPrtRowID="") ReturnCode
	
	//根据业务类型和发票ID获取电子票据票号信息
	s EInvStr=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetEInvBillNoStr(PayAdmType,HISPrtRowID)
	q:EInvStr="" ReturnCode
	
	b //获取服务配置信息
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:RtnConfig'="1" ReturnCode

	b //3.调用Adapter层类方法
	s ReturnData=##class(BILL.EINV.ADP.BSA).PrintElectBill(EInvStr,ObjConfig)
	q ReturnData
PrintElectBilllErr
    s $zt=""
    q -1
}

/// 3.2.3	打印电子票据接口(供打印电子票据使用)
/// 时间:     2021-10-22
/// 开发人：  guoyunlong
/// 入参：	  PayAdmType    业务类型
/// 		  HISPrtRowID   发票ID
/// 出参：	  成功标识^电子票据清单总页数
/// w ##class(BILL.EINV.BL.EInvoiceLogic).PrintElectBill("OP","4781237")
ClassMethod PrintElectBillNew(BillBatchCode As %String, BillNo As %String, Random As %String) As %String
{
	s $zt="PrintElectBilllErr"
	s ReturnCode="-1"    
	q:(BillBatchCode="")||(BillNo="")||(Random="") ReturnCode
	s EInvStr=BillBatchCode_"^"_BillNo_"^"_Random
	b //获取服务配置信息
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:RtnConfig'="1" ReturnCode

	b //3.调用Adapter层类方法
	s ReturnData=##class(BILL.EINV.ADP.BSA).PrintElectBill(EInvStr,ObjConfig)
	q ReturnData
PrintElectBilllErr
    s $zt=""
    q -1
}

/// 功能：修改电子票据流通状态
/// 入参：InputPam  ：电子票据代码^电子票据号码
/// 出参：0-成功，其他失败
ClassMethod ReceiveArreasFlag(InputPam As %String) As %String
{
	
	s ErrCode="-1"  ;错误代码
	
	s billBatchCode=$p(InputPam,"^",1)   ;电子票据代码
	s billNo=$p(InputPam,"^",2)          ;电子票据号码
	//1.根据his票据类型对照博思票据种类代码
	q:(billBatchCode="")||(billNo="") ErrCode

	//1.电子发票服务商基本配置信息获取
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:RtnConfig'="1" ErrCode_"^获取电子发票服务配置失败."
	
	//业务处理配置信息你获取 +dongkf 2019 09 30
	s ObjInvLogicPath=""
	s PathCode="ArreasFeedBack"
	s LogicPathFlg=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetInvLogicPath(PathCode, ObjConfig.FactoryCode, .ObjInvLogicPath)  ;获取业务处理配置信息
	q:LogicPathFlg'="0" "-9999"
	s ClassName=ObjInvLogicPath.IUPClassName     ;类方法
	s MethodName=ObjInvLogicPath.IUPMethodName	
	q:(ClassName="")||(MethodName="") "-9999"  ;"-9999^未配置开票接口类"	;未配置Adapter类
	//3.调用Adapter层类方法
	s ObjPaperBillNo=##class(BILL.EINV.DTO.COM.PaperBillNo).%New()  ;交易对象
	s SerciceRtn=$ZOBJCLASSMETHOD(ClassName,MethodName,InputPam, ObjConfig)
	b ;;;SerciceRtn
	q:SerciceRtn'="0" ErrCode_"^"_"调用服务失败."
	s ErrCode= "0"
	q ErrCode
}

/// 根据时间获取电子发票信息
/// 适用于浙江舟山税歌电子发票日报数据上传
/// w ##class(BILL.EINV.ADP.TBTCB).UPDailyReport("","") 
ClassMethod UPDailyReport(IUDStDate As %String, IUDEdDate As %String) As %String
{
   s nornum=0,noramt=0,strikenum=0,strikeamt=0,NormalStrsum="",StrikeStrsum=""
   //q:(IUDStDate="")||(IUDEdDate="") $$$OK	
   k ^TEMPEINVNorm("0")
   k ^TEMPEINVStrike("0")
   s:IUDStDate="" IUDStDate=+$h-1,IUDEdDate=+$h
	//获取上传成功的发票业务信息
    s IUDStDate=##class(websys.Conversions).DateHtmlToLogical(IUDStDate)
    s IUDEdDate=##class(websys.Conversions).DateHtmlToLogical(IUDEdDate)
    for date=IUDStDate:1:IUDEdDate  d
    .s IUDID="",nornum="",strikenum=""
    .for  s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxIvcDate",date,IUDID)) q:IUDID=""  d
    ..s ObjIUDInfo=$g(^BILL.EINV.PO.InvUpDetailsD(IUDID))    ;##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID)
    ..s IUDUplodeFlag=$lg(ObjIUDInfo,8)  ;ObjIUDInfo.IUDUplodeFlag  			    ;上传标志（Y:上传成功，N:上传失败）
    ..q:IUDUplodeFlag'="Y"    
    ..s EInvFlg=$lg(ObjIUDInfo,40)                                  ;过滤上传成功的
    ..s IUDCreatAmt=$lg(ObjIUDInfo,17)     ;ObjIUDInfo.IUDCreatAmt 						;开票金额
    ..i ((EInvFlg="I")||(EInvFlg="B")) d
    ...s nornum=nornum+1
    ...i $d(^TEMPEINVNorm("0",date))  d
    ....s ^TEMPEINVNorm("0",date)=nornum_"^"_($p($g(^TEMPEINVNorm("0",date)),"^",2)+IUDCreatAmt)
    ...else  d
    ....s ^TEMPEINVNorm("0",date)=nornum_"^"_IUDCreatAmt
    ..else  d
    ...s strikenum=strikenum+1
    ...i $d(^TEMPEINVStrike("0",date))  d
     ....s ^TEMPEINVStrike("0",date)=strikenum_"^"_($p($g(^TEMPEINVStrike("0",date)),"^",2)+IUDCreatAmt)
    ...else  d
    ....s ^TEMPEINVStrike("0",date)=strikenum_"^"_IUDCreatAmt
    
    s normDate=""
    for  s normDate=$o(^TEMPEINVNorm("0",normDate)) q:normDate=""  d
       .s normalData=$g(^TEMPEINVNorm("0",normDate))
       .s nnum=$p(normalData,"^",1)
       .s namt=$p(normalData,"^",2)
       .i NormalStrsum="" d
       ..s NormalStrsum=$tr($zd(normDate,3),"-","")_"^"_nnum_"^"_namt
       .else  d
       ..s NormalStrsum=NormalStrsum_"$"_$tr($zd(normDate,3),"-","")_"^"_nnum_"^"_namt
    
	s StrikeDate=""
    for  s StrikeDate=$o(^TEMPEINVStrike("0",StrikeDate)) q:StrikeDate=""  d
       .s strikeData=$g(^TEMPEINVStrike("0",StrikeDate))
       .s snum=$p(strikeData,"^",1)
       .s samt=$p(strikeData,"^",2)
       .i StrikeStrsum="" d
       ..s StrikeStrsum=$tr($zd(StrikeDate,3),"-","")_"^"_snum_"^"_samt
       .else  d
       ..s StrikeStrsum=StrikeStrsum_"$"_$tr($zd(StrikeDate,3),"-",2)_"^"_snum_"^"_samt
    b ;StrikeStrsum
    q NormalStrsum_"#"_StrikeStrsum
}

/// 4.6.2.9	    接收核对总笔数接口
/// 4.6.2.10	接收退费核对数据接口
/// 4.6.2.11	接收业务时间开票信息接口
/// 入参：InputPam   （busDate业务日期^isReturnList是否返回列表^pageNo页码^pageSize每页条数）
/// 出参：成功：0^成功   失败： -1^ 
/// 编写：guoyunlong
/// 时间：2022-09-29 
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).ReceiveBillByBusDate("") 
ClassMethod ReceiveBillByBusDate(InputPam As %String) As %String
{
	s ErrCode="-1"  ;错误代码
	s busBgnDate=$p(InputPam,"^",1)      ;开票日期
	s busEndDate=$p(InputPam,"^",2)      ;截止日期
	s placeCode=$p(InputPam,"^",3)       ;开票点编码
	s dataType=$p(InputPam,"^",4)  ;数据类型
	s busType=$p(InputPam,"^",5)	;业务标识
	s pageNo=$p(InputPam,"^",6)      ;页码
	s pageSize=$p(InputPam,"^",7)  ;每页条数
	
	q:(busBgnDate="")||(busEndDate'="")||(pageNo="")||(pageSize="") ErrCode
	
	//业务日期格式转换yyyyMMddHHmmssSSS
	s $p(InputPam,"^",1)=$replace($zd(##class(websys.Conversions).DateHtmlToLogical(busBgnDate),3),"-","")_"000000000"
	s:(placeCode'="") $p(InputPam,"^",3)=$p($g(^SSU("SSUSR",placeCode)),"^",1)
	//1.电子发票服务商基本配置信息获取
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(RtnConfig'=1) ErrCode_"^获取电子发票服务配置失败."
	
	//业务处理配置信息你获取 +dongkf 2019 09 30
	s PathCode="getBillByIvcDate"
	s ObjInvLogicPath=""
	s LogicPathFlg=##class(BILL.EINV.BL.COM.InvLogicPathCtl).GetInvLogicPath(PathCode, ObjConfig.FactoryCode, .ObjInvLogicPath)  ;获取业务处理配置信息
	q:(LogicPathFlg'=0) "-9999"
	s ClassName=ObjInvLogicPath.IUPClassName     ;类方法
	s MethodName=ObjInvLogicPath.IUPMethodName
	q:(ClassName="")||(MethodName="") "-9999^未配置开票接口类"	;未配置Adapter类
	
	//3.调用Adapter层类方法
	s ObjCheckData=##class(BILL.EINV.DTO.COM.CheckData).%New()  ;交易对象
	s SerciceRtn=$ZOBJCLASSMETHOD(ClassName,MethodName,InputPam,.ObjCheckData,ObjConfig)
	q:SerciceRtn'="0" ErrCode_"^"_"调用服务失败."
	s ErrCode="0"
	q ErrCode
}

/// 博思v2.0版本回调接口，返回开票信息
ClassMethod ReceiveCallBack(InputJson As %GlobalCharacterStream) As %String
{
	s ReceiveCallFlag="-1"
	q:InputJson.Read()="" ReceiveCallFlag
	d InputJson.Rewind()
	d ##class(ext.util.JsonObject).JSONStreamToObject(InputJson,.ResultObj,"")
	s Rtn=ResultObj.result
	s OutJsonStream=##class(web.Util.Encryption).Base64Decode(ResultObj.message,"UTF8")
	if (Rtn="S0000") {
		 s ReceiceReqObj=##class(BILL.EINV.DTO.BSB.EInvReceiceReq).%New()
	     s ResultStream=##class(%GlobalCharacterStream).%New()
	     d ResultStream.Write(OutJsonStream)
	     d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.ReceiceReqObj,"")
		 s BusNo=ReceiceReqObj.busNo
		 ///Index IdxBusinessNo On IUDBusNo As Exact;
		 s ID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxBusinessNo", BusNo, ""),-1)
	     q:ID="" ReceiveCallFlag
	     s ObjInvUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(ID)
		 s ObjInvUpDetail.IUDBillBatchCode=ReceiceReqObj.invoiceInfo.invoiceCode		;电子票据代码
	     s ObjInvUpDetail.IUDBillBatchNo=ReceiceReqObj.invoiceInfo.invoiceNum			    	;电子票据号码
	     s ObjInvUpDetail.IUDCheckCode=ReceiceReqObj.invoiceInfo.checkCode					;电子校验码
	     s ObjInvUpDetail.IUDCreatDate=$zdh(ReceiceReqObj.invoiceInfo.invoiceDate,3)				;电子票据生成日期
	     s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;;电子票据生成时间
         s ObjInvUpDetail.IUDBillBatchStatus=ReceiceReqObj.invoiceInfo.issueState
	     ;+dongkf 2020-04-02 start
	     s ObjInvUpDetail.EinvprtNo=ReceiceReqObj.invoiceInfo.invoiceCode_ReceiceReqObj.invoiceInfo.invoiceNum  ;发票编码+发票号码
	     s ObjInvUpDetail.Xstr1=ReceiceReqObj.busNo      ;流水号
	     s ObjInvUpDetail.IUDUplodeFlag="Y"
	     s ObjInvUpDetail.EInvFlg="I"
	     s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	     //保存交易结果
	     s InvociePam=##class(BILL.EINV.DTO.COM.InvocieInputPam).%New()
	     s InvociePam.PathCode=ObjInvUpDetail.IUDUploadPathCode
	     s UpdRtn=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).SaveServiceResult(ObjInvUpDetail, InvociePam)
	     if (UpdRtn'="0"){
		   s ReceFlag=-1_"^"_"保存开票结果信息失败."
	      }else{
		     s ReceFlag="0" 
		  } 
	}
	q ReceFlag
}

/// 清除电子发票流水表、对帐表数据,    --------上线后不允许使用
/// 2022-11-16
/// Debug: w ##class(BILL.EINV.BL.EInvoiceLogic).ClearEInvData() 
ClassMethod ClearEInvData() As %String
{
	///清数据
	k ^BILL.EINV.PO.InvUpDetailsD
	k ^BILL.EINV.PO.MedicalEInvInfoD
	k ^BILL.EINV.PO.HISBalanceDayD
	k ^BILL.EINV.PO.BalanceDayD
	k ^BILL.EINV.PO.BalanceDetailsD
	k ^BILL.EINV.PO.BalanceSubDayD
	k ^BILL.EINV.PO.BLDataUpDetailsD
	k ^BILL.EINV.PO.CenterDifferEinvD
	k ^BILL.EINV.PO.CenterEInvInfoD
	k ^BILL.EINV.PO.HisDifferEinvD
	k ^BILL.EINV.PO.InvPrintDetailsD
	k ^BILL.EINV.PO.LogInfoD
	
	///清索引
	k ^BILL.EINV.PO.InvUpDetailsI
	k ^BILL.EINV.PO.MedicalEInvInfoI
	k ^BILL.EINV.PO.HISBalanceDayI
	k ^BILL.EINV.PO.BalanceDayI
	k ^BILL.EINV.PO.BalanceDetailsI
	k ^BILL.EINV.PO.BalanceSubDayI
	k ^BILL.EINV.PO.BLDataUpDetailsI
	k ^BILL.EINV.PO.CenterDifferEinvI
	k ^BILL.EINV.PO.CenterEInvInfoI
	k ^BILL.EINV.PO.HisDifferEinvI
	k ^BILL.EINV.PO.InvPrintDetailsI
	k ^BILL.EINV.PO.LogInfoI
	q 0
}

}
