/// 名称: DHCMA.CPW.SD.PCEntityItem
/// 描述: 按病种付费病种框架
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.SD.PCEntityItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.SD.PCEntity [ Cardinality = parent, Inverse = ChildItem ];

/// 医疗服务价格项目规范
Relationship ChildPrice As DHCMA.CPW.SD.PCEntityPrice [ Cardinality = children, Inverse = Parref ];

/// 项目名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目分类
Property BTCatDr As DHCMA.CPW.SD.PCItemCat;

/// 项目阶段
Property BTEpisDr As DHCMA.CPW.SD.PCItemEpis;

/// 有效标志
Property BTIsActive As %Boolean;

/// 排序码
Property BTIndNo As %Integer;

Index IdxofITMDesc On BTDesc;

/// Creator：     xuwenjie
/// CreatDate：   2018-08-30
/// Description:  根据ID取付费病种项目信息
/// Table：       DHCMA.CPW.SD.PCEntityItem
/// Input：       aId : DHCMA.CPW.SD.PCEntityItem.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.SD.PCEntityItem).GetObjById("30||1")
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.PCEntityItem
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.PCEntityItem).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.PCEntityItem).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     xuwenjie
/// CreatDate：   2018-08-30
/// Description:  更新付费病种项目信息
/// Table：       DHCMA.CPW.SD.PCEntityItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.PCEntityItem).Update("33^2^D1esc^^C4^0^5")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref		         = $p(aInputStr,aSeparete,1)
	Set ChildSub             = $p(aInputStr,aSeparete,2)
	Set Desc                 = $p(aInputStr,aSeparete,3)
	Set CatDr                = $p(aInputStr,aSeparete,4)
	Set EpisDr               = $p(aInputStr,aSeparete,5)
	Set IsActive             = +$p(aInputStr,aSeparete,6)
	Set IndNo                = $p(aInputStr,aSeparete,7)
	Quit:(Parref="")||(Desc="") return
	//Set tID=$o(^DHCMA.CPW.SD.PCEntityItemI("IdxofCode"," "_$zcvt(Code,"U"),0))
	//Quit:(tID'="")&(ID'=tID) -2  
	Set objPCEntity =##class(DHCMA.CPW.SD.PCEntity).GetObjById(Parref)
	Quit:('$Isobject(objPCEntity)) -1
	If ChildSub="" {
		Set obj=##class(DHCMA.CPW.SD.PCEntityItem).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.CPW.SD.PCEntityItem).%OpenId(ID)
	}
	
	Quit:'$IsObject(obj) return
	Set obj.Parref           = objPCEntity   //对象
	Set obj.BTDesc           = Desc 
	Set obj.BTIsActive       = IsActive
	Set obj.BTIndNo          = IndNo
	Set obj.BTCatDr          = ##class(DHCMA.CPW.SD.PCItemCat).GetObjByCode(CatDr)
	Set obj.BTEpisDr         = ##class(DHCMA.CPW.SD.PCItemEpis).GetObjByCode(EpisDr)
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

/// Creator：     xuwenjie
/// CreatDate：   2018-08-30
/// Description:  删除付费病种框架信息
/// Table：       DHCMA.CPW.SD.PCEntityItem
/// Input：       aId : DHCMA.CPW.SD.PCEntityItem.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.PCEntityItem).DeleteById("30||4")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.PCEntityItem).%DeleteId(aId)
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
<Data name="PCEntityItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTDesc</Value>
</Value>
<Value name="3">
<Value>BTCatDr</Value>
</Value>
<Value name="4">
<Value>BTEpisDr</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
<Value name="6">
<Value>BTIndNo</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ITM")</DataLocation>
<DefaultData>PCEntityItemDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ITM")</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.PCEntityI("ITM")</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.PCEntityItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
