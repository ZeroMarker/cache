Class User.DHCNurMedTourRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCNurMedTour_ROWID, SqlTableName = DHCNur_MedTourRecord ]
{

/// NurMedTour_ADM_DR  输液巡视病人就诊号
Property NurMedTourADMDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = NurMedTour_ADM_DR ];

/// NurMedTour_PATBed  输液巡视病人床号
Property NurMedTourPATBed As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = NurMedTour_PATBed ];

/// NurMedTour_PATName  输液巡视病人姓名
Property NurMedTourPATName As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = NurMedTour_PATName ];

/// NurMedTour_PATSex  输液巡视病人性别
Property NurMedTourPATSex As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = NurMedTour_PATSex ];

/// NurMedTour_DATE  输液巡视日期
Property NurMedTourDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = NurMedTour_DATE ];

/// NurMedTour_TIME  输液巡视时间
Property NurMedTourTIME As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = NurMedTour_TIME ];

/// NurMedTour_ItmMast_DR  贴瓶签医嘱ARCIM ROWID
Property NurMedTourItmMastDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = NurMedTour_ItmMast_DR ];

/// NurMedTour_USR_DR   输液巡视人
Property NurMedTourUSRDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = NurMedTour_USR_DR ];

/// NurMedTour_CTLOC_DR  输液巡视患者所在科室
Property NurMedTourCTLOCDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = NurMedTour_CTLOC_DR ];

/// NurMedTour_Med_Deal  输液巡视处理
Property NurMedTourMedDeal As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = NurMedTour_Med_Deal ];

/// NurMedTour_Med_Situation  输液巡视情况
Property NurMedTourMedSituation As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = NurMedTour_Med_Situation ];

/// NurMedTour_Med_BarCodeDr  输液巡视执行医嘱ID(ORD_EXEC)
Property NurMedTourMedBarCodeDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = NurMedTour_Med_BarCodeDr ];

/// 病人就诊号索引
Index NurMedTourADMDRRIndex On NurMedTourADMDR;

/// 病人巡视日期索引
Index NurMedTourDATEIndex On NurMedTourDATE;

/// 输液巡视人索引
Index NurMedTourUSRDRIndex On NurMedTourUSRDR;

/// 输液巡视医嘱索引
Index NurMedTourItmMastDRIndex On NurMedTourItmMastDR;

/// 输液巡视日期人索引
Index NurMedTourDATEUSRDRIndex On (NurMedTourDATE, NurMedTourUSRDR);

/// 输液巡视就诊号日期索引
Index NurMedTourADMDRDATEIndex On (NurMedTourADMDR, NurMedTourDATE);

/// 输液巡视日期医嘱索引
Index NurMedTourDATEItmMastDRIndex On (NurMedTourDATE, NurMedTourItmMastDR);

