Class DHCDoc.DHCApp.BasicConfig Extends DHCDoc.Util.RegisteredObject
{

ClassMethod SaveConfig1(Node As %String, Node1 As %String, NodeValue As %String) As %String
{
	s ^DHCDocAppConfig(Node,Node1)=NodeValue
	q 0
}

ClassMethod SaveConfig2(Node As %String, NodeValue As %String) As %String
{
	s ^DHCDocAppConfig(Node)=NodeValue  
	q 0
}

ClassMethod SaveConfig3(Node As %String, Node1 As %String, NodeValue As %String) As %String
{
 	if (Node1="") {
		s Node1=$o(^DHCDocAppConfig(Node,""),-1)
		i Node1="" s Node1=0
		s Node1=Node1+1
	}
	s ^DHCDocAppConfig(Node,Node1)=NodeValue
	q 0
}

ClassMethod SavebaseInfo(DataList, HospId)
{
	s HospCodeNode="HospDr_"_HospId
	s ConNum=$l(DataList,$C(2))
	f i=1:1:ConNum  d
	.s evNoteinfo=$p(DataList,$C(2),i)
	.i evNoteinfo'="" d ..SaveConfig1(HospCodeNode,$P(evNoteinfo,$C(1),1),$P(evNoteinfo,$C(1),2))
	q 0
}

ClassMethod GetConfigNode(Node As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=$G(%session.Data("LOGON.HOSPID"))
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s str=$g(^DHCDocAppConfig(HospCodeNode,Node))
	}else{
		s str=$g(^DHCDocAppConfig(Node))
	}
	q str
}

/// 判断标本列是否允许编辑
ClassMethod CheckSpecEditor(PisID As %String, EpisodeID As %String) As %String
{
	s rtn=0
	s AdmDepDr=$p($g(^PAADM(EpisodeID)),"^",4)
	s AdmDepHospId=$p(^CTLOC(AdmDepDr),"^",22)
	;1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
	s EMStayFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	//0现金模式；1押金模式
	s StayPayMode=##class(web.DHCBillInterface).IGetStayPayMode(AdmDepHospId)
	s AdmType=$P($G(^PAADM(EpisodeID)),"^",2)
	q:((AdmType="E")&&(StayPayMode=1)&&(" 1 2 "[(" "_EMStayFlag_" "))) 0
	s SetSpecBilled=..GetConfigNode("SetSpecBilled")
	s SetChangeSpec=..GetConfigNode("SetChangeSpec")
	if (AdmType="I"){
		if (PisID'=""){
			s subpID=$o(^DHCAPPPM(PisID,"A",""))
			s Oeori=$P(^DHCAPPPM(PisID,"A",subpID),"^",3)
			s PisStatus= ##Class(web.DHCAPPInterface).GetExaReqItmStatus(Oeori,"")
			s APStatus=$p(^DHCAPPPM(PisID),"^",9)   /// 发送状态
			if (APStatus="Y"){
				if (PisStatus'=""){
					if (PisStatus="AP")&&(SetChangeSpec=0){
						s rtn=0
					}else{
						s rtn=1
						}
				}
			}
		}
	}else{
		if (PisID=""){
			if SetSpecBilled=1 s rtn=1
		}else{
			s subpID=$o(^DHCAPPPM(PisID,"A",""))
			s Oeori=$P(^DHCAPPPM(PisID,"A",subpID),"^",3)
			s PisStatus= ##Class(web.DHCAPPInterface).GetExaReqItmStatus(Oeori,"")
			s APStatus=$p(^DHCAPPPM(PisID),"^",9)   /// 发送状态
			s OrdBilled=$p($g(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3)),"^",5)
			if (OrdBilled'="P"){
				if SetSpecBilled=1 s rtn=1
			}else{
			}
			if (APStatus="Y"){
				if (PisStatus'=""){
					if (PisStatus="AP")&&(SetChangeSpec=0){
						s rtn=0
					}else{
						s rtn=1
						}
				}else{
					if SetChangeSpec=1 s rtn=1
				}
			}
			
		}
	}
	q rtn
}

