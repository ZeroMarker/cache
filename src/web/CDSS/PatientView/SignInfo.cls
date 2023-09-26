/// 名称: 体征信息
/// 描述: 获取体征信息的信息
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-17
Class web.CDSS.PatientView.SignInfo Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-04-27
/// Description：保存修改内容
/// Table：WDT.CDSS.SignInfo
/// Input：web.CDSSEntity.PatientView.SignInfo 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.CDSSEntity.PatientView.SignInfo) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.SignID="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.SignInfo).%New()
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.SignInfo).%OpenId(eobj.SignID)
            s bobj = ##class(web.CDSSEntity.PatientView.SignInfo).%New()
            s bobj.SignID = eobj.SignID
            s bobj.IDNO = obj.IDNO
            s bobj.PatientDR = obj.PatientDR
            s bobj.VisitID= obj.VisitID
            s bobj.VisitType = obj.VisitType
            s bobj.BodyTemperature = obj.BodyTemperature
            s bobj.BloodPressure = obj.BloodPressure
            s bobj.Pulse= obj.Pulse
            s bobj.BreathFeature = obj.BreathFeature
            s bobj.HeartRate = obj.HeartRate
            s bobj.OxygenSaturation = obj.OxygenSaturation
            s bobj.Pupil= obj.Pupil
            s bobj.CornealReflex = obj.CornealReflex
            s bobj.Height = obj.Height
            s bobj.Weight = obj.Weight
            s bobj.MeasureDate= obj.MeasureDate
            s bobj.PassFlag = obj.PassFlag
            s bobj.DiastolicBlood = obj.DiastolicBlood
            s bobj.SystolicBlood = obj.SystolicBlood
        }
        s obj.IDNO = eobj.IDNO
        s obj.PatientDR = eobj.PatientDR
        s obj.VisitID= eobj.VisitID
        s obj.VisitType = eobj.VisitType
        s obj.BodyTemperature = eobj.BodyTemperature
        s obj.BloodPressure = eobj.BloodPressure
        s obj.Pulse= eobj.Pulse
        s obj.BreathFeature = eobj.BreathFeature
        s obj.HeartRate = eobj.HeartRate
        s obj.OxygenSaturation = eobj.OxygenSaturation
        s obj.Pupil= eobj.Pupil
        s obj.CornealReflex = eobj.CornealReflex
        s obj.Height = eobj.Height
        s obj.Weight = eobj.Weight
        s obj.MeasureDate= eobj.MeasureDate
        i eobj.PassFlag="Y"
        {
            s obj.PassFlag = "1"
        }
        else
        {
            s obj.PassFlag = "0"
        }
        s obj.DiastolicBlood = eobj.DiastolicBlood
        s obj.SystolicBlood = eobj.SystolicBlood
            
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
/// Table：WDT.CDSS.SignInfo
/// Other: d ##class(web.CDSS.PatientView.SignInfo).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.CDSSEntity.PatientView.SignInfo).%New()
    s pobj = ##class(WDT.CDSS.SignInfo).%OpenId(id)
	s eobj.SignID = id
    s eobj.IDNO = pobj.IDNO
    s eobj.PatientDR = pobj.PatientDR
    s eobj.VisitID= pobj.VisitID
    s eobj.VisitType = pobj.VisitType
    s eobj.BodyTemperature = pobj.BodyTemperature
    s eobj.BloodPressure = pobj.BloodPressure
    s eobj.Pulse= pobj.Pulse
    s eobj.BreathFeature = pobj.BreathFeature
    s eobj.HeartRate = pobj.HeartRate
    s eobj.OxygenSaturation = pobj.OxygenSaturation
    s eobj.Pupil= pobj.Pupil
    s eobj.CornealReflex = pobj.CornealReflex
    s eobj.Height = pobj.Height
    s eobj.Weight = pobj.Weight
    s eobj.MeasureDate= pobj.MeasureDate
    s:pobj.PassFlag="" eobj.PassFlag="Y"
    s:pobj.PassFlag="1" eobj.PassFlag="Y"
    s:pobj.PassFlag="0" eobj.PassFlag="N"
    s eobj.DiastolicBlood = pobj.DiastolicBlood
    s eobj.SystolicBlood = pobj.SystolicBlood   

    s str = eobj.JsonS()    
    q str
}

/// Creator:丁亚男
/// CreatDate:2020-04-27
/// Description:根据id删除
/// Table:WDT.CDSS.SignInfo
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.PatientView.SignInfo).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    Tstart
    s eobj = ##class(web.CDSSEntity.PatientView.SignInfo).%New()
    s pobj = ##class(WDT.CDSS.SignInfo).%OpenId(id)
    s eobj.SignID = id
    s eobj.IDNO = pobj.IDNO
    s eobj.PatientDR = pobj.PatientDR
    s eobj.VisitID= pobj.VisitID
    s eobj.VisitType = pobj.VisitType
    s eobj.BodyTemperature = pobj.BodyTemperature
    s eobj.BloodPressure = pobj.BloodPressure
    s eobj.Pulse= pobj.Pulse
    s eobj.BreathFeature = pobj.BreathFeature
    s eobj.HeartRate = pobj.HeartRate
    s eobj.OxygenSaturation = pobj.OxygenSaturation
    s eobj.Pupil= pobj.Pupil
    s eobj.CornealReflex = pobj.CornealReflex
    s eobj.Height = pobj.Height
    s eobj.Weight = pobj.Weight
    s eobj.MeasureDate= pobj.MeasureDate
    s:pobj.PassFlag="" eobj.PassFlag="Y"
    s:pobj.PassFlag="1" eobj.PassFlag="Y"
    s:pobj.PassFlag="0" eobj.PassFlag="N"
    s eobj.DiastolicBlood = pobj.DiastolicBlood
    s eobj.SystolicBlood = pobj.SystolicBlood 

    s sc=##class(WDT.CDSS.SignInfo).%DeleteId(id)
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
