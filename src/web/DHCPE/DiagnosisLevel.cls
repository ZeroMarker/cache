Import SQLuser

/// creat by zhouli
/// 医生诊断级别维护
/// 组件：DHCPEDiagnosisLevel
Class web.DHCPE.DiagnosisLevel Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query LevelAll() As %SQLQuery(ROWSPEC = "TRowID:%String,TLevel:%String,TDesc:%String")
{
	select EDC_RowId,EDC_Code,EDC_Desc 

	from DHC_PE_EDClass order by EDC_Code
}

ClassMethod Insert(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
   s level=$p(InString,"^",1)
   s Desc=$p(InString,"^",2)
   s WarnFlag=$p(InString,"^",3)
   q:$d(^DHCPEEDC(0,"Desc",Desc)) "-1^描述重复"
   q:$d(^DHCPEEDC(0,"Code",level)) "-1^级别重复"


  &sql(insert into DHC_PE_EDClass(EDC_Code, EDC_Desc)

	     values (:level,:Desc))
 
   i SQLCODE=0  d
   .s RowID=%ROWID
   .s ^DHCPEDataEx("DHCPEDiagnosisLevel",RowID)=WarnFlag
	Q SQLCODE
}

ClassMethod Update(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
  s rowid=$p(InString,"^",1)

   s level=$p(InString,"^",2)

   s Desc=$p(InString,"^",3)
   s WarnFlag=$p(InString,"^",4)
   
   s DescRowid=$o(^DHCPEEDC(0,"Desc",Desc,0))
   s LevelRowid=$o(^DHCPEEDC(0,"Code",level,0))
   q:$d(^DHCPEEDC(0,"Desc",Desc))&&(DescRowid'=rowid) "-1^该描述已存在"
   q:$d(^DHCPEEDC(0,"Code",level))&&(LevelRowid'=rowid) "-1^该级别已存在"

   &sql(update DHC_PE_EDClass set EDC_Code =:level,EDC_Desc =:Desc where EDC_RowId=:rowid)
   i SQLCODE=0  d

   .s ^DHCPEDataEx("DHCPEDiagnosisLevel",rowid)=WarnFlag
	Q SQLCODE
}

// }

ClassMethod Delete(InString As %Library.String = "")
{
  s rowid=$p(InString,"^",1)
   S EDCRID=$O(^DHCPEEDCR(0,"EDCDR",rowid,0))
  q:EDCRID'="" "-1^该建议级别在专家建议中有使用,需要先取消建议关联的级别,然后删除"
	 &sql(

		delete from DHC_PE_EDClass 

		where EDC_RowId=:rowid

	     )
	   i SQLCODE=0  d
    .s RowID=%ROWID
   .k ^DHCPEDataEx("DHCPEDiagnosisLevel",RowID)
	Q SQLCODE
}

ClassMethod DiagnosisLevel(ContrlWidth As %String = "") As %String
{
	
	s:(""=ContrlWidth) ContrlWidth="290"
	w "<select name='DiagnosisLevel' id='DiagnosisLevel' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>  </option>",!
	s Code=""
	f  s Code=$O(^DHCPEEDC(0,"Code",Code)) q:Code=""  d
	.s EDCRowId=0
	.f  s EDCRowId=$o(^DHCPEEDC(0,"Code",Code,EDCRowId)) q:EDCRowId=""  d  
	..w "<option value='"_EDCRowId_"'>"_$P($g(^DHCPEEDC(EDCRowId)),"^",2)_"</option>",!
	w "</select>",!
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.DiagnosisLevel","FindWarnInfo","","","")

Query FindWarnInfo(DateFrom As %Library.String = "", DateTo As %Library.String = "", ILLLevel As %Library.String = "") As %Query(ROWSPEC = "TLevel:%String, TPatRegNo:%String, TPatName:%String,TPatSex:%String, TPatAge:%String, TRegDate:%String")
{
}

ClassMethod FindWarnInfoExecute(ByRef qHandle As %Binary, DateFrom As %Library.String = "", DateTo As %Library.String = "", ILLLevel As %Library.String = "") As %Status
{


	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 
    k ^DHCPETMPWarmLevel
    s GSED=0
    f  s GSED=$o(^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",GSED))  q:GSED=""  d
    .s LevelRowid=$g(^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",GSED))
    .q:$g(^DHCPEDataEx("DHCPEDiagnosisLevel",LevelRowid))'="Y"
    .q:(ILLLevel'="")&&(ILLLevel'=LevelRowid)
    .s IADM=$P(^DHCPEGS($P(GSED,"||",1),1),"^",1)
    .s RegDate=$P(^DHCPEIADM(IADM),"^",5)
    .q:(DateFrom'="")&&(DateFrom>RegDate)
    .q:(DateTo'="")&&(DateTo<RegDate)
    .s LevelCode=$P($g(^DHCPEEDC(LevelRowid)),"^",1)
    .s LevelDesc=$P($g(^DHCPEEDC(LevelRowid)),"^",2)
    .s Level=LevelCode_""_LevelDesc
    .i $g(^DHCPETMPWarmLevel("LASTIADM"))'=IADM   d
    ..s LevelStr=Level
    .else  d 
    ..i LevelStr'[Level s LevelStr=LevelStr_";"_Level
    .s ^DHCPETMPWarmLevel("LASTIADM")=IADM
    .s ^DHCPETMPWarmLevel("IADM",IADM)=LevelStr

 .
    
    s IADMRowID=0
    f  s IADMRowID=$O(^DHCPETMPWarmLevel("IADM",IADMRowID))  Q:IADMRowID=""  d
    .s Str=$g(^DHCPETMPWarmLevel("IADM",IADMRowID))
    .s PIADM=$P(^DHCPEIADM(IADMRowID),"^",4)
    .q:PIADM=""
    .s RegDate=$zd($P(^DHCPEIADM(IADMRowID),"^",5),3)
    .s PIBIDR=$P(^DHCPEPreIADM(PIADM),"^",1)
    .q:PIBIDR=""  
    .s RegNo=$p(^DHCPEPreIBI(PIBIDR),"^",1)
    .s Name=$p(^DHCPEPreIBI(PIBIDR),"^",2)
    .s SexDR=$p(^DHCPEPreIBI(PIBIDR),"^",3)
    .s SexDesc=""
    .i SexDR'=""  s SexDesc=$p(^CT("SEX",SexDR),"^",2)
    .s DOB=$p(^DHCPEPreIBI(PIBIDR),"^",4)
    .s Age=""
 	.s:(""'=DOB) Age=##class(web.DHCLCNUREXCUTE).CalAge(DOB,+$h)
 	.s Age=$P(Age,"Y")
	.d OutWarnInfo

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWarnInfo
			   
	set Data=$lb(Str, RegNo, Name,SexDesc,Age,RegDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWarnInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWarnInfoExecute ]
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

ClassMethod FindWarnInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWarnInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
