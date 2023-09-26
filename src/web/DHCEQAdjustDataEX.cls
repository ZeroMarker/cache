Class web.DHCEQAdjustDataEX Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by zy 2011-10-25 zy0083
/// desc:按照入库日期,类组,类型,分类,名称,供应商,生产厂家,型号,入库明细,单价汇总设备台帐
/// 入参：valEquipType：类组id串"1,2,3"
///       Fee：调整金额标准
///       filename：结果输出的文件
/// w ##Class(web.DHCEQAdjustDataEX).GetChangeEQList("3",1500,"d:\eq1.txt")
/// w ##Class(web.DHCEQAdjustDataEX).GetChangeEQList("1,2,3,4,5",1500,"d:\eq1.txt")
ClassMethod GetChangeEQList(valEquipType, Fee, filename)
{
	//select eq_name,eq_modeldr->m_desc,eq_originalfee,eq_transassetdate,
	//eq_instocklistdr,sum(eq_originalfee) amount,count(*) qty 
	//from DHC_EQEquip 
	//where EQ_EquiptypeDR=3 and EQ_Originalfee<1500 
	//group by eq_name,eq_modeldr->m_desc,eq_originalfee,eq_transassetdate,
	//eq_instocklistdr 
	//having sum(eq_originalfee)<1500
	
	s valEquipType=","_valEquipType_","
	k ^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList")
	s (sumFee,sumNum,sumStr)=0
	
	s no=0
	for  s no=$o(^DHCEQEquip(0,"No",no)) quit:no=""  d
	.s rowid=0
	.for  s rowid=$o(^DHCEQEquip(0,"No",no,rowid)) quit:rowid=""  d
	..s (EquipType,OriginalFee,Name,ModelDR,ProviderDR,ManuFactoryDR,TransAssetDate,InStockList)=""
	..
	..s EquipType=$p($g(^DHCEQEquip(rowid)),"^",63)
	..s EquipTypeDR=EquipType
	..s EquipType=","_EquipType_","
	..s OriginalFee=+$p($g(^DHCEQEquip(rowid)),"^",27)
	..q:(valEquipType'[EquipType)
	..q:(OriginalFee>=Fee)
	..s Name=$p($g(^DHCEQEquip(rowid)),"^",1)
	..s Name=##Class(web.DHCEQCommon).Trim(Name)
	..s ModelDR=+$p($g(^DHCEQEquip(rowid)),"^",3)
	..s EquipCatDR=$p($g(^DHCEQEquip(rowid)),"^",4)
	..s ProviderDR=+$p($g(^DHCEQEquip(rowid)),"^",25)
	..s ManuFactoryDR=+$p($g(^DHCEQEquip(rowid)),"^",26)
	..s TransAssetDate=+$p($g(^DHCEQEquip(rowid)),"^",45)
	..s InStockList=+$p($g(^DHCEQEquip(rowid)),"^",70)
	..s StatCatDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	..s TempInfo=$g(^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList",TransAssetDate,EquipTypeDR,StatCatDR,EquipCatDR,Name,ProviderDR,ManuFactoryDR,InStockList,OriginalFee,ModelDR))
	..s sumFee=$p(TempInfo,"^",1)+OriginalFee
	..s sumNum=$p(TempInfo,"^",2)+1
	..i $p(TempInfo,"^",3)'=""  d
	...s sumStr=$p(TempInfo,"^",3)_","_rowid
	..e  d
	...s sumStr=rowid
	..s ^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList",TransAssetDate,EquipTypeDR,StatCatDR,EquipCatDR,Name,ProviderDR,ManuFactoryDR,InStockList,OriginalFee,ModelDR)=sumFee_"^"_sumNum_"^"_sumStr
	
	Set file=##class(%File).%New(filename)
	Do file.Open("WSN")
	
	s (TransAssetDateDesc,EquipTypeDR,EquipType,StatCatDR,StatCat,EquipCatDR,EquipCat,Name,ProviderDR,Provider,ManuFactoryDR,ManuFactory,ModelDR,Model,InStockList,OriginalFee,sumNum,sumFee,Flag,sumStr)=""
	s TransAssetDate=0
	for  s TransAssetDate=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList",TransAssetDate)) quit:TransAssetDate=""  d
	.s TransAssetDateDesc=##Class(web.DHCEQCommon).TransValueToPage(TransAssetDate,"date")
	.s EquipTypeDR=""
	.for  s EquipTypeDR=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList",TransAssetDate,EquipTypeDR)) quit:EquipTypeDR=""  d
	..i EquipTypeDR>0 s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	..s StatCatDR=""
	..for  s StatCatDR=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList",TransAssetDate,EquipTypeDR,StatCatDR)) quit:StatCatDR=""  d
	...i StatCatDR>0 s StatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",StatCatDR)
	...s EquipCatDR=""
	...for  s EquipCatDR=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList",TransAssetDate,EquipTypeDR,StatCatDR,EquipCatDR)) quit:EquipCatDR=""  d
	....i EquipCatDR>0 s EquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",EquipCatDR)
	....s Name=""
	....for  s Name=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList",TransAssetDate,EquipTypeDR,StatCatDR,EquipCatDR,Name)) quit:Name=""  d
	.....s ProviderDR=""
	.....for  s ProviderDR=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList",TransAssetDate,EquipTypeDR,StatCatDR,EquipCatDR,Name,ProviderDR)) quit:ProviderDR=""  d
	......i ProviderDR>0 s Provider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
	......s ManuFactoryDR=""
	......for  s ManuFactoryDR=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList",TransAssetDate,EquipTypeDR,StatCatDR,EquipCatDR,Name,ProviderDR,ManuFactoryDR)) quit:ManuFactoryDR=""  d
	.......i ManuFactoryDR>0 s ManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR)),"^",1)
	.......s InStockList=""
	.......for  s InStockList=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList",TransAssetDate,EquipTypeDR,StatCatDR,EquipCatDR,Name,ProviderDR,ManuFactoryDR,InStockList)) quit:InStockList=""  d
	........s OriginalFee=""
	........for  s OriginalFee=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList",TransAssetDate,EquipTypeDR,StatCatDR,EquipCatDR,Name,ProviderDR,ManuFactoryDR,InStockList,OriginalFee)) quit:OriginalFee=""  d
	.........s (ModelDR)=""
	.........s sumFee=0
	.........for  s ModelDR=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList",TransAssetDate,EquipTypeDR,StatCatDR,EquipCatDR,Name,ProviderDR,ManuFactoryDR,InStockList,OriginalFee,ModelDR)) quit:ModelDR=""  d
	..........i ModelDR>0 s Model=##Class(web.DHCEQCommon).GetTrakNameByID("model",ModelDR)
	..........s (TempInfo,sumFee,Flag,sumNum,sumStr,str)=""
	..........s TempInfo=$g(^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList",TransAssetDate,EquipTypeDR,StatCatDR,EquipCatDR,Name,ProviderDR,ManuFactoryDR,InStockList,OriginalFee,ModelDR))
	..........s sumFee=$p(TempInfo,"^",1)
	..........i sumFee>Fee s Flag="Y"
	..........s sumNum=$p(TempInfo,"^",2)
	..........s sumStr="'"_$p(TempInfo,"^",3)
	..........s str=TransAssetDateDesc_"^"_EquipTypeDR_"^"_EquipType_"^"_StatCatDR_"^"_StatCat_"^"_EquipCatDR_"^"_EquipCat_"^"_Name_"^"_ProviderDR_"^"_Provider_"^"_ManuFactoryDR_"^"_ManuFactory_"^"_ModelDR_"^"_Model_"^"_InStockList_"^"_OriginalFee_"^"_sumNum_"^"_sumFee_"^"_Flag_"^"_sumStr
	..........Do file.WriteLine(str)
	k ^DHCEQTemp("web.DHCEQAdjustDataEX","GetChangeEQList")
	
 	Do file.Close()
	Quit "ok!"
}

