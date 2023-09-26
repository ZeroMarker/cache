/// 名称:     web.DHCDocHardCoded
/// 描述:     医生站组个医院写死代码整理类
/// 编写者:  郭荣勇
/// 编写日期: 2011.07.30
/// 适用医院: 
Class web.DHCDocHardCoded Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod HospitalCode() As %String
{
	s HospitalCode=##class(web.DHCDocCommon).GetDocHospitalCode()
	q HospitalCode
}

/// ;XHYY得到是否转科医嘱
/// w ##class(web.DHCDocHardCoded).IsTransDepOrd()
ClassMethod IsTransDepOrd(oeitem) As %String
{
	n (oeitem)
	s myrtn=0
	
	s OrderType=""
	s ARCIMRowid=$p($g(^OEORD(+oeitem,"I",$P(oeitem,"||",2),1)),"^",2)
	s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	i ItemCatDR'="" s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	
	;152 ZT06 无费用嘱托(转科) 
	i ItemCatDR=152 s myrtn=1
	
	q myrtn
}

/// ;XHYY得到所有的手术子类串
/// w ##class(web.DHCDocHardCoded).GetOperaItemCat()
ClassMethod GetOperaItemCat() As %String
{
	s OperaItemCatStr=""
	
	s OrdCatId="14"	;手术大类Rowid
	s RowId=0
	for {
		s RowId=$O(^ARC("IC",0,"OrdCat",OrdCatId,RowId))
		q:RowId=""
		if OperaItemCatStr="" s OperaItemCatStr=RowId
		else  s OperaItemCatStr=OperaItemCatStr_"^"_RowId
	}
	;140 ZL34 放射治疗 
	;10  FS05 放射介入 
	if OperaItemCatStr'="" s OperaItemCatStr="^"_OperaItemCatStr_"^140^10^"
	else  s OperaItemCatStr="^140^10^"
	
	
	Q OperaItemCatStr
}

/// ;XHYY判断科室列表的代码为NOFREQ则不需要录入频次,判断频次和用法
/// w ##class(web.DHCDocHardCoded).DepListNeedFreqEntryExcep(687)
ClassMethod DepListNeedFreqEntryExcep(LogonDep As %String = "") As %String
{
	n (LogonDep)
	s NeedFreqEntry=1
	if LogonDep {
		s LLRowid=0
		for {
			s LLRowid=$O(^CT("LL",0,"Loc1",LogonDep,LLRowid)) q:LLRowid=""
			s LLCode=$p($g(^CT("LL",LLRowid)),"^",1)
			if LLCode="NOFREQ" s NeedFreqEntry=0 q
		}
	}
	
	Q NeedFreqEntry
}

