Class EMRmeta.SDOPRecordSample Extends %Persistent [ ProcedureBlock ]
{

Property TemplateID As %String [ Required, SqlColumnNumber = 2 ];

Property TemplateVersion As %Integer [ Required, SqlColumnNumber = 3 ];

Property MetaData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.SDOPRecordSampleS") [ SqlColumnNumber = 4 ];

Property InstanceData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.SDOPRecordSampleS") [ SqlColumnNumber = 5 ];

/// 病历模板规则脚本定义信息
Property ScriptData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.SDOPRecordSampleS") [ SqlColumnNumber = 6 ];

Property MediasData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.SDOPRecordSampleS") [ SqlColumnNumber = 7 ];

Index IdxMain On (TemplateID, TemplateVersion) [ Unique ];

/// w ##Class(EMRmeta.SDOPRecordSample).GetID("26","15")
ClassMethod GetID(TemplateID, TemplateVersion) As %String
{
	s id = $O(^DHCEMRM.SDOPRecordSampleI("IdxMain"," "_TemplateID, TemplateVersion,""))
	q id
}

/// w ##Class(EMRmeta.SDOPRecordSample).Init()
ClassMethod Init()
{
	s TemplateID = "387"
 	s TemplateVersion = "4"
 	
 	s id = ..GetID(TemplateID, TemplateVersion)
 	if (id = "")
 	{
		s obj = ##class(EMRmeta.SDOPRecordSample).%New()
 	}
 	else
 	{
	 	s obj = ##class(EMRmeta.SDOPRecordSample).%OpenId(id)
 	}
 	
	s fs1 = ##Class(%FileBinaryStream).%New()
 	s fs1.Filename="/tmp/metadata.xml"
 	
 	s fs2 = ##Class(%FileBinaryStream).%New()
 	s fs2.Filename="/tmp/instancedata.xml"
 	
 	s fs3 = ##Class(%FileBinaryStream).%New()
 	s fs3.Filename="/tmp/mediasdata.xml"
 	
 	s fs4 = ##Class(%FileBinaryStream).%New()
 	s fs4.Filename="/tmp/scriptsdata.xml"
 	
 	s metastr = fs1.Read()
 	s inststr = fs2.Read()
 	s medistr = fs3.Read()
 	s scristr =	fs4.Read()
 	
 	s obj.TemplateID = "387"
 	s obj.TemplateVersion = "4"
 	d obj.MetaData.Write(metastr)
 	d obj.InstanceData.Write(inststr)
 	d obj.MediasData.Write(medistr)
 	d obj.ScriptData.Write(scristr)
 	
 	q obj.%Save()
}

Storage Default
{
<Data name="SDOPRecordSampleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateID</Value>
</Value>
<Value name="3">
<Value>TemplateVersion</Value>
</Value>
<Value name="4">
<Value>MetaData</Value>
</Value>
<Value name="5">
<Value>InstanceData</Value>
</Value>
<Value name="6">
<Value>ScriptData</Value>
</Value>
<Value name="7">
<Value>MediasData</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.SDOPRecordSampleD</DataLocation>
<DefaultData>SDOPRecordSampleDefaultData</DefaultData>
<IdLocation>^DHCEMRM.SDOPRecordSampleD</IdLocation>
<IndexLocation>^DHCEMRM.SDOPRecordSampleI</IndexLocation>
<StreamLocation>^DHCEMRM.SDOPRecordSampleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
