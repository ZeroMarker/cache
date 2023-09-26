/// 名称:	EMR.DOC.DTO.NIMacro
/// 描述:	打散数据-反序列化
/// 编写者：	yejian
/// 编写日期: 	2022-11-3
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.NITooth Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Tooth";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property SectionCode As %String(XMLNAME = "SectionCode", XMLREF = 1) [ Required ];

Property EMRCode As %String(XMLNAME = "EMRCode", XMLREF = 1) [ Required ];

Property KBNodeID As %String(XMLNAME = "KBNodeID", XMLREF = 1) [ Required ];

Property ToothImageCode As %String(XMLNAME = "ToothImageCode", XMLREF = 1) [ Required ];

Property ToothImageName As %String(XMLNAME = "ToothImageName", XMLREF = 1) [ Required ];

/// 牙位图表示法(PALMER，UNIVERSAL)
Property CodeSystem As %String(XMLNAME = "CodeSystem", XMLREF = 1) [ Required ];

/// 牙位图表示法名称(帕尔默牙位表示法,通用记录表示法)
Property CodeSystemName As %String(XMLNAME = "CodeSystemName", XMLREF = 1) [ Required ];

/// 牙位表示法(PALMER，UNIVERSAL)
Property SurfaceCodeSystem As %String(XMLNAME = "SurfaceCodeSystem", XMLREF = 1) [ Required ];

/// 牙位表示法名称(帕尔默牙位表示法,通用记录表示法)
Property SurfaceCodeSystemName As %String(XMLNAME = "SurfaceCodeSystemName", XMLREF = 1) [ Required ];

Property ToothType As %String(XMLNAME = "ToothType", XMLREF = 1) [ Required ];

Property Text As %String(XMLNAME = "Text", XMLREF = 1) [ Required ];

Property SourceCode As %String(XMLNAME = "SourceCode", XMLREF = 1) [ Required ];

Property Separator As %String(XMLNAME = "Separator", XMLREF = 1) [ Required ];

/// 展示类型（image/text）
Property ShowType As %String(XMLNAME = "ShowType", XMLREF = 1) [ Required ];

/// 牙位表示法
Property ToothREP As %String(XMLNAME = "ToothREP", XMLREF = 1) [ Required ];

/// 图片数据
Property ImageUrl As %String(XMLNAME = "ShowType", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %DynamicAbstractObject, ByRef aDataList As EMR.DOC.DTO.NIScatterList, ByRef aRelation As EMR.DOC.DTO.NIScattorRelation, ByRef aValue As %String, ByRef aStyleVlaue As %String)
{
	s value = "",styleVlaue = ""
	;w reader.%ToJSON(),!
	s ..SectionCode = aRelation.SectionCode
	s ..KBNodeID = aRelation.KBSourceCode
	//牙位
	if (reader.type="tooth") 
	{
		d ..GetAttrs(reader.attrs,.aDataList,.aRelation,.aValue,.aStyleVlaue)
		d ..GetChildText(reader.children,.aValue,.aStyleVlaue)
		s ..Text = aValue
	}
	s aValue= ..Text
}

/// 解析attrs
Method GetAttrs(ByRef aAttrs As %DynamicAbstractObject, ByRef aDataList As EMR.DOC.DTO.NIScatterList, ByRef aRelation As EMR.DOC.DTO.NIScattorRelation, ByRef aValue As %String, ByRef aStyleVlaue As %String)
{
	s attrItems =aAttrs.%GetIterator()
	while attrItems.%GetNext(.attrIndex , .attrItem)
	{
		s:(attrIndex="code") ..ToothImageCode = attrItem,aRelation.ToothImageCode=attrItem
		s:(attrIndex="toothCodeSystem") ..CodeSystem =attrItem,aRelation.ToothCodeSystem = attrItem
		s:(attrIndex="toothCodeSystemName") ..CodeSystemName =attrItem,aRelation.ToothCodeSystemName = attrItem
		s:(attrIndex="toothSurfaceCodeSystem") ..SurfaceCodeSystem =attrItem
		s:(attrIndex="toothSurfaceCodeSystemName") ..SurfaceCodeSystemName =attrItem
		s:(attrIndex="sourceCode") ..SourceCode =attrItem
		s:(attrIndex="emrcode") ..EMRCode =attrItem
		s:(attrIndex="name") ..ToothImageName =attrItem
		s:(attrIndex="toothType") ..ToothType =attrItem
		s:(attrIndex="separator") ..Separator =attrItem
		s:(attrIndex="toothMethod") ..ToothREP =attrItem
		s:(attrIndex="showType") ..ShowType =attrItem
		s:(attrIndex="imageUrl") ..ImageUrl= attrItem
		//处理牙子项
		if (attrIndex="A")||(attrIndex="B")||(attrIndex="C")||(attrIndex="D")
		{
			s items =attrItem.%GetIterator()
			while items.%GetNext(.poindex , .poItem)
			{
				q:(poItem="")
				s NIToothPosition = ##class(EMR.DOC.DTO.NIToothPosition).%New()
				d NIToothPosition.XMLDeserialize(poItem,aDataList,aRelation)
				d aDataList.ToothPosition.Insert(NIToothPosition)
			}
		}
	}
}

/// 解析元素child获取text
Method GetChildText(ByRef aChild As %DynamicAbstractObject, ByRef aValue As %String, ByRef aStyleVlaue As %String)
{
		s childDatas =aChild.%GetIterator()
		while childDatas.%GetNext(.childindex , .childItem) 
		{	
			//留痕删除
			continue:(childItem.revise'="")&&(childItem.revise.del'="")
			if (childItem.children'="")
			{
				d ..GetChildText(childItem.children,.aValue,.aStyleVlaue)
			}
			elseif(childItem.text'="")
			{
				//内容
				s:(childItem.sup="true")||(childItem.sup=1) aValue =aValue_"<sup>"
				s:(childItem.sub="true")||(childItem.sub=1) aValue =aValue_"<sub>"
				s aValue = aValue_$case(aValue,"":childItem.text,:childItem.text)
				s:(childItem.sup="true")||(childItem.sup=1) aValue =aValue_"</sup>"
				s:(childItem.sub="true")||(childItem.sub=1) aValue =aValue_"</sub>"
			}
		}
}

}
