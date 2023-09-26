/// 健康教育评估公共类
Class web.DHCNurHlthEduComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

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

/// 获取医嘱信息
/// do ##class(%ResultSet).RunQuery("web.DHCNurHlthEduComm","FindDocAdvice","76")
Query FindDocAdvice(EpisodeID As %String) As %Query(ROWSPEC = "OEORDSign:%String,DocAdvcInfo:%String,DocAdvcStDate:%String,DocAdvcStTime:%String")
{
}

ClassMethod FindDocAdviceExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i (EpisodeID="")
	{
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	s OEORDSign="old" 
	s OEOrderID = "" 
	f  s OEOrderID = $O(^OEORD(0,"Adm",EpisodeID,OEOrderID)) q:OEOrderID=""  do
	.//s OEORDDate=$P(^OEORD(OEOrderID),"^",2)
	.//i OEORDDate=$P($H,",",1) s OEORDSign="new"
	.//s OEORDTime=$P(^OEORD(OEOrderID),"^",3)
	.s OEORIChildsub=0
	.f  s OEORIChildsub = $O(^OEORD(OEOrderID,"I",OEORIChildsub)) q:OEORIChildsub=""  do
	..s OEORIItmMastDR = $P(^OEORD(OEOrderID,"I",OEORIChildsub,1),"^",2)
	..s OEORIStDate = $P(^OEORD(OEOrderID,"I",OEORIChildsub,1),"^",9)
	..if OEORIStDate=$P($H,",",1) s OEORDSign="new"
	..s OEORIStTime = $P(^OEORD(OEOrderID,"I",OEORIChildsub,1),"^",10)
 	..s ARCIMSubscript = $P(OEORIItmMastDR,"||",1)
	..s ARCIMVersion = $P(OEORIItmMastDR,"||",2)
	..s ARCIMDesc = $P(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)
	..s OEOrdStatusSub = $O(^OEORD(OEOrderID,"I",OEORIChildsub,"ST",0))
	..s OECOrdStatusSub = $P(^OEORD(OEOrderID,"I",OEORIChildsub,"ST",OEOrdStatusSub),"^",3)
	..s OECOrdStatusCode = $P(^OEC("OSTAT",OECOrdStatusSub),"^",1)
	..q:OECOrdStatusCode="D" 
	..d OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow   
	set Data=$lb(OEORDSign,ARCIMDesc,$Zd(OEORIStDate,3),$zt(OEORIStTime,1))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDocAdviceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocAdviceExecute ]
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

ClassMethod FindDocAdviceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocAdviceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*ClassMethod GetPerson(ids As %String) As %String
{
 //s a=##class(web.DHCMGNurComm).GetPerson()
     q:"" ""
     s ids=$ZConvert(ids,"U")

	 s id=" "_ids
	 s ln=$L(" "_ids)
	 s im=" "_ids
	 s flag=0
	 s ret=""
	 s rw="" s rw=$O(^User.DHCMGPersonsI("SSID",id,rw))
	 if rw'=""  d sa
	 f  s id=$O(^User.DHCMGPersonsI("SSID",id)) q:(id="")!(flag=1)  d
	 .if $E(id,0,ln)'=im s flag=1
	 .s rw=""  f  s rw=$O(^User.DHCMGPersonsI("SSID",id,rw)) q:rw=""!(flag=1)  d
     ..d sa
     ..
   q ret
sa
 	 s parr=^User.DHCMGPersonsD(rw)
     s name=$list(parr,21)
     s ret=ret_rw_"|"_name_"^"
    q
}*/
/// w ##class(web.DHCNurHlthEduComm).GetPerson("6253")
ClassMethod GetPerson(ids As %String) As %String
{
 //s a=##class(web.DHCMGNurComm).GetPerson()
     q:"" ""
     s ids=$ZConvert(ids,"U")

	 s id=ids
	 s ln=$L(ids)
	 s im=ids
	 s flag=0
	 s ret=""
	 s rw="" s rw=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(id),rw))
	 if rw'=""  d sa
	 f  s id=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(id))) q:(id="")!(flag=1)  d
	 .if $E(id,0,ln)'=im s flag=1
	 .s rw=""  f  s rw=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(id),rw)) q:rw=""!(flag=1)  d
     ..d sa
     ..
   q ret
sa
 	 s parr=$G(^SSU("SSUSR",rw))
     s name=$P(parr,"^",2)
     s ret=ret_rw_"|"_name_"^"
    q
}

