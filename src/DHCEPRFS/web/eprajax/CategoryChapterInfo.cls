Class DHCEPRFS.web.eprajax.CategoryChapterInfo Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
    s result = ..GetCategory()
    w result
	Quit $$$OK
}

/// Creator:Candy
/// CreateDate:2013-05-07
/// Desc:获得所有目录
/// Debug：w ##Class(DHCEPRFS.web.eprajax.CategoryChapterInfo).GetCategory()
ClassMethod GetCategory() As %String
{
	s result = ""
	s dt = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMRItem:GetAll")
	d dt.Execute()
	While (dt.Next()) {
		s result =result_dt.Data("MRItemID")_"*"_dt.Data("Description")_"@"
	}
	q result
}

}
