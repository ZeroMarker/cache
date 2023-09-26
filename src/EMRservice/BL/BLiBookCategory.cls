Class EMRservice.BL.BLiBookCategory Extends %RegisteredObject
{

/// w ##class(EMRservice.BL.BLiBookCategory).CreateiBookCategory("病例", "病例", 0)
ClassMethod CreateiBookCategory(ACategoryName, ACategoryDesc, AParent) As %String
{
	q:(ACategoryName = "") "0"
	s:(AParent = "") AParent = 0
	s iBCategoryOBJ = ##class(EMRmeta.Repository.iBookCategory).%New()
	s iBCategoryOBJ.CategoryName = ACategoryName
	s iBCategoryOBJ.Description = ACategoryDesc
	s iBCategoryOBJ.ParentID = AParent
	s iBCategoryOBJ.ResChildCount = 0
	s sc=iBCategoryOBJ.%Save()
	q:$$$ISERR(sc) 0
	//若非根目录下，则父节点的孩子数+1
	if (AParent '= 0){
		s ParentOBJ = ##Class(EMRmeta.Repository.iBookCategory).%OpenId(AParent)
		s ParentOBJ.ResChildCount = ParentOBJ.ResChildCount+1
		s sc=ParentOBJ.%Save()
		q:$$$ISERR(sc) 0
	}
	q iBCategoryOBJ.%Id()
}

/// w ##class(EMRservice.BL.BLiBookCategory).DeleteiBookCategory("")
ClassMethod DeleteiBookCategory(ACategoryID) As %String
{
	//入参为空不能删，前6个缺省目录不能删除
	q:(ACategoryID = "")||(ACategoryID < 7) "0"
	s iBCategoryOBJ = ##Class(EMRmeta.Repository.iBookCategory).%OpenId(ACategoryID)
	//找不到该条记录或节点仍有孩子不能删除
	q:(iBCategoryOBJ = "")||(iBCategoryOBJ.ResChildCount > 0) "0"
	s parentID = iBCategoryOBJ.ParentID
	//根目录下直接删除目录节点
	if (parentID = 0){
		s sc=##Class(EMRmeta.Repository.iBookCategory).%DeleteId(ACategoryID)
		q:$$$ISERR(sc) 0
	}
	//非根目录的情况，父节点的孩子数量-1
	else{
		s ParentOBJ = ##Class(EMRmeta.Repository.iBookCategory).%OpenId(parentID)
		s ParentOBJ.ResChildCount = ParentOBJ.ResChildCount - 1
		s sc=ParentOBJ.%Save()
		q:$$$ISERR(sc) 0
		s sc=##Class(EMRmeta.Repository.iBookCategory).%DeleteId(ACategoryID)
		q:$$$ISERR(sc) 0
		
	}
	q "1"
}

/// 添加目录主逻辑
/// d ##class(EMRservice.BL.BLiBookCategory).AddCategory("test2", "测试病例", 6, "359^6^29^192.168.1.63")
ClassMethod AddCategory(ACategoryName, ACategoryDesc, AParent, AUserParam)
{
	s UserID = $p(AUserParam,"^",1)
	s UserLocID = $p(AUserParam,"^",2)
	s SSGroupID = $p(AUserParam,"^",3)
	s IPAdress = $p(AUserParam,"^",4)
	TS
	//添加目录
	s CategoryID = ..CreateiBookCategory(ACategoryName, ACategoryDesc, AParent)
	TRO:(CategoryID = "")
	q:(CategoryID = "") ""
	//配置科室关联
	s RestrictionID = ##class(EMRservice.BL.BLiBookLink).AddCateRestriction(CategoryID, UserLocID)
	TRO:(RestrictionID = "")
	q:(RestrictionID = "") ""
	//操作日志
	s LogID = ##class(EMRservice.BL.BLiBookLogs).AddLog("ADDDIR", UserID, UserLocID, SSGroupID, IPAdress, "CG"_CategoryID)
	TRO:(LogID = 0)
	q:(LogID = 0) ""
	TC
	q "100_CG"_CategoryID
}

/// 删除目录主逻辑
/// d ##class(EMRservice.BL.BLiBookCategory).RemoveCategory(8, "359^6^29^192.168.1.63")
ClassMethod RemoveCategory(ACategoryID, AUserParam)
{
	s UserID = $p(AUserParam,"^",1)
	s UserLocID = $p(AUserParam,"^",2)
	s SSGroupID = $p(AUserParam,"^",3)
	s IPAdress = $p(AUserParam,"^",4)
	TS
	//删除目录
	s result = ..DeleteiBookCategory(ACategoryID)
	TRO:(result = 0)
	q:(result = 0) ""
	//删除该目录的全部科室关联
	s linkresult = ##class(EMRservice.BL.BLiBookLink).DeleteCateRestriction(ACategoryID,-1)
	TRO:(linkresult = 0)
	q:(linkresult = 0) ""
	//操作日志
	s LogID = ##class(EMRservice.BL.BLiBookLogs).AddLog("DELDIR", UserID, UserLocID, SSGroupID, IPAdress, "CG"_ACategoryID)
	TRO:(LogID = 0)
	q:(LogID = 0) ""
	TC
	q 1
}

/// 加载文献目录
/// w ##class(EMRservice.BL.BLiBookCategory).GetCategoryJson(0,6)
ClassMethod GetCategoryJson(AParentID As %String, ACTLocID As %String) As %String
{
	s json = ""
	s:(AParentID = "") AParentID = 0
	s:(ACTLocID = "") ACTLocID = 0
	s categoryID = ""
	s itemcount = 0
	for
	{
		s categoryID = $o(^DHCEMRM.iBookCategoryI("IdxParentID", " "_AParentID,categoryID))
		q:(categoryID = "")
		s iBCategoryOBJ = ##class(EMRmeta.Repository.iBookCategory).%OpenId(categoryID)
		q:(iBCategoryOBJ = "")
		//检查目录-科室关联
		q:(..CheckRestriction(categoryID, ACTLocID)="")
		s:(itemcount'=0) json = json_","
		s json = json_"{""id"":"_"""CG"_categoryID_""""
		s json = json_",""name"":"_""""_iBCategoryOBJ.CategoryName_""""
		s json = json_",""text"":"_""""_iBCategoryOBJ.Description_""""
		s json = json_",""children"":["_..GetCategoryJson(categoryID, ACTLocID)_"]}"
		s itemcount = itemcount+1
	}
	s childjson = ##class(EMRservice.BL.BLiBook).GetiBooks(AParentID)
	if ((childjson '= "")&&((json '= "")||(AParentID < 7))){
		s:(itemcount'=0) json = json_","
		s json = json_"{""id"":""CG0"_AParentID_""",""name"":""others"",""text"":""其他"",""children"":["_childjson_"]}"
	} else{
		s json = json_childjson
	}
	q json
}

ClassMethod CheckRestriction(ACategoryID, ACTLocID)
{
	s RestrictionID = ""
	s RestrictionID = $o(^DHCEMRM.iBookRestrictionI("IdxCateRule", " "_ACategoryID, " 0", ""))
	s:(RestrictionID="") RestrictionID = $o(^DHCEMRM.iBookRestrictionI("IdxCateRule", " "_ACategoryID, " "_ACTLocID, ""))
	q RestrictionID
}

/// 初始化数据
/// 添加6个初始目录，并为其配置全科室关联
/// d ##class(EMRservice.BL.BLiBookCategory).initialCategory()
ClassMethod initialCategory()
{
	d ..CreateiBookCategory("Laws", "政策法规", 0)
	d ..CreateiBookCategory("Disease", "疾病", 0)
	d ..CreateiBookCategory("Pacs", "检查", 0)
	d ..CreateiBookCategory("Medicine", "药品", 0)
	d ..CreateiBookCategory("Instruction", "指南", 0)
	d ..CreateiBookCategory("Cases", "病例", 0)
	d ##class(EMRservice.BL.BLiBookLink).AddCateRestriction(1,0)	
	d ##class(EMRservice.BL.BLiBookLink).AddCateRestriction(2,0)
	d ##class(EMRservice.BL.BLiBookLink).AddCateRestriction(3,0)
	d ##class(EMRservice.BL.BLiBookLink).AddCateRestriction(4,0)
	d ##class(EMRservice.BL.BLiBookLink).AddCateRestriction(5,0)
	d ##class(EMRservice.BL.BLiBookLink).AddCateRestriction(6,0)
}

}
