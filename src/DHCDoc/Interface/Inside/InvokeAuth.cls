/// Desc：调用权力系统的统一入口类(避免分散，不知接入了那些接口)
/// Creator：lixu
/// Date：2023-03-08
Class DHCDoc.Interface.Inside.InvokeAuth Extends DHCDoc.Util.RegisteredObject
{

/// Desc: 判断权力系统开启状态
/// Output: 0/1:关闭/开启
ClassMethod GetSwitch()
{
    s Switch=##class(websys.StandardTypeItem).GetIdFromCodeOrDescription("websys","EnablePMASystem")
    s:Switch'=1 Switch=0
    Q Switch
}

/// 保存释放号源相关信息(挂号设置->释放号源)
/// "BeforeDateCancelApp!2^BeforeDateReturn!1^DateUnSplitCancelApp!1^DateUnSplitReturn!2^DateSplitBeforeCancelApp!1^DateSplitBeforeReturn!1^DateSplitAfterCancelApp!1^DateSplitAfterReturn!1","1^^^2"
ClassMethod InvokeReSortQueueNoAuth(Coninfo, HospID, UserID)
{
    s ^templx("InvokeReSortQueueNoAuth")=$lb(Coninfo, HospID, UserID)
    
    s NodeArr("BeforeDateCancelApp")="就诊日期之前，取消预约"
    s NodeArr("BeforeDateReturn")="就诊日期之前，退号"
    s NodeArr("DateUnSplitCancelApp")="就诊日期当天，排班未分时段，预约回归点之前取消预约"
    s NodeArr("DateUnSplitReturn")="就诊日期当天，排班未分时段，退号"
    s NodeArr("DateSplitBeforeCancelApp")="在就诊日期当天，分时段排班，时段开始时间之前取消预约"
    s NodeArr("DateSplitBeforeReturn")="在就诊日期当天，分时段排班，时段开始时间之前退号"
    s NodeArr("DateSplitAfterCancelApp")="在就诊日期当天，分时段排班，时段开始时间之后取消预约"
    s NodeArr("DateSplitAfterReturn")="在就诊日期当天，分时段排班，时段开始时间之后退号"	
    s NodeVal("1")="释放号源"
    s NodeVal("2")="不释放号源"
    s NodeVal("3")="不释放号源并增号"

    s MyData = ##class(BSP.SYS.DTO.AuthData).%New()
    s MyData.applyUserId = UserID
    s MyData.authCode = "HIS-DOC-REG-RESORTQUEUENO"
    s MyData.authDesc = "申请审批挂号释放号源设置"
    // 拼凑displayData
    s MyRow = ##class(BSP.SYS.DTO.AuthRowData).%New()
    s MyRow.code = "regdiscountdetail"
    s MyRow.desc = "释放号源设置明细"
    s MyRow.type = "Update"
    for len=1:1:$l(Coninfo,"^"){
        s OneInfo=$p(Coninfo,"^",len)
        continue:OneInfo=""
        s Node=$p(OneInfo,"!",1)
        s NVal=$p(OneInfo,"!",2)
        s OVal=##Class(web.DHCOPRegConfig).GetSpecConfigNode(Node,HospID)
        s NodeName=$g(NodeArr(Node))
        s:NVal'="" NVal=$g(NodeVal(NVal))
        s:OVal'="" OVal=$g(NodeVal(OVal))

        s MyCol=""
        s MyCol = ##class(BSP.SYS.DTO.AuthColData).%New()
        s MyCol.colName = NodeName
        s MyCol.oldDataDesc = OVal
        s MyCol.newDataDesc = NVal
        d MyRow.details.Insert(MyCol)
    }
    // 写回调newData
    s NewData = {"Coninfo":(Coninfo),"HospID":(HospID)}
    s MyData.newData = NewData.%ToJSON()
    d MyData.displayData.Insert(MyRow)
    s AuthIdInfo = ##class(BSP.SYS.SRV.AuthItemApply).ApplyByDto(MyData)
    Q ..FormatAuthIdInfo(AuthIdInfo)
}

/// 回写释放号源相关信息(挂号设置->释放号源)
/// "BeforeDateCancelApp!2^BeforeDateReturn!1^DateUnSplitCancelApp!1^DateUnSplitReturn!2^DateSplitBeforeCancelApp!1^DateSplitBeforeReturn!1^DateSplitAfterCancelApp!1^DateSplitAfterReturn!1","1^^^2"
ClassMethod ServerReSortQueueNoAuth(NewData)
{
    s ^templx("ServerReSortQueueNoAuth")=NewData
    s Obj={}.%FromJSON(NewData)
    s Coninfo=Obj.Coninfo
    s HospID=Obj.HospID
    d ##class(web.DHCOPRegConfig).SaveConfigHosp(Coninfo,HospID)
    Q ""
}

/// 保存挂号优惠设置详细设置
/// w ##class(DHCDoc.Interface.Inside.InvokeAuth).InvokeRegConDisCountSetAuth("4","11","3","1","60","1","1","1","1","1","1")
ClassMethod InvokeRegConDisCountSetAuth(RCDRowid As %String, Age As %String, AgeCompare As %String, SexDr As %String, DeptDr As %String, MarkDr As %String, FeeCateDr As %String, PatTypeDr As %String, OldCard As %String, DocSessionDr As %String, SessionDr As %String, SessionStr As %String) As %String
{
    s ^templx("InvokeRegConDisCountSetAuth")=$lb(RCDRowid,Age,AgeCompare,SexDr,DeptDr,MarkDr,FeeCateDr,PatTypeDr,OldCard,DocSessionDr,SessionDr,SessionStr)
    Q:RCDRowid="" "-1^缺少优惠ID"
    s UserID=$p(SessionStr,"^",1)
    // 先取旧数据
    &SQL(SELECT RCD_Age,RCD_AgeCompare,RCD_Sex_Dr->CTSEX_Desc,RCD_Dept_Dr->CTLOC_Desc, RCD_Mark_Dr->CTPCP_Desc, 
        RCD_FeeCate_Dr->REA_Desc, RCD_PatType_Dr->SS_Desc,RCD_OldCard, RCD_SessionDr->SESS_Desc
        INTO :OAge, :OAgeCompare, :OSex, :ODept, :OMark, :OAdmReason, :OSocialType, :OOldCard, :OSessionType
        FROM SQLUser.DHC_RegConDisCount
        WHERE (RCD_Rowid=:RCDRowid)
    )
    Q:SQLCODE'=0 "--1^缺少优惠ID"
    if OAge'="" {
        s OAgeCompare=$case(OAgeCompare,1:"小于",2:"等于",3:"大于",:"")
        s OAge=OAgeCompare_OAge_"岁"
    }

    s (NAge,NSex,NDept,NMark,NSessionType,NAdmReason,NSocialType)=""
    if Age'=""{
        s AgeCompare=$case(AgeCompare,1:"小于",2:"等于",3:"大于",:"")
        s NAge=AgeCompare_Age_"岁"
    }
    s:SexDr'="" NSex=$p($g(^CT("SEX",SexDr)),"^",2)
    s:DeptDr'="" NDept=$p($g(^CTLOC(DeptDr)),"^",2)
    s:MarkDr'="" NMark=$p($g(^CTPCP(MarkDr,1)),"^",2)
    s:DocSessionDr'="" NSessionType=$p($g(^RBC("SESS",DocSessionDr)),"^",2)
    s:FeeCateDr'="" NAdmReason=$p($g(^PAC("ADMREA",FeeCateDr)),"^",2)
    s:PatTypeDr'="" NSocialType=$p($g(^CT("SS",PatTypeDr)),"^",2)

    s MyData = ##class(BSP.SYS.DTO.AuthData).%New()
    s MyData.applyUserId = UserID
    s MyData.authCode = "HIS-DOC-REGDISCOUNT"
    s MyData.authDesc = "申请审批挂号优惠功能"
    // 拼凑displayData
    s MyRow = ##class(BSP.SYS.DTO.AuthRowData).%New()
    s MyRow.code = "regdiscountdetail"
    s MyRow.desc = "挂号优惠明细"
    s MyRow.type = "Update"
    s MyCol = ##class(BSP.SYS.DTO.AuthColData).%New()
    s MyCol.colName = "性别"
    s MyCol.oldDataDesc = OSex
    s MyCol.newDataDesc = NSex
    d MyRow.details.Insert(MyCol)
    s MyCol1 = ##class(BSP.SYS.DTO.AuthColData).%New()
    s MyCol1.colName = "年龄"
    s MyCol1.oldDataDesc = OAge
    s MyCol1.newDataDesc = NAge
    d MyRow.details.Insert(MyCol1)
    s MyCol2 = ##class(BSP.SYS.DTO.AuthColData).%New()
    s MyCol2.colName = "科室"
    s MyCol2.oldDataDesc = ODept
    s MyCol2.newDataDesc = NDept
    d MyRow.details.Insert(MyCol2)
    s MyCol3 = ##class(BSP.SYS.DTO.AuthColData).%New()
    s MyCol3.colName = "号别"
    s MyCol3.oldDataDesc = OMark
    s MyCol3.newDataDesc = NMark
    d MyRow.details.Insert(MyCol3)
    s MyCol4 = ##class(BSP.SYS.DTO.AuthColData).%New()
    s MyCol4.colName = "挂号职称"
    s MyCol4.oldDataDesc = OSessionType
    s MyCol4.newDataDesc = NSessionType
    d MyRow.details.Insert(MyCol4)
    s MyCol5 = ##class(BSP.SYS.DTO.AuthColData).%New()
    s MyCol5.colName = "患者费别"
    s MyCol5.oldDataDesc = OAdmReason
    s MyCol5.newDataDesc = NAdmReason
    d MyRow.details.Insert(MyCol5)
    s MyCol6 = ##class(BSP.SYS.DTO.AuthColData).%New()
    s MyCol6.colName = "患者类型"
    s MyCol6.oldDataDesc = OSocialType
    s MyCol6.newDataDesc = NSocialType
    d MyRow.details.Insert(MyCol6)
    d MyData.displayData.Insert(MyRow)

    // 写回调newData
    s Val=RCDRowid_"^"_Age_"^"_AgeCompare_"^"_SexDr_"^"_DeptDr_"^"_MarkDr_"^"_FeeCateDr_"^"_PatTypeDr_"^"_OldCard_"^"_DocSessionDr
    s NewData = {"Id":(RCDRowid),"val":(Val)}
    s MyData.newData = NewData.%ToJSON()
    s AuthIdInfo = ##class(BSP.SYS.SRV.AuthItemApply).ApplyByDto(MyData)
    Q ..FormatAuthIdInfo(AuthIdInfo)
}

