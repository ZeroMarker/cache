Import sqluser

Class web.DHCEMConsOrd Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCEMConsOrd).QryEmConsOrd(1,20)
ClassMethod QryEmConsOrd(page As %String, rows As %String, params = "")
{
	n (page,rows,params)
	s HospID=$p(params,"^",1) //hxy 2019-12-24
	s End = page*rows
	s Start=(page-1)*rows+1
	s Num=0
	k ^TMP("DHCEM","web.DHCEMConsOrd","QryEmConsOrd")
	s Pid=$i(^CacheTemp)
	
	s ECOCRowID=0
	f  s ECOCRowID = $o(^DHCEMCONSOC(ECOCRowID)) q:ECOCRowID=""  d
	.
	.s ECOCLocID = $p(^DHCEMCONSOC(ECOCRowID),"^",1)                      //科室ID
	.i +ECOCLocID'=0 s ECOCLoc = $p(^CTLOC(ECOCLocID),"^",2)			  //科室描述
	.E  s ECOCLoc = $s(ECOCLocID="ALL":"全院通用",ECOCLocID="DF":"默认医嘱",1:"")
	.s ECOCArci=""
	.s ECOCArciID = $p(^DHCEMCONSOC(ECOCRowID),"^",2)						  //
	.i ECOCArciID'="" D
	..s ECOCArci = $p(^ARCIM(+ECOCArciID,$p(ECOCArciID,"||",2),1),"^",2)   //医嘱名称
	.s ECOCTypeID = $p(^DHCEMCONSOC(ECOCRowID),"^",3)
	.s ECOCType = $s(ECOCTypeID="I":"院内会诊",ECOCTypeID="O":"院外会诊",1:"")
	.s:+ECOCTypeID'=0 ECOCType = $p($g(^DHCEMCDI(+ECOCTypeID)),"^",2) //hxy 2021-02-27
	.s ECOCProTpID = $p(^DHCEMCONSOC(ECOCRowID),"^",4)						  //职称
	.s ECOCProTp = $p($g(^CT("CPT",+ECOCProTpID)),"^",2)						  //职称描述
	.s ECOCInsTypeID = $p(^DHCEMCONSOC(ECOCRowID),"^",5)						  //职称描述 
	.s ECOCInsType = $s(ECOCInsTypeID="A":"申请产生",ECOCInsTypeID="E":"完成产生",1:"")
	.s ECOCPropID=+$p(^DHCEMCONSOC(ECOCRowID),"^",6)  /// 会诊性质ID
	.s ECOCProp=$p($g(^DHCEMCDI(ECOCPropID)),"^",2)   /// 会诊性质
	.s ECOCHospDr=$p(^DHCEMCONSOC(ECOCRowID),"^",7) //hxy 2019-12-24 st
	.s ECOCHosp=$P($g(^CT("HOSP",+ECOCHospDr)),"^",2)  
	.q:(HospID'="")&(ECOCHospDr'=HospID) //hxy ed
	.s ListData = ECOCRowID_"^"_ECOCLocID_"^"_ECOCLoc_"^"_ECOCArciID_"^"_ECOCArci_"^"_ECOCTypeID_"^"_ECOCType
	.s ListData = ListData_"^"_ECOCProTpID_"^"_ECOCProTp_"^"_ECOCInsTypeID_"^"_ECOCInsType_"^"_ECOCPropID_"^"_ECOCProp_"^"_ECOCHosp_"^"_ECOCHospDr
	.s Num = Num+1
	.s ^TMP("DHCEM","web.DHCEMConsOrd","QryEmConsOrd",Pid,ECOCLocID_"^"_ECOCInsTypeID,Num) = ListData
	
	s Count =0
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s ListTitle="ECOCRowID^ECOCLocID^ECOCLoc^ECOCArciID^ECOCArci^ECOCTypeID^ECOCType^ECOCProTpID^ECOCProTp^ECOCInsTypeID^ECOCInsType^ECOCPropID^ECOCProp^ECOCHosp^ECOCHospDr"
	s ECOCInsTypeID=""
	f  s ECOCInsTypeID = $o(^TMP("DHCEM","web.DHCEMConsOrd","QryEmConsOrd",Pid,ECOCInsTypeID)) q:ECOCInsTypeID=""  d
	.s Num=0
	.f  s Num = $o(^TMP("DHCEM","web.DHCEMConsOrd","QryEmConsOrd",Pid,ECOCInsTypeID,Num)) q:Num=""  d
	..s ListData =^TMP("DHCEM","web.DHCEMConsOrd","QryEmConsOrd",Pid,ECOCInsTypeID,Num)
	..s Count = Count+1
	..
	..Q:(Count<Start)||(Count>End)
	..i Count=Start D
	...W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	..E  D
	...W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	
	q ""
}

