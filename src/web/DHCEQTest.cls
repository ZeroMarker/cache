Import SQLUser

Class web.DHCEQTest Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetLimitYearsChange() As %Query(ROWSPEC = "EQNO:%String,EQName:%String,EQEquipCatCode:%String,EQEquipCat:%String,EQOriginalFee:%String,EQNetFee:%String,EQDepreTotal:%String,EQOldYear:%String,EQNewYear:%String") [ SqlProc ]
{
}

ClassMethod GetLimitYearsChangeExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQUpdate("LimitYears",EQRowID))  q:EQRowID=""  d
	.s EQNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	.s EQName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	.s EQEquipCatDR=$p($g(^DHCEQUpdate("LimitYears",EQRowID)),"^",1)
	.s EQEquipCatCode=$p($g(^DHCEQUpdate("LimitYears",EQRowID)),"^",2)
	.s EQEquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",EQEquipCatDR)
	.s (EQOriginalFee,EQDepreTotal,EQNetFee)=""
	.i $D(^DHCEQSnapShot(85,"Equip",EQRowID))  d
	..s EQOriginalFee=$p($g(^DHCEQSnapShot(85,"Equip",EQRowID)),"^",27)
	..s EQNetFee=$p($g(^DHCEQSnapShot(85,"Equip",EQRowID)),"^",27)
	..s EQDepreTotal=$p($g(^DHCEQSnapShot(85,"Equip",EQRowID)),"^",35)
	.s EQOldYear=$p($g(^DHCEQUpdate("LimitYears",EQRowID)),"^",3)
	.s EQNewYear=$p($g(^DHCEQUpdate("LimitYears",EQRowID)),"^",4)
	.d OutputRowGetLimitYearsChange
	Quit $$$OK
OutputRowGetLimitYearsChange
	s Data=$lb(EQNO,EQName,EQEquipCatCode,EQEquipCat,EQOriginalFee,EQNetFee,EQDepreTotal,EQOldYear,EQNewYear)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetLimitYearsChangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLimitYearsChangeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLimitYearsChangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLimitYearsChangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/***************************************************************************/
/// w ##Class(web.DHCEQTest).ABCDE()
ClassMethod ABCDE()
{
	s NewStatusCount=0
	s NMRRowID=""
	f  s NMRRowID=$o(^DHCEQMMaintRequest(0,"Source",1,14,NMRRowID),-1)  q:NMRRowID=""  d
	.q:NMRRowID=33
	.s NMRInvalidFlag=$p($g(^DHCEQMMaintRequest(NMRRowID)),"^",57)
	.q:NMRInvalidFlag="Y"
	.s NMRStatus=$p($g(^DHCEQMMaintRequest(NMRRowID)),"^",41)
	.q:NMRStatus=2
	.w NMRRowID,!
}

