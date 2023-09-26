Class EPRinstance.InstanceData Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Index IdxECRecord On TheECRecord;

Index IdxListNoTemplateIDVersion On (TemplateID, TemplateVersion, ListNo);

/// 病历创建日期
Property CreateDate As %Date;

Property CreateTime As %Time;

Property CreateUser As %String(TRUNCATE = 1);

Property GroupItemID As %String(TRUNCATE = 1);

Property GroupItemName As %String(TRUNCATE = 1);

/// 病历对应的行为发生日期，一般来说等于CreateDate
Property HappenDate As %Date;

Property HappenTime As %Time;

Property InstanceData As %GlobalCharacterStream(LOCATION = "^DHCEPRI.InstanceDataS");

Property ListNo As %String(TRUNCATE = 1);

Property Log As list Of InstanceLog;

/// 病历修改日期
Property ModifyDate As %Date;

Property ModifyTime As %Time;

Property ModifyUser As %String(TRUNCATE = 1);

Property Status As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %Integer;

Relationship TheECRecord As EPRinstance.ECRecord [ Cardinality = parent, Inverse = Instances ];

Property Title As %String(TRUNCATE = 1);

/// 历次病程记录备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

Index IdxEcRecordAndListNo On (TheECRecord, ListNo) [ Unique ];

Index IdxModifyDate On ModifyDate;

