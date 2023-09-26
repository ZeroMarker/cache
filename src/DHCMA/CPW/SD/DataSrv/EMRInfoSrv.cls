/// 电子病历信息服务类
Class DHCMA.CPW.SD.DataSrv.EMRInfoSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// s a=##class(DHCMA.CPW.SD.DataSrv.EMRInfoSrv).SynEMRDataByAdm(315)
ClassMethod SynEMRDataByAdm(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:aEpisodeID="" return
	Set $zt="SynEMRDataByAdmErr"
	Set arrEmrCode=##class(%ListOfDataTypes).%New()
	Set SourceID=##class(DHCMA.Util.BT.Dictionary).GetDicIDByDesc("SDSource","电子病历")
	If (SourceID="") {
		Set EmrCodeStr=##class(DHCHAI.BT.Config).GetValByCode("DPEmrDailyCourseCode","")	//日常病程
		Set EmrCodeStr2=##class(DHCHAI.BT.Config).GetValByCode("DPEmrFirstCourseCode","")	//首程（病例特点、初步诊断、诊断依据）
		Set EmrCodeStr3=##class(DHCHAI.BT.Config).GetValByCode("DPEmrAdmDiagnosCode","")	//入院记录（初步诊断、鉴别诊断）
		Set EmrCodeStr4=##class(DHCHAI.BT.Config).GetValByCode("DPEmrDisDiagnosCode","")	//出院记录（出院诊断）
		Set EmrCodesList=$lb("日常病程"_$c(1)_EmrCodeStr,"首次病程"_$c(1)_EmrCodeStr2,"入院记录"_$c(1)_EmrCodeStr3,"出院记录"_$c(1)_EmrCodeStr4)
	}else {
		Set xRowID="",TmpList=""
		For { 
			Set xRowID	= $o(^DHCMA.CPW.SD.Stand.DicI("IdxSource",SourceID,xRowID))
		 	Quit:xRowID=""
		 	Set xobj	= ##class(DHCMA.CPW.SD.Stand.Dic).GetObjById(xRowID)
		 	Continue:'$IsObject(xobj)
		 	Set DocType=xobj.DicCatDesc
		 	Set EmrCodeStr=xobj.Resume
		 	Continue:EmrCodeStr=""
		 	Set TmpList=TmpList_$lb(DocType_$c(1)_EmrCodeStr)
		}
		Set EmrCodesList=TmpList
	}
	Set Count=0
	For indList=1:1:$ll(EmrCodesList){
		Set DocType=""
		Set EmrMsgStr=$listget(EmrCodesList,indList)
		Set DocType=$p(EmrMsgStr,$c(1),1)
		Set EmrCodeStr=$p(EmrMsgStr,$c(1),2)
		Continue:EmrCodeStr=""
		For indEC=1:1:$l(EmrCodeStr,",") {
			Set tEmrCodeStr=$p(EmrCodeStr,",",indEC)
			Continue:tEmrCodeStr=""
			Set tEmrCodeStr=$tr(tEmrCodeStr,"：",":")
			Set TitleSub=$p(tEmrCodeStr,":",1)
			Set EmrCodes=$p(tEmrCodeStr,":",2)
			Continue:(TitleSub="")||(EmrCodes="")
			Set tEmrCodeStr=DocType_"|"_TitleSub_":"_EmrCodes
			Do arrEmrCode.Insert(tEmrCodeStr)
		}
	}
	For indEC=1:1:arrEmrCode.Count() {
		Set tEmrCodeStr=arrEmrCode.GetAt(indEC)
		Continue:tEmrCodeStr=""
		Set DocType=$p(tEmrCodeStr,":",1)
		Set EmrCodes=$p(tEmrCodeStr,":",2)
		Set DocTypeDesc=$p(DocType,"|",1)
		Set DocTitleSub=$p(DocType,"|",2)
		Continue:(DocTypeDesc="")||(DocTitleSub="")||(EmrCodes="")

		For indDT=1:1:$l(EmrCodes,"|") {
			Set tEmrCode=$p(EmrCodes,"|",indDT)
			Continue:tEmrCode=""
		    Set DiagnosCode = $p(tEmrCode,"#",1)
			Set arr=..GetDataByGlossary(aEpisodeID,DiagnosCode,aDateFrom,aDateTo)
			Set xInstanceID=""
			For	{
			    Set value=arr.GetNext(.xInstanceID)
			    Quit:xInstanceID=""
				Set XCode    	= $p(xInstanceID,",",1)      // 记录索引码 xInstanceID=InstanceID_","_GlossaryCode
				Set DocTitle    = $p(value,$c(1),1)          // 标题
				Set DocDate     = $p(value,$c(1),2)          // 文档日期
				Set ActDate     = $p(value,$c(1),2)          // 发生日期
				Set ActTime     = $p(value,$c(1),3)          // 发生时间
				Set ActUserID   = $p(value,$c(1),6)          // 填写医生
				Set ActUserCode = $p(value,$c(1),7)          // 医生代码
				Set ActUserDesc = $p(value,$c(1),8)          // 医生名称
				Set GlossaryCode= $p(value,$c(1),9)          // 术语集代码
				Set GlossaryDesc= $p(value,$c(1),10)         // 术语集名称
				Set DocContent  = $p(value,$c(1),11)         // 病程内容
				Continue:GlossaryCode=""
				//Set DocContent  = $tr(DocContent," ","")
				//Set DocContent  = $tr(DocContent,$c(10),"")
				
				Set IsActive=1                               // 是否有效
				Set:DocContent="" IsActive=0
				If DocTypeDesc["日常病程" {
					Set:$l(DocContent)<10 IsActive=0 //少于10个字符算无效
				} Else {
					Set:$l(DocContent)<1 IsActive=0 //少于1个字符算无效
				}
				//处理字符串超长问题 默认最长8000
				If $l(DocContent)>8000 {
					Set DocContent=$e(DocContent,1,8000)
				}
				Set InputStr = ""
				Set InputStr = InputStr_$c(3)_aEpisodeID
				Set InputStr = InputStr_$c(3)_DocTypeDesc          // 文档类型
				Set InputStr = InputStr_$c(3)_DocTitle             // 文档标题
				Set InputStr = InputStr_$c(3)_DocDate              // 文档日期
				Set InputStr = InputStr_$c(3)_DocContent		   // 文档内容
				Set InputStr = InputStr_$c(3)_ActDate			   // 发生日期
				Set InputStr = InputStr_$c(3)_ActTime              // 发生时间
				Set InputStr = InputStr_$c(3)_ActUserID_"|"_ActUserCode_"|"_ActUserDesc  // 填写医生
				Set InputStr = InputStr_$c(3)_IsActive        	   // 有效标志
				Set InputStr = InputStr_$c(3)_+$h                  // 更新日期
				Set InputStr = InputStr_$c(3)_+$p($h,",",2)        // 更新时间
				Set InputStr = InputStr_$c(3)_GlossaryDesc         // 文档子标题(术语集名称)
				Set InputStr = InputStr_$c(3)_GlossaryCode         // 术语集代码
				
				//将解析后的文本内容进行存储
				Set AnalyDocContent=##Class(DHCMA.CPW.SDS.IO.ToDocService).AnalyDHC(DocContent)
				
				Set InputStr = InputStr_$c(3)_AnalyDocContent      // 解析后的文本
				Set EmrRecordDr = ##class(DHCMA.CPW.SD.Data.EmrRecord).Update(InputStr,$c(3))
				If (+EmrRecordDr)<0 {
					//记录错误日志
					Set ErrClass  = "DHCMA.CPW.SD.Data.EmrRecord"
					Set ErrMethod = "Update"
					Set $p(InputStr,$c(3),6)="字符串超长-详细内容略"  //字符串超长
					Set ErrArgStr = $lb(InputStr,$c(3))				}
					Quit:(+EmrRecordDr)<1
					Set Count = Count+1
			}
		}
	}

    Set return=Count
    Quit return
    
SynEMRDataByAdmErr
	Set return="-999^"_$ZError
	Quit return
}

/// Description:  通过就诊号+术语集获取病历信息
///               术语集单元：EPRmeta.Glossary对应^DHCEPRM.GlossaryI
///               术语集目录：EPRmeta.GlossaryCategory对应^DHCEPRM.GlossaryCategoryI
/// Input：       aEpisodeID:就诊号 
///               aGlossary:术语集标识符
/// Output        术语集对应该电子病历单元值
///               类型：数组 
///               格式：[{"实例ID","值"},{"实例ID","值"},...]
///               唯一模板为单值，可重复模板可能有多值
/// Set arr=##Class(DHCMA.CPW.SD.DataSrv.EMRInfoSrv).GetDataByGlossary(27109587,"HDSD00.14.139")
/// Do $system.OBJ.Dump(arr)
ClassMethod GetDataByGlossary(aEpisodeID As %String, aGlossary As %String, aDateFrom As %String = "", aDateTo As %String = "") As %ArrayOfDataTypes
{
	New (aEpisodeID,aGlossary,aDateFrom,aDateTo)
	Set return=##class(%ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="")||(aGlossary="") return
	//Quit:(aDateFrom="")||(aDateTo="") return
	Set arr=##Class(%ArrayOfDataTypes).%New()
	If $l(aGlossary)<13 {
		Set xGrpGlossary=""
		For {
			Set xGrpGlossary=$o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID",xGrpGlossary))
			Quit:xGrpGlossary=""
			
			Set GrpGlossary=$e(xGrpGlossary,2,$l(xGrpGlossary))
			Continue:$e(GrpGlossary,1,$l(aGlossary))'=aGlossary  //代码不匹配
			Continue:$l(GrpGlossary)<12 //非根目录退出
			
			//Set arr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(AEpisodeID,AInternalID)
			Set arrGrp=##Class(EMRservice.BIEMRService).GetDataByGlossaryCategory(aEpisodeID,GrpGlossary)
			Set xGlossary=""
			For	{
			    Set arr=arrGrp.GetNext(.xGlossary)
			    Quit:xGlossary=""
			    
			    Set tGrpGlossary=$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_xGlossary,0))
				Continue:tGrpGlossary=""
				Set tGlossaryID=$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_xGlossary,tGrpGlossary,0))
				Continue:tGlossaryID=""
				
				Set GlossaryDesc=$listget($g(^DHCEPRM.GlossaryD(tGlossaryID)),9)
				Set GlossaryCode=$listget($g(^DHCEPRM.GlossaryD(tGlossaryID)),15)
				Continue:(GlossaryDesc="")||(GlossaryCode="")
				
				Do GetInstanceData
			}
			
			Continue:return.Count()>0
			
			//以下为协和特殊处理程序
			Set xGrpGlossaryID=$o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID",xGrpGlossary,0))
			Continue:xGrpGlossaryID=""
			Set xGlossaryID=""
			For {
				Set xGlossaryID=$o(^DHCEPRM.GlossaryI("IdxCategoryID"," "_xGrpGlossaryID,xGlossaryID))
				Quit:xGlossaryID=""
				
				Set GlossaryDesc=$listget($g(^DHCEPRM.GlossaryD(xGlossaryID)),9)
				Set GlossaryCode=$listget($g(^DHCEPRM.GlossaryD(xGlossaryID)),15)
				Continue:(GlossaryDesc="")||(GlossaryCode="")
				
				Set arr=..GetDataByGlossaryXH(aEpisodeID,GlossaryCode)
				Do GetInstanceData
			}
		}
	} Else {
		Set tGrpGlossary=$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_aGlossary,0))
		Quit:tGrpGlossary="" return
		Set tGlossaryID=$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_aGlossary,tGrpGlossary,0))
		Quit:tGlossaryID="" return
		
		Set GlossaryDesc=$listget($g(^DHCEPRM.GlossaryD(tGlossaryID)),9)
		Set GlossaryCode=$listget($g(^DHCEPRM.GlossaryD(tGlossaryID)),15)
		Quit:(GlossaryDesc="")||(GlossaryCode="") return
		
		//Set arr=##Class(EPRservice.BOScatterData).GetDataByGlossary(AEpisodeID,AInternalID)
		Set arr=##Class(EMRservice.BIEMRService).GetDataByGlossary(aEpisodeID,GlossaryCode)
		Do GetInstanceData
		Quit:arr.Count()>0 return
		
		//以下为协和特殊处理程序
		Set arr=..GetDataByGlossaryXH(aEpisodeID,GlossaryCode)
		Do GetInstanceData
	}
	Quit return
	
