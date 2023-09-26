/// 医务处绩效考核计算
/// creator:赵伟
/// date：2015-05
Class dhc.pa.udata.uMedicalPaCal Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// others:w ##class(dhc.pa.udata.uMedicalPaCal).List(0,25,"2","3901","Q","201501","","")
ClassMethod List(start, limit, sysdr, userdr, frequency, period, result, schemedr) As %String
{
	n (start,limit,sysdr,userdr,frequency,period,result,schemedr)
	i userdr="" s userdr=0
	s sysdr=2
	s sqlStr=" SELECT DISTINCT c.SPR_rowid,c.SPR_period,c.SPR_auditDr->SSUSR_Name as SPR_auditDr,c.SPR_auditState,c.SPR_Desc,c.SPR_auditDate,a.Schem_rowid,a.Schem_code,a.Schem_name,a.Schem_frequency,a.Schem_UpSchemDr,d.SCM_DeptDr    "
	_"  FROM dhc_pa_data.Schem a left join dhc_pa_data.Schem_Perid_Rec c on a.Schem_rowid=c.SPR_schemDr left join  dhc_pa_data.schem_Group d on d.SCM_SchemDR =a.Schem_rowid "
	_" where a.Schem_parRef=(SELECT Stratagem_rowid FROM dhc_pa_data.Stratagem WHERE Stratagem_currStratagem='Y')  "
	_" AND a.Schem_rowid IN (SELECT isa.SAudit_SchemDr FROM  dhc_pa_data.SchemAudit isa,dhc_pa_data.Schem isc "
	_" WHERE isa.SAudit_SchemDr=isc.Schem_rowid and isc.Schem_level=1 AND isa.SAudit_userDr ="_userdr_")"
	s whereStr=""
	
	i sysdr'="" s whereStr=whereStr_" AND c.SPR_appSysDr="_sysdr
	i frequency'="" s whereStr=whereStr_" AND a.Schem_frequency='"_frequency_"'"
	i period'="" s whereStr=whereStr_" AND c.SPR_period= '"_period_"'"
	//i result'="" s whereStr=whereStr_" AND c.SPR_auditState = "_result_""
	i result=0 {s whereStr=whereStr_" AND (c.SPR_auditState = "_result_" or c.SPR_auditState is null )"}
	elseif result'="" {s whereStr=whereStr_" AND c.SPR_auditState = "_result_""}
	i schemedr'="" s whereStr=whereStr_" AND c.SPR_schemDr = "_schemedr_""
	
	s sqlStr=sqlStr_whereStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
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

/// others:w ##class(dhc.pa.udata.uMedicalPaCal).Check("262","3901","1||7","0","","","785","")
ClassMethod Check(rowid, checker, schemedr, result, chkprocdesc, desc, deptdr, chktype) As %String
{
   n (rowid, checker,schemedr,result,chkprocdesc,desc,deptdr,chktype)
   
   s Time = $p($h,",",1)

   &SQL(UPDATE dhc_pa_data.Schem_Perid_Rec SET SPR_auditDr=:checker,SPR_auditState=:result,SPR_auditDate =:Time,SPR_Desc=:desc  where SPR_rowid=:rowid)
   &SQL(INSERT INTO dhc_pa_data.Schem_Perid_RecChkProc(SPRC_ShemPeridRecDR,SPRC_Chercker,SPRC_DateTime,SPRC_ChkResult,SPRC_ChkProcDesc,SPRC_Desc,SPRC_DeptDR,SPRC_ChkType )
   VALUES(:rowid,:checker,:Time,:result,:chkprocdesc,:desc,:deptdR,:chktype))
   //次级影响
      &SQL(SELECT SPR_parRef, SPR_appSysDr, SPR_schemDr, SPR_period
   INTO :parref,:sysdr,:schemedr,:period
FROM dhc_pa_data.Schem_Perid_Rec WHERE SPR_rowid=:rowid)

   s myresult=result
   if (myresult=60){
	//发布时

   d ..updateBaseCheckDetailNew(schemedr,parref,sysdr,period,checker,myresult,chkprocdesc,desc,deptdr,chktype,Time,rowid)
  // w "schemedr"_schemedr,"parref"_parref,"sysdr"_sysdr,"period"_period,"checker"_checker,"schemedr"_schemedr,"result"_myresult,"chkprocdesc"_chkprocdesc,"desc"_desc,"deptdr"_deptdr,"chktype"_chktype,!

   }elseif(myresult=30)||(myresult=10)||(myresult=0)||(myresult=20){
	//审核时	

	d ..sonCheckDetailNew(schemedr,parref,sysdr,period,checker,myresult,chkprocdesc,desc,deptdr,chktype,Time,rowid)   
	}
   q SQLCODE
}

/// date 2016-08-05
/// 对方案单独审核时候，新增加的方法
ClassMethod sonCheckDetailNew(sonid, parref, sysdr, period, checker, myresult, chkprocdesc, desc, deptdr, chktype, Time, mainRowid) As %String
{

	n (sonid,parref,sysdr,period,checker,myresult,chkprocdesc,desc,deptdr,chktype,Time,mainRowid)
	//w "sonid"_sonid,!
	//查寻孩子的父亲
	s sqlStr="SELECT Schem_rowid,Schem_frequency,Schem_UpSchemDr FROM dhc_pa_data.Schem where Schem_rowid ='"_sonid_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		//w "step1",!
		s rowid = result.Data("Schem_rowid")
		//父亲们
		s frequency=result.Data("Schem_frequency")
		s upschemedr = result.Data("Schem_UpSchemDr")
		s myup=upschemedr
		s upschemedr = ..MyArray(upschemedr)
		s len=$l(upschemedr,",")
		//w "upschemedr"
		for j=1:1:len{

			//可能有坏方案，一个年份方案里面放了月份子方案
			//查找是否有孩子审核未通过，如果有，终结，如果一直没有，改变父亲状态
			s fatherid=$p(myup,",",j)
			//w "fatherid"_fatherid_"period"_period,!
			if (myresult=30)||(myresult=20){
			s flag="true"}elseif (myresult=10)||(myresult=0){
			s flag="false"	
				}
			
			s sqlStr2="SELECT a.Schem_rowid,a.Schem_UpSchemDr,b.SPR_auditState,b.SPR_period FROM "
			_" dhc_pa_data.Schem a,"
			_" dhc_pa_data.Schem_Perid_Rec b"
			_" WHERE a.Schem_rowid=b.SPR_schemDr and a.Schem_frequency='"_frequency_"'  and a.Schem_UpSchemDr is not null and SPR_period='"_period_"'"
			s result2=##class(%Library.ResultSet).%New()
			d result2.Prepare(sqlStr2)
			d result2.Execute()
			While(result2.Next()){


				s irowid = result2.Data("Schem_rowid")
				s iupschemedr = result2.Data("Schem_UpSchemDr")
				s state=result2.Data("SPR_auditState")
				//w "fatherid  "_fatherid_"iupschemedr"_iupschemedr,!
				s boolean=..Contains(fatherid,iupschemedr)
				//是它的孩子，而且没有审核通过
				if (boolean="true")&&(((state<30)&&(myresult=30))||((myresult=20)&&(state<20))){
					
					//w !,"sonrowid"_irowid_"fatherid  "_fatherid_"iupschemedr"_iupschemedr,!
					s flag="false" 
				}elseif (boolean="true")&&(((state<=10)&&(myresult=10))||((state=0)&&(myresult=0))){
					
					s flag="true" 
					
					}
			}
			d result2.Close()
			//w "flag"_flag,!
			if flag="true" {	
			//w "father's state is changed!"
			&SQL(UPDATE dhc_pa_data.Schem_Perid_Rec SET SPR_auditDr=:checker,SPR_auditState=:myresult,SPR_auditDate =:Time  where SPR_schemDr=:fatherid and SPR_parRef=:parref and SPR_appSysDr=:sysdr and SPR_period=:period)
   			 i SQLCODE'=0 {
					d ##class(dhc.pa.udata.uPALogger).Insert("(dhc.pa.udata.uMedicalPaCal).Check",fatherid_"^"_parref_"^"_sysdr_"^"_period,SQLCODE,"")
   					}
   			&SQL(INSERT INTO dhc_pa_data.Schem_Perid_RecChkProc(SPRC_ShemPeridRecDR,SPRC_Chercker,SPRC_DateTime,SPRC_ChkResult,SPRC_ChkProcDesc,SPRC_Desc,SPRC_DeptDR,SPRC_ChkType )
   			VALUES(:mainRowid,:checker,:Time,:myresult,:chkprocdesc,:desc,:deptdR,:chktype))
			}
			}
		
		
		
		
		//w "**_"_upschemedr,!
			//父亲的详细信息

		
	}
		
	d result.Close()

   //发布子方案
   //if result=60 
   
   q 0
}

