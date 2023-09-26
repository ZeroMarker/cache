/// web.DHCEkg.WebReportService
Class web.DHCEkg.WebReportService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "WebReportService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// Creator：      yangyali
/// CreatDate：    2019-9-24
/// ModifyDate：   2019-9-25
/// ModifyDesc：   
/// Description:   发布报告时调用平台接口发送检查报告
/// Table：       
/// Input：        医嘱号
/// Output：       调用结果
/// w ##class(web.DHCEkg.WebReportService).getJSInfo("139")
ClassMethod getJSInfo(ExamId) As %GlobalCharacterStream [ WebMethod ]
{
	new $namespace
	s jsStream=##class(%GlobalCharacterStream).%New()
	d jsStream.Write("<script>")
	s str=..AddValue("f_examId", ExamId)
	d jsStream.Write(str)
	s paadmdr=..GetAdmNo(ExamId)
	s (Gender,Age,ClinicDiagnose,PhysicPeriod)="" ;性别，年龄，临床诊断，生理周期
	i paadmdr'="" ;his患者，获取临床诊断和生理周期
	{
		s ClinicDiagnose=..GetClinicDiag(paadmdr)
		s str=..Add("clinicDiag",ClinicDiagnose)
		d jsStream.Write(str)
		
		s PhysicPeriod=##class(DHCDoc.Interface.Inside.Service).GetPhysiologicalCycle(paadmdr)
		s str=..Add("physicPeriod",PhysicPeriod)
		d jsStream.Write(str)
	}
	s Gender=..GetGender(ExamId)
	s str=..Add("gender",Gender)
	d jsStream.Write(str)
	s Age=..GetAge(ExamId)
	s str=..Add("age",Age)
	d jsStream.Write(str)
	s (hrRangeInfo)=""
	d GetRefrenceRange
	
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s examInfo=$g(^dbo.tblExaminationD(ExamId))
	q:(examInfo="") ""
	s diagnose=$listget(examInfo,11,"")
	s diagnose=$replace(diagnose,$c(10),"<br />")
	s str=..Add("diagnosis", diagnose)
	d jsStream.Write(str)	
	s devId=$listget(examInfo,10,"")
	q:(devId="") ""
	s devInfo=$g(^dbo.tblDeviceD(devId))
	q:(devInfo="") ""
	s testTypeId=$listget(devInfo,3,"")
	
	i (testTypeId="1")  ;静息类设备，取参数进行比对
	{
		s HRInfo=""
		s filepathId=""
		s filepathId=$o(^dbo.tblFilePathI("idxExaminationID",ExamId,filepathId))
		while (filepathId'="")
		{
			s paramId=$o(^dbo.tblParamRestI("idxFilePathId",filepathId,""))
			i paramId'=""
			{
				s paramInfo=$g(^dbo.tblParamRestD(paramId))
				s HR=$listget(paramInfo,17,"")
				s NormalLow=$listget(hrRangeInfo,7,"")
				s NormalHigh=$listget(hrRangeInfo,8,"")
				s NormalRange=NormalLow_"-"_NormalHigh_"(bpm)"
				s str=..Add("normalRange",NormalRange)
				d jsStream.Write(str)
				s CrisisLow=$listget(hrRangeInfo,9,"")
				s CrisisHigh=$listget(hrRangeInfo,10,"")
				s CrisisRange=CrisisLow_"-"_CrisisHigh_"(bpm)"
				s str=..Add("crisisRange",CrisisRange)
				d jsStream.Write(str)
				s HRStr=HR_"(bpm)"
				i (CrisisLow'="0")&&(HR<CrisisLow)
				{
					s HRStr=HRStr_"↓"
				}
				elseif (CrisisHigh'="0")&&(HR>CrisisHigh) 
				{
					s HRStr=HRStr_"↑"
				}
				i (HRInfo'="")
				{
					s HRInfo=HRInfo_"^"_HRStr
				}
				else
				{
					s HRInfo=HRStr
				}
			}
			
			s filepathId=$o(^dbo.tblFilePathI("idxExaminationID",ExamId,filepathId))
		}
		i HRInfo'="" 
		{
			s str=..AddValue("hrInfo",HRInfo)
			d jsStream.Write(str)
		}
	}
	else ;动态类型，不显示参考值和范围
	{
		s str="document.getElementById(""hrTr"").style.display = ""none"";"
		s str=str_"document.getElementById(""hrRangeTr"").style.display = ""none"";"
		d jsStream.Write(str)		
	}	
	zn "dhc-app"
	
	d jsStream.Write("</script>")
	b ; d jsStream.OutputToDevice()
	q jsStream
	
	
GetRefrenceRange
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	i (ClinicDiagnose'="") ;按诊断查询
	{
		s refId=""
		s refId=$o(^dbo.tblReferenceRangeI("idxPhysName"," 诊断",refId))
		while refId'=""
		{
			s refInfo=$g(^dbo.tblReferenceRangeD(refId))
			i refInfo'=""
			{
				s PhysValue=$listget(refInfo,3,"")
				i PhysValue'=""
				{
					i ClinicDiagnose[PhysValue ;临床诊断包含
					{
						s RefrenceName=$listget(refInfo,6,"")
						i (RefrenceName="HR") s hrRangeInfo=refInfo
					}
				}
				
			}
			s refId=$o(^dbo.tblReferenceRangeI("idxPhysName"," 诊断",refId))
		}
	}
	i (hrRangeInfo="")&&(PhysicPeriod'="") ;按生理周期查询
	{
		s refId=""
		s refId=$o(^dbo.tblReferenceRangeI("idxPhysName"," 生理周期",refId))
		while refId'=""
		{
			s refInfo=$g(^dbo.tblReferenceRangeD(refId))
			i refInfo'=""
			{
				s PhysValue=$listget(refInfo,3,"")
				i PhysValue'=""
				{
					i PhysicPeriod[PhysValue ;临床诊断包含
					{
						s RefrenceName=$listget(refInfo,6,"")
						i (RefrenceName="HR") s hrRangeInfo=refInfo
					}
				}
				
			}
			s refId=$o(^dbo.tblReferenceRangeI("idxPhysName"," 诊断",refId))
		}
	}
	i (hrRangeInfo="")&&(Age'="") ;按年龄查询
	{
		if Age["天"
		{
			s Age=$p(Age,"天",1)
			s refId=""
			s refId=$o(^dbo.tblReferenceRangeI("idxPhys"," 年龄"," 天",refId))
			while refId'=""
			{
				s refInfo=$g(^dbo.tblReferenceRangeD(refId))
				i refInfo'=""
				{
					s PhysLow=$listget(refInfo,5,"")
					s PhysHigh=$listget(refInfo,4,"")
					i ((PhysLow="")!(PhysLow<=Age))&&((PhysHigh="")!(PhysHigh>Age))&&((PhysHigh'="")!(PhysLow'=""))
					{
						s RefrenceName=$listget(refInfo,6,"")
						i (RefrenceName="HR") s hrRangeInfo=refInfo
					}					
				}
				s refId=$o(^dbo.tblReferenceRangeI("idxPhys"," 年龄"," 天",refId))
			}
			
		}
		elseif Age["月"
		{
			s Age=$p(Age,"月",1)
			s refId=""
			s refId=$o(^dbo.tblReferenceRangeI("idxPhys"," 年龄"," 月",refId))
			while refId'=""
			{
				s refInfo=$g(^dbo.tblReferenceRangeD(refId))
				i refInfo'=""
				{
					s PhysLow=$listget(refInfo,5,"")
					s PhysHigh=$listget(refInfo,4,"")
					i ((PhysLow="")!(PhysLow<=Age))&&((PhysHigh="")!(PhysHigh>Age))&&((PhysHigh'="")!(PhysLow'=""))
					{
						s RefrenceName=$listget(refInfo,6,"")
						i (RefrenceName="HR") s hrRangeInfo=refInfo 
					}					
				}
				s refId=$o(^dbo.tblReferenceRangeI("idxPhys"," 年龄"," 月",refId))
			}
		}
		else ;按岁处理
		{
			s Age=$p(Age,"岁",1)
			s refId=""
			s refId=$o(^dbo.tblReferenceRangeI("idxPhys"," 年龄"," 岁",refId))
			while refId'=""
			{
				s refInfo=$g(^dbo.tblReferenceRangeD(refId))
				i refInfo'=""
				{
					s PhysLow=$listget(refInfo,5,"")
					s PhysHigh=$listget(refInfo,4,"")
					i ((PhysLow="")!(PhysLow<=Age))&&((PhysHigh="")!(PhysHigh>Age))&&((PhysHigh'="")!(PhysLow'=""))
					{
						s RefrenceName=$listget(refInfo,6,"")
						i (RefrenceName="HR") s hrRangeInfo=refInfo
					}					
				}
				s refId=$o(^dbo.tblReferenceRangeI("idxPhys"," 年龄"," 岁",refId))
			}
		}
		
	}
	i (hrRangeInfo="")&&(Gender'="") ;按性别查询
	{
		s refId=""
		s refId=$o(^dbo.tblReferenceRangeI("idxPhys"," 性别"," "_Gender,refId))
		i refId'=""
		{
			s refInfo=$g(^dbo.tblReferenceRangeD(refId))
			s RefrenceName=$listget(refInfo,6,"")
			i (RefrenceName="HR") s hrRangeInfo=refInfo
		}		
	}
}

/// Creator：      yangyali
/// CreatDate：    2019-9-24
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   根据就诊号获取临床诊断
/// Table：       
/// Input：        就诊号
/// Output：       临床诊断详情
/// w ##class(yangyali.test1).GetClinicDiag("45")
ClassMethod GetClinicDiag(paadmdr) As %String
{
	s diagInfo=""
	s mradmid=$p(^PAADM(paadmdr),"^",61)
	
	s rs=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
	d rs.Execute(mradmid, "", "")
	while(rs.Next())
	{
		s code=$g(rs.Data("DiagnosICDCode"))
		s desc=$g(rs.Data("DiagnosDesc"))
		i code'=""
		{
			i diagInfo'="" s diagInfo=diagInfo_code_":"_desc_";"
			else  s diagInfo=code_":"_desc_";"
		}
	}
	q diagInfo
}

/// Creator：      yangyali
/// CreatDate：    2019-9-24
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   根据exam.Id获取年龄
/// Table：       
/// Input：        exam.Id
/// Output：       就诊号
/// w ##class(yangyali.test1).GetGender("179||122")
ClassMethod GetGender(ExamId) As %String
{
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s Gender=""
	s examInfo=$g(^dbo.tblExaminationD(ExamId))
	q:(examInfo="") ""
	s reqId=$listget(examInfo,19,"")
	q:(reqId="") ""
	s reqInfo=$g(^dbo.tblRequestD(reqId))
	q:(reqInfo="") ""
	s patId=$listget(reqInfo,16,"")
	q:(patId="") ""
	s patInfo=$g(^dbo.tblPatientD(patId))
	q:(patInfo="") ""
	
	s Gender=$listget(patInfo,8,"")
	i (Gender="m") s Gender="男"
	i (Gender="f") s Gender="女"
	q Gender
}

/// Creator：      yangyali
/// CreatDate：    2019-9-24
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   根据exam.Id获取年龄
/// Table：       
/// Input：        exam.Id
/// Output：       就诊号
/// w ##class(yangyali.test1).GetAge("179||122")
ClassMethod GetAge(ExamId) As %String
{
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s Age=""
	s examInfo=$g(^dbo.tblExaminationD(ExamId))
	q:(examInfo="") ""
	s Age=$listget(examInfo,34,"")
	i Age="" s Age=$listget(examInfo,5,"")_"岁"
	q Age
}

/// Creator：      yangyali
/// CreatDate：    2019-9-24
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   根据exam.Id获取就诊号
/// Table：       
/// Input：        exam.Id
/// Output：       就诊号
/// w ##class(yangyali.test1).GetAdmNo("179||122")
ClassMethod GetAdmNo(ExamId) As %String
{
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s examInfo=$g(^dbo.tblExaminationD(ExamId))
	q:(examInfo="") ""
	s reqId=$listget(examInfo,19,"")
	q:(reqId="") ""
	s reqInfo=$g(^dbo.tblRequestD(reqId))
	q:(reqInfo="") ""
	s AdmNo=$listget(reqInfo,3,"")
	zn "dhc-app"
	q AdmNo
}

/// Creator：      yangyali
/// CreatDate：    2019-9-24
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   给标签赋值
/// Table：       
/// Input：        标签id，内容
/// Output：       
/// w ##class(yangyali.test1).GetAdmNo("179||122")
ClassMethod Add(fieldName, fieldValue) As %String
{
	s rtn="document.getElementById("""_fieldName_""").innerHTML="""_fieldValue_""";"
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2019-9-24
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   给变量赋值
/// Table：       
/// Input：        变量名，内容
/// Output：       
/// w ##class(yangyali.test1).GetAdmNo("179||122")
ClassMethod AddValue(fieldName, fieldValue) As %String
{
	s rtn="document.getElementById("""_fieldName_""").value="""_fieldValue_""";"
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2020-6-8
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   根据exam.Id获取姓名
/// Table：       
/// Input：        exam.Id
/// Output：       病人姓名
/// w ##class(web.DHCEkg.WebReportService).GetName("")
ClassMethod GetName(ExamId) As %String
{
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s Gender=""
	s examInfo=$g(^dbo.tblExaminationD(ExamId))
	q:(examInfo="") ""
	s reqId=$listget(examInfo,19,"")
	q:(reqId="") ""
	s reqInfo=$g(^dbo.tblRequestD(reqId))
	q:(reqInfo="") ""
	s patId=$listget(reqInfo,16,"")
	q:(patId="") ""
	s patInfo=$g(^dbo.tblPatientD(patId))
	q:(patInfo="") ""
	
	s Name=$listget(patInfo,16,"")
	q Name
}

/// Creator：      yangyali
/// CreatDate：    2020-6-8
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   根据exam.Id获取医嘱名称
/// Table：       
/// Input：        exam.Id
/// Output：       医嘱名称
/// w ##class(web.DHCEkg.WebReportService).GetExamItem("")
ClassMethod GetExamItem(ExamId) As %String
{
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s Gender=""
	s examInfo=$g(^dbo.tblExaminationD(ExamId))
	q:(examInfo="") ""
	s reqId=$listget(examInfo,19,"")
	q:(reqId="") ""
	s reqInfo=$g(^dbo.tblRequestD(reqId))
	q:(reqInfo="") ""
	s examItemCode=$listget(reqInfo,11,"")
	q:(examItemCode="") ""
	s examItemCode=$zcvt(examItemCode,"u")
	s examItemId=$o(^dbo.tblDictExamItemI("idxExamItemCode"," "_examItemCode,""))
	q:(examItemId="") ""
	s examItemInfo=$g(^dbo.tblDictExamItemD(examItemId))
	q:(examItemInfo="") ""
	
	s ExamItem=$listget(examItemInfo,6,"")
	q ExamItem
}

/// Creator：      yangyali
/// CreatDate：    2020-6-8
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   根据exam.Id获取医嘱号
/// Table：       
/// Input：        exam.Id
/// Output：       医嘱号
/// w ##class(web.DHCEkg.WebReportService).GetOrdId("")
ClassMethod GetOrdId(ExamId) As %String
{
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s Gender=""
	s examInfo=$g(^dbo.tblExaminationD(ExamId))
	q:(examInfo="") ""
	s reqId=$listget(examInfo,19,"")
	q:(reqId="") ""
	s reqInfo=$g(^dbo.tblRequestD(reqId))
	q:(reqInfo="") ""
	
	s OrdId=$listget(reqInfo,6,"")
	q OrdId
}

/// Creator：      yangyali
/// CreatDate：    2020-6-8
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   根据exam.Id获取检查时间
/// Table：       
/// Input：        exam.Id
/// Output：       检查时间
/// w ##class(web.DHCEkg.WebReportService).GetOperateTime("")
ClassMethod GetOperateTime(ExamId) As %String
{
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s Gender=""
	s examInfo=$g(^dbo.tblExaminationD(ExamId))
	q:(examInfo="") ""
	
	s OperateTime=$listget(examInfo,13,"")
	q OperateTime
}

/// Creator：      yangyali
/// CreatDate：    2020-6-8
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   根据exam.Id获取来源科室
/// Table：       
/// Input：        exam.Id
/// Output：       来源科室名称
/// w ##class(web.DHCEkg.WebReportService).GetDept("867769")
ClassMethod GetDept(ExamId) As %String
{
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s Gender=""
	s examInfo=$g(^dbo.tblExaminationD(ExamId))
	q:(examInfo="") ""
	s reqId=$listget(examInfo,19,"")
	q:(reqId="") ""
	s reqInfo=$g(^dbo.tblRequestD(reqId))
	q:(reqInfo="") ""
	s deptCode=$listget(reqInfo,9,"")
	q:(deptCode="") ""
	s deptCode=$zcvt(deptCode,"u")
	s deptId=$o(^dbo.tblDictDeptI("idxDeptCode"," "_deptCode,""))
	q:(deptId="") ""
	s deptInfo=$g(^dbo.tblDictDeptD(deptId))
	q:(deptInfo="") ""
	
	s deptName=$listget(deptInfo,4,"")
	q deptName
}

/// Creator：      yangyali
/// CreatDate：    2020-6-8
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   根据exam.Id获取医嘱医生
/// Table：       
/// Input：        exam.Id
/// Output：       医嘱医生姓名
/// w ##class(web.DHCEkg.WebReportService).GetReqDoctor("")
ClassMethod GetReqDoctor(ExamId) As %String
{
	new $namespace
	do ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s Gender=""
	s examInfo=$g(^dbo.tblExaminationD(ExamId))
	q:(examInfo="") ""
	s reqId=$listget(examInfo,19,"")
	q:(reqId="") ""
	s reqInfo=$g(^dbo.tblRequestD(reqId))
	q:(reqInfo="") ""
	
	s DocName=$listget(reqInfo,12,"")
	q DocName
}

}
