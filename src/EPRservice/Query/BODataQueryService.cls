/// EPRservice.BODataQueryService
Class EPRservice.Query.BODataQueryService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.254.100/trakcare/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "BODataQueryService";

/// get one item defined in ExportTables
/// [Previously private]
ClassMethod GetItemDataValue(EpisodeId As %String, ItemCode As %String, parGetCode As %String) As %String
{
	s tmpList=""
	q:((ItemCode="")||(($l(ItemCode,"#")'=6)&&($l(ItemCode,"#")'=5))) ""
	
	///parse 
	s TypeSection=$p(ItemCode,"#",2)
	q:($l(TypeSection,":")<2) ""
	s aType=$p(TypeSection,":",2)
	
	if aType="Simple" 
	{
		s TIDSection=$p(ItemCode,"#",3)
		q:($l(TypeSection,":")<2)
		s aTID=$p(TIDSection,":",2)
		
		s SCODESection=$p(ItemCode,"#",5)
		q:($l(SCODESection,":")<2)
		s aSCODE=$p(SCODESection,":",2)
		
		q ##class(EPRservice.Query.BODataQueryService).SelectEPRItemSimple(EpisodeId,aTID,aSCODE,parGetCode)
	}
	if aType="Segment"
	{
		s TIDSection=$p(ItemCode,"#",3)
		q:($l(TypeSection,":")<2)
		s aTID=$p(TIDSection,":",2)
		
		s GCODESection=$p(ItemCode,"#",5)
		q:($l(GCODESection,":")<2)
		s aGCODE=$p(GCODESection,":",2)
		
		q ##class(EPRservice.Query.BODataQueryService).SelectEPRItemSegment(EpisodeId,aTID,aGCODE)
	}
}

