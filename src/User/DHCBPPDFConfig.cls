Class User.DHCBPPDFConfig Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPP_RowId, SqlTableName = DHC_BP_PDFConfig, StorageStrategy = CacheNewStorage ]
{

// FTP服务器IP

Property FTPSrvIP As %String [ SqlColumnNumber = 2, SqlFieldName = FTP_SrvIP ];

// FTP服务器端口

Property FTPSrvPortNo As %String [ SqlColumnNumber = 3, SqlFieldName = FTP_SrvPortNo ];

// FTP服务器权限用户

Property FTPSrvUserName As %String [ SqlColumnNumber = 4, SqlFieldName = FTP_SrvUserName ];

// FTP服务器权限密码

Property FTPSrvUserCode As %String [ SqlColumnNumber = 5, SqlFieldName = FTP_SrvUserCode ];

// FTP服务器路径文件夹

Property FTPFolderName As %String [ SqlColumnNumber = 6, SqlFieldName = FTP_FolderName ];

// FTP服务器上传类型

Property FTPType As %String [ SqlColumnNumber = 7, SqlFieldName = FTP_Type ];

// 是否启用

Property FTPActive As %String [ SqlColumnNumber = 8, SqlFieldName = FTP_Active ];

// 本地路径

Property FTPLocalPath As %String [ SqlColumnNumber = 9, SqlFieldName = FTP_LocalPath ];

// 本地路径

Property FTPHttpsPortNo As %String [ SqlColumnNumber = 10, SqlFieldName = FTP_HttpsPortNo ];

Storage CacheNewStorage
{
<Data name="DHCBPPDFConfigClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPPDFConfigDefaultData">
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
<Value>FTPActive</Value>
</Value>
<Value name="8">
<Value>FTPLocalPath</Value>
</Value>
<Value name="9">
<Value>FTPHttpsPortNo</Value>
</Value>
</Data>
<DataLocation>^DHCBPPDFConfig</DataLocation>
<DefaultData>DHCBPPDFConfigDefaultData</DefaultData>
<IdLocation>^DHCBPPDFConfig</IdLocation>
<IndexLocation>^DHCBPPDFConfig(0)</IndexLocation>
<StreamLocation>^User.DHCBPPDFConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
