/// 名称: 麻醉信息
/// 描述: 麻醉信息的增删改功能
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-24
Class web.CDSS.PatientView.AnestInfo Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-05-13
/// Description：保存修改内容
/// Table：WDT.CDSS.AnestInfo
/// Input：web.CDSSEntity.PatientView.AnestInfo 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.AnestInfo) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.AnestID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.AnestInfo).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.AnestInfo).%OpenId(eobj.AnestID)
            s bobj = ##class(web.CDSSEntity.PatientView.AnestInfo).%New()
            s bobj.AnestID = eobj.AnestID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.VisitID = obj.VisitID
            s bobj.VisitType = obj.VisitType
            s bobj.AnestMedication = obj.AnestMedication
            s bobj.Usage = obj.Usage
            s bobj.Dose = obj.Dose
            s bobj.Anesthesia = obj.Anesthesia
            s bobj.AnestSite = obj.AnestSite
            s bobj.AnestDuration = obj.AnestDuration
            s bobj.AnestStartTime = obj.AnestStartTime
            s bobj.PassFlag = obj.PassFlag
            
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.VisitID = eobj.VisitID
        s obj.VisitType = eobj.VisitType
        s obj.AnestMedication = eobj.AnestMedication
        s obj.Usage = eobj.Usage
        s obj.Dose = eobj.Dose
        s obj.Anesthesia = eobj.Anesthesia
        s obj.AnestSite = eobj.AnestSite
        s obj.AnestDuration = eobj.AnestDuration
        s obj.AnestStartTime = eobj.AnestStartTime
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
/// Table：WDT.CDSS.AnestInfo
/// Other: d ##class(web.CDSS.PatientView.AnestInfo).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.AnestInfo).%New()
    s eobj = ##class(WDT.CDSS.AnestInfo).%OpenId(id)
	s obj.AnestID = id
    s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.VisitID = eobj.VisitID
    s obj.VisitType = eobj.VisitType
    s obj.AnestMedication = eobj.AnestMedication
    s obj.Usage = eobj.Usage
    s obj.Dose = eobj.Dose
    s obj.Anesthesia = eobj.Anesthesia
    s obj.AnestSite = eobj.AnestSite
    s obj.AnestDuration = eobj.AnestDuration
    s obj.AnestStartTime = eobj.AnestStartTime  
    s:eobj.PassFlag="1" obj.PassFlag="Y"
    s:eobj.PassFlag'="1" obj.PassFlag="N"
     
	d eobj.%Close()  
    s str = obj.JsonS()    
    q str
}

/// Creator:丁亚男
/// CreatDate:2020-05-13
/// Description:根据id删除
/// Table:WDT.CDSS.AnestInfo
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.AnestInfo).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.AnestInfo).%DeleteId(id)
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
