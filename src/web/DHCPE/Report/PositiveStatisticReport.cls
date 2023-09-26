Class web.DHCPE.Report.PositiveStatisticReport Extends %RegisteredObject [ ProcedureBlock ]
{

Query IllnessReport(StartDate As %Library.String = "", EndDate As %Library.String = "", Male As %Library.String = "", Female As %Library.String = "", PETotal As %Library.String = "", ILLAmount As %Library.String = "", GroupDR As %Library.String = "") As %Query(ROWSPEC = "ILLCode:%String,ILLName:%String, ILLTotal:%String, illage1:%String, illage2:%String, illage3:%String, illage4:%String, illage5:%String, illage6:%String, illage7:%String")
{
}

ClassMethod IllnessReportExecute(ByRef qHandle As %Binary, StartDate As %Library.String = "", EndDate As %Library.String = "", Male As %Library.String = "", Female As %Library.String = "", PETotal As %Library.String = "", ILLAmount As %Library.String = "", GroupDR As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^DHCPETMPSR
 	s ^DHCPETMPSR("IllnessInfo")=Male_"^"_Female_"^"_PETotal_"^"_ILLAmount_"^"_GroupDR
	i StartDate=""  s StartDate=+$h-30
    i EndDate=""  s EndDate=+$h
    s IADM=0
    i GroupDR=""
    {
    f CurDate=StartDate:1:EndDate d
    .s DateTime=""
    .f  s DateTime=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,DateTime)) q:DateTime=""  d
    ..f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,DateTime,IADM)) q:IADM=""  d
    ...///s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADM)          //区分科室
  	...///q:LocFlag=1
    ...s Status=$P($g(^DHCPEIADM(IADM)),"^",8)
	...q:Status'="ARRIVED"
	...s PREIADM=$p(^DHCPEIADM(IADM),"^",4)
	...s PIBIDR=$P($g(^DHCPEPreIADM(PREIADM)),"^",1)
	...q:PIBIDR=""
	...s PIBISex=$p(^DHCPEPreIBI(PIBIDR),"^",3)
	...q:(Male="on")&(PIBISex'="10")
	...q:(Female="on")&(PIBISex'="11")
	...s PIBIDOB=$p(^DHCPEPreIBI(PIBIDR),"^",4)
	...s Age=""
 	...i PIBIDOB'="" d
 	....s Age=##class(web.DHCLCNUREXCUTE).CalAge(PIBIDOB,+$h)
 	....s Age=+$P(Age,"Y",1)
 	...q:Age<18 //18岁以下不统计
	...s AgeArea=..GetAgeArea(Age)
	...s ^DHCPETMPSR("IADM",IADM)=AgeArea
    }
    i GroupDR'=""
    {
	s GTSub=0
	f  s GTSub=$o(^DHCPEGADM(GroupDR,"Team",GTSub)) q:GTSub=""  d
	.s GTRowId=GroupDR_"||"_GTSub
	.f  s IADM=$o(^DHCPEIADM(0,"GADM",GroupDR,GTRowId,IADM)) q:IADM=""  d
	..s Status=$P($g(^DHCPEIADM(IADM)),"^",8)
	..q:Status'="ARRIVED"
	..s PREIADM=$p(^DHCPEIADM(IADM),"^",4)
	..s PIBIDR=$P($g(^DHCPEPreIADM(PREIADM)),"^",1)
	..q:PIBIDR=""
	..s PIBISex=$p(^DHCPEPreIBI(PIBIDR),"^",3)
	..q:(Male="on")&(PIBISex'="10")
	..q:(Female="on")&(PIBISex'="11")
	..s PIBIDOB=$p(^DHCPEPreIBI(PIBIDR),"^",4)
	..s Age=""
 	..i PIBIDOB'="" d
 	...s Age=##class(web.DHCLCNUREXCUTE).CalAge(PIBIDOB,+$h)
 	..s Age=+$P(Age,"Y",1)
 	..q:Age<18 //18岁以下不统计
	..s AgeArea=..GetAgeArea(Age)
	..s ^DHCPETMPSR("IADM",IADM)=AgeArea
	    
	}
	
	i ILLAmount="on"
	{
	s IADM=0
	f  s IADM=$O(^DHCPETMPSR("IADM",IADM)) Q:(""=IADM)  d
	.s AgeArea=$G(^DHCPETMPSR("IADM",IADM))
	.s GSRowId=0
	.// DHC_PE_GeneralSummarize
	.f  s GSRowId=$O(^DHCPEGS(0,"IADM",IADM,GSRowId)) Q:(""=GSRowId)  d
	..s GSDChildSub=0
	..// DHC_PE_GSDiagnosis
	..f  s GSDChildSub=$O(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)) Q:(""=GSDChildSub)  d
	...// DHC_PE_GSDiagnosis->DHC_PE_ExpertDiagnosis<=>DHC_PE_IDRelate
	...s GSDEDDR=$P($G(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub)),"^",1)
	...s ^DHCPETMPSR("GSDEDDR",GSDEDDR)=""
	...s IDRRowId=0
	...f  s IDRRowId=$O(^DHCPEIDR(0,"EDDR",GSDEDDR,IDRRowId)) Q:(""=IDRRowId)  d
	....// DHC_PE_IDRelate<=>DHC_PE_IllnessStandard
	....s IDRILLSDR=$P($G(^DHCPEIDR(IDRRowId)),"^",2)
	....s ILLSCode=$P($G(^DHCPEILLS(IDRILLSDR)),"^",1)
	....s ILLSDesc=$P($G(^DHCPEILLS(IDRILLSDR)),"^",2)
	....s ILLToReport=$P($G(^DHCPEILLS(IDRILLSDR)),"^",8)
	....q:ILLToReport'=1
	....s ILLSex=$P($G(^DHCPEILLS(IDRILLSDR)),"^",9)
	....q:(Male="on")&(ILLSex'="M")
	....q:(Female="on")&(ILLSex'="F")
	....s ^DHCPETMPSR("ADMILL",IADM,IDRILLSDR)=ILLSDesc
    .
	.s ISDR=""
	.f  s ISDR=$O(^DHCPETMPSR("ADMILL",IADM,ISDR)) Q:(""=ISDR)  d
	..s ISDesc=^DHCPETMPSR("ADMILL",IADM,ISDR)
	..s ^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,"Total")=+$G(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,"Total"))+1
	..s ^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,"List")=$G(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,"List"))_IADM_"^"
	..s ^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea)=+$G(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))+1
	..s ^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,"Desc")=ISDesc
	
	s ISDR=0
	f  s ISDR=$o(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR)) q:ISDR=""  d
	.s ISCode=$P($G(^DHCPEILLS(ISDR)),"^",1)
	.s ISCode=$e(ISCode,6,8)
	.s ISDesc=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,"Desc"))
	.s ILLTotal=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,"Total"))
	.s AgeArea="",illage1="",illage2="",illage3="",illage4="",illage5="",illage6="",illage7=""
	.f  s AgeArea=$o(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea)) q:AgeArea=""  d
	..i AgeArea=1 s illage1=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))
	..i AgeArea=2 s illage2=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))
	..i AgeArea=3 s illage3=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))
	..i AgeArea=4 s illage4=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))
	..i AgeArea=5 s illage5=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))
	..i AgeArea=6 s illage6=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))
	..i AgeArea=7 s illage7=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))
    .s Data=$lb(ISCode,ISDesc,ILLTotal,illage1,illage2,illage3,illage4,illage5,illage6,illage7)
	.d IllnessReportOut
	}
	
	i PETotal="on"
	{
	s IADM=0,ILLDescs="总胆固醇^甘油三酯^低密度脂蛋白^高密度脂蛋白^葡萄糖^谷丙转氨酶^肌酐^尿酸^乙肝表面抗原"
	f  s IADM=$O(^DHCPETMPSR("IADM",IADM)) Q:(""=IADM)  d
	.s AgeArea=$G(^DHCPETMPSR("IADM",IADM))
	.i Male="on" s Sex="M",^DHCPETMPSR("ADMALL",IADM,"8")="体检总人数"
	.i Female="on" s Sex="F",^DHCPETMPSR("ADMALL",IADM,"9")="体检总人数"
	.s PREIADM=$p(^DHCPEIADM(IADM),"^",4)
	.s PIOISub=0
	.f  s PIOISub=$O(^DHCPEPreIADM(PREIADM,"ORDITEM",PIOISub)) q:PIOISub=""  d
	..s ItmMast=$p(^DHCPEPreIADM(PREIADM,"ORDITEM",PIOISub),"^",1)
	..s ItmStat=$p(^DHCPEPreIADM(PREIADM,"ORDITEM",PIOISub),"^",16)
	..q:ItmStat'=1
	..s ODRRowId=0
	..f  s ODRRowId=$o(^DHCPEODR(0,"ARCIM",ItmMast,ODRRowId)) q:ODRRowId=""  d
	...s ODDR=$p(^DHCPEODR(ODRRowId),"^",2)
	...q:+ODDR'="8"
	...s ODDesc=$P(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2)),"^",1)
	...f i=1:1:9 d
	....s ILLDesc=$p(ILLDescs,"^",i)
	....i ODDesc[ILLDesc d
	.....i ILLDesc="葡萄糖" s ILLDesc="空腹血糖"
	.....i ILLDesc="谷丙转氨酶" s ILLDesc="丙氨酸氨基转移酶"
	.....i Male="on" s ^DHCPETMPSR("ADMALL",IADM,11+i)=ILLDesc
	.....i Female="on" s ^DHCPETMPSR("ADMALL",IADM,14+i)=ILLDesc
	..
	..
	..
	..
	..q:'$d(^DHCPETMPSRData(ItmMast,Sex))
	..s ItemId=""
	..f  s ItemId=$o(^DHCPETMPSRData(ItmMast,Sex,ItemId)) q:ItemId=""  d
	...s ItemId=$p(^DHCPETMPSRData(ItmMast,Sex,ItemId),"^",1)
	...s ItemName=$p(^DHCPETMPSRData(ItmMast,Sex,ItemId),"^",2)
	...s ^DHCPETMPSR("ADMALL",IADM,ItemId)=ItemName
	..
	..
	..
	..
	.s ItemId=""
	.f  s ItemId=$O(^DHCPETMPSR("ADMALL",IADM,ItemId)) Q:(""=ItemId)  d
	..s ItemName=^DHCPETMPSR("ADMALL",IADM,ItemId)
	..s ^DHCPETMPSR("PEList","PEStandard",ItemId,"Total")=+$G(^DHCPETMPSR("PEList","PEStandard",ItemId,"Total"))+1
	..//s ^DHCPETMPSR("PEList","PEStandard",ItemId,"List")=$G(^DHCPETMPSR("PEList","PEStandard",ItemId,"List"))_IADM_"^"
	..s ^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea)=+$G(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))+1
	..s ^DHCPETMPSR("PEList","PEStandard",ItemId,"Desc")=ItemName
	
	s ItemId=0
	f  s ItemId=$o(^DHCPETMPSR("PEList","PEStandard",ItemId)) q:ItemId=""  d
	.s ItemName=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,"Desc"))
	.s PETotal=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,"Total"))
	.s AgeArea="",illage1="",illage2="",illage3="",illage4="",illage5="",illage6="",illage7=""
	.f  s AgeArea=$o(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea)) q:AgeArea=""  d
	..i AgeArea=1 s illage1=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))
	..i AgeArea=2 s illage2=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))
	..i AgeArea=3 s illage3=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))
	..i AgeArea=4 s illage4=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))
	..i AgeArea=5 s illage5=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))
	..i AgeArea=6 s illage6=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))
	..i AgeArea=7 s illage7=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))
    .s Data=$lb(ItemId,ItemName,PETotal,illage1,illage2,illage3,illage4,illage5,illage6,illage7)
	.d IllnessReportOut
	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
