/// 名称: BILL.CES.COM.Log.cls
/// 描述: 单机版程序导入日志处理
/// 编写者: xiongwang
/// 编写日期: 2020-11-03
Class BILL.CES.COM.Log Extends BILL.COM.Abstract
{

ClassMethod InsImportLog(seqNo, terminalNo, tableName, hisId, cesId, globalNo, uploadUser, origString)
{
	set $zt="ERROR"
	
	quit:((terminalNo="")||(tableName="")||(hisId="")||(cesId="")) -1
	set rtn=0

	ts
	
	set objLog=##class(BILL.CES.PO.DHCImportLog).%New()
	set objLog.IRSeqNo=seqNo
	set objLog.IRCESTerminalNo=terminalNo
	set objLog.IRTableName=tableName
	set objLog.IRHisId=hisId
	set objLog.IRCESId=cesId
	set objLog.IRCESGlobalNo=globalNo
	set objLog.IRCESOrigString=origString
	set objLog.IRCESUserName=uploadUser
	set objLog.IRDate=+$h
	set objLog.IRTime=$p($h,",",2)
	set sc=objLog.%Save()
	if ($system.Status.IsError(sc)) {
		tro
		quit $system.Status.GetErrorCodes(sc)
	}
	if ($tl>0) tc
	
	quit rtn
ERROR
	quit ..AppException()
}

/// Creator: xiongwang
/// CreatDate: 2020-11-10
/// Description: 根据单机版业务表和ID获取导入His的ID
/// Table: BILL_CES_PO.DHC_ImportLog
/// Debug: w ##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("oe_orditem","A012111250007")
ClassMethod GetHisIdByGlobalNo(tableName As %String, globalNo As %String) As %String
{
	set hisId=""
	
	if ((tableName'="")&&(globalNo'="")) {
		set tableName=$zcvt(tableName,"L")
		set id=0
		while($o(^BILL.CES.PO.DHCImportLogI("IDXTabGlobalNo",tableName,globalNo,id))) {
			set id=$o(^BILL.CES.PO.DHCImportLogI("IDXTabGlobalNo",tableName,globalNo,id))
			set logData=$g(^BILL.CES.PO.DHCImportLogD(id))
			set hisId=$lg(logData,4)
		}
	}
	quit hisId
}

/// Creator: xiongwang
/// CreatDate: 2020-11-10
/// Description: 根据单机版业务表+终端编号+ID获取导入His的ID
/// Table: BILL_CES_PO.DHC_ImportLog
/// Debug: w ##class(BILL.CES.COM.Log).GetImpHisId("02","I")
ClassMethod GetHisIdByCESId(tableName As %String, terminalNo As %String, cesId As %String) As %String
{
	set hisId=""
	if ((tableName'="")&&(terminalNo'="")&&(cesId'="")) {
		set tableName=$zcvt(tableName,"L")
		set id=0
		while($o(^BILL.CES.PO.DHCImportLogI("IDXTabCESId",tableName,terminalNo,cesId,id))) {
			set id=$o(^BILL.CES.PO.DHCImportLogI("IDXTabCESId",tableName,terminalNo,cesId,id))
			set logData=$g(^BILL.CES.PO.DHCImportLogD(id))
			set hisId=$lg(logData,4)
		}
	}
	quit hisId
}

/// Creator: xiongwang
/// CreatDate: 2021-09-08
/// Description: 根据业务表和ID获取判断数据是否是应急收费系统导入的数据
/// Table: BILL_CES_PO.DHC_ImportLog
/// Debug: w ##class(BILL.CES.COM.Log).IsCESFlag("02","I")
ClassMethod IsCESFlag(tableName As %String, rowId As %String) As %String
{
	set flag=0
	if ((tableName'="")&&(rowId'="")) {
		set tableName=$zcvt(tableName,"L")
		quit ($d(^BILL.CES.PO.DHCImportLogI("IDXTabHisId",tableName,rowId))'=0)
	}
	quit flag
}

/// Creator: ZhYW
/// CreatDate: 2022-07-21
/// Description: 根据业务表和ID获取应急系统数据导入日志信息
/// Table: BILL_CES_PO.DHC_ImportLog
/// Debug: w ##class(BILL.CES.COM.Log).GetCESImportLogInfo("DHC_INVPRT","624")
ClassMethod GetCESImportLogInfo(tableName As %String, rowId As %String) As %String
{
	set json={}
	if ((tableName="")||(rowId="")) quit json.%ToJSON()
	
	set tableName=$zcvt(tableName,"L")
	set logId=$o(^BILL.CES.PO.DHCImportLogI("IDXTabHisId",tableName,rowId,0))
	if (logId="") quit json.%ToJSON()
	set logData=$g(^BILL.CES.PO.DHCImportLogD(logId))
	set logDate=$lg(logData,2)
	set logTime=$lg(logData,3)
	set clientCode=$lg(logData,10)   //机器码
	set userName=$lg(logData,14)
	set logDate=##class(websys.Conversions).DateLogicalToHtml(logDate)
	set logTime=##class(websys.Conversions).TimeLogicalToHtml(logTime)
	set clientId=$o(^CF.BSP.SYS.ClientI("CodeInd",$zu(28,clientCode,7,32768),0))
	set clientLocation=$s((+clientId'=0):$lg(^CF.BSP.SYS.ClientD(clientId),8),1:"")   //客户端位置
	set json.logDate=logDate
	set json.logTime=logTime
	set json.clientCode=clientCode
	set json.userName=userName
	set json.clientLocation=clientLocation
	quit json.%ToJSON()
}

}
