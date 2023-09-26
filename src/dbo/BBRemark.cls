Class dbo.BBRemark Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_Remark, StorageStrategy = Default ]
{

/// Foreign Key FKBBAgreeHospital created via DDL
ForeignKey FKBBRemarkHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_Remark_Hospital ];

Index IndexMaster On (HospitalDR, OPType, Code) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBREMARK On RowID [ PrimaryKey, SqlName = PK_BB_REMARK, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  1:申请备血原因 2 大量用血原因 3:申请单作废原因 4:申请单审批原因 5:申请单拒审原因 6血液寄存原因 7退回血站 8血液报废原因 9血液调拨原因 10外院发血原因  11 血液未正常输注结束原因 12 输血后评价无效原因 13 取消配发血原因 
Property OPType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 5 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活  
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBRemarkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OPType</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBRemarkD</DataLocation>
<DefaultData>BBRemarkDefaultData</DefaultData>
<IdLocation>^dbo.BBRemarkD</IdLocation>
<IndexLocation>^dbo.BBRemarkI</IndexLocation>
<StreamLocation>^dbo.BBRemarkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