IllnessReportOut
	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod IllnessReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IllnessReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid, ind)
 	}
 	s qHandle=$lb(AtEnd,repid, ind)
	Quit $$$OK
}

ClassMethod IllnessReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IllnessReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAgeArea(Age As %String = "")
{
	s Age=+$G(Age)
	
    q:(Age>=18)&(Age<=29) 1
	q:(Age>=30)&(Age<=39) 2
	q:(Age>=40)&(Age<=49) 3
	q:(Age>=50)&(Age<=59) 4
	q:(Age>=60)&(Age<=69) 5
	q:(Age>=70)&(Age<=79) 6
	q:(Age>=80) 7
	
	q
}

ClassMethod SetDHCPETMPSRData()
{
	s ^DHCPETMPSRData("15336||1","M",1)=1_"^"_"测身高体重"
	s ^DHCPETMPSRData("15336||1","M",2)=2_"^"_"测血压"
	s ^DHCPETMPSRData("15338||1","M",3)=3_"^"_"外科检查"
	s ^DHCPETMPSRData("559||1","M",4)=4_"^"_"裂隙灯检查"
	s ^DHCPETMPSRData("596||1","M",5)=5_"^"_"眼底检查"
	s ^DHCPETMPSRData("11219||1","M",6)=6_"^"_"肝胆B超"
	s ^DHCPETMPSRData("11219||1","M",7)=7_"^"_"肾B超"
	s ^DHCPETMPSRData("13604||1","M",9)=9_"^"_"骨密度"
	s ^DHCPETMPSRData("15381||1","M",10)=10_"^"_"肺X线检查"
	s ^DHCPETMPSRData("15346||1","M",11)=11_"^"_"心电图检查"

	
	
	s ^DHCPETMPSRData("15336||1","F",1)=1_"^"_"测身高体重"
	s ^DHCPETMPSRData("15336||1","F",2)=2_"^"_"测血压"
	s ^DHCPETMPSRData("15338||1","F",3)=3_"^"_"外科检查"
	s ^DHCPETMPSRData("15342||1","F",4)=4_"^"_"妇科检查"
	s ^DHCPETMPSRData("559||1","F",5)=5_"^"_"裂隙灯检查"
	s ^DHCPETMPSRData("596||1","F",6)=6_"^"_"眼底检查"
	s ^DHCPETMPSRData("11219||1","F",7)=7_"^"_"肝胆B超"
	s ^DHCPETMPSRData("11219||1","F",8)=8_"^"_"肾B超"
	s ^DHCPETMPSRData("3736||1","F",10)=10_"^"_"妇科B超"
	s ^DHCPETMPSRData("13604||1","F",11)=11_"^"_"骨密度"
	s ^DHCPETMPSRData("15381||1","F",12)=12_"^"_"肺X线检查"
	s ^DHCPETMPSRData("15346||1","F",13)=13_"^"_"心电图检查"
	s ^DHCPETMPSRData("9681||1","F",14)=14_"^"_"TBS描述性诊断"
}

