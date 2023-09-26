Import SQLUser

Class web.DHCRisAgilityStatics Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 247;

/// d ##class(%ResultSet).RunQuery("web.DHCRisAgilityStatics","AgilityStatics","780^^^^^^^N^N^N^N^",61116,61116)
/// add 联系电话、年龄、住院号
Query AgilityStatics(strCondition As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "RegNo:%String,Name:%String,SexDesc:%String,typedesc:%String,GetstrOrderName:%String,strBodyDesc:%String,Num:%String,TotalPrice:%String,OptionCareProvDesc:%String,strRegDate:%String,strRegTime:%String,ReportCareProvDesc:%String,GetRptDate:%String,GetRptTime:%String,VerifyCareProvDesc:%String,GetVerifyDate:%String,GetVerifyTime:%String,GetRptIsYX:%String,StudyNo:%String,AppLocDesc:%String,Dialogonse:%String,Telphone:%String,strAge:%String,IpNo:%String,RegEQDesc:%String,MainDoc:%String,AssDoc:%String")
{
}

ClassMethod AgilityStaticsExecute(ByRef qHandle As %Binary, strCondition As %String, StartDate As %String, EndDate As %String) As %Status
{
	set repid=$I(^CacheTemp)
	s ind=1
	s ^TMPRIS("RIS",1)=strCondition_"$"_StartDate_"^"_EndDate

 	s LocId=$p(strCondition,"^",1)
 	s OptionId=$p(strCondition,"^",2)
 	s TechnicianId=$p(strCondition,"^",3)
 	s ReportDocId=$p(strCondition,"^",4)
 	s VerifyDocId=$p(strCondition,"^",5)
 	s ArcItemRowId=$p(strCondition,"^",6)
 	s BodyPartId=$p(strCondition,"^",7)
 	s BedofOrder=$p(strCondition,"^",8)
 	s NoBedOrder=$p(strCondition,"^",9)
 	s EnhanceOrder=$p(strCondition,"^",10)
 	s CommOrder=$p(strCondition,"^",11)
 	s AppLocId=$p(strCondition,"^",12)
 	s IsRptDate=$p(strCondition,"^",13)
 	s SexID=$p(strCondition,"^",14)
 	s InAge=$p(strCondition,"^",15)
 	s AgeRangeA=$p(strCondition,"^",16)
 	s AgeRangeB=$p(strCondition,"^",17)
 	s:AppLocId=" " AppLocId=""
 	
 	if (IsRptDate'="Y")
 	{
	 	s return=..QuerybyRegDate(StartDate,EndDate,LocId,OptionId,TechnicianId,ReportDocId,VerifyDocId,ArcItemRowId,BodyPartId,BedofOrder,NoBedOrder,EnhanceOrder,CommOrder,AppLocId,SexID,InAge,AgeRangeA,AgeRangeB)
	}
	else
	{
		s return=..QuerybyRptDate(StartDate,EndDate,LocId,OptionId,TechnicianId,ReportDocId,VerifyDocId,ArcItemRowId,BodyPartId,BedofOrder,NoBedOrder,EnhanceOrder,CommOrder,AppLocId,SexID,InAge,AgeRangeA,AgeRangeB)
	}
 	
 	Quit $$$OK
}

ClassMethod AgilityStaticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AgilityStaticsExecute ]
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
  	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod AgilityStaticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AgilityStaticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Trimc(Result2 As %String) As %String
{
	s Result=$TR(Result2,"_$c_","")
	s Result=$TR(Result,"_$c(13,10)_","")
	s Result=$TR(Result,"_$c(10)_","")
	s Result=$TR(Result,"_$c(13)_","")
	Q Result
}

/// do ##class(web.DHCRisAgilityStatics).GetSexListStr()
ClassMethod GetSexListStr() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisNewPatient:QuerySex")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
	    i ret="" s ret=rset.GetData(2)_$C(1)_rset.GetData(1)_"-"_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(2)_$C(1)_rset.GetData(1)_"-"_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

