/// 名称: DHCHAI.IR.INFLastAdm
/// 描述: 医院感染 历史就诊
/// 编写者：zhufei
/// 编写日期: 2020-04-07
Class DHCHAI.IR.INFLastAdm Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 历史记录
Property IRLastAdmDr As DHCHAI.DP.PAAdm;

Index IndexLastAdm On IRLastAdmDr;

/// Creator：     zhoubo
/// CreatDate：   2020-04-14
/// Description:  根据ID取信息
/// Table：       DHCHAI.IR.INFLastAdm
/// Input：       Id : DHCHAI.IR.INFLastAdm.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.INFLastAdm).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.INFLastAdm
{
	New (aId)
	Quit:'##class(DHCHAI.IR.INFLastAdm).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.INFLastAdm).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2020-04-14
/// Description:  更新信息
/// Table：       DHCHAI.IR.INFLastAdm
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.INFLastAdm).Update("29","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set LastAdmDr = $p(aInputStr,aSeparete,1)
	Set ID=$o(^DHCHAI.IR.INFLastAdmI("IndexLastAdm",LastAdmDr,""))
	If ID="" {
		Set obj=##class(DHCHAI.IR.INFLastAdm).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.INFLastAdm).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set objPaadm=##class(DHCHAI.DP.PAAdm).GetObjById(LastAdmDr)
	Set obj.IRLastAdmDr = objPaadm

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
/// CreatDate：   2020-04-14
/// Description:  删除医院感染信息
/// Table：       DHCHAI.IR.INFLastAdm
/// Input：       Id : DHCHAI.IR.INFLastAdm.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.INFLastAdm).DeleteById(1)
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCHAI.IR.INFLastAdm).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="INFLastAdmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IRLastAdmDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.INFLastAdmD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.INFLastAdmD</IdLocation>
<IndexLocation>^DHCHAI.IR.INFLastAdmI</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFLastAdmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
