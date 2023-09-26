Class dbo.BTTATTimeTSGroupRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TATTimeTSGroupRule ]
{

Index IndexSequence On (TATTimeTSGroupDR, AdmType, DateType, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKBTTATTimeTSGroupTimeTSGroupDR created via DDL
ForeignKey FKBTTATTimeTSGroupRuleTSGroup(TATTimeTSGroupDR) References dbo.BTTATTimeTSGroup(PKBTTATTIMETSGROUP) [ SqlName = FK_BTTATTimeTSGroupRuleTSGroup ];

/// DDL Primary Key BTTATTimeTSGroupRule
Index PKBTTATTIMETSGROUPRULE On RowID [ PrimaryKey, SqlName = PK_BT_TATTIMETSGROUPRULE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// TAT完成时医嘱分组  
Property TATTimeTSGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 完成时医嘱就诊分类 {O:门诊,E:急诊}
Property AdmType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 4 ];

/// 日期类型 {0：全周，1-7：周一至周日，8：工作日，9：周末，10：节假日}
Property DateType As %Library.TinyInt [ Required, SqlColumnNumber = 5 ];

/// 采样开始时间  
Property StartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 采样结束时间  
Property EndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 取报告间隔天数  
Property Days As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 取报告时间点  
Property TimePoint As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 取报告时间间隔(单位：分钟)
Property TimeLen As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 取报告说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 11 ];

/// 序号(优先级,值越小优先级越高)
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BTTATTimeTSGroupRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TATTimeTSGroupDR</Value>
</Value>
<Value name="3">
<Value>AdmType</Value>
</Value>
<Value name="4">
<Value>DateType</Value>
</Value>
<Value name="5">
<Value>StartTime</Value>
</Value>
<Value name="6">
<Value>EndTime</Value>
</Value>
<Value name="7">
<Value>Days</Value>
</Value>
<Value name="8">
<Value>TimePoint</Value>
</Value>
<Value name="9">
<Value>TimeLen</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
<Value name="11">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTATTimeTSGroupRuleD</DataLocation>
<DefaultData>BTTATTimeTSGroupRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTTATTimeTSGroupRuleD</IdLocation>
<IndexLocation>^dbo.BTTATTimeTSGroupRuleI</IndexLocation>
<StreamLocation>^dbo.BTTATTimeTSGroupRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
