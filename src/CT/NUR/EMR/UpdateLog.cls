/// 名称:     护理病历更新日志表
/// 描述:     用于记录每次升级的日志（仅用于后置任务）
/// 编写者：  yaojining
/// 编写日期: 2022.11.08
/// 产品组：  护理
Class CT.NUR.EMR.UpdateLog Extends (%Persistent, User.Abstract) [ SqlTableName = UpdateLog ]
{

/// 编辑器版本号
Property ULVersion As %String [ SqlColumnNumber = 2, SqlFieldName = UL_Version ];

/// 编辑器补丁包
Property ULPatch As %String [ SqlColumnNumber = 3, SqlFieldName = UL_Patch ];

/// 重建多院区索引是否完成
Property ULInitMultHospTable As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, MINLEN = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 4, SqlFieldName = UL_InitMultHospTable ];

/// 数据迁移是否完成
Property ULMoveTable As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, MINLEN = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 5, SqlFieldName = UL_MoveTable ];

/// 数据导入是否完成
Property ULImportData As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, MINLEN = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = UL_ImportData ];

/// Bug修复是否完成
Property ULHandleBug As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, MINLEN = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 7, SqlFieldName = UL_HandleBug ];

/// 功能更新是否完成
Property ULUpgrade As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, MINLEN = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 8, SqlFieldName = UL_Upgrade ];

/// 更新日期
Property ULUpdateDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 9, SqlFieldName = UL_UpdateDate ];

/// 更新时间
Property ULUpdateTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 10, SqlFieldName = UL_UpdateTime ];

Index VersionPatch On (ULVersion, ULPatch);

Storage Default
{
<Data name="UpdateLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ULVersion</Value>
</Value>
<Value name="3">
<Value>ULPatch</Value>
</Value>
<Value name="4">
<Value>ULInitMultHospTable</Value>
</Value>
<Value name="5">
<Value>ULMoveTable</Value>
</Value>
<Value name="6">
<Value>ULImportData</Value>
</Value>
<Value name="7">
<Value>ULHandleBug</Value>
</Value>
<Value name="8">
<Value>ULUpgrade</Value>
</Value>
<Value name="9">
<Value>ULUpdateDate</Value>
</Value>
<Value name="10">
<Value>ULUpdateTime</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.EMR.UpdateLogD</DataLocation>
<DefaultData>UpdateLogDefaultData</DefaultData>
<IdLocation>^CT.NUR.EMR.UpdateLogD</IdLocation>
<IndexLocation>^CT.NUR.EMR.UpdateLogI</IndexLocation>
<StreamLocation>^CT.NUR.EMR.UpdateLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
