/// 名称: 婚育史
/// 描述: 获取婚育史的信息
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-21
Class web.CDSS.PatientView.MarryInfo Extends %RegisteredObject
{

/// Creator:dingyanan
/// CreatDate:2020-04-21
/// Description：获取患者婚育史信息表信息 
/// Table：WDT.CDSS.MarryInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型 Config配置信息（确定取数据的方式）
/// Output：按照固定格式返回患者婚育史信息表的时间、名称、id
/// w ##class(web.CDSS.PatientView.MarryInfo).GetMarryInfoForEcharts("ID000000001","YY001","")
ClassMethod GetMarryInfoForEcharts(IDNO As %String, PatientDR As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s MarryInfo="",Info=""
	s MarryID=0
	if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
	{	
		for
		{
			s MarryID =$o(^WDT.CDSS.MarryInfoI("PatDRIndex",PatientDR,MarryID)) q:MarryID=""
			s TypeOfMarriage=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),4)	
			s MarriageOverview=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),5)
			s StartTime=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),6)
			if StartTime'="" s StartTime=$zdate(StartTime,3)
			s EndTime=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),7)
			if EndTime'="" s EndTime=$zdate(EndTime,3)
			if EndTime="" s EndTime=$zdate($h,3)
			
			s Info="{""MarryID"":"""_MarryID_""",""TypeOfMarriage"":"""_TypeOfMarriage_""",""MarriageOverview"":"""_MarriageOverview_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_EndTime_"""}"	
			if (MarryInfo="")
			{
				s MarryInfo=Info
			}
			else
			{
				s MarryInfo=MarryInfo_","_Info
			}
		}
		
	}
	elseif (IDNO'="")  //患者主索引
	{
		for
		{
			s MarryID =$o(^WDT.CDSS.MarryInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),MarryID)) q:MarryID=""
			s TypeOfMarriage=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),4)	
			s MarriageOverview=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),5)
			s StartTime=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),6)
			if StartTime'="" s StartTime=$zdate(StartTime,3)
			s EndTime=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),7)
			if EndTime'="" s EndTime=$zdate(EndTime,3)
			if EndTime="" s EndTime=$zdate($h,3)
		
			s Info="{""MarryID"":"""_MarryID_""",""TypeOfMarriage"":"""_TypeOfMarriage_""",""MarriageOverview"":"""_MarriageOverview_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_EndTime_"""}"	
			if (MarryInfo="")
			{
				s MarryInfo=Info
			}
			else
			{
				s MarryInfo=MarryInfo_","_Info
			}
		}
	}
	return "["_MarryInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-04-21
/// Description：获取患者婚育史信息表单条信息 
/// Table：WDT.CDSS.MarryInfo
/// Input：PastID 婚育史表的id
/// Output：json格式返回婚育史表的枚举字段
/// w ##class(web.CDSS.PatientView.MarryInfo).GetMarryInfoForForm(1)
ClassMethod GetMarryInfoForForm(MarryID As %String) As %String
{
	s MarryInfo=""
	if (MarryID'="")
	{
		s TypeOfMarriage=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),4)	
		s MarriageOverview=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),5)
		s StartTime=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),6)
		if StartTime'="" s StartTime=$zdate(StartTime,3)
		s EndTime=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),7)
		if EndTime'="" s EndTime=$zdate(EndTime,3)
		s Duration=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),8)
		s Criticality=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),9)
		s Remarks=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),10)
		s PassFlag=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),11)
		
		s MarryInfo="{""MarryID"":"""_MarryID_""",""TypeOfMarriage"":"""_TypeOfMarriage_""",""MarriageOverview"":"""_MarriageOverview_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_EndTime_""",""Duration"":"""_Duration_""",""Criticality"":"""_
				Criticality_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_"""}"		
	}
	return MarryInfo
}

/// Creator：丁亚男
/// CreatDate: 2020-05-12
/// Description：保存修改内容
/// Table：WDT.CDSS.MarryInfo
/// Input：web.CDSSEntity.PatientView.MarryInfo 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.MarryInfo) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.MarryID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.MarryInfo).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.MarryInfo).%OpenId(eobj.MarryID)
            s bobj = ##class(web.CDSSEntity.PatientView.MarryInfo).%New()
            s bobj.MarryID = eobj.MarryID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.TypeOfMarriage = obj.TypeOfMarriage
            s bobj.MarriageOverview = obj.MarriageOverview
            s bobj.StartTime= obj.StartTime
            s bobj.EndTime = obj.EndTime
            s bobj.Duration = obj.Duration
            s bobj.Criticality = obj.Criticality
            s bobj.Remarks = obj.Remarks
            s bobj.PassFlag = obj.PassFlag
            
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.TypeOfMarriage = eobj.TypeOfMarriage
        s obj.MarriageOverview = eobj.MarriageOverview
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
/// Table：WDT.CDSS.MarryInfo
/// Other: d ##class(web.CDSS.PatientView.MarryInfo).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.MarryInfo).%New()
    s eobj = ##class(WDT.CDSS.MarryInfo).%OpenId(id)
	s obj.MarryID = id
    s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.TypeOfMarriage = eobj.TypeOfMarriage
    s obj.MarriageOverview = eobj.MarriageOverview
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
/// Table:WDT.CDSS.MarryInfo
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.MarryInfo).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.MarryInfo).%DeleteId(id)
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
