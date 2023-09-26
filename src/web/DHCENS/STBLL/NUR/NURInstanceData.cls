Class web.DHCENS.STBLL.NUR.NURInstanceData Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "NurInstanceWebService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// 连接测试
ClassMethod connectionTest(docType As %String) As %String [ WebMethod ]
{
	
    if (docType="NUR"){
		q "测试成功"
	}else{
		q "病历类型与wsdl地址不符"
	}
}

/// 评估单取数
/// w ##Class(web.DHCENS.STBLL.NUR.NURInstanceData).AssessmentData("205650")
ClassMethod AssessmentData(InstanceID As %String) As %GlobalCharacterStream [ WebMethod ]
{
	//b //111111
	set OutPutStream=##class(%GlobalCharacterStream).%New()
	set instanceInfo=##class(Nur.DHCMoudData).%OpenId(InstanceID)
	if (instanceInfo=""){
		set InstanceDataInfo="<InstanceDataInfo><standardID></standardID>"_"<patientId></patientId><diagNo></diagNo></InstanceDataInfo>"	
		do OutPutStream.Write("该打印模版记录为空"_InstanceDataInfo)
		q OutPutStream
	}
	set cancel=instanceInfo.RecCancelDate
	d instanceInfo.%Close()
	
	set emrCode=instanceInfo.EmrCode
	if (emrCode=""){
		set InstanceDataInfo="<InstanceDataInfo><standardID></standardID>"_"<patientId></patientId><diagNo></diagNo></InstanceDataInfo>"
		do OutPutStream.Write("该打印模版不存在"_InstanceDataInfo)
		q OutPutStream
	}
	
	
	set episodeId=instanceInfo.EpisodeId
	if (episodeId=""){
		set InstanceDataInfo="<InstanceDataInfo><standardID></standardID>"_"<patientId></patientId><diagNo></diagNo></InstanceDataInfo>"	
		do OutPutStream.Write("该打印模版记录为空"_InstanceDataInfo)
		q OutPutStream
	}
	
	set printId=""	
	//使用护理提供接口获取打印模版代码
	set printCode=##class(NurREC.Interface.Print).GetPrnCode(emrCode)
	if (printCode=""){
		set patInfo=$g(^PAADM(episodeId))	
		if (patInfo="") {
			set InstanceDataInfo="<InstanceDataInfo><standardID></standardID><patientId></patientId><diagNo>"_episodeId_"</diagNo></InstanceDataInfo>"
			do OutPutStream.Write("未查到病人相关就诊信息"_InstanceDataInfo)
			q OutPutStream
		}	
		Set PAPMIID=$p(^PAADM(episodeId),"^",1)
		Set patientId=$p($g(^PAPER(PAPMIID,"PAT",1)),"^",1)
		set InstanceDataInfo="<InstanceDataInfo><standardID></standardID>"_"<patientId>"_patientId_"</patientId><diagNo>"_episodeId_"</diagNo></InstanceDataInfo>"
		do OutPutStream.Write("该打印模版不存在"_InstanceDataInfo)
		q OutPutStream
	}
	//获取关联表的ID作为模版id
	&sql(SELECT ID INTO:printId from  SQLUser.DHC_NURMoudelLink where  PrintCode=:printCode and  Code=:emrCode)
	
	set patInfo=$g(^PAADM(episodeId))	
	if (patInfo="") {
		set InstanceDataInfo="<InstanceDataInfo><standardID>"_printId_"</standardID><patientId></patientId><diagNo>"_episodeId_"</diagNo></InstanceDataInfo>"
		do OutPutStream.Write("未查到病人相关就诊信息"_InstanceDataInfo)
		q OutPutStream
	}	
	Set PAPMIID=$p(^PAADM(episodeId),"^",1)
	Set patientId=$p($g(^PAPER(PAPMIID,"PAT",1)),"^",1)
	set InstanceDataInfo="<InstanceDataInfo><standardID>"_printId_"</standardID><patientId>"_patientId_"</patientId><diagNo>"_episodeId_"</diagNo></InstanceDataInfo>"
		
	if (cancel'=""){			
		do OutPutStream.Write("该打印记录已取消"_InstanceDataInfo)
		q OutPutStream
	}
	set datetime=instanceInfo.EmrDate_instanceInfo.EmrTime //$zd(instanceInfo.EmrDate)_" "_$zt(instanceInfo.EmrTime)
	b
	//set printCode=""
	//查询单据打印代码（可能又多个情况，这里取大于或等于DHC_NURMoudelLink的RECDate与RECTime组合中的最大值对应的代码）
	//&sql(SELECT PrintCode,ID INTO:printCode,:printId from  SQLUser.DHC_NURMoudelLink where RECDate=(select max(RECDate)  
		 //from SQLUser.DHC_NURMoudelLink where (RECDate||RECTime) <=:minDateTime and Code=:emrCode) and  Code=:emrCode)
    //按照护理提供的接口取得方式取
	//set printCode=$tr($o(^User.DHCNURMoudelLinkI("PrintCodeIndex"," "_emrCode,""))," ","")
	

	
	set templateXml=##class(NurREC.Interface.Print).GetXML(printCode)
	set PGDInfo=""
	set result=##class(%ResultSet).%New("NurREC.Interface.Print:GetAssessment")
    set sc=result.Execute(episodeId,emrCode,InstanceID)
    if ($$$ISERR(sc)) quit
	while(result.Next()) {
		set resultDataStr=result.Data("aa")
		set resultDataStr=$replace(resultDataStr,"<","&lt;")
		set resultDataStr=$replace(resultDataStr,">","&gt;")
		set id=$p(resultDataStr,"^ID|",2)
		set id=$p(id,"^",1)
		if (id=InstanceID) {
			set PGDInfo=PGDInfo_"<PGDInfo id="""_InstanceID_""">"_resultDataStr_"</PGDInfo>"
		}
		
	}
    do result.Close()
	set PGDInfoList="<PGDInfoList>"_PGDInfo_"</PGDInfoList>"
    //若是混合单则还需取记录单的数
    //&sql(SELECT PrintCode,ID INTO:printCode,:printId from  Nur.DHCNurseRecSub where nurrecid=:InstanceID)
    
    set recResult=##class(%ResultSet).%New("NurREC.Interface.Print:GetRecord")
    set sc=recResult.Execute(episodeId,emrCode)
    if ($$$ISERR(sc)) quit
    set idsStr=""
    set resultDataStr=""
    set JLDInfo=""
    set HeardInfoNode=""
	while(recResult.Next()) {
		set recDataStr=recResult.Data("aa")
		set recDataStr=$replace(recDataStr,"<","&lt;")
		set recDataStr=$replace(recDataStr,">","&gt;")
		set id=$p(recDataStr,"^ID|",2)
		set id=$p(id,"^",1)
		set nurRecId=$p(recDataStr,"NurRecId|",2)
		if (InstanceID=nurRecId) {
			set JLDInfo=JLDInfo_"<JLDInfo id="""_id_""">"_recDataStr_"</JLDInfo>"
			set HeardInfo=##class(NurREC.Interface.Print).GetRecordHeader(episodeId,emrCode,id)
			set HeardInfo=$replace(HeardInfo,"<","&lt;")
			set HeardInfo=$replace(HeardInfo,">","&gt;")
			set HeardInfoNode=HeardInfoNode_"<HeardInfo id="""_id_""">"_HeardInfo_"</HeardInfo>"
		}
	}
    do recResult.Close()
    if (JLDInfo="") {
	    set HeardInfo=##class(NurREC.Interface.Print).GetRecordHeader(episodeId,emrCode)
	    set HeardInfo=$replace(HeardInfo,"<","&lt;")
		set HeardInfo=$replace(HeardInfo,">","&gt;")
		set HeardInfoNode=HeardInfoNode_"<HeardInfo id="""_""">"_HeardInfo_"</HeardInfo>"
	}
    set JLDInfoList="<JLDInfoList>"_JLDInfo_"</JLDInfoList>"
	set HeardInfoList="<HeardInfoList>"_HeardInfoNode_"</HeardInfoList>"
    
    
	//其他信息（包括就诊信息以及模版信息等）
	Set PAPMIID=$p(^PAADM(episodeId),"^",1)
	Set patientId=$p($g(^PAPER(PAPMIID,"PAT",1)),"^",1)
	set RecUser=instanceInfo.EmrUser
	Set CreateDate=instanceInfo.EmrDate
	Set CreateTime=instanceInfo.EmrTime
	b
	set:CreateTime'="" CreateTime=$zt(CreateTime)
	set:CreateDate'="" CreateDate=$zd(CreateDate,3)
	set otherInfo="<standardID>"_printId_"</standardID>"_"<patientId>"_patientId_"</patientId>"_"<diagNo>"_episodeId_"</diagNo>"
					_"<CreateUserID>"_RecUser_"</CreateUserID><CreateDateTime>"_CreateDate_" "_CreateTime_"</CreateDateTime>"
	set allDataInfo="<InstanceDataInfo>"_PGDInfoList_HeardInfoList_JLDInfoList_otherInfo_"</InstanceDataInfo>"
	do OutPutStream.Write(templateXml_allDataInfo)
	q OutPutStream
}

/// 记录单取数
/// w ##Class(web.DHCENS.STBLL.NUR.NURInstanceData).RecordData(448005,"DHCNURBG_LZZSYJLJLD")
ClassMethod RecordData(RecParref As %String, RecTyp As %String) As %GlobalCharacterStream [ WebMethod ]
{
	set OutPutStream=##class(%GlobalCharacterStream).%New()
	if (RecParref=""){	
		do OutPutStream.Write("该打印模版记录为空")
		q OutPutStream
		
	}
	set RecParentInfo=##class(Nur.DHCNurseRecParent).%OpenId(RecParref)
	if (RecParentInfo=""){
		do OutPutStream.Write("该打印模版记录为空")
		q OutPutStream
		
	}
	
	set episodeId=RecParentInfo.Adm
	if (episodeId=""){
		do OutPutStream.Write("该打印模版记录为空")
		q OutPutStream
		
	}
	do RecParentInfo.%Close()
	
	set printId=""
	//使用护理提供接口获取打印模版代码
	set printCode=##class(NurREC.Interface.Print).GetPrnCode(RecTyp)
	if (printCode=""){
		set patInfo=$g(^PAADM(episodeId))
		if (patInfo="") {
			do OutPutStream.Write("未查到病人相关就诊信息"_"<InstanceDataInfo><standardID></standardID><patientId></patientId><diagNo>"_episodeId_"</diagNo></InstanceDataInfo>")
			q OutPutStream
		}	
		Set PAPMIID=$p(^PAADM(episodeId),"^",1)
		Set patientId=$p($g(^PAPER(PAPMIID,"PAT",1)),"^",1) 
		set InstanceDataInfo="<InstanceDataInfo><standardID></standardID><patientId>"_patientId_"</patientId><diagNo>"_episodeId_"</diagNo></InstanceDataInfo>"
		do OutPutStream.Write("该打印模版不存在"_InstanceDataInfo)
		q OutPutStream
	}
	&sql(SELECT ID INTO:printId from  SQLUser.DHC_NURMoudelLink where  PrintCode=:printCode and  Code=:RecTyp)
	set patInfo=$g(^PAADM(episodeId))
	if (patInfo="") {
		do OutPutStream.Write("未查到病人相关就诊信息"_"<InstanceDataInfo><standardID>"_printId_"</standardID><patientId></patientId><diagNo>"_episodeId_"</diagNo></InstanceDataInfo>")
		q OutPutStream
	}	
	Set PAPMIID=$p(^PAADM(episodeId),"^",1)
	Set patientId=$p($g(^PAPER(PAPMIID,"PAT",1)),"^",1) 
	set InstanceDataInfo="<InstanceDataInfo><standardID>"_printId_"</standardID><patientId>"_patientId_"</patientId><diagNo>"_episodeId_"</diagNo></InstanceDataInfo>"

	//由于记录时多条这里取最早时间的那条作为下面取模板代码的依据
	set minDateTime=""
	Set CreateDate=""
	Set CreateTime=""
	Set nurecid=""
	&sql(select CareDate,CareTime,(RecDate||RecTime),NurRecId INTO:CreateDate,:CreateTime,:minDateTime,:nurecid from  Nur.DHCNurseRecSub where RecParref=:RecParref 
		 and RecTyp=:RecTyp and RecCancelDate is null  and (RecDate||RecTime)=(select min(RecDate||RecTime) from Nur.DHCNurseRecSub aa  
	     where RecParref=:RecParref and RecTyp=:RecTyp and RecCancelDate is null) group by ID)
	if (nurecid'="") {			
		do OutPutStream.Write("该记录为混合单已由评估单处理"_InstanceDataInfo)
		q OutPutStream
	}	 
	//&sql(SELECT min(RecDate||RecTime),CareDate,CareTime INTO:minDateTime,:CreateDate,:CreateTime from  Nur.DHCNurseRecSub 
	//     where RecParref=:RecParref and RecTyp=:RecTyp and RecCancelDate is null group by RecParref)
	//b ;;2222
	if (minDateTime=""){
		do OutPutStream.Write("该打印记录已取消"_InstanceDataInfo)
		q OutPutStream
		
	}
	
	//set printCode=""
	//查询单据打印代码（可能又多个情况，这里取大于或等于DHC_NURMoudelLink的RECDate与RECTime组合中的最大值对应的代码）
	//&sql(SELECT PrintCode,ID INTO:printCode,:printId from  SQLUser.DHC_NURMoudelLink where RECDate=(select max(RECDate)  
		 //from SQLUser.DHC_NURMoudelLink where (RECDate||RECTime) <=:minDateTime and Code=:RecTyp) and  Code=:RecTyp)
    //按照护理提供的接口取得方式取
	//set printCode=$tr($o(^User.DHCNURMoudelLinkI("PrintCodeIndex"," "_RecTyp,""))," ","")
	

	
	
	set templateXml=##class(NurREC.Interface.Print).GetXML(printCode)
	set PGDInfo=""
	set result=##class(%ResultSet).%New("NurREC.Interface.Print:GetRecord")
    set sc=result.Execute(episodeId,RecTyp)
    if ($$$ISERR(sc)) quit
    set idsStr=""
    //b
    set resultDataStr=""
    set JLDInfo=""
    set HeardInfoNode=""
	while(result.Next()) {
		set resultDataStr=result.Data("aa")
		set resultDataStr=$replace(resultDataStr,"<","&lt;")
		set resultDataStr=$replace(resultDataStr,">","&gt;")
		set id=$p(resultDataStr,"^ID|",2)
		set id=$p(id,"^",1)
		set JLDInfo=JLDInfo_"<JLDInfo id="""_id_""">"_resultDataStr_"</JLDInfo>"
		set HeardInfo=##class(NurREC.Interface.Print).GetRecordHeader(episodeId,RecTyp,id)
		set HeardInfo=$replace(HeardInfo,"<","&lt;")
		set HeardInfo=$replace(HeardInfo,">","&gt;")
		set HeardInfoNode=HeardInfoNode_"<HeardInfo id="""_id_""">"_HeardInfo_"</HeardInfo>"
	}
    do result.Close()
    if (JLDInfo="") {
	    set HeardInfo=##class(NurREC.Interface.Print).GetRecordHeader(episodeId,RecTyp)
	    set HeardInfo=$replace(HeardInfo,"<","&lt;")
		set HeardInfo=$replace(HeardInfo,">","&gt;")
		set HeardInfoNode=HeardInfoNode_"<HeardInfo id="""_""">"_HeardInfo_"</HeardInfo>"
	}
	set JLDInfoList="<JLDInfoList>"_JLDInfo_"</JLDInfoList>"
	set HeardInfoList="<HeardInfoList>"_HeardInfoNode_"</HeardInfoList>"
	//若是混合单则还需取评估单的数(改为评估单处理)
	set PGDInfo=""
	//set assessmentresult=##class(%ResultSet).%New("NurREC.Interface.Print:GetAssessment")
   // set sc=assessmentresult.Execute(episodeId,RecTyp)
    //if ($$$ISERR(sc)) quit
	//while(assessmentresult.Next()) {
	//	set resultDataStr=assessmentresult.Data("aa")
	//	set id=$p(resultDataStr,"^ID|",2)
	//	set id=$p(id,"^",1)
	//	set PGDInfo=PGDInfo_"<PGDInfo id="""_id_""">"_resultDataStr_"</PGDInfo>"
	//}

	// do assessmentresult.Close()
	set PGDInfoList="<PGDInfoList>"_PGDInfo_"</PGDInfoList>"
    //其他信息（包括就诊信息以及模版信息等）
	Set PAPMIID=$p(^PAADM(episodeId),"^",1)
	Set patientId=$p($g(^PAPER(PAPMIID,"PAT",1)),"^",1)
	set RecUser=RecParentInfo.RecUser
	set:CreateTime'="" CreateTime=$zt(CreateTime)
	set:CreateDate'="" CreateDate=$zd(CreateDate,3)
	set otherInfo="<standardID>"_printId_"</standardID>"_"<patientId>"_patientId_"</patientId>"_"<diagNo>"_episodeId_"</diagNo>"
					_"<CreateUserID>"_RecUser_"</CreateUserID><CreateDateTime>"_CreateDate_" "_CreateTime_"</CreateDateTime>"
    //最终所有取数信息
	set allDataInfo="<InstanceDataInfo>"_HeardInfoList_PGDInfoList_JLDInfoList_otherInfo_"</InstanceDataInfo>"
	do OutPutStream.Write(templateXml_allDataInfo)
	q OutPutStream
}

/// 记录单取数
/// w ##Class(web.DHCENS.STBLL.NUR.NURInstanceData).getAllTemplateInfo()
ClassMethod getAllTemplateInfo() As %GlobalCharacterStream [ WebMethod ]
{
	set OutPutStream=##class(%GlobalCharacterStream).%New()
	set sql="select a.ID as templateId,b.ID as emrSubId,Code as templateCode,Name as templateName,PrintCode as templatePrintCode,typ as templateType,b.EmrSubDesc templateDesc from SQLUser.DHC_NURMoudelLink a left join NurEmr.NurEmrSub b on a.PrintCode=b.EmrSubKCode  where a.PrintCode is not null and a.typ in ('表格记录单','多次评估单','单次评估单','混合单')"
    set statement=##class(%SQL.Statement).%New(1)
    set status=statement.%Prepare(sql)
    if status'=1{
	    q OutPutStream.Write("查询失败，sql为："_sql)
	}
    set resultSet=statement.%Execute()
    set templateInfo=""
    do OutPutStream.Write("<templateInfoList>")
    while resultSet.%Next(){
	   set templateId=resultSet.templateId
	   set emrSubId=resultSet.emrSubId
	   set templateCode=resultSet.templateCode
       set templateName=resultSet.templateName
	   set templatePrintCode=resultSet.templatePrintCode
	   set templateType=resultSet.templateType
	   if emrSubId'="" {
		  set emrSubInfo=##class(NurEmr.NurEmrSub).%OpenId(emrSubId)
	      set templateContent=emrSubInfo.EmrSubData
	      set templateDesc=resultSet.templateDesc
	      set templateInfo="<templateInfo><templateId>"_templateId_"</templateId>"_"<templateCode>"_templateCode_"</templateCode>"_"<templateName>"_templateName_
	      "</templateName>"_"<templatePrintCode>"_templatePrintCode_"</templatePrintCode>"_"<templateType>"_templateType_"</templateType>"_"<templateDesc>"_
	      "</templateDesc><templateContent>"
	      do OutPutStream.Write(templateInfo)
	     
	      set encodeTempContent= ##class(%GlobalCharacterStream).%New()
	      set encodeTempContent= ..base64Encode(templateContent)
	      do OutPutStream.CopyFrom(encodeTempContent)
	      do OutPutStream.Write("</templateContent></templateInfo>")
	   }
	}
	do OutPutStream.Write("</templateInfoList>")
    q OutPutStream
}

ClassMethod base64Encode(srcStream As %GlobalCharacterStream) As %String
{
	s tarStream=##class(%Stream.TmpCharacter).%New()
	s tLen=3*1000
	while 'srcStream.AtEnd{
	s tmpStr=srcStream.Read(tLen)
	s tmpStr=$zcvt(tmpStr,"O","UTF8")
	s encodeStr=$system.Encryption.Base64Encode(tmpStr)
	d tarStream.Write(encodeStr)
	}
	q tarStream
}

}
