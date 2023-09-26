Class web.DHCNurRosterComm Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod setTmp(parr, tmp) As %String
{
	;w ##class(web.DHCNurRstNurInfo).setTmp(parr,.tmp)
	q:parr=""
	s tmp=""
	s l=$L(parr,"^")
	f i=1:1:l d
	.s item=$P(parr,"^",i)
	.q:item=""
	.s key=$P(item,"|",1)
	.s desc = $P(item,"|",2)
	.s tmp(key)=desc
	q 0
}

ClassMethod GetQueryData(QueryName As %String, parrm As %String, funname As %String) As %String
{
   s ^objcyf123(QueryName)=parrm_"^"_funname
   s l=$L(parrm,"!")
   s pp=""
   f i=1:1:l
   {
     s itm=$P(parrm,"!",i)
     s p=$P(itm,"$",1)
     s v=$P(itm,"$",2)
     s @p=v
     b
     if i<l s pp=pp_p_","
     e  s pp=pp_p 
     b
   }

   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()


 // Execute the query
  b
  s sc = rset.Execute(@pp)
  s i=0
  While (rset.Next()) {
       s coldata=""
       For col = 1:1:columns {
            s coldata=coldata_"'"_$ZCVT(rset.GetData(col),"O","JS")_"',"
        }

   s coldata=$e(coldata,0,$l(coldata)-1)
   s rtnval=funname_"("_coldata_");"
   b
  &javascript<#(rtnval)#>

      
 }
 Do rset.Close()
 //	    .//s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($g(inout),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($g(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"');"

 q 0
}

/// 查询所有病区
/// do ##class(%ResultSet).RunQuery("web.DHCNurRosterComm","FindAllWard","")
Query FindAllWard(parr As %String) As %Query(ROWSPEC = "WardId,WardCode,WardDesc") [ SqlProc ]
{
}

