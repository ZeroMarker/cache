Import sqluser

/// 证件类型
Class CHSS.PACCardType Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query SelData() As %SQLQuery(CONTAINID = 1)
{
SELECT CARD_Rowid,CARD_Code,CARD_Desc FROM PAC_CardType
}

/// 修改一条记录
ClassMethod Upd(id, code, desc) As %String
{
 q:##class(User.PACCardType).%ExistsId(id)=0 ""
	s obj=##class(User.PACCardType).%OpenId(id)
	s obj.CARDCode=code
	s obj.CARDDesc=desc
	s status=obj.%Save()
	If $$$ISERR(status) q -1
	q 0
}

/// 删除
ClassMethod Del(id) As %String
{
	&sql(delete from PAC_CardType where CARD_Rowid=:id)
	q SQLCODE
}

/// 插入一条记录到 PAC_CardType
ClassMethod Ins(code, desc) As %String
{
	q:code="" ""
	q:desc="" ""
	&sql(insert into PAC_CardType(CARD_Code,CARD_Desc) values(:code,:desc) )
	q SQLCODE
}

ClassMethod GetJsonData() As %String
{
	s rs=##class(%ResultSet).%New()
	s rs.ClassName="CHSS.PACCardType"
	s rs.QueryName="SelData"
	d rs.Execute()
	s mess="",count=0
	While (rs.Next())
	{
	 s code=rs.Get("CARD_Code")
	 s desc=rs.Get("CARD_Desc")
		s rowid=rs.Get("CARD_RowId")
			
		s count=count+1
		i (mess'="") s mess=mess_","
		s mess=mess_"{""id"":"_""""_rowid_""""_","_"""code"":"_""""_code_""""_","_"""desc"":"_""""_desc_""""_"}"
	}
 s mess="["_mess_"]"
 
 s mess="{""totalCount"":"_""""_count_""""_","_"""topics"""_":"_mess_"}"
 q mess
}

}
