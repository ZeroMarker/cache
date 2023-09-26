/// Function: 基础数据表结构登记子表-例外医院
/// Creator: 基础数据平台-李可凡
/// CreateDate：2020年4月29日
Class User.BDPExceptionHosp Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_ExceptionHosp ]
{

Relationship ExceptionHospParRef As User.BDPTableList [ Cardinality = parent, Inverse = ChildExceptionHosp ];

/// 医院DR
Property HospitalDR As CTHospital [ Required ];

/// 是否启用
Property ActiveFlag As %String;

/// 开始日期
Property ActiveFrom As %Date;

/// 结束日期
Property ActiveTo As %Date;

Index HospitalIndex On (HospitalDR, ExceptionHospParRef) [ Unique ];

Storage Default
{
<Data name="BDPExceptionHospDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospitalDR</Value>
</Value>
<Value name="3">
<Value>ActiveFlag</Value>
</Value>
<Value name="4">
<Value>ActiveFrom</Value>
</Value>
<Value name="5">
<Value>ActiveTo</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildExceptionHosp")</DataLocation>
<DefaultData>BDPExceptionHospDefaultData</DefaultData>
<IdLocation>^User.BDPTableListC("ChildExceptionHosp")</IdLocation>
<IndexLocation>^User.BDPExceptionHospI</IndexLocation>
<StreamLocation>^User.BDPExceptionHospS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
