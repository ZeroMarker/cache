Import sqluser

/// 对医嘱进行的操作
Class web.DHCFOrd Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// //通过医嘱ID进行COPY医嘱
ClassMethod CopyOrdById(PapmiId As %String, OrdId As %String = "", CUserId As %String = "") As %Integer
{
	q:$g(OrdId)="" 100
	q:(+OrdId=0) 100
	q:$g(PapmiId)="" 100
	q:(+PapmiId=0) 100
	s OrdId1=$p(OrdId,"||"),OrdId2=$p(OrdId,"||",2)
	q:($g(OrdId1)="" || $g(OrdId2)="") 100
	q:('$d(^PAPERdr(PapmiId,"ADM","I"))) 100
	s AdmId=$o(^PAPERdr(PapmiId,"ADM","I",""),-1)
	if $g(AdmId)="" q 100
	s OrdParref=$o(^OEORD(0,"Adm",AdmId,0))
	Q:$G(OrdParref)="" 101 //无住院医嘱
	k PLIST
	&sql(select * into :PLIST() from SQLUSER.OE_OrdItem WHERE OEORI_ROWID=:OrdId)
	Q:$G(SQLCODE) $G(SQLCODE)
	b ;sql1
	k PLIST(0),PLIST(2),PLIST(10),PLIST(77),PLIST(120),PLIST(141),PLIST(230),PLIST(93)
	s PLIST(0)=OrdParref
	;s PLIST(42)="院前检查费用合并"
	S PLIST(77)=1005
	S PLIST(76)="TB"
	s PLIST(10)=6
	s PLIST(120)=$g(CUserId),PLIST(141)=$g(CUserId)
	S OrdSttDat=PLIST(17)
	
	&sql(insert into OE_OrdItem values :PLIST())
	b ;sql2
	;w $tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)
	Q:$G(SQLCODE) $G(SQLCODE)
	if $g(%ROWID)'=""  d
	.s NewOrdId=$G(%ROWID)
	.s ^OEORD($p(NewOrdId,"||"),"I",$p(NewOrdId,"||",2),"REM",0)=1
	.s ^OEORD($p(NewOrdId,"||"),"I",$p(NewOrdId,"||",2),"REM",1)="院前检查费用合并"
	.K PLIST,SQLCODE
	.S PLIST(0)=NewOrdId,PLIST(3)=$g(OrdSttDat),PLIST(4)=$P($H,",",2),PLIST(5)=6,PLIST(6)=CUserId
	.&sql(insert into SQLUser.OE_OrdStatus values PLIST())
	.b ;sql3
	.if $G(SQLCODE) 
	
	
	if $g(NewOrdId)'=""  d
	.;s NewOrdId=$G(%ROWID)
	.IF $D(^OEORD(OrdId1,"I",OrdId2,"DHC")) M ^OEORD($P(NewOrdId,"||"),"I",$P(NewOrdId,"||",2),"DHC")=^OEORD(OrdId1,"I",OrdId2,"DHC")
	.S ExecId=0
	.k SQLCODE
	.F  S ExecId=$o(^OEORD(OrdId1,"I",OrdId2,"X",ExecId)) q:((ExecId="")||($G(SQLCODE)))  d
	..K PLIST
	..s OrdExecId=OrdId_"||"_ExecId
	..&sql(select * into :PLIST() from SQLUser.OE_OrdExec WHERE OEORE_RowId=:OrdId)
	..b ;sql4
	..q:$G(SQLCODE)
	..k PLIST(0),PLIST(1),PLIST(2),PLIST(43),SQLCODE
	..s PLIST(0)=NewOrdId
	..&SQL(insert into SQLUser.OE_OrdExec values PLIST())
	..b ;sql5
	..IF $g(SQLCODE) Q 
	.Q:$G(SQLCODE)
	.;S StatusId=$o(^OEORD(OrdId1,"I",OrdId2,"ST",0),-1)
	.;IF +StatusId>0 d
	.;.s OrdStatusId=OrdId_"||"_StatusId
	.;K PLIST,SQLCODE
	..;&sql(select * into :PLIST() from SQLUser.OE_OrdStatus where ST_RowId=:OrdStatusId)
	..;IF $G(SQLCODE) Q
	..;K PLIST(0),PLIST(1),PLIST(2),PLIST(5)
	.;S PLIST(0)=NewOrdId,PLIST(3)=+$H,PLIST(4)=$P($H,",",2),PLIST(5)=6,PLIST(6)=CUserId
	.;&sql(insert into SQLUser.OE_OrdStatus values PLIST())
	.;if $G(SQLCODE) Q
	Q $G(SQLCODE)
}

}
