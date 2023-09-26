/// 出库类型汇总
Class dbo.BSOutPack Extends (%Persistent, %XML.Adaptor) [ Owner = {UnknownUser}, SqlTableName = BS_OutPack ]
{

Index IndexMaster On (WorkGroupDR, OutDate, OutType) [ SqlName = Index_Master, Type = index ];

Index IndexOutType On (OutType, WorkGroupDR, OutDate) [ SqlName = Index_OutType, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBSOutPackId On RowID [ PrimaryKey, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医院代码
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 日期
Property OutDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 1:输用 "报废回收回退回退 BB_PackStatus
Property OutType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 发血单号
Property Number As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BSOutPackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupDR</Value>
</Value>
<Value name="3">
<Value>OutDate</Value>
</Value>
<Value name="4">
<Value>OutType</Value>
</Value>
<Value name="5">
<Value>Number</Value>
</Value>
</Data>
<DataLocation>^dbo.BSOutPackD</DataLocation>
<DefaultData>BSOutPackDefaultData</DefaultData>
<IdLocation>^dbo.BSOutPackD</IdLocation>
<IndexLocation>^dbo.BSOutPackI</IndexLocation>
<StreamLocation>^dbo.BSOutPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
