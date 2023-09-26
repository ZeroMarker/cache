/// 使用与河南洛阳正骨医院
Class BILL.EINV.ADP.HNA Extends %RegisteredObject
{

/// 功能说明：调用服务接口获取电子票据种类查询
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：苏惠德   2019-12-10 
/// 其    他：w ##class(BILL.EINV.ADP.HNA).GetEBillTypeQuery("","") 
ClassMethod GetEBillTypeQuery(InputPam As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef OutputJsonStr As %String, ByRef ErrMsg As %String, hospNo As %String = "") As %String
{
	s RtnFlg="-1"
	s hospitalNo=hospNo
	s HospitalInfoMap=##class(%ArrayOfDataTypes).%New()
	s hospitalInfoNum=##class(BILL.EINV.COM.Common).GetHospitalInfoByDic(.HospitalInfoMap, hospitalNo)  ;获取医院的配置信息
	s obj=##class(BILL.EINV.DTO.HNA.InvoiceReq).%New()
	s ServiceCode="getIvcList"						;接口服务名称
	s obj.sysCode=HospitalInfoMap.GetAt("YL_SysCode")			;医疗系统代码
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(obj,.Stream)
	s InputJson=Stream.Read()
	q:InputJson="" RtnFlg
	//调用财政厅http接口
	s outData=##class(BILL.EINV.BI.HNA.HTTPRequest).InvoiceRequest(ServiceCode,InputJson,ObjUPConfig)
	b //对返回结果进行解析
	s Rtn=..DecryptionResult(outData, .ErrMsg)
	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn) d
	.s RtnFlg=0
	.s OutputJsonStr=outData
	
	q RtnFlg
}

/// 功能说明：调用服务接口获取电子票据单位可用项目查询
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：苏惠德   2019-12-10 
/// 其    他：w ##class(BILL.EINV.ADP.HNA).GetEBillItmList("","") 
ClassMethod GetEBillItmList(InputPam As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef OutputJsonStr As %String, ByRef ErrMsg As %String, hospNo As %String = "") As %String
{
	s RtnFlg="-1"
	s hospitalNo=hospNo
	s HospitalInfoMap=##class(%ArrayOfDataTypes).%New()
	s hospitalInfoNum=##class(BILL.EINV.COM.Common).GetHospitalInfoByDic(.HospitalInfoMap, hospitalNo)  ;获取医院的配置信息
	s obj=##class(BILL.EINV.DTO.HNA.InvoiceReq).%New()
	s ServiceCode="getItemList"						;接口服务名称
	s obj.sysCode=HospitalInfoMap.GetAt("YL_SysCode")			;医疗系统代码
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(obj,.Stream)
	s InputJson=Stream.Read()
	q:InputJson="" RtnFlg
	//调用财政厅http接口
	s outData=##class(BILL.EINV.BI.HNA.HTTPRequest).InvoiceRequest(ServiceCode,InputJson,ObjUPConfig)
	//对返回结果进行解析
	s Rtn=..DecryptionResult(outData, .ErrMsg)
	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn) d
	.s RtnFlg=0
	.s OutputJsonStr=outData
	
	q RtnFlg
}

