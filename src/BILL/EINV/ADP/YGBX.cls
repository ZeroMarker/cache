/// 阳光保险接口参数组织
Class BILL.EINV.ADP.YGBX Extends %RegisteredObject
{

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 	业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：郭云龙   2022-05-11  新做成
/// 其    他：w ##class(BILL.EINV.ADP.YGBX).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	;开具之前先查询该流水号下票据是否开具成功
	s RtnFlg="-1"	
    b //组织开具入参
	s ReqInputXml=..EInvoiceXML(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	s:ReqInputXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:ReqInputXml="" "-1"
	
	b //调用平台组接口ReqInputXml
    s ResOutput=""
    s Stream=##class(%GlobalCharacterStream).%New()
    d Stream.Write(ReqInputXml)
    //w ##class(web.DHCENS.EnsWebService).getElecInvoiceBilingDataFromZongxian(%GlobalCharacterStream)%GlobalCharacterStream
    s ResOutput=##class(web.DHCENS.EnsWebService).getElecInvoiceBilingDataFromZongxian(Stream)    //组平台接口
    b ;ResOutput
    //q:rtn'="0" "-1"
    
    ;解析返回结果 
    s rtn=..ESetInvResultOfInvoice(ObjInvUpDetail, .ResOutput)
	i $p(rtn,"^",1)'="0"  d
	.s RtnFlg="-1"
	.s InvociePam.ErrMsgInfo=$p(rtn,"^",2)
	.b ;
	else  d
	.s RtnFlg="0"
	q RtnFlg
}

/// 组织开票入参XML参数
/// 其    他：w ##class(BILL.EINV.ADP.YGBX).EInvoiceXML("","","")
ClassMethod EInvoiceXML(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	//生成内层报文
	s rtn=""
	
	s EInvoiceReq=##class(BILL.EINV.DTO.YGBX.EInvoiceReq).%New()
	s EInvoiceReq.id="FPKJ"
	s EInvoiceReq.comment="发票开具"
	s EInvoicePACKETReq=##class(BILL.EINV.DTO.YGBX.EInvoicePACKETReq).%New()
	s EInvoicePACKETReq.type="REQUEST"
	s EInvoicePACKETReq.version="1.0"
	s EInvoicePACKETMAINReq=##class(BILL.EINV.DTO.YGBX.EInvoicePACKETMAINReq).%New()
    s EInvoicePACKETMAINReq.UNITED="0"	 ///是否合并开票	VARCHAR2(50)	是	0-否 1-是
    //s EInvoicePACKETMAINPOLICYNOLISTReq=##class(BILL.EINV.DTO.YGBX.EInvoicePACKETMAINPOLICYNOLISTReq).%New()
    //s EInvoicePACKETMAINPOLICYNOLISTReq.BDH=ObjInvPrtInfo.InvItmDetInfo.GetAt(1).DetailNo	 ///	保单号	VARCHAR2(50)	是  传HIS的账单detail表的ID，多个保单号用POLICYNOLIST	
   
    s BDHStr=""
    for index=1:1:ObjInvPrtInfo.InvItmDetInfo.Size   d
    .//s EInvoicePACKETMAINPOLICYNOLISTReq=##class(BILL.EINV.DTO.YGBX.EInvoicePACKETMAINPOLICYNOLISTReq).%New()
    .//s EInvoicePACKETMAINPOLICYNOLISTReq.BDH=ObjInvPrtInfo.InvItmDetInfo.GetAt(1).DetailNo
    .//d EInvoicePACKETMAINReq.POLICYNOLIST.Insert(EInvoicePACKETMAINPOLICYNOLISTReq)
    .s BDH="<BDH>"_ObjInvPrtInfo.InvItmDetInfo.GetAt(index).DetailNo_"</BDH>"
    .if BDHStr="" d
    ..s BDHStr=BDH
    .else  d
    ..s BDHStr=BDHStr_BDH
    
    s EInvoicePACKETMAINReq.POLICYNOLIST=BDHStr   ;EInvoicePACKETMAINPOLICYNOLISTReq
    s EInvoicePACKETMAINReq.QC=""	 ///	期次	VARCHAR2(50)	否	分期开具期次号按逗号分隔,多保单号时不取该字段，直接获取所有为开票数据
    s EInvoicePACKETMAINReq.ACNTUNIT=""	 ///	归属机构	VARCHAR2(50)	否	5位财务账套代码
    s EInvoicePACKETMAINReq.PAYEENAME="山东阳光融和医院有限责任公司"	 ///机构名称	VARCHAR2(50)	否	
    s EInvoicePACKETMAINReq.TBRMC=""	 ///	投保人名称	VARCHAR2(50)	选填	需要更新时必填
    s EInvoicePACKETMAINReq.NSRSBH=""	 ///	购买方纳税人识别号	VARCHAR2(50)	选填	需要更新时必填
    s EInvoicePACKETMAINReq.GFKHDZ=ObjInvPrtInfo.PatBaseInfo.Address	 ///	购方开户地址	VARCHAR2(255)	选填	需要更新时必填
    s EInvoicePACKETMAINReq.GFLXDH=ObjInvPrtInfo.PatBaseInfo.Mobphone	 ///	购方联系电话	VARCHAR2(50)	选填	需要更新时必填
    s EInvoicePACKETMAINReq.GFKHYH=""	 ///	购方开户行名称	VARCHAR2(50)	选填	需要更新时必填
    s EInvoicePACKETMAINReq.GFYHZH=""	 ///	购方银行账户	VARCHAR2(50)	选填	需要更新时必填
    s EInvoicePACKETMAINReq.CONSUMERPHONE=ObjInvPrtInfo.PatBaseInfo.Mobphone	 ///	消费者手机号	VARCHAR2(50)	否	
    s EInvoicePACKETMAINReq.CONSUMEREMAIL=ObjInvPrtInfo.PatBaseInfo.PatEmail	 ///	消费者电子邮件	VARCHAR2(50)	否	
    s EInvoicePACKETMAINReq.XZDM=""	 ///	 险种代码 	VARCHAR2(50)	是	    
    s EInvoicePACKETMAINReq.XZMC=""	 ///	险种名称	VARCHAR2(50)	是	
    s EInvoicePACKETMAINReq.AMOUNT=ObjInvPrtInfo.InvItmDetInfo.Size	 ///	数量	VARCHAR2(50)	是	保单数量，最大为500  保单号的数量，费用明细数量
    s EInvoicePACKETMAINReq.TOTALJYJE=ObjInvPrtInfo.InvShareAmt	 ///	所有要合并的保单的总的金额	VARCHAR2(50)	是	含税金额（保费）
    s EInvoicePACKETMAINReq.FPJZ="2"	 ///	发票介质	VARCHAR2(50)	是	2表示电子发票
    s EInvoicePACKETMAINReq.MESSAGEFLAG="0"	 ///	发送消息类型	VARCHAR2(50)	是	0表示不发送总线消息，1表示发  送总线消息
    s EInvoicePACKETMAINReq.COMPANYNAME="YGRHYY"	 ///	平台名称	VARCHAR2(50)	是	
    s EInvoicePACKETMAINReq.OPERATESITE=""	 ///	保单来源渠道	VARCHAR2(50)	是	
    s EInvoicePACKETMAINReq.KPQQH=ObjInvUpDetail.IUDBusNo	 ///	开票请求号	VARCHAR2(50)	否	飞猪渠道使用
    s EInvoicePACKETMAINReq.BZ=""	 ///	备注	VARCHAR2(50)	否	备注
    
    s EInvoicePACKETReq.MAIN=EInvoicePACKETMAINReq
    s EInvoiceReq.PACKET=EInvoicePACKETReq
    s InputPamStream=""
	d EInvoiceReq.XMLExportToString(.InputPamStream)     ;生成xml字符串
	
	
	//<POLICYNOLIST><![CDATA[<BDH>225098||1||1</BDH><BDH>225098||1||2</BDH>]]></POLICYNOLIST>
	s InputPamStream5=$p(InputPamStream,"<POLICYNOLIST>",1)
	s InputPamStream1=$p(InputPamStream,"<POLICYNOLIST>",2)
	s InputPamStream2=$p(InputPamStream1,"</POLICYNOLIST>",1)
	s InputPamStream4=$p(InputPamStream1,"</POLICYNOLIST>",2)
	s InputPamStream3=$p(InputPamStream2,"<![CDATA[",2)
	s BDHStr1=$p(InputPamStream3,"]]>",1)
	s InputPamStream=InputPamStream5_"<POLICYNOLIST>"_BDHStr1_"</POLICYNOLIST>"_InputPamStream4

	
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
    
    q InputPamStream
}

/// 功能说明：设置电子票据开票结果信息到交易对象表对象中
/// 入参说明：XMLRes  --> 开票返回值XML数据
/// 返 回 值：0 成功 其他值失败
ClassMethod ESetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, XMLRes As %GlobalCharacterStream) As %String
{
	s rtn="-1"
	;使用Base64解密
	;s XMLRes=##class(web.Util.Encryption).Base64Decode(XMLRes)
	s ObjRes=##class(BILL.EINV.DTO.YGBX.EInvoiceRes).%New()
	s XMLRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(XMLRes, "business", "BILL.EINV.DTO.YGBX.EInvoiceRes", .ObjRes)
	b ;XMLRtn
	q:XMLRtn'="0" rtn
	
	s ObjInvUpDetail.IUDResultCode=ObjRes.PACKET.RETURNCODE  	;返回代码 0成功，其它失败
	s ObjInvUpDetail.IUDResultMeg=ObjRes.PACKET.RETURNMSG  		;返回信息
	q:ObjInvUpDetail.IUDResultCode'="0" "-1^"_ObjInvUpDetail.IUDResultMeg	//失败则退出
	//对返回结果的时间戳进行分割
	s createDate=$e(ObjRes.PACKET.KPRQ,1,4)_"-"_$e(ObjRes.PACKET.KPRQ,5,6)_"-"_$e(ObjRes.PACKET.KPRQ,7,8)
	s createTime=$e(ObjRes.PACKET.KPRQ,9,10)_":"_$e(ObjRes.PACKET.KPRQ,11,12)_":"_$e(ObjRes.PACKET.KPRQ,13,14)
	s ObjInvUpDetail.Xstr2=ObjRes.PACKET.UNITID                  ;发票请求流水号
	s ObjInvUpDetail.Xstr3=ObjRes.PACKET.TBRMC                     ;发票抬头                                                            ;税控设备编号
	s ObjInvUpDetail.IUDBillBatchCode=ObjRes.PACKET.FPDM	     	;发票代码
	s ObjInvUpDetail.IUDBillBatchNo=ObjRes.PACKET.FPHM		        ;发票号码
	//s ObjInvUpDetail.IUDCheckCode=ObjRes.PACKET.JYM			        ;校验码
	s ObjInvUpDetail.IUDCreatDate=$zdh(createDate,3)					;票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$zdt(createTime)						;票据生成时间
	//s ObjInvUpDetail.IUDBillQRCode=ObjRes.PACKET.EWM			    ;票据二维码	
	//s ObjInvUpDetail.Xstr4=ObjRes.PACKET.FPMW                       ;发票密文	
	s ObjInvUpDetail.IUDPrintType="E"                                   ;电子票据
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                	;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"										;发票状态	
	q "0"
}

