/// 名称: DHCHAI.IR.INFMBR
/// 描述: 医院感染 病原学检验
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.INFMBR Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm;

/// 检验报告指针
Property IRLabRepDr As DHCHAI.DP.LabVisitReport;

/// 检验标本
Property IRSpecimenDr As DHCHAI.DP.LabSpecimen;

/// 送检日期
Property IRSubmissDate As %Date;

/// 送检科室
Property IRSubmissLocDr As DHCHAI.BT.Location;

/// 病原体
Property IRBactDicDr As DHCHAI.DP.LabBacteria;

/// 病原体
Property IRBactDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 多耐分类
Property IRMRBDicDr As DHCHAI.IR.CRuleMRB;

/// 感染类型（HA、CA、定值、污染、HA重复、CA重复、定值重复）
Property IRInfTypeDr As DHCHAI.BT.Dictionary;

/// 加强手卫生
Property IRHandHygieneDr As DHCHAI.BT.Dictionary;

/// 续发病例
Property IRSecondCaseDr As DHCHAI.BT.Dictionary;

/// 1、隔离方式（单间隔离、床旁隔离、未隔离、报告时患者已出院或转科）
Property IRInsulatTypeDr As DHCHAI.BT.Dictionary;

/// 1.1、接触隔离
Property IRContactList As %String(MAXLEN = 100, TRUNCATE = 1);

/// 1.2、飞沫隔离
Property IRDropletList As %String(MAXLEN = 100, TRUNCATE = 1);

/// 2、感染病人的安置
Property IRPlaceList As %String(MAXLEN = 100, TRUNCATE = 1);

/// 3、隔离单元的设置
Property IRUnitList As %String(MAXLEN = 100, TRUNCATE = 1);

/// 3、隔离单元的设置 其他
Property IRUintExt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 4、感染病人的诊疗
Property IRTreatMentDr As DHCHAI.BT.Dictionary;

/// 5、环境物表的处理
Property IREnvMentDr As DHCHAI.BT.Dictionary;

/// 6、用后被服的处理
Property IRClothMentDr As DHCHAI.BT.Dictionary;

/// 7、探视者的管理
Property IRVisitList As %String(MAXLEN = 100, TRUNCATE = 1);

/// 9、终末消毒
Property IREndList As %String(MAXLEN = 100, TRUNCATE = 1);

/// 10、其他
Property IRResume As %String(MAXLEN = 100, TRUNCATE = 1);

/// 11、审核总结性评价(1-落实 2-部分落实 3-未落实)
Property IRSumAssess As %Integer;

/// 更新日期
Property IRUpdateDate As %Date;

/// 更新时间
Property IRUpdateTime As %Time;

/// 更新人
Property IRUpdateUserDr As DHCHAI.BT.SysUser;

/// 12、批注  add 20211116
Property IRComments As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 外院携带多耐指针
Property IROutLabRepDr As DHCHAI.IR.OutLabReport;

/// 易感因素
Property IRDoTS As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊记录+病原学检验
Index IndexLabEpisode On (IREpisodeDr, IRLabRepDr);

/// 病原学检验+病原体
Index IndexLabRepBact On (IRLabRepDr, IRBactDicDr);

/// 更新日期索引
Index IndexUpdateDate On IRUpdateDate;

/// 送检日期索引
Index IndexSubmissDate On IRSubmissDate;

/// 外院携带多耐+病原体
Index IndexOutLabRepBact On (IROutLabRepDr, IRBactDicDr);

/// Creator：     pylian
/// CreatDate：   2017-08-10
/// Description:  根据ID取病原学检验
/// Table：       DHCHAI.IR.INFMBR
/// Input：       ID:    DHCHAI.IR.INFMBR.ID
/// Return：      返回Object
/// w ##class(DHCHAI.IR.INFMBR).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.IR.INFMBR
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.IR.INFMBR).%ExistsId(+id) return
	Set obj=##Class(DHCHAI.IR.INFMBR).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-08-16
