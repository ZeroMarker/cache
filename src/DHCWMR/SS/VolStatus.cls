/// 病案卷操作记录
Class DHCWMR.SS.VolStatus Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.SS.Volume [ Cardinality = parent, Inverse = ChildStatus ];

/// 操作状态
Property VSStatus As DHCWMR.SS.WorkItem;

/// 操作员（SS_User.ID）
Property VSUserFrom As %String(MAXLEN = 100, TRUNCATE = 1);

/// 操作日期
Property VSActDate As %Date;

/// 操作时间
Property VSActTime As %Time;

/// 验证用户（SS_User.ID）
Property VSUserTo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 操作批次（年月日+流水号）
Property VSBatchNumber As %String(MAXLEN = 100, TRUNCATE = 1);

/// 撤销动作(作废U、回置B、修正R)
Property VSUpdoOpera As %String(MAXLEN = 100, TRUNCATE = 1);

/// 撤销日期
Property VSUpdoDate As %Date;

/// 撤销时间
Property VSUpdoTime As %Time;

/// 撤销人
Property VSUpdoUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 撤销原因
Property VSUpdoReason As %String(MAXLEN = 500, TRUNCATE = 1);

/// 备注信息
Property VSResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// （作废）分类(纸张病历1、电子病历2)
Property VSCategory As %String(MAXLEN = 100, TRUNCATE = 1);

/// （作废）申请单
Property VSRequestDr As DHCWMR.SS.Request;

/// 关联号
Property VSLnkOperaDr As DHCWMR.SS.Operation;

/// 批次号索引
Index IndexBatchNumber On VSBatchNumber;

/// 病历分类、病案状态索引
Index IndexStatusCate On (Parref, VSCategory, VSStatus);

/// 关联操作索引
Index IndexLnkOperaDr On (Parref, VSLnkOperaDr);

