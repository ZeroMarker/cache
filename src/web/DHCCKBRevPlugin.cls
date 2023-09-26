Import sqluser

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-25
/// Descript: 		知识图谱审查插件
Class web.DHCCKBRevPlugin Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-25
/// Descript:		保存插件
/// W ##Class(web.DHCCKBRevPlugin).SaveOrUpdate("")
ClassMethod SaveOrUpdate(ID As %String, Code As %String, Desc As %String) As %String
{
	n (ID, Code, Desc)
	s Err=0
	i ID="" s ID=..Save(Code, Desc)
	E  s ID=..Update(ID, Code, Desc)
	Q ID
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-25
/// Descript:		保存插件
/// W ##Class(web.DHCCKBRevPlugin).Save("")
ClassMethod Save(Code As %String, Desc As %String) As %String
{
	n (Code, Desc)
	&SQL(INSERT INTO DHC_CKBPluginTemp(PT_Code, PT_Desc) VALUES(:Code,:Desc))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-25
/// Descript:		保存插件
/// W ##Class(web.DHCCKBRevPlugin).Update("")
ClassMethod Update(ID As %String, Code As %String, Desc As %String) As %String
{
	n (ID, Code, Desc)
	&SQL(update DHC_CKBPluginTemp set PT_Code=:ScoreCode, PT_Desc=:ScoreDesc where PT_RowID=:ID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Creator: 	bianshuai
/// CreateDate: 2019-10-21
/// Descritp:   保存Html
/// Input:      mListData-模板内容
/// Ouput:      模板ID
/// w ##Class(web.DHCCKBRevPlugin).InsHtml("29","")
ClassMethod InsHtml(ID As %String, Html As %String) As %String
{
	n (ID, Html)

	&SQL(update DHC_CKBPluginTemp set PT_Html=:Html where PT_RowID=:ID)
	Q SQLCODE
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-10-21
/// Descript:    删除模板
/// Input:       EpisodeID - 就诊ID
/// Output: 
/// w ##Class(web.DHCCKBRevPlugin).delRevPlugin("24")
ClassMethod delRevPlugin(ID As %String) As %String
{
	n (ID)
	&SQL(delete from DHC_CKBPluginTemp where PT_RowID=:ID)
	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-25
/// Descript:		提取插件
/// W ##Class(web.DHCCKBRevPlugin).GetRevPluHtml("")
ClassMethod GetRevPluHtml(ID As %String) As %String
{
	n (ID)
	W $p(^DHCCKBPTEMP(ID),"^",3)
	Q ""
}

/// Creator: 	    bianshuai
/// CreateDate: 	2020-12-25
/// Descript:		提取插件
/// Input:      
/// Output:
/// w ##class(web.DHCCKBRevPlugin).GetRevPluObj("15","")
ClassMethod GetRevPluObj(ID As %String) As %String
{
	n (ID)
	s Code="", Desc=""
	i $d(^DHCCKBPTEMP(ID)) D
	.s Code=$p(^DHCCKBPTEMP(ID),"^",1)
	.s Desc=$p(^DHCCKBPTEMP(ID),"^",2)
	s ListData=ID_"^"_Code_"^"_Desc
	s ListTitle="ID^Code^Desc"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-25
/// Descript:		本地审查插件列表
/// W ##Class(web.DHCCKBRevPlugin).JsGetRevPlugin("")
ClassMethod JsGetRevPlugin(Params As %String) As %String
{
	n (Params)

	s num=0
	k TmpArr
	    
	s ID=""
	F  s ID=$o(^DHCCKBPTEMP(ID)) Q:ID=""  D
	.s Code=$p(^DHCCKBPTEMP(ID),"^",1) /// 代码
	.s Desc=$p(^DHCCKBPTEMP(ID),"^",2) /// 描述
	.s TmpArr(ID)=ID_"^"_Code_"^"_Desc
	.
	
	///转换数据为Json格式
	s ListTitle="itemId^itemCode^itemDesc"
	
	s del=""""
	W ##class(web.DHCEMJsonCommon).getJsonStartSign(num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.
	W "]}"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-25
/// Descript:		模板输出
/// W ##Class(web.DHCCKBRevPlugin).JsGetRevPluginTemp("")
ClassMethod JsGetRevPluginTemp(ID As %String) As %String
{
	n (ID)
	s ID=$o(^DHCCKBPTEMP(""),-1)
	s Code=$p(^DHCCKBPTEMP(ID),"^",1)
	s Desc=$p(^DHCCKBPTEMP(ID),"^",2)
	s Html=$p(^DHCCKBPTEMP(ID),"^",3)
	s Html = $replace(Html,"class=""row""","class=""ckb-row""")
	s ListData=Code_"^"_Desc_"^"_Html
	s ListTitle="Code^Desc^Html"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2021-01-20
/// Descript:		插件元素
/// W ##Class(web.DHCCKBRevPlugin).JsGetRevPluElement("")
ClassMethod JsGetRevPluElement(area As %String) As %String
{
	n (area)

	s num=0
	k TmpArr
	
	i area="monHead" D
	.s TmpArr(1)="item.item^药品名称^^V"
	.s TmpArr(2)="^详情信息^ckb-view-item-more^V"
	.s TmpArr(3)="^用药教育^item-edu^V"
	.s TmpArr(4)="^推荐用药^item-recmedical^V"
	
	i area="monBody" D
	.s TmpArr(1)="warn.keyname^问题目录^ruleColorCss^V"
	.s TmpArr(2)="rule.manLev^管控级别^ruleColorCss^V"
	.s TmpArr(3)="msg^目录提醒^^V"
	.s TmpArr(4)="val^提示消息^^V"
	.s TmpArr(5)="ruleSource^参考依据^view-item-ruleSource^V"
	
	i (area="monBase")||(area="monDeta") D
	.s TmpArr(1)="base.AgeProp^年龄^^K"
	.s TmpArr(2)="base.DayDose^剂量^^K"
	.s TmpArr(3)="base.DrugFreq^频次^^K"
	.s TmpArr(4)="base.DrugPreMet^给药方式^^K"
	.s TmpArr(5)="base.Height^身高^^K"
	.s TmpArr(6)="base.Weight^体重^^K"
	.s TmpArr(7)="base.OnceDose^每日用量^^K"
	.s TmpArr(8)="base.Treatment^持续时间^^K"
	.s TmpArr(9)="^默认标签^^L"
	.s TmpArr(10)="^说明书^item-link-intoducation^L"
	.s TmpArr(11)="^参考文献^item-link-literature^L"
	.
	
	///转换数据为Json格式
	s ListTitle="itemCode^itemDesc^itemCss^showType"
	
	s del=""""
	W "["
	s index="",count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.
	W "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2021-01-28
/// Descript:		审查目录
/// W ##Class(web.DHCCKBRevPlugin).JsGetRevLibArr("")
ClassMethod JsGetRevLibArr(q As %String) As %String
{
	n (q)
	s input=q 
	s input=$ZCVT(input,"U")
	s count=0
	w "["
	s Label=##Class(web.DHCCKBCommon).GetDrugLibaryData()
	s ID=""   
	F  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Label,ID))   Q:ID=""  D
	.s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)
	.s tmp=Desc_"^"_Desc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	W $s(count=0:"",1:",")_##class(web.DHCAPPJsonCommon).getJsonData("value^text","ALL^通用模板")
	w "]"
	Q ""
}

}
