/// 类名：web.DHCENS.STBLL.UTIL.EnsInterface
/// 描述：更新查询接口表中数据
/// 编写者：WuXianPu
/// 编写日期：2012-07-06
Class web.DHCENS.STBLL.UTIL.EnsInterface Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod InsertEnsInterface(RowId As %String, Method As %String, Ip As %String, Input As %GlobalCharacterStream, InputDesc As %String) As %String
{
	s $zt="Exception"
	s methodObj=##class(User.EnsInterfaceMethod).%OpenId(RowId)
	if '$isobject(methodObj){
		q "-1^方法不存在!"
	}
	s methodStatus=methodObj.methodStatus
	if (methodStatus="N") {
		q "-1^方法未启用!"
	}
	s DateTimeString=$h
	s obj=##class(User.EnsInterfaceV8).%New()
	s obj.methodCode=methodObj.methodCode
	s obj.methodDesc=methodObj.methodDesc
	d obj.transferInput.CopyFrom(Input)
	s obj.transferInputDesc=InputDesc
	s length=$l($p($p(Method,"^",2),"+",1))
	s methodName=$e($p($p(Method,"^",2),"+",1),2,length)
	s cLength=$l($p(Method,"^",3),".")
	s className=$p($p(Method,"^",3),".",1,cLength-1)
	s obj.transferInClass=className
	s obj.transferInMethod=methodName
	s obj.transferInIp=Ip
	s obj.transferInsDate=$p(DateTimeString,",",1)
	s obj.transferInsTime=$p(DateTimeString,",",2)
	s sc=obj.%Save()
	s methodObj=""
	if $$$ISOK(sc){
		s ret="0^"_obj.%Id()
		s obj=""
	}
	else{
		s retContext=$SYSTEM.Status.GetErrorText(sc)
		s retCode=$SYSTEM.Status.GetErrorCodes(sc)
		s ret="-1^"_retCode_":"_retContext
	}	
	q ret
Exception
  	q -1_"^"_$ze
}

ClassMethod UpdateOutputResult(RowId As %String, TransferStatus As %String, TransferOuput As %GlobalCharacterStream) As %String
{
	set $zt="Exception"
	set obj=##class(User.EnsInterfaceV8).%OpenId(RowId)
	set obj.transferStatus=TransferStatus
	d obj.transferOuput.CopyFrom(TransferOuput)
	set sc=obj.%Save()
	Quit sc
Exception
	Quit "-1^"_$ze
}

/// Creator：WuXianPu
/// CreatDate：2015—01-07
/// Description：日志信息查询
/// Table：User.EnsInterfaceV8
/// Input：
/// Output：返回符合条件的日志列表
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.UTIL.EnsInterface","GetEnsInterfaceData","^^^2016-08-25 00:00:00^2016-08-25 23:59:59^N")
Query GetEnsInterfaceData(Input As %String) As %Query(ROWSPEC = "id:%String,code:%String,desc:%String,input:%String,inputDesc:%String,transferInIp:%String,transferInClass:%String,transferInMethod:%String,transferOuput:%String,transferOuputDesc:%String,transferStatus:%String,transferInsDate:%String,transferInsTime:%String,transferStatus:%String")
{
}

