/// 名称: DHCHAI.DP.MRICDDx
/// 描述: 诊断
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.MRICDDx Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 诊断代码
Property BTCode As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 诊断名称
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 诊断代码索引
Index IndexCode On BTCode As Exact;

/// 诊断名称索引
Index IndexDesc On BTDesc As Exact;

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取诊断
/// Table：       DHCHAI.DP.MRICDDx
/// Input：       ID:    DHCHAI.DP.MRICDDx.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.MRICDDx).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.MRICDDx
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.MRICDDx).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.MRICDDx).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  根据代码、名称取取诊断
/// Table：       DHCHAI.DP.MRICDDx
/// Input：       aCode:    诊断代码
/// 			  aDesc:    诊断名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.MRICDDx).GetObjByCodeDesc("","")
ClassMethod GetObjByCodeDesc(aCode As %String, aDesc As %String) As DHCHAI.DP.MRICDDx
{
	New (aCode,aDesc)
	Set return=""
	Quit:((aCode="")&&(aDesc=""))||((aCode'="")&&(aDesc'="")) return
	Set:(aDesc'="")&($l(aDesc)>100) aDesc =$e(aDesc,1,100)   //update 20220711 字符超长截取
	
	Set id=""
	Set:aCode'="" id = $o(^DHCHAI.DP.MRICDDxI("IndexCode",aCode,0))
	Set:aDesc'="" id = $o(^DHCHAI.DP.MRICDDxI("IndexDesc",aDesc,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新诊断
/// Table：       DHCHAI.DP.MRICDDx
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.MRICDDx).Update("^代码^描述^1")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set Code		= $p(InStr,aSeparete,2)
	Set Desc		= $p(InStr,aSeparete,3)
	Set IsActive	= +$p(InStr,aSeparete,4)
	Quit:(Code="")||(Desc="")||(IsActive="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	//代码唯一性
	Set tID =$o(^DHCHAI.DP.MRICDDxI("IndexCode",Code,0)) 
	Quit:(tID'="")&(ID'=tID) -100

	Set:(Desc'="")&($l(Desc)>100) Desc =$e(Desc,1,100)   //update 20220711 字符超长截取
	//名称唯一性
	Set tID =$o(^DHCHAI.DP.MRICDDxI("IndexDesc",Desc,0)) 
	Quit:(tID'="")&(ID'=tID) -100
		
	if ID="" {
		Set obj=##class(DHCHAI.DP.MRICDDx).%New()
	}else{
		Set obj=##class(DHCHAI.DP.MRICDDx).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode		= Code
	Set obj.BTDesc		= Desc
	Set obj.BTIsActive	= IsActive
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

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除诊断
/// Table：       DHCHAI.DP.MRICDDx
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.MRICDDx")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.MRICDDx).%DeleteId(+Id)
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
<Value name="4">
<Value>BTIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.MRICDDxD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.MRICDDxD</IdLocation>
<IndexLocation>^DHCHAI.DP.MRICDDxI</IndexLocation>
<StreamLocation>^DHCHAI.DP.MRICDDxS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
