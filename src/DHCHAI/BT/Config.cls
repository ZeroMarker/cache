/// 名称: DHCHAI.BT.Config
/// 描述: 系统参数表
/// 编写者：chenjb
/// 编写日期: 2017-01-10
Class DHCHAI.BT.Config Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 描述
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 配置值
Property BTValue As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 医院
Property BTHospDr As DHCHAI.BT.Hospital;

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 模块
Property BTMod As %String [ Required ];

/// 备注
Property BTResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 排序码
Property BTIndNo As %String(TRUNCATE = 1);

/// 代码索引
Index IdxofCode On BTCode As Exact;

/// 医院 + 代码索引
Index IdxofHospDrCode On (BTHospDr, BTCode As Exact);

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  根据ID取参数配置信息
/// Table：       DHCHAI.BT.Config
/// Input：       aId : DHCHAI.BT.Config.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.Config).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.Config
{
	New (aId)
	Quit:'##class(DHCHAI.BT.Config).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.Config).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2022-06-08
/// Description:  根据Code取参数配置信息
/// Table：       DHCHAI.BT.Config
/// Input：       aCode : DHCHAI.BT.Config.BTCode
///               aHospDr : DHCHAI.BT.Hospital.ID
/// Return：      返回String
/// w ##class(DHCHAI.BT.Config).GetValByCode("")
ClassMethod GetValByCode(aCode As %String, aHospDr As %String = "") As %String
{
	New (aCode,aHospDr)
	Set return=""
	Quit:aCode="" return
	
	If aHospDr'="" {
		Set ID=$o(^DHCHAI.BT.ConfigI("IdxofHospDrCode",aHospDr,aCode,0))
		Quit:ID="" return
		Set ConfigData=$g(^DHCHAI.BT.ConfigD(ID))
		If (ConfigData'=""){
			Set IsActive=$li(ConfigData,6)
			Set:IsActive=1 return=$li(ConfigData,4)
		}
	}
	Quit:return'="" return
	
	Set ID=$o(^DHCHAI.BT.ConfigI("IdxofCode",aCode,0))
	Quit:ID="" return
	Set ConfigData=$g(^DHCHAI.BT.ConfigD(ID))
	If (ConfigData'=""){
		Set IsActive=$li(ConfigData,6)
		Set:IsActive=1 return=$li(ConfigData,4)
	}
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  更新参数配置信息
/// Table：       DHCHAI.BT.Config
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.Config).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set Value    = $p(aInputStr,aSeparete,4)
	Set HospDr   = $p(aInputStr,aSeparete,5)
	Set IsActive = +$p(aInputStr,aSeparete,6)
	Set Mod 	 = $p(aInputStr,aSeparete,7)
	Set Resume 	 = $p(aInputStr,aSeparete,8)
	Set IndNo 	 = $p(aInputStr,aSeparete,9)
	
	Quit:(Code="")||(Desc="")||(Mod="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	Set objHosp=""
	If HospDr'="" {
		Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(HospDr)
		Quit:'$IsObject(objHosp) return
	}
	
	
	If HospDr'="" {
		Set tID=$o(^DHCHAI.BT.ConfigI("IdxofHospDrCode",HospDr,Code,0))
	} Else {
		Set tID=$o(^DHCHAI.BT.ConfigI("IdxofCode",Code,0))
	}
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.Config).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.Config).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTValue    = Value
	Set obj.BTHospDr   = objHosp
	Set obj.BTIsActive = IsActive
	Set obj.BTMod 	   = Mod
	Set obj.BTResume   = Resume
	Set obj.BTIndNo    = IndNo
	
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
/// Description:  删除参数配置信息
/// Table：       DHCHAI.BT.Config
/// Input：       aId : DHCHAI.BT.Config.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.Config).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.BT.Config")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCHAI.BT.Config).%DeleteId(aId)
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
<Data name="ConfigDefaultData">
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
<Value>BTValue</Value>
</Value>
<Value name="5">
<Value>BTHospDr</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
<Value name="7">
<Value>BTMod</Value>
</Value>
<Value name="8">
<Value>BTResume</Value>
</Value>
<Value name="9">
<Value>BTIndNo</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.ConfigD</DataLocation>
<DefaultData>ConfigDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.ConfigD</IdLocation>
<IndexLocation>^DHCHAI.BT.ConfigI</IndexLocation>
<StreamLocation>^DHCHAI.BT.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
