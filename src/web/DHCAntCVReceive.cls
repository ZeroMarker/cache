/// 名称:     web.DHCAntCVReceive
/// 描述:     危急值平台接收外部服务类
/// 编写者：  hw
/// 编写日期: 2016-3-02
Class web.DHCAntCVReceive Extends %RegisteredObject
{

/// Creator：      hw
/// CreatDate：    2016-3-02
/// Description:： 根据危急值报告ID获取检验危机结果
/// Table：        调用检验query
/// Input：        危急值类型,危急值ID
/// Output：       检验危急值结果
/// Return：        
/// Others：      w ##class(web.DHCAntCVReceive).GetCVReportResultOfRis(1,"696||1")
ClassMethod GetCVReportResultOfRis(RType As %String, ReportId As %String)
{
	s ret="",num=0
	s VisitNumberReportDR=+ReportId
	Set rset=##class(%ResultSet).%New("DHCLIS.DHCCommon.QueryPanicResult")
	d rset.Execute(VisitNumberReportDR)
	//Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		//s Data=""
		//for i=1:1:columns {
		//Write rset.GetColumnName(i),": "
		//	s $List(Data,i)=rset.GetData(i)
		//}
		s TestCodeName=rset.GetData(1)
		s Result=rset.GetData(4)
		s Unit=rset.GetData(9)
		s Ranges=rset.GetData(10)
		s num=num+1
		i ret="" s ret=num_"、项目名称："_TestCodeName_"结果："_Result_"("_Unit_")    参考范围："_Ranges
		e  s ret=ret_"；"_num_"、项目名称："_TestCodeName_"结果："_Result_"("_Unit_")    参考范围："_Ranges
	 }
	d rset.Close()

	q ret
}

}
