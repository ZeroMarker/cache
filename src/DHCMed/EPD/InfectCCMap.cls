/// 名称: DHCMed.EPD.InfectCCMap
/// 描述: 传染病疾病字典与监控中心传染病监控项目关联记录表
/// 编写者：liuyh
/// 编写日期: 2017-05-31
Class DHCMed.EPD.InfectCCMap Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// DHCMed.EPD.Infection表rowid
Property InfectionID As %String(TRUNCATE = 1);

/// DHCMed.CC.ItemDic表rowid
Property ItemDicID As %String(TRUNCATE = 1);

Index IndexInfDicID On (InfectionID, ItemDicID) [ Unique ];

/// Creator：     liuyh
/// CreatDate：   2017-05-31
/// Description:  根据ID取传染病疾病字典与监控中心传染病监控项目关联记录
/// Table：       DHCMed.EPD.InfectCCMap
/// Input：       ID:    DHCMed.EPD.InfectCCMap.ID
///               separete: 指定的分隔符
/// Return：      返回obj
/// w ##class(DHCMed.EPD.InfectCCMap).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.EPD.InfectCCMap
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.EPD.InfectCCMap).%ExistsId(+id) return
	set obj=##Class(DHCMed.EPD.InfectCCMap).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2017-05-31
/// Description:  更新传染病疾病字典与监控中心传染病监控项目关联记录
/// Table：       DHCMed.EPD.InfectCCMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	
	set id=0
	set ID=$p(InStr,"^",1)
	set InfectionIDx=$p(InStr,"^",2)
	set ItemDicIDx=$p(InStr,"^",3)
	
	set:ID="" ID=$o(^DHCMed.EPD.InfectCCMapI("IndexInfDicID"," "_InfectionIDx," "_ItemDicIDx,0))
	
	if ID="" {
		set obj=##class(DHCMed.EPD.InfectCCMap).%New()
	}else{
		set obj=##class(DHCMed.EPD.InfectCCMap).%OpenId(ID)
	}
	set obj.InfectionID=InfectionIDx
	set obj.ItemDicID=ItemDicIDx
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		set id=-1
	}else{
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

ClassMethod DeleteById(InStr As %String) As %String
{
	new (InStr)
	
	set ret=-1
	set ID=$p(InStr,"^",1)
	set InfectionIDx=$p(InStr,"^",2)
	set ItemDicIDx=$p(InStr,"^",3)
	
	set:ID="" ID=$o(^DHCMed.EPD.InfectCCMapI("IndexInfDicID"," "_InfectionIDx," "_ItemDicIDx,0))
	quit:ID="" ret
	
	set sc = ##class(DHCMed.EPD.InfectCCMap).%DeleteId(+ID)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
	}
	quit ret
}

Storage Default
{
<Data name="InfectCCMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InfectionID</Value>
</Value>
<Value name="3">
<Value>ItemDicID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.InfectCCMapD</DataLocation>
<DefaultData>InfectCCMapDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.InfectCCMapD</IdLocation>
<IndexLocation>^DHCMed.EPD.InfectCCMapI</IndexLocation>
<StreamLocation>^DHCMed.EPD.InfectCCMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
