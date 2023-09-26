/// 退费原因编辑
Class web.UDHCINVOPReasonEdit Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreateDate: 2020-05-20
/// Descripton: 判断是否有代码重复的记录
/// Table: DHC_INVOPRefReason
/// Debug: w ##class(web.UDHCINVOPReasonEdit).CheckCodeExist(23, "01")
ClassMethod CheckCodeExist(pId As %String, code As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("CheckCodeExist")=$lb(pId, code)
	set rtn=0
	quit:(code="") rtn
	
	set id=0
	while($o(^DHCINVOPREFR(id))) {
		set id=$o(^DHCINVOPREFR(id))
		continue:(id=pId)
		set data=$g(^DHCINVOPREFR(id))
		continue:(data="")
		set reaCode=$p(data,"^",1)
		continue:(reaCode'=code)
		set rtn=1_"^"_"代码已存在，不能重复添加"
		quit
	}
    quit rtn
ERROR
	quit ..AppException()
}

/// Description: 保存退费原因
/// Debug: w ##class(web.UDHCINVOPReasonEdit).SaveData()
ClassMethod SaveData(jsonStr As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("SaveData")=jsonStr
	set json=##class(%DynamicObject).%FromJSON(jsonStr)
	
	set rtn=0
	
	set oldData="{}"
	if (json.id>0) {
		set oldData=##class(web.DHCBillCommon).GetClsPropValById("User.DHCINVOPRefReason", json.id)   //取更新前的数据，用于留痕
	}
	
	set rtnVlaue=..CheckCodeExist(json.id, json.code)
	set rtn=$p(rtnVlaue,"^",1)
	quit:(+rtn) rtnVlaue
	
	ts
	
	if (json.id>0) {
		set dataObj=##class(User.DHCINVOPRefReason).%OpenId(json.id, 0)
	}else {
		set dataObj=##class(User.DHCINVOPRefReason).%New()
		set dataObj.IRRCode=json.code
		do dataObj.IRRHospDRSetObjectId(json.hospId)
	}
	set dataObj.IRRDesc=json.desc
	set sc=dataObj.%Save()
	do dataObj.%Close()
	set dataId=dataObj.%Id()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	
	if ($tl>0) tc
	
	//保存日志
	set className="User.DHCINVOPRefReason"
	set tableName=$g(^oddCOM(className,53))
	set classNameDesc="取消结算原因维护"
	set newData=##class(web.DHCBillCommon).GetClsPropValById("User.DHCINVOPRefReason", dataId)
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
/// CreatDate: 2018-11-09
/// Description: 查询退费原因
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCINVOPReasonEdit","ReadRefReason",2)
Query ReadRefReason(hospId As %String) As websys.Query(ROWSPEC = "id:%String:ID,code:%String:代码,text:%String:描述")
{
}

ClassMethod ReadRefReasonExecute(ByRef qHandle As %Binary, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
    set id=0
    while ($o(^DHCINVOPREFR(id))) {
	    set id=$o(^DHCINVOPREFR(id))
	    set data=$g(^DHCINVOPREFR(id))
	    continue:(data="")
	    set hospDR=$p(data,"^",3)
	    continue:(hospDR'=hospId)
	    set code=$p(data,"^",1)
	    set text=$p(data,"^",2)
	    do OutputRefReason
	}
	
	quit $$$OK
OutputRefReason
	set Data=$lb(id,code,text)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

}
