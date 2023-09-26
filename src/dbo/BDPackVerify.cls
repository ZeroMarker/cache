Class dbo.BDPackVerify Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackVerify, StorageStrategy = Default ]
{

/// DDL Primary Key Specification
Index IndexMaster On (PackDR, CheckStage) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL   
Index IndexVerDate On VerDate [ SqlName = Index_VerDate, Type = index ];

Index IndexWorkGroup On (WorkGroupDR, VerDate) [ SqlName = Index_WorkGroup, Type = index ];

Index IndexLocation On (LocationDR, VerDate) [ SqlName = Index_Location, Type = index ];

Index IndexPackDate On (PackDR, VerDate, VerTime) [ SqlName = Index_PackDate, Type = index ];

/// DDL Primary Key Specification
Index PKBDPACKVERIFY On RowID [ PrimaryKey, SqlName = PK_BDPACK_VERIFY, Type = index, Unique ];

/// Foreign Key FKCheckResultPack created via DDL
ForeignKey FKPackVerifyPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_PackVerify_Pack ];

/// Foreign Key FKCheckResultPack created via DDL
ForeignKey FKPackVerifyFirUser(FirUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_PackVerify_FirUser ];

/// Foreign Key FKCheckResultPack created via DDL
ForeignKey FKPackVerifySecUser(SecUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_PackVerify_SecUser ];

/// Foreign Key FKCheckResultPack created via DDL
ForeignKey FKPackVerifyIssueRecord(IssueRecordDR) References dbo.BDIssueRecord(PKBDISSUERECORD) [ SqlName = FK_PackVerify_IssueRecord ];

/// Foreign Key FKCheckResultPack created via DDL
ForeignKey FKPackVerifyWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_PackVerify_WorkGroup ];

/// Foreign Key FKCheckResultPack created via DDL
ForeignKey FKPackVerifyLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_PackVerify_Location ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血袋信息  
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血袋核查阶段  
Property CheckStage As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 核对日期  
Property VerDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 核对时间  
Property VerTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 第1核对人  
Property FirUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 第2核对人  
Property SecUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 核对是否成功  
Property IsPass As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 发血记录单  
Property IssueRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 备注
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 11 ];

/// 核对工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 核对临床科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 温度值  
Property TempValue As %Library.Float [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BDPackVerifyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackDR</Value>
</Value>
<Value name="3">
<Value>CheckStage</Value>
</Value>
<Value name="4">
<Value>VerDate</Value>
</Value>
<Value name="5">
<Value>VerTime</Value>
</Value>
<Value name="6">
<Value>FirUserDR</Value>
</Value>
<Value name="7">
<Value>SecUserDR</Value>
</Value>
<Value name="8">
<Value>IsPass</Value>
</Value>
<Value name="9">
<Value>IssueRecordDR</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
<Value name="11">
<Value>WorkGroupDR</Value>
</Value>
<Value name="12">
<Value>LocationDR</Value>
</Value>
<Value name="13">
<Value>TempValue</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackVerifyD</DataLocation>
<DefaultData>BDPackVerifyDefaultData</DefaultData>
<IdLocation>^dbo.BDPackVerifyD</IdLocation>
<IndexLocation>^dbo.BDPackVerifyI</IndexLocation>
<StreamLocation>^dbo.BDPackVerifyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
