Class EMRservice.BL.BLTemplateVersion Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Query SELECTALL(ATEMPLATEID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,TemplateID:%String,Author:%String,LastSaveDate:%Date,LastSaveTime:%Time,PublicationDate:%Date,PublicationTime:%Time,CreateDate:%Date,CreateTime:%Time,Status:%Integer,VersionNumber:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_TemplateVersion_SELECTALL, SqlProc ]
{
 SELECT ID,TemplateID,Author,LastSaveDate,LastSaveTime,
 PublicationDate,PublicationTime,CreateDate,CreateTime,Status,VersionNumber

 FROM EMRmeta.TemplateVersion
 WHERE TemplateID = :ATEMPLATEID
}

Query SELECTALLVersion() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,TemplateID:%String,Author:%String,LastSaveDate:%Date,LastSaveTime:%Time,PublicationDate:%Date,PublicationTime:%Time,CreateDate:%Date,CreateTime:%Time,Status:%Integer,VersionNumber:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_TemplateVersion_SELECTALLVersion, SqlProc ]
{
 SELECT ID,TemplateID,Author,LastSaveDate,LastSaveTime,
 PublicationDate,PublicationTime,CreateDate,CreateTime,Status,VersionNumber

 FROM EMRmeta.TemplateVersion
}

ClassMethod GetMetaData(ATEMPLATEID As %String, AVersionNumber As %Integer) As %Stream
{
	q:(($d(ATEMPLATEID)=0)||(ATEMPLATEID="")) ""
	q:(($d(AVersionNumber)=0)||(AVersionNumber=0)) ""
	&sql(SELECT ID into :VersionID 
	     FROM EMRmeta.TemplateVersion
 	     WHERE TemplateID = :ATEMPLATEID
 	     And VersionNumber = :AVersionNumber)
 	
 	q:(VersionID="") ""
 	s objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(VersionID)
    q:(objTemplateVersion="") ""
    QUIT objTemplateVersion.MetaData
}

ClassMethod GetPresentationData(ATEMPLATEID As %String, AVersionNumber As %Integer) As %Stream
{
 q:(($d(ATEMPLATEID)=0)||(ATEMPLATEID="")) ""
 q:(($d(AVersionNumber)=0)||(AVersionNumber=0)) ""
 
 
 &sql(SELECT ID
 into :VersionID 
 FROM EMRmeta.TemplateVersion
 WHERE TemplateID = :ATEMPLATEID
 And VersionNumber = :AVersionNumber)

 if VersionID=""
 {
	Quit "" 
 }
 set objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(VersionID)
 q:(objTemplateVersion="") ""

 QUIT objTemplateVersion.PresentationData
}

ClassMethod SELECTMAXVERSION(ATEMPLATEID As %String) As %Integer
{
 
 &sql(SELECT Count(VersionNumber)
 into :Result 
 FROM EMRmeta.TemplateVersion
 WHERE TemplateID = :ATEMPLATEID)

 if '(Result=0)
 {
 &sql(SELECT MAX(VersionNumber)
 into :Result 
 FROM EMRmeta.TemplateVersion
 WHERE TemplateID = :ATEMPLATEID)
}
 QUIT Result
}

ClassMethod GetMaxVrnID(ATEMPLATEID As %String) As EMRservice.entity.ETemplateVersion
{
 s Result = ##class(EMRservice.entity.ETemplateVersion).%New()
 s objTemplate = ##class(EMRmeta.Template).%OpenId(ATEMPLATEID)
 q:(objTemplate="") Result
 s VerNum= objTemplate.LastVersion 
 s temVerID =$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_ATEMPLATEID,VerNum,""))
 q:(objTemplate="") Result
 s objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(temVerID)
 q:(objTemplateVersion="") Result

 s Result.ID = objTemplateVersion.%Id()
 s Result.Author = objTemplateVersion.Author
 s Result.CreateDate = objTemplateVersion.CreateDate
 s Result.CreateTime = $ZTIME(objTemplateVersion.CreateTime)
 s Result.LastSaveDate = objTemplateVersion.LastSaveDate
 s Result.LastSaveTime = $ZTIME(objTemplateVersion.LastSaveTime)
 s Result.PublicationDate =objTemplateVersion.PublicationDate
 s Result.PublicationTime = $ZTIME(objTemplateVersion.PublicationTime)
 s Result.VersionNumber = objTemplateVersion.VersionNumber
 s Result.Status = objTemplateVersion.Status
 s Result.MetaData = objTemplateVersion.MetaData
 s Result.PresentationData = objTemplateVersion.PresentationData
 s Result.MediasData = objTemplateVersion.MediasData
 
 q Result
}