/// others:w ##class(dhc.pa.udata.uMedicalPaCal).Check("114","1","1||7","30","","","","")
ClassMethod CheckAudit(rowid, checker, schemedr, result, chkprocdesc, desc, deptdr, chktype) As %String
{
   n (rowid, checker,schemedr,result,chkprocdesc,desc,deptdr,chktype)
   
   s Time = $p($h,",",1)
   //s shemedr = 1
   //s chkprocdesc = ""
   //s desc = ""
   //s DeptDR = 1      //操作人科室
   //s ChkType= 1
   //s deptdr=0
   //s Result = 30    //审核结果，通过30 不通过10  发布60
   &SQL(UPDATE dhc_pa_data.Schem_Perid_Rec SET SPR_auditDr=:checker,SPR_auditState=:result,SPR_auditDate =:Time,SPR_Desc=:desc  where SPR_rowid=:rowid)
   &SQL(INSERT INTO dhc_pa_data.Schem_Perid_RecChkProc(SPRC_ShemPeridRecDR,SPRC_Chercker,SPRC_DateTime,SPRC_ChkResult,SPRC_ChkProcDesc,SPRC_Desc,SPRC_DeptDR,SPRC_ChkType )
   VALUES(:rowid,:checker,:Time,:result,:chkprocdesc,:desc,:deptdR,:chktype))
   //次级影响
      &SQL(SELECT SPR_parRef, SPR_appSysDr, SPR_schemDr, SPR_period
   INTO :parref,:sysdr,:schemedr,:period
FROM dhc_pa_data.Schem_Perid_Rec WHERE SPR_rowid=:rowid)

   s myresult=result
   
	//发布时

   //w schemedr,parref,sysdr,period,checker,schemedr,result,chkprocdesc,desc,deptdr,chktype
   //w 'fatherid'_fatherid_'parref'_parref,'sysdr'_sysdr,'period'_period,'checker'_checker,'schemedr'_schemedr,'result'_result,'chkprocdesc'_chkprocdesc,'desc'_desc,'deptdr'_deptdr,'chktype'_chktype,!

   d ..updateBaseCheckDetailNew(schemedr,parref,sysdr,period,checker,myresult,chkprocdesc,desc,deptdr,chktype,Time,rowid)
  // w "schemedr"_schemedr,"parref"_parref,"sysdr"_sysdr,"period"_period,"checker"_checker,"schemedr"_schemedr,"result"_myresult,"chkprocdesc"_chkprocdesc,"desc"_desc,"deptdr"_deptdr,"chktype"_chktype,!

   
   q SQLCODE
}

