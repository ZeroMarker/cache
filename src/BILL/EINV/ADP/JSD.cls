Class BILL.EINV.ADP.JSD Extends %RegisteredObject
{

/// 江苏宿迁钟吾电子发票接口，ADP层组织接口参数（江苏百旺）	
/// 功能说明：调用开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：guoyunlong   2020-05-24  新做成         
/// 其    他：w ##class(BILL.EINV.ADP.JSB).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	s InputJson=..InvoiceCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:InputJson="" RtnFlag   ;组织入参发生错误
	
	s Message=InputJson									;业务入参
	s outData=##class(BILL.EINV.BI.JSD.HTTPRequest).InvoiceRequest(Message, InvociePam.ObjUPConfig,.RtnFlag)	;调用江苏启航开创软件http接口
    q:RtnFlag="-1" ""
    s OutJsonStream=""
    s ResponseData=##class(BILL.EINV.DTO.JSD.EInvInvoiceRes).%New()
    s Rtn=..DecryptionResult(outData,OutJsonStream,ResponseData)
	if (Rtn="0") {
		 s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail,ResponseData)
		
	}else{
		 s ObjInvUpDetail.IUDResultCode=Rtn                ;错误信息编码
		 s ObjInvUpDetail.IUDResultMeg=OutJsonStream     ;错误信息描述
		 s InvociePam.ErrMsgInfo=OutJsonStream
		 s RtnFlag="-1"
	}
	q RtnFlag
}

/// 功能说明：根据不同的业务类型分别调用不同冲红接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：guoyunlong   2020-05-24  
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invalid("","","") 
ClassMethod Invalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	;接口服务名称
	s InputJson=..InvalidCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:InputJson="" RtnFlag 
	
	s Message=InputJson									;业务入参
	s outData=##class(BILL.EINV.BI.JSB.HTTPRequest).InvoiceRequest(Message, InvociePam.ObjUPConfig)	;调用http接口
	s OutJsonStream=""
    s ResponseData=##class(BILL.EINV.DTO.JSB.EInvInvoiceRes).%New()
    s Rtn=..DecryptionResult(outData,OutJsonStream,ResponseData)     ;对返回结果进行解密
	if (Rtn="00000") {
		s RtnFlag=..SetInvResultOfInvalid(ObjInvUpDetail,OutJsonStream)  ;;把红冲开票结果信息保存到交易表
	}else{
		//s ObjInvUpDetail.IUDResultCode=Rtn                	;错误信息编码
		//s ObjInvUpDetail.IUDResultMeg=OutJsonStream     	;错误信息描述
		//s InvociePam.ErrMsgInfo=OutJsonStream
		s RtnFlag="-1"
		//s RtnFlag="0"
	}
	//开票成功的情况下, 调用服务接口获取开票状态
	if (RtnFlag="0"){ 
		;如果开具成功，开始调用查询交易查询开票状态
		s InputJson=..QueryCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam,ResponseData)
		q:InputJson="" "-1"   ;组织入参发生错误
		s QueryoutData=##class(BILL.EINV.BI.JSB.HTTPRequest).InvoiceRequest(Message, InvociePam.ObjUPConfig)	;调用吾爱科技http接口
        s OutJsonStream=""
        s ResponseData=##class(BILL.EINV.DTO.JSB.EInvInvoiceRes).%New()
        s Rtn=..DecryptionResult(outData,OutJsonStream,ResponseData)
		 ;获取开票状态(01：开票成功 04：冲红成功)	
		if ResponseData."invoice_status"'="04" {
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}
	}
	q RtnFlag
}

