Class DHCDoc.DHCDocConfig.ARCIMExt Extends DHCDoc.DHCDocConfig.Common
{

ClassMethod getARCIMConfig(ArcimRowId As %String) As %String
{
	s ID=$O(^DHCItmMast("0","ARCIM",ArcimRowId,0))
	Q:ID="" "0^0^0"
	s NotAutoStop=$P(^DHCItmMast(ID),"^",34)="Y"
	s StopAfterLongOrder=$P(^DHCItmMast(ID),"^",31)="Y"
	s DefSttDateDay=$P(^DHCItmMast(ID),"^",32)
	s DefSttTime=$P(^DHCItmMast(ID),"^",33)
	s AllowLongOrder=$P(^DHCItmMast(ID),"^",35)="Y"
	Q 0_"^"_NotAutoStop_"^"_StopAfterLongOrder_"^"_DefSttDateDay_"^"_DefSttTime_"^"_AllowLongOrder
}

/// w ##class(DHCDoc.DHCDocConfig.ARCIMExt).SaveData($LG(^Wqy("Sa"),1),$LG(^Wqy("Sa"),2))
ClassMethod SaveData(ClsNameStr, InputStr)
{
	;s ^Wqy("Sa")=$LB(ClsNameStr, InputStr)
	s ret=0
	s ClsNameArr=[].%FromJSON(ClsNameStr)
	s InputObj=[].%FromJSON(InputStr)
	TS
	for i=1:1:ClsNameArr.%Size(){
		s rows=InputObj.%Get(i-1)
		continue:'rows.%Size()
		s ClsName=ClsNameArr.%Get(i-1)
		if ClsName="User.DHCItmMast"{
			for j=rows.%Size():-1:1{
				s jsonObj=rows.%Get(j-1)
				s DARCIMARCIMDR=jsonObj.DARCIMARCIMDR
				s:DARCIMARCIMDR="" DARCIMARCIMDR=jsonObj.ARCIMRowid
				if (DARCIMARCIMDR=""){
					s ret="-1^项目不能为空"
					Q
				}
				s ID=$O(^DHCItmMast("0","ARCIM",DARCIMARCIMDR,0))
				if (ID'="")&&(ID'=jsonObj.ID){
					s ret="-1^["_$P(^ARCIM(+DARCIMARCIMDR,1,1),"^",2)_"]项目重复"
					Q
				}
			}
		}elseif ClsName="User.DHCItmConflict"{
			for j=rows.%Size():-1:1{
				s jsonObj=rows.%Get(j-1)
				if 'jsonObj.%IsDefined("ITCConflictItmDR"){
					d rows.%Remove(j-1)
					continue
				}
				s ITCConflictItmDR=jsonObj.ITCConflictItmDR
				if (ITCConflictItmDR=""){
					s ret="-1^互斥项目不能为空"
					Q
				}
				s ITCParRef=jsonObj.ITCParRef
				s Sub=$O(^DHCItmMast("0","CFARCIM",ITCConflictItmDR,ITCParRef,0))
				s ID=$CASE(Sub,"":"",:ITCParRef_"||"_Sub)
				if (ID'="")&&(ID'=jsonObj.ID){
					s ret="-1^互斥项目["_$P(^ARCIM(+ITCConflictItmDR,1,1),"^",2)_"]重复"
					Q
				}
			}
		}elseif ClsName="User.DHCItmReplace"{
			for j=rows.%Size():-1:1{
				s jsonObj=rows.%Get(j-1)
				if 'jsonObj.%IsDefined("IRReplaceItmDR"){
					d rows.%Remove(j-1)
					continue
				}
			}
		}
		if ret=0{
			s ret=##super(ClsName, rows)
		}
		Q:ret'=0
	}
	if ret'=0 TRO
	else  TC
	Q ret
}

