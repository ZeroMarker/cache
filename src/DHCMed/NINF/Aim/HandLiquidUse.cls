Class DHCMed.NINF.Aim.HandLiquidUse Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 洗手液类型指针
Property HandLiquidDR As %String(TRUNCATE = 1) [ Required ];

/// 数量
Property HandLiquidNum As %String(TRUNCATE = 1);

/// 当次领用部门指针
Property CTLocDR As %String(TRUNCATE = 1);

Index IndexOfCTLocDR On (CTLocDR, HandLiquidDR);

ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.NINF.Aim.HandLiquidUse).%New()
		} 
	else {
		set obj=##class(DHCMed.NINF.Aim.HandLiquidUse).%OpenId(ID)
		}
	set obj.HandLiquidDR= $p(InStr,"^",2)
	set obj.HandLiquidNum  = $p(InStr,"^",3)
	set obj.CTLocDR = $p(InStr,"^",4)
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

ClassMethod GetObjById(id As %String) As DHCMed.NINF.Aim.HandLiquidUse
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Aim.HandLiquidUse).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Aim.HandLiquidUse).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

Storage Default
{
<Data name="HandLiquidUseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CTLocDR</Value>
</Value>
<Value name="3">
<Value>HandLiquidDR</Value>
</Value>
<Value name="4">
<Value>HandLiquidNum</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.HandLiquidUseD</DataLocation>
<DefaultData>HandLiquidUseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.HandLiquidUseD</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.HandLiquidUseI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.HandLiquidUseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
