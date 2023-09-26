Class web.DHCMRClinicalPathWays Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator:		周志强          
/// CreatDate:		2010.03.13   
/// Description:	得到所使用的临床路径记录集
/// Table:        	MR_ClinicalPathWays,MRC_ClinicalPathways
/// Input:        	EpisodeID:就诊指针
/// Return:       	
/// Others:			d ##class(%ResultSet).RunQuery("web.DHCMRClinicalPathWays","FindMRClinicalPathWays","")
Query FindMRClinicalPathWays(EpisodeID As %String) As %Query(ROWSPEC = "TCliParhWayRowid:%String,TClinicalPathWay:%String,TStatus:%String,TStartDate:%String,TEndDate:%String,TDelDate:%String,TDelTime:%String,TCareProvider:%String,TDiagnos:%String,TReason:%String")
{
}

ClassMethod FindMRClinicalPathWaysExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	s TCliParhWayRowid="",TClinicalPathWay="",TStatus="",TStartDate="",TEndDate="",TDelDate="",TDelTime="",TDiagnos=""
 	s PWPathwaysDR="",CPWUsedFlag="",CPWIDDate="",CPWIDTime="",CPWStatusDR="",CPWDate=""
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    i EpisodeID="" Quit $$$OK
    
	s MRAdmID=$p($g(^PAADM(EpisodeID)),"^",61)
	i MRAdmID'=""{
		s CPWChildsub=0
		for  s CPWChildsub=$o(^MR(MRAdmID,"CPW",CPWChildsub)) Q:CPWChildsub=""  d
		.s TClinicalPathWay=""
		.s PWPathwaysDR=$P(^MR(MRAdmID,"CPW",CPWChildsub),"^",1)
		.s TCliParhWayRowid=PWPathwaysDR
		.i TCliParhWayRowid'="" s TClinicalPathWay=$p(^MRC("CPW",TCliParhWayRowid),"^",2)
		.;
		.s CPWUsedFlag=$P(^MR(MRAdmID,"CPW",CPWChildsub),"^",2)	;CPW_Pathways_DR 临床路径
		.;
		.s CPWIDDate=$P(^MR(MRAdmID,"CPW",CPWChildsub),"^",3)	;CPW_IDDate 插入日期
		.i CPWIDDate'="" s TDelDate=$zd(CPWIDDate,3)
		.s CPWIDTime=$P(^MR(MRAdmID,"CPW",CPWChildsub),"^",4)	;CPW_IDTime 插入时间
		.i CPWIDTime'="" s TDelTime=$zt(CPWIDTime)
		.;
		.s CPWStatusDR=$P(^MR(MRAdmID,"CPW",CPWChildsub),"^",6)	;CPW_Staus_DR 状态
		.i CPWStatusDR'="" s TStatus=$p(^MRC("CLPS",CPWStatusDR),"^",2)
		.;
		.s CPWDate=$P(^MR(MRAdmID,"CPW",CPWChildsub),"^",9)    ;CPW_Date 入径日期 
		.i CPWDate'="" s TStartDate=$zd(CPWDate,3)
		.s TEndDate=$P(^MR(MRAdmID,"CPW",CPWChildsub),"^",10)  ;CPW_ProblemReviewDate 出径日期
		.i TEndDate'="" s TEndDate=$zd(TEndDate,3)
		.
		.s TCareProvider=""
		.s CPWCPRowId=$P(^MR(MRAdmID,"CPW",CPWChildsub),"^",12)    ;CPW_CareProvider_DR
		.if CPWCPRowId'="" s TCareProvider=$P(^CTPCP(CPWCPRowId,1),"^",2)
		.
		.s TReason=""
		.s CPWReasonRowId=$P(^MR(MRAdmID,"CPW",CPWChildsub),"^",15)	;CPW_VarianceReason_DR
		.i CPWReasonRowId'="" s TReason=$p($g(^MRC("VR",CPWReasonRowId)),"^",2)
		.Do OutputRow10
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow10
	set Data=$lb(TCliParhWayRowid,TClinicalPathWay,TStatus,TStartDate,TEndDate,TDelDate,TDelTime,TCareProvider,TDiagnos,TReason)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMRClinicalPathWaysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMRClinicalPathWaysExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindMRClinicalPathWaysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMRClinicalPathWaysExecute ]
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

