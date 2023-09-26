Class CIS.OPApp.DTO.OP.Requirement Extends (CIS.OPApp.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Requirement";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 设备要求
Property Equipments As %String(TRUNCATE = 1);

/// 器械要求
Property Instruments As %String(TRUNCATE = 1);

/// 耗材要求
Property Materials As %String(TRUNCATE = 1);

/// 特殊情况
Property SpecialCondition As %String(TRUNCATE = 1);

/// 隔离手术
Property Isolated As %String(TRUNCATE = 1);

/// 体外循环 Cardiopulmonary Bypass
Property CPB As %String(TRUNCATE = 1);

/// 术中自体血回输 Intraoperative Autotransfusion
Property IOAT As %String(TRUNCATE = 1);

/// 备血
Property PrepareBlood As %String(TRUNCATE = 1);

/// 感染手术
Property Infectious As %String(TRUNCATE = 1);

/// 微创手术
Property MinimallyInvasive As %String(TRUNCATE = 1);

/// 抗生素使用
Property Antibiotic As %String(TRUNCATE = 1);

/// 备注
Property Note As %String(MAXLEN = 200);

}
