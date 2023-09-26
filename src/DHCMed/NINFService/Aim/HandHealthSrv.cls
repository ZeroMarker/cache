/// 名称: DHCMed.NINFService.Aim.HandHealthSrv
/// 描述: 手卫生相关报告信息查询
/// 编写者：lyh
/// 编写日期: 2012-05-09
Class DHCMed.NINFService.Aim.HandHealthSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 手卫生依从性统计表
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.HandHealthSrv","QryForHandHealthDone","2012-05-01","2012-10-10","")
Query QryForHandHealthDone(FromDate As %String, ToDate As %String, LocDR As %String) As %Query(ROWSPEC = "LocDesc:%String,TotalTimes:%String,HandRub:%String,Handwash:%String,HandNo:%String,HandGloves:%String,HandActionRitCount:%String,ObserveTimes:%String,HandRitRate:%String,TotalShouldDoRate:%String,PointTimes:%String,PointHandRub:%String,PointHandwash:%String,PointHandNo:%String,PointHandGloves:%String,PointShouldDoneRate:%String,Point1Times:%String,Point1HandRub:%String,Point1Handwash:%String,Point1HandNo:%String,Point1HandGloves:%String,ShouldDoneRate1:%String,Point2Times:%String,Point2HandRub:%String,Point2Handwash:%String,Point2HandNo:%String,Point2HandGloves:%String,ShouldDoneRate2:%String,Point3Times:%String,Point3HandRub:%String,Point3Handwash:%String,Point3HandNo:%String,Point3HandGloves:%String,ShouldDoneRate3:%String,Point4Times:%String,Point4HandRub:%String,Point4Handwash:%String,Point4HandNo:%String,Point4HandGloves:%String,ShouldDoneRate4:%String,Point5Times:%String,Point5HandRub:%String,Point5Handwash:%String,Point5HandNo:%String,Point5HandGloves:%String,ShouldDoneRate5:%String,Identitys1Times:%String,Identitys1HandRub:%String,Identitys1Handwash:%String,Identitys1HandNo:%String,Identitys1HandGloves:%String,DocRitPercent:%String,DocRitRate:%String,Identitys1DoRate:%String,Identitys2Times:%String,Identitys2HandRub:%String,Identitys2Handwash:%String,Identitys2HandNo:%String,Identitys2HandGloves:%String,NurRitPercent:%String,NurRitRate:%String,Identitys2DoRate:%String,Identitys3Times:%String,Identitys3HandRub:%String,Identitys3Handwash:%String,Identitys3HandNo:%String,Identitys3HandGloves:%String,WorkRitPercent:%String,WorkRitRate:%String,Identitys3DoRate:%String,Identitys4Times:%String,Identitys4HandRub:%String,Identitys4Handwash:%String,Identitys4HandNo:%String,Identitys4HandGloves:%String,CleanRitPercent:%String,CleanRitRate:%String,Identitys4DoRate:%String,Identitys5Times:%String,Identitys5HandRub:%String,Identitys5Handwash:%String,Identitys5HandNo:%String,Identitys5HandGloves:%String,ZYYSRitPercent:%String,ZYYSRitRate:%String,Identitys5DoRate:%String,Identitys6Times:%String,Identitys6HandRub:%String,Identitys6Handwash:%String,Identitys6HandNo:%String,Identitys6HandGloves:%String,YJRitPercent:%String,YJRitRate:%String,Identitys6DoRate") [ SqlProc ]
{
}

