/// Creator: wangxinlei
/// CreatDate: 2010-01-31
/// Description: 手术申请配置
Class web.DHCANOPAppSet Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: wangxinlei
/// CreatDate: 2010-01-31
/// Description: 取手术申请配置
/// Table：^DHCCLSet("AnOp")
/// Input：
/// Return：手术申请配置
ClassMethod GetAppSet() As %String
{
	//手术申请对应医嘱项
	s AppArcimId=$g(^DHCCLSet("AnOp","AppArcimId"))
	i AppArcimId'="" s AppArcim=$p($g(^ARCIM($p(AppArcimId,"||",1),$p(AppArcimId,"||",2),1)),"^",2)
	e  s AppArcim=""
	//手术申请时间限制
	s AppTime=$p($g(^DHCCLSet("AnOp","Time")),"^",1)
	//手术申请对应医嘱项备注
	s arcimNote=$g(^DHCCLSet("AnOp","Note"))
	//备注代码对应名称
	s NoteVar=$g(^DHCCLSet("AnOp","NoteVar"))	
	//是否插入默认手术间
	s InsertDefRoom=$g(^DHCCLSet("AnOp","InsertDefRoom"))
	//是否发送消息
	s SendMessage=$g(^DHCCLSet("AnOp","SendMessage"))
	//是否自动带入检验结果
	s InsertLabInfo=$g(^DHCCLSet("AnOp","InsertLabInfo"))
	//手术室麻醉科收费是否合并
	s ChargeTogether=$g(^DHCCLSet("AnOp","ChargeTogether"))
	//住院申请默认手术室
	s IPDefOpLocId=$g(^DHCCLSet("AnOp","IPDefOpLoc"))
	i IPDefOpLocId'="" s IPDefOpLoc=$p(^CTLOC(IPDefOpLocId),"^",2)
	e  s IPDefOpLoc=""
	//门诊申请默认手术室
	s OPDefOpLocId=$g(^DHCCLSet("AnOp","OPDefOpLoc"))
	i OPDefOpLocId'="" s OPDefOpLoc=$p(^CTLOC(OPDefOpLocId),"^",2)	
	e  s OPDefOpLoc=""	
	//病人调度安全组  20170811 YuanLin
	s PatScheduleId=$g(^DHCCLSet("AnOp","PatSchedule"))
	i PatScheduleId'="" s PatSchedule=$p($g(^SSU("SSGRP",PatScheduleId)),"^",1)
	e  s PatSchedule=""
	//护工安全组      20170811 YuanLin
	s NursingWorkerId=$g(^DHCCLSet("AnOp","NursingWorker"))
	i NursingWorkerId'="" s NursingWorker=$p($g(^SSU("SSGRP",NursingWorkerId)),"^",1)
	e  s NursingWorker=""
	//科主任审核安全组ID
	s DirAuditStr=""
	s DirAuditIdList=$g(^DHCCLSet("AnOp","DirAudit"))
	s DirAuditNum=$l(DirAuditIdList,"^")
 	f I=1:1:DirAuditNum d
 	.s DirAuditId=$p($g(DirAuditIdList),"^",I)
 	.i DirAuditId'="" s DirAudit=$p($g(^SSU("SSGRP",DirAuditId)),"^",1)
 	.e  s DirAudit=""
 	.i DirAuditStr="" s DirAuditStr=DirAudit_"!"_DirAuditId
 	.e  s DirAuditStr=DirAuditStr_"^"_DirAudit_"!"_DirAuditId 
 	 	//麻醉主任审核安全组ID
	s ANDirAuditStr=""
	s ANDirAuditIdList=$g(^DHCCLSet("AnOp","ANDirAudit"))
	s ANDirAuditNum=$l(ANDirAuditIdList,"^")
 	f I=1:1:ANDirAuditNum d
 	.s ANDirAuditId=$p($g(ANDirAuditIdList),"^",I)
 	.i ANDirAuditId'="" s ANDirAudit=$p($g(^SSU("SSGRP",ANDirAuditId)),"^",1)
 	.e  s ANDirAudit=""
 	.i ANDirAuditStr="" s ANDirAuditStr=ANDirAudit_"!"_ANDirAuditId
 	.e  s ANDirAuditStr=ANDirAuditStr_"^"_ANDirAudit_"!"_ANDirAuditId
 	s dayOperNeedAn=""
 	s dayOperNeedAn=$g(^DHCCLSet("AnOp","DayOperNeedAN"))
 	
 	//拟施手术实施手术是否一致
	s OneOperName=$g(^DHCCLSet("AnOp","OneOperName"))
	
 	s ret=AppArcim_"^"_AppArcimId_"@"_AppTime_"@"_arcimNote_"@"_NoteVar_"@"_InsertDefRoom_"@"
 	_SendMessage_"@"_InsertLabInfo_"@"_IPDefOpLocId_"^"_IPDefOpLoc_"@"_OPDefOpLocId_"^"_OPDefOpLoc_"@"_DirAuditStr_"@"
 	_ANDirAuditStr_"@"_ChargeTogether_"@"_PatScheduleId_"^"_PatSchedule_"@"_NursingWorkerId_"^"_NursingWorker_"@"_dayOperNeedAn_"@"_OneOperName
	q ret
}