Query QueryItmMast(Alias = "", ArcimID = "", HospID = "") As %Query(ROWSPEC = "ID,ARCIMRowid,ARCIMDesc,CNMedFlag:%Boolean")
{
}

ClassMethod QueryItmMastExecute(ByRef qHandle As %Binary, Alias = "", ArcimID = "", HospID = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s CNMedCatStr="^"_##class(web.DHCDocOrderCommon).GetCNMedItemCatStr(HospID)_"^"
	if ArcimID'=""{
		s ID=$O(^DHCItmMast("0","ARCIM",ArcimID,0))
		d OutputRow
	}else{
		s ID=0 for{
			s ID=$O(^DHCItmMast(ID)) Q:ID=""
			d OutputRow
		}
	}
	Quit $$$OK
OutputRow
	s ARCIMRowid=$P(^DHCItmMast(ID),"^",1)
	Q:ARCIMRowid=""
	Q:(ArcimID="")&&(Alias'="")&&'##class(web.DHCDocMain).MatchAlias(ARCIMRowid,Alias)
	Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ARCIMRowid,HospID)="N"
	s ARCIMDesc=$P(^ARCIM(+ARCIMRowid,1,1),"^",2)
	s ItemCatRowid=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",10)
	s CNMedFlag=CNMedCatStr[("^"_ItemCatRowid_"^")
	d rows.%Push($LB(ID,ARCIMRowid,ARCIMDesc,CNMedFlag))
	Q
}

ClassMethod QueryItmMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItmMastExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryConflict(ITCParRef) As %Query(ROWSPEC = "ITCParRef,ID,ITCConflictItmDR,ARCIMDesc,ITCConflictType,ITCShortConflictType,ITCLongConflictType")
{
}

ClassMethod QueryConflictExecute(ByRef qHandle As %Binary, ITCParRef) As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s ITCChildsub=0 for{
		s ITCChildsub=$O(^DHCItmMast(ITCParRef,"CF",ITCChildsub)) Q:ITCChildsub=""
		s ITCConflictItmDR=$p(^DHCItmMast(ITCParRef,"CF",ITCChildsub),"^",1)
		s ARCIMDesc=$p($G(^ARCIM(+ITCConflictItmDR,1,1)),"^",2)
		s ITCConflictType=$p(^DHCItmMast(ITCParRef,"CF",ITCChildsub),"^",2)
		s ITCShortConflictType=$p(^DHCItmMast(ITCParRef,"CF",ITCChildsub),"^",3)
		s ITCLongConflictType=$p(^DHCItmMast(ITCParRef,"CF",ITCChildsub),"^",4)
		s ID=ITCParRef_"||"_ITCChildsub
		d rows.%Push($LB(ITCParRef,ID,ITCConflictItmDR,ARCIMDesc,ITCConflictType,ITCShortConflictType,ITCLongConflictType))
	}
	Q $$$OK
}

ClassMethod QueryConflictFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryConflictExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryReplace(IRParRef) As %Query(ROWSPEC = "IRParRef,ID,IRReplaceItmDR,ARCIMDesc,IRReplaceExpress")
{
}

ClassMethod QueryReplaceExecute(ByRef qHandle As %Binary, IRParRef) As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s IRChildsub=0 for{
		s IRChildsub=$O(^DHCItmMast(IRParRef,"CR",IRChildsub)) Q:IRChildsub=""
		s IRReplaceItmDR=$p(^DHCItmMast(IRParRef,"CR",IRChildsub),"^",1)
		s ARCIMDesc=$p($G(^ARCIM(+IRReplaceItmDR,1,1)),"^",2)
		s IRReplaceExpress=$p(^DHCItmMast(IRParRef,"CR",IRChildsub),"^",2)
		s ID=IRParRef_"||"_IRChildsub
		d rows.%Push($LB(IRParRef,ID,IRReplaceItmDR,ARCIMDesc,IRReplaceExpress))
	}
	Q $$$OK
}