/// add by zy 2011-10-25 zy0083
/// Desc:从要调整的数据源文件中生成可操作的数据MasterItem.txt,Equip.txt.
///      然后添加新的设备项，在数据调整中批量调整数据.
/// 入参:filename：数据源文件,文件中数据格式是:新类组^新类型^新分类^设备ID1,设备ID2,设备ID3...
///          topath：输出结果的物理路径,输出结果生成两个txt文件:MasterItem.txt,Equip.txt.
/// w ##Class(web.DHCEQAdjustDataEX).GetDataFile("d:\模版.txt","d:\")
ClassMethod GetDataFile(filename, topath)
{
	n line,errs,result,tofilename
	
	k ^DHCEQTemp("web.DHCEQAdjustDataEX","AdjsutEQ")
	
	If '##class(%File).Exists(filename) q
	s errs=""
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=filename
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		if line="" continue
		set result=..AdjsutEQ(line)
		i result'=""
		{
			w line_","_result,!
			s errs=0
		}
	}
	if (errs'="")
	{
		w "data need modifiy,  import fail! ",!
		q ""
	}
	else
	{
		w "import success!",!
	}
	
	//生成新的设备项数据
	s tofilename=topath_"MasterItem.txt"
	Set file=##class(%File).%New(tofilename)
	Do file.Open("WSN")
	s (Code,Name,EquipType,StatCat,EquipCat,UnitDR,Unit)=""
	s EquipType=""
	for  s EquipType=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","AdjsutEQ","Item",EquipType)) quit:EquipType=""  d
	.s StatCat=""
	.for  s StatCat=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","AdjsutEQ","Item",EquipType,StatCat)) quit:StatCat=""  d
	..s EquipCat=""
	..for  s EquipCat=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","AdjsutEQ","Item",EquipType,StatCat,EquipCat)) quit:EquipCat=""  d
	...s Name=""
	...for  s Name=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","AdjsutEQ","Item",EquipType,StatCat,EquipCat,Name)) quit:Name=""  d
	....s Code=$P(^DHCEQTemp("web.DHCEQAdjustDataEX","AdjsutEQ","Item",EquipType,StatCat,EquipCat,Name),"^",1)
	....s UnitDR=$P(^DHCEQTemp("web.DHCEQAdjustDataEX","AdjsutEQ","Item",EquipType,StatCat,EquipCat,Name),"^",2)
	....s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	....s Str=Code_"^"_Name_"^"_EquipType_"^"_StatCat_"^"_EquipCat_"^"_Unit
	....Do file.WriteLine(Str)
 	Do file.Close()
 	
 	//生成新的需要做批量调整的数据
	s tofilename=topath_"Equip.txt"
	Set file=##class(%File).%New(tofilename)
	Do file.Open("WSN")
	s rowid=0
	for  s rowid=$o(^DHCEQTemp("web.DHCEQAdjustDataEX","AdjsutEQ","EQ",rowid))  quit:rowid=""  d
	.s (Name,No,Status,OriginalFee,DepreTotal,NetFee,StoreLoc,EquipType,StatCat,Origin,NewStoreLoc,NewEquipType,NewStatCat,NewOrigin)=""
	.s NewInfo=$g(^DHCEQTemp("web.DHCEQAdjustDataEX","AdjsutEQ","EQ",rowid))
	.s Name=$p($g(^DHCEQEquip(rowid)),"^",1)
	.s No=$p($g(^DHCEQEquip(rowid)),"^",71)
	.s Status=$p($g(^DHCEQEquip(rowid)),"^",38)
	.s Status=##class(web.DHCEQEquip).GetEquipStatusDisplay(Status)
	.s OriginalFee=$p($g(^DHCEQEquip(rowid)),"^",27)
	.s DepreTotal=$p($g(^DHCEQEquip(rowid)),"^",35)
	.s NetFee=$p($g(^DHCEQEquip(rowid)),"^",28)
	.s StoreLocDR=$p($g(^DHCEQEquip(rowid)),"^",67)
	.i StoreLocDR'="" s StoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	.s EquipTypeDR=$p($g(^DHCEQEquip(rowid)),"^",63)
	.i EquipTypeDR'="" s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	.s StatCatDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	.i StatCatDR'="" s StatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",StatCatDR)
	.s OriginDR=$p($g(^DHCEQEquip(rowid)),"^",20)
	.i OriginDR'="" s Origin=$p($g(^DHCEQCCode("DHCEQCOrigin",OriginDR)),"^",2)
	.s NewStoreLoc=StoreLoc
	.s NewEquipType=$p(NewInfo,"^",1)
	.s NewStatCat=$p(NewInfo,"^",2)
	.s NewEquipCat=$p(NewInfo,"^",3)
	.s NewOrigin=Origin
	.s Str=Name_"^"_No_"^"_Status_"^"_OriginalFee_"^"_DepreTotal_"^"_NetFee_"^"_StoreLoc_"^"_EquipType_"^"_StatCat_"^"_Origin_"^"_NewStoreLoc_"^"_NewEquipType_"^"_NewStatCat_"^"_NewOrigin
	.Do file.WriteLine(Str)
	k ^DHCEQTemp("web.DHCEQAdjustDataEX","AdjsutEQ")
 	Do file.Close()
 	quit "export success!"
}

