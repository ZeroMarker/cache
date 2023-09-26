Class EPRmeta.ImageAnnotate Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property YCode As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property ImageData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.ImageAnnotateS");

ClassMethod CheckDataExits(ATemplateID As %String, ATemplateVersion As %String, AYCode As %String) As %String
{
 new Result
 &sql(SELECT Count(YCode)
 into :Result 
 FROM EPRmeta.ImageAnnotate
 WHERE YCode = :AYCode
 And TemplateID= :ATemplateID
 And TemplateVersion = :ATemplateVersion
 )
 if ((Result="")!(Result=0))
 {
 s Result="0"
 }
 elseif ((Result'="")&&(Result'=0)) 
 {  
 &sql(SELECT ID
 into :Result 
 FROM EPRmeta.ImageAnnotate
 WHERE YCode = :AYCode
 And TemplateID= :ATemplateID
 And TemplateVersion = :ATemplateVersion)
 }
 
 QUIT Result
}

ClassMethod CreateAnnotate(ANIAnnotate As EPRmeta.Parser.NIAnnotate) As %String
{
 set NewAnnotate = ##class(EPRmeta.ImageAnnotate).%New()
 set NewAnnotate.TemplateID =ANIAnnotate.TemplateID   
 set NewAnnotate.YCode =ANIAnnotate.Code   
 set NewAnnotate.TemplateVersion =ANIAnnotate.TemplateVersion 
 d NewAnnotate.ImageData.CopyFrom(ANIAnnotate.ImageData)   
 if (NewAnnotate.%Save())
 {
   s Result= "1"	 
	 }
  else 
  {s Result="0"}
  
  QUIT Result
}

ClassMethod UpdateAnnotate(ANIAnnotate As EPRmeta.Parser.NIAnnotate, AID As %String) As %String
{
 set NewAnnotate = ##class(EPRmeta.ImageAnnotate).%OpenId(AID)
 set NewAnnotate.TemplateID =ANIAnnotate.TemplateID   
 set NewAnnotate.YCode =ANIAnnotate.Code   
 set NewAnnotate.TemplateVersion =ANIAnnotate.TemplateVersion
 /*d ANIAnnotate.ImageData.Rewind()
 While (ANIAnnotate.ImageData.AtEnd = 0) 
 {
 Set len = 100
 set TmpStrText= ANIAnnotate.ImageData.Read(len)
 set StrText= StrText_TmpStrText  
 }
 B "S"*/
 d NewAnnotate.ImageData.Clear() 
 d NewAnnotate.ImageData.CopyFrom(ANIAnnotate.ImageData)   
 if (NewAnnotate.%Save())
 {
   s Result= "1"	 
	 }
  else 
  {s Result="0"}
  
  QUIT Result
}

ClassMethod DeleteAnnotateByVersion(AVersionID As %String, ATemplateID As %String)
{
 &sql(Delete
 FROM EPRmeta.ImageAnnotate
 WHERE  TemplateID= :ATemplateID
 And TemplateVersion = :AVersionID)
}

Storage Default
{
<Data name="ImageAnnotateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>YCode</Value>
</Value>
<Value name="3">
<Value>TemplateID</Value>
</Value>
<Value name="4">
<Value>TemplateVersion</Value>
</Value>
<Value name="5">
<Value>ImageData</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.ImageAnnotateD</DataLocation>
<DefaultData>ImageAnnotateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.ImageAnnotateD</IdLocation>
<IndexLocation>^DHCEPRM.ImageAnnotateI</IndexLocation>
<StreamLocation>^DHCEPRM.ImageAnnotateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
