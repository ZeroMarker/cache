/// 名称: DHCHAI.BT.SysMenu
/// 描述: 系统功能菜单
/// 编写者：chenjb
/// 编写日期: 2021-11-09
Class DHCHAI.BT.SysMenu Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 功能分类
Property BTTypeDr As DHCHAI.BT.Dictionary;

/// 编码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1);

/// 描述
Property BTDesc As %String(MAXLEN = 200, TRUNCATE = 1);

/// 地址
Property BTUrl As %String(MAXLEN = 500, TRUNCATE = 1);

/// 排序码
Property BTIndNo As %String(TRUNCATE = 1);

/// 备注
Property BTBak As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexBTCode On BTCode As Exact;

/// Creator：     chenjb
/// CreatDate：   2021-09-17
/// Description:  根据ID取维护信息
/// Table：       
/// Input：       aId : 
/// Return：      返回obj
/// w ##class(DHCHAI.BT.SysMenu).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.SysMenu
{
	New (aId)
	Quit:'##class(DHCHAI.BT.SysMenu).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.SysMenu).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2021-09-17
/// Description:  更新维护信息
/// Table：       DHCHAI.BT.SysMenu
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.SysMenu).Update("^809^m01^疑似病例筛查^dhcma.hai.ir.locscreening.csp^1","^")
/// w ##class(DHCHAI.BT.SysMenu).Update("^809^m02^十三项指标^dhcma.hai.sta.thirteenindexlc.csp^2","^")
/// w ##class(DHCHAI.BT.SysMenu).Update("^810^m03^ICU患者日志^dhcma.hai.ir.icu.survery.csp^1","^")
/// w ##class(DHCHAI.BT.SysMenu).Update("^811^m04^科室申请单^dhcma.hai.ir.envihyapply.csp^2","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID         = $p(aInputStr,aSeparete,1)
	Set BTTypeDr = $p(aInputStr,aSeparete,2)
	Set BTCode	   = $p(aInputStr,aSeparete,3)
	Set BTDesc   = $p(aInputStr,aSeparete,4)
	Set BTUrl    = $p(aInputStr,aSeparete,5)
	Set BTBak = $p(aInputStr,aSeparete,6)
	Set BTIndNo =$p(aInputStr,aSeparete,7)
	
	Quit:(BTCode="")||(BTDesc="")||(BTTypeDr="")||(BTUrl="") return	
	Set objType= ##class(DHCHAI.BT.Dictionary).GetObjById(BTTypeDr)
	Quit:'$IsObject(objType) return
	
	Set tID=$o(^DHCHAI.BT.SysMenuI("IndexBTCode",BTCode,0))
	Quit:(tID'="")&(ID'=tID) -2	
	
	Set BTDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(BTDesc) //去掉特殊字符

	If ID="" {
		Set obj=##class(DHCHAI.BT.SysMenu).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.SysMenu).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTTypeDr     = objType 
	Set obj.BTCode    = BTCode
	Set obj.BTDesc    = BTDesc
	Set obj.BTUrl     = BTUrl
	Set obj.BTBak  = BTBak
	Set obj.BTIndNo  = BTIndNo
	
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
/// CreatDate：   2021-09-17
/// Description:  删除维护信息
/// Table：       DHCHAI.BT.SysMenu
/// Input：       aId : DHCHAI.BT.SysMenu.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.SysMenu).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	//Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.BT.SysMenu")
	//Quit:Flg'=1 -777
	Set sc = ##class(DHCHAI.BT.SysMenu).%DeleteId(aId)
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
<Data name="SysMenuDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTypeDr</Value>
</Value>
<Value name="3">
<Value>BTCode</Value>
</Value>
<Value name="4">
<Value>BTDesc</Value>
</Value>
<Value name="5">
<Value>BTUrl</Value>
</Value>
<Value name="6">
<Value>BTBak</Value>
</Value>
<Value name="7">
<Value>BTIndNo</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.SysMenuD</DataLocation>
<DefaultData>SysMenuDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.SysMenuD</IdLocation>
<IndexLocation>^DHCHAI.BT.SysMenuI</IndexLocation>
<StreamLocation>^DHCHAI.BT.SysMenuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
