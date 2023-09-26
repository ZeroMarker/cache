/// CTOR: QP
/// DATE: 2021-07-12
/// DESC: 医生交班本主表
Class User.DHCDocPassWorkNMain Extends (%Persistent, User.Abstract)
{

Relationship ChildSub As User.DHCDocPassWorkNSub [ Cardinality = children, Inverse = SParRef ];

Relationship ChildItem As User.DHCDocPassWorkNMainItem [ Cardinality = children, Inverse = IParRef ];

/// 科室
Property MLoc As CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = M_Loc ];

/// 班次日期
Property MBCDate As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = M_BCDate ];

/// 交班日期 [实际填写日期，一般和班次日期一致]
Property MSubmitDate As %Date [ SqlColumnNumber = 4, SqlFieldName = M_SubmitDate ];

/// 交班时间
Property MSubmitTime As %Time [ SqlColumnNumber = 5, SqlFieldName = M_SubmitTime ];

/// 交班人
Property MSubmitUser As SSUser [ SqlColumnNumber = 6, SqlFieldName = M_SubmitUser ];

/// 数据统计 
Property MXML As %String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = M_XML ];

/// 交班备注
Property MSubmitNote As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = M_SubmitNote ];

/// 交班类型
Property MBCCode As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = M_BCCode ];

/// 班次名称
Property MBCName As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = M_BCName ];

/// 班次开始时间
Property MBCSTime As %Time [ SqlColumnNumber = 11, SqlFieldName = M_BCSTime ];

/// 班次结束时间
Property MBCETime As %Time [ SqlColumnNumber = 12, SqlFieldName = M_BCETime ];

/// 班次跨日标志
Property MBCNextDay As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = M_BCNextDay ];

/// 第几班次
Property MBCSeqno As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = M_BCSeqno ];

/// 接班日期
Property MAccpetDate As %Date [ SqlColumnNumber = 15, SqlFieldName = M_AccpetDate ];

/// 接班时间
Property MAccpetTime As %Time [ SqlColumnNumber = 16, SqlFieldName = M_AccpetTime ];

/// 接班人
Property MAcceptUser As SSUser [ SqlColumnNumber = 17, SqlFieldName = M_AcceptUser ];

/// 接班备注
Property MAccpetNote As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = M_AccpetNote ];

/// 插入日期
Property MAddDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 19, SqlFieldName = M_AddDate ];

/// 插入时间
Property MAddTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 20, SqlFieldName = M_AddTime ];

/// 插入人
Property MAddUser As SSUser [ SqlColumnNumber = 21, SqlFieldName = M_AddUser ];

/// 更新日期
Property MUpdateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 22, SqlFieldName = M_UpdateDate ];

/// 更新时间
Property MUpdateTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 23, SqlFieldName = M_UpdateTime ];

/// 更新人
Property MUpdateUser As SSUser [ SqlColumnNumber = 24, SqlFieldName = M_UpdateUser ];

/// 医院
Property MHosp As CTHospital [ SqlColumnNumber = 25, SqlFieldName = M_Hosp ];

Index MHosp On MHosp As Exact;

Index MLoc On MLoc As Exact;

Index MUser On MSubmitUser As Exact;

Index MBCDate On MBCDate As Exact;

Index MBCCode On MBCCode As Exact;

Index MLocCode On (MLoc As Exact, MBCCode As Exact);

Index MLocBCDate On (MLoc As Exact, MBCDate As Exact);

Index MCodeSeqno On (MBCCode As Exact, MBCSeqno As Exact);

Index MLocMBCDateCode On (MLoc As Exact, MBCDate As Exact, MBCCode As Exact);

Index MLocCodeSeqno On (MLoc As Exact, MBCCode As Exact, MBCSeqno As Exact);

Index MLocMBCDateSeqno On (MLoc As Exact, MBCDate As Exact, MBCSeqno As Exact);

Storage Default
{
<Data name="DHCDocPassWorkNMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MLoc</Value>
</Value>
<Value name="3">
<Value>MBCDate</Value>
</Value>
<Value name="4">
<Value>MSubmitDate</Value>
</Value>
<Value name="5">
<Value>MSubmitTime</Value>
</Value>
<Value name="6">
<Value>MSubmitUser</Value>
</Value>
<Value name="7">
<Value>MXML</Value>
</Value>
<Value name="8">
<Value>MSubmitNote</Value>
</Value>
<Value name="9">
<Value>MBCCode</Value>
</Value>
<Value name="10">
<Value>MBCName</Value>
</Value>
<Value name="11">
<Value>MBCSTime</Value>
</Value>
<Value name="12">
<Value>MBCETime</Value>
</Value>
<Value name="13">
<Value>MBCNextDay</Value>
</Value>
<Value name="14">
<Value>MBCSeqno</Value>
</Value>
<Value name="15">
<Value>MAccpetDate</Value>
</Value>
<Value name="16">
<Value>MAccpetTime</Value>
</Value>
<Value name="17">
<Value>MAcceptUser</Value>
</Value>
<Value name="18">
<Value>MAccpetNote</Value>
</Value>
<Value name="19">
<Value>MAddDate</Value>
</Value>
<Value name="20">
<Value>MAddTime</Value>
</Value>
<Value name="21">
<Value>MAddUser</Value>
</Value>
<Value name="22">
<Value>MUpdateDate</Value>
</Value>
<Value name="23">
<Value>MUpdateTime</Value>
</Value>
<Value name="24">
<Value>MUpdateUser</Value>
</Value>
<Value name="25">
<Value>MHosp</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocPassWorkNMainD</DataLocation>
<DefaultData>DHCDocPassWorkNMainDefaultData</DefaultData>
<IdLocation>^User.DHCDocPassWorkNMainD</IdLocation>
<IndexLocation>^User.DHCDocPassWorkNMainI</IndexLocation>
<StreamLocation>^User.DHCDocPassWorkNMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
