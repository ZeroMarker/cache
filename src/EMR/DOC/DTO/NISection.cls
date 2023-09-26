/// 名称:	EMR.DOC.DTO.NISection
/// 描述:	打散数据-反序列化Section
/// 编写者：	yejian
/// 编写日期: 	2022-11-3
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.NISection Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Section";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Code As %String(XMLNAME = "Code", XMLREF = 1) [ Required ];

Property EMRCode As %String(XMLNAME = "EMRCode", XMLREF = 1) [ Required ];

Property Name As %String(XMLNAME = "Name", XMLREF = 1) [ Required ];

Property Text As %String(XMLNAME = "Text", XMLREF = 1) [ Required ];

Method XMLDeserialize(ByRef reader As %DynamicAbstractObject, ByRef aDataList As EMR.DOC.DTO.NIScatterList)
{
	;w reader.%ToJSON(),!
	s objRelation = ##class(EMR.DOC.DTO.NIScattorRelation).%New()
	s items =reader.%GetIterator()
	//页眉、页脚
	if (reader.type = "header")||(reader.type ="footer")
	{
		s ..Code = reader.type
		;s ..EMRCode = reader.type
		s ..Name = reader.type
	}
	elseif(reader.type = "section")
	{
		s ..Code = reader.attrs.code
		s ..EMRCode = reader.attrs.emrCode
		s ..Name = reader.attrs.name
	}
	s objRelation.SectionCode = ..Code
	while items.%GetNext(.index , .jItem)
	{
		q:(jItem="")
		if (index="children")
		{
			s value = "",styleVlaue = ""
			s childDatas =jItem.%GetIterator()
			while childDatas.%GetNext(.childindex , .childItem) 
			{	
				//子章节
				if (childItem.type="section") 
				{
					s section = ##class(EMR.DOC.DTO.NISection).%New()
					d section.XMLDeserialize(childItem,.aDataList)
					d aDataList.Sections.Insert(section)
				}
				elseif (childItem.type="table") //表格
				{
					s items =childItem.children.%GetIterator()
					while items.%GetNext(.trindex , .trItem)
					{
						q:(trItem="")
						s tdItems =trItem.children.%GetIterator()
						while tdItems.%GetNext(.tdindex , .tdItem) 
						{	
							q:(tdItem="")
							s paragraphItems =tdItem.children.%GetIterator()
							while paragraphItems.%GetNext(.paragraphindex , .paragraphItem) 
							{	
								//段落
								if (paragraphItem.type="paragraph") 
								{
									s value = "",styleVlaue = ""
									s Paragraph = ##class(EMR.DOC.DTO.NIParagraph).%New()
									d Paragraph.XMLDeserialize(paragraphItem,.aDataList,.objRelation,.value,.styleVlaue)
									d aDataList.Paragraph.Insert(Paragraph)
									s:(value'="") ..Text = ..Text_value
								}
							}
						}
					}
				}
				elseif (childItem.type="paragraph")||(childItem.type="fragment") //段落
				{
					s value = "",styleVlaue = ""
					s Paragraph = ##class(EMR.DOC.DTO.NIParagraph).%New()
					d Paragraph.XMLDeserialize(childItem,.aDataList,.objRelation,.value,.styleVlaue)
					d aDataList.Paragraph.Insert(Paragraph)
					s:(value'="") ..Text = ..Text_value
				}
			}
		}
		
	}
}

}
