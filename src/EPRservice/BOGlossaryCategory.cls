/// 术语范畴服务类
Class EPRservice.BOGlossaryCategory Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// Parameter LOCATION = "http://10.10.141.189/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "GlossaryCategoryInfo";

/// 创建一个术语范畴
ClassMethod CreateGlossaryCategory(aEGlossaryCategory As EPRservice.entity.EGlossaryCategory) As %String [ WebMethod ]
{
	/// b "s"
	set objGlossaryCategory=##class(EPRmeta.GlossaryCategory).%New()
	quit:(objGlossaryCategory="") ""
	
	set objGlossaryCategory.Name=aEGlossaryCategory.Name
	set objGlossaryCategory.Description=aEGlossaryCategory.Description
	set objGlossaryCategory.ParentID=aEGlossaryCategory.ParentID
	
	///前端的 0 传递过来会成为 "" 
	///set objGlossaryCategory.ResChildCount=aEGlossaryCategory.ResChildCount
	set objGlossaryCategory.ResChildCount = 0
	set objGlossaryCategory.InternalID = aEGlossaryCategory.InternalID
	//set objGlossaryCategory.TemplateCategroyID = aEGlossaryCategory.TemplateCategroyID
	s strRes = ..SetGlossaryTemplateID(aEGlossaryCategory.TemplateCategroyID,aEGlossaryCategory.InternalID)
	do objGlossaryCategory.%Save()
	quit objGlossaryCategory.%Id()
}

/// 删除一个术语范畴
ClassMethod DeleteGlossaryCategory(aGlossaryCategoryId As %String) As %Boolean [ WebMethod ]
{
	quit ##class(EPRmeta.GlossaryCategory).%DeleteId(aGlossaryCategoryId)
}

/// 更新一个术语范畴
ClassMethod UpdateGlossaryCategory(aEGlossaryCategory As EPRservice.entity.EGlossaryCategory) As %Boolean [ WebMethod ]
{
	set objGlossaryCategory=##class(EPRmeta.GlossaryCategory).%OpenId(aEGlossaryCategory.ID)
	quit:(objGlossaryCategory="") "0"
	
	set objGlossaryCategory.Name=aEGlossaryCategory.Name
	set objGlossaryCategory.Description=aEGlossaryCategory.Description
	set objGlossaryCategory.ParentID=aEGlossaryCategory.ParentID
	set objGlossaryCategory.ResChildCount=aEGlossaryCategory.ResChildCount
	set objGlossaryCategory.InternalID=aEGlossaryCategory.InternalID
	;set objGlossaryCategory.TemplateCategroyID=aEGlossaryCategory.TemplateCategroyID
	s strRes = ..SetGlossaryTemplateID(aEGlossaryCategory.TemplateCategroyID,aEGlossaryCategory.InternalID)
	quit objGlossaryCategory.%Save()
}

