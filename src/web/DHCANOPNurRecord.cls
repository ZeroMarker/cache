Class web.DHCANOPNurRecord Extends %RegisteredObject
{

/// Creator: cdx
/// CreatDate: 2015-09-25
/// Description: 取病人的基本信息
/// Table：PA_Adm,PA_PatMas,PA_Person,CT_Loc,PAC_BloodType,DHC_AN_OPArrange,DHC_ANC_OperRoom,OR_Anaesthesia,OR_Anaest_Operation
/// Input：opaId:手术申请ID
/// Return：返回病人科室,姓名,性别,年龄,住院号,血型,手术间,手术日期,手术名称,入室时间,出室时间
/// 			CTLOCD_"^"_patName_"^"_patSex_"^"_patAge_"^"_patMedCareNo_"^"_patBloodType_"^"_patOpRoom_"^"_patOpDate_"^"_patOpName_"^"_StTime_"^"_EnTime
/// w ##class(web.DHCANOPNurRecord).GetPatInfo(20)
ClassMethod GetPatInfo(opaId) As %String
{
	q:opaId="" ""
	s bedCode="",locdes="",InstrNur="",cirNur="",ShiftCtcp="",ReliefCtcp="",ShiftTime=""
	s operEventTime="",operEventEndTime="",operOutEventTime=""
	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	s chl=$p($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	s sub=$o(^OR(EpisodeID,"ANA",chl,"OP",0))
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)                        //床号
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
	i curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",2)
	i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)                            //病区
	s locdes=$P($g(^CTLOC(appLocId)),"^",2)
	i $l(locdes,"-")>1 s locdes=$p(locdes,"-",2)
	s BarCode=$g(^DHCANOPArrange(opaId,"OPCount","BarCCode"))
    s PatientID=+^PAADM(EpisodeID)
	s CTLOCDr=$P(^PAADM(EpisodeID),"^",4)
    i CTLOCDr'="" d
    .s CTLOCD=$P(^CTLOC(CTLOCDr),"^",2)											//科室
    .i $L(CTLOCD,"-")>1  s CTLOCD=$P(CTLOCD,"-",2)
    e  s CTLOCD=""
    s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)								//姓名
    s patSex=$p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
    s birth=$p($g(^PAPER(PatientID,"ALL")),"^",6)	
    ;old不用了，统一走计费新街口+20161109+dyl							
    //s patAge=##class(web.DHCLCNUREXCUTE).CalAge(birth,+$h)						//年龄
    //i $P(patAge,"Y",1)'="" s patAge=$P(patAge,"Y",1)_"岁"
   s patAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID)
    //s patMedCareNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",22)
	s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	s patMedCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	s patBloodTypeDr=$P(^DHCANOPArrange(opaId),"^",11)                       	//OPA_BloodType_dr	血型
	i patBloodTypeDr'="" s patBloodType=$P($G(^PAC("BLDT",patBloodTypeDr)),"^",2)
	e  s patBloodType=""
	s patOpRoomDr=$P(^DHCANOPArrange(opaId),"^",20)                       		//OPA_OpRoom_dr	手术间
	i patOpRoomDr'="" s patOpRoom=$P($G(^DHCANC("OPRoom",patOpRoomDr)),"^",2)
	e  s patOpRoom=""
	s patOpDate=$P(^DHCANOPArrange(opaId),"^",3)                       			//OPA_AppDate	手术申请日期
	i patOpDate'="" s patOpDate=$zd(patOpDate,3)
	s patOpName=""
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$p(anaId,"||",2)
	
	;手术体位
		s operPositionIdList=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",1)),"^") //cdx 151009 手术体位（可能是多个）
	s operPosition=""
	i operPositionIdList'="" d
		 .s operPositionIdNum=$l(operPositionIdList,"|")
		 .f j=1:1:operPositionIdNum d
			   ..s operPositionId=$p(operPositionIdList,"|",j)
			   ..q:operPositionId=""
			   ..s operPositionDesc=$P($G(^ORC("OPPOS",operPositionId)),"^",2)
			   ..i operPosition="" s operPosition=operPositionId_"!"_operPositionDesc
			   ..e  s operPosition=operPosition_","_operPositionId_"!"_operPositionDesc
		
	s anmthdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)
		s anmethod=""
		i anmthdr'="" d
			.s anmetNum=$l(anmthdr,"|")
			.f i=1:1:anmetNum d
				..s anmetId=$p(anmthdr,"|",i)
				..q:anmetId=""
				..s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
				..i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
				..i anmethod="" s anmethod=anmetId_"!"_anmetDesc
				..e  s anmethod=anmethod_","_anmetId_"!"_anmetDesc
	s mzdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)        					;ANA_Anaesthetist_Dr 
		i mzdr'="" d
		.;麻醉医师
		.s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr)
		e  s mzdoc=""
				
	s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")  d
	.s opdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",6)         			//ANAOP_Type_DR 手术名称
	.i opdr'="" d
	..s opdes=$P($g(^ORC("OPER",opdr)),"^",2)
	..i patOpName="" s patOpName=opdes
	..e  s patOpName=patOpName_","_opdes
	.e  d
					..i $g(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2))'="" d
					...i patOpName'="" s patOpName=patOpName_";"
					...s patOpName=patOpName_$G(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2))    ///ck091210
					
	.s predigdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",4)   			//ANAOP_PreopDiag_DR 术前诊断
	.i predigdr'=""  d
	..s prediag=$P($g(^MRC("ID",predigdr)),"^",2)
	..s diag=$G(prediag)
	.e  d
	..i $g(^OR(EpisodeID,"ANA",anaSub,"TXT",1))'="" d 
	...s diamen=^OR(EpisodeID,"ANA",anaSub,"TXT",1)  							//ANA_Notes 麻醉表存放诊断备注
	...s diag=$G(diamen)
	.s docdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",8)      			//ANAOP_Surgeon_DR   手术医师
	.i docdr'="" s opdoc=$TR($P(^CTPCP(docdr,1),"^",2)," ","")
	.e  s opdoc=""
	.s InstrNur="",cirNur=""
	.s OPSCNSub=0 f  s OPSCNSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"SCN",OPSCNSub)) q:(OPSCNSub="")  d
	..q:OPSCNSub>20	//小于20为洗手护士,大于20是交洗手护士
	..s InstrNurDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"SCN",OPSCNSub),"^",1)  //OR_An_Oper_Scrub_Nurse 洗手护士或器材护士
	..q:InstrNurDr=""
	..s InstrNur=InstrNur_" "_##class(web.DHCANOPCom).GetNameById(InstrNurDr)
	
	.s CIRNSub=0 f  s CIRNSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"CIRN",CIRNSub)) q:(CIRNSub="")  d
	..q:CIRNSub>20	//小于20为巡回护士,大于20是交巡回护士
	..s cirNurDr=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"CIRN",CIRNSub)),"^",1)  //OR_An_Oper_Circul_Nurse 巡回护士
	..i cirNurDr'="" d
	...;i cirNurDr="" s cirNur=$P(^CTPCP(cirNurDr,1),"^",2)
	...;e  s cirNur=cirNur_" "_$P(^CTPCP(cirNurDr,1),"^",2) 
	...i cirNur=""  s cirNur=cirNurDr_"!"_##class(web.DHCANOPCom).GetNameById(cirNurDr)
	...e  s cirNur=cirNur_","_cirNurDr_"!"_##class(web.DHCANOPCom).GetNameById(cirNurDr)
	.s ANSSub=$o(^DHCANOPArrange(opaId,"Shift",0))                                     
	.i ANSSub'="" d
    ..s ShiftCtcpID=$P(^DHCANOPArrange(opaId,"Shift",ANSSub),"^",16)               //交班人
    ..i ShiftCtcpID'="" s ShiftCtcp=$P(^CTPCP(ShiftCtcpID,1),"^",2)
    ..s ReliefCtcpID=$P(^DHCANOPArrange(opaId,"Shift",ANSSub),"^",17)		      //接班人
    ..i ReliefCtcpID'="" s ReliefCtcp=$P(^CTPCP(ReliefCtcpID,1),"^",2) 
    ..s ShiftTime=$g(^DHCANOPArrange(opaId,"Shift",ANSSub,"ShiftTime"))
    s TheatreInDate=$P($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)
    i TheatreInDate'=""  s TheatreInDate=$zd(TheatreInDate,4)
	s StTime=$P($g(^OR(EpisodeID,"ANA",anaSub)),"^",40) 						//ANA_TheatreInTime  	入室时间
	i StTime'="" s StTime=$zt(StTime,2)
	s EnTime=$P($g(^OR(EpisodeID,"ANA",anaSub)),"^",42) 						//ANA_TheatreOutTime	出室时间
    i EnTime'="" s EnTime=$zt(EnTime,2)
    s operEvent=##class(web.DHCANOPData).GetEventInfo(opaId,"szsj004")
	s operStartDT=$p(operEvent,"^",4)
	s operEventTime=$p(operStartDT," ",2)
	i operEventTime'="" d
	.s operEventTime=$zth(operEventTime,1)
	.s operEventTime=$zt(operEventTime,2)
	s operEndEvent=##class(web.DHCANOPData).GetEventInfo(opaId,"szsj005","N")
	s operEndDT=$p(operEndEvent,"^",4)
	s operEventEndTime=$p(operEndDT," ",2)
	i operEventEndTime'="" d
	.s operEventEndTime=$zth(operEventEndTime,1)
	.s operEventEndTime=$zt(operEventEndTime,2)
	s operOutEvent=##class(web.DHCANOPData).GetEventInfo(opaId,"szsj008")
	s operOutDT=$p(operOutEvent,"^",4)
	s operOutEventTime=$p(operOutDT," ",2)
	i operOutEventTime'="" d
	.s operOutEventTime=$zth(operOutEventTime,1)
	.s operOutEventTime=$zt(operOutEventTime,2)
    ;q CTLOCD_"^"_patName_"^"_patSex_"^"_patAge_"^"_patMedCareNo_"^"_patBloodType_"^"_patOpRoom_"^"_patOpDate_"^"_patOpName_"^"_StTime_"^"_EnTime_"^"_InstrNur_"^"_cirNur_"^"_diag_"^"_opdoc_"^"_locdes_"^"_bedCode_"^"_BarCode_"^"_ShiftCtcp_"^"_ReliefCtcp_"^"_ShiftTime
    q $g(CTLOCD)_"^"_$g(patName)_"^"_$g(patSex)_"^"_$g(patAge)_"^"_$g(patMedCareNo)_"^"_$g(patBloodType)_"^"_$g(patOpRoom)_"^"_$g(patOpDate)_"^"_$g(patOpName)_"^"_$g(StTime)_"^"_$g(EnTime)_"^"_$g(InstrNur)_"^"_$g(cirNur)_"^"_$g(diag)_"^"_$g(opdoc)_"^"_$g(locdes)_"^"_$g(bedCode)_"^"_$g(BarCode)_"^"_$g(ShiftCtcp)_"^"_$g(ReliefCtcp)_"^"_$g(ShiftTime)_"^"_$g(WardDes)_"^"_$G(anmethod)_"^"_$G(mzdoc)_"^"_$G(TheatreInDate)_"^"_$G(operEventTime)_"^"_$G(operPosition)_"^"_$G(operEventEndTime)_"^"_$G(operOutEventTime)
}

