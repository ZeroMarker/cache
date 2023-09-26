/// Creator:谷雪萍
/// CreatDate:2018-03-26
/// Description：业务使用记录表
/// Table：User.MKBDataUseLog
Class User.MKBDataUseLog Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_DataUseLog ]
{

/// 诊断ID  节点 2
Property MKBDULTermDr As User.MKBTerm [ Required ];

/// 属性RowId 节点 3
Property MKBDULExtendDr As User.MKBTermProperty;

/// 属性内容RowId 节点 4
Property MKBDULDetailDr As %String(MAXLEN = "");

/// 使用科室 节点 5
Property MKBDULLocDr As User.CTLoc [ Required ];

/// 使用用户 节点 6
Property MKBDULUserDr As User.SSUser [ Required ];

///  诊断ID 索引
Index TermIndex On MKBDULTermDr;

/// 科室+诊断 的索引
Index LocTermIdx On (MKBDULLocDr, MKBDULTermDr);

/// 用户+诊断 的索引
Index UserTermIdx On (MKBDULUserDr, MKBDULTermDr);

/// 诊断+属性 的索引
Index TtemExtIdx On (MKBDULTermDr, MKBDULExtendDr);

/// 诊断+属性+属性内容 的索引
Index TtemExtDetailIdx On (MKBDULTermDr, MKBDULExtendDr, MKBDULDetailDr);

Storage Default
{
<Data name="MKBDataUseLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBDULTermDr</Value>
</Value>
<Value name="3">
<Value>MKBDULExtendDr</Value>
</Value>
<Value name="4">
<Value>MKBDULDetailDr</Value>
</Value>
<Value name="5">
<Value>MKBDULLocDr</Value>
</Value>
<Value name="6">
<Value>MKBDULUserDr</Value>
</Value>
</Data>
<DataLocation>^User.MKBDataUseLogD</DataLocation>
<DefaultData>MKBDataUseLogDefaultData</DefaultData>
<IdLocation>^User.MKBDataUseLogD</IdLocation>
<IndexLocation>^User.MKBDataUseLogI</IndexLocation>
<StreamLocation>^User.MKBDataUseLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
