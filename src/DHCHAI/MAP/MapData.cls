/// 名称: DHCHAI.MAP.MapData
/// 描述:数据对照
/// 编写者：pylian
/// 编写日期: 2021-04-12
Class DHCHAI.MAP.MapData Extends (%Persistent, DHCHAI.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 分类编码（与值域分类编码对应）
Property MapType As %String(TRUNCATE = 1) [ Required ];

/// 源值唯一健值
Property MapKeyVal As %String(TRUNCATE = 1) [ Required ];

/// 源值健值描述
Property MapKeyText As %String(TRUNCATE = 1);

/// 值域映射
Property MapItemDr As DHCHAI.MAP.MapItem;

/// 有效标志
Property MapIsActive As %Boolean;

/// 更新日期
Property MapActDate As %Date;

/// 更新时间
Property MapActTime As %Time;

/// 分类编码（与值域分类编码对应）索引
Index IndexType On MapType As Exact;

/// 值域映射索引
Index IndexItemDr On MapItemDr;

/// 分类编码+唯一健值 唯一索引
Index IndexTypeVal On (MapType As Exact, MapKeyVal As Exact);

/// Creator：     pylian
/// CreatDate：   2022-04-12
/// Description:  根据ID取数据对照
/// Table：       DHCHAI.MAP.MapData
/// Input：       ID: DHCHAI.MAP.MapData.ID
/// Return：      返回Object
/// w ##class(DHCHAI.MAP.MapData).GetObjById(414)
ClassMethod GetObjById(id As %String) As DHCHAI.MAP.MapData
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.MAP.MapData).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.MAP.MapData).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-04-12
/// Description:  更新数据对照
/// Table：       DHCHAI.MAP.MapData
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.MAP.MapData).Update("^InfPos^01^呼吸系统^^1","^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set Type   		= $p(InStr,aSeparete,2)
	Set KeyVal      = $p(InStr,aSeparete,3)
	Set KeyText   	= $p(InStr,aSeparete,4)
	Set ItemDr   	= $p(InStr,aSeparete,5)
	Set IsActive   	= +$p(InStr,aSeparete,6)
	Set ActDate   	= $p(InStr,aSeparete,7)
	Set ActTime   	= $p(InStr,aSeparete,8)
	Quit:(Type="")||(KeyVal="")||(KeyText="") return
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set KeyText = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(KeyText) //去掉特殊字符
	Set objItemDr = ##class(DHCHAI.MAP.MapItem).GetObjById(ItemDr)
	
	Set tID =$o(^CF.MA.HAI.MAP.MapDataI("IndexTypeVal",Type,KeyVal,0)) 
	Set:(tID'=ID)&(ID="") ID=tID
	
	if ID="" {
		Set obj=##class(DHCHAI.MAP.MapData).%New()
	}else{
		Set obj=##class(DHCHAI.MAP.MapData).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.MapType		    = Type
	Set obj.MapKeyVal		= KeyVal
	Set obj.MapKeyText		= KeyText
	Set obj.MapItemDr       = objItemDr
	Set obj.MapIsActive	    = IsActive
	Set obj.MapActDate		= ActDate
	Set obj.MapActTime		= ActTime
	
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
/// Description:  删除数据对照
/// Table：       DHCHAI.MAP.MapData
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	
	Set sc = ##class(DHCHAI.MAP.MapData).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     pylian
/// CreatDate：   2022-04-13
/// Description:  更新值域对照
/// Table：       DHCHAI.MAP.MapData
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.MAP.MapData).UpdateMap("1","1")
ClassMethod UpdateMap(aID As %String, aItemID As %String) As %String
{
	New (aID,aItemID)
	Set return=0
	Quit:(aID="")||(aItemID="") return
	
	Set objMapItem = ##class(DHCHAI.MAP.MapItem).GetObjById(aItemID)
	Quit:'$IsObject(objMapItem) return
	Set obj=##class(DHCHAI.MAP.MapData).%OpenId(aID)
	Quit:'$IsObject(obj) return
	Set obj.MapItemDr	= objMapItem
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
/// Description:  删除对照关系
/// Table：       DHCHAI.MAP.MapData
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteMapById(aId)
{
	New (aId)
    Set return = 0
	Set obj=##class(DHCHAI.MAP.MapData).%OpenId(aId)
	Quit:'$IsObject(obj) return
	Set obj.MapItemDr     = ""
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
<Value>MapKeyVal</Value>
</Value>
<Value name="4">
<Value>MapKeyText</Value>
</Value>
<Value name="5">
<Value>MapItemDr</Value>
</Value>
<Value name="6">
<Value>MapIsActive</Value>
</Value>
<Value name="7">
<Value>MapActDate</Value>
</Value>
<Value name="8">
<Value>MapActTime</Value>
</Value>
</Data>
<DataLocation>^CF.MA.HAI.MAP.MapDataD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.MA.HAI.MAP.MapDataD</IdLocation>
<IndexLocation>^CF.MA.HAI.MAP.MapDataI</IndexLocation>
<StreamLocation>^CF.MA.HAI.MAP.MapDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
