/// 名称: DHCMA.Util.BT.MdlDef
/// 描述: 系统模块定义
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.BT.MdlDef Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 角色
Relationship ChildRole As DHCMA.Util.BT.MdlRole [ Cardinality = children, Inverse = Parref ];

/// 模块代码（规范命名：前边带产品代码，例：HIS性别字典:HISCTSex，传染病种字典：EPDEntity）
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 模块名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 产品线
Property BTProductDr As DHCMA.Util.BT.Product;

Index IdxofCode On BTCode [ Unique ];

Index IdxofProductDr On BTProductDr;

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据ID取系统模块定义表信息
/// Table：       DHCMA.Util.BT.MdlDef
/// Input：       aId : DHCMA.Util.BT.MdlDef.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.BT.MdlDef).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.BT.MdlDef
{
	New (aId)
	Quit:'##class(DHCMA.Util.BT.MdlDef).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.BT.MdlDef).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据Code取系统模块定义表信息
/// Table：       DHCMA.Util.BT.MdlDef
/// Input：       aCode : DHCMA.Util.BT.MdlDef.Code
/// Return：      返回obj
/// w ##class(DHCMA.Util.BT.MdlDef).GetObjByCode("HISCTSex")
ClassMethod GetObjByCode(aCode As %String) As DHCMA.Util.BT.MdlDef
{
	New (aCode)
	Quit:aCode="" ""
	Set ID=$o(^DHCMA.Util.BT.MdlDefI("IdxofCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新系统模块定义表信息
/// Table：       DHCMA.Util.BT.MdlDef
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.MdlDef).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set ProductDr= $p(aInputStr,aSeparete,4)
	Quit:(Code="")||(Desc="") return
	
	Set objProduct=##class(DHCMA.Util.BT.Product).GetObjById(ProductDr)
	Quit:'$IsObject(objProduct) return
	//字典类型代码必须与产品代码匹配
	Set ProCode=objProduct.ProCode
	Quit:$e(Code,1,$l(ProCode))'=ProCode return
	
	Set tID=$o(^DHCMA.Util.BT.MdlDefI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMA.Util.BT.MdlDef).%New()
	}Else{
		Set obj=##class(DHCMA.Util.BT.MdlDef).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTProductDr= objProduct
	
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
/// CreatDate：   2018-07-31
/// Description:  删除系统模块定义表信息
/// Table：       DHCMA.Util.BT.MdlDef
/// Input：       aId : DHCMA.Util.BT.MdlDef.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.MdlDef).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.Util.BT.MdlDef")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCMA.Util.BT.MdlDef).%DeleteId(aId)
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
<Data name="MdlDefDefaultData">
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
<Value>BTProductDr</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.BT.MdlDefD</DataLocation>
<DefaultData>MdlDefDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.BT.MdlDefD</IdLocation>
<IndexLocation>^DHCMA.Util.BT.MdlDefI</IndexLocation>
<StreamLocation>^DHCMA.Util.BT.MdlDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