ClassMethod SetGlossaryTemplateID(aTemplateIDs As %String, aInternalID As %String) As %String
{
	s strRes ="1"
	q:(aTemplateIDs ="")||(aInternalID ="") strRes
	&sql(DELETE FROM EPRmeta.GlossarysTemplateID WHERE InternalID = :aInternalID)
	s count = $l(aTemplateIDs,"^")
	for i=1:1:count
	{
		s strTemplateID = $p(aTemplateIDs,"^",i)
		s gtRowID = $o(^DHCEPRM.GlossarysTemplateIDI("IdxInteIDTemID"," "_aInternalID," "_strTemplateID,""))
		continue:(gtRowID '= "")
		s objGlossaryTem = ##Class(EPRmeta.GlossarysTemplateID).%New()
		s objGlossaryTem.InternalID = aInternalID
		s objGlossaryTem.TemplateID = strTemplateID
		s sc =objGlossaryTem.%Save()
		if ('sc)
		{
			s strRes ="-1"
		}
	}
	q strRes
}

/// 查找术语范畴
ClassMethod SelectAllGlossaryCategory() As EPRservice.dataset.EGlossaryCategoryDataset [ WebMethod ]
{
	/// New result
	set result=##class(EPRservice.dataset.EGlossaryCategoryDataset).%New()
	quit result
}

/// 查找术语范畴
ClassMethod SelectGlossaryCategoryByID(aGlossaryCategoryId As %String) As EPRservice.entity.EGlossaryCategory [ WebMethod ]
{
	set objGlossaryCategory=##class(EPRmeta.GlossaryCategory).%OpenId(aGlossaryCategoryId)
	quit:(objGlossaryCategory="") ""
	
	set objEGlossaryCategory=##class(EPRservice.entity.EGlossaryCategory).%New()
	quit:(objEGlossaryCategory="") ""
	
	set objEGlossaryCategory.ID=objGlossaryCategory.%Id()
	set objEGlossaryCategory.Name=objGlossaryCategory.Name
	set objEGlossaryCategory.Description=objGlossaryCategory.Description
	set objEGlossaryCategory.ParentID=objGlossaryCategory.ParentID
	set objEGlossaryCategory.ResChildCount=objGlossaryCategory.ResChildCount
	set objEGlossaryCategory.InternalID=objGlossaryCategory.InternalID
	//set objEGlossaryCategory.TemplateCategroyID=objGlossaryCategory.TemplateCategroyID
	s TemplateCategroyID = ""
	s sub = ""
	for {
		s sub = $o(^DHCEPRM.GlossarysTemplateIDI("IdxInternalID"," "_objGlossaryCategory.InternalID,sub))
		q:(sub = "")
		s objGlossaryTem =##Class(EPRmeta.GlossarysTemplateID).%OpenId(sub)
		q:(objGlossaryTem ="")
		if (TemplateCategroyID="")
		{
			s TemplateCategroyID =objGlossaryTem.TemplateID 
		}
		else
		{
			s TemplateCategroyID = TemplateCategroyID_"^"_objGlossaryTem.TemplateID 
		}
	}
	set objEGlossaryCategory.TemplateCategroyID= TemplateCategroyID
	quit objEGlossaryCategory
}

/// w ##Class(EPRservice.BOGlossaryCategory).CheckInternalID("55","55")
ClassMethod CheckInternalID(AGlossaryCategoryID As %String, AInternalID As %String) As %String [ WebMethod ]
{
	q:(AInternalID="")||(AInternalID=$C(0)) "内部标识符不能为空"
	 
	s id = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_AInternalID,""))
	if (id = "")
	{
		//内部标识符不存在, OK
		q ""
	}
	else
	{
		if (id = AGlossaryCategoryID)
		{
			//内部标识符存在且属于当前术语范畴, OK
			q ""
		}
		else
		{
			s obj = ##Class(EPRmeta.GlossaryCategory).%OpenId(id)
			q "内部标识符与["_obj.Name_"]冲突!"
		}
	}
}

/// w ##Class(EPRservice.BOGlossaryCategory).MoveGlossaryTemIDs()
ClassMethod MoveGlossaryTemIDs() As %String
{
	
	s rowID = ""
	s intcount = 0
	for {
		s rowID = $o(^DHCEPRM.GlossaryCategoryD(rowID))
		q:(rowID = "")	
	
		s objGlossaryCat = ##Class(EPRmeta.GlossaryCategory).%OpenId(rowID)
		q:(objGlossaryCat="")
		continue:(objGlossaryCat.TemplateCategroyID ="")
		s aInternalID = objGlossaryCat.InternalID
		s aTemplateIDs = objGlossaryCat.TemplateCategroyID
				
		s count = $l(aTemplateIDs,"^")
		for i=1:1:count
		{
			s strTemplateID = $p(aTemplateIDs,"^",i)
			if (i=1)
			{
				s ATemplateID =""
				for {
					s ATemplateID = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_strTemplateID,ATemplateID))
					q:(ATemplateID="")
					s gtRowID = $o(^DHCEPRM.GlossarysTemplateIDI("IdxInteIDTemID"," "_aInternalID," "_ATemplateID,""))
					continue:(gtRowID '= "")
					s objGlossaryTem = ##Class(EPRmeta.GlossarysTemplateID).%New()
					s objGlossaryTem.InternalID = aInternalID
					s objGlossaryTem.TemplateID = ATemplateID
					s sc =objGlossaryTem.%Save()
					s intcount =intcount+1
				}
			}
			else
			{
				s gtRowID = $o(^DHCEPRM.GlossarysTemplateIDI("IdxInteIDTemID"," "_aInternalID," "_strTemplateID,""))
				continue:(gtRowID '= "")
				s objGlossaryTem = ##Class(EPRmeta.GlossarysTemplateID).%New()
				s objGlossaryTem.InternalID = aInternalID
				s objGlossaryTem.TemplateID = strTemplateID
				s sc =objGlossaryTem.%Save()
				s intcount =intcount+1
			}
		}
	}
	q "转换绑定模板ID数: "_intcount
}

}
