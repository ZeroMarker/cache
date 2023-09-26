/// -------------------------------
/// 修改：HZY 2011-09-06 HZY0011
/// 新增方法：GetEquipCollect , GetEquipCollectList
/// 描述：查询设备按一定条件分组汇总的结果。
/// -------------------------------
/// 修改:ZY 2011-02-22 ZY0061
/// 描述:GetEquipList预报废处理
/// -------------------------------
/// 修改:DJ 2010-12-29
/// 描述:GetShortEquip查询Status,UseLoc过滤条件修改,解决封存设备被过滤问题
/// -------------------------------
/// 修改:ZY 2009-11-17  zy0017
/// 新增方法:GetNextNoNew
/// 描述:“分类编号”使用财政部分类代码（取6位，把“-”去掉）+4位序号
/// -------------------------------
/// 修改:ZY 2009-11-12  zy0016
/// 增加方法:BatchUpdate,SaveData
/// 描述:机型,生产厂家,供应商的rowid在js中进行处理;当InStockListDR为空时不能修改
/// -------------------------------
/// 修改：JDL 2009-09-12   JDL0027
/// 增加方法：GetChangedAmount；HasChangeAccount；HasAffix
/// 描述:增加获取设备调账合计及判断是否有有效附件及有效调账记录的方法
/// -------------------------------
/// 修改：zy 2009-07-16   zy0005
/// 修改方法：GetOtherListInfo
/// 描述:设备检验单，增加返回了设备附件编号数据信息
/// -------------------------------
/// Modified by jdl 2009-06-30 JDL0019
/// Add Method:GetEquipList
/// Description:设备台帐查询,按批次显示时，总计数量不正确
/// -------------------------------
/// Modified by jdl 2009-06-18 JDL0017
/// Add Method:UpdateEquipsByList,GetEquipsByMove
/// Description:出库单审核后，出库明细里可以批修改设备出厂编号
/// -------------------------------
/// Modified by jdl 2009-06-03 JDL0004
/// Modified Method:GetInStockDate
/// -------------------------------
/// Modified by jdl 2009-06-02 JDL0006
/// Modified Method:SaveData
/// --------------------------------
Class web.DHCEQEquip Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 376;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EQ_Code";

Parameter SQLDESCRIPTION = "EQ_ItemDR";

Parameter SQLROWID = "EQ_RowID";

Parameter GlobalLen = 95;

ClassMethod DelData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", user As %Library.String = "")
{
 k PLIST,rowid,updDate
 s rowid=$p(val,"^",1)
 s updDate=+$H
 s updTime=$P($H,",",2)
 &SQL(update SQLUSER.DHC_EQEquip set EQ_InvalidFlag='Y',EQ_UpdateDate=:updDate,EQ_UpdateTime=:updTime,EQ_UpdateUserDR=:user where EQ_RowID = :rowid)
 q SQLCODE
}

ClassMethod GetEquipByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex,i,count,EquipTechLevel
	s EquipTechLevel=""
	s (result,resultex)=""
	s result= ^DHCEQEquip(rowid)
	set count=..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}
	s resultex=resultex_"^"	;ModelDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;EquiCatDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(result,"^",4))),"^",2)
	s resultex=resultex_"^"	;UnitDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",5))
	s resultex=resultex_"^"	;InstallLocDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",8))
	s $p(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;InstallDate	
	s $p(result,"^",11)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;LeaveFactoryDate
	s $p(result,"^",12)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")	;OpenCheckDate
	s $p(result,"^",13)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"date")	;CheckDate
	s $p(result,"^",14)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",14),"date")	;MakeDate
	s $p(result,"^",15)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",15),"bool")	;ComputerFlag
	s resultex=resultex_"^"	;CountryDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("cou",$p(result,"^",16))
	s resultex=resultex_"^"	;ManageLocDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",17))
	s resultex=resultex_"^"	;ManageLevelDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManageLevel",$p(result,"^",18))),"^",2)
	s resultex=resultex_"^"	;UseLocDR
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",19))
	s resultex=resultex_"^"	;OriginDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCOrigin",$p(result,"^",20))),"^",2)
	s resultex=resultex_"^"	;FromDeptDR
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",21))),"^",2)
	s resultex=resultex_"^"	;ToDeptDR
	i $p(result,"^",22)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",22))),"^",2)
	s resultex=resultex_"^"	;BuyTypeDR
	i $p(result,"^",23)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBuyType",$p(result,"^",23))),"^",2)
	s resultex=resultex_"^"	;ProviderDR
	i $p(result,"^",25)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",25))
	s resultex=resultex_"^"	;ManuFactoryDR
	i $p(result,"^",26)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p(result,"^",26)) //modified by CZF0103
	s $p(result,"^",27)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",27),"")
	s $p(result,"^",28)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",28),"")
	s $p(result,"^",29)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",29),"")
	s resultex=resultex_"^"	;GroupDR
	i $p(result,"^",30)'=""  d
	.s resultex=resultex_$p($g(^DHCEQGroup($p(result,"^",30))),"^",2)
	s resultex=resultex_"^"	;ContractListDR
	i $p(result,"^",32)'=""  d
	.s contractdr=$p($g(^DHCEQContractList($p(result,"^",32))),"^",1)	
	.s resultex=resultex_$p($g(^DHCEQContract(contractdr)),"^",1)
	.//s resultex=resultex_$p($g(^DHCEQContractList($p(result,"^",32))),"^",2)
	s resultex=resultex_"^"	;DepreMethodDR
	i $p(result,"^",33)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDepreMethod",$p(result,"^",33))),"^",2)
	s $p(result,"^",35)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",35),"")
	s resultex=resultex_"^"	;WorkLoadUnitDR
	i $p(result,"^",37)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",37))
	s resultex=resultex_"^"	;ManageUserDR
	i $p(result,"^",39)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",39))
	s resultex=resultex_"^"	;MaintUserDR
	i $p(result,"^",40)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",40))
	s $p(result,"^",43)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",43),"")
	s $p(result,"^",44)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",44),"date")	;StartDate
	i $p(result,"^",45)'="" d //2009-09-19 党军 begin
	.s $p(result,"^",45)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",45),"date")	;TransAssetDate
	e  d
	.i $p(result,"^",70)'="" d
	..s ISRowID=$p($g(^DHCEQInStockList($p(result,"^",70))),"^",1)
	..s $p(result,"^",45)=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(ISRowID)),"^",13),"date") //2009-09-19 党军 end
	s $p(result,"^",46)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",46),"bool")	;GuaranteeFlag
	s $p(result,"^",47)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",47),"bool")	;InputFlag
	s $p(result,"^",48)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",48),"bool")	;TestFlag
	s $p(result,"^",49)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",49),"bool")	;MedicalFlag
	s $p(result,"^",50)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",50),"date")	;GuaranteeStartDate
	s $p(result,"^",51)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",51),"date")	;GuaranteeEndDate
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",52)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",52))
	s $p(result,"^",53)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",53),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",55)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",55))
	s $p(result,"^",56)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",56),"date")	;UpdateDate
	///
	s $p(result,"^",62)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",62),"bool")	;UrgencyFlag
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",63)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",63))),"^",2)
	s resultex=resultex_"^"	;PurchaseTypeDR
	i $p(result,"^",64)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurchaseType",$p(result,"^",64))),"^",2)
	s resultex=resultex_"^"	;PurposeTypeDR
	i $p(result,"^",65)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurposeType",$p(result,"^",65))),"^",2)
	s resultex=resultex_"^"	;KeeperDR
	i $p(result,"^",66)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",66))
	s resultex=resultex_"^"	;StoreLocDR
	i $p(result,"^",67)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",67))
	s resultex=resultex_"^"	;ServiceDR
	i $p(result,"^",69)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("service",$p(result,"^",69))    //modified by ZY 20220816
	s resultex=resultex_"^"	;InStockListDR
	i $p(result,"^",70)'=""  d
	.s resultex=resultex_$p($g(^DHCEQInStockList($p(result,"^",70))),"^",1)
	
	///////
	//状态
	s resultex=resultex_"^"_..GetEquipStatusDisplay($p(result,"^",38))
	//加
	s resultex=resultex_"^"
	i $p(result,"^",24)'=""  d 
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCTechLevel",$p(result,"^",24))),"^",2)
	s resultex=resultex_"^"	;StatCatDR
	i $p(result,"^",75)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p(result,"^",75))),"^",2)
	s resultex=resultex_"^"_##class(web.DHCEQEquip).GetInStockDate(rowid,0)
		
	//add by Mozy 2009-2-27
	s resultex=resultex_"^"	;EquipeCatCode
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(result,"^",4))),"^",1)
	///新增:2009-12-02 党军 begin DJ0035
	s $p(result,"^",80)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",80),"bool")		//Add By DJ 2017-01-20
	s $p(result,"^",81)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",81),"bool")
	s $p(result,"^",82)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",82),"bool")
	s $p(result,"^",83)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",83),"bool")
	///2009-12-02 党军 end DJ0035
	s $p(result,"^",93)=##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus($p(result,"^",93))	/// 20150922  Mozy0166
	
	//add by jdl 2009-9-25  JDL0036
	//格式化金额为小数点两位
	i $p(result,"^",27)'="" s $p(result,"^",27)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",27),"")	;OriginalFee
	i $p(result,"^",28)'="" s $p(result,"^",28)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",28),"")	;NetFee
	i $p(result,"^",29)'="" s $p(result,"^",29)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",29),"")	;NetRemainFee
	i $p(result,"^",35)'="" s $p(result,"^",35)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",35),"")	;DepreTotalFee
	
	//Add By jdl 2010-12-16
	s resultex=resultex_"^"
	i $p(result,"^",72)'="" d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCLocation",$p(result,"^",72))),"^",2)
	///Add By DJ 2013-01-10
	s resultex=resultex_"^"_##Class(web.DHCEQCommon).GetHospitalDesc($p(result,"^",67))
	// 增加68码 Mozy0110
	Set (MIHold1,MIHold1Code,MIHold1Desc)=""
	Set resultex=resultex_"^"	;ItemDR
	If $Piece(result,"^",7)'=""  Do
	.;Add By DJ 2013-06-24 DJ0118
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",7))),"^",1)
	.///modfied by ZY0307 20220713 表结构发生了变化,取值位置变化
	.Set MIHold1=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",$Piece(result,"^",7))),"^",9)
	.If MIHold1'="" Do
	..Set MIHold1Code=$Piece(^DHCEQCCode("DHCEQCTree",MIHold1),"^",2)
	..Set MIHold1Desc=$Piece(^DHCEQCCode("DHCEQCTree",MIHold1),"^",3)
	Set resultex=resultex_"^"_MIHold1_"^"_MIHold1Code_"^"_MIHold1Desc
	///Add By DJ 2013-12-11 DJ0122
	s resultex=resultex_"^"
	i $p(result,"^",94)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBrand",$p(result,"^",94))),"^",3)
	s resultex=resultex_"^"_..GetFundsInfo(rowid) //2014-6-25 HZY
	
	Set resultex=resultex_"^"		;入库单号	Mozy0132	2014-6-25
	If $Piece(result,"^",70)'=""  Do
	.Set InStockDR = $Piece($Get(^DHCEQInStockList($Piece(result,"^",70))),"^",1)
	.Set resultex=resultex_$Piece($Get(^DHCEQInStock(InStockDR)),"^",14)

	s resultex=resultex_"^"
	i $p(result,"^",77)'=""  d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList($p(result,"^",77))),"^",1)
	
	//Add By DJ 2014-08-21 DJ0126
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",1)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",2)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",3)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",4)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",5)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",6)
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",7),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",8),"date")
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",9)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",10)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",11)
	s resultex=resultex_"^"_$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",12)
	/// Mozy0145	20141017
	Set resultex=resultex_"^"_$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",13)
	Set resultex=resultex_"^"_$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",14)
	Set resultex=resultex_"^"_$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",15)
	Set resultex=resultex_"^"_$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",16)
	Set resultex=resultex_"^"_$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",17)
	Set resultex=resultex_"^"	;UserDR
	If $Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",15)'=""  d
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",15))
	//modify BY:GBX 2014-12-02  维修费用合计
	Set resultex=resultex_"^"_..GetMaintTotleFee(rowid)
	//modify BY:GBX 2014-12-02
	
	s result=result_resultex
	//add by zy 20150610 ZY0128
	s result=result_"^"_##Class(web.DHCEQChangeAccount).GetAddDepreTotalNum(rowid)  //显示调账处增加的折旧月份数
	
	//20150630  Mozy0154
	Set result=result_"^"
	If $Piece(result,"^",95)'="" Do
	.Set result=result_$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",$Piece(result,"^",95))),"^",2)
	Set result=result_"^"
	i $p(result,"^",86)'=""  d
	.s result=result_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",86))
	s $p(result,"^",87) = $CASE($p(result,"^",87),"1":"借出",:"在库")
	
	; 已折旧月数	^DHCEQDepreSet("0","EquipMain","6","Y","6")		Mozy0226	2019-9-22
	Set result=result_"^"
	Set tmpDSDR=$o(^DHCEQDepreSet("0","EquipMain",rowid,"Y",""))
	If tmpDSDR'="" Set result=result_$Piece($Get(^DHCEQDepreSet(tmpDSDR)),"^",22)
	Set result=result_"^"	;上一次费用	MR_TotalFee
	s tmpSourceID=$o(^DHCEQLifeInfo("0","EquipSource",31,rowid,""),-1)
	If tmpSourceID'="" Set result=result_$Piece($Get(^DHCEQMMaintRequest(tmpSourceID)),"^",60)
	
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// 2014-12-02 Add BY:GBX 2014-12-02 获取维修总费用
/// 返回值：维修费用合计
ClassMethod GetMaintTotleFee(rowid)
{
	q:(rowid="") "0"
	s MaintTotalFee=0
	s (MaintID,ExObjDR,EquipID)=""
	f  s MaintID=$o(^DHCEQMMaintRequest(MaintID)) q:MaintID=""  d
	.s InvalidFlag=$p($g(^DHCEQMMaintRequest(MaintID)),"^",57)
	.q:(InvalidFlag'="N")
	.s MRStatus=$p($g(^DHCEQMMaintRequest(MaintID)),"^",41)
	.q:(MRStatus'=2)
	.s ExObjDR=$p($g(^DHCEQMMaintRequest(MaintID)),"^",6)
	.i ExObjDR'="" d
	..s ExType=$p($g(^DHCEQMExObj(ExObjDR)),"^",4)  //扩展类型
	..q:(ExType'=1)
	..s EquipID=$p($g(^DHCEQMExObj(ExObjDR)),"^",5)
	..q:(rowid'=EquipID)
	..s MaintTotalFee=MaintTotalFee+$p($g(^DHCEQMMaintRequest(MaintID)),"^",60)  //维修总费用
	
	q MaintTotalFee
}

/// 2014-6-20 HZY0055 获取资金来源描述信息
/// w ##Class(web.DHCEQEquip).GetFundsInfo("123,124")
/// 返回值：自筹=123,财政=234,科研=345
ClassMethod GetFundsInfo(EquipIDs)
{
	n length,i,equipRowID,node
	n FTDR,FRowID,FundsInfo,FundsType,FundsFee
	s Times=$H
	s node="web.DHCEQEquip.GetFundsInfo"
	k ^DHCEQTemp(node,Times,$j)
	i EquipIDs="" q ""
	
	s FundsInfo=""
	s length=$l(EquipIDs,",")
	f i=1:1:length d
	.s equipRowID=$p(EquipIDs,",",i)
	.q:equipRowID=""
	.s FTDR=0
	.f  s FTDR=$o(^DHCEQFunds("0","EquipType",equipRowID,FTDR))  q:FTDR=""  d
	..s FRowID=0
	..f  s FRowID=$o(^DHCEQFunds("0","EquipType",equipRowID,FTDR,FRowID))  q:FRowID=""  d
	...q:$p($g(^DHCEQFunds(FRowID)),"^",10)="Y"
	...s FundsFee=$p($g(^DHCEQFunds(FRowID)),"^",3)
	...i length=1  d
	....d BuildDataFundsInfo
	...e  d
	....s ^DHCEQTemp(node,Times,$j,FTDR)=+$g(^DHCEQTemp(node,Times,$j,FTDR))+FundsFee
	
	i length>1  d
	.s FundsInfo=""
	.s FTDR=0
	.f  s FTDR=$o(^DHCEQTemp(node,Times,$j,FTDR)) q:FTDR=""  d
	..s FundsFee=^DHCEQTemp(node,Times,$j,FTDR)
	..d BuildDataFundsInfo
	
	k ^DHCEQTemp(node,Times,$j) 
	q FundsInfo
	
BuildDataFundsInfo
	s FundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTDR)),"^",2)
	i FundsInfo="" d
	.s FundsInfo=FundsType_"="_FundsFee
	e  d
	.s FundsInfo=FundsInfo_","_FundsType_"="_FundsFee
}

ClassMethod GetEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetEquipExecute(ByRef qHandle As %Binary, vEquipName As %String = "", vEquipNo As %String = "", vModelDR As %String = "", vManageLocDR As %String = "", vUseLocDR As %String = "", vStatus As %String = "", vEquipCatDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetEquip
	Quit $$$OK
BuildDataGetEquip
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	.d ResetVariablesGetEquip
	.s RowID = rowid
	.s Name = $p($g(^DHCEQEquip(rowid)),"^",1)
	.s ABCType = $p($g(^DHCEQEquip(rowid)),"^",2)
	.s ModelDR = $p($g(^DHCEQEquip(rowid)),"^",3)
	.i ModelDR '=""  d
	..s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	.s EquiCatDR = $p($g(^DHCEQEquip(rowid)),"^",4)
	.i EquiCatDR '=""  d
	..s EquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",EquiCatDR)),"^",2)
	.s UnitDR = $p($g(^DHCEQEquip(rowid)),"^",5)
	.i UnitDR '=""  d
	..s Unit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	.s Code = $p($g(^DHCEQEquip(rowid)),"^",6)
	.s Desc = $p($g(^DHCEQEquip(rowid)),"^",7)
	.s InstallLocDR = $p($g(^DHCEQEquip(rowid)),"^",8)
	.i InstallLocDR '=""  d
	..s InstallLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",InstallLocDR)
	.s InstallDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",9),"date")
	.s LeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	.s LeaveFactoryDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",11),"date")
	.s OpenCheckDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",12),"date")
	.s CheckDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",13),"date")
	.s MakeDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",14),"date")
	.s ComputerFlag = $p($g(^DHCEQEquip(rowid)),"^",15)
	.s CountryDR = $p($g(^DHCEQEquip(rowid)),"^",16)
	.i CountryDR '=""  d
	..s Country =##class(web.DHCEQCommon).GetTrakNameByID("cou",CountryDR)
	.s ManageLocDR = $p($g(^DHCEQEquip(rowid)),"^",17)
	.i ManageLocDR '=""  d
	..s ManageLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",ManageLocDR) ; ##class(web.DHCEQCommon).GetTrakNameByID("dept",ManageLocDR)	
	.s ManageLevelDR = $p($g(^DHCEQEquip(rowid)),"^",18)
	.i ManageLevelDR '=""  d
	..s ManageLevel = $p($g(^DHCEQCCode("DHCEQCManageLevel",ManageLevelDR)),"^",2)
	.s UseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	.i UseLocDR '=""  d
	..s UseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
	.s OriginDR = $p($g(^DHCEQEquip(rowid)),"^",20)
	.i OriginDR '=""  d
	..s Origin = $p($g(^DHCEQCCode("DHCEQCOrigin",OriginDR)),"^",2)
	.s FromDeptDR = $p($g(^DHCEQEquip(rowid)),"^",21)
	.i FromDeptDR '=""  d
	..s FromDept = ##class(web.DHCEQCommon).GetTrakNameByID("dept",FromDeptDR)
	.s ToDeptDR = $p($g(^DHCEQEquip(rowid)),"^",22)
	.i ToDeptDR '=""  d
	..s ToDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",ToDeptDR)),"^",2)
	.s BuyTypeDR = $p($g(^DHCEQEquip(rowid)),"^",23)
	.i BuyTypeDR '=""  d
	..s BuyType = $p($g(^DHCEQCCode("DHCEQCBuyType",BuyTypeDR)),"^",2)
	.s EquipTechLevelDR  = $p($g(^DHCEQEquip(rowid)),"^",24)
	.s ProviderDR = $p($g(^DHCEQEquip(rowid)),"^",25)
	.i ProviderDR '=""  d
	..s Provider =##class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
	.s ManuFactoryDR = $p($g(^DHCEQEquip(rowid)),"^",26)
	.i ManuFactoryDR '=""  d
	..s ManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR)),"^",1)
	.s OriginalFee = $p($g(^DHCEQEquip(rowid)),"^",27)
	.s NetFee = $p($g(^DHCEQEquip(rowid)),"^",28)
	.s NetRemainFee = $p($g(^DHCEQEquip(rowid)),"^",29)
	.s GroupDR = $p($g(^DHCEQEquip(rowid)),"^",30)
	.i GroupDR '=""  d
	..s Group = $p($g(^DHCEQGroup(GroupDR)),"^",2)
	.s LimitYearsNum = $p($g(^DHCEQEquip(rowid)),"^",31)
	.s ContractListDR = $p($g(^DHCEQEquip(rowid)),"^",32)
	.i ContractListDR '=""  d
	..s ContractList = $p($g(^DHCEQContractList(ContractListDR)),"^",1)
	.s DepreMethodDR = $p($g(^DHCEQEquip(rowid)),"^",33)
	.i DepreMethodDR '=""  d
	..s DepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",2)
	.s Remark = $p($g(^DHCEQEquip(rowid)),"^",34)
	.s DepreTotalFee = $p($g(^DHCEQEquip(rowid)),"^",35)
	.s DesignWorkLoadNum = $p($g(^DHCEQEquip(rowid)),"^",36)
	.s WorkLoadUnitDR = $p($g(^DHCEQEquip(rowid)),"^",37)
	.i WorkLoadUnitDR '=""  d
	..s WorkLoadUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",WorkLoadUnitDR)
	.s Status = $p($g(^DHCEQEquip(rowid)),"^",38)
	.s ManageUserDR = $p($g(^DHCEQEquip(rowid)),"^",39)
	.i ManageUserDR '=""  d
	..s ManageUser =##class(web.DHCEQCommon).GetTrakNameByID("user",ManageUserDR)
	.s MaintUserDR = $p($g(^DHCEQEquip(rowid)),"^",40)
	.i MaintUserDR '=""  d
	..s MaintUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",MaintUserDR)
	.s ContactUser = $p($g(^DHCEQEquip(rowid)),"^",41)
	.s ContactMode = $p($g(^DHCEQEquip(rowid)),"^",42)
	.s AppendFeeTotalFee = $p($g(^DHCEQEquip(rowid)),"^",43)
	.s StartDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",44),"date")
	.s TransAssetDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",45),"date")
	.s GuaranteeFlag = $p($g(^DHCEQEquip(rowid)),"^",46)
	.s InputFlag = $p($g(^DHCEQEquip(rowid)),"^",47)
	.s TestFlag = $p($g(^DHCEQEquip(rowid)),"^",48)
	.s MedicalFlag = $p($g(^DHCEQEquip(rowid)),"^",49)
	.s GuaranteeStartDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",50),"date")
	.s GuaranteeEndDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",51),"date")
	.s AddUserDR = $p($g(^DHCEQEquip(rowid)),"^",52)
	.i AddUserDR '=""  d
	..s AddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",AddUserDR)
	.s AddDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",53),"date")
	.s AddTime = $p($g(^DHCEQEquip(rowid)),"^",54)
	.s UpdateUserDR = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",55),"date")
	.i UpdateUserDR '=""  d
	..s UpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",UpdateUserDR)
	.s UpdateDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",56),"date")
	.s UpdateTime = $p($g(^DHCEQEquip(rowid)),"^",57)
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	.s StatusDisplay=..GetEquipStatusDisplay(Status)
	.//添加
	.s TStockStatus = $p($g(^DHCEQEquip(rowid)),"^",60)
	.s TStockStatus = $CASE(TStockStatus,"0":"在库","1":"分配","2":"出库",:"没有定义")
	.s TMemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	.s TUrgencyFlag = $p($g(^DHCEQEquip(rowid)),"^",62)
	.s TEquipTypeDR = $p($g(^DHCEQEquip(rowid)),"^",63)
	.i TEquipTypeDR '=""  d
	..s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.s TPurchaseTypeDR = $p($g(^DHCEQEquip(rowid)),"^",64)
	.i TPurchaseTypeDR '=""  d
	..s TPurchaseType = $p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	.s TPurposeTypeDR = $p($g(^DHCEQEquip(rowid)),"^",65)
	.i TPurposeTypeDR '=""  d
	..s TPurposeType = $p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	.s TKeeperDR = $p($g(^DHCEQEquip(rowid)),"^",66)
	.i TKeeperDR '=""  d
	..s TKeeper = ##class(web.DHCEQCommon).GetTrakNameByID("user",TKeeperDR)
	.s TStoreLocDR = $p($g(^DHCEQEquip(rowid)),"^",67)
	.i TStoreLocDR '=""  d
	..s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	.s TStartDepreMonth = $p($g(^DHCEQEquip(rowid)),"^",68)
	.s TServiceDR = $p($g(^DHCEQEquip(rowid)),"^",69)
	.i TServiceDR '=""  d
	..s TService = $p($g(^DHCEQCCode("DHCEQCService",TServiceDR)),"^",1)
	.s TInStockListDR = $p($g(^DHCEQEquip(rowid)),"^",70)
	.i TInStockListDR '=""  d
	..s TInStockList = $p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	.s TNo = $p($g(^DHCEQEquip(rowid)),"^",71)
	.//
	.q:Name'[vEquipName
	.q:RowID'[vEquipNo
	.q:(vModelDR'="")&(ModelDR'=vModelDR)
	.q:(vManageLocDR'="")&(ManageLocDR'=vManageLocDR)
	.q:(vUseLocDR'="")&(UseLocDR'=vUseLocDR)
	.q:(vStatus'="")&(Status'=vStatus)
	.q:InvalidFlag="Y"
	.q:(vEquipCatDR'="")&&(vEquipCatDR'=EquiCatDR)
	.d OutputRowGetEquip
	quit
OutputRowGetEquip
	s Data=$lb(RowID,Name,ABCType,ModelDR,EquiCatDR,UnitDR,Code,Desc,InstallLocDR,InstallDate,LeaveFactoryNo,LeaveFactoryDate,OpenCheckDate,CheckDate,MakeDate,ComputerFlag,CountryDR,ManageLocDR,ManageLevelDR,UseLocDR,OriginDR,FromDeptDR,ToDeptDR,BuyTypeDR,EquipTechLevelDR ,ProviderDR,ManuFactoryDR,OriginalFee,NetFee,NetRemainFee,GroupDR,LimitYearsNum,ContractListDR,DepreMethodDR,Remark,DepreTotalFee,DesignWorkLoadNum,WorkLoadUnitDR,Status,ManageUserDR,MaintUserDR,ContactUser,ContactMode,AppendFeeTotalFee,StartDate,TransAssetDate,GuaranteeFlag,InputFlag,TestFlag,MedicalFlag,GuaranteeStartDate,GuaranteeEndDate,AddUserDR,AddDate,AddTime,UpdateUserDR,UpdateDate,UpdateTime,Model,EquiCat,Unit,InstallLoc,Country,ManageLoc,ManageLevel,UseLoc,Origin,FromDept,ToDept,BuyType,Provider,ManuFactory,Group,ContractList,DepreMethod,WorkLoadUnit,ManageUser,MaintUser,AddUser,UpdateUser,StatusDisplay,TStockStatus,TMemoryCode,TUrgencyFlag,TEquipTypeDR,TEquipType,TPurchaseTypeDR,TPurchaseType,TPurposeTypeDR,TPurposeType,TKeeperDR,TKeeper,TStoreLocDR,TStoreLoc,TStartDepreMonth,TServiceDR,TService,TInStockListDR,TNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquip
	s (Name,ABCType,ModelDR,EquiCatDR,UnitDR,Code,Desc,InstallLocDR,InstallDate,LeaveFactoryNo,LeaveFactoryDate,OpenCheckDate,CheckDate,MakeDate,ComputerFlag,CountryDR,ManageLocDR,ManageLevelDR,UseLocDR,OriginDR,FromDeptDR,ToDeptDR,BuyTypeDR,EquipTechLevelDR ,ProviderDR,ManuFactoryDR,OriginalFee,NetFee,NetRemainFee,GroupDR,LimitYearsNum,ContractListDR,DepreMethodDR,Remark,DepreTotalFee,DesignWorkLoadNum,WorkLoadUnitDR,Status,ManageUserDR,MaintUserDR,ContactUser,ContactMode,AppendFeeTotalFee,StartDate,TransAssetDate,GuaranteeFlag,InputFlag,TestFlag,MedicalFlag,GuaranteeStartDate,GuaranteeEndDate,AddUserDR,AddDate,AddTime,UpdateUserDR,UpdateDate,UpdateTime,Model,EquiCat,Unit,InstallLoc,Country,ManageLoc,ManageLevel,UseLoc,Origin,FromDept,ToDept,BuyType,Provider,ManuFactory,Group,ContractList,DepreMethod,WorkLoadUnit,ManageUser,MaintUser,AddUser,UpdateUser,StatusDisplay,TStockStatus,TMemoryCode,TUrgencyFlag,TEquipTypeDR,TEquipType,TPurchaseTypeDR,TPurchaseType,TPurposeTypeDR,TPurposeType,TKeeperDR,TKeeper,TStoreLocDR,TStoreLoc,TStartDepreMonth,TServiceDR,TService,TInStockListDR,TNo)=""
	quit
}

ClassMethod GetEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipExecute ]
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

ClassMethod GetEquipStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

// midified by zy 2015-7-1 ZY0134 After v4.0

// 修改设备状态为0:在库|1:启用|2:停用|3:报废|4:其他

ClassMethod GetEquipStatusDisplay(status As %Library.String) As %Status
{
	i status=""  q ""
	i +status=0  q "在库"
	i +status=1  q "启用"
	i +status=2  q "停用"
	i +status=3  q "报废"
	i +status=4  q "其他"
	q "未定义"
}

ClassMethod GetEquipStockStatusDisplay(status As %Library.String) As %Status
{
	i status=""  q ""
	i +status=0  q "新增"
	i +status=1  q "入库"
	i +status=2  q "转移出库"
	i +status=3  q "出库"
	q "未定义"
}

ClassMethod GetEquipStatusExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 
 for LogicalValue=0:1:2 d //2010-10-28 DJ
 .s DisplayValue=..GetEquipStatusDisplay(LogicalValue)
 .Do OutputRowGetEquipStatus
 
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRowGetEquipStatus
	set Data=$lb(DisplayValue,LogicalValue)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod GetEquipStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipStatusExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

