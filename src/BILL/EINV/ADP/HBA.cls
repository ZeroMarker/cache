/// 河北唐山中心电子发票接口
Class BILL.EINV.ADP.HBA Extends %RegisteredObject
{

/// 电子发票开具接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.HBA).EInvoice("","","") 
ClassMethod EInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	;d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).Invoice开始")
	s RtnFlag="0"
	;s InputXML=..EInvoiceCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	s InputXML=..EINVOutInfo(ObjInvUpDetail,ObjInvPrtInfo,InvociePam,"EInvoice")
	;s InputXML="<?xml version=""1.0"" encoding=""UTF-8"" ?><interface><globalInfo><terminalCode>0</terminalCode><appId>ZZS_PT_DZFP</appId><version>2.0</version><interfaceCode>ECXML.FPKJ.BC.E_INV</interfaceCode><userName>bHDjs0v4</userName><passWord>9946678345NDc4MTdiZWU5MjVmZjdmZg==</passWord><taxpayerId>130100999999166</taxpayerId><authorizationCode>SYPRTYJ91G</authorizationCode><requestCode>bHDjs0v4</requestCode><requestTime>2018-01-01 00:00:01</requestTime><responseCode/><dataExchangeId>bHDjs0v4202000000001</dataExchangeId><fjh/><jqbh/></globalInfo><returnStateInfo><returnCode/><returnMessage/></returnStateInfo><Data><dataDescription><zipCode>0</zipCode><encryptCode>0</encryptCode><codeType>0</codeType></dataDescription><content><REQUEST_FPKJXX class=""REQUEST_FPKJXX""><FPKJXX_FPTXX class=""FPKJXX_FPTXX""><FPQQLSH>bHDjs0v4202000000001</FPQQLSH><DSPTBM>bHDjs0v4</DSPTBM><NSRSBH>130100999999166</NSRSBH><NSRMC>航信培训企业166</NSRMC><NSRDZDAH/><SWJG_DM/><DKBZ>0</DKBZ><PYDM>000001</PYDM><KPXM>食品</KPXM><XHF_NSRSBH>130100999999166</XHF_NSRSBH><XHFMC>航信培训企业166</XHFMC><XHF_DZ>测试企业地址</XHF_DZ><XHF_DH>15333333333</XHF_DH><XHF_YHZH/><GHFMC>个人</GHFMC><GHF_NSRSBH/><GHF_SF/><GHF_DZ/><GHF_GDDH/><GHF_SJ/><GHF_EMAIL/><GHFQYLX>03</GHFQYLX><GHF_YHZH/><HY_DM/><HY_MC/><KPY>开票员</KPY><SKY>收款人</SKY><FHR>复核人</FHR><KPRQ/><KPLX>0</KPLX><YFP_DM/><YFP_HM/><CZDM>10</CZDM><CHYY/><TSCHBZ>0</TSCHBZ><KPHJJE>10</KPHJJE><HJBHSJE>0</HJBHSJE><HJSE>0</HJSE><BZ/><BYZD1/><BYZD2/><BYZD3/><BYZD4/><BYZD5/><BMB_BBH>33.0</BMB_BBH><QD_BZ>0</QD_BZ><QDXMMC/></FPKJXX_FPTXX><FPKJXX_XMXXS class=""FPKJXX_XMXX;"" size=""1""><FPKJXX_XMXX><XMMC>测试商品</XMMC><XMDW/><GGXH/><XMSL>1</XMSL><HSBZ>1</HSBZ><XMDJ>10</XMDJ><XMBM/><XMJE>10</XMJE><SL>0.03</SL><SE>0</SE><KCE/><BYZD1/><BYZD2/><BYZD3/><BYZD4/><BYZD5/><FPHXZ>0</FPHXZ><SPBM>1010101030000000000</SPBM><ZXBM/><YHZCBS>0</YHZCBS><LSLBS/><ZZSTSGL/></FPKJXX_XMXX></FPKJXX_XMXXS><FPKJXX_DDXX class=""FPKJXX_DDXX""><DDH>000000000001</DDH><THDH/><DDDATE/></FPKJXX_DDXX><FPKJXX_DDMXXXS class=""FPKJXX_DDMXXX;"" size=""0""/><FPKJXX_ZFXX class=""FPKJXX_ZFXX""/><FPKJXX_WLXX class=""FPKJXX_WLXX""/></REQUEST_FPKJXX></content></Data></interface>"
	q:InputXML="" "-1"   ;组织入参发生错误
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).EInvoice开始"_InputXML)
	b ;调用第三方webService服务
	s EINvWebService=##class(dzfpWebService.DzfpWebServiceImplPort).%New()
	s ResOutput=EINvWebService.dzfpHandler(InputXML)
	b ;ResOutput
	;开具成功之后然后保存数据
	;解析返回结果 
    s rtn=..ESetInvResultOfInvoice(ObjInvUpDetail, ResOutput,InvociePam)
	q:rtn'="0" InvociePam.ErrMsgInfo="调用接口成功,保存结果失败"
	
	q rtn
}

/// 组织开具返回值
ClassMethod ESetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, XMLRes As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn="-1"
	b ;解析12
	set XMLRes=$ZCVT(XMLRes,"O","UTF8")
	set tDocument=""
	set tSC=##class(%XML.XPATH.Document).CreateFromString(XMLRes, .tDocument)
	s tRes=""
	set tSC=tDocument.EvaluateExpression("/interface/returnStateInfo/returnCode","text()",.tRes)
	s ObjInvUpDetail.IUDResultCode=tRes.GetAt(1).Value   	;返回代码 0成功，其它失败
	set tSC=tDocument.EvaluateExpression("/interface/returnStateInfo/returnMessage","text()",.tRes)
	s ObjInvUpDetail.IUDResultMeg=tRes.GetAt(1).Value		;返回信息
	q:ObjInvUpDetail.IUDResultCode'="0000" "-1"	//失败则退出
	
	
	set tSC=tDocument.EvaluateExpression("/interface/Data/content/RESPONSE_FPKJ_NEW/FP_DM","text()",.tRes)
	s ObjInvUpDetail.IUDBillBatchCode=tRes.GetAt(1).Value		;发票代码
	set tSC=tDocument.EvaluateExpression("/interface/Data/content/RESPONSE_FPKJ_NEW/FP_HM","text()",.tRes)
	s ObjInvUpDetail.IUDBillBatchNo=tRes.GetAt(1).Value			;发票号码
	set tSC=tDocument.EvaluateExpression("/interface/Data/content/RESPONSE_FPKJ_NEW/JYM","text()",.tRes)
	s ObjInvUpDetail.IUDCheckCode=tRes.GetAt(1).Value			;校验码
	
	set tSC=tDocument.EvaluateExpression("/interface/Data/content/RESPONSE_FPKJ_NEW/PDF_URL","text()",.tRes)
	s ObjInvUpDetail.IUDPictureUrl=tRes.GetAt(1).Value		;PDF文件路径

	b //对返回结果的时间戳进行分割
	set tSC=tDocument.EvaluateExpression("/interface/Data/content/RESPONSE_FPKJ_NEW/KPRQ","text()",.tRes)
	s kprq=tRes.GetAt(1).Value
	s createDate=$e(kprq,1,4)_"-"_$e(kprq,5,6)_"-"_$e(kprq,7,8)
	s createTime=$e(kprq,9,10)_":"_$e(kprq,11,12)_":"_$e(kprq,13,14)	
	s ObjInvUpDetail.IUDCreatDate=$zdh(createDate,3)					;票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$zth(createTime)						;票据生成时间
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                	;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"										;发票状态
	s ObjInvUpDetail.IUDPrintType="E"									;纸质票据
	s ObjInvUpDetail.IUDPrintFlag="1"									;是否打印纸质票据
	if (InvociePam.PathCode="InvalidInv")||(InvociePam.PathCode="InvalidInvSvr") d
	.s ObjInvUpDetail.EInvFlg="S"										;发票状态
	.s ObjInvUpDetail.IUDResultMeg="红冲成功"   							;查询状态 信息是否成功
	q "0"
}

