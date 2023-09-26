/// 名称: DHCHAI.DP.OEAntiCat
/// 描述: 医嘱-抗菌药物分类
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.OEAntiCat Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 代码索引
Index IndexCode On BTCode As Exact;

/// 名称索引
Index IndexDesc On BTDesc As Exact;

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取抗菌药物分类
/// Table：       DHCHAI.DP.OEAntiCat
/// Input：       ID:    DHCHAI.DP.OEAntiCat.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEAntiCat).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.OEAntiCat
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.OEAntiCat).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.OEAntiCat).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-28
/// Description:  根据代码 描述 取抗菌药物分类
/// Table：       DHCHAI.DP.OEAntiCat
/// Input：       aCode:  代码
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEAntiCat).GetObjByCodeDesc("","GPR")
ClassMethod GetObjByCodeDesc(aCode As %String, aDesc As %String) As DHCHAI.DP.OEAntiCat
{
	New (aCode,aDesc)
	Set return=""
	Quit:((aCode="")&&(aDesc=""))||((aCode'="")&&(aDesc'="")) return
	
	Set id=""
	Set:aCode'="" id = $o(^DHCHAI.DP.OEAntiCatI("IndexCode",aCode,0))
	Set:aDesc'="" id = $o(^DHCHAI.DP.OEAntiCatI("IndexDesc",aDesc,0))
	Quit:id="" return
	
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新抗菌药物分类
/// Table：       DHCHAI.DP.OEAntiCat
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OEAntiCat).Update("^SHS^四环素")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set Code		= $p(InStr,aSeparete,2)
	Set Desc		= $p(InStr,aSeparete,3)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	//分类代码唯一性
	Set tID =$o(^DHCHAI.DP.OEAntiCatI("IndexCode",Code,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.OEAntiCat).%New()
	}else{
		Set obj=##class(DHCHAI.DP.OEAntiCat).%OpenId(ID)
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

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除抗菌药物分类
/// Table：       DHCHAI.DP.OEAntiCat
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.OEAntiCat")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.OEAntiCat).%DeleteId(+Id)
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
<DataLocation>^DHCHAI.DP.OEAntiCatD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.OEAntiCatD</IdLocation>
<IndexLocation>^DHCHAI.DP.OEAntiCatI</IndexLocation>
<StreamLocation>^DHCHAI.DP.OEAntiCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
