Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCEQInspectItem Extends %Library.RegisteredObject [ Not Abstract, ClassType = "", Not ProcedureBlock ]
{

ClassMethod InsertInspectItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", InspectDR As %String, InspectPartDR As %String, InspectItemDR As %String, InspectState As %String, Remark As %String)
{
 &sql(Insert into sqluser.DHC_EQInspectItem (ISI_InspectDR,ISI_InspectPartDR,ISI_InspectItemDR,ISI_InspectState,ISI_Remark) values(:InspectDR,:InspectPartDR,:InspectItemDR,:InspectState,:Remark))
  s return=SQLCODE
  i SQLCODE'=0 TROLLBACK
  q return
}

ClassMethod UpdateInspectItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %String, InspectDR As %String, InspectPartDR As %String, InspectItemDR As %String, InspectState As %String, Remark As %String)
{
 &sql(UPDATE sqluser.DHC_EQInspectItem set ISI_InspectDR=:InspectDR,ISI_InspectPartDR=:InspectPartDR,ISI_InspectItemDR=:InspectItemDR,ISI_InspectState=:InspectState,ISI_Remark=:Remark Where ISI_RowID=:RowID)
  s return=SQLCODE
  i SQLCODE'=0 TROLLBACK
  q return
}

ClassMethod DeleteInspectItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %String)
{
 &sql(Delete from sqluser.DHC_EQInspectItem Where ISI_RowID=:RowID)
  s return=SQLCODE
  i SQLCODE'=0 TROLLBACK
  q return
}

// // As %String

ClassMethod GetOneInspectItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQInspectItem(rowid)
	s resultex=resultex_"^"	;InspectDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQInspect($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;InspectPartDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPart",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;InspectItemDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCInspectItem",$p(result,"^",3))),"^",2)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetInspectItem(InspectDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TInspectDR:%String,TInspectPartDR:%String,TInspectPart:%String,TInspectItemDR:%String,TInspectItem:%String,TInspectState:%String,TRemark:%String")
{
SELECT ISI_RowID TRowID,
	   ISI_InspectDR TInspectDR,
	   ISI_InspectPartDR TInspectPartDR, 
	   ISI_InspectPartDR->P_Desc TInspectPart,
	   ISI_InspectItemDR TInspectItemDR,
	   ISI_InspectItemDR->II_Desc TInspectItem,
	   ISI_InspectState TInspectState,
	   ISI_Remark TRemark
FROM sqluser.DHC_EQInspectItem
where ISI_InspectDR=:InspectDR
}

}
