/// CTOR: QP
/// DATE: 2020-09-18
/// DESC: 药量筛选预警对外公共Service [V4.1.0++]
Class DHCDoc.GCPSW.ENS.CommonService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "CommonService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// CTOR: QP
/// SENO: C0001
/// DATE: 2020-09-18
/// DESC: 同步科研筛选系统数据
/// IN  : 
/// NOTE: http://10.160.16.90:57772/dthealth/web/DHCDoc.GCPSW.ENS.CommonService.cls
/// OUT : 1:更新成功   其他：更新失败
Method SyncData(mList) As %String [ WebMethod ]
{
	set mRtn=##class(DHCDoc.GCPSW.BS.Result).SyncData(mList)
	Quit mRtn
}

/// CTOR: QP
/// SENO: C0002
/// DATE: 2020-09-23
/// DESC: 同步科研筛选系统索引
/// IN  : LID:日志ID
/// NOTE: http://10.160.16.90:57772/dthealth/web/DHCDoc.GCPSW.ENS.CommonService.cls
/// OUT : 1:更新成功   其他：更新失败
Method SyncIndex(mList) As %String [ WebMethod ]
{
	set mRtn=##class(DHCDoc.GCPSW.BS.Result).SyncIndex(mList)
	Quit mRtn
}

/// CTOR: QP
/// SENO: C0003
/// DATE: 2020-11-24
/// DESC: 记录开始时间
/// IN  : 
/// NOTE: http://10.160.16.90:57772/dthealth/web/DHCDoc.GCPSW.ENS.CommonService.cls
/// OUT : 1:更新成功   其他：更新失败
Method RecStart() As %String [ WebMethod ]
{
	s LID=##class(DHCDoc.GCPSW.BS.TaskLog).Save("","","WS")
	Quit LID
}

/// CTOR: QP
/// SENO: C0004
/// DATE: 2020-11-24
/// DESC: 记录结束时间
/// IN  : 
/// NOTE: http://10.160.16.90:57772/dthealth/web/DHCDoc.GCPSW.ENS.CommonService.cls
/// OUT : 1:更新成功   其他：更新失败
Method RecEnd(LID) As %String [ WebMethod ]
{
	s mRtn= ##class(DHCDoc.GCPSW.BS.TaskLog).Save("",LID)
	Quit mRtn
}

}
