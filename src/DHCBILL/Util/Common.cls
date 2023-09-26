Class DHCBILL.Util.Common Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 常用加密方法
ClassMethod CommonLockMehtod(str)
{
	;s str=##class(%SYSTEM.Encryption).Base64Encode(str)
	;s str=##class(%SYSTEM.Encryption).Base64Decode(str)
	;s str=##class(%SYSTEM.Encryption).HMACMD5(str)
	;s str=##class(%SYSTEM.Encryption).MD5Hash(str)	
	
	q str
}

}
