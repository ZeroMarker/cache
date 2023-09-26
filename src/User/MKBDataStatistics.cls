/// 知识量统计
Class User.MKBDataStatistics Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBDS_RowId, SqlTableName = MKB_DataStatistics ]
{

/// 标识父菜单
Property MKBDSFlag As %String(DISPLAYLIST = ",知识管理,规则管理", MAXLEN = 5, SELECTIVITY = "33.3333%", VALUELIST = ",KNO,MAP") [ SqlColumnNumber = 2, SqlFieldName = MKBDS_Flag ];

/// 数据ID 
Property MKBDSID As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBDS_ID ];

/// 数据数量
Property MKBDSNum As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBDS_Num ];

/// 存储日期
Property MKBDSDay As %Date [ SqlColumnNumber = 5, SqlFieldName = MKBDS_Day ];

/// 周
Property MKBDSWeek As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = MKBDS_Week ];

/// 月
Property MKBDSMonth As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = MKBDS_Month ];

/// 周数据索引
Index WeekIndex On (MKBDSFlag As Exact, MKBDSID As Exact, MKBDSWeek As Exact, MKBDSNum As Exact);

/// 月数据索引
Index MonthIndex On (MKBDSFlag As Exact, MKBDSID As Exact, MKBDSMonth As Exact, MKBDSNum As Exact);

Storage Default
{
<Data name="MKBDataStatisticsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBDSFlag</Value>
</Value>
<Value name="3">
<Value>MKBDSID</Value>
</Value>
<Value name="4">
<Value>MKBDSNum</Value>
</Value>
<Value name="5">
<Value>MKBDSDay</Value>
</Value>
<Value name="6">
<Value>MKBDSWeek</Value>
</Value>
<Value name="7">
<Value>MKBDSMonth</Value>
</Value>
</Data>
<DataLocation>^User.MKBDataStatisticsD</DataLocation>
<DefaultData>MKBDataStatisticsDefaultData</DefaultData>
<IdLocation>^User.MKBDataStatisticsD</IdLocation>
<IndexLocation>^User.MKBDataStatisticsI</IndexLocation>
<StreamLocation>^User.MKBDataStatisticsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