/// 功能说明：调用服务接口获取电子票据一的系统标识sysCode
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：苏惠德   2020-10-19 
/// 其    他：w ##class(BILL.EINV.ADP.HNA).GetEBillSysCode("","") 
ClassMethod GetEBillSysCode(InputPam As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef OutputJsonStr As %String, ByRef ErrMsg As %String, hospNo As %String = "") As %String
{
	s ResultFlg="-1"
	s hospitalNo=hospNo
	s HospitalInfoMap=##class(%ArrayOfDataTypes).%New()
	s hospitalInfoNum=##class(BILL.EINV.COM.Common).GetHospitalInfoByDic(.HospitalInfoMap, hospitalNo)  ;获取医院的配置信息
	//在获取电子票据一的系统标识sysCode之前，需要先获取组织机构代码作为电子票据一的系统标识sysCode的入参使用
	s PlaceCode=""			;开票点编码
	s HospShortName=HospitalInfoMap.GetAt("Hosp_ShortName")			;医院简称
	s RtnFlg=##class(BILL.EINV.ADP.HNA).GetBillCodePoint(ObjUPConfig, .PlaceCode, HospShortName)
	q:(RtnFlg'="0") RtnFlg
	s obj=##class(BILL.EINV.DTO.HNA.EInvSysCodeReq).%New()
	s ServiceCode="getSysCode"						;接口服务名称
	s obj.orgCode=PlaceCode				;开票点编码
	s obj.callBackUrl="￥"				;异步回调地址
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(obj,.Stream)
	s InputJson=Stream.Read()
	q:InputJson="" ResultFlg
	//调用财政厅http接口
	s InputJson=$tr(InputJson,"￥")
	s outData=##class(BILL.EINV.BI.HNA.HTTPRequest).InvoiceRequest(ServiceCode,InputJson,ObjUPConfig)
	//对返回结果进行解析
	s Rtn=..DecryptionResult(outData, .ErrMsg)
	b //对结果进行判断，成功返回0，失败返回-1
	i (Rtn) d
	.s ResultFlg=0
	.s OutputJsonStr=outData

	q ResultFlg
}

/// 功能说明：调用服务接口获取电子票据网点列表查询
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：苏惠德   2020-10-19 
/// 其    他：w ##class(BILL.EINV.ADP.HNA).GetBillCodePoint("","") 
ClassMethod GetBillCodePoint(ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef PlaceCode As %String, HospShortName As %String) As %String
{
	s RtnFlg="-1"
	s ServiceCode="getAreaList"						;接口服务名称
	s InputJson=""
	//调用财政厅http接口
	s outData=##class(BILL.EINV.BI.HNA.HTTPRequest).InvoiceRequest(ServiceCode,InputJson,ObjUPConfig)
	s outData=$zcvt(outData,"I","UTF8")
	s outData=$tr(outData," ")
	//对返回结果进行解析
	s ResultObj=##class(BILL.EINV.DTO.HNA.BranchListRes).%New()
	s ResultStream=##class(%GlobalCharacterStream).%New()
	d ResultStream.Write(outData)
	d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.ResultObj,"")
	s Rtn=ResultObj.success
	b ;011
	i ((Rtn="true")||(Rtn="1")) {
		s RtnFlg=0
	}
	i (RtnFlg="0"){
		f i=1:1:ResultObj.result.Size {
			q:PlaceCode'=""
			s hospName=ResultObj.result.GetAt(i).name			;网点名称
			s hospShortName=ResultObj.result.GetAt(i).shortName			;网点简称
			s hosparea=ResultObj.result.GetAt(i).area			;所属区域
			i (hospShortName'="")&&(hospShortName=HospShortName){
				s PlaceCode=ResultObj.result.GetAt(i).orgCode		;组织机构代码
			}
		}
	}
	q RtnFlg
}

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 	业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：苏惠德   2020-10-16  新做成
/// 其    他：w ##class(BILL.EINV.ADP.HNA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	s ErrMsg=""
   //组织开具入参
    s InputJson=..EInvoiceJson(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:InputJson="" "-1"   ;组织入参发生错误
	
	//Invoice再开票前查询一次是否已经有当前发票的电子票据信息,已经存在的情况下 直接保存获取到的电子发票结果(接口开票成功,我们保存结果是失败的时候会有这种情况)
	s OutJsonStream=""
	s ResultRtn=..GetEINVResult(ObjInvUpDetail, InvociePam, .OutJsonStream)  ;查询开票情况
	i (ResultRtn="0") {
		//有开票信息时 直接获取开票结果信息
		s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail, OutJsonStream)   ;把开票结果信息保存到交易表
		
	}else{
		//查询不到开票信息时 调用开票业务
		//调用江苏省财政厅http接口
		s ServiceCode="createIvc"		
		;s InputJson=$tr(InputJson," ") b	;接口服务名称
		s outData=##class(BILL.EINV.BI.HNA.HTTPRequest).InvoiceRequest(ServiceCode,InputJson,InvociePam.ObjUPConfig)
		s Rtn=..DecryptionResult(outData,.ErrMsg) B    ;对返回结果进行解密
		if (Rtn){
			s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail, outData)  ;把开票结果信息保存到交易表
		
		}else{
			s ObjInvUpDetail.IUDResultCode=Rtn                ;错误信息编码
			s ObjInvUpDetail.IUDResultMeg=ErrMsg     		;错误信息描述
			s InvociePam.ErrMsgInfo=ErrMsg
			
			s RtnFlag="-1"
		}
	}
	
	//开票成功的情况下, 调用服务接口获取开票状态
	i (RtnFlag="0"){
		d ##class(BILL.EINV.ADP.HNA).SetTimeOut(2) //等待两秒后再查询结果
		s ResultRtn=..GetEINVResult(ObjInvUpDetail, InvociePam, .OutJsonStream) ;查询开票情况
		i (ResultRtn="0"){
			s InvStatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, OutJsonStream)   ;获取开票状态	
			i InvStatusRtn'="0" {
				s RtnFlag="-1"
				s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
			}
		}
	}

	
	q RtnFlag
}

