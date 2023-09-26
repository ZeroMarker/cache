/// 血袋检测
Class dbo.BDPackTest Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackTest, StorageStrategy = Default ]
{

/// Foreign Key FKBDPBDPackTest created via DDL
ForeignKey FKBDPackTestPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_PacakTest_Pack ];

/// Foreign Key FKBDPackTestAddUser created via DDL
ForeignKey FKBDPackTestAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PackTest_AddUser ];

/// Foreign Key FKBDPackTestCheckUser created via DDL
ForeignKey FKBDPackTestCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PackTest_CheckUser ];

/// Foreign Key FKBDPackTestWorkGroup created via DDL
ForeignKey FKBDPackTestWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_PackTest_WorkGroup ];

Index IndexMaster On (TestDate, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexWorkGroup On (WorkGroupDR, TestDate, EpisNo) [ SqlName = Index_WorkGroup, Type = index ];

Index IndexAddDate On (WorkGroupDR, AddDate) [ SqlName = Index_AddDate, Type = index ];

Index IndexCheckDate On (WorkGroupDR, CheckDate) [ SqlName = Index_CheckDate, Type = index ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

Index IndexEpisNo On (TestDate, EpisNo) [ SqlName = Index_EpisNo, Type = index ];

/// DDL Primary Key Specification
Index PKBDPACKTEST On RowID [ PrimaryKey, SqlName = PK_BD_PACKTEST, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 检测日期  
Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血袋  
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 流水号  
Property EpisNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

/// 登记日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 登记时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 登记人
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 审核日期  
Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 审核时间  
Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 审核人
Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 状态   状态{1：登记，2：审核，3：取消审核}
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BDPackTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestDate</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
<Value name="4">
<Value>EpisNo</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
<Value name="8">
<Value>CheckDate</Value>
</Value>
<Value name="9">
<Value>CheckTime</Value>
</Value>
<Value name="10">
<Value>CheckUserDR</Value>
</Value>
<Value name="11">
<Value>WorkGroupDR</Value>
</Value>
<Value name="12">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackTestD</DataLocation>
<DefaultData>BDPackTestDefaultData</DefaultData>
<IdLocation>^dbo.BDPackTestD</IdLocation>
<IndexLocation>^dbo.BDPackTestI</IndexLocation>
<StreamLocation>^dbo.BDPackTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
