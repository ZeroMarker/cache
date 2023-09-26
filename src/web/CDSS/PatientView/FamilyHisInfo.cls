/// 名称: 家族史
/// 描述: 获取家族史的信息
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-20
Class web.CDSS.PatientView.FamilyHisInfo Extends %RegisteredObject
{

/// Creator:dingyanan
/// CreatDate:2020-04-20
/// Description：获取患者家族史信息表信息 
/// Table：WDT.CDSS.FamilyHisInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型 Config配置信息（确定取数据的方式）
/// Output：按照固定格式返回患者家族史信息表的时间、名称、id
/// w ##class(web.CDSS.PatientView.FamilyHisInfo).GetFamilyHisInfoForEcharts("ID000000001","YY001","1")
ClassMethod GetFamilyHisInfoForEcharts(IDNO As %String, PatientDR As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s FamilyHisInfo="",HisInfo=""
	if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
	{	
		s Relationship=0
		for
		{
			s Relationship =$o(^WDT.CDSS.FamilyHisInfoI("PatDRRelationIndex",PatientDR,Relationship)) q:Relationship=""
			s FamilyHisIDs="",GeneticDiseNames="",ProjectDataNames=""
			s FamilyHisID=0
			for
			{
				s FamilyHisID =$o(^WDT.CDSS.FamilyHisInfoI("PatDRRelationIndex",PatientDR,Relationship,FamilyHisID)) q:FamilyHisID=""
				s Relationship=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),4)
				s RelativeName=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),5)
				s GeneticDiseName=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),7)
				s ProjectDataName=##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(GeneticDiseName,"诊断")
				
				s:FamilyHisIDs'="" FamilyHisIDs=FamilyHisIDs_","_FamilyHisID
				s:FamilyHisIDs="" FamilyHisIDs=FamilyHisID
				s:GeneticDiseNames'="" GeneticDiseNames=GeneticDiseNames_","_GeneticDiseName
				s:GeneticDiseNames="" GeneticDiseNames=GeneticDiseName
				s:ProjectDataNames'="" ProjectDataNames=ProjectDataNames_","_$SELECT(ProjectDataName="":GeneticDiseName,1:ProjectDataName)
				s:ProjectDataNames="" ProjectDataNames=$SELECT(ProjectDataName="":GeneticDiseName,1:ProjectDataName)
			}	
			s HisInfo="{""FamilyHisID"":"""_FamilyHisIDs_""",""Relationship"":"""_Relationship_""",""RelativeName"":"""_RelativeName_""",""GeneticDiseName"":"""_GeneticDiseNames_""",""ProjectDataName"":"""_ProjectDataNames_"""}"	
			if (FamilyHisInfo="")
			{
				s FamilyHisInfo=HisInfo
			}
			else
			{
				s FamilyHisInfo=FamilyHisInfo_","_HisInfo
			}
			
		}
		
	}
	elseif (IDNO'="")  //患者主索引
	{
		s Relationship=0
		for
		{
			s Relationship =$o(^WDT.CDSS.FamilyHisInfoI("IDNORelationIndex",IDNO,Relationship)) q:Relationship=""
			s FamilyHisIDs="",GeneticDiseNames="",ProjectDataNames=""
			s FamilyHisID=0
			for
			{
				s FamilyHisID =$o(^WDT.CDSS.FamilyHisInfoI("IDNORelationIndex",IDNO,Relationship,FamilyHisID)) q:FamilyHisID=""
				s Relationship=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),4)
				s RelativeName=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),5)
				s GeneticDiseName=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),7)
				s ProjectDataName=##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(GeneticDiseName,"诊断")
				
				s:FamilyHisIDs'="" FamilyHisIDs=FamilyHisIDs_","_FamilyHisID
				s:FamilyHisIDs="" FamilyHisIDs=FamilyHisID
				s:GeneticDiseNames'="" GeneticDiseNames=GeneticDiseNames_","_GeneticDiseName
				s:GeneticDiseNames="" GeneticDiseNames=GeneticDiseName
				s:ProjectDataNames'="" ProjectDataNames=ProjectDataNames_","_$SELECT(ProjectDataName="":GeneticDiseName,1:ProjectDataName)
				s:ProjectDataNames="" ProjectDataNames=$SELECT(ProjectDataName="":GeneticDiseName,1:ProjectDataName)
			}	
			s HisInfo="{""FamilyHisID"":"""_FamilyHisIDs_""",""Relationship"":"""_Relationship_""",""RelativeName"":"""_RelativeName_""",""GeneticDiseName"":"""_GeneticDiseNames_""",""ProjectDataName"":"""_ProjectDataNames_"""}"	
			if (FamilyHisInfo="")
			{
				s FamilyHisInfo=HisInfo
			}
			else
			{
				s FamilyHisInfo=FamilyHisInfo_","_HisInfo
			}
			
		}
	}
	return "["_FamilyHisInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-04-20
/// Description：获取患者家族史信息表单条信息 
/// Table：WDT.CDSS.FamilyHisInfo
/// Input：FamilyHisIDs 家族史表的id串
/// Output：json格式返回家族史表的枚举字段
/// w ##class(web.CDSS.PatientView.FamilyHisInfo).GetFamilyHisInfoForForm("1,3")
ClassMethod GetFamilyHisInfoForForm(FamilyHisIDs As %String) As %String
{
	s FamilyHisInfo="",HisInfo=""
	if (FamilyHisIDs'="")
	{
		s IDLength=$L(FamilyHisIDs,",")
		for ifamily=1:1:IDLength
		{
			s FamilyHisID=$p(FamilyHisIDs,",",ifamily)
			s Relationship=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),4)
			s RelativeName=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),5)
			s GeneticDiseNo=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),6)
			s GeneticDiseName=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),7)
			s ConditionDescription=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),8)
			s StartTime=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),9)
			if StartTime'="" s StartTime=$zdate(StartTime,3)
			s EndTime=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),10)
			if EndTime'="" s EndTime=$zdate(EndTime,3)
			s Duration=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),11)
			s Criticality=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),12)
			s IsCure=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),13)
			s Remarks=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),14)
			s PassFlag=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),15)
			
			s HisInfo="{""FamilyHisID"":"""_FamilyHisID_""",""Relationship"":"""_Relationship_""",""RelativeName"":"""_RelativeName_""",""GeneticDiseNo"":"""_
				GeneticDiseNo_""",""GeneticDiseName"":"""_GeneticDiseName_""",""ConditionDescription"":"""_ConditionDescription_""",""StartTime"":"""_
				StartTime_""",""EndTime"":"""_EndTime_""",""Duration"":"""_Duration_""",""Criticality"":"""_Criticality_""",""IsCure"":"""_
				IsCure_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_"""}"
				
			if (FamilyHisInfo="")
			{
				s FamilyHisInfo=HisInfo
			}
			else
			{
				s FamilyHisInfo=FamilyHisInfo_","_HisInfo
			}	
		}	
	
	}
	return "["_FamilyHisInfo_"]"
}

/// Creator：丁亚男
/// CreatDate: 2020-05-12
/// Description：保存修改内容
/// Table：WDT.CDSS.FamilyHisInfo
/// Input：web.CDSSEntity.PatientView.FamilyHisInfo 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.FamilyHisInfo) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.FamilyHisID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.FamilyHisInfo).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.FamilyHisInfo).%OpenId(eobj.FamilyHisID)
            s bobj = ##class(web.CDSSEntity.PatientView.FamilyHisInfo).%New()
            s bobj.FamilyHisID = eobj.FamilyHisID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.Relationship = obj.Relationship
            s bobj.RelativeName= obj.RelativeName
            s bobj.GeneticDiseNo = obj.GeneticDiseNo
            s bobj.GeneticDiseName = obj.GeneticDiseName
            s bobj.ConditionDescription = obj.ConditionDescription
            s bobj.StartTime= obj.StartTime
            s bobj.EndTime = obj.EndTime
            s bobj.Duration = obj.Duration
            s bobj.Criticality = obj.Criticality
            s bobj.IsCure = obj.IsCure
            s bobj.Remarks = obj.Remarks
            s bobj.PassFlag = obj.PassFlag
            
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.Relationship = eobj.Relationship
        s obj.RelativeName= eobj.RelativeName
        s obj.GeneticDiseNo = eobj.GeneticDiseNo
        s obj.GeneticDiseName = eobj.GeneticDiseName
        s obj.ConditionDescription = eobj.ConditionDescription
        
        s:eobj.StartTime'="" obj.StartTime= $zdh(eobj.StartTime,3)
        s:eobj.EndTime'="" obj.EndTime= $zdh(eobj.EndTime,3)
        s obj.Duration = eobj.Duration
        s obj.Criticality = eobj.Criticality
        s obj.IsCure = eobj.IsCure
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
/// Table：WDT.CDSS.FamilyHisInfo
/// Other: d ##class(web.CDSS.PatientView.FamilyHisInfo).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.FamilyHisInfo).%New()
    s eobj = ##class(WDT.CDSS.FamilyHisInfo).%OpenId(id)
	s obj.FamilyHisID = id
    s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.Relationship = eobj.Relationship
    s obj.RelativeName= eobj.RelativeName
    s obj.GeneticDiseNo = eobj.GeneticDiseNo
    s obj.GeneticDiseName = eobj.GeneticDiseName
    s obj.ConditionDescription = eobj.ConditionDescription
    s:eobj.StartTime'="" obj.StartTime= $zd(eobj.StartTime,3)
    s:eobj.EndTime'="" obj.EndTime= $zd(eobj.EndTime,3)
    s obj.Duration = eobj.Duration
    s obj.Criticality = eobj.Criticality
    s obj.IsCure = eobj.IsCure
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
/// Table:WDT.CDSS.FamilyHisInfo
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.FamilyHisInfo).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.FamilyHisInfo).%DeleteId(id)
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
