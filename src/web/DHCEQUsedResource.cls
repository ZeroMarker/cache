Import SQLUser

Class web.DHCEQUsedResource Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "UR_RowID";

Parameter SQLDESCRIPTION = "UR_RowID";

Parameter SQLROWID = "UR_RowID";

ClassMethod GetUsedResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUsedResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// modified by czf 397032 增加TRow并输出
/// Modified By QW20190528 需求号:898628 修改参数
ClassMethod GetUsedResourceExecute(ByRef qHandle As %Binary, vData As %String = "", StartYearMonth As %String = "", EndYearMonth As %String = "", QXType As %String = "") As %Status
{
	
	s ^tempczf("useresource")=$lb(vData,StartYearMonth,EndYearMonth)
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=2
	s TRow=1
	s rowid=0
	s Amount=0
	d BuildDataGetUsedResource
	Quit $$$OK
BuildDataGetUsedResource
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set SourceTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"SourceTypeDR")
	Set SourceIDDR=##Class(web.DHCEQCommon).GetDataByName(vData,"SourceIDDR")
	Set ModelDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ModelDR")
	Set ResourceTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ResourceTypeDR")
	Set LocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"LocDR")
	Set Year=##Class(web.DHCEQCommon).GetDataByName(vData,"Year")
	Set Month=##Class(web.DHCEQCommon).GetDataByName(vData,"Month")
	Set ItemDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ItemDR")
	///Modified By QW20190528 需求号:898628 修改参数
	Set IsInputFlag=##Class(web.DHCEQCommon).GetDataByName(vData,"IsInputFlag")
	///End By QW20190528 需求号:898628 修改参数
	//add by zy 2013-05-30
	s IsInputFlag=##Class(web.DHCEQCommon).TransValueFromPage(IsInputFlag,"bool")	
	i (Year'="")||(Month'="")  d
	.i Year=""  d
	..s Year=0
	..f  s Year=$o(^DHCEQUsedResource(0,"YearMonth",Year))  q:Year=""  d
	...s RSType=0
	...f  s RSType=$o(^DHCEQUsedResource(0,"YearMonth",Year,Month,RSType)) q:RSType=""  d
	....q:(ResourceTypeDR'="")&&(RSType'=ResourceTypeDR)
	....s URRowID=0
	....f  s URRowID=$o(^DHCEQUsedResource(0,"YearMonth",Year,Month,RSType,URRowID))  q:URRowID=""  d
	.....d ResetVariablesGetUsedResource
	.....d CheckUsedResource
	.....q:passed=0
	.....d OutputRowGetUsedResource
	....d CancelData
	.e  d
	..i Month=""  d
	...s Month=0
	...f  s Month=$o(^DHCEQUsedResource(0,"YearMonth",Year,Month)) q:Month=""  d
	....s RSType=0
	....f  s RSType=$o(^DHCEQUsedResource(0,"YearMonth",Year,Month,RSType)) q:RSType=""  d
	.....q:(ResourceTypeDR'="")&&(RSType'=ResourceTypeDR)
	.....s URRowID=0
	.....f  s URRowID=$o(^DHCEQUsedResource(0,"YearMonth",Year,Month,RSType,URRowID))  q:URRowID=""  d
	......d ResetVariablesGetUsedResource
	......d CheckUsedResource
	......q:passed=0
	......d OutputRowGetUsedResource
	.....d CancelData
	..e  d
	...s RSType=0
	...f  s RSType=$o(^DHCEQUsedResource(0,"YearMonth",Year,Month,RSType)) q:RSType=""  d
	....q:(ResourceTypeDR'="")&&(RSType'=ResourceTypeDR)
	....s URRowID=0
	....f  s URRowID=$o(^DHCEQUsedResource(0,"YearMonth",Year,Month,RSType,URRowID))  q:URRowID=""  d
	.....d ResetVariablesGetUsedResource
	.....d CheckUsedResource
	.....q:passed=0
	.....d OutputRowGetUsedResource
	....d CancelData
	e  d
	.s Year=0
	.s (STYear,StartMonth,EndYear,EndMonth)=""
	.i StartYearMonth'=""  d
	..s Year=+$p(StartYearMonth,"-",1)-1
	..s STYear=+$p(StartYearMonth,"-",1)       //modified by czf  387023
	..s StartMonth=+$P(StartYearMonth,"-",2)
	.i EndYearMonth'=""  d
	..s EndYear=+$p(EndYearMonth,"-",1)
	..s EndMonth=+$p(EndYearMonth,"-",2)
	.f  s Year=$o(^DHCEQUsedResource(0,"YearMonth",Year))  q:Year=""  d
	..q:(STYear'="")&&(Year<STYear)         //modified by czf 需求号：353866
	..q:(STYear'="")&&(Year>EndYear)
	..s Month=0
	..f  s Month=$o(^DHCEQUsedResource(0,"YearMonth",Year,Month))  q:Month=""  d
	...q:(StartMonth'="")&&(Year=STYear)&&(Month<StartMonth)
	...q:(EndMonth'="")&&(Year=EndYear)&&(Month>EndMonth)
	...s RSType=0
	...f  s RSType=$o(^DHCEQUsedResource(0,"YearMonth",Year,Month,RSType))  q:RSType=""  d
	....q:(ResourceTypeDR'="")&&(RSType'=ResourceTypeDR)
	....s URRowID=0
	....f  s URRowID=$o(^DHCEQUsedResource(0,"YearMonth",Year,Month,RSType,URRowID))  q:URRowID=""  d
	.....d ResetVariablesGetUsedResource
	.....d CheckUsedResource
	.....q:passed=0
	.....d OutputRowGetUsedResource
	....d CancelData
	d ResetVariablesGetUsedResource
	s index=1
	s TRow=""
	s TSourceID="合计:"
	s TAmount=Amount
	i TAmount'="" s TAmount=##class(web.DHCEQCommon).FormatNumber(TAmount,"")  //add by wl 2019-09-12 1025419
	d OutputRowGetUsedResource
	quit
CancelData
	i Month+1>12 d
	.s CSDate=$ZDH(Year_"-"_Month_"-01",3)-1 
	.s CEDate=$ZDH(Year+1_"-01-01",3)
	e  d
	.s CSDate=$ZDH(Year_"-"_Month_"-01",3)-1 
	.s CEDate=$ZDH(Year_"-"_(Month+1)_"-01",3)
	f  s CSDate=$o(^DHCEQUsedResource(0,"CancelDate",CSDate))  q:(CSDate="")||(CSDate>=CEDate)  d
	.s URRowID=0
	.f  s URRowID=$o(^DHCEQUsedResource(0,"CancelDate",CSDate,URRowID))  q:URRowID=""  d
	..s RSType=$p($g(^DHCEQUsedResource(URRowID)),"^",5)
	..q:(ResourceTypeDR'="")&&(RSType'=ResourceTypeDR)
	..d ResetVariablesGetUsedResource
	..d CheckUsedResource
	..q:passed=0
	..s TAmount=0-TAmount
	..s Amount=Amount+TAmount+TAmount
	..d OutputRowGetUsedResource
	quit
CheckUsedResource
	s passed=1
	s TRowID = URRowID	//rowid
	s TSourceType=$p($g(^DHCEQUsedResource(URRowID)),"^",3)
	i (SourceTypeDR'="")&&(TSourceType'=SourceTypeDR)
	{
		s passed=0
		q
	}
	s TSourceID=$p($g(^DHCEQUsedResource(URRowID)),"^",4)
	i TSourceType=1 s Item=$p($g(^DHCEQEquip(TSourceID)),"^",7)
	i TSourceType=2 s Item=TSourceID
	i (ItemDR'="")&&(Item'=ItemDR)
	{
		s passed=0
		q
	}
	i SourceIDDR'=""
	{
		s EQItem=$p($g(^DHCEQEquip(SourceIDDR)),"^",7)
		i (TSourceType=2)&&(Item'=EQItem)
		{
			s passed=0
			q
		}
	}
	i (SourceIDDR'="")&&(TSourceID'=SourceIDDR)
	{
		s passed=0
		q
	}
	s TLoc=$p($g(^DHCEQUsedResource(URRowID)),"^",10) //2010-10-29 DJ
	i (LocDR'="")&&(TLoc'=LocDR)
	{
		s passed=0
		q
	}
	i TLoc'="" //2010-10-29 DJ
	{
		s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,TLoc)
		i Find'=0
		{
			s passed=0
			q
		}
	}
	s TModel=$p($g(^DHCEQUsedResource(URRowID)),"^",14)
	i (ModelDR'="")&&(TModel'=ModelDR)
	{
		s passed=0
		q
	}
	s TStatus=$p($g(^DHCEQUsedResource(URRowID)),"^",18)
	i (QXType=1)&&(TStatus<=1)
	{
		s passed=0
		q
	}
	//add by zy 2013-05-30
	//非手工录入的月资源消耗数据不再设备月度资源消耗界面显示。
	i (IsInputFlag'="")&&($p($g(^DHCEQUsedResource(URRowID)),"^",30)'=IsInputFlag)
	{
		s passed=0
		q
	}
	s TYear=$p($g(^DHCEQUsedResource(URRowID)),"^",1)
	s TMonth=$p($g(^DHCEQUsedResource(URRowID)),"^",2)
	i (TSourceID'="")&&(TSourceType=1) d //设备
	.s TEquipNo=$p($g(^DHCEQEquip(TSourceID)),"^",71)
	.s TSourceID=$p($g(^DHCEQEquip(TSourceID)),"^",1)
	i (TSourceID'="")&&(TSourceType=2) d //设备项
	.s TEquipNo=""
	.s TSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",1)
	i TSourceType'="" s TSourceType=##Class(web.DHCEQEquipService).GetEditSourceType(TSourceType)
	s TResourceType=$p($g(^DHCEQUsedResource(URRowID)),"^",5)
	i TResourceType'=""  s TResourceType=$p($g(^DHCEQCCode("DHCEQCResourceType",TResourceType)),"^",2)
	s TPrice=$p($g(^DHCEQUsedResource(URRowID)),"^",6)
	i TPrice'="" s TPrice=##class(web.DHCEQCommon).FormatNumber(TPrice,"")  //add by wl 2019-9-10 1025419
	s TUom=$p($g(^DHCEQUsedResource(URRowID)),"^",7)
	i TUom'="" s TUom=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUom)
	s TQuantity=$p($g(^DHCEQUsedResource(URRowID)),"^",8)
	//modified by ZY0257  输出错误
	s TAmount=$p($g(^DHCEQUsedResource(URRowID)),"^",9)
	i TAmount="" s TAmount= TQuantity * TPrice   ;add by kdf 2018-03-27 569980
	i TAmount'="" s TAmount = ##class(web.DHCEQCommon).FormatNumber(TAmount,"") //add by wl 2019-9-10 1025419
	i TLoc'=""  s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
	s TAddUser=$p($g(^DHCEQUsedResource(URRowID)),"^",13)
	i TAddUser'="" s TAddUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TAddUser)
	i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	i TStatus'=""  s TStatus=..GetEditURStatus(TStatus)
	s TRemark=$p($g(^DHCEQUsedResource(URRowID)),"^",29)
	s TIsInputFlag=$p($g(^DHCEQUsedResource(URRowID)),"^",30)
	s TCancelDate=$p($g(^DHCEQUsedResource(URRowID)),"^",26)
	i TCancelDate'=""  s TCancelDate=##Class(web.DHCEQCommon).TransValueToPage(TCancelDate,"date")
	s TCancelUser=$p($g(^DHCEQUsedResource(URRowID)),"^",28)
	i TCancelUser'=""  s TCancelUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TCancelUser)
	s Amount=Amount+TAmount
	quit
OutputRowGetUsedResource
	s Data=$lb(TRowID,TYear,TMonth,TSourceType,TSourceID,TResourceType,TPrice,TUom,TQuantity,TAmount,TLoc,TAddUser,TModel,TStatus,TRemark,TIsInputFlag,TEquipNo,TCancelDate,TCancelUser,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetUsedResource
	s (TRowID,TYear,TMonth,TSourceType,TSourceID,TResourceType,TPrice,TUom,TQuantity,TAmount,TLoc,TAddUser,TModel,TStatus,TRemark,TIsInputFlag,TEquipNo,TCancelDate,TCancelUser)=""
	quit
}

ClassMethod GetUsedResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUsedResourceExecute ]
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

/// modified by zy 2013-05-30
/// 添加参数IsInputFlag 判断时候包含手工录入的数据
/// Modified By QW20190528 需求号:898628 修改参数
Query GetUsedResource(vData As %String = "", StartYearMonth As %String = "", EndYearMonth As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TYear:%String,TMonth:%String,TSourceType:%String,TSourceID:%String,TResourceType:%String,TPrice:%String,TUom:%String,TQuantity:%String,TAmount:%String,TLoc:%String,TAddUser:%String,TModel:%String,TStatus:%String,TRemark:%String,TIsInputFlag:%String,TEquipNo:%String,TCancelDate:%String,TCancelUser:%String,TRow:%String")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= $g(^DHCEQUsedResource(rowid))
	s resultex=resultex_"^"
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##Class(web.DHCEQEquipService).GetEditSourceType($p(result,"^",1))
	s resultex=resultex_"^"
	i ($p(result,"^",4)'="")&&($p(result,"^",3)=1)  d //设备
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",4))),"^",1)
	i ($p(result,"^",4)'="")&&($p(result,"^",3)=2)  d //设备项
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",4))),"^",1)
	s resultex=resultex_"^"
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCResourceType",$p(result,"^",5))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",7))
	s resultex=resultex_"^"
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",10))
	s resultex=resultex_"^"
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",13))
	s resultex=resultex_"^"
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",14))),"^",2)
	s $p(result,"^",6)=##class(web.DHCEQCommon).FormatNumber($p(result,"^",6),"")
	s $p(result,"^",9)=##class(web.DHCEQCommon).FormatNumber($p(result,"^",9),"")
	s resultex=result_resultex
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	q rowid_"^"_resultex
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	&SQL(Delete From SQLUSER.DHC_EQUsedResource where UR_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 s PLIST(2)=$P(val,"^",2) //Year
 s Year=$P(val,"^",2)
 s PLIST(3)=$P(val,"^",3) //Month
 s Month=$P(val,"^",3)
 s PLIST(4)=$P(val,"^",4) //SourceType
 s SourceType=$P(val,"^",4)
 s PLIST(5)=$P(val,"^",5) //SourceID
 s SourceID=$P(val,"^",5)
 s PLIST(6)=$P(val,"^",6) //ResourceType
 s ResourceType=$P(val,"^",6)
 s PLIST(7)=$P(val,"^",7) //Price
 s PLIST(8)=$P(val,"^",8) //Uom
 s PLIST(9)=$P(val,"^",9) //Quantity
 s PLIST(10)=$P(val,"^",10) //Amount
 s PLIST(11)=$P(val,"^",11) //Loc
 s PLIST(15)=$P(val,"^",12) //Model
 s PLIST(30)=$p(val,"^",13) //Remark
 s PLIST(31)=##Class(web.DHCEQCommon).TransValueFromPage($P(val,"^",14),"bool") //IsInputFlag
 s PLIST(19)=0
 s RowidFind=""
 i (rowid="")  //新增按钮操作
 {
	 s PLIST(12)=+$H
	 s PLIST(13)=$P($H,",",2)
	 s PLIST(14)=User
	 //检测当前记录是否已经存在
	 &SQL(select UR_RowID into :RowidFind from DHC_EQUsedResource where UR_Year=:Year and UR_Month=:Month and UR_SourceType=:SourceType and UR_Status<>'3' and UR_SourceID=:SourceID and UR_ResourceTypeDR=:ResourceType)
	 i (RowidFind="") //当前记录为新记录,否则已经存在
	 {
		 &SQL(Insert Into SQLUSER.DHC_EQUsedResource Values :PLIST())
	 }
 }
 else  //更新按钮操作
 {
	 s PLIST(16)=+$H
	 s PLIST(17)=$P($H,",",2)
	 s PLIST(18)=User
	 &SQL(select UR_RowID into :RowidFind from DHC_EQUsedResource where UR_Year=:Year and UR_Month=:Month and UR_SourceType=:SourceType and UR_Status<>'3' and UR_SourceID=:SourceID and UR_ResourceTypeDR=:ResourceType)

	 i (RowidFind="")
	 {
		 &SQL(Update SQLUSER.DHC_EQUsedResource Values :PLIST() where UR_RowID = :rowid)
	 }
	 else
	 {
		 i (RowidFind=rowid)
		 {
			 &SQL(Update SQLUSER.DHC_EQUsedResource Values :PLIST() where UR_RowID = :rowid) 	 
		 }
	 }
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

/***********************************************************************/
ClassMethod GetEditURStatus(status As %Library.String) As %Status
{
	i status=""  q ""
	i +status=0  q "新增"
	i +status=1  q "提交"
	i +status=2  q "审核"
	i +status=3  q "作废"
	q "未定义"
}

/***********************************************************************/
ClassMethod UsedResourceOper(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", Oper As %Library.String = "")
{
	 k PLIST,rowid
	 s rowid=$p(val,"^",1)
	 s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	 i +Oper=1
	 {
		 s PLIST(19)=1
		 s PLIST(21)=+$H
		 s PLIST(22)=$P($H,",",2)
		 s PLIST(23)=User
	 }
	 i +Oper=2
	 {
		 s PLIST(19)=0
	 }
	 i +Oper=3
	 {
		 s PLIST(19)=2
		 s PLIST(24)=+$H
		 s PLIST(25)=$P($H,",",2)
		 s PLIST(26)=User
	 }
	 i +Oper=4
	 {
		 s PLIST(19)=3
		 s PLIST(27)=+$H
		 s PLIST(28)=$P($H,",",2)
		 s PLIST(29)=User
	 }
	 &SQL(Update SQLUSER.DHC_EQUsedResource Values :PLIST() where UR_RowID = :rowid) 
	 if SQLCODE  q SQLCODE
	 q rowid
}

/***********************************************************************/
/// w ##class(web.DHCEQUsedResource).AutoCreateUsedResource()
ClassMethod AutoCreateUsedResource(CurMonthFlag As %String = "")
{
	;i $P($ZD($H,3),"-",3)'="01" q
	//设备
	TSTART
	s SourceID=0
	s Error=0
	f  s SourceID=$o(^DHCEQEquipConsumable(0,"Source",1,SourceID)) q:(SourceID="")||(Error'=0)  d
	.s RTRowID=0
	.f  s RTRowID=$o(^DHCEQEquipConsumable(0,"Source",1,SourceID,RTRowID))  q:(RTRowID="")||(Error'=0)  d
	..s ECRowID=0
	..f  s ECRowID=$o(^DHCEQEquipConsumable(0,"Source",1,SourceID,RTRowID,ECRowID))  q:(ECRowID="")||(Error'=0)  d
	...s InvalidFlag=$p($g(^DHCEQEquip(SourceID)),"^",59)
	...q:InvalidFlag="Y"
	...s Status=$p($g(^DHCEQEquip(SourceID)),"^",38)
	...q:Status'=1
	...s CheckReturn=..CheckUsedResource(SourceID,ECRowID,CurMonthFlag)
	...q:CheckReturn=-1
	...i CheckReturn'=0  d
	....TROLLBACK
	....s Error=CheckReturn
	//设备项
	s SourceID=0
	f  s SourceID=$o(^DHCEQEquipConsumable(0,"Source",2,SourceID)) q:(SourceID="")||(Error'=0)  d
	.s RTRowID=0
	.f  s RTRowID=$o(^DHCEQEquipConsumable(0,"Source",2,SourceID,RTRowID))  q:(RTRowID="")||(Error'=0)  d
	..s ECRowID=0
	..f  s ECRowID=$o(^DHCEQEquipConsumable(0,"Source",2,SourceID,RTRowID,ECRowID))  q:(ECRowID="")||(Error'=0)  d
	...s UseLocDR=0
	...s Model=$p($g(^DHCEQEquipConsumable(ECRowID)),"^",9)
	...f  s UseLocDR=$o(^DHCEQEquip(0,"LocItem",UseLocDR))  q:(UseLocDR="")||(Error'=0)  d
	....s EQRowID=0
	....f  s EQRowID=$o(^DHCEQEquip(0,"LocItem",UseLocDR,SourceID,EQRowID))  q:(EQRowID="")||(Error'=0)  d
	.....s InvalidFlag=$p($g(^DHCEQEquip(EQRowID)),"^",59)
	.....q:InvalidFlag="Y"
	.....s Status=$p($g(^DHCEQEquip(EQRowID)),"^",38)
	.....q:Status'=1
	.....s ModelDR=$p($g(^DHCEQEquip(EQRowID)),"^",3)
	.....q:(Model'="")&&(ModelDR'=Model)
	.....s CheckReturn=..CheckUsedResource(EQRowID,ECRowID,CurMonthFlag)
	.....q:CheckReturn=-1
	.....i CheckReturn'=0  d
	......TROLLBACK
	......s Error=CheckReturn
	i Error'=0 q Error
	TCOMMIT
	q 0
}

ClassMethod CheckUsedResource(SourceID, ECRowID, CurMonthFlag)
{
	n (SourceID,ECRowID,CurMonthFlag)
	k PLIST
	;s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Year=+$p($ZD($H,3),"-",1)
	s Month=+$p($ZD($H,3),"-",2)
	i CurMonthFlag'="Y"
	{
		s Month=Month-1
		i Month=0
		{
			s Month=12
			s Year=Year-1
		}
	}
	s ResourceType=$p($g(^DHCEQEquipConsumable(ECRowID)),"^",3)
	s URRowID=0
	s Find=0
	f  s URRowID=$o(^DHCEQUsedResource(0,"YearMonth",Year,Month,ResourceType,URRowID))  q:(URRowID="")||(Find'=0)  d
	.s URStatus=$p($g(^DHCEQUsedResource(URRowID)),"^",18)
	.q:URStatus=3
	.s EquipDR=$p($g(^DHCEQUsedResource(URRowID)),"^",4)
	.i EquipDR=SourceID s Find=1
	i Find'=0 q -1
	s PLIST(2)=Year
	s PLIST(3)=Month
	s PLIST(4)=1
	s PLIST(5)=SourceID
	s PLIST(6)=ResourceType
	s PLIST(7)=$p($g(^DHCEQEquipConsumable(ECRowID)),"^",4)
	s PLIST(8)=$p($g(^DHCEQEquipConsumable(ECRowID)),"^",5)
	s PLIST(9)=$p($g(^DHCEQEquipConsumable(ECRowID)),"^",6)
	// add by zy 2014-09-15  ZY0117
	//通过成本核算组做的科室成本,来计算该科室设备的成本数据.
	s ExType=$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceType)),"^",8)  //DHCEQCResourceType   RT_ExType记录成本数据来源类型
	s ExID=$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceType)),"^",9)  //DHCEQCResourceType   RT_ExType字段成本核算项目ID
	s ExRate=+$p($g(^DHCEQEquipConsumable(ECRowID)),"^",8) //DHCEQEquipConsumable备注字段存分配比例
	s UseLocDR=$p($g(^DHCEQEquip(SourceID)),"^",19)
	i ExType="CA"
	{
		s CAResult=##Class(web.DHCEQ.Interface.DHCEQForCA).GetOutCAData($e($ZD($H,3),1,7),UseLocDR,ExID)
		s Fee=+$p(CAResult,"^",3)
		s PLIST(10)=##Class(web.DHCEQCommon).FormatNumber(Fee,"",2)
		i ExRate'="" s PLIST(10)=##Class(web.DHCEQCommon).FormatNumber(Fee*ExRate,"",2)
	}
	else
	{
		s PLIST(10)=##Class(web.DHCEQCommon).FormatNumber(PLIST(7)*PLIST(9),"",2)
	}
	
	s PLIST(15)=$p($g(^DHCEQEquipConsumable(ECRowID)),"^",9)
	s PLIST(19)=2
	s PLIST(20)=ECRowID
	s PLIST(11)=UseLocDR
	s PLIST(31)="N"
	s PLIST(12)=+$H
	s PLIST(13)=$P($H,",",2)
	;s PLIST(14)=User
	s PLIST(21)=+$H
	s PLIST(22)=$P($H,",",2)
	;s PLIST(23)=User
	s PLIST(24)=+$H
	s PLIST(25)=$P($H,",",2)
	;s PLIST(26)=User
	&SQL(Insert Into SQLUSER.DHC_EQUsedResource Values :PLIST())
	i SQLCODE  q SQLCODE
	q 0
}

/// w ##class(web.DHCEQUsedResource).SaveCostData(1,"^89^2011^4^1^2^3^4^5^6^")
ClassMethod SaveCostData(type, val)
{
	new Data,valLocID,valYear,valMonth,valSubmitFlag,valRowID ,LocID,Year,Month,SubmitFlag,rowid,ID
	s valRowID=$p(val,"^",1)	
	if +type=1
	{
		
		s valLocID=$p(val,"^",2)
		s valYear=$p(val,"^",3)
		s valMonth=$p(val,"^",4)
		s valSubmitFlag=$p(val,"^",11) 
		
		s (LocID,Year,Month,flag,rowid)=0
		s (Data,SubmitFlag,ID)=""
		i valRowID=""
		{
			if $Data(^DHCEQImport("DHCEQUsedResource"))'=0
			{
				for  set rowid=$Order(^DHCEQImport("DHCEQUsedResource",rowid)) quit:((rowid="")||(flag=1))  d
				.s Data=$G(^DHCEQImport("DHCEQUsedResource",rowid))
				.s LocID=$p(Data,"^",2)
				.s Year=$p(Data,"^",3)
				.s Month=$p(Data,"^",4)
				.s SubmitFlag=$p(Data,"^",11) 
				.s ID=rowid
				.if (valLocID=LocID)&&(valYear=Year)&&(valMonth=Month) s flag=1				
			}
			s rowid=ID+1
		}
		else
		{
			s rowid=valRowID
		}
		if flag=1 q "-1"
		s val=rowid_val
		s ^DHCEQImport("DHCEQUsedResource",rowid)=val
		quit rowid
	}
	else
	{
		if $Data(^DHCEQImport("DHCEQUsedResource",valRowID))'=0
		{
			s Data=$G(^DHCEQImport("DHCEQUsedResource",valRowID))
			s LocID=$p(Data,"^",2)
			s Year=$p(Data,"^",3)
			s Month=$p(Data,"^",4)
			s SubmitFlag=$p(Data,"^",11) 
			if SubmitFlag="Y" d ..DeleteImportCostDate(Loc,Year,Month)
			k ^DHCEQImport("DHCEQUsedResource",valRowID)
		}
		q 0
	}
}

/// w ##class(web.DHCEQUsedResource).DeleteImportDate("2011","6")
ClassMethod DeleteImportCostDate(Loc, Year, Month)
{
	new SQLCODE,RSType,ResourceType,URRowID
	TSTART
	s SQLCODE=0
	s RSType=0
	f  s RSType=$o(^DHCEQUsedResource(0,"YearMonth",Year,Month,RSType)) q:(RSType="")||(SQLCODE'=0)  d
	.s ResourceType=$p($g(^DHCEQCCode("DHCEQCResourceType",RSType)),"^",1)
	.q:(ResourceType'="001")&&(ResourceType'="002")&&(ResourceType'="003")&&(ResourceType'="004")
	.s URRowID=0
	.f  s URRowID=$o(^DHCEQUsedResource(0,"YearMonth",Year,Month,RSType,URRowID))  q:(URRowID="")||(SQLCODE'=0)  d
	..quit:$p(^DHCEQUsedResource(URRowID),"^",10)'=Loc
	..quit:$p(^DHCEQUsedResource(URRowID),"^",31)'="Y"
	..&SQL(Delete from SQLUSER.DHC_EQUsedResource where UR_RowID=:URRowID)
	if SQLCODE TROLLBACK	
	TCOMMIT
	q 0
}

/// w ##class(web.DHCEQUsedResource).SubmitCostData(2)
ClassMethod SubmitCostData(RowID)
{
	new flag,GYcost,GLcost,YFcost,ZJcost,Person,InCome,valLoc,valYear,valMonth,index,Loc,Year,Month,equipid
	new GYValue,GLValue,YFValue,ZJValue,StrMonth,Data
	if RowID="" q ""
	s SQLCODE=0
	if $Data(^DHCEQImport("DHCEQUsedResource",RowID))=0 quit ""
	
	s Data=$G(^DHCEQImport("DHCEQUsedResource",RowID))
	s LocID=$p(Data,"^",2)
	s Year=$p(Data,"^",3)
	s Month=$p(Data,"^",4)
 	s GYcost=$p(Data,"^",5)
 	s GLcost=$p(Data,"^",6)
 	s YFcost=$p(Data,"^",7)
 	s ZJcost=$p(Data,"^",8)
 	s Person=$p(Data,"^",9)
 	s InCome=$p(Data,"^",10)
	s SubmitFlag=$p(Data,"^",11) 
	s StrMonth=Year_"-"_Month
 	if SubmitFlag="Y" quit ""
 	if $Data(^DHCEQEquip(0,"StoreLoc",LocID))=0  quit ""
 	s equipid=0
 	for  set equipid=$o(^DHCEQEquip(0,"StoreLoc",LocID,equipid)) quit:((equipid="")||(SQLCODE'=0))  d
 	.quit:##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(equipid)=0
 	.s (GYValue,GLValue,YFValue,ZJValue)=0
 	.s GYValue=..DivideSchemes("001",GYcost,equipid,Person,InCome,StrMonth)
 	.s SQLCODE=..InsertUsedResource(1, equipid,"001",GYValue,StrMonth)
 	.i SQLCODE s SQLCODE=SQLCODE_"^001"
 	.quit:SQLCODE'=0
 	.s GLValue=..DivideSchemes("002",GLcost,equipid,Person,InCome,StrMonth)
 	.s SQLCODE=..InsertUsedResource(1, equipid,"002",GLValue,StrMonth)
 	.i SQLCODE s SQLCODE=SQLCODE_"^002"
 	.quit:SQLCODE'=0
 	.s YFValue=..DivideSchemes("003",YFcost,equipid,Person,InCome,StrMonth)
 	.s SQLCODE=..InsertUsedResource(1, equipid,"003",YFValue,StrMonth)
 	.i SQLCODE s SQLCODE=SQLCODE_"^003"
 	.quit:SQLCODE'=0
 	.s ZJValue=..DivideSchemes("004",ZJcost,equipid,Person,InCome,StrMonth)
 	.s SQLCODE=..InsertUsedResource(1, equipid,"004",ZJValue,StrMonth)
 	.i SQLCODE s SQLCODE=SQLCODE_"^004"
 	.quit:SQLCODE'=0 	
 	i SQLCODE'=""
 	{
	 	s result=$p(SQLCODE,"^",1)
	 	s code=$p(SQLCODE,"^",2)
	 	i result=-1 s SQLCODE=code_"没有定义"
	}
	s SubmitFlag="Y"
	s val=RowID_"^"_LocID_"^"_Year_"^"_Month_"^"_GYcost_"^"_GLcost_"^"_YFcost_"^"_ZJcost_"^"_Person_"^"_InCome_"^"_SubmitFlag
	s ^DHCEQImport("DHCEQUsedResource",RowID)=val
 	q SQLCODE
}

/// w ##class(web.DHCEQUsedResource).DivideSchemes("002","120525.26","8022",30,"1000000")
ClassMethod DivideSchemes(Type, valCost, EquipID, valPerson, valInCome, StrMonth)
{
	new cost,Person,ResourceTypeID,Code,ECRowID,ECRowID
	new TotalFee,CurDate,Month,BeginDate,EndDate,URRowID,Fee
	set cost=0
	if (Type="001")||(Type="002")
	{
		s Person=0
		s ResourceTypeID=0
		for  set ResourceTypeID=$order(^DHCEQEquipConsumable(0,"Source",1,EquipID,ResourceTypeID)) quit:(ResourceTypeID="")||(Person'=0)  d
		.quit:$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",1)="Y"
		.s (Code,ECRowID)=""
		.s Code=$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",1)
		.quit:Code'="02"
		.set ECRowID=$order(^DHCEQEquipConsumable(0,"Source",1,EquipID,ResourceTypeID,ECRowID))
		.if ECRowID'="" s Person=$p($g(^DHCEQEquipConsumable(ECRowID)),"^",6)
		if Person'=0 set cost=valCost*(Person/valPerson)		
	}
	else
	{
		s TotalFee=0
		//s CurDate=$ZD(62200,3)
		//s Month=$p(CurDate,"-",1,2)
		s Month=StrMonth
		s BeginDate=$ZDH(Month_"-01",3)
		s EndDate=##Class(web.DHCEQCommon).GetMonthEndDate(Month)
		s EndDate=BeginDate+EndDate
		s BeginDate=BeginDate-1
		for  set BeginDate=$Order(^DHCEQUseRecord(0,"UseDate",BeginDate)) quit:((BeginDate="")||(BeginDate>EndDate))  d
		.set URRowID=0
		.quit:($Data(^DHCEQUseRecord(0,"UseDate",BeginDate,1,EquipID)))="0"
		.for  set URRowID=$Order(^DHCEQUseRecord(0,"UseDate",BeginDate,1,EquipID,URRowID)) quit:URRowID=""  d
		..quit:$p($g(^DHCEQUseRecord(URRowID)),"^",19)'="2"
		..quit:$p($g(^DHCEQUseRecord(URRowID)),"^",20)="Y"
		..set Fee=$p($g(^DHCEQUseRecord(URRowID)),"^",12)
		..set TotalFee=TotalFee+Fee
		if TotalFee'=0 s cost=valCost*(TotalFee/valInCome)
	}
	s cost=##Class(web.DHCEQCommon).FormatNumber(cost,"",2)
	q cost
}

ClassMethod InsertUsedResource(SourceType, SourceID, Type, cost, StrMonth)
{
	new Year,Month,RTRowID,SQLCODE
	k PLIST
	//s Year=+$p($ZD($H,3),"-",1)
	//s Month=+$p($ZD($H,3),"-",2)
	s Year=+$p(StrMonth,"-",1)
	s Month=+$p(StrMonth,"-",2)
	s PLIST(2)=Year
	s PLIST(3)="4"
	s PLIST(4)=SourceType
	s PLIST(5)=SourceID
	s RTRowID=$o(^DHCEQCCode("DHCEQCResourceType",0,Type,0))
	i RTRowID="" q -1
	s PLIST(6)=RTRowID
	s PLIST(7)=""
	s PLIST(8)=""
	s PLIST(9)=""
	s PLIST(10)=cost
	s PLIST(11)=$p($g(^DHCEQEquip(SourceID)),"^",19)
	s PLIST(12)=+$H
	s PLIST(13)=$P($H,",",2)
	;s PLIST(14)=User	
	s PLIST(15)=""
	
	s PLIST(19)=2
	//s PLIST(20)=""
	s PLIST(21)=+$H
	s PLIST(22)=$P($H,",",2)
	;s PLIST(23)=User
	s PLIST(24)=+$H
	s PLIST(25)=$P($H,",",2)
	;s PLIST(26)=User
	s PLIST(31)="N"
	s PLIST(32)="Y"	//导入数据标志
	&SQL(Insert Into SQLUSER.DHC_EQUsedResource Values :PLIST())
	i SQLCODE  q SQLCODE
	q 0
}

/// 修改：zy 2009-07-22   zy0007
/// 描述:设备入库管理中，库房要从属于库房这一类的科室中选择
/// 增加参数:LocType：科室类型代码
/// 备注:科室类型：1，库房；0，科室
/// d ##class(%ResultSet).RunQuery("web.DHCEQUsedResource","GetLocCost")
Query GetLocCost() As %Query(ROWSPEC = "TRowID:%String,TLoc:%String,TLocDR:%String,TYear:%String,TMonth:%String,TGYCost:%String,TGLCost:%String,TYFCost:%String,TZJCost:%String,TPerson:%String,TInCome:%String")
{
}

ClassMethod GetLocCostExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	if $Data(^DHCEQImport("DHCEQUsedResource"))'=0
	{
		s rowid=0
		for  set rowid=$Order(^DHCEQImport("DHCEQUsedResource",rowid)) quit:rowid=""  d
		.s Data=$G(^DHCEQImport("DHCEQUsedResource",rowid))
		.quit:Data=""
		.d ResetVariablesGetLocCost
		.s TRowID=rowid
		.s TLocDR=$p(Data,"^",2)
		.i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
		.s TYear=$p(Data,"^",3)
		.s TMonth=$p(Data,"^",4)
	 	.s TGYCost=$p(Data,"^",5)
	 	.s TGLCost=$p(Data,"^",6)
	 	.s TYFCost=$p(Data,"^",7)
	 	.s TZJCost=$p(Data,"^",8)
	 	.s TPerson=$p(Data,"^",9)
	 	.s TInCome=$p(Data,"^",10)
		.s TSubmitFlag=$p(Data,"^",11) 
		.d OutputRowGetLocCost
	}	
	Quit $$$OK
OutputRowGetLocCost
	s Data=$lb(TRowID,TLoc,TLocDR,TYear,TMonth,TGYCost,TGLCost,TYFCost,TZJCost,TPerson,TInCome)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetLocCost
	s (TRowID,TLoc,TLocDR,TYear,TMonth,TGYCost,TGLCost,TYFCost,TZJCost,TPerson,TInCome)=""
	quit
}

ClassMethod GetLocCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocCostExecute ]
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

ClassMethod GetLocCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocCostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/***********************************************************************/
/// w ##class(web.DHCEQUsedResource).GetLocCostStatus(1)
ClassMethod GetLocCostStatus(RowID)
{
	new SubmitFlag
	s SubmitFlag=""
	if $Data(^DHCEQImport("DHCEQUsedResource",RowID))=0 quit ""
	s SubmitFlag=$p($G(^DHCEQImport("DHCEQUsedResource",RowID)),"^",11) 
 	q SubmitFlag
}

/// 取设备对应成本数据
/// add by zy 2017-09-05
/// 入参：	SourceType:		YYYY 
/// 			SourceID:	YYYY-MM 
/// 	输出:	TRowID
/// 		TYear,				年
/// 			TMonth,				月
/// 			TResourceTypeDR,	成本类型
/// 			TPrice,				单价
/// 			TQuantity,			数量
/// 			TAmount,			总金额
/// 			TRemark,			备注
/// 			TIsInputFlag,		是否导入
/// 			THold1,				售价总金额
/// 			THold2,				Hold2
/// 			THold3,				Hold3
/// 			THold4,				Hold4
/// 			THold5,				Hold5
/// d ##class(%ResultSet).RunQuery("web.DHCEQUsedResource","GetUsedResourceBySource")
Query GetUsedResourceBySource(SourceType As %String = "", SourceID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TYear:%String,TMonth:%String,TSourceType:%String,TSourceID:%String,TResourceTypeDR:%String,TPrice:%String,TQuantity:%String,TAmount:%String,TIsInputFlag:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String") [ SqlProc ]
{
}

ClassMethod GetUsedResourceBySourceExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (SourceType="")||(SourceID="") d
	.s rowid=0
	.f  s rowid=$o(^DHCEQUsedResource(rowid))  quit:rowid=""  d
	..s DataList=$g(^DHCEQUsedResource(rowid))
	..d BuildDataList
	e  d
	.q:'$Data(^DHCEQUsedResource(0,"Source",SourceType,SourceID))
	.s rowid=0
	.f  s rowid=$o(^DHCEQUsedResource(0,"Source",SourceType,SourceID,rowid))  quit:rowid=""  d
	..s DataList=$g(^DHCEQUsedResource(rowid))
	..d BuildDataList
	Quit $$$OK
BuildDataList
	d ResetVariablesGetUsedResourceBySource
	q:$p(DataList,"^",18)'="2"
	s TRowID = rowid	//rowid
	s TYear=$p(DataList,"^",1)
	s TMonth=$p(DataList,"^",2)
	s TSourceType=$p(DataList,"^",3)
	s TSourceID=$p(DataList,"^",4)
	s TResourceTypeDR=$p(DataList,"^",5)
	s TPrice=$p(DataList,"^",6)
	s TQuantity=$p(DataList,"^",8)
	s TAmount=$p(DataList,"^",9)
	s TRemark=$p(DataList,"^",29)
	s TIsInputFlag=$p(DataList,"^",30)
	s THold1=$p(DataList,"^",30)
	s THold2=$p(DataList,"^",31)
	s THold3=$p(DataList,"^",32)
	s THold4=$p(DataList,"^",33)
	s THold5=$p(DataList,"^",34)
	d OutputRowGetUsedResourceBySource
	quit 
OutputRowGetUsedResourceBySource
	s Data=$lb(TRowID,TYear,TMonth,TSourceType,TSourceID,TResourceTypeDR,TPrice,TQuantity,TAmount,TIsInputFlag,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetUsedResourceBySource
	s (TRowID,TYear,TMonth,TSourceType,TSourceID,TResourceTypeDR,TPrice,TQuantity,TAmount,TIsInputFlag,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod GetUsedResourceBySourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUsedResourceBySourceExecute ]
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

ClassMethod GetUsedResourceBySourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUsedResourceBySourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 写每月消耗材料的成本数据
/// d ##class(web.DHCEQUsedResource).SaveUsedResource("2017","7","2","13383","12","200")
ClassMethod SaveUsedResource(Year, Month, SourceType, SourceID, ResourceTypeCode, Amount, PayAmount As %String = 0)
{
	new SQLCODE,ResourceTypeDR,RowidFind
	s SQLCODE=0
	//取材料成本类型ID
	s ResourceTypeDR=""
	&SQL(select RT_RowID into :ResourceTypeDR from SQLUSER.DHC_EQCResourceType where RT_Code=:ResourceTypeCode)
	
	k URLIST
 	s URLIST(2)=Year
 	s URLIST(3)=Month
 	s URLIST(4)=SourceType
 	s URLIST(5)=SourceID
 	s URLIST(6)=ResourceTypeDR
 	s URLIST(10)=Amount
	s URLIST(19)=2
 	s URLIST(32)=PayAmount
 	s RowidFind=""
	&SQL(select UR_RowID into :RowidFind from SQLUSER.DHC_EQUsedResource where UR_Year=:Year and UR_Month=:Month and UR_SourceType=:SourceType and UR_SourceID=:SourceID and UR_ResourceTypeDR=:ResourceTypeDR)
	
	i (RowidFind="") d
	.&SQL(Insert into SQLUSER.DHC_EQUsedResource Values :URLIST())
	e  d
	.&SQL(Update SQLUSER.DHC_EQUsedResource Values :URLIST() where UR_RowID = :RowidFind)
	.i SQLCODE=100 s SQLCODE=0
	q SQLCODE
}

ClassMethod SaveAllUsedResource(val)
{
    Set $ZT="ERROR" //2009-08-10 党军
	TSTART //2009-08-10 党军
	s (UsedResource,Year, Month, SourceType, SourceID, ResourceTypeCode, Amount)=""
    s length=$l(val,"&")
	f i=1:1:length  d
	.s UsedResource=$p(val,"&",i)
	.s Year=$p(UsedResource,"^",1)
	.s Month=$p(UsedResource,"^",2)
	.s SourceType=$p(UsedResource,"^",3)
	.s SourceID=$p(UsedResource,"^",4)
	.s ResourceTypeCode=$p(UsedResource,"^",5)
	.s Amount=$p(UsedResource,"^",6)
	.s SQLCODE=..SaveUsedResource(Year, Month, SourceType, SourceID, ResourceTypeCode, Amount)
	.q:SQLCODE'=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
    q SQLCODE
ERROR 
	Set ErrorMsg=$ZE	          
	TROLLBACK		      
	Quit "<ERROR>"_ErrorMsg
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQUsedResource","GetUsedResourceFee","1","13383")
Query GetUsedResourceFee(SourceType As %String = "", SourceID As %String = "") As %Query(ROWSPEC = "TYear:%String,TMonth:%String,TTypeFee:%String")
{
}

ClassMethod GetUsedResourceFeeExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Year=0
	f  s Year=$o(^DHCEQUsedResource(0,"SourceDate",2,SourceType,SourceID,Year))  q:Year=""  d
	.s Month=0
	.f  s Month=$o(^DHCEQUsedResource(0,"SourceDate",2,SourceType,SourceID,Year,Month)) q:Month=""  d
	..s TType=""
	..s URRowID=0
	..f  s URRowID=$o(^DHCEQUsedResource(0,"SourceDate",2,SourceType,SourceID,Year,Month,URRowID))  q:URRowID=""  d
	...s TResourceType=$p($g(^DHCEQUsedResource(URRowID)),"^",5)
	...s TAmount=$p($g(^DHCEQUsedResource(URRowID)),"^",9)
	...i TType=""  s TType=TResourceType_"^"_TAmount
	...e  s TType=TType_"&"_TResourceType_"^"_TAmount
	..d OutputRowGetUsedResourceFee
	
	Quit $$$OK
OutputRowGetUsedResourceFee
	s Data=$lb(Year,Month,TType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetUsedResourceFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUsedResourceExecute ]
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

ClassMethod GetUsedResourceFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUsedResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQUsedResource","GetUsedResourceFeeDetail",1,13383,"2017","7")
Query GetUsedResourceFeeDetail(SourceType As %String = "", SourceID As %String = "", Year As %String = "", Month As %String = "") As %Query(ROWSPEC = "TRowID:%String,TTypeRowID:%String,TTypeCode:%String,TTypeDesc:%String,TAmount:%String")
{
}

ClassMethod GetUsedResourceFeeDetailExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", Year As %String = "", Month As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s (TRowID)=""
	if (Year=""&&Month="")  d
	f  s rowid=$o(^DHCEQCCode("DHCEQCResourceType",rowid))  q:rowid=""  d
	.s (TypeInfo,TTypeCode,TTypeDesc,TRowID,TypeRowID)=""
	.s TTypeRowID=rowid
	.s TypeInfo=^DHCEQCCode("DHCEQCResourceType",rowid)
	.s TTypeCode=$p(TypeInfo,"^",1)
	.s TTypeDesc=$p(TypeInfo,"^",2)
	.s TInvalidFlag=$p(TypeInfo,"^",4) // add by sjh SJH0045 2021-02-20
	.q:TInvalidFlag="Y" 			   // add by sjh SJH0045 2021-02-20
	.s URRowID=""
	.s (TAmount)=""
	.i (Year'="")&&(Month'="")  d
	..f  s URRowID=$o(^DHCEQUsedResource(0,"SourceDate",2,SourceType,SourceID,Year,Month,URRowID))  q:URRowID=""  d
	...i rowid=$p($g(^DHCEQUsedResource(URRowID)),"^",5)  d
	....;s (TAmount)=""
	....s TRowID=URRowID
	....s TAmount=$p($g(^DHCEQUsedResource(TRowID)),"^",9)

	.d OutputRowGetUsedResourceFeeDetail
	
	Quit $$$OK
OutputRowGetUsedResourceFeeDetail
	s Data=$lb(TRowID,TTypeRowID,TTypeCode,TTypeDesc,TAmount)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetUsedResourceFeeDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUsedResourceExecute ]
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

ClassMethod GetUsedResourceFeeDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUsedResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
