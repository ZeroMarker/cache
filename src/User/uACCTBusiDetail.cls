Class User.uACCTBusiDetail Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(User.uACCTBusiDetail).Insert(8,8,8,8,8,1,1,1,1,1,1,"P",1,1,1 )
ClassMethod Insert(acctSysBusiSectionDr, acctSysBusiPhaseDr, acctSysBusiTypeDr, acctYearDr, acctSubjDr, summary, caption, direction, isAutoCreate, relayType, isGroup, moneyField, whileSql, isFund, isPay) As %String
{
	n (acctSysBusiSectionDr,acctSysBusiPhaseDr,acctSysBusiTypeDr,acctYearDr,acctSubjDr,summary,caption,direction,isAutoCreate,relayType,isGroup,moneyField,whileSql,isFund,isPay)
	&sql(insert into ACCT_BusiDetail (ACCT_SysBusiSection_Dr,ACCT_SysBusiPhase_Dr,ACCT_SysBusiType_Dr,ACCT_Year_Dr,ACCT_Subj_Dr,summary,caption,direction,is_auto_create,relay_type,is_group,money_field,while_sql,is_fund,is_pay) values(:acctSysBusiSectionDr,:acctSysBusiPhaseDr,:acctSysBusiTypeDr,:acctYearDr,:acctSubjDr,:summary,:caption,:direction,:isAutoCreate,:relayType,:isGroup,:moneyField,:whileSql,:isFund,:isPay))
	q SQLCODE
}

/// w ##class(User.uACCTBusiDetail).Update(12,2,2,2,2,2,0,0,0,0,0,0,"S",0,0,0 )
ClassMethod Update(rowid, acctSysBusiSectionDr, acctSysBusiPhaseDr, acctSysBusiTypeDr, acctYearDr, acctSubjDr, summary, caption, direction, isAutoCreate, relayType, isGroup, moneyField, whileSql, isFund, isPay) As %String
{
	n (rowid,acctSysBusiSectionDr,acctSysBusiPhaseDr,acctSysBusiTypeDr,acctYearDr,acctSubjDr,summary,caption,direction,isAutoCreate,relayType,isGroup,moneyField,whileSql,isFund,isPay)
	&sql(update ACCT_BusiDetail set ACCT_SysBusiSection_Dr=:acctSysBusiSectionDr,ACCT_SysBusiPhase_Dr=:acctSysBusiPhaseDr,ACCT_SysBusiType_Dr=:acctSysBusiTypeDr,ACCT_Year_Dr=:acctYearDr,ACCT_Subj_Dr=:acctSubjDr,summary=:summary,caption=:caption,direction=:direction,is_auto_create=:isAutoCreate,relay_type=:relayType,is_group=:isGroup,money_field=:moneyField,while_sql=:whileSql,is_fund=:isFund,is_pay=:isPay where %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTBusiDetail).Delete(12)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM ACCT_BusiDetail WHERE %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTBusiDetail).List()
ClassMethod List() As %String
{
	s sqlStr="select * from ACCT_BusiDetail"
	s whereStr=" WHERE %ID>0 "
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	s jsonTitle="rowid^acctSysBusiSectionDr^acctSysBusiPhaseDr^acctSysBusiTypeDr^acctSysBusiTypeName^acctYearDr^acctYearName^acctSubjDr^acctSubjName^summary^caption^direction^isAutoCreate^relayType^isGroup^moneyField^whileSql^isFund^isPay"

	While(result.Next())
	{
		s rowid = result.Data("ACCTBD_Rowid")
		s acctSysBusiSectionDr  = result.Data("ACCT_SysBusiSection_Dr")
		s acctSysBusiPhaseDr  = result.Data("ACCT_SysBusiPhase_Dr")
		s acctSysBusiTypeDr  = result.Data("ACCT_SysBusiType_Dr")
		s acctSysBusiTypeName=""
		i (acctSysBusiTypeDr'="")&&($g(^User.ACCTSysBusiTypeD(acctSysBusiTypeDr))'="") d
		.s acctSysBusiTypeName = $LIST(^User.ACCTSysBusiTypeD(acctSysBusiTypeDr),6)
		s acctYearDr  = result.Data("ACCT_Year_Dr")
		s acctYearName=""
		i (acctYearDr'="")&&($g(^User.ACCTYearD(acctYearDr))'="") d
		.s acctYearName = $LIST(^User.ACCTYearD(acctYearDr),13)
		s acctSubjDr  = result.Data("ACCT_Subj_Dr")
		s acctSubjName=""
		i (acctSubjDr'="")&&($g(^User.ACCTSubjD(acctSubjDr))'="") d
		.s acctSubjName = $LIST(^User.ACCTSubjD(acctSubjDr),2)
		s summary  = result.Data("summary")
		s caption  = result.Data("caption")
		s direction  = result.Data("direction")
		s isAutoCreate  = result.Data("is_auto_create")
		s relayType  = result.Data("relay_type")
		s isGroup  = result.Data("is_group")
		s moneyField  = result.Data("money_field")
		s whileSql  = result.Data("while_sql")
		s isFund  = result.Data("is_fund")
		s isPay  = result.Data("is_pay")
		
		s tmp=rowid_"^"_acctSysBusiSectionDr_"^"_acctSysBusiPhaseDr_"^"_acctSysBusiTypeDr_"^"_acctSysBusiTypeName_"^"_acctYearDr_"^"_acctYearName_"^"_acctSubjDr_"^"_acctSubjName_"^"_summary_"^"_caption_"^"_direction_"^"_isAutoCreate_"^"_relayType_"^"_isGroup_"^"_moneyField_"^"_whileSql_"^"_isFund_"^"_isPay
		d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^User.uACCTBusiDetailS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
