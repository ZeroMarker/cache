/// 名称:  DHCLabToEPR.DHCLabTestSetQuery
/// 描述:  为电子病历提供的LIS接口
/// 编写者：胡华明,王伟宏
/// 编写日期: 2009-01-12
/// 可调用的类方法列表：
/// Query SelectReportByOeordID   ;根据选择的具体医嘱ID，取得本医嘱的检验项目的结果
/// Query SelectLISItemListByDate ;根据"就诊号","开始时间(医嘱)","结束时间(医嘱)",查询医嘱套Rowid,医嘱套描述,标本号
/// Query SelectReportListByTS    ;根据登记号,检验套查询患者具体检验套具体所有检验项目的数据（历史数据）
/// Query SelectReportItemByTC    ;根据登记号,检验代码查询患者具体检验套具体所有检验项目的数据。
/// Query SelectLISCTDepartList   ;取得检验项目接收科室列表
/// Query SelectLISCTTestsetList  ;取得接收科室下检验套列表
/// Query SelectLISCTCodeList     ;取得检验套下检验项目列表
/// Query GetReportItemByTestCode ;根据就诊号,检验套,检验项查询患者具体检验套具体某个检验项目的数据
/// Query GetBloodItemByDebtorCode ;根据登记号查询血型信息
Class DHCLabToEPR.DHCLabTestSetQuery Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Creator：      胡华明
/// CreateDate：   2009-01-12
/// Description:：根据指定医嘱ID，取得本医嘱的检验项目的结果
/// Table： CT_TestSet,CT_TestCode,OE_OrdItm
/// Input： 医嘱OeordID
/// Output：ItemDesc:描述,Synonym:英文缩写,ItemResult:结果,ItemUnit:单位
///         AbnorFlag:异常标记,ItemRanges:范围值,Sequence:序号
/// Return：无        
/// Others：无
/// Modify: 2011-05-27 huhm 单位,参考范围,异常标志取值修改.包含接口和非接口
/// Debug: 
Query SelectReportByOeordID(OeordID As %String) As %Query(ROWSPEC = "ItemDesc:%String,Synonym:%String,ItemResult:%String,ItemUnit:%String,AbnorFlag:%String,ItemRanges:%String,Sequence:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCLabToEPR.DHCLabTestSetQuery","SelectReportByOeordID","462||312")
ClassMethod SelectReportByOeordIDExecute(ByRef qHandle As %Binary, OeordID As %String) As %Status
{
 	Set repid=$i(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	/// EH 如果传入的是标本号则调用平台接口
 	i (OeordID'="")&(OeordID'["||"){
		s oew=$o(^OEORD(0,"EpisNo",OeordID,""))
		q:(oew="") $$$OK
		s thisRepid=repid
		s thisInd=ind
		s adm=$p($g(^OEORD(oew)),"^",1)
		s rset=##class(%ResultSet).%New("EMRservice.BL.BLLisData.GetLisDataDetial")
		d rset.Execute(adm,"","",OeordID)
		while(rset.Next()){
			s ItemDesc=rset.GetData(2)
			s Synonym=rset.GetData(3)
			s ItemResult=rset.GetData(4)
			s ItemUnit=rset.GetData(5)
			s AbnorFlag=rset.GetData(6)
			s ItemRanges=rset.GetData(7)
			Set Data=$lb(ItemDesc,Synonym,ItemResult,ItemUnit,AbnorFlag,ItemRanges)
		 	Set ^CacheTemp(thisRepid,thisInd)=Data
		 	Set thisInd=thisInd+1
		}
		d rset.Close()
		s rset=""
		Quit $$$OK
	}
 	
 	k ^TMPLIS($zn,repid)
 	Set ORDID=$Piece(OeordID,"||",1)
 	Set ORDSUB=$Piece(OeordID,"||",2)
 	Quit:'($l(ORDID)!$l(ORDSUB)) $$$OK
 	Set DataFlag=$D(^OEORD(ORDID,"I",ORDSUB,3))
 	Set temstr=$G(^OEORD(ORDID,"I",ORDSUB,3))
 	//20191110 liuzf 统一调整从LIS获取关联
 	s ReportDR=$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OeordID),""))
 	i '$l(ReportDR)  Quit $$$OK
 	i '$d(^dbo.RPVisitNumberReportD(ReportDR)) q $$$OK
	s VisitNumberTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OeordID),ReportDR,""))
	I '$l(VisitNumberTestSetDR)  Quit $$$OK
	//报告信息
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),2)
	s TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),3)
	i '$l(VisitNumberDR) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),5)
	i '$l(WorkGroupMachineDR) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s WorkGroupDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)
	i $lg($g(^dbo.RPVisitNumberReportD(ReportDR)),22)'=3 Set qHandle=$lb(0,repid,0) q $$$OK
	S SplitStatus=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),44)
	k SplitsReportList
	s SplitsReportList(ReportDR)=""
	//获取拆分报告
	i SplitStatus="1" D  
    .s FTesCodeDR="" f  s FTesCodeDR=$o(^dbo.RPReportSplitRecordI("IndexMaster",ReportDR,FTesCodeDR)) q:FTesCodeDR=""  D
	..s SplitReportDR=$o(^dbo.RPReportSplitRecordI("IndexMaster",ReportDR,FTesCodeDR,""))
	..i $lg($g(^dbo.RPVisitNumberReportD(SplitReportDR)),22)'=3 q
	..s SplitsReportList(SplitReportDR)=""   
	s FReportDR="" f  s FReportDR=$o(SplitsReportList(FReportDR)) q:FReportDR=""  d
 	.s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",FReportDR,TestCodeDR)) q:TestCodeDR=""  d
 	..s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
 	..s TestCode=$lg(TestCodeData,2)
	..s ItemDesc=$lg(TestCodeData,3)
	..s Synonym=$lg(TestCodeData,7)
 	..s ResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",FReportDR,TestCodeDR,"")) 
 	..q:'$l(ResultDR)
 	..s ResultData=$g(^dbo.RPVisitNumberReportResultD(ResultDR))
 	..s OperateType=$lg(ResultData,32)
 	..i OperateType="D" q //删除的项目剔除
	..s tmpTestSetDR=$lg(ResultData,28)
	..i $l(tmpTestSetDR),(tmpTestSetDR'=TestSetDR) q  
	..s ItemResult=$lg(ResultData,5)
	..s ItemUnit=$lg(ResultData,11) 
	..s AbnorFlag=$lg(ResultData,9)
	..s ItemRanges=$lg(ResultData,12)
	..s ResNoes=$lg(ResultData,8)
	..s MethodDR=$lg(ResultData,13)
	..s MethodName=""
	..i $l(MethodDR) d
	...s MethodData=$g(^dbo.BTTestMethodD(MethodDR))
	...s MethodName=$lg(MethodData,3)
 	..s Sequence=+$lg(ResultData,18)
 	..s ^TMPLIS($zn,repid,Sequence,ResultDR)=$lb(ItemDesc,Synonym,ItemResult,ItemUnit,AbnorFlag,ItemRanges,Sequence)
 	
   //排序
 	s Seq="" f  s Seq=$o(^TMPLIS($zn,repid,Seq)) q:Seq=""  d
 	.s ResDR="" f  s ResDR=$o(^TMPLIS($zn,repid,Seq,ResDR)) q:ResDR=""  d
	..Set Data=^TMPLIS($zn,repid,Seq,ResDR)
 	..Do OutPut

 	
 	k ^TMPLIS($zn,repid)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod SelectReportByOeordIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectReportByOeordIDExecute ]
{
	
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectReportByOeordIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectReportByOeordIDExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      HouJian
/// CreateDate：   2009-09-05
/// Description:： 批量获取医嘱的检验项目结果
/// Table： CT_TestSet,CT_TestCode,OE_OrdItm
/// Input： 医嘱OeordID序列，如 OeordID1^OeordID2^OeordID3
/// Output：ItemDesc:描述,Synonym:英文缩写,ItemResult:结果,ItemUnit:单位
///         AbnorFlag:异常标记,ItemRanges:范围值,OeordID:医嘱RowId
/// Return：无        
/// Others：无
/// d ##class(%ResultSet).RunQuery("DHCLabToEPR.DHCLabTestSetQuery","SelReportByOeordIDList","110||238")
Query SelReportByOeordIDList(OeordIDList As %String) As %Query(ROWSPEC = "ItemDesc:%String,Synonym:%String,ItemResult:%String,ItemUnit:%String,AbnorFlag:%String,ItemRanges:%String,OeordID:%String")
{
}

ClassMethod SelReportByOeordIDListExecute(ByRef qHandle As %Binary, OeordIDList As %String) As %Status
{
 	Set repid=$i(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:(OeordIDList="") $$$OK
 	
 	set count = $Length(OeordIDList,"^")
 	for i = 1:1:count
 	{
	 	set OeordID = $P(OeordIDList,"^",i)
	 	if OeordID="" continue
	 	
 		set rset = ##class(%ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectReportByOeordID")
 		set sc = rset.Execute(OeordID)
 		if $$$ISERR(sc) continue
 		
 		while rset.Next(.sc)
 		{
	 		set ItemDesc = rset.GetData(1)
	 		set Synonym = rset.GetData(2)
	 		set ItemResult = rset.GetData(3)
	 		set ItemUnit = rset.GetData(4)
		 	set tempOption = $F(ItemUnit,"10S")
	 		if tempOption'=0 set $e(ItemUnit,tempOption-4,tempOption-1)="10^"
	 		set AbnorFlag = rset.GetData(5)
	 		set ItemRanges = rset.GetData(6)
	 		d MyOutPut
 		}	
 	}
 	
	Quit $$$OK

MyOutPut
	Set Data=$lb(ItemDesc,Synonym,ItemResult,ItemUnit,AbnorFlag,ItemRanges,OeordID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod SelReportByOeordIDListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelReportByOeordIDListExecute ]
{
	
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		//added on 2010-01-13 by houj
 		kill ^CacheTemp(repid)
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelReportByOeordIDListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelReportByOeordIDListExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      huanliang
/// CreateDate：   2015-12-11
/// Description:：根据"就诊号","开始条数","结束条数",查询医嘱套Rowid,医嘱套描述,标本号
/// Table： OE_Order,OE_OrdItm
/// Input： 医嘱OeordID
/// Output：医嘱套Rowid：OEordItemRowID,医嘱套描述：OEordItemDesc,标本号：LabEpisodeNo,标本类型：SpecimenDesc
///         标本采集日期：CollectionDate,标本采集时间:CollectionTime,标本接收日期：ReceiveDate,标本接收时间:ReceiveTime
///         标本审核日期:AuthorisationDate,标本审核时间:AuthorisationTime,是否有报告：ExistReport(Y:存在，N:不存在)
/// Return：无        
/// Others：日期格式为数据库默认的存储格式，如果时间未指定查询所有
/// d ##class(%ResultSet).RunQuery("DHCLabToEPR.DHCLabTestSetQuery","SelReportByOeordIDList","110||238")
Query SelectLISItemListByCount(EpisodeID As %String, BegNum As %String = 0, EndNum As %String = 0) As %Query(ROWSPEC = "OEordItemRowID:%String,OEordItemDesc:%String,LabEpisodeNo:%String,SpecimenDesc:%String,CollectionDate:%String,CollectionTime:%String,ReceiveDate:%String,ReceiveTime:%String,AuthorisationDate:%String,AuthorisationTime:%String,ExistReport:%String")
{
}

ClassMethod SelectLISItemListByCountExecute(ByRef qHandle As %Binary, EpisodeID As %String, BegNum As %String = 0, EndNum As %String = 0) As %Status
{
	Set ResultSetRootNode=$i(^CacheTemp) 	//记录集的根节点
	Set Counter=0       					// 统计记录数，同时为子节点
	Set qHandle=$lb(ResultSetRootNode,Counter)
			
 	Set OrderInfo=""    					//保存一条记录
 	s TotCount = 0
 	s QuitFlag = "False"
 	if (BegNum>EndNum)||(BegNum<=0)||(EndNum<=0)
 	{
		Quit $$$OK
 	}
 	
	Set OrderId="" 
	For  {
		set OrderId=$Order(^OEORD(0,"Adm",EpisodeID,OrderId),-1) 		//按OrderId倒序
		Quit:(OrderId="")  
		Quit:(QuitFlag="True")
				
		Set OrderSubId=""  
		For  {
			set OrderSubId=$Order(^OEORD(OrderId,"I",OrderSubId),-1) 	//按OrderSubId倒序
			Quit:(OrderSubId="")
			Quit:(QuitFlag="True")  
			
			S DataFlag=$Data(^OEORD(OrderId,"I",OrderSubId,1))
			if (DataFlag'=1)&(DataFlag'=11) continue
	
			Set ARCItemMastStr=^OEORD(OrderId,"I",OrderSubId,1)
			S OEOrdStatus=$P(ARCItemMastStr,"^",13)
			if OEOrdStatus'=6 continue 									//如果不是已经执行的医嘱则退出
	
			Set TestSetStr=^OEORD(OrderId,"I",OrderSubId,3)
			Set ARCIMId=$Piece(ARCItemMastStr,"^",2) 
			if ARCIMId="" continue
			
			Set ItemNameDesc=..GetLabItemNameDesc(ARCIMId) 
			if ItemNameDesc="" continue
			
			Set OrderRowId=OrderId_"||"_OrderSubId
			Set LabNo=$Piece(TestSetStr,"^",20)

			//20191110 liuzf 统一调整从LIS获取关联
		 	s VisitNumberReportDR=$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OrderRowId),""))
		 	If '$l(VisitNumberReportDR) continue
		 	i '$d(^dbo.RPVisitNumberReportD(VisitNumberReportDR)) q
			s VisitNumberTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OrderRowId),VisitNumberReportDR,""))
						
			Set (SpeDesc,CollectDate,CollectTime,RecDate,RecTime,AuthorDate,AuthorTime,ExistReport)=""
			s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),2)
			s TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),3)
			i VisitNumberDR="" q
			s VisitNumberData=$G(^dbo.RPVisitNumberD(VisitNumberDR))
			s SpecimenDR=$lg(VisitNumberData,56) s SpeDesc=""
			i $l(SpecimenDR)  s SpeDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
			s CollectDate=$lg(VisitNumberData,51)
			s CollectTime=$lg(VisitNumberData,52)
			s RecDate=$lg(VisitNumberData,66)
			s RecTime=$lg(VisitNumberData,67)
			s WorkGroupMachineDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,""))
			s AuthorDate="" s AuthorTime=""
			i $l(VisitNumberReportDR) {
				s AuthorDate=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),19)
				s AuthorTime=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),20)
			}
			s ExistReport="N"
			i $lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),22)=3 s ExistReport="Y"
			i $l(AuthorTime) s AuthorTime=$zt(AuthorTime,2)
			i $l(RecTime) s RecTime=$zt(RecTime,2)
			i $l(CollectTime) s CollectTime=$zt(CollectTime,2)
			i $l(AuthorDate) s AuthorDate=$e(AuthorDate,1,4)_"-"_$e(AuthorDate,5,6)_"-"_$e(AuthorDate,7,8)
			i $l(RecDate) s RecDate=$e(RecDate,1,4)_"-"_$e(RecDate,5,6)_"-"_$e(RecDate,7,8)
			i $l(CollectDate) s CollectDate=$e(CollectDate,1,4)_"-"_$e(CollectDate,5,6)_"-"_$e(CollectDate,7,8) //转换日期时间格式
			Set OrderInfo=""
			set TotCount = TotCount + 1
			if (TotCount>=BegNum)&&(TotCount<=EndNum)
			{
				Set Counter=Counter+1
				Set OrderInfo=$lb(OrderRowId,ItemNameDesc,LabNo,SpeDesc,CollectDate,CollectTime,RecDate,RecTime,AuthorDate,AuthorTime,ExistReport) //保存医嘱套RowID,医嘱描述,标本号
    			Set ^CacheTemp(ResultSetRootNode,Counter)=OrderInfo
			}
			elseif (TotCount>EndNum) 
			{
				s QuitFlag="True"
				quit
			}
		}
	}
	
    Set qHandle=$lb(ResultSetRootNode,"0")
    Kill Counter
	Quit $$$OK
}

