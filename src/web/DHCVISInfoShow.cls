Import SQLUser

Class web.DHCVISInfoShow Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// /物价公示  orderType  R  药价  N  材料
ClassMethod GetDurgShow(orderType As %String = "R") As %String
{
    s n=0,j=0,i=1,oneData=""
    k ^DHCDurgItemTemp($j)
    s n=..GetDurgItemInfo(orderType)
    s j=n
	s data=""
	s head="{"
	s oneHead="["
	s oneMiddle="]={"
	s oneTail="},"
	s tail="row="_n_"}"
	for i=1:1:j  d
	.s oneData=oneHead_i_oneMiddle_^DHCDurgItemTemp($j,i)_oneTail
	.if data="" s data=oneData
	.e  s data=data_oneData
	s data=head_data_tail
	q data
}

//w ##Class(web.DHCVISInfoShow).GetPriceShow()

ClassMethod GetPriceShow(orderType As %String = "R", maxShowRows As %String = "12") As %String
{
    s n=0,j=0,i=1,oneData="",data=""
    k ^DHCDurgItemTemp($j)
    s n=..GetDurgItemInfo(orderType,maxShowRows)
    s j=n
	for i=1:1:j  d
	.s oneData=$TR($G(^DHCDurgItemTemp($j,i)),"""")
	.s oneData=$TR(oneData,",","^")
	.if data="" s data=oneData
	.e  d
	..i i#2=0 d
	...s data=data_"^"_oneData
	..e  d
	...s data=data_"!"_oneData
	q data
}

ClassMethod GetDurgItemInfo(orderType As %String = "R", maxShowRows As %String = "") As %String
{
	s i=1,MaxShow=10
	i (+maxShowRows)>0 s MaxShow=+maxShowRows
	s Subscript=""
	s Version=""
	i $G(^DHCVISDrugShow(+$h))'="" s Subscript=$P(^DHCVISDrugShow(+$h),",")
	f  s Subscript=$O(^ARCIM(Subscript)) q:(Subscript="")||(i>MaxShow)  d
	.s Version=""
	.i ($G(^DHCVISDrugShow(+$h))'="")&&(Subscript=$P(^DHCVISDrugShow(+$h),",")) d
	..i $P(^DHCVISDrugShow(+$h),",",2)'="" s Version=$P(^DHCVISDrugShow(+$h),",",2)
	.f  s Version=$O(^ARCIM(Subscript,Version)) q:(Version="")||(i>MaxShow)  d
	..s ItemDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2)
	..q:ItemDesc=""
	..i $P(ItemDesc,"}",2)'="" s ItemDesc=$P(ItemDesc,"}",2)
	..i $P(ItemDesc,"[",2)'="" s ItemDesc=$P(ItemDesc,"[")
	..i $P(ItemDesc,"(",2)'="" s ItemDesc=$P(ItemDesc,"(")
	..s OrCatDR=$p($g(^ARCIM(Subscript,Version,1)),"^",10)
	..q:OrCatDR=""
	..s EffDateTo=$p($g(^ARCIM(Subscript,Version,7)),"^",1)
	..q:EffDateTo'=""
	..s OrCatType=$p($g(^ARC("IC",OrCatDR)),"^",7)
	..q:OrCatType'=orderType
	..s flag=0
	..i orderType="N" d
	...s OECCatDR=$P($G(^ARC("IC",OrCatDR)),"^",8)
	...q:OECCatDR=""
	...s OECCatDesc=$P($G(^OEC("ORCAT",OECCatDR)),"^",2)
	...i OECCatDesc["材料" s flag=1
	..q:(orderType="N")&&(flag=0)
	..s ItemUomDR=$p($g(^ARCIM(Subscript,Version,8)),"^",14)
	..q:ItemUomDR=""
	..i ItemUomDR="" s ItemUom=""
	..e  s ItemUom=$P($G(^CT("UOM",ItemUomDR)),"^",2)
	..s arcimId=Subscript_"||"_Version
	..s ItemCost=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",arcimId,+$H,"","","","")
	..q:+ItemCost=0
	..s ItemCost=$fn(ItemCost,"",4)
	..i $L(ItemCost)>8 s ItemCost=$E(ItemCost,1,8)
	..s ^DHCDurgItemTemp($j,i)=$c(34)_ItemDesc_$c(34)_","_$c(34)_ItemUom_$c(34)_","_$c(34)_ItemCost_$c(34)
	..s i=i+1
	i Version'="" s Version=$O(^ARCIM(Subscript,Version),-1)
	s ^DHCVISDrugShow(+$h)=Subscript_","_Version
	q i-1
}

/// /检验报告取报告信息
ClassMethod GetLabShow() As %String
{
    s n=0,j=0,i=1,oneData=""
    k ^DHCLabItemTemp($j)
    s n=..GetLabItemInfo()
    s j=n
	s data=""
	s head="{"
	s oneHead="["
	s oneMiddle="]={"
	s oneTail="},"
	s tail="row="_n_"}"
	for i=1:1:j  d
	.s oneData=oneHead_i_oneMiddle_^DHCLabItemTemp($j,i)_oneTail
	.if data="" s data=oneData
	.e  s data=data_oneData
	s data=head_data_tail
	q data
}

/// w ##class(web.DHCVISInfoShow).GetLabItemInfo()
ClassMethod GetLabItemInfo() As %String
{
	//^["LabData"]
	//^["websrc"]
    //^TEPIi("AUTHORISED",dt,labno)-----dt：日期，labno:标本号
   zn "LabData"
   s dt=+$H,num=1,tDeli=",",count=1,labno=""
   i $G(^["websrc"]DHCVISLabShow(+$h))'="" s labno=^["websrc"]DHCVISLabShow(+$h)
   k ^["websrc"]DHCLabItemTemp($j)
   f  s labno=$o(^TEPIi("AUTHORISED",dt,labno)) q:(labno="")||(num>10)  d
   .q:'$D(^TEPI(labno))  
   .s temstr=$g(^TEPI(labno))
   .;Patname
   .s temPName1=$p(temstr,"\",1),temPName2=$p(temstr,"\",2)
   .s temPName=temPName1
   .i temPName1'=temPName2 s temPName=temPName1_temPName2
   .s temPName=$c(34)_temPName_$c(34)
   .q:'$l(temPName)
   .s patType=$p(temstr,"\",48)
   .//q:patType="Y"  //去掉住院病人
   .s ts="" f  s ts=$o(^TEPIi("AUTHORISED",dt,labno,ts)) q:(ts="")||(num>10)  d
   ..s tscnt="" f  s tscnt=$o(^TEPIi("AUTHORISED",dt,labno,ts,tscnt)) q:(tscnt="")||(num>10)  d
   ...s temstr=$g(^TEPI(labno,1,ts,tscnt))
   ...s temPrint=$p(temstr,"\",28)
   ...q:temPrint="Y"
   ...s TSName=""
   ...i $d(^TTAB("TS",ts)) s TSName=$p(^TTAB("TS",ts),"\",1)
   ...q:TSName=""
   ...s TSName=$c(34)_TSName_$c(34)
   ...s authDate=$P(temstr,"\",4)
   ...s authTime=$P(temstr,"\",5)
   ...i count#2=0 d
   ....s $P(^["websrc"]DHCLabItemTemp($j,num),tDeli,3)=temPName
   ....s $P(^["websrc"]DHCLabItemTemp($j,num),tDeli,4)=TSName
   ....s num=num+1
   ...e  s ^["websrc"]DHCLabItemTemp($j,num)=temPName_tDeli_TSName_tDeli_tDeli
   ...s count=count+1
   i labno'="" s labno=$o(^TEPIi("AUTHORISED",dt,labno),-1)
   s ^["websrc"]DHCVISLabShow(+$h)=labno
   zn "websrc"
   s ret=num-1
   q ret
}

/// /检查报告取报告信息
ClassMethod GetExamShow(LocDR As %String = "") As %String
{
    s n=0,j=0,i=1,oneData=""
    k ^DHCExamItemTemp($j)
    s n=..GetExamItemInfo(LocDR)
    s j=n
	s data=""
	s head="{"
	s oneHead="["
	s oneMiddle="]={"
	s oneTail="},"
	s tail="row="_n_"}"
	for i=1:1:j  d
	.s oneData=oneHead_i_oneMiddle_^DHCExamItemTemp($j,i)_oneTail
	.if data="" s data=oneData
	.e  s data=data_oneData
	s data=head_data_tail
	q data
}

/// w ##class(web.DHCVISInfoShow).GetExamItemInfo()
ClassMethod GetExamItemInfo(LocDR As %String = "") As %String
{
	s RegLocDR=""
	s RegDate=+$H
	s num=1,Deli=",",count=0
	s LocNode=LocDR
	i LocDR="" s LocNode="All"
	i LocNode="All" s RegLocDR=$P($G(^DHCVISInfoShow("Exam",LocNode,+$H)),",",1)
	i RegLocDR'="" s RegLocDR=$O(^DHCPACRegInfoi("Loc-date",RegLocDR),-1)
	f  s RegLocDR=$O(^DHCPACRegInfoi("Loc-date",RegLocDR)) q:(RegLocDR="")||(num>10)  d
	.q:(LocDR'="")&&(RegLocDR'=LocDR)
	.s RegRowid=""
	.i RegLocDR=$P($G(^DHCVISInfoShow("Exam",LocNode,+$H)),",",1) s RegRowid=$P($G(^DHCVISInfoShow("Exam",LocNode,+$H)),",",2)
	.i RegRowid'="" s RegRowid=$O(^DHCPACRegInfoi("Loc-date",RegLocDR,RegDate,RegRowid),-1)
	.f  s RegRowid=$O(^DHCPACRegInfoi("Loc-date",RegLocDR,RegDate,RegRowid)) q:(RegRowid="")||(num>10)  d
	..s RegInfo=$G(^DHCPACRegInfo(RegRowid))
	..q:RegInfo=""
	..s StudyNo=$P(RegInfo,"^",2)
	..q:StudyNo=""
	..s AdmDR=$P(RegInfo,"^",10)
	..q:AdmDR=""
	..s OrdDR=$P(RegInfo,"^",11)
	..q:OrdDR=""
	..s PortRowID=$O(^DHCRBStudyi("Report","StudyNo",StudyNo,""))
	..q:PortRowID=""
	..s PortInfo=$G(^DHCRBStudy("Report",PortRowID))
	..q:PortInfo=""
	..s StatusDR=$P(PortInfo,"^",4)
	..q:StatusDR=""
	..s Status=$P($G(^DHCRBCStatus("ReportStatus",StatusDR)),"^",2)
	..q:Status=""
	..s papmiId=+$g(^PAADM(AdmDR))
    ..q:papmiId=0 
	..s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	..s ArcDR=$P($G(^OEORD(+OrdDR,"I",$P(OrdDR,"||",2),1)),"^",2)
	..q:ArcDR=""
	..s ArcDesc=$P($G(^ARCIM(+ArcDR,$P(ArcDR,"||",2),1)),"^",2)
	..q:ArcDesc=""
	..s LocDesc=$P($G(^CTLOC(RegLocDR)),"^",2)
	..i $P(LocDesc,"-",2)'="" s LocDesc=$P(LocDesc,"-",2)
	..s ^DHCExamItemTemp($j,num)=LocDesc_Deli_PatName_Deli_ArcDesc_Deli_Status
	..s num=num+1
	//i (LocNode="All")&&(RegLocDR'="") s RegLocDR=$O(^DHCPACRegInfoi("Loc-date",RegLocDR),-1)
	//i RegRowid'="" s RegRowid=$O(^DHCPACRegInfoi("Loc-date",RegLocDR,RegDate,RegRowid),-1)
	i LocNode'="All" s RegLocDR=LocDR
	s ^DHCVISInfoShow("Exam",LocNode,+$H)=RegLocDR_","_RegRowid
	i num>1 s count=num-1
	q count
}

/// 取收费项价格
ClassMethod GetTarItemShow(orderType As %String = "R") As %String
{
    s n=0,j=0,i=1,oneData=""
    k ^DHCVISTarTemp($j)
    s n=..GetTarItemInfo(orderType)
    s j=n
	s data=""
	s head="{"
	s oneHead="["
	s oneMiddle="]={"
	s oneTail="},"
	s tail="row="_n_"}"
	for i=1:1:j  d
	.s oneData=oneHead_i_oneMiddle_^DHCVISTarTemp($j,i)_oneTail
	.if data="" s data=oneData
	.e  s data=data_oneData
	s data=head_data_tail
	q data
}

/// w ##class(web.DHCVISInfoShow).GetTarItemInfo()
ClassMethod GetTarItemInfo(orderType As %String = "R") As %String
{
	s i=1,MaxShow=10
	s TarRowID=""
	i $G(^DHCVISTarShow(+$h))'="" s TarRowID=$P(^DHCVISTarShow(+$h),",")
	f  s TarRowID=$O(^DHCTARI(TarRowID)) q:(TarRowID="")||(i>MaxShow)  d
	.q:+TarRowID=0
	.s TarStr=$G(^DHCTARI(TarRowID))
	.q:TarStr=""
	.s ActiveFlag=$P(TarStr,"^",7)
	.q:ActiveFlag="N"
	.s StartDate=$P(TarStr,"^",11)
	.s EndDate=$P(TarStr,"^",12)
	.q:(StartDate>+$H)||((+EndDate>0)&&(+EndDate<+$H))
	.s TPRowID=""
	.f  s TPRowID=$O(^DHCTARI(TarRowID,"P",TPRowID)) q:TPRowID=""  d
	..s TPStr=$G(^DHCTARI(TarRowID,"P",TPRowID))
	..q:TPStr=""
	..s TPStartDate=$P(TPStr,"^",3)
	..s TPEndDate=$P(TPStr,"^",4)
	..q:(+$H<TPStartDate)||((+TPEndDate>0)&&(+$H>+TPEndDate))
	..s TarPrice=$P(TPStr,"^",5)
	..s TarPrice=$fn(TarPrice,"",4)
	..i $L(TarPrice)>8 s Price=$E(TarPrice,1,8)
	..s TarName=$P(TarStr,"^",2)
	..s UomRowID=$P(TarStr,"^",3)
	..s PriceUom=""
	..i UomRowID'="" s PriceUom=$P($G(^CT("UOM",UomRowID)),"^",2)
	..s ^DHCVISTarTemp($j,i)=$c(34)_TarName_$c(34)_","_$c(34)_PriceUom_$c(34)_","_$c(34)_TarPrice_$c(34)
	..s i=i+1
	i TarRowID'="" s TarRowID=$O(^DHCTARI(TarRowID),-1)
	s ^DHCVISTarShow(+$h)=TarRowID
	q i-1
}

/// /显示候药摆药确认的候药信息  DispWinRowID
/// /w ##class(web.DHCVISInfoShow).GetDispShow(11)
ClassMethod GetDispShow(DispWinRowID As %String = "") As %String
{
    s n=0,j=0,i=1,oneData=""
    k ^DHCDispItemTemp($j)
    s n=..GetDispItemInfo(DispWinRowID)
    s j=n
	s data=""
	s head="{"
	s oneHead="["
	s oneMiddle="]={"
	s oneTail="},"
	s tail="row="_n_"}"
	for i=1:1:j  d
	.s oneData=oneHead_i_oneMiddle_^DHCDispItemTemp($j,i)_oneTail
	.if data="" s data=oneData
	.e  s data=data_oneData
	s data=head_data_tail
	q data
}

ClassMethod GetDispItemInfo(DispWinRowID As %String = "") As %String
{
	q:DispWinRowID="" 0
	s i=1,MaxShow=10,count=1
	s Subscript=""
	s NowDate=+$H
	s PHLoc=$P($G(^DHCPHPY(+DispWinRowID)),"^",2)
	q:PHLoc="" 0
	s PatNameStr="^"
	s PHDRowID=""
	i $G(^DHCDispShow(+$h))'="" s PHDRowID=$P(^DHCDispShow(+$h),",")
	f  s PHDRowID=$O(^DHCPHDISPi(NowDate,PHLoc,PHDRowID)) q:(PHDRowID="")||(i>MaxShow)  d
	.s PHDInfo=$G(^DHCPHDISP(PHDRowID))
	.q:PHDInfo=""
	.s FYFlag=$P(PHDInfo,"^",4)
	.q:FYFlag=1
	.s PAPMIDR=$P(PHDInfo,"^",7)
	.q:PAPMIDR=""
	.s PatName=$P($G(^PAPER(PAPMIDR,"ALL")),"^",1)
	.q:PatNameStr[("^"_PatName_"^")
	.s PatNameStr=PatNameStr_PatName_"^"
	.s PatNo=$P($G(^PAPER(PAPMIDR,"PAT",1)),"^",1)
	.i count#2=0 d
	..s $P(^DHCDispItemTemp($j,i),",",3)=$c(34)_PatNo_$c(34)
	..s $P(^DHCDispItemTemp($j,i),",",4)=$c(34)_PatName_$c(34)
	..s i=i+1
	.e  d
	..s $P(^DHCDispItemTemp($j,i),",",1)=$c(34)_PatNo_$c(34)
	..s $P(^DHCDispItemTemp($j,i),",",2)=$c(34)_PatName_$c(34)
	.s count=count+1
	i PHDRowID'="" s PHDRowID=$O(^DHCPHDISPi(NowDate,PHLoc,PHDRowID),-1)
	s ^DHCDispShow(+$h)=PHDRowID
	q i-1
}

/// w ##class(web.DHCVISInfoShow).OperSchedulInfo()
ClassMethod OperSchedulInfo(MaxShowRows As %String = "6") As %String
{
    s chl=""
    s j=1
    s num=0
    s date=+$h
    s SubNode="SDate"
    s opaId=""
    k ^DHCVISOpSchTemp($j)
    f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d
	.q:$d(^DHCANOPArrange(opaId))<1
	.s Stat=$P(^DHCANOPArrange(opaId),"^",27)
	.s Status=""
	.i Stat="A" s Status="申请"
	.i Stat="D" s Status="拒绝"
	.i Stat="R" s Status="安排"
	.i Stat="N" s Status="非预约"
	.i Stat="I" s Status="术中"
	.i Stat="P" s Status="恢复室"
	.i Stat="L" s Status="术毕"
	.i Stat="F" s Status="完成"
	.q:(Stat="D")||(Stat="F")
	.s opdate="",oproomdes="",regNo="",patName="",diag="",sex="",age="",opdes="",locdes="",mzdoc="",anmethod=""
	.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
	.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
	.s openddate=$P(^DHCANOPArrange(opaId),"^",16)
	.s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
	.s opmem=$P($P(^DHCANOPArrange(opaId),"^",19),"#",1)
	.i openddate<=opstdate s openddate=""
	.if openddate'=""  s openddate=$ZD(openddate,4)_" "
	.if opendtime'=""  s opendtime=$ZT(opendtime,2)
	.if opsttime'=""  s opsttime=$ZT(opsttime,2)
	.s opdatestr=$ZD(opstdate,4)_" "_opsttime_"~"_openddate_opendtime
	.s opAppdate=$P(^DHCANOPArrange(opaId),"^",3)
	.s opApptime=$P(^DHCANOPArrange(opaId),"^",5)
	.if opAppdate'=""  s opAppdate=$ZD(opAppdate,4)
	.if opApptime'=""  s opApptime=$ZT(opApptime,2)
	.s OpAppDateStr=$G(opAppdate)_"  "_$G(opApptime)
	.s arrTime=$P(^DHCANOPArrange(opaId),"^",8)
	.s arrDate=$P(^DHCANOPArrange(opaId),"^",7)
	.i arrTime'=""  d 	//安排时间不为空
	..s opdate=$ZD(arrDate,3)_" "_$ZT(arrTime,2)
	.e  s opdate=$ZD(opstdate,3)_" "_opsttime
	.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	.if oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
	.//q:(oproomdr'=oproom)&(oproom'="")
	.s opordno=$P(^DHCANOPArrange(opaId),"^",26)
	.i (opordno'="")&(opordno=1) s opdate="8:30"
	.i (opordno'="")&(opordno'=1) s opdate="接台"_(opordno-1)
	.s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm
	.q:adm=""
	.s bedCode="",inPatNo="",admreason=""
	.s bedSub=$p($p($g(^PAADM(adm)),"^",73),"||",2)
    .s curWardId=$p($g(^PAADM(adm)),"^",70)  
    .if curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
    .if (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	.s papmiId=$p($g(^PAADM(admId)),"^",1)
    .s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    .s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    .s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    .s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    .s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	.s loc=$P(^PAADM(adm),"^",4)
	.//q:(Dept'[loc)&(Dept'="")
	.s locdes=$P(^CTLOC(loc),"^",2)
	.i $l(locdes,"-")>1 s locdes=$p(locdes,"-",2)
	.s locdes=locdes_"/"_$G(bedCode)
	.s jz=$P(^OR(adm,"ANA",chl),"^",32)   						//ANA_SourceType 急诊(E)/择期(B)
	.if jz="E" s jzstat="急诊"
	.else  s jzstat="择期"
	.s mzdr=$P(^OR(adm,"ANA",chl),"^",6) 
	.i mzdr'="" d
	..s mzdoc=$TR($P($G(^CTPCP(mzdr,1)),"^",2)," ","") 			;麻醉医师
	.e  s mzdoc=""
	.s mzsupdr=$P(^OR(adm,"ANA",chl),"^",7)        				;ANA_Supervisor_DR ///ck091203  
	.i mzsupdr'="" d
	..s mzsupdoc=$TR($P(^CTPCP(mzsupdr,1),"^",2)," ","") 		;麻醉指导医师
	.e  s mzsupdoc=""
	.s mzNurseId=$P(^OR(adm,"ANA",chl),"^",8) 
	.i mzNurseId'="" d
	..s anNurse=$TR($P($G(^CTPCP(mzNurseId,1)),"^",2)," ","") 	;麻醉护士
	.e  s anNurse=""
	.s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)						;ANA_Method	 麻醉方法
	.s anmethod=""
	.i anmthdr'="" d
	..s anmetNum=$l(anmthdr,"|")
	..f i=1:1:anmetNum d
	...s anmetId=$p(anmthdr,"|",i)
	...q:anmetId=""
	...s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
	...i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
	...i anmethod="" s anmethod=anmetDesc
	...e  s anmethod=anmethod_","_anmetDesc
	.s prediag="",diamen=""
	.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d ///ck091117
	..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
	..i opdr'=""  d
	...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d
	....i opdes'="" s opdes=opdes_";"
	....s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)
	..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)      		    ;ANAOP_Surgeon_DR   手术医师
	..if docdr'="" s opd=$TR($P(^CTPCP(docdr,1),"^",2)," ","")
	..e  s opd=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //手术医生备注	   
	..s predigdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",4)   		    ;ANAOP_PreopDiag_DR 术前诊断
	..i predigdr'=""  d
	...s prediag=$P(^MRC("ID",predigdr),"^",2)
	...s diag=$G(prediag)
	.s ^DHCVISOpSchTemp($j,oproomdes,opordno,opaId)=oproomdes_"^"_opordno_"^"_opdes_"^"_Status_"^"_opsttime_"^"_$G(opd)
	   
    s ShowNum=0
    s oproomdes=""  f  s oproomdes=$o(^DHCVISOpSchTemp($j,oproomdes)) q:oproomdes=""  d
    .s opordno=""  f  s opordno=$o(^DHCVISOpSchTemp($j,oproomdes,opordno)) q:opordno=""  d
    ..s j="" f  s j=$o(^DHCVISOpSchTemp($j,oproomdes,opordno,j)) q:j=""  d
    ...s ShowNum=ShowNum+1
    ...s ^DHCVISOpSchTemp("Sort",ShowNum)=^DHCVISOpSchTemp($j,oproomdes,opordno,j)
    
    s RetStr=""
    s ShowNum=1
    s Index=$G(^DHCVISOpSchTemp("Index"))
    f  s Index=$O(^DHCVISOpSchTemp("Sort",Index)) q:(Index="")||(ShowNum>MaxShowRows)  d
    .s OneData=$G(^DHCVISOpSchTemp("Sort",Index))
    .i RetStr="" s RetStr=OneData
    .e  s RetStr=RetStr_"!"_OneData
    .s ShowNum=ShowNum+1
    k ^DHCVISOpSchTemp("Sort")
    k ^DHCVISOpSchTemp($j)
    
    q RetStr
}

/// w ##class(web.DHCVISInfoShow).GetAnOpShow()
ClassMethod GetAnOpShow(date As %String, stutas As %String) As %String
{
    s n=0,j=0,i=1,oneData=""
    s date="",stutas=""
    k ^TMPVis("App")
    s n=..GetAnOpList(date,stutas)
    s j=n
	s data=""
	s head="{"
	s oneHead="["
	s oneMiddle="]={"
	s oneTail="},"
	s tail="row="_n_"}"
	for i=1:1:j  d
	.s oneData=oneHead_i_oneMiddle_^TMPVis("App",i)_oneTail
	.if data="" s data=oneData
	.e  s data=data_oneData
	s data=head_data_tail
	q data
}

/// w ##class(web.DHCVISInfoShow).GetAnOpList()
ClassMethod GetAnOpList(date As %String, stutas As %String) As %String
{
	///paidType "Y"已收费，"N"未收费，其它为全部
    k ^TMPVis("App")
    s chl=""
    s j=1
    s num=0
    s date=+$h
    s SubNode="SDate"
    s IsAppT=0
    i IsAppT=1 s SubNode="AppDate"
       s opaId=""
       f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d
	   .q:$d(^DHCANOPArrange(opaId))<1
	   .s opdate="",oproomdes="",regNo="",patName="",diag="",sex="",yy="",age="",opdes="",locdes="",opd="",mzdoc="",anmethod="",xsh="",xch="",OPCategory=""
	   .s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
	   .s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
	   .s openddate=$P(^DHCANOPArrange(opaId),"^",16)
	   .s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
	   .s opmem=$P($P(^DHCANOPArrange(opaId),"^",19),"#",1)        	//WKZ 071109 //liangq 20101029
	   .i openddate<=opstdate s openddate=""
	   .if openddate'=""  s openddate=$ZD(openddate,4)_" "
	   .if opendtime'=""  s opendtime=$ZT(opendtime,2)
	   .if opsttime'=""  s opsttime=$ZT(opsttime,2)
	   .s opdatestr=$ZD(opstdate,4)_" "_opsttime_"~"_openddate_opendtime
	   .s opAppdate=$P(^DHCANOPArrange(opaId),"^",3)         //wkz 071225 S
	   .s opApptime=$P(^DHCANOPArrange(opaId),"^",5)
	   .if opAppdate'=""  s opAppdate=$ZD(opAppdate,4)
	   .if opApptime'=""  s opApptime=$ZT(opApptime,2)
	   .s OpAppDateStr=$G(opAppdate)_"  "_$G(opApptime)  	 //wkz 071225 E
	   .s arrTime=$P(^DHCANOPArrange(opaId),"^",8)
	   .s arrDate=$P(^DHCANOPArrange(opaId),"^",7)
	   .i arrTime'=""  d 	//安排时间不为空
	   ..s opdate=$ZD(arrDate,3)_" "_$ZT(arrTime,2)
	   .e  s opdate=$ZD(opstdate,3)_" "_opsttime
	   .s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	   .if oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
	   .//q:(oproomdr'=oproom)&(oproom'="")
	   .i oproomdr'="" s floorId=$p($g(^DHCANC("OPRoom",oproomdr)),"^",4)
	   .e  s floorId=""
	   .i floorId'="" s oprFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
	   .e  s oprFloor=""
	   .//q:(oprFloorId'="")&(oprFloorId'=floorId)
	   .s opordno=$P(^DHCANOPArrange(opaId),"^",26)
	   .i (opordno'="")&(opordno=1) s opdate="8:30"   				//ck  091016
	   .i (opordno'="")&(opordno'=1) s opdate="接台"_(opordno-1)  	//ck  091016
	   .s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm
	   .q:adm=""
	   .s bedCode="",inPatNo="",admreason=""
	   .s bedSub=$p($p($g(^PAADM(adm)),"^",73),"||",2)
       .s curWardId=$p($g(^PAADM(adm)),"^",70)  
       .if curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
       .if (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
       .s inPatNo=$p($g(^PAADM(adm)),"^",29)
       .s admreasondr=$p($g(^PAADM(adm,1)),"^",7)
       .i admreasondr'="" s admreason=$p(^PAC("ADMREA",admreasondr),"^",2)
	   .s yg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",29)			//OPA_PATestHBsAg  	免疫乙肝表面抗原
	   .s bg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",34)			//OPA_PATestHCVAb 	免疫丙型肝炎抗体
	   .s az=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",35)			//OPA_PATestHivAb 	免疫艾滋病毒抗体
	   .s md=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",36)			//OPA_PATestTPAb 	免疫梅毒
	   .s qt=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",2)			//OPA_PATestOther	检其它阴阳性
	   .if yg="阳性" s yy="乙肝阳性"
	   .if bg="阳性" s yy=yy_"丙肝阳性"_" "
	   .if az="阳性" s yy=yy_"艾滋病阳性"_" "
	   .if md="阳性" s yy=yy_"梅毒阳性"_" "
	   .if qt="阳性" s yy=yy_"其他阳性"_" "
	   .s Stat=$P(^DHCANOPArrange(opaId),"^",27)
	   .//q:(Stat="")&(userLocTyp'="E")
	   .//q:(stat'="")&(stat'=Stat)
	   .s Status=""
	   .i Stat="A" s Status="申请"
	   .i Stat="D" s Status="拒绝"
	   .i Stat="R" s Status="安排"
	   .i Stat="N" s Status="非预约"
	   .i Stat="I" s Status="术中"
	   .i Stat="P" s Status="恢复室"
	   .i Stat="L" s Status="术毕"
	   .i Stat="F" s Status="完成"
	   .q:Stat="D"
	   .//q:(Stat="N")&(appType="")
	   .//q:(Stat'="N")&(appType="RegNotApp")
	   .s papmiId=$p($g(^PAADM(admId)),"^",1)
       .s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
       .s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
       .//q:(medCareNo'=MedCareNo)&(MedCareNo'="")
       .s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
       .s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
       .s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
       .s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	   .s loc=$P(^PAADM(adm),"^",4)
	   .//q:(Dept'[loc)&(Dept'="")
	   .s locdes=$P(^CTLOC(loc),"^",2)
	    .i $l(locdes,"-")>1 s locdes=$p(locdes,"-",2)
	   .s locdes=locdes_"/"_$G(bedCode)
	   .s jz=$P(^OR(adm,"ANA",chl),"^",32)   						//ANA_SourceType 急诊(E)/择期(B)
	   .if jz="E" s jzstat="急诊"
	   .else  s jzstat="择期"
	   .s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        					;ANA_Anaesthetist_Dr 
	   .i mzdr'="" d
	   ..s mzdoc=$TR($P($G(^CTPCP(mzdr,1)),"^",2)," ","") 			;麻醉医师
	   .e  s mzdoc=""
	   .s mzsupdr=$P(^OR(adm,"ANA",chl),"^",7)        				;ANA_Supervisor_DR ///ck091203  
	   .i mzsupdr'="" d
	   ..s mzsupdoc=$TR($P(^CTPCP(mzsupdr,1),"^",2)," ","") 		;麻醉指导医师
	   .e  s mzsupdoc=""
	   .s anDocAss=""
	   .s ass=0
	   .f  s ass=$o(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)) q:ass=""  d    //麻醉医师
	   ..s mzzsdr=$p($g(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)),"^",1)
	   ..q:mzzsdr=""
	   ..i anDocAss="" d
	   ...s anDocAss=$TR($P($G(^CTPCP(mzzsdr,1)),"^",2)," ","")
	   ..e  d
	   ...s anDocAss=anDocAss_" "_$TR($P($G(^CTPCP(mzzsdr,1)),"^",2)," ","")
	   .s mzNurseId=$P(^OR(adm,"ANA",chl),"^",8) 
	   .i mzNurseId'="" d
	   ..s anNurse=$TR($P($G(^CTPCP(mzNurseId,1)),"^",2)," ","") 	;麻醉护士
	   .e  s anNurse=""
	   .s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)						;ANA_Method	 麻醉方法
	   .s anmethod=""
	   .i anmthdr'="" d
	   ..s anmetNum=$l(anmthdr,"|")
	   ..f i=1:1:anmetNum d
	   ...s anmetId=$p(anmthdr,"|",i)
	   ...q:anmetId=""
	   ...s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
	   ...i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
	   ...i anmethod="" s anmethod=anmetDesc
	   ...e  s anmethod=anmethod_","_anmetDesc
	   .s anCompDesc=""                                        		//+ wxl 090316 合并疾病
	   .s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"COMP",subchl)) q:(subchl="")  d
	   ..s AnCompDr=$P(^OR(adm,"ANA",chl,"COMP",subchl),"^",1)
	   ..q:AnCompDr=""
	   ..if anCompDesc="" s anCompDesc=$P(^ORC("COMP",AnCompDr),"^",2)
	   ..e  s anCompDesc=anCompDesc_","_$P(^ORC("COMP",AnCompDr),"^",2)	   
	   .s i=0
	   .s prediag="",diamen=""
	   .s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d ///ck091117
	   ..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
	   ..i opdr'=""  d   //ck091210
	   ...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d     ///ck091117
	   ....i opdes'="" s opdes=opdes_";"     ///ck091117
	   ....s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)     ///ck091117
	   ..e  d
	   ...i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d //liangq 20101027 从第二个节点取手工填写的手术名称
	   ....i opdes'="" s opdes=opdes_";"
	   ....s opdes=opdes_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))    ///ck091210
	   ..s i=i+1
	   ..q:i>1   ///ck091117
	   ..s sub=subchl
	   ..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)      		;ANAOP_Surgeon_DR   手术医师
	   ..if docdr'="" s opd=$TR($P(^CTPCP(docdr,1),"^",2)," ","")
	   ..e  s opd=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //CK 091210 手术医生备注(外来手术医生)	   
	   ..s predigdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",4)   		;ANAOP_PreopDiag_DR 术前诊断
	   ..i predigdr'=""  d
	   ...s prediag=$P(^MRC("ID",predigdr),"^",2)
	   ...s diag=$G(prediag)
	   ..e  d
	   ...i $g(^OR(adm,"ANA",chl,"TXT",1))'="" d 
	   ....s diamen=^OR(adm,"ANA",chl,"TXT",1)  	//ck091210 麻醉表存放诊断备注ANA_Notes
	   ....s diag=$p($G(diamen),"/",1)
	   ..s operLocId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",10) 		;ANAOP_CTLOC_DR
	   .s admLocId=$p($g(^PAADM(adm)),"^",4)
	   .//q:(("^"_userLocIdStr_"^")'[("^"_+operLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+admLocId_"^"))  //ypz 070318
	   .s i=0
	   .q:sub=""
	   ..s i=i+1
	   .s ash=""
	   .
	   .s assDocNum=2 //最多显示的助手人数
	   .i $p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)'="" s assDocNum=$p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)
	   .s p=0
	   .s list=0,asName=""
	   .s opaDocNote=$P(^DHCANOPArrange(opaId),"^",42) //手动填写OPA_OpDocNote（实习医生1;实习医生2...|主刀|一助|二助|三助|四助|五助...）
	   .s len=$l(opaDocNote,"|")
	   .s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",sub,"ASS",as)) q:(as="")!(p'<assDocNum)  d
	   ..s asdr=$P(^OR(adm,"ANA",chl,"OP",sub,"ASS",as),"^",1)
	   ..s p=p+1
	   ..q:asdr=""
	   ..s asName=asName_"^"_$P(^CTPCP(asdr,1),"^",2)
	   .i len>assDocNum+2 s len=assDocNum+2
	   .f getLen=3:1:len  d
	   ..i $p(opaDocNote,"|",getLen)'=""  d
	   ...s getName=$p(opaDocNote,"|",getLen)
	   ..e  d
	   ...s list=list+1
	   ...s getName=$p(asName,"^",list+1)
	   ..s ash=ash_" "_getName
	   .
	   .s p=0  ;洗手
	   .s xs=0 f  s xs=$O(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs)) q:(xs="")!(p=3)  d
	   ..q:xs>20
	   ..s xsdr=$P(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs),"^",1)
	   ..q:xsdr=""
	   ..s p=p+1
	   ..s xsh=xsh_" "_$TR($P(^CTPCP(xsdr,1),"^",2)," ","")  ;
	   .s p=0  ;巡回
	   .s xc=0 f  s xc=$O(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc)) q:(xc="")!(p=3)   d
	   ..q:xc>20
	   ..s xchdr=$P(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc),"^",1)
	   ..q:xchdr=""
	   ..s p=p+1
	   ..s xch=$G(xch)_" "_$TR($P($G(^CTPCP(xchdr,1)),"^",2)," ","")  
	   .s scNurNote=$p($G(^DHCANOPArrange(opaId)),"^",51)		//OPA_ScrubNurseNote	器械护士备注 	
	   .s cirNurNote=$p($G(^DHCANOPArrange(opaId)),"^",52)		//OPA_CirculNurseNote	巡回护士备注
	   .s j=j+1
	   .s opd=opd_","_$G(ash)
	   .if oproomdes="" s oproomdes="无"
	   .if opordno="" s opordno="未排" ;Do OutRow2
	   .s NeedAnaesthetist=$p($G(^DHCANOPArrange(opaId)),"^",44)
	   .s operInstrumentId=$P(^DHCANOPArrange(opaId),"^",30)
	   .i operInstrumentId'="" s operInstrument=$P($G(^DHCANC("Instrument",operInstrumentId)),"^",2)
	   .e  s operInstrument=""
	   .s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	   .s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	   .s anaSub=$P(anaId,"||",2)
	   
	   .//liangq 20100826 取多个体位表
	   .s operPositionId = 0
	   .s operPositionList = ""
	   .f  s operPositionId = $o(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",operPositionId)) q:operPositionId=""  d
	   ..s positionDr = $p($G(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",operPositionId)),"^",1)
	   ..q:positionDr=""
	   ..s val = $P($G(^ORC("OPPOS",positionDr)),"^",2)
	   ..i operPositionList=""  s operPositionList=val
	   ..e  s operPositionList = operPositionList_","_val
	   
	   .//s operPositionId=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",1)),"^")
	   .//i operPositionId'="" s operPosition=$P($G(^ORC("OPPOS",operPositionId)),"^",2)
	   .//e  s operPosition=""
	   .s OPCategory="",OPCategoryId=""
	   .;s OPCategoryId=$p(^ORC("OPER",opdr),"^",7)
	   .i opdr'="" s OPCategoryId=$p($g(^ORC("OPER",opdr)),"^",7)
       .i OPCategoryId'=""  s OPCategory=$p(^ORC("CATEG",OPCategoryId),"^",2)
	   .s isAddInstrument=$P($G(^DHCANOPArrange(opaId)),"^",31)
	   .s instrumentDr=$P($G(^DHCANOPArrange(opaId)),"^",30)
	   .i instrumentDr'="" s instrument=$P($G(^DHCANC("Instrument",instrumentDr)),"^",2)
	   .e  s instrument=""
	   .s patWardId1=$P($G(^DHCANOPArrange(opaId)),"^",32)
	   .//q:(patWardId'="")&(patWardId'=patWardId1)
	   .i patWardId1'="" s patWard=$P($G(^PAWARD(patWardId1)),"^",2)
	   .e  s patWard=""
	   .s estiOperDuration=$P($G(^DHCANOPArrange(opaId)),"^",37)
	   .i estiOperDuration'="" s estiOperDuration=$ZT(estiOperDuration,2)
	   .s preDiscussDate=$P($G(^DHCANOPArrange(opaId)),"^",38)
	   .s preDiscussDate=$ZD(preDiscussDate,4)
	   .s isExCirculation=$P($G(^DHCANOPArrange(opaId)),"^",36)
	   .s bloodTypId=$P(^DHCANOPArrange(opaId),"^",11)
	   .i bloodTypId'="" s bloodType=$P($G(^PAC("BLDT",bloodTypId)),"^",2)
	   .e  s bloodType=""
	   .s opDocNote=$P($G(^DHCANOPArrange(opaId)),"^",42)
	   .s anDocNote=$P($G(^DHCANOPArrange(opaId)),"^",43)
	   .s opSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)
	   .s AnaesthesiaID=$P($G(^DHCANOPArrange(opaId)),"^",2)
	   .s retReasonId=$P($G(^DHCANOPArrange(opaId)),"^",35)
	   .i retReasonId'=""  s retReason=$p(^ORC("SUSP",retReasonId),"^",2)   //+ ck091212 手术拒绝原因
	   .e  s retReason=""
	   .s anaDoctorOrd=$p($G(^DHCANOPArrange(opaId)),"^",48)     	//+ ck091212 麻醉医生收费状态
	   .i anaDoctorOrd="Y"  s anaDoctorOrd="Y"
	   .e  s anaDoctorOrd="N"
	   .//q:(paidType="Y")&(LogUserType="ANDOCTOR")&(anaDoctorOrd="N") //ck 20100303修改
	   .//q:(paidType="N")&(LogUserType="ANDOCTOR")&(anaDoctorOrd="Y")
	   .s anaNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",49)      	//+ ck091212 麻醉护士收费状态
	   .i anaNurseOrd="Y"  s anaNurseOrd="Y"
	   .e  s anaNurseOrd="N"
	   .//q:(paidType="Y")&(LogUserType="ANNURSE")&(anaNurseOrd="N")    //ck 20100303修改
	   .//q:(paidType="N")&(LogUserType="ANNURSE")&(anaNurseOrd="Y")
	   .s opNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",50)       	//+ ck091212 手术护士收费状态
	   .i opNurseOrd="Y"  s opNurseOrd="Y"
	   .e  s opNurseOrd="N"
	   .//q:(paidType="Y")&(LogUserType="OPNURSE")&(opNurseOrd="N") //ck 20100303修改
	   .//q:(paidType="N")&(LogUserType="OPNURSE")&(opNurseOrd="Y")
	   .s tPacuBedId=$P($G(^DHCANOPArrange(opaId)),"^",47)		 	//OPA_PacuBed_Dr	麻醉恢复床
	   .i tPacuBedId'="" s tPacuBed=$p(^DHCANC("OPRoom",tPacuBedId),"^",2)
	   .e  s tPacuBed=""
	   .s PACUInDate=$P($G(^DHCANOPArrange(opaId,"PACU")),"^",6) 	//OPA_PACUInDate	入恢复室日期
	   .i PACUInDate'="" s PACUInDate=$zd(PACUInDate,3)
	   .s PACUInTime=$P($G(^DHCANOPArrange(opaId,"PACU")),"^",7) 	//OPA_PACUInTime	入恢复室时间
	   .i PACUInTime'="" s PACUInTime=$zt(PACUInTime)
	   .s PACUInDateTime=PACUInDate_" "_PACUInTime
	   .//
	   .s mutilValues = "", dhcop = ^DHCANOPArrange(opaId),sp="^"
	   .s mutilValues = $p($g(^DHCANOPArrange(opaId,"PA")),sp,89)_sp_$p(opmem,"#",2)_sp_jz_sp_$p(dhcop,sp,44)_sp_$p(dhcop,sp,10)
	   .s mutilValues = mutilValues_sp_isExCirculation_sp_$p(dhcop,sp,34)_sp_$p(dhcop,sp,33)
	   .s num=num+1
	   .//s ^TMPVis("App","Num")=num
	   .//s ^TMPVis("App",$j,oproomdes,opordno,j)=Status_","_jzstat_","_opdate_","_oproomdes_","_opordno_","_regNo_","_patName_","_sex_","_opdes_","_diag_","_opd_","_locdes_","_anmethod_","_mzdoc_","_xsh_","_xch_","_yy_","_opaId_","_adm_","_opdatestr_","_OpAppDateStr_","_opmem_","_isAddInstrument_","_instrument_","_patWard_","_anNurse_","_medCareNo_","_oproomdr_","_oprFloor_","_estiOperDuration_","_preDiscussDate_","_isExCirculation_","_bloodType_","_opDocNote_","_anDocNote_","_opSeqNote_","_anCompDesc_","_AnaesthesiaID_","_operPositionList_","_OPCategory_","_operInstrument_","_NeedAnaesthetist_","_opsttime_","_mzsupdoc_","_retReason_","_anaDoctorOrd_","_anaNurseOrd_","_opNurseOrd_","_inPatNo_","_admreason_","_tPacuBed_","_PACUInDateTime_","_scNurNote_","_cirNurNote_","_anDocAss_","_mutilValues
       .s ^TMPVis("App",$j,oproomdes,opordno,j)=opdate_","_patName_","_opdes_","_oproomdes_","_Status
     
      s showNum=1
      s oproomdes=""  f  s oproomdes=$o(^TMPVis("App",$j,oproomdes)) q:oproomdes=""  d
      .s opordno=""  f  s opordno=$o(^TMPVis("App",$j,oproomdes,opordno)) q:opordno=""  d
      ..s j="" f  s j=$o(^TMPVis("App",$j,oproomdes,opordno,j)) q:j=""  d
      ...s ^TMPVis("App",showNum)=^TMPVis("App",$j,oproomdes,opordno,j)
      ...s showNum=showNum+1
      q num
}

/// w ##class(web.DHCVISRegShow).GetRegResouce()
ClassMethod GetRegResouce(ServerIP As %String = "0.0.0.0", WindowNo As %String = "") As %String
{
	s retStr=""
	s LocStr=""
	s WindowNo=+WindowNo
	s max=6
	s UserId=2  //7289
	s GroupRowId=5  //53
	i ServerIP'="" d
	.s LocStr=""
	.s LocStr=$G(^DHCVISRegShowSet("IP",ServerIP))
	i LocStr="" d
	.s LocId=""
	.f  s LocId=$O(^CTLOC(0,"LocType","E",LocId)) q:LocId=""  d
	..i LocStr="" s LocStr=LocId
	..e  s LocStr=LocStr_"^"_LocId	
	s CreatFlag=0
	//i $D(^DHCVISRegShow(+$H,ServerIP))=0 
	s CreatFlag=1
	//i WindowNo>0 
	k ^DHCVISRegShow(+$H,ServerIP)
	f i=1:1:$L(LocStr,"^") {
		s LocRowId=$P(LocStr,"^",i)
		s TimeRange=1     //DHC_TimeRange
		i $P($H,",",2)>43200 s TimeRange=2
		i TimeRange=1 s TimeRange=""
		//s val="^"_UserId_"^^^"_TimeRange_"^^"_GroupRowId_"^"_LocRowId_"^^^0^"
		s val=LocRowId_"^"_UserId_"^^^"_TimeRange_"^^"_GroupRowId_"^^false"
		s rs=##Class(%ResultSet).%New("web.DHCOPAdmReg:OPDocList")
		i rs.QueryIsValid() { 
			Set Status=rs.Execute(val)
			Set columns = rs.GetColumnCount()
			If 'Status Quit
			While rs.Next() {
				s CTLocDesc=rs.GetData(20)
				i $P(CTLocDesc,"-",2)'="" s CTLocDesc=$P(CTLocDesc,"-",2)
				s MarkDesc=rs.GetData(2)
				s TypeDesc=rs.GetData(10)
				s RegFee=rs.GetData(11)
				s ExamFee=rs.GetData(13)
				s RegFee=RegFee+ExamFee
				//i RegFee<9 continue
				//s RegFee=rs.GetData(24)
				s AvailSeqNo=rs.GetData(21)
				s AppLoad=rs.GetData(4)
				s TimeRangeDesc=rs.GetData(28)
				s MarkDesc=MarkDesc   //_"("_TimeRangeDesc_")"
				//s AvailSeqNo=AvailSeqNo-AppLoad    //当前剩号=剩号-预约号
				i AvailSeqNo<0 s AvailSeqNo=0
				s RoomSite=""
				s RoomDr=""
				s ASRowId=rs.GetData(1)
				s ResRowId=$P(ASRowId,"||",1)
	 			s ASChildSub=$P(ASRowId,"||",2)
	 			i (ResRowId'="")&&(ASChildSub'="") s RoomDr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",5)
				i RoomDr'="" d
				.s RoomSite=$g(^CTLOC(RoomDr,"ADDR",1))
				.s RoomSite=$$ALPHAUP^SSUTIL4(RoomSite)
				.i RoomSite="" s RoomSite=$p($g(^CTLOC(RoomDr)),"^",16)
				.//s CTLocDesc=$P($G(^CTLOC(RoomDr)),"^",2)
				i (CTLocDesc'="") d
				.i CreatFlag=1 	s ^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc)=CTLocDesc_"^"_MarkDesc_"^"_TypeDesc_"^"_TimeRangeDesc_"^"_AvailSeqNo_"^"_RoomSite
				.e  d
				..i $D(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc))>0 s ^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc)=CTLocDesc_"^"_MarkDesc_"^"_TypeDesc_"^"_TimeRangeDesc_"^"_AvailSeqNo_"^"_RoomSite
			}
		}
	}
	k ^DHCVISRegShowQueue($j)
	s index=1
	s CTLocDesc=""
	f  s CTLocDesc=$O(^DHCVISRegShow(+$H,ServerIP,CTLocDesc)) q:(CTLocDesc="")  d
	.s MarkDesc=""
	.f  s MarkDesc=$O(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc)) q:(MarkDesc="")  d
	..s TimeRangeDesc=""
	..f  s TimeRangeDesc=$O(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc)) q:(TimeRangeDesc="")  d
	...s rowvalue=$G(^DHCVISRegShow(+$H,ServerIP,CTLocDesc,MarkDesc,TimeRangeDesc))
	...q:rowvalue="" 
	...s ^DHCVISRegShowQueue($j,index)=rowvalue
	...s index=index+1
	s sum=1
	s index=""
	s index=$G(^DHCVISRegIndex(ServerIP,WindowNo))
	i $O(^DHCVISRegShowQueue($j,index))="" s index=""
	f  s index=$O(^DHCVISRegShowQueue($j,index)) q:(index="")!(sum>max)  d
	.s rowvalue=$G(^DHCVISRegShowQueue($j,index))
	.q:rowvalue=""
	.if retStr="" s retStr=rowvalue
	.else  s retStr=retStr_"!"_rowvalue
	.//s index=index+1
	.s ^DHCVISRegIndex(ServerIP,WindowNo)=index
	.s ^DHCVISRegIndex(ServerIP,0)=index
	.s sum=sum+1
	k ^DHCVISRegShowQueue($j)		
	s TableStr="科室@1700^号别@1000^职称@1700^时段@600^已挂数@800^就诊地点@1880"
	s retStr=TableStr_"!"_retStr
	q retStr
}

/// w ##class(web.DHCVISInfoShow).GetRadioReportShow()
ClassMethod GetRadioReportShow() As %String
{
    s n=0,j=0,i=1,oneData=""
    s IP=1 //$ZUTIL(67,15,$JOB)
    k ^DHCVISReport(IP)
    s n=..GetTwoDaysReportArrangeQueue()
    s j=n
	s data=""
	s head="{"
	s oneHead="["
	s oneMiddle="]={"
	s oneTail="},"
	s tail="row="_n_"}"
	for i=1:1:j  d
	.s oneData=oneHead_i_oneMiddle_^DHCVISReprotShow(IP,i)_oneTail
	.if data="" s data=oneData
	.e  s data=data_oneData
	s data=head_data_tail
	q data
}

/// /// w ##class(web.DHCVISInfoShow).GetTwoDaysReportArrangeQueue()
ClassMethod GetTwoDaysReportArrangeQueue() As %String
{
	s arrNameStr=""
	s arrName=""
	s IP=1
	k ^DHCVISReprotShow(IP)
	s m=1,k=0,num=1
	i '$d(^DHCVISReport(+$h,"Report")) d 
	.f nowDate=+$H:-1:(+$H-1) d
	..s rowId=""  f  s rowId=$O(^DHCVISReportQueuei(0,"CreateDateState",nowDate,"Y",rowId),-1) q:(rowId="")  d
	...s arrName=$p($g(^DHCVISReportQueue(rowId)),"^",2)
	...s arrName=##class(web.DHCNurseBlood).extendEname(arrName)
	...s arrName=$c(34)_arrName_$c(34)
	...q:(arrNameStr'="")&&($l(arrNameStr,arrName)>1)
	...i arrNameStr="" s arrNameStr=arrName
	...e  s arrNameStr=arrNameStr_","_arrName
	...s ^DHCVISReport(+$h,"Report",m)=arrNameStr
	...s k=k+1
	...i k#4=0 s k=0,m=m+1,arrNameStr=""
	
	s reportId=""
	f  s reportId=$o(^DHCVISReport(+$h,"Report",reportId)) q:(reportId="")||(num>10)  d 
	.s ^DHCVISReprotShow(IP,num)=^DHCVISReport(+$h,"Report",reportId) 
	.s num=num+1
	.k ^DHCVISReport(+$h,"Report",reportId)
	q num-1
}

/// w ##class(web.DHCVISInfoShow).GetRadioReport()
ClassMethod GetRadioReport() As %String
{
	s arrNameStr=""
	s arrName=""
	s IP=1
	k ^TempVISPacsReport($J)
	s m=1,k=0,num=1 
	f nowDate=+$H:-1:(+$H-1) d
	.s rowId=""  f  s rowId=$O(^DHCVISReportQueuei(0,"CreateDateState",nowDate,"Y",rowId),-1) q:(rowId="")  d
	..s patName=$p($g(^DHCVISReportQueue(rowId)),"^",2)
	..s ^TempVISPacsReport($J,"Report",patName)=patName
	
	s RetStr=""
	s num=0
	s patName=$G(^DHCVISPacsReport(+$H))
	f  s patName=$o(^TempVISPacsReport($J,"Report",patName)) q:(patName="")||(num>36)  d 
	.i num#6>0 d
	..i RetStr="" s RetStr=patName
	..e  s RetStr=RetStr_"^"_patName
	.e  d
	..i RetStr="" s RetStr=patName
	..e  s RetStr=RetStr_"!"_patName
	.s num=num+1
	.i $O(^TempVISPacsReport($J,"Report",patName))="" s ^DHCVISPacsReport(+$H)=""
	.e  s ^DHCVISPacsReport(+$H)=patName
	k ^TempVISPacsReport($J)
	q RetStr
}

/// w ##class(web.DHCVISInfoShow).NewOper()
ClassMethod NewOper(MaxShowRows As %String = "6") As %String
{
	//Q "areaid=queueinfo&areatype=queue&dataid=49924&data=<br/>王丽丽<br/>李丽丽<br/>安排<br/>头部血管治疗性超声<br/>中西医结合一科/0101床<br/>杨佳<br/>2<br/>手术室20<br/>王丽丽<br/>李丽丽<br/>安排<br/>头部血管治疗性超声<br/>中西医结合一科/0101床<br/>杨佳<br/>2<br/>手术室20<br/>王丽丽<br/>李丽丽<br/>安排<br/>头部血管治疗性超声<br/>中西医结合一科/0101床<br/>杨佳<br/>2<br/>手术室20<br/>王丽丽<br/>李丽丽<br/>安排<br/>头部血管治疗性超声<br/>中西医结合一科/0101床<br/>杨佳<br/>2<br/>手术室20<br/>王丽丽<br/>李丽丽<br/>安排<br/>头部血管治疗性超声<br/>中西医结合一科/0101床<br/>杨佳<br/>2<br/>手术室20<br/>王丽丽<br/>李丽丽<br/>安排<br/>头部血管治疗性超声<br/>中西医结合一科/0101床<br/>杨佳<br/>2<br/>手术室20<br/>麻师<br/>主刀<br/>状态<br/>术称<br/>科别<br/>患者名<br/>台次<br/>手术室"
	s dataIndex=$p($h,",",2)
	s chl=""
   	s j=1
    s num=0
    s date=+$H
    s sdate=date,edate=date
    s SubNode="SDate"
    k ^DHCVISOpSchTemp($j)
	s opaId=""
	f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d
	.q:$d(^DHCANOPArrange(opaId))<1
	.s opdate="",oproomdes="",regNo="",patName="",stat="",appType="",diag="",oproom="",sex="",yy="",age="",opdes="",locdes="",opd="",mzdoc="",anmethod="",xsh="",xch="",OPCategory=""
	.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
	.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
	.s openddate=$P(^DHCANOPArrange(opaId),"^",16)
	.s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
	.s opmem=$P(^DHCANOPArrange(opaId),"^",19)        	//WKZ 071109
	.i openddate<=opstdate s openddate=""
	.i openddate'=""  s openddate=$ZD(openddate,3)_" "
	.i opendtime'=""  s opendtime=$ZT(opendtime,2)
	.i opsttime'=""  s opsttime=$ZT(opsttime,2)
	.s opdatestr=$ZD(opstdate,3)_" "_opsttime_"~"_openddate_opendtime
	.s opAppdate=$P(^DHCANOPArrange(opaId),"^",3)         //wkz 071225 S
	.s opApptime=$P(^DHCANOPArrange(opaId),"^",5)
	.i opAppdate'=""  s opAppdate=$ZD(opAppdate,3)
	.i opApptime'=""  s opApptime=$ZT(opApptime,2)
	.s OpAppDateStr=$G(opAppdate)_"  "_$G(opApptime)  	 //wkz 071225 E
	.s arrTime=$P(^DHCANOPArrange(opaId),"^",8)
	.s arrDate=$P(^DHCANOPArrange(opaId),"^",7)
	.i arrTime'=""  d 	//安排时间不为空
	..s opdate=$ZD(arrDate,3)_" "_$ZT(arrTime,2)
	.e  s opdate=$ZD(opstdate,3)_" "_opsttime
	.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	.i oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
	.//i oproomdes'="" s oproomdes=$p(oproomdes,"-",2)
	.q:(oproomdr'=oproom)&(oproom'="")
	.i oproomdr'="" s floorId=$p($g(^DHCANC("OPRoom",oproomdr)),"^",4)
	.e  s floorId=""
	.i floorId'="" s oprFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
	.e  s oprFloor=""
	.s opordno=$P(^DHCANOPArrange(opaId),"^",26)
	.i (sdate=edate)&(opordno'="")&(opordno=1)&(arrTime="") s opdate="8:30"
	.e  i (sdate'=edate)&(opordno'="")&(opordno=1)&(arrTime="") s opdate=$ZD(opstdate,3)_" "_"8:30"  
	.e  i (sdate=edate)&(opordno'="")&(opordno=1)&(arrTime'="") s opdate=$ZT(arrTime,2)
	.e  i (sdate'=edate)&(opordno'="")&(opordno=1)&(arrTime'="") s opdate=$ZD(opstdate,3)_" "_opsttime
	.s tmpDateStr=opordno
	.i +tmpDateStr=0 s tmpDateStr=""
	.e  s tmpDateStr=tmpDateStr-1
	.s tmpDateStr="接台"_tmpDateStr
	.i sdate'=edate s tmpDateStr=$p(opdate," ")_" "_oproomdes_tmpDateStr
	.e  s tmpDateStr=oproomdes_tmpDateStr
	.i (opordno'="")&(opordno'=1) s opdate=tmpDateStr 
	.s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm
	.q:adm=""
	.s PAADMMainMRADMDR=$p($g(^PAADM(adm)),"^",61) 
	.s PatientID=+$g(^PAADM(+adm))
	.s bedCode="",inPatNo="",admreason=""
	.s bedSub=$p($p($g(^PAADM(adm)),"^",73),"||",2)
	.s curWardId=$p($g(^PAADM(adm)),"^",70)  
	.i curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
	.i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	.s inPatNo=$p($g(^PAADM(adm)),"^",29)
	.s admreasondr=$p($g(^PAADM(adm,1)),"^",7)
	.i admreasondr'="" s admreason=$p(^PAC("ADMREA",admreasondr),"^",2)
	.s yg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",29)			//OPA_PATestHBsAg  	免疫乙肝表面抗原
	.s bg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",34)			//OPA_PATestHCVAb 	免疫丙型肝炎抗体
	.s az=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",35)			//OPA_PATestHivAb 	免疫艾滋病毒抗体
	.s md=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",36)			//OPA_PATestTPAb 	免疫梅毒
	.s qt=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",2)			//OPA_PATestOther	检其它阴阳性
	.i yg="阳性(+)" s yy="乙肝阳性"
	.i bg="阳性(+)" s yy=yy_"丙肝阳性"_" "
	.i az="阳性(+)" s yy=yy_"艾滋病阳性"_" "
	.i md="阳性(+)" s yy=yy_"梅毒阳性"_" "
	.i qt="阳性(+)" s yy=yy_"其他阳性"_" "
	.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,2)=userLocTyp_"/"_opaStatus_"/"_curWardId
	.s opaPatStatus=$P(^DHCANOPArrange(opaId),"^",23)
	.q:(stat'="")&(stat'=opaStatus)
	.s status=""
	.i opaStatus="A" s status="申请"
	.i (opaStatus="D")&(opaPatStatus'="I") s status="拒绝"
	.i opaStatus="R" s status="安排"
	.i opaStatus="N" s status="非预约"
	.i opaStatus="I" s status="术中"
	.i opaStatus="P" s status="恢复室"
	.i opaStatus="L" s status="术毕"
	.i opaStatus="F" s status="完成"
	.i (opaStatus="D")&(opaPatStatus="I") s status="撤销"
	.q:(opaStatus="N")&(appType="")
	.q:(opaStatus="F")||(status="撤销")||(status="拒绝")||(opaStatus="A")
	.q:(opaStatus'="N")&(appType="RegNotApp")
	.s opUnPlanedOperation=$P(^DHCANOPArrange(opaId),"^",46)
	.s papmiId=$p($g(^PAADM(admId)),"^",1)
	.s paadmtype=$p($g(^PAADM(admId)),"^",2)
	.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	.S medCareNo= ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(admId , .ErrMsg)
	.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	.//s age=..CalAge(birth,opstdate)
	.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	.s admLocId=$p($g(^PAADM(adm)),"^",4)
	.q:admLocId=""
	.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
	.s qFlag=1
	.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,4)=Dept_"/"_appLocId_"/"_admLocId
	.i +appLocId=0 s appLocId=admLocId
	.i +appLocId=0 s locdes=""
	.e  s locdes=$P($g(^CTLOC(appLocId)),"^",2)
	.i (appLocId'="")&(admLocId'=appLocId)&(paadmtype'="O") s locdes=locdes_"(借)"
	.i $l(locdes,"-")>1 s locdes=$p(locdes,"-",2)
	.i paadmtype="O" s locdes=locdes_"(门)"
	.e  s locdes=locdes_"/"_bedCode
	.s jz=$P(^OR(adm,"ANA",chl),"^",32)   						//ANA_SourceType 急诊(E)/择期(B)
	.i jz="E" s jzstat="急诊"
	.e  s jzstat="择期"
	.;;;;最后手术登记存放的时间，20120607+dyl
	.s anaTheatreInDate=$p(^OR(adm,"ANA",chl),"^",39)
	.i anaTheatreInDate'="" s anaTheatreInDate=$zd(anaTheatreInDate,3)
	.e  s anaTheatreInDate=opstdate
	.s anaTheatreInTime=$p(^OR(adm,"ANA",chl),"^",40)
	.i anaTheatreInTime'="" s anaTheatreInTime=$zt(anaTheatreInTime,2)
	.e  s anaTheatreInTime=opsttime
	.i opaStatus="F" s opdatestr=anaTheatreInDate_" "_anaTheatreInTime_"~"_openddate_opendtime
	.;;;;;;
	.s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        					;ANA_Anaesthetist_Dr 
	.i mzdr'="" d
	..//s mzdoc=$TR($P($G(^CTPCP(mzdr,1)),"^",2)," ","") 			;麻醉医师
	..s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr)
	.e  s mzdoc=""
	.s mzsupdr=$P(^OR(adm,"ANA",chl),"^",7)        				;ANA_Supervisor_DR ///ck091203  
	.i mzsupdr'="" d
	..//s mzsupdoc=$TR($P(^CTPCP(mzsupdr,1),"^",2)," ","") 		;麻醉指导医师
	..s mzsupdoc=##class(web.DHCANOPCom).GetNameById(mzsupdr)
	.e  s mzsupdoc=""
	.s anDocAss=""
	.s ass=0,surgeonDesc=""
	.f  s ass=$o(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)) q:ass=""  d    //麻醉医师
	..s mzzsdr=$p($g(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)),"^",1)
	..q:mzzsdr=""
	..i anDocAss="" d
	...//s anDocAss=$TR($P($G(^CTPCP(mzzsdr,1)),"^",2)," ","")
	...s anDocAss=##class(web.DHCANOPCom).GetNameById(mzzsdr)
	..e  d
	...//s anDocAss=anDocAss_" "_$TR($P($G(^CTPCP(mzzsdr,1)),"^",2)," ","")
	...s anDocAss=anDocAss_" "_##class(web.DHCANOPCom).GetNameById(mzzsdr)
	.i anDocAss'="" s mzdoc=mzdoc_","_anDocAss
	.s mzNurseId=$P(^OR(adm,"ANA",chl),"^",8)
	.i mzNurseId'="" d
	..//s anNurse=$TR($P($G(^CTPCP(mzNurseId,1)),"^",2)," ","") 	;麻醉护士
	..s anNurse=##class(web.DHCANOPCom).GetNameById(mzNurseId)
	.e  s anNurse=""
	.;ANA_Method:麻醉方法+dyl+20120611
	.s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)
	.s anmethod=""
	.i anmthdr'="" d
	..s anmetNum=$l(anmthdr,"|")
	..f i=1:1:anmetNum d
	...s anmetId=$p(anmthdr,"|",i)
	...q:anmetId=""
	...s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
	...i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
	...i anmethod="" s anmethod=anmetDesc
	...;e  s anmethod=anmethod_","_anmetDesc
	...e  i (anmethod'="")&(anmethod'[anmetDesc) s anmethod=anmethod_","_anmetDesc
	...e  i (anmethod'="")&(anmethod[anmetDesc) s anmethod=anmethod
	.s anCompDesc=""                                        		//+ wxl 090316 合并疾病
	.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"COMP",subchl)) q:(subchl="")  d
	..s AnCompDr=$P(^OR(adm,"ANA",chl,"COMP",subchl),"^",1)
	..q:AnCompDr=""
	..i anCompDesc="" s anCompDesc=$P(^ORC("COMP",AnCompDr),"^",2)
	..e  s anCompDesc=anCompDesc_","_$P(^ORC("COMP",AnCompDr),"^",2)	   
	.s i=0
	.s prediag="",diamen=""
	.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d ///ck091117
	..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
	..i opdr'=""  d   //ck091210
	...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d     ///ck091117
	....i opdes'="" s opdes=opdes_";"     ///ck091117
	....s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)     ///ck091117
	....//
	....i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",1))'="" d
	.....i opdes'="" s opdes=opdes_";"
	.....s opdes=opdes_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",1)) 
	..e  d
	...i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d
	....i opdes'="" s opdes=opdes_";"
	....s opdes=opdes_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))    ///ck091210
	..s i=i+1
	..q:i>1   ///ck091117
	..s sub=subchl
	..;手术部位
	..s bodsIdList=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",24) 	 //ypz 070418 	手术部位
	..s bodsList="",bodsDesc=""
	..i bodsIdList'="" d
	...s bodsIdNum=$l(bodsIdList,"|")
	...f j=1:1:bodsIdNum d
	....s bodsId=$p(bodsIdList,"|",j)
	....q:bodsId=""
	....s bodsDesc2=$p($g(^OEC("BODS",+bodsId)),"^",2)
	....;i bodsList="" s bodsList=bodsId_"|"_bodsDesc
	....;e  s bodsList=bodsList_"!"_bodsId_"|"_bodsDesc	
	....i bodsDesc="" s bodsDesc=bodsDesc2
	....e  s bodsDesc=bodsDesc_"|"_bodsDesc2   
	..;;;
	..s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)      		;ANAOP_Surgeon_DR   手术医师
	..s opd=""
	..//i docdr'="" s opd=$TR($P(^CTPCP(docdr,1),"^",2)," ","")
	..i docdr'="" s opd=##class(web.DHCANOPCom).GetNameById(docdr)
	..e  s opd=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //CK 091210 手术医生备注(外来手术医生)
	..s surgeonDesc=opd   
	..s predigdrS=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",4)   		;ANAOP_PreopDiag_DR 术前诊断字符串  zhangtao add
	..s num=$l(predigdrS,"|")
	..f pi=1:1:num d
	...s predigdr=$p(predigdrS,"|",pi)
	...i predigdr'=""  d
	....s prediag=$P(^MRC("ID",predigdr),"^",2)
	...s $p(diag,",",pi)=$G(prediag)
	...e  d
	....i $g(^OR(adm,"ANA",chl,"TXT",2))'="" d 
	.....s diamen=$p(^OR(adm,"ANA",chl,"TXT",2),"|",pi)  	//ck091210 麻醉表存放诊断备注ANA_Notes
	.....s $p(diag,",",pi)=$G(diamen)            //zhangtao add
	..s operLocId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",10) 		;ANAOP_CTLOC_DR
	.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,5)=userLocIdStr_"/"_operLocId_"/"_admLocId_"/"_appLocId
	.//q:(("^"_userLocIdStr_"^")'[("^"_+operLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+admLocId_"^"))&(("^"_userLocIdStr_"^")'[("^"_+appLocId_"^"))&(qFlag)  //ypz 070318
	.s i=0
	.q:sub=""
	..s i=i+1
	.s ash=""
	.s assDocNum=2 //最多显示的助手人数
	.i $p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)'="" s assDocNum=$p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)
	.s p=0
	.s list=0,asName=""
	.s opaDocNote=$P(^DHCANOPArrange(opaId),"^",42) //手动填写OPA_OpDocNote（实习医生1;实习医生2...|主刀|一助|二助|三助|四助|五助...）
	.s len=$l(opaDocNote,"|")
	.s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",sub,"ASS",as)) q:(as="")!(p'<assDocNum)  d
	..s asdr=$P(^OR(adm,"ANA",chl,"OP",sub,"ASS",as),"^",1)
	..s p=p+1
	..q:asdr=""
	..//s asName=asName_"^"_$P(^CTPCP(asdr,1),"^",2)
	..s asName=asName_"^"_##class(web.DHCANOPCom).GetNameById(asdr)
	.i len>assDocNum+2 s len=assDocNum+2
	.f getLen=3:1:len  d
	..i $p(opaDocNote,"|",getLen)'=""  d
	...s getName=$p(opaDocNote,"|",getLen)
	..e  d
	...s list=list+1
	...s getName=$p(asName,"^",list+1)
	..s ash=ash_" "_getName
	.s p=0  ;洗手
	.s xs=0 f  s xs=$O(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs)) q:(xs="")!(p=3)  d
	..q:xs>20
	..s xsdr=$P(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs),"^",1)
	..q:xsdr=""
	..s p=p+1
	..//s xsh=xsh_" "_$TR($P(^CTPCP(xsdr,1),"^",2)," ","")  ;
	..s xsh=xsh_" "_##class(web.DHCANOPCom).GetNameById(xsdr)
	.s p=0  ;巡回
	.s xc=0 f  s xc=$O(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc)) q:(xc="")!(p=3)   d
	..q:xc>20
	..s xchdr=$P(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc),"^",1)
	..q:xchdr=""
	..s p=p+1
	..//s xch=$G(xch)_" "_$TR($P($G(^CTPCP(xchdr,1)),"^",2)," ","")  
	..s xch=$G(xch)_" "_##class(web.DHCANOPCom).GetNameById(xchdr)  
	.s scNurNote=$p($G(^DHCANOPArrange(opaId)),"^",51)		//OPA_ScrubNurseNote	器械护士备注 	
	.s cirNurNote=$p($G(^DHCANOPArrange(opaId)),"^",52)		//OPA_CirculNurseNote	巡回护士备注
	.s j=j+1
	.s opd=opd_","_$G(ash)
	.s sortOpRoomDesc=oproomdes
	.i oproomdes="" s oproomdes="无"
	.s sortOpaSeq=opordno
	.i opordno="" s opordno="未排" ;Do OutRow2
	.s NeedAnaesthetist=$p($G(^DHCANOPArrange(opaId)),"^",44)
	.
	.s oprFloor=""
	..q:"D"[opaStatus
	..s para="M^149^麻醉会诊意见"
	..s eprRet=##class(EPRservice.BIL.BIToAN).IsOneGroupComplished(adm, 1, +$h, para)
	..i eprRet=0 s oprFloor="未写麻醉会诊意见! "
	..s para="M^151^麻醉知情同意书"
	..s eprRet=##class(EPRservice.BIL.BIToAN).IsOneGroupComplished(adm, 1, +$h, para)
	..i eprRet=0 s oprFloor=oprFloor_"未写麻醉知情同意书! "
	..q:"AR"[opaStatus
	..i "I"[opaStatus s oprFloor=oprFloor_"未完成麻醉记录单! "
	..e  d
	...s anoId=$o(^DHCANOrder(0,"OPApp",opaId,""))
	...i anoId="" s oprFloor=oprFloor_"未写麻醉记录单! "
    ..q:"I"[opaStatus
	..s para="M^153^麻醉术后访视记录"
	..s eprRet=##class(EPRservice.BIL.BIToAN).IsOneGroupComplished(adm, 1, +$h, para)
	..i eprRet=0 s oprFloor=oprFloor_"未写麻醉术后访视记录! "
	.s operInstrumentId=$P(^DHCANOPArrange(opaId),"^",30)
	.i operInstrumentId'="" s operInstrument=$P($G(^DHCANC("Instrument",operInstrumentId)),"^",2)
	.e  s operInstrument=""
	.s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	.s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	.s anaSub=$P(anaId,"||",2)
	.;手术体位
	.s operPositionId=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",1)),"^")
	.i operPositionId'="" s operPosition=$P($G(^ORC("OPPOS",operPositionId)),"^",2)
	.e  s operPosition=""
	.s OPCategory="",OPCategoryId=""
	.i opdr'="" s OPCategoryId=$p($g(^ORC("OPER",opdr)),"^",7)
	.i OPCategoryId'=""  s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
	.s isAddInstrument=$P($G(^DHCANOPArrange(opaId)),"^",31)
	.s instrumentDr=$P($G(^DHCANOPArrange(opaId)),"^",30)
	.i instrumentDr'="" s instrument=$P($G(^DHCANC("Instrument",instrumentDr)),"^",2)
	.e  s instrument=""
	.s patWardId1=$P($G(^DHCANOPArrange(opaId)),"^",32)
	.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,6)=patWardId1_"/"_patWardId
	.i patWardId1'="" s patWard=$P($G(^PAWARD(patWardId1)),"^",2)
	.e  s patWard=""
	.s estiOperDuration=$P($G(^DHCANOPArrange(opaId)),"^",37)
	.i estiOperDuration'="" s estiOperDuration=$ZT(estiOperDuration,2)
	.s preDiscussDate=$P($G(^DHCANOPArrange(opaId)),"^",38)
	.i preDiscussDate'="" s preDiscussDate=$ZD(preDiscussDate,4)
	.s isExCirculation=$P($G(^DHCANOPArrange(opaId)),"^",36)
	.s bloodTypId=$P(^DHCANOPArrange(opaId),"^",11)
	.i (+bloodTypId'=0)&($d(^PAC("BLDT",+bloodTypId))) s bloodType=$P($G(^PAC("BLDT",bloodTypId)),"^",2)
	.e  s bloodType="不详"
	.s opDocNote=$P($G(^DHCANOPArrange(opaId)),"^",42)
	.s anDocNote=$P($G(^DHCANOPArrange(opaId)),"^",43)
	.s opSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)
	.s AnaesthesiaID=$P($G(^DHCANOPArrange(opaId)),"^",2)
	.s retReasonId=$P($G(^DHCANOPArrange(opaId)),"^",35)
	.i opaStatus'="D" s retReasonId=""	;20120613+dyl
	.i retReasonId'=""  s retReason=$p(^ORC("SUSP",retReasonId),"^",2)   //+ ck091212 手术拒绝原因
	.e  s retReason=""
	.s anaDoctorOrd=$p($G(^DHCANOPArrange(opaId)),"^",48)     	//+ ck091212 麻醉医生收费状态
	.i anaDoctorOrd="Y"  s anaDoctorOrd="Y"
	.e  s anaDoctorOrd="N"
	.i $g(^tmpAnop("Anop"))="Y" s ^tmpAnop("Anop",opaId,7)=paidType_"/"_anaDoctorOrd_"/"_LogUserType
	.s anaNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",49)      	//+ ck091212 麻醉护士收费状态
	.i anaNurseOrd="Y"  s anaNurseOrd="Y"
	.e  s anaNurseOrd="N"
	.s opNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",50)       	//+ ck091212 手术护士收费状态
	.i opNurseOrd="Y"  s opNurseOrd="Y"
	.e  s opNurseOrd="N"
	.s tPacuBedId=$P($G(^DHCANOPArrange(opaId)),"^",47)		 	//OPA_PacuBed_Dr	麻醉恢复床
	.i tPacuBedId'="" s tPacuBed=$p(^DHCANC("OPRoom",tPacuBedId),"^",2)
	.e  s tPacuBed=""
	.s PACUInDate=$P($G(^DHCANOPArrange(opaId,"PACU")),"^",6) 	//OPA_PACUInDate	入恢复室日期
	.i PACUInDate'="" s PACUInDate=$zd(PACUInDate,3)
	.s PACUInTime=$P($G(^DHCANOPArrange(opaId,"PACU")),"^",7) 	//OPA_PACUInTime	入恢复室时间
	.i PACUInTime'="" s PACUInTime=$zt(PACUInTime)
	.s PACUInDateTime=PACUInDate_" "_PACUInTime
	.i sortOpRoomDesc="" s sortOpRoomDesc=0
	.i sortOpaSeq<10 s sortOpaSeq=0_sortOpaSeq
	.s opaSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)	//OPA_SeqNote
	.s appLocId=$P($G(^DHCANOPArrange(opaId)),"^",54)	//OPA_AppLoc_Dr
	.s appLocDesc=$P($G(^CTLOC(+appLocId)),"^",2)
	.s tDocArriveTime=$P(^DHCANOPArrange(opaId),"^",46)
	.i tDocArriveTime'="" s tDocArriveTime=##class(web.DHCANOPCom).ConvertToTime(tDocArriveTime)
	.s ^DHCVISOpSchTemp($j,oproomdes,opordno,opaId)=mzdoc_"<br/>"_$G(opd)_"<br/>"_status_"<br/>"_opdes_"<br/>"_locdes_"<br/>"_patName_"<br/>"_opordno_"<br/>"_oproomdes
    s ShowNum=0
    s oproomdes=""  f  s oproomdes=$o(^DHCVISOpSchTemp($j,oproomdes)) q:oproomdes=""  d
    .s opordno=""  f  s opordno=$o(^DHCVISOpSchTemp($j,oproomdes,opordno)) q:opordno=""  d
    ..s j="" f  s j=$o(^DHCVISOpSchTemp($j,oproomdes,opordno,j)) q:j=""  d
    ...s ShowNum=ShowNum+1
    ...s ^DHCVISOpSchTemp("Sort",ShowNum)=^DHCVISOpSchTemp($j,oproomdes,opordno,j)
    //正确带循环，同步屏方法
   	s RetStr="",RetStrone=""
    s ShowNum=1
    s Index=$G(^DHCVISOpSchTemp("Index"))
    f  s Index=$O(^DHCVISOpSchTemp("Sort",Index)) q:(Index="")||(ShowNum>MaxShowRows)  d
    .s OneData=$G(^DHCVISOpSchTemp("Sort",Index))
    .i RetStr="" s RetStr=OneData
    .e  s RetStr=OneData_"<br/>"_RetStr
    .s ShowNum=ShowNum+1
    s ^DHCVISOpSchTemp("Index")=Index-1
   	k ^DHCVISOpSchTemp("Sort")
   	k ^DHCVISOpSchTemp($j)
    i RetStr'="" d
	.i $l(RetStr,"<br/>")'=48 d
	..s $p(RetStrone,"<br/>",(49-$l(RetStr,"<br/>")))="" 
	..s RetStr=RetStrone_RetStr_"<br/>麻师<br/>主刀<br/>状态<br/>术称<br/>科别<br/>患者名<br/>台次<br/>手术室"
	.e  s RetStr=RetStr_"<br/>麻师<br/>主刀<br/>状态<br/>术称<br/>科别<br/>患者名<br/>台次<br/>手术室"
	e  s $p(RetStr,"<br/>",56)=""
    s TableStr="areaid=queueinfo&areatype=queue&dataid="_dataIndex_"&data="
	s RetStr=TableStr_RetStr
    q RetStr
}

}
