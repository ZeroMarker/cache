Class web.DHCNurMouldDataComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod getVal(id) As %String
{
 	s ret=""
	b
	if id'=""
	{
	s a=##class(Nur.DHCMoudDataSub).%OpenId(id)
	
	s tmp("EmrDate")=##class(websys.Conversions).DateLogicalToHtml(a.EmrDate) //$ZD(a.EmrDate,3)
	s tmp("EmrTime")=$ZT(a.EmrTime)
	s tmp("EmrUser")=a.EmrUser
	
	f i=1:1:345 
	{
		s itm="Item"_i  

		s tmp(itm)= $ZOBJPROPERTY(a,itm)
		s tmp(itm)=$TR(tmp(itm),"^",";")
	}
	i (tmp("Item20")'="")&&(tmp("Item20")["-")  d
	.s date=$zdh(tmp("Item20"),3)
	.s tmp("Item20")=##class(websys.Conversions).DateLogicalToHtml(date)
	
	s k=""
	f {
	s k=$O(tmp(k))
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"
	}
	}
	q ret
}

ClassMethod MoudDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^WANGLI("parr")=parr
 	s EmrCode=$P(parr,"^",1)
 	s code=$ZConvert(EmrCode,"U")
 	s EpisodeId=$P(parr,"^",2)
 	s IfCancelRec=$p(parr,"^",4)
 	;if WardId="" Quit $$$OK
 	s p="" f  s p=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeId,p)) q:p=""  d
 	.b
 	.s chl=""  f  s chl=$O(^Nur.DHCMoudDataD(p,"ChildRec",chl)) q:chl=""  d
 	..s a=##class(Nur.DHCMoudDataSub).%OpenId(p_"||"_chl)
 	..s canceluser=a.RecCancelUser
 	..q:(canceluser'="")&(IfCancelRec="false")
    ..q:(canceluser="")&(IfCancelRec="true")
 	..s ret=..getVal(p_"||"_chl)
 	..s canceldate="",canceltime="",canceluser=""
 	..i IfCancelRec="true" d
 	...s canceldate=a.RecCancelDate
	...i canceldate'="" s canceldate=##class(websys.Conversions).DateLogicalToHtml(canceldate)
	...s canceltime=a.RecCancelTime
	...i canceltime'="" s canceltime=$E($ZT(canceltime),1,5)
	...s canceluser=a.RecCancelUser
	...i canceluser'="" s canceluser=$p(^SSU("SSUSR",canceluser),"^",2)
	..i (IfCancelRec="true")&&(code="DHCNURPFB") d
	...s ret=ret_"^Item14|作废记录："_canceluser_" "_canceldate_" "_canceltime
	..s ret=ret_"^rw|"_p_"^chl|"_chl
	..d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod MoudDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MoudDataExecute ]
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

