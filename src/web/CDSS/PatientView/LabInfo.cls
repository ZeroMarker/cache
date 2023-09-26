/// 名称: 检验信息
/// 描述: 获取检验信息的信息
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-05-08
Class web.CDSS.PatientView.LabInfo Extends %RegisteredObject
{

/// Creator:zhaowenwei
/// CreatDate:2022-09-08
/// Description：获取患者检验信息表信息 
/// Table：WDT.CDSS.LabInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者处方信息表枚举字段的json串
/// w ##class(web.CDSS.PatientView.LabInfo).GetPatientLabInfo("","DM000821","1","住院","1")
ClassMethod GetPatientLabInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String = "", Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s PatientLabInfo="",LabInfo=""
	if (Config=1)&(PatientDR'="")&(VisitID'="")&(VisitType'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.LabInfoI("UniquePatIndex",PatientDR,VisitID,VisitType)))
		{
			s GroupFlag=0
			for
			{
				s GroupFlag =$o(^WDT.CDSS.LabInfoI("UniquePatIndex",PatientDR,VisitID,VisitType,GroupFlag)) 
				q:GroupFlag=""
				
				s LabID=0
				for
				{
					s LabID =$o(^WDT.CDSS.LabInfoI("UniquePatIndex",PatientDR,VisitID,VisitType,GroupFlag,LabID)) q:LabID=""
					//s GroupFlag=$lg($g(^WDT.CDSS.LabInfoD(LabID)),6)
					
					s GroupSequence=$lg($g(^WDT.CDSS.LabInfoD(LabID)),7)
					s InspectionCode=$lg($g(^WDT.CDSS.LabInfoD(LabID)),8)
					s InspectionName=$lg($g(^WDT.CDSS.LabInfoD(LabID)),9)
					s LabItemCode=$lg($g(^WDT.CDSS.LabInfoD(LabID)),10)
					s LabItemName=$lg($g(^WDT.CDSS.LabInfoD(LabID)),11)
					s LabResult=$lg($g(^WDT.CDSS.LabInfoD(LabID)),12)
					s Unit=$lg($g(^WDT.CDSS.LabInfoD(LabID)),13)
					s Reference=$lg($g(^WDT.CDSS.LabInfoD(LabID)),14)
					s Specimen=$lg($g(^WDT.CDSS.LabInfoD(LabID)),15)
					s ExecuteTime=$lg($g(^WDT.CDSS.LabInfoD(LabID)),16)
					//if ExecuteTime'="" s ExecuteTime=$zdate(ExecuteTime,3)
					s ReportTime=$lg($g(^WDT.CDSS.LabInfoD(LabID)),17)
					//if ReportTime'="" s ReportTime=$zdate(ReportTime,3)
					s Remarks=$lg($g(^WDT.CDSS.LabInfoD(LabID)),18)
					s PassFlag=$lg($g(^WDT.CDSS.LabInfoD(LabID)),19)
					s LabResultFlag=$lg($g(^WDT.CDSS.LabInfoD(LabID)),20)
					
					s InspectionInfo="{""InspectionCode"":"""_InspectionCode_""",""InspectionName"":"""_InspectionName_""",""LabID"":"""_LabID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""LabItemCode"":"""_LabItemCode_""",""LabItemName"":"""_LabItemName_""",""LabResult"":"""_LabResult_""",""Unit"":"""_
						Unit_""",""Reference"":"""_Reference_""",""Specimen"":"""_Specimen_""",""ExecuteTime"":"""_ExecuteTime_""",""ReportTime"":"""_ReportTime_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""LabResultFlag"":"""_LabResultFlag_""","""_LabItemName_""":"""_LabResult_"""}"	
						
					if (PatientLabInfo="")
					{
						s PatientLabInfo=InspectionInfo
									
					}
					else
					{
						s PatientLabInfo=PatientLabInfo_","_InspectionInfo			
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
			s GroupFlag =$o(^WDT.CDSS.LabInfoI("IDNOLabGIndex",$zcvt(IDNO,"U"),GroupFlag)) q:GroupFlag=""
			s LabID=0
			for
			{
				s LabID =$o(^WDT.CDSS.LabInfoI("IDNOLabGIndex",$zcvt(IDNO,"U"),GroupFlag,LabID)) q:LabID=""
				
				s GroupFlag=$lg($g(^WDT.CDSS.LabInfoD(LabID)),6)
				s GroupSequence=$lg($g(^WDT.CDSS.LabInfoD(LabID)),7)
				s InspectionCode=$lg($g(^WDT.CDSS.LabInfoD(LabID)),8)
				s InspectionName=$lg($g(^WDT.CDSS.LabInfoD(LabID)),9)
				s LabItemCode=$lg($g(^WDT.CDSS.LabInfoD(LabID)),10)
				s LabItemName=$lg($g(^WDT.CDSS.LabInfoD(LabID)),11)
				s LabResult=$lg($g(^WDT.CDSS.LabInfoD(LabID)),12)
				s Unit=$lg($g(^WDT.CDSS.LabInfoD(LabID)),13)
				s Reference=$lg($g(^WDT.CDSS.LabInfoD(LabID)),14)
				s Specimen=$lg($g(^WDT.CDSS.LabInfoD(LabID)),15)
				s ExecuteTime=$lg($g(^WDT.CDSS.LabInfoD(LabID)),16)
				//if ExecuteTime'="" s ExecuteTime=$zdate(ExecuteTime,3)
				s ReportTime=$lg($g(^WDT.CDSS.LabInfoD(LabID)),17)
				//if ReportTime'="" s ReportTime=$zdate(ReportTime,3)
				s Remarks=$lg($g(^WDT.CDSS.LabInfoD(LabID)),18)
				s PassFlag=$lg($g(^WDT.CDSS.LabInfoD(LabID)),19)
				s LabResultFlag=$lg($g(^WDT.CDSS.LabInfoD(LabID)),20)
				
				s InspectionInfo="{""InspectionCode"":"""_InspectionCode_""",""InspectionName"":"""_InspectionName_""",""LabID"":"""_LabID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""LabItemCode"":"""_LabItemCode_""",""LabItemName"":"""_LabItemName_""",""LabResult"":"""_LabResult_""",""Unit"":"""_
					Unit_""",""Reference"":"""_Reference_""",""Specimen"":"""_Specimen_""",""ExecuteTime"":"""_ExecuteTime_""",""ReportTime"":"""_ReportTime_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""LabResultFlag"":"""_LabResultFlag_""","""_LabItemName_""":"""_LabResult_"""}"	
						
				if (PatientLabInfo="")
				{
					s PatientLabInfo=InspectionInfo			
				}
				else
				{
					s PatientLabInfo=PatientLabInfo_","_InspectionInfo			
				}
			}
		}
	}
	
	return "["_PatientLabInfo_"]"
}

/// Creator：丁亚男
/// CreatDate: 2020-05-08
/// Description：保存修改内容
/// Table：WDT.CDSS.LabInfo
/// Input：web.CDSSEntity.PatientView.LabInfo 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.LabInfo) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.LabID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.LabInfo).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.LabInfo).%OpenId(eobj.LabID)
            s bobj = ##class(web.CDSSEntity.PatientView.LabInfo).%New()
            s bobj.LabID = eobj.LabID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.VisitID= obj.VisitID
            s bobj.VisitType = obj.VisitType
            s bobj.GroupFlag = obj.GroupFlag
            s bobj.GroupSequence = obj.GroupSequence
            s bobj.InspectionCode= obj.InspectionCode
            s bobj.InspectionName = obj.InspectionName
            s bobj.LabItemCode = obj.LabItemCode
            s bobj.LabItemName = obj.LabItemName
            s bobj.LabResult= obj.LabResult
            s bobj.Unit = obj.Unit
            s bobj.Reference = obj.Reference
            s bobj.Specimen = obj.Specimen
            s bobj.ExecuteTime= obj.ExecuteTime
            s bobj.ReportTime = obj.ReportTime
            s bobj.Remarks = obj.Remarks
            s bobj.PassFlag = obj.PassFlag
            s bobj.LabResultFlag = obj.LabResultFlag
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.VisitID= eobj.VisitID
        s obj.VisitType = eobj.VisitType
        s obj.GroupFlag = eobj.GroupFlag
        s obj.GroupSequence = eobj.GroupSequence
        s obj.InspectionCode= eobj.InspectionCode
        s obj.InspectionName = eobj.InspectionName
        s obj.LabItemCode = eobj.LabItemCode
        s obj.LabItemName = eobj.LabItemName
        s obj.LabResult= eobj.LabResult
        s obj.Unit = eobj.Unit
        s obj.Reference = eobj.Reference
        s obj.Specimen = eobj.Specimen
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
        s obj.LabResultFlag = eobj.LabResultFlag
            
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
/// Table：WDT.CDSS.LabInfo
/// Other: d ##class(web.CDSS.PatientView.LabInfo).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.LabInfo).%New()
    s eobj = ##class(WDT.CDSS.LabInfo).%OpenId(id)
    s obj.LabID = id
	s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.VisitID= eobj.VisitID
    s obj.VisitType = eobj.VisitType
    s obj.GroupFlag = eobj.GroupFlag
    s obj.GroupSequence = eobj.GroupSequence
    s obj.InspectionCode= eobj.InspectionCode
    s obj.InspectionName = eobj.InspectionName
    s obj.LabItemCode = eobj.LabItemCode
    s obj.LabItemName = eobj.LabItemName
    s obj.LabResult= eobj.LabResult
    s obj.Unit = eobj.Unit
    s obj.Reference = eobj.Reference
    s obj.Specimen = eobj.Specimen
    s obj.ExecuteTime= eobj.ExecuteTime
    s obj.ReportTime = eobj.ReportTime
    s obj.Remarks = eobj.Remarks
    s:eobj.PassFlag="" obj.PassFlag="Y"
    s:eobj.PassFlag="1" obj.PassFlag="Y"
    s:eobj.PassFlag="0" obj.PassFlag="N"
    s obj.LabResultFlag = eobj.LabResultFlag
    
    d eobj.%Close()  
    
    s str = obj.JsonS() 
    
    q str
}

/// Creator:丁亚男
/// CreatDate:2020-05-08
/// Description:根据id删除
/// Table:WDT.CDSS.LabInfo
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.LabInfo).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.LabInfo).%DeleteId(id)
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
