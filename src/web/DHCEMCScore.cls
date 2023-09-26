Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descript: 	评分业务类
Class web.DHCEMCScore Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descritp:   保存评分
/// Input:      mListData-评分内容
/// Ouput:      评分ID
/// w ##Class(web.DHCEMCScore).Insert("","2^3^DOC^12^7"_$c(2)_"2^2^radio@2^2^radio@3^3^radio")
ClassMethod Insert(ID As %String, mListData As %String) As %String
{
	n (ID, mListData)
	i ID="" D
	.s ID=..InsScore(mListData)
	E  D
	.s ID=..UpdScore(ID, mListData)
	Q ID
}

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descritp:   插入评分内容
/// Input:      mListData-评分内容
/// Ouput:      申请单ID
/// w ##Class(web.DHCEMCScore).InsScore("")
ClassMethod InsScore(mListData As %String) As %String
{
	N (mListData)
	s Err=0
	TS

	/// 插入评分主表
	s ListData=$p(mListData,$C(2),1)
	s ID=..InsScoreBus(ListData)
	i ID<0 tro 1
	Q:ID<0 ID

	/// 插入评分子表
	s ListData=$p(mListData,$C(2),2)
	s Err=..InsScoreItem(ID, ListData)
	i Err'=0 tro 1
	Q:Err'=0 "-11"

	TC
	Q ID
}

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descritp:   更新评分内容
/// Input:      mListData-评分内容
/// Ouput:      申请单ID
/// w ##Class(web.DHCEMCScore).UpdScore("")
ClassMethod UpdScore(ID As %String, mListData As %String) As %String
{
	N (ID, mListData)
	s Err=0
	TS

	/// 插入评分主表
	s ListData=$p(mListData,$C(2),1)
	s Err=..UpdScoreBus(ID,ListData)
	i Err'=0 tro 1
	Q:Err'=0 "-11"
	
	/// 删除相关字表内容重新插入
	s Err=..DelScoreItem(ID)
	i Err'=0 tro 1
	Q:Err'=0 "-11"
	
	/// 插入评分子表
	s ListData=$p(mListData,$C(2),2)
	s Err=..InsScoreItem(ID, ListData)
	i Err'=0 tro 1
	Q:Err'=0 "-12"

	TC
	Q ID
}

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descript: 	插入评分主表
/// Input:      EpisodeID - 就诊ID
/// Output: 	
/// W ##Class(web.DHCEMCScore).InsScoreBus("")
ClassMethod InsScoreBus(mListData As %String) As %String
{
	n (mListData)
	s EpisodeID=$p(mListData,"^",1)  /// EpisodeID
	s UserID=$p(mListData,"^",2)     /// 创建人
	s Type=$p(mListData,"^",3)       /// 业务类型
	s ScoreID=$p(mListData,"^",4)    /// 评分表ID
	s ScoreVal=$p(mListData,"^",5)   /// 分值
	s CreateDate=+$H   		         /// 创建日期
	s CreateTime=$p($H,",",2)        /// 创建时间
	s PatChkID=$p(mListData,"^",6)   /// 分诊ID
	&SQL(Insert Into DHC_EMCScore(EC_Adm_Dr,EC_User_Dr,EC_Date,EC_Time,EC_Type,EC_Score_Dr,EC_ScoreVal,EC_Chk_Dr)
		values(:EpisodeID,:UserID,:CreateDate,:CreateTime,:Type,:ScoreID,:ScoreVal,:PatChkID))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descript: 	更新评分主表
/// Input:      EpisodeID - 就诊ID
/// Output: 	
/// W ##Class(web.DHCEMCScore).UpdScoreBus("")
ClassMethod UpdScoreBus(ID As %String, mListData As %String) As %String
{
	n (ID, mListData)
	s EpisodeID=$p(mListData,"^",1)  /// EpisodeID
	s UserID=$p(mListData,"^",2)     /// 创建人
	s Type=$p(mListData,"^",3)       /// 业务类型
	s ScoreID=$p(mListData,"^",4)    /// 评分表ID
	s ScoreVal=$p(mListData,"^",5)   /// 分值
	&SQL(Update DHC_EMCScore set EC_ScoreVal=:ScoreVal where EC_RowID=:ID)
	Q SQLCODE
}

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descript: 	插入评分子表
/// Input:      EpisodeID - 就诊ID
/// Output: 	
/// W ##Class(web.DHCEMCScore).InsScoreItem("")
ClassMethod InsScoreItem(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s Len = $L(mListData,"@")
	s quitflag=0
	F i=1:1:Len Q:quitflag'="0"  D
	.s ListData=$p(mListData,"@",i)  /// 项目列表
	.s key=$p(ListData,"^",1)        /// 元素ID
	.s Tex=$p(ListData,"^",2)        /// 元素值
	.s Type=$p(ListData,"^",3)       /// 元素类型
	.&SQL(Insert Into DHC_EMCScoreItem(EC_ParRef_Dr,EC_key,EC_val,EC_Type)
		values(:arParref,:key,:Tex,:Type))
	.i SQLCODE'=0 s quitflag="1"
	Q quitflag
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-10-21
/// Descript:    删除评分子表
/// Input:       EpisodeID - 就诊ID
/// Output: 
/// w ##Class(web.DHCEMCScore).DelScoreItem("24")
ClassMethod DelScoreItem(ID As %String) As %String
{
	n (ID)
	&SQL(delete from DHC_EMCScoreItem where EC_ParRef_Dr=:ID)
	Q SQLCODE
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-10-21
/// Descript:    自动生成表单ID
/// Input:       EpisodeID - 就诊ID
/// Output: 
/// w ##Class(web.DHCEMCScore).GetFormEleID("24")
ClassMethod GetFormEleID(ID As %String) As %String
{
   s Code=$p(^DHCEMCSS(ID),"^",1) /// 代码
   Q $i(^DHCEMCSCORE(Code,"ElementID"))
}

/// Creator: 	 qqa
/// CreateDate:  2019-10-21
/// Descript:    通过分诊ID和评分表类型ID获取评分数据主表ID
/// Input:       PCLRowID - 分诊ID Type - 评分单ID
/// Output:      
/// w ##Class(web.DHCEMCScore).GetScoreRowID("1647","11")
ClassMethod GetScoreRowID(PCLRowID, Type)
{
	n (PCLRowID,Type)
	s Ret=""
	s ID=""
	f  s ID=$o(^DHCEMCS("0","CHK",PCLRowID,ID),-1) q:(ID="")||(Ret'="")  d
	.s ECScoreDr = $p(^DHCEMCS(ID),"^",6)
	.q:ECScoreDr'=Type
	.s Ret=ID
	q Ret
}

}
