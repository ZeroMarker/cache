Import sqluser

/// 诊断类型
Class CHSS.MRCDiagnosType Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query SelData() As %SQLQuery(CONTAINID = 1)
{
SELECT DTYP_Rowid,DTYP_Code,DTYP_Desc FROM MRC_DiagnosType
}

/// 修改一条记录
ClassMethod Upd(id, code, desc) As %String
{
 q:##class(User.MRCDiagnosType).%ExistsId(id)=0 ""
	s obj=##class(User.MRCDiagnosType).%OpenId(id)
	s obj.DTYPCode=code
	s obj.DTYPDesc=desc
	s status=obj.%Save()
	If $$$ISERR(status) q -1
	q 0
}

/// 删除
ClassMethod Del(id) As %String
{
	&sql(delete from MRC_DiagnosType where DTYP_Rowid=:id)
	q SQLCODE
}

/// 插入一条记录到 MRC_DiagnosType
ClassMethod Ins(code, desc) As %String
{
	q:code="" ""
	q:desc="" ""
	&sql(insert into MRC_DiagnosType(DTYP_Code,DTYP_Desc) values(:code,:desc) )
	q SQLCODE
}

ClassMethod GetJsonData() As %String
{
	s rs=##class(%ResultSet).%New()
	s rs.ClassName="CHSS.MRCDiagnosType"
	s rs.QueryName="SelData"
	d rs.Execute()
	s mess="",count=0
	While (rs.Next())
	{
	 s code=rs.Get("DTYP_Code")
	 s desc=rs.Get("DTYP_Desc")
		s rowid=rs.Get("DTYP_RowId")
			
		s count=count+1
		i (mess'="") s mess=mess_","
		s mess=mess_"{""id"":"_""""_rowid_""""_","_"""code"":"_""""_code_""""_","_"""desc"":"_""""_desc_""""_"}"
	}
 s mess="["_mess_"]"
 
 s mess="{""totalCount"":"_""""_count_""""_","_"""topics"""_":"_mess_"}"
 q mess
}

}