/// 功能说明：根据不同的业务类型分别调用不同冲红接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：苏惠德   2020-10-19   
/// 其    他：w ##class(BILL.EINV.ADP.HNA).Invalid("","","") 
ClassMethod Invalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	s ErrMsg=""
    //组织红冲入参
    s InputJson=..EInvalidJson(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:InputJson="" "-1"   ;组织入参发生错误
	b //再红冲前前查询一次是否已经有当前发票的电子票据信息,已经存在的情况下 直接保存获取到的电子发票结果(接口冲红成功,我们保存结果是失败的时候会有这种情况)
	s OutJsonStream=""
	s ResultRtn=..GetEINVResult(ObjInvUpDetail, InvociePam, .OutJsonStream)  ;查询开票情况
	i (ResultRtn="0") {
		//有冲红信息时 直接获取冲红结果信息
		s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail, OutJsonStream)   ;把开票结果信息保存到交易表
		
	}else{
		//查询不到冲红信息时 调用冲红业务
		//调用江苏省财政厅http接口
		s ServiceCode="writeoffIvc"			;接口服务名称
		s InputJson=$tr(InputJson,"￥")
		s ^tempwsy002test($h)=InputJson
		s outData=##class(BILL.EINV.BI.HNA.HTTPRequest).InvoiceRequest(ServiceCode,InputJson,InvociePam.ObjUPConfig)
		 ;outData;00-9
		s OutJsonStream=""
		s Rtn=..DecryptionResult(outData, .ErrMsg)     ;对返回结果进行解密
		if (Rtn) {
			s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail, outData)  ;把冲红结果信息保存到交易表
		
		}else{
			s ObjInvUpDetail.IUDResultCode=Rtn                ;错误信息编码
			s ObjInvUpDetail.IUDResultMeg=ErrMsg     			;错误信息描述
			s InvociePam.ErrMsgInfo=ErrMsg
			s RtnFlag="-1"
		}
	}
	
		
	//冲红成功的情况下, 调用服务接口获取票据状态
	i (RtnFlag="0"){
		d ##class(BILL.EINV.ADP.HNA).SetTimeOut(2) //等待两秒后再查询结果
		s ResultRtn=..GetEINVResult(ObjInvUpDetail, InvociePam, .OutJsonStream)  ;查询开票情况
		i (ResultRtn="0"){
			s InvStatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, OutJsonStream)  ;获取开票状态	
			i InvStatusRtn'="0" {
				s RtnFlag="-1"
				s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
			}
		}
	}

	
	q RtnFlag
}

/// 功能说明：根据不同的业务类型分别调用不同电票冲正接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：苏惠德   2020-10-19   
/// 其    他：w ##class(BILL.EINV.ADP.HNA).InvCancel("","","") 
ClassMethod InvCancel(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	s ErrMsg=""
    s InputJson=""
	
    //组织冲正入参
	s InvCancelRt=##class(BILL.EINV.DTO.HNA.InvalidReq).%New()
	s InvCancelRt.ivcCode=ObjInvUpDetail.IUDBillBatchCode				;票据代码
	s InvCancelRt.ivcNumber=ObjInvUpDetail.IUDBillBatchNo				;票据号码
	s InvCancelRt.sysCode=InvociePam.HospitalInfoMap.GetAt("YL_SysCode")				;系统代码

	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvCancelRt,.Stream)
	s InputJson=Stream.Read()
	q:InputJson="" "-1"   ;组织入参发生错误
	
		//查询不到冲红信息时 调用冲红业务
		//调用财政厅http接口
		s ServiceCode="cancelIvc"			;接口服务名称
		s outData=##class(BILL.EINV.BI.HNA.HTTPRequest).InvoiceRequest(ServiceCode,InputJson,InvociePam.ObjUPConfig)
		 ;outData;00-19
		s Rtn=..DecryptionResult(outData, .ErrMsg)     ;对返回结果进行解密
		if (Rtn) {
			s RtnFlag=0	;..SetInvResultOfInvoice(ObjInvUpDetail, outData)  ;把冲红结果信息保存到交易表
		
		}else{
			s ObjInvUpDetail.IUDResultCode=Rtn                ;错误信息编码
			s ObjInvUpDetail.IUDResultMeg=ErrMsg     			;错误信息描述
			s InvociePam.ErrMsgInfo=ErrMsg
			s RtnFlag="-1"
		}
	
	q RtnFlag
}