/// Creator: wangxinlei
/// CreatDate: 2010-01-31
/// Description: 保存手术申请配置
/// Table：^DHCCLSet("AnOp")
/// Input：
/// Return：成功返回0,失败返回非0
ClassMethod SaveAppSet(SetStr As %String)
{
	//手术申请对应医嘱项
	s ^DHCCLSet("AnOp","AppArcimId")=$p(SetStr,"@",1)
	//手术申请时间限制
	s ^DHCCLSet("AnOp","Time")=$p(SetStr,"@",2)_"^"_"Y"
	//手术申请对应医嘱项备注
	s ^DHCCLSet("AnOp","Note")=$p(SetStr,"@",3)
	//备注代码对应名称
	s ^DHCCLSet("AnOp","NoteVar")=$p(SetStr,"@",4)	
	//是否插入默认手术间
	s ^DHCCLSet("AnOp","InsertDefRoom")=$p(SetStr,"@",5)
	//是否发送消息
	s ^DHCCLSet("AnOp","SendMessage")=$p(SetStr,"@",6)
	//是否自动带入检验结果
	s ^DHCCLSet("AnOp","InsertLabInfo")=$p(SetStr,"@",7)
	//住院申请默认手术室
	s ^DHCCLSet("AnOp","IPDefOpLoc")=$p(SetStr,"@",8)
	//门诊申请默认手术室
	s ^DHCCLSet("AnOp","OPDefOpLoc")=$p(SetStr,"@",9)
	//科主任审核安全组ID
	s ^DHCCLSet("AnOp","DirAudit")=$p(SetStr,"@",10)
	//麻醉科主任审核安全组ID
	s ^DHCCLSet("AnOp","ANDirAudit")=$p(SetStr,"@",11)
	//收费合并
	s ^DHCCLSet("AnOp","ChargeTogether")=$p(SetStr,"@",12)
	//病人调度安全组ID   20170811 YuanLin
	s ^DHCCLSet("AnOp","PatSchedule")=$p(SetStr,"@",13)
	//护工安全组ID       20170811 YuanLin
	s ^DHCCLSet("AnOp","NursingWorker")=$p(SetStr,"@",14)
	//日间是否需要麻醉评估
	s ^DHCCLSet("AnOp","DayOperNeedAN")=$p(SetStr,"@",15)
	//拟施手术和实施手术是否一致
	s ^DHCCLSet("AnOp","OneOperName")=$p(SetStr,"@",16)
	q 0
}

/// Creator: wangxinlei
/// CreatDate: 2010-01-31
/// Description: 取医护人员类型
/// Table：CT_CareProv,CT_CarPrvTp
/// Input：
/// Return：CTCPTRowId:医护人员类型ID,CTCPTDesc:医护人员类型描述
Query FindCarPrvTp() As %Query(ROWSPEC = "CTCPTRowId,CTCPTDesc")
{
}

ClassMethod FindCarPrvTpExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
 	
 	s CTCPTRowId=0
 	f  s CTCPTRowId=$o(^CT("CPT",CTCPTRowId)) q:CTCPTRowId=""  d
 	.s InternalType=$p(^CT("CPT",CTCPTRowId),"^",4)
 	.q:InternalType'="DOCTOR"
 	.s CTCPTDesc=$p(^CT("CPT",CTCPTRowId),"^",2)
 	.d OutRow1

    s qHandle=$lb(0,repid,0)
    q $$$OK
OutRow1
	s Data=$lb(CTCPTRowId,CTCPTDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q

 //code,name,filename,byadm,prnframe
}

