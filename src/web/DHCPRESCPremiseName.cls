Import SQLUser

/// Creator：      yuliping
/// CreatDate：    2022-06-16
/// Description:   前置审方-前提名称表
/// Table：    	   CF_PHA_PREADT.PremiseName
Class web.DHCPRESCPremiseName Extends %Persistent [ Not ProcedureBlock ]
{

/// w ##class(web.DHCPRESCPremiseName).save("222^2^3^Y^")
ClassMethod save(params)
{
	n (params)
	s ^temptest("22ss") = $lb(params)
	TS
  	s ret=0
  	s len=$l(params,"$$")
  	f i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..SaveOrUpdate(str)
  	
	i ret<0 TRollback
	q:ret<0 ret
	
	Tc
	q ret
}

ClassMethod SaveOrUpdate(str)
{
	n (str)
	s id = $p(str,"^",5)
	s code = $p(str,"^",1)
	;s Err = ..judgeCode(id, code)
	;q:Err="-1" "-1"
	
	i +id=0 d
	.s rtn= ..insert(str)
	e  d
	.s rtn = ..update(str,id)
	.
	q rtn
}

/// 根据code判断是否已存在
/// w ##class(web.DHCPRESCPremiseName).judgeCode("","Loc")
ClassMethod judgeCode(id, code)
{
	
	n (id,code)
	s code = $$ALPHAUP^SSUTIL4(code)
	s thisId=0
	i $d(^CF.PHA.PREADT.PremiseDicI("IndexCode",code)) s thisId= $o(^CF.PHA.PREADT.PremiseDicI("IndexCode",code,""))

	q:(+id=0)&&(thisId'=0) "-1"
	q:(id=thisId)&&(thisId'=0) "0"
	q:(id'=thisId)&&(thisId'=0) "-1"
	
	q "0"
}

/// w ##class(web.DHCPRESCPremiseName).insert("Loc^科室^##class(web.DHCADVCOMMON)")
ClassMethod insert(str)
{
	n (str)
	s PPDCode=$p(str,"^",1)
	s PPDHosp=$p(str,"^",2)
	s PPDModule=$p(str,"^",3)
	s PPDActive=$p(str,"^",4)
	b
	&SQL(Insert Into CF_PHA_PREADT.PremiseName(PAP_Name,PAP_Hosp,PAP_Module,PAP_Active)
		values(:PPDCode,:PPDHosp,:PPDModule,:PPDActive))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

ClassMethod update(str, id)
{
	n (str,id)
	s PPDCode=$p(str,"^",1)
	s PPDHosp=$p(str,"^",2)
	s PPDModule=$p(str,"^",3)
	s PPDActive=$p(str,"^",4)

	&SQL(Update CF_PHA_PREADT.PremiseName set PAP_Name=:PPDCode,PAP_Hosp=:PPDHosp,PAP_Module=:PPDModule,PAP_Active=:PPDActive
		where PN_RowID =:id)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Function：查询/加载列表信息
/// Debugger： d ##class(web.DHCPRESCPremiseName).ListData(1,10,"")
ClassMethod ListData(page = 1, rows = 10, Params)
{
		n (page, rows, Params)
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s desc = $p(Params,"^",1)
	    s Hosp = $p(Params,"^",2)
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s Id=""
		f  s Id=$o(^CF.PHA.PREADT.PremiseNameD(Id)) q:Id=""  d
		.q:Id=0
		.s code=$lg(^CF.PHA.PREADT.PremiseNameD(Id),2)
		.Q:(desc'="")&&(code'=desc)
		.s hospId=$lg(^CF.PHA.PREADT.PremiseNameD(Id),3)
		.Q:(Hosp'="")&&(Hosp'=hospId)
		.s moduleId=$lg($g(^CF.PHA.PREADT.PremiseNameD(Id)),4)
		.q:moduleId=0
		.s module=""
		.s:+moduleId'=0 module=$lg($g(^PHA.PREADT.CaseCollectModuleD(moduleId)),3)
		.s active=$lg(^CF.PHA.PREADT.PremiseNameD(Id),5)
		.s hosp=""
		.s:hospId'="" hosp = $p(^CT("HOSP",hospId),"^",2)
		.s data=Id_"^"_code_"^"_hosp_"^"_module_"^"_active_"^"_hospId_"^"_moduleId
		.;q:(q'="")&(desc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.w ##class(web.DHCAPPJsonCommon).getJsonData("Id^code^hosp^module^active^hospId^moduleId",data)
		w "],""total"":"_count_"}"
		q ""
}

/// Function：查询/加载列表信息
/// Debugger： d ##class(web.DHCPRESCPremiseName).ListCaseData("")
ClassMethod ListCaseData(q)
{
		n (q)
	    s count=0
	    w "["
		s Id=""
		f  s Id=$o(^PHA.PREADT.CaseCollectModuleD(Id)) q:Id=""  d
		.q:Id=0
		.s desc=$lg(^PHA.PREADT.CaseCollectModuleD(Id),3)
		.q:(desc'[q)&&(q'="")
		.s count=count+1
		.i count=1 d
		..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Id_"^"_desc)
		.e  d
		..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",Id_"^"_desc)
		w "]"
		q ""
}

/// w ##class(web.DHCPRESCPremiseName).delete("1")
ClassMethod delete(ID)
{
	n (ID)
	&SQL(delete from CF_PHA_PREADT.PremiseName where PN_RowID=:ID)
	Q:SQLCODE'=0 SQLCODE
	Q SQLCODE
}

/// Descript:js 获取医院字典信息
/// CreateDate:2016-04-21
/// w ##Class(web.DHCMDTCom).GetHospDs()
ClassMethod GetHospDs() As %String
{
	s count=0
	w "["
	s hosprowid=""
	f  s hosprowid=$o(^CT("HOSP",hosprowid)) q:hosprowid=""  d
	.q:hosprowid=0
	.s hospdesc=$p(^CT("HOSP",hosprowid),"^",2) 
	.s tmp=hosprowid_"^"_hospdesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

Storage Default
{
<Data name="DHCPRESCPremiseNameDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPRESCPremiseNameD</DataLocation>
<DefaultData>DHCPRESCPremiseNameDefaultData</DefaultData>
<IdLocation>^web.DHCPRESCPremiseNameD</IdLocation>
<IndexLocation>^web.DHCPRESCPremiseNameI</IndexLocation>
<StreamLocation>^web.DHCPRESCPremiseNameS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