ClassMethod SelectLISItemListByCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLISItemListByCountExecute ]
{
	set RootNode=$List(qHandle,1)
	Set currChildNode=$List(qHandle,2)
	set currChildNode = $O(^CacheTemp(RootNode,currChildNode))
	
	if currChildNode="" 
	{
		s Row="",AtEnd=1
		//added on 2010-01-13 by houj
		kill ^CacheTemp(RootNode)
	}
	else 
	{	
		s Row=^CacheTemp(RootNode,currChildNode)
		s qHandle=$lb(RootNode,currChildNode)
	}
	
	Quit $$$OK
}

ClassMethod SelectLISItemListByCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLISItemListByCountExecute ]
{
	set RootNode=$List(qHandle,1)
	Kill ^CacheTemp(RootNode)
	Set qHandle=""
	Quit $$$OK
}

/// Creator：      黄亮亮
/// CreateDate：   2015-12-09
/// Description:：根据"就诊号","开始时间(医嘱)","结束时间(医嘱)",查询医嘱套Rowid,医嘱套描述,标本号
/// Table： OE_Order,OE_OrdItm
/// Input： 医嘱OeordID
/// Output：医嘱套Rowid：OEordItemRowID,医嘱套描述：OEordItemDesc,标本号：LabEpisodeNo,标本类型：SpecimenDesc
///         标本采集日期：CollectionDate,标本采集时间:CollectionTime,标本接收日期：ReceiveDate,标本接收时间:ReceiveTime
///         标本审核日期:AuthorisationDate,标本审核时间:AuthorisationTime,是否有报告：ExistReport(Y:存在，N:不存在)
/// Return：无        
/// Others：日期格式为数据库默认的存储格式，如果时间未指定查询所有
/// d ##Class(%ResultSet).RunQuery("DHCLabToEPR.DHCLabTestSetQuery","SelectLISItemListByDate","338135","","")
Query SelectLISItemListByDate(EpisodeID As %String, Begdate As %Date = 0, EndDate As %Date = 0, FExistReport As %String) As %Query(ROWSPEC = "OEordItemRowID:%String,OEordItemDesc:%String,LabEpisodeNo:%String,SpecimenDesc:%String,CollectionDate:%String,CollectionTime:%String,ReceiveDate:%String,ReceiveTime:%String,AuthorisationDate:%String,AuthorisationTime:%String,ExistReport:%String,VisitNumberReportDR:%String")
{
}

ClassMethod SelectLISItemListByDateExecute(ByRef qHandle As %Binary, EpisodeID As %String, Begdate As %Date = 0, EndDate As %Date = 0, FExistReport As %String) As %Status
{
	S FExistReport=$G(FExistReport)
	S EpisodeID=$G(EpisodeID)
	S EndDate=$G(EndDate)
	S Begdate=$G(Begdate)
	Set ResultSetRootNode=$i(^CacheTemp) 		//记录集的根节点
	Set Counter=0       						//统计记录数，同时为子节点
 	Set OrderInfo=""    //保存一条记录
	Set OrderId="" 
	For  set OrderId=$Order(^OEORD(0,"Adm",EpisodeID,OrderId)) Quit:OrderId=""  Do
	.Set OEOrdDate=$P(^OEORD(OrderId),"^",2)
	.//Quit:$$CheckDate()'=1   //判断医嘱时间是否在查询的时间段中
	.Set OrderSubId=""  
	.For  set OrderSubId=$Order(^OEORD(OrderId,"I",OrderSubId)) Quit:OrderSubId=""  Do
	..S DataFlag=$Data(^OEORD(OrderId,"I",OrderSubId,1))
	..Q:(DataFlag'=1)&(DataFlag'=11)
	..Set ARCItemMastStr=^OEORD(OrderId,"I",OrderSubId,1)
	..s ItmMastDr=$p(ARCItemMastStr,"^",2)
	..i '$l(ItmMastDr) q
	..i '##Class(web.DHCLabOrder).isLabTS(ItmMastDr) q
	..S OEOrdStatus=$P(ARCItemMastStr,"^",13)
	..Q:OEOrdStatus'=6 //如果不是已经执行的医嘱则退出
	..Set OEOrdDate = $p($g(^OEORD(OrderId,"I",OrderSubId,3)),"^",7)  //按医嘱日期查询
	..i $l(OEOrdDate),$l(Begdate),OEOrdDate-Begdate<0 q
	..i $l(OEOrdDate),$l(EndDate),OEOrdDate-EndDate>0 q
	..;Quit:$$CheckDate()'=1   //判断医嘱时间是否在查询的时间段中
	..Set TestSetStr=^OEORD(OrderId,"I",OrderSubId,3)
	..Set ARCIMId=$Piece(ARCItemMastStr,"^",2) Quit:ARCIMId=""
	..Set ItemNameDesc=..GetLabItemNameDesc(ARCIMId) Quit:ItemNameDesc=""
	..Set OrderRowId=OrderId_"||"_OrderSubId
	..Set LabNo=$Piece(TestSetStr,"^",20)
	..q:'$l(LabNo)
	..//20191110 liuzf 统一调整从LIS获取关联
	..s VisitNumberReportDR=$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OrderRowId),""))
	..q:'$l(VisitNumberReportDR)
	..i '$d(^dbo.RPVisitNumberReportD(VisitNumberReportDR)) q
	..s VisitNumberTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OrderRowId),VisitNumberReportDR,""))
	..Set (SpeDesc,CollectDate,CollectTime,RecDate,RecTime,AuthorDate,AuthorTime,ExistReport)=""
	..s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),2)
	..s TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),3)
	..i VisitNumberDR="" q
	..s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),5)
	..s VisitNumberData=$G(^dbo.RPVisitNumberD(VisitNumberDR))
	..s SpecimenDR=$lg(VisitNumberData,56) s SpeDesc=""
	..i $l(SpecimenDR)  s SpeDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	..s CollectDate=$lg(VisitNumberData,51)
	..s CollectTime=$lg(VisitNumberData,52)
	..s RecDate=$lg(VisitNumberData,66)
	..s RecTime=$lg(VisitNumberData,67)
	..S ExistReport="N"
	..i '$l(WorkGroupMachineDR)  q
	..s AuthorDate=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),19)
	..s AuthorTime=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),20)
	..i $lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),22)=3 s ExistReport="Y"
	..i $L(FExistReport),FExistReport'=ExistReport Q //
	..i $l(AuthorTime) s AuthorTime=$zt(AuthorTime,2)
	..i $l(RecTime) s RecTime=$zt(RecTime,2)
	..i $l(CollectTime) s CollectTime=$zt(CollectTime,2)
	..i $l(AuthorDate) s AuthorDate=$e(AuthorDate,1,4)_"-"_$e(AuthorDate,5,6)_"-"_$e(AuthorDate,7,8)
	..i $l(RecDate) s RecDate=$e(RecDate,1,4)_"-"_$e(RecDate,5,6)_"-"_$e(RecDate,7,8)
	..i $l(CollectDate) s CollectDate=$e(CollectDate,1,4)_"-"_$e(CollectDate,5,6)_"-"_$e(CollectDate,7,8)
	..Set OrderInfo=""
	..Set OrderInfo=$lb(OrderRowId,ItemNameDesc,LabNo,SpeDesc,CollectDate,CollectTime,RecDate,RecTime,AuthorDate,AuthorTime,ExistReport,VisitNumberReportDR) //保存医嘱套RowID,医嘱描述,标本号
    ..Set ^CacheTemp(ResultSetRootNode,Counter)=OrderInfo
    ..Set Counter=Counter+1
    
    //重置qHandle的值，方便倒序输出
    Set qHandle=$lb(ResultSetRootNode,Counter)
    Kill Counter
	Quit $$$OK
