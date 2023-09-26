Class BILL.EINV.ADP.STGLA Extends %RegisteredObject
{

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 	业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：苏惠德   2019-09-17  新做成
///           董科锋   2019-09-19  开票前判断是否已经开过电子发票、把开票结果信息保存到对象中抽取成了一个小方法
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.STGLA).Invoice开始")
	
	s RtnFlag="0"
	
	//组织开具接口入参
	s InputJson=..InvoicePam(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	s:InputJson="" InvociePam.ErrMsgInfo="组织开具入参发生错误"
	q:InputJson="" "-1"   ;组织入参发生错误
	
	//开票前，调用"4.2.7开票结果查询（本地）",如果已经开票直接保存开票结果
	s OutputObj=""
	s InvStatusRtn=..GetEInvResultByBusNo("KP",ObjInvUpDetail,InvociePam, .OutputObj)  ;查询开票情况
	q:InvStatusRtn="-9999" "-1"	;调用服务异常
	q:InvStatusRtn="0" RtnFlag
	
	//查询不到开票信息时 调用开票业务
	s Message=InputJson									;业务入参
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.STGLA.HTTPRequest).InvoiceRequest(Message, InvociePam, .OutputObj)
	q:RtnCode="-9999" "-1"		;调用服务异常
	i (RtnCode="0"){
		s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail, OutputObj)  ;把开票结果信息保存到交易表
	}else{
		s ObjInvUpDetail.IUDResultCode=OutputObj.code ;错误信息编码
		s ObjInvUpDetail.IUDResultMeg=OutputObj.message     ;错误信息描述
		s RtnFlag="-1"
	}

	// 开票成功的情况下, 调用服务接口获取开票状态
	if (RtnFlag="0"){
		s OutputObj=""
		s InvStatusRtn=..GetEInvResultByBusNo("KP",ObjInvUpDetail,InvociePam, .OutputObj)  ;查询开票情况	
		i (InvStatusRtn'="0"){
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}

	}
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.STGLA).Invoice结束")
	q RtnFlag
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, OutputObj As BILL.EINV.DTO.STGLA.EInvResultRes) As %String
{
	s RtnFlg="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.STGLA).SetInvResultOfInvoice开始.")
	
	s ResultMegObj=##class(BILL.EINV.DTO.STGLA.InvoiceRes).%New()
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.Write(OutputObj.dataobj)
	d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
			
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.FPDM		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.FPHM		;电子票据号码
	s ObjInvUpDetail.IUDCreatDate=+$h						;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)				;电子票据生成时间
	s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.EWMURL		;票据二维码地址				
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.PDFURL		;PPdf文件下载地址
	s ObjInvUpDetail.IUDEInvLSH=ResultMegObj.ID		;开票数据ID
	s ObjInvUpDetail.EinvprtNo=ResultMegObj.FPDM_ResultMegObj.FPHM  ;发票编码+发票号码	
	
	s RtnFlg="0"
	
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.STGLA).SetInvResultOfInvoice结束.")
	q RtnFlg
}

