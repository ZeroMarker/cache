/// 	血液寄存单明细
Class dbo.BDCheckRecordItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_CheckRecordItems ]
{

/// Foreign Key FKBDCheckRecordItemsCheckRecordDR created via DDL
ForeignKey FKBDCheckRecordItemsCheckRecordDR(CheckRecordDR) References dbo.BDCheckRecord(PKBDCHECKRECORD) [ SqlName = FK_BDCheckRecordItemsCheckRecordDR ];

/// Foreign Key FKBDCheckRecordItemsPackDR created via DDL
ForeignKey FKBDCheckRecordItemsPackDR(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BDCheckRecordItemsPackDR ];

/// Foreign Key FKBDCheckRecordItemsOutUserDR created via DDL
ForeignKey FKBDCheckRecordItemsOutUserDR(OutUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDCheckRecordItemsOutUserDR ];

/// Foreign Key FKBDCheckRecordItemsTakeUserDR created via DDL
ForeignKey FKBDCheckRecordItemsTakeUserDR(TakeUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDCheckRecordItemsTakeUserDR ];

/// Foreign Key FKBDCheckRecordItemsCheckTypeDR created via DDL
ForeignKey FKBDCheckRecordItemsCheckTypeDR(CheckTypeDR) References dbo.BBCheckType(PKBBCHECKTYPE) [ SqlName = FK_BDCheckRecordItemsCheckTypeDR ];

/// Foreign Key FKBDCheckRecordItemsIssueRecordDR created via DDL
ForeignKey FKBDCheckRecordItemsIssueRecordDR(IssueRecordDR) References dbo.BDIssueRecord(PKBDISSUERECORD) [ SqlName = FK_BDCheckRecordItemsIssueRecordDR ];

/// DDL Primary Key Specification
Index PKBDCHECKRECORDITEMS On RowID [ PrimaryKey, SqlName = PK_BD_CHECKRECORDITEMS, Type = index, Unique ];

Index IndexMaster On (CheckRecordDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

Index IndexOutDate On OutDate [ SqlName = Index_OutDate, Type = index ];

Index IndexOutUser On (OutUserDR, OutDate) [ SqlName = Index_OutUser, Type = index ];

Index IndexTakeUser On (TakeUserDR, OutDate) [ SqlName = Index_TakeUser, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血液寄存单
Property CheckRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血袋
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 取走日期
Property OutDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 取走时间
Property OutTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 交出用户
Property OutUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 接收用户
Property TakeUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 接收用户姓名
Property TakeUserName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// 寄存状态 I:库存，O：出库, C：取消 枚举类：BLD.ENUM.CheckType
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 10 ];

/// 取走原因
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 寄存出库类型
Property CheckTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 发血记录单
Property IssueRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 13 ];

/// 暂存位置
Property StockPosition As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BDCheckRecordItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckRecordDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
<Value name="4">
<Value>OutDate</Value>
</Value>
<Value name="5">
<Value>OutTime</Value>
</Value>
<Value name="6">
<Value>OutUserDR</Value>
</Value>
<Value name="7">
<Value>TakeUserDR</Value>
</Value>
<Value name="8">
<Value>TakeUserName</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
<Value name="11">
<Value>CheckTypeDR</Value>
</Value>
<Value name="12">
<Value>IssueRecordDR</Value>
</Value>
<Value name="13">
<Value>StockPosition</Value>
</Value>
</Data>
<DataLocation>^dbo.BDCheckRecordItemsD</DataLocation>
<DefaultData>BDCheckRecordItemsDefaultData</DefaultData>
<IdLocation>^dbo.BDCheckRecordItemsD</IdLocation>
<IndexLocation>^dbo.BDCheckRecordItemsI</IndexLocation>
<StreamLocation>^dbo.BDCheckRecordItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
