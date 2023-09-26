Class web.DHCOPRegConfig Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 68;

ClassMethod AdmDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AdmDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod AdmDepExecute(ByRef qHandle As %Binary, GroupRowId As %String = "", HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCOPRegConfig","AdmDep")
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
 s GroupResRowIdStr="",DocDesc=""
 i $D(^SSU("SSGRP",GroupRowId,"DHC",HospId)) d
 .s GroupResRowIdStr=$P($G(^SSU("SSGRP",GroupRowId,"DHC",HospId)),"^",1)
 s CTLOCRowId=0 f  s CTLOCRowId=$O(^PAC("ADMLOC",0,"AdmType","O",CTLOCRowId)) Q:CTLOCRowId=""  d
	.Q:'$d(^RB("RES",0,"CTLOC",CTLOCRowId))
	.s ResRowIdStr=""
	.s CTLocDesc=$p($g(^CTLOC(CTLOCRowId)),"^",2)
	.i GroupResRowIdStr'="" d
	..s ResRowId=0  f  s ResRowId=$O(^RB("RES",0,"CTLOC",CTLOCRowId,ResRowId)) Q:ResRowId=""  d
	...s DocRowId=$P(^RB("RES",ResRowId),"^",2)
	...s:DocRowId="" ^NullDocINResource(ResRowId)=""
	...s:DocRowId'="" DocDesc=$p($g(^CTPCP(DocRowId,1)),"^",2)
	...Q:("!"_GroupResRowIdStr_"!")'[("!"_ResRowId_"!")
	...i ResRowIdStr="" s ResRowIdStr=ResRowId
	...e  s ResRowIdStr=ResRowIdStr_"!"_ResRowId
	.s ResRowIdStr=CTLOCRowId_$C(1)_ResRowIdStr
 .Do OutputRow6 	
 //增加急诊科室
  s CTLOCRowId=0 f  s CTLOCRowId=$O(^PAC("ADMLOC",0,"AdmType","E",CTLOCRowId)) Q:CTLOCRowId=""  d
	.Q:'$d(^RB("RES",0,"CTLOC",CTLOCRowId))
	.s ResRowIdStr=""
	.s CTLocDesc=$p($g(^CTLOC(CTLOCRowId)),"^",2)
	.i GroupResRowIdStr'="" d
	..s ResRowId=0  f  s ResRowId=$O(^RB("RES",0,"CTLOC",CTLOCRowId,ResRowId)) Q:ResRowId=""  d
	...s DocRowId=$P(^RB("RES",ResRowId),"^",2)
	...q:(DocRowId="")
	...s DocDesc=$p($g(^CTPCP(DocRowId,1)),"^",2)
	...Q:("!"_GroupResRowIdStr_"!")'[("!"_ResRowId_"!")
	...i ResRowIdStr="" s ResRowIdStr=ResRowId
	...e  s ResRowIdStr=ResRowIdStr_"!"_ResRowId
	.s ResRowIdStr=CTLOCRowId_$C(1)_ResRowIdStr
 .Do OutputRow6 	 	
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(ResRowIdStr,CTLocDesc)
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	quit
}

ClassMethod AdmDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AdmDepExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 取帐单子类串
ClassMethod GetBillSubStr() As %String
{
	;w ##class(web.DHCOPRegConfig).GetBillSubStr()
	s ret=""
	s BillGrpRowId=0 f  s BillGrpRowId=$O(^ARCBG(BillGrpRowId)) Q:BillGrpRowId=""  d
	.s Child=0 f  s Child=$O(^ARCBG(BillGrpRowId,"SG",Child)) Q:Child=""  d
	..s BillSubRowId=BillGrpRowId_"||"_Child
	..s BillSubDesc=$P(^ARCBG(BillGrpRowId,"SG",Child),"^",2)
	..s ret1=BillSubRowId_$C(1)_BillSubDesc
	..i ret="" s ret=ret1
	..e  s ret=ret_"^"_ret1
	Q ret
}

