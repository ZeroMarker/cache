/// creator: xbl
/// createdate: 20171008
/// description: 操作日志
Class web.NurMgLogComm Extends %RegisteredObject
{

/// creator: xbl
/// createdate: 20171008
/// description: 保存操作日志
/// table: DHCNMG.Log.MgOpeateLog
/// input:
/// output:
/// return:
/// other:
ClassMethod SaveLog(table As %String, type As %String, olddata As %String, newdata As %String, user As %String) As %String
{
	q:(table="")!(type="")!((olddata="")&&(newdata=""))!(user="") 0
	s obj=##class(DHCNMG.Log.MgOperateLog).%New()
	s obj.LogTable=table
	s obj.LogType=type
	s obj.LogOldData=olddata
	s obj.LogNewData=newdata
	s obj.LogUserDR=##class(DHCNMG.HR.MgPersons).%OpenId(user)
	s obj.LogDate=+$h
	s obj.LogTime=$P($h,",",2)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

}
