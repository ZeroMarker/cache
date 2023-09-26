/// ----------------------------------
/// Modified by HZY 2011-07-15 . Bug HZY0001
/// Discription:在查询方法GetDisuseRequest中添加参数RequestNo，以实现按申请单号查询的功能。
/// -------------------------------
/// 修改:ZY 2011-02-22 ZY0061
/// 描述:UpdateData预报废处理
/// -------------------------------
/// 修改:zy 2009-08-24  No ZY0010
/// 增加类方法:GetDisuseRequestRowID
/// 描述:根据参数设备rowid,查看报废申请中设备是否存在。
/// -------------------------------
/// 创建:zy 2009-08-17  No ZY0009
/// 描述：设备批量报废
/// --------------------------------
Class web.DHCEQBatchDisuseRequest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 67;

/// ----------------------------------
/// 创建：zy 2009-08-17  No ZY0009
/// 描述：报废种类
/// ----------------------------------
/// Modified by JDL 2011-11-29 JDL0104
ClassMethod GetKindFlag(name, width, Type As %Library.String = "") As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")  //hisui改造 add by lmm 2018-08-17
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	i Type=""
	{
		w "<option value=0>单台报废</option>"
		w "<option value=1>批量报废</option>"
	}
	else
	{
		w "<option value=2>多批报废</option>"
	}
	w "</select>",!
}

ClassMethod GetKindFlag1(name, width, Type As %Library.String = "", value As %Library.String = "") As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	s selectedone=$case(Value,0:"selected",:"")
	s selectedtwo=$case(Value,1:"selected",:"")
	i Type=""
	{
			w "<option value=0 "_selectedone_">单台报废</option>"
			w "<option value=1 "_selectedtwo_">批量报废</option>"
	}
	else
	{
		w "<option value=2>多批报废</option>"
	}
	w "</select>",!
}

/// ----------------------------------
/// 修改：zy 2009-08-17  No ZY0009
/// 描述：根据报废设备的状态显示报废信息
/// 访问表:DHC_EQDisuseRequest
/// ----------------------------------
/// Modified By QW20200331 BUG:QW0055 begin 增加上一步审批
Query GetDisuseRequest(vData As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TGroupDR:%String,TRequestLocDR:%String,TRequestDate:%String,TUseState:%String,TDisuseTypeDR:%String,TChangeReason:%String,TDisureDate:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TRejectReason:%String,TRejectUserDR:%String,TRejectDate:%String,TRejectTime:%String,TApproveSetDR:%String,TNextRoleDR:%String,TNextFlowStep:%String,TApproveStatu:%String,TApproveRoleDR:%String,THold1:%String,TRequestNo:%String,TEquip:%String,TGroup:%String,TRequestLoc:%String,TDisuseType:%String,TAddUser:%String,TUpdateUser:%String,TSubmitUser:%String,TAuditUser:%String,TRejectUser:%String,TApproveSet:%String,TNextRole:%String,TApproveRole:%String,TModelDR:%String,TModel:%String,TManuFactoryDR:%String,TManuFactory:%String,TEquipTypeDR:%String,TEquipType:%String,TPurchaseTypeDR:%String,TPurchaseType:%String,TPrice:%String,TKindFlag:%String,TNo:%String,TUseLoc:%String,TKindFlagDesc:%String,TRow:%String,TQuantity:%String,TTotalFee:%String,TUnit:%String,TLastApproveRole:%String,TApprovals:%String,TNetFeeFlag:%String")
{
}

ClassMethod GetDisuseRequestExecute(ByRef qHandle As %Binary, vData As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	/**************************************************/
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set ReplacesAD=##Class(web.DHCEQCommon).GetDataByName(vData,"ReplacesAD")
	Set ApproveRole=##Class(web.DHCEQCommon).GetDataByName(vData,"ApproveRole")
	Set Type=##Class(web.DHCEQCommon).GetDataByName(vData,"Type")
	Set StatusDR=##Class(web.DHCEQCommon).GetDataByName(vData,"StatusDR")
	Set EquipDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipDR")
	Set RequestLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"RequestLocDR")
	Set EquipTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDR")
	Set PurchaseTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"PurchaseTypeDR")
	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(vData,"StartDate")
	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndDate")
	Set WaitAD=##Class(web.DHCEQCommon).GetDataByName(vData,"WaitAD")
	Set QXType=##Class(web.DHCEQCommon).GetDataByName(vData,"QXType")
	Set Name=##Class(web.DHCEQCommon).GetDataByName(vData,"Name")
	Set UseLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
	Set RequestNo=##Class(web.DHCEQCommon).GetDataByName(vData,"RequestNo")
	//Start Add 2013-12-18 HZY0043
	s EquipName=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipName")
	s MinValue=##Class(web.DHCEQCommon).GetDataByName(vData,"MinValue")
	s MaxValue=##Class(web.DHCEQCommon).GetDataByName(vData,"MaxValue")
	s StartInDate=##Class(web.DHCEQCommon).GetDataByName(vData,"StartInDate")
	s EndInDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndInDate")
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
	Set EquipNo=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipNo")
	
	i ##Class(web.DHCEQCommon).ExistsElement(vData,"InvalidFlag")
	{
		Set InvalidFlag=##Class(web.DHCEQCommon).GetDataByName(vData,"InvalidFlag")
	}
	else
	{
		Set InvalidFlag="N"
	}
	
	Set HospitalDR=##Class(web.DHCEQCommon).GetDataByName(vData,"HospitalDR") // Add QW20210629 BUG:QW0131 增加输入参数院区HospitalDR
	//add by lmm 2017-08-29 begin
	i ##Class(web.DHCEQCommon).ExistsElement(vData,"MergeOrderFlag")
	{
	Set MergeOrderFlag=##Class(web.DHCEQCommon).GetDataByName(vData,"MergeOrderFlag")  
	}
	else
	{
		Set MergeOrderFlag="N"
	}
	//add by lmm 2017-08-29 end

	i StartDate'="" 
	;日期格式统一调整
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate'="" 
	;日期格式统一调整
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	i WaitAD'="" s WaitAD=##Class(web.DHCEQCommon).TransValueFromPage(WaitAD,"bool")
	i ReplacesAD'="" s ReplacesAD=##Class(web.DHCEQCommon).TransValueFromPage(ReplacesAD,"bool")
 	/**************************************************/
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
	
	s index=2 ;Modified By QW20210511 BUG:QW0106 报废审核界面增加查询后数量及金额统计功能 begin
	s rowid=0
	s TRow=0
	Set Total=0  
	Set TotalFee=0 ;Add By QW20210511 BUG:QW0106 报废审核界面增加查询后数量 end
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
	;Add By QW20210511 BUG:QW0106 报废审核界面增加查询后数量 begin
	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")		//Modify DJ 2017-03-16
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" Set TotalLoc=1
		i TotalFlag="2" Set TotalLoc=index+1
		i TotalFlag="3" Set TotalLoc=0
		Do ResetVariablesGetDisuseRequest
		Set TQuantity=Total
		Set TTotalFee=TotalFee
		Set TRow="合计:"
		s Data=$lb(TRowID,TEquipDR,TGroupDR,TRequestLocDR,TRequestDate,TUseState,TDisuseTypeDR,TChangeReason,TDisureDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatu,TApproveRoleDR,THold1,TRequestNo,TEquip,TGroup,TRequestLoc,TDisuseType,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TRejectUser,TApproveSet,TNextRole,TApproveRole,TModelDR,TModel,TManuFactoryDR,TManuFactory,TEquipTypeDR,TEquipType,TPurchaseTypeDR,TPurchaseType,TPrice,TKindFlag,TNo,TUseLoc,TKindFlagDesc,TRow,TQuantity,TTotalFee,TUnit,TLastApproveRole,TApprovals,TNetFeeFlag) ;Modify by zx 2022-12-04 2821212
		Set ^CacheTemp(repid,TotalLoc)=Data
	}
	;Add By QW20210511 BUG:QW0106 报废审核界面增加查询后数量
	quit
GetOneDisuseRequestInfo
	s TRowID = rowid
	s DRFlag=$p($g(^DHCEQDisuseRequest(rowid)),"^",53)
	i DRFlag="" s DRFlag="N"
	q:(InvalidFlag'="")&&(InvalidFlag'=DRFlag)
	s TEquipDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",1)
	q:(EquipDR'="")&&(EquipDR'=TEquipDR)
	s TInStockDate=""
	s AllNum=0
	s AllAmount=0
	s TotalNetFee=0 ;Modify by zx 2022-12-04 2821212 净值大于0,列表加背景色处理
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
	.i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
	.s TPurchaseTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",64)
	.i TPurchaseTypeDR'="" s TPurchaseType=$p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	.s TPrice=$p($g(^DHCEQEquip(TEquipDR)),"^",27)
	.s TUnit=$p($g(^DHCEQEquip(TEquipDR)),"^",5)            //add by czf 369726
	.s AllNum=AllNum+1
	.s AllAmount=AllAmount+$Piece($Get(^DHCEQEquip(TEquipDR)),"^",27)
	.s TInStockDate=$p($g(^DHCEQEquip(TEquipDR)),"^",45)	//Add 2013-12-18 HZY0043
	.s TQuantity=1 //add by lmm 2017-08-25
	.s TTotalFee=TPrice*TQuantity  //add by lmm 2017-08-29
	.s TotalNetFee=$p($g(^DHCEQEquip(TEquipDR)),"^",28)  ;Modify by zx 2022-12-04 2821212 净值大于0,列表加背景色处理
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
	..s AllNum=AllNum+1
	..s AllAmount=AllAmount+$Piece($Get(^DHCEQEquip(TEquipDR)),"^",27)
	..s TotalNetFee=TotalNetFee+$p($g(^DHCEQEquip(TEquipDR)),"^",28)  ;Modify by zx 2022-12-04 2821212 净值大于0,列表加背景色处理
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
	...s AllNum=AllNum+1
	...s AllAmount=AllAmount+$Piece($Get(^DHCEQEquip(TEquipDR)),"^",27)
	...s TotalNetFee=TotalNetFee+$p($g(^DHCEQEquip(TEquipDR)),"^",28)  ;Modify by zx 2022-12-04 2821212 净值大于0,列表加背景色处理
	..Else  Do
	...;批量
	...Set equipRowIDs=$Get(^DHCEQDisuseList(dlid,"EX"))
	...Quit:equipRowIDs=""
	...Set count=$l(equipRowIDs,",")
	...For i=1:1:count Do
	....Set TEquipDR=$Piece(equipRowIDs,",",i)
	....If TNo '="" Set TNo = TNo_","
	....Set TNo = TNo_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",71)
	....s AllNum=AllNum+1
	....s AllAmount=AllAmount+$Piece($Get(^DHCEQEquip(TEquipDR)),"^",27)
	....s TotalNetFee=TotalNetFee+$p($g(^DHCEQEquip(TEquipDR)),"^",28)  ;Modify by zx 2022-12-04 2821212 净值大于0,列表加背景色处理
	Quit:(EquipNo'="")&&(TNo'[EquipNo)
	s TQuantity=AllNum
	s TTotalFee=AllAmount
	s TNetFeeFlag=0
	i TotalNetFee>0 s TNetFeeFlag=1 ;Modify by zx 2022-12-04 2821212 净值大于0,列表加背景色处理
	s TEquipTypeDR=$p($g(^DHCEQDisuseRequest(rowid)),"^",43)  //2011-10-26 DJ DJ0097
	q:TEquipTypeDR=""	//add by ZY20221115
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
	Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TUseLocDR) ;Add QW20210629 BUG:QW0131
	q:(HospitalDR'="")&&(HospitalDR'=THospitalDR) ;Add QW20210629 BUG:QW0131
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
	;Modified by JDL 2011-10-10 JDL0097
	;q:(ApproveRole'="")&&(TNextRoleDR'=ApproveRole)&&(TApproveRoleDR'=ApproveRole)
	//i TApproveRoleDR '=""  d
	//.s TApproveRole = $p($g(^DHCEQCApproveRole(TApproveRoleDR)),"^",2)
	//add by mwz 2020-03-10 begin 获取当前最后操作人 MWZ0028
	s TLastApproveRoleDR="",TLastApproveRole=""
	s TLastApproveListDR=$o(^DHCEQApproveList(0,"Source","5",rowid,""),-1) 
	i TLastApproveListDR'="" s TLastApproveRoleDR=$p(^DHCEQApproveList(TLastApproveListDR),"^",5)
	i TLastApproveRoleDR'="" s TLastApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TLastApproveRoleDR)),"^",2)
	//add by mwz 2020-03-10 end 获取当前最后操作人 MWZ0028
	s THold1 = $p($g(^DHCEQDisuseRequest(rowid)),"^",32)
	s TRequestNo = $p($g(^DHCEQDisuseRequest(rowid)),"^",33)
	q:(RequestNo'="")&&(TRequestNo'[RequestNo)
	s TNo=##Class(web.DHCEQCommon).NoToGroupNo(TNo)		//Add By DJ 2016-04-25
	s TMergeOrderFlag=$p($g(^DHCEQDisuseRequest(rowid)),"^",54)	//modify by lmm 2019-04-48 867352
	//q:(MergeOrderFlag'="")&&(MergeOrderFlag=TMergeOrderFlag)
	s TKindFlagDesc = $CASE(TKindFlag,"0":"单台报废","1":"批量报废","2":"多批报废","":"")  //Modified by JDL 2011-12-02 JDL0104
	s TUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TRequestLocDR)))  ;&&("N"=..GetUserLoc(TUserID,TRequestLocDR,""))
	s (AppFlowID,HospLimit)=""		//czf 2021-09-01 begin
	s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	i AIRowID'="" d
	.s AppSetDR=$p(^DHCEQApproveInfo(AIRowID),"^",3)
	.s NextStepID=$p(^DHCEQApproveInfo(AIRowID),"^",5)
	.i (AppSetDR'="")&&(NextStepID'="") d
	..s AppFlowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSetDR,NextStepID,""))
	i AppFlowID'="" s HospLimit=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AppFlowID)),"^",20)
	q:(WaitAD="Y")&&(ApproveRole=TNextRoleDR)&&(##Class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(THospitalDR,"","","",HospLimit))
	s TRow=TRow+1		//Add By DJ 2015-09-21 DJ0165
	i TKindFlag=2  d		//多批次不显示单价和单位
	.s TPrice=""
	.s TUnit=""
	i TUnit'="" s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	;Add By QW20200331 BUG:QW0055 begin
	s TApprovals="无"
	i AIRowID'="" Do
	.s TApproveRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	.i TApproveRole'="" s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRole),"^",2)	
	i $p($g(^DHCEQDisuseRequest(rowid)),"^",10)=0 s TApprovals=""
	;Add By QW20200331 BUG:QW0055 end
	d OutputRowGetDisuseRequest
	quit
OutputRowGetDisuseRequest
	s Data=$lb(TRowID,TEquipDR,TGroupDR,TRequestLocDR,TRequestDate,TUseState,TDisuseTypeDR,TChangeReason,TDisureDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatu,TApproveRoleDR,THold1,TRequestNo,TEquip,TGroup,TRequestLoc,TDisuseType,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TRejectUser,TApproveSet,TNextRole,TApproveRole,TModelDR,TModel,TManuFactoryDR,TManuFactory,TEquipTypeDR,TEquipType,TPurchaseTypeDR,TPurchaseType,TPrice,TKindFlag,TNo,TUseLoc,TKindFlagDesc,TRow,TQuantity,TTotalFee,TUnit,TLastApproveRole,TApprovals,TNetFeeFlag) ;Modify by zx 2022-12-04 2821212
	Set TotalFee=TotalFee+TTotalFee  ;Add By QW20210511 BUG:QW0106 报废审核界面增加查询后数量
	Set Total=Total+TQuantity
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDisuseRequest
	s (TRowID,TEquipDR,TGroupDR,TRequestLocDR,TRequestDate,TUseState,TDisuseTypeDR,TChangeReason,TDisureDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatu,TApproveRoleDR,THold1,TRequestNo,TEquip,TGroup,TRequestLoc,TDisuseType,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TRejectUser,TApproveSet,TNextRole,TApproveRole,TModelDR,TModel,TManuFactoryDR,TManuFactory,TEquipTypeDR,TEquipType,TPurchaseTypeDR,TPurchaseType,TPrice,TKindFlag,TNo,TUseLoc,TKindFlagDesc,TQuantity,TTotalFee,TUnit,TLastApproveRole,TApprovals,TNetFeeFlag)="" ;Modify by zx 2022-12-04 2821212
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

/// Mozy0217  2018-11-01	增加配属设备信息输出
/// 2012-02-27  Mozy0078
/// 调整批量报废功能选择设备返回值
/// ----------------------------------
/// 创建：zy 2009-08-17  No ZY0009
/// 描述：根据使用科室和报废种类找出能够报废的设备
/// 访问表:DHC_EQEquip
/// 增加入参 TEquipDRs:设备id串 modify by lmm 2020-03-04 
/// d ##class(%ResultSet).RunQuery("web.DHCEQBatchDisuseRequest","Equip",2,1)
/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query Equip(LocDR As %Library.String = "", KindFlag As %Library.String = "", Equip As %Library.String = "", QXType As %Library.String = "", RequestRowID As %Library.String = "", EquipTypeDR As %Library.String = "", ExcludeIDs As %Library.String = "", AllListInfo As %String = "") As %Query(ROWSPEC = "Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,TEquip:%String:设备,TStoreLoc:%String:库房,TInStockNo:%String:入库单号,TQuantityNum:%String:数量,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,TInDate:%String:入库日期,Hidden:%String,Hidden:%String,TNo:%String:设备编号,Hidden:%String,Hidden:%String,Hidden:%String,TFileNo:%String:档案号,Hidden:%String,Hidden:%String,Hidden:%String,TOldNo:%String:旧编号")
{
}

ClassMethod EquipExecute(ByRef qHandle As %Binary, LocDR As %Library.String = "", KindFlag As %Library.String = "", Equip As %Library.String = "", QXType As %Library.String = "", RequestRowID As %Library.String = "", EquipTypeDR As %Library.String = "", ExcludeIDs As %Library.String = "", AllListInfo As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s Equip=##Class(web.DHCEQCommon).UnEscape(Equip)
	s Equip=$ZCONVERT(Equip ,"U")
	//Add By DJ 2017-11-20
	s TCurListRow=$p(AllListInfo,"=",1)
	s TJob=$p(AllListInfo,"=",2)
	s TAllListInfo=$p(AllListInfo,"=",3)
	s TAllListCount=$L(TAllListInfo,"&")
	
	d BuildDataEquip
	Quit $$$OK
BuildDataEquip 		
	s ISLRowID=0
	i +KindFlag=0    //单台报废
	{
		s StoreLocID=0
		f  s StoreLocID=$o(^DHCEQEquip(0,"StoreLoc",StoreLocID)) q:StoreLocID=""  d
		.q:(LocDR'="")&&(LocDR'=StoreLocID)
		.q:##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocID)="1"
		.s TStoreLocDR=StoreLocID
		.s TStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocID)      //库房 20140716  Mozy0134
		.s rowid=0
		.f  s rowid=$o(^DHCEQEquip(0,"StoreLoc",StoreLocID,rowid)) q:rowid=""  d
		..d ResetVariablesEquip		
		..s CurFlag=0		//Add By DJ 2017-11-20 begin
		..s CurListNo=0
		..f CurListNo=1:1:TAllListCount  d
		...q:CurFlag'=0
		...s CurListInfo=$p(TAllListInfo,"&",CurListNo)
		...q:CurListInfo=""
		...s TCurListID=$p(CurListInfo,"^",1)
		...s TCurMXRowID=$p(CurListInfo,"^",2)
		...i TCurListRow'=TCurListID  d
		....i TCurMXRowID'=""  d
		.....s TCurRowIDs=$g(^TEMPEQ("MXList",TJob,TCurMXRowID))
		....e  d
		.....s TCurRowIDs=$g(^TEMPEQ("MXList","EX",TJob,TCurListID))
		....i (","_TCurRowIDs_",")[(","_rowid_",") s CurFlag=1
		..q:CurFlag'=0		//Add By DJ 2017-11-20 end	
		..s TEquip=$p($g(^DHCEQEquip(rowid)),"^",1)           //设备
		..s EQCode=$p($g(^DHCEQEquip(rowid)),"^",6)	
		..s TNo=$p($g(^DHCEQEquip(rowid)),"^",71)          //设备编号
		..Set TFileNo=$Piece($Get(^DHCEQEquip(rowid)),"^",85)	//档案号	20150820  Mozy0160
		..Set TOldNo=$Piece($Get(^DHCEQEquip(rowid)),"^",91)	//旧编号	20230309 bug:  
		..q:(Equip'="")&'(($ZCONVERT(TEquip,"U")[Equip)||($ZCONVERT(EQCode,"U")[Equip)||($ZCONVERT(TNo,"U")[Equip)||($ZCONVERT(TFileNo,"U")[Equip)||($ZCONVERT(TOldNo,"U")[Equip))
		..;Modified by jdl 2011-12-08 JDL0104
		..q:..CheckEquipDR(3,RequestRowID,rowid,LocDR,ExcludeIDs)=1
		..s InStockListDR=$p($g(^DHCEQEquip(rowid)),"^",70)
		..i InStockListDR'="" d
		...s ISRowID=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)    //入库申请单号dr
		...s TInStockNo = $p($g(^DHCEQInStock(ISRowID)),"^",14)   //入库申请单号
		...s TInDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(ISRowID)),"^",13),"date")  //入库日期
		..e  d
		...s TInStockNo = ""   
		...s TInDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",45),"date")  //转资日期
		..s TEquipDR=rowid
		..s TModelDR=$p($g(^DHCEQEquip(rowid)),"^",3)          //机型
		..i TModelDR'=""  s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		..s TEquipCatDR=$p($g(^DHCEQEquip(rowid)),"^",4)       //设备分类
		..i TEquipCatDR'=""  s TEquipCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
		..s TEQManufacturerDR=$p($g(^DHCEQEquip(rowid)),"^",26)  //生产厂商
		..i TEQManufacturerDR'=""  s TEQManufacturer = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TEQManufacturerDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",TEQManufacturerDR)),"^",1) //CZF0093
		..s TProviderDR=$p($g(^DHCEQEquip(rowid)),"^",25)       //供应商
		..i TProviderDR'=""  s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	; $p($g(^APC("APCVM",TProviderDR)),"^",3)
		..s TLimitYearsNum=$p($g(^DHCEQEquip(rowid)),"^",31)   //使用年限 
		..s TEquipTypeDR =$p($g(^DHCEQEquip(rowid)),"^",63)            //设备类组
		..q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
		..q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)="1"
		..i TEquipTypeDR'=""  s TEquipType= $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2) //设备类组
		..s TLeaveFactoryNo=$p($g(^DHCEQEquip(rowid)),"^",10)  //出厂编号
		..s TQuantityNum=1
		..s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(rowid)),"^",27),"")  //原值
		..;// Mozy0217  2018-11-01
		..i THasConfig'="Y" d
		...s TOpenCheckListDR=$p($g(^DHCEQEquip(rowid)),"^",77)
		...i ##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1,TOpenCheckListDR)'="" s THasConfig="Y"
		..s TConfigDR=$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",26)				; EQHold13
		..i TConfigDR'="" s THasConfig="N"									; 过滤配置设备
		..d OutputRowEquip
	}
	i +KindFlag=1   //批量报废
	{
		f  s ISLRowID=$o(^DHCEQEquip(0,"InStockList",ISLRowID)) q:ISLRowID=""  d
		.d ResetVariablesEquip
		.s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)  //入库申请单号dr
		.s TInStockNo = $p($g(^DHCEQInStock(ISRowID)),"^",14)  //入库单号
		.s TInStockListDR=ISLRowID
		.
		.;Modified by jdl 2012-1-12 JDL0110
		.;判断类组时,判断设备的
		.s EquipTypeFlag=1
		.;s TEquipTypeDR = $p($g(^DHCEQInStock(ISRowID)),"^",20)             //类组DR
		.;q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
		.;q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)="1"
		.
		.s TEquip=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)      //设备名
		.s EQCode=$p($g(^DHCEQInStockList(ISLRowID)),"^",16)
		.i EQCode'="" s EQCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",EQCode)),"^",2) //代码
		.q:(Equip'="")&'(($ZCONVERT(TEquip,"U")[Equip)||($ZCONVERT(EQCode,"U")[Equip))
		.q:##Class(web.DHCEQFinance2019).BussFilter(21,ISLRowID)'=0   //Add By QW 2019-01-14  bug:QW0025  比较设备项与业务单据类组是否一致
		.s StoreLocDR=0
		.f  s StoreLocDR=$o(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocDR)) q:((StoreLocDR="")||(EquipTypeFlag=0))  d
		..q:(LocDR'="")&($ZCONVERT(StoreLocDR,"U")'=$ZCONVERT(LocDR,"U"))
		..q:##class(web.DHCEQCommon).LocIsInEQ(QXType,LocDR)="1"
		..s EQRowID=0
		..s TQuantityNum=0
		..s TEquipDR=""
		..f  s EQRowID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocDR,EQRowID)) q:((EQRowID="")||(EquipTypeFlag=0))  d
		...s CurFlag=0		//Add By DJ 2017-11-20 begin
		...s CurListNo=0
		...f CurListNo=1:1:TAllListCount  d
		....q:CurFlag'=0
		....s CurListInfo=$p(TAllListInfo,"&",CurListNo)
		....q:CurListInfo=""
		....s TCurListID=$p(CurListInfo,"^",1)
		....s TCurMXRowID=$p(CurListInfo,"^",2)
		....i TCurListRow'=TCurListID  d
		.....i TCurMXRowID'=""  d
		......s TCurRowIDs=$g(^TEMPEQ("MXList",TJob,TCurMXRowID))
		.....e  d
		......s TCurRowIDs=$g(^TEMPEQ("MXList","EX",TJob,TCurListID))
		.....i (","_TCurRowIDs_",")[(","_EQRowID_",") s CurFlag=1
		...q:CurFlag'=0		//Add By DJ 2017-11-20 end
		...;Modified by jdl 2012-1-12 JDL0110
		...s TEquipTypeDR =$p($g(^DHCEQEquip(EQRowID)),"^",63)             //类组DR
		...i (EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR) s EquipTypeFlag=0
		...q:EquipTypeFlag=0
		...i ##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)="1" s EquipTypeFlag=0
		...q:EquipTypeFlag=0
		...
		...;Modified by jdl 2011-12-08 JDL0104
		...q:..CheckEquipDR(3,RequestRowID,EQRowID,LocDR,ExcludeIDs)=1
		...s TEquipDR=TInStockListDR
		...s TQuantityNum=TQuantityNum+1
		...s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",27),"")  //原值
		...;Add By QW20200218 begin BUG:QW0041 测试需求
		...if TEquipDRs'="" s TEquipDRs=TEquipDRs_"," 
		...s TEquipDRs=TEquipDRs_EQRowID
		..s NoStr=##class(web.DHCEQBatchDisuseRequest).GetEquipNoAndLeaveFactoryNo("","",TEquipDRs)
		..s TNo=$p(NoStr,"^",1)
		..s TLeaveFactoryNo=$p(NoStr,"^",2)
		..s TFileNo=$p(NoStr,"^",4)
		..;Add By QW20200218 begin BUG:QW0041 测试需求
		..i KindFlag="1" q:TQuantityNum<=1
		..
		..s TStoreLocDR=StoreLocDR
		..s TStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)      //库房 20140716  Mozy0134
		..
		..
		..i TEquipTypeDR'=""  s TEquipType= $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2) //设备类组
		..s TModelDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",9)     //机型
		..i TModelDR'=""  s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		..s TEquipCatDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",14)   //设备分类
		..i TEquipCatDR'=""  s TEquipCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
		..s TEQManufacturerDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",6)   //生产厂商
		..i TEQManufacturerDR'=""  s TEQManufacturer = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TEQManufacturerDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",TEQManufacturerDR)),"^",1) //CZF0093
		..s TProviderDR=$p($g(^DHCEQInStock(ISRowID)),"^",17)             //供应商
		..i TProviderDR'=""  s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)		;$p($g(^APC("APCVM",TProviderDR)),"^",3)
		..s TLimitYearsNum = $p($g(^DHCEQInStockList(ISLRowID)),"^",15)   //使用年限
		..s TInDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(ISRowID)),"^",13),"date") //入库日期
		..;// Mozy0217  2018-11-01
		..s TOpenCheckListDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",19)
		..i ##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1,TOpenCheckListDR)'="" s THasConfig="Y"
		..s TConfigDR=$Piece($Get(^DHCEQInStockList(ISLRowID)),"^",22)
		..i TConfigDR'="" s THasConfig="N"
		..d OutputRowEquip
	}
	quit
