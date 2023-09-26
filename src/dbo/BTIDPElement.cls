/// 鉴定元素
Class dbo.BTIDPElement Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_Element ]
{

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

/// Foreign Key FKBTIDPElementBindTestCodeDR created via DDL
ForeignKey FKBTIDPElementBindTestCodeDR(BindTestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTIDPElementBindTestCodeDR ];

/// DDL Primary Key Specification
Index PKBTIDPELEMENT On RowID [ PrimaryKey, SqlName = PK_BTIDP_ELEMENT, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 128) [ SqlColumnNumber = 4 ];

/// 1:文本 2:图片 3:单选下拉  4:单选展开  5:多选下拉  6:多选展开  7:归类节点  8：预报告 
/// 9:最终报告 0:多元素汇总,10:日期时间
/// 11:非菌报告  12:自由阴性报告报告
/// 13：菌报告   14：自由阳性报告
/// 15：培养目录  16：培养节点
/// 17:上机目录   18:上机节点
/// 0根节点 -1流程单 -2历次医嘱 -3 关注项目
/// 元素类型
Property ElementType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 绑定项目
Property BindTestCodeDR As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 允许医生查看
Property DocterView As %Library.Boolean [ SqlColumnNumber = 7 ];

/// 不允许打印
Property NoPrint As %Library.Boolean [ SqlColumnNumber = 8 ];

/// 打印数量
Property PrintNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BTIDPElementDefaultData">
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
<Value>ElementType</Value>
</Value>
<Value name="5">
<Value>BindTestCodeDR</Value>
</Value>
<Value name="6">
<Value>DocterView</Value>
</Value>
<Value name="7">
<Value>NoPrint</Value>
</Value>
<Value name="8">
<Value>PrintNum</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPElementD</DataLocation>
<DefaultData>BTIDPElementDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPElementD</IdLocation>
<IndexLocation>^dbo.BTIDPElementI</IndexLocation>
<StreamLocation>^dbo.BTIDPElementS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