/// 组织开具返回值
ClassMethod PSetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, XMLRes As %String, ByRef InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn="-1"
	b ;解析12
	set XMLRes=$ZCVT(XMLRes,"O","UTF8")
	set tDocument=""
	set tSC=##class(%XML.XPATH.Document).CreateFromString(XMLRes, .tDocument)
	s tRes=""
	set tSC=tDocument.EvaluateExpression("/service/err/refp/RETCODE","text()",.tRes)
	s ObjInvUpDetail.IUDResultCode=tRes.GetAt(1).Value   	;返回代码 0成功，其它失败

	set tSC=tDocument.EvaluateExpression("/service/err/refp/RETMSG","text()",.tRes)
	s ObjInvUpDetail.IUDResultMeg=tRes.GetAt(1).Value		;返回信息
	
	i ObjInvUpDetail.IUDResultCode'="4011" d
	.s InvociePam.ErrMsgInfo=ObjInvUpDetail.IUDResultMeg
	q:ObjInvUpDetail.IUDResultCode'="4011" rtn	//失败则退出
	
	set tSC=tDocument.EvaluateExpression("/service/err/refp/FPDM","text()",.tRes)
	s ObjInvUpDetail.IUDBillBatchCode=tRes.GetAt(1).Value		;发票代码
	
	set tSC=tDocument.EvaluateExpression("/service/err/refp/FPHM","text()",.tRes)
	s ObjInvUpDetail.IUDBillBatchNo=tRes.GetAt(1).Value			;发票号码
	
	//set tSC=tDocument.EvaluateExpression("/service/err/refp/JYM","text()",.tRes)
	//s ObjInvUpDetail.IUDCheckCode=tRes.GetAt(1).Value			;校验码
	
	;set tSC=tDocument.EvaluateExpression("/interface/Data/content/RESPONSE_FPKJ_NEW/PDF_URL","text()",.tRes)
	;s ObjInvUpDetail.IUDBillPictureData=tRes.GetAt(1).Value		;PDF文件路径

	b //对返回结果的时间戳进行分割
	set tSC=tDocument.EvaluateExpression("/service/err/refp/KPRQ","text()",.tRes)
	s kprq=tRes.GetAt(1).Value
	s createDate=$p(kprq," ",1)   ;$e(kprq,1,4)_"-"_$e(kprq,5,6)_"-"_$e(kprq,7,8)
	s createTime=$p(kprq," ",2)   ;_":"_$e(kprq,11,12)_":"_$e(kprq,13,14)	
	s ObjInvUpDetail.IUDCreatDate=$zdh(createDate,3)					;票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$zth(createTime)						;票据生成时间
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                	;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"										;发票状态
	if ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo'=""  d
	.s ObjInvUpDetail.IUDResultMeg="红冲成功"   							;查询状态 信息是否成功
	.s ObjInvUpDetail.EInvFlg="S"										;发票状态
	s ObjInvUpDetail.IUDPrintType="P"									;纸质票据
	s ObjInvUpDetail.IUDPrintFlag="1"									;是否打印纸质票据
	s rtn="0"
	q rtn
}

/// 纸质发票开具接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invoice("","","") 
ClassMethod PInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, ByRef InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	;d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).Invoice开始")
	s RtnFlag="0"
	s InputXML=..PInvoiceCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:InputXML="" "-1"   ;组织入参发生错误
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).纸质发票开具:"_InputXML)
	
	b ;调用第三方接口开具纸质发票
	;b ;调用第三方webService服务
	
	s PINvWebService=##class(KpWebserviceC.PINVWebService.KpWebserviceCImplPort).%New()
	s ResOutput=PINvWebService.issueInvoice(InputXML)
	b ;ResOutput
	;开具成功之后然后保存数据
	;解析返回结果 
    s rtn=..PSetInvResultOfInvoice(ObjInvUpDetail, ResOutput,InvociePam)
	s:rtn'="0" InvociePam.ErrMsgInfo=ObjInvUpDetail.IUDResultMeg
    b ;poipopoop
    s RtnFlag=rtn	
	q RtnFlag
}

/*
/// 纸质发票打印接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invoice("","","") 
ClassMethod PPrint(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).Invoice开始")
	s RtnFlag="0"
	s InputXML=..PPrintCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:InputXML="" "-1"   ;组织入参发生错误
	
	
	b ;调用第三方接口开具纸质发票
	;b ;调用第三方webService服务
	s PINvWebService=##class(KpWebserviceC.PINVWebService.KpWebserviceCImplPort).%New()
	s ResOutput=PINvWebService.printInvoice(InputXML)
	b ;ResOutput
	;打印结果
	;解析返回结果 
    s rtn=..PSetInvResultOfPrint(ObjInvUpDetail, ResOutput)

	
	s RtnFlag=rtn
	q RtnFlag
}
*/
/// 组织开具返回值
ClassMethod PSetInvResultOfPrint(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, XMLRes As %String) As %String
{
	s rtn="-1"
	b ;解析12
	set XMLRes=$ZCVT(XMLRes,"O","UTF8")
	set tDocument=""
	set tSC=##class(%XML.XPATH.Document).CreateFromString(XMLRes, .tDocument)
	s tRes=""
	set tSC=tDocument.EvaluateExpression("/service/err/refp/RETCODE","text()",.tRes)
	s ObjInvUpDetail.IUDResultCode=tRes.GetAt(1).Value   	;返回代码 0成功，其它失败
	set tSC=tDocument.EvaluateExpression("/service/err/refp/RETMSG","text()",.tRes)
	s ObjInvUpDetail.IUDResultMeg=tRes.GetAt(1).Value		;返回信息
	q:ObjInvUpDetail.IUDResultCode'="5011" "-1"	//失败则退出
	
	q "0"
}

/// 功能描述：纸质发票红冲接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invalid("","","") 
ClassMethod PInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	s InputXML=..PInvalidCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:InputXML="" RtnFlag 
	
	b ;调用第三方接口开具纸质发票
	;b ;调用第三方webService服务
	s PINvWebService=##class(KpWebserviceC.PINVWebService.KpWebserviceCImplPort).%New()
	s ResOutput=PINvWebService.invalidInvoice(InputXML)
	b ;ResOutput
	;打印结果
	;解析返回结果 
    s rtn=..PSetInvResultOfvaild(ObjInvUpDetail, ResOutput)

	s RtnFlag=rtn
	q RtnFlag
}

/// 整理红冲数据
ClassMethod PSetInvResultOfvaild(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, XMLRes As %String)
{
	
    s rtn="-1"
	b ;解析12
	set XMLRes=$ZCVT(XMLRes,"O","UTF8")
	set tDocument=""
	set tSC=##class(%XML.XPATH.Document).CreateFromString(XMLRes, .tDocument)
	s tRes=""
	set tSC=tDocument.EvaluateExpression("/service/err/refp/RETCODE","text()",.tRes)
	s ObjInvUpDetail.IUDResultCode=tRes.GetAt(1).Value   	;返回代码 0成功，其它失败
	
	q:ObjInvUpDetail.IUDResultCode'="6011" "-1"	//失败则退出
	set tSC=tDocument.EvaluateExpression("/service/err/refp/RETMSG","text()",.tRes)
	s ObjInvUpDetail.IUDResultMeg=tRes.GetAt(1).Value		;返回信息
	
	
	
	set tSC=tDocument.EvaluateExpression("/service/err/refp/FPDM","text()",.tRes)
	s ObjInvUpDetail.IUDBillBatchCode=tRes.GetAt(1).Value		;发票代码
	set tSC=tDocument.EvaluateExpression("/service/err/refp/FPHM","text()",.tRes)
	s ObjInvUpDetail.IUDBillBatchNo=tRes.GetAt(1).Value		;发票号码

	s ObjInvUpDetail.IUDCreatDate=+$h					;票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)						;票据生成时间
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                	;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="红冲成功"   							;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="S"										;发票状态
	s ObjInvUpDetail.IUDPrintType="P"									;纸质票据
	s ObjInvUpDetail.IUDPrintFlag="1"									;是否打印纸质票据
	
	q "0"	
	
	q RtnFlag
}

/// 纸质发票打印接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invoice("","","") 
ClassMethod PPrint(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, QDFlag As %String) As %String
{
	;d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).Invoice开始")
	s RtnFlag="0"
	
	s InputXML=..PPrintCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam,QDFlag)
	q:InputXML="" "-1"   ;组织入参发生错误
	
	
	b ;调用第三方接口开具纸质发票
	;b ;调用第三方webService服务
	s ResOutput=""
	s PINvWebService=##class(KpWebserviceC.PINVWebService.KpWebserviceCImplPort).%New()
	i QDFlag="" d
	.s ResOutput=PINvWebService.printInvoice(InputXML)
	else  d
	.s ResOutput=PINvWebService.printList(InputXML)
	b ;ResOutput
	;打印结果
	;解析返回结果 
    s rtn=..PSetInvResultOfPrint(ObjInvUpDetail, ResOutput)

	
	s RtnFlag=rtn
	q RtnFlag
}

