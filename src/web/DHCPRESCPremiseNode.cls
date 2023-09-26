Import SQLUser

/// Creator：      yuliping
/// CreatDate：    2022-06-16
/// Description:   前置审方-前提节点表： 逻辑关系:and
/// Table：    	   CF_PHA_PREADT.PremiseNode
Class web.DHCPRESCPremiseNode Extends %Persistent [ Not ProcedureBlock ]
{

/// w ##class(web.DHCPRESCPremiseNode).save("1^14^Y^")
ClassMethod save(params)
{
	n (params)
	s ^temptest("33xx3") = $lb(params)
	TS
  	s ret=0
  	s len=$l(params,"$$")
  	f i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..CheckRepeat(str)   	/// 重复性判断
  	.b  //22
	.q:ret<0
  	.s ret=..SaveOrUpdate(str)
  	
	i ret<0 TRollback
	q:ret<0 ret
	
	Tc
	q ret
}

ClassMethod SaveOrUpdate(str)
{
	n (str)
	
	s id = $p(str,"^",4)
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
/// w ##class(web.DHCPRESCPremiseNode).judgeCode("","Loc")
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

/// w ##class(web.DHCPRESCPremiseNode).insert("Loc^科室^##class(web.DHCADVCOMMON)")
ClassMethod insert(str)
{
	n (str)
	s PPNNameDr=$p(str,"^",1)
	s PPNDicDr=$p(str,"^",2)
	s PPNOp=$p(str,"^",3)

	&SQL(Insert Into CF_PHA_PREADT.PremiseNode(PPN_Name_Dr,PPN_Dic_Dr,PPN_Op)
		values(:PPNNameDr,:PPNDicDr,:PPNOp))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

ClassMethod update(str, id)
{
	n (str,id)
	s PPNNameDr=$p(str,"^",1)
	s PPNDicDr=$p(str,"^",2)
	s PPNOp=$p(str,"^",3)

	&SQL(Update CF_PHA_PREADT.PremiseNode set PPN_Name_Dr=:PPNNameDr,PPN_Dic_Dr=:PPNDicDr,PPN_Op=:PPNOp
		where PN_RowID =:id)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

ClassMethod CheckRepeat(ItmTempStr)
{
	n (ItmTempStr)
	s ret=0
	s nameId = $p(ItmTempStr,"^",1)   	 ///ID
	s dicId = $p(ItmTempStr,"^",2)  	 ///代码
	s opDesc = $p(ItmTempStr,"^",3) 	 ///描述
	s ID = $p(ItmTempStr,"^",4)	 
	b  
	s:$d(^CF.PHA.PREADT.PremiseNodeI("DicOp",nameId,dicId,opDesc)) ret = "-1"
	
	q ret
}

/// Function：查询/加载列表信息
/// Debugger： d ##class(web.DHCPRESCPremiseNode).ListData(1,10,"1")
ClassMethod ListData(page = 1, rows = 10, ID)
{
		n (page, rows,ID)
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    i (+ID=0)||('$d(^CF.PHA.PREADT.PremiseNodeI("PPNName",ID))) w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	    q:(+ID=0)||('$d(^CF.PHA.PREADT.PremiseNodeI("PPNName",ID))) ""
	    w "{""rows"":["
		s Id=""
		f  s Id=$o(^CF.PHA.PREADT.PremiseNodeI("PPNName",ID,Id)) q:Id=""  d
		.q:Id=0
		.s NameDr=$lg(^CF.PHA.PREADT.PremiseNodeD(Id),2)
		.s Name=$lg(^CF.PHA.PREADT.PremiseNameD(NameDr),2)
		.s DicDr=$lg(^CF.PHA.PREADT.PremiseNodeD(Id),3)
		.q:+DicDr=0
		.s type = $lg(^CF.PHA.PREADT.PremiseDicD(DicDr),2)
		.s DicName = $lg($g(^CF.PHA.PREADT.PremiseDicD(DicDr)),3)
		.s PPNOp=$lg(^CF.PHA.PREADT.PremiseNodeD(Id),4)
		.s data=Id_"^"_NameDr_"^"_Name_"^"_DicDr_"^"_DicName_"^"_PPNOp_"^"_type
		.;q:(PPCode'="")&(code'[PPCode)
		.;q:(PPName'="")&(desc'[PPName)
		.;q:(q'="")&(desc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^NameDr^Name^DicDr^Dic^PPNOp^type",data)
		w "],""total"":"_count_"}"
		q ""
}

/// w ##class(web.DHCPRESCPremiseNode).delete("1")
ClassMethod delete(ID)
{
	n (ID)
	&SQL(delete from CF_PHA_PREADT.PremiseNode where PN_RowID=:ID)
	Q:SQLCODE'=0 SQLCODE
	Q SQLCODE
}

Storage Default
{
<Data name="DHCPRESCPremiseNodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPRESCPremiseNodeD</DataLocation>
<DefaultData>DHCPRESCPremiseNodeDefaultData</DefaultData>
<IdLocation>^web.DHCPRESCPremiseNodeD</IdLocation>
<IndexLocation>^web.DHCPRESCPremiseNodeI</IndexLocation>
<StreamLocation>^web.DHCPRESCPremiseNodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
