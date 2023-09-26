/// 名称: DHCHAI.MAP.CssMapping
/// 描述: 横断面调查导出基础字典映射
/// 编写者：chenjb
/// 编写日期: 2022-08-23
Class DHCHAI.MAP.CssMapping Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 分类编码（与值域分类编码对应）
Property BMType As %String(TRUNCATE = 1) [ Required ];

/// 唯一健值
Property BMKeyVal As %String(TRUNCATE = 1) [ Required ];

/// 健值描述
Property BMKeyText As %String(TRUNCATE = 1);

/// 值域映射
Property BMRangeDr As DHCHAI.MAP.BaseRange;

/// 有效标志
Property BMIsActive As %Boolean;

/// 更新日期
Property BMActDate As %Date;

/// 更新时间
Property BMActTime As %Time;

/// 操作人
Property BMActUserDr As DHCHAI.BT.SysUser;

/// 分类编码（与值域分类编码对应）索引
Index IndexType On BMType;

/// 值域映射索引
Index IndexRangeDr On BMRangeDr;

/// 分类编码+唯一健值 唯一索引
Index IndexTypeVal On (BMType As Exact, BMKeyVal As Exact);

/// Creator：     zhoubo
/// CreatDate：   2021-04-14
/// Description:  根据ID取基础值域字典
/// Table：       DHCHAI.MAP.CssMapping
/// Input：       ID: DHCHAI.MAP.CssMapping.ID
/// Return：      返回Object
/// w ##class(DHCHAI.MAP.CssMapping).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.MAP.CssMapping
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.MAP.CssMapping).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.MAP.CssMapping).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2021-04-14
/// Description:  更新基础值域字典
/// Table：       DHCHAI.MAP.CssMapping
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.MAP.CssMapping).Update("^001-001-01^1^是多少1^1^1^^^1")
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
	Set RangeDr   	= $p(InStr,aSeparete,5)
	Set IsActive   	= +$p(InStr,aSeparete,6)
	Set ActDate   	= $p(InStr,aSeparete,7)
	Set ActTime   	= $p(InStr,aSeparete,8)
	Set ActUserDr   = $p(InStr,aSeparete,9)
	Quit:(Type="")||(KeyVal="")||(KeyText="") return
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set KeyText = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(KeyText) //去掉特殊字符
	Set ObjRangeDr = ##class(DHCHAI.MAP.CssMapping).GetObjById(RangeDr)
	Set ObjActUserDr = ##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	Quit:(ID="")&($d(^MA.HAI.DP.CssMappingI("IndexTypeVal",Type,KeyVal))) -100
	if ID="" {
		Set obj=##class(DHCHAI.MAP.CssMapping).%New()
	}else{
		Set obj=##class(DHCHAI.MAP.CssMapping).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.BMType		    = Type
	Set obj.BMKeyVal		= KeyVal
	Set obj.BMKeyText		= KeyText
	Set obj.BMRangeDr       = ObjRangeDr
	Set obj.BMIsActive	    = IsActive
	Set obj.BMActDate		= ActDate
	Set obj.BMActTime		= ActTime
	Set obj.BMActUserDr	    = ObjActUserDr
	
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
/// CreatDate：   2021-04-15
/// Description:  导入基础值域字典
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.MAP.CssMapping).ImportBaseMapping("^手术切口愈合等级^1^甲^^1^^^")
ClassMethod ImportBaseMapping(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ID			= $p(aInputStr,aSeparete,1)
	Set Type   		= $p(aInputStr,aSeparete,2)
	Set KeyVal      = $p(aInputStr,aSeparete,3)
	Set KeyText   	= $p(aInputStr,aSeparete,4)
	Set RangeDr   	= $p(aInputStr,aSeparete,5)
	Set IsActive   	= +$p(aInputStr,aSeparete,6)
	Set ActDate   	= $p(aInputStr,aSeparete,7)
	Set ActTime   	= $p(aInputStr,aSeparete,8)
	Set ActUserDr   = $p(aInputStr,aSeparete,9)
	
	Quit:(Type="")||(KeyVal="")||(KeyText="") return
	Set ID=$o(^MA.HAI.DP.CssMappingI("IndexTypeVal",Type,KeyVal,0))
	Set InputStr = ID_"^"_Type_"^"_KeyVal_"^"_KeyText_"^"_RangeDr_"^1^^^"
	Set return = ..Update(InputStr)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2021-04-14
/// Description:  删除基础值域字典
/// Table：       DHCHAI.MAP.CssMapping
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	;Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.MAP.CssMapping).%DeleteId(+Id)
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
<Data name="CssMappingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BMType</Value>
</Value>
<Value name="3">
<Value>BMKeyVal</Value>
</Value>
<Value name="4">
<Value>BMKeyText</Value>
</Value>
<Value name="5">
<Value>BMRangeDr</Value>
</Value>
<Value name="6">
<Value>BMIsActive</Value>
</Value>
<Value name="7">
<Value>BMActDate</Value>
</Value>
<Value name="8">
<Value>BMActTime</Value>
</Value>
<Value name="9">
<Value>BMActUserDr</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.DP.CssMappingD</DataLocation>
<DefaultData>CssMappingDefaultData</DefaultData>
<IdLocation>^MA.HAI.DP.CssMappingD</IdLocation>
<IndexLocation>^MA.HAI.DP.CssMappingI</IndexLocation>
<StreamLocation>^MA.HAI.DP.CssMappingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