/// Description:  根据检验报告ID、病原体ID取报告信息
/// Table：       DHCHAI.IR.INFMBR
/// Input：       aRepID:    检验报告ID
/// 			  aBactID:    病原体ID
/// Return：      返回Object
/// w ##class(DHCHAI.IR.INFMBR).GetObjByRepBact("","")
ClassMethod GetObjByRepBact(aRepID As %String, aBactID As %String) As DHCHAI.IR.INFMBR
{
	New (aRepID,aBactID)
	Set return=""
	Quit:(aRepID="")||(aBactID="") return
	
	Set ID=""
	Set xID=""
	For {
		Set xID= $o(^DHCHAI.IR.INFMBRI("IndexLabRepBact",aRepID,aBactID,xID))
		Quit:xID="" 
		Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," DHCHAI.IR.INFMBR"," "_xID,0))
		Continue:xRepID=""
		Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.IRStatusDr)
		//Continue:objRep.IRStatusDr.BTCode=4    //update 20210401 选中送检记录保存报告的形式允许作废后再次填报
		Set ID = xID
		Quit:ID'=""
	}
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-08-17
/// Description:  根据外院携带ID、病原体ID取报告信息
/// Table：       DHCHAI.IR.INFMBR
/// Input：       aRepID:    检验报告ID
/// 			  aBactID:    病原体ID
/// Return：      返回Object
/// w ##class(DHCHAI.IR.INFMBR).GetObjByOutRepBact("","")
ClassMethod GetObjByOutRepBact(aOutRepID As %String, aBactID As %String) As DHCHAI.IR.INFMBR
{
	New (aOutRepID,aBactID)
	Set return=""
	Quit:(aOutRepID="")||(aBactID="") return
	
	Set ID=""
	Set xID=""
	For {
		Set xID= $o(^DHCHAI.IR.INFMBRI("IndexOutLabRepBact",aOutRepID,aBactID,xID))
		Quit:xID="" 
		Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," DHCHAI.IR.INFMBR"," "_xID,0))
		Continue:xRepID=""
		Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.IRStatusDr)
		//Continue:objRep.IRStatusDr.BTCode=4    //update 20210401 选中送检记录保存报告的形式允许作废后再次填报
		Set ID = xID
		Quit:ID'=""
	}
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-10-12
/// Description:  判断监控结果记录中的标本、细菌是否维护标准名称对照
/// Table：       DHCHAI.IR.CCResult、DHCHAI.DP.LabBactMap、DHCHAI.DP.LabSpecMap
/// Input：       aResultID:    检验结果ID
/// Return：      返回Object
/// w ##class(DHCHAI.IR.INFMBR).CheckIsMap("58")
ClassMethod CheckIsMap(aResultID As %String) As %String
{
	New (aResultID)
	Set return=0
	Quit:(aResultID="") return
	
	Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(aResultID)
    Quit:'$Isobject(objResult) return
	Quit:objResult.CCIsActive'=1 return
    Set SCode    = objResult.CCSCode      //子系统代码
    Set Bacteria = objResult.CCBacteria   //原始细菌名称
	Set Specimen = objResult.CCSpecimen   //原始标本名称
    
	Set return=-1
	Set SpeID="",SpeCode="",SpeDesc=""
    Set objSpe=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
    If $IsObject(objSpe) {
        If $IsObject(objSpe.BTMapItemDr){
			Set SpeID=objSpe.BTMapItemDr.%Id()
			Set SpeCode=objSpe.BTMapItemDr.BTSpecCode
			Set SpeDesc=objSpe.BTMapItemDr.BTSpecDesc
		}
    }
	Quit:SpeID="" return
	
	Set return=-2
	Set BacID="",BacCode="",BacDesc=""
	Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
    If $IsObject(objBactMap){
		If $IsObject(objBactMap.BTMapItemDr){
			Set BacID=objBactMap.BTMapItemDr.%Id()
			Set BacCode=objBactMap.BTMapItemDr.BTBacCode
			Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
		}
	}
	Quit:BacID="" return
	//update 20230301  3265682多耐类型为MDR类型，细菌为未维护的多耐报告无法填写
	/*
	Set return=-3
	Set MRBFlg=""
	Set MRBFlg=$d(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BacID)) //细菌是否耐药菌
	Quit:MRBFlg=0 return	
    */
	Set return =1 
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-08-10
/// Description:  更新病原学检验
/// Table：       DHCHAI.IR.INFMBR
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.INFMBR).Update("^1^1^1^^16^1^细菌名称^1^217^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE

	Set ID			   = $p(InStr,aSeparete,1)
	Set EpisodeDr      = $p(InStr,aSeparete,2)
	Set LabRepDr       = $p(InStr,aSeparete,3)
	Set SpecimenDr     = $p(InStr,aSeparete,4) 
	Set SubmissDate    = $p(InStr,aSeparete,5)
	Set SubmissLocDr   = $p(InStr,aSeparete,6)
	Set BactDicDr      = $p(InStr,aSeparete,7)
	Set BactDesc       = $p(InStr,aSeparete,8)
	Set MRBDicDr       = $p(InStr,aSeparete,9)
	Set InfTypeDr      = $p(InStr,aSeparete,10)
	Set HandHygieneDr  = $p(InStr,aSeparete,11)
	Set SecondCaseDr   = $p(InStr,aSeparete,12)
	Set InsulatTypeDr  = $p(InStr,aSeparete,13)
	Set ContactList    = $p(InStr,aSeparete,14)
	Set DropletList    = $p(InStr,aSeparete,15)
	Set PlaceList      = $p(InStr,aSeparete,16)
	Set UnitList       = $p(InStr,aSeparete,17)
	Set UintExt        = $p(InStr,aSeparete,18)
	Set TreatMentDr    = $p(InStr,aSeparete,19)
	Set EnvMentDr      = $p(InStr,aSeparete,20)
	Set ClothMentDr    = $p(InStr,aSeparete,21) 
	Set VisitList      = $p(InStr,aSeparete,22)
	Set EndList        = $p(InStr,aSeparete,23)
	Set Resume         = $p(InStr,aSeparete,24)
	Set UpdateDate     = $p(InStr,aSeparete,25)
	Set UpdateTime     = $p(InStr,aSeparete,26)
	Set UpdateUserDr   = $p(InStr,aSeparete,27)
	Set RepAssess      = $p(InStr,aSeparete,28)
	Set Comments       = $p(InStr,aSeparete,29)
	Set OutLabRepDr    = $p(InStr,aSeparete,30)
	Set DoTS    	   = $p(InStr,aSeparete,31)
	Set:SubmissDate'="" SubmissDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(SubmissDate)
	Set:UpdateDate'="" UpdateDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UpdateDate)
	Set:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)
	Set:UpdateDate="" UpdateDate=+$h
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
    Quit:(EpisodeDr="")||(SpecimenDr="")||(BactDicDr="") return
   
     //报告+细菌唯一   	
     //Set tID =$o(^DHCHAI.IR.INFMBRI("IndexLabRepBact",LabRepDr,BactDicDr,0)) 
     Set objInfMBR =##class(DHCHAI.IR.INFMBR).GetObjByRepBact(LabRepDr,BactDicDr)
     If (OutLabRepDr'="") {
	     Set objInfMBR =##class(DHCHAI.IR.INFMBR).GetObjByOutRepBact(OutLabRepDr,BactDicDr)
     }
     If $IsObject(objInfMBR) {
	     Set tID =objInfMBR.%Id()
		 Quit:(ID'="")&(ID'=tID) -100
     }
    Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
    Set objRep = ##class(DHCHAI.DP.LabVisitReport).GetObjById(LabRepDr)
    Set objSpe = ##class(DHCHAI.DP.LabSpecimen).GetObjById(SpecimenDr)
    Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(SubmissLocDr)
    Set objBac = ##class(DHCHAI.DP.LabBacteria).GetObjById(BactDicDr)
    Set objMRB = ##class(DHCHAI.IR.CRuleMRB).GetObjById(MRBDicDr)
    Set objInf = ##class(DHCHAI.BT.Dictionary).GetObjById(InfTypeDr)
    Set objIns = ##class(DHCHAI.BT.Dictionary).GetObjById(InsulatTypeDr)
    Set objTreat = ##class(DHCHAI.BT.Dictionary).GetObjById(TreatMentDr)
    Set objEnv = ##class(DHCHAI.BT.Dictionary).GetObjById(EnvMentDr)
    Set objCloth = ##class(DHCHAI.BT.Dictionary).GetObjById(ClothMentDr)
    Set objCase = ##class(DHCHAI.BT.Dictionary).GetObjById(SecondCaseDr)
    Set objHand = ##class(DHCHAI.BT.Dictionary).GetObjById(HandHygieneDr)
    Set objUser = ##class(DHCHAI.BT.SysUser).GetObjById(UpdateUserDr)
    Set Comments=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Comments) //去掉特殊字符
    Set objOutLab = ##class(DHCHAI.IR.OutLabReport).GetObjById(OutLabRepDr)
	if ID="" {
		Set obj=##class(DHCHAI.IR.INFMBR).%New()
	}else{
		Set obj=##class(DHCHAI.IR.INFMBR).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IREpisodeDr      = objAdm     
	Set obj.IRLabRepDr       = objRep      
	Set obj.IRSpecimenDr     = objSpe    
	Set obj.IRSubmissDate    = SubmissDate   
	Set obj.IRSubmissLocDr   = objLoc  
	Set obj.IRBactDicDr      = objBac     
	Set obj.IRBactDesc       = BactDesc      
	Set obj.IRMRBDicDr       = objMRB      
	Set obj.IRInfTypeDr      = objInf     
	Set obj.IRHandHygieneDr  = objHand 
	Set obj.IRSecondCaseDr   = objCase 
	Set obj.IRInsulatTypeDr  = objIns  
	Set obj.IRContactList    = ContactList     
	Set obj.IRDropletList    = DropletList     
	Set obj.IRPlaceList      = PlaceList   
	Set obj.IRUnitList       = UnitList    
	Set obj.IRUintExt        = UintExt       
	Set obj.IRTreatMentDr    = objTreat   
	Set obj.IREnvMentDr      = objEnv     
	Set obj.IRClothMentDr    = objCloth   
	Set obj.IRVisitList      = VisitList   
	Set obj.IREndList        = EndList
	Set obj.IRResume         = Resume        
	Set obj.IRUpdateDate     = UpdateDate    
	Set obj.IRUpdateTime     = UpdateTime    
	Set obj.IRUpdateUserDr   = objUser 
	Set obj.IRSumAssess      = RepAssess //新增总结性评价
	Set obj.IRComments       = Comments
	Set obj.IROutLabRepDr    = objOutLab
	Set obj.IRDoTS    		 = DoTS     //易感因素
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-08-10
/// Description:  删除病原学检验
/// Table：       DHCHAI.IR.INFMBR
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.IR.INFMBR).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="INFMBRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IRLabRepDr</Value>
</Value>
<Value name="4">
<Value>IRSpecimenDr</Value>
</Value>
<Value name="5">
<Value>IRSubmissDate</Value>
</Value>
<Value name="6">
<Value>IRSubmissLocDr</Value>
</Value>
<Value name="7">
<Value>IRBactDicDr</Value>
</Value>
<Value name="8">
<Value>IRBactDesc</Value>
</Value>
<Value name="9">
<Value>IRMRBDicDr</Value>
</Value>
<Value name="10">
<Value>IRInfTypeDr</Value>
</Value>
<Value name="11">
<Value>IRHandHygieneDr</Value>
</Value>
<Value name="12">
<Value>IRSecondCaseDr</Value>
</Value>
<Value name="13">
<Value>IRInsulatTypeDr</Value>
</Value>
<Value name="14">
<Value>IRContactList</Value>
</Value>
<Value name="15">
<Value>IRDropletList</Value>
</Value>
<Value name="16">
<Value>IRPlaceList</Value>
</Value>
<Value name="17">
<Value>IRUnitList</Value>
</Value>
<Value name="18">
<Value>IRUintExt</Value>
</Value>
<Value name="19">
<Value>IRTreatMentDr</Value>
</Value>
<Value name="20">
<Value>IREnvMentDr</Value>
</Value>
<Value name="21">
<Value>IRClothMentDr</Value>
</Value>
<Value name="22">
<Value>IRVisitList</Value>
</Value>
<Value name="23">
<Value>IREndList</Value>
</Value>
<Value name="24">
<Value>IRResume</Value>
</Value>
<Value name="25">
<Value>IRUpdateDate</Value>
</Value>
<Value name="26">
<Value>IRUpdateTime</Value>
</Value>
<Value name="27">
<Value>IRUpdateUserDr</Value>
</Value>
<Value name="28">
<Value>IRSumAssess</Value>
</Value>
<Value name="29">
<Value>IRComments</Value>
</Value>
<Value name="30">
<Value>IROutLabRepDr</Value>
</Value>
<Value name="31">
<Value>IRDoTS</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.INFMBRD</DataLocation>
<DefaultData>INFMBRDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.INFMBRD</IdLocation>
<IndexLocation>^DHCHAI.IR.INFMBRI</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFMBRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
