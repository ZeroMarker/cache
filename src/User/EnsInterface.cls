Import SQLUser

Class User.EnsInterface Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Ens_Interface ]
{

/// 事件
Property IntEventName As %String(MAXLEN = 32767) [ SqlFieldName = Int_EventName ];

/// 事件描述
Property IntEventDesc As %String(MAXLEN = 32767) [ SqlFieldName = Int_EventDesc ];

/// 事件入参
Property IntInput As %String(MAXLEN = 32767) [ SqlFieldName = Int_Input ];

/// 入参描述
Property IntInputDesc As %String(MAXLEN = 32767) [ SqlFieldName = Int_InputDesc ];

/// 插入日期
Property IntInsDate As %Date [ SqlFieldName = Int_InsDate ];

/// 插入时间
Property IntInsTime As %Time [ SqlFieldName = Int_InsTime ];

/// 处理次数
Property IntCounts As %Integer [ SqlFieldName = Int_Counts ];

/// 处理标志 -1：失败 0：成功 -1：初始状态
Property IntFlag As %String(MAXLEN = 32767) [ InitialExpression = "-1", SqlFieldName = Int_Flag ];

/// 最后处理日期
Property IntLastDate As %Date [ SqlFieldName = Int_LastDate ];

/// 最后处理时间
Property IntLastTime As %Time [ SqlFieldName = Int_LastTime ];

/// 平台连接表主键
Property IntLinkDr As %String(MAXLEN = 32767) [ SqlFieldName = Int_LinkDr ];

/// 所属父事件
Property IntParentEvent As %String(MAXLEN = 32767) [ SqlFieldName = Int_ParentEvent ];

/// 事件处理方式1：直接成功 0：人为干预
Property IntApproach As %String(MAXLEN = 32767) [ SqlFieldName = Int_Approach ];

/// 生成此数据日期
Property IntTInsDate As %Date [ SqlFieldName = Int_TInsDate ];

/// 生成此数据时间
Property IntTInsTime As %Time [ SqlFieldName = Int_TInsTime ];

/// 入参中的主键，如对人操作的AdmID或者对医嘱操作的OrdId，方便按顺序进行操作
Property IntKeyString As %String(MAXLEN = 32767) [ SqlFieldName = Int_KeyString ];

/// 按事件名称和处理结果检索
Index IndexEventNameFlag On (IntEventName, IntFlag);

Index IndextEventNameKeyString On (IntEventName, IntKeyString, IntFlag);

/// 按平台连接表主键检索
Index IndexLinkDr On IntLinkDr As AlphaUp;

/// 错误信息
Property ErrorMessage As %String(MAXLEN = 32767) [ SqlFieldName = ErrorMessage ];

Storage Default
{
<Data name="EnsInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IntEventName</Value>
</Value>
<Value name="3">
<Value>IntEventDesc</Value>
</Value>
<Value name="4">
<Value>IntInput</Value>
</Value>
<Value name="5">
<Value>IntInputDesc</Value>
</Value>
<Value name="6">
<Value>IntInsDate</Value>
</Value>
<Value name="7">
<Value>IntInsTime</Value>
</Value>
<Value name="8">
<Value>IntCounts</Value>
</Value>
<Value name="9">
<Value>IntFlag</Value>
</Value>
<Value name="10">
<Value>IntLastDate</Value>
</Value>
<Value name="11">
<Value>IntLastTime</Value>
</Value>
<Value name="12">
<Value>IntLinkDr</Value>
</Value>
<Value name="13">
<Value>IntParentEvent</Value>
</Value>
<Value name="14">
<Value>IntApproach</Value>
</Value>
<Value name="15">
<Value>IntTInsDate</Value>
</Value>
<Value name="16">
<Value>IntTInsTime</Value>
</Value>
<Value name="17">
<Value>IntKeyString</Value>
</Value>
<Value name="18">
<Value>ErrorMessage</Value>
</Value>
</Data>
<DataLocation>^User.EnsInterfaceD</DataLocation>
<DefaultData>EnsInterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.EnsInterfaceD</IdLocation>
<IndexLocation>^User.EnsInterfaceI</IndexLocation>
<StreamLocation>^User.EnsInterfaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
