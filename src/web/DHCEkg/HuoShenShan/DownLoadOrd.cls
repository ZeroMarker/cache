/// 武汉火神山医院
/// 提供给理邦下载医嘱
/// web.DHCEkg.HuoShenShan.DownLoadOrd
Class web.DHCEkg.HuoShenShan.DownLoadOrd Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "DownLoadOrd";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// 方法说明：	心电图机获取服务器时间，用于同步时间
/// 创建者：	yyl
/// 创建时间：	2020-1-29
/// 入参：		xml字符串
/// 返回值：	xml流
/// w ##class(web.DHCEkg.HuoShenShan.DownLoadOrd).GetTimeNow("<root><SynDateTimeQuery><ECGTitle>650693290</ECGTitle></SynDateTimeQuery></root>")
ClassMethod GetTimeNow(paramInfo As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s $ZT="ERRORGetTime"
	new $namespace
	s rtnStream=##class(%GlobalCharacterStream).%New()
	s ^tmpDHCEKG("DownLoadOrd","GetTimeNow",$zd($h,3),$p($zdt($h,3)," ",2),"param")=paramInfo
	s reader1=##class(%XML.Reader).%New()
	s sc1=reader1.OpenString(paramInfo)
	d reader1.Correlate("SynDateTimeQuery","web.DHCEkg.HuoShenShan.Dict.DateTimeQuery")
	s request=##class(web.DHCEkg.HuoShenShan.Dict.DateTimeRequest).%New()
	while reader1.Next(.obj,.sc)
	{
		b ;obj
		s request.SynDateTimeQuery=obj
	}
	
	s resultInfo=##class(web.DHCEkg.HuoShenShan.Dict.DateTimeQueryResult).%New()
	s resultInfo.Code="Success"
	s resultInfo.Message="1"
	s resultInfo.SynDateTime=$replace($zdt($h,8),":","")
	s request.SynDateTimeQueryResult=resultInfo
	
	s Status=request.XMLExportToStream(.stream)						
	d rtnStream.MoveToEnd()
	d rtnStream.CopyFrom(stream)
	s ^tmpDHCEKG("DownLoadOrd","GetTimeNow",$zd($h,3),$p($zdt($h,3)," ",2),"rtn")=rtnStream.Read()
	d rtnStream.Rewind()
	b ; d rtnStream.OutputToDevice()
	q rtnStream
ERRORGetTime
	Set ErrorMsg=$ZE
	s ^DHCEKGGetTimeError($zd($h,3),$zt($p($h,",",2)))=ErrorMsg	
	s request=##class(web.DHCEkg.HuoShenShan.Dict.DateTimeRequest).%New()
	s resultInfo=##class(web.DHCEkg.HuoShenShan.Dict.DateTimeQueryResult).%New()
	s resultInfo.Code="fail"
	s resultInfo.Message="Interface Exception"
	s request.SynDateTimeQueryResult=result
	
	s rtnStream=##class(%GlobalCharacterStream).%New()	
	s Status=request.XMLExportToStream(.stream)						
	d rtnStream.MoveToEnd()
	d rtnStream.CopyFrom(stream)
	d rtnStream.Rewind()
	b ; d rtnStream.OutputToDevice()
	q rtnStream
}

