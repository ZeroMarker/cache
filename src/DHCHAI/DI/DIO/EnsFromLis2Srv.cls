/// 名称: DHCHAI.DI.DIO.EnsFromLis2Srv
/// 描述: 东华数据中心--检验结果接口服务
/// 编写者：zhufei
/// 编写日期: 2020-03-31
Class DHCHAI.DI.DIO.EnsFromLis2Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      zhufei
/// CreateDate：   2020-03-31
/// Description:   根据就诊号查询医嘱及检验结果信息
/// Table：        OE_Order、OE_OrdItm、Ens_LISReportResult、Ens_LISItemResult...
/// Input：        EpisodeID ：就诊号
///                Begdate   : 开始时间（医嘱）
///                EndDate   : 结束时间（医嘱）
/// Output：       ROWSPEC = ...
/// Others：       日期格式为数据库默认的存储格式，如果时间未指定查询所有
/// d ##Class(%ResultSet).RunQuery("DHCHAI.DI.DIO.EnsFromLis2Srv","SelectLISItemListByDate","25","","")
Query SelectLISItemListByDate(aEpisodeID As %String, aDateFrom As %Date = 0, aDateTo As %Date = 0) As %Query(ROWSPEC = "EpisodeID:%String,VisitNumberReportDR:%String,Order:%String,LabEpisodeNo:%String,TestSetRow:%String,RepStatus:%String,ExistReport:%String,OEordItemRowID:%String,OEordItemDesc:%String,TestSetStr:%String,SpecimenCode:%String,SpecimenDesc:%String,CollectionDate:%String,CollectionTime:%String,CollectUserCode:%String,CollectUserName:%String,ReceiveDate:%String,ReceiveTime:%String,ReceiveUserCode:%String,ReceiveUserName:%String,AuthorisationDate:%String,AuthorisationTime:%String,AuthUserCode:%String,AuthUserName:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserName:%String,ReqDate:%String,ReqTime:%String,LocCode:%String,LocDesc:%String,WardCode:%String,WardDesc:%String,MajorConclusion:%String,ReqNotes:%String")
{
}

