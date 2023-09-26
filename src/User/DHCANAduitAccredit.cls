/// 科主任授权
Class User.DHCANAduitAccredit Extends %Persistent [ Final, Owner = {_PUBLIC}, SqlRowIdName = ANAA_RowId, SqlTableName = DHC_AN_AduitAccredit ]
{

/// 授权科室Id
Property ANAACtlocId As CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = ANAA_CtlocId ];

/// 医护人员Id
Property ANAACtpcpId As CTCareProv [ Required, SqlColumnNumber = 3, SqlFieldName = ANAA_CtpcpId ];

/// 开始授权日期
Property ANAAStartDate As %Date [ SqlColumnNumber = 4, SqlFieldName = ANAA_StartDate ];

/// 开始授权时间
Property ANAAStartTime As %Time [ SqlColumnNumber = 5, SqlFieldName = ANAA_StartTime ];

/// 结束授权日期
Property ANAAEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = ANAA_EndDate ];

/// 结束授权时间
Property ANAAEndTime As %Time [ SqlColumnNumber = 7, SqlFieldName = ANAA_EndTime ];

/// 创建用户ID
Property ANAACreateUserId As SSUser [ Required, SqlColumnNumber = 8, SqlFieldName = ANAA_CreateUserId ];

/// 创建日期
Property ANAACreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = ANAA_CreateDate ];

/// 创建时间
Property ANAACreateTime As %Time [ InitialExpression = {$piece($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = ANAA_CreateTime ];

Index ANAACtlocIdIndex On ANAACtlocId;

Index ANAACtpcpIdIndex On ANAACtpcpId;

Storage Default
{
<Data name="DHCANAduitAccreditDefaultData">
<Value name="1">
<Value>ANAACtlocId</Value>
</Value>
<Value name="2">
<Value>ANAACtpcpId</Value>
</Value>
<Value name="3">
<Value>ANAAStartDate</Value>
</Value>
<Value name="4">
<Value>ANAAStartTime</Value>
</Value>
<Value name="5">
<Value>ANAAEndDate</Value>
</Value>
<Value name="6">
<Value>ANAAEndTime</Value>
</Value>
<Value name="7">
<Value>ANAACreateUserId</Value>
</Value>
<Value name="8">
<Value>ANAACreateDate</Value>
</Value>
<Value name="9">
<Value>ANAACreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCANAduitAccredit</DataLocation>
<DefaultData>DHCANAduitAccreditDefaultData</DefaultData>
<IdLocation>^DHCANAduitAccredit</IdLocation>
<IndexLocation>^DHCANAduitAccredit(0)</IndexLocation>
<StreamLocation>^DHCANAduitAccreditS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
