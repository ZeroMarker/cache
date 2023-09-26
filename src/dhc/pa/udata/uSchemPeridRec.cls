/// 基层科室绩效考核结果审核
/// creator:赵伟
/// date：2015-05
Class dhc.pa.udata.uSchemPeridRec Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// others:w ##class(dhc.pa.udata.uSchemPeridRec).List(0,25,"","1","Q","201502","","")
/// others:w ##class(dhc.pa.udata.uSchemPeridRec).ListFinal(0,25,"","1","","","10","")
ClassMethod List(start, limit, sysdr, userdr, frequency, period, myresult, schemedr) As %String
{
	n (start,limit,sysdr,userdr,frequency,period,myresult,schemedr)

	i userdr="" s userdr=0
	s sqlStr="SELECT b.Schem_rowid FROM dhc_pa_data.Schem b  WHERE b.Schem_rowid IN  (SELECT DISTINCT isa.SAudit_SchemDr FROM  dhc_pa_data.SchemAudit isa,dhc_pa_data.Schem isc  WHERE isa.SAudit_SchemDr=isc.Schem_rowid and isc.Schem_level=1 AND isa.SAudit_userDr ="_userdr_") AND b.Schem_parRef=(SELECT Stratagem_rowid FROM dhc_pa_data.Stratagem WHERE Stratagem_currStratagem='Y') "
	i schemedr'="" s sqlStr=sqlStr_" and b.Schem_rowid like '"_schemedr_"'"
	s fatherschemedr=""
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	While(result.Next())
	{
	s rowid= result.Data("Schem_rowid")
	s fatherschemedr=fatherschemedr_","_rowid
	}

	d result.Close()

	
	s fatherschemedr=$E(fatherschemedr,2,$l(fatherschemedr))
	//w "fatherschemedr"_fatherschemedr,!
	//s sysdr=2
	s sqlStr="SELECT DISTINCT c.SPR_rowid,c.SPR_period,c.SPR_auditDr,c.SPR_auditState,c.SPR_Desc,c.SPR_auditDate,a.Schem_rowid,a.Schem_code,a.Schem_name,a.Schem_frequency,a.Schem_UpSchemDr,d.SCM_DeptDr "
	_" FROM dhc_pa_data.Schem a left join dhc_pa_data.Schem_Perid_Rec c on a.Schem_rowid=c.SPR_schemDr left join  dhc_pa_data.schem_Group d on d.SCM_SchemDR =a.Schem_rowid "
	_" WHERE a.Schem_UpSchemDr IS NOT NULL   "

	
	s whereStr=""
	
	i sysdr'="" s whereStr=whereStr_" AND c.SPR_appSysDr="_sysdr
	i frequency'="" s whereStr=whereStr_" AND a.Schem_frequency='"_frequency_"'"
	i period'="" s whereStr=whereStr_" AND c.SPR_period like '%"_period_"%'"
	i myresult=0 {s whereStr=whereStr_" AND (c.SPR_auditState = "_myresult_" or c.SPR_auditState is null )"}
	elseif myresult'="" {s whereStr=whereStr_" AND c.SPR_auditState = "_myresult_""}
	
	s sqlStr=sqlStr_whereStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	;s ^hhghjtemp = sqlStr
	//w sqlStr,!
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^yearid^period^auditdr^auditstate^desc^auditdate^srowid^code^name^frequency^upschemdr^GroupDr^changedperiod"
	While(result.Next())
	{
	s rowid= result.Data("SPR_rowid")
	s period= result.Data("SPR_period")
	
	s yearperiod=$e(period,1,4)
    &sql(select Cycle_rowid into :yearid from dhc_pa_data.Cycle where Cycle_active='Y' and Cycle_code=:yearperiod)
    
	s auditdr= result.Data("SPR_auditDr")
	s auditstate= result.Data("SPR_auditState")
	i auditstate="" s auditstate=0
	i auditstate=0 s auditstate="未提交"
	i auditstate=10 s auditstate="审核未通过"
	i auditstate=20 s auditstate="已提交"
	i auditstate=30 s auditstate="审核通过"
	i auditstate=60 s auditstate="发布"
	s desc= result.Data("SPR_Desc")
	s auditdate= result.Data("SPR_auditDate")
	i auditdate=0 s auditdate=""
	i auditdate'="" s auditdate=$zdt(auditdate,3)
	s srowid= result.Data("Schem_rowid")
	s code= result.Data("Schem_code")
	s name= result.Data("Schem_name")
	s frequency= result.Data("Schem_frequency")
	s upschemdr= result.Data("Schem_UpSchemDr")
	s boolean="false"
	s boolean=..AarryContains(upschemdr,fatherschemedr)
	s GroupDr= result.Data("SCM_DeptDr")
    s k =$e(period,5,5)
   	i k="0" s changedperiod=$e(period,6,6)
    else  s changedperiod=$e(period,5,6)
	i boolean="true" {
	s temp=rowid_"^"_yearid_"^"_period_"^"_auditdr_"^"_auditstate_"^"_desc_"^"_auditdate_"^"_srowid_"^"_code_"^"_name_"^"_frequency_"^"_upschemdr_"^"_GroupDr_"^"_changedperiod
	i (count>=start)&(count<=end) d
	.d json.InsertRowData(temp)
	s count=count+1}
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// others:w ##class(dhc.pa.udata.uSchemPeridRec).List(0,25,"","1","Q","201502","","")
/// others:w ##class(dhc.pa.udata.uSchemPeridRec).List(0,25,"","1","","","20","")
ClassMethod ListFinal(start, limit, sysdr, userdr, frequency, period, result, schemedr) As %String
{
	n (start,limit,sysdr,userdr,frequency,period,result,schemedr)
	

	i userdr="" s userdr=0
	//s sysdr=2
	s sqlStr="SELECT DISTINCT c.SPR_rowid,c.SPR_period,c.SPR_auditDr,c.SPR_auditState,c.SPR_Desc,c.SPR_auditDate,a.Schem_rowid,a.Schem_code,a.Schem_name,a.Schem_frequency,a.Schem_UpSchemDr,d.SCM_DeptDr "
	_" FROM dhc_pa_data.Schem a,dhc_pa_data.Schem b ,dhc_pa_data.Schem_Perid_Rec c, dhc_pa_data.schem_Group d"
	_" WHERE  a.Schem_rowid=c.SPR_schemDr AND a.Schem_UpSchemDr LIKE '%'||b.Schem_rowid||'%'  "
	_" AND d.SCM_SchemDR = b.Schem_rowid"
	_" AND a.Schem_level >b.Schem_level"
	_" AND a.Schem_parRef=(SELECT Stratagem_rowid FROM dhc_pa_data.Stratagem WHERE Stratagem_currStratagem='Y')"
	_" AND b.Schem_rowid IN "
	_" (SELECT isa.SAudit_SchemDr FROM  dhc_pa_data.SchemAudit isa,dhc_pa_data.Schem isc "
	_" WHERE isa.SAudit_SchemDr=isc.Schem_rowid and isc.Schem_level=1 AND isa.SAudit_userDr ="_userdr
	s inWhere=""
	if schemedr'="" s inWhere=inWhere_" and isc.Schem_rowid='"_schemedr_"'"
	s sqlStr=sqlStr_inWhere_")"
	
	s whereStr=""
	
	i sysdr'="" s whereStr=whereStr_" AND c.SPR_appSysDr="_sysdr
	i frequency'="" s whereStr=whereStr_" AND a.Schem_frequency='"_frequency_"'"
	i period'="" s whereStr=whereStr_" AND c.SPR_period like '%"_period_"%'"
	i result=0 {s whereStr=whereStr_" AND (c.SPR_auditState = "_result_" or c.SPR_auditState is null )"}
	elseif result'="" {s whereStr=whereStr_" AND c.SPR_auditState = "_result_""}
	
	s sqlStr=sqlStr_whereStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	w sqlStr,!
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^yearid^period^auditdr^auditstate^desc^auditdate^srowid^code^name^frequency^upschemdr^GroupDr^changedperiod"
	While(result.Next())
	{
	s rowid= result.Data("SPR_rowid")
	s period= result.Data("SPR_period")
	
	s yearperiod=$e(period,1,4)
    &sql(select Cycle_rowid into :yearid from dhc_pa_data.Cycle where Cycle_active='Y' and Cycle_code=:yearperiod)
    
	s auditdr= result.Data("SPR_auditDr")
	s auditstate= result.Data("SPR_auditState")
	i auditstate="" s auditstate=0
	i auditstate=0 s auditstate="未提交"
	i auditstate=10 s auditstate="审核未通过"
	i auditstate=20 s auditstate="已提交"
	i auditstate=30 s auditstate="审核通过"
	i auditstate=60 s auditstate="发布"
	s desc= result.Data("SPR_Desc")
	s auditdate= result.Data("SPR_auditDate")
	i auditdate=0 s auditdate=""
	i auditdate'="" s auditdate=$zdt(auditdate,3)
	s srowid= result.Data("Schem_rowid")
	s code= result.Data("Schem_code")
	s name= result.Data("Schem_name")
	s frequency= result.Data("Schem_frequency")
	s upschemdr= result.Data("Schem_UpSchemDr")
	s GroupDr= result.Data("SCM_DeptDr")
    s k =$e(period,5,5)
   	i k="0" s changedperiod=$e(period,6,6)
    else  s changedperiod=$e(period,5,6)

	s temp=rowid_"^"_yearid_"^"_period_"^"_auditdr_"^"_auditstate_"^"_desc_"^"_auditdate_"^"_srowid_"^"_code_"^"_name_"^"_frequency_"^"_upschemdr_"^"_GroupDr_"^"_changedperiod
	i (count>=start)&(count<=end) d
	.d json.InsertRowData(temp)
	s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// others:w ##class(dhc.pa.udata.uSchemPeridRec).Check("118","1","1||11","30","","","","")
ClassMethod Check(rowid, checker, schemedr, result, chkprocdesc, desc, deptdr, chktype) As %String
{
   n (rowid, checker,schemedr,result,chkprocdesc,desc,deptdr,chktype)
   s Time = $p($h,",",1)
   &SQL(SELECT SCM_DeptDr into:deptdr
	FROM dhc_pa_data.schem_MDept
	WHERE  SCM_UserDR=:checker AND SCM_SchemDR like :schemedr  )
   &SQL(UPDATE dhc_pa_data.Schem_Perid_Rec SET SPR_auditDr=:checker,SPR_auditState=:result,SPR_auditDate =:Time,SPR_Desc=:desc where SPR_rowid=:rowid)
   &SQL(INSERT INTO dhc_pa_data.Schem_Perid_RecChkProc(SPRC_ShemPeridRecDR,SPRC_Chercker,SPRC_DateTime,SPRC_ChkResult,SPRC_ChkProcDesc,SPRC_Desc,SPRC_DeptDR,SPRC_ChkType )
   VALUES(:schemedr,:checker,:Time,:result,:chkprocdesc,:desc,:deptdr,:chktype))
   q SQLCODE
}

/// w:查找字符，s:字符串如"1||4,1||6,1||7"
/// others:w ##class(dhc.pa.udata.uSchemPeridRec).Contains("1||24","1||24,1||23,1||12,1||1")
/// others:w ##class(dhc.pa.udata.uMedicalPaCal).Contains("1||12","1||4,1||6,1||7")
ClassMethod Contains(w, s) As %String
{
	n (w,s)
	s len=$L(s,",")
	s boolean="false"
	for i=1:1:len{
		//w $p(s,",",i),!
		i w=$p(s,",",i){s boolean="true" q:boolean}
			
		}
	q boolean
}

/// w:查找字符，右边伪数组中包含左边伪数组中任何一个数，返回true
/// others:w ##class(dhc.pa.udata.uSchemPeridRec).AarryContains("1||24,1||23","1||24,1||23,1||12,1||1")
/// others:w ##class(dhc.pa.udata.uMedicalPaCal).Contains("1||12","1||4,1||6,1||7")
ClassMethod AarryContains(words, s) As %String
{
	n (words,s)
	s len=$L(words,",")
	s boolean="false"
	for i=1:1:len{
		s myw= $p(words,",",i)
		//w myw,"s "_s,!
		s boolean= ..Contains(myw,s)
		q:boolean="true"
		
			
		}
	q boolean
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uSchemPeridRecS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
