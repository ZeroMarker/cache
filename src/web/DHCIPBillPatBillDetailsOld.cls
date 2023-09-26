/// 名称：   DHC_PatBillDetailsOld表管理类
/// 描述：	 有对DHC_PatBillDetailsOld表的增删改查的基本操作,供类间调用的类
/// 编写者：  汪会财
/// 编写日期：2009-4-20
Class web.DHCIPBillPatBillDetailsOld Extends %Persistent [ ClassType = persistent ]
{

ClassMethod INSERT() As %String
{
	d ..tb()
	&sql(INSERT INTO SQLUSER.DHC_PatBillDetailsOld values :PLIST())
	//i SQLCODE q ..SELECT(%ROWID) 
	//SQLCODE^NowRowid  NowRowid为当前插入的记录的rowid
	d ..tc()
	q SQLCODE
}

ClassMethod DELETE(ROWID) As %String
{
   
	d ..tb()
	&sql(DELETE FROM SQLUSER.DHC_PatBillDetailsOld WHERE PBDO_RowId= :ROWID)
	d ..tc()	
	q SQLCODE
}

ClassMethod UPDATE(ROWID) As %String
{
	d ..tb()
	&sql(UPDATE SQLUSER.DHC_PatBillDetailsOld values :PLIST() WHERE PBDO_RowId= :ROWID )
	d ..tc()
	//i SQLCODE q ..SELECT(%ROWID)
	//SQLCODE^NowRowid  NowRowid为当前更新的记录的rowid
	q SQLCODE
}

ClassMethod SELECT(ROWID) As %String
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM SQLUSER.DHC_PatBillDetailsOld WHERE PBDO_RowId= :ROWID)
	//s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
	q
}

Storage Default
{
<Data name="DHCIPBillPatBillDetailsOldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCIPBillPat978D</DataLocation>
<DefaultData>DHCIPBillPatBillDetailsOldDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCIPBillPat978D</IdLocation>
<IndexLocation>^web.DHCIPBillPat978I</IndexLocation>
<StreamLocation>^web.DHCIPBillPat978S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