/// Add By DJ 2019-03-25
/// 根据当前单据获取一下待审单据RowID
/// w ##Class(web.DHCEQTest).GetNextAuditID(7,"",7,7,"")
ClassMethod GetNextAuditID(ApproveType As %String = "", MBussType As %String = "", curRowID As %String = "", ApproveRole As %String = "", Action As %String = "")
{
	i (ApproveType="")||(curRowID="") q ""
	s CurUserDR=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s FindSourceID=""
	s ApproveTypeDR=##class(web.DHCEQApproveList).GetApproveType(ApproveType)
	s AISourceID=curRowID
	f  s AISourceID=$o(^DHCEQApproveInfo(0,"StatusType",1,ApproveTypeDR,AISourceID))  q:(AISourceID="")||(FindSourceID'="")  d
	.s AIRowID=0
	.f  s AIRowID=$o(^DHCEQApproveInfo(0,"StatusType",1,ApproveTypeDR,AISourceID,AIRowID))  q:(AIRowID="")||(FindSourceID'="")  d
	..s AIEquipTypeDR=$p($g(^DHCEQApproveInfo(AIRowID)),"^",10)
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(AIEquipTypeDR)
	..s AINextRole=$p($g(^DHCEQApproveInfo(AIRowID)),"^",4)
	..q:(Action="")&&(ApproveRole'=AINextRole)
	..i Action="" s FindSourceID=AISourceID
	..q:(Action="")&&(FindSourceID'="")
	..q:(Action'="")&&(MBussType="")
	..//动作存在检查消息
	..i Action'=""  d
	...s MSRowID=0
	...f  s MSRowID=$o(^DHCEQMessages(0,"MessageType",1,MBussType,AISourceID,MSRowID))  q:(MSRowID="")||(FindSourceID'="")  d
	....s MRIRowID=0
	....f  s MRIRowID=$o(^DHCEQMessagesRecInfo(0,"Message",MSRowID,MRIRowID))  q:(MRIRowID="")||(FindSourceID'="")  d
	.....s MRIUserDR=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",2)
	.....q:MRIUserDR'=CurUserDR
	.....s MRIAction=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",10)
	.....q:(","_MRIAction_",")'[(","_Action_",")
	.....s FindSourceID=AISourceID
	q FindSourceID
}

/// 更新组内用户表信息
/// w ##Class(web.DHCEQTest).UpdateUser()
ClassMethod UpdateUser()
{
	TSTART
	s SQLCODE=0
	s URowID=0
	f  s URowID=$o(^DHCEQCCode("DHCEQCUser",URowID))  q:(URowID="")||(SQLCODE'=0)  d
	.s UDeptDR=$p($g(^DHCEQCCode("DHCEQCUser",URowID)),"^",14)
	.q:UDeptDR=""
	.s NewDeptDR=$o(^DHCEQCCode("DHCEQCDepartment",0,"ExID","Y",1,UDeptDR,0))
	.q:NewDeptDR=""
	.&SQL(Update SQLUSER.DHC_EQCUser Set U_DefaultLocDR=:NewDeptDR Where U_RowID=:URowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q "cg"
}

/// w ##Class(web.DHCEQTest).UpdateMenu()
ClassMethod UpdateMenu()
{
	TSTART
	s SQLCODE=0
	s CurMenuID=0
	f  s CurMenuID=$o(^websys.MenuD(CurMenuID))  q:(CurMenuID="")||(SQLCODE'=0)  d
	.s TMenuName=$lg($g(^websys.MenuD(CurMenuID)),4)
	.q:$E(TMenuName,1,5)'="DHCEQ"
	.s TMenuCaption=$lg($g(^websys.MenuD(CurMenuID)),1)
	.s ValueExpresion=$lg($g(^websys.MenuD(CurMenuID)),10)
	.s LocID="%session.Get("_$C(34)_"LOGON.CTLOCID"_$C(34)_")"
	.s LocDesc="%session.Get("_$C(34)_"LOGON.CTLOCDESC"_$C(34)_")"
	.s UserID="%session.Get("_$C(34)_"LOGON.USERID"_$C(34)_")"
	.s UserName="%session.Get("_$C(34)_"LOGON.USERNAME"_$C(34)_")"
	.s NewLocID="##Class(web.DHCEQCommon).getMapIDBySource("_$C(34)_"dept"_$C(34)_",%session.Get("_$C(34)_"LOGON.CTLOCID"_$C(34)_"))"
	.s NewLocDesc="##Class(web.DHCEQCommon).getMapIDBySource("_$C(34)_"deptname"_$C(34)_",%session.Get("_$C(34)_"LOGON.CTLOCDESC"_$C(34)_"))"
	.s NewUserID="##Class(web.DHCEQCommon).getMapIDBySource("_$C(34)_"user"_$C(34)_",%session.Get("_$C(34)_"LOGON.USERID"_$C(34)_"))"
	.s NewUserName="##Class(web.DHCEQCommon).getMapIDBySource("_$C(34)_"username"_$C(34)_",%session.Get("_$C(34)_"LOGON.USERNAME"_$C(34)_"))"
	.s NewExpresion=ValueExpresion
	.s NewExpresion=##Class(web.DHCEQCommon).Replace(NewExpresion,LocID,NewLocID)
	.s NewExpresion=##Class(web.DHCEQCommon).Replace(NewExpresion,LocDesc,NewLocDesc)
	.s NewExpresion=##Class(web.DHCEQCommon).Replace(NewExpresion,UserID,NewUserID)
	.s NewExpresion=##Class(web.DHCEQCommon).Replace(NewExpresion,UserName,NewUserName)
	.&SQL(Update websys.menu Set ValueExpression=:NewExpresion Where ID=:CurMenuID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q "cg"
}

// 

// ClassMethod UpdBCaptionAndImage()

// {

// 	d ..UpdBCaptionAndImage1()

// 	d ..UpdBCaptionAndImage2()

// 	d ..UpdBCaptionAndImage3()

// 	d ..UpdBCaptionAndImage4()

// 	d ..UpdBCaptionAndImage5()

// 	d ..UpdBCaptionAndImage6()

// 	d ..UpdBCaptionAndImage7()

// 	d ..UpdBCaptionAndImage8()

// 	d ..UpdBCaptionAndImage9()

// 	d ..UpdBCaptionAndImage10()

// }

// 

// ClassMethod UpdBCaptionAndImage1()

// {

// 	//全部图标更新为详细图标

// 	&SQL(Update websys.Componenttableitems set image='uiimages/yellow_paper.png' where parref->name like 'DHCEQ%' and DisplayType='B')

// 	&SQL(Update websys.Componentitems set image='uiimages/yellow_paper.png' where parref->name like 'DHCEQ%' and DisplayType='B')

// 	//列表图标

// 	&SQL(Update websys.Componenttableitems set image='uiimages/edit_remove.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BDeleteList' and caption='删除')

// 	&SQL(Update websys.Componenttableitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='TBPrintBar' and caption='打印标签')

// 	&SQL(Update websys.Componenttableitems set image='uiimages/evaluate.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BEvaluate' and caption='评价')

// }

// 

// ClassMethod UpdBCaptionAndImage2()

// {

// 	&SQL(Update websys.Componentitems set image='uiimages/filesave.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BUpdate' and caption='更新')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrint1' and caption='论证报告打印')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrint2' and caption='可行性分析报告打印')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrint3' and caption='科室讨论记录打印')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrint1' and caption='效益分析打印')

// 	&SQL(Update websys.Componentitems set image='uiimages/locsubmit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSubmit' and caption='提交')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_remove.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BDelete' and caption='删除')

// 	&SQL(Update websys.Componentitems set image='uiimages/no.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BCancelSubmit' and caption='作废')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrint' and caption='打印')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAudit' and caption='审核')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAdd' and caption='增加')

// 	&SQL(Update websys.Componentitems set image='uiimages/search.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BFind' and caption='查找')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAdd' and caption='新增')

// 	&SQL(Update websys.Componentitems set image='uiimages/redo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSave' and caption='导出')

// 	&SQL(Update websys.Componentitems set image='uiimages/enablepaper.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BExecute' and caption='执行')

// 	&SQL(Update websys.Componentitems set image='uiimages/no.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BInvalid' and caption='作废')

// 	&SQL(Update websys.Componentitems set image='uiimages/importdata.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BImport' and caption='导入调整数据')

// 	&SQL(Update websys.Componentitems set image='uiimages/search.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BFind' and caption='查询')

// 	&SQL(Update websys.Componentitems set image='uiimages/cancel.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BClose' and caption='关闭')

// 	&SQL(Update websys.Componentitems set image='uiimages/disuse.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BDisuse' and caption='附件报废')

// 	&SQL(Update websys.Componentitems set image='uiimages/redo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSaveExcel' and caption='导出')

// 	&SQL(Update websys.Componentitems set image='uiimages/filesave.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BUpdate' and caption='保存')

// 	&SQL(Update websys.Componentitems set image='uiimages/clearscreen.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BClear' and caption='清空')

// }

// 

// ClassMethod UpdBCaptionAndImage3()

// {

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAdd' and caption='添加')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove1' and caption='审核1')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove2' and caption='审核2')

// 	&SQL(Update websys.Componentitems set image='uiimages/undo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BCancelSubmit' and caption='取消提交')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSave' and caption='打印')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove1' and caption='审批1')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove5' and caption='审批5')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove2' and caption='审批2')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove3' and caption='审批3')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove4' and caption='审批4')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_remove.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BDeleteList' and caption='删除')

// 	&SQL(Update websys.Componentitems set image='uiimages/redo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrint' and caption='导出')

// 	&SQL(Update websys.Componentitems set image='uiimages/uploadyun.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BUpload' and caption='上传电子资料')

// 	&SQL(Update websys.Componentitems set image='uiimages/filesave.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAdd' and caption='更新')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAddSimple' and caption='新增(多批)')

// 	&SQL(Update websys.Componentitems set image='uiimages/redo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BExport' and caption='导出')

// 	&SQL(Update websys.Componentitems set image='uiimages/arcossets.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAffix' and caption='附属设备')

// 	&SQL(Update websys.Componentitems set image='uiimages/printapplycard.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPicture' and caption='图片信息')

// 	&SQL(Update websys.Componentitems set image='uiimages/copy.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BCopy' and caption='复制')

// 	&SQL(Update websys.Componentitems set image='uiimages/importdata.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BImport' and caption='导入验收单')

// 	&SQL(Update websys.Componentitems set image='uiimages/printapplycard.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPicture' and caption='图片资料')

// 	&SQL(Update websys.Componentitems set image='uiimages/config.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BConfig' and caption='设备配置')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintBar' and caption='打印条码')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintCard' and caption='打印卡片正面')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintCardVerso' and caption='打印卡片反面')

// }

// 

// ClassMethod UpdBCaptionAndImage4()

// {

// 	&SQL(Update websys.Componentitems set image='uiimages/config.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BDepreAllot' and caption='分摊设置')

// 	&SQL(Update websys.Componentitems set image='uiimages/redo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BExportToJQ' and caption='导出到久其')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSubmit' and caption='提交审核')

// 	&SQL(Update websys.Componentitems set image='uiimages/enablepaper.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BExecute' and caption='执行计划')

// 	&SQL(Update websys.Componentitems set image='uiimages/enablepaper.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPartExec' and caption='部分执行')

// 	&SQL(Update websys.Componentitems set image='uiimages/enablepaper.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAllExec' and caption='全部执行')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAudit' and caption='审批')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAddNew' and caption='新增(NEW)')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove6' and caption='审批6')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BBuyPlanItem' and caption='添加明细')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAdd' and caption='添加选中记录到年度分配计划')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAddNN' and caption='新增(批量)')

// 	&SQL(Update websys.Componentitems set image='uiimages/bluepaper.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BArgu' and caption='论证')

// 	&SQL(Update websys.Componentitems set image='uiimages/bluepaper.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BArgumentation' and caption='论证')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BUpdate' and caption='确认')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BOK' and caption='确认')

// 	&SQL(Update websys.Componentitems set image='uiimages/filesave.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSave' and caption='保存')

// 	&SQL(Update websys.Componentitems set image='uiimages/filesave.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BUpdate' and caption='修改')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_remove.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BDel' and caption='删除')

// 	&SQL(Update websys.Componentitems set image='uiimages/filesave.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSave' and caption='保存列设置')

// 	&SQL(Update websys.Componentitems set image='uiimages/movedown.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='Down' and caption='向下')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_remove.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='Left' and caption='删除')

// 	&SQL(Update websys.Componentitems set image='uiimages/moveup.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='Up' and caption='向上')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='Right' and caption='添加')

// 	&SQL(Update websys.Componentitems set image='uiimages/redo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSaveExcel' and caption='导出数据')

// }

// 

// ClassMethod UpdBCaptionAndImage5()

// {

// 	&SQL(Update websys.Componentitems set image='uiimages/arcossets.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAffix' and caption='附件')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAffixISPrint' and caption='附件入库单打印')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAffixSMPrint' and caption='附件出库单打印')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintCA' and caption='打印调账单')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BCheck' and caption='审阅')

// 	&SQL(Update websys.Componentitems set image='uiimages/importdata.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BImportExecel' and caption='导入合同')

// 	&SQL(Update websys.Componentitems set image='uiimages/arcossets.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAffix' and caption='设备附件')

// 	&SQL(Update websys.Componentitems set image='uiimages/importdata.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BImportAffixConfig' and caption='导入附件配置')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove3' and caption='审核3')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove4' and caption='审核4')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove5' and caption='审核5')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAdd1' and caption='新增')

// 	&SQL(Update websys.Componentitems set image='uiimages/search.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='Find' and caption='查找')

// 	&SQL(Update websys.Componentitems set image='uiimages/filesave.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrint' and caption='保存')

// 	&SQL(Update websys.Componentitems set image='uiimages/filesave.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSave' and caption='保存报表')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove1' and caption='出车确认')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove2' and caption='主管审核')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintBarSml' and caption='打印条码')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintAffix' and caption='打印附件')

// 	&SQL(Update websys.Componentitems set image='uiimages/filesave.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BBatchUpdate' and caption='全部更新')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintBar' and caption='批量打印条码')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintCard' and caption='批量打印卡片')

// 	&SQL(Update websys.Componentitems set image='uiimages/filesave.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSave' and caption='确定')

// 	&SQL(Update websys.Componentitems set image='uiimages/filter.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BFilter' and caption='过滤')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAddAllEquip' and caption='添加全部设备')

// }

// 

// ClassMethod UpdBCaptionAndImage6()

// {

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAddAllItem' and caption='添加全部设备项')

// 	&SQL(Update websys.Componentitems set image='uiimages/filesave.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BEvaluate' and caption='评价保存')

// 	&SQL(Update websys.Componentitems set image='uiimages/redo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BExportDym' and caption='动态管理导出')

// 	&SQL(Update websys.Componentitems set image='uiimages/reload.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BCreate' and caption='生成数据')

// 	&SQL(Update websys.Componentitems set image='uiimages/no.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BDelete' and caption='作废')

// 	&SQL(Update websys.Componentitems set image='uiimages/reload.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPDFCreate' and caption='生成PDF')

// 	&SQL(Update websys.Componentitems set image='uiimages/search.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BFind' and caption='单据内查询')

// 	&SQL(Update websys.Componentitems set image='uiimages/undo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BCancel' and caption='取消')

// 	&SQL(Update websys.Componentitems set image='uiimages/ok.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BOK' and caption='确定')

// 	&SQL(Update websys.Componentitems set image='uiimages/undo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BCancel' and caption='返回')

// 	&SQL(Update websys.Componentitems set image='uiimages/locsubmit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSubmit' and caption='提交2')

// 	&SQL(Update websys.Componentitems set image='uiimages/locsubmit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAudit' and caption='提交')

// 	&SQL(Update websys.Componentitems set image='uiimages/enablepaper.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BUpdate' and caption='执行')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAudit' and caption='采购确认')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BBillAudit' and caption='账物审核')

// 	&SQL(Update websys.Componentitems set image='uiimages/reload.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BToMove' and caption='生成出库单')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove2' and caption='账务审核')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove1' and caption='采购确认')

// 	&SQL(Update websys.Componentitems set image='uiimages/no.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BCancel' and caption='作废')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSubmit' and caption='确认')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrint' and caption='打印盘点单')

// 	&SQL(Update websys.Componentitems set image='uiimages/config.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BFilterInfo' and caption='盘点过滤条件设置')

// 	&SQL(Update websys.Componentitems set image='uiimages/ok.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAudit' and caption='盘点完成')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='PrintBarCode' and caption='条码打印')

// 	&SQL(Update websys.Componentitems set image='uiimages/filesave.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSave' and caption='保存盘点结果')

// }

// 

// ClassMethod UpdBCaptionAndImage7()

// {

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BBarCodePrint' and caption='条码打印')

// 	&SQL(Update websys.Componentitems set image='uiimages/printapplycard.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPicture' and caption='附加图片')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPMReport' and caption='PM报告打印')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAddNew' and caption='新增')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintBar' and caption='打印当前设备条码')

// 	&SQL(Update websys.Componentitems set image='uiimages/reply.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BReturn' and caption='回复')

// 	&SQL(Update websys.Componentitems set image='uiimages/senddetails.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSend' and caption='发送')

// 	&SQL(Update websys.Componentitems set image='uiimages/senddetails.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSendMessage' and caption='发送消息')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BConfirm' and caption='科室确认配件')

// 	&SQL(Update websys.Componentitems set image='uiimages/undo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BCancelConfirm' and caption='取消配件确认')

// 	&SQL(Update websys.Componentitems set image='uiimages/undo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BCancelManage' and caption='取消配件管理')

// 	&SQL(Update websys.Componentitems set image='uiimages/evaluate.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BEvaluate' and caption='评价')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove6' and caption='审核6')

// 	&SQL(Update websys.Componentitems set image='uiimages/all_selected.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='Select' and caption='全选')

// 	&SQL(Update websys.Componentitems set image='uiimages/cancel_all_selected.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='Selectf' and caption='反选')

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BNew' and caption='新增')

// 	&SQL(Update websys.Componentitems set image='uiimages/printapplycard.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPictureInfo' and caption='图片信息')

// 	&SQL(Update websys.Componentitems set image='uiimages/importdata.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BImport' and caption='导入批量验收设备')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BBillAudit' and caption='账物确认')

// 	&SQL(Update websys.Componentitems set image='uiimages/undo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BCancelSubmit' and caption='反提交')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAudit' and caption='减库确认')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrint' and caption='打印付款单')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintTotal' and caption='打印汇总单')

// 	&SQL(Update websys.Componentitems set image='uiimages/more.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BMore' and caption='更多...')

// 	&SQL(Update websys.Componentitems set image='uiimages/all_selected.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BSelectAll' and caption='全选(当前页)')

// }

// 

// ClassMethod UpdBCaptionAndImage8()

// {

// 	&SQL(Update websys.Componentitems set image='uiimages/reload.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPayRequest' and caption='生成付款总单')

// 	&SQL(Update websys.Componentitems set image='uiimages/uploadyun.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BUpload' and caption='上传图片')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintCard' and caption='打印卡片')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintCardVerso' and caption='打印背面')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintUser' and caption='打印用户')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintOne' and caption='一维码打印')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrintTwo' and caption='二维码打印')

// 	&SQL(Update websys.Componentitems set image='uiimages/billback.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BReturn' and caption='归还')

// 	&SQL(Update websys.Componentitems set image='uiimages/undo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BCancelSubmit' and caption='取消申请')

// 	&SQL(Update websys.Componentitems set image='uiimages/billgo.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BRent' and caption='借出')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BAudit' and caption='退库确认')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BInAudit' and caption='入库审核')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BOutAudit' and caption='出库审核')

// 	&SQL(Update websys.Componentitems set image='uiimages/print.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrint' and caption='打印转移单')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BBAudit' and caption='管理审核')

// 	&SQL(Update websys.Componentitems set image='uiimages/ok.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BUpdate' and caption='确定')

// 	&SQL(Update websys.Componentitems set image='uiimages/moveup.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BPrev' and caption='上一个')

// 	&SQL(Update websys.Componentitems set image='uiimages/movedown.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BNext' and caption='下一个')

// 	&SQL(Update websys.Componentitems set image='uiimages/unloadyun.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BDownLoad' and caption='下载')

// 	&SQL(Update websys.Componentitems set image='uiimages/audit.png' where parref->name like 'DHCEQ%' and DisplayType='B' and name='BApprove1' and caption='审批')

// }

// 

// ClassMethod UpdBCaptionAndImage9()

// {

// 	//Caption更新

// 	&SQL(Update websys.Componentitems set caption='查询' where parref->name like 'DHCEQ%' and DisplayType='B' and Caption='查找')

// 	&SQL(Update websys.Componentitems set caption='清屏' where parref->name like 'DHCEQ%' and DisplayType='B' and Caption='清空')

// 	&SQL(Update websys.Componentitems set caption='增加' where parref->name like 'DHCEQ%' and DisplayType='B' and Name='BAdd')

// 	&SQL(Update websys.Componentitems set caption='保存' where parref->name like 'DHCEQ%' and DisplayType='B' and Caption='更新')

// 	&SQL(Update websys.Componentitems set caption='新增' where parref->name like 'DHCEQ%' and parref->name like '%Find' and DisplayType='B' and (Name='BAdd' or Name='BAdd1' or Name='BAddNew' or Name='BAddNN'))

// }

// 

// ClassMethod UpdBCaptionAndImage10()

// {

// 	&SQL(Update websys.Componenttableitems set image='uiimages/yellow_paper.png' where parref->name like 'DHCEQ%' and DisplayType='A' AND (Image LIKE 'WEB%' OR Image IS NULL))

// 	&SQL(Update websys.Componentitems set image='uiimages/edit_add.png' where parref->name like 'DHCEQ%' and DisplayType='A' and (name='BAdd' or name='BAdd1' or name='BNew' or name='BAddNew'))

// 	&SQL(Update websys.Componentitems set image='uiimages/config.png' where parref->name like 'DHCEQ%' and DisplayType='A' and name='BColSet')

// 	&SQL(Update websys.Componentitems set caption='导出列设置' where parref->name like 'DHCEQ%' and DisplayType='A' and Caption='导出数据列设置')

// 	&SQL(UPDATE websys.componentitems SET CustomExpression=replace(CustomExpression,'155',130) WHERE ParRef->name LIKE 'DHCEQ%' AND DisplayType='S' AND CustomExpression LIKE '%155%')

// 	&SQL(UPDATE websys.componentitems SET CustomExpression=replace(CustomExpression,'150',130) WHERE ParRef->name LIKE 'DHCEQ%' AND DisplayType='S' AND CustomExpression LIKE '%150%')

// 	&SQL(UPDATE websys.componentitems SET CustomExpression=replace(CustomExpression,'160',130) WHERE ParRef->name LIKE 'DHCEQ%' AND DisplayType='S' AND CustomExpression LIKE '%160%')

// 	&SQL(UPDATE websys.componentitems SET CustomExpression=replace(CustomExpression,'125',130) WHERE ParRef->name LIKE 'DHCEQ%' AND DisplayType='S' AND CustomExpression LIKE '%125%')

// 	&SQL(UPDATE websys.componentitems SET CustomExpression=replace(CustomExpression,'151',130) WHERE ParRef->name LIKE 'DHCEQ%' AND DisplayType='S' AND CustomExpression LIKE '%151%')

// 	&SQL(UPDATE websys.componentitems SET CustomExpression=replace(CustomExpression,'100',130) WHERE ParRef->name LIKE 'DHCEQ%' AND DisplayType='S' AND CustomExpression LIKE '%100%')

// 	&SQL(UPDATE websys.componentitems SET CustomExpression=replace(CustomExpression,'60',130) WHERE ParRef->name LIKE 'DHCEQ%' AND DisplayType='S' AND CustomExpression LIKE '%60%')

// 	&SQL(UPDATE websys.componentitems SET CustomExpression=replace(CustomExpression,'135',130) WHERE ParRef->name LIKE 'DHCEQ%' AND DisplayType='S' AND CustomExpression LIKE '%135%')

// 	&SQL(UPDATE websys.componentitems SET CustomExpression=replace(CustomExpression,'120',130) WHERE ParRef->name LIKE 'DHCEQ%' AND DisplayType='S' AND CustomExpression LIKE '%120%')

// 	&SQL(UPDATE websys.componentitems SET CustomExpression=replace(CustomExpression,'70',130) WHERE ParRef->name LIKE 'DHCEQ%' AND DisplayType='S' AND CustomExpression LIKE '%70%')

// 	&SQL(UPDATE websys.componentitems SET CustomExpression=replace(CustomExpression,'114',130) WHERE ParRef->name LIKE 'DHCEQ%' AND DisplayType='S' AND CustomExpression LIKE '%114%')

// 	&SQL(UPDATE websys.componentitems SET CustomExpression=replace(CustomExpression,'45',130) WHERE ParRef->name LIKE 'DHCEQ%' AND DisplayType='S' AND CustomExpression LIKE '%45%')

// }

// 

// ClassMethod AA()

// {

// 	s RequestXML="<Response>"

// 	s RequestXML=RequestXML_"<MasterItemList>"

// 	s RequestXML=RequestXML_"<MasterHeadInfo>"

// 	s RequestXML=RequestXML_"<DW>0102</DW>"

// 	s RequestXML=RequestXML_"<DDH>CD1707070501</DDH>"

// 	s RequestXML=RequestXML_"<DDRQ>2017-07-07</DDRQ>"

//    s RequestXML=RequestXML_"<YWLC>集采分收集结</YWLC>"

//    s RequestXML=RequestXML_"<GYS>GYS00072</GYS>"

//    s RequestXML=RequestXML_"<GYSBM>GYS00072</GYSBM>"

//    s RequestXML=RequestXML_"<CGY>YCC1605</CGY>"

//    s RequestXML=RequestXML_"<ZDR>SSJ8051</ZDR>"

//    s RequestXML=RequestXML_"<DDZT>Y</DDZT>"

//    s RequestXML=RequestXML_"<GBZT>N</GBZT>"

//    s RequestXML=RequestXML_"<CKID>309</CKID>"

//    s RequestXML=RequestXML_"</MasterHeadInfo>"

//    s RequestXML=RequestXML_"<MasterItemInfo>"

//    s RequestXML=RequestXML_"<CHBM>7855</CHBM>"

//    s RequestXML=RequestXML_"<KPDW>慈林医院</KPDW>"

//    s RequestXML=RequestXML_"<SL>1.00</SL>"

//    s RequestXML=RequestXML_"<DJ>100.00</DJ>"

//    s RequestXML=RequestXML_"<JE>100.00</JE>"

//    s RequestXML=RequestXML_"<SHDW>慈林医院</SHDW>"

//    s RequestXML=RequestXML_"<ROWID>10039V1000000000IBRO</ROWID>"

//    s RequestXML=RequestXML_"</MasterItemInfo>"

//    s RequestXML=RequestXML_"<MasterItemInfo>"

//    s RequestXML=RequestXML_"<CHBM>7853</CHBM>"

//    s RequestXML=RequestXML_"<KPDW>慈林医院</KPDW>"

//    s RequestXML=RequestXML_"<SL>2.00</SL>"

//    s RequestXML=RequestXML_"<DJ>100.00</DJ>"

//    s RequestXML=RequestXML_"<JE>200.00</JE>"

//    s RequestXML=RequestXML_"<SHDW>慈林医院</SHDW>"

//    s RequestXML=RequestXML_"<ROWID>10039V1000000000IBRP</ROWID>"

//    s RequestXML=RequestXML_"</MasterItemInfo>"

//    s RequestXML=RequestXML_"</MasterItemList>"

//    

// 	s RequestXML=RequestXML_"<MasterItemList>"

// 	s RequestXML=RequestXML_"<MasterHeadInfo>"

// 	s RequestXML=RequestXML_"<DW>90102</DW>"

// 	s RequestXML=RequestXML_"<DDH>CD91707070501</DDH>"

// 	s RequestXML=RequestXML_"<DDRQ>2017-07-07</DDRQ>"

//    s RequestXML=RequestXML_"<YWLC>集采分收集结</YWLC>"

//    s RequestXML=RequestXML_"<GYS>GYS00072</GYS>"

//    s RequestXML=RequestXML_"<GYSBM>GYS00072</GYSBM>"

//    s RequestXML=RequestXML_"<CGY>YCC1605</CGY>"

//    s RequestXML=RequestXML_"<ZDR>SSJ8051</ZDR>"

//    s RequestXML=RequestXML_"<DDZT>Y</DDZT>"

//    s RequestXML=RequestXML_"<GBZT>N</GBZT>"

//    s RequestXML=RequestXML_"<CKID>309</CKID>"

//    s RequestXML=RequestXML_"</MasterHeadInfo>"

//    s RequestXML=RequestXML_"<MasterItemInfo>"

//    s RequestXML=RequestXML_"<CHBM>7857</CHBM>"

//    s RequestXML=RequestXML_"<KPDW>慈林医院</KPDW>"

//    s RequestXML=RequestXML_"<SL>1.00</SL>"

//    s RequestXML=RequestXML_"<DJ>100.00</DJ>"

//    s RequestXML=RequestXML_"<JE>100.00</JE>"

//    s RequestXML=RequestXML_"<SHDW>慈林医院</SHDW>"

//    s RequestXML=RequestXML_"<ROWID>10039V1000000000IBRO</ROWID>"

//    s RequestXML=RequestXML_"</MasterItemInfo>"

//    s RequestXML=RequestXML_"</MasterItemList>"

// 	s RequestXML=RequestXML_"</Response>"

// 	s reader=##class(%XML.Reader).%New()

//    s sc=reader.OpenString(RequestXML)

//    d reader.Correlate("MasterItemList","web.DHCEQ.Interface.OuterTableProperty.DHCEQYYOrderInfoProperty")

//    While reader.Next(.request,.sc)

// 	{

// 		s Order=request.MasterHeadInfo		//主表

// 		w Order.DDH_":"

// 		s OrderList=request.MasterItemInfo.Count()	//明细表

// 		s i=0

// 		f i=1:1:OrderList

// 		{

// 			w request.MasterItemInfo.GetAt(i).CHBM_","

// 		}

// 		w !

// 	}

//    q "OK"

// }

// 

// ClassMethod SnapLocType(MonthStr)

// {

// 	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)

// 	i SnapID="" q ""

// 	;增加科室职能快照	//Add By DJ 2017-08-04

// 	s node="LocType"

// 	s ^DHCEQSnapShot(SnapID,node,0,"Begin")=$g(^DHCEQSnapShot(SnapID,"Equip",0,"Begin"))

// 	s LTRowID=0

// 	f  s LTRowID=$o(^DHCEQCCode("DHCEQCLocType",LTRowID))  quit:LTRowID=""  d

// 	.s LTType=$p($g(^DHCEQCCode("DHCEQCLocType",LTRowID)),"^",1)

// 	.s LTLocDR=$p($g(^DHCEQCCode("DHCEQCLocType",LTRowID)),"^",2)	

// 	.s ^DHCEQSnapShot(SnapID,node,LTType,LTLocDR,LTRowID)=$g(^DHCEQCCode("DHCEQCLocType",LTRowID))

// 	s ^DHCEQSnapShot(SnapID,node,0,"End")=$g(^DHCEQSnapShot(SnapID,"Equip",0,"End"))

// 

// 	q 0

// }

// 

// Storage NewStorage1

// {

// <Type>%CacheStorage</Type>

// }

// 

// ClassMethod DelLocType()

// {

// 	k ^TMPDHCEQMozy

// 

// 	s locdr=0

// 	f  s locdr=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",2,locdr)) quit:locdr=""  d

// 	.s n=0

// 	.s LTRowID=0

// 	.f  s LTRowID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",2,locdr,LTRowID))  quit:LTRowID=""  d

// 	..s LTType=$p($g(^DHCEQCCode("DHCEQCLocType",LTRowID)),"^",1)

// 	..s LTLocDR=$p($g(^DHCEQCCode("DHCEQCLocType",LTRowID)),"^",2)	

// 	..;w $Piece($Get(^CTLOC(locdr)),"^",2)_"          "

// 	..s n=n+1

// 	.i n>1 s ^TMPDHCEQMozy(locdr)=n

// 	

// 	s locdr=0

// 	f  s locdr=$o(^TMPDHCEQMozy(locdr)) quit:locdr=""  d

// 	.s OldID=""

// 	.

// 	.s LTRowID=0

// 	.f  s LTRowID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",2,locdr,LTRowID)) quit:LTRowID=""  d

// 	..i OldID'="" d

// 	...;&SQL(Delete From SQLUser.DHC_EQCLocType where LT_RowID = :OldID)

// 	...s ^TMPDHCEQMozy(locdr)=OldID

// 	..s OldID=LTRowID

// 	

// 	w "OK"

// }

/// // d ##Class(web.DHCEQTest).UpdBCaptionAndImage()
/// // w ##Class(web.DHCEQTest).AA()
/// // add by jdl 2010-3-12 JDL0044
/// // 增加科室快照功能
/// //  d ##Class(web.DHCEQSnapShot).SnapLocType("2017-06")
/// // d ##Class(web.DHCEQTest).DelLocType()
/// d ##Class(web.DHCEQTest).InsertBarInfo()
ClassMethod InsertBarInfo()
{
	;清空表
	k ^DHCEQCCode("DHCEQCBarSet")
	k ^DHCEQCCode("DHCEQCBarInfo")
	k ^DHCEQCCode("DHCEQCBarDetail")
	
	&SQL(insert into SQLUSER.DHC_EQCBarInfo(BI_Desc,BI_Style,BI_Left,BI_Top,BI_BorderStyle,BI_Line,BI_LineB,BI_BorderX,BI_BorderY,BI_OffsetX,BI_LineHeigh,BI_FontName,BI_FontSize,BI_FontBold,BI_BarStyle,BI_BarPosX,BI_BarPosY,BI_BarWidth,BI_BarHeight,BI_CorrectLevel,BI_BarMark,BI_CapationCellWidth,BI_ColWidth,BI_LineOffset,BI_ActiveFlag,BI_PrtName,BI_BarLine,BI_InvalidFlag) values ('二维条码左侧打印-南方医院',1,60,500,0,2,2,3500,2000,1350,200,'宋体',10,'Y',0,160,600,1200,0,3,'EQNo',0,520,0,'Y','tiaoma',2,'N'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_Top,BD_Left,BD_Hidden) values (1,0,'标题','标准二维条码左侧打印','宋体',16,150,60,'N'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum) values (1,0,'EQName','设备名称','名称:','宋体',8,1))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum,BD_Characters) values (1,0,'EQNo','设备编号','编号:','宋体',8,2,10))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum) values (1,0,'EQModelDR_MDesc','规格型号','型号:','宋体',8,3))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum,BD_Characters) values (1,0,'EQManuFactoryDR_MFName','生产厂家','厂家:','宋体',8,4,16))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum) values (1,0,'EQLeaveFactoryNo','出厂编号','SN码:','宋体',8,5))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum) values (1,0,'EQStartDate','启用日期','启用:','宋体',8,6))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum) values (1,0,'EQUseLocDR_CTLOCDesc','使用科室','科室:','宋体',8,7))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum) values (1,0,'EQLocationDR_LDesc','存放地点','存放:','宋体',8,8))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum,BD_Hidden,BD_Characters) values (1,0,'EQHospital','医院名称','医院:','宋体',8,9,'N',16))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum,BD_Hidden) values (1,0,'EQOriginalFee','原值','原值:','宋体',8,10,'Y'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Top,BD_Left,BD_LineX,BD_LineY,BD_Remark) values (1,1,500,1400,1400,1900,'竖线1'))
	
	&SQL(insert into SQLUSER.DHC_EQCBarSet(BS_BarInfoDR,BS_EquipTypeDR,BS_InvalidFlag) VALUES (1,2,'N'))
	
	&SQL(insert into SQLUSER.DHC_EQCBarInfo(BI_Desc,BI_Style,BI_Left,BI_Top,BI_BorderStyle,BI_Line,BI_LineB,BI_BorderX,BI_BorderY,BI_OffsetX,BI_LineHeigh,BI_FontName,BI_FontSize,BI_FontBold,BI_BarStyle,BI_BarPosX,BI_BarPosY,BI_BarWidth,BI_BarHeight,BI_CorrectLevel,BI_BarMark,BI_CapationCellWidth,BI_ColWidth,BI_LineOffset,BI_ActiveFlag,BI_PrtName,BI_BarLine,BI_InvalidFlag) values ('呼和浩特市第二医院条码打印',2,1000,700,0,4,4,3500,2000,50,200,'宋体',10,'Y',1,200,40,400,80,3,'EQNo',0,1500,0,'Y','tiaoma',4,'N'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_Top,BD_Left,BD_Hidden) values (2,0,'标题','呼和浩特市第二医院','宋体',16,100,50,'Y'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_FontName,BD_FontSize,BD_Top,BD_Left,BD_Remark) values (2,0,'EQNo','条码值','宋体',8,500,1600,'打印在码下方'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum,BD_ColNum) values (2,0,'EQName','设备名称','名称:','宋体',8,1,1))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_FontName,BD_FontSize,BD_LineNum,BD_ColNum,BD_Hidden) values (2,0,'EQLocationDR_LDesc','存放地点','宋体',8,1,2,'Y'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum,BD_ColNum) values (2,0,'EQModelDR_MDesc','规格型号','型号:','宋体',8,2,1))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum,BD_ColNum) values (2,0,'EQUseLocDR_CTLOCDesc','使用科室','科室:','宋体',8,2,2))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum,BD_ColNum) values (2,0,'EQTransAssetDate','入库日期','入库:','宋体',8,3,1))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum,BD_ColNum) values (2,0,'EQOriginalFee','原值','单价:','宋体',8,3,2))
	
	&SQL(insert into SQLUSER.DHC_EQCBarInfo(BI_Desc,BI_Style,BI_Left,BI_Top,BI_BorderStyle,BI_Line,BI_LineB,BI_BorderX,BI_BorderY,BI_OffsetX,BI_LineHeigh,BI_FontName,BI_FontSize,BI_FontBold,BI_BarStyle,BI_BarPosX,BI_BarPosY,BI_BarWidth,BI_BarHeight,BI_CorrectLevel,BI_BarMark,BI_CapationCellWidth,BI_ColWidth,BI_LineOffset,BI_ActiveFlag,BI_PrtName,BI_BarLine,BI_InvalidFlag) values ('二维条码左侧打印-成都七院',1,60,500,0,2,2,3500,2000,60,200,'宋体',10,'Y',0,150,1300,600,0,3,'EQNo',550,1800,0,'Y','tiaoma',2,'N'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_Top,BD_Left,BD_Hidden) values (3,0,'标题','成都市第七人民医院','宋体',10,50,800,'N'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_Top,BD_Left,BD_Hidden) values (3,0,'标题','固定资产卡','宋体',10,250,1000,'N'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum,BD_CFontSize,BD_CBold) values (3,0,'EQName','设备名称','名称:','宋体',6,1,8,'Y'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum,BD_CFontSize,BD_CBold) values (3,0,'EQModelDR_MDesc','规格型号','规格:','宋体',6,2,8,'Y'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum,BD_CFontSize,BD_CBold) values (3,0,'EQManuFactoryDR_MFName','生产厂家','厂家:','宋体',6,3,8,'Y'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_LineNum,BD_CFontSize,BD_CBold) values (3,0,'EQLeaveFactoryNo','出厂编号','SN码:','宋体',6,4,8,'Y'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_CFontSize,BD_Top,BD_Left,BD_CBold) values (3,0,'EQStartDate','启用日期','启用:','宋体',6,8,1300,850,'Y'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_CFontSize,BD_Top,BD_Left,BD_CBold) values (3,0,'EQKeeperDR_SSUSRName','管理员','责任人:','宋体',6,8,1300,2200,'Y'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_CFontSize,BD_Top,BD_Left,BD_CBold) values (3,0,'EQNo','设备编号','编号:','宋体',6,8,1500,850,'Y'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_CFontSize,BD_Top,BD_Left,BD_CBold) values (3,0,'EQUseLocDR_CTLOCDesc','使用科室','科室:','宋体',6,8,1700,850,'Y'))
	&SQL(insert into SQLUSER.DHC_EQCBarDetail(BD_BarInfoDR,BD_Type,BD_Key,BD_Caption,BD_PrtCaption,BD_FontName,BD_FontSize,BD_CFontSize,BD_Top,BD_Left,BD_CBold) values (3,0,'EQLocationDR_LDesc','存放地点','存放地:','宋体',6,8,1900,850,'Y'))

	w "OK!"
}

