Class User.DHCADMNurseRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = NurRec_ROWID, SqlTableName = DHC_ADMNurRecord ]
{

/// NurRec_ADM_DR  护理巡视病人就诊号
Property NurRecADMDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = NurRec_ADM_DR ];

/// NurRec_PATBed  护理巡视病人床号
Property NurRecPATBed As %Library.String [ SqlColumnNumber = 3, SqlFieldName = NurRec_PATBed ];

/// NurRec_PATName  护理巡视病人姓名
Property NurRecPATName As %Library.String [ SqlColumnNumber = 4, SqlFieldName = NurRec_PATName ];

/// NurRec_PATSex  护理巡视病人性别
Property NurRecPATSex As %Library.String [ SqlColumnNumber = 5, SqlFieldName = NurRec_PATSex ];

/// NurRec_DATE  护理巡视日期
Property NurRecDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = NurRec_DATE ];

/// NurRec_TIME  护理巡视时间
Property NurRecTIME As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = NurRec_TIME ];

/// NurRec_TYP_DR  护理巡视级别
Property NurRecTYPDR As User.DHCNurLevelTYP [ SqlColumnNumber = 8, SqlFieldName = NurRec_TYP_DR ];

/// NurRec_ItmMast_DR  护理医嘱ARCIM ROWID
Property NurRecItmMastDR As %Library.String [ SqlColumnNumber = 9, SqlFieldName = NurRec_ItmMast_DR ];

/// NurRec_USR_DR   护理巡视人
Property NurRecUSRDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = NurRec_USR_DR ];

/// NurRec_CTLOC_DR   护理巡视患者所在科室
Property NurRecCTLOCDR As %Library.String [ SqlColumnNumber = 11, SqlFieldName = NurRec_CTLOC_DR ];

/// 病人就诊号索引
Index NurRecADMDRIndex On NurRecADMDR;

/// 病人巡视日期索引
Index NurRecDATEIndex On NurRecDATE;

/// 护理巡视级别索引
Index NurRecTYPDRIndex On NurRecTYPDR;

/// 护理巡视人索引
Index NurRecUSRDRIndex On NurRecUSRDR;

/// 护理巡视医嘱索引
Index NurRecItmMastDRIndex On NurRecItmMastDR;

/// 护理巡视日期级别索引
Index NurRecDATETYPDRIndex On (NurRecDATE, NurRecTYPDR);

/// 护理巡视日期人索引
Index NurRecDATEUSRDRIndex On (NurRecDATE, NurRecUSRDR);

/// 护理巡视就诊号日期索引
Index NurRecADMDRDATEIndex On (NurRecADMDR, NurRecDATE);

/// 护理巡视日期医嘱索引
Index NurRecDATEItmMastDRIndex On (NurRecDATE, NurRecItmMastDR);

ClassMethod Insert(NurRecADMDR As %String, NurRecPATBed As %String, NurRecPATName As %String, NurRecPATSex As %String, NurRecDATE As %Library.Date, NurRecTIME As %Library.Time, NurRecTYPDR As %String, NurRecItmMastDR As %String, NurRecUSRDR As %String, NurRecCTLOCDR As %String) As %String
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
	s PLIST(2)=NurRecADMDR
	s PLIST(3)=NurRecPATBed
	s PLIST(4)=NurRecPATName
	s PLIST(5)=NurRecPATSex
	s PLIST(6)=NurRecDATE
	s PLIST(7)=NurRecTIME
	s PLIST(8)=NurRecTYPDR
	s PLIST(9)=NurRecItmMastDR
	s PLIST(10)=NurRecUSRDR
	s PLIST(11)=NurRecCTLOCDR
	&sql(insert into DHC_ADMNurRecord Values PLIST())
	i 'SQLCODE d  q ..SELECT(%ROWID)
	q SQLCODE
	//q ret
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_ADMNurRecord WHERE NurRec_ROWID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod GetDHCADMNurseRecord1(StDate, EDate, ConLoc, funname)
{
      //s NurMedTourMedSituation=""
       s StDate=$ZDH(StDate,3),EDate=$ZDH(EDate,3)
	   
	   f CurDate=StDate:1:EDate
    {   
         s Recordrowid="" f  s Recordrowid=$O(^User.DHCADMNurseRecordI("NurRecDATEIndex",CurDate,Recordrowid)) q:Recordrowid=""  d
	    .s a=^User.DHCADMNurseRecordD(Recordrowid)
	    .s NurRecCTLOCDR=$listget(a,11)
	    .q:(ConLoc'="")&(ConLoc'=NurRecCTLOCDR)
        .s NurRecADMDR=$listget(a,2)
        .s papmi=$P(^PAADM(NurRecADMDR),"^",1)
        .s papmino=$p(^PAPER(papmi,"PAT",1),"^",1)
	    .S NurRecPATBed=$listget(a,8)
	    .S NurRecPATName=$listget(a,9)
	    .S NurRecPATSex=$listget(a,10)
	    .S NurRecDATE=$zd($listget(a,3),3)
	    .S NurRecTIME=$zt($listget(a,4),1)
	    .S NurRecTYPDR=$listget(a,5)
	    .S NurRecItmMastDR=$listget(a,6)
	    .S NurRecItmMastDR=$P(^ARCIM($p(NurRecItmMastDR,"||",1),$p(NurRecItmMastDR,"||",2),1),"^",2)
	    .S NurRecUSRDR=$listget(a,7)
	    .S username=$p(^SSU("SSUSR",NurRecUSRDR),"^",2)
	    .S NurRecUSRDR=username
	    .s locasc=$p(^CTLOC(NurRecCTLOCDR),"^" ,2)
		.s NurRecCTLOCDR=locasc	
		.s rtnval=funname_"('"_$ZCVT($g(NurRecADMDR),"O","JS")_"','"_$ZCVT($g(papmino),"O","JS")_"','"_$ZCVT($g(NurRecPATBed),"O","JS")_"','"_$ZCVT($g(NurRecPATName),"O","JS")_"','"_$ZCVT($g(NurRecPATSex),"O","JS")_"','"_$ZCVT($g(NurRecDATE),"O","JS")_"','"_$ZCVT($g(NurRecTIME),"O","JS")_"','"_$ZCVT($g(NurRecTYPDR),"O","JS")_"','"_$ZCVT($g(NurRecItmMastDR),"O","JS")_"','"_$ZCVT($g(NurRecUSRDR),"O","JS")_"','"_$ZCVT($g(NurRecCTLOCDR),"O","JS")_"','"_$ZCVT($g(Recordrowid),"O","JS")_"');"
	    .&javascript<#(rtnval)#>
	   
    }
     q 0
}

