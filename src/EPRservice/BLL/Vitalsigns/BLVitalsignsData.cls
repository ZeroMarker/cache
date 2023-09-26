/// 名称： EPRservice.BLL.Vitalsigns.BLVitalsignsData
/// 描述:  根据EpisodeID,查询患者指定项目的生命体征信息,并且可以通过时间进行数据的筛选
/// 创建者：Lifengbo
/// 创建时间：2012-05-31
/// d ##class(%ResultSet).RunQuery("EPRservice.BLL.Vitalsigns.BLVitalsignsData","GetVitalsignsData",77128,"ITEM1:体温:℃|ITEM2:脉搏:次/分|ITEM3:舒张压:mmHg|ITEM4:收缩压:mmHg|ITEM5:心率:次/分","2009-07-01","2012-07-09","1","12")
Class EPRservice.BLL.Vitalsigns.BLVitalsignsData Extends %RegisteredObject [ Not ProcedureBlock ]
{

Query GetVitalsignsData(EpisodeID As %String, ArgItemStr As %String, StDate As %String, EndDate As %String, ArgStartPage As %String, ArgEndPage As %String) As %Query(ROWSPEC = "Date:%String,Time:%String,ITEM1:%String,ITEM2:%String,ITEM3:%String,ITEM4:%String,ITEM5:%String,ITEM6:%String")
{
}

ClassMethod GetVitalsignsDataExecute(ByRef qHandle As %Binary, EpisodeID As %String, ArgItemStr As %String, StDate As %String, EndDate As %String, ArgStartPage As %String, ArgEndPage As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	k ^TempVitalsignslfb
	if ((StDate = "")||(StDate = $c(0)))
	{ 
	   s SDate = "" 
	}
	else
	{
	    s SDate = $zdh(StDate,3) - 1
	}
	if ((EndDate = "") ||(EndDate = $c(0)))
	{
	   s EDate = ""
	} 
	else 
	{
	   s EDate = $zdh(EndDate,3)
	}
	s MRADMRowId=$p($g(^PAADM(EpisodeID)),"^",61)
	s ITEMNUM=$l(ArgItemStr,"|")
	f i=1:1:ITEMNUM d
	.s ITMStr=$p(ArgItemStr,"|",i)
	.s ITMDesc=$p(ITMStr,":",2)
	.s ITMUnit=$p(ITMStr,":",3)
	.d GetITMData
	s TotalAmount=0
	d OutputRow
	
	q $$$OK
	
	
GetITMData
	s ITMRowId=""
	f  s ITMRowId=$o(^MRC("OBITM",0,"Desc",ITMDesc,ITMRowId)) q:ITMRowId=""  d
	.d GetITMOBSData
	q
	
GetITMOBSData
	q:ITMRowId=""
	s OBSDate=SDate
	f  s OBSDate=$o(^MR(MRADMRowId,"OBS",0,"Date",OBSDate)) q:((EDate="")&(OBSDate=EDate))!((EDate'="")&((OBSDate>EDate)!(OBSDate="")))  d  
	.s OBSChildsub=""
	.f  s OBSChildsub=$o(^MR(MRADMRowId,"OBS",0,"Date",OBSDate,ITMRowId,OBSChildsub)) q:OBSChildsub=""  d
	..s MROBSStr=$g(^MR(MRADMRowId,"OBS",OBSChildsub))
	..s OBSItemDR=$p(MROBSStr,"^",1)
	..q:OBSItemDR=""
	..s ITMDesc=$p($g(^MRC("OBITM",OBSItemDR)),"^",2)
	..s OBSValue=$p(MROBSStr,"^",2)
	..s:(OBSValue'="") OBSValue=$p(MROBSStr,"^",2)_ITMUnit
	..s:(OBSValue'="")&&(ITMDesc["收缩") OBSValue=$p(MROBSStr,"^",2)
	..s OBSDate=$p(MROBSStr,"^",3)
	..s OBSTime=$p(MROBSStr,"^",4)
	..d GetGOfOBSItemData	
	q
		
GetGOfOBSItemData
	i $d(VitalsignsList(OBSDate,OBSTime))=0 d
	.s VitalsignsList(OBSDate,OBSTime)=$lb("")
	
	d GetPosition
	s OBSValueP=Num
	s $list(VitalsignsList(OBSDate,OBSTime),OBSValueP)= OBSValue
	s ^TempVitalsignslfb(OBSDate,OBSTime)=VitalsignsList(OBSDate,OBSTime)
	q

GetPosition

	
	f m=1:1:ITEMNUM d
	.s ITMStr=$p(ArgItemStr,"|",m)
	.s ITMDescListNumber=$p(ITMStr,":",2)
	.s ITMDescList=$g(ITMDescList)_$lb(ITMDescListNumber)
	f n=1:1:ITEMNUM d
	.i ITMDesc=$list(ITMDescList,n) s Num=n
	q

OutputRow

	s TmpOBSDate="",TmpOBSTime=""
	f  {
		s TmpOBSDate=$o(^TempVitalsignslfb(TmpOBSDate)) 
		q:TmpOBSDate=""
		f  
		{
			s TmpOBSTime=$o(^TempVitalsignslfb(TmpOBSDate,TmpOBSTime)) 
			q:TmpOBSTime=""
			s Data=$lb($zd(TmpOBSDate,3))_$lb($zt(TmpOBSTime,1))_^TempVitalsignslfb(TmpOBSDate,TmpOBSTime)
			s TotalAmount=TotalAmount+1	
			Continue:(TotalAmount<ArgStartPage)
			Continue:(TotalAmount>ArgEndPage)
			s ^CacheTemp(repid,ind)=Data
			s ind=ind+1
		}
	}
	q
}

ClassMethod GetVitalsignsDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVitalsignsDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetVitalsignsDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVitalsignsDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{			
 		Set Row=^CacheTemp(repid,ind)
 	}

 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
