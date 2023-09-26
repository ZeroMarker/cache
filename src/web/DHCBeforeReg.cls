Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCBeforeReg Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 182;

Parameter SQLCODE = "ID";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "ID";

Parameter SQLROWID = "ID";

ClassMethod DeleteBeforeBreg(Rowid As %String) As %String
{
	&SQL(Delete From SQLUser.DHCBeforeReg where ID=:Rowid)
	Q SQLCODE
}

ClassMethod DocMarkListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DocMarkListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DocMarkListExecute(ByRef qHandle As %Binary, DepID As %String, DocID As %String, AdmDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	i DepID="" s DepID=%session.Get("LOGON.CTLOCID")
	i DocID="" s DocID=$P(^SSU("SSUSR",%session.Data("LOGON.USERID")),"^",14)
	i AdmDate="" s AdmDate=+$h
	s MarkRowid=0 F  S MarkRowid=$O(^User.DHCMarkDocI("MarkdDocMarkIndex"," "_DocID,MarkRowid)) Quit:(MarkRowid="")  Do
	. s MarkID=$TR(MarkRowid," ")
	. s Mark=$P($G(^CTPCP(MarkID,1)),"^",2)
	. s Rowid=0 F  S Rowid=$O(^User.DHCMarkDocI("MarkdDocMarkIndex"," "_DocID,MarkRowid,Rowid)) Quit:(Rowid="")  Do
	.. s MarkDepID=$list(^User.DHCMarkDocD(Rowid),4)
	.. Q:MarkDepID'=DepID
	.. s ResRowId=$o(^RB("RES",0,"CTPCP",MarkID,DepID,0))
	.. Q:ResRowId=""  
	.. s ScheSt=$p(^RB("RES",ResRowId),"^",6)
	.. Q:(ScheSt'="Y")
	.. s DateRowId=""
	.. If ResRowId'="" Set DateRowId=$O(^RB("RES",ResRowId,"DATE",""),-1)
	.. Q:DateRowId=""
	.. s Sess=..GetDocRes(ResRowId,DateRowId,AdmDate)
	.. ;w "Sess:"_Sess,!
	.. Q:Sess=""
	.. s MarkDesc=$p(^CTPCP(MarkID,1),"^",2)
	..Do OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(MarkDesc,MarkID,Sess)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
ResetVariables2
	///set (repid)=0
	set (MarkDesc,MarkID,Sess)=""
	quit
}

ClassMethod DocMarkListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DocMarkListExecute ]
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

ClassMethod FindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindExecute(ByRef qHandle As %Binary, CurrDate As %String, DepID As %String, DocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	i CurrDate="" s datenum=+$h
	e  s datenum=$ZDH(CurrDate,4)
	i DepID="" s DepID=%session.Get("LOGON.CTLOCID")
	i DocID="" s DocID=$P(^SSU("SSUSR",%session.Data("LOGON.USERID")),"^",14)
	s Dep=$P(^CTLOC(DepID),"^",2)
	s MarkRowid=0 F  S MarkRowid=$O(^User.DHCMarkDocI("MarkdDocMarkIndex"," "_DocID,MarkRowid)) Quit:(MarkRowid="")  Do
	. s MarkID=$TR(MarkRowid," ")
	. s Mark=$P($G(^CTPCP(MarkID,1)),"^",2)
	. s RowId=0 f  S RowId=$o(^User.DHCBeforeRegI("DateDeptDoc"," "_datenum," "_DepID," "_MarkID,RowId)) Quit:(RowId="")  Do
	.. s Date=$list(^User.DHCBeforeRegD(RowId),2)
	.. s Date=$ZD(Date,3)
	.. s Time=$list(^User.DHCBeforeRegD(RowId),13)
	.. i Time'="" s Time=$ZT(Time)
	.. s Pid=$list(^User.DHCBeforeRegD(RowId),7)
	.. s Flag=$list(^User.DHCBeforeRegD(RowId),5)
	.. s No=$list(^User.DHCBeforeRegD(RowId),6)
	.. s TypeID=$list(^User.DHCBeforeRegD(RowId),11)
	.. s Type=""
	.. i TypeID=1 s Type="诊间"
	.. i TypeID=2 s Type="挂号窗口"
	.. i TypeID=3 s Type="电话"
	.. i TypeID=4 s Type="网上"
	.. i TypeID=5 s Type="诊间加号"
	.. s UserAddRowid=$list(^User.DHCBeforeRegD(RowId),12)
	.. i UserAddRowid'="" s UserAdd=$P(^SSU("SSUSR",UserAddRowid),"^",2) 
	.. s DateAdd=""
	.. s DateAddNum=$list(^User.DHCBeforeRegD(RowId),8)
	.. if DateAddNum'="" s DateAdd=$ZD(DateAddNum,3)
	.. s TimeAddNum=$list(^User.DHCBeforeRegD(RowId),10)
	.. i TimeAddNum'="" s TimeAdd=$ZT(TimeAddNum)
	.. e  s TimeAdd=""
	.. s Notes=$list(^User.DHCBeforeRegD(RowId),9)
	.. d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	set Data=$lb(Date,Time,Dep,Mark,No,Pid,Flag,Type,UserAdd,DateAdd,TimeAdd,Notes,RowId,DepID,DocID,TypeID)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables1
	set (Date,Time,Dep,Mark,No,Pid,Flag,Type,UserAdd,DateAdd,TimeAdd,Notes,RowId,DepID,DocID,TypeID)=""
	quit
}

