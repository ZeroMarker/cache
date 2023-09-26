Import SQLUser

/// 修改人： Mozy 2011-01-19
/// 描述:设备供应商应标记录
Class web.DHCEQIFBList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Mozy	2011-1-19
/// 招标包查询
/// Code As %String = "", Desc As %String = ""
/// d ##class(%ResultSet).RunQuery("web.DHCEQIFBList","IFBListDetail","2","1")
Query IFBListDetail(SourceType As %String = "", SourceID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TVendorDR:%String,TVendor:%String,TManuFactoryDR:%String,TManuFactory:%String,TModelDR:%String,TModel:%String,TBrandDR:%String,TBrand:%String,TArg:%String,TPrice:%String,TAmount:%String,TWinFlag:%String,TWinQty:%String,TCandidacy:%String,TCandidacySeq:%String,TScore:%String,TRemark:%String,TRow:%String,TProviderHandler:%String,TProviderTel:%String,TConfigure:%String,TFeatures:%String,TDealPrice:%String,TMaterialAndPrice:%String,TQuanlity:%String,TGuaranteePeriodNum:%String,TArriveNum:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod IFBListDetailExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	i (SourceType="")||(SourceID="")  Quit $$$OK
	s SetRowIDFlag=0	//通过招标、计划、申请的顺序往前找，如果是找的数据，那么输出的时候就rowid就是空，当前的业务需要重新保存一份数据
	if '$Data(^DHCEQIFBList(0,"Source",SourceType,SourceID))
	{
		if SourceType=3
		{
			s ExtendType=$Piece($Get(^DHCEQIFBBag(SourceID)),"^",9)
			s ExtendID=$Piece($Get(^DHCEQIFBBag(SourceID)),"^",10)
			//"0":"设备项","1":"采购申请","2":"采购计划",:"")
			i ExtendType=0 d
			.//
			e  i ExtendType=1 d
			.s SourceType=1
			.s SourceID=ExtendID
			e  i ExtendType=2 d
			.s SourceType=2
			.s SourceID=ExtendID
			s SetRowIDFlag=1
		}
		if '$Data(^DHCEQIFBList(0,"Source",SourceType,SourceID))
		{
			if SourceType=2
			{
				s SourceType=1
				s SourceID=$Piece($Get(^DHCEQBuyPlanList(SourceID)),"^",10)
				s SetRowIDFlag=1
			}
		}
	}
	i (SourceType="")||(SourceID="")  Quit $$$OK
	if '$Data(^DHCEQIFBList(0,"Source",SourceType,SourceID)) Quit $$$OK
	s rowid=0
	For  Set rowid=$Order(^DHCEQIFBList(0,"Source",SourceType,SourceID,rowid))  Quit:rowid=""  Do
	.s DataList=$Get(^DHCEQIFBList(rowid))
	.s TRowID = rowid
	.i SetRowIDFlag=1 s TRowID=""
	.s TVendor=$Piece(DataList,"^",3)
	.s TVendorDR=$Piece(DataList,"^",4)
	.s TManuFactory=$Piece(DataList,"^",5)
	.s TManuFactoryDR=$Piece(DataList,"^",6)
	.s TModelDR=$Piece(DataList,"^",7)
	.s TModel=$Piece(DataList,"^",8)
	.s TBrand=$Piece(DataList,"^",9)
	.s TBrandDR=$Piece(DataList,"^",10)
	.Set TArg	=	$Piece(DataList,"^",11)
	.Set TPrice	=	$Piece(DataList,"^",12)
	.Set TAmount	=	$Piece(DataList,"^",13)
	.Set TWinFlag	=	$Piece(DataList,"^",14)
	.If TWinFlag'="" Set TWinFlag=##Class(web.DHCEQCommon).TransValueToPage(TWinFlag,"bool")
	.Set TWinQty	=	$Piece(DataList,"^",15)
	.Set TCandidacy	=	$Piece(DataList,"^",16)
	.Set TCandidacySeq	=	$Piece(DataList,"^",17)
	.Set TScore	=	$Piece(DataList,"^",18)
	.Set TRemark	=	$Piece(DataList,"^",19)
	.;add by csy 2017-07-25 设备供应商应标记录扩展
	.Set TProviderHandler	=	$Piece(DataList,"^",20)
	.Set TProviderTel	=	$Piece(DataList,"^",21)
	.Set TConfigure	=	$Piece(DataList,"^",22)
	.Set TFeatures	=	$Piece(DataList,"^",23)
	.Set TDealPrice	=	$Piece(DataList,"^",24)
	.Set TMaterialAndPrice	=	$Piece(DataList,"^",25)
	.Set TQuanlity	=	$Piece(DataList,"^",26)
	.Set TGuaranteePeriodNum	=	$Piece(DataList,"^",27)
	.Set TArriveNum	=	$Piece(DataList,"^",28)
	.Set THold1	=	$Piece(DataList,"^",29)
	.Set THold2	=	$Piece(DataList,"^",30)
	.Set THold3	=	$Piece(DataList,"^",31)
	.Set THold4	=	$Piece(DataList,"^",32)
	.Set THold5	=	$Piece(DataList,"^",33)
	.
	.Do OutputRowIFBListDetail
	Quit $$$OK
OutputRowIFBListDetail
	Set TRow=index	// 20150914  Mozy0165 序号
	Set Data=$lb(TRowID,TVendorDR,TVendor,TManuFactoryDR,TManuFactory,TModelDR,TModel,TBrandDR,TBrand,TArg,TPrice,TAmount,TWinFlag,TWinQty,TCandidacy,TCandidacySeq,TScore,TRemark,TRow,TProviderHandler,TProviderTel,TConfigure,TFeatures,TDealPrice,TMaterialAndPrice,TQuanlity,TGuaranteePeriodNum,TArriveNum,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod IFBListDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IFBListDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod IFBListDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IFBListDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SaveData(val, ElementID, TemplateID)
{
    Set $ZT="ERROR" //2009-08-10 党军
	TSTART //2009-08-10 党军
    s length=$l(val,"&")
	f i=1:1:length  d
	.s OneList=$p(val,"&",i)
	.s SQLCODE=##Class(web.DHCEQIFBList).SaveDataList(OneList,0)
	.q:SQLCODE'=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	if (ElementID'="")&&(TemplateID'="")
	{
		s tmp=""
		&SQL(select TL_RowID into :tmp from sqluser.DHC_EQTemplateList where TL_TemplateDR=:TemplateID and TL_ElementDR=:ElementID)
		i tmp'="" 
		{
			&SQL(update sqluser.DHC_EQTemplateList set TL_Result=:length where TL_RowID=:tmp)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
	}
	TCOMMIT
    q SQLCODE_"^"_length
ERROR 
	Set ErrorMsg=$ZE	          
	TROLLBACK		      
	Quit "<ERROR>"_ErrorMsg
}

/// w ##class(web.DHCEQIFBList).SaveData("2^^^","0")
ClassMethod SaveDataList(val As %Library.String = "", OperateType As %Library.String = "")
{
	Kill PLIST,LIST,rowid
	Set rowid=$Piece(val,"^",1)
	If (+OperateType=1)
	{
	 	&SQL(delete from sqluser.DHC_EQIFBList where IFBL_RowID=:rowid)
	 	Quit SQLCODE
 	}
 	If (+OperateType=0) //新增,更新
 	{
	 	Set IFBLRowID=rowid
	 	Set PLIST(2)=	$Piece(val,"^",2)	//	IFBL_SourceType
		Set PLIST(3)=	$Piece(val,"^",3)	//	IFBL_SourceID	
		Set PLIST(4)=	$Piece(val,"^",4)	//	IFBL_Vendor
		Set PLIST(5)=	$Piece(val,"^",5)	//	IFBL_VendorDR	
	 	Set PLIST(6)=	$Piece(val,"^",6)	//	IFBL_ManuFactory
		Set PLIST(7)=	$Piece(val,"^",7)	//	IFBL_ManuFactoryDR
		Set PLIST(8)=	$Piece(val,"^",8)	//	IFBL_Model
		Set PLIST(9)=	$Piece(val,"^",9)	//	IFBL_ModelDR
		Set PLIST(10)=	$Piece(val,"^",10)	//	IFBL_Brand
		Set PLIST(11)=	$Piece(val,"^",11)	//	IFBL_BrandDR
		
		Set PLIST(12)=	$Piece(val,"^",12)	//	IFBL_Arg	6
		Set PLIST(13)=	$Piece(val,"^",13)	//	IFBL_Price	7
		Set PLIST(14)=	$Piece(val,"^",14)	//	IFBL_Amount	8
		Set PLIST(15)=##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",15),"bool")		//	IFBL_WinFlag	9
		Set PLIST(16)=	$Piece(val,"^",16)	//	IFBL_WinQty	10
		
		///i (PLIST(2)'="")&(PLIST(15)="Y")  Set PLIST(10)=	$Piece($Get(^DHCEQIFBBag(PLIST(2))),"^",5)
		
		Set PLIST(17)=	$Piece(val,"^",17)	//	IFBL_Candidacy	11
		Set PLIST(18)=	$Piece(val,"^",18)	//	IFBL_CandidacySeq	12
		Set PLIST(19)=	$Piece(val,"^",19)	//	IFBL_Score	13
		Set PLIST(20)=	$Piece(val,"^",20)	//	IFBL_Remark	14
		// add by csy 2017-07-25 begin 设备供应商应标记扩展
		Set PLIST(21)=	$Piece(val,"^",21)	//	
		Set PLIST(22)=	$Piece(val,"^",22)	//	
		Set PLIST(23)=	$Piece(val,"^",23)	//	
		Set PLIST(24)=	$Piece(val,"^",24)	//	
		Set PLIST(25)=	$Piece(val,"^",25)	//
		Set PLIST(26)=	$Piece(val,"^",26)	//	
		Set PLIST(27)=	$Piece(val,"^",27)	//	
		Set PLIST(28)=	$Piece(val,"^",28)	//	
		Set PLIST(29)=	$Piece(val,"^",29)	//	
		// add by csy 2017-07-25 end 设备供应商应标记录扩展
		Set PLIST(30)=	$Piece(val,"^",30)	//	IFBL_Hold1	24 品牌
		Set PLIST(31)=	$Piece(val,"^",31)	//	IFBL_Hold2	25	PlanListDR
		Set PLIST(32)=	$Piece(val,"^",32)	//	IFBL_Hold3	26
		Set PLIST(33)=	$Piece(val,"^",33)	//	IFBL_Hold4	27
		Set PLIST(34)=	$Piece(val,"^",34)	//	IFBL_Hold5	28
		//Quit:(..CheckWinFlag(PLIST(2),IFBLRowID,PLIST(9))'=0) -1
	 	If (rowid="")  //新增按钮操作
	 	{
		 	&SQL(Insert Into SQLUSER.DHC_EQIFBList Values :PLIST())
	 	}
	 	Else  //更新按钮操作
	 	{
			&SQL(Update SQLUSER.DHC_EQIFBList Values :PLIST() where IFBL_RowID = :IFBLRowID)
	 	}
	 	i SQLCODE=100 s SQLCODE=0
	 	Quit SQLCODE
 	}
}

/// w ##class(web.DHCEQIFBList).GetIFBListByID(1)
ClassMethod GetIFBListByID(rowid As %Library.String = "")
{
	Quit:rowid="" ""
	new result,resultex
	Set result= $Get(^DHCEQIFBList(rowid))
	Set resultex=""
	
	Set resultex=resultex_"^"	;IFBBagDR	1
	If $Piece(result,"^",1)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQIFBBag($Piece(result,"^",1))),"^",2)
	Set resultex=resultex_"^"	;VendorDR	2
	If $Piece(result,"^",2)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece(result,"^",2))
	Set resultex=resultex_"^"	;ManuFactoryDR	3
	If $Piece(result,"^",3)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",$Piece(result,"^",3))),"^",1)
	Set resultex=resultex_"^"	;ModelDR	4
	If $Piece(result,"^",4)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCModel",$Piece(result,"^",4))),"^",2)
	If $Piece(result,"^",8)'="" Set $Piece(result,"^",8)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",8),"bool")
	;add by csy 2017-07-25 暂时用Hold1存品牌
	Set resultex=resultex_"^"	;Hold1	23
	If $Piece(result,"^",23)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCBrand",$Piece(result,"^",23))),"^",3)
	Set result=##class(web.DHCEQCommon).Replace(result_resultex,$C(13,10),"\n") //回车符转换为"\n"
	
	Quit rowid_"^"_result
}

