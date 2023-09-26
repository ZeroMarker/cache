/// 20130304  Mozy0093
/// 修正验收明细查询Query无效标志取值错误
/// -------------------------------------------------
/// Add By HZY 2011-08-02   HZY0004
/// 描述：新增‘设备验收明细查询’功能.
/// 新增方法：GetCheckDetail查询 、GetSourceDesc、TranslateSourceID
/// -------------------------------------------------
/// Modified By HZY 2011-07-18  Bug HZY0004
/// Discription:在查询方法GetOpenCheckRequest中添加一个参数RequestNo,以实现按验收单号查询的功能。
/// -------------------------------------------------
/// Add By ZY 2011-07-05 Bug ZY0073
/// Discription:增加hold字段的显示，其中Hold1用于存储验收单号
/// -------------------------------------------------
/// Add By 党军 2010-04-07 Bug DJ0043
/// Discription:批量验收审核未入库单据及对应设备删除
/// 增加OCRToDel查询及OCREquipDelete方法
/// -------------------------------------------------
/// 修改:ZY 2009-10-30  zy0014
/// 描述:修改设备验收单的录入信息存储
/// 备注:个性需求
/// -----------------------------------------
/// 修改:ZY 2009-10-26  zy0013
/// 新增方法:CopyOpenCheckRequest
/// 目的:复制验收单
/// 描述:复制验收的全部信息,包括附件、资料
/// -----------------------------------------
/// 修改:ZY 2009-10-26  zy0013
/// 修改方法：SaveData
/// 描述:通过js直接取得机型的Rowid，即PLISTMX(6)得值
/// --------------------------------------------------
/// Modefied by zc 2014-9-23 ZC0007
/// Discription:在查询方法GetBPList中添加TPurposeTypeDR和TPurposeType两个参数
/// --------------------------------------------------
Class web.DHCEQOpenCheckRequest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 修改:ZX 2013-12-26  
/// 修改OpenCheckRequest查询，Hole2字段的档案编号  ,ProviderQuery
/// HISUI改造 modified by czf 20180928 增加入参CurRole
/// -----------------------------------------
/// 2011-07-18 Modified By HZY .
/// 描述：添加参数 RequestNo ，以实现按验收单号查询的功能。
/// 2011-10-28	Mozy0067	增加菜单传递的参数CheckTypeDR
/// 2011-10-14	Mozy0062	增加菜单传递的参数Type
Query GetOpenCheckRequest(Equip As %String = "", ManuFactoryDR As %String = "", StatusDR As %String = "", EndDate As %String = "", QXType As %String = "", InvalidFlag As %String = "N", Type As %String = "", CheckTypeDR As %String = "", AssetTypeList As %String = "", vData As %String = "", CancelOper As %String = "", CurRole As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDetail:%String,TEquip:%String,TOpenCheckDate:%String,TUseLoc:%String,TEquipCat:%String,TProvider:%String,TModel:%String,TStatus:%String,TContractNo:%String,TQuantityNum:%String,TManuFactory:%String,TRequestNo:%String,TCommonName:%String,TFileNo:%String,TRow:%String,TUnit:%String,TOriginalFee:%String,TTotalFee:%String,TCheckDate:%String,TApprovals:%String,TMakeUser:%String")
{
}

ClassMethod GetOpenCheckRequestExecute(ByRef qHandle As %Binary, Equip As %String = "", ManuFactoryDR As %String = "", StatusDR As %String = "", EndDate As %String = "", QXType As %String = "", InvalidFlag As %String = "N", Type, CheckTypeDR, AssetTypeList As %String = "", vData As %String = "", CancelOper As %String = "", CurRole As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	s rowid=0
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("7")	//add by CZF0080 2020-02-24
	//Add By QW-2014-11-04 供应商模糊查询
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set ProviderQuery=##Class(web.DHCEQCommon).GetDataByName(vData,"ProviderQuery")  //供应商模糊
	Set ProviderCHeck=##Class(web.DHCEQCommon).GetDataByName(vData,"ProviderCHeck")  //模糊包含
	Set ApproveRole=##Class(web.DHCEQCommon).GetDataByName(vData,"ApproveRole")  
	Set WaitAD=##Class(web.DHCEQCommon).GetDataByName(vData,"WaitAD")    
	Set ProviderDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")  
	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(vData,"StartDate")
	Set SDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	Set EDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	Set RequestNo=##Class(web.DHCEQCommon).GetDataByName(vData,"RequestNo")  
	Set FileNo=##Class(web.DHCEQCommon).GetDataByName(vData,"FileNo")  //档案号
	Set CommonName=##Class(web.DHCEQCommon).GetDataByName(vData,"CommonName")
	Set HospitalDR=##Class(web.DHCEQCommon).GetDataByName(vData,"HospitalDR") // Add QW20210629 BUG:QW0131 增加输入参数院区HospitalDR
	Set MakeUserDR=##Class(web.DHCEQCommon).GetDataByName(vData,"MakeUserDR")	//czf 2022-10-25
	Set UseLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
	
	i SDate="" s SDate=0
	i EDate="" s EDate=+$H
	//End By QW-2014-11-04
		
	//2011-07-18 Start Modified By HZY .
	if RequestNo'=""  d
	.s FindRequestNo=$Order(^DHCEQOpenCheckRequest(0,"RequestNo"," "_RequestNo),-1)
	.For  Set FindRequestNo=$Order(^DHCEQOpenCheckRequest(0,"RequestNo",FindRequestNo))  Quit:((FindRequestNo="")||(FindRequestNo'[RequestNo))  Do
	..Set rowid=0	
	..For  Set rowid=$Order(^DHCEQOpenCheckRequest(0,"RequestNo",FindRequestNo,rowid))  Quit:rowid=""  Do
	...d BuildDataGetOpenCheckRequest
	e  d
	.Set rowid=0
	.For  Set rowid=$Order(^DHCEQOpenCheckRequest(rowid))  Quit:rowid=""  Do
	..d BuildDataGetOpenCheckRequest
	Quit $$$OK
	//2011-07-18 End Modified By HZY .

BuildDataGetOpenCheckRequest		//2011-07-18 Modified By HZY.--去掉for循环。
	;f  s rowid=$o(^DHCEQOpenCheckRequest(rowid))  quit:rowid=""  d
	d ResetVariablesGetOpenCheckRequest
	s TRowID = rowid	//rowid
	s OCRHospID=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",38)	//czf 2021-09-01 begin
	q:##class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(OCRHospID,QXType)
	q:(HospitalDR'="")&&(HospitalDR'=OCRHospID)					//czf 2021-09-01 end
	s OCRFlag=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",45) //无效
	i OCRFlag="" s OCRFlag="N"
	q:(InvalidFlag'="")&&(InvalidFlag'=OCRFlag)
	s TStatus=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",20) //状态
	q:(StatusDR'="")&&(TStatus'=StatusDR)
	s TFileNo=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",38) //档案编号
	q:(FileNo'="")&&(TFileNo'=FileNo)
	s CurRole=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",33)
	i WaitAD="1" q:CurRole'=ApproveRole			//hisui改造 modified by czf 20180928 
	s TStatus=##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus) //状态解析
	s TProvider=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",5) //供应商
	q:(ProviderDR'="")&&(TProvider'=ProviderDR)
	i TProvider'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)  //供应商解析
	//Add By QW-2014-11-04供应商模糊查询 根据输入供应商不包括、包括、等于的所属关系查询
	if (ProviderCHeck=1)
	{
	    if (TProvider[ProviderQuery)
	    {quit}
    }
	elseif (ProviderCHeck=3)
    {
	    if (TProvider'=ProviderQuery)
	    {quit}
    }
	elseif(ProviderCHeck=2)
    {
		if (TProvider'[ProviderQuery)
	    {quit}
	}
	s TOpenCheckDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckRequest(rowid)),"^",10),"date") //开箱日期
	s TCheckDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckRequest(rowid)),"^",11),"date") //验收日期
	q:($p($g(^DHCEQOpenCheckRequest(rowid)),"^",11)>EDate)||($p($g(^DHCEQOpenCheckRequest(rowid)),"^",11)<SDate)		//czf 1929999 2021-06-17
	s OpenCheckList=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,0)) //设备批量申请明细单ID
	s TCommonName=$p($g(^DHCEQOpenCheckList(OpenCheckList)),"^", 2) //设备	//2013-06-24 DJ0118 begin
	q:(CommonName'="")&&(TCommonName'[CommonName)
	s TEquip=$p($g(^DHCEQOpenCheckList(OpenCheckList)),"^", 9)
	i TEquip'="" S TEquip=$p($g(^DHCEQCCode("DHCEQCMasterItem",TEquip)),"^",1) //2013-06-24 DJ0118 end
	q:(Equip'="")&&(TEquip'=Equip)
	s TManuFactory=$p($g(^DHCEQOpenCheckList(OpenCheckList)),"^",15) //生产厂家
	q:(ManuFactoryDR'="")&&(TManuFactory'=ManuFactoryDR)
	i TManuFactory'="" s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactory)  //$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactory)),"^",1)	//modified by CZF0093 2020-03-17
	s TUseLoc = $p($g(^DHCEQOpenCheckList(OpenCheckList)),"^",33)  //使用科室
	q:(UseLocDR'="")&&(TUseLoc'=UseLocDR)	/// modified by ZY0270 20210616
	Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TUseLoc) ;Add QW20210629 BUG:QW0131
	q:(HospitalDR'="")&&(HospitalDR'=THospitalDR) ;Add QW20210629 BUG:QW0131
	i TUseLoc'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	s TEquipCat = $p($g(^DHCEQOpenCheckList(OpenCheckList)),"^",6) //设备分类
	i TEquipCat'="" s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCat)),"^",2)
	s TModel = $p($g(^DHCEQOpenCheckList(OpenCheckList)),"^",5)  //规格型号
	i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	s TContractNo = $p($g(^DHCEQOpenCheckList(OpenCheckList)),"^",36) //合同号
	s TQuantityNum = $p($g(^DHCEQOpenCheckList(OpenCheckList)),"^",16) //数量
	s StoreLocDR=$p($g(^DHCEQOpenCheckList(OpenCheckList)),"^",31) //设备库房 2010-10-26 DJ begin
	s Find=0
	i StoreLocDR'=""  d
	.s Find=##Class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocDR)
	q:Find'=0 //2010-10-26 DJ End
	s TEquipTypeDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",2)
	s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	q:+result'=0
	s result=##class(web.DHCEQCommon).FundsTypeIsIn(0,OpenCheckList)	// Mozy0231	资金来源类型
	q:+result'=0
	s TRequestNo=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",37) //验收单号
	s TMakeUserDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",39)	//制单人
	q:(MakeUserDR'="")&&(MakeUserDR'=TMakeUserDR)
	s TMakeUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TMakeUserDR)
	/// Mozy0145	20141017
	Set OCLStatCatDR=$Piece($Get(^DHCEQOpenCheckList(OpenCheckList)),"^",28)
	///add 20191012 by zy 增加控制
	Set AssetType=""
	i OCLStatCatDR'="" Set AssetType=$Piece($Get(^DHCEQCCode("DHCEQCStatCat",OCLStatCatDR)),"^",10)
	Quit:(AssetTypeList>0)&(AssetType'=AssetTypeList)
	s TRow=TRow+1		//Add By DJ 2015-09-21 DJ0165 begin
	s TUnit=$p($g(^DHCEQOpenCheckList(OpenCheckList)),"^",7)
	i TUnit'="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQOpenCheckList(OpenCheckList)),"^",17),"")
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee,"")		//Add By DJ 2015-09-21 DJ0165 end
	s AIRowID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	s TApprovals="无"
	i AIRowID'="" Do
	.s CurRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",4)
	.s TApproveRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	.i TApproveRole'="" s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRole),"^",2)	//add by CZF0080 2020-02-24
	i $p($g(^DHCEQOpenCheckRequest(rowid)),"^",20)=0 s TApprovals="" //modified by czf 1214221 2020-03-05
	d OutputRowGetOpenCheckRequest
	quit
OutputRowGetOpenCheckRequest
	s Data=$lb(TRowID,TDetail,TEquip,TOpenCheckDate,TUseLoc,TEquipCat,TProvider,TModel,TStatus,TContractNo,TQuantityNum,TManuFactory,TRequestNo,TCommonName,TFileNo,TRow,TUnit,TOriginalFee,TTotalFee,TCheckDate,TApprovals,TMakeUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOpenCheckRequest
	s (TRowID,TDetail,TEquip,TOpenCheckDate,TUseLoc,TEquipCat,TProvider,TModel,TStatus,TContractNo,TQuantityNum,TManuFactory,TRequestNo,TCommonName,TFileNo,TUnit,TOriginalFee,TTotalFee,TCheckDate,TApprovals,TMakeUserDR,TMakeUser)=""
	quit
}

ClassMethod GetOpenCheckRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpenCheckRequestExecute ]
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

ClassMethod GetOpenCheckRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpenCheckRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetApproveSet(OCID)
{
	i OCID="" q ""
	q $P($g(^DHCEQOpenCheckRequest(OCID)),"^",32)
}

/// w ##class(web.DHCEQOpenCheckRequest).GetOneOpenCheckRequest(406)
ClassMethod GetOneOpenCheckRequest(rowid)
{
	new result,resultex, resultmx, mxrowid
	s (result,resultex, resultmx, mxrowid)=""
	s result= ^DHCEQOpenCheckRequest(rowid)
	s resultex=rowid
	s resultex=resultex_"^"
	i $p(result,"^", 1)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 1)
	s resultex=resultex_"^"
	i $p(result,"^", 1)'="" d
	.i $p(result,"^", 1)=0 d
	..s resultex=resultex_##class(web.DHCEQCommon).GetEditCheckTypeDisplay(0)
	.i $p(result,"^", 1)=1 d
	..s resultex=resultex_##class(web.DHCEQCommon).GetEditCheckTypeDisplay(1)
	.i $p(result,"^", 1)=2 d
	..s resultex=resultex_##class(web.DHCEQCommon).GetEditCheckTypeDisplay(2)
	s resultex=resultex_"^"
	i $p(result,"^", 2)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 2)
	s resultex=resultex_"^"
	i $p(result,"^", 2)'="" d //EquipTypeDR
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^", 3)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 3)
	s resultex=resultex_"^"
	i $p(result,"^", 3)'="" d //PurchaseTypeDR
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurchaseType",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^", 4)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 4)
	s resultex=resultex_"^"
	i $p(result,"^", 4)'="" d //StatCatDR
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p(result,"^",4))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^", 5)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 5)
	s resultex=resultex_"^"
	i $p(result,"^", 5)'="" d //ProviderDR
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",5))
	s resultex=resultex_"^"
	i $p(result,"^", 8)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 8)
	s resultex=resultex_"^"
	i $p(result,"^", 8)'="" d //OriginDR
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCOrigin",$p(result,"^",8))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^", 9)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 9)
	s resultex=resultex_"^"
	i $p(result,"^", 9)'="" d //FromDeptDR
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",9))),"^",2)
	s mxrowid=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest", rowid, 0))
	s resultmx=^DHCEQOpenCheckList(mxrowid)
	Set $Piece(resultmx,"^",17)=##Class(web.DHCEQCommon).FormatNumber($Piece(resultmx,"^",17),"")
	Set $Piece(resultmx,"^",18)=##Class(web.DHCEQCommon).FormatNumber($Piece(resultmx,"^",18),"")
	Set $Piece(resultmx,"^",35)=##Class(web.DHCEQCommon).FormatNumber($Piece(resultmx,"^",35),"")
	s resultex=resultex_"^"
	i $p(resultmx,"^",6)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 6)
	s resultex=resultex_"^"
	i $p(resultmx,"^",6)'="" d //EquipCat
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(resultmx,"^",6))),"^",2)
	s resultex=resultex_"^"
	i $p(resultmx,"^",13)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 13)
	s resultex=resultex_"^"
	i $p(resultmx,"^",13)'="" d //BuyType
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBuyType",$p(resultmx,"^",13))),"^",2)
	s resultex=resultex_"^"
	i $p(resultmx,"^",31)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 31)
	s resultex=resultex_"^"
	i $p(resultmx,"^",31)'="" d //StoreLoc
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(resultmx,"^",31))
	s resultex=resultex_"^"
	i $p(resultmx,"^",50)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 50)
	s resultex=resultex_"^"
	i $p(resultmx,"^",50)'="" d //PackType
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPackType",$p(resultmx,"^",50))),"^",2)
	s resultex=resultex_"^"
	i $p(resultmx,"^",7)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 7)
	s resultex=resultex_"^"
	i $p(resultmx,"^",7)'="" d //Uom
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(resultmx,"^",7))
	s resultex=resultex_"^"
	i $p(resultmx,"^",5)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 5)
	s resultex=resultex_"^"
	i $p(resultmx,"^",5)'="" d //Model
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(resultmx,"^",5))),"^",2)
	s resultex=resultex_"^"
	i $p(resultmx,"^",11)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 11)
	s resultex=resultex_"^"
	i $p(resultmx,"^",11)'="" d //country
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("cou",$p(resultmx,"^",11))
	s resultex=resultex_"^"
	i $p(resultmx,"^",21)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 21)
	s resultex=resultex_"^"
	i $p(resultmx,"^",21)'="" d //currency
	.;s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("cur",$p(resultmx,"^",21))
	.s resultex=resultex_$P(^DHCEQCCode("DHCEQCTree",$p(resultmx,"^",21)),"^",3)
	s resultex=resultex_"^"
	i $p(resultmx,"^",24)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 24)
	s resultex=resultex_"^"
	i $p(resultmx,"^",24)'="" d //PurposeType
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurposeType",$p(resultmx,"^",24))),"^",2)
	s resultex=resultex_"^"
	i $p(resultmx,"^",15)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 15)
	s resultex=resultex_"^"
	i $p(resultmx,"^",15)'="" d //ManuFactory
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p(resultmx,"^",15))	 //modified by CZF0093 2020-03-17
	s resultex=resultex_"^"
	i $p(resultmx,"^",25)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 25)
	s resultex=resultex_"^"
	i $p(resultmx,"^",25)'="" d //Service
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("cservice",$p(resultmx,"^",25))	 //modified by czf 2020-04-01
	s resultex=resultex_"^"
	i $p(resultmx,"^",33)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 33)
	s resultex=resultex_"^"
	s OCLLRowID=$o(^DHCEQOpenCheckListLoc(0,"OpenCheckList",mxrowid,0))
	i OCLLRowID'=""  d
	.s $p(resultmx,"^",33)=$p($g(^DHCEQOpenCheckListLoc(OCLLRowID)),"^",3)
	i $p(resultmx,"^",33)'="" d //UseLoc
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(resultmx,"^",33))
	s resultex=resultex_"^"
	i $p(resultmx,"^",20)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 20)
	s resultex=resultex_"^"
	i $p(resultmx,"^",20)'="" d //DepreMethod
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDepreMethod",$p(resultmx,"^",20))),"^",2)
	s resultex=resultex_"^"
	i $p(resultmx,"^",47)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 47)
	s resultex=resultex_"^"
	i $p(resultmx,"^",47)'="" d //InstallLoc
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(resultmx,"^",47))
	s resultex=resultex_"^"
	i $p(resultmx,"^",30)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 30)
	s resultex=resultex_"^"
	i $p(resultmx,"^",30)'="" d //WorkUom
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(resultmx,"^",30))
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 37)
	s contactlistrowid=$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 37)
	s contactrowid=""
	s resultex=resultex_"^"
	i contactlistrowid'="" d
	.s resultex=resultex_$p($g(^DHCEQContractList(contactlistrowid)),"^",1)
	.s contactrowid=$p($g(^DHCEQContractList(contactlistrowid)),"^",1)
	s resultex=resultex_"^"
	i contactrowid'="" d
	.s resultex=resultex_$p($g(^DHCEQContract(contactrowid)),"^",1)
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date") //OpenCheckDate
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date") //CheckDate
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 6) //ProviderHandler
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 7) //ProviderTel
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 12) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 13) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 14) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 15) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 16) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 17) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 18) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 19) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 20) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 21) //
	//s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 28) //
	s RejectReason=##class(web.DHCEQApproveList).GetRejectReasonList("7",rowid)
	s resultex=resultex_"^"_RejectReason
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 32) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 33) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 34) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 35) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 36) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 2) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 4) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 8) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 9) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 16) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 17) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 18) //
	s resultex=resultex_"^"_##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQOpenCheckList(mxrowid)),"^", 19),0,0)   //add by jyp 2018-02-26 546037
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 22) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 26) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 27) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 29) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 35) //
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 36) //
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^",38),"bool") //医疗设备标志
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^",39),"bool") //计量标志
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^",40),"bool") //科研标志
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^",41),"bool") //急购标志
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^",42),"bool") //保修标志
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^",43),"date") //保修开始日期
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^",44),"date") //保修结束日期
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^",48),"date") //安装日期
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^",49),"date") //出厂日期
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^",10),"date") //制造日期
	//s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 55) //
	s resultex=resultex_"^"_$g(^DHCEQOpenCheckList(mxrowid,"EX")) //2009-08-17 党军
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 55)   
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 56)   
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 57)   
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 58)   
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 59) 
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^",60),"bool") //2009-11-25 党军 bgein DJ0037
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^",61),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^",62),"bool")
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 63)
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 64)
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 65) //2009-11-25 党军 end DJ0037
	s resultex=resultex_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p(resultmx,"^",15))		//modified by czf 1252357
	s resultex=resultex_"^"
	i $p(resultmx,"^",26)'="" d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCLocation",$p(resultmx,"^",26))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^", 37)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 37)
	s resultex=resultex_"^"
	i $p(result,"^", 38)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 38)
	s resultex=resultex_"^"
	i $p(result,"^", 39)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 39)
	s resultex=resultex_"^"
	i $p(result,"^", 40)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 40)
	s resultex=resultex_"^"
	i $p(result,"^", 41)'="" d
	.s resultex=resultex_$p($g(^DHCEQOpenCheckRequest(rowid)),"^", 41)
	//Function:Funds 2012-2-16  返回验收明细ID，用于资金来源
	Set resultex=resultex_"^"_mxrowid		;Mozy0075	2011-12-31
	s resultex=resultex_"^"		//2013-06-24 DJ0118
	i $p(resultmx,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(resultmx,"^",9))),"^",1)
	s resultex=resultex_"^"		//2013-12-12 DJ0122
	i $p(resultmx,"^",58)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBrand",$p(resultmx,"^",58))),"^",3)
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 66)
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 67)
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 68)
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 69)
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 70)
	s resultex=resultex_"^"
	i $p($g(^DHCEQOpenCheckList(mxrowid)),"^", 68)'="" d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 68))
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 71)  //modify BY:GBX 会计凭证号
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(mxrowid)),"^", 72),"bool")	;放射标志
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(mxrowid)),"^", 73),"bool")	;中医标志 Modify DJ 2017-01-20
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 74)
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 75)
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 76)
	Set resultex=resultex_"^"
	If $Piece(resultmx,"^",59)'="" Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",$Piece(resultmx,"^",59))),"^",2)
	Set resultex=resultex_"^"_$Get(^DHCEQOpenCheckList(mxrowid,"FileNo"))	//20150819  Mozy0159
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 77)	//Mozy  2018-05-15   128
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 78)	//Mozy  2018-05-15  
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(mxrowid)),"^", 79),"date")
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 80)	//Mozy  2018-05-15  
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 81)	//Mozy  2018-05-15  
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 82)	//Mozy  2018-05-15  
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 83)	//zy  2018-05-15  
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 84)	//zy  2018-05-15  
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 85)	//zy  2018-05-15  
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 86)	//zy  2018-05-15 
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 87)	//czf 2022-09-15 138
	
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("7",rowid)	//^^^^^^^^^
	//s CancelFlag=$p(AppInfo,"^", 7)
	s resultex=resultex_"^"_AppInfo
	s resultex=resultex_"^"_$g(^DHCEQOpenCheckList(mxrowid,"MFInfo"))		// MZY0070	1756493		2021-02-20 ^
	s resultex=resultex_"^"_$Get(^DHCEQOpenCheckList(mxrowid,"TempBar"))	// MZY0074	1904154		2021-04-30 151
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 88)	//OCL_ConfigLicense     
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 89)	//OCL_NewOldPercent
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 90)	//OCL_Voltage
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 91)	//OCL_Electriccurrent
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 92)	//OCL_UseYearsNum
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 93)	//OCL_Note
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 94)	//OCL_MaintNote
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(mxrowid)),"^", 95),"bool")	//OCL_Hold16
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 96)	//OCL_Hold17
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 97)	//OCL_Hold18
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 98)	//OCL_Hold19
	s resultex=resultex_"^"_$p($g(^DHCEQOpenCheckList(mxrowid)),"^", 99)	//OCL_Hold20
	//QW202201712 保管人
	///add by ZY 20220913 2907381、2907386、2907390
	s resultex=resultex_"^"	
	i $p(resultmx,"^",85)'="" d
	.s resultex=resultex_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(resultmx,"^",85))	//KeepUser 164
		
	s resultex=resultex_"^"_$p(resultmx,"^", 100)	//OCL_AuthorizeDeptDR 165
	s resultex=resultex_"^"_$p(resultmx,"^", 101)	//OCL_UseSubjectDR 166
	s resultex=resultex_"^"_$p(resultmx,"^", 102)	//OCL_BuyModeDR 167
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^", 103),"date")	//OCL_AccountDate 168 czf 2022-10-31
	
	s resultex=resultex_"^"	
	i $p(resultmx,"^",100)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("authorizedept",$p(resultmx,"^",101))	//169
	
	s resultex=resultex_"^"	
	i $p(resultmx,"^",101)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("usesubject",$p(resultmx,"^",101))	//170

	s resultex=resultex_"^"	
	i $p(resultmx,"^",102)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("buymode",$p(resultmx,"^",102))	//171
	
	s resultex=resultex_"^"_$p(resultmx,"^", 104)	//ManageUserDR 172
	s resultex=resultex_"^"	
	i $p(resultmx,"^",104)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(resultmx,"^",104))	//173
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(resultmx,"^",105),"date")	//PurchaseDate 174
	s resultex=resultex_"^"_$p(resultmx,"^",108)	//ManageCat 175 add by txr 20230417
	
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10)," ")
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$c(10)," ")
	s resultex=##class(web.DHCEQCommon).Replace(resultex,"'","")
	q resultex
}