/// 功能说明：开票结果查询（本地）
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 			ObjUPConfig		-->配置对象
/// 返 回 值：返回接口文档对应的json格式           
/// 修改履历：徐保保   2020-10-15 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).GetEINVResultByBusNo("","","") 
ClassMethod GetEInvResultByBusNo(Type, ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef OutputObj As BILL.EINV.DTO.STGLA.EInvResultRes) As %String
{
	s RtnFlag="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.STGLA).GetEInvResultByBusNo开始.")
	
	//1.组织电子票据开票状况入参
	s InvStatusRt=##class(BILL.EINV.DTO.STGLA.EInvStatesLocalQryReq).%New()
	s InvStatusRt.METHOD="CXBD"								;请求方法名称
	s InvStatusRt.DWID=InvociePam.ObjUPConfig.IUCAPPID		;单位ID
	s InvStatusRt.ID=ObjInvUpDetail.IUDEInvLSH				;开票信息ID
	s InvStatusRt.CXPJLX=Type								;查询票据类型
	s InvStatusRt.YWLSH=ObjInvUpDetail.IUDBusNo				;业务流水号

	//2.调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvStatusRt,.Stream)
	s InputJson=Stream.Read()
	s Message=InputJson
	
	//3.调用赛通港联http开票结果查询（本地）服务请求
	s RtnCode=##class(BILL.EINV.BI.STGLA.HTTPRequest).InvoiceRequest(Message, InvociePam, .OutputObj)
	q:RtnCode'="0" RtnCode
	
	//4.保存结果信息
	s ResultMegObj=##class(BILL.EINV.DTO.STGLA.EInvStatesLocalQryRes).%New()
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.Write(OutputObj.dataobj)
	d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	//对返回结果的时间戳进行分割
	s createTime=ResultMegObj.CJSJ			;创建时间
	s createDateTime=$e(createTime,1,$l(createTime)-3)
	s createDate=$zdh($e(createDateTime,1,8),8)
	s createTime=$zth(($e(createDateTime,9,10)_":"_$e(createDateTime,11,12)_":"_$e(createDateTime,13,14)),1)
	//状态-1开票失败0已开票1待开票（开票、红冲一致）
	i (ResultMegObj.TYPE="KP")&&(ResultMegObj.TYPE="0"){		
		s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.PJDM		;电子票据代码
		s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.PJHM		;电子票据号码
		s ObjInvUpDetail.IUDCreatDate=createDate							;电子票据生成日期
		s ObjInvUpDetail.IUDCreatTime=createTime							;;电子票据生成时间
		s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.DZ1				;票据二维码地址				
		s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.DZ2				;票据下载地址
		s ObjInvUpDetail.Xstr1=ResultMegObj.DZ4      				;财政票据地址
		s ObjInvUpDetail.IUDEInvLSH=ResultMegObj.ID		;开票数据ID
		s ObjInvUpDetail.EinvprtNo=ResultMegObj.PJDM_ResultMegObj.PJHM  ;发票编码+发票号码
		s ObjInvUpDetail.IUDResultCode=ResultMegObj.JG
		s ObjInvUpDetail.IUDResultMeg=ResultMegObj.MSG
		
		s ObjInvUpDetail.IUDPrintFlag=$Case(ResultMegObj.SFHK,"Y":"1","N":"0",:"")	;是否打印纸质票据
		s ObjInvUpDetail.IUDBillBatchStatus=$Case(ResultMegObj.SFZF,"Y":"2","N":"1",:"")	;电子票据状态
		s ObjInvUpDetail.IUDBillisScarlet=$Case(ResultMegObj.SFHC,"Y":"1","N":"0",:"")	;是否已开红票
		s ObjInvUpDetail.IUDUplodeFlag="Y"                              ;上传标志 Y:上传成功，N:上传失败
		s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
		s ObjInvUpDetail.EInvFlg="I"									;发票状态
		s RtnFlg="0"
	}elseif((ResultMegObj.TYPE="HK")&&(ResultMegObj.TYPE="0")){
	}
	
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.STGLA).GetEInvResultByBusNo结束.RtnFlag="_RtnFlag)
	
	q RtnFlag
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod GetInvStatusOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ResOutput As %String) As %String
{
	s RtnFlg="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.STGLA).SetInvResultOfInvoice开始.")
	
	s ResultMegObj=##class(BILL.EINV.DTO.STGLA.EInvStatesLocalQryRes).%New()
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.Write(OutJsonStream)
	d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	//对返回结果的时间戳进行分割
	;s createTime=ResultMegObj.CJSJ			;创建时间
	;s createDateTime=$e(createTime,1,$l(createTime)-3)
	;s createDate=$zdh($e(createDateTime,1,8),8)
	;s createTime=$zth(($e(createDateTime,9,10)_":"_$e(createDateTime,11,12)_":"_$e(createDateTime,13,14)),1)
	
	//状态-1开票失败0已开票1待开票（开票、红冲一致）
	i (ResultMegObj.TYPE="KP")&&(ResultMegObj.TYPE="0"){		
		s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.PJDM		;电子票据代码
		s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.PJHM		;电子票据号码
		s ObjInvUpDetail.IUDCreatDate=createDate							;电子票据生成日期
		s ObjInvUpDetail.IUDCreatTime=createTime							;;电子票据生成时间
		s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.DZ1				;票据二维码地址				
		s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.DZ2				;票据下载地址
		s ObjInvUpDetail.Xstr1=ResultMegObj.DZ4      				;财政票据地址
		s ObjInvUpDetail.IUDEInvLSH=ResultMegObj.ID		;开票数据ID
		s ObjInvUpDetail.EinvprtNo=ResultMegObj.PJDM_ResultMegObj.PJHM  ;发票编码+发票号码
		s ObjInvUpDetail.IUDResultCode=ResultMegObj.JG
		s ObjInvUpDetail.IUDResultMeg=ResultMegObj.MSG
		
		s ObjInvUpDetail.IUDPrintFlag=$Case(ResultMegObj.SFHK,"Y":"1","N":"0",:"")	;是否打印纸质票据
		s ObjInvUpDetail.IUDBillBatchStatus=$Case(ResultMegObj.SFZF,"Y":"2","N":"1",:"")	;电子票据状态
		s ObjInvUpDetail.IUDBillisScarlet=$Case(ResultMegObj.SFHC,"Y":"1","N":"0",:"")	;是否已开红票
		s ObjInvUpDetail.IUDUplodeFlag="Y"                              ;上传标志 Y:上传成功，N:上传失败
		s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
		s ObjInvUpDetail.EInvFlg="I"									;发票状态
		s RtnFlg="0"
	}else{
		s RtnFlag="-1"
	}
	
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.STGLA).SetInvResultOfInvoice结束.")
	q RtnFlg
}

