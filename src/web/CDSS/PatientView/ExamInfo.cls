/// 名称: 检查信息
/// 描述: 获取检查信息的信息
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-05-08
Class web.CDSS.PatientView.ExamInfo Extends %RegisteredObject
{

/// Creator:dingyanan
/// CreatDate:2020-05-08
/// Description：获取患者检查信息表信息 
/// Table：WDT.CDSS.ExamInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者处方信息表枚举字段的json串
/// w ##class(web.CDSS.PatientView.ExamInfo).GetPatientExamInfo("DH001","te001","1","")
ClassMethod GetPatientExamInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s PatientExamInfo="",ExamInfo="",ResultInfo=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.ExamInfoI("PatVisDRTyExamIndex",PatientDR,VisitID,VisitType)))
		{
			s GroupFlag=0
			for
			{
				s GroupFlag =$o(^WDT.CDSS.ExamInfoI("PatVisDRTyExamIndex",PatientDR,VisitID,VisitType,GroupFlag)) q:GroupFlag=""
				s ExamCode=0
				for
				{
					s ExamCode =$o(^WDT.CDSS.ExamInfoI("PatVisDRTyExamIndex",PatientDR,VisitID,VisitType,GroupFlag,ExamCode)) q:ExamCode=""
					s ExamID=0
					for
					{
						s ExamID =$o(^WDT.CDSS.ExamInfoI("PatVisDRTyExamIndex",PatientDR,VisitID,VisitType,GroupFlag,ExamCode,ExamID)) q:ExamID=""
						s GroupSequence=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),7)
						s ExamCode=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),8)
						s ExamName=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),9)
						s ExamResult=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),10)
						s PartDR=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),11)
						s Part=""
						if (PartDR'="")
						{
							s Part=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(PartDR)),3) //取部位名称
						}
						s ExecuteTime=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),12)
						//if ExecuteTime'="" s ExecuteTime=$zdate(ExecuteTime,3)
						s ReportTime=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),13)
						//if ReportTime'="" s ReportTime=$zdate(ReportTime,3)
						s Remarks=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),14)
						s PassFlag=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),15)
						s ExamResultNum=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),16)
						s ExamResultFlag=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),17)
						s ExamResultDesc=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),18)
						s ProjectName=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),20)
						s SymptomCore=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),21)
						s SymProperty=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),22)
						s PositionWordDR=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),23)
						s ExamInfo="{""ExamID"":"""_ExamID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""ExamCode"":"""_ExamCode_""",""ExamName"":"""_
							ExamName_""",""Part"":"""_Part_""",""ExecuteTime"":"""_ExecuteTime_""",""PassFlag"":"""_PassFlag_""",""ExamResult"":"""_ExamResult_""",""ExamResultNum"":"""_ExamResultNum_""",""ExamResultFlag"":"""_ExamResultFlag_""",""ExamResultDesc"":"""_ExamResultDesc_""",""ReportTime"":"""_ReportTime
							_""",""Remarks"":"""_Remarks_""",""ProjectName"":"""_ProjectName_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""PositionWordDR"":"""_PositionWordDR_"""}"	
						
						if (PatientExamInfo="")
						{
							s PatientExamInfo=ExamInfo		
						}
						else
						{
							s PatientExamInfo=PatientExamInfo_","_ExamInfo			
						}
						
					}
				}
				
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s GroupFlag=0
		for
		{
			s GroupFlag =$o(^WDT.CDSS.ExamInfoI("IDNOExamIndex",IDNO,GroupFlag)) q:GroupFlag=""
			s ExamCode=0
			for
			{
				s ExamCode =$o(^WDT.CDSS.ExamInfoI("IDNOExamIndex",IDNO,GroupFlag,ExamCode)) q:ExamCode=""
				s ExamID=0
				for
				{
					s ExamID =$o(^WDT.CDSS.ExamInfoI("IDNOExamIndex",IDNO,GroupFlag,ExamCode,ExamID)) q:ExamID=""
					s GroupSequence=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),7)
					s ExamCode=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),8)
					s ExamName=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),9)
					s ExamResult=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),10)
					s PartDR=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),11)
					s Part=""
					if (PartDR'="")
					{
						s Part=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(PartDR)),3) //取部位名称
					}
					s ExecuteTime=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),12)
					//if ExecuteTime'="" s ExecuteTime=$zdate(ExecuteTime,3)
					s ReportTime=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),13)
					//if ReportTime'="" s ReportTime=$zdate(ReportTime,3)
					s Remarks=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),14)
					s PassFlag=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),15)
					s ExamResultNum=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),16)
					s ExamResultFlag=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),17)
					s ExamResultDesc=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),18)
					s ProjectName=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),20)
					s SymptomCore=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),21)
					s SymProperty=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),22)
					s PositionWordDR=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),23)
					s ExamInfo="{""ExamID"":"""_ExamID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""ExamCode"":"""_ExamCode_""",""ExamName"":"""_
							ExamName_""",""Part"":"""_Part_""",""ExecuteTime"":"""_ExecuteTime_""",""PassFlag"":"""_PassFlag_""",""ExamResult"":"""_ExamResult_""",""ExamResultNum"":"""_ExamResultNum_""",""ExamResultFlag"":"""_ExamResultFlag_""",""ExamResultDesc"":"""_ExamResultDesc_""",""ReportTime"":"""_ReportTime
							_""",""Remarks"":"""_Remarks_""",""ProjectName"":"""_ProjectName_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""PositionWordDR"":"""_PositionWordDR_"""}"
						
					if (PatientExamInfo="")
					{
						s PatientExamInfo=ExamInfo		
					}
					else
					{
						s PatientExamInfo=PatientExamInfo_","_ExamInfo			
					}
				}
					
			}	
		}
	}
	return "["_PatientExamInfo_"]"
}

/// Creator：丁亚男
/// CreatDate: 2020-05-08
/// Description：保存修改内容
/// Table：WDT.CDSS.ExamInfo
/// Input：web.CDSSEntity.PatientView.ExamInfo 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.ExamInfo) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.ExamID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.ExamInfo).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.ExamInfo).%OpenId(eobj.ExamID)
            s bobj = ##class(web.CDSSEntity.PatientView.ExamInfo).%New()
            s bobj.ExamID = eobj.ExamID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.VisitID= obj.VisitID
            s bobj.VisitType = obj.VisitType
            s bobj.GroupFlag = obj.GroupFlag
            s bobj.GroupSequence = obj.GroupSequence
            s bobj.ExamCode= obj.ExamCode
            s bobj.ExamName = obj.ExamName
            s bobj.ExamResult = obj.ExamResult
            s bobj.PartDR = obj.PartDR
            s bobj.ExecuteTime= obj.ExecuteTime
            s bobj.ReportTime = obj.ReportTime
            s bobj.Remarks = obj.Remarks
            s bobj.PassFlag = obj.PassFlag
            s bobj.ExamResultNum= obj.ExamResultNum
            s bobj.ExamResultFlag = obj.ExamResultFlag
            s bobj.ExamResultDesc = obj.ExamResultDesc
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.VisitID= eobj.VisitID
        s obj.VisitType = eobj.VisitType
        s obj.GroupFlag = eobj.GroupFlag
        s obj.GroupSequence = eobj.GroupSequence
        s obj.ExamCode= eobj.ExamCode
        s obj.ExamName = eobj.ExamName
        s obj.ExamResult = eobj.ExamResult
        s obj.PartDR = eobj.PartDR
        s obj.ExecuteTime= eobj.ExecuteTime
        s obj.ReportTime = eobj.ReportTime
        s obj.Remarks = eobj.Remarks
        i eobj.PassFlag="Y"
        {
            s obj.PassFlag = "1"
        }
        else
        {
            s obj.PassFlag = "0"
        }
        s obj.ExamResultNum= eobj.ExamResultNum
        s obj.ExamResultFlag = eobj.ExamResultFlag
        s obj.ExamResultDesc = eobj.ExamResultDesc
            
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
/// CreatDate: 2020-05-08
/// Description：获取修改时的记录
/// Table：WDT.CDSS.ExamInfo
/// Other: d ##class(web.CDSS.PatientView.ExamInfo).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.CDSSEntity.PatientView.ExamInfo).%New()
    s pobj = ##class(WDT.CDSS.ExamInfo).%OpenId(id)
    s eobj.ExamID = id
	s eobj.IDNO = pobj.IDNO
    s eobj.PatientDR = pobj.PatientDR
    s eobj.VisitID= pobj.VisitID
    s eobj.VisitType = pobj.VisitType
    s eobj.GroupFlag = pobj.GroupFlag
    s eobj.GroupSequence = pobj.GroupSequence
    s eobj.ExamCode= pobj.ExamCode
    s eobj.ExamName = pobj.ExamName
    s eobj.ExamResult = pobj.ExamResult
    s eobj.PartDR = pobj.PartDR
    s eobj.ExecuteTime= pobj.ExecuteTime
    s eobj.ReportTime = pobj.ReportTime
    s eobj.Remarks = pobj.Remarks
    s:pobj.PassFlag="" eobj.PassFlag="Y"
    s:pobj.PassFlag="1" eobj.PassFlag="Y"
    s:pobj.PassFlag="0" eobj.PassFlag="N"
    s eobj.ExamResultNum= pobj.ExamResultNum
    s eobj.ExamResultFlag = pobj.ExamResultFlag
    s eobj.ExamResultDesc = pobj.ExamResultDesc
    d pobj.%Close()  
    
    s str = eobj.JsonS() 
    
    q str
}

/// Creator:丁亚男
/// CreatDate:2020-05-08
/// Description:根据id删除
/// Table:WDT.CDSS.ExamInfo
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.ExamInfo).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.ExamInfo).%DeleteId(id)
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
