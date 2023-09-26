Import SQLUser

/// Creator: Lid
/// CreatDate:2 012-07-12
/// Description: 特殊项目采血地点维护
Class web.DHCOPBillHDDCArcim Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCOPBillHDDCArcim","FindHDDCArcim","","","")
Query FindHDDCArcim(HDDCRowID As %String, LocSortingDR As %String, ArcimDR As %String = "") As websys.Query(ROWSPEC = "Tind,THDDCSRowID,TLocSortingDR,TLocSortingDesc,THDDCSArcimDR,TArcimCode,THDDCSArcimDesc,THDDCSArcimPlace,THDDCSAddUser,THDDCSAddDate,THDDCSUpdateUser,THDDCSUpdateDate")
{
}

ClassMethod FindHDDCArcimExecute(ByRef qHandle As %Binary, HDDCRowID As %String, LocSortingDR As %String, ArcimDR As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set ind=1

	If (+HDDCRowID=0) Do
	.Set HDDCRowID=0
	.For  Set HDDCRowID=$o(^DHCOPBillHDDC(HDDCRowID)) Quit:(HDDCRowID="")  Do
	..Do QueryArcimList(HDDCRowID)
	Else  Do
	.Do QueryArcimList(HDDCRowID)
	
	Quit $$$OK
	
QueryArcimList(HDDCRowID)
	Set myLocSortingDR=$p(^DHCOPBillHDDC(HDDCRowID),"^",2)
	Quit:(LocSortingDR'="")&&(LocSortingDR'=myLocSortingDR)
	Quit:'$d(^DHCLocSorting(myLocSortingDR))
	Set myLocSortingDesc=$p(^DHCLocSorting(myLocSortingDR),"^",2)
	Set Sub=0
	For  Set Sub=$o(^DHCOPBillHDDC(HDDCRowID,"Sub",Sub))  Quit:(Sub="")  Do
	.Set ss=$g(^DHCOPBillHDDC(HDDCRowID,"Sub",Sub))
	.Set (AddUserName,AddDateDisplay,UpdateUserName,UpdateDateDisplay)=""
	.Set myArcimDR=$p(ss,"^",1)
	.Set myArcimCode=$p(^ARCIM(+myArcimDR,$p(myArcimDR,"||",2),1),"^",1)
	.Set myArcimDesc=$p(^ARCIM(+myArcimDR,$p(myArcimDR,"||",2),1),"^",2)
	.Quit:((ArcimDR'="")&&(ArcimDR'=myArcimDR))
	.Set myPlace=$p(ss,"^",2)
	.Set myAddUser=$p(ss,"^",3)
	.Set:myAddUser'="" AddUserName=$p($g(^SSU("SSUSR",myAddUser)),"^",2)
	.Set myAddDate=$p(ss,"^",4)
	.Set:(myAddDate'="") AddDateDisplay=##class(websys.Conversions).DateLogicalToHtml(myAddDate)
	.Set myUpdateUser=$p(ss,"^",6)
	.Set:(myUpdateUser'="") UpdateUserName=$p($g(^SSU("SSUSR",myUpdateUser)),"^",2)
	.Set myUpdateDate=$p(ss,"^",7)
	.Set:(myUpdateDate'="") UpdateDateDisplay=##class(websys.Conversions).DateLogicalToHtml(myUpdateDate)
	.Set HDDCSRowID=HDDCRowID_"||"_Sub
	.Do OutputRow1
	;
	Quit

OutputRow1
	set Data=$lb(ind,HDDCSRowID,myLocSortingDR,myLocSortingDesc,myArcimDR,myArcimCode,myArcimDesc,myPlace,AddUserName,AddDateDisplay,UpdateUserName,UpdateDateDisplay)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod AddHDDCArcim(HDDCRowID, ArcimDR, Position, Guser)
{
	New (HDDCRowID, ArcimDR, Position, Guser)
	;
	Set Sub=0, IsExist=0
	For  Set Sub=$o(^DHCOPBillHDDC(HDDCRowID,"Sub",Sub))  Quit:(Sub="")  Do
	.Set ss=$g(^DHCOPBillHDDC(HDDCRowID,"Sub",Sub))
	.Set myArcimDR=$p(ss,"^",1)
	.If (ArcimDR=myArcimDR) Do
	..Set IsExist=1
	Quit:(IsExist=1) "-1006"  ;一个项目在一个科室分类中只能维护一个位置
	;
 	Set Date=+$H, Time=$p($h,",",2)
 	&sql(insert into dhc_opbillhddcsub(hddc_parref,hddcs_arcim_dr,hddcs_place,hddcs_adduser_dr,hddcs_adddate,hddcs_addtime) values(:HDDCRowID,:ArcimDR,:Position,:Guser,:Date,:Time))
 	Set HDDCSRowID=%ROWID
 	Quit SQLCODE_"^"_HDDCSRowID	
 	;DeleteHDDCArcim",HDDCSRowID,Guser
}

ClassMethod UpdateHDDCArcim(HDDCSRowID, Position, Guser)
{
	New (HDDCSRowID,Position,Guser)
	Set Date=+$h,Time=$p($h,",",2)
	&sql(update dhc_opbillhddcsub set hddcs_place=:Position,hddcs_updateuserdr=:Guser,hddcs_updatedate=:Date,hddcs_updatetime=:Time  where hddcs_rowid=:HDDCSRowID)	
	Quit SQLCODE
}

ClassMethod DeleteHDDCArcim(HDDCSRowID, Guser)
{
	New (HDDCSRowID,Guser)
	&sql(delete from dhc_opbillhddcsub where hddcs_rowid=:HDDCSRowID)
	Quit SQLCODE
}

/// Lid
/// 2012-09-05
/// 处理未加到科室分类中的医嘱项
/// w ##class(web.DHCOPBillHDDCArcim).AddArcim("20515||1")
ClassMethod AddArcim(ArcimDRStr)
{
	New (ArcimDRStr)
	;
	For i=1:1:$l(ArcimDRStr,"^") Do
	.Set ArcimDR=$p(ArcimDRStr,"^",i)
	.Quit:(ArcimDR="")
	.Set HDDCDR=0
	.For  Set HDDCDR=$o(^DHCOPBillHDDC(HDDCDR)) Quit:(HDDCDR="")  Do
	..Set err=..AddHDDCArcim(HDDCDR, ArcimDR, "", 3881)
	Quit 0
}

}
