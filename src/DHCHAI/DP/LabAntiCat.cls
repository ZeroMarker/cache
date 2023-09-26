/// 名称: DHCHAI.DP.LabAntiCat
/// 描述: 抗生素分类
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.LabAntiCat Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 分类代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 分类名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 分类代码索引
Index IndexCode On BTCode As Exact;

/// 分类名称索引
Index IndexDesc On BTDesc As Exact;

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取抗生素分类
/// Table：       DHCHAI.DP.LabAntiCat
/// Input：       ID:    DHCHAI.DP.LabAntiCat.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabAntiCat).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabAntiCat
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabAntiCat).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabAntiCat).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据代码 描述 取抗生素分类
/// Table：       DHCHAI.DP.LabAntiCat
/// Input：       aCode:   抗生素代码
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabAntiCat).GetObjByCodeDesc("")
ClassMethod GetObjByCodeDesc(aCode As %String, aDesc As %String) As DHCHAI.DP.LabAntiCat
{
	New (aCode,aDesc)
	Set return=""
	Quit:((aCode="")&&(aDesc=""))||((aCode'="")&&(aDesc'="")) return
	
	Set id=""
	Set:aCode'="" id = $o(^DHCHAI.DP.LabAntiCatI("IndexCode",aCode,0))
	Set:aDesc'="" id = $o(^DHCHAI.DP.LabAntiCatI("IndexDesc",aDesc,0))
	Quit:id="" return
	
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新抗生素分类
/// Table：       DHCHAI.DP.LabAntiCat
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabAntiCat).Update("^SHS^四环素类")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set ACCode		= $p(InStr,aSeparete,2)
	Set ACDesc		= $p(InStr,aSeparete,3)
	Quit:(ACCode="")||(ACDesc="") return
	Set ACDesc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(ACDesc)  //去掉特殊字符
	
	//分类代码唯一性
	Set tID =$o(^DHCHAI.DP.LabAntiCatI("IndexCode",ACCode,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabAntiCat).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabAntiCat).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode	= ACCode
	Set obj.BTDesc	= ACDesc
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
/// Description:  删除抗生素分类
/// Table：       DHCHAI.DP.LabAntiCat
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.LabAntiCat")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.LabAntiCat).%DeleteId(+Id)
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
<DataLocation>^DHCHAI.DP.LabAntiCatD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabAntiCatD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabAntiCatI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabAntiCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
