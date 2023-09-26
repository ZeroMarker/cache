Class User.DHCOPRegInsuComp Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = RIC_RowId, SqlTableName = DHC_OPRegInsuComp ]
{

Index RICAdmReasonDRIndex On RICAdmReasonDR;

Index RICInsuPatTypeCodeIndex On RICInsuPatTypeCode;

Index RICNowOrdItemIndex On RICNowOrdItem;

Index RICUploadOrdItemIndex On RICUploadOrdItem;

Property RICAdmReasonDR As User.PACAdmReason [ SqlFieldName = RIC_AdmReason_DR ];

Property RICInsuPatTypeCode As %String [ SqlFieldName = RIC_InsuPatTypeCode ];

Property RICNowOrdItem As User.ARCItmMast [ SqlFieldName = RIC_NowOrdItem ];

Property RICUploadOrdItem As User.ARCItmMast [ SqlFieldName = RIC_UploadOrdItem ];

Property RICStartDate As %Date [ SqlFieldName = RIC_StartDate ];

Property RICEndDate As %Date [ SqlFieldName = RIC_EndDate ];

Storage Default
{
<Data name="DHCOPRegInsuCompDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RICInsuPatTypeCode</Value>
</Value>
<Value name="3">
<Value>RICNowOrdItem</Value>
</Value>
<Value name="4">
<Value>RICSocialStatusDR</Value>
</Value>
<Value name="5">
<Value>RICUploadOrdItem</Value>
</Value>
<Value name="6">
<Value>RICEndDate</Value>
</Value>
<Value name="7">
<Value>RICStartDate</Value>
</Value>
<Value name="8">
<Value>RICAdmReasonDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCOPRegInsuCompD</DataLocation>
<DefaultData>DHCOPRegInsuCompDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCOPRegInsuCompD</IdLocation>
<IndexLocation>^User.DHCOPRegInsuCompI</IndexLocation>
<StreamLocation>^User.DHCOPRegInsuCompS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
