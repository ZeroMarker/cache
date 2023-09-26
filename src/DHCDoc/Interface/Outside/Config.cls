Class DHCDoc.Interface.Outside.Config Extends DHCDoc.Util.RegisteredObject
{

/// Creator:    nikang
/// Desc:       为对外预约挂号接口所做配置
/// CreateTime：2017-08-08
/// Modify:2021-01-20 云His改造，加入院区属性
ClassMethod PutConfigNode(Nodeinfo As %String, Node1 As %String, HospId As %String = "") As %String
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}else{
		s HospCodeNode=""
	}
	s GroupID=Node1
	s Node=$p(Nodeinfo,$C(1),1)
	s Info=$p(Nodeinfo,$C(1),2)
	if (Node="LockNotAllowAdd")!(Node="BarCardType")!(Node="LockActiveTime")!(Node="SelfAdmReason"){
		if HospCodeNode'=""{
			s ^DHCOPRegConfig(HospCodeNode,"ExternalService",Node)=Info
		}else{
			s ^DHCOPRegConfig("ExternalService",Node)=Info
		}
	}elseif (Node="EmpowerRes"){
		;院区，ExternalService，安全组，科室
		s EmpowerLoc=$p(Nodeinfo,$C(1),3)
		s Node=Node_"_"_EmpowerLoc
		if HospCodeNode'=""{
			s ^DHCOPRegConfig(HospCodeNode,"ExternalService",GroupID,Node)=Info
		}else{
			s ^DHCOPRegConfig("ExternalService",GroupID,Node)=Info
		}
	}else{
		if HospCodeNode'=""{
			s ^DHCOPRegConfig(HospCodeNode,"ExternalService",GroupID,Node)=Info
		}else{
			s ^DHCOPRegConfig("ExternalService",GroupID,Node)=Info
		}
	}
}

ClassMethod SaveConfig(Coninfo As %String, Node1 As %String, HospId As %String = "") As %String
{
	s ConNum=$l(Coninfo,$C(2))
	f i=1:1:ConNum  d
	.s evNoteinfo=$p(Coninfo,$C(2),i)
	.i evNoteinfo'="" d ..PutConfigNode(evNoteinfo,Node1,HospId)
	q 0
}

ClassMethod GetConfigNode(NodeValue As %String, NodeName As %String, HospId As %String = "", OId As %String = "") As %String
{
	s str=""
	Q:NodeName="" str
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (NodeName="LockNotAllowAdd")!(NodeName="BarCardType")!(NodeName="LockActiveTime")!(NodeName="SelfAdmReason"){
		if (HospId'="") {
			s HospCodeNode="HospDr_"_HospId
			s str=$g(^DHCOPRegConfig(HospCodeNode,"ExternalService",NodeName))
		}else{
			s str=$g(^DHCOPRegConfig("ExternalService",NodeName))
		}
	}elseif (NodeName="EmpowerRes"){
		Q:(NodeValue="")!(OId="") str
		s NodeName=NodeName_"_"_OId
		if (HospId'="") {
			s HospCodeNode="HospDr_"_HospId
			s str=$g(^DHCOPRegConfig(HospCodeNode,"ExternalService",NodeValue,NodeName))
		}else{
			s str=$g(^DHCOPRegConfig("ExternalService",NodeValue,NodeName))
		}
	}else{
		Q:NodeValue="" str
		if (HospId'="") {
			s HospCodeNode="HospDr_"_HospId
			s str=$g(^DHCOPRegConfig(HospCodeNode,"ExternalService",NodeValue,NodeName))
		}else{
			s str=$g(^DHCOPRegConfig("ExternalService",NodeValue,NodeName))
		}
	}
	Q str
}

ClassMethod getDefaultData(Node1 As %String, Node2 As %String, HospId As %String = "") As %String
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}else{
		s HospCodeNode=""
	}
	s rtn=""
	if (Node2="LockNotAllowAdd")!(Node2="LockActiveTime"){
		if (HospCodeNode'="") {
			s rtn=$g(^DHCOPRegConfig(HospCodeNode,"ExternalService",Node2))
		}else{
			s rtn=$g(^DHCOPRegConfig("ExternalService",Node2))
		}
	}else{
		if (HospCodeNode'="") {
			s rtn=$g(^DHCOPRegConfig(HospCodeNode,"ExternalService",Node1,Node2))
		}else{
			s rtn=$g(^DHCOPRegConfig("ExternalService",Node1,Node2))
		}
	}
	s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