/// Creator:      
/// CreatDate:    
/// Description:    取得临床路径代码明细
/// Table:        
/// Input:       
/// Return:     
/// Others:
Query GetMRCCPW() As %Query(ROWSPEC = "CPWRowId:%String,CPWCode:%String,CPWDesc:%String")
{
}

ClassMethod GetMRCCPWExecute(ByRef qHandle As %Binary) As %Status
{
	;^MRC("CPW",{CPW_RowId})
	s CPWCode="",CPWDesc=""
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s CPWRowId=0
	f  s CPWRowId=$o(^MRC("CPW",CPWRowId)) Q:CPWRowId=""  d
	.s CPWCode=$P(^MRC("CPW",CPWRowId),"^",1)
	.s CPWDesc=$P(^MRC("CPW",CPWRowId),"^",2)
	.Do OutputRow11
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow11
	set Data=$lb(CPWRowId,CPWCode,CPWDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMRCCPWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRCCPWExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMRCCPWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRCCPWExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:		周志强          
/// CreatDate:		2010.03.13   
/// Description:	插入新的临床路径,如果已有正在使用的临床路径,则将其状态置为出径Close
/// Table:        	MR_ClinicalPathWays
/// Input:        	EpisodeID:就诊指针,CPWRowId:临床路径指针,CPWDate:入径日期
/// Return:       	0-成功	1-失败
/// Others:			w ##class(web.DHCMRClinicalPathWays).InsertCPWPathWay(243,1,+$H,6)
ClassMethod InsertCPWPathWay(EpisodeID As %String, CPWRowId As %String, CPWDate As %Date, UserRowId As %String)
{
	Q:EpisodeID="" "1"
	i EpisodeID'=""	s MRAdmID=$p($g(^PAADM(EpisodeID)),"^",61) 
	s InUserMRCPWRowId=..GetInUseMRCPW(EpisodeID)
	s CPWCloseStatusDR=$O(^MRC("CLPS",0,"Code","CLS",0))
	if CPWDate="" s CPWDate=+$H
	s CPWStatusDR=$O(^MRC("CLPS",0,"Code","OPN",0))
	s CareProviderRowId=$P(^SSU("SSUSR",UserRowId),"^",14)
	TStart
	if (CPWCloseStatusDR'="")&&(InUserMRCPWRowId'="") {
		s StopDate=+$H
		&SQL(Update SQLUser.MR_ClinicalPathWays 
				Set CPW_Status_DR=:CPWCloseStatusDR,CPW_ProblemReviewDate=:StopDate
			  Where CPW_RowId=:InUserMRCPWRowId)
			  if SQLCODE {
					Trollback 
					Q "1"
			  }
	}
	KILL PLIST
	set PLIST(0)=MRAdmID		       
	Set PLIST(3)=CPWRowId
	Set PLIST(5)=+$h	
	Set PLIST(6)=$p($h,",",2)
	Set PLIST(8)=CPWStatusDR
	Set PLIST(13)=CPWDate
	Set PLIST(17)=CareProviderRowId	 	        
    
	&sql(INSERT INTO SQLUser.MR_ClinicalPathWays Values PLIST()) 
	i SQLCODE {
		Trollback 
		Q "1"
	}
	TC
	Q "0"
}

/// Creator:		周志强          
/// CreatDate:		2010.03.13   
/// Description:	如果已有正在使用的临床路径状态置为出径Close
/// Table:        	MR_ClinicalPathWays
/// Input:        	CPWRowId:临床路径指针
/// Return:       	0-成功	1-失败
/// Others:			w ##class(web.DHCMRClinicalPathWays).UpdateCPWPathWay(243)
ClassMethod UpdateCPWPathWay(CPWRowid As %String, CPWReasonRowId As %String = "") As %String
{
	s CurrentDate=+$H
	s CPWStatusDR=$O(^MRC("CLPS",0,"Code","CLS",0))
	&SQL(Update sqluser.MR_ClinicalPathWays 
	        Set CPW_Status_DR=:CPWStatusDR,
	        CPW_ProblemReviewDate=:CurrentDate,
	        CPW_VarianceReason_DR=:CPWReasonRowId
	      Where CPW_RowId=:CPWRowid)
	if SQLCODE Q 1
	Q 0
}

/// 计算入径和出径数
/// w ##class(web.DHCMRClinicalPathWays).GetMRCPWNumber(243)
ClassMethod GetMRCPWNumber(EpisodeID As %String) As %String
{
	s OpenNumber=0,CloseNumber=0
	s MRAdmID=$p($g(^PAADM(EpisodeID)),"^",61)
	i MRAdmID'=""{
		s CPWChildsub=$o(^MR(MRAdmID,"CPW",0))
		while (CPWChildsub'="") {
			s CPWStatusDR=$P(^MR(MRAdmID,"CPW",CPWChildsub),"^",6)
			i CPWStatusDR'="" {
				s CPWStatusCode=$p(^MRC("CLPS",CPWStatusDR),"^",1)
				if CPWStatusCode="OPN" s OpenNumber=OpenNumber+1
				if CPWStatusCode="CLS" s CloseNumber=CloseNumber+1
			}
			s CPWChildsub=$o(^MR(MRAdmID,"CPW",CPWChildsub))
		}
	}
	Q OpenNumber_"^"_CloseNumber
}

