Import SQLUser

/// Description:提供药师工作站，用药咨询相关模块
/// Creator:pengzhikun
Class web.DHCPHCONSULT Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// pengzhikun --- 2014-8-20
/// 获取咨询类别列表
/// d ##class("web.DHCPHCONSULT").getPhConTypeInfo("100","1")
ClassMethod getPhConTypeInfo(rows, page) As %String
{
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s h=0
	s phConTypeRid=0
    f  s phConTypeRid=$o(^DHCPHCONT(phConTypeRid)) q:(phConTypeRid="")||(phConTypeRid=0)  d
    .s h=h+1
    .s PhContCode=$p(^DHCPHCONT(phConTypeRid),"^",1)
    .s PhContDesc=$p(^DHCPHCONT(phConTypeRid),"^",2)
    .s rowid=phConTypeRid
    .s data=PhContCode_"^"_PhContDesc_"^"_rowid
    .s ^TMP("DHCST","DHCPHCONSULT","getPhConTypeInfo",pid,h)=data
    
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s maxrow=h
	i endpage>maxrow s endpage=maxrow
	
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCPHCONSULT","getPhConTypeInfo",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCPHCONSULT","getPhConTypeInfo",pid,h)
	.s PhContCode=$p(data,"^",1)
	.s PhContDesc=$p(data,"^",2)
	.s rowid=$p(data,"^",3)
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
	.s PhContCode=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PhContCode",PhContCode)
	.s PhContDesc=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PhContDesc",PhContDesc)
	.s rowid=##Class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=PhContCode_PhContDesc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    k ^TMP("DHCST","DHCSTPHCMFUNLIB","getPhConTypeInfo",pid)

	q ""
}

/// 2014-08-23
/// pengzhikun  
/// 获取咨询类别信息,用于界面的下拉显示
/// d ##class("web.DHCPHCONSULT").GetComboPhConType()
ClassMethod GetComboPhConType()
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PHCONT_Code as PhContCode,PHCONT_RowID as rowid FROM DHC_PHConsultType"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s PhContCode = result.Data("PhContCode")
		s rowid = result.Data("rowid")
		s tmp=rowid_"^"_PhContCode
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

//d ##class("web.DHCPHCONSULT").GetComboUser()

ClassMethod GetComboUser()
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT SSUSR_Name as name,SSUSR_RowId as rowid FROM SS_User"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s name = result.Data("name")
		s rowid = result.Data("rowid")
		s tmp=rowid_"^"_name
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// pengzhikun --- 2014-8-20 
/// 更新咨询类别 DHC_PHConsultType
ClassMethod UpdatePhConType(DataList) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..Update(TmpStr)
	.e  d
	..s ret=..Insert(TmpStr)
	q 0
}

/// Descript:update 更新咨询类别 DHC_PHConsultType记录
ClassMethod Update(DataList) As %String
{
	N (DataList)
	S rowid=$p(DataList,"^",1)
	S code=$p(DataList,"^",2) 
	S desc=$p(DataList,"^",3)
	&SQL(UPDATE DHC_PHConsultType Set PHCONT_Code=:code,PHCONT_Desc=:desc
 		WHERE PHCONT_RowID=:rowid)
 	Q SQLCODE
}

/// Descript:Insert 更新咨询类别 DHC_PHConsultType 记录
ClassMethod Insert(DataList) As %String
{
	N (DataList)
	S code=$p(DataList,"^",2) 
	S desc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_PHConsultType(PHCONT_Code,PHCONT_Desc)
 		VALUES(:code,:desc))
 	Q SQLCODE
}

/// Descript:delete 更新咨询类别 DHC_PHConsultType 记录
ClassMethod Delete(rowid) As %String
{
	N (rowid)
	&SQL(DELETE FROM DHC_PHConsultType WHERE PHCONT_RowID=:rowid)
	Q SQLCODE
}

/// pengzhikun --- 2014-8-27
/// 获取问题类别列表
/// d ##class("web.DHCPHCONSULT").getPhConQueTypeInfo("100","1")
ClassMethod getPhConQueTypeInfo(rows, page) As %String
{
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s h=0
	s phConQueTypeRid=0
    f  s phConQueTypeRid=$o(^DHCPHCONQT(phConQueTypeRid)) q:(phConQueTypeRid="")||(phConQueTypeRid=0)  d
    .s h=h+1
    .s PhContQueCode=$p(^DHCPHCONQT(phConQueTypeRid),"^",1)
    .s PhContQueDesc=$p(^DHCPHCONQT(phConQueTypeRid),"^",2)
    .s rowid=phConQueTypeRid
    .s data=PhContQueCode_"^"_PhContQueDesc_"^"_rowid
    .s ^TMP("DHCST","DHCPHCONSULT","getPhConQueTypeInfo",pid,h)=data
    
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s maxrow=h
	i endpage>maxrow s endpage=maxrow
	
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCPHCONSULT","getPhConQueTypeInfo",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCPHCONSULT","getPhConQueTypeInfo",pid,h)
	.s PhContQueCode=$p(data,"^",1)
	.s PhContQueDesc=$p(data,"^",2)
	.s rowid=$p(data,"^",3)
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
	.s PhContQueCode=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PhContQueCode",PhContQueCode)
	.s PhContQueDesc=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PhContQueDesc",PhContQueDesc)
	.s rowid=##Class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=PhContQueCode_PhContQueDesc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    k ^TMP("DHCST","DHCSTPHCMFUNLIB","getPhConQueTypeInfo",pid)

	q ""
}

/// 2014-08-27
/// pengzhikun  
/// 获取问题类别信息,用于界面的下拉显示
/// d ##class("web.DHCPHCONSULT").GetComboPhConQueType()
ClassMethod GetComboPhConQueType()
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PHCONQT_Code as PhContQueCode,PHCONQT_RowID as rowid FROM DHC_PHConQueType"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s PhContQueCode = result.Data("PhContQueCode")
		s rowid = result.Data("rowid")
		s tmp=rowid_"^"_PhContQueCode
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// pengzhikun --- 2014-08-27 
/// 更新问题类别 DHC_PHConQueType
ClassMethod UpdatePhConQueType(DataList) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdateQueType(TmpStr)
	.e  d
	..s ret=..InsertQueType(TmpStr)
	q 0
}