/// 功能说明：整理电子票据开具组织入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：徐保保  2020 10 15
/// 其    他：w ##class(BILL.EINV.ADP.BSA).InvoiceCom("","","") 
ClassMethod InvoicePam(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.STGLA).InvoiceCom开始")
	
	//票据基础信息
	s invobj=##class(BILL.EINV.DTO.STGLA.InvoiceReq).%New()
	s invobj.METHOD="KP"							;请求方法名称
	s invobj.DWID=InvociePam.ObjUPConfig.IUCAPPID	;单位ID
	s invobj.LX="0"	    							;开票类型(0正式开票)
	s invobj.ND=$e($zd(+$h,8),3,4)					;年度(当前年度的后两位)
	s invobj.YWLSH=ObjInvUpDetail.IUDBusNo			;业务受理号
	s invobj.YWRQ=ObjInvPrtInfo.BusDate			;业务日期
	s invobj.KPDBM=""			;开票点编码？？？
	s invobj.YWLX=$Case(ObjInvUpDetail.IUDPayAdmType,"IP":"410602",:"410601")  ;业务类型(410401是资金往来结算 410501是捐赠 410601是门诊410602是住院)
	s invobj.PJHM=""			;发票号码
	
	//票据信息
	s invobj.DATA=##class(BILL.EINV.DTO.STGLA.InvoiceData).%New()
	
	s invobj.DATA.datamain=##class(BILL.EINV.DTO.STGLA.InvoiceDataMain).%New()
	s invobj.DATA.datamain.ZJE=ObjInvPrtInfo.InvAmt      			;总金额
	s invobj.DATA.datamain.JKFS=""				;交款方式???
	s invobj.DATA.datamain.BZ=""				;备注
	s invobj.DATA.datamain.KPR=ObjInvPrtInfo.BusUserDesc	;开票人
	s invobj.DATA.datamain.FHR=ObjInvPrtInfo.BusUserDesc	;复核人
	s invobj.DATA.datamain.BZCZ=""				;财政部门备注
	
	//开票单位信息???
	s invobj.DATA.datamain.KPDW=##class(BILL.EINV.DTO.STGLA.KPDWInfo).%New()
	s invobj.DATA.datamain.KPDW.KPDWBM=""		;开票单位代码
	s invobj.DATA.datamain.KPDW.KPDWMC=""		;开票单位名称
	s invobj.DATA.datamain.KPDW.SKRQC=""		;收款人全称
	s invobj.DATA.datamain.KPDW.SKRZH=""		;收款人账号
	s invobj.DATA.datamain.KPDW.SKRKHH=""		;收款人开户行
	
	//交款人信息???
	s invobj.DATA.datamain.JKR=##class(BILL.EINV.DTO.STGLA.JKRInfo).%New()
	s invobj.DATA.datamain.JKR.JKRLX="1"			;交款人类型(1:个人2:单位)
	s:(ObjInvUpDetail.IUDPayAdmType="PE")&&(ObjInvPrtInfo.PEBaseInfo.InvType="G") invobj.DATA.datamain.JKR.JKRLX="2"
	s invobj.DATA.datamain.JKR.JKRDM=ObjInvPrtInfo.PatBaseInfo.PatID			;交款人代码(单位一般为统一社会信用代码；个人一般为身份证号)
	s invobj.DATA.datamain.JKR.JKRMC=ObjInvPrtInfo.PatBaseInfo.PatName			;交款人名称
	s invobj.DATA.datamain.JKR.JKRZH=""			;交款人账号
	s invobj.DATA.datamain.JKR.JKRKHH=""		;交款人开户行
	
	//其他信息
	s invobj.DATA.datamain.EXT=##class(BILL.EINV.DTO.STGLA.EXTInfo).%New()
	s invobj.DATA.datamain.EXT.XB=ObjInvPrtInfo.PatBaseInfo.Sex		;性别
	s invobj.DATA.datamain.EXT.YLLB=$Case(ObjInvUpDetail.IUDPayAdmType,"IP":"住院",:"门诊")		;医疗类别
	s invobj.DATA.datamain.EXT.MZH=ObjInvPrtInfo.PatAdmInfo.AdmNo		;门诊号
	s invobj.DATA.datamain.EXT.JZRQ=ObjInvPrtInfo.PatAdmInfo.AdmDate	;就诊日期
	s invobj.DATA.datamain.EXT.YLJGLX=""	;医疗机构类型???
	s invobj.DATA.datamain.EXT.YBLX=ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc	;医保类型
	s invobj.DATA.datamain.EXT.YBBH=ObjInvPrtInfo.InsuDivInfo.InsuId	;医保编号
	s invobj.DATA.datamain.EXT.YBZF=ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0	;医保统筹基金支付
	s invobj.DATA.datamain.EXT.QTZF="0"	;其他支付
	s invobj.DATA.datamain.EXT.GRZHZF=ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0	;个人账户支付
	s invobj.DATA.datamain.EXT.GRXJZF=ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0	;个人现金支付
	s invobj.DATA.datamain.EXT.GRZF=ObjInvPrtInfo.InsuDivInfo.selfPayAmt	;个人自付
	s invobj.DATA.datamain.EXT.YJJE=ObjInvPrtInfo.DepositAmt	;预缴金额
	s invobj.DATA.datamain.EXT.BJJE=ObjInvPrtInfo.RecAmt	;补缴金额
	s invobj.DATA.datamain.EXT.TFJE=ObjInvPrtInfo.RefAmt	;退费金额
	
	s FeeCateConFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","FeeItmCateSTGL_ConFlag",5)  ;费用是否对照 1 对照 0 不对照
	s:FeeCateConFlag="" FeeCateConFlag="0" ;默认不对照
	
	//发票费用分类明细信息
	i FeeCateConFlag="1" d      //费用分类需要与第三方接口费用分类对照
	.s FeeConStr=##class(BILL.EINV.COM.Common).GetCatFeeByInvDr(ObjInvPrtInfo, InvociePam.ObjUPConfig, "OP")
	.f num=1:1:$l(FeeConStr,",") d
	..s datadetailsObj=##class(BILL.EINV.DTO.STGLA.InvoiceDataDetails).%New()
	..s CatFeeInfo=$p(FeeConStr,",",num)
	..s datadetailsObj.XMBM=$p(CatFeeInfo,"^",1)	;项目编码
	..s datadetailsObj.XMMC=$p(CatFeeInfo,"^",2)  	;项目名称
	..s datadetailsObj.DW=""						;计量单位
	..s datadetailsObj.BZ=$p(CatFeeInfo,"^",3)	 	;收费标准
	..s datadetailsObj.SL=1							;数量
	..s datadetailsObj.JE=$p(CatFeeInfo,"^",3)		;金额
	..s datadetailsObj.XMBZ=""						;项目备注
	..d invobj.DATA.datadetails.Insert(datadetailsObj)
	e  d
	.f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	..s datadetailsObj=##class(BILL.EINV.DTO.STGLA.InvoiceDataDetails).%New()
	..s CatFeeInfo=$p(FeeConStr,",",num)
	..s datadetailsObj.XMBM=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code	;项目编码
	..s datadetailsObj.XMMC=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc ;项目名称
	..s datadetailsObj.DW=""										;计量单位
	..s datadetailsObj.BZ=bjInvPrtInfo.InvCateInfo.GetAt(i).Amt	 	;收费标准
	..s datadetailsObj.SL=1											;数量
	..s datadetailsObj.JE=bjInvPrtInfo.InvCateInfo.GetAt(i).Amt		;金额
	..s datadetailsObj.XMBZ=""										;项目备注
	..d invobj.DATA.datadetails.Insert(datadetailsObj)

	//清单项目明细信息
	f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.s detailObj=##class(BILL.EINV.DTO.STGLA.InvoiceDataAuxdetails).%New()                     
	.s detailObj.XMBM=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode		;对应项目编码
	.s detailObj.XMMC=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc		;对应项目名称	
	.i FeeCateConFlag="1" d
	..s FeeCateKey=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode  		;费用分类编码
	..s FeeItmCateConInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeItmCateOPConSTGL",FeeCateKey,0)  ;对照信息
	..s detailObj.chargeCode=$p(FeeItmCateConInfo, "^", 5)  			;费用分类编码
	..s detailObj.chargeName=$p(FeeItmCateConInfo, "^", 6)  			;费用分类名称                       
	.s detailObj.SFXMBM=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode	;收费明细项目编码
	.s detailObj.SFXMMC=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc	;收费明细项目名称
	.s detailObj.SL=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty			;收费明细项目数量
	.s detailObj.DW=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit			;收费明细项目单位
	.s detailObj.BZ=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price			;收费明细项目标准
	.s detailObj.JE=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt			;收费明细项目金额
	.s detailObj.XMBZ=""		;收费明细项目备注
	.d invobj.DATA.dataauxdetails.Insert(detailObj)	
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read()
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.STGLA).InvoiceCom结束")
	q rtn
}