/// w ##class(web.DHCPE.Report.DHCPEPositiveStatisticReport).GetPrintData()
ClassMethod GetPrintData()
{
	s petotal=$p($g(^DHCPETMPSR("IllnessInfo")),"^",3)
	s illtotal=$p($g(^DHCPETMPSR("IllnessInfo")),"^",4)
	i $p($g(^DHCPETMPSR("IllnessInfo")),"^",1)="on" s sex="M"
	i $p($g(^DHCPETMPSR("IllnessInfo")),"^",2)="on" s sex="F"
	i illtotal="on"
	{
	s ISDR=0,Data="",Condition="ILL"
	f  s ISDR=$o(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR)) q:ISDR=""  d
	.s ISCode=$P($G(^DHCPEILLS(ISDR)),"^",1)
	.s ISCode=$e(ISCode,6,8)
	.s ISDesc=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,"Desc"))
	.s ILLTotal=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,"Total"))
	.s AgeArea="",illage1="",illage2="",illage3="",illage4="",illage5="",illage6="",illage7=""
	.f  s AgeArea=$o(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea)) q:AgeArea=""  d
	..i AgeArea=1 s illage1=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))
	..i AgeArea=2 s illage2=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))
	..i AgeArea=3 s illage3=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))
	..i AgeArea=4 s illage4=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))
	..i AgeArea=5 s illage5=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))
	..i AgeArea=6 s illage6=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))
	..i AgeArea=7 s illage7=$g(^DHCPETMPSR("IllnessList","IllnessStandard",ISDR,AgeArea))
	.i Data="" s Data=ISCode_"^"_ISDesc_"^"_ILLTotal_"^"_illage1_"^"_illage2_"^"_illage3_"^"_illage4_"^"_illage5_"^"_illage6_"^"_illage7
    .e  s Data=Data_"$"_ISCode_"^"_ISDesc_"^"_ILLTotal_"^"_illage1_"^"_illage2_"^"_illage3_"^"_illage4_"^"_illage5_"^"_illage6_"^"_illage7
	q sex_"@"_Condition_"@"_Data
	}
	i petotal="on"
	{
	s ItemId=0,Data="",Condition="PE"
	f  s ItemId=$o(^DHCPETMPSR("PEList","PEStandard",ItemId)) q:ItemId=""  d
	.s ItemName=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,"Desc"))
	.s PETotal=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,"Total"))
	.s AgeArea="",illage1="",illage2="",illage3="",illage4="",illage5="",illage6="",illage7=""
	.f  s AgeArea=$o(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea)) q:AgeArea=""  d
	..i AgeArea=1 s illage1=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))
	..i AgeArea=2 s illage2=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))
	..i AgeArea=3 s illage3=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))
	..i AgeArea=4 s illage4=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))
	..i AgeArea=5 s illage5=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))
	..i AgeArea=6 s illage6=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))
	..i AgeArea=7 s illage7=$g(^DHCPETMPSR("PEList","PEStandard",ItemId,AgeArea))
	.i Data="" s Data=ItemId_"^"_ItemName_"^"_PETotal_"^"_illage1_"^"_illage2_"^"_illage3_"^"_illage4_"^"_illage5_"^"_illage6_"^"_illage7
    .e  s Data=Data_"$"_ItemId_"^"_ItemName_"^"_PETotal_"^"_illage1_"^"_illage2_"^"_illage3_"^"_illage4_"^"_illage5_"^"_illage6_"^"_illage7
	q sex_"@"_Condition_"@"_Data
	}
	q
}

