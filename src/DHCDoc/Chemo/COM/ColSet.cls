/// CTOR: QP
/// DATE: 2020-06-12
/// DESC: 化疗医嘱表格列设置
Class DHCDoc.Chemo.COM.ColSet Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-05-06
/// DESC: 获取医嘱录入列设置,需要返回的数组指针
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.ColSet).GetListColSet(.ConfigAry)
ClassMethod GetListColSet(ByRef ConfigAry As %String)
{
	n (ConfigAry,%session)
	s Count=0
	s DOGRowId=""
	s child=""
	s DOPRowID=$o(^DHCDocOGi("Code","Chemo.OrderList",0))
	i DOPRowID'="" s child=$o(^DHCDocOGi("Code","Chemo.OrderList",DOPRowID,0))
	i child'="" s DOGRowId=DOPRowID_"||"_child
	Set rset=##Class(%ResultSet).%New("DHCDoc.Chemo.COM.ColSet:GetOrderListSet")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(DOGRowId)
		If 'Status Quit
		While (rset.Next()) {
			s rowid=rset.GetDataByName("rowid")
		    s code=rset.GetDataByName("code")
		    s desc=rset.GetDataByName("desc")
		    s expression=rset.GetDataByName("expression")
		    s colwidth=rset.GetDataByName("colwidth")
		    s hidden=rset.GetDataByName("hidden")
		    s sort=0
		    s Count=Count+1
		    s ConfigAry(Count)=code_"^"_desc_"^"_Count_"^"_colwidth_"^"_hidden_"^"_sort_"^"_expression
		    ;w ConfigAry(Count),!
		}
		d rset.Close()
	}
	b ;001
	q
}

/// CTOR: QP
/// DATE: 2020-05-06
/// DESC: 查询表格设置
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.THPY.CFG.ColSet","GetOrderListSet","62||1")
Query GetOrderListSet(DOGRowId) As %Library.Query(CONTAINID = 0, ROWSPEC = "rowid:%String,code:%String,desc:%String,expression:%String,colwidth:%String,hidden:%String") [ SqlProc ]
{
}