ClassMethod GetEnsInterfaceDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	QUit:Input=""
	set selId=$p(Input,"^",1)
	set selType=$p(Input,"^",2)
	set selInput=$p(Input,"^",3)
	set startDateTime=$p(Input,"^",4)
	set endDateTime=$p(Input,"^",5)
	set tranStatus=$p(Input,"^",6)
	set ensFlag=0,ensStatus=0
	set i=0
	if ((tranStatus'="")&&(tranStatus'="ALL")) d 
	.set rowId=""  for  set rowId=$o(^User.EnsInterfaceV8I("IndexTransferStatus",tranStatus,rowId))  Quit:rowId=""  d
	..set ^DHCENSTMP("EnsInterfaceV8",$j,rowId)="tranStatus"
	..set ensFlag="tranStatus"
	set:(tranStatus'="")&&(tranStatus'="ALL")&&(i=0) ensFlag="tranStatus"
	set i=0
	if ((selType'="")&&(selType'="ALL")) d
	.set rowId=""  for  set rowId=$o(^User.EnsInterfaceV8D(rowId)) q:rowId=""  d
	..set methodCode=$lg(^User.EnsInterfaceV8D(rowId),2)
	..if $d(^User.EnsInterfaceMethodI("MethodCode",selType,methodCode))'=0  d 
	...set i=i+1
	...if ((ensFlag="0")&&(ensStatus'=1)) d
	....set ^DHCENSTMP("EnsInterfaceV8",$j,rowId)="tranType"
	...else  d	
	....if $g(^DHCENSTMP("EnsInterfaceV8",$j,rowId))=ensFlag d
	.....set ^DHCENSTMP("EnsInterfaceV8",$j,rowId)="tranType"
	set:i>0 ensFlag="tranType"
	set:(selType'="")&&(selType'="ALL")&&(i=0) ensFlag="tranType"
	set i=0
	if selId'="" d
	.set rowId="" for  set rowId=$o(^User.EnsInterfaceV8I("IndexMethodCode",selId,rowId)) Quit:rowId=""  d
	..set i=i+1
	..if ((ensFlag="0")&&(ensStatus'=1)) d
	...set ^DHCENSTMP("EnsInterfaceV8",$j,rowId)="methodId"
	..else  d
	...if $g(^DHCENSTMP("EnsInterfaceV8",$j,rowId))=ensFlag d
	....set ^DHCENSTMP("EnsInterfaceV8",$j,rowId)="methodId"
	set:i>0 ensFlag="methodId"
	set:(selId'="")&&($d(^User.EnsInterfaceV8I("IndexMethodCode",selId))=0) ensFlag="methodId"
	set i=0
	if startDateTime'="" d	
	.set dateFormat=##class(websys.Conversions).DateFormat() //取系统配置中日期格式
	.set selStartDate="",selStartTime=""
	.set:startDateTime'="" selStartDate=$p(startDateTime," ",1)
	.;set:selStartDate'="" selStartDate=$zdh(selStartDate,3)
	.set:selStartDate'="" selStartDate=$zdh(selStartDate,dateFormat)
	.set:startDateTime'="" selStartTime=$p(startDateTime," ",2)
	.set:selStartTime'="" selStartTime=$zth(selStartTime,1)
	.set selEndDate="",selEndTime=""
	.set:endDateTime'="" selEndDate=$p(endDateTime," ",1)
	.;set:selEndDate'="" selEndDate=$zdh(selEndDate,3)
	.set:selEndDate'="" selEndDate=$zdh(selEndDate,dateFormat)
	.set:endDateTime'="" selEndTime=$p(endDateTime," ",2)
	.set:selEndTime'="" selEndTime=$zth(selEndTime,1)
	.set selStartDate=selStartDate-1 for  set selStartDate=$o(^User.EnsInterfaceV8I("IndexDateTime",selStartDate)) q:selStartDate=""  d
	..Quit:((selEndDate<selStartDate)&&(selEndDate'=""))
	..set selStartTimeCur=selStartTime for  set selStartTimeCur=$o(^User.EnsInterfaceV8I("IndexDateTime",selStartDate,selStartTimeCur)) q:selStartTimeCur=""  d
	...q:selStartTimeCur>selEndTime
	...set subId="0"  for  set subId=$o(^User.EnsInterfaceV8I("IndexDateTime",selStartDate,selStartTimeCur,subId)) q:subId=""  d
	....set i=i+1
	....if ((ensFlag="0")&&(ensStatus'=1)) d
	.....set ^DHCENSTMP("EnsInterfaceV8",$j,subId)="startTime"
	....else  d
	.....if $g(^DHCENSTMP("EnsInterfaceV8",$j,subId))=ensFlag d
	......set ^DHCENSTMP("EnsInterfaceV8",$j,subId)="startTime"
	set:i>0 ensFlag="startTime"	

	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set rowId=""  for  set rowId=$o(^DHCENSTMP("EnsInterfaceV8",$j,rowId))  q:rowId=""  d
	.set flag=$g(^DHCENSTMP("EnsInterfaceV8",$j,rowId))
	.Quit:flag'=ensFlag
	.set methodObj=##class(User.EnsInterfaceV8).%OpenId(rowId)
	.set code=methodObj.methodCode
	.set type="" //ensMethodObj.methodType
	.set transferInsDate=methodObj.transferInsDate
	.set dateFormat=##class(websys.Conversions).DateFormat()
	.set:transferInsDate'="" transferInsDate=$zd(transferInsDate,dateFormat)
	.set transferInsTime=methodObj.transferInsTime
	.set desc=methodObj.methodDesc
	.set input=methodObj.transferInput	//.Read(methodObj.transferInput.Size)
	.set input=##class(web.DHCENS.STBLL.UTIL.Common).EvalXMLStream(input)
	.set input=input.Read(32767)
	.Quit:('(input[selInput)&&(selInput'=""))
	.set inputDesc=methodObj.transferInputDesc
	.set transferInIp=methodObj.transferInIp
	.set transferInClass=methodObj.transferInClass
	.set transferInMethod=methodObj.transferInMethod
	.set transferOuput=##class(%GlobalCharacterStream).%New()
	.set transferOuput=methodObj.transferOuput	//.Read(methodObj.transferOuput.Size)
	.set transferOuput=##class(web.DHCENS.STBLL.UTIL.Common).EvalXMLStream(transferOuput)
	.set transferOuput=transferOuput.Read(32767)
	.set transferOuputDesc=methodObj.transferOuputDesc
	.set transferStatus=methodObj.transferStatus
	.set:transferInsTime'="" transferInsTime=$zt(transferInsTime,1)
	.set:transferStatus="" transferStatus="N"
	.set methodObj=""
	.set ^CacheTemp(repid,ind)=$lb(rowId,code,desc,input,inputDesc,transferInIp,transferInClass,transferInMethod,transferOuput,transferOuputDesc,transferStatus,transferInsDate,transferInsTime,transferStatus)
	.set ind=ind+1
	k ^DHCENSTMP("EnsInterfaceV8",$j)
	Quit $$$OK
}

ClassMethod GetEnsInterfaceDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetEnsInterfaceDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
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
/// CreatDate：2012-07-06
/// Description：删除接口表中数据
/// Table：
/// Input：
/// Return：0^成功
/// Others：w ##class(web.DHCENS.STBLL.UTIL.EnsInterface).DeleteEnsInterface()
ClassMethod DeleteEnsInterface() As %String
{
	Do DISABLE^%SYS.NOJRN
	set IntDate=+$h-3
	&sql(SELECT TOP 1 transfer_insdate into :tDate FROM SQLUSER.Ens_InterfaceV8)
	for i=tDate:1:IntDate
	{	
		&SQL(DELETE %NOLOCK FROM SQLUSER.Ens_InterfaceV8 WHERE transfer_InsDate<:i)
	}
	Do ENABLE^%SYS.NOJRN
	if (SQLCODE=0){
		Quit "0^成功"
	}
	else{
		Quit "-1^失败"
	}
}

}