/// 功能说明：调用服务接口获取开具服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：guoyunlong   2020-05-24 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).GetInvStatusOfInvoice("","","") 
ClassMethod GetInvStatusOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ResponseData As BILL.EINV.DTO.JSB.EInvInvoiceRes) As %String
{
	s RtnFlag="-1"
	
	s InputJson=..QueryCom(ObjInvUpDetail,ObjInvPrtInfo, InvociePam,ResponseData)
    q:InputJson="" RtnFlag 
	s Message=InputJson									;业务入参
	
	//调用http接口
	s outData=##class(BILL.EINV.BI.JSB.HTTPRequest).InvoiceRequest( Message, InvociePam.ObjUPConfig)	
	//对返回结果进行解密并保存
	s OutJsonStream=""
	s ResponseData=##class(BILL.EINV.DTO.JSB.EInvInvoiceRes).%New()
    s Rtn=..DecryptionResult(outData,OutJsonStream,ResponseData)     ;对返回结果进行解密 
	i Rtn="00000"  d 
	.s ObjInvUpDetail.IUDBillBatchName=ResponseData.billName			;电子票据种类名称
	.s ObjInvUpDetail.IUDBillBatchStatus=ResponseData."invoice_status"			;状态
	.s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	.s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	.s ObjInvUpDetail.EInvFlg="I"										;发票状态
	
	.;+zzw 2020 01 03 start 票据号码信息保存
	.s:ObjInvUpDetail.IUDBillBatchCode="" ObjInvUpDetail.IUDBillBatchCode=ResponseData."invoice_code"	;电子票据代码
	.s:ObjInvUpDetail.IUDBillBatchNo="" ObjInvUpDetail.IUDBillBatchNo=ResponseData."invoice_number"		;电子票据号码
	.s:ObjInvUpDetail.IUDCheckCode="" ObjInvUpDetail.IUDCheckCode=ResponseData.random					;电子校验码
	.s:ObjInvUpDetail.IUDCreatDate="" ObjInvUpDetail.IUDCreatDate=$p($h,",",1)							;电子票据生成日期
	.s:ObjInvUpDetail.IUDCreatTime="" ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;电子票据生成时间
	.;+zzw 2020 01 03 end
	.s ObjInvUpDetail.IUDResultCode=Rtn   ;查询状态 信息是否成功
	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn="00000") s RtnFlag=0
	e   s RtnFlag="-1"
	
	q RtnFlag
}