OutputRowEquip
	Set Data=$lb(TEquipDR,TStoreLocDR,TInStockListDR,TModelDR,TEquipCatDR,TEQManufacturerDR,TProviderDR,TEquipTypeDR,TEquip,TStoreLoc,TInStockNo,TQuantityNum,TModel,TEquipCat,TEQManufacturer,TProvider,TInDate,TEquipType,TLimitYearsNum,TNo,TLeaveFactoryNo,TOriginalFee,KindFlag,TFileNo,THasConfig,TConfigDR,TEquipDRs,TOldNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesEquip
	s (TEquipDR,TEquip,TInStockListDR,TInStockNo,TQuantityNum,TModel,TModelDR,TEquipCat,TEquipCatDR,TEQManufacturer,TEQManufacturerDR,TProvider,TProviderDR,TInDate,TEquipType,TEquipTypeDR,TLimitYearsNum,TNo,TLeaveFactoryNo,TOriginalFee,TFileNo,TConfigDR,TEquipDRs,TOldNo,NoStr)=""  //Modified By QW20200218 begin BUG:QW0041 测试需求
	s THasConfig="N"	;无配置设备
	quit
}

ClassMethod EquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EquipExecute ]
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

ClassMethod EquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Modified By JDL 2011-12-08 JDL0104
/// 优化方法，并增加参数
/// 	增加参数SelectRow，解决翻页后丢失参数的问题
/// 	增加参数ExcludeIDs,处理本单中其他明细选择的设备，在此不再显示
/// ----------------------------------
/// 创建：zy 2009-08-17  No ZY0009
/// 描述：根据入库单号找出能够报废的设备，同时已经选取的RowIDs打勾。
/// 访问表:DHC_EQEquip
/// ----------------------------------
Query DisuseEquip(LocDR As %Library.String = "", InStockListDR As %Library.String = "", RowIDs As %Library.String = "", RowID As %Library.String = "", SelectRow As %Library.String = "", ExcludeIDs As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TEquip:%String,TNo:%String,TInStockListDR:%String,Select:%String,TLeaveFactoryNo:%String,TRow:%String")
{
}

ClassMethod DisuseEquipExecute(ByRef qHandle As %Binary, LocDR As %Library.String = "", InStockListDR As %Library.String = "", RowIDs As %Library.String = "", RowID As %Library.String = "", SelectRow As %Library.String = "", ExcludeIDs As %Library.String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	d BuildDataDisuseEquip
	Quit $$$OK
BuildDataDisuseEquip
	i InStockListDR="" q
	
	s DRStatus=""
	i RowID'="" s DRStatus=$p($g(^DHCEQDisuseRequest(RowID)),"^",10)	
	i (DRStatus>0)   //提交后
	{
		s Count=$l(RowIDs,",")
		for j=1:1:Count
		{
			s TRowID=$p(RowIDs,",",j)
			i TRowID="" continue
			s Select="1"
			d SetEquipInfo
			d OutputRowDisuseEquip
		}
	} 
	else   //提交前
	{
		s RowIDs=","_RowIDs_","
		s TRowID=0
		f  s TRowID=$o(^DHCEQEquip(0,"InStockList",InStockListDR,LocDR,TRowID)) q:TRowID=""  d
		.d ResetVariablesDisuseEquip
		.i RowIDs[(","_TRowID_",")  d
		..s Select="1"
		..d SetEquipInfo
		..d OutputRowDisuseEquip
		.e  d
		..q:..CheckEquipDR(3,RowID,TRowID,LocDR,ExcludeIDs)=1
		..s Select="0"
		..d SetEquipInfo
		..d OutputRowDisuseEquip
	}
	quit
SetEquipInfo
	s TEquip= $p($g(^DHCEQEquip(TRowID)),"^",1)
	s TLeaveFactoryNo = $p($g(^DHCEQEquip(TRowID)),"^",10)
	s TInStockListDR = $p($g(^DHCEQEquip(TRowID)),"^",70)
	s TNo = $p($g(^DHCEQEquip(TRowID)),"^",71)
	s TRow=TRow+1
	quit	
OutputRowDisuseEquip
	s Data=$lb(TRowID,TEquip,TNo,TInStockListDR,Select,TLeaveFactoryNo,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesDisuseEquip
	s (TEquip,TNo,TInStockListDR,Select,TLeaveFactoryNo)=""
	quit
}

ClassMethod DisuseEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DisuseEquipExecute ]
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

ClassMethod DisuseEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DisuseEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Modified By JDL 2011-12-05 JDL0104
/// 重写生成报废明细,并增加对多批次设备报废方式的处理
/// ----------------------------------
/// 创建：zy 2009-08-17  No ZY0009
/// 描述：根据参数rowids写入报废明细。
/// 访问表:DHC_EQDisuseRequestList
/// ----------------------------------
ClassMethod InsertDisuseRequestList(RowID, WeUser As %String = "")
{
	n User,Date,PLISTMX
	n KindFlag,SourceType,EquipIDs,EquipID,Len
	//Modify by zx 2020-03-13 BUG ZX0079
	s User=WeUser
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	k PLISTMX
	s PLISTMX(2)=RowID             ;DisuseRequestDR
	s KindFlag=$P(^DHCEQDisuseRequest(RowID),"^",44)
	
	s ListID=""
	if KindFlag=0  d
	.s EquipID=$P(^DHCEQDisuseRequest(RowID),"^",1)
	.d InsertList	
	else  if KindFlag=1  d
	.s EquipIDs=$g(^DHCEQDisuseRequest(RowID,"EX"))
	.s Len=$l(EquipIDs,",")
	.for i=1:1:Len  q:(SQLCODE'=0)  d
	..s EquipID=$p(EquipIDs,",",i)
	..d InsertList
	else  d
	.;多批
	.f  s ListID=$o(^DHCEQDisuseList(0,"Request",RowID,ListID))  quit:((ListID="")||(SQLCODE'=0))  d
	..i $p(^DHCEQDisuseList(ListID),"^",2)=0  d
	...s EquipID=$P(^DHCEQDisuseList(ListID),"^",3)
	...d InsertList
	..e  d
	...s EquipIDs=$g(^DHCEQDisuseList(ListID,"EX"))
	...s Len=$l(EquipIDs,",")
	...for i=1:1:Len  q:(SQLCODE'=0)  d
	....s EquipID=$p(EquipIDs,",",i)
	....d InsertList
	
	q SQLCODE

InsertList	
	s PLISTMX(3)=EquipID
	;s PLISTMX(12)=$p($g(^DHCEQEquip(EquipID)),"^",38)     ;Sataus
	s PLISTMX(13)=ListID
	&SQL(Insert Into SQLUser.DHC_EQDisuseRequestList values:PLISTMX())
	q
}

/// ----------------------------------
/// 创建：zy 2009-08-17  No ZY0009
/// 描述：根据参数rowid取出报废单中的信息。
/// 访问表:DHC_EQDisuseRequest
/// ----------------------------------
ClassMethod GetOneDisuseRequest(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex,ReasonDR)="" //modefied hly 20200422
	if (rowid=0)||(rowid="")  q ""
	s result= $g(^DHCEQDisuseRequest(rowid))
	if result="" q ""
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;GroupDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQGroup($p(result,"^",2))),"^",1)
	s resultex=resultex_"^"	;RequestLocDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))
	s $p(result,"^",4)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",4),"date")	;RequestDate
	s resultex=resultex_"^"	;DisuseTypeDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDisuseType",$p(result,"^",6))),"^",2)
	s $p(result,"^",8)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"date")	;DisureDate
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",11))
	s $p(result,"^",12)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",14))
	s $p(result,"^",15)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",15),"date")	;UpdateDate
	s resultex=resultex_"^"	;SubmitUserDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",17))
	s $p(result,"^",18)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",18),"date")	;SubmitDate
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",20))
	s $p(result,"^",21)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",21),"date")	;AuditDate
	s resultex=resultex_"^"	;RejectUserDR
	i $p(result,"^",24)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",24))
	s $p(result,"^",25)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",25),"date")	;RejectDate
	s resultex=resultex_"^"	;ApproveSetDR
	i $p(result,"^",27)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCApproveSet($p(result,"^",27))),"^",1)
	s resultex=resultex_"^"	;NextRoleDR
	i $p(result,"^",28)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCApproveRole($p(result,"^",28))),"^",1)
	s resultex=resultex_"^"	;ApproveRoleDR
	i $p(result,"^",31)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCApproveRole($p(result,"^",31))),"^",1)
	s resultex=resultex_"^"	;UseLocDR
	i $p(result,"^",34)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",34))
	s $p(result,"^",36)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",36),"")
	s resultex=resultex_"^"	;InStock
	//modified by zy 20130503
	i $p(result,"^",1)'="" d
	.s InStockListDR=$p($g(^DHCEQEquip($p(result,"^",1))),"^",70)
	.i InStockListDR'="" d
	..s resultex=resultex_$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(InStockListDR)),"^",1))),"^",14)
	e  d
	.i $p(result,"^",45)'="" d
	..s resultex=resultex_$p($g(^DHCEQInStock($p($g(^DHCEQInStockList($p(result,"^",45))),"^",1))),"^",14)
	s $p(result,"^",40)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",40),"")
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",43)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",($p(result,"^",43)))),"^",2)
	s $p(result,"^",49)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",49),"date")	;DRHold5
	s resultex=resultex_"^"_rowid
	s RRowID=0            //add hly 20200422 begin
	f  s RRowID=$o(^DHCEQPReason(0,"RSourceType","34",rowid,RRowID)) q:RRowID=""  d
	.s ReasonDR=ReasonDR_"^"_$p($g(^DHCEQPReason(RRowID)),"^",4)
	//add hly 20200422 end
	//设备信息
	s (TModel,TEquipCat,TEQManufacturer,TProvider,EQItemDR)=""	
	s KindFlag=$p(result,"^",44)
	i KindFlag="1"  d
	.s RowIDs=$g(^DHCEQDisuseRequest(rowid,"EX"))
	.s TEquip=$p($g(^DHCEQInStockList($p(result,"^",45))),"^",5)      //设备名	
	.s ModelDR=$p($g(^DHCEQInStockList($p(result,"^",45))),"^",9)     //机型
	.s EquipCatDR=$p($g(^DHCEQInStockList($p(result,"^",45))),"^",14)   //设备分类
	.s EQItemDR=$p($g(^DHCEQInStockList($p(result,"^",45))),"^",16)     //设备项   add by wjl
	.s EQManufacturerDR=$p($g(^DHCEQInStockList($p(result,"^",45))),"^",6)   //生产厂商
	.s ProviderDR=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList($p(result,"^",45))),"^",1))),"^",17)             //供应商
	.s TInDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock($p($g(^DHCEQInStockList($p(result,"^",45))),"^",1))),"^",13),"date") //入库日期
	else  if KindFlag="0"  d
	.s RowIDs=$p(^DHCEQDisuseRequest(rowid),"^",1)
	.s TEquip=$p($g(^DHCEQEquip(RowIDs)),"^",1)           //设备
	.s ModelDR=$p($g(^DHCEQEquip(RowIDs)),"^",3)          //机型
	.s EquipCatDR=$p($g(^DHCEQEquip(RowIDs)),"^",4)       //设备分类
	.s EQItemDR=$p($g(^DHCEQEquip(RowIDs)),"^",7)        //设备项   add by wjl
	.s EQManufacturerDR=$p($g(^DHCEQEquip(RowIDs)),"^",26)  //生产厂商
	.s ProviderDR=$p($g(^DHCEQEquip(RowIDs)),"^",25)       //供应商
	.s TInDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(RowIDs)),"^",45),"date") //转资日期
	else  d
	.s (RowIDs,TEquip,ModelDR,EquipCatDR,EQManufacturerDR,ProviderDR,TInDate)=""
	//modified by 20150914 ZY0141
	s (EQuipTypeDR,StatCatDR,EQuipType,StatCat)=""  //设备类组  add by wjl
	i EQItemDR'=""  d
	.s EQuipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",EQItemDR)),"^",3)  //设备类组  add by wjl
	.s StatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",EQItemDR)),"^",5)    //设备类型   add by wjl
	i EQuipTypeDR'="" s EQuipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EQuipTypeDR)),"^",2)
	i StatCatDR'="" s StatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)

	i ModelDR'=""  s TModel = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	i EquipCatDR'=""  s TEquipCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR)),"^",2)
	i EQManufacturerDR'=""  s TEQManufacturer = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",EQManufacturerDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",EQManufacturerDR)),"^",1) //CZF0093
	i ProviderDR'="" s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)	;$p($g(^APC("APCVM",ProviderDR)),"^",3)	
	s resultex=resultex_"^"_TEquip_"^"_TModel_"^"_ModelDR_"^"_TEquipCat_"^"_EquipCatDR_"^"_TEQManufacturer_"^"_EQManufacturerDR_"^"_TProvider_"^"_ProviderDR_"^"_TInDate
	
	
	s resultex=resultex_"^"_RowIDs_"^"_..GetEquipNoAndLeaveFactoryNo("","",RowIDs)
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("5",rowid)		//modified by czf 需求号：353835
	s CancelFlag=$p(AppInfo,"^",7)
	///add by zy 2009-09-01 BugNo.ZY0012
	s PrintInfo=""
	i (RowIDs=0)||(RowIDs="")
	{
		s resultex=resultex_"^"_CancelFlag
		q ##Class(web.DHCEQCommon).Replace(result_resultex,$C(13,10),"\n")
	}
	s Count=$l(RowIDs,",")
	s RowID=$p(RowIDs,",",1)  ;EquipDR
	s MakeDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(RowID)),"^",14),"date")   //生产日期
	s PrintInfo=PrintInfo_"^"	
	i MakeDate'=""  d
	.s PrintInfo=PrintInfo_MakeDate
	s CountryDR =($p($g(^DHCEQEquip(RowID)),"^",16))    //国别
	s PrintInfo=PrintInfo_"^"	
	i CountryDR'=""  d
	.s PrintInfo=PrintInfo_$p($g(^CT("COU",CountryDR)),"^",2)
	s ManageLevelDR = $p($g(^DHCEQEquip(RowID)),"^",18)    //管理级别
	s PrintInfo=PrintInfo_"^"	
	i ManageLevelDR'=""  d
	.s PrintInfo=PrintInfo_$p($g(^DHCEQCCode("DHCEQCManageLevel",ManageLevelDR)),"^",2)
	s EquipTechLevelDR = $p($g(^DHCEQEquip(RowID)),"^",24)    //技术水平
	s PrintInfo=PrintInfo_"^"
	i EquipTechLevelDR'=""  d
	.s PrintInfo=PrintInfo_$p($g(^DHCEQCCode("DHCEQCTechLevel",EquipTechLevelDR)),"^",2)
	s OriginalFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(RowID)),"^",27),"")    //设备原值
	s PrintInfo=PrintInfo_"^"	
	i OriginalFee'=""  d
	.s PrintInfo=PrintInfo_OriginalFee
	s StartDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(RowID)),"^",44),"date")    //启用日期
	s PrintInfo=PrintInfo_"^"	
	i StartDate'=""  d
	.s PrintInfo=PrintInfo_StartDate
	s PurposeTypeDR = $p($g(^DHCEQEquip(RowID)),"^",65)    //用途
	s PrintInfo=PrintInfo_"^"	
	i PurposeTypeDR'=""  d
	.s PrintInfo=PrintInfo_$p($g(^DHCEQCCode("DHCEQCPurposeType",PurposeTypeDR)),"^",2)
	s KeeperDR = $p($g(^DHCEQEquip(RowID)),"^",66)    //保管人
	s PrintInfo=PrintInfo_"^"	
	i KeeperDR'=""  d
	.s PrintInfo=PrintInfo_##class(web.DHCEQCommon).GetTrakNameByID("user",KeeperDR)
	s PrintInfo=PrintInfo_"^"_##Class(web.DHCEQCommon).GetApproveInfo(5,rowid)	;20150825  Mozy0163	调整新增通用获取审批意见方法
	//其他信息 2010-04-06 党军
	s OtherInfo=""
	s EQNoIDS=$p(..GetEquipNoAndLeaveFactoryNo("","",RowIDs),"^",1)
	s EQNo=$p(EQNoIDS,",",1)
	s EQRowID=""
	Set FileNo=""
	i EQNo'="" s EQRowID=$o(^DHCEQEquip(0,"No",EQNo,0))
	i EQRowID'="" d
	.s EQUnitDR=$p($g(^DHCEQEquip(EQRowID)),"^",5)
	.s OtherInfo=OtherInfo_"^"
	.i EQUnitDR'="" s OtherInfo=OtherInfo_##class(web.DHCEQCommon).GetTrakNameByID("uom",EQUnitDR)
	.s EQOpenCheckDate=$p($g(^DHCEQEquip(EQRowID)),"^",12)
	.s OtherInfo=OtherInfo_"^"
	.i EQOpenCheckDate'="" s OtherInfo=OtherInfo_##class(web.DHCEQCommon).TransValueToPage(EQOpenCheckDate,"date")
	.s EQTransassetDate=$p($g(^DHCEQEquip(EQRowID)),"^",45)
	.s OtherInfo=OtherInfo_"^"
	.i EQTransassetDate'="" s OtherInfo=OtherInfo_##class(web.DHCEQCommon).TransValueToPage(EQTransassetDate,"date")
	.s EQNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",28),"")
	.s EQDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",35),"")
	.Set FileNo=$Piece($Get(^DHCEQEquip(EQRowID)),"^",85)	//20150820  Mozy0160
	.s OtherInfo=OtherInfo_"^"_EQDepreTotalFee_"^"_EQNetFee
	e  d
	.s OtherInfo="^^^^^"
	
	//add by lmm 2020-03-02 LMM0060
	s (DisuseListID,DisuseLocation)=""
	s DisuseListID=$o(^DHCEQDisuseList(0,"Request",rowid,""))
	i DisuseListID'="" s DisuseLocation=$p($g(^DHCEQDisuseList(DisuseListID)),"^",10)
	
	s result=result_resultex_"^"_PrintInfo_OtherInfo_"^"_EQuipType_"^"_StatCat_"^"_FileNo_"^"_CancelFlag_"^"_DisuseListID_"^"_DisuseLocation_"^"_ReasonDR   //modified by czf 需求号：353835   //add by wjl (EQuipType,StatCat)  //modified hly 20200422
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

ClassMethod GetApproveSet(DRID)
{
	i DRID="" q ""
	q $p($g(^DHCEQDisuseRequest(DRID)),"^",27)   //报废审批设置
}

/// ----------------------------------
/// 创建：zy 2009-08-17  No ZY0009
/// 描述：根据参数rowid取出报废单中设备的出厂编号和设备编号。
/// 访问表:DHC_EQEquip
/// ----------------------------------
ClassMethod GetEquipNoAndLeaveFactoryNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowIDs As %Library.String = "")
{
	//Modified by QW20200303 BUG:QW0042 begin
	new result,resultNo,resultLeaveFactoryNo,RowID
	s (result,resultNo,resultLeaveFactoryNo)=""
	//Modified by QW20200303 BUG:QW0042 end
	if (RowIDs=0)||(RowIDs="")  q ""
	s Count=$l(RowIDs,",")
	for j=1:1:Count
	{
		s RowID=$p(RowIDs,",",j)  ;EquipDR	 				
		s LeaveFactoryNo= $p($g(^DHCEQEquip(RowID)),"^",10)    //出厂编号
		s No=$p( $g(^DHCEQEquip(RowID)),"^",71)    //设备编号
		i LeaveFactoryNo'="" s resultLeaveFactoryNo=resultLeaveFactoryNo_","_LeaveFactoryNo //Modified By QW20200218 begin BUG:QW0041 测试需求
		s resultNo=resultNo_","_No
		s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(RowID)),"^",27),"")  //原值	//Modify DJ 2015-09-10 DJ0163
	}
	s resultLeaveFactoryNo=$e(resultLeaveFactoryNo,2,$l(resultLeaveFactoryNo))
	s resultNo=$e(resultNo,2,$l(resultNo))
	Set resultNo=##Class(web.DHCEQCommon).NoToGroupNo(resultNo)	// 20150914  Mozy0165
	s result=resultNo_"^"_resultLeaveFactoryNo_"^"_OriginalFee  //Modified by QW20200303 BUG:QW0042
	q result
}