/// date：2016-08-04   班
/// description: 增加了dhc_pa_data.Schem_Perid_Rec的rowid，
/// 作为dhc_pa_data.Schem_Perid_RecChkProc中SPRC_ShemPeridRecDR字段的值
/// 从而确定dhc_pa_data.Schem_Perid_RecChkProc表中状态和处理期间的方案对应
ClassMethod updateBaseCheckDetailNew(fatherid, parref, sysdr, period, checker, myresult, chkprocdesc, desc, deptdr, chktype, Time, mainRowid) As %String
{

	n (fatherid,parref,sysdr,period,checker,myresult,chkprocdesc,desc,deptdr,chktype,Time,mainRowid)
	s sqlStr="SELECT Schem_rowid,Schem_UpSchemDr FROM dhc_pa_data.Schem where Schem_UpSchemDr is not null"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		
		s rowid = result.Data("Schem_rowid")
		s upschemedr = result.Data("Schem_UpSchemDr")
		s upschemedr = ..MyArray(upschemedr)
		//w "**_"_upschemedr,!
			s sqlStr2="SELECT Schem_rowid,Schem_UpSchemDr FROM dhc_pa_data.Schem where Schem_rowid in ("_upschemedr_")"
			s result2=##class(%Library.ResultSet).%New()
			d result2.Prepare(sqlStr2)
			d result2.Execute()
			While(result2.Next()){
				s irowid = result2.Data("Schem_rowid")
				i irowid=fatherid
				{
				//do what you want
					//w "checker "_checker_"result "_myresult_"Time "_Time_"rowid "_rowid_" parref"_parref_"sysdr "_sysdr_" period"_period,!
				   &SQL(UPDATE dhc_pa_data.Schem_Perid_Rec SET SPR_auditDr=:checker,SPR_auditState=:myresult,SPR_auditDate =:Time  where SPR_schemDr=:rowid and SPR_parRef=:parref and SPR_appSysDr=:sysdr and SPR_period=:period)
   					i SQLCODE'=0 {
					d ##class(dhc.pa.udata.uPALogger).Insert("class(dhc.pa.udata.uMedicalPaCal).Check",rowid_"^"_parref_"^"_sysdr_"^"_period,SQLCODE,"")
   					}
   					&SQL(INSERT INTO dhc_pa_data.Schem_Perid_RecChkProc(SPRC_ShemPeridRecDR,SPRC_Chercker,SPRC_DateTime,SPRC_ChkResult,SPRC_ChkProcDesc,SPRC_Desc,SPRC_DeptDR,SPRC_ChkType )
   					VALUES(:mainRowid,:checker,:Time,:myresult,:chkprocdesc,:desc,:deptdR,:chktype))
				//w "son"_rowid_"parref"_parref_"sysdr"_sysdr_"period"_period,!
				d ..updateBaseCheckDetailNew(rowid,parref,sysdr,period,checker,myresult,chkprocdesc,desc,deptdr,chktype,Time,mainRowid)
				}
	
			}
	
			d result2.Close()
		
	}
		
	d result.Close()
   
   q 0
}

