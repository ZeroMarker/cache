Import SQLUser

/// Creator: 		qqa
/// CreateDate: 	2019-04-22
/// Descript: 		MDT会诊申请状态字典维护类
Class web.DHCMDTConsStatus Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	会诊申请状态字典
/// w ##class(web.DHCMDTConsStatus).save("8^000003^测试000003^N^65")
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
	..i Err>0  d
	...s HospID=$p(mdata,"^",5)   ///医院ID
	...s hospflag=##Class(web.DHCADVCOMMON).SaveHOSP("DHC_MDTConsStatus",Err,HospID)
 	...q:hospflag'=0 
	q Err
}

/// Descript:	增加 会诊申请状态字典
/// w ##class(web.DHCMDTConsStatus).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s SupStateID=$p(mParam,"^",6)   ///上一级状态ID
 	&SQL(INSERT INTO DHC_MDTConsStatus(MD_Code, MD_Desc, MD_ActiveFlag, MD_Hosp_Dr, MD_SupState) 
 		VALUES(:Code,:Desc,:ActFlag,:HospID,:SupStateID))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:	更新 会诊申请状态字典
/// w ##class(web.DHCMDTConsStatus).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s SupStateID=$p(mParam,"^",6)   ///上一级状态ID
	&SQL(Update DHC_MDTConsStatus Set MD_Code=:Code,MD_Desc=:Desc,MD_ActiveFlag=:ActFlag,MD_Hosp_Dr=:HospID
				,MD_SupState=:SupStateID WHERE MD_RowID=:ID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:	删除 会诊申请状态字典
/// w ##class(web.DHCMDTConsStatus).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MDTConsStatus Where MD_RowID=:ID)
	s hospflag=##Class(web.DHCADVCOMMON).DeleteHospitals("DHC_MDTConsStatus",ID)
	q:hospflag'=1 -3

	Q SQLCODE
}

/// Descript:查询[会诊申请状态字典]
/// w ##class(web.DHCMDTConsStatus).QryEmConsStatus("12","1","")
ClassMethod QryEmConsStatus(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s hospId = $P(params,"^",1)
	s ID="0"
	F  s ID=$o(^DHCMDTS(ID)) Q:ID=""  D
	.s Code=$p(^DHCMDTS(ID),"^",1)    //代码
	.s Desc=$p(^DHCMDTS(ID),"^",2)    //描述
	.s ActCode=$p(^DHCMDTS(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$p(^DHCMDTS(ID),"^",4)  //医院
	.q:##class(web.DHCADVCOMMON).GetHospShowDataFlag("DHC_MDTConsStatus",ID,hospId,"")'="Y"
	.;q:hospId'=HospID
	.s HospDesc=""
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s SupStateID=$p(^DHCMDTS(ID),"^",5)
	.s SupState=##class(web.DHCMDTConsStatus).GetSupState(SupStateID)
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_HospID_"^"_HospDesc_"^"_SupState_"^"_SupStateID
	.s TmpItemDet(Code_"^"_ID)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc^ActCode^ActDesc^HospID^HospDesc^SupState^SupStateID"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	F  s index=$o(TmpItemDet(index)) Q:index=""  D
	.s ListData=$g(TmpItemDet(index))
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符

	Q ""
}

/// 状态描述
ClassMethod GetSupState(StatusIds)
{
	n (StatusIds)
	q:StatusIds="" ""
	s Ret=""
	s Len = $l(StatusIds,",")
	f i=1:1:Len d
	.s StatusId=$p(StatusIds,",",i)
	.q:+StatusId=0
	.s Status=$p(^DHCMDTS(StatusId),"^",2)
	.s:Ret'="" Ret=Ret_","_Status
	.s:Ret="" Ret=Status
	q Ret
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
	Q:(ID="")&($d(^DHCMDTS(0,"Code",$$ALPHAUP^SSUTIL4(Code)))) "-1"
	Q:(ID="")&($d(^DHCMDTS(0,"Desc",$$ALPHAUP^SSUTIL4(Desc)))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$p($g(^DHCMDTS(ID)),"^",1)    //代码
	s TmpDesc=$p($g(^DHCMDTS(ID)),"^",2)    //描述
	Q:(TmpCode'=Code)&($d(^DHCMDTS(0,"Code",$$ALPHAUP^SSUTIL4(Code)))) "-3"
	Q:(TmpDesc'=Desc)&($d(^DHCMDTS(0,"Desc",$$ALPHAUP^SSUTIL4(Desc)))) "-4"
	Q 0
}

/// Descritp:	会诊申请状态
/// w ##Class(web.DHCMDTConsStatus).jsonConsStat("1")
ClassMethod jsonConsStat(HospID As %String) As %String
{
	n (HospID)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT MD_RowID ,MD_Desc, MD_ActiveFlag FROM DHC_MDTConsStatus"
	//i HospID'="" s sqlStr = sqlStr_" Where  MD_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("MD_RowID")
		s Desc = result.Data("MD_Desc")
		Continue:Desc=""
		Continue:result.Data("MD_ActiveFlag")'="Y"
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

}