ClassMethod SelectLISItemListByDateExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %Date = 0, aDateTo As %Date = 0) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aEpisodeID="" $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	//Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set xReportDr=0
	For {
		Set xReportDr=$o(^Busi.ENS.EnsLISReportResultI("LISRRVisitNumberIndex",aEpisodeID,xReportDr))
		Quit:xReportDr=""
		
		Set RecDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),65)
		Set AuthorDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),107)
		Continue:(aDateFrom'="")&&((RecDate<aDateFrom)&&(AuthorDate<aDateFrom))
		Continue:(aDateTo'="")&&((RecDate>aDateTo)&&(AuthorDate>aDateTo))
		
		Set ReportID=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),2) // 报告号
		Set Order=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),122)
		Set:Order="" Order=1   //add 20201109 解决第三方检验无此项目导致同步无法保存内容修改
		//标本号、医嘱ID、医嘱信息（检验代码+检验名称+医嘱代码+医嘱名称）
		Set LabNo=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_ReportID,""))
		Set (OEItemID,TestSetStr,ArcimCode,ArcimDesc)=""
		If LabNo'="" {
			Set xOEItemID=0
			For {
				Set xOEItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_ReportID,LabNo,xOEItemID))
		        Quit:xOEItemID=""
		        Set OEItemID = xOEItemID
				If OEItemID'="" {
					Set ArcimID=$p($g(^OEORD(+OEItemID,"I",+$p(OEItemID,"||",2),1)),"^",2)
					Set ArcimCode=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",1)
					Set ArcimDesc=$p(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1),"^",2)
					Set ExtInfo=##Class(DHCHAI.DI.DIO.EnsFromLis2Srv).GetExCode(ArcimID)
					Set ExtCode=$p(ExtInfo,"^",1)
					Set ExtDesc=$p(ExtInfo,"^",2)
					Set TestSetStr=TestSetStr_"!!"_ExtCode_"^"_ExtDesc_"^"_ArcimCode_"^"_ArcimDesc
				}
			}
			Set:TestSetStr'="" TestSetStr=$e(TestSetStr,3,$l(TestSetStr))
		}
	
		Set LabNo = $tr(LabNo," ","")   //标本号前面有空格
		Set TestSetRow=""
		//报告状态、报告有效标志
		Set Status=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),117)
		//Set RepStatus=$case(Status,"1":"审核","2":"取消审核","3":"作废",:"")
		//update 20201109 解决第三方检验无报告状态导致同步无法保存内容修改
		Set RepStatus=$case(Status,"1":"3","2":"5","3":"6",:"3")    //同步检验报告时,检验报告状态对照用的是code
		Set ExistReport=$s(Status="1":"Y",1:"N")
		//标本代码、标本名称
		Set SpeCode=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),123)
		Set SpeDesc=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),147)
		//采集标本日期、时间、采集人
		Set CollectDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),48)
		Set:CollectDate'="" CollectDate=$zd(CollectDate,3)
		Set CollectTime=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),49)
		Set:CollectTime'="" CollectTime=$zt(CollectTime)
		Set CollectUserCode=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),50) 
		Set CollectUserName=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),51)
		//接收标本日期、时间、接收人
		Set RecDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),65)
		Set:RecDate'="" RecDate=$zd(RecDate,3)
		Set RecTime=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),66)
		Set:RecTime'="" RecTime=$zt(RecTime)
		Set ReceiveUserCode=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),67)
		Set ReceiveUserName=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),68)
		//审核报告日期、时间、审核人
		Set AuthorDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),107)
		Set:AuthorDate'="" AuthorDate=$zd(AuthorDate,3)
		Set AuthorTime=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),108)
		Set:AuthorTime'="" AuthorTime=$zt(AuthorTime)
		Set AuthUserCode=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),109)
		Set AuthUserName=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),110)
		//登记日期、时间、登记人
		Set RegDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),111)
		Set:RegDate'="" RegDate=$zd(RegDate,3)
		Set RegTime=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),112)
		Set:RegTime'="" RegTime=$zt(RegTime)
		Set RegUserCode=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),113)
		Set RegUserName=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),114)
		//申请日期、时间
		Set ReqDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),22)
		Set:ReqDate'="" ReqDate=$zd(ReqDate,3)
		Set ReqTime=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),23)
		Set:ReqTime'="" ReqTime=$zt(ReqTime)
		//送检科室代码、名称
		Set LocCode=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),20)
		Set LocDesc=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),21)
		//根据医嘱取申请科室 合管医嘱 LISSROrderItemID 为医嘱ID1,医嘱ID2
		If (LocCode="") {
			Set LocID=$p($g(^OEORD(+OEItemID,"I",+$p(OEItemID,"||",2),7)),"^",2)
			Set:LocID'="" LocCode = $p($g(^CTLOC(LocID)),"^",1)
			Set:LocID'="" LocDesc = $p($g(^CTLOC(LocID)),"^",2)
		}
	
		//病区代码、名称
		Set WardCode=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),24)
		Set WardDesc=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),25)
		//主要评价
		Set MajorConclusion=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),143)
		//医嘱备注 add 20230424
		Set ReqNotes = $lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),102)
		Set Data=""
		Set $li(Data,1)  = $g(aEpisodeID)            // 就诊号
		Set $li(Data,2)  = $g(ReportID)              // 报告ID  
		Set $li(Data,3)  = $g(Order)                 // 标本报告序号
		Set $li(Data,4)  = $g(LabNo)                 // 标本号
		Set $li(Data,5)  = $g(TestSetRow)            // TestSetRow
		Set $li(Data,6)  = $g(RepStatus)             // 报告状态名称
		Set $li(Data,7)  = $g(ExistReport)           // 报告有效标志
		Set $li(Data,8)  = $g(OEItemID)              // 医嘱ID
		Set $li(Data,9)  = $g(ArcimDesc)             // 医嘱名称
		Set $li(Data,10) = $g(TestSetStr)            // 医嘱信息（检验代码+检验名称+医嘱代码+医嘱名称）
		Set $li(Data,11) = $g(SpeCode)               // 标本代码
		Set $li(Data,12) = $g(SpeDesc)               // 标本名称
		Set $li(Data,13) = $g(CollectDate)           // 采集标本日期
		Set $li(Data,14) = $g(CollectTime)           // 采集标本时间
		Set $li(Data,15) = $g(CollectUserCode)       // 采集人代码
		Set $li(Data,16) = $g(CollectUserName)       // 采集人姓名
		Set $li(Data,17) = $g(RecDate)               // 接收标本日期
		Set $li(Data,18) = $g(RecTime)               // 接收标本时间
		Set $li(Data,19) = $g(ReceiveUserCode)       // 接收人代码
		Set $li(Data,20) = $g(ReceiveUserName)       // 接收人姓名
		Set $li(Data,21) = $g(AuthorDate)            // 审核报告日期
		Set $li(Data,22) = $g(AuthorTime)            // 审核报告时间
		Set $li(Data,23) = $g(AuthUserCode)          // 审核人代码
		Set $li(Data,24) = $g(AuthUserName)          // 审核人姓名
		Set $li(Data,25) = $g(RegDate)               // 登记日期
		Set $li(Data,26) = $g(RegTime)               // 登记时间
		Set $li(Data,27) = $g(RegUserCode)           // 登记人代码
		Set $li(Data,28) = $g(RegUserName)           // 登记人姓名
		Set $li(Data,29) = $g(ReqDate)               // 申请日期
		Set $li(Data,30) = $g(ReqTime)               // 申请时间
		Set $li(Data,31) = $g(LocCode)               // 送检科室代码
		Set $li(Data,32) = $g(LocDesc)               // 送检科室名称
		Set $li(Data,33) = $g(WardCode)              // 病区代码
		Set $li(Data,34) = $g(WardDesc)              // 病区名称
		Set $li(Data,35) = $g(MajorConclusion)       // 主要评价
		Set $li(Data,36) = $g(ReqNotes)              // 医嘱备注 add 20230424

		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod SelectLISItemListByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLISItemListByDateExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectLISItemListByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLISItemListByDateExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获得医嘱项目对应的检验医嘱关联代码ExtCode, ExtDesc
