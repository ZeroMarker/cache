/// 护士排班
Class web.DHCNurRosteringComm Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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

/// 查询所有病区
/// do ##class(%ResultSet).RunQuery("web.DHCNurRosteringComm","FindAllWardData","")
Query FindAllWardData(parr As %String) As %Query(ROWSPEC = "WardRowId,WardCode,WardDesc")
{
}

ClassMethod FindAllWardDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TEMP("g20141223001")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	/*set WardRowId = " "
	for  set WardRowId=$O(^DHCMGNUR.MgPersonsI("Dep",WardRowId)) q:WardRowId=""  do
	.set WardId = $P(WardRowId," ",2)
	.q:$d(^CTLOC(WardId))=0
	.q:$O(^DHCMGNUR.MgNurPerWardI("WardLoc",WardId,""))=""
	.set WardCode = $P(^CTLOC(WardId),"^",1)
	.set WardDesc = $P(^CTLOC(WardId),"^",2)
	.do OutputRow*/
	set WardOrder=""
	for  set WardOrder = $O(^DHCMGNUR.MgNurPerWardI("WardOrd",WardOrder)) q:WardOrder=""  do
	.set WardRowId = $O(^DHCMGNUR.MgNurPerWardI("WardOrd",WardOrder,""))
	.set WardObj = ##class(DHCMGNUR.MgNurPerWard).%OpenId(WardRowId)
	.set WardId= WardObj.WardLoc
	.q:$d(^CTLOC(WardId))=0
	.set WardCode = $P(^CTLOC(WardId),"^",1)
	.set WardDesc = $P(^CTLOC(WardId),"^",2)
	.do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(WardId,WardCode,WardDesc)
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

/// 按病区查询护士信息
/// do ##class(%ResultSet).RunQuery("web.DHCNurRosteringComm","FindNurseByWard","999")
Query FindNurseByWard(parr As %String) As %Query(ROWSPEC = "MgPersonNo,MgPersonName,MgPersonBtyDesc")
{
}