/// 功能说明：组织开具接口入参信息
ClassMethod EInvoiceJson(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	s invobj=##class(BILL.EINV.DTO.HNA.InvoiceReq).%New()
	s invobj.sysCode=InvociePam.HospitalInfoMap.GetAt("YL_SysCode")				;;医疗系统代码
	s invobj.bizCode=ObjInvUpDetail.IUDBusNo				;业务流水
	s invobj.ivcType=..GetBusTypeByAdmType(ObjInvUpDetail.IUDPayAdmType,InvociePam.ObjUPConfig)	 ;开票类型
	i ObjInvUpDetail.IUDPayAdmType="OP" S EInvType="OPEInvType"
	i ObjInvUpDetail.IUDPayAdmType="REG" S EInvType="OPEInvType"
	i ObjInvUpDetail.IUDPayAdmType="IP" S EInvType="IPEInvType"
	S EInvCode=InvociePam.HospitalInfoMap.GetAt(EInvType)				;票据代码
	i +$h>$zdh("2020-12-31",3) d
	.i $e(EInvCode,$l(EInvCode)-2,$l(EInvCode))'=$e($p($zd(+$h,3),"-",1),3,4) d
	..s EInvCode=$e(EInvCode,1,$l(EInvCode)-2)_$e($p($zd(+$h,3),"-",1),3,4)
	s invobj.ivcCode=EInvCode
	s invobj.bizCode=ObjInvUpDetail.IUDBusNo				;业务流水号
	s invobj.totalAmount=ObjInvPrtInfo.InvAmt					;总金额
	s invobj.issueDate=..GetBusDate(+$h,$p($h,",",2))			;开票日期
	
	//开票单位
	s RecPartyobj=##class(BILL.EINV.DTO.HNA.InvoiceRecParty).%New()
	s RecPartyobj.recName=InvociePam.UserDesc 	;InvociePam.HospitalInfoMap.GetAt("XSF_MC")			;收款人全称
	s RecPartyobj.recAcct=InvociePam.HospitalInfoMap.GetAt("XSF_YHZH")			;收款人账号
	s RecPartyobj.recOpBk=InvociePam.HospitalInfoMap.GetAt("XSF_NSRSBH")		;收款人开户行
	s invobj.recParty=RecPartyobj
	d RecPartyobj.%Close()
	
	//交款人
	s PayerPartyobj=##class(BILL.EINV.DTO.HNA.InvoicePayerParty).%New()
	s PayerPartyobj.payerType="1"						;交款人类型
	s PayerPartyobj.payerCode=ObjInvPrtInfo.PatBaseInfo.PatID			;交款人代码(身份证号)
	s PayerPartyobj.payerName=ObjInvPrtInfo.PatBaseInfo.PatName 		;交款人姓名
	s PayerPartyobj.payerMobile=ObjInvPrtInfo.PatBaseInfo.Mobphone		;预留电话
	s PayerPartyobj.payerAcct=""			;交款人账号
	s PayerPartyobj.payerOpBk=""			;交款人开户行
	s invobj.payerParty=PayerPartyobj
	d PayerPartyobj.%Close()
	
	s invobj.payMode=""		;交款方式
	s invobj.checkNumber=""			;支票号
	s invobj.currencyType="人民币"		;货币种类
	s invobj.exchangeRate=""		;汇率
	s invobj.remark=""				;其他信息
	s invobj.handlingPerson=InvociePam.UserDesc			;开票人
	s invobj.checker="武欢茹" ;InvociePam.UserDesc				;复核人
	s invobj.supervisorRemark=""		;财政部门备注
	
	//扩展信息 
	s MainExtobj=##class(BILL.EINV.DTO.HNA.InvoiceMainExt).%New()
	s MainExtobj.businessNumber=ObjInvUpDetail.IUDBusNo			;业务单号
	s MainExtobj.businessDate=$ZD(ObjInvPrtInfo.BusDate,3)			;业务日期
	s MainExtobj.gender=ObjInvPrtInfo.PatBaseInfo.Sex				;性别
	s MainExtobj.age=ObjInvPrtInfo.PatBaseInfo.Age					;年龄
	s MainExtobj.address=ObjInvPrtInfo.PatBaseInfo.Address			;地址
	s MainExtobj.medicalType=""			;医疗类别
	s MainExtobj.patientNumber=ObjInvPrtInfo.PatAdmInfo.AdmNo		;门诊号
	s MainExtobj.medicalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate		;就诊日期
	s MainExtobj.orgType=ObjInvPrtInfo.InsuDivInfo.HospitalType		;医疗机构类型
	s MainExtobj.medicalInsuranceType="自费"   ;医保类型
	i ObjInvPrtInfo.InsTypeDr>1  d
	.s MainExtobj.medicalInsuranceType=ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc
	s MainExtobj.medicalInsuranceID=ObjInvPrtInfo.InsuDivInfo.InsuId			;医保编号
	s MainExtobj.fundPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1			;医保统筹基金支付
	s MainExtobj.otherPayAmount=$fn(ObjInvPrtInfo.InsuDivInfo.otherPayAmount,"",2)			;其他支付
	s MainExtobj.accountPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0		;个人账户支付
	s MainExtobj.ownPayAmount=$fn(ObjInvPrtInfo.InvAmt,"",2)				;个人现金支付
	i (ObjInvPrtInfo.InsuDivInfo.InsuTypeCode'="")  d
	.s MainExtobj.ownPayAmount=$fn(ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0,"",2)			;个人现金支付	
	s MainExtobj.selfpaymentAmount=$fn(ObjInvPrtInfo.InsuDivInfo.selfPayAmt,"",2)		;个人自付
	s MainExtobj.selfpaymentCost=$fn(ObjInvPrtInfo.InsuDivInfo.SelfAmt,"",2)			;个人自费
	/***WSY 20201203 医保部分传参修改***/
	s MainExtobj.spStand=$fn(ObjInvPrtInfo.InsuDivInfo.spStand,"",2)						;起付标准
	s MainExtobj.bSelfpayment=$fn(ObjInvPrtInfo.InsuDivInfo.bSelfpayment,"",2)				;乙类首自付
	s MainExtobj.ptnSelfpayment=$fn(ObjInvPrtInfo.InsuDivInfo.ptnSelfpayment,"",2)			;按比例自付
	s MainExtobj.civilSubsidy=$fn(ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay3,"",2)				;公务员补助
	s MainExtobj.teacherSubsidy=$fn(ObjInvPrtInfo.InsuDivInfo.teacherSubsidy,"",2)			;师职补助
	s MainExtobj.lInsuranceReimburse=$fn(ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay2,"",2)		;大额（病）保险报销
	s MainExtobj.lSuppleInsuranceReimburse=$fn(ObjInvPrtInfo.InsuDivInfo.lSuppleInsuranceReimburse,"",2)	;大病补充保险报销
	s MainExtobj.medicalHelp=$fn(ObjInvPrtInfo.InsuDivInfo.medicalHelp,"",2)				;医疗救助
	s MainExtobj.antenatalClinic=$fn(ObjInvPrtInfo.InsuDivInfo.antenatalClinic,"",2)		;产前检查费
	/***end***/
	s MainExtobj.caseNumber=ObjInvPrtInfo.PatAdmInfo.MedicalCode				;病例号
	s MainExtobj.hospitalizationNumber=ObjInvPrtInfo.PatAdmInfo.MedicalCode		;住院号
	s MainExtobj.departmentName=ObjInvPrtInfo.PatAdmInfo.DepDesc			;科别
	s MainExtobj.inHospitalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate			;住院日期
	s MainExtobj.outHospitalDate=ObjInvPrtInfo.PatAdmInfo.OutDate			;出院日期
	s MainExtobj.prepayAmount=$fn((ObjInvPrtInfo.DepositAmt),"",2)			;预缴金额
	s MainExtobj.rechargeAmount="0"			;补缴金额
	s MainExtobj.refundAmount="0"			;退费金额
	i ((ObjInvPrtInfo.DepositAmt)-(MainExtobj.ownPayAmount)<0){
		s MainExtobj.rechargeAmount=$fn($zabs((ObjInvPrtInfo.DepositAmt)-(MainExtobj.ownPayAmount)),"",2)	;补交金额(现金)

	}else{
		s MainExtobj.refundAmount=$fn((ObjInvPrtInfo.DepositAmt)-(MainExtobj.ownPayAmount),"",2)				;退还金额(现金)

	}
	s MainExtobj.relatedInvoiceCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode		;相关票据代码
	s MainExtobj.relatedInvoiceNumber=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo		;相关票据号码
	s MainExtobj.payCode=""					;缴款码
	
	// 获取备注信息（血费）
	s Remark=##class(BILL.EINV.ADP.HNA).GetPayDescByPrtId(ObjInvUpDetail.IUDPayAdmType, ObjInvUpDetail.IUDInvDr) 
	// end
	
	s MainExtobj.selfmainext=ObjInvPrtInfo.InsuDivInfo.AreaDesc_"  |   "_Remark				;个性化其他项目信息
	s MainExtobj.patientNo=ObjInvPrtInfo.PatBaseInfo.PAPMINO
	s MainExtobj.cardNo=ObjInvPrtInfo.PatBaseInfo.CardNo
	s MainExtobj.medicalInsuranceNumber=ObjInvPrtInfo.InsuDivInfo.InsuId	/// 患者医保编号(参保人在医保系统中的唯一标识(医保号))
	s invobj.mainExt=MainExtobj
	d MainExtobj.%Close()

	//开票单位印章	
	s RecPartySealobj=##class(BILL.EINV.DTO.HNA.InvoiceRecPartySeal).%New()
	s RecPartySealobj.sealId=InvociePam.HospitalInfoMap.GetAt("YL_sealId")			;印章编号
	s RecPartySealobj.sealName=InvociePam.HospitalInfoMap.GetAt("YL_sealName")		;印章编号
	s RecPartySealobj.sealHash=InvociePam.HospitalInfoMap.GetAt("sealHash")			;印章编号
	s invobj.recPartySeal=RecPartySealobj
	d RecPartySealobj.%Close()

	s FeeCateConFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","FeeItmCateBS_ConFlag",5)  ;费用是否对照 1 对照 0 不独照
	s:FeeCateConFlag="" FeeCateConFlag="0" ;默认不对照

	//票面明细信息
	i FeeCateConFlag="1" d      //费用分类需要与第三方接口费用分类对照
	.s FeeConStr=##class(BILL.EINV.COM.Common).GetCatFeeByInvDr(ObjInvPrtInfo,InvociePam.ObjUPConfig, ObjInvUpDetail.IUDPayAdmType)
	.f num=1:1:$l(FeeConStr,",") d
	..s FeeConData=$p(FeeConStr,",",num)
	..s InvDetaillistObj=##class(BILL.EINV.DTO.HNA.InvoiceListDetail).%New()
	..s InvDetaillistObj.itemCode=$p(FeeConData,"^",1)			;项目编码
	..s InvDetaillistObj.itemName=$p(FeeConData,"^",2)		;收费项目名称
	..s InvDetaillistObj.unit="1"
	..s InvDetaillistObj.amount=$p(FeeConData,"^",3)				;金额
	..s InvDetaillistObj.quantity="1"				;数量
	..s InvDetaillistObj.standCode=$p(FeeConData,"^",4)					;标准类型
	..s InvDetaillistObj.remark=" "					;备注
	..do invobj.detail.Insert(InvDetaillistObj)
	e  d
	.f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	..s InvDetaillistObj=##class(BILL.EINV.DTO.HNA.InvoiceListDetail).%New()
	..s InvDetaillistObj.itemCode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code				;项目编码
	..s InvDetaillistObj.itemNameunit=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc			;收费项目名称
	..s InvDetaillistObj.amount=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt					;金额
	..s InvDetaillistObj.quantity="1"				;数量
	..s InvDetaillistObj.standCode=" "				;标准类型
	..s InvDetaillistObj.remark=" "					;备注
	..do invobj.detail.Insert(InvDetaillistObj)

	;b.对象转Json
	set Stream=##class(%GlobalCharacterStream).%New()
	do ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	set jsonStr=Stream.Read()
   	quit jsonStr
}

/// 功能说明：组织冲红接口入参信息
ClassMethod EInvalidJson(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//组织电子票据冲红入参
	i ObjInvUpDetail.IUDBillBatchCode="" s ObjInvUpDetail.IUDBillBatchCode="￥"
	i ObjInvUpDetail.IUDBillBatchNo="" s ObjInvUpDetail.IUDBillBatchNo="￥"
	s InvRefundRt=##class(BILL.EINV.DTO.HNA.InvalidReq).%New()
	i ObjInvUpDetail.IUDPayAdmType="OP" S EInvType="OPEInvType"
	i ObjInvUpDetail.IUDPayAdmType="REG" S EInvType="OPEInvType"
	i ObjInvUpDetail.IUDPayAdmType="IP" S EInvType="IPEInvType"
	S EInvCode=InvociePam.HospitalInfoMap.GetAt(EInvType)				;票据代码
	i +$h>$zdh("2020-12-31",3) d
	.i $e(EInvCode,$l(EInvCode)-2,$l(EInvCode))'=$e($p($zd(+$h,3),"-",1),3,4) d
	..s EInvCode=$e(EInvCode,1,$l(EInvCode)-2)_$e($p($zd(+$h,3),"-",1),3,4)
	s InvRefundRt.ivcCode=EInvCode				;票据代码
	s InvRefundRt.ivcNumber="￥"															;票据号码，如果为空，系统将自动指定并使用新的空票号。
	s InvRefundRt.bizCode=ObjInvUpDetail.OriInvUpDetail.IUDBusNo						;原电子票据业务流水号
	s InvRefundRt.paperIvcCode=ObjInvUpDetail.IUDBillBatchCode							;红票票据对应纸质票票据代码
	s InvRefundRt.paperIvcNumber=ObjInvUpDetail.IUDBillBatchNo							;红票据对应纸质票票据号码
	s InvRefundRt.reason="患者要求"		;冲红原因
	s InvRefundRt.sysCode=InvociePam.HospitalInfoMap.GetAt("YL_SysCode")				;;医疗系统代码			;系统代码

	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvRefundRt,.Stream)
	s rtn=Stream.Read()
	
	q rtn
}