/// Modified By JDL 2011-12-13 JDL0104
/// ----------------------------------
/// 创建：zy 2009-08-24  No ZY0010
/// 描述：根据参数设备rowid,查看报废申请中设备是否存在。
/// 访问表:DHC_EQDisuseRequest
/// 返回值:报废申请RowID和审批设置
/// ----------------------------------
ClassMethod GetDisuseRequestRowID(EquipDR)
{
	
	n RequestID,ApproveSetDR,KindFlag
	n RowID,MXRowID,RequestStatus,Status,EquipIDs
	s (RequestID,ApproveSetDR,KindFlag)=""
	s RequestStatus=""
	;需要处理台帐处
	
	if (EquipDR'="")  d
	.;Status报废设备只取审核的，其他则取未审核的
	.if ($p($g(^DHCEQEquip(EquipDR)),"^",38)=3)  d
	..s RowID=0
	..f  s RowID=$o(^DHCEQLifeInfo(0,"EquipSource","34",EquipDR,RowID))  q:(RowID="")||(RequestID'="")  d
	...s RequestID=$p(^DHCEQDisuseRequestList(RowID),"^",1)
	...if ($p($g(^DHCEQDisuseRequest(RequestID)),"^",53)="Y") s RequestID=""
	.e  d
	..s Status=""
	..f  s Status=$o(^DHCEQDisuseRequest(0,"Status",Status))  q:(Status="")||(RequestID'="")  d
	...;只取未审核的
	...q:((Status'=0)&&(Status'=1))
	...s RowID=0
	...f  s RowID=$o(^DHCEQDisuseRequest(0,"Status",Status,RowID)) q:(RowID="")||(RequestID'="")  d
	....;过滤掉无效的InvalidFlag
	....q:$p($g(^DHCEQDisuseRequest(RowID)),"^",53)="Y"
	....s KindFlag=$p($g(^DHCEQDisuseRequest(RowID)),"^",44)
	....i KindFlag=0  d
	.....if $P(^DHCEQDisuseRequest(RowID),"^",1)=EquipDR s RequestID=RowID
	....else  if KindFlag=1  d
	.....s EquipIDs=$g(^DHCEQDisuseRequest(RowID,"EX"))
	.....i (","_EquipIDs_",")[(","_EquipDR_",") s RequestID=RowID
	....e  d
	.....s MXRowID=0
	.....f  s MXRowID=$o(^DHCEQDisuseList(0,"Request",RowID,MXRowID)) q:(MXRowID="")||(RequestID'="")  d
	......i $p(^DHCEQDisuseList(MXRowID),"^",2)=0  d
	.......i $P(^DHCEQDisuseList(MXRowID),"^",3)=EquipDR s RequestID=RowID
	......e  d
	.......s EquipIDs=$g(^DHCEQDisuseList(MXRowID,"EX"))
	.......i (","_EquipIDs_",")[(","_EquipDR_",") s RequestID=RowID
	
	if RequestID="" q ""
	s ApproveSetDR=$p($g(^DHCEQDisuseRequest(RequestID)),"^",27)
	s KindFlag=$p($g(^DHCEQDisuseRequest(RequestID)),"^",44)
	q RequestID_"^"_ApproveSetDR_"^"_KindFlag
}

/// Add by JDL 2011-11-29 JDL0104
/// d ##class(%ResultSet).RunQuery("web.DHCEQBatchDisuseRequest","DisuseList",2)
Query DisuseList(RowID As %String = "") As %Query(ROWSPEC = "TRow:%String,RowID:%String,DLRowID:%String,TSourceType:%String,TSourceID:%String,TSource:%String,TModel:%String,TManuFactory:%String,TUnit:%String,TProvider:%String,TLimitYears:%String,TInDate:%String,TQtyNum:%String,TTotalFee:%String,TUseState:%String,TDisuseReason:%String,TDisuseDate:%String,TRemark:%String,TOriginalFee:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TJob:%String,TEquipIDs:%String,TNo:%String,TSourceTypeDR:%String")
{
}

ClassMethod DisuseListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	new repid, index,DLRowID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
		
	s TJob=$J
	s (TRow,TotalQty,Amount)=0
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i TotalFlag="1"  s index=2
	
	if RowID'=""  d
	.s DLRowID=0
	.f  s DLRowID=$o(^DHCEQDisuseList(0,"Request",RowID,DLRowID))  quit:DLRowID=""  d
	..d ResetVariablesGetDisuseList
	..s TRow=TRow+1
	..
	..s TSourceType=$p($g(^DHCEQDisuseList(DLRowID)),"^",2)
	..s TSourceTypeDR=TSourceType
	..s TSourceID=$p($g(^DHCEQDisuseList(DLRowID)),"^",3)
	..i TSourceType=0  d
	...s TSource=$p($g(^DHCEQEquip(TSourceID)),"^",1)
	...s TManuFactory=$p($g(^DHCEQEquip(TSourceID)),"^",26)
	...s TModel=$p($g(^DHCEQEquip(TSourceID)),"^",3)
	...s TLimitYears=$p($g(^DHCEQEquip(TSourceID)),"^",31)
	...s TUnit=$p($g(^DHCEQEquip(TSourceID)),"^",5)
	...s TProvider=$p($g(^DHCEQEquip(TSourceID)),"^",25)
	...s TInDate = $p($g(^DHCEQEquip(TSourceID)),"^",45)
	...s TNo=$p($g(^DHCEQEquip(TSourceID)),"^",71)			//Add By DJ 2016-04-25
	..e  d
	...s TSource=$p($g(^DHCEQInStockList(TSourceID)),"^",5)
	...s TManuFactory=$p($g(^DHCEQInStockList(TSourceID)),"^",6)
	...s TModel=$p($g(^DHCEQInStockList(TSourceID)),"^",9)
	...s TLimitYears=$p($g(^DHCEQInStockList(TSourceID)),"^",15)
	...s TUnit=$p($g(^DHCEQInStockList(TSourceID)),"^",10)
	...s TInStockDR=$p($g(^DHCEQInStockList(TSourceID)),"^",1)
	...s TProvider=$p($g(^DHCEQInStock(TInStockDR)),"^",17)
	...s TInDate = $p($g(^DHCEQInStock(TInStockDR)),"^",13)
	...s TNo=$p($g(^DHCEQInStock(TInStockDR)),"^",14)			//Add By DJ 2016-04-25
	..
	..i TManuFactory'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactory) //CZF0093
	..i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	..i TProvider'=""  s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
	..i TUnit'="" s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	..i TInDate'="" s TInDate=##class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
	..
	..
	..s TQtyNum=$p($g(^DHCEQDisuseList(DLRowID)),"^",4)
	..s TUseState=$p($g(^DHCEQDisuseList(DLRowID)),"^",5)
	..s TDisuseReason=$p($g(^DHCEQDisuseList(DLRowID)),"^",6)
	..s TDisuseDate=$p($g(^DHCEQDisuseList(DLRowID)),"^",7)
	..s TRemark=$p($g(^DHCEQDisuseList(DLRowID)),"^",8)
	..s THold1=$p($g(^DHCEQDisuseList(DLRowID)),"^",9)
	..s THold2=$p($g(^DHCEQDisuseList(DLRowID)),"^",10)
	..s THold3=$p($g(^DHCEQDisuseList(DLRowID)),"^",11)
	..s THold4=$p($g(^DHCEQDisuseList(DLRowID)),"^",12)
	..s THold5=$p($g(^DHCEQDisuseList(DLRowID)),"^",13)
	..
	..s TTotalFee=TQtyNum*THold1
	..// Mozy0217  2018-11-01
	..;s TotalQty=TotalQty+TQtyNum
	..;s Amount=Amount+TTotalFee
	..
	..s TEquipIDs=$g(^DHCEQDisuseList(DLRowID,"EX"))
	..// Mozy0217  2018-11-01
	..i ($p(^DHCEQDisuseList(DLRowID),"^",11)="") d
	...s TotalQty=TotalQty+TQtyNum
	...s Amount=Amount+TTotalFee
	..
	..d OutputRowGetDisuseList
	;没有数据时,也返回一个空行,用于编辑
	i TRow=0  d
	.d ResetVariablesGetDisuseList
	.s TRow=1
	.d OutputRowGetDisuseList
	;处理合计行
	i TotalFlag>0  d
	.d ResetVariablesGetDisuseList
	.s DLRowID=-1
	.s TRow="合计"
	.s TQtyNum=TotalQty
	.s TTotalFee=Amount
	.i TotalFlag="1"  d
	..s index=1
	.e  d
	..s index=index+1
	.d OutputRowGetDisuseList
	Quit $$$OK
	
OutputRowGetDisuseList
	i THold1'="" s THold1=##Class(web.DHCEQCommon).FormatNumber(THold1,"")
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
	
	s Data=$lb(TRow,RowID,DLRowID,TSourceType,TSourceID,TSource,TModel,TManuFactory,TUnit,TProvider,TLimitYears,TInDate,TQtyNum,TTotalFee,TUseState,TDisuseReason,TDisuseDate,TRemark,THold1,THold2,THold3,THold4,THold5,TJob,TEquipIDs,TNo,TSourceTypeDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDisuseList
	s (TSourceType,TSourceID,TSource,TModel,TManuFactory,TUnit,TProvider,TLimitYears,TInDate,TQtyNum,TTotalFee,TUseState,TDisuseReason,TDisuseDate,TRemark,THold1,THold2,THold3,THold4,THold5,TEquipIDs,TNo,TSourceTypeDR)=""
	quit
}

ClassMethod DisuseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DisuseListExecute ]
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

ClassMethod DisuseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DisuseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// ----------------------------------
/// 创建：jdl 2011-11-30  JDL0104
/// 描述：保存报废申请单及其明细
/// 访问表:DHC_EQDisuseRequest,DHC_EQDisuseList,DHC_EQDisuseRequestList
/// 参数：	ReqVal申请单信息
/// 		ListVal明细信息
/// 		DelListIDs:删除的报废明细ID串
/// 		IsDel:0正常保存,1删除操作
/// 返回值：
/// 	SQLCODE^OtherInfo
/// 	当SQLCODE为0，表示成功，OtherInfo返回RowID
/// 	当SQLCODE为其他，表示失败，OtherInfo返回失败信息
/// ----------------------------------
/// Modefied by zc0125 2022-12-12 增加入参vInventoryListDR和vInventoryExceptionDR
ClassMethod SaveDisuseRequest(ReqVal, ListVal, DelListIDs, IsDel, val As %String = "", WeUser As %String = "", WeChatLocID As %String = "", vInventoryListDR As %Library.String = "", vInventoryExceptionDR As %Library.String = "")
{
	s $ZT="ERRSaveDisuseRequest"
	
	n RowID,PLIST,User,Date,Time,ErrMsg,PLISTR //modify hly 20200331
	n KindFlag,EquipIDs,InvalidFlag,Job
	
	s ErrMsg=""
	s RowID=$P(ReqVal,"^",1)
	//Modify by zx 2020-03-13 BUG ZX0079
	s User=WeUser
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	s Date=+$H
	s Time=$p($H,",",2)
	
	k PLIST
	s num=$l(val,",") //add hly 20200311 bug:1170377 begin
	s RSourceType=34 //add hly 20200331 bug:1245641
 	i RowID'=""
 	{
	 	s InvalidFlag=$Piece($G(^DHCEQDisuseRequest(RowID)),"^",53)
	 	i InvalidFlag="Y" q "-2201^无效单据不能操作!"
 	}
 	TSTART
 	if +IsDel=1		;删除
 	{
	 	&SQL(Update SQLUSER.DHC_EQDisuseRequest Set DR_InvalidFlag='Y',DR_CancelUser=:User,DR_CancelDate=:Date,DR_CancelTime=:Time where DR_RowID=:RowID)
 		//k ^DHCEQDisuseRequest(RowID,"EX")
 		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^删除报废申请单信息失败!"
		}
		//Modified By QW20211221 BUG:QW00 begin
		s RRowID=$O(^DHCEQPReason("RSourceType",RSourceType,RowID,0))
 		if (RRowID'="")
 		{
	 		&SQL(DELETE FROM SQLUSER.DHC_EQPReason WHERE R_SourceID=:RowID AND R_SourceType=:RSourceType) //modify hly 20200331 bug:1245641
	 		i SQLCODE
			{
				TROLLBACK
				q SQLCODE_"^删除报废原因信息失败!"
			}
		}
 		//Modified By QW20211221 end
        //modified by ZY 20220926 2757106 删除明细占用节点记录
        s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss("","34",RowID,1)
        i SQLCODE
        {
            TROLLBACK
            q SQLCODE_"^删除明细占用节点记录!"
        }
        //end by ZY 20220926 2757106 删除明细占用节点记录
	}
	else		;更新
	{
		;保存报废申请单		
 		;s PLIST(3) = $p(ReqVal,"^",3)	;GroupDR
 		s PLIST(4) = $p(ReqVal,"^",4)	;RequestLocDR 
 		i $p(ReqVal,"^",5)'=""  s PLIST(5) = ##class(web.DHCEQCommon).TransValueFromPage($p(ReqVal,"^",5),"date")	;RequestDate
 		s PLIST(6) = $p(ReqVal,"^",6)	;UseState
 		s PLIST(7) = $p(ReqVal,"^",7)	;DisuseTypeDR
 		s PLIST(8) = $p(ReqVal,"^",8)	;ChangeReason
 		i $p(ReqVal,"^",9)'=""  s PLIST(9) = ##class(web.DHCEQCommon).TransValueFromPage($p(ReqVal,"^",9),"date")	;DisureDate
 		s PLIST(10) = $p(ReqVal,"^",10)	;Remark
 		s PLIST(11) = 0	;Status
 		//s PLIST(12) = $p(ReqVal,"^",12)	;AddUserDR 
 		//i $p(ReqVal,"^",13)'=""  s PLIST(13) = ..TransValueFromPage($p(ReqVal,"^",13),"date")	;AddDate
 		//s PLIST(14) = $p(ReqVal,"^",14)	;AddTime
 		//s PLIST(15) = $p(ReqVal,"^",15) 	;UpdateUserDR
 		//s PLIST(16) = +$H	        ;UpdateDate
 		//s PLIST(17) = $P($H,",",2)	;UpdateTime
 		//s PLIST(18) = $p(ReqVal,"^",18)	;SubmitUserDR
 		//s PLIST(19) = $p(ReqVal,"^",19)	;SubmitDate
 		//s PLIST(20) = $p(ReqVal,"^",20)	;SubmitTime
 		//s PLIST(21) = $p(ReqVal,"^",21)	;AuditUserDR
 		//s PLIST(22) = $p(ReqVal,"^",22)	;AuditDate
 		//s PLIST(23) = $p(ReqVal,"^",23)	;AuditTime
 	 	s PLIST(24) = $p(ReqVal,"^",46)	;RejectReason
 		//s PLIST(25) = $p(ReqVal,"^",25) 	;RejectUserDR
 		//s PLIST(26) = $p(ReqVal,"^",26)	;RejectDate
 		//s PLIST(27) = $p(ReqVal,"^",27)	;RejectTime
 		//s PLIST(28) = $p(ReqVal,"^",28)	;ApproveSetDR
 		//s PLIST(29) = $p(ReqVal,"^",29)	;NextRoleDR
 		//s PLIST(30) = $p(ReqVal,"^",30)	;NextFlowStep
 		//s PLIST(31) = $p(ReqVal,"^",31)	;ApproveStatu
 		//s PLIST(32) = $p(ReqVal,"^",32)	;ApproveRoleDR
 		//s PLIST(33) = $p(ReqVal,"^",33)	;Hold1
 		//s PLIST(34) = $p(ReqVal,"^",34)	;RequestNo
 		s PLIST(35) = $p(ReqVal,"^",35)	;UseLocDR
 		s PLIST(36) = $p(ReqVal,"^",36)	;TotleTime
 	 	s PLIST(37) = $p(ReqVal,"^",37)	;Income
 		s PLIST(38) = $p(ReqVal,"^",38) 	;CheckResult
 		s PLIST(39) = $p(ReqVal,"^",39)	;TechnicEvaluate
 		s PLIST(40) = $p(ReqVal,"^",40)	;RepairHours
 		s PLIST(41) = $p(ReqVal,"^",41)	;RepairFee
 		s PLIST(42) = $p(ReqVal,"^",42)	;RepairTimes
 		s PLIST(43) = $p(ReqVal,"^",43)	;LimitYears
 		s PLIST(44) = $p(ReqVal,"^",48)	;EquipTypeDR
		//20150820  Mozy0160
 		Set PLIST(45) = $Piece(ReqVal,"^",49)	;Hold2
 		Set PLIST(46) = $Piece(ReqVal,"^",50)	;Hold3
 		Set PLIST(47) = $Piece(ReqVal,"^",51)	;Hold4
 		Set PLIST(48) = $Piece(ReqVal,"^",52)	;Hold5
 		s PLIST(49) = $p(ReqVal,"^",44)	;KindFlag
 		s Job=$Piece(ReqVal,"^",53)		//Add By DJ 2016-04-25
 		Set PLIST(56) = $Piece(ReqVal,"^",54)	;DR_DisposalWay czf 2022-05-25
 		Set PLIST(57) = $Piece(ReqVal,"^",55)	;DR_DisposalFee
 		
 		s EquipIDs=""
 		s KindFlag=$p(ReqVal,"^",44)
 		if (KindFlag=0)
 		{	;单台设备
	 		s PLIST(2) = $p(ReqVal,"^",2)	;EquipDR
	 		s PLIST(50) = ""	;InStockListDR
 		}
 		elseif (KindFlag=1)
 		{	;批量设备
	 		s PLIST(2) = ""	;EquipDR
 			s PLIST(50) = $p(ReqVal,"^",45)	;InStockListDR
 			s EquipIDs=$p(ReqVal,"^",47)
 		}
 		else
 		{	;多批设备
	 		s PLIST(2) = ""		;EquipDR
 			s PLIST(50) = ""	;InStockListDR
	 	}
	 	
 		s PLIST(54) = "N"
 		s UpdateFlag=0
		//add hly 20200311 bug:1170377
		k PLISTR	// MZY0105	2340940		2021-12-13
 		s PLISTR(3)=RSourceType //modify hly 20200331 bug:1245641
	 	
 		if RowID=""
 		{
		 	s PLIST(12) = User
	 		s PLIST(13) = Date
			s PLIST(14) = Time
			//Modify by zx 2020-03-13 BUG ZX0079		
	 		s PLIST(34)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQDisuseRequest",PLIST(13),WeChatLocID,$p(ReqVal,"^",48))

	 		&SQL(Insert Into SQLUSER.DHC_EQDisuseRequest Values :PLIST())
			//add hly 20200408 begin
	 		i SQLCODE
			{
				TROLLBACK
				q SQLCODE_"^新增报废申请单信息失败!"
			}
			//add hly 20200408 end
			s RowID=$G(%ROWID)
			// MZY0103	2321058		2021-12-06
			i val'=""
			{
				;k PLISTR	 MZY0105	2340940		2021-12-13
				s PLISTR(4)=RowID
		 		for i=1:1:num
		 		{	
		 			s PLISTR(5)=$p(val,",",i)
					&SQL(Insert Into SQLUSER.DHC_EQPReason Values :PLISTR())
					q:SQLCODE'=0
		 		}
			}
	 		i SQLCODE
			{
				TROLLBACK
				q SQLCODE_"^新增报废原因信息失败!"
			}
 		}
 		else
 		{
	 		s UpdateFlag=1
	 		s PLIST(15) = User
	 		s PLIST(16) = Date
	 		s PLIST(17) = Time

	 		&SQL(Update SQLUSER.DHC_EQDisuseRequest Values :PLIST() where DR_RowID = :RowID)
	 		i SQLCODE
			{
				TROLLBACK
				q SQLCODE_"^更新报废申请单信息失败!"
			}
			//add by wy 2020-4-29 1294046 修改报废原因更新方法 begin
	 	   Set SQLCODE=##Class(web.DHCEQBatchDisuseRequest).DeletePReason(val,RowID)
	 	   // MZY0103	2321058		2021-12-06
		   if SQLCODE=100 s SQLCODE=0
	 	   If SQLCODE
		   {
			 TROLLBACK
	         Quit SQLCODE_"^更新报废原因信息失败!"
		   }
		   i val'=""
		   {
			    for i=1:1:num
		 		{	s PLISTR(5)=$p(val,",",i)
		 		    s RReasonDR=PLISTR(5)
		 		    s PLISTR(4)=RowID
			        &SQL(select R_RowID into :Rowid from SQLUSER.DHC_EQPReason where R_ReasonDR=:RReasonDR and R_sourceID=:RowID)
					i SQLCODE=100  {&SQL(Insert Into SQLUSER.DHC_EQPReason Values :PLISTR())}
		 		}
	 		}
	 		i SQLCODE
			{
				TROLLBACK
				q SQLCODE_"^更新报废原因信息失败!"
			}

			//add by wy 2020-4-29 修改报废原因更新方法 end
 		}	
 		//Modefied by zc0125 2022-12-12 增加盘点信息记录 begin	
 		s SQLCODE=##Class(web.DHCEQ.EM.BUSInventory).SaveBussInfoByInventory(vInventoryExceptionDR,vInventoryListDR,34,RowID)
 		i SQLCODE
 		{
			TROLLBACK
			q SQLCODE_"^更新盘点信息失败!"
 		}
 		//Modefied by zc0125 2022-12-12 增加盘点信息记录 end
 
		if KindFlag="1"
		{
			i UpdateFlag=0 s ^DHCEQDisuseRequest(RowID,"EX")=$g(^TEMPEQ("MXList","EX",Job,"1"))		//Add by DJ 2016-04-25
	 		if (UpdateFlag=1)&&($Data(^TEMPEQ("MXList",Job,RowID)))
	 		{
		 		// Mozy	946352	2019-9-12
		 		s ^DHCEQDisuseRequest(RowID,"EX")=$g(^TEMPEQ("MXList",Job,RowID))
	 			k ^TEMPEQ("MXList","EX",Job,RowID)
	 		}
	 		//Add by QW20200303 BUG:QW0042 begin
	 		s RowIDs=""
			s Len=0
			s RowIDs=$g(^DHCEQDisuseRequest(RowID,"EX"))
			if RowIDs'="" s Len=$l(RowIDs,",")
			s QuantityNum=$p(ListVal,"^",5)  //来源于LMM0060 修改后的入参ListVal。
			//Modified by QW20200313 BUG:QW0044  begin 报废需求修改1224594
	 		if (Len'=QuantityNum) 
	 		{
		 		s Flag=##Class(web.DHCEQUpdateEquipsByList).GetRowIDsByQuantityNum(PLIST(50),QuantityNum,RowID,PLIST(35),Job,"1","6")
				i Flag
				{
					TROLLBACK
					q Flag
				}
	 		}
			i UpdateFlag=0 s ^DHCEQDisuseRequest(RowID,"EX")=$g(^TEMPEQ("MXList","EX",Job,"1"))		
	 		if (UpdateFlag=1)&&($Data(^TEMPEQ("MXList",Job,RowID)))
	 		{
		 		s ^DHCEQDisuseRequest(RowID,"EX")=$g(^TEMPEQ("MXList",Job,RowID))
	 			k ^TEMPEQ("MXList","EX",Job,RowID)
	 		}
	 		//Modified by QW20200313 BUG:QW0044  End 
            ///modified by ZY 20220926 2757106
            s ListEquip=$g(^DHCEQDisuseRequest(RowID,"EX"))
            s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEquip,"34",RowID,0)
            i SQLCODE
            {
                TROLLBACK
                q SQLCODE_"^记录业务占用信息失败!"
            }
        }
        else
        {
            ///modified by ZY 20220926 2757106
            s ListEquip=$g(^DHCEQDisuseRequest(RowID,"EX"))
            s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEquip,"34",RowID,1)
            i SQLCODE
            {
                TROLLBACK
                q SQLCODE_"^删除业务占用信息失败!"
            }
			k ^DHCEQDisuseRequest(RowID,"EX")
		}
 		
 		;保存DHC_EQDisuseList ,仅当多批次信息时，保存此信息
 		;modify by lmm 2020-03-02 LMM0060单批次设备保存信息
 		//if KindFlag=2
 		//{
	 		s SQLCODE=..DeleteDisuseList(DelListIDs)
	 		i SQLCODE
			{
				TROLLBACK
				q SQLCODE_"^删除报废单明细信息失败!"
			}
			s SQLCODE=..SaveDisuseList(RowID,ListVal)
	 		i SQLCODE
			{
				TROLLBACK
				q SQLCODE_"^保存报废单明细信息失败!"
			}
	 	//}
 		
	}
	
	if SQLCODE'=0
	{
		TRollBack
		q SQLCODE_"^"_ErrMsg
	}
	TCOMMIT
 	q "0^"_RowID
 	
ERRSaveDisuseRequest
	TRollBack	
	Set ErrMsg=$ZE	     //得到系统返回的错误消息
 	Quit "-2201^ERRSaveDisuseRequest:"_ErrMsg     //返回错误消息 ;
}

/// ----------------------------------
/// 创建:JDL 2011-12-02  JDL0104
/// 描述:保存报废单明细
/// 入参： 
/// 	DRRowID：报废申请单ID
/// 	ListVal：明细信息
/// 返回值：SQLCODE^ErrDesc
/// 
/// w ##Class(web.DHCEQBatchDisuseRequest).SaveDisuseList("65","1^100^10403&1^100^10403")
ClassMethod SaveDisuseList(DRRowID, ListVal)
{
	n PLISTMX,Length,i,RowData,RowNo
	n DLRowID,EquipIDs
	
	k PLISTMX
	i ListVal="" q 0
	i DRRowID<1 q -1
	
	s Length=$l(ListVal,"&")
	s PLISTMX(2)=DRRowID  				;DL_DisuseRequestDR
	
	for i=1:1:Length  q:SQLCODE'=0  d
	.s RowData=	$p(ListVal,"&",i)
	.
	.s RowNo= $p(RowData,"^",1)
	.s DLRowID= $p(RowData,"^",2)
	.s PLISTMX(3)=$p(RowData,"^",3)  	;SourceType
	.s PLISTMX(4)=$p(RowData,"^",4)		;SourceID
	.s PLISTMX(5)=$p(RowData,"^",5)		;Qty
	.s PLISTMX(6)=$p(RowData,"^",6)  	;UseState
	.s PLISTMX(7)=$p(RowData,"^",7)  	;DisuseReason
	.s PLISTMX(8)=$p(RowData,"^",8)  	;DisuseDate
	.s PLISTMX(9)=$p(RowData,"^",9)  	;Remark
	.s PLISTMX(10)=$p(RowData,"^",10)  	;Hold1
	.;modify by lmm 2020-03-02 LMM0060 用于保存报废存放地点
	.s PLISTMX(11)=$p(RowData,"^",11)  	;Hold2 明细审核标志，一开始更新时都为空 add by csy 2017-08-16 明细勾选报废 需求号：CSY0007
	.s PLISTMX(12)=$p(RowData,"^",12)  	;Hold3
	.s PLISTMX(13)=$p(RowData,"^",13)  	;Hold4
	.s PLISTMX(14)=$p(RowData,"^",14)  	;Hold5
	.s index=$p(RowData,"^",16)			//Add By DJ 2016-04-25
	.s Job=$p(RowData,"^",17)
	.s DLRowIDFlag=""
	.i DLRowID=""  d
	..&SQL(Insert Into SQLUSER.DHC_EQDisuseList Values :PLISTMX())
	..q:SQLCODE'=0
	..s DLRowID=$G(%ROWID)
	.e  d
	..s DLRowIDFlag="1"
	..&SQL(update sqluser.DHC_EQDisuseList values :PLISTMX() where DL_RowID=:DLRowID)
	..q:SQLCODE'=0
	.q:SQLCODE'=0
	.;0:单台  1:批量, 批量时记录设备ID串  
	.i $p(RowData,"^",3)="1"  d
	..i DLRowIDFlag="" s ^DHCEQDisuseList(DLRowID,"EX")=$g(^TEMPEQ("MXList","EX",Job,index))		//Add by DJ 2016-04-25
	..i $D(^TEMPEQ("MXList",Job,DLRowID))  d
	...s ^DHCEQDisuseList(DLRowID,"EX")=$g(^TEMPEQ("MXList",Job,DLRowID))
    ..
    ..///modified by ZY 20220926 2757106
    ..s ListEquip=$g(^DHCEQDisuseList(DLRowID,"EX"))
    ..s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEquip,"34",DRRowID,0)
    ..i SQLCODE s SQLCODE=RLRowID_"^记录业务占用信息失败!"
    ..q:SQLCODE'=0
    .e  d
    ..///modified by ZY 20220926 2757106
    ..s ListEquip=$g(^DHCEQDisuseList(DLRowID,"EX"))
    ..s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEquip,"34",DRRowID,1)
    ..i SQLCODE s SQLCODE=RLRowID_"^删除业务占用信息失败!"
    ..q:SQLCODE'=0
	..k ^DHCEQDisuseList(DLRowID,"EX")
	
	q SQLCODE
}

/// ----------------------------------
/// 创建:JDL 2011-12-02  JDL0104
/// 描述:删除报废单明细
/// 入参： 
/// 	DelListIDs：明细信息
/// 返回值：SQLCODE^ErrDesc
/// 访问表:DHC_EQDisuseRequest,DHC_EQDisuseList
/// w ##Class(web.DHCEQBatchDisuseRequest).DeleteDisuseList(DelRowIDs)
ClassMethod DeleteDisuseList(DelListIDs)
{
	new Length,DLRowID,i
	
	i DelListIDs="" q 0
	
	s Length=$l(DelListIDs,",")
	for i=1:1:Length  q:SQLCODE'=0  d
	.s DLRowID=$p(DelListIDs,",",i)
	.if (DLRowID>0)  d
	..&SQL(delete from  sqluser.DHC_EQDisuseList where DL_RowID=:DLRowID)
    ..q:SQLCODE'=0
    ..///modified by ZY 20220926 2757106
    ..s ListEquip=$g(^DHCEQDisuseList(DLRowID,"EX"))
    ..s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEquip,"34",DLRowID,1)
    ..i SQLCODE s SQLCODE=RLRowID_"^删除业务占用信息失败!"
    ..q:SQLCODE'=0
	..k ^DHCEQDisuseList(DLRowID,"EX")
	
	q SQLCODE
}

/// ----------------------------------
/// 创建:JDL 2011-12-02  JDL0104
/// 描述:提交报废单
/// 入参： 
/// 	RowID：报废单RowID
/// 返回值：SQLCODE^ErrDesc
/// 访问表:DHC_EQDisuseRequest,DHC_EQDisuseList
/// w ##Class(web.DHCEQBatchDisuseRequest).SubmitData(RowID)
ClassMethod SubmitData(RowID, WeUser As %String = "")
{
	s $ZT="ERRSubmitData"
	new (RowID, WeUser,%session)  ;Add By QW20210511 BUG:QW0104 批量报废bug修改
	n User,Date,Time
	n PLIST,InvalidFlag,CheckFlag
	n ApproveType,MaxPrice
	n ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole,AuditFlag
	n StoreLocDR,KindFlag
	//midified by zy 2015-7-1 ZY0134
	n UnusualStatus,UnusualRemark
	s UnusualStatus="1"
	s UnusualRemark="报废提交"
	//Modify by zx 2020-03-13 BUG ZX0079
	s User=WeUser
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k PLIST
	s Date=+$H
	s Time=$p($H,",",2) 	
 	
 	i RowID'=""
 	{
	 	s InvalidFlag=$Piece($G(^DHCEQDisuseRequest(RowID)),"^",53)
	 	i InvalidFlag="Y" q "-2201^无效单据不能操作!"
 	}
 	else
 	{
	 	q "-2201^没有单据不能操作!"
	}
	
	;Status该记录状态不符合,不能执行操作!
	if $p($g(^DHCEQDisuseRequest(RowID)),"^",10)'="0" q -2015   
    
    ;检查设备是否符合要求
    s CheckFlag=..CheckData(RowID)
    s MaxPrice=$p(CheckFlag,"^",2)
    s CheckFlag=$p(CheckFlag,"^",1)    
    if CheckFlag'=1 q CheckFlag
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
	
	s PLIST(11) = 1	        ;Status
	s PLIST(18) = User	    ;SubmitUserDR
	s PLIST(19) = Date	    ;SubmitDate
	s PLIST(20) = Time		;SubmitTime 		
 	s EquipType=$P(^DHCEQDisuseRequest(RowID),"^",43) 	
 	s KindFlag=$P(^DHCEQDisuseRequest(RowID),"^",44)
 
	//Modified by QW20200303 BUG:QW0042 begin
 	if (KindFlag=2)
 	{
	 	s SQLCODE=##CLASS(web.DHCEQInStockNew).EquipTypeIsUniqueNew(RowID,EquipType,"DisUse")		//Add By DJ 2016-04-01 DJ0177 总单与明细单类组一致性判断
		i SQLCODE<0 q -1011
	 	s SQLCODE=..CheckRepeat(RowID)
	 	i SQLCODE'=0 q SQLCODE
	}
 	//End by QW20200303 BUG:QW0042 end
 	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, "", "", MaxPrice,"")
 	i ApproveSet="" q -4007
 	
 	TSTART
 	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"5",User)
 	i SQLCODE
 	{
 		TROLLBACK
 		q SQLCODE_"^清除原无效审批信息失败!"
 	}
 	//Modify by zx 2020-03-13 BUG ZX0079
	s SQLCODE=..InsertDisuseRequestList(RowID,User)
 	if SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^生成报废明细信息失败!"
	}				
	
 	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
 	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
 	s LastFlag=$P(ApproveFlow,"^",1)
 	s NextStep=$P(ApproveFlow,"^",2)
 	s NextRole=$P(ApproveFlow,"^",3)
 	s AppInfoStatus="1"
	s AuditFlag=0		
	i AutoAuditFlag="Y"
 	{
 		i (NextStep="")||(LastFlag="Y")
 		{
	 		s PLIST(11)="2"
 			s SQLCODE=..LastAuditAction( RowID)
			if SQLCODE'=0
			{
 				TROLLBACK
 				q SQLCODE_"^最后审核生成信息失败!"
			}
			;Modified by jdl 2011-3-10  jdl0073
			s AuditFlag=1
			//midified by zy 2015-7-1 ZY0132 
			s (UnusualStatus,UnusualRemark)=""
			//midified by zx 2016-03-16 ZX0035 
			s AppInfoStatus="2"
 		}
 	}
 	s PLIST(28)=ApproveSet
 	s PLIST(29)=NextRole
 	s PLIST(30)=NextStep
 	s PLIST(31)=""
 	s PLIST(32)=""
	&SQL(update sqluser.DHC_EQDisuseRequest values :PLIST() where DR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^更新报废单信息失败!"
	}
	
 	//midified by zy 2015-7-1 ZY0134 
 	//修改设备显示状态信息
 	;s EquipIDs=##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(RowID)
 	;s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(EquipIDs,UnusualStatus,UnusualRemark)
 	s SQLCODE=##Class(web.DHCEQBatchDisuseRequest).UpdateEQUnusualStatus(RowID,UnusualStatus,UnusualRemark)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^更新设备异常状态信息失败!"
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,PLIST(29),PLIST(30),"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("34", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^创建业务消息失败!"
	}

 	TCOMMIT
 	q 0