/// 组织电子票据开具接口参数 
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：电子票据XML串
/// 其    他：w ##class(BILL.EINV.ADP.HBA).EInvoiceCom("","","") 
ClassMethod EInvoiceCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	;外部报文参数组织
	;
	
	;s GlobalObj.authorizationCode="SYPRTYJ91G" 
	;组织发票开具信息中的context中的开具信息 
	;
	s ReqComFPKJObj=##class(BILL.EINV.DTO.HBA.EReqComFPKJ).%New()
	s ReqComFPKJObj.class="REQUEST_FPKJXX"
	
	s ComFPKJFObj=##class(BILL.EINV.DTO.HBA.EComFPKJFPTXX).%New()
	s ComFPKJFObj.class="FPKJXX_FPTXX"
	s ComFPKJFObj.FPQQLSH=ObjInvUpDetail.IUDBusNo   ;发票请求唯一流水号
	s ComFPKJFObj.DSPTBM="puSLvh95"    ;平台编码
	s ComFPKJFObj.NSRSBH="130100999999166"     ;销方纳税人识别号
	s ComFPKJFObj.NSRMC="航信培训企业166"      ;销方名称  
	s ComFPKJFObj.NSRDZDAH=""   ;销方电子档案号
	s ComFPKJFObj.SWJGDM=""     ;税务机构代码
	s ComFPKJFObj.DKBZ="1"      ;代开标志(1：自开（0）；2：代开（1）；默认为自开)
	s ComFPKJFObj.PYDM="000001”"      ;票样代码
	b ;;明细
	s ComFPKJFObj.KPXM="西药费"   ;ObjInvPrtInfo.InvItmDetInfo.GetAt(0).TarDesc      ;主要开票项目(主要开票商品，建议取项目信息中第一条数据的项目名称)
	s ComFPKJFObj.XHFNSRSBH="130100999999166"   ;销方纳税人识别号
	s ComFPKJFObj.XHFMC="航信培训企业166"     ;销方名称
	s ComFPKJFObj.XHFDZ=""    ;销方地址
	s ComFPKJFObj.XHFDH=""    ;销方电话
	s ComFPKJFObj.XHFYHZH=""   ;销方银行账号
	s ComFPKJFObj.XHFWX=""      ;销方微信
	s ComFPKJFObj.GHFMC=ObjInvPrtInfo.PatBaseInfo.PatName    ;购方名称
	s ComFPKJFObj.GHFNSRSBH=""  ;购货方纳税人识别号
	s ComFPKJFObj.GHFSF=""       ;购货方省份
	s ComFPKJFObj.GHFDZ=ObjInvPrtInfo.PatBaseInfo.Address      ;购货方地址
	s ComFPKJFObj.GHFGDDH=ObjInvPrtInfo.PatBaseInfo.Mobphone    ;购货方固定电话
	s ComFPKJFObj.GHFSJ=ObjInvPrtInfo.PatBaseInfo.Mobphone   ; 购货方手机
	s ComFPKJFObj.GHFEMAIL=ObjInvPrtInfo.PatBaseInfo.PatEmail   ;购货方邮箱
	s ComFPKJFObj.GHFQYLX="03"  ;购货方企业类型   (01：企业02：机关事业单位03：个人04：其他)
	s ComFPKJFObj.GHFYHZH=""   ;购货方银行账号
	s ComFPKJFObj.GHFWX=""     ;购货方微信 
	s ComFPKJFObj.HYDM=""      ;行业代码
	s ComFPKJFObj.HYMC=""      ;行业名称
	s ComFPKJFObj.KPDBH=InvociePam.UserCode     ;开票点编号
	s ComFPKJFObj.KPY=InvociePam.UserDesc      ;开票员
	s ComFPKJFObj.SKY=ObjInvPrtInfo.BusUserDesc     ;收款员
	s ComFPKJFObj.FHR=InvociePam.UserDesc      ;复核人
	s ComFPKJFObj.KPRQ=$zd(+$h,3)_" "_$zt($p($h,",",2),1)     ;开票日期    ;格式YYYY-MM-DDHH:MI:SS（由开票系统生成）
	s ComFPKJFObj.KPLX="0"     ;开票类型(0：正票1：红票)
	s ComFPKJFObj.YFPDM=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode   ;原发票代码
	s ComFPKJFObj.YFPHM=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo    ;原发票号码
	s ComFPKJFObj.CZDM="10"     ;操作代码（10：正票正常开具11：正票错票重开20：退货折让红票21：错票重开红票）
	s ComFPKJFObj.CHYY=""     ;冲红原因
	i ComFPKJFObj.YFPDM'=""  d
	.s ComFPKJFObj.CHYY="患者要求"
	s ComFPKJFObj.TSCHBZ=""   ;特殊冲红标志
	s ComFPKJFObj.KPHJJE=$fn(+ObjInvPrtInfo.InvShareAmt,"",2)   ;价税合计金额
	s ComFPKJFObj.HJBHSJE=$fn(+ObjInvPrtInfo.InvShareAmt,"",2)  ;合计不含税金额
	s ComFPKJFObj.HJSE=$fn(+ObjInvPrtInfo.InvShareAmt,"",2)     ;合计税额
	s ComFPKJFObj.BMBBBH="33.0"   ;编码表版本号（目前为33.0）
	s ComFPKJFObj.QDBZ="0"     ;清单标识(0：普通电子发票4：成品油电子发票)
	s ComFPKJFObj.QDXMMC=""   ;清单发票项目名称(可不填，暂不作处理)
	s ComFPKJFObj.BZ=""       ;备注
	s ComFPKJFObj.BYZD1=""    ;备用字段1
	s ComFPKJFObj.BYZD2=""    ;备用字段2
	s ComFPKJFObj.BYZD3=""    ;备用字段3
	s ComFPKJFObj.BYZD4=""    ;备用字段4
	s ComFPKJFObj.BYZD5=""    ;备用字段5
	s ReqComFPKJObj.ComFPKJFPT=ComFPKJFObj
	
	b ;;;项目明细
	s ComFPKJXMXXSObj=##class(BILL.EINV.DTO.HBA.EComFPKJXMXXS).%New()
	s ComFPKJXMXXSObj.class="FPKJXX_XMXX"
	s ComFPKJXMXXSObj.size="1"
	
	for i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	.s ComFPKJXMXXObj=##class(BILL.EINV.DTO.HBA.EComFPKJXMXX).%New()
	.s ComFPKJXMXXObj.XMMC=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc   ;项目名称
	.s ComFPKJXMXXObj.XMDW=""   ;项目单位
	.s ComFPKJXMXXObj.GGXH=""   ;规格型号
	.s ComFPKJXMXXObj.XMSL="1"   ;项目数量
	.s ComFPKJXMXXObj.HSBZ=""   ;;含税标志
	.s ComFPKJXMXXObj.XMDJ=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt   ;项目单价
	.s ComFPKJXMXXObj.XMBM=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code   ;项目编码
	.s ComFPKJXMXXObj.XMJE=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt   ;项目金额
	.s ComFPKJXMXXObj.SL=""     ;税率
	.s ComFPKJXMXXObj.SE=""     ;税额
	.s ComFPKJXMXXObj.FPHXZ=""  ;;发票行性质
	.s ComFPKJXMXXObj.SPBM=""   ;商品编码
	.s ComFPKJXMXXObj.ZXBM=""   ;自行编码
	.s ComFPKJXMXXObj.YHZCBS=""  ;优惠政策标识
	.s ComFPKJXMXXObj.LSLBS=""   ;零税率标识
	.s ComFPKJXMXXObj.ZZSTSGL=""  ;增值税特殊管理
	.s ComFPKJXMXXObj.BYZD1=""    ;备用字段1
	.s ComFPKJXMXXObj.BYZD2=""    ;备用字段2
	.s ComFPKJXMXXObj.BYZD3=""    ;备用字段3
	.s ComFPKJXMXXObj.BYZD4=""    ;备用字段4
	.s ComFPKJXMXXObj.BYZD5=""    ;备用字段5
	.d ComFPKJXMXXSObj.EComFPKJXMXX.Insert(ComFPKJXMXXObj)
	s ReqComFPKJObj.EComFPKJDDMXXXS=ComFPKJXMXXSObj
	
	;订单信息
	s DDXXObj=##class(BILL.EINV.DTO.HBA.EComFPKJDDXX).%New()
	s DDXXObj.class="FPKJXX_DDXX"
	s DDXXObj.DDH=""    ;订单号
	s DDXXObj.THDH=""   ;退货单号
	s DDXXObj.DDDATE=""  ;订单时间
	s ReqComFPKJObj.EComFPKJDDXX=DDXXObj
	
	
	;订单明细信息
	s DDMXXXSObj=##class(BILL.EINV.DTO.HBA.EComFPKJDDMXXXS).%New()
	s DDMXXXSObj.class="FPKJXX_DDMXXX"
	s DDMXXXSObj.size="1"
	for i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	.s DDMXXXObj=##class(BILL.EINV.DTO.HBA.EComFPKJDDMXXX).%New()
	.s DDMXXXObj.DDMC=""    ;订单名称
	.s DDMXXXObj.DW=""      ;单位
	.s DDMXXXObj.GGXH=""    ;规格型号
	.s DDMXXXObj.SL=""      ;数量
	.s DDMXXXObj.DJ=""      ;单价
	.s DDMXXXObj.JE=""      ;金额
	.s DDMXXXObj.BYZD1=""    ;备用字段1
	.s DDMXXXObj.BYZD2=""    ;备用字段2
	.s DDMXXXObj.BYZD3=""    ;备用字段3
	.s DDMXXXObj.BYZD4=""    ;备用字段4
	.s DDMXXXObj.BYZD5=""    ;备用字段5
	.d DDMXXXSObj.EComFPKJDDMXXX.Insert(DDMXXXObj)
	s ReqComFPKJObj.EComFPKJDDMXXXS=DDMXXXSObj
	
	
	;;支付信息
	s ZFXXObj=##class(BILL.EINV.DTO.HBA.EComFPKJZFXX).%New()
	s ZFXXObj.class="FPKJXX_ZFXX"
	s ZFXXObj.ZFFS=""    ; 支付方式
	s ZFXXObj.ZFLSH=""   ;支付流水号
	s ZFXXObj.ZFPT=""    ;支付平台
	s ReqComFPKJObj.EComFPKJZFXX=ZFXXObj
	
	
	;;物流信息
	s WLXXObj=##class(BILL.EINV.DTO.HBA.EComFPKJWLXX).%New()
	s WLXXObj.class="FPKJXX_WLXX"
	s WLXXObj.CYGS=""     ;承运公司
	s WLXXObj.SHSJ=""     ;送货时间
	s WLXXObj.WLDH=""     ;物流单号
	s WLXXObj.SHDZ=""     ;送货地址
	s ReqComFPKJObj.EComFPKJWLXX=WLXXObj
	;b ;12323
	q ReqComFPKJObj
	/*
	s InputPamStream=""
	d ReqComFPKJObj.XMLExportToString(.InputPamStream)     ;生成xml字符串
	
	q:InputPamStream="" rtn
	;s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
    b ;xml
    ;
    q InputPamStream
    */
}

