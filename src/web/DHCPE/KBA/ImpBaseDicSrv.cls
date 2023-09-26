/// 名称: web.DHCPE.KBA.ImpBaseDicSrv
/// 描述: 健康体检知识库-基础字典导入
/// 编写者：zhufei
/// 编写日期: 2021-11-12
Class web.DHCPE.KBA.ImpBaseDicSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2021-11-12
/// Description:  导入站点代码表
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.ImpBaseDicSrv).SaveStationDic()
ClassMethod SaveStationDic(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aDelimiter)="" aDelimiter="^"
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set Code          = $p(aInputStr,aDelimiter,2)    //站点代码
	Set Desc          = $p(aInputStr,aDelimiter,3)    //站点描述
	Set Active        = $p(aInputStr,aDelimiter,4)    //是否有效
	Set KBXCode       = $p(aInputStr,aDelimiter,5)    //知识库外部码
	Set KBItemCatDesc = $p(aInputStr,aDelimiter,6)    //知识库站点名称
	Quit:(Code="")||(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	Set tID=$o(^DHCPEST(0,"Code",$$ALPHAUP^SSUTIL4(Code),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -101  //返回错误提示：名称不唯一
	
	If ID="" {
		Set obj=##class(User.DHCPEStation).%New()
	}Else{
		Set obj=##class(User.DHCPEStation).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.STCode          = Code
	Set obj.STDesc          = Desc
	Set obj.STActive        = Active
	Set obj.STKBXCode       = KBXCode
	Set obj.STKBItemCatDesc = KBItemCatDesc
	Set obj.STUpdateDate    = +$h
	Set obj.STUpdateTime    = $p($h,",",2)
	
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

/// w ##class(web.DHCPE.KBA.ImpBaseDicSrv).ChangeStationCode()
ClassMethod ChangeStationCode()
{
	Set xID=0
	For {
		Set xID=$o(^DHCPEST(xID))
		Quit:xID=""
		Set obj=##class(User.DHCPEStation).%OpenId(xID)
		If $e(obj.STCode,1,1)="U" {
			Set obj.STCode = $e(obj.STCode,2,*)
			Set sc=obj.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
	   			Do $system.OBJ.DisplayError(sc)
			}
		}
		Do obj.%Close()
	}
	Quit "OK"
}

/// Creator：     zhufei
/// CreatDate：   2021-11-12
/// Description:  导入站点分类代码表
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.ImpBaseDicSrv).SaveStationLocDic("^U200^检验^临检^20100^Y^U201^临检")
ClassMethod SaveStationLocDic(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aDelimiter)="" aDelimiter="^"
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set STCode        = $p(aInputStr,aDelimiter,2)    //站点代码
	Set STDesc        = $p(aInputStr,aDelimiter,3)    //站点名称
	Set STLDesc       = $p(aInputStr,aDelimiter,4)    //站点分类
	Set Sort          = $p(aInputStr,aDelimiter,5)    //顺序号
	Set Active        = $p(aInputStr,aDelimiter,6)    //是否有效
	Set KBXCode       = $p(aInputStr,aDelimiter,7)    //知识库外部码
	Set KBItemCatDesc = $p(aInputStr,aDelimiter,8)    //知识库站点名称
	Quit:(STCode="")||(STLDesc="") return
	
	Set STID=$o(^DHCPEST(0,"Code",$$ALPHAUP^SSUTIL4(STCode),0))
	Quit:STID="" return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	Set tSub=$o(^DHCPEST(0,"STL","Desc",$$ALPHAUP^SSUTIL4(STLDesc),STID,0))
	If tSub="" {
		&SQL(insert into Sqluser.DHC_PE_StationLoc (STL_ParRef,STL_LocDesc,STL_LocSort) values (:STID,:STLDesc,:Sort))
	}
	
	Set tSub=$o(^DHCPEST(0,"STL","Desc",$$ALPHAUP^SSUTIL4(STLDesc),STID,0))
	Set tID=$s(tSub'="":STID_"||"_tSub,1:"")
	Set:(ID="") ID=tID
	Quit:(tID'="")&(ID'=tID) -101  //返回错误提示：名称不唯一
	
	Set obj=##class(User.DHCPEStationLoc).%OpenId(ID)
	Quit:'$IsObject(obj) return
	
	Set obj.STLLocDesc           = STLDesc
	Set obj.STLLocSort           = Sort
	Set obj.STLNoActive          = Active
	Set obj.STLKBXCode           = KBXCode
	Set obj.STLKBItemCatDesc     = KBItemCatDesc
	Set obj.STLUpdateDate        = +$h
	Set obj.STLUpdateTime        = $p($h,",",2)
	
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

/// Creator：     zhufei
/// CreatDate：   2021-11-26
/// Description:  导入职业健康处理意见
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.ImpBaseDicSrv).SaveHandlingOpinions("")
ClassMethod SaveHandlingOpinions(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aDelimiter)="" aDelimiter="^"
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set LocGrpID      = $p(aInputStr,aDelimiter,2)    //科室组ID
	Set Code          = $p(aInputStr,aDelimiter,3)    //职业健康处理意见代码
	Set Desc          = $p(aInputStr,aDelimiter,4)    //职业健康处理意见
	Set ConclusionCode= $p(aInputStr,aDelimiter,5)    //职业病结论分类代码
	Set ConclusionDesc= $p(aInputStr,aDelimiter,6)    //职业病结论分类名称
	Set OMETypeCode   = $p(aInputStr,aDelimiter,7)    //职业病检查种类代码
	Set OMETypeDesc   = $p(aInputStr,aDelimiter,8)    //职业病检查种类名称
	Set Sort          = $p(aInputStr,aDelimiter,9)    //顺序号
	Set Active        = $p(aInputStr,aDelimiter,10)   //是否有效
	Set Remark        = $p(aInputStr,aDelimiter,11)   //备注
	Quit:(LocGrpID="")||(Code="")||(Desc="") return
	
	Set ConclusionDr=$o(^User.DHCPEConclusionI("CCodeIndex"," "_$zcvt(ConclusionCode,"U"),0))
	Set OMETypeDr=$o(^User.DHCPEOMETypeI("OMETCodeIndex"," "_$zcvt(OMETypeCode,"U"),0))
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	Set HandlingOpinionsDr=""
	Set xID=0
	For {
		Set xID=$o(^User.DHCPEHandlingOpinionsI("HOCodeIndex"," "_$zcvt(Code,"U"),xID))
		Quit:xID=""
		
    	Continue:##class(User.DHCPEHandlingOpinions).GetLocShowDataFlag(xID,LocGrpID)'="Y"
    	Set HandlingOpinionsDr=xID
    	Quit
	}
	
	If HandlingOpinionsDr="" {
		Set obj=##class(User.DHCPEHandlingOpinions).%New()
	} Else {
		Set obj=##class(User.DHCPEHandlingOpinions).%OpenId(HandlingOpinionsDr)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.HOCode            = Code
	Set obj.HOOMETypeDR       = ##class(User.DHCPEOMEType).GetObjById(OMETypeDr)
	Set obj.HOConclusionDR    = ##class(User.DHCPEConclusion).GetObjById(ConclusionDr)
	Set obj.HODesc            = Desc
	Set obj.HOSort            = Sort
	Set obj.HOActive          = Active
	Set obj.HORemark          = Remark
	Set obj.HOUpdateDate      = +$h
	Set obj.HOUpdateTime      = $p($h,",",2)
	Set obj.HOUpdateUserDR    = ""
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
		Set flg=##class(User.DHCPEHandlingOpinions).SaveDataToPowerControl(obj.%Id(),LocGrpID,"")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2021-11-26
/// Description:  导入建议级别字典
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.ImpBaseDicSrv).SaveEDClass("^152^1^超重^Y^")
ClassMethod SaveEDClass(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aDelimiter)="" aDelimiter="^"
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set LocGrpID      = $p(aInputStr,aDelimiter,2)    //科室组ID
	Set Code          = $p(aInputStr,aDelimiter,3)    //建议级别代码
	Set Desc          = $p(aInputStr,aDelimiter,4)    //建议级别
	Set Active        = $p(aInputStr,aDelimiter,5)    //是否有效
	Set Remark        = $p(aInputStr,aDelimiter,6)    //备注
	Quit:(LocGrpID="")||(Code="")||(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	Set EDClassDr=""
	Set xID=0
	For {
		Set xID=$o(^DHCPEEDC(0,"Code",Code,xID))
		Quit:xID=""
		
    	Continue:##class(User.DHCPEEDClass).GetLocShowDataFlag(xID,LocGrpID)'="Y"
    	Set EDClassDr=xID
    	Quit
	}
	
	If EDClassDr="" {
		Set obj=##class(User.DHCPEEDClass).%New()
	} Else {
		Set obj=##class(User.DHCPEEDClass).%OpenId(EDClassDr)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EDCCode           = Code
	Set obj.EDCDesc           = Desc
	Set obj.EDCNoActive       = Active
	Set obj.EDCUpdateDate     = +$h
	Set obj.EDCUpdateTime     = $p($h,",",2)
	Set obj.EDCUpdateUserDR   = ""
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
		Set flg=##class(User.DHCPEEDClass).SaveDataToPowerControl(obj.%Id(),LocGrpID,"")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2021-12-17
/// Description:  导入标准问卷（量表）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.ImpBaseDicSrv).SaveHMCQuestionsDetail()
ClassMethod SaveHMCQuestionsDetail(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aDelimiter)="" aDelimiter="^"
	Set ID            = $p(aInputStr,aDelimiter,1)      //ID
	Set Code          = $p(aInputStr,aDelimiter,2)      //问题代码
	Set Desc          = $p(aInputStr,aDelimiter,3)      //问卷问题
	Set Type          = $p(aInputStr,aDelimiter,4)      //项目类型
	Set Unit          = $p(aInputStr,aDelimiter,5)      //单位
	Set Sex           = $p(aInputStr,aDelimiter,6)      //性别
	Set Active        = $p(aInputStr,aDelimiter,7)      //是否有效
	Set Required      = $p(aInputStr,aDelimiter,8)      //是否必填项
	Set ElementNum    = $p(aInputStr,aDelimiter,9)      //一行显示数量
	Set MaxValue      = $p(aInputStr,aDelimiter,10)     //录入值上限
	Set MinValue      = $p(aInputStr,aDelimiter,11)     //录入值下限
	Set RangeMax      = $p(aInputStr,aDelimiter,12)     //参考值上限
	Set RangeMin      = $p(aInputStr,aDelimiter,13)     //参考值下限
	Set Defvalue      = $p(aInputStr,aDelimiter,14)     //默认值
	Set Note          = $p(aInputStr,aDelimiter,15)     //解释说明
	Set NoteType      = $p(aInputStr,aDelimiter,16)     //解释说明类型
	Set Remark        = $p(aInputStr,aDelimiter,17)     //备注
	Set UpdateUserDR  = $p(aInputStr,aDelimiter,18)     //更新人
	Quit:(Code="")||(Desc="")||(Type="") return
	
	Set (LinkCode,LinkDesc,LinkUnit,LinkBreak,Iherit,ParentDR)=""
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	Set NoteType=$s(NoteType["文本":"T",NoteType["T":"T",NoteType["图":"P",NoteType["P":"P",1:"")
	//性别
	Set SexDr=""
	If Sex'="" {
		Set SexDr=$o(^CT("SEX",0,"Code",$zcvt(Sex,"U"),0))
		Set:SexDr="" SexDr=$o(^CT("SEX",0,"Desc",$zcvt(Sex,"U"),0))
	}
	
	Set ID=$o(^User.DHCHMCQuestionsDetailI("QDCodeIndex"," "_$zcvt(Code,"U"),0))
	If ID="" {
		Set obj=##class(User.DHCHMCQuestionsDetail).%New()
	} Else {
		Set obj=##class(User.DHCHMCQuestionsDetail).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.QDCode          = Code         //问题代码
	Set obj.QDDesc          = Desc         //问题描述
	Set obj.QDType          = Type         //项目类型（T说明型，N数值型， M多选型，S单选型，D日期型）
	Set obj.QDUnit          = Unit         //单位
	Set obj.QDSex           = SexDr        //性别 指向CT_Sex
	Set obj.QDRequired      = Required     //是否必填项
	Set obj.QDLinkCode      = LinkCode     //关联体检结果
	Set obj.QDElementNum    = ElementNum   //一行显示数量
	Set obj.QDRemark        = Remark       //备注
	Set obj.QDNote          = Note         //解释说明
	Set obj.QDNoteType      = NoteType     //解释说明类型（P图片，T文本）
	Set obj.QDLinkDesc      = LinkDesc     //关联描述
	Set obj.QDLinkUnit      = LinkUnit     //关联单位
	Set obj.QDLinkBreak     = LinkBreak    //关联分隔符
	Set obj.QDMaxValue      = MaxValue     //录入值上限
	Set obj.QDMinValue      = MinValue     //录入值下限
	Set obj.QDRangeMax      = RangeMax     //参考值上限
	Set obj.QDRangeMin      = RangeMin     //参考值下限
	Set obj.QDIherit        = Iherit       //继承方式
	Set obj.QDDefvalue      = Defvalue     //默认值
	Set obj.QDParentDR      = ParentDR     //父节点
	Set obj.QDActive        = Active       //激活
	Set obj.QDUpdateDate    = +$h          //更新日期
	Set obj.QDUpdateTime    = $p($h,",",2) //更新时间
	Set obj.QDUpdateUserDR  = ""           //更信人 指向SS_User
	
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

/// Creator：     zhufei
/// CreatDate：   2021-12-17
/// Description:  导入问卷问题选项
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.ImpBaseDicSrv).SaveHMCQDOptions("^PAT00002^性别^0^未知的性别^^^^0^是^^Demo用户")
ClassMethod SaveHMCQDOptions(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aDelimiter)="" aDelimiter="^"
	Set ID            = $p(aInputStr,aDelimiter,1)      //ID
	Set CQDCode       = $p(aInputStr,aDelimiter,2)      //问题代码
	Set CQDDesc       = $p(aInputStr,aDelimiter,3)      //问卷问题
	Set Code          = $p(aInputStr,aDelimiter,4)      //选项代码
	Set Desc          = $p(aInputStr,aDelimiter,5)      //选项描述
	Set Score         = $p(aInputStr,aDelimiter,6)      //选项评分
	Set Sex           = $p(aInputStr,aDelimiter,7)      //性别限定
	Set Default       = $p(aInputStr,aDelimiter,8)      //默认值
	Set Sort          = $p(aInputStr,aDelimiter,9)      //顺序号
	Set Active        = $p(aInputStr,aDelimiter,10)     //是否有效
	Set Note          = $p(aInputStr,aDelimiter,11)     //备注
	Set UpdateUserDR  = $p(aInputStr,aDelimiter,12)     //更新人
	Quit:(CQDCode="")||(CQDDesc="")||(Code="")||(Desc="") return
	
	Set CQDID=$o(^User.DHCHMCQuestionsDetailI("QDCodeIndex"," "_$zcvt(CQDCode,"U"),0))
	Quit:CQDID="" return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	//性别
	Set SexDr=""
	If Sex'="" {
		Set SexDr=$o(^CT("SEX",0,"Code",$zcvt(Sex,"U"),0))
		Set:SexDr="" SexDr=$o(^CT("SEX",0,"Desc",$zcvt(Sex,"U"),0))
	}
	
	Set Sub=$o(^User.DHCHMCQDOptionsI("IdxOfParRefCode",CQDID," "_$zcvt(Code,"U"),0))
	If Sub="" {
		Set obj=##class(User.DHCHMCQDOptions).%New()
	} Else {
		Set obj=##class(User.DHCHMCQDOptions).%OpenId(CQDID_"||"_Sub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.QDOParRef       = ##class(User.DHCHMCQuestionsDetail).GetObjById(CQDID)
	Set obj.QDOCode         = Code         //选项代码
	Set obj.QDODesc         = Desc         //选项描述
	Set obj.QDOClass        = Score        //选项评分
	Set obj.QDOSex          = SexDr        //性别限定
	Set obj.QDODefault      = Default      //默认值
	Set obj.QDOOrder        = Sort         //顺序号
	Set obj.QDOActive       = Active       //是否有效
	Set obj.QDONote         = Note         //备注
	Set obj.QDOUpdateDate   = +$h          //更新日期
	Set obj.QDOUpdateTime   = $p($h,",",2) //更新时间
	Set obj.QDOUpdateUserDR = ""           //更信人 指向SS_User
	
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

/// Creator：     zhufei
/// CreatDate：   2021-12-17
/// Description:  导入调查问卷分类
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.ImpBaseDicSrv).SaveHMSubjectAndCat("^JKTJZCWJ^健康体检自测问卷^是^^01^基本信息^一、^01^是^^Demo用户")
ClassMethod SaveHMSubjectAndCat(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aDelimiter)="" aDelimiter="^"
	Set ID            = $p(aInputStr,aDelimiter,1)      //ID
	Set SCode         = $p(aInputStr,aDelimiter,2)      //问卷代码
	Set SDesc         = $p(aInputStr,aDelimiter,3)      //问卷描述
	Set SActive       = $p(aInputStr,aDelimiter,4)      //问卷是否有效
	Set SRemark       = $p(aInputStr,aDelimiter,5)      //问卷备注
	Set SCCode        = $p(aInputStr,aDelimiter,6)      //分组代码
	Set SCDesc        = $p(aInputStr,aDelimiter,7)      //分组描述
	Set SCNumber      = +$p(aInputStr,aDelimiter,8)     //分组编号
	Set SCSort        = +$p(aInputStr,aDelimiter,9)     //分组顺序号
	Set SCActive      = $p(aInputStr,aDelimiter,10)     //分组是否有效
	Set SCRemark      = $p(aInputStr,aDelimiter,11)     //分组备注说明
	Set UpdateUserDR  = $p(aInputStr,aDelimiter,12)     //更新人
	Quit:(SCode="")||(SDesc="")||(SCCode="")||(SCDesc="") return
	
	Set SActive=$s(SActive["Y":"Y",SActive["是":"Y",1:"N")
	Set SCActive=$s(SCActive["Y":"Y",SCActive["是":"Y",1:"N")
	
	Set ID=$o(^CT.PE.HM.CQDSubjectI("IndexCode"," "_$zcvt(SCode,"U"),0))
	If ID="" {
		Set obj=##class(User.DHCHMCQDSubject).%New()
	} Else {
		Set obj=##class(User.DHCHMCQDSubject).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.QDSCode         = SCode          //问卷代码
	Set obj.QDSDesc         = SDesc          //问卷描述
	Set obj.QDSActive       = SActive        //是否有效
	Set obj.QDSUpdateDate   = +$h            //更新日期
	Set obj.QDSUpdateTime   = $p($h,",",2)   //更新时间
	Set obj.QDSUpdateUserDR = ""             //更新人 指向SS_User
	Set obj.QDSRemark       = SRemark        //备注信息
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set SID=obj.%Id()
		Set return=SID
	}
	Do obj.%Close()
	Quit:(return<0) return
	
	Set Sub=$o(^CT.PE.HM.CQDSubjectI("CAT","IdxOfParRefCode",SID," "_$zcvt(SCCode,"U"),0))
	If Sub="" {
		Set obj=##class(User.DHCHMCQDSubjectCat).%New()
	} Else {
		Set obj=##class(User.DHCHMCQDSubjectCat).%OpenId(SID_"||"_Sub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.QDSCParRef       = ##class(User.DHCHMCQDSubject).GetObjById(SID)
	Set obj.QDSCCode         = SCCode        //分组代码
	Set obj.QDSCDesc         = SCDesc        //问卷分组
	Set obj.QDSCNumber       = SCNumber      //分组编码
	Set obj.QDSCSort         = SCSort        //顺序号
	Set obj.QDSCActive       = SCActive      //是否有效
	Set obj.QDSCUpdateDate   = +$h           //更新日期
	Set obj.QDSCUpdateTime   = $p($h,",",2)  //更新时间
	Set obj.QDSCUpdateUserDR = ""            //更新人 指向SS_User
	Set obj.QDSCParentDR     = ""            //父节点
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set SCID=obj.%Id()
		Set return=SCID
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2021-12-17
/// Description:  导入调查问卷
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.ImpBaseDicSrv).SaveHMSubjectDtl("^JKTJZCWJ^健康体检自测问卷^基本信息^PAT00001^姓名^^^^01^是^^Demo用户")
ClassMethod SaveHMSubjectDtl(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aDelimiter)="" aDelimiter="^"
	Set ID            = $p(aInputStr,aDelimiter,1)      //ID
	Set SCode         = $p(aInputStr,aDelimiter,2)      //问卷代码
	Set SDesc         = $p(aInputStr,aDelimiter,3)      //问卷描述
	Set SCDesc        = $p(aInputStr,aDelimiter,4)      //分组描述
	Set SDCode        = $p(aInputStr,aDelimiter,5)      //问题代码
	Set SDDesc        = $p(aInputStr,aDelimiter,6)      //问卷问题
	Set SDRequired    = $p(aInputStr,aDelimiter,7)      //是否必填项
	Set SDDefvalue    = $p(aInputStr,aDelimiter,8)      //默认值
	Set SDNumber      = $p(aInputStr,aDelimiter,9)      //问题编号
	Set SDSort        = +$p(aInputStr,aDelimiter,10)    //顺序号
	Set SDActive      = $p(aInputStr,aDelimiter,11)     //是否有效
	Set SDRemark      = $p(aInputStr,aDelimiter,12)     //备注
	Set UpdateUserDR  = $p(aInputStr,aDelimiter,13)     //更新人
	Quit:(SCode="")||(SDesc="")||(SCDesc="")||(SDCode="")||(SDDesc="") return
	
	Set SDActive=$s(SDActive["Y":"Y",SDActive["是":"Y",1:"N")
	
	Set SID=$o(^CT.PE.HM.CQDSubjectI("IndexCode"," "_$zcvt(SCode,"U"),0))
	Quit:SID="" return //无对应问卷
	
	Set CQDID=$o(^User.DHCHMCQuestionsDetailI("QDCodeIndex"," "_$zcvt(SDCode,"U"),0))
	Quit:CQDID="" return //无对应问题
	
	Set SCID=""
	Set Sub=$o(^CT.PE.HM.CQDSubjectI("CAT","IdxOfParRefDesc",SID," "_$zcvt(SCDesc,"U"),0))
	If Sub'="" {
		Set SCID=SID_"||"_Sub
	}
	Quit:SCID="" return
	
	Set Sub=$o(^CT.PE.HM.CQDSubjectI("DTL","IdxOfSubjectCatDtl",SID,SCID,CQDID,0))
	If Sub="" {
		Set obj=##class(User.DHCHMCQDSubjectDtl).%New()
	} Else {
		Set obj=##class(User.DHCHMCQDSubjectDtl).%OpenId(SID_"||"_Sub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.QDSDParRef           = ##class(User.DHCHMCQDSubject).GetObjById(SID)
	Set obj.QDSDQustionDetailDR  = ##class(User.DHCHMCQuestionsDetail).GetObjById(CQDID) //问卷问题
	Set obj.QDSDSubjectCatDR     = ##class(User.DHCHMCQDSubjectCat).GetObjById(SCID) //问题分类
	Set obj.QDSDRequired         = SDRequired      //是否必填项
	Set obj.QDSDDefvalue         = SDDefvalue      //默认值
	Set obj.QDSDNumber           = SDNumber        //显示编号
	Set obj.QDSDSort             = SDSort          //顺序号
	Set obj.QDSDActive           = SDActive        //激活
	Set obj.QDSDUpdateDate       = +$h             //更新日期
	Set obj.QDSDUpdateTime       = $p($h,",",2)    //更新时间
	Set obj.QDSDUpdateUserDR     = ""              //更新人 指向SS_User
	Set obj.QDSDParentDR         = ""              //父节点
	
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

/// Creator：     zhufei
/// CreatDate：   2021-12-17
/// Description:  导入问卷评估内容
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.ImpBaseDicSrv).SaveHMCEvalDtl()
ClassMethod SaveHMCEvalDtl(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aDelimiter)="" aDelimiter="^"
	Set ID            = $p(aInputStr,aDelimiter,1)      //ID
	Set SCode         = $p(aInputStr,aDelimiter,2)      //问卷代码
	Set SDesc         = $p(aInputStr,aDelimiter,3)      //问卷描述
	Set EDCode        = $p(aInputStr,aDelimiter,4)      //评估内容代码
	Set EDDesc        = $p(aInputStr,aDelimiter,5)      //评估内容描述
	Set EDType        = $p(aInputStr,aDelimiter,6)      //结果类型
	Set EDSex         = $p(aInputStr,aDelimiter,7)      //性别限定
	Set EDSort        = +$p(aInputStr,aDelimiter,8)     //顺序号
	Set EDActive      = $p(aInputStr,aDelimiter,9)      //是否有效
	Set EDNote        = $p(aInputStr,aDelimiter,10)     //备注
	Set EDClassName   = $p(aInputStr,aDelimiter,11)     //类名
	Set EDMethodName  = $p(aInputStr,aDelimiter,12)     //方法名
	Set EDExpression  = $p(aInputStr,aDelimiter,13)     //计算表达式
	Set UpdateUserDR  = $p(aInputStr,aDelimiter,14)     //更新人
	Quit:(SCode="")||(SDesc="")||(EDCode="")||(EDDesc="")||(EDType="") return
	
	Set EDActive=$s(EDActive["Y":"Y",EDActive["是":"Y",1:"N")
	
	Set SID=$o(^CT.PE.HM.CQDSubjectI("IndexCode"," "_$zcvt(SCode,"U"),0))
	Quit:SID="" return //无对应问卷
	
	Set ID=$o(^User.DHCHMCEvaluationDetailI("IdxOfQuesCode",SID," "_$zcvt(EDCode,"U"),0))
	If ID="" {
		Set obj=##class(User.DHCHMCEvaluationDetail).%New()
	} Else {
		Set obj=##class(User.DHCHMCEvaluationDetail).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EDCode         = EDCode          //代码
	Set obj.EDDesc         = EDDesc          //描述
	Set obj.EDType         = EDType          //结果类型（评估项目I、评估因子F、评估结果R）
	Set obj.EDSex          = EDSex           //性别限定
	Set obj.EDActive       = EDActive        //激活
	Set obj.EDNote         = EDNote          //备注说明/表达式说明
	Set obj.EDRelateCode   = ""              //外部关联码
	Set obj.EDClassName    = EDClassName     //类名
	Set obj.EDMethodName   = EDMethodName    //方法名
	Set obj.EDCQDSubjectDR = ##class(User.DHCHMCQDSubject).GetObjById(SID)  //问卷量表(主题)定义表
	Set obj.EDExpression   = EDExpression    //计算表达式
	Set obj.EDSort         = EDSort          //顺序号
	Set obj.EDUpdateDate   = +$h             //更新日期
	Set obj.EDUpdateTime   = $p($h,",",2)    //更新时间
	Set obj.EDUpdateUserDR = ""              //更新人 指向SS_User
	
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

/// Creator：     zhufei
/// CreatDate：   2021-12-17
/// Description:  导入问诊知识库
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.ImpBaseDicSrv).SaveHMInquiryResult(^ZF(431))
ClassMethod SaveHMInquiryResult(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aDelimiter)="" aDelimiter="^"
	Set ID            = $p(aInputStr,aDelimiter,1)      //ID
	Set ITCode        = $p(aInputStr,aDelimiter,2)      //问诊类型代码
	Set ITDesc        = $p(aInputStr,aDelimiter,3)      //问诊类型
	Set ITSort        = +$p(aInputStr,aDelimiter,4)     //顺序号
	Set ITActive      = $p(aInputStr,aDelimiter,5)      //是否有效
	Set IRCode        = $p(aInputStr,aDelimiter,6)      //问诊结果代码
	Set IRDesc        = $p(aInputStr,aDelimiter,7)      //问诊结果
	Set IRSort        = +$p(aInputStr,aDelimiter,8)     //顺序号
	Set IRActive      = $p(aInputStr,aDelimiter,9)      //是否有效
	Set IRDIntroduce  = $p(aInputStr,aDelimiter,10)     //基本介绍
	Set IRDAdvice     = $p(aInputStr,aDelimiter,11)     //健康建议
	Set IRDRemark     = $p(aInputStr,aDelimiter,12)     //备注
	Set UpdateUserDR  = $p(aInputStr,aDelimiter,13)     //更新人
	Quit:(ITCode="")||(ITDesc="")||(IRCode="")||(IRDesc="")||(IRDIntroduce="") return
	
	Set ITActive=$s(ITActive["Y":"Y",ITActive["是":"Y",1:"N")
	Set IRActive=$s(IRActive["Y":"Y",IRActive["是":"Y",1:"N")
	
	Set ID=$o(^User.DHCHMInquiryTypeI("CodeIndex"," "_$zcvt(ITCode,"U"),0))
	If ID="" {
		Set obj=##class(User.DHCHMInquiryType).%New()
	} Else {
		Set obj=##class(User.DHCHMInquiryType).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ITCode          = ITCode       //代码
	Set obj.ITDesc          = ITDesc       //描述
	Set obj.ITSort          = ITSort       //序号
	Set obj.ITNoActive      = ITActive     //作废标记
	Set obj.ITUpdateDate    = +$h          //更新日期
	Set obj.ITUpdateTime    = $p($h,",",2) //更新时间
	Set obj.ITUpdateUserDR  = ""           //更信人 指向SS_User
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set ITID=obj.%Id()
		Set return=ITID
	}
	Do obj.%Close()
	Quit:(+return)<0 return
	
	Set Sub=$o(^User.DHCHMInquiryResultI("CodeIndex",ITID," "_$zcvt(IRCode,"U"),0))
	If Sub="" {
		Set obj=##class(User.DHCHMInquiryResult).%New()
	} Else {
		Set obj=##class(User.DHCHMInquiryResult).%OpenId(ITID_"||"_Sub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IRParRef        = ##class(User.DHCHMInquiryType).GetObjById(ITID)
	Set obj.IRCode          = IRCode         //代码
	Set obj.IRDesc          = IRDesc         //描述
	Set obj.IRSort          = IRSort         //序号
	Set obj.IRClassName     = ""             //类名
	Set obj.IRMethodName    = ""             //方法名
	Set obj.IRNoActive      = IRActive       //作废标记
	Set obj.IRUpdateDate    = +$h            //更新日期
	Set obj.IRUpdateTime    = $p($h,",",2)   //更新时间
	Set obj.IRUpdateUserDR  = ""             //更信人 指向SS_User
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set IRID=obj.%Id()
		Set return=IRID
	}
	Do obj.%Close()
	Quit:(+return)<0 return
	
	Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Rewind()
	Do objStream.Write(IRDAdvice)
	Do objStream.%Close()
	
	Set Child=$o(^User.DHCHMInquiryTypeD(+ITID,"ITResult",+$p(IRID,"||",2),"IRDetail",0))
	If Child="" {
		Set obj=##class(User.DHCHMInquiryResultDetail).%New()
	} Else {
		Set obj=##class(User.DHCHMInquiryResultDetail).%OpenId(IRID_"||"_Child)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IRDParRef       = ##class(User.DHCHMInquiryResult).GetObjById(IRID)
	Set obj.IRDIntroduce    = IRDIntroduce    //介绍
	Set obj.IRDAdvice       = objStream       //健康建议
	Set obj.IRDRemark       = IRDRemark       //备注
	Set obj.IRDNoActive     = IRActive        //作废标记
	Set obj.IRDUpdateDate   = +$h             //更新日期
	Set obj.IRDUpdateTime   = $p($h,",",2)    //更新时间
	Set obj.IRDUpdateUserDR = ""              //更信人 指向SS_User
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set IRDID=obj.%Id()
		Set return=IRDID
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2021-12-17
/// Description:  生成科室调查问卷
/// Input：       aLocID：科室ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.ImpBaseDicSrv).NewCQuestionnaire(152)
ClassMethod NewCQuestionnaire(aLocID As %String) As %String
{
	New (aLocID)
	Set return=0
	Quit:aLocID="" return
	
	Set xCQDSID=0
	For {
		Set xCQDSID=$o(^CT.PE.HM.CQDSubjectD(xCQDSID))
		Quit:xCQDSID=""
		Quit:(+return)<0
		
		//同步问卷主表
		Set objCQDS=##class(User.DHCHMCQDSubject).GetObjById(xCQDSID)
		Continue:'$IsObject(objCQDS)
		Continue:objCQDS.QDSActive'="Y"
		
		Set QCode=objCQDS.QDSCode
		Set QDesc=objCQDS.QDSDesc
		Set QType="HM"
		
		Set QID=""
		Set xQID=0
		For {
			Set xQID=$o(^User.DHCHMCQuestionnaireI("IdxOfCQDSubjectDR",xCQDSID,xQID))
			Quit:xQID=""
			
			Continue:##class(User.DHCHMCQuestionnaire).GetLocShowDataFlag(xQID,aLocID)'="Y"
			Set QID=xQID
		}
		If QID="" {
			Set obj=##class(User.DHCHMCQuestionnaire).%New()
		} Else {
			Set obj=##class(User.DHCHMCQuestionnaire).%OpenId(QID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.QCode    = QCode       //代码
		Set obj.QDesc    = QDesc       //描述
		Set obj.QActive  = "Y"         //是否有效
		Set obj.QType    = QType       //类型
		Set obj.QRemark  = ""          //备注
		Set obj.QCQDSubjectDR = objCQDS
		
		Set sc=obj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc) 
	   		Set return=-1
		}Else{
			Set QID=obj.%Id()
			Set return=QID
			Set flg=##class(User.DHCHMCQuestionnaire).SaveDataToPowerControl(obj.%Id(),aLocID,"")
		}
		Do obj.%Close()
		Quit:(+return)<0
		
		//同步问卷主题和问题表
		Set xSub=0
		For {
			Set xSub=$o(^CT.PE.HM.CQDSubjectD(xCQDSID,"DTL",xSub))
			Quit:xSub=""
			Quit:(+return)<0
			
			Set objCQDSDtl=##class(User.DHCHMCQDSubjectDtl).GetObjById(xCQDSID_"||"_xSub)
			Continue:'$IsObject(objCQDSDtl)
			Continue:objCQDSDtl.QDSDActive'="Y"
			Continue:'$IsObject(objCQDSDtl.QDSDQustionDetailDR)
			Set objCQDSCat=objCQDSDtl.QDSDSubjectCatDR
			Continue:'$IsObject(objCQDSCat)
			
			Set CQDSDtlID=objCQDSDtl.QDSDQustionDetailDR.%Id()
			Set QSDSort=objCQDSDtl.QDSDSort
			
			Set QSCode = objCQDSCat.QDSCCode
			Set QSDesc = objCQDSCat.QDSCDesc
			Set QSOrder = objCQDSCat.QDSCSort
			Set QSActive = objCQDSCat.QDSCActive
			Set QSRemark = ""
			
			//生成调查问卷主题
			Set QSID=""
			Set xQSSub=0
			For {
				Set xQSSub=$o(^User.DHCHMCQuestionSubjectI("QSCodeIndex",QID," "_$zcvt(QSCode,"U"),xQSSub))
				Quit:xQSSub=""
				
				Continue:##class(User.DHCHMCQuestionSubject).GetLocShowDataFlag(QID_"||"_xQSSub,aLocID)'="Y"
				Set QSID=QID_"||"_xQSSub
			}
			If QSID="" {
				Set obj=##class(User.DHCHMCQuestionSubject).%New()
				Set obj.QSParRef   = ##class(User.DHCHMCQuestionnaire).GetObjById(QID)
				Set obj.QSCode     = QSCode    //编码
				Set obj.QSDesc     = QSDesc    //描述
				Set obj.QSOrder    = QSOrder   //顺序号
				Set obj.QSActive   = QSActive  //激活
				Set obj.QSRemark   = QSRemark  //备注
				
				Set sc=obj.%Save()
				If $system.Status.IsError(sc) {        //检查Save是否成功
			   		Do $system.OBJ.DisplayError(sc) 
			   		Set return=-1
				}Else{
					Set QSID=obj.%Id()
					Set return=QSID
					Set flg=##class(User.DHCHMCQuestionSubject).SaveDataToPowerControl(obj.%Id(),aLocID,"")
				}
				Do obj.%Close()
			}
			Quit:(+return)<0
			
			//生成调查问卷问题
			Set QSDID=""
			Set xQSDSub=0
			For {
				Set xQSDSub=$o(^User.DHCHMCSDLinkI("SDLDetailIndex",CQDSDtlID,QID,+$p(QSID,"||",2),xQSDSub))
				Quit:xQSDSub=""
				
				Continue:##class(User.DHCHMCSDLink).GetLocShowDataFlag(QSID_"||"_xQSDSub,aLocID)'="Y"
				Set QSDID=QSID_"||"_xQSDSub
			}
			If QSDID="" {
				Set obj=##class(User.DHCHMCSDLink).%New()
				Set obj.SDLParRef    = ##class(User.DHCHMCQuestionSubject).GetObjById(QSID)
				Set obj.SDLQuestionsDetailDR = ##class(User.DHCHMCQuestionsDetail).GetObjById(CQDSDtlID)
				Set obj.SDLOrder     = QSDSort    //顺序号
				Set obj.SDLActive    = "Y"        //是否有效
				Set obj.SDLNote      = ""         //备注
				
				Set sc=obj.%Save()
				If $system.Status.IsError(sc) {        //检查Save是否成功
			   		Do $system.OBJ.DisplayError(sc) 
			   		Set return=-1
				}Else{
					Set QSDID=obj.%Id()
					Set return=QSDID
					Set flg=##class(User.DHCHMCSDLink).SaveDataToPowerControl(obj.%Id(),aLocID,"")
				}
				Do obj.%Close()
			}
			Quit:(+return)<0
		}
		
		//同步问卷评估内容
		Set xCEDCode=""
		For {
			Set xCEDCode=$o(^User.DHCHMCEvaluationDetailI("IdxOfQuesCode",xCQDSID,xCEDCode))
			Quit:xCEDCode=""
			Quit:(+return)<0
			
			Set xCEDID=0
			For {
				Set xCEDID=$o(^User.DHCHMCEvaluationDetailI("IdxOfQuesCode",xCQDSID,xCEDCode,xCEDID))
				Quit:xCEDID=""
				Quit:(+return)<0
				
				Set objCED=##class(User.DHCHMCEvaluationDetail).GetObjById(xCEDID)
				Continue:'$IsObject(objCED)
				Continue:objCED.EDActive'="Y"
				
				Set QEDLOrder=objCED.EDSort
				
				//生成调查问卷问题
				Set QEDID=""
				Set xQEDSub=0
				For {
					Set xQEDSub=$o(^User.DHCHMCQEDLinkI("IdxOfEvalDtlDR",QID,xCEDID,xQEDSub))
					Quit:xQEDSub=""
					
					Continue:##class(User.DHCHMCQEDLink).GetLocShowDataFlag(QID_"||"_xQEDSub,aLocID)'="Y"
					Set QEDID=QID_"||"_xQEDSub
				}
				If QEDID="" {
					Set obj=##class(User.DHCHMCQEDLink).%New()
					Set obj.QEDLParRef    = ##class(User.DHCHMCQuestionnaire).GetObjById(QID)
					Set obj.QEDLEvaluationDetailDR = ##class(User.DHCHMCEvaluationDetail).GetObjById(xCEDID)
					Set obj.QEDLOrder    = +QEDLOrder //顺序号
					Set obj.QEDLCalculateOrder  = +QEDLOrder  //计算顺序
					Set obj.QEDLActive   = "Y"        //是否有效
					Set obj.QEDLNote     = ""         //备注
					
					Set sc=obj.%Save()
					If $system.Status.IsError(sc) {        //检查Save是否成功
				   		Do $system.OBJ.DisplayError(sc) 
				   		Set return=-1
					}Else{
						Set QEDID=obj.%Id()
						Set return=QEDID
						Set flg=##class(User.DHCHMCQEDLink).SaveDataToPowerControl(obj.%Id(),aLocID,"")
					}
					Do obj.%Close()
				}
				Quit:(+return)<0
			}
		}
	}
	
	Quit return
}

}