GetInstanceData
	Set xInstanceID=""
	For	{
	    Set value=arr.GetNext(.xInstanceID)
	    Quit:xInstanceID=""
		
	    Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(xInstanceID)
		Continue:'$IsObject(objInstance)
		If objInstance'="" Do objInstance.%Close()
		
		Set Title       = objInstance.Title          // 标题
		Set HappenDate  = objInstance.HappenDate     // 发生日期
		Set HappenTime  = objInstance.HappenTime     // 发生时间
		Set ModifyDate	= objInstance.ModifyDate     // 修改日期
		Set ModifyTime	= objInstance.ModifyTime     // 修改时间
		Set ModifyUser  = objInstance.ModifyUser     // 修改医生
		Set ModifyUserCode="",ModifyUserDesc=""
		Set:ModifyUser'="" ModifyUserCode=$p($g(^SSU("SSUSR",ModifyUser)),"^",1)
		Set:ModifyUser'="" ModifyUserDesc=$p($g(^SSU("SSUSR",ModifyUser)),"^",2)
		Continue:(aDateFrom'="")&(ModifyDate<aDateFrom)
		Continue:(aDateTo'="")&(ModifyDate>aDateTo)
		
		Set value=$tr(value,$c(1),"") //替换$c(1)
		Set Title=$tr(Title,$c(1),"") //替换$c(1)
		Set ModifyUserCode=$tr(ModifyUserCode,$c(1),"") //替换$c(1)
		Set ModifyUserDesc=$tr(ModifyUserDesc,$c(1),"") //替换$c(1)
		
		Set InstanceData=Title
		_$c(1)_HappenDate_$c(1)_HappenTime
		_$c(1)_ModifyDate_$c(1)_ModifyTime
		_$c(1)_ModifyUser_$c(1)_ModifyUserCode_$c(1)_ModifyUserDesc
		_$c(1)_GlossaryCode_$c(1)_GlossaryDesc
		_$c(1)_value
		
		Set InstanceData=$tr(InstanceData,$c(0),"") //替换$c(0)
		Do return.SetAt(InstanceData,xInstanceID_","_GlossaryCode)
	}
	Quit
}

/// Desc:       根据术语项代码取电子病历数据
/// Input:      AEpisodeID 就诊号
///             AGlossaryInternalID 术语项代码
/// Output:     w ##Class(DHCMA.CPW.SD.DataSrv.EMRInfoSrv).GetDataByGlossaryXH(76,"S.01.01")
ClassMethod GetDataByGlossaryXH(AEpisodeID As %String, AInternalID As %String) As %ArrayOfDataTypes
{
	New (AEpisodeID,AInternalID)
	Set result=##Class(%ArrayOfDataTypes).%New()
	Quit:((AEpisodeID = "")||(AInternalID = "")) result
	
	Set xCategoryID=""
	For {
		Set xCategoryID=$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_$zcvt(AInternalID,"U"),xCategoryID))
		Quit:xCategoryID=""
		Quit:(result.Count()>0)
		
		Set xGlossaryID=""
		For {
			Set xGlossaryID=$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_$zcvt(AInternalID,"U"),xCategoryID,xGlossaryID))
			Quit:xGlossaryID=""
			
			Set result=##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryID(AEpisodeID,xGlossaryID)
			Quit:(result.Count()>0)
		}
	}
	Quit result
}

