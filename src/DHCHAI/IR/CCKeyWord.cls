/// 名称: DHCHAI.IR.CCKeyWord
/// 描述: 关键词表
/// 编写者：zhufei
/// 编写日期: 2017-03-15
Class DHCHAI.IR.CCKeyWord Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 名称
Property CCDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 说明
Property CCNote As %String(MAXLEN = 200, TRUNCATE = 1);

Index IdxofDesc On CCDesc As Exact;

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  根据ID取关键词信息
/// Table：       DHCHAI.IR.CCKeyWord
/// Input：       aId : DHCHAI.IR.CCKeyWord.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCKeyWord).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCKeyWord
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CCKeyWord).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CCKeyWord).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-04-10
/// Description:  根据Desc取关键词信息
/// Table：       DHCHAI.IR.CCKeyWord
/// Input：       aCode : DHCHAI.IR.CCKeyWord.Desc
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCKeyWord).GetObjByDesc("UserType")
ClassMethod GetObjByDesc(aDesc As %String) As DHCHAI.IR.CCKeyWord
{
	New (aDesc)
	Set ID=$o(^DHCHAI.IR.CCKeyWordI("IdxofDesc",aDesc,0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  更新关键词信息
/// Table：       DHCHAI.IR.CCKeyWord
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCKeyWord).Update("^PDesc^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Desc     = $p(aInputStr,aSeparete,2)
	Set Note     = $p(aInputStr,aSeparete,3)
	Quit:(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	Set tID=$o(^DHCHAI.IR.CCKeyWordI("IdxofDesc",Desc,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCKeyWord).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCKeyWord).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CCDesc     = Desc
	Set obj.CCNote     = Note
	
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

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  删除关键词信息
/// Table：       DHCHAI.IR.CCKeyWord
/// Input：       aId : DHCHAI.IR.CCKeyWord.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCKeyWord).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.IR.CCKeyWord")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.IR.CCKeyWord).%DeleteId(aId)
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
<Data name="DicTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CCDesc</Value>
</Value>
<Value name="3">
<Value>CCNote</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCKeyWordD</DataLocation>
<DefaultData>DicTypeDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCKeyWordD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCKeyWordI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCKeyWordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
