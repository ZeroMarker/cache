Class User.DHCDocCureAssScore Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCAS_RowID, SqlTableName = DHC_DocCureAssScore ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCDocCureAssScoreForm As User.DHCDocCureAssScoreForm [ Cardinality = children, Inverse = DCASFParRefDr ];

/// 病人Adm   DCAS_Adm_Dr
Property DCASAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = DCAS_Adm_Dr ];

/// 患者ID   DCAS_Patient_Dr
Property DCASPatientDr As User.PAPatMas [ SqlColumnNumber = 3, SqlFieldName = DCAS_Patient_Dr ];

/// 创建日期  DCAS_Date
Property DCASDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = DCAS_Date ];

/// 创建时间  DCAS_Time
Property DCASTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = DCAS_Time ];

/// 创建人  DCAS_CreateUser_Dr
Property DCASCreateUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = DCAS_CreateUser_Dr ];

/// 业务类型   DCAS_Type DOC医师申请 CURE 治疗师新增
Property DCASType As %String(DISPLAYLIST = ",DOC,CURE", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",D,C") [ SqlColumnNumber = 7, SqlFieldName = DCAS_Type ];

/// 评分表ID   DCAS_AssScale_DR
Property DCASAssScaleDR As %String [ SqlColumnNumber = 8, SqlFieldName = DCAS_AssScale_DR ];

/// 评分值   DCAS_ScoreVal
Property DCASScoreVal As %String [ SqlColumnNumber = 9, SqlFieldName = DCAS_ScoreVal ];

/// 关联医嘱 DCAS_OEORD_DR
Property DCASOEORIDR As User.OEOrdItem [ SqlColumnNumber = 10, SqlFieldName = DCAS_OEORI_DR ];

/// 是否已完成 A 未完成 C 取消 F 已完成
Property DCASStatus As %Library.String(DISPLAYLIST = ",A,C,F", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",A,C,F") [ SqlColumnNumber = 11, SqlFieldName = DCA_Status ];

/// 评分人  DCAS_UpdateUser_Dr
Property DCASUpdateUserDr As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = DCAS_UpdateUser_Dr ];

Index DCASAdmDrIndex On DCASAdmDr;

Index DCASPatientDrIndex On DCASPatientDr;

Index DCASDateStatusIndex On (DCASDate, DCASStatus);

Index DCASPatScaleDRIndex On (DCASPatientDr, DCASAssScaleDR);

Index DCASOEORIDRIndex On DCASOEORIDR;

Index DCASAssScaleDRIndex On DCASAssScaleDR;

Storage Default
{
<Data name="DHCDocCureAssScoreDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DCASAdmDr</Value>
</Value>
<Value name="3">
<Value>DCASPatientDr</Value>
</Value>
<Value name="4">
<Value>DCASDate</Value>
</Value>
<Value name="5">
<Value>DCASTime</Value>
</Value>
<Value name="6">
<Value>DCASCreateUserDr</Value>
</Value>
<Value name="7">
<Value>DCASType</Value>
</Value>
<Value name="8">
<Value>DCASAssScaleDR</Value>
</Value>
<Value name="9">
<Value>DCASScoreVal</Value>
</Value>
<Value name="10">
<Value>DCASOEORIDR</Value>
</Value>
<Value name="11">
<Value>DCASStatus</Value>
</Value>
<Value name="12">
<Value>DCASUpdateUserDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocCureAssScoreD</DataLocation>
<DefaultData>DHCDocCureAssScoreDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCDocCureAssScoreD</IdLocation>
<IndexLocation>^User.DHCDocCureAssScoreI</IndexLocation>
<StreamLocation>^User.DHCDocCureAssScoreS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
