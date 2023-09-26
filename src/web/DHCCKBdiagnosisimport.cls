Import sqluser

Class web.DHCCKBdiagnosisimport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	临时存储导入数据
/// Creator:		Shy
/// CreateDate:		2021-11-22
/// Input:			pid,数据,类型
/// return:			
/// other:			
/// w ##class(web.DHCCKBdiagnosisimport).TmpImportData(20,"")
ClassMethod TmpImportData(pid, mListData, type)
{

	n (pid,mListData,type)
	
	i $CLASSNAME(mListData)="%CSP.CharacterStream" d
	.d ..InsTmpGlobalStream(pid, mListData,type)
	e  d
	.d ..InsTmpGlobalString(pid, mListData,type)
	q 0
}

/// Descript: 临时存储数据[流]
/// W ##Class(web.DHCCKBComImport).InsTmpGlobalStream("1","")
ClassMethod InsTmpGlobalStream(pid As %String, mListData, type) As %String
{
	n (pid, mListData,type)

	s spac="[next]"
	s rowspac="[row]"
	k TmpGlobal	
	
	d mListData.Rewind()
	while (mListData.AtEnd = 0) { 
		s IOStrLen=5000			
		s listData=mListData.Read(.IOStrLen)
		s connetData=$g(TmpGlobal(1))_""_listData
		i connetData[rowspac  d
		.f i=1:1:$L(connetData,rowspac) d
	    ..s mData=$p(connetData,rowspac,i)
	    ..i mData[$c(2) d	   
	    ...s row=$I(^TMPImport("Num",pid))	
	   	...s ^TMP("DHCCKB","web.DHCCKBdiagnosisimport","TmpImportData",pid,type,row)=$p(mData,$c(2))
	   	...k TmpGlobal(1)
		..e  d
		...s TmpGlobal(1)=mData
		e  d
		.s TmpGlobal(1)=$g(TmpGlobal(1))_""_connetData			
	}
	
	if $g(TmpGlobal(1))["#" d
	.s row=$I(^TMPImport("Num",pid))
	.s ^TMP("DHCCKB","web.DHCCKBdiagnosisimport","TmpImportData",pid,type,row)=$p($g(TmpGlobal(1)),"#")
	
	k TmpGlobal
	q ""
}

/// Descript: 临时存储数据[字符串]
/// W ##Class(web.DHCCKBRuleImport).InsTmpGlobal("1","")
ClassMethod InsTmpGlobalString(pid As %String, mListData, type) As %String
{
	n (pid, mListData,type)
	
	s spac="[next]"
	s rowspac="[row]"
	F i=1:1:$L(mListData,rowspac) D
	.s listData=$p(mListData,rowspac,i)
	.//s row=$p(listData,spac,1)+1	// 序号
	.s row=$I(^TMPImport("Num",pid))
	.s listData=$tr(listData,$c(2),"")
	.s ^TMP("DHCCKB","web.DHCCKBdiagnosisimport","TmpImportData",pid,type,row)=listData
	.
	Q ""
}

/// Description:	ICD诊断(西医疾病)目录导入失败的信息列表
/// Creator:		Shy
/// CreateDate:		2021-11-17
/// Input:			代码^描述
/// return:			ICD诊断信息串
/// other:			
/// w ##class(web.DHCCKBdiagnosisimport).QueryDiagList("20","1","1^drugcat")
ClassMethod QueryDiagList(rows As %String = 20, page As %String = 1, params As %String) As %String
{
		
	n (rows,page,params)	

	s end = page*rows
	s start=(page-1)*rows+1
	s pid=$p(params,"^",1)
	s type=$p(params,"^",2)
	   // ^TMP("DHCCKB","web.DHCCKBdiagnosisimport","ExportDataErrMsg",pid,type,row)
	q:'$d(^TMP("DHCCKB","web.DHCCKBdiagnosisimport","ExportDataErrMsg",pid)) ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) // 输出json结尾符
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()	// 输出json前缀串
	
	s count=0
	s title="num^firstCode^firstName^secondCode^secondName^thirdCode^thirdName^fourthCode^fourthName^fifthCode^fifthName"
	s title=title_"^diagCode^diagDesc^classify"
	set index=""	
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBdiagnosisimport","ExportDataErrMsg",pid,type,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBdiagnosisimport","ExportDataErrMsg",pid,type,index))
	.q:listData=""
	.s listObj=##class(web.DHCCKBdiagnosisimport).StrToObj(listData,type)
	.s tmpData=listObj.%Get("seqNo")_"^"_listObj.%Get("firstCode")_"^"_listObj.%Get("firstName")_"^"_listObj.%Get("secondCode")_"^"_listObj.%Get("secondName")
	.s tmpData=tmpData_"^"_listObj.%Get("thirdCode")_"^"_listObj.%Get("thirdName")_"^"_listObj.%Get("fourthCode")_"^"_listObj.%Get("fourthName")
	.s tmpData=tmpData_"^"_listObj.%Get("fifthCode")_"^"_listObj.%Get("fifthName")_"^"_listObj.%Get("diagCode")_"^"_listObj.%Get("diagDesc")_"^"_listObj.%Get("classify")
	.s count = count+1
	.q:(count<start)||(count>end)
	.I count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,tmpData,"^")
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,tmpData,"^")	
	
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) //输出json结尾符
	
	q ""
}

