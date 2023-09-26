Class web.DHCEQTemplate Extends %RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// add by zy 2017-10-30  ZY0166
/// 获取定义的元素的信息
/// 入参：SourceType	模版类型
/// 	  SourceID		对应类型的业务ID
/// w ##Class(web.DHCEQTemplate).GetTemplate(3,4)
ClassMethod GetTemplate(SourceType, SourceID)
{
	new TemplateName,CurTemplateID,TemplateInfo,TemplateListInfo
	s (TemplateName,CurTemplateID,ApproveSet)=""
	i SourceType=3
	{
		s YearFlag=$Piece(^DHCEQBuyRequest(SourceID),"^",3)
		s MaxPrice=$Piece(^DHCEQBuyRequest(SourceID),"^",9)
		s BussStatus=$Piece($G(^DHCEQBuyRequest(SourceID)),"^",16)
	 	s EquipType=$Piece(^DHCEQBuyRequest(SourceID),"^",25)
		s PurchaseTypeCode=$Piece(^DHCEQBuyRequest(SourceID),"^",26)
		
		s ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
		s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseTypeCode, "", MaxPrice, YearFlag, "")
		
		i PurchaseTypeCode'="" s PurchaseTypeCode=$Piece($Get(^DHCEQCCode("DHCEQCPurchaseType",PurchaseTypeCode)),"^",1)
		s TemplateName="91-"_PurchaseTypeCode
	}
	i TemplateName="" q "-1000"
	
	//取模版信息
	//^DHCEQCCode("DHCEQCTemplate",0,"TypeName",3,"91-01",1)
	s FindTemplateID=0
	s TemplateID=0
	f  s TemplateID=$o(^DHCEQCCode("DHCEQCTemplate",0,"TypeName",SourceType,TemplateName,TemplateID))  q:(TemplateID="")||(FindTemplateID'=0)  d
	.q:$Piece($Get(^DHCEQCCode("DHCEQCTemplate",TemplateID)),"^",8)="Y"
	.s FindTemplateID=TemplateID
	i FindTemplateID=0 q "-1001"	//没有定义模版
	
	s FindCurTemplateID=0
	s CurTemplateID=0
	f  s CurTemplateID=$o(^DHCEQTemplate(0,"TypeSourceID",SourceType,SourceID,CurTemplateID))  q:(CurTemplateID="")||(FindCurTemplateID'=0)  d
	.q:$Piece($Get(^DHCEQTemplate(CurTemplateID)),"^",9)="Y"
	.s FindCurTemplateID=CurTemplateID
	s TemplateInfo=""
	i FindCurTemplateID>0
	{
		s TemplateData=$Get(^DHCEQCCode("DHCEQCTemplate",FindTemplateID))
		s CurTemplateData=$Get(^DHCEQTemplate(FindCurTemplateID))
		s TemplateInfo=FindCurTemplateID
		s TemplateInfo=TemplateInfo_"^"_$p(CurTemplateData,"^",3)	//ItemDR
		s TemplateInfo=TemplateInfo_"^"_$p(CurTemplateData,"^",4)	//EquipDR
		s TemplateInfo=TemplateInfo_"^"_$p(CurTemplateData,"^",5)	//Name
		s TemplateInfo=TemplateInfo_"^"_$p(CurTemplateData,"^",6)	//Caption
		s TemplateInfo=TemplateInfo_"^"_$p(CurTemplateData,"^",7)	//Note
		s TemplateInfo=TemplateInfo_"^"_$p(CurTemplateData,"^",8)	//Remark
		s TemplateInfo=TemplateInfo_"^"_$p(CurTemplateData,"^",9)	//InvalidFlag
		s TemplateInfo=TemplateInfo_"^"_$p(CurTemplateData,"^",10)	//Hold1
		s TemplateInfo=TemplateInfo_"^"_$p(CurTemplateData,"^",11)	//Hold2
		s TemplateInfo=TemplateInfo_"^"_$p(CurTemplateData,"^",12)	//Hold3
	}
	else
	{
		s TemplateInfo="^^^^^^^^^^"
	}
	
	//取模版明细记录
	s TemplateListInfo=""
	s Sort=""
	f  s Sort=$o(^DHCEQCCode("DHCEQCTemplateList",0,"TemplateDR",FindTemplateID,Sort))  q:Sort=""  d
	.s TemplateListID=0
	.f  s TemplateListID=$o(^DHCEQCCode("DHCEQCTemplateList",0,"TemplateDR",FindTemplateID,Sort,TemplateListID))  q:TemplateListID=""  d
	..s TemplateListData=TemplateListID_"^"_$Get(^DHCEQCCode("DHCEQCTemplateList",TemplateListID))
	..s ElementID=$p(TemplateListData,"^",3)
	..q:($p($G(^DHCEQCCode("DHCEQCElement",ElementID)),"^",11)="Y")
	..
	..s RoleReqElementInfo=##Class(web.DHCEQTemplate).RoleReqElement(ElementID,ApproveSet)
	..q:(BussStatus=0)&&($p(RoleReqElementInfo,"^",1)=1)
	..s MustFlag=$p(RoleReqElementInfo,"^",2)
	..s ApproveRoleDR=$p(RoleReqElementInfo,"^",3)
	..s Action=$p(RoleReqElementInfo,"^",4)
	..s TemplateListData=TemplateListData_"^"_MustFlag_"^"_ApproveRoleDR_"^"_Action
	..i TemplateListInfo="" d
	...s TemplateListInfo=TemplateListData
	..e  d
	...s TemplateListInfo=TemplateListInfo_"&"_TemplateListData
	
	q TemplateInfo_"@"_TemplateListInfo
}

/// add by zy 2017-11-08
/// 查看当前元素是否在审批设置中设置了可编辑信息,是否必填,及编辑的角色
/// 入参：ElementID  元素ID
///      ApproveSetID  当前业务对应的审批设置ID
/// 返回值   NeedFlag_"^"_MustFlag_"^"_ApproveRoleDR
/// 		 NeedFlag  0  ：没有在审批设置中  1 ：在审批设置中
/// 		 MustFlag  0  ：非必填  1 ：必填
/// 		 ApproveRoleDR  该元素的审批角色
/// 		 Action  该元素的审批动作
/// 		 LastFlag  当前步骤是否是最后一步
/// w ##Class(web.DHCEQTemplate).RoleReqElement(60,2,39)
ClassMethod RoleReqElement(ElementID, ApproveSetID, ActionCode As %Library.String = "")
{
	s (NeedFlag,MustFlag)=0
	s (ApproveRoleDR,Action,LastFlag)=""
	s FlowDR=0
	f  s FlowDR=$O(^DHCEQCCode("DHCEQCRoleReqElement",0,"ElementFlow",ElementID,FlowDR)) Quit:FlowDR=""  d
	.s ApproveSetDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",FlowDR)),"^",1)
	.q:(ApproveSetID'=ApproveSetDR)
	.s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",FlowDR)),"^",2)
	.s ActionDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",FlowDR)),"^",9)
	.;q:(ActionCode'="")&&(ActionCode'=ActionDR)
	.s LastFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",FlowDR)),"^",4)
	.i ActionDR'="" s Action=$p($g(^DHCEQCCode("DHCEQCAction",ActionDR)),"^",1)
	.q:(ActionCode'="")&&(ActionCode'=Action)
	.s RRERowID=$O(^DHCEQCCode("DHCEQCRoleReqElement",0,"ElementFlow",ElementID,FlowDR,0))
	.i RRERowID'=""  d
	..s NeedFlag=1
	..s MustFlag=$p($g(^DHCEQCCode("DHCEQCRoleReqElement",RRERowID)),"^",3)
	q NeedFlag_"^"_MustFlag_"^"_ApproveRoleDR_"^"_Action_"^"_LastFlag
}

/// add by zy 2017-10-30  ZY0166
/// 获取定义的元素的信息
/// 入参：RowID	元素表ID
/// 	 CurTemplateID  如果该模版信息保存过，在模版业务表中的id
/// 
/// w ##Class(web.DHCEQTemplate).GetElement(28,1)
ClassMethod GetElement(RowID, CurTemplateID As %Library.String = "")
{
	new result,resultex,CurElementID
	Set (result,resultex,CurElementID)=""
	Set result=$Get(^DHCEQCCode("DHCEQCElement",RowID))
	
	Set resultex=resultex_"^"	;ElementCatDR
	If $Piece(result,"^",1)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCElementCat",$Piece(result,"^",1))),"^",2)
	
	Set resultex=resultex_"^"	;GroupDR
	If $Piece(result,"^",9)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCElementGroup",$Piece(result,"^",9))),"^",2)
	
	s result=result_resultex_"^"
	//12个节点
	//取当前元素的在当前业务模版中存的信息  18个节点
	s CurElementInfo=""
	i CurTemplateID'=""
	{
		s CurElementID=$o(^DHCEQTemplateList(0,"TemplateElement",CurTemplateID,RowID,0))
		i CurElementID'=""  d
		.s CurElementInfo=CurElementID_"^"_$Get(^DHCEQTemplateList(CurElementID))
		.
		.s $P(CurElementInfo,"^",9)=##Class(web.DHCEQCommon).TransValueToPage($Piece(CurElementInfo,"^",9),"bool")	;NormalFlag
		.s CurElementInfo=CurElementInfo_"^"	;UpdateDR
		.i $P(CurElementInfo,"^",12)'=""  Do
		..s CurElementInfo=CurElementInfo_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(CurElementInfo,"^",12))
		.s $P(CurElementInfo,"^",13)=##Class(web.DHCEQCommon).TransValueToPage($Piece(CurElementInfo,"^",13),"date")	;UpdateDate
		.s $P(CurElementInfo,"^",14)=##Class(web.DHCEQCommon).TransValueToPage($Piece(CurElementInfo,"^",14),"time")	;UpdateTime
		e  d
		.s CurElementInfo="^^^^^^^^^^^^^^^^^"
	}
	else
	{
		s CurElementInfo="^^^^^^^^^^^^^^^^^"
	}
	s result=result_CurElementInfo
	
	s ElementValues=""
	if ($D(^DHCEQCCode("DHCEQCElementValues",0,"ElementDR",RowID)))
	{
		//^DHCEQCCode("DHCEQCElementValues",0,"ElementDR",28
		s EVRowID=0
		f  s EVRowID=$o(^DHCEQCCode("DHCEQCElementValues",0,"ElementDR",RowID,EVRowID)) q:EVRowID=""  d
		.s DataList=$g(^DHCEQCCode("DHCEQCElementValues",EVRowID))
		.q:$p(DataList,"^",5)="Y"
		.//s DefaultFlag=0
		.//i $p(CurElementInfo,"^",7)=EVRowID  s DefaultFlag=1
		.i ElementValues="" d
		..s ElementValues=EVRowID_":"_$p(DataList,"^",2)_":"_$p(DataList,"^",3)_":"_$p(DataList,"^",4)
		.e  d
		..
		..s ElementValues=ElementValues_"&"_EVRowID_":"_$p(DataList,"^",2)_":"_$p(DataList,"^",3)_":"_$p(DataList,"^",4)
	}
	s result=result_"^"_ElementValues
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Quit result
}

/// 
/// w ##Class(web.DHCEQTemplate).SaveData("1^1^^^ceshi^^^^^^^","^2^&^3^&^4^&^5^&^6^&^7^&^8^&^9^&^10^&^11^&^12^&^13^&^14^&^15^&^16^设备拟购置区域","0")
ClassMethod SaveData(val, valList, DelIs)
{
	new RowID,InvalidFlag,SQLCODE
	k PLIST
	Set $ZT="ERRORSave"
	s RowID=$P(val,"^",1)
	TSTART	
	if (DelIs=1)
	{
		s PLIST(10) = "Y"	;InvalidFlag
		&SQL(update sqluser.DHC_EQTemplate values :PLIST() where T_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	else
	{
		if RowID'=""
		{
			s InvalidFlag=$p($g(^DHCEQTemplate(RowID)),"^",9)
			i InvalidFlag="Y" q -1015
		}
		s PLIST(2) = $p(val,"^",2)	;Type
	 	s PLIST(3) = $p(val,"^",3)	;SourceID
	 	s PLIST(4) = $p(val,"^",4)	;ItemDR
	 	s PLIST(5) = $p(val,"^",5)	;EquipDR
	 	s PLIST(6) = $p(val,"^",6)	;Name
	 	s PLIST(7) = $p(val,"^",7)	;Caption
	 	s PLIST(8) = $p(val,"^",8)	;Note
	 	s PLIST(9) = $p(val,"^",9)	;Remark
	 	s PLIST(10) = "N"	;InvalidFlag
	 	s PLIST(11) = $p(val,"^",11)	;Hold1
	 	s PLIST(12) = $p(val,"^",12)	;Hold2
	 	s PLIST(13) = $p(val,"^",13)	;Hold3
	 	if RowID=""
	 	{
			&SQL(insert into sqluser.DHC_EQTemplate values :PLIST())
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
			s RowID=$G(%ROWID)
	 	}
	 	else
	 	{
			&SQL(update sqluser.DHC_EQTemplate values :PLIST() where T_RowID=:RowID)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
	 	}
	 	s SQLCODE=..SaveTemplateList(RowID,valList)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORSave 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQTemplate).SaveTemplateList("65","1^100^10403&1^100^10403")
ClassMethod SaveTemplateList(TemplateID, val)
{
	new Length,TLRowID,Flag,i,User,Date,Time,valList
	//k PLISTMX
	s User=1	//%session.Get("LOGON.USERID")
	s Date=+$H
	s Time=$P($H,",",2)
	i val="" q 0
	i TemplateID="" q -1
	
	//s PLISTMX(2)=TemplateID  				;TL_TemplateDR
	s Length=$l(val,"&")
	
	s Flag=0
	for i=1:1:Length
	{
		k PLISTMX
		q:Flag'=0
		s valList=	$p(val,"&",i)
		s TLRowID= $p(valList,"^",1)
		s PLISTMX(2)=TemplateID  				;TL_TemplateDR
		s PLISTMX(3)=$p(valList,"^",2)  	;ElementDR
		;s PLISTMX(4)=$p(valList,"^",3)		;SettingValue
		;s PLISTMX(5)=$p(valList,"^",4)		;Key
		;s PLISTMX(6)=$p(valList,"^",5)  	;Times
		i ($p(^DHCEQCCode("DHCEQCElement",$p(valList,"^",2)),"^",4)'="4")  d 
		.s PLISTMX(7)=$p(valList,"^",3)  	;Result
		;s PLISTMX(8)=$p(valList,"^",7)  	;Note
		;s PLISTMX(9)=$p(valList,"^",8)  	;NormalFlag
		;s PLISTMX(10)=$p(valList,"^",9)  	;Remark
		;s PLISTMX(11)=$p(valList,"^",10)  	;Sort
		s PLISTMX(12)=User  	;UpdateUserDR
		s PLISTMX(13)=Date  	;UpdateDate
		s PLISTMX(14)=Time  	;UpdateTime
		;s PLISTMX(15)=$p(valList,"^",10)  	;Hold1
		;s PLISTMX(16)=$p(valList,"^",10)  	;Hold2
		;s PLISTMX(17)=$p(valList,"^",10)  	;Hold3
		if (TLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQTemplateList Values :PLISTMX())
			s TLRowID=$G(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQTemplateList values :PLISTMX() where TL_RowID=:TLRowID)
		}
		i SQLCODE
 		{
			s Flag=SQLCODE
 		}
 		q:Flag'=0
		
	}
	q Flag
}

/// add by zy 2017-12-21 
/// 判断是否填写完毕
/// 入参：SourceType	模版类型
/// 	  SourceID		对应类型的业务ID
/// w ##Class(web.DHCEQTemplate).CheckTemplate(3,5,"SQ_Opinion10")
ClassMethod CheckTemplate(SourceType, SourceID, ActionCode)
{
	new TemplateName,CurTemplateID,TemplateInfo,TemplateListInfo
	s (TemplateName,CurTemplateID,ApproveSet)=""
	i SourceType=3
	{
		s YearFlag=$Piece(^DHCEQBuyRequest(SourceID),"^",3)
		s MaxPrice=$Piece(^DHCEQBuyRequest(SourceID),"^",9)
		s BussStatus=$Piece($G(^DHCEQBuyRequest(SourceID)),"^",16)
	 	s EquipType=$Piece(^DHCEQBuyRequest(SourceID),"^",25)
		s PurchaseTypeCode=$Piece(^DHCEQBuyRequest(SourceID),"^",26)
		
		s ApproveType=##class(web.DHCEQApproveList).GetApproveType("1")
		s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseTypeCode, "", MaxPrice, YearFlag, "")
		
		i PurchaseTypeCode'="" s PurchaseTypeCode=$Piece($Get(^DHCEQCCode("DHCEQCPurchaseType",PurchaseTypeCode)),"^",1)
		s TemplateName="91-"_PurchaseTypeCode
	}
	i TemplateName="" q "没有定义模版"
	
	//取模版信息
	//^DHCEQCCode("DHCEQCTemplate",0,"TypeName",3,"91-01",1)
	s FindTemplateID=0
	s TemplateID=0
	f  s TemplateID=$o(^DHCEQCCode("DHCEQCTemplate",0,"TypeName",SourceType,TemplateName,TemplateID))  q:(TemplateID="")||(FindTemplateID'=0)  d
	.q:$Piece($Get(^DHCEQCCode("DHCEQCTemplate",TemplateID)),"^",8)="Y"
	.s FindTemplateID=TemplateID
	i FindTemplateID=0 q "没有定义模版"	//没有定义模版
	
	s FindCurTemplateID=0
	s CurTemplateID=0
	f  s CurTemplateID=$o(^DHCEQTemplate(0,"TypeSourceID",SourceType,SourceID,CurTemplateID))  q:(CurTemplateID="")||(FindCurTemplateID'=0)  d
	.q:$Piece($Get(^DHCEQTemplate(CurTemplateID)),"^",9)="Y"
	.s FindCurTemplateID=CurTemplateID
	i FindCurTemplateID=0 q "//没有填写论证模版信息"	//没有填写论证模版信息
	
	//取模版明细记录
	s FindNoFlag=0
	s TemplateListInfo=""
	s Sort=""
	f  s Sort=$o(^DHCEQCCode("DHCEQCTemplateList",0,"TemplateDR",FindTemplateID,Sort))  q:(Sort="")||(FindNoFlag'=0)  d
	.s TemplateListID=0
	.f  s TemplateListID=$o(^DHCEQCCode("DHCEQCTemplateList",0,"TemplateDR",FindTemplateID,Sort,TemplateListID))  q:(TemplateListID="")||(FindNoFlag'=0)  d
	..s TemplateListData=$Get(^DHCEQCCode("DHCEQCTemplateList",TemplateListID))
	..s ElementID=$p(TemplateListData,"^",2)
	..s Element=$p($G(^DHCEQCCode("DHCEQCElement",ElementID)),"^",2)
	..q:($p($G(^DHCEQCCode("DHCEQCElement",ElementID)),"^",11)="Y")
	..s RoleReqElementInfo=##Class(web.DHCEQTemplate).RoleReqElement(ElementID,ApproveSet,ActionCode)
	..q:($p(RoleReqElementInfo,"^",5)'="Y")&&(BussStatus=0)&&($p(RoleReqElementInfo,"^",1)=1)
	..q:($p(RoleReqElementInfo,"^",5)'="Y")&&(BussStatus=1)&&($p(RoleReqElementInfo,"^",1)=0)
	..
	..s CurTemplateListID=$o(^DHCEQTemplateList(0,"TemplateElement",FindCurTemplateID,ElementID,0))
	..i CurTemplateListID=""  s FindNoFlag=""""_Element_"""没有填写,请查看论证表信息!"
	..q:FindNoFlag'="0"
	..s Result=$p($Get(^DHCEQTemplateList(CurTemplateListID)),"^",6)
	..i Result="" s FindNoFlag=""""_Element_"""是必填项,请完成填写!"
	
	q FindNoFlag
}

/// w ##Class(web.DHCEQTemplate).GetOneTemplate(3,6)
ClassMethod GetOneTemplate(SourceType, SourceID)
{
	new FindTemplateID,TemplateID,TemplateListID,result,TElementID,TReslut
	s result=""
	s FindTemplateID=0
	s TemplateID=0
	f  s TemplateID=$o(^DHCEQTemplate(0,"TypeSourceID",SourceType,SourceID,TemplateID))  q:(TemplateID="")||(FindTemplateID'=0)  d
	.q:$Piece($Get(^DHCEQTemplate(TemplateID)),"^",9)="Y"
	.s FindTemplateID=TemplateID
	
	s TemplateListID=0
	f  s TemplateListID=$o(^DHCEQTemplateList(0,"TemplateDR",FindTemplateID,TemplateListID))  q:(TemplateListID="")  d
	.s TElementID=$P($G(^DHCEQTemplateList(TemplateListID)),"^",2)
	.s TReslut=$P($G(^DHCEQTemplateList(TemplateListID)),"^",6)
		.//淘汰设备信息
	.i TElementID=10 d
	..s TReslut=TReslut_"="
	..s rowid=0
	..f  s rowid=$o(^DHCEQEliminateList(0,"Source",1,SourceID,rowid)) q:rowid=""  d
	...s DataList=$g(^DHCEQEliminateList(rowid))
	...s TEquipID=$P(DataList,"^",3)
	...s TEquipNo=$P($Get(^DHCEQEquip(TEquipID)),"^",71)
	...s TTransAssetDate=$P($Get(^DHCEQEquip(TEquipID)),"^",45)
	...s TTransAssetDate=##class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
	...s TPreWorkLoad=$P(DataList,"^",4)
	...s TPositiveRate=$P(DataList,"^",5)
	...s TReslut=TReslut_"@"_TEquipNo_"&"_TTransAssetDate_"&"_TPreWorkLoad_"&"_TPositiveRate
	.//治疗项目信息
	.i TElementID=23 d
	..s TReslut=TReslut_"="
	..s rowid=0
	..f  s rowid=$o(^DHCEQBillItem(0,"Source",1,SourceID,rowid)) q:rowid=""  d
	...s DataList=$g(^DHCEQBillItem(rowid))
	...s TDesc=$P(DataList,"^",4)
	...s TPrice=$P(DataList,"^",5)
	...s TCost=$P(DataList,"^",6)
	...s TWorkLoadNum=$P(DataList,"^",7)
	...s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TWorkLoadNum*(TPrice-TCost))
	...s TReslut=TReslut_"@"_TDesc_"&"_TPrice_"&"_TWorkLoadNum_"&"_TTotalFee
	.//耗材项目信息
	.e  i TElementID=25 d
	..s TReslut=TReslut_"="
	..s rowid=0
	..f  s rowid=$o(^DHCEQConsumableItemInfo(0,"Scource",1,SourceID,rowid)) q:rowid=""  d
	...s DataList=$g(^DHCEQConsumableItemInfo(rowid))
	...q:($P(DataList,"^",16)="Y")
	...s TDesc=$P(DataList,"^",4)
	...s TPrice=$P(DataList,"^",7)
	...s TPreWorkLoad=$P(DataList,"^",13)
	...s TAdditionRate=$P(DataList,"^",14)
	...s TTotalFee=$P(DataList,"^",17)
	...s TReslut=TReslut_"@"_TDesc_"&"_TPrice_"&"_TPreWorkLoad_"&"_TAdditionRate_"&"_TTotalFee
	.
	.//推荐供应商信息
	.e  i TElementID=30 d
	..s TReslut=TReslut_"="
	..s rowid=0
	..f  s rowid=$o(^DHCEQIFBList(0,"Source",1,SourceID,rowid)) q:rowid=""  d
	...s DataList=$g(^DHCEQIFBList(rowid))
	...s TVendor=$Piece(DataList,"^",3)
	...s TBrand=$Piece(DataList,"^",9)
	...s TProviderHandler=$P(DataList,"^",20)
	...s TProviderTel=$P(DataList,"^",21)
	...s TReslut=TReslut_"@"_TVendor_"&"_TBrand_"&"_TProviderHandler_"&"_TProviderTel
	.
	.i result="" d
	..s result=TElementID_"="_TReslut
	.e  d
	..s result=result_"^"_TElementID_"="_TReslut
	
	q result
}

/// w ##Class(web.DHCEQTemplate).BakGof()
ClassMethod BakGof()
{
	m ^DHCEQYYCode("DHCEQCRoleReqElement")=^DHCEQCCode("DHCEQCRoleReqElement")
	m ^DHCEQYYCode("DHCEQCElementCat")=^DHCEQCCode("DHCEQCElementCat")
	m ^DHCEQYYCode("DHCEQCElement")=^DHCEQCCode("DHCEQCElement")
	m ^DHCEQYYCode("DHCEQCElementGroup")=^DHCEQCCode("DHCEQCElementGroup")
	m ^DHCEQYYCode("DHCEQCElementValues")=^DHCEQCCode("DHCEQCElementValues")
	//m ^DHCEQYYCode("DHCEQCNormalValues")=^DHCEQCCode("DHCEQCNormalValues")
	m ^DHCEQYYCode("DHCEQCFactor")=^DHCEQCCode("DHCEQCFactor")
	m ^DHCEQYYCode("DHCEQCTemplate")=^DHCEQCCode("DHCEQCTemplate")
	m ^DHCEQYYCode("DHCEQCTemplateList")=^DHCEQCCode("DHCEQCTemplateList")
}

/// w ##Class(web.DHCEQTemplate).GetTemplateID(3,6)
ClassMethod GetTemplateID(SourceType, SourceID)
{
	new FindTemplateID,TemplateID
	s FindTemplateID=""
	s TemplateID=0
	f  s TemplateID=$o(^DHCEQTemplate(0,"TypeSourceID",SourceType,SourceID,TemplateID))  q:(TemplateID="")||(FindTemplateID'="")  d
	.q:$Piece($Get(^DHCEQTemplate(TemplateID)),"^",9)="Y"
	.s FindTemplateID=TemplateID
	q FindTemplateID
}

/// w ##Class(web.DHCEQTemplate).UpdateGof()
ClassMethod UpdateGof()
{
	k ^DHCEQCCode("DHCEQCRoleReqElement")
	k ^DHCEQCCode("DHCEQCElementCat")
	k ^DHCEQCCode("DHCEQCElement")
	k ^DHCEQCCode("DHCEQCElementGroup")
	k ^DHCEQCCode("DHCEQCElementValues")
	k ^DHCEQCCode("DHCEQCFactor")
	k ^DHCEQCCode("DHCEQCTemplate")
	k ^DHCEQCCode("DHCEQCTemplateList")
	
	m ^DHCEQCCode("DHCEQCRoleReqElement")=^DHCEQYYCode("DHCEQCRoleReqElement")
	m ^DHCEQCCode("DHCEQCElementCat")=^DHCEQYYCode("DHCEQCElementCat")
	m ^DHCEQCCode("DHCEQCElement")=^DHCEQYYCode("DHCEQCElement")
	m ^DHCEQCCode("DHCEQCElementGroup")=^DHCEQYYCode("DHCEQCElementGroup")
	m ^DHCEQCCode("DHCEQCElementValues")=^DHCEQYYCode("DHCEQCElementValues")
	//m ^DHCEQCCode("DHCEQCNormalValues")=^DHCEQYYCode("DHCEQCNormalValues")
	m ^DHCEQCCode("DHCEQCFactor")=^DHCEQYYCode("DHCEQCFactor")
	m ^DHCEQCCode("DHCEQCTemplate")=^DHCEQYYCode("DHCEQCTemplate")
	m ^DHCEQCCode("DHCEQCTemplateList")=^DHCEQYYCode("DHCEQCTemplateList")
	k ^DHCEQYYCode
}

}
