Class EMRservice.Tools.BaseData.Config Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter ParamVersions = "1200,1300,1400,1500,1600,1620,1630,1640,1650,1660,1700,1710,1720,1730,1740,1750,1760,1770";

/// d ##Class(EMRservice.Tools.BaseData.Config).Main()
ClassMethod Main()
{
	s version = ""
	w "初始化基础数据,以版本包为单位",!
	w "注意:系统参数仅初始化默认值,各项目需根据情况,修改默认值",!
	r "是否继续: 是(y) 否(n) ",flag
	q:($zcvt(flag,"U") = "N")
	w !
	r "请输入初始化版本号(如：1.2.0.0 或 1.2.0.0-1.3.0.0): ", version
	s version = $REPLACE(version,".","")
	s doList = ##Class(%ListOfDataTypes).%New()
	if ((version [ "-")>0)
	{
		s tmpStart = $p(version,"-",1)
		s tmpEnd = $p(version,"-",2)
		for j=1:1:$l(..#ParamVersions,",")
		{
			s tmpParam = $p(..#ParamVersions,",",j)
			if ((tmpParam >= tmpStart)&&(tmpParam <= tmpEnd))
			{
				d doList.Insert("V"_tmpParam)
			}
		}
	}
	else
	{
		d:(..#ParamVersions [ version) doList.Insert("V"_version)
	}
	d ##Class(EMRservice.Tools.BaseData.EMR).Main(doList)
}

}
