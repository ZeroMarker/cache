/// 项目数据源标准字典配置服务类
Class DHCMA.CPW.SDS.QCItemDataConfigSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 通过数据标准化信息以及项目配置信息 获取项目值
/// w ##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetValByDataConfig(2814979,"1||39")
ClassMethod GetValByDataConfig(aEpisodeID As %String = "", aItemID As %String = "") As %String
{
	New (aEpisodeID,aItemID)
	Set return=""
	Set $zt="GetValByDataConfigErr"
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	Quit:(aEpisodeID="")||(aItemID="") return
	Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aItemID)
	Quit:'$IsObject(objItem) return
	Set aItemDesc=objItem.BTDesc 
	//1 通过项目数据配置获取
	Set ConfigID=$o(^DHCMA.CPW.SD.QCItemDataConfigI("IdxItem",aItemID,0))
	Set objConfig=##class(DHCMA.CPW.SD.QCItemDataConfig).GetObjById(ConfigID)
	If ($Isobject(objConfig)) {
		If (objItem.BTTypeDr.BTDesc'["字典") {
			//非字典类型项目，从数据中心取值
			Set return=..getItemValByField(aEpisodeID,objConfig)
		}elseif(objConfig.DataSource.BTDesc="电子病历"){
			//电子病历语义分析项目单独处理
			Set aTypeDr=$o(^DHCMA.CPW.SD.DicTypeI("IdxofItemDR",aItemID,0))
		 	Quit:aTypeDr="" $$$OK
			Set return=..GetValByAnalyDHC(aEpisodeID,objConfig,aTypeDr)
		}elseif(objConfig.DataSource.BTDesc="基础信息"){
			//配置了基础取值信息的
			Set DicID=objConfig.StandDicSub.%Id()
			Set TabelInfo=##class(DHCMA.CPW.SD.Stand.TableInfo).GetTableStrByDic(DicID)
			Quit:TabelInfo="" return
			Set Table=$p(TabelInfo,"^",1)
			Set Field=$p(TabelInfo,"^",2)
			Set Table=$tr(Table,"_",".")
			Set result=..GetTableVal(aEpisodeID,Table,Field)
			If (objItem.BTTypeDr.BTDesc'["字典") {
				//如果非字典类型 ，直接返回基础信息结果
				Quit result	
			}else{
				//如果是字典类型，判断字典是否符合
				Set aTypeDr=$o(^DHCMA.CPW.SD.DicTypeI("IdxofItemDR",aItemID,0))
		 		Quit:aTypeDr="" return
				Set return=..MatchStandDicByDesc(aTypeDr,result,objConfig.CalExp)
			}
		}else{
			//字典类项目
			Set aTypeDr=$o(^DHCMA.CPW.SD.DicTypeI("IdxofItemDR",aItemID,0))
		 	Quit:aTypeDr="" $$$OK
		 	Set SourceField=objConfig.SourceField
		 	//获取配置信息数据源
		 	If (SourceField'="") {
			 	//如果项目配置有取值字典，按照项目配置输出字段进行取值对照
			 	Set return=..getItemValByField(aEpisodeID,objConfig)
			 	//通过描述 匹配标准字典
			 	Set result=$p(return,"^",1)
			 	Set addinfo=$p(return,"^",2)
			 	Set return=..MatchStandDicByDesc(aTypeDr,result,objConfig.CalExp)
			 	Set return=return_"^"_addinfo
		 	}else {
			 	//走自动匹配值域字典与项目标准字典取值
			 	Set return=..AutoValByDicDesc(aEpisodeID,objConfig,aTypeDr)
			 	Set:return["," return=$e(return,2,$l(return))
		 	}
		}
	}else{
		//2 通过匹配标准化字典，直接取表字典
		Set DicID=..GetStandDicID(aItemDesc)
		Quit:DicID="" return
		Set TabelInfo=##class(DHCMA.CPW.SD.Stand.TableInfo).GetTableStrByDic(DicID)
		Quit:TabelInfo="" return
		Set Table=$p(TabelInfo,"^",1)
		Set Field=$p(TabelInfo,"^",2)
		Set Table=$tr(Table,"_",".")
		Set return=..GetTableVal(aEpisodeID,Table,Field)
	}
	Quit return
GetValByDataConfigErr
	w $ZE,!
	Quit ""
}