/// 组纸质票据开具接口参数
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：纸质票据XML串
/// 其    他：w ##class(BILL.EINV.ADP.HBA).PInvoiceCom("","","") 
ClassMethod PInvoiceCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	s InsTypeDRMZ=""  //门诊
	s InsTypeDRZY=""  //住院
	//票据信息
	s invobj=##class(BILL.EINV.DTO.HBA.PInvInvoiceReq).%New()
	s invobj.sid="1"
	s invobj.ip=$ZU(67,15,$j)
	s invobj.port="8888"
	
	s dataObj=##class(BILL.EINV.DTO.HBA.PInvInvoiceData).%New()
	s dataObj.count="2"
	s recordObj=##class(BILL.EINV.DTO.HBA.PInvRecordInfo).%New()

	s fpObj=##class(BILL.EINV.DTO.HBA.PInvFPInfo).%New()
	s fpObj.FPZL="2"         ;发票种类（固定值：0：专用发票 2：普通发票12：机动车票51：电子发票）
	s fpObj.GFMC="" ;##class(web.UDHCOPINVPrtData12).GetINVShopInfo("",ObjInvUpDetail.IUDInvDr,"G")         ;购方名称
	s fpObj.GFSH=ObjInvPrtInfo.PatBaseInfo.PatID   //liutang 2020-08-14   患者身份证号                                 ;购方税号	
	s fpObj.GFDZDH=ObjInvPrtInfo.PatBaseInfo.Mobphone ;购方地址及电话
	s fpObj.GFYHZH="" ;购方银行及账户
	b ;;490
	
	
	//s ^temp("liutang222") = InsTypeDR
	b ; 493333
	i ObjInvUpDetail.IUDPayAdmType="IP" d  //住院
	.s InsTypeDRZY=$p(^DHCINVPRTZY(ObjInvUpDetail.IUDInvDr),"^",9)
	.i ((InsTypeDRZY="22") || (InsTypeDRZY="20") || (InsTypeDRZY="24")) d  //兼容国家医保发票  2021-12-25
	..s fpObj.GFMC = ##class(web.UDHCOPINVPrtData12).GetINVShopInfo00A("",ObjInvUpDetail.IUDInvDr,"G") 	;购货单位名称
    ..s fpObj.GFDZDH=##class(web.UDHCOPINVPrtData12).GetINVShopInfo00A("",ObjInvUpDetail.IUDInvDr,"A") 	;购货单位地址电话N
    ..s fpObj.GFYHZH=##class(web.UDHCOPINVPrtData12).GetINVShopInfo00A("",ObjInvUpDetail.IUDInvDr,"K")	;购货单位银行帐号N
    .e  d
    ..b ;55678888888
    ..s fpObj.GFMC = ##class(web.UDHCOPINVPrtData12).GetINVShopInfo("",ObjInvUpDetail.IUDInvDr,"G") 	;购货单位名称
    ..s fpObj.GFDZDH=##class(web.UDHCOPINVPrtData12).GetINVShopInfo("",ObjInvUpDetail.IUDInvDr,"A") 	;购货单位地址电话N
    ..s fpObj.GFYHZH=##class(web.UDHCOPINVPrtData12).GetINVShopInfo("",ObjInvUpDetail.IUDInvDr,"K")	;购货单位银行帐号N
    e  d   //门诊
    .s InsTypeDRMZ=$p(^DHCINVPRT(ObjInvUpDetail.IUDInvDr),"^",9)
    .i ((InsTypeDRMZ="22") || (InsTypeDRMZ="20")) d
    ..s fpObj.GFMC = ##class(web.UDHCOPINVPrtData12).GetINVShopInfo00A(ObjInvUpDetail.IUDInvDr,"","G") 		;购货单位名称
    ..s fpObj.GFDZDH=##class(web.UDHCOPINVPrtData12).GetINVShopInfo00A(ObjInvUpDetail.IUDInvDr,"","A") 	;购货单位地址电话N
    ..s fpObj.GFYHZH=##class(web.UDHCOPINVPrtData12).GetINVShopInfo00A(ObjInvUpDetail.IUDInvDr,"","K")	;购货单位银行帐号N	
    .e  d
    ..s fpObj.GFMC = ##class(web.UDHCOPINVPrtData12).GetINVShopInfo(ObjInvUpDetail.IUDInvDr,"","G") 		;购货单位名称
    ..s fpObj.GFDZDH=##class(web.UDHCOPINVPrtData12).GetINVShopInfo(ObjInvUpDetail.IUDInvDr,"","A") 	;购货单位地址电话N
    ..s fpObj.GFYHZH=##class(web.UDHCOPINVPrtData12).GetINVShopInfo(ObjInvUpDetail.IUDInvDr,"","K")	;购货单位银行帐号N	
    
    ;add  20200817 从不上传界面获取开票信息
    i InvociePam.EinvName'="" d
    .s fpObj.GFMC=InvociePam.EinvName
    i InvociePam.BussNO'="" d
    .s fpObj.GFSH=InvociePam.BussNO
    i InvociePam.AddRess'="" d
    .s fpObj.GFDZDH=InvociePam.AddRess
    i InvociePam.EINBank'="" d
    .s fpObj.GFYHZH=InvociePam.EINBank

	;增加备注信息传医保支付方式金额
	if ObjInvUpDetail.IUDPayAdmType="IP"  d
	.i ((InsTypeDRZY="22")||(InsTypeDRZY="20")|| (InsTypeDRZY="24")) d 
	..s fpObj.BZ=##class(web.UDHCOPINVPrtData12).GetINSUYBInfo00A("",ObjInvUpDetail.IUDInvDr)
	.e  d
	..s fpObj.BZ=##class(web.UDHCOPINVPrtData12).GetINSUYBInfo("",ObjInvUpDetail.IUDInvDr)   
	else   d
	.i ((InsTypeDRMZ="22")||(InsTypeDRMZ="20")) d
	..s fpObj.BZ=##class(web.UDHCOPINVPrtData12).GetINSUYBInfo00A(ObjInvUpDetail.IUDInvDr,"")
	.e  d
	..s fpObj.BZ=##class(web.UDHCOPINVPrtData12).GetINSUYBInfo(ObjInvUpDetail.IUDInvDr,"") 
	if ObjInvPrtInfo.InvAmt<0  d
	.s fpObj.BZ="对应正数发票代码:"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode_",号码:"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo    
	;s fpObj.BZ=""      ;备注
	s fpObj.SKR=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_SKR", 5)     ;收款人
	s fpObj.FHR=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_FHR", 5)    ;复核人      ????测试复核人暂时取收款人，上线和医院确定复核人
	s fpObj.KPR=InvociePam.UserDesc    ;开票人
	s fpObj.XFYHZH=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_YHZH", 5)  ;销方银行及账户
	s fpObj.XFDZDH=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_DZDH", 5)  ;销方地址及电话
	s fpObj.QDBZ="0"    ;清单标志（固定值0：不开具清单1：开具清单）  ？？？是否开具清单，医院确定，，测试暂时不开具清单
	i ObjInvPrtInfo.InvItmDetInfo.Size>8 d
	.s fpObj.QDBZ="1"
	s fpObj.XSDJBH=""  ;销售单据编号（该字段的内容保存于开票客户端中，不做逻辑处理，内容不做限制，由接口调用方根据需要填写内容）
	s fpObj.KPBZ="0"    ;开票标志（固定值0：开票1：校验）
	s fpObj.JPGG=""    ;卷票规格
	s recordObj.fp=fpObj
	
	b //清单项目明细ObjInvPrtInfo.InvItmDetInfo.Size
	s GroupObj=##class(BILL.EINV.DTO.HBA.PInvFPGroup).%New()
	if (ObjInvUpDetail.IUDPayAdmType="IP")  
	{
	f i=1:1:ObjInvPrtInfo.InvCateInfo.Size d
	.s fpmxObj=##class(BILL.EINV.DTO.HBA.PInvFPGroupFpmxInfo).%New()
	.s fpmxObj.SPMC=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc    ;商品名称
	.s fpmxObj.HSBZ="0"                        ;含税标志(0：不含税1：含税)
	.s fpmxObj.SLV="0"                                       ;税率	税率暂时定于0，测试时和医院确定
	.s fpmxObj.JE=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt    ;金额
	.s fpmxObj.DJ="" // 2021-04-06 董金菊要求单价传空不显示,只显示金额。 ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt   ;单价
	.s fpmxObj.JLDW=""        ;计量单位
	.s fpmxObj.GGXH=""        ;规格型号
	.s fpmxObj.SE="0"          ;税额
	.s fpmxObj.SL=""          ;数量 // 2021-04-06 董金菊要求数量传空不显示，只显示金额。
	.s fpmxObj.BMBBH="35.0"       ;编码版本号
	.s fpmxObj.SSFLBM="3070202000000000000"     ;税收分类编码
	.s fpmxObj.YHZC="1"       ;是否享受优惠政策（固定值0：不享受1：享受） 测试时和医院确定
	.s fpmxObj.YHZCNR="免税"     ;享受优惠政策内容
	.s fpmxObj.LSLBS="1"      ;零税率标识
	.s fpmxObj.QYZBM=""      ;企业自编码
	.s fpmxObj.KCE=""        ;扣除额
	.d GroupObj.fpmx.Insert(fpmxObj)
	}else {
	f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size d
	.s fpmxObj=##class(BILL.EINV.DTO.HBA.PInvFPGroupFpmxInfo).%New()
	.s fpmxObj.SPMC=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc    ;商品名称
	.s fpmxObj.HSBZ="0"                        ;含税标志(0：不含税1：含税)
	.s fpmxObj.SLV="0"                                       ;税率	税率暂时定于0，测试时和医院确定
	.s fpmxObj.JE=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt    ;金额
	.s fpmxObj.DJ=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price   ;单价
	.s fpmxObj.JLDW=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit        ;计量单位
	.s fpmxObj.GGXH=""        ;规格型号
	.s fpmxObj.SE="0"          ;税额
	.s fpmxObj.SL=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty          ;数量
	.s fpmxObj.BMBBH="35.0"       ;编码版本号
	.s fpmxObj.SSFLBM="3070202000000000000"     ;税收分类编码
	.s fpmxObj.YHZC="1"       ;是否享受优惠政策（固定值0：不享受1：享受） 测试时和医院确定
	.s fpmxObj.YHZCNR="免税"     ;享受优惠政策内容
	.s fpmxObj.LSLBS="1"      ;零税率标识
	.s fpmxObj.QYZBM=""      ;企业自编码
	.s fpmxObj.KCE=""        ;扣除额
	.d GroupObj.fpmx.Insert(fpmxObj)
	}
	s recordObj.group=GroupObj
	s dataObj.record=recordObj
	s invobj.data=dataObj
	
	s InputPamStream=""
	;d EInvInMsg.XMLExportToStream(.InputPamStream)
	;d EInvOutMsg.XMLExportToStream(.InputPamStream)    ;生成xml字符流
	;q:$isobject(InputPamStream)=0 rtn
	d invobj.XMLExportToString(.InputPamStream)     ;生成xml字符串
	;w InputPamStream.OutputToDevice()
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数
	q InputPamStream
}