ClassMethod ExportGroupResult(GADM)
{
	s UserID=""
	s:$D(%session) UserID=%session.Get("LOGON.USERID")
   	s Job=$P(GADM,"^",2)
   	s:Job="" Job=UserID
   	s GADM=$P(GADM,"^",1)
   	k ^TempDHCPEResultData(Job)
   	k ^TempDHCPEResultDataSort(Job)
   	k ^TempDHCPEResultSort(Job)
   	s Data=""
   	s GTeam=0
	f  s GTeam=$o(^DHCPEIADM(0,"GADM",GADM,GTeam)) q:GTeam=""  d
	.s IADM=0
	.f  s IADM=$o(^DHCPEIADM(0,"GADM",GADM,GTeam,IADM)) q:IADM=""  d
	..s PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
	..s:UserID="" UserID=PAADM
	..s CRMADM=$p($g(^DHCPEIADM(IADM)),"^",4)
	..s PIADMStatus=$p($g(^DHCPEPreIADM(CRMADM)),"^",8)
	..q:PIADMStatus'="ARRIVED"
	
	..i Data="" d
	...s Data=PAADM
	..e  d
	...s Data=Data_"#"_PAADM
	
	
	..k ^TMPReport(UserID)
	..d ##Class(web.DHCPE.ReportOutToWeb).GetReportInfor(PAADM,UserID)
	..s sStationSequence=""
	..f  s sStationSequence=$O(^TMPReport(UserID,"Result","Station",sStationSequence)) q:sStationSequence=""  d
	...s StationId=""
	...f  s StationId=$O(^TMPReport(UserID,"Result","Station",sStationSequence,StationId)) Q:(""=StationId)  d
	....;q:NoReportStation[("^"_StationId_"^")
	....s sARCSequence=""
	....f  s sARCSequence=$O(^TMPReport(UserID,"Result","Station",sStationSequence,StationId,sARCSequence)) Q:(""=sARCSequence)  d
	.....s iiiLLoop=0
	.....f  s iiiLLoop=$O(^TMPReport(UserID,"Result","Station",sStationSequence,StationId,sARCSequence,iiiLLoop)) Q:(""=iiiLLoop)  d
	......s OEORDItemID=$G(^TMPReport(UserID,"Result","Station",sStationSequence,StationId,sARCSequence,iiiLLoop))
	......s ARCIMID=$P(^OEORD(+OEORDItemID,"I",$P(OEORDItemID,"||",2),1),"^",2)
	......i $D(^TempDHCPEResultSort(Job,sStationSequence,StationId,ARCIMID)) d
	.......s ItemSort=$G(^TempDHCPEResultSort(Job,sStationSequence,StationId,ARCIMID))
	......e  d
	.......s ItemSort=$I(^TempDHCPEResultSort(Job,sStationSequence,StationId,"Sort"))
	.......s ^TempDHCPEResultSort(Job,sStationSequence,StationId,ARCIMID)=ItemSort
	......s CurData=$G(^TMPReport(UserID,"Result", "ARCIM", OEORDItemID))
	......s ReportFormat=$P(CurData,"^",4)
	......s DetailSub=""
	......f  s DetailSub=$O(^TMPReport(UserID,"Result", "Content", OEORDItemID,DetailSub)) q:DetailSub=""  d
	.......s CurData=$g(^TMPReport(UserID,"Result", "Content",OEORDItemID,DetailSub))
	.......i (ReportFormat["LIS")||(ReportFormat["CAT") d
	........s ResultID=$P(CurData,"^",9)
	.......i (ReportFormat["NOR")||((ReportFormat["RIS")||(ReportFormat["PIS")||((ReportFormat["EKG"))) d
	........s ResultID=$P(CurData,"^",6)
	.......q:ResultID=""
	
	.......s ODID=$P($g(^DHCPERLT(ResultID)),"^",3)
	.......q:ODID=""
	.......s Result=$P(CurData,"^",2)
	.......i $D(^TempDHCPEResultSort(Job,sStationSequence,StationId,ARCIMID,ODID)) d
	........s DetailSort=$G(^TempDHCPEResultSort(Job,sStationSequence,StationId,ARCIMID,ODID))
	.......e  d
	........s DetailSort=$I(^TempDHCPEResultSort(Job,sStationSequence,StationId,ARCIMID,"Sort"))
	........s ^TempDHCPEResultSort(Job,sStationSequence,StationId,ARCIMID,ODID)=DetailSort
	........s ^TempDHCPEResultDataSort(Job,sStationSequence,StationId,ItemSort,ARCIMID,DetailSort,ODID)=""
	.......s ^TempDHCPEResultData(Job,PAADM,sStationSequence,StationId,ItemSort,ARCIMID,DetailSort,ODID)=$G(^TempDHCPEResultData(Job,PAADM,sStationSequence,StationId,ItemSort,ARCIMID,DetailSort,ODID))_Result
	q Data
}

// d ##class(web.DHCPE.Report.PositiveStatisticReport).GetGroupData(-2,111)

// w ##class(web.DHCPE.Report.PositiveStatisticReport).GetGroupData(9422137,5918)

ClassMethod GetGroupData(PAADM, Job)
{
	;PAADM:-2   得出共多少列
	;PAADM:-1   得出每个项目共多少小项
	;PAADM:0    得出每个小项的名称
	;PAADM>0    得出每个小项的结果
	s BaseInfo=..GetPatInfo(PAADM)	
	i PAADM=-2{
		s Count=0
		s STSeq=""
		f  s STSeq=$O(^TempDHCPEResultDataSort(Job,STSeq)) q:STSeq=""  d
		.s STID=""
		.f  s STID=$O(^TempDHCPEResultDataSort(Job,STSeq,STID)) q:STID=""  d
		..s ItemSort=""
		..f  s ItemSort=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort)) q:ItemSort=""  d
		...s ARCIMID=""
		...f  s ARCIMID=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort,ARCIMID)) q:ARCIMID=""  d
		....s ODSort=""
		....f  s ODSort=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort,ARCIMID,ODSort)) q:ODSort=""  d
		.....s ODID=""
		.....f  s ODID=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort,ARCIMID,ODSort,ODID)) q:ODID=""  d
		......s Count=Count+1
		q Count+BaseInfo
	}
	i PAADM=-1{
		s Ret=""
		s STSeq=""
		f  s STSeq=$O(^TempDHCPEResultDataSort(Job,STSeq)) q:STSeq=""  d
		.s STID=""
		.f  s STID=$O(^TempDHCPEResultDataSort(Job,STSeq,STID)) q:STID=""  d
		..s ItemSort=""
		..f  s ItemSort=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort)) q:ItemSort=""  d
		...s ARCIMDesc=""
		...s ARCIMID=""
		...f  s ARCIMID=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort,ARCIMID)) q:ARCIMID=""  d
		....s ARCIMDesc=$P($G(^ARCIM(+ARCIMID,1,1)),"^",3)
		....s OneCount=0
		....s ODSort=""
		....f  s ODSort=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort,ARCIMID,ODSort)) q:ODSort=""  d
		.....s ODID=""
		.....f  s ODID=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort,ARCIMID,ODSort,ODID)) q:ODID=""  d
		......s OneCount=OneCount+1
		....i Ret="" d
		.....s Ret=ARCIMDesc_"^"_OneCount
		....e  d
		.....s Ret=Ret_"$"_ARCIMDesc_"^"_OneCount
		s Ret=BaseInfo_"$"_Ret
		q Ret
	}
	i PAADM=0{
		s Ret=""
		s STSeq=""
		f  s STSeq=$O(^TempDHCPEResultDataSort(Job,STSeq)) q:STSeq=""  d
		.s STID=""
		.f  s STID=$O(^TempDHCPEResultDataSort(Job,STSeq,STID)) q:STID=""  d
		..s ItemSort=""
		..f  s ItemSort=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort)) q:ItemSort=""  d
		...s ARCIMID=""
		...f  s ARCIMID=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort,ARCIMID)) q:ARCIMID=""  d
		....s ARCIMDesc=$P($G(^ARCIM(+ARCIMID,1,1)),"^",3)
		....s ODSort=""
		....f  s ODSort=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort,ARCIMID,ODSort)) q:ODSort=""  d
		.....s ODID=""
		.....f  s ODID=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort,ARCIMID,ODSort,ODID)) q:ODID=""  d
		......s ODDesc=$P(^DHCPEST(+ODID,"OD",$P(ODID,"||",2)),"^",1)
		......i Ret="" d
		.......s Ret=ODDesc
		......e  d
		.......s Ret=Ret_"^"_ODDesc
		s Ret=BaseInfo_"^"_Ret
		q Ret
	}
	b ;^TempDHCPEResultData(Job,PAADM
	s Ret=""
	s STSeq=""
	f  s STSeq=$O(^TempDHCPEResultDataSort(Job,STSeq)) q:STSeq=""  d
	.s STID=""
	.f  s STID=$O(^TempDHCPEResultDataSort(Job,STSeq,STID)) q:STID=""  d
	..s ItemSort=""
	..f  s ItemSort=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort)) q:ItemSort=""  d
	...s ARCIMID=""
	...f  s ARCIMID=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort,ARCIMID)) q:ARCIMID=""  d
	....s ARCIMDesc=$P($G(^ARCIM(+ARCIMID,1,1)),"^",3)
	....s ODSort=""
	....f  s ODSort=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort,ARCIMID,ODSort)) q:ODSort=""  d
	.....s ODID=""
	.....f  s ODID=$O(^TempDHCPEResultDataSort(Job,STSeq,STID,ItemSort,ARCIMID,ODSort,ODID)) q:ODID=""  d
	......s Result=$G(^TempDHCPEResultData(Job,PAADM,STSeq,STID,ItemSort,ARCIMID,ODSort,ODID))
	......s Ret=Ret_"^"_Result
	s Ret=BaseInfo_Ret
	q Ret
}

