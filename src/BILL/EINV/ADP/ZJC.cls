/// 浙江慈林医院电子发票接口（诺诺网2.0版本）
Class BILL.EINV.ADP.ZJC Extends %RegisteredObject
{

/// 功能说明：调用开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：guoyunlong   2020-12-20 新做成         
/// 其    他：w ##class(BILL.EINV.ADP.ZJA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
	b ;;;ZJB.ADP	
	s RtnFlag="0"
	;开具之前先查询流水号下有没有开具过电子发票
	i ObjInvUpDetail.Xstr1="" d
	.s RtnFlag="-1"
	else  d
	.s InvStatusRtn=..EinvQuery(ObjInvUpDetail,InvociePam)  ;获取开票状态	
	.if InvStatusRtn'="0" d
	..s RtnFlag="-1"
	..;s InvociePam.ErrMsgInfo="获取发票信息失败"
	b ;343434343	
	q:RtnFlag="0" 0   ;如果该流水号下查询成功，则不再继续开票
	s InputJson=..InvoiceCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:InputJson="" "-1"   ;组织入参发生错误
	s Message=InputJson        ;$replace(InputJson,"[","【")									;业务入参
	;s Message=$replace(Message,"]","】")
	b ;Message
	s outData=##class(BILL.EINV.BI.ZJC.HTTPRequest).InvoiceRequest(Message,InvociePam,.RtnCode,"1")	
	b ;outData
	q:RtnCode="-1" "-1"
    s OutJsonStream=""
    s ResponseData=##class(BILL.EINV.DTO.ZJB.EInvoiceRes).%New()
    s Rtn=..DecryptionResult(outData,OutJsonStream,.ResponseData)
	b ;;Rtn
	if (Rtn="0000") {
		 s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail,.ResponseData)
	}else{
		 s ObjInvUpDetail.IUDResultCode=Rtn                ;错误信息编码
		 s ObjInvUpDetail.IUDResultMeg=OutJsonStream     ;错误信息描述shenme sheme qingjitainjia 12121212121212
		 s InvociePam.ErrMsgInfo=OutJsonStream
		 s RtnFlag="-1"
	}
	
	b ;开票成功后保存一下发票请求流水号，后面如果查询没有成功，可以重复查询
	s Iudid=ObjInvUpDetail.RowId
	if (Iudid'="") {
	    s objInv=##class(BILL.EINV.PO.InvUpDetails).%OpenId(Iudid)
	    if $isobject(objInv) {
		    s sc=objInv.%Save()
	    }
	}
	hang 2
	//b ;开票请求成功后，需要使用请求流水号查询电子发票
	i ObjInvUpDetail.Xstr1'="" d
	.s InvStatusRtn=..EinvQuery(ObjInvUpDetail,InvociePam)  ;获取开票状态	
	
	/*
	b ;开票请求成功后，需要使用请求流水号查询电子发票
	 if (RtnFlag="0"){
		s InvStatusRtn=..EinvQuery(ObjInvUpDetail,InvociePam)  ;获取开票状态	
		if InvStatusRtn'="0" {
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票信息失败"
		}
	}
	*/
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.BSA).Invoice结束")
	q RtnFlag
}