/// 获取病人信息
/// do ##class(web.DHCNurHlthEduComm).getPatientInfo(1)
ClassMethod getPatientInfo(EpisodeID As %String) As %String
{
	q:EpisodeID=""
	q:$d(^PAADM(EpisodeID))=0
	s PAADMPAPMIDR= $P(^PAADM(EpisodeID),"^",1)
	s PAADMBedRowId = $p(^PAADM(EpisodeID),"^",73)
	s PAADMDepCodeDR = $P(^PAADM(EpisodeID),"^",4)
	s CTLocDesc = $P(^CTLOC(PAADMDepCodeDR),"^",1)
	s BedCode=""
	if (PAADMBedRowId'="") do
	.s WardRowId = $P(PAADMBedRowId,"||",1)
	.s BedSub = $P(PAADMBedRowId,"||",2)
	.s BedCode = $P(^PAWARD(WardRowId,"BED",BedSub),"^",1)
	s PAPMIName = $P(^PAPER(PAADMPAPMIDR,"ALL"),"^",1)
	s PAPMINo =  $P(^PAPER(PAADMPAPMIDR,"PAT",1),"^",1)
	s PaPMISex = $P(^PAPER(PAADMPAPMIDR,"ALL"),"^",7)
	s CTSexDesc = $P(^CT("SEX",PaPMISex),"^",2)
	s Age = $$CalAge^at182($p(^PAPER(PAADMPAPMIDR,"ALL"),"^",6),$h)
	s PAPersonAge = $P(Age,"|",12)_"岁"
	;s PAPersonDR  = PAADMPAPMIDR
	;s PAPersonDob = $P(^PAPER(PAPersonDR,"ALL"),"^",6)
	;S PAPersonYear = $P($ZD(PAPersonDob,3),"-",1)
	;s NowYear = $P($zd($P($H,",",1),3),"-",1)
	//w !,PAPersonYear_"^"_NowYear
	;s PAPersonAge=(NowYear-PAPersonYear)
	//w !,(NowYear-PAPersonYear),!
	s ret = PAPMIName_"^"_PAPMINo_"^"_CTSexDesc_"^"_PAPersonAge_"^"_BedCode_"^"_CTLocDesc
	//w !,ret
	q ret
}

/// 查询所有病区
/// do ##class(%ResultSet).RunQuery("web.DHCNurHlthEduComm","FindAllWardData","")
Query FindAllWardData(parr As %String) As %Query(ROWSPEC = "WardRowId,WardCode,WardDesc")
{
}

ClassMethod FindAllWardDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	set WardRowId = ""
	for  set WardRowId=$O(^CTLOC(0,"LocType","W",WardRowId)) q:WardRowId=""  do
	.set WardCode = $P(^CTLOC(WardRowId),"^",1)
	.q:WardCode["停用"
	.//i $F(WardCode,"停用")'=0 d
	.set WardDesc = $P(^CTLOC(WardRowId),"^",2)
	.do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(WardRowId,WardCode,WardDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllWardDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllWardDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAllWardDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllWardDataExecute ]
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

/// 查询健康教育评估项目对应病区的项目一
/// do ##class(%ResultSet).RunQuery("web.DHCNurHlthEduComm","FindHEAPItemOne","7")
Query FindHEAPItemOne(parr As %String) As %Query(ROWSPEC = "Ttem1RowId,Item1Desc")
{
}

ClassMethod FindHEAPItemOneExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i (parr="")
	{
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	set WardRowId = parr
	set Ttem1RowId = ""
	for  set Ttem1RowId=$O(^HEDUAP(WardRowId,"HEAPW",Ttem1RowId)) q:Ttem1RowId=""  do
	.q:$D(^HEDUAP(Ttem1RowId))=0
	.s Item1Desc = $P(^HEDUAP(Ttem1RowId),"^",1)
	.//w !,CareRowId_"^"_CareItem_"^"_CareDesc
	.s Item1Valid = $P(^HEDUAP(Ttem1RowId),"^",3)
	.if Item1Valid'="N" do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(Ttem1RowId,Item1Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHEAPItemOneClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHEAPItemOneExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHEAPItemOneFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHEAPItemOneExecute ]
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

/// 查询健康教育评估项目对应项目一的项目二
/// do ##class(%ResultSet).RunQuery("web.DHCNurHlthEduComm","FindHEAPItemTwo","1")
Query FindHEAPItemTwo(parr As %String) As %Query(ROWSPEC = "Item2RowId,Item2Desc,Item1Desc,Describle")
{
}

ClassMethod FindHEAPItemTwoExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i (parr=""&&$D(^HEDUAP(Item1RowId)))
	{
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	set Item1RowId=parr
	set Item1Desc = $P(^HEDUAP(Item1RowId),"^",1)
	//w !,Item1Desc
	set Item2RowId = ""
	for  set Item2RowId=$O(^HEDUAPI(Item1RowId,"CARETEACH",Item2RowId)) q:Item2RowId=""  do
	.q:$D(^HEDUAPI(Item2RowId))=0
	.s Item2Desc = $P(^HEDUAPI(Item2RowId),"^",2)
	.s Describle = $P(^HEDUAPI(Item2RowId),"^",3)
	.s Item2Valid = $P(^HEDUAPI(Item2RowId),"^",4)
	.if Item2Valid'="N" do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(Item2RowId,Item2Desc,Item1Desc,Describle)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHEAPItemTwoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHEAPItemTwoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHEAPItemTwoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHEAPItemTwoExecute ]
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

/// 添加项目一
/// do ##class(web.DHCNurHlthEduComm).AddHEAProject("产科手术^792^产科手术描述")
ClassMethod AddHEAProject(parr As %String)
{
	q:$d(parr)=0
	s object = ##class(DHCMGNUR.DHCNurHEAProject).%New()
	//s object = ##class(DHCMGNUR.DHCNurHEAProject).%New()
	s object.Item1 = $P(parr,"^",1)
	//s WardObject = ##class(User.CTLoc).%OpenId()
	s WardRowId = $P(parr,"^",2)
	q:$D(^CTLOC(WardRowId))=0
	s object.WardItemDR = WardRowId
	TStart
	S sc = object.%Save()
 	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "添加失败"
	}
	else
	{
		TCommit
		q "添加成功"
	}
}

/// 添加项目二
ClassMethod AddHEAProjectItem(parr As %String)
{
	q:$d(parr)=0
	s object = ##class(DHCMGNUR.DHCNurHEAProjectItem).%New()
	s object.Item2 = $P(parr,"^",1)
	s CareObject = ##class(DHCMGNUR.DHCNurHEAProject).%OpenId($P(parr,"^",2))
	s object.Item1DR = CareObject
	s object.Describe = $P(parr,"^",3)
	TStart
	S sc = object.%Save()
 	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "添加失败"
	}
	else
	{
		TCommit
		q "添加成功"
	}
}

/// 作废项目一
/// w ##class(web.DHCNurHlthEduComm).DeleteHEAProject("1^N")
ClassMethod DeleteHEAProject(parr As %String)
{
	q:$d(parr)=0
	s RowId = $P(parr,"^",1) q:RowId=""
	s Valid = $P(parr,"^",2)
	s ^TempVaild = parr
	s Object = ##class(DHCMGNUR.DHCNurHEAProject).%OpenId(RowId)
	s Object.Item1Valid=Valid
	TStart
	S sc = Object.%Save()
 	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "Fail"
	}
	else
	{
		TCommit
		q "Ok"
	}
}

/// 删除项目二
ClassMethod DeleteHEAProjectItem(parr As %String)
{
	q:$d(parr)=0
	s RowId = $P(parr,"^",1) q:RowId=""
	s Valid = $P(parr,"^",2)
	s object = ##class(DHCMGNUR.DHCNurHEAProjectItem).%OpenId(RowId)
	TStart 
	s object.Item2Valid=Valid
	S sc = object.%Save()
 	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "Fail"
	}
	else
	{
		TCommit
		q "Ok"
	}
}