ERRSubmitData
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "-2201^ERRSubmitData"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// 创建:JDL 2011-12-05  JDL0104
/// 描述：最终审核时需调用此方法,执行审核中需要处理的数据
/// 	在此处，需调用
/// w ##Class(web.DHCEQBatchDisuseRequest).LastAuditAction(52)
/// ----------------------------------
ClassMethod LastAuditAction(RowID)
{
	n PLIST,Status,DRLRowID,EquipDR
	n User,Date,Time
	n EQName,EQNo,FromLoc,EQStoreLocDR,DisuseType,EQStatus
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k PLIST
	s Date=+$H
	s Time=$p($H,",",2)
	
	i RowID="" q "-2201^没有单据不能操作!"	
	;InvalidFlag
	i $Piece($G(^DHCEQDisuseRequest(RowID)),"^",53)="Y" q "-2201^无效单据不能操作!"	
	;Status该记录状态不符合,不能执行操作!
	if $p($g(^DHCEQDisuseRequest(RowID)),"^",10)="2" q "-2015^该记录状态不符合,不能执行操作!"   ;Status该记录状态不符合,不能执行操作!
	
 	s PLIST(11)="2"
	s PLIST(21)=User
	s PLIST(22)=Date
	s PLIST(23)=Time

 	&sql(update sqluser.DHC_EQDisuseRequest values :PLIST() where DR_RowID=:RowID)
	if SQLCODE'=0
	{
		q SQLCODE
	}
	// Modefied by zc0125 2022-12-12 最终业务处理结果记录 begin
	s SQLCODE=##Class(web.DHCEQ.EM.BUSInventory).SaveDisposeResultByBussType(34,RowID)
	i SQLCODE q SQLCODE
	// Modefied by zc0125 2022-12-12 最终业务处理结果记录 end
 	s DRLRowID=0
	f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",RowID,DRLRowID)) q:(DRLRowID="")||(SQLCODE'=0)  d
	.s EquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	.
	.s EQName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	.s EQNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	.;InvalidFlag
	.i $p($g(^DHCEQEquip(EquipDR)),"^",59)="Y"  s SQLCODE="-2201^"_EQName_"["_EQNo_"]设备已无效!"
	.q:SQLCODE'=0
	.;StockStatus
	.i ($p($g(^DHCEQEquip(EquipDR)),"^",60)'="1")  s SQLCODE="-2201^"_EQName_"["_EQNo_"]库房状态不符合条件!"
	.q:SQLCODE'=0
	.s EQStatus=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	.i (EQStatus>2)  s SQLCODE="-2201^"_EQName_"["_EQNo_"]设备状态不符合条件!"
	.q:SQLCODE'=0
	.
	.s FromLoc=$p($g(^DHCEQDisuseRequest(RowID)),"^",34)
	.s EQStoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
	.i FromLoc'=EQStoreLocDR  s SQLCODE="-2201^"_EQName_"["_EQNo_"]所在库房已经变动,不是申请时使用部门!"
	.q:SQLCODE'=0
	.
	.s LI(2)=EquipDR  //设备
	.s LI(4)=$p($g(^DHCEQEquip(EquipDR)),"^",19)   //原使用科室
	.s LI(5)=$p($g(^DHCEQEquip(EquipDR)),"^",17) //原管理科室
	.s LI(6)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  //原库房
	.s LI(7)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  //原值
	.s LI(8)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  //原净值
	.&sql(update sqluser.DHC_EQEquip  set EQ_Status=3,EQ_DisuseDate=:Date  where EQ_RowID=:EquipDR) //修改设备库房状态
	.q:SQLCODE'=0
	.;Mozy		2020-1-19	共享资源下架操作
	.s SQLCODE=##Class(web.DHCEQ.RM.BUSShareResource).ChangeShareResource(34,RowID,"2")  //Modify by zx 2020-08-28 BUG ZX0105
	.q:SQLCODE'=0
	.s LI(9)=$p($g(^DHCEQEquip(EquipDR)),"^",19)   //变动后使用科室
	.s LI(10)=$p($g(^DHCEQEquip(EquipDR)),"^",17) //变动后管理科室
	.s LI(11)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  //变动后库房
	.s LI(12)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  //变动后原值
	.s LI(13)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  //变动后净值
	.s DisuseType=$p($g(^DHCEQDisuseRequest(RowID)),"^",6) //报废类型
	.i DisuseType'="" s LI(14)=$p($g(^DHCEQCCode("DHCEQCDisuseType",DisuseType)),"^",2)  //变动原因
	.s LI(15)=$p($g(^DHCEQDisuseRequest(RowID)),"^",7)  //变动描述
	.s LI(16)=Date	//变动日期
	.s LI(17)=Time	//变动时间
	.s LI(19)="C"	//生命周期类型
	.s LI(20)=34	//来源类型
	.s LI(21)=DRLRowID	//来源ID
	.s LI(27)=User	//更新人
	.s LI(28)=Date	//更新日期
	.s LI(29)=Time	//更新时间
	.&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	.q:SQLCODE'=0
	.&sql(Update SQLUSER.DHC_EQDisuseRequestList set DRL_Hold1=:EQStatus where DRL_RowID=:DRLRowID)
	.q:SQLCODE'=0
	.//Function:Funds	2012-2-16 生成资金来源信息
	.;Modified by JDL 2012-1-4 JDL0108
	.s SQLCODE=##class(web.DHCEQInStockNew).CreateFundsInfo(6, DRLRowID)
	.q:SQLCODE'=0
	.//begin add  by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段
	.s ReduceInfo="2^"_EquipDR_"^"_$p($g(^DHCEQDisuseRequest(RowID)),"^",49)_"^"_$p($g(^DHCEQDisuseRequest(RowID)),"^",48)_"^"_$p($g(^DHCEQDisuseRequest(RowID)),"^",8)
	.s SQLCODE=##Class(web.DHCEQ.EM.BUSReduceInfo).SaveReduceInfo(ReduceInfo)
	.q:SQLCODE'=0
	.//end add  by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段
	.;Mozy0089	2012-10-17
	.Set SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(6, DRLRowID)
		
    /// modified by ZY 20220926 2757106
    i SQLCODE q SQLCODE
    s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss("","34",RowID,1)
    q SQLCODE
}

/// ----------------------------------
/// 创建:JDL 2011-12-07  JDL0104
/// 描述:审批报废单
/// 入参： 
/// 	val:审批信息 RowID^CurRole^Step^Opinion^Remark
/// 返回值：SQLCODE^ErrDesc
/// 访问表:DHC_EQDisuseRequest,DHC_EQDisuseRequestList
/// w ##Class(web.DHCEQBatchDisuseRequest).AuditData(val)
/// modify by jyp 2020-02-27  JYP0022 报废信息表添加可编辑字段
ClassMethod AuditData(val, editFieldsInfo As %Library.String = "", WeUseID As %String = "", ActionCode As %String = "")
{
	Set $ZT="ERRORAudit"
	new (val, editFieldsInfo,WeUseID,ActionCode,%session)  ;Add By QW20210511 BUG:QW0104 批量报废bug修改
	n User
	n RowID,PLIST
	n ApproveSet, ApproveType,ApproveFlow,LastFlag,AutoAuditFlag,NextRole,AuditFlag,CurRole
	n Opinion,Remark
	//midified by zy 2015-7-1 ZY0134
	n UnusualStatus,UnusualRemark,UnusualFlag
	s UnusualFlag=0	//标记是否修改异常状态信息
	//Modify by zx 2020-03-13 BUG ZX0079
	s User=WeUseID
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	
	//add by zy 2013-06-04 zy0107
	//修改设备的预报废标识
	s approveroleid=##class(web.DHCEQCommon).GetSysInfo("601003")		//哪个角色审批时作为院内审批完成
	k PLIST
	s RowID=$P(val,"^",1)
	i RowID="" q "-2201^没有单据不能操作!"	
	;InvalidFlag
	i $Piece($G(^DHCEQDisuseRequest(RowID)),"^",53)="Y" q "-2201^无效单据不能操作!"	
	;Status该记录状态不符合,不能执行操作!
	if $p($g(^DHCEQDisuseRequest(RowID)),"^",10)'="1" q "-2015^该记录状态不符合,不能执行操作!"   ;Status该记录状态不符合,不能执行操作!
	
	s EquipType=$P(^DHCEQDisuseRequest(RowID),"^",43)			//Add By DJ 2016-04-01	DJ0177 begin 总单与明细单类组一致性判断
	//Modified by QW20200303 BUG:QW0042 begin
	s KindFlag=$P(^DHCEQDisuseRequest(RowID),"^",44)
	if (KindFlag=2)
	{
		s SQLCODE=##CLASS(web.DHCEQInStockNew).EquipTypeIsUniqueNew(RowID,EquipType,"DisUse")
		i SQLCODE<0 q -1011
	}
	//Modified by QW20200303 BUG:QW0042 end
	//Modify by zx 2020-03-13 BUG ZX0079
	s ApproveSet=$p($g(^DHCEQDisuseRequest(RowID)),"^",27)
	//add by zx 2019-11-07 传动作时 根据动作获取角色和步骤
	i ActionCode'="" d
	.s RoleInfo=##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,ActionCode)
	.s CurRole=$p(RoleInfo,"^",1)
	.s RoleStep=$p(RoleInfo,"^",2)
	i $p(val,"^",2)'="" s CurRole=$p(val,"^",2)
	s PLIST(32)=CurRole
	s PLIST(31)=$p(val,"^",3)  //Step
	i PLIST(31)="" s PLIST(31)=RoleStep
	s Opinion=$p(val,"^",4)  //Opinion
	s Remark=$p(val,"^",5)

	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, PLIST(31), PLIST(32))
 	s LastFlag=$p(ApproveFlow,"^",1)
 	s PLIST(30)=$p(ApproveFlow,"^",2)  //NextStep
 	s PLIST(29)=$p(ApproveFlow,"^",3)  //NextRole
 	s AppInfoStatus="1"
 	s AutoAuditFlag=$p($g(^DHCEQCCode("DHCEQCApproveSet",ApproveSet)),"^",9)
 	i AutoAuditFlag="Y" s AppInfoStatus="2"
 	TSTART
	//Modify by zx 2020-03-13 BUG ZX0079
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, RowID, Opinion, Remark, PLIST(32), PLIST(31), User)
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^生成审批信息失败!"
	}
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,PLIST(29),PLIST(30),PLIST(31),PLIST(32),AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	//begin modify by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段
	if editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)		//编辑要修改的字段
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^修改编辑字段信息失败!"
		}
	}
	//end modify by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段

	s AuditFlag=0
	i AutoAuditFlag="Y"
	{
 		i (PLIST(30)="")||(LastFlag="Y")
 		{
	 		s PLIST(11)="2"
 			s SQLCODE=..LastAuditAction(RowID)
			if SQLCODE'=0
			{
 				TROLLBACK
 				q SQLCODE_"^最后审核生成信息失败!"
			}
			s AuditFlag=1
			//midified by zy 2015-7-1 ZY0134 
			s UnusualFlag=1
			s (UnusualStatus,UnusualRemark)=""
 		}
	}
	
	&sql(update sqluser.DHC_EQDisuseRequest values :PLIST() where DR_RowID=:RowID)
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^更新报废单信息失败!"
	}
		
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("34", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^生成业务消息失败!"
	}
	
	//add by zy 2013-06-04 zy0107
	//修改设备的预报废标识
	i (approveroleid=CurRole)
	{
	 	//midified by zy 2015-7-1 ZY0134
		s UnusualStatus="2"
		s UnusualRemark="预报废"
		s UnusualFlag=1
		/*
		s SQLCODE=##Class(web.DHCEQBatchDisuseRequest).UpdatePreDisuseFlag(RowID,"Y")
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^修改台帐预报废标识失败!"
		}*/
	}
 	//midified by zy 2015-7-1 ZY0134 
 	//修改设备显示状态信息
 	if UnusualFlag=1
 	{
	 	s EquipIDs=##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(RowID)
	 	s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(EquipIDs,UnusualStatus,UnusualRemark)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^更新设备异常状态信息失败!"
		}
	}
	TCOMMIT
 	q 0
	 
ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "-2201^ERRORAudit"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// 创建:JDL 2011-12-05  JDL0104
/// 描述:取消提交报废单
/// 入参： 
/// 	RowID：报废单RowID
/// 返回值：SQLCODE^ErrDesc
/// 访问表:DHC_EQDisuseRequest,DHC_EQDisuseRequestList
/// w ##Class(web.DHCEQBatchDisuseRequest).CancelSubmitData(RowID)
ClassMethod CancelSubmit(val, User As %String = "", ActionCode As %String = "")
{
	s $ZT="ERRCancelSubmit"
	//Modify by zx 2020-03-13 BUG ZX0079
	n Date,Time
	n PLIST,InvalidFlag,CheckFlag
	n ApproveType,MaxPrice
	n StoreLocDR,KindFlag
	
	n RowIDs,Count,flag,Opinion,Remark,EQStatus,EQStockStatus,drlrowid,DisuseType
	n ApproveSet,NextApproveFlow,NextStep,NextRole,AutoAuditFlag,LastFlag
	n CancelToFlowDR,CancelFlag,CurRole,Step,AFRowID,PLIST,ApproveRoleDR
	//midified by zy 2015-7-1 ZY0134 
	n UnusualStatus,UnusualRemark,UnusualFlag
	s UnusualFlag=0
	//Modify by zx 2020-03-13 BUG ZX0079
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k PLIST
	s Date=+$H
	s Time=$p($H,",",2) 	
 	
 	s RowID=$P(val,"^",1)
 	i RowID'=""
 	{
	 	s InvalidFlag=$Piece($G(^DHCEQDisuseRequest(RowID)),"^",53)
	 	i InvalidFlag="Y" q "-2201^无效单据不能操作!"
 	}
 	else
 	{
	 	q "-2201^没有单据不能操作!"
	}
	
	;Status该记录状态不符合,不能执行操作!
	if $p($g(^DHCEQDisuseRequest(RowID)),"^",10)'="1" q -2015 
	
	
	s PLIST(11)="0"   //报废单状态
	s PLIST(24)=$P(val,"^",2) ;拒绝原因
	s PLIST(25)=User
	s PLIST(26)=Date
	s PLIST(27)=Time
	
		
	s ApproveSetDR=$p($g(^DHCEQDisuseRequest(RowID)),"^",27)
	
	//add by zy 2013-06-04 zy0107
	//修改设备的预报废标识
	s approveroleid=##class(web.DHCEQCommon).GetSysInfo("601003")		//哪个角色审批时作为院内审批完成
	s approverolestep=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSetDR,approveroleid,0))
	i approverolestep'="" s approverolestep=$p($g(^DHCEQCCode("DHCEQCApproveFlow",approverolestep)),"^",3)
	
	s CurRole=$P(val,"^",3)
	//Modify by zx 2020-03-13 BUG ZX0079
	i ActionCode'="" d
	.s RoleInfo=##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSetDR,ActionCode)
	.s CurRole=$p(RoleInfo,"^",1)
	.s RoleStep=$p(RoleInfo,"^",2)
	
	s CancelToFlowDR=""
	s CancelFlag="N"
	s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSetDR,CurRole,0))
	i AFRowID'="" d
	.s CancelFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",5)
	.s CancelToFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",6)
	i CancelFlag'="Y" q -1006		;该步骤未设置为可取消
	
	s (ApproveRoleDR,Step)=""
	i CancelToFlowDR'=""
	{
		s PLIST(11)="1"
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
 		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s PLIST(29)=ApproveRoleDR
	 	s PLIST(30)=Step
	 	
		//midified by zy 2015-7-1 ZY0134 
		//修改设备显示状态信息
		i (approveroleid'="")&(approverolestep<Step)   //modified by wy 2020-4-20 1276898院内报废审批完结审批角色退回的时候异常状态没有改变   //modify by jyp 2023-04-20 判断错误
		{
			s UnusualStatus="2"
			s UnusualRemark="预报废"
		}
		else
		{
			s UnusualStatus="1"
			s UnusualRemark="报废提交"
		}
 		s UnusualFlag=1
	}
 	else
 	{
	 	s PLIST(29)=""
 		s PLIST(30)=""
 		//midified by zy 2015-7-1 ZY0134
 		s UnusualStatus=""
 		s UnusualRemark=""
 		s UnusualFlag=1
	}
 	s PLIST(31)=""
 	s PLIST(32)=""
	
	TSTART
	/*
	//add by zy 2013-06-04 zy0107
	//修改设备的预报废标识,必须在删除报废明细之前修改设备预报废标记。
	i (approveroleid'="")&(approverolestep>=Step)
	{
		s SQLCODE=##Class(web.DHCEQBatchDisuseRequest).UpdatePreDisuseFlag(RowID,"N")
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^修改台帐预报废标识失败!"
		}
	}*/
 	//midified by zy 2015-7-1 ZY0134 
 	//Add By QW20200512 BUG:QW0063 begin ;生成审批记录
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("5", RowID)
	s RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,$P(val,"^",2),"",CurRole,RoleStep,User,"1")
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	//Add By QW20200512 BUG:QW0063 End 修改返回值
 	//修改设备显示状态信息
 	s EquipIDs=##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(RowID)
 	s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(EquipIDs,UnusualStatus,UnusualRemark)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^更新设备异常状态信息失败!"
	}
	;仅当取消到新增时，才删除报废明细
	if (PLIST(11)=0)&&($D(^DHCEQDisuseRequestList(0,"DisuseRequest",RowID)))
	{	
	    //add by wy 2020-4-30 1288746 无效对应汇总明细
		s DRMergeOrderFlag=$p($g(^DHCEQDisuseRequest(RowID)),"^",54)
		if (DRMergeOrderFlag="Y")
	 	{
			;Modified By QW20210525 BUG:QW0114
			&SQL(delete from  sqluser.DHC_EQMergeOrderList where ML_SourceID=:RowID)
			i SQLCODE
 			{
				TROLLBACK
				q SQLCODE_"^无效对应汇总明细信息失败"
 			}
		 }	
	    s PLIST(55)="N"						
		&SQL(delete from  SQLUSER.DHC_EQDisuseRequestList where DRL_DisuseRequestDR=:RowID)
		i SQLCODE
 		{
			TROLLBACK
			q SQLCODE_"^删除报废明细信息失败"
 		}
	}
	 	
	&SQL(update sqluser.DHC_EQDisuseRequest values :PLIST() where DR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^更新报废单信息失败!"
	}
 	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSetDR,RowID,ApproveRoleDR,Step,"","",PLIST(11),"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}	
	s ApproveFlow=""
	s CurRole=$P(val,"^",3)
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSetDR
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("34", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^创建业务消息失败!"
	}
	
 	TCOMMIT
 	q 0
