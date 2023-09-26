Class EPRmeta.PrintTemplateVersion Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Property Author As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Property Data As %GlobalCharacterStream(LOCATION = "^DHCEPRM.PrintTemplateVersionS");

Property LastSaveDate As %Date;

Property LastSaveTime As %Time;

Property PrintTemplateID As %String(TRUNCATE = 1);

Property PublicationDate As %Date;

Property PublicationTime As %Time;

Property ShapeNames As %String(MAXLEN = 2500, TRUNCATE = 1);

Property Status As %Integer;

Property VersionNumber As %Integer;

Property HeadStartPageNum As %String(TRUNCATE = 1) [ InitialExpression = "0" ];

Property FootRepeatRowStart As %String(TRUNCATE = 1) [ InitialExpression = "0" ];

Property FootRepeatRowEnd As %String(TRUNCATE = 1) [ InitialExpression = "0" ];

Property OnePageRowCount As %String(TRUNCATE = 1) [ InitialExpression = "0" ];

Property Duplex As %Boolean;

Property MultiplePagesOption As %String(TRUNCATE = 1);

Property NewPageStartOdd As %Boolean;

Property BlankPageStyle As %String(TRUNCATE = 1);

Index IdxForPrintTIDAndVerNum On (PrintTemplateID, VersionNumber);

ClassMethod GetMaxPublishVersionID(ATEMPLATEID As %String, VnNum As %Integer) As %String
{
 ;B "S"
 New Result
 new PublishVerNum
 &sql(SELECT Count(ID)
 into :PublishVerNum
 FROM EPRmeta.PrintTemplateVersion
 WHERE PrintTemplateID = :ATEMPLATEID)

 if (PublishVerNum=0)
 { Q "0"} 
 elseif (PublishVerNum>0)
 {
 &sql(SELECT ID
 into :Result
 FROM EPRmeta.PrintTemplateVersion
 WHERE PrintTemplateID = :ATEMPLATEID
 And VersionNumber = :VnNum  )
 QUIT Result
 }
}

ClassMethod SELECTMAXVERSION(ATEMPLATEID As %String) As %Integer
{
 new Result
 &sql(SELECT MAX(VersionNumber)
 into :Result 
 FROM EPRmeta.PrintTemplateVersion
 WHERE PrintTemplateID = :ATEMPLATEID)
 QUIT Result
}

ClassMethod SELECTMAXVERSIONID(ATEMPLATEID As %String) As %Integer
{
 //B "S"
 New Result
 new MaxVerNum
 &sql(SELECT MAX(VersionNumber)
 into :MaxVerNum
 FROM EPRmeta.PrintTemplateVersion
 WHERE PrintTemplateID = :ATEMPLATEID)

 if (MaxVerNum=0)
 { Q "0"} 
 elseif (MaxVerNum>0)
 {
 &sql(SELECT ID
 into :Result
 FROM EPRmeta.PrintTemplateVersion
 WHERE PrintTemplateID = :ATEMPLATEID
 And VersionNumber = :MaxVerNum  )
 QUIT Result
 }
}

Query SELECTALL(ATEMPLATEID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,PrintTemplateID:%String,Author:%String,LastSaveDate:%Date,LastSaveTime:%Time,PublicationDate:%Date,PublicationTime:%Time,CreateDate:%Date,CreateTime:%Time,Status:%Integer,VersionNumber:%Integer,ShapeNames:%String,HeadStartPageNum:%String,FootRepeatRowStart:%String,FootRepeatRowEnd:%String,OnePageRowCount:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_PrintTemplateVersion_SELECTALL, SqlProc ]
{
 SELECT ID,PrintTemplateID,Author,LastSaveDate,LastSaveTime,
 PublicationDate,PublicationTime,CreateDate,CreateTime,Status,VersionNumber,ShapeNames,HeadStartPageNum,FootRepeatRowStart,FootRepeatRowEnd,OnePageRowCount
 FROM EPRmeta.PrintTemplateVersion
 WHERE PrintTemplateID = :ATEMPLATEID
}

Storage Default
{
<Data name="PrintTemplateVersionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Data</Value>
</Value>
<Value name="3">
<Value>PrintTemplateID</Value>
</Value>
<Value name="4">
<Value>Version</Value>
</Value>
<Value name="5">
<Value>Author</Value>
</Value>
<Value name="6">
<Value>LastSaveDate</Value>
</Value>
<Value name="7">
<Value>LastSaveTime</Value>
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
<Value>ShapeNames</Value>
</Value>
<Value name="16">
<Value>HeadStartPageNum</Value>
</Value>
<Value name="17">
<Value>FootRepeatRowEnd</Value>
</Value>
<Value name="18">
<Value>FootRepeatRowStart</Value>
</Value>
<Value name="19">
<Value>MultiplePagesOption</Value>
</Value>
<Value name="20">
<Value>OnePageRowCount</Value>
</Value>
<Value name="21">
<Value>Duplex</Value>
</Value>
<Value name="22">
<Value>NewPageStartOdd</Value>
</Value>
<Value name="23">
<Value>BlankPageStyle</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.PrintTemplateVersionD</DataLocation>
<DefaultData>PrintTemplateVersionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.PrintTemplateVersionD</IdLocation>
<IndexLocation>^DHCEPRM.PrintTemplateVersionI</IndexLocation>
<StreamLocation>^DHCEPRM.PrintTemplateVersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
