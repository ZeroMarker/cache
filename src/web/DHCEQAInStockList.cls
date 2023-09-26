Class web.DHCEQAInStockList Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 298;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "AISL_Desc";

Parameter SQLCODE = "AISL_Code";

Parameter SQLROWID = "AISL_RowID";

/// d ##class(%ResultSet).RunQuery("web.DHCEQAInStockList","GetAInStockList","")
Query GetAInStockList(RowID As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TAInStockDR:%String,TItemDR:%String,TCode:%String,TDesc:%String,TModel:%String,TBaseUOMDR:%String,TBaseUOM:%String,TManuFactory:%String,TManuFactoryDR:%String,TPrice:%String,TQuantityNum:%String,TTotalFee:%String,TAmount:%String,TBatchNo:%String,TSourceType:%String,TSourceID:%String,TEstimateFlag:%String,TSerialFlag:%String,TBatchFlag:%String,TProDate:%String,TExpiryDate:%String,TInvoiceNos:%String,TRemark:%String,TManagementFlag:%String,TJob:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,THold6:%String,THold7:%String,TMRRowID:%String,TRequestNo:%String")
{
}

ClassMethod GetAInStockListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	New repid, index,rowid,id
	Set repid=$Increment(^CacheTemp)
 	Set qHandle=$ListBuild(0,repid,0)
	Set index=1
	Set rowid=0
	Set TRow=0
	s Job=$J
	s (TotalQty,Total)=0
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i TotalFlag="1"  s index=2
	
	Do BuildDataGetAInStockList
	Quit $$$OK
BuildDataGetAInStockList
	s AInStockDR=RowID
	if AInStockDR '="" Do
	.f  s rowid=$o(^DHCEQAInStockList(0,"AInStock",AInStockDR,rowid))  quit:rowid=""   d
	..d ResetVariablesGetAInStockList
	..s TRowID=rowid
	..s TAInStockDR = $p($g(^DHCEQAInStockList(rowid)),"^",1)
	..s TItemDR=$p(^DHCEQAInStockList(rowid),"^",2)
	..s TCode=$p(^DHCEQAInStockList(rowid),"^",3)
	..s TDesc=$p(^DHCEQAInStockList(rowid),"^",4)
	..s TModel=$p(^DHCEQAInStockList(rowid),"^",5)
	..s TBaseUOMDR=$p(^DHCEQAInStockList(rowid),"^",6)
	..i TBaseUOMDR'="" d
	...s TBaseUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",(TBaseUOMDR))	;Modified By jdl 20150906 v4.1.0 规范单位取值
	..s TManuFactoryDR=$p(^DHCEQAInStockList(rowid),"^",7)
	..i TManuFactoryDR'="" d
	...s TManuFactory=$p(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR),"^",1)
	..s TPrice=$p(^DHCEQAInStockList(rowid),"^",8)
	..s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice,"",4)		//Mozy	2017-2-2
	..s TQuantityNum=$p(^DHCEQAInStockList(rowid),"^",9)
	..s TQuantityNum=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum,"",2)	//Mozy	2017-2-2
	..i TPrice'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TPrice*TQuantityNum,"",2)
	..s TotalQty=TotalQty+TQuantityNum
	..s Total=Total+TTotalFee
	..s TAmount=$p(^DHCEQAInStockList(rowid),"^",10)
	..s TBatchNo=$p(^DHCEQAInStockList(rowid),"^",11)
	..s TSourceType=$p(^DHCEQAInStockList(rowid),"^",12)
	..s TSourceID=$p(^DHCEQAInStockList(rowid),"^",13)
	..s TEstimateFlag=$p(^DHCEQAInStockList(rowid),"^",14)
	..s TSerialFlag=$p(^DHCEQAInStockList(rowid),"^",15)
	..s TBatchFlag=$p(^DHCEQAInStockList(rowid),"^",16)
	..i TBatchFlag="Y" s TManagementFlag=0
	..i TSerialFlag="Y" s TManagementFlag=1 
	..i TSerialFlag'="" s TSerialFlag=##class(web.DHCEQCommon).TransValueToPage(TSerialFlag,"bool")		//Add By DJ 2014-09-11
	..i TBatchFlag'="" s TBatchFlag=##class(web.DHCEQCommon).TransValueToPage(TBatchFlag,"bool")		//Add By DJ 2014-09-11
	..s TProDate=$p(^DHCEQAInStockList(rowid),"^",17)
	..s TProDate= ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStockList(rowid)),"^",17),"date")
	..s TExpiryDate=$p(^DHCEQAInStockList(rowid),"^",18)
	..s TExpiryDate= ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStockList(rowid)),"^",18),"date")
	..s TInvoiceNos=$p(^DHCEQAInStockList(rowid),"^",19)
	..s TRemark=$p(^DHCEQAInStockList(rowid),"^",20)
	..s THold1=$p(^DHCEQAInStockList(rowid),"^",21)
	..s THold2=$p(^DHCEQAInStockList(rowid),"^",22)
	..s THold3=$p(^DHCEQAInStockList(rowid),"^",23)
	..s THold4=$p(^DHCEQAInStockList(rowid),"^",24)
	..s THold5=$p(^DHCEQAInStockList(rowid),"^",25)
	..;s THold6=$p(^DHCEQAInStockList(rowid),"^",26)
	..;s THold7=$p(^DHCEQAInStockList(rowid),"^",27)
	..; ^DHCEQMMaintPart(MMPRowID,"AISLRowID")=SQLCODE
	..//Mozy	2017-2-2
	..s id=$o(^DHCEQMMaintPart(0,"AInStockList",rowid,""))
	..i id'="" d
	...s TMRRowID=$p($g(^DHCEQMMaintPart(id)),"^",9)	;MTP_MaintRequestDR
	...s TRequestNo=$p($g(^DHCEQMMaintRequest(TMRRowID)),"^",1)
	..s TRow=TRow+1
	..s TJob=Job
	..d OutputRowGetAInStockList
	
	i TRow=0  d
	.d ResetVariablesGetAInStockList
	.s TRow=1
	.s TModel=""    //add by mwz 20180222 需求号542166
	.s TJob=Job
	.d OutputRowGetAInStockList

	;处理合计行
	i TotalFlag>0  d
	.d ResetVariablesGetAInStockList
	.s TRowID=-1
	.s TQuantityNum=TotalQty
	.s TQuantityNum=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum,"",2)	//Mozy	2017-2-2
	.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(Total,"",2)
	.i TotalFlag="1"  d
	..s index=1
	.e  d
	..s index=index+1
	..s TJob=Job
	.d OutputRowGetAInStockList
	Quit
OutputRowGetAInStockList
    Set Data=$ListBuild(TRow,TRowID,TAInStockDR,TItemDR,TCode,TDesc,TModel,TBaseUOMDR,TBaseUOM,TManuFactory,TManuFactoryDR,TPrice,TQuantityNum,TTotalFee,TAmount,TBatchNo,TSourceType,TSourceID,TEstimateFlag,TSerialFlag,TBatchFlag,TProDate,TExpiryDate,TInvoiceNos,TRemark,TManagementFlag,TJob,THold1,THold2,THold3,THold4,THold5,THold6,THold7,TMRRowID,TRequestNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetAInStockList
	Set (TRowID,TAInStockDR,TItemDR,TCode,TDesc,TModel,TBaseUOMDR,TBaseUOM,TManuFactory,TManuFactoryDR,TPrice,TQuantityNum,TAmount,TBatchNo,TSourceType,TSourceID,TEstimateFlag,TSerialFlag,TBatchFlag,TProDate,TExpiryDate,TInvoiceNos,TRemark,TManagementFlag,TJob,THold1,THold2,THold3,THold4,THold5,THold6,THold7,TMRRowID,TRequestNo)=""
	Set TTotalFee=0
	Quit
}

