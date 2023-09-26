Class web.DHCEQ.Risk.BUSEvaluate Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Risk.BUSEvaluate","GetRiskEvaluate","2","1","1")
Query GetRiskEvaluate(SourceType As %String = "", SourceID As %String = "", RowID As %String = "") As %Query(ROWSPEC = "TRiskItemDR:%String,TRiskItem:%String,TWeights:%String,TRiskItemValueDR:%String,TRiskItemValue:%String,TRiskEvaluationDR:%String,TRiskEvaluationListDR:%String,TOpt:%String")
{
}

ClassMethod GetRiskEvaluateExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", RowID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i (SourceType="")||(SourceID="") Quit $$$OK
	s index=1
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCRiskItemValue",rowid)) quit:rowid=""  d
	.d ResetVariablesGetRiskEvaluate
	.q:$p($g(^DHCEQCCode("DHCEQCRiskItemValue",rowid)),"^",5)="Y"
	.s TRiskItemDR=$p($g(^DHCEQCCode("DHCEQCRiskItemValue",rowid)),"^",1)
	.s TRiskItem=$p($g(^DHCEQCCode("DHCEQCRiskItem",TRiskItemDR)),"^",2)
	.q:$p($g(^DHCEQCCode("DHCEQCRiskItem",TRiskItemDR)),"^",4)="Y" //modify hly 20200115 bug:1177919
	.s TWeights=$p($g(^DHCEQCCode("DHCEQCRiskItemValue",rowid)),"^",2)
	.s TRiskItemValueDR=rowid
	.s TRiskItemValue=$p($g(^DHCEQCCode("DHCEQCRiskItemValue",rowid)),"^",3)
	.s relrowid=0
	.for  s relrowid=$o(^DHCEQRiskEvaluationList(0,"RELRiskItemValue",rowid,relrowid)) quit:relrowid=""  d
	..q:$p($g(^DHCEQRiskEvaluationList(relrowid)),"^",1)=""
	..q:$p($g(^DHCEQRiskEvaluationList(relrowid)),"^",1)'=RowID
	..q:$p($g(^DHCEQRiskEvaluation($p($g(^DHCEQRiskEvaluationList(relrowid)),"^",1))),"^",2)'=SourceType
	..q:$p($g(^DHCEQRiskEvaluation($p($g(^DHCEQRiskEvaluationList(relrowid)),"^",1))),"^",3)'=SourceID
	..s TRiskEvaluationDR=$p($g(^DHCEQRiskEvaluationList(relrowid)),"^",1)
	..s TRiskEvaluationListDR=relrowid
	.s TOpt="N"
	.i TRiskEvaluationListDR'="" s TOpt="Y"
	.d OutputRowGetRiskEvaluate
	Quit $$$OK
OutputRowGetRiskEvaluate
	s Data=$lb(TRiskItemDR,TRiskItem,TWeights,TRiskItemValueDR,TRiskItemValue,TRiskEvaluationDR,TRiskEvaluationListDR,TOpt)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRiskEvaluate
	s (TRiskItemDR,TRiskItem,TWeights,TRiskItemValueDR,TRiskItemValue,TRiskEvaluationDR,TRiskEvaluationListDR,TOpt)=""
	quit
}

ClassMethod GetRiskEvaluateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRiskEvaluateExecute ]
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

ClassMethod GetRiskEvaluateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRiskEvaluateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// w ##class(web.DHCEQ.Risk.BUSEvaluate).GetRiskGradeAndScore("1,6,10,16,18")
ClassMethod GetRiskGradeAndScore(RiskItemValueIDs)
{
	i RiskItemValueIDs="" q "^^"
	new RiskItemValueID,len,i,Weight,Score
	s (RiskItemValueID,Weight,Score)=""
	s (len,i)=0
	s len=$L(RiskItemValueIDs,",")
	f i=1:1:len  d
	.s RiskItemValueID=$p(RiskItemValueIDs,",",i)
	.s Score=+$p($g(^DHCEQCCode("DHCEQCRiskItemValue",RiskItemValueID)),"^",2)
	.i Weight="" d
	..s Weight=Score
	.e  d
	..s Weight=Weight+Score 
	q ##class(web.DHCEQ.Risk.BUSEvaluate).GetRiskGradeByScore(Weight)_"^"_Weight
}

