/// 百望电子票据业务组织参数
Class BILL.EINV.ADP.BWA Extends %RegisteredObject
{

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 	业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：董科锋   2019-12-12  新做成
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	;开具之前先查询该流水号下票据是否开具成功
		
    b //组织开具入参
	s ReqInputXml=..EInvoiceXML(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	s:ReqInputXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:ReqInputXml="" "-1"
	
	b //调用百望http接口
    s ResOutput=""
    s rtn=##class(BILL.EINV.BI.BWA.HTTPRequest).InvoiceRequest(ReqInputXml,InvociePam.ObjUPConfig, .ResOutput, InvociePam.ErrMsgInfo)
    q:rtn'="0" "-1"
    
    ;解析返回结果 
    s rtn=..ESetInvResultOfInvoice(ObjInvUpDetail, ResOutput)
	q:rtn'="0" InvociePam.ErrMsgInfo="调用接口成功,保存结果失败"
	
	q rtn
}

/// 将内层报文和外部报文合并，然后输出XML
ClassMethod EInvoiceXML(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	//生成内层报文
	s rtn=""
	s InXML=..CreateInvoiceDetail(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)   ;
	s Data=##class(web.Util.Encryption).Base64Encode(InXML)
	b ;outxml
	//内层报文base64加密后添加到外部报文的一个节点
	s EInvOutMsg=##class(BILL.EINV.DTO.BWA.EInvOutMsg).%New()
	s EInvOutMsg.id="DZFPKJ"
	s EInvOutMsg.comment="电子发票开具"
	s EMsgBody=##class(BILL.EINV.DTO.BWA.EMsgBody).%New()
    s EMsgBody.yylxdm="1"
    s EMsgInput=##class(BILL.EINV.DTO.BWA.EMsgInput).%New()
    s EMsgInput.JQBH=InvociePam.TaxSBBM                 ;设备编号(固定值，开发商提供(多个开票窗口使用同一个))
    s EMsgInput.DIRECT="4"                             ;接口参数(默认是4固定值) 
    s XSFDZDH=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_DZDH", 5) 
    s EMsgInput.XSFLXFS=XSFDZDH                             ;销售方联系方式
    s EMsgInput.GMFLXFS=ObjInvPrtInfo.PatBaseInfo.Mobphone  ;购买方联系方式
    s EMsgInput.FPXML=Data                             ;内层报文
    s EMsgInput.SKType=""                              ;开票机器类型(0表示税控服务器 1表示税控盘 2表示税控盘组服务器)
    s EMsgInput.BussinessID="FPKJ"                     ;业务类型(FPKJ表示发票开具；FPCX表示从Wrapper后台数据库获取已开信息，
                                                       ;上传到电子发票平台；YKFP表示上传已开具的发票，用于非本税控服务器开具的电子发票。)
    s EMsgBody.input=EMsgInput 
    s EInvOutMsg.body=EMsgBody
    
    s InputPamStream=""
	d EInvOutMsg.XMLExportToString(.InputPamStream)     ;生成xml字符串
	
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
    b ;xml
    s ReqInputXml=##class(web.Util.Encryption).Base64Encode(InputPamStream)
    q ReqInputXml
}

/// 功能说明：生成票据的内部报文信息
ClassMethod CreateInvoiceDetail(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//构建内部报文对象
	s EInvInMsg=##class(BILL.EINV.DTO.BWA.EInvInMsg).%New()
	s EInvInMsg.id="FPKJ"
	s EInvInMsg.comment="发票开具"
	
	s ReqComFPKJ=##class(BILL.EINV.DTO.BWA.EReqComFPKJ).%New()
	s ReqComFPKJ.class="REQUEST_COMMON_FPKJ"
	s ComFPKJFPT=##class(BILL.EINV.DTO.BWA.EComFPKJFPT).%New()
	s ComFPKJFPT.class="COMMON_FPKJ_FPT"
	s ComFPKJFPT.FPQQLSH=ObjInvUpDetail.IUDBusNo         ;"发票请求流水号"
	s ComFPKJFPT.ORDERID=""                              ;订单号
	
	;开票类型，是否增加一个标志，判断是开具蓝字发票还是红字发票
	;还是交易表里面原电子票据数据判断
	if ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode'="" d
	.s ComFPKJFPT.KPLX="1"
	else  d
	.s ComFPKJFPT.KPLX="0"                                ;开票类型  0-蓝字发票；1-红字发票
	s BMBBBH=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","BMB_BBH", 5)
	s:BMBBBH="" BMBBBH="30.0"
	s ComFPKJFPT.BMBBBH=BMBBBH                          ;编码表版本号
	s ComFPKJFPT.ZSFS="0"                                ;征税方式 0：普通征税 2：差额征税
	s ComFPKJFPT.TSPZ="00"                               ;特殊票种标识  “00”非特殊票种 “01”农产品销售 “02”农产品收购 “06”抵扣通行费 “08”成品油 说明:非特殊票种默认“00“
	s XSFNSRSBH=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_NSRSBH", 5)
	s ComFPKJFPT.XSFNSRSBH=XSFNSRSBH                     ;销售方纳税人识别号
	s XSFMC=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_MC", 5)
	s ComFPKJFPT.XSFMC=XSFMC                             ;销售方名称
	s XSFDZDH=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_DZDH", 5)
	s ComFPKJFPT.XSFDZDH=XSFDZDH                         ;销售方地址、电话
	s XSFYHZH=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_YHZH", 5)
	s ComFPKJFPT.XSFYHZH=XSFYHZH                         ;销售方银行账号
	s XSFLXFS=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_YHZH", 5)
	s ComFPKJFPT.XSFLXFS=XSFLXFS                         ;销售方移动电话或邮箱
	
	s ComFPKJFPT.GMFNSRSBH=""                               ;购买方纳税人识别号
	s ComFPKJFPT.GMFMC=ObjInvPrtInfo.PatBaseInfo.PatName   ;购买方名称
	s ComFPKJFPT.GMFDZDH=""                                 ;购买方地址、电话   ?????????????
	s ComFPKJFPT.GMFYHZH=""                                 ;购买方银行账号
	s ComFPKJFPT.GMFLXFS=ObjInvPrtInfo.PatBaseInfo.Mobphone ;购买方移动电话或邮箱
	
	s ComFPKJFPT.FPDM=""                                    ;发票代码
	s ComFPKJFPT.FPHM=""                                    ;发票号码
	s ComFPKJFPT.KPRQ=""                                    ;开具日期
	s ComFPKJFPT.FPMW=""                                    ;密文
	s ComFPKJFPT.JYM=""                                     ;校验码
	 
	s ComFPKJFPT.KPR=ObjInvPrtInfo.BusUserDesc              ;开票人
	s SKR=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_SKR", 5)
	s ComFPKJFPT.SKR=SKR                                     ;收款人
	s FHR=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_FHR", 5)
	s ComFPKJFPT.FHR=FHR                                     ;复核人
	
	s ComFPKJFPT.YFPDM=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode   ;原发票代码
	s ComFPKJFPT.YFPHM=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo      ;原发票号码    ->红字发票时必须
	s ComFPKJFPT.JSHJ=ObjInvPrtInfo.InvAmt                          ;价税合计
	s ComFPKJFPT.HJJE=ObjInvPrtInfo.InvAmt                   ;合计金额
	s ComFPKJFPT.HJSE="0"                                    ;合计税额
	s ComFPKJFPT.KCE=""                                     ;扣除额
	s ComFPKJFPT.BZ=""                                      ;备注	
	s ReqComFPKJ.ComFPKJFPT=ComFPKJFPT
	s ComFPKJXMMXS=##class(BILL.EINV.DTO.BWA.EComFPKJXMXXS).%New()
	s ComFPKJXMMXS.class="COMMON_FPKJ_XMXX"
	s ComFPKJXMMXS.size="1"      
	
	;获取收费大类信息
	for i=1:1:ObjInvPrtInfo.InvCateInfo.Size
	.s ComFPKJXMXX=##class(BILL.EINV.DTO.BWA.EComFPKJXMXX).%New()
	.s ComFPKJXMXX.FPHXZ="0"               ;发票行性质(;0正常行、1折扣行、2被折扣行)
	.s ComFPKJXMXX.SPBM=""                 ;商品编码(必须与总局下发编码一致)
	.s ComFPKJXMXX.ZXBM=""                    ;自行编码
	.s ComFPKJXMXX.YHZCBS="1"                 ;优惠政策标识(0未使用，1表示使用)
	.s ComFPKJXMXX.LSLBS="1"                  ;0税率标识(空代表无 全部传空,有免税的传数字0： ？？？文档不能为空                                        ;出口退税1：出口免税和其他免税优惠政策2：不征增值税,3：普通零税率)
	.s ComFPKJXMXX.ZZSTSGL=""                 ;增值税特殊管理
	.s ComFPKJXMXX.XMMC=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc              ;项目名称
	.s ComFPKJXMXX.GGXH=""                   ;规格型号
	.s ComFPKJXMXX.DW=""                     ;计量单位
	.s ComFPKJXMXX.XMSL=""                   ;项目数量
	.s ComFPKJXMXX.XMDJ=""                  ;项目单价
	.s ComFPKJXMXX.XMJE=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt                 ;项目金额
	.s ComFPKJXMXX.SL="0"                     ;税率
	.s ComFPKJXMXX.SE="0"                     ;税额
	.d ComFPKJXMMXS.ComFPKJXMXX.Insert(ComFPKJXMXX)
	s ReqComFPKJ.ComFPKJXMMXS=ComFPKJXMMXS
	s EInvInMsg.ReqComFPKJ=ReqComFPKJ
	s InputPamStream=""
	;d EInvInMsg.XMLExportToStream(.InputPamStream)
	;d EInvOutMsg.XMLExportToStream(.InputPamStream)    ;生成xml字符流
	;q:$isobject(InputPamStream)=0 rtn
	;w InputPamStream.OutputToDevice()
	d EInvInMsg.XMLExportToString(.InputPamStream)     ;生成xml字符串
	b ;inxml
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
	q InputPamStream
}

/// 功能说明：设置电子票据开票结果信息到交易对象表对象中
/// 入参说明：XMLRes  --> 开票返回值XML数据
/// 返 回 值：0 成功 其他值失败
ClassMethod ESetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, XMLRes As %String) As %String
{
	s rtn="-1"
	;使用Base64解密
	;s XMLRes=##class(web.Util.Encryption).Base64Decode(XMLRes)
	s ObjRes=##class(BILL.EINV.DTO.BWA.EResOutMsg).%New()
	s XMLRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(XMLRes, "business", "BILL.EINV.DTO.BWA.EResComFPKJ", .ObjRes)
	q:XMLRtn'="0" rtn
	
	//对返回结果的时间戳进行分割
	s createDate=$e(ObjRes.ResComFPKJ.KPRQ,1,4)_"-"_$e(ObjRes.ResComFPKJ.KPRQ,5,6)_"-"_$e(ObjRes.ResComFPKJ.KPRQ,7,8)
	s createTime=$e(ObjRes.ResComFPKJ.KPRQ,9,10)_":"_$e(ObjRes.ResComFPKJ.KPRQ,11,12)_":"_$e(ObjRes.ResComFPKJ.KPRQ,13,14)
	
	s ObjInvUpDetail.IUDResultCode=ObjRes.ResComFPKJ.RETURNCODE  	;返回代码 0成功，其它失败
	s ObjInvUpDetail.IUDResultMeg=ObjRes.ResComFPKJ.RETURNMSG  		;返回信息
	q:ObjInvUpDetail.IUDResultCode'="0" "-1"	//失败则退出
	
	s ObjInvUpDetail.Xstr2=ObjRes.ResComFPKJ.FPQQLSH                   ;发票请求流水号
	s ObjInvUpDetail.Xstr3=ObjRes.ResComFPKJ.JQBH                      ;税控设备编号                                                            ;税控设备编号
	s ObjInvUpDetail.IUDBillBatchCode=ObjRes.ResComFPKJ.FPDM	     	;发票代码
	s ObjInvUpDetail.IUDBillBatchNo=ObjRes.ResComFPKJ.FPHM		        ;发票号码
	s ObjInvUpDetail.IUDCheckCode=ObjRes.ResComFPKJ.JYM			        ;校验码
	s ObjInvUpDetail.IUDCreatDate=$zdh(createDate,3)					;票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$zdt(createTime)						;票据生成时间
	s ObjInvUpDetail.IUDBillQRCode=ObjRes.ResComFPKJ.EWM			    ;票据二维码	
	s ObjInvUpDetail.Xstr4=ObjRes.ResComFPKJ.FPMW                       ;发票密文	
	s ObjInvUpDetail.IUDPrintType="E"                                   ;电子票据
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                	;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"										;发票状态	
	q "0"
}

