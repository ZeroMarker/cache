/// 名称: DHCHAI.RMES.SaveResultSrv
/// 描述: 保存语义分析结果服务
/// 编写者：zhufei
/// 编写日期: 2017-11-11
Class DHCHAI.RMES.SaveResultSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-08-29
/// Description:  存储语义分析结果
/// Table：       DHCHAI.RME.DocMaster
/// Input：       结果字符串
/// Return：      成功：返回主记录id，失败：返回<0的代码
/// w ##class(DHCHAI.RMES.SaveResultSrv).SaveJsonResult("")
ClassMethod SaveJsonResult(aThemeCode As %String, aEpisodeDr As %String, aDocNumber As %String, aJsonResult As %ArrayOfDataTypes) As %String
{
	New (aThemeCode,aEpisodeDr,aDocNumber,aJsonResult)
	Set return=0
	Quit:(aThemeCode="")||(aEpisodeDr="")||(aDocNumber="")||(aJsonResult="") return
	
	//测试输入Json内容
	//Do ##class(DHCHAI.RMES.SaveResultSrv).OutputJson(aJsonResult,"-")
	//Quit return
	
	//******************************************************************
	//1 解析Json->文档
	//******************************************************************
	Set DocContent   = aJsonResult.GetAt("Doc_Str")   //处理后的数据
	Set DocTitle     = aJsonResult.GetAt("Doc_Title")
	Set DocType      = aJsonResult.GetAt("Doc_Type")
	Quit:aJsonResult.IsDefined("Doc_Tree")'=1 return
	Set arrDocSection= aJsonResult.GetAt("Doc_Tree")
	
	//文档类型
	Set DocTypeDr=""
	Set objDocType=##class(DHCHAI.RME.DocType).GetObjByCode(DocType)
	If $IsObject(objDocType){
		Set DocTypeDr=objDocType.%Id()
	} Else {
		Set DocTypeStr="^"_DocType_"^"_DocType
		Set DocTypeDr=##class(DHCHAI.RME.DocType).Update(DocTypeStr)
	}
	Quit:DocTypeDr="" return
	
	//语义词库版本
	Set VersionDr=""
	Set objVersion=##class(DHCHAI.RME.ThemeType).GetVersionByThCode(aThemeCode)  //HAI语义分析词库
	If $IsObject(objVersion){
		Set VersionDr=objVersion.%Id()
	}
	Quit:VersionDr="" return
	
	//唯一索引
	Set DocMasterDr=$o(^DHCHAI.RME.DocMasterI("IndexDocNumber",VersionDr," "_aDocNumber,0))
	
	//保存文档
	Set InputStr=""
	Set $p(InputStr,"^",1)=DocMasterDr
	Set $p(InputStr,"^",2)=aDocNumber
	Set $p(InputStr,"^",3)=aEpisodeDr
	Set $p(InputStr,"^",4)=$s($l(DocContent)>1000:$e(DocContent,1,1000),1:DocContent)
	Set $p(InputStr,"^",5)=DocTitle
	Set $p(InputStr,"^",6)=VersionDr
	Set $p(InputStr,"^",7)=DocTypeDr
	Set $p(InputStr,"^",8)="1"          //是否有效
	Set DocMasterDr=##class(DHCHAI.RME.DocMaster).Update(InputStr)
	Quit:(+DocMasterDr)<1 return
	Set return=DocMasterDr
	
	//******************************************************************
	//2 解析Json->段落
	//******************************************************************
	Set flg=##class(DHCHAI.RME.DocMaster).ClearSection(DocMasterDr)	//清空原有文档段落
	For indDS=1:1:arrDocSection.Count() {
		//Write !,indDS_". value="""_arrDocSection.%Get(indDS)_""" type="_arrDocSection.%GetTypeOf(indDS)
		
		//段落节点
		Set objSection=arrDocSection.GetAt(indDS)
		Set SectionGroupNo = indDS+1
		Set SectionType    = objSection.GetAt("Section_Type")
		Set SectionContent = objSection.GetAt("Section_Content") //可能不存在 ,为空
		
		/* 子段落暂不处理 */
		Set SubSections    = objSection.GetAt("Sub_Sections")
		Continue:SectionType=""
		
		Continue:objSection.IsDefined("Section_Result")'=1
		Set arrSectionResult=objSection.GetAt("Section_Result")
		Continue:arrSectionResult.Count()<1
		
		//段落分类
		Set SectionTypeDr=""
		Set objSectionType=##class(DHCHAI.RME.SectionType).GetObjByCode(SectionType)
		If $IsObject(objSectionType){
			Set SectionTypeDr=objSectionType.%Id()
		} Else {
			Set SectionTypeStr="^"_SectionType_"^"_SectionType
			Set SectionTypeDr=##class(DHCHAI.RME.SectionType).Update(SectionTypeStr)
		}
		Continue:SectionTypeDr=""
		
		//保存段落
		Set InputStr=""
		Set $p(InputStr,"^",1)=DocMasterDr
		Set $p(InputStr,"^",2)=""             //ChildSub
		Set $p(InputStr,"^",3)=SectionTypeDr
		Set $p(InputStr,"^",4)=SectionContent
		Set $p(InputStr,"^",5)=SectionGroupNo
		Set DocSectionDr=##class(DHCHAI.RME.DocSection).Update(InputStr)
		Continue:(+DocSectionDr)<1
		
		//******************************************************************
		//3 解析Json->结果
		//******************************************************************
		Set keyDR=""
		For {
			Set valueDR=arrSectionResult.GetNext(.keyDR)
			Quit:keyDR=""
			Continue:'$IsObject(valueDR)  //不是对象
			//Write "keyDR = "_keyDR_" , valueDR = "_valueDR,!
			
			//结果类型
			Set ResultType=keyDR
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
			
			For indDR=1:1:valueDR.Count() {
				Set objRecord   = valueDR.GetAt(indDR)
				Continue:'$IsObject(objRecord)
				Continue:objRecord.IsDefined("NAME")'=1
				
				Set DRContext=""  //语境
				If objRecord.IsDefined("CONTEXT")=1 {
					Set DRContext=objRecord.GetAt("CONTEXT")
				}
				Set DRFormal=""   //上位词***
				If objRecord.IsDefined("FORMAL")=1 {
					Set DRFormal=objRecord.GetAt("FORMAL")
				}
				Set OneWord=objRecord.GetAt("NAME")
				
				Set OneWordDr=""
				If DRFormal'=OneWord {
					//上位词（字典添加到归一词库）
					Set objOneWord=##class(DHCHAI.RME.OneWords).GetObjByOneWord(VersionDr,DRFormal)
					If $IsObject(objOneWord){
						Set OneWordDr=objOneWord.%Id()
					} Else {
						Set OneWordStr="^"_VersionDr_"^"_DRFormal_"^"_ResultCatDr_"^^^"
						Set OneWordDr=##class(DHCHAI.RME.OneWords).Update(OneWordStr)
					}
				} Else {
					//归一词
					Set objOneWord=##class(DHCHAI.RME.OneWords).GetObjByOneWord(VersionDr,OneWord)
					If $IsObject(objOneWord){
						Set OneWordDr=objOneWord.%Id()
					} Else {
						Set OneWordStr="^"_VersionDr_"^"_OneWord_"^"_ResultCatDr_"^^^"
						Set OneWordDr=##class(DHCHAI.RME.OneWords).Update(OneWordStr)
					}
				}
				Continue:OneWordDr=""
				
				//******************************************************************
				//4 解析Json->属性
				//******************************************************************
				Set DRPropertys = ""  //属性集合
				If objRecord.IsDefined("PROPERTY")=1 {
					Set RdProperty=objRecord.GetAt("PROPERTY")
					For idxRP=1:1:RdProperty.Count(){
						Set objProperty = RdProperty.GetAt(idxRP)
						
						//属性类型
						Set ProTypeDr=""
						Set ProType=objProperty.GetAt("TYPE")
						Set objProType=##class(DHCHAI.RME.PropertyType).GetObjByCode(ProType)
						If $IsObject(objProType){
							Set ProTypeDr=objProType.%Id()
						} Else {
							Set ProTypeStr="^"_ProType_"^"_ProType
							Set ProTypeDr=##class(DHCHAI.RME.PropertyType).Update(ProTypeStr)
						}
						Continue:ProTypeDr=""
						
						Set DPName  = objProperty.GetAt("NAME")
						Continue:DPName=""
						Set DPValue = objProperty.GetAt("VALUE")
						Set DPUnit  = objProperty.GetAt("UNIT")
						If (DRPropertys=""){
							Set DRPropertys = ProTypeDr_"@"_DPName_"@"_DPValue_"@"_DPUnit
						} Else{
							Set DRPropertys=DRPropertys_"#"_ProTypeDr_"@"_DPName_"@"_DPValue_"@"_DPUnit
						}
					}
				}
				
				Set OffSetList="",ParserWordList=""
				If objRecord.IsDefined("OFFSET")=1 {
					Set RdOffSet=objRecord.GetAt("OFFSET")
					For indOS=1:1:RdOffSet.Count(){
						Set arrOffSet=RdOffSet.GetAt(indOS)
						Set SttOffSet=arrOffSet.GetAt(1)
						Set EndOffSet=arrOffSet.GetAt(2)
						Set OffSetList=OffSetList_$lb(SttOffSet_","_EndOffSet)
						
						Set ParserWord=$e(DocContent,SttOffSet+1,EndOffSet)
						Continue:ParserWord=""
						
						Continue:$listfind(ParserWordList,ParserWord)>0
						Set ParserWordList=ParserWordList_$lb(ParserWord)
					}
				}
				
				//位置
				Set OffSetList=##class(DHCHAI.Utils.CommonSrv).ListToString(OffSetList,";")
				
				//同义词
				Set ParserWords=##class(DHCHAI.Utils.CommonSrv).ListToString(ParserWordList,";")
				Set LimitWord=$s(ParserWords[";":ParserWords,1:"")
				For indPW=1:1:$l(ParserWords,";") {
					Set ParserWord=$p(ParserWords,";",indPW)
					Continue:ParserWord=""
					
					Set objParserWord=##class(DHCHAI.RME.ParserWords).GetObjByVerKeyWord(VersionDr,ParserWord,LimitWord)
					If '$IsObject(objParserWord){
						
						Set ParserWordStr=""
						Set ParserWordStr=ParserWordStr_"^"_VersionDr
						//处理文本中有上箭头 ^
						Set:ParserWord["^" ParserWord = $tr(ParserWord,"^","ˋ")
						Set ParserWordStr=ParserWordStr_"^"_ParserWord
						//处理文本中有上箭头 ^
						Set:LimitWord["^" LimitWord = $tr(LimitWord,"^","ˋ")
						Set ParserWordStr=ParserWordStr_"^"_LimitWord
						Set:DRContext["^" DRContext = $tr(DRContext,"^","ˋ")
						Set ParserWordStr=ParserWordStr_"^"_$tr(DRContext,"^","")
						Set ParserWordStr=ParserWordStr_"^"_OneWordDr
						Set ParserWordStr=ParserWordStr_"^"_0
						Set ParserWordStr=ParserWordStr_"^"_1
						Set ParserWordStr=ParserWordStr_"^^^"
						Set ParserWordDr=##class(DHCHAI.RME.ParserWords).Update(ParserWordStr)
					}
				}
				
				//保存段落结果
				Set InputStr=""
				Set $p(InputStr,"^",1)=DocSectionDr
				Set $p(InputStr,"^",2)=""             //ChildSub
				Set $p(InputStr,"^",3)=ResultTypeDr
				Set $p(InputStr,"^",4)=OneWord
				Set $p(InputStr,"^",5)=DRContext
				Set $p(InputStr,"^",6)=DRPropertys
				Set $p(InputStr,"^",7)=OffSetList
				Set $p(InputStr,"^",8)=ParserWords
				Set $p(InputStr,"^",9)=DRFormal
				Set DocResultDr=##class(DHCHAI.RME.DocResult).Update(InputStr)
			}
		}
	}
	Quit return
}

/// Do ##class(DHCHAI.RMES.SaveResultSrv).OutputJson(json,"-")
ClassMethod OutputJson(json As %ArrayOfDataTypes, head As %String = "") As %String
{
	New (json,head)
	Set key=""
	For {
		Set value=json.GetNext(.key)
		Quit:key=""
		
		Set data=json.GetAt(key)
		if $IsObject(data){
			w head_key_" = "_data,!
			Do ..OutputJson(data,head_"-")
		} else {
			w head_key_" = "_data,!
		}
	}
	Quit 1
}

}
