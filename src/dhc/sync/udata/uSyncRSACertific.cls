Class dhc.sync.udata.uSyncRSACertific Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Description:OA用户登录密码验证
/// Table：
/// Input：
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.sync.udata.uSyncRSACertific).Certific("CCC3203","I5u+cOLbFVzDgTdRFfqB/q/vfoB9lSXyXCgk2saeyLbJstEkJuDmtreFS127t0eEkpobKBQUz/ELJpNVkS61eoI/R9winwiIRqiJYArBQt6VbdrslKDVIV1I0GlGSu8x1xxoC64Te5qVlELLnDcyqKe0/ScmTXcpsGCEcqAkcNk=")
ClassMethod Certific(ucode, pass) As %String
{
	
	n (ucode, pass)
	s userid=0
	;w ucode,!
	k ^temphss
	s ^temphss=ucode_"^"_pass
	s certific=##class(web.Util.Encryption).%New()
	s psw = certific.RSADecrypt(pass ,"D:\DSKeys\OA_Privatekey.pem")
	;w psw,!
	s userid=$o(^dhcsyncUserI("SyncUserCode",ucode,userid))
	;w userid,!
	s pswm=$List(^dhcsyncUserD(userid),4)
	;w pswm,!	
	q:psw=pswm 0
	q:psw'=pswm -1
}

Storage Default
{
<StreamLocation>^dhc.sync.u77EA.uSyncRSACer3D03S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
