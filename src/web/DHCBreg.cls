Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCBreg Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 ;n id,code,desc
 ;
 Set (id,code,desc)=""
 //set ^DHCApp=val
 Set rs=##Class(%ResultSet).%New("web.DHCBreg:OPDocList")
 Set Status=0
 If rs.QueryIsValid() { 
	 Set Status=rs.Execute(val)
	 If 'Status Quit
	 While rs.Next() {
		 Set DocCode=rs.Data("Code")
		 Set DocDesc=rs.Data("Desc")
		 If desc="" Set desc=DocCode_$c(1)_DocDesc
		 Else  Set desc=desc_"^"_DocCode_$c(1)_DocDesc
	 }
 }
 Set SQLCODE=0
 i SQLCODE s desc=val q 0
 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod DocSechBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val1 As %Library.String = "", val2 As %Library.String = "")
{
 set (d(1),d(2),d(3),d(4),d(5),d(6),d(7))="未排"
 set desc=""
 set Deptdr=val1
 set CPDr=val2
 Set ResRowId=$o(^RB("RES",0,"CTPCP",CPDr,Deptdr,""))

 Set DateRowId=""
 If ResRowId'="" Set DateRowId=$O(^RB("RES",ResRowId,"DATE",""),-1)	
 Set AdmDate=..%SysDate(),AdmTime=..%SysTime(),AdmWeek=$ZD(+$H,10)
 If AdmWeek="0" Set AdmWeek="7"

 If DateRowId="" Quit 0
 S Sess=""
 Set SessRowId=0 f  s SessRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)) q:(SessRowId="")!(Sess'="")  d
 .Set StartTime=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",4)
 .Set EndTime=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",5)
 .Set DoWeek=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",2)
 .;If AdmTime'>StartTime Quit
 .;If AdmTime'<EndTime Quit
 .;If AdmWeek'=DoWeek Quit 
 .Set Load=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",8)
 .Set status=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",14)
 .if status="1" s d(DoWeek)=Load
 .if status="2" s d(DoWeek)="停诊"

 set desc=d(1)_"^"_d(2)_"^"_d(3)_"^"_d(4)_"^"_d(5)_"^"_d(6)_"^"_d(7)

 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod FindNextRB(CPDr As %String, Deptdr As %String, QueryStatus As %String, nowda As %String) As %String
{
 s nowda=$ZDH(nowda,4)
 s ^a=CPDr+"^"+Deptdr+"^"+QueryStatus+"^"+nowda

 Set YNextda=""
 Set ResRowId=$o(^RB("RES",0,"CTPCP",CPDr,Deptdr,""))
 Set DateRowId=""
 If ResRowId'="" Set DateRowId=$O(^RB("RES",ResRowId,"DATE",""),-1)
 If DateRowId="" Quit 0
 s nextda=nowda
 s Sessre=""
 while(Sessre=""){
	 s nextda=nextda+1
	 s Sessre=$$Find()
	 } 
 i Sessre'="0" s ret=$zd(nextda,4) 
 e  s ret=""
 q ret
Find() 
 Set AdmDate=nextda,AdmTime=..%SysTime(),AdmWeek=$ZD(nextda,10)
 If AdmWeek="0" Set AdmWeek="7"
 Set Sess="",BregMaxno="",StartTime=""
 Set SessRowId=0 f  s SessRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)) q:(SessRowId="")!(Sess'="")  d
 .Set StartTime=+$p($g(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)),"^",4)
 .if StartTime="" quit
 .Set EndTime=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",5)
 .Set DoWeek=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",2)
 .Set status=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",14)
 .if status'="1" quit
 .If AdmWeek'=DoWeek Quit
 .Set Sess=SessRowId
 .Set Load=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",8)
 .SET AdmQty=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",1)
 .Set RoomDr=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",19)
 .Set NoWeeks=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",21)
 .Set BregMaxno=$p($g(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)),"^",1)
 .s NoWeeks=NoWeeks+1 
 //查找已预约号和已预约并挂号的数	
 s AppQty=0 ;预约并挂号
 s ABregQty=0 
 s AdmDateId=" "_AdmDate
 s CPDrId=" "_CPDr
 s DeptdrId=" "_Deptdr
 s AppRowId=0
 f  Set AppRowId=$o(^User.DHCBeforeRegI("DateDeptDoc",AdmDateId,DeptdrId,CPDrId,AppRowId)) quit:(AppRowId="")  d
 .s AppFlag=$list(^User.DHCBeforeRegD(AppRowId),5)
 .s AppNo=$list(^User.DHCBeforeRegD(AppRowId),6)
 .if NoWeeks=AppNo s NoWeeks=NoWeeks+1
 .s ABregQty=ABregQty+1
 .if AppFlag="0" d 
 ..s AppQty=AppQty+1
 i ABregQty=BregMaxno  s Sess="0"
 q Sess
}

