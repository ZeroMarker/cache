/// 名称: 个人史
/// 描述: 获取个人史的信息
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-20
Class web.CDSS.PatientView.PersonalInfo Extends %RegisteredObject
{

/// Creator:dingyanan
/// CreatDate:2020-04-20
/// Description：获取患者个人史信息表信息 
/// Table：WDT.CDSS.PersonalInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型 Config配置信息（确定取数据的方式）
/// Output：按照固定格式返回患者个人史信息表的时间、名称、id
/// w ##class(web.CDSS.PatientView.PersonalInfo).GetPersoInfoForEcharts("ID000000001","YY001","")
ClassMethod GetPersoInfoForEcharts(IDNO As %String, PatientDR As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s PersonalInfo="",Info=""
	s PersonalID=0
	if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
	{	
		for
		{
			s PersonalID =$o(^WDT.CDSS.PersonalInfoI("PatDRIndex",PatientDR,PersonalID)) q:PersonalID=""
			s PersonalHistoryOverview=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),4)
			s StartTime="",EndTime=""
			s StartTime=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),5)
			s:StartTime'="" StartTime=$zdate(StartTime,3)
			s:StartTime'="" StartTime=$E(StartTime,1,4)
			s EndTime=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),6)
			if EndTime'="" s EndTime=$zdate(EndTime,3)
			if EndTime="" s EndTime=$zdate($h,3)
			s:EndTime'="" EndTime=$E(EndTime,1,4)
			
			s Info="{""PersonalID"":"""_PersonalID_""",""PersonalHistoryOverview"":"""_PersonalHistoryOverview_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_EndTime_"""}"	
			if (PersonalInfo="")
			{
				s PersonalInfo=Info
			}
			else
			{
				s PersonalInfo=PersonalInfo_","_Info
			}
		}
		
	}
	elseif (IDNO'="")  //患者主索引
	{
		for
		{
			s PersonalID =$o(^WDT.CDSS.PersonalInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),PersonalID)) q:PersonalID=""
			s PersonalHistoryOverview=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),4)
			s StartTime="",EndTime=""
			s StartTime=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),5)
			s:StartTime'="" StartTime=$zdate(StartTime,3)
			s:StartTime'="" StartTime=$E(StartTime,1,4)
			s EndTime=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),6)
			if EndTime'="" s EndTime=$zdate(EndTime,3)
			if EndTime="" s EndTime=$zdate($h,3)
			s:EndTime'="" EndTime=$E(EndTime,1,4)
			
			s Info="{""PersonalID"":"""_PersonalID_""",""PersonalHistoryOverview"":"""_PersonalHistoryOverview_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_EndTime_"""}"		
			if (PersonalInfo="")
			{
				s PersonalInfo=Info
			}
			else
			{
				s PersonalInfo=PersonalInfo_","_Info
			}
		}
	}
	return "["_PersonalInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-04-20
/// Description：获取患者个人史信息表单条信息 
/// Table：WDT.CDSS.PersonalInfo
/// Input：PersonalID 个人史表的id
/// Output：json格式返回个人史表的枚举字段
/// w ##class(web.CDSS.PatientView.PersonalInfo).GetPersoInfoForForm(1)
ClassMethod GetPersoInfoForForm(PersonalID As %String) As %String
{
	s PersonalInfo=""
	if (PersonalID'="")
	{
		s PersonalHistoryOverview=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),4)
		s StartTime=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),5)
		if StartTime'="" s StartTime=$zdate(StartTime,3)
		s EndTime=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),6)
		if EndTime'="" s EndTime=$zdate(EndTime,3)
		s Duration=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),7)
		s Criticality=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),8)
		s Remarks=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),9)
		s PassFlag=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),10)
		
		s PersonalInfo="{""PersonalID"":"""_PersonalID_""",""PersonalHistoryOverview"":"""_PersonalHistoryOverview_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_
			EndTime_""",""Duration"":"""_Duration_""",""Criticality"":"""_Criticality_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_"""}"
				
	}
	return PersonalInfo
}

/// Creator：丁亚男
/// CreatDate: 2020-05-12
/// Description：保存修改内容
/// Table：WDT.CDSS.PersonalInfo
/// Input：web.CDSSEntity.PatientView.PersonalInfo 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.PersonalInfo) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.PersonalID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.PersonalInfo).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.PersonalInfo).%OpenId(eobj.PersonalID)
            s bobj = ##class(web.CDSSEntity.PatientView.PersonalInfo).%New()
            s bobj.PersonalID = eobj.PersonalID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.PersonalHistoryOverview = obj.PersonalHistoryOverview
            s bobj.StartTime= obj.StartTime
            s bobj.EndTime = obj.EndTime
            s bobj.Duration = obj.Duration
            s bobj.Criticality = obj.Criticality
            s bobj.Remarks = obj.Remarks
            s bobj.PassFlag = obj.PassFlag
            
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.PersonalHistoryOverview = eobj.PersonalHistoryOverview
        s:eobj.StartTime'="" obj.StartTime= $zdh(eobj.StartTime,3)
        s:eobj.EndTime'="" obj.EndTime= $zdh(eobj.EndTime,3)
        s obj.Duration = eobj.Duration
        s obj.Criticality = eobj.Criticality
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
/// Table：WDT.CDSS.PersonalInfo
/// Other: d ##class(web.CDSS.PatientView.PersonalInfo).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.PersonalInfo).%New()
    s eobj = ##class(WDT.CDSS.PersonalInfo).%OpenId(id)
	s obj.PersonalID = id
    s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.PersonalHistoryOverview = eobj.PersonalHistoryOverview
    s:eobj.StartTime'="" obj.StartTime= $zd(eobj.StartTime,3)
    s:eobj.EndTime'="" obj.EndTime= $zd(eobj.EndTime,3)
    s obj.Duration = eobj.Duration
    s obj.Criticality = eobj.Criticality
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
/// Table:WDT.CDSS.PersonalInfo
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.PersonalInfo).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.PersonalInfo).%DeleteId(id)
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
