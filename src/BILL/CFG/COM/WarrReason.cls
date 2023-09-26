/// 名称: BILL.CFG.COM.WarrReason.cls
/// 描述: 担保原因维护业务类
/// 编写者: LUANZH
/// 编写日期: 2022-11-2
/// 产品组：计费医保组
Class BILL.CFG.COM.WarrReason Extends BILL.COM.Abstract
{

/// Creator: LUANZH
/// CreatDate: 2022-11-1
/// Description: 查询担保原因
/// Input: 
/// Output: 代码，描述,开始日期，结束日期，创建人,创建日期,创建时间,更新人,更新日期,更新时间
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.COM.WarrReason","QryWarrReasonList","")
Query QryWarrReasonList(langId As %String = "") As websys.Query(ROWSPEC = "CfgId:%String:配置ID,WarrCode:%String:担保原因代码,WarrDesc:%String:担保原因描述,DateFrom:%String:开始日期,DateTo:%String:结束日期,CreatUserName:%String:创建人,CreatDate:%String:创建日期,CreatTime:%String:创建时间,UpdtUserName:%String:更新人,UpdtDate:%String:更新日期,UpdtTime:%String:更新时间")
{
}

ClassMethod QryWarrReasonListExecute(ByRef qHandle As %Binary, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("QryWarrReasonList")=$lb(langId)
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}

	set id=0
	while($o(^CF.BILL.COM.WarrReasonD(id))) {
		set id=$o(^CF.BILL.COM.WarrReasonD(id))
		do GetARCIMCfgData
	}
	quit $$$OK
GetARCIMCfgData
	set data=$g(^CF.BILL.COM.WarrReasonD(id))
	set warrCode=$lg(data,2)
	quit:(warrCode="")
	set warrDesc=$lg(data,3)
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
	do OutputARCIMCfgList
	quit
OutputARCIMCfgList
	set data=$lb(id,warrCode,warrDesc,dateFrom,dateTo,creatUserName,creatDate,creatTime,updtUserName,updtDate,updtTime)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	quit
}

/// Creator: LUANZH
/// CreatDate: 2022-11-1
/// Description: 保存担保原因
/// Input: 
/// Output: 
/// Debug: 
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
	if (json.warrCode="") {
		quit -1_"^"_"担保原因代码不能为空"
	}
	if (json.warrDesc="") {
		quit -1_"^"_"担保原因描述不能为空"
	}
	
	
	set oldData="{}"
	if (json.cfgId>0) {
		
		set oldData=##class(web.DHCBillCommon).GetClsPropValById("CF.BILL.COM.WarrReason", json.cfgId)   //取更新前的数据，用于留痕
		if (json.dateFrom<+$h) {
			quit -1_"^"_"生效开始日期不能小于当天"
		}
	}else{
		if (json.dateFrom<+$h) {
			quit -1_"^"_"生效开始日期不能小于当天"
		}
	}
	
	//校验代码或者担保原因是否重复
	if (json.cfgId<=0) {
		set rtnVlaue=..ChkIsRepeat(json.warrCode,json.warrDesc)
		q:rtnVlaue'=0 rtnVlaue
	}
	
	ts
	
	if (json.cfgId>0) {
		set dataObj=##class(CF.BILL.COM.WarrReason).%OpenId(json.cfgId, 0)
		do dataObj.UpdtUserDRSetObjectId(json.userId)
		set dataObj.UpdtDate=+$h
		set dataObj.UpdtTime=$p($h,",",2)
		set dataObj.DateFrom=json.dateFrom
		set dataObj.DateTo=json.dateTo
		set dataObj.Reason=json.warrDesc
	}else {
		set dataObj=##class(CF.BILL.COM.WarrReason).%New()
		set dataObj.DateFrom=json.dateFrom
		set dataObj.DateTo=json.dateTo
		set dataObj.Code=json.warrCode
		set dataObj.Reason=json.warrDesc
		do dataObj.CreatUserDRSetObjectId(json.userId)
	}
	set sc=dataObj.%Save()
	do dataObj.%Close()
	set dataId=dataObj.%Id()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	
	if ($tl>0) tc
	
	//保存日志
	set className="CF.BILL.COM.WarrReason"
	set tableName=$g(^oddCOM(className,53))
	set classNameDesc="担保原因维护"
	set newData=##class(web.DHCBillCommon).GetClsPropValById("CF.BILL.COM.WarrReason", dataId)
	if (json.cfgId>0) {
		do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(tableName, className, classNameDesc, dataId, "修改", "U", newData, oldData, json.userId)
	}else {
		do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(tableName, className, classNameDesc, dataId, "插入", "A", newData, json.userId)
	}
	
	quit rtn
ERROR
	quit ..AppException()
}

/// Creator: LUANZH
/// CreatDate: 2022-11-1
/// Description: 校验是否重复
/// Input: cfgId:CF_BILL_COM.WarrReason.RowId, warrCode
/// Return: 0 :否；提示信息:是
/// Debug: w ##class(BILL.CFG.COM.WarrReason).ChkIsRepeat("","")
ClassMethod ChkIsRepeat(warrCode As %String, warrDesc As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("ChkIsRepeat")=$lb(warrCode,warrDesc)
	set rtn=0
	set pId=""
	set id=0
	set id=$o(^CF.BILL.COM.WarrReasonI("IdxCode",warrCode,id))
	set pId=id
	if (pId="") {
		set pId=$o(^CF.BILL.COM.WarrReasonI("IdxReason",warrDesc,id))
		if (pId'="") {
			set rtn="担保原因'"_warrDesc_"'"_"已存在，不能重复添加"
		}
	}else {
		set rtn="代码'"_warrCode_"'"_"已存在,不能重复添加"
	}
	quit rtn
ERROR
	quit ..AppException()
}

}
