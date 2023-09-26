Import sqluser

Class web.DHCSTMHUI.DHCSubLocUserGroup Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:查询科室专业组列表
/// Creator:	tsr
/// CreatDate:	2019-03-27
/// Table:		DHC_SubLocUserGroup
/// Others:		d ##class(web.DHCSTMHUI.DHCSubLocUserGroup).LocGroupList()
Query LocGroupList(Params As %String) As Query(ROWSPEC = "RowId,GrpCode,GrpDesc,DateFrom,DateTo,SubLoc") [ SqlProc ]
{
}

ClassMethod LocGroupListExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	q:Params="" $$$OK
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s LocId=PJObj.%Get("Loc")
	q:LocId="" $$$OK

	s SqlStr="select LUG_RowId RowId,LUG_GroupCode GrpCode,LUG_GroupDesc GrpDesc,LUG_DateFrom DateFrom,LUG_DateTo DateTo,"
		_"LUG_CTLOC_DR SubLoc from DHC_SubLocUserGroup"
		_" where LUG_CTLOC_DR="_LocId
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s GrpCode=xrs.Data("GrpCode")
		s GrpDesc=xrs.Data("GrpDesc")
		s DateFrom=xrs.Data("DateFrom")
		s DateTo=xrs.Data("DateTo")
		s SubLoc=xrs.Data("SubLoc")
		s:DateFrom'="" DateFrom=..DL2H(DateFrom)
		s:DateTo'="" DateTo=..DL2H(DateTo)
		d OutPutRow 
	}
	d xrs.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,GrpCode,GrpDesc,DateFrom,DateTo,SubLoc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:保存科室专业组列表
/// Creator:	tsr
/// CreatDate:	2019-03-27
/// Table:		DHC_SubLocUserGroup
/// Others: 	d ##class(web.DHCSTMHUI.DHCSubLocUserGroup).Save()
ClassMethod Save(Main As %String, Detail As %String) As %String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s LocId=PJObj.%Get("Loc")
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	tstart
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s GrpCode=Obj.%Get("GrpCode")
		s GrpDesc=Obj.%Get("GrpDesc")
		s RtnObj=..CheckGroupRepeat(LocId,RowId,GrpCode,GrpDesc)
		q:RtnObj.success'=0
		s DateFrom=Obj.%Get("DateFrom")
		s DateTo=Obj.%Get("DateTo")
		s:DateFrom'="" DateFrom=..DH2L(DateFrom)
		s:DateTo'="" DateTo=..DH2L(DateTo)
		i RowId="" d
		.s obj=##class(User.DHCSubLocUserGroup).%New()
		.d obj.LUGCTLOCDRSetObjectId(LocId)
		e  d
		.i ..sssLock("User.DHCLocUserGroup"_RowId)<0 d RtnObj.Err(-99,"","加锁失败!")
		.q:RtnObj.success'=0
		.s obj=##class(User.DHCSubLocUserGroup).%OpenId(RowId)
		.d obj.%Reload()
		q:RtnObj.success'=0
		s obj.LUGGroupCode=GrpCode
		s obj.LUGGroupDesc=GrpDesc
		s obj.LUGDateFrom=DateFrom
		s obj.LUGDateTo=DateTo
		s sc=obj.%Save()
		i $$$ISERR(sc) s Sc=RtnObj.Err(-3,"","更新专业组信息失败!")
		d ..sssUnLock("User.DHCSubLocUserGroup"_RowId)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tcommit 
	q RtnObj.Json()
}