ClassMethod QryForHandHealthDoneExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, LocDR As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	
	s:ToDate="" ToDate=+$h
	s:FromDate="" FromDate=ToDate-30
	k ^CacheTmp("QryForHandHealthDone")
	set ObserveTimes=""
	set (DocObserveTimes,DocRit,NurseObserveTimes,NurRit,WorkObserveTimes,WorkRit,CleanObserveTimes,CleanRit,ZYYSObserveTimes,ZYYSRit,YJObserveTimes,YJRit)=""
	set (Point1HandRub,Point1Handwash,Point1HandNo,Point1HandGloves,Point2HandRub,Point2Handwash,Point2HandNo,Point2HandGloves,Point3HandRub,Point3Handwash,Point3HandNo,Point3HandGloves,Point4HandRub,Point4Handwash,Point4HandNo,Point4HandGloves,Point5HandRub,Point5Handwash,Point5HandNo,Point5HandGloves)=""
	set (Identitys1HandRub,Identitys1Handwash,Identitys1HandNo,Identitys1HandGloves,Identitys2HandRub,Identitys2Handwash,Identitys2HandNo,Identitys2HandGloves,Identitys3HandRub,Identitys3Handwash,Identitys3HandNo,Identitys3HandGloves,Identitys4HandRub,Identitys4Handwash,Identitys4HandNo,Identitys4HandGloves,Identitys5HandRub,Identitys5Handwash,Identitys5HandNo,Identitys5HandGloves,Identitys6HandRub,Identitys6Handwash,Identitys6HandNo,Identitys6HandGloves)=""
	set (TotalTimes,HandRub,Handwash,HandNo,HandGloves,HandActionRitCount,ObserveTimes,HandRitRate,TotalShouldDoRate,PointTimes,PointHandRub,PointHandwash,PointHandNo,PointHandGloves,PointShouldDoneRate,ShouldDoneRate1,ShouldDoneRate2,ShouldDoneRate3,ShouldDoneRate4,ShouldDoneRate5,DocRitPercent,DocRitRate,Identitys1DoRate,NurRitPercent,NurRitRate,Identitys2DoRate,WorkRitPercent,WorkRitRate,Identitys3DoRate,CleanRitPercent,CleanRitRate,Identitys4DoRate,ZYYSRitPercent,ZYYSRitRate,Identitys5DoRate,YJRitPercent,YJRitRate,Identitys6DoRate)=""
	set (Times1Count,Times2Count,Times3Count,Times4Count,HandActionRitCount)=""
	for tmpDate=FromDate:1:ToDate {
		set RepID=""
		for {
			set RepID=$o(^DHCMed.NINF.Aim.HandHealthI("IndexOfDate"," "_tmpDate,RepID)) 
			Quit:RepID=""

			set RepObj=##Class(DHCMed.NINF.Aim.HandHealth).GetObjById(RepID)
			continue:'$IsObject(RepObj)
			set Identitys=""
			set:RepObj.HandAction="1" Times1Count=$i(^CacheTmp("QryForHandHealthDone","Times1Count"))
			set:RepObj.HandAction="2" Times2Count=$i(^CacheTmp("QryForHandHealthDone","Times2Count"))
			set:RepObj.HandAction="3" Times3Count=$i(^CacheTmp("QryForHandHealthDone","Times3Count"))
			set:RepObj.HandAction="4" Times4Count=$i(^CacheTmp("QryForHandHealthDone","Times4Count")) //这四条数据值相加则得到时机总数
			set:RepObj.HandActionRit="1" HandActionRitCount=$i(^CacheTmp("QryForHandHealthDone","HandActionRitCount"))
			if (RepObj.HandActionRit'="") { set ObserveTimes=ObserveTimes+1}
			
			if (RepObj.Identitys="1"){

				if (RepObj.HandActionRit'="")
				{ 
					set DocObserveTimes=DocObserveTimes+1
				}
				if (RepObj.HandActionRit="1")
				{
					s DocRit=DocRit+1

				}
				}elseif(RepObj.Identitys="2")
				{
				if (RepObj.HandActionRit'="")
				{
					set NurseObserveTimes=NurseObserveTimes+1
				}
				if (RepObj.HandActionRit="1")
				{
					s NurRit=NurRit+1
					}
				}elseif(RepObj.Identitys="3")
				{
					if (RepObj.HandActionRit'="")
					{
						set WorkObserveTimes=WorkObserveTimes+1
						}
					
				if (RepObj.HandActionRit="1")
				{
					s WorkRit=WorkRit+1
					}
				}
				elseif(RepObj.Identitys="4")
				{
					if (RepObj.HandActionRit'="")
					{
						set CleanObserveTimes=CleanObserveTimes+1
						}

					if (RepObj.HandActionRit="1")
					{
					s CleanRit=CleanRit+1
					}
				}
				elseif(RepObj.Identitys="5")
				{
					if (RepObj.HandActionRit'="")
					{
						set ZYYSObserveTimes=ZYYSObserveTimes+1
						}
								              //中央运输专业类
					if (RepObj.HandActionRit="1")
					{
					s ZYYSRit=ZYYSRit+1
					}
				}
				elseif(RepObj.Identitys="6")  //医技专业类
				{
					if (RepObj.HandActionRit'="")
					{
						set YJObserveTimes=YJObserveTimes+1
						}

				if (RepObj.HandActionRit="1")
				{
					s YJRit=YJRit+1
					}
				}
			
				
			set HandPoint=RepObj.HandPoint

			if (HandPoint){
				set HandPointLen=$length(HandPoint,"/")
				for i=1:1:HandPointLen {
				
					set PointCode=$p(HandPoint,"/",i)
					set:(RepObj.HandAction="1") HandRub=$i(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandRub"))
					set:(RepObj.HandAction="2") Handwash=$i(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"Handwash"))
					set:(RepObj.HandAction="3") HandNo=$i(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandNo"))
					set:(RepObj.HandAction="4") HandGloves=$i(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandGloves"))
				
				
				}	
			}
		    set Identitys=RepObj.Identitys
		    set:(RepObj.HandAction="1") HandRub=$i(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandRub"))
			set:(RepObj.HandAction="2") Handwash=$i(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"Handwash"))
			set:(RepObj.HandAction="3") HandNo=$i(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandNo"))
			set:(RepObj.HandAction="4") HandGloves=$i(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandGloves"))
			}
	}
	//时机
	set TotalTimes=Times1Count+Times2Count+Times3Count+Times4Count
	//正确率
	set (HandRitRate,TotalShouldDoRate,DocRitRate,NurRitRate,WorkRitRate,CleanRitRate,ZYYSRitRate,YJRitRate)="0"
	set:((HandActionRitCount>0)&(ObserveTimes>0)) HandRitRate=$fn(HandActionRitCount/ObserveTimes*100,"",2)_"%"
	set:(((Times1Count+Times2Count)>0)&(TotalTimes>0)) TotalShouldDoRate=$fn((Times1Count+Times2Count)/TotalTimes*100,"",2)_"%"
	
	set DocRitPercent=DocRit_"/"_DocObserveTimes
	set:((DocRit>0)&(DocObserveTimes>0)) DocRitRate=$fn(DocRit/DocObserveTimes*100,"",2)_"%"
	
	set NurRitPercent=NurRit_"/"_NurseObserveTimes
	set:((NurRit>0)&(NurseObserveTimes>0)) NurRitRate=$fn(NurRit/NurseObserveTimes*100,"",2)_"%"
	
	set WorkRitPercent=WorkRit_"/"_WorkObserveTimes
	set:((WorkRit>0)&(WorkObserveTimes>0)) WorkRitRate=$fn(WorkRit/WorkObserveTimes*100,"",2)_"%"
	
	set CleanRitPercent=CleanRit_"/"_CleanObserveTimes
	set:((CleanRit>0)&(CleanObserveTimes>0)) CleanRitRate=$fn(CleanRit/CleanObserveTimes*100,"",2)_"%"
	
	set ZYYSRitPercent=ZYYSRit_"/"_ZYYSObserveTimes
	set:((ZYYSRit>0)&(ZYYSObserveTimes>0)) ZYYSRitRate=$fn(ZYYSRit/ZYYSObserveTimes*100,"",2)_"%"
	
	set YJRitPercent=YJRit_"/"_YJObserveTimes
	set:((YJRit>0)&(YJObserveTimes>0)) YJRitRate=$fn(YJRit/YJObserveTimes*100,"",2)_"%"

	set PointCode=""
	for {
		set PointCode=$o(^CacheTmp("QryForHandHealthDone","PointCode",PointCode))

		quit:PointCode=""
		set PointDR=$tr(PointCode," ","")

		if (PointDR="1"){
			set Point1HandRub=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandRub"))

			set Point1Handwash=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"Handwash"))
			set Point1HandNo=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandNo"))
			set Point1HandGloves=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandGloves"))
			}elseif(PointDR="2")
			{
			set Point2HandRub=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandRub"))
			set Point2Handwash=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"Handwash"))
			set Point2HandNo=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandNo"))
			set Point2HandGloves=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandGloves"))
			}elseif(PointDR="3")
			{
			set Point3HandRub=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandRub"))
			set Point3Handwash=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"Handwash"))
			set Point3HandNo=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandNo"))
			set Point3HandGloves=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandGloves"))
			}elseif(PointDR="4")
			{
			set Point4HandRub=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandRub"))
			set Point4Handwash=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"Handwash"))
			set Point4HandNo=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandNo"))
			set Point4HandGloves=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandGloves"))
			}elseif(PointDR="5")
			{
			set Point5HandRub=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandRub"))
			set Point5Handwash=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"Handwash"))
			set Point5HandNo=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandNo"))
			set Point5HandGloves=$g(^CacheTmp("QryForHandHealthDone","PointCode",PointCode,"HandGloves"))
			}
		}
	
	set Point1Times=Point1HandRub+Point1Handwash+Point1HandNo+Point1HandGloves
	set:((Point1HandRub+Point1Handwash)>0&(Point1Times>0)) ShouldDoneRate1=$fn((Point1HandRub+Point1Handwash)/Point1Times*100,"",2)_"%"
	set Point2Times=Point2HandRub+Point2Handwash+Point2HandNo+Point2HandGloves
	set:((Point2HandRub+Point2Handwash)>0&(Point2Times>0)) ShouldDoneRate2=$fn((Point2HandRub+Point2Handwash)/Point2Times*100,"",2)_"%"
	set Point3Times=Point3HandRub+Point3Handwash+Point3HandNo+Point3HandGloves
	set:((Point3HandRub+Point3Handwash)>0&(Point3Times>0)) ShouldDoneRate3=$fn((Point3HandRub+Point3Handwash)/Point3Times*100,"",2)_"%"
	set Point4Times=Point4HandRub+Point4Handwash+Point4HandNo+Point4HandGloves
	set:((Point4HandRub+Point4Handwash)>0&(Point4Times>0)) ShouldDoneRate4=$fn((Point4HandRub+Point4Handwash)/Point4Times*100,"",2)_"%"
	set Point5Times=Point5HandRub+Point5Handwash+Point5HandNo+Point5HandGloves
	set:((Point5HandRub+Point5Handwash)>0&(Point5Times>0)) ShouldDoneRate5=$fn((Point5HandRub+Point5Handwash)/Point5Times*100,"",2)_"%"
	
	
	
	set PointTimes=Point1Times+Point2Times+Point3Times+Point4Times+Point5Times
	set PointHandRub=Point1HandRub+Point2HandRub+Point3HandRub+Point4HandRub+Point5HandRub
	set PointHandwash=Point1Handwash+Point2Handwash+Point3Handwash+Point4Handwash+Point5Handwash
	set PointHandNo=Point1HandNo+Point2HandNo+Point3HandNo+Point4HandNo+Point5HandNo
	set PointHandGloves=Point1HandGloves+Point2HandGloves+Point3HandGloves+Point4HandGloves+Point5HandGloves
	set:(((PointHandRub+PointHandwash)>0)&(PointTimes>0)) PointShouldDoneRate=$fn((PointHandRub+PointHandwash)/PointTimes*100,"",2)_"%"
	set Identitys=""

	for {
		set Identitys=$o(^CacheTmp("QryForHandHealthDone","Identitys",Identitys))
		quit:Identitys=""
		set IdentitysDR=$tr(Identitys," ","")
		if (IdentitysDR="1"){
			set Identitys1HandRub=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandRub"))
			set Identitys1Handwash=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"Handwash"))
			set Identitys1HandNo=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandNo"))
			set Identitys1HandGloves=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandGloves"))	
		}elseif(IdentitysDR="2"){
			set Identitys2HandRub=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandRub"))
			set Identitys2Handwash=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"Handwash"))
			set Identitys2HandNo=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandNo"))
			set Identitys2HandGloves=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandGloves"))
		}elseif(IdentitysDR="3"){
			set Identitys3HandRub=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandRub"))
			set Identitys3Handwash=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"Handwash"))
			set Identitys3HandNo=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandNo"))
			set Identitys3HandGloves=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandGloves"))
		}elseif(IdentitysDR="4"){
			set Identitys4HandRub=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandRub"))
			set Identitys4Handwash=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"Handwash"))
			set Identitys4HandNo=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandNo"))
			set Identitys4HandGloves=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandGloves"))
		}elseif(IdentitysDR="5"){
			set Identitys5HandRub=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandRub"))
			set Identitys5Handwash=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"Handwash"))
			set Identitys5HandNo=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandNo"))
			set Identitys5HandGloves=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandGloves"))
		}elseif(IdentitysDR="6"){
			set Identitys6HandRub=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandRub"))
			set Identitys6Handwash=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"Handwash"))
			set Identitys6HandNo=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandNo"))
			set Identitys6HandGloves=$g(^CacheTmp("QryForHandHealthDone","Identitys",Identitys,"HandGloves"))
		}
		}

	set Identitys1Times=	Identitys1HandRub+Identitys1Handwash+Identitys1HandNo+Identitys1HandGloves
	set:(((Identitys1HandRub+Identitys1Handwash)>0)&(Identitys1Times>0)) Identitys1DoRate=$fn((Identitys1HandRub+Identitys1Handwash)/Identitys1Times*100,"",2)_"%"
	set Identitys2Times=	Identitys2HandRub+Identitys2Handwash+Identitys2HandNo+Identitys2HandGloves
	set:(((Identitys2HandRub+Identitys2Handwash)>0)&(Identitys2Times>0)) Identitys2DoRate=$fn((Identitys2HandRub+Identitys2Handwash)/Identitys2Times*100,"",2)_"%"
	set Identitys3Times=	Identitys3HandRub+Identitys3Handwash+Identitys3HandNo+Identitys3HandGloves
	set:(((Identitys3HandRub+Identitys3Handwash)>0)&(Identitys3Times>0)) Identitys3DoRate=$fn((Identitys3HandRub+Identitys3Handwash)/Identitys3Times*100,"",2)_"%"
	set Identitys4Times=	Identitys4HandRub+Identitys4Handwash+Identitys4HandNo+Identitys4HandGloves
	set:(((Identitys4HandRub+Identitys4Handwash)>0)&(Identitys4Times>0)) Identitys4DoRate=$fn((Identitys4HandRub+Identitys4Handwash)/Identitys4Times*100,"",2)_"%"
	set Identitys5Times=	Identitys5HandRub+Identitys5Handwash+Identitys5HandNo+Identitys5HandGloves
	set:(((Identitys5HandRub+Identitys5Handwash)>0)&(Identitys5Times>0)) Identitys5DoRate=$fn((Identitys5HandRub+Identitys5Handwash)/Identitys5Times*100,"",2)_"%"
	set Identitys6Times=	Identitys6HandRub+Identitys6Handwash+Identitys6HandNo+Identitys6HandGloves
	set:(((Identitys6HandRub+Identitys6Handwash)>0)&(Identitys6Times>0)) Identitys6DoRate=$fn((Identitys6HandRub+Identitys6Handwash)/Identitys6Times*100,"",2)_"%"
	set Data=$lb(LocDesc,TotalTimes,Times1Count,Times2Count,Times3Count,Times4Count,HandActionRitCount,ObserveTimes,HandRitRate,TotalShouldDoRate,PointTimes,PointHandRub,PointHandwash,PointHandNo,PointHandGloves,PointShouldDoneRate,
	Point1Times,Point1HandRub,Point1Handwash,Point1HandNo,Point1HandGloves,ShouldDoneRate1,
	Point2Times,Point2HandRub,Point2Handwash,Point2HandNo,Point2HandGloves,ShouldDoneRate2,
	Point3Times,Point3HandRub,Point3Handwash,Point3HandNo,Point3HandGloves,ShouldDoneRate3,
	Point4Times,Point4HandRub,Point4Handwash,Point4HandNo,Point4HandGloves,ShouldDoneRate4,
	Point5Times,Point5HandRub,Point5Handwash,Point5HandNo,Point5HandGloves,ShouldDoneRate5,
	Identitys1Times,Identitys1HandRub,Identitys1Handwash,Identitys1HandNo,Identitys1HandGloves,DocRitPercent,DocRitRate,Identitys1DoRate,
	Identitys2Times,Identitys2HandRub,Identitys2Handwash,Identitys2HandNo,Identitys2HandGloves,NurRitPercent,NurRitRate,Identitys2DoRate,
	Identitys3Times,Identitys3HandRub,Identitys3Handwash,Identitys3HandNo,Identitys3HandGloves,WorkRitPercent,WorkRitRate,Identitys3DoRate,
	Identitys4Times,Identitys4HandRub,Identitys4Handwash,Identitys4HandNo,Identitys4HandGloves,CleanRitPercent,CleanRitRate,Identitys4DoRate,
	Identitys5Times,Identitys5HandRub,Identitys5Handwash,Identitys5HandNo,Identitys5HandGloves,ZYYSRitPercent,ZYYSRitRate,Identitys5DoRate,
	Identitys6Times,Identitys6HandRub,Identitys6Handwash,Identitys6HandNo,Identitys6HandGloves,YJRitPercent,YJRitRate,Identitys6DoRate
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	Quit $$$OK
}

