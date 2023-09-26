Class dbo.BBHandleWay Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_HandleWay, StorageStrategy = Default ]
{

/// Foreign Key FKBBAgreeHospital created via DDL
ForeignKey FKBBHandleWayHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_HandleWay_Hospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBHANDLEWAY On RowID [ PrimaryKey, SqlName = PK_BB_HANDLEWAY, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 加工方式存储数据说明:第1位代表辐照，第2位代办去白，第3位代表洗涤，第4和5位为扩展方式。如：YNNNN代表辐照，NYYNN代表去白+洗涤  
Property Ways As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 5 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活  
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBHandleWayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>Ways</Value>
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
<DataLocation>^dbo.BBHandleWayD</DataLocation>
<DefaultData>BBHandleWayDefaultData</DefaultData>
<IdLocation>^dbo.BBHandleWayD</IdLocation>
<IndexLocation>^dbo.BBHandleWayI</IndexLocation>
<StreamLocation>^dbo.BBHandleWayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