ClassMethod QueryReplaceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReplaceExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryItemToExcel(HospID = "", Alias = "") As %Query(ROWSPEC = "ARCIMDesc:%String:项目名称,CNMedFlag:%String:是否草药,ShowOEMessage:%String:是否提示,RequireNote:%String:需要备注,IPNeedBillQty:%String:住院用整数量,CanCrossDay:%String:修改医嘱开始日期时间权限,OrdDateCanCrossDay:%String:修改开医嘱日期时间权限,AllowOnlyOnce:%String:一个患者只允许开一次,AdmAllowOnlyOnce:%String:一次就诊只允许开一次,AutoInsertONEOrd:%String:长期自备或嘱托自动插入取药医嘱,LabOrdDayAllowRepeat:%String:门诊检验医嘱同一天允许重复,NotLimitQty:%String:不控制数量,CountInButNotOutFlag:%String:计入不记出医嘱标识,CountInButNotOutIPLongOrdRollSttTime:%String:无频次长嘱滚动默认开始时间,SameFreqDifferentDosesFlag:%String:同频次不同剂量医嘱,ConflictType:%String:互斥类型,AlertStockQty:%String:最小提示库存,StopAfterLongOrder:%String:按该医嘱开始日期停止长期医嘱,StopDefSttDateDay:%String:默认开始日期天数,StopDefSttTime:%String:默认开始时间,NotAutoStop:%String:不能被自动停止的长期费用医嘱,AllowLongOrder:%String:允许该医嘱开长期,RepeatCheckDays:%String:重复医嘱判断天数")
{
}