/// 功能说明：调用服务接口获取开票状况服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 			ObjUPConfig		-->配置对象
/// 返 回 值：返回接口文档对应的json格式           
/// 修改履历：苏惠德   2020-10-16 
/// 其    他：w ##class(BILL.EINV.ADP.HNA).GetEINVResult("","","") 
ClassMethod GetEINVResult(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef OutputJsonStr As %String) As %String
{
	s RtnFlag="-1"
	s ErrMsg=""
	//入参通用信息
	s invobj=##class(BILL.EINV.DTO.HNA.InvoiceReq).%New()
	i ObjInvUpDetail.IUDBillBatchCode="" s ObjInvUpDetail.IUDBillBatchCode="￥"
	i ObjInvUpDetail.IUDBillBatchNo="" s ObjInvUpDetail.IUDBillBatchNo="￥"
	s ServiceCode="queryIvc"						;接口服务名称
	s invobj.sysCode=InvociePam.HospitalInfoMap.GetAt("YL_SysCode")				;;医疗系统代码
	s invobj.ivcCode=ObjInvUpDetail.IUDBillBatchCode					;票据代码
	s invobj.ivcNumber=ObjInvUpDetail.IUDBillBatchNo					;票据号码
	s invobj.bizCode=""	;ObjInvUpDetail.IUDBusNo							;业务流水号
	;s invobj.sysCode=""												;系统代码
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s InputJson=Stream.Read()
	s InputJson=$tr(InputJson,"￥")
	q:InputJson="" RtnFlag
	;008//调用http接口
	s outData=##class(BILL.EINV.BI.HNA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam.ObjUPConfig)
	;outData.Read();
	//对返回结果进行解析
	s Rtn=..DecryptionResult(outData,.ErrMsg)
	s HISPrtRowID=ObjInvUpDetail.IUDInvDr
	i HISPrtRowID'="" s ^DHCBILLEINVLY($i,"Query",HISPrtRowID)=ErrMsg
	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn) d
	.s RtnFlag=0
	.s OutputJsonStr=outData
	
	q RtnFlag
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, OutJsonStream As %String) As %String
{
	s RtnFlg="-1"
	
	s ResultMegObj=##class(BILL.EINV.DTO.HNA.InvoiceRes).%New()
	
	;d ##class(web.INSUCacheJSON).RtnObjectFromJSON(.ResultMegObj,OutJsonStream)
	S OutJsonStream=$ZCVT(OutJsonStream,"I","UTF8")
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.Write(OutJsonStream)
	d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
	s RtnMessage=""
	s RtnCode=ResultMegObj.success			;调用成功标识
	i (RtnCode="false"){
		s RtnMessage=ResultMegObj.result	;返回为false时，具体错误描述
	} 
	s ObjInvUpDetail.IUDResultCode=RtnCode					;处理结果代码
	s ObjInvUpDetail.IUDResultMeg=RtnMessage				;详细信息
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.result.ivcCode			;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.result.ivcNumber			;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=ResultMegObj.result.bizCode				;业务流水号
	s ObjInvUpDetail.IUDRateStatus=ResultMegObj.result.state				;0未完成（异步进行中）1 已经完成
	s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.result.pdfQr				;票据下载二维码
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.result.pdfUrl				;票据pdf下载地址
	s ObjInvUpDetail.Xstr2=ResultMegObj.result.ivcWebUrl					;财政厅票据展示地址
	s RtnFlg="0"
	
	q RtnFlg
}

