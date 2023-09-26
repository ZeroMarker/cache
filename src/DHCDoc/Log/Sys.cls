/// creator：郭荣勇
/// date：2019-11-12
/// desc：记录系统及数据库相关日志的公共方法
Class DHCDoc.Log.Sys Extends %RegisteredObject [ ProcedureBlock ]
{

/// creator:郭荣勇
/// date:2019-11-12
/// desc:获取特定命名空间下的锁记录,可用于记录日志
/// d ##class(DHCDoc.Log.Sys).LockLog(.Ary,"DHC-APP","^RBAS")
ClassMethod LockLog(LockAry As %DynamicArray, NSpace As %String, containLockName As %String = "")
{
	;%Library.DynamicArray
	SET lname=""
	FOR I=1:1 {
		SET lname=$ORDER(^$|NSpace|LOCK(lname))
		QUIT:lname=""
		continue:(containLockName'="")&&(lname'[containLockName)
		SET LockAry(I)=lname
		set LockAry(I,"info")="OWNER:"_^$LOCK(lname,"OWNER")_","_"FLAGS:"_^$LOCK(lname,"FLAGS")_","_"MODE:"_^$LOCK(lname,"MODE")
		;示例,owner为进程ID
		;WRITE !,"the lock name is: ",lname
		;WRITE !,"lock owner: ",^$LOCK("^B(1,1)","OWNER")
		;WRITE !,"lock flags: ",^$LOCK("^B(1,1)","FLAGS")
		;WRITE !,"lock mode: ",^$LOCK("^B(1,1)","MODE")
		;WRITE !,"lock counts: "
		;ZZDUMP ^$LOCK("^B(1,1)","COUNTS")
	}
	
	Q
}

/// creator:郭荣勇
/// date:2019-11-12
/// desc:获取进程ID的进程明细信息,可用于记录日志
/// d ##class(DHCDoc.Log.Sys).GetProcessDetail("9636",.ary)
ClassMethod GetProcessDetail(pid As %String, ProDetailAry As %DynamicArray)
{
	s Process=##CLASS(%SYS.ProcessQuery).%OpenId(pid)
	s ProcessDefObj=##Class(%Dictionary.CompiledClass).%OpenId("%SYS.ProcessQuery")
	s cnt=ProcessDefObj.Properties.Count()
	for i=1:1:cnt {
		s PropertyName=ProcessDefObj.Properties.GetAt(i).Name
		continue:PropertyName="%Concurrency"
		continue:PropertyName="%IsInSave"
		continue:(ProcessDefObj.Properties.GetAt(i).Private=1)
		s mValue=$ZOBJPROPERTY(Process,PropertyName)
		s ProDetailAry(PropertyName)=mValue
	}
	
	Q
}

}