/// Descript:update 更新问题类别 DHC_PHConQueType记录
ClassMethod UpdateQueType(DataList) As %String
{
	N (DataList)
	S rowid=$p(DataList,"^",1)
	S code=$p(DataList,"^",2) 
	S desc=$p(DataList,"^",3)
	&SQL(UPDATE DHC_PHConQueType Set PHCONQT_Code=:code,PHCONQT_Desc=:desc
 		WHERE PHCONQT_RowID=:rowid)
 	Q SQLCODE
}

/// Descript:Insert 更新问题类别 DHC_PHConQueType 记录
ClassMethod InsertQueType(DataList) As %String
{
	N (DataList)
	S code=$p(DataList,"^",2) 
	S desc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_PHConQueType(PHCONQT_Code,PHCONQT_Desc)
 		VALUES(:code,:desc))
 	Q SQLCODE
}

/// Descript:Delete 删除问题类别 DHC_PHConQueType 记录
ClassMethod DeleteQueType(rowid) As %String
{
	N (rowid)
	&SQL(DELETE FROM DHC_PHConQueType WHERE PHCONQT_RowID=:rowid)
	Q SQLCODE
}

/// pengzhikun
/// 2014-08-26
/// 查询咨询记录列表
/// w ##class("web.DHCPHCONSULT").QueryResultList("10","1","^^^2014-11-13^2014-11-13")
ClassMethod QueryResultList(rows, page, input) As %String
{
	n (rows,page,input)
	
	s role=""
	s ctloc=""
	s userType=""
	s personname=""
	s patSex=""
	s patDob=""
	s patTel=""
	s SpeCrowd=""  ;患者 --特殊人群
	s chrDisease=""   ;患者--慢性病
	s remark=""       ;患者--备注
	
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s queDr=$p(input,"^",1)
	s userDr=$p(input,"^",2)
	s ctlocDr=$p(input,"^",3)
	s stdate=$p(input,"^",4)
	s stdate=$zdh(stdate,3)
	s enddate=$p(input,"^",5)
	s enddate=$zdh(enddate,3)
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s rowid=""
	s h=0
	s fdate=0
	f fdate=stdate:1:enddate  d
	.;查询时,如果问题类型不存在
	.i queDr=""  d
	..s queDr=0
	..f  s queDr=$o(^DHCPHCONS(0,"DATEQETYPE",fdate,queDr)) q:queDr=""  d
	...s phrid=0
	...f  s phrid=$o(^DHCPHCONS(0,"DATEQETYPE",fdate,queDr,phrid)) q:phrid=""  d
	....s rowid=phrid
	....;判断有无回复
	....s PHCDSubid=0
	....s answerFlag=0
	....s hasAnswer=""
	....s stdRepFlag="N"   
	....s hasStdAnswer=""  ;有无标准回复
	....f  s PHCDSubid=$o(^DHCPHCOND(rowid,"I",PHCDSubid)) q:(PHCDSubid="")||(answerFlag=1)  d
	.....s stdRepFlag=$p(^DHCPHCOND(rowid,"I",PHCDSubid),"^",6)
	.....s answerFlag=1
	....i answerFlag=0 s hasAnswer="无"
	....i answerFlag=1 s hasAnswer="有"
	....
	....s askdate=$p(^DHCPHCONS(rowid),"^",1)
	....s askdate=$zd(askdate,3)
	....s userdr=$p(^DHCPHCONS(rowid),"^",3)
	....s finishFlag=$p(^DHCPHCONS(rowid),"^",7)
	....;有无标准回复
	....i finishFlag="Y" s hasStdAnswer="有"
	....e  s hasStdAnswer="无"
	....s userType=$p(^DHCPHCONS(rowid),"^",9)
	....i userType="1"  d
	.....s role="医生/护士"
	.....s personname=$P(^SSU("SSUSR",userdr),"^",2)
	....e  i userType="2"  d
	.....s role="患者/家属"
	.....s personname=$p(^PAPER(userdr,"ALL"),"^",1)
	.....s sexDr=$p(^PAPER(userdr,"ALL"),"^",7)
	.....s patSex=$p(^CT("SEX",sexDr),"^",2)
	.....s dob=$p(^PAPER(userdr,"ALL"),"^",6)
	.....s patDob=$zd(dob,3)
	.....s patTel=$p(^PAPER(userdr,"PER",1),"^",11)
	.....s patSpeCrowd=$p(^DHCPHCONS(rowid),"^",10)
	.....s length=$L(patSpeCrowd,"|")
	.....f m=1:1:length  d
	......s desc=$p(^DHCPHCONSC($p(patSpeCrowd,"|",m)),"^",2)
	......i SpeCrowd="" s SpeCrowd=desc
	......e  s SpeCrowd=SpeCrowd_","_desc
	.....s chrDisease=$p(^DHCPHCONS(rowid),"^",11)
	.....s remark=$p(^DHCPHCONS(rowid),"^",12)
	....
	....s ctlocdr=$p(^DHCPHCONS(rowid),"^",5)
	....q:(ctlocdr'=ctlocDr)&&(ctlocDr'="")
	....i ctlocdr'="" s ctloc=$P(^CTLOC(ctlocdr),"^",2)
	....s question=$p(^DHCPHCONS(rowid),"^",6)
	....s questionkindDr=$p(^DHCPHCONS(rowid),"^",8)
	....s questionkinds=$p(^DHCPHCONQT(questionkindDr),"^",2)
	....s detailinfo="详细信息"
	....s drugs=""
	....s phitmsubid=0
	....s Flag=0
	....f  s phitmsubid=$o(^DHCPHCONI(rowid,"D",phitmsubid)) q:phitmsubid=""  d
	.....s Flag=Flag+1
	.....s drugDr=$p(^DHCPHCONI(rowid,"D",phitmsubid),"^",1)
	.....s drugName=$p(^INCI(drugDr,1),"^",2)
	.....;过滤掉药品名中的逗号,换成"-"
	.....s drugName=$tr(drugName,",","-")
	.....i Flag=1 s drugs=drugName
	.....e  s drugs=drugs_","_drugName	    
	....s h=h+1
	....s data=askdate_"^"_questionkinds_"^"_drugs_"^"_role_"^"_personname_"^"_question_"^"_detailinfo_"^"_ctloc_"^"_rowid_"^"_hasAnswer_"^"_hasStdAnswer_"^"_SpeCrowd_"^"_chrDisease_"^"_remark_"^"_patSex_"^"_patDob_"^"_patTel
	....s ^TMP("DHCST","DHCPHCONSULT","QueryResultList",pid,h)=data
	.e  d
	..s phrid=0
	..f  s phrid=$o(^DHCPHCONS(0,"DATEQETYPE",fdate,queDr,phrid)) q:phrid=""  d
	...s rowid=phrid
	...;判断有无回复
	...s PHCDSubid=0
	...s answerFlag=0
	...s hasAnswer=""     ;有无回复
	...s stdRepFlag="N"   
	...s hasStdAnswer=""  ;有无标准回复
	...f  s PHCDSubid=$o(^DHCPHCOND(rowid,"I",PHCDSubid)) q:(PHCDSubid="")||(answerFlag=1)  d
	....s stdRepFlag=$p(^DHCPHCOND(rowid,"I",PHCDSubid),"^",6)
	....s answerFlag=1
	...i answerFlag=0 s hasAnswer="无"
	...i answerFlag=1 s hasAnswer="有"
	...;有无标准回复
	...i (answerFlag=1)&&(stdRepFlag="Y") s hasStdAnswer="有"
	...i stdRepFlag="N" s hasStdAnswer="无"
	...
	...s askdate=$p(^DHCPHCONS(phrid),"^",1)
	...s askdate=$zd(askdate,3)
	...s userdr=$p(^DHCPHCONS(phrid),"^",3)
	...s userType=$p(^DHCPHCONS(rowid),"^",9)
	...i userType="1"  d
	....s role="医生/护士"
	....s personname=$P(^SSU("SSUSR",userdr),"^",2)
	...e  i userType="2"  d
	....s role="患者/家属"
	....s personname=$p(^PAPER(userdr,"ALL"),"^",1)
	....s sexDr=$p(^PAPER(userdr,"ALL"),"^",7)
	....s patSex=$p(^CT("SEX",sexDr),"^",2)
	....s dob=$p(^PAPER(userdr,"ALL"),"^",6)
	....s patDob=$zd(dob,3)
	....s patTel=$p(^PAPER(userdr,"PER",1),"^",11)
	....s patSpeCrowd=$p(^DHCPHCONS(rowid),"^",10)
	....s length=$L(patSpeCrowd,"|")
	....f m=1:1:length  d
	.....s desc=$p(^DHCPHCONSC($p(patSpeCrowd,"|",m)),"^",2)
	.....i SpeCrowd="" s SpeCrowd=desc
	.....e  s SpeCrowd=SpeCrowd_","_desc
	....s chrDisease=$p(^DHCPHCONS(rowid),"^",11)
	....s remark=$p(^DHCPHCONS(rowid),"^",12)
	...
	...s ctlocdr=$p(^DHCPHCONS(phrid),"^",5)
	...q:(ctlocdr'=ctlocDr)&(ctlocDr'="")
	...i ctlocdr'="" s ctloc=$P(^CTLOC(ctlocdr),"^",2)
	...s question=$p(^DHCPHCONS(phrid),"^",6)
	...s questionkindDr=$p(^DHCPHCONS(phrid),"^",8)
	...s questionkinds=$p(^DHCPHCONQT(questionkindDr),"^",2)
	...s detailinfo="详细信息"
	...s drugs=""
	...s phitmsubid=0
	...s Flag=0
	...f  s phitmsubid=$o(^DHCPHCONI(phrid,"D",phitmsubid)) q:phitmsubid=""  d
	....s Flag=Flag+1
	....s drugDr=$p(^DHCPHCONI(phrid,"D",phitmsubid),"^",1)
	....s drugName=$p(^INCI(drugDr,1),"^",2)
	....;过滤掉药品名中的逗号,换成"-"
	....s drugName=$tr(drugName,",","-")
	....i Flag=1 s drugs=drugName
	....e  s drugs=drugs_","_drugName	    
	...s h=h+1
	...s data=askdate_"^"_questionkinds_"^"_drugs_"^"_role_"^"_personname_"^"_question_"^"_detailinfo_"^"_ctloc_"^"_rowid_"^"_hasAnswer_"^"_hasStdAnswer_"^"_SpeCrowd_"^"_chrDisease_"^"_remark_"^"_patSex_"^"_patDob_"^"_patTel
	...s ^TMP("DHCST","DHCPHCONSULT","QueryResultList",pid,h)=data
	

	    
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
    i endpage>maxrow s endpage=maxrow
	
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCPHCONSULT","QueryResultList",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCPHCONSULT","QueryResultList",pid,h)
	.s askdate=$p(data,"^",1)
	.s questionkinds=$p(data,"^",2)
	.s drugs=$p(data,"^",3)
	.s role=$p(data,"^",4)
	.s personname=$p(data,"^",5)
	.s question=$p(data,"^",6)
	.s detailinfo=$p(data,"^",7)
	.s ctloc=$p(data,"^",8)
	.s rowid=$p(data,"^",9)
	.s hasAnswer=$p(data,"^",10)
	.s hasStdAnswer=$p(data,"^",11)
	.s speCrowd=$p(data,"^",12)
	.s chrDisease=$p(data,"^",13)
	.s remark=$p(data,"^",14)
	.s patSex=$p(data,"^",15)
	.s patDob=$p(data,"^",16)
	.s patTel=$p(data,"^",17)
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("rowid",rowid)
	.s askdate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("askdate",askdate) 
	.s questionkinds=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("questionkinds",questionkinds)
	.s drugs=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("drugs",drugs)
	.s role=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("role",role)
	.s personname=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("personname",personname)
	.s ctloc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("ctloc",ctloc)
	.s question=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("question",question)
	.s hasAnswer=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("hasAnswer",hasAnswer)
	.s hasStdAnswer=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("hasStdAnswer",hasStdAnswer)
	.s speCrowd=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("speCrowd",speCrowd)
	.s chrDisease=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("chrDisease",chrDisease)
	.s remark=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("remark",remark)
	.s patSex=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patSex",patSex)
	.s patDob=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patDob",patDob)
	.s patTel=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patTel",patTel)
	.s detailinfo=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("detailinfo",detailinfo)
	.
	.s tmpstr=rowid_askdate_questionkinds_drugs_role_personname_ctloc_question_hasAnswer_hasStdAnswer_speCrowd_chrDisease_remark_patSex_patDob_patTel_detailinfo
	.s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	.s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	.s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("DHCST","DHCPHCONSULT","QueryResultList",pid)
	q ""
}

