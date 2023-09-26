/// 嵌入式监控的主函数
Class DHCMed.CCService.EmbedCtrl.CoreVM Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// JS调用的嵌入式监控函数
/// 创建者：李阳
/// 创建日期：2013-06-08
/// 参数：
/// EpisodeID：被监控的就诊信息
/// SettingName：配置信息代码，配置中包含所有需要嵌入式监控的主题配置代码。（建议组织方式：比如配置中包含所有监控诊断的主题代码，包含检验的主题代码集合...）
/// %Value:数据指针
/// HospitalID：医院ID
ClassMethod EmbedControl(EpisodeID As %String, SettingName As %String, %Value As %String, Action As %String = "1", HospitalID As %String = "") As %String
{
	n (EpisodeID,SettingName,%Value,Action,HospitalID)
	Set Setting=##Class(DHCMed.SS.Config).GetValueByKeyHosp(SettingName,HospitalID)
	Set ret="{"
	For i=1:1:$l(Setting,"^") {
		Set ConfigCode=$p(Setting,"^",i)
		Continue:ConfigCode=""
		Set tmpRet=..Main(EpisodeID,ConfigCode,%Value,Action)
		Set SubCatList=##class(DHCMed.CCService.EmbedCtrl.ResultService).GetResultSubCatByEpisodeID(ConfigCode,EpisodeID)
		Set:ret'="{" ret=ret_","
		Set ret=ret_ConfigCode_":'"_SubCatList_"'"
	}
	Set ret=ret_"}"
	Quit ret
}

