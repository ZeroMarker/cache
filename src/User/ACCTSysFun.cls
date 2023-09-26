Class User.ACCTSysFun Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_SysFun ]
{

Property ModCode As %String(MAXLEN = 20) [ Required, SqlFieldName = mod_code ];

Property ModName As %String(MAXLEN = 50) [ Required, SqlFieldName = mod_name ];

Property IsLast As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ InitialExpression = 0, Required, SqlFieldName = is_last ];

Property IsVouch As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ InitialExpression = 0, Required, SqlFieldName = is_vouch ];

Property IsStock As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ InitialExpression = 0, Required, SqlFieldName = is_stock ];

Property IsPay As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ InitialExpression = 0, Required, SqlFieldName = is_pay ];

Property IsBack As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ InitialExpression = 0, Required, SqlFieldName = is_back ];

Property IsDiffPrice As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ InitialExpression = 0, Required, SqlFieldName = is_diff_price ];

Property MasterTable As %String(MAXLEN = 40) [ SqlFieldName = master_table ];

Property KeyField As %String(MAXLEN = 40) [ SqlFieldName = key_field ];

Property BusinessNo As %String(MAXLEN = 40) [ SqlFieldName = business_no ];

Property DateField As %String(MAXLEN = 40) [ SqlFieldName = date_field ];

Property StateField As %String(MAXLEN = 40) [ SqlFieldName = state_field ];

Property StoreField As %String(MAXLEN = 40) [ SqlFieldName = store_field ];

Property VenderField As %String(MAXLEN = 40) [ SqlFieldName = vender_field ];

Property DeptField As %String(MAXLEN = 40) [ SqlFieldName = dept_field ];

Property EmpField As %String(MAXLEN = 40) [ SqlFieldName = emp_field ];

Property ProjField As %String(MAXLEN = 40) [ SqlFieldName = proj_field ];

Property OperatorField As %String(MAXLEN = 40) [ SqlFieldName = operator_field ];

Property CheckerField As %String(MAXLEN = 40) [ SqlFieldName = checker_field ];

Property PayTypeField As %String(MAXLEN = 40) [ SqlFieldName = pay_type_field ];

Property AccField As %String(MAXLEN = 40) [ SqlFieldName = acc_field ];

Property CheckTypeField As %String(MAXLEN = 40) [ SqlFieldName = check_type_field ];

Property CheckNoField As %String(MAXLEN = 40) [ SqlFieldName = check_no_field ];

Property DetailTable As %String(MAXLEN = 40) [ SqlFieldName = detail_table ];

Property AssetField As %String(MAXLEN = 40) [ SqlFieldName = asset_field ];

Property ConfirmValue As %Integer [ SqlFieldName = confirm_value ];

Property AccValue As %Integer [ SqlFieldName = acc_value ];

Property WhileSql As %String(MAXLEN = 200) [ SqlFieldName = while_sql ];

Property AssetTable As %String(MAXLEN = 40) [ SqlFieldName = asset_table ];

Property IsType As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ InitialExpression = 0, Required, SqlFieldName = is_type ];

Property IsAcc As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ InitialExpression = 0, Required, SqlFieldName = is_acc ];

Property IsAccTd As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ InitialExpression = 0, Required, SqlFieldName = is_acc_td ];

Index PKAcctSysFun On ModCode [ Unique ];

Storage Default
{
<Data name="ACCTSysFunDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AccField</Value>
</Value>
<Value name="3">
<Value>AccValue</Value>
</Value>
<Value name="4">
<Value>AssetField</Value>
</Value>
<Value name="5">
<Value>AssetTable</Value>
</Value>
<Value name="6">
<Value>BusinessNo</Value>
</Value>
<Value name="7">
<Value>CheckNoField</Value>
</Value>
<Value name="8">
<Value>CheckTypeField</Value>
</Value>
<Value name="9">
<Value>CheckerField</Value>
</Value>
<Value name="10">
<Value>ConfirmValue</Value>
</Value>
<Value name="11">
<Value>DateField</Value>
</Value>
<Value name="12">
<Value>DeptField</Value>
</Value>
<Value name="13">
<Value>DetailTable</Value>
</Value>
<Value name="14">
<Value>EmpField</Value>
</Value>
<Value name="15">
<Value>IsAcc</Value>
</Value>
<Value name="16">
<Value>IsAccTd</Value>
</Value>
<Value name="17">
<Value>IsBack</Value>
</Value>
<Value name="18">
<Value>IsDiffPrice</Value>
</Value>
<Value name="19">
<Value>IsLast</Value>
</Value>
<Value name="20">
<Value>IsPay</Value>
</Value>
<Value name="21">
<Value>IsStock</Value>
</Value>
<Value name="22">
<Value>IsType</Value>
</Value>
<Value name="23">
<Value>IsVouch</Value>
</Value>
<Value name="24">
<Value>KeyField</Value>
</Value>
<Value name="25">
<Value>MasterTable</Value>
</Value>
<Value name="26">
<Value>ModCode</Value>
</Value>
<Value name="27">
<Value>ModName</Value>
</Value>
<Value name="28">
<Value>OperatorField</Value>
</Value>
<Value name="29">
<Value>PayTypeField</Value>
</Value>
<Value name="30">
<Value>ProjField</Value>
</Value>
<Value name="31">
<Value>StateField</Value>
</Value>
<Value name="32">
<Value>StoreField</Value>
</Value>
<Value name="33">
<Value>VenderField</Value>
</Value>
<Value name="34">
<Value>WhileSql</Value>
</Value>
</Data>
<DataLocation>^User.ACCTSysFunD</DataLocation>
<DefaultData>ACCTSysFunDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTSysFunD</IdLocation>
<IndexLocation>^User.ACCTSysFunI</IndexLocation>
<StreamLocation>^User.ACCTSysFunS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