/// Description:	存储导入数据
/// Creator:		Shy
/// CreateDate:		2021-11-22
/// Input:			pid,数据,类型
/// return:			
/// other:			
/// w ##class(web.DHCCKBdiagnosisimport).SaveImprot("diagnosis","11874^9^1^289^2","222.132.155.206")
ClassMethod SaveImprot(type, LoginInfo = "", ClientIPAdd = "")
{
	n (type,LoginInfo,ClientIPAdd)
	s LgUserID=$p($g(LoginInfo),"^",1)
	s LgHospID=$p($g(LoginInfo),"^",5)
	s pid=1			// 进程号

	set $ZT="ERROR" // 设置一个异常
	s total=0,successNum=0,errNum=0 // 计数器 总数,成功,失败
	s msg=""		// 提示信息
	
	k ^TMP("DHCCKB","web.DHCCKBdiagnosisimport","ExportDataErrMsg",type)

	s row="" 
	f  s row=$o(^TMP("DHCCKB","web.DHCCKBdiagnosisimport","TmpImportData",pid,type,row))  q:row=""  d	
	.s total=total+1
	.s rowData=$g(^TMP("DHCCKB","web.DHCCKBdiagnosisimport","TmpImportData",pid,type,row))
	.s rowObj=..StrToObj(rowData,type)	
	.b ;err2
	.q:rowObj.%Size()=0		// 空对象
	.s err=1
	.s num=rowObj.%Get("num")	// 行号
	.b ;err3
	.TS
	.s linkCatID=0
	.d SaveDiagCat
	.i err=0 d SetTroInfo
	.q:err=0
	.
	.i err>0 do
	..s successNum=successNum+1
	..TCOMMIT
	.else  d SetTroInfo
	

	s outObj={}
	i (successNum'=0) 	d
	.d outObj.%Set("code","success").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","")
	e  d
	.d outObj.%Set("code","err").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg",$case(msg,"":"系统错误,代码:"_$ZE,:msg))
	
	d ..killTmpGlobal(pid)
	
	q outObj.%ToJSON()
	
	
SaveDiagCat		
	//判断当前分类是否为最后一级分类
	s lastFlag=1  //1:最后一级分类    0：非最后一级分类
	//整合表格数据
	s firstCode=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("firstCode"))
	s firstDesc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("firstName"))
	s secondCode=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("secondCode"))
	s secondDesc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("secondName"))
	s ThirdCode=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("thirdCode"))
	s ThirdDesc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("thirdName"))
	s fourthCode=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fourthCode"))
	s fourthDesc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fourthName"))
	s fifthCode=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("diagCode"))
	s fifthDesc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("diagDesc"))
	
	// 一级分类
	if (firstDesc'=""){
	s lastFlag=1
	s:((secondDesc'="")||(ThirdDesc'="")||(fourthDesc'="")||(fifthDesc'="")) lastFlag=0
	s firstID=##class(web.DHCCKBdiagnosisimport).SaveDiagCat(firstCode,firstDesc,"0",pid,lastFlag)
	s:+firstID'=0 linkCatID=firstID
	}
	// 二级分类
	if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("secondName"))'=""){
		s lastFlag=1
		s:((ThirdDesc'="")||(fourthDesc'="")||(fifthDesc'="")) lastFlag=0
		s secondID=##class(web.DHCCKBdiagnosisimport).SaveDiagCat(secondCode,secondDesc,linkCatID,pid,lastFlag)
		s:+secondID'=0 linkCatID=secondID	
		}	
		// 三级分类		
		if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("thirdName"))'=""){
		s lastFlag=1	
		s:((fourthDesc'="")||(fifthDesc'="")) lastFlag=0
			s thirdID=##class(web.DHCCKBdiagnosisimport).SaveDiagCat(ThirdCode,ThirdDesc,linkCatID,pid,lastFlag)		
			s:+thirdID'=0 linkCatID=thirdID	
			}
			s ^shy("111")=linkCatID_"$$$"
			// 四级分类
			if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("fourthName"))'=""){
				s lastFlag=1
				s:((fifthDesc'="")) lastFlag=0
				s ^shy("222")=$lb(fourthCode,fourthDesc,linkCatID,pid,lastFlag)
				s fourthID=##class(web.DHCCKBdiagnosisimport).SaveDiagCat(fourthCode,fourthDesc,linkCatID,pid,lastFlag)
				s:+fourthID'=0 linkCatID=fourthID	
				}
			
				// 诊断代码描述				
				if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("diagDesc"))'=""){
					s ^shy("333")=$lb(fifthCode,fifthDesc,linkCatID,pid,"1")
					s fifthID=##class(web.DHCCKBdiagnosisimport).SaveDiagCat(fifthCode,fifthDesc,linkCatID,pid,"1")
					s:+fifthID'=0 linkCatID=fifthID	
					}
				// 诊断分类保存			
				//if (##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("classify"))'=""){
				//	s classify=##class(web.DHCCKBCommonUtil).ReplaceWordStr(rowObj.%Get("classify"))
				//	s classifyID=##class(web.DHCCKBdiagnosisimport).SaveDiagClassify(classify,linkCatID,pid,LoginInfo,ClientIPAdd)
				//	i +classifyID=0 s err=0,msg="诊断分类保存失败"
				//	q:+classifyID=0
				///	s linkCatID=classifyID
				//}	
				
	i +linkCatID=0  s err=0,msg="分类不能为空" 
	q:+linkCatID=0 ""
	
	quit
	
	
