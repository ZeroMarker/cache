/// 名称:	EMR.DOC.DTO.NIScatterData
/// 描述:	打散数据-反序列化
/// 编写者：	yejian
/// 编写日期: 	2022-11-3
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.NIScatterData Extends (%RegisteredObject, %XML.Adaptor)
{

/// 编辑器json版本
Parameter JSONVersion = "1.0.0.1";

Parameter XMLNAME = "ScatterData";

Parameter XMLSEQUENCE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property DataList As EMR.DOC.DTO.NIScatterList;

Method XMLDeserialize(ByRef reader As %DynamicAbstractObject)
{
	s aDataList = ##class(EMR.DOC.DTO.NIScatterList).%New()
	s items =reader.%GetIterator()
    while items.%GetNext(.index , .jItem)
    {
	    if (index="headFoot") //页眉页脚
		{
			s hfdatas =jItem.%GetIterator()
		    while hfdatas.%GetNext(.tfindex , .tfItem)
		    {	
		    	if (tfindex="header")||(tfindex = "footer") //页眉页脚
				{
					s secdatas =tfItem.%GetIterator()
				    while secdatas.%GetNext(.secindex , .secItem)
				    {	
				    	q:(secItem="")
				    	s section = ##class(EMR.DOC.DTO.NISection).%New()
						d section.XMLDeserialize(secItem,.aDataList)
						d aDataList.Sections.Insert(section)
				    }
		    	}
		    }
		}
		elseif (index="value") //文档体
		{
		   s secdatas =jItem.children.%GetIterator()
		    while secdatas.%GetNext(.secindex , .secItem)
		    {	
		    	q:(secItem="")
		    	s section = ##class(EMR.DOC.DTO.NISection).%New()
				d section.XMLDeserialize(secItem,.aDataList)
				d aDataList.Sections.Insert(section)
		    }
		    	
		    
		}
	}
	s ..DataList = aDataList
}

}
