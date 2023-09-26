Class dbo.BTTATTimeTSGroupTime Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TATTimeTSGroupTime ]
{

Index IndexTestSetType On (TATTimeTSGroupDR, TestSetType, Sequence) [ SqlName = Index_TestSetType, Type = index, Unique ];

Index IndexSequence On (TATTimeTSGroupDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKBTTATTimeTSGroupTimeTSGroupDR created via DDL
ForeignKey FKBTTATTimeTSGroupTimeTSGroup(TATTimeTSGroupDR) References dbo.BTTATTimeTSGroup(PKBTTATTIMETSGROUP) [ SqlName = FK_BTTATTimeTSGroupTimeTSGroupDR ];

/// Foreign Key FKBTTATTimeTSGroupTimeWGM created via DDL
ForeignKey FKBTTATTimeTSGroupTimeWG(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTTATTimeTSGroupTimeWG ];

/// DDL Primary Key BTTATTimeTSGroupTime
Index PKBTTATTIMETSGROUPTIME On RowID [ PrimaryKey, SqlName = PK_BT_TATTIMETSGROUPTIME, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// TAT完成时医嘱分组  
Property TATTimeTSGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 完成时医嘱就诊分类 {I:住院,O:门诊,H:体检,E:急诊,N:新生儿,R:科研,P:药理,G:其他,U加急医嘱}
Property TestSetType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 4 ];

/// 工作小组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 完成时间  
Property FinishTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 开始时间  
Property StartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 结束时间  
Property EndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 序号(优先级)
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTTATTimeTSGroupTimeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TATTimeTSGroupDR</Value>
</Value>
<Value name="3">
<Value>TestSetType</Value>
</Value>
<Value name="4">
<Value>WorkGroupDR</Value>
</Value>
<Value name="5">
<Value>FinishTime</Value>
</Value>
<Value name="6">
<Value>StartTime</Value>
</Value>
<Value name="7">
<Value>EndTime</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTATTimeTSGroupTimeD</DataLocation>
<DefaultData>BTTATTimeTSGroupTimeDefaultData</DefaultData>
<IdLocation>^dbo.BTTATTimeTSGroupTimeD</IdLocation>
<IndexLocation>^dbo.BTTATTimeTSGroupTimeI</IndexLocation>
<StreamLocation>^dbo.BTTATTimeTSGroupTimeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