ClassMethod GetMaxPubVrnID(ATEMPLATEID As %String) As %String
{
 set objTemplate = ##class(EMRmeta.Template).%OpenId(ATEMPLATEID)

 Q:(objTemplate="") ""
 S ResultID= ..GetMAXPublishVERSIONID(ATEMPLATEID,objTemplate.PublishVersion) 
 Q ResultID
}

ClassMethod GetMAXPublishVERSIONID(ATEMPLATEID As %String, APublishVerNumber As %String) As %String
{
 &sql(SELECT Count(ID)
 into :PublishVerNum
 FROM EMRmeta.TemplateVersion
 WHERE TemplateID = :ATEMPLATEID)

 if (PublishVerNum=0)
 { Q "0"} 
 elseif (PublishVerNum>0)
 {
 &sql(SELECT ID
 into :Result
 FROM EMRmeta.TemplateVersion
 WHERE TemplateID = :ATEMPLATEID
 And VersionNumber = :APublishVerNumber  )
 QUIT Result

 }
}

/// Desc:       保存模板
/// Creator:    candy
/// Createdate: 2014-01-25
/// Input:      argInData 模板文件流
///             TemplateVersionId   
/// Output:     result 1成功,-1失败 
ClassMethod SaveTemplate(argInData As %GlobalBinaryStream, TemplateVersionId As %String, Author As %String = "") As %String
{
	s result = "-1"		
    q:((TemplateVersionId = "")||(argInData = "")) result 
    s streamMetaData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<MetaData","</MetaData>","11")
    s streamScriptData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<Scripts>","</Scripts>","10")
    s streamMediasData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<Medias>","</Medias>","9")
    s streamInitialData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<InitialData>","</InitialData>","14")
    s streamPresentationData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<PresentationData>","</PresentationData>","19")
    s objTemplateVersion = ##Class(EMRmeta.TemplateVersion).%OpenId(TemplateVersionId)
    q:(objTemplateVersion = "") result
	

	
    d objTemplateVersion.MetaData.Clear()
    d objTemplateVersion.ScriptData.Clear()
    d objTemplateVersion.MediasData.Clear()
    d objTemplateVersion.InitialData.Clear()
    d objTemplateVersion.PresentationData.Clear()
    
    s objTemplateVersion.Status = 1
    s objTemplateVersion.Author = Author
    d objTemplateVersion.MetaData.CopyFrom(streamMetaData)
    d objTemplateVersion.ScriptData.CopyFrom(streamScriptData)
    d objTemplateVersion.PresentationData.CopyFrom(streamPresentationData)
    d objTemplateVersion.MediasData.CopyFrom(streamMediasData)
    d objTemplateVersion.InitialData.CopyFrom(streamInitialData)
    s objTemplateVersion.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))
	s objTemplateVersion.LastSaveTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
    s sc = objTemplateVersion.%Save()
   
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// CreateTime: 2014-02-12
/// Creator:    candy
/// Desc:		得到模板xml文档
/// Input:		ATemplateVersionId: 模板版本ID
///             AOutRecords: 返回xml 
/// OutPut:     result: 返回1保存成功, -1保存失败
ClassMethod LoadTemplate(ByRef AOutRecords As %GlobalBinaryStream, ATemplateVersionId As %String) As %String
{
	s result = "-1"		
    q:(ATemplateVersionId = "") result 
    s objTemplateVersion = ##Class(EMRmeta.TemplateVersion).%OpenId(ATemplateVersionId)
    q:(objTemplateVersion = "") result
    
    s objMetaData = ##class(%GlobalBinaryStream).%New()
    s objScriptData = ##Class(%GlobalBinaryStream).%New()
    s objInstanceData = ##class(%GlobalBinaryStream).%New()
    s objMediaData = ##Class(%GlobalBinaryStream).%New()
    s objInitialData = ##Class(%GlobalBinaryStream).%New()
    d objMetaData.CopyFrom(objTemplateVersion.MetaData)  	
    d objScriptData.CopyFrom(objTemplateVersion.ScriptData) 
    d objInstanceData.CopyFrom(objTemplateVersion.PresentationData)	
    d objMediaData.CopyFrom(objTemplateVersion.MediasData) 
    d objInitialData.CopyFrom(objTemplateVersion.InitialData)
    s TemplateID = objTemplateVersion.TemplateID
    s elementType = "Template"
    
    d AOutRecords.CopyFrom(##Class(EMRservice.BL.BLTemplate).GetRecordXML(TemplateID,elementType,"","",objMetaData,objScriptData,objInstanceData,objMediaData,objInitialData))
	s result = "1"
	q result
}

ClassMethod UpdateTemVSummary(AVersionID As %String, ASummary As %String) As %String
{
	s result = "-1"	
	q:(AVersionID="") result
	set objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(AVersionID)
	if (objTemplateVersion'="")
	{
		s objTemplateVersion.TemplateSummary = ASummary
		s result = objTemplateVersion.%Save()
	}
	q result
}

}