/// 判断固定时间距离体时间的方法
/// w ##class(DHCDoc.DHCApp.BasicConfig).SpecToFixTime("25/03/2020 16:54:32","LIVSetMin")
ClassMethod SpecToFixTime(datetime, Type)
{
	q:datetime="" ""
	s SpecDate=$p(datetime," ",1)
	s SpecTime=$p(datetime," ",2)
	s SpecDate=..%ZDH(SpecDate)
	s SpecTime=..%ZTH(SpecTime)
	s FixDate=""
	s FixTime=""
	if ((SpecTime'="")&&(SpecDate'="")){
		s AddTime=##class(DHCDoc.DHCApp.BasicConfig).GetConfigNode(Type)
		if (AddTime'=""){
			s AddTime=AddTime*60
			s FixTime=SpecTime+AddTime
			s FixDate=SpecDate
			if (FixTime>86399){
				s FixTime=FixTime-86399
				s FixDate=SpecDate+1
				}
		}
	if FixDate'="" s FixDate=..%ZD(FixDate)
	if FixTime'="" s FixTime=..%ZT(FixTime)
	q FixDate_" "_FixTime
		}
}

Query GetLocPrtConfig(desc As %String = "", HospId As %String = "", Type As %String = "") As %Query(ROWSPEC = "LocRowID:%String,LocDesc:%String,LocPrintSetO:%String,LocPrintSetE:%String,LocPrintSetI:%String,LocPrintSetH:%String,LocPrintSetP:%String,LocPrintSetPdesc:%String")
{
}

