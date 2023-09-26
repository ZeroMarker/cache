Class DHCEPRFS.Entity.EFileRegister Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// ID
Property FileMasterID As %String(MAXLEN = 50, TRUNCATE = 1);

Property FullFileMasterName As %String(MAXLEN = 500, TRUNCATE = 1);

Property FullFileLocName As %String(MAXLEN = 500, TRUNCATE = 1);

Property MD5Code As %String(MAXLEN = 50, TRUNCATE = 1);

Property NameSpace As %String(MAXLEN = 50, TRUNCATE = 1);

}
