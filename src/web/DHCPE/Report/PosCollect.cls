Import SQLUser

/// 阳性体征汇总 
Class web.DHCPE.Report.PosCollect Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 58;

ClassMethod FilterPerson(PIAdmRowId As %String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", Sex As %Library.String = "", Married As %Library.String = "", AgeStep As %Library.String = "")
{

	Q:(""=PIAdmRowId) 0
	
	s PIBIDR=$P($G(^DHCPEPreIADM(PIAdmRowId)),"^",1)
	Q:(""=PIBIDR) 0
	
	s PIBISex=$p(^DHCPEPreIBI(PIBIDR),"^",3)
	Q:(""'=Sex)&(Sex'=PIBISex) 0
	i PIBISex'="" s PIBISex=$p($G(^CT("SEX",PIBISex)),"^",2)
	i PIBISex=""  s PIBISex="未知"
	s PIBIDOB=$p(^DHCPEPreIBI(PIBIDR),"^",4)
	s Age=""
 	i PIBIDOB'="" d
 	.s Age=##class(web.DHCLCNUREXCUTE).CalAge(PIBIDOB,+$h)
 	.s Age=+$P(Age,"Y",1)
	Q:(""'=AgeFrom)&(""'=Age)&(+AgeFrom>=+Age) 0
	Q:(""'=AgeTo)&(""'=Age)&(+AgeTo<+Age) 0
	i AgeStep=""  s AgeStep=10
	//s ^zl("AgeStep",PIAdmRowId)=AgeStep
	s AgeArea=..GetAgeArea(0,100,AgeStep,Age)
	//s AgeArea=..GetAgeArea(AgeFrom,AgeTo,"",Age)
	
	s PIBIMarried=$p(^DHCPEPreIBI(PIBIDR),"^",17)
	Q:(""'=Married)&(Married'=PIBIMarried) 0
	
	s:(PIBIMarried'="") PIBIMarried=$p(^CT("MAR",PIBIMarried),"^",2)
	s:(PIBIMarried="") PIBIMarried="未知"
	
	Q 1
}

/// 疾病汇总
/// 						团体列表(以 ^ 分割)			    疾病诊断列表(以 $ 分割)						体检起始日期					体检结束日期						起始年龄					结束年龄							性别			       婚姻
ClassMethod GetPosCollect(GTList As %Library.String = "", Standards As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", Sex As %Library.String = "", Married As %Library.String = "", AgeStep As %Library.String = "")
{
	//全部GTList
	i (GTList="") d
	.i DateFrom=""  s DateFrom=0
    .i DateTo=""  s DateTo=+$h
    .s IADM=0
    .f CurDate=DateFrom:1:DateTo d
    ..s DateTime=""
    ..f  s DateTime=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,DateTime)) q:DateTime=""  d
    ...f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,DateTime,IADM)) q:IADM=""  d
    ....d FilterPreIADM
    e  d
	.//个人
	.i ("I"=$P(GList,"^",1)) d
	..i DateFrom=""  s DateFrom=0
    ..i DateTo=""  s DateTo=+$h
    ..s IADM=0
    ..f CurDate=DateFrom:1:DateTo d
    ...s DateTime=""
    ...f  s DateTime=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,DateTime)) q:DateTime=""  d
    ....f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",CurDate,DateTime,IADM)) q:IADM=""  d
    .....q:$p(^DHCPEIADM(IADM),"^",2)'=""
    .....d FilterPreIADM
    .//团体
    .e  d
	..f iGLLoop=1:1:$Length(GList,"^") d
	...s GADMRowId=$P(GList,"^",iGLLoop)
	...Q:(""=GADMRowId)
	...// DHC_PE_GADM
	...s GTeamSub=0
	...f  s GTeamSub=$o(^DHCPEGADM(GADMRowId,"Team",GTeamSub)) q:GTeamSub=""  d
	....s GTeamRowId=GADMRowId_"||"_GTeamSub
	....s IADM=0
	....f  s IADM=$O(^DHCPEIADM(0,"GADM",GADMRowId,GTeamRowId,IADM)) q:IADM=""  d
	.....d FilterPreIADM
	
	// 查询所选的阳性体征
	f iLoop=1:1:$l(Standards,"$") d
	.s Standard=$P(Standards,"$",iLoop)
	.s Type=$P(Standard,"^",2)
	.i Type="S" d
	..s ODSALLS=$P(Standard,"^",3)
	..f jLoop=1:1:$l(ODSALLS,"!") d
	...s ODSIDS=$P(ODSALLS,"!",jLoop)
	...q:ODSIDS=""
	...s ODSID=$P(ODSIDS,"@",1)
	...s ODSTemp=$p(ODSIDS,"@",2)
	...//DHC_PE_Station.ST_RowId
	...s STRowId=$P($G(ODSID),"||",1)
	...// DHC_PE_OrderDetail.OD_ChildSub
	...s ODChildSub=$P($G(ODSID),"||",2)
	...s ODSChildSub=$P($G(ODSID),"||",3)
    ...s ODSTextVal=$P($G(^DHCPEST(STRowId, "OD", ODChildSub, "ODS", ODSChildSub)), "^", 2)
	...s RLTODDR=STRowId_"||"_ODChildSub
	...s ^DHCPETMPPC("OrderDetail", RLTODDR)=$g(ODSTextVal)_"^"_$G(^DHCPETMPPC("OrderDetail", RLTODDR))
	.i Type="T" d
	..s RLTODDR=$P(Standard,"^",1)
	..s ODSTextValS=$P(Standard,"^",3)
	..f jLoop=1:1:$l(ODSTextValS,"@") d
	...s ODSTextVal=$P(ODSTextValS,"@",jLoop)
	...s ^DHCPETMPPC("OrderDetail", RLTODDR)=$g(ODSTextVal)_"^"_$G(^DHCPETMPPC("OrderDetail", RLTODDR))
	.i Type="N" d
	..s RLTODDR=$P(Standard,"^",1)
	..s ODSTextValS=$P(Standard,"^",3)
	..f jLoop=1:1:$l(ODSTextValS,"*") d
	...s ODSTextVal=$P(ODSTextValS,"*",jLoop)
	...s ^DHCPETMPPC("OrderDetail", RLTODDR)=$g(ODSTextVal)_"^"_$G(^DHCPETMPPC("OrderDetail", RLTODDR))
    .i Type="R" d
    ..s RLTODDR=$P(Standard,"^",1)
    ..s ODSTextVal=$P(Standard,"^",3)
    ..s ^DHCPETMPPC("OrderDetail", RLTODDR)=$g(ODSTextVal)_"^"_$G(^DHCPETMPPC("OrderDetail", RLTODDR))
	
	s ADMDR=0
	f  s ADMDR=$O(^DHCPETMPPC("ADM", ADMDR)) Q:(""=ADMDR)  d
	.s IAdmRowId=$G(^DHCPETMPPC("ADM", ADMDR))
	.s PIADMRowId=$p(^DHCPEIADM(IAdmRowId),"^",4)
	.s PIBIDR=$P($G(^DHCPEPreIADM(PIADMRowId)),"^",1)
	.s PIBISex=$p(^DHCPEPreIBI(PIBIDR),"^",3)
	.i PIBISex'="" s Sex=$p($G(^CT("SEX",PIBISex)),"^",2)
	.i PIBISex=""  s PIBISex="未知"
	.s PIBIDOB=$p(^DHCPEPreIBI(PIBIDR),"^",4)
	.s Age=""
 	.i PIBIDOB'="" d
 	..s Age=##class(web.DHCLCNUREXCUTE).CalAge(PIBIDOB,+$h)
 	..s Age=+$P(Age,"Y",1)
 	..i AgeStep=""  s AgeStep=10
 	..//s ^zl("20110817",ADMDR)=AgeStep_"^"_Age
	..s AgeArea=..GetAgeArea(0,100,AgeStep,Age)
	..//s ^zl("20110817",ADMDR,1)=AgeArea
	.s PIBIMarried=$p(^DHCPEPreIBI(PIBIDR),"^",17)
	.s:(PIBIMarried'="") PIBIMarried=$p(^CT("MAR",PIBIMarried),"^",2)
	.s:(PIBIMarried="") PIBIMarried="未知"
	.
	.s ODDR=0,SFlag=0,CFlag=0,TFlag=1
	.f  s ODDR=$O(^DHCPETMPPC("OrderDetail",ODDR)) Q:(""=ODDR)  d
	..s TFlag=0 //已选标识
	..s ResultTextList=$g(^DHCPETMPPC("OrderDetail",ODDR))
	..
	..
	..i ODDR="*" d
	...s ItemDescs=""
	...s SSID=$o(^DHCPEGS(0,"IADM",IAdmRowId,0))
	...i SSID'="" d
 	....s Sort=0
 	....f  s Sort=$o(^DHCPEGS(0,"GSDSort",SSID,Sort)) q:Sort=""  d
 	.....s Sub=0
 	.....f  s Sub=$o(^DHCPEGS(0,"GSDSort",SSID,Sort,Sub)) q:Sub=""  d
 	......s RLID=$p(^DHCPEGS(SSID,"Diagnosis",Sub),"^",1)
 	......q:RLID=""
 	......s ItemDesc=""
 	......s ItemDesc=$p($g(^DHCPEED(RLID,"1")),"^",1)
	......s ItemDescs=$g(ItemDesc)_"^"_$g(ItemDescs)
	...s IllName=$p(ResultTextList,"^",1)
	...i (ItemDescs'[IllName) s SFlag=1 //总检标识
	..Q:ODDR="*"
	..
	..
	..s ODType=$P(^DHCPEST(+ODDR,"OD",$P(ODDR,"||",2)),"^",2)
	..s RLTMin="",RLTMax="",RLTResult=""
	..s RLTRowId=0
	..n RLTResults
	..f  s RLTRowId=$O(^DHCPERLT(0,"PAADM_OD",ADMDR,ODDR,RLTRowId)) Q:(""=RLTRowId)  d
    ...s RLTResult=$P(^DHCPERLT(RLTRowId), "^", 4)
	...s RLTResults=$g(RLTResult)_"^"_$g(RLTResults)
	..
	..i '$d(RLTResults) s CFlag=1  //已检标识
	..Q:'$d(RLTResults)
	..i (ODType="S")||(ODType="T") d
	...s ODSTextVal=""
	...f iLoop=1:1:$l(ResultTextList,"^") d
	....s ODSTextVal=$P(ResultTextList,"^",iLoop)
	....i (RLTResults'[ODSTextVal) s SFlag=1  //体征标识
	..
	..i (ODType="N")||(ODType="C") d
	...s SFlag=1,RLTResult=""
	...s RLTMin=$P(ResultTextList,"^",2)
	...s RLTMax=$P(ResultTextList,"^",1)
	...
	...f iLoop=1:1:$l(RLTResults,"^") d
	....s RLTResult=$P(RLTResults,"^",iLoop)
	....Q:RLTResult=""
	....i (RLTMin'="")&&(RLTMax="")&&(+RLTResult>=+RLTMin) s SFlag=0
	....i (RLTMin="")&&(RLTMax'="")&&(+RLTResult<=+RLTMax) s SFlag=0
	....i (RLTMin'="")&&(RLTMax'="")&&(+RLTResult>=+RLTMin)&&(+RLTResult<=+RLTMax) s SFlag=0
    .Q:TFlag=1
	.Q:CFlag=1
	.s ^DHCPETMPPC("PosCollect","CheckTotal")=1+$G(^DHCPETMPPC("PosCollect","CheckTotal"))
	.s ^DHCPETMPPC("PosCollect","SexTotal",Sex)=1+$G(^DHCPETMPPC("PosCollect","SexTotal",Sex))
	.s ^DHCPETMPPC("PosCollect","MarriedTotal",PIBIMarried)=1+$G(^DHCPETMPPC("PosCollect","MarriedTotal",PIBIMarried))
	.s ^DHCPETMPPC("PosCollect","AgeArea",AgeArea)=1+$G(^DHCPETMPPC("PosCollect","AgeArea",AgeArea))
	.s ^DHCPETMPPC("PosCollect","CheckList")=IAdmRowId_"^"_$G(^DHCPETMPPC("PosCollect","CheckList"))
	.Q:SFlag=1
	.s ^DHCPETMPPC("PosCollect","IllTotal")=1+$G(^DHCPETMPPC("PosCollect","IllTotal"))
	.s ^DHCPETMPPC("PosCollect","IllSex",Sex)=1+$G(^DHCPETMPPC("PosCollect","IllSex",Sex))
	.s ^DHCPETMPPC("PosCollect","IllMarried",PIBIMarried)=1+$G(^DHCPETMPPC("PosCollect","IllMarried",PIBIMarried))
	.s ^DHCPETMPPC("PosCollect","IllAgeArea",AgeArea)=1+$G(^DHCPETMPPC("PosCollect","IllAgeArea",AgeArea))
	.s ^DHCPETMPPC("PosCollect","IllList")=IAdmRowId_"^"_$G(^DHCPETMPPC("PosCollect","IllList"))
	Q 1

FilterPreIADM //过滤不符合条件的客户
	s Status=$P($g(^DHCPEIADM(IADM)),"^",8)
	Q:Status'="ARRIVED"
	s ADMDR=$P($g(^DHCPEIADM(IADM)),"^",1)
	Q:ADMDR=""
	s PIAdmRowId=$P($g(^DHCPEIADM(IADM)),"^",4)
	Q:(0=..FilterPerson(PIAdmRowId, DateFrom, DateTo, AgeFrom, AgeTo, Sex, Married,AgeStep))
	s ^DHCPETMPPC("ADM",ADMDR)=IADM
	Q
}

/// 阳性体征
/// d ##Class(%ResultSet).RunQuery("web.DHCPE.Report.PosCollect", "PosCollect", "I^;undefined", "^1||1^N^145*178^","","","","","","")
Query PosCollect(GList As %Library.String = "", Standards As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", Sex As %Library.String = "", Married As %Library.String = "", AgeStep As %Library.String = "") As %Query(ROWSPEC = "TStandardDesc:%String, TTotal:%String, TPercent:%String, TList:%String")
{
}

ClassMethod PosCollectExecute(ByRef qHandle As %Binary, GList As %Library.String = "", Standards As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", Sex As %Library.String = "", Married As %Library.String = "", AgeStep As %Library.String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	i (""=Standards) {
 		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	
	k ^TEMPDHCPEExport("PosCollect")
	s ^tempdhcpe("PosCollect")=GList_"@@"_Standards_"@@"_DateFrom_"@@"_DateTo_"@@"_AgeFrom_"@@"_AgeTo_"@@"_Sex_"@@"_Married
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i DateFrom'="" s DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
 	i DateTo'=""   s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
	k ^DHCPETMPPC	
	// 疾病统计
	d ..GetPosCollect(GList, Standards, DateFrom, DateTo, AgeFrom, AgeTo, Sex, Married,AgeStep)

 	// 输出查询统计数据
 	i ""'=$G(^DHCPETMPPC("PosCollect","CheckTotal")) d
	.s CheckTotal=$G(^DHCPETMPPC("PosCollect","CheckTotal"))
	.s CheckList=$G(^DHCPETMPPC("PosCollect","CheckList"))
	.s Data=$lb("已检人数", CheckTotal, "", CheckList)
	.d PosCollectOut
	.S ^TEMPDHCPEExport("PosCollect",ind)="已检人数"_"^"_CheckTotal_"^"_""_"^"_""
	.s IllTotal=$G(^DHCPETMPPC("PosCollect","IllTotal"))
	.s IllPercent=$FN(IllTotal/CheckTotal*100,"",2)_"%"
	.s IllList=$G(^DHCPETMPPC("PosCollect","IllList"))
	.s Data=$lb("阳性人数", IllTotal, IllPercent, IllList)
	.d PosCollectOut
	.S ^TEMPDHCPEExport("PosCollect",ind)="阳性人数"_"^"_IllTotal_"^"_IllPercent_"^"_""
	.s Sex=""
	.f  s Sex=$O(^DHCPETMPPC("PosCollect","SexTotal",Sex)) Q:(""=Sex)  d
	..s SexTotal=$G(^DHCPETMPPC("PosCollect","SexTotal",Sex))
	..s IllSex=$G(^DHCPETMPPC("PosCollect","IllSex",Sex))
	..s SexPercent=$FN(IllSex/SexTotal*100,"",2)_"%"
	..s Data=$lb(Sex_"性阳性人数", +IllSex, SexPercent, "")
	..d PosCollectOut
	..S ^TEMPDHCPEExport("PosCollect",ind)=Sex_"性阳性人数"_"^"_+IllSex_"^"_SexPercent_"^"_""
	.
	.s Married=""
	.f  s Married=$O(^DHCPETMPPC("PosCollect","MarriedTotal",Married)) Q:(""=Married)  d
	..s MarriedTotal=$G(^DHCPETMPPC("PosCollect","MarriedTotal",Married))
	..s IllMarried=$G(^DHCPETMPPC("PosCollect","IllMarried",Married))
	..s MarriedPercent=$FN(IllMarried/MarriedTotal*100,"",2)_"%"
	..s Data=$lb("婚姻状况:"_Married, +IllMarried, MarriedPercent, "")
	..d PosCollectOut
	..S ^TEMPDHCPEExport("PosCollect",ind)="婚姻状况:"_Married_"^"_+IllMarried_"^"_MarriedPercent_"^"_""
	.s AgeArea=""
	.f  s AgeArea=$O(^DHCPETMPPC("PosCollect","AgeArea",AgeArea)) Q:(""=AgeArea)  d
	..s AgeAreaTotal=$G(^DHCPETMPPC("PosCollect","AgeArea",AgeArea))
	..s IllAgeArea=$G(^DHCPETMPPC("PosCollect","IllAgeArea",AgeArea))
	..s AgeAreaPercent=$FN(IllAgeArea/AgeAreaTotal*100,"",2)_"%"
	..s Data=$lb("("_AgeArea_")年龄区间", +IllAgeArea, AgeAreaPercent, "")
	..d PosCollectOut
    ..S ^TEMPDHCPEExport("PosCollect",ind)="("_AgeArea_")年龄区间"_"^"_+IllAgeArea_"^"_AgeAreaPercent_"^"_""
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PosCollectOut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PosCollectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PosCollectExecute ]
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
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod PosCollectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PosCollectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPosCollectRows()
{
	q $o(^TEMPDHCPEExport("PosCollect",""),-1)
}

ClassMethod GetPosCollectInfo(num)
{
	q:'$d(^TEMPDHCPEExport("PosCollect",num)) ""
	q $g(^TEMPDHCPEExport("PosCollect",num))
}

/// 获取年龄所在的区间
ClassMethod GetAgeArea(aAgeFrom As %String = "", aAgeTo As %String = "", aAgeStep As %String = "", aAge As %String = "")
{
   /*
	s aAge=+$G(aAge)
	;n LowerAgeArea,HeightAgeArea
	// 左开右闭区间
	Q:(""'=aAgeTo)&(aAge>+aAgeTo) ">"_aAgeTo
	Q:(""'=aAgeFrom)&(aAge<=+aAgeFrom) "<"_aAgeFrom
	
	// 没有设置年龄条件,则以 10 岁为间隔
	i ((""=aAgeFrom)||(0=+aAgeFrom))&((""=aAgeTo)||(0=+aAgeTo)) d
	.s aAgeStep=10
	.s LowerAgeArea=aAge\aAgeStep*10
	.s HeightAgeArea=LowerAgeArea+10
	e  d
	.i ((""=aAgeStep)||(0=+aAgeStep)) d
	..s LowerAgeArea=+aAgeFrom
	..s HeightAgeArea=aAgeTo
	.e  d
	..s n=(aAge-aAgeFrom)\aAgeStep
	..s LowerAgeArea=aAgeFrom+(aAgeStep*n)
	..s HeightAgeArea=aAgeFrom+(aAgeStep*(n+1))
	
	Q LowerAgeArea_"-"_HeightAgeArea
	*/
	
	s aAge=+$G(aAge)
	n LowerAgeArea,HeightAgeArea
	Q:(aAge>+aAgeTo) ">"_aAgeTo
	Q:(aAge<+aAgeFrom) "<"_aAgeFrom
	s n=(aAge-aAgeFrom)\aAgeStep
	s LowerAgeArea=aAgeFrom+(aAgeStep*n)
	s HeightAgeArea=aAgeFrom+(aAgeStep*(n+1))
	s:(HeightAgeArea>aAgeTo) HeightAgeArea=aAgeTo
	Q LowerAgeArea_"-"_HeightAgeArea
}

/// 辅助函数 生成HTML页面上的站点列表 DHC_PE_Station
/// 使用 DHCPEDiagnosisCollect.csp
ClassMethod OutStationStationListToHTML()
{
	w "<select id=STDR name=STDR style='WIDTH:135px'>"
	w "<option value=''></option>"
	s STDR=0
	f  s STDR=$O(^DHCPEST(STDR)) Q:(""=STDR)  d
	.s STDesc=$P($G(^DHCPEST(STDR)),"^",2)
	.w "<option value='"_STDR_"'>"_STDesc_"</option>"
	w "</select>"
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.PosCollect", "GetIllnessCollectImageInfo")

Query GetPosCollectImageInfo() As %Query(ROWSPEC = "AgeArea:%String,AgeAreaPercent:%String") [ SqlProc ]
{
}

ClassMethod GetPosCollectImageInfoExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s AgeArea="",AgeAreaTotal="",IllAgeArea="",AgeAreaPercent=""
 	f  s AgeArea=$O(^DHCPETMPPC("PosCollect","AgeArea",AgeArea)) Q:(""=AgeArea)  d
	.s AgeAreaTotal=$G(^DHCPETMPPC("PosCollect","AgeArea",AgeArea))
	.s IllAgeArea=$G(^DHCPETMPPC("PosCollect","IllAgeArea",AgeArea))
	.;s AgeAreaPercent=$FN(IllAgeArea/AgeAreaTotal*100,"",2)_"%"
	.s AgeAreaPercent=$FN(IllAgeArea/AgeAreaTotal,"",2)
    .d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	
	set Data=$lb(AgeArea,AgeAreaPercent)
	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetPosCollectImageInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPosCollectImageInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPosCollectImageInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPosCollectImageInfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