ClassMethod GetAInStockListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAInStockListExecute ]
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
	Set qHandle=$ListBuild(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAInStockListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAInStockListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 描述:新增、更新数据
/// ----------------------------------
ClassMethod SaveData(val, valList, DelRowid)
{
	new (val, valList, DelRowid, mainInvoiceNos)
	Set $ZT="ERRORSave"
	Set mainInvoiceNos=""
	s Date=+$H
	s RowID=$P(val,"^",1)
	s PLIST(2) = $p(val,"^",2)	;InDate
 	i $p(val,"^",2)'=""  s PLIST(2) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",2),"date")	;InDate
 	s PLIST(3) = $p(val,"^",3)	;AccessoryTypeDR
 	s PLIST(4) = $p(val,"^",4)	;LocDR
 	s PLIST(5) = $p(val,"^",5)	;RequestUserDR
    s PLIST(6) = Date	;RequestDate
 	s PLIST(7) = $p(val,"^",7)	;InStockNo
 	s PLIST(8) = $p(val,"^",8)	;InType
 	s PLIST(9) = $p(val,"^",9)	;ProviderDR
 	s PLIST(10) = $p(val,"^",10)	;SourceID 	
 	s PLIST(11) = $p(val,"^",11)	;BuyLocDR
 	s PLIST(12) = $p(val,"^",12)	;BuyUserDR
 	s PLIST(13) = ""	;RejectReason
 	;s PLIST(14) = $p(val,"^",14)	;RejectUserDR 	
 	;s PLIST(15) = $p(val,"^",15)	;RejectDate
 	;s PLIST(16) = $p(val,"^",16)	;RejectTime
 	s PLIST(17) = "0"	;Status
 	s PLIST(18) = $p(val,"^",14)	;AddUserDR
 	s PLIST(19) = Date				;AddDate
 	s PLIST(20) = $P($H,",",2)		;AddTime
 	;s PLIST(21) = $p(val,"^",14)	;SubmitUserDR
 	;s PLIST(22) = Date				;SubmitDate
 	;s PLIST(23) = $P($H,",",2)      ;SubmitTime
 	;S PLIST(24) = $P(val,"^",24)	;AuditUserDR
 	;S PLIST(25) = $P(val,"^",25)	;AuditDate
 	;S PLIST(26) = $P(val,"^",26)	;AuditTime
 	S PLIST(27) = $P(val,"^",15)	;Remark
 	Set PLIST(28) = "N"				;Hold1	Mozy0189	2017-5-26	自动建单未编辑标志
 	;Set PLIST(29) = $Piece(val,"^",29)	;Hold2
 	;Set PLIST(30) = $Piece(val,"^",30)	;Hold3
 	;Set PLIST(31) = $Piece(val,"^",31)	;Hold4
 	;Set PLIST(32) = $Piece(val,"^",32)	;Hold5
 	;Set PLIST(33) = $Piece(val,"^",33)	;Hold6
 	;Set PLIST(34) = $Piece(val,"^",34)	;Hold7
 	;Set PLIST(35) = $Piece(val,"^",35)	;Hold8
 	;Set PLIST(36) = $Piece(val,"^",36)	;Hold9
 	;Set PLIST(37) = $Piece(val,"^",37)	;Hold10
 	;Set PLIST(38) = $Piece(val,"^",38)	;Hold11
	TSTART	
 	if RowID=""
 	{
		i PLIST(7)="" s PLIST(7)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQAInStock",Date,$p(val,"^",4),$p(val,"^",3))	// Mozy	2016-10-21
		&SQL(insert into sqluser.DHC_EQAInStock values :PLIST())
		
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		
		s RowID=$G(%ROWID)
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQAInStock values :PLIST() where AIS_RowID=:RowID)
		
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
 	}
 	
 	s SQLCODE=..DeleteInStockList(DelRowid)
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
 	s SQLCODE=..SaveInStockList(RowID,valList)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	/// 设置配件入库单默认发票号	Mozy
 	If mainInvoiceNos'="" Set ^DHCEQAInStock(RowID,"InvoiceNos")=mainInvoiceNos
 	
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORSave 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// 描述:删除入库单明细
/// w ##Class(web.DHCEQAInStockList).DeleteInStockList("65"," ,0,0,0")
ClassMethod DeleteInStockList(DelRowIDs)
{
	new Length,ISLRowID,Flag,i
	
	i DelRowIDs="" q 0
	
	s Flag=0
	s Length=$l(DelRowIDs,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s ISLRowID=$p(DelRowIDs,",",i)
		if (ISLRowID>0)
		{
			&SQL(delete from  sqluser.DHC_EQAInStockList where AISL_RowID=:ISLRowID)
			i SQLCODE s Flag=SQLCODE
		}
	}
	q Flag
}

/// ----------------------------------
/// 描述:写入入库单明细
/// 入参： ISRowID：入库单ID
/// w ##Class(web.DHCEQAInStockList).SaveInStockList("65","1^100^10403&1^100^10403")
ClassMethod SaveInStockList(ISRowID, valstrings)
{
	new Length,ISLRowID,Flag,i,InvoiceNo,InvoiceDate,InvoiceFee
	n valList,TSourceType,TSourceID
	k PLISTMX
	i valstrings="" q 0
	i ISRowID="" q -1
	s job= $p(valstrings,"##",2)
	s valstring= $p(valstrings,"##",1)
	i valstring="" q 0
	;s PLISTMX(17)= $p(valstring,"##",2)
	s Length=$l(valstring,"&")
	s PLISTMX(2)=ISRowID  				;InStockDR
	s Flag=0
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=	$p(valstring,"&",i)
		s ISLRowID= $p(valList,"^",2)
		;1			2			3		4				5				6			7			8			9			10				11				12				13			14					15			16				17				18			19			20		21			22			23
		;TRow+"^"+TRowID+"^"+TDesc+"^"+TItemDR+"^"+TManuFactoryDR+"^"+TModel+"^"+TPrice+"^"+TBaseUOMDR+"^"+TRemark+"^"+TSourceID+"^"+TInvoiceNos+"^"+TSourceType+"^"+TProDate+"^"+TExpiryDate+"^"+TQuantityNum+"^"+TBatchNo+"^"+TManagementFlag+"^"+TCode+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5	//+"^"+THold6+"^"+THold7;
		s PLISTMX(3) = $p(valList,"^",4)	;ItemDR
 		s PLISTMX(4) = $P($Get(^DHCEQCCode("DHCEQCAccessory",PLISTMX(3))),"^",1) 	;Code
 		s PLISTMX(5) = $p(valList,"^",3)	;Desc
 		s PLISTMX(6) = $p(valList,"^",6)	;Model
 		s PLISTMX(7) = $p(valList,"^",8)	;BaseUOMDR
 		s PLISTMX(8) = $p(valList,"^",5)	;ManuFactoryDR
 		s PLISTMX(9) = ##Class(web.DHCEQCommon).FormatNumber($p(valList,"^",7),"",4)	;Price		//2014-09-09 DJ
 		s PLISTMX(10) = $p(valList,"^",15)	;QuantityNum
 		s PLISTMX(11) = ##Class(web.DHCEQCommon).FormatNumber(PLISTMX(9)*PLISTMX(10),"",4)	;Amount 		//2014-09-09 DJ
 		s PLISTMX(12) = $p(valList,"^",16)	;BatchNo
 		s PLISTMX(13) = $p(valList,"^",12)	;SourceType
 		s PLISTMX(14) = $p(valList,"^",10)	;SourceID
 		i ($p(valList,"^",17)="1")
 		{  
 			s PLISTMX(16)="Y"
 			s PLISTMX(17)="N"
 		}
 		else
 		{
 			s PLISTMX(16)="N"  ;SerialFlag
 			s PLISTMX(17)="Y"  ;BatchFlag
 		}
 		;;s PLISTMX(15) = $p(valList,"^",)	;EstimateFlag 	
 		s PLISTMX(18) = $p(valList,"^",13)	;ProDate
 		i $p(valList,"^",13)'="" s PLISTMX(18) = ##class(web.DHCEQCommon).TransValueFromPage($p(valList,"^",13),"date")	
 		s PLISTMX(19) = $p(valList,"^",14)	;ExpiryDate
 		i $p(valList,"^",14)'="" s PLISTMX(19) = ##class(web.DHCEQCommon).TransValueFromPage($p(valList,"^",14),"date")
 		s PLISTMX(20) = $p(valList,"^",11)	;InvoiceNos
 		s PLISTMX(21) = $p(valList,"^",9)	;Remark
 		
 		Set PLISTMX(22) = $Piece(valList,"^",19)	;Hold1	账页
 		Set PLISTMX(23) = $Piece(valList,"^",20)	;Hold2	货位
 		Set PLISTMX(24) = $Piece(valList,"^",21)	;Hold3
 		Set PLISTMX(25) = $Piece(valList,"^",22)	;Hold4
 		Set PLISTMX(26) = $Piece(valList,"^",23)	;Hold5
 		;Set PLISTMX(27) = $Piece(valList,"^",27)	;Hold6
 		;Set PLISTMX(28) = $Piece(valList,"^",28)	;Hold7
 		
 		s InvoiceNos=PLISTMX(20)
 		s InvoiceDate=""
 		s InvoiceFee=""
 		Set mainInvoiceNos=InvoiceNos
		if (ISLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQAInStockList Values :PLISTMX())
			s ISLRowID=$G(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQAInStockList values :PLISTMX() where AISL_RowID=:ISLRowID)
		}
		i SQLCODE
 		{
			s Flag=SQLCODE
 		}
 		
 		s ^DHCEQAInStockList(ISLRowID,"EX","SerialNoInfo")=$g(^DHCEQTemp("DHCEQAStockDetail",job,ISRowID,PLISTMX(3),ISLRowID))
 		
 		q:Flag'=0
		s SQLCODE=..UpdateInvoiceInfo(ISLRowID, InvoiceNos, InvoiceDate, InvoiceFee)
		
 		i SQLCODE
		{
			s Flag=SQLCODE
		}
	}
	q Flag
}

