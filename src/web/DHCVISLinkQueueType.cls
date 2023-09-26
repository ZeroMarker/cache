Class web.DHCVISLinkQueueType Extends %RegisteredObject
{

ClassMethod SaveLinkQueueType(typeId As %String = "", typeCode As %String = "", typeDesc As %String = "", typeNote As %String = "", activeFlag As %String = "") As %String
{
	q:(typeCode="") "类型代码不能为空！"
	q:(typeDesc="") "类型描述不能为空！"
	
	s tempTypeId=$o(^User.DHCVISLinkQueueTypeI("QueueCodeIndex"," "_typeCode,""))
	
	s typeCode=$$upper^SSUTIL4(typeCode)
	q:((tempTypeId'="")&&(typeId="")) typeCode_"已经维护,请不要重复维护"
	q:((tempTypeId'="")&&(typeId'="")&&(tempTypeId'=typeId)) typeCode_"已经维护,请不要重复维护"
	
	s tempTypeId=$o(^User.DHCVISLinkQueueTypeI("QueueDescIndex"," "_typeDesc,""))
	q:((tempTypeId'="")&&(typeId="")) typeCode_"已经维护,请不要重复维护"
	q:((tempTypeId'="")&&(typeId'="")&&(tempTypeId'=typeId)) typeCode_"已经维护,请不要重复维护"
	
	s currentDate=+$h
	s currentTime=$p($h,",",2)
	
	if typeId'="" {
		s myObj=##class(User.DHCVISLinkQueueType).%OpenId(typeId)
		q:myObj="" "关联类型不存在"
	}else {
		s myObj=##class(User.DHCVISLinkQueueType).%New()
		s myObj.createDate=currentDate
		s myObj.createTime=currentTime
	}
	
	s myObj.linkQueueCode=typeCode
	s myObj.linkQueueDesc=typeDesc
	s myObj.linkQueueNote=typeNote
	s myObj.activeFlag=activeFlag
	d myObj.%Save()
	s ID=myObj.%Id()
	d myObj.%Close()
	
	q "0"
}

ClassMethod DeleteLinkQueueType(typeId As %String = "") As %String
{
	q:typeId="" "参数不能为空"
	
	s myObj=##class(User.DHCVISLinkQueueType).%OpenId(typeId)
	q:myObj="" "类型不存在"
	
	d myObj.%DeleteId(typeId)
	d myObj.%Close()
	
	q 0
}

Query FindQueueType(typeCode As %String, typeDesc As %String, typeNote As %String) As %Query(ROWSPEC = "TypeId:%String,TypeCode:%String,TypeDesc:%String,TypeNote:%String,ActiveFlag:%String")
{
}

ClassMethod FindQueueTypeExecute(ByRef qHandle As %Binary, typeCode As %String = "", typeDesc As %String = "", typeNote As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCVISLinkQueueType","FindQueueType","","","","")
 	
 	s TypeId=""
 	f  s TypeId=$O(^User.DHCVISLinkQueueTypeD(TypeId)) q:(TypeId="")  d
 	.s myObj=##class(User.DHCVISLinkQueueType).%OpenId(TypeId)
 	.q:myObj=""
 	.s TypeCode=myObj.linkQueueCode
 	.q:((typeCode'="")&&(TypeCode'[typeCode))
 	.s TypeDesc=myObj.linkQueueDesc
 	.q:((typeDesc'="")&&(TypeDesc'[typeDesc))
 	.s TypeNote=myObj.linkQueueNote
 	.q:((typeNote'="")&&(TypeNote'[typeNote))
 	.s ActiveFlag=myObj.activeFlag
 	.Do OutRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

OutRow
	
	set Data=$lb(TypeId,TypeCode,TypeDesc,TypeNote,ActiveFlag)
	//set Data=$lb(RegQueueID,QueueNo,PatName,StudyNo,RegDate,RegGroup,QueueState)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindQueueTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQueueTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQueueTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQueueTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query LookUpType(typeCode As %String, typeDesc As %String, typeNote As %String) As %Query(ROWSPEC = "TypeId:%String,TypeCode:%String,TypeDesc:%String,TypeNote:%String,ActiveFlag:%String")
{
}

ClassMethod LookUpTypeExecute(ByRef qHandle As %Binary, typeCode As %String = "", typeDesc As %String = "", typeNote As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCVISLinkQueueType","LookUpType","","","")
 	
 	s TypeId=""
 	f  s TypeId=$O(^User.DHCVISLinkQueueTypeD(TypeId)) q:(TypeId="")  d
 	.s myObj=##class(User.DHCVISLinkQueueType).%OpenId(TypeId)
 	.q:myObj=""
 	.s TypeCode=myObj.linkQueueCode
 	.q:((typeCode'="")&&(TypeCode'[typeCode))
 	.s TypeDesc=myObj.linkQueueDesc
 	.q:((typeDesc'="")&&(TypeDesc'[typeDesc))
 	.s TypeNote=myObj.linkQueueNote
 	.q:((typeNote'="")&&(TypeNote'[typeNote))
 	.s ActiveFlag=myObj.activeFlag
 	.q:ActiveFlag'="Y"
 	.Do OutRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

OutRow
	
	set Data=$lb(TypeId,TypeCode,TypeDesc,TypeNote,ActiveFlag)
	//set Data=$lb(RegQueueID,QueueNo,PatName,StudyNo,RegDate,RegGroup,QueueState)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query QueryQueueType() As %Query(ROWSPEC = "TypeId:%String,TypeCode:%String,TypeDesc:%String,TypeNote:%String,ActiveFlag:%String")
{
}

ClassMethod QueryQueueTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCVISLinkQueueType","FindQueueType","","","","")
 	
 	s TypeId=""
 	f  s TypeId=$O(^User.DHCVISLinkQueueTypeD(TypeId)) q:(TypeId="")  d
 	.s myObj=##class(User.DHCVISLinkQueueType).%OpenId(TypeId)
 	.q:myObj=""
 	.s TypeCode=myObj.linkQueueCode
 	.s TypeDesc=myObj.linkQueueDesc
 	.s TypeNote=myObj.linkQueueNote
 	.s ActiveFlag=myObj.activeFlag
 	.q:ActiveFlag="N"
 	.Do OutRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

OutRow1
	
	set Data=$lb(TypeId,TypeCode,TypeDesc,TypeNote,ActiveFlag)
	//set Data=$lb(RegQueueID,QueueNo,PatName,StudyNo,RegDate,RegGroup,QueueState)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryQueueTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryQueueTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryQueueTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryQueueTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
