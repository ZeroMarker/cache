Include webimport

IncludeGenerator webimport

Class web.DHCOPQueueChangeDep Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query QuerySimilarDepback(QueID) As %SQLQuery(CONTAINID = 1, ROWSPEC = "SimilarDepCode:%String,SimilarDepDesc:%String,QueID:%String")
{
 select ctloc_rowid SimilarDepCode,ctloc_desc SimilarDepDesc,:QueID QueID
 from CT_LOC
 where CTloc_Rowid=(select quedepdr from dhcqueue where ID=:QueID)
  union
 select dep_ctloc_dr SimilarDepCode,
 dep_ctloc_dr->ctloc_desc SimilarDepDesc,:QueID QueID
 from CT_Loc_SimilarDepartment 
 where dep_parref=(select quedepdr from dhcqueue where ID=:QueID)
}

Query QuerySimilarDep(QueID) As %SQLQuery(CONTAINID = 1, ROWSPEC = "SimilarDepCode:%String,SimilarDepDesc:%String,QueID:%String,SimilarMarkCode:%String,SimilarMarkDesc:%String")
{
 select a.Deptarget SimilarDepCode,b.ctloc_desc SimilarDepDesc,:QueID QueID,a.Marktarget SimilarMarkCode,c.ctpcp_desc SimilarMarkDesc
 from DHC_OPChgDepMarkSet a,ct_loc b,ct_careprov c
 where a.Deptarget=b.ctloc_rowid and a.Marktarget=c.ctpcp_rowid
 and a.DepSource=(select quedepdr from dhcqueue where id=:QueID)
 and a.MarkSource=(select queMarkdr from dhcqueue where id=:QueID)
}

ClassMethod Commit(SimilarDepD As %Library.String = "", QueID As %Library.String = "", SimilarMarkD As %Library.String = "")
{
	s desc=0
	s OldChangeDepDr=""
	&sql(select QueDepDr,QuePaadmdr,ChangeDepDr,QueMarkDr into :ChangeDepDr,:QuePaadmdr,:OldChangeDepDr,:ChangeMarkDr from Dhcqueue
       where ID=:QueID)
	
	if OldChangeDepDr'="" set ChangeDepDr=OldChangeDepDr
	
	s desc=desc+SQLCODE
	&sql(update Dhcqueue set ChangeDepDr=:ChangeDepDr,Comm1=:ChangeMarkDr,QueDepDr=:SimilarDepD,QueMarkDr=:SimilarMarkD
	 where Id=:QueID)
	s desc=desc+SQLCODE
	
	&sql(update Pa_Adm set paadm_depcode_dr=:SimilarDepD,paadm_admdoccodedr=:SimilarMarkD
	 where Paadm_rowid=:QuePaadmdr)
	s desc=desc+SQLCODE
	
	q desc
}

}
