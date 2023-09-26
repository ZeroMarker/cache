Class dbo.RPXMHard Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_XMHard, StorageStrategy = Default ]
{

/// Foreign Key FKBDPackWorkGroup created via DDL
ForeignKey FKRPXMHardPatient(PatientDR) References dbo.RPPatient(PKRPPATIENT) [ SqlName = FK_RPXMHard_Patient ];

ForeignKey FKRPXMHardHType(XMHardTypeDR) References dbo.BBXMHardType(PKBBXMHARDTYPE) [ SqlName = FK_RPXMHard_HType ];

ForeignKey FKRPXMHardReqForm(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_RPXMHard_ReqForm ];

ForeignKey FKRPXMHardWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_RPXMHard_WorkGroup ];

Index IndexMaster On (PatientDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index ];

Index IndexXMHardType On (PatientDR, XMHardTypeDR) [ SqlName = Index_XMHardType, Type = index ];

/// DDL Primary Key Specification
Index PKRPXMHARD On RowID [ PrimaryKey, SqlName = PK_RP_XMHARD, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 患者信息
Property PatientDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 添加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 添加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 添加用户  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 疑难配血类型
Property XMHardTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 分析原因  
Property Reason As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 8 ];

/// 建议方案  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 9 ];

/// 申请单  
Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 最后修改日期  
Property LastDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 最后修改时间  
Property LastTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 最后修改用户  
Property LastUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 修改内容
Property Content As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="RPXMHardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>AddUserDR</Value>
</Value>
<Value name="6">
<Value>XMHardTypeDR</Value>
</Value>
<Value name="7">
<Value>Reason</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>ReqFormDR</Value>
</Value>
<Value name="10">
<Value>WorkGroupDR</Value>
</Value>
<Value name="11">
<Value>LastDate</Value>
</Value>
<Value name="12">
<Value>LastTime</Value>
</Value>
<Value name="13">
<Value>LastUserDR</Value>
</Value>
<Value name="14">
<Value>Content</Value>
</Value>
</Data>
<DataLocation>^dbo.RPXMHardD</DataLocation>
<DefaultData>RPXMHardDefaultData</DefaultData>
<IdLocation>^dbo.RPXMHardD</IdLocation>
<IndexLocation>^dbo.RPXMHardI</IndexLocation>
<StreamLocation>^dbo.RPXMHardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
