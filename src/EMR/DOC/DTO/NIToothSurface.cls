/// 名称:	EMR.DOC.DTO.NIToothSurface
/// 描述:	打散数据-反序列化牙面
/// 编写者：	yejian
/// 编写日期: 	2022-11-3
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.NIToothSurface Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "ToothSurface";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property SectionCode As %String(XMLNAME = "SectionCode", XMLREF = 1) [ Required ];

Property EMRCode As %String(XMLNAME = "EMRCode", XMLREF = 1) [ Required ];

Property KBNodeID As %String(XMLNAME = "KBNodeID", XMLREF = 1) [ Required ];

/// 牙位图编码
Property ToothImageCode As %String(XMLNAME = "ToothImageCode", XMLREF = 1) [ Required ];

/// 牙位图标识(PALMER，UNIVERSAL)
Property CodeSystem As %String(XMLNAME = "CodeSystem", XMLREF = 1) [ Required ];

/// 牙位图标识名称(帕尔默牙位表示法,通用记录表示法)
Property CodeSystemName As %String(XMLNAME = "CodeSystemName", XMLREF = 1) [ Required ];

/// 牙编码
Property ToothCode As %String(XMLNAME = "ToothCode", XMLREF = 1) [ Required ];

/// 牙名称
Property ToothName As %String(XMLNAME = "ToothName", XMLREF = 1) [ Required ];

/// 牙象限（A、B、C、D）
Property Quadrant As %String(XMLNAME = "Quadrant", XMLREF = 1) [ Required ];

/// 牙面编码(AA.8.P)
Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

/// 牙面描述
Property Name As %String(XMLNAME = "Name", XMLREF = 1) [ Required ];

/// 牙面定义
Property Define As %String(XMLNAME = "Define", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %DynamicAbstractObject, ByRef aDataList As EMR.DOC.DTO.NIScatterList, ByRef aRelation As EMR.DOC.DTO.NIScattorRelation, ByRef aValue As %String, ByRef aStyleVlaue As %String)
{
	s value = "",styleVlaue = ""
	;w reader.%ToJSON(),!
	s ..SectionCode = aRelation.SectionCode
	s ..KBNodeID = aRelation.KBSourceCode
	s ..CodeSystem = aRelation.ToothCodeSystem
	s ..CodeSystemName = aRelation.ToothCodeSystemName
	s ..ToothImageCode = aRelation.ToothImageCode
	s ..ToothCode = aRelation.ToothCode
	s ..ToothName = aRelation.ToothName
	d ..GetAttrs(reader,.aDataList,.aRelation,.aValue,.aStyleVlaue)
}

/// 解析attrs
Method GetAttrs(ByRef aAttrs As %DynamicAbstractObject, ByRef aDataList As EMR.DOC.DTO.NIScatterList, ByRef aRelation As EMR.DOC.DTO.NIScattorRelation, ByRef aValue As %String, ByRef aStyleVlaue As %String)
{
	s attrItems =aAttrs.%GetIterator()
	while attrItems.%GetNext(.attrIndex , .attrItem)
	{
		q:(attrItem="")
		s:(attrIndex="code") ..Code = attrItem,..Quadrant = $e(attrItem,2,2)
		s:(attrIndex="name") ..Name =attrItem
		s:(attrIndex="desc") ..Define =attrItem,aValue=attrItem
	}
}

}