ClassMethod FindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExecute ]
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

ClassMethod Findbno(dep As %String, doc As %String, bno As %String, da As %String, pno As %String) As %String
{
	s da=$ZDH(da,3)
	&sql(SELECT BefregNo into :no FROM DHCBeforeReg 
	where BefregDep=:dep and 
	BefregDoc=:doc and BefregNo=:bno and BefregDate=:da)
 i SQLCODE=100  d
 .&sql(SELECT BefregNo into :no FROM DHCBeforeReg 
	      where BefregDep=:dep and 
	      BefregDoc=:doc and BefregPid=:pno and BefregDate=:da)
 .i SQLCODE=100  d
 ..&sql(insert into DHCBeforeReg
	     (BefregDep,BefregDoc,BefregNo,BefregDate,BefregFlag,BefregPid)
	     values(:dep,:doc,:bno,:da,"0",:pno)) 
	     ..i SQLCODE=0  d
	     ...&Javascript<alert("保存成功");>
 .e  d
 ..&Javascript<alert("今天此人已经预约过此医生的号");>
 e  d
 .&Javascript<alert("此号已经预约");>

 q:SQLCODE'=0 ""
 q 0
}

ClassMethod GetBregMaxNo(RegDate As %String, DepID As %String, DocID As %String) As %String
{
	&SQL(SELECT Max(BefregNo) into :MaxNo FROM DHCBeforeReg 
	Where BefregDep=:DepID and BefregDoc=:DocID and BefregDate=:RegDate and BefregType="5")
	Q MaxNo
}

ClassMethod GetDocMarkListBroker(itmjs As %Library.String = "", DepID As %String, DocID As %String, AdmDate As %String) As %String
{
	i AdmDate'="" s AdmDate=##Class(websys.Conversions).DateHtmlToLogical(AdmDate)
	Set obj=##class(%ResultSet).%New("web.DHCBeforeReg:DocMarkList")
	d obj.Execute(DepID,DocID,AdmDate)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("Desc")
	.s Rowid=obj.Data("Rowid")
	.s SessRowid=obj.Data("SessRowid")
	.s val=$g(Desc)_"^"_$g(Rowid)_"^"_$g(SessRowid)
	.s retval=itmjs_"('"_$ZCVT(val,"O","JS")_"');"
	.&javascript<#(retval)#>
	d obj.Close()
	q 0
}

ClassMethod GetDocRes(ResRowId As %String, DateRowId As %String, AdmDate As %String) As %String
{
	 s Sess=""
	 s CurrDate=$P($H,",",1)
	 s CurrTime=$P($H,",",2)
	 s AdmWeek=$ZD(AdmDate,10)
	 If AdmWeek="0" Set AdmWeek="7"
	Set SessRowId=0 f  s SessRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)) q:(SessRowId="")!(Sess'="")  d
	.Set StartTime=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",4)
	.Set EndTime=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",5)
	.Set DoWeek=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",2)
	.Set status=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",14)
	.Quit:status'="1"
	.;If AdmTime'>StartTime Quit
	.;If AdmTime'<EndTime Quit
	.Quit:AdmWeek'=DoWeek 
	.Quit:(AdmDate=CurrDate)&&(CurrTime>EndTime)
	.Set Sess=ResRowId_"||"_DateRowId_"||"_SessRowId
	quit Sess
}