/// Creator:		周志强          
/// CreatDate:		2010.03.13   
/// Description:	获得本次就诊正在使用的临床路径(最后一条记录)
/// Table:        	MR_ClinicalPathWays,MRC_ClinicalPathways
/// Input:        	EpisodeID:就诊指针
/// Return:       	
/// Others:			w ##class(web.DHCMRClinicalPathWays).GetInUseMRCPW(243)
ClassMethod GetInUseMRCPW(EpisodeID As %String) As %String
{
	s PWPathwaysDR=""
	s MRAdmID=$p($g(^PAADM(EpisodeID)),"^",61)
	i MRAdmID'=""{
		s CPWChildsub=$o(^MR(MRAdmID,"CPW",""),-1)
		if CPWChildsub="" Quit ""
		
		s PWPathwaysDR=$P(^MR(MRAdmID,"CPW",CPWChildsub),"^",1)
		s CPWStatusDR=$P(^MR(MRAdmID,"CPW",CPWChildsub),"^",6)
		i CPWStatusDR'="" {
			s CPWStatusCode=$p(^MRC("CLPS",CPWStatusDR),"^",1)
			if CPWStatusCode="OPN" {
				s CPWRowId=$P(^MR(MRAdmID,"CPW",CPWChildsub),"^",1)
				s CPWDate=$P(^MR(MRAdmID,"CPW",CPWChildsub),"^",9)
				;如果临床路径还在使用天数中
				s MaxDays=..GetCPWMaxDays(CPWRowId)
				if MaxDays>((+$H-CPWDate)+1) Q MRAdmID_"||"_CPWChildsub
			}
		}
	}
	
	Q ""
}

ClassMethod GetInUseCPW(EpisodeID As %String) As %String
{
	s InUseCPWRowId="" 
	s InUseMRCPW=..GetInUseMRCPW(EpisodeID)
	i InUseMRCPW'="" {
		s InUseCPWRowId=$P(^MR(+InUseMRCPW,"CPW",$P(InUseMRCPW,"||",2)),"^",1)
	}
	Q InUseCPWRowId
}

