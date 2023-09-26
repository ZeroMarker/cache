/// 预检分级评分项表
Class User.DHCEmPatChkScoreItm Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_EmPatChkScoreItm ]
{

/// 预检表 PCS_Chk_Dr
Property PCSChkDr As User.DHCEmPatCheckLev [ SqlFieldName = PCS_Chk_Dr ];

/// 分级
Property PCSLevel As %Library.Integer [ SqlFieldName = PCS_Level ];

/// 得分
Property PCSScore As %Library.Integer [ SqlFieldName = PCS_Score ];

/// 评分项
Property PCSItm As %Library.String(MAXLEN = 500) [ SqlFieldName = PCS_Itm ];

/// 评分项代码
Property PCSItmCode As %Library.String [ SqlFieldName = PCS_Itm_Code ];

Storage Default
{
<Data name="DHCEmPatChkScoreItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PCSChkDr</Value>
</Value>
<Value name="3">
<Value>PCSLevel</Value>
</Value>
<Value name="4">
<Value>PCSScore</Value>
</Value>
<Value name="5">
<Value>PCSItm</Value>
</Value>
<Value name="6">
<Value>PCSItmCode</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmPatChkScoreItmD</DataLocation>
<DefaultData>DHCEmPatChkScoreItmDefaultData</DefaultData>
<IdLocation>^User.DHCEmPatChkScoreItmD</IdLocation>
<IndexLocation>^User.DHCEmPatChkScoreItmI</IndexLocation>
<StreamLocation>^User.DHCEmPatChkScoreItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index IndexChkCode On (PCSChkDr, PCSItmCode);

Index IndexChk On PCSChkDr;

}