ClassMethod InsertBeforeBreg(SessRowId As %String, RegDate As %String, RegTime As %String, PatientNo As %String = "", RegNo As %String = "", UserAddRowid As %String)
{
 s RegDate=$ZDH(RegDate,4)
 i RegTime'="" s RegTime=$ZTH(RegTime)

	s ResRowId=$P(SessRowId,"||",1)
	s DateRowId=$P(SessRowId,"||",2)
	s SessRowId=$P(SessRowId,"||",3)
	s DepID=$p(^RB("RES",ResRowId),"^",1)
	s DocID=$p(^RB("RES",ResRowId),"^",2)
	
	s DateAdd=+$h
	s TimeAdd=$P($h,",",2)
	S MaxAppCount=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",1)
	s MaxAdmCount=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",8)
	;s MaxCount=MaxAppCount+MaxAdmCount
	s MaxCount=MaxAdmCount
	;i RegNo="" {
	;	&SQL(SELECT Max(BefregNo) into :MaxNo FROM DHCBeforeReg 
	;	Where BefregDep=:DepID and BefregDoc=:DocID and BefregDate=:RegDate and BefregType="5")
	;    if (MaxNo="")!(MaxNo=0) s RegNo=MaxCount+1
	;	else  s RegNo=MaxNo+1
	;}//lrl modified 2007-10-09
	i RegNo="" {
		&SQL(SELECT Max(BefregNo) into :MaxNo FROM DHCBeforeReg 
		Where BefregDep=:DepID and BefregDoc=:DocID and BefregDate=:RegDate)
	    s MaxNo=+MaxNo
	    if MaxNo<MaxCount s RegNo=MaxCount+1
		else  s RegNo=MaxNo+1
	}
	s no=""
	&SQL(SELECT BefregNo into :no FROM DHCBeforeReg 
	where BefregDep=:DepID and BefregDoc=:DocID and BefregNo=:RegNo and BefregDate=:RegDate)
	i SQLCODE=100  d
	.&SQL(SELECT BefregNo into :no FROM DHCBeforeReg 
	  Where BefregDep=:DepID and BefregDoc=:DocID and BefregPid=:PatientNo and BefregDate=:RegDate)
	.i SQLCODE=100  d 
	..&SQL(insert into DHCBeforeReg(BefregDep,BefregDoc,BefregNo,BefregDate,BefregTime,BefregFlag,BefregPid,BefregType,BefregUserAdd,BefregDateAdd,BefregTimeAdd)
	         Values(:DepID,:DocID,:RegNo,:RegDate,:RegTime,"0",:PatientNo,"5",:UserAddRowid,:DateAdd,:TimeAdd))
	..;保存成功
	..i SQLCODE=0  s ret=0
	..e  s ret=SQLCODE
	.e  d
	..;今天此人已经预约过此医生的号
	..s ret=1
	e  d
	.;此号已经预约
	.s ret=2
	Q ret
}

ClassMethod delbno(rid As %String) As %String
{
 &sql(delete from DHCBeforeReg
 where %ID=:rid)
}

ClassMethod delbreg(itmjs As %Library.String = "", itmjsex As %Library.String = "", rid As %Library.String = "")
{
 &sql(delete From SQLUser.DHCBeforeReg where id=:rid and befregflag=0)
	s retval=itmjs_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
 &javascript<#(retval)#>
	q SQLCODE
}