ClassMethod FindCarPrvTpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCarPrvTpExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCarPrvTpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCarPrvTpExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2010-01-31
/// Description: 取手术分类
/// Table：ORC_OperationCategory
/// Input：
/// Return：CATEGRowId:手术分类ID,CATEGDesc:手术分类描述
Query FindOpCategory() As %Query(ROWSPEC = "CATEGRowId,CATEGDesc")
{
}

ClassMethod FindOpCategoryExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
 	
 	s CATEGRowId=0
 	f  s CATEGRowId=$o(^ORC("CATEG",CATEGRowId)) q:CATEGRowId=""  d
 	.s CATEGDesc=$p(^ORC("CATEG",CATEGRowId),"^",2)
 	.d OutRow2
    s qHandle=$lb(0,repid,0)
    q $$$OK
OutRow2
	s Data=$lb(CATEGRowId,CATEGDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q

 //code,name,filename,byadm,prnframe
}

ClassMethod FindOpCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOpCategoryExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindOpCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOpCategoryExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2010-01-31
/// Description: 取主刀医师类型与手术分类关联值
/// Table：^DHCCLSet("AnOp")
/// Input：
/// Return：成功返回主刀医师关联的手术分类,失败返回空
ClassMethod GetPrvTpOpCat(CTCPTId As %String)
{
	q:CTCPTId="" ""
	q $g(^DHCCLSet("AnOp","PrvTp",CTCPTId,"OpCat"))
}

/// Creator: wangxinlei
/// CreatDate: 2010-01-31
/// Description: 保存主刀医师类型与手术分类关联值
/// Table：^DHCCLSet("AnOp")
/// Input：
/// Return：成功返回主刀医师关联的手术分类,失败返回空
ClassMethod SavePrvTpOpCat(CTCPTId As %String, CATEGRId As %String)
{
	q:CTCPTId="" -1
	s ^DHCCLSet("AnOp","PrvTp",CTCPTId,"OpCat")=CATEGRId
	q 0
}

/// Creator: wangxinlei
/// CreatDate: 2010-01-31
/// Description: 保存某类型的医生才能为主刀医师
/// Table：^DHCCLSet("AnOp")
/// Input：
/// Return：成功返回0,失败返回非0
ClassMethod SaveOpDocType(CTCPTIdStr As %String)
{
	s ^DHCCLSet("AnOp","OpDocTp")=CTCPTIdStr
	q 0
}

/// Creator: wangxinlei
/// CreatDate: 2010-01-31
/// Description: 取定义的能为主刀医师的医护人员类型
/// Table：^DHCCLSet("AnOp")
/// Input：
/// Return：OpDocTypeId:医护人类型ID,OpDocType:医护人员类型
Query FindOpDocType() As %Query(ROWSPEC = "OpDocTypeId,OpDocType")
{
}

ClassMethod FindOpDocTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
 	s OpDocTypeNum=$l($g(^DHCCLSet("AnOp","OpDocTp")),"^")
 	f I=1:1:OpDocTypeNum d
 	.s OpDocTypeId=$p($g(^DHCCLSet("AnOp","OpDocTp")),"^",I)
 	.i OpDocTypeId'="" s OpDocType=$p(^CT("CPT",OpDocTypeId),"^",2)
 	.e  s OpDocType=""
 	.d OutRow3
    s qHandle=$lb(0,repid,0)
    q $$$OK
OutRow3
	s Data=$lb(OpDocTypeId,OpDocType)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q

 //code,name,filename,byadm,prnframe
}

ClassMethod FindOpDocTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOpDocTypeExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindOpDocTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOpDocTypeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCANOPAppSet","FindMasterItem","SSSQ")

Query FindMasterItem(ARCIMDesc As %String = "") As %Query(ROWSPEC = "ArcimDesc:%String,ArcimDR:%String")
{
}

ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, ARCIMDesc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i ARCIMDesc="" s qHandle=$lb(0,repid,0) Q $$$OK
 	i (ARCIMDesc'="") s ARCIMDesc=$$ALPHAUP^SSUTIL4(ARCIMDesc)
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
		.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
			..s ArcimDR=ArcimID_"||"_ArcimSubID
			..s AlisDR="" f  s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,AlisDR)) q:AlisDR=""  d
				...q:AlisDR=""
				...s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
				...s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
				...s ArcimDesc2=AlisDesc_"-"_ArcimDesc
				...q:ArcimDesc2'[ARCIMDesc
				...//q:$p(ArcimDesc,ARCIMDesc,1)'=""
				...Do OutputRowArcim
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowArcim
	set Data=$lb(ArcimDesc,ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
