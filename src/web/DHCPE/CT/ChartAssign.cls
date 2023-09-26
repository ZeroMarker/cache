Class web.DHCPE.CT.ChartAssign Extends %RegisteredObject
{

/// Description: 多院区医生权限维护
/// Table：表记录授权表 User.DHCPEChartAssign  DHC_PE_ChartAssign
/// Input: UserID 医生UserID, LocID 医生科室（医生所属科室OR体检中心科室）, GroupID 安全组, Type 0 新增 1 删除,sessionUser,Active,ID rowid
/// Return：记录ID^错误描述 记录id返回-1标识更新失败
/// Creator：sxt 
/// CreatDate：20210808
/// dubug: w ##class(web.DHCPE.CT.ChartAssign).UpdateAssign()
/// Remark: 医生权限改成绝对私有的数据了 不需要插授权表
ClassMethod UpdateAssign(UserID, LocID, GroupID, Type, sessionUser, Active, IsInDoc, ID)
{
	s ^TMP("DHCPE","UpdateAssign")=$lb(UserID, LocID, GroupID, Type, sessionUser, Active, IsInDoc, ID)
	s user=sessionUser
	
	s $ZT="UpdateAssignErr"
    s result=1
    
    TSTART
	
	if (Type=1){
		if (ID=""){
			s result="-1^数据异常未找到对应记录"
        	goto UpdateAssignErr
		}else{
			S OldData=$ListToString($g(^CF.PE.ChartAssignD(ID)))
			s obj=##class(User.DHCPEChartAssign).%New()
			s sc= obj.%DeleteId(ID)
			d obj.%Close()
			if ($System.Status.IsError(sc)){
				s result="-1^删除数据失败"
        		goto UpdateAssignErr
			}else{
			  s result="0^删除数据成功"
			  s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_ChartAssign",ID,"D",OldData,"",sessionUser)
			  if ($p(Logret,"^",1)="-1"){
				s result="-1^插入删除数据日志失败"_$p(Logret,"^",2)
        		goto UpdateAssignErr
				}
			}
		}
		
		
	}
	else{
		if (ID=""){
			q:($d(^CF.PE.ChartAssignI("IdxOfLocDocSSGrp"," "_LocID," "_UserID," "_GroupID))) "-1^已存在相同记录不能新增"
			s obj=##class(User.DHCPEChartAssign).%New()
		}
		else{
			s OldRecord=$ListToString($g(^CF.PE.ChartAssignD(ID)))
			s obj=##class(User.DHCPEChartAssign).%OpenId(ID)
		}
		s obj.CADocDR=UserID
		s obj.CALocDR=LocID
		s obj.CASSGrpDR=GroupID
		s obj.CANoActive=Active
		s obj.CAInDoc=IsInDoc
		s obj.CAUpdateDate=+$H
		s obj.CAUpdateTime=$p($h,",",2)
		s obj.CAUpdateUserDR=sessionUser
		s sc=obj.%Save()
		d obj.%Close()
		if ($System.Status.IsError(sc)){
			 s result="-1^保存数据失败"
        	 goto UpdateAssignErr	
			
		}
		else{
			s RowID=obj.%Id()
			if (ID=""){
				s result="0^新增数据成功"	
   	    		s OldRecord=""
   	    		s NewRecord=$ListToString($g(^CF.PE.ChartAssignD(RowID)))
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_ChartAssign",RowID,"I",OldRecord,NewRecord,sessionUser)
   	    
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        			goto UpdateAssignErr	
				}
   	    	}else{
	   	    	s result="0^更新数据成功"
   	    		s NewRecord=$ListToString($g(^CF.PE.ChartAssignD(RowID)))
   	    		if (OldRecord'=NewRecord) {
   	    			s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_ChartAssign",RowID,"U",OldRecord,NewRecord,sessionUser)
					if ($p(Logret,"^",1)="-1"){
						s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        				goto UpdateAssignErr	
					}
   	    		}
   	    	}	 
			
		}
			
	}
	TCommit
        q result  
UpdateAssignErr
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：    sxt 
/// CreatDate：  20210808
/// Description: 多院区医生权限读写明细维护
/// Table：      医生权限读写明细表User.DHCPEChartAssignDtl  DHC_PE_ChartAssignDtl
/// Input:       ID:父表ID, UseStr:待更新的数据, UserID:操作人ID
/// Return：     
/// dubug: w ##class(web.DHCPE.CT.ChartAssign).UpdateAssignDetail("7","1$Y$Y$N$^2$Y$Y$Y$^3$Y$Y$N$^4$Y$Y$N$^5$Y$Y$N$^6$Y$Y$N$^7$Y$Y$N$^8$Y$Y$N$^9$Y$Y$N$^10$Y$Y$N$^11$Y$Y$N$^12$Y$Y$N$^13$Y$Y$N$^14$Y$Y$N$^15$Y$Y$N$^16$Y$Y$N$^17$Y$Y$N$^19$Y$Y$N$^21$Y$Y$N$^22$Y$Y$N$^23$Y$Y$N$^24$Y$Y$N$^25$Y$Y$N$^26$Y$Y$N$^27$Y$Y$N$^28$Y$Y$N$^29$Y$Y$N$^30$Y$Y$N$^31$Y$Y$N$^32$Y$Y$N$^33$Y$Y$N$^34$Y$Y$N$")
ClassMethod UpdateAssignDetail(ID, UseStr, UserID)
{
	s ^TMP("DHCPE","web.DHCPE.CT.ChartAssign","UpdateAssign")=$lb(ID,UseStr,UserID)
		
  	s $ZT="UpdateAssignDetailerr"
    s result=1
    
	TSTART
	s i=$L(UseStr,"^")
	for j=1:1:i{
		s oneInfo=$P(UseStr,"^",j)
		s stid=$P(oneInfo,"$",1)
		//s:(stid="") stid="NULL"
		s DtlSub=$o(^CF.PE.ChartAssignI("DTL","IdxOfStation",ID,stid,0))
		if (DtlSub=""){
			s obj=##Class(User.DHCPEChartAssignDtl).%New()
			d obj.ParRefSetObjectId(ID)
		}else{
			s OldRecord=$ListToString($g(^CF.PE.ChartAssignD(ID,"DTL",DtlSub)))
			s obj=##Class(User.DHCPEChartAssignDtl).%OpenId(ID_"||"_DtlSub)
		}
	
		d:(stid'="") obj.CADStationDRSetObjectId(stid)
		s obj.CADDetail=$P(oneInfo,"$",2)
		s obj.CADWrite=$P(oneInfo,"$",3)
		s obj.CADDefault=$P(oneInfo,"$",4)
		s obj.CADWriteWay=$P(oneInfo,"$",5)
		s sc=obj.%Save()
		d obj.%Close()
	
		if ($System.Status.IsError(sc)){
			s result="-1^保存数据失败"
        	goto UpdateAssignDetailerr
		}else{
			s RowID=obj.%Id()
			if (DtlSub=""){	
   	    		s OldRecord=""
   	    		s NewRecord=$ListToString($g(^CF.PE.ChartAssignD(+RowID,"DTL",$p(RowID,"||",2))))
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_ChartAssignDtl",RowID,"I",OldRecord,NewRecord,UserID)
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        			goto UpdateAssignDetailerr
				}
   	    	}else{
   	    		s NewRecord=$ListToString($g(^CF.PE.ChartAssignD(+RowID,"DTL",$p(RowID,"||",2))))
   	    		if (OldRecord'=NewRecord) {
   	    			s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_ChartAssignDtl",RowID,"U",OldRecord,NewRecord,UserID)
					if ($p(Logret,"^",1)="-1"){
						s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        				goto UpdateAssignDetailerr
					}
   	    		}
   	    	}	  
        
		}
	
	}
	TCommit
        s result="0^保存数据成功"
        q result  
UpdateAssignDetailerr	TROLLBACK 
	//q $ZE
    q result
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.ChartAssign","SerchChartAssign","","388","","2")
Query SerchChartAssign(UserID As %String = "", LocID As %String = "", GroupID As %String = "", hospId As %String = "", ActiveFlag As %String = "", InDoc As %String = "") As %Query(ROWSPEC = "TUserID:%String,TUserName:%String,TLocID:%String,TLocName:%String,TGroupID:%String,TGroupName:%String,Active:%String,IsInDoc:%String,ChartID:%String")
{
}

ClassMethod SerchChartAssignExecute(ByRef qHandle As %Binary, UserID As %String = "", LocID As %String = "", GroupID As %String = "", hospId As %String = "", ActiveFlag As %String = "", InDoc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^tempdhcpe("SerchChartAssign")=$lb(UserID,LocID,GroupID,hospId,InDoc)
 	
 	s Locnode=""
 	for {
	 	s Locnode=$o(^CF.PE.ChartAssignI("IdxOfLocDocSSGrp",Locnode))
	 	q:Locnode=""
	 	s loc=$tr(Locnode," ","")
	 	s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("CT_Loc",loc,hospId)
		//q:(HOSPshowFlag="N")
	 	continue:(LocID'="")&&(LocID'=loc)
	 	s locname=$P($G(^CTLOC(loc)),"^",2)
	 	
	 	s UserNode=""
	 	for {
		 	s UserNode=$o(^CF.PE.ChartAssignI("IdxOfLocDocSSGrp",Locnode,UserNode))
		 	q:(UserNode="")
		 	s user=$tr(UserNode," ","")
		 	//s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("SS_User",user,hospId)
			//q:(HOSPshowFlag="N")
	 		continue:(UserID'="")&&(user'=UserID)
		 	
		 	s init=$P($G(^SSU("SSUSR",user)),"^",1)
		 	s username=$P($G(^SSU("SSUSR",user)),"^",2)_"("_init_")"
		 	
		 	s GroupNode=""
		 	for {
			s GroupNode=$o(^CF.PE.ChartAssignI("IdxOfLocDocSSGrp",Locnode,UserNode,GroupNode))
			q:(GroupNode="")
			s group=$tr(GroupNode," ","")
		 	continue:(GroupID'="")&&(GroupID'=group)
		 	q:group=""
	 	 	s groupname=$p($g(^SSU("SSGRP",group)),"^",1)
	 	 	s ID=""
	 	 	for {
				s ID=$o(^CF.PE.ChartAssignI("IdxOfLocDocSSGrp",Locnode,UserNode,GroupNode,ID))
				q:(ID="")
				s Active=$lg($g(^CF.PE.ChartAssignD(ID)),6)
				i Active="" s Active="N"
				continue:(ActiveFlag'="")&&(ActiveFlag'=Active)
				s IsInDoc=$lg($g(^CF.PE.ChartAssignD(ID)),5)
				i IsInDoc="" s IsInDoc="N"
				continue:(InDoc'="")&&(InDoc'=IsInDoc)
				d FindBuild	
			}
	
		 }
	
	   } 	
	 }
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(user,username,loc,locname,group,groupname,Active,IsInDoc,ID)
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

/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.ChartAssign","SerchChartDetail",4)
Query SerchChartDetail(ChartID As %String = "", OpenType As %String = "", LocID As %String = "") As %Query(ROWSPEC = "TChartID:%String, TChartName:%String, TUseFlag:%String,TWrite:%String,TDefault:%String,TWriteWay:%String")
{
}

ClassMethod SerchChartDetailExecute(ByRef qHandle As %Binary, ChartID As %String = "", OpenType As %String = "", LocID As %String = "") As %Status
{
    //s ^tempdhcpe("SerchChartDetail")=$lb(ChartID,OpenType,LocID)
	Set repid=$I(^CacheTemp)
	s ind=1
 	s ChartBook=+$G(^DHCPESetting("DHCPE","ChartBook"))
 	/*
 	if (ChartID="") //||(ChartBook="0")
 	{
	 	s qHandle=$lb(0,repid,0)
 		Quit $$$OK
 	}
 	*/
 	/// 总检的不要了 已经没用了 表里要求存站点（对象）
 	//s STID="",STDesc="总检"
 	//s:(ChartID'="") DtlSub=$o(^CF.PE.ChartAssignI("DTL","IdxOfStation",ChartID," NULL",0))
	//Do Build
	
	s MedicalStation=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID))
	s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",LocID))

 	s STID=0
 	f  s STID=$O(^DHCPEST(STID)) q:STID=""  d
 	.s STDesc=$P($g(^DHCPEST(STID)),"^",2)
 	.s SSID=$O(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,STID,0))
 	.q:SSID=""
 	.s Active=$lg($g(^CF.PE.StationSetD(SSID)),11)
 	.q:Active'="Y"
 	.q:(MedicalStation=STID)||(OtherStation=STID)
 	.s DtlSub=$o(^CF.PE.ChartAssignI("DTL","IdxOfStation",ChartID,STID,0))
	.Do Build
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

Build
   	s (UseFlag,WriteFlag,Default,WriteWay)=""
   	i DtlSub'=""{
   	s UseFlag=$lg(^CF.PE.ChartAssignD(ChartID,"DTL",DtlSub),3)
   	s WriteFlag=$lg(^CF.PE.ChartAssignD(ChartID,"DTL",DtlSub),4)
   	s Default=$lg(^CF.PE.ChartAssignD(ChartID,"DTL",DtlSub),5)
   	s WriteWay=$lg(^CF.PE.ChartAssignD(ChartID,"DTL",DtlSub),6)
   	}
   	q:(OpenType="Self")&&(WriteFlag'="Y")&&(STID'="")
	set Data=$lb(STID, STDesc, UseFlag,WriteFlag,Default,WriteWay)
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

}
