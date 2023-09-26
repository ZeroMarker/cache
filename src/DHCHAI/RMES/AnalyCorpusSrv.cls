/// 名称: DHCHAI.RMES.AnalyCorpusSrv
/// 描述: 语义分析服务类（关键词筛查2.0）
/// 编写者：zhufei
/// 编写日期: 2019-08-20
Class DHCHAI.RMES.AnalyCorpusSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2019-08-20
/// Description:  病程语义分析（关键词筛查2.0）
/// Table：       DHCHAI.DP.EmrRecord
/// Input：       患者就诊号,记录索引码 EmrXCode
/// Return：      成功：return>0
/// w ##class(DHCHAI.RMES.AnalyCorpusSrv).EmrAnalysisByEpis("5493","2016-10-01","2016-10-12","","1")
ClassMethod EmrAnalysisByEpis(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aDocType As %String = "", aDesenFlag As %String = "0") As %String
{
	New (aEpisodeDr,aSttDate,aEndDate,aDocType,aDesenFlag)
	Set return=0,Count=0
	Quit:aEpisodeDr="" return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set:aSttDate["-" aSttDate=$zdh(aSttDate,3)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	
	Set xDocDate=$s(aSttDate'="":aSttDate-1,1:0)
	For {
		Set xDocDate=$o(^DHCHAI.DP.EmrRecordI("IndexEpisodeDrDocDate",EpisodeDr,xDocDate))
		Quit:xDocDate=""
		Quit:(aEndDate'="")&(xDocDate>aEndDate)
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.EmrRecordI("IndexEpisodeDrDocDate",EpisodeDr,xDocDate,xID))
			Quit:xID=""
			
			Set objRec=##class(DHCHAI.DP.EmrRecord).GetObjById(xID)
			Continue:'$Isobject(objRec)
			Continue:objRec.EmrIsActive'=1
			Continue:'$Isobject(objRec.EmrDocTypeDr)
			Set DocTypeCode=objRec.EmrDocTypeDr.BTCode
			Continue:(aDocType'="")&(aDocType'=DocTypeCode)
			Set SCode=objRec.EmrSCode
			Set DocTitle=objRec.EmrDocTitle
			Set DocHospital=SCode
			Set DocContent=objRec.EmrDocContent
			Set DocNumber=SCode_"||"_objRec.%Id()
			
			//保存关键词筛查结果
			Set flg=..SaveStructResult("INF-HAI",EpisodeDr,DocNumber,DocTitle,DocContent)  //返回最后主记录id
			Continue:(+flg)<1
			Set Count=Count+1
		}
	}
	Quit Count
}

/// Creator：     zhufei
/// CreatDate：   2019-08-20
/// Description:  检查结果语义分析（关键词筛查2.0）
/// Table：       DHCHAI.DP.RBReport
/// Input：       患者就诊号,记录索引码 EmrXCode
/// Return：      成功：return>0
/// w ##class(DHCHAI.RMES.AnalyCorpusSrv).RISAnalysisByEpis("4670","2017-08-01","2017-08-15","","1")
ClassMethod RISAnalysisByEpis(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aDocType As %String = "", aDesenFlag As %String = "0") As %String
{
	New (aEpisodeDr,aSttDate,aEndDate,aDocType,aDesenFlag)
	Set return=0,Count=0
	Quit:aEpisodeDr="" return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set:aSttDate["-" aSttDate=$zdh(aSttDate,3)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	
	Set xRepDate=$s(aSttDate'="":aSttDate-1,1:0)
	For {
		Set xRepDate=$o(^DHCHAI.DP.RBReportI("IndexEpisodeDrRepDate",EpisodeDr,xRepDate))
		Quit:xRepDate=""
		Quit:(aEndDate'="")&(xRepDate>aEndDate)
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.RBReportI("IndexEpisodeDrRepDate",EpisodeDr,xRepDate,xID))
			Quit:xID=""
			
			Set objRep=##class(DHCHAI.DP.RBReport).GetObjById(xID)
			Continue:'$Isobject(objRep)
			Set SCode=objRep.RBSCode
			Set ChkStatus=objRep.RBChkStatus
			Set IsActive=objRep.RBIsActive
			Continue:IsActive=0
			Set CheckItem=objRep.RBCheckItem
			Set ExamDesc=objRep.RBExamDesc
			Set ResultDesc=objRep.RBResultDesc
			Continue:(ExamDesc="")&&(ResultDesc="")
			Set DocTitle=CheckItem
			Set DocHospital=SCode
			Set DocContent=ExamDesc_ResultDesc
			Set DocNumber=SCode_"||"_objRep.%Id()
			
			//保存关键词筛查结果
			Set flg=..SaveStructResult("INF-RIS",EpisodeDr,DocNumber,DocTitle,DocContent)  //返回最后主记录id
			Continue:(+flg)<1
			Set Count=Count+1
		}
	}
	Quit Count
}

/// Creator：     zhufei
/// CreatDate：   2019-08-20
/// Description:  存储关键词筛查结果
/// Table：       DHCHAI.RME.DocMaster
/// Input：       原始文本
/// Return：      成功：返回主记录id，失败：返回<0的代码
/// w ##class(DHCHAI.RMES.AnalyCorpusSrv).SaveStructResult("INF-HAI",5493,"EMR01||1","测试","患者今日体温正常，一般情况好，右膝创面部分同前，痂皮已脱落，创面周围无明显渗出及红肿，余症状查体同前。赵宇教授、盛林主治医师查房：观察患者一般情况变化。遵嘱执行。")
ClassMethod SaveStructResult(aThemeCode As %String, aEpisodeDr As %String, aDocNumber As %String, aDocTitle As %String, aDocContent As %String) As %String
{
	New (aThemeCode,aEpisodeDr,aDocNumber,aDocTitle,aDocContent)
	Set return=0
	Quit:(aThemeCode="")||(aEpisodeDr="")||(aDocNumber="")||(aDocContent="") return
	
	Set objThemeType=##class(DHCHAI.RME.ThemeType).GetObjByCode(aThemeCode)
	Quit:'$IsObject(objThemeType) return
	Quit:'$IsObject(objThemeType.BTVersionDr) return
	Set VersionDr=objThemeType.BTVersionDr.%Id()
	
	Set DocSectionDr=""
	Set DocContent=aDocContent
	Set DocContent=##class(DHCHAI.Utils.CommonSrv).Replace(DocContent,$c(13,10),"|") //处理回车换行
	Set DocContent=$tr(DocContent,"。","|")
	Set DocContent=$tr(DocContent,"；","|")
	Set DocContent=$tr(DocContent,"？","|")
	Set DocContent=$tr(DocContent,"！","|")
	Set DocContent=$tr(DocContent,"，","|")
	Set DocContent=$tr(DocContent,"：","|")
	For indS=1:1:$l(DocContent,"|") {
		Set tSection=$p(DocContent,"|",indS)
		Continue:tSection=""
		Set tSection=##class(DHCHAI.Utils.CommonSrv).MoveSpaceKey(tSection)
		Continue:tSection=""
		
		Set tStructResult=..GetStructResult(tSection)
		Continue:tStructResult=""
		
		//存储语义分析结果
		If DocSectionDr="" {
			//唯一索引
			Set DocMasterDr=$o(^DHCHAI.RME.DocMasterI("IndexDocNumber",VersionDr," "_aDocNumber,0))
			
			//保存文档
			Set InputStr=""
			Set $p(InputStr,"^",1)=DocMasterDr
			Set $p(InputStr,"^",2)=aDocNumber
			Set $p(InputStr,"^",3)=aEpisodeDr
			Set $p(InputStr,"^",4)=$s($l(aDocContent)>1000:$e(aDocContent,1,1000),1:aDocContent)
			Set $p(InputStr,"^",5)=aDocTitle
			Set $p(InputStr,"^",6)=VersionDr
			Set $p(InputStr,"^",7)=""
			Set $p(InputStr,"^",8)="1"          //是否有效
			Set DocMasterDr=##class(DHCHAI.RME.DocMaster).Update(InputStr)
			Quit:(+DocMasterDr)<1
			Set return=DocMasterDr
			
			//清空原有文档段落
			Set flg=##class(DHCHAI.RME.DocMaster).ClearSection(DocMasterDr)
			
			//保存段落
			Set InputStr=""
			Set $p(InputStr,"^",1)=DocMasterDr
			Set $p(InputStr,"^",2)=""             //ChildSub
			Set $p(InputStr,"^",3)=""
			Set $p(InputStr,"^",4)=$s($l(aDocContent)>1000:$e(aDocContent,1,1000),1:aDocContent)
			Set $p(InputStr,"^",5)=1
			Set DocSectionDr=##class(DHCHAI.RME.DocSection).Update(InputStr)
			Quit:(+DocSectionDr)<1
		}
		
		//保存段落结果
		For indK=1:3:$ll(tStructResult) {
			Set OneWord=$listget(tStructResult,indK)       //归一词
			Continue:OneWord=""
			Set ParserWords=$lg(tStructResult,indK+1)      //同义词
			Set ResultType=$lg(tStructResult,indK+2)       //结果类型
			Set DRFormal=OneWord                           //上位词
			
			//结果类型(<HAI_RESULT(+)>表示阳性、<HAI_RESULT(-)>表示阴性、<HAI_RESULT(?)>表示疑似阳性)
			Set ResultTypeDr=""
			Set ResultCatDr=""
			Set objResultType=##class(DHCHAI.RME.ResultType).GetObjByCode(ResultType)
			If $IsObject(objResultType){
				Set ResultTypeDr=objResultType.%Id()
				If $IsObject(objResultType.BTCatDr){
					Set ResultCatDr=objResultType.BTCatDr.%Id()
				}
			} Else {
				Set ResultTypeStr="^"_ResultType_"^"_ResultType_"^"_""
				Set ResultTypeDr=##class(DHCHAI.RME.ResultType).Update(ResultTypeStr)
			}
			Continue:ResultTypeDr=""
			
			Set InputStr=""
			Set $p(InputStr,"^",1)=DocSectionDr   //ID
			Set $p(InputStr,"^",2)=""             //ChildSub
			Set $p(InputStr,"^",3)=ResultTypeDr   //结果类型
			Set $p(InputStr,"^",4)=OneWord        //归一词
			Set $p(InputStr,"^",5)=tSection       //段落/语句
			Set $p(InputStr,"^",6)=""             //属性
			Set $p(InputStr,"^",7)=""             //Offset
			Set $p(InputStr,"^",8)=ParserWords    //同义词词组
			Set $p(InputStr,"^",9)=DRFormal       //上位词
			Set DocResultDr=##class(DHCHAI.RME.DocResult).Update(InputStr)
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-08-08
/// Description:  通过关键词方式结构化病历
/// Table：       DHCHAI.DP.EmrRecord、DHCHAI.RME.ParserWords、DHCHAI.RME.OneWords
/// Input：       aSectionStr: 病历内容（段落）
/// Return：      $list
/// zw ##class(DHCHAI.RMES.AnalyCorpusSrv).GetStructResult("无腹主动脉肠系膜上动脉超声检查;腹主动脉多发斑块。")
/// zw ##class(DHCHAI.RMES.AnalyCorpusSrv).GetStructResult("窦性心律不齐待查")
/// zw ##class(DHCHAI.RMES.AnalyCorpusSrv).GetStructResult("不舒服,当天患者高烧")
ClassMethod GetStructResult(aSectionStr As %String) As %List
{
	New (aSectionStr)
	Set return=""
	Quit:(aSectionStr="") return
	
	Set $ZT="GetStructResultErr"
	
	//1 字符串根据语料库分词
	Set CorpusWordsList=..GetCorpusWords(aSectionStr)
	Quit:CorpusWordsList="" return
	//zw CorpusWordsList
	
	Set subCorpusWords=""
	Set subStart=$s($lg(CorpusWordsList,1)="|":3,1:1),subEnd=""
	For {
		Quit:subStart>$listlength(CorpusWordsList)
		Set subEnd=$listfind(CorpusWordsList,"|",subStart)
		If subEnd<1 {
			Set subCorpusWords=$list(CorpusWordsList,subStart,*)
			//zw subCorpusWords
			Set return=return_..GetCorpusPhrases(subCorpusWords)
			Quit
		} Else {
			Set subCorpusWords=$list(CorpusWordsList,subStart,subEnd-1)
			//zw subCorpusWords
			Set subStart=subEnd+2
			Set return=return_..GetCorpusPhrases(subCorpusWords)
		}
	}
	Quit return
	
GetStructResultErr
	//w $ZError
	Quit return
}

/// 分词结果生成归一词列表
/// zw ##class(DHCHAI.RMES.AnalyCorpusSrv).GetCorpusPhrases($lb("窦性",1,"心律",3,"不齐",5,"待查",7))
ClassMethod GetCorpusPhrases(aCorpusWords As %List) As %List
{
	New (aCorpusWords)
	Set return=""
	Quit:aCorpusWords="" return
	
	//查找否定词、疑似词
	Set NegatorWords="",SuspectWords=""
	For indCW=1:2:$ll(aCorpusWords){
		Set tCorpusWord=$lg(aCorpusWords,indCW)
		Continue:tCorpusWord=""
		Set CorpusOffset=$lg(aCorpusWords,indCW+1)
		Set CorpusWordsDr=$o(^DHCHAI.RME.CorpusWordsI("IdxKeyWord",tCorpusWord,0))
		Continue:CorpusWordsDr=""
		Set CorpusWordsInfo=$g(^DHCHAI.RME.CorpusWordsD(CorpusWordsDr))
		Continue:CorpusWordsInfo=""
		
		Set IsNegator=$lg(CorpusWordsInfo,5)
		Set:IsNegator>0 NegatorWords=NegatorWords_$lb(tCorpusWord,CorpusOffset)
		Set IsSuspect=$lg(CorpusWordsInfo,6)
		Set:IsSuspect>0 SuspectWords=SuspectWords_$lb(tCorpusWord,CorpusOffset)
	}
	
	Kill arrKeywords  //存储拆词结果
	
	Set CorpusResult=..GetFromWords(aCorpusWords)
	//zw CorpusResult
	Quit:CorpusResult="" return
	Set CorpusPhraseList=""
	For indCR=1:1:$ll(CorpusResult) {
		Set tResult=$lg(CorpusResult,indCR)
		Continue:tResult=""
		
		Set tPhrase=$lg(tResult,1)
		Continue:$listfind(CorpusPhraseList,tPhrase)>0
		Set CorpusPhraseList=CorpusPhraseList_$lb(tPhrase)
		Set tLimitWords=$lg(tResult,2)
		Set tCorpusWords=$lg(tResult,3)
		Set tCorpusOffset=$lg(tResult,4)
		
		Set AttrFlag=$s(NegatorWords'="":-1,SuspectWords'="":0,1:1)
		Set arrKeywords("归一词",tPhrase,tCorpusWords,tCorpusOffset)=AttrFlag
	}
	Quit:$o(arrKeywords("归一词",""))="" return
	//zw arrKeywords
	
	//2.2 归一词去重 例：腹主动脉多发斑块->腹主动脉多发斑块、多发斑块、斑块
	Set tLimitWordsStr=""
	Set xOneWord=""
	For {
		Set xOneWord=$o(arrKeywords("归一词",xOneWord))
		Quit:xOneWord=""
		Continue:(+$g(arrKeywords("归一词",xOneWord)))<0
		
		Set xLimitWords=""
		For {
			Set xLimitWords=$o(arrKeywords("归一词",xOneWord,xLimitWords))
			Quit:xLimitWords=""
			
			//查重
			Set IsLike=0
			Set yOneWord=""
			For {
				Set yOneWord=$o(arrKeywords("归一词",yOneWord))
				Quit:yOneWord=""
				Continue:yOneWord=xOneWord
				Continue:(+$g(arrKeywords("归一词",yOneWord)))<0
				
				Set yLimitWords=""
				For {
					Set yLimitWords=$o(arrKeywords("归一词",yOneWord,yLimitWords))
					Quit:yLimitWords=""
					
					Continue:$l(yLimitWords,";")<$l(xLimitWords,";")
					
					//判断是否匹配
					Set IsNotLike=0
					Set tLimitWordsList=$ListFromString(yLimitWords,";")
					For indLW=1:1:$l(xLimitWords,";") {
						Set tLimitWord=$p(xLimitWords,";",indLW)
						Continue:tLimitWord=""
						If $listfind(tLimitWordsList,tLimitWord)<1 {
							Set IsNotLike=1
							Quit
						}
					}
					Continue:IsNotLike>0  //表示不包含
					
					Set IsLike=1
				}
			}
			Continue:IsLike<1
			
			Set arrKeywords("归一词",xOneWord)=-1
		}
	}
	//zw arrKeywords
	
	//输出归一词
	Set xOneWord=""
	For {
		Set xOneWord=$o(arrKeywords("归一词",xOneWord))
		Quit:xOneWord=""
		
		Continue:(+$g(arrKeywords("归一词",xOneWord)))<0  //表示已经处理过
		
		Set LimitWords="",AttrFlag=-1
		Set xLimitWords=""
		For {
			Set xLimitWords=$o(arrKeywords("归一词",xOneWord,xLimitWords))
			Quit:xLimitWords=""
			
			Set LimitWords=LimitWords_$lb(xLimitWords)
			
			Set tLimitOffset=$o(arrKeywords("归一词",xOneWord,xLimitWords,""))
			Continue:tLimitOffset=""
			Set tAttrFlag=$g(arrKeywords("归一词",xOneWord,xLimitWords,tLimitOffset))
			Set:tAttrFlag>AttrFlag AttrFlag=tAttrFlag
		}
		Set LimitWords=$listtostring(LimitWords,"!!")
		Set:AttrFlag="-1" AttrFlag="<HAI_RESULT(-)>"
		Set:AttrFlag="0" AttrFlag="<HAI_RESULT(?)>"
		Set:AttrFlag="1" AttrFlag="<HAI_RESULT(+)>"
		If xOneWord=LimitWords {
			Set return=return_$lb(xOneWord,"",AttrFlag)
		} Else {
			Set return=return_$lb(xOneWord,LimitWords,AttrFlag)
		}
	}
	Kill arrKeywords
	
	Quit return
}

/// zw ##class(DHCHAI.RMES.AnalyCorpusSrv).GetFromWords($lb("腹",1,"主动脉",2,"肠系膜",5,"上",8,"动脉",9,"超",11,"声",12,"检查",13))
ClassMethod GetFromWords(aCorpusWords As %List) As %String
{
	New (aCorpusWords)
	Set return="",retOffset=""
	Quit:aCorpusWords="" return
	
	Kill arrArgs
	Do CheckData(1,"","","")
	
	Quit return
	
CheckData(aPos,aStr,aWords,aOffset)
	Quit:aPos>$ll(aCorpusWords)
	Set args=$lb(aPos,aStr,aWords,aOffset)
	Quit:$d(arrArgs(args))
	Set arrArgs(args)=""
	
	Set tStr=aStr_$lg(aCorpusWords,aPos)
	If $d(^DHCHAI.RME.CorpusPhrasesI("IndexLimitWords",1,tStr)) {
		Set tWord=aWords_";"_$lg(aCorpusWords,aPos)
		Set tOffset=aOffset_";"_$lg(aCorpusWords,aPos+1)
		Set:tWord'="" tWord=$e(tWord,2,*)
		Set:tOffset'="" tOffset=$e(tOffset,2,*)
		
		If ($listfind(retOffset,tOffset)<1){
			Set retOffset=retOffset_$lb(tOffset)
			
			Set OneWord=""
			Set PhrasesDr=$o(^DHCHAI.RME.CorpusPhrasesI("IndexLimitWords",1,tStr,0))
			If PhrasesDr'="" {
				Set PhrasesInfo=$g(^DHCHAI.RME.CorpusPhrasesD(PhrasesDr))
				If PhrasesInfo'="" {
					Set OneWord=$lg(PhrasesInfo,2)
				}
				Set return=return_$lb($lb(OneWord,tStr,tWord,tOffset))
			}
		}
	}
	
	Set tStr=aStr_$lg(aCorpusWords,aPos)
	Set xWord=$o(^DHCHAI.RME.CorpusPhrasesI("IndexLimitWords",1,tStr))
	If $e(xWord,1,$l(tStr))=tStr {
		Set tWord=aWords_";"_$lg(aCorpusWords,aPos)
		Set tOffset=aOffset_";"_$lg(aCorpusWords,aPos+1)
		Do CheckData(aPos+2,tStr,tWord,tOffset)
	}
	
	Set tStr=aStr_$lg(aCorpusWords,aPos)_";"
	Set xWord=$o(^DHCHAI.RME.CorpusPhrasesI("IndexLimitWords",1,tStr))
	If $e(xWord,1,$l(tStr))=tStr {
		Set tWord=aWords_";"_$lg(aCorpusWords,aPos)
		Set tOffset=aOffset_";"_$lg(aCorpusWords,aPos+1)
		Do CheckData(aPos+2,tStr,tWord,tOffset)
	}
	
	Quit:(aPos+2)>$ll(aCorpusWords)
	Do CheckData(aPos+2,"","","")
	
	Quit  //退出
}

/// 句式特殊处理（倒序）
ClassMethod GetCorpusPatterns1(aInputStr As %String, aOrderFlg As %String = "") As %String
{
	New (aInputStr,aOrderFlg)
	Set return=""
	Quit:aInputStr="" return
	
	Set aInputStr=$tr(aInputStr,"|"," ")
	If (aOrderFlg="")||($zcvt(aOrderFlg,"U")="DESC"){
		If aInputStr["炎症性病变为" {
			//以关节慢性炎症性病变为主要表现
			Set aInputStr=$REPLACE(aInputStr,"炎症性病变为","炎症性病变 ")
		}
	}
	
	Quit aInputStr
}

/// 句式特殊处理2（正序）
ClassMethod GetCorpusPatterns2(aInputStr As %String, aOrderFlg As %String = "") As %String
{
	New (aInputStr,aOrderFlg)
	Set return=""
	Quit:aInputStr="" return
	
	Set aInputStr=$tr(aInputStr,"|"," ")
	If (aOrderFlg="")||($zcvt(aOrderFlg,"U")'="DESC"){
		If aInputStr["炎症性病变为" {
			//以关节慢性炎症性病变为主要表现
			Set aInputStr=$REPLACE(aInputStr,"炎症性病变为","炎症性病变 ")
		}
	}
	
	Quit aInputStr
}

/// 字符串拆同义词
/// zw ##class(DHCHAI.RMES.AnalyCorpusSrv).GetCorpusWords("完善盆腔超声、血常规、凝血等检查")
ClassMethod GetCorpusWords(aInputStr As %String, aOrderFlg As %String = "") As %List
{
	New (aInputStr,aOrderFlg)
	Set return=""
	Quit:aInputStr="" return
	
	If (aOrderFlg="")||($zcvt(aOrderFlg,"U")="DESC"){
		//特殊句式处理
		Set aInputStr=..GetCorpusPatterns1(aInputStr)
		
		//倒序拆词 例：窦性心律不齐->窦性、心律不齐
		Set indK=0,xCounter=0
		For {
			Set indK=$i(xCounter)
			Quit:indK>$l(aInputStr)
			
			Set tChar=$e(aInputStr,*-indK+1)
			Continue:tChar=""
			
			//特殊字符处理
			If ("；。！;!"[tChar)||(tChar=$c(13))||(tChar=$c(10)) {
				Set return=$lb("|",$l(aInputStr)-indK+1)_return
				Continue
			} Else {
				Continue:tChar=" "  //空格
				Continue:$c(1,2,3,4,5,6,7,8)[tChar  //不可见字符
				//Continue:"，、：‘’“”"[tChar  //中文符号
				//Continue:"~!@#$%^&*()_+-=,.'""?"[tChar  //英文符号
				//Continue:"ABCDEFGHIJKLMNOPQRSTUVWXYZ"[$zcvt(tChar,"U")  //字母开头不处理
				//Continue:"0123456789"[tChar  //数字开头不处理
			}
			
			//语义词分词
			Set ParserWord="",OffSet=""
			Set xLen=0,xStr=tChar
			For {
				If ($d(^DHCHAI.RME.CorpusWordsI("IndexNegWord",1,xStr))
				||($tr(xStr,"0123456789-/~+-%.、()（）～日月年时分秒天岁个前后左右 ","")="")
				||($tr(xStr,"'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz","")=""))
				{
					If $l(xStr)<62 { //控制最大长度
						Set ParserWord=$e(aInputStr,*-indK-xLen+1,*-indK+1)
						Set OffSet=$l(aInputStr)-indK-xLen+1
					}
				} Else {
					Set tWord=$o(^DHCHAI.RME.CorpusWordsI("IndexNegWord",1,xStr))
					Set yChar=$e(aInputStr,*-indK-xLen+2)
					If (($e(tWord,1,$l(xStr))'=xStr)
					&&($tr(yChar,"0123456789-/~+-%.、()（）～日月年时分秒天岁个前后左右 ","")'="")
					&&($tr(yChar,"'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz","")'=""))
					{
						Quit //退出循环
					}
				}
				Set xLen=xLen+1
				Quit:(indK+xLen)>$l(aInputStr)
				Set xStr=xStr_$e(aInputStr,*-indK-xLen+1)
			}
			Continue:ParserWord=""
			Set xCounter=indK+$l(ParserWord)-1  //当前字符串计数器
			Set return=$lb(ParserWord,OffSet)_return
		}
	} Else {
		//特殊句式处理
		Set aInputStr=..GetCorpusPatterns2(aInputStr)
		
		//正序拆词 例：窦性心律不齐->窦性心律、不齐
		Set indK=0,xCounter=0
		For {
			Set indK=$i(xCounter)
			Quit:indK>$l(aInputStr)
			
			Set tChar=$e(aInputStr,indK)
			Continue:tChar=""
			
			//特殊字符处理
			If ("；。！;!"[tChar)||(tChar=$c(13))||(tChar=$c(10)) {
				Set return=$lb("|",$l(aInputStr)-indK+1)_return
				Continue
			} Else {
				Continue:tChar=" "  //空格
				Continue:$c(1,2,3,4,5,6,7,8)[tChar  //不可见字符
				//Continue:"，、：‘’“”"[tChar  //中文符号
				//Continue:"~!@#$%^&*()_+-=,.'""?"[tChar  //英文符号
				//Continue:"ABCDEFGHIJKLMNOPQRSTUVWXYZ"[$zcvt(tChar,"U")  //字母开头不处理
				//Continue:"0123456789"[tChar  //数字开头不处理
			}
			
			//语义词分词
			Set ParserWord="",OffSet=""
			Set xLen=0,xStr=tChar
			For {
				If ($d(^DHCHAI.RME.CorpusWordsI("IndexKeyWord",1,xStr))
				||($tr(xStr,"0123456789-/~+-%.、()（）～日月年时分秒天岁个前后左右 ","")="")
				||($tr(xStr,"'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz","")=""))
				{
					If $l(xStr)<62 { //控制最大长度
						Set ParserWord=$e(aInputStr,indK,indK+xLen)
						Set OffSet=indK
					}
				} Else {
					Set tWord=$o(^DHCHAI.RME.CorpusWordsI("IndexKeyWord",1,xStr))
					Set yChar=$e(aInputStr,indK+xLen+1)
					If (($e(tWord,1,$l(xStr))'=xStr)
					&&($tr(yChar,"0123456789-/~+-%.、()（）～日月年时分秒天岁个前后左右 ","")'="")
					&&($tr(yChar,"'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz","")'=""))
					{
						Quit //退出循环
					}
				}
				Set xLen=xLen+1
				Quit:(indK+xLen)>$l(aInputStr)
				Set xStr=xStr_$e(aInputStr,indK+xLen)
			}
			Continue:ParserWord=""
			Set xCounter=indK+$l(ParserWord)-1  //当前字符串计数器
			Set return=return_$lb(ParserWord,OffSet)
		}
	}
	Quit return
}

/// 召回率
/// Do ##class(DHCHAI.RMES.AnalyCorpusSrv).Test1(100)
ClassMethod Test1(aTestCnt As %String) As %String
{
	New (aTestCnt)
	Set Count=0
	
	Set xContext=""
	For {
		Set xContext=$o(^DHCHAI.RME.CorpusPhrasesI("IndexContext",xContext))
		Quit:xContext=""
		Set Count=Count+1
		Quit:Count>aTestCnt
		
		Set OneWordRst=..GetStructResult(xContext)
		
		Set OneWordErr=""
		Set xPhrasesDr=0
		For {
			Set xPhrasesDr=$o(^DHCHAI.RME.CorpusPhrasesI("IndexContext",xContext,xPhrasesDr))
			Quit:xPhrasesDr=""
			
			Set PhrasesInfo=$g(^DHCHAI.RME.OneWordsD(xPhrasesDr))
			Continue:PhrasesInfo=""
			Set OneWord=$lg(PhrasesInfo,2)
			
			If $listfind(OneWordRst,OneWord)<1 {
				Continue:$listfind(OneWordErr,OneWord)>0
				Continue:(OneWord["年")&(OneWord["月")
				Continue:(OneWord["月")&(OneWord["日")
				Continue:(OneWord["时")&(OneWord["分")
				Continue:(OneWord["岁")&(OneWord["月")
				Continue:(OneWord["孕")&(OneWord["周")
				Continue:(OneWord["停经")&(OneWord["天")
				Continue:(OneWord["绝经")&(OneWord["岁")
				Continue:(OneWord["小时")
				Continue:($e(OneWord,*)="月")
				Continue:($e(OneWord,*)="年")
				Set OneWordErr=OneWordErr_$lb(OneWord)
			}
		}
		Continue:OneWordErr=""
		
		w "--------------------------------------------------",!
		w xContext,!
		s CorpusWords=..GetCorpusWords(xContext)
		w "-----分词="_$listtostring(CorpusWords,","),!
		w "-----未招回="_$listtostring(OneWordErr,","),!
	}
	Quit "OK"
}

/// 准确率
/// Do ##class(DHCHAI.RMES.AnalyCorpusSrv).Test2(100)
ClassMethod Test2(aTestCnt As %String) As %String
{
	New (aTestCnt)
	Set Count=0
	
	Set xContext=""
	For {
		Set xContext=$o(^DHCHAI.RME.CorpusPhrasesI("IndexContext",xContext))
		Quit:xContext=""
		Set Count=Count+1
		Quit:Count>aTestCnt
		
		Set OneWordRst=..GetStructResult(xContext)
		
		Set OneWordRst2=""
		Set xPhrasesDr=0
		For {
			Set xPhrasesDr=$o(^DHCHAI.RME.CorpusPhrasesI("IndexContext",xContext,xPhrasesDr))
			Quit:xPhrasesDr=""
			
			Set PhrasesInfo=$g(^DHCHAI.RME.CorpusPhrasesD(xPhrasesDr))
			Continue:PhrasesInfo=""
			Set OneWord=$lg(PhrasesInfo,2)
			
			Continue:$listfind(OneWordRst2,OneWord)>0
			Set OneWordRst2=OneWordRst2_$lb(OneWord)
		}
		
		Set OneWordErr=""
		For indRst=1:2:$ll(OneWordRst) {
			Set tOneWord=$lg(OneWordRst,indRst)
			Continue:tOneWord=""
			
			If $listfind(OneWordRst2,tOneWord)<1 {
				Continue:$listfind(OneWordErr,tOneWord)>0
				Set OneWordErr=OneWordErr_$lb(tOneWord)
			}
		}
		Continue:OneWordErr=""
		
		w "--------------------------------------------------",!
		w xContext,!
		s CorpusWords=..GetCorpusWords(xContext)
		w "-----分词="_$listtostring(CorpusWords,","),!
		w "-----准确性="_$listtostring(OneWordErr,","),!
	}
	Quit "OK"
}

}
