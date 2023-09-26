/// 名称:	EMR.DOC.DTO.NIMacro
/// 描述:	打散数据-反序列化
/// 编写者：	yejian
/// 编写日期: 	2022-11-3
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.NIMacro Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Macro";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property SectionCode As %String(XMLNAME = "SectionCode", XMLREF = 1) [ Required ];

Property EMRCode As %String(XMLNAME = "EMRCode", XMLREF = 1) [ Required ];

Property KBNodeID As %String(XMLNAME = "KBNodeID", XMLREF = 1) [ Required ];

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property Name As %String(XMLNAME = "Name", XMLREF = 1) [ Required ];

/// 宏类型（menstrual 月经生育、eyeDeepGrade 前房深度、fetalHeart 胎心）
Property Type As %String(XMLNAME = "Type", XMLREF = 1) [ Required ];

Property Text As %String(XMLNAME = "Text", XMLREF = 1) [ Required ];

Property SourceCode As %String(XMLNAME = "SourceCode", XMLREF = 1) [ Required ];

/// 大小（前房深度，胎心的图片大小）
Property Size As %String(XMLNAME = "Size", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %DynamicAbstractObject, ByRef aDataList As EMR.DOC.DTO.NIScatterList, ByRef aRelation As EMR.DOC.DTO.NIScattorRelation, ByRef aValue As %String, ByRef aStyleVlaue As %String)
{
	s value = "",styleVlaue = ""
	;w reader.%ToJSON(),!
	s ..SectionCode = aRelation.SectionCode
	s ..KBNodeID = aRelation.KBSourceCode
	//月经生育史
	if (reader.type="menstrual") 
	{
		s ..Type = reader.type
		d ..GetAttrs(reader.attrs,.aDataList,.aRelation,.aValue,.aStyleVlaue)
		d ..GetChildText(reader.children,.aValue,.aStyleVlaue)
		s ..Text = aValue
	}
	elseif (reader.type="eyeDeepGrade") //前房深度
	{
		s ..Type = reader.type
		d ..GetAttrs(reader.attrs,.aDataList,.aRelation,.aValue,.aStyleVlaue)
		d ..GetPlaceText(reader.attrs,.aValue,.aStyleVlaue)
		s ..Text = aValue
	}
	elseif (reader.type="fetalHeart") //胎心
	{
		s ..Type = reader.type
		d ..GetAttrs(reader.attrs,.aDataList,.aRelation,.aValue,.aStyleVlaue)
		d ..GetPlaceText(reader.attrs,.aValue,.aStyleVlaue)
		s ..Text = aValue
	}
	s aValue= ..Text
}

/// 解析attrs
Method GetAttrs(ByRef aAttrs As %DynamicAbstractObject, ByRef aDataList As EMR.DOC.DTO.NIScatterList, ByRef aRelation As EMR.DOC.DTO.NIScattorRelation, ByRef aValue As %String, ByRef aStyleVlaue As %String)
{
	s attrItems =aAttrs.%GetIterator()
	s aRelation.MacroCode = aAttrs.code
	s aRelation.MacroSourceCode = aAttrs.sourceCode
	while attrItems.%GetNext(.attrIndex , .attrItem)
	{
		s:(attrIndex="code") ..Code = attrItem
		s:(attrIndex="sourceCode") ..SourceCode =attrItem
		s:(attrIndex="emrcode") ..EMRCode =attrItem
		s:(attrIndex="name") ..Name =attrItem
		if (attrIndex="size")&&(attrItem'="") 
		{
			try
			{
				s ..Size =attrItem.%ToJSON()
			}
			catch
			{
			}
		}
		//处理月经史子项
		if (attrIndex="menarche")||(attrIndex="menstruationPeriod")||(attrIndex="merstrualCycle")||(attrIndex="lastMenstrual")||(attrIndex="lastMenstrualText")
		{
			s NIMacroSim = ##class(EMR.DOC.DTO.NIMacroItems).%New()
			d NIMacroSim.XMLDeserialize(attrIndex,attrItem,aRelation)
			d aDataList.MacroItems.Insert(NIMacroSim)
		}
		elseif (attrIndex="place") //前房深度，胎心
		{
			q:(attrItem="")
			s placeDatas =attrItem.%GetIterator()
			while placeDatas.%GetNext(.placeindex , .placeItem) 
			{	
				s NIMacroSim = ##class(EMR.DOC.DTO.NIMacroItems).%New()
				d NIMacroSim.XMLDeserialize(placeindex,placeItem,aRelation)
				d aDataList.MacroItems.Insert(NIMacroSim)
			}
			
		}
	}
}

/// 解析元素child获取text
Method GetChildText(ByRef aChild As %DynamicAbstractObject, ByRef aValue As %String, ByRef aStyleVlaue As %String)
{
	s childDatas =aChild.%GetIterator()
	s split =";"
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
			s aValue = aValue_$case(aValue,"":childItem.text,:split_childItem.text)
			s:(childItem.sup="true")||(childItem.sup=1) aValue =aValue_"</sup>"
			s:(childItem.sub="true")||(childItem.sub=1) aValue =aValue_"</sub>"
		}
	}
}

/// 解析元素child获取text
Method GetPlaceText(ByRef aChild As %DynamicAbstractObject, ByRef aValue As %String, ByRef aStyleVlaue As %String)
{
	s childDatas =aChild.%GetIterator()
	s split =","
	while childDatas.%GetNext(.childindex , .childItem) 
	{	
		if (childindex="place") 
		{
			q:(childItem="")
			s placeDatas =childItem.%GetIterator()
			while placeDatas.%GetNext(.placeindex , .placeItem) 
			{	
				//内容
				s curVaulue = """"_placeindex_""":"""_placeItem_""""
				s aValue = aValue_$case(aValue,"":curVaulue,:split_curVaulue)
			}
		}
		
	}
}

}
