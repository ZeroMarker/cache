Class EMRservice.Ajax.appRecordInfoData Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
    s episodeId = $Get(%request.Data("EpisodeID",1),"")
    s action = $Get(%request.Data("Action",1),"")
    if (action = "GetAppRecordInfoData")
    {
        w ..GetAppRecordInfo(episodeId)
    }
    Quit $$$OK
}

/// DESC: 取科大讯飞的病历内容，目前包括主诉、现病史、既往史、辅助检查
/// w ##Class(EMRservice.Ajax.appRecordInfoData).GetAppRecordInfo(472)
ClassMethod GetAppRecordInfo(AEpisodeID As %String) As %String
{
    s json = "{""Name"":""主诉"",""Value"":"""",""ID"":"""",""Source"":""""},"
    s json = json_"{""Name"":""现病史"",""Value"":"""",""ID"":"""",""Source"":""""}},"
    s json = json_"{""Name"":""既往史"",""Value"":"""",""ID"":"""",""Source"":""""}},"
    s json = json_"{""Name"":""查体"",""Value"":"""",""ID"":"""",""Source"":""""}},"
    s json = json_"{""Name"":""辅助检查"",""Value"":"""",""ID"":"""",""Source"":""""}}"
    
    q:(AEpisodeID = "") "{""total"":0,""rows"":["_$ZSTRIP(json,"*C")_"]}"
    s count = 0
    
    s idList = ""
	//来自医生助手
    s ID = $O(^DHCEMRI.Custom.AppRecordInfoI("IdxEpisodeIDProduct"," "_AEpisodeID," DOCTORASSIST",""),-1)
    s:(ID '= "") idList = $lb(ID)
    //来自患者
   	s ID = $O(^DHCEMRI.Custom.AppRecordInfoI("IdxEpisodeIDProduct"," "_AEpisodeID," PATIENTAPP",""),-1)    
	s:(ID '= "") idList = idList_$lb(ID)
	//来自疑难病平台
   	s ID = $O(^DHCEMRI.Custom.AppRecordInfoI("IdxEpisodeIDProduct"," "_AEpisodeID," OBGYNCDSS",""),-1)    
	s:(ID '= "") idList = idList_$lb(ID)
   
    q:(idList = "") "{""total"":0,""rows"":["_$ZSTRIP(json,"*C")_"]}"
    
    s json = ""
    for i = 1:1:$LL(idList) 
    {
	    s ID = $lg(idList,i)
	    continue:(ID = "")
	    
        s obj = ##class(EMRinstance.Custom.AppRecordInfo).%OpenId(ID)
        s ChiefComplaint = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($Replace($Replace(obj.MainSuit,$c(10),"\n"),"<br/>","\n"))
        s ClinicHistory  = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($Replace($Replace(obj.NowHisInfo,$c(10),"\n"),"<br/>","\n"))
        s PhysicalExam   = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($Replace($Replace(obj.PhyExam,$c(10),"\n"),"<br/>","\n"))
        s PastHistory    = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($Replace($Replace(obj.PrevHisInfo,$c(10),"\n"),"<br/>","\n"))
        s AdditionalExam = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($Replace($Replace(obj.AdditionalExam,$c(10),"\n"),"<br/>","\n"))
        s DataSrc        = $case(obj.DataSources,"DoctorAssist":"医生助手","PatientAPP":"患者填写","ObgynCDSS":"疑难病平台")
        s RecordDateTime = $zd(obj.RecordDate,3)_" "_$zt(obj.RecordTime,1)
        
        if (json '= "") s json = json_","
        s json = json_"{""Name"":""主诉"",""Value"":""<xmp>"_ChiefComplaint_"</xmp>"",""Source"":"""_DataSrc_""",""RecordDateTime"":"""_RecordDateTime_""",""RecordID"":"""_ID_"""},"
        s json = json_"{""Name"":""现病史"",""Value"":""<xmp>"_ClinicHistory_"</xmp>"",""Source"":"""_DataSrc_""",""RecordDateTime"":"""_RecordDateTime_""",""RecordID"":"""_ID_"""},"
        s json = json_"{""Name"":""既往史"",""Value"":""<xmp>"_PastHistory_"</xmp>"",""Source"":"""_DataSrc_""",""RecordDateTime"":"""_RecordDateTime_""",""RecordID"":"""_ID_"""},"
        s json = json_"{""Name"":""查体"",""Value"":""<xmp>"_PhysicalExam_"</xmp>"",""Source"":"""_DataSrc_""",""RecordDateTime"":"""_RecordDateTime_""",""RecordID"":"""_ID_"""},"
        s json = json_"{""Name"":""辅助检查"",""Value"":""<xmp>"_AdditionalExam_"</xmp>"",""Source"":"""_DataSrc_""",""RecordDateTime"":"""_RecordDateTime_""",""RecordID"":"""_ID_"""}"
        s count = count + 5
    }
    s json = $ZSTRIP(json,"*C")
    q "{""total"":"_count_",""rows"":["_json_"]}"
}

ClassMethod SaveRecordQuoteInfo(AEpisodeID As %String, AUserID As %String, ALocID As %String, RecordQuoteInfo As %String) As %String
{
	s result = "-1"
	q:( AEpisodeID="" ||AUserID = ""|| ALocID = "") result
	
	s obj= ##class(EMRinstance.Custom.AppRecordQuoteLog).%New()
	s obj.EpisodeID = AEpisodeID
	s obj.UserID = AUserID
	s obj.UserLocID = ALocID
	s obj.QuoteRecordInfo = RecordQuoteInfo
	s obj.QuoteDate = $P($H,",",1)
	s obj.QuoteTime = $P($H,",",2)
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1
	q result
}

}