/// add by zy 2011-10-25 zy0083
/// desc:处理GetDataFile方法中filename文件中的一条记录.
/// 
/// 入参:RowStr:格式:新类组^新类型^新分类^设备ID1,设备ID2,设备ID3...
/// w ##Class(web.DHCEQAdjustDataEX).AdjsutEQ("低值资产^新院器械专用设备^一般医用化验器具^'26819")
ClassMethod AdjsutEQ(RowStr)
{
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	s (EquipType,StatCat,EquipCat,Str)=""
	s AdjustFlag=$p(RowStr,del,20),EquipType=$p(RowStr,del,21),StatCat=$p(RowStr,del,22)
	s EquipCat=$p(RowStr,del,23),Str=$p(RowStr,del,24)
	
	i AdjustFlag'="Y" q "" //AdjustFlag=Y时,才是可以调整的数据
	i EquipType'=""  
	.s tmpid=##Class(web.DHCEQImportDataTool).GetEquipTypeID(EquipType)
	.i tmpid=""  d 
	..s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"没有找到该设备类组: 设备类组="_EquipType)
	.e  d
	..s EquipTypeDR=tmpid
	e  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"没有设置设备类组: 设备类组="_EquipType)
	if RetStr'="" q RetStr
		
 	i StatCat'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetStatCatID(StatCat)
	.i tmpid=""  d 
	..s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"没有找到该设备类型: 设备类型="_StatCat)
	.e  d
	..s StatCatDR=tmpid
 	e  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"没有设置设备类型: 设备类型="_StatCat)
	if RetStr'="" q RetStr
	
	i EquipCat'=""  d
	.s tmpid=##Class(web.DHCEQImportDataTool).GetEquipCatIDNew(0,EquipCat)
	.i tmpid=""  d 
	..s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"没有找到设备分类: 设备分类="_EquipCat)
	.e  d
	..s EquipCatDR=tmpid
	e  d
	.s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"没有设备分类: 设备分类="_EquipCat)
	if RetStr'="" q RetStr
	
	//s Str=$e(Str,2,$l(Str))
	if Str="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备ID不能为空")
	if RetStr'="" q RetStr
	s Len=$l(Str,",")
	for i=1:1:Len 
	{
		s (rowid,Name,Item,UnitDR,Code)=""
		s rowid=$p(Str,",",i)
		s Name=$p($g(^DHCEQEquip(rowid)),"^",1)
		s Item=$p($g(^DHCEQEquip(rowid)),"^",7)
		s UnitDR=$p($g(^DHCEQEquip(rowid)),"^",5)
		s Code=$p($g(^DHCEQEquip(rowid)),"^",6)
		s ^DHCEQTemp("web.DHCEQAdjustDataEX","AdjsutEQ","Item",EquipType,StatCat,EquipCat,Name)=Code_"^"_UnitDR
		s ^DHCEQTemp("web.DHCEQAdjustDataEX","AdjsutEQ","EQ",rowid)=EquipType_"^"_StatCat_"^"_EquipCat
	}
	Quit RetStr
}

