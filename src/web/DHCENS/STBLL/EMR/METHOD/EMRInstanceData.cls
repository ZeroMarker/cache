Class web.DHCENS.STBLL.EMR.METHOD.EMRInstanceData Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "InstanceData";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// 连接测试
ClassMethod connectionTest(docType As %String) As %String [ WebMethod ]
{
	if (docType="EMR3"){
		q "测试成功"
	}else{
		q "病历类型与wsdl地址不符"
	}
}

/// 描述:根据病历实例ID（emrinstance.instancedata表ID）获取病历XML实例结构,其中InstanceData字段在电子病历进行了压缩，
/// 调##Class(EMRservice.BL.BLInstanceData).LoadDocument方法进行解压缩
/// Debug:w ##Class(web.DHCENS.STBLL.EMR.METHOD.EMRInstanceData).InstanceDataContent("98||1")
ClassMethod InstanceDataContent(AInstanceID As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set OutPutStream=##class(%Stream.GlobalCharacter).%New()
	s argOutData=##class(%Stream.GlobalCharacter).%New()
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID) 
	
	set InstanceMetaData=objInstance.InstanceMetaData
	set InstanceScriptData=objInstance.InstanceScriptData
	set InstanceData=objInstance.InstanceData
	set InstanceMedia=objInstance.InstanceMedia
	set InstanceInitialData=objInstance.InstanceInitialData
	//解压
	if (##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsBKCompressByInstanceID(AInstanceID)="1"){
		set InstanceData=##class(EMRservice.Parser.StreamData).DeCompressStream(InstanceData)
		set InstanceMetaData=##class(EMRservice.Parser.StreamData).DeCompressStream(InstanceMetaData)
		set InstanceScriptData=##class(EMRservice.Parser.StreamData).DeCompressStream(InstanceScriptData)
		set InstanceMedia=##class(EMRservice.Parser.StreamData).DeCompressStream(InstanceMedia)
		set InstanceInitialData=##class(EMRservice.Parser.StreamData).DeCompressStream(InstanceInitialData)
		d argOutData.CopyFrom(..GetRecordXML(objInstance.RealTemplateIDGet(),"Document",objInstance.Title,objInstance.TitleCode,InstanceMetaData,InstanceScriptData,InstanceData,InstanceMedia,InstanceInitialData))
	}
	else
	{
		d argOutData.CopyFrom(..GetRecordXML(objInstance.RealTemplateID,"Document",objInstance.Title,objInstance.TitleCode,objInstance.InstanceMetaData,objInstance.InstanceScriptData,objInstance.InstanceData,objInstance.InstanceMedia,objInstance.InstanceInitialData))	
	}
	set BindPrnTemplateID=objInstance.RealTemplateID
	set TemplateCategoryRowId=$o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_BindPrnTemplateID,""))
	q:TemplateCategoryRowId="" "0"
	set Name=$lg(^DHCEMRM.EMRTemplateD(TemplateCategoryRowId),2)
	set AdmNo=objInstance.RealEpisodeID
	Set PAPMIID=$p(^PAADM(AdmNo),"^",1)
	set PATName=$p($g(^PAPER(PAPMIID,"ALL")),"^",1)
	set AdmDate= $P($G(^PAADM(AdmNo)),"^",6)
	set AdmTime=$P($G(^PAADM(AdmNo)),"^",7)
	set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	set:AdmTime'="" AdmTime=$zt(AdmTime)	
	Set patientId=$p($g(^PAPER(PAPMIID,"PAT",1)),"^",1)
	Set idNum=$P($g(^PAPER(PAPMIID,"ALL")),"^",9)
	set EPRNum=$p(AInstanceID,"||",2)
	set PrintTemplateVersionID=$o(^DHCEPRM.PrintTemplateVersionI("IdxForPrintTIDAndVerNum"," "_objInstance.TemplateID,objInstance.TemplateVersion,""))
	Set CreateUserID=objInstance.CreateUser
	Set CreateDate=objInstance.CreateDate
	Set CreateTime=objInstance.CreateTime
	//改为不为空的业务发生时间
	Set happenDate=objInstance.HappenDate
	Set happenTime=objInstance.HappenTime
	if (happenDate '="") {
		set CreateDate=happenDate
	}
	if (happenTime '="") {
		set CreateTime=happenTime
	}
	set:CreateTime'="" CreateTime=$zt(CreateTime)
	set:CreateDate'="" CreateDate=$zd(CreateDate,3)
	SET PrintTemplateVersion=objInstance.TemplateVersion
	set InstanceStatus=objInstance.Status
	do argOutData.Write("<InstanceDataInfo><tempType>1</tempType><standardID>"_BindPrnTemplateID_"</standardID><standardName>"_Name_"</standardName><patientId>"_patientId_"</patientId><name>"_PATName_"</name><idNo>"_idNum_"</idNo><diagDate>"_AdmDate_"</diagDate><diagNo>"_AdmNo_"</diagNo><repeatId>"_EPRNum_"</repeatId><insertTime>"_$zd(+$h,3)_" "_$zt($p($h,",",2))_"</insertTime><CreateUserID>"_CreateUserID_"</CreateUserID><PrintTemplateVersionID>"_PrintTemplateVersionID_"</PrintTemplateVersionID><Version>"_PrintTemplateVersion_"</Version><CreateDateTime>"_CreateDate_" "_CreateTime_"</CreateDateTime><InstanceStatus>"_InstanceStatus_"</InstanceStatus></InstanceDataInfo>")
	Q argOutData
}