/// Description:判断专业组人员是否重复
/// Creator:	tsr
/// CreatDate:	2019-08-31
/// Table:		DHC_SubLocUserGroup,DHC_SubLocUser
/// Input:		专业组Id,专业组人员表Id,人员Id
/// Return:		
ClassMethod CheckGroupRepeat(LocId As %String, RowId As %String, GrpCode As %String, GrpDesc As %String) As RtnObj
{
	n (LocId,RowId,GrpCode,GrpDesc)
	s RtnObj=##class(RtnObj).%New()
	s LugId=0
	f  s LugId=$o(^DHCLUG(0,"LOC",LocId,LugId)) q:((LugId="")||(RtnObj.success'=0))  d
	.s pGrpCode=$p(^DHCLUG(LugId),"^",1)
	.s pGrpDesc=$p(^DHCLUG(LugId),"^",2)
	.i (RowId'=LugId)&(GrpCode=pGrpCode) d RtnObj.Err(-11,RowId,"代码:"_GrpCode_"专业组已存在!","",0)
	.q:RtnObj.success'=0
	.i (RowId'=LugId)&(GrpDesc=pGrpDesc) d RtnObj.Err(-12,RowId,"名称:"_GrpDesc_"专业组已存在!","",0)
	.q:RtnObj.success'=0

	q RtnObj
}

/// Description:查询科室专业组人员列表
/// Creator:	tsr
/// CreatDate:	2019-03-27
/// Table:		DHC_SubLocUser
/// Others:		d ##class(web.DHCSTMHUI.DHCSubLocUserGroup).LocGroupList()
Query GroupUserList(Parref As %String) As Query(ROWSPEC = "RowId,User,UserDesc,DateFrom,DateTo,ReqFlag") [ SqlProc ]
{
}

ClassMethod GroupUserListExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	
	s SqlStr="select SLU_RowId RowId,SLU_User_DR UserId,SLU_User_DR->SSUSR_Name UserDesc,SLU_DateFrom DateFrom,SLU_DateTo DateTo,"
		_"SLU_ReqFlag ReqFlag from DHC_SubLocUser"
		_" where SLU_Group_Parref="_Parref
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s User=xrs.Data("UserId")
		s UserDesc=xrs.Data("UserDesc")
		s DateFrom=xrs.Data("DateFrom")
		s DateTo=xrs.Data("DateTo")
		s ReqFlag=xrs.Data("ReqFlag")
		s:DateFrom'="" DateFrom=..DL2H(DateFrom)
		s:DateTo'="" DateTo=..DL2H(DateTo)
		d OutPutDetailRow 
	}
	d xrs.Close()
	Quit $$$OK
OutPutDetailRow
	s Data=$lb(RowId,User,UserDesc,DateFrom,DateTo,ReqFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:保存科室专业组人员信息
/// Creator:	tsr
/// CreatDate:	2019-03-27
/// Table:		DHC_SubLocUser
/// Others: 	w ##class(web.DHCSTMHUI.DHCSubLocUserGroup).SaveDetail("7","[{""UserDesc"":""dthealth"",""User"":""6423"",""DateFrom"":"""",""DateTo"":"""",""ReqFlag"":""N""}]")
ClassMethod SaveDetail(Parref As %String, Detail As %String) As %String
{
	n (Parref,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	i Parref="" d RtnObj.Err(-1,"","请选择专业组信息!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	tstart
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s User=Obj.%Get("User")
		s RtnObj=..CheckUserRepeat(Parref,RowId,User)
		q:RtnObj.success'=0
		s DateFrom=Obj.%Get("DateFrom")
		s DateTo=Obj.%Get("DateTo")
		s ReqFlag=Obj.%Get("ReqFlag")
		s:DateFrom'="" DateFrom=..DH2L(DateFrom)
		s:DateTo'="" DateTo=..DH2L(DateTo)
		i RowId="" d
		.s obj=##class(User.DHCSubLocUser).%New(Parref)
		e  d
		.i ..sssLock("User.DHCSubLocUser"_RowId)<0 d RtnObj.Err(-99,"","加锁失败!")
		.q:RtnObj.success'=0
		.s obj=##class(User.DHCSubLocUser).%OpenId(RowId)
		.d obj.%Reload()
		q:RtnObj.success'=0
		d obj.SLUGroupParrefSetObjectId(Parref)
		d obj.SLUUserDRSetObjectId(User)
		s obj.SLUDateFrom=DateFrom
		s obj.SLUDateTo=DateTo
		s obj.SLUReqFlag=ReqFlag
		s sc=obj.%Save()
		i $$$ISERR(sc) s Sc=RtnObj.Err(-3,"","更新专业组人员信息失败!")
		d ..sssUnLock("User.DHCSubLocUser"_RowId)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tcommit 
	q RtnObj.Json()
}

/// Description:判断专业组人员是否重复
/// Creator:	tsr
/// CreatDate:	2019-08-31
/// Table:		DHC_SubLocUser
/// Input:		专业组Id,专业组人员表Id,人员Id
/// Return:		
ClassMethod CheckUserRepeat(Parref As %String, RowId As %String, User As %String) As RtnObj
{
	n (Parref,RowId,User)
	s RtnObj=##class(RtnObj).%New()
	i Parref="" d RtnObj.Err(-1,"","请选择专业组信息!")
	q:RtnObj.success'=0 RtnObj
	i User="" d RtnObj.Err(-11,"","请选择人员信息")
	q:RtnObj.success'=0 RtnObj
	s Ch=$o(^DHCLUG(0,"USER",User,Parref,0))
	s LUId=Parref_"||"_Ch
	i (Ch'="")&&(LUId'=RowId) d RtnObj.Err(-12,"","该专业组下已存在该人员!") 
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Description:删除科室专业组人员
/// Creator:	tsr
/// CreatDate:	2019-03-27
/// Table:		DHC_SubLocUser
/// Others:		d ##class(web.DHCSTMHUI.DHCSubLocUserGroup).DeleteDetail()
ClassMethod DeleteDetail(Params As %String) As %String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s Obj=PJObj.%Pop()
	s RowId=Obj.%Get("RowId")
	i RowId="" d RtnObj.Err(-2,"","请选择人员信息!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	i ..sssLock("User.DHCLocUserGroup"_RowId)<0 d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	&sql(delete from DHC_SubLocUser where SLU_RowId=:RowId)
	i SQLCODE'=0 d RtnObj.Err(-2,"","删除失败!"_SQLCODE)
	d ..sssUnLock("User.DHCLocUserGroup"_RowId)
	q RtnObj.Json()
}

/// Description:查询用户的专业组列表
/// Creator:	tsr
/// CreatDate:	2019-03-27
/// Table:		DHC_SubLocUser
/// Others:		##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCSubLocUserGroup","GetUserGrp","")
Query GetUserGrp(Params As %String) As Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetUserGrpExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s User=PJObj.%Get("User")
	s SubLoc=PJObj.%Get("SubLoc")
	s ReqFlag=PJObj.%Get("ReqFlag")
	q:User="" $$$OK
	q:SubLoc="" $$$OK

	s SqlStr="SELECT SLU_Group_Parref RowId, SLU_Group_Parref->lug_groupdesc Description"
		_" FROM SQLUser.DHC_SubLocUser"
		_" WHERE SLU_User_DR="_User
		_" AND SLU_Group_Parref->lug_ctloc_dr="_SubLoc
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{	
		s RowId=xrs.Data("RowId")
		s Description=xrs.Data("Description")
		s DateFrom=$p(^DHCLUG(RowId),"^",3)
		s DateTo=$p(^DHCLUG(RowId),"^",4)
		continue:(DateFrom'="")&&(DateFrom>+$h)
		continue:(DateTo'="")&&(DateTo<+$h)
		s SLUch=$o(^DHCLUG(0,"USER",User,RowId,0))
		i SLUch'="" d
		.s UserDf=$p(^DHCLUG(RowId,"I",SLUch),"^",2)
		.s UserDt=$p(^DHCLUG(RowId,"I",SLUch),"^",3)
		.s UserReqFlag=$p(^DHCLUG(RowId,"I",SLUch),"^",4)
		continue:(UserDf'="")&&(UserDf>+$h)
		continue:(UserDt'="")&&(UserDt<+$h)
		continue:(ReqFlag'="")&&(UserReqFlag'="Y")
		d OutPutUserGrpRow 
	}
	d xrs.Close()
	Quit $$$OK
OutPutUserGrpRow
	s Data=$lb(RowId,Description)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:查询科室的专业组列表
/// Creator:	tsr
/// CreatDate:	2019-03-27
/// Table:		DHC_SubLocUserGroup
/// Others:		##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCSubLocUserGroup","GetLocGrp","{""SubLoc"":""326""}")
Query GetLocGrp(Params As %String) As Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetLocGrpExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s SubLoc=PJObj.%Get("SubLoc")
	q:SubLoc="" $$$OK

	s SqlStr="SELECT LUG_RowId, LUG_GroupDesc, LUG_DateFrom, LUG_DateTo"
		_" FROM SQLUser.DHC_SubLocUserGroup"
		_" WHERE LUG_CTLOC_DR="_SubLoc
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{	
		s RowId=xrs.Data("LUG_RowId")
		s Description=xrs.Data("LUG_GroupDesc")
		s DateFrom=xrs.Data("LUG_DateFrom")
		s DateTo=xrs.Data("LUG_DateTo")
		continue:(DateFrom'="")&&(DateFrom>+$h)
		continue:(DateTo'="")&&(DateTo<+$h)
		d OutPutLocGrpRow 
	}
	d xrs.Close()
	Quit $$$OK
OutPutLocGrpRow
	s Data=$lb(RowId,Description)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