/// 取服务组串
ClassMethod GetRBCServiceGroup() As %String
{
	s ret=""
	s SGRowId=0 f  s SGRowId=$o(^RBC("SG",SGRowId)) q:SGRowId=""  d
	.s SGDateFrom=$p(^RBC("SG",SGRowId),"^",6)
	.q:(SGDateFrom'="")&&(SGDateFrom>+$h)
	.s SGDateTo=$p(^RBC("SG",SGRowId),"^",7)
	.q:(SGDateTo'="")&&(SGDateTo<=..%SysDate())
	.s SGDesc=$p(^RBC("SG",SGRowId),"^",2)
	.s ret1=SGRowId_$C(1)_SGDesc
	.i ret="" s ret=ret1
	.e  s ret=ret_"^"_ret1
	Q ret
}

/// creator:guorongyong
/// date:20100816
/// desc:取老年人免费设置串
ClassMethod GetOldManFreeStr() As %String
{
	;w ##class(web.DHCOPRegConfig).GetOldManFreeStr()
	
	s retItem1="1"_$c(1)_"70岁以上老人"
	s retItem2="2"_$c(1)_"有老年证老人"
	
	s ret=retItem1_"^"_retItem2
	
	Q ret
}

/// creator:guorongyong
/// date:20170828
/// desc:启用医保实时结算配置串
ClassMethod GetEnableInsuBillStr() As %String
{
	s retItem1="0"_$c(1)_""
	s retItem1="1"_$c(1)_"按费别优先"
	s retItem2="2"_$c(1)_"按界面传入参数优先"
	
	s ret=retItem1_"^"_retItem2
	
	Q ret
}

ClassMethod GetConfigNode() As %String
{
	s ret=""
	s tmpNode="" f  s tmpNode=$o(^DHCOPRegConfig(tmpNode)) q:tmpNode=""  d
	.s tmpNodeinfo=$g(^DHCOPRegConfig(tmpNode))
	.i ret=""  s ret=tmpNode_"!"_tmpNodeinfo
	.e  s ret=ret_"^"_tmpNode_"!"_tmpNodeinfo
	q ret
}

ClassMethod GetGroupRegRoom(GroupRowId As %String, HospId As %String = "") As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	Q:'$d(^SSU("SSGRP",GroupRowId,"DHC",HospId)) ""
	Q $P(^SSU("SSGRP",GroupRowId,"DHC",HospId),"^",2)
}

ClassMethod GetGroupRes(GroupRowId As %String, HospId As %String = "") As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	Q:'$d(^SSU("SSGRP",GroupRowId,"DHC",HospId)) ""
	Q $P(^SSU("SSGRP",GroupRowId,"DHC",HospId),"^",1)
}

ClassMethod GetRoomStr(HospRowId As %String = "") As %String
{
	if (HospRowId="") s HospRowId=%session.Get("LOGON.HOSPID")
	set ret=""
	Set rset=##class(%ResultSet).%New("web.DHCRBResSession:LookUpRoom")
	do rset.Execute("",HospRowId)
	While (rset.Next()) {
		s RowId=rset.GetData(3)
		s Desc=rset.GetData(1)
		s TRData=RowId_$C(1)_Desc
		i ret="" s ret=TRData
		e  s ret=ret_"^"_TRData
	}
	Q ret
}

ClassMethod GetSpecConfigNode(NodeName As %String, HospId As %String = "") As %String
{
	Q:NodeName="" ""
	s srt=""
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s str=$g(^DHCOPRegConfig(HospCodeNode,NodeName))
	}else{
		s str=$g(^DHCOPRegConfig(NodeName))
	}
	q str
}

ClassMethod GetSpecConfigNodeHosp(NodeName As %String, HospID As %String) As %String
{
	Q:NodeName="" ""
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	Q:'$d(^DHCOPRegConfig("HospDr_"_HospID,NodeName)) ""
	Q $g(^DHCOPRegConfig("HospDr_"_HospID,NodeName))
}

ClassMethod GetSpecConfigNodeByUniqu(NodeName As %String, UniquValue As %String) As %String
{
	Q:(NodeName="")||(UniquValue="") ""
	Q:'$d(^DHCOPRegConfig(NodeName,UniquValue)) ""
	Q $g(^DHCOPRegConfig(NodeName,UniquValue))
}

ClassMethod LocConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LocConfigExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s LocDesc="",DefultDay=""
 i '$d(^DHCOPRegConfig("LocConF"))  d
 .s LocID="" f  s LocID=$o(^DHCOPRegConfig("LocConF",LocID)) q:LocID=""  d
 ..s DefultDay="" f  s DefultDay=$o(^DHCOPRegConfig("LocConF",LocID,DefultDay)) q:DefultDay=""  d
 ...s LocDesc=$p($g(^CTLOC(LocID)),"^",2)
 ...Do OutputRow	 	

 Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow

	set Data=$lb(LocDesc,DefultDay)
 Set ^CacheTemp(repid,LocDesc)=Data	
 Set ind=ind+1
	quit
}