ERRCancelSubmit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "-1^ERRCancelSubmit"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// 创建:JDL 2011-12-05  JDL0104
/// 描述:检查报废单信息是否完整、正确
/// 入参： 
/// 	RowID：报废单RowID
/// 返回值：CheckFlag^MaxPrice^ErrDesc
/// w ##Class(web.DHCEQBatchDisuseRequest).CheckData(RowID)
ClassMethod CheckData(RowID)
{
	n KindFlag,MaxPrice,ListID,EquipTypeDR,StoreLocDR
	n EquipIDs,EquipID,Len,CheckFlag,i
	
	s MaxPrice=0
	s CheckFlag=1
	s StoreLocDR=$P(^DHCEQDisuseRequest(RowID),"^",34)
	s EquipTypeDR=$P(^DHCEQDisuseRequest(RowID),"^",43)	
	s KindFlag=$P(^DHCEQDisuseRequest(RowID),"^",44)
	
	if KindFlag=0  d
	.s EquipID=$P(^DHCEQDisuseRequest(RowID),"^",1)
	.d CheckEquip	
	else  if KindFlag=1  d
	.s EquipIDs=$g(^DHCEQDisuseRequest(RowID,"EX"))
	.s Len=$l(EquipIDs,",")
	.for i=1:1:Len  q:(CheckFlag'=1)  d
	..s EquipID=$p(EquipIDs,",",i)
	..d CheckEquip
	else  d
	.;多批
	.s ListID=0
	.f  s ListID=$o(^DHCEQDisuseList(0,"Request",RowID,ListID))  quit:((ListID="")||(CheckFlag'=1))  d
	..i $p(^DHCEQDisuseList(ListID),"^",2)=0  d
	...s EquipID=$P(^DHCEQDisuseRequest(RowID),"^",1)
	...d CheckEquip
	..e  d
	...s EquipIDs=$g(^DHCEQDisuseRequest(RowID,"EX"))
	...s Len=$l(EquipIDs,",")
	...for i=1:1:Len  q:(CheckFlag'=1)  d
	....s EquipID=$p(EquipIDs,",",i)
	....d CheckEquip
			
	q CheckFlag_"^"_MaxPrice
	
CheckEquip
	if EquipID="" q
	;过滤出库状态、本月入库设备
	i +$p(^DHCEQEquip(EquipID),"^",60)="3"
	{
		s CheckFlag=-1008
		q 
	}
	i +$p(^DHCEQEquip(EquipID),"^",60)="0"
	{
		s CheckFlag=-1008
		q 
	}
	;过滤掉无效的
	i $p(^DHCEQEquip(EquipID),"^",59)="Y"
	{
		s CheckFlag=-1009
		q 
	}
	;报废状态的过滤
	i (+$p(^DHCEQEquip(EquipID),"^",38))>2
	{
		s CheckFlag=-1010
		q 
	}
	
	;检查设备科室
	i (+$p(^DHCEQEquip(EquipID),"^",67))'=StoreLocDR
	{
		s CheckFlag=-1008
		q 
	}
	
	;检查设备类组
	i (+$p(^DHCEQEquip(EquipID),"^",63))'=EquipTypeDR
	{
		s CheckFlag=-1011
		q 
	}
	if ($p($g(^DHCEQEquip(EquipID)),"^",27)>MaxPrice) s MaxPrice=$p($g(^DHCEQEquip(EquipID)),"^",27)
}

/// Add by JDL 2011-12-8 JDL0104
/// 查看设备是不是已经存在其他的单据中,以避免冲突,或者设备是否有效
/// 主要检查以下业务：转移、减少、报废、维修 
/// 返回结果: 是，返回1；否则，返回0
/// 入参： SourceType：类型，1转移单 2退货单 3报废单 4维修 5拆分
///         SourceID：业务单 主单ID
///         EquipDR：要检测的设备
///         FromLocDR：设备所在科室
///         ExcludeIDs:排除在外的设备ID串,主要是排除本单中其他明细中占用的设备
/// 			CheckFlag:判断返回值标识
/// w ##Class(web.DHCEQBatchDisuseRequest).CheckEquipDR("","","1","","","Y")
ClassMethod CheckEquipDR(SourceType, SourceID, EquipDR, FromLocDR, ExcludeIDs, CheckFlag As %String = "")
{
    n Status,Flag,RowID,MXRowID,EquipIDs,KindFlag,LocDR
    
    i EquipDR="" q 0    
    ;本单中已经有其他明细占用了此设备
    if (","_ExcludeIDs_",")[(","_EquipDR_",") q 1
    ;未传入科室，无法判断
    ;i FromLocDR="" q 0 
    s Flag=0
    s Info=""
    ;过滤掉报废或其他设备
    s Status=$p($g(^DHCEQEquip(EquipDR)),"^",38)
    if Status>2 q 1
    ;过滤掉非正常在科室库的设备 StockStatus
    i $p($g(^DHCEQEquip(EquipDR)),"^",60)'=1 q 1
    ;过滤掉无效设备
    i $p($g(^DHCEQEquip(EquipDR)),"^",59)'="N" q 1
    
    ;判断转移单
    s Status=""
    f  s Status=$o(^DHCEQStoreMove(0,"StatusFromLoc",Status))  q:(Status="")||(Flag'=0)  d
    .;只需判断 尚未转移完成的
    .q:(Status'=0)&&(Status'=1)
    .s LocDR=0
    .f  s LocDR=$o(^DHCEQStoreMove(0,"StatusFromLoc",Status,LocDR))  q:(LocDR="")||(Flag'=0)  d
    ..q:((FromLocDR'="")&&(FromLocDR'=LocDR))
    ..s RowID=0
    ..f  s RowID=$o(^DHCEQStoreMove(0,"StatusFromLoc",Status,LocDR,RowID))  q:(RowID="")||(Flag'=0)  d
    ...;过滤掉无效的InvalidFlag
    ...q:$p($g(^DHCEQStoreMove(RowID)),"^",27)="Y"
    ...;过滤掉本单据的
    ...q:(RowID=SourceID)&&(SourceType=1)
    ...s MXRowID=0
    ...f  s MXRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,MXRowID))  q:(MXRowID="")||(Flag'=0)  d
    ....s EquipIDs=$g(^DHCEQStoreMoveList(MXRowID,"EX","RowIDs"))
    ....i (","_EquipIDs_",")[(","_EquipDR_",") d
    .....s Flag=1 
    .....s Info="设备编号"_$p($g(^DHCEQEquip(EquipDR)),"^",71)_"已处于转移单据"_$p($g(^DHCEQStoreMove(RowID)),"^",1)_"占用"   //modefied by by zc 2017-08-29 ZC0032 begin
	
	//modefied by by zc 2017-08-29 ZC0032 begin
	i (Flag'=0)
	{
		i CheckFlag="Y" q Flag_"^"_Info
		q Flag
	}
	//modefied by by zc 2017-08-29 ZC0032  end
	
    ;判断退货及减少单
    s Status=""
    f  s Status=$o(^DHCEQReturn(0,"StatusReturnLoc",Status))  q:(Status="")||(Flag'=0)  d
    .;只需判断 尚未减少完成的
    .q:(Status'=0)&&(Status'=1)
    .s LocDR=0
    .f  s LocDR=$o(^DHCEQReturn(0,"StatusReturnLoc",Status,LocDR)) q:(LocDR="")||(Flag'=0)  d
    ..q:((FromLocDR'="")&&(FromLocDR'=LocDR))
    ..s RowID=0
    ..f  s RowID=$o(^DHCEQReturn(0,"StatusReturnLoc",Status,LocDR,RowID)) q:(RowID="")||(Flag'=0)  d
    ...;过滤掉无效的InvalidFlag
    ...q:$p($g(^DHCEQReturn(RowID)),"^",28)="Y"
    ...;过滤掉本单据的
    ...q:(RowID=SourceID)&&(SourceType=2)
    ...s MXRowID=0
    ...f  s MXRowID=$o(^DHCEQReturnList(0,"Return",RowID,MXRowID)) q:(MXRowID="")||(Flag'=0)  d
    ....s EquipIDs=$g(^DHCEQReturnList(MXRowID,"EX","RowIDs"))
    ....i (","_EquipIDs_",")[(","_EquipDR_",") d
    .....s Flag=1
    .....i $p($g(^DHCEQReturn(RowID)),"^",17)="1" d
    ......s Info="设备编号"_$p($g(^DHCEQEquip(EquipDR)),"^",71)_"已处于退货单据"_$p($g(^DHCEQReturn(RowID)),"^",1)_"占用" //modefied by by zc 2017-08-29 ZC0032 begin
    .....e  d
    ......s Info="设备编号"_$p($g(^DHCEQEquip(EquipDR)),"^",71)_"已处于减少单据"_$p($g(^DHCEQReturn(RowID)),"^",1)_"占用" //modefied by by zc 2017-08-29 ZC0032 end 

	//modefied by by zc 2017-08-29 ZC0032 begin
	i (Flag'=0)
	{
		i CheckFlag="Y" q Flag_"^"_Info
		q Flag
	}
	//modefied by by zc 2017-08-29 ZC0032 end
	
    ;判断报废单
    s Status=""
    f  s Status=$o(^DHCEQDisuseRequest(0,"Status",Status))  q:(Status="")||(Flag'=0)  d
    .;只需判断 尚未报废完成的
    .q:(Status'=0)&&(Status'=1)
    .s RowID=0
    .f  s RowID=$o(^DHCEQDisuseRequest(0,"Status",Status,RowID)) q:(RowID="")||(Flag'=0)  d
    ..;过滤掉无效的InvalidFlag
    ..q:$p($g(^DHCEQDisuseRequest(RowID)),"^",53)="Y"
    ..;过滤掉本单据的
    ..q:(RowID=SourceID)&&(SourceType=3)
    ..s KindFlag=$p($g(^DHCEQDisuseRequest(RowID)),"^",44)
    ..i KindFlag=0  d
    ...if $P(^DHCEQDisuseRequest(RowID),"^",1)=EquipDR d
    ....s Flag=1
    ....s Info="设备编号"_$p($g(^DHCEQEquip(EquipDR)),"^",71)_"已处于报废单据"_$p($g(^DHCEQDisuseRequest(RowID)),"^",33)_"占用"   //modefied by by zc 2017-08-29 ZC0032 begin
    ..else  if KindFlag=1  d
    ...s EquipIDs=$g(^DHCEQDisuseRequest(RowID,"EX"))
    ...i (","_EquipIDs_",")[(","_EquipDR_",") d
    ....s Flag=1
    ....s Info="设备编号"_$p($g(^DHCEQEquip(EquipDR)),"^",71)_"已处于报废单据"_$p($g(^DHCEQDisuseRequest(RowID)),"^",33)_"占用" 
    ..e  d
    ...s MXRowID=0
    ...f  s MXRowID=$o(^DHCEQDisuseList(0,"Request",RowID,MXRowID)) q:(MXRowID="")||(Flag'=0)  d
    ....i $p(^DHCEQDisuseList(MXRowID),"^",2)=0  d
    .....i $P(^DHCEQDisuseList(MXRowID),"^",3)=EquipDR d
    ......s Flag=1
    ......s Info="设备编号"_$p($g(^DHCEQEquip(EquipDR)),"^",71)_"已处于报废单据"_$p($g(^DHCEQDisuseRequest(RowID)),"^",33)_"占用" 
    ....e  d
    .....s EquipIDs=$g(^DHCEQDisuseList(MXRowID,"EX"))
    .....i (","_EquipIDs_",")[(","_EquipDR_",") d
    ......s Flag=1
    ......s Info="设备编号"_$p($g(^DHCEQEquip(EquipDR)),"^",71)_"已处于报废单据"_$p($g(^DHCEQDisuseRequest(RowID)),"^",33)_"占用"  //modefied by by zc 2017-08-29 ZC0032 end
    
    //modefied by by zc 2017-08-29 ZC0032
	i (Flag'=0)
	{
		i CheckFlag="Y" q Flag_"^"_Info
		q Flag
	}

    
    ;判断维修单
    s MExObjID=""
	s MaintRequestNo=""
	s MExObjID=$o(^DHCEQMExObj(0,"ExID",1,EquipDR,0))   //在账维修对象
	i MExObjID="" 
	{
		i CheckFlag="Y" q Flag_"^"_Info
		q Flag
	}
	i MExObjID'="" d
	.s MMRowID=0
	.f  s MMRowID=$o(^DHCEQMMaintRequest(0,"Source",1,MExObjID,MMRowID)) q:(MMRowID="")||(Flag'=0)  d
	..q:(MMRowID=SourceID)&&(SourceType=4)                  //add by wy 20190301
	..q:($p($g(^DHCEQMMaintRequest(MMRowID)),"^",57)="Y")	//过滤无效数据
	..q:($p($g(^DHCEQMMaintRequest(MMRowID)),"^",41)=2)     //过滤已完成的维修单据
	..q:($p($g(^DHCEQMMaintRequest(MMRowID)),"^",41)=3)     // MZY0134	2951953		2022-09-20
	..s Flag=1
	..s Info="设备编号为"_$p($g(^DHCEQEquip(EquipDR)),"^",71)_"已处于维修单据"_$p($g(^DHCEQMMaintRequest(MMRowID)),"^",1)_"中"
   
    i (Flag'=0)
	{
		i CheckFlag="Y" q Flag_"^"_Info
		q Flag
	}
	
	;判断拆分单 czf 2014955 2021-07-28 begin
    s srowid=""
    f  s srowid=$o(^DHCEQSplit(srowid))  q:(srowid="")||(Flag'=0)  d
    .s Status=$p(^DHCEQSplit(srowid),"^",22)
    .q:(Status'=0)&&(Status'=1)
    .s LocDR=$p(^DHCEQSplit(srowid),"^",11)
    .q:((FromLocDR'="")&&(FromLocDR'=LocDR))
    .q:$p($g(^DHCEQSplit(srowid)),"^",27)="Y"
    .q:(srowid=SourceID)&&(SourceType=5)	//过滤本单设备
    .s MXRowID=0
    .f  s MXRowID=$o(^DHCEQSplitList(0,"Split",srowid,MXRowID))  q:(MXRowID="")||(Flag'=0)  d
    ..s EquipIDs=$g(^DHCEQSplitList(MXRowID,"EX","RowIDs"))
    ..i (","_EquipIDs_",")[(","_EquipDR_",") d
    ...s Flag=1 
    ...s Info="设备编号"_$p($g(^DHCEQEquip(EquipDR)),"^",71)_"已处于拆分单据"_$p($g(^DHCEQSplit(RowID)),"^",1)_"占用"
	
	i (Flag'=0)
	{
		i CheckFlag="Y" q Flag_"^"_Info
		q Flag
	}
	;判断拆分单 czf 2014955 2021-07-28 end
	
	q Flag
}

/// 2012-01-04 DJ
/// 描述:多批报废设备重复记录判断
ClassMethod CheckRepeat(RowID)
{
	s ListID=0
	s Find=0
	s CurRow=0
	k ^DHCEQTemp("DisuseCheckRepeat",$J)
	f  s ListID=$o(^DHCEQDisuseList(0,"Request",RowID,ListID))  quit:((ListID="")||(Find'=0))  d
	.s CurRow=CurRow+1
	.i $p(^DHCEQDisuseList(ListID),"^",2)=0  d
	..s EquipID=$P($G(^DHCEQDisuseList(ListID)),"^",3)
	..i $d(^DHCEQTemp("DisuseCheckRepeat",$J,EquipID))  d
	...s Find=1
	..e  d
	...s ^DHCEQTemp("DisuseCheckRepeat",$J,EquipID)=1
	.e  d
	..s EquipIDs=$g(^DHCEQDisuseList(ListID,"EX"))
	..s Len=$l(EquipIDs,",")
	..for i=1:1:Len  q:(Find'=0)  d
	...s EquipID=$p(EquipIDs,",",i)
	...q:EquipID=""
	...i $d(^DHCEQTemp("DisuseCheckRepeat",$J,EquipID))  d
	....s Find=1
	...e  d
	....s ^DHCEQTemp("DisuseCheckRepeat",$J,EquipID)=1
	k ^DHCEQTemp("DisuseCheckRepeat",$J)
	i Find=0 q Find
	q "-2201^(序号:"_CurRow_",ListRowID="_ListID_")设备数据重复"
}

/*
/// add by zy 2013-06-04 zy0107
/// 描述:多批报废设备重复记录判断
/// w ##Class(web.DHCEQBatchDisuseRequest).UpdatePreDisuseFlag(1,"Y")
ClassMethod UpdatePreDisuseFlag(RowID, value)
{
	new DRLRowID,EquipDR,SQLCODE
	s (SQLCODE,DRLRowID)=0
	f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",RowID,DRLRowID)) q:(DRLRowID="")||(SQLCODE'=0)  d
	.s EquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	.&sql(update sqluser.DHC_EQEquip  set EQ_AdvanceDisFlag=:value where EQ_RowID=:EquipDR)
	.q:SQLCODE'=0
	q SQLCODE
}
*/
/// add by zc 2015-04-08 zc0022
/// 描述:多批次报废打印要求数据
/// Modified By QW20191022 BUG:QW0032 修改打印错误
/// w ##Class(web.DHCEQBatchDisuseRequest).GetList(9)
ClassMethod GetList(DisuseRequestDR As %Library.String = "")
{
	s Data=""
	s Num=0
	//Add By QW20191022 BUG:QW0032
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set SplitNumCode=##class(web.DHCEQCommon).GetSysInfo("990026")
	//End By QW20191022 BUG:QW0032
	s DisuseReseon=$p($g(^DHCEQDisuseList(DisuseRequestDR)),"^",7)
	s (sumFee,sumQty)=0
	s Rowid=0
	f  s Rowid=$o(^DHCEQDisuseList(Rowid))  quit:Rowid=""  d
	.s (ManuFactory,Model,Unit,SourceType,EquipNo)=""
	.s DRRowID=$p($g(^DHCEQDisuseList(Rowid)),"^",1)
	.q:DRRowID'=DisuseRequestDR
	.s SourceType=$p($g(^DHCEQDisuseList(Rowid)),"^",2)
	.i SourceType="0" d
	..s EquipDR=$p($g(^DHCEQDisuseList(Rowid)),"^",3)
	..s EquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	..s ManuFactoryDR=$p($g(^DHCEQEquip(EquipDR)),"^",26) //生产厂商
	..i ManuFactoryDR '=""  d
	...s ManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //CZF0093
	..s ModelDR=$p($g(^DHCEQEquip(EquipDR)),"^",3) //规格
	..i ModelDR '=""  d
	...s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	..s UnitDR=$p($g(^DHCEQEquip(EquipDR)),"^",5) //单位
	..i UnitDR '=""  d
	...s Unit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	..s QuantityNum=$p($g(^DHCEQDisuseList(Rowid)),"^",4)
	..s OriginalFee=$p($g(^DHCEQDisuseList(Rowid)),"^",9)
	..s AllFee=QuantityNum*OriginalFee
	..s InStockDate=$p($g(^DHCEQEquip(EquipDR)),"^",45)
    ..i InStockDate'="" s InStockDate=$zd(InStockDate,3)
    ..s UseYearNum=$p($zd($h,3),"-",1)-$p(InStockDate,"-",1)
	..;i InStockDate'="" s InStockDate=$ZD(InStockDate,3)
	..;日期格式统一调整
	..//s InStockDate=##Class(web.DHCEQCommon).TransValueFromPage(InStockDate,"date")
	..s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	..s LimitYearNum=$p($g(^DHCEQEquip(EquipDR)),"^",31)
	..s sumFee=sumFee+AllFee
	..s sumQty=sumQty+QuantityNum
	.. ;Modified By QW20191022 BUG:QW0032  设备名称    规格    单位  生产厂商    入库日期      数量         单价          金额    设备编号
	..s Data=Data_SplitRowCode_EquipName_"^"_Model_"^"_Unit_"^"_ManuFactory_"^"_InStockDate_"^"_QuantityNum_"^"_OriginalFee_"^"_AllFee_"^"_EquipNo_"^"_LimitYearNum_"^"_UseYearNum_"^"_DisuseReseon
	..s Num=Num+1
	.e  i SourceType="1" d
	..s RowIDs=$g(^DHCEQDisuseList(Rowid,"EX"))
	..s EquipName=$p($g(^DHCEQEquip($p(RowIDs,",",1))),"^",1)
	..s LimitYearNum=$p($g(^DHCEQEquip($p(RowIDs,",",1))),"^",31) //年限
	..s ManuFactoryDR=$p($g(^DHCEQEquip($p(RowIDs,",",1))),"^",26) //生产厂商
	..i ManuFactoryDR '=""  d
	...s ManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR)),"^",1) //CZF0093
	..s ModelDR=$p($g(^DHCEQEquip($p(RowIDs,",",1))),"^",3) //规格
	..i ModelDR '=""  d
	...s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	..s UnitDR=$p($g(^DHCEQEquip($p(RowIDs,",",1))),"^",5) //单位
	..i UnitDR '=""  d
	...s Unit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	..s QuantityNum=$p($g(^DHCEQDisuseList(Rowid)),"^",4)
	..s OriginalFee=$p($g(^DHCEQDisuseList(Rowid)),"^",9)
	..s AllFee=QuantityNum*OriginalFee
	..s InStockDate=$p($g(^DHCEQEquip($p(RowIDs,",",1))),"^",45)
	..;i InStockDate'="" s InStockDate=$ZD(InStockDate,3)
    ..i InStockDate'="" s InStockDate=$zd(InStockDate,3)
    ..s UseYearNum=$p($zd($h,3),"-",1)-$p(InStockDate,"-",1)
	..;日期格式统一调整
	..//s InStockDate=##Class(web.DHCEQCommon).TransValueToPage(InStockDate,"date")
	..s count=$l(RowIDs,",")
	..f i=1:1:count d
	...s equipdr=$p(RowIDs,",",i)
	...i EquipNo '="" s EquipNo = EquipNo_","
	...s EquipNo = EquipNo_$p($g(^DHCEQEquip(equipdr)),"^",71)
	..s sumFee=sumFee+AllFee
	..s sumQty=sumQty+QuantityNum
	..;Modified By QW20191022 BUG:QW0032     设备名称    规格    单位  生产厂商    入库日期      数量         单价          金额    设备编号
	..s Data=Data_SplitRowCode_EquipName_"^"_Model_"^"_Unit_"^"_ManuFactory_"^"_InStockDate_"^"_QuantityNum_"^"_OriginalFee_"^"_AllFee_"^"_EquipNo_"^"_LimitYearNum_"^"_UseYearNum_"^"_DisuseReseon
	..s Num=Num+1
	i Data'=""  d
	.s sumRMB=##Class(web.DHCEQCommon).RMBDXXZH("","",sumFee)
	.;Modified By QW20191022 BUG:QW0032
	.s Data=Data_SplitRowCode_"合计"_"^"_"^"_"^"_"^"_sumQty_"^"_"^"_sumFee_"^"_sumRMB_"^"_"^"_"^"_"^"
	.s Num=Num+1
	q Data_SplitNumCode_Num ;Modified By QW20191022 BUG:QW0032
}

/// midified by zy 2015-7-1 ZY0134 
/// w ##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(4)
ClassMethod GetDisuseEquipIDs(RowID)
{
	new KindFlag,EquipIDs,ListID
	s EquipIDs=""
	s KindFlag = $p($g(^DHCEQDisuseRequest(RowID)),"^",44)
	If KindFlag=0
	{
		s EquipIDs=$p($g(^DHCEQDisuseRequest(RowID)),"^",1)
	}
	elseif KindFlag=1
	{
		s EquipIDs=$g(^DHCEQDisuseRequest(RowID,"EX"))
	}
	elseif KindFlag=2
	{
		s ListID=0
		f  s ListID=$o(^DHCEQDisuseList(0,"Request",RowID,ListID))  quit:ListID=""  d
		.
		.i $p(^DHCEQDisuseList(ListID),"^",2)=0  d
		..i EquipIDs=""  d
		...s EquipIDs=$P($g(^DHCEQDisuseList(ListID)),"^",3)
		..e  d
		...s EquipIDs=EquipIDs_","_$P($g(^DHCEQDisuseList(ListID)),"^",3)
		.e  d
		..i EquipIDs=""  d
		...s EquipIDs=$g(^DHCEQDisuseList(ListID,"EX"))
		..e  d
		...s EquipIDs=EquipIDs_","_$g(^DHCEQDisuseList(ListID,"EX"))
	}
	quit EquipIDs
}

/// 批量报废设备处理.
/// add by zy zy0155 2016-12-25
/// d ##class(%ResultSet).RunQuery("web.DHCEQBatchDisuseRequest","GetImportDisuseEquipList","17012")
Query GetImportDisuseEquipList(Job As %String = "", DisplayFlag As %String = "") As %Query(ROWSPEC = "Job:%String,TEquipName:%String,TModel:%String,TNo:%String,TFileNo:%String,TStoreLoc:%String,TStatus:%String,TEquipType:%String,TTransAssetDate:%String,TOriginalFee:%String,TNetFee:%String,TDepreTotalFee:%String,TFlag:%String,TFlagRemark:%String")
{
}

ClassMethod GetImportDisuseEquipListExecute(ByRef qHandle As %Binary, Job As %String = "", DisplayFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=2
	s (TotalQyt,TotalOriginalFee,TotalNetFee,TotalDepreFee)=0

	i $Data(^DHCEQTemp("DisuseEquipIDs",Job))
	{
		s StoreLocID=0
		f  s StoreLocID=$o(^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID)) q:StoreLocID=""  d
		.s TStoreLocDR=StoreLocID
		.s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
		.s EquipTypeID=0
		.f  s EquipTypeID=$o(^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID)) q:EquipTypeID=""  d
		..s TEquipTypeDR=EquipTypeID
		..s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
		..s TEquipID=0
		..f  s TEquipID=$o(^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID,TEquipID)) q:TEquipID=""  d
		...s CheckResult=$g(^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID,TEquipID))
		...s TFlag=$p(CheckResult,"^",1)
		...s TFlagRemark=$p(CheckResult,"^",2)
		...q:(DisplayFlag'="")&&(DisplayFlag'=TFlag)
		...s EquipData=$g(^DHCEQEquip(TEquipID))
		...s TEquipName=$p(EquipData,"^",1)
		...s TModelDR = $p(EquipData,"^",3)
		...s TModel = ##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
		...s TOriginalFee =##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",27),"")
		...s TNetFee =##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",28),"")
		...s TDepreTotalFee =##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",35),"")
		...s TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",45),"date")
		...s TNo = $p(EquipData,"^",71)
		...s TFileNo = $p(EquipData,"^",85)
		...s TStatus=##Class(web.DHCEQEquip).GetEquipStatusDisplay($p(EquipData,"^",38))
		...s TotalQyt=TotalQyt+1
		...s TotalOriginalFee=TotalOriginalFee+TOriginalFee
		...s TotalNetFee=TotalNetFee+TNetFee
		...s TotalDepreFee=TotalDepreFee+TDepreTotalFee
		...d OutputRowGetImportDisuseEquipList
	}
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s index=1
		i TotalFlag="2" s index=index+1
		i TotalFlag="3" s index=0
		d ResetVariableGetImportDisuseEquipList
		s TNo="合计"
		s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TotalOriginalFee,"")
		s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TotalNetFee,"")
		s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalDepreFee,"")
		s TEquipName="数量:"_TotalQyt
		d OutputRowGetImportDisuseEquipList
	}
	Quit $$$OK
	
OutputRowGetImportDisuseEquipList
	s Data=$lb(Job,TEquipName,TModel,TNo,TFileNo,TStoreLoc,TStatus,TEquipType,TTransAssetDate,TOriginalFee,TNetFee,TDepreTotalFee,TFlag,TFlagRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariableGetImportDisuseEquipList
	s (TEquipName,TModel,TNo,TFileNo,TStoreLoc,TStatus,TEquipType,TTransAssetDate,TOriginalFee,TNetFee,TDepreTotalFee,TFlag,TFlagRemark)=""
	quit
}

ClassMethod GetImportDisuseEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetImportDisuseEquipListExecute ]
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

ClassMethod GetImportDisuseEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetImportDisuseEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*
/// add by zy zy0155 2016-12-25
/// 批量报废设备处理.
/// 参数说明：
/// 		Job:			记录导入数据的唯一jobID
/// 返回值：0  正常; 
/// w ##Class(web.DHCEQBatchDisuseRequest).InitDisuseEquip(7076)
ClassMethod InitDisuseEquip(Job)
{
	k ^DHCEQTemp("DisuseEquipIDs",Job)
	q 0
}
*/
/// modified by zy zy0251 2021-01-11
/// 修改之后这个方法已经无用
/// modified by zy zy0251 2021-01-11
/// 批量报废设备处理.
/// 参数说明：
/// 		Job:			记录导入数据的唯一jobID
/// 		val:			设备信息：No
/// 返回值：0  正常; 
/// w ##Class(web.DHCEQBatchDisuseRequest).ImportDisuseEquip("17012","1^2^3^4^5^15^71314^71315^71316^71317^71318^71319^71320^71321")
ClassMethod ImportDisuseEquip(Job, val)
{
	k ^DHCEQTemp("DisuseEquipIDs",Job)
	new EquipNo,EquipIDs,EquipID,EquipTypeID,StoreLocID,InStockListID,Len,i,Flag
	s Flag=0
	s Len=$L(val,"^")
	for i=1:1:Len
	{
		s EquipID=$p(val,"^",i)
		q:EquipID=""
		s EquipTypeID=$p(^DHCEQEquip(EquipID),"^",63)
		s StoreLocID=$p(^DHCEQEquip(EquipID),"^",67)
		s InStockListID=+$p(^DHCEQEquip(EquipID),"^",70)
		s CheckResult=##Class(web.DHCEQBatchDisuseRequest).CheckEquipDR("3","",EquipID,StoreLocID,"","Y")
		i +$p(CheckResult,"^",1)=1
		{
			 s ^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID,EquipID)=CheckResult //Modified By QW20210428 BUG:QW0101
			 s Flag=Flag+1
		}else
		{
			s ^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID,EquipID)=""
		}
	}
	q Flag
}

/// add by zy zy0251 2021-01-11
/// 处理设备在其他报废单占用的问题
/// 参数说明：
/// 		EquipID:			设备ID：No
/// 返回值：0  正常; 
/// w ##Class(web.DHCEQBatchDisuseRequest).DealEquipInOtherRequest("4")
ClassMethod DealEquipInOtherRequest(EquipID)
{
	new SQLCODE,DRStatus,RowID,KindFlag,EquipIDs,DRLRowID,MXRowID
	s SQLCODE=0
    ;判断报废单
    s DRStatus=""
    f  s DRStatus=$o(^DHCEQDisuseRequest(0,"Status",DRStatus))  q:(DRStatus="")||(SQLCODE'=0)  d
    .;只需判断 尚未报废完成的
    .q:(DRStatus'=0)&&(DRStatus'=1)
    .s RowID=0
    .f  s RowID=$o(^DHCEQDisuseRequest(0,"Status",DRStatus,RowID)) q:(RowID="")||(SQLCODE'=0)  d
    ..;过滤掉无效的InvalidFlag
    ..q:$p($g(^DHCEQDisuseRequest(RowID)),"^",53)="Y"
    ..s KindFlag=$p($g(^DHCEQDisuseRequest(RowID)),"^",44)
    ..i KindFlag=0  d
    ...if $P(^DHCEQDisuseRequest(RowID),"^",1)=EquipID d
    ....&SQL(Update SQLUSER.DHC_EQDisuseRequest Set DR_InvalidFlag='Y',DR_Remark='重复记录' where DR_RowID=:RowID)
    ..else  if KindFlag=1  d
    ...s EquipIDs=$g(^DHCEQDisuseRequest(RowID,"EX"))
    ...i (","_EquipIDs_",")[(","_EquipID_",") d
    ....s DRLRowID=$o(^DHCEQDisuseRequestList(0,"EquipDR",EquipID,0))
    ....i DRLRowID'="" &SQL(delete from  SQLUSER.DHC_EQDisuseRequestList where DRL_RowID=:DRLRowID)
	....
	....s EquipIDs=##class(web.DHCEQCommon).Replace(EquipIDs,EquipID,"")
	....s EquipIDs=##class(web.DHCEQCommon).Replace(EquipIDs,",,",",")
	....s ^DHCEQDisuseRequest(RowID,"EX")=EquipIDs
    ....
    ..e  d
    ...s MXRowID=0
    ...f  s MXRowID=$o(^DHCEQDisuseList(0,"Request",RowID,MXRowID)) q:(MXRowID="")||(SQLCODE'=0)  d
    ....i $p(^DHCEQDisuseList(MXRowID),"^",2)=0  d
    .....i $P(^DHCEQDisuseList(MXRowID),"^",3)=EquipID d
    ......s DRLRowID=$o(^DHCEQDisuseRequestList(0,"EquipDR",EquipID,0))
    ......i DRLRowID'="" &SQL(delete from  SQLUSER.DHC_EQDisuseRequestList where DRL_RowID=:DRLRowID)
    ......q:SQLCODE'=0
    ......&SQL(delete from  SQLUSER.DHC_EQDisuseList where DL_RowID=:MXRowID)
    ......
    ....e  d
    .....s EquipIDs=$g(^DHCEQDisuseList(MXRowID,"EX"))
    .....i (","_EquipIDs_",")[(","_EquipID_",") d
    ......s DRLRowID=$o(^DHCEQDisuseRequestList(0,"EquipDR",EquipID,0))
    ......i DRLRowID'="" &SQL(delete from  SQLUSER.DHC_EQDisuseRequestList where DRL_RowID=:DRLRowID)
	......s EquipIDs=##class(web.DHCEQCommon).Replace(EquipIDs,EquipID,"")
	......s EquipIDs=##class(web.DHCEQCommon).Replace(EquipIDs,",,",",")
	......s ^DHCEQDisuseRequest(MXRowID,"EX")=EquipIDs
    
	q SQLCODE
}

/// add by zy zy0251 2021-01-11
/// 批量处理在其他报废单占用的问题.
/// 参数说明：
/// 		Job:			记录导入数据的唯一jobID
/// 返回值：0  正常; 
/// w ##Class(web.DHCEQBatchDisuseRequest).DealInOtherDisuseRequest("3220199000619",7076)
ClassMethod DealEquipInOtherRequestBatch(Job)
{
	i Job="" q -1
	new SQLCODE,StoreLocID,EquipTypeID,EquipTypeID,EquipID,CheckResult
	
	s SQLCODE=0
	i '$Data(^DHCEQTemp("DisuseEquipIDs",Job)) q "没有数据"
	s StoreLocID=0
	f  s StoreLocID=$o(^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID))  q:(StoreLocID="")||(SQLCODE'=0)  d
	.s EquipTypeID=0
	.f  s EquipTypeID=$o(^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID))  q:(EquipTypeID="")||(SQLCODE'=0)  d
	..s EquipID=0
	..f  s EquipID=$o(^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID,EquipID))  q:(EquipID="")||(SQLCODE'=0)  d
	...s CheckResult=$g(^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID,EquipID))
	...q:(CheckResult'="")
	...s SQLCODE=##Class(web.DHCEQBatchDisuseRequest).DealEquipInOtherRequest(EquipID)
	
	q SQLCODE
}

/// modified by zy zy0251 2021-01-11
/// 增加参数控制
/// add by zy zy0155 2016-12-25
/// 批量报废设备处理.
/// 参数说明：
/// 		Job:			记录导入数据的唯一jobID
/// 		OperationType:	操作类型：1,生成单据申请;2,生成预单据;3,生成审批完成的单据
/// w ##Class(web.DHCEQBatchDisuseRequest).BuildDisuseRequest(3816,1)
ClassMethod BuildDisuseRequest(Job, OperationType, KindFlag As %String = "1", NoDealFlag As %String = "")
{
	new Date,EquipNo,EquipID,EquipTypeID,StoreLocID,InStockListID
	new ErrorFlag,BatchEquipIDs,BatchFlag,Length,ListVal,DRRowID,result
	new RowID,EquipID,GroupDR,RequestLocDR,RequestDate,UseState,DisuseTypeDR,ChangeReason,DisureDate
	new Remark,RequestNo,LocDR,TotleTime,Income,CheckResult,TechnicEvaluate,RepairHours,RepairFee,RepairTimes
	new LimitYears,InStockListDR,RowIDs
	new StringInfo,RoleDR
	s NoDealFlag=##class(web.DHCEQCommon).TransValueFromPage(NoDealFlag,"bool")
	s Date=+$H
	s ErrorFlag=0	//保存有错时返回代码
	s CheckResult="" //Modified By QW20210308 BUG:QW0094 测试需求
	i (Job="")||(OperationType="" ) q "没有数据"
	i '$Data(^DHCEQTemp("DisuseEquipIDs",Job)) q "没有数据"
	s StoreLocID=0
	f  s StoreLocID=$o(^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID))  q:(StoreLocID="")||(ErrorFlag'=0)  d
	.s EquipTypeID=0
	.f  s EquipTypeID=$o(^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID))  q:(EquipTypeID="")||(ErrorFlag'=0)  d
	..i KindFlag=0 d
	...s EquipID=0
	...f  s EquipID=$o(^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID,EquipID))  q:(EquipID="")||(ErrorFlag'=0)  d
	....s ID=EquipID //Add By QW20210308 BUG:QW0094 测试需求
	....;Modified By QW20210428 BUG:QW0101 begin 测试需求
	....s CheckInfo=$g(^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID,EquipID))
	....s CheckResult=$p(CheckInfo,"^",2)
	....;Modified By QW20210428 BUG:QW0101 end
	....q:(NoDealFlag="Y")&&(CheckResult'="")
	....i CheckResult'="" d
	.....s ErrorFlag=##Class(web.DHCEQBatchDisuseRequest).DealEquipInOtherRequest(EquipID)
	....q:ErrorFlag'=0
	....d ResetVariablesDisuseRequest
	....s LimitYears=$p($g(^DHCEQEquip(EquipID)),"^",31)
	....s ListVal=""
	....d SaveDisuseRequest
	....k ^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID,ID)  //Modified By QW20210308 BUG:QW0094 测试需求
	..e  i KindFlag=2 d
 	...d ResetVariablesDisuseRequest
	...s ListVal=""
	...s EquipID=0
	...f  s EquipID=$o(^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID,EquipID))  q:(EquipID="")||(ErrorFlag'=0)  d
	....;Modified By QW20210428 BUG:QW0101 begin 测试需求
	....s CheckInfo=$g(^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID,EquipID))
	....s CheckResult=$p(CheckInfo,"^",2)
	....;Modified By QW20210428 BUG:QW0101 end
	....i (NoDealFlag="Y")&&(CheckResult'="") s ErrorFlag=CheckResult  //Add By QW20210308 BUG:QW0094 测试需求
	....q:(NoDealFlag="Y")&&(CheckResult'="")
	....i CheckResult'="" d
	.....s ErrorFlag=##Class(web.DHCEQBatchDisuseRequest).DealEquipInOtherRequest(EquipID)
	....q:ErrorFlag'=0
	....s OriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
 	....s OneListVal="^^0^"_EquipID_"^1^^^^^"_OriginalFee_"^^^^"
	....i ListVal=""  d
	.....s ListVal=OneListVal
 	....e  d
 	.....s ListVal=ListVal_"&"_OneListVal
 	...q:ErrorFlag'=0 //Add By QW20210308 BUG:QW0094 测试需求
	...d SaveDisuseRequest
	...k ^DHCEQTemp("DisuseEquipIDs",Job,StoreLocID,EquipTypeID)
	
	q ErrorFlag
	
ResetVariablesDisuseRequest
	s (RowID,GroupDR,RequestLocDR,RequestDate,UseState,DisuseTypeDR,ChangeReason,DisureDate,Remark,RequestNo,LocDR,TotleTime,Income,CheckResult,TechnicEvaluate,RepairHours,RepairFee,RepairTimes,LimitYears,InStockListDR,RowIDs,Hold2,Hold3,Hold4,Hold5)=""
	q 
SaveDisuseRequest 
 	s RequestLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
 	s RequestDate=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
 	s DisureDate=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
 	s LocDR=StoreLocID
 	s EquipTypeDR=EquipTypeID
 	set ReqVal=RowID_"^"_EquipID_"^"_GroupDR_"^"_RequestLocDR_"^"_RequestDate_"^"_UseState_"^"_DisuseTypeDR_"^"_ChangeReason_"^"_DisureDate_"^"_Remark
  	for i=11:1:33
	{
		set ReqVal=ReqVal_"^"
	}
	set ReqVal=ReqVal_"^"_RequestNo_"^"_LocDR_"^"_TotleTime_"^"_Income_"^"_CheckResult_"^"_TechnicEvaluate_"^"_RepairHours_"^"_RepairFee_"^"_RepairTimes_"^"_LimitYears_"^"_KindFlag_"^"_InStockListDR_"^^"_RowIDs_"^"_EquipTypeDR_"^"_Hold2_"^"_Hold3_"^"_Hold4_"^"_Hold5_"^"_Job
 	
 	s result=##class(web.DHCEQBatchDisuseRequest).SaveDisuseRequest(ReqVal, ListVal,"",0)	//更新
 	if $p(result,"^",1)'=0 s ErrorFlag=$p(result,"^",1)_"报废申请单更新失败..."
 	i ErrorFlag'=0 q
	s DRRowID=$p(result,"^",2)
	Set StringInfo=DRRowID
 	if OperationType>1 
	{
		Set ErrorFlag=##class(web.DHCEQBatchDisuseRequest).SubmitData(StringInfo)	//提交
	 	i ErrorFlag'=0 q ErrorFlag_"报废提交失败..."
	}
	///  Mozy	获取审批设置信息
	s buildApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
    s buildMaxPrice=$p(##class(web.DHCEQBatchDisuseRequest).CheckData(DRRowID),"^",2)
	s buildApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(buildApproveType, EquipTypeDR, "", "", buildMaxPrice,"")
 	i buildApproveSet="" q -4007
	if OperationType>2
	{
		//预报废
		Set RoleDR=##class(web.DHCEQCommon).GetSysInfo("601003")			//院内报废审批完成角色ID
		i RoleDR="" q ErrorFlag_"预报废步骤角色不能为空..."
		s StopFlag=0
		s AFStep=0
		f  s AFStep=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",buildApproveSet,AFStep))  q:(AFStep="")||(StopFlag'=0)||(ErrorFlag'=0)  d
		.s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",buildApproveSet,AFStep,0))
		.s (AFRoleDR,AFLastFlag)=""
		.i AFRowID'=""  d
		..s AFRoleDR=$p(^DHCEQCCode("DHCEQCApproveFlow",AFRowID),"^",2)
		..s AFLastFlag=$p(^DHCEQCCode("DHCEQCApproveFlow",AFRowID),"^",4)
		.s StringInfo=DRRowID_"^"_AFRoleDR_"^"_AFStep_"^同意^"
		.s ErrorFlag=##class(web.DHCEQBatchDisuseRequest).AuditData(StringInfo)
		.i (RoleDR'="")&&(RoleDR=AFRoleDR) s StopFlag=AFStep
		
	 	i ErrorFlag'=0 q ErrorFlag_"预报废审核失败..."
	}
	if OperationType>3
	{
		s AFStep=AFStep
		f  s AFStep=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",buildApproveSet,AFStep))  q:(AFStep="")||(ErrorFlag'=0)  d
		.s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",buildApproveSet,AFStep,0))
		.s (AFRoleDR,AFLastFlag)=""
		.i AFRowID'=""  d
		..s AFRoleDR=$p(^DHCEQCCode("DHCEQCApproveFlow",AFRowID),"^",2)
		..s AFLastFlag=$p(^DHCEQCCode("DHCEQCApproveFlow",AFRowID),"^",4)
		.s StringInfo=DRRowID_"^"_AFRoleDR_"^"_AFStep_"^同意^"
		.s ErrorFlag=##class(web.DHCEQBatchDisuseRequest).AuditData(StringInfo)
		
	 	i ErrorFlag'=0 q ErrorFlag_"报废申请单审核失败..."
	}
 	q
}

ClassMethod GetSourceType(TSourceType)
{
	q $CASE(TSourceType,"0":"单台","1":"批量","":"")
}

/// add by zc 2017-05-25
/// 批量报废申请.
/// 参数说明：
/// 		EquipIDs:	设备ID串
///         ExcludeIDs:排除在外的设备ID串,主要是排除被其他单据中占用的设备ID串
/// w ##Class(web.DHCEQBatchDisuseRequest).BatchDisuseEquipIDs("39918","39918,52122,52123,52124,52227,52228,52229,52230,52231,52281,44717,46458")
ClassMethod BatchDisuseEquipIDs(EquipIDs As %String = "", ExcludeIDs As %String = "", BatchRequestFlag As %String = "")
{
	new Date,EquipDR,EquipTypeID,StoreLocID,EquipDRs,Len
	new ErrorFlag,EquipID,Length,ListVal,DRRowID,result
	new RowID,RequestLocDR,RequestDate,DisureDate,LocDR
	k ^DHCEQTemp("BatchDisuseEquipIDs",$j)
	s Date=+$H
	s KindFlag=2	;多批次报废
	s ErrorFlag=0	//保存有错时返回代码
	s ErrorMess=""

	//add by lmm begin
	s KindFlag=BatchRequestFlag
	s InStockListDR=0
	s EquipDRnew=0
	//add by lmm end

	s Info=""
	s Num=0
	s Len=$l(EquipIDs,",")
 	f i=1:1:Len d
 	.s EquipDR=$p(EquipIDs,",",i)
 	.q:(","_ExcludeIDs_",")[(","_EquipDR_",")
 	.;modefied by by zc 2017-08-29 ZC0032 begin
 	.s Str=##Class(web.DHCEQBatchDisuseRequest).CheckEquipDR("","",EquipDR,"","","Y")
 	.i $p(Str,"^",2)'="" d
 	..i Info="" d
 	...s Info=$p(Str,"^",2)
 	..e  d
 	...s Info=Info_","_$p(Str,"^",2)
 	.q:$p(Str,"^",1)=1
 	.; modefied by by zc 2017-08-29 ZC0032 end
 	.s EquipTypeID=$p($g(^DHCEQEquip(EquipDR)),"^",63)
 	.s StoreLocID=$p($g(^DHCEQEquip(EquipDR)),"^",67)
 	.;add by lmm 2017-09-21 begin
 	.s InStockListDR=$p($g(^DHCEQEquip(EquipDR)),"^",70)
 	.;Modified BY QW20200326 BUG:QW0053 begin
	.i ((BatchRequestFlag=0)||((BatchRequestFlag=1)&&(InStockListDR=""))) d  
 	..s KindFlag=0 
 	..i $Data(^DHCEQTemp("BatchDisuseEquipIDs",$j,+KindFlag,EquipDR))  d
 	...s ^DHCEQTemp("BatchDisuseEquipIDs",$j,+KindFlag,EquipDR)=$g(^DHCEQTemp("BatchDisuseEquipIDs",$j,+KindFlag,EquipDR))_","_EquipDR
	..e  d
	...s ^DHCEQTemp("BatchDisuseEquipIDs",$j,+KindFlag,EquipDR)=EquipDR	
 	.e  i ((BatchRequestFlag=1)&&(InStockListDR'=""))  d 
 	..i $Data(^DHCEQTemp("BatchDisuseEquipIDs",$j,+KindFlag,+InStockListDR,StoreLocID))  d
 	...s ^DHCEQTemp("BatchDisuseEquipIDs",$j,+KindFlag,+InStockListDR,StoreLocID)=$g(^DHCEQTemp("BatchDisuseEquipIDs",$j,+KindFlag,+InStockListDR,StoreLocID))_","_EquipDR
	..e  d
	...s ^DHCEQTemp("BatchDisuseEquipIDs",$j,+KindFlag,+InStockListDR,StoreLocID)=EquipDR	
 	.e  i (BatchRequestFlag=2) d
 	..i $Data(^DHCEQTemp("BatchDisuseEquipIDs",$j,+KindFlag,EquipTypeID,StoreLocID))  d
 	...s ^DHCEQTemp("BatchDisuseEquipIDs",$j,+KindFlag,EquipTypeID,StoreLocID)=$g(^DHCEQTemp("BatchDisuseEquipIDs",$j,+KindFlag,EquipTypeID,StoreLocID))_","_EquipDR
	..e  d
	...s ^DHCEQTemp("BatchDisuseEquipIDs",$j,+KindFlag,EquipTypeID,StoreLocID)=EquipDR
	.;Modified BY QW20200326 BUG:QW0053 end

 	
 	
	//Modified BY QW20200326 BUG:QW0053
	s EquipDR=0
	f  s EquipDR=$o(^DHCEQTemp("BatchDisuseEquipIDs",$j,0,EquipDR))  q:(EquipDR="")||(ErrorFlag'=0)  d
	.s EquipDRs=$g(^DHCEQTemp("BatchDisuseEquipIDs",$j,0,EquipDR))
	.d BuildDisuseRequestNew

	s InStockListDR=0
	f  s InStockListDR=$o(^DHCEQTemp("BatchDisuseEquipIDs",$j,1,InStockListDR))  q:(InStockListDR="")||(ErrorFlag'=0)  d
	.s StoreLocID=0
	.f  s StoreLocID=$o(^DHCEQTemp("BatchDisuseEquipIDs",$j,1,+InStockListDR,StoreLocID))  q:(StoreLocID="")||(ErrorFlag'=0)  d
	..s EquipDRs=$g(^DHCEQTemp("BatchDisuseEquipIDs",$j,1,+InStockListDR,StoreLocID))
	..d BuildDisuseRequestNew

	s EquipTypeID=0
	f  s EquipTypeID=$o(^DHCEQTemp("BatchDisuseEquipIDs",$j,2,EquipTypeID))  q:(EquipTypeID="")||(ErrorFlag'=0)  d
	.s StoreLocID=0
	.f  s StoreLocID=$o(^DHCEQTemp("BatchDisuseEquipIDs",$j,2,EquipTypeID,StoreLocID))  q:(StoreLocID="")||(ErrorFlag'=0)  d
	..s EquipDRs=$g(^DHCEQTemp("BatchDisuseEquipIDs",$j,2,EquipTypeID,StoreLocID))
	..d BuildDisuseRequestNew
 	//Modified BY QW20200326 BUG:QW0053 end 
 	
 	
	k ^DHCEQTemp("BatchDisuseEquipIDs",$j)  /// modefied by by zc 2017-06-25 ZC0031
	q Num_"^"_ErrorMess_"^"_Info  /// modefied by by zc 2017-06-25 ZC0031
	
BuildDisuseRequestNew
	//0,单台报废;1,单批次报废;2,多批次报废
	//add by lmm 2017-10-19 begin
	i KindFlag=0 d
 	.s Length=$l(EquipDRs,",")
 	.f i=1:1:Length d
 	..d ResetVariablesDRNew
 	..s EquipID=$p(EquipDRs,",",i)
 	..s EquipDRnew=EquipID
 	..s LimitYears=$p($g(^DHCEQEquip(EquipID)),"^",31)
 	..s EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)
 	..s StoreLocID=$p($g(^DHCEQEquip(EquipID)),"^",67)
 	..;Add BY QW20200326 BUG:QW0053 begin
 	..s OriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
 	..s ListVal="^^0^"_EquipID_"^1^^^^^"_OriginalFee_"^^^^"
 	..;Add BY QW20200326 BUG:QW0053 end
 	..d SaveDisuseRequestNew
 	i KindFlag=1 d
 	.d ResetVariablesDRNew
 	.s ListVal=""
 	.s Amount=0
 	.s QautityNum=0
 	.s Length=$l(EquipDRs,",")
 	.f i=1:1:Length d
 	..s EquipID=$p(EquipDRs,",",i)
 	..s LimitYears=$p($g(^DHCEQEquip(EquipID)),"^",31)
 	..s EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)
 	..s InStockListDR=$p($g(^DHCEQEquip(EquipID)),"^",70)
 	..s StoreLocID=$p($g(^DHCEQEquip(EquipID)),"^",67)
 	..s OriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
	..s ListVal="^^0^"_EquipID_"^"_Length_"^^^^^"_OriginalFee_"^^^^" ;Add BY QW20200326 BUG:QW0053 begin
 	.s ^TEMPEQ("MXList","EX",$j,"1")=EquipDRs
 	.d SaveDisuseRequestNew
	//add by lmm 2017-10-19 end
 	i KindFlag=2 d
 	.d ResetVariablesDRNew
 	.s ListVal=""
 	.s Length=$l(EquipDRs,",")
 	.f i=1:1:Length d
 	..s EquipID=$p(EquipDRs,",",i)
 	..s EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)
 	..s OriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
 	..s OneListVal="^^0^"_EquipID_"^1^^^^^"_OriginalFee_"^^^^"
 	..i ListVal=""  d
 	...s ListVal=OneListVal
 	..e  d
 	...s ListVal=ListVal_"&"_OneListVal
 	.d SaveDisuseRequestNew
 	q
ResetVariablesDRNew
	s (RowID,EquipID,GroupDR,RequestLocDR,RequestDate,EquipTypeDR,LimitYears,InStockListDR,EquipDRnew)=""
	q 
SaveDisuseRequestNew
 	s RequestLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
 	s RequestDate=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
 	s DisureDate=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
 	s LocDR=StoreLocID
 	//modify by lmm
 	set ReqVal=RowID_"^"_EquipDRnew_"^^"_RequestLocDR_"^"_RequestDate_"^^^^^"   /// modefied by by zc 2017-06-25 ZC0031
  	for i=11:1:33
	{
		set ReqVal=ReqVal_"^"
	}
	//set ReqVal=ReqVal_"^^"_LocDR_"^^^^^^^^^"_KindFlag_"^^^^"_EquipTypeDR_"^^^^^"   /// modefied by by zc 2017-06-25 ZC0031
	set ReqVal=ReqVal_"^^"_LocDR_"^^^^^^^^"_LimitYears_"^"_KindFlag_"^"_InStockListDR_"^^^"_EquipTypeDR_"^^^^^"_$j   /// modefied by by zc 2017-06-25 ZC0031
 	
 	s result=##class(web.DHCEQBatchDisuseRequest).SaveDisuseRequest(ReqVal, ListVal,"",0)	//更新
 	/// modefied by by zc 2017-06-25 ZC0031  begin
 	if $p(result,"^",1)=0 d
 	.s Num=Num+1
 	.s ErrorFlag=$p(result,"^",1)
 	e  d
 	.s ErrorFlag=$p(result,"^",1) ;Add BY QW20200326 BUG:QW0053 begin
 	.i ErrorMess="" d
 	..s ErrorMess=$p($g(^DHCEQEquip(EquipID)),"^",71)
 	.e  d
 	..s ErrorMess=ErrorMess_","_$p(result,"^",71)
	/// modefied by by zc 2017-06-25 ZC0031 end
 	q
}

/// 通过报废单ID生成报废单中所有设备的报废生命周期
/// w ##Class(web.DHCEQBatchDisuseRequest).GetLifeInfoBYRowID(29)
/// 入参 RowID：报废单主表ID    
/// 返回0成功 
/// add by csy 2017-08-16 明细勾选报废 需求号：CSY0007
ClassMethod GetLifeInfoBYRowID(RowID)
{
	n DRLRowID,EquipDR,EQName,EQNo,EQStatus,FromLoc,EQStoreLocDR,DisuseType
	n User,LI,Date,Time
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s SQLCODE=0
	s Date=+$H
	s Time=$p($H,",",2)
	i RowID="" q "-2201^没有单据不能操作!"	
 	s DRLRowID=0
	f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",RowID,DRLRowID)) q:(DRLRowID="")||(SQLCODE'=0)  d
	.s EquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	.s EQName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	.s EQNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	.i $p($g(^DHCEQEquip(EquipDR)),"^",59)="Y"  s SQLCODE="-2201^"_EQName_"["_EQNo_"]设备已无效!"
	.q:SQLCODE'=0
	.i ($p($g(^DHCEQEquip(EquipDR)),"^",60)'="1")  s SQLCODE="-2201^"_EQName_"["_EQNo_"]库房状态不符合条件!"
	.q:SQLCODE'=0
	.s EQStatus=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	.i (EQStatus>2)  s SQLCODE="-2201^"_EQName_"["_EQNo_"]设备状态不符合条件!"
	.q:SQLCODE'=0
	.s FromLoc=$p($g(^DHCEQDisuseRequest(RowID)),"^",34)
	.s EQStoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
	.i FromLoc'=EQStoreLocDR  s SQLCODE="-2201^"_EQName_"["_EQNo_"]所在库房已经变动,不是申请时使用部门!"
	.q:SQLCODE'=0
	.i (EQStatus<3) d 
	..k LI
	..s LI(2)=EquipDR  //设备
	..s LI(4)=$p($g(^DHCEQEquip(EquipDR)),"^",19)   //原使用科室
	..s LI(5)=$p($g(^DHCEQEquip(EquipDR)),"^",17) //原管理科室
	..s LI(6)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  //原库房
	..s LI(7)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  //原值
	..s LI(8)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  //原净值
	..&sql(update sqluser.DHC_EQEquip  set EQ_Status=3,EQ_DisuseDate=:Date,EQ_AdvanceDisFlag=null,EQ_Hold1=null where EQ_RowID=:EquipDR) //修改设备库房状态
	..i SQLCODE=100 s SQLCODE=0
	..q:SQLCODE'=0
	..s LI(9)=$p($g(^DHCEQEquip(EquipDR)),"^",19)   //变动后使用科室
	..s LI(10)=$p($g(^DHCEQEquip(EquipDR)),"^",17) //变动后管理科室
	..s LI(11)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  //变动后库房
	..s LI(12)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  //变动后原值
	..s LI(13)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  //变动后净值
	..s DisuseType=$p($g(^DHCEQDisuseRequest(RowID)),"^",6) //报废类型
	..i DisuseType'="" s LI(14)=$p($g(^DHCEQCCode("DHCEQCDisuseType",DisuseType)),"^",2)  //变动原因
	..s LI(15)=$p($g(^DHCEQDisuseRequest(RowID)),"^",7)  //变动描述
	..s LI(16)=Date	//变动日期
	..s LI(17)=Time	//变动时间
	..s LI(19)="C"	//生命周期类型
	..s LI(20)=34	//来源类型
	..s LI(21)=DRLRowID	//来源ID
	..s LI(27)=User	//更新人
	..s LI(28)=Date	//更新日期
	..s LI(29)=Time	//更新时间
	..&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	..q:SQLCODE'=0
	..&sql(Update SQLUSER.DHC_EQDisuseRequestList set DRL_Hold1=:EQStatus where DRL_RowID=:DRLRowID)
	..i SQLCODE=100 s SQLCODE=0
	..q:SQLCODE'=0
	..//Function:Funds	 生成资金来源信息
	..s SQLCODE=##class(web.DHCEQInStockNew).CreateFundsInfo(6,DRLRowID)
	..q:SQLCODE'=0
	..Set SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(6,DRLRowID)
		
	q SQLCODE
}

/// 明细勾选的设备新生成审核状态的报废单
/// w ##Class(web.DHCEQBatchDisuseRequest).DetailAuditDisuseRequest("1^True&2^false",1)
/// 入参 valList (所有TRowID和勾选标记的拼串) ; RowID:报废单ID  
/// 成功返回: 0_^_DRRowID(新生成的已审核的报废单ID)_"^"_RequestNo(新生成的已审核的报废单号)
/// add by csy 2017-08-16 明细勾选报废 需求号：CSY0007
ClassMethod DetailAuditDisuseRequest(valList, RowID)
{
	Set $ZT="ERRORDetailAudit"
	n User,DLRowID,DRLRowID,DRRowID,i,len,j,k,PLIST,RequestNo
	k PLIST
	s (len,i,SQLCODE)=0	
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	i RowID="" q "-2201^没有单据不能操作!"
	i $p($g(^DHCEQDisuseRequest(RowID)),"^",53)="Y" q "-2201^无效单据不能操作!"	
	i $p($g(^DHCEQDisuseRequest(RowID)),"^",10)'="1" q "-2015^该单据状态不符合,不能执行操作!"   
	TSTART
	&SQL(select * into :PLIST() from sqluser.DHC_EQDisuseRequest where DR_RowID=:RowID)
	if SQLCODE  
		{
		      TROLLBACK
			  q SQLCODE_"^取报废单信息失败！"
		}	
	s PLIST(1)=""  // 将RowID置为空
	s PLIST(10)="由单号为"_$p($g(^DHCEQDisuseRequest(RowID)),"^",33)_"的报废单勾选审核生成"
	s PLIST(11)="2"    //状态置为审核
	s PLIST(21)=User
	s PLIST(22)=Date
	s PLIST(23)=Time
	s PLIST(34)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQDisuseRequest",+$H,"",PLIST(44)) //生成新的报废单号
	&SQL(Insert Into SQLUSER.DHC_EQDisuseRequest Values :PLIST()) // 复制成一个审核状态的报废单
	if SQLCODE  
		{
		      TROLLBACK
			  q SQLCODE_"^勾选的设备生成审核状态的新报废单失败！"
		}	   
    s DRRowID=$G(%ROWID) 
	s len=$l(valList,"&")
	s j=0
	for i=1:1:len
	{   k PlISTMX 
		q:SQLCODE'=0
		s info=$p(valList,"&",i)
		s DLRowID=$p(info,"^",1) // 报废明细表(DHC_EQDisuseList)ID 
		i ((##class(web.DHCEQCommon).TransValueFromPage($p(info,"^",2),"bool")="Y")) d 
		.s j=j+1
		.s PLISTMX(2)=DRRowID  // 新主表ID
		.s PLISTMX(4)=$p($g(^DHCEQDisuseList(DLRowID)),"^",3) // EquipID
		.s PLISTMX(11)=##class(web.DHCEQCommon).TransValueFromPage($p(info,"^",2),"bool")
		.s DRLRowID=0
		.f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",RowID,DRLRowID)) q:(DRLRowID="")||(SQLCODE'=0)  d
		..q:($p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",12)'=DLRowID)
		..&SQL(Update sqluser.DHC_EQDisuseRequestList set DRL_DisuseRequestDR=:DRRowID Where DRL_RowID=:DRLRowID)
		..i SQLCODE=100 s SQLCODE=0
		.q:SQLCODE'=0
		.&SQL(Update sqluser.DHC_EQDisuseList set DL_DisuseRequestDR=:PLISTMX(2),DL_Hold2=:PLISTMX(11) Where DL_RowID=:DLRowID)
		.i SQLCODE=100 s SQLCODE=0
		.q:SQLCODE'=0
	}
	if SQLCODE  
		{
		      TROLLBACK
			  q SQLCODE_"^勾选的设备生成审核状态的新报废单明细失败！"
		}	   
	if (j=0)
	{
		TROLLBACK
			  q -2201_"^没有勾选要报废的设备！"
		} 
	s k=0
	s DRLRowID=0
	f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",RowID,DRLRowID)) q:(DRLRowID="")  d
	.s k=k+1 ; 判断当前要勾选审核的报废单是否还剩下至少一条明细 ;报废明细表DHC_EQDisuseRequestList没有无效标记字段
     if (k=0)
	{
		TROLLBACK
			  q -2201_"^报废单中所有设备都已勾选，可以直接审核通过,不必勾选！"
		} 
	s SQLCODE=##Class(web.DHCEQBatchDisuseRequest).GetLifeInfoBYRowID(DRRowID)
	if SQLCODE  
		{
		      TROLLBACK
			  q SQLCODE_"^明细审核的设备生成生命周期失败！"
		}	   	
  s RequestNo=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",33)
	TCOMMIT
	quit SQLCODE_"^"_DRRowID_"^"_RequestNo
ERRORDetailAudit
   TROLLBACK		              //回滚事务
   Set ErrorMsg=$ZE	          //得到系统返回的错误消息	
   Quit "-2201^ERROR"_ErrorMsg     //返回错误消息
}

/// Mozy0217  2018-11-01
/// 描述:根据来源生成其设备配置的报废单明细
/// 入参： SourceType：		0:入库单明细ID		1:设备DR
/// 			OCLRowid:验收明细ID
/// w ##Class(web.DHCEQBatchDisuseRequest).GetDLForConfig(0, 777, 74, 1)
/// w ##Class(web.DHCEQBatchDisuseRequest).GetDLForConfig(1, 45687, 74, 1)
ClassMethod GetDLForConfig(SourceType As %String = "", SourceID As %String = "", FromLocDR As %String = "", index As %String = "0", RequestRowID As %String = "")
{
	i (SourceType="")||(SourceID="") q ""
	;s ^DHCEQMozy("GetDLForConfig")=SourceType_","_SourceID_","_FromLocDR_","_index
	
	n valList, OCLRowid, ConfigDRs, ConfigDR, Length, i, ISRowID, tmpISLRowID, StoreLocDR, RowIDs, tmpEquipID, Hold13
	s valList=""
	s Num=index		;序号计数器
	i SourceType=0
	{
		i $p($g(^DHCEQInStockList(SourceID)),"^",18)'=2 q 0		;过滤非来自验收明细的入库记录
		i $p($g(^DHCEQInStockList(SourceID)),"^",22)'="" q 0	;设备配置的入库明细不需要再次生成转移明细记录
		s OCLRowid=$p($g(^DHCEQInStockList(SourceID)),"^",19)
		i OCLRowid="" q 0
		s ConfigDRs=##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1, OCLRowid)
		i ConfigDRs="" q 0
		s ISRowID=$p($g(^DHCEQInStockList(SourceID)),"^",1)
		s Length=$l(ConfigDRs,",")
		
		for i=1:1:Length
		{
			Set ConfigDR=$p(ConfigDRs,",",i)
			Set tmpISLRowID=0
			For  Set tmpISLRowID=$Order(^DHCEQInStockList(0,"InStock",ISRowID,tmpISLRowID)) Quit:(tmpISLRowID="")  Do
			.Quit:$p($g(^DHCEQInStockList(tmpISLRowID)),"^",22)'=ConfigDR
			.
			.;拼设备ID串存储临时节点
			.Set RowIDs=""
			.Set StoreLocDR=""
			.For  Set StoreLocDR=$Order(^DHCEQEquip(0,"InStockList",tmpISLRowID,StoreLocDR)) Quit:(StoreLocDR="")  Do
			..Quit:(FromLocDR'="")&&(StoreLocDR'=FromLocDR)
			..Set tmpEquipID=0
			..For  Set tmpEquipID=$Order(^DHCEQEquip(0,"InStockList",tmpISLRowID,StoreLocDR,tmpEquipID)) Quit:(tmpEquipID="")  Do
			...Quit:($p($g(^DHCEQEquip(tmpEquipID)),"^",38)="3")||($p($g(^DHCEQEquip(tmpEquipID)),"^",38)="4")
			...Quit:($p($g(^DHCEQEquip(tmpEquipID)),"^",59)'="N")
			...Quit:##class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(tmpEquipID)),"^",63))
			...
			...;查看设备是不是已经存在其他的单据
			...Quit:##Class(web.DHCEQBatchDisuseRequest).CheckEquipDR("3",RequestRowID,tmpEquipID,FromLocDR,"")'=0
			...If RowIDs'="" Set RowIDs=RowIDs_","
			...Set RowIDs=RowIDs_tmpEquipID
			.Quit:RowIDs=""
			.
			.s Num=Num+1
			.i valList'="" s valList=valList_"&"
			.s valList=valList_Num_"^"_tmpISLRowID
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",1))),"^",14)
			.s valList=valList_"^"_$l(RowIDs,",")		;TQtyNumz
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",7)
			.s valList=valList_"^"_($Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",7)*$l(RowIDs,","))
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",5)
			.s valList=valList_"^"_##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",6)) //厂商
			.s valList=valList_"^"_##class(web.DHCEQCommon).GetTrakNameByID("model",$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",9)) //机型
			.s valList=valList_"^"_##class(web.DHCEQCommon).GetTrakNameByID("uom",$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",10)) //单位
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",15) 		//年限
			.s valList=valList_"^"_##class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",1))),"^",17)) //供应商
			.s valList=valList_"^"_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock($Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",1))),"^",13),"date") //入库日期
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",22)
		}
	}
	elseif SourceType=1
	{
		Set Hold13=0
		For  Set Hold13=$Order(^DHCEQEquip(0,"Hold13",Hold13)) Quit:(Hold13="")  Do
		.Set tmpEquipID=0
		.For  Set tmpEquipID=$Order(^DHCEQEquip(0,"Hold13",Hold13,tmpEquipID)) Quit:(tmpEquipID="")  Do
		..Quit:$Piece($Get(^DHCEQEquip(tmpEquipID,"OtherInfo")),"^",24)'=SourceID		; EQHold11		过滤主设备
		..Quit:($p($g(^DHCEQEquip(tmpEquipID)),"^",38)="3")||($p($g(^DHCEQEquip(tmpEquipID)),"^",38)="4")
		..Quit:($p($g(^DHCEQEquip(tmpEquipID)),"^",59)'="N")
		..Quit:##class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(tmpEquipID)),"^",63))
		..
		..Set StoreLocDR=$p($g(^DHCEQEquip(tmpEquipID)),"^",67)
		..Quit:(StoreLocDR'=FromLocDR)
		..;查看设备是不是已经存在其他的单据
		..Quit:##Class(web.DHCEQBatchDisuseRequest).CheckEquipDR("3",RequestRowID,tmpEquipID,FromLocDR,"")'=0
		..Set RowIDs=tmpEquipID
		..s Num=Num+1
		..i valList'="" s valList=valList_"&"
		..s valList=valList_Num_"^"_tmpEquipID
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",71)
		..s valList=valList_"^1"		;TQtyNumz
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",27)
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",27)
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",1)
		..s valList=valList_"^"_##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",26)) //厂商
		..s valList=valList_"^"_##class(web.DHCEQCommon).GetTrakNameByID("model",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",3)) //机型
		..s valList=valList_"^"_##class(web.DHCEQCommon).GetTrakNameByID("uom",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",5)) //单位
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",31) 		//年限
		..s valList=valList_"^"_##class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",25)) //供应商
		..s valList=valList_"^"_##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQEquip(tmpEquipID)),"^",45),"date") //入库日期
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID,"OtherInfo")),"^",26)		;ConfigDR
	}
	
	Quit valList
}

/// Add By DJ 2018-03-23
/// 描述:优化报废异常状态处理
ClassMethod UpdateEQUnusualStatus(RowID, UnusualStatus, UnusualRemark)
{
	new KindFlag,EquipIDs,ListID,UpResult,EquipLen,CurEquipID,i
	s EquipIDs=""
	s UpResult=0
	s KindFlag = $p($g(^DHCEQDisuseRequest(RowID)),"^",44)
	i KindFlag=2
	{
		s ListID=0
		f  s ListID=$o(^DHCEQDisuseList(0,"Request",RowID,ListID))  quit:(ListID="")||(UpResult'=0)  d
		.i $p(^DHCEQDisuseList(ListID),"^",2)=0  d
		..s EquipIDs=$P($g(^DHCEQDisuseList(ListID)),"^",3)
		.e  d
		..s EquipIDs=$g(^DHCEQDisuseList(ListID,"EX"))
		.s EquipLen=$L(EquipIDs,",")
		.s i=0
		.f i=1:1:EquipLen q:UpResult'=0  d
		..s CurEquipID=$p(EquipIDs,",",i)
		..q:CurEquipID=""
		..s UpResult=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(CurEquipID,UnusualStatus,UnusualRemark)
	}
	else
	{
		i KindFlag=0
		{
			s EquipIDs=$p($g(^DHCEQDisuseRequest(RowID)),"^",1)
		}
		elseif KindFlag=1
		{
			s EquipIDs=$g(^DHCEQDisuseRequest(RowID,"EX"))
		}
		
		s EquipLen=$L(EquipIDs,",")
		s i=0
		f i=1:1:EquipLen q:UpResult'=0  d
		.s CurEquipID=$p(EquipIDs,",",i)
		.q:CurEquipID=""
		.s UpResult=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(CurEquipID,UnusualStatus,UnusualRemark)
	}
	q UpResult
}

/// Add By DJ 2018-04-27
/// 描述:报废设备跨月恢复
/// 参数:vBussNo表示报废单号,vUnusualFlag表示是否恢复到预报废状态(Y:预报废状态 N或空:提交状态)
/// 返回值:0表示成功,非0表示失败
/// 处理步骤:当月报废单据直接执行下列方法即可
/// 			跨月报废单据请先进行数据调整取消报废恢复台帐,然后执行下列方法
/// w ##Class(web.DJPrivate.DJTest).BackEquipByDisUse("BF2017110001","Y")
ClassMethod BackEquipByDisUse(vBussNo As %String = "", vUnusualFlag As %String = "")
{
	i vBussNo="" q "报废单号不能为空!"
	i '$D(^DHCEQDisuseRequest(0,"RequestNo"," "_vBussNo)) q "报废单不存在!"
	s DRRowID=$o(^DHCEQDisuseRequest(0,"RequestNo"," "_vBussNo,0))
	s DRInvalidFlag=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",53)
	s DRStatus=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",10)
	i (DRInvalidFlag="Y")||(DRStatus>2) q "报废单已作废无法恢复!"
	i DRStatus<2	q "报废单未审核完成,请通过业务取消处理!"
	s HospApproveRole=##class(web.DHCEQCommon).GetSysInfo("601003")		//预报废审批角色
	i ((vUnusualFlag="Y")&&(HospApproveRole=""))	q "预报废审批角色参数未设置,不能恢复!"
	i vUnusualFlag="Y"
	{
		s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
		s ApproveSetDR=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",27)
		s ApproveStep=""
		s ApproveFlow=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSetDR,HospApproveRole,0))
		i ApproveFlow="" q "无预报废审批流不能恢复!"
	}
	
	s (EQAdvanceDisFlag,EQHold1)=""
	i vUnusualFlag="Y"
	{
		s EQAdvanceDisFlag=2
		s EQHold1="预报废"
	}
	s SQLCODE=0
	TSTART
	//(1)复制旧报废单信息
	k PLIST
	&SQL(Select * into :PLIST() From SQLUSER.DHC_EQDisuseRequest Where DR_RowID=:DRRowID)
	i SQLCODE
	{
		TROLLBACK
		q "["_SQLCODE_"]复制旧报废单失败!"
	}
	//(2)根据旧报废单信息开始生成新报废单
	k PLIST(1)		//DRRowID
	s PLIST(34)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQDisuseRequest",+$H,PLIST(4),PLIST(43))
	//新报废单据预报废状态处理
	s PLIST(11)=0	//默认生成新增单据
	i vUnusualFlag="Y"
	{
		s ApproveStep=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlow)),"^",3)
		s NextFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSetDR, ApproveType, DRRowID, ApproveStep, HospApproveRole)
		s NextRole=$p(NextFlow,"^",3)
		s NextFlowStep=$p(NextFlow,"^",2)
		s PLIST(11)=1	//DRStatus
		s PLIST(29)=NextRole	//DRNextRoleDR
		s PLIST(30)=NextFlowStep	//DRNextFlowStep
		s PLIST(31)=1				//ApproveStatu
		s PLIST(32)=HospApproveRole		//ApproveRoleDR
	}
	&SQL(Insert Into SQLUSER.DHC_EQDisuseRequest Values :PLIST())
	s NewDRRowID=$G(%ROWID)
	i $D(^DHCEQDisuseRequest(DRRowID,"EX")) s ^DHCEQDisuseRequest(NewDRRowID,"EX")=$g(^DHCEQDisuseRequest(DRRowID,"EX"))
	i SQLCODE
	{
		TROLLBACK
		q "["_SQLCODE_"]生成新报废单设备!"
	}
	//(3)生成新报废单审批信息
	i vUnusualFlag="Y"
	{
		s ApproveListDR=$o(^DHCEQApproveList(0,"ApproveRole",ApproveType,DRRowID,HospApproveRole,0))
		s ApproveUserDR=$p($g(^DHCEQApproveList(ApproveListDR)),"^",6)
		&SQL(Insert Into SQLUSER.DHC_EQApproveList(AL_ApproveTypeDR,AL_SourceID,AL_Opinion,AL_Remark,AL_ApproveRoleDR,AL_ApproveUserDR,AL_ApproveDate,AL_ApproveTime,AL_FlowStep,AL_InvalidFlag,AL_Action,AL_OperateType)
		select AL_ApproveTypeDR,:NewDRRowID,AL_Opinion,AL_Remark,AL_ApproveRoleDR,AL_ApproveUserDR,+$H,AL_ApproveTime,AL_FlowStep,AL_InvalidFlag,AL_Action,AL_OperateType From SQLUSER.DHC_EQApproveList Where AL_ApproveTypeDR=:ApproveType and AL_SourceID=:DRRowID
		)
		i SQLCODE
		{
			TROLLBACK                                                                                                                     
			q "["_SQLCODE_"]生成新报废单ApproveList失败!"
		}
		s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSetDR,NewDRRowID,NextRole,NextFlowStep,ApproveStep,HospApproveRole,"1")
		i SQLCODE
		{
			TROLLBACK
			q "["_SQLCODE_"]生成新报废单ApproveInfo失败!"
		}
		//消息
		s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("34", NewDRRowID, ApproveUserDR, NextFlow_"^"_ApproveSetDR, "N",HospApproveRole,0)
		i SQLCODE
		{
			TROLLBACK
			q "["_SQLCODE_"]生成消息记录失败!"
		}
	}
	//(4)生成新报废单对应明细--分单批次和多批次两种情况
	s DRLRowID=0
	f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DRRowID,DRLRowID)) q:(DRLRowID="")||(SQLCODE'=0)  d
	.k DRLPLIST
	.&SQL(Select * Into :DRLPLIST() from SQLUSER.DHC_EQDisuseRequestList Where DRL_RowID=:DRLRowID)
	.q:SQLCODE'=0
	.k DRLPLIST(1)
	.s DRLPLIST(2)=NewDRRowID
	.&SQL(Insert Into SQLUSER.DHC_EQDisuseRequestList Values :DRLPLIST())
	i SQLCODE
	{
		TROLLBACK
		q "["_SQLCODE_"]生成新报废单明细DisuseRequestList失败!"
	}
	
	s DLRowID=0
	f  s DLRowID=$o(^DHCEQDisuseList(0,"Request",DRRowID,DLRowID)) q:(DLRowID="")||(SQLCODE'=0)  d
	.k DLPLIST
	.&SQL(Select * Into :DLPLIST() from SQLUSER.DHC_EQDisuseList Where DL_RowID=:DLRowID)
	.q:SQLCODE'=0
	.k DLPLIST(1)
	.s DRPLIST(2)=NewDRRowID
	.&SQL(Insert Into SQLUSER.DHC_EQDisuseList Values :DLPLIST())
	.q:SQLCODE'=0
	.s NetDLRowID=$G(%ROWID)
	.i $D(^DHCEQDisuseList(DLRowID,"EX")) s ^DHCEQDisuseList(NetDLRowID,"EX")=$g(^DHCEQDisuseList(DLRowID,"EX"))
	i SQLCODE
	{
		TROLLBACK
		q "["_SQLCODE_"]生成新报废单明细DisuseList失败!"
	}
	//(5)旧报废单作废
	s DRRemark=$ZD(+$H,8)_"恢复数据作废[新单ID"_NewDRRowID_"]"
	&SQL(Update SQLUSER.DHC_EQDisuseRequest Set DR_Status=3,DR_Remark=:DRRemark Where DR_RowID=:DRRowID)
	i SQLCODE
	{
		TROLLBACK
		q "["_SQLCODE_"]作废旧报废单失败!"
	}
	//(6)台帐
	s Error=""
	s DRLRowID=0
	f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DRRowID,DRLRowID)) q:(DRLRowID="")||(SQLCODE'=0)  d
	.s EquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	.s EQStatus=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",11)	//modified by zy 2018-04-28 ZY0167
	.&SQL(Update SQLUSER.DHC_EQEquip Set EQ_Status=:EQStatus,EQ_DisuseDate=NULL,EQ_AdvanceDisFlag=:EQAdvanceDisFlag,EQ_Hold1=:EQHold1 Where EQ_RowID=:EquipDR)
	.i SQLCODE'=0 s Error="["_SQLCODE_"]更新DHC_EQEquip失败!"
	.q:SQLCODE'=0
	.;生命周期处理
	.s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSource",34,EquipDR,DRLRowID,0))
	.&SQL(Delete From SQLUSER.DHC_EQLifeInfo Where LI_RowID=:LIRowID)
	.i SQLCODE'=0 s Error="["_SQLCODE_"]更新DHC_EQLifeInfo失败!"

	i SQLCODE
	{
		TROLLBACK
		q Error
	}
	TCOMMIT
	q 0
}

/// 获取RoleStep
ClassMethod GetRoleStep(RowID, CurRole)
{
	new (RowID,CurRole)
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("5",RowID)
	s RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	q RoleStep
}

/// MZY0130	2785808		2022-07-27	增加备注
/// HISUI改造需重新调整 曾超
/// add by kdf 2018-01-04 报废单润乾打印  单台打印
/// d ##class(%ResultSet).RunQuery("web.DHCEQBatchDisuseRequest","DisuseRequest","1")
/// TRowID TLocDesc TEquipName TEquipNo TCountry TCheckDate TOriginalFee TQuantityNum TUnit TDepreTotalFee TInStockDate TDisuseDate TLimitYearsNum
Query DisuseRequest(RowID As %String = "", RequestNo As %String = "", RequestDate As %String = "", UseLoc As %String = "") As %Query(ROWSPEC = "TRowID:%String, TLocDesc:%String, TEquipName:%String, TEquipNo:%String, TCountry:%String, TCheckDate:%String, TOriginalFee:%String, TQuantityNum:%String, TUnit:%String, TDepreTotalFee:%String, TInStockDate:%String, TDisuseDate:%String, TLimitYearsNum:%String,TModel:%String,TFileNo:%String,TManuFactory:%String,TRemark:%String") [ SqlProc ]
{
}

ClassMethod DisuseRequestExecute(ByRef qHandle As %Binary, RowID As %String = "", RequestNo As %String = "", RequestDate As %String = "", UseLoc As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i RowID="" Quit $$$OK
	i '$Data(^DHCEQDisuseRequestList(0,"DisuseRequest",RowID)) Quit $$$OK
 	s TRowid=0
	f  s TRowid=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",RowID,TRowid))  quit:TRowid=""  d
	.s DisuseRequestDR=$p($g(^DHCEQDisuseRequestList(TRowid)),"^",1)
	.q:DisuseRequestDR'=RowID
	.d BuildDataDisuse
	Quit $$$OK
BuildDataDisuse	
    d ResetVariablesDisuse
    s TRowID=TRowid  // 报废明细ID
    s EquipDR=$p($g(^DHCEQDisuseRequestList(TRowid)),"^",2)
    s DataList=$g(^DHCEQEquip(EquipDR))
    s TLocDR=$p(DataList,"^",67)
    s TLocDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
    ;s TLocDesc = $p($g(^CTLOC(TLocDR)),"^",2)  // 使用科室
    ;s TLocCode = $p($g(^CTLOC(TLocDR)),"^",1)  // 科室代码  //modify by jyp 2019-10-18 CTLOC调整
    s TLocCode =##class(web.DHCEQCommon).GetTrakNameByID("deptcode",TLocDR)    //modify by jyp 2019-10-18 CTLOC调整
	s TEquipName=$p(DataList,"^",1)  // 设备名称
	s TEquipNo=$p(DataList,"^",71)   // 设备编号
	s ModelDR=$p(DataList,"^",3)  
	i ModelDR '=""  d
	.s TModel = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2) // 机型
	s CountryDR=$p(DataList,"^",16) 
 	i CountryDR '=""  s TCountry=##class(web.DHCEQCommon).GetTrakNameByID("cou",CountryDR)  
	s TCheckDate = ##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",12),"date")
	s TOriginalFee=$p(DataList,"^",27) //单价
	s TQuantityNum=1   // 数量
	s UnitDR = $p(DataList,"^",5)
	i UnitDR '=""  d
	.s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	s TDepreTotalFee=$p(DataList,"^",35)  //已折旧合计
	s TInStockDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",45),"date")  // 入库日期
	s TDisuseDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(RowID)),"^",4),"date")  // 报废时间
	s TLimitYearsNum=$p(DataList,"^",31) // 使用年限
	s TFileNo=$p(DataList,"^",86) 
	s TManuFactoryDR=$p(DataList,"^",27)
	i TManuFactoryDR'="" s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	s TRemark=$p($g(^DHCEQDisuseRequest(RowID)),"^",9)		// MZY0130	2785808		2022-07-27
	d OutputRowDisuse
	quit 
OutputRowDisuse
  Set Data=$lb(TRowID,TLocDesc,TEquipName,TEquipNo,TCountry,TCheckDate,TOriginalFee,TQuantityNum,TUnit,TDepreTotalFee,TInStockDate,TDisuseDate,TLimitYearsNum,TModel,TFileNo,TManuFactory,TRemark)
  Set ^CacheTemp(repid,index)=Data
  Set index=index+1 
  quit 
ResetVariablesDisuse
  s (TLocDesc,TEquipName,TEquipNo,TCountry,TCheckDate,TOriginalFee,TQuantityNum,TUnit,TDepreTotalFee,TInStockDate,TDisuseDate,TLimitYearsNum,TModel,TFileNo,TManuFactory)=""
  quit
}

ClassMethod DisuseRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DisuseRequestExecute ]
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

ClassMethod DisuseRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DisuseRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modified by ZY 20221115 增加报废审核信息输出
/// HISUI改造需重新调整 曾超
/// add by kdf 2018-01-04 润乾打印 批量报废
/// d ##class(%ResultSet).RunQuery("web.DHCEQBatchDisuseRequest","DisuseRequestMore","BF2022110151","","","","")
Query DisuseRequestMore(RequestNo As %String = "", RequestLoc As %String = "", RequestDate As %String = "", UseLoc As %String = "", EquipType As %String = "", UseLocCode As %String = "") As %Query(ROWSPEC = "TNo:%String,TName:%String,TModel:%String,TManuFactory:%String,TInDate:%String,TOriginalFee:%String,TUnit:%String,TProvider:%String,TLimitYears:%String,TNetfee:%String,TDepreTotalfee:%String,TRemark:%String,TEquipType:%String,TRow:%String,TDisuseReason:%String,ApproveList1:%String,ApproveList2:%String,ApproveList3:%String,ApproveList4:%String,ApproveList5:%String,ApproveList6:%String") [ SqlProc ]
{
}

ClassMethod DisuseRequestMoreExecute(ByRef qHandle As %Binary, RequestNo As %String = "", RequestLoc As %String = "", RequestDate As %String = "", UseLoc As %String = "", EquipType As %String = "", UseLocCode As %String = "") As %Status
{
    new repid, index,rowid,dlrowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    i RequestNo="" Quit $$$OK
    s TRow=1
    s drowid=0
    f  s drowid=$o(^DHCEQDisuseRequest(0,"RequestNo"," "_RequestNo,drowid))  quit:drowid=""  d
    .q:$p($g(^DHCEQDisuseRequest(drowid)),"^",53)="Y"
    .s (ApproveList1,ApproveList2,ApproveList3,ApproveList4,ApproveList5,ApproveList6)=""
    .s ApproveInfo=##Class(web.DHCEQCommon).GetApproveInfo(5,drowid)
    .s ApproveLen=$l(ApproveInfo,"_")
    .f i=1:1:ApproveLen  d
    ..i i=1 s ApproveList1=$p(ApproveInfo,"_",i)
    ..e  i i=2 s ApproveList2=$p(ApproveInfo,"_",i)
    ..e  i i=3 s ApproveList3=$p(ApproveInfo,"_",i)
    ..e  i i=4 s ApproveList4=$p(ApproveInfo,"_",i)
    ..e  i i=5 s ApproveList5=$p(ApproveInfo,"_",i)
    ..e  i i=6 s ApproveList6=$p(ApproveInfo,"_",i)
    .
    .s drlrowid=0
    .f  s drlrowid=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",drowid,drlrowid))  quit:drlrowid=""  d
    ..d ResetVariablesDisuseRequestMore
    ..s equipdr=$p($g(^DHCEQDisuseRequestList(drlrowid)),"^",2)
    ..s dlrowid=$p($g(^DHCEQDisuseRequestList(drlrowid)),"^",12)
    ..i dlrowid'="" s TRemark=$p($g(^DHCEQDisuseList(dlrowid)),"^",8)
    ..//add by cjt 20220917 需求号2931011 输出TDisuseReason
    ..i dlrowid'="" s TDisuseReason=$p($g(^DHCEQDisuseList(dlrowid)),"^",6)
    ..s TNo=$p($g(^DHCEQEquip(equipdr)),"^",71)
    ..s TName=$p($g(^DHCEQEquip(equipdr)),"^",1)
    ..s ManuFactoryDR = $p($g(^DHCEQEquip(equipdr)),"^",26)
    ..i ManuFactoryDR'="" s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR)),"^",1) //CZF0093
    ..s UnitDR=$p($g(^DHCEQEquip(equipdr)),"^",5)
    ..i UnitDR'="" s TUnit = $p($g(^DHCEQCCode("DHCEQCUOM",UnitDR)),"^",4)
    ..s ModelDR = $p($g(^DHCEQEquip(equipdr)),"^",3)
    ..i ModelDR'="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
    ..s ProviderDR = $p($g(^DHCEQEquip(equipdr)),"^",25)
    ..i ProviderDR'="" s TProvider= $p($g(^DHCEQCCode("DHCEQCVendor",ProviderDR)),"^",2)
    ..s TOriginalFee=$p($g(^DHCEQEquip(equipdr)),"^",27)  //原值
    ..s TNetfee=$p($g(^DHCEQEquip(equipdr)),"^",28)  //净值
    ..s TDepreTotalfee=$p($g(^DHCEQEquip(equipdr)),"^",35)  //累计折旧合计
    ..s TLimitYears=$p($g(^DHCEQEquip(equipdr)),"^",31)
    ..s TInDate=$p($g(^DHCEQEquip(equipdr)),"^",45)
    ..i TInDate'="" s TInDate=$zd(TInDate,3)
    ..s TRemark=$p($g(^DHCEQDisuseRequest(drowid)),"^",10)
    ..s EquipTypeDR=$p($g(^DHCEQDisuseRequest(drowid)),"^",44)
    ..i EquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
    ..d OutputRowDisuseRequestMore
    Quit $$$OK
OutputRowDisuseRequestMore
    s Data=$lb(TNo,TName,TModel,TManuFactory,TInDate,TOriginalFee,TUnit,TProvider,TLimitYears,TNetfee,TDepreTotalfee,TRemark,TEquipType,TRow,TDisuseReason,ApproveList1,ApproveList2,ApproveList3,ApproveList4,ApproveList5,ApproveList6)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    s TRow=TRow+1
    quit
ResetVariablesDisuseRequestMore
    s (TNo,TName,TModel,TManuFactory,TInDate,TOriginalFee,TUnit,TProvider,TLimitYears,TNetfee,TDepreTotalfee,TRemark,dlrowid,ManuFactoryDR,UnitDR,ModelDR,ProviderDR,TEquipType,TDisuseReason)=""
    quit
}

ClassMethod DisuseRequestMoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DisuseRequestMoreExecute ]
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

ClassMethod DisuseRequestMoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DisuseRequestMoreExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Mozy0217  2018-11-01
/// 判断报废单是否存在有配置设备
/// 		返回值		Find:空		未匹配到配置记录
/// w ##Class(web.DHCEQBatchDisuseRequest).CheckConfigDR(2)
ClassMethod CheckConfigDR(RowID As %String = "")
{
	n Find, KindFlag, EquipDR, ListID, len, i
	
	s Find=""
	i (RowID="") q Find
	
	s KindFlag=$Piece($Get(^DHCEQDisuseRequest(RowID)),"^",44)
 	if (KindFlag=0)
 	{	;单台设备
		s EquipDR=$Piece($Get(^DHCEQDisuseRequest(RowID)),"^",1)
		s ListID=""
    	f  s ListID=$o(^DHCEQEquip(0,"Parent",EquipDR,ListID)) quit:ListID=""  d
		.i Find'="" s Find=Find_","
		.s Find=Find_$Piece($Get(^DHCEQEquip(ListID,"OtherInfo")),"^",26)
 	}
 	elseif (KindFlag=1)
 	{	;批量设备
 		;s ListID=$Piece($Get(^DHCEQDisuseRequest(RowID)),"^",45)
 		s EquipDR = ^DHCEQDisuseRequest(RowID,"EX") ;"44,41"
 		s len=$l(EquipDR,",")
 		f i=1:1:len d
 		.s ListID=""
    	.f  s ListID=$o(^DHCEQEquip(0,"Parent",$p(EquipDR,",",i),ListID)) quit:ListID=""  d
		..i Find'="" s Find=Find_","
		..s Find=Find_$Piece($Get(^DHCEQEquip(ListID,"OtherInfo")),"^",26)
 	}
 	else
 	{	;多批设备
		
	}
	
	q Find
}

/// add by kdf 2019-06-10 需求号920964
/// 判断当前使用科室是否为库房
/// 入参LocDR:科室id
/// 返回值： 1：表示该科室为库房 ，0：表示该科室不是库房
ClassMethod CheckStoreLocDR(LocDR As %String = "")
{
	new LocTypeDR
	s LocTypeDR=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
	i $d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,LocDR)) q 1   
	e  q 0
}

/// Add By QW20191008 BUG:QW0028
/// 增加报废恢复功能
/// 入参:DRRowID
/// 返回值:0:成功 其他:不成功
/// w ##Class(web.DHCEQBatchDisuseRequest).RecoverDisUseEquip("34","3222406000005")
/// modified by czf 2021 01-14 CZF0129 增加勾选设备取消报废，可取消上月报废的设备
ClassMethod RecoverDisUseEquip(DRRowID As %String = "", DREquipNo As %String = "")
{
	i DRRowID="" q "-1^报废单不能为空!"
	///检测报废单
	s DRStatus=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",10)
	s DRInvalidFlag=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",53)
	i DRStatus'=2 q "-3^未审核完成单据请走业务处理!"
	i DRInvalidFlag="Y" q "-4^已无效单据不能执行此操作!"
	
	s DREQRowID=""		//czf 2021-01-14 begin CZF0129
	s EQStatus=""
	s DRLCount=0
	i DREquipNo'=""
	{
		s DREQRowID=$o(^DHCEQEquip(0,"No",DREquipNo,0))
		i DREQRowID'="" s EQStatus=$p($g(^DHCEQEquip(DREQRowID)),"^",38)
		i (DREquipNo'="")&&(DREQRowID="") q "-5^设备编号不存在!请正确输入!"
		i ((DREQRowID'="")&&(EQStatus'=3)) q "-6^该设备为有效设备!不能进行恢复."
		//检测单据是否多条明细
		s (DRLRowID,DRLFind)=0
		f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DRRowID,DRLRowID))  q:DRLRowID=""  d
		.s DRLEquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
		.i (DREQRowID'="")&&(DRLEquipDR=DREQRowID) s DRLFind=DRLRowID
		.s DRLCount=DRLCount+1
		i (DREquipNo'="")&&(DRLFind=0) q "-7^该报废单中不存在此设备!"
	}		//czf 2021-01-14 end CZF0129
	
	s DRAuditDate=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",21)
	s YearMonth=##Class(web.DHCEQReport).GetReportMonthByDate(DRAuditDate)
	s Year=$p(YearMonth,"-",1)
	s Month=+$p(YearMonth,"-",2)
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(YearMonth)
	s CurYearMonth=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)  //modified by wy 2020-4-29 1301750 日期转换成会计周期
	s MonthNum=##Class(web.DHCEQCommon).DateDiff("m",$ZD($ZDH(YearMonth_"-01",3),1),$ZD($ZDH(CurYearMonth_"-01",3),1))
	i (MonthNum>1)||(MonthNum=1) q "-8^此操作只执行当月月数据!"
	i MonthNum<0 q "-9^数据异常,不能操作!"
	s $ZT="ERRRecoverDisUseEquip"
	s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
	s SQLCODE=0
	
	TSTART
	//报废主表
	i ((DRLCount=1)||(DREquipNo=""))  d		//czf 2021-01-14 报废单只有一个设备或取消报废整个报废单 CZF0129
	.&SQL(Update SQLUSER.DHC_EQDisuseRequest Set DR_InvalidFlag='Y' where DR_RowID=:DRRowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_DRRowID ;modified By QW20191023 需求号:1065779 执行后界面不刷新问题
	}
	//Modify by zx 2020-08-28 BUG ZX0105 恢复共享资源状态
	s SQLCODE=##Class(web.DHCEQ.RM.BUSShareResource).ChangeShareResource(34,DRRowID,"0",DREQRowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_DRRowID
	}
	//多批报废明细表
	s DLRowID=0
	f  s DLRowID=$o(^DHCEQDisuseList(0,"Request",DRRowID,DLRowID))  q:(DLRowID="")||(SQLCODE'=0)  d
	.s DLSourceType=$p($g(^DHCEQDisuseList(DLRowID)),"^",2)
	.i (DREquipNo="")||(DRLCount=1) d		//取消整个报废单或者报废单只有一台设备 czf 2021-01-14 begin CZF0129
	..&SQL(Delete From SQLUSER.DHC_EQDisuseList Where DL_RowID=:DLRowID)
	.e  i DLSourceType=1  d		//批量中单个设备
	..s DLSourceID=","_$g(^DHCEQDisuseList(DLRowID,"EX"))_","
	..i DLSourceID[(","_DREQRowID_",")  d
	...s DLSourceID=##Class(web.DHCEQCommon).Replace(DLSourceID,","_DREQRowID_",",",")
	...s DLSourceID=$E(DLSourceID,2,$L(DLSourceID)-1)
	...s ^DHCEQDisuseList(DLRowID,"EX")=DLSourceID
	...&SQL(Update SQLUSER.DHC_EQDisuseList Set DL_Qty=DL_Qty-1 Where DL_RowID=:DLRowID)	//取消整个报废单或者报废单只有一台设备 czf 2021-01-14 end CZF0129
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_DRRowID ;modified By QW20191023 需求号:1065779 执行后界面不刷新问题
	}
	//add by wy 2020-4-30 1288746 无效对应汇总明细
	i ((DRLCount=1)||(DREquipNo=""))		//czf 2021-01-14 报废单只有一个设备或取消报废整个报废单
	{
		s DRMergeOrderFlag=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",54)
		if (DRMergeOrderFlag="Y")
		 {
			;Modified By QW20210525 BUG:QW0114
			&SQL(delete from  sqluser.DHC_EQMergeOrderList where ML_SourceID=:DRRowID)
			i SQLCODE
	 		{
				TROLLBACK
				q SQLCODE_"^"_DRRowID
	 		}
		 }
	}
	//报废明细
	s DRLRowID=0
	f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DRRowID,DRLRowID))  q:(DRLRowID="")||(SQLCODE'=0)  d
	.q:SQLCODE'=0
	.s DRLEquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	.q:(DREQRowID'="")&&(DRLEquipDR'=DREQRowID)		//czf 2021-01-14 CZF0129
	.&SQL(Delete From SQLUSER.DHC_EQDisuseRequestList Where DRL_RowID=:DRLRowID)
	.q:SQLCODE'=0
	.s EquipTypeDR=$p($g(^DHCEQEquip(DRLEquipDR)),"^",63)
	.s StatCatDR=$p($g(^DHCEQEquip(DRLEquipDR)),"^",75)
	.s LocDR=$p($g(^DHCEQEquip(DRLEquipDR)),"^",67)
	.s OrignDR=+$p($g(^DHCEQEquip(DRLEquipDR)),"^",20)
	.;生命周期
	.s LIRowID=0
	.f  s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSource",34,DRLEquipDR,DRLRowID,LIRowID))  q:(LIRowID="")||(SQLCODE'=0)  d
	..&SQL(Delete From SQLUSER.DHC_EQLifeInfo Where LI_RowID=:LIRowID)
	.q:SQLCODE'=0
	.;启用停用设备 czf 2021-12-28
	.s EquipStatus=$p($g(^DHCEQEquip(DRLEquipDR)),"^",38)
	.s EquipStockStatus=$p($g(^DHCEQEquip(DRLEquipDR)),"^",60)
	.i (EquipStockStatus=1)&&(EquipStatus=2) d
	..s ToStatus="1"
	..s Reason="报废恢复"
	..s SQLCODE=##class(web.DHCEQChangeInfo).StopEquipBySource(34,DRRowID,"0")
	..s val="^"_DRLEquipDR_"^^1^^34^"_DRRowID_"^^"_EquipStatus_"^"_ToStatus_"^^^^"_Reason_"^"
	..s SQLCODE=##Class(web.DHCEQChangeInfo).SaveData(val,"2")
	.q:SQLCODE'=0
	.;台账
	.s DRLUseFlag=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",11)		//报废前状态[0:在库 1:在用]
	.s EQStatus=1
	.i DRLUseFlag=0 s EQStatus=0
	.&SQL(Update SQLUSER.DHC_EQEquip Set EQ_Status=:EQStatus, EQ_DisuseDate=Null Where EQ_RowID=:DRLEquipDR)
	.q:SQLCODE'=0
	.;月结
	.s MRLRowID=0
	.f  s MRLRowID=$o(^DHCEQMonthReportList(0,"TypeDate",EquipTypeDR,Year,Month,StatCatDR,LocDR,MRLRowID))  q:(MRLRowID="")||(SQLCODE'=0)  d
	..s MRLOriginDR=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",26)
	..q:MRLOriginDR'=OrignDR
	..s MRLFundsType=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",38)
	..s FRowID=0
	..f  s FRowID=$o(^DHCEQFunds(0,"Source",6,DRLRowID,FRowID))  q:(FRowID="")||(SQLCODE'=0)  d
	...q:$p(^DHCEQFunds(FRowID),"^",10)="Y"
	...q:$p(^DHCEQFunds(FRowID),"^",6)="2"
	...s FundsType=$p(^DHCEQFunds(FRowID),"^",2)
	...i FundsType="" s FundsType=SelfFundsType
	...q:MRLFundsType'=FundsType
	...s FundsFee=+$p($g(^DHCEQFunds(FRowID)),"^",3)
	...i EQStatus=1  d
	....&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_Disused=MRL_Disused-:FundsFee, MRL_UsedEnd=MRL_UsedEnd+:FundsFee Where MRL_RowID=:MRLRowID)
	...e  d
	....&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_StockDisused=MRL_StockDisused-:FundsFee, MRL_StockEnd=MRL_StockEnd+:FundsFee Where MRL_RowID=:MRLRowID)
	.q:SQLCODE'=0
	.;资金来源
	.s FRowID=0
	.f  s FRowID=$o(^DHCEQFunds(0,"Source",6,DRLRowID,FRowID))  q:(FRowID="")||(SQLCODE'=0)  d
	..&SQL(Delete From SQLUSER.DHC_EQFunds Where F_RowID=:FRowID)
	.q:SQLCODE'=0
	.;快照
	.i SnapID'=""  d
	..s $p(^DHCEQSnapShot(SnapID,"Equip",DRLEquipDR),"^",38)=EQStatus
	..s $p(^DHCEQSnapShot(SnapID,"Equip",DRLEquipDR),"^",89)=""
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_DRRowID ;modified By QW20191023 需求号:1065779 执行后界面不刷新问题
	}
	
	TCOMMIT
	q 0_"^"_DRRowID ;modified By QW20191023 需求号:1065779 执行后界面不刷新问题
ERRRecoverDisUseEquip
	TRollBack	
	Set ErrMsg=$ZE	     //得到系统返回的错误消息
 	Quit "-2201^ERRRecoverDisUseEquip:"_ErrMsg     //返回错误消息 ;
}

/// add hly 20200311
/// 报废原因下拉框
ClassMethod Reason(name, width) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"'>"
	w "</select>",!
}

// Modify by zx 2020-03-13 BUG ZX0079

/// 扫描生成设备报废单
/// w ##class(web.DHCEQBatchDisuseRequest).BatchDisuseRequestBuild("25528","1","893")
/// ----------------------------------
ClassMethod BatchDisuseRequestBuild(EqRowID As %String = "", WeUser As %String = "", WeLoc As %String = "", Reason As %String = "")
{
	s result=0
	s EquipID=EqRowID
	if ($g(^DHCEQEquip(EquipID))="")
	{
		q "设备没找到---RowID="_EquipID
	}
	//Modify by zx 2021-05-20 移动端改造
	;s rtn=##Class(web.DHCEQBatchDisuseRequest).CheckEquipDR("","",EquipID,"","","Y")
	;s result=$p(rtn,"^",1)
	;i result'=0 q $p(rtn,"^",2)
 	s TUseLocDR = $p($g(^DHCEQEquip(EquipID)),"^",19)
 	s TOriginalFee = $p($g(^DHCEQEquip(EquipID)),"^",27)
 	s TOriginalFee=$fn(TOriginalFee,"",2)
  	
	s Date=+$H
 	set (rtn,result,requestRowID,RowID,GroupDR,UseState,DisuseTypeDR,ChangeReason,RequestNo,TotleTime,Income,CheckResult)=""
 	set (Remark,TechnicEvaluate,RepairHours,RepairFee,RepairTimes,ChangeReason,RequestNo,TotleTime,Income,CheckResult,InStockListDR)=""
 	Set ChangeReason=Reason
 	
 	set RequestLocDR=$p($g(^DHCEQEquip(EquipID)),"^",19)
 	set RequestDate=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
 	set DisureDate=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
 	set Status="1"
 	set LocDR=TUseLocDR
 	set LimitYears=$p($g(^DHCEQEquip(EquipID)),"^",31)
 	set EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)
 	set KindFlag=0
 	
 	set val=RowID_"^"_EquipID_"^"_GroupDR_"^"_RequestLocDR_"^"_RequestDate_"^"_UseState
  	set val=val_"^"_DisuseTypeDR_"^"_ChangeReason_"^"_DisureDate_"^"_Remark
  	for i=11:1:33
	{
		set val=val_"^"
	}
	set val=val_"^"_RequestNo_"^"_LocDR_"^"_TotleTime_"^"_Income_"^"_CheckResult_"^"_TechnicEvaluate_"^"_RepairHours
	set val=val_"^"_RepairFee_"^"_RepairTimes_"^"_LimitYears_"^"_KindFlag_"^"_InStockListDR_"^^^"_EquipTypeDR  //_"^"_BatchNo
    
 	s rtn=##class(web.DHCEQBatchDisuseRequest).SaveDisuseRequest(val,"","",0,"", WeUser, WeLoc)  //Modify by zx 2020-03-14 BUG ZX0090
 	s result=$p(rtn,"^",1)
 	if result'=0 q result
 	i result=0  d
 	.s requestRowID=$p(rtn,"^",2)
 	
 	s result=##Class(web.DHCEQChangeInfo).StopEquipBySource("34",requestRowID,"1","1",WeUser)
 	if result'=0 q result
	
 	s rtn=##class(web.DHCEQBatchDisuseRequest).SubmitData(requestRowID, WeUser)
 	s result=$p(rtn,"^",1)
 	if result'=0 q result
	 	
	q result
}

/// Create by wy 2020-04-29 1294046
/// 描述：删除报废原因明细。
/// 入参：val 报废原因ID串 RSourceID 报废主单ID 
/// 返回值：返回成功标志 0 成功  其他 失败
/// w ##Class(web.DHCEQBatchDisuseRequest).DeletePReason(1,327)
ClassMethod DeletePReason(val, RSourceID)
{
	new Flag,RRowID
	s (Flag,RRowID)=0
	i (RSourceID="") q ""
	i (val="")
	{
		&SQL(delete from sqluser.DHC_EQPReason where R_SourceID=:RSourceID)
	}
	else
	{
		f  s RRowID=$o(^DHCEQPReason(0,"RSourceID",RSourceID,RRowID))  q:RRowID=""  d
		.s RReasonDR=$p($g(^DHCEQPReason(RRowID)),"^",4)
		.i (","_val_",")'[(","_RReasonDR_",") &SQL(delete from  sqluser.DHC_EQPReason where R_RowID=:RRowID)
	}
	If SQLCODE Set Flag=SQLCODE
	Quit Flag
}

/// Create by wy 2020-05-06 1294046
/// 描述：根据报废主单ID取汇总单的标志。
/// 入参：DRRowID报废主单ID 
/// 返回值：返回汇总单的标志 0 有汇总单  1 无
/// w ##Class(web.DHCEQBatchDisuseRequest).GetMergeOrderFlag(6)
ClassMethod GetMergeOrderFlag(DRRowID)
{
	new vFlag
	i DRRowID="" q ""
	s DRMergeOrderFlag=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",54)
    i DRMergeOrderFlag="Y" d
    .s vFlag=0
    e  d
    .s vFlag=1
	Quit vFlag
}

/// add by mwz 20220830
/// 获当前报废单最后一步审批角色
/// 入参：DRRowID 报废单RowID
/// w ##Class(web.DHCEQBatchDisuseRequest).GetDisuseApproveRole(6)
ClassMethod GetDisuseApproveRole(DRRowID)
{
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")   
	s AIRowID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,DRRowID,0))
	s TApprovals=""
	i AIRowID'="" Do
	.s TApproveRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	.i TApproveRole'="" s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRole),"^",2)	
	i $p($g(^DHCEQDisuseRequest(DRRowID)),"^",10)=0 s TApprovals=""
	q TApprovals
}

/// Add By ZC0133 2023-4-20 
/// 增加报废恢复功能
/// 入参:RequestNo  :  报废单号
///      Flag  :  0  单据作废   1 单据恢复到上一步审批
/// 返回值:0:成功 其他:不成功
/// w ##Class(web.DHCEQBatchDisuseRequest).RecDisuseStep("BF2021040010",1)
ClassMethod RecDisuseStep(RequestNo As %String = "", Flag As %String = "0")
{
	new RowID,DRRowID,ReportStartDate,ReportEndDate,DRInvalidFlag,DRStatus,DRAuditDate
	i RequestNo="" q "报废单号不能为空!"
	s vMonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	s ReportStartDate=##Class(web.DHCEQReport).GetReportDate(vMonthStr,"1")
	
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	s ReportStartDate=##class(web.DHCEQCommon).TransValueFromPage(ReportStartDate,"date")
	s ReportEndDate=##Class(web.DHCEQReport).GetReportDate(vMonthStr,"2")
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	s ReportEndDate=##class(web.DHCEQCommon).TransValueFromPage(ReportEndDate,"date")
	Set $ZT="ERRORRecDisuseStep"
	s SQLCODE=0
	i $D(^DHCEQDisuseRequest(0,"RequestNo"," "_RequestNo)) d
	.s DRRowID=$o(^DHCEQDisuseRequest(0,"RequestNo"," "_RequestNo,0))	
	.s DRStatus=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",10)
	.q:DRStatus'=2
	.s DRInvalidFlag=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",53)
	.q:DRInvalidFlag="Y"
	.s vRowID=DRRowID
	.s DRAuditDate=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",21)
	i vRowID="" q "报废单不存在!"
	s MaxCALRowID=0
	s CALRowID=0
	f  s CALRowID=$o(^DHCEQApproveList(0,"Source",5,vRowID,CALRowID)) q:CALRowID=""  d
	.q:$p($g(^DHCEQApproveList(CALRowID)),"^",10)="Y"
	.q:$p($g(^DHCEQApproveList(CALRowID)),"^",12)="1"
	.i CALRowID>MaxCALRowID d
	..s MaxCALRowID=CALRowID
	s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",5,vRowID,0))
	s NextRole=$p($g(^DHCEQApproveInfo(AIRowID)),"^",7)
	s NextStep=$p($g(^DHCEQApproveInfo(AIRowID)),"^",6)
	s ApproveSet=$p($g(^DHCEQDisuseRequest(vRowID)),"^",27)
	s DisUseAduitRole=$p($g(^DHCEQDisuseRequest(vRowID)),"^",31)
	s ApproveStep=+$p($g(^DHCEQApproveInfo(AIRowID)),"^",6)-1
	i (ApproveStep>0) d
	.s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,ApproveStep,0))
	.s ApproveRole=$p(^DHCEQCCode("DHCEQCApproveFlow",AFRowID),"^",2)
	e  d
	.s ApproveRole=""
	s approveroleid=##class(web.DHCEQCommon).GetSysInfo("601003")
	TSTART
	//报废明细
	s DRLRowID=0
	f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",vRowID,DRLRowID))  q:(DRLRowID="")||(SQLCODE'=0)  d
	.q:SQLCODE'=0
	.s DRLEquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	.;生命周期
	.s LIRowID=0
	.f  s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSource",34,DRLEquipDR,DRLRowID,LIRowID))  q:(LIRowID="")||(SQLCODE'=0)  d
	..&SQL(Delete From SQLUSER.DHC_EQLifeInfo Where LI_RowID=:LIRowID)
	.q:SQLCODE'=0
	.;台账
	.s DRLUseFlag=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",11)		//报废前状态[0:在库 1:在用]
	.s EQStatus=1
	.i DRLUseFlag=0 s EQStatus=0
	.&SQL(Update SQLUSER.DHC_EQEquip Set EQ_Status=:EQStatus, EQ_DisuseDate=Null Where EQ_RowID=:DRLEquipDR)
	.q:SQLCODE'=0
	.i +DisUseAduitRole>0 d
	..i (approveroleid=ApproveRole)  d
	...s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus($p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2),"2","预报废")
	..e  d
	...s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus($p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2),"1","报废提交")
	..q:SQLCODE'=0
	..&SQL(update sqluser.DHC_EQDisuseRequestList  set DRL_Hold1=NULL where DRL_RowID=:DRLRowID)
	..q:SQLCODE'=0
	.e  d
	..s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus($p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2),"","")
	..q:SQLCODE'=0
	..&SQL(delete from sqluser.DHC_EQDisuseRequestList  where DRL_RowID=:DRLRowID)
	..q:SQLCODE'=0
	.;资金来源
	.s FRowID=0
	.f  s FRowID=$o(^DHCEQFunds(0,"Source",6,DRLRowID,FRowID))  q:(FRowID="")||(SQLCODE'=0)  d
	..&SQL(Delete From SQLUSER.DHC_EQFunds Where F_RowID=:FRowID)
	..q:SQLCODE'=0
	.s InfoStrs=DRLEquipDR_"^6^"_DRAuditDate_"^报废恢复^1"
	.s SQLCODE=##Class(web.DHCEQMonthDepre).ExecuteAdjustDataNew(InfoStrs,1)
	.q:SQLCODE'=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_vRowID 
	}
	if (+DisUseAduitRole>0)
	{
		&SQL(Update SQLUSER.DHC_EQApproveInfo Set AI_NextRoleDR=:NextRole,AI_NextFlowStep=:NextStep,AI_ApproveStatus=:ApproveStep ,AI_ApproveRoleDR=:ApproveRole ,AI_Status='1' where AI_RowID=:AIRowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^"_vRowID 
		}
		&SQL(Update SQLUSER.DHC_EQDisuseRequest Set DR_Status="1",DR_AuditUserDR=NULL,DR_AuditDate=NULL,DR_AuditTime=NULL,DR_NextRoleDR=:NextRole,DR_NextFlowStep=:NextStep,DR_ApproveStatu=:ApproveStep,DR_ApproveRoleDR=:ApproveRole where DR_RowID=:vRowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^"_vRowID 
		}
		if (Flag'=0)
		{
			&SQL(Delete From SQLUSER.DHC_EQApproveList Where AL_RowID=:MaxCALRowID)
		
		}
		else
		{
			&SQL(Update SQLUSER.DHC_EQDisuseRequest Set DR_InvalidFlag="Y" where DR_RowID=:vRowID)
	
		}
	}
	else
	{
		&SQL(Delete From SQLUSER.DHC_EQApproveInfo  where AI_RowID=:AIRowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^"_vRowID 
		}
		
		&SQL(Delete From SQLUSER.DHC_EQApproveList Where AL_RowID=:MaxCALRowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^"_vRowID 
		}
		&SQL(Update SQLUSER.DHC_EQDisuseRequest Set DR_Status="0",DR_SubmitUserDR=NULL,DR_SubmitDate=NULL,DR_SubmitTime=NULL,DR_AuditUserDR=NULL,DR_AuditDate=NULL,DR_AuditTime=NULL,DR_NextRoleDR=NULL,DR_NextFlowStep=NULL,DR_ApproveStatu=NULL,DR_ApproveRoleDR=NULL where DR_RowID=:vRowID)
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_vRowID 
	}
	s SQLCODE=##Class(web.DHCEQBatchDisuseRequest).RecDisuseMessages(34,vRowID) 
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_vRowID 
	}
	
	if ((DRAuditDate<ReportStartDate)||(DRAuditDate>(ReportEndDate)))
	{
		s YearMonth=##Class(web.DHCEQReport).GetReportMonthByDate(DRAuditDate)
		s CurYearMonth=$P($ZD(+$H,3),"-",1,2)	
		s SQLCODE=##Class(web.DHCEQJob).insertMonthReport(YearMonth,CurYearMonth)
			
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_vRowID 
	}
	
	TCOMMIT
	q 0_"^"_DRRowID 
ERRORRecDisuseStep
	TRollBack	
	Set ErrMsg=$ZE	     //得到系统返回的错误消息
 	Quit "-2201^ERRORRecDisuseStep:"_ErrMsg     //返回错误消息 ;
}

/// Add By ZC0133 2023-4-20 
/// w ##Class(web.DHCEQBatchDisuseRequest).RecDisuseMessages() 
ClassMethod RecDisuseMessages(vBussType, vBussID)
{
    s SQLCODE=0
    s MaxMessageDR=0
    s vMessageDR=""
    s vMessageID=0
	for  s vMessageID=$o(^DHCEQMessages(0,"MessageType",1,vBussType,vBussID,vMessageID)) q:((vMessageID="")||(SQLCODE'=0))  d
    .s MessageDR=vMessageID
    .i MessageDR>MaxMessageDR d
	..s MaxMessageDR=MessageDR
    i +MaxMessageDR=0 q 0
    &SQL(Update sqluser.DHC_EQMessages set M_DealFlag="N",M_DealUserDR=NULL,M_DealDate=NULL,M_DealTime=NULL Where M_RowID=:MaxMessageDR)	
    q SQLCODE
}

}