/// 插入检验绑定医嘱或抽血费例外
/// w ##class(web.DHCDocHardCoded).LabLinkOrderException(93,31,3879)
ClassMethod LabLinkOrderException(EpisodeID As %String, Loc As %String = "", UserID As %String = "") As %String
{
	s ^TMPgry("LabLinkOrder")=EpisodeID_","_Loc_","_UserID
	n (EpisodeID,Loc,UserID)
	s myrtn=0
	Quit:EpisodeID="" myrtn
	if ..HospitalCode()="BJXHYY" {
		;控制的科室Rowid串
		s ContralDepStr=""
		;控制的费别Rowid串
		s ContralReaStr=""
		s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
		s DepCodeDR=$p($g(^PAADM(EpisodeID)),"^",4)
		s AdmReasonDR=$p($g(^PAADM(EpisodeID,1)),"^",7)
		s AdmEpissubtypeID=$p($g(^PAADM(EpisodeID,1)),"^",6)
		s EpisodeSubTypeDesc=""
		i AdmEpissubtypeID'="" s EpisodeSubTypeDesc=$p($g(^PAC("SUBT",AdmEpissubtypeID)),"^",2)
		s CurrWard=""
		s CurrWardDr=$p($g(^PAADM(EpisodeID)),"^",70)
		i CurrWardDr'="" s CurrWard=$p($g(^PAWARD(CurrWardDr)),"^",2)
		
		if (AdmType="I") {
			if (EpisodeSubTypeDesc["特需")||(CurrWard["整形美容外科病房(西院)") {
				;需要插入医嘱串
				;26837||1 E6135 静脉抽血(IMS)
				/*
				s NeedInsertArcStr="26837||1"
				for i=1:1:$L(NeedInsertArcStr,"^") {
					s InsertArc=$p(NeedInsertArcStr,"^")
					if InsertArc="" continue
					s OrdItemStr=InsertArc_"^1"_"^"_DepCodeDR_"^^^"_AdmReasonDR
					s User=UserID
					s Loc=Loc
					s DocUserId=UserID
					s OSRID=""	;ARC_OrdSets
					s rtnvalue=##class(web.DHCOPCashier).CashierInsertOrdItem(EpisodeID,OrdItemStr,User,Loc,DocUserId,OSRID)
					s rtn=$p(rtnvalue,"^",1)
				}
				*/
				s myrtn=1
				Quit myrtn
			}
		}else{
			if ContralDepStr[("^"_DepCodeDR_"^") {
				;需要插入医嘱串
				/*
				s NeedInsertArcStr="26837||1"
				for i=1:1:$L(NeedInsertArcStr,"^") {
					s InsertArc=$p(NeedInsertArcStr,"^")
					if InsertArc="" continue
					s OrdItemStr=InsertArc_"^1"_"^"_DepCodeDR_"^^^"_AdmReasonDR
					s User=UserID
					s Loc=Loc
					s DocUserId=UserID
					s OSRID=""	;ARC_OrdSets
					s rtnvalue=##class(web.DHCOPCashier).CashierInsertOrdItem(EpisodeID,OrdItemStr,User,Loc,DocUserId,OSRID)
					s rtn=$p(rtnvalue,"^",1)
				}
				*/
				s myrtn=1
				Quit myrtn
			}
			if ContralReaStr[("^"_AdmReasonDR_"^") {
				;需要插入医嘱串
				/*
				s NeedInsertArcStr="26837||1"
				for i=1:1:$L(NeedInsertArcStr,"^") {
					s InsertArc=$p(NeedInsertArcStr,"^")
					if InsertArc="" continue
					s OrdItemStr=InsertArc_"^1"_"^"_DepCodeDR_"^^^"_AdmReasonDR
					s User=UserID
					s Loc=Loc
					s DocUserId=UserID
					s OSRID=""	;ARC_OrdSets
					s rtnvalue=##class(web.DHCOPCashier).CashierInsertOrdItem(EpisodeID,OrdItemStr,User,Loc,DocUserId,OSRID)
					s rtn=$p(rtnvalue,"^",1)
				}
				*/
				s myrtn=1
				Quit myrtn
			}
		}
	}
	
	Quit myrtn
}

/// 协和判断是否治疗号
ClassMethod IsZLH(DocId As %String) As %String
{
	set find=0
	Quit:..HospitalCode()'="BJXHYY" find
	Quit:DocId="" find
	set DocCode=$P(^CTPCP(DocId,1),"^",1)
	if DocCode["ZLH" s find=1
	
	q find
}

/// 协和判断医嘱是否治疗 1 是;其他 不是
ClassMethod IsCureCatOrder(ArcimRowid As %String) As %String
{
	set find=0
	Quit:..HospitalCode()'="BJXHYY" find
	Quit:ArcimRowid="" find
	set BillSubDr=$P(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),1),"^",9)
	if BillSubDr'="" {
		s ARCBGDesc=$P(^ARCBG(+BillSubDr),"^",2)
		i ARCBGDesc["治疗收入" s find=1
	}
	
	q find
}

/// 协和判断是否妇产科,用户显示诊间预约的"需听课"checkbox
ClassMethod IsShowNeedListen(DepID As %String) As %String
{
	set find=0
	Quit:..HospitalCode()'="BJXHYY" find
	Quit:DepID="" find
	set DepCode=$P(^CTLOC(DepID),"^",1)
	set DepDesc=$P(^CTLOC(DepID),"^",2)
	if $zcvt($e(DepDesc,1,2),"U")="FK" s find=1
	
	q find
}

/// 协和停医嘱超级组
ClassMethod StopOrdSuperGrp(Grp As %String, Loc As %String) As %String
{
	set find=0
	Quit:..HospitalCode()'="BJXHYY" find
	
	Quit:##class(web.DHCOPAdmReg).IsEmergency(Loc)=1 1
	set SuperGrp=""	;"^23^24^"
	if SuperGrp[("^"_Grp_"^") s find=1
	
	q find
}

/// 协和通过检查组判断检查子类
ClassMethod IsExamSubCat(ArcimRowid As %String)
{
	set IsFlag=0
	Quit:..HospitalCode()'="BJXHYY" IsFlag
	
	s OCGrpDesc=""
	s ItemCatDR=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	if ItemCatDR'="" {
		s OrdCatID=$p($g(^ARC("IC",ItemCatDR)),"^",8)
		i OrdCatID'="" s OCGroupdr=$P($g(^OEC("ORCAT",OrdCatID)),"^",15)
		i $g(OCGroupdr)'="" s OCGrpDesc=$P($g(^OEC("OCGRP",$g(OCGroupdr))),"^",2)
	}
	
	;if OCGrpDesc["检查" s IsFlag=1
	s ServMaterial=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),7)),"^",6)
	if (ServMaterial="S") s IsFlag=1
	
	Q IsFlag
}