ClassMethod GetDocDetailBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val1 As %Library.String = "", val2 As %Library.String, val3 As %Library.String, yda As %String)
{
 ;n id,code,desc
 set AppSelect=val3
 set DocDesc=$tr($ZCVT(val1,"U")," ","")
 Set DocDr=$O(^CTPCP(0,"Code",DocDesc,""))
 Set LocDr=$O(^CTLOC(0,"Desc",$tr($ZCVT(val2,"U"),"-",""),""))
 If DocDr="" Quit 0
 If LocDr="" Quit 0

 if AppSelect="F" {
 Set Detail=##Class(web.DHCBreg).GetDocRegFee(DocDr,LocDr,"S",yda,"0") ;yn加
 }else{
	Set Detail=##Class(web.DHCBreg).GetDocRegFee(DocDr,LocDr,AppSelect,yda,"0") ;yn加
 }
 ;
 Set Detail=Detail_"^"_LocDr_"^"_DocDr
 ;
 Set SQLCODE=0
 ;
 i SQLCODE s desc=val q 0
 s retval=itmjs_"('"_$ZCVT(Detail,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(Detail,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod GetDocRegFee(CPDr As %String, Deptdr As %String, QueryStatus As %String, ynda As %String, tyn As %String) As %String
{
 s Load=0
 s NoAppt=0
 s RoomDr=""
 s LocDesc=""
 S Price=""
 s NoWeeks=""
 Set ResRowId=$o(^RB("RES",0,"CTPCP",CPDr,Deptdr,""))
 Set DateRowId=""
 ;s tyn="0"
 s ^GWJ=Deptdr_"*"_CPDr_"*"_ynda
 if $f(ynda,"/")'=0  s ynda=$zdh(ynda,4)
 If ResRowId'="" Set DateRowId=$O(^RB("RES",ResRowId,"DATE",""),-1)
 i (tyn="0")&(ynda="") d
 .Set AdmDate=..%SysDate(),AdmTime=..%SysTime(),AdmWeek=$ZD(+$H,10)
 e  d
 .Set AdmDate=ynda,AdmTime=..%SysTime(),AdmWeek=$ZD(ynda,10)
 If AdmWeek="0" Set AdmWeek="7"
 ;
 If DateRowId="" Quit 0
 Set Sess=""
 set StartTime=""
 Set SessRowId=0 f  s SessRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)) q:(SessRowId="")!(Sess'="")  d
 .Set StartTime=+$p($g(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)),"^",4)
 .if StartTime="" quit
 .Set EndTime=+$p($g(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)),"^",5)
 .Set DoWeek=+$p($g(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)),"^",2)
 .Set status=$p($g(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)),"^",14)
 .if status'="1" quit
 .;If AdmTime'>StartTime Quit
 .;If AdmTime'<EndTime Quit
 .If AdmWeek'=DoWeek Quit 
 .Set Sess=SessRowId
 .Set Load=$p($g(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)),"^",8)
 .SET AdmQty=$p($g(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)),"^",1)
 .Set RoomDr=$p($g(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)),"^",19)
 .Set NoWeeks=$p($g(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)),"^",21)
 .Set BregMaxno=$p($g(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)),"^",1)
 .Set BregStartno=$p($g(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)),"^",27)
 .s NoWeeks=NoWeeks+1

 If Sess="" Quit ""
 ;fetch price 
 s ArcimDr="",chrhfee=""
 &SQL(SELECT ChrhFeeDr,chrhfee into :ArcimDr,:chrhfee from SQLUser.CHBCRegfee  where ChrhRoomDr=:RoomDr)
 i ArcimDr'=""  d 
 .s ArcimParDr=$p(ArcimDr,"||",1)
 .s Price=$p($g(^ARCIM(ArcimParDr,1,"ITP",1)),"^",4) 
 //查找已预约号和已预约并挂号的数	
 s AppQty=0 ;预约并挂号
 s ABregQty=0,ABregMno=""
 s AdmDateId=" "_AdmDate
 s CPDrId=" "_CPDr
 s DeptdrId=" "_Deptdr
 s AppRowId=0
 i BregStartno=""  s ABregMno=1
 e  s ABregMno=BregStartno
 f  Set AppRowId=$o(^User.DHCBeforeRegI("DateDeptDoc",AdmDateId,DeptdrId,CPDrId,AppRowId)) quit:(AppRowId="")  d
 .s AppFlag=$list(^User.DHCBeforeRegD(AppRowId),5)
 .s AppNo=$list(^User.DHCBeforeRegD(AppRowId),6)
 .if NoWeeks=AppNo s NoWeeks=NoWeeks+1
 .s ABregQty=ABregQty+1
 .i AppNo>ABregMno  s ABregMno=AppNo
 .if AppFlag="0" d 
 ..s AppQty=AppQty+1


 //有预约标志
 if ((QueryStatus'="S") & (QueryStatus'="D")){ 
 //设预排号要考虑预约的情况
 s NoWeeks=0
 s Patid=" "_QueryStatus
 s AppRowId=0
 s AppDep=""
	s AppDoc=""
 s FindStatus=""
 f  Set AppRowId=$o(^User.DHCBeforeRegI("PatidDate",Patid,AdmDateId,AppRowId)) quit:(AppRowId="")!(FindStatus'="")  d
 .S AppDep=$list(^User.DHCBeforeRegD(AppRowId),3)
 .S AppDoc=$list(^User.DHCBeforeRegD(AppRowId),4)
 .S AppFlag=$list(^User.DHCBeforeRegD(AppRowId),5)
 .s AppDate=$list(^User.DHCBeforeRegD(AppRowId),2)
 .if ((AppDep=Deptdr)&(AppDoc=CPDr)&(AppFlag="0")&(AppDate=AdmDate)) d
 ..s NoWeeks=$list(^User.DHCBeforeRegD(AppRowId),6)
 ..s FindStatus="Find"
 }

 if $g(RoomDr)=""{
 set re=""
 }else
 {
 Set LocDesc=$p(^CTLOC(RoomDr),"^",2)
	set AdmQty=Load-AdmQty
 Set re=Load_"^"_$g(AdmQty)_"^"_RoomDr_"^"_NoWeeks_"^"_LocDesc_"^"_Price_"^"_$g(AppQty)_"^"_Sess_"^"_chrhfee_"^"_BregMaxno_"^"_ABregQty_"^"_ABregMno_"^"_BregStartno_"^"_ResRowId_"||"_DateRowId_"||"_Sess
 }

 QUIT re
}

