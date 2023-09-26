Import sqluser

Class web.DHCJFBillADMSFCofig Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod InsCon(Code, Desc, Val)
{
	n (Code, Desc,Val)
	s Val=$$ALPHAUP^SSUTIL4(Val)
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s Code=$$ALPHAUP^SSUTIL4(Code)
	s Date=+$h
	s Time=$p($h,",",2)
	q:$d(^DHCJFBILLADMREACON(0,Val)) "-1"
	TStart
	&sql(INSERT INTO dhc_jfbilladmreasonconfig(ADMCON_Code,ADMCON_Desc,ADMCON_CreatDate,ADMCON_CreatTime,ADMCON_Val) VALUES(:Code,:Desc,:Date,:Time,:Val))
	i (SQLCODE=0) d
	.Tcommit
	e  d
	.Trollback
	
	q SQLCODE
}

ClassMethod DelCon(CONRowID)
{
	n (CONRowID)
	s InvType=$p(^DHCJFBILLADMREACON(CONRowID),"^",3)
	q:(InvType="O") "OPINV"
	q:(InvType="I") "IPINV"
	q:(InvType="R") "RINV"
	&sql(DELETE FROM dhc_jfbilladmreasonconfig WHERE ADMCON_Rowid=:CONRowID)
	q SQLCODE
}

/// Creator: wangjian
/// CreatDate:2012-06-29
/// Description: 查询发票类型
/// Table： dhc_jfbilladmreasonconfig
/// Input： 
/// Output：       
/// Return：         
/// Others：     
Query FindAdmSFConfig(admconcode, admcondesc, admconval) As websys.Query(ROWSPEC = "TCONCode,TCONDesc,TCONVal,TCONDate,TCONTime,TCONRowID")
{
}