/// 税控电子票据交易组织参数
/// 功能说明：开具业务
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：徐保保   2019-12-12  新做成
/// 其    他：w ##class(BILL.EINV.ADP.BWA).PInvoice("","","") 
ClassMethod PInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
    ;add  guoyunlong 2019-12-23
	;开具发票之前，先用请求流水号查询该流水号下的发票是否开具成功，成功的话直接保存发票数据
	s rtn=""
	s SearchReq=..SearchInvXMLInfo(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	s:SearchReq="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:SearchReq="" "-1"
	

    b //调用税控http接口
	s SearchXMLRes=""
	s httpRtn=##class(BILL.EINV.BI.BWA.HTTPRequest).PInvoiceRequest(SearchReq,InvociePam.ObjUPConfig, SearchXMLRes, InvociePam.ErrMsgInfo)	;调用博思http接口
	;q:$p(httpRtn,"^",1)'="0" "-1"
	s SearchXMLRes=$p(httpRtn,"^",2)
	;s:SearchXMLRes="" InvociePam.ErrMsgInfo="调用接口成功,返回结果为空"
	b ;;;
	//如果查询发票信息成功，并且返回值不为空，直接保存数据
	if ($p(httpRtn,"^",1)="0")&&(SearchXMLRes'="")
	 {
	  s rtn=..SearchInvResultOfInvoice(ObjInvUpDetail, SearchXMLRes)  ;把开票结果信息保存到交易表
	  s:rtn'="0" InvociePam.ErrMsgInfo="调用接口成功,返回结果失败"
	  b ;查询数据	 
	 }else
	 {
		b ///组织开具入参
	   s XMLReq=..PInvoiceXML(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	   s:XMLReq="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	   q:XMLReq="" "-1"
	
       s XMLRes=""
	   s httpRtn=##class(BILL.EINV.BI.BWA.HTTPRequest).PInvoiceRequest(XMLReq,InvociePam.ObjUPConfig, XMLRes, InvociePam.ErrMsgInfo)	;调用博思http接口
	   b ;;3343444
	   q:$p(httpRtn,"^",1)'="0" "-1"
	   s XMLRes=$p(httpRtn,"^",2)
	   s:XMLRes="" InvociePam.ErrMsgInfo="调用接口成功,返回结果为空"
	   q:XMLRes="" "-1"
	   //将开票结果信息保存到交易表对象
	  s rtn=..PSetInvResultOfInvoice(ObjInvUpDetail, XMLRes)  ;把开票结果信息保存到交易表
	  s:rtn'="0" InvociePam.ErrMsgInfo="调用接口成功,返回结果失败"
		 
	}
	
	q rtn
}

/// 税控电子票据交易组织参数内部报文组织
/// 功能说名称：组织开具入参
ClassMethod PInvoiceXML(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//构建报文对象
	s ObjReq=##class(BILL.EINV.DTO.BWA.PInvInMsg).%New()
	s ObjReq.id="10008"
	s ObjReq.comment="发票开具"
	
	s ObjBody=##class(BILL.EINV.DTO.BWA.PReqComBody).%New()
	s ObjBody.yylxdm="1"
	s ObjBody.kpzdbs="zd001"										;开票终端唯一性标识
	s ObjBody.fplxdm="007"									;发票类型代码
	s ObjBody.fpqqlsh=ObjInvUpDetail.IUDBusNo				;发票请求流水号
	s Month=+$p($zd(+$h,3),"-",2)
	s ObjBody.kplx="0"				;开票类型(0正票,1负票)--跨月的话开负数
	i (+$p(ObjInvPrtInfo.BusDate,"-",2)<Month)  d
	.s ObjBody.kplx="0"
	s ObjBody.tspz="00"					;特殊票种标识(00不是,01农产品销售,02农产品收购,06抵扣通行费,07其它通行费,08成品油销售)
	s ObjBody.xhdwsbh=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_NSRSBH", 5)	;销货单位识别号
	s ObjBody.xhdwmc=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_MC", 5)		;销货单位名称
	s ObjBody.xhdwdzdh=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_DZDH", 5)	;销货单位地址电话
	s ObjBody.xhdwyhzh=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_YHZH", 5)	;销货单位银行帐号
	s ObjBody.ghdwsbh=""	;购货单位识别号N
	s ObjBody.ghdwmc=ObjInvPrtInfo.PatBaseInfo.PatName		;购货单位名称
	s ObjBody.ghdwdzdh=ObjInvPrtInfo.PatBaseInfo.Mobphone	;购货单位地址电话N
	s ObjBody.ghdwyhzh=""	;购货单位银行帐号N
	
	i ObjInvPrtInfo.InvCateInfo.Size<8 d
	.s ObjBody.qdbz="0"  ;清单标志(0：无清单,1：带清单),医院要求大类大于8传1
	else  d
	.s ObjBody.qdbz="1"  ;清单标志(0：无清单,1：带清单)
	;s ObjBody.qdbz="1"	
	s ObjBody.zsfs="0"	;征税方式(0：普通征税,1：减按计征,2：差额征税)
	
	s ObjBody.hjje=ObjInvPrtInfo.InvAmt	;合计金额???????????
	s ObjBody.hjse="0"	;合计税额???????????
	s ObjBody.jshj=ObjInvPrtInfo.InvAmt	;价税合计???????????
	s ObjBody.kce=""	;差额征税扣除额N
	s ObjBody.bz=""		;备注
	s SKR=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_SKR", 5)
	s ObjBody.skr=SKR	;收款人                                 
	s FHR=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_FHR", 5)
	s ObjBody.fhr=FHR	;复核人
	s ObjBody.kpr=ObjInvPrtInfo.BusUserDesc	;开票人
	s ObjBody.tzdbh=""		;信息表编号
	s ObjBody.yfpdm=""		;原发票代码
	s ObjBody.yfphm =""		;原发票号码
	
	//明细赋值
	s ObjFYMX=##class(BILL.EINV.DTO.BWA.PComFYMX).%New()
	s ObjFYMX.count=ObjInvPrtInfo.InvCateInfo.Size
	
	//具体明细数据Group赋值
	f i=1:1:ObjFYMX.count d
	.s ObjFYMXGroup=##class(BILL.EINV.DTO.BWA.PComFYMXGroup).%New()
	.s ObjFYMXGroup.xh=i       		;序号
	.s ObjFYMXGroup.fphxz="0"       ;发票行性质(0 正常行,1 折扣行,2 被折扣行)
	.s ObjFYMXGroup.spmc=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc      ;商品名称
	.s ObjFYMXGroup.spsm="1501"    	    ;商品税目N	
	.s ObjFYMXGroup.ggxh=""    	    ;规格型号N
	.s ObjFYMXGroup.spsl=""    	    ;商品数量N
	.s ObjFYMXGroup.dj=""    	    ;单价N
	.s ObjFYMXGroup.je=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt    ;金额
	.s ObjFYMXGroup.sl="0"   			 ;税率?????
	.s ObjFYMXGroup.se="0"   			 ;税额?????
	.s ObjFYMXGroup.hsbz="0"  			 ;含税标志(0 不含税,1 含税)N??????
	.s ObjFYMXGroup.spbm="3070202000000000000"   			 ;商品编码N
	.s ObjFYMXGroup.zxbm=""    			 ;纳税人自行编码N
	.s ObjFYMXGroup.yhzcbs="0"   		 ;优惠政策标识N
	.s ObjFYMXGroup.lslbs="3"   	 		 ;零税率标识N(空代表无,1 出口免税和其他免税优惠政策,2 不征增值税,3 普通零税率)
	.s ObjFYMXGroup.zzstsgl="免税"   		 ;增值税特殊管理N(如果yhzcbs为1时，此项必填)
	.d ObjFYMX.group.Insert(ObjFYMXGroup)
	
	s ObjBody.fyxm=ObjFYMX
	s ObjReq.body=ObjBody
	
	s InputPamStream=""
	;d ObjReq.XMLExportToStream(.InputPamStream)
	;q:$isobject(InputPamStream)=0 rtn
	;w InputPamStream.OutputToDevice()
	;
	d ObjReq.XMLExportToString(.InputPamStream,"","literal")       ;生成xml字符串
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream   ;加上xml文件头数据
	
	q InputPamStream
}

/// 税控电子票据交易组织参数
/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：XMLRes  --> 开票返回值XML数据
/// 返 回 值：0 成功 其他值失败
ClassMethod PSetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, XMLRes As %String) As %String
{
	s rtn="-1"
	b ;解析12
	set XMLRes=$ZCVT(XMLRes,"O","GB18030")
	set tDocument=""
	set tSC=##class(%XML.XPATH.Document).CreateFromString(XMLRes, .tDocument)
	s tRes=""
    
	set tSC=tDocument.EvaluateExpression("/business/body/returncode","text()",.tRes)
	s ObjInvUpDetail.IUDResultCode=$zcvt(tRes.GetAt(1).Value,"O","UTF8")   	;返回代码 0成功，其它失败
	set tSC=tDocument.EvaluateExpression("/business/body/returnmsg","text()",.tRes)
	s ObjInvUpDetail.IUDResultMeg=$zcvt(tRes.GetAt(1).Value,"O","UTF8")		;返回信息
	q:ObjInvUpDetail.IUDResultCode'="0" "-1"	//失败则退出
	
	set tSC=tDocument.EvaluateExpression("/business/body/returndata/fpdm","text()",.tRes)
	s ObjInvUpDetail.IUDBillBatchCode=$zcvt(tRes.GetAt(1).Value,"O","UTF8")		;发票代码
	set tSC=tDocument.EvaluateExpression("/business/body/returndata/fphm","text()",.tRes)
	s ObjInvUpDetail.IUDBillBatchNo=$zcvt(tRes.GetAt(1).Value,"O","UTF8")			;发票号码
	
	b ;;
	set tSC=tDocument.EvaluateExpression("/business/body/returndata/jym","text()",.tRes)
	s ObjInvUpDetail.IUDCheckCode=$zcvt(tRes.GetAt(1).Value,"O","UTF8")			;校验码

	b //对返回结果的时间戳进行分割
	set tSC=tDocument.EvaluateExpression("/business/body/returndata/kprq","text()",.tRes)
	s kprq=$zcvt(tRes.GetAt(1).Value,"O","UTF8")
	s createDate=$e(kprq,1,4)_"-"_$e(kprq,5,6)_"-"_$e(kprq,7,8)
	s createTime=$e(kprq,9,10)_":"_$e(kprq,11,12)_":"_$e(kprq,13,14)	
	s ObjInvUpDetail.IUDCreatDate=$zdh(createDate,3)					;票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$zth(createTime)						;票据生成时间
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                	;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"										;发票状态
	;对于百望，纸质票据和电子票据分开开具，票据类型暂时都按照电子票据处理
	s ObjInvUpDetail.IUDPrintType="E"									;纸质票据
	s ObjInvUpDetail.IUDPrintFlag="1"									;是否打印纸质票据
	
	q "0"
}

/// 税控发票作废返回值参数
/// 功能说明：设置作废发票信息到交易对象表对象中
/// 入参说明：XMLRes  --> 作废发票返回值XML数据
/// 返 回 值：0 成功 其他值失败
ClassMethod PSetInvResultOfInvaild(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, XMLRes As %String) As %String
{
	s rtn="-1"
	b ;解析
	set XMLRes=$ZCVT(XMLRes,"O","GB18030")
	set tDocument=""
	set tSC=##class(%XML.XPATH.Document).CreateFromString(XMLRes, .tDocument)
	s tRes=""
    
	set tSC=tDocument.EvaluateExpression("/business/body/returncode","text()",.tRes)
	s ObjInvUpDetail.IUDResultCode=$zcvt(tRes.GetAt(1).Value,"O","UTF8")   	;返回代码 0成功，其它失败
	set tSC=tDocument.EvaluateExpression("/business/body/returnmsg","text()",.tRes)
	s ObjInvUpDetail.IUDResultMeg=$zcvt(tRes.GetAt(1).Value,"O","UTF8")		;返回信息
	;q:ObjInvUpDetail.IUDResultCode'="0" "-1"	//失败则退出
	
	set tSC=tDocument.EvaluateExpression("/business/body/returndata/fpdm","text()",.tRes)
	s ObjInvUpDetail.IUDBillBatchCode=$zcvt(tRes.GetAt(1).Value,"O","UTF8")		;发票代码
	set tSC=tDocument.EvaluateExpression("/business/body/returndata/fphm","text()",.tRes)
	s ObjInvUpDetail.IUDBillBatchNo=$zcvt(tRes.GetAt(1).Value,"O","UTF8")			;发票号码
	
	b //对返回结果的时间戳进行分割
	set tSC=tDocument.EvaluateExpression("/business/body/returndata/zfrq","text()",.tRes)
	s zfrq=$zcvt(tRes.GetAt(1).Value,"O","UTF8")
	s createDate=$e(zfrq,1,4)_"-"_$e(zfrq,5,6)_"-"_$e(zfrq,7,8)
	s createTime=$e(zfrq,9,10)_":"_$e(zfrq,11,12)_":"_$e(zfrq,13,14)	
	s ObjInvUpDetail.IUDCreatDate=$zdh(createDate,3)					;票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$zth(createTime)						;票据生成时间
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                	;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="S"										;发票状态
	;对于百望，纸质票据和电子票据分开开具，票据类型暂时都按照电子票据处理
	s ObjInvUpDetail.IUDPrintType="E"									;纸质票据
	s ObjInvUpDetail.IUDPrintFlag="1"									;是否打印纸质票据
	
	q "0"
}

/// 税控发票信息查询返回值参数组织
/// 功能说明：设置发票查询信息到交易对象表对象中
/// 入参说明：XMLRes  --> 发票查询返回值XML数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SearchInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, XMLRes As %String)
{
	s rtn="-1"
	b ;解析345
	set XMLRes=$ZCVT(XMLRes,"O","GB18030")
	set tDocument=""
	set tSC=##class(%XML.XPATH.Document).CreateFromString(XMLRes, .tDocument)
	s tRes=""
    
	b  ;gffgf
	set tSC=tDocument.EvaluateExpression("/business/body/returncode","text()",.tRes)
	s ObjInvUpDetail.IUDResultCode=$zcvt(tRes.GetAt(1).Value,"O","UTF8")   	;返回代码 0成功，其它失败
	set tSC=tDocument.EvaluateExpression("/business/body/returnmsg","text()",.tRes)
	s ObjInvUpDetail.IUDResultMeg=$zcvt(tRes.GetAt(1).Value,"O","UTF8")		;返回信息
	q:ObjInvUpDetail.IUDResultCode'="0" "-1"	//失败则退出
	
	set tSC=tDocument.EvaluateExpression("/business/body/returndata/kpxx/group/fpdm","text()",.tRes)
	s ObjInvUpDetail.IUDBillBatchCode=$zcvt(tRes.GetAt(1).Value,"O","UTF8")		;发票代码
	set tSC=tDocument.EvaluateExpression("/business/body/returndata/kpxx/group/fphm","text()",.tRes)
	s ObjInvUpDetail.IUDBillBatchNo=$zcvt(tRes.GetAt(1).Value,"O","UTF8")			;发票号码
	
	
	set tSC=tDocument.EvaluateExpression("/business/body/returndata/kpxx/group/jym","text()",.tRes)
	s ObjInvUpDetail.IUDCheckCode=$zcvt(tRes.GetAt(1).Value,"O","UTF8")			;校验码

	b //对返回结果的时间戳进行分割
	set tSC=tDocument.EvaluateExpression("/business/body/returndata/kpxx/group/kprq","text()",.tRes)
	s kprq=$zcvt(tRes.GetAt(1).Value,"O","UTF8")
	s createDate=$e(kprq,1,4)_"-"_$e(kprq,5,6)_"-"_$e(kprq,7,8)
	s createTime=$e(kprq,9,10)_":"_$e(kprq,11,12)_":"_$e(kprq,13,14)	
	s ObjInvUpDetail.IUDCreatDate=$zdh(createDate,3)					;票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$zth(createTime)						;票据生成时间
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                	;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"										;发票状态
	;对于百望，纸质票据和电子票据分开开具，票据类型暂时都按照电子票据处理
	s ObjInvUpDetail.IUDPrintType="E"									;纸质票据
	s ObjInvUpDetail.IUDPrintFlag="1"									;是否打印纸质票据
	
	q "0"
}

/// 下载电子发票信息
ClassMethod DLEinvInfo() As %String
{
}

/// 发票信息查询
ClassMethod SearchInvXMLInfo(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//构建报文对象
	s ObjSerch=##class(BILL.EINV.DTO.BWA.SearchInMsg).%New()
	s ObjSerch.id="10010"
	s ObjSerch.comment="发票查询"
	
	s ObjBody=##class(BILL.EINV.DTO.BWA.SearchInvBody).%New()
	s ObjBody.yylxdm="1"
	s ObjBody.kpzdbs="zd001"								 ;开票终端唯一性标识
	s ObjBody.fplxdm="007"									;发票类型代码
	s ObjBody.cxfs="2"                                      ;查询方式(0：按发票号码段查询1：按时间段查询,2请求流水号查询)
	s ObjBody.cxtj=ObjInvUpDetail.IUDBusNo				;发票请求流水号
	
	s ObjSerch.body=ObjBody
	
	s InputPamStream=""
	d ObjSerch.XMLExportToString(.InputPamStream)       ;生成xml字符串
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream   ;加上xml文件头数据
	
	q InputPamStream
}

/// 调用第三方接口打印
ClassMethod PrintPaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam)
{
	;开始打印
    s rtn=""
	s ReqInputXml=..PrintInvXMLInfo(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	s:ReqInputXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:ReqInputXml="" "-1"
	
	b //调用百望http接口
    s ResOutput=""
    s rtn=##class(BILL.EINV.BI.BWA.HTTPRequest).PInvoiceRequest(ReqInputXml,InvociePam.ObjUPConfig, .ResOutput, InvociePam.ErrMsgInfo)
    q:rtn'="0" InvociePam.ErrMsgInfo="发票打印失败"
	q rtn
}

/// 组织调用第三方打印发票XML信息
ClassMethod PrintInvXMLInfo(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
	s rtn=""
	
	//构建报文对象
	s ObjPrint=##class(BILL.EINV.DTO.BWA.PrintInvMsg).%New()
	s ObjPrint.id="20004"
	s ObjPrint.comment="发票打印"
	
	s ObjBody=##class(BILL.EINV.DTO.BWA.PrintInvBody).%New()
	s ObjBody.yylxdm="1"
	s ObjBody.kpzdbs="zd001"								 ;开票终端唯一性标识
	s ObjBody.fplxdm="007"									;发票类型代码
	s ObjBody.fpdm=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode         ;发票代码
	s ObjBody.fphm=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo             ;发票号码
	s ObjBody.dylx="0"                                      ;打印类型      ;0为发票打印，1为清单打印
	s ObjBody.dyfs="0"                                       ;打印方式（0：每次点击都弹出打印设置框。1：只在第一次点击时弹出打印设置框。2: 设置默认打印

	s ObjBody.printername=""                                ;打印机名称（当dyfs设置为2的时候，读取此节点）
	s ObjPrint.body=ObjBody
	s InputPamStream=""
	d ObjPrint.XMLExportToString(.InputPamStream)       ;生成xml字符串
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream   ;加上xml文件头数据
	
	q InputPamStream
}

/// 调用第三方接口作废纸质票据
ClassMethod PInvaild(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam)
{
    s rtn=""
	s ReqInputXml=..PInvaildXML(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	s:ReqInputXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:ReqInputXml="" "-1"
	
	b //调用百望http接口
	
	s XMLRes=""
	s httpRtn=##class(BILL.EINV.BI.BWA.HTTPRequest).PInvoiceRequest(XMLReq,InvociePam.ObjUPConfig, XMLRes, InvociePam.ErrMsgInfo)	;调用博思http接口
	q:$p(httpRtn,"^",1)'="0" "-1"
    s XMLRes=$p(httpRtn,"^",2)
	s:XMLRes="" InvociePam.ErrMsgInfo="调用接口成功,返回结果为空"
	q:XMLRes="" "-1"
	 
	 
	//将作废发票信息结果信息保存到交易表对象
    s rtn=..PSetInvResultOfInvaild(ObjInvUpDetail, XMLRes)   ;把开票结果信息保存到交易表
	s:rtn'="0" InvociePam.ErrMsgInfo="调用接口成功,返回结果失败"
	q rtn
}

/// 组织纸质发票作废数据XML
ClassMethod PInvaildXML(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//构建报文对象
	s ObjReq=##class(BILL.EINV.DTO.BWA.InvaildInvReqMsg).%New()
	s ObjReq.id="10009"
	s ObjReq.comment="发票作废"
	
	s ObjBody=##class(BILL.EINV.DTO.BWA.InvaildInvBody).%New()
	s ObjBody.yylxdm="1"
	s ObjBody.kpzdbs="zd001"								 ;开票终端唯一性标识
	s ObjBody.fplxdm="007"									;发票类型代码
	s ObjBody.zflx="1"                                       ;作废类型(0：空白票作废1：已开票作废)
	s ObjBody.fpdm=ObjInvUpDetail.IUDBillBatchCode          ;发票代码
	s ObjBody.fphm=ObjInvUpDetail.IUDBillBatchNo             ;发票号码
	
	
	s ObjBody.hjje=ObjInvUpDetail.IUDCreatAmt                ;合计金额 (空白作废时为空,小数点后两位)
	s ObjBody.zfr=ObjInvPrtInfo.BusUserDesc                  ;作废人??????发票结算操作员    界面传进来

	s ObjReq.body=ObjBody
	s InputPamStream=""
	d ObjReq.XMLExportToString(.InputPamStream)       ;生成xml字符串
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream   ;加上xml文件头数据
	
	q InputPamStream
}

/// 功能说明：获取XML文件头部声明部分
ClassMethod GetXMLTitle(Version As %String = "") As %String
{
	q "<?xml version=""1.0"" encoding=""gbk""?>"
}

}