ClassMethod GetEncrypt(Method As %String)
{
	s encmeth=##Class(%CSP.Page).Encrypt($lb(Method))
	Quit encmeth
}

ClassMethod GetPatDetailBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 ;n id,code,desc
 ;
 Set (id,code,desc)=""
 ;
 Set PatDr=$o(^PAPERi("PAPMI_PatNo",$ZCVT(val,"U"),""))
 If PatDr="" {
	Set SQLCODE=1
	Set desc=val
	Quit 0
 }  Else {
	Set Name=$p(^PAPER(PatDr,"ALL"),"^",1)
 set RIDCardNo=$p($g(^PAPER(PatDr,"ALL")),"^",9)
	Set Age=+$p(^PAPER(PatDr,"ALL"),"^",6)
	Set Age=$p(((+$H-Age)/365)+0.5,".")
	Set Sex=$p(^CT("SEX",$p(^PAPER(PatDr,"ALL"),"^",7)),"^",2)
	Set OPMRN=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatDr,"O") //$p(^PAPER(PatDr,"PER",4),"^",4)
	Set IPMRN=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatDr,"I")  //$p(^PAPER(PatDr,"PAT",1),"^",22)
	set RAddress=$p(^PAPER(PatDr,"PER",4),"^",18) 
	Set PatCat=""
	Set PatCatDr=$p(^PAPER(PatDr,"PER",1),"^",10)
	If PatCatDr'="" Set PatCat=$p(^CT("SS",PatCatDr),"^",1)_"."_$p(^CT("SS",PatCatDr),"^",2)
	Set desc=Name_"^"_Age_"^"_Sex_"^"_OPMRN_"^"_IPMRN_"^"_PatCat_"^"_PatDr_"^"_RIDCardNo_"^"_RAddress
	Set SQLCODE=0
 }
 ;
 i SQLCODE s desc=val q 0
 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod OPDeptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPDeptListExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod OPDeptListExecute(ByRef qHandle As %Binary, UserId As %String) As %Status
{
 //
 Set repid=$I(^CacheTemp)
 //
	If $g(ind)="" Set ind=1
	Set RowId=0
	
	s UserId=$ZCVT(UserId,"U")

	//If $g(UserId)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserId,0))
	//s ^DHCApp=UserId

	//}
	//s UserId=" 2"
	s UserId=" "_UserId

	s UserRowId=0
	s RowIdOld=""
	If $g(UserId)="" do
	.f  Set RowId=$o(^CTLOC(RowId)) quit:RowId=""  d
 ..s CTCode=$p($g(^CTLOC(RowId)),"^",1)
 ..s CTCode=$ZCVT(CTCode,"L")
 ..s CTDesc=$p($g(^CTLOC(RowId)),"^",2)
 ..s CTRowId=RowId
 ..s CTType=$p($g(^CTLOC(RowId)),"^",13)
 ..Do OutputRow1
 Else  do
	.f  Set UserRowId=$o(^User.DHCUserGroupI("UserNamedr",UserId,UserRowId)) quit:UserRowId=""  d
 ..s RowId=$list(^User.DHCUserGroupD(UserRowId),4)
 ..if (RowIdOld '= RowId) do
 ...s CTCode=$p($g(^CTLOC(RowId)),"^",1)
 ...;ctcode come from  ^User.DHCRegKind
 ...s RegKindDocDr=$o(^User.DHCRegKindI("RegDeptDocIndex"," "_RowId,0))
 ...s RegKindRowid=$o(^User.DHCRegKindI("RegDeptDocIndex"," "_RowId,RegKindDocDr,0)) 
 ...s CTCode=$LIST(^User.DHCRegKindD(RegKindRowid),5)
 ...s CTCode=$ZCVT(CTCode,"U")
 ...s CTDesc=$p($g(^CTLOC(RowId)),"^",2)
 ...s CTRowId=RowId
 ...s CTType=$p($g(^CTLOC(RowId)),"^",13)
 ...s RowIdOld=RowId
 ...Do OutputRow1	

 Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	set Data=$lb(CTCode,CTDesc)
	//set ^DHCApp(ind)=CTCode_"^"_CTDesc
 Set ^CacheTemp(repid,CTDesc)=Data
 Set ind=ind+1
	quit
ResetVariables1
	///set (repid)=0
	set (CTRowId,CTCode,CTDesc,CTType)=""
	quit
}

ClassMethod OPDeptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDeptListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OPDocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPDocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod OPDocListExecute(ByRef qHandle As %Binary, Dept As %String) As %Status
{
 Set repid=$I(^CacheTemp)	

 Set DeptDr=""
 //s ^DHCApp=Dept
 s yn=Dept
 set UserId=$p($g(Dept),"^",2)
 set Dept=$p($g(Dept),"^",1)
 set ynda=$p($g(yn),"^",3)

 s tyn = $p($g(yn),"^",4)
 if tyn="1" d
 .set ynda=$ZDH(ynda,4)
 e  d
 .set ynda=..%SysDate()

 If $g(Dept)'="" Set DeptDr=$o(^CTLOC(0,"Desc",$tr($ZCVT(Dept,"U"),"-",""),""))
 If $g(ind)="" Set ind=1
	Set RowId=0
	If $g(DeptDr)'="" do
	.f  Set RowId=$o(^RB("RES",0,"CTLOC",DeptDr,RowId)) quit:RowId=""  d
	..Set DocDr=""
	..If ($D(^RB("RES",RowId))) do 
	...Set DocDr=$p(^RB("RES",RowId),"^",2)
	...set ScheSt=$p(^RB("RES",RowId),"^",6)
	..if (ScheSt'="Y") Quit
	..If DocDr="" Quit
	..s UserRowId=0
	..s UserDocDr=""
	..s FindStatus=""
	..s ABregno="",Bregmaxno=""
	..f  Set UserRowId=$o(^User.DHCUserGroupI("UserNamedr"," "_UserId,UserRowId)) quit:(UserRowId="")!(FindStatus'="")  d
 ...s UserDocDr=$list(^User.DHCUserGroupD(UserRowId),2)
	...;s ^DHCApp(ind)=DocDr
 ...if (UserDocDr=DocDr) S FindStatus=UserDocDr  	
 ..if (FindStatus="") quit
 ..s DocResValue=$$DocRes()
 ..//s ^DHCApp(ind)=DocResValue
 ..if (DocResValue=0) ! (DocResValue="") quit
 ..s AllowNum=$p(DocResValue,"^",2)
 ..s DocUnitPrice=$p(DocResValue,"^",6)
 ..s DocExamPrice=$p(DocResValue,"^",9)
 ..s RegKingRowid=$o(^User.DHCRegKindI("RegDeptDocIndex"," "_DeptDr," "_DocDr,0))
 ..s AbbDoc=""
 ..if RegKingRowid'="" s AbbDoc=$LIST(^User.DHCRegKindD(RegKingRowid),4)
 ..s AbbDoc=$ZCVT(AbbDoc,"U") 	 	
 ..Set DocCode=$p(^CTPCP(DocDr,1),"^",1)
 ..Set DocCode=$ZCVT(DocCode,"U")
 ..i '$d(^DHCOPRegConfig("AutoBregNO"))  d
 ...i $g(^DHCOPRegConfig("AutoBregno"))=1  d
 ....s ABregno=$p(DocResValue,"^",11)
 ....s Bregmaxno=$p(DocResValue,"^",10)
 ....s ABregMno=$p(DocResValue,"^",12)
 ....s BregStartno=$p(DocResValue,"^",13)
 ..s DocCode=DocCode_"&"_AbbDoc_"&"_DocUnitPrice_"&"_DocExamPrice ;_"&"_addr
 ..Set DocDesc=$p(^CTPCP(DocDr,1),"^",2)_" - "_AbbDoc_" - "_AllowNum
 ..;b
 ..i '$d(^DHCOPRegConfig("AutoBregNO"))  d
 ...i $g(^DHCOPRegConfig("AutoBregno"))=1  d
 ....s DocDesc=$p(^CTPCP(DocDr,1),"^",2)_" - "_AbbDoc_" - "_ABregno_" - "_Bregmaxno_" - "_BregStartno_" - "_ABregMno
 ..Do OutputRow2
 else  Do
	.Set DocCode=""
 .Set DocDesc=""
 .Do OutputRow2 	
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK

DocRes()

 s ResValue=##Class(web.DHCBreg).GetDocRegFee(DocDr,DeptDr,"D",ynda,tyn) 
 quit ResValue

OutputRow2
	set Data=$lb(DocCode,DocDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
ResetVariables2
	///set (repid)=0
	set (DocCode,DocDesc)=""
	quit
}

ClassMethod OPDocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDocListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod PAADMBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", pat As %Library.String = "", loc As %Library.String = "", doc As %Library.String = "", seqno As %Library.String = "", examfee As %Library.String = "", regfee As %Library.String = "", user As %Library.String = "", RegType As %Library.String = "", AppStatus As %Library.String = "", NappStatus As %Library.String = "")
{
 If $g(pat)="" quit 0
 If $g(loc)="" quit 0
 If $g(doc)="" quit 0
 s ^DHCApp="fff"
 set d=0
 Set Date=$ZD(+$H,3)
 Set Time=..%ZT(..%SysTime(),3)
 ;
 Set PatientID=pat
 Set AdmDate=..%SysDate()
 Set AdmTime=..%SysTime()
 Set AdmDoc=doc
 Set AdmDep=loc 
 Set RefDoc=""
 Set RefDate="" 
 Set Payor=""
 Set Plan=""
 Set PayorOffice=""
 Set InsDateFrom=""
 Set InsDateTo="" 
 Set EpisodeID=""
 Set AdmType="O" 
 Set Bed=""
 Set P0= ""
 Set P1="" 
 Set P2 = "" 
 Set P3 = "" 
 Set P4 = "" 
 Set P5= ""

 set RegTypeLocDr=""
 set RegTypeLocDr=$O(^CTLOC(0,"Desc",$tr($ZCVT(RegType,"U"),"-",""),""))

 Set ResRowId=$o(^RB("RES",0,"CTPCP",doc,loc,""))
 Set DateRowId=""
 If ResRowId'="" Set DateRowId=$O(^RB("RES",ResRowId,"DATE",""),-1)

 set AdmWeek=$ZD(+$H,10)
 If AdmWeek="0" Set AdmWeek="7"
 s DoDay=""
 s DoDay=ResRowId_"||"_DateRowId
 S Sess=""


 lock +^RB("RES",ResRowId,"DATE",DateRowId,"SESS",AdmWeek)

 Set SessRowId=0 f  s SessRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)) q:(SessRowId="")!(Sess'="")  d
 .Set DoWeek=+$p($g(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)),"^",2)
 .If AdmWeek'=DoWeek Quit 
 .Set Sess=SessRowId
 .Set NoWeeks=$p($g(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)),"^",21)

 if NoWeeks="" s NoWeeks=0
 s NoWeeks=NoWeeks+1
 //设预排号要考虑预约的情况

 s AppRowId=0
 s AdmDateId=" "_AdmDate
 s DeptdrId=" "_AdmDep
 s CPDrId=" "_AdmDoc
 f  Set AppRowId=$o(^User.DHCBeforeRegI("DateDeptDoc",AdmDateId,DeptdrId,CPDrId,AppRowId)) quit:(AppRowId="")  d
 .s AppFlag=$list(^User.DHCBeforeRegD(AppRowId),5)
 .s AppNo=$list(^User.DHCBeforeRegD(AppRowId),6)
 .if NoWeeks=AppNo s NoWeeks=NoWeeks+1

 Set Re=##Class(web.PAAdm).ADMInsert(PatientID,AdmDate,AdmTime,AdmDoc,AdmDep,RefDoc,RefDate,Payor,Plan,PayorOffice,InsDateFrom,InsDateTo,EpisodeID,AdmType,Bed,P0,P1,P2,P3,P4,P5)

 if ($g(Re)=""){
 s d=99
 }

 tstart

 &sql(update sqluser.RB_ResEffDateSession
 set SESS_NoApptSlot=SESS_NoApptSlot-1,SESS_NumberOfWeeks=:NoWeeks
 where SESS_ParRef =:DoDay and SESS_DOW_DR=:AdmWeek)  

 s d=d+SQLCODE  


 //插入日期时间操作者及就诊类型

 set PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
 i PatCatDr'="" set DHCPACADMDr=$o(^DHCPACADM(0,"Social",PatCatDr,""))
 set AdmReason=""
 if $g(DHCPACADMDr)'="" Do
 .set AdmReason=$p(^DHCPACADM(DHCPACADMDr),"^",2)

 If $g(Re)'="" Do
 .&SQL(Update SQLUser.PA_Adm Set PAAdm_CreateDate=:AdmDate,PAAdm_CreateTime=:AdmTime,PAAdm_CreateUser=:user,PAADM_AdmReason_DR=:AdmReason
 Where PAAdm_RowId=:Re)

 s d=d+SQLCODE  

 ;
 s v=^PAADM(0)

 s PaInrowid=v_"||"_"1",refrowid=v

 S Name=""
 s RegNo=""
 s Name=$p($g(^PAPER(PatientID,"ALL")),"^",1)
 s RegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)

 &sql(insert into sqluser.PA_AdmInsurance
 (INS_RowId,INS_ParRef,INS_Childsub,INS_InsType_DR,
 INS_CardholderName,INS_AuxInsType_DR,INS_DateTypeFrom,INS_MainInsuranceFlag)
 values(:PaInrowid,:refrowid,"1","28",:name,"4",:AdmDate,"Y"))
 s d=d+SQLCODE
 if NappStatus="T"
 {
	&sql(update DHCBeforeReg set Befregflag="1"
	where BefregDate=:AdmDate and befregdep=:AdmDep and befregdoc=:AdmDoc )
 s d=d+SQLCODE  

 }
 if AppStatus="T" 
 {
	&sql(update DHCBeforeReg set Befregflag="1"
	where BefregDate=:AdmDate and befregdep=:AdmDep and befregdoc=:AdmDoc and befregpid=:RegNo)
 s d=d+SQLCODE  

 }

 if (NappStatus'="T")&(AppStatus'="T")
 {
	 //非预约情况下重新取排队号
	// s ResValue=##Class(web.DHCOPAdm).GetDocRegFee(AdmDoc,AdmDep,"ReFetch")
	 s seqno=NoWeeks
 //s ^DHCApp=seqno
 } 


 &sql(insert into DHCRegistrationFee
 (RegfeeAdmDr,RegfeeName,RegfeeArcDr,RegfeeArcPrice,RegfeelookPrice,
 RegfeeBespFlag,RegfeeNo,RegfeeDoFlag,RegfeeArcDr)
 values(:refrowid,:Name,"",:regfee,:examfee,"No",:seqno,"Yes",:RegTypeLocDr))
 s d=d+SQLCODE

 //插入分诊排队记录表
 //先通过号别找诊室和诊区
 set MarkRowid=""
 set RoomDr=""
 set ExabDr=""
 set MarkRowid=$o(^User.DHCDepMarkI("DepmMarkDrIndex"," "_AdmDoc,0))

 if MarkRowid'="" {
	
 set ExabDr=$list(^User.DHCDepMarkD(MarkRowid),7)
 set AdmDep=$list(^User.DHCDepMarkD(MarkRowid),8)

 //"等候"状态rowid
 set PersDr=""
	set FirstDr=""
	 &sql(select ID into :PersDr from  DHCPerState where PersName="等候")
	 &sql(select ID into :FirstDr from  DHCFirstCode where firstcname="正常")
 &sql(insert into DHCQueue
 (QueDate,QuePersonId,QueName,QueExabDr,QueDepDr,QueMarkDr,QueNo,QuePaadmDr,QueStateDr,QueFirstDr)
 values(:AdmDate,:RegNo,:Name,:ExabDr,:AdmDep,:AdmDoc,:seqno,:Re,:PersDr,:FirstDr))

 s d=d+SQLCODE

 }

 if d=0 {
 TCommit
 }
 else {
 TRollback
 s seqno="error"}

 lock -^RB("RES",ResRowId,"DATE",DateRowId,"SESS",AdmWeek)

 //i +$g(Re)=0 s desc=val d
 s retval=itmjs_"('"_$ZCVT(seqno,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(seqno,"O","JS")_"');"
 &javascript<#(retval)#>

 q 1
}