ClassMethod FindAdmSFConfigExecute(ByRef qHandle As %Binary, admconcode As %String, admcondesc As %String, admconval As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	s CONRowID=0
 	f  s CONRowID=$o(^DHCJFBILLADMREACON(CONRowID))  q:(CONRowID="")  d
 	.s CONCode=$p(^DHCJFBILLADMREACON(CONRowID),"^",1)
 	.s CONDesc=$p(^DHCJFBILLADMREACON(CONRowID),"^",2)
 	.s CONVal=$p(^DHCJFBILLADMREACON(CONRowID),"^",3)
 	.s date=$p(^DHCJFBILLADMREACON(CONRowID),"^",4)
 	.s CONDate=##class(websys.Conversions).DateLogicalToHtml(date)
 	.s time=$p(^DHCJFBILLADMREACON(CONRowID),"^",5)
 	.s CONTime=##class(websys.Conversions).TimeLogicalToHtml(time,1)
 	.q:(admconcode'="")&&($ZCVT(CONCode,"U")'=$ZCVT(admconcode,"U"))
 	.q:(admcondesc'="")&&($ZCVT(CONDesc,"U")'=$ZCVT(admcondesc,"U"))
 	.q:(admconval'="")&&($ZCVT(CONVal,"U")'=$ZCVT(admconval,"U"))
 	.d OutputAdmSFCfg
 	
	quit $$$OK
OutputAdmSFCfg
	set Data=$lb(CONCode,CONDesc,CONVal,CONDate,CONTime,CONRowID)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod UpCon(Code, Desc, Val, CONRowID)
{
	n (Code, Desc,Val,CONRowID)
	s Val=$$ALPHAUP^SSUTIL4(Val)
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s Code=$$ALPHAUP^SSUTIL4(Code)
	s Date=+$h
	s Time=$p($h,",",2)
	TStart
     &sql(UPDATE dhc_jfbilladmreasonconfig SET ADMCON_Code=:Code,ADMCON_Desc=:Desc,ADMCON_CreatDate=:Date,ADMCON_CreatTime=:Time,ADMCON_Val=:Val WHERE ADMCON_Rowid=:CONRowID)
	i SQLCODE=0 D
	.Tcommit
	e  d
	.Trollback
	
	q SQLCODE
}

Query Find1(groupid As %String, User) As websys.Query(ROWSPEC = "Name,ID,Initials")
{
}

ClassMethod Find1Execute(ByRef qHandle As %Binary, groupid As %String, User) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if (groupid="")  quit $$$OK
 	
	s SSRowid="0"
	f  s SSRowid=$o(^SSU("SSUSR",0,"Group",groupid,SSRowid)) q:(SSRowid="")  d
	.s SSName=$p(^SSU("SSUSR",SSRowid),"^",2)
	.s SSInitial=$p(^SSU("SSUSR",SSRowid),"^",1)
	.s ID=SSRowid
	.q:(SSName'[User)&(User'="")
	.d OutputRowUser
	quit $$$OK
OutputRowUser
	set Data=$lb(SSName,ID,SSInitial)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query Find(UserGroup As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRPDesc,ID")
{
SELECT SSGRP_Desc,SSGRP_Rowid
FROM SS_Group
WHERE SSGRP_Desc %STARTSWITH :UserGroup
ORDER BY SSGRP_Desc
}

Query FindRcptGroupSet(grp As %String, RcptTypeval As %String, Guser As %String) As websys.Query(ROWSPEC = "Tusrname:%String,Tusrgrp:%String,Tusrinitials:%String,Tmyrowid:%String")
{
}

ClassMethod FindRcptGroupSetExecute(ByRef qHandle As %Binary, grp As %String, RcptTypeval As %String, Guser As %String) As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
    if ($g(grp)="")||(RcptTypeval="") quit $$$OK
    set type=RcptTypeval
    if (type="A") s grp=1
    set UserID=Guser
    set myUserHospitalID=##Class(web.UDHCHospitalGroup).GetHospitalIDByUserID(UserID)
    s rowid=""
    f  s rowid=$o(^DHCJFRcptGroupSet(0,"Type",type,grp,rowid)) q:rowid=""  d
    .s sub=0
    .f  s sub=$o(^DHCJFRcptGroupSet(rowid,"Sub",sub)) q:sub=""  d
    ..s usrrowid=$p(^DHCJFRcptGroupSet(rowid,"Sub",sub),"^",4)
    ..set myHospitalID=##Class(web.UDHCHospitalGroup).GetHospitalIDByUserID(usrrowid)
    ..;quit:myUserHospitalID'=myHospitalID
    ..s usrgrp=$p(^DHCJFRcptGroupSet(rowid,"Sub",sub),"^",3)
    ..i $d(^SSU("SSUSR",usrrowid)) s usrname=$p(^SSU("SSUSR",usrrowid),"^",2),usrinitials=$p(^SSU("SSUSR",usrrowid),"^",1)
    ..i $d(^SSU("SSGRP",usrgrp)) s usrgrp=$p(^SSU("SSGRP",usrgrp),"^",1)
    ..s myrowid=rowid_"||"_sub
    ..do OutputRow3
	quit $$$OK
OutputRow3
	set Data=$lb(usrname,usrgrp,usrinitials,myrowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod InsGroupset(type, group, user, grp)
{
	n (type,group,user,grp)
	s type=$$ALPHAUP^SSUTIL4(type)
	i type="A"  s grp=1
	S Rowid=0
	TStart
	i '$d(^DHCJFRcptGroupSet(0,"Type",type)) {
     &sql(INSERT INTO DHC_JFRcptGroupSet(grp_rcpttype,grp_rcptgrptype) VALUES(:type,:grp))
     i SQLCODE=0 d
	.s Rowid=$g(%ROWID)
	e  d
	.Trollback
	}
	i (+Rowid=0) s Rowid=$o(^DHCJFRcptGroupSet(0,"Type",type,grp,""))
	&sql(INSERT INTO DHC_JFRcptGroupUser(grpuser_parref,grpuser_ssgrp_dr,grpuser_ssusr_dr) VALUES(:Rowid,:group,:user))
	i SQLCODE=0 d
	.Tcommit
	e  d
	.Trollback
	q SQLCODE
}

ClassMethod DelGroupset(GroupRowid)
{
	TStart
	&sql(DELETE FROM DHC_JFRcptGroupuser WHERE grpuser_rowid=:GroupRowid)
	i SQLCODE=0 d
	.Tcommit
	e  d
	.Trollback
	q SQLCODE
}

}
