/// 名称: DHCMA.Util.BT.SYSTEM
/// 描述: HIS应用系统定义--主要处理不同库并行问题
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.BT.SYSTEM Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 系统代码（例：HIS1,HIS2...）
Property SYSCode As %String(MAXLEN = 50, TRUNCATE = 0);

/// 系统名称
Property SYSDesc As %String(MAXLEN = 100, TRUNCATE = 0);

/// 系统外部码（用于与HIS对接）
Property SYSExCode As %String(MAXLEN = 100, TRUNCATE = 0);

/// 系统说明
Property SYSNote As %String(MAXLEN = 500, TRUNCATE = 0);

Index IdxofCode On SYSCode;

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据ID取应用系统定义信息
/// Table：       DHCMA.Util.BT.SYSTEM
/// Input：       aId : DHCMA.Util.BT.SYSTEM.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.BT.SYSTEM).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.BT.SYSTEM
{
	New (aId)
	Quit:'##class(DHCMA.Util.BT.SYSTEM).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.BT.SYSTEM).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据Code取应用系统定义信息
/// Table：       DHCMA.Util.BT.SYSTEM
/// Input：       aCode : DHCMA.Util.BT.SYSTEM.BTCode
/// Return：      返回String
/// w ##class(DHCMA.Util.BT.SYSTEM).GetObjByCode("")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^DHCMA.Util.BT.SYSTEMI("IdxofCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新应用系统定义信息
/// Table：       DHCMA.Util.BT.SYSTEM
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.SYSTEM).Update("^HIS-Test^测试HIS系统^localhost^模拟测试HIS系统","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID         = $p(aInputStr,aSeparete,1)
	Set Code       = $p(aInputStr,aSeparete,2)
	Set Desc       = $p(aInputStr,aSeparete,3)
	Set ExCode     = $p(aInputStr,aSeparete,4)
	Set Note       = $p(aInputStr,aSeparete,5)
	Quit:(Code="")||(Desc="") return
	
	Set tID=$o(^DHCMA.Util.BT.SYSTEMI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMA.Util.BT.SYSTEM).%New()
	}Else{
		Set obj=##class(DHCMA.Util.BT.SYSTEM).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.SYSCode     = Code
	Set obj.SYSDesc     = Desc
	Set obj.SYSExCode   = ExCode
	Set obj.SYSNote     = Note
	
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

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  删除应用系统定义信息
/// Table：       DHCMA.Util.BT.SYSTEM
/// Input：       aId : DHCMA.Util.BT.SYSTEM.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.SYSTEM).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.Util.BT.SYSTEM")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCMA.Util.BT.SYSTEM).%DeleteId(aId)
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
<Data name="SYSTEMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SYSCode</Value>
</Value>
<Value name="3">
<Value>SYSDesc</Value>
</Value>
<Value name="4">
<Value>SYSExCode</Value>
</Value>
<Value name="5">
<Value>SYSNote</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.BT.SYSTEMD</DataLocation>
<DefaultData>SYSTEMDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.BT.SYSTEMD</IdLocation>
<IndexLocation>^DHCMA.Util.BT.SYSTEMI</IndexLocation>
<StreamLocation>^DHCMA.Util.BT.SYSTEMS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