ClassMethod Insert(NurMedTourADMDR As %String, NurMedTourPATBed As %String, NurMedTourPATName As %String, NurMedTourPATSex As %String, NurMedTourDATE As %Library.Date, NurMedTourTIME As %Library.Time, NurMedTourItmMastDR As %String, NurMedTourUSRDR As %String, NurMedTourCTLOCDR As %String, NurMedTourMedDeal As %String, NurMedTourMedSituation As %String, BarCodeDr As %String) As %String
{
	/*s a=##class(DHCADMNurseRecord).%New()
	s a.NurRecADMDR=NurRecADMDR
	s a.NurRecPATBed=NurRecPATBed
	s a.NurRecPATName=NurRecPATName
	s a.NurRecPATSex=NurRecPATSex
	s a.NurRecDATE=NurRecDATE
	s a.NurRecTIME=NurRecTIME
	s a.NurRecTYPDR=NurRecTYPDR
	s a.NurRecItmMastDR=NurRecItmMastDR
	s a.NurRecUSRDR=NurRecUSRDR
	d a.%Save()
	i a.%Id()="" s ret=1
	e  s ret=0*/
	k PLIST
	s PLIST(2)=NurMedTourADMDR
	s PLIST(3)=NurMedTourPATBed
	s PLIST(4)=NurMedTourPATName
	s PLIST(5)=NurMedTourPATSex
	s PLIST(6)=NurMedTourDATE
	s PLIST(7)=NurMedTourTIME
	s PLIST(8)=NurMedTourItmMastDR
	s PLIST(9)=NurMedTourUSRDR
	s PLIST(10)=NurMedTourCTLOCDR
	s PLIST(11)=NurMedTourMedDeal
	s PLIST(12)=NurMedTourMedSituation
	s PLIST(13)=BarCodeDr
	&sql(insert into DHCNur_MedTourRecord Values PLIST())
	i 'SQLCODE d  q ..SELECT(%ROWID)
	q SQLCODE
	//q ret
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHCNur_MedTourRecord WHERE DHCNurMedTour_ROWID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod GetNurMedTourRecord1(StDate, EDate, ConLoc, funname)
{
      //s NurMedTourMedSituation=""
       s StDate=$ZDH(StDate,3),EDate=$ZDH(EDate,3)
	   f CurDate=StDate:1:EDate
    {    s Recordrowid="" f  s Recordrowid=$O(^User.DHCNurMedTourRecordI("NurMedTourDATEIndex",CurDate,Recordrowid)) q:Recordrowid=""  d
	    .s a=^User.DHCNurMedTourRecordD(Recordrowid)
	    .s Recordloc=$listget(a,3)
	    .q:(ConLoc'="")&(ConLoc'=Recordloc)
        .s NurMedTourADMDR=$listget(a,2)
        .s papmi=$P(^PAADM(NurMedTourADMDR),"^",1)
        .s papmino=$p(^PAPER(papmi,"PAT",1),"^",1)
		.s NurMedTourPATBed= $listget(a,8)
		.s NurMedTourPATName=$listget(a,9)
		.s NurMedTourPATSex=$listget(a,10)
		.s NurMedTourDATE=$zd($listget(a,4),3)
		.s NurMedTourTIME=$zt($listget(a,11),1)
		.s NurMedTourItmMastDR=$listget(a,5)
		.s l=$L(NurMedTourItmMastDR,"&")
        . s strparr=""
        . for i=1:1:l  d
		..s str=$p(NurMedTourItmMastDR,"&",i)
		..i str'="" d
		...s strparr=$P(^ARCIM($p(str,"||",1),$p(str,"||",2),1),"^",2)_","_strparr
		.s NurMedTourItmMastDR=strparr
		.s NurMedTourUSRDR=$listget(a,12)
		.S username=$p(^SSU("SSUSR",NurMedTourUSRDR),"^",2) 
		.s NurMedTourUSRDR=username
		.s NurMedTourMedDeal=$listget(a,6)
		.i ($listget(a,7)=$C(0)) d
		..s NurMedTourMedSituation="" 
		.e  d
		..s NurMedTourMedSituation=$listget(a,7)
		.s NurMedTourMedBarCodeDr=$listget(a,13)
		.s requestdate=$zd($p(^OEORD($p(NurMedTourMedBarCodeDr,"|",1),"I",$p(NurMedTourMedBarCodeDr,"|",2),"X",$p(NurMedTourMedBarCodeDr,"|",3)),"^",1),3)  
		.s requesttime=$zt($p(^OEORD($p(NurMedTourMedBarCodeDr,"|",1),"I",$p(NurMedTourMedBarCodeDr,"|",2),"X",$p(NurMedTourMedBarCodeDr,"|",3)),"^",2),1)  
		.s NurMedTourCTLOCDR= $listget(a,3)
		.s locasc=$p(^CTLOC(NurMedTourCTLOCDR),"^" ,2)
		.s NurMedTourCTLOCDR=locasc
		.s rtnval=funname_"('"_$ZCVT($g(NurMedTourADMDR),"O","JS")_"','"_$ZCVT($g(NurMedTourPATBed),"O","JS")_"','"_$ZCVT($g(NurMedTourPATName),"O","JS")_"','"_$ZCVT($g(NurMedTourPATSex),"O","JS")_"','"_$ZCVT($g(NurMedTourDATE),"O","JS")_"','"_$ZCVT($g(NurMedTourTIME),"O","JS")_"','"_$ZCVT($g(NurMedTourItmMastDR),"O","JS")_"','"_$ZCVT($g(NurMedTourUSRDR),"O","JS")_"','"_$ZCVT($g(NurMedTourMedDeal),"O","JS")_"','"_$ZCVT($g(NurMedTourMedSituation),"O","JS")_"','"_$ZCVT($g(NurMedTourMedBarCodeDr),"O","JS")_"','"_$ZCVT($g(NurMedTourCTLOCDR),"O","JS")_"','"_$ZCVT($g(Recordrowid),"O","JS")_"','"_$ZCVT($g(requestdate),"O","JS")_"','"_$ZCVT($g(requesttime),"O","JS")_"','"_$ZCVT($g(papmino),"O","JS")_"');"
	    .&javascript<#(rtnval)#>
	   
    }
     q 0
}

ClassMethod GetNurMedTourRecord(StDate, EDate, ConLoc, person, nurse, funname)
{
      //s NurMedTourMedSituation=""
       s StDate=$ZDH(StDate,3),EDate=$ZDH(EDate,3)
	   f CurDate=StDate:1:EDate
    {    s Recordrowid="" f  s Recordrowid=$O(^User.DHCNurMedTourRecordI("NurMedTourDATEIndex",CurDate,Recordrowid)) q:Recordrowid=""  d
	    .s a=^User.DHCNurMedTourRecordD(Recordrowid)
	    .s Recordloc=$listget(a,3)
	    .q:(ConLoc'="")&(ConLoc'=Recordloc)
        .s NurMedTourADMDR=$listget(a,2)
        .q:(person'="")&(person'=NurMedTourADMDR)
        .s papmi=$P(^PAADM(NurMedTourADMDR),"^",1)
        .s papmino=$p(^PAPER(papmi,"PAT",1),"^",1)
		.s NurMedTourPATBed= $listget(a,8)
		.s NurMedTourPATName=$listget(a,9)
		.s NurMedTourPATSex=$listget(a,10)
		.s NurMedTourDATE=$zd($listget(a,4),3)
		.s NurMedTourTIME=$zt($listget(a,11),1)
		.s NurMedTourItmMastDR=$listget(a,5)
		.s l=$L(NurMedTourItmMastDR,"&")
        . s strparr=""
        . for i=1:1:l  d
		..s str=$p(NurMedTourItmMastDR,"&",i)
		..i str'="" d
		...s strparr=$P(^ARCIM($p(str,"||",1),$p(str,"||",2),1),"^",2)_","_strparr
		.s NurMedTourItmMastDR=strparr
		.s NurMedTourUSRDR=$listget(a,12)
		.S careprov=$p(^SSU("SSUSR",NurMedTourUSRDR),"^",14)
	    .q:(nurse'="")&(nurse'=careprov)
		.S username=$p(^SSU("SSUSR",NurMedTourUSRDR),"^",2) 
		.s NurMedTourUSRDR=username
		.s NurMedTourMedDeal=$listget(a,6)
		.i ($listget(a,7)=$C(0)) d
		..s NurMedTourMedSituation="" 
		.e  d
		..s NurMedTourMedSituation=$listget(a,7)
		.s NurMedTourMedBarCodeDr=$listget(a,13)
		.s requestdate=$zd($p(^OEORD($p(NurMedTourMedBarCodeDr,"|",1),"I",$p(NurMedTourMedBarCodeDr,"|",2),"X",$p(NurMedTourMedBarCodeDr,"|",3)),"^",1),3)  
		.s requesttime=$zt($p(^OEORD($p(NurMedTourMedBarCodeDr,"|",1),"I",$p(NurMedTourMedBarCodeDr,"|",2),"X",$p(NurMedTourMedBarCodeDr,"|",3)),"^",2),1)  
		.s NurMedTourCTLOCDR= $listget(a,3)
		.s locasc=$p(^CTLOC(NurMedTourCTLOCDR),"^" ,2)
		.s NurMedTourCTLOCDR=locasc
		.s rtnval=funname_"('"_$ZCVT($g(NurMedTourADMDR),"O","JS")_"','"_$ZCVT($g(NurMedTourPATBed),"O","JS")_"','"_$ZCVT($g(NurMedTourPATName),"O","JS")_"','"_$ZCVT($g(NurMedTourPATSex),"O","JS")_"','"_$ZCVT($g(NurMedTourDATE),"O","JS")_"','"_$ZCVT($g(NurMedTourTIME),"O","JS")_"','"_$ZCVT($g(NurMedTourItmMastDR),"O","JS")_"','"_$ZCVT($g(NurMedTourUSRDR),"O","JS")_"','"_$ZCVT($g(NurMedTourMedDeal),"O","JS")_"','"_$ZCVT($g(NurMedTourMedSituation),"O","JS")_"','"_$ZCVT($g(NurMedTourMedBarCodeDr),"O","JS")_"','"_$ZCVT($g(NurMedTourCTLOCDR),"O","JS")_"','"_$ZCVT($g(Recordrowid),"O","JS")_"','"_$ZCVT($g(requestdate),"O","JS")_"','"_$ZCVT($g(requesttime),"O","JS")_"','"_$ZCVT($g(papmino),"O","JS")_"');"
	    .&javascript<#(rtnval)#>
	   
    }
     q 0
}

ClassMethod GetDoc(dep, funname) As %String
{
   //s a=##class(User.DHCNurMedTourRecord).GetDoc("869","add")
	s ret=""
	//q:dep="" ""
	if $g(dep)'=""
	{
		s resId="" f  s resId=$O(^RB("RES",0,"CTLOC",dep,resId))  q:resId=""  d
			   .s ctcpId=$P(^RB("RES",resId),"^",2)
			   .q:ctcpId=""
			   .s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
			   .q:ctcptId=""
			   .//s ctcptType=$p(^CT("CPT",ctcptId),"^",4)
			   .//q:(ifDoctor'="")&(ifDoctor="Y")&(ctcptType'="DOCTOR")
		       .//q:(ifDoctor'="")&(ifDoctor'="Y")&(ctcptType'="NURSE")
			   .s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
			   .q:'$d(^SSU("SSUSR",0,"CTPCP",ctcpId))
			   .s rtnval=funname_"('"_$ZCVT($g(ctcpId),"O","JS")_"','"_$ZCVT($g(ctcpDesc),"O","JS")_"');"
	           .&javascript<#(rtnval)#>
	}
	else
	{
		s ctcpId="" f  s ctcpId=$O(^CTPCP(ctcpId))  q:ctcpId=""  d
		.s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
		.q:ctcptId=""
    	.s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
		.q:ctcptInternalType'="DOCTOR"
		.s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
		.q:'$d(^SSU("SSUSR",0,"CTPCP",ctcpId))
		.s rtnval=funname_"('"_$ZCVT($g(ctcpId),"O","JS")_"','"_$ZCVT($g(ctcpDesc),"O","JS")_"');"
	    .&javascript<#(rtnval)#>
	}
}

ClassMethod GetNurMedTourperson(logonLocId, funname)
{
	
	i logonLocId=""  Quit $$$OK
	s WardID=""
	i logonLocId'="" d
	.s logonLocType=$p($g(^CTLOC(logonLocId)),"^",13)
	.i logonLocType="W" d
	..s WardID=$o(^PAWARD(0,"WARD_LocationDR",logonLocId,""))
	.i logonLocType="E" d
	..s chl="" f  s chl=$O(^CTLOC(logonLocId,"LINK",chl)) q:chl=""  d
	...s link=$P(^CTLOC(logonLocId,"LINK",chl),"^",1)
	...s logonLocType=$p($g(^CTLOC(link)),"^",13)
	...i logonLocType="W" s WardID=$o(^PAWARD(0,"WARD_LocationDR",link,"")) 
	q:WardID=""
	s ind=1
	s curRoomId=0 f  s curRoomId=$o(^PAADMi("CurrWard",WardID,curRoomId)) q:curRoomId=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,curRoomId,EpisodeID)) q:EpisodeID=""  d
	..s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	..s patRegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	..s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	..s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
	..q:bedSub=""
	..s curWardId=$P(bedSub,"||",1)
	..s curBedSub=$P(bedSub,"||",2)
	..q:(curWardId="")!(curBedSub="")
	..s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
    ..q:bedCode=""
    ..s tmp(bedCode)=patRegNo_"^"_patName_"^"_bedCode_"^"_EpisodeID //Modify by liulei 20091118
     s no="" f  s no=$o(tmp(no)) q:no=""  d
    .s patRegNo=$P(tmp(no),"^",1)
    .s patName=$P(tmp(no),"^",2)
    .s bedCode=$P(tmp(no),"^",3)
    .s EpisodeID=$P(tmp(no),"^",4)
    .s ret=bedCode_" "_patName_" "_patRegNo
    .s rtnval=funname_"('"_$ZCVT($g(EpisodeID),"O","JS")_"','"_$ZCVT($g(ret),"O","JS")_"');"
	.&javascript<#(rtnval)#>
}

Storage Default
{
<Data name="DHCNurMedTourRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NurMedTourADMDR</Value>
</Value>
<Value name="3">
<Value>NurMedTourCTLOCDR</Value>
</Value>
<Value name="4">
<Value>NurMedTourDATE</Value>
</Value>
<Value name="5">
<Value>NurMedTourItmMastDR</Value>
</Value>
<Value name="6">
<Value>NurMedTourMedDeal</Value>
</Value>
<Value name="7">
<Value>NurMedTourMedSituation</Value>
</Value>
<Value name="8">
<Value>NurMedTourPATBed</Value>
</Value>
<Value name="9">
<Value>NurMedTourPATName</Value>
</Value>
<Value name="10">
<Value>NurMedTourPATSex</Value>
</Value>
<Value name="11">
<Value>NurMedTourTIME</Value>
</Value>
<Value name="12">
<Value>NurMedTourUSRDR</Value>
</Value>
<Value name="13">
<Value>NurMedTourMedBarCodeDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCNurMedTourRecordD</DataLocation>
<DefaultData>DHCNurMedTourRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNurMedTourRecordD</IdLocation>
<IndexLocation>^User.DHCNurMedTourRecordI</IndexLocation>
<StreamLocation>^User.DHCNurMedTourRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