ClassMethod LocConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocConfigExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LoclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LoclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LoclookupExecute(ByRef qHandle As %Binary, desc As %String, HospitalID As %String = "") As %Status
{
	s HospitalID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospitalID)
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s ^TMPGWJ=desc
 s desc=$$ALPHAUP^SSUTIL4(desc)
 s LocId=0 f  s LocId=$o(^CTLOC(LocId)) q:LocId=""  d
 .s CTLOCType=$p(^CTLOC(LocId),"^",13)
 .q:(CTLOCType="W")!(CTLOCType="OR")
 .Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",LocId,HospitalID)
 .s LocHospitalID=$p($g(^CTLOC(LocId)),"^",22)
 .s ActiveDateFrom=$p($g(^CTLOC(LocId)),"^",24)
 .Q:(ActiveDateFrom'="")&&(ActiveDateFrom>+$h)
 .s ActiveDateTo=$p($g(^CTLOC(LocId)),"^",25)
 .Q:(ActiveDateTo'="")&&(ActiveDateTo'>+$h)
 .;Q:((HospitalID'="")&&(LocHospitalID'=HospitalID))
 .q:($P(^CTLOC(LocId),"^",14)'="Y")
 .s LocDesc=$p(^CTLOC(LocId),"^",2)
 .s LocCode=$p(^CTLOC(LocId),"^",1)
 .s LocContactName=$p(^CTLOC(LocId),"^",43)
 .//q:(desc'="")&(LocDesc'[desc)&(LocContactName'[desc)
 .Q:'##class(web.DHCOPAdmReg).CheckLocDesc(LocId,desc)
 .s NodeStr=..GetConfigNode1("OPRegDepExpand",LocId)
 .s LocInsuNotRealTime=$p(NodeStr,"^",1)
 .s RegQtyNotAMP=$p(NodeStr,"^",2)
 .s LocRegLimit=$p(NodeStr,"^",3)
 .;i LocInsuNotRealTime=..TransCheckBox(LocInsuNotRealTime)
 .;
 .Do OutputRow7 	 	

 Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow7
	set Data=$lb(LocDesc,LocId,LocCode,LocInsuNotRealTime,RegQtyNotAMP,LocRegLimit)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
}

ClassMethod LoclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LoclookupExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod PutConfigNode(Nodeinfo As %String) As %String
{
	s Node=$p(Nodeinfo,"!",1)
	s Info=$p(Nodeinfo,"!",2)
	s ^DHCOPRegConfig(Node)=Info
}

ClassMethod SaveConfigHosp(Coninfo As %String, HospID As %String = "") As %String
{
	s ConNum=$l(Coninfo,"^")
	f i=1:1:ConNum  d
	.s evNoteinfo=$p(Coninfo,"^",i)
	.s evNote=$p(evNoteinfo,"!",1)
	.i evNote'=""  d ..PutConfigNodeHosp(evNoteinfo,HospID)
	q 0
}

ClassMethod PutConfigNodeHosp(Nodeinfo As %String, HospID As %String = "") As %String
{
	s Node=$p(Nodeinfo,"!",1)
	s Info=$p(Nodeinfo,"!",2)
	s ^DHCOPRegConfig("HospDr_"_HospID,Node)=Info
}

ClassMethod SaveConfig(Coninfo As %String) As %String
{
	s ConNum=$l(Coninfo,"^")
	f i=1:1:ConNum  d
	.s evNoteinfo=$p(Coninfo,"^",i)
	.s evNote=$p(evNoteinfo,"!",1)
	.i evNote'=""  d ..PutConfigNode(evNoteinfo)
	q 0
}

ClassMethod SaveConfig1(Node As %String, Node1 As %String, NodeValue As %String) As %String
{
	q:(Node="")||(Node1="") 0
	s ^DHCOPRegConfig(Node,Node1)=NodeValue
	q 0
}

ClassMethod GetConfigNode1(Node As %String, Node1 As %String) As %String
{
	q:(Node="")||(Node1="") 0
	q $g(^DHCOPRegConfig(Node,Node1))
}

ClassMethod SaveGroupRegRoom(GroupRowId As %String, ResRoomStr As %String, HospId As %String = "") As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s $P(^SSU("SSGRP",GroupRowId,"DHC",HospId),"^",2)=ResRoomStr
	Q 0
}

ClassMethod SaveGroupRegRoomNew(GroupRowId As %String, InResRoomStr As %String, OutResRoomStr As %String, HospId As %String = "") As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s OldResRoomStr=$P($g(^SSU("SSGRP",GroupRowId,"DHC",HospId)),"^",2)
	if (OldResRoomStr="") {
		Q ..SaveGroupRegRoom(GroupRowId,InResRoomStr,HospId)
	}else{
		s NewResRoomStr=""
		s ResRoomStr=OldResRoomStr_"!"_InResRoomStr
		for i=1:1:$l(ResRoomStr,"!") {
			s RoomId=$p(ResRoomStr,"!",i)
			if ("!"_OutResRoomStr_"!")'[("!"_RoomId_"!") {
				i NewResRoomStr="" s NewResRoomStr=RoomId
				e  s NewResRoomStr=NewResRoomStr_"!"_RoomId
			}
		}
		Q ..SaveGroupRegRoom(GroupRowId,NewResRoomStr,HospId)
	}
}

/// modify:郭荣勇
/// date:2017-08-31
/// 说明：
/// %CSP.CharacterStream类型接收前端数据,如果未超长则同%String处理
/// %String类型接收前端数据,如果字符超长则会直接变为"%CSP.CharacterStream"这样一个字符串
ClassMethod SaveGroupRes(GroupRowId As %String, ResRowIdCharStream As %CSP.CharacterStream) As %String
{
	;s ^tmpgry("SaveGroupRes")=ResRowIdCharStream
	if '$IsObject(ResRowIdCharStream) {
		s $P(^SSU("SSGRP",GroupRowId,"DHC"),"^",1)=ResRowIdCharStream
	}else{
		While 'ResRowIdCharStream.AtEnd {
			s PartCharStr=ResRowIdCharStream.Read(1024,.sc)
			If $$$ISERR(sc) {
				s ^DHCOPRegConfigSSGRP(GroupRowId,"Log",+$h,$p($zts,",",2))=sc_","_$ZERROR
			}else{
				s $P(^SSU("SSGRP",GroupRowId,"DHC"),"^",1)=$P($g(^SSU("SSGRP",GroupRowId,"DHC")),"^",1)_PartCharStr
			}
		}
	}
	
	Q 0
}