/// 回写挂号优惠设置详细设置
ClassMethod ServerRegConDisCountSetAuth(NewData)
{
    s ^templx("ServerRegConDisCountSetAuth")=$lb(NewData)
    s RCDRowid=$p(NewData,"^",1)
    s Age=$p(NewData,"^",2)
    s AgeCompare=$p(NewData,"^",3)
    s SexDr=$p(NewData,"^",4)
    s DeptDr=$p(NewData,"^",5)
    s MarkDr=$p(NewData,"^",6)
    s FeeCateDr=$p(NewData,"^",7)
    s PatTypeDr=$p(NewData,"^",8)
    s OldCard=$p(NewData,"^",9)
    s DocSessionDr=$p(NewData,"^",10)
    d ##class(web.DHCRegConDisCount).UpdateDHCRegConDisCountSet(RCDRowid,Age,AgeCompare,SexDr,DeptDr,MarkDr,FeeCateDr,PatTypeDr,OldCard,DocSessionDr)
    
    Q ""
}

/// 保存医生站常规设置相关信息
/// "GroupOrderOnePage"_$c(1)_"Y"_$c(2)_"UpdateHourOrderEndTime"_$c(1)_"Y","2","1","{""m_AuthFlag"":1,""CheckIPDeposit"":""住院欠费控制"",""OPOrderEntryLock"":""门、急诊加锁就诊纪录"",""UserEMVirtualtLong"":""急诊启用虚拟长期医嘱"",""OPAdmDayLimit"":""门诊就诊有效时间"",""EPAdmDayLimit"":""急诊就诊有效时间"",""OPEntryTreatOrdWhenNotHaveSkinOrd"":""(门诊)无阴性结果/用药记录可以开立治疗医嘱"",""EPEntryTreatOrdWhenNotHaveSkinOrd"":""(急诊)无阴性结果/用药记录可以开立治疗医嘱"",""IPEntryTreatOrdWhenNotHaveSkinOrd"":""(住院)无阴性结果/用药记录可以开立治疗医嘱"",""SkinTestNeedApply"":""治疗用途医嘱控制为临时"",""OrdStausChangeAutoUpdateExec"":""皮试医嘱需要走申请流程"",""DisableOrdSkinChange"":""按照默认皮试及皮试备注审核,不允许单独修改"",""SkinTestOPNeedExcutedCur"":"" 仅将已执行的治疗医嘱算作有效治疗(门急诊)""}","Day^Hour"
ClassMethod InvokeDHCDocConfigAuth(Coninfo, HospID, UserID, AuthJson, ExptStr)
{
    s ^templx("InvokeDHCDocConfigAuth")=$lb(Coninfo,HospID,UserID,AuthJson,ExptStr)
    s AuthObj={}.%FromJSON(AuthJson)
    s NodeVal("0")="关闭"
    s NodeVal("1")="启用"
    s NodeVal("Day")="天"
    s NodeVal("Hour")="小时"

    s MyData = ##class(BSP.SYS.DTO.AuthData).%New()
    s MyData.applyUserId = UserID
    s MyData.authCode = "HIS-DOC-CONFIG"
    s MyData.authDesc = "申请审批医生站常规设置"
    s MyRow = ##class(BSP.SYS.DTO.AuthRowData).%New()
    s MyRow.code = "configdetail"
    s MyRow.desc = "医生站常规设置明细"
    s MyRow.type = "Update"

    for len=1:1:$l(Coninfo,$c(2)){
        s OneInfo=$p(Coninfo,$c(2),len)
        s Node=$p(OneInfo,$c(1),1)
        continue:Node=""
        s NVal=$p(OneInfo,$c(1),2)
        s OVal=..%GetConfig(Node,HospID)
        continue:(Node="OPLimitType")||(Node="EPLimitType")
        if ((Node="OPAdmDayLimit")||(Node="EPAdmDayLimit")){
            ;门急诊有效就诊日期需特殊处理
            s NValUom=""
            s:Node="OPAdmDayLimit" NValUom=$p(ExptStr,"^",1)
            s:Node="EPAdmDayLimit" NValUom=$p(ExptStr,"^",2)
            s:NValUom'="" NVal=NVal_$g(NodeVal(NValUom))
            s LimitUomNode=$case(Node,"OPAdmDayLimit":"OPLimitType","EPAdmDayLimit":"EPLimitType")
            s LimitUom=..%GetConfig(LimitUomNode,HospID)
            s:LimitUom'="" OVal=OVal_$g(NodeVal(LimitUom))
        }else{
            s:NVal'="" NVal=$g(NodeVal(NVal))
            s:OVal'="" OVal=$g(NodeVal(OVal))
        }
        s NodeName=AuthObj.%Get(Node)
        s MyCol=""
        s MyCol = ##class(BSP.SYS.DTO.AuthColData).%New()
        s MyCol.colName = NodeName
        s MyCol.oldDataDesc = OVal
        s MyCol.newDataDesc = NVal
        d MyRow.details.Insert(MyCol)
    }
    // 写回调newData
    s MyData.newData = $lb(HospID,Coninfo)
    d MyData.displayData.Insert(MyRow)
    s AuthIdInfo = ##class(BSP.SYS.SRV.AuthItemApply).ApplyByDto(MyData)
    Q ..FormatAuthIdInfo(AuthIdInfo)
}

