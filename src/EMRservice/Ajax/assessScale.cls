Class EMRservice.Ajax.assessScale Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
 
    s action = $Get(%request.Data("Action",1),"")
    s interface = $Get(%request.Data("InterFace",1),"")
    s interface = $zcvt($zcvt(interface,"I","URL"),"I","UTF8")
    if (action = "GetAssessScaleDataByEpisodeID")
    {
        s page = $g(%request.Data("page",1),"-1")
        s rows = $g(%request.Data("rows",1),"-1")
        s idxStart = rows * (page -1) + 1
        s idxLast = idxStart + rows -1 
        s episodeIds = $Get(%request.Data("EpisodeIDs",1),"")
        w ..GetAssessScaleDataByEpisodeID(interface,episodeIds,idxStart,idxLast)
    }
    elseif (action = "GetAssessScaleDataByScaleID")
    {
        s scaleID = $Get(%request.Data("ScaleID",1),"")
        w ..GetAssessScaleDataByScaleID(interface,scaleID)
    }
    Quit $$$OK
}

/// Desc:       获取患者的评估量表记录
/// Creator:    Lina
/// Createdate: 2021-4-12
/// Input:      AInterFace 调用接口标识(默认HIS)
///             AEpisodeIDs:就诊号以"^"分隔
///             AIdxStart:返回分页开始页号
///             AIdxLast:返回分页结束页号
/// Output:     ScaleID：评估记录ID,RatingScaleDictDR：评估量表ID,MKBABDesc：评估量表描述,RatingDate：评估时间
///             RatingUser：评估人,RatingDept：评估科室,RatingRemarks：评估说明,RatingScore：评估表总得分
///             RatingDesc：评估表结果描述,RatingRank：评估表结果等级,RatingValue：评估表结果内容
///             w ##Class(EMRservice.Ajax.assessScale).GetAssessScaleDataByEpisodeID("HIS","1^2",1,10)
ClassMethod GetAssessScaleDataByEpisodeID(AInterFace As %String, AEpisodeIDs As %String, AIdxStart As %Integer, AIdxLast As %Integer) As %String
{
    s json = ""
    s count = 0
    q:(AEpisodeIDs = "") "{""total"":"_count_",""rows"":["_json_"]}"
    s key = $i(^CacheTemp)
    k ^TempEMRAssessScaleData(key)
    if (AInterFace = "HIS")
    {
        //类方法 d ##class(%ResultSet).RunQuery("web.CDSS.PatientView.PatientRatingScale","GetList", AEpisodeIDs)
        s result = ##class(%ResultSet).%New("web.CDSS.PatientView.PatientRatingScale:GetList")
        d result.Execute(AEpisodeIDs)
    }
    //elseif (AInterFace = ...){....}   调用其它接口
    
    s columCount = result.GetColumnCount()
    while result.%Next()
    {
        s ratingDate = $zdh(result.Data("RatingDate"),3)
        //排序
        for k=1:1:columCount
        {
            s ^TempEMRAssessScaleData(key,ratingDate,count,result.GetColumnName(k)) = result.Data(result.GetColumnName(k))
        }
        s count = count + 1
    }
    d result.Close()
    
    //倒序排序输出
    s ratingDate = "",i = 1
    for
    {
        s ratingDate = $o(^TempEMRAssessScaleData(key,ratingDate),-1)
        q:(ratingDate="")
        s num = ""
        for {
            s num = $o(^TempEMRAssessScaleData(key,ratingDate,num))
            q:(num = "")
            if ((AIdxStart <= i)&(i <= AIdxLast))
            {
                s tempjson = "{"
                s tempcount = 0
                s column = ""
                for 
                {
                    s column = $o(^TempEMRAssessScaleData(key,ratingDate,num,column))
                    q:(column = "")
                    s columnresult = ^TempEMRAssessScaleData(key,ratingDate,num,column)
                    s:(tempcount '= 0) tempjson = tempjson_","
                    if (column = "RatingDate")
                    {
                        s tempjson = tempjson_""""_column_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",columnresult)_""""
                    }
                    else
                    {
                        s tempjson = tempjson_""""_column_""":"""_columnresult_""""
                    }
                    s tempcount = tempcount + 1
                }       
                s tempjson = tempjson_"}"
                
                s:(json '= "") json = json_","
                s json = json_tempjson
            }
            s i = i + 1
        }
    }
    k ^TempEMRAssessScaleData(key)
    
    s json = "{""total"":"_count_",""rows"":["_json_"]}"
    s json = $ZSTRIP(json,"*C")
    q json
}

/// Desc:       获取患者的评估量表记录
/// Creator:    Lina
/// Createdate: 2021-4-12
/// Input:      AInterFace 调用接口标识(默认HIS)
///             AScaleID：评估记录ID
/// OutPut:     RatingScaleDictDR：评估量表ID,MKBABDesc：评估量表描述,RatingDate：评估时间
///             RatingUser：评估人,RatingDept：评估科室,RatingRemarks：评估说明,RatingScore：评估表总得分
///             RatingDesc：评估表结果描述,RatingRank：评估表结果等级,RatingValue：评估表结果内容
/// debug:      w ##Class(EMRservice.Ajax.assessScale).GetAssessScaleDataByScaleID("HIS","1")
ClassMethod GetAssessScaleDataByScaleID(AInterFace As %String, AScaleID As %String) As %String
{
    s json = ""
    s count = 0
    q:(AScaleID = "") "{""total"":0,""rows"":["_json_"]}"
    s key = $i(^CacheTemp)
    k ^TempEMRAssessScaleSubData(key)
    if (AInterFace = "HIS")
    {
        //类方法 d ##class(%ResultSet).RunQuery("web.CDSS.PatientView.PatientRatingScale","GetRSList", AScaleID)
        s result = ##class(%ResultSet).%New("web.CDSS.PatientView.PatientRatingScale:GetRSList")
        d result.Execute(AScaleID)
    }
    //elseif (AInterFace = ...){....}   调用其它接口
    
    s columCount = result.GetColumnCount()
    while result.%Next()
    {
        s ratingDate = $zdh(result.Data("RatingDate"),3)
        //排序
        for k=1:1:columCount
        {
            s ^TempEMRAssessScaleSubData(key,ratingDate,result.GetColumnName(k)) = result.Data(result.GetColumnName(k))
        }
        s count = count + 1
    }
    d result.Close()
    
    //倒序排序输出
    s ratingDate = ""
    for
    {
        s ratingDate = $o(^TempEMRAssessScaleSubData(key,ratingDate),-1)
        q:(ratingDate="")
        s tempjson = "{"
        s tempcount = 0
        s column = ""
        for 
        {
            s column = $o(^TempEMRAssessScaleSubData(key,ratingDate,column))
            q:(column = "")
            s columnresult = ^TempEMRAssessScaleSubData(key,ratingDate,column)
            s:(tempcount '= 0) tempjson = tempjson_","
            if (column = "RatingDate")
            {
                s tempjson = tempjson_""""_column_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",columnresult)_""""
            }
            else
            {
                s tempjson = tempjson_""""_column_""":"""_columnresult_""""
            }
            s tempcount = tempcount + 1
        }       
        s tempjson = tempjson_"}"
        
        s:(json '= "") json = json_","
        s json = json_tempjson
    }
    k ^TempEMRAssessScaleSubData(key)
    
    s json = "{""total"":"_count_",""rows"":["_json_"]}"
    s json = $ZSTRIP(json,"*C")
    q json
}

}
