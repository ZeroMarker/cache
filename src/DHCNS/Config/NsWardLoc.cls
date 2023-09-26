/// Creator:2020-08-15
/// Desctiptions:敏感指标科室接口类
/// Date:2020-06-22
Class DHCNS.Config.NsWardLoc Extends %RegisteredObject
{

Property rw As %String;

Property Desc As %String;

Method %OnNew(rw) As %Status [ Private, ServerOnly = 1 ]
{
	Set ..rw = rw
	if rw=""{
		Quit $$$OK	
	}
	i $LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),24)="Y" d
	.s objLB=$G(^CF.DHCINM.DB.MgWardLocD(rw))
	.s ..Desc=$LG(objLB,3)
	e  d
	.s objLB=$G(^DHCNS.DB.NsWardLocD(rw))
	.s ..Desc=$LG(objLB,3)
	Quit $$$OK
}

}