/// Info:卫计委资产专属信息
/// 修改:ZY 2009-10-30  zy0014
/// 描述:修改验收单录入的信息保存
/// -----------------------------------------
/// 修改:ZY 2009-10-26  zy0013
/// 描述:通过js直接取得机型的Rowid，即PLISTMX(6)得值
/// w ##Class(web.DHCEQOpenCheckRequest).SaveData("","",4,1)
/// add by QW 2017-12-01 bug号:QW0009 增加验收可编辑字段
/// modify by JYP 2018-12-21 添加参数EquipAttribute用于保存EquipAttribute
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "", Info As %Library.String = "", InFlag As %Library.String = "0", OutFlag As %Library.String = "0", editFieldsInfo As %Library.String = "", CheckInStockType As %Library.String = "", EquipAttribute As %Library.String = "")
{
 k rowid
 s rowid=$p(val,"^",1)
 s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 s Date=+$H
 s Time=$P($H,",",2)
 s CurRole=$p(val,"^",3)	
 s ApproveType=##class(web.DHCEQApproveList).GetApproveType("7")
 Set $ZT="ERROR" //2009-07-10 党军
 s AuditFlag=0
	 
 i (+isDel=1) //删除
 {
	 TSTART
 	 s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,0))
 	 s type=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
 	 s id=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
 	 s oldnum=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
	 s OCLUseLocDR=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",33)
	 s return=..SourceUpdate(type,id,oldnum,2,OCLUseLocDR)
	 if return
	 {
		 TROLLBACK
		 q return
	 }
	 &SQL(Update SQLUSER.DHC_EQOpenCheckRequest set OCR_InvalidFlag='Y',OCR_CancelUser=:User,OCR_CancelDate=:Date,OCR_CancelTime=:Time where OCR_RowID=:rowid)
	 if SQLCODE
	 {
	   TROLLBACK
	   q SQLCODE
	 }
	 Set return=##Class(web.DHCEQOpenCheckRequest).SaveDataForInfo(Info,"","",1)
	 if return
	 {
		TROLLBACK
		Quit return
	 }
	 Set return=##Class(web.DHCEQOpenCheckRequest).DeleteContractAffix(rowid)	
	 if return
	 {
		TROLLBACK
		Quit return
	 }
	 TCOMMIT
	 q ""
 }
 i rowid'=""
 {
	 s InvalidFlag=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",45)
	 i InvalidFlag="Y" q -1015
 }
 
 i (+isDel=2) //新增,更新
 {
	 /************设备批量审批总单****************/
 	s PLIST(2)=$p(val,"^",59) 
 	s PLIST(3)=$p(val,"^",5)
 	s PLIST(4)=$p(val,"^",4)
 	s PLIST(5)=$p(val,"^",6)
 	s PLIST(6)=$p(val,"^",20)   ;Provider
 	s PLIST(7)=$p(val,"^",21)
 	s PLIST(8)=$p(val,"^",22)
 	s PLIST(9)=$p(val,"^",31)
 	s PLIST(10)=$p(val,"^",41)
 	;20150807  Mozy0157
 	s PLIST(11) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",61),"date")
 	s PLIST(12) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",60),"date")
 	s PLIST(13)=$p(val,"^",53)
 	s PLIST(14)=$p(val,"^",50)
 	s PLIST(15)=$p(val,"^",51)
 	s PLIST(16)=$p(val,"^",47)
 	s PLIST(17)=$p(val,"^",56)
 	s PLIST(18)=$p(val,"^",52)
 	s PLIST(19)=$p(val,"^",48)
 	s PLIST(20)=$p(val,"^",49)
 	s PLIST(21)="0"
 	s PLIST(22)=$p(val,"^",55)
 	s PLIST(29)=$p(val,"^",54)
 	
 	//s PLIST(38)=$p(val,"^",76)		//RequestHold1  存验收单号
 	s PLIST(39)=$p(val,"^",77)		//RequestHold2 
 	s PLIST(40)=$p(val,"^",78)		//RequestHold3
 	s PLIST(41)=$p(val,"^",79)		//RequestHold4
 	s PLIST(42)=$p(val,"^",80)		//RequestHold5
 	s PLIST(46)="N"					//InvalidFlag
 	/************设备批量审批细单****************/
 	s PLISTMX(3)=$p(val,"^",81)		//2013-06-24 DJ0118
 	s PLISTMX(4)=$p(val,"^",5)
 	s PLISTMX(5)=$p(val,"^",11)
 	s PLISTMX(6)=$p(val,"^",14)
 	s PLISTMX(7)=$p(val,"^",7)
 	s PLISTMX(8)=$p(val,"^",13)
 	s PLISTMX(9)=$p(val,"^",3)
 	s PLISTMX(10)=$p(val,"^",62)
 	s PLISTMX(11) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",24),"date")	;20150807  Mozy0157
 	s PLISTMX(12)=$p(val,"^",15)
 	//s PLISTMX(13)=""
 	s PLISTMX(14)=$p(val,"^",9)
 	//s PLISTMX(15)=""
 	s PLISTMX(16)=$p(val,"^",23)      ;ManuFactory
 	s PLISTMX(17)=$p(val,"^",17)
 	s PLISTMX(18)=$p(val,"^",29)
 	s PLISTMX(19)=$p(val,"^",30)
 	s PLISTMX(20)=$p(val,"^",33)
 	s PLISTMX(21)=$p(val,"^",34)
 	s PLISTMX(22)=$p(val,"^",16)
 	s PLISTMX(23)=$p(val,"^",8)
 	s PLISTMX(24)=$p(val,"^",4)
 	s PLISTMX(25)=$p(val,"^",18)
 	s PLISTMX(26)=$p(val,"^",26)
 	s PLISTMX(27)=$p(val,"^",27)
 	s PLISTMX(28)=$p(val,"^",28)
 	s PLISTMX(29)=$p(val,"^",6)
 	s PLISTMX(30)=$p(val,"^",37)
 	s PLISTMX(31)=$p(val,"^",38)
 	s PLISTMX(32)=$p(val,"^",10)
 	//s PLISTMX(33)=""
 	s PLISTMX(34)=$p(val,"^",32)
 	s PLISTMX(35)=$p(val,"^",55)
 	s PLISTMX(36)=$p(val,"^",19)
 	s PLISTMX(37)=$p(val,"^",58)
 	s PLISTMX(38)=$p(val,"^",57)
 	;20150807  Mozy0157
 	i $p(val,"^",45)'=""  s PLISTMX(39) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",45),"bool") ;
 	i $p(val,"^",44)'=""  s PLISTMX(40) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",44),"bool") ;
 	i $p(val,"^",46)'=""  s PLISTMX(41) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",46),"bool") ;
 	i $p(val,"^",43)'=""  s PLISTMX(42) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",43),"bool") ;
 	i $p(val,"^",42)'=""  s PLISTMX(43) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",42),"bool") ;
 	s PLISTMX(44) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",39),"date")
 	s PLISTMX(45) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",40),"date")
 	s PLISTMX(46) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",61),"date")
 	s PLISTMX(47) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",60),"date")
 	s PLISTMX(48)=$p(val,"^",36)
 	s PLISTMX(49) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",35),"date")
 	s PLISTMX(50) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",25),"date")
 	
	s PLISTMX(51)=$p(val,"^",12) 
	s PLISTMX(56)=$p(val,"^",65)  
	s PLISTMX(57)=$p(val,"^",66)  
	s PLISTMX(58)=$p(val,"^",67)  
	s PLISTMX(59)=$p(val,"^",68)  
	s PLISTMX(60)=$p(val,"^",69) 
	s LeaveFactoryIDs=$TRANSLATE($p(val,"^",64),"，",",")	//201702-04	Mozy
	i $p(val,"^",70)'=""  s PLISTMX(61) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",70),"bool") ;
	i $p(val,"^",71)'=""  s PLISTMX(62) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",71),"bool") ;
	i $p(val,"^",72)'=""  s PLISTMX(63) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",72),"bool") ;
	s PLISTMX(64)=$p(val,"^",73) ;sourcetype
	s PLISTMX(65)=$p(val,"^",74) ;sourceid
	s PLISTMX(66)=$p(val,"^",75)
	s PLISTMX(67)=$p(val,"^",82)  //价值类型
	s PLISTMX(68)=$p(val,"^",83)  //使用方向
	s PLISTMX(69)=$p(val,"^",84)  //UserDR
	//modify by QW0008 通过系统配置来设置入账形式的值
	s AccountShapeFlag=+##class(web.DHCEQCommon).GetSysInfo("990057")
	i AccountShapeFlag=1 s PLISTMX(70)="0"  //入账形式
	else  s PLISTMX(70)=$p(val,"^",85)  //入账形式
	s PLISTMX(71)=$p(val,"^",86)  //项目预算编号
	s PLISTMX(72)=$p(val,"^",87)  //会计凭证号
	i $p(val,"^",88)'="" s PLISTMX(73) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",88),"bool")	//Hold6		放射标志
	i $p(val,"^",89)'="" s PLISTMX(74) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",89),"bool")	//Hold7		中医标志	//Modify DJ 2017-01-20
	s PLISTMX(75)=$p(val,"^",90)  //Hold8
	s PLISTMX(76)=$p(val,"^",91)  //Hold9
	s PLISTMX(77)=$p(val,"^",92)  //Hold10
	s FileNo=$TRANSLATE($p(val,"^",93),"，",",")	//201702-04	Mozy
	s PLISTMX(78)=$p(val,"^",94)  //OCL_ServiceHandler
	s PLISTMX(79)=$p(val,"^",95)  //OCL_ServiceTel
	s PLISTMX(80)=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",96),"date")  //OCL_MeasureDate
	s PLISTMX(81)=$p(val,"^",97)  //OCL_MeasureNos
	s PLISTMX(82)=$p(val,"^",98)  //OCL_SalesManager		//Mozy	2018-5-15
	s PLISTMX(83)=$p(val,"^",99)  //OCL_SalesManagerTel	//Mozy	2018-5-15
	s PLISTMX(84)=$p(val,"^",100)  //OCL_Hold11	//zy	2018-5-15
	s PLISTMX(85)=$p(val,"^",101)  //OCL_Hold12	//zy	2018-5-15
	s PLISTMX(86)=$p(val,"^",102)  //OCL_Hold13	//zy	2018-5-15
	s PLISTMX(87)=$p(val,"^",103)  //OCL_Hold14	//zy	2018-5-15
	s PLISTMX(88)=$p(val,"^",104)  //OCL_Hold15	//zy	2018-5-15
	
 	i (rowid="")  //新增按钮操作
 	{
		TSTART
		s PLIST(38)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQOpenCheckRequest",Date,"",$p(val,"^",5))
	 	&SQL(Insert Into SQLUSER.DHC_EQOpenCheckRequest Values :PLIST())
	 	if SQLCODE
	 	{
			TROLLBACK
		 	q SQLCODE
	 	}
	 	s OCRRowID=$G(%ROWID)
	 	s PLISTMX(2)=OCRRowID
	 	&SQL(Insert Into SQLUSER.DHC_EQOpenCheckList Values :PLISTMX())
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
		}
		s OCLRowID=$G(%ROWID) //2009-08-17 党军
		s ^DHCEQOpenCheckList(OCLRowID,"EX")=LeaveFactoryIDs //2009-08-17 党军
		s ^DHCEQOpenCheckList(OCLRowID,"FileNo")=FileNo	//20150819  Mozy0159
		s ^DHCEQOpenCheckList(OCLRowID,"MFInfo")=$p(val,"^",105)_"^"_$p(val,"^",106)	//联系人^联系方式
		s return=..SourceUpdate(PLISTMX(64),PLISTMX(65),PLISTMX(17),1)
		if return
		{
			TROLLBACK
			q return
		}
		//Function:Funds	2012-2-16 生成资金来源信息
		;Modified By JDL 2012-2-15 JDL0116
		s OCLAmount=$p(^DHCEQOpenCheckList(OCLRowID),"^",16)*$p(^DHCEQOpenCheckList(OCLRowID),"^",17)
		s return=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(0,OCLRowID,OCLAmount)
		if return
		{
			TROLLBACK
			q return
		}
		/// Mozy0145	20141017
		Set return=##Class(web.DHCEQOpenCheckRequest).SaveDataForInfo(Info,0,OCLRowID,2)
		if return
		{
			TROLLBACK
			Quit return
		}
		// Mozy		20181123 把合同明细对应的DHC_EQCContractConfig的内容写到验收单明细对应的表中/DHC_EQAffix/DHC_EQDoc/DHC_EQConfig
		if (PLISTMX(64)=1)||(PLISTMX(64)=4)
		{
			Set return=##Class(web.DHCEQContractConfig).SaveConfigBySource(PLISTMX(65),OCLRowID)
			if return
			{
				TROLLBACK
				Quit return
			}
		}
		// begin add by jyp jyp 2019-09-02 设备新增时保存验收单设备属性
		Set return=##Class(web.DHCEQ.EM.BUSEquipAttribute).SaveOpenCheckEquipAttribute(2,OCLRowID,EquipAttribute)
		if return
		{
			TROLLBACK
			Quit return
		}
 	}
 	else  //更新按钮操作
 	{
		TSTART
	 	s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,0))
	 	s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	 	s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
	 	s OCLNum=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
	 	&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Values :PLIST() where OCR_RowID=:rowid)
	 	if SQLCODE
	 	{
			TROLLBACK
		 	q SQLCODE
	 	}
	 	&SQL(Update SQLUSER.DHC_EQOpenCheckList Values :PLISTMX() where OCL_OpenCheckRequestDR=:rowid)
	 	if SQLCODE
	 	{
			TROLLBACK
			q SQLCODE
		}
	 	s OCRRowID=rowid
	 	s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0)) //2009-08-17 党军
	 	s ^DHCEQOpenCheckList(OCLRowID,"EX")=LeaveFactoryIDs //2009-08-17 党军
	 	Set ^DHCEQOpenCheckList(OCLRowID,"FileNo")=FileNo	//20150819  Mozy0159
		s return=..SourceUpdate(OCLSourceType,OCLSourceID,OCLNum,2)
		if return
		{
			TROLLBACK
			q return
		}
		s return=..SourceUpdate(PLISTMX(64),PLISTMX(65),PLISTMX(17),1)
		if return
		{
			TROLLBACK
			q return
		}
	 	//Function:Funds	2012-2-16 生成资金来源信息
		s OCLAmount=$p(^DHCEQOpenCheckList(OCLRowID),"^",16)*$p(^DHCEQOpenCheckList(OCLRowID),"^",17)
		s return=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(0,OCLRowID,OCLAmount)
		if return
		{
			TROLLBACK
			q return
		}
		Set return=##Class(web.DHCEQOpenCheckRequest).SaveDataForInfo(Info,0,OCLRowID,2)
		if return
		{
			TROLLBACK
			Quit return
		}
				// begin add by jyp 2019-09-02 设备新增时保存验收单设备属性
		Set return=##Class(web.DHCEQ.EM.BUSEquipAttribute).SaveOpenCheckEquipAttribute(2,OCLRowID,EquipAttribute)
		if return
		{
			TROLLBACK
			Quit return
		}
 	}
 	s InvoiceNo=$p(val,"^",65)
	s SQLCODE=##Class(web.DHCEQInStockNew).UpdateInvoiceInfo(OCLRowID, InvoiceNo, "", "", 6)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	TCOMMIT
 	if SQLCODE  q SQLCODE
 	q OCRRowID
 }
 i (+isDel=3) //提交
 {
	 ;Add by jdl 2011-5-11 JDL0081
	 if (##Class(web.DHCEQPayPlan).CheckPayPlan(2,rowid)="-2") q -1010
	 s Status=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",20) //状态
	 if Status'="0" q -2015   //该记录状态不符合,不能执行操作!
	 n PLISTTJ
	 s PLISTTJ(21)="1"
	 s PLISTTJ(23)=User
	 s PLISTTJ(24)=Date
	 s PLISTTJ(25)=Time
	 s ocrrowid=rowid
	 s EquipType=$P(^DHCEQOpenCheckRequest(rowid),"^",2)
	 s PurchaseType=$P(^DHCEQOpenCheckRequest(rowid),"^",3)
	 s YearFlag=""
	 s oclrowid=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,0))
	 s MaxPrice=$P(^DHCEQOpenCheckList(oclrowid),"^",17)
	 s SpecialType=..GetSpecialType(oclrowid)
	 s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag)
	 i ApproveSet="" q -4007
	 TSTART
	 s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,ocrrowid,"7",User)
	 i SQLCODE
	 {
	 	TROLLBACK
	 	q SQLCODE
	 }
	 s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, ocrrowid, 0, "")
	 s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	 s LastFlag=$P(ApproveFlow,"^",1)
	 s NextStep=$P(ApproveFlow,"^",2)
	 s NextRole=$P(ApproveFlow,"^",3)
	 s AppInfoStatus="1"	 
	 i CheckInStockType="Y" s LastFlag="Y"	 //add by lmm 2019-08-21
	 i AutoAuditFlag="Y"
	 {
	 	i NextStep="" s PLISTTJ(21)="2"
	 	i LastFlag="Y" s PLISTTJ(21)="2"
	 	i (NextStep="")||(LastFlag="Y")
	 	{
		 	s AuditFlag=1
		 	s AppInfoStatus="2"
		 	s ContractList=$P(^DHCEQOpenCheckList(oclrowid),"^",37)
		 	s Quantity=$P(^DHCEQOpenCheckList(oclrowid),"^",16)
		 	s combindata=ocrrowid_"^"_ContractList_"^"_Quantity
	 		s SQLCODE=..SaveData("","", combindata, "5", "", InFlag,OutFlag)	;20170327 Mozy0184
			if SQLCODE<0
			{
	 			TROLLBACK
	 			q SQLCODE
			}
	 	}
	 }
	 s PLISTTJ(33)=ApproveSet
	 s PLISTTJ(34)=NextRole
	 s PLISTTJ(35)=NextStep
	 s PLISTTJ(36)=""
	 s PLISTTJ(37)=""
	 s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,rowid,NextRole,NextStep,"","",AppInfoStatus)
	 If SQLCODE
	 {
		 TROLLBACK
		 Quit SQLCODE
	 }
	 &SQL(Update SQLUSER.DHC_EQOpenCheckRequest Values :PLISTTJ() where OCR_RowID=:ocrrowid)
	 if SQLCODE
	 {
	 	TROLLBACK
		q SQLCODE
	 }
	 ;Modified by jdl 2011-3-8  jdl0073
	 s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("11", ocrrowid, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	 i SQLCODE
	 {
		TROLLBACK
		q SQLCODE
	 }
	 /*************************************************/
	//Function:Funds	2012-2-16 生成资金来源信息
	 ;Modified By JDL 2012-2-15 JDL0116
	 s OCLAmount=$p(^DHCEQOpenCheckList(oclrowid),"^",16)*$p(^DHCEQOpenCheckList(oclrowid),"^",17)
	 s SQLCODE=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(0,oclrowid,OCLAmount)
	 if SQLCODE
	 {
		 TROLLBACK
		 q SQLCODE
	 }
	 /*************************************************/
	 TCOMMIT
	 q ocrrowid
 }
 i (+isDel=4) //取消提交
 {
	 s reason=$p(val,"^",2)
	 s PLIST(21)="0"
	 //s PLIST(29)=reason
	 //s PLIST(30)=User
	 //s PLIST(31)=Date
	 //s PLIST(32)=Time
	 s Status="0"
	 TSTART
	 
	//2015-10-08 ZY0146   取消提交的拒绝原因也写在DHC_EQApproveList表中。表增加一个审批标记:统一/拒绝 
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("7", rowid)
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,rowid,reason,"",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	s CancelToFlowDR=""
	s CancelFlag="N"
	s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,CurRole,0))
	i AFRowID'="" d
	.s CancelFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",5)
	.s CancelToFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",6)
	i CancelFlag'="Y" q -1006		;该步骤未设置为可取消
	
	s (ApproveRoleDR,Step)=""
	i CancelToFlowDR'=""
	{
		s Status="1"
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
 		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
 		///add by lmm 2017-06-14 405891 begin
 		s PLIST(21)="1"  
		s PLIST(34)=ApproveRoleDR
 		s PLIST(35)=Step
 		///add by lmm 2017-06-14 405891 end
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,rowid,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	 &sql(Update SQLUSER.DHC_EQOpenCheckRequest Values :PLIST() where OCR_RowID=:rowid)
	 if SQLCODE
	 {
	 	TROLLBACK
		q SQLCODE
	 }
	 
	 ;Modified by jdl 2011-3-8  jdl0073
	 s CurRole=$p(val,"^",3)
	 s ApproveFlow=""
	 i CancelToFlowDR'=""
	 {
 	 	s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	 }
	 //add by lmm 2017-07-14 begin 405891
	 else
	 {
		 s ApproveFlow="^^^^^^^^"_ApproveSet  
	 }
	 //add by lmm 2017-07-14 end	405891
	 s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("11", rowid, User, ApproveFlow, "Y",CurRole)
	 i SQLCODE
	 {
		TROLLBACK
		q SQLCODE
	 }
		
	 TCOMMIT
	 q rowid
 }
 i (+isDel=5) //审核
 {
	 s Status=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",20) //状态
	 if Status="2" q -2015   //该记录状态不符合,不能执行操作!
	 
	 s PLISTSH(21)="2"
	 s PLISTSH(26)=User
	 s PLISTSH(27)=Date
	 s PLISTSH(28)=Time
	 s ContractListDR=$p(val,"^",2)
	 s Quantity=$p(val,"^",3)
	 s TranFlag=$p(val,"^",4)
	 s ocrrowid=rowid
	 s oclrowid=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,0))
	 i TranFlag="Y" TSTART
	 &sql(update sqluser.DHC_EQOpenCheckRequest values :PLISTSH() where OCR_RowID=:ocrrowid)
	 if SQLCODE
	 {
		i TranFlag="Y" TROLLBACK
		q SQLCODE
	 }
	 /*********审核设备*****************/
	 s PI(2) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",2)	;Name
	 s PI(3) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",4)	;ABCType
	 s PI(4) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",5)	;ModelDR
 	 s PI(5) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",6)	;EquiCatDR
 	 s PI(6) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",7)	;UnitDR
 	 s PI(7) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",8) //Code 	 
 	 s PI(8) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",9) //ItemDR
 	 s PI(9) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",47) ;InstallLoc
 	 s PI(10) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",48) ;InstallDate
 	 s PI(12) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",49) ;LeaveFactoryDate
 	 s PI(13) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",10) ;OpenCheckDate
 	 s PI(14) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",46) ;CheckDate
 	 s PI(15) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",10) ;MakeDate
 	 s PI(16) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",39) ;ComputerFlag  add by zy 20150901 zy0140
 	 s PI(17) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",11)	;CountryDR
 	 s PI(18) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",32)	;ManageLocDR
 	 s PI(19) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",12)	;ManageLevelDR
 	 //s PI(20) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",33)	;UseLocDR  //2012-03-12 DJ
 	 s PI(21) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",8)	;OriginDR
 	 s PI(22) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",9)	;FromDeptDR
	 s PI(24) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",13)	;BuyTypeDR
 	 s PI(25) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",14)	;EquipTechLevelDR 
 	 s PI(26) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",5)	;ProviderDR
 	 s PI(27) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",15)	;ManuFactoryDR
 	 s PI(28) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",17)	;OriginalFee
 	 If PI(3)=""
	 {
	 	// Mozy003001	2020-03-17
		Set PI(3)="A"		;默认类
		;If PI(28)<80000 Set PI(3)="B"
		;If PI(28)<10000 Set PI(3)="C"
		;If PI(28)<1000 Set PI(3)="D"
		s SplitFlag=##class(web.DHCEQCommon).GetSysInfo("201013")
		i SplitFlag="" s SplitFlag="100000,10000"
		If PI(28)<+$p(SplitFlag,",",1) Set PI(3)="B"
		If PI(28)<+$p(SplitFlag,",",2) Set PI(3)="C"
		If PI(28)<+$p(SplitFlag,",",3) Set PI(3)="D"
	 }
	 
 	 s PI(29) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",17)	;NetFee
	 s PI(30) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",18)  	;NetRemainFee
	 s PI(32) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",19) 	;LimitYearsNum
	 s PI(33) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",37)	;ContractListDR
	 s PI(34) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",20) 	;DepreMethod
	 s PI(35) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",21)	;Remark
	 s PI(37) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",29) 	;DesignWorkLoadNum
	 s PI(38) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",30) 	;WorkLoadUnit
	 s PI(39)=0 ;Status
	 s PI(42) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",6)	;ContactUser
 	 s PI(43) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",7)	;ContactMode
	 s PI(47) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",42) ;GuaranteeFlag
 	 s PI(48) = "N"
 	 s PI(49) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",40) ;TestFlag
 	 s PI(50) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",38) ;MedicalFlag
 	 s PI(51) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",43) ;GuaranteeStartDate
	 s PI(52) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",44) ;GuaranteeEndDate
 	 s PI(53)=User
	 s PI(54)=Date
	 s PI(55)=Time
	 s PI(56)=User
	 s PI(57)=Date
	 s PI(58)=Time
	 s PI(59)= $p($g(^DHCEQOpenCheckList(oclrowid)),"^",21) ;Currency
	 s PI(60) = "N"
	 s PI(61) = "0"
 	 s PI(62) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",22) //MemeryCode
 	 s PI(63) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",41) //UrgencyFlag
 	 s PI(64) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",3) //EquipType
 	 s PI(65) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",23) //PurchaseTypeDR
 	 s PI(66) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",24) //PurposeTypeDR
 	 //s PI(68) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",31) ;StoreLoc 2009-06-26 党军
 	 s PI(70) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",25) //ServiceDR 	 
 	 s PI(73) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",26) //LocationDR
 	 s PI(74) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",27) //GuaranteePeriodNum
 	 s PI(76) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",28) //StatCatDR
 	 s PI(77) = $Piece($Get(^DHCEQOpenCheckList(oclrowid)),"^",36) //ContractNo Mozy0051	2011-4-15
 	 s PI(78) = oclrowid //OpenCheckListRowid
 	 //s LeaveFactoryNo=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",55)
 	 s LeaveFactoryNo=$g(^DHCEQOpenCheckList(oclrowid,"EX")) //2009-08-17 党军

 	 //新增:2009-11-25 党军 begin DJ0037
 	 s PI(82)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",60) ;BenefitAnalyFlag
 	 s PI(83)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",61) ;CommonageFlag
 	 s PI(84)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",62) ;AutoCollectFlag
 	 s PI(85)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",65) ;WorkLoadPerMonth
 	 
 	 s PI(93)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",56) ;Hold2  //注册证号
 	 s PI(95)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",58)	;Hold4	//品牌	2013-12-11 DJ0122
 	 //2009-11-25 党军 end DJ0037
 	 Set PI(96)=$Piece($Get(^DHCEQOpenCheckList(oclrowid)),"^",59)	;Hold5	//经费来源 20150630  Mozy0154
 	 //modify BY:GBX 2014-11-24
 	 s PI(109)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",66)  //ValueType
 	 s PI(110)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",67)  //DirectionsUse
 	 s PI(111)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",68)  //UserDR
 	 s PI(112)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",69)  //AccountShape
 	 s PI(113)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",70)  //ProjectNo
 	 s PI(91)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",71)  //凭证号
 	 s PI(103)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",72)  //EQRaditionFlag	放射标志
	 s PI(81)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",73) ;中医标志 Add By DJ 2017-01-20
	 // Mozy0217  2018-11-01
	 s PI(107)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",73)  //Hold3	设备账目归属
	 s PI(114)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",77)  //ServiceHandler
	 s PI(115)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",78)  //ServiceTel
	 s PI(118)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",81)  //SalesManager
	 s PI(119)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",82)  //SalesManagerTel
	 //s PI(86)= $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",38) //FileNo 档案号 2014-1-9 HZY0045 
 	 Set FileNo=$g(^DHCEQOpenCheckList(oclrowid,"FileNo"))		//20150819  Mozy0159
 	 Set SplitFlag=##class(web.DHCEQCommon).GetSysInfo("990035")	//20150822  Mozy0162 验收时档案号是否拆分
	 for j=1:1:Quantity
	 {
		 q:SQLCODE'=0
		 s PI(11) =##class(web.DHCEQCommon).Replace($P(LeaveFactoryNo, ",", j),$C(13,10),"")
		 //20150822  Mozy0162 验收时档案号是否拆分
		 If SplitFlag=1 Do
		 .Set PI(86) =##class(web.DHCEQCommon).Replace($Piece(FileNo, ",", j),$C(13,10),"")
		 Else  Do
		 .Set PI(86) = FileNo
		 &sql(Insert Into sqluser.DHC_EQEquip values :PI())
		 if SQLCODE
		 {
			 i TranFlag="Y" TROLLBACK
			 q:SQLCODE
	 	 }
	 	 s ID=$G(%ROWID)
		 s SQLCODE= ##CLASS(web.DHCEQEquip).UpdateEquipNo(ID,Date)
	 	 i SQLCODE
	 	 {
		 	i TranFlag="Y" TROLLBACK
		 	q:SQLCODE
		 }
		 	 //begin add by jyp jyp 2019-09-02 设备属性在审核时保存到设备中
		 s SQLCODE= ##CLASS(web.DHCEQ.EM.BUSEquipAttribute).SaveEquipAttributeByOpenCheckList(2,oclrowid,ID)
			i SQLCODE
	 	 {
		 	i TranFlag="Y" TROLLBACK
		 	q:SQLCODE
		 }
		 //end add by jyp jyp 2019-09-02 设备属性在审核时保存到设备中
		 if PI(33)'=""
		 {
	 		s SQLCODE=..InsertAffixByContract(ID,PI(33))
	 		if SQLCODE<0
	 		{
				i TranFlag="Y" TROLLBACK
				q:SQLCODE
	 		}
		 }
		 //配置清单复制与附属设备生成台账	// Mozy0217  2018-11-01
		 s SQLCODE=##class(web.DHCEQOpenCheckRequest).InsertEquipOrConfig(oclrowid,ID,j)
	 	 i SQLCODE
	     {
			i TranFlag="Y" TROLLBACK
			q:SQLCODE
	     }
		 /// Mozy0145	20141017
		 Set StatDR=$Piece($Get(^DHCEQOpenCheckList(oclrowid)),"^",28)
		 Set AssetType=$Piece($Get(^DHCEQCCode("DHCEQCStatCat",StatDR)),"^",5)
		 Set Info=##Class(web.DHCEQOpenCheckRequest).GetInfoData(0,oclrowid)
		 /*
		 Set len=$L(Info,"^")
		 Set Info=$Piece(Info,"^",4,len)
		 Set Info=AssetType_"^^"_Info 
		 */
		 //modified by GR0014 2014-11-19 end
		 Set SQLCODE=##Class(web.DHCEQOpenCheckRequest).SaveDataForInfo(Info,1,ID,2)
		 if SQLCODE
		 {
			 i TranFlag="Y" TROLLBACK
		 	 q:SQLCODE
		 }
		 ///////////////////拆分附件的出厂编号 		 ///Mozy	2016-8-4
		 If $Data(^DHCEQAffix(0,"CheckListDR",oclrowid))'=0
		 {
			 ; EQHold11		过滤配置设备	// Mozy0217  2018-11-01
			 If $Piece($Get(^DHCEQEquip(ID,"OtherInfo")),"^",24)=""
			 {
				 Set Affixrowid=0
				 For  Set Affixrowid=$Order(^DHCEQAffix(0,"CheckListDR",oclrowid,Affixrowid))  Quit:Affixrowid=""  Do
				 .;Hold3-拆分标记	把附件拆分为单台
				 .If $Piece($Get(^DHCEQAffix(Affixrowid)),"^",27)="Y" Do
				 ..Set QuantityNum=$Piece($Get(^DHCEQAffix(Affixrowid)),"^",7)
				 ..for n=1:1:QuantityNum d
				 ...Kill APLIST
				 ...Set APLIST(2) = ID	;EquipDR
				 ...Set APLIST(3) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",2)	;AffixDR
				 ...Set APLIST(4) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",3)	;AffixCatDR
				 ...Set APLIST(5) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",4)	;PartSpec
				 ...Set APLIST(6) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",5)	;PartModel
				 ...Set APLIST(7) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",6)	;ManuFactoryDR
				 ...Set APLIST(8) = 1	;$Piece($Get(^DHCEQAffix(Affixrowid)),"^",7)	;QuantityNum
				 ...Set APLIST(9) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",8)	;ReceiverDR
				 ...Set LeaveFacNo = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",9)	;LeaveFacNo
				 ...i $d(^DHCEQAffix(Affixrowid,"EX")) Set LeaveFacNo = $g(^DHCEQAffix(Affixrowid,"EX"))	;LeaveFacNo
				 ...Set APLIST(10) = $Piece(LeaveFacNo,",",(j-1)*QuantityNum+n)
				 ...Set APLIST(11) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",10)	;LeaveDate
				 ...Set APLIST(12) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",11)	;PriceFee
				 ...Set APLIST(13) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",12)	;Remark
				 ...Set APLIST(14) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",13)	;CurrencyDR 
				 ...Set APLIST(15) = "N"		;AF_DisuseFlag
				 ...Set APLIST(16) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",15)	;AF_InvalidFlag
				 ...Quit:APLIST(16)'="N"
				 ...Set APLIST(20) = ""			;AF_CheckListDR
				 ...Set APLIST(21) = Affixrowid	;AFOldRowID
				 ...Set APLIST(25) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",24) ;ProviderDR
				 ...Set APLIST(26) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",25) ;Hold1
				 ...Set APLIST(27) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",26) ;Hold2
				 ...;Set APLIST(28) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",27) ;Hold3
				 ...Set APLIST(29) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",28) ;Hold4
				 ...Set APLIST(30) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",29) ;Hold5
				 ...
				 ...&SQL(Insert Into SQLUSER.DHC_EQAffix Values :APLIST())
		 	}
		 	if SQLCODE
		 	{
			 	i TranFlag="Y" TROLLBACK
		 	 	q:SQLCODE
		 	}
		 }
	 }
	 Set SQLCODE = ##Class(web.DHCEQOpenCheckRequest).AutoInOutExecute(1,oclrowid,$p($g(^DHCEQOpenCheckList(oclrowid)),"^",31),User,InFlag,OutFlag)
	 if SQLCODE
	 {
		 i TranFlag="Y" TROLLBACK
		 q SQLCODE
	 }
	 i TranFlag="Y" TCOMMIT
	 q ocrrowid
 }
 i (+isDel=6)
 {
	s OPLIST(37)=$p(val,"^",2)  //Role
	s OPLIST(36)=$p(val,"^",3)  //Step
	s Opinion=$p(val,"^",4)  //Opinion
	s Remark=$p(val,"^",5)
	s ocrrowid=rowid
	s oclrowid=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,0))
	s ApproveSet=$P(^DHCEQOpenCheckRequest(ocrrowid),"^",32)
	s NextApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, ocrrowid, OPLIST(36), OPLIST(37))
 	s LastFlag=$p(NextApproveFlow,"^",1)
 	s OPLIST(35)=$p(NextApproveFlow,"^",2)  //NextStep
 	s OPLIST(34)=$p(NextApproveFlow,"^",3)  //NextRole
 	s AppInfoStatus="1"
 	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
 	TSTART
 	//add by QW 2017-12-01 bug号:QW0009 增加验收可编辑字段
	if editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)		//编辑要修改的字段
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
 	//End  by QW 2017-12-01
 	i AutoAuditFlag="Y"
	{
	 	i OPLIST(35)="" s OPLIST(21)="2"
	 	i LastFlag="Y" s OPLIST(21)="2"
	 	i (OPLIST(35)="")||(LastFlag="Y")
	 	{		 	
		 	s ContractList=$P(^DHCEQOpenCheckList(oclrowid),"^",37)
		 	s Quantity=$P(^DHCEQOpenCheckList(oclrowid),"^",16)
		 	s combindata=ocrrowid_"^"_ContractList_"^"_Quantity_"^N"
	 		s SQLCODE=..SaveData("", "", combindata, "5", "", InFlag,OutFlag)	;20170327 Mozy0184
			if SQLCODE<0
			{
	 			TROLLBACK
	 			q SQLCODE
			}
			;Modified by jdl 2011-3-8  jdl0073
		 	s AuditFlag=1
		 	s AppInfoStatus="2"
	 	}
	}
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, ocrrowid, Opinion, Remark, OPLIST(37), OPLIST(36))
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,ocrrowid,OPLIST(34),OPLIST(35),OPLIST(36),OPLIST(37),AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&sql(update sqluser.DHC_EQOpenCheckRequest values :OPLIST() where OCR_RowID=:ocrrowid)
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	;Modified by jdl 2011-3-8  jdl0073
	s CurRole=$p(val,"^",2)  //Role
	s ApproveFlow=NextApproveFlow
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("11", ocrrowid, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	TCOMMIT
	q ocrrowid
 }
 q ""