/// Creator:          李阳
/// CreateDate:       2014-08-21
/// Description:      根据ID取病案卷状态信息
/// OperationTable:   DHCWMR.SS.VolStatus
/// Input:            Id : DHCWMR.SS.VolStatus.ID
/// Output:           返回Object
/// w ##Class(DHCWMR.SS.VolStatus).GetObjById(21)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.VolStatus
{
	new (aId)
	quit:'##class(DHCWMR.SS.VolStatus).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.VolStatus).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     李阳
/// CreatDate：   2014-08-19
/// Description:  更新病案卷信息
/// Table：       DHCWMR.SS.VolStatus
/// Input：       InputStr : 病案卷状态信息
///               Separate ：分隔符
/// Return：      返回String
/// w ##class(DHCWMR.SS.VolStatus).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set WorkItemID=$p(aInputStr,aSeparate,3)
	Set ActDate=$p(aInputStr,aSeparate,5)
	Set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set:ActDate="" ActDate=+$h
	Set ActTime=$p(aInputStr,aSeparate,6)
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	Set UpdoOpera=$p(aInputStr,aSeparate,9)
	Set UpdoDate=$p(aInputStr,aSeparate,10)
	Set:UpdoDate["-" UpdoDate=$zdh(UpdoDate,3)
	Set:(UpdoOpera'="")&&(UpdoDate="") UpdoDate=+$h
	Set UpdoTime=$p(aInputStr,aSeparate,11)
	Set:UpdoTime[":" UpdoTime=$zth(UpdoTime,1)
	Set:(UpdoOpera'="")&&(UpdoTime="") UpdoTime=$p($h,",",2)
	Set Resume = $p(aInputStr,aSeparate,14)
	Set Category = $p(aInputStr,aSeparate,15)
	Set RequestDr = $p(aInputStr,aSeparate,16)
	Set LnkOperaDr = $p(aInputStr,aSeparate,17)
	Quit:(Parref="")||(WorkItemID="") return
	
	Set objParref=##Class(DHCWMR.SS.Volume).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objWorkItem=##class(DHCWMR.SS.WorkItem).GetObjById(WorkItemID)
	Quit:'$IsObject(objWorkItem) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.SS.VolStatus).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.VolStatus).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objParref
	Set obj.VSStatus     = objWorkItem
	Set obj.VSUserFrom   = $p(aInputStr,aSeparate,4)
	Set obj.VSActDate    = ActDate
	Set obj.VSActTime    = ActTime
	Set obj.VSUserTo     = $p(aInputStr,aSeparate,7)	
	Set obj.VSBatchNumber= $p(aInputStr,aSeparate,8)
	Set obj.VSUpdoOpera  = UpdoOpera
	Set obj.VSUpdoDate   = UpdoDate
	Set obj.VSUpdoTime   = UpdoTime
	Set obj.VSUpdoUser   = $p(aInputStr,aSeparate,12)
	Set obj.VSUpdoReason = $p(aInputStr,aSeparate,13)
	Set obj.VSResume     = Resume
	Set obj.VSCategory   = 1
	Set obj.VSRequestDr  = ##class(DHCWMR.SS.Request).GetObjById(RequestDr)
	Set obj.VSLnkOperaDr = ##class(DHCWMR.SS.Operation).GetObjById(LnkOperaDr)
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
/// CreatDate：   2014-12-04
/// Description:  更新病案卷状态关联操作信息
/// Table：       DHCWMR.SS.VolStatus
/// Input：       StatusID : 状态ID
///               LnkOperaID ：关联操作
/// Return：      返回String
/// w ##class(DHCWMR.SS.VolStatus).UpdateLnkOpera()
ClassMethod UpdateLnkOpera(aStatusID As %String, aLnkOperaID As %String) As %String
{
	New (aStatusID,aLnkOperaID)
	Set return=0
	Quit:(aStatusID="")||(aLnkOperaID="") return
	
	Set obj=##class(DHCWMR.SS.VolStatus).%OpenId(aStatusID)
	Quit:'$IsObject(obj) return
	
	Set obj.VSLnkOperaDr = ##class(DHCWMR.SS.Operation).GetObjById(aLnkOperaID)
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
/// CreatDate：   2014-09-17
/// Description:  撤销病案卷操作记录
/// Table：       DHCWMR.SS.VolStatus
/// Input：       StatusID : 病案卷状态ID
///               OperaCode : 撤销操作代码（U作废、B回置）
///               UpdoReason : 撤销原因
///               UserID : 操作员
/// Return：      返回String
/// w ##class(DHCWMR.SS.VolStatus).UpdoUpdate(StatusID)
ClassMethod UpdoUpdate(aStatusID As %String, aOperaCode As %String, aUpdoReason As %String, aUserID As %String) As %String
{
	New (aStatusID,aOperaCode,aUpdoReason,aUserID)
	Set return=0
	Quit:(aStatusID="")||(aOperaCode="")||(aUserID="") return
	Quit:aOperaCode'="U" //卷状态非作废操作不调用此方法
	
	Set obj=##class(DHCWMR.SS.VolStatus).%OpenId(aStatusID)
	Quit:'$IsObject(obj) return
	
	Set obj.VSUpdoOpera  = aOperaCode
	Set obj.VSUpdoDate   = +$h
	Set obj.VSUpdoTime   = $p($h,",",2)
	Set obj.VSUpdoUser   = aUserID
	Set obj.VSUpdoReason = aUpdoReason
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		Set VolID=+return
		Set BatchNumber=obj.VSBatchNumber
		Do obj.%Close()
		
		Set LnkOperaID=""
		Set objOpera=##class(DHCWMR.SS.Operation).GetObjByBatchNumber(BatchNumber)
		If $IsObject(objOpera){
			Set LnkOperaID=objOpera.%Id()
		}
		If LnkOperaID'="" {
			Set xSubID=0
			For {
				Set xSubID=$o(^DHCWMR.SS.VolumeI("VS","IndexLnkOperaDr",VolID,LnkOperaID,xSubID))
				Quit:xSubID=""
				
				Set objLnk=##class(DHCWMR.SS.VolStatus).%OpenId(VolID_"||"_xSubID)
				Continue:'$IsObject(objLnk)
				Set objLnk.VSLnkOperaDr = ""
				Set sc=objLnk.%Save()
				If $System.Status.IsError(sc) {  //检查Save是否成功
			   		Do $System.OBJ.DisplayError(sc)
			   		Set return=-2
			   		Quit //退出循环
				} Else {
					Do objLnk.%Close()
				}
			}
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-17
/// Description:  修正病案卷操作记录
/// Table：       DHCWMR.SS.VolStatus
/// Input：       StatusID : 病案卷状态ID
///               OperaCode : 撤销操作代码（U作废、B回置）
///               UpdoReason : 撤销原因
///               UserID : 操作员
/// Return：      返回String
/// w ##class(DHCWMR.SS.VolStatus).ReviseUpdate(StatusID)
ClassMethod ReviseUpdate(aStatusID As %String, aOperaCode As %String, aUpdoReason As %String, aUserID As %String) As %String
{
	New (aStatusID,aOperaCode,aUpdoReason,aUserID)
	Set return=0
	Quit:(aStatusID="")||(aUserID="") return
	Quit:aOperaCode="U" //卷状态作废操作不调用此方法
	
	Set obj=##class(DHCWMR.SS.VolStatus).%OpenId(aStatusID)
	Quit:'$IsObject(obj) return
	
	Set obj.VSUpdoOpera  = aOperaCode
	Set obj.VSUpdoDate   = +$h
	Set obj.VSUpdoTime   = $p($h,",",2)
	Set obj.VSUpdoUser   = aUserID
	Set obj.VSUpdoReason = aUpdoReason
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Quit return
}

/// Creator:      李阳
/// CreateDate:   2014-08-21
/// Description:  删除病案卷状态信息
/// Table:        DHCWMR.SS.VolStatus
/// Input:        Id : DHCWMR.SS.VolStatus.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.VolStatus).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VSStatus</Value>
</Value>
<Value name="3">
<Value>VSUserFrom</Value>
</Value>
<Value name="4">
<Value>VSActDate</Value>
</Value>
<Value name="5">
<Value>VSActTime</Value>
</Value>
<Value name="6">
<Value>VSUserTo</Value>
</Value>
<Value name="7">
<Value>VSBatchNumber</Value>
</Value>
<Value name="8">
<Value>VSUpdoOpera</Value>
</Value>
<Value name="9">
<Value>VSUpdoDate</Value>
</Value>
<Value name="10">
<Value>VSUpdoTime</Value>
</Value>
<Value name="11">
<Value>VSUpdoUser</Value>
</Value>
<Value name="12">
<Value>VSUpdoReason</Value>
</Value>
<Value name="13">
<Value>VSResume</Value>
</Value>
<Value name="14">
<Value>VSCategory</Value>
</Value>
<Value name="15">
<Value>VSRequestDr</Value>
</Value>
<Value name="16">
<Value>VSLnkOperaDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("S")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("S")</IdLocation>
<IndexLocation>^DHCWMR.SS.VolumeI("VS")</IndexLocation>
<StreamLocation>^DHCWMR.SS.VolStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
