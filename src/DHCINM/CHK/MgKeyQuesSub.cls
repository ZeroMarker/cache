/// Creater:lulin
/// Descriptions:重点问题子表
/// Date:2021-12-26
Class DHCINM.CHK.MgKeyQuesSub Extends %Persistent
{

Relationship Parref As DHCINM.CHK.MgKeyQues [ Cardinality = parent, Inverse = ChildSub ];

/// 父组件的开始日期
Property StDate As %Date [ SqlColumnNumber = 2, SqlFieldName = StDate ];

/// 父组件的结束日期
Property EndDate As %Date [ SqlColumnNumber = 3, SqlFieldName = EndDate ];

/// 描述
Property QuesDesc As %String(MAXLEN = 500) [ SqlColumnNumber = 4, SqlFieldName = QuesDesc ];

/// 问题描述id
Property indexlibSubID As %String [ SqlColumnNumber = 5, SqlFieldName = indexlibSubID ];

/// 病区
Property WardDR As %String [ SqlColumnNumber = 6, SqlFieldName = WardDR ];

/// 类型
Property QuesType As %String [ SqlColumnNumber = 7, SqlFieldName = QuesType ];

/// 复查结果
Property Remark As %String [ SqlColumnNumber = 8, SqlFieldName = Remark ];

/// 状态
Property Status As %String [ SqlColumnNumber = 9, SqlFieldName = Status ];

/// 结果外键
Property ResultDR As %String [ SqlColumnNumber = 10, SqlFieldName = ResultDR ];

/// 结果子表外键
Property ResultSubDR As %String [ SqlColumnNumber = 11, SqlFieldName = ResultSubDR ];

/// 所属二级指标CT.DHCINM.DB.MgQualItem
Property QualDR As %String [ SqlColumnNumber = 12, SqlFieldName = QualDR ];

/// DHCINM.CHK.MgKeyQuesItem
Property QuseItem As DHCINM.CHK.MgKeyQuesItem [ SqlColumnNumber = 13, SqlFieldName = QuseItem ];

/// 修改人
Property Updator As %String [ SqlColumnNumber = 14, SqlFieldName = Updator ];

/// 日期
Property UpdatDate As %Date [ SqlColumnNumber = 15, SqlFieldName = UpdatDate ];

// 供检查查询使用【在那时无用】

Index qualDate On (QualDR, WardDR, StDate, EndDate);

Index item On QuseItem;

Index result On (Parref, ResultSubDR, indexlibSubID);

Storage Default
{
<Data name="MgKeyQuesSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StDate</Value>
</Value>
<Value name="3">
<Value>EndDate</Value>
</Value>
<Value name="4">
<Value>QuesDesc</Value>
</Value>
<Value name="5">
<Value>indexlibSubID</Value>
</Value>
<Value name="6">
<Value>WardDR</Value>
</Value>
<Value name="7">
<Value>QuesType</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
<Value name="10">
<Value>ResultDR</Value>
</Value>
<Value name="11">
<Value>ResultSubDR</Value>
</Value>
<Value name="12">
<Value>QualDR</Value>
</Value>
<Value name="13">
<Value>QuseItem</Value>
</Value>
<Value name="14">
<Value>Updator</Value>
</Value>
<Value name="15">
<Value>UpdatDate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.CHK.MgKeyQuesSubD</DataLocation>
<DefaultData>MgKeyQuesSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.CHK.MgKeyQuesSubI</IndexLocation>
<StreamLocation>^DHCINM.CHK.MgKeyQuesSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