/// 功能说明：根据不同的业务类型分别调用不同冲红接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：徐保保  2020 10 16   
/// 其    他：w ##class(BILL.EINV.ADP.STGLA).Invalid("","","") 
ClassMethod Invalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	
	//1.组织冲红接口入参
	s InputJson=..InvalidPam(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	s:InputJson="" InvociePam.ErrMsgInfo="组织开具入参发生错误"
	q:InputJson="" "-1"   ;组织入参发生错误
	
	//2.调用冲红接口
	s Message=InputJson									;业务入参
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.STGLA.HTTPRequest).InvoiceRequest(Message, InvociePam, .OutputObj)
	q:RtnCode="-9999" "-1"		;调用服务异常
	if (RtnCode="0"){
		s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail, OutputObj)  ;把红冲开票结果信息保存到交易表
	}else{
		s RtnFlag="0"
	}
	
	//3.开票成功的情况下, 调用服务接口获取开票状态
	if (RtnFlag="0"){
		s OutputObj=""
		s InvStatusRtn=..GetEInvResultByBusNo("HC",ObjInvUpDetail,InvociePam, .OutputObj)  ;查询开票情况	
		i (InvStatusRtn'="0"){
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}

	}
	
	q RtnFlag
}

/// 功能说明：电子票据冲红入参组织
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：徐保保  2020 10 16
/// 其    他：w ##class(BILL.EINV.ADP.STGLA).InvalidOP("","","") 
/// 备注说明：
ClassMethod InvalidPam(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//组织电子票据冲红入参
	s InvRefundRt=##class(BILL.EINV.DTO.STGLA.InvalidReq).%New()
	s InvRefundRt.METHOD="HC"		;请求方法名称
	s InvRefundRt.DWID=InvociePam.ObjUPConfig.IUCAPPID	;单位ID
	s InvRefundRt.LX="0"	    						;开票类型(0正式开票)
	s InvRefundRt.ND=$e($zd(+$h,8),3,4)					;年度(当前年度的后两位)
	s InvRefundRt.YWLSH=ObjInvUpDetail.IUDBusNo			;业务受理号
	s InvRefundRt.YWRQ=ObjInvPrtInfo.BusDate			;业务日期
	s InvRefundRt.KPDBM=""			;开票点编码???
	s InvRefundRt.HCYY="患者要求"										;冲红原因
	s InvRefundRt.YWLX=$Case(ObjInvUpDetail.IUDPayAdmType,"IP":"410602",:"410601")		;业务类型(410401是资金往来结算 410501是捐赠 410601是门诊410602是住院)
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvRefundRt,.Stream)
	s rtn=Stream.Read()
	
	q rtn
}