/// EquipName As %String = "", EquipNo As %String = "", ModelDR As %String = "", ManageLocDR As %String = "", UseLocDR As %String = "", Status As %String = "", LeaveFactoryNo As %String = ""
/// vStockStatuType为空的时候选择出来库房状态为"入库","转移出库"的设备，否则选择出的为设置的状态
/// NeedUseLoc，是否需要使用科室，0：不需要，当UseLoc为空时不限制科室  1：需要，未指定科室则查找不到数据
/// 2009-12-02 党军 DJ0036 增加vBAFlag参数
/// Modify by zx 2020-11-23 BUG ZX0117 移动端参数处理
/// d ##class(%ResultSet).RunQuery("web.DHCEQEquip","GetShortEquip","","","","","","0","","","","","202","85","","","65706","Y")
Query GetShortEquip(Equip, vUseLoc, vNeedUseLoc, vStockStatuType As %String = "", vBAFlag As %String = "", QXType As %String = "", vComputerFlag As %String = "", PlanNameDR As %String = "", vProviderDR As %String = "", vIncludeBussFlag As %String = "", SessionIDs As %String = "", MaxOriginalFee As %String = "", MinOriginalFee As %String = "", BeginDate As %String = "", EndDate As %String = "", WeChatFlag As %String = "") As %Query(ROWSPEC = "Name:%String:名称,HIDDEN:%String,UseLoc:%String:使用科室,No:%String:编号,LeaveFactoryNo:%String:出厂编号,HIDDEN:%String,HIDDEN:%String,Model:%String:机型,HIDDEN:%String,EquipType:%String:设备类组,HIDDEN:%String,ManuFactory:%String:生产工厂,HIDDEN:%String,Unit:%String:单位,OriginalFee:%String:原值,FileNo:%String:档案号,HIDDEN:%String,Item:%String:设备项")
{
}

