Class EMRservice.Export.CDRXml Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       返回CDRXml
/// Creator:    Candy
/// CreateDate: 2017-2-23
/// Input:      AInstanceID 病历ID
/// Output:     XML	
/// Debug:      d ##Class(EMRservice.Export.CDRXml).GetCDRXml("2||1")  
ClassMethod GetCDRXml(AInstanceID As %String) As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()
	q:(AInstanceID = "") result
	
	s obj = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(obj = "") result
	s type = obj.TheECRecord.DocumentType
	s instanceData = obj.InstanceData
	s metaData = obj.InstanceMetaData
	s title = obj.Title
	/*
	s type = "DOC"
	s instanceData = ##Class(%FileCharacterStream).%New()
	s instanceData.Filename="d:/n.xml"
	s metaData = ##Class(%FileCharacterStream).%New()
	s metaData.Filename="d:/m.xml"
	*/
	if (type = "DOC")
	{
		d result.CopyFrom(..GetWordXml(instanceData,metaData,title))	
	}
	else
	{
		d result.CopyFrom(..GetGirdXML(instanceData,metaData,title))
	}
	/*
	s AStream=##Class(%FileCharacterStream).%New()
	s AStream.Filename="d:\cdrdoc1.xml"
	d AStream.CopyFrom(result)
	d AStream.SaveStream()
	d AStream.%Close()
	*/
	q result
}

/// Desc: 取word型病历xml
/// Debug: d ##Class(EMRservice.Export.CDRXml).GetWordXml("d:\test.xml")
ClassMethod GetWordXml(ANInstanceData As %GlobalBinaryStream, AMetaData As %GlobalBinaryStream, ATitle As %String) As %GlobalBinaryStream
{
	s ResStream = ##Class(%GlobalBinaryStream).%New()
    s status=##class(%XML.TextReader).ParseStream(ANInstanceData,.textreader)
    q:($$$ISERR(status)) ResStream
    d ResStream.Write("<CDR>")
    d ResStream.Write("<name>"_ATitle_"</name>")
    while textreader.Read()
    {
	 	if (textreader.Name = "section")&&(textreader.NodeType = "element") 
	 	{
		 	 d textreader.MoveToAttributeName("type")
		 	 s type = textreader.Value	
		 	 if (type = "")
		 	 {
			 	 d ..GetMainBody(.textreader,.ResStream,AMetaData)
			 }
			 elseif(type = "header")
			 {
				 d ResStream.Write("<section Code=""header""  DispalyName=""header"">")
				 d ..GetHeadOrFoot(.textreader,.ResStream,ANInstanceData,AMetaData)
				 d ResStream.Write("</section>")
			 }
			 elseif(type = "footer")
			 {
				 d ResStream.Write("<section Code=""footer""  DispalyName=""footer"">")
				 d ..GetHeadOrFoot(.textreader,.ResStream,ANInstanceData,AMetaData)
				 d ResStream.Write("</section>")
			 }
		}  
	}
    d ResStream.Write("</CDR>")
    q ResStream
}

