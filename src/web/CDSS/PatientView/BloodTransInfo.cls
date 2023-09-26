/// 名称: 处方信息
/// 描述: 处方信息的增删改功能
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-24
Class web.CDSS.PatientView.BloodTransInfo Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-05-13
/// Description：保存修改内容
/// Table：WDT.CDSS.BloodTransInfo
/// Input：web.CDSSEntity.PatientView.BloodTransInfo 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.BloodTransInfo) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.BloodID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.BloodTransInfo).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.BloodTransInfo).%OpenId(eobj.BloodID)
            s bobj = ##class(web.CDSSEntity.PatientView.BloodTransInfo).%New()
            s bobj.BloodID = eobj.BloodID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.VisitID = obj.VisitID
            s bobj.VisitType = obj.VisitType
            s bobj.BloodTransStartTime = obj.BloodTransStartTime
            s bobj.BloodTransEndTime = obj.BloodTransEndTime
            s bobj.BloodTransDuration = obj.BloodTransDuration
            s bobj.BloodTransVolume= obj.BloodTransVolume
            s bobj.BloodTransSite = obj.BloodTransSite
            s bobj.BloodTransType = obj.BloodTransType
            s bobj.BloodTransDurationU = obj.BloodTransDurationU
            s bobj.BloodTransVolumeU = obj.BloodTransVolumeU
            s bobj.BloodTransClass = obj.BloodTransClass
            s bobj.PassFlag = obj.PassFlag
            
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.VisitID = eobj.VisitID
        s obj.VisitType = eobj.VisitType
        s obj.BloodTransStartTime = eobj.BloodTransStartTime
        s obj.BloodTransEndTime = eobj.BloodTransEndTime
        s obj.BloodTransDuration = eobj.BloodTransDuration
        s obj.BloodTransVolume= eobj.BloodTransVolume
        s obj.BloodTransSite = eobj.BloodTransSite
        s obj.BloodTransType = eobj.BloodTransType
        s obj.BloodTransDurationU = eobj.BloodTransDurationU
        s obj.BloodTransVolumeU = eobj.BloodTransVolumeU
        s obj.BloodTransClass = eobj.BloodTransClass
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
/// Table：WDT.CDSS.BloodTransInfo
/// Other: d ##class(web.CDSS.PatientView.BloodTransInfo).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.BloodTransInfo).%New()
    s eobj = ##class(WDT.CDSS.BloodTransInfo).%OpenId(id)
	s obj.BloodID = id
    s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.VisitID = eobj.VisitID
    s obj.VisitType = eobj.VisitType
    s obj.BloodTransStartTime = eobj.BloodTransStartTime
    s obj.BloodTransEndTime = eobj.BloodTransEndTime
    s obj.BloodTransDuration = eobj.BloodTransDuration
    s obj.BloodTransVolume= eobj.BloodTransVolume
    s obj.BloodTransSite = eobj.BloodTransSite
    s obj.BloodTransType = eobj.BloodTransType
    s obj.BloodTransDurationU = eobj.BloodTransDurationU
    s obj.BloodTransVolumeU = eobj.BloodTransVolumeU
    s obj.BloodTransClass = eobj.BloodTransClass 
    s:eobj.PassFlag="1" obj.PassFlag="Y"
    s:eobj.PassFlag'="1" obj.PassFlag="N"
     
	d eobj.%Close()  
    s str = obj.JsonS()    
    q str
}

/// Creator:丁亚男
/// CreatDate:2020-05-13
/// Description:根据id删除
/// Table:WDT.CDSS.BloodTransInfo
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.BloodTransInfo).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.BloodTransInfo).%DeleteId(id)
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
