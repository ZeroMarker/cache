/// 名称: DHCHAI.DP.LabBactGenus
/// 描述: 细菌菌属字典
/// 编写者：pylian
/// 编写日期: 2020-07-28
Class DHCHAI.DP.LabBactGenus Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 代码索引
Index IndexCode On BTCode As Exact;

/// 名称索引
Index IndexDesc On BTDesc As Exact;

/// Creator：     pylian
/// CreatDate：   2020-07-28
/// Description:  根据ID取细菌菌属
/// Table：       DHCHAI.DP.LabBactGenus
/// Input：       ID:    DHCHAI.DP.LabBactGenus.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabBactGenus).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabBactGenus
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabBactGenus).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabBactGenus).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-07-28
/// Description:  根据代码描述取细菌菌属
/// Table：       DHCHAI.DP.LabBactGenus
/// Input：       aCode:   细菌代码
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabBactGenus).GetObjByCodeDesc("")
ClassMethod GetObjByCodeDesc(aCode As %String, aDesc As %String) As DHCHAI.DP.LabBactGenus
{
	New (aCode,aDesc)
	Set return=""
	Quit:((aCode="")&&(aDesc=""))||((aCode'="")&&(aDesc'="")) return
	
	Set id=""
	Set:aCode'="" id = $o(^CT.MA.HAI.DP.LabBactGenusI("IndexCode",aCode,0))
	Set:aDesc'="" id = $o(^CT.MA.HAI.DP.LabBactGenusI("IndexDesc",aDesc,0))
	Quit:id="" return
	
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-07-28
/// Description:  更新细菌菌属
/// Table：       DHCHAI.DP.LabBactGenus
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabBactGenus).Update("1^shs^四环素")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(aInputStr,aSeparete,1)
	Set Code		= $p(aInputStr,aSeparete,2)
	Set Desc		= $p(aInputStr,aSeparete,3)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	//代码唯一性
	Set tID =$o(^CT.MA.HAI.DP.LabBactGenusI("IndexCode",Code,0)) 
	Quit:(tID'="")&(ID'=tID) -2
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabBactGenus).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabBactGenus).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode		= Code
	Set obj.BTDesc		= Desc
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

/// Creator：     pylian
/// CreatDate：   2020-07-28
/// Description:  删除细菌菌属
/// Table：       DHCHAI.DP.LabBactGenus
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(aId)
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.LabBactGenus")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.LabBactGenus).%DeleteId(+aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
</Data>
<DataLocation>^CT.MA.HAI.DP.LabBactGenusD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.MA.HAI.DP.LabBactGenusD</IdLocation>
<IndexLocation>^CT.MA.HAI.DP.LabBactGenusI</IndexLocation>
<StreamLocation>^CT.MA.CHAI.DP.LabBactGenusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
