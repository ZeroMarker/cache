/// 江苏省财政厅统一接口
Class BILL.EINV.ADP.JSA Extends %RegisteredObject
{

/// 功能说明：调用服务接口获取电子票据种类查询
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：苏惠德   2019-12-10 
/// 其    他：w ##class(BILL.EINV.ADP.JSA).GetEBillTypeQuery("","") 
ClassMethod GetEBillTypeQuery(InputPam As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef OutputJsonStr As %String, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="-1"
	s hospitalNo=""
	s HospitalInfoMap=##class(%ArrayOfDataTypes).%New()
	s hospitalInfoNum=##class(BILL.EINV.COM.Common).GetHospitalInfoByDic(.HospitalInfoMap, hospitalNo)  ;获取医院的配置信息
	s obj=##class(BILL.EINV.DTO.JSA.QueryEBillTypeReq).%New()
	s ServiceCode="estocktypequery"						;接口服务名称
	s obj.method=ServiceCode
	s obj.cocode=HospitalInfoMap.GetAt("YL_YLCode")							;医疗机构编码
	s obj.appid=HospitalInfoMap.GetAt("APP_ID")								;业务服务的编码
	s obj.zonecode=HospitalInfoMap.GetAt("ZONE_Code")						;行政区划
	s obj.timestamp=..GetBusDate(+$h,$p($h,",",2))		;发送请求的时间
	s obj.version=HospitalInfoMap.GetAt("BMB_BBH")						;版本号	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(obj,.Stream)
	s InputJson=Stream.Read()
	q:InputJson="" RtnFlg
	//调用江苏省财政厅http接口
	s outData=##class(BILL.EINV.BI.JSA.HTTPRequest).InvoiceRequest(InputJson,ObjUPConfig)
	//对返回结果进行解析
	s Rtn=..DecryptionResult(outData, .ErrMsg)
	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn="00000") d
	.s RtnFlag=0
	.s OutputJsonStr=outData
	e   s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明：调用服务接口电子票据申请单提交
/// 返 回 值：返回成功与否标识      
/// 修改履历：苏惠德   2019-12-10 
/// 其    他：w ##class(BILL.EINV.ADP.JSA).GetEBillApplyInfo("","","") 
ClassMethod InvBuyApply(InputPam As %String, ApplyCommon As %String, ByRef ObjBuyApply As BILL.EINV.PO.InvBuyApply, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="-1"
	s hospitalNo=""
	s HospitalInfoMap=##class(%ArrayOfDataTypes).%New()
	s hospitalInfoNum=##class(BILL.EINV.COM.Common).GetHospitalInfoByDic(.HospitalInfoMap, hospitalNo)  ;获取医院的配置信息
	s obj=##class(BILL.EINV.DTO.JSA.QueryEBillTypeReq).%New()
	s ServiceCode="estockapplynew"						;接口服务名称
	s obj.method=ServiceCode
	s obj.cocode=HospitalInfoMap.GetAt("YL_YLCode")							;医疗机构编码
	s obj.appid=HospitalInfoMap.GetAt("APP_ID")							;业务服务的编码
	s obj.zonecode=HospitalInfoMap.GetAt("ZONE_Code")							;行政区划
	s obj.timestamp=..GetBusDate(+$h,$p($h,",",2))		;发送请求的时间
	s obj.version=HospitalInfoMap.GetAt("BMB_BBH")						;版本号	
	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo("",20,"") 			;申请业务编码
	s obj.busno=HISUniqueID								;申请业务编码
	s obj.invoicetypecode=$p(InputPam,"^",1)			;电子票据种类代码
	s obj.invoicetypename=$p(InputPam,"^",2)			;电子票据种类名称
	s obj.count=$p(InputPam,"^",3)						;电子票据总数
	s obj.remark=ApplyCommon							;申请单备注
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(obj,.Stream)
	s InputJson=Stream.Read()
	q:InputJson="" RtnFlg
	//调用江苏省财政厅http接口
	s outData=##class(BILL.EINV.BI.JSA.HTTPRequest).InvoiceRequest(InputJson,ObjUPConfig)
	//对返回结果进行解析
	s Rtn=..DecryptionResult(outData,.ErrMsg)
	b //对结果进行判断，成功返回0，失败返回-1
	i (Rtn="00000") d
	.s ResultMegObj=##class(BILL.EINV.DTO.JSA.QueryEBillTypeRes).%New()
	.;s ResultStream=##class(%GlobalCharacterStream).%New()
	.;d ResultStream.Write(outData)
	.;d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.ResultMegObj,"")
	.d ##class(web.INSUCacheJSON).RtnObjectFromJSON(.ResultMegObj,outData)
	.s ObjBuyApply.IBABusNo=HISUniqueID							;申请业务编码
	.s ObjBuyApply.IBATypeCode=$p(InputPam,"^",1)				;;电子票据种类代码
	.s ObjBuyApply.IBATypeName=$p(InputPam,"^",2)				;电子票据种类名称
	.s ObjBuyApply.IBAEBillCount=$p(InputPam,"^",3)				;电子票据总数
	.s ObjBuyApply.ApplyCommon=ApplyCommon						;申请单备注
	.s ObjBuyApply.IBAUsr=$p(InputPam,"^",6)					;申请人
	.s ObjBuyApply.IBAResultCode=ResultMegObj.result			;结果标识
	.s ObjBuyApply.IBAResultMeg=ResultMegObj.information		;结果描述
	.s ObjBuyApply.IBAApplyNo=ResultMegObj.applyno				;申请单号
	.s ObjBuyApply.IBAApplyStatus="1"							;申请状态  0 待申请 1 已申请 2 申请成功 3 申请失败 9 申请作废
	.s ObjBuyApply.IBAApplyDate=+$h								;申请成功日期
	.s ObjBuyApply.IBAApplyTime=$p($h,",",2)					;申请成功时间
	.b ;s ObjBuyApply.IBAStockStatus=""							;入库状态(1.待入库,2.已入库,9.已撤销)
	.s RtnFlag=0
	
	e   s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明：调用服务接口电子票据申请单取消
/// 返 回 值：返回结果标志      
/// 修改履历：苏惠德   2019-12-10 
/// 其    他：w ##class(BILL.EINV.ADP.JSA).GetEBillApplyStock("","","") 
ClassMethod InvBuyApplyRevoke(InputPam As %String, RevokeCommon As %String, ByRef ObjBuyApply As BILL.EINV.PO.InvBuyApply, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="-1"
	
	s hospitalNo=""
	s HospitalInfoMap=##class(%ArrayOfDataTypes).%New()
	s hospitalInfoNum=##class(BILL.EINV.COM.Common).GetHospitalInfoByDic(.HospitalInfoMap, hospitalNo)  ;获取医院的配置信息
	s obj=##class(BILL.EINV.DTO.JSA.QueryEBillTypeReq).%New()
	s ServiceCode="estockapplycancel"						;接口服务名称
	s obj.method=ServiceCode
	s obj.cocode=HospitalInfoMap.GetAt("YL_YLCode")							;医疗机构编码
	s obj.appid=HospitalInfoMap.GetAt("APP_ID")							;业务服务的编码
	s obj.zonecode=HospitalInfoMap.GetAt("ZONE_Code")							;行政区划
	s obj.timestamp=..GetBusDate(+$h,$p($h,",",2))		;发送请求的时间
	s obj.version=HospitalInfoMap.GetAt("BMB_BBH")						;版本号	
	s obj.applyno=ObjBuyApply.IBAApplyNo				;电子票据申请单号
	s obj.remark=RevokeCommon							;申请单备注
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(obj,.Stream)
	s InputJson=Stream.Read()
	q:InputJson="" RtnFlg
	//调用江苏省财政厅http接口
	s outData=##class(BILL.EINV.BI.JSA.HTTPRequest).InvoiceRequest(InputJson,ObjUPConfig)
	b //对返回结果进行解析
	s Rtn=..DecryptionResult(outData, .ErrMsg)
	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn="00000") d
	.s ObjBuyApply.RevokeCommon=RevokeCommon					;申请撤销备注
	.s ObjBuyApply.IBAApplyStatus="9"							;;申请状态  0 待申请 1 已申请 2 申请成功 3 申请失败 9 申请作废
	.;s ObjBuyApply.IBAStockStatus=""							;(1.待入库,2.已入库,9.已撤销) 
	.s ObjBuyApply.StockApplyUsr=$p(InputPam,"^",2)				;取消申请人
	.s ObjBuyApply.StockApplyDate=+$h							;取消申请新日期
	.s ObjBuyApply.StockApplyTime=$p($h,",",2)					;取消申请时间
	.s RtnFlag=0
	e   s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明：调用服务接口电子票据申请单查询
/// 返 回 值：返回标识     
/// 修改履历：苏惠德   2019-12-10 
/// 其    他：w ##class(BILL.EINV.ADP.JSA).EBillApplyNoQuery("","","") 
ClassMethod SearchBuyApplyResult(InputPam As %String, ByRef ObjBuyApply As BILL.EINV.PO.InvBuyApply, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="-1"
	s hospitalNo=""
	s HospitalInfoMap=##class(%ArrayOfDataTypes).%New()
	s hospitalInfoNum=##class(BILL.EINV.COM.Common).GetHospitalInfoByDic(.HospitalInfoMap, hospitalNo)  ;获取医院的配置信息
	s obj=##class(BILL.EINV.DTO.JSA.QueryEBillTypeReq).%New()
	s ServiceCode="estockapplyquery"						;接口服务名称
	s obj.method=ServiceCode
	s obj.cocode=HospitalInfoMap.GetAt("YL_YLCode")							;医疗机构编码
	s obj.appid=HospitalInfoMap.GetAt("APP_ID")							;业务服务的编码
	s obj.zonecode=HospitalInfoMap.GetAt("ZONE_Code")							;行政区划
	s obj.timestamp=..GetBusDate(+$h,$p($h,",",2))		;发送请求的时间
	s obj.version=HospitalInfoMap.GetAt("BMB_BBH")						;版本号	
	s obj.applystate="0"								;0：所有类型；1：已审核2：未审核3：作废
	s obj.applytype="3"									;0：所有类型；3、按照指定单号查询
	s obj.applyno=ObjBuyApply.IBAApplyNo				;申请单号
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(obj,.Stream)
	s InputJson=Stream.Read()
	q:InputJson="" RtnFlg
	//调用江苏省财政厅http接口
	s outData=##class(BILL.EINV.BI.JSA.HTTPRequest).InvoiceRequest(InputJson,ObjUPConfig)
	//对返回结果进行解析
	s Rtn=..DecryptionResult(outData,.ErrMsg)
	s SearchApplyobj=##class(BILL.EINV.DTO.JSA.SearchBuyApplyRes).%New()
	;s ResultStream=##class(%GlobalCharacterStream).%New()
	;d ResultStream.Write(outData)
	;d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.SearchApplyobj,"")
	d ##class(web.INSUCacheJSON).RtnObjectFromJSON(.SearchApplyobj,outData)

	b //对结果进行判断，成功返回0，失败返回-1
	i (Rtn="00000") d
	.s Applycount=SearchApplyobj.applycount			;申请单数量
	.i (Applycount>0) d
	..s SearchApplyListobj=##class(BILL.EINV.DTO.JSA.SearchBuyApplyList).%New()
	..f i=1:1:SearchApplyobj.applylist.Size  d
	...s LYGApplyNo=SearchApplyobj.applylist.GetAt(i).applyno					;第三方返回的申请单号
	...s HisApply=ObjBuyApply.IBAApplyNo				;his原有申请单号
	...q:(HisApply'=LYGApplyNo)							;过滤掉第三方返回的申请单号与his申请单号不一致
	...s ObjBuyApply.IBAApplyNo=SearchApplyobj.applylist.GetAt(i).applyno			;申请单号
	...s ObjBuyApply.IBABusNo=SearchApplyobj.applylist.GetAt(i).busno				;申请时填写的业务编码
	...s ApplyState=SearchApplyobj.applylist.GetAt(i).applystate						;申请审核状态1：已审核2：未审核3：作废
	.../// 申请状态  0 待申请 1 已申请 2 申请成功 3 申请失败 9 申请作废
	...s HisApplyStatus=""
	...s:(ApplyState=1) HisApplyStatus=2
	...s:(ApplyState=2) HisApplyStatus=1
	...s:(ApplyState=3) HisApplyStatus=9
	...s ObjBuyApply.IBAApplyStatus=HisApplyStatus				;申请状态
	...s ApplyDateTime=SearchApplyobj.applylist.GetAt(i).applydatetime			;申请时间 20170724030750
	...s ApplyDate=$zdh($e(ApplyDateTime,1,8),8)
	...s ApplyTime=$zth(($e(ApplyDateTime,9,10)_":"_$e(ApplyDateTime,11,12)_":"_$e(ApplyDateTime,13,14)),1)
	...s ObjBuyApply.IBAApplyDate=ApplyDate					;申请成功日期
	...s ObjBuyApply.IBAApplyTime=ApplyTime					;申请成功时间
	...s ObjBuyApply.IBATypeCode=SearchApplyobj.applylist.GetAt(i).invoicetypecode		;申请电子票据种类代码
	...s ObjBuyApply.IBATypeName=SearchApplyobj.applylist.GetAt(i).invoicetypename		;申请电子票据种类名称
	...s ObjBuyApply.IBAEBillCount=SearchApplyobj.applylist.GetAt(i).applycount			;申请电子票据总数
	
	...s ObjBuyApply.IBAInvoiceCode=SearchApplyobj.applylist.GetAt(i).invoicecode		;审批电子票据代码
	...s ObjBuyApply.IBAInvoiceName=SearchApplyobj.applylist.GetAt(i).invoicename		;审批电子票据名称
	
	...s StockCount=SearchApplyobj.applylist.GetAt(i).stockcount			;审批库存列表个数
	...i (+StockCount>0) d
	....s SearchStockListobj=##class(BILL.EINV.DTO.JSA.SearchApplyStockList).%New()
	....f i=1:1:SearchApplyListobj.stocklist.Size  d	
	.....s ObjBuyApply.IBAStartNo=SearchApplyListobj.stocklist.GetAt(1).startno		;票据开始号码	
	.....s ObjBuyApply.IBAEndNo=SearchApplyListobj.stocklist.GetAt(1).endno			;票据结束号码
	.....s ObjBuyApply.IBAStockStatus=SearchApplyListobj.stocklist.GetAt(1).status		;库存状态1：待入库 2：已入库9：已撤销
	
	.s RtnFlag=0
	e   s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明：调用服务接口电子票据待入库列表查询
/// 返 回 值：返回成功与否标识     
/// 修改履历：苏惠德   2019-12-10 
/// 其    他：w ##class(BILL.EINV.ADP.JSA).GetEBillWarehousQuery("","") 
ClassMethod SearchNotStockData(InputPam As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef ObjCheckData As BILL.EINV.DTO.COM.CheckData, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="-1"
	s hospitalNo=""
	s HospitalInfoMap=##class(%ArrayOfDataTypes).%New()
	s hospitalInfoNum=##class(BILL.EINV.COM.Common).GetHospitalInfoByDic(.HospitalInfoMap, hospitalNo)  ;获取医院的配置信息
	s obj=##class(BILL.EINV.DTO.JSA.QueryEBillTypeReq).%New()
	s ServiceCode="estockquerypending"						;接口服务名称
	s obj.method=ServiceCode
	s obj.cocode=HospitalInfoMap.GetAt("YL_YLCode")							;医疗机构编码
	s obj.appid=HospitalInfoMap.GetAt("APP_ID")							;业务服务的编码
	s obj.zonecode=HospitalInfoMap.GetAt("ZONE_Code")							;行政区划
	s obj.timestamp=..GetBusDate(+$h,$p($h,",",2))		;发送请求的时间
	s obj.version=HospitalInfoMap.GetAt("BMB_BBH")						;版本号	

	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(obj,.Stream)
	s InputJson=Stream.Read()
	q:InputJson="" RtnFlg
	//调用江苏省财政厅http接口
	s outData=##class(BILL.EINV.BI.JSA.HTTPRequest).InvoiceRequest(InputJson,ObjUPConfig)
	//对返回结果进行解析
	s Rtn=..DecryptionResult(outData, .ErrMsg)
	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn="00000") d
	.s SearchNotStockObj=##class(BILL.EINV.DTO.JSA.SearchNotStockRes).%New()
	.;s Stream=##class(%GlobalCharacterStream).%New()
	.;d Stream.Write(outData)
	.;d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.SearchNotStockObj,"")
	.d ##class(web.INSUCacheJSON).RtnObjectFromJSON(.SearchNotStockObj,outData)

	.s StockCount=SearchNotStockObj.stockcount			;库存段数量
	.i (+StockCount>0) d
	..f i=1:1:SearchNotStockObj.stocklist.Size  d
	...s InvBillNoListObj=##class(BILL.EINV.DTO.COM.InvBillNoList).%New()
	...s InvBillNoListObj.applyNo=SearchNotStockObj.stocklist.GetAt(i).applyno			;对应的申请单号
	...s InvBillNoListObj.billBatchCode=SearchNotStockObj.stocklist.GetAt(i).invoicecode		;电子票据代码
	...s InvBillNoListObj.billName=SearchNotStockObj.stocklist.GetAt(i).invoicename		;电子票据名称
	...s InvBillNoListObj.bgnNo=SearchNotStockObj.stocklist.GetAt(i).startno				;起始号码
	...s InvBillNoListObj.endNo=SearchNotStockObj.stocklist.GetAt(i).endno				;结束号码
	...s InvBillNoListObj.copyNum=SearchNotStockObj.stocklist.GetAt(i).count				;电子票据总数
	...d ObjCheckData.InvBillNoList.Insert(InvBillNoListObj)
	.s RtnFlag=0
	e   s RtnFlag="-1"
	q RtnFlag
}