Query MoudData(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod MoudDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MoudDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 打印共用类方法(包括一个打印模版关联多个界面模版)
/// 入参:	就诊标志(手术护理记录单OP其它为空)@病人就诊ID@界面模版代码1@界面模版代码1
/// 2011-05-30
ClassMethod GetPrnValComm(parr) As %String
{
 
    //w ##class(web.DHCNurMouldDataComm).GetPrnValComm("@29@DHCNURXHnewrypg")
	s ParrFlag=$P(parr,"@",1)	
	s AnaesIDOrEpisodeID=$P(parr,"@",2)
	q:AnaesIDOrEpisodeID="" ""
	s subId=$P(parr,"@",4)
    s ret=""
    //从第3分隔值开始为模版的代码
    f ii=3:1:3 d
	.s curEmrCode=$p(parr,"@",ii)
	.i ParrFlag'="OP" s curId=##class(Nur.DHCMoudData).GetId(curEmrCode,AnaesIDOrEpisodeID)
	.e  s curId=##class(Nur.DHCMoudData).GetAnaesId(curEmrCode,AnaesIDOrEpisodeID)
    .q:curId=""
    .B 
    .i subId'="" d
    ..s id=+subId
    ..s sub=$p(subId,"$",2)
    ..s curId=id_"||"_sub
    ..s curRet=##class(Nur.DHCMoudDataSub).getVal(curId)
    .e  s curRet=##class(Nur.DHCMoudData).getVal2(curId)
    .s ret=ret_$TR(curRet,"|","&")
    s ^pjf(1)=ret
    q ret
}

ClassMethod GetPrnValComm2(parr) As %String
{
 
    //w ##class(web.DHCNurMouldDataComm).GetPrnValComm("@64@DHCNURXHrypg")
	s ParrFlag=$P(parr,"@",1)	
	s AnaesIDOrEpisodeID=$P(parr,"@",2)
	q:AnaesIDOrEpisodeID="" ""
	s subId=$P(parr,"@",4)
    s ret=""
    //从第3分隔值开始为模版的代码
    f ii=3:1:3 d
	.s curEmrCode=$p(parr,"@",ii)
	.i ParrFlag'="OP" s curId=##class(Nur.DHCMoudData).GetId(curEmrCode,AnaesIDOrEpisodeID)
	.e  s curId=##class(Nur.DHCMoudData).GetAnaesId(curEmrCode,AnaesIDOrEpisodeID)
    .q:curId=""
    .B 
    .i subId'="" d
    ..s id=+subId
    ..s sub=$p(subId,"$",2)
    ..s curId=id_"||"_sub
    ..s curRet=##class(Nur.DHCMoudDataSub).getVal(curId)
    .e  s curRet=##class(Nur.DHCMoudData).getVal2(curId)
    .s ret=ret_$TR(curRet,"|","&")
    s ^pjf(1)=ret
    q ret
}

ClassMethod GetPrnValComm1(parr) As %String
{
 
    //w ##class(web.DHCNurMouldDataComm).GetPrnValComm("@64@DHCNURXHrypg")
	s ParrFlag=$P(parr,"@",1)	
	s AnaesIDOrEpisodeID=$P(parr,"@",2)
	q:AnaesIDOrEpisodeID="" ""
    s ret=""
    //从第3分隔值开始为模版的代码
    f ii=3:1:$l(parr,"@") d
	.s curEmrCode=$p(parr,"@",ii)
	.i ParrFlag'="OP" s curId=##class(Nur.DHCMoudData).GetId(curEmrCode,AnaesIDOrEpisodeID)
	.e  s curId=##class(Nur.DHCMoudData).GetAnaesId(curEmrCode,AnaesIDOrEpisodeID)
    .q:curId=""
    .s curRet=##class(Nur.DHCMoudData).getVal(curId)
    .s ret=ret_$TR(curRet,"|","&")
    b
    q ret
}

/// CreatDate: 	2011-05-31
/// Description:新建手术护理记录单时显示的默认值
/// Table：		PA_Adm,PA_PatMas,PA_Person,CT_Loc,PAC_BloodType,DHC_AN_OPArrange,DHC_ANC_OperRoom,OR_Anaesthesia,OR_Anaest_Operation
/// Input：		oprow:手术申请ID
/// Return：	返回病人科室,姓名,性别,年龄,住院号,血型,手术间,手术日期,手术名称,入室时间,出室时间
/// 			CTLOCD_"^"_patName_"^"_patSex_"^"_patAge_"^"_patMedCareNo_"^"_patBloodType_"^"_patOpRoom_"^"_patOpDate_"^"_patOpName_"^"_StTime_"^"_EnTime
ClassMethod GetAnaesInfo(oprow)
{
	//w ##class(web.DHCNurMouldDataComm).GetAnaesInfo(459)
	q:oprow="" ""
	s EpisodeID=$P(^DHCANOPArrange(oprow),"^",1)	
    s retStr=##class(web.DHCMGNurComm).PatInfo(EpisodeID)

	s CTLOCD=$P($P(retStr,"^",8),"@",2)	//取科室$P(retStr,"^",2)
    s patName=$P($P(retStr,"^",5),"@",2)
    s patSex=$P($P(retStr,"^",4),"@",2)
    s patSex=$S(patSex="男":1,patSex="女":2,1:"")							
    s patAge=$P($P(retStr,"^",7),"@",2)
    s patAge=$P(patAge,"岁") //界面中只录入数字
    s patMedCareNo=$P($P(retStr,"^",10),"@",2)
	s patBloodTypeDr=$P(^DHCANOPArrange(oprow),"^",11)                       	//OPA_BloodType_dr	血型
	i patBloodTypeDr'="" s patBloodType=$P($G(^PAC("BLDT",patBloodTypeDr)),"^",2)
	e  s patBloodType=""
	s patOpRoomDr=$P(^DHCANOPArrange(oprow),"^",20)                       		//OPA_OpRoom_dr	手术间
	i patOpRoomDr'="" s patOpRoom=$P($G(^DHCANC("OPRoom",patOpRoomDr)),"^",2)
	e  s patOpRoom=""
	s patOpDate=$P(^DHCANOPArrange(oprow),"^",3)                       			//OPA_AppDate	手术申请日期
	i patOpDate'="" s patOpDate=$zd(patOpDate,3)
	s patOpName=""
	s anaId=$P(^DHCANOPArrange(oprow),"^",2)
	s anaSub=$p(anaId,"||",2)
	s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")  d
	.s opdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",6)         			//ANAOP_Type_DR 手术名称
	.i opdr'="" d
	..s opdes=$P($g(^ORC("OPER",opdr)),"^",2)
	..i patOpName="" s patOpName=opdes
	..e  s patOpName=patOpName_","_opdes
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
	..s InstrNurDr=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"SCN",OPSCNSub)),"^",1)  //OR_An_Oper_Scrub_Nurse 洗手护士或器材护士
	..i InstrNurDr'="" d
	...i InstrNur="" s InstrNur=$P(^CTPCP(InstrNurDr,1),"^",2)
	...e  s InstrNur=InstrNur_" "_$P(^CTPCP(InstrNurDr,1),"^",2) 
	.s CIRNSub=0 f  s CIRNSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"CIRN",CIRNSub)) q:(CIRNSub="")  d
	..q:CIRNSub>20	//小于20为巡回护士,大于20是交巡回护士
	..s cirNurDr=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"CIRN",CIRNSub)),"^",1)  //OR_An_Oper_Circul_Nurse 巡回护士
	..i cirNurDr'="" d
	...i cirNurDr="" s cirNur=$P(^CTPCP(cirNurDr,1),"^",2)
	...e  s cirNur=cirNur_" "_$P(^CTPCP(cirNurDr,1),"^",2) 
	s StTime=$P($g(^OR(EpisodeID,"ANA",anaSub)),"^",40) 						//ANA_TheatreInTime  	入室时间
	i StTime'="" s StTime=$zt(StTime,2)
	s EnTime=$P($g(^OR(EpisodeID,"ANA",anaSub)),"^",42) 						//ANA_TheatreOutTime	出室时间
    i EnTime'="" s EnTime=$zt(EnTime,2)

    q CTLOCD_"^"_patName_"^"_patSex_"^"_patAge_"^"_patMedCareNo_"^"_$g(patBloodType)_"^"_$g(patOpRoom)_"^"_$g(patOpDate)_"^"_$g(patOpName)_"^"_$g(StTime)_"^"_$g(EnTime)_"^"_$g(InstrNur)_"^"_$g(cirNur)_"^"_$g(diag)_"^"_$g(opdoc)
}

