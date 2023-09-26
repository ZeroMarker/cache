Class web.DHCPE.ChartAssign Extends %Persistent
{

ClassMethod UpdateAssign(UserID, LocID, GroupID, Type)
{
	s user=%session.Get("LOGON.USERID")
	if (Type=1) d
	.k ^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID)
	e  d
	.s ^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID)=user_"^"_$H
	q 0
}

ClassMethod UpdateAssignDetail(UserID, LocID, GroupID, UseStr)
{
	s i=$L(UseStr,"^")
	for j=1:1:i d
	.s oneInfo=$P(UseStr,"^",j)
	.s chartID=$P(oneInfo,"$",1)
	.s useFlag=$P(oneInfo,"$",2)
	.s WriteFlag=$P(oneInfo,"$",3)
	.s DefaultFlag=$P(oneInfo,"$",4)
	.s WriteWay=$p(oneInfo,"$",5)
	.s ^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Detail",chartID)=useFlag
	.s ^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Write",chartID)=WriteFlag
	.s ^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Default",chartID)=DefaultFlag
	.s ^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"WriteWay",chartID)=WriteWay
	.// 科室确认的方式1  2  3  4  
	//s ^DHCPECFDataEx("ChartAssign","358","152","179","Write","128"
	q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.ChartAssign","SerchChartAssign","","","")
Query SerchChartAssign(UserID As %String = "", LocID As %String = "", GroupID As %String = "", hospId As %String = "") As %Query(ROWSPEC = "TUserID:%String,TUserName:%String,TLocID:%String,TLocName:%String,TGroupID:%String,TGroupName:%String")
{
}

ClassMethod SerchChartAssignExecute(ByRef qHandle As %Binary, UserID As %String = "", LocID As %String = "", GroupID As %String = "", hospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
	 	s user=""
	 	f  s user=$O(^DHCPECFDataEx("ChartAssign",user)) q:user=""  d
	 	.s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("SS_User",user,hospId)
		.q:(HOSPshowFlag="N")
	 	.q:(UserID'="")&&(user'=UserID)
	 	.s init=$P($G(^SSU("SSUSR",user)),"^",1)
	 	.s username=$P($G(^SSU("SSUSR",user)),"^",2)_"("_init_")"
	 	.s loc=""
	 	.f  s loc=$O(^DHCPECFDataEx("ChartAssign",user,loc)) q:loc=""  d
	 	..s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("CT_Loc",loc,hospId)
		..q:(HOSPshowFlag="N")
	 	..q:(LocID'="")&&(LocID'=loc)
	 	..s locname=$P($G(^CTLOC(loc)),"^",2)
	 	..s group=""
	 	..f  s group=$O(^DHCPECFDataEx("ChartAssign",user,loc,group)) q:group=""  d
	 	...q:(GroupID'="")&&(GroupID'=group)
	 	...s groupname=$P($G(^SSU("SSGRP",group)),"^",1)
	 	...d FindBuild
 	
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(user,username,loc,locname,group,groupname)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchChartAssignFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchChartAssignExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				
 	Set Row=^CacheTemp(repid,ind)
 	}
 	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

ClassMethod SerchChartAssignClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchChartAssignExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

Query SerchChartDetail(UserID As %String = "", LocID As %String = "", GroupID As %String = "", OpenType As %String = "") As %Query(ROWSPEC = "TChartID:%String, TChartName:%String, TUseFlag:%String,TWrite:%String,TDefault:%String,TWriteWay:%String")
{
}

