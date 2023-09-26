/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 医生交班本病人类型表
Class User.DHCDocPassWorkNSubType Extends (%Persistent, User.Abstract)
{

Relationship TParRef As User.DHCDocPassWorkNSub [ Cardinality = parent, Inverse = ChildType, Required, SqlFieldName = T_ParRef ];

/// 就诊ID
Property TAdmID As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = T_AdmID ];

/// 病人类型
Property TType As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = T_Type ];

/// 就诊科室 [和主表一致]
Property TLocID As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = T_LocID ];

/// 班次日期 [和主表一致]
Property TBCDate As %Date [ SqlColumnNumber = 5, SqlFieldName = T_BCDate ];

Index TType On TType As Exact;

Index TAdmType On (TAdmID, TType As Exact);

Index TAdmLocTypeBCDate On (TAdmID, TLocID, TType, TBCDate);

Storage Default
{
<Data name="DHCDocPassWorkNSubTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TAdmID</Value>
</Value>
<Value name="3">
<Value>TType</Value>
</Value>
<Value name="4">
<Value>TLocID</Value>
</Value>
<Value name="5">
<Value>TBCDate</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildType")</DataLocation>
<DefaultData>DHCDocPassWorkNSubTypeDefaultData</DefaultData>
<IdLocation>^User.DHCDocPassWorkNSubC("ChildType")</IdLocation>
<IndexLocation>^User.DHCDocPassWorkNSubTypeI</IndexLocation>
<StreamLocation>^User.DHCDocPassWorkNSubTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
