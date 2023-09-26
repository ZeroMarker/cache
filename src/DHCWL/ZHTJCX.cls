Class DHCWL.ZHTJCX Extends %SOAP.WebService
{

Parameter NAMESPACE = "http://tempuri.org";

Parameter SERVICENAME = "ZHTJCX";

/// Creator：      付贺亮<br>
/// CreatDate：    2009-05-12<br>
/// description:   取得指定时间间隔内的住院或者门诊的数据汇总信息<br>
/// Table：        DHCWorkLoad  <br>
/// Input：        BeginDate(检索数据范围的开始日期),EndDate(检索数据范围的结束日期),IoFlag(住院与门诊标志 I:住院 O:门诊),Scope(检索的科室范围 空为所有科室)<br>
/// Output：       门诊(门诊总收入、门诊人次、诊次收入) 住院(住院收入、实际占用床日、床日收入、出院患者平均住院天数、病床使用率(%))<br>
/// Return：       0 调用正常  1 调用失败 
ClassMethod GetDataSumary(BeginDate, EndDate, IoFlag, Scope, SessionId) As %Integer [ WebMethod ]
{
	j ##class(%ResultSet).RunQuery("DHCWL.Query","GetDataSumary",BeginDate, EndDate, IoFlag, Scope,SessionId_"S")	
	q 0
}

/// Creator：      付贺亮<br>
/// CreatDate：    2009-05-13<br>
/// description:   取得指定时间间隔内的住院或者门诊的数据二级信息（按科室分）<br>
/// Table：        DHCWorkLoad  <br>
/// Input：        BeginDate(检索数据范围的开始日期),EndDate(检索数据范围的结束日期),DataPartId(1：门诊总收入 2：门诊人次 3：诊次收入 4：住院收入 5:实际占用床日 6：床日收入 7：病床使用率),Scope(检索的科室范围 空为所有科室)<br>
/// Return：       0 调用正常  1 调用失败 <br>
ClassMethod GetDataDetails(BeginDate, EndDate, DataPartId, Scope, SessionId) As %Integer [ WebMethod ]
{
	j ##class(%ResultSet).RunQuery("DHCWL.Query","GetDataDetails",BeginDate, EndDate, DataPartId, Scope,SessionId_"D")
	q 0
}

/*
ClassMethod GetRequestStatus(SessionId, Type) As %Integer [ WebMethod ]
{
	
	q:$d(^TEMPQuery(SessionId_Type)) 0
	q:'$d(^TEMPQuery(SessionId_Type)) 1
	q 2
}
*/
/// Creator：      付贺亮<br>
/// CreatDate：    2009-05-14<br>
/// description:   取得WebService状态<br>
/// Table：        DHCWorkLoad  <br>
/// Input：        SessionId(进程号)Type(S:汇总数据 D：明细数据)<br>
/// Return：       0：调用完成  1：调用中  2：出错 
/// Creator：      付贺亮<br>
/// CreatDate：    2009-05-14<br>
/// description:   到指定的Global里取住院或者门诊的数据汇总信息<br>
/// Table：        DHCWorkLoad  <br>
/// Input：        SessionId(进程号)<br>
/// Output：       门诊(门诊总收入、门诊人次、诊次收入) 住院(住院收入、实际占用床日、床日收入、出院患者平均住院天数、病床使用率(%))<br>
/// Return：       %XML.DataSet 
ClassMethod GetDataSumaryDataset(SessionId) As %XML.DataSet [ WebMethod ]
{
	s myds=##class(DHCWL.DataSumaryDataSet).%New()
	d myds.SetArgs(SessionId_"S")
	q myds
}

/// Creator：      付贺亮<br>
/// CreatDate：    2009-05-14<br>
/// description:   到指定global里取住院或者门诊的数据二级信息（按科室分）<br>
/// Table：        DHCWorkLoad  <br>
/// Input：        SessionId(进程号)<br>
/// Return：       %XML.DataSet <br>
ClassMethod GetDataDetailsDataset(SessionId) As %XML.DataSet [ WebMethod ]
{
	s myds=##class(DHCWL.DataDetailsDataSet).%New()
	d myds.SetArgs(SessionId_"D")
	q myds
}

}
