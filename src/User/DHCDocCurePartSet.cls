Class User.DHCDocCurePartSet Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = DHC_DocCure_PartSet ]
{

Parameter EXTENTSIZE = 250;

/// CPS_Code 代码
Property CPSCode As %String [ SqlColumnNumber = 2, SqlFieldName = CPS_Code ];

/// CPS_Desc 描述
Property CPSDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CPS_Desc ];

/// CPS_Alias 别名
Property CPSAlias As %String [ SqlColumnNumber = 4, SqlFieldName = CPS_Alias ];

/// CPS_DefaultFlag 默认
Property CPSDefaultFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = CPS_DefaultFlag ];

/// CPS_ActiveFlag 激活
Property CPSActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = CPS_ActiveFlag ];

/// CPS_Type 类型 BodyPart-部位 Acupoint-穴位
Property CPSType As %String(DISPLAYLIST = ",BodyPart,Acupoint", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",BP,A") [ SqlColumnNumber = 7, SqlFieldName = CPS_Type ];

/// CPS_Acup_Position 穴位-定位
Property CPSAcupPosition As %String(MAXLEN = 9999) [ SqlColumnNumber = 8, SqlFieldName = CPS_Acup_Position ];

/// CPS_Acup_Attending 穴位-主治
Property CPSAcupAttending As %String(MAXLEN = 9999) [ SqlColumnNumber = 9, SqlFieldName = CPS_Acup_Attending ];

/// CPS_Acup_Operation 穴位-操作
Property CPSAcupOperation As %String(MAXLEN = 9999) [ SqlColumnNumber = 10, SqlFieldName = CPS_Acup_Operation ];

/// CPS_Acup_ImgDiagram 穴位-图解Base64
Property CPSAcupImgDiagram As %Stream.GlobalCharacter [ SqlColumnNumber = 11, SqlFieldName = CPS_Acup_ImgDiagram ];

Index CPSTypeDescIndex On (CPSType, CPSDesc);

Index CPSTypeIndex On CPSType;

Storage Default
{
<Data name="DHCDocCurePartSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPSCode</Value>
</Value>
<Value name="3">
<Value>CPSDesc</Value>
</Value>
<Value name="4">
<Value>CPSAlias</Value>
</Value>
<Value name="5">
<Value>CPSDefaultFlag</Value>
</Value>
<Value name="6">
<Value>CPSActiveFlag</Value>
</Value>
<Value name="7">
<Value>CPSType</Value>
</Value>
<Value name="8">
<Value>CPSAcupPosition</Value>
</Value>
<Value name="9">
<Value>CPSAcupAttending</Value>
</Value>
<Value name="10">
<Value>CPSAcupOperation</Value>
</Value>
<Value name="11">
<Value>CPSAcupImgDiagram</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocCurePartSetD</DataLocation>
<DefaultData>DHCDocCurePartSetDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCDocCurePartSetD</IdLocation>
<IndexLocation>^User.DHCDocCurePartSetI</IndexLocation>
<StreamLocation>^User.DHCDocCurePartSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
