/// 名称: DHCHAI.DP.EmrDocType
/// 描述: 文档类型
/// 编写者：zhufei
/// 编写日期: 2017-08-08
Class DHCHAI.DP.EmrDocType Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
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
/// CreatDate：   2017-08-08
/// Description:  根据ID取文档类型
/// Table：       DHCHAI.DP.EmrDocType
/// Input：       ID:    DHCHAI.DP.EmrDocType.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.EmrDocType).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.EmrDocType
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.EmrDocType).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.EmrDocType).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-08
/// Description:  根据代码、描述取文档类型
/// Table：       DHCHAI.DP.EmrDocType
/// Input：       aCode:   代码
/// Return：      返回Object
/// w ##class(DHCHAI.DP.EmrDocType).GetObjByCodeDesc("")
ClassMethod GetObjByCodeDesc(aCode As %String, aDesc As %String) As DHCHAI.DP.EmrDocType
{
	New (aCode,aDesc)
	Set return=""
	Quit:((aCode="")&&(aDesc=""))||((aCode'="")&&(aDesc'="")) return
	
	Set id=""
	Set:aCode'="" id = $o(^DHCHAI.DP.EmrDocTypeI("IndexCode",aCode,0))
	Set:aDesc'="" id = $o(^DHCHAI.DP.EmrDocTypeI("IndexDesc",aDesc,0))
	Quit:id="" return
	
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-08
/// Description:  更新文档类型
/// Table：       DHCHAI.DP.EmrDocType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.EmrDocType).Update("^Code2^日常病程")
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
	
	//分类代码唯一性
	Set tID =$o(^DHCHAI.DP.EmrDocTypeI("IndexDesc",Desc,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.EmrDocType).%New()
	}else{
		Set obj=##class(DHCHAI.DP.EmrDocType).%OpenId(ID)
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
/// Description:  删除文档类型
/// Table：       DHCHAI.DP.EmrDocType
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.EmrDocType).%DeleteId(+Id)
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
<DataLocation>^DHCHAI.DP.EmrDocTypeD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.EmrDocTypeD</IdLocation>
<IndexLocation>^DHCHAI.DP.EmrDocTypeI</IndexLocation>
<StreamLocation>^DHCHAI.DP.EmrDocTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