/// 功能说明：6.4	增值税管理系统电子发票根据发票代码号码查询接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：郭云龙   2022-05-12  新做成
/// 其    他：w ##class(BILL.EINV.ADP.YGBX).EInvoiceQuery("","","")
ClassMethod EInvoiceQuery(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
    ;add  guoyunlong 2019-12-23
	;开具发票之前，先用请求流水号查询该流水号下的发票是否开具成功，成功的话直接保存发票数据
	/*s INVPRTRowid=InvociePam.HISPrtRowID
	s ConRowid=0
	f  s ConRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,ConRowid)) q:ConRowid=""  d
	.s Bill=$p(^DHCBCI(ConRowid),"^",2)
	.q:'$d(^DHCPB(Bill))
	.s Ord=0
	.f  s Ord=$o(^DHCPB(Bill,"O",Ord)) q:Ord=""  d
	..q:($d(^DHCPB(Bill,"O",Ord))=10)
	..s Itm=0
	..f  s Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) q:Itm=""  d
	...s InvItmObj=##class(BILL.EINV.DTO.COM.InvItmDetailInfo).%New()
	...s detailNo=""
	...s detailNo=Bill_"||"_Ord_"||"_Itm
	...s Price=""
	...s Price=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",4)
	...s InvItmObj.DetailNo=detailNo
	...s InvItmObj.Price=Price
	...d ObjInvPrtInfo.InvItmDetInfo.Insert(InvItmObj)*/
	s rtn="-1"
	
	//测试代码
	s ObjInvUpDetail=##class(BILL.EINV.DTO.COM.InvUpDetailInfo).%New()
	s ObjInvUpDetail.IUDBillBatchNo="00107431"      ///发票号码
	s ObjInvUpDetail.IUDBillBatchCode="111001490026"    ///发票代码
	b ;//测试代码
	
	s SearchReq=..SearchInvXMLInfo(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	s:SearchReq="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:SearchReq="" 
	
	
	s ResOutput=""
    s Stream=##class(%GlobalCharacterStream).%New()
    d Stream.Write(SearchReq)
    
    s ResOutput=##class(web.DHCENS.EnsWebService).queryElecInvoiceInfoFromZongxian(Stream)    //组平台接口
    b ;ResOutput
	s rtn=..ESetInvResultOfInvoice(ObjInvUpDetail, ResOutput)
	q:rtn'="0" // InvociePam.ErrMsgInfo="调用接口成功,保存结果失败"

    /*b //调用平台接口
	s SearchXMLRes=""
	s httpRtn=""
	b //调用平台组接口SearchReq

	//如果查询发票信息成功，并且返回值不为空，直接保存数据
	if ($p(httpRtn,"^",1)="0")&&(SearchXMLRes'="")
	 {
	  s rtn=..SearchInvResultOfInvoice(ObjInvUpDetail, SearchXMLRes)  ;把开票结果信息保存到交易表
	  s:rtn'="0" InvociePam.ErrMsgInfo="调用接口成功,返回结果失败"
	  b ;查询数据	 
	 }else{
		s InvociePam.ErrMsgInfo="调用接口失败"	 
	}
	*/
	q rtn
}

/// 税控发票信息查询返回值参数组织
/// 功能说明：设置发票查询信息到交易对象表对象中
/// 入参说明：XMLRes  --> 发票查询返回值XML数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SearchInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, XMLRes As %String)
{
	s rtn="-1"
	;s XMLRes=##class(web.Util.Encryption).Base64Decode(XMLRes)
	s ObjRes=##class(BILL.EINV.DTO.YGBX.EInvoiceQueryRes).%New()
	s XMLRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(XMLRes, "business", "BILL.EINV.DTO.YGBX.EInvoiceQueryRes", .ObjRes)
	q:XMLRtn'="0" rtn
	
	//对返回结果的时间戳进行分割
	s ObjInvUpDetail.IUDResultCode=ObjRes.PACKET.RETURNCODE  	;返回代码 0成功，其它失败
	s ObjInvUpDetail.IUDResultMeg=ObjRes.PACKET.RETURNMSG  		;返回信息
	q:ObjInvUpDetail.IUDResultCode'="0" "-1"	//失败则退出                                                  
	s ObjInvUpDetail.IUDBillBatchCode=ObjRes.PACKET.FPDM	     	;发票代码
	s ObjInvUpDetail.IUDBillBatchNo=ObjRes.PACKET.FPHM		        ;发票号码
	s ObjInvUpDetail.IUDPictureUrl=ObjRes.PACKET.PDFURL			        ;PDF地址
	q "0"									;是否打印纸质票据
}

/// 发票信息查询
/// 其    他：w ##class(BILL.EINV.ADP.YGBX).SearchInvXMLInfo()
/// 
ClassMethod SearchInvXMLInfo(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//构建报文对象
	s EInvoiceQuery=##class(BILL.EINV.DTO.YGBX.EInvoiceQueryReq).%New()
	s EInvoiceQuery.id="FPCX"
	s EInvoiceQuery.comment="发票查询"
	
	s EInvoicePACKETQuery=##class(BILL.EINV.DTO.YGBX.EInvoicePACKETQueryReq).%New()
	s EInvoicePACKETQuery.type="REQUEST"
	s EInvoicePACKETQuery.version="1.0"
	//s EInvoicePACKETQuery.BDH=ObjInvPrtInfo.InvItmDetInfo.GetAt(1).DetailNo
	s EInvoicePACKETQuery.FPHM=ObjInvUpDetail.IUDBillBatchNo      ///发票号码
	s EInvoicePACKETQuery.FPDM=ObjInvUpDetail.IUDBillBatchCode     ///发票代码
	b ;01
	s EInvoiceQuery.PACKET=EInvoicePACKETQuery
	s InputPamStream=""
	d EInvoiceQuery.XMLExportToString(.InputPamStream)       ;生成xml字符串
	q:InputPamStream="" rtn
	b ;02
	s InputPamStream=..GetXMLTitle()_InputPamStream   ;加上xml文件头数据
	
	q InputPamStream
}

/// 调用第三方接口作废纸质票据
ClassMethod EInvaild(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam)
{
    s INVPRTRowid=InvociePam.HISPrtRowID
	s ConRowid=0
	f  s ConRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,ConRowid)) q:ConRowid=""  d
	.s Bill=$p(^DHCBCI(ConRowid),"^",2)
	.q:'$d(^DHCPB(Bill))
	.s Ord=0
	.f  s Ord=$o(^DHCPB(Bill,"O",Ord)) q:Ord=""  d
	..q:($d(^DHCPB(Bill,"O",Ord))=10)
	..s Itm=0
	..f  s Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) q:Itm=""  d
	...s InvItmObj=##class(BILL.EINV.DTO.COM.InvItmDetailInfo).%New()
	...s detailNo=""
	...s detailNo=Bill_"||"_Ord_"||"_Itm
	...s Price=""
	...s Price=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",4)
	...s InvItmObj.DetailNo=detailNo
	...s InvItmObj.Price=Price
	...d ObjInvPrtInfo.InvItmDetInfo.Insert(InvItmObj)
    
    ...s rtn=""
	...s ReqInputXml=..EInvaildXML(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	...s:ReqInputXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	...q:ReqInputXml="" 
	
	...;b //调用平台接口
	...;s XMLRes=""
	...;s httpRtn=""
	...;q:$p(httpRtn,"^",1)'="0" 
    ...;s XMLRes=$p(httpRtn,"^",2)
	...;s:XMLRes="" InvociePam.ErrMsgInfo="调用接口成功,返回结果为空"
	...;q:XMLRes="" 
	
	...b //调用平台组接口
    ...s ResOutput=""
    ...s Stream=##class(%GlobalCharacterStream).%New()
    ...d Stream.Write(ReqInputXml)
    ...b ;123
    ...;下方这个方法不存在。。。。。。
    ...s ResOutput=##class(web.DHCENS.EnsWebService).getRedElecInvoiceBilingDataFromZongxian(Stream)
    ...b ;解析返回结果 
    ...s rtn=..ESetInvResultOfInvoice(ObjInvUpDetail, ResOutput)
	...q:rtn'="0" // InvociePam.ErrMsgInfo="调用接口成功,保存结果失败"
	 
	//将作废发票信息结果信息保存到交易表对象
    ...;s rtn=..ESetInvResultOfInvaild(ObjInvUpDetail, XMLRes)   ;把开票结果信息保存到交易表
	...;s:rtn'="0" InvociePam.ErrMsgInfo="调用接口成功,返回结果失败"
	b ;1123
	q rtn
}

