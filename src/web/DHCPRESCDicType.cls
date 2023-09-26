Import SQLUser

/// Creator:     	chenzhaobo
/// CreateDate:   	2021-09-01
/// Descript:		审核状态字典操作
Class web.DHCPRESCDicType Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	审核状态字典类型保存或更新
/// w ##class(web.DHCPRESCDicType).save("8^000003^测试000003^N^65")
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

/// Descript:	增加
/// w ##class(web.DHCPRESCDicType).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
 	&SQL(INSERT INTO CT_PHA_PREADT.DicType(PDS_Code, PDS_Desc, PDS_ActiveFlag, PDS_Hosp_Dr) VALUES(:Code,:Desc,:ActFlag,:HospID))
 	q SQLCODE
}

/// Descript:	更新
/// w ##class(web.DHCPRESCDicType).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	&SQL(Update CT_PHA_PREADT.DicType Set PDS_Code=:Code, PDS_Desc=:Desc, PDS_ActiveFlag=:ActFlag, PDS_Hosp_Dr=:HospID WHERE PDS_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除
/// w ##class(web.DHCPRESCDicType).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	s $Zt="Err"
	ts
	s ItmID="0",ret=0
	b
	F  s ItmID=$o(^CT.PHA.PREADT.DicItemI("TypePar",ID,ItmID)) Q:(ItmID="")||(ret'=0)  D
	.b
	.s ret=##class(web.DHCPrescDicItem).delete(ItmID)
	i ret'=0 tro
	q:ret'=0 ret
	b
	&SQL(Delete From CT_PHA_PREADT.DicType Where PDS_RowID=:ID)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 SQLCODE
	tc
	Q SQLCODE
Err
	tro //ed
	Q SQLCODE
}

/// Descript:查询
/// w ##class(web.DHCPRESCDicType).QryPrescDicType("30","1","2")
ClassMethod QryPrescDicType(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s count=0
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc^ActCode^ActDesc^HospID^HospDesc"
	w "{""rows"":["
	s ID="0"
	F  s ID=$o(^CT.PHA.PREADT.DicTypeD(ID)) Q:ID=""  D
	.s str = $g(^CT.PHA.PREADT.DicTypeD(ID))
	.s Code=$list($g(str),2)    //代码
	.s Desc=$list($g(str),3)    //描述
	.s ActCode=$list($g(str),4) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$list($g(str),5)  //医院
	.s HospDrID=$p(params,"^",1)
	.q:(HospDrID'="")&(HospDrID'=HospID) //hxy 2019-07-18
	.s HospDesc=""
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s count = count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",") 
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_HospID_"^"_HospDesc
	.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "],""total"":"_count_"}"
	q ""
}

/// Descript:检查代码、描述是否重复
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	s ID=$p(mParam,"^",1)   	/// ID
	s Code=$p(mParam,"^",2)   	/// 代码
	s Desc=$p(mParam,"^",3)   	/// 描述
	s HospID=$p(mParam,"^",5)   /// 医院ID
	/// 新记录
	Q:(ID="")&($d(^CT.PHA.PREADT.DicTypeI("Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-1"
	Q:(ID="")&($d(^CT.PHA.PREADT.DicTypeI("Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$list($g(^CT.PHA.PREADT.DicTypeD(ID)),2)    //代码
	s TmpDesc=$list($g(^CT.PHA.PREADT.DicTypeD(ID)),3)    //描述
	Q:(TmpCode'=Code)&($d(^CT.PHA.PREADT.DicTypeI("Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-3"
	Q:(TmpDesc'=Desc)&($d(^CT.PHA.PREADT.DicTypeI("Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-4"
	Q 0
}

}