/// pengzhikun
/// 2014-08-26
/// 查询咨询记录列表
/// w ##class("web.DHCPHCONSULT").QueryQuestioningList("10","1")
ClassMethod QueryQuestioningList(rows, page) As %String
{
	//askdate questionkinds drugs role personname question detailinfo
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	
	s role=""
	s ctloc=""
	s userType=""
	s personname=""
	s patSex=""
	s patDob=""
	s patTel=""
	s SpeCrowd=""     ;患者 --特殊人群
	s chrDisease=""   ;患者--慢性病
	s remark=""       ;患者--备注

	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	    
	s h=0
	s phrid=0
	f  s phrid=$o(^DHCPHCONS(phrid)) q:phrid=""  d
	.s rowid=phrid
	.s askdate=$p(^DHCPHCONS(phrid),"^",1)
	.s askdate=$zd(askdate,3)
	.s userdr=$p(^DHCPHCONS(phrid),"^",3)
	.;q:userdr=""
	.s userType=$p(^DHCPHCONS(phrid),"^",9)
	.;q:userType=""
	.i userType="1"  d
	..s role="医生/护士"
	..s personname=$P(^SSU("SSUSR",userdr),"^",2)
	.e  i userType="2"  d
	..s role="患者/家属"
	..s personname=$p(^PAPER(userdr,"ALL"),"^",1)
	..s sexDr=$p(^PAPER(userdr,"ALL"),"^",7)
	..s patSex=$p(^CT("SEX",sexDr),"^",2)
	..s dob=$p(^PAPER(userdr,"ALL"),"^",6)
	..s patDob=$zd(dob,3)
	..s patTel=$p(^PAPER(userdr,"PER",1),"^",11)
	..s patSpeCrowd=$p(^DHCPHCONS(rowid),"^",10)
	..s length=$L(patSpeCrowd,"|")
	..f m=1:1:length  d
	...s desc=$p(^DHCPHCONSC($p(patSpeCrowd,"|",m)),"^",2)
	...i SpeCrowd="" s SpeCrowd=desc
	...e  s SpeCrowd=SpeCrowd_","_desc
	...s chrDisease=$p(^DHCPHCONS(rowid),"^",11)
	...s remark=$p(^DHCPHCONS(rowid),"^",12)
	.s ctlocdr=$p(^DHCPHCONS(phrid),"^",5)
	.i ctlocdr'="" s ctloc=$P(^CTLOC(ctlocdr),"^",2)
	.s question=$p(^DHCPHCONS(phrid),"^",6)
	.s finishFlag=$p(^DHCPHCONS(phrid),"^",7)
	.q:finishFlag="Y" //有标准答案，就不用出现在待回复列表
	.s questionkindDr=$p(^DHCPHCONS(phrid),"^",8)
	.s questionkinds=$p(^DHCPHCONQT(questionkindDr),"^",2)
	.s detailinfo="回复"
	.s drugs=""
	.s phitmsubid=0
	.s Flag=0
	.f  s phitmsubid=$o(^DHCPHCONI(phrid,"D",phitmsubid)) q:phitmsubid=""  d
	..s Flag=Flag+1
	..s drugDr=$p(^DHCPHCONI(phrid,"D",phitmsubid),"^",1)
	..s drugName=$p(^INCI(drugDr,1),"^",2)
	..;过滤掉药品名中的逗号,换成"-"
	..s drugName=$tr(drugName,",","-")
	..i Flag=1 s drugs=drugName
	..e  s drugs=drugs_","_drugName	    
	.s h=h+1
	.s data=askdate_"^"_questionkinds_"^"_drugs_"^"_role_"^"_personname_"^"_question_"^"_detailinfo_"^"_ctloc_"^"_rowid_"^"_SpeCrowd_"^"_chrDisease_"^"_remark_"^"_patSex_"^"_patDob_"^"_patTel
	.s ^TMP("DHCST","DHCPHCONSULT","QueryQuestioningList",pid,h)=data
	    
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
    
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCPHCONSULT","QueryQuestioningList",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCPHCONSULT","QueryQuestioningList",pid,h)
	.s askdate=$p(data,"^",1)
	.s questionkinds=$p(data,"^",2)
	.s drugs=$p(data,"^",3)
	.s role=$p(data,"^",4)
	.s personname=$p(data,"^",5)
	.s question=$p(data,"^",6)
	.s detailinfo=$p(data,"^",7)
	.s ctloc=$p(data,"^",8)
	.s rowid=$p(data,"^",9)
	.s speCrowd=$p(data,"^",10)
	.s chrDisease=$p(data,"^",11)
	.s remark=$p(data,"^",12)
	.s patSex=$p(data,"^",13)
	.s patDob=$p(data,"^",14)
	.s patTel=$p(data,"^",15)
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("rowid",rowid) 
	.s askdate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("askdate",askdate) 
	.s questionkinds=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("questionkinds",questionkinds)
	.s drugs=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("drugs",drugs)
	.s role=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("role",role)
	.s personname=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("personname",personname)
	.s ctloc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("ctloc",ctloc)
	.s question=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("question",question)
	.s speCrowd=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("speCrowd",speCrowd)
	.s chrDisease=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("chrDisease",chrDisease)
	.s remark=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("remark",remark)
	.s patSex=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patSex",patSex)
	.s patDob=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patDob",patDob)
	.s patTel=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patTel",patTel) 
	.s detailinfo=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("detailinfo",detailinfo)
	.
	.s tmpstr=rowid_askdate_questionkinds_drugs_role_personname_ctloc_question_speCrowd_chrDisease_remark_patSex_patDob_patTel_detailinfo
	.s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	.s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	.s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("DHCST","DHCPHCONSULT","QueryQuestioningList",pid)
	q ""
}