ClassMethod GetShortEquipExecute(ByRef qHandle As %Binary, Equip As %String, vUseLoc, vNeedUseLoc, vStockStatuType As %String = "", vBAFlag As %String = "", QXType As %String = "", vComputerFlag As %String = "", PlanNameDR As %String = "", vProviderDR As %String = "", vIncludeBussFlag As %String = "", SessionIDs As %String = "", MaxOriginalFee As %String = "", MinOriginalFee As %String = "", BeginDate As %String = "", EndDate As %String = "", WeChatFlag As %String = "") As %Status
{
	new repid, index,rowid
 	new passed
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s (SourceType,SourceID)=""				 //modefied by zc 2017-02-23  begin
	s SELocID=$p(SessionIDs,"^",1)
	s SEGroupID=$p(SessionIDs,"^",2)
	s SEUserID=$p(SessionIDs,"^",3)
	i PlanNameDR'="" d
	.s SourceType = $p($g(^DHCEQMaintPlan(PlanNameDR)),"^",3)
	.s SourceID = $p($g(^DHCEQMaintPlan(PlanNameDR)),"^",4)		 //modefied by zc 2017-02-23  end
	s Equip=##Class(web.DHCEQCommon).UnEscape(Equip)
	s Equip=$ZCONVERT(Equip,"U")
	i ((vNeedUseLoc=1)&&(vUseLoc="")) Quit $$$OK
	///Add By DJ 2017-04-05 begin
	i (Equip="")&&(WeChatFlag'="Y") Quit $$$OK
	i (WeChatFlag'="Y")&&($D(^DHCEQEquip(0,"No",Equip)))  d
	.s rowid=$o(^DHCEQEquip(0,"No",Equip,0))
	.d BuildDataGetShortEquip
	e  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquip(rowid))	q:rowid=""  d
	..s NewEQCode=$p($g(^DHCEQEquip(rowid)),"^",6)
	..s NewName=$p($g(^DHCEQEquip(rowid)),"^",1)
	..s LeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	..s No=$p($g(^DHCEQEquip(rowid)),"^",71)
	..s MemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	..s FileNo=$p($g(^DHCEQEquip(rowid)),"^",85)
	..q:($ZCONVERT(No,"U")'[Equip)&&($ZCONVERT(NewEQCode,"U")'[Equip)&&($ZCONVERT(NewName,"U")'[Equip)&&($ZCONVERT(LeaveFactoryNo,"U")'[Equip)&&($ZCONVERT(MemoryCode,"U")'[Equip)&&($ZCONVERT(FileNo,"U")'[Equip)
	..d BuildDataGetShortEquip
	Quit $$$OK
BuildDataGetShortEquip
	d ResetVariablesGetShortEquip
	s RowID = rowid
	d CheckDataGetShortEquip
	i passed=0 q
	;s Name = $p($g(^DHCEQEquip(rowid)),"^",1)
	s ABCType = $p($g(^DHCEQEquip(rowid)),"^",2)
	s ModelDR = $p($g(^DHCEQEquip(rowid)),"^",3)
	i ModelDR '=""  d
	.s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	s ItemDR = $p($g(^DHCEQEquip(rowid)),"^",7)  //add by wy 2017-9-27
	s Item = ##class(web.DHCEQCommon).GetTrakNameByID("masteritem", ItemDR)		//Mozy	1012531	2019-8-28	增加设备项信息
	s EquiCatDR = $p($g(^DHCEQEquip(rowid)),"^",4)
	i EquiCatDR '=""  d
	.s EquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",EquiCatDR)),"^",2)
	s EquipTypeDR=$p($g(^DHCEQEquip(rowid)),"^",63) //add by zx 2015-01-16
	i EquipTypeDR '="" d
	.s EquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	s UnitDR = $p($g(^DHCEQEquip(rowid)),"^",5)
	i UnitDR '=""  d
	.s Unit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	;s Code = $p($g(^DHCEQEquip(rowid)),"^",6)
	;s Desc = $p($g(^DHCEQEquip(rowid)),"^",7)
	s InstallLocDR = $p($g(^DHCEQEquip(rowid)),"^",8)
	i InstallLocDR '=""  d
	.s InstallLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",InstallLocDR)
	s InstallDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",9),"date")
	;s LeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	s LeaveFactoryDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",11),"date")
	s OpenCheckDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",12),"date")
	s CheckDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",13),"date")
	s MakeDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",14),"date")
	s ComputerFlag = $p($g(^DHCEQEquip(rowid)),"^",15)
	q:(vComputerFlag="Y")&(vComputerFlag'=ComputerFlag)
	s CountryDR = $p($g(^DHCEQEquip(rowid)),"^",16)
	i CountryDR '=""  d
	.s Country =##class(web.DHCEQCommon).GetTrakNameByID("cou",CountryDR)
	s ManageLocDR = $p($g(^DHCEQEquip(rowid)),"^",17)
	i ManageLocDR '=""  d
	.s ManageLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",ManageLocDR) ; ##class(web.DHCEQCommon).GetTrakNameByID("dept",ManageLocDR)	
	s ManageLevelDR = $p($g(^DHCEQEquip(rowid)),"^",18)
	i ManageLevelDR '=""  d
	.s ManageLevel = $p($g(^DHCEQCCode("DHCEQCManageLevel",ManageLevelDR)),"^",2)
	//s UseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	i UseLocDR '=""  d
	.s UseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
	s OriginDR = $p($g(^DHCEQEquip(rowid)),"^",20)
	i OriginDR '=""  d
	.s Origin = $p($g(^DHCEQCCode("DHCEQCOrigin",OriginDR)),"^",2)
	s FromDeptDR = $p($g(^DHCEQEquip(rowid)),"^",21)
	i FromDeptDR '=""  d
	.s FromDept = ##class(web.DHCEQCommon).GetTrakNameByID("dept",FromDeptDR)
	s ToDeptDR = $p($g(^DHCEQEquip(rowid)),"^",22)
	i ToDeptDR '=""  d
	.s ToDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",ToDeptDR)),"^",2)
	s BuyTypeDR = $p($g(^DHCEQEquip(rowid)),"^",23)
	i BuyTypeDR '=""  d
	.s BuyType = $p($g(^DHCEQCCode("DHCEQCBuyType",BuyTypeDR)),"^",2)
	s EquipTechLevelDR  = $p($g(^DHCEQEquip(rowid)),"^",24)
	s ProviderDR = $p($g(^DHCEQEquip(rowid)),"^",25)
	i ProviderDR '=""  d
	.s Provider =##class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
	s ManuFactoryDR = $p($g(^DHCEQEquip(rowid)),"^",26)
	i ManuFactoryDR '=""  d
	.s ManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //modified by csj 2020-10-30 
	s OriginalFee = $p($g(^DHCEQEquip(rowid)),"^",27)
	// add by zx 2019-08-16
	q:(MaxOriginalFee'="")&&(MaxOriginalFee<OriginalFee)
	q:(MinOriginalFee'="")&&(MinOriginalFee>OriginalFee)
	s NetFee = $p($g(^DHCEQEquip(rowid)),"^",28)
	s NetRemainFee = $p($g(^DHCEQEquip(rowid)),"^",29)
	s GroupDR = $p($g(^DHCEQEquip(rowid)),"^",30)
	i GroupDR '=""  d
	.s Group = $p($g(^DHCEQGroup(GroupDR)),"^",2)
	s LimitYearsNum = $p($g(^DHCEQEquip(rowid)),"^",31)
	s ContractListDR = $p($g(^DHCEQEquip(rowid)),"^",32)
	i ContractListDR '=""  d
	.s ContractList = $p($g(^DHCEQContractList(ContractListDR)),"^",1)
	s DepreMethodDR = $p($g(^DHCEQEquip(rowid)),"^",33)
	i DepreMethodDR '=""  d
	.s DepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",2)
	s Remark = $p($g(^DHCEQEquip(rowid)),"^",34)
	s DepreTotalFee = $p($g(^DHCEQEquip(rowid)),"^",35)
	s DesignWorkLoadNum = $p($g(^DHCEQEquip(rowid)),"^",36)
	s WorkLoadUnitDR = $p($g(^DHCEQEquip(rowid)),"^",37)
	i WorkLoadUnitDR '=""  d
	.s WorkLoadUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",WorkLoadUnitDR)
	s Status = $p($g(^DHCEQEquip(rowid)),"^",38)
	s ManageUserDR = $p($g(^DHCEQEquip(rowid)),"^",39)
	i ManageUserDR '=""  d
	.s ManageUser =##class(web.DHCEQCommon).GetTrakNameByID("user",ManageUserDR)
	s MaintUserDR = $p($g(^DHCEQEquip(rowid)),"^",40)
	i MaintUserDR '=""  d
	.s MaintUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",MaintUserDR)
	s ContactUser = $p($g(^DHCEQEquip(rowid)),"^",41)
	s ContactMode = $p($g(^DHCEQEquip(rowid)),"^",42)
	s AppendFeeTotalFee = $p($g(^DHCEQEquip(rowid)),"^",43)
	s StartDate=$p($g(^DHCEQEquip(rowid)),"^",44)
	q:(BeginDate'="")&&(BeginDate>StartDate)
	q:(EndDate'="")&&(EndDate<StartDate)
	s StartDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",44),"date")
	s TransAssetDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",45),"date")
	s GuaranteeFlag = $p($g(^DHCEQEquip(rowid)),"^",46)
	s InputFlag = $p($g(^DHCEQEquip(rowid)),"^",47)
	s TestFlag = $p($g(^DHCEQEquip(rowid)),"^",48)
	s MedicalFlag = $p($g(^DHCEQEquip(rowid)),"^",49)
	s GuaranteeStartDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",50),"date")
	s GuaranteeEndDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",51),"date")
	s AddUserDR = $p($g(^DHCEQEquip(rowid)),"^",52)
	i AddUserDR '=""  d
	.s AddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",AddUserDR)
	s AddDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",53),"date")
	s AddTime = $p($g(^DHCEQEquip(rowid)),"^",54)
	s UpdateUserDR = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",55),"date")
	i UpdateUserDR '=""  d
	.s UpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",UpdateUserDR)
	s UpdateDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",56),"date")
	s UpdateTime = $p($g(^DHCEQEquip(rowid)),"^",57)
	s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	;s MemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	s KeeperDR = $p($g(^DHCEQEquip(rowid)),"^",66)
	i KeeperDR '=""  d
	.s Keeper = ##class(web.DHCEQCommon).GetTrakNameByID("user",KeeperDR)
	s StoreLocDR = $p($g(^DHCEQEquip(rowid)),"^",67)
	i StoreLocDR '=""  d
	.s StoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	s StartDepreMonth = $p($g(^DHCEQEquip(rowid)),"^",68)
	s ServiceDR = $p($g(^DHCEQEquip(rowid)),"^",69)
	i ServiceDR '=""  d
	.s Service = $p($g(^DHCEQCCode("DHCEQCService",ServiceDR)),"^",1)
	s InStockListDR = $p($g(^DHCEQEquip(rowid)),"^",70)
	i InStockListDR '=""  d
	.s InStockList = $p($g(^DHCEQInStockList(InStockListDR)),"^",1)
	;s No = $p($g(^DHCEQEquip(rowid)),"^",71)
	s LocationDR = $p($g(^DHCEQEquip(rowid)),"^",72)
	s GuaranteePeriodNum = $p($g(^DHCEQEquip(rowid)),"^",73)
	s StatCatDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	i StatCatDR'="" d
	.s StatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
	Set FileNo=$p($g(^DHCEQEquip(rowid)),"^",85)	//20150819  Mozy0159
	d OutputRowGetShortEquip
	quit
OutputRowGetShortEquip
	Set Data=$lb(Name,RowID,UseLoc,No,LeaveFactoryNo,UseLocDR,ModelDR,Model,EquipTypeDR,EquipType,ManuFactoryDR,ManuFactory,UnitDR,Unit,OriginalFee,FileNo,ItemDR,Item)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetShortEquip
	s (Name,ABCType,ModelDR,EquiCatDR,UnitDR,Code,Desc,InstallLocDR,InstallDate,LeaveFactoryNo,LeaveFactoryDate,OpenCheckDate,CheckDate,MakeDate,ComputerFlag,CountryDR,ManageLocDR,ManageLevelDR,UseLocDR,OriginDR,FromDeptDR,ToDeptDR,BuyTypeDR,EquipTechLevelDR ,ProviderDR,ManuFactoryDR,OriginalFee,NetFee,NetRemainFee,GroupDR,LimitYearsNum,ContractListDR,DepreMethodDR,Remark,DepreTotalFee,DesignWorkLoadNum,WorkLoadUnitDR,Status,ManageUserDR,MaintUserDR,ContactUser,ContactMode,AppendFeeTotalFee,StartDate,TransAssetDate,GuaranteeFlag,InputFlag,TestFlag,MedicalFlag,GuaranteeStartDate,GuaranteeEndDate,AddUserDR,AddDate,AddTime,UpdateUserDR,UpdateDate,UpdateTime,Model,EquiCat,Unit,InstallLoc,Country,ManageLoc,ManageLevel,UseLoc,Origin,FromDept,ToDept,BuyType,Provider,ManuFactory,Group,ContractList,DepreMethod,WorkLoadUnit,ManageUser,MaintUser,AddUser,UpdateUser,FileNo,ItemDR,Item)=""
	quit
CheckDataGetShortEquip
	s passed=1
	s ProviderDR = $p($g(^DHCEQEquip(rowid)),"^",25)
	i (vProviderDR'="")&&(vProviderDR'=ProviderDR) s passed=0	//Add By DJ  2017-04-10 360838
	i passed=0 q
	s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	i InvalidFlag'="N" s passed=0
	i passed=0 q
	i (##Class(web.DHCEQCommon).CheckManageLimit(SEUserID,SEGroupID,"","","","","",rowid)) s passed=0
	i passed=0 q
	;s BAFlag=$p($g(^DHCEQEquip(rowid)),"^",81)
	;i (vBAFlag'="")&&(BAFlag'=vBAFlag) s passed=0
	i (vBAFlag="Y") d
	.s passed=##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(rowid)
	i passed=0 q
	s Name = $p($g(^DHCEQEquip(rowid)),"^",1)
	s Code = $p($g(^DHCEQEquip(rowid)),"^",6)
	s Desc = $p($g(^DHCEQEquip(rowid)),"^",7)
	s ComputerFlag = $p($g(^DHCEQEquip(rowid)),"^",15)		//Add By DJ 2017-02-21 begin
	i (vComputerFlag'="")&&(ComputerFlag'=vComputerFlag) s passed=0
	i passed=0 q		//Add By DJ 2017-02-21
	s EquipType=$p($g(^DHCEQEquip(rowid)),"^",63)
	i (EquipType'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,SEGroupID)) s passed=0
	i ((vIncludeBussFlag=1)&(##Class(web.DHCEQEquip).CheckEquipInBussType(rowid,31)=1)) s passed=0      //modefied by zc 2017-02-23  begin
	i passed=0 q
	i ((vIncludeBussFlag=1)&(##Class(web.DHCEQEquip).CheckEquipInBussType(rowid,34)=1)) s passed=0
	i passed=0 q
	i (PlanNameDR'="")&&(SourceType=1)&&($p($g(^DHCEQEquip(rowid)),"^",4)'=SourceID) s passed=0
	i passed=0 q
	i (PlanNameDR'="")&&(SourceType=2)&&($p($g(^DHCEQEquip(rowid)),"^",7)'=SourceID) s passed=0
	i passed=0 q
	i (PlanNameDR'="")&&(SourceType=3)&&(rowid'=SourceID) s passed=0
	i passed=0 q																		 //modefied by zc 2017-02-23  end
	s LeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	s MemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	s No = $p($g(^DHCEQEquip(rowid)),"^",71)
	Set FileNo=$p($g(^DHCEQEquip(rowid)),"^",85)	//20150819  Mozy0159
	i (Equip'="")&&(($ZCONVERT(Name,"U")'[Equip)&($ZCONVERT(LeaveFactoryNo,"U")'[Equip)&(RowID'=Equip)&($ZCONVERT(MemoryCode,"U")'[Equip)&($ZCONVERT(No,"U")'[Equip)&($ZCONVERT(Code,"U")'[Equip)&($ZCONVERT(FileNo,"U")'[Equip))   d
	.s passed=0
	i passed=0 q
	s Status = $p($g(^DHCEQEquip(rowid)),"^",38)
	i ((Status="3")||(Status="4")) d
	.s passed=0
	s UseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	/// Modefied by zc0123 2022-10-17 移动端台帐科室自动包含子科室查询 begin
	i (WeChatFlag="Y")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(vUseLoc,UseLocDR,"1")'="1")&&(vUseLoc'="") s passed=0
	i passed=0 q
	/// Modefied by zc0123 2022-10-17 移动端台帐科室自动包含子科室查询 end
	s StoreLocDR = $p($g(^DHCEQEquip(rowid)),"^",67)
	i StoreLocDR'=""  d
	.i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocDR,SELocID,SEGroupID)))  d 
	..s passed=0
	i passed=0 q
	i (vUseLoc'="")
	{
		i ((Status="0")||(Status="2"))
			{	if (vUseLoc'=StoreLocDR) s passed=0}
		elseif  (vUseLoc'=UseLocDR) 
			{	s passed=0}
	}
	i passed=0 q
	s StockStatus = $p($g(^DHCEQEquip(rowid)),"^",60)
	i vStockStatuType="" d
	.i ((StockStatus="0")||(StockStatus="3")) s passed=0
	e  d
	.s Flag=##class(web.DHCEQBuyRequest).StringIsIn(vStockStatuType,StockStatus)
	.i Flag="N" s passed=0
	quit
}

ClassMethod GetShortEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShortEquipExecute ]
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

ClassMethod GetShortEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShortEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 修改:ZY 2009-11-12  zy0016
/// 描述:机型,生产厂家,供应商的rowid在js中进行处理;
/// -------------------------------
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", user As %Library.String = "", Info As %Library.String = "", FacilityFlag As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 s PLIST(1) = $p(val,"^",1)	;RowID
 s PLIST(2) = $p(val,"^",91)	;Name	//2013-06-24 DJ0118
 s PLIST(3) = $p(val,"^",3)	;ABCType
 s PLIST(4) = $p(val,"^",4)	;ModelDR
 s PLIST(5) = $p(val,"^",5)	;EquiCatDR
 s PLIST(6) = $p(val,"^",6)	;UnitDR
 s PLIST(7) = $p(val,"^",7)	;Code
 s PLIST(8) = $p(val,"^",8)	;ItemDR
 s PLIST(9) = $p(val,"^",9)	;InstallLocDR 
 s PLIST(10) = $p(val,"^",10)
 i $p(val,"^",10)'=""  s PLIST(10) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"date")	;InstallDate
 s PLIST(11) = $p(val,"^",11)	;LeaveFactoryNo
 s PLIST(12) = $p(val,"^",12)
 i $p(val,"^",12)'=""  s PLIST(12) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",12),"date")	;LeaveFactoryDate
 s PLIST(13) = $p(val,"^",13)
 i $p(val,"^",13)'=""  s PLIST(13) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",13),"date")	;OpenCheckDate
 s PLIST(14) = $p(val,"^",14)
 i $p(val,"^",14)'=""  s PLIST(14) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",14),"date")	;CheckDate
 s PLIST(15) = $p(val,"^",15)
 i $p(val,"^",15)'=""  s PLIST(15) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",15),"date")	;MakeDate
 s PLIST(16) = $p(val,"^",16)
 i $p(val,"^",16)'=""  s PLIST(16) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",16),"bool")	;ComputerFlag 
 s PLIST(17) = $p(val,"^",17)	;CountryDR
 s PLIST(18) = $p(val,"^",18)	;ManageLocDR
 s PLIST(19) = $p(val,"^",19)	;ManageLevelDR
 s PLIST(20) = $p(val,"^",20)	;UseLocDR
 s PLIST(21) = $p(val,"^",21)	;OriginDR
 s PLIST(22) = $p(val,"^",22)	;FromDeptDR
 s PLIST(23) = $p(val,"^",23)	;ToDeptDR
 s PLIST(24) = $p(val,"^",24)	;BuyTypeDR
 s PLIST(25) = $p(val,"^",25)	;EquipTechLevelDR 
 s PLIST(26) = $p(val,"^",26)	;ProviderDR
 s PLIST(27) = $p(val,"^",27)	;ManuFactoryDR
 s PLIST(28) = $p(val,"^",28)	;OriginalFee
 s PLIST(29) = $p(val,"^",29)	;NetFee
 s PLIST(30) = $p(val,"^",30)	;NetRemainFee
 s PLIST(31) = $p(val,"^",31)	;GroupDR
 s PLIST(32) = $p(val,"^",32)	;LimitYearsNum
 s PLIST(33) = $p(val,"^",33)	;ContractListDR
 s PLIST(34) = $p(val,"^",34)	;DepreMethodDR
 s PLIST(35) = $p(val,"^",35)	;Remark
 s PLIST(36) = $p(val,"^",36)	;DepreTotalFee
 s PLIST(37) = $p(val,"^",37)	;DesignWorkLoadNum
 s PLIST(38) = $p(val,"^",38)	;WorkLoadUnitDR
 s PLIST(39) = $p(val,"^",39)	;Status
 if (PLIST(39)="")  s PLIST(39)=0
 s PLIST(40) = $p(val,"^",40)	;ManageUserDR
 s PLIST(41) = $p(val,"^",41)	;MaintUserDR
 s PLIST(42) = $p(val,"^",42)	;ContactUser
 s PLIST(43) = $p(val,"^",43)	;ContactMode
 s PLIST(44) = $p(val,"^",44)	;AppendFeeTotalFee
 s PLIST(45) = $p(val,"^",45)
 i $p(val,"^",45)'=""  s PLIST(45) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",45),"date")	;StartDate
 s PLIST(46) = $p(val,"^",46)
 i $p(val,"^",46)'=""  s PLIST(46) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",46),"date")	;TransAssetDate
 s PLIST(47) = $p(val,"^",47)
 i $p(val,"^",47)'=""  s PLIST(47) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",47),"bool")	;GuaranteeFlag
 ;s PLIST(48) = $p(val,"^",48)
 ;i $p(val,"^",48)'=""  s PLIST(48) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",48),"bool")	;InputFlag
 s PLIST(49) = $p(val,"^",49)
 i $p(val,"^",49)'=""  s PLIST(49) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",49),"bool")	;TestFlag
 s PLIST(50) = $p(val,"^",50)
 i $p(val,"^",50)'=""  s PLIST(50) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",50),"bool")	;MedicalFlag
 s PLIST(51) = $p(val,"^",51)
 i $p(val,"^",51)'=""  s PLIST(51) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",51),"date")	;GuaranteeStartDate
 s PLIST(52) = $p(val,"^",52)
 i $p(val,"^",52)'=""  s PLIST(52) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",52),"date")	;GuaranteeEndDate 
 /*
 s PLIST(53) = $p(val,"^",53)	;AddUserDR
 s PLIST(54) = $p(val,"^",54)
 i $p(val,"^",54)'=""  s PLIST(54) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",54),"date")	;AddDate
 s PLIST(55) = $p(val,"^",55)	;AddTime
 s PLIST(56) = $p(val,"^",56)	;UpdateUserDR
 s PLIST(57) = $p(val,"^",57)
 i $p(val,"^",57)'=""  s PLIST(57) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",57),"date")	;UpdateDate 
 s PLIST(58) = $p(val,"^",58)	;UpdateTime 
 s PLIST(59) = $p(val,"^",59)
 */
 s PLIST(60) = "N"
 //添加
 //s PLIST(61) = $p(val,"^",56)	;StockStatus
 s PLIST(62) = $p(val,"^",57)	;MemoryCode
 s PLIST(63) = $p(val,"^",58)	;UrgencyFlag
 i $p(val,"^",58)'=""  s PLIST(63) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",58),"bool")	;UrgencyFlag
 s PLIST(64) = $p(val,"^",59)	;EquipTypeDR
 s PLIST(65) = $p(val,"^",60)	;PurchaseTypeDR
 s PLIST(66) = $p(val,"^",61)	;PurposeTypeDR
 s PLIST(67) = $p(val,"^",62)	;KeeperDR
 s PLIST(68) = $p(val,"^",63)	;StoreLocDR
 s PLIST(69) = $p(val,"^",64)	;StartDepreMonth
 s PLIST(70) = $p(val,"^",65)	;ServiceDR
 //s PLIST(71) = $p(val,"^",66)	;InStockListDR
 s PLIST(72) = $P(val,"^",67)   ;
 s PLIST(73) = $p(val,"^",68)
 s PLIST(74) = $p(val,"^",69) 
 s PLIST(76) = $p(val,"^",70) 
 
 ///add by jdl 2009-06-02  JDL0006
 s PLIST(77) = $p(val,"^",71) 
 ;s PLIST(78) = $p(val,"^",72) 
 ;s PLIST(79) = $p(val,"^",73) 
 ;s PLIST(80) = $p(val,"^",74) 
 ;s PLIST(81) = $p(val,"^",75) 
 
 ///新增:2009-12-02 党军 begin DJ0035
 i $p(val,"^",75)'=""  s PLIST(81) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",75),"bool")		//Add By DJ 2017-01-20
 i $p(val,"^",76)'=""  s PLIST(82) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",76),"bool")
 i $p(val,"^",77)'=""  s PLIST(83) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",77),"bool")
 i $p(val,"^",78)'=""  s PLIST(84) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",78),"bool")
 s PLIST(85) = $p(val,"^",79)
 ///2009-12-02 党军 end DJ0035
 ///add by jdl 2010-8-24
 s PLIST(86) = $p(val,"^",80)	;FileNo
 ;s PLIST(87) = $p(val,"^",81)	;RentLocDR
 ;s PLIST(88) = $p(val,"^",82)	;RentStatus
 ;s PLIST(89) = $p(val,"^",83)	;FaultStatus
 ;s PLIST(90) = $p(val,"^",84)	;DisuseDate
 s PLIST(91) = $p(val,"^",85)	;AccountNo
 s PLIST(92) = $p(val,"^",86)	;OldNo 原Hold6
 s PLIST(93) = $p(val,"^",87)	;RegistrationNo 原Hold7
 ;s PLIST(94) = $p(val,"^",88)	;AdvanceDisFlag 原Hold8	/// 20150922  Mozy0166	异常状态
 s PLIST(95) = $p(val,"^",89)	;Brand 原Hold9
 s PLIST(96) = $p(val,"^",90)	;Hold10
 //Add By DJ 2014-08-21 DJ0126
 s PLIST(97) = $p(val,"^",92)	;RunStatus
 s PLIST(98) = $p(val,"^",93)	;ConfigLicense
 s PLIST(99) = $p(val,"^",94)	;NewOldPercent
 s PLIST(100) = $p(val,"^",95)	;Power
 s PLIST(101) = $p(val,"^",96)	;Voltage
 s PLIST(102) = $p(val,"^",97)	;Electriccurrent
 i $p(val,"^",98)'=""  s PLIST(103) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",98),"bool")	;RaditionFlag
 i $p(val,"^",99)'=""  s PLIST(104) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",99),"date")	;ReciveDate
 s PLIST(105) = $p(val,"^",100)	;Hold1	UnusualRemark异常状态备注
 s PLIST(106) = $p(val,"^",101)	;Hold2
 s PLIST(107) = $p(val,"^",102)	;Hold3
 s PLIST(108) = $p(val,"^",103)	;Hold4
 
  /// Mozy0145	20141017
 s PLIST(109) = $p(val,"^",104)	;ValueType
 s PLIST(110) = $p(val,"^",105)	;DirectionsUse
 s PLIST(111) = $p(val,"^",106)	;UserDR
 s PLIST(112) = $p(val,"^",107)	;AccountShape
 s PLIST(113) = $p(val,"^",108)	;ProjectNo
 
 s CheckFlag=..CheckEQData(rowid,PLIST(68),PLIST(28),PLIST(29),PLIST(36),PLIST(64),PLIST(76))
 i (FacilityFlag'="2")&&(CheckFlag'=0) q CheckFlag  //modify by jyp 2018-03-14 552320
 
 k PLIST(1)
 TStart
 ///Modified By ZY ZY0016 2009-11-11  删除ModelDR的处理代码
 i (rowid'="") 
 {
	 s PLIST(56) = user
	 s PLIST(57) = +$H
	 s PLIST(58) = $P($H,",",2)
	 
	 //add by jdl 2010-12-07
	 s ^DHCEQMark("DHCEQEquip",rowid,user,$H)=$g(^DHCEQEquip(rowid))
	 
	 &SQL(Update SQLUSER.DHC_EQEquip Values :PLIST() where EQ_RowID = :rowid)
	 Set ID=rowid
 }
 else
 {	 
 	 s PLIST(53) = user
	 s PLIST(54) = +$H
	 s PLIST(55) = $P($H,",",2)	 
	 s PLIST(75) = "N"
	 &SQL(Insert Into SQLUSER.DHC_EQEquip Values :PLIST())
	 Set ID=$g(%ROWID)
	 if (PLIST(72)="")
	 {
		s updateNo= ..UpdateEquipNo(ID,+$H)
	 	i updateNo'=0 
	 	{
		 	TRollBack
		 	q updateNo
		}
	 }
 }
 if SQLCODE  
 {	TRollBack
	q SQLCODE }
 Set SQLCODE=##Class(web.DHCEQOpenCheckRequest).SaveDataForInfo(Info,1,ID,2)
 if SQLCODE
 {
	TROLLBACK
	Quit SQLCODE
}
 TCommit
 q ID
}

/// Modifeid By QW20200108 BUG:QW0035 增加微信直接接收session
ClassMethod UpdateEquipNo(rowid, curdate, locdr As %Library.String = "")
{
	new eqno
	s eqno = ..GetNextNo(rowid,curdate,locdr) ///Modifeid By QW20200108 BUG:QW0035 增加微信直接接收session
	i eqno="" q ""
	&SQL(Update SQLUSER.DHC_EQEquip set EQ_No=:eqno Where EQ_RowID=:rowid)
	if SQLCODE q SQLCODE
	q 0
}

/// w ##Class(web.DHCEQEquip).GetNextNo("1", +$H)
/// Modifeid By QW20200108 BUG:QW0035 增加微信直接接收session
ClassMethod GetNextNo(rowid, curdate, locdr As %Library.String = "")
{
	new equiptype,statcat,equipcatdr,equipecatno,storelocdr
	s (equiptype,statcat,equipcatdr,equipecatno,storelocdr)=""
	&SQL(select EQ_EquipTypeDR->ET_Code,EQ_StatCatDR->SC_Code,EQ_EquiCatDR,EQ_StoreLocDR into :equiptype,:statcat,:equipcatdr,:storelocdr from SQLUSER.DHC_EQEquip where EQ_RowID=:rowid)
	i SQLCODE  q ""
	s equipecatno=..GetEquipeCatCode(equipcatdr)
	i locdr'="" s storelocdr=locdr  //Modifeid By QW20200108 BUG:QW0035 微信直接接收session
	///生成编号时，去掉分类编码中的“-”
	s equipecatno=##class(web.DHCEQCommon).Replace(equipecatno,"-","")	
	s nextno=##class(web.DHCEQCCounter).GetNextNo("DHC_EQEquip",curdate,storelocdr,equiptype,statcat,equipecatno)	
	q nextno
}

/// Creator:ZY   2009-11-17 ZY0017
/// Description:“分类编号”使用财政部分类代码（取6位，把“-”去掉）+4位序号
/// Input:  设备rowid和时间
/// Return: 设备编号
/// w ##Class(web.DHCEQEquip).GetNextNoNew("5", +$H)
ClassMethod GetNextNoNew(rowid, curdate)
{
	new equiptype,statcat,equipcatdr,type,prefix,suf,counter,len,CNTRowID
	s (equiptype,statcat,equipcatdr,equipecatno)=""
	&SQL(select EQ_EquipTypeDR->ET_Code,EQ_StatCatDR->SC_Code,EQ_EquiCatDR into :equiptype,:statcat,:equipcatdr from SQLUSER.DHC_EQEquip where EQ_RowID=:rowid)
	i SQLCODE  q ""
	if equipcatdr'="" s equipecatno=$p($g(^DHCEQCCode("DHCEQCEquipeCat",equipcatdr)),"^",1)
	if equipecatno="" q ""
	//s equipecatno=..GetEquipeCatCode(equipcatdr)
	///生成编号时，去掉分类编码中的“-”
	s equipecatno=##class(web.DHCEQCommon).Replace(equipecatno,"-","")
 	S StrLength=$l(equipecatno)
 	i StrLength>6   s equipecatno=$E(equipecatno,1,6)
 	s type=0
	s type=$o(^DHCEQCCode("DHCEQCCounterType",0,"TableName","DHC_EQEquip",type))
	if type="" q ""
	s CNTRowID=0
	s CNTRowID=$o(^DHCEQCCode("DHCEQCCounter",0,"Type",type,CNTRowID))
	if CNTRowID="" q ""
	s prefix=$p(^DHCEQCCode("DHCEQCCounter",CNTRowID),"^",4)
	s suf=$p(^DHCEQCCode("DHCEQCCounter",CNTRowID),"^",5)
	if (prefix=$c(0)) s prefix=""
	if (suf=$c(0)) s suf=""
	s len=$p(^DHCEQCCode("DHCEQCCounter",CNTRowID),"^",3)
	s counter=0
	i $Data(^DHCEQCCode("DHCEQCCounter",CNTRowID,"EX",equipecatno))=0 s counter=1
	i counter=0 d
	.s counter=$g(^DHCEQCCode("DHCEQCCounter",CNTRowID,"EX",equipecatno))
	.s counter=counter+1
	s (^DHCEQCCode("DHCEQCCounter",CNTRowID,"EX",equipecatno))=counter
	s counter=##class(web.DHCEQCCounter).LPAD(counter,"0",len)
	if (counter="") q ""
	s prefix=##class(web.DHCEQCCounter).ParsePrefix(prefix,curdate)
	s nextno=prefix_counter_suf
	s nextno=##class(web.DHCEQCommon).Replace(nextno,"{StatCat}",statcat)
	s nextno=##class(web.DHCEQCommon).Replace(nextno,"{EquiCat}",equipecatno)
	q nextno
}

/// w ##Class(web.DHCEQEquip).GetEquipeCatCode(equipcatdr)
ClassMethod GetEquipeCatCode(equipcatdr)
{
	new equipecode,flag
	s equipecode=""
	while((equipecode="")&&(equipcatdr'="")){
		s flag=$p($g(^DHCEQCCode("DHCEQCEquipeCat",equipcatdr)),"^",8)
		if flag="Y"  d 
		.s equipecode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",equipcatdr)),"^",1)
		e  d
		.s equipcatdr=$p($g(^DHCEQCCode("DHCEQCEquipeCat",equipcatdr)),"^",4)
	}
	q equipecode
}

/*
/// 以下为查找
/// GetEquip
Query GetEquip(EquipName As %String = "", EquipNo As %String = "", ModelDR As %String = "", ManageLocDR As %String = "", UseLocDR As %String = "", Status As %String = "", EquipCatDR As %String) As %Query(ROWSPEC = "RowID:%String,Name:%String,ABCType:%String,ModelDR:%String,EquiCatDR:%String,UnitDR:%String,Code:%String,Desc:%String,InstallLocDR:%String,InstallDate:%String,LeaveFactoryNo:%String,LeaveFactoryDate:%String,OpenCheckDate:%String,CheckDate:%String,MakeDate:%String,ComputerFlag:%String,CountryDR:%String,ManageLocDR:%String,ManageLevelDR:%String,UseLocDR:%String,OriginDR:%String,FromDeptDR:%String,ToDeptDR:%String,BuyTypeDR:%String,EquipTechLevelDR :%String,ProviderDR:%String,ManuFactoryDR:%String,OriginalFee:%String,NetFee:%String,NetRemainFee:%String,GroupDR:%String,LimitYearsNum:%String,ContractListDR:%String,DepreMethodDR:%String,Remark:%String,DepreTotalFee:%String,DesignWorkLoadNum:%String,WorkLoadUnitDR:%String,Status:%String,ManageUserDR:%String,MaintUserDR:%String,ContactUser:%String,ContactMode:%String,AppendFeeTotalFee:%String,StartDate:%String,TransAssetDate:%String,GuaranteeFlag:%String,InputFlag:%String,TestFlag:%String,MedicalFlag:%String,GuaranteeStartDate:%String,GuaranteeEndDate:%String,AddUserDR:%String,AddDate:%String,AddTime:%String,UpdateUserDR:%String,UpdateDate:%String,UpdateTime:%String,Model:%String,EquiCat:%String,Unit:%String,InstallLoc:%String,Country:%String,ManageLoc:%String,ManageLevel:%String,UseLoc:%String,Origin:%String,FromDept:%String,ToDept:%String,BuyType:%String,Provider:%String,ManuFactory:%String,Group:%String,ContractList:%String,DepreMethod:%String,WorkLoadUnit:%String,ManageUser:%String,MaintUser:%String,AddUser:%String,UpdateUser:%String,StatusDisplay:%String,TStockStatus:%String,TMemoryCode:%String,TUrgencyFlag:%String,TEquipTypeDR:%String,TEquipType:%String,TPurchaseTypeDR:%String,TPurchaseType:%String,TPurposeTypeDR:%String,TPurposeType:%String,TKeeperDR:%String,TKeeper:%String,TStoreLocDR:%String,TStoreLoc:%String,TStartDepreMonth:%String,TServiceDR:%String,TService:%String,TInStockListDR:%String,TNo:%String")
{
}
*/
Query GetEquipStatus() As %Query(ROWSPEC = "DisplayValue:%String:状态,LogicalValue:%String:编码")
{
}

/// Modified by jdl 2010-9-14
/// 新整合设备程序,取消DHC_EQLifeFee,DHC_EQDepreSet增加DepreTypeDR,SourceType,SourceID,DepreTotal,DepreTotalFee,DS_Years
ClassMethod AfterInsert(id, depremethod, originalfee, invalidflag, limityears)
{
 	if (depremethod'="")
	{
		//Function:Funds	2012-2-16 生成资金来源信息
		s deprestatus="true"
		i (depremethod="")||(depremethod="3") s deprestatus="false"		//czf 2023-02-22
		&sql(Insert into Sqluser.DHC_EQDepreSet
			(DS_EquipDR,DS_DepreMethodDr,DS_MainFlag,DS_DepreTypeDR,DS_SourceType,DS_SourceID,DS_Years,DS_Hold2)
			values (:id,:depremethod,'Y',1,0,:id,:limityears,:deprestatus))
		
		;add by jdl 增加一种折旧设置 2011-8-1 JDL0088
		i $d(^DHCEQCCode("DHCEQCDepreType",2))
		{
			//add by zy 2013-07-30 zy0108
			s depreinfo=##Class(web.DHCEQDepreSet).GetLimitYearsByOriginalFee(originalfee,2)	//Add By zy 2013-7-24
			s limityears=$p(depreinfo,"^",1)
			s depremethod=$p(depreinfo,"^",2)
			&sql(Insert into Sqluser.DHC_EQDepreSet
			(DS_EquipDR,DS_DepreMethodDr,DS_MainFlag,DS_DepreTypeDR,DS_SourceType,DS_SourceID,DS_Years)
			values (:id,:depremethod,'N',2,0,:id,:limityears))
		}
	}
	//记录最近一次插入数据时间  modified by czf 2020-05-12
	s ^TempDHCEQGetEquipList("RecordTime","AfterInsert")=$h
	/*
	if (originalfee'="")
	{
		set feemode=$o(^DHCEQCCode("DHCEQCFeeMode",0,"FMType",1,0))
		set feedate = +$H
		&sql(Insert into Sqluser.DHC_EQLifeFee
			(LF_EquipDR,LF_SourceDR,LF_FeeTypeDR,LF_UseFee,LF_FeeDate,LF_IsInputFlag)
			values (:id,:id,:feemode,:originalfee,:feedate,'N'))
	}
	*/
}

/// Modified by jdl 2010-9-14
/// 新整合设备程序,取消DHC_EQLifeFee,DHC_EQDepreSet增加DepreTypeDR,SourceType,SourceID,DepreTotal,DepreTotalFee,DS_Years
ClassMethod AfterUpdate(id, depremethod, originalfee, invalidflag, limityears)
{
	//Function:Funds	2012-2-16 生成资金来源信息
	s depresetid=$o(^DHCEQDepreSet(0,"EquipMain",id,"Y",0))
	i (depresetid'="")
	{
		i ((depremethod'=$p(^DHCEQDepreSet(depresetid),"^",2))||(limityears'=$p(^DHCEQDepreSet(depresetid),"^",24)))
		{
			s deprestatus="true"
			i (depremethod="")||(depremethod="3") s deprestatus="false"		//czf 2023-02-22
			&sql(Update Sqluser.DHC_EQDepreSet 
				set DS_DepreMethodDr=:depremethod,DS_Years=:limityears,DS_Hold2=:deprestatus
			 	where DS_RowID=:depresetid)
			
			;add by jdl 增加一种折旧设置 2011-8-1 JDL0088
			i $d(^DHCEQCCode("DHCEQCDepreType",2))
			{
				//add by zy 2013-07-30 zy0108
				s depreinfo=##Class(web.DHCEQDepreSet).GetLimitYearsByOriginalFee(originalfee,2)	//Add By zy 2013-7-24
				s limityears=$p(depreinfo,"^",1)
				s depremethod=$p(depreinfo,"^",2)
				s depresetid2=$o(^DHCEQDepreSet(0,"Source",2,0,id,0))
				&sql(Update Sqluser.DHC_EQDepreSet 
				set DS_DepreMethodDr=:depremethod,DS_Years=:limityears
			 	where DS_RowID=:depresetid2)
			}
		}
		
	}
	elseif (depremethod'="")
	{
		s deprestatus="true"
		i (depremethod="3") s deprestatus="false"		//czf 2023-02-22
		&sql(Insert into Sqluser.DHC_EQDepreSet
			(DS_EquipDR,DS_DepreMethodDr,DS_MainFlag,DS_DepreTypeDR,DS_SourceType,DS_SourceID,DS_Years,DS_Hold2)
			values (:id,:depremethod,'Y',1,0,:id,:limityears,:deprestatus))
			
		;add by jdl 增加一种折旧设置 2011-8-1 JDL0088
		i $d(^DHCEQCCode("DHCEQCDepreType",2))
		{
			//add by zy 2013-07-30 zy0108
			s depreinfo=##Class(web.DHCEQDepreSet).GetLimitYearsByOriginalFee(originalfee,2)	//Add By zy 2013-7-24
			s limityears=$p(depreinfo,"^",1)
			s depremethod=$p(depreinfo,"^",2)
			s depresetid=$o(^DHCEQDepreSet(0,"Source",2,0,id,0))
			&sql(Insert into Sqluser.DHC_EQDepreSet
			(DS_EquipDR,DS_DepreMethodDr,DS_MainFlag,DS_DepreTypeDR,DS_SourceType,DS_SourceID,DS_Years)
			values (:id,:depremethod,'N',2,0,:id,:limityears))
		}
	}
	//记录最近一次更新数据时间 modified by czf 2020-05-12
	s ^TempDHCEQGetEquipList("RecordTime","AfterUpdate")=$h
	/*
	if (depremethod'="")
	{
		&sql(Select DS_DepreMethodDr into :oldDepremethod
			 from  Sqluser.DHC_EQDepreSet 
			 where DS_EquipDR=:id and DS_MainFlag='Y')
		if (%ROWCOUNT=0)
		{
			&sql(Insert into Sqluser.DHC_EQDepreSet
			(DS_EquipDR,DS_DepreMethodDr,DS_MainFlag,DS_DepreTypeDR,DS_SourceType,DS_SourceID,DS_Years)
			values (:id,:depremethod,'Y',1,0,:id,:limityears))
		}
		elseif (depremethod'=oldDepremethod)
		{			
			&sql(Update Sqluser.DHC_EQDepreSet 
				set DS_DepreMethodDr=:depremethod,DS_Years=:limityears
			 	where DS_EquipDR=:id and DS_MainFlag='Y')
		}
	}	
	if (originalfee'="")
	{
		set feemode=$o(^DHCEQCCode("DHCEQCFeeMode",0,"FMType",1,0))
		set feedate = +$H
		&sql(Select LF_UseFee into :oldfee
			 from  Sqluser.DHC_EQLifeFee 
			 where LF_EquipDR=:id and LF_FeeTypeDR=:feemode)
		if (%ROWCOUNT=0)
		{
			&sql(Insert into Sqluser.DHC_EQLifeFee
			(LF_EquipDR,LF_SourceDR,LF_FeeTypeDR,LF_UseFee,LF_FeeDate,LF_IsInputFlag)
			values (:id,:id,:feemode,:originalfee,:feedate,'N'))
		}
		elseif (originalfee'=oldfee)
		{			
			&sql(Update Sqluser.DHC_EQLifeFee 
				set LF_UseFee=:originalfee
			 	where LF_EquipDR=:id and LF_FeeTypeDR=:feemode)
		}
	}
	*/
}

ClassMethod AfterDelete(id, depremethod, originalfee, invalidflag)
{
	//记录最近一次删除数据时间 modified by czf 2020-05-12
	s ^TempDHCEQGetEquipList("RecordTime","AfterDelete")=$h
}

ClassMethod GetDepreSetData(EquipDr As %Library.String)
{
	s rowid=0
	s result=""
	if (EquipDr="") q ""
	f  s rowid=$o(^DHCEQDepreSet(0,"Equip",EquipDr,rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQDepreSet(rowid)),"^",3)'="Y"
	.s result=^DHCEQDepreSet(rowid)
	.s result=result_"^"_rowid
	
	q result
}

/// new GetEquipList
/// BatchFlag是否按批次汇总显示
/// "TRowID:%String,TName:%String,TABCType:%String,TCode:%String,TDesc:%String,TInstallLocDR:%String,TInstallDate:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TMakeDate:%String,TComputerFlag:%String,TOriginalFee:%String,TNetFee:%String,TNetRemainFee:%String,TGroupDR:%String,TLimitYearsNum:%String,TContractListDR:%String,TDepreMethodDR:%String,TRemark:%String,TDepreTotalFee:%String,TDesignWorkLoadNum:%String,TStatus:%String,TManageUserDR:%String,TMaintUserDR:%String,TProviderHandler:%String,TProviderTel:%String,TAppendFeeTotalFee:%String,TStartDate:%String,TTransAssetDate:%String,TGuaranteeFlag:%String,TInputFlag:%String,TTestFlag:%String,TMedicalFlag:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TCurrencyDR:%String,TInvalidFlag:%String,TStockStatus:%String,TMemoryCode:%String,TUrgencyFlag:%String,TStoreLocDR:%String,TStartDepreMonth:%String,TServiceDR:%String,TInStockListDR:%String,TNo:%String,TModel:%String,TEquiCat:%String,TUnit:%String,TInstallLoc:%String,TCountry:%String,TManageLoc:%String,TManageLevel:%String,TUseLoc:%String,TOrigin:%String,TFromDept:%String,TToDept:%String,TBuyType:%String,TEquipTechLevel:%String,TProvider:%String,TManuFactory:%String,TGroup:%String,TContractList:%String,TDepreMethod:%String,TWorkLoadUnit:%String,TManageUser:%String,TMaintUser:%String,TAddUser:%String,TUpdateUser:%String,TCurrency:%String,TEquipType:%String,TPurchaseType:%String,TPurposeType:%String,TKeeper:%String,TStoreLoc:%String,TService:%String,TInStockList:%String,TQuantity:%String,TBatchFlag:%String,TDisplayStatus:%String,TDisplayStockStatus:%String,TServiceHandler:%String,TServiceTel:%String,TStatCatDR:%String,TStatCat:%String,TModelDR:%String,TEquiCatDR:%String,TUnitDR:%String,TCountryDR:%String,TManageLocDR:%String,TManageLevelDR:%String,TWorkLoadUnitDR:%String,TUseLocDR:%String,TOriginDR:%String,TFromDeptDR:%String,TToDeptDR:%String,TBuyTypeDR:%String,TEquipTechLevelDR:%String,TProviderDR:%String,TManuFactoryDR:%String,TKeeperDR:%String,TEquipTypeDR:%String,TPurchaseTypeDR:%String,TPurposeTypeDR:%String"
Query GetEquipList(Data As %String, ReadOnly) As %Query(ROWSPEC = "TRowID:%String,TName:%String,TABCType:%String,TCode:%String,TDesc:%String,TInstallLocDR:%String,TInstallDate:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TMakeDate:%String,TComputerFlag:%String,TOriginalFee:%String,TNetFee:%String,TNetRemainFee:%String,TGroupDR:%String,TLimitYearsNum:%String,TContractListDR:%String,TDepreMethodDR:%String,TRemark:%String,TDepreTotalFee:%String,TDesignWorkLoadNum:%String,TStatus:%String,TManageUserDR:%String,TMaintUserDR:%String,TProviderHandler:%String,TProviderTel:%String,TAppendFeeTotalFee:%String,TStartDate:%String,TTransAssetDate:%String,TGuaranteeFlag:%String,TInputFlag:%String,TTestFlag:%String,TMedicalFlag:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TCurrencyDR:%String,TInvalidFlag:%String,TStockStatus:%String,TMemoryCode:%String,TUrgencyFlag:%String,TStoreLocDR:%String,TStartDepreMonth:%String,TServiceDR:%String,TInStockListDR:%String,TNo:%String,TModel:%String,TEquiCat:%String,TUnit:%String,TInstallLoc:%String,TCountry:%String,TManageLoc:%String,TManageLevel:%String,TUseLoc:%String,TOrigin:%String,TFromDept:%String,TToDept:%String,TBuyType:%String,TEquipTechLevel:%String,TProvider:%String,TManuFactory:%String,TGroup:%String,TContractList:%String,TDepreMethod:%String,TWorkLoadUnit:%String,TManageUser:%String,TMaintUser:%String,TAddUser:%String,TUpdateUser:%String,TCurrency:%String,TEquipType:%String,TPurchaseType:%String,TPurposeType:%String,TKeeper:%String,TStoreLoc:%String,TService:%String,TInStockList:%String,TQuantity:%String,TBatchFlag:%String,TDisplayStatus:%String,TDisplayStockStatus:%String,TLocation:%String,TGuaranteePeriodNum:%String,TStatCatDR:%String,TStatCat:%String,TFundsFee:%String,TFileNo:%String,TRentLocDR:%String,TRentStatus:%String,TFaultStatus:%String,TDisuseDate:%String,TAccountNo:%String,Thold6:%String,Thold7:%String,Thold8:%String,Thold9:%String,Thold10:%String,TAdvanceDisFlag:%String,TInStockNo:%String,TCommonName:%String,TFundsInfo:%String,TPayNo:%String,TUnusualRemark:%String,TRow:%String,TContractNo:%String,TBackColor:%String,TStartDateFlag:%String,THasDoc:%String,THasFile:%String,TReciveDate:%String,TConfigFlag:%String")
{
}

ClassMethod GetEquipListExecute(ByRef qHandle As %Binary, vData As %String, ReadOnly) As %Status
{
	s gnum=1
	
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k ^DHCEQTemp("EquipList",curuser)
 	new repid, index,rowid,vStoreLocDR,TotalNum,TotalFee,TTotalFundsFee
 	Set TotalNum=0
 	Set TotalFee=0
 	Set TTotalFundsFee=0
 	Set (TotalNetFee,TotalNetRemainFee,TotalDepreTotalFee)=0
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set vData=##class(web.DHCEQCommon).UnEscape(vData)
 	Set EquipCatDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipCatDR")
 	Set StoreLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"StoreLocDR")
 	Set UseLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
 	Set ManageLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"ManageLocDR") 	
 	Set InStockListDR=##class(web.DHCEQCommon).GetDataByName(vData,"InStockListDR")
 	Set BatchFlag=##class(web.DHCEQCommon).GetDataByName(vData,"BatchFlag")
 	Set No=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"No"),"U")
 	Set Code=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"Code"),"U")
 	Set Name=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"Name"),"U")
 	Set CommonName=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"CommonName"),"U")
 	Set ModelDR=##class(web.DHCEQCommon).GetDataByName(vData,"ModelDR")
 	Set Status=##class(web.DHCEQCommon).GetDataByName(vData,"Status")
 	Set MinValue=##class(web.DHCEQCommon).GetDataByName(vData,"MinValue")
 	Set MaxValue=##class(web.DHCEQCommon).GetDataByName(vData,"MaxValue")
 	Set ProviderDR=##class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")
 	Set ManuFactoryDR=##class(web.DHCEQCommon).GetDataByName(vData,"ManuFactoryDR")
 	Set EquipTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDR")
 	Set ServiceDR=##class(web.DHCEQCommon).GetDataByName(vData,"ServiceDR")
 	Set QXType=##class(web.DHCEQCommon).GetDataByName(vData,"QXType")
 	Set PurposeTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"PurposeTypeDR")
 	set IncludeFlag=##class(web.DHCEQCommon).GetDataByName(vData,"IncludeFlag")
 	Set PurchaseTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"PurchaseTypeDR")
 	Set OriginDR=##class(web.DHCEQCommon).GetDataByName(vData,"OriginDR")
 	Set StatCatDR=##class(web.DHCEQCommon).GetDataByName(vData,"StatCatDR")
 	Set BeginInStockDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginInStockDate")
 	Set EndInStockDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndInStockDate")
 	
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	Set BeginInStockDate=##class(web.DHCEQCommon).TransValueFromPage(BeginInStockDate,"date")
	Set EndInStockDate=##class(web.DHCEQCommon).TransValueFromPage(EndInStockDate,"date")
 	Set InvoiceNo=##class(web.DHCEQCommon).GetDataByName(vData,"InvoiceNo")
 	Set ContractNo=##class(web.DHCEQCommon).GetDataByName(vData,"ContractNo")
 	Set IsDisused=##class(web.DHCEQCommon).GetDataByName(vData,"IsDisused")
 	Set IsDisusing=##class(web.DHCEQCommon).GetDataByName(vData,"IsDisusing")
 	Set IsOut=##class(web.DHCEQCommon).GetDataByName(vData,"IsOut")
 	Set ComputerFlag=##class(web.DHCEQCommon).GetDataByName(vData,"ComputerFlag")
 	Set BeginDisuseDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginDisuseDate")
 	Set EndDisuseDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndDisuseDate")
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	Set BeginDisuseDate=##class(web.DHCEQCommon).TransValueFromPage(BeginDisuseDate,"date")
	Set EndDisuseDate=##class(web.DHCEQCommon).TransValueFromPage(EndDisuseDate,"date")
	Set MemoryCode=##class(web.DHCEQCommon).GetDataByName(vData,"MemoryCode")
	Set BeginTransAssetDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginTransAssetDate")
	Set EndTransAssetDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndTransAssetDate")
	
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	Set BeginTransAssetDate=##class(web.DHCEQCommon).TransValueFromPage(BeginTransAssetDate,"date")
	Set EndTransAssetDate=##class(web.DHCEQCommon).TransValueFromPage(EndTransAssetDate,"date")
 	Set FundsTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"FundsTypeDR")
	Set FundsRecordDR=##class(web.DHCEQCommon).GetDataByName(vData,"FundsRecordDR")
 	Set BeginOutDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginOutDate")
	Set EndOutDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndOutDate")
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	Set BeginOutDate=##class(web.DHCEQCommon).TransValueFromPage(BeginOutDate,"date")
	Set EndOutDate=##class(web.DHCEQCommon).TransValueFromPage(EndOutDate,"date")
 	Set MasterItemDR=##class(web.DHCEQCommon).GetDataByName(vData,"MasterItemDR")	
	Set LocIncludeFlag=##class(web.DHCEQCommon).GetDataByName(vData,"LocIncludeFlag")
	Set TreeNo=##class(web.DHCEQCommon).GetDataByName(vData,"TreeNo")
	Set AdvanceDisFlag=##class(web.DHCEQCommon).GetDataByName(vData,"AdvanceDisFlag")
	Set InStockNo=##class(web.DHCEQCommon).GetDataByName(vData,"InStockNo")
	Set LeaveFactoryNo=##class(web.DHCEQCommon).GetDataByName(vData,"LeaveFactoryNo")
	Set StoreMoveNo=##class(web.DHCEQCommon).GetDataByName(vData,"StoreMoveNo")
	Set HospitalDR=##class(web.DHCEQCommon).GetDataByName(vData,"HospitalDR")
	Set FilterFlag=##class(web.DHCEQCommon).GetDataByName(vData,"FilterFlag")
	Set NameStr=##class(web.DHCEQCommon).GetDataByName(vData,"NameStr")
	Set UseLocDRStr=##class(web.DHCEQCommon).GetDataByName(vData,"UseLocDRStr")
	Set ProviderDRStr=##class(web.DHCEQCommon).GetDataByName(vData,"ProviderDRStr")
	Set EquipTypeDRStr=##class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDRStr")
	Set StatusStr=##class(web.DHCEQCommon).GetDataByName(vData,"StatusStr")
	Set ModelDRStr=##class(web.DHCEQCommon).GetDataByName(vData,"ModelDRStr")
	Set NoStr=##class(web.DHCEQCommon).GetDataByName(vData,"NoStr")
	Set MIHold1=##class(web.DHCEQCommon).GetDataByName(vData,"MIHold1")
	Set CommonageFlag=##class(web.DHCEQCommon).GetDataByName(vData,"CommonageFlag")
	Set LimitYearsNum=##class(web.DHCEQCommon).GetDataByName(vData,"LimitYearsNum")
	Set LeaveFactoryNo=##class(web.DHCEQCommon).GetDataByName(vData,"LeaveFactoryNo")
	Set BrandDR=##class(web.DHCEQCommon).GetDataByName(vData,"BrandDR")
	Set Model=##class(web.DHCEQCommon).GetDataByName(vData,"Model")
	Set Model=$ZCONVERT(Model,"U")
	Set FileNo=##class(web.DHCEQCommon).GetDataByName(vData,"FileNo")
	Set FileNo=$ZCONVERT(FileNo,"U")
	Set Location=""
	Set LocationDR=##class(web.DHCEQCommon).GetDataByName(vData,"LocationDR")
	If LocationDR'="" Set Location=$p($g(^DHCEQCCode("DHCEQCLocation",LocationDR)),"^",1)
	Set UserLoc=##class(web.DHCEQCommon).GetDataByName(vData,"UserLoc")
	Set UserLoc=$ZCONVERT(UserLoc,"U")
	Set Name=##Class(web.DHCEQCommon).Trim(Name)
	Set Chk=##class(web.DHCEQCommon).GetDataByName(vData,"Chk")
	Set UnCheckLimitFlag=##class(web.DHCEQCommon).GetDataByName(vData,"UnCheckLimitFlag")
	Set CheckRentFlag=##class(web.DHCEQCommon).GetDataByName(vData,"CheckRentFlag")
	Set FacilityFlag=##class(web.DHCEQCommon).GetDataByName(vData,"FacilityFlag")  //add by zx 2017-03-28 BUG ZX0036
	Set LifeEmergencyFlag=##class(web.DHCEQCommon).GetDataByName(vData,"LifeEmergencyFlag")
	Set UnDisFlag=##class(web.DHCEQCommon).GetDataByName(vData,"UnDisFlag")
	///add by lmm 2018-11-08 begin
	Set EquipDRStr=##class(web.DHCEQCommon).GetDataByName(vData,"EquipDRStr")
	Set StatCatDRStr=##class(web.DHCEQCommon).GetDataByName(vData,"StatCatDRStr")
	Set MastitemDRStr=##class(web.DHCEQCommon).GetDataByName(vData,"MastitemDRStr")
	///add by lmm 2018-11-08 end
	Set ConfigFlag=##class(web.DHCEQCommon).GetDataByName(vData,"ConfigFlag")  // Mozy0217  2018-11-01
	Set index=2
	Set rowid=0
	k ^DHCEQTemp("EquipList",0,"Cat",$j)
	s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s CurGroupID=%session.Get("LOGON.GROUPID")
	d BuildDataGetEquipList
	k ^DHCEQTemp("EquipList",0,"Cat",$j)
	k ^DHCEQTemp("EquipList",0,"Depre",$j)
	
	Quit $$$OK
BuildDataGetEquipList
	s findnolist=0
	s CheckLocFlag=0
	i BatchFlag ="Y" 
	{
		s InStockList=0		
		f  s InStockList=$o(^DHCEQEquip(0,"InStockList",InStockList))  quit:InStockList=""  d
		.q:(InStockListDR'="")&(InStockListDR'=InStockList)
		.s vStoreLocDR=0
		.f  s vStoreLocDR=$o(^DHCEQEquip(0,"InStockList",InStockList,vStoreLocDR))  quit:vStoreLocDR=""  d
		..s TQuantity=0
		..s TBatchFundsFee=0
		..s tmpTotalFee=0	;;Modified by JDL 2012-3-1 JDL0118 修正合计错误
		..s tmpTotalNetFee=0
		..s tmpTotalNetRemainFee=0
		..s tmpTotalDepreTotalFee=0
		..s TInStockListDR=InStockList
		..s vRowID=""
		..s rowid=0
		..f  s rowid=$o(^DHCEQEquip(0,"InStockList",InStockList,vStoreLocDR,rowid))  quit:rowid=""  d
		...d ResetVariablesGetEquipList
		...d CheckGetEquipList
		...q:passed=0
		...s TQuantity=TQuantity+1
		...;Modified by JDL 2012-3-1 JDL0118 修正合计错误
		...s tmpTotalFee=tmpTotalFee+$p(^DHCEQEquip(rowid),"^",27)
		...s tmpTotalNetFee=tmpTotalNetFee+$p(^DHCEQEquip(rowid),"^",28)
		...s tmpTotalNetRemainFee=tmpTotalNetRemainFee+$p(^DHCEQEquip(rowid),"^",29)
		...s tmpTotalDepreTotalFee=tmpTotalDepreTotalFee+$p(^DHCEQEquip(rowid),"^",35)
		...s vRowID=rowid
		...s TBatchFundsFee=TBatchFundsFee+TFundsFee
		...;add by lmm 2018-09-14 begin 685010
		...S (EquipNetFee,EquipDepreFee)=""
		...s EquipNetFee=$p(^DHCEQEquip(rowid),"^",28)
		...s EquipDepreFee=$p(^DHCEQEquip(rowid),"^",35)
		...i $d(^DHCEQTemp("EquipList",0,"Depre",$j,InStockList,vStoreLocDR))  d
		....s ^DHCEQTemp("EquipList",0,"Depre",$j,InStockList,vStoreLocDR)=($p($g(^DHCEQTemp("EquipList",0,"Depre",$j,InStockList,vStoreLocDR)),"^",1)+EquipNetFee)_"^"_($p($g(^DHCEQTemp("EquipList",0,"Depre",$j,InStockList,vStoreLocDR)),"^",2)+EquipDepreFee)
		...e  d
		....s ^DHCEQTemp("EquipList",0,"Depre",$j,InStockList,vStoreLocDR)=EquipNetFee_"^"_EquipDepreFee
		...;add by lmm 2018-09-14 end 685010
		...;Modified by jdl 2011-3-15 取消BatchFlag的使用
		...;i $p($g(^DHCEQInStockList(InStockList)),"^",3)="N"  d
		...;.d SetVariablesGetEquipList
		..q:TQuantity=0
		..
		..;Modified by JDL 2012-3-1 JDL0118 修正批量显示出错
		..s TInStockListDR=InStockList
		..
		..;Modified by jdl 2011-3-15 取消BatchFlag的使用
		..;以数量来区分处理,一条显示设备信息,多个显示批量信息
		..i TQuantity=1  d
		...s rowid=vRowID
		...d SetVariablesGetEquipList
		..e  d
		...s TotalNum=TotalNum+TQuantity
		...;Modified by JDL 2012-3-1 JDL0118 修正合计错误
		...s TotalFee=TotalFee+tmpTotalFee
		...s TotalNetFee=TotalNetFee+tmpTotalNetFee
		...s TotalNetRemainFee=TotalNetRemainFee+tmpTotalNetRemainFee
		...s TotalDepreTotalFee=TotalDepreTotalFee+tmpTotalDepreTotalFee
		...Set rowid=vRowID		;Mozy0100	2013-6-3	批量的情况取第一台设备信息
		...d SetBatchVariablesGetEquipList
		..
		..;i $p($g(^DHCEQInStockList(InStockList)),"^",3)="Y"  d
		..;.s TotalNum=TotalNum+TQuantity
		..;.d SetBatchVariablesGetEquipList
		..d OutputRowGetEquipList
		s findnolist=1
	}
	s rowid=0
	if (FilterFlag="Y")&&((UseLocDRStr'="")||(ProviderDRStr'=""))
	{
		if (UseLocDRStr'="")
		{
			s Len=$l(UseLocDRStr,",")
			for i=1:1:Len
			{
				s UseLocID=$p(UseLocDRStr,",",i)
				s rowid=0
				f  s rowid=$o(^DHCEQEquip(0,"UseLoc",UseLocID,rowid))  quit:rowid=""  d
				.d FillOneDataGetEquipList		
			}
		}
		elseif(ProviderDRStr'="")
		{
			s Len=$l(ProviderDRStr,",")
			for i=1:1:Len
			{
				s ProviderDR=$p(ProviderDRStr,",",i)
				s rowid=0
				f  s rowid=$o(^DHCEQEquip(0,"Provider",ProviderDR,rowid))  quit:rowid=""  d
				.d FillOneDataGetEquipList	
			}
		}
	}
	elseif InStockListDR'=""
	{
		s vStoreLocDR=0
		f  s vStoreLocDR=$o(^DHCEQEquip(0,"InStockList",InStockListDR,vStoreLocDR))  quit:vStoreLocDR=""  d
		.s rowid=0
		.f  s rowid=$o(^DHCEQEquip(0,"InStockList",InStockListDR,vStoreLocDR,rowid))  quit:rowid=""  d
		..d FillOneDataGetEquipList
		//quit
	}
	elseif (StoreMoveNo'="")
	{
		Set SMRowID=0		
		For  Set SMRowID=$Order(^DHCEQStoreMove(0,"StoreMoveNo",StoreMoveNo,SMRowID))  Quit:SMRowID=""  Do
		.Set TStoreMoveNo=StoreMoveNo
		.Set SMLRowID=0 
		.For  Set SMLRowID=$Order(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  Quit:SMLRowID=""  Do
		..Set CSRowID=0
		..For  Set CSRowID=$Order(^DHCEQChangeStock(0,"Source",1,SMLRowID,CSRowID))  Quit:CSRowID=""  Do
		...Set rowid = $Piece($Get(^DHCEQChangeStock(CSRowID)),"^",1)
		...Do FillOneDataGetEquipList
		//quit
	}
	elseif (StoreLocDR'="")
	{	
		f  s rowid=$o(^DHCEQEquip(0,"StoreLoc",StoreLocDR,rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipList
		//quit
	}
	elseif(UseLocDR'="")||(HospitalDR'="")
	{
		;检测科室标志
		s CheckLocFlag=1
		s TCUseLocDR=0
		f  s TCUseLocDR=$o(^DHCEQEquip(0,"UseLoc",TCUseLocDR))  quit:TCUseLocDR=""  d
		.q:(LocIncludeFlag'="1")&&(TCUseLocDR'=UseLocDR)&&(UseLocDR'="")
		.;检测是否为子科室
		.q:(LocIncludeFlag="1")&&(..CheckIsChildLoc(UseLocDR,TCUseLocDR,"1")'="1")&&(UseLocDR'="")
		.
		.;add by Mozy 2011-11-09	Mozy0068
		.Set THospitalDR=$Piece($Get(^CTLOC(TCUseLocDR)),"^",22)
		.Quit:(HospitalDR'="")&(HospitalDR'=THospitalDR)
		.
		.s rowid=0
		.f  s rowid=$o(^DHCEQEquip(0,"UseLoc",TCUseLocDR,rowid))  quit:rowid=""  d
		..d FillOneDataGetEquipList		
	}
	elseif(ProviderDR'="")
	{
		f  s rowid=$o(^DHCEQEquip(0,"Provider",ProviderDR,rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipList
		//quit
	}
	elseif(ManuFactoryDR'="")
	{
		f  s rowid=$o(^DHCEQEquip(0,"ManuFactory",ManuFactoryDR,rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipList
		//quit
	}
	elseif(ServiceDR'="")
	{
		f  s rowid=$o(^DHCEQEquip(0,"Service",ServiceDR,rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipList
		//quit
	}
	else
	{
		f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipList
		//quit
	}
	
	//hisui改造 add by zc0037 2018-09-30 去掉台账合计行 begin
	/*
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		i TotalFlag="3" s TotalLoc=0
		d ResetVariablesGetEquipList
		s TRow="合计:"	// 20150914  Mozy0165 序号
		s TQuantity=TotalNum
		s TOriginalFee=TotalFee
		s TFundsFee=TTotalFundsFee
		Set TNetFee=##Class(web.DHCEQCommon).FormatNumber(TotalNetFee,"")
		Set TNetRemainFee=##Class(web.DHCEQCommon).FormatNumber(TotalNetRemainFee,"")
		Set TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalDepreTotalFee,"")
		//格式化金额为小数点两位
		i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
		i TFundsFee'="" s TFundsFee=##Class(web.DHCEQCommon).FormatNumber(TFundsFee,"") 
	
		//d OutputRowGetEquipList
		s Data=$lb(TRowID,TName,TABCType,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TQuantity,TBatchFlag,TDisplayStatus,TDisplayStockStatus,TLocation,TGuaranteePeriodNum,TStatCatDR,TStatCat,TFundsFee,TFileNo,TRentLocDR,TRentStatus,TFaultStatus,TDisuseDate,TAccountNo,Thold6,Thold7,Thold8,Thold9,Thold10,TAdvanceDisFlag,TInStockNo,TCommonName,TFundsInfo,TPayNo,TUnusualRemark,TRow,TContractNo,TBackColor)
		Set ^CacheTemp(repid,TotalLoc)=Data
		s ^DHCEQTemp("EquipList",curuser,gnum)=TName_"^"_TModel_"^"_TEquiCat_"^"_TUnit_"^"_TCode_"^"_TDesc_"^"_TInstallLoc_"^"_TInstallDate_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TCheckDate_"^"_TOpenCheckDate_"^"_TMakeDate_"^"_TCountry_"^"_TUseLoc_"^"_TOrigin_"^"_TFromDept_"^"_TToDept_"^"_TBuyType_"^"_TProvider_"^"_TManuFactory_"^"_TOriginalFee_"^"_TNetFee_"^"_TNetRemainFee_"^"_TLimitYearsNum_"^"_TContractList_"^"_TDepreMethod_"^"_TRemark_"^"_TDepreTotalFee_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnit_"^"_TManageUser_"^"_TMaintUser_"^"_TProviderHandler_"^"_TProviderTel_"^"_TAppendFeeTotalFee_"^"_TStartDate_"^"_TTransAssetDate_"^"_TGuaranteeFlag_"^"_TTestFlag_"^"_TMedicalFlag_"^"_TGuaranteeStartDate_"^"_TGuaranteeEndDate_"^"_TBatchFlag_"^"_TQuantity_"^"_TMemoryCode_"^"_TUrgencyFlag_"^"_TEquipType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TKeeper_"^"_TStoreLoc_"^"_TStartDepreMonth_"^"_TService_"^"_TInStockList_"^"_TNo_"^"_TDisplayStatus_"^"_TDisplayStockStatus_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TStoreLocDR_"^"_TStatCat_"^"_TFundsFee_"^"_TRowID_"^"_TFileNo_"^"_TRentLocDR_"^"_TRentStatus_"^"_TFaultStatus_"^"_TDisuseDate_"^"_TAccountNo_"^"_Thold6_"^"_Thold7_"^"_Thold8_"^"_Thold9_"^"_Thold10_"^"_TAdvanceDisFlag_"^"_TInStockNo_"^"_TCommonName_"^"_TFundsInfo_"^"_TPayNo_"^"_TUnusualRemark_"^"_TRow_"^"_TContractNo_"^"_THasDoc_"^"_THasFile_"^"_TReciveDate
		//s ^DHCEQTemp("Equip",+$H,$j,gnum)=TName_"^"_TModel_"^"_TEquiCat_"^"_TUnit_"^"_TCode_"^"_TDesc_"^"_TInstallLoc_"^"_TInstallDate_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TCheckDate_"^"_TOpenCheckDate_"^"_TMakeDate_"^"_TCountry_"^"_TUseLoc_"^"_TOrigin_"^"_TFromDept_"^"_TToDept_"^"_TBuyType_"^"_TProvider_"^"_TManuFactory_"^"_TOriginalFee_"^"_TNetFee_"^"_TNetRemainFee_"^"_TLimitYearsNum_"^"_TContractList_"^"_TDepreMethod_"^"_TRemark_"^"_TDepreTotalFee_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnit_"^"_TManageUser_"^"_TMaintUser_"^"_TProviderHandler_"^"_TProviderTel_"^"_TAppendFeeTotalFee_"^"_TStartDate_"^"_TTransAssetDate_"^"_TGuaranteeFlag_"^"_TTestFlag_"^"_TMedicalFlag_"^"_TGuaranteeStartDate_"^"_TGuaranteeEndDate_"^"_TBatchFlag_"^"_TQuantity_"^"_TMemoryCode_"^"_TUrgencyFlag_"^"_TEquipType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TKeeper_"^"_TStoreLoc_"^"_TStartDepreMonth_"^"_TService_"^"_TInStockList_"^"_TNo_"^"_TDisplayStatus_"^"_TDisplayStockStatus_"^"_TServiceHandler_"^"_TServiceTel
	}*/
	//hisui改造 add by zc0037 2018-09-30 去掉台账合计行 end
	quit
FillOneDataGetEquipList
	d ResetVariablesGetEquipList
	d CheckGetEquipList
	q:passed=0
	d SetVariablesGetEquipList
	d OutputRowGetEquipList
	quit
ResetVariablesGetEquipList
	s (TRowID,TName,TABCType,TModelDR,TEquiCatDR,TUnitDR,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TCountryDR,TManageLocDR,TManageLevelDR,TUseLocDR,TOriginDR,TFromDeptDR,TToDeptDR,TBuyTypeDR,TEquipTechLevelDR,TProviderDR,TManuFactoryDR,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TWorkLoadUnitDR,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TEquipTypeDR,TPurchaseTypeDR,TPurposeTypeDR,TKeeperDR,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TLocation,TGuaranteePeriodNum,TStatCatDR,TStatCat,TFundsFee,TDisplayStatus,TDisplayStockStatus)=""
	s (TFileNo,TRentLocDR,TRentStatus,TFaultStatus,TDisuseDate,TAccountNo,Thold6,Thold7,Thold8,Thold9,Thold10,TAdvanceDisFlag,TStoreMoveNo,TInStockNo,TCommonName,THospitalDR,TFundsInfo,TPayNo,TUnusualRemark,TRow,TContractNo,TBackColor,TStartDateFlag,THasDoc,THasFile,TReciveDate,TConfigFlag)=""
	s TBatchFlag="N"
	quit
CheckGetEquipList
	s passed=0
	s EquipData=$g(^DHCEQEquip(rowid))
	s TUseLocDR = $p(EquipData,"^",19)
	;i ",112,108,98,118,116,356,130,113,88,103,89,115,75,99,"'[(","_TUseLocDR_",") q
	i (CheckLocFlag=0)&&(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
	{quit}
	if (FilterFlag="Y")&&(UseLocDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(UseLocDRStr,TUseLocDR,"Y")=0 {quit}
	}
	s TInvalidFlag = $p(EquipData,"^",59)
	i TInvalidFlag'="N" quit
	
	;Modified by jdl 2012-1-6 JDL0109
	;优化查询及查询报错
	s TStatus = $p(EquipData,"^",38)
	i (Status'="")&(Status'=TStatus)
		{quit}
	s Thold9=$P(EquipData,"^",94)
	i (BrandDR'="")&(Thold9'=BrandDR)
		{quit}
	if (FilterFlag="Y")&&(StatusStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(StatusStr,TStatus,"Y")=0 {quit}
	}
	//是否包含已经报废设备
	i (IsDisused="Y")&(TStatus'=3)
		{quit}
	i (IsDisused="N")&(TStatus=3)
		{quit}
		
	///判断是否还未入库
	s TStockStatus=$p(EquipData,"^",60)
	i (TStockStatus="0")
		{	quit}
	//是否包含已经出库设备
	i (IsOut="Y")&(TStockStatus'="3")
		{	quit}
	i (IsOut="N")&(TStockStatus="3")
		{	quit}
	
	s TEquiCatDR = $p(EquipData,"^",4)	
	i (EquipCatDR'="")&(EquipCatDR'=TEquiCatDR)
		{
			i (IncludeFlag'="1")
			{
				quit
			}
			else
			{
				//modified by jdl 2010-10-11 JDL0050 优化根据分类查找
				i TEquiCatDR=""
				{
					quit
				}
				else
				{
					i $g(^DHCEQTemp("EquipList",0,"Cat",$j,TEquiCatDR))=""
					{					
						s ^DHCEQTemp("EquipList",0,"Cat",$j,TEquiCatDR)=##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatDR,TEquiCatDR)						
					}
					i +$g(^DHCEQTemp("EquipList",0,"Cat",$j,TEquiCatDR))=0 quit
				}
			}
		}
	//简易台帐过滤位置置前处理.
	Set TEquipTypeDR=$p(EquipData,"^",63)
	i (EquipTypeDR'="")&(EquipTypeDR'=TEquipTypeDR)
		{quit}
	i (EquipTypeDR="")&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,"","",FacilityFlag))
		{quit}
	s TStoreLocDR = $p(EquipData,"^",67)
	i (StoreLocDR'="")&(StoreLocDR'=TStoreLocDR) quit
	i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TStoreLocDR,CurLocID,CurGroupID)))
	{
		quit
	}
	Set THospitalDR=$Piece($Get(^CTLOC(TStoreLocDR)),"^",22)
	i (HospitalDR'="")&(HospitalDR'=THospitalDR)
		{quit}	
	s TUseLocDR = $p(EquipData,"^",19)
	i (CheckLocFlag=0)&&(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
		{quit}
	s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	i (UserLoc'="")&&(TUseLoc'[UserLoc) //  add by jy 2015-12-23  JY0009
	{quit}
	;ZY0098
	if (FilterFlag="Y")&&(UseLocDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(UseLocDRStr,TUseLocDR,"Y")=0 {quit}
	}
	s TManageLocDR = $p(EquipData,"^",17)
	i (ManageLocDR'="")&(ManageLocDR'=TManageLocDR)
		{quit}
	s TInStockListDR = $p(EquipData,"^",70)
	i (InStockListDR'="")&(InStockListDR'=TInStockListDR)
		{quit}
	if ((BeginInStockDate'="")||(EndInStockDate'=""))	
	{
		i (TInStockListDR="")
		{	s InStockDate=$p(EquipData,"^",45)}
		else
		{
			s InStockDate=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
			s InStockDate=$p(^DHCEQInStock(InStockDate),"^",13)
		}
		i ((BeginInStockDate'="")&(InStockDate<BeginInStockDate))
		{quit}
		
		i ((EndInStockDate'="")&(InStockDate>EndInStockDate))
		{quit}
	}
	
	if ((BeginTransAssetDate'="")||(EndTransAssetDate'=""))	
	{
		s TransAssetDate=$p(EquipData,"^",45)
		i ((BeginTransAssetDate'="")&(TransAssetDate<BeginTransAssetDate))
		{quit}
		
		i ((EndTransAssetDate'="")&(TransAssetDate>EndTransAssetDate))
		{quit}
	}
	
	s TModelDR = $p(EquipData,"^",3)
	i (ModelDR'="")&(ModelDR'=TModelDR)
		{quit}
	
	if (FilterFlag="Y")&&(ModelDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(ModelDRStr,TModelDR,"Y")=0 {quit}
	}
	i (TStatus=3)
	{
		//Modified by jdl 2010-8-24
		s TDisuseDate=$p(EquipData,"^",89)
		
		i ((BeginDisuseDate'="")&(TDisuseDate<BeginDisuseDate))
		{
			quit
		}
		i ((EndDisuseDate'="")&(TDisuseDate>EndDisuseDate))
		{
			quit
		}
	}
	s TOriginalFee=$p(EquipData,"^",27)
	i (MinValue'="")&(MinValue>TOriginalFee)
		{quit}
	i (MaxValue'="")&(MaxValue<TOriginalFee)
		{quit}
	s TProviderDR = $p(EquipData,"^",25)
	i (ProviderDR'="")&(ProviderDR'=TProviderDR)
		{quit}
		
	if (FilterFlag="Y")&&(ProviderDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(ProviderDRStr,TProviderDR,"Y")=0 {quit}
	}
	s TManuFactoryDR = $p(EquipData,"^",26)
	i (ManuFactoryDR'="")&(ManuFactoryDR'=TManuFactoryDR)
		{quit}
	s TServiceDR = $p(EquipData,"^",69)
	i (ServiceDR'="")&(ServiceDR'=TServiceDR)
		{quit}
	s TPurchaseTypeDR=$p(EquipData,"^",64)
	i (PurchaseTypeDR'="")&(PurchaseTypeDR'=TPurchaseTypeDR)
		{quit}
	s TOriginDR=$p(EquipData,"^",20)
	i (OriginDR'="")&(OriginDR'=TOriginDR)
		{quit}	
	if (FilterFlag="Y")&&(EquipTypeDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(EquipTypeDRStr,TEquipTypeDR,"Y")=0 {quit}
	}
 	Set TPurposeTypeDR=$p(EquipData,"^",65)
 	i (PurposeTypeDR'="")&(PurposeTypeDR'=TPurposeTypeDR)
		{quit}
	s TCode = $ZCONVERT($p(EquipData,"^",6),"U")
	s TCommonName = $ZCONVERT($p(EquipData,"^",1),"U")
	i (CommonName'="")&(TCommonName'[CommonName)
	{quit}
	s TName=""
	s TLifeEmergencyFlag=""
	s TItemDR=$p(EquipData,"^",7)
	i TItemDR'=""  d
	.s TName=$ZCONVERT($p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1),"U")
	.s TLifeEmergencyFlag=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",13)
	i (LifeEmergencyFlag="Y")&&(TLifeEmergencyFlag'=LifeEmergencyFlag)
	{quit}
	s TNo = $ZCONVERT($p(EquipData,"^",71),"U")
	if (FilterFlag="Y")&&(NameStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(NameStr,TName,"N")=0 {quit}
	}
	if (FilterFlag="Y")&&(NoStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(NoStr,TNo,"N")=0 {quit}
	}
	i ((TCode'[Code)||(TNo'[No))
		{quit}
	i (Name'="")
	{
		Set len = $Length(Name," ")
		for i=1:1:len
		{
			If ($Piece(Name," ",i)'="")&(TName[$Piece(Name," ",i)) Set passed=1
		}
		i passed'=1 q
		s passed=0
	}
	s TStatCatDR = $p(EquipData,"^",75)
	i (StatCatDR'="")&&(StatCatDR'=TStatCatDR)
	{quit}
	//不限制CheckManageLimit，查询台帐。 JDL20160527 特殊情况需要。
	i UnCheckLimitFlag'="Y"
	{
		Quit:(##Class(web.DHCEQCommon).CheckManageLimit("","","",TEquipTypeDR,TStatCatDR,TEquiCatDR,TStoreLocDR,rowid,TItemDR))
	}
	i (findnolist=1)&(TInStockListDR'="")
	{
		quit
	}
	i (InvoiceNo'="")
	{
		// Mozy0059	2011-8-17	模糊检索某一来源的全部发票号
		Set TInvoiceNo=..GetInvoiceNo(rowid,0)
		Set len = $Length(TInvoiceNo,"&")
		for i=1:1:len
		{
			If $Piece($Piece(TInvoiceNo,"&",i),"^",1)[InvoiceNo Set passed=1
		}
		i passed'=1 q
		s passed=0
	}
	
	i (ContractNo'="")
	{
		s THold1=$p($g(^DHCEQEquip(rowid)),"^",76)
		if THold1'[ContractNo
		{
			quit
		}
		/*
		if ContractNo'=..GetContractNo(rowid)
		{
			quit
		}
		*/
	}
	
	s TComputerFlag = $p(EquipData,"^",15)
	i ((ComputerFlag="Y")&("Y"'=TComputerFlag))||((ComputerFlag="N")&("Y"=TComputerFlag))  //Modified  2014-1-16 HZY0047
	{quit}
	s THold1 = $p(EquipData,"^",76)
	i (IsDisusing="Y")&(THold1'="1")
	{quit}
	i (IsDisusing="N")&(THold1="1")
	{quit}
	
	//add by JDL 2009-9-7 JDL0023
	s TMemoryCode=$p(EquipData,"^",61)
	i (MemoryCode'="")&&(MemoryCode'=TMemoryCode)
	{quit}
	
	//add by jdl 2010-3-30	JDL0045
	s TFundsFee=TOriginalFee
	i ((FundsTypeDR'="")||(FundsRecordDR'=""))
	{
		s TFundsFee=##Class(web.DHCEQFunds).GetFundsAmountByFromID(1,rowid,FundsTypeDR,FundsRecordDR)
		i +TFundsFee=0
		{
			quit
		}
	}
	;add by jdl 2010-8-25
	;增加减少日期的判断
	i (TStockStatus="3")
	{
		i ((BeginOutDate'="")||(EndOutDate'=""))
		{
			s TOutID=$o(^DHCEQLifeInfo(0,"EquipSource","23",rowid,0))	
			s TLifeInfoID=$o(^DHCEQLifeInfo(0,"EquipSource","23",rowid,TOutID,0))	
			s TOutDate=$p(^DHCEQLifeInfo(TLifeInfoID),"^",15)
			i (BeginOutDate'="")
			{
				i (TOutDate<BeginOutDate)
				{
					quit
				}
			}
			i (EndOutDate'="")
			{
				i (TOutDate>EndOutDate)
				{
					quit
				}
			}
		}
	}
	//add by mwz 2017-10-30 需求号467202
	//停用设备查询
	i (TStatus="2")
	{
		s CIRowID=$o(^DHCEQChangeInfo(0,"EquipChangeType",rowid,2,0,0,""),-1)
		i CIRowID'=""
		{
			s OutDate=$p(^DHCEQChangeInfo(CIRowID),"^",4)
			i (BeginOutDate'="")&&(OutDate<BeginOutDate) quit
			i (EndOutDate'="")&&(OutDate>EndOutDate) quit
		}
	}
	s TMasterItemDR = $p(EquipData,"^",7)
	i (MasterItemDR'="")&&(MasterItemDR'=TMasterItemDR)
	{quit}
	//Mozy0110 68码
	If (MIHold1'="")
	{
		Set TMIHold1=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TMasterItemDR)),"^",10)
		If (TMIHold1'=MIHold1) Quit
	}
	s TLimitYearsNum = $p(EquipData,"^",31)
	i (LimitYearsNum'="")&&(LimitYearsNum'=TLimitYearsNum)
	{quit}
	s TLeaveFactoryNo = $p(EquipData,"^",10)
	i (LeaveFactoryNo'="")&&(TLeaveFactoryNo'[LeaveFactoryNo)
	{quit}
	i TreeNo'=""
	{
		s TTreeNo=""
		i (TMasterItemDR'="")
		{
			s TTreeNo=$p($g(^DHCEQCCode("DHCEQCMasterItem",TMasterItemDR)),"^",10)
			i TTreeNo'="" s TTreeNo=$p($g(^DHCEQCCode("DHCEQCTree",TTreeNo)),"^",2)
		}
		i ((TTreeNo="")||(TreeNo'=$e(TTreeNo,1,$l(TreeNo))))
		{quit}
	}
	//20150827  Mozy0163	存放地点
	i Location'=""
	{
		s TLocationDR = $p(EquipData,"^",72)
		i TLocationDR=""
		{quit}
		i $e($p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",1),1,$l(Location))'=Location
		{quit}
	}
	//modified by ZY 2015-07-27  ZY0134 Hold8改成EQ_AdvanceDisFlag,用于记录设备的异常状态
	//add by zy 2011-02-22  ZY0061 设备院内报废参数查询 
	//修改为直接取EQ_Hold8字段的值来判断设备的预报废
	s THold8 = $p(EquipData,"^",93)
	i (AdvanceDisFlag'="")&&(THold8'=AdvanceDisFlag)
	{quit}
	
	i (InStockNo'="")
	{
		i (TInStockListDR="") quit
		s TInStockNo=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
		s TInStockNo=$p($g(^DHCEQInStock(TInStockNo)),"^",14)
		i (TInStockNo'[InStockNo) quit
	}
	Set TLeaveFactoryNo=$p(EquipData,"^",10)		//出厂编号
	If (LeaveFactoryNo'="")&(TLeaveFactoryNo'[LeaveFactoryNo) quit
	if StoreMoveNo'=""
	{
		i TStoreMoveNo=""
		{
			s LifeSourceID=0
			f  s LifeSourceID=$o(^DHCEQLifeInfo(0,"EquipSource",22,rowid,LifeSourceID)) quit:(LifeSourceID="")  d
			.i ($p($g(^DHCEQStoreMove($p($g(^DHCEQStoreMoveList(LifeSourceID)),"^",1))),"^",1)=StoreMoveNo)  d
			..s passed=1
			i passed'=1 q
			s passed=0
		}
	}
	s TCommonageFlag=$p(EquipData,"^",82) //共用标记
	If (CommonageFlag'="")
	{
		i (CommonageFlag="Y")&&(TCommonageFlag'=CommonageFlag) quit
		i (CommonageFlag="N")&&(TCommonageFlag="Y") quit
	}
	If (Model'="")
	{
		Set TModel = ""
		If TModelDR '="" Set TModel = $Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		If (TModel="")||($ZCONVERT(TModel,"U")'[Model) Quit
	}
	Set TFileNo=$Piece(EquipData,"^",85)
	If (FileNo'="")&&($ZCONVERT(TFileNo,"U")'[FileNo) Quit
	If (Chk'="")&(##class(web.DHCEQOperateLog).GetOperateLogInfo(52,rowid,2)'="") Quit
	If (CheckRentFlag'=0)&(CheckRentFlag'="")&(##Class(web.DHCEQEquipRent).CheckEquipIsInRent(rowid)) Quit
	
	//依次为不包含附属设备和仅附属设备过滤	Mozy	763889	2018-12-6
	i (ConfigFlag=0)&&($p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",24)'="") Quit
	i (ConfigFlag=1)&&($p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",24)="") Quit
	If (UnDisFlag'="")&&(THold8=2) Quit
	
	//add by lmm 2018-11-08 begin
	if (FilterFlag="Y")&&(EquipDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(EquipDRStr,rowid,"Y")=0 {quit}
	}
	if (FilterFlag="Y")&&(StatCatDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(StatCatDRStr,TStatCatDR,"Y")=0 {quit}
	}
	if (FilterFlag="Y")&&(MastitemDRStr'="")
	{
		i ##Class(web.DHCEQCommon).Find(MastitemDRStr,TMasterItemDR,"Y")=0 {quit}
	}
	
	
	//add by lmm 2018-11-08 end
	
	
	s passed=1
	quit
SetBatchVariablesGetEquipList
	
	s TNo=""  //add by lmm 2018-09-14 684046
	s TNetFee=$p($g(^DHCEQTemp("EquipList",0,"Depre",$j,TInStockListDR,vStoreLocDR)),"^",1) //add by lmm 2018-09-14 685010
	s TDepreTotalFee=$p($g(^DHCEQTemp("EquipList",0,"Depre",$j,TInStockListDR,vStoreLocDR)),"^",2) //add by lmm 2018-09-14 685010
	
	
	s TBatchFlag="Y"
	s TCommonName = $p($g(^DHCEQInStockList(TInStockListDR)),"^",5)	//2013-06-24 DJ0118 begin
	s TName=$p($g(^DHCEQInStockList(TInStockListDR)),"^",16)
	i TName'="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TName)),"^",1) //2013-06-24 DJ0118 end
	s TManuFactoryDR = $p($g(^DHCEQInStockList(TInStockListDR)),"^",6)
	i TManuFactoryDR '=""  d
	.s TManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	s TOriginalFee = $p($g(^DHCEQInStockList(TInStockListDR)),"^",7)
	;s TotalFee=TotalFee+(TOriginalFee*TQuantity)
	
	//add by jdl
	s TTotalFundsFee=TTotalFundsFee+TBatchFundsFee
	
	s TModelDR = $p($g(^DHCEQInStockList(TInStockListDR)),"^",9)
	i TModelDR '=""  d
	.s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TUnitDR = $p($g(^DHCEQInStockList(TInStockListDR)),"^",10)
	i TUnitDR '=""  d
	.s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	s TProviderDR = $p($g(^DHCEQInStock($p($g(^DHCEQInStockList(TInStockListDR)),"^",1))),"^",17)
	i TProviderDR '=""  d
	.s TProvider =##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	
	s TEquipTypeDR = $p($g(^DHCEQInStock($p($g(^DHCEQInStockList(TInStockListDR)),"^",1))),"^",20)
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TStatCatDR=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(TInStockListDR)),"^",1))),"^",21)
	i TStatCatDR'="" d
	.s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)


	s TEquiCatDR = $p($g(^DHCEQInStockList(TInStockListDR)),"^",14)
	i TEquiCatDR '=""  d
	.s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCatDR)),"^",2)
	
	i vStoreLocDR'=""  d
	.s TStoreLocDR=vStoreLocDR
	.s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	;Mozy0100	2013-6-3
	Set TInStockList=TInStockListDR
	If TInStockList'="" Do
	.Set TInStockList = $Piece($Get(^DHCEQInStockList(TInStockListDR)),"^",1)
	.If TInStockList'="" Set TInStockNo = $Piece($Get(^DHCEQInStock(TInStockList)),"^",14)
	Set TLeaveFactoryDate=$Piece($Get(^DHCEQEquip(rowid)),"^",11)
	Set TOpenCheckDate=$Piece($Get(^DHCEQEquip(rowid)),"^",12)
	Set TOpenCheckDate=##Class(web.DHCEQCommon).TransValueToPage(TOpenCheckDate,"date")
	Set TCheckDate=$Piece($Get(^DHCEQEquip(rowid)),"^",13)
	Set TCheckDate=##Class(web.DHCEQCommon).TransValueToPage(TCheckDate,"date")
	Set TMakeDate=$Piece($Get(^DHCEQEquip(rowid)),"^",14)
	Set TMakeDate=##Class(web.DHCEQCommon).TransValueToPage(TMakeDate,"date")
	Set TNetRemainFee=$Piece($Get(^DHCEQEquip(rowid)),"^",29)
	Set TLimitYearsNum=$Piece($Get(^DHCEQEquip(rowid)),"^",31)
	Set TDepreMethodDR=$Piece($Get(^DHCEQEquip(rowid)),"^",33)
	If TDepreMethodDR'="" Set TDepreMethod=$Piece($Get(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	Set TProviderHandler=$Piece($Get(^DHCEQEquip(rowid)),"^",41)
	Set TProviderTel=$Piece($Get(^DHCEQEquip(rowid)),"^",42)
	Set TTransAssetDate=$Piece($Get(^DHCEQEquip(rowid)),"^",45)
	Set TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
	Set TServiceDR=$Piece($Get(^DHCEQEquip(rowid)),"^",69)
	If TServiceDR'="" Set TService=$Piece($Get(^DHCEQCCode("DHCEQCService",TServiceDR)),"^",2)
	Set TCountryDR=$Piece($Get(^DHCEQEquip(rowid)),"^",16)
	If TCountryDR'="" Set TCountry=##Class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
	Set TOriginDR=$Piece($Get(^DHCEQEquip(rowid)),"^",20)
	If TOriginDR'="" Set TOrigin=$Piece($Get(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	Set TFromDeptDR=$Piece($Get(^DHCEQEquip(rowid)),"^",21)
	If TFromDeptDR'="" Set TFromDept=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TFromDeptDR)
	Set TBuyTypeDR=$Piece($Get(^DHCEQEquip(rowid)),"^",23)
	If TBuyTypeDR'="" Set TBuyType=$Piece($Get(^DHCEQCCode("DHCEQCBuyType",TBuyTypeDR)),"^",2)
	Set TEquipTechLevelDR=$Piece($Get(^DHCEQEquip(rowid)),"^",24)
	If TEquipTechLevelDR'="" Set TEquipTechLevel=$Piece($Get(^DHCEQCCode("DHCEQCTechLevel",TEquipTechLevelDR)),"^",2)
	Set TContractListDR = $Piece($Get(^DHCEQEquip(rowid)),"^",32)
	If TContractListDR '=""  Set TContractList = $Piece($Get(^DHCEQContractList(TContractListDR)),"^",1)
	Set TWorkLoadUnitDR = $Piece($Get(^DHCEQEquip(rowid)),"^",37)
	If TWorkLoadUnitDR '="" Set TWorkLoadUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUnitDR)
	Set TCurrencyDR=$Piece($Get(^DHCEQEquip(rowid)),"^",58)
	If TCurrencyDR'="" Set TCurrency=$Piece($Get(^DHCEQCCode("DHCEQCCurrency",TCurrencyDR)),"^",2)
	Set TMemoryCode=$Piece($Get(^DHCEQEquip(rowid)),"^",61)
	Set TPurchaseTypeDR=$Piece($Get(^DHCEQEquip(rowid)),"^",64)
	If TPurchaseTypeDR'="" Set TPurchaseType=$Piece($Get(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	Set TPurposeTypeDR=$Piece($Get(^DHCEQEquip(rowid)),"^",65)
	If TPurposeTypeDR'="" Set TPurposeType=$Piece($Get(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	Set TLocationDR=$Piece($Get(^DHCEQEquip(rowid)),"^",72)
	Set TGuaranteePeriodNum=$Piece($Get(^DHCEQEquip(rowid)),"^",73)
	
	Quit
SetVariablesGetEquipList
	s TQuantity = 1
	s TotalNum=TotalNum+TQuantity
	s TRowID = rowid
	//modified by zy 2014-01-07  zy0109 批量显示数据显示错误
	s EquipData=$g(^DHCEQEquip(rowid))
	;Modified by JDL 2012-3-1 JDL0118 优化速度
	s TName = $p(EquipData,"^",1)
	s TCommonName=TName  ///add by lmm 2017-06-28 394419
	s TABCType = $p(EquipData,"^",2)
	s TModelDR = $p(EquipData,"^",3)
	i TModelDR '=""  d
	.s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TEquiCatDR = $p(EquipData,"^",4)
	i TEquiCatDR '=""  d
	.s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCatDR)),"^",2)
	s TUnitDR = $p(EquipData,"^",5)
	i TUnitDR '=""  d
	.s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	;s TCode = $p(EquipData,"^",6)
	;s TDesc = $p(EquipData,"^",7)
	s TInstallLocDR = $p(EquipData,"^",8)
	i TInstallLocDR '=""  d
	.s TInstallLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TInstallLocDR)
	s TInstallDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",9),"date")
	s TLeaveFactoryNo = $p(EquipData,"^",10)
	s TLeaveFactoryDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",11),"date")
	s TOpenCheckDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",12),"date")
	s TCheckDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",13),"date")
	s TMakeDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",14),"date")
	s TComputerFlag = $p(EquipData,"^",15)
	s TCountryDR = $p(EquipData,"^",16)
	i TCountryDR '=""  d
	.s TCountry = ##class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
	s TManageLocDR = $p(EquipData,"^",17)
	i TManageLocDR '=""  d
	.s TManageLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	s TManageLevelDR = $p(EquipData,"^",18)
	i TManageLevelDR '=""  d
	.s TManageLevel = $p($g(^DHCEQCCode("DHCEQCManageLevel",TManageLevelDR)),"^",2)
	s TUseLocDR = $p(EquipData,"^",19)
	i TUseLocDR '=""  d
	.s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	s TOriginDR = $p(EquipData,"^",20)
	i TOriginDR '=""  d
	.s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	s TFromDeptDR = $p(EquipData,"^",21)
	i TFromDeptDR '=""  d
	.s TFromDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TFromDeptDR)),"^",2)
	s TToDeptDR = $p(EquipData,"^",22)
	i TToDeptDR '=""  d
	.s TToDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TToDeptDR)),"^",2)
	s TBuyTypeDR = $p(EquipData,"^",23)
	i TBuyTypeDR '=""  d
	.s TBuyType = $p($g(^DHCEQCCode("DHCEQCBuyType",TBuyTypeDR)),"^",2)
	s TEquipTechLevelDR = $p(EquipData,"^",24)
	i TEquipTechLevelDR '=""  d
	.s TEquipTechLevel = $p($g(^DHCEQCCode("DHCEQCTechLevel",TEquipTechLevelDR)),"^",2)
	s TProviderDR = $p(EquipData,"^",25)
	i TProviderDR '=""  d
	.s TProvider =##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TManuFactoryDR = $p(EquipData,"^",26)
	i TManuFactoryDR '=""  d
	.s TManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	s TOriginalFee = $p(EquipData,"^",27)
	s TotalFee=TotalFee+TOriginalFee
	
	s TTotalFundsFee=TTotalFundsFee+TFundsFee
	
	s TNetFee = $p(EquipData,"^",28)
	s TNetRemainFee = $p(EquipData,"^",29)
	s TGroupDR = $p(EquipData,"^",30)
	i TGroupDR '=""  d
	.s TGroup =$p($g(^DHCEQGroup(TGroupDR)),"^",2)
	s TLimitYearsNum = $p(EquipData,"^",31)
	s TContractListDR = $p(EquipData,"^",32)
	i TContractListDR '=""  d
	.s TContractList = $p($g(^DHCEQContractList(TContractListDR)),"^",1)
	s TDepreMethodDR = $p(EquipData,"^",33)
	i TDepreMethodDR '=""  d
	.s TDepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	s TRemark = $p(EquipData,"^",34)
	s TDepreTotalFee = ##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",35),"")
	/// 20150918  Mozy0166
	s TotalNetFee=TotalNetFee+TNetFee
	s TotalNetRemainFee=TotalNetRemainFee+TNetRemainFee
	s TotalDepreTotalFee=TotalDepreTotalFee+TDepreTotalFee
	s TDesignWorkLoadNum = $p(EquipData,"^",36)
	s TWorkLoadUnitDR = $p(EquipData,"^",37)
	i TWorkLoadUnitDR '=""  d
	.s TWorkLoadUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUnitDR)
	s TStatus = $p(EquipData,"^",38)  //modify by lmm 2018-09-14 684036
	s TDisplayStatus=..GetEquipStatusDisplay(TStatus)
	s TManageUserDR = $p(EquipData,"^",39)
	i TManageUserDR '=""  d
	.s TManageUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TManageUserDR)
	s TMaintUserDR = $p(EquipData,"^",40)
	i TMaintUserDR '=""  d
	.s TMaintUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUserDR)
	s TProviderHandler = $p(EquipData,"^",41)
	s TProviderTel = $p(EquipData,"^",42)	
	s TAppendFeeTotalFee = $p(EquipData,"^",43)
	s TStartDateFlag=$p(EquipData,"^",44)
	s TStartDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",44),"date")
	s TTransAssetDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",45),"date")
	s TGuaranteeFlag = $p(EquipData,"^",46)
	s TInputFlag = $p(EquipData,"^",47)
	s TTestFlag = $p(EquipData,"^",48)
	s TMedicalFlag = $p(EquipData,"^",49)
	s TGuaranteeStartDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",50),"date")
	s TGuaranteeEndDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",51),"date")
	s TAddUserDR = $p(EquipData,"^",52)
	i TAddUserDR '=""  d
	.s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	s TAddDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",53),"date")
	s TAddTime = $p(EquipData,"^",54)
	s TUpdateUserDR = $p(EquipData,"^",55)
	i TUpdateUserDR '=""  d
	.s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	s TUpdateDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",56),"date")
	s TUpdateTime = $p(EquipData,"^",57)
	s TCurrencyDR = $p(EquipData,"^",58)
	i TCurrencyDR '=""  d
	.s TCurrency = ##class(web.DHCEQCommon).GetTrakNameByID("cur",TCurrencyDR)
	s TInvalidFlag = $p(EquipData,"^",59)
	;s TStockStatus = $p(EquipData,"^",60)
	s TDisplayStockStatus=..GetEquipStockStatusDisplay(TStockStatus)
	;s TMemoryCode = $p(EquipData,"^",61)
	s TUrgencyFlag = $p(EquipData,"^",62)
	;s TEquipTypeDR = $p(EquipData,"^",63)
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TPurchaseTypeDR = $p(EquipData,"^",64)
	i TPurchaseTypeDR '=""  d
	.s TPurchaseType = $p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	s TPurposeTypeDR = $p(EquipData,"^",65)
	i TPurposeTypeDR '=""  d
	.s TPurposeType = $p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	s TKeeperDR = $p(EquipData,"^",66)
	i TKeeperDR '=""  d
	.s TKeeper = ##class(web.DHCEQCommon).GetTrakNameByID("user",TKeeperDR)
	s TStoreLocDR = $p(EquipData,"^",67)
	i TStoreLocDR '=""  d
	.s TStoreLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	s TStartDepreMonth = $p(EquipData,"^",68)
	s TServiceDR = $p(EquipData,"^",69)
	i TServiceDR '=""  d
	.s TService = $p($g(^DHCEQCCode("DHCEQCService",TServiceDR)),"^",1)
	s TInStockListDR = $p(EquipData,"^",70)
	i TTransAssetDate="" d //2009-09-19 党军 begin 无转资日期显示入库审核日期
	.i TInStockListDR '=""  d
	..s TInStockList = $p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	..s TTransAssetDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(TInStockList)),"^",13),"date") //2009-09-19 党军 end
	i TInStockListDR '=""  d
	.s TInStockList = $p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	.i TInStockList'="" s TInStockList = $p($g(^DHCEQInStock(TInStockList)),"^",14)
	.s TPayNo=##class(web.DHCEQPayRecord).GetPayNo("1",TInStockListDR) //2014-7-18 HZY0056
	s TNo = $p(EquipData,"^",71)
	s TLocationDR = $p(EquipData,"^",72)
	i TLocationDR'="" s TLocation=$p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)
	
	s TGuaranteePeriodNum = $p(EquipData,"^",73)
	s TStatCatDR=$p(EquipData,"^",75)
	i TStatCatDR'="" d
	.s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	s TContractNo = $p(EquipData,"^",76)
	//add by jdl 2010-8-24
	s TFileNo=$p(EquipData,"^",85)
	s TRentLocDR=$p(EquipData,"^",86)
	s TRentStatus=$p(EquipData,"^",87)
	s TFaultStatus=$p(EquipData,"^",88)
	s TDisuseDate=$p(EquipData,"^",89)
	i TDisuseDate'="" s TDisuseDate=##class(web.DHCEQCommon).TransValueToPage(TDisuseDate,"date")
	s TAccountNo=$p(EquipData,"^",90)
	s Thold6=$p(EquipData,"^",91) //2011-08-08 DJ begin
	s Thold7=$p(EquipData,"^",92)
	s Thold8=$p(EquipData,"^",93)
	s TBackColor=Thold8 //add by zx 2016-06-13 异常状态背景色处理
	//midified by zy 2015-7-1 ZY0134 
	s Thold8=##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus(Thold8)
	/// 20150918  Mozy0166
	s TAdvanceDisFlag=Thold8
	//s TUnusualRemark=$p(EquipData,"^",104)
	s TUnusualRemark=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",9)
	//end by zy 2015-7-1 ZY0134
	s Thold9=$p(EquipData,"^",94)
	i Thold9'="" s Thold9=$p($g(^DHCEQCCode("DHCEQCBrand",Thold9)),"^",3)
	s Thold10=$p(EquipData,"^",95) //2011-08-08 DJ end
	s TFundsInfo=..GetFundsInfo(TRowID) //2014-6-20 HZY0055 增加资金来源描述信息的显示
	;Mozy	2017-1-11	文本资料和电子资料标记
	s THasDoc=##Class(web.DHCEQDoc).HasDoc(TRowID)
	s THasFile=##Class(web.DHCEQDoc).HasFile(TRowID)
	;s TName=TOutDate
	//Add By DJ 2017-12-28
	s TReciveDate=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",8)
	i TReciveDate'="" s TReciveDate=##Class(web.DHCEQCommon).TransValueToPage(TReciveDate,"date")
	i $p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",24)'="" s TConfigFlag="Y"	; Mozy	763889	2018-12-6
	
	quit
OutputRowGetEquipList
	;TRowID,TName,TABCType,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TQuantity,TBatchFlag,TDisplayStatus,TDisplayStockStatus,TServiceHandler,TServiceTel,TStatCatDR,TStatCat,TModelDR,TEquiCatDR,TUnitDR,TCountryDR,TManageLocDR,TManageLevelDR,TWorkLoadUnitDR,TUseLocDR,TOriginDR,TFromDeptDR,TToDeptDR,TBuyTypeDR,TEquipTechLevelDR,TProviderDR,TManuFactoryDR,TKeeperDR,TEquipTypeDR,TPurchaseTypeDR,TPurposeTypeDR
	//格式化金额为小数点两位
	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
	i TNetFee'="" s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TNetFee,"")
	i TNetRemainFee'="" s TNetRemainFee=##Class(web.DHCEQCommon).FormatNumber(TNetRemainFee,"")
	i TFundsFee'="" s TFundsFee=##Class(web.DHCEQCommon).FormatNumber(TFundsFee,"")
	Set TRow=gnum	// 20150914  Mozy0165 序号
	Set Data=$lb(TRowID,TName,TABCType,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TQuantity,TBatchFlag,TDisplayStatus,TDisplayStockStatus,TLocation,TGuaranteePeriodNum,TStatCatDR,TStatCat,TFundsFee,TFileNo,TRentLocDR,TRentStatus,TFaultStatus,TDisuseDate,TAccountNo,Thold6,Thold7,Thold8,Thold9,Thold10,TAdvanceDisFlag,TInStockNo,TCommonName,TFundsInfo,TPayNo,TUnusualRemark,TRow,TContractNo,TBackColor,TStartDateFlag,THasDoc,THasFile,TReciveDate,TConfigFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	s ^DHCEQTemp("EquipList",curuser,gnum)=TName_"^"_TModel_"^"_TEquiCat_"^"_TUnit_"^"_TCode_"^"_TDesc_"^"_TInstallLoc_"^"_TInstallDate_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TCheckDate_"^"_TOpenCheckDate_"^"_TMakeDate_"^"_TCountry_"^"_TUseLoc_"^"_TOrigin_"^"_TFromDept_"^"_TToDept_"^"_TBuyType_"^"_TProvider_"^"_TManuFactory_"^"_TOriginalFee_"^"_TNetFee_"^"_TNetRemainFee_"^"_TLimitYearsNum_"^"_TContractList_"^"_TDepreMethod_"^"_TRemark_"^"_TDepreTotalFee_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnit_"^"_TManageUser_"^"_TMaintUser_"^"_TProviderHandler_"^"_TProviderTel_"^"_TAppendFeeTotalFee_"^"_TStartDate_"^"_TTransAssetDate_"^"_TGuaranteeFlag_"^"_TTestFlag_"^"_TMedicalFlag_"^"_TGuaranteeStartDate_"^"_TGuaranteeEndDate_"^"_TBatchFlag_"^"_TQuantity_"^"_TMemoryCode_"^"_TUrgencyFlag_"^"_TEquipType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TKeeper_"^"_TStoreLoc_"^"_TStartDepreMonth_"^"_TService_"^"_TInStockList_"^"_TNo_"^"_TDisplayStatus_"^"_TDisplayStockStatus_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TStoreLocDR_"^"_TStatCat_"^"_TFundsFee_"^"_TRowID_"^"_TFileNo_"^"_TRentLocDR_"^"_TRentStatus_"^"_TFaultStatus_"^"_TDisuseDate_"^"_TAccountNo_"^"_Thold6_"^"_Thold7_"^"_Thold8_"^"_Thold9_"^"_Thold10_"^"_TAdvanceDisFlag_"^"_TInStockNo_"^"_TCommonName_"^"_TFundsInfo_"^"_TPayNo_"^"_TUnusualRemark_"^"_TRow_"^"_TContractNo_"^"_THasDoc_"^"_THasFile_"^"_TReciveDate_"^"_TConfigFlag
	s gnum=gnum+1
	quit
}

ClassMethod GetEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipListExecute ]
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

ClassMethod GetEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetInStockDate(equipdr, isnum)
{
	s InDate=""
	i equipdr'=""  d
	.s instocklistdr=$p($g(^DHCEQEquip(equipdr)),"^",70)
	.s InDate=##Class(web.DHCEQInStockList).GetInStockDate(instocklistdr, isnum)
	.//add by jdl 2009-06-03 JDL0004  没有入库单,则取TransAssetDate
	.if InDate=""  d
	..s InDate=$p($g(^DHCEQEquip(equipdr)),"^",45)
	..//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	..i isnum'=1 s InDate=##class(web.DHCEQCommon).TransValueToPage(InDate,"date")
	q InDate
}

ClassMethod GetContractNo(equipdr)
{
	s contractno=""
	if equipdr'=""
	{
		s contractListDR=$p($g(^DHCEQEquip(equipdr)),"^",32)
		if (contractListDR'="")
		{
			s contractno=$p(^DHCEQContract($p(^DHCEQContractList(contractListDR),"^",1)),"^",2)
		}
		else
		{
			s contractno=$p($g(^DHCEQEquip(equipdr)),"^",76)		//Add By DJ 2021-06-16 DJ0194
		}
	}
	q contractno
}

ClassMethod GetInvoiceNo(equipdr, firstFlag As %Library.String = "1")
{
	s invoiceno=""
	if equipdr'=""
	{
		s instocklistdr=$p($g(^DHCEQEquip(equipdr)),"^",70)
		if (instocklistdr'="")
		{
			if (firstFlag="1")
			{
				s invoiceno=$p(##Class(web.DHCEQInvoice).GetInvoiceInfos(1,instocklistdr),"^",1)
			}
			else
			{
				s invoiceno=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,instocklistdr)
			}
		}
	}
	q invoiceno
}

/// 修改：zy 2009-07-16   zy0005
/// 描述：增加设备附件报表中显示的设备基本信息
/// 增加：设备出厂编号字段信息
ClassMethod GetOtherListInfo(equipdr)
{
	s result=""
	i equipdr="" q ""
	s firstFlag=0
	s listid=0
	f  s listid=$o(^DHCEQAffix(0,"Equip",equipdr,listid)) q:listid=""  d
	.q:$p(^DHCEQAffix(listid),"^",15)'="N"
	.i $p(^DHCEQAffix(listid),"^",2)'=""  d
	..s listname=$p($g(^DHCEQCCode("DHCEQCAffix",$p(^DHCEQAffix(listid),"^",2))),"^",2)
	.e  d
	..s listname=$p(^DHCEQAffix(listid),"^",4)
	.i firstFlag=0  d
	..s firstFlag=1
	.e  d
	..s result=result_"&"
	.;Modified by zy  2009-7-16  zy0005
	.s result=result_listname_"^"_$p(^DHCEQAffix(listid),"^",5)_"^"_$p(^DHCEQAffix(listid),"^",7)_"^"_$p(^DHCEQAffix(listid),"^",11)_"^"_$p(^DHCEQAffix(listid),"^",9)
	
	s result=result_"@"
	s firstFlag=0
	s listid=0
	f  s listid=$o(^DHCEQDoc(0,"Equip",equipdr,listid)) q:listid=""  d
	.s listname=$p($g(^DHCEQDoc(listid)),"^",2)
	.i firstFlag=0  d
	..s firstFlag=1
	.e  d
	..s result=result_"&"
	.s result=result_listname	
	q result
}

/// 修改:ZY 2009-11-12  zy0016
/// 描述:机型和生产厂家的rowid在js中进行处理;当InStockListDR为空时不能修改
/// 输入：val：列表信息，字符串格式为EquipID1=No1^EquipID2=No2^.....^EquipIDn=Non
/// -------------------------------
/// Add By DJ 2009-05-20 DJ0003
/// 同批入库设备基本信息批量修改
ClassMethod BatchUpdate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	 k PLIST, Flag, InstockListDR
	 /************************************************/
	 s Flag=isDel //更新范围,1:全部,0部分
	 if ##class(web.DHCEQCommon).ExistsElement(val,"Name")=1
	 { s PLIST(2) =##class(web.DHCEQCommon).GetDataByName(val,"Name") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"ABCType")=1
	 { s PLIST(3) =##class(web.DHCEQCommon).GetDataByName(val,"ABCType") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"ModelDR")=1
	 {	s PLIST(4) =##class(web.DHCEQCommon).GetDataByName(val,"ModelDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"EquiCatDR")=1
	 { s PLIST(5) =##class(web.DHCEQCommon).GetDataByName(val,"EquiCatDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"UnitDR")=1
	 { s PLIST(6) =##class(web.DHCEQCommon).GetDataByName(val,"UnitDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"Code")=1
	 { s PLIST(7) =##class(web.DHCEQCommon).GetDataByName(val,"Code") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"LeaveFactoryDate")=1
	 { 
	  if ##class(web.DHCEQCommon).GetDataByName(val,"LeaveFactoryDate")'=""
	  {
	   s PLIST(12) =##class(web.DHCEQCommon).TransValueFromPage(##class(web.DHCEQCommon).GetDataByName(val,"LeaveFactoryDate"),"date")
	  }
	 }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"CountryDR")=1
	 { s PLIST(17) =##class(web.DHCEQCommon).GetDataByName(val,"CountryDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"OriginDR")=1
	 { s PLIST(21) =##class(web.DHCEQCommon).GetDataByName(val,"OriginDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"FromDeptDR")=1
	 { s PLIST(22) =##class(web.DHCEQCommon).GetDataByName(val,"FromDeptDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"BuyTypeDR")=1
	 { s PLIST(24) =##class(web.DHCEQCommon).GetDataByName(val,"BuyTypeDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"ProviderDR")=1 //2011-11-39 DJ
	 { s PLIST(26) =##class(web.DHCEQCommon).GetDataByName(val,"ProviderDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"ManuFactoryDR")=1
	 { s PLIST(27) =##class(web.DHCEQCommon).GetDataByName(val,"ManuFactoryDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"LimitYearsNum")=1
	 { s PLIST(32) =##class(web.DHCEQCommon).GetDataByName(val,"LimitYearsNum") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"DepreMethodDR")=1
	 { s PLIST(34) =##class(web.DHCEQCommon).GetDataByName(val,"DepreMethodDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"DepreTotalFee")=1
	 { s PLIST(36) =##class(web.DHCEQCommon).GetDataByName(val,"DepreTotalFee") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"DesignWorkLoadNum")=1
	 { s PLIST(37) =##class(web.DHCEQCommon).GetDataByName(val,"DesignWorkLoadNum") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"WorkLoadUnitDR")=1
	 { s PLIST(38) =##class(web.DHCEQCommon).GetDataByName(val,"WorkLoadUnitDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"MemoryCode")=1
	 { s PLIST(62) =##class(web.DHCEQCommon).GetDataByName(val,"MemoryCode") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"EquipTypeDR")=1
	 { s PLIST(64) =##class(web.DHCEQCommon).GetDataByName(val,"EquipTypeDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"PurchaseTypeDR")=1
	 { s PLIST(65) =##class(web.DHCEQCommon).GetDataByName(val,"PurchaseTypeDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"PurposeTypeDR")=1
	 { s PLIST(66) =##class(web.DHCEQCommon).GetDataByName(val,"PurposeTypeDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"ServiceDR")=1
	 { s PLIST(70) =##class(web.DHCEQCommon).GetDataByName(val,"ServiceDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"GuaranteePeriodNum")=1
	 { s PLIST(74) =##class(web.DHCEQCommon).GetDataByName(val,"GuaranteePeriodNum") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"StatCatDR")=1
	 { s PLIST(76) =##class(web.DHCEQCommon).GetDataByName(val,"StatCatDR") }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"InStockListDR")=1
	 { s InstockListDR =##class(web.DHCEQCommon).GetDataByName(val,"InStockListDR")}
	 
	 if (InstockListDR="") q 100
	 
	 /***********************************************/ //2009-08-17 党军 begin
	 if ##class(web.DHCEQCommon).ExistsElement(val,"ComputerFlag")=1
	 {
		 if ##class(web.DHCEQCommon).GetDataByName(val,"ComputerFlag")'=""
		 {
			 s PLIST(16) =##class(web.DHCEQCommon).TransValueFromPage(##class(web.DHCEQCommon).GetDataByName(val,"ComputerFlag"),"bool")
		 }
	 }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"GuaranteeFlag")=1
	 {
		 if ##class(web.DHCEQCommon).GetDataByName(val,"GuaranteeFlag")'=""
		 {
			 s PLIST(47) =##class(web.DHCEQCommon).TransValueFromPage(##class(web.DHCEQCommon).GetDataByName(val,"GuaranteeFlag"),"bool")
		 }
	 }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"ItemDR")=1
	 {	s PLIST(8) =##class(web.DHCEQCommon).GetDataByName(val,"ItemDR")}
	 if ##class(web.DHCEQCommon).ExistsElement(val,"KeeperDR")=1
	 {	s PLIST(67) =##class(web.DHCEQCommon).GetDataByName(val,"KeeperDR")}
	 if ##class(web.DHCEQCommon).ExistsElement(val,"MaintUserDR")=1
	 {	s PLIST(40) =##class(web.DHCEQCommon).GetDataByName(val,"MaintUserDR")}
	 if ##class(web.DHCEQCommon).ExistsElement(val,"NetRemainFee")=1
	 {	s PLIST(30) =##class(web.DHCEQCommon).GetDataByName(val,"NetRemainFee")}
	 if ##class(web.DHCEQCommon).ExistsElement(val,"OpenCheckDate")=1
	 {
		 if ##class(web.DHCEQCommon).GetDataByName(val,"OpenCheckDate")'=""
		 {
			 s PLIST(13) =##class(web.DHCEQCommon).TransValueFromPage(##class(web.DHCEQCommon).GetDataByName(val,"OpenCheckDate"),"date")
		 }
	 }
	 if ##class(web.DHCEQCommon).ExistsElement(val,"ProviderHandler")=1
	 {	s PLIST(42) =##class(web.DHCEQCommon).GetDataByName(val,"ProviderHandler")}
	 if ##class(web.DHCEQCommon).ExistsElement(val,"ProviderTel")=1
	 {	s PLIST(43) =##class(web.DHCEQCommon).GetDataByName(val,"ProviderTel")}
	 if ##class(web.DHCEQCommon).ExistsElement(val,"LocationDR")=1
	 {	s PLIST(73) =##class(web.DHCEQCommon).GetDataByName(val,"LocationDR")}
	 if ##class(web.DHCEQCommon).ExistsElement(val,"StartDepreMonth")=1
	 {	s PLIST(69) =##class(web.DHCEQCommon).GetDataByName(val,"StartDepreMonth")}
	 /***********************************************/ //2009-08-17 党军 end
	 Set $ZT="ERROR" //2009-08-10 党军
	 TSTART //2009-08-10 党军
	 i (Flag=1) //更新全部
	 {
	  &SQL(Update SQLUSER.DHC_EQEquip Values :PLIST() where EQ_InStockListDR = :InstockListDR)
	  s Flag="All"
	 }
	 else //更新部分
	 {
	  
	 }
	 if SQLCODE
	 {
		 TROLLBACK //2009-08-10 党军
		 q SQLCODE
	 }
	 TCOMMIT //2009-08-10 党军
	 q Flag
ERROR //2009-08-10 党军 begin
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
	TROLLBACK		       //回滚事务
	Quit "<ERROR>"_ErrorMsg     //返回错误消息 ; //2009-08-10 党军 end
}

/// add by jdl 2009-05-27 JDL0017
/// 根据转移单明细获取设备列表信息
/// SourceType：类型 0:转移单明细  1:入库单明细		SourceID:对应的明细id
Query GetEquipsByMove(SourceType As %String, SourceID As %String) As %Query(ROWSPEC = "TRowID:%String,TEquipNo:%String,TLeaveFactoryNo:%String,TSortNo:%String")
{
}

ClassMethod GetEquipsByMoveExecute(ByRef qHandle As %Binary, SourceType As %String, SourceID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s SortNo=0
 	s rowid=0
 	s name=$ZCONVERT(name,"U")
 	k ^TempDHCEQ("GetEquipsByMove",$j)
 	if SourceType="0"
 	{
	 	if SourceID'=""
	 	{
		 	s EquipDR=$p($g(^DHCEQStoreMoveList(SourceID)),"^",2)
		 	i EquipDR'=""  d
		 	.s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
		 	.s LeavefactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
		 	.s SortNo=1
		 	.d OutputRowGetEquipsByMove
		 	e  d
		 	.f  s rowid=$o(^DHCEQChangeStock(0,"Source",1,SourceID,rowid)) q:rowid=""  d
		 	..s EquipDR=$p($g(^DHCEQChangeStock(rowid)),"^",1)
		 	..s (EquipNo,LeavefactoryNo)=""
		 	..i EquipDR'=""  d
		 	...s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
		 	...s LeavefactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
		 	...s SortNo=SortNo+1
		 	...d OutputRowGetEquipsByMove
		}
	 	
	}
	elseif SourceType="1"
 	{
	 	if SourceID'=""
	 	{
		 	s iSourceType=$p($g(^DHCEQInStockList(SourceID)),"^",18)
		 	s iSourceID=$p($g(^DHCEQInStockList(SourceID)),"^",19)
		 	i (iSourceType="2")  d
		 	.f  s rowid=$o(^DHCEQEquip(0,"OpenCheckList",iSourceID,rowid)) q:rowid=""  d
		 	..s EquipDR=rowid
		 	..s (EquipNo,LeavefactoryNo)=""
		 	..i EquipDR'=""  d
		 	...s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
		 	...s LeavefactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
		 	...s SortNo=SortNo+1
		 	...d OutputRowGetEquipsByMove
		 	e  d
		 	.f  s rowid=$o(^DHCEQChangeStock(0,"Source",0,SourceID,rowid)) q:rowid=""  d
		 	..s EquipDR=$p($g(^DHCEQChangeStock(rowid)),"^",1)
		 	..s (EquipNo,LeavefactoryNo)=""
		 	..i EquipDR'=""  d
		 	...s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
		 	...s LeavefactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
		 	...s SortNo=SortNo+1
		 	...d OutputRowGetEquipsByMove
		}
	 	
	}
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowGetEquipsByMove	
	set Data=$lb(EquipDR,EquipNo,LeavefactoryNo,SortNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetEquipsByMoveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipsByMoveExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod GetEquipsByMoveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipsByMoveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by jdl 2009-05-27	JDL0017
/// 根据列表更新设备的信息
/// w ##Class(web.DHCEQEquip).UpdateEquipsByList("1^no1&2^no2&3^no3")
ClassMethod UpdateEquipsByList(val)
{
	new i,count,equipinfo,errs
	if val="" q "没有要更新的设备信息!"
	s i=1
	s count=$l(val,"&")
	s errs=""
	TStart
	
	while((i'>count)&&(errs=""))
	{
		//if errs'="" break		
		s equipinfo=$p(val,"&",i)
		s i=i+1
		s id=$p(equipinfo,"^",1)
		if id="" break		
		s leavefactoryno=$p(equipinfo,"^",2)
		&SQL(Update SQLUSER.DHC_EQEquip set EQ_LeaveFactoryNo=:leavefactoryno where EQ_RowID=:id)
		if SQLCODE 
		{
			s errs="更新设备信息失败!   SQLCODE="_SQLCODE
			TRollBack
		}
	}
	TCommit
	q errs
}

/// add by jdl 2009-09-11	JDL0027
/// 获取调账金额
/// w ##Class(web.DHCEQEquip).GetChangedAmount(equipdr)
ClassMethod GetChangedAmount(EquipDR)
{
	new Amount,rowid
	s Amount=0
	s rowid=0
	f  s rowid=$o(^DHCEQChangeAccount(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQChangeAccount(rowid)),"^",11)'=2  ;Status状态为审核的记录
	.s Amount=Amount+$p($g(^DHCEQChangeAccount(rowid)),"^",2)
	
	q Amount
}

/// add by jdl 2009-09-11	JDL0027
/// 判断设备是否有已核实调账记录
/// 返回值：0无记录  1有记录
/// w ##Class(web.DHCEQEquip).HasChangeAccount(equipdr)
ClassMethod HasChangeAccount(EquipDR)
{
	new Result,rowid
	s Result=0
	s rowid=0
	f  s rowid=$o(^DHCEQChangeAccount(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQChangeAccount(rowid)),"^",11)'=2  ;Status状态为审核的记录
	.s Result=1
	
	q Result
}

/// add by jdl 2009-09-11	JDL0027
/// 判断设备是否有已附件记录
/// 返回值：0无记录  1有记录
/// w ##Class(web.DHCEQEquip).HasAffix(equipdr)
ClassMethod HasAffix(EquipDR)
{
	new Result,rowid
	s Result=0
	s rowid=0
	f  s rowid=$o(^DHCEQAffix(0,"Equip",EquipDR,rowid)) q:rowid=""  d
	.q:$p($g(^DHCEQAffix(rowid)),"^",15)'="N"
	.s Result=1	
	q Result
}

/// add by jdl 2010-02-24
/// 获取其他应用程序需要的设备信息，根据对照表中定义的对照信息来调整设备的信息
/// 返回值：与应用程序相匹配的设备信息
/// w ##Class(web.DHCEQEquip).GetEquipToApp(rowid,appName)
ClassMethod GetEquipToApp(rowid As %Library.String = "", appName)
{
	new result,resultex,i,count,EquipTechLevel,tmp
	s EquipTechLevel=""
	s (result,resultex)=""
	s result= ^DHCEQEquip(rowid)
	set count=..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}
	s resultex=resultex_"^"	;ModelDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;EquiCatDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(result,"^",4))),"^",2)
	s resultex=resultex_"^"	;UnitDR
	i $p(result,"^",5)'=""  d
	.s tmp=##class(web.DHCEQCommon).GetContrastInfo(appName,"uom",$p(result,"^",5),2)
	.i tmp=$c(0)  d
	..s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",5))
	.e  d
	..s resultex=resultex_tmp
	s resultex=resultex_"^"	;InstallLocDR
	i $p(result,"^",8)'=""  d
	.s tmp=##class(web.DHCEQCommon).GetContrastInfo(appName,"dept",$p(result,"^",8),2)
	.i tmp=$c(0)  d
	..s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",8))
	.e  d
	..s resultex=resultex_tmp
	s $p(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;InstallDate	
	s $p(result,"^",11)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;LeaveFactoryDate
	s $p(result,"^",12)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")	;OpenCheckDate
	s $p(result,"^",13)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"date")	;CheckDate
	s $p(result,"^",14)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",14),"date")	;MakeDate
	s $p(result,"^",15)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",15),"bool")	;ComputerFlag
	s resultex=resultex_"^"	;CountryDR
	i $p(result,"^",16)'=""  d
	.s tmp=##class(web.DHCEQCommon).GetContrastInfo(appName,"cou",$p(result,"^",16),2)
	.i tmp=$c(0)  d
	..s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("cou",$p(result,"^",16))
	.e  d
	..s resultex=resultex_tmp
	s resultex=resultex_"^"	;ManageLocDR
	i $p(result,"^",17)'=""  d
	.s tmp=##class(web.DHCEQCommon).GetContrastInfo(appName,"dept",$p(result,"^",17),2)
	.i tmp=$c(0)  d
	..s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",17))
	.e  d
	..s resultex=resultex_tmp
	s resultex=resultex_"^"	;ManageLevelDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManageLevel",$p(result,"^",18))),"^",2)
	s resultex=resultex_"^"	;UseLocDR
	i $p(result,"^",19)'=""  d
	.s tmp=##class(web.DHCEQCommon).GetContrastInfo(appName,"dept",$p(result,"^",19),2)
	.i tmp=$c(0)  d
	..s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",19))
	.e  d
	..s resultex=resultex_tmp
	s resultex=resultex_"^"	;OriginDR
	i $p(result,"^",20)'=""  d
	.s tmp=##class(web.DHCEQCommon).GetContrastInfo(appName,"orign",$p(result,"^",20),2)
	.i tmp=$c(0)  d
	..s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCOrigin",$p(result,"^",20))),"^",2)
	.e  d
	..s resultex=resultex_tmp
	s resultex=resultex_"^"	;FromDeptDR
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",21))),"^",2)
	s resultex=resultex_"^"	;ToDeptDR
	i $p(result,"^",22)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",22))),"^",2)
	s resultex=resultex_"^"	;BuyTypeDR
	i $p(result,"^",23)'=""  d
	.s tmp=##class(web.DHCEQCommon).GetContrastInfo(appName,"buytype",$p(result,"^",23),2)
	.i tmp=$c(0)  d
	..s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBuyType",$p(result,"^",23))),"^",2)
	.e  d
	..s resultex=resultex_tmp
	s resultex=resultex_"^"	;ProviderDR
	i $p(result,"^",25)'=""  d
	.s tmp=##class(web.DHCEQCommon).GetContrastInfo(appName,"prov",$p(result,"^",25),2)
	.i tmp=$c(0)  d
	..s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",25))
	.e  d
	..s resultex=resultex_tmp
	s resultex=resultex_"^"	;ManuFactoryDR
	i $p(result,"^",26)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(result,"^",26))),"^",1)
	s resultex=resultex_"^"	;GroupDR
	i $p(result,"^",30)'=""  d
	.s resultex=resultex_$p($g(^DHCEQGroup($p(result,"^",30))),"^",2)
	s resultex=resultex_"^"	;ContractListDR
	i $p(result,"^",32)'=""  d
	.s contractdr=$p($g(^DHCEQContractList($p(result,"^",32))),"^",1)	
	.s resultex=resultex_$p($g(^DHCEQContract(contractdr)),"^",1)
	.//s resultex=resultex_$p($g(^DHCEQContractList($p(result,"^",32))),"^",2)
	s resultex=resultex_"^"	;DepreMethodDR
	i $p(result,"^",33)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDepreMethod",$p(result,"^",33))),"^",2)
	s resultex=resultex_"^"	;WorkLoadUnitDR
	i $p(result,"^",37)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",37))
	s resultex=resultex_"^"	;ManageUserDR
	i $p(result,"^",39)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",39))
	s resultex=resultex_"^"	;MaintUserDR
	i $p(result,"^",40)'=""  d
	.s tmp=##class(web.DHCEQCommon).GetContrastInfo(appName,"user",$p(result,"^",40),2)
	.i tmp=$c(0)  d
	..s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",40))
	.e  d
	..s resultex=resultex_tmp
	s $p(result,"^",44)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",44),"date")	;StartDate
	i $p(result,"^",45)'="" d //2009-09-19 党军 begin
	.s $p(result,"^",45)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",45),"date")	;TransAssetDate
	e  d
	.i $p(result,"^",70)'="" d
	..s ISRowID=$p($g(^DHCEQInStockList($p(result,"^",70))),"^",1)
	..s $p(result,"^",45)=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(ISRowID)),"^",13),"date") //2009-09-19 党军 end
	s $p(result,"^",46)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",46),"bool")	;GuaranteeFlag
	s $p(result,"^",47)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",47),"bool")	;InputFlag
	s $p(result,"^",48)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",48),"bool")	;TestFlag
	s $p(result,"^",49)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",49),"bool")	;MedicalFlag
	s $p(result,"^",50)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",50),"date")	;GuaranteeStartDate
	s $p(result,"^",51)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",51),"date")	;GuaranteeEndDate
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",52)'=""  d
	.s tmp=##class(web.DHCEQCommon).GetContrastInfo(appName,"user",$p(result,"^",52),2)
	.i tmp=$c(0)  d
	..s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",52))
	.e  d
	..s resultex=resultex_tmp
	s $p(result,"^",53)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",53),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",55)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",55))
	s $p(result,"^",56)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",56),"date")	;UpdateDate
	///
	s $p(result,"^",62)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",62),"bool")	;UrgencyFlag
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",63)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",63))),"^",2)
	s resultex=resultex_"^"	;PurchaseTypeDR
	i $p(result,"^",64)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurchaseType",$p(result,"^",64))),"^",2)
	s resultex=resultex_"^"	;PurposeTypeDR
	i $p(result,"^",65)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurposeType",$p(result,"^",65))),"^",2)
	s resultex=resultex_"^"	;KeeperDR
	i $p(result,"^",66)'=""  d
	.s tmp=##class(web.DHCEQCommon).GetContrastInfo(appName,"user",$p(result,"^",66),2)
	.i tmp=$c(0)  d
	..s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",66))
	.e  d
	..s resultex=resultex_tmp
	s resultex=resultex_"^"	;StoreLocDR
	i $p(result,"^",67)'=""  d
	.s tmp=##class(web.DHCEQCommon).GetContrastInfo(appName,"dept",$p(result,"^",67),2)
	.i tmp=$c(0)  d
	..s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",67))
	.e  d
	..s resultex=resultex_tmp
	s resultex=resultex_"^"	;ServiceDR
	i $p(result,"^",69)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",$p(result,"^",69))),"^",1)
	s resultex=resultex_"^"	;InStockListDR
	i $p(result,"^",70)'=""  d
	.s resultex=resultex_$p($g(^DHCEQInStockList($p(result,"^",70))),"^",1)
	
	///////
	//状态
	s resultex=resultex_"^"_##class(web.DHCEQCommon).GetEquipStatusDisplay($p(result,"^",38))
	//加
	s resultex=resultex_"^"
	i $p(result,"^",24)'=""  d 
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCTechLevel",$p(result,"^",24))),"^",2)
	s resultex=resultex_"^"	;StatCatDR
	i $p(result,"^",75)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p(result,"^",75))),"^",2)
	s resultex=resultex_"^"_##class(web.DHCEQEquip).GetInStockDate(rowid,0)
		
	s resultex=resultex_"^"	;EquipeCatCode
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(result,"^",4))),"^",1)
	s resultex=resultex_"^"	;EXCode
	i $p(result,"^",4)'=""  d
	.s tmp=$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(result,"^",4))),"^",11)
	.s tmp=##class(web.DHCEQCommon).Replace(tmp,"-","")
	.s resultex=resultex_tmp
	///新增:2009-12-02 党军 begin DJ0035
	s $p(result,"^",80)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",80),"bool")		//Add By DJ 2017-01-20
	s $p(result,"^",81)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",81),"bool")
	s $p(result,"^",82)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",82),"bool")
	s $p(result,"^",83)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",83),"bool")
	///2009-12-02 党军 end DJ0035
	
	
	//add by jdl 2009-9-25  JDL0036
	//格式化金额为小数点两位
	i $p(result,"^",27)'="" s $p(result,"^",27)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",27),"")	;OriginalFee
	i $p(result,"^",28)'="" s $p(result,"^",28)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",28),"")	;NetFee
	i $p(result,"^",29)'="" s $p(result,"^",29)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",29),"")	;NetRemainFee
	i $p(result,"^",35)'="" s $p(result,"^",35)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",35),"")	;DepreTotalFee
	
	
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

ClassMethod GetGlobalLen()
{
	q ..#GlobalLen
}

/// 将台帐查询中的查询结果,按科室汇总整理,
/// 现主要用于按使用科室批量打印条码
/// modified by csj 2020-07-27 添加SortType排序参数
/// SortType 1:按科室排序后的顺序位置 2、根据设备名称、编号排序后的顺序位置 3、按科室排序、设备名称、设备编号排序后的顺序
/// modified by csj 2020-03-01 添加Job参数
ClassMethod LocPrintEquip(Job, SortType As %String = "3")
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k ^DHCEQTemp("LocPrintEquipTemp",curuser)
	k ^DHCEQTemp("LocPrintEquip",curuser)
	if SortType="1"
	{
		s rowid=0
		f  s rowid=$o(^DHCEQTemp("EquipList",+$h,Job,curuser,rowid)) q:rowid=""  d		//modified by czf 2020-05-09
		.s EQRowID=$p($g(^DHCEQTemp("EquipList",+$h,Job,curuser,rowid)),"^",64)
		.q:EQRowID<1
		.s Name=$p($g(^DHCEQEquip(EQRowID)),"^",1)
		.s EquipNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
		.s LocDR=$p($g(^DHCEQEquip(EQRowID)),"^",67)
		.s DeptCode=""	
		.i LocDR'="" s DeptCode=$p(^DHCEQCCode("DHCEQCDepartment",LocDR),"^",1)
		.i DeptCode="" s DeptCode=0
		.i LocDR="" s LocDR=0
		.s ^DHCEQTemp("LocPrintEquipTemp",curuser,DeptCode,rowid)=EQRowID_"^"_EquipNo_"^"_Name
		
		s DeptCode=""
		s Count=1
		f  s DeptCode=$o(^DHCEQTemp("LocPrintEquipTemp",curuser,DeptCode))  q:DeptCode=""  d
		.s rowid=0
		.f  s rowid=$o(^DHCEQTemp("LocPrintEquipTemp",curuser,DeptCode,rowid))  q:rowid=""  d
		..s ^DHCEQTemp("LocPrintEquip",curuser,Count)=$g(^DHCEQTemp("LocPrintEquipTemp",curuser,DeptCode,rowid))
		..s Count=Count+1
	}
	elseif SortType="2"{
		s rowid=0
		f  s rowid=$o(^DHCEQTemp("EquipList",+$h,Job,curuser,rowid)) q:rowid=""  d	
		.s EQRowID=$p($g(^DHCEQTemp("EquipList",+$h,Job,curuser,rowid)),"^",64)
		.q:EQRowID<1
		.s Name=$p($g(^DHCEQEquip(EQRowID)),"^",1)
		.s EquipNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
		.s ^DHCEQTemp("LocPrintEquipTemp",curuser,Name,EquipNo,rowid)=EQRowID_"^"_EquipNo_"^"_Name
		
		s Name=""
		s Count=1
		f  s Name=$o(^DHCEQTemp("LocPrintEquipTemp",curuser,Name))  q:Name=""  d
		.s EquipNo=""
		.f  s EquipNo=$o(^DHCEQTemp("LocPrintEquipTemp",curuser,Name,EquipNo))  q:EquipNo=""  d
		..s rowid=0
		..f  s rowid=$o(^DHCEQTemp("LocPrintEquipTemp",curuser,Name,EquipNo,rowid))  q:rowid=""  d
		...s ^DHCEQTemp("LocPrintEquip",curuser,Count)=$g(^DHCEQTemp("LocPrintEquipTemp",curuser,Name,EquipNo,rowid))
		...s Count=Count+1
	}
	elseif SortType="3"{
		s rowid=0
		f  s rowid=$o(^DHCEQTemp("EquipList",+$h,Job,curuser,rowid)) q:rowid=""  d	
		.s EQRowID=$p($g(^DHCEQTemp("EquipList",+$h,Job,curuser,rowid)),"^",64)
		.q:EQRowID<1
		.s Name=$p($g(^DHCEQEquip(EQRowID)),"^",1)
		.s EquipNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
		.s LocDR=$p($g(^DHCEQEquip(EQRowID)),"^",67)
		.s DeptCode=""
		.i LocDR'="" s DeptCode=$p(^DHCEQCCode("DHCEQCDepartment",LocDR),"^",1)
		.i DeptCode="" s DeptCode=0
		.i LocDR="" s LocDR=0
		.s ^DHCEQTemp("LocPrintEquipTemp",curuser,DeptCode,Name,EquipNo,rowid)=EQRowID_"^"_EquipNo_"^"_Name
		
		s DeptCode=""
		s Count=1
		f  s DeptCode=$o(^DHCEQTemp("LocPrintEquipTemp",curuser,DeptCode))  q:DeptCode=""  d
		.s Name="" 
		.f  s Name=$o(^DHCEQTemp("LocPrintEquipTemp",curuser,DeptCode,Name))  q:Name=""  d
		..s EquipNo=""
		..f  s EquipNo=$o(^DHCEQTemp("LocPrintEquipTemp",curuser,DeptCode,Name,EquipNo))  q:EquipNo=""  d
		...s rowid=0
		...f  s rowid=$o(^DHCEQTemp("LocPrintEquipTemp",curuser,DeptCode,Name,EquipNo,rowid))  q:rowid=""  d
		....s ^DHCEQTemp("LocPrintEquip",curuser,Count)=$g(^DHCEQTemp("LocPrintEquipTemp",curuser,DeptCode,Name,EquipNo,rowid))
		....s Count=Count+1
	}
	q 1
}

ClassMethod GetLocPrintList(gnum)
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s str=$g(^DHCEQTemp("LocPrintEquip",curuser,gnum))
  	q str
}

ClassMethod GetRowIDByNo(No)
{
	i No="" q ""
	s ID=$o(^DHCEQEquip(0,"No",No,0))
	q ID
}

/// 用于获取检索台帐后,该编号设备所在位置
/// Type: 0:根据台帐检索顺序  1:按科室排序后的顺序位置
ClassMethod GetNextNum(Type, ID, Ejob)
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s BeginNum=1
	;
	if Type=0  d
	.s Num=0
	.f  s Num=$o(^DHCEQTemp("EquipList",+$h,Ejob,curuser,Num)) q:((Num="")||(BeginNum'=1))  d		//modified by czf 2020-05-09
	..s EquipID=$p(^DHCEQTemp("EquipList",+$h,Ejob,curuser,Num),"^",64)
	..i EquipID=ID s BeginNum=Num
	e  d
	.s Num=0
	.f  s Num=$o(^DHCEQTemp("LocPrintEquip",curuser,Num)) q:((Num="")||(BeginNum'=1))  d
	..s EquipID=$p(^DHCEQTemp("LocPrintEquip",curuser,Num),"^",1)
	..i EquipID=ID s BeginNum=Num
	q BeginNum
}

/*
ClassMethod GetParTreeChild(ParTreeDR)
{
	n ParTreeID,TreeID,UseLocDR
	s ParTreeID=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID",1,ParTreeDR,0))
	i ParTreeID="" q 0
	s TreeID=0
	f  s TreeID=$o(^DHCEQCCode("DHCEQCTreeMap",0,"ParTreeID",ParTreeID,TreeID)) q:TreeID=""  d
	.s UseLocDR=$p($g(^DHCEQCCode("DHCEQCTreeMap",TreeID)),"^",3)
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquip(0,"UseLoc",UseLocDR,rowid))  quit:rowid=""  d
	..d FillOneDataGetEquipList
	.d ..GetParTreeChild(UseLocDR)
}
*/
/// Add by jdl 2010-11-22
/// 检测ChildLoc是否是ParLoc的后代。
/// TreeType：树类型
/// 返回值：0不是，1是
ClassMethod CheckIsChildLoc(ParLoc, ChildLoc, TreeType)
{
	
	n ParTreeID,rowid,IsChildFlag
	s IsChildFlag=0
	i ParLoc=ChildLoc q 1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID",TreeType,ChildLoc,rowid)) q:(rowid="")||(IsChildFlag=1)  d
	.s ParTreeID=$p($g(^DHCEQCCode("DHCEQCTreeMap",rowid)),"^",4)
	.q:(ParTreeID=0)
	.i ParTreeID'=""  s ParTreeID=$p($g(^DHCEQCCode("DHCEQCTreeMap",ParTreeID)),"^",3)
	.if ParTreeID=ParLoc s IsChildFlag=1
	.q:(IsChildFlag=1)||(ParTreeID=0)
	.s IsChildFlag=..CheckIsChildLoc(ParLoc,ParTreeID,TreeType)
	
	q IsChildFlag
}

/// midified by zy 2015-7-1 ZY0134 
/// ----------------------------------
/// 创建：zy 2011-02-22  No ZY0061
/// 描述：预报废
/// ----------------------------------
ClassMethod GetPreDisuseFlag(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=1>"_##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus(1)_"</option>"
	w "<option value=2>"_##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus(2)_"</option>"
	w "<option value=3>"_##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus(3)_"</option>"
	w "<option value=4>"_##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus(4)_"</option>"
	w "</select>",!
}

/// Modified By JDL 2011-3-11
/// 判断设备的有效性
/// 入参：	EquipID 设备ID
/// 			GroupID 安全组ID,传递为空时,不判断安全组访问类组,否则需要判读该安全组是否可访问该类组设备
/// 			ExclusiveFlag 排他标志  N不排他  Y排他,当为排他时 需要传递SourceType,SourceID
/// 			SourceType:业务类型,1转移 2退货减少 3报废	当为排他时，需要传递.
/// 			SourceID:业务ID
/// 返回值：0 无效		1 有效
ClassMethod CheckEquipValid(EquipID, GroupID As %Library.String = "", ExclusiveFlag As %Library.String = "N", SourceType As %Library.String = "", SourceID As %Library.String = "")
{
	n EquipType,Status,UsedFlag
	
	;报废状态的过滤
	i (+$p(^DHCEQEquip(EquipID),"^",38))>2 q 0
	;已经退货或减少的，出库状态置为无效
	i +$p(^DHCEQEquip(EquipID),"^",60)="3" q 0
	;尚未入库的为无效
	i +$p(^DHCEQEquip(EquipID),"^",60)="0" q 0
	;过滤掉无效的
	i $p(^DHCEQEquip(EquipID),"^",59)="Y" q 0
	
	;以下是根据参数来确定是否有效的设备
	;过滤掉类组
	s EquipType=$p(^DHCEQEquip(EquipID),"^",63)
	if GroupID'=""
	{		
		i '$d(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",GroupID,EquipType)) q 0
	}
	;如果排他,需要检测以下单据中是否已经占用该设备
	if ExclusiveFlag="Y"
	{		
		s UsedFlag="N"
		
		;检查转移单中是否已经占用该设备
		s Status=""
		f  s Status=$o(^DHCEQStoreMove(0,"StatusFromLoc",Status)) q:(Status="")||(UsedFlag="Y")  d
		.q:Status=2
		.s Node=0
		.f  s Node=$o(^DHCEQStoreMove(0,"StatusFromLoc",Status,Node)) q:(Node="")||(UsedFlag="Y")  d
		..s RowID=0
		..f  s RowID=$o(^DHCEQStoreMove(0,"StatusFromLoc",Status,Node,RowID)) q:(RowID="")||(UsedFlag="Y")  d
		...q:$p(^DHCEQStoreMove(RowID),"^",16)'=EquipType
		...s ListRowID=0
		...f  s ListRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,ListRowID)) q:(ListRowID="")||(UsedFlag="Y")  d
		....q:((SourceType="StoreMove")&&(SourceID=ListRowID))
		....i (","_$g(^DHCEQStoreMoveList(ListRowID,"EX","RowIDs"))_",")[(","_EquipID_",") s UsedFlag="Y"
		i UsedFlag="Y" q 0
		
		;检查退货单中是否已经占用该设备
		s Status=""
		f  s Status=$o(^DHCEQReturn(0,"StatusReturnLoc",Status)) q:(Status="")||(UsedFlag="Y")  d
		.q:Status=2
		.s Node=0
		.f  s Node=$o(^DHCEQReturn(0,"StatusReturnLoc",Status,Node)) q:(Node="")||(UsedFlag="Y")  d
		..s RowID=0
		..f  s RowID=$o(^DHCEQReturn(0,"StatusReturnLoc",Status,Node,RowID)) q:(RowID="")||(UsedFlag="Y")  d
		...q:$p(^DHCEQReturn(RowID),"^",15)'=EquipType
		...s ListRowID=0
		...f  s ListRowID=$o(^DHCEQReturnList(0,"Return",RowID,ListRowID)) q:(ListRowID="")||(UsedFlag="Y")  d
		....q:((SourceType="Return")&&(SourceID=ListRowID))
		....i (","_$g(^DHCEQReturnList(ListRowID,"EX","RowIDs"))_",")[(","_EquipID_",") s UsedFlag="Y"
		i UsedFlag="Y" q 0
		
		;检查报废单中是否已经占用该设备
		s Status=""
		f  s Status=$o(^DHCEQDisuseRequest(0,"Status",Status)) q:(Status="")||(UsedFlag="Y")  d
		.q:Status=2
		.s RowID=0
		.f  s RowID=$o(^DHCEQDisuseRequest(0,"Status",Status,RowID)) q:(RowID="")||(UsedFlag="Y")  d
		..q:$p(^DHCEQDisuseRequest(RowID),"^",43)'=EquipType
		..
		..i (","_$g(^DHCEQDisuseRequest(RowID,"EX"))_",")[(","_EquipID_",") s UsedFlag="Y"
		i UsedFlag="Y" q 0
	}
	q 1
}

/// Modified By Mozy 2011-6-14
/// 获取设备上一使用科室信息
/// 入参：	EquipID 设备ID
/// 返回值：成功	返回科室id和科室名称
/// 		失败	返回0
/// w ##Class(web.DHCEQEquip).GetOriginalLoc(3846)
ClassMethod GetOriginalLoc(EquipID As %Library.String = "")
{
	Quit:EquipID="" 0
	new date,id,AppendType,LocId,Loc
	Set (AppendType,LocId,Loc)=""
	
	Set date=0
	For  Set date=$Order(^DHCEQLifeInfo(0,"Equip",EquipID,date)) Quit:date=""  Do
	.Set id=0
	.For  Set id=$Order(^DHCEQLifeInfo(0,"Equip",EquipID,date,id)) Quit:id=""  Do
	..Set AppendType=$Piece($Get(^DHCEQLifeInfo(id)),"^",21)
	..If (AppendType=1)||(AppendType=3) Do
	...Set LocId= $Piece($Get(^DHCEQLifeInfo(id)),"^",3)
	...Set Loc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",LocId)
	
	Quit:LocId="" 0
	Quit LocId_"^"_Loc
}

/*
/// add by Mozy 2009-08-04	Mzy0019
/// 根据列表更新房屋专有信息
/// w ##Class(web.DHCEQEquip).SaveEQBuilding("1^no1&2^no2&3^no3")
ClassMethod SaveEQBuilding(val As %Library.String = "")
{
	Kill List,rowid
 	Set rowid = $Piece(val,"^",1)
 	Set rowid = $Order(^DHCEQBuilding(0,"EquipDR",rowid,-1))
 	
	Set List(2) = $Piece(val,"^",1)		;EquipRowID
 	;Set List(3) = $Piece(val,"^",1)	;StructDR
    Set List(4) = $Piece(val,"^",2)		;BuildingArea
    Set List(5) = $Piece(val,"^",3)		;UtilizationArea
  	Set List(6) = $Piece(val,"^",4)		;SubArea
  	Set List(7) = $Piece(val,"^",5)		;Place
 	If $Piece(val,"^",6)'="" Set List(8) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",6),"bool")	;OwnerFlag
  	Set List(9) = $Piece(val,"^",7)		;SelfUseArea
   	Set List(10) = $Piece(val,"^",8)	;LendingArea
   	Set List(11) = $Piece(val,"^",9)	;RentArea
   	Set List(12) = $Piece(val,"^",10)	;WorkArea
 	Set List(13) = $Piece(val,"^",11)	;IdleArea
    Set List(14) = $Piece(val,"^",12)	;OtherArea
    Set List(15) = $Piece(val,"^",13)	;LendCompany
 	Set List(16) = $Piece(val,"^",14)	;RentCompany
 	Set List(17) = $Piece(val,"^",15)	;OwnerCertificat
 	Set List(18) = $Piece(val,"^",16)	;CertificateNo
  	If $Piece(val,"^",17)'="" Set List(19) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",17),"date")	;CertificateDate
  	Set List(20) = $Piece(val,"^",18)	;FloorNum
  	Set List(21) = $Piece(val,"^",19)	;UnderFloorNum
  	Set List(22) = $Piece(val,"^",20)	;BD_Hold1
  	Set List(23) = $Piece(val,"^",21)	;BD_Hold2
  	Set List(24) = $Piece(val,"^",22)	;BD_Hold3
  	Set List(25) = $Piece(val,"^",23)	;BD_Hold4
  	Set List(26) = $Piece(val,"^",24)	;BD_Hold5
	
	Kill List(1)
	
	TStart
	If (rowid'="") 
	{
		&SQL(Update SQLUSER.DHC_EQBuilding Values :List() where BD_RowID = :rowid)
		Set ID=rowid
	}
	Else
	{
		&SQL(Insert Into SQLUSER.DHC_EQBuilding Values :List())
		Set ID=$Get(%ROWID)
	}
	If SQLCODE  
	{
		TRollBack
		Quit SQLCODE
	}
	
	TCommit
	Quit ID
}*/
/// delete by GR0014 2014-11-18 
/// 更新操作从台帐提前到验收阶段，SaveEQBuilding移到web.DHCEQBuilding中
/// delete by GR0014 2014-11-18 end
/// add by Mozy 2009-08-04	Mzy0019
/// 根据列表更新交通工具专有信息
/// w ##Class(web.DHCEQEquip).SaveEQVehicle("1^no1&2^no2&3^no3")
ClassMethod SaveEQVehicle(val As %Library.String = "")
{
	Kill List,rowid
 	Set rowid = $Piece(val,"^",1)
 	Set rowid = $Order(^DHCEQVehicle(0,"EquipDR",rowid,-1))
 	
	Set List(2) = $Piece(val,"^",1)		;EquipRowID
    Set List(3) = $Piece(val,"^",2)		;VehicleNo
    Set List(4) = $Piece(val,"^",3)		;EngineNo
 	Set List(5) = $Piece(val,"^",4)		;CarFrameNo
 	Set List(6) = $Piece(val,"^",5)		;Displacemint
 	Set List(7) = $Piece(val,"^",6)		;Mileage
 	Set List(8) = $Piece(val,"^",7)		;Color
 	Set List(9) = $Piece(val,"^",8)		;V_Hold1
  	Set List(10) = $Piece(val,"^",9)	;V_Hold2
  	Set List(11) = $Piece(val,"^",10)	;V_Hold3
  	Set List(12) = $Piece(val,"^",11)	;V_Hold4
  	Set List(13) = $Piece(val,"^",12)	;V_Hold5
	
	Kill List(1)
	
	TStart
	If (rowid'="") 
	{
		&SQL(Update SQLUSER.DHC_EQVehicle Values :List() where V_RowID = :rowid)
		Set ID=rowid
	}
	Else
	{
		&SQL(Insert Into SQLUSER.DHC_EQVehicle Values :List())
		Set ID=$Get(%ROWID)
	}
	If SQLCODE  
	{
		TRollBack
		Quit SQLCODE
	}
	
	TCommit
	Quit ID
}

/*GR0014
/// add by Mozy 2009-08-04	Mzy0019
/// 根据ID获取房屋专有信息
/// w ##class(web.DHCEQEquip).GetEqBuildingByEQID("","","3")
ClassMethod GetEqBuildingByEQID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result
	Set result=""
	Set rowid = $Order(^DHCEQBuilding(0,"EquipDR",rowid,-1))
	If rowid'="" Do
	.Set result = ^DHCEQBuilding(rowid) 
	.If $Piece(result,"^",7)'="" Set $Piece(result,"^",7) = ##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",7),"bool")
	.If $Piece(result,"^",18)'="" Set $Piece(result,"^",18) = ##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",18),"date")
	.Set result=result_"^"_rowid	//Add By HZY HZY0034 2012-10-17
	Quit result
}*/
/// delete by GR0014 2014-11-18 
/// 更新操作从台帐提前到验收阶段，GetEqBuildingByEQID移到web.DHCEQBuilding中
/// delete by GR0014 2014-11-18 end
/// add by Mozy 2009-08-04	Mzy0019
/// 根据ID获取交通工具专有信息
/// w ##class(web.DHCEQEquip).GetEqVehicleByEQID("","","12")
ClassMethod GetEqVehicleByEQID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	Set rowid = $Order(^DHCEQVehicle(0,"EquipDR",rowid,-1))
	Quit:rowid'="" ^DHCEQVehicle(rowid)

	Quit ""
}

/// Add By HZY 2011-09-06 HZY0011
/// Description：查询设备按一定条件分组汇总的结果。
Query GetEquipCollect(Data As %String, ReadOnly) As %Query(ROWSPEC = "TEquipType:%String,TName:%String,TModel:%String,TOriginalFee:%String,TStoreLoc:%String,TOrigin:%String,TStatCat:%String,TEquipCat:%String,TQuantity:%String,TTotalFee:%String,TTotalNet:%String,TTotalDepre:%String,TRow:%String")
{
}

ClassMethod GetEquipCollectExecute(ByRef qHandle As %Binary, vData As %String, ReadOnly) As %Status
{
	d ##Class(web.DHCEQCommon).KillTempGlobal("EquipCollect")	//^DHCEQTemp(str,+$H,$J)
	d ##Class(web.DHCEQCommon).KillTempGlobal("EquipCollectPrint")
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s approveroleid=##class(web.DHCEQCommon).GetSysInfo("601003")		//哪个角色审批时作为院内审批完成
	
	Set TRow=0
	k GroupNameList,GroupFlagList,GroupValueList,GN
	s groupstring=##class(web.DHCEQCommon).GetSysInfo("401006")			//设备汇总统计查询分组字符串
	s PNum=1
	n GroupLen,tempGN,TotalNetFee,TotalDepreFee
	s (TotalNetFee,TotalDepreFee)=0
	s tempGN=""
	s GroupLen=6
	for i=1:1:GroupLen d
	.s GroupNameList(i)= $p($p(groupstring,",",i),"|",1)
	.s GroupFlagList(i)= $p($p(groupstring,",",i),"|",2)
	
 	new repid, index,rowid,vStoreLocDR,TotalNum,TotalFee,TTotalFundsFee
 	Set TotalNum=0
 	Set TotalFee=0
 	Set TTotalFundsFee=0
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set vData=##class(web.DHCEQCommon).UnEscape(vData)
 	Set EquipCatDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipCatDR")
 	Set StoreLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"StoreLocDR")
 	Set UseLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
 	Set ManageLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"ManageLocDR") 	
 	Set InStockListDR=##class(web.DHCEQCommon).GetDataByName(vData,"InStockListDR")
 	Set BatchFlag=##class(web.DHCEQCommon).GetDataByName(vData,"BatchFlag")
 	Set No=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"No"),"U")
 	Set Code=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"Code"),"U")
 	Set Name=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"Name"),"U")
 	Set ModelDR=##class(web.DHCEQCommon).GetDataByName(vData,"ModelDR")
 	Set Status=##class(web.DHCEQCommon).GetDataByName(vData,"Status")
 	Set MinValue=##class(web.DHCEQCommon).GetDataByName(vData,"MinValue")
 	Set MaxValue=##class(web.DHCEQCommon).GetDataByName(vData,"MaxValue")
 	Set ProviderDR=##class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")
 	Set ManuFactoryDR=##class(web.DHCEQCommon).GetDataByName(vData,"ManuFactoryDR")
 	Set EquipTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDR")
 	Set ServiceDR=##class(web.DHCEQCommon).GetDataByName(vData,"ServiceDR")
 	Set QXType=##class(web.DHCEQCommon).GetDataByName(vData,"QXType")
 	Set PurposeTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"PurposeTypeDR")
 	set IncludeFlag=##class(web.DHCEQCommon).GetDataByName(vData,"IncludeFlag")
 	Set PurchaseTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"PurchaseTypeDR")
 	Set OriginDR=##class(web.DHCEQCommon).GetDataByName(vData,"OriginDR")
 	Set StatCatDR=##class(web.DHCEQCommon).GetDataByName(vData,"StatCatDR")
 	
 	Set BeginInStockDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginInStockDate")
 	Set EndInStockDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndInStockDate")
 	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
 	s BeginInStockDate=##class(web.DHCEQCommon).TransValueFromPage(BeginInStockDate,"date")
 	s EndInStockDate=##class(web.DHCEQCommon).TransValueFromPage(EndInStockDate,"date")
 	
 	Set InvoiceNo=##class(web.DHCEQCommon).GetDataByName(vData,"InvoiceNo")
 	Set ContractNo=##class(web.DHCEQCommon).GetDataByName(vData,"ContractNo")
 	Set IsDisused=##class(web.DHCEQCommon).GetDataByName(vData,"IsDisused")
 	Set IsDisusing=##class(web.DHCEQCommon).GetDataByName(vData,"IsDisusing")
 	Set IsOut=##class(web.DHCEQCommon).GetDataByName(vData,"IsOut")
 	Set ComputerFlag=##class(web.DHCEQCommon).GetDataByName(vData,"ComputerFlag")
 	
 	// Mozy  2009-03-03 增加报废查询的时间段
 	Set BeginDisuseDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginDisuseDate")
 	Set EndDisuseDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndDisuseDate")
 	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
 	s BeginDisuseDate=##class(web.DHCEQCommon).TransValueFromPage(BeginDisuseDate,"date")
 	s EndDisuseDate=##class(web.DHCEQCommon).TransValueFromPage(EndDisuseDate,"date")

	//add by JDL 2009-9-7 JDL0023
	Set MemoryCode=##class(web.DHCEQCommon).GetDataByName(vData,"MemoryCode")
	
	//add by JDL 2009-9-16 JDL0033
	Set BeginTransAssetDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginTransAssetDate")
	Set EndTransAssetDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndTransAssetDate")
 	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
 	s BeginTransAssetDate=##class(web.DHCEQCommon).TransValueFromPage(BeginTransAssetDate,"date")
 	s EndTransAssetDate=##class(web.DHCEQCommon).TransValueFromPage(EndTransAssetDate,"date")
 	
 	//add by jdl 2010-3-30	JDL0045
 	Set FundsTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"FundsTypeDR")
	Set FundsRecordDR=##class(web.DHCEQCommon).GetDataByName(vData,"FundsRecordDR")
	
	//add by jdl 2010-8-25
 	Set BeginOutDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginOutDate")
	Set EndOutDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndOutDate")
 	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
 	s BeginOutDate=##class(web.DHCEQCommon).TransValueFromPage(BeginOutDate,"date")
 	s EndOutDate=##class(web.DHCEQCommon).TransValueFromPage(EndOutDate,"date")
 	
 	//add by ZY 2010-08-09
 	Set MasterItemDR=##class(web.DHCEQCommon).GetDataByName(vData,"MasterItemDR")	
	//add by DJ 2010-10-27
	Set LocIncludeFlag=##class(web.DHCEQCommon).GetDataByName(vData,"LocIncludeFlag")
	//add by jdl 2010-12-09 JDL0063
	Set TreeNo=##class(web.DHCEQCommon).GetDataByName(vData,"TreeNo")
	
	//20150827  Mozy0163	存放地点
	Set Location=""
	Set LocationDR=##class(web.DHCEQCommon).GetDataByName(vData,"LocationDR")
	i LocationDR'="" s Location=$p($g(^DHCEQCCode("DHCEQCLocation",LocationDR)),"^",1)
	//add by zy 2011-02-22  ZY0061
	Set AdvanceDisFlag=##class(web.DHCEQCommon).GetDataByName(vData,"AdvanceDisFlag")
	
	Set InStockNo=##class(web.DHCEQCommon).GetDataByName(vData,"InStockNo")
	Set LeaveFactoryNo=##class(web.DHCEQCommon).GetDataByName(vData,"LeaveFactoryNo")
	Set StoreMoveNo=##class(web.DHCEQCommon).GetDataByName(vData,"StoreMoveNo")
	//add by zx 2013-12-27 
	Set LimitYearsNum=##class(web.DHCEQCommon).GetDataByName(vData,"LimitYearsNum")
	//20150819  Mozy0159
	Set Model=##class(web.DHCEQCommon).GetDataByName(vData,"Model")
	Set Model=$ZCONVERT(Model,"U")
	Set FileNo=##class(web.DHCEQCommon).GetDataByName(vData,"FileNo")
	Set FileNo=$ZCONVERT(FileNo,"U")
	
	s index=2
	s rowid=0
	
	//add by jdl 2010-10-11 JDL0050 优化根据分类查找
	k ^DHCEQTemp("EquipCollect",0,"Cat",$j)
	
	d BuildDataGetEquipCollect 
	
	//add by jdl 2010-10-11 JDL0050 优化根据分类查找
	k ^DHCEQTemp("EquipCollect",0,"Cat",$j)
	Quit $$$OK
	
BuildDataGetEquipCollect
	s findnolist=0
	s CheckLocFlag=0
	
	if InStockListDR'=""
	{
		s vStoreLocDR=0
		f  s vStoreLocDR=$o(^DHCEQEquip(0,"InStockList",InStockListDR,vStoreLocDR))  quit:vStoreLocDR=""  d
		.s rowid=0
		.f  s rowid=$o(^DHCEQEquip(0,"InStockList",InStockListDR,vStoreLocDR,rowid))  quit:rowid=""  d
		..d FillOneDataGetEquipCollect
	}
	elseif (StoreMoveNo'="")
	{
		Set SMRowID=0		
		For  Set SMRowID=$Order(^DHCEQStoreMove(0,"StoreMoveNo",StoreMoveNo,SMRowID))  Quit:SMRowID=""  Do
		.Set TStoreMoveNo=StoreMoveNo
		.Set SMLRowID=0 
		.For  Set SMLRowID=$Order(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  Quit:SMLRowID=""  Do
		..Set CSRowID=0
		..For  Set CSRowID=$Order(^DHCEQChangeStock(0,"Source",1,SMLRowID,CSRowID))  Quit:CSRowID=""  Do
		...Set rowid = $Piece($Get(^DHCEQChangeStock(CSRowID)),"^",1)
		...Do FillOneDataGetEquipCollect
	}
	elseif (StoreLocDR'="")
	{	
		f  s rowid=$o(^DHCEQEquip(0,"StoreLoc",StoreLocDR,rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipCollect
	}
	elseif(UseLocDR'="")
	{
		s CheckLocFlag=1
		s TUseLocDR=0
		f  s TUseLocDR=$o(^DHCEQEquip(0,"UseLoc",TUseLocDR))  quit:TUseLocDR=""  d
		.q:(LocIncludeFlag'="1")&&(TUseLocDR'=UseLocDR)
		.q:(LocIncludeFlag="1")&&(..CheckIsChildLoc(UseLocDR,TUseLocDR,"1")'="1")
		.s rowid=0
		.f  s rowid=$o(^DHCEQEquip(0,"UseLoc",TUseLocDR,rowid))  quit:rowid=""  d
		..d FillOneDataGetEquipCollect		
	}
	elseif(ProviderDR'="")
	{
		f  s rowid=$o(^DHCEQEquip(0,"Provider",ProviderDR,rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipCollect
	}
	elseif(ManuFactoryDR'="")
	{
		f  s rowid=$o(^DHCEQEquip(0,"ManuFactory",ManuFactoryDR,rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipCollect
	}
	elseif(ServiceDR'="")
	{
		f  s rowid=$o(^DHCEQEquip(0,"Service",ServiceDR,rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipCollect
	}
	else
	{
		f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
		.d FillOneDataGetEquipCollect
	}
	
	s (TEquipType,TName,TModel,TOriginalFee,TStoreLoc,TOrigin,TStatCat,TEquipCat,TQuantity,TTotalFee,TTotalNet,TTotalDepre)=""
	d ResetVariablesGetEquipCollect
	
	;Modified By JDL 2013-2-28 JDL0131
	;s TName="总计:"
	s aCmd=""_GroupNameList(1)_" = ""总计:"""
	;s ^DHCEQTemp("jdl")=aCmd
	s @aCmd
	
	s TQuantity=TotalNum
	s TTotalFee=TotalFee
	s TTotalNet=TotalNetFee
	s TTotalDepre=TotalDepreFee
	//格式化金额为小数点两位
	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
	i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
	i TTotalNet'="" s TTotalNet=##Class(web.DHCEQCommon).FormatNumber(TTotalNet,"") 
	i TTotalDepre'="" s TTotalDepre=##Class(web.DHCEQCommon).FormatNumber(TTotalDepre,"")
	d OutPutFinalInfo
	d OutputRowGetEquipCollect
	quit
	
FillOneDataGetEquipCollect
	d ResetVariablesGetEquipCollect
	d CheckGetEquipCollect
	q:passed=0
	d SetVariablesGetEquipCollect
	quit
ResetVariablesGetEquipCollect
	s (TRowID,TName,TABCType,TModelDR,TEquiCatDR,TUnitDR,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TCountryDR,TManageLocDR,TManageLevelDR,TUseLocDR,TOriginDR,TFromDeptDR,TToDeptDR,TBuyTypeDR,TEquipTechLevelDR,TProviderDR,TManuFactoryDR,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TWorkLoadUnitDR,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TEquipTypeDR,TPurchaseTypeDR,TPurposeTypeDR,TKeeperDR,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TLocation,TGuaranteePeriodNum,TStatCatDR,TStatCat,TDisplayStatus,TDisplayStockStatus)=""
	s (TFileNo,TRentLocDR,TRentStatus,TFaultStatus,TDisuseDate,TAccountNo,Thold6,Thold7,Thold8,Thold9,Thold10,TAdvanceDisFlag,TStoreMoveNo)=""
	s TBatchFlag="N"
	quit
CheckGetEquipCollect
	s passed=0
	
	s TUseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	s TInvalidFlag = $p($g(^DHCEQEquip(rowid)),"^",59)
	i TInvalidFlag'="N" quit
	s TEquiCatDR = $p($g(^DHCEQEquip(rowid)),"^",4)	
	i (EquipCatDR'="")&(EquipCatDR'=TEquiCatDR)
		{
			i (IncludeFlag'="1")
			{
				quit
			}
			else
			{
				//modified by jdl 2010-10-11 JDL0050 优化根据分类查找
				i TEquiCatDR=""
				{
					quit
				}
				else
				{
					i $g(^DHCEQTemp("EquipCollect",0,"Cat",$j,TEquiCatDR))=""
					{					
						s ^DHCEQTemp("EquipCollect",0,"Cat",$j,TEquiCatDR)=##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatDR,TEquiCatDR)						
					}
					i +$g(^DHCEQTemp("EquipCollect",0,"Cat",$j,TEquiCatDR))=0 quit
				}
			}
		}
	s TStoreLocDR = $p($g(^DHCEQEquip(rowid)),"^",67)
	i (StoreLocDR'="")&(StoreLocDR'=TStoreLocDR) quit
	i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TStoreLocDR))) //2010-10-27 DJ
	{
		quit
	}
	s TUseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	i (CheckLocFlag=0)&&(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
		{quit}
	s TManageLocDR = $p($g(^DHCEQEquip(rowid)),"^",17)
	i (ManageLocDR'="")&(ManageLocDR'=TManageLocDR)
		{quit}
	s TInStockListDR = $p($g(^DHCEQEquip(rowid)),"^",70)
	i (InStockListDR'="")&(InStockListDR'=TInStockListDR)
		{quit}
	if ((BeginInStockDate'="")||(EndInStockDate'=""))	
	{
		i (TInStockListDR="")
		{	s InStockDate=$p($g(^DHCEQEquip(rowid)),"^",45)}
		else
		{
			s InStockDate=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
			s InStockDate=$p(^DHCEQInStock(InStockDate),"^",13)
		}
		i ((BeginInStockDate'="")&(InStockDate<BeginInStockDate))
		{quit}
		
		i ((EndInStockDate'="")&(InStockDate>EndInStockDate))
		{quit}
	}
	
	//add by JDL 2009-9-16 JDL0033
	if ((BeginTransAssetDate'="")||(EndTransAssetDate'=""))	
	{
		s TransAssetDate=$p($g(^DHCEQEquip(rowid)),"^",45)
		i ((BeginTransAssetDate'="")&(TransAssetDate<BeginTransAssetDate))
		{quit}
		
		i ((EndTransAssetDate'="")&(TransAssetDate>EndTransAssetDate))
		{quit}
	}
	
	s TModelDR = $p($g(^DHCEQEquip(rowid)),"^",3)
	i (ModelDR'="")&(ModelDR'=TModelDR)
		{quit}
	s TStatus = $p($g(^DHCEQEquip(rowid)),"^",38)
	i (Status'="")&(Status'=TStatus)
		{quit}
	//是否包含已经报废设备
	i (IsDisused="Y")&(TStatus'=3)
		{quit}
	i (IsDisused="N")&(TStatus=3)
		{quit}
	i (TStatus=3)
	{
		//Modified by jdl 2010-8-24
		s TDisuseDate=$p($g(^DHCEQEquip(rowid)),"^",89)
		
		i ((BeginDisuseDate'="")&(TDisuseDate<BeginDisuseDate))
		{
			quit
		}
		i ((EndDisuseDate'="")&(TDisuseDate>EndDisuseDate))
		{
			quit
		}
	}
	s TOriginalFee=$p($g(^DHCEQEquip(rowid)),"^",27)
	i (MinValue'="")&(MinValue>TOriginalFee)
		{quit}
	i (MaxValue'="")&(MaxValue<TOriginalFee)
		{quit}
	s TProviderDR = $p($g(^DHCEQEquip(rowid)),"^",25)
	i (ProviderDR'="")&(ProviderDR'=TProviderDR)
		{quit}
	s TManuFactoryDR = $p($g(^DHCEQEquip(rowid)),"^",26)
	i (ManuFactoryDR'="")&(ManuFactoryDR'=TManuFactoryDR)
		{quit}
	s TServiceDR = $p($g(^DHCEQEquip(rowid)),"^",69)
	i (ServiceDR'="")&(ServiceDR'=TServiceDR)
		{quit}
	///判断是否还未入库
	s TStockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	i (TStockStatus="0")
		{	quit}
	//是否包含已经出库设备
	i (IsOut="Y")&(TStockStatus'="3")
		{	quit}
	i (IsOut="N")&(TStockStatus="3")
		{	quit}
			
	s TPurchaseTypeDR=$p($g(^DHCEQEquip(rowid)),"^",64)
	i (PurchaseTypeDR'="")&(PurchaseTypeDR'=TPurchaseTypeDR)
		{quit}
	s TOriginDR=$p($g(^DHCEQEquip(rowid)),"^",20)
	i (OriginDR'="")&(OriginDR'=TOriginDR)
		{quit}	
	///end
	Set TEquipTypeDR=$p($g(^DHCEQEquip(rowid)),"^",63)
	i (EquipTypeDR'="")&(EquipTypeDR'=TEquipTypeDR)
		{quit}
	i (EquipTypeDR="")&("1"=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
		{quit}
 	Set TPurposeTypeDR=$p($g(^DHCEQEquip(rowid)),"^",65)
 	i (PurposeTypeDR'="")&(PurposeTypeDR'=TPurposeTypeDR)
		{quit}
	s TCode = $ZCONVERT($p($g(^DHCEQEquip(rowid)),"^",6),"U")
	s TName = $ZCONVERT($p($g(^DHCEQEquip(rowid)),"^",1),"U")	
	s TNo = $ZCONVERT($p($g(^DHCEQEquip(rowid)),"^",71),"U")
	i ((TCode'[Code)||(TName'[Name)||(TNo'[No))
		{quit}
	
	///add 2006-12-25
	s TStatCatDR = $p($g(^DHCEQEquip(rowid)),"^",75)
	i (StatCatDR'="")&&(StatCatDR'=TStatCatDR)
	{quit}
	///end
	i (findnolist=1)&(TInStockListDR'="")
	{
		quit
	}
	
	i (InvoiceNo'="")
	{
		// Mozy0059	2011-8-17	模糊检索某一来源的全部发票号
		Set tmp=0
		Set TInvoiceNo=..GetInvoiceNo(rowid)
		Set len = $Length(InvoiceNo,"&")
		for i=1:1:len
		{
			If $Piece($Piece(TInvoiceNo,"&",i),"^",1)[InvoiceNo Set tmp=1
		}
		Quit:tmp=0
	}
	i (ContractNo'="")
	{
		s THold1=$p($g(^DHCEQEquip(rowid)),"^",76)	//2014-07-21 DJ0125
		if THold1'[ContractNo
		{
			quit
		}
		/*
		if ContractNo'=..GetContractNo(rowid)
		{
			quit
		}
		*/
	}
	
	s TComputerFlag = $p($g(^DHCEQEquip(rowid)),"^",15)
	i (ComputerFlag'="")&(ComputerFlag'=TComputerFlag)
	{quit}
	s THold1 = $p($g(^DHCEQEquip(rowid)),"^",76)
	i (IsDisusing="Y")&(THold1'="1")
	{quit}
	i (IsDisusing="N")&(THold1="1")
	{quit}
	
	//add by JDL 2009-9-7 JDL0023
	s TMemoryCode=$p($g(^DHCEQEquip(rowid)),"^",61)
	i (MemoryCode'="")&&(MemoryCode'=TMemoryCode)
	{quit}
	
	//add by jdl 2010-3-30	JDL0045
	s TFundsFee=TOriginalFee
	i ((FundsTypeDR'="")||(FundsRecordDR'=""))
	{
		s TFundsFee=##Class(web.DHCEQFunds).GetFundsAmountByFromID(1,rowid,FundsTypeDR,FundsRecordDR)
		i +TFundsFee=0
		{
			quit
		}
	}
	;add by jdl 2010-8-25
	;增加减少日期的判断
	i (TStockStatus="3")
	{
		i ((BeginOutDate'="")||(EndOutDate'=""))
		{
			s TOutID=$o(^DHCEQLifeInfo(0,"EquipSource","23",rowid,0))	
			s TLifeInfoID=$o(^DHCEQLifeInfo(0,"EquipSource","23",rowid,TOutID,0))	
			s TOutDate=$p(^DHCEQLifeInfo(TLifeInfoID),"^",15)
			i (BeginOutDate'="")
			{
				i (TOutDate<BeginOutDate)
				{
					quit
				}
			}
			i (EndOutDate'="")
			{
				i (TOutDate>EndOutDate)
				{
					quit
				}
			}
		}
	}
	///add 2010-08-09
	s TMasterItemDR = $p($g(^DHCEQEquip(rowid)),"^",7)
	i (MasterItemDR'="")&&(MasterItemDR'=TMasterItemDR)
	{quit}
	///end
	//add by zx 2013-12-27
	s TLimitYearsNum = $p($g(^DHCEQEquip(rowid)),"^",31)
	i (LimitYearsNum'="")&&(LimitYearsNum'=TLimitYearsNum)
	{quit}
	//add by jdl 2010-12-09 JDL0063
	i TreeNo'=""
	{
		s TTreeNo=""
		i (TMasterItemDR'="")
		{
			s TTreeNo=$p($g(^DHCEQCCode("DHCEQCMasterItem",TMasterItemDR)),"^",10)
			i TTreeNo'="" s TTreeNo=$p($g(^DHCEQCCode("DHCEQCTree",TTreeNo)),"^",2)
		}
		i ((TTreeNo="")||(TreeNo'=$e(TTreeNo,1,$l(TreeNo))))
		{quit}
	}
	
	//20150827  Mozy0163	存放地点
	i Location'=""
	{
		s TLocationDR = $p($g(^DHCEQEquip(rowid)),"^",72)
		i TLocationDR=""
		{quit}
		i $e($p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",1),1,$l(Location))'=Location
		{quit}
	}
	
	//add by zy 2011-02-22  ZY0061 设备院内报废参数查询 
	i approveroleid=""
	{
		i AdvanceDisFlag="1" quit
	}
	else
	{
		i TStatus="3"	//设备状态为报废
		{
			i AdvanceDisFlag="1" quit
		}
		else
		{
			i $D(^DHCEQDisuseRequestList(0,"EquipDR",rowid))
			{
				s (DRLRowID,DRRowID,ApproveRoleDR)=""
				s DRLRowID=$order(^DHCEQDisuseRequestList(0,"EquipDR",rowid,DRLRowID))
				i DRLRowID'="" 
				{
					s DRRowID=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",1)
					i DRRowID'=""
					{
						s ApproveRoleDR=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",31)
						i ApproveRoleDR=approveroleid
						{
							s TAdvanceDisFlag="预报废"
						}
					}
				}
			}
			i (AdvanceDisFlag'="0")
			{
				if (AdvanceDisFlag="1")
				{
					if (TAdvanceDisFlag="")	quit
				}
				else
				{
					if (TAdvanceDisFlag'="")	quit
				}			
			}
		}
	}
	//end by zy 2011-02-22 ZY0061
	
	i (InStockNo'="")
	{
		i (TInStockListDR="") quit
		s TInStockNo=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
		s TInStockNo=$p($g(^DHCEQInStock(TInStockNo)),"^",14)
		i (TInStockNo'[InStockNo) quit
	}
	Set TLeaveFactoryNo=$p($g(^DHCEQEquip(rowid)),"^",10)		//出厂编号
	If (LeaveFactoryNo'="")&(TLeaveFactoryNo'[LeaveFactoryNo) quit
	if StoreMoveNo'=""
	{
		i TStoreMoveNo=""
		{
			s LifeSourceID=0
			f  s LifeSourceID=$o(^DHCEQLifeInfo(0,"EquipSource",22,rowid,LifeSourceID)) quit:(LifeSourceID="")  d
			.i ($p($g(^DHCEQStoreMove($p($g(^DHCEQStoreMoveList(LifeSourceID)),"^",1))),"^",1)=StoreMoveNo)  d
			..s passed=1
			i passed'=1 q
			s passed=0
		}
	}
	//20150819  Mozy0159
	If (Model'="")
	{
		Set TModel = ""
		If TModelDR '="" Set TModel = $Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		If (TModel="")||($ZCONVERT(TModel,"U")'[Model) Quit
	}
	Set TFileNo=$Piece($Get(^DHCEQEquip(rowid)),"^",85)	//20150822  Mozy0162	设备汇总统计查询异常
	If (FileNo'="")&&($ZCONVERT(TFileNo,"U")'[FileNo) Quit
	
	s passed=1
	quit
SetVariablesGetEquipCollect
	s TQuantity = 1
	s TotalNum=TotalNum+TQuantity
	s TRowID = rowid
	s TName = $p($g(^DHCEQEquip(rowid)),"^",1)
	s TModelDR = $p($g(^DHCEQEquip(rowid)),"^",3)
	i TModelDR '=""  d
	.s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TEquiCatDR = $p($g(^DHCEQEquip(rowid)),"^",4)
	s TEquiCat=""
	i TEquiCatDR '=""  d
	.s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCatDR)),"^",2)
	
	s TOriginDR = $p($g(^DHCEQEquip(rowid)),"^",20)
	s TOrigin=""
	i TOriginDR '=""  d
	.s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	
	s TOriginalFee = $p($g(^DHCEQEquip(rowid)),"^",27)
	s TotalFee=TotalFee+TOriginalFee
	
	s TTotalFundsFee=TTotalFundsFee+TFundsFee
	
	s TNetFee = $p($g(^DHCEQEquip(rowid)),"^",28)
	s TotalNetFee=TotalNetFee+TNetFee
	
	s TNetRemainFee = $p($g(^DHCEQEquip(rowid)),"^",29)
	i TNetRemainFee="" s TNetRemainFee=0
	s TNetRemainFee=##Class(web.DHCEQCommon).FormatNumber(TNetRemainFee,"")
	
	s TDepreTotalFee = $p($g(^DHCEQEquip(rowid)),"^",35)
	s TotalDepreFee=TotalDepreFee+TDepreTotalFee
	
	
	s TEquipTypeDR = $p($g(^DHCEQEquip(rowid)),"^",63)
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	
	
	s TStoreLocDR = $p($g(^DHCEQEquip(rowid)),"^",67)
	i TStoreLocDR '=""  d
	.s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	
	s TStatCatDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	s TStatCat=""
	i TStatCatDR'="" d
	.s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	
	//格式化金额为小数点两位
	;i TOriginalFee="" s TOriginalFee=0
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
	;i TNetFee="" s TNetFee=0
	s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TNetFee,"")
	;i TDepreTotalFee="" s TDepreTotalFee=0
	s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TDepreTotalFee,"")
	
	//Start Modified By HZY 2011-09-07 HZY0011
	i TEquipType="" s TEquipType="--"
	i TName="" s TName="--"
	i TModel="" s TModel="--"
	i TStoreLoc="" s TStoreLoc="--"
	i TOrigin="" s TOrigin="--"
	i TStatCat="" s TStatCat="--"
	i TEquiCat="" s TEquiCat="--"
				
	for i=1:1:GroupLen d
	.s GroupValueList(i)=0
	.i GroupNameList(i)="TEquipType" s GroupValueList(i)=TEquipType
	.i GroupNameList(i)="TName" s GroupValueList(i)=TName
	.i GroupNameList(i)="TModel" s GroupValueList(i)=TModel
	.i GroupNameList(i)="TOriginalFee" s GroupValueList(i)=TOriginalFee
	.i GroupNameList(i)="TStoreLoc" s GroupValueList(i)=TStoreLoc
	.i GroupNameList(i)="TOrigin" s GroupValueList(i)=TOrigin
	.i GroupNameList(i)="TStatCat" s GroupValueList(i)=TStatCat
	.i GroupNameList(i)="TEquiCat" s GroupValueList(i)=TEquiCat

	;TEquipType|1,TName|0,TModel|1,TOriginalFee|0,TStoreLoc|1，TOrigin|1，TStatCat|0,TEquiCat|1,      TTotalNet_"^"_TTotalDepre
	s TSumQuantity=1+$p($g(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GroupValueList(1),GroupValueList(2),GroupValueList(3),GroupValueList(4),GroupValueList(5),GroupValueList(6))),"^",10)
	s TSumOriginalFee=TOriginalFee+$p($g(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GroupValueList(1),GroupValueList(2),GroupValueList(3),GroupValueList(4),GroupValueList(5),GroupValueList(6))),"^",5)
	s TSumNet=TNetFee+$p($g(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GroupValueList(1),GroupValueList(2),GroupValueList(3),GroupValueList(4),GroupValueList(5),GroupValueList(6))),"^",11)
	s TSumDepre=TDepreTotalFee+$p($g(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GroupValueList(1),GroupValueList(2),GroupValueList(3),GroupValueList(4),GroupValueList(5),GroupValueList(6))),"^",12)
	s ^DHCEQTemp("EquipCollect",+$H,$J,curuser,GroupValueList(1),GroupValueList(2),GroupValueList(3),GroupValueList(4),GroupValueList(5),GroupValueList(6))=TName_"^"_TModel_"^"_TEquipType_"^"_TOriginalFee_"^"_TSumOriginalFee_"^"_TStoreLoc_"^"_TOrigin_"^"_TStatCat_"^"_TEquiCat_"^"_TSumQuantity_"^"_TSumNet_"^"_TSumDepre   
	quit	
	
OutputRowGetEquipCollect
	s tempGN=""
	s GN(1)=""	//GroupName	
	f  s GN(1)=$o(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GN(1))) quit:GN(1)=""  d
	.s i=0
	.d ClearSumValue
	.s GN(2)=""
	.f  s GN(2)=$o(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GN(1),GN(2))) quit:GN(2)=""  d
	..d ClearSumValue
	..s GN(3)=""
	..f  s GN(3)=$o(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GN(1),GN(2),GN(3))) quit:GN(3)=""  d
	...d ClearSumValue
	...s GN(4)=""
	...f  s GN(4)=$o(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GN(1),GN(2),GN(3),GN(4))) quit:GN(4)=""  d
	....d ClearSumValue
	....s GN(5)=""
	....f  s GN(5)=$o(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GN(1),GN(2),GN(3),GN(4),GN(5))) quit:GN(5)=""  d
	.....d ClearSumValue
	.....s GN(6)=""
	.....f  s GN(6)=$o(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GN(1),GN(2),GN(3),GN(4),GN(5),GN(6))) quit:GN(6)=""  d
	......d ClearSumValue
	......d SetSumValue
	......s (TEquipType,TName,TModel,TOriginalFee,TStoreLoc,TOrigin,TStatCat,TEquipCat,TQuantity,TTotalFee,TTotalNet,TTotalDepre)=""
	......d OutputGetEquip
	......s i=i+1
	......d OutputSubTotal
	......d ClearSum
	.....d OutputSubTotal
	.....d ClearSum
	....d OutputSubTotal
	....d ClearSum
	...d OutputSubTotal
	...d ClearSum
	..d OutputSubTotal
	..d ClearSum
	.d OutputSubTotal
	.d ClearSum
	
	quit
	
OutputSubTotal
	s i=i-1	
	i +GroupFlagList(i)'=1 quit	
	s tempGN=GroupNameList(i)
	s TQuantity=QtyList(i)
	s TTotalFee=OriginalFeeList(i)
	s TTotalNet=NetFeeList(i)
	s TTotalDepre=DepreFeeList(i)
	
	s (TEquipType,TName,TModel,TOriginalFee,TStoreLoc,TOrigin,TStatCat,TEquipCat)=""
	if (tempGN="TEquipType")
	{
		s TEquipType="小计:"
	}
	elseif (tempGN="TName")
	{
		s TName="小计:"
	}
	elseif (tempGN="TModel")
	{
		s TModel="小计:"
	}
	elseif (tempGN="TOriginalFee")
	{
		s TOriginalFee="小计:"
	}
	elseif (tempGN="TStoreLoc")
	{
		s TStoreLoc="小计:"
	}
	elseif (tempGN="TOrigin")
	{
		s TOrigin="小计:"
	}
	elseif (tempGN="TStatCat")
	{
		s TStatCat="小计:"
	}
	elseif (tempGN="TEquiCat")
	{
		s TEquiCat="小计:"
	}
	
	d OutPutFinalInfo
	quit
		
OutputGetEquip
	for i=1:1:GroupLen d
	.i GN(i)'="--" d
	..i GroupNameList(i)="TEquipType" s TEquipType=GN(i)
	..i GroupNameList(i)="TName" s TName=GN(i)
	..i GroupNameList(i)="TModel" s TModel=GN(i)
	..i GroupNameList(i)="TOriginalFee" s TOriginalFee=GN(i)
	..i GroupNameList(i)="TStoreLoc" s TStoreLoc=GN(i)
	..i GroupNameList(i)="TOrigin" s TOrigin=GN(i)
	..i GroupNameList(i)="TStatCat" s TStatCat=GN(i)
	..i GroupNameList(i)="TEquiCat" s TEquiCat=GN(i)
	
	s TQuantity=$p($g(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GN(1),GN(2),GN(3),GN(4),GN(5),GN(6))),"^",10)
	s TTotalFee=$p($g(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GN(1),GN(2),GN(3),GN(4),GN(5),GN(6))),"^",5)
	s TTotalNet=$p($g(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GN(1),GN(2),GN(3),GN(4),GN(5),GN(6))),"^",11)
	s TTotalDepre=$p($g(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GN(1),GN(2),GN(3),GN(4),GN(5),GN(6))),"^",12)
	
	d OutPutFinalInfo
	quit
		
OutPutFinalInfo
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
	s TTotalNet=##Class(web.DHCEQCommon).FormatNumber(TTotalNet,"")
	s TTotalDepre=##Class(web.DHCEQCommon).FormatNumber(TTotalDepre,"")
	Set TRow=TRow+1
	s Data=$lb(TEquipType,TName,TModel,TOriginalFee,TStoreLoc,TOrigin,TStatCat,TEquipCat,TQuantity,TTotalFee,TTotalNet,TTotalDepre,TRow)
	Set ^CacheTemp(repid,index)=Data
	s index=index+1	
	s ^DHCEQTemp("EquipCollectPrint",+$H,$J,curuser,PNum)=TEquipType_"^"_TName_"^"_TModel_"^"_TOriginalFee_"^"_TStoreLoc_"^"_TOrigin_"^"_TStatCat_"^"_TEquipCat_"^"_TQuantity_"^"_TTotalFee_"^"_TTotalNet_"^"_TTotalDepre
	s PNum=PNum+1
	quit
	
SetSumValue
	f i=1:1:GroupLen  d
	.i +GroupFlagList(1)=1  d
	..s QtyList(i)=QtyList(i)+$p($g(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GN(1),GN(2),GN(3),GN(4),GN(5),GN(6))),"^",10)
	..s OriginalFeeList(i)=OriginalFeeList(i)+$p($g(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GN(1),GN(2),GN(3),GN(4),GN(5),GN(6))),"^",5)
	..s NetFeeList(i)=NetFeeList(i)+$p($g(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GN(1),GN(2),GN(3),GN(4),GN(5),GN(6))),"^",11)
	..s DepreFeeList(i)=DepreFeeList(i)+$p($g(^DHCEQTemp("EquipCollect",+$H,$J,curuser,GN(1),GN(2),GN(3),GN(4),GN(5),GN(6))),"^",12)
	quit
	
ClearSumValue
	s i=i+1
	s QtyList(i)=0
	s OriginalFeeList(i)=0
	s NetFeeList(i)=0
	s DepreFeeList(i)=0
	quit
	
ClearSum
	s QtyList(i)=0
	s OriginalFeeList(i)=0
	s NetFeeList(i)=0
	s DepreFeeList(i)=0
	quit
}

ClassMethod GetEquipCollectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipCollectExecute ]
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

ClassMethod GetEquipCollectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipCollectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 得到需要导入的数据.
ClassMethod GetEquipCollectList(num, job As %Library.String = "")
{
	i job="" s job=$j
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q $g(^DHCEQTemp("EquipCollectPrint",+$H,job,curuser,num))
}

/// w ##Class(web.DHCEQEquip).GetEquipIDByNo(3220501000073)
ClassMethod GetEquipIDByNo(No)
{
	new ID
	if No="" q ""
	Set ID = $Order(^DHCEQEquip(0,"No",No,0))
	quit ID
}

ClassMethod CheckEQData(rowid, StoreLocDR, OriginalFee, NetFee, DepreTotalFee, EquipTypeDR, StatCatDR)
{
	i rowid="" q 0
	i $p($g(^DHCEQEquip(rowid)),"^",67)'=StoreLocDR q -1
	i ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(rowid)),"^",27),"")'=##Class(web.DHCEQCommon).FormatNumber(OriginalFee,"") q -1
	i ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(rowid)),"^",28),"")'=##Class(web.DHCEQCommon).FormatNumber(NetFee,"") q -1
	i ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(rowid)),"^",35),"")'=##Class(web.DHCEQCommon).FormatNumber(DepreTotalFee,"") q -1
	i $p($g(^DHCEQEquip(rowid)),"^",63)'=EquipTypeDR q -1
	i $p($g(^DHCEQEquip(rowid)),"^",75)'=StatCatDR q -1
	q 0
}

/// 创建：zy 2014-01-07  No ZY0109
/// 描述：分摊设备查询
/// d ##Class(web.DHCEQEquip).GetCommonageFlag("CommonageFlag",150)
ClassMethod GetCommonageFlag(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=Y>分摊设备</option>"
	w "<option value=N>非分摊设备</option>"
	w "</select>",!
}

/// Mozy	2015-11-26
/// 获取管理权限科室列表
/// d ##class(%ResultSet).RunQuery("web.DHCEQEquip","GetManageLocList","1",85)
Query GetManageLocList(CurUserID As %String = "", CurGroupID As %String = "", RoleDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", LocDR As %String = "") As %Query(ROWSPEC = "row:%String,locdr:%String,loc:%String,job:%String")
{
}

ClassMethod GetManageLocListExecute(ByRef qHandle As %Binary, CurUserID As %String = "", CurGroupID As %String = "", RoleDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "", LocDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i CurUserID ="" s CurUserID = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i CurGroupID ="" s CurGroupID = %session.Get("LOGON.GROUPID")
	s job=$job
	k ^DHCEQTemp("LocTemp",CurUserID)
	k ^DHCEQTemp("GetManageLocList",CurUserID)
	s row=0
	s index=1
	
	s TStoreLocDR = ""
	f  s TStoreLocDR=$o(^DHCEQEquip("0","StoreLoc",TStoreLocDR)) quit:TStoreLocDR=""  d
	.s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	.q:TStoreLoc=""
	.s EquipID=0
	.f  s EquipID=$o(^DHCEQEquip("0","StoreLoc",TStoreLocDR,EquipID)) quit:EquipID=""  d
	..q:($p(^DHCEQEquip(EquipID),"^",60)="3")||($p(^DHCEQEquip(EquipID),"^",60)="0")
	..q:$p(^DHCEQEquip(EquipID),"^",59)="Y"
	..q:$p(^DHCEQEquip(EquipID),"^",38)>2
	..s TEquipTypeDR = $p(^DHCEQEquip(EquipID),"^",63)
	..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	..s TStatCatDR = $p(^DHCEQEquip(EquipID),"^",75)
	..s TEquiCatDR = $p(^DHCEQEquip(EquipID),"^",4)
	..s TItemDR = $p(^DHCEQEquip(EquipID),"^",7)
	..Quit:(##Class(web.DHCEQCommon).CheckManageLimit("","","",TEquipTypeDR,TStatCatDR,TEquiCatDR,TStoreLocDR,EquipID,TItemDR))
	..s ^DHCEQTemp("LocTemp",CurUserID,job,$ZCONVERT(TStoreLoc,"U"),TStoreLocDR)=1+$g(^DHCEQTemp("LocTemp",CurUserID,job,$ZCONVERT(TStoreLoc,"U"),TStoreLocDR))
	..s ^DHCEQTemp("GetManageLocList",CurUserID,+$H,job,TStoreLocDR,EquipID)=""
	
	s Loc=""
	f  s Loc=$o(^DHCEQTemp("LocTemp",CurUserID,job,Loc)) q:Loc=""  d
	.s TStoreLocDR=$o(^DHCEQTemp("LocTemp",CurUserID,job,Loc,""))
	.s TStoreLoc=##Class(web.DHCEQCommon).GetSplitDataByFlag(Loc,"-")
	.s TStoreLoc=TStoreLoc_"("_$g(^DHCEQTemp("LocTemp",CurUserID,job,Loc,TStoreLocDR))_")"
	.d OutputRowGetManageLocList
	
	k ^DHCEQTemp("LocTemp",CurUserID)
	Quit $$$OK
OutputRowGetManageLocList
	set row=row+1
	set Data=$lb(row,TStoreLocDR,TStoreLoc,$j)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetManageLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManageLocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetManageLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManageLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// MZY0122	2602957,2603399		2022-04-24	增加输出列描述
/// 获取管理权限设备列表
/// d ##class(%ResultSet).RunQuery("web.DHCEQEquip","GetManageEquipList",7300,2)
Query GetManageEquipList(Name As %String = "", job As %String = "", LocDR As %String = "", FileNo As %String = "", No As %String = "", Chk As %String = "") As %Query(ROWSPEC = "TRow:%String:序号,TRowID:%String:设备ID,TNo:%String:设备编号,TFileNo:%String:档案号,TName:%String:设备名称,TModel:%String:规格型号,TOriginalFee:%String:原值,TStatus:%String:状态,TStoreLocDR:%String:库房DR,TStoreLoc:%String:库房,TLeaveFactoryNo:%String:出厂编号,TProvider:%String:供应商,TManuFactory:%String:生产厂商,TLeaveFactoryDate:%String:出厂日期,TStartDate:%String:启用日期,TAdvanceDisFlag:%String:异常状态,TEquipType:%String:类组,TLocation:%String:存放地点,TCountry:%String:国别,TBackColor:%String:背景色")
{
}

ClassMethod GetManageEquipListExecute(ByRef qHandle As %Binary, Name As %String = "", job As %String = "", LocDR As %String = "", FileNo As %String = "", No As %String = "", Chk As %String = "") As %Status
{
	new repid, index, id
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s CurUserID = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s CurGroupID = %session.Get("LOGON.GROUPID")
	s gnum=1
	k ^DHCEQTemp("ManageEquipList",CurUserID)
	Set Name=$ZCONVERT(Name,"U")
	s TRow=0
	s index=1
	s TStoreLocDR = 0
	f  s TStoreLocDR=$o(^DHCEQEquip("0","StoreInStock",TStoreLocDR)) quit:TStoreLocDR=""  d
	.q:(LocDR'="")&&(LocDR'=TStoreLocDR)
	.s TStoreLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TStoreLocDR)
	.s TEquipTypeDR = 0
	.f  s TEquipTypeDR=$o(^DHCEQEquip("0","StoreInStock",TStoreLocDR,TEquipTypeDR)) quit:TEquipTypeDR=""  d
	..;q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	..s TEquipType = ##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
	..s ISLRowID=""
	..f  s ISLRowID=$o(^DHCEQEquip("0","StoreInStock",TStoreLocDR,TEquipTypeDR,1,"N",ISLRowID)) quit:ISLRowID=""  d
	...s TEquipID=0
	...f  s TEquipID=$o(^DHCEQEquip("0","StoreInStock",TStoreLocDR,TEquipTypeDR,1,"N",ISLRowID,TEquipID)) quit:TEquipID=""  d
	....s EQGlobal=$Get(^DHCEQEquip(TEquipID))
	....q:$p(EQGlobal,"^",38)>2
	....
	....s TStatCatDR = $p(EQGlobal,"^",75)
	....s TEquiCatDR = $p(EQGlobal,"^",4)
	....s TItemDR = $p(EQGlobal,"^",7)
	....Quit:(##Class(web.DHCEQCommon).CheckManageLimit("","","",TEquipTypeDR,TStatCatDR,TEquiCatDR,TStoreLocDR,TEquipID,TItemDR))
	....d ResetVariablesGetManageEquipList
	....s TRowID=TEquipID
	....s TNo = $p(EQGlobal,"^",71)
	....q:(No'="")&&(TNo'[No)
	....Set TFileNo=$Piece(EQGlobal,"^",85)
	....q:(FileNo'="")&&($ZCONVERT(TFileNo,"U")'[FileNo)
	....Set TName=$Piece(EQGlobal,"^",1)
	....q:(Name'="")&&($ZCONVERT(TName,"U")'[Name)&&($ZCONVERT(TNo,"U")'[Name)&&($ZCONVERT(TFileNo,"U")'[Name)
	....Set TModelDR=$Piece(EQGlobal,"^",3)
	....Set TModel = ##Class(web.DHCEQCommon).GetTrakNameByID("model", TModelDR)
	....s TOriginalFee = $p(EQGlobal,"^",27)
	....s TStatus = $p(EQGlobal,"^",38)
	....s TStatus=##Class(web.DHCEQEquip).GetEquipStatusDisplay(TStatus)
	....s TLeaveFactoryNo = $p(EQGlobal,"^",10)
	....s TLeaveFactoryDate = ##class(web.DHCEQCommon).TransValueToPage($p(EQGlobal,"^",11),"date")
	....s TBackColor = $p(EQGlobal,"^",93) //设备异常状态背景色处理
	....s TProviderDR = $p(EQGlobal,"^",25)
	....Set TProvider = ##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	....Set TManuFactoryDR = $p(EQGlobal,"^",26)
	....Set TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	....s TStartDate = ##class(web.DHCEQCommon).TransValueToPage($p(EQGlobal,"^",44),"date")
	....s TAdvanceDisFlag=##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus($Piece(EQGlobal,"^",93))
	....Quit:(Chk'="")&&(##class(web.DHCEQOperateLog).GetOperateLogInfo(52,TEquipID,2)'="")	;检测是否已经打印条码
	....Set TLocationDR = $Piece(EQGlobal,"^",72)
	....Set TLocation = ##Class(web.DHCEQCommon).GetTrakNameByID("location",TLocationDR)
	....Set TCountryDR=$p(EQGlobal,"^",16)
	....Set TCountry=##Class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
	....d OutputRowGetManageEquipList
	
	Quit $$$OK
OutputRowGetManageEquipList
	If TOriginalFee'="" Set TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
	Set TRow=TRow+1
	Set Data=$lb(TRow,TRowID,TNo,TFileNo,TName,TModel,TOriginalFee,TStatus,TStoreLocDR,TStoreLoc,TLeaveFactoryNo,TProvider,TManuFactory,TLeaveFactoryDate,TStartDate,TAdvanceDisFlag,TEquipType,TLocation,TCountry,TBackColor)
	Set ^DHCEQTemp("ManageEquipList",CurUserID,gnum)=TNo_"^"_TFileNo_"^"_TName_"^"_TModel_"^"_TOriginalFee_"^"_TStatus_"^"_TStoreLoc_"^"_TLeaveFactoryNo_"^"_TProvider_"^"_TManuFactory_"^"_TLeaveFactoryDate_"^"_TStartDate_"^"_TAdvanceDisFlag_"^"_TEquipType_"^"_TLocation_"^"_TCountry
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set gnum=gnum+1
	quit
ResetVariablesGetManageEquipList
	Set (TRowID,TNo,TFileNo,TName,TModel,TOriginalFee,TStatus,TLeaveFactoryNo,TBackColor,TProvider,TManuFactory,TLeaveFactoryDate,TStartDate,TAdvanceDisFlag,TLocation,TCountry)=""
	quit
}

ClassMethod GetManageEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManageEquipListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetManageEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManageEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQEquip).GetManageEquipListEQDRs(1,3656,302)
ClassMethod GetManageEquipListEQDRs(CurUserID As %String = "", job As %String = "", LocDR As %String = "", No As %String = "", Name As %String = "")
{
	i CurUserID="" s CurUserID = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s count=0
	s EQDRs=""
	s cjob=""
	f  s cjob=$o(^DHCEQTemp("GetManageLocList",CurUserID,+$H,cjob)) quit:cjob=""  d
	.q:(job'="")&(cjob'=job)
	.s TStoreLocDR=""
	.f  s TStoreLocDR=$o(^DHCEQTemp("GetManageLocList",CurUserID,+$H,cjob,TStoreLocDR)) quit:TStoreLocDR=""  d
	..q:(LocDR'="")&(LocDR'=TStoreLocDR)
	..s id=0
	..f  s id=$o(^DHCEQTemp("GetManageLocList",CurUserID,+$H,cjob,TStoreLocDR,id)) quit:id=""  d
	...Set EquipData=##Class(web.DHCEQEquip).GetEquipByID("","",id)
	...s TNo = $p(EquipData,"^",71)
	...q:(No'="")&(TNo'[No)
	...Set TFileNo=$Piece(EquipData,"^",85)
	...Set TName=$Piece(EquipData,"^",1)
	...q:(Name'="")&($ZCONVERT(TName,"U")'[Name)
	...s count=1 + count
	...i EQDRs'="" s EQDRs=EQDRs_"^"
	...s EQDRs=EQDRs_id
	
	q count_":"_EQDRs
}

/// add by zc 2017-02-22
/// 过滤处于业务单据里的台账数据
/// 入参:BussType 业务代码   
/// 返回值:0  不在    1 在
/// w ##Class(web.DHCEQEquip).CheckEquipInBussType(39184)
ClassMethod CheckEquipInBussType(EquipID, BussType)
{
	i EquipID="" q 0
	s flag=0
	if (BussType=31)
	{
		s MExObjID=""
		s MExObjID=$o(^DHCEQMExObj(0,"ExID",1,EquipID,0))
		i MExObjID="" q flag
		i MExObjID'="" d
		.s MMRowID=0
		.f  s MMRowID=$o(^DHCEQMMaintRequest(0,"Source",1,MExObjID,MMRowID)) q:(MMRowID="")||(flag'=0)  d
		..q:($p($g(^DHCEQMMaintRequest(MMRowID)),"^",57)="Y")	
		..q:($p($g(^DHCEQMMaintRequest(MMRowID)),"^",41)=2)
		..s flag=1	
	}
	elseif (BussType=34)
	{
		s (dlrowid,drrowid,instocklistdr)=""	
		i ($D(^DHCEQDisuseRequest(0,"Equip",EquipID))&&(flag'=1)) d
		.s drowid=0
		.f  s drowid=$o(^DHCEQDisuseRequest(0,"Equip",EquipID,drowid)) q:(drowid="")||(flag'=0)  d
		..q:$p($g(^DHCEQDisuseRequest(drowid)),"^",53)="Y"	
		..q:$p($g(^DHCEQDisuseRequest(drowid)),"^",10)=2
		..s flag=1
		e  d
		.i ($D(^DHCEQDisuseList(0,"Source",0,EquipID))&&(flag'=1)) d
		..s dlrowid=$o(^DHCEQDisuseList(0,"Source",0,EquipID,0))
		..s drrowid=$p($g(^DHCEQDisuseList(dlrowid)),"^",1)
		..q:$p($g(^DHCEQDisuseRequest(drrowid)),"^",53)="Y"	
		..q:$p($g(^DHCEQDisuseRequest(drrowid)),"^",10)=2
		..s flag=1
		.e  d
		..s instocklistdr=$p($g(^DHCEQEquip(EquipID)),"^",70)
		..q:instocklistdr=""
		..i ($D(^DHCEQDisuseList(0,"Source",1,instocklistdr))&&(flag'=1)) d
		...s drlrowid=0
		...f  s drlrowid=$o(^DHCEQDisuseList(0,"Source",1,instocklistdr,drlrowid))  q:(drlrowid="")||(flag'=1)  d
		....s drrowid=$p($g(^DHCEQDisuseList(drlrowid)),"^",1)
		....q:$p($g(^DHCEQDisuseRequest(drrowid)),"^",53)="Y"	
		....q:$p($g(^DHCEQDisuseRequest(drrowid)),"^",10)=2
		....s flag=1
	}
	q flag
}

/*// Mozy	785784	2018-12-21		迁移至web.DHCEQ.EM.BUSEquip.cls
/// 增加附属设备查询标识	空：包含附属设备	0：不包含附属设备		1:仅附属设备
ClassMethod ConfigFlag(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=>包含</option>"
	w "<option value=0>不包含</option>"
	w "<option value=1>仅附属设备</option>"
	w "</select>",!
}*/
/// Mozy0217  2018-11-01
/// w ##Class(web.DHCEQEquip).GetConfigFlag(ConfigFlag, 18192)
ClassMethod GetConfigFlag(ConfigFlag, erowid)
{
 n Flag	
 i (ConfigFlag="0")||(ConfigFlag="") q 0
 s Flag=0
 if ConfigFlag="1"
   {
	 s parentDR=$p($g(^DHCEQEquip(erowid,"OtherInfo")),"^",24)
	 i parentDR'="" d
	 .s Flag=1
	}
 if ConfigFlag="2"
	{
	 s parentDR=$p($g(^DHCEQEquip(erowid,"OtherInfo")),"^",24)
	 i parentDR="" d
	 .s Flag=1
	} 
 q Flag
}

/// Mozy0217  2018-11-01
/// w ##Class(web.DHCEQEquip).GetParentFlag(130,1)
ClassMethod GetParentFlag(OpenCheckListDR, ID)
{
	s RowID=0
	s flag=""
	f  s RowID=$o(^DHCEQEquip(0,"OpenCheckList",OpenCheckListDR,RowID)) q:(RowID="")  d
	.s parentDR=$p($g(^DHCEQEquip(RowID,"OtherInfo")),"^",24)
	.q:parentDR="" 
	.q:parentDR'=ID
	.i flag'="" d
	..s flag=flag_"^"_RowID
	.e  d
	..s flag=RowID
	q flag
}

/// w ##class(web.DHCEQEquip).GetLimitYearsNum("")
/// add hly 20200311 bug:1096983
/// Flag:100到期
/// 	-100未到期
ClassMethod GetLimitYearsNum(RowID)
{
	n (RowID)
	s Flag=0
	///modified by ZY0273 20210705
	s LimitYears=$p($g(^DHCEQEquip(RowID)),"^",31) //折旧年限
	s EQHold5=$p($g(^DHCEQEquip(RowID)),"^",80) //使用年限
	i EQHold5'="" s LimitYears=EQHold5
	s LimitYearsNum=LimitYears*12
	s StartDate=$p($g(^DHCEQEquip(RowID)),"^",44) //启用日期
	s EndDate=$SYSTEM.SQL.DATEDIFF("m",StartDate,+$h)
	i EndDate>=LimitYearsNum d
	.s Flag=100
	e  d
	.s Flag=-100
	q Flag
}

}