/// Creator:		周志强          
/// CreatDate:		2010.03.13   
/// Description:	获得临床路径的最长使用天数
/// Table:        	MRC_ClinicalPathways
/// Input:        	CPWRowId:临床指针
/// Return:       	最长天数
/// Others:			w ##class(web.DHCMRClinicalPathWays).GetCPWMaxDays(1)
ClassMethod GetCPWMaxDays(CPWRowId As %String) As %String
{
	s maxdays=0
	s CPWEPRowId=$o(^MRC("CPW",CPWRowId,"EP",0))
	if CPWEPRowId'=""  {
		s DAYSChildsub=$O(^MRC("CPW",CPWRowId,"EP",CPWEPRowId,"DAYS",0))
		while (DAYSChildsub'=""){
			s days=$p(^MRC("CPW",CPWRowId,"EP",CPWEPRowId,"DAYS",DAYSChildsub),"^",3)
			if days="" {
				s DAYSChildsub=$O(^MRC("CPW",CPWRowId,"EP",CPWEPRowId,"DAYS",DAYSChildsub))
				continue
			}
			if days>maxdays s maxdays=days
			s DAYSChildsub=$O(^MRC("CPW",CPWRowId,"EP",CPWEPRowId,"DAYS",DAYSChildsub))
		}
	}
	Q maxdays
}

/// Creator:		周志强    
/// CreatDate:    	2010.03.12
/// Description:    取得临床路径使用到某天的医嘱套定义
/// Table:			User.MRCClinPathwEpDays      
/// Input:			EpisodeID:就诊指针  CurrenDate:使用日期   
/// Return:      
/// Others:			d ##class(%ResultSet).RunQuery("web.DHCMRClinicalPathWays","FIndMRCCPWEPOS",243,+$H)
Query FIndMRCCPWEPOS(EpisodeID As %String, CurrenDate As %Date = "") As %Query(ROWSPEC = "Item:%String,ItemQty:%String,ItemBillUOM:%String,ItemDoseQty:%String,ItemDoseUOM:%String,ItemFreq:%String,ItemInstr:%String,ItemDur:%String,ItemData:%String,ItemRowid:%String,ItemOrderType:%String,ItemPrice:%String,ItemSeqNo:%String")
{
}

ClassMethod FIndMRCCPWEPOSExecute(ByRef qHandle As %Binary, EpisodeID As %String, CurrenDate As %Date = "") As %Status
{
 	Set repid1=$I(^CacheTemp)
    If $g(ind1)="" Set ind1=1
	s MRCPWRowId=..GetInUseMRCPW(EpisodeID)

	if MRCPWRowId'="" {
		s CPWRowId=$P(^MR(+MRCPWRowId,"CPW",$P(MRCPWRowId,"||",2)),"^",1)
		s MRCPWDate=$P(^MR(+MRCPWRowId,"CPW",$P(MRCPWRowId,"||",2)),"^",9)
		i CurrenDate="" s CurrenDate=+$H
		s inter=CurrenDate-MRCPWDate+1
	
		s CPWEPRowId=$o(^MRC("CPW",CPWRowId,"EP",0))
		if CPWEPRowId'=""  {
			s DAYSChildsub=$O(^MRC("CPW",CPWRowId,"EP",CPWEPRowId,"DAYS",0))
			while (DAYSChildsub'=""){
				s days=$p(^MRC("CPW",CPWRowId,"EP",CPWEPRowId,"DAYS",DAYSChildsub),"^",3)
				if days="" {
					s DAYSChildsub=$O(^MRC("CPW",CPWRowId,"EP",CPWEPRowId,"DAYS",DAYSChildsub))
					Continue
				}
				if days=inter {
					s OSChildsub=$O(^MRC("CPW",CPWRowId,"EP",CPWEPRowId,"DAYS",DAYSChildsub,"OS",0))
					while OSChildsub'="" {
						s OSRowId=$P(^MRC("CPW",CPWRowId,"EP",CPWEPRowId,"DAYS",DAYSChildsub,"OS",OSChildsub),"^",1)
						s ARCIMRowId=$P(^MRC("CPW",CPWRowId,"EP",CPWEPRowId,"DAYS",DAYSChildsub,"OS",OSChildsub),"^",2)
						Set rs=##Class(%ResultSet).%New("web.DHCDocOrderCommon:FindOSItems")
						d rs.Execute(OSRowId)
						Set columns = rs.GetColumnCount()
						While (rs.Next()) {
							s Data=""
							For i = 1:1:columns  {
								s $List(Data,i)=rs.GetData(i)
							}
							d OutputRow
						}
						d rs.Close()
						s OSChildsub=$O(^MRC("CPW",CPWRowId,"EP",CPWEPRowId,"DAYS",DAYSChildsub,"OS",OSChildsub))
					} 
				}
				s DAYSChildsub=$O(^MRC("CPW",CPWRowId,"EP",CPWEPRowId,"DAYS",DAYSChildsub))
			}
		}
	}
	Set qHandle=$lb(0,repid1,0)
	Quit $$$OK
