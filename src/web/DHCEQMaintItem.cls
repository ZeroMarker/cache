Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCEQMaintItem Extends %Library.RegisteredObject [ Not Abstract, ClassType = "", Not ProcedureBlock ]
{

ClassMethod InsertMaintItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", MaintDR, MaintPartDR, MaintItemDR, MaintState, Remark)
{
 &sql(Insert into sqluser.DHC_EQMaintItem (MTI_MaintDR,MTI_MaintPartDR,MTI_MaintItemDR,MTI_MaintState,MTI_Remark) values(:MaintDR,:MaintPartDR,:MaintItemDR,:MaintState,:Remark))
  s return=SQLCODE
  i SQLCODE'=0 TROLLBACK
  q return
}

ClassMethod UpdateMaintItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID, MaintDR, MaintPartDR, MaintItemDR, MaintState, Remark)
{
 &sql(UPDATE sqluser.DHC_EQMaintItem set MTI_MaintDR=:MaintDR,MTI_MaintPartDR=:MaintPartDR,MTI_MaintItemDR=:MaintItemDR,MTI_MaintState=:MaintState,MTI_Remark=:Remark Where MTI_RowID=:RowID)
  s return=SQLCODE
  i SQLCODE'=0 TROLLBACK
  q return
}

ClassMethod DeleteMaintItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID)
{
 &sql(Delete from sqluser.DHC_EQMaintItem Where MTI_RowID=:RowID)
  s return=SQLCODE
  i SQLCODE'=0 TROLLBACK
  q return
}

ClassMethod GetOneMaintItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQMaintItem(rowid)
	s resultex=resultex_"^"	;MaintDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQMaint($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;MaintPartDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPart",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;MaintItemDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintItem",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;MaintUserDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##class(DHCEQCommon).GetTrakNameByID("user",$p(result,"^",4))
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetMaintItem(MaintDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TMaintDR:%String,TMaintPartDR:%String,TMaintPart:%String,TMaintItemDR:%String,TMaintItem:%String,TMaintState:%String,TRemark:%String")
{
SELECT MTI_RowID TRowID,
	   :MaintDR TMaintDR,
	   MTI_MaintPartDR TMaintPartDR, 
	   MTI_MaintPartDR->P_Desc TMaintPart,
	   MTI_MaintItemDR TMaintItemDR,
	   MTI_MaintItemDR->MI_Desc TMaintItem,
	   MTI_MaintState TMaintState,
	   MTI_Remark TRemark
FROM sqluser.DHC_EQMaintItem
where MTI_MaintDR=:MaintDR
}

}