ClassMethod QueryItemToExcelExecute(ByRef qHandle As %Binary, HospID = "", Alias = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s rows=[]
	s qHandle=rows.%GetIterator()
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s CNMedCatStr="^"_##class(web.DHCDocOrderCommon).GetCNMedItemCatStr(HospID)_"^"
	s ID=0 for{
		s ID=$O(^DHCItmMast(ID)) Q:ID=""
		s str=^DHCItmMast(ID)
		s ARCIMRowid=$P(str,"^",1)
		continue:ARCIMRowid=""
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ARCIMRowid,HospID)="N"
		continue:(Alias'="")&&'##class(web.DHCDocMain).MatchAlias(ARCIMRowid,Alias)
		s ItemCatRowid=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",10)
		s ARCIMDesc=$P(^ARCIM(+ARCIMRowid,1,1),"^",2)
		s CNMedFlag=$SELECT(CNMedCatStr[("^"_ItemCatRowid_"^"):"是",1:"")
		s ShowOEMessage=$P(str,"^",4)
		s RequireNote=$P(str,"^",5)
		s IPNeedBillQty=$P(str,"^",8)
		s CanCrossDay=$P(str,"^",11)
		s OrdDateCanCrossDay=$P(str,"^",25)
		s AllowOnlyOnce=$P(str,"^",13)
		s AutoInsertONEOrd=$P(str,"^",15)
		s LabOrdDayAllowRepeat=$P(str,"^",26)
		s NotLimitQty=$P(str,"^",30)
		s CountInButNotOutFlag=$P(str,"^",27)
		s CountInButNotOutIPLongOrdRollSttTime=$P(str,"^",28)
		s SameFreqDifferentDosesFlag=$P(str,"^",22)
		s ConflictType=$CASE($P(str,"^",14),"OW":"单向","TW":"双向",:"")
		s AlertStockQty=$P(str,"^",7)
		s StopAfterLongOrder=$P(str,"^",31)
		s StopDefSttDateDay=$P(str,"^",32)
		s StopDefSttTime=$P(str,"^",33)
		s NotAutoStop=$P(str,"^",34)
		s AllowLongOrder=$P(str,"^",35)
		s AdmAllowOnlyOnce=$P(str,"^",36)
		s RepeatCheckDays=$P(str,"^",37)
		d rows.%Push($LB(ARCIMDesc,CNMedFlag,ShowOEMessage,RequireNote,IPNeedBillQty,CanCrossDay,OrdDateCanCrossDay,AllowOnlyOnce,AdmAllowOnlyOnce,AutoInsertONEOrd,LabOrdDayAllowRepeat,NotLimitQty,
			CountInButNotOutFlag,CountInButNotOutIPLongOrdRollSttTime,SameFreqDifferentDosesFlag,ConflictType,AlertStockQty,StopAfterLongOrder,StopDefSttDateDay,
			StopDefSttTime,NotAutoStop,AllowLongOrder,RepeatCheckDays))
	}
	Quit $$$OK
}

ClassMethod QueryItemToExcelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemToExcelExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

/// 获取互斥医嘱项
/// w ##class(DHCDoc.DHCDocConfig.ARCIMExt).GetConflict("11588||1",2)
ClassMethod GetConflict(ArcimRowid As %String, HospId As %String = "", ByRef OutList = "")
{
	k OutList
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	
	d ..GetConflictTypeList("User.DHCItmConflict","ITCLongConflictType",.ConflictTypeList)
	
	s DHCItemRowid=0 f  s DHCItemRowid=$O(^DHCItmMast(0,"ARCIM",ArcimRowid,DHCItemRowid)) Q:DHCItemRowid=""  d
	.s childsub=0  f  s childsub=$O(^DHCItmMast(DHCItemRowid,"CF",childsub)) q:childsub=""  d
	..s ConflictItem=$p($g(^DHCItmMast(DHCItemRowid,"CF",childsub)),"^",1)
	..d OneItem
	;如果传入ID在其他医嘱项目子表中 User.DHCItmConflict (可能一个项目包含在多个子表中)
	s DHCItemRowid=0 f  s DHCItemRowid=$O(^DHCItmMast("0","CFARCIM",ArcimRowid,DHCItemRowid)) Q:DHCItemRowid=""  d
	.s childsub=$O(^DHCItmMast("0","CFARCIM",ArcimRowid,DHCItemRowid,0))
	.s ConflictItem=$P(^DHCItmMast(DHCItemRowid),"^",1)
	.d OneItem
	.Q:##class(web.DHCDocOrderCommon).IsCNMedItem(ConflictItem,HospId)
	.s DARCIMConflictType=$P(^DHCItmMast(DHCItemRowid),"^",14)
	.Q:(DARCIMConflictType="OW") //互斥类型为单向时,不进行子表互斥项目判断
	.s childsub=0  f  s childsub=$O(^DHCItmMast(DHCItemRowid,"CF",childsub)) q:childsub=""  d
	..s ConflictItem=$p($g(^DHCItmMast(DHCItemRowid,"CF",childsub)),"^",1)
	..Q:ConflictItem=ArcimRowid	;本身不判断
	..d OneItem
	s ConflictItemStr=""
	s ConflictItem="" for{
		s ConflictItem=$O(OutList(ConflictItem)) Q:ConflictItem=""
		i ConflictItemStr="" s ConflictItemStr=ConflictItem
		e  s ConflictItemStr=ConflictItemStr_"^"_ConflictItem
	}
	Q ConflictItemStr
OneItem
	Q:(ConflictItem="")	;||(ConflictItem=ArcimRowid)
	Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ConflictItem,HospId)="N"
	s ShortConflictType=$p(^DHCItmMast(DHCItemRowid,"CF",childsub),"^",3)
	s:ShortConflictType="" ShortConflictType="DT"	;临时互斥类型默认为当日提示
	s LongConflictType=$p(^DHCItmMast(DHCItemRowid,"CF",childsub),"^",4)
	s:LongConflictType="" LongConflictType="S"	;长期互斥类型默认为停止
	s ShortLevel=$G(ConflictTypeList(ShortConflictType))
	s LongLevel=$G(ConflictTypeList(LongConflictType))
	;保留高优先级
	if '$D(OutList(ConflictItem)){
		s OutList(ConflictItem)={"Short":{},"Long":{}}
	}
	if ShortLevel>OutList(ConflictItem).Short.Level{
		s OutList(ConflictItem).Short={"Level":(ShortLevel),"Type":(ShortConflictType)}
	}
	if LongLevel>OutList(ConflictItem).Long.Level{
		s OutList(ConflictItem).Long={"Level":(LongLevel),"Type":(LongConflictType)}
	}
	Q
}

