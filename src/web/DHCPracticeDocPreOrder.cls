Class web.DHCPracticeDocPreOrder Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 实习生插入未审核的医嘱
/// (Adm ,医嘱列的Json串, 实习生User)
/// Creator:qujian
/// CreateTime:20190523
/// w ##class(web.DHCPracticeDocPreOrder).InsertPracticeOrder(112,tt,12451,"R")
ClassMethod InsertPracticeOrder(Adm As %String, JsonStr As %String, PreUserID As %String, InsertType As %String = "R")
{
	s ^Tempqujian("InsertPracticeOrder")=Adm_","_JsonStr_","_PreUserID_","_InsertType
	q:Adm="" ""
	if $ISObject(JsonStr) s JsonStr=JsonStr.ReadSQL()
	Set OrdItemCount=$L(JsonStr,$c(1))
	set NowDate=..%SysDate()
	set NowTime=..%SysTime()
	set Type="N"
	set rtn=0
	if (InsertType="C"){
		&SQL(insert into SQLUser.DHC_PracticeDocPreOrder  
			(PracticeAdmDR,PracticeJson,PracticeJsonType,PracticePreUser,
			PracticePreDate,PracticePreTime,PracticeInsertType
			) Values(:Adm,:JsonStr,:Type,:PreUserID,:NowDate,:NowTime,:InsertType))
		s rtn=SQLCODE
	}else{
		if (InsertType="R") {
			k NewRowDataList
			For i=1:1:OrdItemCount{
				Set OrdItem=$p(JsonStr,$c(1),i)
				k RowDataArr
				d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(OrdItem,.RowDataArr)
				s OrderMasterSeqNo=$G(RowDataArr("OrderMasterSeqNo"))
				s id=$G(RowDataArr("id"))
				if (OrderMasterSeqNo'="") {
					s NewRowDataList(OrderMasterSeqNo,id)=OrdItem
				}else{
					s NewRowDataList(id)=OrdItem
				}
			}
			s NewJsonStr=""
			s Counter=0
			for {
				s Counter=$o(NewRowDataList(Counter)) Q:Counter=""
				i NewJsonStr="" s NewJsonStr=$g(NewRowDataList(Counter))
				else  s NewJsonStr=NewJsonStr_$C(1)_$g(NewRowDataList(Counter))
				s SubCounter=0
				for {
					s SubCounter=$o(NewRowDataList(Counter,SubCounter)) Q:SubCounter=""
					i NewJsonStr="" s NewJsonStr=$g(NewRowDataList(Counter,SubCounter))
					else  s NewJsonStr=NewJsonStr_$C(1)_$g(NewRowDataList(Counter,SubCounter))
				}
			}
			s JsonStr=NewJsonStr
		}
		For i=1:1:OrdItemCount{
			Set OrdItem=$p(JsonStr,$c(1),i)
			&SQL(insert into SQLUser.DHC_PracticeDocPreOrder  
			(PracticeAdmDR,PracticeJson,PracticeJsonType,PracticePreUser,
			PracticePreDate,PracticePreTime,PracticeInsertType
			) Values(:Adm,:OrdItem,:Type,:PreUserID,:NowDate,:NowTime,:InsertType))
			s rtn=SQLCODE
			if rtn'=0 q
		}
	}
	q rtn
}

