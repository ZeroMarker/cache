Import SQLUser

/// Creator: bianshuai
/// CreateDate: 2014-06-20
/// Descript: 用户用药建议模板维护
Class web.DHCSTPHCMMEDADVTEMP Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存用户用药建议模板
ClassMethod save(medAdvTempList As %String) As %String
{
	n (medAdvTempList)
    s len=$L(medAdvTempList,"||")
    f i=1:1:len d
    .s medAdvTempstr=$p(medAdvTempList,"||",i)
	.s ret=..Insert(medAdvTempstr)
	q ret
}

/// Descript:插入用户用药建议模板
ClassMethod Insert(medAdvTempstr As %String) As %String
{
	n (medAdvTempstr)
	s type=$p(medAdvTempstr,"^",1)
	s pointer=$p(medAdvTempstr,"^",2)
	s medAdvTempID=$p(medAdvTempstr,"^",3)

	&SQL(Insert Into DHC_PHMedAdvTemp(PHMAT_Type,PHMAT_Pointer,PHMAT_DSD_Dr) 
		Values(:type,:pointer,:medAdvTempID))
	i SQLCODE'=0  q SQLCODE
	q SQLCODE
}

/// Descript:删除用户用药建议模板记录
ClassMethod delmedAdvTemp(medAdvTempID As %String) As %String
{
	n (medAdvTempID)
	&SQL(delete  from DHC_PHMedAdvTemp where PHMAT_RowID=:medAdvTempID)
	i SQLCODE'=0  q SQLCODE
	q SQLCODE
}

/// Descript:用户建议模板维护
ClassMethod QueryMedAdvTemp(rows As %String, page As %String, param As %String) As %String
{
	n (rows,page,param,%session)

	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
	s locId=$p(param,"^",1)  //科室
	s userId=$p(param,"^",2) //用户
	
	s type=""
	i $d(^DHCPHMAT(0,"TypePointer","U",userId)) s type="U",pointer=userId
	i $d(^DHCPHMAT(0,"TypePointer","L",locId))  s type="U",pointer=locId
	
	q:type="" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	s num=0
	s medAdvTempID=""
	f  s medAdvTempID=$o(^DHCPHMAT(0,"TypePointer",type,pointer,medAdvTempID)) q:medAdvTempID=""  d
	.s advID=$p(^DHCPHMAT(medAdvTempID),"^",3)  //建议字典表ID
	.q:'$d(^DHCPHDSD(advID))
	.s advDicCode=$p(^DHCPHDSD(advID),"^",1) //代码
	.s advDicDesc=$p(^DHCPHDSD(advID),"^",2) //描述
	.s num=num+1
	.s advDicDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHDrgSugDic","DSDDesc","",advDicDesc)
	.s ^TMP("DHCST","web.DHCSTPHCMMEDADVTEMP","QueryMedAdvTemp",pid,num)=medAdvTempID_"^"_advID_"^"_advDicCode_"^"_advDicDesc

	q:num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	s Title="medAdvID^ID^Code^Desc"
	s maxrow=num
	i EndPage>maxrow S EndPage=maxrow
	s quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(num) //输出json前缀串
	s num=0
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMMEDADVTEMP","QueryMedAdvTemp",pid,index)) Q:(index="")||(quitflag=1)  D
	.s mdata=^TMP("DHCST","web.DHCSTPHCMMEDADVTEMP","QueryMedAdvTemp",pid,index)
	.s num=num+1
	.q:num<StPage
	.s:num=EndPage quitflag=1
	.i num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCST","web.DHCSTPHCMMEDADVTEMP","QueryMedAdvTemp",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^TMP("PHCMMEDADVTEMP"))
}

}