/// 功能说明：调用服务接口获取开具服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：苏惠德   2020-10-17 
/// 其    他：w ##class(BILL.EINV.ADP.HNA).GetInvStatusOfInvoice("","","") 
ClassMethod GetInvStatusOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, OutJsonStream As %String) As %String
{
	s RtnFlg="-1"
	s OutJsonStream=$zcVt(OutJsonStream,"I","UTF8")
	s ResultMegObj=##class(BILL.EINV.DTO.HNA.InvoiceRes).%New()
	;s Stream=##class(%GlobalCharacterStream).%New()
	;d Stream.Write(OutJsonStream)
	;d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
	
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.Write(OutJsonStream)
	d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")	
	s RtnMessage=""
	s RtnCode=ResultMegObj.success			;调用成功标识
	i (RtnCode="0"){
		s RtnMessage=ResultMegObj.result	;返回为false时，具体错误描述
	} 
	i RtnCode'="" s ObjInvUpDetail.IUDResultCode=RtnCode					;处理结果代码
	i RtnMessage'="" s ObjInvUpDetail.IUDResultMeg=RtnMessage				;详细信息
	i ResultMegObj.result.ivcCode'="" s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.result.ivcCode			;电子票据代码
	i ResultMegObj.result.ivcNumber'="" s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.result.ivcNumber			;电子票据号码
	i ResultMegObj.result.bizCode'="" s ObjInvUpDetail.IUDCheckCode=ResultMegObj.result.bizCode				;业务流水号
	i ResultMegObj.result.state'="" s ObjInvUpDetail.IUDRateStatus=ResultMegObj.result.state				;0未完成（异步进行中）1 已经完成
	;i ResultMegObj.result.pdfQr'="" s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.result.pdfQr				;票据下载二维码
	i ResultMegObj.result.pdfUrl'="" s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.result.pdfUrl
	i ResultMegObj.result."pdfUrl_nw"'="" s ObjInvUpDetail.Xstr3=ResultMegObj.result."pdfUrl_nw"				;票据pdf下载地址
	i ResultMegObj.result.ivcWebUrl'="" s ObjInvUpDetail.Xstr2=ResultMegObj.result.ivcWebUrl				;财政厅票据展示地址
	s ObjInvUpDetail.IUDCreatDate=+$h
	s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)

	i (ObjInvUpDetail.IUDUploadPathCode="Invoice"){			//开具
		s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
		s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
		s:ObjInvUpDetail.EInvFlg'="B" ObjInvUpDetail.EInvFlg="I"										;发票状态

	}elseif(ObjInvUpDetail.IUDUploadPathCode="InvalidInv"){
		s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
		s ObjInvUpDetail.IUDResultMeg="冲红成功"
		s ObjInvUpDetail.EInvFlg="S"											;发票状态

	}else{
		s ObjInvUpDetail.IUDUplodeFlag=""                                ;上传标志 Y:上传成功，N:上传失败
		s ObjInvUpDetail.IUDResultMeg=""
		s ObjInvUpDetail.EInvFlg=""	
	}

	s RtnFlg="0"
	
	q RtnFlg
}

