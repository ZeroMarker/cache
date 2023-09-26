/// 名称: 手术信息
/// 描述: 手术信息的增删改功能
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-24
Class web.CDSS.PatientView.OperationInfo Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-05-13
/// Description：保存修改内容
/// Table：WDT.CDSS.OperationInfo
/// Input：web.CDSSEntity.PatientView.OperationInfo 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.OperationInfo) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.OperID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.OperationInfo).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.OperationInfo).%OpenId(eobj.OperID)
            s bobj = ##class(web.CDSSEntity.PatientView.OperationInfo).%New()
            s bobj.OperID = eobj.OperID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.VisitID = obj.VisitID
            s bobj.VisitType = obj.VisitType
            s bobj.OperNum = obj.OperNum
            s bobj.OperSequence = obj.OperSequence
            s bobj.MainOperFlag = obj.MainOperFlag
            s bobj.OperCode= obj.OperCode
            s bobj.OperName = obj.OperName
            s bobj.OperDesc = obj.OperDesc
            s bobj.OperType = obj.OperType
            s bobj.OperPosition = obj.OperPosition
            s bobj.IntraoperDiagnosis = obj.IntraoperDiagnosis
            s bobj.OperDuration = obj.OperDuration
            s bobj.OperStartTime = obj.OperStartTime
            s bobj.OperEndTime= obj.OperEndTime
            s bobj.PassFlag = obj.PassFlag
            
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.VisitID = eobj.VisitID
        s obj.VisitType = eobj.VisitType
        s obj.OperNum = eobj.OperNum
        s obj.OperSequence = eobj.OperSequence
        s obj.MainOperFlag = eobj.MainOperFlag
        s obj.OperCode= eobj.OperCode
        s obj.OperName = eobj.OperName
        s obj.OperDesc = eobj.OperDesc
        s obj.OperType = eobj.OperType
        s obj.OperPosition = eobj.OperPosition
        s obj.IntraoperDiagnosis = eobj.IntraoperDiagnosis
        s obj.OperDuration = eobj.OperDuration
        s obj.OperStartTime = eobj.OperStartTime
        s obj.OperEndTime= eobj.OperEndTime
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
/// Table：WDT.CDSS.OperationInfo
/// Other: d ##class(web.CDSS.PatientView.OperationInfo).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.OperationInfo).%New()
    s eobj = ##class(WDT.CDSS.OperationInfo).%OpenId(id)
	s obj.OperID = id
    s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.VisitID = eobj.VisitID
    s obj.VisitType = eobj.VisitType
    s obj.OperNum = eobj.OperNum
    s obj.OperSequence = eobj.OperSequence
    s obj.MainOperFlag = eobj.MainOperFlag
    s obj.OperCode= eobj.OperCode
    s obj.OperName = eobj.OperName
    s obj.OperDesc = eobj.OperDesc
    s obj.OperType = eobj.OperType
    s obj.OperPosition = eobj.OperPosition
    s obj.IntraoperDiagnosis = eobj.IntraoperDiagnosis
    s obj.OperDuration = eobj.OperDuration
    s obj.OperStartTime = eobj.OperStartTime
    s obj.OperEndTime= eobj.OperEndTime
    s:eobj.PassFlag="1" obj.PassFlag="Y"
    s:eobj.PassFlag'="1" obj.PassFlag="N"
     
	d eobj.%Close()  
    s str = obj.JsonS()    
    q str
}

/// Creator:丁亚男
/// CreatDate:2020-05-13
/// Description:根据id删除
/// Table:WDT.CDSS.OperationInfo
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.OperationInfo).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.OperationInfo).%DeleteId(id)
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
