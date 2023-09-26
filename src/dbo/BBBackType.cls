Class dbo.BBBackType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BackType, StorageStrategy = Default ]
{

/// Foreign Key FKBBAgreeHospital created via DDL
ForeignKey FKBBRemarkHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_Remark_Hospital ];

Index IndexMaster On (HospitalDR, OPType, Code) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBBACKTYPE On RowID [ PrimaryKey, SqlName = PK_BB_BACKTYPE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  7：退回血站，8：血液报废，13:取消发血，14：取消配血
Property OPType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 代码  
Property Code As %Library.String(MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

/// 名称  
Property CName As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 5 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活  
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBBackTypeDefaultData">
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
<DataLocation>^dbo.BBBackTypeD</DataLocation>
<DefaultData>BBBackTypeDefaultData</DefaultData>
<IdLocation>^dbo.BBBackTypeD</IdLocation>
<IndexLocation>^dbo.BBBackTypeI</IndexLocation>
<StreamLocation>^dbo.BBBackTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