/// Desc:保存默认数据设置
/// d ##class(DHCDoc.Interface.Outside.Config).SetDefaultData(^tmpnk("SetDefaultData"))
ClassMethod SetDefaultData(Coninfo, HospId As %String = "")
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}else{
		s HospCodeNode=""
	}
	
	s ConNum=$l(Coninfo,$C(2))
	f i=1:1:ConNum{
		s evNoteinfo=$p(Coninfo,$C(2),i)
		i evNoteinfo'=""{
			s Node=$p(evNoteinfo,$C(1),1)
			s Info=$p(evNoteinfo,$C(1),2)
			
			if (HospCodeNode'="") {
				s ^DHCRegInterfaceCodeRelate(HospCodeNode,"Default",Node)=Info
			}else{
				s ^DHCRegInterfaceCodeRelate("Default",Node)=Info
			}
		}
	}
	q 0
}

/// Desc:获取默认数据设置
ClassMethod GetDefaultDataNew(Node As %String, HospId As %String = "")
{
	Q:Node="" ""
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s str=$g(^DHCRegInterfaceCodeRelate(HospCodeNode,"Default",Node))
	}else{
		s str=$g(^DHCRegInterfaceCodeRelate("Default",Node))
	}
	Q str
}

Query FindList(ListName As %String, GroupRowId As %String, HospitalId As %String = "", desc As %String = "", otherVal As %String = "") As %Query(ROWSPEC = "RowId:%String,Code:%String,selected:%Boolean")
{
}