/// d ##Class(web.DHCEQTest).InsertBarDetailKey()
ClassMethod InsertBarDetailKey()
{
	;清空表
	k ^DHCEQCCode("DHCEQCBarDetailKey")
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQABCType','ABC分类','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQAccountNo','凭证号','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQAccountShape','入账形式','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQAddDate','新增日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQAddDepreMonths','调整折旧月份数','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQAddTime','新增时间','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQAddUserDR','新增人','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQAddUserDR_SSUSRName','新增人','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQAdvanceDisFlag','预报废标志','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQAdvanceDisFlagDesc','预报废标志','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQAppendFeeTotalFee','附加费用合计','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQBenefitAnalyFlag','效益分析标志','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQBrand','品牌','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQBuyTypeDR','采购方式DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQBuyTypeDR_BTDesc','采购方式','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQCheckDate','验收日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQChineseMedicineFlag','中医设备标志','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQClassFlag','泛类标志','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQCode','编码','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQCommonageFlag','共用标志','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQComputerFlag','计量标志','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQComputerFlagNew','计量设备','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQConfigLicense','配置许可证号','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQContractListDR','合同明细DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQContractNo','合同号','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQCountryDR','国别DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQCountryDR_CTCOUDesc','国别','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQCurrencyDR','货币','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQDepreMethodDR','折旧方法DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQDepreMethodDR_DMDesc','折旧方法','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQDepreRate','折旧率','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQDepreTotalFee','累计折旧合计','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQDesignWorkLoadNum','额定工作总量','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQDirectionsUse','使用方向','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQDisuseDate','报废日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQElectriccurrent','电流','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQEquiCatDR','设备分类DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQEquiCatDR_ECDesc','设备分类','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQEquipTechLevelDR','设备技术水平DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQEquipTechLevelDR_TLDesc','设备技术水平','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQEquipTypeDR','设备类组DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQEquipTypeDR_ETDesc','设备类组','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQFaultStatus','故障状态','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQFileCat','档案分类号','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQFileNo','档案号','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQFirstAidFlag','急救设备','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQFromDeptDR','设备来源部门DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQFromDeptDR_FTDDesc','设备来源部门','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQGroupDR','机组DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQGroupDR_GRName','机组','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQGuaranteeEndDate','保修结束日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQGuaranteeFlag','计提折旧标志','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQGuaranteePeriodNum','保修月数','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQGuaranteeStartDate','保修开始日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQHasDepreFlag','计提折旧完成标志','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQHold1','异常状态备注','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQHold10','经费来源DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQHold10_EDesc','经费来源','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQHold13','配置表ID','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQHold14','保留14','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQHold15','保留15','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQHold2','入库制单日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQHold3','出库制单日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQHold4','保留4','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQHold5','中医标志','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQHospital','院区','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQInputFlag','直接新增标志(导入设备)','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQInspectionFlag','检验设备','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQInstallDate','安装日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQInstallLocDR','安装地点DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQInstallLocDR_CTLOCDesc','安装地点','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQInStockListDR','入库明细','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQInvalidFlag','无效标志','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQItemDR','设备项','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQItemDR_MIDesc','设备项名称','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQKeeperDR','保管人DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQKeeperDR_SSUSRName','保管人','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQLeaveFactoryDate','出厂日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQLeaveFactoryNo','出厂编号','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQLimitYearsNum','使用年限','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQLocationDR','存放地点DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQLocationDR_LDesc','存放地点','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQMaintUserDR','维修负责人DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQMaintUserDR_SSUSRName','维修负责人','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQMakeDate','制造日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQManageLevelDR','管理级别DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQManageLevelDR_MLDesc','管理级别','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQManageLocDR','管理部门DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQManageLocDR_CTLOCDesc','管理部门','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQManageUserDR','管理责任人DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQManageUserDR_SSUSRName','管理责任人','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQManuFactoryDR','生产厂商DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQManuFactoryDR_MFName','生产厂商','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQMedicalFlag','医疗设备标志','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQMemoryCode','助记码','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQModelDR','机型DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQModelDR_MDesc','机型','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQName','设备名称','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQNetFee','设备净值','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQNetRemainFee','设备净残值','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQNewOldPercent','新旧程度','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQNo','设备编号','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQOldLoc','旧系统科室','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQOldNo','旧系统唯一号','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQOpenCheckDate','开箱验收日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQOpenCheckListDR','验收明细DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQOriginalFee','设备原值','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQOriginDR','设备来源DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQOriginDR_ODesc','设备来源','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQParentDR','主设备','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQPower','功率','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQProjectNo','预算项目编号','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQProviderDR','供应商DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQProviderDR_VName','供应商','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQProviderHandler','供方经办人','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQProviderTel','供方电话','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQPurchaseTypeDR','申购类别DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQPurchaseTypeDR_PTDesc','申购类别','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQPurposeTypeDR','用途DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQPurposeTypeDR_PTDesc','用途','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQRaditionFlag','放射标志','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQRaditionFlagNew','放射设备','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQReciveDate','领用日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQRegistrationNo','医疗器械注册证号','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQRehabilitationFlag','康复设备','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQRemark','备注','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQRentLocDR','出租科室DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQRentLocDR_CTLOCDesc','出租科室','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQRentStatus','出租状态','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQRunStatus','运行状态','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQSalesManager','售后经理','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQSalesManagerTel','售后经理电话','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQSelfFundFee','自筹资金金额','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQSelfFundsFlag','默认资金来源ID','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQServiceDR','售后服务商DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQServiceDR_SVName','售后服务商','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQServiceHandler','服务商联系人','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQServiceTel','服务商联系电话','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQSpec','规格','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQSpecialFlag','特种设备标识','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQStartDate','启用日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQStartDepreMonth','起折月份','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQStatCatDR','设备类型','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQStatCatDR_SCDesc','设备类型','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQStatus','状态','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQStatusDisplay','状态','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQStockStatus','库房状态','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQStoreLocDR','设备库房DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQStoreLocDR_CTLOCDesc','设备库房','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQTestFlag','科研标志','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQToDeptDR','设备去向DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQToDeptDR_FTDDesc','设备去向','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQTransAssetDate','转资日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQUnitDR','设备单位DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQUnitDR_UOMDesc','设备单位','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQUpdateDate','更新日期','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQUpdateTime','更新时间','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQUpdateUserDR','更新人DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQUpdateUserDR_SSUSRName','更新人','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQUrgencyFlag','急购标志','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQUseLocDR','使用部门DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQUseLocDR_CTLOCDesc','使用部门','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQUserDR','使用人DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQUserDR_SSUSRName','使用人','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQValueType','价值类型','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQVideoFlag','影像设备','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQVoltage','电压','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQWorkLoadPerMonth','计划工作量(月)','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQWorkLoadUnitDR','工作量单位DR','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hidden) values ('EQWorkLoadUnitDR_UOMDesc','工作量单位','N'))
	w "Completed!"
}

