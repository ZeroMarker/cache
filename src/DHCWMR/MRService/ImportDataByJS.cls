/// creator    :shp
/// date       :20151010
/// description:通过JS导入基础数据
Class DHCWMR.MRService.ImportDataByJS Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// creator    : shp
/// date       : 20151010
/// description: 通过JS导入住院病案首页错误代码
/// table      ：DHCWMR.MR.FPErrCode
ClassMethod ImportErrCode(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=""
	Quit:aInputStr="" return
	
	Set Code=$p(aInputStr,"^",1)
	Set Desc=$p(aInputStr,"^",2)
	Quit:(Code="")||(Desc="") return
	
	Set ID=$o(^DHCWMR.MR.FPErrCodeI("IndexCode"," "_$zcvt(Code,"U"),0))
	
	Set InputStr=ID_"^"_Code_"^"_Desc
	Set return=##Class(DHCWMR.MR.FPErrCode).Update(InputStr,"^")
	Quit return
}

/// creator    : shp
/// date       : 20151010
/// description: 通过JS导入住院病案首页错误代码
/// table      ：DHCWMR.MR.FPErrCode
ClassMethod ImportVersion(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=""
	Quit:aInputStr="" return
	
	Set Code=$p(aInputStr,"^",1)
	Set Desc=$p(aInputStr,"^",2)
	Quit:(Code="")||(Desc="") return
	
	Set ID=$o(^DHCWMR.MR.FPVersionI("IndexCode"," "_$zcvt(Code,"U"),0))
	
	Set InputStr=ID_"^"_Code_"^"_Desc
	Set return=##Class(DHCWMR.MR.FPVersion).Update(InputStr,"^")
	Quit return
}

ClassMethod ImportVersionData(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set Code=$p(aInputStr,"^",1)
	Set Desc=$p(aInputStr,"^",2)
	Set Type=$p(aInputStr,"^",3)
	Set Range=$p(aInputStr,"^",4)
	Set Resume=$p(aInputStr,"^",5)
	Set VersionCode=$p(aInputStr,"^",6)
	Set Num=$p(aInputStr,"^",7)
	Quit:(Code="")||(Desc="")||(Type="")||(VersionCode="")||(Num="") return
	
	Set Parref=$o(^DHCWMR.MR.FPVersionI("IndexCode"," "_$zcvt(VersionCode,"U"),0))
	Quit:Parref="" return
	
	Set ChildSub=$o(^DHCWMR.MR.FPVersionI("DATA","IndexCode",Parref," "_$zcvt(Code,"U"),0))
	
	Set InputStr=Parref_"^"_ChildSub_"^"_Code_"^"_Desc_"^"_Type_"^"_Range_"^"_Resume_"^"_Num
	set ^tempshp("mr")=InputStr
	Set return=##Class(DHCWMR.MR.FPVersionData).Update(InputStr,"^")
	Quit return
}

}
