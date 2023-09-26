Class web.DHCANAnalgesia Extends %RegisteredObject
{

ClassMethod GetAnalgesiaFormula() As %String
{
	//镇痛配方对应医嘱串
	s FormulaList="260||1"_"~"_"261||1"_"~"_"265||1"_"~"_"1355||1"_"~"_"19||1"
	q FormulaList
}

/// w ##class(web.DHCANAnalgesia).FindAnalgesia(144)
ClassMethod FindAnalgesia(opaId) As %String
{
	q:opaId="" "opaId is null"
	
	s sub=$o(^DHCANOPArrange(opaId,"PAA",""),-1)
	q:sub="" ""
	s retStr=""
	s PAAType="",PAAPumpSpec="",PAABodySite="",PAAStartDate="",PAAStartTime="",PAAEndDate=""
	s PAAEndTime="",PAALockTime="",PAABackgroundDose="",PAAPCADose="",PAATotalAmount="",PAADispenseCtcpDr=""
	
	s PAAType=$p(^DHCANOPArrange(opaId,"PAA",sub),"^",1)
	s PAAPumpSpec=$p(^DHCANOPArrange(opaId,"PAA",sub),"^",2)
	s PAABodySite=$p(^DHCANOPArrange(opaId,"PAA",sub),"^",3)
	s PAAStartDate=$p(^DHCANOPArrange(opaId,"PAA",sub),"^",4)
	s PAAStartTime=$p(^DHCANOPArrange(opaId,"PAA",sub),"^",5)
	s PAAEndDate=$p(^DHCANOPArrange(opaId,"PAA",sub),"^",6)
	s PAAEndTime=$p(^DHCANOPArrange(opaId,"PAA",sub),"^",7)
	s PAALockTime=$p(^DHCANOPArrange(opaId,"PAA",sub),"^",8)
	s PAABackgroundDose=$p(^DHCANOPArrange(opaId,"PAA",sub),"^",9)
	s PAAPCADose=$p(^DHCANOPArrange(opaId,"PAA",sub),"^",10)
	s PAATotalAmount=$p(^DHCANOPArrange(opaId,"PAA",sub),"^",11)
	s PAADispenseCtcpDr=$p(^DHCANOPArrange(opaId,"PAA",sub),"^",12)
	
	i PAAStartDate'="" s PAAStartDate=$zd(PAAStartDate,3)
	i PAAEndDate'="" s PAAEndDate=$zd(PAAEndDate,3)
	i PAAStartTime'="" s PAAStartTime=$zt(PAAStartTime)
	i PAAEndTime'="" s PAAEndTime=$zt(PAAEndTime)
	
	//已保存医嘱串
	s AnalgesiaDrugList=""
	
	s PAADSub="" f  s PAADSub=$o(^DHCANOPArrange(opaId,"PAA",sub,"D",PAADSub)) q:PAADSub=""  d
	.q:PAADSub=0
	.s arcimId=$P(^DHCANOPArrange(opaId,"PAA",sub,"D",PAADSub),"^",1)
	.S uomId=$P(^DHCANOPArrange(opaId,"PAA",sub,"D",PAADSub),"^",3)
	.S dose=$P(^DHCANOPArrange(opaId,"PAA",sub,"D",PAADSub),"^",4)
	.s recLoc=$P(^DHCANOPArrange(opaId,"PAA",sub,"D",PAADSub),"^",9)
	.s startDate=$P(^DHCANOPArrange(opaId,"PAA",sub,"D",PAADSub),"^",5)
	.s startTime=$P(^DHCANOPArrange(opaId,"PAA",sub,"D",PAADSub),"^",6)
	.s AnalgesiaDrug=arcimId_$c(3)_uomId_$c(3)_dose_$c(3)_recLoc_$c(3)_$zd(startDate,3)_$c(3)_$zt(startTime)
	.i AnalgesiaDrugList="" s AnalgesiaDrugList=AnalgesiaDrug
	.e  s AnalgesiaDrugList=AnalgesiaDrugList_"~"_AnalgesiaDrug
	
	s retStr=sub_"^"_PAAType_"^"_PAAPumpSpec_"^"_PAABodySite_"^"_PAAStartDate_"^"_PAAStartTime_"^"_PAAEndDate_"^"_PAAEndTime_"^"_PAALockTime_"^"_PAABackgroundDose_"^"_PAAPCADose_"^"_PAATotalAmount_"^"_PAADispenseCtcpDr_"^"_AnalgesiaDrugList
	
	q retStr
}

//w ##class(web.DHCANAnalgesia).InsertAnalgesia(144,"PCA^^^^^^^")

ClassMethod InsertAnalgesia(opaId, ParaStr) As %String
{
	q:opaId="" "opaId is null"
	//s chl=$o(^DHCANOPArrange(opaId,"PAA",""),-1)
	
	s PAAType=$p(ParaStr,"^",1)
	s PAAPumpSpec=$p(ParaStr,"^",2)
	s PAABodySite=$p(ParaStr,"^",3)
	
	s PAAStartDate=+$h
	s PAAStartTime=$p($h,",",2)
	s PAAEndDate=+$h
	s PAAEndTime=$p($h,",",2)
	
	s PAALockTime=$p(ParaStr,"^",4)
	s PAABackgroundDose=$p(ParaStr,"^",5)
	s PAAPCADose=$p(ParaStr,"^",6)
	s PAATotalAmount=$p(ParaStr,"^",7)
	s PAADispenseCtcpDr=$p(ParaStr,"^",8)
	
	&sql(insert into SQLUSER.DHC_AN_Analgesia set PAA_Parref=:opaId,PAA_Type=:PAAType
	,PAA_PumpSpec=:PAAPumpSpec,PAA_BodySite=:PAABodySite,PAA_StartDate=:PAAStartDate
	,PAA_StartTime=:PAAStartTime,PAA_EndDate=:PAAEndDate,PAA_EndTime=:PAAEndTime
	,PAA_LockTime=:PAALockTime,PAA_BackgroundDose=:PAABackgroundDose,PAA_PCADose=:PAAPCADose
	,PAA_TotalAmount=:PAATotalAmount,PAA_DispenseCtcp_Dr=:PAADispenseCtcpDr
	)
	q SQLCODE
}

ClassMethod InsertAnalgesiaDrug(opaId, ParaStr) As %String
{
	q:opaId="" "opaId is null"
	s chl=$o(^DHCANOPArrange(opaId,"PAA",""),-1)
	s parref=opaId_"||"_chl
	//s chlD=$o(^DHCANOPArrange(opaId,"PAA",chl,"D",""),-1)
	//&sql(delete from SQLUSER.DHC_AN_AnalgesiaDrug where PAAD_Parref=:parref)
	
	f i=1:1:$l(ParaStr,"^") d
	.s Para=$p(ParaStr,"^",i)
	.i Para'="" d
	..s arcimId=$p(Para,$c(3),1)
	..s dose=$p(Para,$c(3),2)
	..s uomId=$p(Para,$c(3),3)
	..s recLoc=$p(Para,$c(3),4)
	..s PAADStartDate=+$h
	..s PAADStartTime=$p($h,",",2)
	..s PAADEndDate=+$h
	..s PAADEndTime=$p($h,",",2)
	
	..&sql(insert into SQLUSER.DHC_AN_AnalgesiaDrug set PAAD_Parref=:parref
	,PAAD_Arcim_Dr=:arcimId,PAAD_Uom=:uomId,PAAD_Dose=:dose
	,PAAD_StartDate=:PAADStartDate,PAAD_StartTime=:PAADStartTime
	,PAAD_EndDate=:PAADEndDate,PAAD_EndTime=:PAADEndTime,PAAD_RecCtloc=:recLoc)
	
	q 0
}

}