/// 根据药品别名查询药品信息
/// d ##class("web.DHCPHCONSULT").FindDrugsByAlias("10","1","lhn")
ClassMethod FindDrugsByAlias(rows, page, Input) As %Library.String
{
    n (Input,page, rows)
    s Input="%"_$$ALPHAUP^SSUTIL4(Input)_"%"
    
    s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s h=0
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	    
    s cnt=..FindItmByStkGrp(Input,"","G")
    q:cnt<1 "" 
    f i=1:1:cnt  d 
	. s INCI=##class(web.DHCSTITMDESC).ListItms(i)
	. s incirowid=$p(INCI,"^",1)
	. s incicode=$p(INCI,"^",2)
	. s incidesc=$p(INCI,"^",3)
	. s genericdesc=""
	. s drgmastRid=0
	. f  s drgmastRid=$o(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(incicode),drgmastRid)) q:drgmastRid=""  d
	. . s DrgGenericDr=$p(^PHCD(drgmastRid,4),"^",1)
	. . s genericdesc=$p(^PHCGE("GE",DrgGenericDr),"^",2)
    . s h = h+1
    . s data=incirowid_"^"_incidesc_"^"_genericdesc
    . s ^TMP("DHCST","DHCPHCONSULT","FindDrugsByAlias",pid,h)=data
    
    
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
    
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCPHCONSULT","FindDrugsByAlias",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCPHCONSULT","FindDrugsByAlias",pid,h)
	.s incirowid=$p(data,"^",1)
	.s incidesc=$p(data,"^",2)
	.s genericdesc=$p(data,"^",3)
	.s incirowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("incirowid",incirowid) 
	.s incidesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("incidesc",incidesc)
	.s genericdesc=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("genericdesc",genericdesc)
	.s tmpstr=incirowid_incidesc_genericdesc
	.s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	.s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	.s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
	.i count<maxrow w firstrow
	.i count=maxrow w lastrow
	.
	k ^TMP("DHCST","DHCPHCONSULT","FindDrugsByAlias",pid)
	q ""
}

