/// 名称: 处方信息
/// 描述: 处方信息的增删改功能
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-24
Class web.CDSS.PatientView.OtherDisOrderInfo Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-05-13
/// Description：保存修改内容
/// Table：WDT.CDSS.OtherDisOrderInfo
/// Input：web.CDSSEntity.PatientView.OtherDisOrderInfo 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.OtherDisOrderInfo) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.OtherDisOrderID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.OtherDisOrderInfo).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.OtherDisOrderInfo).%OpenId(eobj.OtherDisOrderID)
            s bobj = ##class(web.CDSSEntity.PatientView.OtherDisOrderInfo).%New()
            s bobj.OtherDisOrderID = eobj.OtherDisOrderID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.VisitID = obj.VisitID
            s bobj.GroupFlag = obj.GroupFlag
            s bobj.GroupSequence = obj.GroupSequence
            s bobj.OrderDesc= obj.OrderDesc
            s bobj.ExecuteMethod = obj.ExecuteMethod
            s bobj.PlanStartTime = obj.PlanStartTime
            s bobj.PlanStopTime = obj.PlanStopTime
            s bobj.ExecuteDesc = obj.ExecuteDesc
            s bobj.PassFlag = obj.PassFlag
            
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.VisitID = eobj.VisitID
        s obj.GroupFlag = eobj.GroupFlag
        s obj.GroupSequence = eobj.GroupSequence
        s obj.OrderDesc= eobj.OrderDesc
        s obj.ExecuteMethod = eobj.ExecuteMethod
        s:eobj.PlanStartTime'="" obj.PlanStartTime= $zdh(eobj.PlanStartTime,3)
    	s:eobj.PlanStopTime'="" obj.PlanStopTime= $zdh(eobj.PlanStopTime,3)
        s obj.ExecuteDesc = eobj.ExecuteDesc
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
/// Table：WDT.CDSS.OtherDisOrderInfo
/// Other: d ##class(web.CDSS.PatientView.OtherDisOrderInfo).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.OtherDisOrderInfo).%New()
    s eobj = ##class(WDT.CDSS.OtherDisOrderInfo).%OpenId(id)
	s obj.OtherDisOrderID = id
    s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.VisitID = eobj.VisitID
    s obj.GroupFlag = eobj.GroupFlag
    s obj.GroupSequence = eobj.GroupSequence
    s obj.OrderDesc= eobj.OrderDesc
    s obj.ExecuteMethod = eobj.ExecuteMethod
    s:eobj.PlanStartTime'="" obj.PlanStartTime= $zd(eobj.PlanStartTime,3)
    s:eobj.PlanStopTime'="" obj.PlanStopTime= $zd(eobj.PlanStopTime,3)
    s obj.ExecuteDesc = eobj.ExecuteDesc
    s:eobj.PassFlag="1" obj.PassFlag="Y"
    s:eobj.PassFlag'="1" obj.PassFlag="N"
     
	d eobj.%Close()  
    s str = obj.JsonS()    
    q str
}

/// Creator:丁亚男
/// CreatDate:2020-05-13
/// Description:根据id删除
/// Table:WDT.CDSS.OtherDisOrderInfo
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.OtherDisOrderInfo).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.OtherDisOrderInfo).%DeleteId(id)
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