/// 回写医生站常规设置相关信息
/// "GroupOrderOnePage"_$c(1)_"Y"_$c(2)_"UpdateHourOrderEndTime"_$c(1)_"Y","2","1","{""m_AuthFlag"":1,""CheckIPDeposit"":""住院欠费控制"",""OPOrderEntryLock"":""门、急诊加锁就诊纪录"",""UserEMVirtualtLong"":""急诊启用虚拟长期医嘱"",""OPAdmDayLimit"":""门诊就诊有效时间"",""EPAdmDayLimit"":""急诊就诊有效时间"",""OPEntryTreatOrdWhenNotHaveSkinOrd"":""(门诊)无阴性结果/用药记录可以开立治疗医嘱"",""EPEntryTreatOrdWhenNotHaveSkinOrd"":""(急诊)无阴性结果/用药记录可以开立治疗医嘱"",""IPEntryTreatOrdWhenNotHaveSkinOrd"":""(住院)无阴性结果/用药记录可以开立治疗医嘱"",""SkinTestNeedApply"":""治疗用途医嘱控制为临时"",""OrdStausChangeAutoUpdateExec"":""皮试医嘱需要走申请流程"",""DisableOrdSkinChange"":""按照默认皮试及皮试备注审核,不允许单独修改"",""SkinTestOPNeedExcutedCur"":"" 仅将已执行的治疗医嘱算作有效治疗(门急诊)""}","Day^Hour"
ClassMethod ServerDHCDocConfigAuth(NewData)
{
    s ^templx("ServerDHCDocConfigAuth")=$lb(NewData)
    s HospID=$lg(NewData,1)
    s Coninfo=$lg(NewData,2)
    d ##class(web.DHCDocConfig).SaveConfig(Coninfo,HospID)
    Q ""
}

