Include webimport

IncludeGenerator webimport

Class web.DHCExaBorDep Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod insertBorDep(itmjs As %Library.String = "", itmjsex As %Library.String = "", BordBorDr As %Library.String = "", BordDepDr As %Library.String = "", BordMemo As %Library.String = "")
{
 s ccode = ""
 &sql(SELECT id into :ccode FROM SQLUser.DHCExaBorDep 
 where BordBorDr=:BordBorDr and BordDepDr=:BordDepDr)
 if ccode="" d inbor
 if (itmjs'=""){
	 s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
	 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q 1
 }else{
	 Q:ccode'="" ccode
	 Q SQLCODE
 }
inbor
   &sql(insert into SQLUser.DHCExaBorDep
   (BordBorDr,BordDepDr,BordMemo)
    values(:BordBorDr,:BordDepDr,:BordMemo))
}

/// w ##class(web.DHCExaBorDep).updateBorDep("","",2,4,"",4)
ClassMethod updateBorDep(itmjs As %Library.String = "", itmjsex As %Library.String = "", BordBorDr As %Library.String = "", BordDepDr As %Library.String = "", BordMemo As %Library.String = "", id As %Library.String = "")
{
  
  s ccode = ""
  &sql(SELECT id into :ccode FROM SQLUser.DHCExaBorDep where BordBorDr=:BordBorDr and BordDepDr=:BordDepDr and id <>:id)
  if (ccode=""){
	  if (id'="") {
		  s OldBordDepDr=$lg(^User.DHCExaBorDepD(id),7)
		  s OldBordBorDr=$lg(^User.DHCExaBorDepD(id),6)
		  if (BordBorDr'=OldBordBorDr)||(BordDepDr'=OldBordDepDr) {
		  	d ..DelDepMarkMul(id)
		  }
	  }
	  &sql(update SQLUser.DHCExaBorDep
	  set BordBorDr=:BordBorDr,BordDepDr=:BordDepDr,BordMemo=:BordMemo
	 where id=:id)
  }
 if (itmjs'=""){
	 i SQLCODE=0 d
	 .s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
	 .i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
	 .&javascript<#(retval)#>
	 q 1
 }else{
	 q:ccode'="" ccode
	 Q SQLCODE
 }
}

ClassMethod DeleteBorDep(itmjs As %Library.String = "", itmjsex As %Library.String = "", id As %Library.String = "")
{
	d ..DelDepMarkMul(id)
 	&sql(delete From SQLUser.DHCExaBorDep where id=:id)
 	if (itmjs'=""){
		s retval=itmjs_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
	    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
	    &javascript<#(retval)#>
		q SQLCODE
	}else{
		q SQLCODE
	}
}

ClassMethod CheckDepMark(Bordr As %String, Deptdr As %String) As %String
{
	s id="",Find=0
	for {
		s id=$o(^User.DHCDepMarkI("DepmBorDrIndex",Bordr,id))
		q:(id="")||(Find=1)
		s DepmDepDr=$lg(^User.DHCDepMarkD(id),8)
		continue:DepmDepDr'=Deptdr
		s Find=1
	}
	Q Find
}

ClassMethod DelDepMarkMul(id) As %String
{
	s Bordr=$lg(^User.DHCExaBorDepD(id),6)
	s Deptdr=$lg(^User.DHCExaBorDepD(id),7)
	q:(Bordr="")&&(Deptdr="") 0
	&sql(delete From SQLUser.DHCDepMark where DepmBorDr=:Bordr AND DepmDepDr=:Deptdr)
	q SQLCODE
}

/// 获取分诊区科室对照列表
/// d ##class(%ResultSet).RunQuery("web.DHCExaBorDep","FindExaLoc","2","内分泌科门诊",2)
Query FindExaLoc(ExaId As %String, desc As %String = "", HospId As %String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "LocId:%String,CTDesc:%String,PoweredFlag:%String")
{
}

