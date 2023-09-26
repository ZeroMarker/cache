Class DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.Contex Extends %RegisteredObject
{

Property mStratergy As DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.GetGlobal;

Method GetGlobal(Para As %String)
{
	q ..mStratergy.GetGlobal(Para)
}

Method %OnNew(Stratergy As DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.GetGlobal) As %Status [ Private, ServerOnly = 1 ]
{
	s ..mStratergy=Stratergy
	Quit $$$OK
}

}