/// 检测其他中标单位
/// 返回其他中标单位数量
/// w ##class(web.DHCEQIFBList).CheckWinFlag(1,3,"Y")
ClassMethod CheckWinFlag(IFBBagDR As %Library.String = "", IFBLRowID As %Library.String = "", WinFlag As %Library.String = "")
{
	Quit:WinFlag'="Y" 0
	New flag,id
	Set flag=0
	Set id=0
	For  Set id=$Order(^DHCEQIFBList(0,"IFBBag",IFBBagDR,id))  Quit:id=""  Do
	.Set WinFlag=$Piece($Get(^DHCEQIFBList(id)),"^",8)
	.If (WinFlag="Y")&&(IFBLRowID'=id) Set flag=flag+1
	.
	
	Quit flag
}

/*
/// 检测其他中标单位
/// 返回其他中标单位数量
/// w ##class(web.DHCEQIFBList).VendorListSaveData("^^供应商1^^品牌001^123^1234^2")
ClassMethod VendorListSaveData(val As %Library.String = "")
{
	s flag=""
	s Len=$l(val,"&")
	for i=1:1:Len
	{
		q:flag'=""
		s VendorList=$p(val,"&",i)
		s VendorDR=$p(VendorList,"^",2)
        s VendorDesc=$p(VendorList,"^",3)
        s BrandDR=$p(VendorList,"^",4)
        s BrandDesc=$p(VendorList,"^",5)
        i VendorDR=""  d
        .&SQL(select V_RowID into :VRowid from DHC_EQCVendor where V_Name=:VendorDesc and V_InvalidFlag='N')
		.if VRowid="" d
		..s VendorCode=##class(web.DHCEQCHanZiEncoding).GetEncoding(VendorDesc,4,"","U")
		..s VList="^"_VendorCode_"^"_VendorDesc_"^^^^^^"_$p(VendorList,"^",6)_"^"_$p(VendorList,"^",7)
		..s VResult=##class(web.DHCEQCVendor).SaveData(VList)
		..if SQLCODE<0  d
		...s flag=SQLCODE_"^供应商保存失败" 
		..e  d
		...s $p(VendorList,"^",2)=VResult 
		.e  d
		..s $p(VendorList,"^",2)=VRowid
        .if SQLCODE  s flag=SQLCODE_"^供应商保存失败" 
        i BrandDR=""  d
		.&SQL(select B_RowID into :BRowid from DHC_EQCBrand where B_Desc=:BrandDesc and B_InvalidFlag='N')
		.if BRowid=""  d
		..s BrandCode=##class(web.DHCEQCHanZiEncoding).GetEncoding(BrandDesc,4,"","U")
		..s BList="^"_BrandCode_"^"_BrandDesc
		..s BResult=##class(web.DHCEQCBrand).SaveData("","",BList)
        ..if SQLCODE<0  d
		...s flag=SQLCODE_"^品牌保存失败" 
		..e  d
		...s $p(VendorList,"^",4)=BResult 
		.e  d
		..s $p(VendorList,"^",4)=BRowid
        s IFBList=$p(VendorList,"^",1)_"^^"_$p(VendorList,"^",2)_"^^^^^^^^^^^^"_$p(VendorList,"^",6)_"^"_$p(VendorList,"^",7)_"^^^^^^^^"_$p(VendorList,"^",4)_"^^"_$p(VendorList,"^",8)
        s IRowID=1
        //s IRowID=##class(web.DHCEQIFBList).SaveData(IFBList)
	}
	I flag'="" Quit flag
	e  Quit IRowID
}
*/
}
