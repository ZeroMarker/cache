/// <H3>监控结果表</H3>
/// <H4>创建者：李阳</H4>
/// <H4>创建日期：2012-06-17</H4>
Class DHCMed.CC.CtlResult Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %Integer;

/// 记录日期
Property RecordDate As %Date;

/// 监控项目指针,指向 DHCMed.CC.SubjectItm
Property ItemId As %Integer;

/// 结果日期
Property ActDate As %Date;

/// 结果时间
Property ActTime As %Time;

/// 摘要信息,用于页面展现
Property Summary As %String(MAXLEN = 1000, TRUNCATE = 0);

/// 数据值
Property DataValue As %String(MAXLEN = 1000, TRUNCATE = 0);

/// 数据定值
Property DataText As %String(MAXLEN = 1000, TRUNCATE = 0);

/// 业务数据指针
Property ObjectID As %String(MAXLEN = 200, TRUNCATE = 1);

/// 操作员,指向SS_User
Property UserID As %Integer;

/// 操作员
Property UserName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 自定义数据项
Property Parameters As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 主题ID
Property SubjectID As %Integer;

/// 分数
Property Score As %Float;

/// (作废)绝对项目
Property IsAbsolute As %Boolean;

/// 关键字,指向 DHCMed.CC.KeyWord
Property KeyWord As %Integer;

/// (作废)是否是敏感条件
Property IsSensitive As %Boolean;

/// (作废)是否是特异性条件
Property IsSpecificity As %Boolean;

/// 发生日期
Property OccurDate As %Date;

/// 发生时间
Property OccurTime As %Time;

/// 业务数据类别（LAB、OE、CHK、OBS）
Property ObjCategory As %String;

/// 业务开始日期
Property ObjSttDate As %Date;

/// 业务开始时间
Property ObjSttTime As %Time;

/// 业务结束日期
Property ObjEndDate As %Date;

/// 业务结束时间
Property ObjEndTime As %Time;

/// 触发日期、Paadm的索引
Index IndexActDateEpisodeID On (ActDate, EpisodeID, ItemId, ObjectID);

/// 发生日期、Paadm的索引
Index IndexOccurDateEpisodeID On (OccurDate, EpisodeID, ItemId, ObjectID);

Index IndexSubjectItemID On (EpisodeID, ItemId);

/// 就诊、监控主题索引
Index IndexEpisodeSubject On (EpisodeID, SubjectID);

/// 就诊、关键字索引
Index IndexEpisodeKeyword On (EpisodeID, SubjectID, KeyWord);

/// 主题、关键字、触发日期
Index IndexSubjectKeyword On (SubjectID, KeyWord, ActDate);

/// 主题、EpisodeID、触发日期
Index IndexSubjectEpisodeActDate On (ActDate, EpisodeID, SubjectID);

/// 就诊索引
Index IndexEpisodeID On EpisodeID;

/// 主题、关键字、业务数据指针
Index IndexSubjectKeywordObjectID On (SubjectID, KeyWord, ObjectID);

/// <H3>功能：将对象的内容用String表示出来</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>seperator</B>：分隔符，默认是  ^  </LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果程序运行成功返回对象转换后的String
Method ToString(seperator As %String = "^") As %String
{
	Set ret=..%Id()_seperator
	Set ret=ret_..EpisodeID_seperator
	Set ret=ret_$zd(+..RecordDate,3)_seperator
	Set ret=ret_..ItemId_seperator
	Set ret=ret_$zd(+..ActDate,3)_seperator
	Set ret=ret_$zt(+..ActTime,1)_seperator
	Set ret=ret_..Summary_seperator
	Set ret=ret_..DataValue_seperator
	Set ret=ret_..ObjectID_seperator
	Set ret=ret_..UserID_seperator
	Set ret=ret_..Parameters_seperator
	Set ret=ret_..SubjectID_seperator
	Set ret=ret_..Score_seperator
	Set ret=ret_..IsAbsolute_seperator
	Set ret=ret_..KeyWord_seperator
	Set ret=ret_..IsSensitive_seperator
	Set ret=ret_..IsSpecificity_seperator
	Quit ret
}

