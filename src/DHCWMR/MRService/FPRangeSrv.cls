/// 名称: DHCWMR.MRService.FPRangeSrv
/// 描述: 住院病案首页值域服务
/// 编写者：zhufei
/// 编写日期: 2015-08-27
Class DHCWMR.MRService.FPRangeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ImportRange(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=""
	Quit:aInputStr="" return
	
	Set Code=$p(aInputStr,"^",1)
	Set Desc=$p(aInputStr,"^",2)
	Quit:(Code="")||(Desc="") return
	
	Set ID=$o(^DHCWMR.MR.FPRangeI("IndexCode"," "_$zcvt(Code,"U"),0))
	
	Set InputStr=ID_"^"_Code_"^"_Desc
	Set return=##Class(DHCWMR.MR.FPRange).Update(InputStr,"^")
	Quit return
}

ClassMethod ImportRangeData(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set RangeCode=$p(aInputStr,"^",1)
	Set RangeDesc=$p(aInputStr,"^",2)
	Set Code=$p(aInputStr,"^",3)
	Set Desc=$p(aInputStr,"^",4)
	Set HospID=+$p(aInputStr,"^",5)
	Quit:(RangeCode="")||(Code="")||(Desc="") return
	
	Set Parref=$o(^DHCWMR.MR.FPRangeI("IndexCode"," "_$zcvt(RangeCode,"U"),0))
	If Parref="" {
		Set InputStr=Parref_"^"_Code_"^"_Desc
		Set Parref=##Class(DHCWMR.MR.FPRange).Update(InputStr,"^")
		Quit:+Parref<0 return
	}
	
	Set ChildSub=$o(^DHCWMR.MR.FPRangeI("DATA","IndexCode",Parref,HospID," "_$zcvt(Code,"U"),0))
	
	Set InputStr=Parref_"^"_ChildSub_"^"_Code_"^"_Desc_"^"_HospID
	Set return=##Class(DHCWMR.MR.FPRangeData).Update(InputStr,"^")
	Quit return
}

/// creator   :SHP
/// date      :20151008
/// obj       ：操作对象表【DHCWMR.MR.FPRangeData】
/// description :病案首页中取得描述，
/// debug     :w ##class(DHCWMR.MRService.FPRangeSrv).GetDescByCode("RC002002",2)
///             w ##class(DHCWMR.MRService.FPRangeSrv).GetDescByCode("RC003002",2)
ClassMethod GetDescByCode(RCode, RDCode)
{
	n (RCode,RDCode)
	s par="",RDDesc=""
	for{
		s par=$o(^DHCWMR.MR.FPRangeI("IndexCode"," "_RCode,par))
		q:par=""
		s chl=""
		for {
			s chl=$o(^DHCWMR.MR.FPRangeI("DATA","IndexCode",par,0," "_RDCode,chl))
			q:chl=""
			s RDDesc=$list(^DHCWMR.MR.FPRangeD(par,"DATA",chl),3)
			}
		}
	Q RDDesc
}

}
