/// 名称: 主诉信息
/// 描述: 获取主诉信息的信息
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-17
Class web.CDSS.PatientView.ChiefCompInfo Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-04-27
/// Description：保存修改内容
/// Table：WDT.CDSS.ChiefCompInfo
/// Input：web.CDSSEntity.PatientView. 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.ChiefCompInfo) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.CompID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.ChiefCompInfo).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.ChiefCompInfo).%OpenId(eobj.CompID)
            s bobj = ##class(web.CDSSEntity.PatientView.ChiefCompInfo).%New()
            s bobj.CompID = eobj.CompID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.VisitID= obj.VisitID
            s bobj.VisitType = obj.VisitType
            s bobj.SymptomNum = obj.SymptomNum
            s:obj.PartDR'="" bobj.PartDR = obj.PartDR.%Id()
            s bobj.Symptom= obj.Symptom
            s bobj.Duration = obj.Duration
            s bobj.AbnormalMax = obj.AbnormalMax
            s bobj.AbnormalMin = obj.AbnormalMin
            s bobj.NormalMax= obj.NormalMax
            s bobj.NormalMin = obj.NormalMin
            s bobj.RangeUnit = obj.RangeUnit
            s bobj.RangeType = obj.RangeType
            s bobj.Cause= obj.Cause
            s bobj.PassFlag = obj.PassFlag
            
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.VisitID= eobj.VisitID
        s obj.VisitType = eobj.VisitType
        s obj.SymptomNum = eobj.SymptomNum
        d:eobj.PartDR'="" obj.PartDRSetObjectId(eobj.PartDR)
        s obj.Symptom= eobj.Symptom
        s obj.Duration = eobj.Duration
        s obj.AbnormalMax = eobj.AbnormalMax
        s obj.AbnormalMin = eobj.AbnormalMin
        s obj.NormalMax= eobj.NormalMax
        s obj.NormalMin = eobj.NormalMin
        s obj.RangeUnit = eobj.RangeUnit
        s obj.RangeType = eobj.RangeType
        s obj.Cause= eobj.Cause
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
/// CreatDate: 2020-04-27
/// Description：获取修改时的记录
/// Table：WDT.CDSS.ChiefCompInfo
/// Other: d ##class(web.CDSS.PatientView.ChiefCompInfo).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.ChiefCompInfo).%New()
    s eobj = ##class(WDT.CDSS.ChiefCompInfo).%OpenId(id)
	s obj.CompID = id
    s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.VisitID= eobj.VisitID
    s obj.VisitType = eobj.VisitType
    s obj.SymptomNum = eobj.SymptomNum
    s:eobj.PartDR'="" obj.PartDR = eobj.PartDR.%Id()
    s obj.Symptom= eobj.Symptom
    s obj.Duration = eobj.Duration
    s obj.AbnormalMax = eobj.AbnormalMax
    s obj.AbnormalMin = eobj.AbnormalMin
    s obj.NormalMax= eobj.NormalMax
    s obj.NormalMin = eobj.NormalMin
    s obj.RangeUnit = eobj.RangeUnit
    s obj.RangeType = eobj.RangeType
    s obj.Cause= eobj.Cause   
    s:eobj.PassFlag="" obj.PassFlag="Y"
    s:eobj.PassFlag="1" obj.PassFlag="Y"
    s:eobj.PassFlag="0" obj.PassFlag="N"
     
	d eobj.%Close()  
    s str = obj.JsonS()    
    q str
}

/// Creator:丁亚男
/// CreatDate:2020-04-27
/// Description:根据id删除
/// Table:WDT.CDSS.ChiefCompInfo
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.ChiefCompInfo).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.ChiefCompInfo).%DeleteId(id)
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
