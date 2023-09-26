/// 主题词分类
Class DHCHAI.RME.ThWordType Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 标签
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 说明
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 主题类型
Property BTThemeTypeDr As DHCHAI.RME.ThemeType [ Required ];

Index IndexCode On BTCode;

Index IndexDesc On BTDesc;

/// Creator：     zhoubo
/// CreatDate：   2017-08-10
/// Description:  根据ID取主题词分类信息
/// Table：       DHCHAI.RME.ThWordType
/// Input：       aId : DHCHAI.RME.ThWordType.ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.ThWordType).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.ThWordType
{
	New (aId)
	Quit:'##class(DHCHAI.RME.ThWordType).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.ThWordType).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-10
/// Description:  根据Code取主题词分类信息
/// Table：       DHCHAI.RME.ThWordType
/// Input：       aCode : DHCHAI.RME.ThWordType.Code
/// Return：      返回obj
/// w ##class(DHCHAI.RME.ThWordType).GetObjByCode("UserType")
ClassMethod GetObjByCode(aCode As %String, aDesc As %String = "") As DHCHAI.RME.ThWordType
{
	New (aCode,aDesc)
	Set return=""
	Quit:(aCode="")&(aDesc="") return
	
	Set:aCode'="" ID=$o(^DHCHAI.RME.ThWordTypeI("IndexCode"," "_$zcvt(aCode,"U"),0))
	Set:aDesc'="" ID=$o(^DHCHAI.RME.ThWordTypeI("IndexDesc"," "_$zcvt(aDesc,"U"),0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-10
/// Description:  更新主题词分类信息
/// Table：       DHCHAI.RME.ThWordType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ThWordType).Update("^ThWordType02^主题词分类02","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set ThemeTypeDr = $p(aInputStr,aSeparete,4)
	Quit:(Code="")||(Desc="")||(ThemeTypeDr="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	Set objThemeType=##class(DHCHAI.RME.ThemeType).GetObjById(ThemeTypeDr)
	Quit:'$IsObject(objThemeType) return
	
	// 代码唯一性
	Set tID=$o(^DHCHAI.RME.ThWordTypeI("IndexCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.RME.ThWordType).%New()
	}Else{
		Set obj=##class(DHCHAI.RME.ThWordType).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode  = Code
	Set obj.BTDesc  = Desc
	SEt obj.BTThemeTypeDr = objThemeType
	
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
/// CreatDate：   2017-08-10
/// Description:  删除主题词分类信息
/// Table：       DHCHAI.RME.ThWordType
/// Input：       aId : DHCHAI.RME.ThWordType.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ThWordType).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.RME.ThWordType")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.RME.ThWordType).%DeleteId(aId)
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
<Data name="ThWordTypeDefaultData">
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
<Value>BTThemeTypeDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.RME.ThWordTypeD</DataLocation>
<DefaultData>ThWordTypeDefaultData</DefaultData>
<IdLocation>^DHCHAI.RME.ThWordTypeD</IdLocation>
<IndexLocation>^DHCHAI.RME.ThWordTypeI</IndexLocation>
<StreamLocation>^DHCHAI.RME.ThWordTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