/// w ##class(web.DHCNurHlthEduComm).FindWardById("1")
ClassMethod FindWardById(parr As %String)
{
	q:$d(parr)=0
	q:$Data(^CTLOC(parr))=0
	s WardCode = $P(^CTLOC(parr),"^",1)
	s WardDesc = $P(^CTLOC(parr),"^",2)
	s ret = WardCode_"^"_WardDesc
	q ret
}

/// w ##class(web.DHCNurHlthEduComm).FindHEAPItemTwoById("1")
ClassMethod FindHEAPItemTwoById(parr As %String)
{
	//s TempXBL("FHEAPIT") = parr
	q:parr="" "ERROR"
	q:$Data(^HEDUAPI(parr))=0 "ERROR2"
	s ItemDesc = $P(^HEDUAPI(parr),"^",3)
	q ItemDesc
}

/// 修改项目一
ClassMethod UpdateHEAProject(parr As %String)
{
	q:$d(parr)=0
	s id = $P(parr,"^",1)
	s object = ##class(DHCMGNUR.DHCNurHEAProject).%OpenId(id)
	s object.Item1 = $P(parr,"^",2)
	TStart
	S sc = object.%Save()
 	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "修改失败"
	}
	else
	{
		TCommit
		q "修改成功"
	}
}

