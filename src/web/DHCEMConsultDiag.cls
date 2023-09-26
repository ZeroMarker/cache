Import sqluser

/// Descript:   MDT诊断字典维护类
/// Creator:    bianshuai
/// CreateDate: 2018-06-21
Class web.DHCEMConsultDiag Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	保存
/// w ##class(web.DHCEMConsultDiag).Save("^11^22222^Y^2")
ClassMethod Save(mListData As %String) As %String
{
	n (mListData)
	s Len=$L(mListData,"$$")
	s Err=0
	F i=1:1:Len Q:Err'=0  D
	.s TempStr=$p(mListData,"$$",i)
	.i $p(TempStr,"^",1) ="" D
	..s Err=..Insert(TempStr)
	.e  d
	..s Err=..Update(TempStr)
	Q Err
}

/// Descript:	插入
/// w ##class(web.DHCEMConsultDiag).Insert("")
ClassMethod Insert(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s MrID=$p(ItmTempStr,"^",2)   	/// 诊断ID
 	&SQL(INSERT INTO DHC_EmConsultDiag(EC_MR_Dr) VALUES(:MrID))
 	q SQLCODE
}

/// Descript:	更新
/// w ##class(web.DHCEMConsultDiag).update("")
ClassMethod Update(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ID=$p(ItmTempStr,"^",1)   	///ID
	s MrID=$p(ItmTempStr,"^",2)   	/// 诊断ID
	&SQL(Update DHC_EmConsultDiag Set EC_MR_Dr=:MrID WHERE EC_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除
/// w ##class(web.DHCEMConsultDiag).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_EmConsultDiag Where EC_RowID=:ID)
	Q SQLCODE
}

/// Descript:	查询
/// w ##class(web.DHCEMConsultDiag).QryConsultDiag("12","1","")
ClassMethod QryConsultDiag(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	
    s pid=##Class(web.DHCAPPExaRepCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCEMCD(ID)) Q:ID=""  D
	.s MrID=$p(^DHCEMCD(ID),"^",1)        //诊断ID
    .s MrCode=$p(^MRC("ID",MrID),"^",1)  //代码
    .s MrDesc=$p(^MRC("ID",MrID),"^",2)  //描述
	.s h=h+1
	.s ListData=ID_"^"_MrID_"^"_MrCode_"^"_MrDesc
	.s ^TMP("DHCST","web.DHCEMConsultDiag","QryConsultDiag",pid,h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="ID^MrID^MrCode^MrDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	F  s index=$o(^TMP("DHCST","web.DHCEMConsultDiag","QryConsultDiag",pid,index)) Q:index=""  D
	.s ListData=$g(^TMP("DHCST","web.DHCEMConsultDiag","QryConsultDiag",pid,index))
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCEMConsultDiag","QryConsultDiag",pid)
	Q ""
}

}