/// Desc:       根据就诊号和病历类型获取电子病历数据
/// Input:      aEpisodeID	就诊号
///             aDocType	病历类型
/// 				aItemID		质控项目ID
/// Output:     w ##Class(DHCMA.CPW.SD.DataSrv.EMRInfoSrv).GetDocContent(185,"日常病程","1||292")
ClassMethod GetDocContent(aEpisodeID As %String, aDocType As %String, aItemID As %String = "") As %String
{
	New (aEpisodeID,aDocType,aItemID)
	Set ^tmpzgz1011=$lb(aEpisodeID,aDocType,aItemID)
	
	If (aItemID'="") {
		Set aTypeDr=$o(^DHCMA.CPW.SD.DicTypeI("IdxofItemDR",aItemID,0))
		//按照值域字典描述匹配项目标准字典进行取值
		Set dicStartIndx=1
	 	Set xID="",DicCodeArr="",DicStr=""
	 	k DicAnalyDHCArr,tDicIndxArr
	 	If (aTypeDr'="") {
	 	For {
		 		Set xID	= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDr",aTypeDr,xID))
		 		Quit:xID=""
			 	//获取值域字典信息
			 	Set DicObj=##class(DHCMA.CPW.SD.Dictionary).GetObjById(xID)
			 	Set DicCode=DicObj.BTCode
			 	Set DicDesc=DicObj.BTDesc
			 	Continue:(DicDesc["请选择")||(DicDesc="")
			 	//存储每个字典在文本中的位置信息
			 	Set tDicIndxArr(DicCode)=$lb(dicStartIndx,dicStartIndx+$l(DicDesc))
			 	Set DicStr=DicStr_DicDesc_"。"
			 	Set dicStartIndx=$l(DicStr)+1
		 	}
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
			Set xCode="",DicCode=""
			For {
				Set xCode=$o(tDicIndxArr(xCode))
				Quit:xCode=""
				Set CodeIndx=$g(tDicIndxArr(xCode))
				Set endIndx=$lg(CodeIndx,2)
				Set:TargeStart<endIndx DicCode=xCode
				Quit:DicCode'=""
			}
			//以归一词、项目code 、结果类型为索引 存储解析结果
			Set DicAnalyDHCArr(FormalWord,ResultType,DicCode)=""
		}
	}
	Set Count=0,Content="",xsubText=""
	Set xRowID="",OutContent=""
	For {
		Set xRowID=$o(^DHCMA.CPW.SD.Data.EmrRecordI("IndexAdmDocType",aEpisodeID,aDocType,xRowID))
		Quit:xRowID=""
		Set xEmrobj=##class(DHCMA.CPW.SD.Data.EmrRecord).GetObjById(xRowID)	
		Continue:'$IsObject(xEmrobj)
		Set Count=Count+1
		Set DocDate=xEmrobj.DocDate
		Set DocDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DocDate)
		Set ActUser=xEmrobj.ActUser
		Set UserName=$p(ActUser,"|",3)
		Set xContent=xEmrobj.AnalyDocContent
		Set Content=xEmrobj.DocContent
		If (xContent="") {
			//对Content内容进行语义分析标记
			Set xobj=##class(DHCMA.CPW.SD.Data.EmrRecord).%OpenId(xRowID)
			Set xContent=##Class(DHCMA.CPW.SDS.IO.ToDocService).AnalyDHC(Content)
			Set xobj.AnalyDocContent=xContent
			Set sc=xobj.%Save()
		}
		
		Set xFlgLen=0  //标记符长度
		For xind=1:1:$l(xContent,$c(1)) {
			Set subContent=$p(xContent,$c(1),xind)
			Set xIndexStr=$p(subContent,$c(2),7)
			Set ResultType=$p(subContent,$c(2),2)
			Set OneWord=$p(subContent,$c(2),1)	
			Set subText=$p(subContent,$c(2),3)
			Set FormalWord=$p(subContent,$c(2),8)
			Continue:OneWord="吐"
			Continue:FormalWord=""
			If $d(DicAnalyDHCArr(FormalWord)) {
				Set xResultType=$o(DicAnalyDHCArr(FormalWord,""),-1)
				Continue:(ResultType["-")&&(xResultType'["-") //阴性症状不一致，过滤
				For yindx=1:2:$l(xIndexStr,"^") {
					Set TargeStart=$p(xIndexStr,"^",yindx)
					Continue:TargeStart=""
					Set TargeEnd=$p(xIndexStr,"^",yindx+1)
					Set $e(Content,TargeStart+xFlgLen+1,TargeStart+xFlgLen+1)=$c(3)_$e(Content,TargeStart+xFlgLen+1,TargeStart+xFlgLen+1)
					Set $e(Content,TargeEnd+xFlgLen+2,TargeEnd+xFlgLen+2)=$e(Content,TargeEnd+xFlgLen+2,TargeEnd+xFlgLen+2)_$c(4)
					Set xFlgLen=xFlgLen+2
					Continue:xsubText[subText
					Set:xsubText'="" xsubText=xsubText_$c(10)_subText
					Set:xsubText="" xsubText=subText
					
				}
			}
				
		}
		Set Content=$Replace(Content,$c(3),"<span style=""background-color:orange"">")
		Set Content=$Replace(Content,$c(4),"</span>")
		//End
		Set OutContent=OutContent_"<div id=""DocID:"_xRowID_"""><h3>"_DocDate_"&nbsp;&nbsp;&nbsp;&nbsp;"_UserName_"</h3><br>&nbsp;&nbsp;&nbsp;&nbsp;"_Content_"</div>"
	}
	Set:OutContent="" OutContent="暂无病历内容"
	Set return=aDocType_"<span style=""font-weight:bold"">&nbsp;"_Count_"&nbsp;</span>份"_$c(1)_OutContent_$c(1)_xsubText
	Quit return
}

}
