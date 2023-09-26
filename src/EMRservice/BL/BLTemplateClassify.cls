Class EMRservice.BL.BLTemplateClassify Extends (%RegisteredObject, %XML.Adaptor)
{

/// 返回Json格式
/// w ##Class(EMRservice.BL.BLTemplateClassify).GetTemplateClassify("CTLOC251")
ClassMethod GetTemplateClassify(ctloc As %String) As %String
{
		s parentID=$zcvt(ctloc,"U")
		s ret=""
		s id=""
		for{
			s id=$O(^DHCEMRM.TemplateClassifyI("IdxParentID", " "_parentID, id))
			q:(id="")
			s obj=##Class(EMRmeta.TemplateClassify).%OpenId(id)
			s child = "["_..GetTemplateClassify(id)_"]"
			s docid=""_obj.DocID
		    s item = "{""id"":"""_obj.%Id()_""",""text"":"""_obj.Name_""",""parentID"":"""_obj.ParentID_""",""docid"":"""_docid_""",""children"":"_child_"}"
		    if (ret="") { s ret = item}
		    else { s ret=ret_","_item}
		}
		q ret
}

/// 过滤掉了空文件夹节点
/// w ##Class(EMRservice.BL.BLTemplateClassify).GetTemplateClassifyTree("CTLOC251")
ClassMethod GetTemplateClassifyTree(ctloc As %String, tmpLst As %ArrayOfDataTypes) As %Stream
{
	s parentID=$zcvt(ctloc,"U")
	s ret = ##Class(%GlobalCharacterStream).%New()
	s child = ##Class(%GlobalCharacterStream).%New()
	s item = ##Class(%GlobalCharacterStream).%New()
	s id=""
	for{
		s id=$O(^DHCEMRM.TemplateClassifyI("IdxParentID", " "_parentID, id))
		q:(id="")
		s obj=##Class(EMRmeta.TemplateClassify).%OpenId(id)
		s child = ..GetTemplateClassifyTree(id,.tmpLst)
		s docid=""_obj.DocID
		if (child.Size = 0) & (""=docid) continue
		if (tmpLst'="") & (docid'="")
		{
			s key=0
			while(1)
			{
				s key=tmpLst.Next(key)
				q:(key="")
				
				s tmp=tmpLst.GetAt(key)
				s tmp=$p(tmp,"^",1)
				q:(tmp=docid)
			}
			if ((key="")||(""=tmpLst.GetAt(key))) 
			{
				 continue 
			}
			else 
			{
				 d tmpLst.RemoveAt(key) 
			}
		}
		if (child.Size > 0)
		{
			if (item.Size > 0)
			{
				d item.Write(",")
				d item.Write("{""id"":"""_docid_""",""text"":"""_obj.Name_""",""state"":""closed"",""children"":[")
				d item.CopyFrom(child)
				d item.Write("]}")
			}
			else
			{
				d item.Write("{""id"":"""_docid_""",""text"":"""_obj.Name_""",""state"":""closed"",""children"":[")
				d item.CopyFrom(child)
				d item.Write("]}")
			}
		}
		else
		{
			s FPinyin = ##class(web.DHCINSUPort).GetCNCODE($tr(obj.Name," ",""),4,"")
			s tmplNode = "{""id"":"""_docid_""",""text"":"""_obj.Name_""",""attributes"":{""py"":"""_FPinyin_"""}}"
			if (item.Size > 0)
			{
				d item.Write(",")
				d item.Write(tmplNode)
			}
			else
			{
				d item.Write(tmplNode)	
			}
		}
		}
		if (ret.Size = 0) { d ret.CopyFrom(item)}
		else { 
		d ret.Write(",")
		d ret.CopyFrom(item)
	}
	q ret
}

ClassMethod Add(name As %String, parentID As %String, DocID As %String) As %String
{
		s obj=##Class(EMRmeta.TemplateClassify).%New()
		s obj.Name=name
		s obj.ParentID=parentID
		s obj.DocID=DocID
		d obj.%Save()
		q obj.%Id()
}

/// 只能修改名字
ClassMethod Modify(id As %String, name As %String)
{
		s obj=##Class(EMRmeta.TemplateClassify).%OpenId(id)
		s obj.Name=name
		d obj.%Save()
		//q obj.%Id()
}

ClassMethod Remove(id As %String)
{
		d ##Class(EMRmeta.TemplateClassify).%DeleteId(id)
}

/// d ##Class(EMRservice.BL.BLTemplateClassify).test()
ClassMethod test()
{
	s tmpDeptArray=##class(%ArrayOfDataTypes).%New()
	d ##Class(EMRservice.BL.BLOPClientCategory).GetTempCateJson("251","Running","9857645","2079", .tmpDeptArray)
	/*
	//d tmpDeptArray.SetAt("var", "89")
 	w tmpDeptArray.GetAt(202),!
 	d tmpDeptArray.RemoveAt(202)
 	w "RemoveAt"_tmpDeptArray.GetAt(202),!
 	if ("" = tmpDeptArray.GetAt(1)) { w "tmpDeptArray.GetAt(1)" }
 	*/
 	w ..GetTemplateClassifyTree("CTLOC251", .tmpDeptArray),!
 	w "Count:"_tmpDeptArray.Count(),!
}

}
