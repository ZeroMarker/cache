Class EPRservice.Quality.GetStructResult Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s Action = $Get(%request.Data("action",1),"")
	d ..GetStructJson(Action)
	Quit $$$OK
}

/// add by yhy
/// 2016-04-05
/// d ##class(EPRservice.Quality.GetStructResult).GetStructJson()
ClassMethod GetStructJson(Action As %String)
{
	s json = "["
	s isFirstNode = 1
	s TotalCount = 0
	s StructID = ""
	s InpStruct = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("InpStruct")
	s OutStruct = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("OutStruct")
	s ^yhy("0")=Action
	for 
	{
		s:Action'="O" StructID = $O(^DHCEPRM.QualityStructI("IdxParentId"," "_InpStruct,StructID))
		s:Action="O" StructID = $O(^DHCEPRM.QualityStructI("IdxParentId"," "_OutStruct,StructID))
		q:StructID=""
		// 过滤掉一些手工评分用不到的质控结构
		//continue:((StructID=389)||(StructID=391)||(StructID=392))
		s ObjStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
		s IsActive = ObjStruct.IsActive
		continue:(IsActive="N")
		s StructName = ..GetStructByStructID(StructID)
		
		if (isFirstNode = 0 ) {s json = json_","}
		s json = json_"{StructID:'"_StructID_"',"
		s json = json_"StructName:'"_StructName_"'}"
		s isFirstNode = 0
 		s TotalCount = TotalCount+1
	}
	s json = json_"]"
	w "{"
    w "TotalCount:'"_TotalCount_"'"
    w ",data:"_json_"}"
}

/// add by  yhy
/// 2017-06-11
ClassMethod GetStructByStructID(AStructID As %String) As %String
{
	q:AStructID="" ""
	s StrcutName = ""
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	if (IsBSQualityEnable="Y")
	{
		s objStruct = $g(^CT.MA.QC.QualityStructD(AStructID))
		q:(objStruct = "") ""
	    s StructName = $list(objStruct,2)
	
	}
	else
	{
		s objStruct = $g(^DHCEPRM.QualityStructD(AStructID))
		q:(objStruct = "") ""
	    s StructName = $list(objStruct,1)
	}
	
	q StructName
}

}