SetTroInfo
	tro
	s errNum=errNum+1
	s ^TMP("DHCCKB","web.DHCCKBdiagnosisimport","ExportDataErrMsg",pid,type,row)=rowData_"[next]"_"errMsg"_$c(1)_msg	// 记录提交失败信息
	Quit


ERROR
	set errorMsg=$ZE                  //$ZE 获取错误信息
	tro                      //有异常，则回滚事务(Golbal才可以回滚,普通变量不能回滚)
	s ^TMP("DHCCKB","web.DHCCKBdiagnosisimport","ExportDataErrMsg",pid,type,row)=rowData	// 记录提交失败信息
	s outObj={}
	d outObj.%Set("code","err").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","系统错误,代码"_errorMsg)
	d ..killTmpGlobal(pid)
	
	Quit outObj.%ToJSON()             //返回错误信息
}

/// 特定格式的字符串转换为对象 		//	通用名$c(1)阿莫西林 [next] 剂型2$c(1) 片剂	
/// w ##class(web.DHCCKBComImport).StrToObj("编码1"_$c(1)_"11111[next]药品商品名1"_$c(1)_"阿莫西林").%ToJSON()
ClassMethod StrToObj(mData, type = "") As %String
{
	n (mData,type)
	
	s spec="[next]"
	s del=$c(1)
	s len=$length(mData,spec)
	s dataObj={}

	f i=1:1:len	d
	.s tmpData=$p(mData,spec,i)
	.s key=$p(tmpData,del,1)
	.i type="diagnosis" d
	..s key=..SetCatKey(key)
	.e  d
	..s key=..SetCommonKey(key)
	.
	.s value=$p(tmpData,del,2)
	.d dataObj.%Set(key,value)
	
	q dataObj
}

