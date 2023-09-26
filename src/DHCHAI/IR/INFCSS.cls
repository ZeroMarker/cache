/// 名称: DHCHAI.IR.INFMBR
/// 描述: 横断面调查 汇总登记表
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.INFCSS Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm;

/// 调查编号
Property IRSurvNumber As %String(TRUNCATE = 1);

/// 调查人(人员名称)
Property IRSurvUser As %String(TRUNCATE = 1);

/// 是否有效
Property IRIsActive As %Boolean;

/// 是否感染 INFCSSIsExt
Property IRInfectionDr As DHCHAI.BT.Dictionary;

/// 感染分类 IRCSSINFTYPE
Property IRInfCategoryDr As DHCHAI.BT.Dictionary;

/// 医院感染1（多值"#"分隔）感染部位,病原体1,多耐情况1,病原体2,多耐情况2,病原体3,多耐情况3
Property IRInfPathogen1 As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 医院感染2（多值"#"分隔）
Property IRInfPathogen2 As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 医院感染3（多值"#"分隔）
Property IRInfPathogen3 As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 手术后肺炎 OEYesNo
Property IROprInf As DHCHAI.BT.Dictionary;

/// 社区感染1（多值"#"分隔）感染部位,病原体1,多耐情况1,病原体2,多耐情况2,病原体3,多耐情况3
Property IRComInfPathogen1 As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 社区感染2（多值"#"分隔）
Property IRComInfPathogen2 As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 社区感染3（多值"#"分隔
Property IRComInfPathogen3 As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 手术(是、否)
Property IROperFlag As %Boolean;

/// 手术切口等级(Ⅰ、Ⅱ、Ⅲ、Ⅳ、无)
Property IROperCuteTypeDr As DHCHAI.BT.Dictionary;

/// 手术日期
Property IROperDate As %Date;

/// 手术名称
Property IROperName As %String(MAXLEN = 500, TRUNCATE = 1);

/// 细菌耐药情况（多值"#","||"分割）
/// 金黄色葡萄球菌||苯唑西林:耐药||头孢西丁:#凝固酶阴性葡萄球菌||苯唑西林:耐药||头孢西丁:
/// #粪肠球菌||氨苄西林:耐药||万古霉素:#屎肠球菌||氨苄西林:耐药||万古霉素:#肺炎链球菌||青霉素:耐药
/// #大肠埃希菌||头孢他啶:耐药||亚胺/美罗培南:||左氧氟沙星:耐药
/// #肺炎克雷伯菌||头孢他啶:耐药||亚胺/美罗培南:||左氧氟沙星:耐药#铜绿假单胞菌||环丙沙星:耐药||哌拉西林/他唑巴坦:||亚胺培南/美罗培南:耐药||头孢他啶:||头孢吡肟:耐药||阿米卡星:
/// #鲍曼不动杆菌||亚胺培南/美罗培南:耐药||头孢哌酮/舒巴坦:
Property IRBugsAntiSen As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 抗菌药物使用(是、否)
Property IRAntiFlag As %Boolean;

/// 抗菌药物名称  多值用","号隔开
Property IRAntiDrList As %String(MAXLEN = 100, TRUNCATE = 1);

/// 目的(治疗用药、预防用药、治疗+预防)
Property IRAntiUsePurposeDr As DHCHAI.BT.Dictionary;

/// 联用(单用、二联、三联、四联及以上)
Property IRAntiCombinedMedDr As DHCHAI.BT.Dictionary;

/// 治疗用药已送细菌培养(是、否)
Property IRAntiSenFlag As %Boolean;

/// 送培养时机为抗菌药物使用前: (是、否)
Property IROperAntiFlag As %Boolean;

/// 报告是否完成(是、否)
Property IRRepFinishFlag As %Boolean;

/// 更新日期
Property IRUpdateDate As %Date;

/// 更新时间
Property IRUpdateTime As %Time;

/// 更新人
Property IRUpdateUserDr As DHCHAI.BT.SysUser;

/// 疾病诊断 
Property IRCSSDiagnosDr As DHCHAI.BT.Dictionary;

