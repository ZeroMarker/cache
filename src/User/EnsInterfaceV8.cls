/// 类名：User.EnsInterfaceV8
/// 描述：存储其他组调用相关方法的信息
/// 编写者：WuXianPu
/// 编写日期：2012-02-29 ##class(User.EnsInterfaceV8).%BuildIndices()
Class User.EnsInterfaceV8 Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, SqlTableName = Ens_InterfaceV8 ]
{

/// 方法代码
Property methodCode As %String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 2, SqlFieldName = method_Code ];

/// 入参
Property transferInput As %GlobalCharacterStream [ SqlColumnNumber = 3, SqlFieldName = transfer_Input ];

/// 入参说明
Property transferInputDesc As %String(MAXLEN = 200) [ SqlColumnNumber = 4, SqlFieldName = transfer_InputDesc ];

/// 调用此方法所在类或M名称
Property transferInClass As %String [ SqlColumnNumber = 5, SqlFieldName = transfer_InClass ];

/// 调用此方法所在方法
Property transferInMethod As %String [ SqlColumnNumber = 6, SqlFieldName = transfer_InMethod ];

/// 调用IP地址
Property transferInIp As %String [ SqlColumnNumber = 7, SqlFieldName = transfer_InIp ];

/// 返回值
Property transferOuput As %GlobalCharacterStream [ SqlColumnNumber = 8, SqlFieldName = transfer_Ouput ];

/// 返回值说明
Property transferOuputDesc As %String [ SqlColumnNumber = 9, SqlFieldName = transfer_OuputDesc ];

/// 状态
Property transferStatus As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 10, SqlFieldName = transfer_Status ];

/// 插入日期
Property transferInsDate As %Date [ SqlColumnNumber = 11, SqlFieldName = transfer_InsDate ];

/// 插入时间
Property transferInsTime As %Time [ SqlColumnNumber = 12, SqlFieldName = transfer_InsTime ];

/// 方法描述
Property methodDesc As %String(MAXLEN = 200) [ SqlColumnNumber = 13, SqlFieldName = method_Desc ];

/// 按插入日期时间检索
Index IndexDateTime On (transferInsDate As AlphaUp, transferInsTime As AlphaUp);

/// 按处理结果检索
Index IndexTransferStatus On transferStatus;

/// 按方法代码检索
Index IndexMethodCode On methodCode;

Storage Default
{
<Data name="EnsInterfaceV8DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>methodCode</Value>
</Value>
<Value name="3">
<Value>transferInput</Value>
</Value>
<Value name="4">
<Value>transferInputDesc</Value>
</Value>
<Value name="5">
<Value>transferInClass</Value>
</Value>
<Value name="6">
<Value>transferInMethod</Value>
</Value>
<Value name="7">
<Value>transferInIp</Value>
</Value>
<Value name="8">
<Value>transferOuput</Value>
</Value>
<Value name="9">
<Value>transferOuputDesc</Value>
</Value>
<Value name="10">
<Value>transferStatus</Value>
</Value>
<Value name="11">
<Value>transferInsDate</Value>
</Value>
<Value name="12">
<Value>transferInsTime</Value>
</Value>
<Value name="13">
<Value>methodDesc</Value>
</Value>
</Data>
<DataLocation>^User.EnsInterfaceV8D</DataLocation>
<DefaultData>EnsInterfaceV8DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.EnsInterfaceV8D</IdLocation>
<IndexLocation>^User.EnsInterfaceV8I</IndexLocation>
<StreamLocation>^User.EnsInterfaceV8S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