ERROR
 	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit "<ERROR>"_ErrorMsg     //返回错误消息 ; //2009-07-10 党军 end
}

ClassMethod GetSpecialType(OCID)
{
	s SpecialType=""
	s EquipCat=$P(^DHCEQOpenCheckList(OCID),"^",6)
	i EquipCat'="" s SpecialType=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCat),"^",5)
	i SpecialType'="" q SpecialType
	q 0
}

ClassMethod InsertAffixByContract(EquipID, ContractListID)
{
	new User,Date,Time
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	&SQL(Insert Into SQLUser.DHC_EQAffix (AF_EquipDR,AF_AffixDR,AF_AffixCatDR,AF_PartSpec,AF_PartModel,AF_ManuFactoryDR,AF_QuantityNum,AF_ReceiverDR,AF_LeaveFacNo,AF_LeaveDate,AF_PriceFee,AF_Remark,AF_CurrencyDR,AF_DisuseFlag,AF_InvalidFlag,AF_UpdateUserDR,AF_UpdateDate,AF_UpdateTime) 
	select :EquipID,CA_AffixDR,CA_AffixCatDR,CA_PartSpec,CA_PartModel,CA_ManuFactoryDR,CA_QuantityNum,CA_ReceiverDR,CA_LeaveFacNo,CA_LeaveDate,CA_PriceFee,CA_Remark,CA_CurrencyDR,'N','N',:User,:Date,:Time from SQLUser.DHC_EQContractAffix where CA_ContractListDR=:ContractListID)
	//modified by zy 2019-10-21 ZY0193
	i SQLCODE=100 s SQLCODE=0
	q SQLCODE
}

/// Mozy  2018-11-20	调整新生成的附属设备编号为父设备编号加后缀,并拆分附属设备出厂编号
/// EQCount:插入配置信息的遍历设备序列
/// w ##Class(web.DHCEQOpenCheckRequest).InsertEquipOrConfig(128,18308,1)
/// 配置信息复与台账插入
ClassMethod InsertEquipOrConfig(OCLRowid, EquipID, EQCount)
{
	new flag,SQLCODE,CRowid,Type,CCount,CQuantityNum,n,sn,prefix,LastEquipID
	s flag=##class(web.DHCEQCommon).GetSysInfo("201011")  //0:复制 1：生成台账
	s SQLCODE=0
	
	s CRowid=0
	f  s CRowid=$Order(^DHCEQConfig(0,"SourceID",1,OCLRowid,CRowid)) Quit:(CRowid="")||(SQLCODE'=0)  Do
	.s Type=$P($g(^DHCEQConfig(CRowid)),"^",1)
	.i ((flag=1)&(Type=1)) d
	..d DoInsertEquip
	..q:SQLCODE'=0
	.e  d
	..s SQLCODE=##Class(web.DHCEQOpenCheckRequest).InsertConfig(CRowid,EquipID)   //复制
	..q:SQLCODE'=0
	
	q SQLCODE
	
DoInsertEquip
	;;根据配置表设置信息为设备插入相关的附属设备,如为第EQCount台设备依次插入其关联的附属设备
	s CQuantityNum=$P($g(^DHCEQConfig(CRowid)),"^",7)		;附属配置设备的总数量
	s n=0
	s CCount=n*$P(^DHCEQOpenCheckList(OCLRowid),"^",16)+EQCount		;初始化分配附属配置设备计数
	while ((CCount<=CQuantityNum)&&(SQLCODE=0))
	{
		s sn=$p($P($g(^DHCEQConfig(CRowid)),"^",17),",",CCount)			//拆分出厂编号
		s LastEquipID=$Order(^DHCEQEquip(0,"Parent",EquipID,""),-1)		//当前EquipID设备的最后一个附属设备ID
		i LastEquipID="" d
		.s prefix=1
		e  d
		.s prefix=$p($g(^DHCEQEquip(LastEquipID)),"^",71)		;No
		.;s prefix=$p($g(^DHCEQEquip(LastEquipID)),"^",85)		;FileNo
		.s prefix=1+$p(prefix,"-",2)
		s prefix=##class(web.DHCEQCCounter).LPAD(prefix,"0",2)
		s SQLCODE=##Class(web.DHCEQOpenCheckRequest).InsertEquip(CRowid,EquipID,OCLRowid,sn,prefix)  //生成台账
		s n=n+1
		s CCount=n*$P(^DHCEQOpenCheckList(OCLRowid),"^",16)+EQCount
	}
	
	q
}

/// Mozy0217  2018-11-01
/// 描述：附属设备插入台账.
/// 当配置类型为附属设备且系统参数为1时生成台账
ClassMethod InsertEquip(CRowid, EquipID, OCLRowid As %String = "", sn As %String = "", prefix As %String = "")
{
	k CPPI
	n OCRRowid,EID,tmpeqno
	s OCRRowid=$P($g(^DHCEQOpenCheckList(OCLRowid)),"^",1)
	s CPPI(8) = $P($g(^DHCEQConfig(CRowid)),"^",4)		;C_ItemDR
	s CPPI(4) = $P($g(^DHCEQConfig(CRowid)),"^",13)  	;C_Model
	i CPPI(4)'="" s CPPI(4) =##Class(web.DHCEQCModel).UpdModel(CPPI(4), CPPI(8))
	s CPPI(2) = $P($g(^DHCEQConfig(CRowid)),"^",5)  	;Name	Mozy	2018-11-20
	s CPPI(5) = $P($g(^DHCEQCCode("DHCEQCMasterItem",CPPI(8))),"^",4)  ;EquipCatDR
	s CPPI(6) = $P($g(^DHCEQConfig(CRowid)),"^",8)	;C_UnitDR
 	s CPPI(11) = sn	;$P($g(^DHCEQConfig(CRowid)),"^",17)  ;C_LeaveFacNo
	s CPPI(12) = $P($g(^DHCEQConfig(CRowid)),"^",18)	;C_LeaveDate
	s CPPI(28) = $P($g(^DHCEQConfig(CRowid)),"^",6)	;C_Price
	s CPPI(95) = $P($g(^DHCEQConfig(CRowid)),"^",9)  ;C_BrandDR
	s CPPI(26) = $P($g(^DHCEQConfig(CRowid)),"^",10)  ;C_VendorDR
	s CPPI(27) = $P($g(^DHCEQConfig(CRowid)),"^",11)  ;C_ManuFactoryDR
	s CPPI(74) = $P($g(^DHCEQConfig(CRowid)),"^",15)  ;C_GuaranteePeriodNum
	s CPPI(17) = $P($g(^DHCEQConfig(CRowid)),"^",16)  ;C_CountryDR
	s CPPI(73) = $P($g(^DHCEQConfig(CRowid)),"^",19)	;C_Location
	i CPPI(73)'="" s CPPI(73)=##Class(web.DHCEQCLocation).UpdLocation(##class(web.DHCEQCHanZiEncoding).GetEncoding(CPPI(73),4,"","U")_"^"_CPPI(73))
	s CPPI(16) = $P($g(^DHCEQConfig(CRowid)),"^",21)	;C_MeasureFlag	计量标志	Mozy	20180930
	s CPPI(51) = $P($g(^DHCEQConfig(CRowid)),"^",22)	;C_GuaranteeStartDate	
	s CPPI(52)= $P($g(^DHCEQConfig(CRowid)),"^",23)		;C_GuaranteeEndDate
	s CPPI(90) = $P($g(^DHCEQConfig(CRowid)),"^",25)	;C_DisuseDate 
	;s CPPI(27) = $P($g(^DHCEQConfig(CRowid)),"^",26)	;C_InvoiceNo
	s CPPI(35) = $P($g(^DHCEQConfig(CRowid)),"^",28)	;C_Remark
	
	s CPPI(7) = $p($g(^DHCEQCCode("DHCEQCMasterItem", +CPPI(8))),"^",2)					;EQ_Code
	s CPPI(13) = $p($g(^DHCEQOpenCheckRequest(OCRRowid)),"^",10) 						;OpenCheckDate
 	s CPPI(14) = $p($g(^DHCEQOpenCheckList(OCLRowid)),"^",46) 							;CheckDate
 	s CPPI(21) = $p($g(^DHCEQOpenCheckRequest(OCRRowid)),"^",8)							;OriginDR
 	s CPPI(29) = $P($g(^DHCEQConfig(CRowid)),"^",6)		;NetFee
 	i $p($g(^DHCEQCCode("DHCEQCMasterItem",CPPI(8))),"^",4)'="" d
 	.s CPPI(32) = ##Class(web.DHCEQCEquipeCat).GetYearsByCatID($p($g(^DHCEQCCode("DHCEQCMasterItem",CPPI(8))),"^",4),$p($g(^DHCEQCCode("DHCEQCMasterItem",CPPI(8))),"^",5)) 	;LimitYearsNum
	s CPPI(34)=3		;不计提折旧
	s CPPI(39)=0 ;Status
	s CPPI(48) = "N"   				;InputFlag
	s CPPI(53)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))		;EQ_AddUserDR EQ_AddDate EQ_AddTime EQ_UpdateUserDR EQ_UpdateDate EQ_UpdateTime 
	s CPPI(54)=+$H
	s CPPI(55)=$P($H,",",2)
	s CPPI(56)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s CPPI(57)=+$H
	s CPPI(58)=$P($H,",",2)
	s CPPI(60) = "N"				;EQ_InvalidFlag
	s CPPI(61) = "0"				;EQ_StockStatus
	s CPPI(64) = $p($g(^DHCEQCCode("DHCEQCMasterItem",CPPI(8))),"^",3) 		//EquipType
	s CPPI(65) = $p($g(^DHCEQOpenCheckList(OCLRowid)),"^",23) 				//PurchaseTypeDR
 	s CPPI(66) = $p($g(^DHCEQOpenCheckList(OCLRowid)),"^",24) 				//PurposeTypeDR
	s CPPI(76) = $p($g(^DHCEQCCode("DHCEQCMasterItem",CPPI(8))),"^",5)  	//StatCatDR
	s CPPI(78) = OCLRowid	
	s CPPI(93)=$P($g(^DHCEQConfig(CRowid)),"^",38)	//注册证号
	s CPPI(81)=$P($g(^DHCEQConfig(CRowid)),"^",39)	//厂家建议年限
	;s CPPI(103) = $p($g(^DHCEQOpenCheckList(OCLRowid)),"^",72)  			//RaditionFlag	放射标志	Mozy	20180930	附属设备不能直接获取主设备标记
	s CPPI(114)=$P($g(^DHCEQConfig(CRowid)),"^",36)							//ServiceHandler
	s CPPI(115)=$P($g(^DHCEQConfig(CRowid)),"^",37)							//ServiceTel
	;i $p($g(^DHCEQEquip(EquipID)),"^",85)'="" Set CPPI(86) = $p($g(^DHCEQEquip(EquipID)),"^",85)_"-"_prefix	档案号
	s CPPI(120) = EquipID		//主设备ID
	s CPPI(122) = CRowid
    &SQL(Insert Into SQLUSER.DHC_EQEquip Values :CPPI())	
	i SQLCODE
	{
		 q SQLCODE
	}
	s EID=$G(%ROWID)
	i prefix="" d
	.s SQLCODE=##CLASS(web.DHCEQEquip).UpdateEquipNo(EID,$h)
	e  d
	.s tmpeqno=$p($g(^DHCEQEquip(EquipID)),"^",71)_"-"_##class(web.DHCEQCCounter).LPAD(prefix,"0",2)
	.&SQL(Update SQLUSER.DHC_EQEquip set EQ_No=:tmpeqno Where EQ_RowID=:EID)
	i SQLCODE
	{
		 q SQLCODE
	}
	;/// Mozy0248	1191132		2020-02-18
	i $P($g(^DHCEQConfig(CRowid)),"^",21)="Y"
	{
		Set TMPEAID=""
		Set EAID=0
		For  Set EAID=$Order(^DHCEQCCode("DHCEQCEquipAttribute",0,"Code",11,EAID)) Quit:(EAID="")||(TMPEAID'="")  Do
		.Quit:$p($g(^DHCEQCCode("DHCEQCEquipAttribute",EAID)),"^",5)="Y"
		.Set TMPEAID=EAID
		i TMPEAID'="" &SQL(insert into sqluser.DHC_EQEquipAttributeList (EAL_EquipAttributeDR,EAL_SourceType,EAL_SourceID) values (:TMPEAID,'3',:EID))
	}
	q SQLCODE
}

ClassMethod UpdateBPLArriveNum(Num, BPLID)
{
	s ArriveNum=$p(^DHCEQBuyPlanList(BPLID),"^",17)
	s ExecNum=$p(^DHCEQBuyPlanList(BPLID),"^",7)
	i ArriveNum="" s ArriveNum=0
	s Num=Num+ArriveNum
	i Num>ExecNum q ExecNum-Num
	&SQL(update sqluser.DHC_EQBuyPlanList set BPL_ArriveNum=:Num where BPL_RowID=:BPLID)
	q SQLCODE
}

Query GetCheckType() As %Query(ROWSPEC = "CheckType:%String,ID:%String")
{
}

ClassMethod GetCheckTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	d BuildDataGetCheckType
	Quit $$$OK
BuildDataGetCheckType
	s ID="0"
	s CheckType=##class(web.DHCEQCommon).GetEditCheckTypeDisplay(ID)
	d OutputRowGetCheckType
	s ID="1"
	s CheckType=##class(web.DHCEQCommon).GetEditCheckTypeDisplay(ID)
	d OutputRowGetCheckType
	s ID="2"
	s CheckType=##class(web.DHCEQCommon).GetEditCheckTypeDisplay(ID)
	d OutputRowGetCheckType
	quit
OutputRowGetCheckType
	s Data=$lb(CheckType,ID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCheckType
	s (CheckType,ID)=""
	quit
}

ClassMethod GetCheckTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckTypeExecute ]
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

ClassMethod GetCheckTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 新增：2009-08-21 党军
/// 描述：根据设备批量验收总单RowID取明细RowID
ClassMethod GetOpenCheckListDR(OCRRowID)
{
	s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	q OCLRowID
}