/// Add By JDL 2012-2-9  JDL0115 
/// 根据准备的设备项上的新的分类信息来进行：
/// 		调整分类信息，调整设备项上的分类、设备的分类，
/// 		验收明细对应的分类以及入库明细对应的分类视情况是否更新(为保持一致建议更新)。
/// 	w ##Class(web.DHCEQAdjustDataEX).AdjsutEquipCat(RowStr)
ClassMethod AdjsutEquipCat(ChangeType, RowStr)
{
	i ChangeType="Clear"  d
	.;不操作
	q:ChangeType="Clear" "数据已清:"
	s del="^",RetStr=""
	s RowStr=$tr(RowStr," ","")
	s itemID=$p(RowStr,del,1)
	s itemName=$p(RowStr,del,2)
	s equipType=$p(RowStr,del,3)
	s oldCatCode=$p(RowStr,del,4)
	s oldCatName=$p(RowStr,del,5)
	s newCatCode=$p(RowStr,del,6)
	s newCatName=$p(RowStr,del,7)
	
	if itemID="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"设备项ID不能为空DHC_EQCEquipeCat:")
 	if oldCatCode="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"原分类编码不能为空DHC_EQCEquipeCat:")
 	if newCatCode="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"新分类编码不能为空DHC_EQCEquipeCat:")
 	if RetStr'="" q RetStr
 	s newCatID=""
 	s catid=0
 	for  s catid=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"Code",newCatCode,catid))  quit:catid=""  d
 	.q:$p($g(^DHCEQCCode("DHCEQCEquipeCat",catid)),"^",7)="Y"
 	.s newCatID=catid
 	s oldCatID=$p($g(^DHCEQCCode("DHCEQCMasterItem",itemID)),"^",4)
 	if newCatID="" q ##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"新分类编码不存在DHC_EQCEquipeCat:"_newCatCode)
 	if newCatID=oldCatID q "OK"
 	
 	if ChangeType'="Test" d
 	.&SQL(Update SQLUSER.DHC_EQCMasterItem Set MI_CatDR=:newCatID Where MI_RowID=:itemID)
	.i SQLCODE  s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"更新设备项失败: 设备项="_itemName_" 新分类码="_newCatCode_" SQLCODE="_SQLCODE)
	.q:RetStr'=""
	.&SQL(Update SQLUSER.DHC_EQEquip Set EQ_EquiCatDR=:newCatID Where EQ_ItemDR=:itemID)
	.i SQLCODE&&(SQLCODE'=100)  s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"更新设备台帐失败: 设备项="_itemName_" 新分类码="_newCatCode_" SQLCODE="_SQLCODE)
	.q:RetStr'=""
	.&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_EquiCatDR=:newCatID Where OCL_ItemDR=:itemID)
	.i SQLCODE&&(SQLCODE'=100)  s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"更新验收明细失败: 设备项="_itemName_" 新分类码="_newCatCode_" SQLCODE="_SQLCODE)
	.q:RetStr'=""
	.&SQL(Update SQLUSER.DHC_EQInStockList Set ISL_EquipCatDR=:newCatID Where ISL_ItemDR=:itemID)
	.i SQLCODE&&(SQLCODE'=100)  s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"更新入库明细失败: 设备项="_itemName_" 新分类码="_newCatCode_" SQLCODE="_SQLCODE)
	.q:RetStr'=""
	
 	q:RetStr="" "OK"
	q RetStr
}

/// 2012-3-23 For NY 净值不对,根据最新的台帐里的及快照里的信息更新
/// 		原值也不对？
/// 调整月结的净值
/// 根据设备快照,相关月份折旧分配明细,当前台帐
/// w ##Class(web.DHCEQAdjustDataEX).AdjustReportNetFee("2012-01")
ClassMethod AdjustReportNetFee(MonthStr, vEquipType As %String = "", TestFlag As %String = "1")
{
	n Year,Month,ErrDesc
	n EquipTypeDR,StatCatDR,LocDR,OriginDR,FundsTypeDR
	n SnapID
	n RowID,GblData,OriginalFee,NetFee,DepreTotalFee
	n FundsID,SelfFundsType
	k ^DHCEQTemp("DHCEQAdjustDataEX","AdjustReportNetFee",$j)
		
	s ErrDesc=""
	i MonthStr=""
	{
		s ErrDesc="月结月份不能为空!"
		q ErrDesc
	}
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	i SnapID=""
	{
		s ErrDesc="没有找到相对应的快照!"
		q ErrDesc
	}
		
	
	s Year=+$p(MonthStr,"-",1)
	s Month=+$p(MonthStr,"-",2)
	s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
	
	s RowID=0
	i SnapID=""  d
	.f  s RowID=$o(^DHCEQEquip(RowID))  quit:(RowID="")  d
	..s GblData=^DHCEQEquip(RowID)
	..d AddAdjustReportNetFee
	e  d
	.f  s RowID=$o(^DHCEQSnapShot(SnapID,"Equip",RowID))  quit:(RowID="")  d
	..s GblData=^DHCEQSnapShot(SnapID,"Equip",RowID)
	..d AddAdjustReportNetFee
	
	if (TestFlag=1) q "Test Complete!"
	i vEquipType=""
	{
		&SQL(UPDATE SQLUser.DHC_EQMonthReportList SET MRL_NetFee =(mrl_usedend+mrl_stockend) WHERE MRL_MonthStr =:MonthStr)
	}
	else
	{
		&SQL(UPDATE SQLUser.DHC_EQMonthReportList SET MRL_NetFee =(mrl_usedend+mrl_stockend) WHERE MRL_MonthStr =:MonthStr and MRL_EquipTypeDR=:vEquipType)
	}
	s UpdCount=0
	s SQLCODE=0
	s LocDR=""
	f  s LocDR=$o(^DHCEQTemp("DHCEQAdjustDataEX","AdjustReportNetFee",$j,MonthStr,LocDR)) q:((LocDR="")||(SQLCODE'=0))  d
	.s EquipTypeDR=""
	.f  s EquipTypeDR=$o(^DHCEQTemp("DHCEQAdjustDataEX","AdjustReportNetFee",$j,MonthStr,LocDR,EquipTypeDR)) q:((EquipTypeDR="")||(SQLCODE'=0))  d
	..q:(vEquipType'="")&&(vEquipType'=EquipTypeDR)
	..s StatCatDR=""
	..f  s StatCatDR=$o(^DHCEQTemp("DHCEQAdjustDataEX","AdjustReportNetFee",$j,MonthStr,LocDR,EquipTypeDR,StatCatDR)) q:((StatCatDR="")||(SQLCODE'=0))  d
	...s OriginDR=""
	...f  s OriginDR=$o(^DHCEQTemp("DHCEQAdjustDataEX","AdjustReportNetFee",$j,MonthStr,LocDR,EquipTypeDR,StatCatDR,OriginDR)) q:((OriginDR="")||(SQLCODE'=0))  d
	....s FundsTypeDR=0
	....f  s FundsTypeDR=$o(^DHCEQTemp("DHCEQAdjustDataEX","AdjustReportNetFee",$j,MonthStr,LocDR,EquipTypeDR,StatCatDR,OriginDR,FundsTypeDR)) q:((FundsTypeDR="")||(SQLCODE'=0))  d
	.....s DepreTotalFee=$g(^DHCEQTemp("DHCEQAdjustDataEX","AdjustReportNetFee",$j,MonthStr,LocDR,EquipTypeDR,StatCatDR,OriginDR,FundsTypeDR))
	.....&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_NetFee=(MRL_UsedEnd+MRL_StockEnd-:DepreTotalFee) Where MRL_MonthStr=:MonthStr AND MRL_EquipTypeDR =:EquipTypeDR AND MRL_StatCatDR=:StatCatDR AND MRL_LocDR=:LocDR AND MRL_FundsTypeDR=:FundsTypeDR and  MRL_Origin=:OriginDR)
	.....s UpdCount=UpdCount+1
	
	k ^DHCEQTemp("DHCEQAdjustDataEX","AdjustReportNetFee",$j)
	w "UpdCount:"_UpdCount,!
	q SQLCODE
AddAdjustReportNetFee
	;汇总计算各设备的累计折旧
	;
	///出库状态、无效标志
	s StockStatus=$p(GblData,"^",60)
	;尚未入库的不计入
	q:(StockStatus="0")
	
	s CounterFlag="1"
	;其他退货、报废、无效的，不计入原值、数量，只计入折旧、累计折旧相关数据
	i (StockStatus="3") s CounterFlag="0"
	;过滤掉报废的
	s Status=$p(GblData,"^",38)
	i (Status>"2") s CounterFlag="0"
	;过滤掉无效的
	s InvalidFlag=$p(GblData,"^",59)
	i (InvalidFlag="Y") s CounterFlag="0"
	q:CounterFlag="0"
	
	s EquipTypeDR=$p(GblData,"^",63)
	q:(vEquipType'="")&&(vEquipType'=EquipTypeDR)
	
	s EquipDepreTotal=$p(GblData,"^",35)
	s SumFundsDepre=0
	
	;q:((UseLocDR'="")&&(UseLocDR'=$p(GblData,"^",67)))  ;库房
	;q:(EquipTypeDR="")&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn($p(GblData,"^",63)))	;Mozy0070	2011-12-03
	;q:EquipTypeDR'=3
	;q:RowID'=123052
	
	i EquipTypeDR '=""  s EquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)	
	s StatCatDR=$p(GblData,"^",75)
	i StatCatDR'="" s StatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
	s OriginDR=$p(GblData,"^",20)
	i OriginDR="" s OriginDR=0
	s LocDR=$p(GblData,"^",67)
		
	s LocNode=LocDR
	s StatCatNode=StatCatDR
	s OriginNode=OriginDR
	
	s OriginalFee=+$p(GblData,"^",27)
	;记录有效设备 推算回到当时月份的累计折旧
	s FundsID=0
	f  s FundsID=$o(^DHCEQFunds(0,"Source",1,RowID,FundsID)) q:(FundsID="")  d
	.q:$p(^DHCEQFunds(FundsID),"^",10)="Y"		;F_InvalidFlag
	.q:$p(^DHCEQFunds(FundsID),"^",6)="2"		;F_OperFlag
	.s FundsTypeDR=$p(^DHCEQFunds(FundsID),"^",2)
	.
	.i FundsTypeDR="" s FundsTypeDR=SelfFundsType
	.
	.s DepreTotalFee=$p($g(^DHCEQFunds(FundsID)),"^",13)
	.;i (RowID=100070) w FundsID,!
	.s DepreMonth=MonthStr
	.f  s DepreMonth=$o(^DHCEQMonthDepre(0,"EquipMonth",RowID,DepreMonth)) q:DepreMonth=""  d
	..s MonthDepreID=0
	..f  s MonthDepreID=$o(^DHCEQMonthDepre(0,"EquipMonth",RowID,DepreMonth,MonthDepreID)) q:MonthDepreID=""  d
	...q:$p(^DHCEQMonthDepre(MonthDepreID),"^",3)'="Y"
	...s MDStatus=$p($g(^DHCEQMonthDepre(MonthDepreID)),"^",20)	//DJ0136
	...q:MDStatus="3"
	...;i (RowID=100070) w MonthDepreID,!
	...;折旧分摊
	...s CADRowID=0
	...s CADDepreFee=0
	...f  s CADRowID=$o(^DHCEQCostAllotDetail(0,"SourceID",MonthDepreID,CADRowID)) q:CADRowID=""  d
	....q:(FundsTypeDR'=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",7))
	....s DepreTotalFee=DepreTotalFee-$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",5)
	.
	.i DepreTotalFee<0  d
	..w "Equip="_RowID_" ErrDepreTotal="_DepreTotalFee,!
	..s DepreTotalFee=0
	.s SumFundsDepre=SumFundsDepre+DepreTotalFee
	.s ^DHCEQTemp("DHCEQAdjustDataEX","AdjustReportNetFee",$j,MonthStr,LocNode,EquipTypeDR,StatCatNode,OriginNode,FundsTypeDR)=DepreTotalFee+$g(^DHCEQTemp("DHCEQAdjustDataEX","AdjustReportNetFee",$j,MonthStr,LocNode,EquipTypeDR,StatCatNode,OriginNode,FundsTypeDR))
	
	i EquipDepreTotal>SumFundsDepre  d
	.s FundsTypeDR=SelfFundsType
	.s DepreTotalFee=EquipDepreTotal-SumFundsDepre
	.s ^DHCEQTemp("DHCEQAdjustDataEX","AdjustReportNetFee",$j,MonthStr,LocNode,EquipTypeDR,StatCatNode,OriginNode,FundsTypeDR)=DepreTotalFee+$g(^DHCEQTemp("DHCEQAdjustDataEX","AdjustReportNetFee",$j,MonthStr,LocNode,EquipTypeDR,StatCatNode,OriginNode,FundsTypeDR))
	
	;i (+SumFundsDepre)'=(+EquipDepreTotal) w RowID_"&"_EquipDepreTotal_"&"_SumFundsDepre_"&"_(EquipDepreTotal-SumFundsDepre),!
	q
}

/// 2012-3-23 For NY 调整以下转移明细未计入月结中，据此调整月结相关记录,
/// 注意如果跨年需要修改代码
/// 转移明细：6387,6451,6444,6388,6417,6441,6440,6426,6497
/// w ##Class(web.DHCEQAdjustDataEX).AdjustReportUsedIn("")
ClassMethod AdjustReportUsedIn(SMLRowIDs, Year, Month)
{
	;均为出库记录
	;均为1月份转移
	;均为资金1
	n Len,Error,SMLRowID,SMRowID,AuditDate,EquipID,InStockListID,MoveType
	n FromLocDR,ToLocDR,EquipType,StatCat,Origin
	s SMLRowIDs="6387,6451,6444,6388,6417,6441,6440,6426,6497"
	s Len=$L(SMLRowIDs,",")
	//检测录入设备编号是否存在
	s Error=""
	s SQLCODE=0
	f i=1:1:Len q:(SQLCODE'=0)  d
	.s SMLRowID=$p(SMLRowIDs,",",i)
	.i SMLRowID="" w "第"_i_"个SMLRowID为空!",!
	.q:SMLRowID=""
	.s SMRowID=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",1)
	.i SMRowID="" w "第"_i_"个SMRowID为空!",!
	.q:SMRowID=""
	.q:$p($g(^DHCEQStoreMove(SMRowID)),"^",13)'=2 ;尚未审核
	.
	.s FromLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)
	.s ToLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
	.
	.s EquipID=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
	.s InStockListID=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
	.s Fee=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7)*$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
	.
	.d GetStatOtherInfoA
	.q:EquipType=""
	.q:StatCat=""
	.i Origin="" s Origin=0
	.
	.s MoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)
	.i MoveType=0  d
	..s AuditDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
	..q:AuditDate=""
	..;更新当月出库及库末
	..&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_StockMoveOut=MRL_StockMoveOut+:Fee,MRL_StockEnd=MRL_StockEnd-:Fee  Where MRL_Year=:Year and MRL_Month=:Month AND MRL_EquipTypeDR =:EquipType AND MRL_StatCatDR=:StatCat AND MRL_LocDR=:FromLocDR AND MRL_FundsTypeDR='1' and  MRL_Origin=:Origin)
	..q:SQLCODE'=0
	..;更新后面库初及库末
	..&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_StockEnd=MRL_StockEnd-:Fee,MRL_StockBegin=MRL_StockBegin-:Fee  Where MRL_Year=:Year and MRL_Month>:Month AND MRL_EquipTypeDR =:EquipType AND MRL_StatCatDR=:StatCat AND MRL_LocDR=:FromLocDR AND MRL_FundsTypeDR='1' and  MRL_Origin=:Origin)
	..i SQLCODE=100 s SQLCODE=0
	..q:SQLCODE'=0
	..;更新当月领用及用末
	..&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_UsedIn=MRL_UsedIn+:Fee,MRL_UsedEnd=MRL_UsedEnd+:Fee  Where MRL_Year=:Year and MRL_Month=:Month AND MRL_EquipTypeDR =:EquipType AND MRL_StatCatDR=:StatCat AND MRL_LocDR=:ToLocDR AND MRL_FundsTypeDR='1' and  MRL_Origin=:Origin)
	..q:SQLCODE'=0
	..;更新后面用初及用末
	..&SQL(Update SQLUSER.DHC_EQMonthReportList Set MRL_UsedEnd=MRL_UsedEnd+:Fee,MRL_UsedBegin=MRL_UsedBegin+:Fee  Where MRL_Year=:Year and MRL_Month>:Month AND MRL_EquipTypeDR =:EquipType AND MRL_StatCatDR=:StatCat AND MRL_LocDR=:ToLocDR AND MRL_FundsTypeDR='1' and  MRL_Origin=:Origin)
	..i SQLCODE=100 s SQLCODE=0
	..q:SQLCODE'=0
	..
	.e  d
	..w "尚未处理! SMLRowID="_SMLRowID,!
	..;尚未处理
	
	q SQLCODE
	
GetStatOtherInfoA	;根据InStockListID和EquipID获取信息:StatCat,Origin
	i EquipID'=""  d
	.s Origin=$p($g(^DHCEQEquip(EquipID)),"^",20)
	.s StatCat=$p($g(^DHCEQEquip(EquipID)),"^",75)
	.s EquipType=$p($g(^DHCEQEquip(EquipID)),"^",63)
	e  d
	.s Origin=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(InStockListID)),"^",1))),"^",15)
	.s StatCat= ##class(web.DHCEQStoreMoveNew).GetEquipTypeByInStockList(InStockListID)
	.s EquipType=$Piece(StatCat,"^",1)
	.s StatCat=$Piece(StatCat,"^",2)
	q
}

