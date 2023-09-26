Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2018-04-02
/// Descript: 		会诊申请状态字典维护类
Class web.DHCEMConsStatus Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	会诊申请状态字典
/// w ##class(web.DHCEMConsStatus).save("8^000003^测试000003^N^65")
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
	q Err
}

/// Descript:	增加 会诊申请状态字典
/// w ##class(web.DHCEMConsStatus).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
 	&SQL(INSERT INTO DHC_EmConsStatus(ECS_Code, ECS_Desc, ECS_ActiveFlag, ECS_Hosp_Dr) VALUES(:Code,:Desc,:ActFlag,:HospID))
 	q SQLCODE
}

/// Descript:	更新 会诊申请状态字典
/// w ##class(web.DHCEMConsStatus).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	&SQL(Update DHC_EmConsStatus Set ECS_Code=:Code,ECS_Desc=:Desc,ECS_ActiveFlag=:ActFlag,ECS_Hosp_Dr=:HospID WHERE ECS_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除 会诊申请状态字典
/// w ##class(web.DHCEMConsStatus).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_EmConsStatus Where ECS_RowID=:ID)
	Q SQLCODE
}

/// Descript:查询[会诊申请状态字典]
/// w ##class(web.DHCEMConsStatus).QryEmConsStatus("30","1","")
ClassMethod QryEmConsStatus(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCEMCONS(ID)) Q:ID=""  D
	.s Code=$p(^DHCEMCONS(ID),"^",1)    //代码
	.s Desc=$p(^DHCEMCONS(ID),"^",2)    //描述
	.s ActCode=$p(^DHCEMCONS(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$p(^DHCEMCONS(ID),"^",4)  //医院
	.s HospDesc=""
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_HospID_"^"_HospDesc
	.s TmpItemDet(Code,h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc^ActCode^ActDesc^HospID^HospDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	F  s index=$o(TmpItemDet(index)) Q:index=""  D
	.s index1=0
	.F  s index1=$o(TmpItemDet(index,index1)) Q:index1=""  D
	..s ListData=$g(TmpItemDet(index,index1))
	..s count = count+1
	..Q:(count<Start)||(count>End)
	..I count=Start D
	...w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	..e  D
	...w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符

	Q ""
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
	Q:(ID="")&($d(^DHCEMCONS(0,"Code",$$ALPHAUP^SSUTIL4(Code)))) "-1" //hxy 2019-09-18 st
	Q:(ID="")&($d(^DHCEMCONS(0,"Desc",$$ALPHAUP^SSUTIL4(Desc)))) "-2"
	;Q:(ID="")&($d(^DHCEMCONS(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-1"
	;Q:(ID="")&($d(^DHCEMCONS(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-2" //ed
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$p($g(^DHCEMCONS(ID)),"^",1)    //代码
	s TmpDesc=$p($g(^DHCEMCONS(ID)),"^",2)    //描述
	Q:(TmpCode'=Code)&($d(^DHCEMCONS(0,"Code",$$ALPHAUP^SSUTIL4(Code)))) "-3" //hxy 2019-09-18 st
	Q:(TmpDesc'=Desc)&($d(^DHCEMCONS(0,"Desc",$$ALPHAUP^SSUTIL4(Desc)))) "-4"
	;Q:(TmpCode'=Code)&($d(^DHCEMCONS(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-3"
	;Q:(TmpDesc'=Desc)&($d(^DHCEMCONS(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-4" //ed
	Q 0
}

/// Descritp:	会诊申请状态
/// w ##Class(web.DHCEMConsStatus).jsonConsStat("1")
ClassMethod jsonConsStat(HospID As %String, RidNotProSta = "") As %String
{
	n (HospID,%session,RidNotProSta)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ECS_RowID ,ECS_Desc, ECS_ActiveFlag FROM DHC_EmConsStatus" //hxy 2019-12-25 WHERE ECS_Hosp_Dr="_HospID
	//i HospID'="" s sqlStr = sqlStr_" Where ECS_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("ECS_RowID")
		s Desc = result.Data("ECS_Desc")
		Continue:Desc=""
		Continue:result.Data("ECS_ActiveFlag")'="Y"
		Continue:(RidNotProSta=1)&&(Desc="到达") //hxy 2021-05-12 会诊处理-申请单列表-会诊状态-下拉数据去掉不纳入流程控制的到达（配置界面新增流程控制的字段做配置？到达过滤有到达日期的？）
		s Desc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmConsStatus","ECSDesc","",Desc)
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

/// Creator: 		bianshuai
/// CreateDate: 	2019-06-18
/// Descritp:	    取会诊申请流程节点状态
/// w ##Class(web.DHCEMConsStatus).jsCsStatNode("1")
ClassMethod jsCsStatNode(HospID As %String) As %String
{
	n (HospID)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ECS_RowID ,ECS_Desc, ECS_ActiveFlag FROM DHC_EmConsStatus"
	//i HospID'="" s sqlStr = sqlStr_" Where  ECS_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s Id = result.Data("ECS_RowID")
		s Desc = result.Data("ECS_Desc")
		s ActiveFlag = result.Data("ECS_ActiveFlag")
		Continue:Desc=""
		s tmp=Id_"^"_Desc_"^"_ActiveFlag
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("ID^Desc^ActiveFlag",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("ID^Desc^ActiveFlag",tmp)
	}
	w "]"
	q ""
}

}