/// 获取互斥类型优先级
ClassMethod GetConflictTypeList(ClsName, PropName, ByRef TypeList)
{
	k TypeList
	s Count=0
	s rs=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.Common:QueryPropDisplay")
	d rs.Execute(ClsName,PropName)
	while rs.Next(){
		s Type=rs.GetDataByName("id")
		continue:Type=""
		s TypeList(Type)=$I(Count)
	}
	Q Count
}

/// Creator:WangQingyong
/// Description:检测病人新开医嘱是否有互斥医嘱(按已存在医嘱的类型进行取配置判断)
/// Notice:按最高控制级别进行返回提醒
/// 控制代码释义:"AF":本次就诊禁开、"DF":同一天禁开、"S":停止原医嘱、"AT":本次就诊提示、"DT":同一天提示
/// 增加入参langid  应为医嘱录入的web.DHCOEOrdItemView方法没有%session
/// w ##class(DHCDoc.DHCDocConfig.ARCIMExt).CheckConflict("61","11586||1","","","","2")
ClassMethod CheckConflict(EpisodeID, ArcimRowid, OrderSttDate = "", OrderSttTime = "", PriorRowid = "", HospId = "", langid = "") As %String
{
	;s ^Wqy("CheckConflict")=$LB(EpisodeID, ArcimRowid, OrderSttDate, OrderSttTime, PriorRowid, HospId)
	s Ord=$o(^OEORD(0,"Adm",+EpisodeID,0))
	Q:Ord="" "N"
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	d ..GetConflict(ArcimRowid,HospId,.ConflictItemList)
	Q:'$D(ConflictItemList) "N"
	s OrderSttDate=..%ZDH(OrderSttDate)
	s:OrderSttDate="" OrderSttDate=..%SysDate()
	s OrderSttTime=..%ZTH(OrderSttTime)
	s:OrderSttTime="" OrderSttTime=..%SysTime()
	s LongPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)
	Set:langid="" langid=..%LanguageID()
	;如果开长期医嘱需要循环开始日期后是否存在有效记录,临时医嘱只校验当天
	s OrderEndDate=$CASE(LongPriorFlag,1:"",:OrderSttDate)
	s FindConflictObj={"Level":"","Type":"","OrdItemIDs":[]}
	s ItmMastID="" for{
		s ItmMastID=$O(^OEORDi(0,"ARCIM",Ord,ItmMastID)) Q:ItmMastID=""
		continue:'$D(ConflictItemList(ItmMastID))
		s ConflictItemObj=ConflictItemList(ItmMastID)
		s SttDate="" for{
			s SttDate=$O(^OEORDi(0,"ARCIM",Ord,ItmMastID,SttDate)) Q:SttDate=""
			s Sub=0 for{
				s Sub=$O(^OEORDi(0,"ARCIM",Ord,ItmMastID,SttDate,Sub)) Q:Sub=""
				d OneOrdItem
			}
		}
	}
	Q:FindConflictObj.Level="" "N"
	s ItmMastIDs=FindConflictObj.ItmMastIDs
	s ConflictType=FindConflictObj.Type
	s ArcimDescStr=""
	f i=1:1:$L(ItmMastIDs,","){
		s ItmMastID=$P(ItmMastIDs,",",i)
		continue:ItmMastID=""
		s ArcimDesc=$p($g(^ARCIM(+ItmMastID,1,1)),"^",2)
		s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
		i ArcimDescStr="" s ArcimDescStr=ArcimDesc
		e  s ArcimDescStr=ArcimDescStr_","_ArcimDesc
	}
	s NewArcimDesc=$p($g(^ARCIM(+ArcimRowid,1,1)),"^",2)
	s NewArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",NewArcimDesc,langid)
	s TipMsg=$CASE(ConflictType,
			"AF":..%Translate("oeorder.oplistcustom.new.csp","本次就诊已存在互斥医嘱【",langid)_ArcimDescStr_..%Translate("oeorder.oplistcustom.new.csp","】,禁止开【",langid)_NewArcimDesc_"】",
			"DF":..%ZD(OrderSttDate)_..%Translate("oeorder.oplistcustom.new.csp","已存在互斥医嘱【",langid)_ArcimDescStr_..%Translate("oeorder.oplistcustom.new.csp","】,禁止同一天开【",langid)_NewArcimDesc_"】",
			"S":"【"_NewArcimDesc_..%Translate("oeorder.oplistcustom.new.csp","】将停止互斥长期医嘱【",langid)_ArcimDescStr_"】",
			"AT":..%Translate("oeorder.oplistcustom.new.csp","本次就诊已存在互斥医嘱【",langid)_ArcimDescStr_"】",
			"DT":..%ZD(OrderSttDate)_..%Translate("oeorder.oplistcustom.new.csp","已存在互斥医嘱【",langid)_ArcimDescStr_"】")
	Q "Y^"_TipMsg_"^"_ConflictType_"^"_ArcimDescStr