//孩子控制

//ClassMethod CheckDetail(rowid,period, checker, schemedr, result, chkprocdesc, desc, deptdr, chktype) As %String

//{

//   n (rowid,period, checker,schemedr,result,chkprocdesc,desc,deptdr,chktype)

/// others:w ##class(dhc.pa.udata.uSchemPeridRec).CheckDetail("114","","Demo Group","1||7","30","","","","")
/// others:w ##class(dhc.pa.udata.uMedicalPaCal).baseCheckDetail()
ClassMethod sonCheckDetail(sonid, parref, sysdr, period, checker, myresult, chkprocdesc, desc, deptdr, chktype, Time) As %String
{

	n (sonid,parref,sysdr,period,checker,myresult,chkprocdesc,desc,deptdr,chktype,Time)
	//w "sonid"_sonid,!
	//查寻孩子的父亲
	s sqlStr="SELECT Schem_rowid,Schem_frequency,Schem_UpSchemDr FROM dhc_pa_data.Schem where Schem_rowid ='"_sonid_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		//w "step1",!
		s rowid = result.Data("Schem_rowid")
		//父亲们
		s frequency=result.Data("Schem_frequency")
		s upschemedr = result.Data("Schem_UpSchemDr")
		s myup=upschemedr
		s upschemedr = ..MyArray(upschemedr)
		s len=$l(upschemedr,",")
		//w "upschemedr"
		for j=1:1:len{

			//可能有坏方案，一个年份方案里面放了月份子方案
			//查找是否有孩子审核未通过，如果有，终结，如果一直没有，改变父亲状态
			s fatherid=$p(myup,",",j)
			//w "fatherid"_fatherid_"period"_period,!
			if (myresult=30)||(myresult=20){
			s flag="true"}elseif (myresult=10)||(myresult=0){
			s flag="false"	
				}
			
			s sqlStr2="SELECT a.Schem_rowid,a.Schem_UpSchemDr,b.SPR_auditState,b.SPR_period FROM "
			_" dhc_pa_data.Schem a,"
			_" dhc_pa_data.Schem_Perid_Rec b"
			_" WHERE a.Schem_rowid=b.SPR_schemDr and a.Schem_frequency='"_frequency_"'  and a.Schem_UpSchemDr is not null and SPR_period='"_period_"'"
			s result2=##class(%Library.ResultSet).%New()
			d result2.Prepare(sqlStr2)
			d result2.Execute()
			While(result2.Next()){


				s irowid = result2.Data("Schem_rowid")
				s iupschemedr = result2.Data("Schem_UpSchemDr")
				s state=result2.Data("SPR_auditState")
				//w "fatherid  "_fatherid_"iupschemedr"_iupschemedr,!
				s boolean=..Contains(fatherid,iupschemedr)
				//是它的孩子，而且没有审核通过
				if (boolean="true")&&(((state<30)&&(myresult=30))||((myresult=20)&&(state<20))){
					
					//w !,"sonrowid"_irowid_"fatherid  "_fatherid_"iupschemedr"_iupschemedr,!
					s flag="false" 
				}elseif (boolean="true")&&(((state<=10)&&(myresult=10))||((state=0)&&(myresult=0))){
					
					s flag="true" 
					
					}
			}
			d result2.Close()
			//w "flag"_flag,!
			if flag="true" {	
			//w "father's state is changed!"
			&SQL(UPDATE dhc_pa_data.Schem_Perid_Rec SET SPR_auditDr=:checker,SPR_auditState=:myresult,SPR_auditDate =:Time  where SPR_schemDr=:fatherid and SPR_parRef=:parref and SPR_appSysDr=:sysdr and SPR_period=:period)
   			 i SQLCODE'=0 {
					d ##class(dhc.pa.udata.uPALogger).Insert("(dhc.pa.udata.uMedicalPaCal).Check",fatherid_"^"_parref_"^"_sysdr_"^"_period,SQLCODE,"")
   					}
   			&SQL(INSERT INTO dhc_pa_data.Schem_Perid_RecChkProc(SPRC_ShemPeridRecDR,SPRC_Chercker,SPRC_DateTime,SPRC_ChkResult,SPRC_ChkProcDesc,SPRC_Desc,SPRC_DeptDR,SPRC_ChkType )
   			VALUES(:fatherid,:checker,:Time,:myresult,:chkprocdesc,:desc,:deptdR,:chktype))
			}
			}
		
		
		
		
		//w "**_"_upschemedr,!
			//父亲的详细信息

		
	}
		
	d result.Close()

   //发布子方案
   //if result=60 
   
   q 0
}

