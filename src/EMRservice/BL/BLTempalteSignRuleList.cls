/// Desc: 		模板签名规则表Bl层 
/// Creator:	yejian
/// CreatDate:	2019-3-19
Class EMRservice.BL.BLTempalteSignRuleList Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:	yejian
/// CreatDate:  2019-3-20
/// Desc:		根据模板ID和标题获取模板规则
/// Input：		
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTempalteSignRuleList","SelectTemSignRule","1","")
Query SelectTemSignRule(aTemplateID As %String, aTitleCode As %String) As %Query(ROWSPEC = "ID:%Integer,TemplateID:%String,TitleCode:%String,TemRuleCode:%String,TemRuleDesc:%String,TemRuleValue:%String")
{
}

ClassMethod SelectTemSignRuleExecute(ByRef qHandle As %Binary, aTemplateID As %String, aTitleCode As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s arowID = ""
	for {
		s arowID = $o(^DHCEMRM.TemplateSignRuleListI("IndexTemTitle"," "_aTemplateID," "_aTitleCode,arowID))
		q:(arowID = "")	
		s objTemSign = ##Class(EMRmeta.TemplateSignRuleList).%OpenId(arowID)
		s TemplateID = objTemSign.TemplateID
		s TitleCode = objTemSign.TitleCode
		s TemRuleCode = objTemSign.TemRuleCode
		s TemRuleDesc = objTemSign.TemRuleDesc
		s TemRuleValue = objTemSign.TemRuleValue

		s Data = $lb(arowID,TemplateID,TitleCode,TemRuleCode,TemRuleDesc,TemRuleValue)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
		
	}
	q $$$OK
}

ClassMethod SelectTemSignRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectTemSignRuleExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectTemSignRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectTemSignRuleExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 添加用户模板科室
ClassMethod SaveTemplateSignRule(aETempSignRules As EMRservice.entity.ETemplateSignRuleList) As %String
{
	
	s ret = 0
	s sc = ""
	s arowID = $o(^DHCEMRM.TemplateSignRuleListI("IndexTemTitle"," "_aETempSignRules.TemplateID," "_$zcvt(aETempSignRules.TitleCode,"U"),""))
	if (arowID="")
	{
		s objTemSign = ##Class(EMRmeta.TemplateSignRuleList).%New()
		s objTemSign.TemplateID =aETempSignRules.TemplateID
		s objTemSign.TemRuleCode =aETempSignRules.TemRuleCode
		s objTemSign.TemRuleDesc =aETempSignRules.TemRuleDesc
		s objTemSign.TemRuleValue =aETempSignRules.TemRuleValue
		s objTemSign.TitleCode =aETempSignRules.TitleCode
		s sc =objTemSign.%Save()
	}
	else
	{
		s objTemSign = ##Class(EMRmeta.TemplateSignRuleList).%OpenId(arowID)
		s objTemSign.TemplateID =aETempSignRules.TemplateID
		s objTemSign.TemRuleCode =aETempSignRules.TemRuleCode
		s objTemSign.TemRuleDesc =aETempSignRules.TemRuleDesc
		s objTemSign.TemRuleValue =aETempSignRules.TemRuleValue
		s objTemSign.TitleCode =aETempSignRules.TitleCode
		s sc =objTemSign.%Save()
	}
	
	if ($$$ISOK(sc))
	{
		s ret=objTemSign.%Id()
	}

	d objTemSign.%Close()
	q ret
}

/// 删除一个数据元范畴
/// d ##Class(EMRservice.BL.BLTitles).test()
ClassMethod test() As %String [ WebMethod ]
{
	
	
	s objTemSign = ##Class(EMRservice.entity.ETemplateSignRuleList).%New()
	s objTemSign.Code =aETempSignRules.Code
	s objTemSign.SectionCode =aETempSignRules.SectionCode
	s objTemSign.CompositeCode =aETempSignRules.CompositeCode
	s objTemSign.KbBaseID =aETempSignRules.KbBaseID
	s objTemSign.KBNodeID =aETempSignRules.KBNodeID
	s objTemSign.ActiveFlag =aETempSignRules.ActiveFlag
	
	d ..SaveTemplateSignRule(objTemSign)
}

}