OutputRow
	Set ^CacheTemp(repid1,ind1)=Data
 	Set ind1=ind1+1
	quit
}

ClassMethod FIndMRCCPWEPOSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FIndMRCCPWEPOSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FIndMRCCPWEPOSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FIndMRCCPWEPOSExecute ]
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

ClassMethod FindClinicPathWayByICD(ICDRowId As %String) As %String
{
	Q $P($g(^MRC("ID",ICDRowId,"DHC")),"^",1)
}

/// Creator:		周志强          
/// CreatDate:		2010.03.13   
/// Description:	将临床路径对应的医嘱直接增加到界面上
/// Table:        	MR_ClinicalPathWays,MRC_ClinicalPathways
/// Input:        	EpisodeID:就诊指针
/// Return:       	
/// Others:			w ##class(web.DHCMRClinicalPathWays).AddMRCPWItemToList("AddCopyItemToList","","")
ClassMethod AddMRCPWItemToList(itmjs As %Library.String = "", itmjsex As %Library.String = "", EpisodeID As %String) As %String
{
	Set retval=""
	Set rs=##Class(%ResultSet).%New("web.DHCMRClinicalPathWays:FIndMRCCPWEPOS")
	d rs.Execute(EpisodeID)
	While (rs.Next()) {
		s code=$ZCVT(rs.Data("ItemRowid"),"O","JS")
		s ItemData=$ZCVT(rs.Data("ItemData"),"O","JS")
		s Type=$ZCVT(rs.Data("ItemOrderType"),"O","JS")
		s OrderSeqNo=$ZCVT(rs.Data("ItemSeqNo"),"O","JS")
		s retval=retval_"Copyary[Copyary.length]="""_code_"!"_OrderSeqNo_"!"_ItemData_"!"_Type_"!!OSItem"";"
		
	}
	d rs.Close()
	if (itmjs'="")&&(retval'="") {
		s retval="var Copyary=new Array();"_retval_itmjs_"(Copyary);"
		&javascript<#(retval)#>
	}
	Q 0
}

/// Creator:		周志强          
/// CreatDate:		2010.03.16   
/// Description:	返回出径原因串
/// Table:        	User.MRCVarianceReason
/// Input:        	
/// Return:       	
/// Others:			w ##class(web.DHCMRClinicalPathWays).GetVarianceReasonStr()
ClassMethod GetVarianceReasonStr() As %String
{
	s ret=""_$C(1)_""
	s rowid=0 f  s rowid=$o(^MRC("VR",rowid)) q:rowid=""  d
	.s code=$p($g(^MRC("VR",rowid)),"^",1)
	.s desc=$p($g(^MRC("VR",rowid)),"^",2)
	.s single=rowid_$C(1)_desc_$C(1)_code
	.i ret="" s ret=single
	.e  s ret=ret_"^"_single
	q ret
}

}