/// Desc:病历正文节点
ClassMethod GetMainBody(ByRef textreader, ByRef Stream, AMetaData As %GlobalBinaryStream)
{
	s flag = 0
	s arryProps = ##Class(%ArrayOfDataTypes).%New()
    while textreader.Read()
    {
	    q:(textreader.Name = "section")&&(textreader.NodeType = "endelement") 
	    if (textreader.Name = "p")&&(textreader.NodeType = "element")
	    {
		    while textreader.Read()
		    {
			    q:(textreader.Name = "p")&&(textreader.NodeType = "endelement")
			    if (textreader.Name = "c")&&(textreader.NodeType = "element")
			    {
		         	d arryProps.Clear()
		         	s count = textreader.AttributeCountGet()
					for i=1:1:count
					{
						d textreader.MoveToAttributeIndex(i)
						d arryProps.SetAt(textreader.Value,textreader.LocalName)
					}
		         	s props = arryProps.GetAt("props")
		         	s revision = arryProps.GetAt("revision")
		            if (props [ "et:9")
		         	{
			         	d:(flag '= 0) Stream.Write("</section>")
			         	d Stream.Write("<section ")
			         	s path = ..getPropertyValue(props,"code",";")
			         	s path = $p(path,"^",2)
			         	s attr = ..GetSectionValue(path,AMetaData)
			         	s key = ""
			         	for
			         	{
				         	s value = attr.GetNext(.key)
				         	q:(key = "")
				         	d Stream.Write(" "_key_"="""_value_"""")
				        }	
     	
			         	d Stream.Write(">")

			         	if (props '[ "display:none")
					    {
						    d Stream.Write("<text>")
						    d textreader.MoveToContent()
							d Stream.Write(textreader.Value)
							d Stream.Write("</text>")
					    }
			         	s flag = 1
			        }
			        elseif (props [ "code")
			        {
				        continue:(props [ "display:none")
				        d Stream.Write("<field  ")
						s path = ..getPropertyValue(props,"code",";")
			         	s path = $p(path,"^",2)
			         	s attr = ..GetFieldVlaue(path,AMetaData)
			         	s key = ""
			         	for
			         	{
				         	s value = attr.GetNext(.key)
				         	q:(key = "")
				         	d Stream.Write(" "_key_"="""_value_""" ")
				        }	
	        			d Stream.Write(">")
						d ..GetChar(props,revision,.textreader,.Stream)
				        d Stream.Write("</field>")
				    }
				    else
				    {
					    continue:((revision [ ",")|| ($e(revision,1,1)="-"))
					    continue:(props [ "display:none")
					    d Stream.Write("<text>")
						d ..GetChar(props,revision,.textreader,.Stream)
	        			d Stream.Write("</text>")
					}			    
				}
				elseif (textreader.Name = "image")&&(textreader.NodeType = "element")
				{
					d textreader.MoveToAttributeName("title")	
					s char = textreader.Value
					d Stream.Write("<text> "_char_" </text>")
				}
			}
		}
		elseif (textreader.Name = "table")&&(textreader.NodeType = "element")
		{
			d Stream.Write("<table>")
			d ..GetTableData(.textreader,.Stream,AMetaData)
		}
    }
    d:(flag '= 0) Stream.Write("</section>")
}

/// Desc:取页眉页脚内容
/// Creator:Candy
/// CreateDate:2017-23
ClassMethod GetHeadOrFoot(ByRef reader, ByRef Stream, ANInstanceData As %GlobalBinaryStream, AMetaData As %GlobalBinaryStream)
{
	s arryProps = ##Class(%ArrayOfDataTypes).%New()
	while reader.Read()
	{
		q:(reader.Name = "section")&&(reader.NodeType = "endelement") 
		if (reader.Name = "c")&&(reader.NodeType = "element")
	    {
         	d arryProps.Clear()
         	s count = reader.AttributeCountGet()
			for i=1:1:count
			{
				d reader.MoveToAttributeIndex(i)
				d arryProps.SetAt(reader.Value,reader.LocalName)
			}
         	s props = arryProps.GetAt("props")
         	s revision = arryProps.GetAt("revision") 
	        if (props [ "code")
	        {
		        continue:(props [ "display:none")
		        d Stream.Write("<field  ")
				s path = ..getPropertyValue(props,"code",";")
	         	s attr = ..GetFieldVlaue(path,AMetaData)
	         	s key = ""
	         	for
	         	{
		         	s value = attr.GetNext(.key)
		         	q:(key = "")
		         	d Stream.Write(" "_key_"="""_value_""" ")
		        }	
				d Stream.Write(">")
				d ..GetChar(props,revision,.reader,.Stream)
		        d Stream.Write("</field>")
		    }
		    else
		    {
			    continue:(props [ "display:none")
			    d Stream.Write("<text>")
				d ..GetChar(props,revision,.reader,.Stream)
			    d Stream.Write("</text>")
			}
	    }
	    elseif (reader.Name = "field")&&(reader.NodeType = "element")
	    {
			d Stream.Write("<field  ")
			d reader.MoveToAttributeName("props")
			s props = reader.Value
			s path = ..getPropertyValue(props,"code",";")
			s attr = ..GetFieldVlaue(path,AMetaData)
			s key = ""
			for
			{
				s value = attr.GetNext(.key)
				q:(key = "")
				d Stream.Write(" "_key_"="""_value_""" ")
			} 
			d Stream.Write(">  ")
			s char = ..GetDynamicLabelValue(path,ANInstanceData)
			d Stream.Write(char)
			d Stream.Write("</field>")
		}
	}
}

/// 解析表格
ClassMethod GetTableData(ByRef textreader, ByRef Stream, AMetaData As %GlobalBinaryStream)
{
    while textreader.Read()
    {
	    q:(textreader.Name = "table")&&(textreader.NodeType = "endelement") 
	    if (textreader.Name = "cell")&&(textreader.NodeType = "element")
	    {
			d textreader.MoveToAttributeName("props")
			s props = textreader.Value
			s topattach = ..getPropertyValue(props,"top-attach",";")
			d Stream.Write("<row  index ="""_topattach_""">")
		    while textreader.Read()
		    {
			    q:(textreader.Name = "cell")&&(textreader.NodeType = "endelement")
			    if (textreader.Name = "c")&&(textreader.NodeType = "element")
			    {
				    d textreader.MoveToAttributeName("props")
			    	s props = textreader.Value
			    	d textreader.MoveToAttributeName("revision") 
			    	s revision = textreader.Value
			    	if (props [ "code")
			        {
				        continue:(props [ "display:none")
				        d Stream.Write("<field  ")
						s path = ..getPropertyValue(props,"code",";")
			         	s path = $p(path,"^",2)
			         	s attr = ..GetFieldVlaue(path,AMetaData)
			         	s key = ""
			         	for
			         	{
				         	s value = attr.GetNext(.key)
				         	q:(key = "")
				         	d Stream.Write(" "_key_"="""_value_""" ")
				        }	
	        			d Stream.Write(">")
						d ..GetChar(props,revision,.textreader,.Stream)
				        d Stream.Write("</field>")
				    }
				    else
				    {
					    continue:(revision [ ",")
					    continue:(props [ "display:none")
					    d Stream.Write("<text>")
						d ..GetChar(props,revision,.textreader,.Stream)
					    d Stream.Write("</text>")
					}			    
				}
				elseif (textreader.Name = "image")&&(textreader.NodeType = "element")
				{
					d textreader.MoveToAttributeName("title")	
					s char = textreader.Value
					d Stream.Write("<text> "_char_" </text>")
				}
			}
			d Stream.Write("</row>")
		}
    }
    d Stream.Write("</table>")
}

/// Desc:   取章节属性值
/// Debug:  d ##Class(EMRservice.Tools.Tool).GetSectionValue("S001")
ClassMethod GetSectionValue(ACode As %String, AMetaData As %GlobalBinaryStream) As %String
{
    s result = ##class(%ArrayOfDataTypes).%New()
    q:(ACode = "") result	
    s sc=##class(%XML.XPATH.Document).CreateFromStream(AMetaData,.doc)
  	q:($$$ISERR(sc)) result

	s sc=doc.EvaluateExpression("/MetaData/Component/Section","Code[@Code='"_ACode_"']",.res)
    q:($$$ISERR(sc)||res.Count()<=0) result
    s node = res.GetAt(1)
    if (node.Type=2)
    {
	    d node.Read()
	    q:(node.NodeType '="element")
	    d node.MoveToAttributeName("Code")
	    s code = node.Value
	    d result.SetAt(code,"Code")
	    d node.MoveToAttributeName("DisplayName")
	    s displayName = node.Value
	    d result.SetAt(displayName,"DisplayName")
	}  
    q result
}

/// 获取结构化单元属性值
ClassMethod GetFieldVlaue(ACode As %String, AMetaData As %GlobalBinaryStream) As %String
{
	s result = ##class(%ArrayOfDataTypes).%New()
    q:(ACode = "")||(AMetaData.Size<=0) result	
    d AMetaData.Rewind()
	s sectionId = $p(ACode,"_",1)
	s compositeId = $p(ACode,"_",2)
	s simple = $p(ACode,"_",3)
    s sc=##class(%XML.XPATH.Document).CreateFromStream(AMetaData,.doc)
  	q:($$$ISERR(sc)) result
  	
    s type = ..GetUnitType(simple)
    if (type = "MIConcept")
    {
	    s csimple = $p(ACode,"_",4)
	    s cstype = ..GetUnitType(csimple)
		s sc = doc.EvaluateExpression("/MetaData/Component/Section[Code/@Code='"_sectionId_"']/Composite[Code/@Code='"_compositeId_"']/SubItems/"_type_"[Code='"_simple_"']/SubItems/Attribute/RefElement/"_cstype_"[Code='"_csimple_"']/Code","text()",.res)   
		q:($$$ISERR(sc)) result
   		s code = $case(res.Count()>0,1:res.GetAt(1).Value,:"")
    	d result.SetAt(code,"Code")
		s sc = doc.EvaluateExpression("/MetaData/Component/Section[Code/@Code='"_sectionId_"']/Composite[Code/@Code='"_compositeId_"']/SubItems/"_type_"[Code='"_simple_"']/SubItems/Attribute/RefElement/"_cstype_"[Code='"_csimple_"']/DisplayName","text()",.res)   
		q:($$$ISERR(sc)) result
    	s displayName = $case(res.Count()>0,1:res.GetAt(1).Value,:"") 
	    d result.SetAt(displayName,"DisplayName")	
	}
	else
	{
		s sc = doc.EvaluateExpression("/MetaData/Component/Section[Code/@Code='"_sectionId_"']/Composite[Code/@Code='"_compositeId_"']/SubItems/"_type_"[Code='"_simple_"']/Code","text()",.res)		
	    q:($$$ISERR(sc)) result
	    s code = $case(res.Count()>0,1:res.GetAt(1).Value,:"")
    	d result.SetAt(code,"Code")
 		s sc = doc.EvaluateExpression("/MetaData/Component/Section[Code/@Code='"_sectionId_"']/Composite[Code/@Code='"_compositeId_"']/SubItems/"_type_"[Code='"_simple_"']/DisplayName","text()",.res)		
	    q:($$$ISERR(sc)) result 
	    s displayname = $case(res.Count()>0,1:res.GetAt(1).Value,:"")
	    d result.SetAt(displayname,"DisplayName")	
	} 
    q result
}

/// Desc:从打散数据中取动态标签值
ClassMethod GetDynamicLabelValue(ACode As %String, ANInstanceData As %GlobalBinaryStream) As %String
{
	s result = ""
	q:(ACode = "")||(ANInstanceData.Size = 0) result
	s sc=##class(%XML.XPATH.Document).CreateFromStream(ANInstanceData,.doc)
	q:($$$ISERR(sc)) result
	s sectionId = $p(ACode,"_",1)
	s compositeId = $p(ACode,"_",2)
	s simple = $p(ACode,"_",3)
	s type = ..GetUnitType(simple)
	s sc = doc.EvaluateExpression("/NInstanceData/ScatterData/Component/Section[Code/@Code='"_sectionId_"']/Composite[Code/@Code='"_compositeId_"']/SubItems/MIString[Code/@Code='"_simple_"']/Value","text()",.res)		
    q:($$$ISERR(sc)||res.Count()<=0) result
	s result = res.GetAt(1).Value	
	q result
}

/// Desc：返回对应单元类型
ClassMethod GetUnitType(AUnit As %String) As %String
{
	s type = ""
	q:(AUnit = "") type
	s word = $e(AUnit,1,1) 
	if (word = "L")
	{
		s type = "MIString"
	}
	elseif (word = "N")
	{
		s type = "MINumber"
	}
	elseif (word = "D")
	{
		s type = "MIDateTime"
	}
	elseif (word = "O")
	{
		s type = "MIMonoChoice"		
	}
	elseif (word = "I")
	{
		s type = "MIDictionary"
	}
	elseif (word = "M")
	{
		if ($e(AUnit,1,3) '= "MCC")
		{
			s type = "MIMultiChoice"
		}
		else
		{
			s type = "MIConcept"
		}
	}
	q type
}

/// 取节点属性
ClassMethod getPropertyValue(AString As %String, AName As %String, ASeparator As %String) As %String
{
	s result = ""
	q:(AString = "")||(AName = "") result
	s count = $l(AString,ASeparator)
	for i=1:1:count
	{
		s temp = $p(AString,ASeparator,i)
		s code = $tr($p(temp,":",1)," ","")
		if (code = AName)
		{
			s result = $tr($p(temp,":",2)," ","")
			q
		}
	}
	q result
}

/// Desc:取节点值
ClassMethod GetChar(props As %String, revision As %String, ByRef reader, ByRef Stream)
{
	d:((props [ "text-position:superscript")||(revision["text-position:superscript")) Stream.Write("<sup>")
	d:((props [ "text-position:subscript")||(revision["text-position:subscript")) Stream.Write("<sub>")
    while reader.Read()
    {
	    q:(reader.NodeType = "endelement")
	    d:(reader.NodeType = "chars") Stream.Write(reader.Value)
	}
	d:((props [ "text-position:superscript")||(revision["text-position:superscript")) Stream.Write("</sup>")
	d:((props [ "text-position:subscript")||(revision["text-position:subscript")) Stream.Write("</sub>")
}

/// Desc:取表格型xml
/// d ##Class(EMRservice.Export.CDRXml).GetGirdXML("d:\gird.xml")
ClassMethod GetGirdXML(ANInstanceData As %GlobalBinaryStream, AMetaData As %GlobalBinaryStream, ATitle As %String) As %GlobalBinaryStream
{
	s ResStream = ##class(%GlobalBinaryStream).%New()
	q:(ANInstanceData.Size = 0)||(AMetaData.Size = 0) ResStream
	d ResStream.Write("<CDR>")
	d ResStream.Write("<name>"_ATitle_"</name>")
	d ResStream.Write("<section Code = """" DispalyName="""">")
    s sc = ##class(%XML.XPATH.Document).CreateFromStream(ANInstanceData,.doc)
    q:($$$ISERR(sc)) ResStream	
    s sc = doc.EvaluateExpression("/NInstanceData/iEditor/Sheets","count(Sheet)",.sheets)
    q:($$$ISERR(sc)) ResStream
    s scount = sheets.GetAt(1).Value
    for i=1:1:scount
    {
	   s sc = doc.EvaluateExpression("/NInstanceData/iEditor/Sheets/Sheet["_i_"]","Cell/@Row",.rows) 
	   continue:($$$ISERR(sc))
	   d ResStream.Write("<sheet index="""_i_""">")
	   s arrayRow = ##Class(EMRservice.Export.CDRXml).SortOrder(rows)
	   s keyRow = ""
	   for
	   {
		   s row = arrayRow.GetNext(.keyRow)
		   q:(keyRow = "")
		   s sc = doc.EvaluateExpression("/NInstanceData/iEditor/Sheets/Sheet["_i_"]/Cell[@Row='"_row_"']","@Col",.cols)		   
	   	   continue:($$$ISERR(sc))
	   	   d ResStream.Write("<row index="""_row_""">")
	   	   s arrayCol = ##Class(EMRservice.Export.CDRXml).SortOrder(cols)
	   	   s keyCol = ""
	   	   for
	   	   {
		   	   s col = arrayCol.GetNext(.keyCol)
		   	   q:(keyCol = "")
		   	   s sc = doc.EvaluateExpression("/NInstanceData/iEditor/Sheets/Sheet["_i_"]/Cell[@Row='"_row_"'][@Col='"_col_"']","Object",.res)
		   	   s node = res.GetAt(1)
    		   if (node.Type=2)
    		   {
					d node.Read()
					q:(node.NodeType '="element")
					d node.MoveToAttributeName("Type")
					s type = node.Value
					d node.MoveToAttributeName("Code")
					s code = node.Value
					d node.MoveToAttributeName("Value")
					s char = node.Value
					if (type = 2)&&(code '= "")
					{
						d ResStream.Write("<field ")
						s path = "V001_V002_"_code
						s attr = ..GetFieldVlaue(path,AMetaData)
						s key = ""
						for
						{
							s value = attr.GetNext(.key)
							q:(key = "")
							d ResStream.Write(" "_key_"="""_value_""" ")
						} 
						d ResStream.Write(">"_char_"</field>")		
					}
					else
					{
						d ResStream.Write("<text>"_char_"</text>")
					}	   
	    	   }
		   }
		   d ResStream.Write("</row>")
	   }
	   d ResStream.Write("</sheet>")
    }
	d ResStream.Write("</section>") 
	d ResStream.Write("</CDR>")
    q ResStream
}

/// d ##Class(EMRservice.Export.CDRXml).SortOrder(rows)
ClassMethod SortOrder(AContent As %ListOfObjects(CLASSNAME="%XML.XPATH.Result")) As %ArrayOfDataTypes
{
	s result = ##Class(%ArrayOfDataTypes).%New()
	for i=1:1:AContent.Count()
	{
		s tResult = AContent.GetAt(i)
		continue:(tResult.Value = "")
		d result.SetAt(tResult.Value,tResult.Value)
	}
	q result
}

/// Desc:	返回患者就诊病历目录
/// Input: 	AEpisodeID 就诊号
/// Debug: 	d ##Class(EMRservice.Export.CDRXml).GetInstanceIDs(112)
ClassMethod GetInstanceIDs(AEpisodeID As %String) As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()
	q:(AEpisodeID = "") result
	s AStatus = "Save"
	d result.Write("<InstanceIDs>")
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," "_$zcvt(AStatus,"U"),date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," "_$zcvt(AStatus,"U"),date,time))
			q:(time = "")
			s parentId = ""
			for
			{
				s parentId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," "_$zcvt(AStatus,"U"),date,time,parentId))
				q:(parentId = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," "_$zcvt(AStatus,"U"),date,time,parentId,subId))
					q:(subId = "")
					s instanceId = parentId_"||"_subId
					d result.Write("<InstanceID>"_instanceId_"</InstanceID>")
				}
			}
		}
	}
	d result.Write("</InstanceIDs>")
	q result
}

}
