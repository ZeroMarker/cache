Class DHCMed.NINF.Aim.HandLiquidType Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 洗手液Code
Property HandLiquidCode As %String(TRUNCATE = 1) [ Required ];

/// 名称
Property HLName As %String(TRUNCATE = 1);

/// 容量
Property HlVolume As %String(TRUNCATE = 1);

/// 单位
Property HlUnit As %String(TRUNCATE = 1);

/// 类型
Property Type As %String(TRUNCATE = 1);

Index IndexOfName On (HandLiquidCode, HLName) [ Unique ];

/// w ##class(DHCMed.NINF.Aim.HandLiquidType).Update("^a^b^c^d")
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.NINF.Aim.HandLiquidType).%New()
		} 
	else {
		set obj=##class(DHCMed.NINF.Aim.HandLiquidType).%OpenId(ID)
		}
	set obj.HandLiquidCode= $p(InStr,"^",2)
	set obj.HLName  = $p(InStr,"^",3)
	set obj.HlVolume = $p(InStr,"^",4)
	set obj.HlUnit = $p(InStr,"^",5)
	set obj.Type = $p(InStr,"^",6)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

ClassMethod GetObjById(id As %String) As DHCMed.NINF.Aim.HandLiquidType
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Aim.HandLiquidType).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Aim.HandLiquidType).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

Storage Default
{
<Data name="HandLiquidTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HLName</Value>
</Value>
<Value name="3">
<Value>HandLiquidCode</Value>
</Value>
<Value name="4">
<Value>HlUnit</Value>
</Value>
<Value name="5">
<Value>HlVolume</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.HandLiquidTypeD</DataLocation>
<DefaultData>HandLiquidTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.HandLiquidTypeD</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.HandLiquidTypeI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.HandLiquidTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