CheckDate()
    if ((Begdate=0)&&(EndDate=0)) //未指定开始时间和结束时间
    {   
	    Quit 1
	}ElseIF (((Begdate=0)&&(OEOrdDate<=EndDate))||((EndDate=0)&&(OEOrdDate>=Begdate))) //未指定开始时间或结束时间
	{  
		Quit 1
	}ElseIF ((OEOrdDate>=Begdate)&&(OEOrdDate<=EndDate)) //指定了开始时间和结束时间
	{
		b ///?
		Quit 1
	}
    Quit 0   //其他情况返回0
}

ClassMethod SelectLISItemListByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLISItemListByDateExecute ]
{
	/*
	set RootNode=$List(qHandle,1)
	Set currChildNode=$List(qHandle,2)
	Set:currChildNode=0 Row="",AtEnd=1
	Set:currChildNode'=0 Row=^CacheTemp(RootNode,currChildNode-1),qHandle=$lb(RootNode,currChildNode-1)
	Quit $$$OK
	*/
	
	//modified on 2010-01-13 by houj
	set RootNode=$List(qHandle,1)
	Set currChildNode=$List(qHandle,2)
	
	s currChildNode = $O(^CacheTemp(RootNode,currChildNode),-1)
	if (currChildNode="") 
	{
		s Row=""
		s AtEnd=1
		kill ^CacheTemp(RootNode)
	}
	else
	{
		s Row=^CacheTemp(RootNode,currChildNode)
		s qHandle=$lb(RootNode,currChildNode)
	}
	
	Quit $$$OK
}

ClassMethod SelectLISItemListByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLISItemListByDateExecute ]
{
	set RootNode=$List(qHandle,1)
	Kill ^CacheTemp(RootNode)
	Set qHandle=""
	Quit $$$OK
}

/// Creator：      王伟宏
/// CreateDate：   2009-01-12
/// Description:：根据登记号DebtorCode,检验套CtTestSetDr查询患者具体检验套具体所有检验项目的数据（历史数据）
/// Table： CT_TestSet,CT_TestCode,EP_VisitNumber,DEB_Debtor
/// Input： DebtorCode：病人登记号，CtTestSetDr：检验医嘱套
/// Output：ItemCode:检验项代码,ItemDesc:检验项描述,Synonym:英文缩写,ItemResult:检验项结果,ItemUnit:单位,AbnorFlag:异常标志,ItemRangs:参考范围,ItemDate:审核日期,ItemTime:审核时间
/// Return：无        
/// Others：无
/// d ##Class(%ResultSet).RunQuery("DHCLabToEPR.DHCLabTestSetQuery","SelectReportListByTS","0000018925","5")
Query SelectReportListByTS(DebtorCode As %String, CtTestSetDr As %String) As %Query(ROWSPEC = "ItemCode:%String,ItemDesc:%String,Synonym:%String,ItemResult:%String,ItemUnit:%String,AbnorFlag:%String,ItemRangs:%String,ItemDate:%Date,ItemTime:%Time")
{
}

ClassMethod SelectReportListByTSExecute(ByRef qHandle As %Binary, DebtorCode As %String, CtTestSetDr As %String) As %Status
{
	//根据登记号DebtorCode获得检验号EpisodeID
	Set RootNode=$i(^CacheTemp)
	Set CollectDate=""  //医嘱时间
	Set NodeCounter=0   //记录计数
	s RequestDate=""
	f  s RequestDate=$o(^dbo.RPVisitNumberI("IndexPatientRequest",##Class(LIS.Util.Common).IndexData(DebtorCode),RequestDate)) Quit:RequestDate=""  d
	.s RPVisitNumberDR="" f  s RPVisitNumberDR=$o(^dbo.RPVisitNumberI("IndexPatientRequest",##Class(LIS.Util.Common).IndexData(DebtorCode),RequestDate,RPVisitNumberDR)) q:RPVisitNumberDR=""  d
	..q:'$d(^dbo.RPVisitNumberTestSetI("IndexMaster",RPVisitNumberDR,CtTestSetDr))
	..s RPVisitNumberTestSetDR=$O(^dbo.RPVisitNumberTestSetI("IndexMaster",RPVisitNumberDR,CtTestSetDr,""))
	..s RPVisitNumberTestSetData=$g(^dbo.RPVisitNumberTestSetD(RPVisitNumberTestSetDR))
	..s WorkGroupMachineDR=$lg(RPVisitNumberTestSetData,5)
	..q:'$l(WorkGroupMachineDR)
	..s orderno=$o(^dbo.RPVisitNumberReportI("IndexReportID",RPVisitNumberDR,WorkGroupMachineDR,""))
	..q:'$l(orderno)
	..s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",RPVisitNumberDR,WorkGroupMachineDR,orderno,""))
	..Q:'$D(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR))
	..S TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR)) q:TestCodeDR=""  d
	...s ResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR,"")) 
	...q:ResultDR=""
	...s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
	...s ItemCode = $lg(TestCodeData,2)
	...s ItemDesc=$lg(TestCodeData,3)
	...s Synonym = $lg(TestCodeData,7) //缩写
	...s ItemUnit = $lg(TestCodeData,8) //单位
	...s ReportResult=$g(^dbo.RPVisitNumberReportResultD(ResultDR))
	...s OperateType=$lg(ReportResult,32)
 	...i OperateType="D" q //删除的项目剔除
	...s ItemResult=$lg(ReportResult,5)
	...s AbnorFlag=$lg(ReportResult,9)
	...s ItemRangs = $lg(ReportResult,12) //参考范围
	...s ItemDate=$lg(ReportResult,16)
	...s ItemTime=$lg(ReportResult,17)
	...Set ^CacheTemp(RootNode,NodeCounter)=$LB(ItemCode,ItemDesc,Synonym,ItemResult,ItemUnit,AbnorFlag,ItemRangs,ItemDate,ItemTime)
	...Set NodeCounter=NodeCounter+1
	Set qHandle=$LB(0,RootNode,0)
	Quit $$$OK
}

ClassMethod SelectReportListByTSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectReportListByTSExecute ]
{
	Set AtEnd=$List(qHandle,1)
	Set RootNode=$List(qHandle,2)
	Set CurrNode=$List(qHandle,3)

	if (CurrNode="")||($Data(^CacheTemp(RootNode,CurrNode))=0)
	{   
	    Set AtEnd=1,Row=""
	}
	else
	{  
	     Set NextNode=$Order(^CacheTemp(RootNode,CurrNode))
		 Set qHandle=$LB(0,RootNode,NextNode)
		 Set Row=^CacheTemp(RootNode,CurrNode)
	}
	Quit $$$OK
}

ClassMethod SelectReportListByTSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectReportListByTSExecute ]
{
	Set RootNode=$List(qHandle,2)
	Kill ^CacheTemp(RootNode)
	Set qHandle=""
	Quit $$$OK
}

/// Creator：      王伟宏
/// CreateDate：   2009-01-12
/// Description:根据登记号DebtorCode,检验代码CtTestCodeDr查询患者具体检验套具体所有检验项目的数据。
/// Table： CT_TestSet,CT_TestCode,EP_VisitNumber,DEB_Debtor
/// Input： DebtorCode：病人登记号，CtTestCodeDr：检验项目代码
/// Output：ItemDesc:检验项描述,ItemResult:检验项结果,ItemUnit:单位,AbnorFlag:异常标志,ItemRangs:参考范围,ItemDate:日期
/// Return：无        
/// Others：无
/// d ##Class(%ResultSet).RunQuery("DHCLabToEPR.DHCLabTestSetQuery","SelectReportItemByTC","0000018925","1")
Query SelectReportItemByTC(DebtorCode As %String, CtTestCodeDr As %String) As %Query(ROWSPEC = "ItemDesc:%String,ItemResult:%String,ItemUnit:%String,AbnorFlag:%String,ItemRangs:%String,ItemDate:%Date")
{
}

