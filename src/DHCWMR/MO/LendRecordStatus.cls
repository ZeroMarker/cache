/// 病案借阅状态表
Class DHCWMR.MO.LendRecordStatus Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.MO.LendRecord [ Cardinality = parent, Inverse = ChildStatus ];

/// 操作状态
Property RStatus As DHCWMR.SS.WorkItem;

/// 操作员（SS_User.ID）
Property RUserFrom As %String(MAXLEN = 100, TRUNCATE = 1);

/// 操作日期
Property RActDate As %Date;

/// 操作时间
Property RActTime As %Time;

/// 验证用户（SS_User.ID）
Property RUserTo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 操作批次（年月日+流水号）
Property RBatchNumber As %String(MAXLEN = 100, TRUNCATE = 1);

/// 撤销动作(作废U、回置B、修正R)
Property RUpdoOpera As %String(MAXLEN = 100, TRUNCATE = 1);

/// 撤销日期
Property RUpdoDate As %Date;

/// 撤销时间
Property RUpdoTime As %Time;

/// 撤销人
Property RUpdoUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 撤销原因
Property RUpdoReason As %String(MAXLEN = 500, TRUNCATE = 1);

/// 备注信息
Property RResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 批次号索引
Index IndexBatchNumber On RBatchNumber;

/// 操作日期时间索引
Index IndexActDateTime On (RActDate, RActTime);

/// Creator：     zhufei
/// CreatDate：   2015-09-30
/// Description:  更新病案借阅状态表
/// Table：       DHCWMR.MO.LendRecordStatus
/// Input：       InputStr ID^DHCWMR.MO.LendRecord.ID^DHCWMR.SS.Volume.ID
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(DHCWMR.MO.LendRecordStatus).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref			= $p(aInputStr,aSeparate,1)
	Set ChildSub        = $p(aInputStr,aSeparate,2)
	Set WorkItemID 		= $p(aInputStr,aSeparate,3)
	Set UserFrom 		= $p(aInputStr,aSeparate,4)
	Set ActDate 		= $p(aInputStr,aSeparate,5)
	set:ActDate["-" ActDate=$zdh(ActDate,3)
	set:ActDate["/" ActDate=$zdh(ActDate,4)
	set:ActDate="" ActDate=+$h
	Set ActTime 		= $p(aInputStr,aSeparate,6)
	set:ActTime[":" ActTime=$zth(ActTime,1)
	set:ActTime="" ActTime=$p($h,",",2)
	Set UserTo   		= $p(aInputStr,aSeparate,7)
	Set BatchNumber		= $p(aInputStr,aSeparate,8)
	Set StatusID 		= $p(aInputStr,aSeparate,9)
	Set UpdoOpera       = $p(aInputStr,aSeparate,10)
	Set UpdoDate        = $p(aInputStr,aSeparate,11)
	Set UpdoTime        = $p(aInputStr,aSeparate,12)
	Set UpdoUser        = $p(aInputStr,aSeparate,13)
	Set UpdoReason      = $p(aInputStr,aSeparate,14)
	Set Resume          = $p(aInputStr,aSeparate,15)
	Quit:(Parref="")||(WorkItemID="")||(BatchNumber="") return
	
	Set objParref = ##class(DHCWMR.MO.LendRecord).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	Set objWorkItem = ##class(DHCWMR.SS.WorkItem).GetObjById(WorkItemID)
	Quit:'$IsObject(objWorkItem) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.MO.LendRecordStatus).%New()
	} Else {
		Set obj=##class(DHCWMR.MO.LendRecordStatus).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref			= objParref
	Set obj.RStatus		    = objWorkItem
	Set obj.RUserFrom       = UserFrom
	Set obj.RActDate        = ActDate
	Set obj.RActTime        = ActTime
	Set obj.RUserTo         = UserTo
	Set obj.RBatchNumber    = BatchNumber
	Set obj.RUpdoOpera      = UpdoOpera
	Set obj.RUpdoDate       = UpdoDate
	Set obj.RUpdoTime       = UpdoTime
	Set obj.RUpdoUser       = UpdoUser
	Set obj.RUpdoReason     = UpdoReason
	Set obj.RResume         = Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-30
/// Description:  取病案借阅状态表
/// Table：       DHCWMR.MO.LendRecordStatus
/// Input：       Id : DHCWMR.MO.LendRecordStatus.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MO.LendRecordStatus).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MO.LendRecordStatus
{
	new (aId)
	quit:'##class(DHCWMR.MO.LendRecordStatus).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MO.LendRecordStatus).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-09-30
/// Description:  删除病案借阅状态表
/// Table：       DHCWMR.MO.LendRecordStatus
/// Input：       Id : DHCWMR.MO.LendRecordStatus.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCWMR.MO.LendRecordStatus).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RStatus</Value>
</Value>
<Value name="3">
<Value>RUserFrom</Value>
</Value>
<Value name="4">
<Value>RActDate</Value>
</Value>
<Value name="5">
<Value>RActTime</Value>
</Value>
<Value name="6">
<Value>RUserTo</Value>
</Value>
<Value name="7">
<Value>RBatchNumber</Value>
</Value>
<Value name="8">
<Value>RUpdoOpera</Value>
</Value>
<Value name="9">
<Value>RUpdoDate</Value>
</Value>
<Value name="10">
<Value>RUpdoTime</Value>
</Value>
<Value name="11">
<Value>RUpdoUser</Value>
</Value>
<Value name="12">
<Value>RUpdoReason</Value>
</Value>
<Value name="13">
<Value>RResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("S")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("S")</IdLocation>
<IndexLocation>^DHCWMR.MO.LendRecordI("STATUS")</IndexLocation>
<StreamLocation>^DHCWMR.MO.LendRecordStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