ClassMethod GetTableVal(aEpisodeID, aTable, aField) As %String
{
	new (aEpisodeID,aTable,aField)
	Set return=""
	Set $zt="GetTableValErr"
	Quit:(aEpisodeID="")||(aTable="")||(aField="") return
	If (aTable["Nur") {
			Set xobj=##class(DHCMA.CPW.SD.DataSrv.NurInfoSrv).GetDataByAdm(aEpisodeID)
			Quit:'$IsObject(xobj) return
			Set exp="set return=xobj."_aField
			x exp
		}elseIf (aTable["Fee") {
			Set xobj=##class(DHCMA.CPW.SD.DataSrv.FeeInfoSrv).GetDataByAdm(aEpisodeID)
			Quit:'$IsObject(xobj) return
			Set exp="set return=xobj."_aField
			x exp
		}elseIf (aTable["Base") {
			Set xobj=##class(DHCMA.CPW.SD.DataSrv.BaseInfoSrv).GetDataByAdm(aEpisodeID)
			Quit:'$IsObject(xobj) return
			Set exp="set return=xobj."_aField
			x exp
		}elseIf (aTable["FP") {
			Set xobj=##class(DHCMA.CPW.SD.DataSrv.FPInfoSrv).GetDataByAdm(aEpisodeID)
			Quit:'$IsObject(xobj) return
			Set exp="set return=xobj."_aField
			x exp
		}
	Quit return
GetTableValErr
	Quit ""
}

/// 通过配置信息以及值域信息，匹配电子病历记录中各值域字典结果
/// w ##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetValByAnalyDHC()
ClassMethod GetValByAnalyDHC(aEpisodeID, objConfig, aTypeDr) As %String
{
	New (aEpisodeID,objConfig,aTypeDr)
	Set xreturn=""
	Set DataSource   = objConfig.DataSource	
	Set SourceField  = objConfig.SourceField	
	Set StandDic     = objConfig.StandDic
	Set DocType=StandDic.DicCatDesc
	Quit:DocType="" xreturn
	k AnalyDHCArr
	Set xRowID=""
	For {
		Set xRowID=$o(^DHCMA.CPW.SD.Data.EmrRecordI("IndexAdmDocType",aEpisodeID,DocType,xRowID))
		Quit:xRowID=""
		Set xEmrobj=##class(DHCMA.CPW.SD.Data.EmrRecord).GetObjById(xRowID)	
		Continue:'$IsObject(xEmrobj)
		Set oContent=xEmrobj.DocContent
		//获取语义分析后的文本内容
		Set xContent=xEmrobj.AnalyDocContent
		Continue:xContent=""
		For xind=1:1:$l(xContent,$c(1)) {
			Set subContent=$p(xContent,$c(1),xind)
			Set xIndexStr=$p(subContent,$c(2),7)
			Set ResultType=$p(subContent,$c(2),2)
			Set OneWord=$p(subContent,$c(2),1)	
			Set FormalWord=$p(subContent,$c(2),8)
			Set:FormalWord="" FormalWord=OneWord	
			//根据项目标准字典常用短语对主题词进行归一化
			Set StandDicDesc=..GetStandDicDesc(FormalWord)
			Set:StandDicDesc'="" FormalWord=StandDicDesc
			Set indxStr=$p(subContent,$c(2),7)
			Set:'$d(AnalyDHCArr(ResultType)) AnalyDHCArr(ResultType)=""
			Continue:$lf(AnalyDHCArr(ResultType),FormalWord)>0
			//将各个类型的归一词以及其所在文档记录ID 开始结束位置记录下来
			Set AnalyDHCArr(ResultType)=$g(AnalyDHCArr(ResultType))_$lb(FormalWord,xRowID_"|"_indxStr)
		}
	}
 	//按照值域字典描述匹配项目标准字典进行取值
 	Set xID="",DicDescStr="",DicCodeArr="",DicStr=""
 	Set dicStartIndx=0,KeyDicCode=""
 	k DicAnalyDHCArr,tDicIndxArr
 	For {
 		Set xID	= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDr",aTypeDr,xID))
 		Quit:xID=""
	 	//获取值域字典信息
	 	Set DicObj=##class(DHCMA.CPW.SD.Dictionary).GetObjById(xID)
	 	Set DicCode=DicObj.BTCode
	 	Set DicDesc=DicObj.BTDesc
	 	Continue:(DicDesc["请选择")||(DicDesc="")
	 	//获取值域字典关键字，如果有关键字信息先走模糊匹配
	 	/*Set standID=..GetStandDicID(DicDesc)
	 	If (standID'="") {
			Set KeyId=$o(^DHCMA.CPW.SD.Stand.KeyInfoI("IdxDic",standID,0))
			If (KeyId'="") {
				Set Keyobj=##class(DHCMA.CPW.SD.Stand.KeyInfo).GetObjById(KeyId)
				Set DicKey=Keyobj.ResultKeys
				Set DicFilter=Keyobj.ResultFilter
				Set KeyFlg=##class(DHCMA.CPW.SDS.QCTask).CheckDicKey(oContent,DicKey,DicFilter)
				If (KeyFlg=1) {
					Set KeyDicCode=KeyDicCode_DicCode_","
					Continue
				}
			}
		}*/
	 	//存储每个字典在文本中的位置信息
	 	Set tDicIndxArr(DicCode)=$lb(dicStartIndx,dicStartIndx+$l(DicDesc)-1)
	 	//每个值域字典拼上句号，防止值域字典被联合解析。
	 	Set DicStr=DicStr_DicDesc_"。"
	 	Set dicStartIndx=$l(DicStr)
 	}
 	//对字典内容进行语义分析
 	Set xDicStr=##Class(DHCMA.CPW.SDS.IO.ToDocService).AnalyDHC(DicStr)
 	For xind=1:1:$l(xDicStr,$c(1)) {
	 	Set subContent=$p(xDicStr,$c(1),xind)
		Set xIndexStr=$p(subContent,$c(2),7)
		Set ResultType=$p(subContent,$c(2),2)
		Set OneWord=$p(subContent,$c(2),1)	
		Set FormalWord=$p(subContent,$c(2),8)
		Set TargeStart=$p(xIndexStr,"^",1)
		//根据项目标准字典常用短语对主题词进行归一化
		Set:FormalWord="" FormalWord=OneWord
		Continue:FormalWord=""
		Set StandDicDesc=..GetStandDicDesc(FormalWord)
		Set:StandDicDesc'="" FormalWord=StandDicDesc
		Set xCode="",DicCode="",startIndx="",endIndx=""
		For {
			Set xCode=$o(tDicIndxArr(xCode))
			Quit:xCode=""
			Set CodeIndx=$g(tDicIndxArr(xCode))
			Set startIndx=$lg(CodeIndx,1)
			Set endIndx=$lg(CodeIndx,2)
			Set:(TargeStart>=startIndx)&&(TargeStart<=endIndx) DicCode=xCode
			Quit:DicCode'=""
		}
		Set:'$d(DicAnalyDHCArr(DicCode,ResultType)) DicAnalyDHCArr(DicCode,ResultType)=""
		//同一字典项主题词不应该重复
		Continue:$lf(DicAnalyDHCArr(DicCode,ResultType),FormalWord)>0
		Set DicAnalyDHCArr(DicCode,ResultType)=$g(DicAnalyDHCArr(DicCode,ResultType))_$lb(FormalWord)
	}
 	//将值域字典的语义核心词与病历语义核心词进行匹配
 	Set xDicCode="",addInfo=""
 	For {
	 	Set xDicCode=$o(DicAnalyDHCArr(xDicCode))
	 	Quit:xDicCode=""
	 	Set xType="",xOneWordArr="",xDHCOneWordArr="",MatchFlg=""
	 	For {
		 	Set xType=$o(DicAnalyDHCArr(xDicCode,xType))
		 	Quit:xType=""
		 	Set xOneWordArr=$g(DicAnalyDHCArr(xDicCode,xType))
		 	Set xDHCOneWordArr=$g(AnalyDHCArr(xType))
		 	Continue:(xOneWordArr="")||(xDHCOneWordArr="")
		 	//Set MatchFlg=0
		 	For zInd=1:1:$ll(xOneWordArr) {
				Set xOneWord=$lg(xOneWordArr,zInd)
				Set WordTarget=$lf(xDHCOneWordArr,xOneWord)
				If (WordTarget>0) {
					Set MatchFlg=1
					Set addInfo=addInfo_"#"_$lg(xDHCOneWordArr,WordTarget+1)
				}
				Quit:MatchFlg=1
			}
			//如果有任意类型没匹配上，则判定匹配失败
			//Quit:MatchFlg=0
			
		 }
		Set:MatchFlg=1 xreturn=xreturn_","_xDicCode
	}
	Set:KeyDicCode'="" xreturn=xreturn_","_KeyDicCode
	Set:xreturn'="" xreturn=xreturn_"^EMR:"_addInfo
	Quit xreturn
}

/// w ##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetStandDicDesc("上报医师")
ClassMethod GetStandDicDesc(aItemDesc As %String) As %String
{
	New (aItemDesc)
	Set DicID="",OneWord=""
	Quit:aItemDesc="" ""
	//优先通过标准字典取匹配信息
	If ($d(^DHCMA.CPW.SD.Stand.DicsubI("IdxDicDesc",aItemDesc))||$d(^DHCMA.CPW.SD.Stand.DicI("IdxDicDesc",aItemDesc))) {
		Quit aItemDesc
	}
	//如果没匹配上标准字典，再匹配别名字典
	Set AID=$o(^DHCMA.CPW.SD.Stand.DicAliasI("IdxAlias",aItemDesc,0))
	Set Aobj=##class(DHCMA.CPW.SD.Stand.DicAlias).GetObjById(AID)
	Set:$IsObject(Aobj) DicID=Aobj.LinkDicID
	Quit:DicID="" ""
	If (DicID'["||"){
		Set StandDicobj=##class(DHCMA.CPW.SD.Stand.Dic).GetObjById(DicID)
		Set:$IsObject(StandDicobj) OneWord=StandDicobj.DicCatDesc
	}else{
		Set StandSubDicobj=##class(DHCMA.CPW.SD.Stand.Dicsub).GetObjById(DicID)	
		Set:$IsObject(StandSubDicobj) OneWord=StandSubDicobj.DicDesc
	}	
	Quit OneWord
}

/// w ##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetStandDicID("心电图")
ClassMethod GetStandDicID(aItemDesc As %String) As %String
{
	New (aItemDesc)
	Set DicID=""
	//优先通过标准字典取匹配信息
	If ($d(^DHCMA.CPW.SD.Stand.DicsubI("IdxDicDesc",aItemDesc))) {
		Set xDicID=$o(^DHCMA.CPW.SD.Stand.DicsubI("IdxDicDesc",aItemDesc,""),-1)
		Set xDicSubID=$o(^DHCMA.CPW.SD.Stand.DicsubI("IdxDicDesc",aItemDesc,xDicID,""),-1)
		Set DicID=xDicID_"||"_xDicSubID
	}elseif($d(^DHCMA.CPW.SD.Stand.DicI("IdxDicDesc",aItemDesc))){
		Set DicID=$o(^DHCMA.CPW.SD.Stand.DicI("IdxDicDesc",aItemDesc,""),-1)
	}
	//如果没匹配上标准字典，再匹配别名字典
	If (DicID="") {
		Set AID=$o(^DHCMA.CPW.SD.Stand.DicAliasI("IdxAlias",aItemDesc,0))
		Set Aobj=##class(DHCMA.CPW.SD.Stand.DicAlias).GetObjById(AID)
		Set:$IsObject(Aobj) DicID=Aobj.LinkDicID
	}
	Quit DicID
}

/// 通过描述/逻辑公式 匹配标准字典
/// w ##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).MatchStandDicByDesc(23,"15","a:this<20,b:this<=30,c:this<=40,d:this<=50,e:this>50")
ClassMethod MatchStandDicByDesc(aDicTypeID As %String, aResult As %String, aCalExp As %String = "") As %String
{
	New (aDicTypeID,aResult,aCalExp)
	Set MSDret=""
	If (aCalExp'="") {
		//有运算逻辑的项目，默认单选
		Set eLength=$l(aCalExp,","),xret=0
		For eind=1:1:eLength {
			Set subExp	= $p(aCalExp,",",eind)
			Set xcode	= $p(subExp,":",1)	
			Set xexp	= $p(subExp,":",2)
			Set xexp	= $Replace(xexp,"this",""""_aResult_"""")
			Set exp="Set xret=("_xexp_")"
			x exp
			If (xret>0) {
				Set MSDret=	xcode
				Quit
			}
		}
		Quit MSDret
	}else {
		Set xID=""
	 	For {
	 		Set xID	= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDr",aDicTypeID,xID))
	 		Quit:xID=""
		 	//获取值域字典信息
		 	Set DicObj=##class(DHCMA.CPW.SD.Dictionary).GetObjById(xID)
		 	Set DicCode=DicObj.BTCode
			Set DicDesc=DicObj.BTDesc
		 	Set DicKeyInfo=##class(DHCMA.CPW.SD.QCOptionMatchKey).GetKeyInfoByDicId(xID)
		 	If DicKeyInfo="" {
			 	Set:aResult[DicDesc MSDret=MSDret_","_DicCode
			}else{
			 	Set DicKey=$p(DicKeyInfo,"^",1)
			 	Set DicFilter=$p(DicKeyInfo,"^",2)
			 	Set KeyFlg=##Class(DHCMA.CPW.SDS.QCExpressSrv).CheckKeyArea(aResult,DicKey)
			 	Set FilFlg=##Class(DHCMA.CPW.SDS.QCExpressSrv).CheckKeyArea(aResult,DicFilter)
			 	Set:((KeyFlg=1)&&(FilFlg'=1)) MSDret=MSDret_","_DicCode
			}
	 	}
	 	Set:MSDret'="" MSDret=$e(MSDret,2,$l(MSDret))
	}
 	Quit MSDret
}

/// 通过项目值域描述，自动匹配取值
/// w ##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).AutoValByDicDesc(2720552)
ClassMethod AutoValByDicDesc(aEpisodeID, objConfig, aTypeDr) As %String
{
	New (aEpisodeID,objConfig,aTypeDr)
	Set SubFlg=0,return=""
	Set DataSource   = objConfig.DataSource	
	Set SourceField  = objConfig.SourceField	
	Set StandDic     = objConfig.StandDic		 
	Set StandDicSub  = objConfig.StandDicSub	 
	Set GetValTime   = objConfig.GetValTime
	Set CalExp		 = objConfig.CalExp		 
	Set DataFormat	 = objConfig.DataFormat
	Set:$IsObject(StandDicSub) SubFlg=1
	Set ClassName=##class(DHCMA.CPW.SD.StandSrv.SourceSrv).GetDataClass(objConfig.DataSource.%Id(),SubFlg)
	Set SourceID=DataSource.%Id()
 	//按照值域字典描述匹配项目标准字典进行取值
 	Set xID="",ShortDicArr="",OEItemID=""
 	For {
 		Set xID	= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDr",aTypeDr,xID))
 		Quit:xID=""
	 	//获取值域字典信息
	 	Set DicObj=##class(DHCMA.CPW.SD.Dictionary).GetObjById(xID)
	 	Set DicCode=DicObj.BTCode
	 	Set DicDesc=DicObj.BTDesc
	 	Set DicDesc=$tr(DicDesc,"＋","+")
		//根据值域字典 获取标准化字典（值域字典与标准化字典描述一致才能匹配上）
		Set xDicId="",LinkOrder="",ExcuteFlg=""
		If ($d(^DHCMA.CPW.SD.Stand.DicsubI("IdxDicDesc",DicDesc))){
			For {
		 		Set xDicId=$o(^DHCMA.CPW.SD.Stand.DicsubI("IdxDicDesc",DicDesc,xDicId))
		 		Quit:xDicId=""
		 		Set xDicSubId=$o(^DHCMA.CPW.SD.Stand.DicsubI("IdxDicDesc",DicDesc,xDicId,0))
		 		Set objDic=##class(DHCMA.CPW.SD.Stand.Dicsub).GetObjById(xDicId_"||"_xDicSubId)
		 		Continue:'$IsObject(objDic)
		 		Set xSourceID=objDic.Parref.SourceDr.%Id()
		 		Set xStandDic=objDic.Parref.%Id()
		 		//数据源和数据字典过滤，去掉干扰字典项
		 		Continue:(SourceID'="")&&(SourceID'=xSourceID)
		 		Continue:($IsObject(StandDic))&&(StandDic.%Id()'=xStandDic)
		 		Set LinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(xDicId_"||"_xDicSubId)
		 		If (LinkOrder="")&&(ClassName["Lis") {
			 		Set ItemCode=""
			 		Set LinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(xDicId)		
			 		Continue:LinkOrder=""
			 		Set SubDicId=xDicId_"||"_xDicSubId
					Set xItemLinkId=$o(^DHCMA.CPW.SD.Stand.TestCodeLink("IdxDicSub",SubDicId,0))
					Set xObjLink=##class(DHCMA.CPW.SD.Stand.TestCodeLink).GetObjById(xItemLinkId)
					Set:$IsObject(xObjLink) ItemCode=xObjLink.TestCodeDr.BTCode
					Continue:ItemCode=""
			 		Set ExcuteINfo=..GetExcuteResult(aEpisodeID,ClassName,LinkOrder,GetValTime,ItemCode)
			 		Set ExcuteFlg=$p(ExcuteINfo,"^",1)
					Set OEItemID=$p(ExcuteINfo,"^",2)
			 	}else{
				 	Set ExcuteINfo=..GetExcuteResult(aEpisodeID,ClassName,LinkOrder,GetValTime)
					Set ExcuteFlg=$p(ExcuteINfo,"^",1)
					Set OEItemID=$p(ExcuteINfo,"^",2)
				}		 		
				Set:ExcuteFlg=1 return=return_","_DicCode,ShortDicArr=ShortDicArr_$lb($e(DicDesc,1,4))
				//解决联用项字典的问题（阿司匹林，氯吡格雷->阿司匹林＋氯吡格雷）
				If (DicDesc["+") {
					Set DicLen=$l(DicDesc,"+"),JoinFlg=0
					Set:DicLen>1 JoinFlg=1
					For xdicInd=1:1:DicLen{
						Set xdicdesc=$p(DicDesc,"+",xdicInd)
						Set:($lf(ShortDicArr,$e(xdicdesc,1,4))<0) JoinFlg=0
					}
					
					Set:JoinFlg=1 return=DicCode
				}
			}
		}elseIf ($d(^DHCMA.CPW.SD.Stand.DicI("IdxDicDesc",DicDesc))) {
			For {
		 		Set xDicId=$o(^DHCMA.CPW.SD.Stand.DicI("IdxDicDesc",DicDesc,xDicId))
		 		Quit:xDicId=""
		 		Set objDic=##class(DHCMA.CPW.SD.Stand.Dic).GetObjById(xDicId)
		 		Set xSourceID=objDic.SourceDr.%Id()
		 		Continue:(SourceID'="")&&(SourceID'=xSourceID)
		 		Set LinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(xDicId)
		 		Continue:LinkOrder=""
		 		Set ExcuteINfo=..GetExcuteResult(aEpisodeID,ClassName,LinkOrder,GetValTime)
				Set ExcuteFlg=$p(ExcuteINfo,"^",1)
				Set OEItemID=$p(ExcuteINfo,"^",2)
				Set:ExcuteFlg=1 return=return_","_DicCode,ShortDicArr=ShortDicArr_$lb($e(DicDesc,1,4))
				//解决联用项字典的问题（头孢，青霉素->头孢＋青霉素）
				//联合用药只有在本身没关联医嘱才分别找头孢和青霉素两种药的医嘱
				If (DicDesc["+")&&(LinkOrder="") {
					Set DicLen=$l(DicDesc,"+"),JoinFlg=1
					For xdicInd=1:1:DicLen{
						Set xdicdesc=$p(DicDesc,"+",xdicInd)
						Set:($lf(ShortDicArr,$e(xdicdesc,1,4))<0) JoinFlg=0
					}
					Set:JoinFlg=1 return=DicCode
				}
			}
 		}elseIf (DicDesc["+") {
	 		//解决联用项字典的问题（如果联用没维护到项目标准字典）
			Set DicLen=$l(DicDesc,"+"),xCount=0
			For xdicInd=1:1:DicLen{
				Set xdicdesc=$p(DicDesc,"+",xdicInd)
				///将+号连接的字典作为标准字典 组合判断
				Set xDicId=$o(^DHCMA.CPW.SD.Stand.DicsubI("IdxDicDesc",xdicdesc,""),-1)
		 		Quit:xDicId=""
		 		Set xDicSubId=$o(^DHCMA.CPW.SD.Stand.DicsubI("IdxDicDesc",xdicdesc,xDicId,0))
		 		Set objDic=##class(DHCMA.CPW.SD.Stand.Dicsub).GetObjById(xDicId_"||"_xDicSubId)
		 		Continue:'$IsObject(objDic)
		 		Set xSourceID=objDic.Parref.SourceDr.%Id()
		 		Set xStandDic=objDic.Parref.%Id()
		 		//数据源和数据字典过滤，去掉干扰字典项
		 		Continue:(SourceID'="")&&(SourceID'=xSourceID)
		 		Continue:($IsObject(StandDic))&&(StandDic.%Id()'=xStandDic)
		 		Set LinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(xDicId_"||"_xDicSubId)
		 		Continue:LinkOrder=""
		 		Set ExcuteINfo=..GetExcuteResult(aEpisodeID,ClassName,LinkOrder,GetValTime)
				Set ExcuteFlg=$p(ExcuteINfo,"^",1)
				Set OEItemID=$p(ExcuteINfo,"^",2)
				Set:ExcuteFlg=1 xCount=xCount+1
				
			}
			Set:xCount=DicLen return=DicCode	
	 	}elseIf ((DicDesc="是")||(DicDesc="实施")) {
	 		//如果绑定项目为是否，只需要判断存在情况
	 		Set xDicId=""
			Set:$IsObject(objConfig.StandDic) xDicId= objConfig.StandDic.%Id()		 
			Set:$IsObject(objConfig.StandDicSub) xDicId=objConfig.StandDicSub.%Id()
			Set LinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(xDicId)
			Quit:LinkOrder=""
			Set ExcuteINfo=..GetExcuteResult(aEpisodeID,ClassName,LinkOrder,GetValTime)
			Set ExcuteFlg=$p(ExcuteINfo,"^",1)
			Set OEItemID=$p(ExcuteINfo,"^",2)
			Set return="n"
			Set:ExcuteFlg=1 return="y"
			Quit  	;一次判断即可判断是否执行 退出
			
	 	}
 	}
 	Set addInfo=""
	Set:OEItemID'="" addInfo="OE:"_OEItemID
 	Quit return_"^"_addInfo
}

/// 通过项目配置取值输出字段
ClassMethod getItemValByField(aEpisodeID, objConfig As %ObjectIdentity) As %String
{
	New (aEpisodeID,objConfig)
	Set SubFlg=0,return=""
	Set DataSource   = objConfig.DataSource	
	Set SourceField  = objConfig.SourceField	
	Set StandDic     = objConfig.StandDic		 
	Set StandDicSub  = objConfig.StandDicSub	 
	Set GetValTime   = objConfig.GetValTime
	Set CalExp		 = objConfig.CalExp		 
	Set DataFormat	 = objConfig.DataFormat
	Set:$IsObject(StandDicSub) SubFlg=1
	Set ClassName=##class(DHCMA.CPW.SD.StandSrv.SourceSrv).GetDataClass(objConfig.DataSource.%Id(),SubFlg)
	Quit:SourceField="" return
	//非字典项目直接获取输出值，字典项目获取后做值域字典关键字匹配
	Set OEItemID=""
	if (StandDic'="") {
		//2.通过标准字典筛选后，数据源+取值字段直接获取-非字典项目,如：医嘱开始结束日期、报告日期、检查结果
		//检验数据源，字典子项不关联医嘱，走字典项获取对照医嘱信息
		If ($IsObject(StandDicSub)&&(ClassName'["Lis")) {
		 	Set DicSubID=StandDicSub.%Id()
		 	Set LinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(DicSubID)
		 }else{
			Set LinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(StandDic.%Id())
		}
		Set ItemCode=""
		If ($IsObject(StandDicSub))&&(ClassName["Lis"){
			//如果关联了检验的子项，需要传入子项代码进行取值
			Set SubDicId=StandDicSub.%Id()
			Set xItemLinkId=""
			For {
				Set xItemLinkId=$o(^DHCMA.CPW.SD.Stand.TestCodeLink("IdxDicSub",SubDicId,xItemLinkId))
				Quit:xItemLinkId=""
				Set xObjLink=##class(DHCMA.CPW.SD.Stand.TestCodeLink).GetObjById(xItemLinkId)
				Set:$IsObject(xObjLink) ItemCode=ItemCode_xObjLink.TestCodeDr.BTCode_","
			}
		}elseif(($IsObject(StandDicSub))&&(ClassName["Ris")){
			
		}
		//通过关联数据源、关联医嘱、取值时机、检验项目代码，获取精确结果对象
		Set ExcuteINfo=..GetExcuteResult(aEpisodeID,ClassName,LinkOrder,GetValTime,ItemCode,SourceField)
		Set Result=$p(ExcuteINfo,"^",1)
		Set OEItemID=$p(ExcuteINfo,"^",2)
		Set return=Result	
	}elseIf (DataSource'=""){
		Set xStandDic="",LinkOrder=""
		For{
			Set xStandDic=$o(^DHCMA.CPW.SD.Stand.DicI("IdxSource",DataSource.%Id(),xStandDic))
			Quit:xStandDic=""
			If ($IsObject(StandDicSub)&&(ClassName'["Lis")) {
		 	Set DicSubID=StandDicSub.%Id()
		 	Set xLinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(DicSubID)
			}else{
				Set xLinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(xStandDic)
			}
			Set LinkOrder=LinkOrder_"^"_xLinkOrder
		}
		//通过关联数据源、关联医嘱、取值时机，获取精确结果对象
		Set ExcuteINfo=..GetExcuteResult(aEpisodeID,ClassName,LinkOrder,GetValTime,"",SourceField)
		Set Result=$p(ExcuteINfo,"^",1)
		Set OEItemID=$p(ExcuteINfo,"^",2)
		Set return=Result
	}
	Set addInfo=""
	Set:OEItemID'="" addInfo="OE:"_OEItemID
	Quit return_"^"_addInfo
}

/// 通过不同数据源  标准字典/字典子项相关医嘱 采集时机获取对应的执行结果
ClassMethod GetExcuteResult(EpisodeID As %String, ClassName As %String, LinkOrder As %String, GetValTime As DHCMA.CPW.SD.Dictionary, aItemCode As %String = "", aSourceField As %String = "") As %String
{
	New (EpisodeID,ClassName,LinkOrder,GetValTime,aItemCode,aSourceField)
	Set return=""
	Set $zt="GetExcuteResultErr"
	Set ^tmpzgz28=$lb(EpisodeID,ClassName,LinkOrder,GetValTime,aItemCode,aSourceField)
	Quit:(EpisodeID="")||(LinkOrder="")||(ClassName="") return
	Kill tmpSDDataExcuteResultArr 
	//从医嘱记录入
	Set OEItemID=""
	For OrdInd=1:1:$l(LinkOrder,"^") {
		Set EPOrderID=$P(LinkOrder,"^",OrdInd)
		Continue:EPOrderID=""
		Set objEPOrder=##class(DHCMA.Util.EPx.OrdMast).GetObjById(EPOrderID)
		Set ARCMastID=$p(objEPOrder.OID,"!!",1)
		Continue:ARCMastID=""
		Set xRowID=""
		For {
			Set xRowID=$o(^DHCMA.CPW.SD.Data.OrderInfoI("IdxAdmARC",EpisodeID,ARCMastID,xRowID))
			Quit:xRowID=""
			Set objOrder=##class(DHCMA.CPW.SD.Data.OrderInfo).GetObjById(xRowID)
			Set OESttDate=objOrder.OESttDate
			Set OESttTime=objOrder.OESttTime
			Continue:OESttDate=""
			Set OEStatus=objOrder.OEStatus	
			Set OEPriority=objOrder.OEPriority
			Set:OEPriority="" OEPriority="NORM"
			Continue:("CU"[OEStatus)
			Set OEItemID=objOrder.OEItemID
			//取各医嘱的执行记录
			Set OEORDId=$p(OEItemID,"||",1)
			Set SubId=$p(OEItemID,"||",2)
			Set SkinTest=objOrder.SkinTest
			Continue:SkinTest=1  ;皮试医嘱过滤
			
			Set xExcuteID="0"
			For {
				Set xExcuteID=$o(^OEORD(OEORDId,"I",SubId,"X",xExcuteID))
				Quit:xExcuteID=""
				Set ExcuteInfo=$g(^OEORD(OEORDId,"I",SubId,"X",xExcuteID))
				Continue:ExcuteInfo=""
				Set OEStatus=$p(ExcuteInfo,"^",16)
				Set OEExcuteDate=$p(ExcuteInfo,"^",19)
				Set OEExcuteTime=$p(ExcuteInfo,"^",20)
				Continue:OEStatus'="1" ;过滤非执行状态医嘱
				Set tmpSDDataExcuteResultArr(OEPriority,OEExcuteDate,OEExcuteTime)=OEItemID
			}
		}
	}
	Quit:'$d(tmpSDDataExcuteResultArr) return
	//按取值时机和取值数据源  决定返回执行数据对象
	Set GetType="InHosp" //默认取入院首次
 	Set:$IsObject(GetValTime) GetType=GetValTime.BTCode
	Set (OperDateStr,operKey,OperSttDate,OperSttTime,OperEndDate,OperEndTime)=""
	If (GetType["Oper") {
		Set OperDateStr=##Class(DHCMA.CPW.SD.DataSrv.OperationSrv).GetOperDate(EpisodeID,operKey)
		Quit:OperDateStr="" return
		Set OperSttDate=$p(OperDateStr,"^",1)
		Set OperSttDate=##class(DHCMA.Util.IO.FromHisSrv).GetDateHtmlToLogical(OperSttDate)
		Set OperSttTime=$p(OperDateStr,"^",2)
		Set OperSttTime=$zth(OperSttTime)
		Set OperEndDate=$p(OperDateStr,"^",3)
		Set OperEndDate=##class(DHCMA.Util.IO.FromHisSrv).GetDateHtmlToLogical(OperEndDate)
		Set OperEndTime=$p(OperDateStr,"^",4)
		Set OperEndTime=$zth(OperEndTime)
	}
	//获取就诊时间
	Set EpisodeOID=EpisodeID_"!!"_1
	Set AdmObj=##class(DHCMA.Util.EPx.Episode).GetObjByOID(EpisodeOID)
	Set AdmDate=AdmObj.PAAdmDate
	Set AdmTime=AdmObj.PAAdmTime
	Set DischDate=AdmObj.PADischDate
	Set DischTime=AdmObj.PADischTime
	//默认筛选 医嘱日期范围为住院期间
	Set xFDate=AdmDate
	Set xFTime=AdmTime
	Set xTDate=DischDate
	Set xTTime=DischTime
	If (GetType="Emergency"){
		//急诊未处理
	}elseif(GetType="BfOperAnti"){
		//术前,默认手术前0.5-1小时
		Set LogicOperStt=(OperSttDate*24*3600+OperSttTime)
		Set xFDate=(LogicOperStt-(3600))\(24*3600)
		Set xFTime=(LogicOperStt-(3600))#(24*3600)
		Set xTDate=(LogicOperStt-1800)\(24*3600)
		Set xTTime=(LogicOperStt-1800)#(24*3600)
		d GetOrdItem
	}elseif(GetType="InOperAnti"){
		//术中
		Set xFDate=OperSttDate
		Set xFTime=OperSttTime
		Set xTDate=OperEndDate
		Set xTTime=OperEndTime
		d GetOrdItem
	}elseif(GetType="AfOperAnti"){
		//术后默认术后24小时
		Set xFDate=OperEndDate
		Set xFTime=OperEndTime
		Set xTDate=OperEndDate+1
		Set xTTime=OperEndTime
		d GetOrdItem
	}elseif(GetType="AllOper"){
		//围术期
		Set LogicOperStt=(OperSttDate*24*3600+OperSttTime)
		Set xFDate=(LogicOperStt-3600)\(24*3600)
		Set xFTime=(LogicOperStt-3600)#(24*3600)
		Set xTDate=OperEndDate+3
		Set xTTime=OperEndTime
		d GetOrdItem
	}elseif(GetType="LastInHosp"){
		//出院前24小时
		Set xFDate=DischDate-1
		Set xFTime=DischTime
		Set xTDate=DischDate
		Set xTTime=DischTime
		d GetOrdItem
	}elseif(GetType="EMR-Inhos24"){
		//急诊/入院24小时
		Set xFDate=AdmDate
		Set xFTime=AdmTime
		Set xTDate=AdmDate+1
		Set xTTime=AdmTime
		d GetOrdItem
	}elseif(GetType="OutOrder"){
		//出院带药
		d GetOrdItem
	}else{
		//默认入院首次
		d GetOrdItem
	}
	Quit:OEItemID="" return
	//根据数据源类型 返回不同的输出对象
	If (ClassName["OrderInfo")	{
		Set OrdInfoID=$o(^DHCMA.CPW.SD.Data.OrderInfoI("IdxAdmOEItem",EpisodeID,OEItemID,0))
		Set return=##class(DHCMA.CPW.SD.Data.OrderInfo).GetFormatObjById(OrdInfoID)
	}elseif(ClassName["Lis"){
		Set LisInfoID=$o(^DHCMA.CPW.SD.Data.LisInfoI("IdxAdmOEItem",EpisodeID,OEItemID,0))
		Quit:LisInfoID="" return
		If (ClassName["Item") {
			Set return=..GetItemObj(EpisodeID,ClassName,OEItemID,aItemCode)
		}else{
			Set return=##class(DHCMA.CPW.SD.Data.LisInfo).GetFormatObjById(LisInfoID)
		}
	}elseif(ClassName["Ris"){
		Set RisInfoID=$o(^DHCMA.CPW.SD.Data.RisInfoI("IdxAdmOEItem",EpisodeID,OEItemID,0))
		Quit:RisInfoID="" return
		If (ClassName["Item") {
			Set return=..GetItemObj(EpisodeID,ClassName,OEItemID,aItemCode)
		}else{	
			Set return=##class(DHCMA.CPW.SD.Data.RisInfo).GetFormatObjById(RisInfoID)
		}
	}
	If ($IsObject(return)){
		Set result=1 //默认返回值域字典或项目是否执行
		Set:aSourceField'="" result=$property(return,aSourceField) //如果需要输出值，则返回结果
		set return=result
	} 
	Quit return_"^"_OEItemID
	
GetExcuteResultErr
	Quit ""
GetOrdItem
	Set xOEPriority="",OEItemID=""
	For {
		Set xOEPriority=$o(tmpSDDataExcuteResultArr(xOEPriority))
		Quit:xOEPriority=""
		Continue:(GetType="OutOrder")&&(xOEPriority'="OUT")
		Set xDate=""
		For xDate=xFDate:1:xTDate{
			Set xTime=""
			For {
				Set xTime=$o(tmpSDDataExcuteResultArr(xOEPriority,xDate,xTime))	
				Quit:xTime=""
				Continue:(xDate=xFDate)&&(xTime<xFTime)
				Quit:(xDate=xTDate)&&(xTime>xTTime)
				Set OEItemID=$g(tmpSDDataExcuteResultArr(xOEPriority,xDate,xTime))
				Quit
			}
			Quit:OEItemID'=""
		}
		Quit:OEItemID'=""
	}
	Quit OEItemID
}

/// 根据医嘱ID 以及结果项目代码，获取结果值
ClassMethod GetItemObj(aEpisodeID, aClassName, aOEItem, aItemCode) As %Library.ObjectIdentity
{
	New (aEpisodeID,aClassName,aOEItem,aItemCode)
	Set return=""
	Quit:((aEpisodeID="")||(aClassName="")||(aOEItem="")||(aItemCode="")) return
	Set xRowID=""
	For xCodeInd=1:1:$L(aItemCode,",") {
		Set xItemCode=$p(aItemCode,",",xCodeInd)
		Continue:xItemCode=""
		If (aClassName["Lis") {
			For {
				Set xRowID=$o(^DHCMA.CPW.SD.Data.LisInfoI("IdxAdmOEItem",aEpisodeID,aOEItem,xRowID))
				Quit:xRowID=""
				Continue:'$d(^DHCMA.CPW.SD.Data.LisItemInfoI("IdxItemCode",xRowID," "_xItemCode))
				Set xItemID=$o(^DHCMA.CPW.SD.Data.LisItemInfoI("IdxItemCode",xRowID," "_xItemCode,0))
				Set xItemObj=##class(DHCMA.CPW.SD.Data.LisItemInfo).GetObjById(xItemID)
				Set return=xItemObj
			}
		}elseif(aClassName["Ris"){
			For {
				Set xRowID=$o(^DHCMA.CPW.SD.Data.RisInfoI("IdxAdmOEItem",aEpisodeID,aOEItem,xRowID))
				Quit:xRowID=""
				Continue:'$d(^DHCMA.CPW.SD.Data.RisItemInfoI("IdxItemCode",xRowID," "_xItemCode))
				Set xItemID=$o(^DHCMA.CPW.SD.Data.RisItemInfoI("IdxItemCode",xRowID," "_xItemCode,0))
				Set xItemObj=##class(DHCMA.CPW.SD.Data.RisItemInfo).GetObjById(xItemID)
				Set return=xItemObj
			}
		}
	}
	Quit return
}

/// 重置项目数据配置
ClassMethod ResetConfig(aInputStr) As %String
{
	New (aInputStr)
	Set aItemId=$p(aInputStr,"^",1)
	Set aItemDicId=$p(aInputStr,"^",2)
	Set return=""
	Quit:(aItemId="")&&(aItemDicId="")
	If (aItemDicId'="") {
		Set configID=$o(^DHCMA.CPW.SD.QCItemDataConfigI("IdxItemDic",aItemDicId,0))	
	}else{
		Set configID=$o(^DHCMA.CPW.SD.QCItemDataConfigI("IdxItem",aItemId,0))
	}
	Set return=##class(DHCMA.CPW.SD.QCItemDataConfig).DeleteById(configID)
	Quit return
}

/// 获取项目数据配置
/// w ##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetConfigData("1||265^")
ClassMethod GetConfigData(aInputStr) As %String
{
	New (aInputStr)
	Set aItemId=$p(aInputStr,"^",1)
	Set aItemDicId=$p(aInputStr,"^",2)
	Set return=""
	Quit:(aItemId="")&&(aItemDicId="") ""
	If (aItemDicId'="") {
		Set configID=$o(^DHCMA.CPW.SD.QCItemDataConfigI("IdxItemDic",aItemDicId,0))	
	}else{
		Set configID=$o(^DHCMA.CPW.SD.QCItemDataConfigI("IdxItem",aItemId,0))
	}
	Set objConfig=##class(DHCMA.CPW.SD.QCItemDataConfig).GetObjById(configID)
	Quit:'$IsObject(objConfig) return
	Set DataSource   = objConfig.DataSource.%Id()
	Set SourceField  = objConfig.SourceField	
	Set StandDic     = objConfig.StandDic	 
	Set StandDicSub  = objConfig.StandDicSub	 
	Set GetValTime   = objConfig.GetValTime	
	Set CalExp		 = objConfig.CalExp		 
	Set DataFormat	 = objConfig.DataFormat
	Set:$IsObject(StandDic) StandDic=StandDic.%Id()
	Set:$IsObject(StandDicSub) StandDicSub=StandDicSub.%Id()
	Set:$IsObject(GetValTime) GetValTime=GetValTime.%Id()
	Set return=DataSource_"^"_SourceField_"^"_StandDic_"^"_StandDicSub_"^"_GetValTime_"^"_CalExp_"^"_DataFormat
	Quit return
}

/// 导入项目标准化配置信息
/// w ##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).ImportConfigData("")
ClassMethod ImportConfigData(aInputStr) As %String
{
	New (aInputStr)
	Set aQCId		= $p(aInputStr,"^",1)
	Set aItemCode	= $p(aInputStr,"^",2)
	Set aSorceDesc	= $p(aInputStr,"^",3)
	Set aOutField	= $p(aInputStr,"^",4)
	Set aDicDesc	= $p(aInputStr,"^",5)
	Set aDicSubDesc	= $p(aInputStr,"^",6)
	Set aGetTimeDesc= $p(aInputStr,"^",7)
	Set ^tmpzgz617=aInputStr
	Set return=""
	Quit:(aQCId="")||(aItemCode="")||(aSorceDesc="") ""
	Set objQC=##class(DHCMA.CPW.SD.QCEntity).GetObjById(aQCId)
	Set VerID=objQC.BTVersion.%Id()
	Set ID          	= ""
	Set QCItemId		=""
	Set QCItemObj      	= ##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VerID,aQCId,aItemCode)
	Set:$IsObject(QCItemObj) QCItemId=QCItemObj.%Id()
	Quit:QCItemId="" return
	Set SourceId        = ##class(DHCMA.Util.BT.Dictionary).GetDicIDByDesc("SDSource",aSorceDesc)
	Set SourceField     = aOutField
	Set GetValTimeId	= ##class(DHCMA.Util.BT.Dictionary).GetDicIDByDesc("SDItemGetValTime",aGetTimeDesc)
	Set aDicId=""
	Quit:(QCItemId="")||(SourceId="") ""
	If (aDicDesc'="") {
		Set xDicId=""
		For {
			Set xDicId=$o(^DHCMA.CPW.SD.Stand.DicI("IdxDicDesc",aDicDesc,xDicId))
			Quit:xDicId=""
			Set xDicObj=##class(DHCMA.CPW.SD.Stand.Dic).GetObjById(xDicId)
			Set xSourceId=xDicObj.SourceDr.%Id()
			Continue:xSourceId'=SourceId
			Set aDicId=xDicId
			Quit 
		}	
	}
	Set aDicSubId=""
	If (aDicId'="")&&(aDicSubDesc'="") {
		Set xDicSubId=$o(^DHCMA.CPW.SD.Stand.DicsubI("IdxDicDesc",aDicSubDesc,aDicId,""),-1)
		Set aDicSubId=aDicId_"||"_xDicSubId
	}
	Set CalExp			= ""
	Set DataFormat		= ""
	Set aInputStr=ID_$c(1)_QCItemId_$c(1,1)_SourceId_$c(1)_SourceField_$c(1)_aDicId_$c(1)_aDicSubId_$c(1)_GetValTimeId_$c(1)_CalExp_$c(1)_DataFormat
	Set return=##class(DHCMA.CPW.SD.QCItemDataConfig).Update(aInputStr,$c(1))
	Quit return
}

/// 获取所有项目标准化配置信息
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCItemDataConfigSrv","QryAllConfig")
Query QryAllConfig() As %Query(ROWSPEC = "RowID,Code,Desc,Resume,Alias")
{
}

ClassMethod QryAllConfigExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	Set xConfigID=""
 	For {
 		Set xConfigID = $o(^DHCMA.CPW.SD.QCItemDataConfigD(xConfigID))
		Quit:xConfigID=""
		Set objConfig=##class(DHCMA.CPW.SD.QCItemDataConfig).GetObjById(xConfigID)
		Continue:'$IsObject(objConfig)
		Set QCID=objConfig.QCItem.Parref.%Id()
		Set ItemCode=objConfig.QCItem.BTCode
		Set DataSource   = objConfig.DataSource
		Set SourceField  = objConfig.SourceField	
		Set StandDic     = objConfig.StandDic	 
		Set StandDicSub  = objConfig.StandDicSub 
		Set GetValTime   = objConfig.GetValTime
		Set CalExp		 = objConfig.CalExp		 
		Set DataFormat	 = objConfig.DataFormat
		Set:$IsObject(StandDic) StandDic=StandDic.DicCatDesc
		Set:$IsObject(StandDicSub) StandDicSub=StandDicSub.DicDesc
		Set:$IsObject(GetValTime) GetValTime=GetValTime.BTDesc
		Set:$IsObject(DataSource) DataSource=DataSource.BTDesc
		w QCID_"^"_ItemCode_"^"_DataSource_"^"_SourceField_"^"_StandDic_"^"_StandDicSub_"^"_GetValTime_"^"_CalExp_"^"_DataFormat,!	
 	}
	Quit $$$OK
}

ClassMethod QryAllConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAllConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAllConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAllConfigExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取所有项目所属数据源
/// w ##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetItemSourceByID("1||265")
ClassMethod GetItemSourceByID(aItemID As %String) As %String
{
	New (aItemID)
	Set return=""
	Quit:aItemID="" return
	Set ConfigID=$o(^DHCMA.CPW.SD.QCItemDataConfigI("IdxItem",aItemID,0))
	Set objConfig=##class(DHCMA.CPW.SD.QCItemDataConfig).GetObjById(ConfigID)
	If ($IsObject(objConfig)){
	   	//首先获取数据源配置信息中的数据来源
		Set return=objConfig.DataSource.BTDesc
	}else{
		//根据项目标准字典匹配上的数据来源
		Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aItemID)
		If ($IsObject(objItem)) {
			Set aItemDesc=objItem.BTDesc
			Set DicID=##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetStandDicID(aItemDesc)
			Set DicID=$p(DicID,"||",1)
			Set objDic=##class(DHCMA.CPW.SD.Stand.Dic).GetObjById(DicID)
			Set:$IsObject(objDic) return=objDic.DicCatDesc
		}
	}
	Quit return
}

}
