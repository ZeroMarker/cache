/// BDReqFormItemResult
Class dbo.BDReqFormItemResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqFormItemResult, StorageStrategy = Default ]
{

/// Foreign Key FKBDRFIRReqForm created via DDL
ForeignKey FKBDRFIRReqForm(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_RFIR_ReqForm ];

/// Foreign Key FKBDRFIRResultUser created via DDL
ForeignKey FKBDRFIRResultUser(ResultUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_RFIR_ResultUser ];

/// Foreign Key FKBDRFIRTestItem created via DDL
ForeignKey FKBDRFIRTestItem(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_BD_RFIR_TestItem ];

Index IndexMaster On (ReqFormDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDREQFORMITEMRESULT On RowID [ PrimaryKey, SqlName = PK_BD_REQFORMITEMRESULT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 申请单  
Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 结果  
Property Result As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 5 ];

/// 单位  
Property Unit As %Library.String(MAXLEN = 15) [ SqlColumnNumber = 6 ];

/// 参考范围  
Property RefRanges As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 7 ];

/// 审核日期  
Property ResultDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 审核时间  
Property ResultTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 审核者  
Property ResultUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 异常标志  
Property AbFlag As %Library.String(MAXLEN = 5) [ SqlColumnNumber = 12 ];

/// 检测项目分组 1：输血前9项，2：输血适应症
Property TestItemGroup As %Library.String(MAXLEN = 1) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BDReqFormItemResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqFormDR</Value>
</Value>
<Value name="3">
<Value>TestItemDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>Unit</Value>
</Value>
<Value name="6">
<Value>RefRanges</Value>
</Value>
<Value name="7">
<Value>ResultDate</Value>
</Value>
<Value name="8">
<Value>ResultTime</Value>
</Value>
<Value name="9">
<Value>ResultUserDR</Value>
</Value>
<Value name="10">
<Value>SeqNum</Value>
</Value>
<Value name="11">
<Value>AbFlag</Value>
</Value>
<Value name="12">
<Value>TestItemGroup</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReqFormItemResultD</DataLocation>
<DefaultData>BDReqFormItemResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDReqFormItemResultD</IdLocation>
<IndexLocation>^dbo.BDReqFormItemResultI</IndexLocation>
<StreamLocation>^dbo.BDReqFormItemResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
