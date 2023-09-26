Class DHCWL.DM.Init.InitAll Extends %RegisteredObject
{

// d ##class(DHCWL.DM.Init.InitAll).InitAll()

ClassMethod InitAll()
{
	d ##class(DHCWL.DM.Init.Base).InitAll()
	d ##class(DHCWL.DM.Init.Dim).InitAll()
	d ##class(DHCWL.DM.Init.MRInfo).InitAll()
}

}