ClassMethod GetLocPrtConfigExecute(ByRef qHandle As %Binary, desc As %String = "", HospId As %String = "", Type As %String = "") As %Status
{
    ;d ##class(%ResultSet).RunQuery("DHCDoc.DHCApp.BasicConfig","GetLocPrtConfig","","2")
    s LocRowID=0  
    f  s LocRowID=$o(^CTLOC(LocRowID)) q:LocRowID=""  d
    .s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",LocRowID,HospId)
	.q:flag="N"
	.s LocHospDr=$p(^CTLOC(LocRowID),"^",22)
	.Q:LocHospDr'=HospId
    .s LocDesc=$p(^CTLOC(LocRowID),"^",2)
    .s CTLOCType=$p(^CTLOC(LocRowID),"^",13)
    .q:(CTLOCType'="E")&&(CTLOCType'="W")&&(CTLOCType'="EM")&&(CTLOCType'="OP")
	.q:##class(web.DHCDocCommon).CheckLocIsValid(LocRowID)=0
	.q:##class(web.DHCOPAdmReg).CheckLocDesc(LocRowID,desc)=0
    .s CTLocContactName=$P(^CTLOC(LocRowID),"^",43)
    .s Node=LocRowID_"_"_Type
    .s (LocPrintSetO,LocPrintSetE,LocPrintSetI,LocPrintSetH,LocPrintSetP,LocPrintSetPdesc)=""
    .s SortFlag="B"
    .if $d(^DHCDocAppConfig("LocPrtSet",Node)) d
    ..s ConfigStr=$g(^DHCDocAppConfig("LocPrtSet",Node))
    ..if Type="P" d
    ...s LocPrintSetP=ConfigStr
    ...s LocPrintSetPdesc=$case(ConfigStr,"saveprint":"保存并打印","sentprint":"发送并打印","noprint":"不自动打印",:"")
	...if LocPrintSetPdesc'="" d
	....s LocDesc="<font style='color:red'>[已配置]</font>"_LocDesc
	....s SortFlag="A"
    ..else  d
    ...s LocPrintSetO=(","_ConfigStr_",")[(",O,")
    ...s LocPrintSetE=(","_ConfigStr_",")[(",E,")
    ...s LocPrintSetI=(","_ConfigStr_",")[(",I,")
    ...s LocPrintSetH=(","_ConfigStr_",")[(",H,")
    .Do OutputRowGetLocPrtConfig
    Quit $$$OK
OutputRowGetLocPrtConfig
    set Data=$lb($g(LocRowID),$g(LocDesc),$g(LocPrintSetO),$g(LocPrintSetE),$g(LocPrintSetI),$g(LocPrintSetH),$g(LocPrintSetP),$g(LocPrintSetPdesc))
    Set qHandle(SortFlag,$I(ind))=Data
    Quit
}

ClassMethod GetLocPrtConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocPrtConfigExecute ]
{
	s SortNo=$O(qHandle(""))
	if SortNo'=""{
		s ind=$O(qHandle(SortNo,""))
		if ind'=""{
			s Row=qHandle(SortNo,ind)
			k qHandle(SortNo,ind)
			Quit $$$OK
		}
	}
	s AtEnd=1
	Quit $$$OK
}

/// w ##Class(DHCDoc.DHCApp.BasicConfig).GetAppPrtSetConfig("I","Exa","2^5")
ClassMethod GetAppPrtSetConfig(AdmType As %String, Type As %String, LgParam As %String) As %String
{
	s HospID=$p(LgParam,"^",1) 
	s CTLocID=$p(LgParam,"^",2) 
	s SetValue=""	
	if (Type="Exa"){
		s LocNodeVal=CTLocID_"_E"
		s NodeVal="PrintExa"
		d GetSetValue
	}elseif (Type="Lab"){
		s LocNodeVal=CTLocID_"_L"
		s NodeVal="PrintLab"
		d GetSetValue
	}elseif (Type="Pis"){
		s LocNodeVal=CTLocID_"_P"
		s NodeVal="PrintSet"
		s SetValue=""
		if $d(^DHCDocAppConfig("LocPrtSet",LocNodeVal)){
			s SetValue=$g(^DHCDocAppConfig("LocPrtSet",LocNodeVal))
		}else{
			s SetValue=..GetConfigNode(NodeVal,HospID)
		}
	}
	
	q SetValue
GetSetValue
	s SetValue=0
	if $d(^DHCDocAppConfig("LocPrtSet",LocNodeVal)){
		s ConfigStr=$g(^DHCDocAppConfig("LocPrtSet",LocNodeVal))
		if ((","_ConfigStr_",")[(","_AdmType_",")){
			s SetValue=1	
		}
	}else{
		s ConfigStr=..GetConfigNode(NodeVal,HospID)
		if ((","_ConfigStr_",")[(","_AdmType_",")){
			s SetValue=1	
		}
	}
	Q SetValue
}

Query GetTCTWomenConfig(desc As %String = "", HospId As %String = "") As %Query(ROWSPEC = "LocRowID:%String,LocDesc:%String,LocSexInclude:%String,LocSexIncludeDr:%String,LocWomenset:%String")
{
}

ClassMethod GetTCTWomenConfigExecute(ByRef qHandle As %Binary, desc As %String = "", HospId As %String = "") As %Status
{
    ;d ##class(%ResultSet).RunQuery("DHCDoc.DHCApp.BasicConfig","GetTCTWomenConfig","","2")
    s LocRowID=0 
    for{
	    s LocRowID=$o(^CTLOC(LocRowID)) 
	    q:LocRowID="" 
	    s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",LocRowID,HospId)
		continue:flag="N"
		s LocHospDr=$p(^CTLOC(LocRowID),"^",22)
		continue:LocHospDr'=HospId
		s LocDesc=$p(^CTLOC(LocRowID),"^",2)
		s CTLOCType=$p(^CTLOC(LocRowID),"^",13)
		continue:(CTLOCType'="E")&&(CTLOCType'="W")&&(CTLOCType'="EM")&&(CTLOCType'="OP")
		continue:##class(web.DHCDocCommon).CheckLocIsValid(LocRowID)=0
		continue:##class(web.DHCOPAdmReg).CheckLocDesc(LocRowID,desc)=0
		s CTLocContactName=$P(^CTLOC(LocRowID),"^",43)
		s Node=LocRowID_"_TCT" 
		s LocSexInclude="",LocSexIncludeDr="",LocWomenset=""
		s SortFlag="B"
		if $d(^DHCDocAppConfig("Womenset",Node)) {
    		s ConfigStr=$g(^DHCDocAppConfig("Womenset",Node))
    		s LocWomenset=$P(ConfigStr,"^",1)
    		s LocSexIncludeDr=$P(ConfigStr,"^",2)
    		s LocWomensetDesc=$case(LocWomenset,"0":"妇科信息不必填","1":"妇科信息必填",:"")
    		s LocSexDesc=""
			if (LocSexIncludeDr'=""){
				for i=1:1:$l(LocSexIncludeDr,","){
					s SexID=$P(LocSexIncludeDr,",",i)
					s SexDesc=$P(^CT("SEX",SexID),"^",2)
					if (LocSexDesc=""){s LocSexDesc=SexDesc}else{s LocSexDesc=LocSexDesc_","_SexDesc}
					}
				}
			s LocSexInclude=LocWomensetDesc_":"_LocSexDesc
			if ((LocSexDesc'="")||(LocWomensetDesc'="")){
				s LocDesc="<font style='color:red'>[已配置]</font>"_LocDesc
				s SortFlag="A"
			}
			} 
		set Data=$lb($g(LocRowID),$g(LocDesc),$g(LocSexInclude),$g(LocSexIncludeDr),$g(LocWomenset))
   		Set qHandle(SortFlag,$I(ind))=Data
	    }

    Quit $$$OK
}

ClassMethod GetTCTWomenConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTCTWomenConfigExecute ]
{
	s SortNo=$O(qHandle(""))
	if SortNo'=""{
		s ind=$O(qHandle(SortNo,""))
		if ind'=""{
			s Row=qHandle(SortNo,ind)
			k qHandle(SortNo,ind)
			Quit $$$OK
		}
	}
	s AtEnd=1
	Quit $$$OK
}

