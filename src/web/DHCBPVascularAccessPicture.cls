Import SQLUser

Class web.DHCBPVascularAccessPicture Extends web.DHCClinicCom
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPVascularAccessPicture","FindBPVascularAccessPicture",1)
Query FindBPVascularAccessPicture(registerId As %String) As %Query(ROWSPEC = "rowId,VAId,VADesc,image,ifActive,startDate,startTime,updateUserDr,updateUserDesc,note")
{
}

ClassMethod FindBPVascularAccessPictureExecute(ByRef qHandle As %Binary, registerId As %String) As %Status
{
	//s ^TempBPDebug("FindBPVascularAccessPicture")=registerId
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
	k ^TMPBP("VascularAccessPicture",$j)
	//s date="2021/5/31"
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rowId="",count=0
	f  s rowId=$o(^DHCBPVascularAccessPicture(0,"Register",registerId,rowId)) q:(rowId="")  d
	.d GetDateRow
	s rowId="" f  s rowId=$o(^TMPBP("VascularAccessPicture",$j,rowId),-1) q:rowId=""  d
	.do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	

GetDateRow  
	q:rowId<22
	//q:rowId'=14
    s item=##class(User.DHCBPVascularAccessPicture).%OpenId(rowId)
    
    q:item.BPVPVascularAccessDr=""
     //s ^TempBPDebug("FindBPVascularAccessPicture")=$j
    s VAId=item.BPVPVascularAccessDr.%Id()
    s VADesc=item.BPVPVascularAccessDr.BPCVADesc
    b
    s image=item.BPVPImage.Read(1024*1024)
    s ifActive=item.BPVPIfActive
    q:ifActive="N"
    s count=count+1
    s startDate=item.BPVPStartDate
    s startTime=item.BPVPStartTime
    s updateUserDr=item.BPVPUpdateUserDr
    s startDate=##class(web.DHCClinicCom).ConvertToDate(startDate)
    s startTime=##class(web.DHCClinicCom).ConvertToTime(startTime)
    s userObj=##class(User.SSUser).%OpenId(updateUserDr)
    s updateUserDesc=userObj.SSUSRName
    s note=item.BPVPNote
    
    s ^TMPBP("VascularAccessPicture",$j,rowId)=$lb(rowId,VAId,VADesc,image,ifActive,startDate,startTime,updateUserDr,updateUserDesc,note)
    quit
OutputRow 
 	Set ^CacheTemp(repid,ind)=^TMPBP("VascularAccessPicture",$j,rowId)
 	Set ind=ind+1
	quit
}

ClassMethod FindBPVascularAccessPictureFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBPVascularAccessPictureClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##class(web.DHCBPVascularAccessPicture).SaveVascularAccessPicture($p(^tempby("SaveVascularAccessPicture"),"!!",1),$p(^tempby("SaveVascularAccessPicture"),"!!",2))

