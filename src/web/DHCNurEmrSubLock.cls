Class web.DHCNurEmrSubLock Extends %Persistent
{

//判断是否加锁

ClassMethod isLockEmrSub(code) As %String
{
	//s ^objcyf888=code
	q:code="" ""
	s code=$zcvt(code,"U")
	s ret=""
	i $d(^NurEmr.NurEmrSubLock(code))  d
	.s ret=^NurEmr.NurEmrSubLock(code)
	q ret
}

//给模板加锁

ClassMethod LockEmrSub(code, ip, hander) As %String
{
	s code=$zcvt(code,"U")
	q:code="" 0
	//i '$d(^NurEmr.NurEmrSubLock(code))  d
	s ^NurEmr.NurEmrSubLock(code)=ip_"^"_hander
	q 0
}

//给模板解锁

ClassMethod unLockEmrSub(code) As %String
{
	s code=$zcvt(code,"U")
	q:code="" 0
	i $d(^NurEmr.NurEmrSubLock(code))  d
	.k ^NurEmr.NurEmrSubLock(code)
	q 0
}

Storage Default
{
<Data name="DHCNurEmrSubLockDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCNurEmrSubLockD</DataLocation>
<DefaultData>DHCNurEmrSubLockDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCNurEmrSubLockD</IdLocation>
<IndexLocation>^web.DHCNurEmrSubLockI</IndexLocation>
<StreamLocation>^web.DHCNurEmrSubLockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