/// /W ##Class(web.DHCEQTest).UpdSQL()
ClassMethod UpdSQL()
{
	s SQLCODE=0
	TSTART
	&SQL(INSERT INTO DHC_EQPCNoticeCat(NC_Desc,NC_InvalidFlag) VALUES ('制度','N'))
	&SQL(INSERT INTO DHC_EQPCNoticeCat (NC_Desc,NC_InvalidFlag) VALUES ('行业规范','N'))
	&SQL(INSERT INTO DHC_EQPCNoticeCat (NC_Desc,NC_InvalidFlag) VALUES ('医院公告','N'))
	&SQL(INSERT INTO DHC_EQPCNoticeCat (NC_Desc,NC_InvalidFlag) VALUES ('法律法规','N'))

	///标准化消耗资源类型
	K ^DHCEQCCode("DHCEQCResourceType")
	
	&SQL(INSERT INTO SQLUser.DHC_EQCResourceType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag, RT_Type, RT_Price, RT_Unit, RT_ExType, RT_ExID, RT_FixdFlag) VALUES ('01', '人员工资', NULL, 'N', '1',3000, 47, NULL, NULL, 'Y'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCResourceType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag, RT_Type, RT_Price, RT_Unit, RT_ExType, RT_ExID, RT_FixdFlag) VALUES ('02', '培训', NULL, 'N', '2',10000, 47, NULL, NULL, 'Y'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCResourceType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag, RT_Type, RT_Price, RT_Unit, RT_ExType, RT_ExID, RT_FixdFlag) VALUES ('03', '水', NULL, 'N', '1',2, 20, 'Y', NULL, 'Y'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCResourceType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag, RT_Type, RT_Price, RT_Unit, RT_ExType, RT_ExID, RT_FixdFlag) VALUES('04', '电', NULL, 'N', '1',0.84, 44, NULL, NULL, 'Y'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCResourceType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag, RT_Type, RT_Price, RT_Unit, RT_ExType, RT_ExID, RT_FixdFlag)	VALUES('05', '折旧', NULL, 'N', '1',200, 47, NULL, NULL, 'Y'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCResourceType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag, RT_Type, RT_Price, RT_Unit, RT_ExType, RT_ExID, RT_FixdFlag) VALUES('06', '房屋折旧', NULL, 'N', '1',300, 47, NULL, NULL, 'Y'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCResourceType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag, RT_Type, RT_Price, RT_Unit, RT_ExType, RT_ExID, RT_FixdFlag)	VALUES('07', '维修费', NULL, 'N', '2',NULL, 47, NULL, NULL, 'N'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCResourceType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag, RT_Type, RT_Price, RT_Unit, RT_ExType, RT_ExID, RT_FixdFlag)	VALUES('08', '维保费', NULL, 'N', '2',NULL, 47, NULL, NULL, 'N'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCResourceType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag, RT_Type, RT_Price, RT_Unit, RT_ExType, RT_ExID, RT_FixdFlag)	VALUES('09', '保养', NULL, 'N', '2',NULL, 47, NULL, NULL, 'N'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCResourceType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag, RT_Type, RT_Price, RT_Unit, RT_ExType, RT_ExID, RT_FixdFlag)	VALUES('10', '检查', NULL, 'N', '2',NULL, 47, NULL, NULL, 'N'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCResourceType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag, RT_Type, RT_Price, RT_Unit, RT_ExType, RT_ExID, RT_FixdFlag)	VALUES('11', '计量', NULL, 'N', '2',NULL, 47, NULL, NULL, 'N'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCResourceType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag, RT_Type, RT_Price, RT_Unit, RT_ExType, RT_ExID, RT_FixdFlag)	VALUES('12', '质控', NULL, 'N', '2',NULL, 47, NULL, NULL, 'N'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCResourceType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag, RT_Type, RT_Price, RT_Unit, RT_ExType, RT_ExID, RT_FixdFlag)	VALUES('13', '消耗性材料', '注射器、帽子口罩等消耗性低值材料', 'N', '1',10, 2, NULL, NULL, 'Y'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCResourceType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag, RT_Type, RT_Price, RT_Unit, RT_ExType, RT_ExID, RT_FixdFlag)	VALUES('14', '维保费', '胶片、造影剂等', 'N', '1',300, 47, NULL, NULL, 'Y'))

	///增加甲乙类设备分类数据
	&SQL(INSERT INTO SQLUser.DHC_EQCInHospitalType (IHT_Code, IHT_Desc, IHT_Type, IHT_InvalidFlag, IHT_Hold1, IHT_Hold2, IHT_Hold3, IHT_Hold4, IHT_Hold5)	VALUES ('01', 'X线正电子发射型电子计算机断层扫描仪(PET-CT，包括正电子发射型断层仪即PET)', '510', 'N', NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCInHospitalType (IHT_Code, IHT_Desc, IHT_Type, IHT_InvalidFlag, IHT_Hold1, IHT_Hold2, IHT_Hold3, IHT_Hold4, IHT_Hold5)	VALUES ('02', '伽玛射线立体定位治疗系统（γ刀）', '510', 'N', NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCInHospitalType (IHT_Code, IHT_Desc, IHT_Type, IHT_InvalidFlag, IHT_Hold1, IHT_Hold2, IHT_Hold3, IHT_Hold4, IHT_Hold5)	VALUES ('03', '医用电子回旋加速治疗系统（MM50）', '510', 'N', NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCInHospitalType (IHT_Code, IHT_Desc, IHT_Type, IHT_InvalidFlag, IHT_Hold1, IHT_Hold2, IHT_Hold3, IHT_Hold4, IHT_Hold5)	VALUES ('04', '质子治疗系统', '510', 'N', NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCInHospitalType (IHT_Code, IHT_Desc, IHT_Type, IHT_InvalidFlag, IHT_Hold1, IHT_Hold2, IHT_Hold3, IHT_Hold4, IHT_Hold5)	VALUES ('05', '其它单价在500万元及以上的大型医用设备', '510', 'N', NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCInHospitalType (IHT_Code, IHT_Desc, IHT_Type, IHT_InvalidFlag, IHT_Hold1, IHT_Hold2, IHT_Hold3, IHT_Hold4, IHT_Hold5)	VALUES ('06', 'X线电子计算机断层扫描装置（CT）', '511', 'N', NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCInHospitalType (IHT_Code, IHT_Desc, IHT_Type, IHT_InvalidFlag, IHT_Hold1, IHT_Hold2, IHT_Hold3, IHT_Hold4, IHT_Hold5)	VALUES ('07', '医用核磁共振成像设备（MRI）', '511', 'N', NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCInHospitalType (IHT_Code, IHT_Desc, IHT_Type, IHT_InvalidFlag, IHT_Hold1, IHT_Hold2, IHT_Hold3, IHT_Hold4, IHT_Hold5)	VALUES ('08', '数字减影血管造影X线机（DSA）', '511', 'N', NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCInHospitalType (IHT_Code, IHT_Desc, IHT_Type, IHT_InvalidFlag, IHT_Hold1, IHT_Hold2, IHT_Hold3, IHT_Hold4, IHT_Hold5)	VALUES ('09', '医用电子直线加速器（LA）', '511', 'N', NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCInHospitalType (IHT_Code, IHT_Desc, IHT_Type, IHT_InvalidFlag, IHT_Hold1, IHT_Hold2, IHT_Hold3, IHT_Hold4, IHT_Hold5)	VALUES ('010', '单光子发射型电子计算机断层扫描装置（SPECT）', '511', 'N', NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCEquipAttribute (EA_Code, EA_Name, EA_Group, EA_Remark, EA_InvalidFlag, EA_Hold1, EA_Hold2, EA_Hold3, EA_Hold4, EA_Hold5)	VALUES ('51', '甲乙类设备', '05', NULL, NULL, NULL, NULL, NULL, NULL, NULL))

	&SQL(UPDATE SQLUser.DHC_EQCSysSet SET  SS_Value = '01,02,03,04,05' WHERE SS_Code = '990065')

	&SQL(UPDATE DHC_EQCComponent SET C_DefaultSize=NULL WHERE C_Name='EM.L.IFBAgency')
	i SQLCODE
	{
		TROLLBACK
		Q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

/// d ##Class(web.DHCEQTest).UpdColumsContractList()
ClassMethod UpdColumsContractList()
{
	&sql(insert into dhc_eqcsysset (ss_code,ss_value,ss_desc,ss_remark,ss_hidden) values ('990076','2','核算项目控制参数','0:不启用  1:启用非必填 2:启用且必填','N'))

	&sql(insert into dhc_eqcsysset (ss_code,ss_value,ss_desc,ss_remark,ss_hidden) values ('990077','1','单项资金来源是否允许多个核算项目','0:不允许 1:允许','N'))

	&sql(UPDATE dhc_eqcsysset SET SS_Value='1,2,3,4' WHERE SS_Code='990041')

	&sql(UPDATE DHC_EQCComponentItem SET CI_LinkUrl='dhceq.em.funds.csp' WHERE CI_ComponentDR->C_Name='EM.G.InStock.InStockList')

	/*
	&sql(INSERT INTO SQLUSER.DHC_EQCTableData(TD_Code,TD_Desc,TD_GetDataType,TD_Remark) VALUES ('ContractList','合同明细查询',1,'合同明细查询'))
	i SQLCODE q SQLCODE
	s tdid=""
	&sql(SELECT TD_RowID into:tdid from SQLUSER.DHC_EQCTableData where TD_Code="ContractList")
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TContractName','N','合同名称',1,'4','001'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TContractNo','N','合同号',2,'4','002'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TSignDate','N','签订日期',3,'1','003'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TSignLoc','N','签订科室',4,NULL,'004'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TPreFeeFee','N','预付款',5,'2','005'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TPayedTotalFee','N','已付款',6,'2','006'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TDeliveryDate','N','交货日期',7,'1','007'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TArriveDate','N','到货日期',8,'1','008'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TStartDate','N','有效开始日期',9,'1','009'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TEndDate','N','有效截止日期',10,'1','010'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TService','N','服务商',12,NULL,'011'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TProvider','N','供应商',14,NULL,'012'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TProviderTel','N','供方联系方式',15,'4','013'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TProviderHandler','N','供方联系人',16,NULL,'014'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TGuaranteePeriodNum','N','保修期',18,NULL,'015'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TContractType','N','合同类型',20,NULL,'016'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TFileNo','N','档案号',21,'4','017'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TName','N','设备名称',22,NULL,'018'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TPrice','N','单价',23,'2','019'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TQuantityNum','N','数量',24,NULL,'020'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TTotal','N','金额',25,'2','021'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'THold1','N','技术服务费',26,'2','022'))
	&sql(INSERT INTO SQLUSER.DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Format,C_Sort) VALUES(:tdid,'TContractFee','N','合同金额',27,'2','023'))
*/
}

/// Add by czf 2021-06-02
/// 导出项目工程下的文件(每个文件对应一个xml)
/// w ##class(web.DHCEQTest).ExportPrjItem("DHCEQ20230421","C:\Users\admin\Desktop\设备管理\程序合并\trunk\20230420")
ClassMethod ExportPrjItem(PrjName, Path = "") As %String
{
	q:PrjName="" "无对应的工程："_PrjName 
	
	s:Path="" Path="C:\ExportPrjItem\"
	s AllName=""
	
	;查询Project下的项目
	Set Obj=##class(%Studio.Project).%New()
	Set rset=##class(%ResultSet).%New("%Studio.Project:ProjectItemsList")
	do rset.Execute(PrjName)
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		s name=rset.Data("Name")
		s type=rset.Data("Type")
		k list
		i ##class(%RoutineMgr).Exists(name_$Select(type="CLS"||(type="PKG")||(type="DIR"):"."_type,1:"")) {
			s list(name_$Select(type="CLS"||(type="PKG"):"."_type,1:""))=""
			
			;记录导出的文件名
			i AllName="" s AllName=name_$Select(type="CLS"||(type="PKG"):"."_"cls",1:"")
			e  s AllName=AllName_$c(1)_name_$Select(type="CLS"||(type="PKG"):"."_"cls",1:"")
			
			s type=$zcvt(type,"U")
			s last=$p(name,".",*)
			continue:((".js^.JS")[last)
			
			;特殊处理xml名字
			i type="CSP" {
				s name=$replace(name,"/","_")
				i name[".csp" d
				.s name=$replace(name,".csp","")
				.s name="Csp\"_name		//$p(name,"_",*)
			}
			i type="CLS" {
				i name["web." s name="WebCls\"_$p(name,".",2,*)
				i name["User." s name="UserCls\"_$p(name,".",2,*)
			}
			
			s XMlName=name_".xml"
			s:Path'="" XMlName=Path_"\"_XMlName
			s ret=Obj.ExportList(XMlName,.list)
		}
	}
	i AllName'=""{
		s filename="log.txt"
		s:Path'="" filename=Path_"\"_filename
		s file=##class(%File).%New(filename)
		d file.Open("WSN")
		f len=1:1:$l(AllName,$c(1)) d
		.s name=$p(AllName,$c(1),len)
		.i ((name[(".js"))||(name[(".js"))) s name=$replace(name,"imedical/web/","")
		.i name[(".csp") s name=$replace(name,"imedical/web/csp/","")
		.d file.WriteLine(name)	
		d file.Close()	
	}else{
		w "无对应的工程："_PrjName ,!
	}

	q ""
}

/// d ##Class(web.DHCEQTest).InsertAFBarDetailKey()
ClassMethod InsertAFBarDetailKey()
{
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFAddDate','追加日期','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFAffixCatDR','附件分类','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFAffixDR','附件','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFChangeAccountAddDR','增值调账ID','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFChangeAccountReduceDR','减值调账ID','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFCheckListDR','验收明细ID','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFCurrencyDR','单位','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFCurrencyDR_UOMDesc','单位','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFDisuseFlag','报废标志','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFEquipDR','设备','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFGuaranteeEndDate','保修截止日期','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFGuaranteeStartDate','保修开始日期','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFHold1','保留1','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFHold2','保留2','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFHold3','保留3','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFHold4','保留4','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFHold5','保留5','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFInvalidFlag','无效标志','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFInvoiceNo','发票号','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFLeaveDate','出厂日期','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFLeaveFacNo','出厂编号','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFManuFactoryDR','制造厂家','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFManuFactoryDR_MFName','生产厂商','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFNo','附件编号','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFOldRowID','原ID','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFOperFlag','执行标识','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFPartModel','型号','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFPartSpec','附件名称','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFPriceFee','单价','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFProviderDR','供应商','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFProviderDR_VName','供应商','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFQuantityNum','数量','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFReceiverDR','接收人','附件','Y'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFRemark','备注','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFSplitFlag','拆分标记','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFUpdateDate','更新日期','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFUpdateTime','更新时间','附件','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('AFUpdateUserDR','更新人','附件','Y'))

	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('DRSubmitUserDR_UDesc','更新时间','报废','N'))
	&SQL(Insert Into DHC_EQCBarDetailKey(BDK_Name,BDK_Desc,BDK_Hold1,BDK_Hidden) values ('DRSubmitDate','更新时间','报废','N'))

	w "Completed!"
}

/// d ##Class(web.DHCEQTest).InsertTableData()
ClassMethod InsertTableData()
{
	s ^DHCEQCCode("DHCEQCTableData",13)="InventoryException^盘盈设备清单^1^^盘盈设备清单^^^^^"
	s ^DHCEQCCode("DHCEQCTableData",0,"Code","INVENTORYEXCEPTION",13)=""
	s ^DHCEQCCode("DHCEQCTableData",0)=13
	
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Sort) values (13,'IERowID','Y','IERowID',1,1))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Format, C_Sort) values (13,'InventoryNo','N','盘点单号',2,4,2))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Sort) values (13,'EquipName','N','资产名称',3,3))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Format, C_Sort) values (13,'EquipNo','N','资产编号',4,4,4))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Format, C_Sort) values (13,'OriginalFee','N','原值',5,2,5))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Format, C_Sort) values (13,'Model','N','规格型号',6,4,6))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Format, C_Sort) values (13,'StartDate','N','启用日期',7,1,7))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Format, C_Sort) values (13,'TransAssetDate','N','转资日期',8,1,8))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Sort) values (13,'UseLoc','N','使用科室',9,9))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Sort) values (13,'StoreLoc','N','所在库房',10,10))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Sort) values (13,'ManuFactory','N','生产厂商',11,11))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Sort) values (13,'Provider','N','供货商',12,12))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Sort) values (13,'Location','N','存放地点',13,13))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Format, C_Sort) values (13,'LeaveFactoryNo','N','出厂编号',14,4,14))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Format, C_Sort) values (13,'Date','Y','盘盈日期',15,1,15))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Sort) values (13,'Time','Y','盘盈时间',16,16))
	&SQL(insert into SQLUSER.DHC_EQCColumns(C_TableDR, C_Name, C_HiddenFlag, C_Caption, C_Location, C_Sort) values (13,'Remark','N','备注',17,17))

	w "Completed!"
}

