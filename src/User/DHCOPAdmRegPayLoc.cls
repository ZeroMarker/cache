/// 挂号第三方支付交易日志
Class User.DHCOPAdmRegPayLoc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCOPAdmRegPayLoc ]
{

Index OnlyID On OnlyID;

Index OnlyTypeDesccDateTime On (OnlyTypeDesc, InsertDate, InsertTime);

Index InsertDateTime On (InsertDate, InsertTime);

Index InsertUserDateTime On (InsertUser, InsertDate, InsertTime);

/// 唯一ID
Property OnlyID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 唯一ID描述
Property OnlyTypeDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 插入日期
Property InsertDate As %Date [ SqlColumnNumber = 4 ];

/// 插入时间
Property InsertTime As %Time [ SqlColumnNumber = 5 ];

/// 操作人
Property InsertUser As SSUser [ SqlColumnNumber = 6 ];

/// 操作科室
Property InsertLoc As CTLoc [ SqlColumnNumber = 7 ];

/// 操作IP
Property InsertIP As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// 操作机器Mac
Property InsertMac As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

/// 支付接口调用信息
Property PayMesage As %String(COLLATION = "Exact", MAXLEN = 100000, TRUNCATE = 1) [ SqlColumnNumber = 10 ];

/// 支付接口返回信息
Property PayRtn As %String(COLLATION = "Exact", MAXLEN = 100000, TRUNCATE = 1) [ SqlColumnNumber = 11 ];

/// 备注
Property PayNote As %String(COLLATION = "Exact", MAXLEN = 100000, TRUNCATE = 1) [ SqlColumnNumber = 12 ];

/// 交易状态 0 正常 其他失败
Property Statu As %String [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="DHCOPAdmRegPayLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OnlyID</Value>
</Value>
<Value name="3">
<Value>OnlyTypeDesc</Value>
</Value>
<Value name="4">
<Value>InsertDate</Value>
</Value>
<Value name="5">
<Value>InsertTime</Value>
</Value>
<Value name="6">
<Value>InsertUser</Value>
</Value>
<Value name="7">
<Value>InsertLoc</Value>
</Value>
<Value name="8">
<Value>InsertIP</Value>
</Value>
<Value name="9">
<Value>InsertMac</Value>
</Value>
<Value name="10">
<Value>PayMesage</Value>
</Value>
<Value name="11">
<Value>PayRtn</Value>
</Value>
<Value name="12">
<Value>PayNote</Value>
</Value>
<Value name="13">
<Value>Statu</Value>
</Value>
</Data>
<DataLocation>^User.DHCOPAdmRegPayLocD</DataLocation>
<DefaultData>DHCOPAdmRegPayLocDefaultData</DefaultData>
<IdLocation>^User.DHCOPAdmRegPayLocD</IdLocation>
<IndexLocation>^User.DHCOPAdmRegPayLocI</IndexLocation>
<StreamLocation>^User.DHCOPAdmRegPayLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