/// /modified by  ZY 2009-10-26  ZY0086
/// /验收单号是唯一字段，不能复制
/// /----------------
/// 创建:ZY 2009-10-26  zy0013
/// 目的:复制验收单
/// 描述:复制验收的全部信息,包括附件、资料
/// 输入:
/// 输出:
/// 返回值: 成功返回复制后的验收单RowID
/// w ##Class(web.DHCEQOpenCheckRequest).CopyOpenCheckRequest("12")
ClassMethod CopyOpenCheckRequest(rowid)
{
	new OCRRowID,OCLRowID,CheckListDR,AFCheckListDR,DOCCheckListDR,EquipTypeDR,StatCatDR  //2014-9-17 HZY0063
	s (CheckListDR,AFCheckListDR,DOCCheckListDR)=""
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	s Date=+$H
 	s Time=$P($H,",",2)
 	s CheckListDR=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,0))
 	i CheckListDR="" q
 	s OCLSourceType=$p(^DHCEQOpenCheckList(CheckListDR),"^",63)
 	s OCLSourceID=$p(^DHCEQOpenCheckList(CheckListDR),"^",64)
 	s OCLContractListDR=$p(^DHCEQOpenCheckList(CheckListDR),"^",37)
 	s OCLItemDR=$p(^DHCEQOpenCheckList(CheckListDR),"^",9)
 	i +OCLSourceType'=0
 	{
	 	s OCLSourceID=""
	 	s OCLContractListDR=""
	 	s OCLItemDR=""
	} 	
 	s AFCheckListDR=$o(^DHCEQAffix(0,"CheckListDR",CheckListDR,0))
 	s DOCCheckListDR=$o(^DHCEQDoc(0,"CheckListDR",CheckListDR,0))
 	s ConfigCheckListDR=$o(^DHCEQConfig(0,"SourceID",1,CheckListDR,0))
 	s EquipTypeDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",2)  //2014-9-17 HZY0063
 	s StatCatDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",4)  //2014-9-17 HZY0063
 	s MFInfo=^DHCEQOpenCheckList(CheckListDR,"MFInfo")		//czf 2022-10-17
	TSTART
		s OCRHold1=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQOpenCheckRequest",Date,"",EquipTypeDR,StatCatDR)  //2014-9-17 HZY0063
		//GR0029 增加OCR_InvalidFlag字段
		&SQL(Insert Into sqluser.DHC_EQOpenCheckRequest
    	(OCR_CheckType,OCR_EquipTypeDR,OCR_PurchaseTypeDR,OCR_StatCatDR,
         OCR_ProviderDR,OCR_ProviderHandler,OCR_ProviderTel,OCR_OriginDR,
         OCR_FromDeptDR,OCR_OpenCheckDate,OCR_CheckDate,OCR_PackageState,OCR_ConfigState,OCR_FileState,
         OCR_AffixState,OCR_RunningState,OCR_OpenState,OCR_CheckResult,
         OCR_CheckUser,OCR_Status,OCR_Remark,OCR_Hold1,OCR_Hold2,OCR_UpdateUserDR,
         OCR_UpdateDate,OCR_UpdateTime,OCR_InvalidFlag) 
		Select OCR_CheckType,OCR_EquipTypeDR,OCR_PurchaseTypeDR,OCR_StatCatDR,
         OCR_ProviderDR,OCR_ProviderHandler,OCR_ProviderTel,OCR_OriginDR,
         OCR_FromDeptDR,OCR_OpenCheckDate,:Date,OCR_PackageState,OCR_ConfigState,OCR_FileState,
         OCR_AffixState,OCR_RunningState,OCR_OpenState,OCR_CheckResult,
         OCR_CheckUser,'0',OCR_Remark,:OCRHold1,OCR_Hold2,:User,
         :Date,:Time,'N'
		From sqluser.DHC_EQOpenCheckRequest Where OCR_RowID=:rowid)
		s OCRRowID=$G(%ROWID)
		if SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		// Mozy0217  2018-11-01	修改验收明细表字段
		&SQL(Insert Into sqluser.DHC_EQOpenCheckList  
		(OCL_OpenCheckRequestDR,OCL_Name,OCL_EquipTypeDR,OCL_ABCType,OCL_ModelDR,
		 OCL_EquiCatDR,OCL_UnitDR,OCL_Code,OCL_ItemDR,OCL_MakeDate,OCL_CountryDR,
		 OCL_ManageLevelDR,OCL_BuyTypeDR,OCL_EquipTechLevelDR,OCL_ManuFactoryDR,
		 OCL_Quantity,OCL_OriginalFee,OCL_NetRemainFee,OCL_LimitYearsNum,
		 OCL_DepreMethodDR,OCL_CurrencyDR,OCL_MemoryCode,OCL_PurchaseTypeDR,
		 OCL_PurposeTypeDR,OCL_ServiceDR,OCL_LocationDR,OCL_GuaranteePeriodNum,
		 OCL_StatCatDR,OCL_DesignWorkLoadNum,OCL_WorkLoadUnitDR,OCL_StoreLocDR,
		 OCL_ManageLocDR,OCL_UseLocDR,OCL_Remark,OCL_CurrencyFee,OCL_ContractNo,
		 OCL_ContractListDR,OCL_MedicalFlag,OCL_MeasureFlag,OCL_TestFlag,OCL_UrgencyFlag,
		 OCL_GuaranteeFlag,OCL_GuaranteeStartDate,OCL_GuaranteeEndDate,OCL_OpenCheckDate,OCL_CheckDate,OCL_InstallLocDR,
		 OCL_InstallDate,OCL_LeaveFactoryDate,OCL_PackTypeDR,OCL_PackNum,OCL_TransAssetDate,
		 OCL_AppendFeeAmount,OCL_BatchNo,OCL_Hold1,OCL_Hold2,OCL_Hold3,OCL_Hold4,OCL_Hold5,
		 OCL_BenefitAnalyFlag,OCL_CommonageFlag,OCL_AutoCollectFlag,OCL_SourceType,OCL_SourceID,OCL_WorkLoadPerMonth,
		 OCL_ValueType,OCL_DirectionsUse,OCL_UserDR,OCL_AccountShape,OCL_ProjectNo,OCL_AccountNo,OCL_RaditionFlag,OCL_TCMFlag,
		 OCL_SpecialFlag,OCL_Hold9,OCL_Hold10,OCL_ServiceHandler,OCL_ServiceTel,OCL_MeasureDate,OCL_MeasureNos,OCL_SalesManager,
		 OCL_SalesManagerTel,OCL_Hold11,OCL_Hold12,OCL_Hold13,OCL_Hold14,OCL_IsInStall,OCL_ConfigLicense,OCL_NewOldPercent,OCL_Voltage,
		 OCL_Electriccurrent,OCL_UseYearsNum,OCL_Note,OCL_MaintNote,OCL_Hold16,OCL_Hold17,OCL_Hold18,OCL_Hold19,OCL_Hold20,OCL_AuthorizeDeptDR,OCL_UseSubjectDR,OCL_BuyModeDR,OCL_AccountDate,OCL_ManageUserDR,OCL_PurchaseDate,OCL_Hold21,OCL_Hold22)
		Select :OCRRowID,OCL_Name,OCL_EquipTypeDR,OCL_ABCType,OCL_ModelDR,
		 OCL_EquiCatDR,OCL_UnitDR,OCL_Code,:OCLItemDR,OCL_MakeDate,OCL_CountryDR,
		 OCL_ManageLevelDR,OCL_BuyTypeDR,OCL_EquipTechLevelDR,OCL_ManuFactoryDR,
		 NULL,OCL_OriginalFee,OCL_NetRemainFee,OCL_LimitYearsNum,
		 OCL_DepreMethodDR,OCL_CurrencyDR,OCL_MemoryCode,OCL_PurchaseTypeDR,
		 OCL_PurposeTypeDR,OCL_ServiceDR,OCL_LocationDR,OCL_GuaranteePeriodNum,
		 OCL_StatCatDR,OCL_DesignWorkLoadNum,OCL_WorkLoadUnitDR,OCL_StoreLocDR,
		 OCL_ManageLocDR,OCL_UseLocDR,OCL_Remark,OCL_CurrencyFee,OCL_ContractNo,
		 :OCLContractListDR,OCL_MedicalFlag,OCL_MeasureFlag,OCL_TestFlag,OCL_UrgencyFlag,
		 OCL_GuaranteeFlag,OCL_GuaranteeStartDate,OCL_GuaranteeEndDate,OCL_OpenCheckDate,OCL_CheckDate,OCL_InstallLocDR,
		 OCL_InstallDate,OCL_LeaveFactoryDate,OCL_PackTypeDR,OCL_PackNum,OCL_TransAssetDate,
		 OCL_AppendFeeAmount,OCL_BatchNo,OCL_Hold1,OCL_Hold2,OCL_Hold3,OCL_Hold4,OCL_Hold5,
		 OCL_BenefitAnalyFlag,OCL_CommonageFlag,OCL_AutoCollectFlag,OCL_SourceType,:OCLSourceID,OCL_WorkLoadPerMonth,
		 OCL_ValueType,OCL_DirectionsUse,OCL_UserDR,OCL_AccountShape,OCL_ProjectNo,OCL_AccountNo,OCL_RaditionFlag,OCL_TCMFlag,
		 OCL_SpecialFlag,OCL_Hold9,OCL_Hold10,OCL_ServiceHandler,OCL_ServiceTel,OCL_MeasureDate,OCL_MeasureNos,OCL_SalesManager,
		 OCL_SalesManagerTel,OCL_Hold11,OCL_Hold12,OCL_Hold13,OCL_Hold14,OCL_IsInStall,OCL_ConfigLicense,OCL_NewOldPercent,OCL_Voltage,
		 OCL_Electriccurrent,OCL_UseYearsNum,OCL_Note,OCL_MaintNote,OCL_Hold16,OCL_Hold17,OCL_Hold18,OCL_Hold19,OCL_Hold20,OCL_AuthorizeDeptDR,OCL_UseSubjectDR,OCL_BuyModeDR,OCL_AccountDate,OCL_ManageUserDR,OCL_PurchaseDate,OCL_Hold21,OCL_Hold22
		From sqluser.DHC_EQOpenCheckList Where OCL_OpenCheckRequestDR=:rowid)
		s OCLRowID=$G(%ROWID)
		if SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		
		s ^DHCEQOpenCheckList(OCLRowID,"MFInfo")=MFInfo		//出厂编号赋值 czf 2022-10-17
		
		//GR0029 增加资产卡片专属信息
		Set StatDR=$Piece($Get(^DHCEQOpenCheckList(OCLRowID)),"^",28)		//Modify DJ 2016-12-26
		Set AssetType=$Piece($Get(^DHCEQCCode("DHCEQCStatCat",StatDR)),"^",5) //GR0015 2014-11-25兼容卫计委 EQType作为资产类型标识
		i AssetType=1 &SQL(Select * into :plist() from sqluser.DHC_EQLand where L_SourceID=:CheckListDR and L_SourceType=0)
		e  i AssetType=2 &SQL(Select * into :plist() from sqluser.DHC_EQBuilding where BD_OpenCheckListDR=:CheckListDR)  //modify by lmm 2021-07-20
		e  i AssetType=3 &SQL(Select * into :plist() from sqluser.DHC_EQStructures where S_SourceID=:CheckListDR and S_SourceType=0)
		e  i AssetType=4 &SQL(Select * into :plist() from sqluser.DHC_EQVehicle where V_SourceID=:CheckListDR and V_SourceType=0)
		e  i AssetType=8 &SQL(Select * into :plist() from sqluser.DHC_EQExhibits where E_SourceID=:CheckListDR and E_SourceType=0)
		e  i AssetType=9 &SQL(Select * into :plist() from sqluser.DHC_EQSpecialPlant where S_SourceID=:CheckListDR and S_SourceType=0)
		e  i AssetType=11 &SQL(Select * into :plist() from sqluser.DHC_EQIntangibleAssets where IA_SourceID=:CheckListDR and IA_SourceType=0)
		if SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		k plist(1)
		i AssetType=1 &SQL(insert into sqluser.DHC_EQLand Values :plist())
		e  i AssetType=2 &SQL(insert into sqluser.DHC_EQBuilding Values :plist())
		e  i AssetType=3 &SQL(insert into sqluser.DHC_EQStructures Values :plist())
		e  i AssetType=4 &SQL(insert into sqluser.DHC_EQVehicle Values :plist())
		e  i AssetType=8 &SQL(insert into sqluser.DHC_EQExhibits Values :plist())
		e  i AssetType=9 &SQL(insert into sqluser.DHC_EQSpecialPlant Values :plist())
		e  i AssetType=11 &SQL(insert into sqluser.DHC_EQIntangibleAssets Values :plist())
		if SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		s NewAssetRowID=$G(%ROWID)	//无专属信息相关表的，此语句无意义
		i AssetType=1 &SQL(Update sqluser.DHC_EQLand set  L_SourceID=:OCLRowID where L_RowID=:NewAssetRowID)
		e  i AssetType=2 &SQL(Update sqluser.DHC_EQBuilding set  BD_OpenCheckListDR=:OCLRowID where BD_RowID=:NewAssetRowID)  //modify by lmm 2021-07-20
		e  i AssetType=3 &SQL(Update sqluser.DHC_EQStructures set  S_SourceID=:OCLRowID where S_RowID=:NewAssetRowID)
		e  i AssetType=4 &SQL(Update sqluser.DHC_EQVehicle set  V_SourceID=:OCLRowID where V_RowID=:NewAssetRowID)
		e  i AssetType=8 &SQL(Update sqluser.DHC_EQExhibits set  E_SourceID=:OCLRowID where E_RowID=:NewAssetRowID)
		e  i AssetType=9 &SQL(Update sqluser.DHC_EQSpecialPlant set  S_SourceID=:OCLRowID where S_RowID=:NewAssetRowID)
		e  i AssetType=11 &SQL(Update sqluser.DHC_EQIntangibleAssets set  IA_SourceID=:OCLRowID where IA_RowID=:NewAssetRowID)
		if SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		/*
		s Assetstablename=$case(AssetType,1:"DHC_EQLand",2:"DHC_EQBuilding",3:"DHC_EQStructures",4:"DHC_EQVehicle",8:"DHC_EQExhibits",9:"DHC_EQSpecialPlant",11:"DHC_EQIntangibleAssets",:"")
		s AssetsPrefix=$case(AssetType,1:"L",2:"BD",3:"S",4:"V",8:"E",9:"S",11:"IA",:"")
		i Assetstablename'=""
		{
		new plist
		s plist(1)=""
		//&SQL(Select * into :plist() from sqluser.DHC_EQCBuildingStruct where BS_RowID=4)
		SET myquery = "SELECT * from "_Assetstablename_" where "_AssetsPrefix_"_RowID="_rowid
  		SET tStatement = ##class(%SQL.Statement).%New()
  		SET tStatement.%ObjectSelectMode=1
  		SET tStatus = tStatement.%Prepare(myquery)
  		i tStatus'=1 
  		{
	  		TROLLBACK
	  		q tStatus
  		}
  		SET rset = tStatement.%Execute()
  		While (rset.%Next()){
	  	//w rset.%GetData(1) 取结果第一个字段
	  	//s plist(i)=rset.BSRowID
  		//d rset.%Display() 显示表中字段及受影响行数
  		//w rset.%Get("BS_RowID") 显示指定字段
  		//rset.%ResultColumnCount 受影响字段数
  		//rset.%StatementTypeName 操作指令名
  		for i=1:1:rset.%ResultColumnCount s plist(i)=rset.%GetData(i)
  		break
  		}
		if SQLCODE||(plist(1)="")
		{
			TROLLBACK
			q SQLCODE
		}
		s plist(1)=""
		//&SQL(insert into sqluser.DHC_EQCBuildingStruct Values :plist())
		}
		if SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}*/
	
		if (AFCheckListDR'="")
		{
			&SQL(Insert Into sqluser.DHC_EQAffix
			(AF_EquipDR,AF_AffixDR,AF_AffixCatDR,AF_PartSpec,AF_PartModel,AF_ManuFactoryDR,
		 	AF_QuantityNum,AF_ReceiverDR,AF_LeaveFacNo,AF_LeaveDate,AF_PriceFee,
		 	AF_Remark,AF_CurrencyDR,AF_DisuseFlag,AF_InvalidFlag,AF_UpdateUserDR,
		 	AF_CheckListDR,AF_OldRowID,AF_OperFlag)
			Select AF_EquipDR,AF_AffixDR,AF_AffixCatDR,AF_PartSpec,AF_PartModel,AF_ManuFactoryDR,
		 	AF_QuantityNum,AF_ReceiverDR,AF_LeaveFacNo,AF_LeaveDate,AF_PriceFee,
		 	AF_Remark,AF_CurrencyDR,AF_DisuseFlag,AF_InvalidFlag,AF_UpdateUserDR,
		 	:OCLRowID,AF_OldRowID,AF_OperFlag
 			From sqluser.DHC_EQAffix Where AF_CheckListDR=:CheckListDR)
			if SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}			
		}
		if (DOCCheckListDR'="")
		{
			&SQL(Insert Into sqluser.DHC_EQDoc
			(DOC_DocOriginalDR,DOC_DocName,DOC_LocDR,DOC_ManagerDR,DOC_ShareNum,DOC_PagesNum,
		 	DOC_Remark,DOC_AddUserDR,DOC_AddDate,DOC_AddTime,DOC_UpdateUserDR,DOC_UpdateDate,DOC_UpdateTime,DOC_EquipDR,
		 	DOC_DocTypeDR,DOC_CheckListDR,DOC_OldRowID,DOC_OperFlag)
	 		Select DOC_DocOriginalDR,DOC_DocName,DOC_LocDR,DOC_ManagerDR,DOC_ShareNum,DOC_PagesNum,
		 	DOC_Remark,:User,:Date,:Time,DOC_UpdateUserDR,DOC_UpdateDate,DOC_UpdateTime,
		 	DOC_EquipDR,DOC_DocTypeDR,:OCLRowID,DOC_OldRowID,DOC_OperFlag
 	 		From sqluser.DHC_EQDoc Where DOC_CheckListDR=:CheckListDR)
			if SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
		if (ConfigCheckListDR'="")
		{
			&SQL(Insert Into sqluser.DHC_EQConfig
			(C_Type,C_SourceType,C_SourceID,C_ItemDR,C_Item,C_Price,C_QuantityNum,C_UnitDR,C_BrandDR,C_ProviderDR,C_ManuFactoryDR,C_Spec,C_Model,C_Parameters,C_GuaranteePeriodNum,C_CountryDR,C_LeaveFacNo
			,C_LeaveDate,C_Location,C_ReceiverDR,C_MeasureFlag,C_GuaranteeStartDate,C_GuaranteeEndDate,C_DisuseFlag,C_DisuseDate,C_InvoiceNo,C_OpenFlag,C_Remark,C_Status,C_UpdateUserDR,C_UpdateDate
			,C_UpdateTime,C_AuditUserDR,C_AuditDate,C_AuditTime,C_ServiceHandler,C_ServiceTel,C_RegisterNo,C_RecomendYears,C_Hold3,C_Hold4,C_Hold5,C_Hold6)
	 		Select C_Type,C_SourceType,:OCLRowID,C_ItemDR,C_Item,C_Price,C_QuantityNum,C_UnitDR,C_BrandDR,C_ProviderDR,C_ManuFactoryDR,C_Spec,C_Model,C_Parameters,C_GuaranteePeriodNum,C_CountryDR,C_LeaveFacNo
			,C_LeaveDate,C_Location,C_ReceiverDR,C_MeasureFlag,C_GuaranteeStartDate,C_GuaranteeEndDate,C_DisuseFlag,C_DisuseDate,C_InvoiceNo,C_OpenFlag,C_Remark,'0',:User,:Date
			,:Time,C_AuditUserDR,C_AuditDate,C_AuditTime,C_ServiceHandler,C_ServiceTel,C_RegisterNo,C_RecomendYears,C_Hold3,C_Hold4,C_Hold5,C_Hold6
 	 		From sqluser.DHC_EQConfig Where C_SourceType=1 and C_SourceID=:CheckListDR)
			if SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
 	TCOMMIT
 	q OCRRowID
}

/// 新增：2009-11-25 党军 DJ0037
/// 描述：入库单设备来源类型使用下拉列表控件
/// w ##Class(web.DHCEQOpenCheckRequest).SourceTypeList("SourceType",130)
ClassMethod SourceTypeList(name, width) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,width)   //hisui改造 add by kdf
    s SourceType=##class(web.DHCEQCommon).GetSysInfo("201001")  //modified by wy 2019-05-17 868277   begin
    i SourceType="" d		//modified by czf 20200426
    .w "<option value=0>设备项</option>"
	.w "</select>",!
	e  d
	.s Len=$l(SourceType,",")
	.f i=1:1:Len d
	..s ID=$p(SourceType,",",i)
	..q:ID=""
	..s Desc=$case(ID,"0":"设备项","1":"采购合同","2":"招标","3":"计划单","4":"协议合同","5":"投放合同")
	..w "<option value="_ID_">"_Desc_"</option>"
	.w "</select>",!
    /*
	s ContractIDs=##class(web.DHCEQCommon).GetSysInfo("201012")		//modified by czf 20181109
    i SourceType'=0 d        
    .i SourceType=1 d
    ..s Len=$l(ContractIDs,",")
	..f i=1:1:Len d
	...s ID=$p(ContractIDs,",",i)
	...q:ID=""
	...s Desc=$case(ID,"1":"采购合同","4":"协议合同","5":"投放合同")
	...w "<option value="_ID_">"_Desc_"</option>"
	..w "</select>",!
	.e  d
	..w "<option value=0>设备项</option>"
	..s Len=$l(ContractIDs,",")
	..f i=1:1:Len d
	...s ID=$p(ContractIDs,",",i)
	...q:ID=""
	...s Desc=$case(ID,"1":"采购合同","4":"协议合同","5":"投放合同")
	...w "<option value="_ID_">"_Desc_"</option>"
	..;w "<option value=2>采购单</option>"
	..w "<option value=3>计划单</option>"
	..w "</select>",!
    e  d
	.w "<option value=0>设备项</option>"
	.w "<option value=3>计划单</option>"
	.w "</select>",!       //end
	*/
}

/********************************************************************/
/// Mozy0217  2018-11-01	增加合同类型处置
/// Modified by jdl 2012-3-7 JDL0120
/// 增加返回使用年限
/// ------------------------------------------------------------
/// Modified by jdl 2011-3-25
/// 整理获取合同列表方法
/// ------------------------------------------------------------
/// 新增:2009-11-25 党军 DJ0037
/// 描述:选择合同列表中未验收或未验收完设备
/// d ##Class(%ResultSet).RunQuery("web.DHCEQOpenCheckRequest","GetContractList","")
Query GetContractList(Name, AssetType As %Library.String = "", ContractType As %Library.String = "", CurGroupID As %Library.String = "") As %Query(ROWSPEC = "TName:%String,HIDDEN:%String,TModel:%String,TNum:%String,TProvider:%String,TManuFac:%String,TContractNo:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,TContractName:%String,HIDDEN:%String,TCommonName:%String,TFileNo:%String")
{
}

ClassMethod GetContractListExecute(ByRef qHandle As %Binary, Name, AssetType As %Library.String = "", ContractType As %Library.String = "", CurGroupID As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s CurDate=+$H
	s rowid=0
	d BuildDataGetContractList
	Quit $$$OK
BuildDataGetContractList
	s TContractDR=0
	f  s TContractDR=$o(^DHCEQContract(0,"Status",2,TContractDR)) quit:TContractDR=""  d
	.s TContractName=$p($g(^DHCEQContract(TContractDR)),"^",1)
	.s TContractNo=$p($g(^DHCEQContract(TContractDR)),"^",2)
	.s TContractType=$p($g(^DHCEQContract(TContractDR)),"^",39)  //add by lmm 2107-07-18 405602
	.q:(TContractType'="0")    //add by lmm 2107-07-18 405602
	.// Mozy0217  2018-11-01
	.q:(ContractType'="")&&(ContractType'=TContractType)
	.s TStartDate=+$p($g(^DHCEQContract(TContractDR)),"^",11)  //StartDate 
	.s TEndDate=+$p($g(^DHCEQContract(TContractDR)),"^",12)  //EndDate
	.q:(ContractType=2)&&(ContractType=TContractType)&&((TEndDate<CurDate)||(TStartDate>CurDate))
	.s TProviderDR=$p($g(^DHCEQContract(TContractDR)),"^",18)
	.i TProviderDR'="" d
	..s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)
	.
	.s rowid=0
	.f  s rowid=$o(^DHCEQContractList(0,"Contract",TContractDR,rowid)) quit:rowid=""  d
	..d ResetVariablesGetContractList
	..s TRowID=rowid
	..s ArriveNum=##class(web.DHCEQOpenCheck).GetArriveNum("","",rowid)
	..// Mozy0217  2018-11-01
	..q:(TContractType=0)&&(ArriveNum'>0)
	..q:(TContractType=3)&&(ArriveNum'>0)
	..i TContractType="2" s ArriveNum=0	//协议合同数量为空,减了已经到货的数量会是负数.
	..s TCommonName = $p($g(^DHCEQContractList(rowid)),"^",2)	//2013-06-24 DJ0118
	..s TFileNo=$p($g(^DHCEQContract(TContractDR)),"^",52)  //档案号
	..s ItemDR= $p($g(^DHCEQContractList(rowid)),"^",18)
	..s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1) //2013-06-24 DJ0118
	..s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",2)
	..q:(Name'="")&&(TContractName'[Name)&&(TName'[Name)&&($e(TContractNo,1,$l(Name))'=Name)&&($ZCONVERT($e(TCode,1,$l(Name)),"U")'=Name)
	..s TModelDR = $p($g(^DHCEQContractList(rowid)),"^",3)
	..i TModelDR '=""  d
	...s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..s TManuFacDR = $p($g(^DHCEQContractList(rowid)),"^",4)
	..i TManuFacDR '=""  d
	...s TManuFac = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFacDR)		//modified by czf 1252357
	..s TNum=ArriveNum
	..s TEquipTypeDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
	..q:((TEquipTypeDR'="")&&(##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)'=0))
	..i TEquipTypeDR '="" d
	...s TEquipType = $P(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR),"^",2)
	..s TStatCatDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",5)
	..i TStatCatDR '="" d
	...s TStatCat = $P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
	..Quit:(TStatCatDR'="")&&(AssetType'="")&&(AssetType'=0)&&(AssetType'=$Piece(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",5))	///modified by GR0027 卫计委与武汉资产类型兼容 
	..s TEquipCatDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
	..i TEquipCatDR '="" d
	...s TEquipCat = $P(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR),"^",2)
	..s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",7)
	..i TUnitDR'="" d
	...s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..
	..;Modified by jdl 2012-3-7 JDL0120
	..s TLimitYears=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TEquipCatDR,TStatCatDR)
	..
	..d OutputRowGetContractList
	quit
OutputRowGetContractList
	s Data=$lb(TName,TRowID,TModel,TNum,TProvider,TManuFac,TContractNo,TCode,TEquipType,TEquipTypeDR,TStatCat,TStatCatDR,TEquipCat,TEquipCatDR,TUnit,TUnitDR,TModelDR,TProviderDR,TManuFacDR,TContractName,TLimitYears,TCommonName,TFileNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContractList
	s (TName,TRowID,TModel,TNum,TManuFac,TCode,TEquipType,TEquipTypeDR,TStatCat,TStatCatDR,TEquipCat,TEquipCatDR,TUnit,TUnitDR,TModelDR,TManuFacDR,TCommonName,TFileNo)=""
	;s (TProvider,TContractNo,TProviderDR)=""
	s TLimitYears=""
	quit
}

ClassMethod GetContractListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractListExecute ]
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

ClassMethod GetContractListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/********************************************************************/
/// ------------------------------------------------------------
/// Modified by jdl 2012-3-7 JDL0120
/// 增加返回使用年限
/// ------------------------------------------------------------
/// d ##class(%ResultSet).RunQuery("web.DHCEQOpenCheckRequest","GetBPList","","3")
/// add by lmm 2018-03-01 523557 增加出参 TPurchaseTypeDR TPurchaseType
Query GetBPList(Name, type, AssetType As %Library.String = "") As %Query(ROWSPEC = "TName:%String,HIDDEN:%String,TModel:%String,TNum:%String,TManuFac:%String,TBuyPlanNo:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,TBuyPlanName:%String,HIDDEN:%String,TCommonName:%String,HIDDEN:%String,TPurposeType:%String,TPurchaseTypeDR:%String,TPurchaseType:%String")
{
}

/// Modified by jdl 2011-3-24
/// 重新整理获取计划列表方法
ClassMethod GetBPListExecute(ByRef qHandle As %Binary, Name, type, AssetType As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;type 2:采购单 3:计划单
	s index=1
	s rowid=0
	d BuildDataGetBPList
	Quit $$$OK
BuildDataGetBPList
	
	s TEquipTypeDR=0
	f  s TEquipTypeDR=$o(^DHCEQBuyPlan(0,"EquipType",TEquipTypeDR)) quit:TEquipTypeDR=""  d
	.;过滤掉不能访问的类组
	.q:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
	.s TEquipType = $P(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR),"^",2)
	.s TBuyPlanDR=0
	.f  s TBuyPlanDR=$o(^DHCEQBuyPlan(0,"EquipType",TEquipTypeDR,TBuyPlanDR)) quit:TBuyPlanDR=""  d
	..;过滤掉状态非审核的
	..q:$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",6)'=2
	..s (TPurposeTypeDR,TPurposeType)=""
	..s (TPurchaseTypeDR,TPurchaseType)=""  ;add by lmm 2018-03-01 begin 523557
	..;获取计划信息
	..s TBuyPlanName=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",1)
	..s TBuyPlanNo=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",25)	
	..s TUrgencyFlag=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",33)
	..s TPurposeTypeDR=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",42)
	..i TPurposeTypeDR'="" s TPurposeType=$P(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR),"^",2)
	..;add by lmm 2018-03-01 begin 523557
	..s TPurchaseTypeDR=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",28)
	..i TPurchaseTypeDR'="" s TPurchaseType=$P(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR),"^",2)
	..;add by lmm 2018-03-01 end 523557
	..;获取计划明细信息
	..s rowid=0
	..f  s rowid=$o(^DHCEQBuyPlanList(0,"BuyPlan",TBuyPlanDR,rowid)) quit:rowid=""  d
	...d ResetVariablesGetBPList
	...s TRowID = rowid
	...s TCommonName = $p($g(^DHCEQBuyPlanList(rowid)),"^",2)	//2013-06-24 DJ0118
	...s TModelDR=$p($g(^DHCEQBuyPlanList(rowid)),"^",3)
	...i TModelDR'="" s TModel=$P(^DHCEQCCode("DHCEQCModel",TModelDR),"^",2)
	...s TManuFacDR=$p($g(^DHCEQBuyPlanList(rowid)),"^",4)
	...i TManuFacDR'="" s TManuFac=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFacDR)		//modified by czf 1252357
	...s TTestFlag=$p($g(^DHCEQBuyPlanList(rowid)),"^",5)
	...s TPrice=$p($g(^DHCEQBuyPlanList(rowid)),"^",6)
	...s TQuantityNum = $p($g(^DHCEQBuyPlanList(rowid)),"^",7)
	...s TArriveNum=$p($g(^DHCEQBuyPlanList(rowid)),"^",17)
	...s TNum=TQuantityNum-TArriveNum
	...q:TNum<1
	...
	...s ItemDR= $p($g(^DHCEQBuyPlanList(rowid)),"^",18)
	...i ItemDR'="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1) //2013-06-24 DJ0118
	...s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",2)
	...q:(Name'="")&&(TName'[Name)&&(TBuyPlanName'[Name)&&($e(TBuyPlanNo,1,$l(Name))'=Name)&&($ZCONVERT($e(TCode,1,$l(Name)),"U")'=Name)
	...s TStatCatDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",5)
	...i TStatCatDR '="" s TStatCat = $P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
	...Quit:(TStatCatDR'="")&&(AssetType'="")&&(AssetType'=0)&&(AssetType'=$Piece(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",5))	/// modified by GR0027 卫计委与武汉资产类型兼容
	...s TEquipCatDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
	...i TEquipCatDR '="" s TEquipCat = $P(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR),"^",2)
	...s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",7)
	...i TUnitDR'="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	...
	...;Modified by jdl 2012-3-7 JDL0120
	...s TLimitYears=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TEquipCatDR,TStatCatDR)
	...
	...d OutputRowGetBPList
	
	quit
OutputRowGetBPList
	s Data=$lb(TName,TRowID,TModel,TNum,TManuFac,TBuyPlanNo,TCode,TEquipType,TEquipTypeDR,TStatCat,TStatCatDR,TEquipCat,TEquipCatDR,TUnit,TUnitDR,TModelDR,TManuFacDR,TTestFlag,TUrgencyFlag,TPrice,ItemDR,TBuyPlanName,TLimitYears,TCommonName,TPurposeTypeDR,TPurposeType,TPurchaseTypeDR,TPurchaseType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBPList
	s (TName,TRowID,TModel,TNum,TManuFac,TCode,TStatCat,TStatCatDR,TEquipCat,TEquipCatDR,TUnit,TUnitDR,TModelDR,TManuFacDR,TTestFlag,TPrice,ItemDR,TCommonName)=""
	;s (TBuyPlanNo,TEquipType,TEquipTypeDR,TUrgencyFlag)="
	s TLimitYears=""
	quit
}

ClassMethod GetBPListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBPListExecute ]
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

ClassMethod GetBPListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBPListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/********************************************************************/
/// 新增:2009-11-25 党军 DJ0037
/// 描述:取当前来源类型单据设备可用数量
/// w ##class(web.DHCEQOpenCheckRequest).UsableQuantity("^2^24")
ClassMethod UsableQuantity(val As %Library.String = "")
{
	s rowid=$p(val,"^",1)
	s type=$p(val,"^",2)
	s id=$p(val,"^",3)
	i +type=0 q 0 //设备项
	s Quantity=0
	s return=0		//czf 20200601 1339398
	i rowid'=""
	{
		s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,0))
		s sourcetype=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
		s sourceid=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
		i (sourcetype=type)&&(sourceid=id)
		{
			s Quantity=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
		}
	}
	i (type=1)||(type=4)||(type=5)	//合同 modified by czf 20181107
	{
		/// 2018-05-18 Modified By ZY ZY0169	// Mozy0217  2018-11-01
		/// 协议合同没有数量只有金额,返回最大值999
		s ContractDR=$p($G(^DHCEQContractList(id)),"^",1)
		s ContractType=$p($G(^DHCEQContract(ContractDR)),"^",39)
		i ContractType=2
		{
			//s DefaultNum=##class(web.DHCEQCommon).GetSysInfo("201007")
			//s return=$p(DefaultNum,",",2)
			s return=999
		}
		else
		{
			s return=##class(web.DHCEQOpenCheck).GetArriveNum("","",id)
		}
	}
	///Modified BY ZY0232 20200527
	i (type=2)||(type=3) //计划单
	{
		s TQuantityNum = $p($g(^DHCEQBuyPlanList(id)),"^",7)
		s TArriveNum=$p($g(^DHCEQBuyPlanList(id)),"^",17)
		i TQuantityNum="" s TQuantityNum=0
		i TArriveNum="" s TArriveNum=0
		s return=TQuantityNum-TArriveNum
	}
	s return=return+Quantity
	i return<0 q 0
	q return
}

/********************************************************************/
/// modified by ZY0260 20210428
/// 新增:2009-11-25 党军 DJ0037
/// 描述:更新来源单据
/// 入参：type:1 合同  2、3采购计划
/// 	  id:  合同明细ID或采购计划明细id
/// 	  oldnum:更新的数量
/// 	  oper:操作 1 新增，2删除
/// 返回:0：正常 其他：失败 其中 -1为验收数量总和已大于合同或计划的数量
ClassMethod SourceUpdate(type, id, oldnum, oper, UseLocDR As %Library.String = "", sysflag As %Library.String = "")
{
	k PLISTC,PLISTBP
	i +type<0 q 0
	i (type=1)||(type=4)||(type=5) ;1:采购合同 4:协议合同 5:投放合同	modified by czf 20181109
	{
		;ArriveQuantity
		s num=$p($g(^DHCEQContractList(id)),"^",12)
		i oper=1 ;+
		{
			s PLISTC(13)=num+oldnum
		}
		i oper=2 ;-
		{
			s PLISTC(13)=num-oldnum
			if num<oldnum q -1
		}
		
		&SQL(Update SQLUSER.DHC_EQContractList Values :PLISTC() where CTL_RowID=:id)
		i SQLCODE q SQLCODE
		//modified by ZY0266 20210531
		///增加合同明细字表的处理.
		s LocListFlag=##class(web.DHCEQCommon).GetSysInfo("201015")
		i LocListFlag=1
		{
			///modified by ZY0273 202100707
			if (sysflag=0)
			{
				i oper=1 ;+
				{
					&SQL(Update SQLUSER.DHC_EQContractListLoc set CLL_ArrivedQuantity=CLL_Quantity where CLL_ContractListDR=:id)
				}
				i oper=2 ;-
				{
					&SQL(Update SQLUSER.DHC_EQContractListLoc set CLL_ArrivedQuantity=null where CLL_ContractListDR=:id)
				}
			}
			else
			{
				s CLLRowID=""
				&SQL(select CLL_RowID into :CLLRowID  from SQLUSER.DHC_EQContractListLoc where CLL_ContractListDR=:id and CLL_BuyLocDR=:UseLocDR)
				if CLLRowID="" q 0 //Modified By QW20210728 BUG:QW0141
				///modified by ZY0269 20210615
				s CLLArrivedQuantity=$p($g(^DHCEQContractListLoc(CLLRowID)),"^",6)
				i oper=1 ;+
				{
					s CLLArrivedQuantity=CLLArrivedQuantity+oldnum
				}
				i oper=2 ;-
				{
					s CLLArrivedQuantity=CLLArrivedQuantity-oldnum		//czf 20210707 删除操作到达数量减
				}
				&SQL(Update SQLUSER.DHC_EQContractListLoc set CLL_ArrivedQuantity=:CLLArrivedQuantity where CLL_RowID=:CLLRowID)
			}
			i SQLCODE=100 s SQLCODE=0	//czf 20210707 采购合同没有填写申购明细，根据采购合同验收，保存报错
			i SQLCODE q SQLCODE
		}
		
		s CTLBPLDR=$p($g(^DHCEQContractList(id)),"^",17)
		;SourceType 1:计划 2:招标 3:设备项
		;如果是招标,检查招标是否引用的是计划
		i ($p($g(^DHCEQContractList(id)),"^",5)=2)
		{
			i CTLBPLDR'=""
			{
				;ExtendType 0：设备项 1采购申请 2采购计划
				i $p($g(^DHCEQIFBBag(CTLBPLDR)),"^",9)=2
				{
					s CTLBPLDR=$p($g(^DHCEQIFBBag(CTLBPLDR)),"^",10)					
				}
				else
				{
					s CTLBPLDR=""
				}
			}
		}
		elseif ($p($g(^DHCEQContractList(id)),"^",5)=3)
		{
			s CTLBPLDR=""
		}
		
		i CTLBPLDR'=""
		{
			s num=$p($g(^DHCEQBuyPlanList(CTLBPLDR)),"^",17)
			i oper=1
			{
				s PLISTBP(18)=num+oldnum
			}
			i oper=2
			{
				s PLISTBP(18)=num-oldnum
				if num<oldnum q -1
			}			
			&SQL(Update SQLUSER.DHC_EQBuyPlanList Values :PLISTBP() where BPL_RowID=:CTLBPLDR)
		}
	}
	i (type=2)||(type=3) ;2.采购单 3.计划单
	{
		s num=$p($g(^DHCEQBuyPlanList(id)),"^",17)
		i oper=1
		{
			s PLISTBP(18)=num+oldnum
		}
		i oper=2
		{
			s PLISTBP(18)=num-oldnum
			if num<oldnum q -1
		}
		&SQL(Update SQLUSER.DHC_EQBuyPlanList Values :PLISTBP() where BPL_RowID=:id)
	}
	i SQLCODE q SQLCODE
	q 0
}

/********************************************************************/
ClassMethod OCRToDelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OCRToDelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OCRToDelExecute(ByRef qHandle As %Binary, QXType As %String = "", Equip As %String = "", ProviderDR As %String = "", EquipTypeDR As %String = "", StartDate As %String = "", EndDate As %String = "", HospitalDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	s rowid=0
	s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")	//HISUI改造 add by czf 20181011
	s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	d BuildDataGetOCRToDel
	Quit $$$OK
BuildDataGetOCRToDel
	s EquipTypeIDS=##class(web.DHCEQCommon).GetEquipTypesByGroup("")
	;s EquipTypeIDS=""
	q:EquipTypeIDS=""
	s EquipTypeIDS="^"_EquipTypeIDS_"^"
	s OCRCheckType=""
	f  s OCRCheckType=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType)) q:OCRCheckType=""  d
	.s TEquipTypeDR=0
	.f  s TEquipTypeDR=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType,TEquipTypeDR)) q:TEquipTypeDR=""  d
	..s OCRRowID=0
	..Quit:(EquipTypeDR'="")&(TEquipTypeDR'=EquipTypeDR)
	..q:EquipTypeIDS'[("^"_TEquipTypeDR_"^")
	..f  s OCRRowID=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType,TEquipTypeDR,"2",OCRRowID)) q:OCRRowID=""  d
	...d ResetVariablesGetOCRToDel
	...;过滤无效
	...s InvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
	...q:InvalidFlag="Y"
	...s TOpenCheckRequestNo=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",37)	//Add By DJ 2015-08-20 DJ0157
	...//Modified by JDL 2010-11-22 JDL0059 修正删除判断错误
	...s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	...q:OCLRowID=""
	...q:##class(web.DHCEQCommon).FundsTypeIsIn(0,OCLRowID)	// Mozy0231	资金来源类型
	...;根据验收单检测当前验收单是否存在入库记录
	...s Find=0
	...;Modified By JDL 2011-10-12 JDL0098 判断是否在有效的入库单中
	...s ISLRowID=0
	...f  s ISLRowID=$o(^DHCEQInStockList(0,"Source","2",OCLRowID,ISLRowID)) q:(ISLRowID="")||(Find'=0)  d
	....q:($p(^DHCEQInStock($p(^DHCEQInStockList(ISLRowID),"^",1)),"^",25)="Y")
	....s Find=Find+1
	...q:Find'=0
	...;根据验收单对应设备检测是否已经有部分或全部设备存在入库记录
	...;s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	...;q:OCLRowID=""
	...s EQRowID=0
	...f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",OCLRowID,EQRowID)) q:(EQRowID="")||(Find'=0)  d
	....s Find=$o(^DHCEQInStockList(0,"Equip",EQRowID,0))
	....i Find="" s Find=0
	...q:Find'=0
	...;基本信息
	...s TRowID=OCRRowID
	...i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	...s TCommonName=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",2)	//2013-06-24 DJ0118 begin
	...s TEquip=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",9)
	...i TEquip'="" s TEquip=$p($g(^DHCEQCCode("DHCEQCMasterItem",TEquip)),"^",1) //2013-06-24 DJ0118 end
	...Quit:(Equip'="")&(TEquip'[Equip)
	...s OpenCheckDate=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",10)
	...Quit:(EndDate'="")&(OpenCheckDate>EndDate)
	...Quit:(StartDate'="")&(OpenCheckDate<StartDate)
	...s TOpenCheckDate=##class(web.DHCEQCommon).TransValueToPage(OpenCheckDate,"date")
	...s TStatCat=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",4)
	...i TStatCat'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCat)),"^",2)
	...s TEquipCat=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",6)
	...i TEquipCat'="" s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCat)),"^",2)
	...s TOriginalFee=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",17)
	...s TUnit=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",7)
	...i TUnit'="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	...s TProvider=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",5)
	...Quit:(ProviderDR'="")&(TProvider'=ProviderDR)
	...i TProvider'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
	...s TCountry=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",11)
	...i TCountry'="" s TCountry=##class(web.DHCEQCommon).GetTrakNameByID("cou",TCountry)
	...s TManuFacturer=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",15)
	...i TManuFacturer'="" s TManuFacturer=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFacturer)		//modified by CZF0093 2020-03-17
	...s TAddUser=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",22)
	...i TAddUser'="" s TAddUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUser)
	...s TModel=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",5)
	...i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	...s TQuantity=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
	...s TAmount=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee*TQuantity,"")
	...s StoreLocDR=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",31) //设备库房 2010-10-26 DJ begin
	...s Find=0
	...i StoreLocDR'=""  d
	....s Find=##Class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocDR)
	...q:Find'=0 //2010-10-26 DJ End
	...Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID($p($g(^DHCEQOpenCheckList(OCLRowID)),"^",33)) ;Add QW20210629 BUG:QW0131
	...q:(HospitalDR'="")&&(HospitalDR'=THospitalDR) ;Add QW20210629 BUG:QW0131
	...s TRow=TRow+1		//Modify DJ 2015-09-21 DJ0165
	...d OutputRowGetOCRToDel
	quit
OutputRowGetOCRToDel
	s Data=$lb(TRowID,TEquip,TEquipNo,TOpenCheckDate,TEquipType,TStatCat,TEquipCat,TOriginalFee,TUnit,TProvider,TCountry,TManuFacturer,TAddUser,TModel,TQuantity,TAmount,TCommonName,TOpenCheckRequestNo,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOCRToDel
	s (TRowID,TEquip,TEquipNo,TOpenCheckDate,TEquipType,TStatCat,TEquipCat,TOriginalFee,TUnit,TProvider,TCountry,TManuFacturer,TAddUser,TModel,TQuantity,TAmount,TCommonName,TOpenCheckRequestNo)=""
	quit
}

ClassMethod OCRToDelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OCRToDelExecute ]
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

/// Add QW20210629 BUG:QW0131 增加输入参数院区HospitalDR
Query OCRToDel(QXType As %String = "", Equip As %String = "", ProviderDR As %String = "", EquipTypeDR As %String = "", StartDate As %String = "", EndDate As %String = "", HospitalDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquip:%String,TEquipNo:%String,TOpenCheckDate:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TOriginalFee:%String,TUnit:%String,TProvider:%String,TCountry:%String,TManuFacturer:%String,TAddUser:%String,TModel:%String,TQuantity:%String,TAmount:%String,TCommonName:%String,TOpenCheckRequestNo:%String,TRow:%String")
{
}

/********************************************************************/
ClassMethod OCREquipDelete(OCRRowID)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	//Modified by JDL 2010-11-22 JDL0059 修正删除判断错误
	;根据验收单对应设备检测是否已经有部分或全部设备存在入库记录
	s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	i OCLRowID="" q -98 //当前设备无明细记录
	
	;根据验收单检测当前验收单是否存在入库记录
	s Find=0
	;Modified By JDL 2011-10-12 JDL0098 判断是否在有效的入库单中
	s ISLRowID=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"Source","2",OCLRowID,ISLRowID)) q:(ISLRowID="")||(Find'=0)  d
	.q:($p(^DHCEQInStock($p(^DHCEQInStockList(ISLRowID),"^",1)),"^",25)="Y")
	.s Find=Find+1
	i Find'=0 q -99 //当前设备已经入库
	
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",OCLRowID,EQRowID)) q:(EQRowID="")||(Find'=0)  d
	.s Find=$o(^DHCEQInStockList(0,"Equip",EQRowID,0))
	.i Find="" s Find=0
	i Find'=0 q -99 //当前设备已经入库	
	TSTART
	//验收总单
	s ^DHCEQDelete("DHCEQOpenCheckRequest",OCRRowID)=$g(^DHCEQOpenCheckRequest(OCRRowID))
	s ^DHCEQDelete("DHCEQOpenCheckRequest",OCRRowID,"Info")=User_"^"_$H
	//验收细单
	s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	i OCLRowID="" q ""
	s ^DHCEQDelete("DHCEQOpenCheckRequest",OCRRowID,"List",OCLRowID)=$g(^DHCEQOpenCheckList(OCLRowID))
	//恢复来源单据 2010-06-11 党军 begin
	s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
	s OCLNum=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
	//modified by ZY0252 20210301
	s OCLUseLocDR=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",33)
	// Mozy0028		2010-11-01
	if +OCLSourceType'=0
	{
		s return=..SourceUpdate(OCLSourceType,OCLSourceID,OCLNum,2,OCLUseLocDR)
		if return
		{
			TROLLBACK
			q return
		 }
	}
	//2010-06-11 党军 end
	&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Set OCR_InvalidFlag='Y',OCR_CancelUser=:User,OCR_CancelDate=:Date,OCR_CancelTime=:Time Where OCR_RowID=:OCRRowID)
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	&SQL(Update SQLUSER.DHC_EQEquip Set EQ_InvalidFlag='Y' Where EQ_OpenCheckListDR=:OCLRowID)
	i SQLCODE=100 s SQLCODE=0
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q OCRRowID
}