ClassMethod SetAdmDep(itmjs As %Library.String = "", GroupRowId As %String) As %String
{
	;w ##class(web.DHCOPRegConfig).SetAdmDep(6)
	Set rset=##Class(%ResultSet).%New("web.DHCOPRegConfig:AdmDep")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(GroupRowId)
		If 'Status Quit
		While (rset.Next()) {
			s CTLOCDesc=rset.GetData(2)
			s ResRowIdStr=rset.GetData(1)
		    
	   		s retval=itmjs_"('"_$ZCVT(CTLOCDesc,"O","JS")_"','"_$ZCVT(ResRowIdStr,"O","JS")_"');"
			&javascript<#(retval)#>
		}
		d rset.Close()
	}
	Q 0
}

ClassMethod SetAdmDep1(itmjs As %Library.String = "", GroupRowId As %String, DepDesc As %String) As %String
{
	;w ##class(web.DHCOPRegConfig).SetAdmDep(1,"jzn")
	Set rset=##Class(%ResultSet).%New("web.DHCOPRegConfig:AdmDep")
	Set DepDesc=$ZCVT(DepDesc,"U")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(GroupRowId)
		If 'Status Quit
		While (rset.Next()) {
			s CTLOCDesc=rset.GetData(2)
			continue:(CTLOCDesc'[DepDesc)&&(DepDesc'="")
			s ResRowIdStr=rset.GetData(1)
	   		s retval=itmjs_"('"_$ZCVT(CTLOCDesc,"O","JS")_"','"_$ZCVT(ResRowIdStr,"O","JS")_"');"
			&javascript<#(retval)#>
		}
		d rset.Close()
	}
	Q 0
}

Query AdmDep(GroupRowId As %String) As %Query(ROWSPEC = "ResRowIdStr:%String,LocDesc:%String")
{
}

Query LocConfig(desc As %String) As %Query(ROWSPEC = "LocDesc:%String,DefultDay:%String")
{
}

Query Loclookup(desc As %String, HospitalID As %String = "") As %Query(ROWSPEC = "LocDesc:%String,LocId:%String,LocCode:%String,LocInsuNotRealTime:%String,RegQtyNotAMP:%String,LocRegLimit:%String")
{
}

// 检查科室是否有权限挂号 0 无，1有