ClassMethod GetCareRecord(opaId, code)
{
	s ret=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId, code)
	s ret1=$p(ret,$c(3))
	i code="instrumentEquip"  d
	.s Str1=""
	.s Num=$l(ret1,",")
			.f i=1:1:Num d
				..s Id=$p(ret1,",",i)
				..q:Id=""
				..;s desc=$li($g(^DHCANC("Equip",Id)),3)
				..s desc=##class(web.DHCEQ.Interface.Inner.DHCEQOperation).GetOneEquip(Id,"")   //cdx 151124 从设备组提供的接口取设备的基本信息
				..s desc=$p($g(desc),"^",3)
				..i Str1=""  s Str1=Id_"!"_desc
				..e  s Str1=Str1_","_Id_"!"_desc
	.s ret1=Str1
	q ret1
}

ClassMethod SaveCareRecord(opaId, str, UserId)
{
	s str=$tr(str,"$",$c(3))
	s ^temp("150930cdx")=str 
	s ret=##class(web.DHCANOPArrangeExtend).SaveArrangeExtend(opaId, str,UserId)
	q ret
}

Query GetCareHemostaticBeltList(opaId) As %Query(ROWSPEC = "tCareHemostaticBelt2Body,tCareHemostaticBelt2PuffTime,tCareHemostaticBelt2RelaxTime,ttotalTime,tCareHemostaticBelt2Pressure")
{
}

