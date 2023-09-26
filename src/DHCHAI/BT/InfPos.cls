/// 名称: DHCHAI.BT.InfPos
/// 描述: 感染诊断（部位）表
/// 编写者：chenjb
/// 编写日期: 2017-01-10
Class DHCHAI.BT.InfPos Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 感染诊断分类
Relationship ChildExt As DHCHAI.BT.InfPosExt [ Cardinality = children, Inverse = Parref ];

/// 代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 诊断标志
Property BTDiagFlag As %Boolean;

/// 排序码(用于体现层级关系)
Property BTGCode As %String(TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

Index IdxofCode On BTCode As Exact;

Index IdxofDesc On BTDesc As Exact;

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  根据ID取感染诊断（部位）信息
/// Table：       DHCHAI.BT.InfPos
/// Input：       aId : DHCHAI.BT.InfPos.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.InfPos).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.InfPos
{
	New (aId)
	Quit:'##class(DHCHAI.BT.InfPos).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.InfPos).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-04-08
/// Description:  根据代码取感染诊断信息
/// Table：       DHCHAI.BT.InfPos
/// Input：       aCode : DHCHAI.BT.InfPos.BTCode
/// Return：      返回obj
/// w ##class(DHCHAI.BT.InfPos).GetObjByCode("01")
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.BT.InfPos
{
	New (aCode)
	Quit:(aCode="") ""
	Set ID=$o(^DHCHAI.BT.InfPosI("IdxofCode",aCode,0))
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2017-10-26
/// Description:  根据描述取感染诊断信息
/// Table：       DHCHAI.BT.InfPos
/// Input：       aDesc : DHCHAI.BT.InfPos.Desc
/// Return：      返回obj
/// w ##class(DHCHAI.BT.InfPos).GetObjByDesc("上呼吸道感染")
ClassMethod GetObjByDesc(aDesc As %String) As DHCHAI.BT.InfPos
{
	New (aDesc)
	Quit:(aDesc="") ""
	Set ID=$o(^DHCHAI.BT.InfPosI("IdxofDesc",aDesc,0))
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2018-01-11
/// Description:  根据描述取感染诊断信息ID
/// Table：       DHCHAI.BT.InfPos
/// Input：       aDesc : DHCHAI.BT.InfPos.Desc
/// Return：      返回obj
/// w ##class(DHCHAI.BT.InfPos).GetIDByDesc("新生儿感染")
ClassMethod GetIDByDesc(aDesc As %String) As %String
{
	New (aDesc)
	Quit:(aDesc="") ""
	Set ID=$o(^DHCHAI.BT.InfPosI("IdxofDesc",aDesc,0))
	Quit ID
}

/// Creator：     pylian
/// CreatDate：   2021-10-25
/// Description:  根据ID取感染诊断描述
/// Table：       DHCHAI.BT.InfPos
/// Input：       aDesc : DHCHAI.BT.InfPos.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.InfPos).GetDescByID("4")
ClassMethod GetDescByID(aID As %String) As %String
{
	New (aID)
	Quit:(aID="") ""
	Set InfPos=$g(^DHCHAI.BT.InfPosD(aID))
	Quit:(InfPos="") ""
	Set Desc=$lg(InfPos,3)
	
	Quit Desc
}

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  更新感染诊断（部位）信息
/// Table：       DHCHAI.BT.InfPos
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.InfPos).Update("^P01^PDesc^1^1","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set DiagFlag = $p(aInputStr,aSeparete,4)
	Set GCode    = $p(aInputStr,aSeparete,5)
	Set IsActive = +$p(aInputStr,aSeparete,6)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set tID=$o(^DHCHAI.BT.InfPosI("IdxofCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.InfPos).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.InfPos).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTDiagFlag = DiagFlag
	Set obj.BTGCode    = GCode
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
/// Description:  删除感染诊断（部位）信息
/// Table：       DHCHAI.BT.InfPos
/// Input：       aId : DHCHAI.BT.InfPos.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.InfPos).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.BT.InfPos")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCHAI.BT.InfPos).%DeleteId(aId)
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
<Data name="InfPosDefaultData">
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
<Value>BTDiagFlag</Value>
</Value>
<Value name="5">
<Value>BTGCode</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.InfPosD</DataLocation>
<DefaultData>InfPosDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.InfPosD</IdLocation>
<IndexLocation>^DHCHAI.BT.InfPosI</IndexLocation>
<StreamLocation>^DHCHAI.BT.InfPosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
