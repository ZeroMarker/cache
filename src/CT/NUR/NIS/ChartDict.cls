/// Author: SongChao
/// Date: 2019-09-23 14:30:38
/// Description: 
/// LastEditors: SongChao
/// LastEditTime: 2019-12-25 16:46:57
/// Other:  
/// 体温单配置所需字典字段
Class CT.NUR.NIS.ChartDict Extends (%Persistent, User.Abstract) [ SqlTableName = ChartDict, StorageStrategy = CacheStorage ]
{

/// 类别
Property Category As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Category ];

/// 描述
Property Description As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Description ];

/// C#对应值
Property CValue As %String [ SqlColumnNumber = 4, SqlFieldName = CValue ];

/// 表达式
Property Expression As %String(MAXLEN = 200) [ SqlColumnNumber = 5, SqlFieldName = Expression ];

/// 表达式循环次数
Property LoopTimes As %Integer [ SqlColumnNumber = 6, SqlFieldName = LoopTimes ];

/// 是否停用 
Property IsStop As %String(DISPLAYLIST = ",停用,启用", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = IsStop ];

/// 表达式循环次数
Property HospDr As User.CTHospital [ SqlColumnNumber = 8, SqlFieldName = HospDr ];

Index Category On Category;

Storage CacheStorage
{
<Data name="ChartDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Category</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Expression</Value>
</Value>
<Value name="5">
<Value>CValue</Value>
</Value>
<Value name="6">
<Value>LoopTimes</Value>
</Value>
<Value name="7">
<Value>IsStop</Value>
</Value>
<Value name="8">
<Value>HospDr</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.NIS.ChartDictD</DataLocation>
<DefaultData>ChartDictDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.ChartDictD</IdLocation>
<IndexLocation>^CT.NUR.NIS.ChartDictI</IndexLocation>
<SqlIdExpression>$i(^CT.NUR.NIS.ChartDictD)</SqlIdExpression>
<SqlRowIdName>ID</SqlRowIdName>
<SqlRowIdProperty>ID</SqlRowIdProperty>
<StreamLocation>^CT.NUR.NIS.ChartDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
