/// 实体类型
Class DHCHAI.RME.ResultType Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 标签
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 说明
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 实体分类
Property BTCatDr As DHCHAI.RME.ResultCat;

Index IndexCode On BTCode As Exact;

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  根据ID取实体类型信息
/// Table：       DHCHAI.RME.ResultType
/// Input：       aId : DHCHAI.RME.ResultType.ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.ResultType).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.ResultType
{
	New (aId)
	Quit:'##class(DHCHAI.RME.ResultType).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.ResultType).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  根据Code取实体类型信息
/// Table：       DHCHAI.RME.ResultType
/// Input：       aCode : DHCHAI.RME.ResultType.Code
/// Return：      返回obj
/// w ##class(DHCHAI.RME.ResultType).GetObjByCode("UserType")
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.RME.ResultType
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	Set ID=$o(^DHCHAI.RME.ResultTypeI("IndexCode",aCode,0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  更新实体类型信息
/// Table：       DHCHAI.RME.ResultType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ResultType).Update("^Result02^实体类型02","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set CatDr    = $p(aInputStr,aSeparete,4)
	Quit:(Code="")||(Desc="") return
	
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	Set objCat=##class(DHCHAI.RME.ResultCat).GetObjById(CatDr)
	
	// 代码唯一性
	Set tID=$o(^DHCHAI.RME.ResultTypeI("IndexCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.RME.ResultType).%New()
	}Else{
		Set obj=##class(DHCHAI.RME.ResultType).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode  = Code
	Set obj.BTDesc  = Desc
	Set obj.BTCatDr = objCat
	
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
/// Description:  删除实体类型信息
/// Table：       DHCHAI.RME.ResultType
/// Input：       aId : DHCHAI.RME.ResultType.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ResultType).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.RME.ResultType")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.RME.ResultType).%DeleteId(aId)
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
<Data name="ResultTypeDefaultData">
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
<Value>BTCatDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.RME.ResultTypeD</DataLocation>
<DefaultData>ResultTypeDefaultData</DefaultData>
<IdLocation>^DHCHAI.RME.ResultTypeD</IdLocation>
<IndexLocation>^DHCHAI.RME.ResultTypeI</IndexLocation>
<StreamLocation>^DHCHAI.RME.ResultTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