ClassMethod FindItmByStkGrp(input, stkgrpcode, stkgrptype) As %String
{
	n (input,stkgrpcode,stkgrptype,%session)
	s input=$g(input),stkgrpcode=$g(stkgrpcode),stkgrptype=$g(stkgrptype) 
	;s LocID=$g(%session.Data("LOGON.CTLOCID"))
	;s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(LocID)
	s num=1
	k ^TMP($j,"Itmrowid"),^TMP($j,"Itmcode"),^TMP($j,"Itmdesc"),^TMP($j,"ItmUO")
	i stkgrpcode'="" d
	.&sql(DECLARE cur CURSOR FOR
	        select distinct inca_inci_dr    from inc_alias 
	         where %ALPHAUP(inca_text) %STARTSWITH %ALPHAUP(:input))  
	.&sql(OPEN cur)
	.f  &sql(fetch cur into :inci)  q:SQLCODE  d
	..q:'$d(^INCI(inci,1))
	..q:##class(web.DHCSTITMDESC).CatGrpCode(inci)'=stkgrpcode     
	..
	..//q:'$d(^INCI("IL_LOC",LocID,inci))&(HospString'="") 
	..s ^TMP($j,"Itmrowid",num)=inci
	..s ^TMP($j,"Itmcode",num)=$p(^INCI(^TMP($j,"Itmrowid",num),1),"^",1)
	..s ^TMP($j,"Itmdesc",num)=$p(^INCI(^TMP($j,"Itmrowid",num),1),"^",2)
	..s uomdr=$p(^INCI(^TMP($j,"Itmrowid",num),1),"^",10)
	..s ^TMP($j,"ItmUO",num)="" i uomdr'="" s ^TMP($j,"ItmUO",num)=$p(^CT("UOM",+uomdr),"^",2)
	..s num=num+1
	..
	.&sql(close cur)
	e  d
	.i stkgrptype="" d
	..&sql(DECLARE curt CURSOR FOR
	        select distinct inca_inci_dr   from inc_alias 
	         where %ALPHAUP(inca_text) %STARTSWITH %ALPHAUP(:input))  
	..&sql(OPEN curt)
	..f  &sql(fetch curt into :inci)  q:SQLCODE  d
	...q:'$d(^INCI(inci,1))
	...s ^TMP($j,"Itmrowid",num)=inci
	...s ^TMP($j,"Itmcode",num)=$p(^INCI(inci,1),"^",1)
	...s ^TMP($j,"Itmdesc",num)=$p(^INCI(inci,1),"^",2)
	...s uomdr=$p(^INCI(inci,1),"^",10)
	...s ^TMP($j,"ItmUO",num)="" i uomdr'="" s ^TMP($j,"ItmUO",num)=$p(^CT("UOM",+uomdr),"^",2)
	...s num=num+1
	..&sql(close curt)
	.e  d
	..&sql(DECLARE curtt CURSOR FOR
	        select distinct inca_inci_dr from inc_alias 
	         where %ALPHAUP(inca_text) %STARTSWITH %ALPHAUP(:input))  
	..&sql(OPEN curtt)
	..f  &sql(fetch curtt into :inci )  q:SQLCODE  d
	...q:##class(web.DHCSTITMDESC).CatType(inci)'=stkgrptype
	...;q:'$d(^INCI("IL_LOC",LocID,inci))&(HospString'="") 
	...s ^TMP($j,"Itmrowid",num)=inci
	...s ^TMP($j,"Itmcode",num)=$p(^INCI(inci,1),"^",1)
	...s ^TMP($j,"Itmdesc",num)=$p(^INCI(inci,1),"^",2)
	...s uomdr=$p(^INCI(inci,1),"^",10)
	...s ^TMP($j,"ItmUO",num)="" i uomdr'="" s ^TMP($j,"ItmUO",num)=$p(^CT("UOM",+uomdr),"^",2)
	...s num=num+1
	..&sql(close curtt)
	s P5=num-1 
	q P5
}

