/// 文档类型
Class DHCHAI.RME.DocType Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 标签
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 说明
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

Index IndexCode On BTCode As Exact;

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  根据ID取文档类型信息
/// Table：       DHCHAI.RME.DocType
/// Input：       aId : DHCHAI.RME.DocType.ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.DocType).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.DocType
{
	New (aId)
	Quit:'##class(DHCHAI.RME.DocType).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.DocType).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  根据Code取文档类型信息
/// Table：       DHCHAI.RME.DocType
/// Input：       aCode : DHCHAI.RME.DocType.Code
/// Return：      返回obj
/// w ##class(DHCHAI.RME.DocType).GetObjByCode("UserType")
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.RME.DocType
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	Set ID=$o(^DHCHAI.RME.DocTypeI("IndexCode",aCode,0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  更新文档类型信息
/// Table：       DHCHAI.RME.DocType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.DocType).Update("^DocType02^文档类型02","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	// 代码唯一性
	Set tID=$o(^DHCHAI.RME.DocTypeI("IndexCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.RME.DocType).%New()
	}Else{
		Set obj=##class(DHCHAI.RME.DocType).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode  = Code
	Set obj.BTDesc  = Desc
	
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

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  删除文档类型信息
/// Table：       DHCHAI.RME.DocType
/// Input：       aId : DHCHAI.RME.DocType.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.DocType).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.RME.DocType")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.RME.DocType).%DeleteId(aId)
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
<Data name="DocTypeDefaultData">
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
<DataLocation>^DHCHAI.RME.DocTypeD</DataLocation>
<DefaultData>DocTypeDefaultData</DefaultData>
<IdLocation>^DHCHAI.RME.DocTypeD</IdLocation>
<IndexLocation>^DHCHAI.RME.DocTypeI</IndexLocation>
<StreamLocation>^DHCHAI.RME.DocTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