ClassMethod GetPatInfo(PAADM)
{
	;PAADM:-2   得出基本信息共多少列
	;PAADM:-1   得出基本信息^多少项
	;PAADM:0    得出基本信息的名称
	;PAADM>0    得出每个人的基本信息
	s TotalCount=10
	q:PAADM="" ""
	q:PAADM=-2 TotalCount
	q:PAADM=-1 "基本信息^"_TotalCount
	q:PAADM=0 "ID号^姓名^性别^出生日期^身份证号^电话^部门^职务^团体名称^分组名称^体检日期"
	
	s PaPatID=$P(^PAADM(PAADM),"^",1) 
	s IADMDR=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	s AdmDate=$P(^PAADM(PAADM),"^",6)
	s:AdmDate'="" AdmDate=$ZD(AdmDate,3)
	s RegNo=$P(^PAPER(PaPatID,"PAT",1),"^",1)
	s BaseID=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	s Name=$P(^PAPER(PaPatID,"ALL"),"^",1)
	s Sex=$P(^PAPER(PaPatID,"ALL"),"^",7)
	s:Sex'="" Sex=$P(^CT("SEX",Sex),"^",2)
	s IDCard=$P($g(^PAPER(PaPatID,"PAT",3)),"^",6)
	s Dob=$P(^PAPER(PaPatID,"ALL"),"^",6)
	s Dob=$ZD(Dob,3)
	
	s PIBIIDCard="",PACCardDesc="",PACCardTypeDR=""
	S PACCardTypeDR=$P($G(^PAPER(PaPatID,"PAT",3)),"^",7)
	I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
	i PACCardDesc["身份证" s PIBIIDCard=$P($G(^PAPER(PaPatID,"PAT",3)),"^",6)
	s Tel=""
	i BaseID'="" d
	.s Tel=$P(^DHCPEPreIBI(BaseID),"^",8)
	.s:Tel="" Tel=$P(^DHCPEPreIBI(BaseID),"^",6)
	.s:Tel="" Tel=$P(^DHCPEPreIBI(BaseID),"^",7)
	s:Tel="" Tel=$P(^PAPER(PaPatID,"PER",4),"^",21)
	s:Tel="" Tel=$P(^PAPER(PaPatID,"PER",1),"^",11)
	s:Tel="" Tel=$P(^PAPER(PaPatID,"PER",1),"^",9)
	s PIADMDR=$P(^DHCPEIADM(IADMDR),"^",4)
	s CurData=$G(^DHCPEPreIADM(PIADMDR))
	s VIPLevel=$P(CurData,"^",18)
	s:VIPLevel'="" VIPLevel=$P($G(^DHCPEVIPLevel("VIP",VIPLevel)),"^",2)
	s HPNo=$P(CurData,"^",27)
	s Depart=$G(^DHCPEDataEx("DHCPEPreIADM","Position",PIADMDR))
	s Position=$P(CurData,"^",25)
	s TeamDesc=""
	s GroupDesc=""
	s TeamID=$P(CurData,"^",3)
	i TeamID'="" d
	.s TeamDesc=$P(^DHCPEPreGADM(+TeamID,"Team",$P(TeamID,"||",2)),"^",1)
	.s GBI=$P(^DHCPEPreGADM(+TeamID),"^",1)
	.s GroupDesc=$P(^DHCPEPreGBI(GBI),"^",2)
	q RegNo_"^"_Name_"^"_Sex_"^"_Dob_"^"_PIBIIDCard_"^"_Tel_"^"_Depart_"^"_Position_"^"_GroupDesc_"^"_TeamDesc_"^"_AdmDate
}

// w ##class(web.DHCPE.Report.PositiveStatisticReport).ExportGroupInfo("5859623","21747")

ClassMethod ExportGroupInfo(PAADM)
{
   
    //NeedDRStr为需要导出的医嘱项ID串
    s RisID=$G(^DHCPESetting("DHCPE","StationId_Ris"))
    //s NeedDRStr="^15336||1^12147||1^3299||1^3032||1^10752||1^10765||1"
	//s NeedDRStr=NeedDRStr_"^"_"10766||1^10764||1^10779||1^10780||1^10763||1^10784||1"
	//s NeedDRStr=NeedDRStr_"^"_"10776||1^10807||1^10664||1^"
	//s NeedDRStr=NeedDRStr_"^"_"20389||1^10781||1^3736||1^11219||1^3763||1^11223||1^15381||1^3480||1"
	//s NeedDRStr=NeedDRStr_"^"_"3563||1^3562||1^3561||1^15342||1^12226||1^15348||1^15346||1^13604||1^3699||1^3652||1^15367||1^"
	s RLTID=0,ALLResult="",Result="",ARCIMDR="",ODDR="",ODStrResult=""
	s ODDR=0
    f  s ODDR=$o(^DHCPERLT(0,"PAADM_OD",PAADM,ODDR))  q:ODDR=""  d
    .s ODDesc=$p(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2)),"^",1)
	.s ODUnit=$p(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2)),"^",4)
	.s ODStrResult=""
	.f  s RLTID=$o(^DHCPERLT(0,"PAADM_OD",PAADM,ODDR,RLTID)) q:RLTID=""  d
	..s Result=$p(^DHCPERLT(RLTID),"^",4)
	..s TemplateDesc=$p(^DHCPERLT(RLTID),"^",10)
    ..s ARCIMDR=$p(^DHCPERLT(RLTID),"^",2)
    ..s OEOrdItem=$p(^DHCPERLT(RLTID),"^",9)
	..s STRowId="0"
	..s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,STRowId))
    ..s Station="^"_STRowId_"^"
    ..//q:NeedDRStr'[("^"_ARCIMDR_"^")   //过滤医嘱
    ..i ("^"_RisID_"^")[("^"_STRowId_"^")  d
    ...i Result=""  s Result=$g(^DHCPETempResult(OEOrdItem))
    ...s Result=$p(Result,"诊断意见:",2)
    ..s Result=##class(web.DHCPE.Public.Setting).Replace(Result,"_$c(13,10)_","  ")
	..s Result=##class(web.DHCPE.Public.Setting).Replace(Result,"_$c_","  ")
	..i TemplateDesc'=""  s Result=Result_":"_TemplateDesc
	..i ODStrResult="" s ODStrResult=Result
	..else  s ODStrResult=ODStrResult_" "_Result
	.i ALLResult=""  s ALLResult=ARCIMDR_"@"_ODDR_"@"_ODStrResult
    .else  s ALLResult=ALLResult_"^"_ARCIMDR_"@"_ODDR_"@"_ODStrResult

	q ALLResult
}

