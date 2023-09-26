/// 名称: DHCMA.Util.BT.DicType
/// 描述: 字典分类表
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.BT.DicType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码（规范命名：前边带产品代码，例：HIS性别字典:HISCTSex，传染病种字典：EPDEntity）
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 产品线
Property BTProductDr As DHCMA.Util.BT.Product;

Index IdxofCode On BTCode [ Unique ];

Index IdxofProductDr On BTProductDr;

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据ID取字典分类信息
/// Table：       DHCMA.Util.BT.DicType
/// Input：       aId : DHCMA.Util.BT.DicType.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.BT.DicType).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.BT.DicType
{
	New (aId)
	Quit:'##class(DHCMA.Util.BT.DicType).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.BT.DicType).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据Code取字典分类信息
/// Table：       DHCMA.Util.BT.DicType
/// Input：       aCode : DHCMA.Util.BT.DicType.Code
/// Return：      返回obj
/// w ##class(DHCMA.Util.BT.DicType).GetObjByCode("HISCTSex")
ClassMethod GetObjByCode(aCode As %String) As DHCMA.Util.BT.DicType
{
	New (aCode)
	Quit:aCode="" ""
	Set ID=$o(^DHCMA.Util.BT.DicTypeI("IdxofCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新字典分类信息
/// Table：       DHCMA.Util.BT.DicType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.DicType).Update("","")
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
	///兼容导入的时候为产品代码的字典类型
	Set:'$IsObject(objProduct) objProduct=##class(DHCMA.Util.BT.Product).GetObjByCode(ProductDr)
	Quit:'$IsObject(objProduct) return
	//字典类型代码必须与产品代码匹配
	Set ProCode=objProduct.ProCode
	;Quit:$e(Code,1,$l(ProCode))'=ProCode return
	
	Set tID=$o(^DHCMA.Util.BT.DicTypeI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMA.Util.BT.DicType).%New()
	}Else{
		Set obj=##class(DHCMA.Util.BT.DicType).%OpenId(ID)
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
/// Description:  删除字典分类信息
/// Table：       DHCMA.Util.BT.DicType
/// Input：       aId : DHCMA.Util.BT.DicType.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.DicType).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.Util.BT.DicType")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCMA.Util.BT.DicType).%DeleteId(aId)
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
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTProductDr</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.BT.DicTypeD</DataLocation>
<DefaultData>DicTypeDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.BT.DicTypeD</IdLocation>
<IndexLocation>^DHCMA.Util.BT.DicTypeI</IndexLocation>
<StreamLocation>^DHCMA.Util.BT.DicTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
