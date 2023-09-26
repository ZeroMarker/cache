/// 名称: DHCHAI.DI.DIO.FromEmrNewSrv
/// 描述: 东华医为电子病历数据接口（只有三版EMR有效）
/// 编写者：zhufei
/// 编写日期: 2020-09-27
Class DHCHAI.DI.DIO.FromEmrNewSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2020-09-27
/// Description:  通过就诊号+术语集获取病历信息
///               术语集单元：EPRmeta.Glossary对应^DHCEPRM.GlossaryI
///               术语集目录：EPRmeta.GlossaryCategory对应^DHCEPRM.GlossaryCategoryI
/// Input：       aEpisodeID:就诊号 
///               aGlossary:术语集标识符
/// Output        术语集对应该电子病历单元值
///               类型：数组 
///               格式：[{"实例ID","值"},{"实例ID","值"},...]
///               唯一模板为单值，可重复模板可能有多值
/// Set arr=##Class(DHCHAI.DI.DIO.FromEmrNewSrv).GetDataByGlossaryX(63377,"HDSD00.14.139")
/// Do $system.OBJ.Dump(arr)
ClassMethod GetDataByGlossaryX(aEpisodeID As %String, aGlossary As %String, aDateFrom As %String = "", aDateTo As %String = "") As %ArrayOfDataTypes
{
	New (aEpisodeID,aGlossary,aDateFrom,aDateTo)
	Set return=##class(%ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="")||(aGlossary="") return
	//Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	
	Set arr=##Class(%ArrayOfDataTypes).%New()
	If $l(aGlossary)<13 {
		Set xGrpGlossary=""
		For {
			Set xGrpGlossary=$o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID",xGrpGlossary))
			Quit:xGrpGlossary=""
			
			Set GrpGlossary=$e(xGrpGlossary,2,$l(xGrpGlossary))
			Continue:$e(GrpGlossary,1,$l(aGlossary))'=aGlossary  //代码不匹配
			Continue:$l(GrpGlossary)<12 //非根目录退出
			
			Set xGrpGlossaryID=$o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID",xGrpGlossary,0))
			Continue:xGrpGlossaryID=""
			Set xGlossaryID=""
			For {
				Set xGlossaryID=$o(^DHCEPRM.GlossaryI("IdxCategoryID"," "_xGrpGlossaryID,xGlossaryID))
				Quit:xGlossaryID=""
				
				Set GlossaryDesc=$listget($g(^DHCEPRM.GlossaryD(xGlossaryID)),9)
				Set GlossaryCode=$listget($g(^DHCEPRM.GlossaryD(xGlossaryID)),15)
				Continue:(GlossaryDesc="")||(GlossaryCode="")
				
				//Set arr=##Class(EPRservice.BOScatterData).GetDataByGlossary(AEpisodeID,AInternalID)
				//Set arr=##Class(EMRservice.BIEMRService).GetDataByGlossary(aEpisodeID,GlossaryCode)
				Set arr=..GetDataByGlossary(aEpisodeID,GlossaryCode,aDateFrom,aDateTo)
				
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
		Set arr=..GetDataByGlossary(aEpisodeID,GlossaryCode,aDateFrom,aDateTo)
		
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
		Set CreateDate  = objInstance.CreateDate     // 创建日期
		Set CreateTime  = objInstance.CreateTime     // 创建时间
		Set HappenDate  = objInstance.HappenDate     // 发生日期
		Set HappenTime  = objInstance.HappenTime     // 发生时间
		Set ModifyDate	= objInstance.ModifyDate     // 修改日期
		Set ModifyTime	= objInstance.ModifyTime     // 修改时间
		Set ModifyUser  = objInstance.ModifyUser     // 修改医生
		Set ModifyUserCode="",ModifyUserDesc=""
		Set:ModifyUser'="" ModifyUserCode=$p($g(^SSU("SSUSR",ModifyUser)),"^",1)
		Set:ModifyUser'="" ModifyUserDesc=$p($g(^SSU("SSUSR",ModifyUser)),"^",2)
		Continue:(aDateFrom'="")&((ModifyDate<aDateFrom)&&(CreateDate<aDateFrom))
		Continue:(aDateTo'="")&((ModifyDate>aDateTo)&&(CreateDate>aDateTo))
		
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

/// Creator:    zhufei
/// CreateDate: 2020-09-27
/// Desc:       根据术语项代码取电子病历数据
/// Input:      AEpisodeID 就诊号
///             AInternalID 术语项代码
/// w ##Class(DHCHAI.DI.DIO.FromEmrNewSrv).GetDataByGlossary(76,"S.01.01")
ClassMethod GetDataByGlossary(aEpisodeID As %String, aGlossaryCode As %String, aDateFrom As %String, aDateTo As %String) As %ArrayOfDataTypes
{
	New (aEpisodeID,aGlossaryCode,aDateFrom,aDateTo)
	Set result=##Class(%ArrayOfDataTypes).%New()
	Quit:((aEpisodeID = "")||(aGlossaryCode = "")) result
	
	If $d(^DHCEPRM.GlossaryI("IdxGlossaryID"," "_$zcvt(aGlossaryCode,"U"))){
		Set xGlossaryID=""
		For {
			Set xGlossaryID=$o(^DHCEPRM.GlossaryI("IdxGlossaryID"," "_$zcvt(aGlossaryCode,"U"),xGlossaryID))
			Quit:xGlossaryID=""
			
			//Set result=##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryID(76,1029)
			Set result=..GetDataByGlossaryID(aEpisodeID,xGlossaryID,aDateFrom,aDateTo)
			
			Quit:(result.Count()>0)
		}
	} Else {
		//协和 术语集配置与其他项目不一样
		Set xCategoryID=""
		For {
			Set xCategoryID=$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_$zcvt(aGlossaryCode,"U"),xCategoryID))
			Quit:xCategoryID=""
			Quit:(result.Count()>0)
			
			Set xGlossaryID=""
			For {
				Set xGlossaryID=$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_$zcvt(aGlossaryCode,"U"),xCategoryID,xGlossaryID))
				Quit:xGlossaryID=""
				
				//Set result=##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryID(aEpisodeID,xGlossaryID)
				Set result=..GetDataByGlossaryID(aEpisodeID,xGlossaryID,aDateFrom,aDateTo)
				Quit:(result.Count()>0)
			}
		}
	}
	Quit result
}

/// Creator:    zhufei
/// CreateDate: 2020-09-27
/// Desc:       根据取术语项ID取病历数据
/// Input:      AEpisodeID 就诊号
///             AGlossaryID 术语代码rowID
/// w ##Class(DHCHAI.DI.DIO.FromEmrNewSrv).GetDataByGlossaryID(76,1029)
ClassMethod GetDataByGlossaryID(aEpisodeID As %String, aGlossaryID As %String, aDateFrom As %String, aDateTo As %String) As %ArrayOfDataTypes
{
	New (aEpisodeID,aGlossaryID,aDateFrom,aDateTo)
	Set result=##Class(%ArrayOfDataTypes).%New()
	Quit:((aEpisodeID = "")||(aGlossaryID = "")) result
	
	Set objGlossary=##Class(EPRmeta.Glossary).%OpenId(aGlossaryID)
	If objGlossary'="" Do objGlossary.%Close()
	Quit:'$IsObject(objGlossary) result
	Quit:($zcvt(objGlossary.GlossaryType,"U")'="TG") result //模板
	
	Set xGlossaryItemID=0
	For {
		Set xGlossaryItemID=$o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",aGlossaryID,xGlossaryItemID))
		Quit:xGlossaryItemID=""
		
		Set objGlossaryItem=##Class(EPRmeta.GlossaryItem).%OpenId(xGlossaryItemID)
		If objGlossaryItem'="" Do objGlossaryItem.%Close()
		Continue:'$IsObject(objGlossaryItem)
		
		If ($zcvt(objGlossaryItem.TemType,"U") = "NEW") {
			//新版
			//s result=##Class(EMRservice.BL.BLScatterData).GetScatterDatas(aEpisodeID,objGlossaryItem.ItemCode,objGlossaryItem.TemplateID,objGlossaryItem.ValueType)
			Set result=..GetScatterDatas(aEpisodeID,objGlossaryItem.ItemCode,objGlossaryItem.TemplateID,objGlossaryItem.ValueType,aDateFrom,aDateTo)
		} ElseIf ($zcvt(objGlossaryItem.TemType,"U") = "EMRINSTANCE") {
			//扩展的instanceData属性字段
			//不需要 暂时不用
		} Else {
			//老版
			Set result=##Class(EMRservice.BL.BLEPRScatterData).GetScatterDatas(aEpisodeID,objGlossaryItem.TemplateID,objGlossaryItem.ItemCode,objGlossaryItem.ValueType)
		}
		Quit:(result.Count()>0)
	}
	Quit result
}

/// Creator:    zhufei
/// CreateDate: 2020-09-27
/// Desc:       根据单元代码取所有病历打散数据
/// Input:      AEpisodeID 就诊号
///             AItem #TYPE:ICOMPOSITESAMPLE#SCODE:S010|CCODE:V001|CSCODE:L013#TID:88#VTYPE:V
/// Output:     result 数组 key:病历ID value:单元值
/// w ##Class(DHCHAI.DI.DIO.FromEmrNewSrv).GetDataByGlossaryID(76,1029)
ClassMethod GetScatterDatas(AEpisodeID As %String, AItem As %String, ATemplateID As %String, AValueType As %String, ADateFrom As %String = "", ADateTo As %String = "") As %ArrayOfDataTypes
{
	s $ZT="ERROR"
	s result = ##Class(%ArrayOfDataTypes).%New()
	q:((AEpisodeID = "")||(AItem = "")||(ATemplateID = "")) result
	s elementType = $p($p(AItem,"#",2),":",2)
	s vtype = $Case(AValueType,"":"V",:AValueType)
	if (elementType = "ISECTIONDESC")
	{
		s code = $p($p(AItem,"#",3),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_code,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			if (ADateFrom'="")||(ADateTo'=""){
				//add by zf 20200927
				set CreateDate=objInstance.CreateDate
				set ModifyDate=objInstance.ModifyDate
				set:ModifyDate="" ModifyDate=CreateDate
				continue:(ADateFrom'="")&&((ModifyDate<ADateFrom)&&(CreateDate<ADateFrom))
				continue:(ADateTo'="")&&((ModifyDate>ADateTo)&&(CreateDate>ADateTo))
			}
			s rowId = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_code,instanceId,""))
			s value = ##Class(EMRservice.BL.BLScatterData).GetSectionData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}
	} 
	elseif (elementType = "ICOMPOSITEDESC")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			if (ADateFrom'="")||(ADateTo'=""){
				//add by zf 20200927
				set CreateDate=objInstance.CreateDate
				set ModifyDate=objInstance.ModifyDate
				set:ModifyDate="" ModifyDate=CreateDate
				continue:(ADateFrom'="")&&((ModifyDate<ADateFrom)&&(CreateDate<ADateFrom))
				continue:(ADateTo'="")&&((ModifyDate>ADateTo)&&(CreateDate>ADateTo))
			}
			s rowId = $o(^DHCEMRI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode,instanceId,""))
			s value = ##Class(EMRservice.BL.BLScatterData).GetCompositeData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}
	}
	elseif (elementType = "ICOMPOSITESAMPLE")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s cscode = $p($p($p(AItem,"#",3),"|",3),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cscode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			if (ADateFrom'="")||(ADateTo'=""){
				//add by zf 20200927
				set CreateDate=objInstance.CreateDate
				set ModifyDate=objInstance.ModifyDate
				set:ModifyDate="" ModifyDate=CreateDate
				continue:(ADateFrom'="")&&((ModifyDate<ADateFrom)&&(CreateDate<ADateFrom))
				continue:(ADateTo'="")&&((ModifyDate>ADateTo)&&(CreateDate>ADateTo))
			}
			s rowId = $o(^DHCEMRI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cscode,instanceId,""))
			s value = ##Class(EMRservice.BL.BLScatterData).GetCompositeSimpleData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}		
	}
	elseif (elementType = "ICONCEPTDESC")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s cocode = $p($p($p(AItem,"#",3),"|",3),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeConceptI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cocode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			if (ADateFrom'="")||(ADateTo'=""){
				//add by zf 20200927
				set CreateDate=objInstance.CreateDate
				set ModifyDate=objInstance.ModifyDate
				set:ModifyDate="" ModifyDate=CreateDate
				continue:(ADateFrom'="")&&((ModifyDate<ADateFrom)&&(CreateDate<ADateFrom))
				continue:(ADateTo'="")&&((ModifyDate>ADateTo)&&(CreateDate>ADateTo))
			}
			s rowId = $o(^DHCEMRI.ICompositeConceptI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cocode,instanceId,""))
			s value = ##Class(EMRservice.BL.BLScatterData).GetConceptData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}
	}
	elseif (elementType = "ICONCEPTSAMPLE")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s cocode = $p($p($p(AItem,"#",3),"|",3),":",2)
		s cscode = $p($p($p(AItem,"#",3),"|",4),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.IConceptSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cocode," "_cscode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			if (ADateFrom'="")||(ADateTo'=""){
				//add by zf 20200927
				set CreateDate=objInstance.CreateDate
				set ModifyDate=objInstance.ModifyDate
				set:ModifyDate="" ModifyDate=CreateDate
				continue:(ADateFrom'="")&&((ModifyDate<ADateFrom)&&(CreateDate<ADateFrom))
				continue:(ADateTo'="")&&((ModifyDate>ADateTo)&&(CreateDate>ADateTo))
			}
			s rowId = $o(^DHCEMRI.IConceptSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cocode," "_cscode,instanceId,""))
			s value = ##Class(EMRservice.BL.BLScatterData).GetConceptSimpleData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}
	}
	elseif (elementType = "IMACRODESC")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s macode = $p($p($p(AItem,"#",3),"|",3),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeMacroI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_macode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			if (ADateFrom'="")||(ADateTo'=""){
				//add by zf 20200927
				set CreateDate=objInstance.CreateDate
				set ModifyDate=objInstance.ModifyDate
				set:ModifyDate="" ModifyDate=CreateDate
				continue:(ADateFrom'="")&&((ModifyDate<ADateFrom)&&(CreateDate<ADateFrom))
				continue:(ADateTo'="")&&((ModifyDate>ADateTo)&&(CreateDate>ADateTo))
			}
			s rowId = $o(^DHCEMRI.ICompositeMacroI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cocode,instanceId,""))
			s value = ##Class(EMRservice.BL.BLScatterData).GetCompositeMacroData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}		
	}
	elseif (elementType = "IMACROSAMPLE")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s mccode = $p($p($p(AItem,"#",3),"|",3),":",2)
		s mcname = $p($p($p(AItem,"#",3),"|",4),":",2)		
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.IMacroObjectItemsI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_mcCode,instanceId),-1)
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			q:($zcvt(objInstance.Status,"U") = "SAVE")
			if (ADateFrom'="")||(ADateTo'=""){
				//add by zf 20200927
				set CreateDate=objInstance.CreateDate
				set ModifyDate=objInstance.ModifyDate
				set:ModifyDate="" ModifyDate=CreateDate
				continue:(ADateFrom'="")&&((ModifyDate<ADateFrom)&&(CreateDate<ADateFrom))
				continue:(ADateTo'="")&&((ModifyDate>ADateTo)&&(CreateDate>ADateTo))
			}
			s value = ##Class(EMRservice.BL.BLScatterData).GetMacroObjectItemsDataByInstanceID(AEpisodeID,tmpInstanceId,ATemplateID,scode,ccode,mccode,mcname)
			d result.SetAt(value,tmpInstanceId)
		}		
	}
	q result
	
ERROR
    q "ERROR"
}

}
