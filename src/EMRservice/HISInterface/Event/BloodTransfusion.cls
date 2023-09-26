/// Desc:       输血事件接口
/// Creator:    Candy
/// CreateDate: 2015-4-13
Class EMRservice.HISInterface.Event.BloodTransfusion Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       写入输血事件数据(数据推送接口)
/// Creator:    Candy
/// CreateDate: 2015-4-13
/// Input:      APatientID 病人ID
///             AEpisodeID 就诊号
///             AOEordItemID 输血医嘱
///             ATransDate (cache内部格式) 输血日期
///             ATransTime (cache内部格式) 输血时间
///             ABloodTypeabo abo型血
///             ABloodTyperh rh型血
///             AContent 申请内容
///             ADescription 描述
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.HISInterface.Event.BloodTransfusion).SetData(48,76,"1||1","身体检查",63634,36676,"O","N","test","testDesc")
ClassMethod SetData(APatientID As %String, AEpisodeID As %String, AOEordItemID As %String, AOEordItemDesc As %String, ATransDate As %String, ATransTime As %String, ABloodTypeabo As %String, ABloodTyperh As %String, AContent As %String, ADescription As %String) As %String
{
	s result = ##Class(EMRservice.BL.Event.BLBloodTransfusion).SetData(APatientID, AEpisodeID, AOEordItemID, AOEordItemDesc, ATransDate, ATransTime, ABloodTypeabo, ABloodTyperh, AContent, ADescription)
	q result
}

/// Creator:	Donglulu
/// CreatDate:  2020-01-02
/// Desc:		取该DocID下所有知情同意列表接口
/// Input：		EpisodeID:就诊号，DocID:病历展现结构ID
/// Return：	AInstanceID:病历ID
///             ATitle:病历名称
///             ACreateor:创建者
///             AHappendDate:创建日期
///             AHappendTime:创建时间
///             AIsLink:是否已与输血申请单rowid关联
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.HISInterface.Event.BloodTransfusion","GetInformedConsentList","24","94")
Query GetInformedConsentList(EpisodeID As %String, DocID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "AInstanceID:%String,ATitle:%String,ACreateor:%String,AHappendDate:%String,AHappendTime:%String,AIsLink:%String")
{
}

ClassMethod GetInformedConsentListExecute(ByRef qHandle As %Binary, EpisodeID As %String, DocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	Quit:(EpisodeID="")||(DocID="") $$$OK
	
	for k=1:1:$l(DocID,",")
	{
		s tempADocId = $p(DocID,",",k)
		s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeID,tempADocId,""))
		continue:(ecrecordId = "")
		
		s objEcrecod =  ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
		continue:(objEcrecod = "")

		s date = ""
		for
		{
			s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE",date))
			q:(date = "")
			
			s time = ""
			for
			{
				s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE",date,time))	
				q:(time = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE",date,time,subId))			
					q:(subId = "")
					s AInstanceID = ecrecordId_"||"_subId
					
					s isLink = "N"
					s linkID = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxInstanceType"," "_AInstanceID," BLOODTRANSFUSION",""))
					s:(linkID '= "") isLink = "Y"
					
					s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
					q:(objInstance = "")
					
					s title = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(objInstance.Title)
					
					s num = objInstance.ListNo
					s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(EpisodeID,tempADocId,num)
					s creator = $tr($p(log,"^",1)," ","")
					
					s happendate = objInstance.HappenDate
					s happentime = objInstance.HappenTime
					
					s isSign = ##Class(EMRservice.BL.BLTemplateSign).HasRecordSign(EpisodeID,tempADocId,num)
					continue:(isSign = "0")
					s data = $LB(AInstanceID,title,creator,happendate,happentime,isLink)
					s ^CacheTemp(repid,ind) = data
					s ind=ind+1 		
				}
			}
		}
	}
	q $$$OK
}

ClassMethod GetInformedConsentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInformedConsentListExecute ]
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
	q $$$OK
}

ClassMethod GetInformedConsentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInformedConsentListExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:保存或修改输血ID与instanceID关系
/// Creator:Donglulu
/// CreateDate:2019-1-15
/// Input:      ABloodID 输血申请单ID
///             AInstanceID 病历实例ID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.HISInterface.Event.BloodTransfusion).SaveDataLink(1,"340||1")
ClassMethod SaveDataLink(ABloodID As %String, AInstanceID As %String) As %String
{
	s result = ##Class(EMRservice.BL.Event.BLBloodTransfusion).SaveDataLink(ABloodID, AInstanceID)
	q result
}

/// Desc:取输血知情同意数据内容接口
/// Creator:Donglulu
/// CreateDate:2019-1-15
/// Input:      AInstanceID 病历实例ID
/// Output:     json串
/// Debug:      w ##Class(EMRservice.HISInterface.Event.BloodTransfusion).GetInformedConsentContent("340||1")
ClassMethod GetInformedConsentContent(AInstanceID As %String) As %String
{
	s result = ##Class(EMRservice.BL.Event.BLBloodTransfusion).GetInformedConsentContent(AInstanceID)
	q result
}

/// Desc:取输血知情同意DocID接口
/// Creator:Donglulu
/// CreateDate:2019-1-15
/// Input:      
/// Output:     输血知情同意DocID
/// Debug:      w ##Class(EMRservice.HISInterface.Event.BloodTransfusion).GetInformedConsentDocID()
ClassMethod GetInformedConsentDocID() As %String
{
	s result = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("InformedConsentDocID","")
	q result
}

}
