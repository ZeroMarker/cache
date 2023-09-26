/// 犬伤疫苗接种登记表
/// yangyongtao
/// 2021-11-23
/// d ##class(User.DHCEmVacExeReg).%BuildIndices()
Class User.DHCEmVacExeReg Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_EmVacExeReg ]
{

/// 疫苗追溯码 VERCurCode
Property VERCurCode As %String [ SqlColumnNumber = 2, SqlFieldName = VER_CurCode ];

/// 疫苗编码 VER_VaccCode
Property VERVaccCode As %String [ SqlColumnNumber = 3, SqlFieldName = VER_VaccCode ];

/// 生产企业编码 VER_VaccCorp  
Property VERVaccCorp As %String [ SqlColumnNumber = 4, SqlFieldName = VER_VaccCorp ];

/// 接种批号 VER_BatchNo  
Property VERBatchNo As %String [ SqlColumnNumber = 5, SqlFieldName = VER_BatchNo ];

/// 接种日期 VER_InocDate 
Property VERInocDate As %Date [ SqlColumnNumber = 6, SqlFieldName = VER_InocDate ];

/// 接种时间 VER_InocTime  
Property VERInocTime As %Time [ SqlColumnNumber = 7, SqlFieldName = VER_InocTime ];

/// 接种部位 VER_InocPart
Property VERInocPart As %String [ SqlColumnNumber = 8, SqlFieldName = VER_InocPart ];

/// 接种途径 VER_InocRoute
Property VERInocRoute As %String [ SqlColumnNumber = 9, SqlFieldName = VER_InocRoute ];

/// 接种医生 VER_Doc_Dr
Property VERDocDr As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = VER_Doc_Dr ];

/// 接种科室 VER_Loc_Dr
Property VERLocDr As User.CTLoc [ SqlColumnNumber = 11, SqlFieldName = VER_Loc_Dr ];

/// 数据状态 VER_Status
Property VERStatus As %String [ SqlColumnNumber = 12, SqlFieldName = VER_Status ];

/// 就诊ID VER_Adm_Dr
Property VERAdmDr As PAAdm [ SqlColumnNumber = 13, SqlFieldName = VER_Adm_Dr ];

/// 医嘱ID VER_Oeori_Dr
Property VEROeoriDr As User.OEOrdExec [ SqlColumnNumber = 14, SqlFieldName = VER_Oeori_Dr ];

/// 同一个伤情档案下的针次数 VER_NeedleNumber
Property VERNeedleNumber As %String [ SqlColumnNumber = 15, SqlFieldName = VER_NeedleNumber ];

/// 接种类型 VER_InocType
Property VERInocType As %String [ SqlColumnNumber = 16, SqlFieldName = VER_InocType ];

/// 接种记录类型 VER_VacRecType
Property VERVacRecType As %String [ SqlColumnNumber = 17, SqlFieldName = VER_VacRecType ];

/// 集团化医院 VER_HospDr
Property VERHospDr As User.CTHospital [ SqlColumnNumber = 18, SqlFieldName = VER_HospDr ];

Index IndexAdm On (VERAdmDr, VERInocDate);

Index IndexDateLoc On (VERInocDate, VERLocDr);

Index IndexOeori On VEROeoriDr;

Index IndexCurCode On VERCurCode;

Storage Default
{
<Data name="DHCEmVacExeRegDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VERCurCode</Value>
</Value>
<Value name="3">
<Value>VERVaccCode</Value>
</Value>
<Value name="4">
<Value>VERVaccCorp</Value>
</Value>
<Value name="5">
<Value>VERBatchNo</Value>
</Value>
<Value name="6">
<Value>VERInocDate</Value>
</Value>
<Value name="7">
<Value>VERInocTime</Value>
</Value>
<Value name="8">
<Value>VERInocPart</Value>
</Value>
<Value name="9">
<Value>VERInocRoute</Value>
</Value>
<Value name="10">
<Value>VERDocDr</Value>
</Value>
<Value name="11">
<Value>VERLocDr</Value>
</Value>
<Value name="12">
<Value>VERStatus</Value>
</Value>
<Value name="13">
<Value>VERAdmDr</Value>
</Value>
<Value name="14">
<Value>VEROeoriDr</Value>
</Value>
<Value name="15">
<Value>VERNeedleNumber</Value>
</Value>
<Value name="16">
<Value>VERInocType</Value>
</Value>
<Value name="17">
<Value>VERVacRecType</Value>
</Value>
<Value name="18">
<Value>VERHospDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmVacExeRegD</DataLocation>
<DefaultData>DHCEmVacExeRegDefaultData</DefaultData>
<IdLocation>^User.DHCEmVacExeRegD</IdLocation>
<IndexLocation>^User.DHCEmVacExeRegI</IndexLocation>
<StreamLocation>^User.DHCEmVacExeRegS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