/// 组织纸质红冲接口参数
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：红冲票据XML串
/// 其    他：w ##class(BILL.EINV.ADP.HBA).PInvalidCom("","","") 
ClassMethod PInvalidCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	;d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).EInvalid开始.")
	s rtn=""
	
	b //票据信息
	s invobj=##class(BILL.EINV.DTO.HBA.PInvValidService).%New()
	s invobj.sid="4"
	s invobj.ip=$ZU(67,15,$j)
	i invobj.ip="10.30.2.115" d
	.s invobj.ip="10.20.9.26"
	s invobj.port="8888"
	
	s dataObj=##class(BILL.EINV.DTO.HBA.PInvValidData).%New()
	s dataObj.count="2"
	s recordObj=##class(BILL.EINV.DTO.HBA.PInvValidRecordInfo).%New()
    s recordObj.FPZL="2"    ;发票种类（固定值：0：专用发票 2：普通发票12：机动车票51：电子发票）
    s recordObj.FPHM=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo  ;发票号码
    s recordObj.FPDM=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode    ;发票代码
	s dataObj.record=recordObj
	s invobj.data=dataObj
	
	s InputPamStream=""
	;d EInvInMsg.XMLExportToStream(.InputPamStream)
	;d EInvOutMsg.XMLExportToStream(.InputPamStream)    ;生成xml字符流
	;q:$isobject(InputPamStream)=0 rtn
	d invobj.XMLExportToString(.InputPamStream)     ;生成xml字符串
	;w InputPamStream.OutputToDevice()
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
	q InputPamStream
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).EInvalid结束.Rtn=")
	q Rtn
}

/// 组织纸质红冲接口参数
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：红冲票据XML串
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invalid("","","") 
ClassMethod EPrintCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).EInvalid开始.")
	
	
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).EInvalid结束.Rtn=")
	q RtnFlag
}

