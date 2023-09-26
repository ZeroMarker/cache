/// 名称: DHCHAI.DP.EmrRecord
/// 描述: 电子病历（入院记录、首程、日常病程、手术记录、会诊记录等）
/// 编写者：zhufei
/// 编写日期: 2017-08-08
Class DHCHAI.DP.EmrRecord Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property EmrEpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 文档类型
Property EmrDocTypeDr As DHCHAI.DP.EmrDocType [ Required ];

/// 文档标题
Property EmrDocTitle As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文档子标题
Property EmrDocTitleSub As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文档日期
Property EmrDocDate As %Date;

/// 文档内容
Property EmrDocContent As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 术语集代码
Property EmrDatItmCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 发生日期
Property EmrActDate As %Date;

/// 发生时间
Property EmrActTime As %Time;

/// 记录医生（ID|Code|Desc）
Property EmrActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码
Property EmrSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 记录索引码
Property EmrXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property EmrIsActive As %Boolean [ Required ];

/// 更新日期
Property EmrUpdateDate As %Date [ Required ];

/// 更新时间
Property EmrUpdateTime As %Time [ Required ];

/// 就诊记录 索引
Index IndexEpisodeDr On EmrEpisodeDr;

/// 文档日期 索引
Index IndexDocDate On EmrDocDate;

/// 就诊记录 + 文档日期 索引
Index IndexEpisodeDrDocDate On (EmrEpisodeDr, EmrDocDate);

/// 子系统代码+记录索引码 索引
Index IndexSXCode On (EmrSCode As Exact, EmrXCode As Exact);

/// 子系统代码+记录索引码 索引
Index IndexSXCode2 On (EmrSCode As Exact, EmrXCode As Exact, EmrDatItmCode As Exact);

/// 更新日期 索引
Index IndexEpisUpdateDate On (EmrEpisodeDr, EmrUpdateDate);

