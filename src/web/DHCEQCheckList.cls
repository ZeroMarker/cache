Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCEQCheckList Extends %Library.RegisteredObject [ Not Abstract, ClassType = "", Not ProcedureBlock ]
{

ClassMethod UpdateCheckList(itmjs As %Library.String = "", itmjsex As %Library.String = "", val, AppType)
{
	;+AppType=0 新增
	;+AppType=1 更新
	;+AppType=2 删除
	s RowID=$p(val,"^",1) ;RowID
	s PLIST(2)=$p(val,"^",2) ;CheckDR
	s PLIST(3)=$p(val,"^",3) ;CheckItemDR
	s PLIST(4)=$p(val,"^",4) ;CheckResultDR
	s PLIST(5)=$p(val,"^",5) ;Remark
 	TSTART
 	if +AppType=0
 	{
	 	&sql(insert into sqluser.DHC_EQCheckList values :PLIST())
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	if +AppType=1
 	{
	 	&sql(update sqluser.DHC_EQCheckList values :PLIST() where CHL_RowID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	if +AppType=2
 	{
	 	&sql(delete from sqluser.DHC_EQCheckList where CHL_RowID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	TCOMMIT
 	q SQLCODE
}

ClassMethod GetOneCheckList(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCheckList(rowid)
	s resultex=resultex_"^"	;CheckDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCheck($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;CheckItemDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCCheckItem",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;CheckResultDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCCheckResult",$p(result,"^",3))),"^",2)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetCheckList(CheckDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TCheckDR:%String,TCheckItemDR:%String,TCheckItem:%String,TCheckResultDR:%String,TCheckResult:%String,TRemark:%String")
{
SELECT CHL_RowID TRowID,
	   :CheckDR TCheckDR,
	   CHL_CheckItemDR TCheckItemDR,
	   CHL_CheckItemDR->CI_Desc TCheckItem,
	   CHL_CheckResultDR TCheckResultDR,
	   CHL_CheckResultDR->CR_Desc TCheckResult,
	   CHL_Remark TRemark
FROM sqluser.DHC_EQCheckList
where CHL_CheckDR=:CheckDR
}

}