/// Add by JDL 2012-3-27 JDL0127
/// 调整报表数据，错误将报废数据计入到报废申请科室中
/// 应该计入到设备报废时所在的库房
/// w ##Class(web.DHCEQAdjustDataEX).AdjustReportDisuse("2012-01",11)
ClassMethod AdjustReportDisuse(MonthStr, EquipTypeDR As %Library.String = "", FundsTypeDR As %String = "")
{
	s User=1
	s Year=+$p(MonthStr,"-",1)
	s Month=+$p(MonthStr,"-",2)
	s StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	s EndDate=$p(StartDate,"^",2)
	s StartDate=$p(StartDate,"^",1)
	
	;将之前的报废 修正报废记录在申请科室下 ，1恢复
	s Loc=0
	f  s Loc=$o(^DHCEQMonthReportList(0,"Loc",Year,Month,Loc)) q:Loc=""  d
	.;q:((LocDR'="")&&(LocDR'=Loc))
	.s (StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount)=0
	.s StatCat=0
	.f  s StatCat=$o(^DHCEQCCode("DHCEQCStatCat",StatCat)) q:StatCat=""  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQMonthReportList(0,"Loc",Year,Month,Loc,StatCat,rowid)) q:rowid=""  d
	...s listInfo=$g(^DHCEQMonthReportList(rowid))
	...s EquipType=$p(listInfo,"^",27)
	...q:(EquipTypeDR'="")&&(EquipTypeDR'=EquipType)
	...s Origin =$p(listInfo,"^",26)
	...s FundsType=$p(listInfo,"^",38)
	...s Disused=+$p(listInfo,"^",18)
	...s StockDisused=+$p(listInfo,"^",30)
	...i Disused>0  d
	....&SQL(Update SQLUser.DHC_EQMonthReportList Set MRL_Disused=0,MRL_UsedEnd=MRL_UsedEnd+:Disused where MRL_RowID=:rowid)
	....i SQLCODE w SQLCODE,!
	....&SQL(Update SQLUser.DHC_EQMonthReportList Set MRL_UsedBegin=MRL_UsedBegin+:Disused,MRL_UsedEnd=MRL_UsedEnd+:Disused where  MRL_Year=:Year And MRL_Month>:Month AND MRL_EquipTypeDR =:EquipType AND MRL_StatCatDR=:StatCat AND MRL_LocDR=:Loc AND MRL_FundsTypeDR=:FundsType and  MRL_Origin=:Origin)
	....i SQLCODE<0 w SQLCODE,!
	...i StockDisused>0  d
	....&SQL(Update SQLUser.DHC_EQMonthReportList Set MRL_StockDisused=0,MRL_StockEnd=MRL_StockEnd+:StockDisused where MRL_RowID=:rowid)
	....i SQLCODE w SQLCODE,!
	....&SQL(Update SQLUser.DHC_EQMonthReportList Set MRL_StockBegin=MRL_StockBegin+:StockDisused,MRL_StockEnd=MRL_StockEnd+:StockDisused where  MRL_Year=:Year And MRL_Month>:Month AND MRL_EquipTypeDR =:EquipType AND MRL_StatCatDR=:StatCat AND MRL_LocDR=:Loc AND MRL_FundsTypeDR=:FundsType and  MRL_Origin=:Origin)
	....i SQLCODE<0 w SQLCODE,!
	
	;重新计算报废，然后更新相应月结数据
	new PreYear,PreMonth,Loc,StatCat,BillDate,type,tmpfee,StoreLoc,listInfo
 	new StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd
 	new ChangeAccount,Origin,EquipType
 	;折旧总额,当月折旧,在库报废,库房转移(入),库房转移(出)
 	new TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut
 	new StockStatus,MonthDepreID,MonthStr
 	new ListRowID,OutType,OutTypeCode,EquipID,InStockListID
 	new NetFee
 	
 	;Add by JDL 2011-6-22 JDL0086
 	new StockChangeAccount,UsedReduce,StockOther,UsedOther
 	new AdjustType
 	
 	;Add by JDL 2011-12-28 JDL0107
 	new FundsType,SelfFundsType,FundsID,RemainOriginalFee,RemainDepreTotal,RemainNetFee,FundsFee
 	new SourceType,SourceID
 	s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
	
	k ^DHCEQTemp("MonthReport","List",User,$J,Year,Month)
	;s ^DHCEQTemp("jdl")=User_","_ Year_","_ Month_","_ StartDate_","_ EndDate_","_ EquipTypeIDs_","_ FundsTypeDR	
	if (Month=1)
	{	s PreYear=Year-1
		s PreMonth=12}
	else
	{	s PreYear=Year
		s PreMonth=Month-1}	

	;重新汇总报废的信息
	s SourceType="6"
	//汇总当期设备报废信息
	s EquipType=0
	f  s EquipType=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType)) q:EquipType=""  d
	.s BillDate=StartDate-1
	.f  s BillDate=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate,rowid)) q:((rowid=""))  d
	...q:$p($g(^DHCEQDisuseRequest(rowid)),"^",10)'=2
	...s ListRowID=0
	...s StoreLoc=$p($g(^DHCEQDisuseRequest(rowid)),"^",34)
	...f  s ListRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",rowid,ListRowID)) q:(ListRowID="")  d
	....d InitStatInfoVariant
	....s EquipID=$p($g(^DHCEQDisuseRequestList(ListRowID)),"^",2)
	....d GetStatOtherInfo
	....
	....s SourceID=ListRowID
	....s RemainOriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
	....d SplitFunds
	
	;重新更新月结数据中的报废及相关期初期末
	s EquipType=0
	f  s EquipType=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType)) q:EquipType=""  d
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=EquipType)
	.s Loc=0
	.f  s Loc=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc)) q:Loc=""  d
	..s StatCat=0
	..f  s StatCat=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat)) q:StatCat=""  d
	...s Origin=""
	...f  s Origin=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin)) q:Origin=""  d
	....s FundsType=""
	....f  s FundsType=$o(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType)) q:FundsType=""  d
	.....s listInfo=$g(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,Loc,StatCat,Origin,FundsType))
	.....
	.....s Disused=+$p(listInfo,"^",13)
	.....s StockDisused=+$p(listInfo,"^",18)
	.....
	.....i Disused>0  d
	......&SQL(Update SQLUser.DHC_EQMonthReportList Set MRL_Disused=:Disused,MRL_UsedEnd=MRL_UsedEnd-:Disused where MRL_Year=:Year And MRL_Month=:Month AND MRL_EquipTypeDR =:EquipType AND MRL_StatCatDR=:StatCat AND MRL_LocDR=:Loc AND MRL_FundsTypeDR=:FundsType and  MRL_Origin=:Origin)
	......i SQLCODE w SQLCODE,!
	......&SQL(Update SQLUser.DHC_EQMonthReportList Set MRL_UsedBegin=MRL_UsedBegin-:Disused,MRL_UsedEnd=MRL_UsedEnd-:Disused where MRL_Year=:Year And MRL_Month>:Month AND MRL_EquipTypeDR =:EquipType AND MRL_StatCatDR=:StatCat AND MRL_LocDR=:Loc AND MRL_FundsTypeDR=:FundsType and  MRL_Origin=:Origin)
	......i SQLCODE<0 w SQLCODE,!
	.....i StockDisused>0  d
	......&SQL(Update SQLUser.DHC_EQMonthReportList Set MRL_StockDisused=:StockDisused,MRL_StockEnd=MRL_StockEnd-:StockDisused where  MRL_Year=:Year And MRL_Month=:Month AND MRL_EquipTypeDR =:EquipType AND MRL_StatCatDR=:StatCat AND MRL_LocDR=:Loc AND MRL_FundsTypeDR=:FundsType and  MRL_Origin=:Origin)
	......i SQLCODE w SQLCODE,!
	......&SQL(Update SQLUser.DHC_EQMonthReportList Set MRL_StockBegin=MRL_StockBegin-:StockDisused,MRL_StockEnd=MRL_StockEnd-:StockDisused where  MRL_Year=:Year And MRL_Month>:Month AND MRL_EquipTypeDR =:EquipType AND MRL_StatCatDR=:StatCat AND MRL_LocDR=:Loc AND MRL_FundsTypeDR=:FundsType and  MRL_Origin=:Origin)
	......i SQLCODE<0 w SQLCODE,!
	
	q "finish!"