/// 保存抗菌药物->功能配置->常规设置相关信息
ClassMethod InvokeAntFunConfigAuth(Coninfo, HospID, UserID)
{
    s ^templx("InvokeAntFunConfigAuth")=$lb(Coninfo, HospID, UserID)
    s NodeVal("OSKJ")="启用门诊抗菌药物管理"
    s NodeVal("ESKJ")="启用急诊抗菌药物管理"
    s NodeVal("ISKJ")="启用住院抗菌药物管理"
    
    s MyData = ##class(BSP.SYS.DTO.AuthData).%New()
    s MyData.applyUserId = UserID
    s MyData.authCode = "HIS-DOCANT-FUNCONFIG"
    s MyData.authDesc = "审批抗菌药物功能配置"
    s MyRow = ##class(BSP.SYS.DTO.AuthRowData).%New()
    s MyRow.code = "configdetail"
    s MyRow.desc = "常规设置明细"
    s MyRow.type = "Update"
    s Obj=##class(DHCDoc.Util.FromXML).XML2Arr(Coninfo,"BSNoraml")
    s key=""
	for {
		s value=Obj.%GetNext(.key)
        q:key=""
        s NodeName=$g(NodeVal(key))
        Continue:NodeName=""
        s NVal=$case(value,1:"是",:"否")
        s OVal=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode(key,HospID)
        s OVal=$case(OVal,1:"是",:"否")

        s MyCol=""
        s MyCol = ##class(BSP.SYS.DTO.AuthColData).%New()
        s MyCol.colName = NodeName
        s MyCol.oldDataDesc = OVal
        s MyCol.newDataDesc = NVal
        d MyRow.details.Insert(MyCol)
	}
    // 写回调newData
    s MyData.newData = HospID_"^"_Coninfo
    d MyData.displayData.Insert(MyRow)
    s AuthIdInfo = ##class(BSP.SYS.SRV.AuthItemApply).ApplyByDto(MyData)
    Q ..FormatAuthIdInfo(AuthIdInfo)
}