/// 组织开具接口参数
ClassMethod InvoiceCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
   s rtn=""
   //票据信息
   s invobj=##class(BILL.EINV.DTO.ZJC.EInvoiceReq).%New()
   s invobj.identity=InvociePam.HospitalInfoMap.GetAt("Hospital_identity")    ;身份认证，在诺诺网备案后，由诺诺网提供，每个企业一个"0B82B0F046D20F5E95D43CB0F0A31DE8C6D3CAB7B4B45037"  ;
   
   s invOrderData=##class(BILL.EINV.DTO.ZJB.EInvoiceOrderData).%New()
   s invOrderData.buyername=ObjInvPrtInfo.PatBaseInfo.PatName   ;购方企业名称
   s invOrderData.taxnum=""        ;购方企业税号
   s invOrderData.address=ObjInvPrtInfo.PatBaseInfo.Address       ;购方企业地址
   s invOrderData.account=""       ;购方企业银行开户行及账号
   s invOrderData.telephone=ObjInvPrtInfo.PatBaseInfo.Mobphone     ;购方企业电话
   s invOrderData.orderno=ObjInvUpDetail.IUDBusNo      ;订单号
   s invOrderData.invoicedate=$zd(ObjInvPrtInfo.BusDate,3)_" "_$zt(ObjInvPrtInfo.BusTime,1)    ;单据时间
   s invOrderData.saletaxnum=InvociePam.HospitalInfoMap.GetAt("Hospital_Saletax")        ;销方企业税号"150301199811285326"      ;;
   //s invOrderData.saletaxnum="91330681MA2D80G598"                                            ;销方企业税号(宏宇)
   s invOrderData.saleaccount=InvociePam.HospitalInfoMap.GetAt("Hospital_Account") ;销方企业银行开户行及账号"浙江诸暨农村商业银行股份有限公司暨阳科技支行  201000256471642" ;
   s invOrderData.salephone=InvociePam.HospitalInfoMap.GetAt("Hospital_Phone")    ;销方企业电话"0575-87597922"     ;
   s invOrderData.saleaddress=InvociePam.HospitalInfoMap.GetAt("Hospital_Address")  ;销方企业地址"诸暨市暨南街道环城南路191号" ;
   s invOrderData.kptype="1"   ;发票类型，1:正票;2：红票
   s invOrderData.message=ObjInvPrtInfo.InsuDivInfo.OtherInsuInfo  ;备注（不同开票服务器类型支持的备注长度不同，提交后会有相应校验）
   s invOrderData.clerk=InvociePam.UserDesc   ;开票员
   s invOrderData.payee=ObjInvPrtInfo.BusUserDesc    ;收款人
   s invOrderData.checker=InvociePam.UserDesc  ;复核人    ???测试暂时用这个，后面医院确定复核人
   s invOrderData.fpdm=""
   s invOrderData.fphm=""
   if ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo'="" d   ;原票信息不为空
   .s invOrderData.kptype="2" 
   .s invOrderData.message="对应正数发票代码:"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode_"号码:"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo
   .s invOrderData.fpdm=$e("000000000000"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode,*-11,*)     ;对应蓝票发票代码(红票必填，不满12位请左补0)
   .s invOrderData.fphm=$e("00000000"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo,*-7,*)     ;对应蓝票发票号码(红票必填，不满8位请左补0)
   s invOrderData.tsfs="-1"     ;推送方式，-1:不推送;0:邮箱;1:手机(默认);2:邮箱&手机
   s invOrderData.email=ObjInvPrtInfo.PatBaseInfo.PatEmail   ;推送邮箱（tsfs为0或2时，此项为必填）
   s invOrderData.phone=ObjInvPrtInfo.PatBaseInfo.Mobphone    ;推送手机(开票成功会短信提醒购方)
   s invOrderData.qdbz="1"     ;清单标志，0:非清单,1:清单，根据项目名称数，自动生成清单;
   s invOrderData.qdxmmc="详见销货清单"   ;注意：税局要求清单项目名称为（详见销货清单）
   s invOrderData.dkbz="0"     ;代开标志，0:非代开;1:代开。
   s invOrderData.deptid=""   ;部门门店id（诺诺网系统中的id）
   s invOrderData.clerkid=""  ;开票员id（诺诺网系统中的id）
    
   ;b ;发票种类，p:电子增值税普通发票，c:增值税普通发票(纸票)，s:增值税专用发票，e:收购发票(电子)，f:收购发票(纸质)，r:增值税普通发票(卷式)，b:增值税电子专用发票
   s invOrderData.invoiceLine="p" 
   s invOrderData.cpybz="0"       ;成品油标志：0非成品油，1成品油，
   s invOrderData.billInfoNo=""  ;红字信息表编号
   ;b ;ObjInvPrtInfo.InvItmDetInfo.Size
   for Index=1:1:ObjInvPrtInfo.InvItmDetInfo.Size   d
   .s detailsObj=##class(BILL.EINV.DTO.ZJB.EInvoiceDetails).%New()
   .s detailsObj.goodsname=ObjInvPrtInfo.InvItmDetInfo.GetAt(Index).TarDesc   ;商品名称
   .;i detailsObj.goodsname="头孢克肟分散片[50mg*18]" b ;;tou
   .s detailsObj.goodsname=$replace(detailsObj.goodsname,"[","【")									;业务入参
   .s detailsObj.goodsname=$replace(detailsObj.goodsname,"]","】")
   .s detailsObj.num=ObjInvPrtInfo.InvItmDetInfo.GetAt(Index).Qty        ;数量
   .s detailsObj.price=ObjInvPrtInfo.InvItmDetInfo.GetAt(Index).Price     ;单价
   .s detailsObj.hsbz="0"        ;单价含税标志，0:不含税,1:含税       ?????确定单价含税不含
   .s detailsObj.taxrate="0"     ;税率，
   .s detailsObj.spec=ObjInvPrtInfo.InvItmDetInfo.GetAt(Index).Spec        ;规格型号
   .s detailsObj.spec=$replace(detailsObj.spec,"[","【")									;业务入参
   .s detailsObj.spec=$replace(detailsObj.spec,"]","】")
   .s detailsObj.spec=$e(detailsObj.spec,1,20)
   .s detailsObj.unit=ObjInvPrtInfo.InvItmDetInfo.GetAt(Index).Unit        ;单位，开具成品油发票时必填，必须为”升”或“吨”。
   .s detailsObj.spbm=""        ;税收分类编码
   .s detailsObj.zsbm=""        ;自行编码
   .s detailsObj.fphxz="0"       ;发票行性质，0:正常行;1:折扣行;2:被折扣行
   .s detailsObj.yhzcbs="1"      ;优惠政策标识,0:不使用;1:使用
   .s detailsObj.zzstsgl="免税"     ;增值税特殊管理，如：即征即退、免税、简易征收等
   .s detailsObj.lslbs="1"       ;零税率标识
   .s detailsObj.kce="0"         ;扣除额
   .s detailsObj.taxfreeamt=$fn(ObjInvPrtInfo.InvItmDetInfo.GetAt(Index).Amt,"",2)  ;不含税金额
   .s detailsObj.tax="0"        ;税额
   .s detailsObj.taxamt=$fn(ObjInvPrtInfo.InvItmDetInfo.GetAt(Index).Amt,"",2)      ;含税金额
   .d invOrderData.detail.Insert(detailsObj)
   
   s invobj.order=invOrderData
   
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read(Stream.Size)
	
	q rtn
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ResultMegObj As BILL.EINV.DTO.ZJB.EInvoiceRes) As %String
{
	s RtnFlg="-1"
	
	b //对返回结果的时间戳进行分割
	s ObjInvUpDetail.Xstr1=ResultMegObj.fpqqlsh										;请求流水号
	s RtnFlg="0"
	
	q RtnFlg
}

