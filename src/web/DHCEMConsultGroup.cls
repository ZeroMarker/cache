Import sqluser

/// Descript:   MDT字典维护类
/// Creator:    bianshuai
/// CreateDate: 2018-06-19
Class web.DHCEMConsultGroup Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	保存
/// w ##class(web.DHCEMConsultGroup).Save("^11^22222^Y^2")
ClassMethod Save(mListData As %String) As %String
{
	n (mListData)
	s Len=$L(mListData,"$$")
	s Err=0
	F i=1:1:Len Q:Err'=0  D
	.s TempStr=$p(mListData,"$$",i)
	.s Err=..isRepeat(TempStr)   /// 重复性判断
	.Q:Err'=0
	.i $p(TempStr,"^",1) ="" D
	..s Err=..Insert(TempStr)
	.e  d
	..s Err=..Update(TempStr)
	Q Err
}

/// Descript:	插入
/// w ##class(web.DHCEMConsultGroup).Insert("")
ClassMethod Insert(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s Code=$p(ItmTempStr,"^",2)   	///代码
	s Desc=$p(ItmTempStr,"^",3)   	///描述
	s isFlag=$p(ItmTempStr,"^",4)   ///不可用标志
	s HospID=$p(ItmTempStr,"^",5)   ///医院ID
	s TLeaderID=$p(ItmTempStr,"^",6)   /// 小组组长
	s Type=$p(ItmTempStr,"^",7)     /// 类型
 	&SQL(INSERT INTO DHC_EmConsultGroup(EC_Code, EC_Desc, EC_ActiveFlag, EC_Hosp_Dr, EC_TLeader_Dr,EC_Type) VALUES(:Code,:Desc,:isFlag,:HospID,:TLeaderID,:Type))
 	q SQLCODE
}

