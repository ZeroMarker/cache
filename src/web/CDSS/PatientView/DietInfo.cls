/// 名称: 患者饮食信息
/// 描述: 患者饮食信息的增删改功能
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-24
Class web.CDSS.PatientView.DietInfo Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-05-13
/// Description：保存修改内容
/// Table：WDT.CDSS.DietInfo
/// Input：web.CDSSEntity.PatientView.DietInfo 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.DietInfo) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.DietID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.DietInfo).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.DietInfo).%OpenId(eobj.DietID)
            s bobj = ##class(web.CDSSEntity.PatientView.DietInfo).%New()
            s bobj.DietID = eobj.DietID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.VisitID = obj.VisitID
            s bobj.VisitType = obj.VisitType
            s bobj.GroupFlag = obj.GroupFlag
            s bobj.GroupSequence = obj.GroupSequence
            s bobj.DietMethod= obj.DietMethod
            s bobj.DietType = obj.DietType
            s bobj.DietContent = obj.DietContent
            s bobj.DietAmount = obj.DietAmount
            s bobj.DietInstructions = obj.DietInstructions
            s bobj.Duration = obj.Duration
            s bobj.StartTime = obj.StartTime
            s bobj.EndTime = obj.EndTime
            s bobj.PassFlag = obj.PassFlag
            
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.VisitID = eobj.VisitID
        s obj.VisitType = eobj.VisitType
        s obj.GroupFlag = eobj.GroupFlag
        s obj.GroupSequence = eobj.GroupSequence
        s obj.DietMethod= eobj.DietMethod
        s obj.DietType = eobj.DietType
        s obj.DietContent = eobj.DietContent
        s obj.DietAmount = eobj.DietAmount
        s obj.DietInstructions = eobj.DietInstructions
        s obj.Duration = eobj.Duration
        s obj.StartTime= eobj.StartTime
        s obj.EndTime= eobj.EndTime
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
/// Table：WDT.CDSS.DietInfo
/// Other: d ##class(web.CDSS.PatientView.DietInfo).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.DietInfo).%New()
    s eobj = ##class(WDT.CDSS.DietInfo).%OpenId(id)
	s obj.DietID = id
    s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.VisitID = eobj.VisitID
    s obj.VisitType = eobj.VisitType
    s obj.Type = eobj.Type
    s obj.GroupFlag = eobj.GroupFlag
    s obj.GroupSequence = eobj.GroupSequence
    s obj.DietMethod= eobj.DietMethod
    s obj.DietType = eobj.DietType
    s obj.DietContent = eobj.DietContent
    s obj.DietAmount = eobj.DietAmount
    s obj.DietInstructions = eobj.DietInstructions
    s obj.Duration = eobj.Duration
    s obj.StartTime= eobj.StartTime
    s obj.EndTime= eobj.EndTime
    s:eobj.PassFlag="1" obj.PassFlag="Y"
    s:eobj.PassFlag'="1" obj.PassFlag="N"
     
	d eobj.%Close()  
    s str = obj.JsonS()    
    q str
}

/// Creator:丁亚男
/// CreatDate:2020-05-13
/// Description:根据id删除
/// Table:WDT.CDSS.DietInfo
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.DietInfo).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.DietInfo).%DeleteId(id)
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
