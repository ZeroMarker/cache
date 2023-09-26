/// 名称: DHCHAI.MAP.MapItem
/// 描述: 值域字典
/// 编写者：pylian
/// 编写日期: 2022-04-12
Class DHCHAI.MAP.MapItem Extends (%Persistent, DHCHAI.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 分类/项目编码
Property MapType As %String(TRUNCATE = 1) [ Required ];

/// 分类/项目名称
Property MapCate As %String(TRUNCATE = 1);

/// 值域代码
Property MapCode As %String(TRUNCATE = 1) [ Required ];

/// 值域名称
Property MapDesc As %String(TRUNCATE = 1) [ Required ];

/// 值域名称2
Property MapDesc2 As %String(TRUNCATE = 1);

/// 数据来源（哨点医院专项活动、）
Property MapSource As %String(TRUNCATE = 1);

/// 有效标志
Property MapIsActive As %Boolean;

/// 分类编码（与值域分类编码对应）索引
Index IndexType On MapType As Exact;

/// 分类编码+值域代码 唯一索引
Index IndexTypeCode On (MapType As Exact, MapCode As Exact);

/// Creator：     pylian
/// CreatDate：   2022-04-12
/// Description:  根据ID取值域字典
/// Table：       DHCHAI.MAP.MapItem
/// Input：       ID: DHCHAI.MAP.MapItem.ID
/// Return：      返回Object
/// w ##class(DHCHAI.MAP.MapItem).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.MAP.MapItem
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.MAP.MapItem).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.MAP.MapItem).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-04-12
/// Description:  更新值域字典
/// Table：       DHCHAI.MAP.MapItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.MAP.MapItem).Update("11^Location^科室字典^10^其它内科^内科^^1","^")
ClassMethod Update(aInStr As %String, aSeparete As %String) As %String
{
	New (aInStr,aSeparete)
	
	Set return=0
	Quit:aInStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		  = $p(aInStr,aSeparete,1)
	Set Type   	  = $p(aInStr,aSeparete,2)
	Set Cate      = $p(aInStr,aSeparete,3)
	Set Code   	  = $p(aInStr,aSeparete,4)
	Set Desc   	  = $p(aInStr,aSeparete,5)
	Set Desc2     = $p(aInStr,aSeparete,6)
	Set Source    = $p(aInStr,aSeparete,7)
	Set IsActive  = +$p(aInStr,aSeparete,8)
	Quit:(Code="")||(Desc="")||(Type="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	//分类编码+值域代码 唯一索引
	Set tID =$o(^CF.MA.HAI.MAP.MapItemI("IndexTypeCode",Type,Code,0)) 
	Set:(tID'=ID)&(ID="") ID=tID

	if ID="" {
		Set obj=##class(DHCHAI.MAP.MapItem).%New()
	}else{
		Set obj=##class(DHCHAI.MAP.MapItem).%OpenId(ID)
	}

	Quit:'$IsObject(obj) return
	Set obj.MapType		= Type
	Set obj.MapCate		= Cate
	Set obj.MapCode		= Code
	Set obj.MapDesc		= Desc
	Set obj.MapDesc2	= Desc2
	Set obj.MapSource	= Source
	Set obj.MapIsActive	= IsActive
	
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
/// CreatDate：   2022-04-12
/// Description:  删除值域字典
/// Table：       DHCHAI.MAP.MapItem
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.MAP.MapItem).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MapType</Value>
</Value>
<Value name="3">
<Value>MapCate</Value>
</Value>
<Value name="4">
<Value>MapCode</Value>
</Value>
<Value name="5">
<Value>MapDesc</Value>
</Value>
<Value name="6">
<Value>MapDesc2</Value>
</Value>
<Value name="7">
<Value>MapSource</Value>
</Value>
<Value name="8">
<Value>MapIsActive</Value>
</Value>
</Data>
<DataLocation>^CF.MA.HAI.MAP.MapItemD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.MA.HAI.MAP.MapItemD</IdLocation>
<IndexLocation>^CF.MA.HAI.MAP.MapItemI</IndexLocation>
<StreamLocation>^CF.MA.HAI.MAP.MapItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