ClassMethod GetCareHemostaticBeltListExecute(ByRef qHandle As %Binary, opaId) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s ret=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId, "CareHemostaticBeltStr")
	s ret1=$p(ret,$c(3))
		i ret1'="" d
			.s Num=$l(ret1,"@")
			.f i=1:1:Num d
				..s ret2=$p(ret1,"@",i)
				..i ret2'="" d
				     ...s tCareHemostaticBelt2Body=$p(ret2,"#",1)
				      ...s tCareHemostaticBelt2PuffTime=$p(ret2,"#",2)
				      ...s tCareHemostaticBelt2RelaxTime=$p(ret2,"#",3)
				      ...s ttotalTime=$p(ret2,"#",4)
				      ...s tCareHemostaticBelt2Pressure=$p(ret2,"#",5)
                      ...d outputRH
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(tCareHemostaticBelt2Body,tCareHemostaticBelt2PuffTime,tCareHemostaticBelt2RelaxTime,ttotalTime,tCareHemostaticBelt2Pressure)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetCareHemostaticBeltListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareHemostaticBeltListExecute ]
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

ClassMethod GetCareHemostaticBeltListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareHemostaticBeltListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetCareImplantList(opaId) As %Query(ROWSPEC = "tCareImplant2Name,tCareImplant2Num")
{
}

ClassMethod GetCareImplantListExecute(ByRef qHandle As %Binary, opaId) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s ret=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId, "CareImplantStr")
	s ret1=$p(ret,$c(3))
		i ret1'="" d
			.s Num=$l(ret1,"@")
			.f i=1:1:Num d
				..s ret2=$p(ret1,"@",i)
				..i ret2'="" d
				     ...s tCareImplant2Name=$p(ret2,"#",1)
				      ...s tCareImplant2Num=$p(ret2,"#",2)
                      ...d outputRH
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(tCareImplant2Name,tCareImplant2Num)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetCareImplantListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareImplantListExecute ]
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

ClassMethod GetCareImplantListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareImplantListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindElectrotomeModel() As %Query(ROWSPEC = "RHId,RHDesc")
{
}

ClassMethod FindElectrotomeModelExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s RHDesc="FX(威力)",RHId=1
    d outputRH
    s RHDesc="OLYMPUS(奥林巴司)",RHId=2
    d outputRH
    s RHDesc="AESCULAP(蛇牌)",RHId=3
    d outputRH
    s RHDesc="Stryker(史塞克)",RHId=4
    d outputRH
    s RHDesc="Bovie",RHId=5
    d outputRH
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(RHId,RHDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindElectrotomeModelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindElectrotomeModelExecute ]
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

ClassMethod FindElectrotomeModelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindElectrotomeModelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindTourniquet() As %Query(ROWSPEC = "RHId,RHDesc")
{
}

ClassMethod FindTourniquetExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s RHDesc="无",RHId=1
    d outputRH
    s RHDesc="驱血橡胶带",RHId=2
    d outputRH
    s RHDesc="气压止血仪",RHId=3
    d outputRH
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(RHId,RHDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindTourniquetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTourniquetExecute ]
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

ClassMethod FindTourniquetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTourniquetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindPresTourniquetModel() As %Query(ROWSPEC = "RHId,RHDesc")
{
}

ClassMethod FindPresTourniquetModelExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s RHDesc="ATS-I",RHId=1
    d outputRH
    s RHDesc="VBM-2500",RHId=2
    d outputRH
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(RHId,RHDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindPresTourniquetModelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPresTourniquetModelExecute ]
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

ClassMethod FindPresTourniquetModelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPresTourniquetModelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindFoley() As %Query(ROWSPEC = "RHId,RHDesc")
{
}

