/// 注册配置
Class web.DHCEntity.Configure.PatEnroll Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Y or N
Property AccManageFLag As %String(TRUNCATE = 1);

/// 可用的 卡类型列表, 如果为空， 本设置的 默认 设备类型为空
Property CardTypeList As list Of %String(TRUNCATE = 1);

/// Y or N
Property CardRefFlag As %String(TRUNCATE = 1);

Property DefaultCardTypeDR As %String(TRUNCATE = 1);

Property DefaultCityDR As %String(TRUNCATE = 1);

/// 默认的身份证读取器
Property DefaultIDEquipDR As %String(TRUNCATE = 1);

Property DefaultCountryDR As %String(TRUNCATE = 1);

Property DefaultNationDR As %String(TRUNCATE = 1);

Property DefaultPatTypeDR As %String(TRUNCATE = 1);

Property DefaultProvinceDR As %String(TRUNCATE = 1);

/// 默认性别
Property DefaultSexDR As %String(TRUNCATE = 1);

/// Y or N
Property PatMasFlag As %String(TRUNCATE = 1);

/// 患者类型列表
Property PatTypeList As list Of %String(TRUNCATE = 1);

Method FindCardTypeByDR(CardTypeDR As %String) As %String
{
	;如果存在=1
	;不存在=0
	s myCount=..CardTypeList.Count()
	s myrtn=0
	
	f myIdx=1:1:myCount  q:(+myrtn)  d
	.s myCardTypeDR=..CardTypeList.GetAt(myIdx)
	.q:(myCardTypeDR'=CardTypeDR)
	.s myrtn=1
	
	q myrtn
}

Method FindPatTypeByDR(PatTypeDR As %String) As %String
{
	;如果存在=1
	;不存在=0
	s myCount=..PatTypeList.Count()
	s myrtn=0
	
	f myIdx=1:1:myCount  q:(+myrtn)  d
	.s myPatTypeDR=..PatTypeList.GetAt(myIdx)
	.q:(myPatTypeDR'=PatTypeDR)
	.b	;;Myrtn
	.s myrtn=1
	
	q myrtn
}

}
