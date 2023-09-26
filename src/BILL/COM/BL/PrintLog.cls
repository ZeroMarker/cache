/// 名称: BILL.COM.BL.PrintLog.cls
/// 描述: 单据打印日志业务逻辑类
/// 编写者: ZhYW
/// 编写日期: 2021-05-20
Class BILL.COM.BL.PrintLog Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2021-05-20
/// Description: XML打印日志保存
/// Input: className:打印类名称, methodName:打印方法名称, keyCode:单据代码, keyValue:单据主索引, 
///        txtObj: TxtData对象, listObj: ListData的json数组对象, args: 打印方法形参值，userId:操作员
/// Return: =0:更新成功, <>0:更新失败
/// Debug: w ##class(BILL.COM.BL.PrintLog).XMLPrintLog()
ClassMethod XMLPrintLog(className As %String, methodName As %String, keyCode As %String, keyValue As %String, txtObj As %DynamicObject, listObj As %DynamicArray, args As %List, userId As %String = "") As %String
{
	set $zt="ERROR"
	set rtn=0
	
	if (userId="")&&($d(%session)) {
		set userId=%session.Get("LOGON.USERID")
	}
	
	set paramO=##class(%DynamicObject).%New()
	set pNames=##class(BILL.Util.Tools).GetMethodParams(className, methodName)
	for i=1:1:$l(pNames,",") {
		set name=$p(pNames,",",i)
		continue:(name="")
		do paramO.%Set(name, $lg(args,i))
	}
	set params=paramO.%ToJSON()

	set contentO=##class(%DynamicObject).%New()
	set contentO.TxtData=txtObj
	set contentO.ListData=listObj
	set stream=##class(%Stream.GlobalCharacter).%New()
	do contentO.%ToJSON(.stream)
	
	set rtn=##class(BILL.COM.BL.PrintLog).Save(keyCode, keyValue, params, stream, userId)
	quit rtn
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2021-05-20
/// Description: 插入单据打印日志表
/// Return: =0:更新成功, <>0:更新失败
/// Debug: w ##class(BILL.COM.BL.PrintLog).Save()
ClassMethod Save(keyCode As %String, keyValue As %String, conditions As %String, content As %Stream.GlobalCharacter, userId As %String = "") As %String
{
	set $zt="ERROR"
	set rtn=0
	
	if (userId="")&&($d(%session)) {
		set userId=%session.Get("LOGON.USERID")
	}
	
	//已存在记录时，增加打印次数
	set oLogId=$o(^BILL.COM.PO.PrintLogI("IdxKeyValue",keyCode,keyValue,0))
	if (oLogId>0) {
		quit ..AddTimes(oLogId, userId)
	}
	
	ts
	
	set dataObj=##class(BILL.COM.PO.PrintLog).%New()
	set dataObj.KeyCode=keyCode
	set dataObj.KeyValue=keyValue
	set dataObj.Conditions=conditions
	set dataObj.Content=content
	do dataObj.OpterIdSetObjectId(userId)
	set sc=dataObj.%Save()
	do dataObj.%Close()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	if ($tl>0) tc
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2021-05-20
/// Description: 更新打印日志表打印次数
/// Return: =0:更新成功, <>0:更新失败
/// Debug: w ##class(BILL.COM.BL.PrintLog).AddTimes()
ClassMethod AddTimes(logId As %String, userId As %String = "") As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	if (userId="")&&($d(%session)) {
		set userId=%session.Get("LOGON.USERID")
	}
	
	ts
	
	set dataObj=##class(BILL.COM.PO.PrintLog).%OpenId(logId, 0)
	set dataObj.PrintTimes=dataObj.PrintTimes+1
	do dataObj.UpdtIdSetObjectId("")
	set dataObj.UpdtDate=+$h
	set dataObj.UpdtTime=$p($h,",",2)
	set sc=dataObj.%Save()
	do dataObj.%Close()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	if ($tl>0) tc
	
	quit rtn
	
ERROR
	quit ..AppException()
}

}