/// others:w ##class(dhc.pa.udata.uSchemPeridRec).CheckDetail("118","","Demo Group","1||8","30","","","","")
/// others:w ##class(dhc.pa.udata.uMedicalPaCal).baseCheckDetail()
ClassMethod updateBaseCheckDetail(fatherid, parref, sysdr, period, checker, myresult, chkprocdesc, desc, deptdr, chktype, Time) As %String
{

	n (fatherid,parref,sysdr,period,checker,myresult,chkprocdesc,desc,deptdr,chktype,Time)
	s sqlStr="SELECT Schem_rowid,Schem_UpSchemDr FROM dhc_pa_data.Schem where Schem_UpSchemDr is not null"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		
		s rowid = result.Data("Schem_rowid")
		s upschemedr = result.Data("Schem_UpSchemDr")
		s upschemedr = ..MyArray(upschemedr)
		//w "**_"_upschemedr,!
			s sqlStr2="SELECT Schem_rowid,Schem_UpSchemDr FROM dhc_pa_data.Schem where Schem_rowid in ("_upschemedr_")"
			s result2=##class(%Library.ResultSet).%New()
			d result2.Prepare(sqlStr2)
			d result2.Execute()
			While(result2.Next()){
				s irowid = result2.Data("Schem_rowid")
				i irowid=fatherid
				{
				//do what you want
					//w "checker "_checker_"result "_myresult_"Time "_Time_"rowid "_rowid_" parref"_parref_"sysdr "_sysdr_" period"_period,!
				   &SQL(UPDATE dhc_pa_data.Schem_Perid_Rec SET SPR_auditDr=:checker,SPR_auditState=:myresult,SPR_auditDate =:Time  where SPR_schemDr=:rowid and SPR_parRef=:parref and SPR_appSysDr=:sysdr and SPR_period=:period)
   					i SQLCODE'=0 {
					d ##class(dhc.pa.udata.uPALogger).Insert("class(dhc.pa.udata.uMedicalPaCal).Check",rowid_"^"_parref_"^"_sysdr_"^"_period,SQLCODE,"")
   					}
   					&SQL(INSERT INTO dhc_pa_data.Schem_Perid_RecChkProc(SPRC_ShemPeridRecDR,SPRC_Chercker,SPRC_DateTime,SPRC_ChkResult,SPRC_ChkProcDesc,SPRC_Desc,SPRC_DeptDR,SPRC_ChkType )
   					VALUES(:mainRowid,:checker,:Time,:myresult,:chkprocdesc,:desc,:deptdR,:chktype))
				//w "son"_rowid_"parref"_parref_"sysdr"_sysdr_"period"_period,!
				d ..updateBaseCheckDetail(rowid,parref,sysdr,period,checker,myresult,chkprocdesc,desc,deptdr,chktype,Time)
				}
	
			}
	
			d result2.Close()
		
	}
		
	d result.Close()
   
   q 0
}

/// others:w ##class(dhc.pa.udata.uMedicalPaCal).MyArray("1||4,1||6,1||7")
ClassMethod MyArray(s) As %String
{
	n (s)
	s len=$L(s,",")
	s resultString=""
	for i=1:1:len{
		i resultString="" {
		s resultString=resultString_"'"_$p(s,",",i)_"'"}else{
		s resultString=resultString_",'"_$p(s,",",i)_"'"	
			}
		}
	q resultString
}

/// w:查找字符，s:字符串如"1||4,1||6,1||7"
/// description:右边字符串包换左边字符
/// others:w ##class(dhc.pa.udata.uMedicalPaCal).Contains("1||24","1||24,1||23,1||12,1||1")
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

Storage Default
{
<StreamLocation>^dhc.pa.udata.uMedicalPaCalS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