/// 得到Json串
/// DHC_PracticeDocPreOrder表id
/// Creator:qujian
/// CreateTime:20190523
/// w ##class(web.DHCPracticeDocPreOrder).GetOnePracticeOrder(99,2)
ClassMethod GetOnePracticeOrder(Rowid, langid As %String = "")
{
	q:Rowid="" ""
	s:langid="" langid=..%LanguageID()
	s JsonStr=$P($g(^DHCPracticeDocPre(Rowid)),"^",2)
	s InsertPageType=$P($g(^DHCPracticeDocPre(Rowid)),"^",11)
	if (InsertPageType["Cure")&&(JsonStr'=""){
		s JsonStr=..FormatCureData(JsonStr,langid)
	}
	q JsonStr
}

/// 修改实习医嘱表医嘱状态 实习生审核为"N",医生录入到医嘱录入界面为"I" 审核后 为"A" 取消为"X"
/// DHC_PracticeDocPreOrder表id
/// Creator:qujian
/// CreateTime:20190523
ClassMethod ChangePreOrdType(Rowid As %String, Type As %String, UserID As %String, oeori As %String = "")
{

	q:Rowid="" ""
	set NowDate=..%SysDate()
	set NowTime=..%SysTime()
	if (Type="A"){
		&SQL(Update SQLUser.DHC_PracticeDocPreOrder set PracticeJsonType=:Type,PracticeConDoc=:UserID, 
		PracticeConDate=:NowDate,PracticeConTime=:NowDate,PracticeOrdItemDR=:oeori
		where RowID=:Rowid)
	}else{
	&SQL(Update SQLUser.DHC_PracticeDocPreOrder set PracticeJsonType=:Type,PracticeConDoc=:UserID, 
		PracticeConDate=:NowDate,PracticeConTime=:NowDate
		where RowID=:Rowid)
	}
	s rtn=SQLCODE	
	q rtn
}

/// 批量修改实习医嘱表医嘱状态
ClassMethod ChangeMuiPreOrdType(RowidStr As %String, Type As %String, UserID As %String)
{
	s ^tempqujian("ChangeMuiPreOrdType")=RowidStr_","_Type_","_UserID
	q:RowidStr="" ""
	for i=1:1:$L(RowidStr,"^"){
		s Rowid=$P(RowidStr,"^",i)
		s rtn=..ChangePreOrdType(Rowid,Type,UserID)
		if rtn'=0 q
	}
	q rtn
}

/// 获得有几条实习医嘱未审核
/// w ##class(web.DHCPracticeDocPreOrder).GetPracticeOrdNum(629,"N")
ClassMethod GetPracticeOrdNum(Adm As %String, Type As %String, PageType As %String = "R", AssScoreID As %String = "")
{
	q:Adm="" 0
	s Number=0
	Set rs=##Class(%ResultSet).%New("web.DHCPracticeDocPreOrder:FindPracticeOrder")
	If rs.QueryIsValid() { 
		Set Status=rs.Execute(Adm,Type,PageType,AssScoreID)
		If 'Status Quit 0
		 While rs.Next() {
			 s Number=Number+1
		 }
	}
	q Number
}

/// 审核实习医嘱条数 websys.DHCChartStyle.GetVerifyStyle
/// w ##class(web.DHCPracticeDocPreOrder).GetVerifyStyleNum(629)
ClassMethod GetVerifyStyleNum(EpisodeID = "")
{
	Set count = 0
	s rs = ##class(%ResultSet).%New("web.DHCOEOrdItem:FindUnActiveOrderItems")
	s sc = rs.Execute(EpisodeID)
	While (rs.Next()){
		set count = count+1
	}
	do rs.Close()
	q count
}

/// 查询 对应类型的医嘱
/// 
Query FindPracticeOrder(Adm As %String, Type As %String, PageType As %String = "R^Cure", AssScoreID As %String = "") As %Query(ROWSPEC = "Rowid:%String,OrderName:%String,OrderDoseQty:%String,OrderDoseUOM:%String,OrderInstr:%String,OrderFreq:%String,OrderDur:%String,OrderPackQty:%String,OrderPackUOM:%String,OrderPrior:%String,OrderUserAdd:%String,OrderStartDate:%String,OrdSeqNo:%String,OrderDate:%String,OrderRecLoc:%String,OrderInsertType:%String")
{
}

ClassMethod FindPracticeOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPracticeOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPracticeOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPracticeOrderExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPracticeOrderExecute(ByRef qHandle As %Binary, Adm As %String, Type As %String, PageType As %String = "R", AssScoreID As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPracticeDocPreOrder","FindPracticeOrder","272","N","R")
	s ^tempqujian("FindPracticeOrder")= Adm_","_Type_","_PageType
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s langid=..%LanguageID()
	s PageType="^"_PageType_"^"
	s SeqNo=1,LastMainOrdSeqNo=""
	s Rowid=""
	for {
		s Rowid=$O(^DHCPracticeDocPrei("TypeAdm",Type,Adm,Rowid))
		q:Rowid=""
		s JsonStr=$P(^DHCPracticeDocPre(Rowid),"^",2)
		continue:JsonStr=""
		s InsertPageType=$P(^DHCPracticeDocPre(Rowid),"^",11)
		s OrderInsertType=""
		if (PageType["^C^")&&(InsertPageType="C"){
			Set OrdItemCount=$L(JsonStr,$c(4))
			set OrderName=""
			For i=18:1:OrdItemCount{
				Set OrdItem=$p(JsonStr,$c(4),i)
				set Name=$P(OrdItem,",",2)
				set qty=$P(OrdItem,",",3)_$P(OrdItem,",",4)
				if (OrderName="") {set OrderName=Name_" "_qty }else{  set OrderName=OrderName_","_Name_" "_qty} 
			}
			s OrderDoseQty=""
			s OrderDoseUOM=""
			s OrderInstr=""
			s OrderFreq=$P(JsonStr,$c(4),2)
			if OrderFreq'="" s OrderFreq=$p(^PHCFR(OrderFreq),"^",3)
			s OrderInstr=$P(JsonStr,$c(4),3)
			if OrderInstr'="" s OrderInstr=$p(^PHCIN(OrderInstr),"^",2)
			s OrderDur=$P(JsonStr,$c(4),4)
			if OrderDur'="" s OrderDur=$p(^PHCDU(OrderDur),"^",3)
			s OrderPackQty=""
			s OrderPackUOM=""
			s OrderPrior=$P(JsonStr,$c(4),7)
			if OrderPrior'="" s OrderPrior=$p(^OECPR(OrderPrior),"^",2)
			s OrderUserAdd=$P(^DHCPracticeDocPre(Rowid),"^",4)
			if OrderUserAdd'="" s OrderUserAdd=$p(^SSU("SSUSR",OrderUserAdd),"^",2)
			//set OrderStartDate=$P(^DHCPracticeDocPre(Rowid),"^",5)
			//set OrderStartTime=$P(^DHCPracticeDocPre(Rowid),"^",6)
			//if OrderStartDate'="" s OrderStartDate=..%ZD(OrderStartDate)
			s PrescStartDate=$P(JsonStr,$c(4),16)
			s OrderStartDate=$p(PrescStartDate," ",1)
			if OrderStartDate'="" {
				s OrderStartDate=..%ZDH(OrderStartDate)
				s OrderStartDate=..%ZD(OrderStartDate)
			}
			s OrderStartTime=$p(PrescStartDate," ",2)
			s OrderStartDate=OrderStartDate_" "_OrderStartTime
			s OrderDate=OrderStartDate
			s PrescEmergency=$P(JsonStr,$c(4),11)
			if (PrescEmergency="true") {
				s OrderName="<span style='color:red;'>急</span>"_" "_OrderName
			}
			s OrdSeqNo=SeqNo
			s SeqNo=SeqNo+1
			s OrderRecDep=""
			s OrderRecDepDr=$P(JsonStr,$c(4),9)
			s:OrderRecDepDr'="" OrderRecDep=$P(^CTLOC(OrderRecDepDr),"^",2)
			d GetOrderInsertType
			set Data=$lb(Rowid,OrderName,OrderDoseQty,OrderDoseUOM,OrderInstr,OrderFreq,OrderDur,OrderPackQty,OrderPackUOM,OrderPrior,OrderUserAdd,OrderStartDate,OrdSeqNo,OrderDate,$g(OrderRecDep),OrderInsertType)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	
		}
		elseif((PageType["^R^")&&((InsertPageType="R")||(InsertPageType=""))){
			k RowDataArr
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(JsonStr,.RowDataArr)
			s OrderName=$G(RowDataArr("OrderName"))
			s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
			s OrderDoseQty=$G(RowDataArr("OrderDoseQty"))
			s OrderDoseUOM=$G(RowDataArr("OrderDoseUOM"))
			s OrderDoseUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",OrderDoseUOM,langid)
			s OrderInstr=$G(RowDataArr("OrderInstr"))
			s OrderInstr=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",OrderInstr,langid)
			s OrderFreq=$G(RowDataArr("OrderFreq"))
			s OrderFreq=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",OrderFreq,langid)
			s OrderDur=$G(RowDataArr("OrderDur"))
			s OrderDur=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",OrderDur,langid)
			s OrderPackQty=$G(RowDataArr("OrderPackQty"))
			s OrderPackUOM=$G(RowDataArr("OrderPackUOM"))
			s OrderPackUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",OrderPackUOM,langid)
			s OrderPrior=$G(RowDataArr("OrderPrior"))
			s OrderPrior=##class(User.OECPriority).GetTranByDesc("OECPRDesc",OrderPrior,langid)
			s OrderUserAdd=$G(RowDataArr("OrderUserAdd"))
			s OrderUserAdd =##class(User.SSUser).GetTranByDesc("SSUSRName",OrderUserAdd,langid)
			s OrderStartDate=$G(RowDataArr("OrderStartDate"))
			s OrderStartTime=$p(OrderStartDate," ",2)
			s OrderStartDate=$p(OrderStartDate," ",1)
			if (OrderStartDate["/") s OrderStartDate=$zdh(OrderStartDate,4)
			if (OrderStartDate["-") s OrderStartDate=$zdh(OrderStartDate,3)
			if OrderStartDate'="" s OrderStartDate=..%ZD(OrderStartDate)
			s OrderStartDate=OrderStartDate_" "_OrderStartTime
			s OrderMasterSeqNo=$G(RowDataArr("OrderMasterSeqNo"))
			if (OrderMasterSeqNo="") {
				s OrdSeqNo=SeqNo,LastMainOrdSeqNo=OrdSeqNo
				s SeqNo=SeqNo+1,SubSeqNo=0
			}else{
				if (LastMainOrdSeqNo="") {
					s OrdSeqNo=SeqNo+1
				}else{
					s OrdSeqNo=LastMainOrdSeqNo_"."_(SubSeqNo+1)
					s SubSeqNo=SubSeqNo+1
				}
			}
			s OrderDate=$G(RowDataArr("OrderDate"))
			S OrderRecDep=$G(RowDataArr("OrderRecDep"))
			s OrderRecDep=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",OrderRecDep,langid)
			d GetOrderInsertType
			set Data=$lb(Rowid,OrderName,OrderDoseQty,OrderDoseUOM,OrderInstr,OrderFreq,OrderDur,OrderPackQty,OrderPackUOM,OrderPrior,OrderUserAdd,OrderStartDate,OrdSeqNo,OrderDate,$g(OrderRecDep),OrderInsertType)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}elseif(((PageType["^Cure^")&&(InsertPageType="Cure"))||((PageType["^CureAdvise^")&&(InsertPageType="CureAdvise"))){
			k RowDataArr
			s JsonStr=..FormatCureData(JsonStr,langid)
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(JsonStr,.RowDataArr)
			s CureAssScoreID=$G(RowDataArr("CureAssScoreID"))
			continue:(AssScoreID'="")&&(AssScoreID'=CureAssScoreID)
			s CureItemRowid=$G(RowDataArr("CureItemRowid"))
			s OrderName=$G(RowDataArr("CureItemArcDesc"))
			s OrderDoseQty=$G(RowDataArr("CureItemDoseQty"))
			s OrderDoseUOM=$G(RowDataArr("CureItemDoseUOMDesc")) 
			s OrderInstr="" //$G(RowDataArr("CureItemDoseUOMDesc"))
			s OrderFreq=$G(RowDataArr("CureItemFreq"))
			s OrderDur=$G(RowDataArr("CureItemDur"))
			s OrderPackQty=$G(RowDataArr("CureItemPackQty"))
			s OrderPackUOM=$G(RowDataArr("CureItemPackUOMDesc"))
			s OrderPrior=$G(RowDataArr("CureItemPrior"))
			s OrderUserAdd=$G(RowDataArr("CureOrderUserAdd"))
			s OrderStartDate=$G(RowDataArr("CureItemStartDate"))
			s OrderStartTime=$p(OrderStartDate," ",2)
			s OrderStartDate=$p(OrderStartDate," ",1)
			if (OrderStartDate["/") s OrderStartDate=$zdh(OrderStartDate,4)
			if (OrderStartDate["-") s OrderStartDate=$zdh(OrderStartDate,3)
			if OrderStartDate'="" s OrderStartDate=..%ZD(OrderStartDate)
			s OrderStartDate=OrderStartDate_" "_OrderStartTime
			s OrderMasterSeqNo=""
			if (OrderMasterSeqNo="") {
				s OrdSeqNo=SeqNo,LastMainOrdSeqNo=OrdSeqNo
				s SeqNo=SeqNo+1,SubSeqNo=0
			}else{
				if (LastMainOrdSeqNo="") {
					s OrdSeqNo=SeqNo+1
				}else{
					s OrdSeqNo=LastMainOrdSeqNo_"."_(SubSeqNo+1)
				}
			}
			s OrderDate=$G(RowDataArr("CureItemStartDate"))
			s OrderRecLoc=$G(RowDataArr("CureItemRecLoc"))
			d GetOrderInsertType
			set Data=$lb(Rowid,OrderName,OrderDoseQty,OrderDoseUOM,OrderInstr,OrderFreq,OrderDur,OrderPackQty,OrderPackUOM,OrderPrior,OrderUserAdd,OrderStartDate,OrdSeqNo,OrderDate,OrderRecLoc,OrderInsertType)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOrderInsertType	
	s OrderInsertType=$case($g(InsertPageType),"C":"实习生草药","R":"实习生医嘱","Cure":"实习生治疗医嘱","CureAdvise":"治疗建议医嘱",:InsertPageType)
	s OrderInsertType=##class(websys.Translation).Get("ipdoc.practicedocpreorder.hui.csp",OrderInsertType,langid)
	Q
}

/// Creator:nk
/// CreateDate:
/// Description:翻译部分字典类型字段
/// Input:
/// Output:
/// Debug:w ##class().ToDo(para)
ClassMethod FormatCureData(DataJson As %String, langid As %String = "")
{
	s:langid="" langid=..%LanguageID()
	s DataObj={}.%FromJSON(DataJson)
	s CureItemRowid=DataObj.CureItemRowid
	q:CureItemRowid="" DataJson
	s CureItemArcDesc=DataObj.CureItemArcDesc
	s CureItemArcDesc=##class(DHCDoc.Common.Translate).GetTransARCIM(CureItemArcDesc,langid)
	s DataObj.CureItemArcDesc=CureItemArcDesc
	s CureItemDoseUOMDesc=DataObj.CureItemDoseUOMDesc
	s CureItemDoseUOMDesc=##class(DHCDoc.Common.Translate).GetTransUOM(CureItemDoseUOMDesc,langid)
	s DataObj.CureItemDoseUOMDesc=CureItemDoseUOMDesc
	s CureItemFreq=DataObj.CureItemFreq
	s CureItemFreq=##class(DHCDoc.Common.Translate).GetTransFreq(CureItemFreq,langid)
	s DataObj.CureItemFreq=CureItemFreq
	s CureItemDur=DataObj.CureItemDur
	s CureItemDur=##class(DHCDoc.Common.Translate).GetTransDura(CureItemDur,langid)
	s DataObj.CureItemDur=CureItemDur
	s CureItemPackUOMDesc=DataObj.CureItemPackUOMDesc
	s CureItemPackUOMDesc=##class(DHCDoc.Common.Translate).GetTransUOM(CureItemPackUOMDesc,langid)
	s DataObj.CureItemPackUOMDesc=CureItemPackUOMDesc
	s CureItemPrior=DataObj.CureItemPrior
	s CureItemPrior=##class(DHCDoc.Common.Translate).GetTransOECPR(CureItemPrior,langid)
	s DataObj.CureItemPrior=CureItemPrior
	s CureOrderUserAdd=##class(DHCDoc.Common.Translate).GetTransUser(DataObj.CureOrderUserAdd,langid)
	s DataObj.CureOrderUserAdd=CureOrderUserAdd
	s CureItemRecLoc=##class(DHCDoc.Common.Translate).GetTransLoc(DataObj.CureItemRecLoc,langid)
	s DataObj.CureItemRecLoc=CureItemRecLoc
	s CureItemBillType=##class(DHCDoc.Common.Translate).GetTransAdmReason(DataObj.CureItemBillType,langid)
	s DataObj.CureItemBillType=CureItemBillType

	q DataObj.%ToJSON()
}

/// 查询待激活医嘱/待处理医嘱列表,供portal组调用
Query FindPracticeOrderForPortal(Adm As %String) As %Query(ROWSPEC = "PracticePreRowid:%String,OrderItemRowid:%String,OrderName:%String,OrderStatus:%String,OrderPrior:%String,OrderInstr:%String,arcim:%String,OrderStartDate:%String,OrderStartTime:%String,OrderDur:%String,OrderApplyDoc:%String,OrderApplyDate:%String,OrderApplyTime:%String,LinkOrder:%String")
{
}

ClassMethod FindPracticeOrderForPortalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPracticeOrderForPortalExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPracticeOrderForPortalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPracticeOrderForPortalExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
		//
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	 }
	 Else {				// fetch row
	 	Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod FindPracticeOrderForPortalExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPracticeDocPreOrder","FindPracticeOrderForPortal","108")
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s Count=1
	k ^||PracticeOrderForPortal
	s UnActiveOrdPriorRowid=$o(^OEC("OSTAT",0,"Code","I",0))
	s UnActiveOrdPrior=$p(^OEC("OSTAT",UnActiveOrdPriorRowid),"^",2)
	//OEORI_Date 	OEORI_TimeOrd  OEORI_Doctor_DR->CTPCP_Desc
	///获取待激活西药医嘱列表
	Set rset=##class(%ResultSet).%New("web.DHCPracticeDocPreOrder:FindPracticeOrder")
	do rset.Execute(Adm,"N","R")
	While (rset.Next()) {
		d RecordSortTmpData
	}
	d rset.Close()
	///获取待激活草药医嘱列表
	Set rset=##class(%ResultSet).%New("web.DHCPracticeDocPreOrder:FindPracticeOrder")
	do rset.Execute(Adm,"N","C")
	While (rset.Next()) {
		d RecordSortTmpData
	}
	d rset.Close()
	///获取待处理医嘱列表
	Set rset=##class(%ResultSet).%New("web.DHCOEOrdItem:FindUnActiveOrderItems")
	do rset.Execute(Adm)
	While (rset.Next()) {
		s PracticePreRowid=""
		s OrderItemRowid=rset.Data("OrderItemRowid")
		s OrderName=rset.Data("OrderName")
		s OrderStatus=rset.Data("OrderStatus")
		s OrderPrior=rset.Data("OrderPrior")
		s OrderInstr=rset.Data("OrderInstr")
		s arcim=rset.Data("OrderARCIMRowid")
		s OrderStartDate=rset.Data("OrderStartDate")
		s OrderStartTime=rset.Data("OrderStartTime")
		s OrderDur=rset.Data("OrderDur")
		s OrderApplyDoc=rset.Data("OrderDoc")
		s OrderApplyDate=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),3),"^",7)
		s OrderApplyDate=..%ZD(OrderApplyDate)
		s OrderApplyTime=$p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),1),"^",17)
		s OrderApplyTime=..%ZT(OrderApplyTime,1)
		s LinkOrder=rset.Data("LinkOrderItem")
		d OutPutData
	}
	d rset.Close()
	s date=0
	for {
		s date=$o(^||PracticeOrderForPortal(date)) q:date=""
		s time=0
		for {
			s time=$o(^||PracticeOrderForPortal(date,time)) q:time=""
			s count=0
			for {
				s count=$o(^||PracticeOrderForPortal(date,time,count)) q:count=""
				s data=$g(^||PracticeOrderForPortal(date,time,count))
				d OutputRow1
			}
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	Set ^CacheTemp(repid,ind)=data
	Set ind=ind+1
	quit
OutPutData
	s Data=$lb(PracticePreRowid,OrderItemRowid,OrderName,OrderStatus,OrderPrior,OrderInstr,arcim,OrderStartDate,OrderStartTime,OrderDur,OrderApplyDoc,OrderApplyDate,OrderApplyTime,LinkOrder)
	Set ^||PracticeOrderForPortal(OrderStartDate,OrderStartTime,Count)=Data
	Set Count=Count+1
	Q
RecordSortTmpData
	s OrderItemRowid=""
	s PracticePreRowid=rset.Data("Rowid")
	s OrderName=rset.Data("OrderName")
	s OrderStatus=UnActiveOrdPrior
	s OrderPrior=rset.Data("OrderPrior")
	s OrderInstr=rset.Data("OrderInstr")
	s arcim=""
	s OrderStartDate=rset.Data("OrderStartDate")
	s OrderStartTime=$p(OrderStartDate," ",2)
	s OrderStartDate=$p(OrderStartDate," ",1)
	s OrderDur=rset.Data("OrderDur")
	s OrderApplyDoc=rset.Data("OrderUserAdd")
	s OrderDate=rset.Data("OrderDate")
	s OrderApplyDate=$p(OrderDate," ",1)
	s OrderApplyTime=$p(OrderDate," ",2)
	s LinkOrder=""
	d OutPutData
	Quit
}

}
