Class web.DHCPE.AdmRefuseRoom Extends %Persistent
{

/// d ##Class(web.DHCPE.AdmRefuseRoom).GetResumeRoomButtonID("","")
ClassMethod GetResumeRoomButtonID(PAADM, RoomID)
{
	q:'$d(^User.DHCPEAdmRefuseRoomI("PAADMStatus",PAADM,"RF",RoomID)) ""
	q $O(^User.DHCPEAdmRefuseRoomI("PAADMStatus",PAADM,"RF",RoomID,""))
}

ClassMethod Refuse(PAADM, RoomID)
{
	;w ##class(web.DHCPE.AdmRefuseRoom).Refuse("4223330","1||2")
	q:$D(^User.DHCPEAdmRefuseRoomI("PAADMStatus",PAADM,"RF",RoomID)) "-1^已经放弃"
	s Date=+$H
	s Time=$P($H,",",2)
	s User=%session.Get("LOGON.USERID")
	s obj=##class(User.DHCPEAdmRefuseRoom).%New()
	d obj.ARRPAADMDRSetObjectId(PAADM)
	d obj.ARRRoomDRSetObjectId(RoomID)
	s obj.ARRStatus="RF"
	s obj.ARRRefuseDate=Date
	s obj.ARRRefuseTime=Time
	d obj.ARRRefuseUserDRSetObjectId(User)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		d ..GetRefuseItemByRoomID(PAADM, RoomID, "RF")
		s CurRoomInfo=##class(web.DHCPE.RoomManager).GetAdmCurRoom(PAADM, "ADM","")
		q:CurRoomInfo="" "0^操作成功"
		s CurRoomInfoID=$P(CurRoomInfo,"^",1)
		s CurRoomID=$LG(^User.DHCPEAdmRoomRecordD(CurRoomInfoID),6)
		i CurRoomID=RoomID d
		.s CurInfo=##class(web.DHCPE.RoomManager).StopCurRoomInfo(CurRoomInfoID)
		.i +CurInfo="0" d
		..d ##class(web.DHCPE.RoomManager).InsertRoomRecord(PAADM)
		..s CurRoomInfo=##class(web.DHCPE.RoomManager).GetAdmCurRoom(PAADM, "ADM","")
		..//RoomDesc_"^"_NewPerson_"^"_Name
		q:CurRoomInfo="" "0^操作成功^"
		q "0^请'"_$P(CurRoomInfo,"^",4)_"'到'"_$P(CurRoomInfo,"^",2)_"'处候诊,您是第'"_$P(CurRoomInfo,"^",3)_"'位^"_$P(CurRoomInfo,"^",5)
		//CurRoomID_"^"_RoomDesc_"^"_NewPerson_"^"_Name
		q "0^操作成功"
	}
}

ClassMethod Resume(ID)
{
	s obj=##class(User.DHCPEAdmRefuseRoom).%OpenId(ID)
	s Status=obj.ARRStatus
	q:Status="RS" "-1^已经取消,不需要再次操作"
	s Date=+$H
	s Time=$P($H,",",2)
	s User=%session.Get("LOGON.USERID")
	s PAADM=obj.ARRPAADMDRGetObjectId()
	s RoomID=obj.ARRRoomDRGetObjectId()
	s obj.ARRResumeDate=Date
	s obj.ARRResumeTime=Time
	d obj.ARRResumeUserDRSetObjectId(User)
	s obj.ARRStatus="RS"
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		d ..GetRefuseItemByRoomID(PAADM, RoomID, "RS")
		
		s CurRoomInfo=##class(web.DHCPE.RoomManager).GetAdmCurRoom(PAADM, "ADM","")
		i CurRoomInfo="" d
		.d ##class(web.DHCPE.RoomManager).InsertRoomRecord(PAADM)
		s CurRoomInfo=##class(web.DHCPE.RoomManager).GetAdmCurRoom(PAADM, "ADM","")
		//RoomDesc_"^"_NewPerson_"^"_Name
		q:CurRoomInfo="" "0^操作成功"
		q "0^请'"_$P(CurRoomInfo,"^",4)_"'到'"_$P(CurRoomInfo,"^",2)_"'处候诊,您是第'"_$P(CurRoomInfo,"^",3)_"'位"
		
		q "0^操作成功"
	}
}

ClassMethod GetRefuseItemByRoomID(PAADM, RoomID, Type)
{
	s StationID=$LG(^User.DHCPEAreaD(+RoomID,"ChildRoom",$P(RoomID,"||",2)),7)
	q:StationID="" ""
	s Order=$O(^OEORD(0,"Adm",PAADM,0))
	q:Order="" ""
	s Sub=0
	f  s Sub=$O(^OEORD(Order,"I",Sub)) q:Sub=""  d
	.s StatID=$P(^OEORD(Order,"I",Sub,1),"^",13)
	.q:StatID'="1"
	.s ArcimID=$P(^OEORD(Order,"I",Sub,1),"^",2)
	.s ArcStation=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
	.q:ArcStation'=StationID
	.s OrderID=Order_"||"_Sub
	.i Type="RS" d  ;恢复
	..q:'$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrderID))
	..d ##class(web.DHCPE.ResultEdit).RefuseCheck(OrderID)
	.e  d ;放弃
	..q:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrderID))
	..b ;OrderID
	..d ##class(web.DHCPE.ResultEdit).RefuseCheck(OrderID)
	q 0
	;s Station=
}

ClassMethod OutRefuseButton(PAADM, RoomID)
{
	;d ##Class(web.DHCPE.AdmRefuseRoom).OutRefuseButton("a","b")
	i $D(^User.DHCPEAdmRefuseRoomI("PAADMStatus",PAADM,"RF",RoomID)) d
	.s ID=$O(^User.DHCPEAdmRefuseRoomI("PAADMStatus",PAADM,"RF",RoomID,""))
	.w "<input type='button' id='"_ID_"' name='RefuseButton' value='恢复' onclick='ResumeRoom();'>"
	e  d
	.w "<input type='button' id='"_PAADM_"^"_RoomID_"' name='RefuseButton' value='放弃' onclick='RefuseRoom();'>"
	.w "<input type='checkbox' name='TSelect' id='"_PAADM_"^"_RoomID_"'>"
	Quit $$$OK
}

Storage Default
{
<Data name="AdmRefuseRoomDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.AdmRefuseRoomD</DataLocation>
<DefaultData>AdmRefuseRoomDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.AdmRefuseRoomD</IdLocation>
<IndexLocation>^web.DHCPE.AdmRefuseRoomI</IndexLocation>
<StreamLocation>^web.DHCPE.AdmRefuseRoomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
