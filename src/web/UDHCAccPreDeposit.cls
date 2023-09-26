Import SQLUser

Class web.UDHCAccPreDeposit Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod CLOSE()
{
	k ROW
	q 0
}

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_AccPreDeposit WHERE AccPD_RowID= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod FETCH(ParRef)
{
	i $d(ROW) d
	.s ROW=$o(^DHCACD("AccM",+ParRef,"AccPD",ROW))
	.s SQLCODE=..SELECT(ParRef_"||"_ROW)
	e  s SQLCODE=100
	q SQLCODE
}

/// 得到最大的流水号码
/// w ##class(web.UDHCAccPreDeposit).GetMaxBillNo("P","GHZ001")
ClassMethod GetMaxBillNo(PreType As %String, UserCode As %String) As %String
{
	new (PreType, UserCode)
	
	set myMaxBNo=""
	quit:(UserCode="") myMaxBNo
	//收预交金0，退预交金1
	set myFlag=$s((PreType="P"):"0",1:"1")
	
	set myUserRowID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(UserCode,"U"),0))
	set myLastBNo=""
	if (myUserRowID'="") {
	    if (PreType="P") {
			set myLastBNo=$o(^DHCACDi("AccM",0,"UserBillNo",myUserRowID,PreType,""),-1)
	    }else {
		    set myLastBNo=$o(^DHCACDi("AccM",0,"UserBillNo",myUserRowID,"F",""),-1)
		    set myRefundLastBNo=$o(^DHCACDi("AccM",0,"UserBillNo",myUserRowID,"R",""),-1)
		    set myUserCode=$zcvt(UserCode,"U")
		    set tmpLastBNo=+$p(myLastBNo,myUserCode,2,12)
		    set tmpRefundLastBNo=+$p(myRefundLastBNo,myUserCode,2,12)
		    if (tmpLastBNo<tmpRefundLastBNo) {
				set myLastBNo=myRefundLastBNo
			}
		}
	}
	
	if ((myUserRowID="")||(myLastBNo="")){
		set myUserCode=UserCode_myFlag_"%"
		&sql(SELECT max(AccPD_BillNum) INTO :myMaxBNo
			FROM DHC_AccPreDeposit WHERE AccPD_BillNum LIKE :myUserCode)
	}else{
		set myMaxBNo=myLastBNo
	}
	
	set mylen=$l(UserCode_myFlag)
	set myBNoLen=$l(myMaxBNo)
	set myNo=+$e(myMaxBNo,mylen+1,myBNoLen)+1    //取到数字位
	set myMaxBNo=UserCode_myFlag_##class(BILL.Util.Tools).FormatNO(myNo, 11)
	
	quit myMaxBNo
}

ClassMethod INSERT()
{
	k PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_AccPreDeposit Values PLIST())
	d ..tc()
	s myRowID=%ROWID
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
}

ClassMethod OPEN(ParRef)
{
	i '$d(^DHCACD("AccM",+ParRef,"AccPD")) s SQLCODE=100
	e  s ROW="",SQLCODE=0
	q SQLCODE
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_AccPreDeposit WHERE AccPD_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod UPDATE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_AccPreDeposit VALUES PLIST() WHERE AccPD_RowID= :RowId)
	d ..tc()
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q SQLCODE
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
 	n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