AddStatListInfoNew
	;Modified by jdl 2011-3-31 jdl0076
	s (StockBegin,UsedBegin)=0
	
	i FundsType="" s FundsType=SelfFundsType
	i FundsType="" s FundsType=0
	
	i Origin="" s Origin=0
	s listInfo=$g(^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,StoreLoc,StatCat,Origin,FundsType))
	s StockEnd=StockBegin+StockIn-StockMoveOut-StockReturn-StockReduce+StockMoveIn
	;增加 库房转移(入),库房转移(出)
	s StockEnd=StockEnd+StoreMoveIn-StoreMoveOut
	s UsedEnd=UsedBegin+UsedIn-UsedReturn+UsedMoveIn-UsedMoveOut-Disused+ChangeAccount
	
	;Add by JDL 2011-6-22 JDL0086
	s StockEnd=StockEnd-StockDisused+StockChangeAccount+StockOther
	s UsedEnd=UsedEnd-UsedReduce+UsedOther
	
	;b //AddStatListInfoNew
	if listInfo=""
	{
		s TotalDepre=0
		s preRowId=0
		f  s preRowId=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,PreYear,PreMonth,StatCat,StoreLoc,preRowId)) q:preRowId=""  d
		.q:(Origin'=$p($g(^DHCEQMonthReportList(preRowId)),"^",26))
		.q:(EquipType'=$p($g(^DHCEQMonthReportList(preRowId)),"^",27))
		.q:(FundsType'=$p($g(^DHCEQMonthReportList(preRowId)),"^",38))
		.s StockBegin=+StockBegin+$p($g(^DHCEQMonthReportList(preRowId)),"^",12)	///在库 上月期末为本月期初
		.s UsedBegin=+UsedBegin+$p($g(^DHCEQMonthReportList(preRowId)),"^",19)	///在用 上月期末为本月期初
		.s StockEnd=+StockEnd+StockBegin
		.s UsedEnd=+UsedEnd+UsedBegin
		.;累计折旧取上期累计折旧+本期折旧
		.s TotalDepre=+$p($g(^DHCEQMonthReportList(preRowId)),"^",28)
		s TotalDepre=+Depre+TotalDepre
		;Modified by JDL 2011-6-22 JDL0086
		s listInfo=StockBegin_"^"_StockIn_"^"_StockReturn_"^"_StockReduce_"^"_StockMoveOut_"^"_StockMoveIn_"^"_StockEnd_"^"_UsedBegin_"^"_UsedIn_"^"_UsedReturn_"^"_UsedMoveIn_"^"_UsedMoveOut_"^"_Disused_"^"_UsedEnd_"^"_ChangeAccount_"^"_TotalDepre_"^"_Depre_"^"_StockDisused_"^"_StoreMoveIn_"^"_StoreMoveOut_"^"_NetFee_"^"_StockChangeAccount_"^"_UsedReduce_"^"_StockOther_"^"_UsedOther
		
	}
	else
	{
		s $p(listInfo,"^",1)=+$p(listInfo,"^",1)+StockBegin
		s $p(listInfo,"^",2)=+$p(listInfo,"^",2)+StockIn
		s $p(listInfo,"^",3)=+$p(listInfo,"^",3)+StockReturn
		s $p(listInfo,"^",4)=+$p(listInfo,"^",4)+StockReduce
		s $p(listInfo,"^",5)=+$p(listInfo,"^",5)+StockMoveOut
		s $p(listInfo,"^",6)=+$p(listInfo,"^",6)+StockMoveIn
		s $p(listInfo,"^",7)=+$p(listInfo,"^",7)+StockEnd
		
		s $p(listInfo,"^",8)=+$p(listInfo,"^",8)+UsedBegin
		s $p(listInfo,"^",9)=+$p(listInfo,"^",9)+UsedIn
		s $p(listInfo,"^",10)=+$p(listInfo,"^",10)+UsedReturn
		s $p(listInfo,"^",11)=+$p(listInfo,"^",11)+UsedMoveIn
		s $p(listInfo,"^",12)=+$p(listInfo,"^",12)+UsedMoveOut
		s $p(listInfo,"^",13)=+$p(listInfo,"^",13)+Disused
		s $p(listInfo,"^",14)=+$p(listInfo,"^",14)+UsedEnd
		
		s $p(listInfo,"^",15)=+$p(listInfo,"^",15)+ChangeAccount
		
		;增加 库房转移(入),库房转移(出)
		s $p(listInfo,"^",16)=+$p(listInfo,"^",16)+Depre		;TotalDepre
		s $p(listInfo,"^",17)=+$p(listInfo,"^",17)+Depre
		s $p(listInfo,"^",18)=+$p(listInfo,"^",18)+StockDisused
		s $p(listInfo,"^",19)=+$p(listInfo,"^",19)+StoreMoveIn
		s $p(listInfo,"^",20)=+$p(listInfo,"^",20)+StoreMoveOut
		s $p(listInfo,"^",21)=+$p(listInfo,"^",21)+NetFee
		
		;Add by JDL 2011-6-22 JDL0086
		s $p(listInfo,"^",22)=+$p(listInfo,"^",22)+StockChangeAccount
		s $p(listInfo,"^",23)=+$p(listInfo,"^",23)+UsedReduce
		s $p(listInfo,"^",24)=+$p(listInfo,"^",24)+StockOther
		s $p(listInfo,"^",25)=+$p(listInfo,"^",25)+UsedOther		
	}
	s ^DHCEQTemp("MonthReport","List",User,$J,Year,Month,EquipType,StoreLoc,StatCat,Origin,FundsType)=listInfo
	quit
InitStatInfoVariant
	s (StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,TotalEnd,ChangeAccount)=0
	s (TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut)=0	
	s NetFee=0
	;Add by JDL 2011-6-22 JDL0086
	s (StockChangeAccount,UsedReduce,StockOther,UsedOther)=0
	
	s (RemainOriginalFee,RemainDepreTotal,RemainNetFee,FundsFee)=0
	q
GetStatOtherInfo	;根据InStockListID和EquipID获取信息:StatCat,Origin
	i EquipID'=""  d
	.s Origin=$p($g(^DHCEQEquip(EquipID)),"^",20)
	.s StatCat=$p($g(^DHCEQEquip(EquipID)),"^",75)
	e  d
	.s Origin=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(InStockListID)),"^",1))),"^",15)
	.;Mozy0077	2012-2-21	从设备表中获取设备类型
	.Set StatCat= ##class(web.DHCEQStoreMoveNew).GetEquipTypeByInStockList(InStockListID)
	.If StatCat'="" Do
	..Set StatCat=$Piece(StatCat,"^",2)
	.Else  Do
	..s StatCat=$p($g(^DHCEQInStockList(InStockListID)),"^",17)
	..i StatCat="" s StatCat=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(InStockListID)),"^",1))),"^",21)
	q
