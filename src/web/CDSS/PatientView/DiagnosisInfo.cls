/// 名称: 诊疗时间轴
/// 描述: 获取诊疗时间轴的信息
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-24
Class web.CDSS.PatientView.DiagnosisInfo Extends %RegisteredObject
{

/// Creator:dingyanan
/// CreatDate:2020-04-24
/// Description：获取患者诊断信息表信息 
/// Table：WDT.CDSS.DiagnosisInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型 Config配置信息（确定取数据的方式）
/// Output：按照固定格式返回患者诊断信息表的时间、名称、id
/// w ##class(web.CDSS.PatientView.DiagnosisInfo).GetDiagInfoForEcharts("","DM000703","1")
ClassMethod GetDiagInfoForEcharts(IDNO As %String, PatientDR As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s UnKnoDateInfo="",DateInfo="",DiagnosisInfo="",Info=""
	s DiagnosisID=0
	if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
	{	
		for
		{
			s DiagnosisID =$o(^WDT.CDSS.DiagnosisInfoI("PatDRIndex",PatientDR,DiagnosisID)) q:DiagnosisID=""
			s DiagnosisName=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),9)
			s DiagnosisTime=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),11)
			if DiagnosisTime'="" s DiagnosisTime=$p(DiagnosisTime," ",1)
			s:DiagnosisTime'="" DiagnosisTime=$E(DiagnosisTime,1,4)
			s:DiagnosisTime="" DiagnosisTime=0
			s ProjectDataName=##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(DiagnosisName,"诊断")
			//s Info="["_DiagnosisTime_","""_DiagnosisName_""","_DiagnosisID_""","_ProjectDataName_"]"
			s Info="["_DiagnosisTime_","""_DiagnosisName_""","_DiagnosisID_","""_ProjectDataName_"""]"
			if (DiagnosisTime=0)
			{
				s:UnKnoDateInfo'="" UnKnoDateInfo=UnKnoDateInfo_","_Info
				s:UnKnoDateInfo="" UnKnoDateInfo=Info
			}
			else
			{
				s:DateInfo'="" DateInfo=DateInfo_","_Info
				s:DateInfo="" DateInfo=Info
			}
		}
		
	}
	elseif (IDNO'="")  //患者主索引
	{
		for
		{
			s DiagnosisID =$o(^WDT.CDSS.DiagnosisInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),DiagnosisID)) q:DiagnosisID=""
			s DiagnosisName=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),9)
			s DiagnosisTime=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),11)
			if DiagnosisTime'="" s DiagnosisTime=$p(DiagnosisTime," ",1)
			s:DiagnosisTime'="" DiagnosisTime=$E(DiagnosisTime,1,4)
			s:DiagnosisTime="" DiagnosisTime=0
			s ProjectDataName=##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(DiagnosisName,"诊断")
			//s Info="["_DiagnosisTime_","""_DiagnosisName_""","_DiagnosisID_""","_ProjectDataName_"]"
			s Info="["_DiagnosisTime_","""_DiagnosisName_""","_DiagnosisID_","""_ProjectDataName_"""]"
			if (DiagnosisTime=0)
			{
				s:UnKnoDateInfo'="" UnKnoDateInfo=UnKnoDateInfo_","_Info
				s:UnKnoDateInfo="" UnKnoDateInfo=Info
			}
			else
			{
				s:DateInfo'="" DateInfo=DateInfo_","_Info
				s:DateInfo="" DateInfo=Info
			}
		}
	}
	if (UnKnoDateInfo'="")
	{
	 	s DiagnosisInfo=UnKnoDateInfo
	 	if (DateInfo'="")
	 	{
		 	s DiagnosisInfo=DiagnosisInfo_","_DateInfo
		}
	}
	else
	{
		if (DateInfo'="")
	 	{
		 	s DiagnosisInfo=DateInfo
		}
	}
	return "["_DiagnosisInfo_"]"
}

/// Creator：丁亚男
/// CreatDate: 2020-05-13
/// Description：保存修改内容
/// Table：WDT.CDSS.DiagnosisInfo
/// Input：web.CDSSEntity.PatientView.DiagnosisInfo 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.DiagnosisInfo) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.DiagnosisID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.DiagnosisInfo).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.DiagnosisInfo).%OpenId(eobj.DiagnosisID)
            s bobj = ##class(web.CDSSEntity.PatientView.DiagnosisInfo).%New()
            s bobj.DiagnosisID = eobj.DiagnosisID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.VisitID = obj.VisitID
            s bobj.VisitType = obj.VisitType
            s bobj.DiagnosisType = obj.DiagnosisType
            s bobj.DiagnosisSequence = obj.DiagnosisSequence
            s bobj.DiagnosisCode = obj.DiagnosisCode
            s bobj.DiagnosisName= obj.DiagnosisName
            s bobj.DiagnosisDesc = obj.DiagnosisDesc
            s bobj.DiagnosisTime = obj.DiagnosisTime
            s bobj.DiagnosisStatus = obj.DiagnosisStatus
            s bobj.ChildDiagnosisFlag = obj.ChildDiagnosisFlag
            s bobj.PassFlag = obj.PassFlag
            
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.VisitID = eobj.VisitID
        s obj.VisitType = eobj.VisitType
        s obj.DiagnosisType = eobj.DiagnosisType
        s obj.DiagnosisSequence = eobj.DiagnosisSequence
        s obj.DiagnosisCode = eobj.DiagnosisCode
        s obj.DiagnosisName= eobj.DiagnosisName
        s obj.DiagnosisDesc = eobj.DiagnosisDesc
        s obj.DiagnosisTime= eobj.DiagnosisTime
        s obj.DiagnosisStatus = eobj.DiagnosisStatus
        i eobj.ChildDiagnosisFlag="Y"
        {
            s obj.ChildDiagnosisFlag = "1"
        }
        else
        {
            s obj.ChildDiagnosisFlag = "0"
        }
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
/// CreatDate: 2020-05-13
/// Description：获取修改时的记录
/// Table：WDT.CDSS.DiagnosisInfo
/// Other: d ##class(web.CDSS.PatientView.DiagnosisInfo).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.DiagnosisInfo).%New()
    s eobj = ##class(WDT.CDSS.DiagnosisInfo).%OpenId(id)
	s obj.DiagnosisID = id
    s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.VisitID = eobj.VisitID
    s obj.VisitType = eobj.VisitType
    s obj.DiagnosisType = eobj.DiagnosisType
    s obj.DiagnosisSequence = eobj.DiagnosisSequence
    s obj.DiagnosisCode = eobj.DiagnosisCode
    s obj.DiagnosisName= eobj.DiagnosisName
    s obj.DiagnosisDesc = eobj.DiagnosisDesc
    s obj.DiagnosisTime= eobj.DiagnosisTime
    s obj.DiagnosisStatus = eobj.DiagnosisStatus
    s:eobj.ChildDiagnosisFlag="1" obj.ChildDiagnosisFlag="Y"
    s:eobj.ChildDiagnosisFlag'="1" obj.ChildDiagnosisFlag="N"  
    s:eobj.PassFlag="1" obj.PassFlag="Y"
    s:eobj.PassFlag'="1" obj.PassFlag="N"
     
	d eobj.%Close()  
    s str = obj.JsonS()    
    q str
}

/// Creator:丁亚男
/// CreatDate:2020-05-13
/// Description:根据id删除
/// Table:WDT.CDSS.DiagnosisInfo
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.DiagnosisInfo).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.DiagnosisInfo).%DeleteId(id)
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