/// Creator：     zhufei
/// CreatDate：   2018-03-10
/// Description:  根据ID作废病程记录
/// Table：       DHCHAI.DP.EmrRecord
/// Input：       id:    DHCHAI.DP.EmrRecord.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.EmrRecord).CancelById(1)
ClassMethod CancelById(id As %String) As %String
{
	New (id)
	Set return=""
	Quit:id="" return
	
	Set obj=##class(DHCHAI.DP.EmrRecord).%OpenId(id)
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

/// Creator：     zhufei
/// CreatDate：   2017-08-08
/// Description:  根据ID取电子病历内容
/// Table：       DHCHAI.DP.EmrRecord
/// Input：       ID:    DHCHAI.DP.EmrRecord.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.EmrRecord).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.EmrRecord
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.EmrRecord).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.EmrRecord).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-08
/// Description:  根据索引码取电子病历内容
/// Table：       DHCHAI.DP.EmrRecord
/// Input：       aSCode:DHCHAI.DP.EmrRecord.EmrSCode
/// 			  aXCode:DHCHAI.DP.EmrRecord.EmrXCode
/// Return：      返回Object
/// w ##class(DHCHAI.DP.EmrRecord).GetObjByXCode("EMR02","9225||1","")
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String, aEmrCode As %String = "") As DHCHAI.DP.EmrRecord
{
	New (aSCode,aXCode,aEmrCode)
	Set return=""
	Quit:(aSCode="")||(aXCode="") return
	
	Set id = ""
	If aEmrCode'="" {
		Set id=$o(^DHCHAI.DP.EmrRecordI("IndexSXCode2",aSCode,aXCode,aEmrCode,0))
		If id="" {
			//兼容历史数据程序处理
			Set tId=$o(^DHCHAI.DP.EmrRecordI("IndexSXCode",aSCode,aXCode,0))
			If tId'="" {
				Set tObj=##class(DHCHAI.DP.EmrRecord).GetObjById(tId)
				Quit:'$IsObject(tObj) return
				Quit:tObj.EmrDatItmCode'="" return
				Set id=tId
			}
		}
	} Else {
		Set id=$o(^DHCHAI.DP.EmrRecordI("IndexSXCode",aSCode,aXCode,0))
	}
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-08
/// Description:  更新电子病历内容
/// Table：       DHCHAI.DP.EmrRecord
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.EmrRecord).Update("^300^1^上级医师查房^2017-02-08^病历3^2017-02-08^18:00:00^刘杰^EMR01^3^1^2017-01-01^18:00:00")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set EpisodeDr	= $p(InStr,aSeparete,2)
	Set DocTypeDr   = $p(InStr,aSeparete,3)
	Set DocTitle	= $p(InStr,aSeparete,4)
	Set DocDate		= $p(InStr,aSeparete,5)
	Set DocContent	= $p(InStr,aSeparete,6)
	Set ActDate		= $p(InStr,aSeparete,7)
	Set ActTime		= $p(InStr,aSeparete,8)
	Set ActUser		= $p(InStr,aSeparete,9)
	Set SCode		= $p(InStr,aSeparete,10)
	Set XCode		= $p(InStr,aSeparete,11)
	Set IsActive	= +$p(InStr,aSeparete,12)
	Set UpdateDate	= $p(InStr,aSeparete,13)
	Set UpdateTime	= $p(InStr,aSeparete,14)
	Set DocTitleSub = $p(InStr,aSeparete,15)
	Set DatItmCode  = $p(InStr,aSeparete,16)
	Set:DocDate["-" DocDate = $zdh(DocDate,3)
	Set:ActDate["-" ActDate = $zdh(ActDate,3)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Quit:(EpisodeDr="")||(DocTypeDr="")||(DocTitle="")||(DocDate="")||(ActDate="")||(ActTime="")||(ActUser="")||(SCode="")||(XCode="")||(IsActive="") return
	
	//子系统代码+记录索引码 唯一性
	If DatItmCode'="" {
		Set tID=$o(^DHCHAI.DP.EmrRecordI("IndexSXCode2",SCode,XCode,DatItmCode,0))
	} Else {
		Set tID=$o(^DHCHAI.DP.EmrRecordI("IndexSXCode",SCode,XCode,0))
	}
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$isobject(objAdm) return
	Set objDocType = ##class(DHCHAI.DP.EmrDocType).GetObjById(DocTypeDr)
	Quit:'$isobject(objDocType) return
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.EmrRecord).%New()
	}else{
		Set obj=##class(DHCHAI.DP.EmrRecord).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EmrEpisodeDr	= objAdm
	Set obj.EmrDocTypeDr 	= objDocType
	Set obj.EmrDocTitle		= DocTitle
	Set obj.EmrDocTitleSub  = DocTitleSub
	Set obj.EmrDocDate		= DocDate
	Set obj.EmrDocContent	= DocContent
	Set obj.EmrDatItmCode   = DatItmCode
	Set obj.EmrActDate		= ActDate
	Set obj.EmrActTime		= ActTime
	Set obj.EmrActUser		= ActUser	
	Set obj.EmrSCode		= SCode
	Set obj.EmrXCode		= XCode
	Set obj.EmrIsActive		= IsActive
	Set obj.EmrUpdateDate	= +$h
	Set obj.EmrUpdateTime	= $p($h,",",2)
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

/// Creator：     zhufei
/// CreatDate：   2017-08-08
/// Description:  删除电子病历内容
/// Table：       DHCHAI.DP.EmrRecord
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.EmrRecord).%DeleteId(+Id)
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
<Value>EmrEpisodeDr</Value>
</Value>
<Value name="3">
<Value>EmrDocTypeDr</Value>
</Value>
<Value name="4">
<Value>EmrDocTitle</Value>
</Value>
<Value name="5">
<Value>EmrDocDate</Value>
</Value>
<Value name="6">
<Value>EmrDocContent</Value>
</Value>
<Value name="7">
<Value>EmrActDate</Value>
</Value>
<Value name="8">
<Value>EmrActTime</Value>
</Value>
<Value name="9">
<Value>EmrActUser</Value>
</Value>
<Value name="10">
<Value>EmrSCode</Value>
</Value>
<Value name="11">
<Value>EmrXCode</Value>
</Value>
<Value name="12">
<Value>EmrIsActive</Value>
</Value>
<Value name="13">
<Value>EmrUpdateDate</Value>
</Value>
<Value name="14">
<Value>EmrUpdateTime</Value>
</Value>
<Value name="15">
<Value>EmrDocTitleSub</Value>
</Value>
<Value name="16">
<Value>EmrDatItmCode</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.EmrRecordD</DataLocation>
<DefaultData>EmrRecordDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.EmrRecordD</IdLocation>
<IndexLocation>^DHCHAI.DP.EmrRecordI</IndexLocation>
<StreamLocation>^DHCHAI.DP.EmrRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
