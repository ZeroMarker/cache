/// 名称: DHCHAI.IR.ASPAntiRecord
/// 描述: 抗菌用药记录表
/// 编写者：mayanpeng
/// 编写日期: 2017-12-26
Class DHCHAI.IR.ASPAntiRecord Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 抗菌用药字典
Property IRAntiMastDr As DHCHAI.DP.OEAntiMast [ Required ];

/// 开医嘱科室
Property IROrdLocDr As DHCHAI.BT.Location;

/// 开医嘱科室（ID|Code|Desc）
Property IROrdLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 开医嘱医生（ID|Code|Desc）
Property IRDoctor As %String(MAXLEN = 100, TRUNCATE = 1);

/// 用药开始日期
Property IRSttDate As %Date;

/// 用药开始时间
Property IRSttTime As %Time;

/// 用药停止日期
Property IRXDate As %Date;

/// 用药停止时间
Property IRXTime As %Time;

/// 用药天数
Property IRDates As %Integer;

/// 药品状态("IRASPAntiRecordType")
Property IRStatusDr As DHCHAI.BT.Dictionary;

/// 就诊记录索引
Index IndexIREpisodeDr On IREpisodeDr;

/// 就诊药品开始时间索引
Index IndexEpiAntiSttDt On (IREpisodeDr, IRAntiMastDr, IRSttDate);

/// Creator：     mayanpeng
/// CreatDate：   2017-12-26
/// Description:  根据ID取抗菌用药记录表
/// Table：       DHCHAI.IR.ASPAntiRecord
/// Input：       ID:    DHCHAI.IR.ASPAntiRecord.ID
/// Return：      返回Object
/// w ##class(DHCHAI.IR.ASPAntiRecord).GetObjById(1)
ClassMethod GetObjById(ID As %String) As DHCHAI.IR.ASPAntiRecord
{
	New (ID)
	Set return=""
	Quit:ID="" return
	Quit:'##class(DHCHAI.IR.ASPAntiRecord).%ExistsId(+ID) return
	
	Set obj=##Class(DHCHAI.IR.ASPAntiRecord).%OpenId(+ID)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-12-26
/// Description:  更新抗菌用药记录表
/// Table：       DHCHAI.IR.ASPAntiRecord
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ASPAntiRecord).Update("^532^1^1^||心内科^||张三^2017-12-21^12:00:00^^^12^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set EpisodeDr	= $p(InStr,aSeparete,2)
	Set AntiMastDr	= $p(InStr,aSeparete,3)
	Set OrdLocDr	= $p(InStr,aSeparete,4)
	Set OrdLoc		= $p(InStr,aSeparete,5)
	Set Doctor		= $p(InStr,aSeparete,6)
	Set SttDate		= $p(InStr,aSeparete,7)
	Set SttTime 	= $p(InStr,aSeparete,8)
	Set XDate		= $p(InStr,aSeparete,9)
	Set XTime 		= $p(InStr,aSeparete,10)
	Set Dates 		= $p(InStr,aSeparete,11)
	Set StatusDr	= $p(InStr,aSeparete,12)
	Quit:(EpisodeDr="")||(AntiMastDr="") return
	
	Set:SttDate["-" SttDate = $zdh(SttDate,3)
	Set:SttTime[":" SttTime = $zth(SttTime,1)
	Set:XDate["-" XDate = $zdh(XDate,3)
	Set:XTime[":" XTime = $zth(XTime,1)
	Set:XDate="" XDate = +$h
	Set:XTime="" XTime = +($p($h,",",2))
	
	Set objEpisode = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set objAntiMast = ##class(DHCHAI.DP.OEAntiMast).GetObjById(AntiMastDr)
	Quit:'$IsObject(objAntiMast) return
	Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(OrdLocDr)
	Set objStatus=""
	If StatusDr'=""{
		Set objStatus = ##class(DHCHAI.BT.Dictionary).GetObjById(StatusDr)
		Quit:'$IsObject(objStatus) return
	}
	
	if ID="" {
		Set obj=##class(DHCHAI.IR.ASPAntiRecord).%New()
	}else{
		Set obj=##class(DHCHAI.IR.ASPAntiRecord).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.IREpisodeDr	= objEpisode
	Set obj.IRAntiMastDr= objAntiMast
	Set obj.IROrdLocDr	= objLoc
	Set obj.IROrdLoc	= OrdLoc
	Set obj.IRDoctor	= Doctor
	Set obj.IRSttDate 	= SttDate
	Set obj.IRSttTime	= SttTime
	Set obj.IRXDate		= XDate
	Set obj.IRXTime 	= XTime
	Set obj.IRDates 	= Dates
	Set obj.IRStatusDr 	= objStatus
	
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

/// Creator：     mayanpeng
/// CreatDate：   2017-12-26
/// Description:  根据ID删除抗菌用药记录表
/// Table：       DHCHAI.IR.ASPAntiRecord
/// Input：       ID
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(ID As %String) As %String
{
	New (ID)
	Set sc = ##class(DHCHAI.IR.ASPAntiRecord).%DeleteID(+ID)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="ASPAntiRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IRAntiMastDr</Value>
</Value>
<Value name="4">
<Value>IROrdLocDr</Value>
</Value>
<Value name="5">
<Value>IROrdLoc</Value>
</Value>
<Value name="6">
<Value>IRDoctor</Value>
</Value>
<Value name="7">
<Value>IRSttDate</Value>
</Value>
<Value name="8">
<Value>IRSttTime</Value>
</Value>
<Value name="9">
<Value>IRXDate</Value>
</Value>
<Value name="10">
<Value>IRXTime</Value>
</Value>
<Value name="11">
<Value>IRDates</Value>
</Value>
<Value name="12">
<Value>IRStatusDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.ASPAntiRecordD</DataLocation>
<DefaultData>ASPAntiRecordDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.ASPAntiRecordD</IdLocation>
<IndexLocation>^DHCHAI.IR.ASPAntiRecordI</IndexLocation>
<StreamLocation>^DHCHAI.IR.ASPAntiRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