/// add by czf 2021-09-16
/// d ##Class(web.DHCEQTest).InsertChartsDefine()
/// 插入图表定义
ClassMethod InsertChartsDefine()
{
	&SQL(UPDATE DHC_EQCComponent SET C_ClassName='web.DHCEQ.BA.RPTList' WHERE C_Name='BA.G.LocBenefitInfo')

	&SQL(UPDATE DHC_EQCComponent SET C_ClassName='web.DHCEQ.BA.RPTList' WHERE C_Name='BA.G.StatCatBenefitInfo')

	&SQL(UPDATE DHC_EQCComponent SET C_ClassName='web.DHCEQ.BA.RPTBaseList' WHERE C_Name='BA.G.EquipBenefitInfo')

	&SQL(UPDATE DHC_EQCChartsDefine SET CD_WebCls='web.DHCEQ.BA.RPTEchart' WHERE CD_WebCls='web.DHCEQ.BA.BUSBenefitAnalyReport')

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType)
	VALUES ('BAEQNumAmount', '效益设备信息', 'web.DHCEQ.BA.RPTEchart', 'GetBenefitAnaly', 'eqblock'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType)
	VALUES ('BAInOutAmount', '收支信息', 'web.DHCEQ.BA.RPTEchart', 'GetBenefitAnaly', 'eqblock'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType)
	VALUES ('BAInOutPerDay', '日均收支', 'web.DHCEQ.BA.RPTEchart', 'GetBenefitAnaly', 'eqblock'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType)
	VALUES ('BAInOutQoQ', '收支环比', 'web.DHCEQ.BA.RPTEchart', 'GetBenefitAnaly', 'eqblock'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType)
	VALUES ('BAInOutYoY', '收支同比', 'web.DHCEQ.BA.RPTEchart', 'GetBenefitAnaly', 'eqblock'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType)
	VALUES ('BACheckPerson', '服务人次', 'web.DHCEQ.BA.RPTEchart', 'GetBenefitAnaly', 'eqblock'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_Remark, CD_Detail, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_LegentX, CD_LegendShow)
	VALUES ('InComeTypeAnaly', '效益分析收入来源分析', NULL, NULL, 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'pie', '收入来源', '50', '50,50', 'left', 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_Remark, CD_Detail, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_LegentX,CD_Hold1)
	VALUES ('ItemInOutRate', '设备项收支比', NULL, NULL, 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', 'center','百分比'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_Remark, CD_Detail, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_LegentX,CD_Hold1)
	VALUES ('LocInComeRate', '科室收支比', NULL, NULL, 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', 'center','百分比'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_Remark, CD_Detail, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_LegentX,CD_Hold1)
	VALUES ('StatCatInOutRate', '设备类型收支比', NULL, NULL, 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', 'center','百分比'))

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_SeriesType='bar',CD_SeriesStack = '收支' WHERE CD_Code = 'LocBenefitInfo')

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesStack, CD_LegentX, CD_Hold1, CD_LegendShow)
	VALUES ('LocOutItemInfo', '科室支出项统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'bar', '科室支出项', 'center', '金额(元)', 'N'))

	&SQL(UPDATE DHC_EQCChartsDefine SET CD_Hold2=NULL,CD_Hold1='金额(元)' WHERE CD_Code IN ('ItemBenefitInfo','LocBenefitInfo','EquipOutFeeInfo','LocPerMonthBenefit','LocEquipOutFeeInfo','SCPerMonthBenefit','StatCatBenefitInfo'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
	VALUES ('LocInComeQoY', '科室收入同比-环比', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line','center','百分比'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
	VALUES ('LocOutFeeQoY', '科室支出同比-环比', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line','center','百分比'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
	VALUES ('LocCheckPerson', '科室检查人次', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'bar','center','百分比'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
	VALUES ('InComeTypeQoYRate', '收入类型同比-环比', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line','center','百分比'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
	VALUES ('ItemCheckPeron', '设备项检查人次', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line','center','百分比'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
	VALUES ('ItemExposureNum', '设备项曝光次数', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'bar','center','百分比'))
	
	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
	VALUES ('StatCatBenefitInfo', '设备类型效益分析', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'bar','center','金额(元)'))

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_SeriesStack = NULL WHERE CD_Code = 'LocBenefitInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_LegendShow = 'N' WHERE CD_Code = 'LocEquipNums')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_LegendShow = 'N' WHERE CD_Code = 'StatCatEquipAmount')

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
	VALUES ('EQMonthInOut', '设备收支统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'line','center','金额(元)'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX)
	VALUES ('EQMonthWorkLoad', '设备工作量统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'bar','center'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
	VALUES ('EQMonthCheckPerson', '设备检查人次统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'line','center','人次'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
	VALUES ('EQMonthExposure', '设备曝光次数', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'bar','center','次'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType)
	VALUES ('BAEQInOutAmount', '设备收支信息', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'eqblock'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType)
	VALUES ('BAEQCheckPerson', '设备人次信息', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'eqblock'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType)
	VALUES ('BAEQWorkAmount', '设备工作统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'eqblock'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType)
	VALUES ('BAEQCostAmount', '设备成本统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'eqblock'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType)
	VALUES ('BAEQMaintAmount', '设备维保统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'eqblock'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_Remark, CD_Detail, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_LegentX, CD_LegendShow)
	VALUES ('EQFixedCost', '设备固定成本统计', NULL, NULL, 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'pie', '支出项', '50', '50,50', 'left', 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_Remark, CD_Detail, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_LegentX, CD_LegendShow)
	VALUES ('EQVariableCost', '设备变动成本统计', NULL, NULL, 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'pie', '支出项', '50', '50,50', 'left', 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
	VALUES ('SameEQBAInfo', '同类设备效益信息', 'web.DHCEQ.BA.RPTEchart', 'M_GetSameEQBAChart', 'bar','center','金额(元)'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
	VALUES ('SameEQMaintInfo', '同类设备维修信息', 'web.DHCEQ.BA.RPTEchart', 'M_GetSameEQMaintChart', 'bar','center','次'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
		VALUES ('DoctorPositiveRate', '医生开单阳性率', 'web.DHCEQ.BA.RPTEchart', 'M_DoctorPositiveRate', 'line','center','阳性率(百分比)'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
		VALUES ('PatientNum', '日检查人数', 'web.DHCEQ.BA.RPTEchart', 'M_PersonTimes', 'bar','center','检查人次(位)'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
		VALUES ('AvgTime', '平均扫描时长', 'web.DHCEQ.BA.RPTEchart', 'M_PersonTimes', 'bar','center','扫描时长(分)'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
		VALUES ('LatelyInOut', '近年收益统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetLatelyYearsBA', 'bar','center','金额(元)'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType,CD_LegentX,CD_Hold1)
		VALUES ('LatelyInOutYOYRate', '近年收益同比', 'web.DHCEQ.BA.RPTEchart', 'M_GetLatelyYearsBA', 'line','center','百分比'))

	&SQL(UPDATE SQLUser.DHC_EQCResourceType SET RT_Desc = '耗材' WHERE RT_Code = 14)

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_SeriesStack = NULL WHERE CD_Code = 'EquipOutFeeInfo')
	
	&SQL(INSERT INTO DHC_EQCChartsDefine (CD_Code,CD_Desc,CD_WebCls,CD_QueryMethod,CD_SeriesType,CD_Hold1) 
		VALUES ('CompareServiceIncome','检测收入预测实际对比','web.DHCEQ.BA.RPTEchart','M_GetBenefitAnaly','line','金额(元)'))

	&SQL(INSERT INTO DHC_EQCChartsDefine (CD_Code,CD_Desc,CD_WebCls,CD_QueryMethod,CD_SeriesType,CD_Hold1) 
		VALUES ('CompareMaterialIncome','材料收入预测实际对比','web.DHCEQ.BA.RPTEchart','M_GetBenefitAnaly','line','金额(元)'))

	&SQL(INSERT INTO DHC_EQCChartsDefine (CD_Code,CD_Desc,CD_WebCls,CD_QueryMethod,CD_SeriesType,CD_Hold1) 
		VALUES ('CompareMaintFee','维修费预测实际对比','web.DHCEQ.BA.RPTEchart','M_GetBenefitAnaly','line','金额(元)'))

	&SQL(INSERT INTO DHC_EQCChartsDefine (CD_Code,CD_Desc,CD_WebCls,CD_QueryMethod,CD_SeriesType,CD_Hold1) 
		VALUES ('CompareFeeOfEmployee','人员费预测实际对比','web.DHCEQ.BA.RPTEchart','M_GetBenefitAnaly','line','金额(元)'))
		
	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Code = 'CompareMaterialFee',CD_Desc='耗材费预测实际对比' WHERE CD_Code = 'CompareMaterialIncome')

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_LegentX, CD_Hold1)
		VALUES ('SameEQMaintRate', '同类设备维修率', 'web.DHCEQ.BA.RPTEchart', 'M_GetSameEQMaintChart', 'line', 'center','百分比'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius,CD_SeriesCenter, CD_LegentX)
		VALUES ('SameEQMaintTimeCost', '同类设备维修时长', 'web.DHCEQ.BA.RPTEchart', 'M_GetSameEQMaintChart', 'pie', '型号', '50', '50,50', 'left'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_LegentX, CD_Hold1)
		VALUES ('SameEQLocBAInfo', '同类设备科室效益信息', 'web.DHCEQ.BA.RPTEchart', 'M_GetSameEQBAChart', 'line', 'center','金额(元)'))
}

/// d ##Class(web.DHCEQTest).UpdBnefitIndex()
ClassMethod UpdBnefitIndex()
{
	
	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='LocOutItemInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='StatCatEquipAmount')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='StatCatInComeInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='StatCatOutFeeInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='StatCatBenefitInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='LatelyInOut')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='SameEQBAInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='SameEQLocBAInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='ItemBenefitInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='ItemInComeInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='ItemOutFeeInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='LocInComeInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='LocOutFeeInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='LocBenefitInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='InComeTypeAnaly')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '金额(万元)' WHERE CD_Code='EquipOutFeeInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_LegendShow = 'N' WHERE CD_Code='SameEQMaintTimeCost')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '人次' WHERE CD_Code='LocCheckPerson')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Hold1 = '人次' WHERE CD_Code='ItemCheckPeron')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_XAxisType = NULL,CD_YAxisType = NULL WHERE CD_Code='EquipOutFeeInfo')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_Code = 'ItemWorkLoad',CD_Desc='设备项工作量统计',CD_Hold1=NULL WHERE CD_Code='ItemExposureNum')

	&SQL(UPDATE SQLUser.DHC_EQCChartsDefine SET CD_SeriesType = 'line',CD_SeriesName=NULL,CD_SeriesRadius=NULL,CD_SeriesCenter=NULL,CD_LegendShow=NULL,CD_LegentX=NULL,CD_Hold1='时' WHERE CD_Code='SameEQMaintTimeCost')

	&SQL(DELETE DHC_EQCChartsColorScheme WHERE CCS_RowID>14)
}

/// ////////////////////////////////////////////////////////////
/// Add By CZF 2022-01-13
/// 描述：设备卡片
/// 接口调用:CALL web_DHCEQTest_GetEquipCard()
/// 输出结果:
/// d ##class(%ResultSet).RunQuery("web.DHCEQTest","GetEquipCard")
Query GetEquipCard() As %Query(ROWSPEC = "TEQRowID:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TEQNo:%String,TEQName:%String,TCode:%String,TModel:%String,TNum:%String,TUnit:%String,TOriginalFee:%String,TStoreLoc:%String,TStatus:%String,TTransAssetDate:%String,TStartDate:%String,TDepreMethod:%String,TLimitYearsNum:%String,TDepreTotalFee:%String,TNetRemainrate:%String,TVendor:%String,TManufacturer:%String,TLeaveFacNo:%String,TLeaveFacDate:%String,TCountry:%String,TPurposeType:%String,TOrigin:%String,TManager:%String,TKeeper:%String,TFromDept:%String,TRemark:%String,TOldLoc:%String,TDisuseDate:%String,TMemoryCode:%String,TLocation:%String,TAccountNo:%String,TFileNo:%String,TFundsInfo:%String,TRegistrationNo:%String,TBrand:%String,THold10:%String,TGuranteeNum:%String,TTreeCat:%String,TFinanceItemCode:%String,TDepreNum:%String,TOldNo:%String,TStockStatus:%String") [ SqlProc ]
{
}

ClassMethod GetEquipCardExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetEquipCard
	Quit $$$OK
BuildDataGetEquipCard
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQEquip(EQRowID))  quit:EQRowID=""  d
	.s EQInvalidFlag=$p($g(^DHCEQEquip(EQRowID)),"^",59)
	.q:EQInvalidFlag="Y"
	.s EQStatus=$p($g(^DHCEQEquip(EQRowID)),"^",38)
	.s EQStockStatus=$p($g(^DHCEQEquip(EQRowID)),"^",60)
	.q:+EQStockStatus=0
	.d ResetVariablesGetEquipCard
	.s TEQRowID=EQRowID
	.s TItemDR=$p($g(^DHCEQEquip(EQRowID)),"^",7)
	.s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p($g(^DHCEQEquip(EQRowID)),"^",63))
	.s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",$p($g(^DHCEQEquip(EQRowID)),"^",75))
	.s TEquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",$p($g(^DHCEQEquip(EQRowID)),"^",4))
	.s TEQNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	.s TEQName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	.s TCode=$p($g(^DHCEQEquip(EQRowID)),"^",6)
	.s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(EQRowID)),"^",3))
	.s TNum=1
	.s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p($g(^DHCEQEquip(EQRowID)),"^",5))
	.s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",27))
	.s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(EQRowID)),"^",67))
	.s TStatus=$p($g(^DHCEQEquip(EQRowID)),"^",38)
	.s TStatus=$case(TStatus,"0":"在库","1":"在用","2":"退货","3":"报废",:"")
	.s TTransAssetDate=$p($g(^DHCEQEquip(EQRowID)),"^",45)
	.i TTransAssetDate'="" s TTransAssetDate=$zd(TTransAssetDate,3)
	.s TStartDate=$p($g(^DHCEQEquip(EQRowID)),"^",44)
	.i TStartDate'="" s TStartDate=$zd(TStartDate,3)
	.s TDepreMethod=##Class(web.DHCEQCommon).GetTrakNameByID("depremethod",$p($g(^DHCEQEquip(EQRowID)),"^",33))
	.s TLimitYearsNum=$p($g(^DHCEQEquip(EQRowID)),"^",31)
	.s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",35))
	.s TNetRemainrate=""
	.s TVendor=##Class(web.DHCEQCommon).GetTrakNameByID("prov",$p($g(^DHCEQEquip(EQRowID)),"^",25))
	.s TManufacturer=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQEquip(EQRowID)),"^",26))
	.s TLeaveFacNo=$p($g(^DHCEQEquip(EQRowID)),"^",10)
	.s TLeaveFacDate=$p($g(^DHCEQEquip(EQRowID)),"^",11)
	.i TLeaveFacDate'="" s TLeaveFacDate=$zd(TLeaveFacDate,3)
	.s TCountry=##Class(web.DHCEQCommon).GetTrakNameByID("country",$p($g(^DHCEQEquip(EQRowID)),"^",16))
	.s TPurposeType=##Class(web.DHCEQCommon).GetTrakNameByID("purposetype",$p($g(^DHCEQEquip(EQRowID)),"^",65))
	.s TOrigin=##Class(web.DHCEQCommon).GetTrakNameByID("origin",$p($g(^DHCEQEquip(EQRowID)),"^",20))
	.s TManager=##Class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQEquip(EQRowID)),"^",39))
	.s TKeeper=##Class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQEquip(EQRowID)),"^",66))
	.s TFromDept=$p($g(^DHCEQEquip(EQRowID)),"^",21)
	.i TFromDept'="" s TFromDept=$p(^DHCEQCCode("DHCEQCFromToDept",TFromDept),"^",2)
	.s TRemark=$p($g(^DHCEQEquip(EQRowID)),"^",34)
	.s TRemark=##class(web.DHCEQCommon).Replace(TRemark,$c(13,10),";")
	.s TOldLoc=$p($g(^DHCEQEquip(EQRowID)),"^",79)
	.s TDisuseDate=$p($g(^DHCEQEquip(EQRowID)),"^",89)
	.i TDisuseDate'="" s TDisuseDate=$zd(TDisuseDate,3)
	.s TMemoryCode=$p($g(^DHCEQEquip(EQRowID)),"^",61)
	.s TLocation=##Class(web.DHCEQCommon).GetTrakNameByID("location",$p($g(^DHCEQEquip(EQRowID)),"^",72))
	.s TAccountNo=$p($g(^DHCEQEquip(EQRowID)),"^",90)
	.s TFileNo=$p($g(^DHCEQEquip(EQRowID)),"^",85)
	.s TFundsInfo=##class(web.DHCEQEquip).GetFundsInfo(EQRowID)
	.s TRegistrationNo=$p($g(^DHCEQEquip(EQRowID)),"^",92)
	.s TBrand=##Class(web.DHCEQCommon).GetTrakNameByID("brand",$p($g(^DHCEQEquip(EQRowID)),"^",95))
	.s THold10=##Class(web.DHCEQCommon).GetTrakNameByID("expense",$p($g(^DHCEQEquip(EQRowID)),"^",94))
	.s TGuranteeNum=$p($g(^DHCEQEquip(EQRowID)),"^",73)
	.s TTreeCat=$p(^DHCEQCCode("DHCEQCMasterItem",TItemDR),"^",10)
	.i TTreeCat'="" s TTreeCat=$p(^DHCEQCCode("DHCEQCTree",TTreeCat),"^",3)
	.s TFinanceItemCode=""		//核算项目编码
	.s TDepreSetID=$o(^DHCEQDepreSet(0,"Equip",EQRowID,""))
	.i TDepreSetID'="" s TDepreNum=$p(^DHCEQDepreSet(TDepreSetID),"^",22)
	.s TItemName=$p(^DHCEQCCode("DHCEQCMasterItem",TItemDR),"^",22)
	.s TOldNo=$p($g(^DHCEQEquip(EQRowID)),"^",91)
	.s TStockStatus=$p($g(^DHCEQEquip(EQRowID)),"^",60)
	.d OutputRowGetEquipCard
	quit
OutputRowGetEquipCard
	s Data=$lb(TEQRowID,TEquipType,TStatCat,TEquipCat,TEQNo,TEQName,TCode,TModel,TNum,TUnit,TOriginalFee,TStoreLoc,TStatus,TTransAssetDate,TStartDate,TDepreMethod,TLimitYearsNum,TDepreTotalFee,TNetRemainrate,TVendor,TManufacturer,TLeaveFacNo,TLeaveFacDate,TCountry,TPurposeType,TOrigin,TManager,TKeeper,TFromDept,TRemark,TOldLoc,TDisuseDate,TMemoryCode,TLocation,TAccountNo,TFileNo,TFundsInfo,TRegistrationNo,TBrand,THold10,TGuranteeNum,TTreeCat,TFinanceItemCode,TDepreNum,TOldNo,TStockStatus)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipCard
	s (TEQRowID,TItemDR,TEquipType,TStatCat,TEquipCat,TEQNo,TEQName,TCode,TModel,TNum,TUnit,TOriginalFee,TStoreLoc,TStatus,TTransAssetDate,TStartDate,TDepreMethod,TLimitYearsNum,TDepreTotalFee,TNetRemainrate,TVendor,TManufacturer,TLeaveFacNo,TLeaveFacDate,TCountry,TPurposeType,TOrigin,TManager,TKeeper,TFromDept,TRemark)=""
	s (TOldLoc,TDisuseDate,TMemoryCode,TLocation,TAccountNo,TFileNo,TFundsInfo,TRegistrationNo,TBrand,THold10,TGuranteeNum,TTreeCat,TFinanceItemCode,TDepreNum,TOldNo,TStockStatus)=""
	quit
}

ClassMethod GetEquipCardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipCardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEquipCardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipCardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by mwz 20220117 mwz0057
/// 列定义追加
/// d ##Class(web.DHCEQTest).InsertTableDataNew()
ClassMethod InsertTableDataNew()
{
	&SQL(Insert Into DHC_EQCTableData(TD_CODE,TD_Desc,TD_GetDataType,TD_Remark) values ('EQAReduceList','配件退货明细查询','1','配件退货明细查询'))
	&SQL(Insert Into DHC_EQCTableData(TD_CODE,TD_Desc,TD_GetDataType,TD_Remark) values ('EQAInStockList','配件入库明细查询','1','配件入库明细查询'))
	&SQL(Insert Into DHC_EQCTableData(TD_CODE,TD_Desc,TD_GetDataType,TD_Remark) values ('EQUnPayRequestList','未付款明细查询','1','未付款明细查询'))
	&SQL(Insert Into DHC_EQCTableData(TD_CODE,TD_Desc,TD_GetDataType,TD_Remark) values ('EQInStockDetailInvoice','入库发票明细查询','1','入库发票明细查询'))
}

