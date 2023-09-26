/// 名称:	EMR.DOC.DTO.NIMacroItems
/// 描述:	打散数据-反序列化CompositeConcept
/// 编写者：	yejian
/// 编写日期: 	2022-11-3
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.NIMacroItems Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "MacroItems";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property SectionCode As %String(XMLNAME = "SectionCode", XMLREF = 1) [ Required ];

Property EMRCode As %String(XMLNAME = "EMRCode", XMLREF = 1) [ Required ];

Property KBNodeID As %String(XMLNAME = "KBNodeID", XMLREF = 1) [ Required ];

Property MacroCode As %String(XMLNAME = "MacroCode", XMLREF = 1) [ Required ];

Property MacroSourceCode As %String(XMLNAME = "MacroSourceCode", XMLREF = 1) [ Required ];

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property Name As %String(XMLNAME = "Name", XMLREF = 1) [ Required ];

Property Text As %String(XMLNAME = "Text", XMLREF = 1) [ Required ];

Method XMLDeserialize(aCode As %String, aVlaue As %String, ByRef aRelation As EMR.DOC.DTO.NIScattorRelation)
{
	s ..KBNodeID = aRelation.KBSourceCode
	s ..SectionCode = aRelation.SectionCode
	s ..MacroCode = aRelation.MacroCode
	s ..MacroSourceCode = aRelation.MacroSourceCode
	s ..Code = aCode
	s ..Text= aVlaue
}

}
