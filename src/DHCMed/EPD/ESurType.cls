/// 名称：DHCMed.EPD.ESurType
/// 表名：DHCMed_EPD.ESurType
/// 流行病学调查表类型定义
/// 编写者：chenrui
/// 编写日期:2021-06-11
Class DHCMed.EPD.ESurType Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 内容扩展
Relationship ChildExt As DHCMed.EPD.ESurTypeExt [ Cardinality = children, Inverse = Parref ];

/// 代码
Property ESCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property ESDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 是否有效
Property ESIsActive As %Boolean;

/// 备注（说明）
Property ESResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 代码索引
Index IndexCode On ESCode As Exact;

/// 名称索引
Index IndexDesc On ESDesc As Exact;

/// Creator：     chenr
/// CreatDate：   2021-07-16
/// Description:  根据ID取流调类型表
/// Table：       名称：DHCMed.EPD.ESurType
/// Input：       aId : DHCMed.EPD.ESurType.ID
/// Return：      返回obj
/// w ##class(DHCMed.EPD.ESurType).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.EPD.ESurType
{
	New (aId)
	Quit:'##class(DHCMed.EPD.ESurType).%ExistsId(aId) ""
	Set obj=##Class(DHCMed.EPD.ESurType).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenr
/// CreatDate：   2021-07-16
/// Description:  更新流调类型表
/// Table：       DHCHAI.IR.OccExpType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.ESurType).Update("1^BJXHZYBL^北京协和职业暴露^1^北京协和职业暴露")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(aInputStr,aSeparete,1)
	Set Code		= $p(aInputStr,aSeparete,2)
	Set Desc		= $p(aInputStr,aSeparete,3)
	Set IsActive	= +$p(aInputStr,aSeparete,4)
	Set Resume		= $p(aInputStr,aSeparete,5)
	Quit:(Code="")||(Desc="") return
	
	Set Code=$zcvt(Code,"U")
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set tID=$o(^DHCMed.EPD.ESurTypeI("IndexCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMed.EPD.ESurType).%New()
	}Else{
		Set obj=##class(DHCMed.EPD.ESurType).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ESCode	    = Code
	Set obj.ESDesc	    = Desc
	Set obj.ESIsActive 	= IsActive
	Set obj.ESResume 	= Resume
	
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

/// Creator：     chenr
/// CreatDate：   2021-07-16
/// Description:  删除流调类型
/// Table：       DHCMed.EPD.ESurType
/// Input：       aId : DHCMed.EPD.ESurType.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.EPD.ESurType).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMed.EPD.ESurType).%DeleteId(aId)
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
<Data name="ESurTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ESCode</Value>
</Value>
<Value name="3">
<Value>ESDesc</Value>
</Value>
<Value name="4">
<Value>ESIsActive</Value>
</Value>
<Value name="5">
<Value>ESResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.ESurTypeD</DataLocation>
<DefaultData>ESurTypeDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.ESurTypeD</IdLocation>
<IndexLocation>^DHCMed.EPD.ESurTypeI</IndexLocation>
<StreamLocation>^DHCMed.EPD.ESurTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