/// 组织开具接口参数
ClassMethod InvoiceCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
   s rtn=""
   //票据信息
   s invobj=##class(BILL.EINV.DTO.JSD.EInvoiceReq).%New()
   s invobj.accesstoken=""    ;用户token
   s invobj.serviceKey=""     ;	应用接口
   s invDataObj=##class(BILL.EINV.DTO.JSD.EInvoiceData).%New()
   s invDataObj.dataresources="API"   ;	数据源，固定参数 “API”
   s invDataObj.nsrsbh=""       ;销售方纳税人识别号
   s invDataObj.ordernum=""     ;业务单据号；必须是唯一的（不能超过45位）
   s invDataObj.bmbbbh=""      ;税收编码版本号，参数“32.0”，具体值请询问提供商	32.0
   s invDataObj.skph=""        ;税控盘号（使用税控盒子必填，API接口填空字符串即可）
   s invDataObj.zsfs=""        ;征税方式 0：普通征税 1: 减按计增 2：差额征税
   s invDataObj.tspz="00"       ;特殊票种标识:“00”=正常票种,“02”=农产品收购	
   s invDataObj.xsfnsrsbh=""    ;销售方纳税人识别号
   s invDataObj.xsfmc=""        ;销售方名称
   s invDataObj.xsfdzdh=""      ;销售方地址、电话
   s invDataObj.xsfyhzh=""      ;销售方开户行名称与银行账号
   s invDataObj.gmfnsrsbh=""    ;购买方纳税人识别号(税务总局规定企业用户为必填项)
   s invDataObj.gmfmc=ObjInvPrtInfo.PatBaseInfo.PatName       ;购买方名称
   s invDataObj.gmfdzdh=ObjInvPrtInfo.PatBaseInfo.PatName      ;购买方地址、电话
   s invDataObj.gmfyhzh=""     ;购买方开户行名称与银行账号
   s invDataObj.kpr=InvociePam.UserDesc        ;开票人(长度20)
   s invDataObj.skr=ObjInvPrtInfo.BusUserDesc        ;收款人(长度16)
   s invDataObj.fhr=ObjInvPrtInfo.BusUserDesc        ;复核人(长度16)
   s invDataObj.yfpdm=""       ;原发票代码
   s invDataObj.yfphm=""       ;原发票号码
   ;价税合计;单位：元（2位小数） 价税合计=合计金额(不含税)+合计税额 
   ;注意：不能使用商品的单价、数量、税率、税额来进行累加，最后四舍五入，只能是总合计金额+合计税额
   s invDataObj.jshj=ObjInvPrtInfo.InvShareAmt       
   s invDataObj.hjje=ObjInvPrtInfo.InvShareAmt     ;合计金额 注意：不含税，单位：元(2位小数)
   s invDataObj.hjse="0"    ;合计税额单位：元（2位小数）z
   s invDataObj.kce=""     ;扣除额小数点后2位，当ZSFS为2时扣除额为必填项
   s invDataObj.bz=""     ;备注长度应减去”对应正数发票代码:XXXXXXXXXXXX号码:YYYYYYYY\n”字样长度，长度剩余140
   s invDataObj.jffphone=ObjInvPrtInfo.PatBaseInfo.Mobphone   ;手机号
   s invDataObj.jffemail=ObjInvPrtInfo.PatBaseInfo.PatEmail  ;电子邮件
   s invDataObj.noticeurl=""  ;回传开票(待使用)
   
   for mxIndex=1:1:ObjInvPrtInfo.InvItmDetInfo.Size()  d
   .s invDataXMXXObj=##class(BILL.EINV.DTO.JSD.EInvoiceDataXMXX).%New()
   .s invDataXMXXObj.fphxz="0"    ;发票行性质 0正常行、1折扣行、2被折扣行
   .s invDataXMXXObj.spbm=""      ;商品编码(商品编码为税务总局颁发的19位税控编码)  ????怎么传
   .s invDataXMXXObj.zxbm=""      ;自行编码(一般不建议使用自行编码)
   .s invDataXMXXObj.yhzcbs="0"    ;优惠政策标识 0：不使用，1：使用
   .s invDataXMXXObj.lslbs="3"     ;零税率标识 空：非零税率， 1：免税，2：不征收，3普通零税率   ?????测试与医院确定一下
   .s invDataXMXXObj.zzstsgl=""   ;增值税特殊管理-如果yhzcbs为1时，此项必填
   .s invDataXMXXObj.xmmc=ObjInvPrtInfo.InvItmDetInfo.GetAt(mxIndex).TarDesc      ;项目名称 ,必须与商品编码表一致
   .s invDataXMXXObj.ggxh=ObjInvPrtInfo.InvItmDetInfo.GetAt(mxIndex).Spec      ;规格型号(折扣行请不要传)
   .s invDataXMXXObj.dw=ObjInvPrtInfo.InvItmDetInfo.GetAt(mxIndex).Unit        ;计量单位(折扣行请不要传)
   .s invDataXMXXObj.xmsl=ObjInvPrtInfo.InvItmDetInfo.GetAt(mxIndex).Qty     ;项目数量,大于0的数字
   .s invDataXMXXObj.xmdj=ObjInvPrtInfo.InvItmDetInfo.GetAt(mxIndex).Price      ;项目单价 ,注意：单价是含税单价,大于0的数字，小数点后六位
   .s invDataXMXXObj.xmje=ObjInvPrtInfo.InvItmDetInfo.GetAt(mxIndex).Amt     ;项目金额 注意：金额是含税，单位：元（2位小数）
   .s invDataXMXXObj.sl="0"       ;税率 例6%为0.06
   .s invDataXMXXObj.se="0"       ;税额 单位：元（2位小数）
   .d invDataObj.commonfpkjxmxx.Insert(invDataXMXXObj)
    s invobj.data=invDataObj
   
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read()
	
	q rtn
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, OutPutJsonStr As %String) As %String
{
	s RtnFlg="-1"
	
	//对返回结果的时间戳进行分割
	s OutJsonStr={}.%FormJson(OutPutJsonStr)
	s ResultCode=OutJsonStr.%Get("code")
	s ResultMsg=OutJsonStr.%Get("msg")
	s ResultResult=OutJsonStr.%Get("result")
	s ResultRows=OutJsonStr.%Get("rows").%Get(0)
	
	
	s createDate=ResultRows.%Get("kprq")						;返回日期"20190528 135131"
	s createDate=$zdh($e(createDate,1,8),8)
	s createTime=$zth($e(createDate,9,14),8)
	s ObjInvUpDetail.IUDResultCode=ResultCode					;处理结果代码
	s ObjInvUpDetail.IUDResultMeg=ResultMsg				;详细信息
	s ObjInvUpDetail.IUDCreatDate=createDate							;电子票据生成日期
	s ObjInvUpDetail.IUDBillBatchCode=ResultRows.%Get("fp_dm")      ;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultRows.%Get("fp_hm")     ;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=ResultRows.%Get("jym")                ;校验码
	s ObjInvUpDetail.IUDPictureUrl=ResultRows.%Get("img_down_url")		;电子票据H5页面URL
	s ObjInvUpDetail.IUDBillBatchName=ResultRows.%Get("kprq")    ;开票单位名称
	s ObjInvUpDetail.IUDBillBatchStatus=ResultRows.%Get("kprq")    ;开票状态
	s ObjInvUpDetail.IUDBusNo=ResultRows.%Get("fpqqlsh")        ;开票流水号
	s ObjInvUpDetail.IUDBillPictureData=ResultRows.%Get("pdf_down_url")    ;该张发票pdf流，直接下载
	s ObjInvUpDetail.Xstr1=ResultRows.%Get("qpm")              ;取票码（很重要， 一定要妥善保存）
    s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"										;发票状态
	s RtnFlg="0"
	q RtnFlg
}

