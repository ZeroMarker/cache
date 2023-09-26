Class User.DHCANCPDFConfig Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_ANC_PDFConfig, StorageStrategy = CacheNewStorage ]
{

Property FTPSrvIP As %String [ SqlColumnNumber = 2, SqlFieldName = FTP_SrvIP ];

Property FTPSrvPortNo As %String [ SqlColumnNumber = 3, SqlFieldName = FTP_SrvPortNo ];

Property FTPSrvUserName As %String [ SqlColumnNumber = 4, SqlFieldName = FTP_SrvUserName ];

Property FTPSrvUserCode As %String [ SqlColumnNumber = 5, SqlFieldName = FTP_SrvUserCode ];

Property FTPFolderName As %String [ SqlColumnNumber = 6, SqlFieldName = FTP_FolderName ];

Property FTPType As %String [ SqlColumnNumber = 7, SqlFieldName = FTP_Type ];

Property FTPHttpsPortNo As %String [ SqlColumnNumber = 8, SqlFieldName = FTP_HttpsPortNo ];

Storage CacheNewStorage
{
<Data name="DHCANCPDFConfigClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANCPDFConfigDefaultData">
<Value name="1">
<Value>FTPSrvIP</Value>
</Value>
<Value name="2">
<Value>FTPSrvPortNo</Value>
</Value>
<Value name="3">
<Value>FTPSrvUserName</Value>
</Value>
<Value name="4">
<Value>FTPSrvUserCode</Value>
</Value>
<Value name="5">
<Value>FTPFolderName</Value>
</Value>
<Value name="6">
<Value>FTPType</Value>
</Value>
<Value name="7">
<Value>FTPHttpsPortNo</Value>
</Value>
</Data>
<DataLocation>^DHCANCPDFConfig</DataLocation>
<DefaultData>DHCANCPDFConfigDefaultData1</DefaultData>
<IdLocation>^DHCANCPDFConfig</IdLocation>
<IndexLocation>^DHCANCPDFConfig(0)</IndexLocation>
<StreamLocation>^User.DHCANCPDFConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