ClassMethod QuerybyRegDate(StartDate, EndDate, LocId, OptionId, TechnicianId, ReportDocId, VerifyDocId, ArcItemRowId, BodyPartId, BedofOrder, NoBedOrder, EnhanceOrder, CommOrder, AppLocId, SexID, InAge, AgeRangeA, AgeRangeB)
{
	s TotalFee=0,TotalNum=0
 	
    for date=StartDate:1:EndDate
    {
	  s Regrowid=0 f  s Regrowid=$o(^DHCPACRegInfoi("RegDate",date,Regrowid)) q:Regrowid=""  d    
      .s bOut="N"  ;是否已经输出
      .q:$d(^DHCPACRegInfo(Regrowid))=0 
      .s RegLocDR=$p(^DHCPACRegInfo(Regrowid),"^",13)
      .q:LocId'=RegLocDR   ; 执行科室不是当前科室
      .s oeorditemdr=$p(^DHCPACRegInfo(Regrowid),"^",11)
      .;w !,"oeorditemdr"_oeorditemdr
      .s StudyNo=$p(^DHCPACRegInfo(Regrowid),"^",2)
	  .s strRegDate=$zd(date,3)
	  .s RegTime=$p(^DHCPACRegInfo(Regrowid),"^",9)
	  .s strRegTime=""
	  .i RegTime'="" s strRegTime=$zt(RegTime,1)
	  .s MainDocDr="",assDocDr="",MainDoc="",AssDoc=""
	  .s MainDocDr=$p($g(^DHCPACRegInfo(Regrowid)),"^",5)
	  .s assDocDr=$p($g(^DHCPACRegInfo(Regrowid)),"^",6)
	  .s RegEQDr=$p(^DHCPACRegInfo(Regrowid),"^",14)
	  .i RegEQDr'="" s RegEQDesc=$p($g(^RBC("EQ",RegEQDr)),"^",2)
	  .q:(TechnicianId'="")&(MainDocDr'=TechnicianId) ;按检查技师,没有找到
 	  .i MainDocDr'="" s MainDoc=$p($g(^CTPCP(MainDocDr,1)),"^",2)
 	  .i assDocDr'="" s AssDoc=$p($g(^CTPCP(assDocDr,1)),"^",2)
	  .s OptionUserID=$p(^DHCPACRegInfo(Regrowid),"^",7)
	  .s OptionCareProvId="",OptionCareProvDesc=""
	  .i OptionUserID'="" s OptionCareProvId=$p($g(^SSU("SSUSR",OptionUserID)),"^",14)
	  .q:(OptionId'="")&(OptionId'=OptionCareProvId) ;按登记的人查询,没有找到
	  .i OptionCareProvId'="" s OptionCareProvDesc=$p($g(^CTPCP(OptionCareProvId,1)),"^",2)
      .s OrderRowid=$p(oeorditemdr,"||",1)
      .s itemsub=$p(oeorditemdr,"||",2)
      .s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
      .s orddeptDr=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",3)
      .s AppLocDesc=""
      .i orddeptDr'="" s AppLocDesc=$p(^CTLOC(orddeptDr),"^",2) 
      .q:(AppLocId'="")&(AppLocId'=orddeptDr) ;申请科室不是查询科室则退出
      .q:(ArcItemRowId'="")&(ArcItemRowId'=arcimid) ; 医嘱项目没有找到
      .s GetstrOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
      .q:(BedofOrder="Y")&('(GetstrOrderName["床旁")) ; 检索床旁医嘱，不是床旁医嘱则退出
      .q:(NoBedOrder="Y")&(GetstrOrderName["床旁") ; 检索非床旁医嘱，是床旁医嘱则退出
	  .q:(EnhanceOrder="Y")&('(GetstrOrderName["增强")) ; 检索增强医嘱，不是增强医嘱则退出
      .q:(CommOrder="Y")&(GetstrOrderName["增强") ; 检索非增强医嘱，是增强医嘱则退出
      .s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
      .s price=##class(web.DHCRisCommFunction).GetItemPrice(oeorditemdr)
      .s TotalPrice=price*Num
	  .s TotalFee=TotalFee+TotalPrice
	  .s TotalNum=TotalNum+Num
      .s paadmdr=$p(^DHCPACRegInfo(Regrowid),"^",10)
      .s papatmasmdr=$p(^PAADM(paadmdr),"^",1)        
      .s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)  
      .s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
      .s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
      .q:(SexID'="")&(SexID'=SexDr)   ;按性别查询
      .i SexDr'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)
      .s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
      .s typedesc=##class(web.DHCRisCommFunction).GetTypeDesc(patienttype)
      .s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
      .i DOB="" d
 	 	..s strDOB=""
 	 	..s strAge=""
 	  .e  d
      ..s strDOB=$ZD(DOB,3)
      ..s strToday=$ZD(+$h,3)
      ..s strAge=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
      ..s year=$p(strDOB,"-",1)
      ..s Month=$p(strDOB,"-",2)
      ..s day=$p(strDOB,"-",3)
      ..s strDOB=day_"/"_Month_"/"_year
      .i strAge'="" s Age=$p($g(strAge),"岁",1)
      .q:(InAge'="")&(InAge'=Age)
      .q:((AgeRangeA'="")&(Age<AgeRangeA))
      .q:((AgeRangeB'="")&(Age>AgeRangeB))
      .s IPNO=##class(web.DHCRisCommFunctionEx).GetIPNO(papatmasmdr)   //获得住院号
      .s Telphone=$p($g(^PAPER(papatmasmdr,"PER",1)),"^",11) 
  	  .s strBodyDesc="",IsFindBodyPart=0
	  .i BodyPartId="" s IsFindBodyPart=1
	  .s ChildSub=0  f  s ChildSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,Regrowid,ChildSub)) q:ChildSub=""  d
	  ..s BodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,Regrowid,ChildSub),"^",1) 
	  ..i (BodyPartId'="")&(BodyDr=BodyPartId) s IsFindBodyPart=1
	  ..i BodyDr'="" s BodyDesc=$p(^MRC("BODP",BodyDr),"^",2)
	  ..i strBodyDesc="" s strBodyDesc=$g(BodyDesc)
	  ..else  s strBodyDesc=strBodyDesc_","_$g(BodyDesc)
	  .q:(BodyPartId'="")&(IsFindBodyPart=0)   ;按部位查询没有找到 
	  .; 按报告医生和审核医生统计 
	  .s ReportCareProvId="",ReportCareProvDesc="",VerifyCareProvId="",VerifyCareProvDesc=""
	  .s GetRptDate="",GetRptTime="",GetVerifyDate="",GetVerifyTime=""
	  .s ReportDocId="",VerifyDocId=""
	  .q:(StudyNo="")
      .s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
      .i (Rptrowid'="") d
      ..i $d(^DHCRBStudy("Report",Rptrowid)) d 
      ..s GetRptIsYX=$p(^DHCRBStudy("Report",Rptrowid),"^",7)
      ..s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
      ..i GetRptDocDR'="" s ReportCareProvId=$p($g(^SSU("SSUSR",GetRptDocDR)),"^",14)
	  ..i ReportCareProvId'="" s ReportCareProvDesc=$p($g(^CTPCP(ReportCareProvId,1)),"^",2)
      ..s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
      ..i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
      ..s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
      ..i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
      ..s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
      ..i GetVerifyDocDR'="" s VerifyCareProvId=$p($g(^SSU("SSUSR",GetVerifyDocDR)),"^",14)
	  ..i VerifyCareProvId'="" s VerifyCareProvDesc=$p($g(^CTPCP(VerifyCareProvId,1)),"^",2)
      ..s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
      ..i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
      ..s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
      ..i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
      ..s Result1=$g(^DHCRBStudy("Report",Rptrowid,"ResultDescEx"))
      ..s Resullt=..Trimc(Result1)
      ..q:(ReportDocId'="")&(ReportDocId'=ReportCareProvId) ;按报告人查询,没有找到
      ..q:(VerifyDocId'="")&(VerifyDocId'=VerifyCareProvId) ; 按审核人没有找到
      ..s bOut="Y"
      ..Do OutRow4
      .i (bOut="N")&(ReportDocId="")&(VerifyDocId="")  d
      ..s bOut="Y"
      ..Do OutRow4
      
   }
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutRow4
    set Data=$lb(RegNo,Name,SexDesc,typedesc,GetstrOrderName,strBodyDesc,Num,TotalPrice,OptionCareProvDesc,strRegDate,
    strRegTime,ReportCareProvDesc,GetRptDate,GetRptTime,VerifyCareProvDesc,GetVerifyDate,GetVerifyTime,GetRptIsYX,StudyNo,AppLocDesc,Result,Telphone,strAge,IPNO,RegEQDesc,MainDoc,AssDoc)
   	Set ^CacheTemp(repid,ind)=Data
   	set ^CacheTemp(repid,ind+1)=$lb("合计","","","","","",TotalNum,TotalFee,"","","","","","","","","","","","")
	Set ind=ind+1
 	quit
}

ClassMethod QuerybyRptDate(StartDate, EndDate, LocId, OptionId, TechnicianId, ReportDocId, VerifyDocId, ArcItemRowId, BodyPartId, BedofOrder, NoBedOrder, EnhanceOrder, CommOrder, AppLocId, SexID, InAge, AgeRangeA, AgeRangeB)
{
	s TotalFee=0,TotalNum=0
	
	for date=StartDate:1:EndDate
    {
	  s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("ReportDate",date,RptRowId)) q:RptRowId=""  d
	  .s StudyNo=$p(^DHCRBStudy("Report",RptRowId),"^",1)
	  .q:(StudyNo="")
	  .s Regrowid=""
	  .s Regrowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,""),-1) q:Regrowid=""  
	  .s bOut="N"  ;是否已经输出
      .q:$d(^DHCPACRegInfo(Regrowid))=0 
      .s RegLocDR=$p(^DHCPACRegInfo(Regrowid),"^",13)
      .q:LocId'=RegLocDR   ; 执行科室不是当前科室
      .s oeorditemdr=$p(^DHCPACRegInfo(Regrowid),"^",11)
      .;w !,"oeorditemdr"_oeorditemdr
      .s StudyNo=$p(^DHCPACRegInfo(Regrowid),"^",2)
	  .s strRegDate=$zd(date,3)
	  .s RegTime=$p(^DHCPACRegInfo(Regrowid),"^",9)
	  .s strRegTime=""
	  .i RegTime'="" s strRegTime=$zt(RegTime,1)
	  .s MainDocDr="",assDocDr="",MainDoc="",AssDoc=""
	  .s MainDocDr=$p($g(^DHCPACRegInfo(Regrowid)),"^",5)
	  .s assDocDr=$p($g(^DHCPACRegInfo(Regrowid)),"^",6)
	  .s RegEQDr=$p(^DHCPACRegInfo(Regrowid),"^",14)
	  .i RegEQDr'="" s RegEQDesc=$p($g(^RBC("EQ",RegEQDr)),"^",2)
	  .q:(TechnicianId'="")&(MainDocDr'=TechnicianId) ;按检查技师,没有找到
 	  .i MainDocDr'="" s MainDoc=$p($g(^CTPCP(MainDocDr,1)),"^",2)
 	  .i assDocDr'="" s AssDoc=$p($g(^CTPCP(assDocDr,1)),"^",2)
	  .s OptionUserID=$p(^DHCPACRegInfo(Regrowid),"^",7)
	  .s OptionCareProvId="",OptionCareProvDesc=""
	  .i OptionUserID'="" s OptionCareProvId=$p($g(^SSU("SSUSR",OptionUserID)),"^",14)
	  .q:(OptionId'="")&(OptionId'=OptionCareProvId) ;按登记的人查询,没有找到
	  .i OptionCareProvId'="" s OptionCareProvDesc=$p($g(^CTPCP(OptionCareProvId,1)),"^",2)
      .s OrderRowid=$p(oeorditemdr,"||",1)
      .s itemsub=$p(oeorditemdr,"||",2)
      .s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
      .s orddeptDr=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",3)
      .s AppLocDesc=""
      .i orddeptDr'="" s AppLocDesc=$p(^CTLOC(orddeptDr),"^",2) 
      .q:(AppLocId'="")&(AppLocId'=orddeptDr) ;申请科室不是查询科室则退出
      .q:(ArcItemRowId'="")&(ArcItemRowId'=arcimid) ; 医嘱项目没有找到
      .s GetstrOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
      .q:(BedofOrder="Y")&('(GetstrOrderName["床旁")) ; 检索床旁医嘱，不是床旁医嘱则退出
      .q:(NoBedOrder="Y")&(GetstrOrderName["床旁") ; 检索非床旁医嘱，是床旁医嘱则退出
	  .q:(EnhanceOrder="Y")&('(GetstrOrderName["增强")) ; 检索增强医嘱，不是增强医嘱则退出
      .q:(CommOrder="Y")&(GetstrOrderName["增强") ; 检索非增强医嘱，是增强医嘱则退出
      .s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
      .s price=##class(web.DHCRisCommFunction).GetItemPrice(oeorditemdr)
      .s TotalPrice=price*Num
	  .s TotalFee=TotalFee+TotalPrice
	  .s TotalNum=TotalNum+Num
      .s paadmdr=$p(^DHCPACRegInfo(Regrowid),"^",10)
      .s papatmasmdr=$p(^PAADM(paadmdr),"^",1)        
      .s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)  
      .s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
      .s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
      .q:(SexID'="")&(SexID'=SexDr)   ;按性别查询
      .i SexDr'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)
      .s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
      .s typedesc=##class(web.DHCRisCommFunction).GetTypeDesc(patienttype)
      .s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
      .i DOB="" d
 	 	..s strDOB=""
 	 	..s strAge=""
 	  .e  d
      ..s strDOB=$ZD(DOB,3)
      ..s strToday=$ZD(+$h,3)
      ..s strAge=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
      ..s year=$p(strDOB,"-",1)
      ..s Month=$p(strDOB,"-",2)
      ..s day=$p(strDOB,"-",3)
      ..s strDOB=day_"/"_Month_"/"_year
      .i strAge'="" s Age=$p($g(strAge),"岁",1)
      .q:(InAge'="")&(InAge'=Age)
      .q:((AgeRangeA'="")&(Age<AgeRangeA))
      .q:((AgeRangeB'="")&(Age>AgeRangeB))
      .s IPNO=##class(web.DHCRisCommFunctionEx).GetIPNO(papatmasmdr)   //获得住院号
      .s Telphone=$p($g(^PAPER(papatmasmdr,"PER",1)),"^",11) 
  	  .s strBodyDesc="",IsFindBodyPart=0
	  .i BodyPartId="" s IsFindBodyPart=1
	  .s ChildSub=0  f  s ChildSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,Regrowid,ChildSub)) q:ChildSub=""  d
	  ..s BodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,Regrowid,ChildSub),"^",1) 
	  ..i (BodyPartId'="")&(BodyDr=BodyPartId) s IsFindBodyPart=1
	  ..i BodyDr'="" s BodyDesc=$p(^MRC("BODP",BodyDr),"^",2)
	  ..i strBodyDesc="" s strBodyDesc=$g(BodyDesc)
	  ..else  s strBodyDesc=strBodyDesc_","_$g(BodyDesc)
	  .q:(BodyPartId'="")&(IsFindBodyPart=0)   ;按部位查询没有找到 
	  .; 按报告医生和审核医生统计 
	  .s ReportCareProvId="",ReportCareProvDesc="",VerifyCareProvId="",VerifyCareProvDesc=""
	  .s GetRptDate="",GetRptTime="",GetVerifyDate="",GetVerifyTime=""
	  .s ReportDocId="",VerifyDocId=""
	  .s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
      .i (Rptrowid'="") d
      ..i $d(^DHCRBStudy("Report",Rptrowid)) d 
      ..s GetRptIsYX=$p(^DHCRBStudy("Report",Rptrowid),"^",7)
      ..s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
      ..i GetRptDocDR'="" s ReportCareProvId=$p($g(^SSU("SSUSR",GetRptDocDR)),"^",14)
	  ..i ReportCareProvId'="" s ReportCareProvDesc=$p($g(^CTPCP(ReportCareProvId,1)),"^",2)
      ..s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
      ..i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
      ..s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
      ..i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
      ..s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
      ..i GetVerifyDocDR'="" s VerifyCareProvId=$p($g(^SSU("SSUSR",GetVerifyDocDR)),"^",14)
	  ..i VerifyCareProvId'="" s VerifyCareProvDesc=$p($g(^CTPCP(VerifyCareProvId,1)),"^",2)
      ..s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
      ..i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
      ..s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
      ..i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
      ..s Result1=$g(^DHCRBStudy("Report",Rptrowid,"ResultDescEx"))
      ..s Resullt=..Trimc(Result1)
      ..q:(ReportDocId'="")&(ReportDocId'=ReportCareProvId) ;按报告人查询,没有找到
      ..q:(VerifyDocId'="")&(VerifyDocId'=VerifyCareProvId) ; 按审核人没有找到
      ..s bOut="Y"
      ..Do OutRow5
      .i (bOut="N")&(ReportDocId="")&(VerifyDocId="")  d
      ..s bOut="Y"
      ..Do OutRow5
	
	}
	
	 Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutRow5
    set Data=$lb(RegNo,Name,SexDesc,typedesc,GetstrOrderName,strBodyDesc,Num,TotalPrice,OptionCareProvDesc,strRegDate,
    strRegTime,ReportCareProvDesc,GetRptDate,GetRptTime,VerifyCareProvDesc,GetVerifyDate,GetVerifyTime,GetRptIsYX,StudyNo,AppLocDesc,Result,Telphone,strAge,IPNO,RegEQDesc,MainDoc,AssDoc)
   	Set ^CacheTemp(repid,ind)=Data
   	set ^CacheTemp(repid,ind+1)=$lb("合计","","","","","",TotalNum,TotalFee,"","","","","","","","","","","","")
	Set ind=ind+1
 	quit
}

}
