Class BILL.EINV.ADP.ZZJ Extends %RegisteredObject
{

/// 功能说明：组织病人已开具成功的电子票据信息的XML
/// 入参说明: ObjPatEInvDetail    --> 电子票据信息对象
///           ObjEInvRes  		--> 交易XML对象
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：xubaobao   2019-10-25  新做成
/// 其    他：w ##class(BILL.EINV.ADP.ZZJ).SetEInvUpDetailInfo("","","") 
ClassMethod SetEInvUpDetailInfo(ObjReq As BILL.EINV.DTO.ZZJ.EInvDetailInfoReq, ObjRes As BILL.EINV.DTO.ZZJ.EInvDetailInfoRes, XMLReq) As %String
{
	s RtnFlag="0"
	
	//组织XML对象
	//s ObjEInvRes=##class(BILL.EINV.DTO.ZZJ.EInvDetailInfoRes).%New()
	s ObjRes.ResultCode="0"
	s ObjRes.ResultMsg="成功"
	//s ObjEInvRes.EInvNum=ObjPatEInvDetail.EInvNum			;总票据条目
	//s ObjEInvRes.EInvAmt=ObjPatEInvDetail.EInvAmt			;总票据金额
	/*s ObjEInvRes.EInvList=##class(BILL.EINV.DTO.ZZJ.EInvListRow).%New()
	f i=1:1:ObjPatEInvDetail.EInvList.Size {
		s EInvDetail=##class(BILL.EINV.DTO.ZZJ.EInvListData).%New()
		s EInvDetail.HISPrtRowID=ObjPatEInvDetail.EInvList.GetAt(i).IUDInvDr 	   ;发票表ID
		s EInvDetail.ID=ObjPatEInvDetail.EInvList.GetAt(i).RowId   					 ;票据ID
		s EInvDetail.PayAdmType=ObjPatEInvDetail.EInvList.GetAt(i).IUDPayAdmType    ;业务类型
		s EInvDetail.CreatAmt=ObjPatEInvDetail.EInvList.GetAt(i).IUDCreatAmt    	;票据金额
		s EInvDetail.BillBatchCode=ObjPatEInvDetail.EInvList.GetAt(i).IUDBillBatchCode 	   ;电子票据代码
		s EInvDetail.BillBatchNo=ObjPatEInvDetail.EInvList.GetAt(i).IUDBillBatchNo   	   ;电子发票号码
		s EInvDetail.PrtInvType=ObjPatEInvDetail.EInvList.GetAt(i).PrtInvType  ;票据类型
		s EInvDetail.CreatDate=ObjPatEInvDetail.EInvList.GetAt(i).IUDCreatDate_" "_ObjPatEInvDetail.EInvList.GetAt(i).IUDCreatTime   	;电子票据开具时间
		s EInvDetail.Status=ObjPatEInvDetail.EInvList.GetAt(i).IUDBillBatchStatus 	   ;票据状态
		s EInvDetail.CheckCode=ObjPatEInvDetail.EInvList.GetAt(i).IUDCheckCode   	   ;电子校验码
		s EInvDetail.BillQRCode=ObjPatEInvDetail.EInvList.GetAt(i).IUDBillQRCode 	   ;电子票据二维码图片数据
		s EInvDetail.Date=ObjPatEInvDetail.EInvList.GetAt(i).IUDDate   	   ;上传日期
		s EInvDetail.Time=ObjPatEInvDetail.EInvList.GetAt(i).IUDTime   	   ;上传时间
		s EInvDetail.UserID=ObjPatEInvDetail.EInvList.GetAt(i).IUDUser   	   ;结算操作员
		s EInvDetail.BusNo=ObjPatEInvDetail.EInvList.GetAt(i).IUDBusNo 	   ;业务流水号
		s EInvDetail.PrtDate=ObjPatEInvDetail.EInvList.GetAt(i).IUDPrtDate   	   ;业务发生日期
		s EInvDetail.PrtTime=ObjPatEInvDetail.EInvList.GetAt(i).IUDPrtTime   	   ;业务发生时间
		d ObjEInvRes.EInvList.row.Insert(EInvDetail)
	}*/
	
	//将对象转换XML流
	s InputPamStream=""
	d ObjRes.XMLExportToStream(.InputPamStream)
	q:'$IsObject(InputPamStream) "-1"
	
	s XMLReq=InputPamStream
	//s XMLReq=InputPamStream.OutputToDevice()
	
	q RtnFlag
}

/// 功能说明：组织HIS/第三方当前纸质票据可用号码的XML
/// 入参说明: InputData    --> 纸质票据代码^纸质票据号
///           ObjPaperNoReq  		--> 可用票据XML对象
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：xubaobao   2019-10-25  新做成
/// 其    他：w ##class(BILL.EINV.ADP.ZZJ).SetPaperBillNoInfo("","","") 
ClassMethod SetPaperBillNoInfo(ObjReq As BILL.EINV.DTO.ZZJ.PaperBillNoReq, InputData As %String, XMLReq) As %String
{
	s RtnFlag="0"
	
	s ObjRes=##class(BILL.EINV.DTO.ZZJ.PaperBillNoRes).%New()
	s ObjRes.ResultCode="0"
	s ObjRes.ResultMsg="成功"
	s ObjRes.pBillBatchCode=$p(InputData,"^",1)      ;纸质票据代码
	s ObjRes.pBillNo=$p(InputData,"^",2)       		 ;纸质票据号
	
	//将对象转换XML流
	s InputPamStream=""
	d ObjRes.XMLExportToStream(.InputPamStream)
	q:'$IsObject(InputPamStream) "-1"
	
	s XMLReq=InputPamStream
	//s XMLReq=InputPamStream.OutputToDevice()
	
	q RtnFlag
}

/// 功能说明：组织交易结果标识与结果描述的XML
/// 入参说明: ObjResult    --> 结果信息对象
///           ObjResultReq  		--> 结果XML对象
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：xubaobao   2019-10-25  新做成
/// 其    他：w ##class(BILL.EINV.ADP.ZZJ).SetResultInfo("","","") 
ClassMethod SetResultInfo(ObjResult As BILL.EINV.DTO.ZZJ.ResultData, ObjResultRes As BILL.EINV.DTO.ZZJ.ResultRes, XMLReq) As %String
{
	s RtnFlag="0"
	
	s ObjResultRes=##class(BILL.EINV.DTO.ZZJ.ResultRes).%New()
	s ObjResultRes.ResultCode=ObjResult.ResultCode     ;结果标识
	s ObjResultRes.ResultMsg=ObjResult.ResultMsg       ;结果描述
	
	//将对象转换XML流
	s InputPamStream=""
	d ObjResultRes.XMLExportToStream(.InputPamStream)
	q:'$IsObject(InputPamStream) "-1"
	
	s XMLReq=InputPamStream
	//s XMLReq=InputPamStream.OutputToDevice()
	
	q RtnFlag
}

/// 功能说明：组织电子票据明细信息XML
/// 入参说明: ObjInvPrtInfo    --> 发票信息对象
///           ObjRes  		--> 电子票据明细对象
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：xubaobao   2019-10-25  新做成
/// 其    他：w ##class(BILL.EINV.ADP.ZZJ).SetResultInfo("","","") 
ClassMethod SetBillDetailsInfo(ObjReq As BILL.EINV.BL.COM.InvUpConfigCtl, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, ObjRes As BILL.EINV.DTO.ZZJ.PatBillDetailsRes, XMLReq) As %String
{
	s RtnFlag="0"
	
	s ObjRes.ResultCode="0"
	s ObjRes.ResultMsg="成功"
	s ObjRes.accountPay=ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0      //个人账户支付
	s ObjRes.fundPay=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1    	   //医保统筹基金支付
	s otherInsupay=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay2+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay3+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay4+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay5
	s otherInsupay=otherInsupay+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay6+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay7+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay8+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay9
	s ObjRes.otherfundPay=otherInsupay 							   //其它医保支付
	s ObjRes.ownPay=ObjInvPrtInfo.InsuDivInfo.SelfAmt   	   //自费金额
	
	s ObjRes.selfConceitedAmt=ObjInvPrtInfo.InsuDivInfo.selfConceitedAmt     //个人自负
	s ObjRes.selfPayAmt=ObjInvPrtInfo.InsuDivInfo.selfPayAmt    	    //个人自付
	s ObjRes.selfCashPay=ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0    		//个人现金支付
	s ObjRes.ownAcBalance=ObjInvPrtInfo.InsuDivInfo.INPAYZstr23   	    //个人账户余额
	
	s ObjRes.reimbursementAmt=ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0     //报销总金额
	s ObjRes.balancedNumber=ObjInvPrtInfo.InsuDivInfo.INPAYdjlsh0    	    //结算号
	s ObjRes.consultationDate=ObjInvPrtInfo.PatAdmInfo.AdmDate    		//就诊日期
	s ObjRes.category=ObjInvPrtInfo.PatAdmInfo.DepDesc   	    //就诊科室
	s ObjRes.sex=ObjInvPrtInfo.PatBaseInfo.Sex     //性别
	s ObjRes.age=ObjInvPrtInfo.PatBaseInfo.Age    	    //年龄
	s ObjRes.medicalCareType=ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc    		//医保类型名称
	s ObjRes.cashRecharge=ObjInvPrtInfo.RecAmt   	    //应收金额
	s ObjRes.cashRefund=ObjInvPrtInfo.RefAmt   	    //应退金额
	s ObjRes.cashPay=ObjInvPrtInfo.DepositAmt   	    //预交总金额
	
	//将对象转换XML流
	s InputPamStream=""
	d ObjRes.XMLExportToStream(.InputPamStream)
	q:'$IsObject(InputPamStream) "-1"
	
	s XMLReq=InputPamStream
	//s XMLReq=InputPamStream.OutputToDevice()
	
	q RtnFlag
}

}
