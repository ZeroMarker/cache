/// 名称:EPRservice.BLL.MEDRECORDDATA.BLMedRecordData
/// 描述:按照EpisodeID查询患者病历信息
/// 创建者:Lifengbo
/// 创建时间:2012-08-08
Class EPRservice.BLL.MEDRECORDDATA.BLMedRecordData Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator： Lfb
/// CreatDate： 2012-08-08
/// Description:： 按照EpisodeID查询患者病历信息
/// Table： EPRinstance.ECRecord;EPRmeta.SysOption;EPRinstance.InstanceData
/// Input： EpisodeID:患者EpisodeID;StaDate,EndDate:筛选条件,起始结束日期;ArgStartPage,ArgEndPage:分页筛选结果,从第ArgStartPage条到第ArgEndPage条
/// Output： 查询的历次病历的Title,HappenDate,HappenTime,InstanceID和病历内容
/// Return：	
/// Others： 
/// debugger: d ##class(%ResultSet).RunQuery("EPRservice.BLL.MEDRECORDDATA.BLMedRecordData","GetMedRecordListItems","8261","62610","62616",1,5)
Query GetMedRecordListItems(ArgEpisodeID As %String, StaDate As %String, EndDate As %String, ArgStartPage As %Integer, ArgEndPage As %Integer) As %Query(ROWSPEC = "Title:%String,HappenDate:%String,HappenTime:%String,MedRecordInfo:%String,InstanceID:%String")
{
}

ClassMethod GetMedRecordListItemsExecute(ByRef qHandle As %Binary, ArgEpisodeID As %String, StaDate As %String, EndDate As %String, ArgStartPage As %Integer, ArgEndPage As %Integer) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s TotalAmount=0
	s OptionValues=##class(EPRmeta.SysOption).GetOptionValueByName("MedRecordItemCode")
	q:(OptionValues="")||(OptionValues="NULL") $$$OK
	// 多个可重复模板的程序，通过$$分割
	for i=1:1:$l(OptionValues,"$$")
	{
		s OptionValue=$p(OptionValues,"$$",i)
		s ChartItemId=$p(OptionValue,"|",1)
		s ItemCode=$p(OptionValue,"|",2)
		s ECRecordID = ##class(EPRinstance.ECRecord).GetECRecordID("", ArgEpisodeID,ChartItemId)
		continue:(ECRecordID="")
		s listNo=""
		f  
		{
			s listNo = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,listNo)) 
			q:listNo=""
			s InstanceID = ECRecordID_"||"_listNo
			s objInstance = ##class(EPRinstance.InstanceData).%OpenId(InstanceID)
			Continue:(objInstance="")
			s HappenDate=objInstance.HappenDate
			Continue:(HappenDate<StaDate)
			Continue:(HappenDate>EndDate)
		
			s HappenTime=objInstance.HappenTime
			//符合条件后,再进行分页的判断
			s TotalAmount=TotalAmount+1	
			Continue:(TotalAmount<ArgStartPage)
			Continue:(TotalAmount>ArgEndPage)
			s Title=objInstance.Title
			s MedRecordInfo=##class(EPRservice.BOScatterData).GetEPRMultipleData(ArgEpisodeID, ItemCode,InstanceID)
			//在输出时如果字符串中包含$c(13),会丢失数据
			s MedRecordInfo=$tr(MedRecordInfo,$c(13),"#")
			d OutputRow
		}
	}
	Quit $$$OK
OutputRow
	Set Data=$lb(Title,$zd(HappenDate,3),$zt(HappenTime,1),MedRecordInfo,InstanceID)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetMedRecordListItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMedRecordListItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetMedRecordListItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMedRecordListItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator： 	houj
/// CreatDate： 2014-11-08
/// Desc： 		按照EpisodeID查询患者病历信
/// Table： 	EPRinstance.ECRecord; EPRmeta.SysOption; EPRinstance.InstanceData
/// Input： 	AEpisodeID : 患者EpisodeID
/// 			ARecordFlag ：病历标识，比如入院记录，病程记录等
/// 			ASelectionFlag ：查询标识，比如 1：查询所有，2：查询近一个月，3：查询近一周，4：查询近三天
/// 			AStartCount ：分页标识的起始行数
/// 			AEndCount ：分页标识的结束行数
/// Output： 	Title 标题, HappenDate 发生日期, HappenTime 发生时间, MedRecordInfo 病历内容, InstanceID InstanceDataID
/// Return：	
/// Others： 
/// debugger: 	d ##class(%ResultSet).RunQuery("EPRservice.BLL.MEDRECORDDATA.BLMedRecordData","GetMedRecList","201871","日常病程","1","1","5")
Query GetMedRecList(AEpisodeID As %String, ARecordFlag, ASelectionFlag, AStartCount As %String, AEndCount As %String) As %Query(ROWSPEC = "Title:%String,HappenDate:%String,HappenTime:%String,MedRecordInfo:%String,InstanceID:%String")
{
}