/// 生成整行对象的key
/// w ##class(web.DHCCKBComImport).SetRowKey(20,"")
ClassMethod SetCatKey(key) As %String
{
	n (key)

	s keyObj={}
	
	d keyObj.%Set("序号","seqNo").%Set("一级编码","firstCode").%Set("一级名称","firstName").%Set("一级别名","firstKey") //second third fourth fifth
	d keyObj.%Set("二级编码","secondCode").%Set("二级名称","secondName").%Set("二级别名","secondKey")
	d keyObj.%Set("三级编码","thirdCode").%Set("三级名称","thirdName").%Set("三级别名","thirdKey")
	d keyObj.%Set("四级编码","fourthCode").%Set("四级名称","fourthName").%Set("四级别名","fourthKey")
	d keyObj.%Set("诊断代码","diagCode").%Set("诊断描述","diagDesc").%Set("来源","classify")
	q keyObj.%Get(key)
}

/// 生成整行对象的key
/// w ##class(web.DHCCKBdiagnosisimport).SetRowKey(20,"")
ClassMethod SetCommonKey(key) As %String
{
	n (key)

	s keyObj={}
	
	d keyObj.%Set("num","num").%Set("代码","itmCode").%Set("描述","itmDesc").%Set("父级节点","parent")	
	q keyObj.%Get(key)
}

ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	
    k ^TMP("DHCCKB","web.DHCCKBdiagnosisimport","TmpImportData",pid)
}

