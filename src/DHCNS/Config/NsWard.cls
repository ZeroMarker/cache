/// Creator:2020-08-15
/// Desctiptions:敏感指标病区接口类
/// Date:2020-06-22
Class DHCNS.Config.NsWard Extends %RegisteredObject
{

Property rw As %String;

Property CTLocDR As %String;

Property StDate As %String;

Property EndDate As %String;

Property Desc As %String;

Property IsWard As %String;

Property ClassDesc As %String;

Property WardMGCode As %String;

Method %OnNew(rw) As %Status [ Private, ServerOnly = 1 ]
{
	Set ..rw = rw
	if rw=""{
		Quit $$$OK	
	}
	i $LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),24)="Y" d
	.s objLB=$G(^CF.DHCINM.DB.MgWardD(rw))
	.s ..CTLocDR=$LG(objLB,2)
	.s ..StDate=$LG(objLB,11)
	.s ..EndDate=$LG(objLB,12)
	.s ..Desc=$LG(objLB,4)
	.s ..WardMGCode=$LG(objLB,3)
	.s wardClass=$LG(objLB,5),wardClassDesc=""
	.i wardClass'="" d
	..s wardClassDesc=$LG($g(^CT.DHCINM.Set.MgSysParamSubD($P(wardClass,"||",1),$P(wardClass,"||",2))),3)
	..s:wardClassDesc["病区" ..IsWard=1
	.s ..ClassDesc=wardClassDesc
	e  d
	.s objLB=$G(^DHCNS.DB.NsWardD(rw))
	.s ..CTLocDR=$LG(objLB,2)
	.s ..StDate=$LG(objLB,10)
	.s ..EndDate=$LG(objLB,11)
	.s ..Desc=$LG(objLB,4)
	.s ..WardMGCode=$LG(objLB,15)
	.s wardClass=$LG(objLB,5),wardClassDesc=""
	.i wardClass'="" d
	..s wardClassDesc=$LG($g(^DHCNS.Set.NsSysParamSubD($P(wardClass,"||",1),$P(wardClass,"||",2))),3)
	..s:wardClassDesc["病区" ..IsWard=1
	.s ..ClassDesc=wardClassDesc
	Quit $$$OK
}

}
