/// 名称: DHCHAI.MAP.CssRange
/// 描述: 横断面调查导出值域字典
/// 编写者：chenjb
/// 编写日期: 2022-08-23
Class DHCHAI.MAP.CssRange Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 分类/项目编码（参考省市县乡格式：000000-000000-00）
Property BRType As %String(TRUNCATE = 1) [ Required ];

/// 值域代码
Property BRCode As %String(MAXLEN = 10, TRUNCATE = 1) [ Required ];

/// 值域名称
Property BRDesc As %String(TRUNCATE = 1) [ Required ];

/// 有效标志
Property BRIsActive As %Boolean;

/// 分类编码（与值域分类编码对应）索引
Index IndexType On BRType;

/// 分类编码+值域代码 唯一索引
Index IndexTypeCode On (BRType As Exact, BRCode As Exact);

/// Creator：     zhoubo
/// CreatDate：   2021-04-14
/// Description:  根据ID取基础值域字典
/// Table：       DHCHAI.MAP.CssRange
/// Input：       ID: DHCHAI.MAP.CssRange.ID
/// Return：      返回Object
/// w ##class(DHCHAI.MAP.CssRange).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.MAP.CssRange
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.MAP.CssRange).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.MAP.CssRange).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2021-04-14
/// Description:  更新基础值域字典
/// Table：       DHCHAI.MAP.CssRange
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.MAP.CssRange).Update("^001-001-06^1^是多少^1")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set Type   		= $p(InStr,aSeparete,2)
	Set Code   		= $p(InStr,aSeparete,3)
	Set CName   	= $p(InStr,aSeparete,4)
	Set IsActive   	= +$p(InStr,aSeparete,5)
	Quit:(Code="")||(CName="")||(IsActive="")||(Type="") return
	Set CName = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(CName) //去掉特殊字符
	
	Quit:(ID="")&($d(^MA.HAI.DP.CssRangeI("IndexTypeCode",Type,Code))) -100
	//分类编码+值域代码 唯一索引
	Set tID =$o(^MA.HAI.DP.CssRangeI("IndexTypeCode",Type,Code,0)) 
	Set:tID'=ID ID=tID
	if ID="" {
		Set obj=##class(DHCHAI.MAP.CssRange).%New()
	}else{
		Set obj=##class(DHCHAI.MAP.CssRange).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.BRType		= Type
	Set obj.BRCode		= Code
	Set obj.BRDesc		= CName
	Set obj.BRIsActive	= IsActive
	
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

/// Creator：     zhoubo
/// CreatDate：   2021-04-14
/// Description:  导入基础值域字典
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.MAP.CssRange).ImportBaseRange("标准医学专业代码^98^中医妇科学")
ClassMethod ImportBaseRange(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Type	= $p(aInputStr,aSeparete,1)
	Set Code	= $p(aInputStr,aSeparete,2)
	Set CName	= $p(aInputStr,aSeparete,3)
	Quit:(Code="")||(CName="")||(Type="") return
	
	//代码唯一性
	Set tID =$o(^MA.HAI.DP.CssRangeI("IndexTypeCode",Type,Code,0)) 
	Set InputStr = tID_"^"_Type_"^"_Code_"^"_CName_"^1"
	
	Set return = ..Update(InputStr)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2021-04-14
/// Description:  删除基础值域字典
/// Table：       DHCHAI.MAP.BaseRange
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCHAI.MAP.CssRange")
	;Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.MAP.CssRange).%DeleteId(+Id)
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
<Data name="CssRangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BRType</Value>
</Value>
<Value name="3">
<Value>BRCode</Value>
</Value>
<Value name="4">
<Value>BRDesc</Value>
</Value>
<Value name="5">
<Value>BRIsActive</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.DP.CssRangeD</DataLocation>
<DefaultData>CssRangeDefaultData</DefaultData>
<IdLocation>^MA.HAI.DP.CssRangeD</IdLocation>
<IndexLocation>^MA.HAI.DP.CssRangeI</IndexLocation>
<StreamLocation>^MA.HAI.DP.CssRangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
