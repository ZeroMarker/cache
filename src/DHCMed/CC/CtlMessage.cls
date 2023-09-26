/// <H3>交互信息</H4>
Class DHCMed.CC.CtlMessage Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 就诊ID
Property EpisodeID As %Integer;

/// 监控主题
Property SubjectID As %Integer;

/// 消息内容
Property Message As %String(MAXLEN = 500, TRUNCATE = 1);

/// 发送用户
Property SendUser As %Integer;

/// 发送日期
Property SendDate As %Date;

/// 发送时间
Property SendTime As %Time;

/// 标题
Property Title As %String(TRUNCATE = 1);

Index IndexEpisodeSubjectID On (EpisodeID, SubjectID);

/// <H3>功能：通过ID获取对象的实例</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>id</B>：<B>DHCMed.CC.CtlMessage</B>对象的%Id()值，即RowID</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果程序运行成功返回对象实例，否则返回空字符串
ClassMethod GetObjById(id As %String) As DHCMed.CC.CtlMessage
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.CtlMessage).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.CtlMessage).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// <H3>功能：通过ID删除指定对象</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>id</B>：DHCMed.CC.CtlMessage对象的%Id()值，即RowID</LI>
/// </OL>
/// <H4>返回值:</H4>
///  成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.CtlMessage).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// <H3>功能：保存监控筛查规则记录</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>InStr</B>：保存的数据，以seperator指定的分隔符分割。
/// 传入顺序是：RowID^EpisodeID^SubjectID^Message^SendUser^SendDate^SendTime^Title</LI>
/// <LI><B>seperator</B>：分割符，默认是 ^</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果保存成功，返回新生成数据的RowID，否则返回错误代码（错误代码<0）
/// <H4>备注</H4>
/// <OL>
/// <LI>各日期字段允许的格式包括：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY，如果未指明，则系统自动填入当前日期</LI>
/// <LI>各时间字段允许的格式包括：（1）Cache的时间格式，（2）HH:MM:SS格式，如果未指明，则系统自动填入当前时间</LI>
/// </OL>
ClassMethod Update(InStr As %String, seperator As %String = "^") As %String
{
	new (InStr,seperator)
	set id=0
	set ID=$p(InStr,seperator,1)	
	if ID="" {
		set obj=##class(DHCMed.CC.CtlMessage).%New()
		} 
	else {
		set obj=##class(DHCMed.CC.CtlMessage).%OpenId(ID)
		}
	set obj.EpisodeID=$p(InStr,seperator,2)
	set obj.SubjectID=$p(InStr,seperator,3)
	set obj.Message=$p(InStr,seperator,4)
	set obj.SendUser=$p(InStr,seperator,5)
	Set tmpDate=$p(InStr,seperator,6)
	Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
	Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
	Set:tmpDate="" tmpDate=+$h
	set obj.SendDate=tmpDate
	Set tmpTime=$p(InStr,seperator,7)
	Set:tmpTime[":" tmpTime=$zth(tmpTime,1)
	Set:tmpTime="" tmpTime=$p($h,",",2)
	set obj.SendTime=tmpTime
	Set obj.Title=$p(InStr,seperator,8)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// 
/// <H3>功能：通过Paadm，主题ID获取交互消息列表</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>EpisodeID</B>：就诊ID，PAADM</LI>
/// <LI><B>SubjectID</B>：监控主题ID，DHCMed.CC.SubjectItm的%Id()值</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <OL>
/// <LI>RowID:%String :<B>DHCMed.CC.CtlMessage</B>类的ROWID</LI>
/// <LI>Title:%String：标题</LI>
/// <LI>Message:%String：消息内容</LI>
/// <LI>SendUser:%String：发送用户（名字）</LI>
/// <LI>SendDate:%String：发送日期，格式YYYY-MM-DD</LI>
/// <LI>SendTime:%String：发送时间，格式HH:MM</LI>
/// </OL>
/// <H4>实例：</H4>
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.CC.CtlMessage","QryByEpisodeSubject",20309278,1)
Query QryByEpisodeSubject(EpisodeID As %String, SubjectID As %String) As %Query(ROWSPEC = "RowID:%String,Title:%String,Message:%String,SendUser:%String,SendDate:%String,SendTime:%String")
{
}

ClassMethod QryByEpisodeSubjectExecute(ByRef qHandle As %Binary, EpisodeID As %String, SubjectID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(EpisodeID="")||(SubjectID)="" $$$OK
	
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.CC.CtlResultI("Message","IndexEpisodeSubjectID",EpisodeID,SubjectID,RowID))
		Quit:RowID=""
		Set objMsg=##class(DHCMed.CC.CtlMessage).GetObjById(RowID)
		Continue:$IsObject(objMsg)=""
		Set data=$$BuildQryByEpisodeSubject(objMsg)
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	
	Quit $$$OK
BuildQryByEpisodeSubject(objMsg)
	n (objMsg)
	Set data=$lb("")
	Set $li(data,1)=objMsg.%Id() //RowID:%String
	Set $li(data,2)=objMsg.Title // Title:%String
	Set $li(data,3)=objMsg.Message  // Message:%String
	Set objUser=##class(DHCMed.Base.SSUser).GetObjById(objMsg.SendUser)
	Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
	Set $li(data,4)=objUser.Name //SendUser:%String
	Set $li(data,5)=$zd(objMsg.SendDate,3) //SendDate:%String
	Set $li(data,6)=$zt(objMsg.SendTime,1)  //SendTime:%String
	Quit data
}

ClassMethod QryByEpisodeSubjectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByEpisodeSubjectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryByEpisodeSubjectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByEpisodeSubjectExecute ]
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

Storage Default
{
<Data name="CtlMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>SubjectID</Value>
</Value>
<Value name="4">
<Value>Message</Value>
</Value>
<Value name="5">
<Value>SendUser</Value>
</Value>
<Value name="6">
<Value>SendDate</Value>
</Value>
<Value name="7">
<Value>SendTime</Value>
</Value>
<Value name="8">
<Value>Title</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC.CtlResultD("Message")</DataLocation>
<DefaultData>CtlMessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC.CtlResultD("Message")</IdLocation>
<IndexLocation>^DHCMed.CC.CtlResultI("Message")</IndexLocation>
<StreamLocation>^^DHCMed.CC.CtlResultS("Summary")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
