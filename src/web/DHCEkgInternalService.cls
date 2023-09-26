/// web.DHCEkgInternalService
/// For DHC internal System . 2009-6-16, Created by Rocky Lau .
/// 东华内部子系统需要使用的心电/电生理功能模块
Class web.DHCEkgInternalService Extends %RegisteredObject
{

/// Creator：      liupeng
/// CreatDate：    2009-6-16
/// Description:： 按照输入条件查询符合条件的心电图文报告 
/// Table：        
/// Input：        OrdRowId-医嘱rowid；WsUrl-心电web服务器地址，可为空
/// Output：       图文报告的链接
/// Return：       链接
/// History	2009-6-16	liupeng	创建
/// 		2009-6-17	liupeng	增加注释
ClassMethod GetEKGReportImg(OrdRowId As %String, WsUrl As %String) As %String
{
	//w ##class(web.DHCEkgInternalService).GetEKGReportImg("13||9","")
	Set newobj = ##class(web.DHCEkgCISServiceSoap).%New()
	s url=""
	if (WsUrl="")
	{
		s url=newobj.LOCATIONADRESS
	}else
	{
		s url=WsUrl
	}
	s rtn=newobj.GetEKGReportImgLink(url,OrdRowId)
	
	s newobj=""
	k newobj
	Quit rtn
}

/// Creator：      王任重
/// CreatDate：    2009-6-17
/// OEORIID:OEORDItem的RowID
/// ReportUser:报告医生
/// AuditUser:审核医生
/// ClinicInfo:临床诊断
/// ExamDesc:检查所见
/// ExamResult:诊断意见
/// History	2009-6-16	wangrenzhong	创建
/// 		2009-6-17	wangrenzhong封装，liupeng增加注释
ClassMethod UpdatePEResult(OEORIID, ReportUser, AuditUser, ClinicInfo, ExamDesc, ExamResult)
{
	q $zobjclassmethod("web.DHCPE.CRM.Gateway","UpdatePEResult",OEORIID, ReportUser, AuditUser, ClinicInfo, ExamDesc, ExamResult)
}

Storage Default
{
<Data name="DHCEkgInternalServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEkgInternalServiceD</DataLocation>
<DefaultData>DHCEkgInternalServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCEkgInternalServiceD</IdLocation>
<IndexLocation>^web.DHCEkgInternalServiceI</IndexLocation>
<StreamLocation>^web.DHCEkgInternalServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
