/// 东华CDSS逻辑处理类
Class EMRservice.BL.BLCDSSDHService Extends %RegisteredObject
{

ClassMethod GetInitData(AParamArray As %ArrayOfDataTypes)
{
        //定义错误处理函数
    s resultStream = ##class(%GlobalBinaryStream).%New()
    d resultStream.Write("{""success"":0,""message"":""东华CDSS初始化参数为空，检查结构化数据配置""}")
    s stream=##class(EMRservice.BL.BLCDSSService).GetDataByKey("CDSSDH","init","3","all",AParamArray)
    q:(stream.IsNull()=1) resultStream  
 	d resultStream.Clear()
    d resultStream.Write("{""success"":""1"",""message"":")
    d resultStream.CopyFrom(stream)
    s loadType = ..loadType()
    s episodeType=##class(EMRservice.BL.BLCDSSService).GetEpisodeType(AParamArray.GetAt("AEpisodeID"))
    d resultStream.Write(",""args"":{")
    d resultStream.Write("""cdssType"":""CDSSDH""")
    d resultStream.Write(",""loadType"":"""_loadType_"""")
    d resultStream.Write(",""episodeType"":"""_episodeType_"""}}")
    q resultStream
}

ClassMethod GetDHJsonData(AParamArray As %ArrayOfDataTypes)
{
    s resultStream = ##class(%GlobalBinaryStream).%New()
 	d resultStream.Write("{""success"":0,""message"":""检查前端接口参数""}")
    q:(((AParamArray.GetAt("AEpisodeID")="")||(AParamArray.GetAt("AUserID")="")||(AParamArray.GetAt("ADocID")="")||(AParamArray.GetAt("AInstanceID")="")||(AParamArray.GetAt("AType")="")||(AParamArray.GetAt("AAction")=""))) resultStream
    //判断当前模板是否关联CDSS
    s connectCDSS=0
    s count = ##class(EMRservice.BL.BLCDSSService).GetOldRecCount(AParamArray.GetAt("AEpisodeID"))
    if (count>0){
        if (AParamArray.GetAt("AInstanceID")=""){
            s ECRecordID =##Class(EMRservice.BL.BLCDSSService).GetECRecordID(AParamArray.GetAt("AEpisodeID"),paramArray.GetAt("ADocID"))    
            d AParamArray.SetAt(ECRecordID,"AInstanceID")
        }
        s connectCDSS = ##class(EMRservice.BL.BLCDSSService).isConnectCDSSEPR(AParamArray)  
    }else{
        s connectCDSS = ##class(EMRservice.BL.BLCDSSService).isConnectCDSSEMR(AParamArray)  
    }
  
    d resultStream.Clear()
	d resultStream.Write("{""success"":0,""message"":""检查术语集-模板相关配置""}")
    q:connectCDSS=0 resultStream
    s action = $ZCVT(AParamArray.GetAt("AAction"),"U")
    s:action'="DELETE" action="SAVE"
    s type = $ZCVT(AParamArray.GetAt("AType"),"U")
    s stream=##class(EMRservice.BL.BLCDSSService).GetDataByKey("CDSSDH","",type,action,AParamArray)  
    q:(stream.IsNull()=1) resultStream
    d resultStream.Clear()
    d resultStream.Write("{""success"":""1"",""message"":")
    d resultStream.CopyFrom(stream)
    d resultStream.Write("}")
    q resultStream
}

/// desc 取东华CDSS定义的就诊类型
/// debug result=##class(EMRservice.BL.BLCDSSService).GetCDSSEpisodeIDType(AEpisodeID)
ClassMethod GetCDSSEpisodeType(AEpisodeID As %String)
{
    
    q:(AEpisodeID="") ""
    s (result,episodeType)=""
    s episodeType = $ZCVT($p($G(^PAADM(AEpisodeID)),"^",2),"U")
    //默认住院类型
    q:episodeType="" result
    if (episodeType="I"){
        s result = 3
    }elseif(episodeType="O"){
       s result = 2
    }elseif(episodeType="E"){
        s result =1   
    }
    q result
}

/// desc 根据就诊号取东华CDSS定义的性别
/// debug result=##class(EMRservice.BL.BLCDSSDHService).GetGender(50865378)
ClassMethod GetGender(AEpisodeID As %String)
{
    q:(AEpisodeID = "") ""
    s (gender,patientId) =""
    s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
    s:patientId'="" gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientId, "")
    s:gender'="" gender = $P(gender, "^", 3)
    s:gender'="" gender = $case(gender,"男":1,"男性":1,"女":0,"女性":0,:2)
    q gender
}

/// desc 取病历数据
/// debug result=##class(EMRservice.BL.BLCDSSDHService).GetSectionInfo(50892282,390,1112443||1)
ClassMethod GetSectionInfo(AEpisodeID As %String, ADocID As %String, AInstanceID As %String, ACDSSTool As %String = "CDSSDH")
{
    //s ^Temp("duan","GetSectionInfo")=AEpisodeID_","_ADocID_","_AInstanceID
    s result = ##Class(%GlobalBinaryStream).%New()
    q:(AEpisodeID = "")||(ADocID = "") result
    s:(ACDSSTool="") ACDSSTool="CDSSDH"
    s objIstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    q:(objIstance = "") ""
    if (objIstance.TitleCode '= "")&&(objIstance.TheECRecord.ChartItemType = "Multiple")
    {
        s hdsdcode = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocCode"," "_ACDSSTool," "_ADocID," "_$zcvt(objIstance.TitleCode,"u"),""))
    }
    else
    {
        s hdsdcode = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocHDSD"," "_ACDSSTool," "_ADocID,""))
    }
    s hdsdcode = $tr(hdsdcode," ","")
    q:hdsdcode="" ""
    //s arrInstanceID=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEpisodeID,hdsdcode)
    s arr=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,hdsdcode,AInstanceID)
    /*q:arrInstanceID.Count()=0 result
    s arr = arrInstanceID.GetAt(AInstanceID)*/
    q:arr.Count()=0 result
    s sectionRowId = ""
    for
    {
        s sectionRowId = $o(^DHCEMRM.CDSS.HDSDSectionI("IdxHDSD"," "_ACDSSTool," "_hdsdcode,sectionRowId))
        q:(sectionRowId = "")
        s objSection = ##Class(EMRmeta.CDSS.HDSDSection).%OpenId(sectionRowId)
        q:(objSection = "")
        s sectionCode = objSection.HDSDSectionCode
        s key = objSection.SectionDesc
        s sectionKeyDesc = objSection.SectionKeyDesc
        s diagnosisType = objSection.DiagnosisType
        s ConfigSpecial = $P(objSection.ConfigSpecial,"^",1)
        s CacheDiagnosisType = $P(objSection.ConfigSpecial,"^",2)
        s value=""
        for i=1:1:$l(sectionCode,"^")
        {
	        s tmpSectionCode = $p(sectionCode,"^",i)
	        s:(value '= "") value = value_arr.GetAt(tmpSectionCode)
        	s:(value = "") value = arr.GetAt(tmpSectionCode)
        }
        s value=$ZSTRIP(value,"*C")
        s value=##Class(EMRservice.BL.BLCDSSService).JsonEscape(value)
        d:result.Size>1 result.Write(",")
        d result.Write("{")
        d result.Write("""key"":"""_key_"""")
        d result.Write(",""value"":"""_value_"""")
        d result.Write("}")
    }
    q result
}

/// desc 根据就诊号 判断患者就诊类型  判断当前患者属于门诊系统还是住院系统
/// output 1 住院电子病历  2 住院医生站 3 门诊电子病历 4门诊医生站 5 手术 6 检查 7 检验 8 护理
/// debug result=##class(EMRservice.BL.BLCDSSDHService).GetPageSource(AEpisodeID)
ClassMethod GetPageSource(AEpisodeID As %String)
{
    q:AEpisodeID="" ""
    s episodeType = ##class(EMRservice.BL.BLCDSSService).GetEpisodeType(AEpisodeID)
    q:episodeType="I" 1
    q:episodeType="O" 3
    q "患者就诊类型未知"
}

/// desc 东华CDSS是否在在电子病历初始化
/// output 1 是  0不在病历初始化  （默认1） 
/// debug result=##class(EMRservice.BL.BLCDSSDHService).GetPageSource(AEpisodeID)
ClassMethod loadType()
{
	s (Id,loadType,CDSSObj,paramter)=""
	s Id = $O(^DHCEMRM.CDSSToolI("CDSSActive"," CDSSDH"," 1",Id))
	q:Id="" loadType
	s CDSSObj = ##class(EMRmeta.CDSS.CDSSTool).%OpenId(Id)
	s:CDSSObj'="" paramter = CDSSObj.Paramter
	s:paramter'="" loadType = $P(paramter,"^",1)
	s:paramter="" loadType = 1
	q loadType
}

}
