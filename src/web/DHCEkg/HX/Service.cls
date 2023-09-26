/// web.DHCEkg.HX.Service
/// 华西项目，接口转为xml格式，提供给集成平台调用
Class web.DHCEkg.HX.Service Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "Service";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// 方法说明：	查询HIS医嘱信息
/// 创建者：	yyl
/// 创建时间：	2018-10-19
/// 入参：		xml流，包括科室ID，登记号，开始日期，结束日期
/// 返回值：	医嘱信息的xml流
/// s param=##class(%GlobalCharacterStream).%New()
/// d param.Write("")
/// w ##class(web.DHCEkg.HX.Service).GetEKGInfoTxtXml(param)
ClassMethod GetEKGInfoTxtXml(paramInfo As %GlobalCharacterStream) As %String [ WebMethod ]
{
	new $namespace
	s ^tmpDHCEKG("GetEKGInfoTxtXml",$zd($h,3),$p($zdt($h,3)," ",2),"param")=paramInfo.Read()
	s reader1=##class(%XML.Reader).%New()
	s sc1=reader1.OpenStream(paramInfo)
	d reader1.Correlate("GetEKGInfoTxt","web.DHCEkg.HX.Dict.GetEKGInfoTxt")
	s (CtLocId,RegNo,StartDate,Enddate)=""
	while reader1.Next(.obj,.sc)
	{
		b ;obj
		s CtLocId=obj.CtLocId
		s RegNo=obj.RegNo
		s StartDate=obj.StartDate
		s Enddate=obj.Enddate
	}
	b ; w CtLocId_"^"_RegNo_"^"_StartDate_"^"_Enddate
	q:(CtLocId="")!(RegNo="")!(StartDate="")!(Enddate="") ""
	
	s rtnInfo=""
	s rtnInfo=##class(web.DHCEkgService).GetEKGInfoTxt(CtLocId,RegNo,StartDate,Enddate)
	if rtnInfo[$c(0) set rtnInfo=$translate(rtnInfo,$c(0),"")
	
	s ordList=##class(web.DHCEkg.HX.Dict.OrdInfoList).%New()
	f ordCount=1:1:$length(rtnInfo,"$") d
	.s ordStr=$p(rtnInfo,"$",ordCount)
	.q:(ordStr="")
	.s ordInfo=##class(web.DHCEkg.HX.Dict.OrdInfo).%New()
	.s ordInfo.AdmType=$p(ordStr,"^",1)
	.s ordInfo.RegNo=$p(ordStr,"^",2)
	.s ordInfo.Name=$p(ordStr,"^",4)
	.s ordInfo.Sex=$p(ordStr,"^",5)
	.s ordInfo.Age=$p(ordStr,"^",6)
	.s ordInfo.BirthDay=$p(ordStr,"^",7)
	.s ordInfo.OrdName=$p(ordStr,"^",8)
	.s ordInfo.ClinicDiagnose=$p(ordStr,"^",14)
	.s ordInfo.OrdDoctor=$p(ordStr,"^",15)
	.s ordInfo.OrdLoc=$p(ordStr,"^",16)
	.s ordInfo.OrdDate=$p(ordStr,"^",31)
	.s ordInfo.OrdTime=$p(ordStr,"^",32)
	.s ordInfo.MedNo=$p(ordStr,"^",53)
	.s ordInfo.Ward=$p(ordStr,"^",40)
	.s ordInfo.Room=$p(ordStr,"^",41)
	.s ordInfo.BedNo=$p(ordStr,"^",42)
	.s ordInfo.FeeType=$p(ordStr,"^",43)
	.s ordInfo.OrdBillStatus=$p(ordStr,"^",45)
	.s ordInfo.OrdRowID=$p(ordStr,"^",49)
	.s ordInfo.Telephone=$p(ordStr,"^",57)
	.s ordInfo.ItemStatusCode=$p(ordStr,"^",62)
	.d ordList.OrdInfoList.Insert(ordInfo)
	
	s rtnXmlStream=##class(%GlobalCharacterStream).%New()
	
	s Status=ordList.XMLExportToStream(.stream)						
	d rtnXmlStream.MoveToEnd()
	d rtnXmlStream.CopyFrom(stream)
	s ^tmpDHCEKG("GetEKGInfoTxtXml",$zd($h,3),$p($zdt($h,3)," ",2),"rtn")=rtnXmlStream.Read()
	b ; d rtnXmlStream.OutputToDevice()
	q rtnXmlStream
}

/// 方法说明：	改变医嘱状态，若值为E，则把医嘱改为执行状态；若值为V，则把医嘱改为核实状态
/// 创建者：	yyl
/// 创建时间：	2018-10-19
/// 入参：		xml流，包括医嘱号，医嘱执行状态标志
/// 返回值：	调用结果的xml流
/// s param=##class(%GlobalCharacterStream).%New()
/// d param.Write("")
/// w ##class(web.DHCEkg.HX.Service).UpdataOrdInfo(param)
ClassMethod UpdataOrdInfo(paramInfo As %GlobalCharacterStream) As %String [ WebMethod ]
{
	new $namespace
	s ^tmpDHCEKG("UpdataOrdInfo",$zd($h,3),$p($zdt($h,3)," ",2),"param")=paramInfo.Read()
	s reader1=##class(%XML.Reader).%New()
	s sc1=reader1.OpenStream(paramInfo)
	d reader1.Correlate("UpdataOrdInfo","web.DHCEkg.HX.Dict.UpdataOrdInfo")
	s (OrdRowID,OrderStatus)=""
	while reader1.Next(.obj,.sc)
	{
		b ;obj
		s OrdRowID=obj.OrdRowID
		s OrderStatus=obj.OrderStatus
	}
	b ; w OrdRowID_"^"_OrderStatus
	q:(OrdRowID="")!(OrderStatus="") ""
	s rtnUpdata=""
	s rtnUpdata=##class(web.DHCEkgService).UpdataOrdInfo(OrdRowID,"", OrderStatus,"","")
	
	s rtnXmlObj=##class(web.DHCEkg.HX.Dict.Response).%New()
	s rtnXmlObj.ResultCode=rtnUpdata
	i (rtnUpdata="0") s rtnXmlObj.ResultContent= "成功"
	e  s rtnXmlObj.ResultContent= "失败"
	
	s rtnXmlStream=##class(%GlobalCharacterStream).%New()
	
	s Status=rtnXmlObj.XMLExportToStream(.stream)						
	d rtnXmlStream.MoveToEnd()
	d rtnXmlStream.CopyFrom(stream)
	s ^tmpDHCEKG("UpdataOrdInfo",$zd($h,3),$p($zdt($h,3)," ",2),"rtn")=rtnXmlStream.Read()
	b ; d rtnXmlStream.OutputToDevice()
	q rtnXmlStream
}

/// 方法说明：	发布报告时，回传诊断结论
/// 创建者：	yyl
/// 创建时间：	2018-10-19
/// 入参：		xml流，包括医嘱号，就诊类别，审核医生工号，诊断结论，诊断意见
/// 返回值：	调用结果的xml流
/// s param=##class(%GlobalCharacterStream).%New()
/// d param.Write("")
/// w ##class(web.DHCEkg.HX.Service).UpdataRptInfo(param)
ClassMethod UpdataRptInfo(paramInfo As %GlobalCharacterStream) As %String [ WebMethod ]
{
	new $namespace
	s ^tmpDHCEKG("UpdataRptInfo",$zd($h,3),$p($zdt($h,3)," ",2),"param")=paramInfo.Read()
	s reader1=##class(%XML.Reader).%New()
	s sc1=reader1.OpenStream(paramInfo)
	d reader1.Correlate("UpdataRptInfo","web.DHCEkg.HX.Dict.UpdataRptInfo")
	s (OrdRowID,AdmType,ArbiterUser,DiagInfo,ExtInfo)=""
	while reader1.Next(.obj,.sc)
	{
		b ;obj
		s OrdRowID=obj.OrdRowID
		s AdmType=obj.AdmType
		s ArbiterUser=obj.ArbiterUser
		s DiagInfo=obj.DiagInfo
		s ExtInfo=obj.ExtInfo
	}
	b ; w OrdRowID
	q:(OrdRowID="") ""
	s rtnUpdata=""
	s rtnUpdata= ##class(web.DHCPE.CRM.Gateway).UpdatePEResult(OrdRowID, ArbiterUser,ArbiterUser, "",DiagInfo,ExtInfo,"")

	s rtnXmlObj=##class(web.DHCEkg.HX.Dict.Response).%New()
	s rtnXmlObj.ResultCode=rtnUpdata
	i (rtnUpdata="0") s rtnXmlObj.ResultContent= "成功"
	e  s rtnXmlObj.ResultContent= "失败"
	
	s rtnXmlStream=##class(%GlobalCharacterStream).%New()
	
	s Status=rtnXmlObj.XMLExportToStream(.stream)						
	d rtnXmlStream.MoveToEnd()
	d rtnXmlStream.CopyFrom(stream)
	s ^tmpDHCEKG("UpdataRptInfo",$zd($h,3),$p($zdt($h,3)," ",2),"rtn")=rtnXmlStream.Read()
	b ; d rtnXmlStream.OutputToDevice()
	q rtnXmlStream
}

/// 方法说明：	获取HIS科室信息
/// 创建者：	yyl
/// 创建时间：	2018-10-19
/// 入参：		
/// 返回值：	科室信息的xml流
/// w ##class(web.DHCEkg.HX.Service).EKGGetDeptListXML()
ClassMethod EKGGetDeptListXML() As %String [ WebMethod ]
{
	new $namespace
	s ^tmpDHCEKG("EKGGetDeptListXML",$zd($h,3),$p($zdt($h,3)," ",2),"param")=""
	
	s rtnInfo=""
	s rtnInfo=##class(web.DHCEkgService).GetCTLOCList()
	
	
	s deptList=##class(web.DHCEkg.HX.Dict.DeptList).%New()
	f deptCount=1:1:$length(rtnInfo,"$") d
	.s deptStr=$p(rtnInfo,"$",deptCount)
	.q:(deptStr="")
	.s deptInfo=##class(web.DHCEkg.HX.Dict.Dept).%New()
	.s deptInfo.Id=$p(deptStr,"^",1)
	.s deptInfo.Spell=$p(deptStr,"^",2)
	.s deptInfo.Name=$p(deptStr,"^",3)
	.d deptList.DeptList.Insert(deptInfo)
		
	s rtnXmlStream=##class(%GlobalCharacterStream).%New()
	
	s Status=deptList.XMLExportToStream(.stream)						
	d rtnXmlStream.MoveToEnd()
	d rtnXmlStream.CopyFrom(stream)
	s ^tmpDHCEKG("EKGGetDeptListXML",$zd($h,3),$p($zdt($h,3)," ",2),"rtn")=rtnXmlStream.Read()
	b ; d rtnXmlStream.OutputToDevice()
	q rtnXmlStream
}

/// 方法说明：	登录his用户
/// 创建者：	yyl
/// 创建时间：	2018-10-19
/// 入参：		xml流，包括用户工号和密码
/// 返回值：	调用结果的xml流
/// s param=##class(%GlobalCharacterStream).%New()
/// d param.Write("")
/// w ##class(web.DHCEkg.HX.Service).UserAuthenticate(param)
ClassMethod UserAuthenticate(paramInfo As %GlobalCharacterStream) As %String [ WebMethod ]
{
	new $namespace
	s ^tmpDHCEKG("UserAuthenticate",$zd($h,3),$p($zdt($h,3)," ",2),"param")=paramInfo.Read()
	s reader1=##class(%XML.Reader).%New()
	s sc1=reader1.OpenStream(paramInfo)
	d reader1.Correlate("UserAuthenticate","web.DHCEkg.HX.Dict.UserAuthenticate")
	s (User,Password)=""
	while reader1.Next(.obj,.sc)
	{
		b ;obj
		s User=obj.User
		s Password=obj.Password
	}
	b ; w User_"^"_Password
	q:(User="")!(Password="") ""
	s rtnLogon=""
	s rtnLogon=##class(web.DHCEkgService).UserLogon(User,Password)
	
	s rtnXmlObj=##class(web.DHCEkg.HX.Dict.LogonResponse).%New()
	
	i (rtnLogon'="") d
	.s rtnXmlObj.RowId=$p(rtnLogon,"^",1)
	.s rtnXmlObj.SSUSRInitials=$p(rtnLogon,"^",2)
	.s rtnXmlObj.Name=$p(rtnLogon,"^",3)
	.s rtnXmlObj.DeptDR=$p(rtnLogon,"^",4)
	.s rtnXmlObj.code=$p(rtnLogon,"^",5)
	
	s rtnXmlStream=##class(%GlobalCharacterStream).%New()
	
	s Status=rtnXmlObj.XMLExportToStream(.stream)						
	d rtnXmlStream.MoveToEnd()
	d rtnXmlStream.CopyFrom(stream)
	s ^tmpDHCEKG("UserAuthenticate",$zd($h,3),$p($zdt($h,3)," ",2),"rtn")=rtnXmlStream.Read()
	b ; d rtnXmlStream.OutputToDevice()
	q rtnXmlStream
}

/// 方法说明：	根据卡号获取登记号
/// 创建者：	yyl
/// 创建时间：	2018-10-19
/// 入参：		xml流，卡号
/// 返回值：	登记号的xml流
/// s param=##class(%GlobalCharacterStream).%New()
/// d param.Write("")
/// w ##class(web.DHCEkg.HX.Service).GetEKGRegNoByCardNo(param)
ClassMethod GetEKGRegNoByCardNo(paramInfo As %GlobalCharacterStream) As %String [ WebMethod ]
{
	new $namespace
	s ^tmpDHCEKG("GetEKGRegNoByCardNo",$zd($h,3),$p($zdt($h,3)," ",2),"param")=paramInfo.Read()
	s reader1=##class(%XML.Reader).%New()
	s sc1=reader1.OpenStream(paramInfo)
	d reader1.Correlate("GetEKGRegNoByCardNo","web.DHCEkg.HX.Dict.GetEKGRegNoByCardNo")
	s CardNo=""
	while reader1.Next(.obj,.sc)
	{
		b ;obj
		s CardNo=obj.CardNo
	}
	b ; w CardNo
	q:(CardNo="") ""
	
	s CardNoLength = +##class(web.DHCEkgNo).getCardNoLength() //卡号长度
	
	s rtnRegNo=""
	s CardNo=##class(web.DHCEkgNo).getFullNo(CardNo,CardNoLength) //位数补齐
	s rtnRegNo= ##class(web.DHCEkgNo).getRegNoByCardNo(CardNo)
	;s rtn=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNo,"",""_$c(2)_"16"_$c(2)_"PatInfo")
	
	s rtn="^^^^^^^^"_rtnRegNo
	i (rtnRegNo="") s rtn="-200"_rtn
	s rtnXmlObj=##class(web.DHCEkg.HX.Dict.PatInfo).%New()
	s rtnXmlObj.PatInfo=rtn
	
	s rtnXmlStream=##class(%GlobalCharacterStream).%New()
	
	s Status=rtnXmlObj.XMLExportToStream(.stream)						
	d rtnXmlStream.MoveToEnd()
	d rtnXmlStream.CopyFrom(stream)
	s ^tmpDHCEKG("GetEKGRegNoByCardNo",$zd($h,3),$p($zdt($h,3)," ",2),"rtn")=rtnXmlStream.Read()
	b ; d rtnXmlStream.OutputToDevice()
	q rtnXmlStream
}

/// 方法说明：	检查结束，回传检查状态
/// 创建者：	yyl
/// 创建时间：	2020-11-12
/// 入参：		
/// <param name="OrdId">医嘱ID</param>
/// <param name="ExamId">流水号</param>
/// <param name="Date">日期[yyyy-MM-dd]</param>
/// <param name="Time">时间[HH:mm:SS]</param>
/// <param name="UserCode">用户工号</param>
/// <param name="UserName">用户姓名</param>
/// 返回值：	
/// w ##class(web.DHCEkg.HX.Service).ExamFinished()
ClassMethod ExamFinished(OrdId As %String, ExamId As %String, Date As %String, Time As %String, UserCode As %String, UserName As %String) As %String [ WebMethod ]
{
}

/// 方法说明：	发布报告，回传检查状态，回传报告
/// 创建者：	yyl
/// 创建时间：	2020-11-12
/// 入参：		
/// <param name="OrdId">医嘱ID</param>
/// <param name="ExamId">流水号</param>
/// <param name="Date">日期[yyyy-MM-dd]</param>
/// <param name="Time">时间[HH:mm:SS]</param>
/// <param name="UserCode">用户工号</param>
/// <param name="UserName">用户姓名</param>
/// 返回值：	
/// w ##class(web.DHCEkg.HX.Service).SendReport()
ClassMethod SendReport(OrdId As %String, ExamId As %String, Date As %String, Time As %String, UserCode As %String, UserName As %String) As %String [ WebMethod ]
{
}

/// 方法说明：	发布报告，回传检查状态，回传报告
/// 创建者：	yyl
/// 创建时间：	2020-11-12
/// 入参：		
/// <param name="OrdId">医嘱ID</param>
/// <param name="ExamId">流水号</param>
/// <param name="Date">日期[yyyy-MM-dd]</param>
/// <param name="Time">时间[HH:mm:SS]</param>
/// <param name="UserCode">用户工号</param>
/// <param name="UserName">用户姓名</param>
/// <param name="Diagnose">诊断结论</param>
/// 返回值：	
/// w ##class(web.DHCEkg.HX.Service).SendEmergency()
ClassMethod SendEmergency(OrdId As %String, ExamId As %String, Date As %String, Time As %String, UserCode As %String, UserName As %String, Diagnose As %String(MAXLEN=32767)) As %String [ WebMethod ]
{
}

}
