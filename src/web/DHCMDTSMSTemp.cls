Import sqluser

Class web.DHCMDTSMSTemp Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// Descript:	保存

/// w ##class(web.DHCEMConsultGroup).Save("^11^22222^Y^2")
ClassMethod Save(mListData As %String) As %String
{
	n (mListData)
	s ^BIANSHUAI(123)=mListData
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
 	&SQL(INSERT INTO DHC_MDTSMSTemp(MS_Code, MS_Desc, MS_ActiveFlag,MS_Hosp_Dr) VALUES(:Code,:Desc,:isFlag,:HospID))
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
	&SQL(Update DHC_MDTSMSTemp Set MS_Code=:Code, MS_Desc=:Desc, MS_ActiveFlag=:isFlag, MS_Hosp_Dr=:HospID WHERE MS_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除
/// w ##class(web.DHCEMConsultGroup).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MDTSMSTemp Where MS_RowID=:ID)
	Q SQLCODE
}

/// Descript:	短信内容
/// w ##class(web.DHCEMConsultGroup).SaveItem("^13^EEEEEE")
ClassMethod SaveItem(mListData As %String) As %String
{
	n (mListData)
	s Err=0
	F i=1:1:$L(mListData,"$$") Q:Err'=0  D
	.s TempStr=$p(mListData,"$$",i)
	.i $p(TempStr,"^",1) ="" D
	..s Err=..InsertItem(TempStr)
	.e  d
	..s Err=..UpdateItem(TempStr)
	Q Err
}

/// Descript:	插入子表
/// w ##class(web.DHCEMConsultGroup).InsertItem("")
ClassMethod InsertItem(mListData As %String) As %String
{
	n (mListData)
	s ID=$p(mListData,"^",2)   	    /// DHC_MDTSMTemp ID
	s text=$p(mListData,"^",3)  
	s ChildSub=$o(^DHCMDTSMST(ID,"I",""),-1)+1
 	&SQL(INSERT INTO DHC_MDTSMSTempD(MS_Temp_ParRef,MS_ChlidSub,MS_Text) VALUES(:ID,:ChildSub,:text))
 	q SQLCODE
}

/// Descript:	更新子表
/// w ##class(web.DHCEMConsultGroup).UpdateItem("")
ClassMethod UpdateItem(mListData As %String) As %String
{
	n (mListData)
	s ID=$p(mListData,"^",1)   	     ///ID
	s text=$p(mListData,"^",3)  	/// 内容
	&SQL(Update DHC_MDTSMSTempD Set MS_Text=:text WHERE MS_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除 
/// w ##class(web.DHCEMConsultGroup).deleteItem("1")
ClassMethod deleteItem(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MDTSMSTempD Where MS_RowID=:ID)
	Q SQLCODE
}

/// Descript:	查询
/// w ##class(web.DHCEMConsultGroup).QryConsultGroup("12","1","")
ClassMethod QryConsultGroup(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	
    s pid=##Class(web.DHCAPPExaRepCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s hospId = $p(params,"^",1)

	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCMDTSMST(ID)) Q:ID=""  D
	.s Code=$p(^DHCMDTSMST(ID),"^",1)    //代码
	.s Desc=$p(^DHCMDTSMST(ID),"^",2)    //描述
	.s ActCode=$p(^DHCMDTSMST(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$p(^DHCMDTSMST(ID),"^",4)  //医院
	.s HospDesc=""
	.q:hospId'=HospID
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_HospID_"^"_HospDesc
	.s ^TMP("DHCST","web.DHCEMConsultGroup","QryConsultGroup",pid,h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="ID^Code^Desc^ActCode^ActDesc^HospID^HospDesc"
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

/// 
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
	f  s CH=$o(^DHCMDTSMST(ID,"I",CH)) q:CH=""  d
	.s Text=$p(^DHCMDTSMST(ID,"I",CH),"^",1)    /// 科室ID
	
	.s h=h+1
	.s ListData=ID_"^"_ID_"||"_CH_"^"_Text
	.s ^TMP("DHCST","web.DHCEMConsultGroup","QueryAppItemTempD",pid,h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="MasID^ID^Text"
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
ClassMethod JsonConsGroup(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT _RowID, _Desc FROM DHC_AppItemTemp WHERE _Hosp_Dr="_HospID 
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowID = result.Data("_RowID")
		s Desc = result.Data("_Desc")
		s tmp=RowID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
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
	Q:(ID="")&($d(^DHCMDTSMST(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-1"
	Q:(ID="")&($d(^DHCMDTSMST(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s Code=$p($g(^DHCMDTSMST(ID)),"^",1)    //代码
	s Desc=$p($g(^DHCMDTSMST(ID)),"^",2)    //描述
	Q:(Code'=Code)&($d(^DHCMDTSMST(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-3"
	Q:(Desc'=Desc)&($d(^DHCMDTSMST(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-4"
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

/// w ##Class(web.DHCMDTSMSTemp).GetItemTempNotes("5")
ClassMethod GetItemTempNotes(ID As %String) As %String
{
	n (ID)
	q:'$D(^DHCMDTSMST(ID)) ""
	s CH=""
	s CH=$o(^DHCMDTSMST(ID,"I",CH))
	q:CH=""
	s aitNotes=$p(^DHCMDTSMST(ID,"I",CH),"^",1)    //注意事项
	s ListData=ID_"||"_CH_"^"_aitNotes
	s ListTitle="itemTempId^itemTempDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// d ##Class(%ResultSet).RunQuery("web.DHCMDTSMSTemp","KC24","")
Query KC24(warID As %String) As %Query(ROWSPEC = "EpisodeID,PatientID")
{
}

ClassMethod KC24Execute(ByRef qHandle As %Binary, warID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
	       s CstID=0 ,DocEpisodeID="" //会诊表
	       F  s CstID=$o(^DHCEMCON(CstID)) Q:CstID=""  D
	        .s EpisodeID=$p(^DHCEMCON(CstID),"^",1)   /// 就诊ID
	        .i EpisodeID=1128 b ;2
			.;q:'$d(^PAADM(EpisodeID))
			.s EpisodeIDstr="#"_EpisodeID_"*"
			.q:DocEpisodeID[EpisodeIDstr
			.s DocEpisodeID=DocEpisodeID_EpisodeIDstr
	        .s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	        .s PatWardID=$p(^PAADM(EpisodeID),"^",70)
	        .Q:PatWardID'=warID
			.d Output
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Output
 	Set DATA=$lb(EpisodeID,PatientID)
 	Set ^CacheTemp(repid,ind)=DATA
 	Set ind=ind+1
 	Quit $$$OK
}

ClassMethod KC24Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = KC24Execute ]
{
 	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod KC24Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = KC24Execute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 	 	Set Row=""
 	}
 	Else{	
 	 	Set Row=^CacheTemp(repid,ind)
 	}
 		Set qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

}