/// 组织纸质发票作废数据XML
ClassMethod EInvaildXML(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//构建报文对象
	s ObjReq=##class(BILL.EINV.DTO.YGBX.EInvoiceQueryReq).%New()
	s ObjReq.id="FPHC"
	s ObjReq.comment="发票红冲"
	s ObjBody=##class(BILL.EINV.DTO.YGBX.EInvoicePACKETQueryRes).%New()
	s ObjBody.BDH=ObjInvPrtInfo.InvItmDetInfo.GetAt(1).DetailNo
	//s ObjBody.FPDM=ObjInvUpDetail.IUDBillBatchCode          ;发票代码
	//s ObjBody.FPHM=ObjInvUpDetail.IUDBillBatchNo             ;发票号码
	s ObjReq.PACKET=ObjBody
	s InputPamStream=""
	d ObjReq.XMLExportToString(.InputPamStream)       ;生成xml字符串
	s str0=$p(InputPamStream,"<PACKET",1)
	s str1=$p(InputPamStream,"<PACKET",2)
	s str2=$p(str1,"<BDH>",2)
	S InputPamStream=str0_"<PACKET type='REQUEST' version='1.0'><BDH>"_str2
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream   ;加上xml文件头数据
	
	q InputPamStream
}

/// 税控发票作废返回值参数
/// 功能说明：设置作废发票信息到交易对象表对象中
/// 入参说明：XMLRes  --> 作废发票返回值XML数据
/// 返 回 值：0 成功 其他值失败
ClassMethod ESetInvResultOfInvaild(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, XMLRes As %String) As %String
{
	s rtn="-1"
	b ;解析
	s rtn="-1"
	;s XMLRes=##class(web.Util.Encryption).Base64Decode(XMLRes)
	s ObjRes=##class(BILL.EINV.DTO.YGBX.EInvoiceQueryRes).%New()
	s XMLRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(XMLRes, "business", "BILL.EINV.DTO.YGBX.EInvoiceQueryRes", .ObjRes)
	q:XMLRtn'="0" rtn
	
	//对返回结果的时间戳进行分割
	s ObjInvUpDetail.IUDResultCode=ObjRes.PACKET.RETURNCODE  	;返回代码 0成功，其它失败
	s ObjInvUpDetail.IUDResultMeg=ObjRes.PACKET.RETURNMSG  		;返回信息
	q:ObjInvUpDetail.IUDResultCode'="0" "-1"	//失败则退出                                                  
	s ObjInvUpDetail.IUDBillBatchCode=ObjRes.PACKET.FPDM	     	;发票代码
	s ObjInvUpDetail.IUDBillBatchNo=ObjRes.PACKET.FPHM		        ;发票号码
	s KPRQ=ObjRes.PACKET.KPRQ			        ;PDF地址
	s createDate=$e(KPRQ,1,4)_"-"_$e(KPRQ,5,6)_"-"_$e(KPRQ,7,8)
	s createTime=$e(KPRQ,9,10)_":"_$e(KPRQ,11,12)_":"_$e(KPRQ,13,14)	
	s ObjInvUpDetail.IUDCreatDate=$zdh(createDate,3)					;票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$zth(createTime)						;票据生成时间
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                	;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="S"										;发票状态
	s ObjInvUpDetail.IUDPrintType="E"									;纸质票据
	s ObjInvUpDetail.IUDPrintFlag="1"									;是否打印纸质票据
	
	q "0"
}

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 	业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：郭云龙   2022-05-11  新做成
/// 其    他：w ##class(BILL.EINV.ADP.BSA).EInvocieUpData("","","") 
ClassMethod EInvocieUpData(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	;开具之前先查询该流水号下票据是否开具成功
	s INVPRTRowid=InvociePam.HISPrtRowID
	s ConRowid=0
	f  s ConRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,ConRowid)) q:ConRowid=""  d
	.s Bill=$p(^DHCBCI(ConRowid),"^",2)
	.q:'$d(^DHCPB(Bill))
	.s Ord=0
	.f  s Ord=$o(^DHCPB(Bill,"O",Ord)) q:Ord=""  d
	..q:($d(^DHCPB(Bill,"O",Ord))=10)
	..s Itm=0
	..f  s Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) q:Itm=""  d
	...s InvItmObj=##class(BILL.EINV.DTO.COM.InvItmDetailInfo).%New()
	...s detailNo=""
	...s detailNo=Bill_"||"_Ord_"||"_Itm
	...s Price=""
	...s Price=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	...s InvItmObj.DetailNo=detailNo
	...s InvItmObj.Price=Price
	...d ObjInvPrtInfo.InvItmDetInfo.Insert(InvItmObj)
    ...b //组织开具入参
	...s ReqInputXml=..EInvoiceUPDataXML(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	...b ;ReqInputXml
	...s:ReqInputXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	...q:ReqInputXml="" 
	
	...b //调用平台组接口ReqInputXml

	...b //调用平台组接口
    ...s ResOutput=""
    ...s Stream=##class(%GlobalCharacterStream).%New()
    ...d Stream.Write(ReqInputXml)
    ...s ResOutput=##class(web.DHCENS.EnsWebService).getOutputBilingDataFromProductInsurance(Stream)
    ...;s rtn=""     //组平台接口
    ...;q:rtn'="0" "-1"
    
    ...;解析返回结果 
    ...s rtn=..ESetInvResultOfInvoice(ObjInvUpDetail, ResOutput)
	...q:rtn'="0" // InvociePam.ErrMsgInfo="调用接口成功,保存结果失败"
	
	q rtn
}

