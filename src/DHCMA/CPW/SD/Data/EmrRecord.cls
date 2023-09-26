/// 电子病历信息记录
Class DHCMA.CPW.SD.Data.EmrRecord Extends (%Persistent, DHCHAI.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property EpisodeID As %String [ Required ];

/// 文档类型
Property DocType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文档标题
Property DocTitle As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文档子标题
Property DocTitleSub As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文档日期
Property DocDate As %Date;

/// 文档内容
Property DocContent As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 术语集代码
Property HDSDCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 发生日期
Property ActDate As %Date;

/// 发生时间
Property ActTime As %Time;

/// 记录医生（ID|Code|Desc）
Property ActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property IsActive As %Boolean [ Required ];

/// 更新日期
Property UpdateDate As %Date [ Required ];

/// 更新时间
Property UpdateTime As %Time [ Required ];

/// 解析后文本
Property AnalyDocContent As %String(MAXLEN = 100000);

/// 就诊记录 索引
Index IndexAdm On EpisodeID As Exact;

/// 文档日期 索引
Index IndexDocDate On DocDate;

/// 就诊记录 + 日期 索引
Index IndexAdmDocDate On (EpisodeID As Exact, DocDate);

/// 就诊记录 + 病历类型 索引
Index IndexAdmDocType On (EpisodeID As Exact, DocType As Exact);

/// 就诊记录 + 日期 + 术语集 索引
Index IndexAdmDDHD On (EpisodeID As Exact, DocDate, HDSDCode As Exact);

/// 更新日期 索引
Index IndexAdmUpdateDate On (EpisodeID As Exact, UpdateDate);

/// Description:  根据ID作废病历记录
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.EmrRecord).CancelById(1)
ClassMethod CancelById(id As %String) As %String
{
	New (id)
	Set return=""
	Quit:id="" return
	
	Set obj=##class(DHCMA.CPW.SD.Data.EmrRecord).%OpenId(id)
	Quit:'$IsObject(obj) return
	Set obj.EmrIsActive   = 0
	Set obj.EmrUpdateDate = +$h
	Set obj.EmrUpdateTime = $p($h,",",2)
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Description:  根据ID取电子病历内容
/// Table：       DHCMA.CPW.SD.Data.EmrRecord
/// Input：       ID:    DHCMA.CPW.SD.Data.EmrRecord.ID
/// Return：      返回Object
/// w ##class(DHCMA.CPW.SD.Data.EmrRecord).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMA.CPW.SD.Data.EmrRecord
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCMA.CPW.SD.Data.EmrRecord).%ExistsId(+id) return
	
	Set obj=##Class(DHCMA.CPW.SD.Data.EmrRecord).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Description:  更新电子病历内容
/// Table：       DHCMA.CPW.SD.Data.EmrRecord
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Data.EmrRecord).Update("^315^日常病程^查房记录^2021-09-01^1^^^^1^^^^HDSD00.14.139")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set EpisodeID	= $p(InStr,aSeparete,2)
	Set DocType		= $p(InStr,aSeparete,3)
	Set DocTitle	= $p(InStr,aSeparete,4)
	Set DocDate		= $p(InStr,aSeparete,5)
	Set DocContent	= $p(InStr,aSeparete,6)
	Set ActDate		= $p(InStr,aSeparete,7)
	Set ActTime		= $p(InStr,aSeparete,8)
	Set ActUser		= $p(InStr,aSeparete,9)
	Set IsActive	= +$p(InStr,aSeparete,10)
	Set UpdateDate	= $p(InStr,aSeparete,11)
	Set UpdateTime	= $p(InStr,aSeparete,12)
	Set DocTitleSub = $p(InStr,aSeparete,13)
	Set HDSDCode  	= $p(InStr,aSeparete,14)
	Set AnalyDocContent	= $p(InStr,aSeparete,15)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Set:DocDate["-" DocDate = $zdh(DocDate,3)
	Set:ActDate["-" ActDate = $zdh(ActDate,3)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Quit:(EpisodeID="")||(DocType="")||(DocTitle="")||(DocDate="")||(ActDate="")||(ActTime="")||(ActUser="")||(IsActive="") return
	//子系统代码+记录索引码 唯一性
	
	Set:ID="" ID=$o(^DHCMA.CPW.SD.Data.EmrRecordI("IndexAdmDDHD",EpisodeID,DocDate,HDSDCode,0))
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.Data.EmrRecord).%New()
	}else{
		Set obj=##class(DHCMA.CPW.SD.Data.EmrRecord).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EpisodeID		= EpisodeID
	Set obj.DocType 		= DocType
	Set obj.DocTitle		= DocTitle
	Set obj.DocTitleSub		= DocTitleSub
	Set obj.DocDate			= DocDate
	Set obj.DocContent		= DocContent
	Set obj.HDSDCode		= HDSDCode
	Set obj.ActDate			= ActDate
	Set obj.ActTime			= ActTime
	Set obj.ActUser			= ActUser	
	Set obj.IsActive		= IsActive
	Set obj.UpdateDate		= +$h
	Set obj.UpdateTime		= $p($h,",",2)
	Set obj.AnalyDocContent	= AnalyDocContent
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Description:  删除电子病历内容
/// Table：       DHCMA.CPW.SD.Data.EmrRecord
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCMA.CPW.SD.Data.EmrRecord).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="EmrRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>DocTitle</Value>
</Value>
<Value name="4">
<Value>DocTitleSub</Value>
</Value>
<Value name="5">
<Value>DocDate</Value>
</Value>
<Value name="6">
<Value>DocContent</Value>
</Value>
<Value name="7">
<Value>HDSDCode</Value>
</Value>
<Value name="8">
<Value>ActDate</Value>
</Value>
<Value name="9">
<Value>ActTime</Value>
</Value>
<Value name="10">
<Value>ActUser</Value>
</Value>
<Value name="11">
<Value>IsActive</Value>
</Value>
<Value name="12">
<Value>UpdateDate</Value>
</Value>
<Value name="13">
<Value>UpdateTime</Value>
</Value>
<Value name="14">
<Value>DocType</Value>
</Value>
<Value name="15">
<Value>AnalyDocContent</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Data.EmrRecordD</DataLocation>
<DefaultData>EmrRecordDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Data.EmrRecordD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Data.EmrRecordI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Data.EmrRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