/// 功能说明： 对第三方返回的json加密数据进行解析
/// w ##class(BILL.EINV.ADP.HNA).DecryptionResult("{""result"":""00000"",""information"":""success"",""count"":""1"",""invoicetypelist"":[{""invoice_type_code"":""320101"",""invoice_type_name"":""非税一般缴款书""},{""invoice_type_code"":""320000"",""invoice_type_name"":""北望一般缴款书""}]}")
ClassMethod DecryptionResult(Response, ByRef ErrMsg As %String) As %String
{
	s Rtn="-1"
	s ResultObj=##class(BILL.EINV.DTO.HNA.InvoiceRes).%New()
	s Response=$zcvt(Response,"I","UTF8")
	;d ##class(web.INSUCacheJSON).RtnObjectFromJSON(.ResultObj,Response)
	;s ^tempwsytest001(+$h,$p($h,",",2))=Response
	s ResultStream=##class(%GlobalCharacterStream).%New()
	d ResultStream.Write(Response)
	d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.ResultObj,"")
	s Rtn=ResultObj.success
	s ErrMsg=ResultObj.result
	i ErrMsg="" s ErrMsg=ResultObj.errText
	b ;对第三方返回的json加密数据进行解析
	q Rtn
}

/// 功能说明：   通过HIs就诊类型获取对应的第三方的业务标识
/// 入参：       AdmType：就诊类型
/// (REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金) 
/// 出参：       第三方接口对应的业务标识
/// 编写：       guoyunlong
/// 备注说明：   目前根据就诊类型和第三方接口文档里面提供的业务标识在程序里面进行匹配
ClassMethod GetBusTypeByAdmType(AdmType As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	//00-住院 10-门诊 11-急诊 12-体检 30-其他
	//s BusType=$Case(AdmType,"IP":"01","OP":"02","API":"02","OT":"02","IT":"01","PE":"05","REG":"06","DEP":"07",:0)    				 
    s BusType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("BusinessTypeCon"_ObjUPConfig.FactoryCode,AdmType,5)
    q BusType
}