/// 功能说明：调用服务接口电子票据库存入库
/// 返 回 值：返回成功与否标志      
/// 修改履历：苏惠德   2019-12-10 
/// 其    他：w ##class(BILL.EINV.ADP.JSA).GetEBILLPurchase("","","") 
ClassMethod SaveApplyInvResult(InputPam As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef EBillBuyObj As BILL.EINV.DTO.COM.EBillBuyInfo, ByRef ObjInvBuyApply As BILL.EINV.PO.InvBuyApply, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="-1"
	s hospitalNo=""
	s HospitalInfoMap=##class(%ArrayOfDataTypes).%New()
	s hospitalInfoNum=##class(BILL.EINV.COM.Common).GetHospitalInfoByDic(.HospitalInfoMap, hospitalNo)  ;获取医院的配置信息

	s obj=##class(BILL.EINV.DTO.JSA.EBILLWareHousReq).%New()
	s ServiceCode="estockstore"						;接口服务名称
	s obj.method=ServiceCode
	s obj.cocode=HospitalInfoMap.GetAt("YL_YLCode")							;医疗机构编码
	s obj.appid=HospitalInfoMap.GetAt("APP_ID")							;业务服务的编码
	s obj.zonecode=HospitalInfoMap.GetAt("ZONE_Code")							;行政区划
	s obj.timestamp=..GetBusDate(+$h,$p($h,",",2))		;发送请求的时间
	s obj.version=HospitalInfoMap.GetAt("BMB_BBH")						;版本号	
	s obj.invoicecode=ObjInvBuyApply.IBAInvoiceCode				;电子票据代码
	s obj.invoicename=ObjInvBuyApply.IBAInvoiceName				;电子票据名称
	s obj.count=ObjInvBuyApply.IBAEBillCount					;电子票据总数
	s obj.startno=ObjInvBuyApply.IBAStartNo						;开始票据号
	s obj.endno=ObjInvBuyApply.IBAEndNo							;结束票据号
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(obj,.Stream)
	s InputJson=Stream.Read()
	q:InputJson="" RtnFlg
	b //调用江苏省财政厅http接口
	s outData=##class(BILL.EINV.BI.JSA.HTTPRequest).InvoiceRequest(InputJson,ObjUPConfig)

	//对返回结果进行解析
	s Rtn=..DecryptionResult(outData,.ErrMsg)
	b //对结果进行判断，成功返回0，失败返回-1
	i (Rtn="00000") d
	.s EBillBuyObj.BuyUsr=$p(InputPam,"^",2)				;购入人
	.s EBillBuyObj.BuyHospital=$p(InputPam,"^",5)			;院区指针
	.s EBillBuyObj.BuyBillCode=ObjInvBuyApply.IBAInvoiceCode				;电子票据代码
	.s EBillBuyObj.BuyBillName=ObjInvBuyApply.IBAInvoiceName				;电子票据名称
	.s EBillBuyObj.BuyStartNo=ObjInvBuyApply.IBAStartNo						;开始票据号
	.s EBillBuyObj.BuyEndNo=ObjInvBuyApply.IBAEndNo							;结束票据号
	.s EBillBuyObj.BuyCount=ObjInvBuyApply.IBAEBillCount					;购入数量
	.s EInvType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("EInvTypeCon"_ObjUPConfig.FactoryCode,ObjInvBuyApply.IBATypeCode,5)   ;获取对照的票据种类
	.s EBillBuyObj.BuyType=EInvType							;电子票据类型
	.s EBillBuyObj.BuyDate=+$h								;购入日期
	.s EBillBuyObj.BuyTime=$p($h,",",2)						;购入时间
	.s ObjInvBuyApply.IBAStockStatus="2"					;入库状态(1.待入库,2.已入库,9.已撤销)
	.s ObjInvBuyApply.StockUsr=$p(InputPam,"^",2)			;入库人
	.s ObjInvBuyApply.StockDate=+$h							;入库日期
	.s ObjInvBuyApply.StockTime=$p($h,",",2)				;入库时间
	.s RtnFlag=0
	e   s RtnFlag="-1"
	q RtnFlag
}

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 	业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：苏惠德   2019-12-16  新做成
/// 其    他：w ##class(BILL.EINV.ADP.JSA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	
	s ErrMsg=""
    //组织开具入参
    s InputJson=..EInvoiceJson(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)

	q:InputJson="" "-1"   ;组织入参发生错误
	
	b //再开票前查询一次是否已经有当前发票的电子票据信息,已经存在的情况下 直接保存获取到的电子发票结果(接口开票成功,我们保存结果是失败的时候会有这种情况)
	s OutJsonStream=""
	s ResultRtn=..GetEINVResult(ObjInvUpDetail, InvociePam, .OutJsonStream)  ;查询开票情况
	i (ResultRtn="0") {
		//有开票信息时 直接获取开票结果信息
		s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail, OutJsonStream)   ;把开票结果信息保存到交易表
		
	}else{
		//查询不到开票信息时 调用开票业务
		//调用江苏省财政厅http接口
		s outData=##class(BILL.EINV.BI.JSA.HTTPRequest).InvoiceRequest(InputJson,InvociePam.ObjUPConfig)
		s Rtn=..DecryptionResult(outData,.ErrMsg)     ;对返回结果进行解密
		if (Rtn="00000"){
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

/// 功能说明：根据不同的业务类型分别调用不同冲红接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：苏惠德   2019-12-17   
/// 其    他：w ##class(BILL.EINV.ADP.JSA).Invalid("","","") 
ClassMethod Invalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	s ErrMsg=""
    //组织红冲入参
    s InputJson=..EInvalidJson(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:InputJson="" "-1"   ;组织入参发生错误
	
	//再红冲前前查询一次是否已经有当前发票的电子票据信息,已经存在的情况下 直接保存获取到的电子发票结果(接口冲红成功,我们保存结果是失败的时候会有这种情况)
	s OutJsonStream=""
	s ResultRtn=..GetEINVResult(ObjInvUpDetail, InvociePam, .OutJsonStream)  ;查询开票情况
	i (ResultRtn="0") {
		//有冲红信息时 直接获取冲红结果信息
		s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail, OutJsonStream)   ;把开票结果信息保存到交易表
		
	}else{
		//查询不到冲红信息时 调用冲红业务
		//调用江苏省财政厅http接口
		s outData=##class(BILL.EINV.BI.JSA.HTTPRequest).InvoiceRequest(InputJson,InvociePam.ObjUPConfig)
		s OutJsonStream=""
		s Rtn=..DecryptionResult(outData, .ErrMsg)     ;对返回结果进行解密
		if (Rtn="00000") {
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

/// 功能说明：组织开具接口入参信息
ClassMethod EInvoiceJson(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	s invobj=##class(BILL.EINV.DTO.JSA.InvoiceReq).%New()
	//入参通用信息
	s ServiceCode="invoicehisissue"						;接口服务名称
	s invobj.cocode=InvociePam.HospitalInfoMap.GetAt("YL_YLCode")							;医疗机构编码
	s invobj.appid=InvociePam.HospitalInfoMap.GetAt("APP_ID")							;业务服务的编码
	s invobj.zonecode=InvociePam.HospitalInfoMap.GetAt("ZONE_Code")							;行政区划
	s invobj.timestamp=..GetBusDate(+$h,$p($h,"",2))		;发送请求的时间
	s invobj.version=InvociePam.HospitalInfoMap.GetAt("BMB_BBH")						;版本号	
	s invobj.method=ServiceCode
	//票据信息
	s invobj.invoicecode=InvociePam.pBillBatchCode							;票据代码
	s invobj.invoicenumber=InvociePam.pBillNo								;电子票据号码
	s invobj.random=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,6,"")					;校验码					;校验码
	s invobj.totalamount=ObjInvPrtInfo.InvAmt					;总金额
	s invobj.invoicingpartycode=InvociePam.HospitalInfoMap.GetAt("YL_YLCode")								;医疗机构单位代码
	s invobj.invoicingpartyname=InvociePam.HospitalInfoMap.GetAt("YL_YLCode")								;医疗机构单位名称
	s XSFMC=InvociePam.HospitalInfoMap.GetAt("XSF_MC")
	s invobj.recname=XSFMC										;收款人全称
	s XSFYHZH=InvociePam.HospitalInfoMap.GetAt("XSF_YHZH")
	s invobj.recacct=XSFYHZH											;收款人账号
	s XSFNSRSBH=InvociePam.HospitalInfoMap.GetAt("XSF_NSRSBH")
	s invobj.recopbk=XSFNSRSBH										;收款人开户行
	s invobj.payerpartytype="1"								;交款人类型1:个人2:单位
	s invobj.payerpartycode=ObjInvPrtInfo.PatBaseInfo.PatID				;患者身份证号码
	s invobj.payerpartyname=ObjInvPrtInfo.PatBaseInfo.PatName			;患者名称
	s invobj.payeracct=" "												;交款人账号
	s invobj.payeropbk=" "												;交款人开户行
	s invobj.paymode=" "												;交款方式
	s invobj.bizcode=ObjInvUpDetail.IUDBusNo							;业务流水号
	s invobj.currencytype="CNY"											;货币种类
	s invobj.exchangerate=" "											;汇率
	s invobj.remark=" "												    ;备注
	s invobj.handlingperson=InvociePam.UserDesc						;开票人
	s invobj.checker=InvociePam.UserDesc							;复核人
	s invobj.supervisorremark=" "										;财政部门备注
	//退款相关票据
	s InvRefobj=##class(BILL.EINV.DTO.JSA.InvoiceRefInfo).%New()
	s InvRefobj.relatedinvoicecode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode			;相关票据代码
	s InvRefobj.relatedinvoicenumber=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo			;相关票据号码
	s InvRefobj.paycode=" "						;缴款码
	s invobj.mainext=InvRefobj
	d InvRefobj.%Close()
	//票面明细信息
	f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	.s InvDetaillistObj=##class(BILL.EINV.DTO.JSA.InvoiceListDetail).%New()
	.s InvDetaillistObj.itemcode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code			;项目编码
	.s InvDetaillistObj.itemname=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc			;收费项目名称
	.;s InvDetaillistObj.unit=" "			;计量单位
	.s InvDetaillistObj.unit=ObjInvPrtInfo.InvCateInfo.GetAt(i).UOM
	.s InvDetaillistObj.itemamount=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt				;金额
	.;s InvDetaillistObj.num="1"				;数量
	.s InvDetaillistObj.num=ObjInvPrtInfo.InvCateInfo.GetAt(i).num
	.s InvDetaillistObj.stdtype=" "			;标准类型
	.//明细信息扩展
	.s InvItemextObj=##class(BILL.EINV.DTO.JSA.InvoiceItemText).%New()
	.s InvItemextObj.selfamt=" "			;自费金额 
	.s InvItemextObj.remark=" "			;备注信息
	.s InvDetaillistObj.Itemext=InvItemextObj
	.d InvItemextObj.%Close()
	.d invobj.detailitemlist.Insert(InvDetaillistObj)
	//辅助明细信息
	s InvAuxitemlistObj=##class(BILL.EINV.DTO.JSA.InvoiceAuxitemlist).%New()
	d invobj.auxitemlist.Insert(InvAuxitemlistObj)
	i (ObjInvUpDetail.IUDPayAdmType="IP"){
		s invobj.invoicingsealid=InvociePam.HospitalInfoMap.GetAt("YL_ZYYZBH")		;;单位印章编号
	} 
	
	i (ObjInvUpDetail.IUDPayAdmType="OP")||(ObjInvUpDetail.IUDPayAdmType="REG"){
		s invobj.invoicingsealid=InvociePam.HospitalInfoMap.GetAt("YL_MZYZBH")		;;单位印章编号
	
	}
	//票据开具后的寄送\通知目的
	s InvAddressobj=##class(BILL.EINV.DTO.JSA.InvoiceAddress).%New()
	s InvAddressobj.email=ObjInvPrtInfo.PatBaseInfo.PatEmail     			;通知邮件地址
	s InvAddressobj.telephone=ObjInvPrtInfo.PatBaseInfo.Mobphone			;通知人电话
	s InvAddressobj.alipaycode=InvociePam.UserCode					;收款员编码
	s InvAddressobj.wechatorderno=" "						;微信订单号
	s invobj.recipientaddr=InvAddressobj
	d InvAddressobj.%Close()
	s invobj.attachinfo=" "				;附加信息
	//医疗票相关信息
	s InvHisInfoobj=##class(BILL.EINV.DTO.JSA.InvoiceHisInfo).%New()
	s InvHisInfoobj.cardtype=..GetBusCardType(ObjInvPrtInfo.PatBaseInfo.CardType,InvociePam.ObjUPConfig)    ;卡类型 (需要对照)
	s InvHisInfoobj.cardno=ObjInvPrtInfo.PatBaseInfo.CardNo					;患者的卡编号
	s InvHisInfoobj.biztime=..GetBusDate(ObjInvPrtInfo.BusDate,ObjInvPrtInfo.BusTime)		;业务发生时间
	s InvHisInfoobj.placecode=InvociePam.UserCode    	;开票点编码 
	s InvHisInfoobj.payee=InvociePam.UserDesc  	 		;收费员
	//收费信息
	s InvTradeInfoobj=##class(BILL.EINV.DTO.JSA.InvoiceTradeInfo).%New()
	s InvTradeInfoobj.accountpay=ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0				;个人账户支付金额
	s:(InvTradeInfoobj.accountpay)="" InvTradeInfoobj.accountpay="0"
	s InvTradeInfoobj.fundpay=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1				;医保统筹基金支付金额
	s:(InvTradeInfoobj.fundpay)="" InvTradeInfoobj.fundpay="0"
	s InvTradeInfoobj.otherfundpay="0"				;其它医保支付金额
	s InvTradeInfoobj.ownpay=ObjInvPrtInfo.InsuDivInfo.SelfAmt				;自费金额，
	s:(InvTradeInfoobj.ownpay)="" InvTradeInfoobj.ownpay="0"
	s InvTradeInfoobj.cashpay=ObjInvPrtInfo.DepositAmt						;现金预交款金额
	s:(InvTradeInfoobj.cashpay)="" InvTradeInfoobj.cashpay="0"
	s InvTradeInfoobj.chequepay="0"				;支票预交款金额
	s InvTradeInfoobj.transferaccountpay="0"				;转账预交款金额
	s InvTradeInfoobj.cashrecharge=ObjInvPrtInfo.RecAmt				;补交金额(现金)
	s InvTradeInfoobj.chequerecharge="0"				;补交金额(支票)
	s InvTradeInfoobj.transferrecharge="0"				;补交金额（转账）
	s InvTradeInfoobj.cashrefund=ObjInvPrtInfo.RefAmt				;退还金额(现金)
	s InvTradeInfoobj.chequerefund="0"				;退交金额(支票)
	s InvTradeInfoobj.cashrecharge="0"				;补交金额(现金)
	s InvTradeInfoobj.transferrefund="0"				;退交金额(转账)
	s InvTradeInfoobj.acctBalance=ObjInvPrtInfo.InsuDivInfo.INPAYZstr23				;个人账户余额
	//交费渠道列表-支付方式
	f i=1:1:ObjInvPrtInfo.PayModeInfo.Size  d
	.s payChobj=##class(BILL.EINV.DTO.JSA.InvoicePaychannelList).%New()
	.s payChobj.channelcode=..GetBusPayMode(ObjInvPrtInfo.PayModeInfo.GetAt(i).Code,InvociePam.ObjUPConfig)  ;需要对照
	.s payChobj.channelamt=ObjInvPrtInfo.PayModeInfo.GetAt(i).Amt			;交费渠道金额
	.d InvTradeInfoobj.paychannellist.Insert(payChobj)
	s InvHisInfoobj.tradeinfo=InvTradeInfoobj
	d InvTradeInfoobj.%Close()
	//报销信息
	s InvReimburseInfoobj=##class(BILL.EINV.DTO.JSA.InvoiceReimburseInfo).%New()
	s InvReimburseInfoobj.illassist="0"					;大病救助报销金额
	s InvReimburseInfoobj.illinsur="0"					;大病保险报销金额
	s InvReimburseInfoobj.civilassist="0"					;民政救助报销金额
	s InvReimburseInfoobj.medinsur="0"					;医保范围内费用
	s InvReimburseInfoobj.selfpay="0"					;个人自理金额
	s InvHisInfoobj.reimburseinfo=InvReimburseInfoobj
	d InvReimburseInfoobj.%Close()
	//就诊信息明细
	s InvBizInfoobj=##class(BILL.EINV.DTO.JSA.InvoiceBizInfo).%New()
	s InvBizInfoobj.biztype=..GetBusTypeByAdmType(ObjInvUpDetail.IUDPayAdmType,InvociePam.ObjUPConfig)	 ;业务标识
	s InvBizInfoobj.medcaretype=" "				;医保类型名称
	s InvBizInfoobj.medcaretypecode=" "				;医保类型编码
	s InvBizInfoobj.patientid=ObjInvPrtInfo.PatBaseInfo.PAPMINO				;患者唯一ID
	s InvBizInfoobj.sex=ObjInvPrtInfo.PatBaseInfo.Sex			;性别：男、女
	s InvBizInfoobj.age=ObjInvPrtInfo.PatBaseInfo.Age			;年龄

	//门诊信息
	i (ObjInvUpDetail.IUDPayAdmType="OP"){
		
		s InvMedoutInfoobj=##class(BILL.EINV.DTO.JSA.InvoicemMedoutInfo).%New()
		s InvMedoutInfoobj.category=ObjInvPrtInfo.PatAdmInfo.DepDesc			;就诊科室
		s InvMedoutInfoobj.categorycode=ObjInvPrtInfo.PatAdmInfo.DepCode			;就诊科室编码
		s InvMedoutInfoobj.patientno=ObjInvPrtInfo.PatAdmInfo.AdmNo			;患者门诊号
		s InvMedoutInfoobj.caseno=" "			;病历号
		s InvMedoutInfoobj.spdisname=" "		;特殊病种名称
		s InvBizInfoobj.medoutinfo=InvMedoutInfoobj
		d InvMedoutInfoobj.%Close()

	}
	//住院信息
	i (ObjInvUpDetail.IUDPayAdmType="IP"){
		
		s InvMedbedInfoobj=##class(BILL.EINV.DTO.JSA.InvoiceMedbedInfo).%New()
		s InvMedbedInfoobj.patienttype=ObjInvPrtInfo.InsuDivInfo.PatType		;人员类别、
		s InvMedbedInfoobj.incategory=ObjInvPrtInfo.PatAdmInfo.DepDesc				;入院科室名称
		s InvMedbedInfoobj.incategorycode=ObjInvPrtInfo.PatAdmInfo.DepCode           //入院科室编码			;患者门诊号
		s InvMedbedInfoobj.outcategory=ObjInvPrtInfo.PatAdmInfo.OutDepDesc	                        //出院科室名称
		s InvMedbedInfoobj.outcategorycode=ObjInvPrtInfo.PatAdmInfo.OutDepCode	                          //出院科室编码
		s InvMedbedInfoobj.hospitalno=ObjInvPrtInfo.PatAdmInfo.MedicalCode			//患者住院号
		s InvMedbedInfoobj.hospitalarea=ObjInvPrtInfo.PatAdmInfo.WardDesc	        	//病区
		s InvMedbedInfoobj.bedno=ObjInvPrtInfo.PatAdmInfo.BedCode				//床号
		s InvMedbedInfoobj.caseno=ObjInvPrtInfo.PatAdmInfo.MedicalCode			  //病历号
		s InvMedbedInfoobj.indate=ObjInvPrtInfo.PatAdmInfo.AdmDate			//住院日期
		s InvMedbedInfoobj.outdate=ObjInvPrtInfo.PatAdmInfo.OutDate			//出院日期
		s InvMedbedInfoobj.hospitalDays=ObjInvPrtInfo.PatAdmInfo.IPDays			//住院天数
		s InvBizInfoobj.medbedinfo=InvMedbedInfoobj
		d InvMedbedInfoobj.%Close()

	}
	//挂号信息
	i (ObjInvUpDetail.IUDPayAdmType="REG"){
		
		s InvMedregInfoobj=##class(BILL.EINV.DTO.JSA.InvoiceMedregInfo).%New()
		s InvMedregInfoobj.category=ObjInvPrtInfo.PatAdmInfo.DepDesc					;就诊科室
		s InvMedregInfoobj.categorycode=ObjInvPrtInfo.PatAdmInfo.DepCode			;就诊科室编码
		s InvBizInfoobj.medreginfo=InvMedregInfoobj
		d InvMedregInfoobj.%Close()

	}
	//体检信息
	i (ObjInvUpDetail.IUDPayAdmType="PE"){
		
		s InvMedexamInfoobj=##class(BILL.EINV.DTO.JSA.InvoiceMedexamInfo).%New()
		s InvMedexamInfoobj.category=ObjInvPrtInfo.PatAdmInfo.DepDesc					;就诊科室
		s InvMedexamInfoobj.categorycode=ObjInvPrtInfo.PatAdmInfo.DepCode				;就诊科室编码
		s InvMedexamInfoobj.examno="999999"												;体检号码
		s InvBizInfoobj.medreginfo=InvMedexamInfoobj
		d InvMedexamInfoobj.%Close()

	}

    s InvHisInfoobj.bizinfo=InvBizInfoobj
	d InvBizInfoobj.%Close()
	
	//医疗清单明细
	//清单项目明细列表
	i (ObjInvUpDetail.IUDPayAdmType'="IP"){
		for i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
		.set MeditemListObj=##class(BILL.EINV.DTO.JSA.InvoiceMeditemList).%New()
		.set MeditemListObj.listno=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).SortNo                                //序号
		.set MeditemListObj.itemcode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode				       	    //费用类型编码
		.set MeditemListObj.itemname=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc					    	//费用类型名称
		.set MeditemListObj.chrgtypecode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode                                 //药品编码
		.set MeditemListObj.chrgtypename=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc                                 //药品名称
		.set MeditemListObj.unit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit									//计量单位
		.set MeditemListObj.std=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price  							    	//单价
		.set MeditemListObj.num=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty								//数量
		.set MeditemListObj.amt=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt							    	//金额
		.set MeditemListObj.selfamt=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).SelfAmt                              //自付金额
		.set MeditemListObj.receivableamt=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).RecAmt                         //应收费用
		.set MeditemListObj.medcareitemtype=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Insutjdm				    //医保药品分类
		.set MeditemListObj.medreimburserate=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).InsuScale                      //医保报销比例
		.set MeditemListObj.remark=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Remark							//备注
		.do InvHisInfoobj.meditemlist.Insert(MeditemListObj)
	}
	
	s invobj.hisinfo=InvHisInfoobj
	d InvHisInfoobj.%Close()
	
	 ;b.对象转Json
	set Stream=##class(%GlobalCharacterStream).%New()
	do ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	set jsonStr=Stream.Read()
   	quit jsonStr
}