/// Description:	保存分类
/// Creator:		Shy
/// CreateDate:		2021-11-22
/// Input:			代码,描述,所属字典表id，新代码，新描述
/// return:			成功id，失败代码<0
/// other:			w ##class(web.DHCCKBdiagnosisimport).SaveDiagCat("L08.900x021", "软组织感染", 229904,"","","")
ClassMethod SaveDiagCatOLD(code, desc, linkCatID, pid, lastFlag = "")
{
	n (code, desc, linkCatID, pid, lastFlag)
	s Thisid=0
	s:code="" code=desc
	s queryExtID=..QueryCodeDesc(code,desc)  //查询东华总院下疾病字典数据是否存在
	b ;s1
	i queryExtID="N"  d	
	.s:('$d(^CKB.PDSS.ExtDictionI("SearchCode",code))&&('$d(^CKB.PDSS.ExtDictionI("SearchDesc",desc)))) lastFlag=0
	.i lastFlag=1 d
	..q:linkCatID=229875    //其他类最后一级单独判断 不导入
	..//代码或描述重复将匹配条目放到同一层级
	..//代码
	..s extID=""   //	^CKB.PDSS.ExtDictionI("Code",{ED_Hospital},{ED_Code},{ED_RowID})
    ..f  s extID=$o(^CKB.PDSS.ExtDictionI("SearchCode",code,extID))  q:extID=""  d
 	...s extData = $g(^CKB.PDSS.ExtDictionD(extID))
 	...q:$lg(extData,4)'="DiseaseData"
	...s obj=##class(CKB.PDSS.ExtDiction).%OpenId(extID)
	...s obj.EDHospital=""
	...s:extID=linkCatID linkCatID=0     //判断id跟parrefDr相同情况  shy 2022-03-17
	...i linkCatID'="0"  d
	....s obj.EDParrefDr=linkCatID
	...e  d
	....s obj.EDParrefDr= $o(^CKB.PDSS.ExtDictionI("CodeDesc","DiseaseData","疾病字典",""))    //一级数据放置在疾病字典下
	...s sc=obj.%Save()
	...s Thisid = obj.%Id()
	...d obj.%Close()
	..
	..//   描述
	..s extID=""   
    ..f  s extID=$o(^CKB.PDSS.ExtDictionI("SearchDesc",desc,extID))  q:extID=""  d
	...q:$lg(^CKB.PDSS.ExtDictionD(extID),4)'="DiseaseData"
	...s obj=##class(CKB.PDSS.ExtDiction).%OpenId(extID)
	...s obj.EDHospital=""
	...s:extID=linkCatID linkCatID=0  //判断id跟parrefDr相同情况  shy 2022-03-17
	...i linkCatID'="0"  d
	....s obj.EDParrefDr=linkCatID
	...e  d
	....s obj.EDParrefDr= $o(^CKB.PDSS.ExtDictionI("CodeDesc","DiseaseData","疾病字典",""))    //一级数据放置在疾病字典下
	...s sc=obj.%Save()
	...s Thisid = obj.%Id()
	...d obj.%Close()
	.e  d
	..//存外部代码    - 添加
	..s obj=##class(CKB.PDSS.ExtDiction).%New()
	..s obj.EDCode=code
	..s obj.EDDesc=desc
	..s obj.EDType="DiseaseData"       //添加药品数据存入CKB_PDSS.ExtDiction表中数据类型
	..s obj.EDHospital=""
	..i linkCatID'="0"  d
	...s obj.EDParrefDr=linkCatID
	..e  d
	...s obj.EDParrefDr= $o(^CKB.PDSS.ExtDictionI("CodeDesc","DiseaseData","疾病字典",""))    //一级数据放置在疾病字典下
	..b ;s111
	..s sc=obj.%Save()
	..s Thisid = obj.%Id()
	..b ;s112
	..d obj.%Close()
	e  d
	.b ;s12
	.s obj=##class(CKB.PDSS.ExtDiction).%OpenId(queryExtID)
	.s obj.EDHospital=""
	.s:queryExtID=linkCatID linkCatID=0    //判断id跟parrefDr相同情况  shy 2022-03-17
	.i linkCatID'="0"  d
	..s obj.EDParrefDr=linkCatID
	.e  d
	..s obj.EDParrefDr= $o(^CKB.PDSS.ExtDictionI("CodeDesc","DiseaseData","疾病字典",""))    //一级数据放置在疾病字典下
	.s sc=obj.%Save()
	.s Thisid = obj.%Id()
	.b ;err
	.d obj.%Close()
	//两个问题：
	//1、一级代码导入  指向是不是不应该为空
	//代码或描述重复的：将知识库条目放到与匹配上的模板中的条目相同层级的位置，保留其当前与西医疾病的对照关系
    //代码及描述均不重复：存在与西医疾病对照关系的知识库条目保留，并自动归入其他类，与疾病无对照关系的直接删除。
    //2、其他类
    //3、与疾病无对照关系的直接删除。
    b ;s2
	q Thisid
}

/// Description:	检测外部代码表中是否存在数据（导入用）
/// Creator:		Sunhuiyong 
/// CreateDate:		2021-11-22	
/// Input:			Code Desc
/// return:			
/// other:			w ##class(web.DHCCKBdiagnosisimport).QueryCodeDesc("M80020/3","小细胞型恶性肿瘤")
ClassMethod QueryCodeDesc(Code As %String = "", Desc = "") As %String
{
	n (Code,Desc)  
	s Ret="N"
    s ExtID = ""
    q:'$d(^CKB.PDSS.ExtDictionI("CodeDesc",Code,Desc)) "N"
    f  s ExtID = $o(^CKB.PDSS.ExtDictionI("CodeDesc",Code,Desc,ExtID)) q:ExtID=""  d
    .s ExtData = $g(^CKB.PDSS.ExtDictionD(ExtID))    
    .s Type= $lg(ExtData,4)
    .s Hosp= $lg(ExtData,5) 
    .q:+Hosp'=0
    .q:Type'="DiseaseData"
    .s Ret=ExtID
    
    q Ret
}

