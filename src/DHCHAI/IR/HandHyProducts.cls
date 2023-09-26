/// 名称: DHCHAI.IR.HandHyProducts
/// 描述: 手卫生用品字典
/// 编写者：zhoubo
/// 编写日期: 2017-12-20
Class DHCHAI.IR.HandHyProducts Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property HHPCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property HHPDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 拼音码
Property HHPPinyin As %String(TRUNCATE = 1);

/// 规格
Property HHPSpec As %String(TRUNCATE = 1) [ Required ];

/// 单位 ("HandHyUnit")
Property HHPUnit As DHCHAI.BT.Dictionary [ Required ];

/// 次均用量
Property HHPAvgAmount As %Integer;

/// 是否有效
Property HHPActive As %Boolean;

/// 备注
Property HHPResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 名称+规格
Index IndexDescSpec On (HHPDesc As Exact, HHPSpec As Exact);

/// 名称
Index IndexDesc On HHPDesc As Exact;

/// 代码
Index IndexCode On HHPCode As Exact;

/// Creator：     zhoubo
/// CreatDate：   2017-12-27
/// Description:  根据ID取手卫生用品
/// Table：       DHCHAI.IR.HandHyProducts
/// Input：       aId : DHCHAI.IR.HandHyProducts.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.HandHyProducts).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.HandHyProducts
{
	New (aId)
	Quit:'##class(DHCHAI.IR.HandHyProducts).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.HandHyProducts).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-12-27
/// Description:  更新手卫生用品
/// Table：       DHCHAI.IR.HandHyProducts
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.HandHyProducts).Update("^1^洗手液^XSY^500ml^690^2^1^beizhuxinxi","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ID        = $p(aInputStr,aSeparete,1)
	Set Code	  = $p(aInputStr,aSeparete,2)
	Set Desc      = $p(aInputStr,aSeparete,3)
	Set Pinyin    = $p(aInputStr,aSeparete,4)
	Set Spec      = $p(aInputStr,aSeparete,5)
	Set UnitDr    = $p(aInputStr,aSeparete,6)
	Set AvgAmount = $p(aInputStr,aSeparete,7)
	Set Active    = +$p(aInputStr,aSeparete,8)
	Set Resume    = $p(aInputStr,aSeparete,9)
	Quit:(Code="")||(Desc="")||(Spec="")||(UnitDr="")||(AvgAmount="") return
	
	Set objUnit=##class(DHCHAI.BT.Dictionary).GetObjById(UnitDr)
	Quit:'$IsObject(objUnit) return
	// 代码 唯一性
	Set tID = $o(^DHCHAI.IR.HandHyProductsI("IndexCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -101
	// 名称+规格 唯一性
	Set tID = $o(^DHCHAI.IR.HandHyProductsI("IndexDescSpec",Desc,Spec,0))
	Quit:(tID'="")&(ID'=tID) -100
	If ID="" {
		Set obj=##class(DHCHAI.IR.HandHyProducts).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.HandHyProducts).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.HHPCode      = Code
	Set obj.HHPDesc      = Desc
	Set obj.HHPPinyin    = Pinyin
	Set obj.HHPSpec      = Spec
	Set obj.HHPUnit      = objUnit
	Set obj.HHPAvgAmount = AvgAmount
	Set obj.HHPActive    = Active
	Set obj.HHPResume    = Resume
	
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
/// CreatDate：   2017-12-27
/// Description:  删除手卫生用品记录
/// Table：       DHCHAI.IR.HandHyProducts
/// Input：       aId : DHCHAI.IR.HandHyProducts.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.HandHyProducts).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	//
	Set IsOk = ..IsReged(aId)
	If (IsOk<0){
		Set return = -2
		Quit return	
	}
	//
	
	Set sc = ##class(DHCHAI.IR.HandHyProducts).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// CreatDate：   2017-12-27
/// Description:  判断手卫生用品是否进行过手卫生消耗登记
/// Table：       DHCHAI.IR.HandHyConsums
/// Input：       aId : DHCHAI.IR.HandHyProducts.ID
/// Return：      产品未被登记过消耗：返回0，
/// 				  产品  被登记过消耗：返回<0的代码
/// w ##class(DHCHAI.IR.HandHyProducts).IsReged(1)
ClassMethod IsReged(aId As %String) As %String
{
	New (aId)
	
	Set xLoc="",Str=""
	For {
		Set xLoc = $o(^DHCHAI.IR.HandHyConsumsI("IndexLocDate",xLoc))
		Quit:xLoc=""
		Set xDate = ""
		For {
			Set xDate = $o(^DHCHAI.IR.HandHyConsumsI("IndexLocDate",xLoc,xDate))
			Quit:xDate=""
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.IR.HandHyConsumsI("IndexLocDate",xLoc,xDate,xID))
				Quit:xID=""
				;w xID,!
				Set IsActive	= $lg(^DHCHAI.IR.HandHyConsumsD(xID),10)
				;Continue:IsActive'=1
				Set Produ 		= $lg(^DHCHAI.IR.HandHyConsumsD(xID),4)
				Set Str = Str_$lb(Produ)
			}	
		}
	}
	;b //1
	If ($listfind(Str,aId)=0){
		Set return=0	//产品未被登记过消耗
	} Else{
		Set return=-1
	}
	
	Quit return
}

Storage Default
{
<Data name="HandHyProductsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HHPCode</Value>
</Value>
<Value name="3">
<Value>HHPDesc</Value>
</Value>
<Value name="4">
<Value>HHPPinyin</Value>
</Value>
<Value name="5">
<Value>HHPSpec</Value>
</Value>
<Value name="6">
<Value>HHPUnit</Value>
</Value>
<Value name="7">
<Value>HHPAvgAmount</Value>
</Value>
<Value name="8">
<Value>HHPActive</Value>
</Value>
<Value name="9">
<Value>HHPResume</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.HandHyProductsD</DataLocation>
<DefaultData>HandHyProductsDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.HandHyProductsD</IdLocation>
<IndexLocation>^DHCHAI.IR.HandHyProductsI</IndexLocation>
<StreamLocation>^DHCHAI.IR.HandHyProductsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
