Class web.DHCOPAdmPowerConfig Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取挂号授权号别列表
/// d ##class(%ResultSet).RunQuery("web.DHCOPAdmPowerConfig","FindDoc","30","")
Query FindDoc(GroupId As %String, depstr, docname As %String = "", HospId As %String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "Desc:%String,RowID:%String,ResRowId:%String,PoweredFlag:%String,code:%String")
{
}

ClassMethod FindDocExecute(ByRef qHandle As %Binary, GroupId As %String, depstr, docname As %String = "", HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (depstr=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s GrantedMarkStr=$P($g(^SSU("SSGRP",GroupId,"DHC",HospId)),"^",1)
	s GrantedMarkStr="!"_GrantedMarkStr_"!"
	for i=1:1:$l(depstr,"^") {
		s depid=$p(depstr,"^",i)
		s locDesc=$p(^CTLOC(depid),"^",2)
		s count=1
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
			continue:0=##Class(web.DHCExaBorough).CheckDocAlias(CTPCPDR,docname)
			Set OtherName=$p(^CTPCP(CTPCPDR,3),"^",28)
			if (count=1) s CTPCPDesc=CTPCPDesc_"<span style='color:red;'>---"_locDesc_"</span>"
			s PoweredFlag="N"
			if GrantedMarkStr[("!"_RESRowId_"!") s PoweredFlag="Y"
			s count=count+1
			d OutputRow2
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow2
	Set ^CacheTemp(repid,ind)=$LB(CTPCPDesc,CTPCPDR,RESRowId,PoweredFlag,OtherName)
	Set ind=ind+1
	quit
}

/// 获取安全组挂号已授权列表
/// d ##class(%ResultSet).RunQuery("web.DHCOPAdmPowerConfig","FindPoweredByGroup","30","")
Query FindPoweredByGroup(GroupId As %String, Depstr As %String, isShowDoc As %String, HospRowId As %String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "CTPCPDesc:%String,CTPCPDR:%String,RESRowId:%String,LocId:%String,LocDesc:%String")
{
}

ClassMethod FindPoweredByGroupExecute(ByRef qHandle As %Binary, GroupId As %String, Depstr As %String, isShowDoc As %String, HospRowId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (GroupId=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s HospRowId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospRowId)
	s GrantedMarkStr=$P($g(^SSU("SSGRP",GroupId,"DHC",HospRowId)),"^",1)
	if (GrantedMarkStr="") {
		s CTPCPDesc="",CTPCPDR="",RESRowId="",LocId="",LocDesc="<span style='color:red;font-weight:bold;'>可挂所有号别<span>"
		d OutputRow3
	}else{
		k ^TempPoweredLoc($j)
		for i=1:1:$l(GrantedMarkStr,"!") {
			s RESRowId=$p(GrantedMarkStr,"!",i)
			continue:'$D(^RB("RES",RESRowId))
			s DateActiveFrom=$P(^RB("RES",RESRowId),"^",22)
			continue:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
			s DateActiveTo=$P(^RB("RES",RESRowId),"^",23)
			continue:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
			s CTPCPDR=$P(^RB("RES",RESRowId),"^",2)
			continue:(CTPCPDR="")
			continue:'$D(^CTPCP(CTPCPDR,1))
			s CTPCPDesc=$P(^CTPCP(CTPCPDR,1),"^",2)
			s LocId=$p(^RB("RES",RESRowId),"^",1)
			s LocHosDr=$p(^CTLOC(LocId),"^",22)
			continue:((HospRowId'="")&&(##class(DHCDoc.Common.Hospital).GetMultiHospConfigLoc(HospRowId,LocId)="N"))
			continue:(Depstr'="")&&(("^"_Depstr_"^")'[("^"_LocId_"^"))
			s LocDesc=$p(^CTLOC(LocId),"^",2)
			continue:(isShowDoc="N")&&($d(^TempPoweredLoc($j,LocId)))
			if (isShowDoc="N") s CTPCPDesc=""
			s ^TempPoweredLoc($j,LocId)=1
			d OutputRow3
		}
		k ^TempPoweredLoc($j)
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow3
	Set ^CacheTemp(repid,ind)=$LB(CTPCPDesc,CTPCPDR,RESRowId,LocId,LocDesc)
	Set ind=ind+1
	quit
}

/// 获取排班授权号别列表
/// d ##class(%ResultSet).RunQuery("web.DHCOPAdmPowerConfig","FindResDoc","30","")
Query FindResDoc(UserId As %String, depstr, docname As %String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "Desc:%String,RowID:%String,ResRowId:%String,PoweredFlag:%String,code:%String")
{
}

ClassMethod FindResDocExecute(ByRef qHandle As %Binary, UserId As %String, depstr, docname As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (UserId="")||(depstr=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	for i=1:1:$l(depstr,"^") {
		s depid=$p(depstr,"^",i)
		s locDesc=$p(^CTLOC(depid),"^",2)
		s count=1
		s RESRowId=""
		for {
			s RESRowId=$O(^RB("RES",0,"CTLOC",depid,RESRowId))
			q:(RESRowId="")
			s RESScheduleRequired=$p($g(^RB("RES",RESRowId)),"^",6)
			continue:RESScheduleRequired="N"
			s DateActiveFrom=$P(^RB("RES",RESRowId),"^",22)
			continue:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
			s DateActiveTo=$P(^RB("RES",RESRowId),"^",23)
			continue:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
			s CTPCPDR=$P(^RB("RES",RESRowId),"^",2)
			continue:(CTPCPDR="")
			continue:'$D(^CTPCP(CTPCPDR,1))
			set ActiveFlag=$p($g(^CTPCP(CTPCPDR,1)),"^",9)
			continue:ActiveFlag'="Y"
			s CTPCPDesc=$P(^CTPCP(CTPCPDR,1),"^",2)
			continue:0=##Class(web.DHCExaBorough).CheckDocAlias(CTPCPDR,docname)
			Set OtherName=$p(^CTPCP(CTPCPDR,3),"^",28)
			if (count=1) s CTPCPDesc=CTPCPDesc_"<span style='color:red;'>---"_locDesc_"</span>"
			s PoweredFlag="N"
			s:##class(web.DHCUserGroup).UserCanDo(UserId,depid,CTPCPDR,"","REG") PoweredFlag="Y"
			s count=count+1
			d OutputRow4
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow4
	Set ^CacheTemp(repid,ind)=$LB(CTPCPDesc,CTPCPDR,RESRowId,PoweredFlag,OtherName)
	Set ind=ind+1
	quit
}

/// 获取排班员已授权号别列表
/// d ##class(%ResultSet).RunQuery("web.DHCOPAdmPowerConfig","FindPoweredByUser","30","")
Query FindPoweredByUser(UserId As %String, Depstr As %String, isShowDoc As %String, HospRowId As %String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "CTPCPDesc:%String,CTPCPDR:%String,RESRowId:%String,LocId:%String,LocDesc:%String")
{
}

ClassMethod FindPoweredByUserExecute(ByRef qHandle As %Binary, UserId As %String, Depstr As %String, isShowDoc As %String, HospRowId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (UserId=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	k ^TempPoweredLoc($j)
	s DeptId=0
	for {
		s DeptId=$O(^User.DHCUserGroupI("UserLocDoc"," REG"," "_UserId,DeptId)) Q:DeptId=""
		s LocId=##class(web.DHCDocUtil).Replace(DeptId," ","")
		s LocHosDr=$p(^CTLOC(LocId),"^",22)
		continue:(HospRowId'="")&&(LocHosDr'=HospRowId)
		continue:(Depstr'="")&&(("^"_Depstr_"^")'[("^"_LocId_"^"))
		s LocDesc=$p(^CTLOC(LocId),"^",2)
		s DocID=0
		for {
			s DocID=$O(^User.DHCUserGroupI("UserLocDoc"," REG"," "_UserId," "_LocId,DocID)) Q:DocID=""
			s CTPCPDR=##class(web.DHCDocUtil).Replace(DocID," ","")
			continue:'$D(^CTPCP(CTPCPDR,1))
			s RESRowId=$o(^RB("RES",0,"CTPCP",CTPCPDR,LocId,""))
			continue:RESRowId=""
			continue:'$D(^RB("RES",RESRowId))
			s DateActiveFrom=$P(^RB("RES",RESRowId),"^",22)
			continue:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
			s DateActiveTo=$P(^RB("RES",RESRowId),"^",23)
			continue:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
			s CTPCPDesc=$P(^CTPCP(CTPCPDR,1),"^",2)
			if (isShowDoc="N") s CTPCPDesc="",CTPCPDR=""
			continue:(isShowDoc="N")&&($d(^TempPoweredLoc($j,LocId)))
			continue:($P(^CTLOC(LocId),"^",14)'="Y")
			s ^TempPoweredLoc($j,LocId)=1
			d OutputRow5
		}
	}
	
	k ^TempPoweredLoc($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow5
	Set ^CacheTemp(repid,ind)=$LB(CTPCPDesc,CTPCPDR,RESRowId,LocId,LocDesc)
	Set ind=ind+1
	quit
}

/// 获取资源表
/// d ##class(%ResultSet).RunQuery("web.DHCOPAdmPowerConfig","FindResList","30","")
Query FindResList(DeptId As %String, MarkId As %String) As websys.Query(CONTAINID = 0, ROWSPEC = "CTPCPDesc:%String,CTPCPDR:%String,RESRowId:%String,LocId:%String,LocDesc:%String")
{
}

ClassMethod FindResListExecute(ByRef qHandle As %Binary, DeptId As %String, MarkId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (DeptId=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s LocDesc=$p(^CTLOC(DeptId),"^",2)
	s RESRowId=""
	for {
		s RESRowId=$O(^RB("RES",0,"CTLOC",DeptId,RESRowId))
		q:(RESRowId="")
		s DateActiveFrom=$P(^RB("RES",RESRowId),"^",22)
		continue:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
		s DateActiveTo=$P(^RB("RES",RESRowId),"^",23)
		continue:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
		s CTPCPDR=$P(^RB("RES",RESRowId),"^",2)
		continue:(CTPCPDR="")
		continue:(MarkId'="")&&(CTPCPDR'=MarkId)
		continue:'$D(^CTPCP(CTPCPDR,1))
		set ActiveFlag=$p($g(^CTPCP(CTPCPDR,1)),"^",9)
		continue:ActiveFlag'="Y"
		s CTPCPDesc=$P(^CTPCP(CTPCPDR,1),"^",2)
		d OutputRow6
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow6
	Set ^CacheTemp(repid,ind)=$LB(CTPCPDesc,CTPCPDR,RESRowId,DeptId,LocDesc)
	Set ind=ind+1
	quit
}

/// 获取安全组
/// d ##class(%ResultSet).RunQuery("web.DHCOPAdmPowerConfig","FindGroupByRes","30")
Query FindGroupByRes(ResRowId As %String, groupDesc As %String = "", HospRowId As %String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "GroupId:%String,GroupDesc:%String,GrantedFlag:%String")
{
}

ClassMethod FindGroupByResExecute(ByRef qHandle As %Binary, ResRowId As %String, groupDesc As %String = "", HospRowId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (ResRowId=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s HospRowId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospRowId)
	k ^TempGroupList($j)
	s GroupId=0
	for {
		s GroupId=$o(^SSU("SSGRP",GroupId)) Q:GroupId=""
		s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_Group",GroupId,HospRowId)
		continue:flag="N"
		s GroupDesc=$p(^SSU("SSGRP",GroupId),"^",1)
		continue:(groupDesc'="")&&(($ZCVT(GroupDesc,"U"))'[($ZCVT(groupDesc,"U")))
		s ActiveFlag=$p(^SSU("SSGRP",GroupId),"^",151)
	    continue:ActiveFlag="N"
		s GrantedMarkStr=$P($G(^SSU("SSGRP",GroupId,"DHC",HospRowId)),"^",1)
		s GrantedFlag=0
		s Data=$lb(GroupId,GroupDesc,GrantedFlag)
		if (GrantedMarkStr="") {
			s GroupDesc=GroupDesc_"<span style='color:red;font-weight:bold;'> 可挂所有号别<span>"
			s $list(Data,2)=GroupDesc
			s ^TempGroupList($j,3,GroupId)=Data
		}else{
			if ("!"_GrantedMarkStr_"!")[("!"_ResRowId_"!")  {
				s $list(Data,3)=1
				s ^TempGroupList($j,1,GroupId)=Data
			}else{
				s ^TempGroupList($j,2,GroupId)=Data
			}
		}
	}
	s index=0
	for {
		s index=$o(^TempGroupList($j,index)) Q:index=""
		s id=0
		for {
			s id=$o(^TempGroupList($j,index,id)) Q:id=""
			s Data=$g(^TempGroupList($j,index,id))
			d OutputRow8
		}
	}
	k ^TempGroupList($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// 获取排版员排班列表
/// d ##class(%ResultSet).RunQuery("web.DHCOPAdmPowerConfig","FindUserByRes","30")
Query FindUserByRes(ResRowId As %String, userDesc As %String = "", HospRowId = "") As websys.Query(CONTAINID = 0, ROWSPEC = "UserId:%String,UserName:%String,GrantedFlag:%String")
{
}

ClassMethod FindUserByResExecute(ByRef qHandle As %Binary, ResRowId As %String, userDesc As %String = "", HospRowId = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (ResRowId=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s HospRowId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospRowId)
	s RESCTLOCDR=$p(^RB("RES",ResRowId),"^",1)
	s LocHospDr=$p(^CTLOC(RESCTLOCDR),"^",22)
	k ^TempUserList($j)
	s UserId=0
	for {
		s UserId=$o(^SSU("SSUSR",UserId)) Q:UserId=""
		s SSUSRHospitalDR=$p($g(^SSU("SSUSR",UserId)),"^",98)
		;continue:SSUSRHospitalDR'=LocHospDr
		continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",UserId,HospRowId)
		s UserName=$p(^SSU("SSUSR",UserId),"^",2)
		continue:0=##class(DHCDoc.Util.Base).CheckUserName("SS_User",UserId,userDesc)
		s USRActive=$p(^SSU("SSUSR",UserId),"^",19)
		continue:USRActive'="Y"
		s Datefrom=$p(^SSU("SSUSR",UserId),"^",96)
		s DateTo=$p(^SSU("SSUSR",UserId),"^",97)
		continue:(Datefrom'="")&&(Datefrom>+$H)
		continue:(DateTo'="")&&(DateTo<+$H)
		s CTPCPDR=$P(^RB("RES",ResRowId),"^",2)
		s LocId=$p(^RB("RES",ResRowId),"^",1)
		s GrantedFlag=0
		s:##class(web.DHCUserGroup).UserCanDo(UserId,LocId,CTPCPDR,"","REG") GrantedFlag=1
		s data=$lb(UserId,UserName,GrantedFlag)
		s ^TempUserList($j,GrantedFlag,UserId)=data
	}
	s index=""
	for {
		s index=$o(^TempUserList($j,index),-1) Q:index=""
		s id=0
		for {
			s id=$o(^TempUserList($j,index,id)) Q:id=""
			s Data=$g(^TempUserList($j,index,id))
			d OutputRow9
		}
	}
	k ^TempUserList($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// 科室号别授权->排班授权
ClassMethod SaveResSchedulePower(ResRowId As %Library.String = "")
{
	s Type="REG"
	s CTPCPDR=$P(^RB("RES",ResRowId),"^",2)
	s LocId=$p(^RB("RES",ResRowId),"^",1)
	set userDelim="UserIdz",GrantedDelim="GrantedFlagz"
	set userRow=$o(%request.Data(userDelim))
	while (userRow'="")&(userRow[userDelim){
		set rowIndex=$p(userRow,userDelim,2)
		set menuAccessRow=GrantedDelim_rowIndex
		set UserID=+$g(%request.Data(userRow,1))
		set GrantFlag=$s($g(%request.Data(menuAccessRow,1))="on":1,1:0)
		//排班已授权	
		if (##class(web.DHCUserGroup).UserCanDo(UserID,LocId,CTPCPDR,"","REG")) {
			if (GrantFlag=0) {
				&sql(delete from SQLUser.DHCUserGroup where UsegUsername=:UserID and UsegUsergroup=:LocId and UsegType=:Type and UsegDoc=:CTPCPDR)
			}
		}else{
			if (GrantFlag=1) {
				s rtn=##class(web.DHCUserGroup).insu("","",UserID,LocId,CTPCPDR,Type)
			}
		}
		set userRow=$o(%request.Data(userRow))
	}
	Q 0
}

/// 科室号别授权->挂号授权
ClassMethod SaveResRegPower(ResRowId As %Library.String = "", HospId As %String = "")
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	set GroupDelim="GroupIdz",GrantedDelim="GrantedFlagz"
	set groupRow=$o(%request.Data(GroupDelim))
	while (groupRow'="")&(groupRow[GroupDelim){
		set rowIndex=$p(groupRow,GroupDelim,2)
		set menuAccessRow=GrantedDelim_rowIndex
		set GroupID=+$g(%request.Data(groupRow,1))
		set GrantFlag=$s($g(%request.Data(menuAccessRow,1))="on":1,1:0)
		set GrantedMarkStr=$P($g(^SSU("SSGRP",GroupID,"DHC",HospId)),"^",1)
		if (GrantedMarkStr="")&&(GrantFlag=1) {
			set $P(^SSU("SSGRP",GroupID,"DHC",HospId),"^",1)=ResRowId
		}else{
			s resPara=""
			s osLen=$l(GrantedMarkStr,"!")
			if (("!"_GrantedMarkStr_"!")[("!"_ResRowId_"!")) {
				if (GrantFlag=0) {
					for i=1:1:osLen {
						s curValue=$p(GrantedMarkStr,"!",i)
						i ("!"_ResRowId_"!")'[("!"_curValue_"!") {
							i resPara="" s resPara=curValue
							e  s resPara=resPara_"!"_curValue
						}
					}
				}else{
					s resPara=GrantedMarkStr
				}
			}else{
				if (GrantFlag=1) {
					s resPara=GrantedMarkStr_"!"_ResRowId
				}else{
					s resPara=GrantedMarkStr
				}
			}
			s $P(^SSU("SSGRP",GroupID,"DHC",HospId),"^",1)=resPara
		}
		set groupRow=$o(%request.Data(groupRow))
	}
	Q 0
}

/// 排班授权(按排版员)
ClassMethod SaveSchedulePower(UserId As %String, Depstr As %String, inPara As %String, outPara As %String) As %String
{
	s rtn=0
	for i=1:1:$l(Depstr,"^") {
		s dept=$p(Depstr,"^",i)
		for i=1:1:$l(outPara,"!") {
			s ResRowId=$p(outPara,"!",i)
			continue:(ResRowId="")
			s CTPCPDR=$P($G(^RB("RES",ResRowId)),"^",2)
			s LocId=$P($G(^RB("RES",ResRowId)),"^",1)

			&sql(delete from SQLUser.DHCUserGroup where UsegUsername=:UserId and UsegUsergroup=:LocId and UsegType='REG' and UsegDoc=:CTPCPDR)
		}
		//d ##class(web.DHCUserGroup).delu("","",UserId,dept,"REG")
	}
	if (inPara'=""){
		for i=1:1:$l(inPara,"^") {
			s ResRowId=$p(inPara,"^",i)
			s CTPCPDR=$P(^RB("RES",ResRowId),"^",2)
			s LocId=$p(^RB("RES",ResRowId),"^",1)
			s rtn=##class(web.DHCUserGroup).insu("","",UserId,LocId,CTPCPDR,"REG")
		}
	}
	Q rtn
}

ClassMethod DeleteSchedulePower(UserId As %String, DeptId As %String, DocId As %String) As %String
{
	s type="REG"
	if (DocId="") {
		&sql(delete from SQLUser.DHCUserGroup where UsegUsername=:UserId and UsegUsergroup=:DeptId and UsegType=:type)
	}else{
		&sql(delete from SQLUser.DHCUserGroup where UsegUsername=:UserId and UsegUsergroup=:DeptId and UsegType=:type and UsegDoc=:DocId)
	}
	i SQLCODE=100 s SQLCODE=0
	Q SQLCODE
}

/// 获取诊室列表
/// d ##class(%ResultSet).RunQuery("web.DHCOPAdmPowerConfig","FindPoweredByGroup","30","")
Query FindRoomByGroup(GroupId As %String, Desc As %String, HospRowId As %String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "RoomId:%String,RoomName:%String,GrantedFlag:%String")
{
}

ClassMethod FindRoomByGroupExecute(ByRef qHandle As %Binary, GroupId As %String, Desc As %String, HospRowId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	s HospRowId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospRowId)
	s GroupRegRoomStr=##class(web.DHCOPRegConfig).GetGroupRegRoom(GroupId,HospRowId)
	Set rset=##class(%ResultSet).%New("web.DHCRBResSession:LookUpRoom")
	do rset.Execute(Desc,HospRowId)
	While (rset.Next()) {
		s RoomId=rset.GetData(3)
		s RoomName=rset.GetData(1)
		s GrantedFlag=0
		if ("!"_GroupRegRoomStr_"!")[("!"_RoomId_"!") s GrantedFlag=1
		d OutputRow11
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow11
	Set ^CacheTemp(repid,ind)=$LB(RoomId,RoomName,GrantedFlag)
	Set ind=ind+1
	quit
}

}
