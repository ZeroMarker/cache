Class EPRservice.Quality.Ajax.GetStructResult Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s Action = $Get(%request.Data("Action",1),"")
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	if (IsBSQualityEnable'="Y")
	{
		w ..GetStructJson(Action)
	}
	
	else
	{
		w ..GetStructJsonNew(Action)
	}
	Quit $$$OK
}

/// add by yhy
/// 2016-04-05
/// d ##class(EPRservice.Quality.GetStructResult).GetStructJson()
ClassMethod GetStructJson(Action As %String)
{

	s json = ""
	s TotalCount = 0
	s StructID = ""
	s:(Action="CQC") Action="D"   //终末交叉质控使用终末质控手工评分目录
	s:(Action="IA") Action="A"
	s InpStruct = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("InpStruct")
	s OutStruct = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("OutStruct")
                s SYStruct = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("SYStruct")
	//s ^yhy("0")=Action
	for 
	{
		s:(Action="A")||(Action["D") StructID = $O(^DHCEPRM.QualityStructI("IdxParentId"," "_InpStruct,StructID))
		s:Action="O" StructID = $O(^DHCEPRM.QualityStructI("IdxParentId"," "_OutStruct,StructID))
		s:Action["S" StructID = $O(^DHCEPRM.QualityStructI("IdxParentId"," "_SYStruct,StructID))
		q:StructID=""
		// 过滤掉一些手工评分用不到的质控结构
		//continue:((StructID=389)||(StructID=391)||(StructID=392))
		s ObjStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
		s IsActive = ObjStruct.IsActive
		continue:(IsActive="N")
		s StructName = ..GetStructByStructID(StructID)
		
		s:(TotalCount '=0) json =json_","
		s json = json_"{"
		s json = json_"""StructID"":"""_StructID_""","
		s json = json_"""StructName"":"""_StructName_"""}"
 		s TotalCount = TotalCount+1
	}
	s json = "["_json_"]"
	q json
}

/// add by yhy
/// 2016-04-05
/// d ##class(EPRservice.Quality.GetStructResult).GetStructJson()
ClassMethod GetStructJsonNew(Action As %String)
{

	s json = ""
	s TotalCount = 0
	s StructID = ""
	s:(Action="CQC") Action="D"   //终末交叉质控使用终末质控手工评分目录
	s InpStruct = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCodeNew("InpStruct")
	s OutStruct = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCodeNew("OutStruct")
    s SYStruct = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCodeNew("SYStruct")
	//s ^yhy("0")=Action
	for 
	{
		s:(Action="A")||(Action["D") StructID = $O(^CT.MA.QC.QualityStructI("IdxParentId"," "_InpStruct,StructID))
		s:Action="O" StructID = $O(^CT.MA.QC.QualityStructI("IdxParentId"," "_OutStruct,StructID))
		s:Action["S" StructID = $O(^CT.MA.QC.QualityStructI("IdxParentId"," "_SYStruct,StructID))
		q:StructID=""
		// 过滤掉一些手工评分用不到的质控结构
		//continue:((StructID=389)||(StructID=391)||(StructID=392))
		s ObjStruct = ##Class(CT.MA.QC.QualityStruct).%OpenId(StructID)
		s IsActive =ObjStruct.IsActive
		continue:(IsActive="N")
		s StructName = ..GetStructByStructID(StructID)
		
		s:(TotalCount '=0) json =json_","
		s json = json_"{"
		s json = json_"""StructID"":"""_StructID_""","
		s json = json_"""StructName"":"""_StructName_"""}"
 		s TotalCount = TotalCount+1
	}
	s json = "["_json_"]"
	q json
}

/// add by  yhy
/// 2017-06-11
ClassMethod GetStructByStructID(AStructID As %String) As %String
{
	q:AStructID="" ""
	s StrcutName = ""
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	if (IsBSQualityEnable'="Y")
	{
		s objStruct = $g(^DHCEPRM.QualityStructD(AStructID))
		q:(objStruct = "") ""
		s StructName = $list(objStruct,1)
	}
	else
	{
		s objStruct = $g(^CT.MA.QC.QualityStructD(AStructID))
		q:(objStruct = "") ""
		s StructName = $list(objStruct,2)
	}
	
	q StructName
}

}