ClassMethod GetExCode(ARCIMId As %String) As %String
{
	Quit:ARCIMId'["||" ""
	Set ItemId=$P(ARCIMId,"||",1) Quit:ItemId="" ""
	Set ItemSub=$P(ARCIMId,"||",2) Quit:ItemSub="" ""
	Set ExtCode="",ExtDesc=""
	Set chl=""
	For {
		Set chl=$o(^ARCIM(ItemId,ItemSub,"EXT",chl))
		Quit:chl=""
		Set DateTo=$p(^ARCIM(ItemId,ItemSub,"EXT",chl),"^",2)
		Set DateFrom=$p(^ARCIM(ItemId,ItemSub,"EXT",chl),"^",1)
		Continue:(DateFrom'="")&(DateFrom>+$h)
		Continue:(DateTo'="")&(DateTo<+$h)
		Set ExtCode=$p(^ARCIM(ItemId,ItemSub,"EXT",chl),"^",4)
		Set ExtDesc=$p(^ARCIM(ItemId,ItemSub,"EXT",chl),"^",6)
	}
	Quit ExtCode_"^"_ExtDesc
}

/// Creator：     zhufei
/// CreateDate：  2020-03-31
/// Description:  通过检验报告ID取检验结果接口
/// Table:        User.EnsLISItemResult
/// Input：       aReportID:检验报告ID
/// Return：      检验结果信息
/// w ##Class(DHCHAI.DI.DIO.EnsFromLis2Srv).GetRepResult("2000008031||2768")
ClassMethod GetRepResult(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	New (aReportID,errMsg)
	Set return=""
	Quit:(aReportID="") return
	
	Set $ZT="GetRepResultErr"
	//bug 2614702 如果索引里有字母123456_lsxd_45 索引里是小写，入参已经转大写了
	//增加判断不存在转小写
	Set:'$d(^Busi.ENS.EnsLISItemResultI("LISIRReportIDIndex",aReportID)) aReportID=$ZCVT($g(aReportID),"L")
	
	Set xShowSeq=""
	For {
		Set xShowSeq=$o(^Busi.ENS.EnsLISItemResultI("LISIRReportIDIndex",aReportID,xShowSeq))
		Quit:xShowSeq=""
		
		Set xResultID=""
		For {
			Set xResultID=$o(^Busi.ENS.EnsLISItemResultI("LISIRReportIDIndex",aReportID,xShowSeq,xResultID))
			Quit:xResultID=""
			
			Set ResultData=$g(^Busi.ENS.EnsLISItemResultD(xResultID))
			Continue:ResultData=""
			
			Set ResultID        = $lg(ResultData,2)   //检验项目结果ID
			Set TestCodeID	    = $lg(ResultData,6)   //检验项目代码
			Set TestCodeDesc	= $lg(ResultData,7)   //检验项目名称
			Set TestCodeData    = $g(^dbo.BTTestCodeD(TestCodeID))
			Set TestCodeCode	= $lg(TestCodeData,2) //检验项目代码
			Set TestCodeDesc	= $lg(TestCodeData,3) //检验项目名称
			Set RstFormat       = $lg(TestCodeData,9) //结果类型
			Set:RstFormat="X" RstFormat = "T" 	//文本格式
			
			Set Result			= $lg(ResultData,8)	  //检测结果
			Set TextRes			= $lg(ResultData,10)  //定性结果
			Set ResNoes			= $lg(ResultData,12)  //结果说明(备注)
			Set AbFlag			= $lg(ResultData,13)  //异常提示
			Set Unit			= $lg(ResultData,9)   //单位
			Set:Unit["^" Unit=$tr(Unit,"^","~")       //特殊字符处理
			Set RefRanges  	 	= $lg(ResultData,14)  //参考范围
			Set MDRResult   	= $lg(ResultData,34)  //多耐结果
			Set MultipleRes   	= $lg(ResultData,35)  //多耐类型
			
			Set RstResItems=##Class(DHCHAI.DI.DIO.EnsFromLis2Srv).GetRepRstResItem(xResultID) //根据检验结果获取耐药机制阳性结果
			For indItem=1:1:$listlength(RstResItems) {
				Set RstResItem=$listget(RstResItems,indItem)
				Continue:RstResItem=""
				Set MDRResult=MDRResult_","_RstResItem
			}
			
			//Update 20220120 标准版部分检出菌无结果有定性结果导致取不到细菌结果修改
			Set:(Result="")&(TextRes'="") Result=TextRes
		
			Set ResultData = ResultID_"^"_TestCodeCode_"^"_TestCodeDesc_"^"_RstFormat_"^"_Result_"^"_TextRes
			_"^"_ResNoes_"^"_AbFlag_"^"_Unit_"^"_RefRanges_"^"_MDRResult_"^"_MultipleRes
			
			Set return = return_$lb(ResultData)
		}
	}
	Quit return
	
GetRepResultErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     zhufei
/// CreateDate：  2020-03-31
/// Description:  通过检验结果ID取药敏结果接口
/// Table:        User.EnsLISItemSenResult
/// Input：       aResultID:检验结果ID
/// Return：      药敏结果信息
/// w ##Class(DHCHAI.DI.DIO.EnsFromLis2Srv).GetResultSen(1176)
ClassMethod GetResultSen(aResultID As %String, ByRef errMsg As %String = "") As %List
{
	New (aResultID,errMsg)
	Set return=""
	Quit:(aResultID="") return
	
	Set $ZT="GetResultSenErr"
	
	Set xShowSeq=""
	For {
		Set xShowSeq=$o(^Busi.ENS.EnsLISItemSenResultI("IndexSequence",aResultID,xShowSeq))
		Quit:xShowSeq=""
		
		Set xResSenID=""
		For {
			Set xResSenID=$o(^Busi.ENS.EnsLISItemSenResultI("IndexSequence",aResultID,xShowSeq,xResSenID))
			Quit:xResSenID=""
			Set AntCode=$lg($g(^Busi.ENS.EnsLISItemSenResultD(xResSenID)),3)
			Set AntDesc=$lg($g(^Busi.ENS.EnsLISItemSenResultD(xResSenID)),4)
			Continue:AntDesc=""
			Set SenCode=$lg($g(^Busi.ENS.EnsLISItemSenResultD(xResSenID)),6)
			Set SenDesc=$lg($g(^Busi.ENS.EnsLISItemSenResultD(xResSenID)),7)
		    Continue:SenDesc=""
			Set ResultSenData = AntCode_"^"_AntDesc_"^"_SenDesc_"^"_1
			Set return = return_$lb(ResultSenData)
		}
	}
	Quit return
	
GetResultSenErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     zhufei
/// CreateDate：  2020-03-31
/// Description:  通过检验结果ID取耐药机制结果接口
/// Table:        User.EnsLISItemResRst
/// Input：       aResultID:检验结果ID
/// Return：      耐药机制信息
/// w ##Class(DHCHAI.DI.DIO.EnsFromLis2Srv).GetRepRstRes(1678)
ClassMethod GetRepRstRes(aResultID As %String, ByRef errMsg As %String = "") As %List
{
	New (aResultID,errMsg)
	Set return=""
	Quit:(aResultID="") return
	
	Set $ZT="GetRepRstResErr"
	
	Set xShowSeq=""
	For {
		Set xShowSeq=$o(^Busi.ENS.EnsLISItemResRstI("LISIRResultSeqIndex",aResultID,xShowSeq))
		Quit:xShowSeq=""
		
		Set xRstResID=""
		For {
			Set xRstResID=$o(^Busi.ENS.EnsLISItemResRstI("LISIRResultSeqIndex",aResultID,xShowSeq,xRstResID))
			Quit:xRstResID=""
		
			Set ResRstData=$g(^Busi.ENS.EnsLISItemResRstD(xRstResID))
			Continue:ResRstData=""
			Set ResItemCode=$lg(ResRstData,4)
			Set ResItemName=$lg(ResRstData,5)
			Set ResRstDr=$lg(ResRstData,3)
			Continue:ResRstDr=""
			Set RstName=$lg(ResRstData,6)
			Set RstCode=""  //对应表dbo.BTBaseTable
	
            Set RepResRstData = xRstResID_"^"_aResultID_"^"_ResItemCode_"^"_ResItemName_"^"_ResRstDr_"^"_RstCode_"^"_RstName
			Set return = return_$lb(RepResRstData)
		}
	}	
	Quit return
	
GetRepRstResErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     zhufei
/// CreateDate：  2020-03-31
/// Description:  通过检验结果ID取耐药机制阳性项目列表
/// Table:        User.EnsLISItemResRst
/// Input：       aResultID:检验结果ID
/// Return：      耐药机制信息
/// w ##Class(DHCHAI.DI.DIO.EnsFromLis2Srv).GetRepRstResItem(1296)
ClassMethod GetRepRstResItem(aResultID As %String, ByRef errMsg As %String = "") As %List
{
	New (aResultID,errMsg)
	Set return=""
	Quit:(aResultID="") return
	
	Set $ZT="GetRepRstResItemErr"
	
	Set xShowSeq=""
	For {
		Set xShowSeq=$o(^Busi.ENS.EnsLISItemResRstI("LISIRResultSeqIndex",aResultID,xShowSeq))
		Quit:xShowSeq=""
		
		Set xRstResID=""
		For {
			Set xRstResID=$o(^Busi.ENS.EnsLISItemResRstI("LISIRResultSeqIndex",aResultID,xShowSeq,xRstResID))
			Quit:xRstResID=""
			
			Set ResRstData=$g(^Busi.ENS.EnsLISItemResRstD(xRstResID))
			Continue:ResRstData=""
			Set ResItemCode=$lg(ResRstData,4)
			Set ResItemName=$lg(ResRstData,5)
			//排除非多重耐药菌项目
		    Continue:(ResItemCode="A0001")||(ResItemCode="A0004")||(ResItemCode="A0005")||(ResItemCode="A0006")||(ResItemCode="A0007")
			Set ResRstDr=$lg(ResRstData,6)
			Continue:ResRstDr=""
            Continue:(ResRstDr'["阳性")&&(ResRstDr'["MRSA")
			Set return = return_$lb(ResItemName)
		}
	}
	Quit return
	
GetRepRstResItemErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     zhufei
/// CreateDate：  2020-03-31
/// Description:  根据标本号同步检验标本病区数据
/// 			  aEpisodeNo：检验号/标本号
///               DHCHAI.DP.LabVisitNumber
/// Return：      DHCHAI.DP.LabVisitNumber.ID
/// w ##class(DHCHAI.DI.DIO.EnsFromLis2Srv).SyncVisitNumber("LIS01","1000000715")
ClassMethod SyncVisitNumber(aSCode As %String, aEpisodeNo As %String) As %String
{
	New (aSCode,aEpisodeNo)
	Set return=0
	Quit:(aSCode="")||(aEpisodeNo="") return
	Set $ZT="SyncVisitNumberErr"
	
	Set VisitSpecDr=$o(^Busi.ENS.EnsLISSpecimenReportI("RELORDERSPECIMENHOSCODE"," "_aEpisodeNo,""))
	Quit:VisitSpecDr="" return
	Set xReportDr=$lg($g(^Busi.ENS.EnsLISSpecimenReportD(VisitSpecDr)),2)
	Quit:xReportDr="" return
	
	//接收标本日期、时间
	Set RecDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),65)
	Set RecTime=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),66)
	//病区代码、名称
	Set WardCode=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),24)
	Set WardDesc=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),25)
	//update 20190508 检验BT_Ward有部分数据Code与HISCode的存储是反的, 8.3标准版病区HISCode由存储PAC_Ward的WARD_Code改WARD_RowID
	If (WardCode'="")&&('$d(^PAWARD(0,"WARD_Code",$zcvt(WardCode,"U")))) {
		Set WardCode=$p($g(^PAWARD(WardCode)),"^",1)
	}	
	
	Set objWard=##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,WardCode)
	
	Set xID =$o(^DHCHAI.DP.LabVisitNumberI("IndexLabEpisodeNo",aEpisodeNo,"")) 
	Set obj=##class(DHCHAI.DP.LabVisitNumber).%OpenId(xID)
	Quit:'$IsObject(obj) return
	
	Set EpisodeID = obj.LabEpisodeDr.%Id()
	If '$IsObject(objWard){
		Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeID,RecDate,RecTime)
		Set WardDr =$p(TransInfo,"^",2)
		Set objWard = ##class(DHCHAI.BT.Location).GetObjById(WardDr)
	}
	
	Set obj.LabWardDr=objWard
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
SyncVisitNumberErr
	Set return="-999^"_$ZError
	Quit return
}

}