ClassMethod PatBregBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Patid As %Library.String = "")
{
	s redesc=""
	s iPatid=" "_Patid
	s iBDate=" "_$p($h,",",1)
	s Befregid="" f  s Befregid=$o(^User.DHCBeforeRegI("PatidDate",iPatid,iBDate,Befregid)) q:Befregid=""  d
	.s TBefregRowid=$tr(Befregid," ")
	.s AppFlag=$list(^User.DHCBeforeRegD(TBefregRowid),5)
	.i AppFlag'=1  d
	..s BregLoc=$list(^User.DHCBeforeRegD(TBefregRowid),3)
	..s BregDoc=$list(^User.DHCBeforeRegD(TBefregRowid),4)
	..s BregNo=$list(^User.DHCBeforeRegD(TBefregRowid),6)
	..s LocDesc=$p($g(^CTLOC($tr(BregLoc," "))),"^",2)
	..s DocDesc=$p($g(^CTPCP($tr(BregDoc," "),1)),"^",2)
	..s BregType=$list(^User.DHCBeforeRegD(TBefregRowid),11)
	..s redesc=LocDesc_"^"_DocDesc_"^"_BregNo_"^"_$g(BregType)
	s retval=itmjs_"('"_$ZCVT(redesc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(redesc,"O","JS")_"');"
 &javascript<#(retval)#>
 q 0
}

ClassMethod QueryBregClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBregExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryBregExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LOCID As %String, DOCID As %String, PatNO As %String, PatName As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s ^TMPGwj=StartDate_"^"_EndDate_"^"_LOCID_"^"_DOCID_"^"_PatNO_"^"_PatName

 i (StartDate="")!(EndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
 s LocDesc="",DocDesc="",BPatNO="",BPatName="",BregNO="",BregFlag="",BregID=""
 s BregDate=""
 f pdate=StartDate:1:EndDate  d
 .s ppdate=" "_pdate
 .s BefregDep="" f  s BefregDep=$o(^User.DHCBeforeRegI("DateDeptDoc",ppdate,BefregDep)) q:BefregDep=""  d
 ..s newLOCID=" "_LOCID
 ..q:(BefregDep'=newLOCID)&(LOCID'="")
 ..s BefregDoc="" f  s BefregDoc=$o(^User.DHCBeforeRegI("DateDeptDoc",ppdate,BefregDep,BefregDoc)) q:BefregDoc=""  d
 ...s newDOCID=" "_DOCID
 ...q:(BefregDoc'=newDOCID)&(DOCID'="")
 ...s BefregRowid="" f  s BefregRowid=$o(^User.DHCBeforeRegI("DateDeptDoc",ppdate,BefregDep,BefregDoc,BefregRowid)) q:BefregRowid=""  d
 ....s BregID=$tr(BefregRowid," ")
 ....s LocDesc=$p($g(^CTLOC($tr(BefregDep," "))),"^",2)
 ....s DocDesc=$p($g(^CTPCP($tr(BefregDoc," "),1)),"^",2)
 ....s BPatNO=$list(^User.DHCBeforeRegD(BregID),7)
 ....q:BPatNO=""
 ....s BPatID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(BPatNO,"U"),""))
 ....q:(BPatNO'=PatNO)&(PatNO'="")
 ....s BPatName=$p($g(^PAPER(BPatID,"ALL")),"^",1)
	....q:(BPatName'=PatName)&(PatName'="")
 ....s BregFlag=$list(^User.DHCBeforeRegD(BregID),5)
 ....s BregNO=$list(^User.DHCBeforeRegD(BregID),6)
 ....s BregDate=$zd(pdate,4) 
 ....s BregType=$list(^User.DHCBeforeRegD(BregID),11)
 ....i BregType=""  s BregType="窗口预约"
 ....i BregType="5"  s BregType="诊间加号"
 ....s dateadd=$list(^User.DHCBeforeRegD(BregID),8)
 ....i dateadd'="" s BregDateAdd=$zd(dateadd,4) 
 ....e  s BregDateAdd=""
 ....s timeadd=$list(^User.DHCBeforeRegD(BregID),10)
 ....i timeadd'="" s BregTimeAdd=..%ZT(timeadd) 
 ....e  s BregTimeAdd=""
 ....s useradd=$list(^User.DHCBeforeRegD(BregID),12)
 ....i useradd'="" s BregUserAdd=$P(^SSU("SSUSR",useradd),"^",2) 
 ....e  s BregUserAdd=""
 ....Do OutputRow	 	

 Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow

	set Data=$lb(BregDate,LocDesc,DocDesc,BPatNO,BPatName,BregNO,BregFlag,BregID,BregType,BregDateAdd,BregTimeAdd,BregUserAdd)
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	quit
}

