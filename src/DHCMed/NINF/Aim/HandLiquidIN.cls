Class DHCMed.NINF.Aim.HandLiquidIN Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 洗手液出库量年份
Property InYears As %String(TRUNCATE = 1) [ Required ];

/// 洗手液出库量月份
Property InMonth As %String(TRUNCATE = 1) [ Required ];

/// 导入日期
Property InDate As %String(TRUNCATE = 1);

/// 导入时间
Property InTime As %String(TRUNCATE = 1);

/// 导入人
Property InUserDR As %String(TRUNCATE = 1);

Index IndexOfDateTime On (InYears, InMonth);

ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.NINF.Aim.HandLiquidIN).%New()
		} 
	else {
		set obj=##class(DHCMed.NINF.Aim.HandLiquidIN).%OpenId(ID)
		}
	set obj.InYears= $p(InStr,"^",2)
	set obj.InMonth  = $p(InStr,"^",3)
	set obj.InDate = $p(InStr,"^",4)
	set obj.InTime = $p(InStr,"^",5)
	set obj.InUserDR = $p(InStr,"^",6)
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

Storage Default
{
<Data name="HandLiquidINDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InDate</Value>
</Value>
<Value name="3">
<Value>InMonth</Value>
</Value>
<Value name="4">
<Value>InTime</Value>
</Value>
<Value name="5">
<Value>InUserDR</Value>
</Value>
<Value name="6">
<Value>InYears</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.HandLiquidIND</DataLocation>
<DefaultData>HandLiquidINDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.HandLiquidIND</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.HandLiquidINI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.HandLiquidINS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