ClassMethod SerchChartDetailExecute(ByRef qHandle As %Binary, UserID As %String = "", LocID As %String = "", GroupID As %String = "", OpenType As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	s ind=1
 	Set ChartBook=+$G(^DHCPESetting("DHCPE","ChartBook"))
 	if (UserID="")||(LocID="")||(GroupID="") //||(ChartBook="0")
 	{
	 	s qHandle=$lb(0,repid,0)
 		Quit $$$OK
 	}
 	s ChartId="NULL"
 	s Chart="总检"
 	Set UseFlag=+$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Detail",ChartId))
	Set WriteFlag=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Write",ChartId))
	Set Default=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Default",ChartId))
	s WriteWay=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"WriteWay",ChartId))
	Do Build
 	s ChartId=0
 	f  s ChartId=$O(^DHCPEST(ChartId)) q:ChartId=""  d
 	.s Chart=$P(^DHCPEST(ChartId),"^",2)
 	.s Active=$P(^DHCPEST(ChartId),"^",5)
 	.q:Active'="Y"
 	.Set UseFlag=+$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Detail",ChartId))
	.Set WriteFlag=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Write",ChartId))
	.;w !,WriteFlag
	.q:(OpenType="Self")&&(WriteFlag'="Y")
	.Set Default=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Default",ChartId))
	.s WriteWay=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"WriteWay",ChartId))
	.;s:(WriteWay="1") WriteWay="手动确认"
	.;s:(WriteWay="2") WriteWay="保存结果"
	.;s:(WriteWay="3") WriteWay="科室提交"
	.;s:(WriteWay="4") WriteWay="不确认"
	.;Set:Default'="Y" Default=0
	.;Set:Default="Y" Default=1
	.Do Build
	
 	/*
 	Set ChartList=$LIST(^epr.ChartBookD(ChartBook),2)
	Set ListCount=$ListLength(ChartList)
	For i=1:1:ListCount Do
	.Set ChartId=$List(ChartList,i)
	.Set ChartId=$List(ChartId)
	.Set Chart=$List(^ooChartD(ChartId),4)
	.Set UseFlag=+$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Detail",ChartId))
	.Set WriteFlag=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Write",ChartId))
	.Do Build
	*/
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

Build
   
	set Data=$lb(ChartId, Chart, UseFlag,WriteFlag,Default,WriteWay)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchChartDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchChartDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SerchChartDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchChartDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod UpdateCheckRoom(ID, Name, Address, Sort, Flag, Type)
{
	s Loc=%session.Get("LOGON.CTLOCID")
	if (Type=1) d
	.q:ID=""
	.k ^DHCPEDataEx("RoomCheck",Loc,ID)
	e  d
	.i ID="" s ID=+$O(^DHCPEDataEx("RoomCheck",Loc,""),-1)+1
	.s ^DHCPEDataEx("RoomCheck",Loc,ID)=Name_"^"_Address_"^"_Sort_"^"_Flag_"^"_$H
	q 0
}

ClassMethod SerchCheckRoomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchCheckRoomExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod SerchCheckRoomExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Loc=%session.Get("LOGON.CTLOCID")
	s ID=0 
	f  s ID=$O(^DHCPEDataEx("RoomCheck",Loc,ID)) q:ID=""  d
	.s Str=$G(^DHCPEDataEx("RoomCheck",Loc,ID))
	.s Name=$P(Str,"^",1)
	.s Address=$P(Str,"^",2)
	.s Sort=$P(Str,"^",3)
	.s Flag=$P(Str,"^",4)
	.d FindRoomBuild
 	
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindRoomBuild      
	set Data=$lb(ID,Name,Address,Sort,Flag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchCheckRoomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchCheckRoomExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

Query SerchCheckRoom() As %Query(ROWSPEC = "TID:%String,TRoomDesc:%String,TRoomAddress:%String,TRoomSort:%String,TActiveFlag:%String")
{
}

/// 医生权限  医生提交的方式  
/// // 科室确认的方式1 直接提交  2 科室确认  3 保存结果 ①妇科问诊（保存结果，不科室确认）  4 保存结果 科室确认② （妇科大夫上午查体时，保存结果科室确认），下午才提交
ClassMethod OutWriteWayToHTML(ContrlWidth As %String = "", ChardID As %String, DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	w "<select name='WriteWay' id=WriteWay"_ChardID_" style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value=''>  </option>",!
	w:(DefaultValue'="1") "<option value='"_"1"_"'>"_"手动确认"_"</option>",!
	w:(DefaultValue'="2") "<option value='"_"2"_"'>"_"保存结果"_"</option>",!
	w:(DefaultValue'="3") "<option value='"_"3"_"'>"_"科室提交"_"</option>",!
	w:(DefaultValue'="4") "<option value='"_"4"_"'>"_"不确认"_"</option>",!
	w:(DefaultValue=1) "<option value='"_"1"_"' "_"selected"_">"_"手动确认"_"</option>",!
	w:(DefaultValue=2) "<option value='"_"2"_"' "_"selected"_">"_"保存结果"_"</option>",!
	w:(DefaultValue=3) "<option value='"_"3"_"' "_"selected"_">"_"科室提交"_"</option>",!
	w:(DefaultValue=4) "<option value='"_"4"_"' "_"selected"_">"_"不确认"_"</option>",!
	w "</select>",!
	Quit $$$OK
}

Storage Default
{
<Data name="ChartAssignDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.ChartAssignD</DataLocation>
<DefaultData>ChartAssignDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.ChartAssignD</IdLocation>
<IndexLocation>^web.DHCPE.ChartAssignI</IndexLocation>
<StreamLocation>^web.DHCPE.ChartAssignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
