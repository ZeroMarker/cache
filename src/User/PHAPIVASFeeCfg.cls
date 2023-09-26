/// 配液收费全局设置
Class User.PHAPIVASFeeCfg Extends %Persistent [ SqlTableName = PHAPIVAS_FeeCfg ]
{

Index Arcim On PFCArcimDR As exact;

/// 医嘱项
Property PFCArcimDR As %Library.String [ Required, SqlColumnNumber = 2, SqlFieldName = PFC_Arcim_DR ];

/// 收取次数
Property PFCTimes As %Library.Integer [ SqlColumnNumber = 3, SqlFieldName = PFC_Times ];

/// 收取上限金额
Property PFCMaxAmt As %Library.Double [ SqlColumnNumber = 4, SqlFieldName = PFC_MaxAmt ];

Storage Default
{
<Data name="PHAPIVASFeeCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PFCArcimDR</Value>
</Value>
<Value name="3">
<Value>PFCTimes</Value>
</Value>
<Value name="4">
<Value>PFCMaxAmt</Value>
</Value>
</Data>
<DataLocation>^CF.PHA.PIVAS.FeeCfg</DataLocation>
<DefaultData>PHAPIVASFeeCfgDefaultData</DefaultData>
<IdLocation>^CF.PHA.PIVAS.FeeCfg</IdLocation>
<IndexLocation>^CF.PHA.PIVAS.FeeCfgi</IndexLocation>
<SqlRowIdName>PFC_RowID</SqlRowIdName>
<StreamLocation>^CF.PHA.PIVAS.FeeCfgs</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
