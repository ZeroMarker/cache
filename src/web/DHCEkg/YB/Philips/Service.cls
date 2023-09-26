/// web.DHCEkg.YB.Philips.Service
/// Creator：		yangyali
/// CreatDate：		2020-12-9
/// Description:	提供给飞利浦查询医嘱
Class web.DHCEkg.YB.Philips.Service Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "Service";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// 默认的医嘱接收科室ID
Parameter LocId = 85;

/// Creator：		yangyali
/// CreatDate：		2020-12-9
/// Description:	按照输入条件查询符合条件的医嘱记录
/// Table：        
/// Input：			登记号；起始日期；终止日期
/// Output：       
/// Return：		xml格式的医嘱信息
/// w ##class(web.DHCEkg.YB.Philips.Service).GetEKGInfo("<root><LocId>85</LocId><RegNo>0000000021</RegNo><StartDate>2020-6-1</StartDate><Enddate>2020-12-9</Enddate></root>")
ClassMethod GetEKGInfo(paramInfo As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s rtnStream=##class(%GlobalCharacterStream).%New()
	try
	{
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkg.YB.Philips.Service","GetEKGInfo",
										$zd($h,3),$zt($p($h,",",2),1),paramInfo,"param")
		s rtnObj = ##class(web.DHCEkg.XML).New("root")
		s entityObj =##class(web.DHCEkg.XML).New("entity")
		s propertyObj =##class(web.DHCEkg.XML).New("property")
		s propertyObj.serviceName="GetEKGInfo"
		s propertyObj.orderType="NW"
		d entityObj.Insert(propertyObj)
		
		s RequestObj =##class(web.DHCEkg.XML).New("Request")
		s PatOrdListsObj=##class(web.DHCEkg.XML).New("PatOrdLists")
		try
		{
			i (paramInfo["<?xml") s paramInfo=$e(paramInfo,$l($p(paramInfo,">",1))+2,$l(paramInfo))
			s xmlData= ##class(web.DHCEkg.XML).FromXML(paramInfo)
			;zw xmlData
			;b ; 0000
			;w xmlData.LocId_"^"_xmlData.RegNo_"^"_xmlData.StartDate_"^"_xmlData.Enddate,!
			s LocId=xmlData.LocId
			s RegNo=xmlData.RegNo
			s StartDate=xmlData.StartDate
			s Enddate=xmlData.Enddate
			i (LocId="") s LocId=..#LocId
			s ordInfoStr=##class(web.DHCEkgService).GetEKGInfoTxt(LocId,RegNo_"^RegNo",StartDate,Enddate)
			i (ordInfoStr'="")
			{
				s indexOrd=1
				while(indexOrd<=$l(ordInfoStr,"$"))
				{
					try
					{
						s thisOrdInfo=$p(ordInfoStr,"$",indexOrd)
						//医嘱执行状态
						s ordStatus=$p(thisOrdInfo,"^",62) 
						i (ordStatus["核实") ;医嘱为核实状态
						{
							;b ; w thisOrdInfo
							s PatOrdListObj=##class(web.DHCEkg.XML).New("PatOrdList")
							s PatOrdListObj.RegNo=$p(thisOrdInfo,"^",2) ;病人登记号
							s PatOrdListObj.CardNo=""
							s PatOrdListObj.Name=$p(thisOrdInfo,"^",4) ;病人姓名
							s gender=$p(thisOrdInfo,"^",5) ;性别
							;病人性别代码
							s PatOrdListObj.SexCode=$CASE(gender,
													"男":"1",
													"女":"2",
													:"")  
							s PatOrdListObj.Sex=$p(thisOrdInfo,"^",5) ;性别
							s PatOrdListObj.Age=$p(thisOrdInfo,"^",6) ;年龄
							s PatOrdListObj.BirthDay=$p(thisOrdInfo,"^",7) ;出生日期
							s PatOrdListObj.Marry=""
							s PatOrdListObj.Address=""  ;病人住址
							s PatOrdListObj.Telephone=$p(thisOrdInfo,"^",57)
							s PatOrdListObj.CredentialNo=""
							s PatOrdListObj.NationCode=""
							s PatOrdListObj.Nation=""
							s PatOrdListObj.OccupationCode=""
							s PatOrdListObj.Occupation=""
							s PatOrdListObj.InsuranceNo=""
							s PatOrdListObj.DocumentID=""
							s PatOrdListObj.AdmNo=$p(thisOrdInfo,"^",48) ;就诊号
							s PatOrdListObj.AdmSerialNum=""
							s patType=$p(thisOrdInfo,"^",1)
							//就诊类型
							s PatOrdListObj.AdmType=$CASE(patType,
													"门诊病人":"O",
													"住院病人":"I",
													"体检病人":"H",
													"急诊病人":"E",
													:"") 
							s PatOrdListObj.FeeType=$p(thisOrdInfo,"^",43) ;费用类型
							s PatOrdListObj.WardCode="" ;病人所在病区代码
							s PatOrdListObj.Ward=$p(thisOrdInfo,"^",40) ;病区名称
							s PatOrdListObj.RoomCode="" ;病房号
							s PatOrdListObj.Room=""
							s PatOrdListObj.BedNo=$p(thisOrdInfo,"^",42) ;病床号
							s PatOrdListObj.ClinicDiagnose=$p(thisOrdInfo,"^",14) ;临床诊断
							s PatOrdListObj.ClinicDisease=""
							s PatOrdListObj.OperationInfo=""
							s PatOrdListObj.OtherInfo=""
							s PatOrdListObj.OrdRowID=$p(thisOrdInfo,"^",49) ;医嘱号
							s examItemInfo=$p(thisOrdInfo,"^",8) ;医嘱信息
							s PatOrdListObj.OrdName=$p(examItemInfo,"#",3) ;项目名称
							s PatOrdListObj.OrdCode=$p(examItemInfo,"#",2) ;项目代码
							s PatOrdListObj.OrdPrice=$p(thisOrdInfo,"^",30) ;项目价格
							s PatOrdListObj.OrdBillStatus=$p(thisOrdInfo,"^",45) ;计费状态
							s PatOrdListObj.OrdPriorityCode="NORM"
							s PatOrdListObj.OrdPriority="临时医嘱"
							s PatOrdListObj.Hospital=""
							s deptInfo=$p(thisOrdInfo,"^",16) ;开单科室信息
							s deptName=$p(deptInfo,"#",2)
							i (deptName["-") s deptName=$p(deptName,"-",2)
							s PatOrdListObj.OrdLocCode=$p(deptInfo,"#",1) ;开单科室code，此处取的rowid
							s PatOrdListObj.OrdLoc=deptName ;开单科室名称
							s PatOrdListObj.OrdDoctorCode=""
							s PatOrdListObj.OrdDoctor=$p(thisOrdInfo,"^",15) ;开单医生
							s PatOrdListObj.OrdDate=$p(thisOrdInfo,"^",31) ;开单日期
							s PatOrdListObj.OrdTime=$p(thisOrdInfo,"^",32) ;开单时间
							s PatOrdListObj.OrdExeLocCode="" ;执行科室
							s PatOrdListObj.OrdExeLoc="" ;执行科室
							s PatOrdListObj.Position=""
							s PatOrdListObj.Purpose=""
							
							d PatOrdListsObj.Insert(PatOrdListObj)
						}
					}
					catch sc0
					{
						b ; error sc0
						d ##class(web.DHCEkg.Base).Log("ERROR","web.DHCEkg.YB.Philips.Service","GetEKGInfo",
														$zd($h,3),$zt($p($h,",",2),1),sc0.Code_"^"_sc0.Location_"^"_sc0.Data,"sc0")

					}
					s indexOrd=indexOrd+1
				}
				d RequestObj.Insert(PatOrdListsObj)
				s RequestObj.ResultCode="0"
				s RequestObj.ResultContent="成功"
			}
			else
			{
				s RequestObj.ResultCode="1"
				s RequestObj.ResultContent="未查询到医嘱"
			}
		}
		catch sc1
		{
			b ; error sc1
			s RequestObj.ResultCode="-1"
			s RequestObj.ResultContent="接口异常"
			d ##class(web.DHCEkg.Base).Log("ERROR","web.DHCEkg.YB.Philips.Service","GetEKGInfo",
											$zd($h,3),$zt($p($h,",",2),1),sc1.Code_"^"_sc1.Location_"^"_sc1.Data,"sc1")
		}
		d entityObj.Insert(RequestObj)
		d rtnObj.Insert(entityObj)
		s xmlStr=rtnObj.ToXML()
		d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkg.YB.Philips.Service","GetEKGInfo",
										$zd($h,3),$zt($p($h,",",2),1),xmlStr,"rtn")
		b ; w xmlStr
		d rtnStream.Write(xmlStr)
	}
	catch sc2
	{
		b ; error sc2
		d ##class(web.DHCEkg.Base).Log("ERROR","web.DHCEkg.YB.Philips.Service","GetEKGInfo",
										$zd($h,3),$zt($p($h,",",2),1),sc2.Code_"^"_sc2.Location_"^"_sc2.Data,"sc2")
		d rtnStream.Write("<root><entity><property><serviceName>GetEKGInfo</serviceName><orderType></orderType></property>"
				_"<Request><ResultCode>-1</ResultCode><ResultContent>接口异常</ResultContent></Request></entity></root>")		
	}
	b ; d rtnStream.OutputToDevice()
	q rtnStream
}

}