ClassMethod SelectReportItemByTCExecute(ByRef qHandle As %Binary, DebtorCode As %String, CtTestCodeDr As %String) As %Status
{
	//根据登记号DebtorCode获得检验号EpisodeID   许琳 2009-6-9
	Set RootNode=$i(^CacheTemp)
	Set (CollectDate,CollectTime,EpisodeID)=""  //医嘱日期,医嘱时间,标本号
	Set NodeCounter=0   //记录计数
	s RequestDate=""
	f  s RequestDate=$o(^dbo.RPVisitNumberI("IndexPatientRequest",##Class(LIS.Util.Common).IndexData(DebtorCode),RequestDate)) Quit:RequestDate=""  d
	.s RPVisitNumberDR="" f  s RPVisitNumberDR=$o(^dbo.RPVisitNumberI("IndexPatientRequest",##Class(LIS.Util.Common).IndexData(DebtorCode),RequestDate,RPVisitNumberDR)) q:RPVisitNumberDR=""  d
	..s CtTestSetDr="" f  s CtTestSetDr=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",RPVisitNumberDR,CtTestSetDr)) q:CtTestSetDr=""  d
	...s RPVisitNumberTestSetDR=$O(^dbo.RPVisitNumberTestSetI("IndexMaster",RPVisitNumberDR,CtTestSetDr,""))
	...s RPVisitNumberTestSetData=$g(^dbo.RPVisitNumberTestSetD(RPVisitNumberTestSetDR))
	...s WorkGroupMachineDR=$lg(RPVisitNumberTestSetData,5)
	...q:'$l(WorkGroupMachineDR)
	...s WorkGroupDR=$LG($G(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)
	...Q:'$D(^dbo.BTTestSetLayoutI("IndexMaster",CtTestSetDr,WorkGroupDR, CtTestCodeDr))
	...s orderno=$o(^dbo.RPVisitNumberReportI("IndexReportID",RPVisitNumberDR,WorkGroupMachineDR,""))
	...q:'$l(orderno)
	...s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",RPVisitNumberDR,WorkGroupMachineDR,orderno,""))
	...Q:'$D(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR))
	...S TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR)) q:TestCodeDR=""  d
	....q:'$d(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,CtTestCodeDr))
	....s ResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR,"")) 
    ....s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
	....s ItemCode = $lg(TestCodeData,2)
	....s ItemDesc=$lg(TestCodeData,3)
	....s Synonym = $lg(TestCodeData,7) //缩写
	....s ItemUnit = $lg(TestCodeData,8) //单位
	....s ReportResult=$g(^dbo.RPVisitNumberReportResultD(ResultDR))
	....s OperateType=$lg(ReportResult,32)
 	....i OperateType="D" q //删除的项目剔除
	....s ItemResult=$lg(ReportResult,5)
	....s AbnorFlag=$lg(ReportResult,9)
	....s ItemRangs = $lg(ReportResult,12) //参考范围
	....s ItemDate=$lg(ReportResult,16)
	....s ItemTime=$lg(ReportResult,17)
	....Set ^CacheTemp(RootNode,NodeCounter)=$LB(ItemDesc,ItemResult,ItemUnit,AbnorFlag,ItemRangs,ItemDate)
	....Set NodeCounter=NodeCounter+1
	
	Set qHandle=$LB(0,RootNode,0)
	
	Quit $$$OK
}

ClassMethod SelectReportItemByTCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectReportItemByTCExecute ]
{
	Set AtEnd=$List(qHandle,1)
	Set RootNode=$List(qHandle,2)
	Set CurrNode=$List(qHandle,3)

	if (CurrNode="")||($Data(^CacheTemp(RootNode,CurrNode))=0)
	{   
	    Set AtEnd=1,Row=""
	}
	else
	{  
	     Set NextNode=$Order(^CacheTemp(RootNode,CurrNode))
		 Set qHandle=$LB(0,RootNode,NextNode)
		 Set Row=^CacheTemp(RootNode,CurrNode)
	}
	Quit $$$OK
}

ClassMethod SelectReportItemByTCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectReportItemByTCExecute ]
{
	Set RootNode=$List(qHandle,2)
	Kill ^CacheTemp(RootNode)
	Set qHandle=""
	Quit $$$OK
}

/// Creator：      王伟宏
/// CreateDate：   2009-01-12
/// Description:：取得检验项目接收科室列表
/// Table： CT_Department
/// Input： 无
/// Output：RowId：检验项目接受科室RowId，Code:代码，Desc:描述名称
/// Return：无        
/// Others：无
/// d ##Class(%ResultSet).RunQuery("DHCLabToEPR.DHCLabTestSetQuery","SelectLISCTDepartList")
Query SelectLISCTDepartList() As %Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String")
{
}

ClassMethod SelectLISCTDepartListExecute(ByRef qHandle As %Binary) As %Status
{
	Set RootNode=$i(^CacheTemp)
	Set NodeCounter=0   //记录计数

	Set RowId="" For  Set RowId=$Order(^dbo.BTDepartmentD(RowId)) Quit:RowId=""  Do
	.s Code=$lg($g(^dbo.BTDepartmentD(RowId)),2)
	.Set Desc=$lg($g(^dbo.BTDepartmentD(RowId)),3)
	.Set:Desc'="" ^CacheTemp(RootNode,NodeCounter)=$LB(RowId,Code,Desc),NodeCounter=NodeCounter+1
	Set qHandle=$LB(0,RootNode,0)
	Quit $$$OK
}

ClassMethod SelectLISCTDepartListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLISCTDepartListExecute ]
{
	Set AtEnd=$List(qHandle,1)
	Set RootNode=$List(qHandle,2)
	Set CurrNode=$List(qHandle,3)

	if (CurrNode="")||($Data(^CacheTemp(RootNode,CurrNode))=0)
	{   
	    Set AtEnd=1,Row=""
	}
	else
	{    
	     Set NextNode=$Order(^CacheTemp(RootNode,CurrNode))
		 Set qHandle=$LB(0,RootNode,NextNode)
		 Set Row=^CacheTemp(RootNode,CurrNode)
	}
	
	Quit $$$OK
}

ClassMethod SelectLISCTDepartListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLISCTDepartListExecute ]
{
	Set RootNode=$List(qHandle,2)
	Kill ^CacheTemp(RootNode)
	Set qHandle=""
	Quit $$$OK
}

/// Creator：      王伟宏
/// CreateDate：   2009-01-12
/// Description:：取得接收科室下检验套列表
/// Table： CT_TestSet
/// Input： 无
/// Output:检验套RowId，检验套Code，检验套描述Desc
/// Return：无        
/// Others：无
/// d ##Class(%ResultSet).RunQuery("DHCLabToEPR.DHCLabTestSetQuery","SelectLISCTTestsetList","1")
Query SelectLISCTTestsetList(DeprartmentDr As %String) As %Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String")
{
}

ClassMethod SelectLISCTTestsetListExecute(ByRef qHandle As %Binary, DeprartmentDr As %String) As %Status
{
	Set RootNode=$i(^CacheTemp)
	Set NodeCounter=0   //记录计数
	
	If (DeprartmentDr="")||($Data(^dbo.BTWorkGroupI("IndexCode",DeprartmentDr))=0) Set qHandle=$LB(0,RootNode,0) Quit $$$OK
	Set WorkGroupCode="" For  Set WorkGroupCode=$Order(^dbo.BTWorkGroupI("IndexCode",DeprartmentDr,WorkGroupCode)) Quit:WorkGroupCode=""  Do
	.Set WorkGroupDR="" For  Set WorkGroupDR=$Order(^dbo.BTWorkGroupI("IndexCode",DeprartmentDr,WorkGroupCode,WorkGroupDR)) Quit:WorkGroupDR=""  Do
    ..Set WGMCode="" For  Set WGMCode=$Order(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,WGMCode)) Quit:WGMCode=""  Do 
    ...S WorkGroupMachineDR="" For  Set WorkGroupMachineDR=$Order(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,WGMCode,WorkGroupMachineDR)) Quit:WorkGroupMachineDR=""  Do 
    ....S TestSetDR="" f  s TestSetDR=$O(^dbo.BTTestSetWorkGroupMachineI("IndexMaster",TestSetDR)) q:TestSetDR=""  d
    .....s FWGMDR="" f  s FWGMDR=$O(^dbo.BTTestSetWorkGroupMachineI("IndexMaster",TestSetDR,FWGMDR)) q:FWGMDR=""  d
    ......q:FWGMDR'=WorkGroupMachineDR
	......Quit:$Data(^dbo.BTTestSetD(TestSetDR))=0
	......s RowId=TestSetDR
	......s Code=$lg($g(^dbo.BTTestSetD(TestSetDR)),2)
	......Set Desc=$lg($g(^dbo.BTTestSetD(TestSetDR)),3)
	......Set:Desc'="" ^CacheTemp(RootNode,NodeCounter)=$LB(RowId,Code,Desc),NodeCounter=NodeCounter+1
	
	Set qHandle=$LB(0,RootNode,0)
	Quit $$$OK
}

ClassMethod SelectLISCTTestsetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLISCTTestsetListExecute ]
{
	Set AtEnd=$List(qHandle,1)
	Set RootNode=$List(qHandle,2)
	Set CurrNode=$List(qHandle,3)

	if (CurrNode="")||($Data(^CacheTemp(RootNode,CurrNode))=0)
	{   
	    Set AtEnd=1,Row=""
	}
	else
	{    
	     Set NextNode=$Order(^CacheTemp(RootNode,CurrNode))
		 Set qHandle=$LB(0,RootNode,NextNode)
		 Set Row=^CacheTemp(RootNode,CurrNode)
	}
	Quit $$$OK
}

ClassMethod SelectLISCTTestsetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLISCTTestsetListExecute ]
{
	Set RootNode=$List(qHandle,2)
	Kill ^CacheTemp(RootNode)
	Set qHandle=""
	Quit $$$OK
}

/// Creator：      王伟宏
/// CreateDate：   2009-01-12
/// Description:：取得检验套下检验项目列表
/// Table： CT_TestCode，CT_TestCodeTestSet
/// Input： 无
/// Output:检验项目RowId，检验项目Code，检验项目描述
/// Return：无        
/// Others：无
Query SelectLISCTCodeList(CTTestsetDr As %String) As %Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String")
{
}

