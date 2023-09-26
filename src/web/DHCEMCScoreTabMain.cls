Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2019-08-20
/// Descript: 	评分表维护类
Class web.DHCEMCScoreTabMain Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descritp:   保存评分维护表
/// Input:      mListData-评分内容
/// Ouput:      评分ID
/// w ##Class(web.DHCEMCScoreTabMain).Insert("12","APACHE II评分表1","APACHE II评分表1")
ClassMethod Insert(ID As %String, Code As %String, Desc As %String) As %String
{
	n (ID, Code, Desc)
	
	s HasID=$o(^DHCEMCSS(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	q:(ID="")&&(HasID'="") -1
	q:(ID'="")&&(HasID'="")&&(ID'=HasID) -1	  //代码不能重复
	s HasID=$o(^DHCEMCSS(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),""))
	q:(ID="")&&(HasID'="") -2
	q:(ID'="")&&(HasID'="")&&(ID'=HasID) -2   //名称不能重复
	
	i ID="" D
	.s ID=..InsScoreTabMain(Code, Desc)
	E  D
	.s ID=..UpdScoreTabMain(ID, Code, Desc)
	Q ID
}

/// Creator: 	bianshuai
/// CreateDate: 2019-08-20
/// Descript: 	插入评分维护表
/// Input:      
/// Output: 
ClassMethod InsScoreTabMain(ScoreCode, ScoreDesc) As %String
{
	n (ScoreCode, ScoreDesc)
	;Q:$d(^DHCEMCSS(0,"Code",$$ALPHAUP^SSUTIL4(ScoreCode))) "-1" //hxy 2020-03-03 代码不能重复
	;Q:$d(^DHCEMCSS(0,"Desc",$$ALPHAUP^SSUTIL4(ScoreDesc))) "-2" //hxy 2020-03-03 名称不能重复
	&SQL(INSERT INTO DHC_EMCScoreScale(EC_Code, EC_Desc) VALUES(:ScoreCode,:ScoreDesc))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Creator: 	bianshuai
/// CreateDate: 2019-08-20
/// Descript: 	更新评分维护表
/// Input:      
/// Output: 
ClassMethod UpdScoreTabMain(ID, ScoreCode, ScoreDesc) As %String
{
	n (ID, ScoreCode, ScoreDesc)
	&SQL(update DHC_EMCScoreScale set EC_Code=:ScoreCode, EC_Desc=:ScoreDesc where EC_RowID=:ID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descritp:   保存评分维护表
/// Input:      mListData-评分内容
/// Ouput:      评分ID
/// w ##Class(web.DHCEMCScoreTabMain).InsHtml("29","")
ClassMethod InsHtml(ID As %String, Html As %String, FormEls As %String) As %String
{
	n (ID, Html, FormEls)
	
	s Err=0
	TS
	/// 插入评分维护表Html
	s Err=..InsScoreHtml(ID, Html)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 删除相关字表内容重新插入
	s Err=..DelScoreForm(ID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 插入评分表单元素
	s Err=..InsScoreForm(ID, FormEls)
	i Err'=0 tro
	Q:Err'=0 "-13"
	TC
	Q Err
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-10-21
/// Descript:    删除评分子表
/// Input:       EpisodeID - 就诊ID
/// Output: 
/// w ##Class(web.DHCEMCScore).DelScoreForm("24")
ClassMethod DelScoreForm(ID As %String) As %String
{
	n (ID)
	s SQLCODE=0
	i $D(^DHCEMCSF(0,"Parref",ID)) D
	.&SQL(delete from DHC_EMCScoreForm where EC_ParRef_Dr=:ID)
	Q SQLCODE
}

/// Creator: 	bianshuai
/// CreateDate: 2019-08-20
/// Descript: 	插入评分维护表Html
/// Input:      
/// Output: 
ClassMethod InsScoreHtml(ScoreID As %String, ScoreHtml As %String) As %String
{
	n (ScoreID, ScoreHtml)
	&SQL(update DHC_EMCScoreScale set EC_Html=:ScoreHtml where EC_RowID=:ScoreID)
	Q SQLCODE
}

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descript: 	插入评分表单元素
/// Input:      EpisodeID - 就诊ID
/// Output: 	
/// W ##Class(web.DHCEMCScore).InsScoreForm("")
ClassMethod InsScoreForm(ID As %String, mListData As %String) As %String
{
	n (ID, mListData)
	s Len = $L(mListData,"@")
	s quitflag=0
	F i=1:1:Len Q:quitflag'="0"  D
	.s ListData=$p(mListData,"@",i)  /// 项目列表
	.Q:ListData=""
	.s key=$p(ListData,"^",1)        /// 元素ID
	.s Tex=$p(ListData,"^",2)        /// 元素值
	.s Type=$p(ListData,"^",3)       /// 元素类型
	.&SQL(Insert Into DHC_EMCScoreForm(EC_ParRef_Dr,EC_key,EC_Text,EC_Type)
		values(:ID,:key,:Tex,:Type))
	.i SQLCODE'=0 s quitflag="1"
	Q quitflag
}

/// Creator: 	bianshuai
/// CreateDate: 2019-08-20
/// Descript: 	取评分维护表
/// Input:      
/// Output:
/// w ##class(web.DHCEMCScoreTabMain).GetScoreScale("15","")
ClassMethod GetScoreScale(ScoreID As %String, ScoreCode As %String) As %String
{
	n (ScoreID, ScoreCode)
	s ScoreCode=$p(^DHCEMCSS(ScoreID),"^",1)
	s ScoreDesc=$p(^DHCEMCSS(ScoreID),"^",2)
	s ListData=ScoreID_"^"_ScoreCode_"^"_ScoreDesc
	s ListTitle="ScoreID^ScoreCode^ScoreDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator: 	bianshuai
/// CreateDate: 2019-08-20
/// Descript: 	取评分维护表Html
/// Input:      
/// Output:
/// w ##class(web.DHCEMCScoreTabMain).GetScoreTabHtml("15","")
ClassMethod GetScoreTabHtml(ScoreID As %String, ScoreCode As %String, LangId = "") As %String
{
	n (ScoreID, ScoreCode,LangId)
	i ScoreID="" s ScoreID=$o(^DHCEMCSS(0,"Code",$$ALPHAUP^SSUTIL4(ScoreCode),""))
	;i ScoreID'="" W $p(^DHCEMCSS(ScoreID),"^",3) //hxy 2022-10-12 只要思想不滑坡，总能翻译的 st
	s HTML=""
	i ScoreID'="" s HTML=$p(^DHCEMCSS(ScoreID),"^",3)
	if LangId'="" {
		s result=##class(%Library.ResultSet).%New("websys.DHCTranslation:FindPageItems")
		s sc=result.Execute("dhcemc.scoretabreview.csp",LangId)
 		s colNum=result.GetColumnCount() //列数
	 	While(result.Next())
		{ 
			s itemname="",translation=""
			For i=1:1:colNum Do
			.i result.GetColumnName(i)="itemname" s itemname=$P(result.%GetData(i),$C(13,10))
			.i result.GetColumnName(i)="translation" s translation=$P(result.%GetData(i),$C(13,10))
			.s:translation'="" HTML=$replace(HTML,itemname,translation)			
		 }	
	}
	w HTML //ed

	Q ""
}

/// Descript:查询
/// w ##class(web.DHCEMCScoreTabMain).QryScoreScale("12","1","")
ClassMethod QryScoreScale(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCEMCSS(ID)) Q:ID=""  D
	.s Code=$p(^DHCEMCSS(ID),"^",1)    //代码
	.s Desc=$p(^DHCEMCSS(ID),"^",2)    //描述
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc"
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

/// Descritp:	类型
/// w ##Class(web.DHCEMCScoreTabMain).JsRelType()
ClassMethod JsRelType() As %String
{
	
	d ##Class(web.DHCEMCScoreTabMain).RelList(.TmpArr)
	
	w "["
	s index="", count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",ListData)
	.e  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",ListData)
	w "]"
	Q ""
}

/// w ##Class(web.DHCEMCScoreTabMain).RelList("22")
ClassMethod RelList(ByRef TmpArr)
{
	;EpisodeID,PatChkID
	;code^desc^获取值的方法
	s TmpArr(1)="temp^体温^##Class(web.DHCEMCScoreTabMain).GetChkTemp(EpisodeID,PatChkID)"
	s TmpArr(2)="aware^意识状态^##Class(web.DHCEMCScoreTabMain).GetChkAware(EpisodeID,PatChkID)"
	s TmpArr(3)="age^年龄^##Class(web.DHCEMCScoreTabMain).GetPapmiAge(EpisodeID)"
	s TmpArr(4)="sbp^收缩压^##Class(web.DHCEMCScoreTabMain).GetChkSbp(EpisodeID,PatChkID)"
	s TmpArr(5)="breath^呼吸^##Class(web.DHCEMCScoreTabMain).GetChkBreath(EpisodeID,PatChkID)"
	q ""
}

/// w ##Class(web.DHCEMCScoreTabMain).RelListJson("","106")
ClassMethod RelListJson(EpisodeID, PatChkID) As %String
{
	
	d ##Class(web.DHCEMCScoreTabMain).RelList(.TmpArr)
	
	s Title="",ItmData=""
	s Number=0,Index=""
	f  s Index=$o(TmpArr(Index)) Q:Index=""  D
	.s ListData=$g(TmpArr(Index))
	.s Code = $p(ListData,"^",1)
	.s Press = $p(ListData,"^",3)
	.s AllPress = "s Ret="_Press
	.x AllPress
	.q:Ret=""
	.s Number=Number+1
	.s $p(Title,"^",Number)=Code
	.s $p(ItmData,"^",Number)=Ret
	q:Title="" "{}"
	q ##class(web.DHCEMJsonCommon).getJsonData(Title,ItmData)
}

/// 获取分诊最后一次的体温
/// w ##Class(web.DHCEMCScoreTabMain).GetChkTemp("22")
ClassMethod GetChkTemp(EpisodeID, PatChkID)
{
	n (EpisodeID,PatChkID)
	s EmPCLvID=""
	i PatChkID="" d
	.s:$d(^DHCEMPCA(0,"AdmChkLev",+EpisodeID))>=10 EmPCLvID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	s:PatChkID'="" EmPCLvID=PatChkID
	q:EmPCLvID="" ""
	s EmPatChkSign=##Class(web.DHCEMPatCheckLevQuery).GetEmPatChkSignItm(EmPCLvID)
	q $p(EmPatChkSign,"@",2)
}

/// 获取分诊意识状态
/// w ##Class(web.DHCEMCScoreTabMain).GetChkAware("22")
ClassMethod GetChkAware(EpisodeID, PatChkID)
{
	n (EpisodeID,PatChkID)
	s EmPCLvID=""
	i PatChkID="" d
	.s:$d(^DHCEMPCA(0,"AdmChkLev",+EpisodeID))>=10 EmPCLvID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	s:PatChkID'="" EmPCLvID=PatChkID
	q:EmPCLvID="" ""
	s EmAware=$p(^DHCEMPCL(EmPCLvID),"^",17) 	    /// 意识状态
	s:EmAware'="" EmAware=$p($g(^DHCEMPAW(EmAware)),"^",2)
	q EmAware
}

/// 获取年龄
/// w ##Class(web.DHCEMCScoreTabMain).GetPapmiAge("17624")
ClassMethod GetPapmiAge(EpisodeID)
{
	n (EpisodeID)
	q:EpisodeID="" ""
	s HospID=##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
	s PatientID=+$g(^PAADM(EpisodeID))
	s PatAge = ##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",HospID)
	q:PatAge["未知" ""
	s Ret=""
	s:PatAge["岁" Ret=+PatAge
	s:PatAge'["岁" Ret=0
	q Ret
}

/// 获取分诊收缩压
/// w ##Class(web.DHCEMCScoreTabMain).GetChkSbp("22")
ClassMethod GetChkSbp(EpisodeID, PatChkID)
{
	n (EpisodeID,PatChkID)
	s EmPCLvID=""
	i PatChkID="" d
	.s:$d(^DHCEMPCA(0,"AdmChkLev",+EpisodeID))>=10 EmPCLvID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	s:PatChkID'="" EmPCLvID=PatChkID
	q:EmPCLvID="" ""
	s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",EmPCLvID,""),-1)
	s EmPcsSBP=$p(^DHCEMPCS(EmPcsID),"^",6)    /// 血压(BP)收缩压
	q EmPcsSBP
}

/// 获取分诊收缩压
/// w ##Class(web.DHCEMCScoreTabMain).GetChkBreath("","27")
ClassMethod GetChkBreath(EpisodeID, PatChkID)
{
	n (EpisodeID,PatChkID)
	s EmPCLvID=""
	i PatChkID="" d
	.s:$d(^DHCEMPCA(0,"AdmChkLev",+EpisodeID))>=10 EmPCLvID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	s:PatChkID'="" EmPCLvID=PatChkID
	q:EmPCLvID="" ""
	s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",EmPCLvID,""),-1)
	q $p(^DHCEMPCS(EmPcsID),"^",9)    /// 血压(BP)收缩压
}

}
