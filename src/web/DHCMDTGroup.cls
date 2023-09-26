Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript: 		mdt疑难病种分组维护
Class web.DHCMDTGroup Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		mdt疑难病种分组维护表
/// w ##class(web.DHCMDTGroup).save("8^000003^测试000003^N^65")
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

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		增加
/// w ##class(web.DHCMDTGroup).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s Address=$p(mParam,"^",6)   ///会诊地点
 	s Notes=$p(mParam,"^",7)   
 	&SQL(INSERT INTO DHC_MDTGroup(MD_Code, MD_Desc, MD_ActiveFlag, MD_Hosp_Dr,MD_ConsAddress,MD_Notes) VALUES(:Code,:Desc,:ActFlag,:HospID,:Address,:Notes))
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		更新
/// w ##class(web.DHCMDTGroup).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s Address=$p(mParam,"^",6)   ///会诊地点
	s Notes=$p(mParam,"^",7)
	&SQL(Update DHC_MDTGroup Set MD_Code=:Code, MD_Desc=:Desc, MD_ActiveFlag=:ActFlag, MD_Hosp_Dr=:HospID 
		,MD_ConsAddress=:Address,MD_Notes=:Notes WHERE MD_RowID=:ID)
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		删除
/// w ##class(web.DHCMDTGroup).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MDTGroup Where MD_RowID=:ID)
	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		查询