ClassMethod findbreg(itmjs As %Library.String = "", itmjsex As %Library.String = "", dep As %String, doc As %String, da As %String)
{
 Set repid=$I(^CacheTemp)

	If $g(ind)="" Set ind=1
	
	s da=$ZDH(da,4)
	s ff=""
	
 s myrowid=0
	for  s myrowid=$o(^User.DHCBeforeRegD(myrowid)) q:myrowid=""  d   
		.s depid=$List(^User.DHCBeforeRegD(myrowid),3)
		.s docid=$List(^User.DHCBeforeRegD(myrowid),4)
		.s da1=$List(^User.DHCBeforeRegD(myrowid),2)
		
		.i (depid=dep)&&(docid=doc)&&(da1=da) d  
		..s DepDesc=$p($g(^CTLOC(depid)),"^",2)
		..i $f(DepDesc,"-")'=0  d
 ...s DepDesc=$p(DepDesc,"-",2)
 ..s DocDesc=$p($g(^CTPCP(docid,1)),"^",2)
		..s rno=$List(^User.DHCBeforeRegD(myrowid),7)
		..i rno="" d  s rno="无" 
		..s PatName=""
		..s PapmiRowid=0
		..i rno'=""  d
		...s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",$ZCVT(rno,"U"),PapmiRowid))
		...s PatName=$p($g(^PAPER(PapmiRowid,"ALL")),"^",1)
		..s bno=$List(^User.DHCBeforeRegD(myrowid),6)
		..s yn=$List(^User.DHCBeforeRegD(myrowid),5)
		..i yn="0" d  s yn="否"
		..i yn="1" d  s yn="是"
		
		..i ff="" d
		...s ff=rno_"!"_bno_"!"_yn_"!"_myrowid_"!"_DepDesc_"!"_DocDesc_"!"_PatName
		..e  d
		...s ff=ff_"^"_rno_"!"_bno_"!"_yn_"!"_myrowid_"!"_DepDesc_"!"_DocDesc_"!"_PatName
		.e  d  q

 s retval=itmjs_"('"_$ZCVT(ff,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ff,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1

 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod insertbreg(itmjs As %Library.String = "", itmjsex As %Library.String = "", dep As %Library.String = "", doc As %Library.String = "", bno As %Library.String = "", da As %Library.String = "", pno As %Library.String = "")
{
 s Retcode=0
 s da=$ZDH(da,4)
 s no=""
 ;&sql(select DepmBorDr into :zq from DHCDepMark where DepmMarkDr=:doc and depmstate="2" and depmsign="Y")
 ;i SQLCODE=100 d 
 .;&Javascript<alert("此号别没有关联诊区,不能预约");>

 ;q:SQLCODE'=0 2
 &sql(SELECT BefregNo into :no FROM DHCBeforeReg 
	where BefregDep=:dep and BefregDoc=:doc and BefregNo=:bno and BefregDate=:da)
 i SQLCODE=100  d
 .&sql(SELECT BefregNo into :no FROM DHCBeforeReg 
	      where BefregDep=:dep and 
	      BefregDoc=:doc and BefregPid=:pno and BefregDate=:da)
 .i SQLCODE=100  d inbor

	     ..;i SQLCODE=0  d
	     ...;&Javascript<alert("保存成功");>
 .e  d
 ..&Javascript<alert("今天此人已经预约过此医生的号");>
 ..s Retcode=1
 e  d
 .&Javascript<alert("此号已经预约");>
 .s Retcode=1

 s retval=itmjs_"('"_$ZCVT(no,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(no,"O","JS")_"');"
 &javascript<#(retval)#>

 q Retcode
inbor
 ;s ^GWJ=dep_"^"_doc_"^"_bno_"^"_da_"^"_"0"_"^"_pno
 s AddDate=+$H
 s AddTime=$P($H,",",2)
 s AddUser=%session.Get("LOGON.USERID")
 &sql(insert into DHCBeforeReg
	     (BefregDep,BefregDoc,BefregNo,BefregDate,BefregFlag,BefregPid,BefregType,BefregUserAdd,BefregDateAdd,BefregTimeAdd)
	     values(:dep,:doc,:bno,:da,"0",:pno,"1",:AddUser,:AddDate,:AddTime))
 s Retcode=0
}

ClassMethod rdate(da As %String) As %String
{
	s date=$ZDH(da,3)
	q date
}

ClassMethod selno(dep As %String, doc As %String, pid As %String) As %String
{
 s date=$P($H,",",1)
 &sql(select  BefregNo,BefregFlag into 
bno,:flag from DHCBeforeReg
 where BefregDate=:date and BefregDep=:dep
 and BefregDoc=:doc  and BefregPid=:pid) 
 s P6=$P($g(bno),$C(1))_"^"_$P($g(flag),$C(1))
 i SQLCODE=0 q P6
 e  q "n"
}

Query DocMarkList(DepID As %String, DocID As %String, AdmDate As %String) As %Query(ROWSPEC = "Desc:%String,Rowid:%String,SessRowid:%String")
{
}

Query Find(dep As %String, doc As %String, date As %String) As %Query(CONTAINID = 1, ROWSPEC = "Date:%String,Time:%String,Dep:%String,Mark:%String,No:%String,Pid:%String,Flag:%String,Type:%String,UserAdd:%String,DateAdd:%String,TimeAdd:%String,Notes:%String,RowId:%String,DepID:%String,DocID:%String,TypeID:%String")
{
}

Query UFindbreg(depid, docid, da) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Trno:%String,Tbno:%String,Tyn:%String,Tid:%String")
{
 SELECT BefregPid,BefregNo,BefregFlag,id
 From DHCBeforeReg
 where BefregDep=:depid and BefregDoc=:docid and TO_DATE(BefregDate,'DD/MM/YYYY')=:da
}

Query fbno(dep, doc, da) As %SQLQuery(CONTAINID = 1, ROWSPEC = "BefregPid:%String,BefregNo:%String,BefregFlag:%String,%ID:%Integer")
{
 select  BefregPid,BefregNo,BefregFlag,%ID from DHCBeforeReg where
 BefregDep=:dep and  BefregDoc=:doc and BefregDate=:da ORDER BY BefregNo
}

Query selyyno(dep, doc, da) As %SQLQuery(CONTAINID = 1, ROWSPEC = "BefregNo:%String")
{
select  BefregNo from DHCBeforeReg where
BefregDep=:dep and  BefregDoc=:doc  ORDER BY BefregNo
}

}