/********************************************************************/
/// Add by jdl 2010-12-04  增加验收单导入附件及发票号信息
/// 入参：CheckListDR验收单明细ID
/// 		AffixInfos：附件信息串，多条之间以“&”分割，每条的字段间以“^”分割
/// 		///InvoiceInfos：发票信息串，多个发票号之间以","分割
/// 返回：1：操作成功
/// 	  0：未操作
/// 	  -1001：插入附件信息失败
/// 	  -1002：插入发票信息失败
/// 	  ClassMethod ImportAffixInfo(CheckListDR, AffixInfos, InvoiceInfos) 	
ClassMethod ImportAffixInfo(CheckListDR, AffixInfos)
{
	k APLIST
	k IPLIST
	k MPLIST
	
	i CheckListDR="" q 0
	Set $ZT="ErrImportAffix" //2009-07-10 党军
	TStart
	s SQLCODE=0
	i AffixInfos'=""
	{
		s APLIST(15) = "N"			;AF_DisuseFlag
		s APLIST(16) = "N"			;AF_InvalidFlag
		s APLIST(20) = CheckListDR  ;AF_CheckListDR
		s APLIST(27)= "N"	;Hold2	追加标志
		s Num=$l(AffixInfos,"&")
		for i=1:1:Num
		{
			q:SQLCODE
			s val=$p(AffixInfos,"&",i)
			d InsertAffix
		}
		i SQLCODE
		{
			TRollBack
			q -1001_"^"_SQLCODE		;导入附件失败
		}
	}
	/*
	i InvoiceInfos'=""
	{		
		;s IPLIST(4) = $p(^DHCEQOpenCheckList(CheckListDR),"^",58)		;Date
		s IPLIST(6) = $p(^DHCEQOpenCheckRequest($p(^DHCEQOpenCheckList(CheckListDR),"^",1)),"^",5)		;ProviderDR
		
		s IPLIST(11) = 0					;Status
		s IPLIST(12) = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))		;SubmitUserDR
		s IPLIST(13) = +$Horolog						;SubmitDate
		s IPLIST(14) = $Piece($Horolog,",",2)			;SubmitTime
			
		
		s Num=$l(InvoiceInfos,",")
		for i=1:1:Num
		{
			q:SQLCODE
			i $p(InvoiceInfos,",",i)'=""
			{
				s IPLIST(3) = $p(InvoiceInfos,",",i)		;No			
				&SQL(Insert Into SQLUSER.DHC_EQInvoice Values :IPLIST())
				i SQLCODE q
				s ID=$Get(%ROWID)
				Set MPLIST(2) = CheckListDR				;SourceID
				Set MPLIST(3) = ID					;InvoiceDR
				Set MPLIST(4) = 2					;Type
				&SQL(Insert Into SQLUSER.DHC_EQInvoiceUseMap Values :MPLIST())
			}
		}
		i SQLCODE
		{
			TRollBack
			q -1002_"^"_SQLCODE		;导入发票号失败
		}
	}
	*/
	TCommit
	q 1
InsertAffix
	;s APLIST(1) = $p(val,"^",1)	;RowID
	;s APLIST(2) = $p(val,"^",2)	;EquipDR
	;s APLIST(3) = $p(val,"^",3)	;AffixDR
	;s APLIST(4) = $p(val,"^",4)	;AffixCatDR
	s APLIST(5) = $p(val,"^",1)	;PartSpec
	s APLIST(6) = $p(val,"^",2)	;PartModel
	
	s APLIST(8) = $p(val,"^",4)	;QuantityNum
	;s APLIST(9) = $p(val,"^",9)	;ReceiverDR
	s APLIST(10) = $p(val,"^",3)	;LeaveFacNo
	;s APLIST(11) = $p(val,"^",11)	;LeaveDate
	;i $p(val,"^",11)'=""  s APLIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"date")	;LeaveDate
	;s APLIST(12) = $p(val,"^",12)	;PriceFee
	s APLIST(13) = $p(val,"^",7)	;Remark
	
	i $p(val,"^",5)'=""
	{
		s UnitDesc=$p(val,"^",5)
		
		;Modified By jdl 20150906 v4.1.0 统一单位取值，不再取CT_UOM中，直接使用DHC_EQUOM
		s UnitID=##Class(web.DHCEQImportDataTool).GetUnitID(UnitDesc)
		;&SQL(select ctuom_rowid into :UnitID from sqluser.ct_uom where ctuom_desc=:UnitDesc)
		
		i UnitID'="" s APLIST(14) = UnitID	;CurrencyDR 
	}
	
	i $p(val,"^",6)'=""
	{
		s ManuFactoryDR=##Class(web.DHCEQCManufacturer).UpdManufacturer($p(val,"^",8)_"^"_$p(val,"^",6))
		if ManuFactoryDR>0
		{	s APLIST(7) = ManuFactoryDR		}
		else
		{	q		}
	}
	
	;s APLIST(15) = "N"			;AF_DisuseFlag
	;s APLIST(16) = "N"			;AF_InvalidFlag
	;s APLIST(20) = CheckListDR  ;AF_CheckListDR
	;s APLIST(25)=$p(val,"^",15) ;ProviderDR
	;s APLIST(26)=$p(val,"^",16) ;Hold1 
	;Set APLIST(27)= "N"	;Hold2	追加标志
	;Set APLIST(28)=$Piece(val,"^",19) ;Hold3	发票号
	;Set APLIST(31)=$Piece(val,"^",18) ;Status
	&SQL(Insert Into SQLUSER.DHC_EQAffix Values :APLIST())
	q
ErrImportAffix
 	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit "_1^"_ErrorMsg     //返回错误消息 ; //2009-07-10 党军 end
}