/// <H3>功能：通过ID获取对象的实例</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>id</B>：<B>DHCMed.CC.CtlResult</B>对象的%Id()值，即RowID</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果程序运行成功返回对象实例，否则返回空字符串
ClassMethod GetObjById(id As %String) As DHCMed.CC.CtlResult
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.CtlResult).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.CtlResult).%OpenId(+id)
	set:obj.OccurDate="" obj.OccurDate=obj.ActDate
	set:obj.OccurTime="" obj.OccurTime=obj.ActTime
	if (obj.ObjCategory="OE"){
		set OEItemID=obj.ObjectID
		set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
		if $IsObject(objOEItem){
			set obj.ObjEndDate=objOEItem.OEORIXDate
			set obj.ObjEndTime=objOEItem.OEORIXTime
		}
	}
	if (obj.UserID'="")&&(obj.UserName'="") {
		Set UserName=$p(^SSU("SSUSR",obj.UserID),"^",2)
		Set:(UserName'=obj.UserName) obj.UserID=""
	}
	if (obj.DataText="") {
		Set obj.DataText=obj.DataValue
	}
	set return=obj
	do obj.%Close()
	quit return
}

/// <H3>功能：通过ID删除指定对象</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>id</B>：DHCMed.CC.CtlResult对象的%Id()值，即RowID</LI>
/// </OL>
/// <H4>返回值:</H4>
///  成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.CtlResult).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// <H3>功能：保存监控结果明细记录</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>InStr</B>：保存的数据，以seperator指定的分隔符分割。
/// 传入顺序是：RowID^EpisodeID^RecordDate^ItemId^ActDate^ActTime^Summary^DataValue^ObjectID^UserID^Parameters^SubjectID^Score^IsAbsolute^KeyWord^IsSensitive^IsSpecificity</LI>
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
	
	//以下四个子段为非空字段
	set EpisodeID=$p(InStr,seperator,2)
	set ItemId=$p(InStr,seperator,4)
	set ActDate=$p(InStr,seperator,5)
	set ObjectID=$p(InStr,seperator,9)
	quit:(EpisodeID="")||(ItemId="")||(ActDate="")||(ObjectID="") id
	
	//根据唯一索引查询ID
	if ID="" {
		set ID=$o(^DHCMed.CC.CtlResultI("Detail","IndexActDateEpisodeID",ActDate,EpisodeID,ItemId," "_$zcvt(ObjectID,"U"),0))
	}
	
	if ID="" {
		set obj=##class(DHCMed.CC.CtlResult).%New()
	} else {
		set obj=##class(DHCMed.CC.CtlResult).%OpenId(ID)
	}
	set obj.EpisodeID=$p(InStr,seperator,2)
	set obj.RecordDate=$p(InStr,seperator,3)
	set obj.ItemId=$p(InStr,seperator,4)
	set obj.ActDate=$p(InStr,seperator,5)
	set obj.ActTime=$p(InStr,seperator,6)
	set obj.Summary=$p(InStr,seperator,7)
	set obj.DataValue=$p($p(InStr,seperator,8),"!!",1)
	set obj.DataText=$p($p(InStr,seperator,8),"!!",2)
	set:obj.DataText="" obj.DataText=obj.DataValue
	set obj.ObjectID=$p(InStr,seperator,9)
	set obj.UserID=$p($p(InStr,seperator,10),"/",1)
	set obj.UserName=$p($p(InStr,seperator,10),"/",2)
	set obj.Parameters=$p(InStr,seperator,11)
	Set obj.SubjectID=$p(InStr,seperator,12)
	Set obj.Score=$p(InStr,seperator,13)
	Set obj.IsAbsolute=+$p(InStr,seperator,14)
	Set obj.KeyWord=+$p(InStr,seperator,15)
	set obj.IsSensitive=$p(InStr,seperator,16)
	set obj.IsSpecificity=$p(InStr,seperator,17)
	set obj.OccurDate=$p(InStr,seperator,18)
	set:obj.OccurDate="" obj.OccurDate=obj.ActDate
	set obj.OccurTime=$p(InStr,seperator,19)
	set:obj.OccurTime="" obj.OccurTime=obj.ActTime
	set obj.ObjCategory=$p(InStr,seperator,20)
	set obj.ObjSttDate=$p(InStr,seperator,21)
	set obj.ObjSttTime=$p(InStr,seperator,22)
	set obj.ObjEndDate=$p(InStr,seperator,23)
	set obj.ObjEndTime=$p(InStr,seperator,24)
	
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

