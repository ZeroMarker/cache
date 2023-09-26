Class CHSSWeb.Reg.CARD.CardPATRegConfig Extends %Persistent
{

ClassMethod GetCardPatRegConfig() As %String
{
	set Returnvalue=""
	set RowID=""
	set RowID=$order(^DHCCARDPATREGCONFIG(RowID))
	while(RowID '="")
	{
		set Returnvalue=RowID_"^"_$get(^DHCCARDPATREGCONFIG(RowID))
		set RowID=$order(^DHCCARDPATREGCONFIG(RowID))
	}
	quit Returnvalue
}

Storage Default
{
<Data name="CardPATRegConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.Reg4E3.CardPATRegCo5D3D</DataLocation>
<DefaultData>CardPATRegConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.Reg4E3.CardPATRegCo5D3D</IdLocation>
<IndexLocation>^CHSSWeb.Reg4E3.CardPATRegCo5D3I</IndexLocation>
<StreamLocation>^CHSSWeb.Reg4E3.CardPATRegCo5D3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