/// modified by ZY 20220927  修改global
/// Add by jdl 2010-12-6 JDL0061
/// 检测设备序列号是否有重复
/// 入参：	LeaveFactoryNos:序列号的字符串，多个之间以","分割
/// 			SourceType: 1验收单 2设备
/// 			SourceID：对应的ID
/// 返回：
/// 		0：无重复
/// 		1：LeaveFactoryNos:序列号的字符串中有重复的
/// 		2：与设备表中的设备有重复
/// 		3：与其他未审核验收单中有重复
/// 	w ##Class(web.DHCEQOpenCheckRequest).CheckLeaveFactoryNo("","1","10000")
ClassMethod CheckLeaveFactoryNo(LeaveFactoryNos, SourceType, SourceID)
{
	new rowid,Flag,Num,LeaveFactoryNo,RepeatNo,CheckType
	
	i LeaveFactoryNos="" q 0
	
	s Flag=0
    k ^TempDHCEQ("DHCEQOpenCheckRequest","CheckLeaveFactoryNo",$j)
    s Num=$l(LeaveFactoryNos,",")
    for i=1:1:Num
    {
        ;检测序列号串中本身是否有重复的
        q:Flag'=0
        s LeaveFactoryNo=$p(LeaveFactoryNos,",",i)
        i LeaveFactoryNo="" continue
        if $d(^TempDHCEQ("DHCEQOpenCheckRequest","CheckLeaveFactoryNo",$j,"No",LeaveFactoryNo)) s Flag=1
        q:Flag'=0
        s ^TempDHCEQ("DHCEQOpenCheckRequest","CheckLeaveFactoryNo",$j,"No",LeaveFactoryNo)=""
		
		;检测序列号是否与其它未审核验收单中的序列号重复		
		s CheckType=""		
		f  s CheckType=$o(^DHCEQOpenCheckRequest(0,"Status",CheckType))  quit:(CheckType="")||(Flag'=0)  d 
		.s EquipType=0
		.f  s EquipType=$o(^DHCEQOpenCheckRequest(0,"Status",CheckType,EquipType))  quit:(EquipType="")||(Flag'=0)  d
		..s OCRStatus=""
		..f  s OCRStatus=$o(^DHCEQOpenCheckRequest(0,"Status",CheckType,EquipType,OCRStatus))  quit:(OCRStatus="")||(Flag'=0)  d
		...q:OCRStatus>1
		...s OCRRowID=0
		...f  s OCRRowID=$o(^DHCEQOpenCheckRequest(0,"Status",CheckType,EquipType,OCRStatus,OCRRowID))  quit:(OCRRowID="")||(Flag'=0)  d
		....q:(SourceType=1)&&(SourceID=OCRRowID)
		....s rowid=0
		....f  s rowid=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,rowid))  quit:(rowid="")||(Flag'=0)  d
		.....if (","_$g(^DHCEQOpenCheckList(rowid,"EX"))_",")[(","_LeaveFactoryNo_",")  d
		......;b
		......s Flag=3
	}	
    k ^TempDHCEQ("DHCEQOpenCheckRequest","CheckLeaveFactoryNo",$j)
	i Flag'=0 q Flag_"^"_LeaveFactoryNo
	
	;检测序列号是否与台帐中的设备有重复
	s LeaveFactoryNos=","_LeaveFactoryNos_","
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:(rowid="")||(Flag'=0)  d 
	.q:$p($g(^DHCEQEquip(rowid)),"^",59)="Y"		;InvalidFlag
	.q:$p($g(^DHCEQEquip(rowid)),"^",60)=3		;StockStatus
	.q:(SourceType=2)&&(SourceID=rowid)
	.s LeaveFactoryNo=$p($g(^DHCEQEquip(rowid)),"^",10)
	.q:LeaveFactoryNo=""
	.q:LeaveFactoryNos'[(","_LeaveFactoryNo_",")
	.;b
	.s Flag=2
	i Flag=0 q 0
	q Flag_"^"_LeaveFactoryNo
}

/// Add By DJ 2011-04-28
ClassMethod GetSourceFunds(CheckListDR, EquipDR, FundsAmount, FundsType)
{
	n (CheckListDR, EquipDR, FundsAmount, FundsType)
	i (CheckListDR="")&&(EquipDR="") q 0
	s OtherFunds=0
	s rowid=0
	s Flag=0
	s SourceType=""
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	i FundsType'=SelfFundsFlag s SourceType=FundsType
	i CheckListDR'=""  //验收单
	{
		f  s rowid=$o(^DHCEQFunds("0","CheckList",CheckListDR,rowid))  q:rowid=""  d
		.d GetOtherFunds
	}
	else //设备
	{
		//s FundsAmount=$p($g(^DHCEQEquip(EquipDR)),"^",27) //OriginalFee
		s OCLDR=$p($g(^DHCEQEquip(EquipDR)),"^",77) //OpenCheckList
		i OCLDR=""  d //导入设备
		.f  s rowid=$o(^DHCEQFunds("0","Equip",EquipDR,rowid))  q:rowid=""  d
		..d GetOtherFunds
		e  d //正常业务数据
		.f  s rowid=$o(^DHCEQFunds("0","Equip",EquipDR,rowid))  q:rowid=""  d  //改自验收单信息
		..d GetOtherFunds
		.s rowid=0
		.s MaxID=$o(^DHCEQEquip(0,"OpenCheckList",OCLDR,""),-1)
		.s Quantity=$p($g(^DHCEQOpenCheckList(OCLDR)),"^",16)
		.f  s rowid=$o(^DHCEQFunds("0","CheckList",OCLDR,rowid))  q:rowid=""  d //未改自验收单信息
		..q:$d(^DHCEQFunds("0","OldRowEquip",rowid,EquipDR))
		..s Flag=1
		..d GetOtherFunds
	}
	i FundsType=SelfFundsFlag q ##Class(web.DHCEQCommon).FormatNumber(FundsAmount-OtherFunds,"")
	q ##Class(web.DHCEQCommon).FormatNumber(OtherFunds,"")
GetOtherFunds
	s InvalidFlag=$p($g(^DHCEQFunds(rowid)),"^",10)
	q:InvalidFlag="Y"
	s FundsTypeDR=$p($g(^DHCEQFunds(rowid)),"^",2)
	q:FundsTypeDR=SelfFundsFlag //过滤自有资金
	q:(SourceType'="")&&(SourceType'=FundsTypeDR)
	s Funds=$p($g(^DHCEQFunds(rowid)),"^",3)
	i Flag=1 //未改自验收单信息处理
	{
		i MaxID=EquipDR //同批次最后一台设备
		{
			s Funds=Funds-(##Class(web.DHCEQCommon).FormatNumber(Funds/Quantity,"")*(Quantity-1))
		}
		else
		{
			s Funds=##Class(web.DHCEQCommon).FormatNumber(Funds/Quantity,"")
		}
	}
	s OtherFunds=OtherFunds+Funds
	QUIT
}

/******************************************************/
/// Add 2011-05-05 DJ
ClassMethod GetAffixFunds(AffixID, FundsAmount, FundsType)
{
	n (AffixID, FundsAmount, FundsType)
	i AffixID="" q 0
	s OtherFunds=0
	s FAID=0
	s SourceType=""
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	i FundsType'=SelfFundsFlag s SourceType=FundsType
	f  s FAID=$o(^DHCEQFunds("0","Affix",AffixID,FAID)) q:FAID=""  d
	.s InvalidFlag=$p($g(^DHCEQFunds(FAID)),"^",10)
	.q:InvalidFlag="Y"
	.s FundsTypeDR=$p($g(^DHCEQFunds(FAID)),"^",2)
	.q:FundsTypeDR=SelfFundsFlag //过滤自有资金
	.q:(SourceType'="")&&(SourceType'=FundsTypeDR)
	.s Funds=$p($g(^DHCEQFunds(FAID)),"^",3)
	.s OtherFunds=OtherFunds+Funds
	i FundsType=SelfFundsFlag q ##Class(web.DHCEQCommon).FormatNumber(FundsAmount-OtherFunds,"")
	q ##Class(web.DHCEQCommon).FormatNumber(OtherFunds,"")
}

/******************************************************/
/// modified by ZY 20220927  修改global
/// Add By HZY 2011-08-02   HZY0004
/// Description：设备验收明细查询.
/// d ##class(%ResultSet).RunQuery("web.DHCEQOpenCheckRequest","GetCheckDetail")
Query GetCheckDetail(vData As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TABCType:%String,TAppendFeeAmount:%String,TAutoCollectFlag:%String,TBatchNo:%String,TBenefitAnalyFlag:%String,TBuyType:%String,TCheckDate:%String,TCode:%String,TCommonageFlag:%String,TContractList:%String,TContractNo:%String,TCountry:%String,TCurrency:%String,TCurrencyFee:%String,TDepreMethod:%String,TDesignWorkLoadNum:%String,TEquipName:%String,TEquipCat:%String,TEquipTechLevel:%String,TEquipType:%String,TGuaranteeEndDate:%String,TGuaranteeFlag:%String,TGuaranteeStartDate:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TInstallDate:%String,TInstallLoc:%String,TItem:%String,TLeaveFactoryDate:%String,TLimitYearsNum:%String,TMakeDate:%String,TManageLevel:%String,TManageLoc:%String,TManuFactory:%String,TMeasureFlag:%String,TMedicalFlag:%String,TMemoryCode:%String,TModel:%String,TNetRemainFee:%String,TOpenCheckDate:%String,TOpenCheckRequestDR:%String,TOriginalFee:%String,TPackNum:%String,TPackType:%String,TPurchaseType:%String,TPurposeType:%String,TQuantity:%String,TRemark:%String,TService:%String,TLocation:%String,TGuaranteePeriodNum:%String,TSourceID:%String,TSourceType:%String,TStatCat:%String,TStoreLoc:%String,TTestFlag:%String,TTransAssetDate:%String,TUnit:%String,TUrgencyFlag:%String,TUseLoc:%String,TWorkLoadPerMon:%String,TWorkLoadUnit:%String,TTotalFee:%String,TOpenCheckRequest:%String,TJob:%String,TFileNo:%String,TRow:%String,TStatus:%String,TFinanceType:%String,TMakeUser:%String")
{
}

ClassMethod GetCheckDetailExecute(ByRef qHandle As %Binary, vData As %String = "", QXType As %String = "") As %Status
{
	new repid, index,rowid,Total,TotalFee,PNum,TJob
	Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)

    //d ##Class(web.DHCEQCommon).KillTempGlobal("CheckDetail")
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set Type=##Class(web.DHCEQCommon).GetDataByName(vData,"Type")
	Set LocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"StoreLocDR")
	Set Status=##Class(web.DHCEQCommon).GetDataByName(vData,"Status")			//状态
	Set ModelDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ModelDR")			//机型
	//Set InvoiceNos=##Class(web.DHCEQCommon).GetDataByName(vData,"InvoiceNos")	//合同号
	Set MinPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MinPrice")
	Set MaxPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MaxPrice")
	Set ProviderDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")
	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(vData,"StartDate")
	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndDate")
	Set Name=##Class(web.DHCEQCommon).GetDataByName(vData,"Name")
	Set EquipCatDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipCatDR")
	Set EquipTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDR")
	Set StatCatDR=##Class(web.DHCEQCommon).GetDataByName(vData,"StatCatDR")
	Set RequestNo=##Class(web.DHCEQCommon).GetDataByName(vData,"RequestNo")		//验收单号
	Set FileNo=##Class(web.DHCEQCommon).GetDataByName(vData,"FileNo")		//档案编号
	Set UseLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")  //使用科室
	//Add By QW-2014-10-20 供应商模糊查询
	Set ProviderQuery=##Class(web.DHCEQCommon).GetDataByName(vData,"ProviderQuery")  //供应商模糊
	Set ProviderCHeck=##Class(web.DHCEQCommon).GetDataByName(vData,"ProviderCHeck")  //模糊包含
	Set EquipNo=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipNo")  //Modify By QW0004-2015-01-02 设备编号
	//Set ManuFactoryDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ManuFactoryDR")
	Set InvalidFlag=##Class(web.DHCEQCommon).GetDataByName(vData,"InvalidFlag")
	Set HospitalDR=##Class(web.DHCEQCommon).GetDataByName(vData,"HospitalDR") // Add QW20210629 BUG:QW0131 增加输入参数院区HospitalDR
	Set FinanceTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"FinanceTypeDR")	//czf 2022-09-19
	Set MakeUserDR=##Class(web.DHCEQCommon).GetDataByName(vData,"MakeUserDR")	//czf 2022-10-25
	Set UseLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
	
	;i StartDate'="" s StartDate=$ZDH(StartDate,4)
	;日期格式统一调整   modify by jyp  2017-03-02
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	;i EndDate'="" s EndDate=$ZDH(EndDate,4)
	;日期格式统一调整   modify by jyp  2017-03-02
    s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
    //modified by ZY20221205 bug:3071883
    //第一次进来的时候所有参数都是空,所以给个默认值
    i StartDate="" s StartDate=+$H-30
 	i EndDate="" s EndDate=+$H
	s index=2
	s ISRowID=0
	s rowid=0
	s Total=0
	s TotalFee=0
	s PNum=1
	s TJob=$J
    //modified by ZY 20220928
    s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    d ##class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal("CheckDetail",TJob,curuser)
	
	if RequestNo'=""  d
	.s FindRequestNo=$Order(^DHCEQOpenCheckRequest(0,"RequestNo"," "_RequestNo),-1)
	.For  Set FindRequestNo=$Order(^DHCEQOpenCheckRequest(0,"RequestNo",FindRequestNo))  Quit:((FindRequestNo="")||(FindRequestNo'[RequestNo))  Do
	..Set RequestID=0	
	..For  Set RequestID=$Order(^DHCEQOpenCheckRequest(0,"RequestNo",FindRequestNo,RequestID))  Quit:RequestID=""  Do
	...Set rowid=0
	...For  Set rowid=$Order(^DHCEQOpenCheckList(0, "OpenCheckRequest" ,RequestID,rowid))  Quit:rowid=""  Do
	....d BuildDataGetCheckDetail
	e  d
	.Set rowid=""
	.For  Set rowid=$Order(^DHCEQOpenCheckList(rowid),-1) Quit:(rowid="")||(rowid=0)  d
	..d BuildDataGetCheckDetail
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		i TotalFlag="3" s TotalLoc=0 
		d ResetVariablesGetCheckDetail
		s TQuantity=Total
		s TTotalFee=TotalFee
		s TRow="合计:"
		//modify by cjc 修改底部合计行显示 start
		i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
		//s Data=$lb(TRowID,TABCType,TAppendFeeAmount,TAutoCollectFlag,TBatchNo,TBenefitAnalyFlag,TBuyType,TCheckDate,TCode,TCommonageFlag,TContractList,TContractNo,TCountry,TCurrency,TCurrencyFee,TDepreMethod,TDesignWorkLoadNum,TEquipName,TEquipCat,TEquipTechLevel,TEquipType,TGuaranteeEndDate,TGuaranteeFlag,TGuaranteeStartDate,THold1,THold2,THold3,THold4,THold5,TInstallDate,TInstallLoc,TItem,TLeaveFactoryDate,TLimitYearsNum,TMakeDate,TManageLevel,TManageLoc,TManuFactory,TMeasureFlag,TMedicalFlag,TMemoryCode,TModel,TNetRemainFee,TOpenCheckDate,TOpenCheckRequestDR,TOriginalFee,TPackNum,TPackType,TPurchaseType,TPurposeType,TQuantity,TRemark,TService,TLocation,TGuaranteePeriodNum,TSourceID,TSourceType,TStatCat,TStoreLoc,TTestFlag,TTransAssetDate,TUnit,TUrgencyFlag,TUseLoc,TWorkLoadPerMon,TWorkLoadUnit,TTotalFee,TOpenCheckRequest,TJob,TFileNo,TRow,TStatus)
		//Set ^CacheTemp(repid,TotalLoc)=Data
		//modify by cjc 修改底部合计行显示 end
        //modified by ZY 20220928
        //Set ^TempDHCEQ("CheckDetail",+$H,TJob,PNum)=TRowID_"^"_TABCType_"^"_TAppendFeeAmount_"^"_TAutoCollectFlag_"^"_TBatchNo_"^"_TBenefitAnalyFlag_"^"_TBuyType_"^"_TCheckDate_"^"_TCode_"^"_TCommonageFlag_"^"_TContractList_"^"_TContractNo_"^"_TCountry_"^"_TCurrency_"^"_TCurrencyFee_"^"_TDepreMethod_"^"_TDesignWorkLoadNum_"^"_TEquipName_"^"_TEquipCat_"^"_TEquipTechLevel_"^"_TEquipType_"^"_TGuaranteeEndDate_"^"_TGuaranteeFlag_"^"_TGuaranteeStartDate_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TInstallDate_"^"_TInstallLoc_"^"_TItem_"^"_TLeaveFactoryDate_"^"_TLimitYearsNum_"^"_TMakeDate_"^"_TManageLevel_"^"_TManageLoc_"^"_TManuFactory_"^"_TMeasureFlag_"^"_TMedicalFlag_"^"_TMemoryCode_"^"_TModel_"^"_TNetRemainFee_"^"_TOpenCheckDate_"^"_TOpenCheckRequestDR_"^"_TOriginalFee_"^"_TPackNum_"^"_TPackType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TQuantity_"^"_TRemark_"^"_TService_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TSourceID_"^"_TSourceType_"^"_TStatCat_"^"_TStoreLoc_"^"_TTestFlag_"^"_TTransAssetDate_"^"_TUnit_"^"_TUrgencyFlag_"^"_TUseLoc_"^"_TWorkLoadPerMon_"^"_TWorkLoadUnit_"^"_TTotalFee_"^"_TOpenCheckRequest_"^"_TFileNo
        s tmpValue=TRowID_"^"_TABCType_"^"_TAppendFeeAmount_"^"_TAutoCollectFlag_"^"_TBatchNo_"^"_TBenefitAnalyFlag_"^"_TBuyType_"^"_TCheckDate_"^"_TCode_"^"_TCommonageFlag_"^"_TContractList_"^"_TContractNo_"^"_TCountry_"^"_TCurrency_"^"_TCurrencyFee_"^"_TDepreMethod_"^"_TDesignWorkLoadNum_"^"_TEquipName_"^"_TEquipCat_"^"_TEquipTechLevel_"^"_TEquipType_"^"_TGuaranteeEndDate_"^"_TGuaranteeFlag_"^"_TGuaranteeStartDate_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TInstallDate_"^"_TInstallLoc_"^"_TItem_"^"_TLeaveFactoryDate_"^"_TLimitYearsNum_"^"_TMakeDate_"^"_TManageLevel_"^"_TManageLoc_"^"_TManuFactory_"^"_TMeasureFlag_"^"_TMedicalFlag_"^"_TMemoryCode_"^"_TModel_"^"_TNetRemainFee_"^"_TOpenCheckDate_"^"_TOpenCheckRequestDR_"^"_TOriginalFee_"^"_TPackNum_"^"_TPackType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TQuantity_"^"_TRemark_"^"_TService_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TSourceID_"^"_TSourceType_"^"_TStatCat_"^"_TStoreLoc_"^"_TTestFlag_"^"_TTransAssetDate_"^"_TUnit_"^"_TUrgencyFlag_"^"_TUseLoc_"^"_TWorkLoadPerMon_"^"_TWorkLoadUnit_"^"_TTotalFee_"^"_TOpenCheckRequest_"^"_TFileNo
        d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal("CheckDetail",+$H,TJob,curuser,PNum,tmpValue)
	}
	Quit $$$OK

BuildDataGetCheckDetail		
	d ResetVariablesGetCheckDetail
	s TRowID = rowid	//rowid	
	s TOpenCheckRequestDR=$p($g(^DHCEQOpenCheckList(rowid)),"^",1)
	s OCRHospID=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",38)	//czf 2021-09-01 begin
	q:##class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(OCRHospID,QXType)
	q:(HospitalDR'="")&&(HospitalDR'=OCRHospID)			//czf 2021-09-01 end
	
	s TMakeUserDR=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",39)	//制单人
	q:(MakeUserDR'="")&&(MakeUserDR'=TMakeUserDR)
	s TMakeUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TMakeUserDR)
	s TLeaveFactoryNo=$g(^DHCEQOpenCheckList(rowid,"EX")) //出厂编号 zyq 2023-03-06
	s OCRFlag=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",45) //无效
	q:(InvalidFlag'="")&&(InvalidFlag'=OCRFlag)
	q:(InvalidFlag="")&&("N"'=OCRFlag)
	i TOpenCheckRequestDR'="" s TOpenCheckRequest=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",37)	//验收单号
	i TOpenCheckRequest="" s TOpenCheckRequest=" -- "
	
	q:(ProviderDR'="")&&(ProviderDR'=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",5))
	q:(Status'="")&&(Status'=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",20))
	
	//Add By QW-2014-10-20 供应商模糊查询 根据输入供应商不包括、包括、等于的所属关系查询
	s tmpid=""
	s tmpid=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",5)
	i tmpid'="" s Provider=$p($g(^DHCEQCCode("DHCEQCVendor",tmpid)),"^",2)
	if (ProviderCHeck=1)
		{
		    if (Provider[ProviderQuery)
		    {quit}
	    }
	elseif (ProviderCHeck=3)
	    {
		    if (Provider'=ProviderQuery)
		    {quit}
	    }
	else
	    {
		    if (Provider'[ProviderQuery)
		    {quit}
	    }
	s TStatus=$p($g(^DHCEQOpenCheckRequest(TOpenCheckRequestDR)),"^",20)
	q:((EquipNo'="")&&(TStatus'=2))
	s TStatus=##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	s TFileNo=$g(^DHCEQOpenCheckList(rowid,"FileNo"))	  ///需求号:268358 修改档案号的字段  Modify by mwz 2016-10-26
	q:(FileNo'="")&&(TFileNo'[FileNo)
	s TEquipName =$p($g(^DHCEQOpenCheckList(rowid)),"^",2)
	q:(Name'="")&&(TEquipName'[Name)
	q:##class(web.DHCEQCommon).FundsTypeIsIn(0,rowid) //modify by zx 2020-09-04 调整顺序后生效
	s TEquipTypeDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",3)
	Quit:(TEquipTypeDR'="")&(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))		;Mozy0104	2013-8-24
	q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	i TEquipTypeDR'="" s TEquipType =$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)	//设备类组
	s TFinanceTypeDR=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",9)
	q:(FinanceTypeDR'="")&&(FinanceTypeDR'=TFinanceTypeDR)
	s TFinanceType=##class(web.DHCEQCommon).GetTrakNameByID("financetype",TFinanceTypeDR)
	
	s TABCType =$p($g(^DHCEQOpenCheckList(rowid)),"^",4)
	s TModelDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",5)
	q:(ModelDR'="")&&(ModelDR'=TModelDR)
	i TModelDR'="" s TModel =$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)	//机型
	
	s TEquipCatDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",6)
	q:(EquipCatDR'="")&&(EquipCatDR'=TEquipCatDR)
	i TEquipCatDR'="" s TEquipCat =$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)	//设备分类
	
	s TUnitDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",7)		//设备单位
	i TUnitDR'="" s TUnit =##class(web.DHCEQCommon).GetTrakNameByID("uom",(TUnitDR))	;Modified By jdl 20150906 v4.1.0 规范单位取值
	
	s TCode =$p($g(^DHCEQOpenCheckList(rowid)),"^",8)
	
	s TItemDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",9)
	i TItemDR'="" s TItem =$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)	//设备项
	
	s TMakeDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",10),"date")
	
	s TCountryDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",11)
	i TCountryDR'="" s TCountry=##class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
	
	s TManageLevelDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",12)
	i TManageLevelDR'="" s TManageLevel =$p($g(^DHCEQCCode("DHCEQCManageLevel",TManageLevelDR)),"^",2)	//管理级别
	
	s TBuyTypeDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",13)
	i TBuyTypeDR'="" s TBuyType =$p($g(^DHCEQCCode("DHCEQCBuyType",TBuyTypeDR)),"^",2)		//采购方式
	
	s TEquipTechLevelDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",14)
	i TEquipTechLevelDR'="" s TEquipTechLevel =$p($g(^DHCEQCCode("DHCEQCTechLevel",TEquipTechLevelDR)),"^",2)	//设备技术水平
	
	s TManuFactoryDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",15)
	//q:(ManuFactoryDR'="")&&(ManuFactoryDR'=TManuFactoryDR)
	i TManuFactoryDR'="" s TManuFactory =##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)	//设备生产厂商	//modified by CZF0093 2020-03-17
	
	s TQuantity =$p($g(^DHCEQOpenCheckList(rowid)),"^",16)
	s TOriginalFee =$p($g(^DHCEQOpenCheckList(rowid)),"^",17)
	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
	
	q:(MinPrice="")&&(MaxPrice'="")&&(TOriginalFee>MaxPrice)
	q:(MinPrice'="")&&(MaxPrice="")&&(TOriginalFee<MinPrice)
	q:(MinPrice'="")&&(MaxPrice'="")&&((TOriginalFee<MinPrice)||(TOriginalFee>MaxPrice))
	
	s TNetRemainFee =$p($g(^DHCEQOpenCheckList(rowid)),"^",18)
	i TNetRemainFee'="" s TNetRemainFee=##Class(web.DHCEQCommon).FormatNumber(TNetRemainFee,"")
	s TLimitYearsNum =$p($g(^DHCEQOpenCheckList(rowid)),"^",19)
	
	s TDepreMethodDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",20)
	i TDepreMethodDR'="" s TDepreMethod =$p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)	//折旧方法
	
	s TCurrencyDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",21)
	i TCurrencyDR'="" s TCurrency =$p($g(^CT("CUR",TCurrencyDR)),"^",2)		//货币
	
	s TMemoryCode =$p($g(^DHCEQOpenCheckList(rowid)),"^",22)
	
	s TPurchaseTypeDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",23)
	i TPurchaseTypeDR'="" s TPurchaseType =$p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)	//申购类别
	
	s TPurposeTypeDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",24)
	i TPurposeTypeDR'="" s TPurposeType =$p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	
	s TServiceDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",25)
	i TServiceDR'="" s TService =$p($g(^DHCEQCCode("DHCEQCService",TServiceDR)),"^",1)
	
	//20150827  Mozy0163	存放地点
	Set TLocationDR = $Piece($Get(^DHCEQOpenCheckList(rowid)),"^",26)
	If TLocationDR'="" Set TLocation = $Piece($Get(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)
	Set TGuaranteePeriodNum = $Piece($Get(^DHCEQOpenCheckList(rowid)),"^",27)
	
	s TStatCatDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",28)
	q:(StatCatDR'="")&&(StatCatDR'=TStatCatDR)
	i TStatCatDR'="" s TStatCat =$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	
	s TDesignWorkLoadNum =$p($g(^DHCEQOpenCheckList(rowid)),"^",29)
	
	s TWorkLoadUnitDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",30)
	i TWorkLoadUnitDR'="" s TWorkLoadUnit =##class(web.DHCEQCommon).GetTrakNameByID("uom",(TWorkLoadUnitDR))	;Modified By jdl 20150906 v4.1.0 规范单位取值
	
	s TStoreLocDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",31)
	q:((LocDR'="")&&(LocDR'=TStoreLocDR))
	i TStoreLocDR'="" s TStoreLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	
	s TManageLocDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",32)
	i TManageLocDR'="" s TManageLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	
	s TUseLocDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",33)
	q:(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
	i TUseLocDR'="" s TUseLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TUseLocDR) ;Add QW20210629 BUG:QW0131
	q:(HospitalDR'="")&&(HospitalDR'=THospitalDR) ;Add QW20210629 BUG:QW0131
	s TRemark =$p($g(^DHCEQOpenCheckList(rowid)),"^",34)
	s TCurrencyFee =$p($g(^DHCEQOpenCheckList(rowid)),"^",35)
	i TCurrencyFee'="" s TCurrencyFee=##Class(web.DHCEQCommon).FormatNumber(TCurrencyFee,"")
	s TContractNo =$p($g(^DHCEQOpenCheckList(rowid)),"^",36)
	// MZY0125	2615815,2615876,2615902		2022-06-08
	s TContractList =$p($g(^DHCEQOpenCheckList(rowid)),"^",37)	//合同
	i TContractList'="" d
	.s TContractList=$p($g(^DHCEQContractList(TContractList)),"^",1)
	.s TContractList=$p($g(^DHCEQContract(TContractList)),"^",1)
	s TMedicalFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",38)
	s TMeasureFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",39)
	// MZY0125	2615815,2615876,2615902		2022-06-08
	i TMeasureFlag="" d
	.s Lrowid=0
	.f  s Lrowid=$o(^DHCEQEquipAttributeList(0,"SourceID",2,rowid,Lrowid)) quit:(Lrowid="")||(TMeasureFlag'="")  d
	..s EADR=$p($g(^DHCEQEquipAttributeList(Lrowid)),"^",1)
	..i ($p($g(^DHCEQCCode("DHCEQCEquipAttribute",EADR)),"^",5)="N")&&($p($g(^DHCEQCCode("DHCEQCEquipAttribute",EADR)),"^",1)=11) s TMeasureFlag="Y"
	s TTestFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",40)
	s TUrgencyFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",41)
	s TGuaranteeFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",42)
	
	s TGuaranteeStartDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",43),"date")	
	s TGuaranteeEndDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",44),"date")
	s TOpenCheckDate =$p($g(^DHCEQOpenCheckList(rowid)),"^",46)		//czf 1929999 2021-06-17
	q:(TOpenCheckDate>EndDate)||(TOpenCheckDate<StartDate)
	s TOpenCheckDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",45),"date")
	s TCheckDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",46),"date")
	
	s TInstallLocDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",47)
	i TInstallLocDR'="" s TInstallLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept" ,TInstallLocDR )
	
	s TInstallDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",48),"date")
	s TLeaveFactoryDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",49),"date")
	
	s TPackTypeDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",50)
	i TPackTypeDR'="" s TPackType =$p($g(^DHCEQCCode("DHCEQCPackType",TPackTypeDR)),"^",2)
	
	s TPackNum =$p($g(^DHCEQOpenCheckList(rowid)),"^",51)
	s TTransAssetDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",52),"date")
	s TAppendFeeAmount =$p($g(^DHCEQOpenCheckList(rowid)),"^",53)
	i TAppendFeeAmount'="" s TAppendFeeAmount=##Class(web.DHCEQCommon).FormatNumber(TAppendFeeAmount,"")
	s TBatchNo =$p($g(^DHCEQOpenCheckList(rowid)),"^",54)
	
	s THold1 =$p($g(^DHCEQOpenCheckList(rowid)),"^",55)	//发票号	
	s THold2 =$p($g(^DHCEQOpenCheckList(rowid)),"^",56)
	s THold3 =$p($g(^DHCEQOpenCheckList(rowid)),"^",57)
	s THold4 =$p($g(^DHCEQOpenCheckList(rowid)),"^",58)
	s THold5 =$p($g(^DHCEQOpenCheckList(rowid)),"^",59)
	
	s TBenefitAnalyFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",60)
	s TCommonageFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",61)
	s TAutoCollectFlag =$p($g(^DHCEQOpenCheckList(rowid)),"^",62)
	s SourceType =$p($g(^DHCEQOpenCheckList(rowid)),"^",63)
	i SourceType'="" s TSourceType=..GetSourceDesc(SourceType)
	
	s SourceID =$p($g(^DHCEQOpenCheckList(rowid)),"^",64)
	i SourceID'="" s TSourceID =..TranslateSourceID(SourceType,SourceID)
	
	s TWorkLoadPerMon =$p($g(^DHCEQOpenCheckList(rowid)),"^",65)
	
	//Mozy	2016-12-8
	i EquipNo'=""
	{
		s TEquipDR=0
		s HasFlag=0		;存在标志		0 不存在
		For  s TEquipDR=$Order(^DHCEQEquip(0,"OpenCheckList",rowid,TEquipDR)) Quit:(TEquipDR="")||(HasFlag'=0)  Do
		.if ($p($g(^DHCEQEquip(TEquipDR)),"^",71)[EquipNo) s HasFlag=1	;存在
		;不存在DHCEQEquip则退出
		i (HasFlag=0) q
	}
	s TTotalFee=TQuantity*TOriginalFee
	i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
	s Total=Total+TQuantity			//总数
	s TotalFee=TotalFee+TTotalFee	//总金额
	d OutputRowGetCheckDetail
	
	quit
OutputRowGetCheckDetail
	s TRow=PNum
	s Data=$lb(TRowID,TABCType,TAppendFeeAmount,TAutoCollectFlag,TBatchNo,TBenefitAnalyFlag,TBuyType,TCheckDate,TCode,TCommonageFlag,TContractList,TContractNo,TCountry,TCurrency,TCurrencyFee,TDepreMethod,TDesignWorkLoadNum,TEquipName,TEquipCat,TEquipTechLevel,TEquipType,TGuaranteeEndDate,TGuaranteeFlag,TGuaranteeStartDate,THold1,THold2,THold3,THold4,THold5,TInstallDate,TInstallLoc,TItem,TLeaveFactoryDate,TLimitYearsNum,TMakeDate,TManageLevel,TManageLoc,TManuFactory,TMeasureFlag,TMedicalFlag,TMemoryCode,TModel,TNetRemainFee,TOpenCheckDate,TOpenCheckRequestDR,TOriginalFee,TPackNum,TPackType,TPurchaseType,TPurposeType,TQuantity,TRemark,TService,TLocation,TGuaranteePeriodNum,TSourceID,TSourceType,TStatCat,TStoreLoc,TTestFlag,TTransAssetDate,TUnit,TUrgencyFlag,TUseLoc,TWorkLoadPerMon,TWorkLoadUnit,TTotalFee,TOpenCheckRequest,TJob,TFileNo,TRow,TStatus,TFinanceType,TMakeUser)
	Set ^CacheTemp(repid,index)=Data
    //modified by ZY 20220928
    //Set ^TempDHCEQ("CheckDetail",+$H,TJob,PNum)=TRowID_"^"_TABCType_"^"_TAppendFeeAmount_"^"_TAutoCollectFlag_"^"_TBatchNo_"^"_TBenefitAnalyFlag_"^"_TBuyType_"^"_TCheckDate_"^"_TCode_"^"_TCommonageFlag_"^"_TContractList_"^"_TContractNo_"^"_TCountry_"^"_TCurrency_"^"_TCurrencyFee_"^"_TDepreMethod_"^"_TDesignWorkLoadNum_"^"_TEquipName_"^"_TEquipCat_"^"_TEquipTechLevel_"^"_TEquipType_"^"_TGuaranteeEndDate_"^"_TGuaranteeFlag_"^"_TGuaranteeStartDate_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TInstallDate_"^"_TInstallLoc_"^"_TItem_"^"_TLeaveFactoryDate_"^"_TLimitYearsNum_"^"_TMakeDate_"^"_TManageLevel_"^"_TManageLoc_"^"_TManuFactory_"^"_TMeasureFlag_"^"_TMedicalFlag_"^"_TMemoryCode_"^"_TModel_"^"_TNetRemainFee_"^"_TOpenCheckDate_"^"_TOpenCheckRequestDR_"^"_TOriginalFee_"^"_TPackNum_"^"_TPackType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TQuantity_"^"_TRemark_"^"_TService_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TSourceID_"^"_TSourceType_"^"_TStatCat_"^"_TStoreLoc_"^"_TTestFlag_"^"_TTransAssetDate_"^"_TUnit_"^"_TUrgencyFlag_"^"_TUseLoc_"^"_TWorkLoadPerMon_"^"_TWorkLoadUnit_"^"_TTotalFee_"^"_TOpenCheckRequest_"^"_TFileNo_"^"_TFinanceType    
    s tmpValue=TRowID_"^"_TABCType_"^"_TAppendFeeAmount_"^"_TAutoCollectFlag_"^"_TBatchNo_"^"_TBenefitAnalyFlag_"^"_TBuyType_"^"_TCheckDate_"^"_TCode_"^"_TCommonageFlag_"^"_TContractList_"^"_TContractNo_"^"_TCountry_"^"_TCurrency_"^"_TCurrencyFee_"^"_TDepreMethod_"^"_TDesignWorkLoadNum_"^"_TEquipName_"^"_TEquipCat_"^"_TEquipTechLevel_"^"_TEquipType_"^"_TGuaranteeEndDate_"^"_TGuaranteeFlag_"^"_TGuaranteeStartDate_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TInstallDate_"^"_TInstallLoc_"^"_TItem_"^"_TLeaveFactoryDate_"^"_TLimitYearsNum_"^"_TMakeDate_"^"_TManageLevel_"^"_TManageLoc_"^"_TManuFactory_"^"_TMeasureFlag_"^"_TMedicalFlag_"^"_TMemoryCode_"^"_TModel_"^"_TNetRemainFee_"^"_TOpenCheckDate_"^"_TOpenCheckRequestDR_"^"_TOriginalFee_"^"_TPackNum_"^"_TPackType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TQuantity_"^"_TRemark_"^"_TService_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TSourceID_"^"_TSourceType_"^"_TStatCat_"^"_TStoreLoc_"^"_TTestFlag_"^"_TTransAssetDate_"^"_TUnit_"^"_TUrgencyFlag_"^"_TUseLoc_"^"_TWorkLoadPerMon_"^"_TWorkLoadUnit_"^"_TTotalFee_"^"_TOpenCheckRequest_"^"_TFileNo_"^"_TFinanceType_"^"_TMakeUser_"^"_TLeaveFactoryNo   //modify by zyq 2023-03-06
    d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal("CheckDetail",+$H,TJob,curuser,PNum,tmpValue)
	Set PNum=PNum+1
	Set index=index+1
	quit
ResetVariablesGetCheckDetail
	s (TRowID,TABCType,TAppendFeeAmount,TAutoCollectFlag,TBatchNo,TBenefitAnalyFlag,TBuyType,TCheckDate,TCode,TCommonageFlag,TContractList,TContractNo,TCountry,TCurrency,TCurrencyFee,TDepreMethod,TDesignWorkLoadNum,TEquipName,TEquipCat,TEquipTechLevel,TEquipType,TGuaranteeEndDate,TGuaranteeFlag,TGuaranteeStartDate,THold1,THold2,THold3,THold4,THold5,TInstallDate,TInstallLoc,TItem,TLeaveFactoryDate,TLimitYearsNum,TMakeDate,TManageLevel,TManageLoc,TManuFactory,TMeasureFlag,TMedicalFlag,TMemoryCode,TModel,TNetRemainFee,TOpenCheckDate,TOpenCheckRequestDR,TOriginalFee,TPackNum,TPackType,TPurchaseType,TPurposeType,TQuantity,TRemark,TService,TLocation,TGuaranteePeriodNum,TSourceID,TSourceType,TStatCat,TStoreLoc,TTestFlag,TTransAssetDate,TUnit,TUrgencyFlag,TUseLoc,TWorkLoadPerMon,TWorkLoadUnit,TTotalFee,TOpenCheckRequest,TFileNo,Provider,TRow,TStatus,TFinanceTypeDR,TFinanceType,TMakeUserDR,TMakeUser,TLeaveFactoryNo)="" //QW-2014-10-20 新增初始化 Provider
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

/// Add By HZY 2011-08-02   HZY0004
ClassMethod GetSourceDesc(Type)
{
	q $CASE(Type,"0":"无","1":"合同","2":"采购单","3":"计划单","4":"申请单")
}

/// Add By HZY 2011-08-02   HZY0004
ClassMethod TranslateSourceID(SourceType, SourceID)
{
	new Source
	s Source=""
	if (SourceType=1)	//合同
	{
		s Source=$p($g(^DHCEQContract(SourceID)),"^",2)
	}
	elseif (SourceType=3)	//计划单
	{
		s Source=$p($g(^DHCEQBuyPlan(SourceID)),"^",25)
	}
	elseif (SourceType=4)	//申请单
	{
		s Source=$p($g(^DHCEQBuyRequest(SourceID)),"^",35)
	}
	
	q Source
}

/// add by zy 2011-10-25 zy0083
/// desc:按照新财务制度检测设备是否属于固定资产,根据设备的金额来判断是否属于当前类组规定的金额范围.
/// 入参:type：两种值OpenCheck,InStock,区分入库还是验收
/// 		id,单据id号
/// w ##Class(web.DHCEQOpenCheckRequest).CheckFeeArea("InStock",7613)
ClassMethod CheckFeeArea(type, id)
{
	new flag,EquipType,MinPrice,MaxPrice,rowid,ItemDR,MIEquipType,Name,Quantity,OriginalFee,Fee
	s (EquipType,MinPrice,MaxPrice)=""
	s (flag,rowid)=0
	if type="OpenCheck"
	{
		s EquipType=$p($g(^DHCEQOpenCheckRequest(id)),"^",2)
		s MinPrice=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipType)),"^",7)
		s MaxPrice=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipType)),"^",8)
		for  s rowid=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",id,rowid)) q:(rowid="")||(flag'=0)  d
		.s (Name,ItemDR,MIEquipType,Quantity,OriginalFee,Fee)=""
		.s Name=$p($g(^DHCEQOpenCheckList(rowid)),"^",2)
		.s ItemDR=$p($g(^DHCEQOpenCheckList(rowid)),"^",9)
		.s MIEquipType=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
		.s Quantity=$p($g(^DHCEQOpenCheckList(rowid)),"^",16)
		.s OriginalFee=$p($g(^DHCEQOpenCheckList(rowid)),"^",17)
		.d ComFee
	}
	elseif type="InStock"
	{
		s EquipType=$p($g(^DHCEQInStock(id)),"^",20)
		s MinPrice=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipType)),"^",7)
		s MaxPrice=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipType)),"^",8)
		for  s rowid=$o(^DHCEQInStockList(0,"InStock",id,rowid)) q:(rowid="")||(flag'=0)  d
		.s (Name,ItemDR,MIEquipType,Quantity,OriginalFee,Fee)=""
		.s Name=$p($g(^DHCEQInStockList(rowid)),"^",5)
		.s ItemDR=$p($g(^DHCEQInStockList(rowid)),"^",16)
		.s MIEquipType=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
		.s Quantity=$p($g(^DHCEQInStockList(rowid)),"^",8)
		.s OriginalFee=$p($g(^DHCEQInStockList(rowid)),"^",7)
		.d ComFee
	}
	if flag'=0 q flag_"^"_Name
	q flag
ComFee	
	i (MIEquipType'=EquipType) s flag=-1012 ;设备项类组和与单据类组不一致
	q:flag'=0
	s Fee=OriginalFee*Quantity
	i Fee<MinPrice  d
	.s flag=-1013  ;设备价值小于当前类组的范围
	e  i (Fee>=MaxPrice)&&(MaxPrice'="")  d
	.s flag=-1014  ;设备价值大于当前类组的范围
}

/// Mozy0145	20141017
/// w ##Class(web.DHCEQOpenCheckRequest).SaveDataForInfo("11^^1^4^2^22/10/2014^5^6^3^24/10/2014^N^^^^^",1,69091,2)
ClassMethod SaveDataForInfo(Info As %String = "", SourceType As %String = "", SourceID As %String = "", Operation As %String = "")
{
	New AssetType
	Set AssetType=+$Piece(Info,"^",1)
	;s ^DHCEQMozy("SaveDataForInfo",SourceType,SourceID)=Info
	If AssetType<1 Quit 0
	If (AssetType=1)
	{
		Set SQLCODE = ##Class(web.DHCEQLand).Save(Info,SourceType,SourceID,Operation)	//GR0019 2014-12-15 土地资产
	}
	elseif (AssetType=2)
	{
		Set SQLCODE = ##Class(web.DHCEQBuilding).Save(Info,SourceType,SourceID,Operation) //modified by GR0014 2014-11-18
	}
	elseif (AssetType=3)
	{
		Set SQLCODE = ##Class(web.DHCEQStructures).Save(Info,SourceType,SourceID,Operation) //modified by GR0021 2014-12-29
	}
	elseif (AssetType=4)
	{
		Set SQLCODE = ##Class(web.DHCEQVehicle).SaveData("","",Info,SourceType,SourceID,Operation)
	}
	elseif (AssetType=5)
	{
		
	}
	elseif (AssetType=6)
	{
		
	}
	elseif (AssetType=7)
	{
		
	}
	elseif (AssetType=8)
	{
		Set SQLCODE = ##Class(web.DHCEQExhibits).SaveData("","",Info,SourceType,SourceID,Operation)
	}
	elseif (AssetType=9)
	{
		Set SQLCODE = ##Class(web.DHCEQSpecialPlant).SaveData("","",Info,SourceType,SourceID,Operation)
	}
	elseif (AssetType=10)
	{
		
	}
	elseif (AssetType=11)
	{
		; 无形资产
		Set SQLCODE = ##Class(web.DHCEQIntangibleAssets).SaveData("","",Info,SourceType,SourceID,Operation)
	}
	If SQLCODE Quit SQLCODE
	Quit 0
}

/// Mozy0145	20141017
/// w ##Class(web.DHCEQOpenCheckRequest).GetInfoData(0,380)
/// 返回值：result：专属信息串
/// 		AssetType：资产类型    //modify BY:GBX GBX0032 
ClassMethod GetInfoData(SourceType As %String = "", SourceID As %String = "")
{
	If (SourceType="")||(SourceID="") Quit ""
	If (SourceType="0")
	{
		//s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",SourceID,0))		//Add By DJ 2015-09-24 DJ0167
		Set StatDR=$Piece($Get(^DHCEQOpenCheckList(SourceID)),"^",28)
	}
	Else
	{
		Set StatDR=$Piece($Get(^DHCEQEquip(SourceID)),"^",75)
	}
	//Set AssetType=$Piece($Get(^DHCEQCCode("DHCEQCStatCat",StatDR)),"^",10)
	///add 20191012 by zy 增加控制
	Set AssetType=""
	i StatDR'="" Set AssetType=$Piece($Get(^DHCEQCCode("DHCEQCStatCat",StatDR)),"^",5) //GR0015 2014-11-25兼容卫计委 EQType作为资产类型标识
	Set result=""
	If (AssetType=1)
	{
		Set result=##Class(web.DHCEQLand).GetLandBySourceID(SourceType,SourceID)
	}
	elseif (AssetType=2)
	{
		; 房屋资产  GR0014 2014-11-18
		Set result=##Class(web.DHCEQBuilding).GetDHCEQBuildingByID(SourceType,SourceID)
	}
	elseif (AssetType=3)
	{
		;构筑物		GR0021 2014-12-29
		Set result=##Class(web.DHCEQStructures).GetDHCEQStructuresByID(SourceType,SourceID)
	}
	elseif (AssetType=4)
	{
		Set result=##Class(web.DHCEQVehicle).GetDHCEQVehicleByID("","",SourceType,SourceID)
	}
	elseif (AssetType=5)
	{
		
	}
	elseif (AssetType=6)
	{
		
	}
	elseif (AssetType=7)
	{
		
	}
	elseif (AssetType=8)
	{
		Set result=##Class(web.DHCEQExhibits).GetDHCEQExhibitsByID("","",SourceType,SourceID)
	}
	elseif (AssetType=9)
	{
		Set result=##Class(web.DHCEQSpecialPlant).GetDHCEQSpecialPlantByID("","",SourceType,SourceID)
	}
	elseif (AssetType=10)
	{
		
	}
	elseif (AssetType=11)
	{
		; 无形资产
		Set result=##Class(web.DHCEQIntangibleAssets).GetIntangibleAssetsByID("","",SourceType,SourceID)
	}
	
	Quit AssetType_"^"_result
}

/// Add 2014-1-20 HZY 
/// 通过验收单的RowID获取设备编号
/// 77  EQ_Hold2->OCL_RowID
/// w ##CLass(web.DHCEQOpenCheckRequest).GetEquipNosByOCRRowID(14)
ClassMethod GetEquipNosByOCRRowID(OCRRowID)
{
	i (OCRRowID="")||(OCRRowID<1) q ""
	s EquipNos=""
	s OCLRowID=0
	f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,OCLRowID)) q:(OCLRowID="")  d
	.s equiprowid=0
	.f  s equiprowid=$o(^DHCEQEquip(0,"OpenCheckList",OCLRowID,equiprowid)) q:(equiprowid="")  d
	..i (EquipNos="") d 
	...s EquipNos=$p($g(^DHCEQEquip(equiprowid)),"^",71)
	..e  d
	...s EquipNos=EquipNos_","_$p($g(^DHCEQEquip(equiprowid)),"^",71)
	
	q EquipNos
}

/// add by QW-2014-10-20
ClassMethod ProviderCheckList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	;w "<option value=0></option>"
	w "<option value=1>不包括</option>"
	w "<option value=2>包括</option>"
	w "<option value=3>等于</option>" //2010-10-26 DJ
	w "</select>",!
}

/// modified by ZY 20220927  修改global
/// 检测档案号是否有重复  20150819  Mozy0159
/// 入参： LeaveFactoryNos:序列号的字符串，多个之间以","分割
///             SourceType: 1验收单 2设备
///             SourceID：对应的ID
/// 返回：
/// 		0：无重复
/// 		1：LeaveFactoryNos:序列号的字符串中有重复的
/// 		2：与设备表中的设备有重复
/// 		3：与其他未审核验收单中有重复
/// 
/// 返回值: 0表示不重复  其他表示重复
/// w ##Class(web.DHCEQOpenCheckRequest).CheckFileNo(2,"3451",3423)
ClassMethod CheckFileNo(SourceType As %String = "", SourceID As %String = "", FileNoStr As %String = "")
{
	If FileNoStr="" Quit 0
	Set Flag=0
	
	;检测档案号串中本身是否有重复
    Kill ^TempDHCEQ("web.DHCEQCommon","FileNo",$j)
	Set Num=$l(FileNoStr,",")
	for i=1:1:Num
	{
		Quit:Flag'=0
		Set FileNo=$Piece(FileNoStr,",",i)
		If FileNo="" continue
        if $d(^TempDHCEQ("web.DHCEQCommon","FileNo",$j,"No",FileNo)) Set Flag=1
        Quit:Flag'=0
        Set ^TempDHCEQ("web.DHCEQCommon","FileNo",$j,"No",FileNo)=""
		
		;检测序列号是否与其它未审核验收单中的档案号重复
		s CheckType=""		
		f  s CheckType=$o(^DHCEQOpenCheckRequest(0,"Status",CheckType))  quit:(CheckType="")||(Flag'=0)  d 
		.s EquipType=0
		.f  s EquipType=$o(^DHCEQOpenCheckRequest(0,"Status",CheckType,EquipType))  quit:(EquipType="")||(Flag'=0)  d
		..s OCRStatus=""
		..f  s OCRStatus=$o(^DHCEQOpenCheckRequest(0,"Status",CheckType,EquipType,OCRStatus))  quit:(OCRStatus="")||(Flag'=0)  d
		...q:OCRStatus>1
		...s OCRRowID=0
		...f  s OCRRowID=$o(^DHCEQOpenCheckRequest(0,"Status",CheckType,EquipType,OCRStatus,OCRRowID))  quit:(OCRRowID="")||(Flag'=0)  d
		....q:(SourceType=1)&&(SourceID=OCRRowID)
		....s rowid=0
		....f  s rowid=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,rowid))  quit:(rowid="")||(Flag'=0)  d
		.....if (","_$g(^DHCEQOpenCheckList(rowid,"FileNo"))_",")[(","_FileNo_",")  d
		......s Flag=3
	}	
    k ^TempDHCEQ("DHCEQOpenCheckRequest","FileNo",$j)
	i Flag'=0 q Flag_"^"_FileNo
	
	Set FileNoStr=","_FileNoStr_","
	Set rowid=0
	For  Set rowid=$Order(^DHCEQEquip(rowid)) Quit:(rowid="")||(Flag'=0)  Do 
	.Quit:$Piece($Get(^DHCEQEquip(rowid)),"^",59)="Y"	;InvalidFlag
	.Quit:$Piece($Get(^DHCEQEquip(rowid)),"^",60)=3		;StockStatus
	.Quit:(SourceType=2)&&(SourceID=rowid)
	.Set FileNo=$Piece($Get(^DHCEQEquip(rowid)),"^",85)
	.Quit:FileNo=""
	.Quit:FileNoStr'[(","_FileNo_",")
	.Set Flag=2
	If Flag=0 Quit 0
	Quit Flag_"^"_FileNo
}

/// 20170327 Mozy0184
/// 获取自动入库出库参数
/// 返回：自动入库^自动出库
/// w ##Class(web.DHCEQOpenCheckRequest).GetAutoInOut(5)
ClassMethod GetAutoInOut(val As %String = "")
{
	;判断单据当前是否为最后一步
	n (val)
	s RowID=$p(val,"^",1)
	s Role=$p(val,"^",2)
	s Step=+$p(val,"^",3)
	
	if (##Class(web.DHCEQPayPlan).CheckPayPlan(2,RowID)="-2") q "0^0"
	s Status=$p($g(^DHCEQOpenCheckRequest(RowID)),"^",20) //状态
	if Status="2" q "0^0"   //该记录状态不符合,不能执行操作!
	s EquipType=$P(^DHCEQOpenCheckRequest(RowID),"^",2)
	s PurchaseType=$P(^DHCEQOpenCheckRequest(RowID),"^",3)
	s oclrowid=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",RowID,0))
	s SpecialType=""
	s EquipCat=$P(^DHCEQOpenCheckList(oclrowid),"^",6)
	i EquipCat'="" s SpecialType=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCat),"^",5)
	s MaxPrice=$P(^DHCEQOpenCheckList(oclrowid),"^",17)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("7")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,"")
	i ApproveSet="" q "0^0"
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, Step, Role)
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	
	i AutoAuditFlag="Y"
	{
		i (NextStep="")||(LastFlag="Y")
		{
	 		Quit +##class(web.DHCEQCommon).GetSysInfo("201009")_"^"_+##class(web.DHCEQCommon).GetSysInfo("301010")
		}
	}
	Quit "0^0"
}

/// modified by ZY0252 20210301
/// 增加跟进验收多个科室自动出库的功能，同时，之前的事务处理有bug
/// 入参：	SourceType: 1验收明细 2入库单	SourceID：对应的ID
/// 注:不处理直接办理入库并设置自动出库的情况
/// 自动入库出库设置AutoFlag	0:无操作;1:自动入库;2:自动出库;3:依次自动入库和出库
/// 返回值:0正常	其他:SQL错误编码
/// w ##Class(web.DHCEQOpenCheckRequest).AutoInOutExecute(1,56,571,1)
/// w ##Class(web.DHCEQOpenCheckRequest).AutoInOutExecute(2,47,571,1)
ClassMethod AutoInOutExecute(SourceType As %String = "", SourceID As %String = "", CTLOCID As %String = "", USERID As %String = "", InFlag As %Library.String = "0", OutFlag As %Library.String = "0")
{
	If SourceID="" Quit 0
	New val,AppSet,afstep,afrole,afid,SQLCODE,LocListFlag
	Set SQLCODE=0
	If CTLOCID="" Set CTLOCID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	If USERID="" Set USERID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	If SourceType=1
	{
		if InFlag=0	Quit 0
		;&SQL(update sqluser.DHC_EQOpenCheckList Set OCL_Remark='验收单自动操作(1-自动入库,2-自动出库,3-依次自动入库和出库):'||:AutoFlag where OCL_RowID=:SourceID)
		;生成入库业务信息
		Set val=$Piece($Get(^DHCEQOpenCheckList(SourceID)),"^",1)
		Set val=val_"^"_SourceID
		Set val=val_"^"						;入库单ID
		Set val=val_"^"_CTLOCID				;库房
		Set val=val_"^"_USERID				;操作员
		Set val=val_"^"_$Piece($Get(^DHCEQOpenCheckRequest($Piece($Get(^DHCEQOpenCheckList(SourceID)),"^",1))),"^",37)_"验收完成自动生成的入库单"	;Remark
		Set ISRowID = ##Class(web.DHCEQInStockNew).SaveDataFromOpenCheck(val)
		If ISRowID<0
		{
			Quit ISRowID
		}
		
		;提交自动生成的入库单
		Set val=ISRowID				;入库单ID
		Set val=val_"^"
		Set val=val_"^"_USERID		;操作员
		Set ISRowID = ##Class(web.DHCEQInStockNew).SubmitData(val,OutFlag)
		
		If ISRowID<0
		{
			Quit ISRowID
		}
		;审核完成自动生成的入库单	AuditData(val, CurRole, RoleStep, editFieldsInfo)
		Set SQLCODE = 0
		Set AppSet=##class(web.DHCEQApproveList).GetApproveSet("13", ISRowID)	
		If AppSet=""
		{
			Quit -4007
		}
		Set afstep=0
		For  Set afstep=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSet,afstep)) Quit:(afstep="")||(SQLCODE<0)  Do
		.Set afid=0
		.For  Set afid=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSet,afstep,afid)) Quit:(afid="")||(SQLCODE<0)  Do
		..Set afrole=$p(^DHCEQCCode("DHCEQCApproveFlow",afid),"^",2)
		..Set SQLCODE = ##Class(web.DHCEQInStockNew).AuditData(val,afrole,afstep,"",OutFlag)
		
		If SQLCODE<0
		{
			Quit SQLCODE
		}
	}
	If SourceType=2
	{
		If OutFlag=0 Quit 0
		s LocListFlag=+##class(web.DHCEQCommon).GetSysInfo("201015")
		;生成出库业务信息
		Set InStockData=$Get(^DHCEQInStock(SourceID))
		Kill PLISTSM,PLISTSML
		;主表
		Set PLISTSM(3) = $Piece(InStockData,"^",2)	;FromLocDR
		if LocListFlag=0 Set PLISTSM(4) = $Piece(InStockData,"^",18)	;ToLocDR
		Set PLISTSM(5) = USERID			;MakerDR
		Set PLISTSM(6) = +$H			;MakeDate
		Set PLISTSM(13) = "0"			;MoveType
		Set PLISTSM(14) = "0"			;Status
		Set PLISTSM(15) = $Piece(InStockData,"^",14)	;_"入库完成自动生成的转移单"	;Remark
		Set PLISTSM(17) = $Piece(InStockData,"^",20)	;EquipTypeDR
		Set PLISTSM(18) = $Piece(InStockData,"^",21)	;StatCatDR
		Set PLISTSM(28) = "N"
		Set MoveTypeCode=##Class(web.DHCEQStoreMoveNew).GetMoveTypeCode(0)
		if LocListFlag=0
		{
			Set PLISTSM(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQStoreMove",+$H,PLISTSM(3),$Piece(InStockData,"^",20),"","",MoveTypeCode)
			&SQL(insert into sqluser.DHC_EQStoreMove values :PLISTSM())
			If SQLCODE
			{
				Quit SQLCODE
			}
			Set SMRowID=$Get(%ROWID)
			Set PLISTSML(2)=SMRowID
		}
		
		;明细表
		Set tmpISLRowID=0
		For  Set tmpISLRowID=$Order(^DHCEQInStockList(0,"InStock",SourceID,tmpISLRowID)) Quit:(tmpISLRowID="")||(SQLCODE)  Do
		.;Set PLISTSML(3)=$p(valList,"^",3)  ;SML_EquipDR
		.Set PLISTSML(4)="Y"				;SML_BatchFlag
		.Set PLISTSML(5)=tmpISLRowID  		;SML_InStockListDR
		.Set PLISTSML(6)=$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",5)  	;SML_Equip
		.Set PLISTSML(7)=$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",6)  	;SML_TManuFactoryDR
		.Set PLISTSML(8)=$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",7)  	;SML_TOriginalFee
		.if LocListFlag=0 Set PLISTSML(9)=$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",8)  	;SML_TQuantityNum
		.Set PLISTSML(10)=$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",9)  	;SML_TModelDR
		.Set PLISTSML(11)=$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",10)  	;SML_TUnitDR
		.Set PLISTSML(12)=$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",12)  	;SML_TRemark
		.s ISLSourceType=$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",18)
		.;s TSourceType=$CASE(TSourceType,"0":"设备","1":"设备项","2":"验收单","":"")
		.s ISLSourceID=$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",19)
		.If (ISLSourceType=2) Set PLISTSML(13)=$Piece($Get(^DHCEQOpenCheckList(ISLSourceID)),"^",26)  	;LocationDR
		.Set PLISTSML(16)=$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",22)  	;SML_Hold3	// Mozy0217  2018-11-01
		.If PLISTSML(16)'="" Do
		..If PLISTSML(6)'["(附)" Set PLISTSML(6)="(附)"_PLISTSML(6)
		.if LocListFlag=0  d
		..&SQL(Insert Into SQLUSER.DHC_EQStoreMoveList Values :PLISTSML())
		..Set SMLRowID=$Get(%ROWID)
		.;拼设备DI串存储临时节点
		.Set RowIDs=""
		.Set tmpEquipID=0
		.For  Set tmpEquipID=$Order(^DHCEQEquip(0,"InStockList",tmpISLRowID,$Piece(InStockData,"^",2),tmpEquipID)) Quit:(tmpEquipID="")||(SQLCODE)  Do
		..If RowIDs'="" Set RowIDs=RowIDs_","
		..Set RowIDs=RowIDs_tmpEquipID
		.if LocListFlag=0 Set ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")=RowIDs
		.///处理科室列表对应的出库单
		.i ((LocListFlag=1)&&(ISLSourceType=2)) d
		..s (beginCount,endCount)=0
		..///modified by ZY0260 20210428
		..s ISLLRowID=0
		..f  s ISLLRowID=$o(^DHCEQInStockListLoc(0,"InStockList",tmpISLRowID,ISLLRowID)) quit:(ISLLRowID="")||(SQLCODE)  d
		...s ISLLBuyLocDR=$p($g(^DHCEQInStockListLoc(ISLLRowID)),"^",3)
		...s PLISTSM(4)=ISLLBuyLocDR
		...s ISLLQuantity=$p($g(^DHCEQInStockListLoc(ISLLRowID)),"^",4)
		...s PLISTSML(9)=ISLLQuantity
		...Set PLISTSM(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQStoreMove",+$H,PLISTSM(3),$Piece(InStockData,"^",20),"","",MoveTypeCode)
		...&SQL(insert into sqluser.DHC_EQStoreMove values :PLISTSM())
		...Set SMRowID=$Get(%ROWID)
		...q:SQLCODE'=0
		...Set PLISTSML(2)=SMRowID
		...&SQL(Insert Into SQLUSER.DHC_EQStoreMoveList Values :PLISTSML())
		...Set SMLRowID=$Get(%ROWID)
		...q:SQLCODE'=0
		...;截取设备DI串存储临时节点
		...i endCount=0  d
		....s endCount=ISLLQuantity	///modified by ZY0260 20210428
		...e  d
		....s endCount=endCount+ISLLQuantity	///modified by ZY0260 20210428
		...Set ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")=$p(RowIDs,",",beginCount,endCount)
		...s beginCount=endCount+1
		...;提交自动生成的出库单
		...Set val=SMRowID_"^^^^^^^^"_USERID
		...Set result = ##Class(web.DHCEQStoreMoveNew).SubmitData(val)
		...i SMRowID=result d
		....s SQLCODE=0
		...e  d
		....s SQLCODE=result
		...q:SQLCODE'=0
		...;审核完成自动生成的入库单	AuditData(val, CurRole, RoleStep, editFieldsInfo)
		...;Set SQLCODE = 0
		...Set AppSet=##class(web.DHCEQApproveList).GetApproveSet("14", SMRowID)	
		...If AppSet="" Set SQLCODE = -4007
		...q:SQLCODE'=0
		...Set afstep=0
		...For  Set afstep=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSet,afstep)) Quit:(afstep="")||(SQLCODE)  Do
		....Set afid=0
		....For  Set afid=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSet,afstep,afid)) Quit:(afid="")||(SQLCODE)  Do
		.....Set afrole=$p(^DHCEQCCode("DHCEQCApproveFlow",afid),"^",2)
		.....Set result = ##Class(web.DHCEQStoreMoveNew).AuditData(val,afrole,afstep,"")
		.....i SMRowID=result d
		......s SQLCODE=0
		.....e  d
		......s SQLCODE=result
		
		if LocListFlag=0
		{
			If SQLCODE
			{
				Quit SQLCODE
			}
			;提交自动生成的出库单
			Set val=SMRowID_"^^^^^^^^"_USERID
			Set SMRowID = ##Class(web.DHCEQStoreMoveNew).SubmitData(val)
			If SMRowID<0
			{
				Quit SMRowID
			}
			;审核完成自动生成的入库单	AuditData(val, CurRole, RoleStep, editFieldsInfo)
			Set SQLCODE = 0
			Set AppSet=##class(web.DHCEQApproveList).GetApproveSet("14", SMRowID)	
			If AppSet=""
			{
				Quit -4007
			}
			Set afstep=0
			For  Set afstep=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSet,afstep)) Quit:(afstep="")||(SQLCODE<0)  Do
			.Set afid=0
			.For  Set afid=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSet,afstep,afid)) Quit:(afid="")||(SQLCODE<0)  Do
			..Set afrole=$p(^DHCEQCCode("DHCEQCApproveFlow",afid),"^",2)
			..Set SQLCODE = ##Class(web.DHCEQStoreMoveNew).AuditData(val,afrole,afstep,"")
			..i SQLCODE>0 s SQLCODE=0		//czf 2021-06-11 不启用多科室自动出库错误
		}
		If SQLCODE
		{
			Quit SQLCODE
		}
	}
	Quit 0
}

/// 判断科室极其类型
/// SourceType	1:库房	其它:科室
/// 结果	0:相符	其它:不一致
/// w ##Class(web.DHCEQOpenCheckRequest).CheckLocStock(0,302)
ClassMethod CheckLocStock(SourceType As %String = "0", SourceLocDR As %String = "")
{
	i (SourceLocDR="") q -1
	n LocType
	
	s LocType=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0102",0))
	i SourceType=1 s LocType=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
	i $d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType,SourceLocDR)) q 0
	q -1
}