/// 修改项目二
ClassMethod UpdateHEAProjectItem(parr As %String)
{
	q:$d(parr)=0
	s id = $P(parr,"^",1)
	s object = ##class(DHCMGNUR.DHCNurHEAProjectItem).%OpenId(id)
	s object.Item2 = $P(parr,"^",2)
	s object.Describe = $P(parr,"^",3)
	TStart
	S sc = object.%Save()
 	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "修改失败"
	}
	else
	{
		TCommit
		q "修改成功"
	}
}

/// w ##class(web.DHCNurHlthEduComm).UpdateHEAProjectItem2("")
ClassMethod UpdateHEAProjectItem2(parr As %String)
{
	q:$d(parr)=0
	s id = $P(parr,"^",1)
	s id2 = $P(parr,"^",2)
	s object = ##class(DHCMGNUR.DHCNurHEAProjectItem).%OpenId(id)
	s a = ##class(DHCMGNUR.DHCNurHEAProject).%OpenId(id2)
	s object.Item1DR = a
	b ;01
	TStart
	S sc = object.%Save()
 	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "修改失败"
	}
	else
	{
		TCommit
		q "修改成功"
	}
}

/// w ##class(web.DHCNurHlthEduComm).FindWardByPO("1")
ClassMethod FindWardByPO(parr As %String) As %String
{
	q:parr=""
	s a = ##class(DHCMGNUR.DHCNurHEAProject).%OpenId(parr)
	s ret = a.Item1_"^"_a.WardItemDR
	q ret
}

/// do ##class(%ResultSet).RunQuery("web.DHCNurHlthEduComm","FindProjectByWard","1018")
Query FindProjectByWard(parr As %String) As %Query(ROWSPEC = "id,name,desc")
{
}

ClassMethod FindProjectByWardExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	;w $g($O(^HEDUAP("1018","HEAPW","")))
	s HEAPId1="" f  s HEAPId1=$O(^HEDUAP(parr,"HEAPW",HEAPId1)) q:HEAPId1=""  d
	.s HEAPValid1=$P(^HEDUAP(HEAPId1),"^",3)
	.q:HEAPValid1="N"
	.s HEAPId2="" f  s HEAPId2=$O(^HEDUAPI(HEAPId1,"CARETEACH",HEAPId2)) q:HEAPId2=""  d
	..s HEAPValid2 = $P(^HEDUAPI(HEAPId2),"^",4)
	..q:HEAPValid2="N"
	..s HEAPItem2 = $P(^HEDUAPI(HEAPId2),"^",2)
	..s HEAPDesc2 = $P(^HEDUAPI(HEAPId2),"^",3)
	..s Flag=0
	..s HEAPId3="" f  s HEAPId3=$O(^DHCMGNUR.DHCNurHEAPIItemI("ItemDR"," "_HEAPId2,HEAPId3)) q:HEAPId3=""  d
	...s object=##class(DHCMGNUR.DHCNurHEAPIItem).%OpenId(HEAPId3)
	...s ItemValid=object.ItemValid
	...q:ItemValid=""
	...s HEAPItem3 = object.Item3
	...s HEAPDesc3 = object.Describe
	...s Flag=1
	...s id=HEAPId1_"||"_HEAPId2_"||"_HEAPId3
	...s name = HEAPItem3
	...s desc = HEAPDesc3
	...d OutputPJRow
	..i Flag=0 d
	...s id=HEAPId1_"||"_HEAPId2
	...s name = HEAPItem2
	...s desc = HEAPDesc2
	...d OutputPJRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPJRow      
	set Data=$lb(id,name,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindProjectByWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProjectByWardExecute ]
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

ClassMethod FindProjectByWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindProjectByWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
