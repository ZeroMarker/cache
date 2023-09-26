Class web.DHCEQ.EM.BUSBatchDisuseRequest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// ----------------------------------
/// 修改：zy 2009-08-17  No ZY0009
/// 描述：根据报废设备的状态显示报废信息
/// 访问表:DHC_EQDisuseRequest
/// ----------------------------------
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSBatchDisuseRequest","GetDisuseRequest","^ReplacesAD=^ApproveRole=^Type=^StatusDR=1^Status=^EquipDR=^RequestLocDR=^EquipTypeDR=^PurchaseTypeDR=^StartDate=^EndDate=^WaitAD=^QXType=^Name=^UseLocDR=^RequestNo=^EquipName=^MinValue=^MaxValue=^StartInDate=^EndInDate=^EquipNo=^MergeOrderFlag=Y")
Query GetDisuseRequest(VData As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TGroupDR:%String,TRequestLocDR:%String,TRequestDate:%String,TUseState:%String,TDisuseTypeDR:%String,TChangeReason:%String,TDisureDate:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TRejectReason:%String,TRejectUserDR:%String,TRejectDate:%String,TRejectTime:%String,TApproveSetDR:%String,TNextRoleDR:%String,TNextFlowStep:%String,TApproveStatu:%String,TApproveRoleDR:%String,THold1:%String,TRequestNo:%String,TEquip:%String,TGroup:%String,TRequestLoc:%String,TDisuseType:%String,TAddUser:%String,TUpdateUser:%String,TSubmitUser:%String,TAuditUser:%String,TRejectUser:%String,TApproveSet:%String,TNextRole:%String,TApproveRole:%String,TModelDR:%String,TModel:%String,TManuFactoryDR:%String,TManuFactory:%String,TEquipTypeDR:%String,TEquipType:%String,TPurchaseTypeDR:%String,TPurchaseType:%String,TPrice:%String,TKindFlag:%String,TNo:%String,TUseLoc:%String,TKindFlagDesc:%String,TRow:%String,TQuantity:%String,TTotalFee:%String,TUnit:%String")
{
}

ClassMethod GetDisuseRequestExecute(ByRef qHandle As %Binary, VData As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	/**************************************************/
	Set VData=##Class(web.DHCEQCommon).UnEscape(VData)
	Set ReplacesAD=##Class(web.DHCEQCommon).GetDataByName(VData,"ReplacesAD")
	Set ApproveRole=##Class(web.DHCEQCommon).GetDataByName(VData,"ApproveRole")
	Set Type=##Class(web.DHCEQCommon).GetDataByName(VData,"Type")
	Set StatusDR=##Class(web.DHCEQCommon).GetDataByName(VData,"StatusDR")
	Set EquipDR=##Class(web.DHCEQCommon).GetDataByName(VData,"EquipDR")
	Set RequestLocDR=##Class(web.DHCEQCommon).GetDataByName(VData,"RequestLocDR")
	Set EquipTypeDR=##Class(web.DHCEQCommon).GetDataByName(VData,"EquipTypeDR")
	Set PurchaseTypeDR=##Class(web.DHCEQCommon).GetDataByName(VData,"PurchaseTypeDR")
	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(VData,"StartDate")
	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(VData,"EndDate")
	Set WaitAD=##Class(web.DHCEQCommon).GetDataByName(VData,"WaitAD")
	Set QXType=##Class(web.DHCEQCommon).GetDataByName(VData,"QXType")
	Set Action=##Class(web.DHCEQCommon).GetDataByName(VData,"Action") //Add By QW20201211 BUG:
	Set MergeOrderDR=##Class(web.DHCEQCommon).GetDataByName(VData,"MergeOrderDR") //Add By QW20201211 BUG:
	Set Name=##Class(web.DHCEQCommon).GetDataByName(VData,"Name")
	Set UseLocDR=##Class(web.DHCEQCommon).GetDataByName(VData,"UseLocDR")
	Set RequestNo=##Class(web.DHCEQCommon).GetDataByName(VData,"RequestNo")
	//Start Add 2013-12-18 HZY0043
	s EquipName=##Class(web.DHCEQCommon).GetDataByName(VData,"EquipName")
	s MinValue=##Class(web.DHCEQCommon).GetDataByName(VData,"MinValue")
	s MaxValue=##Class(web.DHCEQCommon).GetDataByName(VData,"MaxValue")
	s StartInDate=##Class(web.DHCEQCommon).GetDataByName(VData,"StartInDate")
	s EndInDate=##Class(web.DHCEQCommon).GetDataByName(VData,"EndInDate")
	i StartInDate'="" d
	.;s StartInDate=$ZDH(StartInDate,4)
	.;日期格式统一调整
	.s StartInDate=##Class(web.DHCEQCommon).TransValueFromPage(StartInDate,"date")
	e  d
	.s StartInDate=0
	i EndInDate'="" d
	.;s EndInDate=$ZDH(EndInDate,4)
	.;日期格式统一调整
	.s EndInDate=##Class(web.DHCEQCommon).TransValueFromPage(EndInDate,"date")
	e  d
	.s EndInDate=+$H
	//End Add 2013-12-18 HZY0043
	Set EquipNo=##Class(web.DHCEQCommon).GetDataByName(VData,"EquipNo")
	
	i ##Class(web.DHCEQCommon).ExistsElement(VData,"InvalidFlag")
	{
		Set InvalidFlag=##Class(web.DHCEQCommon).GetDataByName(VData,"InvalidFlag")
	}
	else
	{
		Set InvalidFlag="N"
	}
	
	
	//add by lmm 2017-08-29 begin
	i ##Class(web.DHCEQCommon).ExistsElement(VData,"MergeOrderFlag")
	{
	Set MergeOrderFlag=##Class(web.DHCEQCommon).GetDataByName(VData,"MergeOrderFlag")  
	}
	else
	{
		Set MergeOrderFlag="N"
	}
	//add by lmm 2017-08-29 end
	;i StartDate'="" s StartDate=$ZDH(StartDate,4)
	;日期格式统一调整
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	;i EndDate'="" s EndDate=$ZDH(EndDate,4)
	;日期格式统一调整
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	i WaitAD'="" s WaitAD=##Class(web.DHCEQCommon).TransValueFromPage(WaitAD,"bool")
	i ReplacesAD'="" s ReplacesAD=##Class(web.DHCEQCommon).TransValueFromPage(ReplacesAD,"bool")
 	/**************************************************/
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
 	
	s index=1
	s rowid=0
	s TRow=0
	s Name=$ZCONVERT(Name,"U")
	d BuildDataGetDisuseRequest
	Quit $$$OK
BuildDataGetDisuseRequest
	;Modified by JDL 2011-10-10 JDL0097 重写查询逻辑
	;Type= 0建单 1审批  2审核(基本弃用)
	if Type="1"
	{
		;各个审批角色审批时，用此查询
		;必须有审批角色
		if (ApproveRole="") q
		;查待审批的;非代审的
		if (ReplacesAD'="Y")
		{
			s rowid=0
			f  s rowid=$o(^DHCEQDisuseRequest(0,"ApproveRole",1,ApproveRole,rowid))  quit:rowid=""  d
			.d ResetVariablesGetDisuseRequest
			.d GetOneDisuseRequestInfo
		}
		
		;当 待操作 标志并未选中时，还需要显示该角色审批过的（不包含取消提交的），
		if WaitAD'="Y"
		{
			s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",1)  //%session.Get("LOGON.USERID")
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
			s rowid=0
			f  s rowid=$o(^DHCEQApproveList(0,"ApproveRole",ApproveType,rowid))  quit:rowid=""  d
			.s ApproveListID=0
			.;过滤掉新增的
			.q:$p($g(^DHCEQDisuseRequest(rowid)),"^",10)<1
			.s FindFlag=0
			.f  s ApproveListID=$o(^DHCEQApproveList(0,"ApproveRole",ApproveType,rowid,ApproveRole,ApproveListID))  quit:ApproveListID=""  d
			..;当查找别人代审的，则过滤掉 审批人员为自己的
			..q:(ReplacesAD="Y")&&($p(^DHCEQApproveList(ApproveListID),"^",6)=CurUser)
			..
			..;已经审核的，置为找到标志
			..i $p($g(^DHCEQDisuseRequest(rowid)),"^",10)=2  d
			...s FindFlag=1
			..;当为提交时，仅当报废单的审批步骤，大于角色的审批步骤，才显示
			..i $p($g(^DHCEQDisuseRequest(rowid)),"^",10)=1  d
			...;DR_NextFlowStep>AL_FlowStep
			...i $p($g(^DHCEQDisuseRequest(rowid)),"^",29)>$p(^DHCEQApproveList(ApproveListID),"^",9) s FindFlag=1
			.q:FindFlag=0
			.d ResetVariablesGetDisuseRequest
			.d GetOneDisuseRequestInfo
		}
	}
	elseif Type="2"
	{
		;审核查询,此步骤基本弃用
		s rowid=0
		s NextStep=""
		f  s rowid=$o(^DHCEQDisuseRequest(0,"Status",1,rowid))  quit:rowid=""  d
		.s NextStep=$p($G(^DHCEQDisuseRequest(rowid)),"^",29)
		.;只取审批步骤已经完成，只需最后审核的单据
		.q:NextStep'=""
		.d ResetVariablesGetDisuseRequest
		.d GetOneDisuseRequestInfo		
	}
	else
	{
		;一般建单人用此查询
		f  s rowid=$o(^DHCEQDisuseRequest(rowid))  quit:rowid=""  d
		.d ResetVariablesGetDisuseRequest
		.d GetOneDisuseRequestInfo
	}
	
	quit
GetOneDisuseRequestInfo
	s TRowID = rowid
	s TUseLocDR=$P($G(^DHCEQDisuseRequest(rowid)),"^",34)  //add hly 20190404
	q:(UseLocDR'="")&&(UseLocDR'=TUseLocDR)                //add hly 20190404
	s DRFlag=$p($g(^DHCEQDisuseRequest(rowid)),"^",53)
	i DRFlag="" s DRFlag="N"
	q:(InvalidFlag'="")&&(InvalidFlag'=DRFlag)
	s TEquipDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",1)
	q:(EquipDR'="")&&(EquipDR'=TEquipDR)
	s TInStockDate=""
	s AllNum=0
	s AllAmount=0
	;0:单台  1:批量  2:简易报废
	s TKindFlag =$p($g(^DHCEQDisuseRequest(rowid)),"^",44)
	
	i TKindFlag ="0"  d
	.s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TEquip=$ZCONVERT(TEquip,"U")
	.s TNo = $p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.s TNo=$ZCONVERT(TNo,"U")
	.s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	.i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
	.i TManuFactoryDR'="" s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	.s TPurchaseTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",64)
	.i TPurchaseTypeDR'="" s TPurchaseType=$p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	.s TPrice=$p($g(^DHCEQEquip(TEquipDR)),"^",27)
	.s TUnit=$p($g(^DHCEQEquip(TEquipDR)),"^",5)            //add by czf 369726
	.s AllNum=AllNum+1
	.s AllAmount=AllAmount+$Piece($Get(^DHCEQEquip(TEquipDR)),"^",27)
	.s TInStockDate=$p($g(^DHCEQEquip(TEquipDR)),"^",45)	//Add 2013-12-18 HZY0043
	.s TQuantity=1 //add by lmm 2017-08-25
	.s TTotalFee=TPrice*TQuantity  //add by lmm 2017-08-29
	if TKindFlag ="1"  d
	.s InStockListDR=$p($g(^DHCEQDisuseRequest(rowid)),"^",45) //2011-10-26 DJ DJ0097
	.i InStockListDR'=""  d
	..s TEquip=$p($g(^DHCEQInStockList(InStockListDR)),"^",5) //2011-10-26 DJ DJ0097
	..s TInStockDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",1) 	//Add 2013-12-18 HZY0043
	..s TInStockDate=$p($g(^DHCEQInStock(TInStockDR)),"^",7)
	..s TPrice=$p($g(^DHCEQInStockList(InStockListDR)),"^",7) 		//Add 2013-12-18 HZY0043
	..s TUnit=$p($g(^DHCEQInStockList(InStockListDR)),"^",10)       //add by czf 369726
	.//20141202  Mozy0147
	.Set equipRowIDs=$Get(^DHCEQDisuseRequest(rowid,"EX"))
	.Quit:equipRowIDs=""
	.Set count=$l(equipRowIDs,",")
	.For i=1:1:count Do
	..Set TEquipDR=$Piece(equipRowIDs,",",i)
	..If TNo '="" Set TNo = TNo_","
	..Set TNo = TNo_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",71)
	..;add by lmm 2018-11-05 begin
	..If (TEquip '="")&&((","_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)_",")'[(","_TEquip_","))  d
	...Set TEquip = TEquip_","_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	..If TEquip ="" Set TEquip = $Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	..;add by lmm 2018-11-05 end
	..s AllNum=AllNum+1
	..s AllAmount=AllAmount+$Piece($Get(^DHCEQEquip(TEquipDR)),"^",27)
	;多批报废
	if TKindFlag ="2"  d
	.Set dlid=0
	.s TQuantity=0 //add by lmm 2017-08-25
	.s TTotalFee=0
	.For  Set dlid=$Order(^DHCEQDisuseList(0,"Request",rowid,dlid)) Quit:dlid=""  Do
	..Set TQuantity=TQuantity+$Piece($Get(^DHCEQDisuseList(dlid)),"^",4)  //add by lmm 2017-08-25 
	..Set TTotalFee=($Piece($Get(^DHCEQDisuseList(dlid)),"^",4))*($Piece($Get(^DHCEQDisuseList(dlid)),"^",9))
	..If $Piece($Get(^DHCEQDisuseList(dlid)),"^",2)=0 Do
	...;单台
	...Set TEquipDR=$Piece($Get(^DHCEQDisuseList(dlid)),"^",3)
	...If TNo '="" Set TNo = TNo_","
	...Set TNo = TNo_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",71)
	...;add by lmm 2018-11-05 begin
	...If (TEquip '="")&&((","_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)_",")'[(","_TEquip_","))  d
	....Set TEquip = TEquip_","_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	...If TEquip ="" Set TEquip = $Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	...;add by lmm 2018-11-05 end
	...s AllNum=AllNum+1
	...s AllAmount=AllAmount+$Piece($Get(^DHCEQEquip(TEquipDR)),"^",27)
	..Else  Do
	...;批量
	...Set equipRowIDs=$Get(^DHCEQDisuseList(dlid,"EX"))
	...Quit:equipRowIDs=""
	...Set count=$l(equipRowIDs,",")
	...For i=1:1:count Do
	....Set TEquipDR=$Piece(equipRowIDs,",",i)
	....If TNo '="" Set TNo = TNo_","
	....Set TNo = TNo_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",71)
	....;add by lmm 2018-11-05 begin
	....If (TEquip '="")&&((","_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)_",")'[(","_TEquip_","))  d
	.....Set TEquip = TEquip_","_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	....If TEquip ="" Set TEquip = $Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	....;add by lmm 2018-11-05 end
	....s AllNum=AllNum+1
	....s AllAmount=AllAmount+$Piece($Get(^DHCEQEquip(TEquipDR)),"^",27)
	Quit:(EquipNo'="")&&(TNo'[EquipNo)
	s TQuantity=AllNum
	s TTotalFee=AllAmount
	s TEquipTypeDR=$p($g(^DHCEQDisuseRequest(rowid)),"^",43)  //2011-10-26 DJ DJ0097
	q:(Name'="")&&(TNo'=Name)&&(TEquip'[Name)
	q:(EquipName'="")&&(TNo'=EquipName)&&(TEquip'[EquipName)	//Start Add 2013-12-18 HZY0043
	q:(TInStockDate'="")&((TInStockDate<StartInDate)||(TInStockDate>EndInDate))
	q:(MinValue'="")&&(TPrice<MinValue)
	q:(MaxValue'="")&&(TPrice>MaxValue)	//End Add 2013-12-18 HZY0043
	q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	q:(PurchaseTypeDR'="")&&(PurchaseTypeDR'=TPurchaseTypeDR)
	q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)) //2011-10-26 DJ DJ0097
	i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2) //2011-10-26 DJ DJ0097
	s TGroupDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",2)
	i TGroupDR '=""  d
	.s TGroup = $p($g(^DHCEQGroup(TGroupDR)),"^",2)
	s TRequestLocDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",3)
	q:(RequestLocDR'="")&&(RequestLocDR'=TRequestLocDR)
	i TRequestLocDR '=""  d
	.s TRequestLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	s TUseLocDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",34)
	q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)	//20141202  Mozy0147
	i TUseLocDR'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	q:($p($g(^DHCEQDisuseRequest(rowid)),"^",4)>EndDate)||($p($g(^DHCEQDisuseRequest(rowid)),"^",4)<StartDate)
	s TRequestDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(rowid)),"^",4),"date")
	s TUseState = $p($g(^DHCEQDisuseRequest(rowid)),"^",5)
	s TDisuseTypeDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",6)
	i TDisuseTypeDR '=""  d
	.s TDisuseType = $p($g(^DHCEQCCode("DHCEQCDisuseType",TDisuseTypeDR)),"^",2)
	s TChangeReason = $p($g(^DHCEQDisuseRequest(rowid)),"^",7)
	s TDisureDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(rowid)),"^",8),"date")
	s TRemark = $p($g(^DHCEQDisuseRequest(rowid)),"^",9)
	s TStatus = $p($g(^DHCEQDisuseRequest(rowid)),"^",10)
	q:(StatusDR'="")&&(StatusDR'=TStatus)
	i ((Type'=0)&&(TStatus="0")) q
	s TStatus=##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	s TAddUserDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",11)
	i TAddUserDR '=""  d
	.s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	s TAddDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(rowid)),"^",12),"date")
	s TAddTime = $p($g(^DHCEQDisuseRequest(rowid)),"^",13)
	s TUpdateUserDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",14)
	i TUpdateUserDR '=""  d
	.s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	s TUpdateDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(rowid)),"^",15),"date")
	s TUpdateTime = $p($g(^DHCEQDisuseRequest(rowid)),"^",16)
	s TSubmitUserDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",17)
	i TSubmitUserDR '=""  d
	.s TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	s TSubmitDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(rowid)),"^",18),"date")
	s TSubmitTime = $p($g(^DHCEQDisuseRequest(rowid)),"^",19)
	s TAuditUserDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",20)
	i TAuditUserDR '=""  d
	.s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	s TAuditDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(rowid)),"^",21),"date")
	s TAuditTime = $p($g(^DHCEQDisuseRequest(rowid)),"^",22)
	s TRejectReason = $p($g(^DHCEQDisuseRequest(rowid)),"^",23)
	s TRejectUserDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",24)
	i TRejectUserDR '=""  d
	.s TRejectUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRejectUserDR)
	s TRejectDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(rowid)),"^",25),"date")
	s TRejectTime = $p($g(^DHCEQDisuseRequest(rowid)),"^",26)
	s TApproveSetDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",27)
	//i TApproveSetDR '=""  d
	//.s TApproveSet = $p($g(^DHCEQCApproveSet(TApproveSetDR)),"^",1)
	s TNextRoleDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",28)
	//i TNextRoleDR '=""  d
	//.s TNextRole = $p($g(^DHCEQCApproveRole(TNextRoleDR)),"^",2)
	s TNextFlowStep = $p($g(^DHCEQDisuseRequest(rowid)),"^",29)
	s TApproveStatu = $p($g(^DHCEQDisuseRequest(rowid)),"^",30)
	s TApproveRoleDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",31)
	//Add By QW20201223 BUG: QW0085 报废汇总批量审核 权限过滤 begin
	Quit:(MergeOrderDR'="")&&(##Class(web.DHCEQ.Plat.BUSMergeOrder).IsInMergeOrder(MergeOrderDR,rowid)=0)
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
    Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	Set roleFlag=0
	If ApproveRole'="" 
	{
		Quit:ApproveInfoID=""
    	Set CurStep=$Piece($Get(^DHCEQApproveInfo(ApproveInfoID)),"^",5)
		Quit:Action=""
	    s RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(##class(web.DHCEQApproveList).GetApproveSet("5",rowid),ApproveRole,Action)
	    i (CurStep'=RoleStep)&&(WaitAD="Y") Set roleFlag=1
	}elseif(Action'="")
	{
		Quit:ApproveInfoID=""
    	Set CurStep=$Piece($Get(^DHCEQApproveInfo(ApproveInfoID)),"^",5)
	    s RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(##class(web.DHCEQApproveList).GetApproveSet("5",rowid),"",Action)
	    i (CurStep'=RoleStep) Set roleFlag=1
	}
	Quit:($p($g(^DHCEQDisuseRequest(rowid)),"^",10)=1)&&(roleFlag'=0)  //Modified By QW20210118 BUG: QW0088
	//Add By QW20201223 BUG: QW0085 报废汇总批量审核 end
	;Modified by JDL 2011-10-10 JDL0097
	;q:(ApproveRole'="")&&(TNextRoleDR'=ApproveRole)&&(TApproveRoleDR'=ApproveRole)
	//i TApproveRoleDR '=""  d
	//.s TApproveRole = $p($g(^DHCEQCApproveRole(TApproveRoleDR)),"^",2)
	s THold1 = $p($g(^DHCEQDisuseRequest(rowid)),"^",32)
	s TRequestNo = $p($g(^DHCEQDisuseRequest(rowid)),"^",33)
	q:(RequestNo'="")&&(TRequestNo'[RequestNo)
	s TNo=##Class(web.DHCEQCommon).NoToGroupNo(TNo)		//Add By DJ 2016-04-25
	
	//add by lmm 2017-08-29
	s TMergeOrderFlag=$p($g(^DHCEQDisuseRequest(rowid)),"^",54)
	i TMergeOrderFlag="" s TMergeOrderFlag="N" //Add By QW20201223 BUG: QW0085 转空为N
	q:(MergeOrderFlag'="")&&(MergeOrderFlag'=TMergeOrderFlag) //Modified By QW20201223 BUG: QW0085 是否已汇总标志过滤
	
	
	;Modified by JDL 2011-12-02 JDL0104
	s TKindFlagDesc = $CASE(TKindFlag,"0":"单台报废","1":"批量报废","2":"多批报废","":"")
	s TUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",1)  //%session.Get("LOGON.USERID")
	q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TRequestLocDR)))  ;&&("N"=..GetUserLoc(TUserID,TRequestLocDR,""))
	s TRow=TRow+1		//Add By DJ 2015-09-21 DJ0165
	i TKindFlag=2  d		//多批次不显示单价和单位
	.s TPrice=""
	.s TUnit=""
	i TUnit'="" s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	d OutputRowGetDisuseRequest
	quit
OutputRowGetDisuseRequest
	s Data=$lb(TRowID,TEquipDR,TGroupDR,TRequestLocDR,TRequestDate,TUseState,TDisuseTypeDR,TChangeReason,TDisureDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatu,TApproveRoleDR,THold1,TRequestNo,TEquip,TGroup,TRequestLoc,TDisuseType,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TRejectUser,TApproveSet,TNextRole,TApproveRole,TModelDR,TModel,TManuFactoryDR,TManuFactory,TEquipTypeDR,TEquipType,TPurchaseTypeDR,TPurchaseType,TPrice,TKindFlag,TNo,TUseLoc,TKindFlagDesc,TRow,TQuantity,TTotalFee,TUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDisuseRequest
	s (TRowID,TEquipDR,TGroupDR,TRequestLocDR,TRequestDate,TUseState,TDisuseTypeDR,TChangeReason,TDisureDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatu,TApproveRoleDR,THold1,TRequestNo,TEquip,TGroup,TRequestLoc,TDisuseType,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TRejectUser,TApproveSet,TNextRole,TApproveRole,TModelDR,TModel,TManuFactoryDR,TManuFactory,TEquipTypeDR,TEquipType,TPurchaseTypeDR,TPurchaseType,TPrice,TKindFlag,TNo,TUseLoc,TKindFlagDesc,TQuantity,TTotalFee,TUnit)=""
	quit
}

ClassMethod GetDisuseRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisuseRequestExecute ]
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

ClassMethod GetDisuseRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisuseRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