/// 2018-05-18 Modified By ZY ZY0169
/// add by wy 2018-5-2
/// 配置清单复制
/// 描述：将配置信息复制存储DHC_EQConfig.
ClassMethod InsertConfig(CRowid, EquipID)
{
	k CPLIST
	s result=$g(^DHCEQConfig(CRowid))
	s len=$l(result,"^")+1
	f i=1:1:len d
	.s CPLIST(i+1)=$p(result,"^",i)
	s CPLIST(3) = 2	;C_SourceType
 	s CPLIST(4) = EquipID	;C_SourceID

    &SQL(Insert Into SQLUser.DHC_EQConfig Values :CPLIST())	
    q SQLCODE
}

/// add by zy 2018-05-16  ZY0168
/// 在工作台界面的上面移动显示验收待入库的数量
/// w ##Class(web.DHCEQOpenCheckRequest).GetOCRToDelNum()
ClassMethod GetOCRToDelNum()
{
	s Num=0
	s EquipTypeIDS=##class(web.DHCEQCommon).GetEquipTypesByGroup("85")
	q:EquipTypeIDS=""
	s EquipTypeIDS="^"_EquipTypeIDS_"^"
	s OCRCheckType=""
	f  s OCRCheckType=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType)) q:OCRCheckType=""  d
	.s TEquipTypeDR=0
	.f  s TEquipTypeDR=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType,TEquipTypeDR)) q:TEquipTypeDR=""  d
	..s OCRRowID=0
	..q:EquipTypeIDS'[("^"_TEquipTypeDR_"^")
	..f  s OCRRowID=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType,TEquipTypeDR,"2",OCRRowID)) q:OCRRowID=""  d
	...;过滤无效
	...s InvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
	...q:InvalidFlag="Y"
	...s TOpenCheckRequestNo=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",37)	//Add By DJ 2015-08-20 DJ0157
	...//Modified by JDL 2010-11-22 JDL0059 修正删除判断错误
	...s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	...q:OCLRowID=""
	...
	...;根据验收单检测当前验收单是否存在入库记录
	...s Find=0
	...;Modified By JDL 2011-10-12 JDL0098 判断是否在有效的入库单中
	...s ISLRowID=0
	...f  s ISLRowID=$o(^DHCEQInStockList(0,"Source","2",OCLRowID,ISLRowID)) q:(ISLRowID="")||(Find'=0)  d
	....q:($p(^DHCEQInStock($p(^DHCEQInStockList(ISLRowID),"^",1)),"^",25)="Y")
	....s Find=Find+1
	...q:Find'=0
	...;根据验收单对应设备检测是否已经有部分或全部设备存在入库记录
	...;s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	...;q:OCLRowID=""
	...s EQRowID=0
	...f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",OCLRowID,EQRowID)) q:(EQRowID="")||(Find'=0)  d
	....s Find=$o(^DHCEQInStockList(0,"Equip",EQRowID,0))
	....i Find="" s Find=0
	...q:Find'=0
	...s Num=Num+1
	q Num
}

/// add by zy 2018-05-16  ZY0168
/// 在工作台界面的上面移动显示合同明细待验收的数量
/// w ##Class(web.DHCEQOpenCheckRequest).GetContractListToOpenNum()
ClassMethod GetContractListToOpenNum()
{
	s ContractNum=0
	s TContractDR=0
	f  s TContractDR=$o(^DHCEQContract(0,"Status",2,TContractDR)) quit:TContractDR=""  d
	.s TContractType=$p($g(^DHCEQContract(TContractDR)),"^",39)
	.q:(TContractType="1")||(TContractType="2") 
	.s rowid=0
	.f  s rowid=$o(^DHCEQContractList(0,"Contract",TContractDR,rowid)) quit:rowid=""  d
	..s ArriveNum=##class(web.DHCEQOpenCheck).GetArriveNum("","",rowid)
	..q:((TContractType=0)||(TContractType=3))&&(ArriveNum'>0)
	..s ContractNum=ContractNum+1
	q ContractNum
}

/// add by lmm 2018-08-16
/// 描述：hisui改造 查询采购计划单
/// 入参：Name 设备项名称
///      type 2:采购单 3:计划单
///      AssetType 资产类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQOpenCheckRequest","GetBPList","","3")
/// add by lmm 2018-03-01 523557 增加出参 TPurchaseTypeDR TPurchaseType
Query GetBPListnew(Name, type, AssetType As %Library.String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TModel:%String,TNum:%String,TManuFac:%String,TBuyPlanNo:%String,TCode:%String,TEquipType:%String,TEquipTypeDR:%String,TStatCat:%String,TStatCatDR:%String,TEquipCat:%String,TEquipCatDR:%String,TUnit:%String,TUnitDR:%String,TModelDR:%String,TManuFacDR:%String,TTestFlag:%String,TUrgencyFlag:%String,TPrice:%String,ItemDR:%String,TBuyPlanName:%String,TLimitYears:%String,TCommonName:%String,TPurposeTypeDR:%String,TPurposeType:%String,TPurchaseTypeDR:%String,TPurchaseType:%String")
{
}

ClassMethod GetBPListnewExecute(ByRef qHandle As %Binary, Name, type, AssetType As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;type 2:采购单 3:计划单
	s index=1
	s rowid=0
	d BuildDataGetBPListnew
	Quit $$$OK
BuildDataGetBPListnew
	
	s TEquipTypeDR=0
	f  s TEquipTypeDR=$o(^DHCEQBuyPlan(0,"EquipType",TEquipTypeDR)) quit:TEquipTypeDR=""  d
	.;过滤掉不能访问的类组
	.q:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
	.s TEquipType = $P(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR),"^",2)
	.s TBuyPlanDR=0
	.f  s TBuyPlanDR=$o(^DHCEQBuyPlan(0,"EquipType",TEquipTypeDR,TBuyPlanDR)) quit:TBuyPlanDR=""  d
	..;过滤掉状态非审核的
	..q:$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",6)'=2
	..s (TPurposeTypeDR,TPurposeType)=""
	..s (TPurchaseTypeDR,TPurchaseType)=""  ;add by lmm 2018-03-01 begin 523557
	..;获取计划信息
	..s TBuyPlanName=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",1)
	..s TBuyPlanNo=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",25)	
	..s TUrgencyFlag=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",33)
	..s TPurposeTypeDR=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",42)
	..i TPurposeTypeDR'="" s TPurposeType=$P(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR),"^",2)
	..;add by lmm 2018-03-01 begin 523557
	..s TPurchaseTypeDR=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",28)
	..i TPurchaseTypeDR'="" s TPurchaseType=$P(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR),"^",2)
	..;add by lmm 2018-03-01 end 523557
	..;获取计划明细信息
	..s rowid=0
	..f  s rowid=$o(^DHCEQBuyPlanList(0,"BuyPlan",TBuyPlanDR,rowid)) quit:rowid=""  d
	...d ResetVariablesGetBPListnew
	...s TRowID = rowid
	...s TCommonName = $p($g(^DHCEQBuyPlanList(rowid)),"^",2)	//2013-06-24 DJ0118
	...s TModelDR=$p($g(^DHCEQBuyPlanList(rowid)),"^",3)
	...i TModelDR'="" s TModel=$P(^DHCEQCCode("DHCEQCModel",TModelDR),"^",2)
	...s TManuFacDR=$p($g(^DHCEQBuyPlanList(rowid)),"^",4)
	...i TManuFacDR'="" s TManuFac=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFacDR)		//modified by czf 1252357
	...s TTestFlag=$p($g(^DHCEQBuyPlanList(rowid)),"^",5)
	...s TPrice=$p($g(^DHCEQBuyPlanList(rowid)),"^",6)
	...s TQuantityNum = $p($g(^DHCEQBuyPlanList(rowid)),"^",7)
	...s TArriveNum=$p($g(^DHCEQBuyPlanList(rowid)),"^",17)
	...s TNum=TQuantityNum-TArriveNum
	...q:TNum<1
	...
	...s ItemDR= $p($g(^DHCEQBuyPlanList(rowid)),"^",18)
	...i ItemDR'="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1) //2013-06-24 DJ0118
	...s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",2)
	...q:(Name'="")&&(TName'[Name)&&(TBuyPlanName'[Name)&&($e(TBuyPlanNo,1,$l(Name))'=Name)&&($ZCONVERT($e(TCode,1,$l(Name)),"U")'=Name)
	...s TStatCatDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",5)
	...i TStatCatDR '="" s TStatCat = $P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
	...Quit:(TStatCatDR'="")&&(AssetType'="")&&(AssetType'=0)&&(AssetType'=$Piece(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",5))	/// modified by GR0027 卫计委与武汉资产类型兼容
	...s TEquipCatDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
	...i TEquipCatDR '="" s TEquipCat = $P(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR),"^",2)
	...s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",7)
	...i TUnitDR'="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	...
	...;Modified by jdl 2012-3-7 JDL0120
	...s TLimitYears=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TEquipCatDR,TStatCatDR)
	...
	...d OutputRowGetBPListnew
	
	quit
OutputRowGetBPListnew
	s Data=$lb(TName,TRowID,TModel,TNum,TManuFac,TBuyPlanNo,TCode,TEquipType,TEquipTypeDR,TStatCat,TStatCatDR,TEquipCat,TEquipCatDR,TUnit,TUnitDR,TModelDR,TManuFacDR,TTestFlag,TUrgencyFlag,TPrice,ItemDR,TBuyPlanName,TLimitYears,TCommonName,TPurposeTypeDR,TPurposeType,TPurchaseTypeDR,TPurchaseType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBPListnew
	s (TName,TRowID,TModel,TNum,TManuFac,TCode,TStatCat,TStatCatDR,TEquipCat,TEquipCatDR,TUnit,TUnitDR,TModelDR,TManuFacDR,TTestFlag,TPrice,ItemDR,TCommonName)=""
	;s (TBuyPlanNo,TEquipType,TEquipTypeDR,TUrgencyFlag)="
	s TLimitYears=""
	quit
}

ClassMethod GetBPListnewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBPListnewExecute ]
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

ClassMethod GetBPListnewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBPListnewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by lmm 2018-08-16
/// 描述：hisui改造 选择合同列表中未验收或未验收完设备
/// 入参：Name 设备项名称
///      AssetType 资产类型
Query GetContractListnew(Name, AssetType As %Library.String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TModel:%String,TNum:%String,TProvider:%String,TManuFac:%String,TContractNo:%String,TCode:%String,TEquipType:%String,TEquipTypeDR:%String,TStatCat:%String,TStatCatDR:%String,TEquipCat:%String,TEquipCatDR:%String,TUnit:%String,TUnitDR:%String,TModelDR:%String,TProviderDR:%String,TManuFacDR:%String,TContractName:%String,TLimitYears:%String,TCommonName:%String")
{
}

ClassMethod GetContractListnewExecute(ByRef qHandle As %Binary, Name, AssetType As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetContractListnew
	Quit $$$OK
BuildDataGetContractListnew
	s TContractDR=0
	f  s TContractDR=$o(^DHCEQContract(0,"Status",2,TContractDR)) quit:TContractDR=""  d
	.s TContractName=$p($g(^DHCEQContract(TContractDR)),"^",1)
	.s TContractNo=$p($g(^DHCEQContract(TContractDR)),"^",2)
	.s TContractType=$p($g(^DHCEQContract(TContractDR)),"^",39)  //add by lmm 2107-07-18 405602
	.q:(TContractType'="0")    //add by lmm 2107-07-18 405602
	.s TProviderDR=$p($g(^DHCEQContract(TContractDR)),"^",18)
	.i TProviderDR'="" d
	..s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)
	.
	.s rowid=0
	.f  s rowid=$o(^DHCEQContractList(0,"Contract",TContractDR,rowid)) quit:rowid=""  d
	..d ResetVariablesGetContractListnew
	..s TRowID=rowid
	..s ArriveNum=##class(web.DHCEQOpenCheck).GetArriveNum("","",rowid)
	..q:ArriveNum'>0
	..s TCommonName = $p($g(^DHCEQContractList(rowid)),"^",2)	//2013-06-24 DJ0118
	..s ItemDR= $p($g(^DHCEQContractList(rowid)),"^",18)
	..s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1) //2013-06-24 DJ0118
	..s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",2)
	..q:(Name'="")&&(TContractName'[Name)&&(TName'[Name)&&($e(TContractNo,1,$l(Name))'=Name)&&($ZCONVERT($e(TCode,1,$l(Name)),"U")'=Name)
	..s TModelDR = $p($g(^DHCEQContractList(rowid)),"^",3)
	..i TModelDR '=""  d
	...s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..s TManuFacDR = $p($g(^DHCEQContractList(rowid)),"^",4)
	..i TManuFacDR '=""  d
	...s TManuFac = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFacDR)		//modified by czf 1252357
	..s TNum=ArriveNum
	..s TEquipTypeDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
	..q:((TEquipTypeDR'="")&&(##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0))
	..i TEquipTypeDR '="" d
	...s TEquipType = $P(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR),"^",2)
	..s TStatCatDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",5)
	..i TStatCatDR '="" d
	...s TStatCat = $P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
	..Quit:(TStatCatDR'="")&&(AssetType'="")&&(AssetType'=0)&&(AssetType'=$Piece(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",5))	///modified by GR0027 卫计委与武汉资产类型兼容 
	..s TEquipCatDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
	..i TEquipCatDR '="" d
	...s TEquipCat = $P(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR),"^",2)
	..s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",7)
	..i TUnitDR'="" d
	...s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..
	..;Modified by jdl 2012-3-7 JDL0120
	..s TLimitYears=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TEquipCatDR,TStatCatDR)
	..
	..d OutputRowGetContractListnew
	quit
OutputRowGetContractListnew
	s Data=$lb(TName,TRowID,TModel,TNum,TProvider,TManuFac,TContractNo,TCode,TEquipType,TEquipTypeDR,TStatCat,TStatCatDR,TEquipCat,TEquipCatDR,TUnit,TUnitDR,TModelDR,TProviderDR,TManuFacDR,TContractName,TLimitYears,TCommonName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContractListnew
	s (TName,TRowID,TModel,TNum,TManuFac,TCode,TEquipType,TEquipTypeDR,TStatCat,TStatCatDR,TEquipCat,TEquipCatDR,TUnit,TUnitDR,TModelDR,TManuFacDR,TCommonName)=""
	;s (TProvider,TContractNo,TProviderDR)=""
	s TLimitYears=""
	quit
}

ClassMethod GetContractListnewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractListnewExecute ]
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

ClassMethod GetContractListnewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractListnewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// MZY0125	2615815,2615876,2615902		2022-06-08	增加输出列:设备编号(TEquipNos)和附件信息(TAffixInfo)
/// HISUI改造需重新调整 曾超
/// add by kdf 2018-01-16
/// 用于验收单润乾打印
/// modify by zyq 2023-02-14 增加入参LeaveFactoryNo和出参TLeaveFactoryNo
/// d ##class(%ResultSet).RunQuery("web.DHCEQOpenCheckRequest","GetOPenCheckListNew","20")
Query GetOPenCheckListNew(TRowID As %Library.String = "", LeaveFactoryNo As %Library.String = "") As %Query(ROWSPEC = "TEquipName:%String,TCountry:%String,TManuFactory:%String,TModel:%String,TQuantity:%String,TOriginalFee:%String,TOpenCheckDate:%String,TCheckDate:%String,TOpenCheckNo:%String,TLeaveFactoryDate:%String,TRegisterNo:%String,TEquipNos:%String,TAffixInfo:%String,TUseLoc:%String,THold12:%String,TLeaveFactoryNo:%String") [ SqlProc ]
{
}

ClassMethod GetOPenCheckListNewExecute(ByRef qHandle As %Binary, TRowID As %Library.String = "", LeaveFactoryNo As %Library.String = "") As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    s index=1
    i TRowID="" Quit $$$OK
	s rowid=TRowID
	d ResetVariablesGetOPenCheckListNew
	s TEquipName=$p($g(^DHCEQOpenCheckList(rowid)),"^",2)  //设备名称
	s TCountryDR=$p($g(^DHCEQOpenCheckList(rowid)),"^",11)
	i TCountryDR'="" s TCountry=##class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR) // 产地
	s TManuFactoryDR=$p($g(^DHCEQOpenCheckList(rowid)),"^",15)   
	i TManuFactoryDR'="" s TManuFactory= ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)		//modified by czf 1252357  //出厂厂商
	s TModelDR =$p($g(^DHCEQOpenCheckList(rowid)),"^",5)
	i TModelDR'="" s TModel =$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)	//机型
	s TQuantity =$p($g(^DHCEQOpenCheckList(rowid)),"^",16) //数量
	s TOriginalFee =$p($g(^DHCEQOpenCheckList(rowid)),"^",17) // 价值
	s TOpenCheckDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",45),"date") //开箱日期
	s TCheckDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",46),"date") 
	s TEquipRequestDR=$p($g(^DHCEQOpenCheckList(rowid)),"^",1)
	i TEquipRequestDR'="" s TOpenCheckNo=$p($g(^DHCEQOpenCheckRequest(TEquipRequestDR)),"^",37) //验收单号
	s TLeaveFactoryDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckList(rowid)),"^",49),"date")
	s TRegisterNo =$p($g(^DHCEQOpenCheckList(rowid)),"^",56) //注册证号
	s TEquipNos=..GetEquipNosByOCRRowID(TEquipRequestDR)
	s AffixDR=0
	f  s AffixDR=$o(^DHCEQAffix(0,"CheckListDR",rowid,AffixDR)) quit:AffixDR=""  d
	.q:$p($g(^DHCEQAffix(AffixDR)),"^",15)'="N"
	.i TAffixInfo'="" s TAffixInfo=TAffixInfo_";"
	.s TAffixInfo=TAffixInfo_$p($g(^DHCEQAffix(AffixDR)),"^",4)_":"_$p($g(^DHCEQAffix(AffixDR)),"^",7)_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p($g(^DHCEQAffix(AffixDR)),"^",13))
 	s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQOpenCheckList(rowid)),"^",33))
	s THold12=$p($g(^DHCEQOpenCheckList(rowid)),"^",84)
	i LeaveFactoryNo'="" s TLeaveFactoryNo=LeaveFactoryNo //add by zyq 2023-02-14
	i TLeaveFactoryNo="" s TLeaveFactoryNo=$g(^DHCEQOpenCheckList(rowid,"EX")) //出厂编号
 	d OutputRowGetOPenCheckListNew
	Quit $$$OK
	
