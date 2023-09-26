/// 标准值 版本信息
/// s ds=##class(DHCWL.CheckFun.CheckFunVersion).%New()
/// d ds.Insert()
Class DHCWL.CheckFun.CheckFunVersion Extends DHCWL.VerManagement.VerData
{

Parameter VMDName = "标准值";

Parameter VMDCode = "V1.0.0";

Parameter VMDTSName = "董晶晶(ans)";

Parameter VMDUpDate = "2016-01-31";

Parameter VMDremarks = "指标环境为4.2以及以上版本";

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