ClassMethod FindListExecute(ByRef qHandle As %Binary, ListName As %String, GroupRowId As %String = "", HospitalId As %String = "", desc As %String = "", otherVal As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Outside.Config","FindList","CardType","")
    s HospitalId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospitalId)
    s DefaultData=..GetConfigNode(GroupRowId,ListName,HospitalId)
    s Sortable="NS"
	if ListName="AppRegMethod"{
	    s APTMRowId=0
	 	f  s APTMRowId=$o(^RBC("APTM",APTMRowId)) q:APTMRowId=""  d
	 	.s str=$g(^RBC("APTM",APTMRowId))
	 	.s APTMCode=$p(str,"^",2)
		.s selected=0
		.Do OutputRowFindList
	}elseif ListName="GetPatientIDRule"{
		s TempStr="1"_$c(1)_"GETNEWINSU"_$c(1)_"获取最新含医保号主索引"_"^"_"2"_$c(1)_"GETNEW"_$c(1)_"获取最新主索引"_"^"_"3"_$c(1)_"GETALL"_$c(1)_"获取全部主索引"
		s TempLen=$l(TempStr,"^")
		for TempCount=1:1:TempLen d
		.s aTempStr=$p(TempStr,"^",TempCount)
		.s APTMRowId=$p(aTempStr,$c(1),"2")
		.s APTMCode=$p(aTempStr,$c(1),"3")
		.s selected=0
		.Do OutputRowFindList	
	}elseif ListName="SelfAdmReason"{
		s APTMRowId=0
	    f  s APTMRowId=$o(^PAC("ADMREA",APTMRowId)) q:APTMRowId=""  d
	    .s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("PAC_AdmReason",APTMRowId,HospitalId)
		.Q:flag="N"
	    .s APTMCode=$p(^PAC("ADMREA",APTMRowId),"^",2)
	    .s READateFrom=$p(^PAC("ADMREA",APTMRowId),"^",3)
	    .Q:(READateFrom'="")&&(READateFrom>+$h)
	    .s READateTo=$p(^PAC("ADMREA",APTMRowId),"^",4)
	    .Q:(READateTo'="")&&(READateTo<+$h)
	    .s selected=0
		.Do OutputRowFindList	
	}
	elseif ListName="BarCardType"{
		s APTMRowId=0
	 	f  s APTMRowId=$o(^DHCCARDTYPEDef(APTMRowId)) q:APTMRowId=""  d
	 	.s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_CardTypeDef",APTMRowId,HospitalId)
		.Q:flag="N"
	 	.s str=$g(^DHCCARDTYPEDef(APTMRowId))
	 	.s APTMCode=$p(str,"^",2)
		.s APTMSDate=$p(str,"^",9)
		.Q:(APTMSDate'="")&&(APTMSDate>+$h)
		.s APTMEDate=$p(str,"^",10)
		.Q:(APTMEDate'="")&&(APTMEDate'>+$h)
		.s selected=0
		.Do OutputRowFindList	
	}elseif ListName="DataCompareExtOrg"{
		s APTMRowId=0
	    f  s APTMRowId=$o(^DHCMUCExtOrg(APTMRowId)) q:APTMRowId=""  d
	    .s ExtOrgActiveFlag=$p(^DHCMUCExtOrg(APTMRowId),"^",3)
		.Q:ExtOrgActiveFlag'="Y"
	    .s APTMCode=$p(^DHCMUCExtOrg(APTMRowId),"^",2)
	    .s selected=0
		.Do OutputRowFindList	
	}elseif ListName="AdmReason"{
		s DefaultData=..GetDefaultDataNew(ListName,HospitalId)
		s APTMRowId=0
	    f  s APTMRowId=$o(^PAC("ADMREA",APTMRowId)) q:APTMRowId=""  d
	    .s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("PAC_AdmReason",APTMRowId,HospitalId)
		.Q:flag="N"
	    .s APTMCode=$p(^PAC("ADMREA",APTMRowId),"^",2)
		.s READateFrom=$p(^PAC("ADMREA",APTMRowId),"^",3)
	    .Q:(READateFrom'="")&&(READateFrom>+$h)
	    .s READateTo=$p(^PAC("ADMREA",APTMRowId),"^",4)
	    .Q:(READateTo'="")&&(READateTo<+$h)
	    .s selected=0
		.Do OutputRowFindList	
	}elseif ListName="CardType"{
		s DefaultData=..GetDefaultDataNew(ListName,HospitalId)
		s APTMRowId=0
	 	f  s APTMRowId=$o(^DHCCARDTYPEDef(APTMRowId)) q:APTMRowId=""  d
	 	.s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_CardTypeDef",APTMRowId,HospitalId)
		.Q:flag="N"
	 	.s str=$g(^DHCCARDTYPEDef(APTMRowId))
	 	.s APTMCode=$p(str,"^",2)
	 	.s APTMCode1=$p(str,"^",1)
		.s APTMSDate=$p(str,"^",9)
		.Q:(APTMSDate'="")&&(APTMSDate>+$h)
		.s APTMEDate=$p(str,"^",10)
		.Q:(APTMEDate'="")&&(APTMEDate'>+$h)
		.s selected=0
		.Do OutputRowFindList1	
	}elseif ListName="IDCardType"{
		s DefaultData=..GetDefaultDataNew(ListName,HospitalId)
		s APTMRowId=0
	    f  s APTMRowId=$o(^PAC("CARD",APTMRowId)) q:APTMRowId=""  d
	    .s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("PAC_CardType",APTMRowId,HospitalId)
		.Q:flag="N"
	    .s APTMCode=$p(^PAC("CARD",APTMRowId),"^",2)
	    .s APTMCode1=$p(^PAC("CARD",APTMRowId),"^",1)
		.s APTMSDate=$p(^PAC("CARD",APTMRowId),"^",3)
		.Q:(APTMSDate'="")&&(APTMSDate>+$h)
		.s APTMEDate=$p(^PAC("CARD",APTMRowId),"^",4)
		.Q:(APTMEDate'="")&&(APTMEDate'>+$h)
	    .s selected=0
		.Do OutputRowFindList1	
	}elseif ListName="ExtUserID"{
		s DefaultData=..GetDefaultDataNew(ListName,HospitalId)
		s APTMRowId=0
	    f  s APTMRowId=$o(^SSU("SSUSR",APTMRowId)) q:APTMRowId=""  d
	    .s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",APTMRowId,HospitalId)
		.Q:flag="N"
	    .s APTMCode=$p(^SSU("SSUSR",APTMRowId),"^",2)
	    .s APTMCode1=$p(^SSU("SSUSR",APTMRowId),"^",1)
	    .s selected=0
		.Do OutputRowFindList1	
	}elseif ListName="SSGroup"{
		s desc=$zcvt(desc,"U")
		s APTMRowId=0
	    f  s APTMRowId=$o(^SSU("SSGRP",APTMRowId)) q:APTMRowId=""  d
	    .s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_Group",APTMRowId,HospitalId)
		.Q:flag="N"
		.s ActiveFlag=$p(^SSU("SSGRP",APTMRowId),"^",151)
		.Q:ActiveFlag'="Y"
	    .s APTMCode=$p(^SSU("SSGRP",APTMRowId),"^",1)
	    .Q:(desc'="")&&($zcvt(APTMCode,"U")'[desc)
	    .s selected=0
		.Do OutputRowFindList	
	}elseif ListName="EmpowerLoc"{
		s rs=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.CommonFunction:QueryLoc")
		If rs.QueryIsValid() { 
			 s Status=rs.Execute(desc,"",HospitalId)
			 If 'Status Quit
			 While rs.Next() {
				 s name=rs.GetDataByName("name")
				 s id=rs.GetDataByName("id")
				 s ContactName=rs.GetDataByName("ContactName")
				 s APTMRowId=id
				 s APTMCode=name
				 s selected=0
				 d OutputRowFindList
			 }
		}
	}
	elseif ListName="EmpowerRes"{
		if (otherVal=""){
			Quit $$$OK
		}
		s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospitalId)
		for i=1:1:$l(otherVal,"^") {
			s depid=$p(otherVal,"^",i)
			s GrantedMarkStr=..GetConfigNode(GroupRowId,ListName,HospitalId,depid)
			s GrantedMarkStr="^"_GrantedMarkStr_"^"
			s locDesc=$p(^CTLOC(depid),"^",2)
			s RESRowId=""
			for {
				s RESRowId=$O(^RB("RES",0,"CTLOC",depid,RESRowId))
				q:(RESRowId="")
				s DateActiveFrom=$P(^RB("RES",RESRowId),"^",22)
				continue:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
				s DateActiveTo=$P(^RB("RES",RESRowId),"^",23)
				continue:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
				s CTPCPDR=$P(^RB("RES",RESRowId),"^",2)
				continue:(CTPCPDR="")
				continue:'$D(^CTPCP(CTPCPDR,1))
				s CTPCPDesc=$P(^CTPCP(CTPCPDR,1),"^",2)
				continue:0=##Class(web.DHCExaBorough).CheckDocAlias(CTPCPDR,desc)
				s OtherName=$p(^CTPCP(CTPCPDR,3),"^",28)
				s selected="0"
				if GrantedMarkStr[("^"_RESRowId_"^") s selected="1"
				s APTMRowId=RESRowId
				s APTMCode=CTPCPDesc
				d OutputRowFindList
			}
		}
	}
	Quit $$$OK
OutputRowFindList
	if (DefaultData'="")&&(APTMRowId=DefaultData) s selected=1
	set Data=$lb($g(APTMRowId),$g(APTMCode),$g(selected))
 	set qHandle(Sortable,$I(ind))=Data
	Quit
OutputRowFindList1
	if APTMCode1=DefaultData s selected=1
	set Data=$lb($g(APTMCode1),$g(APTMCode),$g(selected))
 	set qHandle(Sortable,$I(ind))=Data
	Quit
}

ClassMethod FindListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindListExecute ]
{
	s code=$O(qHandle(""))
	if code'=""{
		s ind=$O(qHandle(code,""))
		if ind'=""{
			s Row=qHandle(code,ind)
			k qHandle(code,ind)
			Quit $$$OK
		}
	}
	s AtEnd=1
	Quit $$$OK
}

/// 二级科室排序设置
Query GetMajorLocList(GroupID As %String = "", HospId As %String = "") As %Query(ROWSPEC = "RowID:%String,Name:%String,Code:%String,StartDate:%String,EndDate:%String,HospDesc:%String,MinorCTLocSort:%String ")
{
}

ClassMethod GetMajorLocListExecute(ByRef QHandle As %Binary, GroupID As %String = "", HospId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s MajorID=0
    f  s MajorID=$o(^DHCCTLoc(MajorID)) q:MajorID=""  d
     .s RowID=MajorID
     .s HospDr=$p(^DHCCTLoc(MajorID),"^",5)
     .Q:(HospId'="")&&(HospId'=HospDr)
     .s HospDesc=$p(^CT("HOSP",HospDr),"^",2)
     .s Name=$p(^DHCCTLoc(MajorID),"^",2)
     .s Code=$p(^DHCCTLoc(MajorID),"^",1)
     .s StartDate=$p(^DHCCTLoc(MajorID),"^",3)
     .Q:(StartDate'="")&&(StartDate>+$H)
     .i StartDate'="" s StartDate=..%ZD(StartDate) //$zd(StartDate,4)
     .s EndDate=$p(^DHCCTLoc(MajorID),"^",4)
     .Q:(EndDate'="")&&(EndDate'>+$H)
     .i EndDate'="" s EndDate=..%ZD(EndDate) //$zd(EndDate,4)
     .s MinorCTLocSort=..GetConfigNode(GroupID,"MinorCTLocSort"_RowID,HospId)
	 .s ^CacheTemp(repid,ind)=$lb(RowID,Name,Code,StartDate,EndDate,HospDesc,MinorCTLocSort)
	 .s ind=ind+1
	Quit $$$OK
}

ClassMethod GetMajorLocListClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetMajorLocListExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMajorLocListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMajorLocListExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