ClassMethod GetOrderListSetExecute(ByRef qHandle As %Binary, DOGRowId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s desc="",rowid="",mrdesc=""
	i DOGRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s OPRowId=$p(DOGRowId,"||",1)
	s child=$p(DOGRowId,"||",2)
	k ^TEMP("GetOrderListSet",$j)
	s Rowid=0
 	f  s Rowid=$o(^DHCDocOLS(OPRowId,child,Rowid)) q:Rowid=""  d
 	.s Code=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",1)
 	.s Desc=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",2)
 	.s Desc=##class(websys.Translation).Get("chemo.bs.apply.csp",Desc)
 	.s expression=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",3)
 	.s colwidth=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",4)
 	.s hidden=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",5)
 	.s seqno=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",6)
 	.i seqno="" s seqno="999"
 	.s outData=$lb(OPRowId_"||"_child_"||"_Rowid,Code,Desc,expression,colwidth,hidden)
 	.s ^TEMP("GetOrderListSet",$j,seqno,Rowid)=outData
 	
 	s seqno=""
 	f  s seqno=$o(^TEMP("GetOrderListSet",$j,seqno)) q:seqno=""  d
 	.s Rowid=""
 	.f  s Rowid=$o(^TEMP("GetOrderListSet",$j,seqno,Rowid)) q:Rowid=""  d
 	..s outData=^TEMP("GetOrderListSet",$j,seqno,Rowid)
 	..d OutputRow
 	
 	k ^TEMP("GetOrderListSet",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=outData	//$lb(OPRowId_"||"_child_"||"_Rowid,Code,Desc,expression,colwidth,hidden)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetOrderListSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderListSetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOrderListSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderListSetExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-05-06
/// DESC: 根据列头设置得到医嘱录入的表格配置对象
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.THPY.CFG.ColSet).ReadListColSet()
ClassMethod ReadListColSet(classname As %String, classmethod As %String, ByRef colNames As %String, ByRef colModelAry As %String, ByRef ParamAry As %String) As %String
{
	q:(classname="")||(classmethod="") ""
	n (%session,classname,classmethod,colNames,colModelAry,ParamAry)
	s SessionStr=""
	
	i %session,$d(%session.Data) {
		s SessionStr=%session.Get("LOGON.SITECODE")_"^"_%session.Get("LOGON.USERID")
		s SessionStr=SessionStr_"^"_%session.Get("LOGON.GROUPID")_"^"_%session.Get("LOGON.CTLOCID")
		s SessionStr=SessionStr_"^"_%session.Get("CONTEXT")_"^"_%session.Get("LOGON.WARDID")
		s SessionStr=SessionStr_"^"_%session.Get("LOGON.HOSPID")_"^"_%session.Get("LOGON.LANGID")
	}
	
	k ConfigAry
	d ##class(DHCDoc.Chemo.COM.ColSet).GetListColSet(.ConfigAry)
	k SortQueue			
	k SortConfigAry
	s uSet=""
	s Loop=0
	for {
		s Loop=$O(ConfigAry(Loop)) Q:Loop=""
		i $g(hiddenPlist(Loop))="" {
			//2014-04-15
			s SortConfigAry(999,Loop)=$g(ConfigAry(Loop))
		}else{
			s SortNum=$o(SortQueue(Loop,0))
			s SortConfigAry(+SortNum,Loop)=$g(ConfigAry(Loop))
		} 
	}
	
	s SortNum=""
	for {
		s SortNum=$O(SortConfigAry(SortNum)) Q:SortNum=""
		
		s Loop=0
		for {
			s Loop=$O(SortConfigAry(SortNum,Loop)) Q:Loop=""
			s OneItem=$g(ConfigAry(Loop))
			s name=$p(OneItem,"^",1)
			s cap=$p(OneItem,"^",2)
			s col=$p(OneItem,"^",3)
			s wid=$p(OneItem,"^",4)
			s isHidden=$p(OneItem,"^",5)
			i (isHidden="Y")||(cap="") s cap=name
			s sort=$p(OneItem,"^",6)
			s expression=$p(OneItem,"^",7)
			i '$d(colNames) {
				s colNames=cap
			}else{
				s colNames=colNames_","_cap
			}
			i (uSet'=""),$g(hiddenPlist(Loop))="" s isHidden="Y"
		
			;转换
			i isHidden="Y" s isHidden="true"
			e  s isHidden="false"
			;多语言转换
			//s CurLangID=$p(SessionStr,"^",8)
			//i CurLangID'="",$p($g(^SS("LAN",CurLangID)),"^",2)'="Chinese" {
			//	s cap=##class(web.DHCDocUtil).GetTranslatedStr(CurLangID,cap)
			//}
		
			k ColCFAry
			s ColCFAry("name")=name
			s ColCFAry("cap")=cap
			s ColCFAry("col")=col
			s ColCFAry("wid")=wid
			s ColCFAry("isHidden")=isHidden
			s ColCFAry("sort")=sort
			s ClassName=$p(expression,".",1,$l(expression,".")-1)
			s MethodName=$p(expression,".",$l(expression,"."))
			s colModelAry(cap)="{}"
			s ExpStr=""
			i $d(ParamAry(name)) s ExpStr=$g(ParamAry(name))
			i ClassName'="" {
				
				;判断方法是否存在
				s CLSObj=##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
				if $IsObject(CLSObj) {
					if $d(^oddDEF(CLSObj.%Id(),"m",MethodName)) {
						s colModelAry(cap)=$CLASSMETHOD(ClassName,MethodName,SessionStr,.ColCFAry,ExpStr)
					}
				}
			}
		}
	}

	q
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.COM.ColSet).CreateColSet("1||1","61||1")
ClassMethod CreateColSet(CopyGrid, NewGrid) As %String
{
	n (CopyGrid,NewGrid)
	Q:CopyGrid="" ""
	s Page=$p(CopyGrid,"||",1),Grid=$p(CopyGrid,"||",2)
	s id=0
	s j=0
	for{
		s id=$O(^DHCDocOLS(Page,Grid,id))
		q:id=""
		s code=$p(^DHCDocOLS(Page,Grid,id),"^",1)
		s desc=$p(^DHCDocOLS(Page,Grid,id),"^",2)
		s expression=$p(^DHCDocOLS(Page,Grid,id),"^",3)
		s width=$p(^DHCDocOLS(Page,Grid,id),"^",4)
		s hidden=$p(^DHCDocOLS(Page,Grid,id),"^",5)
		s j=j+1
		//OLS_ChildSub
		&SQL(INSERT INTO SQLUser.DHC_DocOrderListSet (OLS_DOG_ParRef, OLS_Code, OLS_Desc, OLS_Expression, OLS_ColWidth, OLS_Hidden)
			VALUES(:NewGrid,:code,:desc,:expression,:width,:hidden)
		)
		Q:SQLCODE'=0
	}
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-05-20
/// DESC: 删除多余不需要的列
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.COM.ColSet).DeleteColSet("61||1")
ClassMethod DeleteColSet(NewGrid) As %String
{
	n (NewGrid)	
	//Need Delete ColList
	s KList = "LinkedMasterOrderSeqNo,OrderAntibApplyRowid,UserReasonId,Urgent,OrderPilotPro,OrderPilotProRowid,OrderInsurCatHideen"
	s KList = KList_",OrderSelfOMFlag,OrderOutsourcingFlag,SpecialAction"
	s KList = KList_",OrderBindSource,OrdCateGory,OrdCateGoryRowId,OrderOperation,OrderOperationCode,OrderPoisonRowid"
	s KList = KList_",OrderMKMsg,OrderMonitorId,OrderNurseLinkOrderRowid,OrderBodyPartLabel,OrderCPWStepItemRowId,OrderItemCongeries"
	s KList = KList_",OrderOperationStr,OrderFreqTimeDoseStr,AnaesthesiaID,OrderPkgOrderNo,OrderHolidayRecLocStr,idoseqtystr,OrderVirtualtLong,OrderChronicDiag,OrderChronicDiagCode,OrderChronicDiagStr,StyleConfigStr,OrderPrice,OrderSum,OrderPrescNo,OrderFirstDayTimes,OrderLabSpecRowid,OrderLabSpec,OrderLabEpisodeNo,OrderAutoCalculate,OrderCoverMainIns,OrderInsurCatRowId,OrderInsurCat,OrderActionRowid,OrderDIACatRowId,OrderDIACat,OrderBodyPart,OrderOutPriorRecLocStr,OrderOnePriorRecLocStr,OrderPHForm,OrderConFac,OrderPHPrescType,OrderNeedPIVAFlag,OrderMaterialBarcode,AntUseReason,OrderMaxDurFactor,OrderMaxQty,OrderBaseQtySum,OrderFile1,OrderFile2,OrderFile3,OrderLabExCode,OrderAlertStockQty,OrderPoisonCode,OrderGenericName,OrderLabSpecStr,idiagnoscatstr,RowDisableStr,OrderPriorRemarksRowId,OrderPriorStr,OrderType,OrderMaterialBarcodeHiden,ExceedReasonID,ExceedReason,OrderBodyPartID,OrderLocalInfusionQty,OrderUsableDays,OrderStageCode,AntUseReasonRowid,LinkedMasterOrderRowid,ShowTabStr"
	for i=1:1:$l(KList,",") {
		s code = $p(KList,",",i)
		&SQL(
			DELETE FROM SQLUser.DHC_DocOrderListSet
			WHERE OLS_DOG_ParRef =:NewGrid 
			AND OLS_Code = :code
		)	
	}
	
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-05-20
/// DESC: 新增加的列
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.COM.ColSet).AddColSet("61||1")
ClassMethod AddColSet(NewGrid) As %String
{
	n (NewGrid)	
	s mRtn=0
	s PID=+NewGrid,GID=$P(NewGrid,"||",2)
	K ^TEMP("AddColSet")
	s SID=0
	f  s SID=$O(^DHCDocOLS(PID,GID,SID)) Q:SID=""  D
	.s code=$p(^DHCDocOLS(PID,GID,SID),"^",1)
	.s desc=$p(^DHCDocOLS(PID,GID,SID),"^",2)
	.s express=$p(^DHCDocOLS(PID,GID,SID),"^",3)
	.s width=$p(^DHCDocOLS(PID,GID,SID),"^",4)
	.s hidden=$p(^DHCDocOLS(PID,GID,SID),"^",5)
	.s seqno=$p(^DHCDocOLS(PID,GID,SID),"^",6)
	.s cList=$lb(code,desc,width,hidden,express,seqno)
	.s ^TEMP("AddColSet",SID)=cList
	K ^TEMP("AddColSet")
	
	
	s MDATA(1)	=	$lb("id","序号","30","N","DHCDoc.Chemo.COM.ColConfig.Id","1")
	s MDATA(2)	=	$lb("OrderItemRowid","OrderItemRowid","60","Y","web.DHCDocOrderListConfig.OrderItemRowid","")
	s MDATA(3)	=	$lb("OrderARCIMRowid","OrderARCIMRowid","60","Y","web.DHCDocOrderListConfig.OrderARCIMRowid","")
	s MDATA(4)	=	$lb("OrderPriorRowid","OrderPriorRowid","60","Y","web.DHCDocOrderListConfig.OrderPriorRowid","")
	s MDATA(5)	=	$lb("OrderPrior","医嘱类型","78","","web.DHCDocOrderListConfig.OrderPrior","2")
	s MDATA(6)	=	$lb("OrderMasterSeqNo","关联","30","","web.DHCDocOrderListConfig.OrderMasterSeqNo","3")
	s MDATA(7)	=	$lb("OrderName","医嘱名称","240","","web.DHCDocOrderListConfig.OrderName","5")
	s MDATA(8)	=	$lb("OrderDoseQty","单次剂量","60","","web.DHCDocOrderListConfig.OrderDoseQty","9")
	s MDATA(9)	=	$lb("OrderDoseUOMRowid","OrderDoseUOMRowid","45","Y","web.DHCDocOrderListConfig.OrderDoseUOMRowid","")
	s MDATA(10)	=	$lb("OrderDoseUOM","剂量单位","60","","web.DHCDocOrderListConfig.OrderDoseUOM","10")
	s MDATA(11)	=	$lb("OrderFreqRowid","OrderFreqRowid","60","Y","web.DHCDocOrderListConfig.OrderFreqRowid","")
	s MDATA(12)	=	$lb("OrderFreq","频次","95","","web.DHCDocOrderListConfig.OrderFreq","12")
	s MDATA(13)	=	$lb("OrderFreqFactor","OrderFreqFactor","60","Y","web.DHCDocOrderListConfig.OrderFreqFactor","")
	s MDATA(14)	=	$lb("OrderFreqInterval","OrderFreqInterval","60","Y","web.DHCDocOrderListConfig.OrderFreqInterval","")
	s MDATA(15)	=	$lb("OrderFreqDispTimeStr","OrderFreqDispTimeStr","60","Y","web.DHCDocOrderListConfig.OrderFreqDispTimeStr","")
	s MDATA(16)	=	$lb("OrderInstrRowid","OrderInstrRowid","60","Y","web.DHCDocOrderListConfig.OrderInstrRowid","")
	s MDATA(17)	=	$lb("OrderInstr","用法","95","","web.DHCDocOrderListConfig.OrderInstr","11")
	s MDATA(18)	=	$lb("OrderDurRowid","OrderDurRowid","60","Y","web.DHCDocOrderListConfig.OrderDurRowid","")
	s MDATA(19)	=	$lb("OrderDur","疗程","80","","web.DHCDocOrderListConfig.OrderDur","14")
	s MDATA(20)	=	$lb("OrderDurFactor","OrderDurFactor","60","Y","web.DHCDocOrderListConfig.OrderDurFactor","")
	s MDATA(21)	=	$lb("OrderPackQty","数量","40","","web.DHCDocOrderListConfig.OrderPackQty","15")
	s MDATA(22)	=	$lb("OrderPackUOMRowid","OrderPackUOMRowid","45","Y","web.DHCDocOrderListConfig.OrderPackUOMRowid","")
	s MDATA(23)	=	$lb("OrderPackUOM","数量单位","60","","web.DHCDocOrderListConfig.OrderPackUOM","16")
	s MDATA(24)	=	$lb("OrderPackUOMStr","OrderPackUOMStr","45","Y","web.DHCDocOrderListConfig.OrderPackUOMStr","")
	s MDATA(25)	=	$lb("OrderSkinTest","皮试","40","Y","web.DHCDocOrderListConfig.OrderSkinTest","18")
	s MDATA(26)	=	$lb("OrderPriorRemarks","附加说明","80","Y","web.DHCDocOrderListConfig.OrderPriorRemarks","17")
	s MDATA(27)	=	$lb("OrderRecDepRowid","OrderRecDepRowid","60","Y","web.DHCDocOrderListConfig.OrderRecDepRowid","")
	//s MDATA(28)	=	$lb("OrderRecDep","接收科室","80","","web.DHCDocOrderListConfig.OrderRecDep","")
	s MDATA(28)	=	$lb("OrderRecDep","接收科室","80","","DHCDoc.Chemo.COM.ColConfig.OrderRecDep","")
	s MDATA(29)	=	$lb("CurrentRecLocStr","CurrentRecLocStr","60","Y","web.DHCDocOrderListConfig.CurrentRecLocStr","")
	s MDATA(30)	=	$lb("OrderDepProcNote","备注","100","","web.DHCDocOrderListConfig.OrderDepProcNote","13")
	s MDATA(31)	=	$lb("OrderDoc","开医嘱人","80","Y","web.DHCDocOrderListConfig.OrderDoc","")
	s MDATA(32)	=	$lb("OrderUserAdd","录入人","80","Y","web.DHCDocOrderListConfig.OrderUserAdd","")
	s MDATA(33)	=	$lb("OrderUserDep","就诊科室","100","Y","web.DHCDocOrderListConfig.OrderUserDep","")
	s MDATA(34)	=	$lb("OrderBillType","费别","70","Y","web.DHCDocOrderListConfig.OrderBillType","")
	s MDATA(35)	=	$lb("OrderBillTypeRowid","OrderBillTypeRowid","60","Y","web.DHCDocOrderListConfig.OrderBillTypeRowid","")
	s MDATA(36)	=	$lb("OrderStartDate","开始日期","120","Y","web.DHCDocOrderListConfig.OrderStartDate","")
	s MDATA(37)	=	$lb("OrderAction","皮试备注","60","Y","web.DHCDocOrderListConfig.OrderAction","19")
	s MDATA(38)	=	$lb("OrderEndDate","停止日期","120","Y","web.DHCDocOrderListConfig.OrderEndDate","")
	s MDATA(39)	=	$lb("OrderStage","医嘱阶段","60","Y","web.DHCDocOrderListConfig.OrderStage","")
	s MDATA(40)	=	$lb("OrderSpeedFlowRate","输液流速","60","Y","web.DHCDocOrderListConfig.OrderSpeedFlowRate","20")
	s MDATA(41)	=	$lb("OrderFlowRateUnit","流速单位","60","Y","web.DHCDocOrderListConfig.OrderFlowRateUnit","21")
	s MDATA(42)	=	$lb("OrderFlowRateUnitRowId","OrderFlowRateUnitRowId","60","Y","web.DHCDocOrderListConfig.OrderFlowRateUnitRowId","")
	s MDATA(43)	=	$lb("OrderDate","开医嘱日期","120","Y","web.DHCDocOrderListConfig.OrderDate","")
	s MDATA(44)	=	$lb("OrderRecLocStr","OrderRecLocStr","50","Y","web.DHCDocOrderListConfig.OrderRecLocStr","")
	s MDATA(45)	=	$lb("OrderDrugFormRowid","OrderDrugFormRowid","50","Y","web.DHCDocOrderListConfig.OrderDrugFormRowid","")
	s MDATA(46)	=	$lb("OrderBaseQty","OrderBaseQty","50","Y","web.DHCDocOrderListConfig.OrderBaseQty","")
	s MDATA(47)	=	$lb("OrderARCOSRowid","OrderARCOSRowid","50","Y","web.DHCDocOrderListConfig.OrderARCOSRowid","")
	s MDATA(48)	=	$lb("OrderHiddenPara","OrderHiddenPara","50","Y","web.DHCDocOrderListConfig.OrderHiddenPara","")
	s MDATA(49)	=	$lb("OrderLogDep","开医嘱科室","100","Y","web.DHCDocOrderListConfig.OrderLogDep","")
	s MDATA(50)	=	$lb("OrderDocRowid","OrderDocRowid","10","Y","web.DHCDocOrderListConfig.OrderDocRowid","")
	s MDATA(51)	=	$lb("OrderDocStr","OrderDocStr","10","Y","web.DHCDocOrderListConfig.OrderDocStr","")
	s MDATA(52)	=	$lb("TplGroupItemId","TplGroupItemId","100","N","DHCDoc.Chemo.COM.ColConfig.TplGroupItemId","")
	s MDATA(53)	=	$lb("PGIId","PGIId","100","Y","DHCDoc.Chemo.COM.ColConfig.PGIId","")
	s MDATA(54)	=	$lb("BSAUnit","AUC/单位体表面积浓度","100","N","DHCDoc.Chemo.COM.ColConfig.BSAUnit","8")
	s MDATA(55)	=	$lb("Formula","计算公式","100","N","DHCDoc.Chemo.COM.ColConfig.Formula","7")
	s MDATA(56)	=	$lb("HospDose","外院剂量","100","N","DHCDoc.Chemo.COM.ColConfig.HospDose","")
	s MDATA(57)	=	$lb("HDID","外院记录ID","100","N","DHCDoc.Chemo.COM.ColConfig.HDID","")
	s MDATA(58)	=	$lb("ManuFactor","厂家","100","Y","DHCDoc.Chemo.COM.ColConfig.ManuFactor","")
	s MDATA(59)	=	$lb("BSAUnitSTD","标准值","60","N","DHCDoc.Chemo.COM.ColConfig.BSAUnitSTD","")
	s MDATA(60)	=	$lb("LinkSymbol","组","30","N","DHCDoc.Chemo.COM.ColConfig.LinkSymbol","4")
	s MDATA(61)	=	$lb("GroupType","化疗组类型","150","N","DHCDoc.Chemo.COM.ColConfig.GroupType","2")
	s MDATA(62)	=	$lb("GroupTypeId","组类型ID","100","N","DHCDoc.Chemo.COM.ColConfig.GroupTypeId","")
	s MDATA(63)	=	$lb("MainDrug","是否主药","100","N","DHCDoc.Chemo.COM.ColConfig.MainDrug","")
	s MDATA(64)	=	$lb("ChemoDays","日期","100","N","DHCDoc.Chemo.COM.ColConfig.ChemoDays","6")

	
	/*
	s MDATA(1)=$lb("TplGroupItemId","TplGroupItemId",100,"Y","DHCDoc.Chemo.COM.ColConfig.TplGroupItemId")
	s MDATA(2)=$lb("PGIId","PGIId",100,"N","DHCDoc.Chemo.COM.ColConfig.PGIId")
	s MDATA(3)=$lb("BSAUnit","AUC/单位体表面积浓度/WGT",100,"N","DHCDoc.Chemo.COM.ColConfig.BSAUnit")
	s MDATA(4)=$lb("Formula","计算公式",50,"N","DHCDoc.Chemo.COM.ColConfig.Formula")
	s MDATA(5)=$lb("HospDose","外院剂量",100,"N","DHCDoc.Chemo.COM.ColConfig.HospDose")
	s MDATA(6)=$lb("HDID","外院记录ID",100,"N","DHCDoc.Chemo.COM.ColConfig.HDID")
	s MDATA(7)=$lb("ManuFactor","厂家",100,"Y","DHCDoc.Chemo.COM.ColConfig.ManuFactor")
	s MDATA(8)=$lb("BSAUnitSTD","标准值",60,"N","DHCDoc.Chemo.COM.ColConfig.BSAUnitSTD")
	s MDATA(9)=$lb("LinkSymbol","组",30,"N","DHCDoc.Chemo.COM.ColConfig.LinkSymbol")
	s MDATA(10)=$lb("GroupType","化疗组类型",150,"N","DHCDoc.Chemo.COM.ColConfig.GroupType")
	s MDATA(11)=$lb("GroupTypeId","组类型ID",100,"Y","DHCDoc.Chemo.COM.ColConfig.GroupTypeId")
	s MDATA(12)=$lb("MainDrug","是否主药",100,"N","DHCDoc.Chemo.COM.ColConfig.MainDrug")
	s MDATA(13)=$lb("ChemoDays","日期",100,"N","DHCDoc.Chemo.COM.ColConfig.ChemoDays")
	s MDATA(14)=$lb("OeoriDR","OeoriDR",100,"N","DHCDoc.Chemo.COM.ColConfig.OeoriDR")
	s MDATA(15)=$lb("InitDosage","初始剂量",100,"N","DHCDoc.Chemo.COM.ColConfig.InitDosage")
	s MDATA(16)=$lb("OrderDoseQtyNurese","单次剂量.",100,"Y","DHCDoc.Chemo.COM.ColConfig.OrderDoseQtyNurese")
	*/
	
	f i=1:1:64 {
		s code=$lg(MDATA(i),1)
		s desc=$lg(MDATA(i),2)
		s width=$lg(MDATA(i),3)
		s hidden=$lg(MDATA(i),4)
		s express=$lg(MDATA(i),5)
		s seq=$lg(MDATA(i),6)
		&SQL(
			INSERT INTO SQLUser.DHC_DocOrderListSet (OLS_DOG_ParRef, OLS_Code, OLS_Desc, OLS_Expression, OLS_ColWidth, OLS_Hidden, OLS_Seqno)
			VALUES (:NewGrid, :code, :desc, :express,:width,:hidden,:seq)
		)
		i SQLCODE'=0 {
			s mRtn=SQLCODE
			Q	
		}
		
	
	}
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 
/// IN  : 
/// OUT : 0 成功
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.COM.ColSet).CreateChemoGridData()
ClassMethod CreateChemoGridData() As %String
{
	TS
	;产生化疗单页面
	&SQL(
		INSERT INTO SQLUser.DHC_DocOrderPage (DOP_Code, DOP_Desc)
		VALUES ('chemo.bs.apply.csp', '化疗申请单')
	)
	i SQLCODE'=0 {
		TRO 
		Q SQLCODE	
	}
	s PageID=%ROWID
	
	;产生化疗单表格
	&SQL(
		INSERT INTO SQLUser.DHC_DocOrderGrid (DOG_DOP_ParRef, DOG_ChildSub, DOG_Code, DOG_Desc, DOG_Type)
		VALUES (:PageID, 1, 'Chemo.OrderList', '化疗医嘱表格', 'jqgrid')
	)
	i SQLCODE'=0 {
		TRO 
		Q SQLCODE	
	}
	
	s GID=%ROWID
	
	;产生化疗单表格数据列
	s mRtn=..AddColSet(GID)
	i mRtn'=0 {
		TRO
		Q mRtn	
	}
	
	TC
	Q 0
}

}