/// w ##Class(DHCMed.CC.CtlResult).UpdateEndDate()
ClassMethod UpdateEndDate(aResultID As %String, aEndDate As %String, aEndTime As %String) As %String
{
	new (aResultID,aEndDate,aEndTime)
	set return=0
	quit:(aResultID="")||(aEndDate="")||(aEndTime="") return
	
	set obj=##class(DHCMed.CC.CtlResult).%OpenId(aResultID)
	quit:'$IsObject(obj) return
	set obj.ObjEndDate=aEndDate
	set obj.ObjEndTime=aEndTime
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	quit return
}

/// <H3>功能：清空某一天的监控明细记录</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>FromDate</B>：开始日期</LI>
/// <LI><B>ToDate</B>：结束日期</LI>
/// <LI><B>SubjectID</B>：监控主题ID，DHCMed.CC.Subject  %Id()</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果运行成功，返回字符串 OK
/// <H4>备注</H4>
/// <OL>
/// <LI>各日期字段允许的格式包括：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// <LI>各时间字段允许的格式包括：（1）Cache的时间格式，（2）HH:MM:SS格式</LI>
/// </OL>
ClassMethod ClearData(aFromDate As %String, aToDate As %String, aSubjectID As %Integer, aEpisodeID As %String, aKeywordID As %Integer) As %String
{
	New (aFromDate,aToDate,aSubjectID,aEpisodeID)
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") ""
	Set KeywordID=+$g(KeywordID)
	Set aEpisodeID=+$g(aEpisodeID)
	
	For tmpDate=aFromDate:1:aToDate {
		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,EpisodeID))
			Quit:EpisodeID=""
			;Continue:((aEpisodeID'=0)&&(aEpisodeID'=EpisodeID))
			Set RowID=""
			For {
				Set RowID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,EpisodeID,aSubjectID,RowID))
				Quit:RowID=""
				;Continue:((KeywordID'=0)&&($d(^DHCMed.CC.CtlResultI("Detail","IndexSubjectKeyword",aSubjectID,KeywordID,tmpDate))=0)) //Modified By LiYang 2012-10-30 可以按照关键字清除某个部分的数据
				Set flg=##class(DHCMed.CC.CtlResult).DeleteById(RowID)
			}
		}
	}
	
	Quit "OK"
}

Storage Default
{
<Data name="CtlResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActDate</Value>
</Value>
<Value name="3">
<Value>ActTime</Value>
</Value>
<Value name="4">
<Value>DataValue</Value>
</Value>
<Value name="5">
<Value>EpisodeID</Value>
</Value>
<Value name="6">
<Value>ItemId</Value>
</Value>
<Value name="7">
<Value>ObjectID</Value>
</Value>
<Value name="8">
<Value>Parameters</Value>
</Value>
<Value name="9">
<Value>RecordDate</Value>
</Value>
<Value name="10">
<Value>Summary</Value>
</Value>
<Value name="11">
<Value>UserID</Value>
</Value>
<Value name="12">
<Value>SubjectID</Value>
</Value>
<Value name="13">
<Value>Score</Value>
</Value>
<Value name="14">
<Value>IsAbsolute</Value>
</Value>
<Value name="15">
<Value>KeyWord</Value>
</Value>
<Value name="16">
<Value>IsSensitive</Value>
</Value>
<Value name="17">
<Value>IsSpecificity</Value>
</Value>
<Value name="18">
<Value>OccurDate</Value>
</Value>
<Value name="19">
<Value>OccurTime</Value>
</Value>
<Value name="20">
<Value>ObjCategory</Value>
</Value>
<Value name="21">
<Value>ObjSttDate</Value>
</Value>
<Value name="22">
<Value>ObjSttTime</Value>
</Value>
<Value name="23">
<Value>ObjEndDate</Value>
</Value>
<Value name="24">
<Value>ObjEndTime</Value>
</Value>
<Value name="25">
<Value>UserName</Value>
</Value>
<Value name="26">
<Value>DataText</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC.CtlResultD("Detail")</DataLocation>
<DefaultData>CtlResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC.CtlResultD("Detail")</IdLocation>
<IndexLocation>^DHCMed.CC.CtlResultI("Detail")</IndexLocation>
<StreamLocation>^DHCMed.CC.CtlResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
