/// 名称: 护理信息
/// 描述: 获取护理信息的信息
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-05-08
Class web.CDSS.PatientView.NursingInfo Extends %RegisteredObject
{

/// Creator:zhaowenwei
/// CreatDate:2022-09-08
/// Description：获取患者护理信息表信息 
/// Table：WDT.CDSS.NursingInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者处方信息表枚举字段的json串
/// w ##class(web.CDSS.PatientView.NursingInfo).GetNursingInfo("DM000729","DM000729","1","")
ClassMethod GetNursingInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String = "", Config As %String) As %String
{
	s NursingInfo="",Info=""
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	if (Config=1)&(PatientDR'="")&(VisitID'="")&(VisitType'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.NursingInfoI("PatVisDRNursNumTIndex",PatientDR,VisitID,VisitType)))
		{	
			s NursingItemNum=0
			for
			{
				s NursingItemNum =$o(^WDT.CDSS.NursingInfoI("PatVisDRNursNumTIndex",PatientDR,VisitID,VisitType,NursingItemNum)) q:NursingItemNum=""
				s NursID=0
				for
				{
					s NursID =$o(^WDT.CDSS.NursingInfoI("PatVisDRNursNumTIndex",PatientDR,VisitID,VisitType,NursingItemNum,NursID)) q:NursID=""
					s NursingItemCode=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),7)
					s NursingItemName=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),8)
					s ChildItemNum=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),9)
					s ChildItemCode=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),10)
					s ChildItemName=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),11)
					s NursingEffect=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),12)
					s PassFlag=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),13)
				
					s Info="{""NursingItemCode"":"""_NursingItemCode_""",""NursingItemName"":"""_NursingItemName_""",""NursingItemNum"":"""_NursingItemNum_""",""NursID"":"""_NursID
					_""",""ChildItemCode"":"""_ChildItemCode_""",""ChildItemName"":"""_ChildItemName_""",""NursingEffect"":"""_NursingEffect_""",""ChildItemNum"":"""_ChildItemNum_""",""PassFlag"":"""_PassFlag_"""}"
					
					if (NursingInfo="")
					{
						s NursingInfo=Info			
					}
					else
					{
						s NursingInfo=NursingInfo_","_Info			
					}
				}
			}	
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s NursingItemNum=0
		for
		{
			s NursingItemNum =$o(^WDT.CDSS.NursingInfoI("IDNONursNumTIndex",IDNO,NursingItemNum)) q:NursingItemNum=""
			s NursID=0
			for
			{
				s NursID =$o(^WDT.CDSS.NursingInfoI("IDNONursNumTIndex",IDNO,NursingItemNum,NursID)) q:NursID=""
				s NursingItemCode=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),7)
				s NursingItemName=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),8)
				s ChildItemNum=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),9)
				s ChildItemCode=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),10)
				s ChildItemName=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),11)
				s NursingEffect=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),12)
				s PassFlag=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),13)
			
				s Info="{""NursingItemCode"":"""_NursingItemCode_""",""NursingItemName"":"""_NursingItemName_""",""NursingItemNum"":"""_NursingItemNum_""",""NursID"":"""_NursID
					_""",""ChildItemCode"":"""_ChildItemCode_""",""ChildItemName"":"""_ChildItemName_""",""NursingEffect"":"""_NursingEffect_""",""ChildItemNum"":"""_ChildItemNum_""",""PassFlag"":"""_PassFlag_"""}"
						
				if (NursingInfo="")
				{
					s NursingInfo=Info			
				}
				else
				{
					s NursingInfo=NursingInfo_","_Info			
				}	
			}	
		}	
	}
	
	return "["_NursingInfo_"]"
}

/// Creator：丁亚男
/// CreatDate: 2020-05-08
/// Description：保存修改内容
/// Table：WDT.CDSS.NursingInfo
/// Input：web.CDSSEntity.PatientView.NursingInfo 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.NursingInfo) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.NursID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.NursingInfo).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.NursingInfo).%OpenId(eobj.NursID)
            s bobj = ##class(web.CDSSEntity.PatientView.NursingInfo).%New()
            s bobj.NursID = eobj.NursID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.VisitID= obj.VisitID
            s bobj.VisitType = obj.VisitType
            s bobj.NursingItemNum = obj.NursingItemNum
            s bobj.NursingItemCode= obj.NursingItemCode
            s bobj.NursingItemName = obj.NursingItemName
            s bobj.ChildItemNum = obj.ChildItemNum
            s bobj.ChildItemCode = obj.ChildItemCode
            s bobj.ChildItemName= obj.ChildItemName
            s bobj.NursingEffect = obj.NursingEffect
            s bobj.PassFlag = obj.PassFlag
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.VisitID= eobj.VisitID
        s obj.VisitType = eobj.VisitType
        s obj.NursingItemNum = eobj.NursingItemNum
        s obj.NursingItemCode= eobj.NursingItemCode
        s obj.NursingItemName = eobj.NursingItemName
        s obj.ChildItemNum = eobj.ChildItemNum
        s obj.ChildItemCode = eobj.ChildItemCode
        s obj.ChildItemName= eobj.ChildItemName
        s obj.NursingEffect = eobj.NursingEffect
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
/// CreatDate: 2020-05-08
/// Description：获取修改时的记录
/// Table：WDT.CDSS.NursingInfo
/// Other: d ##class(web.CDSS.PatientView.NursingInfo).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.NursingInfo).%New()
    s eobj = ##class(WDT.CDSS.NursingInfo).%OpenId(id)
    s obj.NursID = id
	s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.VisitID= eobj.VisitID
    s obj.VisitType = eobj.VisitType
    s obj.NursingItemNum = eobj.NursingItemNum
    s obj.NursingItemCode= eobj.NursingItemCode
    s obj.NursingItemName = eobj.NursingItemName
    s obj.ChildItemNum = eobj.ChildItemNum
    s obj.ChildItemCode = eobj.ChildItemCode
    s obj.ChildItemName= eobj.ChildItemName
    s obj.NursingEffect = eobj.NursingEffect
    s:eobj.PassFlag="" obj.PassFlag="Y"
    s:eobj.PassFlag="1" obj.PassFlag="Y"
    s:eobj.PassFlag="0" obj.PassFlag="N"
   
    d eobj.%Close()  
    
    s str = obj.JsonS() 
    
    q str
}

/// Creator:丁亚男
/// CreatDate:2020-05-08
/// Description:根据id删除
/// Table:WDT.CDSS.NursingInfo
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.NursingInfo).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.NursingInfo).%DeleteId(id)
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
