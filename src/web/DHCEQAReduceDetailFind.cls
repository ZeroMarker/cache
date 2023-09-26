Class web.DHCEQAReduceDetailFind Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modify BY:GBX GBX0015 配件退货详细查询
/// d ##Class(%ResultSet).RunQuery("web.DHCEQAReduceDetailFind","GetReturnDetail")
Query GetReturnDetail(vData As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TISRowID:%String,TProviderDR:%String,TProvider:%String,TMakeDate:%String,TISNo:%String,TLocDR:%String,TLoc:%String,TAccessoryTypeDR:%String,TAccessoryType:%String,TStatus:%String,TAccessory:%String,TPrice:%String,TQuantityNum:%String,TTotalFee:%String,TJob:%String,TApproveStep:%String,TApproveRole:%String,TReduceType:%String,TReturnTypeDR:%String,TRow:%String")
{
}

ClassMethod GetReturnDetailExecute(ByRef qHandle As %Binary, vData As %String = "", QXType As %String = "") As %Status
{
 	new repid, index,rowid,Total,TotalFee,PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	d ##Class(web.DHCEQCommon).KillTempGlobal("AReduceDetail")
 	/**************************************************/
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set LocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"LocDR")
	Set Status=##Class(web.DHCEQCommon).GetDataByName(vData,"Status")
	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(vData,"StartDate")
	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndDate")	
	Set MinPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MinPrice")
	Set MaxPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MaxPrice")
	Set ProviderDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")
	Set Name=##Class(web.DHCEQCommon).GetDataByName(vData,"Name")
	Set AccessoryTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"AccessoryTypeDR")
	Set ReduceNo=##Class(web.DHCEQCommon).GetDataByName(vData,"ReduceNo")
	Set ReduceType=##Class(web.DHCEQCommon).GetDataByName(vData,"ReduceType")
	
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	/**************************************************/
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	s index=2
	s ISRowID=0
	s rowid=0
	s Total=0
	s TotalFee=0
	s PNum=1
	s TRow=1 //add by zx 2015-09-15 BugZX0032
	s TJob=$J
	d BuildDataGetReturnDetail
	Quit $$$OK
BuildDataGetReturnDetail
	i vData="" q
	i StartDate>EndDate q
	f  s ISRowID=$o(^DHCEQAReduce(ISRowID))  quit:ISRowID=""  d
	.s TLocDR=$p(^DHCEQAReduce(ISRowID),"^",4)
	.q:(LocDR'="")&&(LocDR'=TLocDR)
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
	.s TStatusDR=$p(^DHCEQAReduce(ISRowID),"^",23)
	.q:TStatusDR=3 //modify BY:GBX 2014-9-13 15:02:34
	.q:(Status'="")&&(TStatusDR'=Status)
	.s TMakeDate=$p($g(^DHCEQAReduce(ISRowID)),"^",8) //退货日期
	.q:(TMakeDate>EndDate)||(TMakeDate<StartDate)
	.s TAccessoryTypeDR=$p($g(^DHCEQAReduce(ISRowID)),"^",2) //配件类组
	.q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR))
	.s rowid=0
	.f  s rowid=$o(^DHCEQAReduceList(0,"Reduce",ISRowID,rowid))  quit:rowid=""  d
	..s TPrice=$p(^DHCEQAReduceList(rowid),"^",9)
	..q:(MaxPrice'="")&&(TPrice>MaxPrice)
	..q:(MinPrice'="")&&(TPrice<MinPrice)
	..d GetOneInStockDetail
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		d ResetVariablesGetReturnDetail
		s TQuantityNum=Total
		s TTotalFee=TotalFee
		s TRow="合计:"
		
		//add by jdl 2009-9-25  JDL0036
		//格式化金额为小数点两位
		i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",4)
		s Data=$lb(TISRowID,TProviderDR,TProvider,TMakeDate,TISNo,TLocDR,TLoc,TAccessoryTypeDR,TAccessoryType,TStatus,TAccessory,TPrice,TQuantityNum,TTotalFee,TJob,TApproveStep,TApproveRole,TReduceType,TReturnTypeDR,TRow)
		Set ^CacheTemp(repid,TotalLoc)=Data
		Set ^DHCEQTemp("AReduceDetail",+$H,TJob,PNum)=TISNo_"^"_TLoc_"^"_TProvider_"^"_TAccessory_"^"_TPrice_"^"_TQuantityNum_"^"_TTotalFee
	}
	quit
GetOneInStockDetail
	d ResetVariablesGetReturnDetail
	s TISRowID=ISRowID
	
	s TMakeDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAReduce(TISRowID)),"^",8),"date")
	s TReduceType=$p($g(^DHCEQAReduce(TISRowID)),"^",3)  //减少类型
	s TReturnTypeDR=TReduceType		//Add By DJ 2014-09-13
	q:(ReduceType'="")&(ReduceType'=TReduceType)
	q:(ReduceType="")&&(1=TReduceType)	//需求号:270539	Mozy	2016-11-4
	if TReduceType'=""  d
	.s TReduceType=$CASE(TReduceType,"1":"退货","2":"报损","3":"消耗","4":"盘亏","9":"其他")	//Modify DJ 2014-09-10
	s TISNo=$p($g(^DHCEQAReduce(TISRowID)),"^",1)
	q:(ReduceNo'="")&&(TISNo'=ReduceNo)
	s TLocDR=$p($g(^DHCEQAReduce(TISRowID)),"^",4)
	i TLocDR'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	s TAccessoryTypeDR=$p($g(^DHCEQAReduce(TISRowID)),"^",2)
	q:(AccessoryTypeDR'="")&&(TAccessoryTypeDR'=AccessoryTypeDR)
	s result=##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)
	q:+result'=0
	i TAccessoryTypeDR '=""  d
	.s TAccessoryType = $p($g(^DHCEQCCode("DHCEQCAccessoryType",TAccessoryTypeDR)),"^",2)
	s TStatus=$p($g(^DHCEQAReduce(TISRowID)),"^",23)
	s TAccessory=$p($g(^DHCEQAStockDetail($p(^DHCEQAReduceList(rowid),"^",5))),"^",5) //配件名称
	q:(Name'="")&(TAccessory'[Name)	
	//add by wy 2017-5-24
	//根据减少类型获取供应商	
	if $p($g(^DHCEQAReduce(TISRowID)),"^",3)="1" d                                     
	.s TProviderDR=$p($g(^DHCEQAReduce(TISRowID)),"^",6)
	e  d        
	.s TProviderDR=$p(^DHCEQAStockDetail($p(^DHCEQAReduceList(rowid),"^",5)),"^",16)
	q:(ProviderDR'="")&&(ProviderDR'=TProviderDR)
	s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)     
	s TPrice=$p(^DHCEQAReduceList(rowid),"^",9)
	s TQuantityNum=$p(^DHCEQAReduceList(rowid),"^",10)
	s TTotalFee=TPrice*TQuantityNum
	s Total=Total+TQuantityNum
	s TotalFee=TotalFee+TTotalFee
	//add by jdl 2009-9-25  JDL0036
	//格式化金额为小数点两位
	i TPrice'="" s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice,"",4)
	i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",4)
	i TStatus'=0  d
	.s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("21",TISRowID) //21:配件退货
	.i ApproveInfo'=""  d
	..s TApproveRole=$p(ApproveInfo,"^",9)
	..s TApproveStep=$p(ApproveInfo,"^",5) //2010-08-31 DJ end
	s TStatus=$CASE(TStatus,"0":"新增","1":"提交","2":"审核","3":"作废",:"没有定义")
	d OutputRowGetReturnDetail
	quit
