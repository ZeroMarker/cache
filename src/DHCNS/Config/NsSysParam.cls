/// Creator:2020-08-15
/// Desctiptions:敏感指标系统参数接口类
/// Date:2020-06-22
Class DHCNS.Config.NsSysParam Extends %RegisteredObject
{

Property rw As %String;

Property DayStTime As %String;

Property DayEndTime As %String;

/// E:ext，V:vue版本，W:vue4.1
Property NurMgInter As %String;

/// E:ext,A:新产品组
Property AdvInter As %String;

/// D:东华,O:第三方
Property InfInter As %String;

/// 护管第三方Server
Property NurMgOtherSever As %String;

/// 第三方护管Port
Property NurMgOtherPort As %String;

/// 第三方护管Url
Property NurMgOtherUrl As %String;

Method %OnNew(rw) As %Status [ Private, ServerOnly = 1 ]
{
	Set ..rw = rw
	if rw=""{
		Quit $$$OK	
	}
	i $LG($G(^CT.DHCINM.Set.MgArgParamSetD(1)),24)="Y" d
	.s objLB=$G(^CT.DHCINM.Set.MgArgParamSetD(rw))
	.s ..DayStTime=$LG(objLB,6)
	.s ..DayEndTime=$LG(objLB,5)
	.s ..NurMgInter=$LG(objLB,22)
	.s ..AdvInter=$LG(objLB,23)
	.s ..InfInter=$LG(objLB,26)
	.s ..NurMgOtherSever=$LG(objLB,29)
	.s ..NurMgOtherPort=$LG(objLB,30)
	.s ..NurMgOtherUrl=$LG(objLB,31)
	e  d
	.s objLB=$G(^DHCNS.Set.NsSysOutlineParamD(rw))
	.s ..DayStTime=$LG(objLB,3)
	.s ..DayEndTime=$LG(objLB,4)
	.s ..NurMgInter=$LG(objLB,5)
	.s ..AdvInter=$LG(objLB,6)
	.s ..InfInter=$LG(objLB,7)
	.s ..NurMgOtherSever=$LG(objLB,8)
	.s ..NurMgOtherPort=$LG(objLB,9)
	.s ..NurMgOtherUrl=$LG(objLB,10)
	Quit $$$OK
}

}