/// 回写抗菌药物->功能配置->常规设置相关信息
ClassMethod ServerAntFunConfigAuth(NewData)
{
    s ^templx("ServerAntFunConfigAuth")=NewData
    s HospID=$p(NewData,"^",1)
    s Coninfo=$p(NewData,"^",2)
    d ##class(DHCAnt.KSS.Config.BSNormal).DBSave(Coninfo,HospID)
    Q ""
}

/// 保存抗菌药物->功能配置->流程设置相关信息
/// ("240","KSS2APP","A,F,S","2","","1")
ClassMethod InvokeAntProcessAuth(id, mcgCode, mcgValue, mcgHosp, finalDep, UserID)
{
    s ^templx("InvokeAntProcessAuth")=$lb(id, mcgCode, mcgValue,mcgHosp,finalDep,UserID)
    s NodeVal("KSS2APP")="非特抗药申请流程"
    s NodeVal("KSS3APPNOA")="特抗药无审核权限申请流程"
    s NodeVal("KSS3APPA")="特抗药有审核权限申请流程"
    s NodeVal("A")="是否科室预审"
    s NodeVal("F")="是否会诊"
    s NodeVal("H")="是否科室审核"
    s NodeVal("S")="是否最终审核"
    s NodeVal("U")="最终审核科室"
    
    s MyData = ##class(BSP.SYS.DTO.AuthData).%New()
    s MyData.applyUserId = UserID
    s MyData.authCode = "HIS-DOCANT-PROCESSCONFIG"
    s MyData.authDesc = "审批抗菌药物功能配置"
    s MyRow = ##class(BSP.SYS.DTO.AuthRowData).%New()
    s MyRow.code = "configdetail"
    s MyRow.desc = $g(NodeVal(mcgCode))
    s MyRow.type = "Update"

    s OProcessStr=$p(^DHCAntBaseMainConfigD(id),"^",9)
    s ProcessStr="A,F,H,S,U"
    for len=1:1:$l(ProcessStr,","){
        s Process=$p(ProcessStr,",",len)
        Continue:Process=""
        s NodeName=$g(NodeVal(Process))
        s NVal="否"
        s:mcgValue[Process NVal="是"
        s OVal="否"
        s:OProcessStr[Process OVal="是"
        s MyCol=""
        s MyCol = ##class(BSP.SYS.DTO.AuthColData).%New()
        s MyCol.colName = NodeName
        s MyCol.oldDataDesc = OVal
        s MyCol.newDataDesc = NVal
        d MyRow.details.Insert(MyCol)
    }
    s:finalDep'="" NLocDesc=$P(^CTLOC(finalDep),"^",2)
    s OLocID=$p(^DHCAntBaseMainConfigD(id),"^",8)
    s:OLocID'="" OLocDesc=$P(^CTLOC(OLocID),"^",2)
    s MyCol=""
    s MyCol = ##class(BSP.SYS.DTO.AuthColData).%New()
    s MyCol.colName = "最终审核科室"
    s MyCol.oldDataDesc = $g(OLocDesc)
    s MyCol.newDataDesc = $g(NLocDesc)
    d MyRow.details.Insert(MyCol)

    // 写回调newData
    s Coninfo = {"id":(id),"mcgCode":(mcgCode),"mcgValue":(mcgValue),"mcgHosp":(mcgHosp),"finalDep":(finalDep)}
    s MyData.newData = Coninfo.%ToJSON()
    d MyData.displayData.Insert(MyRow)
    s AuthIdInfo = ##class(BSP.SYS.SRV.AuthItemApply).ApplyByDto(MyData)
    Q ..FormatAuthIdInfo(AuthIdInfo)
}

/// 回写抗菌药物->功能配置->流程设置相关信息
/// w ##class(DHCDoc.Interface.Inside.InvokeAuth).ServerAntProcessAuth("{""id"":""422"",""mcgCode"":""KSS3APPA"",""mcgValue"":""A,H,S,U"",""mcgHosp"":""2"",""finalDep"":""191""}")
ClassMethod ServerAntProcessAuth(NewData)
{
    s ^templx("ServerAntProcessAuth")=$lb(NewData)
    s Obj={}.%FromJSON(NewData)
    d ##class(DHCAnt.Base.MainConfigExcute).SaveProcess(Obj.mcgCode,Obj.mcgValue,Obj.mcgHosp,Obj.finalDep,"",Obj.id)                
    Q ""
}

/// 保存医生站安全组设置相关信息
/// w ##class(DHCDoc.Interface.Inside.InvokeAuth).InvokeDocGroupAuth("{""NoAdmValidDaysLimit"":""1""}","28","2","1^医嘱录入设置")
ClassMethod InvokeDocGroupAuth(InputStr, GroupID, HospID, ExptStr)
{
    s ^templx("InvokeAntProcessAuth")=$lb(InputStr, GroupID, HospID, ExptStr)
    s UserID=$p(ExptStr,"^",1)
    s Title=$p(ExptStr,"^",2)
    s GroupDesc=$p($g(^SSU("SSGRP",GroupID)),"^",1)
    s NodeVal("NoAdmValidDaysLimit")="不受就诊有效天数限制"

    s MyData = ##class(BSP.SYS.DTO.AuthData).%New()
    s MyData.applyUserId = UserID
    s MyData.authCode = "HIS-DOC-GROUPAUTH"
    s MyData.authDesc = "医生站安全组:"_GroupDesc_"配置"
    s MyRow = ##class(BSP.SYS.DTO.AuthRowData).%New()
    s MyRow.code = "configdetail"
    s MyRow.desc = Title_"设置"
    s MyRow.type = "Update"

    s InputObj={}.%FromJSON(InputStr)
	s Iterator=InputObj.%GetIterator()
	while Iterator.%GetNext(.key , .value ) {
		Continue:key=""
		s NodeName=$g(NodeVal(key))
        Continue:NodeName=""
        s NVal=$case(value,1:"是",:"否")
        s NodeStr="["""_key_"""]"
        s OValJson=##class(DHCDoc.DHCDocConfig.Group).GetMulDocConfig1(NodeStr,GroupID,HospID)
        s OValObj={}.%FromJSON(OValJson)
        s OVal=OValObj.%Get(key)
        s OVal=$case(OVal,1:"是",:"否")

        s MyCol=""
        s MyCol = ##class(BSP.SYS.DTO.AuthColData).%New()
        s MyCol.colName = NodeName
        s MyCol.oldDataDesc = OVal
        s MyCol.newDataDesc = NVal
        d MyRow.details.Insert(MyCol)
	}

    // 写回调newData
    s Coninfo = {"GroupID":(GroupID),"InputStr":(InputStr),"HospID":(HospID)}
    s MyData.newData = Coninfo.%ToJSON()
    d MyData.displayData.Insert(MyRow)
    s AuthIdInfo = ##class(BSP.SYS.SRV.AuthItemApply).ApplyByDto(MyData)
    Q ..FormatAuthIdInfo(AuthIdInfo)
}

/// 回写医生站安全组设置相关信息
ClassMethod ServerDocGroupAuth(NewData)
{
    s ^templx("ServerDocGroupAuth")=$lb(NewData)
    s Obj={}.%FromJSON(NewData)
    d ##class(DHCDoc.DHCDocConfig.Group).SaveMulDocConfig1(Obj.InputStr,Obj.GroupID,Obj.HospID)
    Q ""
}

/// 保存医生站排班审批设置相关信息
/// w ##class(DHCDoc.Interface.Inside.InvokeAuth).InvokeDocGroupAuth("{""NoAdmValidDaysLimit"":""1""}","28","2","1^医嘱录入设置")
ClassMethod InvokeScheduleAudiAuth(Coninfo, HospID, UserID)
{
    s ^templx("InvokeScheduleAudiAuth")=$lb(Coninfo, HospID, UserID)
    s HospCodeNode="HospDr_"_HospID
    
    s MyData = ##class(BSP.SYS.DTO.AuthData).%New()
    s MyData.applyUserId = UserID
    s MyData.authCode = "HIS-DOC-SCHEDULEAUDI"
    s MyData.authDesc = "医生站排班审批配置"
    s MyRow = ##class(BSP.SYS.DTO.AuthRowData).%New()
    s MyRow.code = "configdetail"
    s MyRow.desc = "不受限制的安全组"
    s MyRow.type = "Update"
	
	s Node=$p(Coninfo,$c(1),1)
	s NNodeValStr=$p(Coninfo,$c(1),2)
	s ONodeValStr=$g(^DHCDocConfig(HospCodeNode,Node))
	s NodeValStr=NNodeValStr_"^"_ONodeValStr
	for Len=1:1:$l(NodeValStr,"^"){
		s NodeVal=$p(NodeValStr,"^",Len)
		Continue:+NodeVal=0
		s NodeName=$p($g(^SSU("SSGRP",NodeVal)),"^",1)
		s (NVal,OVal)="否"
		if ("^"_NNodeValStr_"^")[("^"_NodeVal_"^") s NVal="是"
		if ("^"_ONodeValStr_"^")[("^"_NodeVal_"^") s OVal="是"

		s MyCol=""
        s MyCol = ##class(BSP.SYS.DTO.AuthColData).%New()
        s MyCol.colName = NodeName
        s MyCol.oldDataDesc = OVal
        s MyCol.newDataDesc = NVal
        d MyRow.details.Insert(MyCol)
	}
    // 写回调newData
    s NewData = {"HospID":(HospID),"Coninfo":(Coninfo)}
    s MyData.newData = $lb(Coninfo,HospID)
    d MyData.displayData.Insert(MyRow)
    s AuthIdInfo = ##class(BSP.SYS.SRV.AuthItemApply).ApplyByDto(MyData)
    Q ..FormatAuthIdInfo(AuthIdInfo)
}

/// 回写医生站排班审批设置相关信息
ClassMethod ServerScheduleAudiAuth(NewData)
{
    s ^templx("ServerScheduleAudiAuth")=NewData
    s Coninfo=$lg(NewData,1)
    s HospID=$lg(NewData,2)
    d ##class(web.DHCDocConfig).SaveConfig(Coninfo,HospID)
    Q ""
}

/// 格式化权力系统返回值
/// Output: 0/其他^描述：成功/失败^描述
ClassMethod FormatAuthIdInfo(AuthIdInfo)
{
	s AuthDesc=$P(AuthIdInfo,"^",2)
    if $p(AuthIdInfo,"^")="-3" {
        Quit "-3^申请已发出,请等侯审批"
    }
	
	if AuthDesc="Not Data Change" s AuthIdInfo=1    ;没数据改变默认提示为发出申请
    if AuthIdInfo>0 {
        Quit "0^已成功向权力系统发出申请"
    }else{
        Quit "-3^向权力系统发出申请失败,"_AuthDesc
    } 
    Quit "-4^权力系统发出申请错误"
}

/// 用于VSCode调试
ClassMethod Test()
{
    zw ^templx("InvokeDHCDocConfigAuth")
    d ##class(DHCAnt.KSS.Extend.Hosp).QryProcessConfig()
    Q ""
}

}