/// [Previously private]
ClassMethod PrepareAdmIdList(parWhereString As %String, parUniqueId As %String) As %String
{
	;b "s"
	k ^CacheTempAdmIdTmp(parUniqueId)
	k ^CacheTempAdmId(parUniqueId)
	s WhereNum=$l(parWhereString,"^")
	for i=1:1:WhereNum
	{
		;b "s"
		set aWhereString=$p(parWhereString,"^",i)
		set aWhere=$p(aWhereString,"#",1)
		set aOperator=$p(aWhereString,"#",2)
		set aValue=$p(aWhereString,"#",3)
		if $zcvt(aWhere,"U")="DISCHARGEDATE"
		{
			d ##class(EPRservice.Query.BODataQueryService).WhereDischargeDate(aOperator,aValue,parUniqueId)
			merge ^CacheTempAdmIdTmp(parUniqueId)=^CacheTempDisChgAdmId(parUniqueId)
		}
	}
	s AdmId=0,AdmCount=0
	f  s AdmId=$o(^CacheTempAdmIdTmp(parUniqueId,AdmId)) q:(AdmId="")  d
	.;if $ql("^CacheTempAdmIdTmp("_$j_","_AdmId_","""")")=WhereNum d
	.s SubNodesNum=0,SubNodes=0
	.f  s SubNodes=$o(^CacheTempAdmIdTmp(parUniqueId,AdmId,SubNodes)) q:(SubNodes="")  d
	..s SubNodesNum=SubNodesNum+1
	.if SubNodesNum=WhereNum d
	..s ^CacheTempAdmId(parUniqueId,AdmId)=""
	..s AdmCount=AdmCount+1
	q AdmCount
}

ClassMethod PrepareResultGlobal()
{
}

ClassMethod SelectAdmItem()
{
}

ClassMethod SelectEPRItem(parTableName As %String, parAdmWhereString As %String) As %String [ WebMethod ]
{
	;q "qqq"
	s AdmCount=0,aExportTable="",id=""
	s UniqueId=$i(^CacheTemp)
	s AdmCount=##class(EPRservice.Query.BODataQueryService).PrepareAdmIdList(parAdmWhereString,UniqueId)
	q:(AdmCount="0") "100" ;没有符合出院日期条件的病人

	k ^CacheTempEPRResult(UniqueId)

	k SQLCODE
	&sql(select ID into :id from EPRservice_Query.ExportTables where TableName=:parTableName)
	q:(SQLCODE'=0) "0" ;导出表定义错误

	s aExportTable=##class(EPRservice.Query.ExportTables).%OpenId(id)
	q:(aExportTable="") "0" ;导出表定义错误


	if (aExportTable.ClearData="1") {
	s ClearResult=##class(EPRservice.Query.ExportTables).ClearData(parTableName)
	q:(ClearResult="0") "-100"} ;清除导出表原有数据错误


	s AdmId=0
	f  s AdmId=$o(^CacheTempAdmId(UniqueId,AdmId)) q:(AdmId="")  d
	.s ColumnCount=0
	.s ColumnCount=aExportTable.Columns.Count()
	.q:(ColumnCount=0)
	.for i=1:1:ColumnCount d
	..s aColumn="",aColumnString="",aDataValue="",aGetCode=""
	..s aColumn=aExportTable.Columns.GetAt(i)
	..q:(aColumn="")
	..s aColumnString=aColumn.ItemCode
	..q:(aColumnString="")
	..s aGetCode=aColumn.GetCode
	..s ^CacheTempEPRResult(UniqueId,AdmId,aColumn.Name)=##class(EPRservice.Query.BODataQueryService).GetItemDataValue(AdmId,aColumnString,aGetCode)
	
	if (##class(EPRservice.Query.ExportTables).ImportData(parTableName,UniqueId)=1)
	{
		s ExportHis=$zdt($h,3)_"导出"_AdmCount_"条病人数据?导出条件?"_parAdmWhereString
		if ##class(EPRservice.Query.ExportTables).SetExportHistory(parTableName,ExportHis)'="1"
		{q "-1"}
		q AdmCount
	}
	q "-1" ;导出失败
}

/// [Previously private]
ClassMethod SelectEPRItemSegment(argEpisodeId As %String, argTemplateId As %String, argSegmentCode As %String) As %String
{
	s TextStreamId="",aText=""
	&sql(select Text into :TextStreamId from EPRinstance.ISegment
			where EpisodeId=:argEpisodeId and TemplateId=:argTemplateId and SegmentCode=:argSegmentCode)
	q:(TextStreamId="") ""
	Set TextStream=##class(%CharacterStream).%Open(TextStreamId)
	q:(TextStream="") ""
	d TextStream.Rewind()
	s aText=TextStream.Read(1000)
	s TextStream=""
	q aText
}

/// [Previously private]
ClassMethod SelectEPRItemSimple(argEpisodeId As %String, argTemplateId As %String, argSimpleItemCode As %String, argGetCode As %String) As %String
{
	s aDataValue=""
	if (argGetCode="1")
	{
		&sql(select ValueCode into :aDataValue from EPRinstance.ISimple 
				where EpisodeId=:argEpisodeId and TemplateId=:argTemplateId and SimpleItemCode=:argSimpleItemCode)
		q aDataValue
	}
	&sql(select DataValue into :aDataValue from EPRinstance.ISimple 
			where EpisodeId=:argEpisodeId and TemplateId=:argTemplateId and SimpleItemCode=:argSimpleItemCode)
	q aDataValue
}

/// [Previously private]
ClassMethod WhereDischargeDate(argOperator As %String, argValue As %String, parUniqueIdWhere As %String)
{
	k ^CacheTempDisChgAdmId(parUniqueIdWhere)
	s argDisDate=$zdh(argValue,3)
	if argOperator=">="
	{
		s argDisDate=argDisDate-1,AdmId=0
		f  s argDisDate=$o(^PAADMi("DischDate",argDisDate)) q:(argDisDate="")  d
		.f  s AdmId=$o(^PAADMi("DischDate",argDisDate,AdmId)) q:(AdmId="")  d
		..s patType=$p($g(^PAADM(AdmId)),"^",2)
		..s patStatus=$p($g(^PAADM(AdmId)),"^",20)
		..if (patType="I")&&(patStatus="D") d
		...s ^CacheTempDisChgAdmId(parUniqueIdWhere,AdmId,"D>=")=""
	}
	if argOperator="<="
	{
		s argDisDate=argDisDate+1,AdmId=0
		f  s argDisDate=$o(^PAADMi("DischDate",argDisDate),-1) q:(argDisDate="")  d
		.f  s AdmId=$o(^PAADMi("DischDate",argDisDate,AdmId)) q:(AdmId="")  d
		..s patType=$p($g(^PAADM(AdmId)),"^",2)
		..s patStatus=$p($g(^PAADM(AdmId)),"^",20)
		..if (patType="I")&&(patStatus="D") d
		...s ^CacheTempDisChgAdmId(parUniqueIdWhere,AdmId,"D<=")=""
	}
}

ClassMethod test()
{
	w ##class(EPRservice.Query.BODataQueryService).GetItemDataValue("63960","一般情况.姓名#TYPE:Simple#TID:1#TVER:0#SCODE:D0007#VTYPE:V")
}

ClassMethod test2()
{
	d ##class(EPRservice.Query.BODataQueryService).SelectEPRItem("test")
}

ClassMethod test3()
{
	w ##class(EPRservice.Query.BODataQueryService).SelectEPRItem("TEST","dischargedate#>=#2007-1-1^dischargedate#<=#2007-2-1")
}

ClassMethod test4()
{
	w ##class(EPRservice.Query.BODataQueryService).PrepareAdmIdList("dischargedate#>=#2007-5-1^dischargedate#<=#2007-5-1")
}

}