ClassMethod FindExaLocExecute(ByRef qHandle As %Binary, ExaId As %String, desc As %String = "", HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (ExaId=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	if HospId="" s HospId=%session.Get("LOGON.HOSPID")
	k ^Temp("QueryLocSortable",$j)
	s TypeStr="O^E"
	for i=1:1:$l(TypeStr,"^"){
		s Type=$p(TypeStr,"^",i)
		set myrowid=0
	 	for  {
		   s myrowid=$o(^PAC("ADMLOC",0,"AdmType",Type,myrowid)) q:myrowid=""
	 	   s CTCode1=myrowid 
	 	   s CTDesc=$p($g(^CTLOC(myrowid)),"^",2)
	 	   s ContactName=$P(^CTLOC(myrowid),"^",43)
	 	   //s DepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myrowid)
	 	   s DepHosDr=$p($g(^CTLOC(myrowid)),"^",22)
		   continue:((HospId'=DepHosDr)&&(HospId'=""))
	 	   continue:##class(web.DHCOPAdmReg).CheckLocDesc(myrowid,desc)'=1
		   continue:($P(^CTLOC(myrowid),"^",14)'="Y")
	 	   s CTLOCMarkNO=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.CTLoc","正式",myrowid)
	 	   s CTLOCMarkNO=$case($l(CTLOCMarkNO),0:"999",1:"00"_CTLOCMarkNO,2:"0"_CTLOCMarkNO,:CTLOCMarkNO)
	 	   s Sortable=CTLOCMarkNO_$$ALPHAUP^SSUTIL4(ContactName)
	 	   s PoweredFlag="N"
		   if (..CheckExaBorDep(ExaId,myrowid)=1) s PoweredFlag="Y"
	 	   s ^Temp("QueryLocSortable",$j,Sortable,myrowid)=CTDesc_"^"_PoweredFlag
	 	}
	}
	d OutPutSortRow
	k ^Temp("QueryLocSortable",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutSortRow
	s l1="" f  s l1=$o(^Temp("QueryLocSortable",$j,l1)) q:l1=""  d
	.s l2="" f  s l2=$o(^Temp("QueryLocSortable",$j,l1,l2)) q:l2=""  d
	..s info=$g(^Temp("QueryLocSortable",$j,l1,l2))
	..s LocId=l2
	..s CTDesc=$p(info,"^",1)
	..s PoweredFlag=$p(info,"^",2)
	..d DHCDocOut2
	q

DHCDocOut2
	set Data=$lb(LocId,CTDesc,PoweredFlag)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
}

/// 分诊区科室对照批量授权
/// w ##class(web.DHCExaBorDep).SaveExaBorDep(3,"","205")
ClassMethod SaveExaBorDep(ExaId As %String, inPara As %String, subPara As %String) As %String
{
	for i=1:1:$l(inPara,"!") {
		s LocId=$p(inPara,"!",i)
		if (..CheckExaBorDep(ExaId,LocId)=0) {
			d ..insertBorDep("","",ExaId,LocId,"")
		}
	}
	for i=1:1:$l(subPara,"!") {
		s LocId=$p(subPara,"!",i)
		s id="",FindId=""
		for {
			s id=$o(^User.DHCExaBorDepI("BordBorDrIndex",ExaId,id))
			q:(id="")||(FindId'="")
			s DepmDepDr=$lg(^User.DHCExaBorDepD(id),7)
			continue:DepmDepDr'=LocId
			s FindId=id
		}
		if (FindId'="") {
			d ..DeleteBorDep("","",FindId)
		}
	}
	Q 0
}

ClassMethod CheckExaBorDep(ExaId As %String, LocId As %String) As %String
{
	s id="",Find=0
	for {
		s id=$o(^User.DHCExaBorDepI("BordBorDrIndex",ExaId,id))
		q:(id="")||(Find=1)
		s DepmDepDr=$lg(^User.DHCExaBorDepD(id),7)
		continue:DepmDepDr'=LocId
		s Find=1
	}
	Q Find
}

}
