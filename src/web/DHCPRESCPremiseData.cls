Import SQLUser

/// Creator：      yuliping
/// CreatDate：    2022-06-16
/// Description:   前置审方-前提数据表：逻辑关系:or
/// Table：    	   CF_PHA_PREADT.PremiseData
Class web.DHCPRESCPremiseData Extends %Persistent [ Not ProcedureBlock ]
{

/// w ##class(web.DHCPRESCPremiseData).save("Locs^科室^web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo^2")
ClassMethod save(params)
{
	n (params)
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
	
	s id = $p(str,"^",8)
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
/// w ##class(web.DHCPRESCPremiseData).judgeCode("","Loc")
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

/// w ##class(web.DHCPRESCPremiseData).insert("Loc^科室^##class(web.DHCADVCOMMON)")
ClassMethod insert(str)
{
	n (str)
	s PPDNodeDr=$p(str,"^",1)
	s PPDValue=$p(str,"^",2)
	s PPDNameDr=$p(str,"^",3)
	s PPDLimit=$p(str,"^",4)
	s PPDStTime=$p(str,"^",5)
	s PPDEdTime=$p(str,"^",6)
	s PPDType=$p(str,"^",7)
	&SQL(Insert Into CF_PHA_PREADT.PremiseData(PPD_Node_Dr,PPD_Value,PPD_Name_Dr,PPD_Limit,PPD_StTime,PPD_EdTime,PPD_Type)
		values(:PPDNodeDr,:PPDValue,:PPDNameDr,:PPDLimit,:PPDStTime,:PPDEdTime,:PPDType))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

ClassMethod update(str, id)
{
	n (str,id)
	s PPDNodeDr=$p(str,"^",1)
	s PPDValue=$p(str,"^",2)
	s PPDNameDr=$p(str,"^",3)
	s PPDLimit=$p(str,"^",4)
	s PPDStTime=$p(str,"^",5)
	s PPDEdTime=$p(str,"^",6)
	s PPDType=$p(str,"^",7)

	&SQL(Update CF_PHA_PREADT.PremiseData set PPD_Node_Dr=:PPDNodeDr,PPD_Value=:PPDValue,PPD_Name_Dr=:PPDNameDr,PPD_Limit=:PPDLimit
		,PPD_StTime=:PPDStTime,PPD_EdTime=:PPDEdTime,PPD_Type=:PPDType
		where PD_RowID =:id)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Function：查询/加载列表信息
/// Debugger： d ##class(web.DHCPRESCPremiseData).ListData("1","40","22")
ClassMethod ListData(page = 1, rows = 10, ID)
{
		n (page, rows, ID)
		s ^temptest("ID") = $LB(page, rows, ID)
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    i (+ID=0)||('$d(^CF.PHA.PREADT.PremiseDataI("PPDNode",ID))) w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	    q:(+ID=0)||('$d(^CF.PHA.PREADT.PremiseDataI("PPDNode",ID))) ""
	    w "{""rows"":["
		s Id=""
		f  s Id=$o(^CF.PHA.PREADT.PremiseDataI("PPDNode",ID,Id)) q:Id=""  d
		.q:Id=0
		.s PPDNodeDr=$lg(^CF.PHA.PREADT.PremiseDataD(Id),2)
		.s PPDValueId=$lg(^CF.PHA.PREADT.PremiseDataD(Id),3)
		.s PPDNameDr=$lg(^CF.PHA.PREADT.PremiseDataD(Id),4)
		.s PPDName=$lg(^CF.PHA.PREADT.PremiseNameD(PPDNameDr),2)
		.s PPDLimit=$lg(^CF.PHA.PREADT.PremiseDataD(Id),5)
		.s PPDStTime=$lg(^CF.PHA.PREADT.PremiseDataD(Id),6)
		.s PPDEdTime=$lg(^CF.PHA.PREADT.PremiseDataD(Id),7)
		.s PPDType=$lg(^CF.PHA.PREADT.PremiseDataD(Id),8)
		.s PPDValue = ""
		.i PPDType="Constant"  d
		..s dicId = $lg(^CF.PHA.PREADT.PremiseNodeD(PPDNodeDr),3)
		..s dictype = ""
		..s:+dicId'=0 dictype = $lg(^CF.PHA.PREADT.PremiseDicD(dicId),2)
		..s:dictype="Loc" PPDValue = $p(^CTLOC(PPDValueId),"^",2)
		..s:dictype="doc" PPDValue = $p(^CTPCP(PPDValueId,1),"^",2)
		.e  d
		..s PPDValue = PPDValueId
		.s data=Id_"^"_PPDNodeDr_"^"_PPDValueId_"^"_PPDValue_"^"_PPDNameDr _"^"_PPDName_"^"_PPDLimit_"^"_PPDStTime_"^"_PPDEdTime_"^"_PPDType
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^PPDNodeDr^PPDValueId^PPDValue^PPDNameDr^PPDName^PPDLimit^PPDStTime^PPDEdTime^PPDType",data)
		w "],""total"":"_count_"}"
		q ""
}

/// w ##class(web.DHCPRESCPremiseData).delete("1")
ClassMethod delete(ID)
{
	n (ID)
	&SQL(delete from CF_PHA_PREADT.PremiseData where PD_RowID=:ID)
	Q:SQLCODE'=0 SQLCODE
	Q SQLCODE
}

Storage Default
{
<Data name="DHCPRESCPremiseDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPRESCPremiseDataD</DataLocation>
<DefaultData>DHCPRESCPremiseDataDefaultData</DefaultData>
<IdLocation>^web.DHCPRESCPremiseDataD</IdLocation>
<IndexLocation>^web.DHCPRESCPremiseDataI</IndexLocation>
<StreamLocation>^web.DHCPRESCPremiseDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
