/// 名称: 处方信息
/// 描述: 处方信息的增删改功能
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-24
Class web.CDSS.PatientView.CarryDrug Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-05-13
/// Description：保存修改内容
/// Table：WDT.CDSS.CarryDrug
/// Input：web.CDSSEntity.PatientView.CarryDrug 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.CarryDrug) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.CarryDrugID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.CarryDrug).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.CarryDrug).%OpenId(eobj.CarryDrugID)
            s bobj = ##class(web.CDSSEntity.PatientView.CarryDrug).%New()
            s bobj.CarryDrugID = eobj.CarryDrugID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.VisitID = obj.VisitID
            s bobj.GroupFlag = obj.GroupFlag
            s bobj.GroupSequence = obj.GroupSequence
            s bobj.DrugCode= obj.DrugCode
            s bobj.DrugName = obj.DrugName
            s bobj.Usage = obj.Usage
            s bobj.Dose = obj.Dose
            s bobj.Frequency = obj.Frequency
            s bobj.Unit = obj.Unit
            s bobj.Specification = obj.Specification
            s bobj.StartTime = obj.StartTime
            s bobj.StopTime = obj.StopTime
            s bobj.Remarks = obj.Remarks
            s bobj.PassFlag = obj.PassFlag
            
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.VisitID = eobj.VisitID
        s obj.GroupFlag = eobj.GroupFlag
        s obj.GroupSequence = eobj.GroupSequence
        s obj.DrugCode= eobj.DrugCode
        s obj.DrugName = eobj.DrugName
        s obj.Usage = eobj.Usage
        s obj.Dose = eobj.Dose
        s obj.Frequency = eobj.Frequency
        s obj.Unit = eobj.Unit
        s obj.Specification = eobj.Specification
        s:eobj.StartTime'="" obj.StartTime= $zdh(eobj.StartTime,3)
    	s:eobj.StopTime'="" obj.StopTime= $zdh(eobj.StopTime,3)
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
/// CreatDate: 2020-05-13
/// Description：获取修改时的记录
/// Table：WDT.CDSS.CarryDrug
/// Other: d ##class(web.CDSS.PatientView.CarryDrug).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.CarryDrug).%New()
    s eobj = ##class(WDT.CDSS.CarryDrug).%OpenId(id)
	s obj.CarryDrugID = id
    s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.VisitID = eobj.VisitID
    s obj.GroupFlag = eobj.GroupFlag
    s obj.GroupSequence = eobj.GroupSequence
    s obj.DrugCode= eobj.DrugCode
    s obj.DrugName = eobj.DrugName
    s obj.Usage = eobj.Usage
    s obj.Dose = eobj.Dose
    s obj.Frequency = eobj.Frequency
    s obj.Unit = eobj.Unit
    s obj.Specification = eobj.Specification
    s:eobj.StartTime'="" obj.StartTime= $zd(eobj.StartTime,3)
    s:eobj.StopTime'="" obj.StopTime= $zd(eobj.StopTime,3)
    s obj.Remarks = eobj.Remarks  
    s:eobj.PassFlag="1" obj.PassFlag="Y"
    s:eobj.PassFlag'="1" obj.PassFlag="N"
     
	d eobj.%Close()  
    s str = obj.JsonS()    
    q str
}

/// Creator:丁亚男
/// CreatDate:2020-05-13
/// Description:根据id删除
/// Table:WDT.CDSS.CarryDrug
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.CarryDrug).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.CarryDrug).%DeleteId(id)
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