ClassMethod QueryBregFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBregExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindDocAlias(kindno) As %SQLQuery(CONTAINID = 1, ROWSPEC = "DeptDesc:%String,DocDesc:%String,Alias:%String,Deptdr:%String,Docdr:%String")
{
-- select CTLOC_Desc DeptDesc,ctpcp_desc DocDEsc,RegKindNo,RegKindDepDr,RegKindDocDr
--  from DHCRegKind,CT_Loc,CT_CareProv
--  where SUBSTR(regkinDno,3,length(:kindno))=:kindno
--  and RegKindDepDr=ctloc_rowid and RegKindDocDr=ctpcp_rowid1
select CTLOC_Desc ,CTLOC_Desc,CTLOC_Desc,CTLOC_Desc,CTLOC_Desc
 from SQLUser.CT_Loc
}

Query OPDeptList(UserId As %String) As %Query(ROWSPEC = "CTCode:%String,CTDesc:%String")
{
}

Query OPDocList(Dept As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String")
{
}

Query QueryBreg(StartDate As %String, EndDate As %String, LOCID As %String, DOCID As %String, PatNO As %String, PatName As %String) As %Query(ROWSPEC = "TBregDate:%String,TLoc:%String,TDoc:%String,TPatNO:%String,TPatName:%String,TBregNO:%String,TBregflag:%String,TBregID:%String,TBregType:%String,TBregDateAdd:%String,TBregTimeAdd:%String,TBregUserAdd:%String")
{
}

Query UFinddoc(depid) As %SQLQuery(CONTAINID = 1, ROWSPEC = "name:%String,id:%Integer")
{
SELECT RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR  FROM SQLUser.RB_RESOURCE
 WHERE (RES_CTLOC_DR = :depid and res_schedulerequired="Y")
}

}