ClassMethod SaveVascularAccessPicture(vascularAccessPicturePara, imagebase As %Library.GlobalCharacterStream) As %String
{
	s ^tempby("SaveVascularAccessPicture")=vascularAccessPicturePara_"!!"_imagebase
	s obj=""
	q:(vascularAccessPicturePara="") obj
	s d=..ToJsonObj(vascularAccessPicturePara)
	s obj=##class(User.DHCBPVascularAccessPicture).%New()
	s registerId=d.GetAt("RegisterId")
	i registerId'="" s obj.BPVPBPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
	s vascularAccessId=d.GetAt("VascularAccessId")
	i vascularAccessId'="" s obj.BPVPVascularAccessDr=##class(User.DHCBPCVascularAccess).%OpenId(vascularAccessId)
	
	s obj.BPVPImage=imagebase
	b 
	s obj.BPVPIfActive=d.GetAt("IfActive")
	
	s startDate=d.GetAt("StartDate")
	s obj.BPVPStartDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=d.GetAt("StartTime")
	s obj.BPVPStartTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	
	s obj.BPVPUpdateUserDr=d.GetAt("UpdateUserDr")
	s obj.BPVPNote=d.GetAt("Note")
	d obj.%Save()
	
	s result=obj.%Id()
	d obj.%Close()
	q result
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPVascularAccessPicture","FindBPVascularAccessPicture",1)
Query FindBPVascularAccessPictureForPC(registerId As %String) As %Query(ROWSPEC = "rowId,VAId,VADesc,image,ifActive,startDate,startTime,updateUserDr,updateUserDesc,note")
{
}

ClassMethod FindBPVascularAccessPictureForPCExecute(ByRef qHandle As %Binary, registerId As %String) As %Status
{
	s ^TempBPDebug("FindBPVascularAccessPicture")=registerId
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
	k ^TMPBP("VascularAccessPicture",$j)
	//s date="2021/5/31"
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rowId="",count=0
	f  s rowId=$o(^DHCBPVascularAccessPicture(0,"Register",registerId,rowId)) q:(rowId="")  d
	.d GetDateRow
	s rowId="" f  s rowId=$o(^TMPBP("VascularAccessPicture",$j,rowId),-1) q:rowId=""  d
	.do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	

GetDateRow  
	//q:rowId>15
	//q:rowId'=14
    s item=##class(User.DHCBPVascularAccessPicture).%OpenId(rowId)
    
    q:item.BPVPVascularAccessDr=""
     s ^TempBPDebug("FindBPVascularAccessPicture")=$j
    s VAId=item.BPVPVascularAccessDr.%Id()
    s VADesc=item.BPVPVascularAccessDr.BPCVADesc
    s image=""
    i (item.BPVPImage'="") d
    .s image="Y"
    s ifActive=item.BPVPIfActive
    q:ifActive="N"
    s count=count+1
    s startDate=item.BPVPStartDate
    s startTime=item.BPVPStartTime
    s updateUserDr=item.BPVPUpdateUserDr
    s startDate=##class(web.DHCClinicCom).ConvertToDate(startDate)
    s startTime=##class(web.DHCClinicCom).ConvertToTime(startTime)
    s userObj=##class(User.SSUser).%OpenId(updateUserDr)
    s updateUserDesc=userObj.SSUSRName
    s note=item.BPVPNote
    
    s ^TMPBP("VascularAccessPicture",$j,rowId)=$lb(rowId,VAId,VADesc,image,ifActive,startDate,startTime,updateUserDr,updateUserDesc,note)
    quit
OutputRow 
 	Set ^CacheTemp(repid,ind)=^TMPBP("VascularAccessPicture",$j,rowId)
 	Set ind=ind+1
	quit
}

ClassMethod FindBPVascularAccessPictureForPCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBPVascularAccessPictureForPCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetVascularAccessPicture(rowId) As %String
{
	q:rowId="" ""
	s item=##class(User.DHCBPVascularAccessPicture).%OpenId(rowId)
    q:item.BPVPVascularAccessDr=""
    //s image=item.BPVPImage
    s image=item.BPVPImage.Read()
	q image
}

ClassMethod DeleteVascularAccessPicture(rowId) As %String
{
	q:rowId="" ""
	s obj=##class(User.DHCBPVascularAccessPicture).%OpenId(rowId)
	s obj.BPVPIfActive="N"
	d obj.%Save()
	s result=obj.%Id()
	d obj.%Close()
	q result
}

ClassMethod GetBPVascularAccessPictureID(registerId As %String, vascularAccessId As %String) As %String
{
	q:registerId="" ""
	s rowId="",result=""
	f  s rowId=$o(^DHCBPVascularAccessPicture(0,"Register",registerId,rowId)) q:(rowId="")  d
		.s vaID = $lg(^DHCBPVascularAccessPicture(rowId),2)
		.q:(vascularAccessId'="")&&(vascularAccessId'=vaID)
		.s ifActive = $lg(^DHCBPVascularAccessPicture(rowId),4)
		.q:ifActive'="Y"
		.s result=rowId
	q result
}

}