/// 功能说明：   通过日期时间获取对应的第三方规定时间格式
/// 入参：       Date：日期
/// 			 Time: 时间
/// 出参：       第三方接口对应的时间格式(yyyyMMddHHmmss)
/// w ##class(BILL.EINV.ADP.HNA).GetBusDate(+$h,$p($h,",",2))
ClassMethod GetBusDate(Date, Time) As %String
{
	s rtnDate=""
	i Date'["-" d  s Date=$zd(Date,3)
	i Time'[":" d  s Time=$zt(Time,1)
	s rtnDate=Date_" "_Time
	q rtnDate
}

/// 功能说明：   设置等待时间
/// 入参：       Time: 等待时间 （单位：秒）
/// w ##class(BILL.EINV.ADP.HNA).SetTimeOut(1)
ClassMethod SetTimeOut(Time) As %String
{
	s:Time="" Time=1
	s oldTime=$p($h,",",2)
	s oldDay=+$h
	s flag=0
	d{
		s nowTime=$p($h,",",2)
		s nowDay=+$h	
		s dayNum=nowDay-oldDay
		s nowTimeNew=dayNum*86400+nowTime
		s TimeNum=nowTimeNew-oldTime
		s Sec=TimeNum\Time
		i Sec=1 s flag=1
	}
	while(flag=0)
	
	q 0
}

/// w ##class(BILL.EINV.ADP.HNA).GetEInvCodeByCode(45232321)
ClassMethod GetEInvCodeByCode(EInvCode)
{
	i $e(EInvCode,$l(EInvCode)-2,$l(EInvCode))'=$e($p($zd(+$h,3),"-",1),3,4) d
	.s EInvCode=$e(EInvCode,1,$l(EInvCode)-2)_$e($p($zd(+$h,3),"-",1),3,4)
	q EInvCode
}

/// 其    他：w ##class(BILL.EINV.ADP.HNA).GetPayDescByPrtId("IP", 211484) 
ClassMethod GetPayDescByPrtId(admType, PrtId)
{
	q:PrtId="" ""
	q:admType="API" ""
	s Remark=""
	
	s paymStr=""
	i admType="OP" D
	.s ipmSub=""
	.f  s ipmSub=$o(^DHCINVPRT(PrtId,"P",ipmSub)) q:ipmSub=""  d
	..s paymode=$p(^DHCINVPRT(PrtId,"P",ipmSub),"^",1)
	..q:paymStr'[("^"_paymode_"^")
	..s paymodeDesc=$p(^CT("CTPM",paymode),"^",2)
	..s payamt=$p(^DHCINVPRT(PrtId,"P",ipmSub),"^",3)
	..q:+payamt=0
	..i Remark="" s Remark=paymodeDesc_","_payamt
	..e  s Remark=Remark_"^"_paymodeDesc_","_payamt
	e  i admType="IP" D
	.s arrcpdr=$p(^DHCINVPRTZY(PrtId),"^",17)
	.s paymsub=""
	.f  s paymsub=$o(^ARRCP(arrcpdr,"PAYM",paymsub),-1) q:paymsub=""  d
	..s paymode=$p(^ARRCP(arrcpdr,"PAYM",paymsub),"^",1)
	..q:paymStr'[("^"_paymode_"^")
	..s paymodeDesc=$p(^CT("CTPM",paymode),"^",2)
	..s payamt=$p(^ARRCP(arrcpdr,"PAYM",paymsub),"^",3)
	..q:+payamt=0
	..i Remark="" s Remark=paymodeDesc_","_payamt
	..e  s Remark=Remark_"^"_paymodeDesc_","_payamt
	

	// wsy add 20200115 增加输血费费用
	s SXFee=##class(BILL.EINV.ADP.HNA).GetSXFeeByPrtId(admType, PrtId) 
	i SXFee'="" d
	.i Remark'="" s Remark=Remark_"^"_"输血费"_":"_SXFee
	.e  s Remark="输血费"_":"_SXFee
	// end 
	
	q Remark
}

/// wsy add 20200115 增加输血费费用
/// w ##class(BILL.EINV.ADP.HNA).GetSXFeeByPrtId("IP", 211484) 
ClassMethod GetSXFeeByPrtId(admtype, prtId)
{
	q:admtype'="IP" ""
	S BillNo=$p(^DHCINVPRTZY(prtId),"^",5)
	
	s SXFee=0
	S FeeStr=##class(BILL.EINV.BL.COM.Common).GetIPCatFeeByBillNoNew(BillNo,"")
	;w FeeStr,!
	f index=1:1:$l(FeeStr,",") d
	.s FeeData=$p(FeeStr,",",index)
	.q:FeeData=""
	.s catDr=$p(FeeData,"^",1)
	.s cateFee=$p(FeeData,"^",3)
	.q:(catDr'=17)
	.s SXFee=SXFee+cateFee
	
	q SXFee
}

}