/// Description:	保存分类
/// Creator:		Shy
/// CreateDate:		2021-11-22
/// Input:			代码,描述,所属字典表id，新代码，新描述
/// return:			成功id，失败代码<0
/// other:			w ##class(web.DHCCKBdiagnosisimport).SaveDiagCat("AZA01AA", "辛温解表剂", 120998,"","", pid)
ClassMethod SaveDiagClassify(classify, linkCatID, pid, loginInfo = "", clientIPAdd = "")
{
	n (classify,linkCatID,pid,LoginInfo,ClientIPAdd)
	s ret=0
	s classifyDr=""     //国临版  医保版   病理诊断
	s ICDRes=##class(web.DHCCKBCommon).GetICDResData()
	s classifyDr=$o(^CKB.PDSS.ExtDictionI("CodeDesc",classify,classify,""))
	q:$d(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",linkCatID,ICDRes)) 1
	&SQL(Insert Into CKB_PDSS.DicExtLinkAttr(DLA_DicExt_Dr,DLA_AttrCode,DLA_Attr_Dr)
		values(:linkCatID,:ICDRes,:classifyDr))
	s:SQLCODE=0 ret=1
	
	q ret
}

/// Description:	导入完毕后调用-存在与西医疾病对照关系的知识库条目保留，并自动归入其他类，与疾病无对照关系的直接删除。
/// Creator:		Sunhuiyong 
/// CreateDate:		2021-11-24	
/// Input:			Code Desc
/// return:			
/// other:			w ##class(web.DHCCKBdiagnosisimport).DataAction()
ClassMethod DataAction() As %String
{
    //^CKB.PDSS.ExtDictionI("Code",{ED_Hospital},{ED_Code},{ED_RowID})
    
    s Code=""
    f  s Code=$o(^CKB.PDSS.ExtDictionI("Code",95,Code)) q:Code=""  d
    .s Id="" f  s Id=$o(^CKB.PDSS.ExtDictionI("Code",95,Code,Id)) q:Id=""  d
    ..//^CKB.PDSS.ComContrastI("HisCode",$$UPPER({CC_HisCode}),{CC_RowID})
    ..s extData = $g(^CKB.PDSS.ExtDictionD(Id)) 	
    ..s Desc=$lg(extData,3)
    ..q:"DiseaseData"'=$lg(extData,4)
    ..i $d(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(Code)))  d
    ...s ACTionFlag=0
    ...s CCId="" f  s CCId=$o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(Code),CCId)) q:(CCId="")||(ACTionFlag=1)  d
    ....s CCDesc=$lg(^CKB.PDSS.ComContrastD(CCId),5)
    ....s CCType=$lg(^CKB.PDSS.ComContrastD(CCId),6)
    ....i (CCDesc=Desc)&&(CCType="115")  d
    .....;s $lg(extData,5)="-2"   //其他类
    .....&SQL(UPDATE CKB_PDSS.ExtDiction SET ED_Hospital='-2' WHERE ED_RowID=:Id)
    .....s ACTionFlag=1
    ....e  d
    .....//将Hosp先置为-1
    .....;s $lg(extData,5)="-1"   //删除
    .....&SQL(UPDATE CKB_PDSS.ExtDiction SET ED_Hospital='-1' WHERE ED_RowID=:Id)
    ....s ACTionFlag=1
    ..e  d
    ...//将Hosp先置为-1
    ...;s $lg(extData,5)="-1"    //删除
    ...&SQL(UPDATE CKB_PDSS.ExtDiction SET ED_Hospital='-1' WHERE ED_RowID=:Id)
    b ;End
    q "Over!"
}

