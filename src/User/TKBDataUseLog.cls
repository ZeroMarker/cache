/// 描述: 基础数据平台   医用知识库业务使用记录
/// 编写者：谷雪萍
/// 编写日期: 2017-09-04
Class User.TKBDataUseLog Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = TKB_DataUseLog ]
{

//    ^User.TKBDataUseLogD   ^User.TKBDataUseLogI

/// 诊断ID  节点 2
Property TKBDULTremDr As User.TKBTrem [ Required ];

/// 属性RowId 节点 3
Property TKBDULExtendDr As User.TKBTremExtend;

/// 属性内容RowId 节点 4
Property TKBDULDetailDr As %String;

/// 使用科室 节点 5
Property TKBDULLocDr As User.CTLoc [ Required ];

/// 使用用户 节点 6
Property TKBDULUserDr As User.SSUser [ Required ];

///  诊断ID 索引
Index TremIndex On TKBDULTremDr;

/// 科室+诊断 的索引
Index LocTremIdx On (TKBDULLocDr, TKBDULTremDr);

/// 用户+诊断 的索引
Index UserTremIdx On (TKBDULUserDr, TKBDULTremDr);

/// 诊断+属性 的索引
Index TtemExtIdx On (TKBDULTremDr, TKBDULExtendDr);

/// 诊断+属性+属性内容 的索引
Index TtemExtDetailIdx On (TKBDULTremDr, TKBDULExtendDr, TKBDULDetailDr);

Storage Default
{
<Data name="TKBDataUseLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TKBDULTremDr</Value>
</Value>
<Value name="3">
<Value>TKBDULExtendDr</Value>
</Value>
<Value name="4">
<Value>TKBDULDetailDr</Value>
</Value>
<Value name="5">
<Value>TKBDULLocDr</Value>
</Value>
<Value name="6">
<Value>TKBDULUserDr</Value>
</Value>
</Data>
<DataLocation>^User.TKBDataUseLogD</DataLocation>
<DefaultData>TKBDataUseLogDefaultData</DefaultData>
<IdLocation>^User.TKBDataUseLogD</IdLocation>
<IndexLocation>^User.TKBDataUseLogI</IndexLocation>
<StreamLocation>^User.TKBDataUseLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