ClassMethod FindNurseByWardExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if parr="" 
	{
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	;set ^TempXBL("ward")=parr
	set MgPersonID = ""
	for  set MgPersonID=$O(^DHCMGNUR.MgPersonsI("TempDep"," "_parr,MgPersonID)) q:MgPersonID=""  do
	.set MgPersonObj = ##class(DHCMGNUR.MgPersons).%OpenId(MgPersonID)
	.do Output1
	set MgPersonID = ""
	for  set MgPersonID=$O(^DHCMGNUR.MgPersonsI("Dep"," "_parr,MgPersonID)) q:MgPersonID=""  do
	.set MgPersonObj = ##class(DHCMGNUR.MgPersons).%OpenId(MgPersonID)
	.set MgPersonTmpCTLoc = MgPersonObj.PersonTempDepDR
	.q:MgPersonTmpCTLoc'=""
	.do Output1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output1
	set MgPersonNo=MgPersonObj.PersonID
	set MgPersonName=MgPersonObj.PersonName
	set MgPersonBty = MgPersonObj.PersonBattery
	;w !,MgPersonBty
	if MgPersonBty'="" set MgPersonBtyDesc = MgPersonBty.Code
	else  set MgPersonBtyDesc=""
	set Data=$lb(MgPersonNo,MgPersonName,MgPersonBtyDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseByWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseByWardExecute ]
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

ClassMethod FindNurseByWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseByWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

///  查询所有岗位分类
///  do ##class(%ResultSet).RunQuery("web.DHCNurRosteringComm","FindAllWorkCategory","")
///  w $O(^DHCMGNUR.CommDictionarySubI("Code"," 产房(助产)",1,""))
Query FindAllWorkCategory(parr As %String) As %Query(ROWSPEC = "CommDicSubID,CommDicSubCode,CommDicSubDesc")
{
}

ClassMethod FindAllWorkCategoryExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	set CommDicId = $O(^DHCMGNUR.CommDictionaryI("Code"," 工作科室",""))
	if (CommDicId="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s CommDicSubCode="" f  s CommDicSubCode = $O(^DHCMGNUR.CommDictionarySubI("Code",CommDicSubCode)) q:CommDicSubCode=""  d
	.;s CommDicID = $O(^DHCMGNUR.CommDictionarySubI("Code",CommDicSubCode,""))
	.;q:CommDicID'=CommDicId2
	.s CommDicSubID= $O(^DHCMGNUR.CommDictionarySubI("Code",CommDicSubCode,CommDicId,"")) 
	.q:CommDicSubID=""
	.s id=CommDicId_"||"_CommDicSubID
	.s CommDicSubObj = ##class(DHCMGNUR.CommDictionarySub).%OpenId(id)
	.s CommDicSubDesc = CommDicSubObj.CodeDesc
	.;b ;01
	.do Output2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output2
	set Data=$lb(CommDicSubID,$P(CommDicSubCode," ",2),CommDicSubDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllWorkCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllWorkCategoryExecute ]
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

ClassMethod FindAllWorkCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllWorkCategoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 按病区查询岗位信息
/// Input:parr(病区)
/// Output: 岗位代码^岗位名称^需要人数^夜班^备注^范围^小时数^岗位类别^顺序号^rw
/// d ##Class(%ResultSet).RunQuery("web.DHCNurRosteringComm","FindPostData","")
Query FindPostData(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPostDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	set ind=1
 	set tmp=""
 	set PostId = "" for  set PostId = $O(^DHCMGNUR.MgNurPostD(PostId)) q:PostId=""  do
	.set PostObj=##class(DHCMGNUR.MgNurPost).%OpenId(PostId)
	.set PostValid = PostObj.PostValid
	.q:PostValid="N"
	.set PostCode = PostObj.PostCode
	.set PostNeedNurse = PostObj.PostNeedNurse
	.set PostIsNight = PostObj.PostIsNight
	.set PostHourNum = PostObj.PostHourNum
	.set PostRemarks = PostObj.PostRemarks
	.set PostOrderNo = PostObj.PostOrderNo
	.set tmp(PostOrderNo)="^PostCode|"_PostCode_"^PostNeedNurse|"_PostNeedNurse_"^PostIsNight|"_PostIsNight_"^PostHourNum|"_PostHourNum_"^PostRemarks|"_PostRemarks_"^PostValid|"_PostValid_"^PostOrder|"_PostOrderNo_"^ID|"_PostId
	s Order="" f  s Order=$O(tmp(Order)) q:Order=""  d
	.set ret=tmp(Order)
	.Do OutputPost
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPost
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPostDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPostDataExecute ]
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

ClassMethod FindPostDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPostDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询所有轮转护士信息
/// do ##class(%ResultSet).RunQuery("web.DHCNurRosteringComm","FindRotateNurse")
Query FindRotateNurse() As %Query(ROWSPEC = "NurseId,NurseName,NurseLoc,NurseRowId")
{
}

ClassMethod FindRotateNurseExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	set LocId = $O(^CTLOC(0,"Code","轮转",""))
	if LocId=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	set MgPersonID = ""
	for  set MgPersonID=$O(^DHCMGNUR.MgPersonsI("Dep"," "_LocId,MgPersonID)) q:MgPersonID=""  do
	.set MgPersonObj = ##class(DHCMGNUR.MgPersons).%OpenId(MgPersonID)
	.set MgPersonNo = MgPersonObj.PersonID
	.set MgPersonName = MgPersonObj.PersonName
	.set PersonTempDepDR = MgPersonObj.PersonTempDepDR
	.if PersonTempDepDR'="" set CTLocDesc = $P(^CTLOC(PersonTempDepDR),"^",2)
	.else  set CTLocDesc=""
	.do OutputRotate
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRotate
	set Data=$lb(MgPersonNo,MgPersonName,CTLocDesc,MgPersonID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRotateNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRotateNurseExecute ]
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

ClassMethod FindRotateNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRotateNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 轮转护士调科
/// Input：NurseId^NurseTmpWardDR
ClassMethod SaveRotateWard(parr As %String) As %String
{
	q:parr=""
	set NurseId = $P(parr,"^",1)
	set NurseTmpWardDR = $P(parr,"^",2)
	set PersonObj = ##class(DHCMGNUR.MgPersons).%OpenId(NurseId)
	set PersonObj.PersonTempDepDR = NurseTmpWardDR
	TStart
	set sc = PersonObj.%Save()
	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "fail"
	}
	else
	{
		TCommit
		q "success"
	}
}

/// 检查当前科室人员信息与模板人员信息是否一致
/// w ##class(web.DHCNurRosteringComm).CheckNurseInfo("1018^1")
ClassMethod CheckNurseInfo(parr As %String) As %String
{
	q:parr=""
	set ret=""
	set WardId = $P(parr,"^",1)
	set ModelId = $P(parr,"^",2)
	set AJMRowId = ""
	for  set AJMRowId = $O(^DHCMGNUR.MgNurArrangeJobModelI("AJWardDRIndex"," "_WardId,AJMRowId)) q:AJMRowId=""  do
	.set AJMObj = ##class(DHCMGNUR.MgNurArrangeJobModel).%OpenId(AJMRowId)
	.set AJModelDR = AJMObj.AJModelDR
	.q:AJModelDR'=ModelId
	.set AJMNurseDR = AJMObj.AJNurseDR
	.set PersonRowId = $O(^DHCMGNUR.MgPersonsI("SSID"," "_AJMNurseDR,"")) 
	.set MgPersonObj = ##class(DHCMGNUR.MgPersons).%OpenId(PersonRowId)
	.set PersonLoc = MgPersonObj.PersonDepDR
	.set PersonTempDepDR = MgPersonObj.PersonTempDepDR
	.set NurseName = MgPersonObj.PersonName
	.if ((PersonLoc'=WardId)&&(PersonTempDepDR'=WardId)) do
	..if ret="" set ret = "姓名:"_NurseName_"    工号:"_AJMNurseDR
	..else  set ret = ret_"^"_"姓名:"_NurseName_"    工号:"_AJMNurseDR 
	q ret
}

/// w ##class(web.DHCNurRosteringComm).CheckNurseInfo2("1018^1")
ClassMethod CheckNurseInfo2(parr As %String) As %String
{
	q:parr=""
	set ret=""
	set WardId = $P(parr,"^",1)
	set ModelId = $P(parr,"^",2)
	set Weeks = "MONDAY^TUESDAY^WEDNESDAY^THURSDAY^FRIDAY^SATURDAY^SUNDAY"
	set MgPersonID = ""
	for  set MgPersonID=$O(^DHCMGNUR.MgPersonsI("TempDep"," "_WardId,MgPersonID)) q:MgPersonID=""  do
	.set MgPersonObj = ##class(DHCMGNUR.MgPersons).%OpenId(MgPersonID)
	.do CheackPersonData
	set MgPersonID = ""
	for  set MgPersonID=$O(^DHCMGNUR.MgPersonsI("Dep"," "_WardId,MgPersonID)) q:MgPersonID=""  do
	.set MgPersonObj = ##class(DHCMGNUR.MgPersons).%OpenId(MgPersonID)
	.set MgPersonTmpCTLoc = MgPersonObj.PersonTempDepDR
	.q:MgPersonTmpCTLoc'=""
	.do CheackPersonData
	q ret
CheackPersonData
	set Flag=0
	set PersonId = MgPersonObj.PersonID
	set NurseName = MgPersonObj.PersonName
	for i=1:1:7 do
	.set Week = $P(Weeks,"^",i)
	.set AJMRowId = $O(^DHCMGNUR.MgNurArrangeJobModelI("AJNurWeekIndex"," "_ModelId," "_WardId," "_PersonId," "_Week,""))
	.q:AJMRowId'=""
	.set Flag=1
	if Flag=1 do
	.if ret="" set ret = "姓名:"_NurseName_"    工号:"_PersonId
	.else  set ret = ret_"^"_"姓名:"_NurseName_"    工号:"_PersonId
	q
}

/// w ##class(web.DHCNurRosteringComm).getAllHolidayCode()
ClassMethod getAllHolidayCode()
{
	set ret=";"
	s hldid="" f  s hldid=$O(^DHCMGNUR.MgNurHolidayCodeD(hldid)) q:hldid=""  d
	.s hldobj=##class(DHCMGNUR.MgNurHolidayCode).%OpenId(hldid)
	.q:hldobj.HolidayStatus="N"
	.s ret=ret_hldobj.HolidayDesc_";"
	q ret
}

ClassMethod CheckNurseType(PerId)
{
	q:PerId="" ""
	s ret="正式"
	s PerDR=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZCvt(PerId,"U"),""))
	i PerDR'="" d
	.s a=##class(DHCMGNUR.MgPersons).%OpenId(PerDR)
	.s WardDR=a.PersonDepDR
	.s WardCode=$P($g(^CTLOC(WardDR)),"^",1)
	.i WardCode="轮转" s ret="轮转"
	else  d
	.s ret="进修"
	q ret
}

}