/// Description:	过滤删除重复代码表述的数据
/// Creator:		Sunhuiyong 
/// CreateDate:		2021-11-24	
/// Input:			Code Desc
/// return:			
/// other:			w ##class(web.DHCCKBdiagnosisimport).DataActionText()
ClassMethod DataActionText() As %String
{
    s ExtID=""
    f  s ExtID=$o(^CKB.PDSS.ExtDictionI("Type",$c(0),"DiseaseData",ExtID))  q:ExtID=""  d
    .s ExtData = $g(^CKB.PDSS.ExtDictionD(ExtID)) 
    .s Code= $lg(ExtData,2)
    .s Desc= $lg(ExtData,3)
    .q:'$d(^CKB.PDSS.ExtDictionI("CodeDesc",Code,Desc))
    .s Count=0
    .;q:Code'="L08.900x021"  
    .s ID=""
    .f  s ID = $o(^CKB.PDSS.ExtDictionI("CodeDesc",Code,Desc,ID)) q:ID=""  d
    ..s Count=Count+1
    ..q:Count=1
    ..&SQL(delete from CKB_PDSS.ExtDiction where ED_RowID=:ID)
    ..w ID_" // "

    q ""
}

/// Description:	保存分类
/// Creator:		Shy
/// CreateDate:		2021-11-22
/// Input:			代码,描述,所属字典表id，新代码，新描述
/// return:			成功id，失败代码<0
/// other:			w ##class(web.DHCCKBdiagnosisimport).SaveDiagCat("A41.3","流感嗜血杆菌性脓毒症","230977","1","1")
ClassMethod SaveDiagCat(code, desc, linkCatID, pid, lastFlag = "")
{
	n (code, desc, linkCatID, pid, lastFlag)
	s Thisid=0
	s:code="" code=desc
	s queryExtID=..QueryCodeDescNew(code,desc)  //查询东华总院下疾病字典数据是否存在
	b ;1
	i queryExtID="N"  d	    //^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP({CD_Code}),{CD_RowID})
	.s:('$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(code)))||('$d(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(desc))))) lastFlag=0
	.i lastFlag=1 d
	..q:linkCatID=205985    //其他类最后一级单独判断 不导入
	..//代码或描述重复将匹配条目放到同一层级
	..//代码
	..s extID="" 
    ..f  s extID=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(code),extID))  q:extID=""  d
	...;q:$lg(^CKB.PDSS.ExtDictionD(extID),4)'="DiseaseData"
	...s obj=##class(CT.CKB.PDSS.CommonDiction).%OpenId(extID)
	...;s obj.EDHospital=""
	...s:extID=linkCatID linkCatID=0     //判断id跟parrefDr相同情况  shy 2022-03-17
	...i linkCatID'="0"  d
	....d obj.CDParrefDrSetObjectId(linkCatID)
	...e  d
	....d obj.CDParrefDrSetObjectId(26938)    //一级数据放置在疾病字典下
	...s sc=obj.%Save()
	...s Thisid = obj.%Id()
	...d obj.%Close()
	..
	..//   描述
	..;s extID=""   
    ..;f  s extID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(desc),extID))  q:extID=""  d
	..;.;q:$lg(^CKB.PDSS.ExtDictionD(extID),4)'="DiseaseData"
	..;.s obj=##class(CT.CKB.PDSS.CommonDiction).%OpenId(extID)
	..;.;s obj.EDHospital=""
	..;.s:extID=linkCatID linkCatID=0  //判断id跟parrefDr相同情况  shy 2022-03-17
	..;.i linkCatID'="0"  d
	..;..d obj.CDParrefDrSetObjectId(linkCatID)
	..;.e  d
	..;..d obj.CDParrefDrSetObjectId(26938)    //一级数据放置在疾病字典下
	..;.s sc=obj.%Save()
	..;.s Thisid = obj.%Id()
	..;.d obj.%Close()
	.e  d
	..//存外部代码    - 添加
	..s obj=##class(CT.CKB.PDSS.CommonDiction).%New()
	..s desc=$replace(desc,"（","(")
	..s desc=$replace(desc,"）",")")
	..s obj.CDCode=code
	..s obj.CDDesc=desc
	..;s obj.EDType="DiseaseData"       //添加药品数据存入CKB_PDSS.ExtDiction表中数据类型
	..;s obj.EDHospital=""
	..i linkCatID'="0"  d
	...d obj.CDParrefDrSetObjectId(linkCatID)
	..e  d
	...d obj.CDParrefDrSetObjectId(26938)      //一级数据放置在疾病字典下
	..s sc=obj.%Save()
	..s Thisid = obj.%Id()
	..d obj.%Close()
	e  d
	.s obj=##class(CT.CKB.PDSS.CommonDiction).%OpenId(queryExtID)
	.;s obj.EDHospital=""
	.s:queryExtID=linkCatID linkCatID=0    //判断id跟parrefDr相同情况  shy 2022-03-17
	.i linkCatID'="0"  d
	..d obj.CDParrefDrSetObjectId(linkCatID)
	.e  d
	..d obj.CDParrefDrSetObjectId(26938)  //一级数据放置在疾病字典下
	.s sc=obj.%Save()
	.s Thisid = obj.%Id()
	.d obj.%Close()
	//两个问题：
	//1、一级代码导入  指向是不是不应该为空
	//代码或描述重复的：将知识库条目放到与匹配上的模板中的条目相同层级的位置，保留其当前与西医疾病的对照关系
    //代码及描述均不重复：存在与西医疾病对照关系的知识库条目保留，并自动归入其他类，与疾病无对照关系的直接删除。
    //2、其他类
    //3、与疾病无对照关系的直接删除。
	q Thisid
}

