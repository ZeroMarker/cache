/// 名称: BILL.CFG.IP.CancelChgReason.cls
/// 描述: 取消结算原因维护业务类
/// 编写者: ZhYW
/// 编写日期: 2022-06-21
/// 产品组：计费医保组
Class BILL.CFG.IP.CancelChgReason Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2022-06-21
/// Description: 查询取消结算原因
/// Input: 
/// Output: ID,代码,取消结算原因,生效开始日期,生效结束日期,创建人,创建日期,创建时间,更新人,更新日期,更新时间
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.IP.CancelChgReason","QryReasonList","2")
Query QryReasonList(hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "Id:%String:ID,ReasonCode:%String:代码,ReasonDesc:%String:取消结算原因,DateFrom:%String:生效开始日期,DateTo:%String:生效结束日期,CreatUserName:%String:创建人,CreatDate:%String:创建日期,CreatTime:%String:创建时间,UpdtUserName:%String:更新人,UpdtDate:%String:更新日期,UpdtTime:%String:更新时间")
{
}

ClassMethod QryReasonListExecute(ByRef qHandle As %Binary, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("QryReasonList")=$lb(hospId, langId)
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set id=0
	while($o(^CF.BILL.IP.CancelChgReasonD(id))) {
		set id=$o(^CF.BILL.IP.CancelChgReasonD(id))
		do GetReasonData
	}
	quit $$$OK
GetReasonData
	set data=$g(^CF.BILL.IP.CancelChgReasonD(id))
	set hospDR=$lg(data,12)
	quit:(hospDR'=hospId)
	set reasonCode=$lg(data,2)
	set reasonDesc=$lg(data,3)
	set reasonDesc=##class(CF.BILL.IP.CancelChgReason).GetTranByDesc("ReaDesc", reasonDesc, langId)
	set dateFrom=$lg(data,4)
	set dateTo=$lg(data,5)
	set dateFrom=##class(websys.Conversions).DateLogicalToHtml(dateFrom)
	set dateTo=##class(websys.Conversions).DateLogicalToHtml(dateTo)
	set creatUserDR=$lg(data,6)
	set creatUserName=$s((+creatUserDR'=0):$p(^SSU("SSUSR",creatUserDR),"^",2),1:"")
	set creatUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", creatUserName, langId)
	set creatDate=$lg(data,7)
	set creatTime=$lg(data,8)
	set creatDate=##class(websys.Conversions).DateLogicalToHtml(creatDate)
	set creatTime=##class(websys.Conversions).TimeLogicalToHtml(creatTime)
	set updtUserDR=$lg(data,9)
	set updtUserName=$s((+updtUserDR'=0):$p(^SSU("SSUSR",updtUserDR),"^",2),1:"")
	set updtUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", updtUserName, langId)
	set updtDate=$lg(data,10)
	set updtTime=$lg(data,11)
	set updtDate=##class(websys.Conversions).DateLogicalToHtml(updtDate)
	set updtTime=##class(websys.Conversions).TimeLogicalToHtml(updtTime)
	do OutputReasonList
	quit
OutputReasonList
	set data=$lb(id,reasonCode,reasonDesc,dateFrom,dateTo,creatUserName,creatDate,creatTime,updtUserName,updtDate,updtTime)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-06-21
/// Description: 保存配置数据
/// Input: 
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(BILL.CFG.IP.CancelChgReason).SaveData("{""Id"":""16"",""arcimId"":""3885||1"",""dateFrom"":"""",""dateTo"":"""",""userId"":""1"",""hospId"":""2""}")
ClassMethod SaveData(jsonStr As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("SaveData")=jsonStr
	set json=##class(%DynamicObject).%FromJSON(jsonStr)
	
	set json.dateFrom=##class(websys.Conversions).DateHtmlToLogical(json.dateFrom)
	set json.dateTo=##class(websys.Conversions).DateHtmlToLogical(json.dateTo)
	set json.UpdtDate=##class(websys.Conversions).DateHtmlToLogical(json.UpdtDate)
	set json.UpdtTime=##class(websys.Conversions).DateHtmlToLogical(json.UpdtTime)
	
	set rtn=0
	
	if (json.dateFrom=0) {
		quit -1_"^"_"生效开始日期不能为空"
	}
	if (json.dateTo>0) {
		if (json.dateTo<+$h) {
			quit -1_"^"_"生效结束日期不能小于当天"
		}
		if (json.dateTo<json.dateFrom) {
			quit -1_"^"_"生效结束日期不能小于生效开始日期"
		}
	}
	
	set oldData="{}"
	if (json.Id>0) {
		set oldData=##class(web.DHCBillCommon).GetClsPropValById("CF.BILL.IP.CancelChgReason", json.Id)   //取更新前的数据，用于留痕
	}else {
		if (json.dateFrom<+$h) {
			quit -1_"^"_"生效开始日期不能小于当天"
		}
	}
	
	set rtnVlaue=..CheckCodeExist(json.Id, json.reaCode)
	set rtn=$p(rtnVlaue,"^",1)
	quit:(+rtn) rtnVlaue
	
	ts
	
	if (json.Id>0) {
		set dataObj=##class(CF.BILL.IP.CancelChgReason).%OpenId(json.Id, 0)
		do dataObj.UpdtUserDRSetObjectId(json.userId)
		set dataObj.UpdtDate=+$h
		set dataObj.UpdtTime=$p($h,",",2)
	}else {
		set dataObj=##class(CF.BILL.IP.CancelChgReason).%New()
		set dataObj.ReaCode=json.reaCode
		do dataObj.CreatUserDRSetObjectId(json.userId)
		do dataObj.HospDRSetObjectId(json.hospId)
	}
	set dataObj.ReaDesc=json.reaDesc
	set dataObj.DateFrom=json.dateFrom
	set dataObj.DateTo=json.dateTo
	set sc=dataObj.%Save()
	do dataObj.%Close()
	set dataId=dataObj.%Id()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	
	if ($tl>0) tc
	
	//保存日志
	set className="CF.BILL.IP.CancelChgReason"
	set tableName=$g(^oddCOM(className,53))
	set classNameDesc="取消结算原因维护"
	set newData=##class(web.DHCBillCommon).GetClsPropValById("CF.BILL.IP.CancelChgReason", dataId)
	if (json.Id>0) {
		do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(tableName, className, classNameDesc, dataId, "修改", "U", newData, oldData, json.userId)
	}else {
		do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(tableName, className, classNameDesc, dataId, "插入", "A", newData, json.userId)
	}
	
	quit rtn
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-06-21
/// Description: 校验是否重复
/// Input: Id:CF_BILL_IP.CancelChgReason.RowId, code:退院原因代码
/// Return: 0:否, 1:是
/// Debug: w ##class(BILL.CFG.IP.CancelChgReason).CheckCodeExist("1","01")
ClassMethod CheckCodeExist(Id As %String, code As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("CheckCodeExist")=$lb(Id, code)
	set rtn=0
	quit:(code="") rtn
	
	set pId=""
	set id=0
	while($o(^CF.BILL.IP.CancelChgReasonI("IdxReaCode",code,id))) {
		set id=$o(^CF.BILL.IP.CancelChgReasonI("IdxReaCode",code,id))
		set data=$g(^CF.BILL.IP.CancelChgReasonD(id))
		set pId=id
		quit
	}
	set rtn=((pId'="")&&(pId'=Id))
	quit:(+rtn) +rtn_"^"_"代码已存在，不能重复添加"
	quit 0
ERROR
	quit ..AppException()
}

}
