/// 名称: DHCMA.CPW.SD.PCPriceMast
/// 描述: 医疗服务价格项目规范（CCHI）
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.SD.PCPriceMast Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目编码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 项目名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目内涵
Property BTNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// 除外内容
Property BTException As %String(MAXLEN = 500, TRUNCATE = 1);

/// 计价单位
Property BTChargeUnit As %String(MAXLEN = 50, TRUNCATE = 1);

/// 计价说明
Property BTChargeNote As %String(MAXLEN = 500, TRUNCATE = 1);

Index IdxofCode On BTCode;

/// Creator：     xuwenjie
/// CreatDate：   2018-08-29
/// Description:  根据ID取单病种服务价格字典信息
/// Table：       DHCMA.CPW.SD.PCPriceMast
/// Input：       aId : DHCMA.CPW.SD.PCPriceMast.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.SD.PCPriceMast).GetObjById(15)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.PCPriceMast
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.PCPriceMast).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.PCPriceMast).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     xuwenjie
/// CreatDate：   2018-08-29
/// Description:  根据Code取单病种服务价格字典信息
/// Table：       DHCMA.CPW.SD.PCPriceMast
/// Input：       aCode : DHCMA.CPW.SD.PCPriceMast.BTCode
/// Return：      返回String
/// w ##class(DHCMA.CPW.SD.PCPriceMast).GetObjByCode("C4")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^DHCMA.CPW.SD.PCPriceMastI("IdxofCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     xuwenjie
/// CreatDate：   2018-08-29
/// Description:  更新单病种服务价格字典信息
/// Table：       DHCMA.CPW.SD.PCPriceMast
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.PCPriceMast).Update("^Code^Desc")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID               = $p(aInputStr,aSeparete,1)
	Set Code             = $p(aInputStr,aSeparete,2)
	Set Desc             = $p(aInputStr,aSeparete,3)
	Set Note             = $p(aInputStr,aSeparete,4)
	Set Exception        = $p(aInputStr,aSeparete,5)
	Set ChargeUnit       = $p(aInputStr,aSeparete,6)
	Set ChargeNote       = $p(aInputStr,aSeparete,7)
	Quit:(Code="")||(Desc="") return
	
	Set tID=$o(^DHCMA.CPW.SD.PCPriceMastI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2                
	
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.PCPriceMast).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.PCPriceMast).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTNote     = Note
	Set obj.BTException     = Exception
	Set obj.BTChargeUnit     = ChargeUnit
	Set obj.BTChargeNote     = ChargeNote
	
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
/// Description:  删除单病种服务价格字典信息
/// Table：       DHCMA.CPW.SD.PCPriceMast
/// Input：       aId : DHCMA.CPW.SD.PCPriceMast.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.PCPriceMast).DeleteById(6)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.PCPriceMast).%DeleteId(aId)
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
<Data name="PCPriceMastDefaultData">
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
<Value>BTNote</Value>
</Value>
<Value name="5">
<Value>BTException</Value>
</Value>
<Value name="6">
<Value>BTChargeUnit</Value>
</Value>
<Value name="7">
<Value>BTChargeNote</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.PCPriceMastD</DataLocation>
<DefaultData>PCPriceMastDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.PCPriceMastD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.PCPriceMastI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.PCPriceMastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