OneOrdItem
	s OrdItemID=Ord_"||"_Sub
	Q:'##class(DHCDoc.Order.Common).IsValidOrd(OrdItemID)
	s LongOrdFlag=##class(DHCDoc.Order.Common).IsLongOrdItem(OrdItemID)
	s ConflictObj=$CASE(LongOrdFlag,1:ConflictItemObj.Long,:ConflictItemObj.Short)
	;只找更高优先级
	if ConflictObj.Level=FindConflictObj.Level{
		if (","_FindConflictObj.ItmMastIDs_",")'[(","_ItmMastID_","){
			s FindConflictObj.ItmMastIDs=FindConflictObj.ItmMastIDs_","_ItmMastID
		}
	}elseif ConflictObj.Level>FindConflictObj.Level{
		s ConflictType=ConflictObj.Type
		if " DF DT "[(" "_ConflictType_" "){
			if ##class(DHCDoc.Order.Common).ExistValidExec(OrdItemID,OrderSttDate,OrderEndDate){
				d SetFindObj
			}
		}elseif " S "[(" "_ConflictType_" "){
			s OrdStatusCode=##class(DHCDoc.Order.Common).GetOrdStatusCode(OrdItemID)
			if OrdStatusCode="D"{
				s XDate=$p($g(^OEORD(Ord,"I",Sub,3)),"^",34)
				s XTime=$p($g(^OEORD(Ord,"I",Sub,2)),"^",15)
				if (OrderSttDate<XDate)||((OrderSttDate=XDate)&&(OrderSttTime<XTime)){
					d SetFindObj
				}
			}else{
				d SetFindObj
			}
		}else{
			d SetFindObj
		}
	}
	Q
SetFindObj
	s FindConflictObj={"Level":(ConflictObj.Level),"Type":(ConflictType),"ItmMastIDs":(ItmMastID)}
	Q
}

ClassMethod DeleteData(ClsName, ID)
{
 	s IPPartial=$p($g(^DHCItmMast(ID)),"^",9)	;住院单次剂量偏好
 	s OPPartial=$p($g(^DHCItmMast(ID)),"^",38)	;门诊单次剂量偏好
	Q:(IPPartial'="")||(OPPartial'="") "药品已维护单次剂量偏好,不能删除"
	Q ##super(ClsName, ID)
}

}