/// 功能说明：组织开具接口入参信息
ClassMethod EInvalidJson(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	s invobj=##class(BILL.EINV.DTO.JSA.InvoiceReq).%New()
	//入参通用信息
	s ServiceCode="invoicehiswriteoff"						;接口服务名称
	s invobj.method=ServiceCode
	s invobj.cocode=InvociePam.HospitalInfoMap.GetAt("YL_YLCode")							;医疗机构编码
	s invobj.appid=InvociePam.HospitalInfoMap.GetAt("APP_ID")							;业务服务的编码
	s invobj.zonecode=InvociePam.HospitalInfoMap.GetAt("ZONE_Code")							;行政区划
	s invobj.timestamp=..GetBusDate(+$h,$p($h,"",2))		;发送请求的时间
	s invobj.version=InvociePam.HospitalInfoMap.GetAt("BMB_BBH")						;版本号	
	//票据信息
	s invobj.invoicecode=InvociePam.pBillBatchCode							;票据代码
	s invobj.invoicenumber=InvociePam.pBillNo							;电子票据号码
	s invobj.random=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,6,"")					;校验码
	s invobj.totalamount=ObjInvPrtInfo.InvAmt					;总金额
	s invobj.invoicingpartycode=InvociePam.HospitalInfoMap.GetAt("YL_YLCode")								;医疗机构单位代码
	s invobj.invoicingpartyname=InvociePam.HospitalInfoMap.GetAt("YL_YLCode")								;医疗机构单位名称
	s XSFMC=InvociePam.HospitalInfoMap.GetAt("XSF_MC")
	s invobj.recname=XSFMC										;收款人全称
	s XSFYHZH=InvociePam.HospitalInfoMap.GetAt("XSF_YHZH")
	s invobj.recacct=XSFYHZH											;收款人账号
	s XSFNSRSBH=InvociePam.HospitalInfoMap.GetAt("XSF_NSRSBH")
	s invobj.recopbk=XSFNSRSBH										;收款人开户行
	s invobj.payerpartytype="1"								;交款人类型1:个人2:单位
	s invobj.payerpartycode=ObjInvPrtInfo.PatBaseInfo.PatID				;患者身份证号码
	s invobj.payerpartyname=ObjInvPrtInfo.PatBaseInfo.PatName			;患者名称
	s invobj.payeracct=" "												;交款人账号
	s invobj.payeropbk=" "												;交款人开户行
	s invobj.paymode=" "												;交款方式
	s invobj.bizcode=ObjInvUpDetail.IUDBusNo							;业务流水号
	s invobj.currencytype="CNY"											;货币种类
	s invobj.exchangerate=0.00											;汇率
	s invobj.remark=" "												    ;备注
	s invobj.handlingperson=InvociePam.UserDesc					;开票人
	s invobj.checker=InvociePam.UserDesc								;复核人
	s invobj.supervisorremark=" "										;财政部门备注
	//退款相关票据
	s InvRefobj=##class(BILL.EINV.DTO.JSA.InvoiceRefInfo).%New()
	s InvRefobj.relatedinvoicecode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode			;相关票据代码
	s InvRefobj.relatedinvoicenumber=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo			;相关票据号码
	s InvRefobj.paycode=" "						;缴款码
	s invobj.mainext=InvRefobj
	d InvRefobj.%Close()
	//票面明细信息
	f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	.s InvDetaillistObj=##class(BILL.EINV.DTO.JSA.InvoiceListDetail).%New()
	.s InvDetaillistObj.itemcode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code			;项目编码
	.s InvDetaillistObj.itemname=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc			;收费项目名称
	.s InvDetaillistObj.unit=" "			;计量单位
	.s InvDetaillistObj.itemamount=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt				;金额
	.s InvDetaillistObj.num="1"				;数量
	.s InvDetaillistObj.stdtype=" "			;标准类型
	.//明细信息扩展
	.s InvItemextObj=##class(BILL.EINV.DTO.JSA.InvoiceItemText).%New()
	.s InvItemextObj.selfamt="0"					;自费金额 
	.s InvItemextObj.remark=" "			;备注信息
	.s InvDetaillistObj.Itemext=InvItemextObj
	.d InvItemextObj.%Close()
	.d invobj.detailitemlist.Insert(InvDetaillistObj)
	//辅助明细信息
	s InvAuxitemlistObj=##class(BILL.EINV.DTO.JSA.InvoiceAuxitemlist).%New()
	d invobj.auxitemlist.Insert(InvAuxitemlistObj)
	s BizType=..GetBusTypeByAdmType(ObjInvUpDetail.IUDPayAdmType,InvociePam.ObjUPConfig)
	
	i (ObjInvUpDetail.IUDPayAdmType="IP"){
		s invobj.invoicingsealid=InvociePam.HospitalInfoMap.GetAt("YL_ZYYZBH")		;;单位印章编号
	} 
	i (ObjInvUpDetail.IUDPayAdmType="OP")||(ObjInvUpDetail.IUDPayAdmType="REG"){
		s invobj.invoicingsealid=InvociePam.HospitalInfoMap.GetAt("YL_MZYZBH")		;;单位印章编号
	
	}
	//票据开具后的寄送\通知目的
	s InvAddressobj=##class(BILL.EINV.DTO.JSA.InvoiceAddress).%New()
	s InvAddressobj.email=ObjInvPrtInfo.PatBaseInfo.PatEmail     			;通知邮件地址
	s InvAddressobj.telephone=ObjInvPrtInfo.PatBaseInfo.Mobphone			;通知人电话
	s InvAddressobj.alipaycode=InvociePam.UserCode						;收款员编码
	s InvAddressobj.wechatorderno=" "						;微信订单号
	s invobj.recipientaddr=InvAddressobj
	d InvAddressobj.%Close()
	s invobj.attachinfo=" "				;附加信息
	
	;b.对象转Json
	set Stream=##class(%GlobalCharacterStream).%New()
	do ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	set jsonStr=Stream.Read()
   	quit jsonStr
}

