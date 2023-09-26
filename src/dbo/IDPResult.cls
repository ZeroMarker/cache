/// 鉴定结果
Class dbo.IDPResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = IDP_Result ]
{

Index IndexMainReport On (LinkReportDR, VisitNumberReportDR) [ SqlName = Index_MainReport, Type = index ];

Index IndexChildReport On (VisitNumberReportDR, LinkReportDR) [ SqlName = Index_ChildReport, Type = index ];

Index IndexCultureNum On (VisitNumberReportDR, Flag, CultureNum) [ SqlName = Index_CultureNum, Type = index ];

Index IndexLinkRepMid On LinkRepMidDR [ SqlName = Index_LinkRepMid, Type = index ];

Index IndexLinkReport On LinkReportDR [ SqlName = Index_LinkReport, Type = index ];

Index IndexMaster On (VisitNumberReportDR, ParentDR, Sequence) [ SqlName = Index_Master, Type = index ];

Index IndexSaveDate On (VisitNumberReportDR, SaveDate, SaveTime) [ SqlName = Index_SaveDate, Type = index ];

/// Foreign Key FKIDPResultVisitNumberReportDR created via DDL
ForeignKey FKIDPResultVisitNumberReportDR(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_IDPResultVisitNumberReportDR ];

/// Foreign Key FKIDPResultLinkReportDR created via DDL
ForeignKey FKIDPResultLinkReportDR(LinkReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_IDPResultLinkReportDR ];

/// Foreign Key FKIDPResultIDPElementDR created via DDL
ForeignKey FKIDPResultIDPElementDR(IDPElementDR) References dbo.BTIDPElement(PKBTIDPELEMENT) [ SqlName = FK_IDPResultIDPElementDR ];

/// Foreign Key FKIDPResultParentDR created via DDL
ForeignKey FKIDPResultParentDR(ParentDR) References dbo.IDPResult(PKIDPRESULT) [ SqlName = FK_IDPResultParentDR ];

/// Foreign Key FKIDPResultOrganismDR created via DDL
ForeignKey FKIDPResultOrganismDR(OrganismDR) References dbo.BTOrganism(PKBTORGANISM) [ SqlName = FK_IDPResultOrganismDR ];

/// Foreign Key FKIDPResultAddUserDR created via DDL
ForeignKey FKIDPResultAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_IDPResultAddUserDR ];

/// Foreign Key FKIDPResultActUserDR created via DDL
ForeignKey FKIDPResultActUserDR(ActUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_IDPResultActUserDR ];

/// Foreign Key FKIDPResultSaveUserDR created via DDL
ForeignKey FKIDPResultSaveUserDR(SaveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_IDPResultSaveUserDR ];

/// Foreign Key FKIDPResultLinkRepMidDR created via DDL
ForeignKey FKIDPResultLinkRepMidDR(LinkRepMidDR) References dbo.RPVisitNumberRepMid(PKRPVISITNUMBERREPMID) [ SqlName = FK_IDPResultLinkRepMidDR ];

/// DDL Primary Key Specification
Index PKIDPRESULT On RowID [ PrimaryKey, SqlName = PK_IDP_RESULT, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 报告
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 鉴定元素
Property IDPElementDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 父节点
Property ParentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 说明
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 7 ];

/// 选择菌
Property OrganismDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 是否添加到报告
Property AddToReport As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 添加人
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 添加日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 添加时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 操作人
Property ActUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 操作日期
Property ActDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 操作时间
Property ActTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 是否打印
Property Printed As %Library.Boolean [ SqlColumnNumber = 16 ];

/// 关联中间报告
Property LinkRepMidDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 关联报告
Property LinkReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 构造方式0:模板，1:手工添加
Property MakeType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 保存人
Property SaveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 保存日期
Property SaveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 保存时间
Property SaveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 标志 1:分纯节点  2:转种节点
Property Flag As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 23 ];

/// 来自信息
Property FromInfo As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 24 ];

/// 分纯和转种序号
Property CultureNum As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 25 ];

Storage Default
{
<Data name="IDPResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>IDPElementDR</Value>
</Value>
<Value name="4">
<Value>ParentDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>OrganismDR</Value>
</Value>
<Value name="8">
<Value>AddToReport</Value>
</Value>
<Value name="9">
<Value>AddUserDR</Value>
</Value>
<Value name="10">
<Value>AddDate</Value>
</Value>
<Value name="11">
<Value>AddTime</Value>
</Value>
<Value name="12">
<Value>ActUserDR</Value>
</Value>
<Value name="13">
<Value>ActDate</Value>
</Value>
<Value name="14">
<Value>ActTime</Value>
</Value>
<Value name="15">
<Value>Printed</Value>
</Value>
<Value name="16">
<Value>LinkRepMidDR</Value>
</Value>
<Value name="17">
<Value>LinkReportDR</Value>
</Value>
<Value name="18">
<Value>MakeType</Value>
</Value>
<Value name="19">
<Value>SaveUserDR</Value>
</Value>
<Value name="20">
<Value>SaveDate</Value>
</Value>
<Value name="21">
<Value>SaveTime</Value>
</Value>
<Value name="22">
<Value>Flag</Value>
</Value>
<Value name="23">
<Value>FromInfo</Value>
</Value>
<Value name="24">
<Value>CultureNum</Value>
</Value>
</Data>
<DataLocation>^dbo.IDPResultD</DataLocation>
<DefaultData>IDPResultDefaultData</DefaultData>
<IdLocation>^dbo.IDPResultD</IdLocation>
<IndexLocation>^dbo.IDPResultI</IndexLocation>
<StreamLocation>^dbo.IDPResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
