/// 名称: 既往史
/// 描述: 获取既往史的信息
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-17
Class web.CDSS.PatientView.PastDiagnosis Extends %RegisteredObject
{

/// Creator:dingyanan
/// CreatDate:2020-04-17
/// Description：获取患者既往史信息表信息 
/// Table：WDT.CDSS.PastDiagnosis
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型 Config配置信息（确定取数据的方式）
/// Output：按照固定格式返回患者既往史信息表的时间、名称、id
/// w ##class(web.CDSS.PatientView.PastDiagnosis).GetPastDiagForEcharts("DH001","te001","1","Y")
ClassMethod GetPastDiagForEcharts(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String = "", Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s UnKnoDateInfo="",DateInfo="",DiagInfo="",PastDiagInfo=""
	if (Config=1)&(PatientDR'="")&(VisitID'="")&(VisitType'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.PastDiagnosisI("PatVisDRSeqIndex",PatientDR,VisitID,VisitType)))
		{
			s PastHistoryNum=0
			for
			{
				s PastHistoryNum =$o(^WDT.CDSS.PastDiagnosisI("PatVisDRSeqIndex",PatientDR,VisitID,VisitType,PastHistoryNum)) q:PastHistoryNum=""
				s PastID=0
				for
				{
					s PastID =$o(^WDT.CDSS.PastDiagnosisI("PatVisDRSeqIndex",PatientDR,VisitID,VisitType,PastHistoryNum,PastID)) q:PastID=""
					s PastDiagnosisName=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),7)
					s ProjectDataName=##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(PastDiagnosisName,"诊断")
					s StartTime=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),9)
					s:StartTime'="" StartTime=$zdate(StartTime,3)
					s:StartTime'="" StartTime=$E(StartTime,1,4)
					s:StartTime="" StartTime=0
					s DiagInfo="["_StartTime_","""_PastDiagnosisName_""","_PastID_""","_ProjectDataName_"]"
					if (StartTime=0)
					{
						s:UnKnoDateInfo'="" UnKnoDateInfo=UnKnoDateInfo_","_DiagInfo
						s:UnKnoDateInfo="" UnKnoDateInfo=DiagInfo
					}
					else
					{
						s:DateInfo'="" DateInfo=DateInfo_","_DiagInfo
						s:DateInfo="" DateInfo=DiagInfo
					}
				}
			}
		}
	}
	elseif(IDNO'="")  //患者主索引
	{
		s PastHistoryNum=0
		for
		{
			s PastHistoryNum =$o(^WDT.CDSS.PastDiagnosisI("IDNOSeqIndex",IDNO,PastHistoryNum)) q:PastHistoryNum=""
			s PastID=0
			for
			{
				s PastID =$o(^WDT.CDSS.PastDiagnosisI("IDNOSeqIndex",IDNO,PastHistoryNum,PastID)) q:PastID=""
				s PastDiagnosisName=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),7)
				s StartTime=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),9)
				s ProjectDataName=##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(PastDiagnosisName,"诊断")
				s:StartTime'="" StartTime=$zdate(StartTime,3)
				s:StartTime'="" StartTime=$E(StartTime,1,4)
				s:StartTime="" StartTime=0
				s DiagInfo="["_StartTime_","""_PastDiagnosisName_""","_PastID_""","_ProjectDataName_"]"
				if (StartTime=0)
				{
					s:UnKnoDateInfo'="" UnKnoDateInfo=UnKnoDateInfo_","_DiagInfo
					s:UnKnoDateInfo="" UnKnoDateInfo=DiagInfo
				}
				else
				{
					s:DateInfo'="" DateInfo=DateInfo_","_DiagInfo
					s:DateInfo="" DateInfo=DiagInfo
				}
			}
		}
	}
	if (UnKnoDateInfo'="")
	{
	 	s PastDiagInfo=UnKnoDateInfo
	 	if (DateInfo'="")
	 	{
		 	s PastDiagInfo=PastDiagInfo_","_DateInfo
		}
	}
	else
	{
		if (DateInfo'="")
	 	{
		 	s PastDiagInfo=DateInfo
		}
	}
	s PastDiagInfo="["_PastDiagInfo_"]"
	return PastDiagInfo
}

/// Creator:dingyanan
/// CreatDate:2020-04-17
/// Description：获取患者既往史信息表单条信息 
/// Table：WDT.CDSS.PastDiagnosis
/// Input：PastID 既往史表的id
/// Output：json格式返回既往史表的枚举字段
/// w ##class(web.CDSS.PatientView.PastDiagnosis).GetPastDiagForForm(1)
ClassMethod GetPastDiagForForm(PastID As %String) As %String
{
	s PastDiagInfo=""
	if (PastID'="")
	{
		s PastHistoryNum=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),6)
		s PastDiagnosisName=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),7)
		s ProjectDataName=##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(PastDiagnosisName,"诊断")
		s DiagnosisType=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),8)
		s StartTime=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),9)
		if StartTime'="" s StartTime=$zdate(StartTime,3)
		s EndTime=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),10)
		if EndTime'="" s EndTime=$zdate(EndTime,3)
		s Duration=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),11)
		s Criticality=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),12)
		s TreatmentEffect=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),13)
		s Remarks=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),14)
			
		s PastDiagInfo="{""PastID"":"""_PastID_""",""PastDiagnosisName"":"""_PastDiagnosisName_""",""DiagnosisType"":"""_DiagnosisType_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_
				EndTime_""",""Duration"":"""_Duration_""",""Criticality"":"""_Criticality_""",""TreatmentEffect"":"""_TreatmentEffect_""",""Remarks"":"""_Remarks_""",""ProjectDataName"":"""_ProjectDataName_"""}"
				
	}
	return PastDiagInfo
}

/// Creator：丁亚男
/// CreatDate: 2020-05-12
/// Description：保存修改内容
/// Table：WDT.CDSS.PastDiagnosis
/// Input：web.CDSSEntity.PatientView.PastDiagnosis 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.PastDiagnosis) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.PastID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.PastDiagnosis).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.PastDiagnosis).%OpenId(eobj.PastID)
            s bobj = ##class(web.CDSSEntity.PatientView.PastDiagnosis).%New()
            s bobj.PastID = eobj.PastID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.VisitID= obj.VisitID
            s bobj.VisitType = obj.VisitType
            s bobj.PastHistoryNum = obj.PastHistoryNum
            s bobj.PastDiagnosisName = obj.PastDiagnosisName
            s bobj.DiagnosisType= obj.DiagnosisType
            s bobj.StartTime= obj.StartTime
            s bobj.EndTime = obj.EndTime
            s bobj.Duration = obj.Duration
            s bobj.Criticality = obj.Criticality
            s bobj.TreatmentEffect= obj.TreatmentEffect
            s bobj.Remarks = obj.Remarks
            s bobj.PassFlag = obj.PassFlag
            
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.VisitID= eobj.VisitID
        s obj.VisitType = eobj.VisitType
        s obj.PastHistoryNum = eobj.PastHistoryNum
        s obj.PastDiagnosisName = eobj.PastDiagnosisName
        s obj.DiagnosisType= eobj.DiagnosisType
        s:eobj.StartTime'="" obj.StartTime= $zdh(eobj.StartTime,3)
        s:eobj.EndTime'="" obj.EndTime= $zdh(eobj.EndTime,3)
        s obj.Duration = eobj.Duration
        s obj.Criticality = eobj.Criticality
        s obj.TreatmentEffect= eobj.TreatmentEffect
        s obj.Remarks = eobj.Remarks
        i eobj.PassFlag="Y"
        {
            s obj.PassFlag = "1"
        }
        else
        {
            s obj.PassFlag = "0"
        }
        
            
        Ts
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc){
            Tc
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}" //返回RowId
          }else{
            Trollback
            s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
        }
           
    }   

    else
    {
        s result = "{success:'false',errorinfo:'对象不存在'}"
    }
    
    q result
}

/// Creator：丁亚男
/// CreatDate: 2020-05-12
/// Description：获取修改时的记录
/// Table：WDT.CDSS.PastDiagnosis
/// Other: d ##class(web.CDSS.PatientView.PastDiagnosis).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.PastDiagnosis).%New()
    s eobj = ##class(WDT.CDSS.PastDiagnosis).%OpenId(id)
	s obj.PastID = id
    s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.VisitID= eobj.VisitID
    s obj.VisitType = eobj.VisitType
    s obj.PastHistoryNum = eobj.PastHistoryNum
    s obj.PastDiagnosisName = eobj.PastDiagnosisName
    s obj.DiagnosisType= eobj.DiagnosisType
    s:eobj.StartTime'="" obj.StartTime= $zd(eobj.StartTime,3)
    s:eobj.EndTime'="" obj.EndTime= $zd(eobj.EndTime,3)
    s obj.Duration = eobj.Duration
    s obj.Criticality = eobj.Criticality
    s obj.TreatmentEffect= eobj.TreatmentEffect
    s obj.Remarks = eobj.Remarks  
    s:eobj.PassFlag="" obj.PassFlag="Y"
    s:eobj.PassFlag="1" obj.PassFlag="Y"
    s:eobj.PassFlag="0" obj.PassFlag="N"
     
	d eobj.%Close()  
    s str = obj.JsonS()    
    q str
}

/// Creator:丁亚男
/// CreatDate:2020-05-12
/// Description:根据id删除
/// Table:WDT.CDSS.PastDiagnosis
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.PastDiagnosis).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.PastDiagnosis).%DeleteId(id)
    if $$$ISOK(sc){
        Tcommit
        s result="{success:'true',info:'删除成功！'}"
    }
    else{
        Trollback
        s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
     }
   
    q result
}

}
