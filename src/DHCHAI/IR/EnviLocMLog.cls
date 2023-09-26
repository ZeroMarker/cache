/// 名称: DHCHAI.IR.EnviHyLocItems
/// 描述: 环境卫生学科室监测项目计划发送消息日志
/// 编写者: zhoubo
/// 编写日期: 2021-06-17
Class DHCHAI.IR.EnviLocMLog Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 申请科室
Property EHLocationDr As DHCHAI.BT.Location [ Required ];

/// 监测项目
Property EHItemDr As DHCHAI.IR.EnviHyItem [ Required ];

/// 单位
Property EHItemUnit As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 消息接收人
Property HISUser As DHCHAI.BT.SysUser;

/// 消息内容
Property MessageInfo As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 消息ID
Property CSMsgDtlID As %String(MAXLEN = 500, TRUNCATE = 1);

/// 更新日期
Property EHActDate As %Date;

/// 更新时间
Property EHActTime As %Time;

/// 申请科室+监测项目 索引
Index IdxLocItemDr On (EHLocationDr, EHItemDr, EHItemUnit);

/// Creator：     zhoubo
/// CreatDate：   2021-06-17
/// Description:  根据ID取
/// Table：       DHCHAI.IR.EnviLocMLog
/// Input：       aId : DHCHAI.IR.EnviLocMLog.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.EnviLocMLog).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.EnviLocMLog
{
	New (aId)
	Quit:'##class(DHCHAI.IR.EnviLocMLog).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.EnviLocMLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2021-06-17
/// Description:  更新
/// Table：       DHCHAI.IR.EnviLocMLog
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.EnviLocMLog).Update("^2^76^2021年06月^3^444^2334","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID           = $p(aInputStr,aSeparete,1)
	Set LocDr	     = $p(aInputStr,aSeparete,2)
	Set EHItemDr     = $p(aInputStr,aSeparete,3)
	Set DateUnitDesc = $p(aInputStr,aSeparete,4)
	Set CCLocUserDr  = $p(aInputStr,aSeparete,5)
	Set MessageInfo  = $p(aInputStr,aSeparete,6)
	Set CSMsgDtlID   = $p(aInputStr,aSeparete,7)
	Quit:(LocDr="")||(EHItemDr="") return
	Set UpdateDate=+$h
	Set UpdateTime=$p($h,",",2)
	Set objLocUser=##class(DHCHAI.BT.SysUser).GetObjById(CCLocUserDr)
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocDr)
	Quit:'$IsObject(objLoc) return
	Set objEHItem=##class(DHCHAI.IR.EnviHyItem).GetObjById(EHItemDr)
	Quit:'$IsObject(objEHItem) return
	Set ID=$o(^DHCHAI.IR.EnviLocMLogI("IdxLocItemDr",LocDr,EHItemDr," "_DateUnitDesc,""))
	If ID="" {
		Set obj=##class(DHCHAI.IR.EnviLocMLog).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.EnviLocMLog).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.EHLocationDr  = objLoc
	Set obj.EHItemDr      = objEHItem
	Set obj.EHItemUnit    = DateUnitDesc
	Set obj.HISUser       = objLocUser
	Set obj.MessageInfo   = MessageInfo
	Set obj.CSMsgDtlID    = CSMsgDtlID
	Set obj.EHActDate     = UpdateDate
	Set obj.EHActTime     = UpdateTime
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2021-06-17
/// Description:  删除
/// Table：       DHCHAI.IR.EnviLocMLog
/// Input：       aId : DHCHAI.IR.EnviLocMLog.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.EnviLocMLog).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.EnviLocMLog).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="EnviLocMLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EHLocationDr</Value>
</Value>
<Value name="3">
<Value>EHItemDr</Value>
</Value>
<Value name="4">
<Value>EHItemUnit</Value>
</Value>
<Value name="5">
<Value>HISUser</Value>
</Value>
<Value name="6">
<Value>MessageInfo</Value>
</Value>
<Value name="7">
<Value>CSMsgDtlID</Value>
</Value>
<Value name="8">
<Value>EHActDate</Value>
</Value>
<Value name="9">
<Value>EHActTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.EnviLocMLogD</DataLocation>
<DefaultData>EnviLocMLogDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.EnviLocMLogD</IdLocation>
<IndexLocation>^DHCHAI.IR.EnviLocMLogI</IndexLocation>
<StreamLocation>^DHCHAI.IR.EnviLocMLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
