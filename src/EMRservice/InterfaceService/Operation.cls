/// Desc:       手术事件接口
Class EMRservice.InterfaceService.Operation Extends %RegisteredObject
{

/// Desc:       查询当前未关联的病历和关联到手术ID的病历
///             若手术ID不为空，则通过就诊号跟DocID获取当前未关联的病历和关联到手术ID的病历；
///             若手术ID为空，则通过就诊号跟DocID获取当前未关联的病历；
/// Creator:    Lina
/// CreateTime: 2019-12-4
/// Input：     AEpisodeID   就诊号
///             AOpaID       手术ID
///             ADocID       目录展现结构挂模板一层的目录ID
/// Return：    happenDate   病历完成日期(YY-MM-DD)
///             happenTime   病历完成时间(HH-MM-SS)
///             title        病历名称
///             creator      创建病历者
///             isLink       是否关联,"0"：未关联；"1"：已关联
///             insID        病历ID
/// Debug:      d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.Operation","GetOperativeRecord","4","","68")
Query GetOperativeRecord(AEpisodeID As %String, AOpaID As %String, ADocID As %String) As %Query(ROWSPEC = "happenDate:%String,happenTime:%String,title:%String,creator:%String,isLink:%String,insID:%String")
{
}

ClassMethod GetOperativeRecordExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AOpaID As %String, ADocID As %String) As %Status
{
    s repid = $i(^CacheTemp)
    s ind = 1
    s qHandle = $lb(0,repid,0)
    q:(($g(AEpisodeID) = "")||($g(ADocID) = "")) $$$OK
    s opaRowId = ""
    s:(AOpaID '= "") opaRowId = $o(^DHCEMRI.Events.OperationI("IdxOpaID"," "_AOpaID,""))
    
    s emrDocId=""
    for 
    {
	    s emrDocId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_ADocID,emrDocId))
	    q:(emrDocId="")
	    s ecrecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,emrDocId,""))
	    continue:(ecrecordID = "")
    s date = ""
    for
    {
        s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordID," SAVE",date))
        q:(date = "")
        s time = ""
        for
        {
            s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordID," SAVE",date,time))    
            q:(time = "")
            s subId = ""
            for
            {
                s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordID," SAVE",date,time,subId))         
                q:(subId = "")
                s rowId = ecrecordID_"||"_subId
                s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
                s happenDate = $zd(objInstance.HappenDate,3)
                s happenTime = $zt(objInstance.HappenTime)
                s title = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(objInstance.Title)
                s creator = ##class(EMRservice.BL.BLPowerUser).GetUserName(objInstance.CreateUser)
                s creator = $ZSTRIP(creator,"*C")
                //病历是否关联
                s isLink = $d(^DHCEMRI.Events.LinkDocumnentsI("IdxInstanceType"," "_rowId," OPERATION"))
                s isLink = $Case(isLink>0,1:"1",:"0")
                if (isLink = "1")
                {
                    s linkRowId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxInstanceType"," "_rowId," OPERATION",""))
                    s objLink = ##Class(EMRinstance.Events.LinkDocumnents).%OpenId(linkRowId)
                    q:(objLink.EventsID '= opaRowId)
                }
                s ^CacheTemp(repid,ind) = $lb(happenDate,happenTime,title,creator,isLink,rowId)
                s ind = ind + 1
            }
        }
    }
    
    }
    Quit $$$OK
}