OutputRowGetReturnDetail
	s Data=$lb(TISRowID,TProviderDR,TProvider,TMakeDate,TISNo,TLocDR,TLoc,TAccessoryTypeDR,TAccessoryType,TStatus,TAccessory,TPrice,TQuantityNum,TTotalFee,TJob,TApproveStep,TApproveRole,TReduceType,TReturnTypeDR,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set ^DHCEQTemp("AReduceDetail",+$H,TJob,PNum)=TISNo_"^"_TLoc_"^"_TProvider_"^"_TAccessory_"^"_TPrice_"^"_TQuantityNum_"^"_TTotalFee
	Set PNum=PNum+1
	Set TRow=TRow+1
	Set index=index+1
	quit
ResetVariablesGetReturnDetail
	s (TISRowID,TProviderDR,TProvider,TMakeDate,TISNo,TLocDR,TLoc,TAccessoryTypeDR,TAccessoryType,TStatus,TAccessory,TPrice,TQuantityNum,TTotalFee,TUseYearsNum,TApproveStep,TApproveRole,TReduceType,TReturnTypeDR)=""
	quit
}

ClassMethod GetReturnDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReturnDetailExecute ]
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

ClassMethod GetReturnDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReturnDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// -------------------------------
/// 描述:取到打印导出的查询信息
/// -------------------------------
ClassMethod GetOneReturnDetail(PNum, job)
{
	i PNum=0 q $o(^DHCEQTemp("AReduceDetail",+$H,job,""),-1)
	q $g(^DHCEQTemp("AReduceDetail",+$H,job,PNum))
}

ClassMethod StatusList(name, width, Type) As %String
{
	;;下拉列表
	//w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"") //add hly 2019-04-26
	w "<option value=></option>"
	;i (Type="")||(Type="0") 
	w "<option value=0>新增</option>"	
	;i Type'="2" 
	w "<option value=1>提交</option>"
	w "<option value=2>审核</option>"
	//w "<option value=3>作废</option>"
	w "</select>",!
}

/// Modify DJ 2014-09-10
ClassMethod ReduceTypeList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=1>退货</option>"
	w "<option value=2>报损</option>"
	w "<option value=3>消耗</option>"
	w "<option value=4>盘亏</option>"
	w "<option value=9>其他</option>"
	w "</select>",!
}

}