/// 功能说明：调用服务接口获取换开纸质票据接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 其中:	  ,扩展字段属性中"^"分割的第五个字段为'纸质票据代码',"^"分割的第六个字段为'纸质票据号码',不允许随便修改扩展串位置
/// 返 回 值：	成功标志(0 成功 其他值代表失败)  
/// 修改履历：	徐保保  2020-10-16
/// 其    他：	w ##class(BILL.EINV.ADP.STGLA).PrintPaper("","") 
ClassMethod PrintPaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	
	//1.组织换开入参
	s InputJson=..TurnPaperInvoice(ObjInvUpDetail,InvociePam)
	s:InputJson="" InvociePam.ErrMsgInfo="组织开具入参发生错误"
	q:InputJson="" "-1"   ;组织入参发生错误
	
	//2.调用换开服务
	s Message=InputJson									;业务入参
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.STGLA.HTTPRequest).InvoiceRequest(Message, InvociePam, .OutputObj)
	q:RtnCode="-9999" "-1"		;调用服务异常
	if (RtnCode="0"){
		s ResultMegObj=##class(BILL.EINV.DTO.STGLA.EInvTurnPaperRes).%New()
		s Stream=##class(%GlobalCharacterStream).%New()
		d Stream.Write(OutputObj.dataobj)
		d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
		s ObjInvUpDetail.IUDEInvLSH=ResultMegObj.KPXXID
	}else{
		s InvociePam.ErrMsgInfo=OutputObj.message
	}
	
	//3.开票成功的情况下, 调用服务接口获取开票状态
	if (RtnFlag="0"){
		s OutputObj=""
		s InvStatusRtn=..GetEInvResultByBusNo("HK",ObjInvUpDetail,InvociePam, .OutputObj)  ;查询开票情况	
		i (InvStatusRtn'="0"){
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}

	}
	
	q RtnFlag
}