ClassMethod GetPrnValComm12(parr) As %String
{
 
    //w ##class(web.DHCNurMouldDataComm).GetPrnValComm12("@76@DHCNURHYD_ZYHZPGB@111$1")
    s ^cvcv("1212")=parr
	s ParrFlag=$P(parr,"@",1)	
	s AnaesIDOrEpisodeID=$P(parr,"@",2)
	q:AnaesIDOrEpisodeID="" ""
	s subId=$P(parr,"@",4)
    s ret=""
    b ;11
    //从第3分隔值开始为模版的代码
    f ii=3:1:3 d
	.s curEmrCode=$p(parr,"@",ii)
	.i ParrFlag'="OP" s curId=##class(Nur.DHCMoudData).GetId(curEmrCode,AnaesIDOrEpisodeID)
	.e  s curId=##class(Nur.DHCMoudData).GetAnaesId(curEmrCode,AnaesIDOrEpisodeID)
    .q:curId=""
    .i subId'="" d
    ..s id=+subId
    ..s sub=$p(subId,"$",2)
    ..s curId=id_"||"_sub
    ..s curRet=##class(Nur.DHCMoudDataSub).getVal(curId)
    .e  s curRet=##class(Nur.DHCMoudData).getVal(curId)
    .s ret=ret_$TR(curRet,"|","&")
    s ^pjf(1)=ret
    b ;16
    q ret
}

