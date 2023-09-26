/// 名称: web.DHCCPW.UpGrade.BaseDataSrv
/// 描述: 系统升级 基础数据处理
/// 编写者：zhufei
/// 编写日期: 2015-05-25
Class web.DHCCPW.UpGrade.BaseDataSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod ChangeLnkArcim()
{
	New
	Set return=0
	
	
	
	Quit return
}

Storage Default
{
<Data name="BaseDataSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW.UpG572D.BaseDataSrvD</DataLocation>
<DefaultData>BaseDataSrvDefaultData</DefaultData>
<IdLocation>^web.DHCCPW.UpG572D.BaseDataSrvD</IdLocation>
<IndexLocation>^web.DHCCPW.UpG572D.BaseDataSrvI</IndexLocation>
<StreamLocation>^web.DHCCPW.UpG572D.BaseDataSrvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