// w ##class(web.DHCPE.Report.PositiveStatisticReport).ExportPersonalResult("1017","360")

// w ##class(web.DHCPE.Report.PositiveStatisticReport).ExportGroupInfo("5859623","21747")

ClassMethod ExportPersonalResult(PAADM)
{

	s Data=""
	s ^zl("PAADM")=PAADM
	s PAPMIDR=$p(^PAADM(PAADM),"^",1)
	s ^zl("PAADM")=PAADM_"^"_PAPMIDR990069
	q:PAPMIDR=""
	s PAADMRowID=0
	f  s PAADMRowID=$o(^PAPERdr(PAPMIDR,"ADM","H",PAADMRowID))  Q:(PAADMRowID="")||(PAADMRowID>PAADM)  d 
	.s IADM=""
	.s IADM=$o(^DHCPEIADM(0,"PAADM",PAADMRowID,0))
	.s CRMADM=$p(^DHCPEIADM(IADM),"^",4)
	.s RegDate=$p(^DHCPEIADM(IADM),"^",5)
	.i RegDate'=""  s RegDate=$zd(RegDate,3)
	.s PIBIID=$p(^DHCPEPreIADM(CRMADM),"^",1)
	.s PIADMStatus=$p(^DHCPEPreIADM(CRMADM),"^",8)
	.q:PIADMStatus="CANCELPE"
	.s Name=$p(^DHCPEPreIBI(PIBIID),"^",2)
	.s GName=Name
	.s PAPMI=$p(^DHCPEPreIBI(PIBIID),"^",1)
	.s SexDR=$p(^DHCPEPreIBI(PIBIID),"^",3)
	.s Sex=$p(^CT("SEX",SexDR),"^",2)
	.s PIBIDOB=$p(^DHCPEPreIBI(PIBIID),"^",4)
	.s Tel1=$p(^DHCPEPreIBI(PIBIID),"^",6)
	.s MobilePhone=$p(^DHCPEPreIBI(PIBIID),"^",8)
    .i Tel1=""  s Tel1=MobilePhone
	.s Age=""
 	.i PIBIDOB'="" d
 	..s Age=##class(web.DHCLCNUREXCUTE).CalAge(PIBIDOB,+$h)
 	..s PIBIDOB=$zd(PIBIDOB,3)
 	.s Age=+$P(Age,"Y",1)
 	.s PETime=##class(web.DHCPE.PreCommon).GetReCheckFlag(IADM,"PEADM")
 	.s PETime=PETime+1
	.i Data="" s Data=PAPMI_"^"_Name_"^"_Sex_"^"_Age_"^"_ PIBIDOB_"^"_GName_"^"_Tel1_"^"_RegDate_"^"_PETime_"^"_PAADM_"^"_CRMADM
	.e  s Data=Data_"#"_PAPMI_"^"_Name_"^"_Sex_"^"_Age_"^"_ PIBIDOB_"^"_GName_"^"_Tel1_"^"_RegDate_"^"_PETime_"^"_PAADM_"^"_CRMADM
	q Data
}

}
