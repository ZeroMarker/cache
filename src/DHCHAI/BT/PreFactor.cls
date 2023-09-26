/// 名称: DHCHAI.BT.PreFactor
/// 描述: 易感因素
/// 编写者：chenjb
/// 编写日期: 2017-01-10
Class DHCHAI.BT.PreFactor Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码	BT_Code
Property BTCode As %String(TRUNCATE = 1) [ Required ];

/// 名称	BT_Desc
Property BTDesc As %String(TRUNCATE = 1) [ Required ];

/// 排序码	BT_IndNo
Property BTIndNo As %String(TRUNCATE = 1);

/// 有效标志	BT_IsActive
Property BTIsActive As %Boolean;

/// 新生儿标志	BT_IsNewborn
Property BTIsNewborn As %Integer;

Index IdxofCode On BTCode As Exact;

/// 增加排序码索引 20230410
/// d ##class(DHCHAI.BT.PreFactor).%BuildIndices()
Index IdxofIndNo On BTIndNo As Exact;

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  根据ID取易感因素信息
/// Table：       DHCHAI.BT.PreFactor
/// Input：       aId : DHCHAI.BT.PreFactor.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.PreFactor).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.PreFactor
{
	New (aId)
	Quit:'##class(DHCHAI.BT.PreFactor).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.PreFactor).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  更新易感因素信息
/// Table：       DHCHAI.BT.PreFactor
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.PreFactor).Update("^P01^PDesc^1^1","")
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
	Set IsNewborn = +$p(aInputStr,aSeparete,6)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set tID=$o(^DHCHAI.BT.PreFactorI("IdxofCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.PreFactor).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.PreFactor).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTIndNo    = IndNo
	Set obj.BTIsActive = IsActive
	Set obj.BTIsNewborn = IsNewborn
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
/// Description:  删除易感因素信息
/// Table：       DHCHAI.BT.PreFactor
/// Input：       aId : DHCHAI.BT.PreFactor.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.PreFactor).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.BT.PreFactor")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.BT.PreFactor).%DeleteId(aId)
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
<Data name="PreFactorDefaultData">
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
<Value name="6">
<Value>BTIsNewborn</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.PreFactorD</DataLocation>
<DefaultData>PreFactorDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.PreFactorD</IdLocation>
<IndexLocation>^DHCHAI.BT.PreFactorI</IndexLocation>
<StreamLocation>^DHCHAI.BT.PreFactorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
