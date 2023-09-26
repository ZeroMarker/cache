/// 名称：DHCMed.IMP.ImpPatStatus
/// 描述：重点病人记录状态日志
/// 创建者：李阳
/// 创建日期：2010-05-25
Class DHCMed.IMP.ImpPatStatus Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 归属
/// 指向DHCMed.IMP.ImpPatient
Property ParentID As %String(TRUNCATE = 1);

Index IndexParent On ParentID;

/// 状态ID
/// 指向DHCMed.SS.Dictionary
Property StatusID As %String(TRUNCATE = 1);

/// 操作日期
Property OperationDate As %Date;

/// 操作时间
Property OperationTime As %Time;

/// 操作员ID
/// 指向DHCMed.Base.SSUser
Property OperationUser As %String(TRUNCATE = 1);

/// 备注
Property ResumeText As %String(TRUNCATE = 1);

ClassMethod Update(arg As %String, Delimiter As %String = "^") As %Integer
{
	New (arg,Delimiter)
	s return=0
	s:$g(Delimiter)="" Delimiter=$c(1)
	s ID=$p(arg,Delimiter,1)
	i ID=""  d
	.s obj=##class(DHCMed.IMP.ImpPatStatus).%New()
	e  d
	.s obj=##class(DHCMed.IMP.ImpPatStatus).%OpenId(ID)
	set obj.ParentID=$p(arg,Delimiter,2)
	set obj.StatusID=$p(arg,Delimiter,3)
	set obj.OperationDate=$p(arg,Delimiter,4)
	set obj.OperationTime=$p(arg,Delimiter,5)
	set:$p(arg,Delimiter,4)["-" obj.OperationDate=$zdh($p(arg,Delimiter,4),3)
	set:$p(arg,Delimiter,5)[":" obj.OperationTime=$zth($p(arg,Delimiter,5),1)
	set obj.OperationUser=$p(arg,Delimiter,6)
	set obj.ResumeText=$p(arg,Delimiter,7)
	s sc=obj.%Save()
	if obj'="" d obj.%Close()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
	}
	k obj	q id
}

/// 查找重点患者的状态变更记录
/// d ##Class(%ResultSet).RunQuery("DHCMed.IMP.ImpPatStatus","QueryByParent",2)
Query QueryByParent(ParentID As %String) As %Query(ROWSPEC = "ID:%String,StatusID:%String,Status:%String:状态,OpeDate:%String:操作日期,OpeTime:%String:操作时间,Operator:%String:操作员,ResumeText:%String:备注")
{
}

ClassMethod QueryByParentExecute(ByRef qHandle As %Binary, ParentID As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   Set ind=1
   Set qHandle=$lb(0,repid,0)
   s key=" "_ParentID
   s rowid="" f  s rowid=$o(^DHCMed.IMP.ImpPatStatusI("IndexParent",key,rowid),-1) q:rowid=""  d
   .s objStatus=##class(DHCMed.IMP.ImpPatStatus).%OpenId(rowid)
   .q:$IsObject(objStatus)=0
   .d objStatus.%Close()
   .s objStatusDic=##class(DHCMed.SS.Dictionary).%OpenId(objStatus.StatusID)
   .q:$IsObject(objStatusDic)=0
   .d objStatusDic.%Close()
   .s objUser=##class(DHCMed.Base.SSUser).GetObjById(objStatus.OperationUser)
   .s:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
   .s data=$lb("")
   .s $li(data,1)=objStatus.%Id()
   .s $li(data,2)=objStatus.StatusID
   .s $li(data,3)=objStatusDic.Description
   .s $li(data,4)=$s(objStatus.OperationDate'="":$zd(objStatus.OperationDate,3),1:"")
   .s $li(data,5)=$s(objStatus.OperationTime'="":$zt(objStatus.OperationTime,1),1:"")
   .s $li(data,6)=objUser.Name
   .s $li(data,7)=objStatus.ResumeText
   .s ^CacheTemp(repid,ind)=data
   .s ind=ind+1
   .d objUser.%Close()
   .k objStatus
   .k objStatusDic
   .k objUser
   Quit $$$OK
}

ClassMethod QueryByParentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByParentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByParentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByParentExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="ImpPatStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OperationDate</Value>
</Value>
<Value name="3">
<Value>OperationTime</Value>
</Value>
<Value name="4">
<Value>OperationUser</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
<Value name="6">
<Value>StatusID</Value>
</Value>
<Value name="7">
<Value>ParentID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.IMP.ImpPatStatusD</DataLocation>
<DefaultData>ImpPatStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.IMP.ImpPatStatusD</IdLocation>
<IndexLocation>^DHCMed.IMP.ImpPatStatusI</IndexLocation>
<StreamLocation>^DHCMed.IMP.ImpPatStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
