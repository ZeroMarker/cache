Class web.DHCENS.STBLL.UTIL.EnsSendDataInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.Method.EnsSendDataInfo).SaveEnsSendDataInfo("update^78^Y^Day^1^1^00:00^备注^入参格式")
ClassMethod SaveEnsSendDataInfo(Input As %String) As %String
{
	set $zt="Exception"
	set acionStatus=$p(Input,"^",1)
	set interfaceMethodDr=$p(Input,"^",2)
	set rowId=$o(^User.EnsSendDataInfoI("InterfaceMethodDr",interfaceMethodDr,""))
	if acionStatus="add" {
		Quit:rowId'="" "-1^数据同步方法已经添加"
		set sendObj=##class(User.EnsSendDataInfo).%New()
		set interfaceMethodObj=##class(User.EnsInterfaceMethod).%OpenId(interfaceMethodDr)
		set sendObj.interfaceMethodDr=interfaceMethodObj
	}
	else {
		Quit:rowId="" "-1^数据同步方法不存在"
		set sendObj=##class(User.EnsSendDataInfo).%OpenId(rowId)
	}
	set ensDataStatus=$p(Input,"^",3)
	set ensDataTaskFreq=$p(Input,"^",4)
	set ensDataWeeks=$p(Input,"^",5)
	set ensDataDays=$p(Input,"^",6)
	set ensDataTimes=$p(Input,"^",7)
	set ensDataNote=$p(Input,"^",8)
	set ensDataFormat=$p(Input,"^",9)
	set sendObj.ensDataStatus=ensDataStatus
	set sendObj.ensDataTaskFreq=ensDataTaskFreq
	set sendObj.ensDataWeeks=ensDataWeeks
	set sendObj.ensDataDays=ensDataDays
	set sendObj.ensDataTimes=ensDataTimes
	set sendObj.ensDataNote=ensDataNote
	set sendObj.ensDataFormat=ensDataFormat
	set sc=sendObj.%Save()
	Quit sc
Exception
	Quit "-1^"_$ze
}

/// Creator：WuXianPu
/// CreatDate：2015—04-13
/// Description：
/// Table：User.EnsSendDataInfo
/// Input：
/// Output：返回符合条件的数据任务同步列表
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.Method.EnsSendDataInfo","GetEnsSendDataInfo","")
Query GetEnsSendDataInfo(Input As %String) As %Query(ROWSPEC = "id:%String,methodId:%String,code:%String,desc:%String,freq:%String,status:%String")
{
}

ClassMethod GetEnsSendDataInfoExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set selId=$p(Input,"^",1)
	set selStatus=$p(Input,"^",2)
	set selTaskFreq=$p(Input,"^",3)
	set QHandle=$lb(0,repid,0)
	set subId=""  for  set subId=$o(^User.EnsSendDataInfoD(subId)) Quit:subId=""  d
	.set sendDataInfo=^User.EnsSendDataInfoD(subId)
	.set id=$lg(sendDataInfo,2)
	.Quit:((id'=selId)&&((selId'="")&&(selId'="ALL")))
	.set ensMethodObj=##class(User.EnsInterfaceMethod).%OpenId(id)
	.set methodId=id
	.set code=ensMethodObj.methodCode
	.set desc=ensMethodObj.methodDesc
	.set freq=$lg(sendDataInfo,5)
	.Quit:((freq'=selTaskFreq)&&((selTaskFreq'="")&&(selTaskFreq'="ALL")))	
	.set status=$lg(sendDataInfo,4)
	.Quit:((status'=selStatus)&&((selStatus'="")&&(selStatus'="ALL")))	
	.set ^CacheTemp(repid,ind)=$lb(subId,methodId,code,desc,freq,status)
	.set ind=ind+1
	Quit $$$OK
}

ClassMethod GetEnsSendDataInfoClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetEnsSendDataInfoFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：WuXianPu
/// CreatDate：2015—04-13
/// Description：数据同步详细信息
/// Table：User.EnsSendDataInfo
/// Input：
/// Output：返回his版本信息信息列表
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.Method.EnsSendDataInfo","GetEnsSendDataDetailInfo","1")
Query GetEnsSendDataDetailInfo(Input As %String) As %Query(ROWSPEC = "methodId:%String,methodCode:%String,methodDesc:%String,methodClassName:%String,methodName:%String,ensDataFormat:%String,methodNotes:%String,methodStatus:%String,methodFreq:%String,methodWeeks:%String")
{
}

ClassMethod GetEnsSendDataDetailInfoExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)	
	set id=$p(Input,"^",1)
	set obj=##class(User.EnsSendDataInfo).%OpenId(id)
	set methodObj=obj.interfaceMethodDr
	set methodId=methodObj.%Id()
	set methodCode=methodObj.methodCode
	set methodDesc=methodObj.methodDesc
	set methodClassName=methodObj.methodClassName
	set methodName=methodObj.methodName
	set ensDataFormat=obj.ensDataFormat
	set methodNotes=obj.ensDataNote
	set methodStatus=obj.ensDataStatus
	set methodFreq=obj.ensDataTaskFreq
	set methodWeeks=obj.ensDataWeeks
	set ^CacheTemp(repid,ind)=$lb(methodId,methodCode,methodDesc,methodClassName,methodName,ensDataFormat,methodNotes,methodStatus,methodFreq,methodWeeks)
	set ind=ind+1
	k ^TMPIMP
	Quit $$$OK
}

ClassMethod GetEnsSendDataDetailInfoClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetEnsSendDataDetailInfoFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(web.DHCENS.Method.EnsSendDataInfo).UpdateSendDataStatus("1")
ClassMethod UpdateSendDataStatus(Input As %String) As %String
{
	set $zt="Exception"
	set id=$p(Input,"^",1)
	set obj=##class(User.EnsSendDataInfo).%OpenId(id)
	if '$isobject(obj) {
		q "方法不存在"
	}
	ts
	if obj.ensDataStatus="Y" {
		s obj.ensDataStatus="N"
	}
	else {
		s obj.ensDataStatus="Y"
	}
	s sc=obj.%Save()
	if (sc'=1) {
		tro
		q "-1^状态保存失败"
	}
	tc
	Quit sc
Exception
	Quit "-1^"_$ze
}

ClassMethod DelSendDataInfo(Input As %String) As %String
{
	set $zt="Exception"
	set id=$p(Input,"^",1)
	set sc=##class(User.EnsSendDataInfo).%DeleteId(id)
	Quit sc
Exception
	Quit "-1^"_$ze
}

}