/// 功能说明：调用服务接口获取开票状况服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 			ObjUPConfig		-->配置对象
/// 返 回 值：返回接口文档对应的json格式           
/// 修改履历：苏惠德   2019-12-17 
/// 其    他：w ##class(BILL.EINV.ADP.JSA).GetEINVResult("","","") 
ClassMethod GetEINVResult(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef OutputJsonStr As %String) As %String
{
	s RtnFlag="-1"
	s ErrMsg=""
	//入参通用信息
	s invobj=##class(BILL.EINV.DTO.JSA.InvoiceReq).%New()
	s ServiceCode="invoicequery"						;接口服务名称
	s invobj.cocode=InvociePam.HospitalInfoMap.GetAt("YL_YLCode")							;医疗机构编码
	s invobj.appid=InvociePam.HospitalInfoMap.GetAt("APP_ID")							;业务服务的编码
	s invobj.zonecode=InvociePam.HospitalInfoMap.GetAt("ZONE_Code")							;行政区划
	s invobj.timestamp=..GetBusDate(+$h,$p($h,"",2))							;发送请求的时间
	s invobj.version=InvociePam.HospitalInfoMap.GetAt("BMB_BBH")						;版本号	
	s invobj.method=ServiceCode
	s invobj.invoicecode=InvociePam.pBillBatchCode			;电子票据代码
	s invobj.invoicenumber=InvociePam.pBillNo				;电子票据号码
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s InputJson=Stream.Read()
	q:InputJson="" RtnFlg
	//调用江苏省财政厅http接口
	s outData=##class(BILL.EINV.BI.JSA.HTTPRequest).InvoiceRequest(InputJson, InvociePam.ObjUPConfig)

	//对返回结果进行解析
	s Rtn=..DecryptionResult(outData,.ErrMsg)
	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn="00000") d
	.s RtnFlag=0
	.s OutputJsonStr=outData
	e   s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, OutJsonStream As %String) As %String
{
	s RtnFlg="-1"
	
	s ResultMegObj=##class(BILL.EINV.DTO.JSA.InvoiceRes).%New()
	
	d ##class(web.INSUCacheJSON).RtnObjectFromJSON(.ResultMegObj,OutJsonStream)

	;s Stream=##class(%GlobalCharacterStream).%New()
	;d Stream.Write(OutJsonStream)
	;d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")

	//对返回结果的时间戳进行分割
	s createDate=ResultMegObj.issuedate					;返回日期"20191217"
	s createDate=$zdh(createDate,8)
	s ObjInvUpDetail.IUDResultCode=ResultMegObj.result					;处理结果代码
	s ObjInvUpDetail.IUDResultMeg=ResultMegObj.information				;详细信息
	s ObjInvUpDetail.IUDCreatDate=createDate							;电子票据生成日期
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.invoiceurl			;电子票据H5页面URL
	
	s RtnFlg="0"
	
	q RtnFlg
}

