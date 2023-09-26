/// 名称: 个人史
/// 描述: 获取个人史的信息
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-20
Class web.CDSS.PatientView.AllergyHistory Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-05-12
/// Description：保存修改内容
/// Table：WDT.CDSS.AllergyHistory
/// Input：web.CDSSEntity.PatientView.AllergyHistory 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.AllergyHistory) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.AllergyID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.AllergyHistory).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.AllergyHistory).%OpenId(eobj.AllergyID)
            s bobj = ##class(web.CDSSEntity.PatientView.AllergyHistory).%New()
            s bobj.AllergyID = eobj.AllergyID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.AllergySourceName = obj.AllergySourceName
            s bobj.AllergySourceType = obj.AllergySourceType
            s bobj.AllergyHistoryNum = obj.AllergyHistoryNum
            s bobj.StartTime= obj.StartTime
            s bobj.EndTime = obj.EndTime
            s bobj.RiskLevel = obj.RiskLevel
            s bobj.TreatmentEffect = obj.TreatmentEffect
            s bobj.Remarks = obj.Remarks
            s bobj.PassFlag = obj.PassFlag
            
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.AllergySourceName = eobj.AllergySourceName
        s obj.AllergySourceType = eobj.AllergySourceType
        s obj.AllergyHistoryNum = eobj.AllergyHistoryNum
        s:eobj.StartTime'="" obj.StartTime= $zdh(eobj.StartTime,3)
        s:eobj.EndTime'="" obj.EndTime= $zdh(eobj.EndTime,3)
        s obj.RiskLevel = eobj.RiskLevel
        s obj.TreatmentEffect = eobj.TreatmentEffect
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
/// Table：WDT.CDSS.AllergyHistory
/// Other: d ##class(web.CDSS.PatientView.AllergyHistory).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s obj = ##class(web.CDSSEntity.PatientView.AllergyHistory).%New()
    s eobj = ##class(WDT.CDSS.AllergyHistory).%OpenId(id)
	s obj.AllergyID = id
    s obj.IDNO = eobj.IDNO
    s obj.PatientDR = eobj.PatientDR
    s obj.AllergySourceName = eobj.AllergySourceName
    s obj.AllergySourceType = eobj.AllergySourceType
    s obj.AllergyHistoryNum = eobj.AllergyHistoryNum
    s:eobj.StartTime'="" obj.StartTime= $zd(eobj.StartTime,3)
    s:eobj.EndTime'="" obj.EndTime= $zd(eobj.EndTime,3)
    s obj.RiskLevel = eobj.RiskLevel
    s obj.TreatmentEffect = eobj.TreatmentEffect
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
/// Table:WDT.CDSS.AllergyHistory
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.AllergyHistory).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    Tstart
    s sc=##class(WDT.CDSS.AllergyHistory).%DeleteId(id)
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