/// add a log for a instancedata
Method AddLog(argLog As InstanceLog) As %Status
{
	q:($d(argLog)=0)||(argLog="") 0
	q:('$IsObject(argLog)) 0
	q:($p(argLog,"@",2)'="EPRinstance.InstanceLog") 0
	s status=##this.Log.Insert(argLog)
	q status
}

Method GetFinalLog() As InstanceLog
{
	s count=0
	s count=##this.Log.Count()
	q:(count=0) ""
	s log=""
	s log=##this.Log.GetAt(count)
	q log
}

/// check if a instance has a status. that is, if there is a log in all its logs 
/// parameter: argStatusStr--the string of status
/// return value: InstanceLog
Method GetFirstLogByFinalStatus(argStatusStr As %String) As InstanceLog
{
	s count=0,log="",result="0"
	s count=##this.Log.Count()
	q:(count=0) ""
	for i=1:1:count {
		q:(result="1")
		s log=##this.Log.GetAt(i)
		if ($zcvt(log.FinalStatus,"U")=$zcvt(argStatusStr,"U")) {s result="1"}
	}
	
	q:(result="1") log
	q ""
}

/// gjb 2008-8-6
/// check if a instance has an action. that is, if there is a log in all its logs 
/// parameter: argActionStr--the string of checked Action 
/// return value: InstanceLog
Method GetFirstLogByAction(argActionStr As %String) As InstanceLog
{
	s count=0,log="",result="0"
	s count=##this.Log.Count()
	q:(count=0) ""
	for i=1:1:count {
		q:(result="1")
		s log=##this.Log.GetAt(i)
		if ($zcvt(log.Action,"U")=$zcvt(argActionStr,"U")) {s result="1"}
	}
	
	q:(result="1") log
	q ""
}

ClassMethod CheckInstanceSelfExist(AListNo As %String, ATemplateID As %String, ATemplateVersion As %Integer) As %Integer
{
 new Result
 &sql(SELECT Count(ListNo)
 into :Result 
 FROM EPRinstance.InstanceData
 WHERE ListNo = :AListNo
 And TemplateID = :ATemplateID 
 And TemplateVersion = :TemplateVersion )
 if Result=""
 {s Result=0 }
 QUIT Result
}

/// should not be used because you can't delete any logs
/// only for debug
Method ClearLog()
{
	d ##this.Log.Clear()
}

Method ChangeStatus(argStatus As %String)
{
	s ##this.Status=argStatus
}

Method GetAllLogs() As %ListOfObjects
{
	q ##this.Log
}

Method GetCurrentStatus()
{
	q ##this.Status
}

ClassMethod GetStrEpisodeID(ProcressionID As %String) As %String
{
	s outstr=""
	s PROCAChildSub="0"
	f  s PROCAChildSub=$o(^DHCPorc(ProcressionID,"I",PROCAChildSub)) q:PROCAChildSub=""  d
 .s mCurrRow=$g(^DHCPorc(ProcressionID,"I",PROCAChildSub))
 .s EpisodeID=$p(mCurrRow,"^",1)
	.s outstr=EpisodeID_"^"_outstr
	q outstr
}

ClassMethod GetTemplateIDByID(AID As %String) As %String
{
  /* commented by gaojb 20090527
 new Result
 New CountTpl
 &sql(SELECT Count(TemplateID)
 into :CountTpl
 FROM EPRinstance.InstanceData
 WHERE ID = :AID)

 if (CountTpl="")
 {QUIT Result=0 }
 Elseif(CountTpl>0)
 {
 &sql(SELECT TemplateID
 into :Result
 FROM EPRinstance.InstanceData
 WHERE ID = :AID)
 Quit Result  */

 /// added by gaojb 20090527
 s instanceData=""
 s instanceData=##class(EPRinstance.InstanceData).%OpenId(AID)
 q:(instanceData="") ""
 s result=instanceData.TemplateID
 s instanceData=""
 q result
}

ClassMethod MakeProcessList(AProcessID As %String, AChartItemID As %String)
{
 K ^CacheTempProcessList($J)


 S EpisodeIDStr=##class(EPRinstance.InstanceData).GetStrEpisodeID(AProcessID)
 s ECRecordIDStr=""
 S ECRecordCount = 0
 s BlankChartItemID= " "_AChartItemID
 if (EpisodeIDStr'="")&(EpisodeIDStr'=$C(0)) 
 {
 set EpisodeIDCount = $LENGTH(EpisodeIDStr,"^")	  
	 if (EpisodeIDCount >0)
	 {
	  if $D(^DHCEPRI.ECRecordI)	     
	  {
	   for I=  1 :1:EpisodeIDCount
 {
	    s EpisodeID= $PIECE(EpisodeIDStr,"^",I)
	    s BlankEpisodeID=" "_EpisodeID 
	    if ($D(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",BlankEpisodeID,BlankChartItemID)) )
	    {
		   S AECRecordID= $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",BlankEpisodeID,BlankChartItemID,""))  
		   WHILE (AECRecordID'="")
		   {
			 if (ECRecordCount=0)
			 { s ECRecordIDStr= AECRecordID }
			 Elseif (ECRecordCount>0)
			 {
			   s ECRecordIDStr= ECRecordIDStr _"^"_ AECRecordID }
			   s ECRecordCount =ECRecordCount +1	
			 
			 s AECRecordID= $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",BlankEpisodeID,BlankChartItemID,AECRecordID))    
			 }  
			}
 }
		    }
	     }
		}  	 
	 S PropressListCount = 0
	 if (ECRecordIDStr'="")
	 {
		set ECRecordCount = $LENGTH(ECRecordIDStr,"^")	   

 if (ECRecordCount >0)
 {
	      for J=1:1:ECRecordCount
 {
	        s ECRecordID = $PIECE(ECRecordIDStr,"^",J)
	        if $D(^DHCEPRI.InstanceDataI)
	        { s AInstanceLowID = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,""))
		     while (AInstanceLowID'="") 
		     {
			   s AInstanceDataID= ECRecordID_"||"_ AInstanceLowID 
			   s objInstance= ##class(EPRinstance.InstanceData).%OpenId(AInstanceDataID)   			     
			   s PropressListCount= PropressListCount +1
			   Set ^CacheTempProcessList($J,PropressListCount)=$LB(objInstance.%Id(),objInstance.GroupItemName)		
			   s AInstanceLowID = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,AInstanceLowID)) 
			     }
		      }  
	        } 
	        }
	 }
}

ClassMethod OldUpdateIndex(AEInstanceData As EPRservice.entity.EInstanceData)
{
		
		//set objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(AID)
	//Set InstanceDataStream = ##class(%GlobalCharacterStream).%New() 
	//d InstanceDataStream.CopyFrom(objInstanceData.InstanceData)
	//Do InstanceDataStream.SaveStream()
		
		 Set sc = ##class(%XML.TextReader).ParseStream(AEInstanceData.InstanceData,.reader) 
		 Set newNInstanceData=##class(EPRinstance.Parser.NInstanceData).%New()
		 
		 if ($$$ISOK(sc)) 
		 { 
		   do reader.Read()
		   do newNInstanceData.XMLDeserialize(reader) 	   	
		}	
		
		set newIndexMgrSimple = ##class(EPRinstance.IdxMgr.Simple).%New()
		
		
		Set newIndexMgrSimple.InstanceDataID = AEInstanceData.ID
		
		Set newIndexMgrSimple.PatientID = AEInstanceData.PatientID
		
		Set newIndexMgrSimple.EpisodeID = AEInstanceData.EpisodeID
		
		Set newIndexMgrSimple.ListNo = AEInstanceData.ListNo
		
		Set newIndexMgrSimple.ChartItemID = AEInstanceData.ChartItemID
		
		Set newIndexMgrSimple.TemplateID = AEInstanceData.TemplateID
		
		Set newIndexMgrSimple.TemplateVersion = AEInstanceData.TemplateVersion
	
		d newIndexMgrSimple.BuildIndex(newNInstanceData)
		
		set newIndexMgrSegment = ##class(EPRinstance.IdxMgr.Segment).%New()
	
		Set newIndexMgrSegment.InstanceDataID = AEInstanceData.ID
		
		Set newIndexMgrSegment.PatientID = AEInstanceData.PatientID
		
		Set newIndexMgrSegment.EpisodeID = AEInstanceData.EpisodeID
		
		Set newIndexMgrSegment.ListNo = AEInstanceData.ListNo
		
		Set newIndexMgrSegment.ChartItemID = AEInstanceData.ChartItemID
		
		Set newIndexMgrSegment.TemplateID = AEInstanceData.TemplateID
		
		Set newIndexMgrSegment.TemplateVersion = AEInstanceData.TemplateVersion
		Do newIndexMgrSegment.BuildIndex(newNInstanceData)
		
		
		set newIndexMgrTextDesc = ##class(EPRinstance.IdxMgr.TextDesc).%New()
		Set newIndexMgrTextDesc.InstanceDataID = AEInstanceData.ID
		Set newIndexMgrTextDesc.PatientID = AEInstanceData.PatientID
		
		Set newIndexMgrTextDesc.EpisodeID = AEInstanceData.EpisodeID
		
		Set newIndexMgrTextDesc.ListNo = AEInstanceData.ListNo
		
		Set newIndexMgrTextDesc.ChartItemID = AEInstanceData.ChartItemID
		
		Set newIndexMgrTextDesc.TemplateID = AEInstanceData.TemplateID
		
		Set newIndexMgrTextDesc.TemplateVersion = AEInstanceData.TemplateVersion
	
		d newIndexMgrTextDesc.BuildIndex(newNInstanceData)
		
		
	    set newIndexMgrTable = ##class(EPRinstance.IdxMgr.Table).%New()
	    Set newIndexMgrTable.InstanceDataID = AEInstanceData.ID
	    Set newIndexMgrTable.PatientID = AEInstanceData.PatientID
		
	    Set newIndexMgrTable.EpisodeID = AEInstanceData.EpisodeID
		
	    Set newIndexMgrTable.ListNo = AEInstanceData.ListNo
		
	    Set newIndexMgrTable.ChartItemID = AEInstanceData.ChartItemID
		
	    Set newIndexMgrTable.TemplateID = AEInstanceData.TemplateID
		
	    Set newIndexMgrTable.TemplateVersion = AEInstanceData.TemplateVersion
	
	    d newIndexMgrTable.BuildIndex(newNInstanceData)
}

ClassMethod SELECTProcessListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SELECTProcessListExecute ]
{
 s qHandle="" 
 Quit $$$OK
}

ClassMethod SELECTProcessListExecute(ByRef qHandle As %Binary, AProcessID As %String, AChartItemID As %String) As %Status
{
 s qHandle="1" 
 s SQLCODE=0 
 //s %ROWID=0 
 s %counter=0
 s ID=""
 S %ResultID=""

 if ($D(^CacheTempProcessList($J)))
 { set IncDataIDKey= $O(^CacheTempProcessList($J,""))
	 While (IncDataIDKey '="")
	 {
	  Set %ResultID(IncDataIDKey)= $G(^CacheTempProcessList($J,IncDataIDKey))	 
	   set IncDataIDKey= $O(^CacheTempProcessList($J,IncDataIDKey)) 	
	 }
	 s qHandle=%ResultID
 Quit $$$OK
	 }
}

ClassMethod SELECTProcessListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SELECTProcessListExecute ]
{
 s SQLCODE=0 
 s $ET="QUIT" 
 s %counter=%counter+1
 if $o(%ResultID(""),-1) < %counter 
 {
	s Row = ""
	s AtEnd=1
 }
 else 
 {
	set Row=%ResultID(%counter)
	}

 Quit $$$OK
}

ClassMethod UpdateAnnotateIndex()
{
	set newIndexMgrAnnotate = ##class(EPRinstance.IdxMgr.Annotate).%New()
	Set newIndexMgrAnnotate.InstanceDataID = AEInstanceData.ID
	Set newIndexMgrAnnotate.PatientID = AEInstanceData.PatientID
		
	Set newIndexMgrAnnotate.EpisodeID = AEInstanceData.EpisodeID
		
	Set newIndexMgrAnnotate.ListNo = AEInstanceData.ListNo
		
	Set newIndexMgrAnnotate.ChartItemID = AEInstanceData.ChartItemID
		
	Set newIndexMgrAnnotate.TemplateID = AEInstanceData.TemplateID
		
	Set newIndexMgrAnnotate.TemplateVersion = AEInstanceData.TemplateVersion
	
	d newIndexMgrAnnotate.BuildIndex(newNInstanceData)
}

ClassMethod UpdateIndex(AEInstanceData As EPRservice.entity.EInstanceData)
{
 s AFileName=##class(EPRservice.Utility).GetFileName(AEInstanceData.ID)  
 Set file=##class(%File).%New(AFileName)
	Do file.Open("WNU")
	d AEInstanceData.InstanceData.Rewind()
	while (AEInstanceData.InstanceData.AtEnd = 0)
	{ s readstring=AEInstanceData.InstanceData.Read(1000)
	  d file.Write(readstring)
	}
	//d file.CopyFrom(AStream)
	D file.%Close()
	
	Set file = ##class(%File).%New(AFileName)
 Do file.Open("RS") 
	set ASearchStream = ##class(%GlobalCharacterStream).%New()
	d ASearchStream.CopyFrom(file)
 D file.%Close() 

 Set sc = ##class(%XML.TextReader).ParseFile(AFileName,.reader) 
		 Set newNInstanceData=##class(EPRinstance.Parser.NInstanceData).%New()
		 
		 if ($$$ISOK(sc)) 
		 { 
		   do reader.Read()
		   do newNInstanceData.XMLDeserialize(reader) 	   	
		}
	    
	    ;B 
	    ;w ASearchStream.SizeGet() 
 d newNInstanceData.FileImageAnnotate(ASearchStream)		
			
		
		set newIndexMgrSimple = ##class(EPRinstance.IdxMgr.Simple).%New()
		
		Set newIndexMgrSimple.InstanceDataID = AEInstanceData.ID
		
		Set newIndexMgrSimple.PatientID = AEInstanceData.PatientID
		
		Set newIndexMgrSimple.EpisodeID = AEInstanceData.EpisodeID
		
		Set newIndexMgrSimple.ListNo = AEInstanceData.ListNo
		
		Set newIndexMgrSimple.ChartItemID = AEInstanceData.ChartItemID
		
		Set newIndexMgrSimple.TemplateID = AEInstanceData.TemplateID
		
		Set newIndexMgrSimple.TemplateVersion = AEInstanceData.TemplateVersion
	
		d newIndexMgrSimple.BuildIndex(newNInstanceData)
		
		set newIndexMgrSegment = ##class(EPRinstance.IdxMgr.Segment).%New()
	
		Set newIndexMgrSegment.InstanceDataID = AEInstanceData.ID
		
		Set newIndexMgrSegment.PatientID = AEInstanceData.PatientID
		
		Set newIndexMgrSegment.EpisodeID = AEInstanceData.EpisodeID
		
		Set newIndexMgrSegment.ListNo = AEInstanceData.ListNo
		
		Set newIndexMgrSegment.ChartItemID = AEInstanceData.ChartItemID
		
		Set newIndexMgrSegment.TemplateID = AEInstanceData.TemplateID
		
		Set newIndexMgrSegment.TemplateVersion = AEInstanceData.TemplateVersion
		Do newIndexMgrSegment.BuildIndex(newNInstanceData)
		
		
		set newIndexMgrTextDesc = ##class(EPRinstance.IdxMgr.TextDesc).%New()
		Set newIndexMgrTextDesc.InstanceDataID = AEInstanceData.ID
		Set newIndexMgrTextDesc.PatientID = AEInstanceData.PatientID
		
		Set newIndexMgrTextDesc.EpisodeID = AEInstanceData.EpisodeID
		
		Set newIndexMgrTextDesc.ListNo = AEInstanceData.ListNo
		
		Set newIndexMgrTextDesc.ChartItemID = AEInstanceData.ChartItemID
		
		Set newIndexMgrTextDesc.TemplateID = AEInstanceData.TemplateID
		
		Set newIndexMgrTextDesc.TemplateVersion = AEInstanceData.TemplateVersion
	
		d newIndexMgrTextDesc.BuildIndex(newNInstanceData)
		
		
	    set newIndexMgrTable = ##class(EPRinstance.IdxMgr.Table).%New()
	    Set newIndexMgrTable.InstanceDataID = AEInstanceData.ID
	    Set newIndexMgrTable.PatientID = AEInstanceData.PatientID
		
	    Set newIndexMgrTable.EpisodeID = AEInstanceData.EpisodeID
		
	    Set newIndexMgrTable.ListNo = AEInstanceData.ListNo
		
	    Set newIndexMgrTable.ChartItemID = AEInstanceData.ChartItemID
		
	    Set newIndexMgrTable.TemplateID = AEInstanceData.TemplateID
		
	    Set newIndexMgrTable.TemplateVersion = AEInstanceData.TemplateVersion
	
	    d newIndexMgrTable.BuildIndex(newNInstanceData)

 set newIndexMgrAnnotate = ##class(EPRinstance.IdxMgr.Annotate).%New()
	    Set newIndexMgrAnnotate.InstanceDataID = AEInstanceData.ID
	    Set newIndexMgrAnnotate.PatientID = AEInstanceData.PatientID
		
	    Set newIndexMgrAnnotate.EpisodeID = AEInstanceData.EpisodeID
		
		Set newIndexMgrAnnotate.ListNo = AEInstanceData.ListNo
		
		Set newIndexMgrAnnotate.ChartItemID = AEInstanceData.ChartItemID
		
		Set newIndexMgrAnnotate.TemplateID = AEInstanceData.TemplateID
		
		Set newIndexMgrAnnotate.TemplateVersion = AEInstanceData.TemplateVersion
	
		d newIndexMgrAnnotate.BuildIndex(newNInstanceData)
}

/// Desc: 打散数据
/// Input: AEInstanceData: EPRservice.entity.EInstanceData
/// Output: 无
/// Return："1" 成功，"0" 失败
ClassMethod UpdateIndexByAutomaton(AEInstanceData As EPRservice.entity.EInstanceData) As %String
{
	//异常处理 -- added on 2009-07-27 by HouJ
	s $zt = "ErrorHandler"
	
	//comment by houj on 2014-04-23
	/* 
	//生成流数据备份
 	s ASearchStream = ##class(%GlobalCharacterStream).%New()
 	d ASearchStream.CopyFrom(AEInstanceData.InstanceData)
 	d ASearchStream.Rewind()
 
 	//解析流数据
 	S AAutoParserStream=##class(EPRservice.Util.ParserStream).%New()
 	s AAutoParserStream.CdataSign=$J
 	S DissolveStream =  AAutoParserStream.AutoMationByStr(ASearchStream)
	d DissolveStream.Rewind()
	*/
	//add by houj on 2014-04-23
	s DissolveStream = ##class(EPRservice.Util.ParserStream).AutoMationByString(AEInstanceData.InstanceData,$j)
	
	//清除非法结束字符 -- added on 2010-05-27 by houj
	s DissolveStream = ##class(EPRservice.Util.StreamParser).ClearIllegalChar(DissolveStream)
	d DissolveStream.Rewind()
	
	//重置流数据格式（解决Cache的xml相关的bug）
	s AFileName=##class(EPRservice.Utility).GetFileName(AEInstanceData.ID)  
	S stream=##class(%FileCharacterStream).%New()
	S stream.Filename=AFileName
	d stream.TranslateTableSet("UTF8")
	d stream.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	while (DissolveStream.AtEnd = 0)
	{ 
		s readstring=DissolveStream.Read(32000)
	  	d stream.Write(readstring)
	}
	d stream.SaveStream()
	D stream.%Close()
	
	//从流数据反序列化InstanceData对象
	S newNInstanceData=##class(EPRinstance.Parser.NInstanceData).%New()
	s newNInstanceData.SessionSign=$J
	S sc = ##class(%XML.TextReader).ParseFile(AFileName,.reader) 
	if ($$$ISOK(sc)) 
	{ 
		do reader.Read()
		do newNInstanceData.XMLDeserialize(reader) 	   	
	}
	else
	{	
		//清理临时数据
		d ##class(EPRservice.Util.CdataItem).DeleteCdataItems(newNInstanceData.SessionSign)
		If (##class(%File).Exists(AFileName))
		{ 
		 	s file = ""
		 	d ##class(%File).Delete(AFileName)
		}
		q "0"_"Error in Deserilize InstanceData by File"
	}
	
	
	//清理临时数据
	d ##class(EPRservice.Util.CdataItem).DeleteCdataItems(newNInstanceData.SessionSign)
	If (##class(%File).Exists(AFileName))
	{ 
	 	s file = ""
	 	d ##class(%File).Delete(AFileName)
	}
	
	
	//数据打散
	set newIndexMgrSimple = ##class(EPRinstance.IdxMgr.Simple).%New()	
	Set newIndexMgrSimple.InstanceDataID = AEInstanceData.ID	
	Set newIndexMgrSimple.PatientID = AEInstanceData.PatientID
	Set newIndexMgrSimple.EpisodeID = AEInstanceData.EpisodeID
	Set newIndexMgrSimple.ListNo = AEInstanceData.ListNo
	Set newIndexMgrSimple.ChartItemID = AEInstanceData.ChartItemID
	Set newIndexMgrSimple.TemplateID = AEInstanceData.TemplateID
	Set newIndexMgrSimple.TemplateVersion = AEInstanceData.TemplateVersion
	d newIndexMgrSimple.BuildIndex(newNInstanceData)
	
	set newIndexMgrSegment = ##class(EPRinstance.IdxMgr.Segment).%New()
	Set newIndexMgrSegment.InstanceDataID = AEInstanceData.ID
	Set newIndexMgrSegment.PatientID = AEInstanceData.PatientID
	Set newIndexMgrSegment.EpisodeID = AEInstanceData.EpisodeID
	Set newIndexMgrSegment.ListNo = AEInstanceData.ListNo	
	Set newIndexMgrSegment.ChartItemID = AEInstanceData.ChartItemID
	Set newIndexMgrSegment.TemplateID = AEInstanceData.TemplateID
	Set newIndexMgrSegment.TemplateVersion = AEInstanceData.TemplateVersion
	Do newIndexMgrSegment.BuildIndex(newNInstanceData)
	
	set newIndexMgrTextDesc = ##class(EPRinstance.IdxMgr.TextDesc).%New()
	Set newIndexMgrTextDesc.InstanceDataID = AEInstanceData.ID
	Set newIndexMgrTextDesc.PatientID = AEInstanceData.PatientID
	Set newIndexMgrTextDesc.EpisodeID = AEInstanceData.EpisodeID
	Set newIndexMgrTextDesc.ListNo = AEInstanceData.ListNo
	Set newIndexMgrTextDesc.ChartItemID = AEInstanceData.ChartItemID
	Set newIndexMgrTextDesc.TemplateID = AEInstanceData.TemplateID
	Set newIndexMgrTextDesc.TemplateVersion = AEInstanceData.TemplateVersion
	d newIndexMgrTextDesc.BuildIndex(newNInstanceData)
	
	set newIndexMgrTable = ##class(EPRinstance.IdxMgr.Table).%New()
	Set newIndexMgrTable.InstanceDataID = AEInstanceData.ID
	Set newIndexMgrTable.PatientID = AEInstanceData.PatientID
	Set newIndexMgrTable.EpisodeID = AEInstanceData.EpisodeID
	Set newIndexMgrTable.ListNo = AEInstanceData.ListNo
	Set newIndexMgrTable.ChartItemID = AEInstanceData.ChartItemID	
	Set newIndexMgrTable.TemplateID = AEInstanceData.TemplateID
	Set newIndexMgrTable.TemplateVersion = AEInstanceData.TemplateVersion
	d newIndexMgrTable.BuildIndex(newNInstanceData)
	
 	set newIndexMgrAnnotate = ##class(EPRinstance.IdxMgr.Annotate).%New()
	Set newIndexMgrAnnotate.InstanceDataID = AEInstanceData.ID
	Set newIndexMgrAnnotate.PatientID = AEInstanceData.PatientID
	Set newIndexMgrAnnotate.EpisodeID = AEInstanceData.EpisodeID
	Set newIndexMgrAnnotate.ListNo = AEInstanceData.ListNo
	Set newIndexMgrAnnotate.ChartItemID = AEInstanceData.ChartItemID
	Set newIndexMgrAnnotate.TemplateID = AEInstanceData.TemplateID
	Set newIndexMgrAnnotate.TemplateVersion = AEInstanceData.TemplateVersion
	d newIndexMgrAnnotate.BuildIndex(newNInstanceData)
	
	// 合肥Figure单元导致保存失败，还未准确确定原因
	// 使用系统参数控制是否打散F单元
	set needScatterFigure = ##class(EPRmeta.SysOption).GetOptionValueByName("NeedScatterFigure")
	if (needScatterFigure = "Y")
	{
		set newIndexMgrFigure = ##class(EPRinstance.IdxMgr.Figure).%New()
		Set newIndexMgrFigure.InstanceDataID = AEInstanceData.ID
		Set newIndexMgrFigure.PatientID = AEInstanceData.PatientID
		Set newIndexMgrFigure.EpisodeID = AEInstanceData.EpisodeID
		Set newIndexMgrFigure.ListNo = AEInstanceData.ListNo
		Set newIndexMgrFigure.ChartItemID = AEInstanceData.ChartItemID
		Set newIndexMgrFigure.TemplateID = AEInstanceData.TemplateID
		Set newIndexMgrFigure.TemplateVersion = AEInstanceData.TemplateVersion
		d newIndexMgrFigure.BuildIndex(newNInstanceData)
	}
	
   q "1"
    
ErrorHandler

	q "0"_$ZError
}

Method UpdateOneLog(argLog As InstanceLog, argLogID As %String) As %Status
{
	q:($d(argLogID)=0)||(argLogID="") 0
	s status=##this.Log.SetAt(argLog, argLogID)
	q status
}

ClassMethod UpdateTableIndex()
{
	
	
	set newIndexMgrTable = ##class(EPRinstance.IdxMgr.Table).%New()
	Set newIndexMgrTable.InstanceDataID = AEInstanceData.ID
	Set newIndexMgrTable.PatientID = AEInstanceData.PatientID
		
	Set newIndexMgrTable.EpisodeID = AEInstanceData.EpisodeID
		
	Set newIndexMgrTable.ListNo = AEInstanceData.ListNo
		
	Set newIndexMgrTable.ChartItemID = AEInstanceData.ChartItemID
		
	Set newIndexMgrTable.TemplateID = AEInstanceData.TemplateID
		
	Set newIndexMgrTable.TemplateVersion = AEInstanceData.TemplateVersion
	
	d newIndexMgrTable.BuildIndex(newNInstanceData)
}

ClassMethod testbyId(AID As %String)
{
 s aa= ##class(EPRservice.BOInstanceData).GetDataByID(AID)
 d ##class(EPRinstance.InstanceData).UpdateIndexByFile(aa)
}

ClassMethod testupddteById(AID As %String)
{
 set AEInstanceData= ##class(EPRservice.BOInstanceData).GetDataByID(AID)	
 d ..UpdateIndexByAutomaton(AEInstanceData)
}

/// added on 2008-07-10 by HouJ
Query SELECTCreateDateGroupList(ATheECRecord As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "CreateDate:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_InstanceData_SELECTCreateDateGroupList, SqlProc ]
{
 SELECT CreateDate  
 FROM EPRinstance.InstanceData
 WHERE TheECRecord = :ATheECRecord Group By CreateDate
}

/// added on 2008-10-08 by HouJ
Query SELECTHappenDateGroupList(ATheECRecord As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "HappenDate:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_InstanceData_SELECTHappenDateGroupList, SqlProc ]
{
	SELECT HappenDate
	FROM EPRinstance.InstanceData
	WHERE TheECRecord = :ATheECRecord Group By HappenDate Order By HappenDate
}

Query SELECTGroupList(ATheECRecord As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String ,GroupItemName:%String, GroupItemID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_InstanceData_SELECTGroupList, SqlProc ]
{
 SELECT  ID,  GroupItemName, GroupItemID
 FROM EPRinstance.InstanceData
 WHERE TheECRecord =  :ATheECRecord
}

Query SELECTGroupListNew(ATheECRecord As %String, AEpisodeID As %String) As %Query(ROWSPEC = "ID:%String ,GroupItemName:%String, GroupItemID:%String, ItemStatus:%String") [ SqlName = SP_InstanceData_SELECTGroupListNew, SqlProc ]
{
}

ClassMethod SELECTGroupListNewExecute(ByRef qHandle As %Binary, ATheECRecord As %String, AEpisodeID As %String) As %Status
{
 s qHandle=$lb(ATheECRecord,"",AEpisodeID)

 Quit $$$OK
}

ClassMethod SELECTGroupListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SELECTGroupListNewExecute ]
{
	s aTheECRecord = $lg(qHandle,1)
	s instanceChildId = $lg(qHandle,2)
	s aEpisodeID = $lg(qHandle,3)
	
	if aTheECRecord'=""
	{
		s instanceChildId = $o(^DHCEPRI.InstanceDataI("IdxECRecord",aTheECRecord,instanceChildId))
	}
	else
	{
		s instanceChildId = ""
	}

	if instanceChildId'=""
	{
		s curInstanceData = $g(^DHCEPRI.ECRecordD(aTheECRecord,"Instances",instanceChildId))
		s curId = "",curItemName="",curGroupItemID="",curItemStatus=""
		if (curInstanceData'="")
		{
			s curId = aTheECRecord_"||"_instanceChildId
			s curItemName = $lg(curInstanceData,29)
			s curGroupItemID = $lg(curInstanceData,28)
			s curItemStatus = $lg(curInstanceData,11)
			
			//页签权限控制，对于没有保存过的页签，如果当前页签下没有最少一个可显示的模板，不显示页签（在此需将其状态改为Unview）--Added By cwj On 090220
			if (curItemStatus = "UnSave")
			{
				s rtnTemplate = ##class(EPRservice.TPrivLogic.PrivLogic).GetTempForView(aEpisodeID,"",curGroupItemID)
 				s privateActivity = $p(rtnTemplate,"^",1)
 				s ATemplateID = $p(rtnTemplate,"^",2)
 				if ((privateActivity = "Y") && (ATemplateID=""))
 				{
	 				s curItemStatus = "UnView"
				}
			}
			//end
		}
		
		if ($d(curId)=0){s curId = ""}
		if ($d(curItemName)=0){s curItemName = ""}
		if ($d(curGroupItemID)=0){s curGroupItemID = ""}
		if ($d(curItemStatus)=0){s curItemStatus = ""}
		s Row=$lb(curId,curItemName,curGroupItemID,curItemStatus)
		s qHandle=$lb(aTheECRecord,instanceChildId,aEpisodeID)
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod SELECTGroupListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SELECTGroupListNewExecute ]
{
 	s qHandle="" 
	Quit $$$OK
}

Query SELECTProcessList(AProcessID As %String, AChartItemID As %String) As %Query(CONTAINID = 1, ROWSPEC = "ID:%String ,GroupItemName:%String")
{
}

Storage Default
{
<Data name="InstanceDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChartItemID</Value>
</Value>
<Value name="3">
<Value>CreateUser</Value>
</Value>
<Value name="4">
<Value>CretaeDateTime</Value>
</Value>
<Value name="5">
<Value>Data</Value>
</Value>
<Value name="6">
<Value>EpisodeId</Value>
</Value>
<Value name="7">
<Value>ID</Value>
</Value>
<Value name="8">
<Value>ModifyDateTime</Value>
</Value>
<Value name="9">
<Value>ModifyUser</Value>
</Value>
<Value name="10">
<Value>PatientID</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>TemplateID</Value>
</Value>
<Value name="13">
<Value>TemplateVersion</Value>
</Value>
<Value name="14">
<Value>CretaeDate</Value>
</Value>
<Value name="15">
<Value>CretaeTime</Value>
</Value>
<Value name="16">
<Value>EpisodeID</Value>
</Value>
<Value name="17">
<Value>HappenDate</Value>
</Value>
<Value name="18">
<Value>HappenTime</Value>
</Value>
<Value name="19">
<Value>InstanceData</Value>
</Value>
<Value name="20">
<Value>ListNo</Value>
</Value>
<Value name="21">
<Value>ModifyDate</Value>
</Value>
<Value name="22">
<Value>ModifyTime</Value>
</Value>
<Value name="23">
<Value>PateintID</Value>
</Value>
<Value name="24">
<Value>ECRecordID</Value>
</Value>
<Value name="25">
<Value>CreateDate</Value>
</Value>
<Value name="26">
<Value>CreateTime</Value>
</Value>
<Value name="27">
<Value>Title</Value>
</Value>
<Value name="28">
<Value>GroupItemID</Value>
</Value>
<Value name="29">
<Value>GroupItemName</Value>
</Value>
<Value name="30">
<Value>Log</Value>
</Value>
<Value name="31">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Instances")</DataLocation>
<DefaultData>InstanceDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Instances")</IdLocation>
<IndexLocation>^DHCEPRI.InstanceDataI</IndexLocation>
<StreamLocation>^DHCEPRI.InstanceDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