ClassMethod CheckTCTWomenConfig(EpisodeID, LocID)
{
	s TCTWomen=0
	s TCTWomen=##class(DHCDoc.DHCApp.BasicConfig).GetConfigNode("TCTWomen")
	if (EpisodeID'=""){
		s PatientID=$p(^PAADM(EpisodeID),"^",1)
		s sexId=+$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
		s Node=LocID_"_TCT" 
		if $d(^DHCDocAppConfig("Womenset",Node)) {
			s ConfigStr=$g(^DHCDocAppConfig("Womenset",Node))
			s LocWomenset=$P(ConfigStr,"^",1)
    		s LocSexIncludeDr=$P(ConfigStr,"^",2)
    		if (LocWomenset=0){
	    		if ((","_LocSexIncludeDr_",")[(","_sexId_",")) {s TCTWomen=0}
	    		if (LocSexIncludeDr="") {s TCTWomen=0}
	    		}
    		if (LocWomenset=1){
	    		if ((","_LocSexIncludeDr_",")[(","_sexId_",")) {s TCTWomen=1}
	    		if (LocSexIncludeDr="") {s TCTWomen=1}
	    		}
			}
	}
	q TCTWomen
}

ClassMethod SentAppionmentAd(EpisodeID, arReqID, HospId)
{
	q:(EpisodeID="")||(arReqID="")||(HospId="") ""
	s Addresss=..GetConfigNode("SentAppionmentAd",HospId)
	if (Addresss'="") {
		s PaitentID=$p($g(^PAADM(EpisodeID)),"^",1)
		s Addresss=$replace(Addresss,"{EpisodeID}",EpisodeID)
		s Addresss=$replace(Addresss,"{PaitentID}",PaitentID)
		s ExaRepNo=$p(^DHCAPREP(arReqID),"^",1) 
		s Addresss=$replace(Addresss,"{ExaRepNo}",ExaRepNo)
		s CH="",oeori=""
		f  {
			s CH=$o(^DHCAPREP(arReqID,"AR",CH)) 
			Q:CH=""
			s oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3) 
			q:oeori'=""
			}
		s Addresss=$replace(Addresss,"{OEORDID}",oeori)
		}
	q Addresss
}

}
