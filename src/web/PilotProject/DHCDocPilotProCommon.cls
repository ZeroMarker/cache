Class web.PilotProject.DHCDocPilotProCommon Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Desc:清理临床药理业务数据
/// Inupt:1 直接清除所有业务数据 ;2 除项目信息不清除以外,其他信息都清除
/// d ##Class(web.PilotProject.DHCDocPilotProCommon).ClearData(2)
ClassMethod ClearData(Level As %String = "1") As %String
{
	if Level=1 {
		;主表
		Kill ^DHCDocPP
		;状态表
		Kill ^DHCDocPPS
		;付款记录表
		Kill ^DHCDocPPR
		;参与者表
		Kill ^DHCDocPPC
		;药理病人表
		Kill ^DHCDocPPP
		;其他科研科室与研究者表
		Kill ^DHCDocPPD
		;质控表
		Kill ^DHCDocPPSAE
		;结算表
		Kill ^DHCDocPPSET
		;年度跟踪审查表
		Kill ^DHCDocPPYK
		;质控表
		Kill ^DHCDocPPQCZYZ
		;清除科研专业组
		Kill ^UDHCDocPilotProConfig("DeptApprove")
	}
	if Level=2 {
		;状态表
		Kill ^DHCDocPPS
		;付款记录表
		Kill ^DHCDocPPR
		;参与者表
		Kill ^DHCDocPPC
		;药理病人表
		Kill ^DHCDocPPP
		;其他科研科室与研究者表
		Kill ^DHCDocPPD
		;质控表
		Kill ^DHCDocPPSAE
		;结算表
		Kill ^DHCDocPPSET
		;年度跟踪审查表
		Kill ^DHCDocPPYK
		;质控表
		Kill ^DHCDocPPQCZYZ
	}
	Q
}

ClassMethod GetClassPropertyList(ClassName As %String) As %String
{
	n (ClassName)
	;w ##class(web.PilotProject.DHCDocPilotProCommon).GetClassPropertyList("web.PilotProject.PPA.DHCDocPilotProject")
	
	s myItems=""
	
	s myobj=##class(%Dictionary.CompiledClass).%OpenId(ClassName)
	s myCount = myobj.Properties.Count()
	
	s mylist=$p(ClassName,".",$l(ClassName,"."))
	b ;
	For i = 1:1:myCount {
		s myproperty=myobj.Properties.GetAt(i)
		s myName=myproperty.Name
		if myName="%%OID" continue
		if (mylist="")
		{
			s mylist= myName
		}else
		{
	    	s mylist=mylist_"^"_myName
		}
	}
	
	q mylist
}

