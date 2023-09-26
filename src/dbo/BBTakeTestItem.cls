/// 取血单评估检测项目
Class dbo.BBTakeTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_TakeTestItem, StorageStrategy = Default ]
{

/// Foreign Key FKBBTTIHospital created via DDL
ForeignKey FKBBTTIHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_TTI_Hospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBTAKETESTITEM On RowID [ PrimaryKey, SqlName = PK_BB_TAKETESTITEM, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 标准码  
Property SCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

/// LONIC码  
Property LonicCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

/// 结果是否必填  {1:true,0:false}
Property IsMandatory As %Library.Boolean [ SqlColumnNumber = 8 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 是否激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

/// 结果选项(对象字符串)  
Property ResultList As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BBTakeTestItemDefaultData">
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
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>SCode</Value>
</Value>
<Value name="6">
<Value>LonicCode</Value>
</Value>
<Value name="7">
<Value>IsMandatory</Value>
</Value>
<Value name="8">
<Value>SeqNum</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
<Value name="10">
<Value>ResultList</Value>
</Value>
</Data>
<DataLocation>^dbo.BBTakeTestItemD</DataLocation>
<DefaultData>BBTakeTestItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBTakeTestItemD</IdLocation>
<IndexLocation>^dbo.BBTakeTestItemI</IndexLocation>
<StreamLocation>^dbo.BBTakeTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