/// 电子外部报文
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.HBA).EINVOutInfo("","","") 
ClassMethod EINVOutInfo(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, PathCode As %String) As %String
{
	s rtn=""
	//票据信息
	s invobj=##class(BILL.EINV.DTO.HBA.EInterfaceReq).%New()
	s GlobalObj=##class(BILL.EINV.DTO.HBA.EInvGlobalReq).%New()    ;全局信息
	s GlobalObj.terminalCode="0"   ;终端类型标识(0:B/S请求来源；1:C/S请求来源)
	s GlobalObj.appId="DZFP"
	s GlobalObj.version="2.0"   ;接口版本
	s GlobalObj.interfaceCode="ECXML.FPKJ.BC.E_INV"   ;接口编码
	s GlobalObj.userName="cpBOV0yu"        ;平台编码    ？？？测试编码  
	s GlobalObj.passWord="9946678345NDc4MTdiZWU5MjVmZjdmZg=="        ;10位随机数+Base64({(10位随机数+userName）MD5（小写16位）})
	s GlobalObj.taxpayerId="91130200MA07X36BXK"      ;纳税人识别号    liutang
	s GlobalObj.authorizationCode="PU4MZAJWWX"  ;接入系统平台授权码（由平台提供） ？？？ 测试编码
	s GlobalObj.requestCode="cpBOV0yu"    ;数据交换请求发出方代码
	s GlobalObj.requestTime=$zd(+$h,3)_" "_$zt($p($h,",",2),1)    ;数据交换请求发出时间
	s GlobalObj.responseCode=""   ;数据交换请求接受方代码
	s GlobalObj.dataExchangeId=ObjInvUpDetail.IUDBusNo  ;数据交换流水号
	s GlobalObj.fjh=""      ;分机号
	s GlobalObj.jqbh=""      ;机器编号
	s GlobalObj.ygid=""      ;员工id
	
	s ReturnObj=##class(BILL.EINV.DTO.HBA.EInvReturnReq).%New()   ;返回信息
	;(0000：成功9999：失败0001：蓝票已开具1001：红票已开具1900：设备正忙，稍后重新请求)
	s ReturnObj.returnCode=""   ;返回代码
	;(0000返回成功，其他返回错误描述，base64编码)
	s ReturnObj.returnMessage=""   ;base64返回描述
	
	s DataObj=##class(BILL.EINV.DTO.HBA.EInvDataReq).%New()  ;交换数据
	s DataDescriobj=##class(BILL.EINV.DTO.HBA.EInvdataDescription).%New()
	s DataDescriobj.zipCode="0"    ;(0，1根据数据包大小判断是否进行压缩)
	s DataDescriobj.encryptCode="0"   ;(加密方式代码，0表示不用任何加密)
	s DataDescriobj.codeType="0"      ;(三种加密方式代码，正式使用时通讯用CA)
	
	;根据传进来的pathcode确定交易类型,组织Context的值
	s Context=""
	;if PathCode="EInvoice" d        ;开电子票
	;.s Context=..EInvoiceCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	;.
	s EINVFPKJReqObj=##class(BILL.EINV.DTO.HBA.EINVFPKJReq).%New()
	
	s ReqComFPKJObj=##class(BILL.EINV.DTO.HBA.EReqComFPKJ).%New()
	s ReqComFPKJObj.class="REQUEST_FPKJXX"

	s ComFPKJFObj=##class(BILL.EINV.DTO.HBA.EComFPKJFPTXX).%New()
	s ComFPKJFObj.class="FPKJXX_FPTXX"
	s ComFPKJFObj.FPQQLSH=ObjInvUpDetail.IUDBusNo   ;发票请求唯一流水号
	s ComFPKJFObj.DSPTBM="cpBOV0yu"    ;平台编码
	s ComFPKJFObj.NSRSBH="91130200MA07X36BXK"     ;销方纳税人识别号   liutang
	s ComFPKJFObj.NSRMC="唐山市中心医院有限公司"      ;销方名称    liutang
	s ComFPKJFObj.NSRDZDAH=""   ;销方电子档案号
	s ComFPKJFObj.SWJGDM=""     ;税务机构代码
	s ComFPKJFObj.DKBZ="0"      ;代开标志(1：自开（0）；2：代开（1）；默认为自开)
	s ComFPKJFObj.PYDM="000001"      ;票样代码
	s ComFPKJFObj.KPXM="西药费"   ;ObjInvPrtInfo.InvItmDetInfo.GetAt(0).TarDesc      ;主要开票项目(主要开票商品，建议取项目信息中第一条数据的项目名称)
	s ComFPKJFObj.XHFNSRSBH="91130200MA07X36BXK"   ;销方纳税人识别号  liutang
	s ComFPKJFObj.XHFMC="唐山市中心医院有限公司"     ;销方名称   liutang
	s ComFPKJFObj.XHFDZ="河北省唐山市路北区友谊路西辅路以西，光明路东辅路以东，长宁道北辅路以北，龙富南道以南"    ;销方地址    liutang
	s ComFPKJFObj.XHFDH="0315-2833050"    ;销方电话
	s ComFPKJFObj.XHFYHZH="132350000012016004348"   ;销方银行账号
	s ComFPKJFObj.XHFWX=""      ;销方微信
	i ObjInvUpDetail.IUDPayAdmType="IP" d  //住院
    .s ComFPKJFObj.GHFMC = ##class(web.UDHCOPINVPrtData12).GetINVShopInfo("",ObjInvUpDetail.IUDInvDr,"G") 	;购货单位名称
    .s ComFPKJFObj.GHFDZ = ##class(web.UDHCOPINVPrtData12).GetINVShopInfo("",ObjInvUpDetail.IUDInvDr,"A") 	;购货单位地址电话N
    .s ComFPKJFObj.GHFYHZH = ##class(web.UDHCOPINVPrtData12).GetINVShopInfo("",ObjInvUpDetail.IUDInvDr,"K")	;购货单位银行帐号N
    e  d   //门诊
    .s ComFPKJFObj.GHFMC = ##class(web.UDHCOPINVPrtData12).GetINVShopInfo(ObjInvUpDetail.IUDInvDr,"","G") 		;购货单位名称
    .s ComFPKJFObj.GHFDZ = ##class(web.UDHCOPINVPrtData12).GetINVShopInfo(ObjInvUpDetail.IUDInvDr,"","A") 	;购货单位地址电话N
    .s ComFPKJFObj.GHFYHZH = ##class(web.UDHCOPINVPrtData12).GetINVShopInfo(ObjInvUpDetail.IUDInvDr,"","K")	;购货单位银行帐号N	
	;s ComFPKJFObj.GHFMC=ObjInvPrtInfo.PatBaseInfo.PatName    ;购方名称
	s ComFPKJFObj.GHFNSRSBH=ObjInvPrtInfo.PatBaseInfo.PatID  ;购货方纳税人识别号  //liutang  2020-10-30   患者身份证号   
	s ComFPKJFObj.GHFSF=""       ;购货方省份
	;s ComFPKJFObj.GHFDZ=ObjInvPrtInfo.PatBaseInfo.Address      ;购货方地址
	s ComFPKJFObj.GHFGDDH=ObjInvPrtInfo.PatBaseInfo.Mobphone    ;购货方固定电话
	s ComFPKJFObj.GHFSJ=ObjInvPrtInfo.PatBaseInfo.Mobphone   ; 购货方手机
	s ComFPKJFObj.GHFEMAIL=ObjInvPrtInfo.PatBaseInfo.PatEmail   ;购货方邮箱
	s ComFPKJFObj.GHFQYLX="03"  ;购货方企业类型   (01：企业02：机关事业单位03：个人04：其他)
	;s ComFPKJFObj.GHFYHZH=""   ;购货方银行账号
	s ComFPKJFObj.GHFWX=""     ;购货方微信 
	
	;;add  20200817 从不上传界面获取开票信息
    i InvociePam.EinvName'="" d
    .s ComFPKJFObj.GHFMC=InvociePam.EinvName
    i InvociePam.BussNO'="" d
    .s ComFPKJFObj.GHFNSRSBH=InvociePam.BussNO
    i InvociePam.AddRess'="" d
    .s ComFPKJFObj.GHFDZ=InvociePam.AddRess
    i InvociePam.EINBank'="" d
    .s ComFPKJFObj.GHFYHZH=InvociePam.EINBank
    
	s ComFPKJFObj.HYDM=""      ;行业代码
	s ComFPKJFObj.HYMC=""      ;行业名称
	s ComFPKJFObj.KPDBH=InvociePam.UserCode     ;开票点编号
	s ComFPKJFObj.KPY=InvociePam.UserDesc      ;开票员
	s ComFPKJFObj.SKY=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_SKR", 5)     ;收款人  ;ObjInvPrtInfo.BusUserDesc     ;收款员
	s ComFPKJFObj.FHR=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","XSF_FHR", 5) ;InvociePam.UserDesc      ;复核人
	s ComFPKJFObj.KPRQ=$zd(+$h,3)_" "_$zt($p($h,",",2),1)     ;开票日期    ;格式YYYY-MM-DDHH:MI:SS（由开票系统生成）
	s ComFPKJFObj.KPLX="0"     ;开票类型(0：正票1：红票)
	s ComFPKJFObj.YFPDM=""  ;原发票代码
	s ComFPKJFObj.YFPHM=""    ;原发票号码
	s ComFPKJFObj.CZDM="10"     ;操作代码（10：正票正常开具11：正票错票重开20：退货折让红票21：错票重开红票）
	s ComFPKJFObj.CHYY=""     ;冲红原因
	if ObjInvUpDetail.IUDPayAdmType="IP"  d
	.s ComFPKJFObj.BZ=##class(web.UDHCOPINVPrtData12).GetINSUYBInfo("",ObjInvUpDetail.IUDInvDr)   
	else   d
	.s ComFPKJFObj.BZ=##class(web.UDHCOPINVPrtData12).GetINSUYBInfo(ObjInvUpDetail.IUDInvDr,"") 
	if (InvociePam.PathCode="InvalidInv") || (InvociePam.PathCode="InvalidInv")  d
	.s ComFPKJFObj.KPLX="1"     ;开票类型(0：正票1：红票)
	.s ComFPKJFObj.YFPDM=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode   ;原发票代码
	.s ComFPKJFObj.YFPHM=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo    ;原发票号码
	.s ComFPKJFObj.CZDM="10"     ;操作代码（10：正票正常开具11：正票错票重开20：退货折让红票21：错票重开红票）
	.s ComFPKJFObj.CHYY=""     ;冲红原因
	.s ComFPKJFObj.CHYY="患者要求"
	.s ComFPKJFObj.BZ="对应正数发票代码:"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode_"号码:"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo      ;备注
	s ComFPKJFObj.TSCHBZ="0"   ;特殊冲红标志
	s ComFPKJFObj.KPHJJE=$fn(+ObjInvPrtInfo.InvShareAmt,"",2)   ;价税合计金额
	s ComFPKJFObj.HJBHSJE=$fn(ObjInvPrtInfo.InvShareAmt,"",2)    ;合计不含税金额
	s ComFPKJFObj.HJSE="0"  ;$fn(+ObjInvPrtInfo.InvAmt,"",2)    ;合计税额
	s ComFPKJFObj.BMBBBH="33.0"   ;编码表版本号（目前为33.0）
	s ComFPKJFObj.QDBZ="0"     ;清单标识(0：普通电子发票4：成品油电子发票)
	s ComFPKJFObj.QDXMMC=""   ;清单发票项目名称(可不填，暂不作处理)
	
	s ComFPKJFObj.BYZD1=""    ;备用字段1
	s ComFPKJFObj.BYZD2=""    ;备用字段2
	s ComFPKJFObj.BYZD3=""    ;备用字段3
	s ComFPKJFObj.BYZD4=""    ;备用字段4
	s ComFPKJFObj.BYZD5=""    ;备用字段5
	s ReqComFPKJObj.ComFPKJFPT=ComFPKJFObj
	
	
	b ;;;项目明细
	s ComFPKJXMXXSObj=##class(BILL.EINV.DTO.HBA.EComFPKJXMXXS).%New()
	s ComFPKJXMXXSObj.class="FPKJXX_XMXX;"
	s ComFPKJXMXXSObj.size=ObjInvPrtInfo.InvItmDetInfo.Size
	
	for i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.s ComFPKJXMXXObj=##class(BILL.EINV.DTO.HBA.EComFPKJXMXX).%New()
	.s ComFPKJXMXXObj.XMMC=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc   ;项目名称
	.s ComFPKJXMXXObj.XMDW=""   ;项目单位
	.s ComFPKJXMXXObj.GGXH=""   ;规格型号
	.s ComFPKJXMXXObj.XMSL=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty   ;项目数量
	.s ComFPKJXMXXObj.HSBZ="0"   ;;含税标志
	.s ComFPKJXMXXObj.XMDJ=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price   ;项目单价
	.s ComFPKJXMXXObj.XMBM=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode   ;项目编码
	.s ComFPKJXMXXObj.XMJE=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt   ;项目金额
	.s ComFPKJXMXXObj.SL="0"     ;税率
	.s ComFPKJXMXXObj.SE=""     ;税额
	.s ComFPKJXMXXObj.FPHXZ="0"  ;;发票行性质
	.s ComFPKJXMXXObj.SPBM="3070202000000000000"   ;商品编码  ？？测试暂时写死
	.s ComFPKJXMXXObj.ZXBM=""   ;自行编码
	.s ComFPKJXMXXObj.YHZCBS="1"  ;优惠政策标识
	.s ComFPKJXMXXObj.LSLBS="1"   ;零税率标识
	.s ComFPKJXMXXObj.ZZSTSGL="免税"  ;增值税特殊管理
	.s ComFPKJXMXXObj.BYZD1=""    ;备用字段1
	.s ComFPKJXMXXObj.BYZD2=""    ;备用字段2
	.s ComFPKJXMXXObj.BYZD3=""    ;备用字段3
	.s ComFPKJXMXXObj.BYZD4=""    ;备用字段4
	.s ComFPKJXMXXObj.BYZD5=""    ;备用字段5
	.d ComFPKJXMXXSObj.EComFPKJXMXX.Insert(ComFPKJXMXXObj)
	s ReqComFPKJObj.EComFPKJXMXXS=ComFPKJXMXXSObj
	
	;订单信息
	s DDXXObj=##class(BILL.EINV.DTO.HBA.EComFPKJDDXX).%New()
	s DDXXObj.class="FPKJXX_DDXX"
	s DDXXObj.DDH=""    ;订单号
	s DDXXObj.THDH=""   ;退货单号
	s DDXXObj.DDDATE=""  ;订单时间
	s ReqComFPKJObj.EComFPKJDDXX=DDXXObj
	
	
	;订单明细信息
	s DDMXXXSObj=##class(BILL.EINV.DTO.HBA.EComFPKJDDMXXXS).%New()
	s DDMXXXSObj.class="FPKJXX_DDMXXX;"
	s DDMXXXSObj.size="1"
	for i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	.s DDMXXXObj=##class(BILL.EINV.DTO.HBA.EComFPKJDDMXXX).%New()
	.s DDMXXXObj.DDMC=""    ;订单名称
	.s DDMXXXObj.DW=""      ;单位
	.s DDMXXXObj.GGXH=""    ;规格型号
	.s DDMXXXObj.SL=""      ;数量
	.s DDMXXXObj.DJ=""      ;单价
	.s DDMXXXObj.JE=""      ;金额
	.s DDMXXXObj.BYZD1=""    ;备用字段1
	.s DDMXXXObj.BYZD2=""    ;备用字段2
	.s DDMXXXObj.BYZD3=""    ;备用字段3
	.s DDMXXXObj.BYZD4=""    ;备用字段4
	.s DDMXXXObj.BYZD5=""    ;备用字段5
	.d DDMXXXSObj.EComFPKJDDMXXX.Insert(DDMXXXObj)
	s ReqComFPKJObj.EComFPKJDDMXXXS=DDMXXXSObj
	
	
	;;支付信息
	s ZFXXObj=##class(BILL.EINV.DTO.HBA.EComFPKJZFXX).%New()
	s ZFXXObj.class="FPKJXX_ZFXX"
	s ZFXXObj.ZFFS=""    ; 支付方式
	s ZFXXObj.ZFLSH=""   ;支付流水号
	s ZFXXObj.ZFPT=""    ;支付平台
	s ReqComFPKJObj.EComFPKJZFXX=ZFXXObj
	
	
	;;物流信息
	s WLXXObj=##class(BILL.EINV.DTO.HBA.EComFPKJWLXX).%New()
	s WLXXObj.class="FPKJXX_WLXX"
	s WLXXObj.CYGS=""     ;承运公司
	s WLXXObj.SHSJ=""     ;送货时间
	s WLXXObj.WLDH=""     ;物流单号
	s WLXXObj.SHDZ=""     ;送货地址
	s ReqComFPKJObj.EComFPKJWLXX=WLXXObj
	s EINVFPKJReqObj.FPKJXXFPTXX=ReqComFPKJObj
	b ;context
	s DataObj.content=EINVFPKJReqObj                    ;请求数据内容或返回数据内容
	s DataObj.dataDescription=DataDescriobj
	
	s invobj.globalInfo=GlobalObj
	s invobj.returnStateInfo=ReturnObj
	s invobj.Data=DataObj
	
	s InputPamStream=""
	
	d invobj.XMLExportToString(.InputPamStream)     ;生成xml字符串
	q:InputPamStream="" rtn
	;s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
	;s InputPamStream=$tr(InputPamStream,"CDATA","")
	;s InputPamStream=$tr(InputPamStream,"]","")
	;s InputPamStream=$tr(InputPamStream,"!","")
	q InputPamStream
}

/// 组织纸质红冲接口参数
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：红冲票据XML串
/// 其    他：w ##class(BILL.EINV.ADP.HBA).PPrintCom("","","") 
ClassMethod PPrintCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, QDFlag As %String) As %String
{
	s RtnFlag="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).EInvalid开始.")
	s rtn=""
	
	//票据信息
	s invobj=##class(BILL.EINV.DTO.HBA.PInvPrintService).%New()
	s invobj.sid="2"
	s invobj.ip=$ZU(67,15,$j) //"10.30.2.115"
	s invobj.port="8888"
	
	s dataObj=##class(BILL.EINV.DTO.HBA.PInvPrintData).%New()
	s dataObj.count="2"
	s recordObj=##class(BILL.EINV.DTO.HBA.PInvPrintRecordInfo).%New()
    s recordObj.FPZL="2"    ;发票种类（固定值：0：专用发票 2：普通发票12：机动车票51：电子发票）
    s recordObj.FPHM=ObjInvUpDetail.IUDBillBatchNo    ;发票号码
    s recordObj.FPDM=ObjInvUpDetail.IUDBillBatchCode   ;发票代码
    i QDFlag'="" d
    .s recordObj.TCBZ=""
    else  d
    .s recordObj.TCBZ="0"    ;弹窗标志
	s dataObj.record=recordObj
	s invobj.data=dataObj
	
	s InputPamStream=""
	;d EInvInMsg.XMLExportToStream(.InputPamStream)
	;d EInvOutMsg.XMLExportToStream(.InputPamStream)    ;生成xml字符流
	;q:$isobject(InputPamStream)=0 rtn
	d invobj.XMLExportToString(.InputPamStream)     ;生成xml字符串
	;w InputPamStream.OutputToDevice()
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitleGBK()_InputPamStream     ;加上xml文件头数据
	q InputPamStream
	


	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).EInvalid结束.Rtn=")
}

