/// 名称:	EMR.DOC.DTO.NIParagraph
/// 描述:	打散数据-反序列化Paragraph
/// 编写者：	yejian
/// 编写日期: 	2022-11-3
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.NIParagraph Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Paragraph";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property SourceCode As %String(XMLNAME = "SourceCode", XMLREF = 1) [ Required ];

Property Text As %String(XMLNAME = "Text", XMLREF = 1) [ Required ];

// Property StyleText As %String(XMLNAME = "StyleText", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %DynamicAbstractObject, ByRef aDataList As EMR.DOC.DTO.NIScatterList, ByRef aRelation As EMR.DOC.DTO.NIScattorRelation, ByRef aValue As %String, ByRef aStyleVlaue As %String)
{
	//遍历line
	;w reader.%ToJSON(),!
	if (reader.type="fragment")
	{
		s ..Code = reader.attrs.code
		s ..SourceCode = reader.attrs.sourceCode
		s aRelation.KBCode = ..Code
		s aRelation.KBSourceCode = ..SourceCode
	}
	s childDatas =reader.children.%GetIterator()
	while childDatas.%GetNext(.childIndex , .childItem)
	{
		continue:(childItem="")
		//子节点为paragraph或fragment
		if (childItem.type="paragraph")||(childItem.type="fragment") //段落
		{
			s value = "",styleVlaue = ""
			s Paragraph = ##class(EMR.DOC.DTO.NIParagraph).%New()
			d Paragraph.XMLDeserialize(childItem,.aDataList,.aRelation,.value,.styleVlaue)
			d aDataList.Paragraph.Insert(Paragraph)
			s:(value'="") ..Text = ..Text_value
		}
		elseif(childItem.type="line")
		{
			s cchildDatas =childItem.children.%GetIterator()
			while cchildDatas.%GetNext(.cchildIndex , .cchildItem) 
			{	
				//章节名称元素跳过
				continue:(cchildItem.sectionName = "true")
				s value = "",styleVlaue = ""
				//结构化元素
				if (cchildItem.type="menstrual")||(cchildItem.type="eyeDeepGrade")||(cchildItem.type="fetalHeart") //月经生育史、前房深度、胎心
				{
					s NIMacro = ##class(EMR.DOC.DTO.NIMacro).%New()
					d NIMacro.XMLDeserialize(cchildItem,.aDataList,.aRelation,.value,.styleVlaue)
					d aDataList.Macros.Insert(NIMacro)
				}
				elseif (cchildItem.type="tooth") //牙位
				{
					s NITooth = ##class(EMR.DOC.DTO.NITooth).%New()
					d NITooth.XMLDeserialize(cchildItem,.aDataList,.aRelation,.value,.styleVlaue)
					d aDataList.Tooth.Insert(NITooth)
				}
				elseif (cchildItem.type="fragment") //片段
				{
					s Paragraph = ##class(EMR.DOC.DTO.NIParagraph).%New()
					d Paragraph.XMLDeserialize(cchildItem,.aDataList,.aRelation,.value,.styleVlaue)
					d aDataList.Paragraph.Insert(Paragraph)
				}
				elseif (cchildItem.type'="") 
				{
					s SubItems = ##class(EMR.DOC.DTO.NISimple).%New()
					d SubItems.XMLDeserialize(cchildItem,.aRelation,.value,.styleVlaue)
					d aDataList.Simples.Insert(SubItems)
				}
				else //文本
				{
					//留痕删除
					continue:(cchildItem.revise'="")&&(cchildItem.revise.del'="")
					//内容
					s:(cchildItem.sup="true")||(cchildItem.sup=1) value =value_"<sup>"
					s:(cchildItem.sub="true")||(cchildItem.sub=1) value =value_"<sub>"
					s value = value_cchildItem.text
					s:(cchildItem.sup="true")||(cchildItem.sup=1) value =value_"</sup>"
					s:(cchildItem.sub="true")||(cchildItem.sub=1) value =value_"</sub>"
					
				}
				s:(value'="") ..Text = ..Text_value
			}
		}
		
	}
	s aValue= ..Text
}

}