/// Descript:	更新
/// w ##class(web.DHCEMConsultGroup).update("")
ClassMethod Update(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ID=$p(ItmTempStr,"^",1)   	///ID
	s Code=$p(ItmTempStr,"^",2)   	///代码
	s Desc=$p(ItmTempStr,"^",3)   	///描述
	s isFlag=$p(ItmTempStr,"^",4)   ///不可用标志
	s HospID=$p(ItmTempStr,"^",5)   ///医院ID
	s TLeaderID=$p(ItmTempStr,"^",6)   /// 小组组长
	s Type=$p(ItmTempStr,"^",7)     /// 类型
	&SQL(Update DHC_EmConsultGroup Set EC_Code=:Code, EC_Desc=:Desc, EC_ActiveFlag=:isFlag, EC_Hosp_Dr=:HospID, EC_TLeader_Dr=:TLeaderID,EC_Type=:Type WHERE EC_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除
/// w ##class(web.DHCEMConsultGroup).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_EmConsultGroup Where EC_RowID=:ID)
	Q SQLCODE
}

/// Descript:	MDT小组成员
/// w ##class(web.DHCEMConsultGroup).SaveItem("1||3^1^178^12335^^N")
ClassMethod SaveItem(mListData As %String) As %String
{
	n (mListData)
	s Err=0
	F i=1:1:$L(mListData,"$$") Q:Err'=0  D
	.s TempStr=$p(mListData,"$$",i)
	.s Err=##class(web.DHCEMConsultGroup).isExist(TempStr)   /// 重复性判断 //hxy 2020-08-11 st
	.
	.Q:Err'=0 //ed
	.i $p(TempStr,"^",1) ="" D
	..s Err=..InsertItem(TempStr)
	.e  d
	..s Err=..UpdateItem(TempStr)
	.
	Q Err
}

/// Descript:	插入子表
/// w ##class(web.DHCEMConsultGroup).InsertItem("")
ClassMethod InsertItem(mListData As %String) As %String
{
	n (mListData)
	s ID=$p(mListData,"^",2)   	    /// DHC_EmConsultGroup ID
	s LocID=$p(mListData,"^",3)   	/// 科室ID
	s UserID=$p(mListData,"^",4)   	/// 成员ID
	s ContactsFlag =$p(mListData,"^",5)   	/// 联络人标识
	s DefFlag =$p(mListData,"^",6)   	 /// 默认标识
	s ChildSub=$o(^DHCEMCG(ID,"G",""),-1)+1
 	&SQL(INSERT INTO DHC_EmConsultGroupItm(EC_ParRef_Dr, EC_ChlidSub, EC_Loc_Dr, EC_User_Dr, EC_ContactsFlag, EC_DefFlag) VALUES(:ID, :ChildSub,:LocID,:UserID,:ContactsFlag,:DefFlag))
 	q SQLCODE
}

/// Descript:	更新子表
/// w ##class(web.DHCEMConsultGroup).UpdateItem("")
ClassMethod UpdateItem(mListData As %String) As %String
{
	n (mListData)
	s ID=$p(mListData,"^",1)   	     ///ID
	s LocID=$p(mListData,"^",3)   	 /// 科室ID
	s UserID=$p(mListData,"^",4)     /// 成员ID
	s ContactsFlag =$p(mListData,"^",5)   	/// 联络人标识
	s DefFlag =$p(mListData,"^",6)   	    /// 默认标识
	&SQL(Update DHC_EmConsultGroupItm Set EC_Loc_Dr=:LocID, EC_User_Dr=:UserID, EC_ContactsFlag=:ContactsFlag, EC_DefFlag=:DefFlag WHERE EC_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除 
/// w ##class(web.DHCEMConsultGroup).deleteItem("1")
ClassMethod deleteItem(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_EmConsultGroupItm Where EC_RowID=:ID)
	Q SQLCODE
}

/// Descript:	查询
/// w ##class(web.DHCEMConsultGroup).QryConsultGroup("12","1","")
ClassMethod QryConsultGroup(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s HospDr=$p(params,"^",1) //hxy 2020-05-28 
	s TypeCode=$p(params,"^",2) //hxy 2021-06-18
	
    s pid=##Class(web.DHCAPPExaRepCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCEMCG(ID)) Q:ID=""  D
	.s Type=$p(^DHCEMCG(ID),"^",6)  //类型 hxy 2021-06-18 st
	.s TypeDesc=$s(Type="DOC":"医师大科",Type="NUR":"护士专科组",1:"")
	.q:(TypeCode'="")&&(Type'=TypeCode) //ed
	.s Code=$p(^DHCEMCG(ID),"^",1)    //代码
	.s Desc=$p(^DHCEMCG(ID),"^",2)    //描述
	.s ActCode=$p(^DHCEMCG(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$p(^DHCEMCG(ID),"^",4)  //医院
	.q:HospDr'=HospID //hxy 2020-05-28
	.s HospDesc=""
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s User=""
	.s UserID=$p(^DHCEMCG(ID),"^",5)    /// 组长ID
	.i UserID'="" s User=$p(^SSU("SSUSR",UserID),"^",2)
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_HospID_"^"_HospDesc_"^"_UserID_"^"_User_"^"_Type_"^"_TypeDesc
	.s ^TMP("DHCST","web.DHCEMConsultGroup","QryConsultGroup",pid,h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="ID^Code^Desc^ActCode^ActDesc^HospID^HospDesc^TLeaderID^TLeader^Type^TypeDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	F  s index=$o(^TMP("DHCST","web.DHCEMConsultGroup","QryConsultGroup",pid,index)) Q:index=""  D
	.s ListData=$g(^TMP("DHCST","web.DHCEMConsultGroup","QryConsultGroup",pid,index))
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

/// Descript:	查询MDT子表
/// w ##class(web.DHCEMConsultGroup).QryConsultGroupItm("12","1","")
ClassMethod QryConsultGroupItm(rows As %String, page As %String, ID As %String) As %String
{
	n (rows, page, ID)
	s End = page*rows
	s Start=(page-1)*rows+1
	
    s pid=##Class(web.DHCAPPExaRepCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
	s h=0,count=0
	s CH=""
	f  s CH=$o(^DHCEMCG(ID,"G",CH)) q:CH=""  d
	.s LocID=$p(^DHCEMCG(ID,"G",CH),"^",1)    /// 科室ID
	.s LocDesc = $p(^CTLOC(LocID),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s User=""
	.s UserID=$p(^DHCEMCG(ID,"G",CH),"^",2)    /// 用户ID
	.i UserID'="" s User=$p(^SSU("SSUSR",UserID),"^",2)
	.s ContactsID=$p(^DHCEMCG(ID,"G",CH),"^",3)    /// 联络人标识
	.s ContactsFlag=$s(ContactsID="Y":"是",1:"否")
	.s DefFlagID=$p(^DHCEMCG(ID,"G",CH),"^",4)     /// 默认标识
	.s DefFlag=$s(DefFlagID="Y":"是",1:"否")
	.s h=h+1
	.s ListData=ID_"^"_ID_"||"_CH_"^"_LocID_"^"_LocDesc_"^"_UserID_"^"_User_"^"_ContactsID_"^"_ContactsFlag_"^"_DefFlagID_"^"_DefFlag
	.s ^TMP("DHCST","web.DHCEMConsultGroup","QueryAppItemTempD",pid,h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="MasID^ID^LocID^LocDesc^UserID^User^ContactsID^ContactsFlag^DefFlagID^DefFlag"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCEMConsultGroup","QueryAppItemTempD",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCEMConsultGroup","QueryAppItemTempD",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:	查询
/// w ##class(web.DHCEMConsultGroup).JsonConsGroup("")
ClassMethod JsonConsGroup(HospID As %String, Type = "") As %String
{
	n (HospID,Type,%session)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT EC_RowID, EC_Desc,EC_ActiveFlag,EC_Type FROM DHC_EmConsultGroup WHERE EC_Hosp_Dr="_HospID 
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowID = result.Data("EC_RowID")
		s Desc = result.Data("EC_Desc")
		s ActiveFlag = result.Data("EC_ActiveFlag") //hxy 2020-08-11 st
		continue:ActiveFlag'="Y" //ed
		s ECType=result.Data("EC_Type")
		continue:(Type'="")&&(ECType'=Type) //hxy 2021-06-16
		s Desc=##class(web.DHCEMConsultCom).GetTransDesc("User.DHCEmConsultGroup","ECDesc","",Desc)  //hxy 2022-12-12
		s tmp=RowID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	d result.Close()
	w "]"
	Q ""
}

/// Descript:检查代码、描述是否重复
ClassMethod isRepeat(ItmTempStr As %String) As %String
{
	N (ItmTempStr)
	s ID=$p(ItmTempStr,"^",1)       ///ID
	s Code=$p(ItmTempStr,"^",2)   	///代码
	s Desc=$p(ItmTempStr,"^",3)   	///描述
	s HospID=$p(ItmTempStr,"^",5)   ///医院ID
	/// 新记录
	Q:(ID="")&($d(^DHCEMCG(0,"Code",$$ALPHAUP^SSUTIL4(Code)))) "-1"
	;Q:(ID="")&($d(^DHCEMCG(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-1"
	Q:(ID="")&($d(^DHCEMCG(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s OldCode=$p($g(^DHCEMCG(ID)),"^",1)    //代码
	s OldDesc=$p($g(^DHCEMCG(ID)),"^",2)    //描述
	Q:(Code'=OldDesc)&($d(^DHCEMCG(0,"Code",$$ALPHAUP^SSUTIL4(Code)))) "-3"
	;Q:(Code'=Code)&($d(^DHCEMCG(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-3"
	Q:(Desc'=Desc)&($d(^DHCEMCG(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-4"
	Q 0
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCEMConsultGroup","QueryAppItemTemp",pid)
	k ^TMP("DHCST","web.DHCEMConsultGroup","QueryAppItemTempD",pid)
	q ""
}

/// Creator: 		hxy
/// CreateDate: 	2020-08-11
/// Descript:		检查是否重复
/// w ##class(web.DHCEMConsultGroup).isExist("1||3^1^178^12335^^N")
ClassMethod isExist(mListData As %String) As %String
{
	N (mListData)
	s ret=0
	s RowID=$p(mListData,"^",1)
	s ID=$p(mListData,"^",2)   	    /// DHC_EmConsultGroup ID
	s LocID=$p(mListData,"^",3)   	/// 科室ID
	s UserID=$p(mListData,"^",4)   	/// 成员ID
	
	s Type=$p(^DHCEMCG(ID),"^",6)   //类型 hxy 2021-06-18 st
	q:(Type="DOC")&&($d(^DHCEMCG(0,"LOC",LocID,ID))) -2
	q:UserID="" 0 //ed
	
	s CH=""
	f  s CH=$o(^DHCEMCG(0,"User",UserID,ID,CH)) Q:CH=""  D
	.s ItmLocID=$p(^DHCEMCG(ID,"G",CH),"^",1)    /// 科室ID
	.s ItmID=ID_"||"_CH
	.s:(ItmLocID=LocID)&(RowID="") ret=-1
	.s:(ItmLocID=LocID)&(RowID'="")&(RowID'=ItmID) ret=-1

	Q ret
}

/// Creator: 		guoguomin
/// CreateDate: 	20200908 
/// Descript:		查询大科下面的科室-河南省人民医院
/// w ##class(web.DHCEMConsultGroup).JsonConsGroupItm("1")
ClassMethod JsonConsGroupItm(ECRowID As %String) As %String
{
	n (ECRowID,%session)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT EC_Loc_Dr FROM DHC_EmConsultGroupItm WHERE EC_ParRef_Dr="_ECRowID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s LocID = result.Data("EC_Loc_Dr")
		s LocDesc = $p(^CTLOC(LocID),"^",2)
	    s LocDesc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)  ///guoguomin 20211123
		s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		s tmp=LocID_"^"_LocDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	d result.Close()
	w "]"
	Q ""
}

}
