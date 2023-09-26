/// 创建人：李阳
/// 名称：DHCMed.IMP.DutyUser
/// 重点患者责任人交接信息
Class DHCMed.IMP.DutyUser Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 重点病人记录
Property ParentID As %Integer;

Index ParentIDIndex On ParentID;

/// 开始日期
Property FromDate As %Date;

/// 开始时间
Property FromTime As %Time;

/// 责任人ID，指向SSUser
Property DutyUserID As %String(TRUNCATE = 1);

Index DutyUserIDIndex On DutyUserID As Exact;

/// 是否活动
Property IsActive As %Boolean;

/// 备注
Property ResumeText As %String(TRUNCATE = 1);

/// 更新人指向SSUser
Property UpdateUser As %Integer;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 责任科室ID，指向CT_Loc
Property DutyLocID As %String(TRUNCATE = 1);

/// 通过重点病人记录的ID查找责任人交接信息
/// ImpRowID：重点病人记录的Rowid
ClassMethod GetByParent(ImpRowID As %String) As %Library.ListOfObjects
{
	s arry=##class(%Library.ListOfObjects).%New()
	s ImpRowID=+ImpRowID
	s rowid="" f  s rowid=$o(^DHCMed.IMP.DutyUserI("ParentIDIndex",ImpRowID,rowid),-1) q:rowid=""  d
	.s obj=##class(DHCMed.IMP.DutyUser).%OpenId(rowid)
	.q:$IsObject(obj)=0
	.d obj.%Close()
	.d arry.Insert(obj)
	d arry.%Close()
	q arry
}

/// 通过重点病人记录ID查询责任人交接记录
/// d ##Class(%ResultSet).RunQuery("DHCMed.IMP.DutyUser","QueryByImpID",3)
Query QueryByImpID(ImpRowID As %String) As %Query(ROWSPEC = "RowID:%String,FromDate:%String:开始日期,FromTime:%String:开始时间,DutyUserCode:%String:责任人工号,DutyUserName:%String:责任人,ResumeText:%String:备注,DutyLocID:%String:责任科室ID,DutyLocDesc:%String:责任科室")
{
}

ClassMethod QueryByImpIDExecute(ByRef qHandle As %Binary, ImpRowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:ImpRowID="" $$$OK
	s arry=..GetByParent(ImpRowID)
	s cnt=arry.Count()
	f i=1:1:cnt  d
	.s obj=arry.GetAt(i)
	.s data=$lb("")
	.s $li(data,1)=obj.%Id()
	.s $li(data,2)=$zd(+obj.FromDate,3)
	.s $li(data,3)=$zt(+obj.FromTime,1)
	.s objUser=##class(DHCMed.Base.SSUser).GetObjById(obj.DutyUserID)
	.i $IsObject(objUser)  d
	..s $li(data,4)=objUser.Code
	..s $li(data,5)=objUser.Name
	..d objUser.%Close()
	..k objUser
	.s $li(data,6)=obj.ResumeText
	.s DutyLocID=obj.DutyLocID
	.s DutyLocDesc=""
	.s:DutyLocID'="" DutyLocDesc=$p($g(^CTLOC(DutyLocID)),"^",2)
	.s $li(data,7)=DutyLocID
	.s $li(data,8)=$g(DutyLocDesc)
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	d arry.%Close()
	k arry
	Quit $$$OK
}

ClassMethod QueryByImpIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByImpIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryByImpIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByImpIDExecute ]
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

/// w ##class(DHCMed.IMP.DutyUser).Update("^3^^1^1^Resume^1^^^")
ClassMethod Update(arg As %String, Delimiter As %String = "^") As %Integer
{
	New (arg,Delimiter)
	s return=0
	s:$g(Delimiter)="" Delimiter=$c(1)
	s ID=$p(arg,Delimiter,1)
	i ID=""  d
	.s obj=##class(DHCMed.IMP.DutyUser).%New()
	e  d
	.s obj=##class(DHCMed.IMP.DutyUser).%OpenId(ID)
	s obj.ParentID=$p(arg,Delimiter,2)
	s obj.FromDate=$p(arg,Delimiter,3)
	s obj.FromTime=$p(arg,Delimiter,4)
	s obj.DutyUserID=$p(arg,Delimiter,5)
	s obj.IsActive=$p(arg,Delimiter,6)
	s obj.ResumeText=$p(arg,Delimiter,7)
	s obj.UpdateUser=$p(arg,Delimiter,8)
	s obj.UpdateDate=$p(arg,Delimiter,9)
	s:obj.UpdateDate["-" obj.UpdateDate=$zdh(obj.UpdateDate,3)
	s:obj.UpdateDate="" obj.UpdateDate=+$h
	s obj.UpdateTime=$p(arg,Delimiter,10)
	s:obj.UpdateTime[":" obj.UpdateTime=$zth(obj.UpdateTime,1)
	s:obj.UpdateTime="" obj.UpdateTime=$p($h,",",2)
	s obj.DutyLocID=$p(arg,Delimiter,11)
	s sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
	}
	if obj'="" d obj.%Close()
	k obj	q id
}

Method ToString(separete As %String) As %String
{
	if $g(separete)=""
	{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..ParentID_separete
	set return=return_..FromDate_separete
	set return=return_..FromTime_separete
	set return=return_..DutyUserID_separete
	set return=return_..IsActive_separete
	set return=return_..UpdateUser_separete
	set return=return_..UpdateDate_separete
	set return=return_..UpdateTime_separete
	set return=return_..DutyLocID_separete
	q return
}

Storage Default
{
<Data name="DutyUserHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DutyUserID</Value>
</Value>
<Value name="3">
<Value>FromDate</Value>
</Value>
<Value name="4">
<Value>FromTime</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>ParentID</Value>
</Value>
<Value name="7">
<Value>ResumeText</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>UpdateTime</Value>
</Value>
<Value name="10">
<Value>UpdateUser</Value>
</Value>
<Value name="11">
<Value>DutyLocID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.IMP.DutyUserD</DataLocation>
<DefaultData>DutyUserHistoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.IMP.DutyUserD</IdLocation>
<IndexLocation>^DHCMed.IMP.DutyUserI</IndexLocation>
<StreamLocation>^DHCMed.IMP.DutyUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