/// w ##class(web.DHCEQ.Risk.BUSEvaluate).GetRiskGradeByScore("15")
ClassMethod GetRiskGradeByScore(Weight)
{
	s (MaxRowID,Desc)=""
	s flag=0
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCRiskGrade",rowid)) quit:(rowid="")||(flag'=0)  d
	.q:$p($g(^DHCEQCCode("DHCEQCRiskGrade",rowid)),"^",6)="Y"
	.s (MinValue,MaxValue)=""
	.s MinValue=$p($g(^DHCEQCCode("DHCEQCRiskGrade",rowid)),"^",3)
	.s MaxValue=$p($g(^DHCEQCCode("DHCEQCRiskGrade",rowid)),"^",4)
	.i MinValue="" d
	..i MaxValue>=Weight d
	...s flag=1
	...s MaxRowID=rowid
	.e  d
	..i MaxValue="" d
	...i MinValue<=Weight d
	....s flag=1
	....s MaxRowID=rowid
	..e  d
	...i (MinValue<=Weight)&&(MaxValue>=Weight) d
	....s flag=1
	....s MaxRowID=rowid
	q MaxRowID_"^"_$p($g(^DHCEQCCode("DHCEQCRiskGrade",MaxRowID)),"^",2)
}

ClassMethod SaveRiskEvaluate(val, valList)
{
	new (val, valList)
	Set $ZT="ERRORSaveRiskEvaluate"
	k PLIST
	s User=$p(val,"^",7)
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	;s rowid=$p(val,"^",1)
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",5)
	s PLIST(6)=$p(val,"^",6)
	s PLIST(7)=User
	s PLIST(8)=+$h
	s PLIST(9)=$p($h,",",2)
	s PLIST(10)=$p(val,"^",10)
	TSTART	
	&SQL(Insert Into sqluser.DHC_EQRiskEvaluation Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"
	}
	s RowID=$G(%ROWID)
	s SQLCODE=..SaveRiskEvaluateList(RowID,valList)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"
	}
	TCOMMIT
 	s ID=RowID
 	q SQLCODE_"^"_ID
ERRORSaveRiskEvaluate
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQ.Risk.BUSEvaluate).SaveRiskEvaluateList("65","1^100^10403&1^100^10403")
ClassMethod SaveRiskEvaluateList(RERowID, val)
{
	new Len,Flag,i
	n valList
	k PLISTMX
	i val="" q 0
	i RERowID="" q -1
	
	s Len=$l(val,"&")
	s PLISTMX(2)=RERowID  				
	
	s Flag=0
	for i=1:1:Len
	{
		q:Flag'=0
		s valList=	$p(val,"&",i)
		s RiskItemValueDR= $p(valList,"^",1)
		s PLISTMX(3)=RiskItemValueDR
		s PLISTMX(4)=$p($g(^DHCEQCCode("DHCEQCRiskItemValue",RiskItemValueDR)),"^",2) 	
		&SQL(Insert Into SQLUSER.DHC_EQRiskEvaluationList Values :PLISTMX())
		i SQLCODE
 		{
			s Flag=SQLCODE
 		}
 		q:Flag'=0		
	}
	q Flag
}

/// w ##class(web.DHCEQ.Risk.BUSEvaluate).GetRecentRiskEvaluate("2","1")
ClassMethod GetRecentRiskEvaluate(SourceType As %String = "", SourceID As %String = "")
{
	i (SourceType="")||(SourceID="") q ""
	s MaxRowID=""
	s rerowid=0
	for  s rerowid=$o(^DHCEQRiskEvaluation(0,"Source",SourceType,SourceID,rerowid)) quit:(rerowid="")  d
	.i rerowid>MaxRowID d
	..s MaxRowID=rerowid
	q MaxRowID
}