/// 功能说明：获取XML文件头部声明部分
ClassMethod GetXMLTitle(Version As %String = "") As %String
{
	q "<?xml version=""1.0"" encoding=""UTF-8"" ?>"
}

/// 功能说明：获取XML文件头部声明部分
ClassMethod GetXMLTitleGBK(Version As %String = "") As %String
{
	q "<?xml version=""1.0"" encoding=""GBK""?>"
}

/// 组织电子票据查询
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：电子票据查询XML串
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invalid("","","") 
ClassMethod EInvQueryInfo(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).EInvQueryInfo开始.")
	s QueryInfoObj=##class(BILL.EINV.DTO.HBA.EInvFPQueryReq).%New()
	s QueryInfoObj.class="REQUEST_FPXXXZ_NEW"
	s QueryInfoObj.DDH=""   ; 订单号
	s QueryInfoObj.FPQQLSH=""  ;发票请求唯一流水号
	s QueryInfoObj.DSPTBM=""   ;平台编码
	s QueryInfoObj.NSRSBH=""    ;纳税人识别号
	s QueryInfoObj.PDFXZFS="2"   ;下载方式默认填2
	
	s InputPamStream=""
	
	d QueryInfoObj.XMLExportToString(.InputPamStream)     ;生成xml字符串
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
	q InputPamStream
	
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).EInvQueryInfo结束.Rtn=")
}