/// w ##class(web.DHCEMConsOrd).QryEmConsLoc("")
ClassMethod QryEmConsLoc(q As %String)
{
	n (q)
	s Count = 0
	w "["
	s LocID=""
	f  s LocID = $o(^CTLOC(LocID)) q:LocID=""  d
	.s LocDesc = $p(^CTLOC(LocID),"^",2)
	.s LocCode = $p(^CTLOC(LocID),"^",43)
	.s LocAllDesc = LocCode_LocDesc
	.q:(q'="")&&(LocAllDesc'[$$ALPHAUP^SSUTIL4(q))
	.s Count = Count+1
	.s Tmp=LocID_"^"_LocDesc
	.i Count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	w "]"
	
	q ""
}

/// w ##class(web.DHCEMConsOrd).Save("6^1^11255||1^O^1^A")
ClassMethod Save(Params)
{
	n (Params)
	s Err=0
	f i=1:1:$l(Params,"$$") Q:Err'=0  D
	.s Param=$p(Params,"$$",i)
	.s Err=..IsExist(Param)   /// 重复性判断
	.q:Err'=0
	.i $p(Param,"^",1) ="" d
	..s Err=..Insert(Param)
	.e  d
	..s Err=..Update(Param)
	.
	q Err
}

ClassMethod Delete(ID)
{
	n (ID)
	&sql(DELETE DHC_EmConsOrdConfig WHERE ECOC_RowID =:ID )
	q SQLCODE
}

/// Scripts:判断是否已经存在
/// Return: 1:已经存在 0：不存在
/// w ##class(web.DHCEMConsOrd).IsExist("^17^9348||1^I^^A^^2^2^^")
ClassMethod IsExist(Param)
{
	n (Param)
	s ECOCRowID = $p(Param,"^",1)   //ID
	s CstLocID = $p(Param,"^",2)   //科室
	s CstArciID = $p(Param,"^",3)  //医嘱项目
	s CstTypeID = $p(Param,"^",4)  //类型；单科多科
	s CstProvID = $p(Param,"^",5)  //职称
	s CstWayID = $p(Param,"^",6)   //发送完成
	s CsPropID = $p(Param,"^",7)   //会诊性质
	S Hosp=$p(Param,"^",8) //hxy 2019-12-24 st
	S HospDr=$p(Param,"^",9) 
	s ECOCHospDr=""
	S:+Hosp=0 ECOCHospDr=HospDr
	S:+Hosp'=0 ECOCHospDr=Hosp //ed
	s Err=0
	s ID=0
	F  s ID=$o(^DHCEMCONSOC(ID)) Q:(ID="")||(Err'=0)  D
	.Q:(ECOCRowID'="")&(ECOCRowID=ID)
	.Q:$p(^DHCEMCONSOC(ID),"^",1)'=CstLocID    /// 科室
	.Q:$p(^DHCEMCONSOC(ID),"^",3)'=CstTypeID
	.Q:$p(^DHCEMCONSOC(ID ),"^",5)'=CstWayID   /// 生成方式
	.s PrvTpID=$p(^DHCEMCONSOC(ID),"^",4)      /// 职称
	.Q:(CstProvID'=PrvTpID) //hxy 2020-09-24 原：(CstProvID'="")&(CstProvID'=PrvTpID)
	.s PropID=+$p(^DHCEMCONSOC(ID),"^",6)       /// 会诊性质
	.Q:+CsPropID'=PropID
	.s HospID=$p(^DHCEMCONSOC(ID),"^",7)       /// 医院 //hxy 2019-12-24 st
	.Q:(ECOCHospDr'="")&(HospID'=ECOCHospDr)   //ed
	.s Err=1
#;	i CstProvID'="" s ECOCRowDr =$o(^DHCEMCONSOC(0,"InsType",CstWayID,CstTypeID,CstLocID,CstProvID,""))
#;	E  s ECOCRowDr =$o(^DHCEMCONSOC(0,"InsType",CstWayID,CstTypeID,CstLocID,-100000000000000,""))
#;	s:(ECOCRowDr'="")&&(ECOCRowDr'=ECOCRowID) Ret=1
	q Err
}

ClassMethod Insert(Param)
{
	s CstLocID = $p(Param,"^",2)   //科室
	s CstArciID = $p(Param,"^",3)  //医嘱项目
	s CstTypeID = $p(Param,"^",4)  //类型；单科多科
	s CstProvID = $p(Param,"^",5)  //职称
	s CstWayID = $p(Param,"^",6)   //发送完成
	s CsPropID = $p(Param,"^",7)   //会诊性质
	s HospDr = $p(Param,"^",8)   //医院	//hxy 2019-12-24
	&sql(INSERT INTO DHC_EmConsOrdConfig (ECOC_RepLoc_Dr, ECOC_ArcItem_Dr, ECOC_Type, ECOC_DocType_Dr, ECOC_InsertType, ECOC_Nat_Dr,ECOC_Hosp_Dr) 
	VALUES (:CstLocID,:CstArciID,:CstTypeID,:CstProvID,:CstWayID,:CsPropID,:HospDr) )
	q SQLCODE
}

ClassMethod Update(Param)
{
	s ECOCRowID = $p(Param,"^",1)   //配置ID
	s CstLocID = $p(Param,"^",2)   //科室
	s CstArciID = $p(Param,"^",3)  //医嘱项目
	s CstTypeID = $p(Param,"^",4)  //类型；单科多科
	s CstProvID = $p(Param,"^",5)  //职称
	s CstWayID = $p(Param,"^",6)   //发送完成
	s CsPropID = $p(Param,"^",7)   //会诊性质
	S Hosp=$p(Param,"^",8) //hxy 2019-12-24 st
	S HospDr=$p(Param,"^",9) 
	s ECOCHospDr=""
	S:+Hosp=0 ECOCHospDr=HospDr
	S:+Hosp'=0 ECOCHospDr=Hosp //ed
	s ECOCProTp=$p(Param,"^",10) //hxy 2020-03-02 st
	s ECOCProp=$p(Param,"^",11)
	s:ECOCProTp="" CstProvID=""
	s:ECOCProp="" CsPropID="" //ed
	&sql(UPDATE DHC_EmConsOrdConfig SET ECOC_RepLoc_Dr=:CstLocID,ECOC_ArcItem_Dr=:CstArciID, ECOC_Type=:CstTypeID, ECOC_DocType_Dr=:CstProvID, ECOC_InsertType=:CstWayID, ECOC_Nat_Dr=:CsPropID,ECOC_Hosp_Dr=:ECOCHospDr WHERE ECOC_RowID=:ECOCRowID )
	q SQLCODE
}

}