/// 功能说明：调用服务接口获取开具服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：苏惠德   2019-09-17 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).GetInvStatusOfInvoice("","","") 
ClassMethod GetInvStatusOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, OutJsonStream As %String) As %String
{
	s RtnFlg="-1"
	
	s ResultMegObj=##class(BILL.EINV.DTO.JSA.InvoiceRes).%New()
	;s Stream=##class(%GlobalCharacterStream).%New()
	;d Stream.Write(OutJsonStream)
	;d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
	
	d ##class(web.INSUCacheJSON).RtnObjectFromJSON(.ResultMegObj,OutJsonStream)
	//对返回结果的时间戳进行分割
	s createDate=ResultMegObj.issuedate						;返回日期"20191217"
	s createDate=$zdh(createDate,8)
	s EInvStatus=$Case(ResultMegObj.invoicestatus,"01":"0","04":"1",:0) 
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.invoicecode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.invoicenumber		;电子票据号码
	s ObjInvUpDetail.IUDResultCode=ResultMegObj.result					;处理结果代码
	s ObjInvUpDetail.IUDResultMeg=ResultMegObj.information				;详细信息
	s ObjInvUpDetail.IUDCreatDate=createDate							;电子票据生成日期
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.invoiceurl			;电子票据H5页面URL
	s ObjInvUpDetail.IUDBillBatchName=ResultMegObj.invoicingpartyname	;开票单位名称
	s ObjInvUpDetail.IUDBillisScarlet=EInvStatus							;是否已开红票
	s ObjInvUpDetail.IUDBusNo=ResultMegObj.bizcode						;业务流水号
	s ObjInvUpDetail.IUDCreatAmt=ResultMegObj.totalamount			;总金额
	
	i (ObjInvUpDetail.IUDUploadPathCode="Invoice"){			//开具
		s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
		s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
		s ObjInvUpDetail.EInvFlg="I"										;发票状态

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

/// 功能说明：   通过HIs卡类型获取对应的第三方的卡类型
/// 入参：       CardType：卡类型
/// 出参：       第三方接口对应的卡类型
/// 备注说明：   目前根据HIs卡类型和第三方接口文档里面提供的卡类型在程序里面进行匹配
ClassMethod GetBusCardType(CardType As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	;第三方卡类型(1102:社会保险号;3101:诊疗卡/就诊卡;4101:4101)
	//s BusCardType=$Case(CardType,"1":"1102","2":"3101","16":"3101","17":"1102","19":"3101","20":"3101","":"")    				 
    s BusCardType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("CardTypeCon"_ObjUPConfig.FactoryCode,CardType,5)
    q BusCardType
}

/// 功能说明：   通过支付方式编码获取对应的第三方的交费渠道信息
/// 入参：       PayModeCode：支付方式编码
/// 出参：       第三方接口对应的交费渠道
/// 备注说明：   目前根据HIs卡类型和第三方接口文档里面提供的卡类型在程序里面进行匹配
ClassMethod GetBusPayMode(PayModeCode As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	;第三方交费渠道
	//s BusPayModeCode=$Case(PayModeCode,"CASH":"02","CPP":"12","YHK":"07","CARDCPP":"08","ZP":"06","YBINSU1":"11",:"02")    				 
    s BusPayModeCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("PayModeCon"_ObjUPConfig.FactoryCode,PayModeCode,5)
    q BusPayModeCode
}

/// 功能说明：   通过HIs就诊类型获取对应的第三方的业务标识
/// 入参：       AdmType：就诊类型
/// (REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金) 
/// 出参：       第三方接口对应的业务标识
/// 编写：       guoyunlong
/// 备注说明：   目前根据就诊类型和第三方接口文档里面提供的业务标识在程序里面进行匹配
ClassMethod GetBusTypeByAdmType(AdmType As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	//s BusType=$Case(AdmType,"IP":"01","OP":"02","API":"02","OT":"02","IT":"01","PE":"05","REG":"06","DEP":"07",:0)    				 
    s BusType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("BusinessTypeCon"_ObjUPConfig.FactoryCode,AdmType,5)
    q BusType
}

/// 功能说明： 对第三方返回的json加密数据进行解析
/// w ##class(BILL.EINV.ADP.JSA).DecryptionResult("{""result"":""00000"",""information"":""success"",""count"":""1"",""invoicetypelist"":[{""invoice_type_code"":""320101"",""invoice_type_name"":""非税一般缴款书""},{""invoice_type_code"":""320000"",""invoice_type_name"":""北望一般缴款书""}]}")
ClassMethod DecryptionResult(Response, ByRef ErrMsg As %String) As %String
{
	s Rtn="-1"
	s ResultObj=##class(BILL.EINV.DTO.JSA.ResponseComm).%New()
	
	d ##class(web.INSUCacheJSON).RtnObjectFromJSON(.ResultObj,Response)
		
	;s ResultStream=##class(%GlobalCharacterStream).%New()
	;d ResultStream.Write(Response)
	;d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.ResultObj,"")
	s Rtn=ResultObj.result
	s ErrMsg=ResultObj.information
	q Rtn
}

/// 功能说明：   通过日期时间获取对应的第三方规定时间格式
/// 入参：       Date：日期
/// 			 Time: 时间
/// 出参：       第三方接口对应的时间格式(yyyyMMddHHmmss)
/// w ##class(BILL.EINV.ADP.JSA).GetBusDate(+$h,$p($h,",",2))
ClassMethod GetBusDate(Date, Time) As %String
{
	s rtnDate=""
	i Date'["-" d  s Date=$zd(Date,3)
	i Time'[":" d  s Time=$zt(Time,1)
	s rtnDate=$tr(Date,"-","")_$tr(Time,":","")
	q rtnDate
}

}
