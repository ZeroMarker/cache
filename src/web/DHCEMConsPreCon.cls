Import sqluser

Class web.DHCEMConsPreCon Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 保存[工作流前置]
/// Creator:     QQA
/// CreateDate:  2019-12-09
/// Table:		 DHC_EmConsWorkFlow
/// Input:  	 DataList:以字符"^"分割,格式为:id^代码^描述^类型描述^是否可用
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCEMConsWorkFlow).save("^111^222")
ClassMethod save(mParam As %String) As %String
{
	n (mParam)
	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.s Err=..isExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	Q Err
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		检查代码、描述是否重复
/// w ##class(web.DHCEMNurExecFormSet).isExist("^SYDO^SYDO^2")
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	;q 0 //hxy 2020-08-10 注释
	s ID=$p(mParam,"^",1)   	///ID
	s WF=$p(mParam,"^",2)   	///代码
	s Fun=$p(mParam,"^",3)   	///描述
	q:$d(^DHCEMCONPC(0,"FunWorkFlow",Fun,WF)) -1 //hxy 2020-08-10
	Q 0
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		增加
/// w ##class(web.DHCMDTGroup).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s WFDr=$p(mParam,"^",2)   
	s FunDr=$p(mParam,"^",3)   	

	
 	&SQL(INSERT INTO DHC_EmConsPreCon(EC_WF_Dr, EC_Fun_Dr) 
 		VALUES(:WFDr,:FunDr))
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		更新
/// w ##class(web.DHCMDTGroup).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s WFDr=$p(mParam,"^",2)   
	s FunDr=$p(mParam,"^",3)  
	&SQL(Update DHC_EmConsPreCon Set EC_WF_Dr=:WFDr, EC_Fun_Dr=:FunDr
		WHERE EC_RowID=:ID )
 	q SQLCODE
}

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript:		删除
/// w ##class(web.DHCMDTGroup).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_EmConsPreCon Where EC_RowID=:ID)
	Q SQLCODE
}

/// w ##class(web.DHCEmConsPreCon).GetPreList("2")
ClassMethod GetPreList(HospID)
{
	n (HospID)
	
	s Count=0
	w "["
	s ID=0
	f  s ID = $o(^DHCEMCONF(ID)) q:ID=""  d
	.s Code=$p(^DHCEMCONF(ID),"^",1)
	.s Desc=$p(^DHCEMCONF(ID),"^",2)
	.s HospDr = $p(^DHCEMCONF(ID),"^",5)
	.s Flag = $p(^DHCEMCONF(ID),"^",4) //hxy 2020-08-10 st
	.q:Flag'="Y" //ed
	.;q:(HospID'="")&&(HospID'=HospDr) //hxy 2020-06-04 注释
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=ID_"^"_Desc
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text",ListData)
	w "]"
	q ""
}

ClassMethod QryListPreCon(rows As %String, page As %String, Params As %String)
{
	n (rows,page,Params)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	s MID=$p(Params,"^",1)
	q:+MID=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	
	k TmpItemDet
	s h=0,Count=0
	s ID=""
	f  s ID=$o(^DHCEMCONPC(0,"WorkFlow",MID,ID)) q:ID=""  d
	.q:+ID=0
	.s Date = ^DHCEMCONPC(ID)
	.s FunDr=$p(Date,"^",2)
	.s Fun=$p($g(^DHCEMCONF(FunDr)),"^",2)
	.s FunExp=$p($g(^DHCEMCONF(FunDr)),"^",3) /// 表达式
	.s h=h+1
	.s ListData=ID_"^"_FunDr_"^"_Fun_"^"_FunExp
	.s TmpItemDet(h)=ListData
	i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^FunDr^Fun^FunExp"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s Index=""
	F  s Index=$o(TmpItemDet(Index)) Q:Index=""  D
	.s ListData=$g(TmpItemDet(Index))
	.s Count = Count+1
	.Q:(Count<Start)||(Count>End)
	.I Count=Start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

/// Descript: 取表达式参数
/// w ##Class(web.DHCEMConsPreCon).ListExpParams("10","1","1")
ClassMethod ListExpParams(rows As %String, page As %String, ID As %String) As %String
{
	n (rows,page,ID)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	k TmpArr
	s ExpParams=""
	i $d(^DHCEMCONPC(+ID)) s ExpParams=$p($g(^DHCEMCONPC(+ID)),"^",3)
    s Num=0
	F i=1:1:$L(ExpParams,",") D
	.s Param=$p(ExpParams,",",i)
	.Q:Param=""
	.s Num=Num+1
	.s TmpArr(Num)=ID_"^"_Param_"^"_Param
	.
	
	i Num=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Desc^OldDesc"

	W ##class(web.DHCEMJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.
	W "]}"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-30
/// Descript: 		表达式参数
/// w ##Class(web.DHCEMConsPreCon).InsExpParam("9","主管药师","医士")
ClassMethod InsExpParam(ID As %String, Params As %String, DelParams = "") As %String
{
	n (ID, Params,DelParams)
	s ExpParams=$p($g(^DHCEMCONPC(+ID)),"^",3)
	s Num=0
	s ExpPar=","_ExpParams_","
	
	F i=1:1:$L(DelParams,",") D
	.s Param=$p(DelParams,",",i)
	.Q:Param=""
	.s:ExpPar[(","_Param_",") ExpParams=$replace(ExpPar,(","_Param_","),",")
	
	F i=1:1:$L(Params,",") D
	.s Param=$p(Params,",",i)
	.Q:Param=""
	.Q:ExpPar[(","_Param_",")
	.s Params=ExpParams_","_Param
	.s Num=Num+1
	s:Num=0 Params=ExpParams
	&SQL(update DHC_EmConsPreCon set EC_Params=:Params where EC_RowID=:ID)
	Q SQLCODE
}

/// Creator: 		hxy
/// CreateDate: 	2022-10-14
/// Descript: 		删除表达式参数
/// w ##Class(web.DHCEMConsPreCon).DelExpParam("10")
ClassMethod DelExpParam(ID As %String, Desc As %String) As %String
{
	n (ID, Desc)
	s ExpParams=$p($g(^DHCEMCONPC(+ID)),"^",3)
	s Params=""
	F i=1:1:$L(ExpParams,",") D
	.s Param=$p(ExpParams,",",i)
	.Q:Param=""
	.Q:Param=Desc
	.s Params=Params_Param_","
	&SQL(update DHC_EmConsPreCon set EC_Params=:Params where EC_RowID=:ID)
	Q SQLCODE
}

}