ClassMethod SelectLISCTCodeListExecute(ByRef qHandle As %Binary, CTTestsetDr As %String) As %Status
{
	Set RootNode=$i(^CacheTemp)
	Set NodeCounter=0   //记录计数
	i '$d(^dbo.BTTestSetLayoutI("IndexMaster",CTTestsetDr)) Set qHandle=$LB(0,RootNode,0) Quit $$$OK
	Set WorkGroupDR="" For  Set WorkGroupDR=$Order(^dbo.BTTestSetLayoutI("IndexMaster",CTTestsetDr,WorkGroupDR)) Quit:WorkGroupDR=""  Do
    .s TestCodeDR=""  For  Set TestCodeDR=$Order(^dbo.BTTestSetLayoutI("IndexMaster",CTTestsetDr,WorkGroupDR,TestCodeDR)) Quit:TestCodeDR=""  Do
  	..s RowId=TestCodeDR
  	..s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
 	..s Code=$lg(TestCodeData,2)
	..s Desc=$lg(TestCodeData,3) 
	..Set:Desc'="" ^CacheTemp(RootNode,NodeCounter)=$LB(RowId,Code,Desc),NodeCounter=NodeCounter+1
	Set qHandle=$LB(0,RootNode,0)
	Quit $$$OK
}

ClassMethod SelectLISCTCodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLISCTCodeListExecute ]
{
	Set AtEnd=$List(qHandle,1)
	Set RootNode=$List(qHandle,2)
	Set CurrNode=$List(qHandle,3)

	if (CurrNode="")||($Data(^CacheTemp(RootNode,CurrNode))=0)
	{   
	    Set AtEnd=1,Row=""
	}
	else
	{    
	     Set NextNode=$Order(^CacheTemp(RootNode,CurrNode))
		 Set qHandle=$LB(0,RootNode,NextNode)
		 Set Row=^CacheTemp(RootNode,CurrNode)
	}
	Quit $$$OK
}

ClassMethod SelectLISCTCodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLISCTCodeListExecute ]
{
	Set RootNode=$List(qHandle,2)
	Kill ^CacheTemp(RootNode)
	Set qHandle=""
	Quit $$$OK
}

/// Creator：      王伟宏
/// CreateDate：   2009-02-23
/// Description:： 根据就诊号EpisodeID,检验套CtTestSetDr,检验项CtTestCodeDr查询患者具体检验套具体某个检验项目的数据
/// Table： CT_TestSet,CT_TestCode
/// Input： 就诊号EpisodeID,检验套CtTestSetDr,检验项CtTestCodeDr
/// Output：TCCode:代码,TCDesc:描述,TCResult:结果,TCUnit:单位,AbnorFlag:异常标记,TCRangs:范围值,TCDate:标本采集日期,TCTime:标本采集时间
/// Return：无        
/// Others：无     
/// d ##Class(%ResultSet).RunQuery("DHCLabToEPR.DHCLabTestSetQuery","GetReportItemByTestCode","52610","7","445")
Query GetReportItemByTestCode(EpisodeID As %String, CtTestSetDr As %String, CtTestCodeDr As %String) As %Query(ROWSPEC = "TCCode:%String,TCDesc:%String,TCResult:%String,TCUnit:%String,AbnorFlag:%String,TCRangs:%String,TCDate:%Date,TCTime:%Time")
{
}

ClassMethod GetReportItemByTestCodeExecute(ByRef qHandle As %Binary, EpisodeID As %String, CtTestSetDr As %String, CtTestCodeDr As %String) As %Status
{
	Set repid=$i(^CacheTemp)
 	Set ind=1
 	
 	Set EpisodeID=$g(EpisodeID),CtTestSetDr=$g(CtTestSetDr), CtTestCodeDr=$g(CtTestCodeDr)
   
 	/*Set OEOrdRowId=""
 	For  Set OEOrdRowId=$O(^OEORD(0,"Adm",EpisodeID,OEOrdRowId)) Quit:OEOrdRowId=""  Do
 	.Set OEORIChildsub=""
 	.For  Set OEORIChildsub=$O(^OEORDi(0,"Abnorm",OEOrdRowId,OEORIChildsub)) Quit:OEORIChildsub=""  Do
 	..Set DataFlag=$Data(^OEORD(OEOrdRowId,"I",OEORIChildsub,3))
 	..b ///11
 	..Quit:(DataFlag'=1)&(DataFlag'=11)
 	..Set OEORIData3=^OEORD(OEOrdRowId,"I",OEORIChildsub,3)
 	..Set TestSet=$Piece(OEORIData3,"^",35)
 	..w TestSet,!
 	..Set VisitNumber=$Piece(OEORIData3,"^",20)
 	..Quit:'$l(TestSetRow)
 	..;Set VisitNumber=$Piece(TestSetRow,"||",1)
 	..;Set TestSet=$Piece(TestSetRow,"||",2)
 	..;Set TestSetCount=$Piece(TestSetRow,"||",3)*/
 	
 	s OrderId=""
 	For  set OrderId=$Order(^OEORD(0,"Adm",EpisodeID,OrderId)) Quit:OrderId=""  Do
	.Set OrderSubId=""  
	.For  set OrderSubId=$Order(^OEORD(OrderId,"I",OrderSubId)) Quit:OrderSubId=""  Do
	..S DataFlag=$Data(^OEORD(OrderId,"I",OrderSubId,1))
	..Q:(DataFlag'=1)&(DataFlag'=11)
	..Set ARCItemMastStr=^OEORD(OrderId,"I",OrderSubId,1)
	..s ItmMastDr=$p(ARCItemMastStr,"^",2)
	..i '$l(ItmMastDr) q
	..i '##Class(web.DHCLabOrder).isLabTS(ItmMastDr) q
	..S OEOrdStatus=$P(ARCItemMastStr,"^",13)
	..Q:OEOrdStatus'=6 //如果不是已经执行的医嘱则退出
	..Set TestSetStr=^OEORD(OrderId,"I",OrderSubId,3)
	..Set ARCIMId=$Piece(ARCItemMastStr,"^",2) Quit:ARCIMId=""
	..Set ItemNameDesc=..GetLabItemNameDesc(ARCIMId) Quit:ItemNameDesc=""
	..Set OrderRowId=OrderId_"||"_OrderSubId
	..Set VisitNumber=$Piece(TestSetStr,"^",20)
	..//20191110 liuzf 统一调整从LIS获取关联
	..s VisitNumberReportDR=$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OrderRowId),""))
	..q:'$l(VisitNumberReportDR)
	..i '$d(^dbo.RPVisitNumberReportD(VisitNumberReportDR)) q  
	..s VisitNumberTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OrderRowId),VisitNumberReportDR,""))
 	..Set (TCDesc, TCResult,TCUnit,AbnorFlag,TCRangs,TCDate)=""
	..s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),2)
	..i VisitNumberDR="" q
	..s RPVisitNumberTestSetDR=$O(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,CtTestSetDr,""))
	..s RPVisitNumberTestSetData=$g(^dbo.RPVisitNumberTestSetD(RPVisitNumberTestSetDR))
	..s WorkGroupMachineDR=$lg(RPVisitNumberTestSetData,5)
	..i '$l(WorkGroupMachineDR) q
	..q:'$d(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR,CtTestCodeDr)) 
	..s ResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR,CtTestCodeDr,"")) 
    ..s TestCodeData=$g(^dbo.BTTestCodeD(CtTestCodeDr))
	..s ItemCode = $lg(TestCodeData,2)
	..s TCDesc=$lg(TestCodeData,3)
	..s Synonym = $lg(TestCodeData,7) //缩写
	..s TCUnit = $lg(TestCodeData,8) //单位
	..s ReportResult=$g(^dbo.RPVisitNumberReportResultD(ResultDR))
	..s OperateType=$lg(ReportResult,32)
 	..i OperateType="D" q //删除的项目剔除
	..s TCResult=$lg(ReportResult,5)
	..s AbnorFlag=$lg(ReportResult,9)
	..s TCRangs = $lg(ReportResult,12) //参考范围
	..s TCDate=$lg(ReportResult,16)
 	..Do OutPut
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPut
	Set Data=$lb(CtTestCodeDr,TCDesc, TCResult,TCUnit,AbnorFlag,TCRangs,TCDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetReportItemByTestCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportItemByTestCodeExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetReportItemByTestCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportItemByTestCodeExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      许琳
/// CreateDate：   2009-06-09
/// Description:： 根据登记号DebtorCode,医嘱项目TCCode代码查询患者的血型信息
/// Table： DEB_Debtor
/// Input： 登记号DebtorCode，医嘱项目代码TCCode
/// Output：BloodCode:血型，Rh:Rh，HIVAb:HIV-Ab，HCVAb:HCV-Ab，HbsAg:HbsAg
/// Return：无        
/// Others：无     、、、
/// d ##Class(%ResultSet).RunQuery("DHCLabToEPR.DHCLabTestSetQuery","GetBloodItemByDebtorCode","52610","L0001")
Query GetBloodItemByDebtorCode(ADMID As %String, TCCode As %String) As %Query(ROWSPEC = "ItemResult:%String,ItemDate:%String,ItemTime:%String")
{
}

ClassMethod GetBloodItemByDebtorCodeExecute(ByRef qHandle As %Binary, ADMID As %String, TCCode As %String) As %Status
{
	
	
	Set RootNode=$i(^CacheTemp) 		//记录集的根节点
	Set NodeCounter=0       						//统计记录数，同时为子节点
 	Set OrderInfo=""    //保存一条记录
	Set OrderId="" 
	For  set OrderId=$Order(^OEORD(0,"Adm",ADMID,OrderId)) Quit:OrderId=""  Do
	.Set OEOrdDate=$P(^OEORD(OrderId),"^",2)
	.//Quit:$$CheckDate()'=1   //判断医嘱时间是否在查询的时间段中
	.Set OrderSubId=""  
	.For  set OrderSubId=$Order(^OEORD(OrderId,"I",OrderSubId)) Quit:OrderSubId=""  Do
	..S DataFlag=$Data(^OEORD(OrderId,"I",OrderSubId,1))
	..Q:(DataFlag'=1)&(DataFlag'=11)
	..Set ARCItemMastStr=^OEORD(OrderId,"I",OrderSubId,1)
	..s ItmMastDr=$p(ARCItemMastStr,"^",2)
	..i '$l(ItmMastDr) q
	..i '##Class(web.DHCLabOrder).isLabTS(ItmMastDr) q
	..S OEOrdStatus=$P(ARCItemMastStr,"^",13)
	..Q:OEOrdStatus'=6 //如果不是已经执行的医嘱则退出
	..Set TestSetStr=^OEORD(OrderId,"I",OrderSubId,3)
	..Set ARCIMId=$Piece(ARCItemMastStr,"^",2) Quit:ARCIMId=""
	..Set ItemNameDesc=..GetLabItemNameDesc(ARCIMId) Quit:ItemNameDesc=""
	..Set OrderRowId=OrderId_"||"_OrderSubId
	..Set LabNo=$Piece(TestSetStr,"^",20)
	..q:'$l(LabNo)
	..//20191110 liuzf 统一调整从LIS获取关联
	..s VisitNumberReportDR=$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OrderRowId),""))
	..q:'$l(VisitNumberReportDR) 
	..i '$d(^dbo.RPVisitNumberReportD(VisitNumberReportDR)) q 
	..s VisitNumberTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexHISOrderID",##Class(LIS.Util.Common).IndexData(OrderRowId),VisitNumberReportDR,""))
	..Set (SpeDesc,CollectDate,CollectTime,RecDate,RecTime,AuthorDate,AuthorTime,ExistReport)=""
	..I $l(VisitNumberTestSetDR) D  
	...s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),2)
	...i VisitNumberDR="" q
	...s VisitNumberData=$G(^dbo.RPVisitNumberD(VisitNumberDR))
	...s SpecimenDR=$lg(VisitNumberData,56) s SpeDesc=""
	...i $l(SpecimenDR)  s SpeDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	...s CollectDate=$lg(VisitNumberData,51)
	...s CollectTime=$lg(VisitNumberData,52)
	...s RecDate=$lg(VisitNumberData,66)
	...s RecTime=$lg(VisitNumberData,67)
	...s WorkGroupMachineDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,""))
	...i '$l(WorkGroupMachineDR) s AuthorDate="" s AuthorTime=""
	...s HOSDR=$O(^dbo.BTTestCodeI("IndexCode",""))
	...Q:'$L(HOSDR)
	...s TestCodeDR=$O(^dbo.BTTestCodeI("IndexCode",HOSDR,##Class(LIS.Util.Common).IndexData(TCCode),"")) 
    ...Q:'$L(TestCodeDR)
	...q:'$d(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR,TestCodeDR))
	...s ResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR,TestCodeDR,"")) 
    ...s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
	...s ItemCode = $lg(TestCodeData,2)
	...s ItemDesc=$lg(TestCodeData,3)
	...s Synonym = $lg(TestCodeData,7) //缩写
	...s ItemUnit = $lg(TestCodeData,8) //单位
	...s ReportResult=$g(^dbo.RPVisitNumberReportResultD(ResultDR))
	...s OperateType=$lg(ReportResult,32)
 	...i OperateType="D" q //删除的项目剔除
	...s ItemResult=$lg(ReportResult,5)
	...s ItemDate=$lg(ReportResult,16)
	...s ItemTime=$lg(ReportResult,17)
	...Set ^CacheTemp(RootNode,NodeCounter)=$LB(ItemResult,ItemDate,ItemTime)
	...Set NodeCounter=NodeCounter+1
	Set qHandle=$LB(0,RootNode,0)
	
	Quit $$$OK
	
	
	
	//根据就诊号EpisodeID,医嘱项目TCCode代码获得患者的项目结果信息
	/*Set RootNode=$increment(^CacheTemp)
	Set (OrderId,OrderSubId,LabNoStr,DebtorCode,CollectDate,CollectTime)=""  //医嘱日期,医嘱时间,标本号
	Set NodeCounter=0   //记录计数
	For  set OrderId=$Order(^OEORD(0,"Adm",ADMID,OrderId)) Quit:OrderId=""  Do       //根据ADM号获取标本号和登记号
	.For  set OrderSubId=$Order(^OEORD(OrderId,"I",OrderSubId)) Quit:OrderSubId=""  Do
	..Set DataFlag=$DATA(^OEORD(OrderId,"I",OrderSubId,3))
	..QUIT:(DataFlag'=1)&(DataFlag'=11)
	..Set TestSetStr=^OEORD(OrderId,"I",OrderSubId,3)
	..Set LabNoStr=$Piece(TestSetStr,"^",35)
	..Set ARCItemMastStr=^OEORD(OrderId,"I",OrderSubId,1)
	..set ItmMastDr=$piece(ARCItemMastStr,"^",2)
	..if '$length(ItmMastDr) quit
	..if '##Class(web.DHCLabOrder).isLabTS(ItmMastDr) quit
	..If ($length(LabNoStr)'="")&(LabNoStr["||") Do
	...Set LabNo=$piece(LabNoStr,"||",1),TSCode=$piece(LabNoStr,"||",2)
	..else  set (TSCode,LabNo)=""
	..If LabNo="" Quit
	..Set EpisRowId=$piece(^PAADM(ADMID),"^",1)
	..Set DebtorCode=$Piece(^PAPER(EpisRowId,"PAT",1),"^",1)
	..Set EpisodeID=""
	..//b ;001   
	..For  Set CollectDate=$Order(^TDHCOldResult(1,DebtorCode,TCCode,CollectDate)) Quit:CollectDate=""  do
	...set ItemDate=$ZDATE(CollectDate,3)
	...For  set CollectTime=$Order(^TDHCOldResult(1,DebtorCode,TCCode,CollectDate,CollectTime)) Quit:CollectTime=""  do  
	....set ItemTime=$ZTIME(CollectTime*60,2)
	....For  Set EpisodeID=$Order(^TDHCOldResult(1,DebtorCode,TCCode,CollectDate,CollectTime,EpisodeID)) Quit:EpisodeID=""  do
	.....If EpisodeID'=LabNo Quit
	.....Set (TestSet,TestSetCounter)=""
	.....For  Set TestSet=$Order(^TDHCOldResult(1,DebtorCode,TCCode,CollectDate,CollectTime,EpisodeID,TestSet)) Quit:TestSet=""  do
	......If TSCode'=TestSet Quit
	......For  set TestSetCounter=$Order(^TDHCOldResult(1,DebtorCode,TCCode,CollectDate,CollectTime,EpisodeID,TestSet,TestSetCounter))  Quit:TestSetCounter=""  do
	.......SET DataFlag=$Data(^TEPI(EpisodeID,1,TestSet,TestSetCounter,"DATA",TCCode))
	.......QUIT:(DataFlag'=1)&(DataFlag'=11)
	.......Set resstr=$Piece(^TEPI(EpisodeID,1,TestSet,TestSetCounter,"DATA",TCCode),"\",1)
	.......Set temres=..GetTestCodeResult(EpisodeID,TCCode,resstr)
	.......Set ItemDesc=$Piece(temres,$Char(2),2) //检验项目描述
	.......Set ItemResult=$Piece(temres,$Char(2),3)  //结果
	......//Set ResultFormat=$Piece(^TTAB("TC",CtTestCodeDr),"\",3) //检验项目结果值的类型格式
	......Set ^CacheTemp(RootNode,NodeCounter)=$LISTBUILD(ItemResult,ItemDate,ItemTime)
	......Set NodeCounter=NodeCounter+1
	Set qHandle=$LISTBUILD(0,RootNode,0)
	
	Quit $$$OK */
}

ClassMethod GetBloodItemByDebtorCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectReportItemByTCExecute ]
{
	Set AtEnd=$List(qHandle,1)
	Set RootNode=$List(qHandle,2)
	Set CurrNode=$List(qHandle,3)

	if (CurrNode="")||($Data(^CacheTemp(RootNode,CurrNode))=0)
	{   
	    Set AtEnd=1,Row=""
	}
	else
	{  
	     Set NextNode=$Order(^CacheTemp(RootNode,CurrNode))
		 Set qHandle=$LB(0,RootNode,NextNode)
		 Set Row=^CacheTemp(RootNode,CurrNode)
	}
	Quit $$$OK
}

ClassMethod GetBloodItemByDebtorCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectReportItemByTCExecute ]
{
	Set RootNode=$List(qHandle,2)
	Kill ^CacheTemp(RootNode)
	Set qHandle=""
	Quit $$$OK
}

/// 获取检验项目的异常标记
/// TestCode:检验项代码，TCResult:检验结果，TCRanges：检验项范围值（默认为空）
/// [Previously private]
ClassMethod GetAbnorFlag(TestCode As %String, TCResult As %String, TCRanges As %String = "") As %String
{
	Set FormatFlag=""
	//Set currNS=$znspace
	Set:$Data(^TTAB("TC",TestCode))'=0 FormatFlag=$Piece(^TTAB("TC",TestCode),"\",3)
	Quit:FormatFlag=""!TCResult=""!TestCode="" ""
	Set:TCRanges="" PType="0",TCRanges=..GetTCRanges(TestCode, "","", "", PType, "", "", "", "1","")
	Set:'$l(TCRanges) TCRanges=..GetMultiScope(TestCode)
	Set AbnorFlag=$Select(FormatFlag["N":$$GetAbnorFlagByNum(TCResult,TCRanges),FormatFlag["S":$$GetAbnorFlagByStCommen(TestCode,TCResult),FormatFlag["X":$$GetAbnorFlagByFreeText(TestCode,TCResult),1:"")
	//Set $znspace=currNS
	Quit AbnorFlag
	
	 ;数据型
GetAbnorFlagByNum(TCResult,TCRanges)
	s TCResult=$g(TCResult),TCRanges=$g(TCRanges)
	s (retvalue,retranges,retcolor)=""
	s retflag="N",lowflag="L",highflag="H"
	s reslow=$p(TCRanges,$c(1),1),reshigh=$p(TCRanges,$c(1),2)
	;panic unaccept
	s resPaniclow=$p(TCRanges,$c(1),3),resPanichigh=$p(TCRanges,$c(1),4)
	s resUnAcceptlow=$p(TCRanges,$c(1),9),resUnAccepthigh=$p(TCRanges,$c(1),10)
	;i TCRanges="" q ""
	i $l(TCRanges,$c(10))>1 q retvalue_$c(28)_retflag
	Set TCResult=$tr(TCResult,"><")
	;
	/*
	Set $znspace="LABDATA"
	Set lowflag=$p(^CF("LAB",1),"^",18),highflag=$p(^CF("LAB",1),"^",19)
	s rangsta=$p(^CF("LAB",1),"^",16),rangend=$p(^CF("LAB",1),"^",17)
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    s iBelowBColor=$P(^CF("LAB",1,"COLOUR",12),"^",1)
    s iBelowFcolor=$P(^CF("LAB",1,"COLOUR",12),"^",2)
    ;
    s iUnAcceptBColor=$P(^CF("LAB",1,"COLOUR",2),"^",1)
    s iUnAcceptFColor=$P(^CF("LAB",1,"COLOUR",2),"^",2)
    s iPanicColor=$P($tr(^CF("LAB",1,"COLOUR",15),$c(13,10)),"^",11)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    i TCRanges="" q retvalue_$c(28)_retranges_$c(28)_retcolor_$c(28)_retflag
	 
	i TCRanges="" q retvalue_$c(28)_retflag
	
	;---------add 20070914  修改范围值的显示
	i reslow="",reshigh="" d 
	.s retranges="" 
	i "<>"[$e(reslow) d ;($e(reslow,1)="<")!($e(reslow,1)=">") d
	.s retranges=rangsta_reslow_rangend
	e  d
	.s retranges=rangsta_reslow_"-"_reshigh_rangend
	;-----------
	*/
	i TCRanges="" q retvalue_$c(28)_retflag
	i '$ISVALIDNUM(TCResult) q retvalue_$c(28)_retflag
	;UnAccept check
	s rang=resUnAcceptlow_resUnAccepthigh
	i $l(rang) d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<resUnAcceptlow s retvalue=lowflag,retflag="U" q
	..i TCResult>resUnAccepthigh s retvalue=highflag,retflag="U" q
	.i (rang["<") d
	..s lowvalue=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowvalue s retvalue=highflag,retflag="U" q
	.i (rang["<") d
	..s highvlaue=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highvlaue s retvalue=lowflag,retflag="U" q
	;Panic check
	s rang=resPaniclow_resPanichigh
	i $l(rang),retflag="N" d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<resPaniclow s retvalue=lowflag,retflag="M" q
	..i TCResult>resPanichigh s retvalue=highflag,retflag="M" q
	.i (rang["<") d
	..s lowvalue=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowvalue s retvalue=highflag,retflag="M" q
	.i (rang[">") d
	..s highvlaue=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highvlaue s retvalue=lowflag,retflag="M" q
	;normal check
	s rang=reslow_reshigh
	i $l(rang),retflag="N" d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<reslow s retvalue=lowflag,retflag="L" q
	..i TCResult>reshigh s retvalue=highflag,retflag="H" q
	.i (rang["<") d
	..s lowflag=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowflag s retvalue=highflag,retflag="H" 
	.i (rang[">") d
	..s highflag=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highflag s retvalue=lowflag,retflag="L"	
	q retvalue_$c(28)_retflag
	//q retflag
	
	;标准备注型	
GetAbnorFlagByStCommen(TestCode,TCResult)
	Set TestCode=$g(TestCode),TCResult=$g(TCResult)
	i '$l(TCResult) q $c(28,28,28)
	;
	/*
	Set $znspace="LABDATA"
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    */
    s retflag="N",retvalue=""
    ;s retvalue=TCResult
    ;s ^aareflag=TestCode_":"_TCResult
    i $d(^TTAB("TC",TestCode,2,TCResult)) d
    .s retflag=$p(^TTAB("TC",TestCode,2,TCResult),"\",1)
    .i retflag="A" s retvalue="*"
    q retvalue_$c(28)_retflag
    //q retflag
    
	;文本类型
GetAbnorFlagByFreeText(TestCode,TCResult)
	Set TestCode=$g(TestCode),TCResult=$g(TCResult)
	;
	/*
	Set $znspace="LABDATA"
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    */
    s retflag="N",retvalue=""
    ;s retvalue=TCResult
    s temstr=""
    s std="" f  s std=$o(^TTAB("TC",TestCode,2,std)) q:std=""  d
    .i $p(^TTAB("TC",TestCode,2,std),"\",1)="A" d
    ..i $d(^TTAB("TC",TestCode,2,std,1)),TCResult[$g(^TTAB("TC",TestCode,2,std,1)) ,retvalue="*",retflag="A"
    q retvalue_$c(28)_retflag
    // q retflag
    
res(rang) ; check < >
 i rang[">" s rang=$tr(rang,">")+.00000001
 i rang["<" s rang=$tr(rang,"<")-.00000001
 q rang
}

/// 获取项目的范围值
/// TestCode:项目代码,Age:年龄,Species:性别,Pregn:怀孕(0),PatientType:病人类型(0\0-IN),Date:日期,Cond:临床条件(0),Loc:0,mi:1\2,Weeks:周(0)
/// [Previously private]
ClassMethod GetTCRanges(TestCode As %String, Age As %Integer = "", Species As %String = "", Pregn As %String = "", PatientType As %String = "0", Date As %String = "", Cond As %String = "", Loc As %String = "", mi As %String = "1", Weeks As %Integer = "") As %String
{
 Set (j,x,xf,age0,type,exist,result,format)=""
 Set result=""
 Set tc=$g(TestCode),age=$g(Age),spec=$g(Species),pregn=$g(Pregn),ptype=$g(PatientType),date=$g(Date),cond=$g(Cond),loc=$g(Loc),mi=$g(mi),weeks=$g(Weeks)
 ;
 If '$l(age) Set age=0
 If '$l(spec) Set spec="M"
 ;;
 Set format=$p($g(^TTAB("TC",tc)),"\",3)
 i '$l(date) s date=+$h
 i '$d(^TTAB("TC",tc,4,date)) s date=$o(^TTAB("TC",tc,4,date),-1)
 i $l(date) d
 .For type=ptype,$e(ptype) i $d(^TTAB("TC",tc,4,date,type)) d  q
 ..k xf s x="" f  s x=$o(^TTAB("TC",tc,4,date,type,x)) q:x=""  d
 ...i $l($p(^(x),"\",23)),'$l(age) q
 ...i $l($p(^(x),"\",23)),$l($p(^(x),"\",23),"-")'>1 Set $p(^(x),"\",23)="0-"_$p(^(x),"\",23) //如果年龄只有最大值，则改为“0-最大值”的格式
 ...i $l($p(^(x),"\",23)),age<$p($p(^(x),"\",23),"-",1) q
 ...i $l($p(^(x),"\",23)),age>$p($p(^(x),"\",23),"-",2) q
 ...i $l($p(^(x),"\",22)),$p(^(x),"\",22)'=spec q
 ...i $l($p(^(x),"\",21)),$p(^(x),"\",21)'=cond q
 ...i $l($p(^(x),"\",24)),$p(^(x),"\",24)'=loc q
 ...i $l($p(^(x),"\",25)),'$l(age) q
 ...i $l($p(^(x),"\",25)),weeks<$p($p(^(x),"\",25),"-",1) q
 ...i $l($p(^(x),"\",25)),weeks>$p($p(^(x),"\",25),"-",2) q
 ...s xf=(''$l($p(^(x),"\",21)))+(''$l($p(^(x),"\",22)))+(''$l($p(^(x),"\",23)))+(''$l($p(^(x),"\",24)))+(''$l($p(^(x),"\",25))),xf(xf,x)=^(x)
 ..s xf=$o(xf(""),-1) i $l(xf) s x=$o(xf(xf,"")) i $l(x) d
 ...s (aaLow,aaHigh,aaPLow,aaPHigh)=""
 ...//i $l(mi) s rowid=tc_"||"_date_"||"_type_"||"_x_"||"_mi i '$$select^LVBCTTCG(rowid) d
 ...//.s aaLow=PLIST(3),aaHigh=PLIST(4),aaPLow=PLIST(5),aaPHigh=PLIST(6)
 ...i $l(mi) d Select 
 ...s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
 ...i $l(aaLow)!$l(aaHigh) s $p(xx,"\",3)=aaLow,$p(xx,"\",4)=aaHigh
 ...i pregn["Y" s xx=$p(xf(xf,x),"\",9,16)_"\"_$p(xf(xf,x),"\",19,20) d
 ....s exist="" f j=1:1:10 i $l($p(xx,"\",j)) s exist=1 q
 ....i 'exist d
 .....s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
 .....i $l(aaPLow)!$l(aaPHigh) s $p(xx,"\",3)=aaPLow,$p(xx,"\",4)=aaPHigh
 ...s result=$p(xx,"\",1)_$c(1)_$p(xx,"\",2)_$c(1)_$p(xx,"\",5)_$c(1)_$p(xx,"\",6)_$c(1)_$p(xx,"\",7)_$c(1)_$p(xx,"\",8)_$c(1)_$p(xx,"\",3)_$c(1)_$p(xx,"\",4)_$c(1)_$p(xx,"\",9)_$c(1)_$p(xx,"\",10)
 For j=1:1:$l(result,$c(1)) s x=$p(result,$c(1),j) i $l(x) d
 .i ($e(x)="<")!($e(x)=">") d  q
 ..s $p(result,$c(1),j)=$e(x)_$j($e(x,2,$l(x)),0,$e(format,2,4))
 ..i $e(x,2)="." s $p(result,$c(1),j)=$e(x)_0_$e(x,2,$l(x))
 .s $p(result,$c(1),j)=$j(x,0,$e(format,2,4))
 .i $e($p(result,$c(1),j))="." s $p(result,$c(1),j)=0_$p(result,$c(1),j)
  //w !,"@Debug Start-------------------------------------",!
  //w "result:"_result
  //w !,"@Debug End---------------------------------------",!
 Quit result
 
Select
 set tc=$g(tc),date=$g(date), type=$g(type),x=$g(x),mi=$g(mi),ValDeli="\"
 If $Data(^TTAB("TC",tc,4,date,type,x,mi))=0 Quit
 Set rangesAAStr=^TTAB("TC",tc,4,date,type,x,mi)
 Set aaLow=$Piece(rangesAAStr,ValDeli,1)
 Set aaHigh=$Piece(rangesAAStr,ValDeli,2)
 Set aaPLow=$Piece(rangesAAStr,ValDeli,3)
 Set aaPHigh=$Piece(rangesAAStr,ValDeli,4)
 Quit
}

/// 检验项目结果多范围值的获取
/// [Previously private]
ClassMethod GetMultiScope(ItemCode, LabNo, date) As %String
{
   
   ;先判断有没有临床条件?若有临床条件则不需要返回多范围了
   s ItemCode=$g(ItemCode),LabNo=$g(LabNo),date=$g(date)
   ;s conditions=""    ?????  Liuzf-20090422
   ;s conditions=$P($g(^TEPI(LabNo,0)),"\",17)  ???? Liuzf-20090422
   ;i conditions'="" q ""        ???? Liuzf-20090422
   s Scopy=""
   i '$l(date) s date=+$h
   i '$d(^TTAB("TC",ItemCode,4,date)) s date=$o(^TTAB("TC",ItemCode,4,date),-1)
   i $l(date) d
   .s num=1
   .s ord="" f  s ord=$o(^TTAB("TC",ItemCode,4,date,0,ord)) q:ord=""  d
   ..i $p(^TTAB("TC",ItemCode,4,date,0,ord),"\",21)'="" d
   ...s clc=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",21)
   ...s temL=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",1)
   ...s temH=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",2)
   ...i $l(temH) s temrange=^TTAB("CLC",clc)_"("_$j(temL,3,2)_"-"_$j(temH,3,2)_")"
   ...i '$l(temH) s temrange=^TTAB("CLC",clc)_"("_temL_")"
   ...;s temrange=^TTAB("CLC",clc)_"("_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",1),3,2)_"-"_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",2),3,2)_")"
   ...i (num#2)=0 d
   ....s Scopy=Scopy_temrange_$c(10,13)
   ...e  d
   ....s Scopy=Scopy_temrange_$c(32)
   ...s num=num+1
   q Scopy
}

/// 根据日期获取检验项目的单位 //$$Units^DHCCTTCU(TC,recdate) ;
/// [Previously private]
ClassMethod GetTCUnitByDate(tc, date) As %String
{
  ;table CT_TestCodePrevUnits
  s tc=$g(tc),date=$g(date)
  i '$l(tc) q ""
  i '$l(date) s date=+$h
  s date=date+1
  s last=$o(^TTAB("TC",tc,6,""),-1)
  q:($Data(^TTAB("TC",tc))'=1)&($Data(^TTAB("TC",tc))'=11) ""
  s unit=$p(^TTAB("TC",tc),"\",2)
  i date>last s last="" q unit
  i $d(^TTAB("TC",tc,6,date)) q $p(^TTAB("TC",tc,6,date),"\",1) 
  s last=date s last=$o(^TTAB("TC",tc,6,last)) ; q:(last<date)!(last="")
  ;i last="" s last=$o(^TTAB("TC",tc,6,""))
  q $p(^TTAB("TC",tc,6,last),"\",1)
}

/// //入参就诊号AdmNo
/// 判断是否含可打印报告
ClassMethod GetIsContainLisReport(AdmNo) As %String
{

    s quitflag=0
    s RequestDate="" f  s RequestDate=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),RequestDate))  q:((RequestDate="")||(quitflag=1))  d
    .s VisitNumberDR="" f  s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),RequestDate,VisitNumberDR))  q:((VisitNumberDR="")||(quitflag=1))  d
    ..s WorkGroupMachineDR="" f  s WorkGroupMachineDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR)) q:((WorkGroupMachineDR="")||(quitflag=1))  d
    ...s OrderNo="" f  s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo)) q:((OrderNo="")||(quitflag=1))  d
    ....s ReportDR=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,"")) 
    ....i $lG($g(^dbo.RPVisitNumberReportD(ReportDR)),22)=3 s quitflag=1 q
    q quitflag
}

/*
ClassMethod GetTestCodeResult(LabNo As %String, TC As %String, Result As %String) As %String
{
	
	
	     
	If '$Data(^TTAB("TC",TC)) Quit retvalue
	Set itmname=$Piece(^TTAB("TC",TC),"\",1)
	Set itmdate=$P(^TEPI(LabNo),"\",10)
	//---------------------------------->Add wwh 2009-06-01
	//英文缩写
	Set Synonym=$Piece(^TTAB("TC",TC),"\",12)
	//-----------------------------------<
	Set itmunits=..GetTCUnitByDate(TC,itmdate) 
	Set itmtype=$Piece(^TTAB("TC",TC),"\",3)
	Set $Piece(retvalue,$Char(2),1)=TC
	Set $Piece(retvalue,$Char(2),2)=itmname
	Set itmres=Result
	If itmtype="V" {  //Micro Pathogen||V 微生物
		Set itemres=Result
		If $Data(^TTAB("BUG",Result)) Set $Piece(retvalue,$c(2),3)=$Piece(^TTAB("BUG",Result),"\",1)
	}
	If itmtype["N" { //??
		Set decimal=$Extract(itmtype,2)
		If decimal="" Set decimal="0"
		Set itmres=$$CheckResDecimal(Result,decimal)
	}
	///
	If itmtype["S",$Data(^TTAB("TC",TC,2,Result,1)){  //Standard Comment标准意见
		Set itmres=$Piece(^TTAB("TC",TC,2,Result,1),"\",1)
	}
	;血型结果
	If (itmtype="B2"),$l(itmres),$Data(^TTAB("BB-BG",itmres)){
		Set itmres=$Piece(^TTAB("BB-BG",Result),"\",1)
	}
	///异常标志
	Set ResFlag=..GetAbnorFlag(TC ,Result)
	///参考范围
	//Set RefRanges=..GetTCRanges(TC)
	
	s spec=$p(^TEPI(LabNo),"\",3)
	s age=$p(^TEPI(LabNo),"\",25)
	s ptype="0" ;$p(^TEPI(labno),"\",48)
	s cond=$p(^TEPI(LabNo,0),"\",17)
	s (pregn,loc,mi,weeks)=""
	s date=itmdate
	i '$l(date) s date=+$h
	Set RefRanges=..GetTCRanges(TC,age,spec,pregn,ptype,date,cond,loc,mi,weeks)
	//--------------------->wwh 参考范围高低值之间用“~”分隔
	Set RefRanges=$tr(RefRanges,$C(1),"~")
	//---------------------<
	Set:'$l(RefRanges) RefRanges=..GetMultiScope(TC)
	Set $Piece(retvalue,$Char(2),3)=$TRanslate(itmres,$Char(13,10),"")
	
	If itmtype="V" {  //Micro Pathogen||V 微生物
		Set itemres=Result
		If $Data(^TTAB("BUG",Result)) Set $Piece(retvalue,$c(2),3)=$Piece(^TTAB("BUG",Result),"\",1)
	}
	Set $Piece(retvalue,$Char(2),4)=itmunits
	Set $Piece(retvalue,$Char(2),5)=ResFlag
	Set $Piece(retvalue,$Char(2),6)=RefRanges
	Set $Piece(retvalue,$Char(2),7)=Synonym
	Quit retvalue
	
CheckResDecimal(res,dec)
	Set res=$Get(res),dec=+$Get(dec)
	Set ret=""
	If res="" Quit ret
	If dec="" Quit ret
	Set flag=""
	If ($Extract(res)="<")!($Extract(res)=">") s flag=$Extract(res),res=$TRanslate(res,"<>")
	//20121019 wangwentao update
	Set res=$tr(res," ")
	//20121019 update end
	Set res=+res
	Set ret=$fn(res,"",dec)
	Quit flag_ret
}
*/
/// 获取检验项目的描述，结果，单位，异常值，参考范围信息，英文缩写
/// [Previously private]
/// 获得检验项目的类别
/// [Previously private]
ClassMethod GetItemOrderType(ItemCatId As %String) As %String
{
	s OrderTypeStr=^ARC("IC",ItemCatId) Quit:OrderTypeStr="" ""
	s OrderType=$P(OrderTypeStr,"^",7)	Quit:OrderType="" ""
	Quit OrderType
}

/// 获得检验项目的名称
/// [Previously private]
ClassMethod GetLabItemNameDesc(ARCIMId As %String) As %String
{
	Quit:ARCIMId'["||" ""
	Set ItemId=$P(ARCIMId,"||",1) Quit:ItemId="" ""
	Set ItemSub=$P(ARCIMId,"||",2) Quit:ItemSub="" ""
	Set ItemCatId=$Piece(^ARCIM(ItemId,ItemSub,1),"^",10) Quit:ItemCatId="" ""
	Quit:..GetItemOrderType(ItemCatId)'="L" ""
	Set ItemDesc=$Piece(^ARCIM(ItemId,ItemSub,1),"^",2)
	Quit ItemDesc
}

/// 获得医嘱项目对应的检验医嘱关联代码TestSetCode
/// [Previously private]
ClassMethod GetExtTestSetCode(ARCIMId As %String) As %String
{
	Quit:ARCIMId'["||" ""
	Set ItemId=$P(ARCIMId,"||",1) Quit:ItemId="" ""
	Set ItemSub=$P(ARCIMId,"||",2) Quit:ItemSub="" ""
	Set:$Data(^ARCIM(ItemId,ItemSub,"EXT",1)) ItemExternalCodesStr=^ARCIM(ItemId,ItemSub,"EXT",1)
	Set TestSetCode=""
	Set:ItemExternalCodesStr'="" TestSetCode=$Piece(ItemExternalCodesStr,"^",4)
	Quit TestSetCode
}

/// 根据标本代码获取标本名称描述
/// [Previously private]
ClassMethod GetSpecimenDesc(SpecCode As %String) As %String
{
	S SpecDesc=""
	Q:'$l(SpecCode) SpecDesc
	s HospitalDR=$O(^dbo.BTSpecimenI("IndexCode",""))
	Q:'$l(HospitalDR) SpecDesc
	s SpecimenDR=$O(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode,""))
	Q:'$l(SpecimenDR) SpecDesc
	s SpecDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	Q SpecDesc
}

/// Desc:	获取某一就诊过程中做过的指定检验医嘱rowid（做过多次，取最后的一次）
/// Input：	AEpisodeID 就诊指针
/// 		ATestARCID 指定的检验医嘱rowid
/// 		ANeedReport 是否需要检验报告，1 需要，0 不需要
/// Output:	医嘱rowid
ClassMethod GetLastestTestOrderID(AEpisodeID As %String, ATestARCID As %String, ANeedReport As %Boolean) As %String
{
	s retOrderID = ""
	
	Set OrderId="" 
	For  {
		set OrderId=$Order(^OEORD(0,"Adm",AEpisodeID,OrderId),-1) 		//按OrderId倒序
		Quit:(OrderId="")  
		Quit:(QuitFlag="True")
				
		Set OrderSubId=""  
		For  {
			set OrderSubId=$Order(^OEORD(OrderId,"I",OrderSubId),-1) 	//按OrderSubId倒序
			Quit:(OrderSubId="")
			Quit:(QuitFlag="True")  
			
			s totOrderID=OrderId_"||"_OrderSubId
			
			S DataFlag=$Data(^OEORD(OrderId,"I",OrderSubId,1))
			if (DataFlag'=1)&(DataFlag'=11) continue
	
			Set ARCItemMastStr=^OEORD(OrderId,"I",OrderSubId,1)
			S OEOrdStatus=$P(ARCItemMastStr,"^",13)
			if OEOrdStatus'=6 continue 									//如果不是已经执行的医嘱则退出
	

			Set ARCIMId=$Piece(ARCItemMastStr,"^",2) 
			if ARCIMId="" continue
			
			if (ATestARCID '= "")
			{
				continue:($find("^"_ATestARCID_"^",ARCIMId)=0)		//是否指定的检查医嘱
			}
			
			//Set ItemNameDesc=..GetLabItemNameDesc(ARCIMId) 
			//if ItemNameDesc="" continue
			if (ANeedReport = "1")
			{
				Set TestSetStr=^OEORD(OrderId,"I",OrderSubId,3)
				Set LabNo=$Piece(TestSetStr,"^",20)
				Set TSRowID=$Piece(TestSetStr,"^",35)
				Set TSRowID=$tr(TSRowID,$c(0))
				if '$L(TSRowID) continue
			 
				;Set DataFlag=$DATA(^TEPI($P(TSRowID,"||",1),1,$P(TSRowID,"||",2),$P(TSRowID,"||",3)))
				;if (DataFlag'=1)&(DataFlag'=11) continue
			}
			
			Set retOrderID=OrderId_"||"_OrderSubId
			set QuitFlag="1"
		}
	}
	
	q retOrderID
}

}
