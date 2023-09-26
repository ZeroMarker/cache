Import SQLUser

/// Created by JDL  2007-4
Class web.DHCPE.ItemFeeList Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query FindItemFeeList(SplitType As %Library.String = "", InvPrtId As %Library.String = "", PreAudits As %Library.String = "", SelectIds As %Library.String = "", ReadOnlyFlag As %Library.String = "", ADMType As %Library.String = "", GIADM As %Library.String = "", ARCIMID As %Library.String = "", OrdSetID As %Library.String = "", Name As %Library.String = "", Status As %Library.String = "", CSPName As %Library.String = "") As %Query(ROWSPEC = "RecordSum:%String,ItemName:%String,FeeType:%String,FeeTypeDesc:%String,RowId:%String,AddOrdItem:%String,FactAmount:%String,PrivilegeMode:%String,Privilege:%String,PAuditDR:%String,UpdateUserDR:%String,UpdateDate:%String,UpdateTime:%String,OrdStatus:%String,OrdStatusDesc:%String,Checked:%String,PatName:%String,PatRegNo:%String,ARCOSName")
{
}

ClassMethod FindItemFeeListExecute(ByRef qHandle As %Binary, SplitType As %Library.String = "", InvPrtId As %Library.String = "", PreAudits As %Library.String = "", SelectIds As %Library.String = "", ReadOnlyFlag As %Library.String = "", ADMType As %Library.String = "", GIADM As %Library.String = "", ARCIMID, OrdSetID, Name As %Library.String = "", Status As %Library.String = "", CSPName As %Library.String = "") As %Status
{
	
	new i,preAuditId,subroot,preAdmId,childsub,feesub,errs
	new ItemName,FeeType,RowId,AddOrdItem,FactAmount,PrivilegeMode,Privilege,PAuditDR,UpdateUserDR,UpdateDate,UpdateTime,OrdStatus,OrdStatusDesc,Checked
	new patName
   	s Job=$J
    k ^TempDHCPEFeeList(Job)

    i (Name'="") s SplitType="person"
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=2
 	///get PreAudits from invid
 	new billId,relateid
 	s:OrdSetID'="" ARCIMID=""
 	if InvPrtId'=""  d
 	.s PreAudits=""
 	.s billId=$p($g(^DHCPEINVPRT(InvPrtId)),"^",3)
 	.q:billId=""
 	.s relateid=""
 	.f  s relateid=$o(^DHCPEPAPBR(0,"PBDR",billId,relateid)) q:((relateid=""))  d
 	..i PreAudits'=""  s PreAudits=PreAudits_","
 	..s PreAudits=PreAudits_$p($g(^DHCPEPAPBR(relateid)),"^",1)
	
		
 	Q:(""=PreAudits) $$$OK
 	
 	s errs=""
 	s i=1
	while(i<=$l(PreAudits,",")){
		s preAuditId=$p(PreAudits,",",i)
		q:preAuditId=""
		//preAuditId 为审核表的rowid
		//按人员拆分
		s quitFlag=0
		s PAADMType=$p(^DHCPEPreA(preAuditId) ,"^",1)
		i (PAADMType="G")&&(SplitType="person" ) d
		.s quitFlag=1
		.s preAdmId=""
		.s preAdmIds=""
		.f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:((preAdmId="")||(errs'=""))  d
		..d ClearData
		..;s ItemName=$p($g(^DHCPEPreIADM(preAdmId)),"^",8)  //人员状态
		..s (patName,PatRegNo,ItemName)=""
		..s FeeTypeDesc="人员"
		..s PIBI=$p($g(^DHCPEPreIADM(preAdmId)),"^",1)
		..i PIBI'="" d
		...s patName=$p($g(^DHCPEPreIBI(PIBI)),"^",2)
		...s PatRegNo=$p($g(^DHCPEPreIBI(PIBI)),"^",1)
		..;s ItemName=patName
		..s ItemName=$p($g(^DHCPEPreIADM(preAdmId)),"^",8)
		..s ItemName=##Class(web.DHCPE.PreCommon).TransStatus(ItemName)
		..q:(Status'="")&&(ItemName'=Status)
		..q:(Name'="")&&(patName'="")&&(patName'[Name)
		..i (CSPName'="") s ItemName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,ItemName)  //翻译
		..//处理项目
		..s childsub=""
		..s subroot="ORDITEM"
		..f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
		...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
		...s feesub=0
		...f  s feesub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
		....s tempRowId=preAdmId_"||"_childsub_"||"_feesub_",1"
		....d GetGroupFee
		..
		..//处理个人有项目时的套餐
		..s childsub=""
		..s subroot="ORDENT"
		..f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
		...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
		...s feesub=0
		...f  s feesub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
		....s tempRowId=preAdmId_"||"_childsub_"||"_feesub_",2"
		....d GetGroupFee
		..q:tempRowId=""
		..s RowId=preAdmId
		..i RowId'="" d OutItemFee
		..s preAdmIds=preAdmIds_","_preAdmId
		.//处理纯套餐人员信息
		.s subroot="ORDENT"
		.s preAdmId=""
		.f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId)) q:((preAdmId="")||(errs'=""))  d
		..q:preAdmIds[preAdmId
		..d ClearData
		..s patName=$p($g(^DHCPEPreIADM(preAdmId)),"^",1)
		..i patName'="" s patName=$p($g(^DHCPEPreIBI(patName)),"^",2)
		..s ItemName=$p($g(^DHCPEPreIADM(preAdmId)),"^",8)
		..s ItemName=##Class(web.DHCPE.PreCommon).TransStatus(ItemName)
		..q:(Status'="")&&(ItemName'=Status)
		..i (CSPName'="") s ItemName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,ItemName) //翻译
		..q:(Name'="")&&(patName'="")&&(patName'[Name)
		..s childsub=""
		..f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
		...
		...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
		...
		...s feesub=0
		...f  s feesub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
		....s tempRowId=preAdmId_"||"_childsub_"||"_feesub_",2"
		....d GetGroupFee
		..s RowId=preAdmId
		..i RowId'="" d OutItemFee
		q:quitFlag=1
		
		
		//按团体分组拆分
		i (PAADMType="G")&&(SplitType="group" ) d
		.s quitFlag=1
		.s preGAdmId=$p(^DHCPEPreA(preAuditId) ,"^",2)
		.q:preGAdmId=""
		.s FeeTypeDesc="分组"
		.s GTchildsub=0
		.f  s GTchildsub=$o(^DHCPEPreGADM(preGAdmId,"Team",GTchildsub)) q:GTchildsub=""  d
		..s GTeamId=preGAdmId_"||"_GTchildsub
		..s preAdmId=""
		..d ClearData 
		..f  s preAdmId=$o(^DHCPEPreIADM(0,"PGTeam",GTeamId,preAdmId)) q:preAdmId=""  d
		...s patName=$p($g(^DHCPEPreIADM(preAdmId)),"^",1)
		...i patName'="" s patName=$p($g(^DHCPEPreIBI(patName)),"^",2)
		...//处理项目
		...s childsub=""
		...s subroot="ORDITEM"
		...f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
		....q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
		....s feesub=0
		....f  s feesub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
		.....s tempRowId=preAdmId_"||"_childsub_"||"_feesub_",1"
		.....d GetGroupFee
		...//处理套餐
		...s childsub=""
		...s subroot="ORDENT"
		...f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
		....q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
		....s feesub=0
		....f  s feesub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
		.....s tempRowId=preAdmId_"||"_childsub_"||"_feesub_",2"
		.....d GetGroupFee
		..//组的名词
		..s FeeTypeDesc="分组"
		..s patName=$p($g(^DHCPEPreGADM(preGAdmId,"Team",GTchildsub)),"^",1)
		..q:tempRowId=""
		..s RowId=preGAdmId_"||"_GTchildsub
		..i RowId'="" d OutItemFee
		q:quitFlag=1
		//add ++
		///处理审核记录对应的项目
		s subroot="ORDITEM"
		s preAdmId=""
		s FeeType=1
		s FeeTypeDesc="项目"
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:((preAdmId="")||(errs'=""))  d
		.;q:OrdSetID'=""
		.s PIBI=$p($g(^DHCPEPreIADM(preAdmId)),"^",1)
		.i PIBI'="" d
		..s patName=$p($g(^DHCPEPreIBI(PIBI)),"^",2)
		..s PatRegNo=$p($g(^DHCPEPreIBI(PIBI)),"^",1)
		.s childsub=""
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
		..
		..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
		..s CurARCIMID=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",1)
		..q:(ARCIMID'="")&&(CurARCIMID'=ARCIMID)
		..
		..s ARCOSDR=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",3) //套餐ID
		..q:(OrdSetID'="")&&(OrdSetID'=ARCOSDR)
		..
		..s feesub=0
		..//f  s feesub=$o(^DHCPEPreIADM(preAdmId,subroot,childsub,"FEE",feesub)) q:((feesub="")||(errs'=""))  d
		..f  s feesub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
		...d GetItemFee
		...q:feeData=""
		...d OutItemFee
		///处理审核记录对应的套餐
		q:ARCIMID'=""
		s subroot="ORDENT"
		s preAdmId=""
		s FeeType=2
		s FeeTypeDesc="套餐"
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId)) q:((preAdmId="")||(errs'=""))  d
		.s PIBI=$p($g(^DHCPEPreIADM(preAdmId)),"^",1)
		.i PIBI'="" d
		..s patName=$p($g(^DHCPEPreIBI(PIBI)),"^",2)
		..s PatRegNo=$p($g(^DHCPEPreIBI(PIBI)),"^",1)
		.s childsub=""
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
		..
		..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
		..s CurSetID=$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",1)
		..q:(OrdSetID'="")&&(CurSetID'=OrdSetID)
		..
		..s feesub=0
		..//f  s feesub=$o(^DHCPEPreIADM(preAdmId,subroot,childsub,"FEE",feesub)) q:((feesub="")||(errs'=""))  d
		..f  s feesub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
		...d GetItemFee
		...q:feeData=""
		...d OutItemFee
		
		s i=i+1
	}
	i (PreAudits'="")&(SplitType="")&(InvPrtId="")  D
	.s ind=1 
	.s ID="",FactAmountTotal=0
 	.f  s ID=$O(^TempDHCPEFeeList(Job,ID)) q:ID=""  d
 	..S FactAmountTotal=FactAmountTotal+$g(^TempDHCPEFeeList(Job,ID))
 	.S ItemName="合计"
 	.i (CSPName'="") s ItemName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,ItemName) //翻译
 	.S FactAmount=FactAmountTotal
 	.s (FeeType,FeeTypeDesc,RowId,AddOrdItem,PrivilegeMode,Privilege,PAuditDR,UpdateUserDR,UpdateDate,UpdateTime,OrdStatus,OrdStatusDesc,Checked,tempRowId,patName,PatRegNo,ARCOSName)=""
	.d OutItemFee
 	.k ^TempDHCPEFeeList(Job)

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetItemFee
	s feeData=$g(^DHCPEPreIADM(preAdmId,subroot,childsub,"FEE",feesub))	
	s RowId=preAdmId_"||"_childsub_"||"_feesub
	s ItemName=..GetItemNameByFeeID(RowId,FeeType)
	s ARCOSName=""
	s ARCOSDR=$p($g(^DHCPEPreIADM(preAdmId,subroot,childsub)),"^",3)  //套餐ID
	i ARCOSDR'="" s ARCOSName=$p($g(^ARCOS(ARCOSDR)),"^",2)           //套餐名称
	s AddOrdItem=$p(feeData,"^",1)
	s FactAmount=$p(feeData,"^",2)
	i $p(FactAmount,".",1)="" s FactAmount=0_FactAmount
	;s PrivilegeMode=$p(feeData,"^",3)
	s PrivilegeMode=$p($g(^DHCPEPreA($p(feeData,"^",5))),"^",19)

	s PrivilegeMode=##class(web.DHCPE.PreAudit).GetPrivilegeMode(PrivilegeMode)
	s SaleAmount=$p($g(^DHCPEPreA($p(feeData,"^",5))),"^",8)
	i SaleAmount>0 s PrivilegeMode="销售金额"
	s Privilege=$p(feeData,"^",4)
	s PAuditDR=$p(feeData,"^",5)
	s UpdateUserDR=$p(feeData,"^",6)
	s UpdateDate=$p(feeData,"^",7)
	s UpdateTime=$p(feeData,"^",8)
	s OrdStatus=..GetOrdItemStatus(preAdmId_"||"_childsub,FeeType)
	s MedicalDispensing=..MedicalDispensing(preAdmId_"||"_childsub,FeeType)
	s OrdStatusDesc="未执行"
	i OrdStatus=1 s OrdStatusDesc="执行"
	i MedicalDispensing="1" S OrdStatusDesc="已发药" 
	i MedicalDispensing="0" S OrdStatusDesc="未发药"
	i MedicalDispensing="3" S OrdStatusDesc="已退药" ,OrdStatus=1 
    i subroot="ORDENT" S OrdStatusDesc=""
	s Checked=0
	i SelectIds[(FeeType_"^"_RowId) s Checked=1	
	q
ClearData
	s (ItemName,FeeType,FeeTypeDesc,RowId,AddOrdItem,FactAmount,PrivilegeMode,Privilege,PAuditDR,UpdateUserDR,UpdateDate,UpdateTime,OrdStatus,OrdStatusDesc,Checked,tempRowId,ARCOSName)=""
	q
OutItemFee
	/*** 翻译 start ***/
    if (CSPName'="") {
    	s PrivilegeMode=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,PrivilegeMode)
    	s OrdStatusDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,OrdStatusDesc)
    	s FeeTypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,FeeTypeDesc)
    }
  	/*** 翻译 end ***/
  	s:RowId'="" ^TempDHCPEFeeList(Job,RowId)=+$G(^TempDHCPEFeeList(Job,RowId))+FactAmount
	set Data=$lb(0,ItemName,FeeType,FeeTypeDesc,RowId,AddOrdItem,$j(FactAmount,3,2),PrivilegeMode,Privilege,PAuditDR,UpdateUserDR,UpdateDate,UpdateTime,OrdStatus,OrdStatusDesc,Checked,patName,$G(PatRegNo),ARCOSName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
GetGroupFee
	//add by wang fujian 2009-05-21
	s feeData=$g(^DHCPEPreIADM(preAdmId,subroot,childsub,"FEE",feesub))	
	i SplitType'="group"
	{
		i RowId="" d
		.s RowId=tempRowId
		e  d
		.s RowId=RowId_"^"_tempRowId
	}
	s AddOrdItem=$p(feeData,"^",1)
	i FactAmount="" d
	.s FactAmount=$p(feeData,"^",2)
	e  d
	.s FactAmount=FactAmount+$p(feeData,"^",2)
	s PrivilegeMode=$p(feeData,"^",3)
	s PrivilegeMode=##class(web.DHCPE.PreAudit).GetPrivilegeMode(PrivilegeMode)
	s SaleAmount=$p($g(^DHCPEPreA($p(feeData,"^",5))),"^",8)
	i SaleAmount>0 s PrivilegeMode="销售金额"
	s Privilege=$p(feeData,"^",4)
	s PAuditDR=$p(feeData,"^",5)
	s UpdateUserDR=$p(feeData,"^",6)
	s UpdateDate=$p(feeData,"^",7)
	s UpdateTime=$p(feeData,"^",8)
	s OrdStatus=..GetOrdItemStatus(preAdmId_"||"_childsub,FeeType)
	s MedicalDispensing=..MedicalDispensing(preAdmId_"||"_childsub,FeeType)
	s OrdStatusDesc="未执行"
	i OrdStatus=1 s OrdStatusDesc="执行"
	i MedicalDispensing="1" S OrdStatusDesc="已发药" 
	i MedicalDispensing="0" S OrdStatusDesc="未发药"
	i MedicalDispensing="3" S OrdStatusDesc="已退药" ,OrdStatus=1 
	s Checked=0
	i SelectIds[(FeeType_"^"_RowId) s Checked=1	
	q
}

ClassMethod FindItemFeeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemFeeListExecute ]
{

	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindItemFeeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemFeeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItemNameByFeeID(itemfeeid, feetype, containID As %Library.String = "")
{
	new itemid,itemName,preAdmId,childSub
	s itemName=""
	s preAdmId=$p(itemfeeid,"||",1)
	s childSub=$p(itemfeeid,"||",2)
	if feetype=1
	{
		s itemid=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childSub)),"^",1)
		s itemName=$p($g(^ARCIM($p(itemid,"||",1),$p(itemid,"||",2),1)),"^",2)
		s itemName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",itemName,"ARCIMDesc","cls") //翻译
		
	}
	elseif feetype=2
	{
		s itemid=$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childSub)),"^",1)
		s itemName=$p($g(^ARCOS(itemid)),"^",2)
	}
	if containID=1 s itemName=itemName_"^"_itemid
	q itemName
}

/// itemtype:  1项目  2套餐
/// 返回：0，未执行  1已经执行
/// w ##class(web.DHCPE.ItemFeeList).GetOrdItemStatus("275||4")
ClassMethod GetOrdItemStatus(preOrdItemId, itemtype As %Library.String = "")
{
	new crmorderid,orderid,ordStatus
	s ordStatus=0
	i preOrdItemId="" q ordStatus
	i itemtype=2
	{
		new preadmid,prechildsub,preorderid,entid
		s preadmid=$p(preOrdItemId,"||",1)
		//s prechildsub=$p(preOrdItemId,"||",2)
		//s entid=$p($g(^DHCPEPreIADM(preadmid,"ORDITEM",prechildsub)),"^",2)
		s entid=preOrdItemId
		i entid'=""
		{
			s prechildsub=""
			f  s prechildsub=$o(^DHCPEPreIADM(0,"OrdEnt",entid,preadmid,prechildsub)) q:((prechildsub="")||(ordStatus=1))  d
			.s preorderid= preadmid_"||"_prechildsub
			.s ordStatus=..GetOrdItemStatus(preorderid,"")
			.q:ordStatus=1
			q ordStatus
		}		
	}	
	
	s crmorderid=$o(^DHCPECRMO(0,"CRMORI",preOrdItemId,""))
	if crmorderid="" q ordStatus
	s orderid=$p($g(^DHCPECRMO(crmorderid)),"^",1)
	if orderid="" q ordStatus
	s ResultFlag=$p($g(^OEORD($p(orderid,"||",1),"I",$p(orderid,"||",2),1)),"^",5)
	s ordStatus=$p($g(^OEORD($p(orderid,"||",1),"I",$p(orderid,"||",2),1)),"^",13)
	if ordStatus'=""
	{
		s ordStatus=$p($g(^OEC("OSTAT",ordStatus)),"^",1)		
	}
	////V:核实,U:未核实,D:停止,E:执行,S:暂缓,I:Inactive,IP:In Progress
	if ordStatus="E" q 1	
	q:ResultFlag="SC" 1  ;检查临（到）检的算做执行，不允许退费
	q 0
}

/// AllFlag=1，将FromAuditId审核对应的全部费用明细转移给ToAuditId
/// AllFlag=0时，根据ItemFeeInfos将相应的费用明细转移给ToAuditId
/// ItemFeeInfos格式为：itemfeeid1,itemfeetype1^itemfeeid2,itemfeetype2^......
/// 当ToAuditId为空时，将根据FromAuditId生成一条与FromAuditId审核信息一致的审核记录
ClassMethod MoveItemFee(itmjs As %Library.String = "", itmjsex As %Library.String = "", FromAuditId As %Library.String = "", ToAuditId As %Library.String = "", AllFlag As %Library.String = "", ItemFeeInfos As %Library.String = "")
{
	new errs,itemfeeid,transFlag
	new pAdmType,preAdmId,GIAdmId
	s transFlag=0
	s errs=""
	if FromAuditId=""
	{	s errs="请选择费用记录"
		goto MoveItemFeeErrTrap
	}
	if ((AllFlag'=1)&&(ItemFeeInfos=""))
	{	s errs="请选择要转移的费用明细记录!"
		goto MoveItemFeeErrTrap
	}
	s fromAuditData=$g(^DHCPEPreA(FromAuditId))
	if $p(fromAuditData,"^",14)'="UNCHARGED"
	{	s errs="已经收费，不能转移!"
		goto MoveItemFeeErrTrap
	}
	
	s pAdmType=$p(fromAuditData,"^",1)
	s GIAdmId=$p(fromAuditData,"^",2)  //修改一个参数名称因为与下面使用的重复了
	
	if (ToAuditId'="")
	{
		s toAuditData=$g(^DHCPEPreA(ToAuditId))
		if $p(toAuditData,"^",14)'="UNCHARGED"
		{	s errs="已经收费，不能转移!"
			goto MoveItemFeeErrTrap}
		if (($p(fromAuditData,"^",1)'=$p(toAuditData,"^",1))||($p(fromAuditData,"^",2)'=$p(toAuditData,"^",2))||($p(fromAuditData,"^",3)'=$p(toAuditData,"^",3)))
		{	s errs="不属于同一个登记记录，不能转移!"
			goto MoveItemFeeErrTrap}
		if (($p(fromAuditData,"^",5)'=$p(toAuditData,"^",5))||($p(fromAuditData,"^",19)'=$p(toAuditData,"^",19))||($p(fromAuditData,"^",20)'=$p(toAuditData,"^",20)))
		{	s errs="审核记录优惠方式有差别，不能转移!"
			goto MoveItemFeeErrTrap}
	}
	
	s transFlag=1
	TStart
	if (ToAuditId="")
	{
		&SQL(Insert Into DHC_PE_PreAudit (PA_ADMType,PA_CRMADM,PA_GIADM,PA_ContractNo,PA_Rebate,PA_AuditedStatus,PA_AuditUser_DR,PA_AuditDate,PA_AuditTime,PA_ChargedStatus,PA_CancelUser_DR,PA_CancelDate,PA_CancelTime,PA_Remark,PA_PrivilegeMode,PA_Type,PA_Status)
			Select PA_ADMType,PA_CRMADM,PA_GIADM,PA_ContractNo,PA_Rebate,PA_AuditedStatus,PA_AuditUser_DR,PA_AuditDate,PA_AuditTime,PA_ChargedStatus,PA_CancelUser_DR,PA_CancelDate,PA_CancelTime,PA_Remark,PA_PrivilegeMode,PA_Type,'U'
				from DHC_PE_PreAudit Where PA_RowId=:FromAuditId)
		if SQLCODE
		{	s errs="生成新的费用记录失败!"
			goto MoveItemFeeErrTrap				
		}
		s ToAuditId=%ROWID
	}
	
	if (AllFlag=1)
	{
		///处理审核记录对应的项目
		s preAdmId=""
		s FeeType=1
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",FromAuditId,preAdmId)) q:((preAdmId="")||(errs'=""))  d
		.s childsub=""
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",FromAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
		..s feesub=0
		..f  s feesub=$o(^DHCPEPreIADM(0,"PAORDITEM",FromAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
		...s itemfeeid=preAdmId_"||"_childsub_"||"_feesub
		...d MoveItemFeeByID(FeeType,itemfeeid)
		
		if errs'="" goto MoveItemFeeErrTrap
		
		///处理审核记录对应的套餐
		s preAdmId=""
		s FeeType=2
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDENT",FromAuditId,preAdmId)) q:((preAdmId="")||(errs'=""))  d
		.s childsub=""
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",FromAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
		..s feesub=0
		..f  s feesub=$o(^DHCPEPreIADM(0,"PAORDENT",FromAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
		...s itemfeeid=preAdmId_"||"_childsub_"||"_feesub
		...d MoveItemFeeByID(FeeType,itemfeeid)
		if errs'="" goto MoveItemFeeErrTrap
	}
	elseif ItemFeeInfos'=""
	{	
		s i=1
		while(i<=$l(ItemFeeInfos,"^")){
			s itemfeeid=$p(ItemFeeInfos,"^",i)
			s i=i+1
			i itemfeeid="" continue

			s FeeType=$p(itemfeeid,",",2)
			s itemfeeid=$p(itemfeeid,",",1)
			i $l(itemfeeid,"||")=3
			{		
				if ((itemfeeid="")||(FeeType=""))
				{	s errs="选择的费用明细信息不正确!"
					goto MoveItemFeeErrTrap	}
				d MoveItemFeeByID(FeeType,itemfeeid)
				if errs'="" goto MoveItemFeeErrTrap
			}
			elseif($l(itemfeeid,"||")=2)
			{
				d MoveItemFeeByTeamID(itemfeeid)
				if errs'="" goto MoveItemFeeErrTrap
			}
			else
			{
				d MoveItemFeeByPreID(itemfeeid)
				if errs'="" goto MoveItemFeeErrTrap
			}
			
			
		}		
	}
	
	///重新计算审核表费用
	///修改返回值判断	
	i pAdmType="G" 
	{	//s preAdmId=$p($g(^DHCPEGADM(pAdmId)),"^",2)
		s SQLCODE= ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(GIAdmId,"")}
	else
	{	//s preAdmId=$p($g(^DHCPEIADM(pAdmId)),"^",4)	
		s SQLCODE= ##class(web.DHCPE.PreIADM).UpdatePersonAuditAmount(GIAdmId)
	}
	d ##class(web.DHCPE.PreIADM).UpdateAuditSaleAmount(FromAuditId,ToAuditId)
	if SQLCODE'=0
	{
		s errs="重新计算费用错误"
		goto MoveItemFeeErrTrap
	}
	
	
	TCommit
	q ToAuditId
	
MoveItemFeeByID(FeeType,itemfeeid)
	i FeeType=1  d
	.&SQL(Update DHC_PE_PreIOrdItemFee Set PIOIF_PAudit_DR=:ToAuditId Where PIOIF_RowId=:itemfeeid)
	.if SQLCODE s errs="转移费用明细失败!"
	e  d
	.&SQL(Update DHC_PE_PreIOrdEntFee Set PIOEF_PAudit_DR=:ToAuditId Where PIOEF_RowId=:itemfeeid)
	.if SQLCODE s errs="转移费用明细失败!"	
	q
MoveItemFeeByTeamID(GTeamId)
	s preAdmId=""
	f  s preAdmId=$o(^DHCPEPreIADM(0,"PGTeam",GTeamId,preAdmId)) q:preAdmId=""  d
	.s patName=$p($g(^DHCPEPreIADM(preAdmId)),"^",1)
	.i patName'="" s patName=$p($g(^DHCPEPreIBI(patName)),"^",2)
	.//处理项目
	.s childsub=""
	.s subroot="ORDITEM"
	.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",FromAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
	..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
	..s feesub=0
	..f  s feesub=$o(^DHCPEPreIADM(0,"PAORDITEM",FromAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
	...s tempRowId=preAdmId_"||"_childsub_"||"_feesub
	...d MoveItemFeeByID("1",tempRowId)
	.//处理套餐
	.s childsub=""
	.s subroot="PAORDENT"
	.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",FromAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
	..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
	..s feesub=0
	..f  s feesub=$o(^DHCPEPreIADM(0,"PAORDENT",FromAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
	...s tempRowId=preAdmId_"||"_childsub_"||"_feesub
	...d MoveItemFeeByID("2",tempRowId)
	q
MoveItemFeeByPreID(preAdmId)
	s childsub=""
	s subroot="ORDITEM"
	f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",FromAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
	.q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
	.s feesub=0
	.f  s feesub=$o(^DHCPEPreIADM(0,"PAORDITEM",FromAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
	..s tempRowId=preAdmId_"||"_childsub_"||"_feesub
	..d MoveItemFeeByID("1",tempRowId)
	//处理套餐
	s childsub=""
	s subroot="PAORDENT"
	f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",FromAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
	.q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
	.s feesub=0
	.f  s feesub=$o(^DHCPEPreIADM(0,"PAORDENT",FromAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
	..s tempRowId=preAdmId_"||"_childsub_"||"_feesub
	..d MoveItemFeeByID("2",tempRowId)
	q	
MoveItemFeeErrTrap
	i transFlag=1 TRollBack	
	q errs
}

/// w ##class(web.DHCPE.ItemFeeList).CalculateFee(auditid, accountamount, discountedAmount)
ClassMethod CalculateFee(auditid, accountamount, discountedAmount)
{
	new preAdmId,childsub,feesub,FeeType
	new errs,tmpAmount,tmpDiscountedAmount
	///处理审核记录对应的项目
	s (errs,tmpAmount,tmpDiscountedAmount)=""
	s accountamount=0
	s preAdmId=""
	s FeeType=1
	f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",auditid,preAdmId)) q:((preAdmId="")||(errs'=""))  d
	.s childsub=""
	.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",auditid,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
	..s feesub=0
	..f  s feesub=$o(^DHCPEPreIADM(0,"PAORDITEM",auditid,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
	...s itemfeeid=preAdmId_"||"_childsub_"||"_feesub
	...d ..GetFee(FeeType, itemfeeid, .tmpAmount, tmpDiscountedAmount)
	...s accountamount=accountamount+tmpAmount
		
	///处理审核记录对应的套餐
	s preAdmId=""
	s FeeType=2
	f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDENT",auditid,preAdmId)) q:((preAdmId="")||(errs'=""))  d
	.s childsub=""
	.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",auditid,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
	..s feesub=0
	..f  s feesub=$o(^DHCPEPreIADM(0,"PAORDENT",auditid,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
	...s itemfeeid=preAdmId_"||"_childsub_"||"_feesub
	...d ..GetFee(FeeType, itemfeeid, .tmpAmount, tmpDiscountedAmount)
	...s accountamount=accountamount+tmpAmount
	q
}

ClassMethod GetFee(feetype, itemfeeid, accountamount, discountedAmount)
{
	new preAdmId,childsub,auditId
	new subroot,feesub,itemdata,errs
	s errs=""
	i itemfeeid="" q ""
	if feetype=1 s subroot="ORDITEM"
	if feetype=2 s subroot="ORDENT"
	if subroot="" q ""
	s preAdmId=$p(itemfeeid,"||",1)
	s childsub=$p(itemfeeid,"||",2)
	if ((preAdmId="")||(childsub="")) q ""
	s itemdata=$g(^DHCPEPreIADM(preAdmId,subroot,childsub))
	i feetype=1 s accountamount=$p(itemdata,"^",14)
	i feetype=2 s accountamount=$p(itemdata,"^",7)
	s feesub=0
	f  s feesub=$o(^DHCPEPreIADM(preAdmId,subroot,childsub,"FEE",feesub)) q:((feesub="")||(errs'=""))  d
	.i preAdmId_"||"_childsub_"||"_feesub'=itemfeeid  d
	..i feetype=1 s accountamount=0
	..//s feeData=$g(^DHCPEPreIADM(preAdmId,subroot,childsub,"FEE",feesub))
	..//q:feeData=""
	..//s auditId=$p(feeData,"^",5)
	..//i $p($g(^DHCPEPreA(auditId)),"",)
	q
}

/// w ##class(web.DHCPE.ItemFeeList).GetAmount(",1^233||30||1,1^233||31||1,")
ClassMethod GetAmount(itemfeeids)
{
	new itemfeeid,feetype,preadmid,childsub,feesub
	new i,amount,total	
	s i=1
	s total=0
	if itemfeeids="" q 0
	while(i<=$l(itemfeeids,",")){
		s itemfeeid=$p(itemfeeids,",",i)
		s i=i+1
		i itemfeeid="" continue
		s feetype=$p(itemfeeid,"^",1)
		s itemfeeid=$p(itemfeeid,"^",2)
		s preadmid=$p(itemfeeid,"||",1)
		s childsub=$p(itemfeeid,"||",2)
		s feesub=$p(itemfeeid,"||",3)
		if feetype=1
		{	s amount=$p($g(^DHCPEPreIADM(preadmid,"ORDITEM",childsub,"FEE",feesub)),"^",2)}
		else
		{	s amount=$p($g(^DHCPEPreIADM(preadmid,"ORDENT",childsub,"FEE",feesub)),"^",2)}
		s total=total+amount			
	}	
	q total
}

/// PreAudits:审核ids
/// flag:1清单打印   0发票打印
/// curdate：$H
/// job:$j
/// w ##class(web.DHCPE.ItemFeeList).GetListInfo("283","0",60894,1)
ClassMethod GetListInfo(PreAudits, flag, curdate, job)
{
	new tmpdata
	new amount,ItemName,ItemId,FactAmount,qty,Uom
	new itmsub,itmdata,itmFactAmount,itmSumAmount,itmAccountAmount,sumAccount
	new rtn
	new i,preAuditId,FeeType,subroot,preAdmId,childsub,feesub,errs
	new defaultfeeid,defaultfeename
	new sumFactAmount,sumAccountAmount
	s (defaultfeeid,defaultfeename)=""
	s (sumFactAmount,sumAccountAmount)=0
	
	k ^DHCPETemp("GetListInfo",curdate,job)
	
	d ##class(web.DHCPE.Cashier).GetDefaultFee(.defaultfeeid,.defaultfeename)
	s i=1
	while(i<=$l(PreAudits,",")){
		s preAuditId=$p(PreAudits,",",i)
		s i=i+1
		q:preAuditId=""
		q:$p($g(^DHCPEPreA(preAuditId)),"^",21)="NU"
		s sumAccountAmount=sumAccountAmount+$p($g(^DHCPEPreA(preAuditId)),"^",6)
		s sumFactAmount=sumFactAmount+$p($g(^DHCPEPreA(preAuditId)),"^",9)
		///取项目
		s FeeType=1
		s subroot="ORDITEM"
		s preAdmId=""
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:((preAdmId=""))  d
		.s childsub=""
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub)) q:((childsub=""))  d
		..
		..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
		..s itmAccountAmount=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",14)
		..if itmAccountAmount'="" s itmAccountAmount=$j(itmAccountAmount,3,2)
		..s feesub=0
		..f  s feesub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub,feesub)) q:((feesub=""))  d
		...s feeData=$g(^DHCPEPreIADM(preAdmId,subroot,childsub,"FEE",feesub))	
		...s ItemName=##class(web.DHCPE.ItemFeeList).GetItemNameByFeeID(preAdmId_"||"_childsub,FeeType,1)
		...//w ItemName
		...//b ItemName
		...s FactAmount=$p(feeData,"^",2)
		...if FactAmount'="" s FactAmount=$j(FactAmount,3,2)
		...s ItemId=$p(ItemName,"^",2)
		...s ItemName=$p(ItemName,"^",1)
		...s Uom=##class(web.DHCPE.Cashier).GetUomByArcItem(ItemId)
		...s itmFactAmount=FactAmount
		...d FillTmpData		
		///取套餐
		s FeeType=2
		s subroot="ORDENT"
		s preAdmId=""
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId)) q:((preAdmId=""))  d
		.s childsub=""
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub)) q:((childsub=""))  d
		..
		..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
		..s itmAccountAmount=$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",7)
		..if itmAccountAmount'="" s itmAccountAmount=$j(itmAccountAmount,3,2)
		..s feesub=0
		..f  s feesub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub,feesub)) q:((feesub=""))  d
		...s feeData=$g(^DHCPEPreIADM(preAdmId,subroot,childsub,"FEE",feesub))	
		...s ItemName=##class(web.DHCPE.ItemFeeList).GetItemNameByFeeID(preAdmId_"||"_childsub,FeeType,1)
		...s FactAmount=$p(feeData,"^",2)
		...if FactAmount'="" s FactAmount=$j(FactAmount,3,2)
		...
		...s itmSumAmount=##class(web.DHCPE.Cashier).GetEntSumAmount(preAdmId_"||"_childsub)
		...s itmSumAmount=$j(itmSumAmount,3,2)
		...i ((flag=0)&&(itmSumAmount'=FactAmount))  d
		....s itmFactAmount=FactAmount
		....s ItemId=defaultfeeid
		....s ItemName=defaultfeename
		....s Uom=##class(web.DHCPE.Cashier).GetUomByArcItem(ItemId)
		....d FillTmpData 
		...q:((flag=0)&&(itmSumAmount'=FactAmount))
		...i ((flag=1)&&(itmSumAmount'=itmAccountAmount))  d
		....s ItemId=$p(ItemName,"^",2)
		....s ItemName=$p(ItemName,"^",1)
		....s itmFactAmount=FactAmount
		....
		....s Uom=""
		....d FillTmpData 
		....//b
		....
		...q:((flag=1)&&(itmSumAmount'=itmAccountAmount))
		...//
		...s itmSumAmount=0
		...s itmsub=""
		...f  s itmsub=$o(^DHCPEPreIADM(0,"OrdEnt",preAdmId_"||"_childsub,preAdmId,itmsub)) q:((itmsub=""))  d
		....
		....q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",itmsub)),"^",16)'=1	//判断是否有效
		....
		....q:FactAmount=itmSumAmount
		....s itmdata=$g(^DHCPEPreIADM(preAdmId,"ORDITEM",itmsub))
		....s ItemName=##class(web.DHCPE.ItemFeeList).GetItemNameByFeeID(preAdmId_"||"_itmsub,1,1)
		....s ItemId=$p(ItemName,"^",2)
		....s ItemName=$p(ItemName,"^",1)
		....s Uom=##class(web.DHCPE.Cashier).GetUomByArcItem(ItemId)
		....s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",preAdmId_"||"_itmsub)) 
		....s itmFactAmount=##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(ItemId,"","","","","","","",preAdmId,ADMFeeType)
		....s itmFactAmount=+itmFactAmount
		....s itmAccountAmount=itmFactAmount
		....d FillTmpData		
	}
	s ^DHCPETemp("GetListInfo",curdate,job,"SumAccount")=sumAccountAmount	
	s ^DHCPETemp("GetListInfo",curdate,job,"SumFact")=sumFactAmount
	q 
	
FillTmpData
	//w itmFactAmount
	s tmpdata=$g(^DHCPETemp("GetListInfo",curdate,job,ItemId,itmFactAmount))
	if tmpdata=""  d
	.s tmpdata=ItemName_"^"_1_"^"_itmFactAmount_"^"_itmFactAmount_"^"_Uom_"^"_itmAccountAmount
	e  d
	.s $p(tmpdata,"^",2)=+$p(tmpdata,"^",2)+1
	.s $p(tmpdata,"^",3)=+$p(tmpdata,"^",3)+itmFactAmount
	s ^DHCPETemp("GetListInfo",curdate,job,ItemId,itmFactAmount)=tmpdata
	q
}

/// creator:xy
/// creatdate:2018-11-21
/// description:通过发票ID判断部分退费、全退
/// d ##class(web.DHCPE.ItemFeeList).GetApplyRefundFlag()
ClassMethod GetApplyRefundFlag(InvPrtId As %String)
{
	q:InvPrtId="" ""
	q:'$d(^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId)) ""
	s selectIds=$g(^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId))
	i selectIds="" s flag=0
	e  s flag=1
	q flag
}

/// creator:wangfujian
/// creatdate:2009-04-20
/// description:通过发票号，取出该发票的退费申请信息
ClassMethod GetApplyRefund(InvPrtId As %String, flag As %String)
{
	q:InvPrtId="" ""
	s selectIds=$g(^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId))
	q selectIds
}

/// creator:wangfujian
/// creatdate:2009-04-20
/// description:通过发票号，取出该发票的退费申请信息
/// outPut:保存成功，返回1，保存失败返回0 返回2表示没有改变
/// w ##class(web.DHCPE.ItemFeeList).SetApplyRefund(791,"","0","")
ClassMethod SetApplyRefund(InvPrtId As %String, selectIds As %String, flag As %String = "", backAmount As %String = "", LocID As %String = "", UserID As %String = "")
{
	q:(InvPrtId="") 0
	// 退药申请
	// 先处理退药申请 成功再设置退费申请
	s ^TMPDHCPE("SetApplyRefund")=$lb(InvPrtId,selectIds,flag,backAmount,LocID,UserID)
	TSTART
	s Drugret=0
	i selectIds="" d
	.i $g(^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId))="" d
	..s item=""
	..f  s item=$o(^DHCPEOEITEM(InvPrtId,"OEITEM",item)) q:(item="")  d
	...s CRMORDER=$o(^DHCPECRMO(0,"CRMORI",item,0))
	...q:(CRMORDER="") 
	...s OEORI=$p($g(^DHCPECRMO(CRMORDER)),"^",1)
	...q:OEORI=""
	...q:('$d(^DHCPEDataEx("SendPHDRequest",OEORI)))
	...s CancelRet= ..CancelDrugApply(OEORI,UserID)
	...i CancelRet'=0 goto Err
	.e  d
	..s IDS=$p($g(^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId)),";",1)
	..s length=$l(IDS)
	..for i=1:1:length d
	...s OneInfo=$p(IDS,",",i)
	...q:(OneInfo="")
	...s itemtype=$p(OneInfo,"^",1)
	...s preOrdItemId=$p($p(OneInfo,"^",2),"||",1,2)
	
	...i itemtype="2"  d       //为医嘱套
	....s PIOERowID=$P(preOrdItemId,"||",1,2)
	....s childsub=0
	....f  s childsub=$o(^DHCPEPreIADM(0,"OrdEnt",PIOERowID,$p(PIOERowID,"||",1),childsub))  q:childsub=""  d
	.....s PIOIRowID=$p(PIOERowID,"||",1)_"||"_childsub
    .....s CRMORDER=$o(^DHCPECRMO(0,"CRMORI",$P(preOrdItemId,"||",1,2),0))
	.....q:(CRMORDER="") 
	.....s OEORI=$p($g(^DHCPECRMO(CRMORDER)),"^",1)
	.....q:OEORI=""
	.....q:('$d(^DHCPEDataEx("SendPHDRequest",OEORI)))
	.....s CancelRet= ..CancelDrugApply(OEORI,UserID)
	.....i CancelRet'=0 goto Err
	.....e  d
	......k ^DHCPEDataEx("SendPHDRequest",OEORI)
	...i itemtype="1"  d       //为医嘱套
	....s CRMORDER=$o(^DHCPECRMO(0,"CRMORI",preOrdItemId,0))
	....q:(CRMORDER="") 
	....s OEORI=$p($g(^DHCPECRMO(CRMORDER)),"^",1)
	....q:OEORI=""
	....q:('$d(^DHCPEDataEx("SendPHDRequest",OEORI)))
	....s CancelRet= ..CancelDrugApply(OEORI,UserID)
	....i CancelRet'=0 goto Err
	....e  d
	.....k ^DHCPEDataEx("SendPHDRequest",OEORI)
	e  i selectIds="AllRefund" d
	.
	.s item=""
	.f  s item=$o(^DHCPEOEITEM(InvPrtId,"OEITEM",item)) q:(item="")  d
	..s OneInfo="1^"_item
	..s Drugret=##class(web.DHCPE.ItemFeeList).DrugPermControl(OneInfo,"0","",LocID,UserID)
	..i Drugret=2 d
	...goto Err
	e  d
	.s length=$l(selectIds)
	.for i=1:1:length d
	..s OneInfo=$p(selectIds,",",i)
	..q:(OneInfo="")
	..
	..s Drugret=##class(web.DHCPE.ItemFeeList).DrugPermControl(OneInfo,"0","",LocID,UserID)
	..q:(Drugret=2)
	..i Drugret=2 d
	...goto Err
	s ret=1
	
	i selectIds="" d
	.k ^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId)
	.k ^DHCPEDataEx("DHCPERefundApply","SelectIdsUser",InvPrtId)
	e  i selectIds="AllRefund" d
	.//i ($g(^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId))="")&&($d(^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId))) s ret=2
	.s ^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId)=""
	.s ^DHCPEDataEx("DHCPERefundApply","SelectIdsUser",InvPrtId)=UserID_"^"_$h
	.s PAADM=$P($g(^DHCPEINVPRT(InvPrtId)),"^",2)
	.//插入全退申请日志
	.d ##class(web.DHCPE.AdmRecordManager).Insert(PAADM,"A","AllRefund",UserID,InvPrtId)
	e  d
	.i $g(^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId))=(selectIds_";"_backAmount) s ret=2
	.s ^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId)=selectIds_";"_backAmount
	.s ^DHCPEDataEx("DHCPERefundApply","SelectIdsUser",InvPrtId)=UserID_"^"_$h
	TCommit
	
	q ret
Err
	TRollBack	
	q "-1"
}

// w ##class(web.DHCPE.ItemFeeList).GetRefundInfo(84)

/*ClassMethod GetRefundInfo(INvPrtId)
{
	q:'$D(^DHCPEDataEx("DHCPERefundApply","SelectIds",INvPrtId)) ""
	s PAADM=$p(^DHCPEINVPRT(INvPrtId),"^",2)
	s No=$p(^DHCPEINVPRT(INvPrtId),"^",1)
	q:PAADM="" ""
	s LocID=$P(^PAADM(PAADM),"^",4)
	s LocID=$P(^CTLOC(LocID),"^",2)
	i $L(LocID,"-")>1 s LocID=$P(LocID,"-",2)
	s pmiID=$P(^PAADM(PAADM),"^",1)
	s Name=$P(^PAPER(pmiID,"ALL"),"^",1)
	s refundItem=$G(^DHCPEDataEx("DHCPERefundApply","SelectIds",INvPrtId))
	i refundItem="" d
	.s refundAmount=$p(^DHCPEINVPRT(INvPrtId),"^",7)
	e  d
	.s refundAmount=$P(refundItem,";",2)
	.s refundItem=$P(refundItem,";",1)
	s AmountPY=##class(web.DHCPE.DHCPEPAY).RMBDXXZH("","",refundAmount)
	s patientInfo=Name_"^"_No_"^"_LocID_"^"_AmountPY_"^"_refundAmount
	s ItemInfo=""
	i refundItem="" d
	.s PBID=$p(^DHCPEINVPRT(INvPrtId),"^",3)
	.s PAPBID=0
	.f  s PAPBID=$O(^DHCPEPAPBR(0,"PBDR",PBID,PAPBID)) q:PAPBID=""  d
	..s PAID=$P(^DHCPEPAPBR(PAPBID),"^",1)
	..s IADM=0
	..f  s IADM=$O(^DHCPEPreIADM(0,"PAORDITEM",PAID,IADM)) q:IADM=""  d
	...s itemSub=0
	...f  s itemSub=$O(^DHCPEPreIADM(0,"PAORDITEM",PAID,IADM,itemSub)) q:itemSub=""  d
	....s feeSub=0
	....s oneAmount=0
	....f  s feeSub=$O(^DHCPEPreIADM(0,"PAORDITEM",PAID,IADM,itemSub,feeSub)) q:feeSub=""  d
	.....s amount=$P(^DHCPEPreIADM(IADM,"ORDITEM",itemSub,"FEE",feeSub),"^",2)
	.....s oneAmount=oneAmount+amount
	....s itmMastID=$P(^DHCPEPreIADM(IADM,"ORDITEM",itemSub),"^",1)
	....s itmDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(itmMastID)
	....s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(10),"")
	....s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(9),"")
	....s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(13),"")
	....s oneInfo=itmDesc_"^"_oneAmount
	....i ItemInfo="" d
	.....s ItemInfo=oneInfo
	....e  d
	.....s ItemInfo=ItemInfo_$C(2)_oneInfo
	e  d
	.s i=$L(refundItem,",")
	.s i=i-1
	.f j=2:1:i  d
	..s oneItem=$P(refundItem,",",j)
	..q:oneItem=""
	..s feeID=$P(oneItem,"^",2)
	..s itmMastID=$P(^DHCPEPreIADM(+feeID,"ORDITEM",$P(feeID,"||",2)),"^",1)
	..s itmDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(itmMastID)
	..s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(10),"")
	..s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(9),"")
	..s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(13),"")
	..s amount=$P(^DHCPEPreIADM(+feeID,"ORDITEM",$P(feeID,"||",2),"FEE",$P(feeID,"||",3)),"^",2)
	..s oneInfo=itmDesc_"^"_amount
	..i ItemInfo="" d
	...s ItemInfo=oneInfo
	..e  d
	...s ItemInfo=ItemInfo_$C(2)_oneInfo
	q patientInfo_$C(1)_ItemInfo
}*/
ClassMethod GetRefundInfo(INvPrtId)
{
	q:INvPrtId="" ""
	q:'$D(^DHCPEDataEx("DHCPERefundApply","SelectIds",INvPrtId)) ""
	s PAADM=$p(^DHCPEINVPRT(INvPrtId),"^",2)
	s No=$p(^DHCPEINVPRT(INvPrtId),"^",1)
	s FocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_INvPrtId,""))
	i FocusPrintID'="" d
	.s No=$LG(^User.DHCPEINVFocusPrtD(FocusPrintID),3)
	q:PAADM="" ""
	
	s LocID=$P($g(^PAADM(PAADM)),"^",4)
	s LocDesc=$P($g(^CTLOC(LocID)),"^",2)
	i $L(LocDesc,"-")>1 s LocDesc=$P(LocDesc,"-",2)
	
	s pmiID=$P($g(^PAADM(PAADM)),"^",1)
	s Name=$P($g(^PAPER(pmiID,"ALL")),"^",1)
	s refundItem=$G(^DHCPEDataEx("DHCPERefundApply","SelectIds",INvPrtId))
	i refundItem="" d
	.s refundAmount=$p(^DHCPEINVPRT(INvPrtId),"^",7)
	e  d
	.s refundAmount=$P(refundItem,";",2)
	.s refundItem=$P(refundItem,";",1)
	s AmountPY=##class(web.DHCPE.DHCPEPAY).RMBDXXZH("","",refundAmount,1,LocID)
	s RefundRemark=$g(^DHCPEDataEx("DHCPERefundApply","RefundRemark",INvPrtId))
	s HOSPID=$P($g(^CTLOC(LocID)),"^",22)
	s HospitalName=##class(web.DHCPE.DHCPECommon).GetHospitalName(HOSPID)
	s patientInfo=Name_"^"_No_"^"_LocDesc_"^"_AmountPY_"^"_$fn(refundAmount,"",2)_"^"_RefundRemark_"^"_HospitalName
	s ItemInfo=""
	i refundItem="" d
	.s PBID=$p(^DHCPEINVPRT(INvPrtId),"^",3)
	.s PAPBID=0
	.f  s PAPBID=$O(^DHCPEPAPBR(0,"PBDR",PBID,PAPBID)) q:PAPBID=""  d
	..s PAID=$P(^DHCPEPAPBR(PAPBID),"^",1)
	..s IADM=0
	..f  s IADM=$O(^DHCPEPreIADM(0,"PAORDITEM",PAID,IADM)) q:IADM=""  d
	...s itemSub=0
	...f  s itemSub=$O(^DHCPEPreIADM(0,"PAORDITEM",PAID,IADM,itemSub)) q:itemSub=""  d
	....s feeSub=0
	....s oneAmount=0
	....f  s feeSub=$O(^DHCPEPreIADM(0,"PAORDITEM",PAID,IADM,itemSub,feeSub)) q:feeSub=""  d
	.....s amount=$P($g(^DHCPEPreIADM(IADM,"ORDITEM",itemSub,"FEE",feeSub)),"^",2)
	.....s oneAmount=oneAmount+amount
	....s itmMastID=$P(^DHCPEPreIADM(IADM,"ORDITEM",itemSub),"^",1)
	....s itmDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(itmMastID,"A",LocID)
	....s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(10),"")
	....s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(9),"")
	....s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(13),"")
	....s oneInfo=itmDesc_"^"_$fn(oneAmount,"",2)
	....i ItemInfo="" d
	.....s ItemInfo=oneInfo
	....e  d
	.....s ItemInfo=ItemInfo_$C(2)_oneInfo
	
	...s EntSub=0
	...f  s EntSub=$O(^DHCPEPreIADM(0,"PAORDENT",PAID,IADM,EntSub)) q:EntSub=""  d
	....s EntfeeSub=0
	....s oneAmount=0
	....f  s EntfeeSub=$O(^DHCPEPreIADM(0,"PAORDENT",PAID,IADM,EntSub,EntfeeSub)) q:EntfeeSub=""  d
	.....s amount=$P($g(^DHCPEPreIADM(IADM,"ORDENT",EntSub,"FEE",EntfeeSub)),"^",2)
	.....s oneAmount=oneAmount+amount
	....s OrderSetsDR=$P(^DHCPEPreIADM(IADM,"ORDENT",EntSub),"^",1)
	....s itmDesc=$p($g(^ARCOS(OrderSetsDR)),"^",2)
	....s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(10),"")
	....s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(9),"")
	....s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(13),"")
	....s oneInfo=itmDesc_"^"_$fn(oneAmount,"",2)
	....i ItemInfo="" d
	.....s ItemInfo=oneInfo
	....e  d
	.....s ItemInfo=ItemInfo_$C(2)_oneInfo

     
	e  d
	.s i=$L(refundItem,",")
	.s i=i-1
	.f j=2:1:i  d
	..s oneItem=$P(refundItem,",",j)
	..q:oneItem=""
	..s feeID=$P(oneItem,"^",2)
	..s FeeType=$P(oneItem,"^",1)
	..i FeeType="1"  d
	...s itmMastID=$P(^DHCPEPreIADM(+feeID,"ORDITEM",$P(feeID,"||",2)),"^",1)
	...s itmDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(itmMastID,"A",LocID)
	...s amount=$P(^DHCPEPreIADM(+feeID,"ORDITEM",$P(feeID,"||",2),"FEE",$P(feeID,"||",3)),"^",2)
	..i FeeType="2"  d
    ...s SetID=$P($G(^DHCPEPreIADM(+feeID,"ORDENT",$P(feeID,"||",2))),"^",1)
    ...s itmDesc=$P($G(^ARCOS(SetID)),"^",2)
    ...s amount=$P(^DHCPEPreIADM(+feeID,"ORDENT",$P(feeID,"||",2),"FEE",$P(feeID,"||",3)),"^",2)
	..s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(10),"")
	..s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(9),"")
	..s itmDesc=##class(web.DHCPE.Public.Setting).Replace(itmDesc,$C(13),"")
	..s oneInfo=itmDesc_"^"_$fn(amount,"",2)
	..i ItemInfo="" d
	...s ItemInfo=oneInfo
	..e  d
	...s ItemInfo=ItemInfo_$C(2)_oneInfo
	q patientInfo_$C(1)_ItemInfo
}

ClassMethod MedicalDispensing(preOrdItemId, itemtype As %Library.String = "")
{
   
     new crmorderid,orderid,ordStatus
	s ordStatus=2
	i preOrdItemId="" q ordStatus
	i itemtype=2
	{
		new preadmid,prechildsub,preorderid,entid
		s preadmid=$p(preOrdItemId,"||",1)
		s entid=preOrdItemId
		i entid'=""
		{
			s prechildsub=""
			f  s prechildsub=$o(^DHCPEPreIADM(0,"OrdEnt",entid,preadmid,prechildsub)) q:((prechildsub="")||(ordStatus=1))  d
			.s preorderid= preadmid_"||"_prechildsub
			.s ordStatus=..MedicalDispensing(preorderid,"")
			.q:ordStatus=1
			q ordStatus
		}		
	}	
	s LocID=$P($g(^DHCPEPreIADM(+preOrdItemId)),"^",26)
	s crmorderid=$o(^DHCPECRMO(0,"CRMORI",preOrdItemId,""))
	if crmorderid="" q "2"
	s orderid=$p($g(^DHCPECRMO(crmorderid)),"^",1)
	if orderid="" q "2"
	s ordStatus=$p($g(^OEORD($p(orderid,"||",1),"I",$p(orderid,"||",2),1)),"^",13)
	s ItmMastDR=$p($g(^OEORD($p(orderid,"||",1),"I",$p(orderid,"||",2),1)),"^",2)
    q:ItmMastDR="" ""
	//s STRowId="0"
	//s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,STRowId))
	/***多院区***/
	S StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItmMastDR,LocID)
	q:StatOrderID="" ""
	s STRowId=$p(StatOrderID,"||",1)
	/***多院区***/
	q:(STRowId="")&&($g(^DHCPESetting("DHCPE","StationId_Medical",LocID))="") "2"  
	q:STRowId'=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID)) "2" 
	s OEDId=$o(^DHCOEDISQTY(0,"OEORI",orderid,""),-1)
	q:OEDId="" 0
	s OEDStatus=$p($g(^DHCOEDISQTY(OEDId)),"^",7)
	
	q:OEDStatus="C" 1   //已发药
	q:OEDStatus="TC" 0  //未发药
	q:OEDStatus="R" 3  //已退药
	q 2
}

/// Description: 退费申请和退费时药品状态的判断
/// Input:       IsApply:(0 退费申请,1 退费)，InvPrtId（发票ID）,LocID(科室ID),userId(操作人员ID)
/// Return：     0/1/2(退药申请失败)
/// debug: w ##class(web.DHCPE.ItemFeeList).DrugPermControl("1^22806||24||2","0")
ClassMethod DrugPermControl(Str, IsApply, InvPrtId, LocID As %Library.String = "", userId As %Library.String = "")
{
	s ^tempdhcpe("DrugPermControl")=$lb(Str, IsApply, InvPrtId, LocID,userId)
	s MedcalStation=$G(^DHCPESetting("DHCPE","StationId_Medical",LocID))
	
	s ControlFlag=0
    if IsApply="0"  d                  //退费申请
	.s itemtype=$p(Str,"^",1)
	.s preOrdItemId=$p(Str,"^",2)
    .i itemtype="1"  d                 //为医嘱项
    ..s PIOIRowID=$P(preOrdItemId,"||",1,2)
    ..s ARCIMDR=$p($g(^DHCPEPreIADM($p(PIOIRowID,"||",1),"ORDITEM",$p(PIOIRowID,"||",2))),"^",1)
    ..q:ARCIMDR=""
    ..;s Station=0
    ..;s Station=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,Station))
    ..s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMDR,LocID)
    ..s Station=$p(StatOrderDR,"||",1)            //站点ID(多院区)
    ..q:Station=""
    ..q:Station'=MedcalStation
    ..s CRMORowId=0
    ..s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",PIOIRowID,CRMORowId))
    ..q:CRMORowId=""
    ..s OEOrdItem=$p($g(^DHCPECRMO(CRMORowId)),"^",1)
	..q:OEOrdItem="" 
	..s OEDId=$o(^DHCOEDISQTY(0,"OEORI",OEOrdItem,""),-1)
	..q:OEDId="" 
	..s OEDStatus=$p($G(^DHCOEDISQTY(OEDId)),"^",7) //药品状态
	..i OEDStatus="R" s ControlFlag=1    
	..
	..//i (InvPrtId'="")&&(OEDStatus="C") d
	..i (OEDStatus="C") d
	...//发药退药申请
	...s incId=$o(^INCI(0,"ARCIM_DR",+ARCIMDR,0))
	...	s UOMFac=1
	...	i incId'="" d
	....s bUom=$p($g(^INCI(incId,1)),"^",10)
	....//基本单位
	....s pUom=$p($g(^INCI(incId,3)),"^",6)
	....//入库单位（正包装的）
	....//b ;d2
	....s UOMFac= ##class(PHA.FACE.OUT.Com).UOMFac(pUom,bUom)
	...s myQty=$G(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",PIOIRowID))
	...i +myQty=0 s myQty=1
	...s myQty=myQty*UOMFac
	...s RecLoc=$p($g(^DHCPEPreIADM($p(PIOIRowID,"||",1),"ORDITEM",$p(PIOIRowID,"||",2))),"^",17) //接收科室
	...s PrescNo=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",14) //处方号
	...s PHDROWID="",phdrowid="" // 先循环取有效记录
	...f  s PHDROWID=$o(^DHCPHDI(0,"OEORI",OEOrdItem,PHDROWID),-1) q:(PHDROWID="")||(phdrowid'="")  d
	....s PHDSUB=""
	....f  s PHDSUB=$o(^DHCPHDI(0,"OEORI",OEOrdItem,PHDROWID,PHDSUB),-1) q:(PHDSUB="")||(phdrowid'="")  d
	.....q:($p(^DHCPHDI(PHDROWID,"PHDI",PHDSUB),"^",10)'=1)
	.....S phdrowid=PHDROWID_"||"_PHDSUB  //发药子表ID
	...s PHDROWID=$p(phdrowid,"||",1)
	...s PHDSUB=$p(phdrowid,"||",2)
	...s ordstr=OEOrdItem_"^"_myQty_"^1^"_phdrowid_"^"_"" //医嘱Id^数量^是否欠药(体检传1)^发药子表Id^退费申请Id(体检传空)
	...s ordstr=""
	...Q:$D(^DHCPEDataEx("SendPHDRequest",OEOrdItem))
	...s subsub=""
	...f  s subsub=$o(^DHCPHDI(PHDROWID,"PHDI",PHDSUB,"INCLB",subsub)) q:(subsub="")  d
	....s:(ordstr'="") ordstr=ordstr_$c(2)_OEOrdItem_"^"_myQty_"^1^"_phdrowid_"||"_subsub_"^"_""
	....s:(ordstr="") ordstr=OEOrdItem_"^"_myQty_"^1^"_phdrowid_"||"_subsub_"^"_"H"_OEOrdItem  // 申请ID H+医嘱ID
	...s flag=##class(PHA.FACE.OUT.Method).SaveOutPhReq(RecLoc,PrescNo,ordstr,"28",userId)
	...S ^DHCPEDataEx("SendPHDRequest2",OEOrdItem)=RecLoc_"@"_PrescNo_"@"_ordstr_"@"_"28"_"@"_userId
	...//s flag=##class(web.DHCSTINTERFACE).SaveOutPhRequestnew(RecLoc,"",PrescNo,ordstr,"",userId)
	...S ^DHCPEDataEx("SendPHDRequest",OEOrdItem)=$H_"^"_flag
	...i flag<0 s ControlFlag=2 //退药申请失败
	...e  d ##class(web.DHCPE.AdmRecordManager).Insert(+PIOIRowID,"P","DrugApply",userId,OEOrdItem)
	
	.
	.i itemtype="2"  d       //为医嘱套
	.s PIOERowID=$P(preOrdItemId,"||",1,2)
	.s childsub=0
	.f  s childsub=$o(^DHCPEPreIADM(0,"OrdEnt",PIOERowID,$p(PIOERowID,"||",1),childsub))  q:childsub=""  d
	..s PIOIRowID=$p(PIOERowID,"||",1)_"||"_childsub
    ..s ARCIMDR=$p($g(^DHCPEPreIADM($p(PIOIRowID,"||",1),"ORDITEM",$p(PIOIRowID,"||",2))),"^",1)
    ..;s Station=0
    ..;s Station=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,Station))
    ..s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMDR,LocID)
    ..s Station=$p(StatOrderDR,"||",1)            //站点ID(多院区)
    ..q:Station=""
    ..q:Station'=MedcalStation
    ..s incId=$o(^INCI(0,"ARCIM_DR",+ARCIMDR,0))
	..s UOMFac=1
	..i incId'="" d
	...s bUom=$p($g(^INCI(incId,1)),"^",10)
	...//基本单位
	...s pUom=$p($g(^INCI(incId,3)),"^",6)
	...//入库单位（正包装的）
	...//b ;d2
	...s UOMFac= ##class(PHA.FACE.OUT.Com).UOMFac(pUom,bUom)
	..s myQty=$G(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",PIOIRowID))
	..i +myQty=0 s myQty=1
	..s myQty=myQty*UOMFac
 	..s CRMORowId=0
    ..s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",PIOIRowID,CRMORowId))
    ..q:CRMORowId=""
    ..s OEOrdItem=$p($g(^DHCPECRMO(CRMORowId)),"^",1)
	..q:OEOrdItem="" 
	..s OEDId=$o(^DHCOEDISQTY(0,"OEORI",OEOrdItem,""),-1)
	..q:OEDId="" 
	..s OEDStatus=$p($g(^DHCOEDISQTY(OEDId)),"^",7)  //药品状态
	..i OEDStatus="R" s ControlFlag=1  
	..	
	..//i (InvPrtId'="")&&(OEDStatus="C") d
	..i (OEDStatus="C") d
	...//发药退药申请
	...s RecLoc=$p($g(^DHCPEPreIADM($p(PIOIRowID,"||",1),"ORDITEM",$p(PIOIRowID,"||",2))),"^",17) //接收科室
	...s PrescNo=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",14) //处方号
	...s PHDROWID="",phdrowid=""
	...f  s PHDROWID=$o(^DHCPHDI(0,"OEORI",OEOrdItem,PHDROWID),-1) q:(PHDROWID="")||(phdrowid'="")  d
	....s PHDSUB=""
	....f  s PHDSUB=$o(^DHCPHDI(0,"OEORI",OEOrdItem,PHDROWID,PHDSUB),-1) q:(PHDSUB="")||(phdrowid'="")  d
	.....q:($p(^DHCPHDI(PHDROWID,"PHDI",PHDSUB),"^",10)'=1)
	.....S phdrowid=PHDROWID_"||"_PHDSUB  //发药子表ID
	...s PHDROWID=$p(phdrowid,"||",1)
	...s PHDSUB=$p(phdrowid,"||",2)
	...s ordstr=OEOrdItem_"^1^1^"_phdrowid_"^"_"" //医嘱Id^数量^是否欠药(体检传1)^发药子表Id^退费申请Id(体检传空)
	...s ordstr=""
	...Q:$D(^DHCPEDataEx("SendPHDRequest",OEOrdItem))
	...s subsub=""
	...f  s subsub=$o(^DHCPHDI(PHDROWID,"PHDI",PHDSUB,"INCLB",subsub)) q:(subsub="")  d
	....s:(ordstr'="") ordstr=ordstr_$c(2)_OEOrdItem_"^"_myQty_"^1^"_phdrowid_"||"_subsub_"^"_""
	....s:(ordstr="") ordstr=OEOrdItem_"^"_myQty_"^1^"_phdrowid_"||"_subsub_"^"_"H"_OEOrdItem
	...s flag=##class(PHA.FACE.OUT.Com).SaveOutPhReq(RecLoc,PrescNo,ordstr,"28",userId)
	...//s flag=##class(web.DHCSTINTERFACE).SaveOutPhRequestnew(RecLoc,"",PrescNo,ordstr,"",userId)
	...S ^DHCPEDataEx("SendPHDRequest",OEOrdItem)=$H_"^"_flag
	...i flag<0 s ControlFlag=2 //退药申请失败 
	...e  d ##class(web.DHCPE.AdmRecordManager).Insert(+PIOIRowID,"P","DrugApply",userId,OEOrdItem)
	else  d
	.s InvPrtDR=Str
	.s ControlFlag=..GetDrugDataByInvPrt(InvPrtDR,LocID)
   //w !,"ControlFlag:"_ControlFlag
 q ControlFlag
}

/// creator:sxt
/// creatdate:2020-07-23
/// description: 根据fee表id取消退药申请
/// outPut:保存成功，返回0，保存失败返回其他
/// w ##class(web.DHCPE.ItemFeeList).CancleDrugApply(487,"1^827||1||1","temp","15.00")
ClassMethod CancleDrugApply(ItemFeeID, Type, UserID As %String = "")
{
	s ret=0
	i Type=1 d
	.s preOrdItemId=$p(ItemFeeID,"||",1,2)
	.s CRMORDER=$o(^DHCPECRMO(0,"CRMORI",preOrdItemId,0))
	.q:(CRMORDER="") 
	.s OEORI=$p($g(^DHCPECRMO(CRMORDER)),"^",1)
	.q:('$d(^DHCPEDataEx("SendPHDRequest",OEORI)))
	.s ret= ..CancelDrugApply(OEORI,UserID)
	.
	i Type=2 d
	.s childsub=0
	.f  s childsub=$o(^DHCPEPreIADM(0,"OrdEnt",ItemFeeID,$p(ItemFeeID,"||",1),childsub))  q:childsub=""  d
	..s PIOIRowID=$p(ItemFeeID,"||",1)_"||"_childsub
    ..s CRMORDER=$o(^DHCPECRMO(0,"CRMORI",$P(PIOIRowID,"||",1,2),0))
	..q:(CRMORDER="") 
	..s OEORI=$p($g(^DHCPECRMO(CRMORDER)),"^",1)
	..;S ^TEMPDHCPE("OEORI",PIOIRowID)=OEORI
	..q:('$d(^DHCPEDataEx("SendPHDRequest",OEORI)))
	..s ret= ..CancelDrugApply(OEORI,UserID)
	q ret
}

// w ##class(web.DHCPE.ItemFeeList).CancelDrugApply("5561")

ClassMethod CancelDrugApply(OEID, UserID As %String = "")
{
	s ret=0
	s cancel=##class(PHA.FACE.OUT.Com).DelOutPhReq(OEID_"^H"_OEID)
	q:(cancel'=0) cancel
	
	s PAADM=$P($g(^OEORD(+OEID)),"^",1)
	d ##class(web.DHCPE.AdmRecordManager).Insert(PAADM,"A","CancelDrugApply",UserID,OEID)
	k ^DHCPEDataEx("SendPHDRequest",OEID)
	q 0
}

// w ##class(web.DHCPE.ItemFeeList).GetDrugDataByInvPrt("5561")

ClassMethod GetDrugDataByInvPrt(InvPrtDR, LocID As %Library.String = "")
{
 //退费时，判断是否存在已发药的记录
 s MedcalStation=$G(^DHCPESetting("DHCPE","StationId_Medical",LocID))
 s Flag=0
 s DataStr=$G(^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtDR))
 i DataStr'=""  
 {                         //部分退费
 s ItemFeeIDStr=$P(DataStr,";",1)
 s ItemFeeIDLength=$l(ItemFeeIDStr,",")
 for i=2:1:ItemFeeIDLength-1
 {   
 	 s ItemFeeIDData=$p(ItemFeeIDStr,",",i)
	 s ItemType=$p(ItemFeeIDData,"^",1)
	 s ItemFeeID=$p(ItemFeeIDData,"^",2)
	
	 s PIORowID=$P(ItemFeeID,"||",1,2)
	 q:PIORowID="" 
	 if ItemType="1"  d
     .s ARCIMDR=$p($g(^DHCPEPreIADM($p(PIORowID,"||",1),"ORDITEM",$p(PIORowID,"||",2))),"^",1)
     .q:ARCIMDR=""
     .;s Station=0
     .;s Station=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,Station))
     .s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMDR,LocID)
     .s Station=$p(StatOrderDR,"||",1)            //站点ID(多院区)
     .q:Station=""
     .q:Station'=MedcalStation
     .s CRMORowId=0
     .s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",PIORowID,CRMORowId))
	 .q:CRMORowId=""
     .s OEOrdItem=$p($g(^DHCPECRMO(CRMORowId)),"^",1)
     .q:OEOrdItem="" 
     .s OEDId=$o(^DHCOEDISQTY(0,"OEORI",OEOrdItem,""),-1)
	 .q:OEDId="" 
	 .s OEDStatus=$p($G(^DHCOEDISQTY(OEDId)),"^",7)
     .i OEDStatus="C" s Flag=1
   
    else  d
    .q:PIORowID=""
    .s childsub=0
	.f  s childsub=$o(^DHCPEPreIADM(0,"OrdEnt",PIORowID,$p(PIORowID,"||",1),childsub))  q:childsub=""  d
	..s PIOIItemRowID=$p(PIORowID,"||",1)_"||"_childsub
	..s ARCIMDR=$p($g(^DHCPEPreIADM($p(PIOIItemRowID,"||",1),"ORDITEM",$p(PIOIItemRowID,"||",2))),"^",1)
	..q:ARCIMDR=""
	..;s Station=0
	..;s Station=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,Station))
	..s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMDR,LocID)
    ..s Station=$p(StatOrderDR,"||",1)            //站点ID(多院区)
    ..q:Station=""
	..q:Station'=MedcalStation
 	..s CRMORowId=0
 	..s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",PIOIItemRowID,CRMORowId))
   	..q:CRMORowId=""
   	..s OEOrdItem=$p($g(^DHCPECRMO(CRMORowId)),"^",1)
	..q:OEOrdItem="" 
	..s OEDId=$o(^DHCOEDISQTY(0,"OEORI",OEOrdItem,""),-1)
	..q:OEDId="" 
	..s OEDStatus=$p($G(^DHCOEDISQTY(OEDId)),"^",7)
	..i OEDStatus="C" s Flag=1  
	 }
 }
 else   
 {   //全退
	s PBID=$p($g(^DHCPEINVPRT(InvPrtDR)),"^",3)
	s preAuditIds=""
	s PAPBID=0
	f  s PAPBID=$o(^DHCPEPAPBR(0,"PBDR",PBID,PAPBID)) q:PAPBID=""  d
	.s PAID=$p($g(^DHCPEPAPBR(PAPBID)),"^",1)
	.i preAuditIds=""  s preAuditIds=PAID
	.else  s preAuditIds=preAuditIds_","_PAID

	s j=1
	while(j<=$l(preAuditIds,",")){
		s preAuditId=$p(preAuditIds,",",j)
		s j=j+1
		continue:preAuditId=""
		s preAdmId=0
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:((preAdmId=""))  d
		.s childsub=0
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub)) q:((childsub=""))  d
		..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",2)'=""	//判断是否是套餐中的项目
		..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
		..s ARCIMDR=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",1)
		..q:ARCIMDR=""
     	..s PIOIRowID=preAdmId_"||"_childsub
     	..;s Station=0
     	..;s Station=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,Station))
     	..s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMDR,LocID)
    	..s Station=$p(StatOrderDR,"||",1)            //站点ID(多院区)
   		..q:Station=""
     	..q:Station'=MedcalStation
		..s CRMORowId=0
    	..s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",PIOIRowID,CRMORowId))
    	..s OEOrdItem=$p($g(^DHCPECRMO(CRMORowId)),"^",1)
		..q:OEOrdItem="" 
		..s OEDId=$o(^DHCOEDISQTY(0,"OEORI",OEOrdItem,""),-1)
		..q:OEDId="" 
		..s OEDStatus=$p($G(^DHCOEDISQTY(OEDId)),"^",7)
		..i OEDStatus="C" s Flag=1  
		s preAdmId=0
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId)) q:((preAdmId=""))  d
		.s childsub=0
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",preAuditId,preAdmId,childsub)) q:((childsub=""))  d
		..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
		..s ItemSub=0
		..f  s ItemSub=$o(^DHCPEPreIADM(0,"OrdEnt",preAdmId_"||"_childsub,preAdmId,ItemSub)) q:ItemSub=""  d
		...s ARCIMDR=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",ItemSub)),"^",1)
		...s PIOIRowID=preAdmId_"||"_childsub
		...;s Station=0
     	...;s Station=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,Station))
     	...s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMDR,LocID)
    	...s Station=$p(StatOrderDR,"||",1)            //站点ID(多院区)
   		...q:Station=""
     	...q:Station'=MedcalStation
		...s CRMORowId=0
    	...s CRMORowId=$o(^DHCPECRMO(0,"CRMORI",PIOIRowID,CRMORowId))
    	...s OEOrdItem=$p($g(^DHCPECRMO(CRMORowId)),"^",1)
		...q:OEOrdItem="" 
		...s OEDId=$o(^DHCOEDISQTY(0,"OEORI",OEOrdItem,""),-1)
		...q:OEDId="" 
		...s OEDStatus=$p($G(^DHCOEDISQTY(OEDId)),"^",7)
		...i OEDStatus="C" s Flag=1  
	}
 }
 q Flag
}

/// w ##class(web.DHCPE.ItemFeeList).DrugDataToPharmacy()
/// 返回值 0为没有申请退费，1申请退费  2 后台数据有问题 
ClassMethod DrugDataToPharmacy(OEOrdItem)
{
   s UFlag=0
   q:OEOrdItem="" "2"
   s CRMORowId=0
   s CRMORowId=$o(^DHCPECRMO(0,"OEORI",OEOrdItem,CRMORowId)) 
   q:CRMORowId="" "2"
   i $d(^DHCPEDataEx("DHCPEDrugApply","SelectId",OEOrdItem)) s UFlag=1   //add by yupeng
   s CRMOCRMORI=$p(^DHCPECRMO(CRMORowId),"^",2)
   s AdmId=$p(CRMOCRMORI,"||",1)
   s ChildId=$p(CRMOCRMORI,"||",2)
   s PIOIOrdEntDR=$p(^DHCPEPreIADM(AdmId,"ORDITEM",ChildId),"^",2)
   s feesub=0	
   i PIOIOrdEntDR'="" d
   .f  s feesub=$O(^DHCPEPreIADM(AdmId,"ORDENT",$P(PIOIOrdEntDR,"||",2),"FEE",feesub)) q:feesub=""  d
   ..s preAuditID=$P(^DHCPEPreIADM(AdmId,"ORDENT",$P(PIOIOrdEntDR,"||",2),"FEE",feesub),"^",5)
   ..q:preAuditID=""
   ..s auditStat=$P(^DHCPEPreA(preAuditID),"^",21)
   ..q:auditStat="NU"
   ..s papbID=$O(^DHCPEPAPBR(0,"PADR",preAuditID,0))
   ..q:papbID=""
   ..s pbID=$P(^DHCPEPAPBR(papbID),"^",2)
   ..s invID=$O(^DHCPEINVPRT(0,"PB",pbID,0))
   ..s refundIDs=$G(^DHCPEDataEx("DHCPERefundApply","SelectIds",invID))
   ..s:refundIDs[(",2^"_PIOIOrdEntDR_"||"_feesub_",") UFlag=1
   ..i ($D(^DHCPEDataEx("DHCPERefundApply","SelectIds",invID))&&($G(^DHCPEDataEx("DHCPERefundApply","SelectIds",invID))=""))  d
   ...s UFlag=1
   e  d
   .f  s feesub=$O(^DHCPEPreIADM(AdmId,"ORDITEM",ChildId,"FEE",feesub)) q:feesub=""  d
   ..s preAuditID=$P(^DHCPEPreIADM(AdmId,"ORDITEM",ChildId,"FEE",feesub),"^",5)
   ..q:preAuditID=""
   ..s auditStat=$P(^DHCPEPreA(preAuditID),"^",21)
   ..q:auditStat="NU"
   ..s papbID=$O(^DHCPEPAPBR(0,"PADR",preAuditID,0))
   ..q:papbID=""
   ..s pbID=$P(^DHCPEPAPBR(papbID),"^",2)
   ..s invID=$O(^DHCPEINVPRT(0,"PB",pbID,0))
   ..s refundIDs=$G(^DHCPEDataEx("DHCPERefundApply","SelectIds",invID))
   ..s:refundIDs[(",1^"_AdmId_"||"_ChildId_"||"_feesub_",") UFlag=1
   ..i ($D(^DHCPEDataEx("DHCPERefundApply","SelectIds",invID))&&($G(^DHCPEDataEx("DHCPERefundApply","SelectIds",invID))=""))  d
   ...s UFlag=1
   q UFlag
}

/// creator:yupeng
/// creatdate:2012-12-19
/// description:保存视同收费未结算退药信息
/// outPut:保存成功,返回1,保存失败返回0
ClassMethod SetApplyDrug(selectId As %String, OEORIRowId As %String)
{
	q:OEORIRowId="" 0
	i selectId="" d
	.k ^DHCPEDataEx("DHCPEDrugApply","SelectId",OEORIRowId)
	e  d
	.s ^DHCPEDataEx("DHCPEDrugApply","SelectId",OEORIRowId)=selectId
	q 1
}

ClassMethod SetRefundRemark(INvPrtId, RefundRemark)
{
	s ^DHCPEDataEx("DHCPERefundApply","RefundRemark",INvPrtId)=RefundRemark
	q 0
}

/// Creator:      xy
/// Creatdate:    2020-9-9
/// Description: 撤销退费申请
/// Input:       InvPrtId(发票ID),UserID(操作人员ID)
/// Debug:  d ##class(web.DHCPE.ItemFeeList).GBCancelRefundApp()
ClassMethod BCancelRefundApp(InvPrtId As %String, UserID As %String = "")
{
	q:InvPrtId="" ""
	q:'$d(^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId)) ""
	
	TSTART
	//撤销全退申请
	i ($g(^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId))="") d
	.s item=""
	.f  s item=$o(^DHCPEOEITEM(InvPrtId,"OEITEM",item)) q:(item="")  d
	..s CRMORDER=$o(^DHCPECRMO(0,"CRMORI",item,0))
	..q:CRMORDER=""
	..s OEORI=$p($g(^DHCPECRMO(CRMORDER)),"^",1)
	..q:OEORI=""
	..q:('$d(^DHCPEDataEx("SendPHDRequest",OEORI)))
	..s CancelRet= ..CancelDrugApply(OEORI,UserID)
	..i CancelRet'=0 goto CancelDrugAppErr
	.s PAADM=$P($g(^DHCPEINVPRT(InvPrtId)),"^",2)
	.//插入撤销全退申请日志
	.d ##class(web.DHCPE.AdmRecordManager).Insert(PAADM,"A","CancelAllRefund",UserID,InvPrtId) 
	e  d
	.s IDS=$p($g(^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId)),";",1)
	.s length=$l(IDS)
	.for i=1:1:length d
	..s OneInfo=$p(IDS,",",i)
	..q:(OneInfo="")
	..s itemtype=$p(OneInfo,"^",1)
	..s preOrdItemId=$p($p(OneInfo,"^",2),"||",1,2)
	..i itemtype="2"  d       //为医嘱套
	...s PIOERowID=$P(preOrdItemId,"||",1,2)
	...s childsub=0
	...f  s childsub=$o(^DHCPEPreIADM(0,"OrdEnt",PIOERowID,$p(PIOERowID,"||",1),childsub))  q:childsub=""  d
	....s PIOIRowID=$p(PIOERowID,"||",1)_"||"_childsub
    ....s CRMORDER=$o(^DHCPECRMO(0,"CRMORI",$P(preOrdItemId,"||",1,2),0))
	....q:(CRMORDER="") 
	....s OEORI=$p($g(^DHCPECRMO(CRMORDER)),"^",1)
	....q:OEORI=""
	....q:('$d(^DHCPEDataEx("SendPHDRequest",OEORI)))
	....s CancelRet= ..CancelDrugApply(OEORI,UserID)
	....i CancelRet'=0 goto CancelDrugAppErr
	....e  d
	.....k ^DHCPEDataEx("SendPHDRequest",OEORI)
	..i itemtype="1"  d       //为医嘱套
	...s CRMORDER=$o(^DHCPECRMO(0,"CRMORI",preOrdItemId,0))
	...q:(CRMORDER="") 
	...s OEORI=$p($g(^DHCPECRMO(CRMORDER)),"^",1)
	...q:OEORI=""
	...q:('$d(^DHCPEDataEx("SendPHDRequest",OEORI)))
	...s CancelRet= ..CancelDrugApply(OEORI,UserID)
	...i CancelRet'=0 goto CancelDrugAppErr
	...e  d
	....k ^DHCPEDataEx("SendPHDRequest",OEORI)

	k ^DHCPEDataEx("DHCPERefundApply","SelectIds",InvPrtId)
	k ^DHCPEDataEx("DHCPERefundApply","SelectIdsUser",InvPrtId)
	
	TCommit
	q 0
	
CancelDrugAppErr
	TRollBack	
	q "-1"
}

/// creator:		xy
/// creatdate:		2020-9-28
/// description:	判断个人/团体是否有发过药品
/// Input:          RowID:预约ID,Type:G/I
/// debug:  d ##class(web.DHCPE.ItemFeeList).IsMedicalDispensing()
ClassMethod IsMedicalDispensing(Type, RowID)
{
	s flag=0
	if (Type="I"){
		s IADM=$o(^DHCPEIADM(0,"CRMADM",RowID,0))
		q:IADM="" flag
		s LocID=$p($g(^DHCPEPreIADM(RowID)),"^",26)
		s CRMORowId=0
		f  s CRMORowId=$o(^DHCPECRMO(0,"IADM",IADM,CRMORowId)) q:(CRMORowId="")||(flag=1)  d
		.s OEORIDR=$p($g(^DHCPECRMO(CRMORowId)),"^",1)
		.s ItmMastDR=$p($g(^OEORD($p(OEORIDR,"||",1),"I",$p(OEORIDR,"||",2),1)),"^",2)
        .q:ItmMastDR="" 
	    .;s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
	    .;q:(STRowId="")&&($g(^DHCPESetting("DHCPE","StationId_Medical"))="") 
	    .;q:STRowId'=$g(^DHCPESetting("DHCPE","StationId_Medical"))
	    .S OrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItmMastDR,LocID)
        .s STRowId=+OrderID
	    .q:(STRowId="")&&($g(^DHCPESetting("DHCPE","StationId_Medical",LocID))="") 
	    .q:STRowId'=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID)) 
	    .s OEDId=$o(^DHCOEDISQTY(0,"OEORI",OEORIDR,""),-1)
		.q:OEDId="" 
		.s OEDStatus=$p($g(^DHCOEDISQTY(OEDId)),"^",7)
		.i OEDStatus="C" s flag=1 //已发药
		
		
	}elseif (Type="G"){
		S PGADM=RowID
		s PIADM=""
		f  s PIADM=$o(^DHCPEPreIADM(0,"PGADM",PGADM,PIADM)) q:PIADM=""  d
		.s Status=$p($g(^DHCPEPreIADM(PIADM)),"^",8)
		.q:Status="CANCELPE"
		.s LocID=$p($g(^DHCPEPreIADM(PIADM)),"^",26)
		.s IADM=$o(^DHCPEIADM(0,"CRMADM",PIADM,0))
		.q:IADM=""
		.s CRMORowId=0
		.f  s CRMORowId=$o(^DHCPECRMO(0,"IADM",IADM,CRMORowId)) q:(CRMORowId="")||(flag=1)  d
		..s OEORIDR=$p($g(^DHCPECRMO(CRMORowId)),"^",1)
		..s ItmMastDR=$p($g(^OEORD($p(OEORIDR,"||",1),"I",$p(OEORIDR,"||",2),1)),"^",2)
        ..q:ItmMastDR="" 
	    ..;s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
	    ..;q:(STRowId="")&&($g(^DHCPESetting("DHCPE","StationId_Medical"))="") 
	    ..;q:STRowId'=$g(^DHCPESetting("DHCPE","StationId_Medical")) 
	    ..S OrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItmMastDR,LocID)
        ..s STRowId=+OrderID
	    ..q:(STRowId="")&&($g(^DHCPESetting("DHCPE","StationId_Medical",LocID))="") 
	    ..q:STRowId'=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID))
	    ..s OEDId=$o(^DHCOEDISQTY(0,"OEORI",OEORIDR,""),-1)
		..q:OEDId="" 
		..s OEDStatus=$p($g(^DHCOEDISQTY(OEDId)),"^",7)
		..i OEDStatus="C" s flag=1 //已发药 
		
	}
	q flag
}

/// Creator：    xy 
/// CreatDate：  20220816
/// Description: 合并审核记录
/// Input:       AuditIds:审核记录ID,审核记录ID,...
/// Return：      
/// debug: w ##class(web.DHCPE.ItemFeeList).MergeAudit("25832,26399,26400")
ClassMethod MergeAudit(AuditIds As %Library.String = "")
{
	s errs=""
	s FromAudit=$p(AuditIds,",",1) //要被合并的主审核记录
	s fromAuditData=$g(^DHCPEPreA(FromAudit))
	s pAdmType=$p(fromAuditData,"^",1)
	s GIAdmId=$p(fromAuditData,"^",2)
	s ToAuditIds=$p(AuditIds,",",2,100)
	s AuditIdsLength=$l(ToAuditIds,",")
	
	f i=1:1:AuditIdsLength 
	{
		TStart	
			s OneAuditId=$P(ToAuditIds,",",i)
			s OneAuditIdData=$g(^DHCPEPreA(OneAuditId))
	
	        //p(OneAuditIdData,"^",14)  收费状态
			if $p(OneAuditIdData,"^",14)'="UNCHARGED"
			{	
				s errs="已经收费，不能合并!"
				goto MergeAuditErrTrap
			}
			
			//$p(fromAuditData,"^",1) ADM类型(I/G),$p(fromAuditData,"^",1) CRMADM, $p(fromAuditData,"^",3) ADM
			if (($p(fromAuditData,"^",1)'=$p(OneAuditIdData,"^",1))||($p(fromAuditData,"^",2)'=$p(OneAuditIdData,"^",2))||($p(fromAuditData,"^",3)'=$p(OneAuditIdData,"^",3)))
			{	
				s errs="不属于同一个登记记录，不能合并!"
				goto MergeAuditErrTrap
			}	
	        
	        //分组ID
			if (($p(fromAuditData,"^",22)'=$p(OneAuditIdData,"^",22)))
			{	
				//s errs="审核记录分组不同，不能合并!"
				//goto MergeAuditErrTrap
			}		
	
	        
	        //项目不打折标记
	        i ($p(fromAuditData,"^",24)="") S $p(fromAuditData,"^",24)="N"
	        i ($p(OneAuditIdData,"^",24)="") s $p(OneAuditIdData,"^",24)="N"
	        if (($p(fromAuditData,"^",24)'=$p(OneAuditIdData,"^",24)))
	        {
		        s errs="审核记录不打折标记不同，不能合并!"
				goto MergeAuditErrTrap
	        }
	        
	        //$p(fromAuditData,"^",5) 折扣率 $p(fromAuditData,"^",19) 优惠方式   $p(fromAuditData,"^",20) 类型（PRE:预约,ADD:加项）
			if (($p(fromAuditData,"^",5)'=$p(OneAuditIdData,"^",5))||($p(fromAuditData,"^",19)'=$p(OneAuditIdData,"^",19))||($p(fromAuditData,"^",20)'=$p(OneAuditIdData,"^",20)))
			{	
				s errs="审核记录优惠方式不同，不能合并!"
				goto MergeAuditErrTrap
			}
			if (($p(fromAuditData,"^",10)'=$p(OneAuditIdData,"^",10)))
	        {
		        s errs="审核状态不一致，不能合并!"
				goto MergeAuditErrTrap
	        }
	        if (($p(fromAuditData,"^",14)'=$p(OneAuditIdData,"^",14)))
	        {
		        s errs="收费状态不一致，不能合并!"
				goto MergeAuditErrTrap
	        }
			
	
	
	///处理审核记录对应的项目
		s preAdmId=""
		s FeeType=1
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",OneAuditId,preAdmId)) q:((preAdmId="")||(errs'=""))  d
		.s childsub=""
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",OneAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
		..s feesub=0
		..f  s feesub=$o(^DHCPEPreIADM(0,"PAORDITEM",OneAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
		...s itemfeeid=preAdmId_"||"_childsub_"||"_feesub
		...d MergeItemFeeByID(FeeType,itemfeeid)
		
		if errs'="" goto MergeAuditErrTrap
		
		///处理审核记录对应的套餐
		s preAdmId=""
		s FeeType=2
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDENT",OneAuditId,preAdmId)) q:((preAdmId="")||(errs'=""))  d
		.s childsub=""
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",OneAuditId,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
		..s feesub=0
		..f  s feesub=$o(^DHCPEPreIADM(0,"PAORDENT",OneAuditId,preAdmId,childsub,feesub)) q:((feesub="")||(errs'=""))  d
		...s itemfeeid=preAdmId_"||"_childsub_"||"_feesub
		...d MergeItemFeeByID(FeeType,itemfeeid)
		if errs'="" goto MergeAuditErrTrap
		
		
	///重新计算审核表费用
	///修改返回值判断 
	i pAdmType="G" 
	{	//s preAdmId=$p($g(^DHCPEGADM(pAdmId)),"^",2)
		s SQLCODE= ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(GIAdmId,"")}
	else
	{	//s preAdmId=$p($g(^DHCPEIADM(pAdmId)),"^",4) 
		s SQLCODE= ##class(web.DHCPE.PreIADM).UpdatePersonAuditAmount(GIAdmId)
	}
	//d ##class(web.DHCPE.PreIADM).UpdateAuditSaleAmount(FromAuditId,ToAuditId)
	if SQLCODE'=0
	{
		s errs="重新计算费用错误"
		goto MergeAuditErrTrap
	}
	
	&SQL(delete from DHC_PE_PreAudit where PA_RowId=:OneAuditId)
	TCommit
   
	
	}
	q "合并成功"	
MergeItemFeeByID(FeeType,itemfeeid)
	i FeeType=1 d
	.&SQL(Update DHC_PE_PreIOrdItemFee Set PIOIF_PAudit_DR=:FromAudit Where PIOIF_RowId=:itemfeeid)
	.if SQLCODE s errs="合并费用明细失败!"
	e  d
	.&SQL(Update DHC_PE_PreIOrdEntFee Set PIOEF_PAudit_DR=:FromAudit Where PIOEF_RowId=:itemfeeid)
	.if SQLCODE s errs="合并费用明细失败!"	
	q "" 			
	
				
MergeAuditErrTrap
	TRollBack	
	q errs
}

}
