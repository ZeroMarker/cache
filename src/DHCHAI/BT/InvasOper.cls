/// 名称: DHCHAI.BT.InvasOper
/// 描述: 侵害性操作表
/// 编写者：chenjb
/// 编写日期: 2017-01-10
Class DHCHAI.BT.InvasOper Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(TRUNCATE = 1) [ Required ];

/// 排序码
Property BTIndNo As %String(TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

Index IdxofCode On BTCode As Exact;

Index IdxofDesc On BTDesc As Exact;

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  根据ID取侵害性操作信息
/// Table：       DHCHAI.BT.InvasOper
/// Input：       aId : DHCHAI.BT.InvasOper.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.InvasOper).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.InvasOper
{
	New (aId)
	Quit:'##class(DHCHAI.BT.InvasOper).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.InvasOper).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2017-10-26
/// Description:  根据描述取侵害性操作表信息
/// Table：       DHCHAI.BT.InvasOper
/// Input：       aDesc :DHCHAI.BT.InvasOper.Desc
/// Return：      返回obj
/// w ##class(DHCHAI.BT.InvasOper).GetObjByDesc("呼吸机")
ClassMethod GetObjByDesc(aDesc As %String) As DHCHAI.BT.InfPos
{
	New (aDesc)
	Quit:(aDesc="") ""
	Set ID=$o(^DHCHAI.BT.InvasOperI("IdxofDesc",aDesc,0))
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  更新侵害性操作信息
/// Table：       DHCHAI.BT.InvasOper
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.InvasOper).Update("^P01^PDesc^1^1","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set IndNo    = $p(aInputStr,aSeparete,4)
	Set IsActive = +$p(aInputStr,aSeparete,5)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set tID=$o(^DHCHAI.BT.InvasOperI("IdxofCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.InvasOper).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.InvasOper).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTIndNo    = IndNo
	Set obj.BTIsActive = IsActive
	
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

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  删除侵害性操作信息
/// Table：       DHCHAI.BT.InvasOper
/// Input：       aId : DHCHAI.BT.InvasOper.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.InvasOper).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.BT.InvasOper")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCHAI.BT.InvasOper).%DeleteId(aId)
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
<Data name="InvasOperDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTIndNo</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.InvasOperD</DataLocation>
<DefaultData>InvasOperDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.InvasOperD</IdLocation>
<IndexLocation>^DHCHAI.BT.InvasOperI</IndexLocation>
<StreamLocation>^DHCHAI.BT.InvasOperS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