/// w ##class(web.DHCMDTGroup).QryGroup("12","1","")
ClassMethod QryGroup(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s hospId = $p(params,"^",1)

	s ID="0"
	F  s ID=$o(^DHCMDTG(ID)) Q:ID=""  D
	.s Code=$p(^DHCMDTG(ID),"^",1)    //代码
	.s Desc=$p(^DHCMDTG(ID),"^",2)    //描述
	.s ActCode=$p(^DHCMDTG(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$p(^DHCMDTG(ID),"^",4)  //医院
	.s HospDesc=""
	.q:hospId'=HospID
	.q:'$d(^CT("HOSP",HospID))
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s Addr = $p(^DHCMDTG(ID),"^",5)
	.s Notes = $p(^DHCMDTG(ID),"^",6)
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_HospID_"^"_HospDesc_"^"_Addr_"^"_Notes
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc^ActCode^ActDesc^HospID^HospDesc^Addr^Notes"
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

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		检查代码、描述是否重复
/// w ##class(web.DHCMDTGroup).isExist("")
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	s ID=$p(mParam,"^",1)   	/// ID
	s Code=$p(mParam,"^",2)   	/// 代码
	s Desc=$p(mParam,"^",3)   	/// 描述
	s HospID=$p(mParam,"^",5)   /// 医院ID
	/// 新记录
	Q:(ID="")&($d(^DHCMDTG(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-1"
	Q:(ID="")&($d(^DHCMDTG(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$p($g(^DHCMDTG(ID)),"^",1)    //代码
	s TmpDesc=$p($g(^DHCMDTG(ID)),"^",2)    //描述
	Q:(TmpCode'=Code)&($d(^DHCMDTG(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-3"
	Q:(TmpDesc'=Desc)&($d(^DHCMDTG(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-4"
	Q 0
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descritp:		会诊申请字典类型
/// w ##Class(web.DHCMDTGroup).jsonGroup("1")
ClassMethod jsonGroup(LgParams As %String, Type As %String = "") As %String
{
	N (LgParams, Type ,%session)
	s HospID=$p(LgParams,"^",1)
	i Type="" s Type="App"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT MD_RowID ,MD_Desc, MD_ActiveFlag FROM DHC_MDTGroup"
	i HospID'="" s sqlStr = sqlStr_" Where  MD_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("MD_RowID")
		s Desc = result.Data("MD_Desc")
		s AppAut= ##class(web.DHCMDTCom).ReqMdtConsAbilityNew(Type,RowId,LgParams)
		Continue:AppAut'=1
		Continue:Desc=""
		Continue:result.Data("MD_ActiveFlag")'="Y"
		s Desc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCMDTGroup","MDDesc","",Desc)
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descritp:		会诊申请字典类型
/// w ##Class(web.DHCMDTGroup).jsonGroupAll("")
ClassMethod jsonGroupAll(HospID) As %String
{
	N (HospID,%session)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT MD_RowID ,MD_Desc, MD_ActiveFlag FROM DHC_MDTGroup"
	i HospID'="" s sqlStr = sqlStr_" Where  MD_Hosp_Dr="_HospID
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
		s Desc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCMDTGroup","MDDesc","",Desc)
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		MDT分组成员科室
/// w ##class(web.DHCMDTGroup).saveItm("^4^3^11625^")
ClassMethod saveItm(mParam As %String) As %String
{
	N (mParam)
	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.s Err=..isItemExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" D
	..s Err=..InsertItem(mdata)
	.e  d
	..s Err=..UpdateItem(mdata)
	Q Err
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		插入子表
/// w ##class(web.DHCMDTGroup).InsertItem("")
ClassMethod InsertItem(mListData As %String) As %String
{
	N (mListData)
	s ID=$p(mListData,"^",2)   	    /// DHC_MDTGroup ID
	s LocID=$p(mListData,"^",3)   	/// 科室ID
	s PrvTpDr =$p(mListData,"^",4)
	s UserID=$p(mListData,"^",5)   	/// 成员ID
	s ContactsFlag =$p(mListData,"^",6)   	/// 联络人标识
	s ChildSub=$o(^DHCMDTG(ID,"I",""),-1)+1
 	&SQL(INSERT INTO DHC_MDTGroupItm(MD_ParRef_Dr, MD_ChlidSub, MD_Loc_Dr,MD_PrvTp_Dr,MD_User_Dr, MD_ContactsFlag) VALUES(:ID, :ChildSub,:LocID,:PrvTpDr,:UserID,:ContactsFlag))
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		更新子表
/// w ##class(web.DHCMDTGroup).UpdateItem("")
ClassMethod UpdateItem(mListData As %String) As %String
{
	N (mListData)
	s ID=$p(mListData,"^",1)   	     ///ID
	s LocID=$p(mListData,"^",3)   	 /// 科室ID
	s PrvTpDr =$p(mListData,"^",4)
	s UserID=$p(mListData,"^",5)   	/// 成员ID
	s ContactsFlag =$p(mListData,"^",6)   	/// 联络人标识
	&SQL(Update DHC_MDTGroupItm Set MD_Loc_Dr=:LocID,MD_PrvTp_Dr=:PrvTpDr,MD_User_Dr=:UserID, MD_ContactsFlag=:ContactsFlag WHERE MD_RowID=:ID)
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		删除 
/// w ##class(web.DHCMDTGroup).deleteItem("1")
ClassMethod deleteItem(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MDTGroupItm Where MD_RowID=:ID)
	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		mdt成员科室
/// w ##class(web.DHCMDTGroup).QryGroupItm("12","1","4")
ClassMethod QryGroupItm(rows As %String, page As %String, ID As %String) As %String
{
	N (rows, page, ID)
	s End = page*rows
	s Start=(page-1)*rows+1
	
    k TmpItemDet
  
	s h=0,count=0
	s CH=""
	f  s CH=$o(^DHCMDTG(ID,"I",CH)) q:CH=""  d
	.s LocID=$p(^DHCMDTG(ID,"I",CH),"^",1)    /// 科室ID
	.s LocDesc = $p(^CTLOC(LocID),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s User=""
	.s UserID=$p(^DHCMDTG(ID,"I",CH),"^",2)    /// 用户ID
	.i UserID'="" s User=$p($g(^SSU("SSUSR",UserID)),"^",2)
	.s ContactsID=$p(^DHCMDTG(ID,"I",CH),"^",3)    /// 联络人标识
	.s ContactsFlag=$s(ContactsID="Y":"是",1:"否")
	.s PrvTpID=$p(^DHCMDTG(ID,"I",CH),"^",4)    /// 职称
	.s PrvTp=""
	.i PrvTpID'="" s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	.s h=h+1
	.s ListData=ID_"^"_ID_"||"_CH_"^"_LocID_"^"_LocDesc_"^"_UserID_"^"_User_"^"_ContactsID_"^"_ContactsFlag
	.s ListData=ListData_"^"_PrvTpID_"^"_PrvTp
	.s TmpItemDet(h)=ListData
	.
	
	///转换数据为Json格式
	S ListTitle="mID^ID^LocID^LocDesc^UserID^User^ContactsID^ContactsFlag^PrvTpID^PrvTp"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(TmpItemDet(index)) q:index=""  d
	.s ListData=$g(TmpItemDet(index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		成员科室是否重复，联络人标识是否重复
/// w ##class(web.DHCMDTGroup).isItemExist("^1^103^3^10658^")
ClassMethod isItemExist(mParam As %String) As %String
{
	N (mParam)
	s mID=$p(mParam,"^",1)   	  /// ID
	s ID=$p(mParam,"^",2)   	  /// 分组ID
	s mLocID=$p(mParam,"^",3)     /// 科室ID
	s mUserID=$p(mParam,"^",5)    /// 成员ID
	s ConFlag=$p(mParam,"^",6)    /// 联络人标识
	s QuitFlag="N",repFlag="N"
	s CH=""
	f  s CH=$o(^DHCMDTG(ID,"I",CH)) q:CH=""  d
	.s itmID=ID_"||"_CH
	.s LocID=$p(^DHCMDTG(ID,"I",CH),"^",1)    /// 科室ID
	.s UserID=$p(^DHCMDTG(ID,"I",CH),"^",2)   /// 用户ID
	.i (ConFlag="Y")&($p(^DHCMDTG(ID,"I",CH),"^",3)="Y") D
	..i (mID="")||((mID'="")&(mID'=itmID)) s repFlag="Y"
	.i (LocID=mLocID)&(UserID=mUserID) D
	..i (mID="")||((mID'="")&(mID'=itmID)) s QuitFlag="Y"
	.
	Q:QuitFlag="Y" "-1"  /// 成员科室重复
	Q:repFlag="Y" "-2"   /// 联络人重复
	Q 0
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		MDT分组成员科室
/// w ##class(web.DHCMDTGroup).saveOutExp("1^^2")
ClassMethod saveOutExp(mParam As %String) As %String
{
	n (mParam)
	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.s Err=..isOutExpExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" D
	..s Err=..InsOutExp(mdata)
	.e  d
	..s Err=..UpdOutExp(mdata)
	Q Err
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-08-20
/// Descript:		插入 病种关联外院专家记录
/// w ##class(web.DHCMDTGroup).InsOutExp("")
ClassMethod InsOutExp(mListData As %String) As %String
{
	n (mListData)
	s ParRef=$p(mListData,"^",2)   	    /// DHC_MDTGroup ID
	s OutExpID=$p(mListData,"^",3)   	/// 外院专家ID
 	&SQL(INSERT INTO DHC_MDTGrpOuterExp(MD_ParRef_Dr, MD_OutExp_Dr) VALUES(:ParRef, :OutExpID))
 	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-08-20
/// Descript:		更新 病种关联外院专家记录
/// w ##class(web.DHCMDTGroup).UpdOutExp("")
ClassMethod UpdOutExp(mListData As %String) As %String
{
	n (mListData)
	s ID=$p(mListData,"^",1)   	     ///ID
	s OutExpID=$p(mListData,"^",3)   /// 外院专家ID
	&SQL(Update DHC_MDTGrpOuterExp Set MD_OutExp_Dr=:OutExpID WHERE MD_RowID=:ID)
 	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-08-20
/// Descript:		删除 病种关联外院专家记录
/// w ##class(web.DHCMDTGroup).deleteOutExp("1")
ClassMethod deleteOutExp(ID As %String) As %String
{
	n (ID)
	&SQL(delete from DHC_MDTGrpOuterExp where MD_RowID=:ID)
	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		成员科室是否重复
/// w ##class(web.DHCMDTGroup).isOutExpExist("^5^3^10588^Y")
ClassMethod isOutExpExist(mParam As %String) As %String
{
	n (mParam)

	s tmpID=$p(mParam,"^",1)   	  /// ID
	s ParRef=$p(mParam,"^",2)     /// DHC_MDTGroup ID
	s OutExpID=$p(mParam,"^",3)   /// 外院专家ID
	s repFlag="N"
	s ID=""
	F  s ID=$o(^DHCMDTGOE(0,"ParRef",+ParRef,ID)) Q:(ID="")||(repFlag="Y")  D
	.Q:tmpID=ID
	.Q:$p(^DHCMDTGOE(ID),"^",2)'=OutExpID
	.s repFlag="Y"
	.
	Q:repFlag="Y" "-1"  /// 成员重复
	Q 0
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-08-20
/// Descript:		查询
/// w ##Class(web.DHCMDTGroup).JsQryGrpOutExp("12","1","")
ClassMethod JsQryGrpOutExp(rows As %String, page As %String, Parref As %String) As %String
{
	n (rows, page, Parref)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpArr
	s h=0, count=0
	s ID="0"
	F  s ID=$o(^DHCMDTGOE(0,"ParRef",+Parref,ID)) Q:ID=""  D
	.s grpID=$p(^DHCMDTGOE(ID),"^",1)
	.s expID=$p(^DHCMDTGOE(ID),"^",2)
	.Q:expID=""
	.q:'$d(^DHCMDTOUTEXP(expID))
	.s userCode=$p(^DHCMDTOUTEXP(expID),"^",1)    /// 工号
	.s userName=$p(^DHCMDTOUTEXP(expID),"^",2)    /// 姓名
	.s sexId=$p(^DHCMDTOUTEXP(expID),"^",3)       /// 姓别
	.s userSex=$p($g(^CT("SEX",+sexId)),"^",2)
	.s idCard=$p(^DHCMDTOUTEXP(expID),"^",5)      /// 身份证
	.s prvTpID=$p(^DHCMDTOUTEXP(expID),"^",4)     /// 职称
	.s prvTp=$p($g(^CT("CPT",+prvTpID)),"^",2)
	.s locID=$p(^DHCMDTOUTEXP(expID),"^",6)       /// 科室ID
	.s locDesc=$p($g(^DHCMDTDI(+locID)),"^",2)
	.s parID=$p($g(^DHCMDTDI(+locID)),"^",6)
	.s outHosp=$p($g(^DHCMDTDI(+parID)),"^",2)
	.s phone=$p(^DHCMDTOUTEXP(expID),"^",7)       /// 电话
	.s actCode=$p(^DHCMDTOUTEXP(expID),"^",8)     /// 可用标志
	.s actDesc=$s(actCode="Y":"是",actCode="N":"否",1:"")
	.s hospID=$p(^DHCMDTOUTEXP(expID),"^",9)      /// 医院
	.s hospDesc=$p($g(^CT("HOSP",+hospID)),"^",2)
	.s h=h+1
	.s ListData=ID_"^"_expID_"^"_grpID_"^"_userCode_"^"_userName_"^"_userSex_"^"_idCard_"^"_prvTp
	.s ListData=ListData_"^"_locDesc_"^"_phone_"^"_hospDesc_"^"_outHosp
	.s TmpArr(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^expID^grpID^userCode^userName^userSex^idCard^prvTp^locDesc^phone^hospDesc^outHosp"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符

	Q ""
}

}
