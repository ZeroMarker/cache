/// 医嘱图片配置
Class dbo.BTTestsetImageConfig Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestsetImageConfig ]
{

/// Foreign Key FKTestSet created via DDL
ForeignKey FKTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TestSe ];

Index IndexMaster On (TestSetDR, ImageClass) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (TestSetDR, Sequence, ImageClass) [ SqlName = Index_Sequence, Type = index, Unique ];

/// DDL Primary Key TestsetImageConfig
Index PKBTTESTSETIMAGECONFIG On RowID [ PrimaryKey, SqlName = PK_BT_TESTSETIMAGECONFIG, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医嘱  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 图片类别  
Property ImageClass As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

/// 缩图图宽度
Property ThumbnailWidth As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 缩图图高度
Property ThumbnailHeight As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 缩略图旋转度数
Property ThumbnailDeg As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTTestsetImageConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>ImageClass</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>ThumbnailWidth</Value>
</Value>
<Value name="7">
<Value>ThumbnailHeight</Value>
</Value>
<Value name="8">
<Value>ThumbnailDeg</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestsetImageConfigD</DataLocation>
<DefaultData>BTTestsetImageConfigDefaultData</DefaultData>
<IdLocation>^dbo.BTTestsetImageConfigD</IdLocation>
<IndexLocation>^dbo.BTTestsetImageConfigI</IndexLocation>
<StreamLocation>^dbo.BTTestsetImageConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