/// 组织库存查询接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：电子票据库存查询XML串
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invalid("","","") 
ClassMethod EInvKCCXInfo(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).EInvQueryInfo开始.")
	s KCQueryInfoObj=##class(BILL.EINV.DTO.HBA.EInvKCQueryReq).%New()
	s KCQueryInfoObj.class="REQUEST_FPKCCX_NEW"
	s KCQueryInfoObj.NSRSBH=""    ;纳税人识别号
	
	s InputPamStream=""
	d KCQueryInfoObj.XMLExportToString(.InputPamStream)     ;生成xml字符串
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
	q InputPamStream
	
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).EInvQueryInfo结束.Rtn=")
}

/// 组织电子发票地址下载接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：电子发票地址下载XML串
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invalid("","","") 
ClassMethod EInvAdressDL(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).EInvQueryInfo开始.")
	s AdressDLInfoObj=##class(BILL.EINV.DTO.HBA.EInvAdressDLReq).%New()
	s AdressDLInfoObj.class="REQUEST_FPXZDZ_DDH"
	s AdressDLInfoObj.NSRSBH="130100999999166"    ;纳税人识别号
	s AdressDLInfoObj.DDH=ObjInvUpDetail.IUDPictureUrl   ;
	
	s InputPamStream=""
	d AdressDLInfoObj.XMLExportToString(.InputPamStream)     ;生成xml字符串
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
	q InputPamStream
	
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).EInvQueryInfo结束.Rtn=")
}

/// 组织发票重新推送接口接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：发票重新推送接口XML串
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invalid("","","") 
ClassMethod EInvReInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).EInvQueryInfo开始.")
	s ReInvoiceObj=##class(BILL.EINV.DTO.HBA.EInvReInvoiceReq).%New()
	s ReInvoiceObj.class="REQUEST_FPXXTS_NEW"
	s ReInvoiceObj.NSRSBH=""    ;纳税人识别号
	s ReInvoiceObj.FPQQLSH=""    ;发票请求唯一流水号
	s ReInvoiceObj.FPDM=""       ;发票代码
	s ReInvoiceObj.FPHM=""      ;发票号码
	s ReInvoiceObj.GHFSJ=""     ;购货方手机
	s ReInvoiceObj.GHFEMAIL=""  ;购货方邮箱
	
	s InputPamStream=""
	d ReInvoiceObj.XMLExportToString(.InputPamStream)     ;生成xml字符串
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
	q InputPamStream
	
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).EInvQueryInfo结束.Rtn=")
}

/// 纸质发票打印接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.HBA).PGrantPrtInfo() 
ClassMethod PGrantPrtInfo() As %String
{
	s RtnFlag="0"
	s InputXML=..PGrantPrtInfoCom()
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HBA).Invoice纸质发票打印开始"_InputXML)
	q:InputXML="" "-1"   ;组织入参发生错误
	
	
	b ;调用第三方接口开具纸质发票
	;b ;调用第三方webService服务
	s PINvWebService=##class(KpWebserviceC.PINVWebService.KpWebserviceCImplPort).%New()
	s ResOutput=PINvWebService.queryInventory(InputXML)
	b ;ResOutput
	;打印结果
	;解析返回结果 
    s rtn=..PSetInvResultOfGrantInv(ResOutput)

	
	s RtnFlag=rtn
	q RtnFlag
}

/// 组织获取库存信息接口参数
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：获取库存信息XML串
/// 其    他：w ##class(BILL.EINV.ADP.HBA).PPrintCom("","","") 
ClassMethod PGrantPrtInfoCom() As %String
{
	s RtnFlag="-1"
	;d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).EInvalid开始.")
	s rtn=""
	
	//票据信息
	s invobj=##class(BILL.EINV.DTO.HBA.PInvStockComData).%New()
	s invobj.sid="0"
	s invobj.ip=$ZU(67,15,$j)
	s invobj.port="8888"
	
	s dataObj=##class(BILL.EINV.DTO.HBA.PInvStockData).%New()
	s dataObj.count="2"
	s recordObj=##class(BILL.EINV.DTO.HBA.PInvStockRecordInfo).%New()
    s recordObj.FPZL="2"    ;发票种类（固定值：0：专用发票 2：普通发票12：机动车票51：电子发票）
	s dataObj.record=recordObj
	s invobj.data=dataObj
	
	s InputPamStream=""
	;d EInvInMsg.XMLExportToStream(.InputPamStream)
	;d EInvOutMsg.XMLExportToStream(.InputPamStream)    ;生成xml字符流
	;q:$isobject(InputPamStream)=0 rtn
	d invobj.XMLExportToString(.InputPamStream)     ;生成xml字符串
	;w InputPamStream.OutputToDevice()
	q:InputPamStream="" rtn
	s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
	q InputPamStream
	


	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).EInvalid结束.Rtn=")
}

/// 组织开具返回值
ClassMethod PSetInvResultOfGrantInv(XMLRes As %String) As %String
{
	s rtn="-1"
	b ;解析12
	set XMLRes=$ZCVT(XMLRes,"O","UTF8")
	set tDocument=""
	set tSC=##class(%XML.XPATH.Document).CreateFromString(XMLRes, .tDocument)
	s tRes=""
	set tSC=tDocument.EvaluateExpression("/service/err/refp/RETCODE","text()",.tRes)
	s IUDResultCode=tRes.GetAt(1).Value   	;返回代码 0成功，其它失败
	set tSC=tDocument.EvaluateExpression("/service/err/refp/RETMSG","text()",.tRes)
	s IUDResultMeg=tRes.GetAt(1).Value		;返回信息
	
	q:IUDResultCode'="3011" "-1^"_IUDResultMeg	//失败则退出
	
	set tSC=tDocument.EvaluateExpression("/service/err/refp/FPHM","text()",.tRes)
	s FPHM=tRes.GetAt(1).Value   	;发票号码
	set tSC=tDocument.EvaluateExpression("/service/err/refp/FPDM","text()",.tRes)
	s FPDM=tRes.GetAt(1).Value   	;发票代码
	set tSC=tDocument.EvaluateExpression("/service/err/refp/KCFPSL","text()",.tRes)
	s FPNum=tRes.GetAt(1).Value   	;发票数量
	
	s rtn=FPHM_"^"_FPDM_"^"_FPNum
	q rtn
}

/// 规则：  ;10位随机数+Base64({(10位随机数+userName）MD5（小写16位）})
/// /// 其    他：w ##class(BILL.EINV.ADP.HBA).CreateBusinessNo("张三","") 
ClassMethod CreateBusinessNo(UserName As %String, OutLen As %Integer = 16) As %String
{

	s Str=""
	for StrLen=1:1:10 d
	  .if Str="" d
	  ..s Str=$R(10)
	  .else  d
	  ..s Str=Str_$R(10)
    set BusinessNo=Str_UserName
    Set BusinessNo=##class(web.Util.Encryption).MD5HexStr($zcvt(BusinessNo,"O","UTF8"))  ;MD5加密
    Set Src = $zcvt(BusinessNo,"O","UTF8")
	Set BaseStr= ##class(%SYSTEM.Encryption).Base64Encode(Src)
	set OutBusinessNo=Str_BaseStr
	q OutBusinessNo
}

}