/// 组织XML参数
ClassMethod EInvoiceUPDataXML(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	//生成内层报文
	s rtn=""
	
	s EInvoiceDataUL=##class(BILL.EINV.DTO.YGBX.EInvoiceDataUL).%New()
	
	s EInvoiceDataHeadUL=##class(BILL.EINV.DTO.YGBX.EInvoiceDataHeadUL).%New()
    s EInvoiceDataHeadUL.SystemCode=""    //系统代码
	s EInvoiceDataBodyUL=##class(BILL.EINV.DTO.YGBX.EInvoiceDataBodyUL).%New()
	s EInvoiceDataBodyInvoiceInfosUL=##class(BILL.EINV.DTO.YGBX.EInvoiceDataBodyInvoiceInfosUL).%New()
	s EInvoiceDataBodyInvoiceInfoUL=##class(BILL.EINV.DTO.YGBX.EInvoiceDataBodyInvoiceInfoUL).%New()
	
	s detailno=ObjInvPrtInfo.InvItmDetInfo.GetAt(ObjInvPrtInfo.InvItmDetInfo.Size).DetailNo

	s bill=0,ord=0,itm=0,tarid=0,tarcate=0,tardesc=0,XZDM=0,XZMC=0
	s bill=$p(detailno,"||",1)
	s ord=$p(detailno,"||",2)
	s itm=$p(detailno,"||",3)
	s tarid=$p(^DHCPB(bill,"O",ord,"D",itm),"^",3)
	s tarcate=$p(^DHCTARI(tarid),"^",14)
	s tardesc=$p(^DHCTarC("IC",tarcate),"^",2)

	if (tarcate=1) {
	s XZDM="RH8" 
	s XZMC=tardesc
	}
	if tarcate=2 {
	s XZDM="RH29" 
	s XZMC=tardesc
	}
	if tarcate=3 {
	s XZDM="RH19"
	s XZMC=tardesc
	}
	if tarcate=4 {
	s XZDM="RH11 "
	s XZMC=tardesc}
	if tarcate=5 {
	s XZDM="RH18" 
	s XZMC=tardesc}
	if tarcate=6 {
	s XZDM="RH23"
	s XZMC=tardesc}
	if (tarcate=7) {
	s XZDM="RH7" 
	s XZMC=tardesc}
	if tarcate=8 s XZDM="RH9" s XZMC=tardesc
	if tarcate=9 s XZDM="RH17" s XZMC=tardesc
	if ((tarcate=10)||(tarcate=11)) s XZDM="RH10" s XZMC="材料费"
	if tarcate=15 s XZDM="RH40",XZMC="药品费"
	if ((tarcate=12)||(tarcate=13)||(tarcate=14)) s XZDM="RH12" s XZMC="输血费"


	b ;11
	s EInvoiceDataBodyInvoiceInfoUL.JYH=detailno	///交易号()	VARCHAR2(32)	是	唯一标识 传HIS的账单detail表的ID
    s EInvoiceDataBodyInvoiceInfoUL.JYJGDM="Y0000"		///成本中心	VARCHAR2(32)	是	核心系统交易机构的成本中心
    s EInvoiceDataBodyInvoiceInfoUL.JYJGMC="山东阳光融和医院有限责任公司"		///交易机构名称	VARCHAR2(256)	是	核心系统交易机构名称
    s EInvoiceDataBodyInvoiceInfoUL.ACNTUNIT="Y0000"		///公司代码	VARCHAR2(50)	是	交易机构代码
    s EInvoiceDataBodyInvoiceInfoUL.BDH=detailno		;传HIS的账单detail表的ID///保单号	VARCHAR2(50)	是	如一个保单对应多个险种，不同险种需拆分为一条单独的数据发送
    s EInvoiceDataBodyInvoiceInfoUL.PDH=detailno		;传HIS的账单detail表的ID///批单号	VARCHAR2(50)	是	批单性质的业务，批单号码必填
    b ;2
    s EInvoiceDataBodyInvoiceInfoUL.QC=""		///期次	VARCHAR2(50)	否	付款期次
    s EInvoiceDataBodyInvoiceInfoUL.TBRBM=""		///投保人编码	VARCHAR2(50)	否	投保人编码
    s EInvoiceDataBodyInvoiceInfoUL.TBRMC=ObjInvPrtInfo.PatBaseInfo.PatName		///投保人名称	VARCHAR2(50)	是	投保人名称
    s EInvoiceDataBodyInvoiceInfoUL.NSRLX=""		///纳税人类型	VARCHAR2(50)	是	一般纳税人\小规模纳税人\个人
    s EInvoiceDataBodyInvoiceInfoUL.NSRSBH=""		///纳税人识别号	VARCHAR2(32)	否	表示投保人税务登记证上地址，和营业执照注册地址一致。开票要求为专票时，必填，其他可为空。
    s EInvoiceDataBodyInvoiceInfoUL.KPDZ=""		///开票地址	VARCHAR2(256)	否	表示投保人税务登记证上地址，和营业执照注册地址一致。开票要求为专票时，必填，其他可为空。
    s EInvoiceDataBodyInvoiceInfoUL.KPDH=""		///开票电话	VARCHAR2(32)	否	表示投保人税局预留的固定电话一致；开票要求为专票时，必填，其他可为空。
    s EInvoiceDataBodyInvoiceInfoUL.KHYH=""		///开户银行	VARCHAR2(200)	否	表示投保人开户银行，一般为投保人基本户开户行。开票要求为专票时，必填，其他可为空。
    s EInvoiceDataBodyInvoiceInfoUL.YHZH=""		///银行账号	VARCHAR2(50)	否	表示投保人银行账号，一般为基本户开户银行账号。开票要求为专票时，必填，其他可为空。
    s EInvoiceDataBodyInvoiceInfoUL.JYRQ=$zd(+$H,3)	///交易日期	DATE	是	表示业务生效且确认收入日期，YYYY-XX-XX
    s EInvoiceDataBodyInvoiceInfoUL.JYLX="医疗服务"		///交易类型	VARCHAR2(50)	是	业务系统明细交易类型，枚举：保费收入、利息收入、账户管理费收入等
    s EInvoiceDataBodyInvoiceInfoUL.XZDM=XZDM		;按收费类型和集团的表对照，开票不传///险种代码	VARCHAR2(50)	是	交易类型为保费收入的，必填，否则可为空
    s EInvoiceDataBodyInvoiceInfoUL.XZMC=XZMC		;按收费类型和集团的表对照，开票不传///险种名称	VARCHAR2(256)	是	交易类型为保费收入的，必填，否则可为空
    b ;3
    s EInvoiceDataBodyInvoiceInfoUL.XBDM=""		///险别代码	VARCHAR2(50)	否	交易类型为保费收入的，必填，否则可为空
    s EInvoiceDataBodyInvoiceInfoUL.XBMC=""		///险别名称	VARCHAR2(256)	否	交易类型为保费收入的，必填，否则可为空
    s EInvoiceDataBodyInvoiceInfoUL.HSJE=ObjInvPrtInfo.InvItmDetInfo.GetAt(ObjInvPrtInfo.InvItmDetInfo.Size).Price		///含税金额	NUMBER(20,2)	是	价税分离前金额
    s EInvoiceDataBodyInvoiceInfoUL.SL	="0"	///税率	NUMBER(8,4)	是	该交易价税分离采用税率
    s EInvoiceDataBodyInvoiceInfoUL.BHSJE=ObjInvPrtInfo.InvItmDetInfo.GetAt(ObjInvPrtInfo.InvItmDetInfo.Size).Price		///不含税金额	NUMBER(20,2)	是	价税分离后金额
    s EInvoiceDataBodyInvoiceInfoUL.SE	="0"	///税额	NUMBER(20,4)	是	价税分离生成的税额
    s EInvoiceDataBodyInvoiceInfoUL.YJYH=""		///原保单号	VARCHAR2(32)	否	交易金额为负数时，保全发生回退业务时发送原业务编号（保单受理号），其他业务提供对应的保单号
    s EInvoiceDataBodyInvoiceInfoUL.JFRMC=""		///缴费人名称	VARCHAR2(36)		
    s EInvoiceDataBodyInvoiceInfoUL.KPYQ="1"		///开票要求	VARCHAR2(1)	是	0-专票；1-普票
    s EInvoiceDataBodyInvoiceInfoUL.FPJZ="2"		///发票介质	VARCHAR2(1)	是	0-纸质；2-电子
    s EInvoiceDataBodyInvoiceInfoUL.YWYBM=""		///业务员编码	VARCHAR2(50)	否	完成保单交易业务员代码
    s EInvoiceDataBodyInvoiceInfoUL.YWYMC=""		///业务员名称	VARCHAR2(50)	否	完成保单交易业务员名称
    s EInvoiceDataBodyInvoiceInfoUL.LYXTMC="YGRHYY"		///来源系统名称	VARCHAR2(50)	是	数据来源系统名称
    s EInvoiceDataBodyInvoiceInfoUL.QD=""		///渠道	VARCHAR2(30)	否	渠道
    s EInvoiceDataBodyInvoiceInfoUL.REMARK=""		///备注	VARCHAR2(256)	否	发票备注
    s EInvoiceDataBodyInvoiceInfoUL.YECJBS="0"		///业务场景标识	INTEGER	是	0-正常1-5月1 日批减2-信保业务收入3-共保业务4-共保分出5-共保退保
    s EInvoiceDataBodyInvoiceInfoUL.JZRQ=$e($tr($zd(+$H,3),"-",""),1,6)	///记账日期	VARCHAR2(10)	是	收付挂账日期
    s EInvoiceDataBodyInvoiceInfoUL.ZJLX="01"		///证件类型	VARCHAR2(100)	否	01-身份证02-户口薄03-护照04-军官证05-驾驶证06-返乡证07-异常身份证08-组织机构代码证99-其他
    s EInvoiceDataBodyInvoiceInfoUL.ZJHM=ObjInvPrtInfo.PatBaseInfo.PatID		///证件号码	VARCHAR2(100)	否	
    s EInvoiceDataBodyInvoiceInfoUL.COINSFLAG=""		///联共保的标识	VARCHAR2(20)	否	退保是9，1到8是共保标识
    s EInvoiceDataBodyInvoiceInfoUL.STARTDATE=""		///税款所属期起期	VARCHAR2(100)	否	
    s EInvoiceDataBodyInvoiceInfoUL.ENROLLDATE=""		///税款所属期止期	VARCHAR2(100)	否	
    s EInvoiceDataBodyInvoiceInfoUL.LICENSENO=""		///车牌号	VARCHAR2(100)	否	
    s EInvoiceDataBodyInvoiceInfoUL.LATEFEE=""		///滞纳金	VARCHAR2(100)	否	
    s EInvoiceDataBodyInvoiceInfoUL.CARSHIPTAX=""		///车船税	VARCHAR2(100)	否	
    s EInvoiceDataBodyInvoiceInfoUL.APPLITYPE=""		///个人团体标识	VARCHAR2(5)	否	1代表个人，2代表团体
    s EInvoiceDataBodyInvoiceInfoUL.OPERATESITE=""		///渠道标识	VARCHAR2(30)	否	空代表是核心出单，QBDQCWY- 关于与700度平台，QBDDIYDSX-700度--个意险承保，YGQBD-700度网络平台互联网业务（个险）对接 ，WJBX-网金阳光个人综合意外险
    s EInvoiceDataBodyInvoiceInfoUL.XBFLAG	=""	///信保标识	VARCHAR2(30)	否	
    s EInvoiceDataBodyInvoiceInfoUL.APPSERIALPERIOD=""		///缴费期数	VARCHAR2(30)	否	
    s EInvoiceDataBodyInvoiceInfoUL.ISCARINSURANCE=""		///自动开票标识	VARCHAR2(10)	否	
    s EInvoiceDataBodyInvoiceInfoUL.WBHSJE=""		///外币含税金额	NUMBER(20,2)	否	
    s EInvoiceDataBodyInvoiceInfoUL.WBBHSJE=""		///外币不含税金额	NUMBER(20,2)	否	
    s EInvoiceDataBodyInvoiceInfoUL.WBSE=""		///外币税额	NUMBER(20,2)	否	
    s EInvoiceDataBodyInvoiceInfoUL.YBZ="CNY"		///原币种	VARCHAR2(10)	是	人民币需填写CNY
    s EInvoiceDataBodyInvoiceInfoUL.EMAILADDRESS=""		///邮箱地址	VARCHAR2(100)	否	
	s EInvoiceDataBodyInvoiceInfosUL.InvoiceInfo=EInvoiceDataBodyInvoiceInfoUL
	s EInvoiceDataBodyUL.InvoiceInfos=EInvoiceDataBodyInvoiceInfosUL
	s EInvoiceDataUL.Head=EInvoiceDataHeadUL
	s EInvoiceDataUL.Body=EInvoiceDataBodyUL
    
    s InputPamStream=""
	d EInvoiceDataUL.XMLExportToString(.InputPamStream)     ;生成xml字符串
	
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
    b ;4
    q InputPamStream
}

/// 功能说明：获取XML文件头部声明部分
ClassMethod GetXMLTitle(Version As %String = "") As %String
{
	q "<?xml version=""1.0"" encoding=""gbk""?>"
}

}