ClassMethod FindFoleyExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s RHDesc="无",RHId=1
    d outputRH
    s RHDesc="病房带来",RHId=2
    d outputRH
    s RHDesc="手术室",RHId=3
    d outputRH
    ;s RHDesc="双腔",RHId=4
    ;d outputRH
    ;s RHDesc="三腔",RHId=5
    ;d outputRH
    ;s RHDesc="其他",RHId=6
    ;d outputRH
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(RHId,RHDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindFoleyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFoleyExecute ]
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

ClassMethod FindFoleyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFoleyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query Findstomach() As %Query(ROWSPEC = "RHId,RHDesc")
{
}

ClassMethod FindstomachExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s RHDesc="无",RHId=1
    d outputRH
    s RHDesc="病房带来",RHId=2
    d outputRH
    s RHDesc="手术室",RHId=3
    d outputRH
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(RHId,RHDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindstomachFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindstomachExecute ]
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

ClassMethod FindstomachClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindstomachExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query Finddisinfect() As %Query(ROWSPEC = "RHId,RHDesc")
{
}

ClassMethod FinddisinfectExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s RHDesc="安多福",RHId=1
    d outputRH
    s RHDesc="碘伏原液",RHId=2
    d outputRH
    s RHDesc="2.5%碘酊",RHId=3
    d outputRH
    s RHDesc="75%酒精",RHId=4
    d outputRH
    s RHDesc="其他",RHId=5
    d outputRH
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(RHId,RHDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FinddisinfectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinddisinfectExecute ]
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

ClassMethod FinddisinfectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinddisinfectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindCareImplant2Name() As %Query(ROWSPEC = "RHId,RHDesc")
{
}

ClassMethod FindCareImplant2NameExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s RHDesc="负压引流",RHId=1
    d outputRH
    s RHDesc="胶片引流",RHId=2
    d outputRH
    s RHDesc="硅胶引流管",RHId=3
    d outputRH
    s RHDesc="乳胶引流管",RHId=4
    d outputRH
    s RHDesc="双套管",RHId=5
    d outputRH
    s RHDesc="胶管引流",RHId=6
    d outputRH
    s RHDesc="T管引流",RHId=7
    d outputRH
    s RHDesc="菌形管",RHId=8
    d outputRH
    s RHDesc="心包引流管",RHId=9
    d outputRH
    s RHDesc="纵膈引流管",RHId=10
    d outputRH
    s RHDesc="脑室引流袋",RHId=11
    d outputRH
    s RHDesc="潘氏引流管",RHId=12
    d outputRH
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(RHId,RHDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindCareImplant2NameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCareImplant2NameExecute ]
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

ClassMethod FindCareImplant2NameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCareImplant2NameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query Findspecimen() As %Query(ROWSPEC = "RHId,RHDesc")
{
}

ClassMethod FindspecimenExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s RHDesc="无",RHId=1
    d outputRH
    s RHDesc="常规病理检查",RHId=2
    d outputRH
    s RHDesc="冰冻切片",RHId=3
    d outputRH
    s RHDesc="细菌培养",RHId=4
    d outputRH
    s RHDesc="其他",RHId=5
    d outputRH
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(RHId,RHDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindspecimenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindspecimenExecute ]
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

ClassMethod FindspecimenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindspecimenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindANSType() As %Query(ROWSPEC = "RHId,RHDesc")
{
}

ClassMethod FindANSTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s RHDesc="麻醉复苏室",RHId=1
    d outputRH
    s RHDesc="ICU",RHId=2
    d outputRH
    s RHDesc="病房",RHId=3
    d outputRH
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(RHId,RHDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindANSTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANSTypeExecute ]
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

ClassMethod FindANSTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANSTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindPatGoods() As %Query(ROWSPEC = "RHId,RHDesc")
{
}

ClassMethod FindPatGoodsExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s RHDesc="X-Ray片",RHId=1
    d outputRH
    s RHDesc="CT片",RHId=2
    d outputRH
    s RHDesc="MR片",RHId=3
    d outputRH
    s RHDesc="其他",RHId=4
    d outputRH
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(RHId,RHDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindPatGoodsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatGoodsExecute ]
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

ClassMethod FindPatGoodsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatGoodsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CreatDate: 2010-06-10
/// Description: 取医护人员
/// Table：CT_Loc,RB_Resource,PA_Adm,DHC_ANOPArrange,CT_LocationList
/// Input：needCtcpDesc医护人员姓名前面部分, 
/// 			locListCodeStr科室列表"^"分割的代码串："INOPDEPT"住院手术科室,"OUTOPDEPT"门诊手术科室,"EMOPDEPT"急诊手术科室,
/// 			"AN"麻醉科,"OP"手术室,"OUTAN"门诊麻醉科,"OUTOP"手术室,"EMAN"急诊麻醉科,"EMOP"急诊手术室,"ICU"重症科室,
/// 			locDescOrId科室名或科室Id, EpisodeID就诊号, opaId手术排班Id, ifDoctor是否医生(Y/N)为空是全部, ifSurgeon是否医生(Y)
/// Output：用户Id,用户描述
Query FindCtcp(needCtcpDesc As %String, locListCodeStr As %String, locDescOrId As %String = "", EpisodeID As %String = "", opaId As %String = "", ifDoctor As %String = "", ifSurgeon As %String = "") As %Query(ROWSPEC = "ctcpId,ctcpDesc,ctcpAlias")
{
}