/// add by mwz 20220117 mwz0057
/// 列定义明细追加
/// d ##Class(web.DHCEQTest).InsertColsetTestNew()
ClassMethod InsertColsetTestNew()
{
	/// AReduceList :  TISNo_"^"_TLoc_"^"_TProvider_"^"_TAccessory_"^"_TPrice_"^"_TQuantityNum_"^"_TTotalFee
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('14','TISNo','N','退货单号','1','001'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('14','TLoc','N','科室','2','002'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('14','TProvider','N','供应商','3','003'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('14','TAccessory','N','配件名称','4','004'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('14','TPrice','N','单价','5','005'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('14','TQuantityNum','N','数量','6','006'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('14','TTotalFee','N','总价','7','007'))
	//AInStockList :   TISNo_"^"_TLoc_"^"_TAccessory_"^"_TAccessoryType_"^"_TProvider_"^"_TPrice_"^"_TQuantityNum_"^"_TTotalFee_"^"_TShortDesc_"^"_TBuyUser
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('15','TISNo','N','入库单号','1','001'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('15','TLoc','N','科室','2','002'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('15','TAccessory','N','配件类型','3','003'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('15','TAccessory','N','配件名称','4','004'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('15','TProvider','N','供应商','5','005'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('15','TPrice','N','单价','6','006'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('15','TQuantityNum','N','数量','7','007'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('15','TTotalFee','N','总价','8','008'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('15','TShortDesc','N','短名称','9','009'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('15','TBuyUser','N','采购人','10','010'))
    //Unpaylist : TRowID_"^"_TSourceType_"^"_TSourceNo_"^"_TDate_"^"_TEquipName_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TTotalFee_"^"_TPaedFee_"^"_TNeedPayFee_"^"_TAmountFee_"^"_TRemark_"^"_TReduceQtyNum_"^"_TInvoiceNo_"^"_TInvoiceDate_"^"_TLoc_"^"_TEquipType_"^"_TGuaranteeDate_"^"_TGuaranteeFee_"^"_TRate_"^"_TOpenCheckDate_"^"_TProvider_"^"_TOpenCheckAuditDate_"^"_TOpenCheckOrigin_"^"_TOpenCheckRemark_"^"_TUseLoc
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TSourceNo','N','业务单号','3','001'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TEquipName','N','设备名称','5','002'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TEquipType','N','类组','17','003'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TProvider','N','供应商','22','004'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TOriginalFee','N','原值','6','005'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TQuantityNum','N','数量','7','006'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TTotalFee','N','金额','8','007'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TPaedFee','N','已付','9','008'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TNeedPayFee','N','未付','10','009'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TLoc','N','科室','16','010'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TGuaranteeFee','N','质保金额','19','011'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TGuaranteeDate','N','质保日期','18','012'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TOpenCheckDate','N','验收日期','21','013'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TOpenCheckAuditDate','N','验收审核日期','23','014'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TOpenCheckOrigin','N','来源','24','015'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('16','TOpenCheckRemark','N','备注','25','016'))
    //InStockInvoiceDetail:TISRowID_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLoc_"^"_TStatCat_"^"_TEquipType_"^"_TISLRowID_"^"_TEquipName_"^"_TModel_"^"_TUnit_"^"_TQuantityNum_"^"_TOriginalFee_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TInvoice_"^"_TRemark_"^"_TBuyLoc_"^"_TOrigin
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('17','TISNo','N','入库单号','4','001'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('17','TInvoice','N','发票号','17','002'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('17','TEquipName','N','设备名称','9','003'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('17','TModel','N','机型','10','004'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('17','TProvider','N','供应商','2','005'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('17','TInDate','N','入库日期','3','006'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('17','TOriginalFee','N','原值','13','007'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('17','TQuantityNum','N','数量','12','008'))
	&SQL(Insert Into DHC_EQCColumns(C_TableDR,C_Name,C_HiddenFlag,C_Caption,C_Location,C_Sort) values ('17','TTotalFee','N','总金额','14','009'))
}

/// add by mwz 20220117 mwz0057
/// 更新列定义信息
/// d ##Class(web.DHCEQTest).UpdateColsetTestNew()
ClassMethod UpdateColsetTestNew()
{
	//   0           1              2               3              4            5                 6               7                8           9           10            11               12               13              14                  15          16              17               18          19        20            21                    22            
   ///TRowID_"^"_TEquipDR_"^"_TStoreLocDR_"^"_TFromToLoc_"^"_TSourceID_"^"_TChangeType_"^"_TChangeDate_"^"_TAuditUserDR_"^"_TAuditDate_"^"_TEquip_"^"_TStoreLoc_"^"_TAuditUser_"^"_TChangeTypeDR_"^"_TParSourceID_"^"_TBillChangeDate_"^"_TEquipNo_"^"_TEquipType_"^"_TEquipTypeDR_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TSubChangeTypeDR_"^"_TRequestNo

	&SQL(update  SQLUSER.DHC_EQCColumns set C_Location='10' where C_TableDR='12' and C_Name='TEquip')  
	&SQL(update  SQLUSER.DHC_EQCColumns set C_Location='11' where C_TableDR='12' and C_Name='TStoreLoc') 
	&SQL(update  SQLUSER.DHC_EQCColumns set C_Location='4' where C_TableDR='12' and C_Name='TFromToLoc')  
	&SQL(update  SQLUSER.DHC_EQCColumns set C_Location='6' where C_TableDR='12' and C_Name='TChangeType')  
	&SQL(update  SQLUSER.DHC_EQCColumns set C_Location='7' where C_TableDR='12' and C_Name='TChangeDate')  
	&SQL(update  SQLUSER.DHC_EQCColumns set C_Location='16' where C_TableDR='12' and C_Name='TEquipNo')  
	&SQL(update  SQLUSER.DHC_EQCColumns set C_Location='21' where C_TableDR='12' and C_Name='TOriginalFee')  
	&SQL(update  SQLUSER.DHC_EQCColumns set C_Location='23' where C_TableDR='12' and C_Name='TRequestNo') 
	&SQL(update  SQLUSER.DHC_EQCColumns set C_Location='17' where C_TableDR='12' and C_Name='TEquipType')  
	&SQL(update  SQLUSER.DHC_EQCColumns set C_Location='20' where C_TableDR='12' and C_Name='TModel')  
	&SQL(update  SQLUSER.DHC_EQCColumns set C_Location='15' where C_TableDR='12' and C_Name='TBillChangeDate')
}

/// ////////////////////////////////////////////////////////////
/// Add By CZF 2022-05-07
/// 描述：获取设备附件
/// 接口调用:CALL web.DHCEQTest_GetAffix()
/// 输出结果:
/// d ##class(%ResultSet).RunQuery("web.DHCEQTest","GetAffix")
Query GetAffix() As %Query(ROWSPEC = "TRowID:%String,TAffix:%String,TModel:%String,TManufacturer:%String,TNum:%String,TLeaveFacNo:%String,TLeaveFacDate:%String,TPriceFee:%String,TRemark:%String,TEQName:%String,TEQNo:%String,TEquipType:%String,TStatus:%String,TStoreLoc:%String,TProvider:%String,TAffixNo:%String") [ SqlProc ]
{
}

ClassMethod GetAffixExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetAffix
	Quit $$$OK
BuildDataGetAffix
	s RowID=0
	f  s RowID=$o(^DHCEQAffix(RowID))  quit:RowID=""  d
	.s InvalidFlag=$p($g(^DHCEQAffix(RowID)),"^",15)
	.q:InvalidFlag="Y"
	.d ResetVariablesGetAffix
	.s TRowID=RowID
	.s EQRowID=$p($g(^DHCEQAffix(RowID)),"^",1)
	.s TAffix=$p($g(^DHCEQAffix(TRowID)),"^",4)
	.s TModel=$p($g(^DHCEQAffix(TRowID)),"^",5)
	.s TManufacturer=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQAffix(TRowID)),"^",6))
	.s TAffixNum=$p($g(^DHCEQAffix(TRowID)),"^",7)
	.s TLeaveFacNo=$p($g(^DHCEQAffix(TRowID)),"^",9)
	.s TLeaveFacDate=$p($g(^DHCEQAffix(TRowID)),"^",10)
	.i TLeaveFacDate'="" s TLeaveFacDate=$zd(TLeaveFacDate,3)
	.s TPriceFee=$fn($p($g(^DHCEQAffix(TRowID)),"^",11),"",2)
	.s TRemark=$p($g(^DHCEQAffix(TRowID)),"^",12)
	.s TProvider=$p($g(^DHCEQAffix(TRowID)),"^",25)	;Hold1
	.s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
	.s TCheckListDR=$p($g(^DHCEQAffix(TRowID)),"^",19)
	.i EQRowID'="" d
	..d GetEquipInfo
	.i TCheckListDR'="" d
	..s EQRowID=$Order(^DHCEQEquip(0,"OpenCheckList",TCheckListDR,""))
	..q:EQRowID=""
	..d GetEquipInfo
	/*
	..s EQRowID=0
	..f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",TCheckListDR,EQRowID)) q:EQRowID=""  d
	...q:$D(^DHCEQAffix(0,"OldRowID",EQRowID,TRowID))'=0
	...d GetEquipInfo
	*/
	quit
	
GetEquipInfo
	s TEQNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	q:$p($g(^DHCEQEquip(EQRowID)),"^",59)="Y"
	q:$p($g(^DHCEQEquip(EQRowID)),"^",60)=0
	s TEQName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p($g(^DHCEQEquip(EQRowID)),"^",63))
	s TStatus=$p($g(^DHCEQEquip(EQRowID)),"^",38)
	s TStatus=$case(TStatus,"0":"在库","1":"在用","2":"退货","3":"报废",:"")
	s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(EQRowID)),"^",67))
	f ii=1:1:TAffixNum d
	.s TNum=1
	.s jj=$I(^DHCEQEquip(0,"EquipNo",TEQNo))
	.s TAffixNo=TEQNo_"-"_##class(web.DHCEQCCounter).LPAD(jj,"0",2)
	.d OutputRowGetAffix
	
	quit
OutputRowGetAffix
	s Data=$lb(TRowID,TAffix,TModel,TManufacturer,TNum,TLeaveFacNo,TLeaveFacDate,TPriceFee,TRemark,TEQName,TEQNo,TEquipType,TStatus,TStoreLoc,TProvider,TAffixNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAffix
	s (TRowID,EQRowID,TAffix,TModel,TManufacturer,TNum,TLeaveFacNo,TLeaveFacDate,TPriceFee,TRemark,TCheckListDR,TEQName,TEQNo,TEquipType,TStatus,TStoreLoc,TProvider,TAffixNo)=""
	quit
}

ClassMethod GetAffixFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAffixExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAffixClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAffixExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////
/// Add By CZF 2022-09-18
/// 描述：获取设备电子资料
/// 接口调用:CALL web.DHCEQTest_GetAppendFile()
/// 输出结果:
/// d ##class(%ResultSet).RunQuery("web.DHCEQTest","GetAppendFile")
Query GetAppendFile() As %Query(ROWSPEC = "TRowID:%String,TOriginalType:%String,TOriginalID:%String,TDocName:%String,TFileName:%String,TFileRemark:%String,TAddUser:%String,TAddDate:%String,TAddTime:%String,TUpdUser:%String,TUpdDate:%String,TUpdTime:%String,TInvalidFlag:%String,TEquipNos:%String") [ SqlProc ]
{
}

ClassMethod GetAppendFileExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s RowID=0
	f  s RowID=$o(^DHCEQAppendFile(RowID))  quit:RowID=""  d
	.d ResetVariablesGetAppendFile
	.s TRowID=RowID
	.s TOriginalType=$p($g(^DHCEQAppendFile(RowID)),"^",1)
	.s TOriginalID=$p($g(^DHCEQAppendFile(TRowID)),"^",2)
	.i TOriginalType=4 d
	..s TEquipNos=$p(^DHCEQEquip(TOriginalID),"^",71)
	.i TOriginalType=9 d
	..s TEquipID=""
	..f  s TEquipID=$o(^DHCEQEquip(0,"OpenCheckList",TOriginalID,TEquipID)) q:TEquipID=""  d
	...q:$p($g(^DHCEQEquip(TEquipID)),"^",59)="Y"
	...i TEquipNos'="" s TEquipNos=TEquipNos_","
	...s TEquipNos=TEquipNos_$p(^DHCEQEquip(TEquipID),"^",71)
	.i TOriginalType=10 d
	..s TEquipID=""
	..s TStoreLocDR=""
	..f  s TStoreLocDR=$o(^DHCEQEquip(0,"InStockList",TOriginalID,TStoreLocDR)) q:TStoreLocDR=""  d
	...s TEquipID=""
	...f  s TEquipID=$o(^DHCEQEquip(0,"InStockList",TOriginalID,TStoreLocDR,TEquipID)) q:TEquipID=""  d
	....q:$p($g(^DHCEQEquip(TEquipID)),"^",59)="Y"
	....i TEquipNos'="" s TEquipNos=TEquipNos_","
	....s TEquipNos=TEquipNos_$p(^DHCEQEquip(TEquipID),"^",71)
	.s TDocName=$p($g(^DHCEQAppendFile(TRowID)),"^",3)
	.s TFileName=$p($g(^DHCEQAppendFile(TRowID)),"^",4)
	.s TFileRemark=$p($g(^DHCEQAppendFile(TRowID)),"^",7)
	.s TAddUser=##class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQAppendFile(TRowID)),"^",8))
	.s TAddDate=$p($g(^DHCEQAppendFile(TRowID)),"^",9)
	.i TAddDate'="" s TAddDate=$zd(TAddDate,3)
	.s TAddTime=$p($g(^DHCEQAppendFile(TRowID)),"^",10)
	.i TAddTime'="" s TAddTime=$zt(TAddTime,1)
	.s TUpdUser=##class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQAppendFile(TRowID)),"^",11))
	.s TUpdDate=$p($g(^DHCEQAppendFile(TRowID)),"^",12)
	.i TUpdDate'="" s TUpdDate=$zd(TUpdDate,3)
	.s TUpdTime=$p($g(^DHCEQAppendFile(TRowID)),"^",13)
	.i TUpdTime'="" s TUpdTime=$zt(TUpdTime,1)
	.s TInvalidFlag=$p($g(^DHCEQAppendFile(TRowID)),"^",19)
	.d OutputRowGetAppendFile
	
	Quit $$$OK
OutputRowGetAppendFile
	s Data=$lb(TRowID,TOriginalType,TOriginalID,TDocName,TFileName,TFileRemark,TAddUser,TAddDate,TAddTime,TUpdUser,TUpdDate,TUpdTime,TInvalidFlag,TEquipNos)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAppendFile
	s (TRowID,TOriginalType,TOriginalID,TDocName,TFileName,TFileRemark,TAddUser,TAddDate,TAddTime,TUpdUser,TUpdDate,TUpdTime,TInvalidFlag,TEquipNos)=""
	quit
}

ClassMethod GetAppendFileFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppendFileExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAppendFileClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppendFileExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By CZF 2022-09-24
/// 描述：获取设备验收明细
/// 接口调用:CALL web.DHCEQTest_GetCheckDetail()
/// 输出结果:
/// d ##class(%ResultSet).RunQuery("web.DHCEQTest","GetCheckDetail")
Query GetCheckDetail() As %Query(ROWSPEC = "TRowID:%String,TOpenCheckRequest:%String,TItem:%String,TEquipName:%String,TCode:%String,TUseLoc:%String,TStoreLoc:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TABCType:%String,TModel:%String,TOriginalFee:%String,TQuantity:%String,TUnit:%String,TPurchaseType:%String,TOpenCheckDate:%String,TCheckDate:%String,TCountry:%String,TManuFactory:%String,TProvider:%String,TProviderHandler:%String,TProviderTel:%String,TPurposeType:%String,TOrigin:%String,TFromDept:%String,TBuyType:%String,TLeaveFactoryDate:%String,TLeaveFactoryNo:%String,TWorkLoadPerMon:%String,TDepreMethod:%String,TLimitYearsNum:%String,TService:%String,TLocation:%String,TGuaranteeNum:%String,TContractNo:%String,TRemark:%String,TRegisterNo:%String,TConfigLicense:%String,TNewOldPercent:%String,TPower:%String,TVoltage:%String,TElectriccurrent:%String,TRaditionFlag:%String,TMaintPoint:%String,TNotices:%String,TBuyItemYearFlag:%String,TBuyItemNoName:%String,TBuyItemYear:%String,TBuyItemFee:%String,TPackageState:%String,TConfigState:%String,TFileState:%String,TAffixState:%String,TRunningState:%String,TOpenState:%String,TCheckResult:%String,TCheckUser:%String,TFundsInfo:%String,THold1:%String,THold3:%String") [ SqlProc ]
{
}

ClassMethod GetCheckDetailExecute(ByRef qHandle As %Binary) As %Status
{
	
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQOpenCheckList(rowid))  Quit:rowid=""  Do
	.d BuildDataGetCheckDetail
	Quit $$$OK

BuildDataGetCheckDetail		
	d ResetVariablesGetCheckDetail
	s TRowID = rowid
	s TOpenCheckRequestDR=$p($g(^DHCEQOpenCheckList(rowid)),"^",1)
	q:TOpenCheckRequestDR=""
	s OCRFlag=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",45) //无效
	q:OCRFlag="Y"
	s TStatus=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",20)
	q:TStatus'=0
	s TOpenCheckRequest=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",37)	//验收单号
	s TItemDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",9)
	i TItemDR'="" s TItem =$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)	//设备项
	s TEquipName =$p($g(^DHCEQOpenCheckList(rowid)),"^",2)
	s TCode=$p($g(^DHCEQOpenCheckList(rowid)),"^",8)
	s TUseLocDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",33)
	i TUseLocDR'="" s TUseLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	s TStoreLocDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",31)
	i TStoreLocDR'="" s TStoreLoc =$p($g(^CTLOC(TStoreLocDR)),"^",2)
	s TEquipTypeDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",3)
	i TEquipTypeDR'="" s TEquipType =$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)	//设备类组
	s TStatCatDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",28)
	i TStatCatDR'="" s TStatCat =$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	s TEquipCatDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",6)
	i TEquipCatDR'="" s TEquipCat =$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)	//设备分类
	s TABCType =$p($g(^DHCEQOpenCheckList(rowid)),"^",4)	//ABC分类
	s TModelDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",5)
	i TModelDR'="" s TModel =$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)	//机型
	s TOriginalFee =$p($g(^DHCEQOpenCheckList(rowid)),"^",17)
	s TOriginalFee=$fn(TOriginalFee,"",2)
	s TQuantity =$p($g(^DHCEQOpenCheckList(rowid)),"^",16)
	s TUnitDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",7)		//设备单位
	i TUnitDR'="" s TUnit =$p($g(^CT("UOM",TUnitDR)),"^",2)
	s TPurchaseTypeDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",23)
	i TPurchaseTypeDR'="" s TPurchaseType =$p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)	//申购类别
	s TOpenCheckDate =$p($g(^DHCEQOpenCheckList(rowid)),"^",45)
	s TOpenCheckDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",45),"date")	//开箱日期
	s TCheckDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",46),"date")	//验收日期
	s TCountryDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",11)
	i TCountryDR'="" s TCountry=##class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)	//国别
	s TManuFactoryDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",15)
	i TManuFactoryDR'="" s TManuFactory =$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)	//设备生产厂商
	s TProviderDR=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",5)
	i TProviderDR'="" s TProvider =$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)	//供应商
	s TProviderHandler=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",6)
	s TProviderTel=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",7)
	
	s TPurposeTypeDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",24)
	i TPurposeTypeDR'="" s TPurposeType =$p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)	//用途
	s TOriginDR=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",8)
	i TOriginDR'="" s TOrigin =$p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)	//来源
	s TFromDeptDR=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",9)
	i TFromDeptDR'="" s TFromDept =$p($g(^DHCEQCCode("DHCEQCFromToDept",TFromDeptDR)),"^",2)	//来源部门
	s TBuyTypeDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",13)
	i TBuyTypeDR'="" s TBuyType =$p($g(^DHCEQCCode("DHCEQCBuyType",TBuyTypeDR)),"^",2)		//采购方式
	s TLeaveFactoryDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",49),"date")	//出厂日期
	s TLeaveFactoryNo=$g(^DHCEQOpenCheckList(rowid,"EX"))	//出厂编号
	s TWorkLoadPerMon =$p($g(^DHCEQOpenCheckList(rowid)),"^",65)	//计划工作量
	s TDepreMethodDR = $p($g(^DHCEQOpenCheckList(rowid)),"^",20)
	i TDepreMethodDR'="" s TDepreMethod =$p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)	//折旧方法
	s TLimitYearsNum = $p($g(^DHCEQOpenCheckList(rowid)),"^",19)	//折旧年限
	s TServiceDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",25)
	i TServiceDR'="" s TService =$p($g(^DHCEQCCode("DHCEQCService",TServiceDR)),"^",1)
	;s TServiceHandler =$p($g(^DHCEQOpenCheckList(rowid)),"^",26)
	;s TServiceTel =$p($g(^DHCEQOpenCheckList(rowid)),"^",27)
	s TLocationDR = $p($g(^DHCEQOpenCheckList(rowid)),"^",26)
	i TLocationDR'="" s TLocation =$p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)	//存放地点
	s TGuaranteeNum = $p($g(^DHCEQOpenCheckList(rowid)),"^",27)
	s TContractNo =$p($g(^DHCEQOpenCheckList(rowid)),"^",36)
	s TRemark =$p($g(^DHCEQOpenCheckList(rowid)),"^",34)
	s TRemark=##class(web.DHCEQCommon).Replace(TRemark,$c(13,10),";")
	
	s TManageLocDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",32)
	i TManageLocDR'="" s TManageLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	s TMedicalFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",38)
	s TMeasureFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",39)
	s TTestFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",40)
	s TUrgencyFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",41)
	s TGuaranteeFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",42)
	s TInstallLocDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",47)
	i TInstallLocDR'="" s TInstallLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept" ,TInstallLocDR )
	s TInstallDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",48),"date")
	s THold1 = $p($g(^DHCEQOpenCheckList(rowid)),"^",55)	//发票号	
	s THold2 = $p($g(^DHCEQOpenCheckList(rowid)),"^",56)
	s THold3 = $p($g(^DHCEQOpenCheckList(rowid)),"^",57)	//厂家建议年限
	s THold4 = $p($g(^DHCEQOpenCheckList(rowid)),"^",58)
	s Thold5 = $p($g(^DHCEQOpenCheckList(rowid)),"^",59)
	s TBenefitAnalyFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",60)
	s TCommonageFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",61)
	s TAutoCollectFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",62)
	s SourceType =$p($g(^DHCEQOpenCheckList(rowid)),"^",63)
	s TSourceType=##class(web.DHCEQOpenCheckRequest).GetSourceDesc(SourceType)
	s SourceID =$p($g(^DHCEQOpenCheckList(rowid)),"^",64)
	s TSourceID =##class(web.DHCEQOpenCheckRequest).TranslateSourceID(SourceType,SourceID)
	
	s TRegisterNo=$p($g(^DHCEQOpenCheckList(rowid)),"^",66)		//注册证号
	s TConfigLicense=$p($g(^DHCEQOpenCheckList(rowid)),"^",67)	//配置许可证号
	s TNewOldPercent=$p($g(^DHCEQOpenCheckList(rowid)),"^",68)	//新旧程度
	s TPower=$p($g(^DHCEQOpenCheckList(rowid)),"^",69)		//功率
	s TVoltage=$p($g(^DHCEQOpenCheckList(rowid)),"^",70)	//电压
	s TElectriccurrent=$p($g(^DHCEQOpenCheckList(rowid)),"^",71)	//电流
	s TRaditionFlag=$p($g(^DHCEQOpenCheckList(rowid)),"^",72)		//放射标志
	s TMaintPoint=$p($g(^DHCEQOpenCheckList(rowid,"OtherInfo")),"^",1)		//保养要点
	s TNotices=$p($g(^DHCEQOpenCheckList(rowid,"OtherInfo")),"^",2)			//注意事项
	s BuyItemYearFlag=$p($g(^DHCEQOpenCheckList(rowid,"OtherInfo")),"^",3)	
	s TBuyItemYearFlag=##Class(web.DHCEQCommon).TransValueToPage(BuyItemYearFlag,"bool")	//是否2012年后获得的购置项目
	s TBuyItemNoName=$p($g(^DHCEQOpenCheckList(rowid,"OtherInfo")),"^",4)	//购置项目文件号及名称
	s TBuyItemYear=$p($g(^DHCEQOpenCheckList(rowid,"OtherInfo")),"^",5)		//购置年份
	s TBuyItemFee=$p($g(^DHCEQOpenCheckList(rowid,"OtherInfo")),"^",6)		//购置投入资金
	
	s TPackageState=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",12)	//包装情况
	s TConfigState=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",13)	//配置相符
	s TFileState=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",14)		//随机文件
	s TAffixState=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",15)	//附件信息
	s TRunningState=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",16)	//运行情况
	s TOpenState=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",17)		//开箱情况
	s TCheckResult=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",18)	//验收结果
	s TCheckUser=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",19)		//验收人
	s TFundsInfo=##class(web.DHCEQFunds).GetSourceFundsInfo("0",rowid)		//资金来源信息
	d OutputRowGetCheckDetail
	
	quit
OutputRowGetCheckDetail
	s Data=$lb(TRowID,TOpenCheckRequest,TItem,TEquipName,TCode,TUseLoc,TStoreLoc,TEquipType,TStatCat,TEquipCat,TABCType,TModel,TOriginalFee,TQuantity,TUnit,TPurchaseType,TOpenCheckDate,TCheckDate,TCountry,TManuFactory,TProvider,TProviderHandler,TProviderTel,TPurposeType,TOrigin,TFromDept,TBuyType,TLeaveFactoryDate,TLeaveFactoryNo,TWorkLoadPerMon,TDepreMethod,TLimitYearsNum,TService,TLocation,TGuaranteeNum,TContractNo,TRemark,TRegisterNo,TConfigLicense,TNewOldPercent,TPower,TVoltage,TElectriccurrent,TRaditionFlag,TMaintPoint,TNotices,TBuyItemYearFlag,TBuyItemNoName,TBuyItemYear,TBuyItemFee,TPackageState,TConfigState,TFileState,TAffixState,TRunningState,TOpenState,TCheckResult,TCheckUser,TFundsInfo,THold1,THold3)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCheckDetail
	s (TRowID,TOpenCheckRequest,TItemDR,TItem,TEquipName,TCode,TUseLocDR,TUseLoc,TStoreLocDR,TStoreLoc,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TEquipCatDR,TEquipCat,TABCType,TModelDR,TModel,TOriginalFee,TQuantity,TUnitDR,TUnit,TPurchaseTypeDR,TPurchaseType,TOpenCheckDate,TCheckDate,TCountryDR,TCountry,TManuFactoryDR,TManuFactory,TProviderDR,TProvider,TProviderHandler,TProviderTel)=""
	s (TPurposeTypeDR,TPurposeType,TOriginDR,TOrigin,TFromDeptDR,TFromDept,TBuyTypeDR,TBuyType,TLeaveFactoryDate,TLeaveFactoryNo,TWorkLoadPerMon,TDepreMethodDR,TDepreMethod,TLimitYearsNum,TServiceDR,TService,TLocationDR,TLocation,TGuaranteeNum,TContractNo,TRemark)=""
	s (TManageLocDR,TManageLoc,TMedicalFlag,TMeasureFlag,TTestFlag,TUrgencyFlag,TGuaranteeFlag,TInstallLocDR,TInstallLoc,TInstallDate,THold1,THold2,THold3,THold4,THold5,TBenefitAnalyFlag,TCommonageFlag,TAutoCollectFlag,TSourceType,TSourceID)=""
	s (TRegisterNo,TConfigLicense,TNewOldPercent,TPower,TVoltage,TElectriccurrent,TRaditionFlag,TMaintPoint,TNotices,TBuyItemYearFlag,TBuyItemNoName,TBuyItemYear,TBuyItemFee,TPackageState,TConfigState,TFileState,TAffixState,TRunningState,TOpenState,TCheckResult,TCheckUser,TFundsInfo)=""
	quit
}

ClassMethod GetCheckDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckDetailExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCheckDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by czf 2022-12-02
/// 执行SQL语句
/// d ##Class(web.DHCEQTest).ExecuteSQL()
ClassMethod ExecuteSQL()
{
	k ^DHCEQCCode("DHCEQCBuyMode")
	k ^DHCEQCCode("DHCEQCAuthorizeDept")
	k ^DHCEQCCode("DHCEQCUseSubject")
	k ^DHCEQCCode("DHCEQCRightType")
	k ^DHCEQCCode("DHCEQCUseSubject")
	k ^DHCEQCCode("DHCEQCPurposeType")
	k ^DHCEQCCode("DHCEQCDisuseReason")
	
	&SQL(INSERT INTO SQLUser.DHC_EQCBuyMode (BM_Code, BM_Desc, BM_Remark, BM_InvalidFlag) 
	VALUES ('01', '集中采购', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCBuyMode (BM_Code, BM_Desc, BM_Remark, BM_InvalidFlag)
	VALUES ('02', '分散采购', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCBuyMode (BM_Code, BM_Desc, BM_Remark, BM_InvalidFlag)
	VALUES ('03', '机构集中采购', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCBuyMode (BM_Code, BM_Desc, BM_Remark, BM_InvalidFlag)
	VALUES ('04', '部门集中采购', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCAuthorizeDept (AD_Code, AD_Desc, AD_Remark, AD_InvalidFlag)
	VALUES ('01', '发展改革部门', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCAuthorizeDept (AD_Code, AD_Desc, AD_Remark, AD_InvalidFlag)
	VALUES ('02', '财政部门', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCAuthorizeDept (AD_Code, AD_Desc, AD_Remark, AD_InvalidFlag)
	VALUES ('03', '机关事务主管部门', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCAuthorizeDept (AD_Code, AD_Desc, AD_Remark, AD_InvalidFlag)
	VALUES ('04', '主管部门', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCAuthorizeDept (AD_Code, AD_Desc, AD_Remark, AD_InvalidFlag)
	VALUES ('05', '本单位', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCUseSubject (US_Code, US_Desc, US_Remark, US_InvalidFlag)
	VALUES ('01', '单位', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCUseSubject (US_Code, US_Desc, US_Remark, US_InvalidFlag)
	VALUES ('02', '司（处、科、股）', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCUseSubject (US_Code, US_Desc, US_Remark, US_InvalidFlag)
	VALUES ('03', '人', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCRightType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag)
	VALUES ('1', '出让', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCRightType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag)
	VALUES ('2', '划拨', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCRightType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag)
	VALUES ('3', '租赁', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCRightType (RT_Code, RT_Desc, RT_Remark, RT_InvalidFlag)
	VALUES ('9', '其他', NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('101000', '副部（省）级及以上领导用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('102000', '主要负责人用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('103000', '机要通信用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('104000', '应急保障用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('105001', '一般执法执勤用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('105002', '执法执勤特种专业技术用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('106000', '特种专业技术用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('107000', '离退休干部服务用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('108000', '中管干部用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('109099', '其他用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('205000', '培训', NULL, 'N', '1,2,3,4,5'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('206000', '执法', NULL, 'N', '1,2,3,4,5'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('207000', '窗口', NULL, 'N', '1,2,3,4,5'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('208000', '专用', NULL, 'N', '1,2,3,4,5'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('101000', '副部（省）级及以上领导用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('102000', '主要负责人用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('103000', '机要通信用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('104000', '应急保障用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('105001', '一般执法执勤用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('105002', '执法执勤特种专业技术用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('106000', '特种专业技术用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('107000', '离退休干部服务用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('108000', '中管干部用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('109099', '其他用车', NULL, 'N', '11'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('205000', '培训', NULL, 'N', '1,2,3,4,5'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('206000', '执法', NULL, 'N', '1,2,3,4,5'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('207000', '窗口', NULL, 'N', '1,2,3,4,5'))

	&SQL(INSERT INTO SQLUser.DHC_EQCPurposeType (PT_Code, PT_Desc, PT_Remark, PT_InvalidFlag, PT_StatCatDR)
	VALUES ('208000', '专用', NULL, 'N', '1,2,3,4,5'))
	
	&SQL(INSERT INTO DHC_EQCDisuseReason (DR_Code,DR_Desc,DR_Remark,DR_InvalidFlag) VALUES 
	("1","影响使用安全、无法维修","","N"))

	&SQL(INSERT INTO DHC_EQCDisuseReason (DR_Code,DR_Desc,DR_Remark,DR_InvalidFlag) VALUES 
	("2","性能下降、达不到基本质量要求","","N"))

	&SQL(INSERT INTO DHC_EQCDisuseReason (DR_Code,DR_Desc,DR_Remark,DR_InvalidFlag) VALUES 
	("3","技术落后、技术已淘汰","","N"))

	&SQL(INSERT INTO DHC_EQCDisuseReason (DR_Code,DR_Desc,DR_Remark,DR_InvalidFlag) VALUES 
	("4","维修费用比例过高","","N"))

	&SQL(INSERT INTO DHC_EQCDisuseReason (DR_Code,DR_Desc,DR_Remark,DR_InvalidFlag) VALUES 
	("5","原产品已停产、无零配件供应、且无类似替代品","","N"))

	&SQL(INSERT INTO DHC_EQCDisuseReason (DR_Code,DR_Desc,DR_Remark,DR_InvalidFlag) VALUES 
	("6","使用年限超时","","N"))

	&SQL(INSERT INTO DHC_EQCDisuseReason (DR_Code,DR_Desc,DR_Remark,DR_InvalidFlag) VALUES 
	("7","未达到国家计量标准，又无法矫正修复","","N"))

	&SQL(INSERT INTO DHC_EQCDisuseReason (DR_Code,DR_Desc,DR_Remark,DR_InvalidFlag) VALUES 
	("8","相关试剂耗材无法测证","","N"))

	&SQL(INSERT INTO DHC_EQCDisuseReason (DR_Code,DR_Desc,DR_Remark,DR_InvalidFlag) VALUES 
	("9","国家有关部门公布淘汰、禁止产品","","N"))

	&SQL(INSERT INTO DHC_EQCDisuseReason (DR_Code,DR_Desc,DR_Remark,DR_InvalidFlag) VALUES 
	("10","特殊设备强制报废","","N"))

	&SQL(INSERT INTO DHC_EQCDisuseReason (DR_Code,DR_Desc,DR_Remark,DR_InvalidFlag) VALUES 
	("11","设备残缺不全、或丢失","","N"))
	
	/*
	&SQL(UPDATE SQLUser.DHC_EQCSysSet
	SET SS_Value = '1,2,3,4,5', SS_Desc = '属于房屋建筑物的类型', 
	SS_Remark = '添加类型的ID串，以","分割', SS_DefaultValue = '1,2,3,4,5', SS_UniqueFlag = 'Y' 
	WHERE SS_Code = '401003')

	&SQL(UPDATE SQLUser.DHC_EQCSysSet 
	SET SS_Desc = '属于土地的类型', SS_Remark = '添加类型的ID串，以","分割'
	WHERE SS_Code = '401002')

	&SQL(UPDATE SQLUser.DHC_EQCSysSet 
	SET SS_Desc = '属于交通工具的类型', SS_Remark = '添加类型的ID串，以","分割' 
	WHERE SS_Code = '401005')

	&SQL(UPDATE SQLUser.DHC_EQCSysSet 
	SET SS_Remark = '0:设备项、验收单 1:计划、招标 2:设备项、计划、招标、配件项、验收单' 
	WHERE SS_Code='103001')

	&SQL(UPDATE DHC_EQCSysSet SET SS_Value=NULL,SS_UniqueFlag='Y' WHERE SS_Code=503015)

	&SQL(UPDATE SQLUser.DHC_EQCSysSet SET SS_Value = '0',SS_DefaultValue='0' WHERE SS_Code = '201014')

	&SQL(INSERT INTO DHC_EQCSysSet (SS_Code,SS_Value,SS_Desc,SS_Remark,SS_Hidden) VALUES ('503018','','维修专用类组串','ID串,用逗号分隔','N'))

	&SQL(UPDATE SQLUser.DHC_EQCSysSet SET SS_Value = '6,36,2757' WHERE SS_Code="503015")

	&SQL(INSERT INTO DHC_EQCAction (A_Code,A_Desc,A_SourceType,A_InvalidFlag) VALUES ('WX_Appearance','出现场','25','N'))

	&SQL(INSERT INTO DHC_EQCAction (A_Code,A_Desc,A_SourceType,A_InvalidFlag) VALUES ('WX_LocAudit','科室确认','25','N'))

	&SQL(INSERT INTO DHC_EQCAction (A_Code,A_Desc,A_SourceType,A_InvalidFlag) VALUES ('WX_Retrieve','维修取回','25','N'))

	&SQL(INSERT INTO DHC_EQCAction (A_Code,A_Desc,A_SourceType,A_InvalidFlag) VALUES ('WX_Return','维修归还','25','N'))

	&SQL(INSERT INTO DHC_EQCAction (A_Code,A_Desc,A_SourceType,A_InvalidFlag) VALUES ('WX_ManageLocAudit','管理科室确认','25','N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCBarDetailKey (BDK_Name, BDK_Desc, BDK_Hidden, BDK_Hold1) 
	VALUES ('EQConfigInfo', '附属信息', 'N', '设备'))

	&SQL(INSERT INTO DHC_EQCTableData (TD_Code,TD_Desc,TD_GetDataType,TD_Remark) VALUES ("Department","科室级别树导出","1","科室级别树导出"))

	&SQL(UPDATE SQLUser.DHC_EQCComponentSetItem SET CSI_ItemStyle = 'width:250' WHERE CSI_RowID = 1177)

	&SQL(UPDATE DHC_EQCComponentItem SET CI_ShowInNewWindow='size=verylarge' WHERE CI_ComponentDR->C_Name='EM.G.Inventory.InventoryFind' AND CI_Name='IInventoryNo')

	&SQL(UPDATE DHC_EQCComponentItem SET CI_Description='绑定' WHERE CI_ComponentDR->C_Name='EM.G.Inventory.InventoryException' AND CI_Name='IEBind')

	&SQL(UPDATE DHC_EQCComponentItem SET CI_Description='盘盈' WHERE CI_ComponentDR->C_Name='EM.G.Inventory.InventoryException' AND CI_Name='IEException')

	&SQL(UPDATE DHC_EQCComponentItem SET CI_Description='有报废单' WHERE CI_ComponentDR->C_Name='EM.G.Inventory.InventoryException' AND CI_Name='IEDisuse')

	&SQL(UPDATE DHC_EQCComponentItem SET CI_Description='解绑' WHERE CI_ComponentDR->C_Name='EM.G.Inventory.InventoryException' AND CI_Name='IEUnBind')

	&SQL(UPDATE DHC_EQCComponentSetItem SET CSI_Sort=15 WHERE CSI_ComponentSetDR->CS_ComponentDR->C_Name='EM.G.Inventory.InventoryException' AND CSI_ComponentItemDR->CI_Name in ('IEBind','IEException','IEDisuse','IEUnBind'))

	&SQL(UPDATE DHC_EQCComponentItem SET CI_Caption='设备名称' WHERE CI_ComponentDR->C_Name='EM.G.Inventory.InventoryException' AND CI_Name='IEEquipName')

	&SQL(UPDATE websys.ComponentTableItems SET CaptionStyle=null,Style=null WHERE ParRef=51079)

	&SQL(UPDATE DHC_EQCComponentItem SET CI_Description='一致' WHERE CI_ComponentDR->C_Name='EM.G.Inventory.InventoryPlanList' AND CI_Name='ToConsistent')

	&SQL(UPDATE DHC_EQCComponentItem SET CI_Description='科室不符' WHERE CI_ComponentDR->C_Name='EM.G.Inventory.InventoryPlanList' AND CI_Name='ToUnCheckLoc')

	&SQL(UPDATE DHC_EQCComponentItem SET CI_Description='报废' WHERE CI_ComponentDR->C_Name='EM.G.Inventory.InventoryPlanList' AND CI_Name='ToDisUse')

	&SQL(UPDATE DHC_EQCComponentItem SET CI_Description='盘亏' WHERE CI_ComponentDR->C_Name='EM.G.Inventory.InventoryPlanList' AND CI_Name='ToLoss')

	&SQL(UPDATE DHC_EQCComponentSetItem SET CSI_Sort=16 WHERE CSI_ComponentSetDR->CS_ComponentDR->C_Name='EM.G.Inventory.InventoryPlanList' AND CSI_ComponentItemDR->CI_Name in ('ToConsistent','ToUnCheckLoc','ToDisUse','ToLoss') )

	&SQL(Update DHC_EQCComponentItem Set CI_CaptionStyle=null WHERE CI_ComponentDR->C_Name='CON.G.Contract.ContractDetail' AND CI_Name='TProvider')
	
	&SQL(Update DHC_EQCComponentSetItem Set CSI_ItemStyle=null WHERE CSI_ComponentItemDR->CI_ComponentDR->C_Name='CON.G.Contract.ContractDetail' AND CSI_ComponentItemDR-> CI_Name='TProvider')
	*/
}

/// czf 2023-01-19
/// 设备医保飞行检查数据
/// d ##class(web.LeeClass).GetEquipInfo()
ClassMethod GetEquipInfo()
{
	s rtn=0

	s filename="DHCEQEquipInfo"		/*$p(StartDate,"-",1)_"_"_$p(StartDate,"-",2)_"~"_$p(EndDate,"-",2)*/
	s fileload="D:\"_filename_".csv"
    s file=##class(%File).%New(fileload)
    d file.Open("RWSN")
    //d file.WriteLine("病案关联字段,结算单据号,医疗机构编码,医疗机构名称,医保结算等级,参保地统筹区域编码,参保地统筹区域名称,结算日期,结算年份,结算月份,住院号,个人编码,患者社保卡号,病案号,险种类型,人员类型,入院科别,转科科别,出院科别,主诊医师编码,主诊医师姓名,患者姓名,身份证号,患者性别,患者出生日期,患者年龄,患者所在单位,患者家庭住址,患者床位号,新生儿入院类型,新生儿出生体重,新生儿入院体重,住院医疗类型,异地标志,入院日期,出院日期,住院天数,离院方式,上一次出院日期,是否有31天内再住院计划,医疗总费用,基本统筹支付,大病保险,医疗救助,公务员医疗补助,大额补充,企业补充,个人现金支付,个人账户支付,个人自付,个人自费,符合基本医疗保险的费用,本次进入大病保险范围内金额,起付线金额,甲类使用,乙类使用,丙类使用,超限价自付金额,先行自付金额,自费金额,个人支付比例,统筹支付比例,个人支付床位费,统筹支付床位费,入院诊断编码,入院诊断名称,出院诊断编码,出院诊断名称,床位费,诊察费,检查费,化验费,治疗费,护理费,卫生材料费,西药费,中药饮片费,中成药费,一般诊疗费,挂号费,其他费,医保支付方式,病组病种编码,病组病种名称")
	d file.WriteLine("资产类别,资产编号,资产名称,生产企业,规格/型号,数量,单价,采购金额,启用日期,核销日期,使用状态,存放地点,使用科室,中标号,合同号,出厂日期,合格证号,是否收到发票,对应发票号")
	//d file.WriteLine("BRIDGE_ID,HISID,HOSPITAL_ID,HOSPITAL_NAME,P_LEVEL,BMI_AREA_ID,BMI_AREA_NAME,BILL_DATE,YEAR,MONTH,ZYH,PATIENT_ID,SOCIAL_CARD_ID,MEDICAL_RECORD_ID,BENEFIT_TYPE,BENEFIT_GROUP_ID,ADMISSION_DEPT_NAME,TRANSFER_DEPT_NAME,DISCHARGE_DEPT_NAME,DOCTOR_ID,DOCTOR_NAME,PATIENT_NAME,AAE135,PATIENT_GENDER,PATIENT_BIRTHDAY,PATIENT_AGE,PATIENT_COMPANY,PATIENT_ADDRESS,BEDID,NB_TYPE,NB_BIRTH_WEIGHT,NB_INPATIENT_WEIGHT,CLAIM_TYPE,IF_LOCAL_FLAG,ADMISSION_DATE,DISCHARGE_DATE,ZYTS,DISCHARGE_STATUS,PRE_ADMISSION_DATE,DAYS31_RE_ADMISSION,TOTAL_AMOUNT,BMI_PAY_AMOUNT,DBBX,YLJZ,GWYBZ,DEBC,QYBC,CASH,SELF_PAY_AMOUNT,SELF_PAY_IN,SELF_PAY_OUT,BMI_CONVERED_AMOUNT,DBBX_CONVERED_AMOUNT,QFXJR,JLSY,YLSY,BLSY,CXJZFJE,XXZFJE,ZFJE,GRZFBL,TCZFBL,GRZFCW,TCZFCW,ADMISSION_DISEASE_ID,ADMISSION_DISEASE_NAME,DISCHARGE_DISEASE_ID_MAIN,DISCHARGE_DISEASE_NAME_MAIN,ACCOMMODATION_FEE,DIAGNOSIS_FEE,INSPECTION_FEE,TEST_FEE,TREATMENT_FEE,NURSING_FEE,MATERIAL_FEE,WESTERN_MEDICINE_FEE,CHINESE_MEDICINE_YINPIAN,CHINESE_MEDICINE_FORM,CONSULTATION_FEE,REGISTRATION_FEE,OTHER_FEE,YB_PAY_TYPE,DRGS_CODE,DRGS_NAME")
	d file.WriteLine("ASSET_CLASS,ASSETS_ID,ASSETS_NAME,RECEIVE_MANUFACTURE,RECEIVE_SPEC,ASSETS_NUM,ASSETS_PRICE,ASSETS_COST,START_DATE,WRITE_OFF_DATE,USAGE_STATUS,STORAGE_LOCATION,USING_DEPARTMENT,MEDIUM_MARK_ID,CONTRACT_ ID,DELIVERY_ DATE,CERTIFICATE_ID,INVOICE_RECV_FLAG,INVOICE_ID")
	
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQEquip(EQRowID))  quit:EQRowID=""  d
	.s EQInvalidFlag=$p($g(^DHCEQEquip(EQRowID)),"^",59)
	.q:EQInvalidFlag="Y"
	.s EQStatus=$p($g(^DHCEQEquip(EQRowID)),"^",38)
	.s EQStockStatus=$p($g(^DHCEQEquip(EQRowID)),"^",60)
	.q:EQStockStatus'=1
	.s EquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",$p($g(^DHCEQEquip(EQRowID)),"^",4))
	.s EQNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	.s EQName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	.s Manufactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQEquip(EQRowID)),"^",26))
	.s Model=##Class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(EQRowID)),"^",3))
	.s Quantity=1
	.s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",27),"",2)
	.s PurchaseFee=OriginalFee
	.s StartDate=$p($g(^DHCEQEquip(EQRowID)),"^",44)
	.i StartDate'="" s StartDate=$zd(StartDate,3)
	.s DisuseDate=$p($g(^DHCEQEquip(EQRowID)),"^",89)
	.i DisuseDate'="" s DisuseDate=$zd(DisuseDate,3)
	.s Status="正常"
	.i EQStatus=3 s Status="报废"
	.s Location=##Class(web.DHCEQCommon).GetTrakNameByID("location",$p($g(^DHCEQEquip(EQRowID)),"^",72))
	.s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(EQRowID)),"^",19))
	.s IFBNo=""
	.s ContractNo=$p($g(^DHCEQEquip(EQRowID)),"^",76)
	.s LeaveFactoryDate=$p($g(^DHCEQEquip(EQRowID)),"^",11)
	.i LeaveFactoryDate'="" s LeaveFactoryDate=$zd(LeaveFactoryDate,3)
	.s RegisterNo=$p($g(^DHCEQEquip(EQRowID,"EX")),"^",1)	//器械注冊證號
	.s HasInvoice="是"		
	.s InvoiceNo=""
	.s InStockListDR=$p($g(^DHCEQEquip(EQRowID)),"^",70)
	.s return=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,InStockListDR)
	.s InvoiceNo=$p(return,"^",1)
	.;w EquipCat_"^"_EQNo_"^"_EQName_"^"_Manufactory_"^"_Model_"^"_Quantity_"^"_OriginalFee_"^"_PurchaseFee_"^"_StartDate_"^"_DisuseDate_"^"_Status_"^"_Location_"^"_UseLoc_"^"_IFBNo_"^"_ContractNo_"^"_LeaveFactoryDate_"^"_RegisterNo_"^"_HasInvoice_"^"_InvoiceNo ,!
	.s mList=EquipCat_"^"_EQNo_"^"_EQName_"^"_Manufactory_"^"_Model_"^"_Quantity_"^"_OriginalFee_"^"_PurchaseFee_"^"_StartDate_"^"_DisuseDate_"^"_Status_"^"_Location_"^"_UseLoc_"^"_IFBNo_"^"_ContractNo_"^"_LeaveFactoryDate_"^"_RegisterNo_"^"_HasInvoice_"^"_InvoiceNo
		
	.s mList=$tr(mList,",",".")
	.s mList=$tr(mList,"^",",")
	.s mList=$tr(mList,$c(13))
	.s mList=$tr(mList,$c(10))	
	.d file.WriteLine(mList)
	
    
	k ^TMP("XMLBSum",$j)


	d file.Close()
	q 0
}

/// d ##class(web.DHCEQTest).BakComponent()
ClassMethod BakComponent()
{
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQCServiceItem"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQCResourceType"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQCConsumableItem"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQCServiceConsumable"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQCServDetItem"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQCServiceDetails"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQDeviceMap"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQEquipConsumable"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQEquipOperatorFind"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQEquipServiceFind"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQEquipOperator"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQUseRecord"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQUseRecordList"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQUseConsumableItem"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQUsedResource"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQUseRecordFind"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQUsedResourceFind"),!
	w ##Class(web.DHCEQComponent).BakComponentNew(8,"DHCEQUseConsumableFind")
}

/// d ##class(web.DHCEQTest).BakMenu()
ClassMethod BakMenu()
{
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.H"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.H.StateInfo"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.H.StateInfo.Detail"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.H.StateInfo.Record"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Base"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Base.BenefitEquipList"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Base.DeviceMap"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Base.EquipConsumable"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Base.EquipOperator"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Base.EquipService"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Base.UseConsumableItem"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Base.UsedResource"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Base.UseRecord"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Code"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Code.ConsumableItem"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Code.ImportData"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Code.LISRISDevice"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Code.ResourceType"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Code.ServDetItem"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Code.ServiceDetails"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Code.ServiceItem"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Code.ServiceItemConsumable"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Find"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Find.SummaryFind"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Find.UseConsumableFind"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Find.UsedResourceFind"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Find.UseRecordFind"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Stat"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Stat.BenefitIndex"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Stat.BenefitReportMonth"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Stat.Benifit"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Stat.Cost"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Stat.CVP"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Stat.Decision"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Stat.Dynamic"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.S.Stat.Invest"),!
	w ##Class(web.DHCEQComponent).BakMenu("8","DHCEQBA.ShowList"),!
}

ClassMethod InsertBACharts()
{
	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('LocEquipNums', '效益分析资产数量分布(科室)', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'pie', '科室', '40', '25,50', NULL, 'left', NULL, NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('StatCatEquipAmount', '效益分析资产金额分布(类型)', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'pie', '设备类型', '40', '75,50', NULL, 'left', NULL, '金额(万元)', 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('ItemBenefitInfo', '全院设备综合分析', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '金额(万元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('LocBenefitInfo', '科室效益统计分析', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '金额(万元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('EquipOutFeeInfo', '设备支出统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '金额(万元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('LocPerMonthFacWorkLoad', '科室月工作量统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetLocBenefit', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('LocPerMonthBenefit', '科室月效益统计分析', 'web.DHCEQ.BA.RPTEchart', 'M_GetLocBenefit', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '金额(元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('LocEquipOutFeeInfo', '科室支出项统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetLocBenefit', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '金额(元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('SCEquipOutFeeInfo', '支出项分布', 'web.DHCEQ.BA.RPTEchart', 'M_GetStatCatBenefit', 'pie', '设备类型', '50', '50,50', NULL, 'left', NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('SCPerMonthFacWorkLoad', '科室月工作量统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetStatCatBenefit', 'line', NULL, NULL, NULL, NULL, 'center', NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('SCPerMonthBenefit', '科室月效益统计分析', 'web.DHCEQ.BA.RPTEchart', 'M_GetStatCatBenefit', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '金额(元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('BAEQNumAmount', '效益设备信息', 'web.DHCEQ.BA.RPTEchart', 'GetBenefitAnaly', 'eqblock', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('BAInOutAmount', '收支信息', 'web.DHCEQ.BA.RPTEchart', 'GetBenefitAnaly', 'eqblock', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('BAInOutPerDay', '日均收支', 'web.DHCEQ.BA.RPTEchart', 'GetBenefitAnaly', 'eqblock', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('BAInOutQoQ', '收支环比', 'web.DHCEQ.BA.RPTEchart', 'GetBenefitAnaly', 'eqblock', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('BAInOutYoY', '收支同比', 'web.DHCEQ.BA.RPTEchart', 'GetBenefitAnaly', 'eqblock', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('BACheckPerson', '服务人次', 'web.DHCEQ.BA.RPTEchart', 'GetBenefitAnaly', 'eqblock', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('InComeTypeAnaly', '效益分析收入来源分析', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'pie', '收入来源', '50', '50,50', NULL, 'left', NULL, '金额(万元)', 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('ItemInOutRate', '设备项收支比', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '百分比', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('LocInComeRate', '科室收支比', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '百分比', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('StatCatInOutRate', '设备类型收支比', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '百分比', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('LocOutItemInfo', '科室支出项统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'bar', NULL, NULL, NULL, '科室支出项', 'center', NULL, '金额(万元)', 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('LocInComeQoY', '科室收入同比-环比', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '百分比', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('LocOutFeeQoY', '科室支出同比-环比', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '百分比', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('LocCheckPerson', '科室检查人次', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '人次', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('InComeTypeQoYRate', '收入类型同比-环比', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '百分比', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('ItemCheckPeron', '设备项检查人次', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '人次', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('ItemWorkLoad', '设备项工作量统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('StatCatBenefitInfo', '设备类型效益分析', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '金额(万元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('EQMonthInOut', '设备收支统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '金额(元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('EQMonthWorkLoad', '设备工作量统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('EQMonthCheckPerson', '设备检查人次统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '人次', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('EQMonthExposure', '设备曝光次数', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '次', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('BAEQInOutAmount', '设备收支信息', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'eqblock', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('BAEQCheckPerson', '设备人次信息', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'eqblock', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('BAEQWorkAmount', '设备工作统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'eqblock', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('BAEQCostAmount', '设备成本统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'eqblock', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('BAEQMaintAmount', '设备维保统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'eqblock', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('EQFixedCost', '设备固定成本统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'pie', '支出项', '50', '50,50', NULL, 'left', NULL, NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('EQVariableCost', '设备变动成本统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetEquipBenefit', 'pie', '支出项', '50', '50,50', NULL, 'left', NULL, NULL, 'N'))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('SameEQBAInfo', '同类设备效益信息', 'web.DHCEQ.BA.RPTEchart', 'M_GetSameEQBAChart', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '金额(万元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('SameEQMaintInfo', '同类设备维修信息', 'web.DHCEQ.BA.RPTEchart', 'M_GetSameEQMaintChart', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '次', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('DoctorPositiveRate', '医生开单阳性率', 'web.DHCEQ.BA.RPTEchart', 'M_DoctorPositiveRate', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '阳性率(百分比)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('PatientNum', '日检查人数', 'web.DHCEQ.BA.RPTEchart', 'M_PersonTimes', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '检查人次(位)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('AvgTime', '平均扫描时长', 'web.DHCEQ.BA.RPTEchart', 'M_PersonTimes', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '扫描时长(分)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('LatelyInOut', '近年收益统计', 'web.DHCEQ.BA.RPTEchart', 'M_GetLatelyYearsBA', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '金额(万元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('LatelyInOutYOYRate', '近年收益同比', 'web.DHCEQ.BA.RPTEchart', 'M_GetLatelyYearsBA', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '百分比', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('CompareServiceIncome', '检测收入预测实际对比', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', NULL, NULL, NULL, NULL, NULL, NULL, '金额(元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('CompareMaterialFee', '耗材费预测实际对比', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', NULL, NULL, NULL, NULL, NULL, NULL, '金额(元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('CompareMaintFee', '维修费预测实际对比', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', NULL, NULL, NULL, NULL, NULL, NULL, '金额(元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('CompareFeeOfEmployee', '人员费预测实际对比', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', NULL, NULL, NULL, NULL, NULL, NULL, '金额(元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('SameEQMaintRate', '同类设备维修率', 'web.DHCEQ.BA.RPTEchart', 'M_GetSameEQMaintChart', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '百分比', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('SameEQMaintTimeCost', '同类设备维修时长', 'web.DHCEQ.BA.RPTEchart', 'M_GetSameEQMaintChart', 'line', NULL, NULL, NULL, NULL, NULL, NULL, '时', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('SameEQLocBAInfo', '科室效益信息', 'web.DHCEQ.BA.RPTEchart', 'M_GetSameEQBAChart', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '金额(万元)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('EquipOutFeeQOY', '全院支出项同比-环比', 'web.DHCEQ.BA.RPTEchart', 'M_GetBenefitAnaly', 'line', NULL, NULL, NULL, NULL, 'center', NULL, '百分比', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('LatelyOutFee', '近年总支出分析', 'web.DHCEQ.BA.RPTEchart', 'M_GetLatelyYearsBA', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '金额(万)', NULL))

	&SQL(INSERT INTO SQLUser.DHC_EQCChartsDefine (CD_Code, CD_Desc, CD_WebCls, CD_QueryMethod, CD_SeriesType, CD_SeriesName, CD_SeriesRadius, CD_SeriesCenter, CD_SeriesStack, CD_LegentX, CD_LegentY, CD_Hold1, CD_LegendShow)
	VALUES ('LatelyCheckPerson', '近年服务人次统计分析', 'web.DHCEQ.BA.RPTEchart', 'M_GetLatelyYearsBA', 'bar', NULL, NULL, NULL, NULL, 'center', NULL, '人次', NULL))
}

/// d ##class(web.DHCEQTest).UpdVendorContrast()
ClassMethod UpdVendorContrast()
{
	s vrowid=0
	f  s vrowid=$o(^DHCEQCCode("DHCEQCVendor",vrowid)) q:vrowid=""  d
	.s vType=$p($g(^DHCEQCCode("DHCEQCVendor",vrowid)),"^",22)
	.i vType["2" d
	..s fcrowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",2,vrowid,""))
	..i fcrowid="" d
	...&SQL(INSERT INTO SQLUser.DHC_EQCFirmContrast(FC_FirmType,FC_FirmDR,FC_InvalidFlag) Values('2',:vrowid,'N'))
	.e  i vType["3" d
	..s fcrowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",3,vrowid,""))
	..i fcrowid="" d
	...&SQL(INSERT INTO SQLUser.DHC_EQCFirmContrast(FC_FirmType,FC_FirmDR,FC_InvalidFlag) Values('3',:vrowid,'N'))
	.e  i vType["4" d
	..s fcrowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",4,vrowid,""))
	..i fcrowid="" d
	...&SQL(INSERT INTO SQLUser.DHC_EQCFirmContrast(FC_FirmType,FC_FirmDR,FC_InvalidFlag) Values('4',:vrowid,'N'))
}

}