/// 功能说明： 对第三方返回的json加密数据进行解析
/// w ##class(BILL.EINV.ADP.JSC).DecryptionResult("","")
ClassMethod DecryptionResult(Response, ByRef ErrMsg As %String, ByRef ResultObj As BILL.EINV.DTO.ZJB.EInvoiceRes) As %String
{
	s Rtn="-1"
	s ResultStream=##class(%GlobalCharacterStream).%New()
	d ResultStream.Write(Response)
	d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.ResultObj,"")
	s Rtn=ResultObj.status
	s ErrMsg=ResultObj.message
	b ;;Rtn
	q Rtn
}

ClassMethod EinvQuery(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
   s rtn="",RtnCode="0",RtnFlag="-1"
   //票据信息
	s rtn="{""serialNos"":"""_ObjInvUpDetail.Xstr1_""",""orderNos"":"""",""isOfferInvoiceDetail"":"""_1_"""}"
   
    b  ;调用平台接口DES加密入参
	s Message=rtn									;业务入参
	s outData=##class(BILL.EINV.BI.ZJC.HTTPRequest).InvoiceRequest(Message,InvociePam,.RtnCode,"2")
	b ;q:RtnCode="-1" "-1"
	if (RtnCode="0") {
		 s RtnFlag=..SetInvResultOfQuery(ObjInvUpDetail,outData)
	}
	q RtnFlag
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfQuery(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, OutData As %String) As %String
{
	s RtnFlg="-1"
	
	s ObjJsonStream={}.%FromJSON(OutData)
	s ObjInvUpDetail.IUDResultCode=ObjJsonStream.%Get("result")
	b ;s ObjInvUpDetail.IUDResultMeg=ObjJsonStream.%Get("errorMsg")
	
	s ObjList=ObjJsonStream.%Get("list")
	s ObjInvUpDetail.Xstr1=ObjList.%Get(0).%Get("c_fpqqlsh")
	s cmsg=ObjList.%Get(0).%Get("c_msg")
	q:cmsg'="开票完成（最终状态）" RtnFlg
	b //开票状态： 2 :开票完成（ 最终状态），其他状态分别为: 20:开票中;
    //21:开票成功签章中;22:开票失败;24:
   //开票成功签章失败;3:发票已作废 31:发票作废中
   //备注：22、24状态时，无需再查询，请确认开票失败原因以及签章失败原因；3、31只针对纸票
   //注：请以该状态码区分发票状态
	s status=ObjList.%Get(0).%Get("c_status")    //3
    s pdfurl=ObjList.%Get(0).%Get("c_url")      //发票PDF地址6
	s jpgurl=ObjList.%Get(0).%Get("c_jpg_url")  //发票详情地址
	s kprq=ObjList.%Get(0).%Get("c_kprq")      //开票日期7
	b ;;kprq
	s fpdm=ObjList.%Get(0).%Get("c_fpdm")      //发票代码1
	s fphm=ObjList.%Get(0).%Get("c_fphm")      //发票号码2
	s invoiceid=ObjList.%Get(0).%Get("c_invoiceid")      //发票主键
	s jym=ObjList.%Get(0).%Get("c_jym")      //校验码5
	s Ewm=ObjList.%Get(0).%Get("qrCode")      //二维码4
	s imgUrls=ObjList.%Get(0).%Get("c_imgUrls")      //jpg图片数据，主票和清单用","分开
	
	b //对返回结果的时间戳进行分割
	s ObjInvUpDetail.IUDBillBatchCode=fpdm						
	s ObjInvUpDetail.IUDBillBatchNo=fphm
	s ObjInvUpDetail.IUDBillBatchStatus=status
	s ObjInvUpDetail.IUDBillQRCode=Ewm
	s ObjInvUpDetail.IUDCheckCode=jym
	s ObjInvUpDetail.IUDPictureUrl=imgUrls     ;jpg图片数据 pdfurl
	s ObjInvUpDetail.IUDCreatDate=+$h   ;kprq
	s ObjInvUpDetail.EInvFlg="I"
	s ObjInvUpDetail.IUDResultMeg="开票成功"   						;查询状态 信息是否成功
	s ObjInvUpDetail.IUDUplodeFlag="Y"
	
	s ObjInvUpDetail.Xstr2=jpgurl     ;发票详情地址
	s ObjInvUpDetail.IUDBillPictureData=pdfurl
	s ObjInvUpDetail.Xstr4=invoiceid  ;发票主键
	s ObjInvUpDetail.Xstr5=OutData
	
	if ObjInvUpDetail.IUDCreatAmt<0 d
	.s ObjInvUpDetail.EInvFlg="S"
	.s ObjInvUpDetail.IUDResultMeg="红冲成功"   						;查询状态 信息是否成功
	s RtnFlg="0"
	
	q RtnFlg
}

}
