/// 急诊担保金额
Class User.DHCEmGuaLevel Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_EmGuaLevel ]
{

Index GLEMinIndex On (GLEMin, GLEHospDr) [ Unique ];

/// 起始金额
Property GLEMin As %Numeric [ SqlFieldName = GLE_Min ];

/// 结束金额
Property GLEMax As %Numeric [ SqlFieldName = GLE_Max ];

/// 是否启用
Property GLEActiveFlag As %String [ SqlFieldName = GLE_ActiveFlag ];

/// 集团化医院
Property GLEHospDr As CTHospital [ SqlFieldName = GLE_Hosp_Dr ];

/// 职称
Property GLECarPrTpDr As CTCarPrvTp [ SqlFieldName = GLE_CarPrTp_Dr ];

Storage Default
{
<Data name="DHCEmGuaLevelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GLEMin</Value>
</Value>
<Value name="3">
<Value>GLEMax</Value>
</Value>
<Value name="4">
<Value>GLEActiveFlag</Value>
</Value>
<Value name="5">
<Value>GLEHospDr</Value>
</Value>
<Value name="6">
<Value>GLECarPrTpDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmGuaLevelD</DataLocation>
<DefaultData>DHCEmGuaLevelDefaultData</DefaultData>
<IdLocation>^User.DHCEmGuaLevelD</IdLocation>
<IndexLocation>^User.DHCEmGuaLevelI</IndexLocation>
<StreamLocation>^User.DHCEmGuaLevelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
