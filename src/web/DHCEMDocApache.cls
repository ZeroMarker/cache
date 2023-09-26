Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2018-08-23
/// Descript: 		APACHE II评分表
Class web.DHCEMDocApache Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	APACHE II评分表
/// w ##class(web.DHCEMDocApache).Insert("","89942444^1322^18^APACHE^A:A-1#B:B-3#D-1:D-1-2#D-2:D-2-2#D-3:D-3-2#D-4:D-4-2#D-5:D-5-6#D-6:D-6-2")
ClassMethod Insert(ID As %String, mListData As %String) As %String
{
	n (ID, mListData)
	i ID="" D
	.s ID=..InsApache(mListData)
	E  D
	.s ID=..UpdApache(ID, mListData)
	Q ID
}

/// Descritp:  插入APACHE II评分表
/// Input:     mListData-会诊申请内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMConsult).InsApache("")
ClassMethod InsApache(mListData As %String) As %String
{
	N (mListData)
	s Err=0
	TS

	/// 评分主表
	s ID=..InsApaMaster(mListData)
	i ID<0 tro
	Q:ID<0 ID

	/// 评分子表
	s Err=..InsApaItem(ID, mListData)
	i Err'=0 tro
	Q:Err'=0 "-11"

	TC
	Q ID
}

/// Descritp:  更新APACHE II评分表
/// Input:     mListData-会诊申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMDocApache).UpdApache("^11843^^APACHE^")
ClassMethod UpdApache(ID As %String, mListData As %String) As %String
{
	N (ID, mListData)
	s Err=0
	TS

	/// 评分主表
	s ID=..UpdApaMaster(ID,mListData)
	i ID<0 tro
	Q:ID<0 ID
	
	/// 删除相关字表内容重新插入
	s Err=..DeltMasSubTable(ID)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 评分子表
	s Err=..InsApaItem(ID, mListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	TC
	Q ID
}

/// Descritp:  插入APACHE II评分表
ClassMethod InsApaMaster(mListData As %String) As %String
{
	n (mListData)
	s EpisodeID=$p(mListData,"^",1)     /// EpisodeID
	s CsRUserID=$p(mListData,"^",2)     /// 操作人
	s CsRDate=+$H   		            /// 操作日期
	s CsRTime=$p($H,",",2)              /// 操作时间
	&SQL(Insert Into DHC_EmScore(SCORE_Adm_Dr,SCORE_CreateUser_Dr,SCORE_CreateDate,SCORE_CreateTime,SCORE_UpdateUser_Dr,SCORE_UpdateDate,SCORE_UpdateTime)
		values(:EpisodeID,:CsRUserID,:CsRDate,:CsRTime,:CsRUserID,:CsRDate,:CsRTime))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descritp:  插入APACHE II评分表
ClassMethod UpdApaMaster(ID As %String, mListData As %String) As %String
{
	n (ID, mListData)
	s EpisodeID=$p(mListData,"^",1)     /// EpisodeID
	s CsRUserID=$p(mListData,"^",2)     /// 操作人
	s CsRDate=+$H   		            /// 操作日期
	s CsRTime=$p($H,",",2)              /// 操作时间
	&SQL(Update DHC_EmScore Set SCORE_UpdateUser_Dr=:CsRUserID,SCORE_UpdateDate=:CsRDate,SCORE_UpdateTime=:CsRTime Where SCORE_RowID=:ID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descritp:  插入APACHE II评分子表
ClassMethod InsApaItem(ID As %String, mListData As %String) As %String
{
	n (ID, mListData)
	s Score=$p(mListData,"^",3)     /// 总分
	s TypeCode=$p(mListData,"^",4)  /// 评分类型
	s items=$p(mListData,"^",5)     /// 项目串
	s ChildSub=$o(^DHCEMSCORE(ID,"I",""),-1)+1
	b ;err
	&SQL(Insert Into DHC_EmScoreItm(SCORE_Itm_ParRef,SCORE_ChildSub,SCORE_Score,SCORE_TypeCode,SCORE_Item_Dr)
		values(:ID,:ChildSub,:Score,:TypeCode,:items))
	b ;err2
	Q SQLCODE
}

/// Descript: 删除会诊申请子表和关联表数据
/// w ##Class(web.DHCEMConsult).DelCstMasSubTable("24")
ClassMethod DeltMasSubTable(ID) As %String
{
	n (ID)
	s SQLCODE=0
	
	///  评分子表
	i $o(^DHCEMSCORE(ID,"I","")) D
	.&SQL(delete from DHC_EmScoreItm where SCORE_Itm_ParRef=:ID)
	Q:SQLCODE'=0 SQLCODE
	
	Q SQLCODE
}

/// Descript:查询
/// w ##class(web.DHCEMDocApache).QryEmApache("12","1","186")
ClassMethod QryEmApache(rows As %String, page As %String, EpisodeID As %String, mType As %String) As %String
{
	N (rows, page, EpisodeID, mType)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCEMSCORE(0,"Adm",+EpisodeID,ID)) Q:ID=""  D
	.s Type=..GetScoreType(ID)
	.q:Type'=mType
	.s CreUser=""
	.s CreUserID=$p(^DHCEMSCORE(ID),"^",2)  /// 创建人
	.s:CreUserID'="" CreUser=$p(^SSU("SSUSR",CreUserID),"^",2)
	.s CreDate=$p(^DHCEMSCORE(ID),"^",3)    /// 创建日期
	.s:CreDate'="" CreDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CreDate)
	.s CreTime=$p(^DHCEMSCORE(ID),"^",4)    /// 创建时间
	.s:CreTime'="" CreTime=$zt(CreTime,1)
	.s UpdUser=""
	.s UpdUserID=$p(^DHCEMSCORE(ID),"^",5)  /// 更新人
	.s:UpdUserID'="" UpdUser=$p(^SSU("SSUSR",UpdUserID),"^",2)
	.s UpdDate=$p(^DHCEMSCORE(ID),"^",6)    /// 更新日期
	.s:UpdDate'="" UpdDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(UpdDate)
	.s UpdTime=$p(^DHCEMSCORE(ID),"^",7)    /// 更新时间
	.s:UpdTime'="" UpdTime=$zt(UpdTime,1)
	.s Scorce=$p(^DHCEMSCORE(ID,"I",1),"^",3)
	.s h=h+1
	.s ListData=ID_"^"_CreUser_"^"_CreDate_"^"_CreTime_"^"_UpdUser_"^"_UpdDate_"^"_UpdTime_"^"_Scorce
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^CreUser^CreDate^CreTime^UpdUser^UpdDate^UpdTime^Scorce"
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

/// Descript:获取Apache分值内容
/// w ##class(web.DHCEMDocApache).GetDocApache("12")
ClassMethod GetDocApache(ID As %String) As %String
{
	n (ID)
	Q:'$d(^DHCEMSCORE(ID)) ""
	s DocApache=$p(^DHCEMSCORE(ID,"I",1),"^",5)
	Q DocApache
}

/// Descript:获取分值类型
/// w ##class(web.DHCEMDocSofa).GetScoreType("12")
ClassMethod GetScoreType(ID As %String) As %String
{
	n (ID)
	q:'$d(^DHCEMSCORE(ID)) ""
	s Type=$p(^DHCEMSCORE(ID,"I",1),"^",4)
	q Type
}

/// Descript:	删除
/// w ##class(web.DHCEMDocApache).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_EmScore Where SCORE_RowID=:ID)
	Q SQLCODE
}

/// w ##class(web.DHCEMDocApache).GetAppacheScore(94)
ClassMethod GetAppacheScore(EpisodeID)
{
	n (EpisodeID)
	s ScoreVal=""
	s ID=0
	f  s ID=$o(^DHCEMCS(0,"ADM",EpisodeID,ID)) q:ID=""  d
	.s ScoreID=$p(^DHCEMCS(ID),"^",6)  /// 评分表ID
	.s ScoreCode=$p(^DHCEMCSS(ScoreID),"^",1) /// 代码
	.q:ScoreCode'["APACHE II"
	.s ScoreVal=$p(^DHCEMCS(ID),"^",7) /// 分值
	q ScoreVal
}

}
