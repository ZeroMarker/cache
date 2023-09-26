/// 名称: DHCMA.Util.BT.Product
/// 描述: 产品线表
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.BT.Product Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 产品代码（规范命名：例：医院信息系统HIS、传染病EPD、死亡证DTH...）
Property ProCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 产品名称
Property ProDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 版本号
Property ProVersion As %String(MAXLEN = 100, TRUNCATE = 1);

/// 图标样式
Property ProIconClass As %String(MAXLEN = 100, TRUNCATE = 1);

/// 显示顺序号
Property ProIndNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property ProIsActive As %Boolean;

/// 备注
Property ProResume As %String(MAXLEN = 100, TRUNCATE = 1);

Index IdxOfProCode On ProCode [ Unique ];

Index IdxOfProIndNo On ProIndNo;

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据ID取产品线信息
/// Table：       DHCMA.Util.BT.Product
/// Input：       aId : DHCMA.Util.BT.Product.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.BT.Product).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.BT.Product
{
	New (aId)
	Quit:'##class(DHCMA.Util.BT.Product).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.BT.Product).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据Code取产品线信息
/// Table：       DHCMA.Util.BT.Product
/// Input：       aCode : DHCMA.Util.BT.Product.Code
/// Return：      返回obj
/// w ##class(DHCMA.Util.BT.Product).GetObjByCode("HIS")
ClassMethod GetObjByCode(aCode As %String) As DHCMA.Util.BT.Product
{
	New (aCode)
	Quit:aCode="" ""
	Set ID=$o(^DHCMA.Util.BT.ProductI("IdxOfProCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新产品线信息
/// Table：       DHCMA.Util.BT.Product
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.Product).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set Version  = $p(aInputStr,aSeparete,4)
	Set IconClass= $p(aInputStr,aSeparete,5)
	Set IndNo    = $p(aInputStr,aSeparete,6)
	Set IsActive = +$p(aInputStr,aSeparete,7)
	Set Resume   = $p(aInputStr,aSeparete,8)
	Quit:(Code="")||(Desc="") return
	
	Set tID=$o(^DHCMA.Util.BT.ProductI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMA.Util.BT.Product).%New()
	}Else{
		Set obj=##class(DHCMA.Util.BT.Product).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ProCode     = Code
	Set obj.ProDesc     = Desc
	Set obj.ProVersion  = Version
	Set obj.ProIconClass= IconClass
	Set obj.ProIndNo    = IndNo
	Set obj.ProIsActive = IsActive
	Set obj.ProResume   = Resume
	
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
/// Description:  删除产品线信息
/// Table：       DHCMA.Util.BT.Product
/// Input：       aId : DHCMA.Util.BT.Product.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.Product).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.Util.BT.Product")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCMA.Util.BT.Product).%DeleteId(aId)
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
<Data name="ProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProCode</Value>
</Value>
<Value name="3">
<Value>ProDesc</Value>
</Value>
<Value name="4">
<Value>ProVersion</Value>
</Value>
<Value name="5">
<Value>ProIconClass</Value>
</Value>
<Value name="6">
<Value>ProIndNo</Value>
</Value>
<Value name="7">
<Value>ProIsActive</Value>
</Value>
<Value name="8">
<Value>ProResume</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.BT.ProductD</DataLocation>
<DefaultData>ProductDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.BT.ProductD</IdLocation>
<IndexLocation>^DHCMA.Util.BT.ProductI</IndexLocation>
<StreamLocation>^DHCMA.Util.BT.ProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
