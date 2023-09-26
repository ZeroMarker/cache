Class dbo.RGSupplierEvaluation Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_SupplierEvaluation, StorageStrategy = Default ]
{

Index IndexSupplier On SupplierDR [ SqlName = Index_Supplier, Type = index ];

Index PKRGSUPPLIEREVALUATION On RowID [ PrimaryKey, SqlName = PK_RG_SUPPLIEREVALUATION, Type = index, Unique ];

ForeignKey FKRGEvalSupplier(SupplierDR) References dbo.BTRGSupplier(PKBTRGSUPPLIER) [ SqlName = FK_RG_Eval_Supplier ];

ForeignKey FKRGEvalFilePath(FilePathDR) References dbo.RGFilePath(PKRGFILEPATH) [ SqlName = FK_RG_Eval_FilePath ];

ForeignKey FKRGEvalCreator(CreatorDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_Eval_Creator ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Evaluation As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 4 ];

Property FilePathDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property CreatorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="RGSupplierEvaluationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SupplierDR</Value>
</Value>
<Value name="3">
<Value>Evaluation</Value>
</Value>
<Value name="4">
<Value>FilePathDR</Value>
</Value>
<Value name="5">
<Value>CreatorDR</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.RGSupplierEvaluationD</DataLocation>
<DefaultData>RGSupplierEvaluationDefaultData</DefaultData>
<IdLocation>^dbo.RGSupplierEvaluationD</IdLocation>
<IndexLocation>^dbo.RGSupplierEvaluationI</IndexLocation>
<StreamLocation>^dbo.RGSupplierEvaluationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