ClassMethod GetComponentItemsList() As %String
{
	;d ##class(web.PilotProject.DHCDocPilotProCommon).GetComponentItemsList()
	
	s myFormName=""
	s myMenuID=%request.Get("TMENU")
	;s myMenuID=50345
	i myMenuID'="" d
	.s mymenuobj=##class(websys.Menu).%OpenId(myMenuID)
	.s myFormName=mymenuobj.LinkComponent.Name
	.d mymenuobj.%Close()
	
	i myFormName="" d
	.s myFormName=%request.Get("TFORM")
	
	i myFormName="" d
	.s myFormName=%request.Get("WEBSYS.TCOMPONENT")
	
	q:(myFormName="") ""
	s myItems=""
	
	s myCompID=""
	&sql(select ID into :myCompID from websys.component where Name=:myFormName)
	
	;打开组件类	
	s myComs=##class(websys.Component).%OpenId(myCompID)
	
	s myCount = myComs.Items.Count()
	s myTxtIdx=0
	s myListIdx = 0
	s myLookTxtIdx = 0
	
	Write !,"<SCRIPT language=""Javascript"">",!
	;JS 函数
		w "var m_ListItemName = new Array();", !
		w "var m_TextItemName = new Array();", !
		w "var m_LookUpTextItemName = new Array()",!
		w "var m_LookUpTextItemRowID = new Array()", !
		
		For i = 1:1:myCount {
			s myItemObj=myComs.Items.GetAt(i)
			s myDPType = myItemObj.DisplayType
			i ((myDPType="T")||(myDPType="L")||(myDPType="C")||(myDPType="TA")||(myDPType="B"))
			{
			    i ((('+myItemObj.Hidden)&&(myItemObj.LookupClassName="")&&(myItemObj.LookupQueryName=""))!(myDPType="L")){
				    i (myDPType="L"){
						w "  "_"m_ListItemName["_myListIdx_"]='"_myItemObj.Name_"';",!
						s myListIdx=+myListIdx+1
				    }else{
						w "  "_"m_TextItemName["_myTxtIdx_"]='"_myItemObj.Name_"';",!
						s myTxtIdx=+myTxtIdx+1
				    }
			    }elseif(('+myItemObj.Hidden)&&(myItemObj.LookupClassName'="")&&(myItemObj.LookupQueryName'="")){
					///对于Lookup的规则  显示数据的Name后面加上 RowID
					w "  "_"m_LookUpTextItemName["_myLookTxtIdx_"]='"_myItemObj.Name_"';",!
					w "  "_"m_LookUpTextItemRowID["_myLookTxtIdx_"]='"_myItemObj.Name_"LookUpRowID';",!
					s myLookTxtIdx = +myLookTxtIdx+1
			    }
			}
		}
	w "</SCRIPT>"
	w !
	
	d myComs.%Close()
	
	q ""
}

/// 公共接口部分
/// creator:guorongyong
/// date:2010-05-22
/// desc:根据病人PA_PatMas的RowId得到此病人在药理项目的就诊ID
/// Input:PAPMIID:病人的PA_PatMas的RowId
/// Output：PA_Adm表的RowId
ClassMethod getProAdmByPAPMIID(PAPMIID As %String, AdmType As %String = "") As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProCommon).getProAdmByPAPMIID(132478)
	n (PAPMIID,AdmType)
	Q:PAPMIID="" "-100"
	s findAdmID=""
	s PPRowId=0
	for {
		s PPRowId=$O(^DHCDocPPP("PapmiDr",0,PAPMIID,PPRowId))
		Q:(PPRowId="")||(findAdmID'="")
		Set ProStartDate=$p($g(^DHCDocPP(PPRowId)),"^",11)
		Set ProEndDate=$p($g(^DHCDocPP(PPRowId)),"^",13)
		Set ProState=$p($g(^DHCDocPP(PPRowId)),"^",16)
		if ((ProStartDate>+$H)&&(ProStartDate'=""))||((ProEndDate<+$H)&&(ProEndDate'=""))||(" N V I "'[(" "_ProState_" ")) continue
		;查询可用项目下的此病人的记录,按现在的流程可以不循环,因为每个项目的一个病人只有一条记录
		s PPPRowId=0
		for {
			s PPPRowId=$O(^DHCDocPPP("PapmiDr",0,PAPMIID,PPRowId,PPPRowId))
			Q:(PPPRowId="")||(findAdmID'="")
			s VisitState=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",2)
			if VisitState'="N" continue
			;查询就诊
			s PPPARowId=0
			for {
				s PPPARowId=$O(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId))
				Q:(PPPARowId="")||(findAdmID'="")
				s PPPAActiveFlag=$P(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),"^",4)
				if PPPAActiveFlag'="Y" continue
				s PPPAAdmDr=$P(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),"^",1)
				s GetAdmType=$P($G(^PAADM(PPPAAdmDr)),"^",2)
				continue:(AdmType'="")&&(GetAdmType'=AdmType)
				s findAdmID=PPPAAdmDr
			}
		}
	}
	
	Q findAdmID
}

// date:2013-10-15

/// desc:根据项目RowId跟用户RowId得到账号
/// Input:PPRowId:项目RowId,UserId 用户RowId
/// Output：PA_Adm表的RowId
/// d ##class(web.PilotProject.DHCDocPilotProCommon).GetAccount(21288,4175)
ClassMethod GetAccount(PPRowId As %String, UserId As %String) As %String
{
	n (PPRowId , UserId)
	q:((PPRowId="")||(UserId="")) ""
	s account=""
	s UserDr=""
	s child=0
	f  s child=$o(^DHCDocPPC(PPRowId,child)) q:child=""  d
	.s PPCJoinUserDr=$p($g(^DHCDocPPC(PPRowId,child)),"^",1)
	.;w !,PPCJoinUserDr
	.s PPUesr=$p($g(^DHCDocPPC(PPRowId,child)),"^",12)
	.if UserId=PPCJoinUserDr d
	..s UserDr=PPUesr
	s account=##class(web.PilotProject.DHCDocPilotProject).GetAccountByUser(PPRowId,UserDr)
	q account
	
	i UserDr="" s UserDr=UserId
	s PPAccount=$p($g(^DHCDocPP(PPRowId)),"^",50)
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	if ((UserDr=ProStartUserDr)||(UserDr=UserUserDr)) q PPAccount
	s PAccount=""
	s child=0
	f  s child=$o(^DHCDocPPD(PPRowId,child)) q:child=""  d
	.s ProStartUserDr1=""
	.s UserUserDr1=""
	.s ProStartUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	.s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	.s PAccount1=""
	.s PAccount1=$p($g(^DHCDocPPD(PPRowId,child)),"^",4)
	.i ((UserDr=ProStartUserDr1)||(UserDr=UserUserDr1))  s PAccount=PAccount1
	q PAccount
}

// 根据小组成员得到

// w ##Class(web.PilotProject.DHCDocPilotProCommon).GetStartUserByUserID(1,4175)

ClassMethod GetStartUserByUserID(PPRowId As %String, UserId As %String) As %String
{
	s PPCRowId=""
	s UserDr=""
	s User=""
	s HCPID=""
	s HCP=""
	s ^zzy("GetStartUserByUserID")=PPRowId_"^"_UserId 
	f  s PPCRowId=$O(^DHCDocPPC(PPRowId,PPCRowId)) Q:(PPCRowId="")  d
	.s JoinUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",1)
	.s PPCUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",12)
	.;w !,JoinUserDr
	.if UserId=JoinUserDr d
	..;b
	..s UserDr=PPCUserDr
	..s:UserDr'="" User=$p($g(^SSU("SSUSR",UserDr)),"^",2)
	s HCPRowId=""
	f  s HCPRowId=$O(^CT("HCP",HCPRowId)) q:HCPRowId=""  d
	.s HCPDesc=$p($g(^CT("HCP",HCPRowId)),"^",2)
	.q:HCPDesc'["科研"
	.i ((HCPDesc[User)&&(User'="")) d
	..s HCPID=HCPRowId
	..s HCP=HCPDesc
	q HCPID_"^"_HCP
}

/// 固定账户设置
/// creator:guorongyong
/// date:2014-01-07
/// desc:
/// Input:
/// Output：1 是固定账户用户,0 非固定账户用户
ClassMethod getCFFixedAcountFlag(UserID As %String) As %String
{
	Q:UserID="" 0
	;胡蓓,江骥
	s FixedAcountStr="^3339^3340^"
	i FixedAcountStr[("^"_UserID_"^") Q 1
	e  Q 0
}

/// zzy
/// 转换科室名字
/// w ##Class(web.PilotProject.DHCDocPilotProCommon).TransDeptName("临床药理实验室")
ClassMethod TransDeptName(Name As %String) As %String
{
	i Name="临床药理实验室" s Name="I期临床试验研究室"
	i Name["免疫" s Name="风湿免疫科"
	if Name="感染内科" s Name="感染科"
	q Name
}

// 判读就诊是否是有效科研就诊

ClassMethod CheckPilotAdm(EpisodeID As %String)
{
	s ret=0
	i EpisodeID="" q ret
	s PPRowId=""
	i '$d(^DHCDocPPPA("AdmDr",EpisodeID)) q ret
	f  s PPRowId=$o(^DHCDocPPPA("AdmDr",EpisodeID,0,PPRowId)) q:PPRowId=""  d
	.s PPPChild=""
	.f  s PPPChild=$o(^DHCDocPPPA("AdmDr",EpisodeID,0,PPRowId,PPPChild)) q:PPPChild=""  d
	..s PPAChild=""
	..f  s PPAChild=$o(^DHCDocPPPA("AdmDr",EpisodeID,0,PPRowId,PPPChild,PPAChild)) q:PPAChild=""  d
	...s Active=$p($g(^DHCDocPPPA(PPRowId,PPPChild,PPAChild)),"^",4)
	...i Active="Y" s ret=1
	q ret
}

// 根据小组成员得到PI

// w ##Class(web.PilotProject.DHCDocPilotProCommon).GetPIByUserID(1,4175)

ClassMethod GetPIByUserID(PPRowId As %String, UserId As %String) As %String
{
	n (PPRowId,UserId)
	s PPCRowId=""
	s UserDr=""
	s User=""
	f  s PPCRowId=$O(^DHCDocPPC(PPRowId,PPCRowId)) Q:(PPCRowId="")  d
	.s JoinUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",1)
	.s PPCUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",12)
	.if UserId=JoinUserDr d
	..s UserDr=PPCUserDr
	..s:UserDr'="" User=$p($g(^SSU("SSUSR",UserDr)),"^",2)
	q User
}

// 判断用户是否是科研项目的参与人员

// w ##Class(web.PilotProject.DHCDocPilotProCommon).IsPilotProCareFlag(51,354)

// -1 非参与人员,1 参与人员

ClassMethod IsPilotProCareFlag(PPRowId As %String, UserId As %String) As %String
{
	n (PPRowId,UserId)
	Q:(PPRowId="")||(UserId="") 0
	s myrtn=-1
	s PPCRowId=""
	f  s PPCRowId=$O(^DHCDocPPC(PPRowId,PPCRowId)) Q:(PPCRowId="")||(myrtn=1)  d
	.s JoinUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",1)
	.s PPCUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",12)
	.if UserId=JoinUserDr s myrtn=1
	q myrtn
}

// 得到科研项目的参与医护人员联系人,如果没有设置联系人则取PI

// w ##Class(web.PilotProject.DHCDocPilotProCommon).GetPilotProCare(51)

ClassMethod GetPilotProCare(PPRowId As %String) As %String
{
	n (PPRowId,%session)
	s $zt="GetPilotProCareErr"
	Q:(PPRowId="") ""
	s myStr="",PilotProCareTel="",PilotProCare=""
	k PPCUserDRAry
	s langid=..%LanguageID()
	s PPCRowId=""
	f  s PPCRowId=$O(^DHCDocPPC(PPRowId,PPCRowId)) Q:(PPCRowId="")||(myStr'="")  d
	.s JoinUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",1)
	.s JoinUserName=""
	.i JoinUserDr'="" s JoinUserName=$p(^SSU("SSUSR",JoinUserDr),"^",2)
	.s PPCUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",12)
	.s ContactFlag=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",10)
	.s ContactTel=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",11)
	.s JoinUserName=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",JoinUserName,langid)
	.if ContactFlag="Y" d
	..s PilotProCare=JoinUserName
	..s PilotProCareTel=ContactTel
	..s myStr=JoinUserDr_"^"_JoinUserName_",电话:"_ContactTel_"^"_PilotProCare_"^"_PilotProCareTel
	.if PPCUserDr'="" d
	..s UserName=$p(^SSU("SSUSR",PPCUserDr),"^",2)
	..s JoinUserName=##class(User.SSUser).GetTranByDesc("SSUSRName",UserName,langid)
	..s PPCUserDRAry(PPCUserDr)=PPCUserDr_"^"_UserName
	
	;没有找到联系人
	i myStr="" {
		s PIIDStr=""
		s PIStr=""
		s PI=""
		for {
			s PI=$O(PPCUserDRAry(PI)) Q:PI=""
			continue:PPCUserDRAry(PI)=""
			i PIStr="" {
				s PIStr=$p(PPCUserDRAry(PI),"^",2),PIIDStr=$p(PPCUserDRAry(PI),"^",1)
				s docid=##class(DHCAnt.KSS.Common.Method).TransSSUserToCTCare($p(PPCUserDRAry(PI),"^",1))
				i docid'="" s PilotProCareTel=$p(^CTPCP(docid,3),"^",6)
				s PilotProCare=$p(PPCUserDRAry(PI),"^",2)
				
			}else {
				s PIStr=PIStr_";"_$p(PPCUserDRAry(PI),"^",2),PIIDStr=PIIDStr_";"_$p(PPCUserDRAry(PI),"^",1)
			}
		}
		
		s myStr=PIIDStr_"^"_PIStr_"^"_PilotProCare_"^"_PilotProCareTel
	}
	
	q myStr
GetPilotProCareErr
	q ""
}

}