ClassMethod getPatCurLocBed(EpisodeID As %String) As %String
{
	q:Adm="" ""
	s ret=""
	s patloc="", curWardId="",bedSub="",bedCode="",curward=""
	i $g(EpisodeID)'="" d
  	.s patloc=$p(^PAADM(EpisodeID),"^",4)
  	.s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
  	.s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
  	.i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
  	.e  s bedCode=""
  	.i curWardId'="" s curward=$p(^PAWARD(curWardId),"^",5)
  	s ret=patloc_"^"_bedCode_"^"_curWardId
	q ret
}

/// by lmm
/// 排序查询
/// d ##Class(%ResultSet).RunQuery("web.DHCNurMouldDataComm","MoudDataSort","DHCNURPGD_BZSPDLB^3585020^IfCancelRec^false")
ClassMethod MoudDataSortExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^pyh("MoudDataSortExecute")=$lb(parr)
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s EmrCode=$P(parr,"^",1)
 	s code=$ZConvert(EmrCode,"U")
 	s EpisodeId=$P(parr,"^",2)
 	s IfCancelRec=$p(parr,"^",4)
 	k ^tmpMoudData("Sort",$j)
 	s rowId=$O(^User.DHCNURMoudelLinkI("CodeIndex"," "_code,""),-1)
	i rowId'="" d
	.s objSet=##class(User.DHCNURMoudelLink).%OpenId(rowId)
	.i objSet.SortDate'="" s sortDate=objSet.SortDate
	.i objSet.SortTime'="" s sortTime=objSet.SortTime 
 	s p="" f  s p=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeId,p)) q:p=""  d
 	.s chl=""  f  s chl=$O(^Nur.DHCMoudDataD(p,"ChildRec",chl)) q:chl=""  d
 	..s a=##class(Nur.DHCMoudDataSub).%OpenId(p_"||"_chl)
 	..s canceluser=a.RecCancelUser
 	..q:(canceluser'="")&(IfCancelRec="false")
    ..q:(canceluser="")&(IfCancelRec="true")
    ..//走排序配置
	..i $g(sortDate)'="" s date=$ZOBJPROPERTY(a,sortDate)
	..i $g(sortTime)'="" s time=$ZOBJPROPERTY(a,sortTime)   
    ..i $g(date)="" s date=1000000
    ..i $g(time)="" s time=1000000
    ..//end
    ..s ^tmpMoudData("Sort",$j,date,time,p,chl)=1
    
    s date=""  f  s date=$O(^tmpMoudData("Sort",$j,date)) q:date=""  d
    .s time=""  f  s time=$o(^tmpMoudData("Sort",$j,date,time)) q:time=""  d
  	..s p="" f  s p=$o(^tmpMoudData("Sort",$j,date,time,p)) q:p=""  d
 	...s chl=""  f  s chl=$o(^tmpMoudData("Sort",$j,date,time,p,chl)) q:chl=""  d       
 	....s ret=##class(Nur.DHCMoudDataSub).getVal(p_"||"_chl)
	....s ret=ret_"^rw|"_p_"^chl|"_chl
	....d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod MoudDataSortFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MoudDataSortExecute ]
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

Query MoudDataSort(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod MoudDataSortClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MoudDataSortExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