ClassMethod FindAllWardExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	set WardOrder=""
	for  set WardOrder = $O(^DHCMGNUR.MgNurPerWardI("WardOrd",WardOrder)) q:WardOrder=""  do
	.set WardRowId = $O(^DHCMGNUR.MgNurPerWardI("WardOrd",WardOrder,""))
	.set WardObj = ##class(DHCMGNUR.MgNurPerWard).%OpenId(WardRowId)
	.set WardId= WardObj.WardLoc
	.q:$d(^CTLOC(WardId))=0
	.set WardCode = $P(^CTLOC(WardId),"^",1)
	.set WardDesc = $P(^CTLOC(WardId),"^",2)
	.do OutputWardRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputWardRow      
	set Data=$lb(WardId,WardCode,WardDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAllWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// do ##class(%ResultSet).RunQuery("web.DHCNurRosterComm","GetWardData","")
Query GetWardData(parr As %String, input As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetWardDataExecute(ByRef qHandle As %Binary, parr As %String, input As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ssgrp=$P(parr,"^",1)
	s userid=$P(parr,"^",2)
	set WardOrder=""
	for  set WardOrder = $O(^DHCMGNUR.MgNurPerWardI("WardOrd",WardOrder)) q:WardOrder=""  do
	.set WardRowId = $O(^DHCMGNUR.MgNurPerWardI("WardOrd",WardOrder,""))
	.set WardObj = ##class(DHCMGNUR.MgNurPerWard).%OpenId(WardRowId)
	.set WardId= WardObj.WardLoc
	.q:$d(^CTLOC(WardId))=0
	.s flag=0
	.i ssgrp="znurhead" d
	..s usedr=$O(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(userid,"U"),""))
	..q:usedr=""
	..s largeloccode=$O(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_$zcvt(usedr,"U"),""))
	..q:largeloccode=""
	..s mcuid=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ",largeloccode,WardId,""))
	..q:mcuid=""
	..s flag=1
	.e  s flag=1
	.q:flag=0
	.set WardCode = $P(^CTLOC(WardId),"^",1)
	.set WardDesc = $P(^CTLOC(WardId),"^",2)
	.quit:(WardDesc'[input)&(WardDesc'[$zcvt(input,"U"))
	.set ret="WardCode|"_WardCode_"^WardDesc|"_WardDesc_"^rw|"_WardId
	.do OutputWard
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputWard     
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetWardDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetWardDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// do ##class(%ResultSet).RunQuery("web.DHCNurRosterComm","FindCommDicSubData","班次分类")
Query FindCommDicSubData(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCommDicSubDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	set cdid = $O(^DHCMGNUR.CommDictionaryI("Code"," "_$zcvt(parr,"U"),""))
	if (cdid="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s cdsid="" f  s cdsid = $O(^DHCMGNUR.CommDictionarySubD(cdid,cdsid)) q:cdsid=""  d
	.s id=cdid_"||"_cdsid
	.s cdsobj = ##class(DHCMGNUR.CommDictionarySub).%OpenId(id)
	.s codedesc = cdsobj.CodeDesc
	.s code=cdsobj.Code
	.s ret="rw|"_$tr(id,"||","__")_"^Code|"_code_"^Desc|"_codedesc
	.do OutputCommDic
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCommDic
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCommDicSubDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCommDicSubDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod FindCommDicSubDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCommDicSubDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod getPersonVal(parr As %String) As %String
{
	q:parr=""
	s ID=$O(^DHCMGNUR.MgPersonsI("SSID"," "_parr,""))
	q:ID=""
	s a=##class(DHCMGNUR.MgPersons).%OpenId(ID)
	s TempDepDR=a.PersonTempDepDR
	s ret="TempDepDR|"_TempDepDR
	q ret
}

/// 
/// MethodDescription:同步老版排班岗位代码
/// d ##class(web.DHCNurRosterComm).LoadPostData()
ClassMethod LoadPostData()
{
	k ^DHCMGNUR.MgNurPostI
	k ^DHCMGNUR.MgNurPostD
	k ^DHCMGNUR.MgNurWardPostI
	k ^DHCMGNUR.MgNurWardPostD
	s count1=0
	s mgpostid="" f  s mgpostid=$O(^User.DHCMGPostD(mgpostid)) q:mgpostid=""  d
	.q:+mgpostid=0
	.s a=##class(User.DHCMGPost).%OpenId(mgpostid)
	.s b=##class(DHCMGNUR.MgNurPost).%New()
	.s c=##class(DHCMGNUR.MgNurWardPost).%New()
	.s b.PostCode=a.PostCode
	.s b.PostDesc=a.PostDesc
	.s b.PostPerNum=a.PostPerNums
	.s b.PostHours=a.PostMaxTime
	.s b.PostNightHours=a.PostNightHour
	.s:a.PostFlag="Y" b.PostType="30||2"
	.s:a.PostFlag="N" b.PostType="30||1"
	.s:a.PostTypDr="5" b.PostWorkType="31||3"
	.s:a.PostTypDr="6" b.PostWorkType="31||2"
	.s:a.PostTypDr="7" b.PostWorkType="31||1"
	.s:a.PostTypDr="8" b.PostWorkType="31||4"
	.s b.PostHoliday=a.PostHolFlag
	.s b.PostStTime=a.PostStartTime
	.s b.PostEndTime=a.PostEndTime
	.s b.PostRemarks=a.Postmem
	.;s b.PostOrder=##class(DHCMGNUR.MgNurPost).getCount()+1
	.i a.PostCurrFlag="N" s b.PostValid="Y",count1=count1+1,b.PostOrder=count1
	.e  s b.PostValid="N"
	.s sc=b.%Save()
	.;s count1=count1+1 
	.;w !,count1,$System.Status.DisplayError(sc)
	.q:a.PostCurrFlag'="N"
	.s id=b.%Id()
	.s c.PostID=id
	.s c.PostWard=a.PostLocDr
	.s c.PostOrder=c.getCount(a.PostLocDr)+1
	.d c.%Save()
	q 1
}

/// 
/// 休假代码同步
/// d ##class(web.DHCNurRosterComm).LoadHolidayData()
ClassMethod LoadHolidayData()
{
	s hldid="" f  s hldid=$O(^User.DHCMGCHolidayD(hldid)) q:hldid=""  d
	.q:+hldid=0
	.s hld=##class(User.DHCMGCHoliday).%OpenId(hldid)
	.s mghld=##class(DHCMGNUR.MgNurHolidayCode).%New()
	.s mghld.HolidayCode=hld.HolCode
	.s mghld.HolidayDesc=hld.HolDesc
	.i hld.HolCurrFlag="N" s mghld.HolidayStatus="Y"
	.e  s mghld.HolidayStatus="N"
	.d mghld.%Save()
}

ClassMethod HasBed(wardid As %String) As %String
{
	q:wardid="" 0
	s pawardid=$O(^PAWARD(0,"WARD_LocationDR",wardid,""))
	q:pawardid="" 0
	q:$d(^PAWARD(pawardid,"BED"))=0 0
	q 1
}

}