/// 用来进行嵌入式监控的主函数
/// EpisodeID:被监控的就诊信息
/// ConfigCode:需要被监控的主题配置代码。注意：同一个配置代码下的类库应该拥有统一的入参类型
/// Value : 数据指针
/// Action: 1---增加、修改数据  2--删除数据
ClassMethod Main(EpisodeID As %String, ConfigCode As %String, Value As %String, Action As %String) As %String
{
	n (EpisodeID, ConfigCode, Value, Action)
	Set ret=0
	Quit:EpisodeID="" -1
	Quit:ConfigCode="" -2
	Quit:Value="" -4
	Set %Value=$g(Value)
	Set %EpisodeID=EpisodeID
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(ConfigCode)
	Quit:'$IsObject(objConfig) -2
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(objConfig.SubjectCode)
	Quit:'$IsObject(objSubject) -3
	Set aSubjectID=objSubject.%Id()
	
	Set ItemStoreID=$I(^CacheTemp)
	Set SubCatID=""
	For {
		Set SubCatID=$o(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",objConfig.%Id(),SubCatID))
		Quit:SubCatID=""
		Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
		Do objSubCat.%Close()
		Set ItemDic=""
		For {
			Set ItemDic=$o(^DHCMed.CCi("ItemDic",0,"IDSubCatDrIndex",SubCatID,ItemDic))
			Quit:ItemDic=""
			Set SubjectItemID=""
			For {
				Set SubjectItemID=$o(^DHCMed.CCi("SItem",0,"IndexItemDic",objSubject.%Id(),ItemDic,SubjectItemID))
				Quit:SubjectItemID=""
				Set ^CacheTemp(ItemStoreID,"SubjectItem",SubjectItemID)=objSubCat.ISCKeywordID
			}
		}
	}
	
	
	Set ItmID=""
	For {
		Set ItmID=$o(^CacheTemp(ItemStoreID,"SubjectItem",ItmID))
		Quit:ItmID=""
		Set objItm=##class(DHCMed.CC.SubjectItm).GetObjById(ItmID)
		Continue:'$IsObject(objItm)
		Do objItm.%Close()
		Set objDic=##class(DHCMed.CC.ItemDic).GetObjById(objItm.ItemDic)
		Continue:'$IsObject(objDic)
		;w "Exam Subject Item ID:"_ItmID,!
		Set %ExtraData=$lb("")
		Set %ExtraDataCnt=0
		Set %ErrorData=$lb("")
		Set %ErrorDataCnt=0
		Set exp=##class(DHCMed.CCService.AutoProcess.ExpEvaluation).EvaExpression(objDic.IDExpression)
		Set expResult=##class(DHCMed.CCService.AutoProcess.CoreLib).RunExpression($li(exp,2))
		If $li(expResult,1)="OK" {
				If $li(expResult,2)>0 {
					For indData=1:1:$ListLength(%ExtraData) {
						Set itm=$lg(%ExtraData,indData)
						Continue:itm=""
						
						//按照时间段过滤,非当前时间段的监控结果,过滤掉
						Set ActDate=$p(itm,$c(3),2)
						Set OldResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexActDateEpisodeID",ActDate,%EpisodeID,ItmID," "_$p(itm,$c(3),5),""))
						
						if (Action=1) {
							Set num=$i(^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+ActDate,3),"CtlPaadmCnt"))
						
							//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
							Set aInput=""
							Set $p(aInput,$c(1),1)=OldResultID             // ID
							Set $p(aInput,$c(1),2)=%EpisodeID              // 就诊号
							Set $p(aInput,$c(1),3)=+$h                    // 记录日期
							Set $p(aInput,$c(1),4)=ItmID                  // 监控项目ID
							Set:$p(itm,$c(3),2)["-" $p(itm,$c(3),2)=$zdh($p(itm,$c(3),2),3)
							Set:$p(itm,$c(3),2)["/" $p(itm,$c(3),2)=$zdh($p(itm,$c(3),2),4)
							Set $p(aInput,$c(1),5)=$p(itm,$c(3),2)        // 日期
							Set:$p(itm,$c(3),3)[":" $p(itm,$c(3),3)=$zth($p(itm,$c(3),3),1)
							Set $p(aInput,$c(1),6)=$p(itm,$c(3),3)        // 时间
							Set $p(aInput,$c(1),7)=$p(itm,$c(3),1)        // 摘要信息，用于页面展现
							Set $p(aInput,$c(1),8)=$p(itm,$c(3),4)        // 数据值
							Set $p(aInput,$c(1),9)=$p(itm,$c(3),5)        // 业务数据指针
							Set $p(aInput,$c(1),10)=$p(itm,$c(3),6)       // 操作人员指针
							Set $p(aInput,$c(1),11)=$p(itm,$c(3),7)       // 自定义数据项
							Set $p(aInput,$c(1),12)=objItm.SubjectID     // 主题ID
							Set $p(aInput,$c(1),13)=objItm.Score         // 分数
							Set $p(aInput,$c(1),14)=objItm.IsAbsolute    // 绝对项目
							Set $p(aInput,$c(1),15)=$g(^CacheTemp(ItemStoreID,"SubjectItem",ItmID))       // 关键字
							Set $p(aInput,$c(1),16)=objItm.IsSensitive   // 是否敏感性条件
							Set $p(aInput,$c(1),17)=objItm.IsSpecificity // 是否特异性项目
						
							//存储监控结果
							Set tmpID=##class(DHCMed.CC.CtlResult).Update(aInput,$c(1))
							If tmpID<0 {
								Set error="保存监控结果错误,ErrCode="_tmpID_",Input="_aInput
								Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h, $p($h,",",2),Paadm,objItm.SubjectID,objItm.%Id(),error)
							}
							;w "CtlResult:"_tmpID,!
						}
						else
						{
							;w "OldResultID:"_OldResultID,!
							d:OldResultID'="" ##class(DHCMed.CC.CtlResult).%DeleteId(OldResultID)
						}
						Set ret=ret+1
					}
				}			
		}Else {
			//记录错误日志
			;b //Error
			Set error="表达式:"_objDic.IDExpression_";错误信息:"_$li(expResult,3)
			Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h, $p($h,",",2),%EpisodeID,objItm.SubjectID,objItm.%Id(),error)
		}
	
	}
	Kill ^CacheTemp(ItemStoreID,"SubjectItem")
	Quit ret
}

ClassMethod DeleteResult(EpisodeID As %String, ConfigCode As %String, DataValue As %String)
{
	n (EpisodeID, ConfigCode, DataValue)
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(ConfigCode)
	Quit:'$IsObject(objConfig) -2
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(objConfig.SubjectCode)
	Quit:'$IsObject(objSubject) -3
	Set aSubjectID=objSubject.%Id()
}

/// w ##class(DHCMed.CCService.EmbedCtrl.CoreVM).Test(2)
ClassMethod Test(Action)
{
	W ##class(DHCMed.CCService.EmbedCtrl.CoreVM).EmbedControl(345,"CCEmbedCtrlSubjectConfig","398||7",Action)
	w ##class(DHCMed.CCService.EmbedCtrl.ResultService).GetResultSubCatByEpisodeID("EPDCC",398)
	Quit ""
}

}