ClassMethod QryForHandHealthDoneClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryForHandHealthDoneExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryForHandHealthDoneFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryForHandHealthDoneExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.HandHealthSrv","QueryUserInfo","刘")
Query QueryUserInfo(alias As %String) As %Query(ROWSPEC = "tmpid:%String,Name:%String")
{
}

ClassMethod QueryUserInfoExecute(ByRef qHandle As %Binary, alias As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s alias=$ZCVT(alias,"u")
	s tmpid=$o(^SSU("SSUSR",""))
	f  s tmpid=$o(^SSU("SSUSR",tmpid)) q:tmpid=""  d
	.s flag=0
	.s code=$p($g(^SSU("SSUSR",+tmpid)),"^",1)
	.s name=$p($g(^SSU("SSUSR",+tmpid)),"^",2)
	.s mailName=$p($g(^SSU("SSUSR",+tmpid)),"^",11)
	.s:$ZCVT(code,"u")[alias flag=1
    .s:$ZCVT(name,"u")[alias flag=1
	.s:$ZCVT(mailName,"u")[alias flag=1
	.s SSUSRCareProvDR=$p($g(^SSU("SSUSR",+tmpid)),"^",14)
	.q:SSUSRCareProvDR=""
	.s CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)
	.q:CTPCPCarPrvTpDR=""
	.s UserType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
	.q:(UserType'="DOCTOR")&&(UserType'="NURSE")
	.s CTPCP=##class(User.CTCareProv).%OpenId(SSUSRCareProvDR)
	.q:'$IsObject(CTPCP)
	.s OtherName=CTPCP.CTPCPOtherName
	.s:(OtherName'="")&($ZCVT(OtherName,"u")[alias) flag=1
	.q:flag'=1
	.d CTPCP.%Close()
	.s obj=##class(DHCMed.Base.SSUser).GetObjById(tmpid)
	.q:'$IsObject(obj)
	.s Name=obj.Name
	.s Data=$lb(tmpid,Name)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	
	Quit $$$OK
}

ClassMethod QueryUserInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryUserInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.HandHealthSrv","QryForHandHeRep","2012-05-01","2012-05-09","")
Query QryForHandHeRep(FromDate As %String, ToDate As %String, LocDR As %String) As %Query(ROWSPEC = "RepID:%String,CTLOCID:%String,LocDesc:%String,ObserveDate:%String,ObserveTime:%String,ObserverDR:%String,ObserverName:%String,ObserverCode:%String,Identitys:%String,IdentitysDesc:%String,HandPoint:%String,HandPointDesc:%String,HandAction:%String,HandActionDesc:%String,HandActionRit:%String,HandActionRitDesc:%String,WardID:%String,WardDesc:%String")
{
}

ClassMethod QryForHandHeRepExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, LocDR As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	
	s:ToDate="" ToDate=+$h
	s:FromDate="" FromDate=ToDate-10
	
	set CTLoc=""
	for tmpDate=FromDate:1:ToDate {
	for {
		set CTLoc=$o(^DHCMed.NINF.Aim.HandHealthI("IndexOfDateLoc"," "_tmpDate,CTLoc))
		Quit:CTLoc=""
		set sCTLoc=$tr(CTLoc," ","")
		continue:((LocDR'="")&&(sCTLoc'=LocDR))
		set RepID=""
		for {
			set RepID=$o(^DHCMed.NINF.Aim.HandHealthI("IndexOfDateLoc"," "_tmpDate,CTLoc,RepID)) 
			Quit:RepID=""
			set RepObj=##Class(DHCMed.NINF.Aim.HandHealth).GetObjById(RepID)
			set CTLOCID=$tr(CTLoc," ","")
			set LocDesc=$p(^CTLOC(CTLOCID),"^",2)
			set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
			set WardID=RepObj.WardDR
			set WardDesc=""
			set:'$d(PAWARD(+WardID)) WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	 		set ObserveDate=RepObj.ObserveDate
	 		set:ObserveDate'="" ObserveDate=$zd(ObserveDate,3)
			set ObserveTime=RepObj.ObserveTime
			set ObserverDR=RepObj.ObserverDR
			set ObserverObj=##class(DHCMed.Base.SSUser).GetObjById(ObserverDR)
			continue:'$IsObject(ObserverObj)
			set ObserverName=ObserverObj.Name
			set ObserverCode=ObserverObj.Code
			set Identitys=RepObj.Identitys
			set IdentitysDesc=""
			if (Identitys'="")
			{
    			set dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Identitys,"HandHealthDocType")
    			set objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    			quit:'$IsObject(objDic)
    			set IdentitysDesc=objDic.Description
			}
			set HandPoint=RepObj.HandPoint
			set HandPointDesc=""
			if (HandPoint'="")
			{
				set len=$l(HandPoint,"/")
				for i=1:1:len {
					set sHandPoint=$p(HandPoint,"/",i)
					Continue:sHandPoint=""
					set dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(sHandPoint,"HandHealthGuide")
    				set objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    				continue:'$IsObject(objDic)
    				set:HandPointDesc'="" HandPointDesc=HandPointDesc_","_objDic.Description
					set:HandPointDesc="" HandPointDesc=objDic.Description
				}
				
			}
			set HandAction=RepObj.HandAction
			set HandActionDesc=""
			set:HandAction=1 HandActionDesc="擦手"
			set:HandAction=2 HandActionDesc="洗手"
			set:HandAction=3 HandActionDesc="未采取"
			set:HandAction=4 HandActionDesc="gloves"
			set HandActionRit=RepObj.HandActionRit
			set HandActionRitDesc=""
			set:HandActionRit=1 HandActionRitDesc="是"
			set:HandActionRit=2 HandActionRitDesc="否"
			set Data=$lb(RepID,CTLOCID,LocDesc,ObserveDate,ObserveTime,ObserverDR,ObserverName,ObserverCode,Identitys,IdentitysDesc,HandPoint,HandPointDesc,HandAction,HandActionDesc,HandActionRit,HandActionRitDesc,WardID,WardDesc)
			set ^CacheTemp(repid,ind)=Data
			set ind=ind+1
			}
		}
	}	
	Quit $$$OK
}

ClassMethod QryForHandHeRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryForHandHeRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryForHandHeRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryForHandHeRepExecute ]
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

/// d ##class(DHCMed.NINFService.Aim.HandHealthSrv).DeleteTestData()
ClassMethod DeleteTestData()
{
	k ^DHCMed.NINF.Aim.HandLiquidIND
	k ^DHCMed.NINF.Aim.HandLiquidINI
	
	k ^DHCMed.NINF.Aim.HandLiquidTypeD
	k ^DHCMed.NINF.Aim.HandLiquidTypeI
	
	k ^DHCMed.NINF.Aim.HandLiquidUseD
	k ^DHCMed.NINF.Aim.HandLiquidUseI
	
	k ^DHCMed.NINF.Aim.HandLiquidDepD
	k ^DHCMed.NINF.Aim.HandLiquidDepI
}

/// Creator：     liuyh
/// CreatDate：   2012-05-11
/// Description:  导入洗手液出库量数据
/// Return：      
/// w ##class(DHCMed.NINFService.Aim.HandHealthSrv).ImportHandHealthData("")
ClassMethod ImportHandHealthData(ImportDataDate As %String, ExcelCode As %String, TotalLocSoapStr As %String) As %String
{
	n (ImportDataDate , ExcelCode , TotalLocSoapStr)
	s ^LYH1=ImportDataDate
	s ^LYH2=ExcelCode
	s ^LYH3=TotalLocSoapStr
	set ret=-1,ErrorFlag=0
	q:(ImportDataDate="")||(ExcelCode="")||(TotalLocSoapStr="") ret
	set $ZT="Error"
	TStart
	set InYear=$p(ImportDataDate,"年",1)
	set InMonth=$p(ImportDataDate,"年",2)
	set InDate=+$h
	set InTime=$p($h,",",2)
	set DataInfo="^"_InYear_"^"_InMonth_"^"_InDate_"^"_InTime_"^"
	set HandLiquidINID=##class(DHCMed.NINF.Aim.HandLiquidIN).Update(DataInfo)
	
	if HandLiquidINID<0 TRollback		// 出现插入失败后全部rollback
	
	set len=$l(ExcelCode,$c(10))
	for i=1:1:len d
	.set TypeStr=$p(ExcelCode,$c(10),i)
	.set TypeCode=$p(TypeStr,"^",1)
	.set TypeName=$p(TypeStr,"^",2)
	.set TypeHlVolume=$p(TypeStr,"^",3)
	.set TypeHlUnit=$p(TypeStr,"^",4)
	.quit:$d(^DHCMed.NINF.Aim.HandLiquidTypeI("IndexOfName"," "_TypeCode," "_TypeName))
	.set retStr=##class(DHCMed.NINF.Aim.HandLiquidType).Update("^"_TypeStr)
	.set:retStr<1 ErrorFlag=1 
	
	if ErrorFlag>0 TRollback
	
	set len=$l(TotalLocSoapStr,$c(11))
	for i=1:1:len d
	.set LocSoapInfo=$p(TotalLocSoapStr,$c(11),i)
	.quit:LocSoapInfo=""
	.set LocDescInfo=$p(LocSoapInfo,$c(12),1) //科室代码、描述
	.set LocDescInfo=$tr(LocDescInfo," ","^")
	.set HandLDepID=##class(DHCMed.NINF.Aim.HandLiquidDep).Update("^"_HandLiquidINID_"^"_LocDescInfo) //插入科室编码名称信息
	.set:HandLDepID<1 ErrorFlag=1
	.quit:HandLDepID<1
	.set LocSoapStr=$p(LocSoapInfo,$c(12),2)
	.set SoapTypeNum=$l(LocSoapStr,$c(9))
	.for j=1:1:SoapTypeNum d
	..set SoapTypeInfo=$p(LocSoapStr,$c(9),j)
	..set LocSoapTypeNum=$p(SoapTypeInfo,$c(10),2)	//科室对应洗手液数量
	..set SoapTypeStr=$p(SoapTypeInfo,$c(10),1) //洗手液代码、名称、容量、单位 信息
	..set TypeCode=$p(SoapTypeStr,"^",1)
	..set TypeName=$p(SoapTypeStr,"^",2)
	..set TypeHlVolume=$p(SoapTypeStr,"^",3)
	..set TypeHlUnit=$p(SoapTypeStr,"^",4)
	..;该名称、容量、单位 洗手液 数据已经保存过
	..if $d(^DHCMed.NINF.Aim.HandLiquidTypeI("IndexOfName"," "_TypeCode," "_TypeName)) do
	...set TypeID=$o(^DHCMed.NINF.Aim.HandLiquidTypeI("IndexOfName"," "_TypeCode," "_TypeName,""),-1)
	...set:TypeID<1 ErrorFlag=2
	...quit:TypeID<1
	...s LocSoapUserNum=##class(DHCMed.NINF.Aim.HandLiquidUse).Update("^"_TypeID_"^"_LocSoapTypeNum_"^"_HandLDepID)
	...set:LocSoapUserNum<1 ErrorFlag=3
	..else  do
	...q:SoapTypeStr=""		//科室没用洗手液
	...set TypeID=##class(DHCMed.NINF.Aim.HandLiquidType).Update("^"_SoapTypeStr)
	...set:TypeID<1 ErrorFlag=4
	...q:TypeID<1
	...s LocSoapUserNum=##class(DHCMed.NINF.Aim.HandLiquidUse).Update("^"_TypeID_"^"_LocSoapTypeNum_"^"_HandLDepID)
	...set:LocSoapUserNum<1 ErrorFlag=5
	
	if ErrorFlag>0 TRollback
	
	TCommit
	set ret=1
	quit ret

Error
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.HandHealthSrv","QueryHandHType")
Query QueryHandHType() As %Query(ROWSPEC = "rowid:%String,HandLiquidCode:%String,HLName:%String,HlVolume:%String,HlUnit:%String,Type:%String")
{
}

ClassMethod QueryHandHTypeExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s rowid=""
	f  s rowid=$o(^DHCMed.NINF.Aim.HandLiquidTypeD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.NINF.Aim.HandLiquidType).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s HandLiquidCode=obj.HandLiquidCode
	.s HLName=obj.HLName
	.s HlVolume=obj.HlVolume
	.s HlUnit=obj.HlUnit
	.s Type=obj.Type
	.d obj.%Close()
	.s Data=$lb(rowid,HandLiquidCode,HLName,HlVolume,HlUnit,Type)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	
	Quit $$$OK
}

ClassMethod QueryHandHTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHandHTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryHandHTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHandHTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

}
