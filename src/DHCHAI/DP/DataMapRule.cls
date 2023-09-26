/// 名称: DHCHAI.DP.DataMapRule
/// 描述: 对照匹配规则
/// 编写者：pylian
/// 编写日期: 2017-08-03
Class DHCHAI.DP.DataMapRule Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 分类
Property BTCatDr As DHCHAI.BT.Dictionary [ Required ];

/// 标准名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 对照名称
Property BTMapDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 关系类型(0:匹配，1:包含，2:排除)
Property BTType As %Integer [ Required ];

/// 分类索引
Index IndexCat On BTCatDr As Exact;

/// 标准名称索引
Index IndexDesc On BTDesc As Exact;

/// 对照名称索引
Index IndexMapDesc On BTMapDesc As Exact;

/// 分类、对照名称索引
Index IndexCatDescUnique On (BTCatDr, BTDesc, BTMapDesc) [ Unique ];

/// 分类、类型、对照名称索引
Index IndexCatMapDesc On (BTCatDr, BTType, BTMapDesc As Exact);

/// 分类、类型、标准名称、对照名称索引
Index IndexCatDescMapDesc On (BTCatDr, BTType, BTDesc As Exact, BTMapDesc As Exact);

/// Creator：     pylian
/// CreatDate：   2017-08-03
/// Description:  根据ID对照匹配规则
/// Table：       DHCHAI.DP.DataMapRule
/// Input：       ID:    DHCHAI.DP.DataMapRule.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.DataMapRule).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.DP.DataMapRule
{
	New (aId)
	Quit:'##class(DHCHAI.DP.DataMapRule).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.DP.DataMapRule).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2017-08-03
/// Description:  更新对照匹配规则
/// Table：       DHCHAI.DP.DataMapRule
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.DataMapRule).Update("^116^金杆菌属^芽胞杆菌^1")
ClassMethod Update(aInStr As %String, aSeparete As %String = "^") As %String
{
	New (aInStr,aSeparete)
	Set return=0
	Quit:aInStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(aInStr,aSeparete,1)
	Set CatDr		= $p(aInStr,aSeparete,2)
	Set Desc		= $p(aInStr,aSeparete,3)
	Set MapDesc		= $p(aInStr,aSeparete,4)
	Set Type		= +$p(aInStr,aSeparete,5)
	Quit:(CatDr="")||(Desc="")||(MapDesc="")||(Type="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	//分类 + 对照名称 唯一性
	Set tID =$o(^DHCHAI.DP.DataMapRuleI("IndexCatDescUnique",CatDr," "_$zcvt(Desc,"U")," "_$zcvt(MapDesc,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objCat = ##class(DHCHAI.BT.Dictionary).GetObjById(CatDr)
	if ID="" {
		Set obj=##class(DHCHAI.DP.DataMapRule).%New()
	}else{
		Set obj=##class(DHCHAI.DP.DataMapRule).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCatDr		= objCat
	Set obj.BTDesc		= Desc
	Set obj.BTMapDesc   = MapDesc
	Set obj.BTType		= Type
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-08-03
/// Description:  删除对照匹配规则
/// Table：       DHCHAI.DP.DataMapRule
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.DataMapRule).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     pylian
/// CreatDate：   2017-08-03
/// Description:  导入对照匹配
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##Class(DHCHAI.DP.DataMapRule).ImportRule("","^")
ClassMethod ImportRule(aInStr As %String, aSeparate As %String) As %String
{
	New (aInStr,aSeparate)
	Set return = ""
	Quit:(aInStr="")||(aSeparate="") return
	
	Set CatDr = ""
	Set CatDesc	= $p(aInStr,aSeparate,2)
	Set objDic  = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("DataMapRule",CatDesc)
	If $Isobject(objDic) {
		Set CatDr = objDic.%Id()
	}
	Set $p(aInStr,aSeparate,2) = CatDr
	
	Set TypeDesc =$p(aInStr,aSeparate,5)
	Set Type = 0
	Set Type = $s(TypeDesc="匹配":"0",TypeDesc="包含":"1",TypeDesc="排除":"2")
	Set $p(aInStr,aSeparate,5) = Type
	
	Set return = ..Update(aInStr,aSeparate)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-08-05
/// Description:  根据分类描述获得分类ID
/// Input：       aCatDesc
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##Class(DHCHAI.DP.DataMapRule).GetCatID("检验细菌")
ClassMethod GetCatID(aCatDesc As %String) As %String
{
	New (aCatDesc)
	Set return = -1
	Quit:(aCatDesc) return
	
	Set CatDr = ""
	Set objDic  = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("DataMapRule",aCatDesc)
	If $Isobject(objDic) {
		Set CatDr = objDic.%Id()
	}
	Set return = CatDr
	
   Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCatDr</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTMapDesc</Value>
</Value>
<Value name="5">
<Value>BTType</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.DataMapRuleD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.DataMapRuleD</IdLocation>
<IndexLocation>^DHCHAI.DP.DataMapRuleI</IndexLocation>
<StreamLocation>^DHCHAI.DP.DataMapRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
