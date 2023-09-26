/// Shy
/// 2022-7-15
/// 通用名关联ICD-项目数据采集
Class web.DHCCKBGenDrugLinkIcd Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 取ICD关联通用名列表
/// w ##class(web.DHCCKBGenDrugLinkIcd).GetDrugLinkIcdList(1,500,100,"呕","")
ClassMethod GetDrugLinkIcdList(rows As %String, page As %String, HospDesc, Querypara = "", Queryloc = "") As %String
{
	n (rows,page,HospDesc,Querypara,Queryloc)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	
	q:HospDesc="" ""
	s Len=$l(HospDesc,"^")
	f m=1:1:Len  d
	.s $p(HospDesc,"^",m)=$p(^CT("HOSP",$p(HospDesc,"^",m)),"^",2)

	//k ^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd","蚌埠一院")
	//s ^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName,PatDiag)="通用名^诊断^通用名诊断数量^通用名下所有诊断数^通用名所有处方数"
	s index=0
	
	s Len=$l(HospDesc,"^")
	f i=1:1:Len  d
	.s Hosp=$p(HospDesc,"^",i)
	.s GenName=""  f  s GenName=$o(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName))  q:GenName=""  d
	..s PatDiag="" f  s PatDiag=$o(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName,PatDiag))  q:PatDiag=""  d
	...s GenName=$p(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName,PatDiag),"^",2)
	...s DiaName=$p(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName,PatDiag),"^",1)
	...s GenDiaNum=$p(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName,PatDiag),"^",3)
	...s GenDiaAllNum=$p(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName,PatDiag),"^",4)
	...s GenAllNum=$p(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName,PatDiag),"^",5)
	...s ^TmpGenHosp("web.DHCCKBGenDrugLinkIcd",GenName,Hosp)=GenAllNum
	...s ^TmpGenHosp("web.DHCCKBGenDrugLinkIcd",GenName,DiaName,Hosp)=GenDiaNum
	...s ^TmpDiaHosp("web.DHCCKBGenDrugLinkIcd",GenName,Hosp)=GenDiaAllNum
	
	//融合多个医院数据
	//通用名
	f p=1:1:Len  d
	.s Hosp=$p(HospDesc,"^",p)
	.s GenName="" f  s GenName=$o(^TmpGenHosp("web.DHCCKBGenDrugLinkIcd",GenName)) q:GenName=""  d
	..s ^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenName)=+$g(^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenName))+$g(^TmpGenHosp("web.DHCCKBGenDrugLinkIcd",GenName,Hosp)) 
	//通用名+诊断
	f p=1:1:Len  d
	.s Hosp=$p(HospDesc,"^",p)
	.s GenName="" f  s GenName=$o(^TmpGenHosp("web.DHCCKBGenDrugLinkIcd",GenName)) q:GenName=""  d
	..s DiaName="" f  s DiaName=$o(^TmpGenHosp("web.DHCCKBGenDrugLinkIcd",GenName,DiaName)) q:DiaName=""  d
	...q:HospDesc[DiaName
	...s ^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenName,DiaName)=+$g(^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenName,DiaName))+(+$g(^TmpGenHosp("web.DHCCKBGenDrugLinkIcd",GenName,DiaName,Hosp)))
	//通用名下所有诊断
	f p=1:1:Len  d
	.s Hosp=$p(HospDesc,"^",p)
	.s GenName="" f  s GenName=$o(^TmpDiaHosp("web.DHCCKBGenDrugLinkIcd",GenName)) q:GenName=""  d
	..s ^TmpDiaCountArr("web.DHCCKBGenDrugLinkIcd",GenName)=+$g(^TmpDiaCountArr("web.DHCCKBGenDrugLinkIcd",GenName))+$g(^TmpDiaHosp("web.DHCCKBGenDrugLinkIcd",GenName,Hosp)) 
	
	s GenNameStr=""
	f  s GenNameStr=$o(^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr))  q:GenNameStr=""  d  
	.s PatDiagStr="" f  s PatDiagStr=$o(^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr,PatDiagStr)) q:PatDiagStr=""  d
	..q:HospDesc[PatDiagStr  //过滤医院节点
	..s index=index+1
	..s Lv=0,Lv2=0
	..s:^TmpDiaCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr)'=0 Lv=$e((^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr,PatDiagStr)/^TmpDiaCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr)),0,5)*100_"%"
	..s:^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr)'=0 Lv2=$e((^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr,PatDiagStr)/^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr)),0,5)*100_"%"
	..s:$e(Lv,1)="." Lv="0"_Lv
	..s:$e(Lv2,1)="." Lv2="0"_Lv2
	..s OrderFlag=^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr,PatDiagStr)*10000+index
	..s ^TMPLinkICDArr("web.DHCCKBGenDrugLinkIcd",OrderFlag)=$p(GenNameStr,"@@",1)_"^"_$p(GenNameStr,"@@",2)_"^"_PatDiagStr_"^"_^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr,PatDiagStr)_"^"_Lv_"^"_Lv2

	
	s ListTitle="Loc^Gen^Dia^DiaGen^Lv^Lv2"
	W "{"
	w """"_"rows"_""""_":"_"["
	s index="",count=0
	F  s index=$o(^TMPLinkICDArr("web.DHCCKBGenDrugLinkIcd",index),-1) Q:index=""  D
	.s ListData=$g(^TMPLinkICDArr("web.DHCCKBGenDrugLinkIcd",index))
	.s LocOut=$p(ListData,"^",1)
	.s GenOut=$p(ListData,"^",2)
	.s DiaOut=$p(ListData,"^",3)
	.Q:(Querypara'="")&&(GenOut'[Querypara)&&(DiaOut'[Querypara)
	.Q:(Queryloc'="")&&(LocOut'=Queryloc)
	.//Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W "]"
	w ","
	w """"_"total"_""""_":"_count
	w "}"
	k ^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd")
	k ^TmpDiaCountArr("web.DHCCKBGenDrugLinkIcd")
	k ^TMPLinkICDArr("web.DHCCKBGenDrugLinkIcd")
	k ^TmpGenHosp("web.DHCCKBGenDrugLinkIcd")
	k ^TmpDiaHosp("web.DHCCKBGenDrugLinkIcd")
	Q ""
}

/// 导入项目数据
/// w ##class(web.DHCCKBGenDrugLinkIcd).SaveDrugLink()
ClassMethod SaveDrugLink(RowData, HospDesc) As %String
{
	n (RowData, HospDesc)
	
	s PatDiag=$p(RowData,"^",2)  
	s GenName=$p(RowData,"^",4)
	s Num1=$p(RowData,"^",6)
	s Num2=$p(RowData,"^",8)
	s Num3=$p(RowData,"^",10)
	s HospDesc=$p(^CT("HOSP",HospDesc),"^",2)
	s SaveStr=PatDiag_"^"_GenName_"^"_Num1_"^"_Num2_"^"_Num3
	
	s ^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",HospDesc,GenName,PatDiag)=SaveStr
}

/// 后台导入项目数据
/// w ##class(web.DHCCKBGenDrugLinkIcd).SaveDrugLinkAction("蚌埠一院")
ClassMethod SaveDrugLinkAction(HospDesc) As %String
{
	n (HospDesc)
	
	
	
	TSTART
	s count = 0
	s file=##class(%File).%New("D:\temp\蚌埠导入.csv")
	d file.Open("RS")
	d file.ReadLine() //读取一行
	s count=0
	while 'file.AtEnd
	{
		s line=file.Read()
		continue:line=""
		s PatDiag=$p(line,",",1) 
		s GenName=$p(line,",",2)
		s Num1=$p(line,",",3)
		s Num2=$p(line,",",4)
		s Num3=$p(line,",",5)
		s SaveStr=PatDiag_"^"_GenName_"^"_Num1_"^"_Num2_"^"_Num3
		continue:(GenName="")||(PatDiag="")||(Num1="")||(Num2="")||(Num3="")
		s ^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",HospDesc,GenName,PatDiag)=SaveStr
	   
		s count=count+1
		w "导入第"
		w count
		w "条数据,请稍后...",!	
	}  
	w "导入完成！"
	q ""
}

/// 获取公共科室Combobox
/// w ##class(web.DHCCKBGenDrugLinkIcd).GetComLoc("100^120")
ClassMethod GetComLoc(HospStr) As %String
{
	n (HospStr)
	
	q:HospStr="" ""
	s Len=$l(HospStr,"^")
	f m=1:1:Len  d
	.s $p(HospStr,"^",m)=$p(^CT("HOSP",$p(HospStr,"^",m)),"^",2)
	
	s count=0
	s Len=$l(HospStr,"^")
	f i=1:1:Len  d
	.s HospDesc=$p(HospStr,"^",i)
	.s GenName=""  f  s GenName = $o(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",HospDesc,GenName)) q:GenName=""  d
	..s LocDesc=$p(GenName,"@@",1)
	..s TmpLocArr(LocDesc,HospDesc)=+$g(TmpLocArr(LocDesc))+1
	w "["
	s Loc="" f  s Loc=$o(TmpLocArr(Loc)) q:Loc=""  d
	.s ComFlag=0
	.f index=1:1:Len  d
	..s Hosp=$p(HospStr,"^",index)
	..q:+$g(TmpLocArr(Loc,Hosp))=0
	..s ComFlag=ComFlag+1
	.i ComFlag=Len  d 
	..s count=count+1
	..i count=1  d
	...W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Loc_"^"_Loc)
	..e  d
	...w ","
	...w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Loc_"^"_Loc)
	w "]"
	k TmpLocArr
	q ""
}

/// shy
/// 导入知识库ICD通用名对应关系
/// w ##class(web.DHCCKBGenDrugLinkIcd).ImportICDLink("异丙托溴铵吸入溶液","急性支气管炎","儿科门诊","1^9^1^289^2","蚌埠一院")
ClassMethod ImportICDLink(Gen, Dia, Loc, LoginInfo, HospStr) As %String
{
	n (Gen, Dia, Loc, LoginInfo, HospStr)
	s InsertFlag=..IsDiaHave(Dia)
	s SQLCODE=0
	i InsertFlag="N"  d
	.&SQL(insert into CT_CKB_PDSS.CommonDiction values (:Dia,:Dia,"205985",""))
	.s InsertFlag=%ROWID
	q:SQLCODE'=0 "新增该诊断到其他类失败！"
	//字典数据准备
	s GenDic=##class(web.DHCCKBCommon).GetGeneralFromData()
	s Indication=##class(web.DHCCKBCommon).GetDrugIndicNew()
	
	//判断是否存在通用名适应症规则
	s GenID=""
	s DicID=""
	s Gen=$replace(Gen,"%","")
	f  s DicID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$UPPER^SSUTIL4(Gen),DicID)) q:DicID=""  d
	.s ParentDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicID)),4)
	.q:ParentDr'=GenDic  //通用名字典
	.s GenID=DicID   //获取通用名对应ID
	q:GenID="" "-2,未找到该通用名字典!"
	
	//判断是否该规则已经存在	
	s GenRule=##class(web.DHCCKBRuleIndexEdit).GetRuleByDic(GenID,Indication,"",LoginInfo).%ToJSON()  //查找适应症规则
	q:GenRule[Dia "-1"
	
	//新增判断关联ICD是否存在相同  shy 2022-10-17
	q:##class(web.DHCCKBGenDrugLinkIcd).HaveSameTag(GenID,Dia)=1
	
	ts
	s successInsert=-10
	//如果存在项目来源的规则 则直接插入一条疾病细信息（分支）
	i 1  d
	.s RDID=""
	.f  s RDID=$o(^CT.CKB.PDSS.RuleDicI("Dic",GenID,RDID)) q:(RDID="")  d
	..s Rule=$lg($g(^CT.CKB.PDSS.RuleDicD(RDID)),2)
	..q:+Rule=0
	..q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",Rule,"73"))   //适应症
	..s MsgTips="",ret=0
	..s RuleDataID=""	f  s RuleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",Rule,RuleDataID),-1)  q:(RuleDataID="")  d
	...s:$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="236641" MsgTips = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),8)  //知识来源 - 经验用药
	...s:(MsgTips="260133")&&($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="82") $list(^CT.CKB.PDSS.RuleDataD(RuleDataID),9)=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),9)_"、"_Dia //提示信息
	...s:MsgTips="260133" ret=1
	..q:ret=0
	..s Node=$o(^CT.CKB.PDSS.RuleNodeI("Parent",Rule,"if",0,""))
	..s:$lg($g(^CT.CKB.PDSS.RuleNodeD(Node)),3)="and" $list(^CT.CKB.PDSS.RuleNodeD(Node),3)="or"
	..&SQL(INSERT INTO CT_CKB_PDSS.RuleData VALUES ("26983","6","variable","Equals",:InsertFlag,NULL,'Constant',NULL,NULL,:Rule,:Node,NULL))
	..s:SQLCODE=0 successInsert=1
	..s Message=""
	..s:SQLCODE=0 Message=%ROWID
	..;save CKB.PDSS.RuleLog (规则主表日志)
	..;s Log=##class(web.DHCCKBRuleLog).SaveLog(Rule,$p(LoginInfo,"^",1),LoginInfo,HospStr,Message)
	..;s:Log<0 successInsert=-10
	..s ret = ##class(web.DHCCKBWriteLog).InsertAuthLog("DHC_CKBRuleData", Message, "indication", $p(LoginInfo,"^",1), +$h , $p($h,",",1), "", "", "")
	..s:ret'=0 successInsert=-10
	
	//如果不存在则插入通用名适应症规则
	i successInsert'=1 d
	.s baseObj={}
	.s ruleObj={}		//规则
	.s outPutObj={}		//输出
	.s labGenObj={}
	.s emRuleObj={}
	.s tymParId = ##class(web.DHCCKBCommon).GetGeneralFromData()
	.s disease = Dia
	.s tymc = Gen
	./*组织规则信息*/
	.d ruleObj.%Set("IcdCompare",disease)
	.d ruleObj.%Set("linkSym","")
	.d ruleObj.%Set("linkPeople","")
	.d ruleObj.%Set("linkAge","")
	.d ruleObj.%Set("linkSex","")
	.d ruleObj.%Set("linkLabItm","")
	.d ruleObj.%Set("linkLabValue","")
	.d ruleObj.%Set("linkWeight","")
	.d ruleObj.%Set("linkDose","")
	.d ruleObj.%Set("linkDrugDose","")
	./*组织输出信息*/
	.s outMsg = "本品用于"_disease
	.d outPutObj.%Set("linkErrMsg",outMsg)
	.d outPutObj.%Set("OutMsgTips","Y")
	.;d outPutObj.%Set("msgSource","项目经验汇总") 弃用,改为知识来源-经验用药
	.d outPutObj.%Set("knowledgeSource","经验用药")   //经验用药
	./*组织药品信息*/
	.s generId = ##class(web.DHCCKBCommon).GetDicIdByDesc(tymc,tymParId)
	.Q:generId=0
	.;s proexistFlag = ##class(web.DHCCKBRuleImport).IsProjectUse(generId)
	.;Q:proexistFlag'=1
	.;s existFlag = ##class(web.DHCCKBRuleImport).IsExistRule(generId,disease)
	.;Q:existFlag=1
	.s labelId = 73
	.d labGenObj.%Set("generID",generId)
	.d labGenObj.%Set("labelID",labelId)
	.d emRuleObj.%Set("empRuletip","TipsAtOnceProp")
	.s jsonstr = ##class(web.DHCCKBRuleImport).ImportNew(baseObj,ruleObj,outPutObj,1,0,1,labGenObj,"",LoginInfo,emRuleObj)
	.s:jsonstr["success" successInsert=0
	.s rule=$replace($p(jsonstr,"rule",2),""":""","")
	.s rule=$replace(rule,"""}","")
	.;s ^shy("test",7)=rule_"%%"_jsonstr
	.s:rule'="" ret = ##class(web.DHCCKBWriteLog).InsertAuthLog("DHC_CKBRule", rule, "indication", $p(LoginInfo,"^",1), +$h , $p($h,",",1), "", "", "")
	tc:successInsert=0||successInsert=1
	tro:(successInsert'=0)&&(successInsert'=1)
	q successInsert
}

/// 判断ICD字典是否存在该诊断；如果不存在新增
/// w ##class(web.DHCCKBGenDrugLinkIcd).IsDiaHave("焦虑状态")
ClassMethod IsDiaHave(Dia) As %String
{
	n (Dia)
	s h = 0
	q:Dia="" "N"
	s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.CommonDictionD(dicID))   q:dicID=""||h>0  d
	.q:$d(^CT.CKB.PDSS.CommonDictionI("Parref",dicID))   //最后一级
	.q:$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)=115
	.q:$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)=116
	.s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s:(Dia=dicDesc)||(Dia=dicCode) h = dicID 
	q:h=0 "N"	
    q:h>0 h
}

/// 批量导入ICD诊断通用名规则
/// 入参：医院ID (防止医院名称写错改用ID)
/// w ##class(web.DHCCKBGenDrugLinkIcd).InsertListData("114")
ClassMethod InsertListData(HospDesc) As %String
{
	
	n (HospDesc)
	
	k ^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd")
	k ^TmpDiaCountArr("web.DHCCKBGenDrugLinkIcd")
	k ^TMPLinkICDArr("web.DHCCKBGenDrugLinkIcd")
	k ^TmpGenHosp("web.DHCCKBGenDrugLinkIcd")
	k ^TmpDiaHosp("web.DHCCKBGenDrugLinkIcd")
	
	
	q:HospDesc="" ""
	s Len=$l(HospDesc,"^")
	f m=1:1:Len  d
	.s $p(HospDesc,"^",m)=$p(^CT("HOSP",$p(HospDesc,"^",m)),"^",2)
	s index=0
	s Len=$l(HospDesc,"^")
	f i=1:1:Len  d
	.s Hosp=$p(HospDesc,"^",i)
	.s GenName=""  f  s GenName=$o(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName))  q:GenName=""  d
	..s PatDiag="" f  s PatDiag=$o(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName,PatDiag))  q:PatDiag=""  d
	...s GenName=$p(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName,PatDiag),"^",2)
	...s DiaName=$p(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName,PatDiag),"^",1)
	...s GenDiaNum=$p(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName,PatDiag),"^",3)
	...s GenDiaAllNum=$p(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName,PatDiag),"^",4)
	...s GenAllNum=$p(^TMP("web.DHCCKBGenDrugLinkIcd","DrugLinkIcd",Hosp,GenName,PatDiag),"^",5)
	...s ^TmpGenHosp("web.DHCCKBGenDrugLinkIcd",GenName,Hosp)=GenAllNum
	...s ^TmpGenHosp("web.DHCCKBGenDrugLinkIcd",GenName,DiaName,Hosp)=GenDiaNum
	...s ^TmpDiaHosp("web.DHCCKBGenDrugLinkIcd",GenName,Hosp)=GenDiaAllNum
	
	//融合多个医院数据
	//通用名
	f p=1:1:Len  d
	.s Hosp=$p(HospDesc,"^",p)
	.s GenName="" f  s GenName=$o(^TmpGenHosp("web.DHCCKBGenDrugLinkIcd",GenName)) q:GenName=""  d
	..s ^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenName)=+$g(^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenName))+$g(^TmpGenHosp("web.DHCCKBGenDrugLinkIcd",GenName,Hosp)) 
	//通用名+诊断
	f p=1:1:Len  d
	.s Hosp=$p(HospDesc,"^",p)
	.s GenName="" f  s GenName=$o(^TmpGenHosp("web.DHCCKBGenDrugLinkIcd",GenName)) q:GenName=""  d
	..s DiaName="" f  s DiaName=$o(^TmpGenHosp("web.DHCCKBGenDrugLinkIcd",GenName,DiaName)) q:DiaName=""  d
	...q:HospDesc[DiaName
	...s ^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenName,DiaName)=+$g(^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenName,DiaName))+(+$g(^TmpGenHosp("web.DHCCKBGenDrugLinkIcd",GenName,DiaName,Hosp)))
	//通用名下所有诊断
	f p=1:1:Len  d
	.s Hosp=$p(HospDesc,"^",p)
	.s GenName="" f  s GenName=$o(^TmpDiaHosp("web.DHCCKBGenDrugLinkIcd",GenName)) q:GenName=""  d
	..s ^TmpDiaCountArr("web.DHCCKBGenDrugLinkIcd",GenName)=+$g(^TmpDiaCountArr("web.DHCCKBGenDrugLinkIcd",GenName))+$g(^TmpDiaHosp("web.DHCCKBGenDrugLinkIcd",GenName,Hosp)) 
	
	s GenNameStr=""
	f  s GenNameStr=$o(^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr))  q:GenNameStr=""  d  
	.s PatDiagStr="" f  s PatDiagStr=$o(^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr,PatDiagStr)) q:PatDiagStr=""  d
	..q:HospDesc[PatDiagStr  //过滤医院节点
	..s index=index+1
	..s Lv=0,Lv2=0
	..s:^TmpDiaCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr)'=0 Lv=$e((^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr,PatDiagStr)/^TmpDiaCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr)),0,5)*100_"%"
	..s:^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr)'=0 Lv2=$e((^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr,PatDiagStr)/^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr)),0,5)*100_"%"
	..s:$e(Lv,1)="." Lv="0"_Lv
	..s:$e(Lv2,1)="." Lv2="0"_Lv2
	..s OrderFlag=^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr,PatDiagStr)*10000+index
	..s ^TMPLinkICDArr("web.DHCCKBGenDrugLinkIcd",OrderFlag)=$p(GenNameStr,"@@",1)_"^"_$p(GenNameStr,"@@",2)_"^"_PatDiagStr_"^"_^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd",GenNameStr,PatDiagStr)_"^"_Lv_"^"_Lv2

	
	s ListTitle="Loc^Gen^Dia^DiaGen^Lv^Lv2"

	s index="",count=0,ret=0
	TS
	F  s index=$o(^TMPLinkICDArr("web.DHCCKBGenDrugLinkIcd",index),-1) Q:(index="")  D
	.s ListData=$g(^TMPLinkICDArr("web.DHCCKBGenDrugLinkIcd",index))
	.s LocOut=$p(ListData,"^",1)
	.s GenOut=$p(ListData,"^",2)
	.s DiaOut=$p(ListData,"^",3)
	.s Num1=$p(ListData,"^",4)
	.s Num2=$p(ListData,"^",5)
	.s Num3=$p(ListData,"^",6)
	.
	.;q:((GenOut'="替莫唑胺胶囊")&&(DiaOut'="神经胶质瘤"))   //测试
	.//通用名+当前诊断出现的次数≥60次，通用名+当前诊断出现的次数/该通用名下所有诊断出现的次数≥10%，通用名+当前诊断出现的次数/该通用名下所有处方数≥35%
	.q:(Num1<60)||(+Num2<10)||(+Num3<35)
	.s ret=##class(web.DHCCKBGenDrugLinkIcd).ImportICDLink(GenOut,DiaOut,LocOut,"1^9^1^289^2",HospDesc)
	.w GenOut_"^"_DiaOut_"^"_LocOut_"^"_ret,!
	.s ^TMPSHYINFO("web.DHCCKBGenDrugLinkIcd",GenOut_"^"_DiaOut)=GenOut_"^"_DiaOut_"^"_LocOut_"^"_ret
	
	k ^TmpGenCountArr("web.DHCCKBGenDrugLinkIcd")
	k ^TmpDiaCountArr("web.DHCCKBGenDrugLinkIcd")
	k ^TMPLinkICDArr("web.DHCCKBGenDrugLinkIcd")
	k ^TmpGenHosp("web.DHCCKBGenDrugLinkIcd")
	k ^TmpDiaHosp("web.DHCCKBGenDrugLinkIcd")
	
	
	;TRO:(ret'=0)&&(ret'=1)&&(ret'="-1")
	;q:(ret'=0)&&(ret'=1)&&(ret'="-1") ret
	TC
	Q 0
}

/// 判断导入诊断与规则现有诊断和现有诊断对应的ICD诊断是否有重复
/// 入参：GenID\Dia
/// 0：没有   1：有
/// w ##class(web.DHCCKBGenDrugLinkIcd).HaveSameTag(GenID,Dia)
ClassMethod HaveSameTag(GenID, Dia) As %String
{
	n (GenID,Dia)
	s res=0
	s DrugIng=##class(web.DHCCKBCommon).GetDrugIndicNew()   //适应症
    s RDID=""
	f  s RDID=$o(^CT.CKB.PDSS.RuleDicI("Dic",GenID,RDID)) q:(RDID="")||(res=1)  d
	.s Rule=$lg($g(^CT.CKB.PDSS.RuleDicD(RDID)),2)
	.q:+Rule=0
	.q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",Rule,DrugIng))   //适应症
	.//遍历该规则下的所有西医疾病
	.s RuleDataID=""	f  s RuleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",Rule,RuleDataID),-1)  q:(RuleDataID="")||(res=1)  d
	..q:($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)'="6")   //值判断西医疾病,不判断新插入的ICD
	..
	..s RuleDia=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),8)  //获取规则维护的西医疾病或者插入的ICD诊断
	..s queryHisCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(RuleDia)),2) 
	..s queryHisDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(RuleDia)),3)
	..s:queryHisDesc=Dia res=1
	..q:res=1
	..s ccRowID="" f  s ccRowID = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(queryHisCode),ccRowID)) q:(ccRowID="")||(res=1)  d
	...s listData =$g(^CKB.PDSS.ComContrastD(ccRowID))	
	...s libCode = $lg(listData,2)
	...s libDesc = $lg(listData,3) //知识库描述
	...s:libDesc=Dia res=1
	...q:res=1
	
	q res
}

}
