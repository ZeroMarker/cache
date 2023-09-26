/// 名称:EMRservice.Tools.SelectEmrRecordData
/// 描述:统计在院，出院患者病程记录，以及数量
/// 编写者：yejian
/// 编写日期: 2020-8-6
Class EMRservice.Tools.SelectEmrRecordData Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:     取患者列表
/// creator:  YEJIAN
/// Input:    Aparam 在院和出院：all,在院:in ,出院：out
/// 		  OutStdate:出院开始日期
/// 		  OutEnddate:出院结束日期
/// 		  ChartItemID:病程记录的EMRinstance.ECRecord的ChartItemID
///           AIsArrivedQue 是否到达
/// Debug:    d ##class(%ResultSet).RunQuery("EMRservice.Tools.SelectEmrRecordData","GetPaAdmList","all","2019-1-31","2019-4-16","")
Query GetPaAdmList(Aparam As %String, OutStdate As %String, OutEnddate As %String, ChartItemID As %String) As websys.Query(ROWSPEC = "ind:%String,EpisodeID:%String,PAPMIName:%String,ResidentDays:%String,TitleNames:%String,resCount:%Integer") [ SqlProc ]
{
}

ClassMethod GetPaAdmListExecute(ByRef qHandle As %Binary, Aparam As %String, OutStdate As %String, OutEnddate As %String, ChartItemID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)

	s sysOutStdate=##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",OutStdate)
	s sysOutEnddate=##class(EMRservice.BOCreateRecords).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",OutEnddate)
	
	if (Aparam '="out"){
		s WardID = 0
		for {
			s WardID = $o(^PAWARD(WardID))
			q:(WardID = "")||('$ISVALIDNUM(WardID))
			s objWard = $g(^PAWARD(+WardID))
			continue:(objWard = "")
			s IsWardActive = $p(objWard,"^",6)
			continue:(IsWardActive '= "Y")
			continue:'$d(^PAADMi("CurrWard",WardID))
			s RoomID = 0
			for {
				s RoomID = $o(^PAADMi("CurrWard",WardID,RoomID))
				q:(RoomID = "")
				s EpisodeID = ""
				for {
					s EpisodeID = $o(^PAADMi("CurrWard",WardID,RoomID,EpisodeID))
					q:(EpisodeID = "")
					if (EpisodeID = "67")
					{
						s str = ""
					}
					d outputrow
				}
			}
		}	
	}
	if (Aparam '="in"){
		if (sysOutStdate '= "")&&(sysOutEnddate '= "")
		{
			for DischgDate = sysOutStdate:1:sysOutEnddate 
			{
				s EpisodeID = ""
				//w "按时间段查询",!
				for {	
					s EpisodeID = $o(^PAADMi("DischDate",DischgDate,EpisodeID))
					q:(EpisodeID = "")
					if (EpisodeID = "67")
					{
						s str = ""
					}
					d outputrow
				}
				
			}			
		}
	}
	Quit $$$OK
outputrow
	s mCurrRow = $g(^PAADM(EpisodeID))
	//排除有记录数据
	s Ecrowid = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeID,ChartItemID,""))
	q:(Ecrowid = "")
	s mradm = $p(^PAADM(EpisodeID),"^",61)
	s PAPMIDR = $p($g(mCurrRow),"^",1)

	s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)

	s ResidentDays = ##class(EMRservice.HISInterface.PatientInfoAssist).ResidentDaysAdm(EpisodeID,"")

	s InstanceID=""
	s TitleNames = ""
	s AStatus = " SAVE"
	s resCount = 0
	s eRowid = ""
	for
	{
		s eRowid = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeID,ChartItemID,eRowid))
		q:(eRowid = "")
		s objEcreord = ##Class(EMRinstance.ECRecord).%OpenId(eRowid)
		//只取重复的非连续加载病历
		//continue:((objEcreord.ChartItemType '= "Multiple")||(objEcreord.DocumentCharacteristic '="0"))
		
		Set key = ""
		do
		{ 
	    	S objInstanceData = objEcreord.Instances.GetNext(.key)
		    if (objInstanceData '= "")
	     	{ 
		     	continue:(objInstanceData.Status'="Save")
		     	s InstanceID = objInstanceData.%Id()
			    s startInDate=objInstanceData.CreateDate
				//s startIntTime=objInstanceData.CreateTime
				//s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
				//s ipAddress=##Class(EMRservice.SystemParameter).GetServerIP()
				s TitleName = objInstanceData.Title _" "_$zd(startInDate,3)
				s TitleNames = $case(TitleNames,"":TitleName,:TitleNames _"^"_TitleName)
				s resCount=resCount+1	
		  	} 
 		 } 
 		 while (key '="" )
	}
    
	;s ^temp("emrlog")=$LB(ind,EpisodeID,PAPMIName,ResidentDays,TitleNames,resCount)
	set ^CacheTemp(repid,ind) = $LB(ind,EpisodeID,PAPMIName,ResidentDays,TitleNames,resCount)
	set ind = ind + 1
	Quit
}

ClassMethod GetPaAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaAdmListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPaAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaAdmListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
