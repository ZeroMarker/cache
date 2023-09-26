Class DtPortal.Common.Interface.CriticalValue Extends %RegisteredObject [ ClassType = "" ]
{

/// Creator：      chengpeng
/// CreatDate：    2015-12-15
/// Description:： 查询危急报告
/// Table：        DHC_AntCVReport
/// Input：        危急报告日期,科室ID,处理状态(C未完成,F完成),就诊类型(O:门诊,I:住院,E:急诊),报告类型(1:检验,2病理,3心电,4超声,5内镜,6放射)
/// Output：       
/// Return：        
/// Others：d ##Class(%ResultSet).RunQuery("DtPortal.Common.Interface.CriticalValue","GetPanicReport","2018-03-01","2018-12-19","","F","I",1)
Query GetPanicReport(startDate As %String, enddate As %String, LocId As %String, Status As %String, AdmType As %String = "", ReportType As %String) As DtPortal.Query(ROWSPEC = "ind:%String,ReportId:%String,epis:%String,TSName:%String,PhoneNo:%String,ToPerson:%String,TransMemo:%String,TDate,TTime,TransDT:%String,TransUser:%String,ReportType:%String,adm:%String,AmdLoc:%String,ReportDate,ReportTime,ReportStatus,TransDate,TransTime,DPRPResult,OEOrdItemID")
{
}

ClassMethod GetPanicReportExecute(ByRef qHandle As %Binary, startDate As %String, enddate As %String, LocId As %String, Status As %String, AdmType As %String = "", ReportType As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	set:startDate["-" startDate=$zdh(startDate,3)
	set:enddate["-" enddate=$zdh(enddate,3)
	
  	set Date=startDate-1
  	for
  	{
	  	set Date=$o(^DHCAntCVReport(0,"DATE",Date)) 
	  	quit:(Date="")||(Date>enddate)  
	  	
	  	set epis="" 
	  	for
	  	{
		  	set epis=$o(^DHCAntCVReport(0,"DATE",Date,ReportType,epis)) 
		  	quit:epis=""
		  	
		  	set ord=""
		  	for
		  	{
			  	set ord=$o(^DHCAntCVReport(0,"DATE",Date,ReportType,epis,ord)) 
			  	quit:ord="" 
			  	
			  	set ReportId="",ReportDate="",ReportTime="",TSName="",PhoneNo="",ToPerson="",TransMemo="",TransDT="",TransDate="",TransTime="",TransUser="",adm="",AmdLoc=""
			  	
			  	set adm=$p(^DHCAntCVReport(ReportType,epis,ord),"\",7)
			  	set OEOrdItemID=$p(^DHCAntCVReport(ReportType,epis,ord),"\",14)
			  	set ReportDate=$p(^DHCAntCVReport(ReportType,epis,ord),"\",1)
			  	set ReportTime=$p(^DHCAntCVReport(ReportType,epis,ord),"\",2)
			  	set DPRPResult=^DHCAntCVReport(ReportType,epis,ord,"Result")
			  	
				set TSName=..GetOrdItemName(OEOrdItemID)
				if TSName="",ReportType=1 s TSName=..GetTSName(epis)
				set aStatus=$p(^DHCAntCVReport(ReportType,epis,ord),"\",9)
				if $l(Status),Status'=aStatus continue
				
				set aAdmType=$p(^PAADM(adm),"^",2)
				if $l(AdmType), AdmType'=aAdmType continue
				
				if '$l(TSName) continue
				;if ReportType=1,'$$CheckLoc1(adm,LocId,epis) continue
				if '$$CheckLoc2(adm,LocId,OEOrdItemID) continue
				
				set TransOrd=+$o(^DHCAntCVReport(ReportType,epis,ord,"TR",""))
				set (ToPerson,PhoneNo,TransMemo,TransDT,TransDate,TransTime)=""
				
				if TransOrd'=0
				{
					s str=$g(^DHCAntCVReport(ReportType,epis,ord,"TR",TransOrd))
					s TDate=$p(str,"\",1)
					s TTime=$p(str,"\",2)
					s TUser=$p(str,"\",3)
					s TransDate=TDate
					s TransTime=TTime
					i $l(TDate),$l(TTime) s TransDT=$zd(TDate,3)_" "_$zt(TTime)
					s TransUser=""
					//
					i $l(TUser) 
					{
						s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(TUser,"U"),""))
						i $l(UserId) s TransUser=$p(^SSU("SSUSR",UserId),"^",2)
					}
					s ToPerson=$p(str,"\",5)
					s PhoneNo=$p(str,"\",6)
					s TransMemo=$p(str,"\",7)
					
				}
				s ReportId=epis_"||"_ord 	
				set AmdLoc=""
				i AdmType="I" 
				{
					s CurrentWard=$p($g(^PAADM(adm)),"^",70)
					i $l(CurrentWard) s OrdLoc=$p(^PAWARD(CurrentWard),"^",1)
					s AmdLoc=$o(^CTLOC(0,"Code",$zcvt(OrdLoc,"U"),""))
				}else
				{
					s AmdLoc=$p($g(^PAADM(adm)),"^",4)
				}
   				;if AmdLoc'=63 continue
   				;w adm,!
				
				set DPRPResult=$REPLACE(DPRPResult,"结果","&nbsp;结果")
				set DPRPResult=$REPLACE(DPRPResult,"参考范围","&nbsp;&nbsp;参考范围")
				
				set Data=$lb(ind,ReportId,epis,TSName,PhoneNo,ToPerson,TransMemo,TDate,TTime,TransDT,TransUser,ReportType,adm,AmdLoc,ReportDate,ReportTime,aStatus,TransDate,TransTime,DPRPResult,OEOrdItemID)
 				Set ^||CacheTemp(repid,ind)=Data
 				Set ind=ind+1
				
			}
		}
	}  
	
	Quit $$$OK
CheckLoc1(adm,LocId,epis)
   //s adm=$p(^OEORD(OrdId),"^",1)
   s AdmType=$p(^PAADM(adm),"^",2)
   s OrdId=$o(^OEORD(0,"EpisNo",epis,""))
   i '$l(OrdId) q 0
   s OrdSub=$o(^OEORD(0,"EpisNo",epis,OrdId,""))
   i '$l(OrdSub) q 0 
   //
   s OrdLoc=$p(^OEORD(OrdId,"I",OrdSub,1),"^",3)
   i AdmType="I" d
   .s CurrentWard=$p(^PAADM(adm),"^",70)
   .i $l(CurrentWard) s OrdLoc=$p(^PAWARD(CurrentWard),"^",1)
   i '$l(OrdLoc) q 0
   s Locid=$o(^CTLOC(0,"Code",$zcvt(OrdLoc,"U"),""))
   s AmdLoc=$p(^PAADM(adm),"^",4)
  
   i (((LocId'="")&&(LocId'=Locid))&&((LocId'="")&&(LocId'=AmdLoc))) q 0   //医生，护士都可看见危急值报告
   q 1
CheckLoc2(adm,LocId,OEOrdId)
   //s adm=$p(^OEORD(OrdId),"^",1)
   s AdmType1=$p(^PAADM(adm),"^",2)
   s OrdLoc=$p(^OEORD($p(OEOrdId,"||",1),"I",$p(OEOrdId,"||",2),1),"^",3)
   i AdmType1="I" d
   .s CurrentWard=$p(^PAADM(adm),"^",70)
   .i $l(CurrentWard) s OrdLoc=$p(^PAWARD(CurrentWard),"^",1)
   ;w "OrdLoc:"_OrdLoc,!
   i '$l(OrdLoc) q 0
   s Locid=$o(^CTLOC(0,"Code",$zcvt(OrdLoc,"U"),""))
   s AmdLoc=$p(^PAADM(adm),"^",4)
   i (((LocId'="")&&(LocId'=Locid))&&((LocId'="")&&(LocId'=AmdLoc))) q 0   //医生，护士都可看见危急值报告
   q 1
}

/// Creator：      huhm
/// CreatDate：    20131008
/// Description:： 根据医嘱ID取医嘱名称
/// Table：        OE_OrdItem
/// Input：        医嘱ID
/// Output：       医嘱名称
/// Return：        
/// Others：       
ClassMethod GetOrdItemName(OEOrdId As %String) As %String
{
	//n (epis)
   s epis=$g(epis)
   s RetValue=""
   s OrdId=$p(OEOrdId,"||",1)
   i OrdId="" q ""
   s OrdSub=$p(OEOrdId,"||",2)
   i OrdSub="" q ""
   s OrdStr=$g(^OEORD(OrdId,"I",OrdSub,1))
   s ItmMastDr=$p(OrdStr,"^",2)
   i '$l(ItmMastDr) q ""
   i '$d(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)) q ""
   s RetValue=$p(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1),"^",2)
   q RetValue
}

/// Creator：      huhm
/// CreatDate：    20131008
/// Description:： 根据危急值项目ID 获取检查项目
/// Table：        OE_OrdItem
/// Input：        项目ID
/// Output：       检查项目
/// Return：        
/// Others
ClassMethod GetTSName(epis As %String) As %String
{
	//n (epis)
   s epis=$g(epis)
   s RetValue=""
   s OrdId="" f  s OrdId=$o(^OEORD(0,"EpisNo",epis,OrdId)) q:OrdId=""  d
   .s OrdSub="" f  s OrdSub=$o(^OEORD(0,"EpisNo",epis,OrdId,OrdSub)) q:OrdSub=""  d
   ..s OrdStr=$g(^OEORD(OrdId,"I",OrdSub,1))
   ..s ItmMastDr=$p(OrdStr,"^",2)
   ..i '$l(ItmMastDr) q
   ..i '$d(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)) q
   ..s TSName=$p(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1),"^",2)
   ..s RetValue=RetValue_TSName_"+"
   s RetValue=$p(RetValue,"+",1,$l(RetValue,"+")-1)
   q RetValue
}

}