ClassMethod CheckLocAuthority(LocID As %String, GroupID As %String = "") As %String
{
	 s Counter=0
	 i GroupID="" d                                                  
	 .s GroupRes=##class(web.DHCOPRegConfig).GetGroupRes(%session.Get("LOGON.GROUPID"))
	 e  d
	 .s GroupRes=##class(web.DHCOPRegConfig).GetGroupRes(GroupID)
	 q:GroupRes="" "1"
     set ResRowID=0
     for  set ResRowID=$o(^RB("RES",0,"CTLOC",LocID,ResRowID)) q:((ResRowID="")||(Counter>0))  d
     .s:((GroupRes'="")&&(("!"_GroupRes_"!")[("!"_ResRowID_"!"))) Counter=Counter+1     
    quit Counter
}

/// 查询所有安全组
/// do ##class(%ResultSet).RunQuery("web.DHCOPRegConfig","GetGroupAll","")
ClassMethod GetGroupAllExecute(ByRef qHandle As %Binary, Desc As %String, HospID = "") As %Status
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	Set repid=$I(^CacheTemp)
	s ind=1
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s GroupRowID=0
	f  s GroupRowID=$o(^SSU("SSGRP",GroupRowID)) q:GroupRowID=""  d 
	.s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_Group",GroupRowID,HospID)
	.q:flag="N"
	.s GroupDesc=$p(^SSU("SSGRP",GroupRowID),"^",1)
	.q:((Desc'="")&($$ALPHAUP^SSUTIL4(GroupDesc)'[Desc))
	.s ActiveFlag=$p(^SSU("SSGRP",GroupRowID),"^",151)
	.q:ActiveFlag="N"
	.d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build    
	set Data=$lb(GroupDesc,GroupRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetGroupAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupAllExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetGroupAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupAllExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetGroupAll(Desc As %String, HospID = "") As %Query(ROWSPEC = "GroupDesc:%String,GroupRowID:%String")
{
}

ClassMethod SaveForceRetGro(InStr As %String)
{
	s GroupID=$p(InStr,"^",1)
	s ForceRetFlag=$p(InStr,"^",2)
	s ^DHCOPRegConfig("ForceCancelRegGroup",GroupID)=ForceRetFlag
	q 0
}

ClassMethod DeleteForceRetGro(InStr As %String)
{
	s GroupID=$p(InStr,"^",1)
	k ^DHCOPRegConfig("ForceCancelRegGroup",GroupID)
	q 0
}

/// 查询已配置强退号安全组
/// do ##class(%ResultSet).RunQuery("web.DHCOPRegConfig","GetForceRetGroup","")
ClassMethod GetForceRetGroupExecute(ByRef qHandle As %Binary, GroupID As %String, HospRowId = "") As %Status
{
	s HospRowId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospRowId)
	Set repid=$I(^CacheTemp)
	s ind=1
	i GroupID=""{
		s GroupRowID=0
		f  s GroupRowID=$o(^DHCOPRegConfig("ForceCancelRegGroup",GroupRowID)) q:GroupRowID=""  d 
		.s GroupID=GroupRowID
		.s GroupDesc=$p(^SSU("SSGRP",GroupRowID),"^",1)
		.q:'$d(^DHCOPRegConfig("ForceCancelRegGroup",GroupRowID))
		.s ForceRetFlag=$p(^DHCOPRegConfig("ForceCancelRegGroup",GroupRowID),"^",1)
		.s:ForceRetFlag="Y" ForceRet="是"
		.s:ForceRetFlag="N" ForceRet="否"
		.d Build1
	}
	else {
		i '$d(^DHCOPRegConfig("ForceCancelRegGroup",GroupID)){
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK	
		}
		s GroupDesc=$p(^SSU("SSGRP",GroupID),"^",1)
		s ForceRetFlag=$p(^DHCOPRegConfig("ForceCancelRegGroup",GroupID),"^",1)
		s:ForceRetFlag="Y" ForceRet="是"
		s:ForceRetFlag="N" ForceRet="否"
		d Build1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build1
	Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_Group",GroupID,HospRowId)
	set Data=$lb(GroupDesc,GroupID,ForceRet)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	q
}

ClassMethod GetForceRetGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetForceRetGroupExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetForceRetGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetForceRetGroupExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetForceRetGroup(GroupID As %String, HospRowId = "") As %Query(ROWSPEC = "TSSGroup:%String,TGroupID:%String,TForceReturn:%String")
{
}

/*Query GetBillSubStr() As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "ARCSGRowId:%String,ARCSGDesc:%String")
{
	SELECT ARCSG_RowId,ARCSG_Desc FROM SQLUser.ARC_BillSub
}*/
Query GetBillSubStr(HospRowId = "") As websys.Query(ROWSPEC = "ARCSGRowId:%String,ARCSGDesc:%String")
{
}

ClassMethod GetBillSubStrExecute(ByRef qHandle As %Binary, HospRowId = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s HospRowId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospRowId)
	s ARCBGRowId=0
	for {
		s ARCBGRowId=$o(^ARCBG(ARCBGRowId)) Q:ARCBGRowId=""
		s ARCSGChildSub=0
		for {
			s ARCSGChildSub=$o(^ARCBG(ARCBGRowId,"SG",ARCSGChildSub)) Q:ARCSGChildSub=""
			s ARCSGRowId=ARCBGRowId_"||"_ARCSGChildSub
			continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_BillSub",ARCSGRowId,HospRowId)
			s ARCSGDesc=$p(^ARCBG(ARCBGRowId,"SG",ARCSGChildSub),"^",2)
			d OutPutRow99
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow99
	set Data=$lb(ARCSGRowId,ARCSGDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	q
}

/// do ##class(%ResultSet).RunQuery("web.DHCOPRegConfig","GetRBCServiceGroup","")
ClassMethod GetRBCServiceGroupExecute(ByRef qHandle As %Binary, HospID = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s SGRowId=0 f  s SGRowId=$o(^RBC("SG",SGRowId)) q:SGRowId=""  d
	.q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_ServiceGroup",SGRowId,HospID)
	.s SGDateFrom=$p(^RBC("SG",SGRowId),"^",6)
	.q:(SGDateFrom'="")&&(SGDateFrom>+$h)
	.s SGDateTo=$p(^RBC("SG",SGRowId),"^",7)
	.q:(SGDateTo'="")&&(SGDateTo<=..%SysDate())
	.s SGDesc=$p(^RBC("SG",SGRowId),"^",2)
	.d OutPutRow8
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow8    
	set Data=$lb(SGRowId,SGDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	q
}

ClassMethod GetRBCServiceGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRBCServiceGroupExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRBCServiceGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRBCServiceGroupExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetRBCServiceGroup(HospID = "") As %Query(ROWSPEC = "SGRowId:%String,SGDesc:%String")
{
}

/// do ##class(%ResultSet).RunQuery("web.DHCOPRegConfig","GetEnableInsuBillStr","")
ClassMethod GetEnableInsuBillStrExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s EnableInsuBillStr=..GetEnableInsuBillStr()
	s len=$l(EnableInsuBillStr,"^")
	f i=1:1:len{
		s EnableInsuBillInfo=$p(EnableInsuBillStr,"^",i)
		continue:EnableInsuBillInfo=""
		s InsuBillId=$p(EnableInsuBillInfo,$c(1),1)
		s InsuBillDesc=$p(EnableInsuBillInfo,$c(1),2)
		d OutPutRow9
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow9    
	set Data=$lb(InsuBillId,InsuBillDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	q
}

ClassMethod GetEnableInsuBillStrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnableInsuBillStrExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEnableInsuBillStrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEnableInsuBillStrExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetEnableInsuBillStr() As %Query(ROWSPEC = "InsuBillId:%String,InsuBillDesc:%String")
{
}

/// w ##class(web.DHCOPRegConfig).GetDHCOPRegConfigInfo()
ClassMethod GetDHCOPRegConfigInfo(HospID As %String = "")
{
	s DHCOPRegConfigInfo=""
	s AppQtyDefault=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("AppQtyDefault",HospID)
	s AppStartNoDefault=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("AppStartNoDefault",HospID)
	s AdmTimeRangeCount=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("AdmTimeRangeCount",HospID)
	s AppBreakLimit=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("AppBreakLimit",HospID)
	s AppDaysLimit=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("AppDaysLimit",HospID)
	s SchedulePeriod=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("SchedulePeriod",HospID)
	s RegStartTime=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("RegStartTime",HospID)
	s AppStartTime=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("AppStartTime",HospID)
	s AddStartTime=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("AddStartTime",HospID)
	s CommonCardNo=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("CommonCardNo",HospID)
	s DayRegCountLimit=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("DayRegCountLimit",HospID)
	s DaySameLocRegCountLimit=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("DaySameLocRegCountLimit",HospID)
	s DaySameDocRegCountLimit=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("DaySameDocRegCountLimit",HospID)
	s MRArcimInfo=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("MRArcimId",HospID)
	s NeedBillCardFeeOrder=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("NeedBillCardFeeOrder",HospID)
	s FreeOrder=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("FreeOrder",HospID)
	s RegFeeBillSub=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("RegFeeBillSub",HospID)
	s CheckFeeBillSub=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("CheckFeeBillSub",HospID)
	s AppFeeBillSub=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("AppFeeBillSub",HospID)
	s HoliFeeBillSub=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("HoliFeeBillSub",HospID)
	s ReCheckFeeBillSub=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("ReCheckFeeBillSub",HospID)
	s RegServiceGroup=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("RegServiceGroup",HospID)
	s EnableInsuBill=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("EnableInsuBill",HospID)
	s IFScreenStart=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("IFScreenStart",HospID)
	s IFTeleAppStart=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("IFTeleAppStart",HospID)
	s NotNullRealAmount=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("NotNullRealAmount",HospID)
	s ReturnNotAllowReg=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("ReturnNotAllowReg",HospID)
	s ReturnNotAllowAdd=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("ReturnNotAllowAdd",HospID)
	s AppReturnNotAllowRegAdd=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("AppReturnNotAllowRegAdd",HospID)
	s NotNeedNotFeeBill=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("NotNeedNotFeeBill",HospID)
	s RegTreeQuery=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("RegTreeQuery",HospID)
	s HolidayNotCreateSche=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("HolidayNotCreateSche",HospID)
	s AdvanceAppAdm=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("AdvanceAppAdm",HospID)
	s IsHideExaBor=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("IsHideExaBor",HospID)
	s MedifyPatTypeSynAdmRea=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("MedifyPatTypeSynAdmRea",HospID)
	s DaySameTimeRegLimit=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("DaySameTimeRegLimit",HospID)
	s OPRegListDefault=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("OPRegListDefault",HospID)
	s AllowOpenAllRoms=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("AllowOpenAllRoms",HospID)
	s TempCardRegCountLimit=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("TempCardRegCountLimit",HospID)
	s CancelRegNeedINVPrt=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("CancelRegNeedINVPrt",HospID)
	s QryScheduleByClinicGroup=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("QryScheduleByClinicGroup",HospID)
	s OPReturnReason=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("OPReturnReason",HospID)
	s AllocInsuBill=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("AllocInsuBill",HospID)
	s TimeRangeInclude=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("TimeRangeInclude",HospID)
	s DocOPRegistBill=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("DocOPRegistBill",HospID)
	s InPatNotAllowOPRegist=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("InPatNotAllowOPRegist",HospID)
	s DocOPRegistInsu=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("DocOPRegistInsu",HospID)
	s OPRegistShowTimeRange=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("OPRegistShowTimeRange",HospID)
	s SeqNoOverRangeTime=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("SeqNoOverRangeTime",HospID)
	s SeqNoOverRangeTimeAdd=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("SeqNoOverRangeTimeAdd",HospID)
	s ResoduSeqNoAnyTime=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("ResoduSeqNoAnyTime",HospID)
	s DHCOPRegConfigInfo=AppQtyDefault_$c(1)_AppStartNoDefault_$c(1)_AdmTimeRangeCount_$c(1)_AppBreakLimit_$c(1)_AppDaysLimit_$c(1)_SchedulePeriod_$c(1)_RegStartTime    //1-7
	s DHCOPRegConfigInfo=DHCOPRegConfigInfo_$c(1)_AppStartTime_$c(1)_AddStartTime_$c(1)_CommonCardNo_$c(1)_DayRegCountLimit_$c(1)_DaySameLocRegCountLimit_$c(1)_DaySameDocRegCountLimit    //8-13
	s DHCOPRegConfigInfo=DHCOPRegConfigInfo_$c(1)_MRArcimInfo_$c(1)_NeedBillCardFeeOrder_$c(1)_FreeOrder_$c(1)_RegFeeBillSub_$c(1)_CheckFeeBillSub_$c(1)_AppFeeBillSub   //14-19
	s DHCOPRegConfigInfo=DHCOPRegConfigInfo_$c(1)_HoliFeeBillSub_$c(1)_ReCheckFeeBillSub_$c(1)_RegServiceGroup_$c(1)_EnableInsuBill_$c(1)_IFScreenStart_$c(1)_IFTeleAppStart    //20-25
	s DHCOPRegConfigInfo=DHCOPRegConfigInfo_$c(1)_NotNullRealAmount_$c(1)_ReturnNotAllowReg_$c(1)_ReturnNotAllowAdd_$c(1)_AppReturnNotAllowRegAdd_$c(1)_NotNeedNotFeeBill_$c(1)_RegTreeQuery     //26-31
	s DHCOPRegConfigInfo=DHCOPRegConfigInfo_$c(1)_HolidayNotCreateSche_$c(1)_AdvanceAppAdm_$c(1)_IsHideExaBor_$c(1)_MedifyPatTypeSynAdmRea_$C(1)_DaySameTimeRegLimit _$C(1)_OPRegListDefault    //32-36
	s DHCOPRegConfigInfo=DHCOPRegConfigInfo_$c(1)_AllowOpenAllRoms_$c(1)_TempCardRegCountLimit_$c(1)_CancelRegNeedINVPrt_$c(1)_QryScheduleByClinicGroup_$c(1)_OPReturnReason_$C(1)_AllocInsuBill
	s DHCOPRegConfigInfo=DHCOPRegConfigInfo_$c(1)_TimeRangeInclude_$c(1)_DocOPRegistBill_$c(1)_InPatNotAllowOPRegist_$c(1)_DocOPRegistInsu_$c(1)_OPRegistShowTimeRange
	s DHCOPRegConfigInfo=DHCOPRegConfigInfo_$c(1)_SeqNoOverRangeTime_$c(1)_SeqNoOverRangeTimeAdd_$c(1)_ResoduSeqNoAnyTime
	q DHCOPRegConfigInfo
}

/// 增加例外科室
ClassMethod InsertTimeLocDoc(TimeRangeID As %String, LocID As %String, MarkID As %String)
{
	q:((TimeRangeID="")||(LocID="")||(MarkID="")) ""
	Q:$d(^DHCOPRegConfig("DaySameTimeRegLimit",TimeRangeID,LocID,MarkID)) "repeat"
	s ^DHCOPRegConfig("DaySameTimeRegLimit",TimeRangeID,LocID,MarkID)=1
	q 0
}

/// 删除列外科室
ClassMethod DeleteTimeLocDoc(RowID)
{
	q:RowID="" ""
	s TimeRangeID=$P(RowID,"^",1)
	s LocID=$P(RowID,"^",2)
	s MarkID=$P(RowID,"^",3)
	if ('$d(^DHCOPRegConfig("DaySameTimeRegLimit",TimeRangeID,LocID,MarkID))) q ""
	k ^DHCOPRegConfig("DaySameTimeRegLimit",TimeRangeID,LocID,MarkID)
	q 0
}

/// 查询例外科室
/// do ##class(%ResultSet).RunQuery("web.DHCOPRegConfig","FindTimeLocDoc")
ClassMethod FindTimeLocDocExecute(ByRef qHandle As %Binary, HospRowId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s TimeRangeID=""
	for{
		s TimeRangeID=$o(^DHCOPRegConfig("DaySameTimeRegLimit",TimeRangeID))
		q:TimeRangeID=""
		s LocID=""
		for{
			s LocID=$o(^DHCOPRegConfig("DaySameTimeRegLimit",TimeRangeID,LocID))
			q:LocID=""
			s LocHospId=$p(^CTLOC(LocID),"^",22)
			continue:(LocHospId'=HospRowId)&&(HospRowId'="")
			s MarkID=""
			for{
				s MarkID=$O(^DHCOPRegConfig("DaySameTimeRegLimit",TimeRangeID,LocID,MarkID))
				q:MarkID=""
				s Rowid=TimeRangeID_"^"_LocID_"^"_MarkID
				s TimeRangeDesc=$p(^DHCTimeRange(TimeRangeID),"^",2)
				s LocDesc=$p($g(^CTLOC(LocID)),"^",2)
				s DocDesc=$p(^CTPCP(MarkID,1),"^",2)
				set Data=$lb(Rowid,TimeRangeDesc,LocDesc,DocDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindTimeLocDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTimeLocDocExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindTimeLocDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTimeLocDocExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindTimeLocDoc(HospRowId As %String = "") As %Query(ROWSPEC = "Rowid:%String,TimeRange:%String,LocDesc:%String,DocDesc:%String")
{
}

/// 查询表对应的医院
/// do ##class(%ResultSet).RunQuery("web.DHCOPRegConfig","FindHopital","DHC_CardTypeDef",1)
ClassMethod FindHopitalExecute(ByRef qHandle As %Binary, BDPMPHTableName As %String, BDPMPHDataReference As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s HospID=""
    if ($d(^User.BDPMappingHospI("HospRef",BDPMPHTableName,BDPMPHDataReference)))
    {
        for {
	        s HospID=$O(^User.BDPMappingHospI("HospRef",BDPMPHTableName,BDPMPHDataReference,HospID))
	        q:HospID=""
	        s Rowid=$O(^User.BDPMappingHospI("HospRef",BDPMPHTableName,BDPMPHDataReference,HospID,0))
	        s HospDesc=$p(^CT("HOSP",HospID),"^",2)
	        set Data=$lb(Rowid,HospDesc,HospID)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	        }
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindHopitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHopitalExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindHopitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHopitalExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindHopital(BDPMPHTableName As %String, BDPMPHDataReference As %String) As %Query(ROWSPEC = "Rowid:%String,HospDesc:%String,HospID:%String")
{
}

/// create 20200316 by yl
/// 科室排序类型列表
Query GetLocSortTypeList() As %SQLQuery(ROWSPEC = "rowid:%String,Type:%String")
{
	select ID,SortType from SQLUser.BDP_Sort where TableName="User.CTLoc" group by SortType
}

/// 查询该科室号别时段的数
/// 功能控制(安全组)
/// 保存安全组控制
ClassMethod SaveGroupConfig(HospId, GroupID, Node1, Node2)
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ^DHCOPRegConfig(HospCodeNode,GroupID,Node1)=Node2
	}
}

/// 得到安全组控制
ClassMethod GetGroupConfig(HospId, GroupID, Node1)
{
	s ret=""
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ret=$g(^DHCOPRegConfig(HospCodeNode,GroupID,Node1))
	}
	q ret
}

ClassMethod SaveRegSetConfig(HospId, GroupID, NodeStr)
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	q:((HospId="")||(GroupID="")) ""
	for i=1:1:$L(NodeStr,"^"){ 
		s OneNode=$P(NodeStr,"^",i)
		s Node1=$P(OneNode,"!",1)
		s Node2=$P(OneNode,"!",2)
		d ..SaveGroupConfig(HospId,GroupID,Node1,Node2)
		}
	q 0
}

ClassMethod GetRegSetConfig(HospId, GroupID)
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	q:((HospId="")||(GroupID="")) ""
	s rtn=..GetGroupConfig(HospId,GroupID,"ForceCancelRegGroup")
	s rtn=rtn_$c(1)_..GetGroupConfig(HospId,GroupID,"OPNotReportGroup")
	s rtn=rtn_$c(1)_..GetGroupConfig(HospId,GroupID,"OPAllocReport")
	s rtn=rtn_$c(1)_..GetGroupConfig(HospId,GroupID,"ScheduleSentMessage")
	s rtn=rtn_$c(1)_..GetGroupConfig(HospId,GroupID,"MessageSentFunction")
	s rtn=rtn_$c(1)_..GetGroupConfig(HospId,GroupID,"MessageSentContent")
	s rtn=rtn_$c(1)_..GetGroupConfig(HospId,GroupID,"BookPreLocDocLimit")
	s rtn=rtn_$c(1)_..GetGroupConfig(HospId,GroupID,"BookPreLocNurseLimit")
	s rtn=rtn_$c(1)_..GetGroupConfig(HospId,GroupID,"BookPreLocCashLimit")
	s rtn=rtn_$c(1)_..GetGroupConfig(HospId,GroupID,"RegDefaultSearch")
	s rtn=rtn_$c(1)_..GetGroupConfig(HospId,GroupID,"OPRegInsertOrder")
	s rtn=rtn_$c(1)_..GetGroupConfig(HospId,GroupID,"OPRegAdmCategory")
	q rtn
}

/// 时段上的报到时间控制
ClassMethod SaveReportTimeRange(HospId, TimeRangeID, TimeRangeStr)
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	q:(HospId="") ""
	d ..SaveGroupConfig(HospId,"TimeRangeReport",TimeRangeID,TimeRangeStr)
	q ""
}

ClassMethod GetReportTimeRange(HospId, TimeRangeID)
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	q:(HospId="") ""
	q ..GetGroupConfig(HospId,"TimeRangeReport",TimeRangeID)
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPRegConfig","PACAdmCategoryList")
Query PACAdmCategoryList() As websys.Query(ROWSPEC = "ADMCATRowId:%String,ADMCATCode:%String,ADMCATDesc:%String,ADMCATIsPayAfterTrea:%String")
{
}

ClassMethod PACAdmCategoryListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	set ret=""
	Set rset=##class(%ResultSet).%New("web.DHCBL.CT.PACAdmCategory:GetList")
	do rset.Execute("","","")
	While (rset.Next()) {
		s ADMCATRowId=rset.GetData(1)
		s ADMCATCode=rset.GetData(2)
		s ADMCATDesc=rset.GetData(3)
		s ADMCATDateFrom=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",3)
		if (ADMCATDateFrom'="")&&(ADMCATDateFrom>+$H){
			continue
		}
		s ADMCATDateTo=$p($g(^PAC("ADMCAT",ADMCATRowId)),"^",4)
		if (ADMCATDateTo'="")&&(ADMCATDateTo<+$H){
			continue
		}
		s ADMCATIsPayAfterTrea=rset.GetData(10)
		d OutputRow1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    set Data=$lb(ADMCATRowId,ADMCATCode,ADMCATDesc,ADMCATIsPayAfterTrea)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

}
