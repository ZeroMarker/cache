Import sqluser

/// 就诊原因(住院理由)
Class CHSS.PACAdmReason Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// SELECT REA_Rowid,REA_Code,REA_Desc FROM PAC_AdmReason

Query SelData() As %SQLQuery(CONTAINID = 1)
{
  SELECT * FROM PAC_AdmReason
}

/// 修改一条记录
ClassMethod Upd(id, code, desc, otherData) As %String
{
 q:##class(User.PACAdmReason).%ExistsId(id)=0 ""
	s obj=##class(User.PACAdmReason).%OpenId(id)
	//
	s nationalCode=$P(otherData,"^",1)
	s dateFrom=$P(otherData,"^",2)
	s dateTo=$P(otherData,"^",3)
	s ageFrom=$P(otherData,"^",4)
	s ageTo=$P(otherData,"^",5)
	s ageType=$P(otherData,"^",6)
 s age1From=$P(otherData,"^",7)
 s age1To=$P(otherData,"^",8)
 s age1Type=$P(otherData,"^",9)
 i dateFrom'="" s dateFrom=$zdh(dateFrom,3)
 i dateTo'="" s dateTo=$zdh(dateTo,3)
 
 //
	s obj.REACode=code
	s obj.READesc=desc
	s obj.REANationalCode=nationalCode
	s obj.READateFrom=dateFrom
	s obj.READateTo=dateTo
	s obj.REAAgeFrom=ageFrom
	s obj.REAAgeTo=ageTo
	s obj.REAAgeType=ageType
	s obj.REAAge1From=$g(age1From)
	s obj.REAAge1To=$g(age1To)
	s obj.REAAge1Type=$g(age1Type)
	//
	s status=obj.%Save()
	If $$$ISERR(status) q -1
	q 0
}

/// 删除
ClassMethod Del(id) As %String
{
	&sql(delete from PAC_AdmReason where REA_Rowid=:id)
	q SQLCODE
}

/// 插入一条记录到 PAC_AdmReason
ClassMethod Ins(code, desc, otherData = "") As %String
{
	q:code="" ""
	q:desc="" ""
	s nationalCode=$P(otherData,"^",1)
	s dateFrom=$P(otherData,"^",2)
	s dateTo=$P(otherData,"^",3)
	s ageFrom=$P(otherData,"^",4)
	s ageTo=$P(otherData,"^",5)
	s ageType=$P(otherData,"^",6)
 s age1From=$P(otherData,"^",7)
 s age1To=$P(otherData,"^",8)
 s age1Type=$P(otherData,"^",9)
	
	i dateFrom'="" s dateFrom=$zdh(dateFrom,3)
	i dateTo'="" s dateTo=$zdh(dateTo,3)
	
 //	&sql(insert into PAC_AdmReason(REA_Code,REA_Desc,) values(:code,:desc) )
	&sql(insert into PAC_AdmReason(
 REA_Code,
 REA_Desc,
 REA_NationalCode,
 REA_DateFrom,
 REA_DateTo,
 REA_AgeFrom,
 REA_AgeTo,
 REA_AgeType,
 REA_Age1From,
 REA_Age1To,
 REA_Age1Type)
 values (
  :code,
  :desc,
  :nationalCode,
  nvl(:dateFrom,null),
  nvl(:dateTo,null),
  :ageFrom,
  :ageTo,
  :ageType,
  nvl(:age1From,null),
  nvl(:age1To,null),
  :age1Type 
  )
 )
  
 q SQLCODE
}

ClassMethod GetJsonData() As %String
{
	s rs=##class(%ResultSet).%New()
	s rs.ClassName="CHSS.PACAdmReason"
	s rs.QueryName="SelData"
	d rs.Execute()
	s mess="",count=0
	While (rs.Next())
	{
	 s code=rs.Get("REA_Code")
	 s desc=rs.Get("REA_Desc")
		s rowid=rs.Get("REA_RowId")
		s datefrom=rs.Get("REA_DateFrom")
		i datefrom'="" s datefrom=$zd(datefrom,3)
		s dateto=rs.Get("REA_DateTo")
		i dateto'="" s dateto=$zd(dateto,3)
		s nationalcode=rs.Get("REA_NationalCode")
		s agefrom=rs.Get("REA_AgeFrom")
		s ageto=rs.Get("REA_AgeTo")
		s agetype=rs.Get("REA_AgeType")
		s age1from=rs.Get("REA_Age1From")
		s age1to=rs.Get("REA_Age1To")
		s age1type=rs.Get("REA_Age1Type")
		
		s count=count+1
		i (mess'="") s mess=mess_","
		s mess=mess_"{""id"":"_""""_rowid_""""_","_"""code"":"_""""_code_""""_","_"""desc"":"_""""_desc_""""_","
	 s mess=mess_"""datefrom"":"_""""_datefrom_""""_","_"""dateto"":"_""""_dateto_""""_","_"""nationalcode"":"_""""_nationalcode_""""_","
	 s mess=mess_"""agefrom"":"_""""_agefrom_""""_","_"""ageto"":"_""""_ageto_""""_","_"""agetype"":"_""""_agetype_""""_","
	 s mess=mess_"""age1from"":"_""""_age1from_""""_","_"""age1to"":"_""""_age1to_""""_","_"""age1type"":"_""""_age1type_""""
	 s mess=mess_"}"
	}
 s mess="["_mess_"]"
 
 s mess="{""totalCount"":"_""""_count_""""_","_"""topics"""_":"_mess_"}"
 q mess
}

}
