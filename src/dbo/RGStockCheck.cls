Class dbo.RGStockCheck Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_StockCheck, StorageStrategy = Default ]
{

Index IndexMaster On StockCheckNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexCreateDate On CreateDate [ SqlName = Index_CreateDate, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

Index IndexCreator On (CreatorDR, CreateDate) [ SqlName = Index_Creator, Type = index ];

Index IndexChecker On (CheckerDR, CheckDate) [ SqlName = Index_Checker, Type = index ];

Index IndexStkIn On StkInDR [ SqlName = Index_StkIn, Type = index ];

Index IndexStkOut On StkOutDR [ SqlName = Index_StkOut, Type = index ];

Index IndexReagentGroupDR On ReagentGroupDR [ SqlName = Index_ReagentGroupDR, Type = index ];

/// DDL Primary Key Specification
Index PKRGSTOCKCHECK On RowID [ PrimaryKey, SqlName = PK_RG_STOCKCHECK, Type = index, Unique ];

ForeignKey FKRGStockCheckCreator(CreatorDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_StockCheck_Creator ];

ForeignKey FKRGStockCheckGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_StockCheck_Group ];

ForeignKey FKRGStockCheckChecker(CheckerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_StockCheck_Checker ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property StockCheckNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property CreatorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property CheckerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ Required, SqlColumnNumber = 11 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 12 ];

Property StkInDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property StkOutDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="RGStockCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StockCheckNo</Value>
</Value>
<Value name="3">
<Value>CreateDate</Value>
</Value>
<Value name="4">
<Value>CreateTime</Value>
</Value>
<Value name="5">
<Value>CreatorDR</Value>
</Value>
<Value name="6">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="7">
<Value>CheckDate</Value>
</Value>
<Value name="8">
<Value>CheckTime</Value>
</Value>
<Value name="9">
<Value>CheckerDR</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>Remark</Value>
</Value>
<Value name="12">
<Value>StkInDR</Value>
</Value>
<Value name="13">
<Value>StkOutDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RGStockCheckD</DataLocation>
<DefaultData>RGStockCheckDefaultData</DefaultData>
<IdLocation>^dbo.RGStockCheckD</IdLocation>
<IndexLocation>^dbo.RGStockCheckI</IndexLocation>
<StreamLocation>^dbo.RGStockCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