/// w ##class("web.DHCPHCONSULT").SaveQuestion("23565^791^1^1^2014-09-12^你的名字是||30664^31439^")
/// pengzhikun  2014-09-13
/// 添加咨询问题
/// 插入数据到DHC_PHConsult,DHC_PHConsultItm
ClassMethod SaveQuestion(input) As %String
{
	;23565^791^1^1^2014-09-12^你的名字是||30664^31439^
	n (input)
	
	Set $ZT="ErrorSave"	
	TSTART
		
	s parentDateList=$p(input,"||",1)
	s drugItmList=$p(input,"||",2)
	
 	k PLIST
 	S PLIST=13
 	f i=1:1:13  s PLIST(i)=""
 	s PLIST(2)=$zdh($P(parentDateList,"^",5),3)
 	s PLIST(3)=""
 	s PLIST(4)=$P(parentDateList,"^",1)    ;咨询人ID
 	s PLIST(5)=$P(parentDateList,"^",3)    ;咨询类型
 	s PLIST(6)=$P(parentDateList,"^",2)    ;咨询开始id
 	s PLIST(7)=$P(parentDateList,"^",6)    ;问题描述
 	s PLIST(8)="N"                         ;问题置完成标志
 	s PLIST(9)=$P(parentDateList,"^",4)    ;问题类别
 	s PLIST(10)=$P(parentDateList,"^",7)   ;咨询人类型
 	s speCrowdList=$P(parentDateList,"^",8)   ;特殊人群
 	s PLIST(11)=$tr(speCrowdList,",","||")
 	s PLIST(12)=$P(parentDateList,"^",9)   ;慢性病
 	s PLIST(13)=$P(parentDateList,"^",10)  ;备注
 	&sql(insert into DHC_PHConsult values:PLIST())
 	if SQLCODE'=0
	{
		TRollBack
		q SQLCODE
		;s ret=""
	}
	s phrid=$g(%ROWID)
	
	s SQLCODE=0
	s i=0
	///子表操作
	s length=$L(drugItmList,"^")-1
	K LIST
	s LIST=4
	f i=1:1:4  s LIST(i)=""
	f i=1:1:length q:(phrid="")!(SQLCODE'=0)  d
	.S LIST(0)=phrid
	.S LIST(2)=+$o(^DHCPHCONI(phrid,"D",""),-1)+1
	.S LIST(3)=$P(drugItmList,"^",i)
	.&sql(insert into DHC_PHConsultItm  values :LIST())
	
	if SQLCODE'=0
 	{  
		TRollBack
		q SQLCODE
 	}
 	
 	TCOMMIT
 	
 	q SQLCODE
 	
ErrorSave
	TRollBack
	set error=$ZE
	q "保存失败"
	;s json=##class(%ArrayOfDataTypes).%New()
	;d json.SetAt($g(error),"ErrorInfo")
	;q ##class(Nur.JSON).Encode(json)
}

/// pengzhikun 2014-09-15
/// 插入回复答案 DHC_PHConsultDetail
/// w ##class("web.DHCPHCONSULT").SubmitAnswer("4^21672^penzi^^3,4")
ClassMethod SubmitAnswer(input) As %String
{
	s phrid=$p(input,"^",1)
	q:phrid="" ""
	s userid=$p(input,"^",2)
	q:userid="" ""
	s answer=$p(input,"^",3)
	//被回复DHC_PHConsultDetail明细的rowid
	s phdelrid=$p(input,"^",4)
	s conBasLists=$p(input,"^",5)	
	s conBasLists=$tr(conBasLists,",","||")
	
	K LIST
	f i=0:1:9  s LIST(i)=""
	S LIST(0)=phrid
	S LIST(8)=+$o(^DHCPHCOND(phrid,"I",""),-1)+1
	s date=$p($h,",",1)
	s time=$p($h,",",2)
	S LIST(2)=date
	S LIST(3)=time
	S LIST(4)=userid
	S LIST(5)=answer
	S LIST(6)=phdelrid
	S LIST(7)="N"
	s LIST(9)=conBasLists
	&sql(insert into DHC_PHConsultDetail  values :LIST())
	q SQLCODE
}

/// d ##class("web.DHCPHCONSULT").GetAllAnswer("2")
ClassMethod GetAllAnswer(phrid)
{
	
	n (phrid)
	s StPage=0
    s Limit=99999
	s h=0
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s endpage=StPage+Limit  //结束行
	s StPage=StPage+1 //开始行
	
	s PHCDSubid=0	
	f  s PHCDSubid=$o(^DHCPHCOND(phrid,"I",PHCDSubid)) q:PHCDSubid=""  d
	.s detailRid=phrid_"||"_PHCDSubid
	.s answerDate=$p(^DHCPHCOND(phrid,"I",PHCDSubid),"^",1)
	.s answerDate=$zd(answerDate,3)
	.s answerTime=$p(^DHCPHCOND(phrid,"I",PHCDSubid),"^",2)
	.s answerTime=$zt(answerTime,3)
	.s userid=$p(^DHCPHCOND(phrid,"I",PHCDSubid),"^",3)
	.s username=$P(^SSU("SSUSR",userid),"^",2)
	.s answer=$p(^DHCPHCOND(phrid,"I",PHCDSubid),"^",4)
	.//被回复的子表id
	.s phdelrid=$p(^DHCPHCOND(phrid,"I",PHCDSubid),"^",5)
	.s ansUsername=""
	.//被回复的人ID
	.i (phdelrid'="")&&((phdelrid'=0))  d
	..s ansUserid=$p(^DHCPHCOND($p(phdelrid,"||",1),"I",$p(phdelrid,"||",2)),"^",3)
	..s ansUsername=$P(^SSU("SSUSR",ansUserid),"^",2)
	.s okFlag=$p(^DHCPHCOND(phrid,"I",PHCDSubid),"^",6)
	.s conBasLists=$p(^DHCPHCOND(phrid,"I",PHCDSubid),"^",7)
	.s ret=""
	.i conBasLists'="" s ret=..getConBasLists(conBasLists)
	.s h=h+1
	.s data=username_"^"_answer_"^"_answerDate_"^"_answerTime_"^"_detailRid_"^"_ansUsername_"^"_okFlag_"^"_ret
	.s ^TMP("DHCST","DHCPHCONSULT","GetAllAnswer",pid,h)=data
	
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	
 	s maxrow=h
 	i endpage>maxrow s endpage=maxrow

    s h=""
    s count=0
    f  s h=$o(^TMP("DHCST","DHCPHCONSULT","GetAllAnswer",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCPHCONSULT","GetAllAnswer",pid,h)
    .s username=$p(data,"^",1)
    .s answer=$p(data,"^",2)
    .s answerDate=$p(data,"^",3)
    .s answerTime=$p(data,"^",4)
    .s detailRid=$p(data,"^",5)
    .s ansUsername=$p(data,"^",6)
    .s okFlag=$p(data,"^",7)
    .s basList=$p(data,"^",8)
    .
    .s username=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("username",username)
    .s answerDate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("answerDate",answerDate)
    .s answerTime=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("answerTime",answerTime)
    .s ansUsername=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("ansUsername",ansUsername)
    .s detailRid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("detailRid",detailRid)
    .s basList=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("basList",basList)
    .s okFlag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("okFlag",okFlag)
	.s answer=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("answer",answer)
	.
	.s tmpstr=username_answerDate_answerTime_ansUsername_detailRid_basList_okFlag_answer
	.s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	.s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	.s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
	.i count<maxrow w firstrow
	.i count=maxrow w lastrow
	.
	k ^TMP("DHCST","DHCPHCONSULT","GetAllAnswer",pid)
	q ""
}

//w ##class("web.DHCPHCONSULT").getConBasLists("2")

ClassMethod getConBasLists(conBasLists)
{
	n (conBasLists)
	s length=$l(conBasLists,"|")
	s result=""
	f i=1:1:length  d
	.s conBasRid=$p(conBasLists,"|",i)
	.s desc=$P(^DHCPHCONTB(conBasRid),"^",2)
	.i result="" s result=desc
	.e  s result=result_"|"_desc
	q result
}

/// pengzhikun --- 2014-10-30
/// 回复依据列表
/// d ##class("web.DHCPHCONSULT").getPhConBasInfo("100","1")
ClassMethod getPhConBasInfo(rows, page) As %String
{
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s h=0
	s phConBasRid=0
    f  s phConBasRid=$o(^DHCPHCONTB(phConBasRid)) q:(phConBasRid="")||(phConBasRid=0)  d
    .s h=h+1
    .s PhContBCode=$p(^DHCPHCONTB(phConBasRid),"^",1)
    .s PhContBDesc=$p(^DHCPHCONTB(phConBasRid),"^",2)
    .s rowid=phConBasRid
    .s data=PhContBCode_"^"_PhContBDesc_"^"_rowid
    .s ^TMP("DHCST","DHCPHCONSULT","getPhConBasInfo",pid,h)=data
    
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s maxrow=h
	i endpage>maxrow s endpage=maxrow
	
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCPHCONSULT","getPhConBasInfo",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCPHCONSULT","getPhConBasInfo",pid,h)
	.s PhContBCode=$p(data,"^",1)
	.s PhContBDesc=$p(data,"^",2)
	.s rowid=$p(data,"^",3)
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
	.s PhContBCode=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PhContBCode",PhContBCode)
	.s PhContBDesc=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PhContBDesc",PhContBDesc)
	.s rowid=##Class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=PhContBCode_PhContBDesc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    k ^TMP("DHCST","DHCSTPHCMFUNLIB","getPhConBasInfo",pid)

	q ""
}

/// pengzhikun --- 2014-10-30 
/// 更新咨询类别 DHC_PHConsultBasis
/// w ##class(web.DHCPHCONSULT).UpdatePhConBas("^001^药品说明书")
ClassMethod UpdatePhConBas(DataList) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdateBas(TmpStr)
	.e  d
	..s ret=..InsertBas(TmpStr)
	q 0
}

