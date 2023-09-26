Class BILL.EINV.DTO.COM.InvUpDetailInfo Extends %RegisteredObject
{

Property RowId As %Date(CAPTION = "交易表ID");

Property IUDDate As %Date(CAPTION = "上传日期");

Property IUDTime As %Time(CAPTION = "上传时间");

Property IUDInvDr As %String(CAPTION = "发票表指针");

Property IUDUser As %String(CAPTION = "上传人");

Property IUDBusNo As %String(CAPTION = "业务流水号");

/// 票据业务类型(IP:住院发票，OP:门诊发票，API:集中打印发票,OT:门诊跳号发票(空白作废发票)，IT:住院跳号发票(空白作废发票))
Property IUDPayAdmType As %String(CAPTION = "票据业务类型");

/// 上传标志 Y:上传成功，N:上传失败
Property IUDUplodeFlag As %String(CAPTION = "上传标志");

Property IUDBatchNo As %String(CAPTION = "批次号");

Property IUDResultCode As %String(CAPTION = "返回结果代码");

Property IUDResultMeg As %String(CAPTION = "返回结果信息");

Property IUDBillBatchCode As %String(CAPTION = "票据代码");

Property IUDBillBatchNo As %String(CAPTION = "票据号码");

Property IUDHospDr As %String(CAPTION = "院区指针");

Property IUDCreatDate As %Date(CAPTION = "开票日期");

Property IUDCreatTime As %Time(CAPTION = "开票时间");

Property IUDCreatAmt As %String(CAPTION = "开票金额");

Property IUDAcceptid As %String(CAPTION = "受理号");

/// 是否打印纸质票据(0未打印，1已打印)
Property IUDPrintFlag As %String(CAPTION = "是否打印纸质票据");

/// 生成状态(0未生成、1已生成、2失败 )
Property IUDRateStatus As %String(CAPTION = "生成状态");

Property IUDCheckCode As %String(CAPTION = "校验码");

Property IUDBillQRCode As %String(CAPTION = "电子票据二维码图片数据", MAXLEN = 3000);

Property IUDBillBatchName As %String(CAPTION = "电子票据种类名称");

/// 电子票据状态(状态：1正常，2作废)
Property IUDBillBatchStatus As %String(CAPTION = "电子票据状态");

Property IUDPrtDate As %Date(CAPTION = "发票日期");

Property IUDPrtTime As %Time(CAPTION = "发票时间");

/// 是否已开红票(0未开红票，1已开红票)
Property IUDBillisScarlet As %String(CAPTION = "是否已开红票");

Property IUDBillPictureData As %String(CAPTION = "电子票据图片内容", MAXLEN = 3000);

/// 票据种类 V-增值税发票 C-普票
Property IUDStyle As %String(CAPTION = "票据种类");

/// 票据模式 E-电子票据 P-纸质发票
Property IUDPrintType As %String(CAPTION = "票据模式");

/// 换票（包含电子换纸质）原业务表指向
Property IUDInitDr As %String(CAPTION = "换票");

Property TradeCode As %String(CAPTION = "业务类型");

/// 申请路径代码 DHCInvUploadPath表
Property IUDUploadPathCode As %String(CAPTION = "申请路径代码");

/// 电子票据H5页面URL
Property IUDPictureUrl As %String(CAPTION = "电子票据H5页面URL", MAXLEN = 2000);

/// 电子票据服务名
Property IUDServiceCode As %String(CAPTION = "电子票据服务名");

/// 原交易表指针
Property IUDInitRowID As %String(CAPTION = "原交易表指针");

/// 预交金凭证代码
Property IUDVoucherBatchCode As %String(CAPTION = "预交金凭证代码");

/// 预交金凭证号码
Property IUDVoucherNo As %String(CAPTION = "预交金凭证号码");

/// 预交金凭证校验码
Property IUDVoucherRandom As %String(CAPTION = "预交金凭证校验码");

/// 原记录交易对象
Property OriInvUpDetail As BILL.EINV.PO.InvUpDetails(CAPTION = "原记录交易对象");

/// I 正常开具 B 被冲红 S 冲红 H 已换开
Property EInvFlg As %String(CAPTION = "发票标志");

/// 票据类型
Property PrtInvType As %String(CAPTION = "票据类型");

Property Xstr1 As %String(CAPTION = "扩展字段1");

Property Xstr2 As %String(CAPTION = "扩展字段2", MAXLEN = 2000);

Property Xstr3 As %String(CAPTION = "扩展字段3");

Property Xstr4 As %String(CAPTION = "扩展字段4");

Property Xstr5 As %String(CAPTION = "扩展字段5");

/// 发票编码+发票号码
Property EinvprtNo As %String(CAPTION = "发票号码");

/// add by xubaobao 2020 10 15 赛通港联接口返回
Property IUDEInvLSH As %String(CAPTION = "开票信息ID");

/// 功能说明：通过实体类对象(BILL.EINV.PO.InvUpDetails)给逻辑类对象赋值
/// 入参说明: ObjInvUpDetails    --> 交易对象
/// 修改履历：苏惠德   2019-09-17   
/// 其    他：
Method SetValues(ObjInvUpDetails As BILL.EINV.PO.InvUpDetails) As %Status
{
	s ..RowId=ObjInvUpDetails.%Id()									;;电子票据id	
	s ..IUDDate=ObjInvUpDetails.IUDDate								;上传日期
	s ..IUDTime=ObjInvUpDetails.IUDTime								;上传时间
	s ..IUDInvDr=ObjInvUpDetails.IUDInvDr							;发票表指针
	s ..IUDUser=ObjInvUpDetails.IUDUser								;上传人
	s ..IUDBusNo=ObjInvUpDetails.IUDBusNo							;业务流水号
	s ..IUDPayAdmType=ObjInvUpDetails.IUDPayAdmType					;票据类型
	s ..IUDUplodeFlag=ObjInvUpDetails.IUDUplodeFlag					;上传标志
	s ..IUDBatchNo=ObjInvUpDetails.IUDBatchNo						;批次号
	s ..IUDHospDr=ObjInvUpDetails.IUDHospDr							;院区指针
	s ..IUDCreatAmt=ObjInvUpDetails.IUDCreatAmt						;开票金额
	s ..IUDAcceptid=ObjInvUpDetails.IUDAcceptid						;受理号
	s ..IUDPrtDate=ObjInvUpDetails.IUDPrtDate						;发票日期
	s ..IUDPrtTime=ObjInvUpDetails.IUDPrtTime						;发票时间
	s ..IUDStyle=ObjInvUpDetails.IUDStyle							;票据种类 V-增值税发票 C-普票
	s ..IUDPrintType=ObjInvUpDetails.IUDPrintType					;票据模式
	s ..IUDUploadPathCode=ObjInvUpDetails.IUDUploadPathCode			;申请路径代码							
	s ..IUDBillBatchCode=ObjInvUpDetails.IUDBillBatchCode			;电子票据代码
	s ..IUDBillBatchNo=ObjInvUpDetails.IUDBillBatchNo				;电子票据号码
	s ..IUDResultCode=ObjInvUpDetails.IUDResultCode					;结果代码
	s ..IUDResultMeg=ObjInvUpDetails.IUDResultMeg					;结果描述
	s ..IUDCreatDate=ObjInvUpDetails.IUDCreatDate					;开票日期
	s ..IUDCreatTime=ObjInvUpDetails.IUDCreatTime					;开票时间
	s ..IUDPrintFlag=ObjInvUpDetails.IUDPrintFlag					;是否打印纸质票据
	s ..IUDRateStatus=ObjInvUpDetails.IUDRateStatus					;生成状态
	s ..IUDCheckCode=ObjInvUpDetails.IUDCheckCode					;校验码
	s ..IUDBillQRCode=ObjInvUpDetails.IUDBillQRCode					;电子票据二维码图片数据
	s ..IUDBillBatchName=ObjInvUpDetails.IUDBillBatchName			;电子票据种类名称
	s ..IUDBillBatchStatus=ObjInvUpDetails.IUDBillBatchStatus		;电子票据状态
	s ..IUDBillisScarlet=ObjInvUpDetails.IUDBillisScarlet			;是否已开红票
	s ..IUDInitDr=ObjInvUpDetails.IUDInitDr							;换票（包含电子换纸质）原业务表指向
	s ..IUDPictureUrl=ObjInvUpDetails.IUDPictureUrl					;电子票据H5页面URL
	s ..IUDServiceCode=ObjInvUpDetails.IUDServiceCode				;电子票据接口服务名
	s ..IUDInitRowID=ObjInvUpDetails.IUDInitRowID					;原交易表指针
	s ..IUDVoucherBatchCode=ObjInvUpDetails.IUDVoucherBatchCode		;预交金凭证代码
	s ..IUDVoucherNo=ObjInvUpDetails.IUDVoucherNo					;预交金凭证号码
	s ..IUDVoucherRandom=ObjInvUpDetails.IUDVoucherRandom			;预交金凭证校验码
	s ..EInvFlg=ObjInvUpDetails.EInvFlg                             ;发票标志 I 正常开具 B 被冲红 S 冲红 H 已换开
	if ObjInvUpDetails.IUDInitRowID'="" do
	.s ObjInv=##class(BILL.EINV.PO.InvUpDetails).%OpenId(ObjInvUpDetails.IUDInitRowID)
	.;add by xubaobao 2021 10 28 如果是换开或者重新换开业务，此处取电子票据对象
	.i (ObjInvUpDetails.IUDUploadPathCode="PrintPaper")||(ObjInvUpDetails.IUDUploadPathCode="RePrintPaper") d
	..s ObjInv=##class(BILL.EINV.PO.InvUpDetails).%OpenId(ObjInvUpDetails.IUDInitDr)	
	.s ..OriInvUpDetail=ObjInv
	
	;增加扩展字段 xubaobao 2019 12 12
	s ..Xstr1=ObjInvUpDetails.Xstr1
	s ..Xstr2=ObjInvUpDetails.Xstr2
	s ..Xstr3=ObjInvUpDetails.Xstr3
	s ..Xstr4=ObjInvUpDetails.Xstr4
	s ..Xstr5=ObjInvUpDetails.Xstr5
	
	s ..EinvprtNo=ObjInvUpDetails.EinvprtNo   ;发票编码+发票号码 +dongkf 2020 04 02
	s ..IUDEInvLSH=ObjInvUpDetails.IUDEInvLSH	;add by xubaobao 2020 10 15 赛通港联接口返回

	q $$$OK
}

/// 功能说明：转为实体对象(表对象)
/// 返 回 值：实体类对象
/// 修改履历：苏惠德   2019-09-17   
/// 其    他： 
Method ToInvUpDetails() As BILL.EINV.PO.InvUpDetails
{
	b ;00
	s rowid=..RowId
	i rowid="" d
	.s objInv=##class(BILL.EINV.PO.InvUpDetails).%New()
	e  d
	.s objInv=##class(BILL.EINV.PO.InvUpDetails).%OpenId(rowid)
	
	s objInv.IUDDate=..IUDDate								;上传日期
	s objInv.IUDTime=..IUDTime								;上传时间
	s objInv.IUDInvDr=..IUDInvDr							;发票表指针
	s objInv.IUDUser=..IUDUser								;上传人
	s objInv.IUDBusNo=..IUDBusNo							;业务流水号
	s objInv.IUDPayAdmType=..IUDPayAdmType					;票据类型
	s objInv.IUDUplodeFlag=..IUDUplodeFlag					;上传标志
	s objInv.IUDBatchNo=..IUDBatchNo						;批次号
	s objInv.IUDHospDr=..IUDHospDr							;院区指针
	s objInv.IUDCreatAmt=..IUDCreatAmt						;开票金额
	s objInv.IUDAcceptid=..IUDAcceptid						;受理号
	s objInv.IUDPrtDate=..IUDPrtDate						;发票日期
	s objInv.IUDPrtTime=..IUDPrtTime						;发票时间
	s objInv.IUDStyle=..IUDStyle							;票据种类 V-增值税发票 C-普票
	s objInv.IUDPrintType=..IUDPrintType					;票据模式
	s objInv.IUDUploadPathCode=..IUDUploadPathCode			;申请路径代码							
	s objInv.IUDBillBatchCode=..IUDBillBatchCode			;电子票据代码
	s objInv.IUDBillBatchNo=..IUDBillBatchNo				;电子票据号码
	s objInv.IUDResultCode=..IUDResultCode					;结果代码
	s objInv.IUDResultMeg=..IUDResultMeg					;结果描述
	s objInv.IUDCreatDate=..IUDCreatDate					;开票日期
	s objInv.IUDCreatTime=..IUDCreatTime					;开票时间
	s objInv.IUDPrintFlag=..IUDPrintFlag					;是否打印纸质票据
	s objInv.IUDRateStatus=..IUDRateStatus					;生成状态
	s objInv.IUDCheckCode=..IUDCheckCode					;校验码
	s objInv.IUDBillQRCode=..IUDBillQRCode					;电子票据二维码图片数据
	s objInv.IUDBillBatchName=..IUDBillBatchName			;电子票据种类名称
	s objInv.IUDBillBatchStatus=..IUDBillBatchStatus		;电子票据状态
	s objInv.IUDBillisScarlet=..IUDBillisScarlet			;是否已开红票
	s objInv.IUDInitDr=..IUDInitDr							;换票（包含电子换纸质）原业务表指向
	s objInv.IUDPictureUrl=..IUDPictureUrl					;电子票据H5页面URL
	s objInv.IUDServiceCode=..IUDServiceCode				;电子票据接口服务名
	s objInv.IUDInitRowID=..IUDInitRowID					;原交易表指针
	s objInv.IUDVoucherBatchCode=..IUDVoucherBatchCode		;预交金凭证代码
	s objInv.IUDVoucherNo=..IUDVoucherNo					;预交金凭证号码
	s objInv.IUDVoucherRandom=..IUDVoucherRandom			;预交金凭证校验码
	s objInv.EInvFlg=..EInvFlg			                    ;发票标志 I 正常开具 B 被冲红 S 冲红 H 已换开
	;增加扩展字段 xubaobao 2019 12 12
	s objInv.Xstr1=..Xstr1
	s objInv.Xstr2=..Xstr2
	s objInv.Xstr3=..Xstr3
	s objInv.Xstr4=..Xstr4
	s objInv.Xstr5=..Xstr5
	
	s objInv.EinvprtNo=..EinvprtNo   ;发票编码+发票号码 +dongkf 2020 04 02
	i objInv.EinvprtNo="" d
	.s objInv.EinvprtNo=objInv.IUDBillBatchCode_objInv.IUDBillBatchNo   ;电子票据号码存储到一个字段(票据代码+票据号码)
	s objInv.IUDEInvLSH=..IUDEInvLSH	;add by xubaobao 2020 10 15 赛通港联接口返回
	
	q objInv
}

}