/// 协和医保适应症提示屏蔽代码
ClassMethod InsuIndicationAlertShield(Adm As %String, InsuIndication As %String) As %String
{
	n (Adm,InsuIndication)
	/*
	限一级以上医院使用
	限二级以上医院使用
	限三级以上医院使用
	仅限协和医院使用
	费用需由个人部分负担
	肾透析患者门诊治疗限一级以上医院（含社区卫生服务中心）使用
	仅限协和医院使用
	限中医医院或二级以上医院使用
	限精神病专科医院或二级以上医院使用
	限二级以上医院使用肾透析患者门诊治疗限一级以上医院（含社区卫生服务中心）使用
	限二级以上医院使用肾透析患者门诊治疗限一级以上医院（包括社区卫生服务中心）使用
    */
    s InsuIndication=$CASE(InsuIndication["限一级以上医院使用。",1:$tr(InsuIndication,"限一级以上医院使用。",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["限二级以上医院使用。",1:$tr(InsuIndication,"限二级以上医院使用。",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["限三级以上医院使用。",1:$tr(InsuIndication,"限三级以上医院使用。",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["仅限协和医院使用。",1:$tr(InsuIndication,"仅限协和医院使用。",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["费用需由个人部分负担。",1:$tr(InsuIndication,"费用需由个人部分负担。",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["肾透析患者门诊治疗限一级以上医院（含社区卫生服务中心）使用。",1:$tr(InsuIndication,"肾透析患者门诊治疗限一级以上医院（含社区卫生服务中心）使用。",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["限中医医院或二级以上医院使用。",1:$tr(InsuIndication,"限中医医院或二级以上医院使用。",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["限精神病专科医院或二级以上医院使用。",1:$tr(InsuIndication,"限精神病专科医院或二级以上医院使用。",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["限二级以上医院使用肾透析患者门诊治疗限一级以上医院（含社区卫生服务中心）使用。",1:$tr(InsuIndication,"限二级以上医院使用肾透析患者门诊治疗限一级以上医院（含社区卫生服务中心）使用。",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["限二级以上医院使用肾透析患者门诊治疗限一级以上医院（包括社区卫生服务中心）使用。",1:$tr(InsuIndication,"限二级以上医院使用肾透析患者门诊治疗限一级以上医院（包括社区卫生服务中心）使用。",""),0:InsuIndication)

    s InsuIndication=$CASE(InsuIndication["限一级以上医院使用",1:$tr(InsuIndication,"限一级以上医院使用",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["限二级以上医院使用",1:$tr(InsuIndication,"限二级以上医院使用",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["限三级以上医院使用",1:$tr(InsuIndication,"限三级以上医院使用",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["仅限协和医院使用",1:$tr(InsuIndication,"仅限协和医院使用",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["费用需由个人部分负担",1:$tr(InsuIndication,"费用需由个人部分负担",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["肾透析患者门诊治疗限一级以上医院（含社区卫生服务中心）使用",1:$tr(InsuIndication,"肾透析患者门诊治疗限一级以上医院（含社区卫生服务中心）使用",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["限中医医院或二级以上医院使用",1:$tr(InsuIndication,"限中医医院或二级以上医院使用",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["限精神病专科医院或二级以上医院使用",1:$tr(InsuIndication,"限精神病专科医院或二级以上医院使用",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["限二级以上医院使用肾透析患者门诊治疗限一级以上医院（含社区卫生服务中心）使用",1:$tr(InsuIndication,"限二级以上医院使用肾透析患者门诊治疗限一级以上医院（含社区卫生服务中心）使用",""),0:InsuIndication)
    s InsuIndication=$CASE(InsuIndication["限二级以上医院使用肾透析患者门诊治疗限一级以上医院（包括社区卫生服务中心）使用",1:$tr(InsuIndication,"限二级以上医院使用肾透析患者门诊治疗限一级以上医院（包括社区卫生服务中心）使用",""),0:InsuIndication)
	
	s PatCatDesc=""
	if Adm'="" {
		s AdmType=$p($g(^PAADM(Adm)),"^",2)
		s PapmiRowid=$p($g(^PAADM(Adm)),"^",1)
		Set Age=+$p(^PAPER(PapmiRowid,"ALL"),"^",6)
		Set Age=$p(((+$H-Age)/365)+0.5,".")
		Set PatCat=""
		if $D(^PAPER(PapmiRowid,"PER",1)) {
			Set PatCatDr=$p(^PAPER(PapmiRowid,"PER",1),"^",10)
			i $g(PatCatDr)'="" {
				set PatCatDesc=$p($g(^CT("SS",PatCatDr)),"^",2)   //病人类型描述
			}
		}


		if AdmType'="I" s InsuIndication=$CASE(InsuIndication["限门诊使用",1:$tr(InsuIndication,"限门诊使用",""),0:InsuIndication)
		else  s InsuIndication=$CASE(InsuIndication["限住院使用",1:$tr(InsuIndication,"限住院使用",""),0:InsuIndication)
		
		i (PatCatDesc["儿童") s InsuIndication=$CASE(InsuIndication["限学生儿童大病医疗保险使用",1:$tr(InsuIndication,"限学生儿童大病医疗保险使用",""),0:InsuIndication)
	}
	
	q InsuIndication
}

/// 协和医院医保儿童用药控制,超过30岁,要求自费
ClassMethod GetInsurChildLimit(Adm As %String, InsuIndication As %String)
{
	set InsurChildLimit=0
	Quit:..HospitalCode()'="BJXHYY" InsurChildLimit
	
	if Adm'="" {
		s AdmType=$p($g(^PAADM(Adm)),"^",2)
		s PapmiRowid=$p($g(^PAADM(Adm)),"^",1)
		Set Age=+$p(^PAPER(PapmiRowid,"ALL"),"^",6)
		Set Age=$p(((+$H-Age)/365)+0.5,".")
		Set PatCat=""
		if $D(^PAPER(PapmiRowid,"PER",1)) {
			Set PatCatDr=$p(^PAPER(PapmiRowid,"PER",1),"^",10)
			i $g(PatCatDr)'="" {
				set PatCatDesc=$p($g(^CT("SS",PatCatDr)),"^",2)   //病人类型描述
			}
		}
        i (Age>30)&&(InsuIndication["限儿童") s InsurChildLimit=1
	}
	
	Q InsurChildLimit
}

ClassMethod HardCodedVersions(ClassName As %String, MethodName As %String, ArgObj As web.DHCEntity.Args.Arguments) As %String
{
	set ArgsStr=""
	set ClassDef = ##class(%Library.ClassDefinition).%OpenId("web.DHCEntity.Args.Arguments")
	s myCount=ClassDef.Properties.Count()

	f i = 1:1:myCount d
	.s myPropertyName=ClassDef.Properties.GetAt(i).Name
	.q:(myPropertyName="")
	.s aCmd="b=ArgObj."_myPropertyName
	.s @aCmd
	.i ArgsStr="" s ArgsStr=b
	.e  s ArgsStr=ArgsStr_"^"_b
	
	w ArgsStr,!
	d ClassDef.%Close()
	
	q 0
	;q $ZOBJCLASSMETHOD(ClassName,MethodName,ArgsStr)
}

ClassMethod TestMethod() As %String
{
	/*
	w ##class(web.DHCDocHardCoded).TestMethod()
	测试:
	$ZOBJCLASSMETHOD
	$ZOBJMETHOD
	$ZOBJPROPERTY
	*/
	;s $ZT="Err"
	s classname="web.DHCDocCommon"
	s classmethod="GetDocHospitalCode"
	;q $ZOBJCLASSMETHOD(classname,classmethod)
	
	
	;s aCmdClass="myrtn=##class("_classname_")."_classmethod_"()"
	;s @aCmdClass
	;q myrtn
	
	s Obj=##class(web.DHCEntity.Args.Arguments).%New()
	s Obj.Args1="a"
	s Obj.Args2="b"
	s myrtn=..HardCodedVersions(classname,classmethod,Obj)
	q myrtn
	
Err
	set $ZTRAP = ""
	  if $ZE["<ZSOAP>" {
	   do $System.OBJ.DisplayError(%objlasterror)
	  }
	quit 1
}

//得到不允许儿童挂号的科室串

ClassMethod GetNoRegLocIDs()
{
	//s locStr="242^243"
	s locStr="" //"167" //神经科门诊 
	q "^"_locStr_"^"
}

//对于已经有诊断的判断是否有权限退号  1  有权限

ClassMethod ReturnHadDiagnosReg(Type As %String = "His")
{
	i Type'="His" q 0
	s ret=0
	s GroupID="89"  //写死的有特殊退号权限的安全组
	S:GroupID=%session.Get("LOGON.GROUPID") ret=1
	q ret
}

//得到VIP预约取号的每个人最大限额^当天最大限额

ClassMethod GetVIPRegMaxNum(PatientID)
{
	q "2^3"
}

//得到挂号员登录科室或者挂号员是否可以直接加号的权限

//1有权限  0无权限

ClassMethod GetCanAddRegFlag()
{
	//q 1
	s CurLoc=%session.Get("LOGON.CTLOCID")
	s CurUser=%session.Get("LOGON.USERID")
	s CurGroup=%session.Get("LOGON.GROUPID")
	i CurLoc="" q 1
	q 0
}

//挂号时看登录科室是否国际医疗部挂号科室

ClassMethod GetInternationFlag()
{
	s CurLoc=%session.Get("LOGON.CTLOCID")
	i CurLoc="552" q 1
	q 0
}

//看停闭诊是否需要申请

//1需要  0不需要

ClassMethod GetRBASRequestFlag(Type)
{
	//##class(web.DHCDocHardCoded).GetRBASRequestFlag("S")
	q:Type="S" 1
	q:Type="R" 1
	q 1
}

//看医保信息和录入信息不一致时是否有权限覆盖原有信息

ClassMethod GetUpdateInfoFlagByYB()
{
	q 1
	s CurLoc=%session.Get("LOGON.CTLOCID")
	s CurUser=%session.Get("LOGON.USERID")
	s CurGroup=%session.Get("LOGON.GROUPID")
	i CurGroup="90" q 1
	q 0
}

//有病案号的允许修改信息的特殊权限

ClassMethod GetUpdateInfoFlag()
{
	s CurLoc=%session.Get("LOGON.CTLOCID")
	s CurUser=%session.Get("LOGON.USERID")
	s CurGroup=%session.Get("LOGON.GROUPID")
	i CurGroup="90" q 1
	q 0
}

//查看n天内的存在未收费的医嘱,返回n

ClassMethod GetIntervalDays()
{
	;##class(web.DHCDocHardCoded).GetIntervalDays()
	s IntervalDays=0  ;当天
	q IntervalDays
}

//得到计划生育和产科对应亚专业的串

ClassMethod GetSpecialClinicGroup()
{
	;##class(web.DHCDocHardCoded).GetSpecialClinicGroup()
	;RBC_ClinicGroup
	q "^"_"2"_"^"
}

//得到设置限额的预约方式Code

ClassMethod GetAPPTCode()
{
	;##class(web.DHCDocHardCoded).GetAPPTCode()
	;RBC_AppointMethod
	q "^VIP^"
}

//得到排班时有夜间号的安全组

ClassMethod GetNightRBGroups()
{
	;##class(web.DHCDocHardCoded).GetNightRBGroups()
	;SS_Group
	q "^296^"
}

//夜间时段对应的ID

ClassMethod GetNightTimeRangeID()
{
	;##class(web.DHCDocHardCoded).GetNightTimeRangeID()
	;DHC_TimeRange
	q "3"
}

}
