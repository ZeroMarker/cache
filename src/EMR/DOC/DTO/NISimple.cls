/// 名称:	EMR.DOC.DTO.NISimple
/// 描述:	打散数据-反序列化Simple
/// 编写者：	yejian
/// 编写日期: 	2022-11-3
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.NISimple Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Simple";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property SectionCode As %String(XMLNAME = "SectionCode", XMLREF = 1) [ Required ];

Property EMRCode As %String(XMLNAME = "EMRCode", XMLREF = 1) [ Required ];

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property Name As %String(XMLNAME = "Name", XMLREF = 1) [ Required ];

Property ValueCode As %String(XMLNAME = "ValueCode", XMLREF = 1) [ Required ];

Property DataValue As %String(XMLNAME = "DataValue", XMLREF = 1) [ Required ];

Property BindKBCode As %String(XMLNAME = "BindKBCode", XMLREF = 1) [ Required ];

Property KBNodeID As %String(XMLNAME = "KBNodeID", XMLREF = 1) [ Required ];

Property DataRef As %String(XMLNAME = "DataRef", XMLREF = 1) [ Required ];

Property Separator As %String(XMLNAME = "Separator", XMLREF = 1) [ Required ];

Property Type As %String(XMLNAME = "Type", XMLREF = 1) [ Required ];

Property SourceCode As %String(XMLNAME = "SourceCode", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %DynamicAbstractObject, ByRef aRelation As EMR.DOC.DTO.NIScattorRelation, ByRef aValue As %String, ByRef aStyleVlaue As %String)
{
	s value = "",styleVlaue = ""
	;w reader.%ToJSON(),!
	s ..SectionCode = aRelation.SectionCode
	s ..BindKBCode = aRelation.KBCode
	s ..KBNodeID = aRelation.KBSourceCode
	//字符、数值、链接单元、签名
	if (reader.type="string")||(reader.type="number")||(reader.type="link")||(reader.type="sign") 
	{
		s ..Type = reader.type
		d ..GetAttrs(reader.attrs,.aValue,.aStyleVlaue)
		d ..GetChildText(reader.children,.aValue,.aStyleVlaue)
	}
	elseif (reader.type="dateTime") //日期
	{
		s ..Type = reader.type
		d ..GetAttrs(reader.attrs,.aValue,.aStyleVlaue)
		d ..GetChildText(reader.children,.aValue,.aStyleVlaue)
		;s ..DataValue = reader.value
	}
	elseif (reader.type="dictionary")||(reader.type="radio")||(reader.type="checkbox")  //字典、单选、多选
	{
		s ..Type = reader.type
		d ..GetAttrs(reader.attrs,.aValue,.aStyleVlaue)
	}
	
	s aValue= ..DataValue
	s aStyleVlaue = ..DataValue
}

/// 解析attrs
Method GetAttrs(ByRef aAttrs As %DynamicAbstractObject, ByRef aValue As %String, ByRef aStyleVlaue As %String)
{
	s attrItems =aAttrs.%GetIterator()
	s split = $case(aAttrs.separator,"":",",:aAttrs.separator)
	while attrItems.%GetNext(.attrIndex , .attrItem)
	{
		s:(attrIndex="code") ..Code =attrItem
		s:(attrIndex="emrCode") ..EMRCode =attrItem
		s:(attrIndex="name") ..Name =attrItem
		s:(attrIndex="sourceCode") ..SourceCode =attrItem
		if (attrIndex="checked")&&(attrItem'="")
		{
			s checkItems =attrItem.%GetIterator()
			while checkItems.%GetNext(.checkIndex , .checkItem)
			{
				q:(checkItem="")
				s:(checkItem.id'="") ..DataRef = $CASE(..DataRef,"":checkItem.id,:..DataRef_split_checkItem.id)
				s:(checkItem.value'="") ..ValueCode = $CASE(..ValueCode,"":checkItem.value,:..ValueCode_split_checkItem.value)
				s:(checkItem.text'="") ..DataValue = $CASE(..DataValue,"":checkItem.text,:..DataValue_split_checkItem.text)
			}
		}
	}
}

/// 解析元素child获取text
Method GetChildText(ByRef aChild As %DynamicAbstractObject, ByRef aValue As %String, ByRef aStyleVlaue As %String)
{
		s childDatas =aChild.%GetIterator()
		s text =""
		while childDatas.%GetNext(.childindex , .childItem) 
		{	
			//留痕删除
			continue:(childItem.revise'="")&&(childItem.revise.del'="")
			//内容
			s:(childItem.sup="true")||(childItem.sup=1) text =text_"<sup>"
			s:(childItem.sub="true")||(childItem.sub=1) text =text_"<sub>"
			s text = text_childItem.text
			s:(childItem.sup="true")||(childItem.sup=1) text =text_"</sup>"
			s:(childItem.sub="true")||(childItem.sub=1) text =text_"</sub>"
		}
		s ..DataValue = text
}

}