/// 首次医院感染日期
Property IRFirInfDate As %String;

/// 输液（调查日）和经血传播病毒情况（住院期间） Blood transfusion
/// 静脉输液#静脉输液是否抗菌药物#乙肝感染#丙肝感染#HIV感染#梅毒感染 6
/// 是 1 否 0 存在 Y 不存在 N 未查 U(default) 未选""(备用)
Property IRTransBloodInf As %String;

/// 基础疾病和危险因素  
/// 实体肿瘤#血液系统恶性肿瘤#糖尿病#呼吸衰竭#肾功能补全#肝硬化#昏迷#使用免疫抑制剂#使用糖皮质激素 9
/// 是1 否0
Property IRBaseRisk As %String;

/// 标本革兰染色 (是、否)
Property IRCSSSpecGLFlag As %Boolean;

/// 标本抗酸染色 (是、否)
Property IRCSSSpecKSFlag As %Boolean;

/// 标本墨汁染色 (是、否)
Property IRCSSSpecMZFlag As %Boolean;

/// 标本基因测序  (是、否)
Property IRCSSSpecJYFlag As %Boolean;

/// 社区感染发生类型：1：外院发生 2：社区发生
Property SQMethod1 As %String;

/// 社区感染发生类型：1：外院发生 2：社区发生
Property SQMethod2 As %String;

/// 社区感染发生类型：1：外院发生 2：社区发生
Property SQMethod3 As %String;

Index IndexSurEpisodeID On (IRSurvNumber, IREpisodeDr);

/// w ##class(DHCHAI.IR.INFCSS).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.IR.INFCSS
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCHAI.IR.INFCSS).%ExistsId(+id) return
	set obj=##Class(DHCHAI.IR.INFCSS).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator     ：chenjianbo
