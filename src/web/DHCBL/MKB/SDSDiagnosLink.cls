/// Creator:高姗姗
/// CreatDate:20197-0-23
/// Description：结构化诊断关联表
/// Table：User.SDSDiagnosLink
Class web.DHCBL.MKB.SDSDiagnosLink Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2018-06-19
/// Description：保存修改结构化诊断关联的内容
/// Table：User.SDSDiagnosLink
/// Input：MRDiagnosRowid 医生端诊断id,SDSRowId 结构化诊断id
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosLink).SaveLink("","")
ClassMethod SaveLink(DiagnosRowid, SDSRowId, mradm) As %String
{
	
	s rowid=$o(^User.SDSDiagnosLinkI("DiagnosIndex",DiagnosRowid,0)) //结构化诊断对医生站诊断：一对多
	
	s result=""
    if (rowid=""){	    	
    	s obj=##class(User.SDSDiagnosLink).%New()
    }else{
		s obj=##class(User.SDSDiagnosLink).%OpenId(rowid)
	}
	s obj.SDSDiagnosDR=DiagnosRowid
	d:SDSRowId'="" obj.SDSStructDRSetObjectId(SDSRowId)
	d:SDSRowId="" obj.SDSStructDRSetObjectId("")
	d:mradm'="" obj.SDSAdmDRSetObjectId(mradm)
	
	s sc=obj.%Save()
	d obj.%Close()	
	
	If $$$ISOK(sc){
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"    
	}else{
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"_'}"    //返回错误信息 
	}			
	q result
}

}