/// 方法说明：	获取静息类的医嘱过滤条件
/// 创建者：	yyl
/// 创建时间：	2020-2-7
/// 入参：		无
/// 返回值：	医嘱名称;医嘱名称
/// w ##class(web.DHCEkg.HuoShenShan.DownLoadOrd).GetExamFilter()
ClassMethod GetExamFilter() As %String [ WebMethod ]
{
	s rtnExamFilter=""
	new $NAMESPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s examItemId=""
	s examItemId=$o(^dbo.tblDictExamItemI("idxCategoryCode"," 1",examItemId))
	while(examItemId'="")
	{
		s examItemInfo=$g(^dbo.tblDictExamItemD(examItemId))
		s examItemName=$listget(examItemInfo,6,"")
		i examItemName'=""
		{
			i rtnExamFilter'="" s rtnExamFilter=rtnExamFilter_";"_examItemName
			e  s rtnExamFilter=examItemName
		}
		s examItemId=$o(^dbo.tblDictExamItemI("idxCategoryCode"," 1",examItemId))
	}
	
	q rtnExamFilter
}

/// 方法说明：	心电图机获取医嘱列表
/// 创建者：	yyl
/// 创建时间：	2020-1-29
/// 入参：		xml字符串
/// 返回值：	xml流
/// s param="<root><query><ECGTitle>650693290</ECGTitle><ExamStartDate>2020-1-1</ExamStartDate><ExamEndDate/><Modality></Modality><ExamDepartment></ExamDepartment><PerformingPhysician></PerformingPhysician><PatientName></PatientName><PatientID></PatientID><ExamID></ExamID><RequestID></RequestID><RequestDepartment>ZYHL003</RequestDepartment></query></root>"
/// w ##class(web.DHCEkg.HuoShenShan.DownLoadOrd).GetOrderList(param)
ClassMethod GetOrderList(paramInfo As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s $ZT="ERRORGetOrd"
	s locIdConfig="83^85" ;医嘱接收科室,心电图室id
	new $namespace
	s rtnStream=##class(%GlobalCharacterStream).%New()
	s ^tmpDHCEKG("DownLoadOrd","GetOrderList",$zd($h,3),$p($zdt($h,3)," ",2),"param")=paramInfo
	s reader1=##class(%XML.Reader).%New()
	s sc1=reader1.OpenString(paramInfo)
	d reader1.Correlate("query","web.DHCEkg.HuoShenShan.Dict.OrdQuery")
	s request=##class(web.DHCEkg.HuoShenShan.Dict.OrdRequest).%New()
	s result=##class(web.DHCEkg.HuoShenShan.Dict.OrdResult).%New()
	s result.Code="fail"
	s result.Message="未解析到参数"
	s examItemFilter=..GetExamFilter()
	s (patCode,stdDate,endDate,examItemFilter, execFlag,feeFlag,patientType,examState,rptState)=""
	s (StartTime,EndTime,OrdStatus,OrdDeptCode)=""
	while reader1.Next(.obj,.sc)
	{
		b ;obj
		s request.query=obj
		s patCode=obj.PatientID
		i ($length(patCode)<2) s patCode=""
		s StartTime=obj.ExamStartDate
		i ($length(StartTime)<2) s StartTime=""
		s EndTime=obj.ExamEndDate
		i ($length(EndTime)<2) s EndTime=""
		s OrdStatus=""
		s OrdDeptCode=obj.RequestDepartment
		i ($length(OrdDeptCode)<2) s OrdDeptCode=""
		
	}
	s ordCount=0 ;医嘱数量
	i OrdDeptCode=""
	{
		
		s objsub=##class(web.DHCEkg.HuoShenShan.Dict.OrdRecord).%New()
		/// 病人姓名
		s objsub.PatientName ="病区为空"
		d request.records.Insert(objsub)
		s ordCount=ordCount+1
	}
	else
	{
		i StartTime="" s stdDate=$p($h,",",1)-5
		else  s stdDate=$zdh(StartTime,3)
		i ($length(EndTime)<2) s endDate=$p($h,",",1)+1
		else  s endDate=$zdh(EndTime,3)
		
		s i=1
		while(i<=$l(locIdConfig,"^"))
		{
			s locId=$p(locIdConfig,"^",i)
			i (locId'="")
			{
				b ; w locId_","_patCode_","_stdDate_","_endDate_","_OrdDeptCode
				s rs=##class(%ResultSet).%New("web.DHCEkg.HuoShenShan.QueryOrder:GetEkgOdrList")
				d rs.Execute(locId,patCode,stdDate,endDate,examItemFilter, execFlag,feeFlag,patientType,examState,rptState,OrdDeptCode)
				
				while(rs.Next())
				{
					s objsub=##class(web.DHCEkg.HuoShenShan.Dict.OrdRecord).%New()
					/// 流水号
					s objsub.SerialNO =$g(rs.Data("OeordId"))
					/// 病人号，心电图机根据此项值生成数据，此处放置医嘱号
					s objsub.PatientID =$g(rs.Data("OeordId")) ;$g(rs.Data("RegNo"))
					/// 病人姓名
					s objsub.PatientName =$g(rs.Data("PatName"))
					/// 病人性别
					s objsub.PatientSex =$g(rs.Data("sex"))
					/// 病人年龄
					s age=+$g(rs.Data("age"))
					s ageUnit=$p($g(rs.Data("age")),age,2)
					s objsub.PatientAge =age
					/// 年龄单位
					s objsub.PatientAgeUnit =ageUnit
					/// 病人出生日期
					s objsub.PatientBirthDate =$g(rs.Data("dobDate"))
					/// 身高
					s objsub.Height =""
					/// 身高单位
					s objsub.HeightUnit =""
					/// 体重
					s objsub.Weight =""
					/// 体重单位
					s objsub.WeightUnit =""
					/// 舒张压
					s objsub.DiastolicBP =""
					/// 收缩压
					s objsub.SystolicBP =""
					/// 血压单位
					s objsub.BPUnit =""
					/// 检查科室
					s objsub.ExamDepartment =$g(rs.Data("RecLocDesc"))
					/// 申请科室
					s objsub.RequestDepartment =$g(rs.Data("AdmDep"))
					/// 预约日期
					s objsub.RequestDate =$g(rs.Data("OrdDateTime"))
					/// 申请号
					;s ordRowid=$g(rs.Data("OeordId"))
					s studyNo=""
					;i (ordRowid'="") s studyNo="EKG||"_ordRowid
					s objsub.RequestID =studyNo
					/// 检查优先级
					s objsub.Priority =""
					/// 检查项目
					s objsub.ExamItem =$g(rs.Data("ArcimDesc"))
					/// 医嘱
					s objsub.DoctorAdvice =""
					/// 病区
					s objsub.WardNo =$g(rs.Data("Wardname"))
					/// 病床号
					s objsub.SickBedNo =$g(rs.Data("BedCode"))
					/// 种族
					s objsub.Race =""
					/// 起搏器
					s objsub.Pacemaker =""
					/// 用药
					s objsub.DrugsTaken =""
					/// 自定义项1名称
					s objsub.CustomName1 ="RegNo"
					/// 自定义项1内容
					s objsub.CustomContent1 =$g(rs.Data("RegNo"))
					/// 自定义项2名称
					s objsub.CustomName2 =""
					/// 自定义项2内容
					s objsub.CustomContent2 =""
					
					d request.records.Insert(objsub)
					s ordCount=ordCount+1
				}
			}
			s i=i+1
		}
	}
	s result.Code="Success"
	s result.Message=ordCount
	s request.result=result
	s Status=request.XMLExportToStream(.stream)						
	d rtnStream.MoveToEnd()
	d rtnStream.CopyFrom(stream)
	s ^tmpDHCEKG("DownLoadOrd","GetOrderList",$zd($h,3),$p($zdt($h,3)," ",2),"rtn")=rtnStream.Read()
	d rtnStream.Rewind()
	b ; d rtnStream.OutputToDevice()
	q rtnStream
	
ERRORGetOrd
	Set ErrorMsg=$ZE
	s ^DHCEKGGetOrdError($zd($h,3),$zt($p($h,",",2)))=ErrorMsg	
	s request=##class(web.DHCEkg.HuoShenShan.Dict.OrdRequest).%New()
	s result=##class(web.DHCEkg.HuoShenShan.Dict.OrdResult).%New()
	s result.Code="fail"
	s result.Message="Interface Exception"
	s request.result=result
	s request.result=result
	
	s rtnStream=##class(%GlobalCharacterStream).%New()	
	s Status=request.XMLExportToStream(.stream)						
	d rtnStream.MoveToEnd()
	d rtnStream.CopyFrom(stream)
	d rtnStream.Rewind()
	b ; d rtnStream.OutputToDevice()
	q rtnStream
}

}