/// 功能说明：设置红票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ResultMegObj As BILL.EINV.DTO.JSC.EInvolidRes) As %String
{
	s RtnFlg="-1"
	
	//对返回结果的时间戳进行分割
	s createDate=ResultMegObj.BODY.RCPTLIST.issuedate						;返回日期"20191217"
	s createDate=$zdh(createDate,8)
	s ObjInvUpDetail.IUDResultCode=ResultMegObj.BODY.CLBZ					;处理结果代码
	s ObjInvUpDetail.IUDResultMeg=ResultMegObj.BODY.CLJG				;详细信息
	s ObjInvUpDetail.IUDCreatDate=createDate							;电子票据生成日期
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.BODY.RCPTLIST.invoicecode      ;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.BODY.RCPTLIST.invoicenumber     ;电子票据号码
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.BODY.RCPTLIST.invoiceurl		;电子票据H5页面URL
	s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.BODY.RCPTLIST.invoicestatus    ;开票状态
    s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="红冲成功"   						;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"										;发票状态
	s RtnFlg="0"
	
	q RtnFlg
}

/// 查询状态
ClassMethod QueryCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ResponseData As BILL.EINV.DTO.JSC.EInvInvoiceRes) As %String
{
	s rtn=""
   //票据信息
   s invobj=##class(BILL.EINV.DTO.JSD.EInvQueryOnlyReq).%New()
   s invobj.accesstoken=""    ;用户token
   s invobj.serviceKey=""     ;应用接口
   s invDataobj=##class(BILL.EINV.DTO.JSD.EInvQueryOnlyData).%New()
   s invDataobj.ordernum=""   ;业务单据号；必须是唯一的 
   s invDataobj.nsrsbh=""     ;销售方纳税人识别号
   s invDataobj.fpdm=""       ;发票代码
   s invDataobj.fphm=""       ;发票号码
   s invDataobj.jym=""        ;校验码
   s invobj.data=invDataobj
   //调用固定方法进行对象转Json
   s Stream=##class(%GlobalCharacterStream).%New()
   d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
   s rtn=Stream.Read()
   q rtn
}

/// 组织红冲接口参数
ClassMethod InvalidCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
   s rtn=""
   //票据信息
   s invobj=##class(BILL.EINV.DTO.JSD.EInvalidReq).%New()
   s invobj.accesstoken=""    ;用户token
   s invobj.serviceKey=""     ;应用接口
   s invDataobj=##class(BILL.EINV.DTO.JSD.EInvalidData).%New()
   s invDataobj.dataresources="API"   ;数据源，固定参数 “API”
   s invDataobj.nsrsbh=""     ;销售方纳税人识别号
   s invDataobj.ordernum=""   ;业务单据号；必须是唯一的（不能超过45位）
   s invDataobj.skph=""       ;税控盘号（使用税控盒子必填，其他设备为空）
   s invDataobj.kpr=InvociePam.UserDesc        ;开票人
   s invDataobj.skr=ObjInvPrtInfo.BusUserDesc       ;收款人
   s invDataobj.fhr=ObjInvPrtInfo.BusUserDesc      ;复核人
   s invDataobj.yfpdm=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode      ;原发票代码
   s invDataobj.yfphm=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo      ;原发票号码
   s invDataobj.bz=""         ;备注长度应减去”对应正数发票代码:XXXXXXXXXXXX号码:YYYYYYYY\n”字样长度，长度剩余140
   s invobj.data=invDataobj
   
   //调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read()
	
	q rtn
}

/// 功能说明： 对第三方返回的json加密数据进行解析
/// w ##class(BILL.EINV.ADP.JSC).DecryptionResult("","")
ClassMethod DecryptionResult(Response, ByRef ErrMsg As %String, ByRef ResultObj As BILL.EINV.DTO.JSC.EInvInvoiceRes) As %String
{
	s Rtn="-1"
	s ResultStream=##class(%GlobalCharacterStream).%New()
	d ResultStream.Write(Response)
	d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.ResultObj,"")
	s Rtn=ResultObj.BODY.CLBZ
	s ErrMsg=ResultObj.BODY.CLJG
	q Rtn
}

}