SplitFunds
	s FundsID=0
	f  s FundsID=$o(^DHCEQFunds(0,"Source",SourceType,SourceID,FundsID)) q:(FundsID="")  d
	.q:$p(^DHCEQFunds(FundsID),"^",10)="Y"		;F_InvalidFlag
	.q:$p(^DHCEQFunds(FundsID),"^",6)="2"		;F_OperFlag
	.s FundsType=$p(^DHCEQFunds(FundsID),"^",2)
	.i FundsType="" s FundsType=SelfFundsType
	.s FundsFee=+$p($g(^DHCEQFunds(FundsID)),"^",3)
	.
	.s RemainOriginalFee=RemainOriginalFee-FundsFee
	.;根据设备获取 净值等信息
	.i SourceType="1"  d
	..s DepreTotal=$p($g(^DHCEQFunds(FundsID)),"^",13)
	..s RemainDepreTotal=RemainDepreTotal-DepreTotal
	..s NetFee=FundsFee-DepreTotal
	..;Modified by JDL 2012-1-17 JDL0112 修改调账相关程序 净值不能小于0
	..i NetFee<0 s NetFee=0
	..s RemainNetFee=RemainNetFee-NetFee
	.d AddFundsInfo

	;如果有剩余金额,则记在系统参数设置中的默认 资金来源中
	i RemainOriginalFee'=0  d
	.s FundsType=SelfFundsType
	.s FundsFee=RemainOriginalFee
	.i SourceType="1"  d
	..s NetFee=RemainNetFee
	..s DepreTotal=RemainDepreTotal
	.;Modified By JDL 2012-3-22 JDL0126 调整数据时,要根据情况处理累计折旧
	.i SourceType="9"  d
	..s DepreTotal=RemainDepreTotal
	.d AddFundsInfo
	
	q