/// Descript:update 更新回复依据 DHC_PHConsultBasis记录
ClassMethod UpdateBas(DataList) As %String
{
	N (DataList)
	S rowid=$p(DataList,"^",1)
	S code=$p(DataList,"^",2) 
	S desc=$p(DataList,"^",3)
	&SQL(UPDATE DHC_PHConsultBasis Set PHCONTB_Code=:code,PHCONTB_Desc=:desc
 		WHERE PHCONTB_RowID=:rowid)
 	Q SQLCODE
}

/// Descript:Insert 更新回复依据 DHC_PHConsultBasis 记录
ClassMethod InsertBas(DataList) As %String
{
	N (DataList)
	S code=$p(DataList,"^",2) 
	S desc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_PHConsultBasis(PHCONTB_Code,PHCONTB_Desc)
 		VALUES(:code,:desc))
 	Q SQLCODE
}

/// Descript:delete 更新回复依据 DHC_PHConsultBasis 记录
ClassMethod DeleteBas(rowid) As %String
{
	N (rowid)
	&SQL(DELETE FROM DHC_PHConsultBasis WHERE PHCONTB_RowID=:rowid)
	Q SQLCODE
}

//w ##class(web.DHCPHCONSULT).SetOkFlag("4||1")

ClassMethod SetOkFlag(detailRid)
{

	q:detailRid="" ""
    s patRowid=$p(detailRid,"||",1)
	s finishFlag=$p(^DHCPHCONS(patRowid),"^",7)
	i finishFlag="Y" q "-1"
	
	Ts
	s Flag="Y"
	s SQLCODE=0
	&sql(update DHC_PHConsultDetail set PHCONTD_OkFlag=:Flag where PHCONTD_RowID=:detailRid)
	i SQLCODE'=0
	{
		TRO
		Q SQLCODE
	}
	
	s patRowid=$p(detailRid,"||",1)
	s finishFlag=$p(^DHCPHCONS(patRowid),"^",7)
	i finishFlag="N" s finishFlag="Y"
	&sql(update DHC_PHConsult set PHCON_FinishFlag=:finishFlag where PHCON_RowID=:patRowid)
	i SQLCODE'=0
	{
		TRO
		Q SQLCODE
	}
	
	TC
	q SQLCODE
}

