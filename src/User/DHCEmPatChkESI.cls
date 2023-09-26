/// ESI急诊严重指数
Class User.DHCEmPatChkESI Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_EMPatChkESI ]
{

/// 预检表 PCS_Chk_Dr
Property PCSChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PCS_Chk_Dr ];

/// 濒危
Property PCSESIEnDanger As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PCS_ESI_EnDanger ];

/// 能等待
Property PCSESIWait As %Library.String [ SqlColumnNumber = 4, SqlFieldName = PCS_ESI_Wait ];

/// 急症病人
Property PCSESIEmergencyCase As %Library.String [ SqlColumnNumber = 5, SqlFieldName = PCS_ESI_EmergencyCase ];

/// 生命体征异常
Property PCSESIException As %Library.String [ SqlColumnNumber = 6, SqlFieldName = PCS_ESI_Exception ];

/// 需要多少医疗资源
Property PCSESIResource As %Library.String [ SqlColumnNumber = 7, SqlFieldName = PCS_ESI_Resource ];

/// 评级
Property PCSESILevel As %Library.String [ SqlColumnNumber = 8, SqlFieldName = PCS_ESI_Level ];

/// 激活标志
Property PCSESIActive As %Library.String [ SqlColumnNumber = 9, SqlFieldName = PCS_ESI_Active ];

Storage Default
{
<Data name="DHCEmPatChkESIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PCSChkDr</Value>
</Value>
<Value name="3">
<Value>PCSESIEnDanger</Value>
</Value>
<Value name="4">
<Value>PCSESIWait</Value>
</Value>
<Value name="5">
<Value>PCSESIEmergencyCase</Value>
</Value>
<Value name="6">
<Value>PCSESIException</Value>
</Value>
<Value name="7">
<Value>PCSESIResource</Value>
</Value>
<Value name="8">
<Value>PCSESILevel</Value>
</Value>
<Value name="9">
<Value>PCSESIActive</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmPatChkESID</DataLocation>
<DefaultData>DHCEmPatChkESIDefaultData</DefaultData>
<IdLocation>^User.DHCEmPatChkESID</IdLocation>
<IndexLocation>^User.DHCEmPatChkESII</IndexLocation>
<StreamLocation>^User.DHCEmPatChkESIS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index IndexChk On PCSChkDr;

}
