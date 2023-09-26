Class BILL.EINV.DTO.BWA.TESTMode Extends %RegisteredObject
{

/// w ##class(BILL.EINV.DTO.BWA.TESTMode).TestCreateEInvMsg()
ClassMethod TestCreateEInvMsg() As %String
{
	s EInvOutMsg=##class(BILL.EINV.DTO.BWA.EInvOutMsg).%New()
	
	s EInvInMsg=##class(BILL.EINV.DTO.BWA.EInvInMsg).%New()
	s EInvInMsg.id="FPKJ"
	s EInvInMsg.comment="发票开具"
	
	s ReqComFPKJ=##class(BILL.EINV.DTO.BWA.EReqComFPKJ).%New()
	s ReqComFPKJ.class="REQUEST_COMMON_FPKJ"
	s ComFPKJFPT=##class(BILL.EINV.DTO.BWA.EComFPKJFPT).%New()
	s ComFPKJFPT.class="COMMON_FPKJ_FPT"
	s ComFPKJFPT.FPQQLSH="发票请求流水号"
	s ComFPKJFPT.ORDERID="订单号"
	s ComFPKJFPT.KPLX="开票类型"
	s ReqComFPKJ.ComFPKJFPT=ComFPKJFPT
	
	
	s ComFPKJXMMXS=##class(BILL.EINV.DTO.BWA.EComFPKJXMXXS).%New()
	s ComFPKJXMMXS.class="COMMON_FPKJ_XMXX"
	s ComFPKJXMMXS.size="2"
	
	s ComFPKJXMXX=##class(BILL.EINV.DTO.BWA.EComFPKJXMXX).%New()
	s ComFPKJXMXX.FPHXZ="发票行性质"
	s ComFPKJXMXX.SPBM="商品编码"
	d ComFPKJXMMXS.ComFPKJXMXX.Insert(ComFPKJXMXX)
	s ComFPKJXMXX1=##class(BILL.EINV.DTO.BWA.EComFPKJXMXX).%New()
	s ComFPKJXMXX1.FPHXZ="发票行性质"
	s ComFPKJXMXX1.SPBM="商品编码"
	d ComFPKJXMMXS.ComFPKJXMXX.Insert(ComFPKJXMXX1)
	
	s ReqComFPKJ.ComFPKJXMMXS=ComFPKJXMMXS
	s EInvInMsg.ReqComFPKJ=ReqComFPKJ
	
	s InputPamStream=""
	d EInvInMsg.XMLExportToStream(.InputPamStream)
	q:$isobject(InputPamStream)=0 "0"
	b ;33
	;s rtnXML=..SaveDivideByStream(DivideDataStream)
	;w InputPamStream.OutputToDevice()
	
	q ""
}

/// w ##class(BILL.EINV.DTO.BWA.TESTMode).TestSearchInvMsg()
ClassMethod TestSearchInvMsg() As %String
{
	//构建内部报文对象
	;s ObjSearchReq=##class(BILL.EINV.DTO.BWA.ESerachInvInMsg).%New()
	;s ObjSearchReq.id="10010"						;交易编号 10010 税控服务器  30012 税控盘组服务器
	;s ObjSearchReq.comment="发票查询"  			;交易描述
	
	;s ObjSearchMsgBody=##class(BILL.EINV.DTO.BWA.ESearchMsgBody).%New()
	;s ObjSearchMsgBody.yylxdm="1"					;应用类型代码
	;s ObjSearchMsgBody.kpzdbs="开票终端标识"		;开票终端标识
	;s ObjSearchMsgBody.fplxdm="发票类型代码"		;发票类型代码 “004”增值税专用发票 “007”增值税普通发票 “025”卷式发票 “026”电子发票 “005”机动车发票 “006”二手车销售统一发票
	;s ObjSearchMsgBody.cxfs="查询方式"				;查询方式 0：按发票号码段查询 1：按时间段查询 2：按发票请求流水号查询
	;s ObjSearchMsgBody.cxtj="查询条件"				;查询条件 0:发票代码+发票起始号码+发票终止号码 1:起始日期+终止日期YYYYMMDD 2：按输入请求流水号查询
	;s ObjSearchReq.body=ObjSearchMsgBody
	
	//构建外部报文对象
	s ObjSearchReq=##class(BILL.EINV.DTO.BWA.ESearchInvOutMsg).%New()
	s ObjSearchReq.id="FPCX"
	s ObjSearchReq.comment="发票查询"
	
	s ObjBody=##class(BILL.EINV.DTO.BWA.ESearchOutMsgBody).%New()
	s ObjBody.yylxdm="1"
	
	s ObjInput=##class(BILL.EINV.DTO.BWA.ESearchMsgInput).%New()
	s ObjInput.JQBH="设备编号"                             	;设备编号
	s ObjInput.DIRECT="接口参数"                            ;接口参数 默认是1
	s ObjInput.NSRSBH="销方税号"                            ;销方税号
	s ObjInput.FPXML="内层报文"                             ;内层报文(发票上传的内层报文，需BASE64加密)
	s ObjInput.SKType="开票机器类型"						;开票机器类型 0表示税控服务器 2代表盘组服务器
	
	s ObjBody.input=ObjInput
	s ObjSearchReq.body=ObjBody
	
	s InputPamStream=""
	d ObjSearchReq.XMLExportToStream(.InputPamStream)
	q:$isobject(InputPamStream)=0 "0"
	w InputPamStream.OutputToDevice()
	
	q ""
}

}
