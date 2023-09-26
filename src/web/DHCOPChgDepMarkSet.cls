Include webimport

IncludeGenerator webimport

Class web.DHCOPChgDepMarkSet Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query Finddep(DepDesc, HospId) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Desc:%String,RowID:%String,code:%String")
{
SELECT CTLOC_Desc,CTLOC_RowID,CTLOC_ContactName  FROM SQLUser.CT_LOC
where ctloc_desc like nvl(upper(:DepDesc),"")||'%' and CTLOC_Hospital_DR=:HospId and 	
CTLOC_ActiveFlag = 'Y'
}

Query Findloc(depid, MarkSource As %String = "", HospId) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Desc:%String,RowID:%String,code:%String")
{
SELECT RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR ,RES_CTPCP_DR->CTPCP_OtherName
FROM SQLUser.RB_RESOURCE
WHERE (RES_CTLOC_DR = :depid 
and (res_schedulerequired='Yes' or res_schedulerequired='Y')
and RES_AdmittingRights='Y')
and (:MarkSource is null or RES_CTPCP_DR->CTPCP_Desc like '%'_:MarkSource_'%')
and (RES_CTLOC_DR->CTLOC_Hospital_DR=:HospId)
and ((RES_DateActiveFrom is null)or (RES_DateActiveFrom<=+$h))
and ((RES_DateActiveTo is null)or (RES_DateActiveTo>+$h))
}

Query UFindChgDepMark(HospID) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,DepSourceDr:%String,MarkSourceDr:%String,DepTargetDr:%String,MarkTargetDr:%String,DepSourceDesc:%String,MarkSourceDesc:%String,DepTargetDesc:%String,MarkTargetDesc:%String")
{
  select a.ID ID,a.DepSource DepSourceDr,a.MarkSource MarkSourceDr,a.DepTarget DepTargetDr,a.MarkTarget MarkTargetDr,
       b.ctloc_desc DepSourceDesc,c.ctpcp_desc MarkSourceDesc,d.ctloc_desc DepTargetDesc,e.ctpcp_desc MarkTargetDesc
 from DHC_OPChgDepMarkSet a,ct_loc b,ct_careprov c,ct_loc d,ct_careprov e
 where a.DepSource=b.ctloc_rowid and a.MarkSource=c.ctpcp_rowid 
   and a.DepTarget=d.ctloc_rowid and a.MarkTarget=e.ctpcp_rowid
   and (b.CTLOC_Hospital_DR=:HospID)
   order by a.DepSource,a.MarkSource,a.DepTarget,a.MarkTarget
}

ClassMethod Save(DepSourceDr As %Library.String = "", MarkSourceDr As %Library.String = "", DepTargetDr As %Library.String = "", MarkTargetDr As %Library.String = "")
{
 
 set num=0
 
 &sql(select count(ID) into :Num from DHC_OPChgDepMarkSet
    where DepSource=:DepSourceDr and MarkSource=:MarkSourceDr )

 //set ^DHCAAA=DepSourceDr_"^"_MarkSourceDr_"^"_DepTargetDr_"^"_MarkTargetDr
    
 if (Num>0) {
    &sql(update DHC_OPChgDepMarkSet set DepTarget=:DepTargetDr,MarkTarget=:MarkTargetDr
    where DepSource=:DepSourceDr and MarkSource=:MarkSourceDr)
 }else{
 	 &sql(insert into SQLUser.DHC_OPChgDepMarkSet
 	(DepSource,MarkSource,DepTarget,MarkTarget)
 	values(:DepSourceDr,:MarkSourceDr,:DepTargetDr,:MarkTargetDr))
 }
 q SQLCODE
}

ClassMethod Delete(ID As %Library.String = "")
{
 
  &sql(Delete from SQLUser.DHC_OPChgDepMarkSet
 	where ID=:ID)
 
 q SQLCODE
}

ClassMethod Insert(DepSourceDr As %Library.String = "", MarkSourceDr As %Library.String = "", DepTargetDr As %Library.String = "", MarkTargetDr As %Library.String = "")
{
	 set num=0
	 &sql(select count(ID) into :Num from DHC_OPChgDepMarkSet
	    where DepSource=:DepSourceDr and MarkSource=:MarkSourceDr and DepTarget=:DepTargetDr and MarkTarget=:MarkTargetDr)    
	 if (Num>0) {
	    q "-1"
	 }else{
	 	 &sql(insert into SQLUser.DHC_OPChgDepMarkSet
	 	(DepSource,MarkSource,DepTarget,MarkTarget)
	 	values(:DepSourceDr,:MarkSourceDr,:DepTargetDr,:MarkTargetDr))
	 }
	 q SQLCODE
}

ClassMethod Update(ID, DepSourceDr As %Library.String = "", MarkSourceDr As %Library.String = "", DepTargetDr As %Library.String = "", MarkTargetDr As %Library.String = "")
{
	&sql(select count(ID) into :Num from DHC_OPChgDepMarkSet
	    where DepSource=:DepSourceDr and MarkSource=:MarkSourceDr and DepTarget=:DepTargetDr and MarkTarget=:MarkTargetDr and ID<>:ID)
	 if (Num>0)  q "-1"    
	 &sql(update DHC_OPChgDepMarkSet set DepTarget=:DepTargetDr,MarkTarget=:MarkTargetDr,
	 DepSource=:DepSourceDr , MarkSource=:MarkSourceDr
    where ID=:ID)
	 q SQLCODE
}

}
