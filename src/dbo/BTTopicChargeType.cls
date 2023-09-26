Class dbo.BTTopicChargeType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TopicChargeType ]
{

/// Foreign Key FKBTTopicChargeTypeTopicDR created via DDL
ForeignKey FKBTTopicChargeTypeTopicDR(TopicDR) References dbo.BTTopic(PKBTTOPIC) [ SqlName = FK_BTTopicChargeTypeTopicDR ];

/// Foreign Key FKBTTopicChargeTypeChargeTypeDR created via DDL
ForeignKey FKBTTopicChargeTypeChargeTypeDR(ChargeTypeDR) References dbo.BTChargeType(PKBTCHARGETYPE) [ SqlName = FK_BTTopicChargeTypeChargeTypeDR ];

Index IndexMaster On (TopicDR, ChargeTypeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTOPICCHARGETYPE On RowID [ PrimaryKey, SqlName = PK_BT_TOPICCHARGETYPE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 研究课题  
Property TopicDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 计费类型  
Property ChargeTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTTopicChargeTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TopicDR</Value>
</Value>
<Value name="3">
<Value>ChargeTypeDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTopicChargeTypeD</DataLocation>
<DefaultData>BTTopicChargeTypeDefaultData</DefaultData>
<IdLocation>^dbo.BTTopicChargeTypeD</IdLocation>
<IndexLocation>^dbo.BTTopicChargeTypeI</IndexLocation>
<StreamLocation>^dbo.BTTopicChargeTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