/// CreatDate   ：2018-01-05
/// input       : aInput
/// w ##Class(DHCHAI.IR.INFCSS).Update("^2773^201802010003^7935^1^0^^^1^290^301^0^0^^^^^^^^^^^7935")
ClassMethod Update(aInput As %String, aSeparete As %String = "^") As %String
{
	New (aInput,aSeparete)
	Set return=0
	Quit:aInput="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ID=$p(aInput,aSeparete,1)
	Set EpisodeDr=$p(aInput,aSeparete,2)
	Set SurvNumber=$p(aInput,aSeparete,3)
	Quit:(SurvNumber="")||(EpisodeDr="") return
	
	Set objEpisodeDr=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objEpisodeDr) return
	
	//set:SurvDate'="" SurvDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(SurvDate)
	//调查编号+患者唯一	
    Set ID =$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_SurvNumber,EpisodeDr,0)) 
	
	Set IRSurvUser    = $p(aInput,aSeparete,4)
	Set IRIsActive    = $p(aInput,aSeparete,5)
	Set IRInfectionDr = $p(aInput,aSeparete,6)
	Set objInfection  = ##class(DHCHAI.BT.Dictionary).GetObjById(IRInfectionDr)
	Set InfCategoryDr = $p(aInput,aSeparete,7)
	Set objCategory   = ##class(DHCHAI.BT.Dictionary).GetObjById(InfCategoryDr)
	Set IRInfPathogen1    = $p(aInput,aSeparete,8)
	Set IRInfPathogen2    = $p(aInput,aSeparete,9)
	Set IRInfPathogen3    = $p(aInput,aSeparete,10)
	Set IROprInf   = $p(aInput,aSeparete,11)
	Set objOprInf  = ##class(DHCHAI.BT.Dictionary).GetObjById(IROprInf)
	Set IRComInfPathogen1   = $p(aInput,aSeparete,12)
	Set IRComInfPathogen2   = $p(aInput,aSeparete,13)
	Set IRComInfPathogen3   = $p(aInput,aSeparete,14)
	Set chkCSSIsOpr   = $p(aInput,aSeparete,15)
	Set CSSIncisionDr = $p(aInput,aSeparete,16)
	Set objIncision   = ##class(DHCHAI.BT.Dictionary).GetObjById(CSSIncisionDr)
	Set OperDate      = $p(aInput,aSeparete,17)
	set:OperDate'="" OperDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(OperDate)
	Set txtOperName   = $p(aInput,aSeparete,18)
	Set CRBugsAntiSen = $p(aInput,aSeparete,19)
	Set IRAntiFlag    = $p(aInput,aSeparete,20)
	Set IRAntiDrList  = $p(aInput,aSeparete,21)
	Set MedPurposeDr  = $p(aInput,aSeparete,22)
	Set objPurpose    = ##class(DHCHAI.BT.Dictionary).GetObjById(MedPurposeDr)
	Set CombinedMedDr = $p(aInput,aSeparete,23)
	Set objCombin     = ##class(DHCHAI.BT.Dictionary).GetObjById(CombinedMedDr)
	Set chkCSSZLSbmt  = $p(aInput,aSeparete,24)
	Set OperAntiFlag  = $p(aInput,aSeparete,25)
	Set RepFinishFlag = $p(aInput,aSeparete,26)
	Set UpdateDate    = $p(aInput,aSeparete,27)
	Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UpdateDate)
	Set:UpdateDate="" UpdateDate=+$h
	Set UpdateTime    = $p(aInput,aSeparete,28)
	Set:UpdateTime[":" UpdateTime=$zth(UpdateTime,1)
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
	Set UpdateUserDr  = $p(aInput,aSeparete,29)
	Set CSSDiagnosDr  = $p(aInput,aSeparete,30)
	Set objCSSDiagnos = ##class(DHCHAI.BT.Dictionary).GetObjById(CSSDiagnosDr)
	Set objUpdateUser = ##class(DHCHAI.BT.SysUser).GetObjById(UpdateUserDr)
	Set IRFirInfDate = $p(aInput,aSeparete,31)
	Set IRTransBloodInf = $p(aInput,aSeparete,32)
	Set IRBaseRisk = $p(aInput,aSeparete,33)
	
	Set CSSSpecGL = $p(aInput,aSeparete,34)
	Set CSSSpecKS = $p(aInput,aSeparete,35)
	Set CSSSpecMZ = $p(aInput,aSeparete,36)
	Set CSSSpecJY = $p(aInput,aSeparete,37)
	Set SQMethod1 = $p(aInput,aSeparete,38)
	Set SQMethod2 = $p(aInput,aSeparete,39)
	Set SQMethod3 = $p(aInput,aSeparete,40)
	If ID="" {
		Set obj=##class(DHCHAI.IR.INFCSS).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.INFCSS).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IREpisodeDr         = objEpisodeDr
	Set obj.IRSurvNumber        = SurvNumber
	Set obj.IRSurvUser          = IRSurvUser
	Set obj.IRIsActive          = +IRIsActive
	Set obj.IRInfectionDr       = objInfection
	Set obj.IRInfCategoryDr     = objCategory
	Set obj.IRInfPathogen1      = IRInfPathogen1
	Set obj.IRInfPathogen2      = IRInfPathogen2
	Set obj.IRInfPathogen3      = IRInfPathogen3
	Set obj.IROprInf            = objOprInf
	Set obj.IRComInfPathogen1   = IRComInfPathogen1
	Set obj.IRComInfPathogen2   = IRComInfPathogen2
	Set obj.IRComInfPathogen3   = IRComInfPathogen3
	Set obj.IROperFlag          = chkCSSIsOpr
	Set obj.IROperCuteTypeDr    = objIncision
	Set obj.IROperDate          = OperDate
	Set obj.IROperName          = txtOperName
	Set obj.IRBugsAntiSen       = CRBugsAntiSen
	Set obj.IRAntiFlag          = IRAntiFlag
	Set obj.IRAntiDrList        = IRAntiDrList
	Set obj.IRAntiUsePurposeDr  = objPurpose
	Set obj.IRAntiCombinedMedDr = objCombin
	Set obj.IRAntiSenFlag       = chkCSSZLSbmt
	Set obj.IROperAntiFlag      = OperAntiFlag
	Set obj.IRRepFinishFlag     = RepFinishFlag
	Set obj.IRUpdateDate        = UpdateDate
	Set obj.IRUpdateTime        = UpdateTime
	Set obj.IRUpdateUserDr      = objUpdateUser
	Set obj.IRCSSDiagnosDr      = objCSSDiagnos
	Set obj.IRFirInfDate		= IRFirInfDate
	Set obj.IRTransBloodInf		= IRTransBloodInf
	Set obj.IRBaseRisk			= IRBaseRisk
	
	Set obj.IRCSSSpecGLFlag  = CSSSpecGL
	Set obj.IRCSSSpecKSFlag  = CSSSpecKS
	Set obj.IRCSSSpecMZFlag  = CSSSpecMZ
	Set obj.IRCSSSpecJYFlag  = CSSSpecJY
	Set obj.SQMethod1 = SQMethod1
	Set obj.SQMethod2 = SQMethod2
	Set obj.SQMethod3 = SQMethod3
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenjianbo
/// CreatDate：   2018-01-05
/// Description:  删除
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Quit:aId="" return
	Set sc = ##class(DHCHAI.IR.INFCSS).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="INFCSSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IRSurvNumber</Value>
</Value>
<Value name="4">
<Value>IRSurvUser</Value>
</Value>
<Value name="5">
<Value>IRIsActive</Value>
</Value>
<Value name="6">
<Value>IRInfectionDr</Value>
</Value>
<Value name="7">
<Value>IRInfCategoryDr</Value>
</Value>
<Value name="8">
<Value>IRInfPathogen1</Value>
</Value>
<Value name="9">
<Value>IRInfPathogen2</Value>
</Value>
<Value name="10">
<Value>IRInfPathogen3</Value>
</Value>
<Value name="11">
<Value>IROprInf</Value>
</Value>
<Value name="12">
<Value>IRComInfPathogen1</Value>
</Value>
<Value name="13">
<Value>IRComInfPathogen2</Value>
</Value>
<Value name="14">
<Value>IRComInfPathogen3</Value>
</Value>
<Value name="15">
<Value>IROperFlag</Value>
</Value>
<Value name="16">
<Value>IROperCuteTypeDr</Value>
</Value>
<Value name="17">
<Value>IROperDate</Value>
</Value>
<Value name="18">
<Value>IROperName</Value>
</Value>
<Value name="19">
<Value>IRBugsAntiSen</Value>
</Value>
<Value name="20">
<Value>IRAntiFlag</Value>
</Value>
<Value name="21">
<Value>IRAntiDrList</Value>
</Value>
<Value name="22">
<Value>IRAntiUsePurposeDr</Value>
</Value>
<Value name="23">
<Value>IRAntiCombinedMedDr</Value>
</Value>
<Value name="24">
<Value>IRAntiSenFlag</Value>
</Value>
<Value name="25">
<Value>IROperAntiFlag</Value>
</Value>
<Value name="26">
<Value>IRRepFinishFlag</Value>
</Value>
<Value name="27">
<Value>IRUpdateDate</Value>
</Value>
<Value name="28">
<Value>IRUpdateTime</Value>
</Value>
<Value name="29">
<Value>IRUpdateUserDr</Value>
</Value>
<Value name="30">
<Value>IRCSSDiagnosDr</Value>
</Value>
<Value name="31">
<Value>IRFirInfDate</Value>
</Value>
<Value name="32">
<Value>IRTransBloodInf</Value>
</Value>
<Value name="33">
<Value>IRBaseRisk</Value>
</Value>
<Value name="34">
<Value>IRCSSSpecGLFlag</Value>
</Value>
<Value name="35">
<Value>IRCSSSpecKSFlag</Value>
</Value>
<Value name="36">
<Value>IRCSSSpecMZFlag</Value>
</Value>
<Value name="37">
<Value>IRCSSSpecJYFlag</Value>
</Value>
<Value name="38">
<Value>SQMethod1</Value>
</Value>
<Value name="39">
<Value>SQMethod2</Value>
</Value>
<Value name="40">
<Value>SQMethod3</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.INFCSSD</DataLocation>
<DefaultData>INFCSSDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.INFCSSD</IdLocation>
<IndexLocation>^DHCHAI.IR.INFCSSI</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFCSSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