/// 功能说明：4.2.3换开纸质票据接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：徐保保	2020-10-16
/// 其    他：w ##class(BILL.EINV.ADP.BSA).TurnPaperInvoice("","","") 
ClassMethod TurnPaperInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	//换开纸质票据
	
	s TurnPaperRt=##class(BILL.EINV.DTO.STGLA.EInvTurnPaperReq).%New()
	s TurnPaperRt.METHOD="HK"		;请求方法名称
	s TurnPaperRt.DWID=InvociePam.ObjUPConfig.IUCAPPID			;单位ID
	s TurnPaperRt.LX=ObjInvUpDetail.OriInvUpDetail.IUDEInvLSH	;开票信息ID
	s TurnPaperRt.YWLSH=ObjInvUpDetail.IUDBusNo					;业务受理号
	s TurnPaperRt.PJDM=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode	;票据代码
	s TurnPaperRt.PJHM=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo		;票据号码
	s TurnPaperRt.HKZZPJDM=InvociePam.pBillBatchCode			;换开纸质票据代码								
	s TurnPaperRt.HKZZPJHM=InvociePam.pBillNo					;换开纸质票据号码

	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(TurnPaperRt,.Stream)
	s rtn=Stream.Read()
	q rtn
}

/// 功能说明：调用服务接口获取作废换开的纸质票据接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败)  
/// 修改履历：徐保保	2020-10-16 
/// 其    他：	w ##class(BILL.EINV.ADP.BSA).InvalidPaperInv("","") 
ClassMethod InvalidPaperInv(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	
	//1.组织换开入参
	s InputJson=..TurnPaperInvalid(ObjInvUpDetail,InvociePam)
	s:InputJson="" InvociePam.ErrMsgInfo="组织开具入参发生错误"
	q:InputJson="" "-1"   ;组织入参发生错误

	//2.调用换开服务
	s Message=InputJson									;业务入参
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.STGLA.HTTPRequest).InvoiceRequest(Message, InvociePam, .OutputObj)
	q:RtnCode="-9999" "-1"		;调用服务异常
	if (RtnCode="0"){
		s ResultMegObj=##class(BILL.EINV.DTO.STGLA.EInvTurnPaperRes).%New()
		s Stream=##class(%GlobalCharacterStream).%New()
		d Stream.Write(OutputObj.dataobj)
		d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
		s ObjInvUpDetail.IUDEInvLSH=ResultMegObj.KPXXID
	}else{
		s InvociePam.ErrMsgInfo=OutputObj.message
	}
	
	//3.开票成功的情况下, 调用服务接口获取开票状态
	if (RtnFlag="0"){
		s OutputObj=""
		s InvStatusRtn=..GetEInvResultByBusNo("ZF",ObjInvUpDetail,InvociePam, .OutputObj)  ;查询开票情况	
		i (InvStatusRtn'="0"){
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}

	}
	
	q RtnFlag
}

