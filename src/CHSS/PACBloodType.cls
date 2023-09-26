Import sqluser

/// 血型
Class CHSS.PACBloodType Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query SelData() As %SQLQuery(CONTAINID = 1)
{
SELECT BLDT_Rowid,BLDT_Code,BLDT_Desc FROM PAC_BloodType
}

/// 修改一条记录
ClassMethod Upd(id, code, desc) As %String
{
 q:##class(User.PACBloodType).%ExistsId(id)=0 ""
	s obj=##class(User.PACBloodType).%OpenId(id)
	s obj.BLDTCode=code
	s obj.BLDTDesc=desc
	s status=obj.%Save()
	If $$$ISERR(status) q -1
	q 0
}

/// 删除
ClassMethod Del(id) As %String
{
	&sql(delete from PAC_BloodType where BLDT_Rowid=:id)
	q SQLCODE
}

/// 插入一条记录到 PAC_BloodType
ClassMethod Ins(code, desc) As %String
{
	q:code="" ""
	q:desc="" ""
	&sql(insert into PAC_BloodType(BLDT_Code,BLDT_Desc) values(:code,:desc) )
	q SQLCODE
}

ClassMethod GetJsonData() As %String
{
	s rs=##class(%ResultSet).%New()
	s rs.ClassName="CHSS.PACBloodType"
	s rs.QueryName="SelData"
	d rs.Execute()
	s mess="",count=0
	While (rs.Next())
	{
	 s code=rs.Get("BLDT_Code")
	 s desc=rs.Get("BLDT_Desc")
		s rowid=rs.Get("BLDT_RowId")
			
		s count=count+1
		i (mess'="") s mess=mess_","
		s mess=mess_"{""id"":"_""""_rowid_""""_","_"""code"":"_""""_code_""""_","_"""desc"":"_""""_desc_""""_"}"
	}
 s mess="["_mess_"]"
 
 s mess="{""totalCount"":"_""""_count_""""_","_"""topics"""_":"_mess_"}"
 q mess
}

}
