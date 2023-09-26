/// 名称: DHCHAI.DP.LabBactType
/// 描述: 细菌类型
/// 编写者：zhufei
/// 编写日期: 2017-05-18
Class DHCHAI.DP.LabBactType Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 代码索引
Index IndexCode On BTCode As Exact;

/// 名称索引
Index IndexDesc On BTDesc As Exact;

/// Creator：     zhufei
/// CreatDate：   2017-05-18
/// Description:  根据ID取细菌类型
/// Table：       DHCHAI.DP.LabBactType
/// Input：       ID:    DHCHAI.DP.LabBactType.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabBactType).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabBactType
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabBactType).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabBactType).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据代码 描述 取细菌分类
/// Table：       DHCHAI.DP.LabBactType
/// Input：       aCode:   细菌代码
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabBactType).GetObjByCodeDesc("")
ClassMethod GetObjByCodeDesc(aCode As %String, aDesc As %String) As DHCHAI.DP.LabBactType
{
	New (aCode,aDesc)
	Set return=""
	Quit:((aCode="")&&(aDesc=""))||((aCode'="")&&(aDesc'="")) return
	
	Set id=""
	Set:aCode'="" id = $o(^DHCHAI.DP.LabBactTypeI("IndexCode",aCode,0))
	Set:aDesc'="" id = $o(^DHCHAI.DP.LabBactTypeI("IndexDesc",aDesc,0))
	Quit:id="" return
	
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-18
/// Description:  更新细菌类型
/// Table：       DHCHAI.DP.LabBactType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabBactType).Update("1^shs^四环素")
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
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	//分类代码唯一性
	Set tID =$o(^DHCHAI.DP.LabBactTypeI("IndexCode",Code,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabBactType).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabBactType).%OpenId(ID)
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

/// Creator：     zhufei
/// CreatDate：   2017-05-18
/// Description:  删除细菌类型
/// Table：       DHCHAI.DP.LabBactType
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.LabBactType")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.LabBactType).%DeleteId(+Id)
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
<DataLocation>^DHCHAI.DP.LabBactTypeD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabBactTypeD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabBactTypeI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabBactTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
