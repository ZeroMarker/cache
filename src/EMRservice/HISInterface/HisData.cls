/// Desc:        对外接口
/// Creator:     Candy
/// CreateDate:  2017-11-9
/// Input:       pType 科室类型 多个类型用","分隔
/// Output:      rowID,Code,Desc,Type
/// Debug:       d ##Class(%ResultSet).RunQuery("EMRservice.HISInterface.HisData","GetLocByType","") 
Class EMRservice.HISInterface.HisData Extends (%RegisteredObject, %XML.Adaptor)
{

Query GetLocByType(pType As %String, pText As %String) As %Query(ROWSPEC = "rowID:%String,Code:%String,Desc:%String,Type:%String")
{
}

ClassMethod GetLocByTypeExecute(ByRef qHandle As %Binary, pType As %String, pText As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
 	
 	if (pType = "")
 	{
	 	s tmpType = ""
	 	for
	 	{
		 	s tmpType = $o(^CTLOC(0,"LocType",tmpType))
		 	q:(tmpType = "")
		 	d getData
		}
	}
	else
	{
	 	for i=1:1:$l(pType,",")
	 	{
		 	s tmpType = $p(pType,",",i)
		 	d getData
	 	}
	}
	Quit $$$OK
getData
 	s rowId = ""
	for
	{
		s rowId = $o(^CTLOC(0,"LocType",$zcvt(tmpType,"U"),rowId))
		q:(rowId = "")
		continue:($d(^CTLOC(rowId))=0)
		s code = $p(^CTLOC(rowId),"^",1)
		s desc = $p(^CTLOC(rowId),"^",2)
		continue:((pText '= "")&&($zcvt(desc,"U")'[ $zcvt(pText,"U")))
		s ^CacheTemp(repid,ind) = $lb(rowId,code,desc,tmpType)
		s ind=ind+1
	}
}

ClassMethod GetLocByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:     Candy
/// CreateDate:  2017-11-9
/// Input:       pType 科室类型 多个类型用","分隔
/// Output:      rowID,Code,Desc,Type
/// Debug:       d ##Class(EMRservice.HISInterface.HisData).GetLocListbyType("zx","E") 
ClassMethod GetLocListbyType(pType As %String, pText As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.HISInterface.HisData:GetLocByType")
	d ds.Execute(pType,pText)
	d json.Write("[")
	While (ds.Next())
	{
		d:(json.Size>1) json.Write(",")
		d json.Write("{")
		d json.Write("""RowID"":"""_ds.Data("rowID")_"""")
		d json.Write(",""Code"":"""_ds.Data("Code")_"""")
		d json.Write(",""Desc"":"""_ds.Data("Desc")_"""")
		d json.Write(",""Type"":"""_ds.Data("Type")_"""")			
		d json.Write("}")
	}
	d json.Write("]")
	q json
}

/// Desc:     判断本次就诊所书写门诊病历的打印状态
/// CreatDate:2018-12-21
/// Creator:  Lina
/// Input:    AEpisodeID 就诊号
/// Output:   ret格式：{episodeId:"",hasNoPrinted:"1","documents":[{"instanceId":"1||1","isprinted":"1"},{"instanceId":"2||1","isprinted":"0"},……]}
/// Debug:    w ##Class(EMRservice.HISInterface.HisData).GetInstancePrintedStatus("2167") 
ClassMethod GetInstancePrintedStatus(AEpisodeID As %String) As %String
{
	s ret = "",item = "",isprinted="",unPrintedCount=""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	//判断新版全局图表是否包含就诊，如果包含走四版接口
    if (##class(%Dictionary.CompiledClass).%ExistsId("EMR.GB.GlobalData") '= "0")
	{
		s HasData = $o(^EMR.GB.GlobalDataI("IdxMain",AEpisodeID,""))
		if (HasData'="")
		{
			s json = ##class(EMR.OP.BL.DocumentViewPrint).GetDocumentPrintedStatus(AEpisodeID)
			q json
		}
	}
	
	s unPrintedCount = 0
	s CategoryID = ""
	for {
		s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID))
		q:(CategoryID="")

		s ecRecordID = "" 
		for {
			s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID, ecRecordID))
			s ecRecordID = $tr(ecRecordID," ","")
			s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ecRecordID)
			q:(objECRecord="")
			
			s instanceCount = objECRecord.InstanceCount
			for idx = 1:1:instanceCount { 
				s isprinted = 0
				s objInstance = objECRecord.Instances.GetAt(idx)
				q:(objInstance = "") 
				continue:(objInstance.Status '= "Save")
				//是否过滤无有效签名或无签名病历
				s signFlag = ##Class(EMRservice.BOPrivAssist).HasValidSign(objInstance.%Id())
				continue:(signFlag = 0)
			    s docId = objECRecord.RealChartItemID
			    s num = objInstance.ListNo
			    s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(AEpisodeID,docId,num)
			    //获取病历日志明细最后一次操作的Action名字
				s action = $p(log,"^",8)
				s:(action '= "print") action = ""
				if (action '= "") {
					s isprinted = "1"
				}else {
					s unPrintedCount = unPrintedCount + 1
				}
			    s:(item '= "") item = item_","
				d OutPutToJson
			}
		}
	}
	if (item = "") {
		s ret = "{""episodeId"":"""_AEpisodeID_""",""hasNoPrinted"":0}"
	}else {
		s ret = "{""episodeId"":"""_AEpisodeID_""",""hasNoPrinted"":"_unPrintedCount
		s ret = ret_",""documents"":["_item_"]"
		s ret = ret_"}"
	}
	q ret
OutPutToJson
    s item = item_"{""instanceId"":"""_objInstance.%Id()
    s item = item_""",""isprinted"":"""_isprinted_"""}"
    q
}

/// Desc:  调用医生站接口设置患者到达状态
/// CreatDate:2020-05-08
/// Creator:yan
/// Input: AEpisodeID 就诊号
///        ALocID     科室ID
///        AUserID    用户ID
/// Debug: w ##Class(EMRservice.HISInterface.HisData).SetArrivedStatus("26603","231","10327")
ClassMethod SetArrivedStatus(AEpisodeID As %String, ALocID As %String, AUserID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "")||(ALocID = "")||(AUserID = "") ret
	try{
		s ret = ##class(web.DHCDocOrderEntry).SetArrivedStatusNew(AEpisodeID,ALocID,AUserID)
	}catch{
		s ret = ""
	}
	q ret
}

}