/// w ##class("web.DHCPHCONSULT").GetConBas()
ClassMethod GetConBas()
{
	s StPage=0
    s Limit=99999
	s h=0
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s endpage=StPage+Limit  //结束行
	s StPage=StPage+1 //开始行
	
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s h=0
	s phConBasRid=0
    f  s phConBasRid=$o(^DHCPHCONTB(phConBasRid)) q:(phConBasRid="")||(phConBasRid=0)  d
    .s h=h+1
    .s PhContBCode=$p(^DHCPHCONTB(phConBasRid),"^",1)
    .s PhContBDesc=$p(^DHCPHCONTB(phConBasRid),"^",2)
    .s rowid=phConBasRid
    .s data=PhContBCode_"^"_PhContBDesc_"^"_rowid
    .s ^TMP("DHCST","DHCPHCONSULT","GetConBas",pid,h)=data
	
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	
 	s maxrow=h
 	i endpage>maxrow s endpage=maxrow

    s h=""
    s count=0
    f  s h=$o(^TMP("DHCST","DHCPHCONSULT","GetConBas",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCPHCONSULT","GetConBas",pid,h)
    .s PhContBCode=$p(data,"^",1)
    .s PhContBDesc=$p(data,"^",2)
    .s rowid=$p(data,"^",3)
    .
    .s PhContBCode=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PhContBCode",PhContBCode)
	.s PhContBDesc=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PhContBDesc",PhContBDesc)
	.s rowid=##Class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=PhContBCode_PhContBDesc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
    .
	.s count=count+1
	.i count=1 w startString
	.i count<maxrow w firstrow
	.i count=maxrow w lastrow
	.
	k ^TMP("DHCST","DHCPHCONSULT","GetConBas",pid)
	q ""
}

/// pengzhikun --- 2014-10-30
/// 回复依据列表
/// d ##class("web.DHCPHCONSULT").GetSpeCrdInfo("100","1")
ClassMethod GetSpeCrdInfo(rows, page) As %String
{
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s h=0
	s speCrdRid=0
    f  s speCrdRid=$o(^DHCPHCONSC(speCrdRid)) q:(speCrdRid="")||(speCrdRid=0)  d
    .s h=h+1
    .s code=$p(^DHCPHCONSC(speCrdRid),"^",1)
    .s desc=$p(^DHCPHCONSC(speCrdRid),"^",2)
    .s rowid=speCrdRid
    .s data=code_"^"_desc_"^"_rowid
    .s ^TMP("DHCST","DHCPHCONSULT","GetSpeCrdInfo",pid,h)=data
    
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s maxrow=h
	i endpage>maxrow s endpage=maxrow
	
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCPHCONSULT","GetSpeCrdInfo",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCPHCONSULT","GetSpeCrdInfo",pid,h)
	.s code=$p(data,"^",1)
	.s desc=$p(data,"^",2)
	.s rowid=$p(data,"^",3)
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
	.s code=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	.s desc=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##Class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=code_desc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    k ^TMP("DHCST","DHCPHCONSULT","GetSpeCrdInfo",pid)

	q ""
}

/// pengzhikun --- 2014-11-1 
/// 更新特殊人群 DHC_PHConSpCrowd
/// w ##class(web.DHCPHCONSULT).UpdateSpCrowd("")
ClassMethod UpdateSpCrowd(DataList) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdateSpeCrd(TmpStr)
	.e  d
	..s ret=..InsertSpeCrd(TmpStr)
	q 0
}

/// Descript:update 更新特殊人群 DHC_PHConSpCrowd记录
ClassMethod UpdateSpeCrd(DataList) As %String
{
	N (DataList)
	S rowid=$p(DataList,"^",1)
	S code=$p(DataList,"^",2) 
	S desc=$p(DataList,"^",3)
	&SQL(UPDATE DHC_PHConSpCrowd Set PHConSpCd_Code=:code,PHConSpCd_Desc=:desc
 		WHERE PHConSpCd_RowID=:rowid)
 	Q SQLCODE
}

/// Descript:Insert 更新特殊人群 DHC_PHConSpCrowd记录
ClassMethod InsertSpeCrd(DataList) As %String
{
	N (DataList)
	S code=$p(DataList,"^",2) 
	S desc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_PHConSpCrowd(PHConSpCd_Code,PHConSpCd_Desc)
 		VALUES(:code,:desc))
 	Q SQLCODE
}

/// Descript:delete 更新特殊人群 DHC_PHConSpCrowd记录
ClassMethod DeleteSpCrdInfo(rowid) As %String
{
	N (rowid)
	&SQL(DELETE FROM DHC_PHConSpCrowd WHERE PHConSpCd_RowID=:rowid)
	Q SQLCODE
}

/// w ##class("web.DHCPHCONSULT").GetSpCrdList()
ClassMethod GetSpCrdList()
{
	s StPage=0
    s Limit=99999
	s h=0
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s endpage=StPage+Limit  //结束行
	s StPage=StPage+1 //开始行
	
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s h=0
	s speCrdRid=0
    f  s speCrdRid=$o(^DHCPHCONSC(speCrdRid)) q:(speCrdRid="")||(speCrdRid=0)  d
    .s h=h+1
    .s code=$p(^DHCPHCONSC(speCrdRid),"^",1)
    .s desc=$p(^DHCPHCONSC(speCrdRid),"^",2)
    .s rowid=speCrdRid
    .s data=code_"^"_desc_"^"_rowid
    .s ^TMP("DHCST","DHCPHCONSULT","GetSpCrdList",pid,h)=data
	
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	
 	s maxrow=h
 	i endpage>maxrow s endpage=maxrow

    s h=""
    s count=0
    f  s h=$o(^TMP("DHCST","DHCPHCONSULT","GetSpCrdList",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCPHCONSULT","GetSpCrdList",pid,h)
    .s code=$p(data,"^",1)
    .s desc=$p(data,"^",2)
    .s rowid=$p(data,"^",3)
    .
    .s code=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	.s desc=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##Class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=code_desc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
    .
	.s count=count+1
	.i count=1 w startString
	.i count<maxrow w firstrow
	.i count=maxrow w lastrow
	.
	k ^TMP("DHCST","DHCPHCONSULT","GetSpCrdList",pid)
	q ""
}

//w ##class("web.DHCPHCONSULT").GetPatInf("00000001")

ClassMethod GetPatInf(inputs)
{
	n (inputs)
	s patId=0
	s count=0
	s maxrow=1
	f  s patId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(inputs),patId)) q:patId=""  d
	.s patName=$p(^PAPER(patId,"ALL"),"^",1)
	.s sexDr=$p(^PAPER(patId,"ALL"),"^",7)
	.s sex=$p(^CT("SEX",sexDr),"^",2)
	.s dob=$p(^PAPER(patId,"ALL"),"^",6)
	.s dob=$zd(dob,3)
	.s tel=$p(^PAPER(patId,"PER",1),"^",11)
   	.s patId=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patId",patId)
    .s patName=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patName",patName)
	.s sex=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("sex",sex)
	.s dob=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("dob",dob)
	.s tel=##Class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("tel",tel)
	.
	.s tmpstr=patId_patName_sex_dob_tel
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
    .
	.s count=count+1
	.i count=1 w startString
	.i count<maxrow w firstrow
	.i count=maxrow w lastrow
	.
	q:count=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q ""
}

}