/// 描述:删除入库单
/// w ##Class(web.DHCEQAInStockList).DeleteData("205^^1^^5^1^^")
ClassMethod DeleteData(val)
{
	Set $ZT="ERRORDelete"
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	
	TSTART
	;&SQL(Delete from SQLUSER.DHC_EQAInStock  where AIS_RowID=:RowID)
	&SQL(update SQLUSER.DHC_EQAInStock set AIS_Status='3' where AIS_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	/*;&SQL(Delete from SQLUSER.DHC_EQAInStockList  where AISL_AInStockDR=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}*/
	TCOMMIT
 	q SQLCODE
ERRORDelete 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}

/// 描述:提交
/// w ##Class(web.DHCEQAInStockList).SubmitData("47^1^^1^")
ClassMethod SubmitData(val)
{
	new (val, %session)  //ZX0035 清空session值后,影响消息生成
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	i $p($g(^DHCEQAInStock(RowID)),"^",27)="Y" q -1	;Hold1	Mozy0189	2017-5-26	自动建单未编辑不能提交
	Set $ZT="ERRORSubmit"
	s User=$P(val,"^",2)
	s Remark=$P(val,"^",3)
	s Job=$P(val,"^",8)
	s Date=+$H
	s LocDR=$p($g(^DHCEQAInStock(RowID)),"^",3)
	s LocType=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
  	i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType,LocDR)) q -1005   //判断入库单中的科室类型是否属于库房
  	
	s PLIST(21) = User	;SubmitUserDR
 	s PLIST(22) = Date	;SubmitDate
 	s PLIST(23) = $P($H,",",2)
	s PLIST(17)="1"		;Status
	s PLIST(27)=Remark	
	
	s AccessoryTypeDR=$p($g(^DHCEQAInStock(RowID)),"^",2)
	s ReturnAccessoryType=..AccessoryTypeIsUniqueNew(RowID,AccessoryTypeDR,"InStock")	
	i ReturnAccessoryType<0 q ReturnAccessoryType
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("10")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, AccessoryTypeDR, "", "", "","")
	i ApproveSet="" q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
		
	s AppInfoStatus="1"		;Status
	
	s AuditFlag=0
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s AuditFlag=1
		s PLIST(17)="2"		;Status
		s PLIST(24)=User	;BillAuditUserDR
		s PLIST(25)=Date	;BillAuditDate
		s AppInfoStatus="2"		;Status
	}
	
	TSTART
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"10",User)
	i SQLCODE
	{
		TROLLBACK
	 	q SQLCODE
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQAInStock values :PLIST() where AIS_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	;最后一步,需要调用审核方法
	if AuditFlag=1
	{
		s AInStockNo=$P($G(^DHCEQAInStock(RowID)),"^",6)
		s SQLCODE=..LastAuditAction(RowID, User, Date, Job, AInStockNo)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}		
	}
	//add by zx 2016-03-03 消息处理 ZX0035
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("A01", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	i SQLCODE q SQLCODE
	TCOMMIT
 	q RowID
 	
ERRORSubmit 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

ClassMethod ChangeStock(RowID, User, Date, Job)
{
	new (RowID, User, Date, Job, ASDR)
	s AcPL(2)=$P(^DHCEQAInStock(RowID),"^",3) //库房
	s j=0
	s CSSQLCODE=0
	s ISLRowID=""
	f  s ISLRowID=$o(^DHCEQAInStockList(0,"AInStock",RowID,ISLRowID))  quit:(ISLRowID="")||(CSSQLCODE'=0)  d
	.s AcPL(4)=ISLRowID //入库明细
	.s Num=$P(^DHCEQAInStockList(ISLRowID),"^",9) //配件数量
	.
	.s SourceType=$p(^DHCEQAInStockList(ISLRowID),"^",12)
	.s SourceID=$P(^DHCEQAInStockList(ISLRowID),"^",13)
	.
	.s AcPL(15)=$P(^DHCEQAInStockList(ISLRowID),"^",7) //生产厂商
	.s AcPL(8)=$P(^DHCEQAInStockList(ISLRowID),"^",18) //过期日期
	.s AcPL(9)=$P(^DHCEQAInStockList(ISLRowID),"^",8) //配件原值
	.s AcPL(16)=$P(^DHCEQAInStockList(ISLRowID),"^",5) //配件机型
	.s AcPL(14)=$P(^DHCEQAInStockList(ISLRowID),"^",6) //配件单位
	.s AcPL(24)=$P(^DHCEQAInStockList(ISLRowID),"^",13)
	.s AcPL(7)=$P(^DHCEQAInStockList(ISLRowID),"^",11) //批号
	.s AcPL(3)=$P(^DHCEQAInStockList(ISLRowID),"^",2) //配件项
	.s AcPL(29)=$P(^DHCEQAInStockList(ISLRowID),"^",22) //ASD_Location
	.s AcPL(30)=$P(^DHCEQAInStockList(ISLRowID),"^",21) //ASD_BillPage
	.i AcPL(3)'="" s AcPL(5)=$P(^DHCEQAInStockList(ISLRowID),"^",3) //Code
	.i AcPL(3)'="" s AcPL(6)=$P(^DHCEQAInStockList(ISLRowID),"^",4) //配件名称
	.s AcPL(17)=$P(^DHCEQAInStock(RowID),"^",8) //供应商
	.s AcPL(12)=$P(^DHCEQAInStock(RowID),"^",2) //类组
	.s AcPL(23)=$P(^DHCEQAInStock(RowID),"^",7) //intype
	.s AcPL(22)=$o(^DHCEQAStock(0,"Accessory",AcPL(3),0))
	.s InStockListDR=$P(^DHCEQAInStockList(ISLRowID),"^",1)
	.s AcPL(13)="0"
	.s AcRowID=0
	.s BatchFlag=$P(^DHCEQAInStockList(ISLRowID),"^",16) //是否批号处理
	.i BatchFlag="N"  d
	..s AcPL(7)=""		//Modify DJ 2014-09-09
	..;插入设备变动信息,更新或插入设备信息
	..s AcPL(18)=1
	..s CSPLIST(3)=$P(^DHCEQAInStock(RowID),"^",3) //ToLocDR
	..s CSPLIST(4)=AcPL(3) //配件项
	..s CSPLIST(5)=AcPL(12) //AccessoryTypeDR
	..s CSPLIST(6)=AcPL(14) //BaseUOMDR
	..s CSPLIST(8)=Num  //BaseStock
	..s CSPLIST(9)=AcPL(9) //Price
	..s CSPLIST(10)="0" //变动类型
	..s CSPLIST(11)=ISLRowID	//变动来源
	..s CSPLIST(12)=Num //Stock
	..s CSPLIST(13)=User	//AuditUserDR
	..s CSPLIST(15)=Date	//AuditDate 	
	..&SQL(insert into sqluser.DHC_EQAChangeStock values :CSPLIST())
	..s CSSQLCODE=SQLCODE
	..q:CSSQLCODE'=0
	..s PLIST(2)=$G(%ROWID)
	..For i = 1:1:Num q:CSSQLCODE'=0  d
	...;序列号存储      来源(入库ID)    配件ID
	...;^DHCEQTemp("DHCEQAStockDetail",job,SourceID,AccessoryDR)
	...;^DHCEQAInStockList(ISLRowID,"EX","SerialNoInfo")
	...s Str=$p($g(^DHCEQAInStockList(ISLRowID,"EX","SerialNoInfo")),"#",1)
	...s List=$p($g(^DHCEQAInStockList(ISLRowID,"EX","SerialNoInfo")),"#",2)
	...i List'="" s j=$p(List,"^",2)
	...i i>j  d
	....s AcPL(10)=""
	...e  d
	....i Str'="" s AcPL(10)=$p(Str,",",i)
	...;设备项插入设备表记录
	...i SourceType="1"  d
	....&SQL(insert into sqluser.DHC_EQAStockDetail values :AcPL())
	....s CSSQLCODE=SQLCODE
	....q:CSSQLCODE'=0
	....s AcRowID=$G(%ROWID)
	....s CSSQLCODE=..UpdateAccessoryNo(AcRowID,+$H)
	....q:CSSQLCODE'=0
	....s PLIST(3)=AcRowID
	....s PLIST(5)=Num
	....s PLIST(6)="1"
	....&SQL(insert into sqluser.DHC_EQAChangeStockDetail values :PLIST())
	....s CSSQLCODE=SQLCODE
	....q:CSSQLCODE'=0
	.e  d
	..s AcPL(10)=""		//Modify DJ 2014-09-09
	..s AcPL(18)=Num
	..&SQL(insert into sqluser.DHC_EQAStockDetail values :AcPL())
	..s CSSQLCODE=SQLCODE
	..q:CSSQLCODE'=0
	..s AcRowID=$G(%ROWID)
	..;插入配件变动信息
	..s CSPLIST(3)=$P(^DHCEQAInStock(RowID),"^",3) //ToLocDR
	..s CSPLIST(4)=AcPL(3) //配件项
	..s CSPLIST(5)=AcPL(12) //AccessoryTypeDR
	..s CSPLIST(6)=AcPL(14) //BaseUOMDR
	..s CSPLIST(8)=Num  //BaseStock
	..s CSPLIST(9)=AcPL(9) //Price
	..s CSPLIST(10)="0" //变动类型
	..s CSPLIST(11)=ISLRowID	//变动来源
	..s CSPLIST(12)=Num //Stock
	..s CSPLIST(13)=User	//AuditUserDR
	..s CSPLIST(15)=Date	//AuditDate 	
	..
	..&SQL(insert into sqluser.DHC_EQAChangeStock values :CSPLIST())
	..s CSSQLCODE=SQLCODE
	..q:CSSQLCODE'=0
	..s PLIST(2)=$G(%ROWID)
	..s PLIST(3)=AcRowID
	..s PLIST(5)=Num
	..s PLIST(6)=Num
	..&SQL(insert into sqluser.DHC_EQAChangeStockDetail values :PLIST())
	..s CSSQLCODE=SQLCODE
	..q:CSSQLCODE'=0
	q CSSQLCODE
}

/// 描述:反提交
/// w ##Class(web.DHCEQAInStockList).CancelSubmitData("202^^1^^5^1^112^28")
ClassMethod CancelSubmitData(val, CurRole)
{
	new (val,CurRole, %session)  //ZX0035 清空session值后,影响消息生成
	Set $ZT="ERRORCancel"
	s RowID=$P(val,"^",1)
	q:RowID=""
	s User=$P(val,"^",2)
	s Remark=$P(val,"^",3)
	s CancelToFlowDR=$P(val,"^",7)
	s ApproveSet=$P(val,"^",5)
	s Date=+$H
	Set RejectReason=$P(val,"^",9)
	;获取取消到上一步的信息
	s Status="0"
	s ApproveRoleDR=""
	s Step=""
	if (CancelToFlowDR'="")
	{
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
	}	 	

	
	s PLIST(14)=User	;RejectUserDR
	s PLIST(15)=Date	;RejectDate
	s PLIST(16)=$P($H,",",2)
	s PLIST(17)=Status
	s PLIST(27)=Remark
	S PLIST(13)=RejectReason		
	TSTART

	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("10")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("10", RowID)
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQAInStock values :PLIST() where AIS_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//add by zx 2016-03-03 ZX0035 取消提交生成消息
	else
	{
		s ApproveFlow=""
		i CancelToFlowDR'=""
		{
			s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
			
		}
		s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("A01", RowID, User, ApproveFlow, "Y",CurRole)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORCancel
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// 描述:修改发票信息
/// 访问表:DHC_EQInvoice,DHC_EQInvoiceUseMap
/// w ##Class(web.DHCEQAInStockList).UpdateInvoiceInfo
/// ----------------------------------
ClassMethod UpdateInvoiceInfo(ISLRowID, InvoiceNos, InvoiceDate, InvoiceFee)
{
	new ISRowID,ProviderID,ISStatus,IUMRowID,InvoiceID
	new OldInvoiceID,OldInvoiceNo,OldInvoiceDate,OldInvoiceFee,RowID,Times
	

	s (OldInvoiceID,OldInvoiceNo,OldInvoiceDate,OldInvoiceFee)=""
	s Flag=0
	s ISRowID=$P(^DHCEQAInStockList(ISLRowID),"^",1)
	s ProviderID=$P(^DHCEQAInStock(ISRowID),"^",8)
	s ISStatus=$P(^DHCEQAInStock(ISRowID),"^",16)
	s IUMRowID=0
	;s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source","2",ISLRowID,IUMRowID))
	s InvoiceDate=##class(web.DHCEQCommon).TransValueFromPage(InvoiceDate,"date")
	s num=$l(InvoiceNos,",")
	s num=1		//Modify DJ 2014-09-25
	for j=1:1:num
	{
		q:Flag'=0
		k INPLIST
		;s INPLIST(3)=$p(InvoiceNos,",",j)
		s INPLIST(3)=InvoiceNos		//Modify 2014-09-25
		s INPLIST(4)=InvoiceDate
		s INPLIST(5)=InvoiceFee
		s INPLIST(11)="0" //Status
		s INPLIST(6)=ProviderID
		s INPLIST(17)="N"
		s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source","3",ISLRowID,IUMRowID))
		;i INPLIST(3)'="" s IvRowID=$o(^DHCEQInvoice(0,"InvoiceNo",INPLIST(3),0))
		;i IvRowID'="" s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Invoice",IvRowID,0))
		;s ^MARUI(23)=IUMRowID
		;获取原来的发票信息
		i IUMRowID'=""
		{		
			s OldInvoiceID=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)
			//s OldInvoiceNo=$p(^DHCEQInvoice(OldInvoiceID),"^",2)
			//s OldInvoiceDate=$p(^DHCEQInvoice(OldInvoiceID),"^",3)
			//s OldInvoiceFee=$p(^DHCEQInvoice(OldInvoiceID),"^",4)
		}
		;获取新的发票ID
		s InvoiceID=""
		i INPLIST(3)'=""
		{
			s RowID=0
			f  s RowID=$o(^DHCEQInvoice(0,"InvoiceNo",INPLIST(3),RowID)) q:((RowID="")||(InvoiceID'=""))  d
			.q:$p(^DHCEQInvoice(RowID),"^",16)'="N"
			.i ProviderID=$p(^DHCEQInvoice(RowID),"^",5) s InvoiceID=RowID		
		}
	
		i InvoiceID'=""
		{
			s Times=##class(web.DHCEQInvoice).InvoiceUsedTimes(3,ISLRowID,InvoiceID)
			i Times>0
			{
				;该发票与原有信息不符!
				i InvoiceDate'=$p(^DHCEQInvoice(InvoiceID),"^",3) s Flag=-1008
				i InvoiceFee'=$p(^DHCEQInvoice(InvoiceID),"^",4) s Flag=-1008				
			}
			;发票已经提交
			i $p(^DHCEQInvoice(InvoiceID),"^",10)="2" s Flag=-1009
			&SQL(update sqluser.DHC_EQInvoice values :INPLIST() where IV_RowID=:InvoiceID)
		}
		else
		{
			i INPLIST(3)'=""
			{
				&SQL(insert into sqluser.DHC_EQInvoice values :INPLIST())
				if SQLCODE s Flag=SQLCODE
				s InvoiceID=$G(%ROWID)
				;q "InvoiceID"_InvoiceID
			}
		}	
	
		;处理原来发票		
		i (OldInvoiceID'="")&&(OldInvoiceID'=InvoiceID)
		{
			;删除对照
			&SQL(delete from sqluser.DHC_EQInvoiceUseMap where IUM_RowID=:IUMRowID)
			if SQLCODE<0 s Flag=SQLCODE
			s Times=##class(web.DHCEQInvoice).InvoiceUsedTimes(3,ISLRowID,OldInvoiceID)
			;没有其他单据使用则删除发票
			i Times=0
			{
				&SQL(delete from sqluser.DHC_EQInvoice where IV_RowID=:OldInvoiceID)
			}
			if SQLCODE<0 s Flag=SQLCODE		
		}
		;增加新发票对照
		i ((InvoiceID'="")&&(OldInvoiceID'=InvoiceID))
		{
			k INMPLIST
			s INMPLIST(2)=ISLRowID
			s INMPLIST(3)=InvoiceID
			s INMPLIST(4)="3"
			&SQL(insert into sqluser.DHC_EQInvoiceUseMap values :INMPLIST())
			if SQLCODE
			{
				s Flag=SQLCODE
			}
		}
	}
	q Flag
}

ClassMethod GetSourceType(TSourceType)
{
	q $CASE(TSourceType,"0":"配件","1":"配件项","":"")
}

ClassMethod GetManagementFlag(TManagementFlag)
{
	q $CASE(TManagementFlag,"0":"批号管理","1":"序列号管理","":"")
}

ClassMethod GetOneAInStock(rowid)
{
	new result,resultex,LocCode,AppInfo,Total
	s (result,resultex,LocCode,AppInfo,Total)=""
	s result= ^DHCEQAInStock(rowid)
	s $p(result,"^",1)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",1),"date")	;InDate
	s resultex=resultex_"^"	;AccessoryTypeDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAccessoryType",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;LocDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))
	.;s LocCode=$p($g(^CTLOC($p(result,"^",2))),"^",1)    //modify by jyp 2019-10-18 CTLOC调整
	.s LocCode=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",$p(result,"^",2))   //modify by jyp 2019-10-18 CTLOC调整
	s resultex=resultex_"^"	;RequestUserDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",4))
	s $p(result,"^",5)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")	;RequestDate
	s resultex=resultex_"^"	;ProviderDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",8))
	.//s ProviderCode=$P($G(^APC("APCVM",$p(result,"^",17))),"^",3)
	s resultex=resultex_"^"	;BuyLocDR
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",10))
	s resultex=resultex_"^"	;BuyUserDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",11))
	s resultex=resultex_"^"	;RejectUserDR
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",13))
	s $p(result,"^",14)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",14),"date")	;RejectDate
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",17))
	s $p(result,"^",18)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",18),"date")	;AddDate
	s resultex=resultex_"^"	;SubmitUserDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",20))
	s $p(result,"^",21)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",21),"date")	;SubmitDate
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",23)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",23))
	s $p(result,"^",24)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",24),"date")	;AuditDate
	
	s Total=..GetOneInStockTotalFeeNum(rowid)
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("10",rowid)
	Set InvoiceNos=$Get(^DHCEQAInStock(rowid,"InvoiceNos"))		/// 配件入库单默认发票号	Mozy
	
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex_"^"_LocCode_"^"_AppInfo_"^"_InvoiceNos
}

ClassMethod GetOneInStockTotalFeeNum(ISRowID)
{
	i ISRowID="" q ""
	new ISLRowID,Fee,Num
	s ISLRowID=0
	s Fee=0
	s Num=0
	f  s ISLRowID=$o(^DHCEQAInStockList(0,"InStock",ISRowID,ISLRowID)) q:ISLRowID=""  d
	.s QuantityNum=$P(^DHCEQAInStockList(ISLRowID),"^",9)
	.s Price=$P(^DHCEQAInStockList(ISLRowID),"^",8)
	.s Fee=Fee+(QuantityNum*Price)
	.s Num=Num+QuantityNum
	i Fee=0  d
	.s Fee=""
	e  d
	.s Fee=##Class(web.DHCEQCommon).FormatNumber(Fee,"",4)
	//Mozy	2017-2-2
	i Num=0 d
	.s Num=""
	e  d
	.s Num=##Class(web.DHCEQCommon).FormatNumber(Num,"",2)
	q Num_"^"_Fee
}

/// 描述：更新设备配件库存
/// 访问表:DHC_EQAStock、DHC_EQAStockList
/// 输入：No：入库单编号
/// 输出：无
/// 返回：
/// 备注：
/// d ##Class(web.DHCEQAInStockList).SaveAStock("20090039")
ClassMethod SaveAStock(No As %Library.String = "")
{
	Kill PLIST
	
	New rowid,id,RowID,AS
	Set AInStockDR=$Order(^DHCEQAInStock(0,"InStockNo",No,""),-1)
	Set LocDR=$Piece($Get(^DHCEQAInStock(AInStockDR)),"^",3)
	//Set job=$Order(^DHCEQTemp("DHCEQAInStockList",No,""),-1)
	Set Amount=0
	Set Stock=0
	
	Set rowid=""
	For  Set rowid=$Order(^DHCEQAInStockList(0,"AInStock",AInStockDR,rowid))  Quit:rowid=""  Do
	.Set val=$Get(^DHCEQAInStockList(rowid))
	.Set AccessoryDR=$Piece(val,"^",2)
	.Set Price=$Piece(val,"^",8)
	.Set RowID=""
	.Set AS=""
	.Set id=""
	.K PLIST	//Modify DJ 2014-09-09
	.For  Set id=$Order(^DHCEQAStock(0,"Loc",LocDR,id))  Quit:id=""  Do
	..Set AS=$Get(^DHCEQAStock(id))
	..If ($Piece(AS,"^",2)=AccessoryDR) Set RowID=id
	.If (RowID="") Do
	..Set PLIST(2)=LocDR										;AS_LocDR
	..Set PLIST(3)=AccessoryDR									;AS_ItemDR
	..;Set Code=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",AccessoryDR)),"^",1)
	..Set PLIST(4)=$Piece(val,"^",3)											;AS_Code
	..;Set Desc=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",AccessoryDR)),"^",2)
	..Set PLIST(5)=$Piece(val,"^",4)											;AS_Desc
	..Set PLIST(6)=$Piece($Get(^DHCEQAInStock(AInStockDR)),"^",2) ;AS_AccessoryTypeDR
	..Set PLIST(7)=$Piece(val,"^",18)                           ;ExpiryDate
	..Set PLIST(8)=+$Piece(val,"^",8) 							;AS_FinalBPrice
	..Set PLIST(9)=PLIST(8)										;AS_WtdBPrice
	..Set PLIST(11)=+$Piece(val,"^",9)							;AS_Stock
	..Set PLIST(10)=PLIST(11)*PLIST(8)							;AS_Amount
	..&SQL(Insert into sqluser.DHC_EQAStock values :PLIST())
	.Else  Do
	..Set AS=$Get(^DHCEQAStock(RowID))
	..Set Stock=+$Piece(AS,"^",10)
	..Set Amount=+$Piece(AS,"^",9)
	..; val DHCEQAInStockList
	..Set PLIST(8)=+$Piece(val,"^",8) 							;AS_FinalBPrice
	..Set PLIST(11)=Stock+$Piece(val,"^",9)						;AS_Stock
	..Set PLIST(10)=Amount+(+$Piece(val,"^",9)*PLIST(8))		;AS_Amount
	..If PLIST(11)'=0 Set PLIST(9)=PLIST(10)/PLIST(11)			;AS_WtdBPrice
	..If PLIST(9)'="" Set PLIST(9)=##Class(web.DHCEQCommon).FormatNumber(PLIST(9),"",4)
	..&SQL(Update sqluser.DHC_EQAStock values :PLIST() where AS_RowID = :RowID)
	
	If SQLCODE 
 	{
	 	Quit SQLCODE
 	} 	

	Quit 0
}

ClassMethod UpdateAccessoryNo(rowid, curdate)
{
	new accessoryno
	s accessoryno = ..GetNextNo(rowid,curdate)
	i accessoryno="" q ""
	&SQL(Update SQLUSER.DHC_EQAStockDetail set ASD_No=:accessoryno Where ASD_RowID=:rowid)
	if SQLCODE q SQLCODE
	q 0
}

/// w ##Class(web.DHCEQAInStockList).GetNextNo("47", +$H)
ClassMethod GetNextNo(rowid, curdate)
{
	new accessorytype,accessorycatdr,storelocdr
	s (accessorytype,accessorycatdr,storelocdr)=""
	&SQL(select ASD_AccessoryTypeDR->AT_Code,ASD_ItemDR->A_CatDR,ASD_LocDR into :accessorytype,:accessorycatdr,:storelocdr from SQLUSER.DHC_EQAStockDetail where ASD_RowID=:rowid)
	i SQLCODE  q ""
	s accessorycatno=..GetAccessoryCatCode(accessorycatdr)
	///生成编号时，去掉分类编码中的“-”
	;s accessorycatno=##class(web.DHCEQCommon).Replace(accessorycatno,"-","")	
	s nextno=##class(web.DHCEQCCounter).GetNextNo("DHC_EQCAccessory",curdate,storelocdr,accessorytype,"",accessorycatno)	
	;s nextno=##class(web.DHCEQCCounter).GetNextNo("DHC_EQAInStock",curdate,storelocdr,"","","")
	q nextno
}

ClassMethod GetAccessoryCatCode(accessorycatdr)
{
	new accessorycode,flag
	s accessorycode=""
	while((accessorycode="")&&(accessorycatdr'="")){
		s flag=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",accessorycatdr)),"^",5)
		if flag="Y"  d 
		.s accessorycode=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",accessorycatdr)),"^",2)
		e  d
		.s accessorycatdr=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",accessorycatdr)),"^",1)
	}
	q accessorycode
}

ClassMethod GetSysInfo(code)
{
	new rowid,Info
	s Info=""
	s rowid=$o(^DHCEQCCode("DHCEQCSysSet",0,"Code",code,0))
	i rowid'="" s Info=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",2)
	q Info
}

/// 根据SourceID^QuantityNum^index^MXRowID^AccessoryDR
/// 保存配件序列号到临时Global
/// d ##Class(web.DHCEQAInStockList).SaveSerialNo("123")
ClassMethod SaveSerialNo(SerialNo, SourceID, QuantityNum, index, MXRowID, AccessoryDR, Status, job)
{
	n str
	n (SerialNo, SourceID, QuantityNum, index, MXRowID, AccessoryDR, Status, job)

	i job="" s job=$j
	s SerialNo=$TRANSLATE(SerialNo,"，",",")	//需求序号:	417407		Mozy	20170731	增加对序列号的中文逗号替换为英文逗号
	s str=SerialNo_"#"_SourceID_"^"_QuantityNum_"^"_index_"^"_MXRowID_"^"_AccessoryDR_"^"_Status
	s ^DHCEQTemp("DHCEQAStockDetail",job,SourceID,AccessoryDR,MXRowID)=str
	s ^DHCEQAInStockList(MXRowID,"EX","SerialNoInfo")=str
	
	Quit 0
}

ClassMethod GetSerialNoInfo(MXRowID, SourceID, AccessoryDR, job As %Library.String = "")
{
	n SeriaLNo
	n (SourceID, MXRowID, AccessoryDR, job)
	s SeriaLNo=$g(^DHCEQTemp("DHCEQAStockDetail",job,SourceID,AccessoryDR,MXRowID))
	q SeriaLNo
}

ClassMethod FillData(MXRowID, SourceID, AccessoryDR, job As %Library.String = "")
{
	;i job="" s job=$j
	n SeriaLNo
	n (SourceID, MXRowID, AccessoryDR, job)
	s SeriaLNo=$g(^DHCEQAInStockList(MXRowID,"EX","SerialNoInfo"))
	q SeriaLNo
}

/// ----------------------------------
/// 描述:判断入库单设备类组的唯一性
/// w ##Class(web.DHCEQAInStockList).AccessoryTypeIsUniqueNewTypeIsUniqueNew("63","1","StoreMove")
/// 返回值：-1006：明细的类组不一致，-1007:明细与单据的类组不一致
ClassMethod AccessoryTypeIsUniqueNew(RowID, AccessoryTypeID, vType)
{
	new (RowID, AccessoryTypeID, vType)
	
	new ResultFlag,PreAccessoryTypeID,CTypeDR
	new SourceType,SourceID
	new ISLRowID,SMLRowID,RLRowID
	
	s ResultFlag=0	
	s PreAccessoryTypeID=0

	s AccessoryTypeDR=""
	if (vType="InStock")	//入库单明细的判断
	{
		s ISLRowID=0
		f  s ISLRowID=$O(^DHCEQAInStockList(0,"AInStock",RowID,ISLRowID)) q:(ISLRowID="")||(ResultFlag'=0)  d
		.s SourceType=$P(^DHCEQAInStockList(ISLRowID),"^",12)
		.s SourceID=$P(^DHCEQAInStockList(ISLRowID),"^",13)
		.i SourceID="" s ResultFlag=-1003
		.q:(ResultFlag'=0)
		.i SourceType="0" d 	//配件
		..;s AccessoryTypeDR=$p($g(^DHCEQCAccessory(SourceID)),"^",14)
		.i SourceType="1" d  	//配件项
		..i SourceID'="" s AccessoryTypeDR=$p($g(^DHCEQCCode("DHCEQCAccessory",SourceID)),"^",14)
		.d CheckAccessoryType
	}
	i ResultFlag'=0 q ResultFlag
	q AccessoryTypeDR	
CheckAccessoryType
	i PreAccessoryTypeID=0 s PreAccessoryTypeID=AccessoryTypeDR
	i PreAccessoryTypeID'=AccessoryTypeDR  d
	.s ResultFlag=-1006
	e  i (AccessoryTypeID'="")&&(AccessoryTypeID'=AccessoryTypeDR)  d
	.s ResultFlag=-1007
	q
}

/// ----------------------------------
/// 描述：最终审核时需调用此方法,执行审核中需要处理的数据
/// 	在此处，需调用
/// w ##Class(web.DHCEQAcInStorckList).LastAuditAction(52,1,61963,Job,AInStockNo)
/// ----------------------------------
ClassMethod LastAuditAction(RowID, User, Date, Job, AInStockNo)
{
	s SQLCODE=##class(web.DHCEQAInStockList).SaveAStock(AInStockNo)
	i SQLCODE q SQLCODE
	s SQLCODE=##class(web.DHCEQAInStockList).ChangeStock(RowID,User,Date,Job)
	q SQLCODE
}

/// 描述:审核
/// w ##Class(web.DHCEQAInStockList).AuditData("202^^1^^5^1^^28","13","2","202^,3^,4@455^1111113434,1^11111343434,2")
ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo)
{
	new (val, CurRole,RoleStep, editFieldsInfo, %session)  //ZX0035 清空session值后,影响消息生成
	n ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	n User,Date,RowID,AuditFlag
	Set $ZT="ERRORAudit"
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	
	s User=$P(val,"^",2)
	s Date=+$H
	s Job=$P(val,"^",8)
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("10")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("10",RowID)
		
	i ApproveSet="" q -4007	
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
		
	s AppInfoStatus="1"	;Status	
	
	TSTART
	s AuditFlag=0
	i ((NextStep="")||(LastFlag="Y"))
	{
		i ($p($g(^DHCEQAInStock(RowID)),"^",16)=2)
		{
			TROLLBACK
			q -1010
		}
		s AuditFlag=1
		s PLIST(17)="2"
		s PLIST(24)=User	;AuditUserDR
		s PLIST(25)=Date	;AuditDate
		s PLIST(26)=$P($H,",",2)
		&SQL(update sqluser.DHC_EQAInStock values :PLIST() where AIS_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		
		s AppInfoStatus="2"	;Status
	}
	
	;生成审批记录
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep)
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}	
	if editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)		//编辑要修改的字段
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	;最后一步,需要调用审核方法
	s AInStockNo=$P($G(^DHCEQAInStock(RowID)),"^",6)
	if AuditFlag=1
	{
		s SQLCODE=..LastAuditAction(RowID, User, Date, Job, AInStockNo)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}		
	}
	//add by zx 2016-03-03 消息处理 ZX0035
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("A01", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg     //返回错误消息 ;
}

ClassMethod GetList(InStockDR As %Library.String = "")
{
	s Data=""
	s Num=0
	
	s (sumFee,sumQty)=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set SplitNumCode=##class(web.DHCEQCommon).GetSysInfo("990026")
	
	s Rowid=0
	f  s Rowid=$o(^DHCEQAInStockList(Rowid))  quit:Rowid=""  d
	.s (ManuFactory,Model,Unit)=""
	.s InStockD=$p($g(^DHCEQAInStockList(Rowid)),"^",1)
	.q:InStockD'=InStockDR
	.s AccessoryName=$p($g(^DHCEQAInStockList(Rowid)),"^",4) //配件名称
	.s ManuFactoryDR=$p($g(^DHCEQAInStockList(Rowid)),"^",7) //生产厂商
	.i ManuFactoryDR '=""  d
	..s ManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR)),"^",1)
	.s Model=$p($g(^DHCEQAInStockList(Rowid)),"^",5) //规格
	.s UnitDR=$p($g(^DHCEQAInStockList(Rowid)),"^",6) //单位
	.i UnitDR '=""  d
	..s Unit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	.s QuantityNum=$p($g(^DHCEQAInStockList(Rowid)),"^",9) //数量
	.s QuantityNum=##Class(web.DHCEQCommon).FormatNumber(QuantityNum,"",2)	//Mozy	2017-2-2
	.s OriginalFee=$p($g(^DHCEQAInStockList(Rowid)),"^",8) //单价
	.if OriginalFee'="" s OriginalFee=##Class(web.DHCEQCommon).FormatNumber(OriginalFee,"",4)  //modify BY:GBX 2014-9-14 11:21:01
	.;s InvoiceNos=$p(##Class(web.DHCEQInvoice).GetInvoiceInfos(3,Rowid),"^",1) //发票号 Modify BY:GBX 2014-8-21 22:02:29 3:配件
	.s InvoiceNos=$p(^DHCEQAInStockList(Rowid),"^",19)  //modify BY:GBX 2014-9-13 16:52:39
	.s Remark=$p($g(^DHCEQAInStockList(Rowid)),"^",20) //备注
	.s AllFee=QuantityNum*OriginalFee
	.if AllFee'="" s AllFee=##Class(web.DHCEQCommon).FormatNumber(AllFee,"",4)  //modify BY:GBX  2014-9-14 11:21:19
	.s sumFee=sumFee+AllFee
	.if sumFee'="" s sumFee=##Class(web.DHCEQCommon).FormatNumber(sumFee,"",4)
	.s sumQty=sumQty+QuantityNum
	.if sumQty'="" s sumQty=##Class(web.DHCEQCommon).FormatNumber(sumQty,"",2)	//Mozy	2017-2-2
	.                         //设备名称      生产厂商      规格    单位   数量         单价          金额    发票号       备注
	.s Data=Data_SplitRowCode_AccessoryName_"^"_ManuFactory_"^"_Model_"^"_Unit_"^"_QuantityNum_"^"_OriginalFee_"^"_AllFee_"^"_InvoiceNos_"^"_Remark
	.s Num=Num+1
	i Data'=""  d
	.s Data=Data_SplitRowCode_"合计"_"^"_"^"_"^"_"^"_sumQty_"^"_"^"_sumFee_"^"_"^"_"^"_"^"_"^"
	.s Num=Num+1
	q Data_SplitNumCode_Num
}

/// Creator：      WL
/// CreatDate：    2019-11-20
/// Description:   润乾打印(配件入库单)
/// Input：        AISRowID:配件入库ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQAInStockList","GetAInStockPrint","20")
Query GetAInStockPrint(AISRowID As %String = "") As %Query(ROWSPEC = "AISInDate:%String,AISProviderDR_VName:%String,AISInstockNo:%String,AISRemark:%String,AISBuyUserDR_UName:%String") [ SqlProc ]
{
}

ClassMethod GetAInStockPrintExecute(ByRef qHandle As %Binary, AISRowID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
	i AISRowID'="" d
	.s (TInDate,TProviderDR,TProvider,TInstockNo,TRemark,TBuyUserDR,TBuyUser)=""
	.s TInDate=$p($g(^DHCEQAInStock(AISRowID)),"^",1) //入库日期
	.i TInDate'="" s TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"datetime")
	.s TProviderDR= $p($g(^DHCEQAInStock(AISRowID)),"^",8)
	.i TProviderDR'="" s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR) //供应商
	.s TInstockNo=$p($g(^DHCEQAInStock(AISRowID)),"^",6) //单号
	.s TRemark= $p($g(^DHCEQAInStock(AISRowID)),"^",26) //备注
	.s TBuyUserDR=$p($g(^DHCEQAInStock(AISRowID)),"^",11)
	.i TBuyUserDR'="" s TBuyUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TBuyUserDR)
 	.d OutputRowGetAInStockPrint
 	
 	

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK	 
OutputRowGetAInStockPrint
 set Data=$lb(TInDate,TProvider,TInstockNo,TRemark,TBuyUser)
 set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetAInStockPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAInStockPrintExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind=""
	 {
	  //if there are no more rows,finish fetching...
	  Set AtEnd=1
	  Set Row=""
	 }
	 Else
	 {
	  Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod GetAInStockPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAInStockPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      WL
/// CreatDate：    2019-11-20
/// Description:   润乾打印(配件入库单明细)
/// Input：        AISRowID:配件入库ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQAInStockList","GetAInStockListPrint","20")
Query GetAInStockListPrint(AISRowID As %String = "") As %Query(ROWSPEC = "ASLDesc:%String,ASLManuFactory_MUDesc:%String,AISLModel:%String,AISLBaseUOMDR_UOMDesc:%String,ASLQuantityNum:%String,ASLOriginalFee:%String,ASLInvoiceNos:%String,ASLRemark:%String,AllFee: %String") [ SqlProc ]
{
}

ClassMethod GetAInStockListPrintExecute(ByRef qHandle As %Binary, AISRowID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
	s Rowid=0
	f  s Rowid=$o(^DHCEQAInStockList(Rowid))  quit:Rowid=""  d
	.s (ManuFactory,Model,Unit,AllFee)=""
	.s InStockD=$p($g(^DHCEQAInStockList(Rowid)),"^",1)
	.q:InStockD'=AISRowID
	.s AccessoryName=$p($g(^DHCEQAInStockList(Rowid)),"^",4) //配件名称
	.s ManuFactoryDR=$p($g(^DHCEQAInStockList(Rowid)),"^",7) //生产厂商
	.i ManuFactoryDR '=""  d
	..s ManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR)),"^",1)
	.s Model=$p($g(^DHCEQAInStockList(Rowid)),"^",5) //规格
	.s UnitDR=$p($g(^DHCEQAInStockList(Rowid)),"^",6) //单位
	.i UnitDR '=""  d
	..s Unit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	.s QuantityNum=$p($g(^DHCEQAInStockList(Rowid)),"^",9) //数量
	.s QuantityNum=##Class(web.DHCEQCommon).FormatNumber(QuantityNum,"",2)	
	.s OriginalFee=$p($g(^DHCEQAInStockList(Rowid)),"^",8) //单价
	.s AllFee=QuantityNum*OriginalFee
	.if AllFee'="" s AllFee=##Class(web.DHCEQCommon).FormatNumber(AllFee,"",4) 
	.if OriginalFee'="" s OriginalFee=##Class(web.DHCEQCommon).FormatNumber(OriginalFee,"",4)  
	.s InvoiceNos=$p(^DHCEQAInStockList(Rowid),"^",19) //发票号  
	.s Remark=$p($g(^DHCEQAInStockList(Rowid)),"^",20) //备注
	 
 	.d OutputRowGetAInStockListPrint
 	
 	

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK	 
OutputRowGetAInStockListPrint
 set Data=$lb(AccessoryName,ManuFactory,Model,Unit,QuantityNum,OriginalFee,InvoiceNos,Remark,AllFee) 
 set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetAInStockListPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAInStockListPrintExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind=""
	 {
	  //if there are no more rows,finish fetching...
	  Set AtEnd=1
	  Set Row=""
	 }
	 Else
	 {
	  Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod GetAInStockListPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAInStockListPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