ClassMethod GetOperativeRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperativeRecordExecute ]
{
    s repid=$list(qHandle,2)
    k ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetOperativeRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperativeRecordExecute ]
{
    s AtEnd=$list(qHandle,1)
    s repid=$list(qHandle,2)
    s ind=$list(qHandle,3)
    s ind=$o(^CacheTemp(repid,ind))
    if ind="" { 
        s AtEnd=1
        s Row=""
        k ^CacheTemp(repid)
    } else {
        s Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Desc:       根据AFlag来设置病历与手术申请的关联关系
/// Creator:    Lina
/// CreateTime: 2019-12-4
/// Input：     AOpaID       手术ID
///             AInstanceID  病历ID
///             AFlag        "0"：取消关联；"1"：设置关联
/// Return：    result       "0"|取消/设置关联失败原因：关联失败|原因；
///                          "1"：取消/设置关联成功
/// Debug:      w ##Class(EMRservice.InterfaceService.Operation).setLinkByFlag("10","97||3","1")
ClassMethod setLinkByFlag(AOpaID As %String, AInstanceID As %String, AFlag As %String) As %String
{
    s result = "0"
    q:(AOpaID = "")||(AInstanceID = "") result_"|入参为空！"
    s eventsId = $o(^DHCEMRI.Events.OperationI("IdxOpaID"," "_AOpaID,""))
    q:(eventsId = "") result_"|请先申请手术！"
    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    q:(objInstance = "")||($zcvt(objInstance.Status,"U") '= "SAVE") result_"|病历不可用！"
    
    if (AFlag = "1")
    {
        s rowId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxInstanceType"," "_AInstanceID," OPERATION",""))
        if (rowId = "")
        {
            s obj = ##Class(EMRinstance.Events.LinkDocumnents).%New()
            s obj.EpisodeID = objInstance.RealEpisodeID
            s obj.EventsID = eventsId
            s obj.EventType =  "Operation"
            s obj.PatientID =  ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(objInstance.RealEpisodeID)
            s obj.InstanceID  = AInstanceID
            s obj.ChartItemID = objInstance.TheECRecord.RealChartItemID
            s obj.TitleCode = objInstance.TitleCode
            if ($$$ISOK(obj.%Save()))
            {
                s result = "1"
            }
            else
            {
                s result = "0|病历关联手术失败！"
            }
        }
        else
        {
            s obj = ##Class(EMRinstance.Events.LinkDocumnents).%OpenId(rowId)
            if (obj.EventsID = eventsId)
            {
                s result = "1"
            }
            else
            {
                s result = "0|该病历已经关联到其他手术！"
            }
        }
    }
    elseif (AFlag = "0")
    {
        s rowId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxMain"," "_objInstance.RealEpisodeID," OPERATION"," "_eventsId," "_AInstanceID,""))
        if (rowId '= "")
        {
            s obj = ##Class(EMRinstance.Events.LinkDocumnents).%OpenId(rowId)
            if (obj.EventsID = eventsId)
            {
                if ('$$$ISOK(obj.%DeleteId(rowId)))
                {
                    s result = "0|病历取消关联手术失败！"
                }
                else
                {
                    s result = "1"
                }
            }
            else
            {
                s result = "0|该病历未与该次手术关联，所以无法取消关联！"
            }
        }
        else
        {
            s result = "0|该病历未与该次手术关联，所以无法取消关联！"
        }
    }
    q result
}

/// Desc:       根据手术ID读取关联病历文书实例ID
/// Creator:    Lina
/// CreateTime: 2019-12-5
/// Input：     AEpisodeID   就诊号
///             AOpaID       手术ID
/// Return：    insID        病历ID
///             docID        目录展现结构挂模板一层的目录ID
///             title        病历名称
///             creator      创建病历者
///             browseUrl    浏览病历链接
/// Debug:      d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.Operation","GetLinkRecordByOpaID","4","10")
Query GetLinkRecordByOpaID(AEpisodeID As %String, AOpaID As %String) As %Query(ROWSPEC = "insID:%String,docID:%String,title:%String,creator:%String,browseUrl:%String")
{
}

ClassMethod GetLinkRecordByOpaIDExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AOpaID As %String) As %Status
{
    s repid = $i(^CacheTemp)
    s ind = 1
    s qHandle = $lb(0,repid,0)
    q:(($g(AEpisodeID) = "")||($g(AOpaID) = "")) $$$OK
    s rowId = $o(^DHCEMRI.Events.OperationI("IdxOpaID"," "_AOpaID,""))
    q:(rowId = "") $$$OK
    s objOperateion = ##Class(EMRinstance.Events.Operation).%OpenId(rowId)
    q:(objOperateion = "") $$$OK
    
    s InstanceId = ""
    s version = "" 
    if (##Class(%Dictionary.CompiledClass).%ExistsId("EMR.DOC.BL.GlobalData")'=0){
   		s version = ##Class(EMR.DOC.BL.GlobalData).GetEMRVersionID(AEpisodeID)
    }
    if (version="4"){
	    d GetEMR4
	    }else{
		  d GetEMR3  
		}
	Quit $$$OK
GetEMR3
    for
    {
        s InstanceId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxMain"," "_objOperateion.EpisodeID," OPERATION"," "_rowId,InstanceId))
        q:(InstanceId = "")
        s tempInstanceId = $tr(InstanceId," ","")
        s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tempInstanceId)
        continue:($zcvt(objInstance.Status,"U") '= "SAVE")
        s docID = objInstance.TheECRecord.RealChartItemID
        s title = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(objInstance.Title)
        s creator = ##class(EMRservice.BL.BLPowerUser).GetUserName(objInstance.CreateUser)
        s creator = $ZSTRIP(creator,"*C")
        s browseUrl = "emr.record.browse.browsform.editor.csp?id="_tempInstanceId_"&episodeId="_objInstance.RealEpisodeID_"&Action=""BROWSE"""
        if (##Class(%Dictionary.CompiledClass).%ExistsId("EMR.IP.BL.View.Browse")'=0){
        	s browseUrl = "emr.bs.browse.browsform.html.csp?recordID="_tempInstanceId_"&EpisodeID="_objInstance.RealEpisodeID_"&emrVersion=emr3"_"&Action=""BROWSE"""
        }
        s ^CacheTemp(repid,ind) = $lb(tempInstanceId,docID,title,creator,browseUrl)
        s ind = ind + 1
    }
    q
GetEMR4  
	q
}

ClassMethod GetLinkRecordByOpaIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLinkRecordByOpaIDExecute ]
{
    s repid=$list(qHandle,2)
    k ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetLinkRecordByOpaIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLinkRecordByOpaIDExecute ]
{
    s AtEnd=$list(qHandle,1)
    s repid=$list(qHandle,2)
    s ind=$list(qHandle,3)
    s ind=$o(^CacheTemp(repid,ind))
    if ind="" { 
        s AtEnd=1
        s Row=""
        k ^CacheTemp(repid)
    } else {
        s Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

}