ClassMethod GetMedRecListExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ARecordFlag, ASelectionFlag, AStartCount As %String, AEndCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//初始化
	s TotalAmount=0
	s StaDate = "0"
	s EndDate = $p($h,",",1)
	
	//b "s"
	//根据查询标识判断要查询的病历开始和结束日期
	s disDate = $P($G(^PAADM(AEpisodeID)),"^",17)
	if (ASelectionFlag = "1")
	{
		s StaDate = "0"
		s EndDate = $p($h,",",1)
	}
	elseif (ASelectionFlag = "2")
	{
		if (disDate '= "") {s EndDate = disDate}
		s StaDate = EndDate - 31
	}
	elseif (ASelectionFlag = "3")
	{
		if (disDate '= "") {s EndDate = disDate}
		s StaDate = EndDate - 7
	}
	elseif (ASelectionFlag = "4")
	{
		if (disDate '= "") {s EndDate = disDate}
		s StaDate = EndDate - 3
	}
	
	//取病历数据
	s bigRecordName = $zcvt(ARecordFlag,"U")
	s sequence = ""
	for {
		s sequence = $O(^DHCEPRM.CT.ResMedRecordI("IdxRecordName"," "_bigRecordName,sequence))
		q:(sequence = "")
		
		s rowID = ""
		for {
			s rowID = $O(^DHCEPRM.CT.ResMedRecordI("IdxRecordName"," "_bigRecordName,sequence,rowID))
			q:(rowID = "")
		
			s objResMedRecord = ##Class(EPRmeta.CT.ResMedRecord).%OpenId(rowID)
			continue:(objResMedRecord="")
			
			s recordType = objResMedRecord.RecordType
			if (recordType = "Multiple")
			{
				do GetMultiData2(objResMedRecord.PrintDocID, objResMedRecord.ContentScheme)
			}
			elseif (recordType = "Single")
			{
				do GetSingleData2(objResMedRecord.PrintDocID, objResMedRecord.ContentScheme, objResMedRecord.Title)
			}
		}
	}
	
	q $$$OK
	
	
GetMultiData2(printDocID, contentScheme)
	s ecRecordID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," ML"_printDocID,""))
	q:(ecRecordID="")
	
	s childSub = ""
	for {
		s childSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ecRecordID,childSub)) 
		q:(childSub="")
		
		s InstanceID = ecRecordID_"||"_childSub
		s objInstance = ##class(EPRinstance.InstanceData).%OpenId(InstanceID)
		continue:(objInstance="")
		continue:(objInstance.Status="UnSaved")
		
		//判断病历日期
		s HappenDate=objInstance.HappenDate
		Continue:(HappenDate<StaDate)
		Continue:(HappenDate>EndDate)
		
		//符合条件后,再进行分页的判断
		s TotalAmount=TotalAmount+1	
		Continue:(TotalAmount<AStartCount)
		Continue:(TotalAmount>AEndCount)
		
		s Title=objInstance.Title
		s HappenTime=objInstance.HappenTime
		s MedRecordInfo= $$GetContent2(AEpisodeID, InstanceID, contentScheme, "Multiple")
		d OutputRow2
	}
	
	quit

GetSingleData2(printDocID, contentScheme, segTitle)
	s eprLogsID = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_AEpisodeID," "_printDocID,"1",""))
	q:(eprLogsID = "")
	
	s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
	q:(objEPRLogs = "")
	q:(objEPRLogs.EPRStatus = "created")
	
	//1)唯一病历不需要筛选日期
	//2)分页
	s TotalAmount=TotalAmount+1	
	q:(TotalAmount<AStartCount)
	q:(TotalAmount>AEndCount)
	
	s HappenDate = objEPRLogs.HappenDate
	s HappenTime = objEPRLogs.HappenTime
	s Title = ""
	if (segTitle '= "")
	{
		s Title = segTitle
	}
	else
	{
		s objEPRTplCate = ##class(EPRmeta.EPRTemplateCategory).%OpenId(printDocID)
		if (objEPRTplCate '= "") {s Title = objEPRTplCate.CategoryName}
	}
	s InstanceID = eprLogsID_"--1"
	s MedRecordInfo= $$GetContent2(AEpisodeID, InstanceID, contentScheme, "Single")
	d OutputRow2
	
	quit
	
	
GetContent2(AEpisodeID, InstanceID, contentScheme, recordType)
	s recordContent = ""
	s leftCount = $L(contentScheme,"{")
	for i=1:1:leftCount
	{
		s scheme = $p(contentScheme,"{",i)
		if ($L(scheme,"}")=2)
		{
			//b "s"
			s itemCode = $p(scheme,"}",1)
			s record = ""
			if (recordType = "Multiple")
			{
				s record=##class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID, itemCode,InstanceID)
			}
			elseif (recordType = "Single")
			{
				s record=##class(EPRservice.BOScatterData).GetEPRData(AEpisodeID, itemCode)
			}
			
			//<+ by houj on 2014-12-26> 测试包含$C(13)时未丢失数据。不应直接去掉$C(13)，会导致引用的病历内容丢失换行
			//s record=$tr(record,$c(13),"")	//在输出时如果字符串中包含$c(13),会丢失数据
			s recordContent = recordContent_record_$p(scheme,"}",2)
		}
		else
		{
			s recordContent = recordContent_scheme
		}	
	}
	q recordContent
	
OutputRow2
	Set Data=$lb(Title,$zd(HappenDate,3),$zt(HappenTime,1),MedRecordInfo,InstanceID)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetMedRecListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMedRecListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetMedRecListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMedRecListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		Kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
