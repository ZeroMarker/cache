/// Description:手术数据导出接口
/// Creator：谷雪萍
/// CreatDate: 2020-03-31
Class web.DHCBL.MKB.MKBOperationExportInfo Extends %RegisteredObject
{

/// Creator：谷雪萍
/// CreatDate: 2020-03-31
/// Description:后台读取query数据，导出手术申请数据
/// Input： startdate-开始日期，enddate-结束日期
/// Return: 返回导出Excel的维护
/// w ##class(web.DHCBL.MKB.MKBOperationExportInfo).ReadQuery("2018-01-01","2019-12-31")
ClassMethod ReadQuery(startdate As %String, enddate As %String)
{
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1)
	s PathDir=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"
	s ifExistsDir=##class(%File).DirectoryExists(PathDir)
	if ifExistsDir'=1
	{
		d ##class(%File).CreateDirectory("D:\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\")
	}
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\手术申请数据从"_startdate_"到"_enddate_".csv"
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.Write("序号,"_"开始日期,"_"结束日期,"_"申请日期,"_"科室,"_"诊断,"_"手术编码,"_"手术名称,"_"部位,"_"级别,"_"切口,"_"器械")
	d file.WriteLine()
	
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCANCom"
	set rs.QueryName="GetAnOpList"
	set sc=rs.Execute(startdate,enddate)  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	while rs.%Next() 
	{ 		
		d file.Write(rs.Data("ind")_",")
		d file.Write(rs.Data("opStdatestr")_",")
		d file.Write(rs.Data("opEndDatestr")_",")
		d file.Write(rs.Data("OpAppDateStr")_",")
		d file.Write(rs.Data("locdes")_",")
		s diag=##class(web.BDP.util.String).Replace(rs.Data("diag"),",","，")
		d file.Write(diag_",")
		d file.Write(rs.Data("OpNamecode")_",")
		s opdes=##class(web.BDP.util.String).Replace(rs.Data("opdes"),",","，")
		d file.Write(opdes_",")
		s bodsDesc=##class(web.BDP.util.String).Replace(rs.Data("bodsDesc"),",","，")
		d file.Write(bodsDesc_",")
		d file.Write(rs.Data("OPCategory")_",")
		d file.Write(rs.Data("BladeTypeDesc")_",")
		d file.Write(rs.Data("operInstrument"))
		d file.WriteLine()
	}
	d file.%Save()
	d file.%Close()
	q P
}

}
