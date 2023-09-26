/// 名称:	EMR.DOC.DTO.NIScatterList
/// 描述:	打散数据-list集合
/// 编写者：	yejian
/// 编写日期: 	2022-11-24
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.NIScatterList Extends (%RegisteredObject, %XML.Adaptor)
{

Property Sections As list Of EMR.DOC.DTO.NISection(XMLNAME = "Section", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property Paragraph As list Of EMR.DOC.DTO.NIParagraph(XMLNAME = "Paragraph", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property Simples As list Of EMR.DOC.DTO.NISimple(XMLNAME = "Simple", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property Macros As list Of EMR.DOC.DTO.NIMacro(XMLNAME = "Macro", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property MacroItems As list Of EMR.DOC.DTO.NIMacroItems(XMLNAME = "MacroItems", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property Tooth As list Of EMR.DOC.DTO.NITooth(XMLNAME = "Tooth", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property ToothPosition As list Of EMR.DOC.DTO.NIToothPosition(XMLNAME = "ToothPosition", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

Property ToothSurface As list Of EMR.DOC.DTO.NIToothSurface(XMLNAME = "ToothSurface", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

// Property CompositeConcept As EMR.DOC.DTO.NICompositeConcept(XMLNAME = "CompositeConcept", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

// Property CompositeToothImage As EMR.DOC.DTO.NICompositeToothImage(XMLNAME = "CompositeToothImage", XMLPROJECTION = "ELEMENT", XMLREF = 1) [ Required ];

}