ClassMethod FindCtcpExecute(ByRef qHandle As %Binary, needCtcpDesc As %String, locListCodeStr As %String, locDescOrId As %String = "", EpisodeID As %String = "", opaId As %String = "", ifDoctor As %String = "", ifSurgeon As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^wwjtempaa=needCtcpDesc_"^"_locListCodeStr_"^"_locDescOrId_"^"_EpisodeID_"^"_opaId_"^"_ifDoctor_"^"_ifSurgeon
	k ^TMPCTCP($j)
	s needCtcpDesc=$$ALPHAUP^SSUTIL4(needCtcpDesc)
	s ctlocIdList=""
	i locDescOrId'="" d
		.i locDescOrId=+locDescOrId s ctlocIdList=locDescOrId
		.e  d
			..s locDesc=$$ALPHAUP^SSUTIL4(locDescOrId)
			..s ctlocIdList=$o(^CTLOC(0,"Desc",locDesc,""))
	
	i EpisodeID="",opaId'="" s EpisodeID=$P($g(^DHCANOPArrange(opaId)),"^",1)
	s locListCodeStr=##class(web.DHCCLCom).AdjustLocListCode(locListCodeStr,EpisodeID)
	i ctlocIdList="" s ctlocIdList=##class(web.DHCCLCom).GetLocIdByLocListCode(locListCodeStr)
	s ^wwjtempaa(1)=ctlocIdList
	i needCtcpDesc="",ctlocIdList="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
	
	//查询提示已安排手术间的麻醉科医生、手术室护士
	i ((locListCodeStr_"^")["AN^")!((locListCodeStr_"^")["OP^") d
		.s opaStartDate=$p($g(^DHCANOPArrange(+opaId)),"^",14)
		.q:opaStartDate=""
    	.k ctcpList
    	.s opaId=""
    	.f  s opaId=$O(^DHCANOPArrange(0,"SDate",+opaStartDate,opaId)) q:opaId=""  d 
	    	..q:'$d(^DHCANOPArrange(opaId))
	    	..s oprId=$P($G(^DHCANOPArrange(opaId)),"^",20)
    		..q:oprId=""
    		..s oprDesc=$p($g(^DHCANC("OPRoom",oprId)),"^",2)
	    	..s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	    	..s EpisodeID=+anaId
	    	..s anaSub=$p(anaId,"||",2)
	    	..i ((locListCodeStr_"^")]"AN^") d
	    		...s anaSuperCtcpId=$P(^OR(EpisodeID,"ANA",anaSub),"^",7)
	    		...d SetCtcp(anaSuperCtcpId,oprDesc)
	    		...s anaesthCtcpId=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)
	    		...d SetCtcp(anaesthCtcpId,oprDesc)
	    		...s anaopSub=0 
				...f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
		    		....i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
		    		....s anassSub=0
		    		....i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
		    		....f  s anassSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub)) q:anassSub=""  d
		        		.....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub),"^")
		        		.....d SetCtcp(ctcpId,oprDesc)
	    	..q:(locListCodeStr_"^")'["OP^"
	    	..s anaopSub=0 
			..f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
		    	...i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
		    	...s scnSub=0
		    	...f  s scnSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",scnSub)) q:scnSub=""  d
		        	....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",scnSub),"^")
		        	....d SetCtcp(ctcpId,oprDesc)
		    	...s cirnSub=0
		    	...f  s cirnSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub)) q:cirnSub=""  d
		        	....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub),"^")
		        	....d SetCtcp(ctcpId,oprDesc)
	s ctcptIdStr=$g(^DHCCLSet("AnOp","OpDocTp")) //能为主刀医师的医护人员类型
	;s ^TEMPSJ("0113")=optype
	;s LogLocId=%session.Data("LOGON.CTLOCID")
	f i=1:1:$l(ctlocIdList) d
		.s ctlocId=$p(ctlocIdList,"^",i)
		.q:ctlocId=""
		.;q:(ctlocId'=LogLocId)&(ifDoctor'="Y")
		.s resId=""
		.f  s resId=$O(^RB("RES",0,"CTLOC",ctlocId,resId))  q:resId=""  d
			..s ctcpId=$P(^RB("RES",resId),"^",2)
			..q:ctcpId=""
			..s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
			..q:ctcptId=""
			..q:(ifSurgeon="Y")&((locListCodeStr_"^")["OPDEPT^")&((ctcptIdStr'="")&(("^"_ctcptIdStr_"^")'[("^"_ctcptId_"^")))
			..s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",4)
			..q:(ifDoctor'="")&(ifDoctor="Y")&(ctcptType'="DOCTOR")
			..q:(ifDoctor'="")&(ifDoctor'="Y")&(ctcptType'="NURSE")
			..//s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
			..s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpId)
			..q:($p(ctcpDesc,needCtcpDesc)'="")&(needCtcpDesc'="")&(..MatchName(ctcpId,needCtcpDesc)=0)
			..s ctcpDesc=ctcpDesc_$g(ctcpList(ctcpId))
			..s ctcpAlias=$p($g(^CTPCP(ctcpId,3)),"^",28)
			..s ^TMPCTCP($j,1,ctcpId)=$lb(ctcpId,ctcpDesc,ctcpAlias)
			..;Do Outputcpt
		.s ctcptOtherId = ""
		.s list = ..FindOtherCtcp(ctlocId,needCtcpDesc,ifDoctor) //liangqi 100906 查询外院医护人员
		.q:list.Size=""
		.f j=1:1:list.Size d
		..s str = list.GetAt(j)
		..s ctcptOtherId = "~"_$p(str,"^",1)
		..s ctcpDesc = $p(str,"^",2)_$g(ctcpList(ctcptOtherId))
		..s ctcpAlias=$p(str,"^",3)
		..s ^TMPCTCP($j,2,ctcptOtherId)=$lb(ctcptOtherId,ctcpDesc,ctcpAlias)
		..;d Outputothercpt
		s n="" 
		f  s n=$o(^TMPCTCP($j,n)) q:n=""  d
		.s ctcptId=""  f  s ctcptId=$o(^TMPCTCP($j,n,ctcptId)) q:ctcptId=""  d
		..d Outputcpt
		
		/*
	  //PJF 10031 
 s codeflag=0
 i +needCtcpDesc'=0 d
 .q:needCtcpDesc=""
 .s ctcpId=0
 .f  s ctcpId=$O(^SSU("SSUSR",0,"SSUSR_Initials",needCtcpDesc,ctcpId)) q:ctcpId=""  d
 ..s ctcpDesc=$p(^SSU("SSUSR",ctcpId),"^",2)
 ..s codeflag=1
 ..Do Outputcpt
 i codeflag=1 s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
 s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",ctloc,rw))  q:rw=""  d
	 .s ctcpId=$P(^RB("RES",rw),"^",2)
	 .q:ctcpId=""
	 .s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
	 .;q:(ctcpDesc'[needCtcpDesc)&(needCtcpDesc'="")
	 .s text2=$p($g(^CTPCP(ctcpId,3)),"^",12) 
	 .s tmpname=text2_ctcpDesc
 	 .s tmpname=$$ALPHAUP^SSUTIL4(tmpname)
     .q:(tmpname'[needCtcpDesc)
     .Do Outputcpt	
     */
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
SetCtcp(ctcpId,oprDesc)
	q:(ctcpId="")
	q:$g(ctcpList(ctcpId))[("("_oprDesc_")")
	s ctcpList(ctcpId)=$g(ctcpList(ctcpId))_"("_oprDesc_")"
	q

Outputcpt
 set Data=$lb(ctcpId,ctcpDesc)
 Set ^CacheTemp(repid,ind)=^TMPCTCP($j,n,ctcptId)
 Set ind=ind+1
 quit
}

ClassMethod FindCtcpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCtcpExecute ]
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

ClassMethod FindCtcpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCtcpExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod MatchName(ctcpId As %String, name As %String, exact As %Boolean = 1)
{
	q:(ctcpId="")!(name="") 0
	s userEmailName = ##class(DHCANOPCom).GetCtcpUserEmailName(ctcpId)
	s userEmailName = $p(userEmailName,"-",1)
	s userInitials=##class(DHCANOPCom).GetCtcpUserInitials(ctcpId)
	s ctcpAlias=$p($g(^CTPCP(ctcpId,3)),"^",28)
	s ctcpAlias=$$ALPHAUP^SSUTIL4(ctcpAlias)
	if exact
	{
		q (userEmailName=name)||(userInitials=name)||(ctcpAlias=name)
	}
	else 
	{
		q (userEmailName_$c(3)_userInitials_$c(3)_ctcpAlias)[name
	}
}

ClassMethod FindOtherCtcp(locId As %String, nameOralias As %String, ifDoc As %String)
{
	
	s rowId = ""
	s list = ##class(%Library.ListOfDataTypes).%New()
	
	i locId '= ""
	{
		f {
			s rowId = $o(^DHCCLCPI("CtLoc",+locId,rowId)) 
			q:rowId=""
			d OutPut
		}
	}
	else
	{
		f {
			s rowId = $o(^DHCCLCP(rowId))
			q:rowId=""
			d OutPut
		}
	}
	
	q list
	
OutPut
	s str =..GetOtherCtcp(rowId,nameOralias ,ifDoc)
	i str '= ""{
		d list.Insert(str)
	}
	q
}

ClassMethod GetOtherCtcp(rowId, nameOralias, ifDoc As %String) As %String
{
	q:rowId="" ""
	
	i ifDoc '= "" {
		i ifDoc = "Y" s ifDoc = 1
		i ifDoc = "N" s ifDoc = 0
	}
	
	s ctName = "", ctAlias = "", ctIfDoc = "",inActive = ""
	s glb = ^DHCCLCP(rowId)
	s inActive = $list(glb,6)
	q:inActive ""	//已离开
	s ctName = $list(glb,2)
	s ctAlias = $list(glb,3)
	q:((nameOralias '= "") && (nameOralias'= ctName) && (nameOralias'= ctAlias)) ""
	s ctIfDoc = $list(glb,7)
	q:((ifDoc '= "") && (+ifDoc '= ctIfDoc)) ""
	s typeCode=$li(glb,8)
    s typeId="",typeDes="" 
    f  s typeId=$o(^DHCCLComCode("UserType",typeId)) q:typeId=""  d
    .i $p(^DHCCLComCode("UserType",typeId),"^",1)=typeCode d
    ..s typeDes=$p(^DHCCLComCode("UserType",typeId),"^",2)
    s ctName=ctName_"("_typeDes_")"
	q rowId_"^"_ctName_"^"_ctAlias
}

ClassMethod GettotalTime(PuffTime, RelaxTime) As %String
{
	
	q:PuffTime="" ""
	q:RelaxTime="" ""
	s PuffTime=$zth(PuffTime,2)
	s RelaxTime=$zth(RelaxTime,2)
	s ret1=(RelaxTime-PuffTime)/60
	q ret1
}

ClassMethod SaveMessagePush(UserId, ComGroup, txtqt) As %String
{
	
	q:UserId="" "发布者为空"
	q:ComGroup="" "阅读对象不能为空"
	q:txtqt="" "发布内容不能为空"
	s date=$p($h,",",1)
	s time=$p($h,",",2)
	s ^DHCANOPMessagePush(date,time)=UserId_"@"_ComGroup_"@"_$H_"@"_txtqt
	q 0
}

ClassMethod SaveMessageGroup(Code, GroupName, userId) As %String
{
	
	q:Code="" "编码为空"
	q:GroupName="" "组名为空"
	s date=$p($h,",",1)
	s time=$p($h,",",2)
	q:$G(^DHCANOPMessageGroup(Code))'="" "编号已使用"
	s ^DHCANOPMessageGroup(Code)=GroupName_"^"_userId_"^"_date_"^"_time
	q 0
}

ClassMethod UpdateMessageGroup(Code, GroupName, userId) As %String
{
	
	q:Code="" "编码为空"
	q:GroupName="" "组名为空"
	s date=$p($h,",",1)
	s time=$p($h,",",2)
	q:$d(^DHCANOPMessageGroup(Code))<1 "该组不存在"
	s ^DHCANOPMessageGroup(Code)=GroupName_"^"_userId_"^"_date_"^"_time
	q 0
}

ClassMethod deleteMessageGroup(Code) As %String
{
	q:Code="" "编码为空"
	q:$d(^DHCANOPMessageGroup(Code))<1 "该组不存在"
	k ^DHCANOPMessageGroup(Code)
	s NurseId="",NurseIdstr=""
	f  s NurseId=$o(^DHCANOPMessageNurse(NurseId)) q:NurseId=""  d
	.q:$d(^DHCANOPMessageNurse(NurseId))<1
	.s GroupId=$p(^DHCANOPMessageNurse(NurseId),"^",1)
	.q:(GroupId'=Code)
	.k ^DHCANOPMessageNurse(NurseId)
	q 0
}

ClassMethod MessageSure(UserId, Group, Message) As %String
{
	
	q:UserId="" "用户ID为空"
	q:Group="" "安全组为空"
	q:Message="" "发布内容为空"
	s ComGroup=$p(Message,"@",2)
   	q:(ComGroup'[Group)
	s date=##Class(web.DHCANOPCom).ConvertToDateH($p($p(Message,"@",3),",",1))
	s time=##Class(web.DHCANOPCom).ConvertToTimeH($p($p(Message,"@",3),",",2))
	s MessagePush=^DHCANOPMessagePush(date,time)
	q:$d(MessagePush)<1
	s str=UserId_"^"_$h
	s ^DHCANOPMessagePush(date,time)=MessagePush_"#"_str
	q 0
}

ClassMethod IsMessagePush(UserId) As %String
{
	q:UserId="" ""
	s manId=$p($g(^SSU("SSUSR",UserId)),"^",9)
	q:manId="" ""
	q:$d(^DHCANOPMessageNurse(manId))<1 ""
	s GroupIds=$p(^DHCANOPMessageNurse(manId),"^",1)
	s stdate=(+$h-2),enddate=(+$h),MessagePush=""
	f date=stdate:1:enddate
    {  
    	s time=""
    	f  s time=$O(^DHCANOPMessagePush(date,time)) q:time=""  d
    	.q:$d(^DHCANOPMessagePush(date,time))<1
    	.s ComGroup=$p(^DHCANOPMessagePush(date,time),"@",2)
    	.q:(ComGroup'[GroupIds)
    	.s UserIdstr=$p(^DHCANOPMessagePush(date,time),"#",2)
    	.q:(UserIdstr'="")&&(("^"_UserIdstr_"^")[("^"_UserId_"^"))
    	.s PushTime=$p(^DHCANOPMessagePush(date,time),"@",3)
    	.s Pushdate=$zd($P(PushTime,",",1),3)
    	.s Pushtime=$zt($P(PushTime,",",2))
    	.s PushUser=$p(^DHCANOPMessagePush(date,time),"@",1)
    	.s txtqt=$p(^DHCANOPMessagePush(date,time),"@",4)
    	.s MessagePush=PushUser_"@"_ComGroup_"@"_Pushdate_","_Pushtime_"@"_txtqt
    }
	
	q MessagePush
}

Query GetMessagePush(stdate As %String, enddate As %String) As %Query(ROWSPEC = "users,Message,GrpDesc,Pushdate,Pushtime")
{
}

ClassMethod GetMessagePushExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    q:stdate="" "开始时间不能为空"
    q:enddate="" "结束时间不能为空"
    s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
    f date=sdate:1:edate
    {  
    	s time=""
    	f  s time=$O(^DHCANOPMessagePush(date,time)) q:time=""  d
    	.s UserId=$p(^DHCANOPMessagePush(date,time),"@",1)
    	.s users=$p(^SSU("SSUSR",UserId),"^",2)
    	.s ComGroup=$p(^DHCANOPMessagePush(date,time),"@",2)
    	.s len=$l(ComGroup,",")
    	.s GrpDesc=""
    	.for i=1:1:len d
        ..q:$P(ComGroup,",",i)=""
        ..s rw=$P(ComGroup,",",i)
    	..s Group=$p(^DHCANOPMessageGroup(rw),"^",1)
    	..i GrpDesc="" s GrpDesc=Group
    	..e  s GrpDesc=GrpDesc_","_Group
    	.s Message=$p($p(^DHCANOPMessagePush(date,time),"@",4),"#",1)
    	.s PushTime=$p(^DHCANOPMessagePush(date,time),"@",3)
    	.;s Pushdate=##Class(web.DHCANOPCom).ConvertToDateH($P(PushTime,",",1))
    	.s Pushdate=$zd($P(PushTime,",",1),3)
    	.;s Pushtime=##Class(web.DHCANOPCom).ConvertToDateH($P(PushTime,",",2))
    	.s Pushtime=$zt($P(PushTime,",",2))
    	
        .d outputRH
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(users,Message,GrpDesc,Pushdate,Pushtime)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetMessagePushFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMessagePushExecute ]
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

ClassMethod GetMessagePushClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMessagePushExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod DeleteMessagePush(Pushdate, Pushtime) As %String
{
	q:Pushdate="" "日期不能为空"
	q:Pushtime="" "时间不能为空"
	k ^temp(88)
	s date=##Class(web.DHCANOPCom).ConvertToDateH(Pushdate),time=$ZTH(Pushtime)
	s ^tempmadi(88)=date_","_time
	k ^DHCANOPMessagePush(date,time)
	q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPNurRecord","FindReadInfo","3","3")
Query FindReadInfo(Pushdate As %String, Pushtime As %String) As %Query(ROWSPEC = "tReadman,tReadTime")
{
}

ClassMethod FindReadInfoExecute(ByRef qHandle As %Binary, Pushdate As %String, Pushtime As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    q:Pushdate="" "开始时间不能为空"
    q:Pushtime="" "结束时间不能为空"
    s date=##Class(web.DHCANOPCom).ConvertToDateH(Pushdate)
	s time=##Class(web.DHCANOPCom).ConvertToTimeH(Pushtime)
	s MessagePush=^DHCANOPMessagePush(date,time)
    q:$d(MessagePush)<1
    s str=$p(MessagePush,"@",4)
    s len=$l(str,"#")
   	s GrpDesc=""
    for i=2:1:len d
     .q:$P(str,"#",i)=""
     .s use=$P(str,"#",i)
     .s UserId=$p(use,"^",1)
     .s tReadman=$p($g(^SSU("SSUSR",UserId)),"^",2)
     .s Time=$p(use,"^",2)
     .s tReadTime=$zd($P(Time,",",1),3)_""_$zt($P(Time,",",2))
     .d outputRH
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputRH
 set Data=$lb(tReadman,tReadTime)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindReadInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindReadInfoExecute ]
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

ClassMethod FindReadInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindReadInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPNurRecord","GetMessageGroup")
Query GetMessageGroup() As %Query(ROWSPEC = "GroupCode,ANCCTDesc,Createdate,CreateUser")
{
}

ClassMethod GetMessageGroupExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
   
    	s Code=""
    	f  s Code=$O(^DHCANOPMessageGroup(Code)) q:Code=""  d
    	.q:$d(^DHCANOPMessageGroup(Code))<1
    	.s ANCCTDesc=$p(^DHCANOPMessageGroup(Code),"^",1)
    	.s UserId=$p(^DHCANOPMessageGroup(Code),"^",2)
    	.s CreateUser=$p($g(^SSU("SSUSR",UserId)),"^",2)
    	.s Createdate=$ZD($p(^DHCANOPMessageGroup(Code),"^",3),4)
        .d outputcode
  
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputcode
 set Data=$lb(Code,ANCCTDesc,Createdate,CreateUser)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetMessageGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMessageGroupExecute ]
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

ClassMethod GetMessageGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMessageGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod CreateGroupNumber(NurseId, GroupId, UserId) As %String
{
	q:NurseId="" "护士不能为空"
    q:GroupId="" "组名不能为空"
	q:$G(^DHCANOPMessageNurse(NurseId))'="" "用户已添加"
	s ^DHCANOPMessageNurse(NurseId)=GroupId_"^"_UserId
	q 0
}

ClassMethod updateGroupNumber(NurseId, GroupId, UserId) As %String
{
	q:NurseId="" "护士不能为空"
    q:GroupId="" "组名不能为空"
	q:$G(^DHCANOPMessageNurse(NurseId))="" "用户未添加"
	s ^DHCANOPMessageNurse(NurseId)=GroupId_"^"_UserId
	q 0
}

ClassMethod DeleteGroupNumber(NurseId) As %String
{
	q:NurseId="" "护士不能为空"
	q:$G(^DHCANOPMessageNurse(NurseId))="" "用户未添加"
	k ^DHCANOPMessageNurse(NurseId)
	q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPNurRecord","GetMessageNurse","")
Query GetMessageNurse(GroupId As %String = "", NurseIds As %String = "") As %Query(ROWSPEC = "NurseId,Nurse,GroupName,GroupIds")
{
}

ClassMethod GetMessageNurseExecute(ByRef qHandle As %Binary, GroupId As %String = "", NurseIds As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s NurseId=""
    f  s NurseId=$O(^DHCANOPMessageNurse(NurseId)) q:NurseId=""  d
    .q:(NurseIds'="")&&(NurseIds'=NurseId)
    .s Nurse=##class(web.DHCANOPCom).GetNameById(NurseId)
    .s GroupIds=$p(^DHCANOPMessageNurse(NurseId),"^",1)
    .q:(GroupId'="")&&(GroupId'=GroupIds)
    .s GroupName=$p(^DHCANOPMessageGroup(GroupIds),"^",1)
   	.d outputGroup
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputGroup
 set Data=$lb(NurseId,Nurse,GroupName,GroupIds)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetMessageNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMessageNurseExecute ]
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

ClassMethod GetMessageNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMessageNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