OutputRowGetOPenCheckListNew
	Set Data=$lb(TEquipName,TCountry,TManuFactory,TModel,TQuantity,TOriginalFee,TOpenCheckDate,TCheckDate,TOpenCheckNo,TLeaveFactoryDate,TRegisterNo,TEquipNos,TAffixInfo,TUseLoc,THold12,TLeaveFactoryNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOPenCheckListNew
	s (TEquipName,TCountry,TManuFactory,TModel,TQuantity,TOriginalFee,TOpenCheckDate,TCheckDate,TOpenCheckNo,TLeaveFactoryDate,TRegisterNo,TEquipNos,TAffixInfo,TUseLoc,THold12,TLeaveFactoryNo)=""
	quit
}

ClassMethod GetOPenCheckListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPenCheckListNewExecute ]
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

ClassMethod GetOPenCheckListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPenCheckListNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy0217  2018-11-01	待定
/// 功能：提取生成台账代码
/// 入参val:传入的字符串，第一个为验收单的id; 
/// 				AutoFlag:自动出入库设置; CancelFlag :"Y" 作废时根据审核状态的验收单生成台账
ClassMethod SaveEquipData(val As %Library.String = "", AutoFlag As %Library.String = "", CancelFlag As %Library.String = "")
{
	new rowid,Status,ContractListDR,Quantity,TranFlag,ocrrowid,oclrowid,SplitFlag,FileNo,ID,Info,User,Date,Time
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
 	s Date=+$H
    s Time=$P($H,",",2)
	s rowid=$p(val,"^",1)  //验收单ID
	s Status=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",20) //状态
	if (CancelFlag'="Y")   //add by kdf 作废时通过审核状态的验收单来生成台账，这里增加控制
	{
		if Status="2" q -2015   //该记录状态不符合,不能执行操作!
	}
	s PLISTSH(21)="2"
	s PLISTSH(26)=User
	s PLISTSH(27)=Date
	s PLISTSH(28)=Time
	if (CancelFlag'="Y")
	{
		s ContractListDR=$p(val,"^",2)
		s Quantity=$p(val,"^",3)
		s TranFlag=$p(val,"^",4)
	}
	s ocrrowid=rowid
	s oclrowid=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,0))
	if (CancelFlag="Y")
	{
		//当作废生成台账时获取设备数量 add by kdf 
		s Quantity=$P(^DHCEQOpenCheckList(oclrowid),"^",16)
	}
	i (CancelFlag'="Y")
	{
		//作废生成台账时 不需要事务，且不需要处理验收相关的表 add by kdf 
		i TranFlag="Y" TSTART
		Set ^DHCEQOpenCheckList(oclrowid,"AutoFlag")=AutoFlag	;20170327 Mozy0184
		&sql(update sqluser.DHC_EQOpenCheckRequest values :PLISTSH() where OCR_RowID=:ocrrowid)
		if SQLCODE
		{
			i TranFlag="Y" TROLLBACK
			q SQLCODE
		}
	}
	/*********审核设备*****************/
	s PI(2) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",2)	;Name
	s PI(3) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",4)	;ABCType
	s PI(4) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",5)	;ModelDR
 	s PI(5) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",6)	;EquiCatDR
 	s PI(6) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",7)	;UnitDR
 	s PI(7) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",8) //Code 	 
 	s PI(8) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",9) //ItemDR
 	s PI(9) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",47) ;InstallLoc
 	s PI(10) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",48) ;InstallDate
 	s PI(12) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",49) ;LeaveFactoryDate
 	s PI(13) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",10) ;OpenCheckDate
 	s PI(14) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",46) ;CheckDate
 	s PI(15) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",10) ;MakeDate
 	s PI(16) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",39) ;ComputerFlag  add by zy 20150901 zy0140
 	s PI(17) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",11)	;CountryDR
 	s PI(18) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",32)	;ManageLocDR
 	s PI(19) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",12)	;ManageLevelDR
 	//s PI(20) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",33)	;UseLocDR  //2012-03-12 DJ
 	s PI(21) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",8)	;OriginDR
 	s PI(22) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",9)	;FromDeptDR
	s PI(24) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",13)	;BuyTypeDR
 	s PI(25) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",14)	;EquipTechLevelDR 
 	s PI(26) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",5)	;ProviderDR
 	s PI(27) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",15)	;ManuFactoryDR
 	s PI(28) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",17)	;OriginalFee
 	If PI(3)=""
	{
		// Mozy003001	2020-03-17
		Set PI(3)="A"		;默认类
		;If PI(28)<80000 Set PI(3)="B"
		;If PI(28)<10000 Set PI(3)="C"
		;If PI(28)<1000 Set PI(3)="D"
		s SplitFlag=##class(web.DHCEQCommon).GetSysInfo("201013")
		i SplitFlag="" s SplitFlag="100000,10000"
		If PI(28)<+$p(SplitFlag,",",1) Set PI(3)="B"
		If PI(28)<+$p(SplitFlag,",",2) Set PI(3)="C"
		If PI(28)<+$p(SplitFlag,",",3) Set PI(3)="D"
	}
 	s PI(29) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",17)	;NetFee
	s PI(30) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",18)  	;NetRemainFee
	s PI(32) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",19) 	;LimitYearsNum
	s PI(33) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",37)	;ContractListDR
	s PI(34) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",20) 	;DepreMethod
	s PI(35) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",21)	;Remark
	s PI(37) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",29) 	;DesignWorkLoadNum
	s PI(38) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",30) 	;WorkLoadUnit
	s PI(39)=0 ;Status
	s PI(42) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",6)	;ContactUser
 	s PI(43) = $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",7)	;ContactMode
	s PI(47) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",42) ;GuaranteeFlag
 	s PI(48) = "N"
 	s PI(49) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",40) ;TestFlag
 	s PI(50) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",38) ;MedicalFlag
 	s PI(51) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",43) ;GuaranteeStartDate
	s PI(52) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",44) ;GuaranteeEndDate
 	s PI(53)=User
	s PI(54)=Date
	s PI(55)=Time
	s PI(56)=User
	s PI(57)=Date
	s PI(58)=Time
	s PI(59)= $p($g(^DHCEQOpenCheckList(oclrowid)),"^",21) ;Currency
	s PI(60) = "N"
	s PI(61) = "0"
 	s PI(62) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",22) //MemeryCode
 	s PI(63) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",41) //UrgencyFlag
 	s PI(64) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",3) //EquipType
 	s PI(65) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",23) //PurchaseTypeDR
 	s PI(66) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",24) //PurposeTypeDR
 	//s PI(68) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",31) ;StoreLoc 2009-06-26 党军
 	s PI(70) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",25) //ServiceDR 	 
 	s PI(73) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",26) //LocationDR
 	s PI(74) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",27) //GuaranteePeriodNum
 	s PI(76) = $p($g(^DHCEQOpenCheckList(oclrowid)),"^",28) //StatCatDR
 	s PI(77) = $Piece($Get(^DHCEQOpenCheckList(oclrowid)),"^",36) //ContractNo Mozy0051	2011-4-15
 	s PI(78) = oclrowid //OpenCheckListRowid
 	//s LeaveFactoryNo=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",55)
 	s LeaveFactoryNo=$g(^DHCEQOpenCheckList(oclrowid,"EX")) //2009-08-17 党军
 	//新增:2009-11-25 党军 begin DJ0037
 	s PI(82)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",60) ;BenefitAnalyFlag
 	s PI(83)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",61) ;CommonageFlag
 	s PI(84)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",62) ;AutoCollectFlag
 	s PI(85)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",65) ;WorkLoadPerMonth
 	s PI(93)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",56) ;Hold2  //注册证号
 	s PI(95)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",58)	;Hold4	//品牌	2013-12-11 DJ0122
 	Set PI(96)=$Piece($Get(^DHCEQOpenCheckList(oclrowid)),"^",59)	;Hold5	//经费来源 20150630  Mozy0154
 	s PI(109)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",66)  //ValueType
 	s PI(110)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",67)  //DirectionsUse
 	s PI(111)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",68)  //UserDR
 	s PI(112)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",69)  //AccountShape
 	s PI(113)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",70)  //ProjectNo
 	s PI(91)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",71)  //凭证号
 	s PI(103)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",72)  //EQRaditionFlag	放射标志
	s PI(81)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",73) ;中医标志 Add By DJ 2017-01-20
	s PI(114)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",77)  //ServiceHandler
	s PI(115)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",78)  //ServiceTel
	s PI(117)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",74)  //SpecialFlag
	s PI(118)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",81)  //SalesManager		//Mozy	2018-5-15
	s PI(119)=$p($g(^DHCEQOpenCheckList(oclrowid)),"^",82)  //SalesManagerTel	//Mozy	2018-5-15
	//s PI(86)= $p($g(^DHCEQOpenCheckRequest(ocrrowid)),"^",38) //FileNo 档案号 2014-1-9 HZY0045 
 	Set FileNo=$g(^DHCEQOpenCheckList(oclrowid,"FileNo"))		//20150819  Mozy0159
 	Set SplitFlag=##class(web.DHCEQCommon).GetSysInfo("990035")	//20150822  Mozy0162 验收时档案号是否拆分
	for j=1:1:Quantity
	{
		q:SQLCODE'=0
	 	s PI(11) =##class(web.DHCEQCommon).Replace($P(LeaveFactoryNo, ",", j),$C(13,10),"")
	 	//20150822  Mozy0162 验收时档案号是否拆分
	 	If SplitFlag=1 Do
	 	.Set PI(86) =##class(web.DHCEQCommon).Replace($Piece(FileNo, ",", j),$C(13,10),"")
	 	Else  Do
	 	.Set PI(86) = FileNo
	 	&sql(Insert Into sqluser.DHC_EQEquip values :PI())
	 	if SQLCODE
		{
			i (CancelFlag'="Y")
			{
				i TranFlag="Y" TROLLBACK
			}
			q:SQLCODE
		}
		s ID=$G(%ROWID)
	 	s SQLCODE= ##CLASS(web.DHCEQEquip).UpdateEquipNo(ID,Date)
		i SQLCODE
		{
	 		i (CancelFlag'="Y")
	 		{
	 			i TranFlag="Y" TROLLBACK
	 	 	}
	 		q:SQLCODE
	 	}
	 	if PI(33)'=""
	 	{
		 	s SQLCODE=##Class(web.DHCEQOpenCheckRequest).InsertAffixByContract(ID,PI(33))
			if SQLCODE<0
			{
		 		i (CancelFlag'="Y")
		 		{
					i TranFlag="Y" TROLLBACK
		 		}
				q:SQLCODE
			}
	 	}
	 	//add by wy 2018-5-2
	 	//配置清单复制与附属设备生成台账
	 	s SQLCODE=##class(web.DHCEQOpenCheckRequest).InsertEquipOrConfig(oclrowid,ID,j)
		i SQLCODE
	    { 
	       i (CancelFlag'="Y")
	       {
		       i TranFlag="Y" TROLLBACK
	       }
	 		q:SQLCODE
	    }
		/// Mozy0145	20141017
		Set StatDR=$Piece($Get(^DHCEQOpenCheckList(oclrowid)),"^",28)
		Set AssetType=$Piece($Get(^DHCEQCCode("DHCEQCStatCat",StatDR)),"^",5)
		Set Info=##Class(web.DHCEQOpenCheckRequest).GetInfoData(0,oclrowid)
		Set SQLCODE=##Class(web.DHCEQOpenCheckRequest).SaveDataForInfo(Info,1,ID,2)
		if SQLCODE
		{
			i (CancelFlag'="Y")
			{
				i TranFlag="Y" TROLLBACK
			}
		 	q:SQLCODE
		}
	 	///////////////////拆分附件的出厂编号 		 ///Mozy	2016-8-4
		If $Data(^DHCEQAffix(0,"CheckListDR",oclrowid))'=0
	 	{
		 	Set Affixrowid=0
			For  Set Affixrowid=$Order(^DHCEQAffix(0,"CheckListDR",oclrowid,Affixrowid))  Quit:Affixrowid=""  Do
			.;Hold3-拆分标记	把附件拆分为单台
			.If $Piece($Get(^DHCEQAffix(Affixrowid)),"^",27)="Y" Do
			..Set QuantityNum=$Piece($Get(^DHCEQAffix(Affixrowid)),"^",7)
			..for n=1:1:QuantityNum d
			...Kill APLIST
			...Set APLIST(2) = ID	;EquipDR
			...Set APLIST(3) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",2)	;AffixDR
			...Set APLIST(4) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",3)	;AffixCatDR
			...Set APLIST(5) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",4)	;PartSpec
			...Set APLIST(6) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",5)	;PartModel
			...Set APLIST(7) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",6)	;ManuFactoryDR
			...Set APLIST(8) = 1	;$Piece($Get(^DHCEQAffix(Affixrowid)),"^",7)	;QuantityNum
			...Set APLIST(9) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",8)	;ReceiverDR
			...Set LeaveFacNo = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",9)	;LeaveFacNo
			...i $d(^DHCEQAffix(Affixrowid,"EX")) Set LeaveFacNo = $g(^DHCEQAffix(Affixrowid,"EX"))	;LeaveFacNo
			...Set APLIST(10) = $Piece(LeaveFacNo,",",(j-1)*QuantityNum+n)
			...Set APLIST(11) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",10)	;LeaveDate
			...Set APLIST(12) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",11)	;PriceFee
			...Set APLIST(13) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",12)	;Remark
			...Set APLIST(14) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",13)	;CurrencyDR 
			...Set APLIST(15) = "N"		;AF_DisuseFlag
			...Set APLIST(16) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",15)	;AF_InvalidFlag
			...Quit:APLIST(16)'="N"
			...Set APLIST(20) = ""			;AF_CheckListDR
			...Set APLIST(21) = Affixrowid	;AFOldRowID
			...Set APLIST(25) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",24) ;ProviderDR
			...Set APLIST(26) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",25) ;Hold1
			...Set APLIST(27) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",26) ;Hold2
			...;Set APLIST(28) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",27) ;Hold3
			...Set APLIST(29) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",28) ;Hold4
		 	...Set APLIST(30) = $Piece($Get(^DHCEQAffix(Affixrowid)),"^",29) ;Hold5
		 	...
		 	...&SQL(Insert Into SQLUSER.DHC_EQAffix Values :APLIST())
	 	}
	}
	if SQLCODE
	{
		i (CancelFlag'="Y")
		{
	 		i TranFlag="Y" TROLLBACK
	 	}
	 	q SQLCODE
	}
	i (CancelFlag'="Y")
	{
		//add by kdf 作废根据审核状态的验收单生成台账时 不执行下面的代码
		Set SQLCODE = ##Class(web.DHCEQOpenCheckRequest).AutoInOutExecute(1,oclrowid,$p($g(^DHCEQOpenCheckList(oclrowid)),"^",31),User)
		if SQLCODE
		{
			i TranFlag="Y" TROLLBACK
		 	q SQLCODE
		}
	}
	
	i (CancelFlag'="Y")
	{
		i TranFlag="Y" TCOMMIT
	}
	i (CancelFlag="Y")
	{
		q 0
	}
	q ocrrowid
}

/// add by lmm 2019-08-21
/// 描述：根据验收单id获取入库单id
/// 入参：OpenCheckID 验收单id
/// w ##Class(web.DHCEQOpenCheckRequest).GetInStockIDByOpenCheckID(3)
/// add by lmm 2019-08-21
/// 描述：根据验收单id获取入库单id
/// 入参：OpenCheckID 验收单id
/// w ##Class(web.DHCEQOpenCheckRequest).GetInStockIDByOpenCheckID(165)
ClassMethod GetInStockIDByOpenCheckID(OpenCheckID)
{
	i OpenCheckID="" q "0^0"
	s (StoreMoveID,StoreMoveListID,InStockID,InStockListID)=0
	s OpenCheckListID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OpenCheckID,0))
	i OpenCheckListID="" q "0^0"
	i $d(^DHCEQInStockList(0,"Source",2,OpenCheckListID))  d
	.s InStockListID=$o(^DHCEQInStockList(0,"Source",2,OpenCheckListID,0))
	.i InStockListID'="0" s InStockID=$p(^DHCEQInStockList(InStockListID),"^",1)
	e  d
	.s InStockID=0
	i (InStockListID'="")&&($d(^DHCEQStoreMoveList(0,"InStockList",InStockListID)))  d
	.s StoreMoveListID=$o(^DHCEQStoreMoveList(0,"InStockList",InStockListID,0))
	.i StoreMoveListID'="0" s StoreMoveID=$p(^DHCEQStoreMoveList(StoreMoveListID),"^",1)
	e  d
	.s StoreMoveID=0

	q InStockID_"^"_StoreMoveID
}

/*
ClassMethod GetInStockIDByOpenCheckID(OpenCheckID)
{
	i OpenCheckID="" q 0
	s InStockID=0
	
	s OpenCheckListID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OpenCheckID,0))
	s InStockListID=$o(^DHCEQInStockList(0,"Source",2,OpenCheckListID,0))
	i InStockListID'="" s InStockID=$p(^DHCEQInStockList(InStockListID),"^",1)

	q InStockID
}
*/
/// add by lmm 2019-08-21
/// 描述：根据验收明细id获取验收单id
/// 入参：OpenCheckID 验收明细id
/// w ##Class(web.DHCEQOpenCheckRequest).GetOCRIDByOCListID(46)
ClassMethod GetOCRIDByOCListID(OpenCheckListID)
{
	i OpenCheckListID="" q ""
	s OpenCheckID=""
	s OpenCheckID=$p(^DHCEQOpenCheckList(OpenCheckListID),"^",1)

	q OpenCheckID
}

/// Mozy		2019-10-04
/// 目的:删除插入验收单单合同附件信息
/// 输入:验收单DR
/// 返回值: 返回SQLCODE
/// w ##Class(web.DHCEQOpenCheckRequest).DeleteContractAffix(154)
ClassMethod DeleteContractAffix(OCRRowID As %String = "")
{
	i OCRRowID="" q 0
	n OCLRowID,OCLSourceID,SQLCODE
	s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	i OCLRowID="" q 0
	s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	i OCLSourceType'=1 q 0
	s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
	i OCLSourceID="" q 0
	
	; ^DHCEQContractConfig("0","ContractList","166","41")
	Set SQLCODE=0
	Set ConfigDR=""
	For  Set ConfigDR=$Order(^DHCEQContractConfig(0,"ContractList",OCLSourceID,ConfigDR)) Quit:(ConfigDR="")||(SQLCODE<0)  Do
	.Set ^DHCEQContractConfig(ConfigDR,"OCL")=0
	
	Quit 0
}

/// Add By JYP 2019-09-02
/// 描述:生成设备属性关键字列表格式
/// 入参:  name：关键字列表名称
ClassMethod KeyWordsList(name) As %String
{
	w "<div id='"_name_"'>"
	w "</div>",!
}

/// Modify Mozy003018	1279498	2020-04-27	修正增加SourceID和SourceType参数获取设备属性列表
/// Add By JYP 2019-09-02
/// 描述:生成设备属性关键字列表内容
/// 入参:  
/// 			SourceType:来源类型ID(1:设备项,2:验收单,3:设备,4:合同)
/// 		SourceID:对应来源ID
/// w ##Class(web.DHCEQOpenCheckRequest).ReturnJsonEquipAttribute(3,4)
ClassMethod ReturnJsonEquipAttribute(SourceID, SourceType As %String = "2")
{
	//s ReturnInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetNewJSONObj()  // modify by jyp 2019-08-26
	s ReturnInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s ReturnData="["
	s GroupID=%session.Get("LOGON.GROUPID")  //add by lmm 2020-05-07
	s EquipAttributeList=##class(web.DHCEQCommon).GetSysInfo("990065")
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCEquipAttribute",rowid)) quit:rowid=""  d
	.q:($p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",5)="Y")
	.s EALGroup = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",3)
	.q:((","_EquipAttributeList_",")'[(","_EALGroup_","))
	.//add by lmm 2020-05-07 begin
	.s TRowID=""
	.i $D(^DHCEQCCode("DHCEQCGroupEquipAttribute",0,"Group",GroupID,rowid))  d
	..s TRowID=$o(^DHCEQCCode("DHCEQCGroupEquipAttribute",0,"Group",GroupID,rowid,0))
	.i TRowID="" d
	..s TEditFlag="N"
	.e  d
	..s TEditFlag=$p($g(^DHCEQCCode("DHCEQCGroupEquipAttribute",TRowID)),"^",3) 
	.q:(TEditFlag="N")
	.//add by lmm 2020-05-07 end	
	.s EALName = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",2)
	.s Lrowid=0
	.s EALFlag=""
	.if (SourceID'="")  d
	..f  s Lrowid=$o(^DHCEQEquipAttributeList(0,"AttributeSource",rowid,SourceType,SourceID,Lrowid)) quit:Lrowid=""  d
	...s EALFlag="true"
	...//Modify by zx 2020-02-21 BUG ZX0077 分类放大镜元素信息获取
	...s (EALSubInfo,EALSubInfoDesc)=""
	...s EALSubInfo=$p($g(^DHCEQEquipAttributeList(Lrowid)),"^",4)
	...i EALSubInfo'="" d
	....s EALSubInfoDesc=$p($g(^DHCEQCCode("DHCEQCInHospitalType",EALSubInfo)),"^",2)
	....d ReturnInfo.%Set("id"_rowid_"Desc",EALSubInfoDesc)
	....d ReturnInfo.%Set("id"_rowid_"DR",EALSubInfo)
	.if ReturnData'="["  d
	..s ReturnData=ReturnData_","
	.s ReturnData=ReturnData_"{text:'"_EALName_"',id:'id"_rowid_"',selected:'"_EALFlag_"'}"
	s ReturnData=ReturnData_"]"
	d ReturnInfo.%Set("Data",ReturnData)
	q ReturnInfo.%ToJSON()
}

/// czf 2022-06-06
/// 描述：hisui改造在jQuery页面标签显示合计信息
/// 输入：node：临时global的节点名称
/// w ##Class(web.DHCEQOpenCheckRequest).GetSumInfo(61300)
ClassMethod GetSumInfo(Ejob As %Library.String = "")
{
	//s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s info=""
	
	s (Count,TotalFee,TotalNetFee,TotalDepreFee)=0
	
	s nrowid=0	
    f  s nrowid=$o(^TempDHCEQ("CheckDetail",+$h,Ejob,nrowid)) q:nrowid=""  d
    .q:$p($g(^TempDHCEQ("CheckDetail",+$h,Ejob,nrowid)),"^",1)=""  //合计行
    .s OriginalFee=$p($g(^TempDHCEQ("CheckDetail",+$h,Ejob,nrowid)),"^",46)
    .s Quantity=$p($g(^TempDHCEQ("CheckDetail",+$h,Ejob,nrowid)),"^",51)
	.s Count=Count+Quantity
	.s TotalFee=TotalFee+(Quantity*OriginalFee)
	
	s TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
  	s info="合计&nbsp;&nbsp;数量:"_Count_"&nbsp;&nbsp;&nbsp;总金额:"_TotalFee
  	
  	q info
}

/// czf 2022-06-06
/// 获取验收单设备编号
/// w ##Class(web.DHCEQOpenCheckRequest).GetEQNosByOpenCheckList(61300)
ClassMethod GetEQNosByOpenCheckList(mxrowid)
{
	i mxrowid="" q ""
	s EQNos=""
	s EQRowID=0
	f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",mxrowid,EQRowID))  q:EQRowID=""  d
	.q:$Piece($Get(^DHCEQEquip(EQRowID,"OtherInfo")),"^",24)'=""
	.s EQNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	.s EQNos=EQNos_","_EQNo
	
	q ##class(web.DHCEQCommon).NoToGroupNo(EQNos)
}

/// czf 2022-10-18
/// 根据验收单ID获取验收明细ID
/// w ##Class(web.DHCEQOpenCheckRequest).GetCheckListID(420)
ClassMethod GetCheckListID(rowid)
{
	i rowid="" q ""
	s CheckListDR=""
	s CheckListDR=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,CheckListDR))  q:CheckListDR=""  d
	
	q CheckListDR
}

/// zyq 2022-11-16
/// 获取验收单对应设备信息
/// w ##Class(web.DHCEQOpenCheckRequest).GetEQNosByOpenCheckListInfo(1)
ClassMethod GetEQIDsByOpenCheckList(mxrowid)
{
	i mxrowid="" q ""
	s EQRowID=0
	s EQRowIDs=""
	f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",mxrowid,EQRowID)) q:EQRowID=""  d
	.q:$Piece($Get(^DHCEQEquip(EQRowID,"OtherInfo")),"^",24)'=""
	.s EQRowIDs=EQRowIDs_","_EQRowID
	if (EQRowIDs="") q ""
	q EQRowIDs
}

}
