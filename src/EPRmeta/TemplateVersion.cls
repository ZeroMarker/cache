Class EPRmeta.TemplateVersion Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Property Author As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Property InitialData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.TemplateVersionS");

Property LastSaveDate As %Date;

Property LastSaveTime As %Time;

Property MetaData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.TemplateVersionS");

Property PresentationData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.TemplateVersionS");

Property GridData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.TemplateVersionS");

Property PublicationDate As %Date;

Property PublicationTime As %Time;

Property Status As %Integer;

Property TemplateID As %String(TRUNCATE = 1);

Property VersionNumber As %Integer;

ClassMethod GetInitialData(ATEMPLATEID As %String, AVersionNumber As %Integer) As %Stream
{
 q:(($d(ATEMPLATEID)=0)||(ATEMPLATEID="")) ""
 q:(($d(AVersionNumber)=0)||(AVersionNumber=0)) ""
 	  
 new VersionID	 
 &sql(SELECT ID
 into :VersionID 
 FROM EPRmeta.TemplateVersion
 WHERE TemplateID = :ATEMPLATEID
 And VersionNumber = :AVersionNumber)

 if VersionID=""
 {
	Quit "" 
 }
 set objTemplateVersion = ##class(EPRmeta.TemplateVersion).%OpenId(VersionID)
 q:(objTemplateVersion="") ""

 QUIT objTemplateVersion.InitialData
}

ClassMethod GetMAXPublishVERSIONID(ATEMPLATEID As %String, APublishVerNumber As %String) As %String
{
 New Result
 new PublishVerNum
 &sql(SELECT Count(ID)
 into :PublishVerNum
 FROM EPRmeta.TemplateVersion
 WHERE TemplateID = :ATEMPLATEID)

 if (PublishVerNum=0)
 { Q "0"} 
 elseif (PublishVerNum>0)
 {
 &sql(SELECT ID
 into :Result
 FROM EPRmeta.TemplateVersion
 WHERE TemplateID = :ATEMPLATEID
 And VersionNumber = :APublishVerNumber  )
 QUIT Result

 }
}

ClassMethod GetMaxTemplateVersionNo(ATemplateID As %String, AStatus As %String) As %String
{
	n verNumber
	&sql(SELECT MAX(VersionNumber)
 	into :verNumber
 	FROM EPRmeta.TemplateVersion
 	WHERE TemplateID = :ATemplateID
 	AND Status= :AStatus)
 	q verNumber
}

ClassMethod GetMaxPubVrnID(ATEMPLATEID As %String) As %String
{
 set objTemplate = ##class(EPRmeta.Template).%OpenId(ATEMPLATEID)

 Q:(objTemplate="") ""
 s ^AAA($J,"PUb") = objTemplate.PublishVersion
 S ResultID= ##class(EPRmeta.TemplateVersion).GetMAXPublishVERSIONID(ATEMPLATEID,objTemplate.PublishVersion) 
 Q ResultID
}

ClassMethod GetMetaData(ATEMPLATEID As %String, AVersionNumber As %Integer) As %Stream
{
 q:(($d(ATEMPLATEID)=0)||(ATEMPLATEID="")) ""
 q:(($d(AVersionNumber)=0)||(AVersionNumber=0)) ""
 new VersionID	 
 &sql(SELECT ID
 into :VersionID 
 FROM EPRmeta.TemplateVersion
 WHERE TemplateID = :ATEMPLATEID
 And VersionNumber = :AVersionNumber)

 if VersionID=""
 {
	Quit "" 
 }
 set objTemplateVersion = ##class(EPRmeta.TemplateVersion).%OpenId(VersionID)
 q:(objTemplateVersion="") ""

 QUIT objTemplateVersion.MetaData
}

ClassMethod GetPresentationData(ATEMPLATEID As %String, AVersionNumber As %Integer) As %Stream
{
 q:(($d(ATEMPLATEID)=0)||(ATEMPLATEID="")) ""
 q:(($d(AVersionNumber)=0)||(AVersionNumber=0)) ""
 
 new VersionID	 
 &sql(SELECT ID
 into :VersionID 
 FROM EPRmeta.TemplateVersion
 WHERE TemplateID = :ATEMPLATEID
 And VersionNumber = :AVersionNumber)

 if VersionID=""
 {
	Quit "" 
 }
 set objTemplateVersion = ##class(EPRmeta.TemplateVersion).%OpenId(VersionID)
 q:(objTemplateVersion="") ""

 QUIT objTemplateVersion.PresentationData
}

ClassMethod SELECTMAXVERSION(ATEMPLATEID As %String) As %Integer
{
 new Result	 
 &sql(SELECT Count(VersionNumber)
 into :Result 
 FROM EPRmeta.TemplateVersion
 WHERE TemplateID = :ATEMPLATEID)

 if '(Result=0)
 {
 &sql(SELECT MAX(VersionNumber)
 into :Result 
 FROM EPRmeta.TemplateVersion
 WHERE TemplateID = :ATEMPLATEID)
}
 QUIT Result
}

Query SELECTALL(ATEMPLATEID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,TemplateID:%String,Author:%String,LastSaveDate:%Date,LastSaveTime:%Time,PublicationDate:%Date,PublicationTime:%Time,CreateDate:%Date,CreateTime:%Time,Status:%Integer,VersionNumber:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_TemplateVersion_SELECTALL, SqlProc ]
{
 SELECT ID,TemplateID,Author,LastSaveDate,LastSaveTime,
 PublicationDate,PublicationTime,CreateDate,CreateTime,Status,VersionNumber

 FROM EPRmeta.TemplateVersion
 WHERE TemplateID = :ATEMPLATEID
}

Storage Default
{
<Data name="TemplateVersionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Author</Value>
</Value>
<Value name="3">
<Value>InitialData</Value>
</Value>
<Value name="4">
<Value>LastSaveDate</Value>
</Value>
<Value name="5">
<Value>LastSaveTime</Value>
</Value>
<Value name="6">
<Value>MetaData</Value>
</Value>
<Value name="7">
<Value>PresentationData</Value>
</Value>
<Value name="8">
<Value>PublicationDate</Value>
</Value>
<Value name="9">
<Value>PublicationTime</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>TemplateID</Value>
</Value>
<Value name="12">
<Value>VersionNumber</Value>
</Value>
<Value name="13">
<Value>CreateDate</Value>
</Value>
<Value name="14">
<Value>CreateTime</Value>
</Value>
<Value name="15">
<Value>GridData</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.TemplateVersionD</DataLocation>
<DefaultData>TemplateVersionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.TemplateVersionD</IdLocation>
<IndexLocation>^DHCEPRM.TemplateVersionI</IndexLocation>
<StreamLocation>^DHCEPRM.TemplateVersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