AddFundsInfo
	i SourceType="1"  d
	.;获取当前的净值信息   原值(根据期初和变动计算)、累计折旧(上期累计+本期折旧)
	.
	else  if SourceType="3"  d
	.;当期入库金额
	.s StockIn=FundsFee
	else  if SourceType="4"  d
	.;当期转移
	.;0:库房分配|1:科室间调配|2:报废转废品库|3:科室退库|4:库房转移
	.if $p($g(^DHCEQStoreMove(rowid)),"^",12)="0"  d
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	..s StockMoveOut=FundsFee
	..s UsedIn=0
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	..s StockMoveOut=0
	..s UsedIn=FundsFee
	.e  i $p($g(^DHCEQStoreMove(rowid)),"^",12)="1"  d
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	..s UsedMoveOut=FundsFee
	..s UsedMoveIn=0
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	..s UsedMoveOut=0
	..s UsedMoveIn=FundsFee
	.e  i $p($g(^DHCEQStoreMove(rowid)),"^",12)="3"  d
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	..s UsedReturn=FundsFee
	..s StockMoveIn=0
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	..s UsedReturn=0
	..s StockMoveIn=FundsFee
	.e  i $p($g(^DHCEQStoreMove(rowid)),"^",12)="4"  d
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	..s StoreMoveIn=0
	..s StoreMoveOut=FundsFee
	..d AddStatListInfoNew
	..s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",3)
	..s StoreMoveIn=FundsFee
	..s StoreMoveOut=0
	else  if SourceType="5"  d
	.;当期退货及减少
	.i OutTypeCode="TH" d
	..s StockReturn=FundsFee	;退货费用
	.e  d
	..;根据减少单是否有使用科室,来区分是在库减少、在用减少
	..i $p($g(^DHCEQReturn(rowid)),"^",24)="" d
	...s StockReduce=FundsFee	;其他减少费用
	..e  d
	...s StoreLoc=$p($g(^DHCEQReturn(rowid)),"^",24)
	...s UsedReduce=FundsFee	;其他减少费用
	else  if SourceType="6"  d
	.;当期报废的
	.;Hold1区分在库的和在用的
	.i $p($g(^DHCEQDisuseRequestList(ListRowID)),"^",11)="1"  d
	..s Disused=FundsFee
	.e  d
	..s StockDisused=FundsFee	;报废为在库的
	else  if SourceType="7"  d
	.;当期调账的
	.;Hold1区分在库的和在用的调账
	.i ($p($g(^DHCEQChangeAccount(rowid)),"^",32)="1")||($p($g(^DHCEQChangeAccount(rowid)),"^",32)="")  d
	..s ChangeAccount=FundsFee
	.e  d
	..s StockChangeAccount=FundsFee
	.s StoreLoc=$p($g(^DHCEQChangeAccount(rowid)),"^",28)
	else  if SourceType="9"  d
	.;Modified By JDL 2012-3-22 JDL0126 调整数据时,要根据情况处理原值及累计折旧
	.;当期后台调整的数据
	.;1:调整数据 2:新增数据 3:删除数据 4.取消报废 9.其他调整
	.;从From减少数据
	.i (AdjustType="1")||(AdjustType="3")  d
	..s EquipType=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",4)  //2012-02-01 DJ0103
	..s StoreLoc=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",3) //2012-02-01 DJ0103
	..s StatCat=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",5)
	..s Origin=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",6)
	..;调整数据 累计折旧减少
	..s DepreTotal=-DepreTotal
	..i (AdjustType="3") s DepreTotal=0
	..i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)="1"  d
	...s UsedOther=-FundsFee
	...s StockOther=0
	..e  d
	...s UsedOther=0
	...s StockOther=-FundsFee
	..d AddStatListInfoNew
	.;从To增加数据
	.i (AdjustType="1")||(AdjustType="2")||(AdjustType="4")  d
	..s EquipType=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",9) //2012-02-01 DJ0103
	..s StoreLoc=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",8) //2012-02-01 DJ0103
	..s StatCat=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",10)
	..s Origin=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",11)
	..i (AdjustType="4") s DepreTotal=0
	..i $p($g(^DHCEQAdjustDataList(ListRowID)),"^",13)="1"  d
	...s UsedOther=FundsFee
	...s StockOther=0
	..e  d
	...s UsedOther=0
	...s StockOther=FundsFee
	..d AddStatListInfoNew
	s DepreTotal=0
	if SourceType'="9" d AddStatListInfoNew
	q
}

}