/// 功能说明：4.2.4作废纸质票据
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：徐保保	2020-10-16
/// 其    他：w ##class(BILL.EINV.ADP.BSA).TurnPaperInvoice("","","") 
ClassMethod TurnPaperInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	s TurnPaperRt=##class(BILL.EINV.DTO.STGLA.EInvTurnPaperInvalidReq).%New()
	s TurnPaperRt.METHOD="ZF"		;请求方法名称
	s TurnPaperRt.DWID=InvociePam.ObjUPConfig.IUCAPPID			;单位ID
	s TurnPaperRt.LX=ObjInvUpDetail.OriInvUpDetail.IUDEInvLSH	;开票信息ID
	s TurnPaperRt.YWLSH=ObjInvUpDetail.OriInvUpDetail.IUDBusNo	;业务流水号
	s TurnPaperRt.PJDM=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode	;票据代码
	s TurnPaperRt.PJHM=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo		;票据号码
	s TurnPaperRt.ZFZZPJDM=InvociePam.pBillBatchCode			;作废纸质票据代码							
	s TurnPaperRt.ZFZZPJHM=InvociePam.pBillNo					;作废纸质票据号码
	s TurnPaperRt.ZFYY="患者要求"                     		    ;作废原因	

	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(TurnPaperRt,.Stream)
	s rtn=Stream.Read()
	q rtn
}

/// 功能说明：查询单位信息
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：徐保保	2020-10-16
/// 其    他：w ##class(BILL.EINV.ADP.BSA).TurnPaperInvoice("","","") 
ClassMethod getHospitalInfo() As %String
{
	s HospitalStr=""
	
	s Message="{METHOD:""JCXX""}"									;业务入参
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.STGLA.HTTPRequest).InvoiceRequest(Message, InvociePam, .OutputObj)
	q:RtnCode="-9999" "-1"		;调用服务异常
	if (RtnCode="0"){
		s ResultMegObj=##class(BILL.EINV.DTO.STGLA.HospitalInfoRes).%New()
		s Stream=##class(%GlobalCharacterStream).%New()
		d Stream.Write(OutputObj.dataobj)
		d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
		s HospitalStr=ResultMegObj.XZBM_"|"_ResultMegObj.DWMC_"|"_ResultMegObj.DWID_"|"_ResultMegObj.DWBM
	}
	
	q HospitalStr
}

/// 功能说明：查询单位信息
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：徐保保	2020-10-16
/// 其    他：w ##class(BILL.EINV.ADP.BSA).TurnPaperInvoice("","","") 
ClassMethod getFeeInfo(ObjConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	s HospitalStr=""
	s inputReqObj=##class(BILL.EINV.DTO.STGLA.HospitalInfoReq).%New()
	s inputReqObj.METHOD="XMXX"
	s inputReqObj.DWID=ObjConfig.IUCAPPID
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(TurnPaperRt,.Stream)
	s Message=Stream.Read()
	
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.STGLA.HTTPRequest).InvoiceRequest(Message, InvociePam, .OutputObj)
	q:RtnCode="-9999" "-1"		;调用服务异常
	b ;1
	if (RtnCode="0"){
		s ResultMegObj=##class(BILL.EINV.DTO.STGLA.HospitalInfoRes).%New()
		s Stream=##class(%GlobalCharacterStream).%New()
		d Stream.Write(OutputObj.dataobj)
		d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
		b
		//s HospitalStr=ResultMegObj.XZBM_"|"_ResultMegObj.DWMC_"|"_ResultMegObj.DWID_"|"_ResultMegObj.DWBM
	}
	
	q HospitalStr
}

}
