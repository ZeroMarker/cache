/// 名称: DHCMA.CPW.SD.PCItemCat
/// 描述: 病种框架 项目分类
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.SD.PCItemCat Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

Index IdxofCode On BTCode;

/// Creator：     xuwenjie
/// CreatDate：   2018-08-29
/// Description:  根据ID取单病种项目分类字典信息
/// Table：       DHCMA.CPW.SD.PCItemCat
/// Input：       aId : DHCMA.CPW.SD.PCItemCat.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.SD.PCItemCat).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.PCItemCat
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.PCItemCat).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.PCItemCat).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     xuwenjie
/// CreatDate：   2018-08-29
/// Description:  根据Code取单病种项目分类字典信息
/// Table：       DHCMA.CPW.SD.PCItemCat
/// Input：       aCode : DHCMA.CPW.SD.PCItemCat.BTCode
/// Return：      返回String
/// w ##class(DHCMA.CPW.SD.PCItemCat).GetObjByCode("111")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^DHCMA.CPW.SD.PCItemCatI("IdxofCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     xuwenjie
/// CreatDate：   2018-08-29
/// Description:  更新单病种项目分类字典信息
/// Table：       DHCMA.CPW.SD.PCItemCat
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.PCItemCat).Update("^Code^Desc")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID         = $p(aInputStr,aSeparete,1)
	Set Code       = $p(aInputStr,aSeparete,2)
	Set Desc       = $p(aInputStr,aSeparete,3)
	Quit:(Code="")||(Desc="") return
	
	Set tID=$o(^DHCMA.CPW.SD.PCItemCatI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2                
	
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.PCItemCat).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.PCItemCat).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	
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
/// CreatDate：   2018-08-29
/// Description:  删除单病种项目分类字典信息
/// Table：       DHCMA.CPW.SD.PCItemCat
/// Input：       aId : DHCMA.CPW.SD.PCItemCat.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.PCItemCat).DeleteById(2)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.PCItemCat).%DeleteId(aId)
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
<Data name="PCItemCatDefaultData">
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
<DataLocation>^DHCMA.CPW.SD.PCItemCatD</DataLocation>
<DefaultData>PCItemCatDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.PCItemCatD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.PCItemCatI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.PCItemCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