ClassMethod GetOneRiskEvaluate(rowid As %Library.String = "")
{
	new result
	s (result)=""
	s result= ^DHCEQRiskEvaluation(rowid)
	s RiskGrade=""
	i $p(result,"^",5)'=""  d
	.s RiskGrade=$Piece($Get(^DHCEQCCode("DHCEQCRiskGrade",$p(result,"^",5))),"^",2)
	q result_"^"_RiskGrade
}

ClassMethod SumRiskEvaluate(SourceType As %String = "", SourceID As %String = "")
{
	i (SourceType="")||(SourceID="") q 0
	s Num=0
	s rerowid=0
	for  s rerowid=$o(^DHCEQRiskEvaluation(0,"Source",SourceType,SourceID,rerowid)) quit:(rerowid="")  d
	.s Num=Num+1
	q Num
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Risk.BUSEvaluate","GetRiskEvaluateHistory","2","1","5")
Query GetRiskEvaluateHistory(SourceType As %String = "", SourceID As %String = "", RowID As %String = "") As %Query(ROWSPEC = "TRiskEvaluationDR:%String,TEvaluateUser:%String,TEvaluateDate:%String,TRiskGrade:%String,TWeight:%String")
{
}

ClassMethod GetRiskEvaluateHistoryExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", RowID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i (SourceType="")||(SourceID="") Quit $$$OK
	s index=1
	s rerowid=0
	for  s rerowid=$o(^DHCEQRiskEvaluation(0,"Source",SourceType,SourceID,rerowid)) quit:(rerowid="")  d
	.d ResetVariablesGetRiskEvaluateHistory
	.q:rerowid=RowID
	.s TRiskEvaluationDR=rerowid
	.s TEvaluateUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQRiskEvaluation(rerowid)),"^",6))
	.s TEvaluateDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQRiskEvaluation(rerowid)),"^",7),"date")
	.s TRiskGradeDR=$p($g(^DHCEQRiskEvaluation(rerowid)),"^",5)
	.i TRiskGradeDR'="" s TRiskGrade=$p($g(^DHCEQCCode("DHCEQCRiskGrade",TRiskGradeDR)),"^",2)
	.s TWeight=$p($g(^DHCEQRiskEvaluation(rerowid)),"^",4)
	.d OutputRowGetRiskEvaluateHistory
	Quit $$$OK
OutputRowGetRiskEvaluateHistory
	s Data=$lb(TRiskEvaluationDR,TEvaluateUser,TEvaluateDate,TRiskGrade,TWeight)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRiskEvaluateHistory
	s (TRiskEvaluationDR,TEvaluateUser,TEvaluateDate,TRiskGrade,TWeight,TRiskGradeDRt)=""
	quit
}

ClassMethod GetRiskEvaluateHistoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRiskEvaluateHistoryExecute ]
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

ClassMethod GetRiskEvaluateHistoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRiskEvaluateHistoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 创建:ZC ZC0042 2018-11-02   
/// 描述：根据传入的来源类型以及描述检索相应信息
/// 输入：参数SourceType、Desc
/// 输出：符合条件的信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Risk.BUSEvaluate","GetRiskEvaluateSoucre","1","")
Query GetRiskEvaluateSoucre(SourceType As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TCode:%String,TSourceType:%String,TSourceTypeDesc:%String")
{
}

ClassMethod GetRiskEvaluateSoucreExecute(ByRef qHandle As %Binary, SourceType As %String = "", Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s Desc=$ZCONVERT(Desc ,"U")
 	i SourceType="" Quit $$$OK
 	
 	
 	s CurGroup=%session.Get("LOGON.GROUPID")
	if SourceType="0"
	{
		s equipinfo=##Class(web.DHCEQ.Plat.CTManageLimit).Chanage(##Class(web.DHCEQCommon).GetEquipTypesByGroup(CurGroup))
		s csrowid=0
		f  s csrowid=$o(^DHCEQCCode("DHCEQCStatCat",csrowid)) q:csrowid=""  d
		.d ResetVariablesGetRiskEvaluateSoucre
		.q:$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",4)="Y"
		.q:(0=(##Class(web.DHCEQCommon).Find(equipinfo,$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",12),"Y")))
		.s TName=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",2)
		.s TCode=$p($g(^DHCEQCCode("DHCEQCStatCat",csrowid)),"^",1)
		.q:(Desc'="")&&($ZCONVERT(TName,"U")'[Desc)
		.s TSourceType=SourceType
		.s TSourceTypeDesc=$case(TSourceType,"0":"设备类型","1":"设备分类","2":"设备项","3":"设备","":"其他")
		.s TRowID=csrowid
		.d OutputRowGetRiskEvaluateSoucre
	}
	if SourceType="1"
	{
		s cerowid=0
		f  s cerowid=$o(^DHCEQCCode("DHCEQCEquipeCat",cerowid)) q:cerowid=""  d
		.d ResetVariablesGetRiskEvaluateSoucre
		.q:$p($g(^DHCEQCCode("DHCEQCEquipeCat",cerowid)),"^",7)="Y"
		.s TName=$p($g(^DHCEQCCode("DHCEQCEquipeCat",cerowid)),"^",2)
		.s TCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",cerowid)),"^",1)
		.q:(Desc'="")&&($ZCONVERT(TName,"U")'[Desc)
		.s TSourceType=SourceType
		.s TSourceTypeDesc=$case(TSourceType,"0":"设备类型","1":"设备分类","2":"设备项","3":"设备","":"其他")
		.s TRowID=cerowid
		.d OutputRowGetRiskEvaluateSoucre
	}
	if SourceType="2"
	{
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR)) quit:TEquipTypeDR=""  d
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroup)'=0
		.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
		.s ItemID=0
		.f  s ItemID=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR,ItemID)) quit:ItemID=""  d
		..q:$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",8)="Y"
		..s TName = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",1)
		..s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",2)
		..q:(Desc'="")&&($ZCONVERT(TName ,"U")'[Desc)
		..s TSourceType=SourceType
		..s TSourceTypeDesc=$case(TSourceType,"0":"设备类型","1":"设备分类","2":"设备项","3":"设备","":"其他")
		..s TRowID=ItemID
		..d OutputRowGetRiskEvaluateSoucre
	}
	if SourceType="3"
	{
		s eqrowid=0
		f  s eqrowid=$o(^DHCEQEquip(eqrowid)) q:eqrowid=""  d
		.d ResetVariablesGetRiskEvaluateSoucre
		.q:$p($g(^DHCEQEquip(eqrowid)),"^",59)="Y"
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(eqrowid)),"^",63),CurGroup)'=0
		.s TName=$p($g(^DHCEQEquip(eqrowid)),"^",1)
		.s TCode=$p($g(^DHCEQEquip(eqrowid)),"^",71)
		.q:(Desc'="")&&($ZCONVERT(TName,"U")'[Desc)
		.s TSourceType=SourceType
		.s TSourceTypeDesc=$case(TSourceType,"0":"设备类型","1":"设备分类","2":"设备项","3":"设备","":"其他")
		.s TRowID=eqrowid
		.d OutputRowGetRiskEvaluateSoucre
	}
	Quit $$$OK
OutputRowGetRiskEvaluateSoucre
	s Data=$lb(TRowID,TName,TCode,TSourceType,TSourceTypeDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRiskEvaluateSoucre
	s (TRowID,TName,TCode,TSourceType,TSourceTypeDesc)=""
	quit
}

ClassMethod GetRiskEvaluateSoucreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRiskEvaluateSoucreExecute ]
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

ClassMethod GetRiskEvaluateSoucreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRiskEvaluateSoucreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// Add By ZC0056 2020-02-04
/// 描述:获取有效的评估项目条数
/// 返回值:Num 条数
ClassMethod SumRiskItem()
{
	s Num=0
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCRiskItem",rowid)) quit:rowid=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCRiskItem",rowid)),"^",4)="Y"
	.s Num=Num+1
	q Num
}

}
