Class ABN.dao.DHCNurCureRec Extends %RegisteredObject
{

Query FindByPatientID(PatientID, StDate, EndDate, Flag) As websys.Query(ROWSPEC = "ID, CureAttainDoseDate,CureStdate,FineRate,InterValDays,PapmiID,Prescription,ProtectDose,Scheme")
{
}

/// , RegNo As %String, Name As %String
/// d ##class(%ResultSet).RunQuery("ABN.dao.DHCNurCureRec","FindByPatientID","","01/07/2012","01/07/2012","")
ClassMethod FindByPatientIDExecute(ByRef qHandle As %Binary, PatientID, StDate, EndDate, Flag) As %Status
{
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		s ^Temp("wanghc","ABN.dao.DHCNurCureRec","FindByPatientID")=PatientID_","_ StDate_","_ EndDate_","_ Flag
		;if (RegNo="")&&(Name="") set qHandle = $lb(0,repid,0) 	Q $$$OK
		;s PapmiID=""
		;if RegNo'=""{
		;		s RegNo=$$ALPHAUP^SSUTIL4(RegNo)
		;		s PapmiID=$o(^PAPERi("PAPMI_PatNo",RegNo,0))					
		;;	}elseif (Name'=""){
		;		s Name = $$ALPHAUP^SSUTIL4(Name)
		;;		s PapmiID=$o(^PAPERi("PAPER_PatName",Name,0))
		;	}
		;if (PatientID="") set qHandle = $lb(0,repid,0) 	Q $$$OK
		s:StDate="" StDate=$zd(+$h,4),EndDate=$zd(+$h,4)
		i ($l(StDate,"/")=3) s StDate = $zdh(StDate,4),EndDate=$zdh(EndDate,4)
		b
		f CureStdateIndex = StDate:1:EndDate d
		.s ID=0
		.for  s ID=$o(^ABN.DHCNurCureRecI("CureStdateIndex",CureStdateIndex,ID)) q:ID=""  d
		..s obj = ##class(ABN.DHCNurCureRec).%OpenId(ID)
		..b
		..s CureAttainDoseDate = obj.CureAttainDoseDate
		..s:CureAttainDoseDate'="" CureAttainDoseDate=$zd(CureAttainDoseDate,3) 
		..s CureStdate = CureStdateIndex ;obj.CureStdate
		..s PapmiID = obj.PapmiID
		..q:(EndDate'="")&&(CureStdate>EndDate)
		..q:(StDate'="")&&(CureStdate<StDate)
		..q:(PatientID'="")&&(PapmiID'=PatientID)
		..s:CureStdate'="" CureStdate=$zd(CureStdate,3)	
		..s FineRate=obj.FineRate
		..s InterValDays=obj.InterValDays
		..s Prescription=obj.Prescription
		..s Prescription=##class(web.DHCDocAllergyCureIng).GetIngInfo(Prescription)
		..s ProtectDose=obj.ProtectDose
		..s Scheme=obj.Scheme
		..s ind = ind+1
		..s ^CacheTemp(repid,ind) = $lb(ID, CureAttainDoseDate,CureStdate,FineRate,InterValDays,PapmiID,Prescription,ProtectDose,Scheme)
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

ClassMethod Delete(ID)
{
	s $zt="ERROR"
	s obj = ##class(ABN.DHCNurCureRec).%DeleteId(ID)
	q "0^"_ID
ERROR 
	S ^Temp("wanghc","DHCNurCureRec","Delete")=$ze
	s $ze=""
	q "-1^后台出错!"
}

ClassMethod Save(reqJson)
{
	q ##class(ABN.dao.DHCDocAllergyInterface).Save(reqJson,"ABN.DHCNurCureRec",4)
 	/*s ^Temp("wanghc","save","ABN.dao.DHCNurCureRec")=reqJson
	s $zt="ERROR"
	q:reqJson="" "-306"
	s jsonObj = ##class(ext.util.JsonObject).%New()
	s jsonObj.ContainNullValue=1	//删除属性值时用到
	s jsonObj.DateFormat=4
	d jsonObj.FromObject(reqJson)
	#dim obj As ABN.DHCNurCureRec
	s obj = jsonObj.Bean("ABN.DHCNurCureRec")	
	d jsonObj.%Close()
	s jsonObj=""
	s sc = obj.%Save()	
	If $$$ISERR(sc) Quit "-306^"_sc		
	s id = obj.%Id() 
	d obj.%Close()
	s obj = ""	
	b
	q 0_"^"_id
ERROR 
	S ^Temp("wanghc","DHCNurCureRec","Save")=$ze
	s $ze=""
	q "-1^后台出错!"*/
}

Query FindPatientByReg(PatientNO As %String) As websys.Query(ROWSPEC = "PatientNO,PAPMI,PAPMIName:%String:姓名,PAPMIDOB:%String:出生日期,PAPMIAge:%String:年龄,PAPMISex:%String:性别")
{
}

/// d ##class(%ResultSet).RunQuery("ABN.dao.DHCNurCureRec","FindPatientByReg","1577619")
ClassMethod FindPatientByRegExecute(ByRef qHandle As %Binary, PatientNO As %String) As %Status
{
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		s ^Temp("wanghc","FindPatientByReg")=PatientNO
		if (PatientNO="") set qHandle = $lb(0,repid,0) 	Q $$$OK		
		Set PAPMI=$O(^PAPERi("PAPMI_PatNo",PatientNO,""))
		if $g(PAPMI)="" set qHandle = $lb(0,repid,0) 	Q $$$OK
		b
		set str = ^PAPER(PAPMI,"ALL")
		Set PAPMIName=$P(str,"^",1)
		Set DobDate=$P(str,"^",6)
		If DobDate'="" Do
		.Set PAPMIDOB=$ZD($P(str,"^",6),3)
		.Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
		Else  Set PAPMIDOB="",PAPMIAge=""
		Set Sex=$P(str,"^",7)
		Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
		s ind = ind+1
		s ^CacheTemp(repid,ind) = $lb(PatientNO,PAPMI,PAPMIName,PAPMIDOB,PAPMIAge,PAPMISex)
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

/// w ##class(ABN.dao.DHCNurCureRec).GetPatientInfo(6)
ClassMethod GetPatientInfo(ID)
{
	s obj = ##class(ABN.DHCNurCureRec).%OpenId(ID,0)
	s papmi = obj.PapmiID
	s Name = $p(^PAPER(papmi,"ALL"),"^",1)
	s Reg  = $p(^PAPER(papmi,"PAT",1),"^",2)
	s obj = ""
	q Name_"^"_Reg
}

/// w ##class(ABN.dao.DHCNurCureRec).GetInfo(6)
ClassMethod GetInfo(ID)
{
	s ^Temp("wanghc","ABN.dao.DHCNurCureRec","GetInfo")=ID
	s obj = ##class(ABN.DHCNurCureRec).%OpenId(ID,0)
	s papmi = obj.PapmiID
	s Name = $p(^PAPER(papmi,"ALL"),"^",1)
	s Reg  = $p(^PAPER(papmi,"PAT",1),"^",2)
	s jsonObj = ##class(ext.util.JsonObject).%New()
	s jsonObj.DateFormat=4
	d jsonObj.Put("PapmiID",papmi)
	d jsonObj.Put("Name",Name)
	d jsonObj.Put("Reg",Reg)
	s Prescription = obj.Prescription
	;if (Perscription=$p(^DHCDocConfig("PrescriptionArcim"),"^",1)){
	;	d jsonObj.Put("PrescriptionLU","起始量")
	;}elseif(Perscription=$p(^DHCDocConfig("PrescriptionArcim"),"^",2)){
	;	d jsonObj.Put("PrescriptionLU","维持量")
	;}else{
	d jsonObj.Put("PrescriptionLU",##class(web.DHCDocAllergyCureIng).GetIngInfo(Prescription))
	;}
	s json = jsonObj.FromObject(obj).Json()
	s ^Temp("wanghc","GetInfo")=json
	q json
}

ClassMethod GetInfoProxy(jsFun, ID)
{
	s json = ..GetInfo(ID)
	s rtn = jsFun_"("_json_")"
	&javascript<#(rtn)#>
	q ""
}

}