ClassMethod GetDHCADMNurseRecord(StDate, EDate, ConLoc, person, nurse, funname)
{
      //s NurMedTourMedSituation=""
       s StDate=$ZDH(StDate,3),EDate=$ZDH(EDate,3)
	   
	   f CurDate=StDate:1:EDate
    {   
         s Recordrowid="" f  s Recordrowid=$O(^User.DHCADMNurseRecordI("NurRecDATEIndex",CurDate,Recordrowid)) q:Recordrowid=""  d
	    .s a=^User.DHCADMNurseRecordD(Recordrowid)
	    .s NurRecCTLOCDR=$listget(a,11)
	    .q:(ConLoc'="")&(ConLoc'=NurRecCTLOCDR)
        .s NurRecADMDR=$listget(a,2)
        .q:(person'="")&(person'=NurRecADMDR)
        .s papmi=$P(^PAADM(NurRecADMDR),"^",1)
        .s papmino=$p(^PAPER(papmi,"PAT",1),"^",1)
	    .S NurRecPATBed=$listget(a,8)
	    .S NurRecPATName=$listget(a,9)
	    .S NurRecPATSex=$listget(a,10)
	    .S NurRecDATE=$zd($listget(a,3),3)
	    .S NurRecTIME=$zt($listget(a,4),1)
	    .S NurRecTYPDR=$listget(a,5)
	    .S NurRecItmMastDR=$listget(a,6)
	    .S NurRecItmMastDR=$P(^ARCIM($p(NurRecItmMastDR,"||",1),$p(NurRecItmMastDR,"||",2),1),"^",2)
	    .S NurRecUSRDR=$listget(a,7)
	    .S careprov=$p(^SSU("SSUSR",NurRecUSRDR),"^",14)
	    .q:(nurse'="")&(nurse'=careprov)
	    .S username=$p(^SSU("SSUSR",NurRecUSRDR),"^",2)
	    .S NurRecUSRDR=username
	    .s locasc=$p(^CTLOC(NurRecCTLOCDR),"^" ,2)
		.s NurRecCTLOCDR=locasc	
		.s rtnval=funname_"('"_$ZCVT($g(NurRecADMDR),"O","JS")_"','"_$ZCVT($g(papmino),"O","JS")_"','"_$ZCVT($g(NurRecPATBed),"O","JS")_"','"_$ZCVT($g(NurRecPATName),"O","JS")_"','"_$ZCVT($g(NurRecPATSex),"O","JS")_"','"_$ZCVT($g(NurRecDATE),"O","JS")_"','"_$ZCVT($g(NurRecTIME),"O","JS")_"','"_$ZCVT($g(NurRecTYPDR),"O","JS")_"','"_$ZCVT($g(NurRecItmMastDR),"O","JS")_"','"_$ZCVT($g(NurRecUSRDR),"O","JS")_"','"_$ZCVT($g(NurRecCTLOCDR),"O","JS")_"','"_$ZCVT($g(Recordrowid),"O","JS")_"');"
	    .&javascript<#(rtnval)#>
	   
    }
     q 0
}

Storage Default
{
<Data name="DHCADMNurseRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NurRecADMDR</Value>
</Value>
<Value name="3">
<Value>NurRecPATBed</Value>
</Value>
<Value name="4">
<Value>NurRecPATName</Value>
</Value>
<Value name="5">
<Value>NurRecPATSex</Value>
</Value>
<Value name="6">
<Value>NurRecDATE</Value>
</Value>
<Value name="7">
<Value>NurRecTIME</Value>
</Value>
<Value name="8">
<Value>NurRecTYPDR</Value>
</Value>
<Value name="9">
<Value>NurRecItmMastDR</Value>
</Value>
<Value name="10">
<Value>NurRecUSRDR</Value>
</Value>
<Value name="11">
<Value>NurRecCTLOCDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCADMNurseRecordD</DataLocation>
<DefaultData>DHCADMNurseRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCADMNurseRecordD</IdLocation>
<IndexLocation>^User.DHCADMNurseRecordI</IndexLocation>
<StreamLocation>^User.DHCADMNurseRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