/// Description:	检测代码表中是否存在数据（导入用）
/// Creator:		Sunhuiyong 
/// CreateDate:		
/// Input:			Code Desc
/// return:			
/// other:			w ##class(web.DHCCKBdiagnosisimport).QueryCodeDescNew("T95.900","烧伤、腐蚀伤和冻伤后遗症")
ClassMethod QueryCodeDescNew(Code As %String = "", Desc = "") As %String
{
	n (Code,Desc)  
	s Ret="N"
	s Desc=$replace(Desc,"（","(")
	s Desc=$replace(Desc,"）",")")
	s Desc=$replace(Desc,"、","")
    s ExtID = ""
    q:'$d(^CT.CKB.PDSS.CommonDictionI("CodeDesc",$$ALPHAUP^SSUTIL4(Code),$$ALPHAUP^SSUTIL4(Desc))) "N"
    f  s ExtID = $o(^CT.CKB.PDSS.CommonDictionI("CodeDesc",$$ALPHAUP^SSUTIL4(Code),$$ALPHAUP^SSUTIL4(Desc),ExtID)) q:ExtID=""  d
    .s Ret=ExtID
    
    q Ret
}

/// Description:	清除代码表中其他类多保存的数据
/// Creator:		Sunhuiyong 
/// CreateDate:		
/// Input:			Code Desc
/// return:			
/// other:			w ##class(web.DHCCKBdiagnosisimport).ClearOtherDesc()
ClassMethod ClearOtherDesc() As %String
{
 
	//^CT.CKB.PDSS.CommonDictionI("Parref",{CD_Parref_Dr},{CD_RowID})
	s ID=""
	s count=0
	f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",205985,ID))  q:ID=""  d
	.s Ret=""
	.s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)
	.s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)
	.s ExtID=""
	.f  s ExtID = $o(^CT.CKB.PDSS.CommonDictionI("CodeDesc",$$ALPHAUP^SSUTIL4(code),$$ALPHAUP^SSUTIL4(desc),ExtID)) q:ExtID=""  d
    ..s:$lg($g(^CT.CKB.PDSS.CommonDictionD(ExtID)),4)'=205985 Ret=ExtID
    .q:Ret=""
    .&SQL(delete from CT_CKB_PDSS.CommonDiction where CD_RowID=:ID)
	.s count=count+1
	w count
	q ""
}

}