/// CreateTime: 2014-02-12
/// Creator:    candy
/// Desc:		文档信息
/// Input:		ATempLateID: 模板ID
///             AElementType: 根标签类型(template,Document)
///             ATitle: 标题
///             ATitleCode: 标题代码 
///             AMetaData: 元数据
///             AScriptData: 公式规则
///             AInstanceData: 实例数据
/// OutPut:     stream：xml文档流数据
ClassMethod GetRecordXML(ATempLateID As %String, AElementType As %String, ATitle As %String, ATitleCode As %String, AMetaData As %GlobalBinaryStream, AScriptData As %GlobalBinaryStream, AInstanceData As %GlobalBinaryStream, AMediasData As %GlobalBinaryStream, AInitialData As %GlobalBinaryStream) As %GlobalBinaryStream
{
	s stream = ##Class(%GlobalCharacterStream).%New()
	q:((ATempLateID= "")||(AElementType = "")) stream
	s objTemplate = ##Class(EMRmeta.Template).%OpenId(ATempLateID)
	q:((objTemplate = "")) stream
	s templatePropertyCode = "testCode"
	s templatePropertyName = "testName"
 	s ctPropRowID = $o(^DHCEMRM.CTPropertyI("IdxCode"," "_$zcvt(objTemplate.TemplateProperty,"U"),""))
	s objCTProperty = ##Class(EMRmeta.CTProperty).%OpenId(ctPropRowID)
	if (objCTProperty '= "")
	{
		s templatePropertyCode = $zcvt(objCTProperty.PropertyCode,"O","UTF8")
		s templatePropertyName = $zcvt(objCTProperty.PropertyName,"O","UTF8")
	}
	s code = $ZSTRIP(objTemplate.Code,"*C")  //去特殊字符
	s code = $zcvt(code,"O","UTF8") //转为UTF8码制
	s displayName = $ZSTRIP(objTemplate.DisplayName,"*C") //去特殊字符
	s displayName = $zcvt(displayName,"O","UTF8") //转为UTF8码制
	
	//xml流
	d stream.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	d stream.Write("<"_AElementType_">")
	d stream.Write("<Code Code="""_code_""" DisplayName="""_displayName_"""/>")
	d stream.Write("<TemplateGUID>"_objTemplate.GUID_"</TemplateGUID>")
	d stream.Write("<TemplateType>"_objTemplate.ChartItemType_"</TemplateType>")
	d stream.Write("<TemplateProperty Code="""_templatePropertyCode_""" DisplayName="""_templatePropertyName_"""/>")
	
	if (AElementType = "Document")
	{
		s tmpTitlecode = $p(ATitleCode,"^",1)
		s tmpTitlecode = $zcvt(tmpTitlecode,"O","UTF8")
		s ATitle = $ZSTRIP(ATitle,"*C") 
		s ATitle = $zcvt(ATitle,"O","UTF8")	
		s title = ATitle
		s titleRowId = $o(^DHCEMRM.TitlesI("IdxCode"," "_$zcvt(tmpTitlecode,"U"),""))
		if (titleRowId '= "")
		{
			s objTitle = ##Class(EMRmeta.Titles).%OpenId(titleRowId)
			q:(objTitle = "") stream
			s title = $zcvt(objTitle.Description,"O","UTF8")
		}
		d stream.Write("<Title Code="""_tmpTitlecode_""" DisplayName="""_title_""" NewDisplayName="""_ATitle_""">")
		d stream.Write("<TitleItems>")
		for i=1:1:$l(ATitleCode,"^")
		{
			s tmpcode = $p(ATitleCode,"^",i)
			s titleRowId = $o(^DHCEMRM.TitlesI("IdxCode"," "_$zcvt(tmpcode,"U"),""))
			continue:(titleRowId = "")
			s objTitle = ##Class(EMRmeta.Titles).%OpenId(titleRowId)
			continue:(objTitle = "")
			s tmpDesc = objTitle.Description
			s tmpcode = $zcvt(tmpcode,"O","UTF8")
			s tmpDesc = $zcvt(tmpDesc,"O","UTF8")	
			d stream.Write("<TitleItem Code="""_tmpcode_""" DisplayName="""_tmpDesc_"""/>")
		}
		d stream.Write("</TitleItems>")
		d stream.Write("</Title>")
	}
	else
	{
		d stream.Write("<Title Code="""_ATitleCode_""" DisplayName="""_ATitle_"""/>")
	}
	
	d stream.Write("<Macros>")
	d stream.Write("<Macro/>")
	d stream.Write("</Macros>")
	  
	//表格文档需要加打印信息
	d:( $zcvt(objTemplate.DocumentType,"U") = "GRID") stream.Write("<PrintSetup/>")
	d stream.Write("<StructuredBody>")
	;b ;AMetaData
	d stream.CopyFrom(AMetaData)
	d stream.CopyFrom(AScriptData)
	d stream.CopyFrom(AMediasData)
	d stream.CopyFrom(AInitialData)
	d stream.CopyFrom(AInstanceData)
	d stream.Write("</StructuredBody>")
	d stream.Write("</"_AElementType_">") 
	k objTemplate,AMetaData,AScriptData,AInstanceData,AMediasData,AInitialData
	q stream
}

/// w ##Class(web.DHCENS.STBLL.EMR.METHOD.EMRInstanceData).GetPrintTemplateVersionInfo("3||116")
/// w ##Class(web.DHCENS.STBLL.EMR.METHOD.EMRInstanceData).GetPrintTemplateVersionInfo(3||112)
ClassMethod GetPrintTemplateVersionInfo(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	set PrintTemplateID=$p(input,"||",2)
	set EMRTemplateRowID=""
	set OutStream=##Class(%GlobalCharacterStream).%New()
	do OutStream.Write("<PrintTemplate>")
	for
	{
		set EMRTemplateRowID=$o(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_PrintTemplateID,EMRTemplateRowID))
		Q:EMRTemplateRowID=""
		set BindTemplateID=$lg(^DHCEMRM.EMRTemplateD(EMRTemplateRowID),5)
		set PrintTemplateName=$lg(^DHCEMRM.EMRTemplateD(EMRTemplateRowID),2)
		set PrintTemplateName=..TransXML(PrintTemplateName)
		continue:BindTemplateID=$c(0)
		set VersionNumber=""
		for
		{
			set XMLStream=##Class(%GlobalCharacterStream).%New()
			set VersionNumber=$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_BindTemplateID,VersionNumber),-1)
			q:VersionNumber=""
			set PrintTemplateVersionRowId=$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_BindTemplateID,VersionNumber,""))
			Set LastSaveDate=$zd($lg(^DHCEMRM.TemplateVersionD(PrintTemplateVersionRowId),6),3)
			set LastSaveTime=$zt($lg(^DHCEMRM.TemplateVersionD(PrintTemplateVersionRowId),7))
			set LastSaveDateTime=LastSaveDate_" "_LastSaveTime
			do OutStream.Write("<PrintTemplateInfo><PrintTemplateName>"_PrintTemplateName_"</PrintTemplateName>")
			do OutStream.Write("<xmlId>"_PrintTemplateVersionRowId_"</xmlId>")
			do OutStream.Write("<PrintTemplateID>"_BindTemplateID_"</PrintTemplateID>")
			do OutStream.Write("<PrintTemplateCategoryID>"_input_"</PrintTemplateCategoryID>")
			do OutStream.Write("<VersionNumber>"_VersionNumber_"</VersionNumber>")
			do OutStream.Write("<LastSaveDateTime>"_LastSaveDateTime_"</LastSaveDateTime>")
			do OutStream.Write("<Content>")
			set tSC=..LoadTemplate(.XMLStream,PrintTemplateVersionRowId)
			Set tempStream=..base64Encode(XMLStream)
			do OutStream.CopyFrom(tempStream)
			do OutStream.Write("</Content></PrintTemplateInfo>")
		}
	}
	do OutStream.Write("</PrintTemplate>")
	set TempSringOut=OutStream.Read()
	if TempSringOut="<PrintTemplate></PrintTemplate>"
	{
		set OutStream=##Class(%GlobalCharacterStream).%New()
		do OutStream.Write("非打印模板")
		Q OutStream
	}
	else
	{
		do OutStream.Rewind()
	}
	Q OutStream
}

/// w ##Class(web.DHCENS.BLL.EMR.PrintTemplateInfo).GetPrintTemplateCategoryInfo("华西电子病历V3.0")
ClassMethod GetPrintTemplateCategoryInfo(version As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set PrintTemplateCategoryRowID=""
	Set Stream=##class(%GlobalCharacterStream).%New()
	do Stream.Write("<PrintTemplateCategoryInfo><PrintTemplateCategoryList>")
	set num=0
	for
	{
		set num=num+1
		set PrintTemplateCategoryRowID=$o(^DHCEMRM.EMRTemplateCategoryD(PrintTemplateCategoryRowID))
		Q:PrintTemplateCategoryRowID=""
		set CategoryName=$lg(^DHCEMRM.EMRTemplateCategoryD(PrintTemplateCategoryRowID),2)
		set CategoryName=..TransXML(CategoryName)
		set ParentCategoryID=$lg(^DHCEMRM.EMRTemplateCategoryD(PrintTemplateCategoryRowID),4)
		set CategorySeq=$lg(^DHCEMRM.EMRTemplateCategoryD(PrintTemplateCategoryRowID),5)
		do Stream.Write("<Info><CategoryID>"_version_"||"_PrintTemplateCategoryRowID_"</CategoryID><Name>"_CategoryName_"</Name><ParentID>"_ParentCategoryID_"</ParentID><Version>"_version_"</Version><CategorySeq>"_CategorySeq_"</CategorySeq></Info>")
	}
	do Stream.Write("</PrintTemplateCategoryList></PrintTemplateCategoryInfo>")
	Q Stream
}

/// CreateTime: 2014-02-12
/// Creator:    candy
/// Desc:		得到模板xml文档
/// Input:		ATemplateVersionId: 模板版本ID
///             AOutRecords: 返回xml 
/// OutPut:     result: 返回1保存成功, -1保存失败
ClassMethod LoadTemplate(ByRef AOutRecords As %GlobalCharacterStream, ATemplateVersionId As %String) As %String
{
	s result = "-1"		
    q:(ATemplateVersionId = "") result 
    s objTemplateVersion = ##Class(EMRmeta.TemplateVersion).%OpenId(ATemplateVersionId)
    q:(objTemplateVersion = "") result
    
    s objMetaData = ##class(%GlobalCharacterStream).%New()
    s objScriptData = ##Class(%GlobalCharacterStream).%New()
    s objInstanceData = ##class(%GlobalCharacterStream).%New()
    s objMediaData = ##Class(%GlobalCharacterStream).%New()
    s objInitialData = ##Class(%GlobalCharacterStream).%New()
    d objMetaData.CopyFrom(objTemplateVersion.MetaData)  	
    d objScriptData.CopyFrom(objTemplateVersion.ScriptData) 
    d objInstanceData.CopyFrom(objTemplateVersion.PresentationData)	
    d objMediaData.CopyFrom(objTemplateVersion.MediasData) 
    d objInitialData.CopyFrom(objTemplateVersion.InitialData)
    s TemplateID = objTemplateVersion.TemplateID
    s elementType = "Template"
    
    d AOutRecords.CopyFrom(..GetRecordXML(TemplateID,elementType,"","",objMetaData,objScriptData,objInstanceData,objMediaData,objInitialData))
	s result = "1"
	q result
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

/// w ##Class(web.DHCENS.STBLL.EMR.METHOD.EMRInstanceData ).Task("2019-12-02","2019-12-05","192.178.61.154")
ClassMethod Task(SDate As %String, EDate As %String, ipAddress As %String) As %String
{
	set:SDate["-" SDate=$zdh(SDate,3)
	set:EDate["-" EDate=$zdh(EDate,3)
	set j=0
	for i=SDate:1:EDate
	{
		set InstanceDataRowID=""
		set TempString=""
		for
		{
			set InstanceDataRowID=$o(^DHCEMRI.InstanceDataI("IdxModifyDate",i,InstanceDataRowID))
			Q:InstanceDataRowID=""
			set sub=""
			for
			{
				set sub=$o(^DHCEMRI.InstanceDataI("IdxModifyDate",i,InstanceDataRowID,sub))
				q:sub=""
				set xml=..InstanceDataContent(InstanceDataRowID_"||"_sub)
				continue:xml="0"
				set Toftp=##class(%Net.FtpSession).%New()
				set Toftp.TranslateTable="UTF8"
				set tSC=Toftp.Connect(ipAddress,"anonymous","")
				set ToftpDire="1202"
				set tSC=Toftp.SetDirectory(ToftpDire)
				set tSC=Toftp.Store(InstanceDataRowID_"_"_sub,xml)
				set tSC=Toftp.Logout()
				;b ;123
				set j=j+1
			}
		}
	}
	Q j
}

/// w ##Class(web.DHCENS.STBLL.EMR.METHOD.EMRInstanceData ).GetPrintTemplateVersionInfoFTP("192.178.61.154")
ClassMethod GetPrintTemplateVersionInfoFTP(ipAddress As %String) As %GlobalCharacterStream [ WebMethod ]
{
	;b ;123
	SET PrintTemplateID=""
	set j=0
	for
	{
		set PrintTemplateID=$o(^DHCEMRM.EMRTemplateI("IdxCategoryID",PrintTemplateID))
		q:PrintTemplateID=""
		set EMRTemplateRowID=""
		for
		{
		set EMRTemplateRowID=$o(^DHCEMRM.EMRTemplateI("IdxCategoryID",PrintTemplateID,EMRTemplateRowID))
		q:EMRTemplateRowID=""
		set BindTemplateID=$lg(^DHCEMRM.EMRTemplateD(EMRTemplateRowID),5)
		set PrintTemplateName=$lg(^DHCEMRM.EMRTemplateD(EMRTemplateRowID),2)
		;b ;BindTemplateID
		CONTINUE:BindTemplateID=$c(0)
		;b ;BindTemplateID
		set OutStream=##Class(%GlobalCharacterStream).%New()
		do OutStream.Write("<PrintTemplate>")
		set VersionNumber=""
		for
		{
			set XMLStream=##Class(%GlobalCharacterStream).%New()
			set VersionNumber=$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_BindTemplateID,VersionNumber),-1)
			q:VersionNumber=""
			set PrintTemplateVersionRowId=$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_BindTemplateID,VersionNumber,""))
			Set LastSaveDate=$zd($lg(^DHCEMRM.TemplateVersionD(PrintTemplateVersionRowId),6),3)
			set LastSaveTime=$zt($lg(^DHCEMRM.TemplateVersionD(PrintTemplateVersionRowId),7))
			set LastSaveDateTime=LastSaveDate_" "_LastSaveTime
			do OutStream.Write("<PrintTemplateInfo><PrintTemplateName>"_PrintTemplateName_"</PrintTemplateName>")
			do OutStream.Write("<xmlId>"_PrintTemplateVersionRowId_"</xmlId>")
			do OutStream.Write("<PrintTemplateID>"_BindTemplateID_"</PrintTemplateID>")
			do OutStream.Write("<PrintTemplateCategoryID>3||"_PrintTemplateID_"</PrintTemplateCategoryID>")
			do OutStream.Write("<VersionNumber>"_VersionNumber_"</VersionNumber>")
			do OutStream.Write("<LastSaveDateTime>"_LastSaveDateTime_"</LastSaveDateTime>")
			do OutStream.Write("<Content>")
			set tSC=..LoadTemplate(.XMLStream,PrintTemplateVersionRowId)
			Set tempStream=..base64Encode(XMLStream)
			do OutStream.CopyFrom(tempStream)
			do OutStream.Write("</Content></PrintTemplateInfo>")
		}
		do OutStream.Write("</PrintTemplate>")
		set Toftp=##class(%Net.FtpSession).%New()
		set Toftp.TranslateTable="UTF8"
		set tSC=Toftp.Connect(ipAddress,"anonymous","")
		set ToftpDire="1202"
		set tSC=Toftp.SetDirectory(ToftpDire)
		set tSC=Toftp.Store("3_"_PrintTemplateID,OutStream)
		set tSC=Toftp.Logout()
		;b ;tSC
		set j=j+1
		}
	}
	Q j
}

ClassMethod TransXML(InputString As %String) As %String
{
	Set InputString=$replace(InputString,"&","&amp;")
	Set InputString=$replace(InputString,"<","&lt;")
	Set InputString=$replace(InputString,">","&gt;")
	
	Set InputString=$replace(InputString,"'","&apos;")
	Set InputString=$replace(InputString,"""","&quot;")
	
	Set InputString=$replace(InputString,$c(2),"|")
	q InputString
}

}
