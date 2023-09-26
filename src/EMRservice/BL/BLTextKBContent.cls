/// Desc:专科知识库内容
/// Creator:Candy
/// CreateDate:2018-2-28
Class EMRservice.BL.BLTextKBContent Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:      保存节点并送审
/// Input:     ACategoryID 目录ID
///            AContent 内容
/// 			   AUserCode   创建者
/// 			   Name     节点名称
/// w ##class(EMRservice.BL.BLTextKBContent).NewData("24","3333333","YS01","4444","")
ClassMethod NewData(ACategoryID As %String, AContent As %String, AUserCode As %String, AName As %String, IsModify As %String = "") As %String
{
	s result = ""
	s ID = ""
	s $ZT="ERROR"
	q:((ACategoryID = "")||(AUserCode = "")) result
	TStart
	if (IsModify = "")
	{
		s obj = ##class(EMRmeta.TextKBCategory).%New()
		s obj.IsValid = "Y"
		s obj.ParentID = ACategoryID
		s obj.Type = "leaf"
	}
	else
	{
		s obj = ##class(EMRmeta.TextKBCategory).%OpenId(ACategoryID)
	}
	
	s obj.Name = AName	
	d obj.%Save()

	s:$$$ISOK(obj) ID = obj.%Id()
	if (ID = "") {
		Trollback
		q result
	}
	s objnew = ##class(EMRmeta.TextKBCategory).%OpenId(ID)
	s objnew.Sequence = ID
    s sc = objnew.%Save()
    if ($$$ISERR(sc)) {
        Trollback
        q result
    }
	
	if (IsModify = "")
	{
		s obj2 = ##class(EMRmeta.TextKBContent).%New()
		s obj2.CategoryID = ID
		s obj2.CreateDate = $zd($P($H,",",1),3)_" "_$zt($P($H,",",2),1)
		s obj2.Status = "1"
		s obj2.AuditDate = $zd($P($H,",",1),3)_" "_$zt($P($H,",",2),1)
		s obj2.AuditID = AUserCode
		s obj2.UserID = AUserCode
	}
	else
	{
		s rowId = $o(^DHCEMRM.TextKBContentI("IdxCategoryID",ACategoryID,""))
		q:(rowId = "") result
		s obj2 = ##class(EMRmeta.TextKBContent).%OpenId(rowId)
	}
	d obj2.Content.Write(AContent)
    s sc2 = obj2.%Save()
    if ($$$ISERR(sc2)) {
        Trollback
        q result
    } else {
        s result = 1
    }
	
	Tcommit
	q result
	
ERROR
	Trollback
	q "-1"
}

/// Desc:      获取创建者信息
/// Creator:   yb
/// CreateDate:2021-6-7
/// Input:     ACategoryID 目录ID
/// /w ##class(EMRservice.BL.BLTextKBContent).GetCreateUsrInfo(17)
ClassMethod GetCreateUsrInfo(ACategoryID As %String) As %String
{
	s result = ""
	q:(ACategoryID = "") result
	s obj = ##class(EMRmeta.TextKBCategory).%OpenId(ACategoryID)
	q:(obj = "") result
	s name = obj.Name
	
	s rowId = $o(^DHCEMRM.TextKBContentI("IdxCategoryID",ACategoryID,""))
	q:(rowId = "") result
	s obj2 = ##class(EMRmeta.TextKBContent).%OpenId(rowId)
	q:(obj2 = "") result
	s createUser = obj2.UserID
	q:(createUser = "") result
	s userID = ##class(EMRservice.BL.BLPowerUser).GetUserId(createUser)
	q:(userID = "") result
	s createUserName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(userID)
	q:(createUserName = "") result
	
	s result = "{"
	s result = result_"""createUser"":"""_createUser_""","
	s result = result_"""createUserName"":"""_createUserName_""","
	s result = result_"""name"":"""_name_""""
	s result = result_"}"
	q result
}

/// Desc:      删除知识库
/// Creator:   yb
/// CreateDate:2021-6-7
/// Input:     ACategoryID 目录ID
/// /w ##class(EMRservice.BL.BLTextKBContent).GetCreateUsrInfo(17)
ClassMethod DeleteCategory(ACategoryID As %String) As %String
{
	s result = ""
	q:(ACategoryID = "") result
	s objCategory = ##class(EMRmeta.TextKBCategory).%OpenId(ACategoryID)
	q:(objCategory="") result
	s objCategory.IsValid = "N"
	s sc = objCategory.%Save()
	s:$$$ISOK(sc) result = 1
	q result
}

/// Desc:      添加知识库内容
/// Creator:   Candy
/// CreateDate:2018-2-28
/// Input:     ACategoryID 目录ID
///            AContent 内容
ClassMethod AddContent(ACategoryID As %String, AContent As %GlobalBinaryStream) As %String
{
	s result = ""
	q:(ACategoryID = "") result
	s rowId = $o(^DHCEMRM.TextKBContentI("IdxCategoryID",ACategoryID,""))
	if (rowId = "")
	{
		s obj = ##Class(EMRmeta.TextKBContent).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.TextKBContent).%OpenId(rowId)
	}
	s obj.CategoryID = ACategoryID
	d obj.Content.CopyForm(AContent)
	s sc = obj.%Save()
	s:$$$ISOK(sc) result = 1
	q result
}

/// Desc:       取病历内容
/// Creator:    Candy
/// CreateDate: 2018-3-1
/// Input:      ACategoryID
/// Debug: d ##Class(EMRservice.BL.BLTextKBContent).GetContent(4)
ClassMethod GetContent(ACategoryID As %String) As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()
	q:(ACategoryID = "") result
	
	s rowId = $o(^DHCEMRM.TextKBContentI("IdxCategoryID",ACategoryID,""))
	q:(rowId = "") result
	s obj = ##Class(EMRmeta.TextKBContent).%OpenId(rowId)
	q:(obj = "") result
    //d result.CopyFrom(obj.Content)
    while('obj.Content.AtEnd)
    {
	    s tmptxt = obj.Content.Read(1)
	    s:(tmptxt = " ") tmptxt = "&nbsp;"
	    s:(tmptxt = $c(10))||(tmptxt = $c(13)) tmptxt = "<br>"
	    d result.Write(tmptxt)
	}
	q result
}

/// Debug: d ##Class(EMRservice.BL.BLTextKBContent).InitData()
ClassMethod InitData()
{
	s obj = ##Class(EMRmeta.TextKBContent).%New()
	s obj.CategoryID = 4 
	d obj.Content.Write("1.要求有固定分类，参考嘉禾分类（鉴别诊断、诊疗计划、并发症、手术记录、辅助检查、日常病程、操作记录、诊断依据、出院小结、护理记录）2.专科知识库不和模板关联，写病历时可以引用不同分类知识库（知识库分类）3.可以引用所有信息，可以选择引用，不限制引用下面是嘉禾专科知识库应用")
	d obj.%Save()
}

}
