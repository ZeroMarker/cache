Import SQLUser

Class web.DHCPE.TempTools Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// w ##class(web.DHCPE.TempTools).CopyResult("79||1","79||2","","")

ClassMethod CopyResult(SourceOEID, ToOEID, Date As %String = "", UserID As %String = "")
{
	//&SQL(Insert into Sqluser.DHC_PE_Result (RLT_ADM_DR,RLT_ARCIM_DR,RLT_OD_DR,RLT_Result,RLT_User_DR,RLT_UpdateDate,RLT_Normal,RLT_OEORI_DR,RLT_FollowUpFlag,RLT_ShowSort) values ())
	;s:Date="" Date=+$H
	;s:UserID="" UserID=1
	s SQLCODE=0
	s InsertFlag=0
	s PAADM=$P(^OEORD(+ToOEID),"^",1)
	s ToArcimID=$p($G(^OEORD(+ToOEID,"I",$P(ToOEID,"||",2),1)),"^",2)
	s SourceArcimID=$p($G(^OEORD(+SourceOEID,"I",$P(SourceOEID,"||",2),1)),"^",2)
	q:ToArcimID'=SourceArcimID "不是同一个医嘱项，不能复制"
	i Date[("-") s Date=$ZDH(Date,3)
	i Date[("/") s Date=$ZDH(Date,4)
	s RLTID=""
	f  s RLTID=$O(^DHCPERLT(0,"OEORI",SourceOEID,RLTID)) q:RLTID=""  d
	.s InsertFlag=1
	.k PLIST
	.&SQL(select * into PLIST() from Sqluser.DHC_PE_Result where RLT_rowID=:RLTID)
	.k PLIST(1)
	.s PLIST(2)=PAADM
	.s PLIST(11)=ToOEID
	.s PLIST(11)=ToOEID
	.s:Date'="" PLIST(7)=Date
	.s:UserID'="" PLIST(6)=UserID
	.&SQL(insert into Sqluser.DHC_PE_Result values :PLIST())
	w:InsertFlag=0 "源项目没有数据",!
	q SQLCODE
}

// w ##class(web.DHCPE.TempTools).InsertResult("190||9","临床诊断:;检查所见:肝脏大小形态异常;诊断意见:肝囊肿脂肪肝","","")

ClassMethod InsertResult(OEID, Result As %String = "", UserID As %String = "", Date As %String = "")
{
	//临床诊断:;检查所见:肝脏大小形态异常,不规则囊肿肝脏表面欠光滑,建议就诊;诊断意见:肝囊肿脂肪肝
	
	q:OEID="" "医嘱不能为空"
	q:'$D(^OEORD(+OEID,"I",$P(OEID,"||",2))) "医嘱不存在"
	q:$D(^DHCPERLT(0,"OEORI",OEID)) "医嘱已经存在结果，不需要再次插入"
	s:Result="" Result="临床诊断:;检查所见:;诊断意见:"
	s:UserID="" UserID=1
	s:Date="" Date=+$H
	s PAADM=$P(^OEORD(+OEID),"^",1)
	s ArcimID=$p($G(^OEORD(+OEID,"I",$P(OEID,"||",2),1)),"^",2)
	s Sort="99999999"
	s SQLCODE=0
	s InsertFlag=0
	s Sequence=""
	f  s Sequence=$O(^DHCPEODR(0,"Sequence",ArcimID,Sequence)) q:Sequence=""  d
	.s RowId=""
	.f  s RowId=$O(^DHCPEODR(0,"Sequence",ArcimID,Sequence,RowId)) q:RowId=""  d
	..Set RLTODDR=$P($g(^DHCPEODR(RowId)),"^",2)
	..s ODDesc=$p($G(^DHCPEST(+RLTODDR,"OD",$P(RLTODDR,"||",2))),"^",1)	//细项名称	DHC_PE_OrderDetail
	..Q:(""=ODDesc)
	..s InsertFlag=1
	..&SQL(Insert into Sqluser.DHC_PE_Result (RLT_ADM_DR,RLT_ARCIM_DR,RLT_OD_DR,RLT_Result,RLT_User_DR,RLT_UpdateDate,RLT_Normal,RLT_OEORI_DR,RLT_FollowUpFlag,RLT_ShowSort) values 
												(:PAADM,:ArcimID,:RLTODDR,:Result,:UserID,:Date,'0',:OEID,'N',:Sequence))
	s:InsertFlag=0 ret="没有细项，没有插入"
	i InsertFlag=1 d
	.s:SQLCODE=0 ret="插入成功"_%ROWID
	.s:SQLCODE'=0 ret="插入失败"_SQLCODE
	q ret
}

// d ##class(web.DHCPE.TempTools).UpdateResult(SourceOEID,ToOEID)

ClassMethod UpdateResult(SourceOEID, ToOEID)
{
	s Ret=""
	s LabSpec=$p($G(^OEORD(+SourceOEID,"I",$P(SourceOEID,"||",2),3)),"^",20)
	i LabSpec'="" d
	.&SQL(Delete from Sqluser.DHC_PE_Result where RLT_OEORI_DR=:SourceOEID)
	.s:SQLCODE=100 SQLCODE=0
	.s:SQLCODE'=0 Ret="删除结果错误"
	.q:SQLCODE'=0
	.s Ret=##class(web.DHCPE.TransResult).TransALabItem("","1",SourceOEID)
	.
	e  d
	.s RARRowId=$o(^DHCPACRegInfoi("OEORI",SourceOEID,0))
	.i RARRowId'="" d
	..&SQL(Delete from Sqluser.DHC_PE_Result where RLT_OEORI_DR=:SourceOEID)
	..s:SQLCODE=100 SQLCODE=0
	..s:SQLCODE'=0 Ret="删除结果错误"
	..q:SQLCODE'=0
	..s Ret=##class(web.DHCPE.TransResult).TransARisItem("",SourceOEID,"1")
	i Ret'=""
	{
		w Ret
		q
	}
	
	s ToPAADM=$P(^OEORD(+ToOEID),"^",1)
	&SQL(Update Sqluser.DHC_PE_Result set RLT_ADM_DR=:ToPAADM,RLT_OEORI_DR=:ToOEID where RLT_OEORI_DR=:SourceOEID)
	i SQLCODE'=0 w "错误："_SQLCODE
	s ^DHCPETmpeUpdateResult($H,SourceOEID,ToOEID)=""
	w "成功"
}

// d ##class(web.DHCPE.TempTools).SetRange("医嘱ID","C0450","阴性")

ClassMethod SetRange(ArcimID, ODCode, Range)
{
	s rid=""
	f  s rid=$O(^DHCPERLT(0,"ARCIM",ArcimID,rid)) q:rid=""  d
	.s ODID=$P(^DHCPERLT(rid),"^",3)
	.s RODCode=$p($G(^DHCPEST(+ODID,"OD",$p(ODID,"||",2))),"^",11)
	.q:RODCode'=ODCode
	.s ^DHCPEDataEx("DHCPEResult",rid,"Ranges")=Range
}

ClassMethod SetArrValue()
{
	;d ##class(web.DHCPE.TempTools).SetArrValue()
	s Spec="8010000000"
	f  s Spec=$O(^TEPI(Spec)) q:Spec=""  d
	.;^OEORD(0,"EpisNo",SpecNo,Order,OrderSub)
	.s SetCode=$O(^TEPI(Spec,1,""))
	.s Order=""
	.f  s Order=$O(^OEORD(0,"EpisNo",Spec,Order)) q:Order=""  d
	..s PAADM=$P(^OEORD(Order),"^",1)
	..s OrderSub=""
	..f  s OrderSub=$O(^OEORD(0,"EpisNo",Spec,Order,OrderSub)) q:OrderSub=""  d
	...s OrderItemID=Order_"||"_OrderSub
	...q:'$D(^DHCPERLT(0,"OEORI",OrderItemID))
	...d ##class(web.DHCPE.TransResultEx).SetArrowInfo(PAADM,OrderItemID)
}

ClassMethod UpdateOneSpec(Spec)
{
   ;d ##class(web.DHCPE.TempTools).UpdateOneSpec(8010193758)
	s SetCode=$O(^TEPI(Spec,1,""))
	s Order=""
	f  s Order=$O(^OEORD(0,"EpisNo",Spec,Order)) q:Order=""  d
	.s PAADM=$P(^OEORD(Order),"^",1)
	.s OrderSub=""
	.f  s OrderSub=$O(^OEORD(0,"EpisNo",Spec,Order,OrderSub)) q:OrderSub=""  d
	..s OrderItemID=Order_"||"_OrderSub
	..q:'$D(^DHCPERLT(0,"OEORI",OrderItemID))
	..d ##class(web.DHCPE.TransResultEx).SetArrowInfo(PAADM,OrderItemID)
}

ClassMethod ExportInfo(DateStr, Job)
{
	;d ##class(web.DHCPE.TempTools).ExportInfo("2013-11-08")
	s PersonNum=0
	s SpecNum=0
	s Date=$ZDH(DateStr,3)
	s Time=""
	f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:Time=""  d
	.s IADM=""
	.f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM)) q:IADM=""  d
	..s Status=$P(^DHCPEIADM(IADM),"^",8)
	..q:Status'="ARRIVED"
	..s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	..s Order=$O(^OEORD(0,"Adm",PAADM,0))
	..s Obj=##class(User.PAAdm).%OpenId(PAADM)
	..s PersonNum=PersonNum+1
	..s Name=Obj.PAADMPAPMIDR.PAPMIName
	..s RegNo=Obj.PAADMPAPMIDR.PAPMINo
	..s OrderSub=0
	..f  s OrderSub=$O(^OEORD(Order,"I",OrderSub)) q:OrderSub=""  d
	...s Stat=$P(^OEORD(Order,"I",OrderSub,1),"^",13)
	...q:Stat="4"
	...s PaiedStatus=$P(^OEORD(Order,"I",OrderSub,3),"^",5)
	...q:PaiedStatus'="P"
	...s SpecNo=$P(^OEORD(Order,"I",OrderSub,3),"^",20)
	...q:SpecNo=""
	...q:$D(^TempDHCPESpec(Job,SpecNo))
	...s OEID=Order_"||"_OrderSub
	...s CrmOrderID=$O(^DHCPECRMO(0,"OEORI",OEID,0))
	...q:CrmOrderID=""
	...s CrmID=$P(^DHCPECRMO(CrmOrderID),"^",2)
	...s SetsID=$P(^DHCPEPreIADM(+CrmID,"ORDITEM",$P(CrmID,"||",2)),"^",2)
	...;q:SetsID'=""
	...s ^TempDHCPESpec(Job,SpecNo)=""
	
	q
}

ClassMethod Export()
{
	;d ##class(web.DHCPE.TempTools).Export()
	s Job=$J
	k ^TempDHCPESpec(Job)
	;d ##class(web.DHCPE.TempTools).ExportInfo("2013-11-08",Job)
	;d ##class(web.DHCPE.TempTools).ExportInfo("2013-11-11",Job)
	d ##class(web.DHCPE.TempTools).ExportInfo("2013-11-12",Job)
	;d ##class(web.DHCPE.TempTools).ExportInfo("2013-11-13",Job)
	;d ##class(web.DHCPE.TempTools).ExportInfo("2013-11-14",Job)
	
	s f=##class(%File).%New("/tem/ListInfo.txt")
	d f.Open("WSN")
	
	s SpecNo=""
	f  s SpecNo=$O(^TempDHCPESpec(Job,SpecNo)) q:SpecNo=""  d
	.s Order=""
	.s Order=$O(^OEORD(0,"EpisNo",SpecNo,""))
	.s PAADM=$P(^OEORD(Order),"^",1)
	.s Obj=##class(User.PAAdm).%OpenId(PAADM)
	.s Name=Obj.PAADMPAPMIDR.PAPMIName
	.s RegNo=Obj.PAADMPAPMIDR.PAPMINo
	.s OrderSub=""
	.f  s OrderSub=$O(^OEORD(0,"EpisNo",SpecNo,Order,OrderSub)) q:OrderSub=""  d
	..s Stat=$P(^OEORD(Order,"I",OrderSub,1),"^",13)
	..q:Stat="4"
	..s PaiedStatus=$P(^OEORD(Order,"I",OrderSub,3),"^",5)
	..q:PaiedStatus'="P"
	..s HadResult=0
	..s:$D(^TEPI(SpecNo)) HadResult=1
	..s SetsFlag=0
	..s OEID=Order_"||"_OrderSub
	..s CrmOrderID=$O(^DHCPECRMO(0,"OEORI",OEID,0))
	..s CrmID=$P(^DHCPECRMO(CrmOrderID),"^",2)
	..s SetsID=$P(^DHCPEPreIADM(+CrmID,"ORDITEM",$P(CrmID,"||",2)),"^",2)
	..s:SetsID'="" SetsFlag="1"
	..s ArcimID=$P(^OEORD(Order,"I",OrderSub,1),"^",2)
	..s ArcimCode=$P(^ARCIM(+ArcimID,1,1),"^",1)
	..s ArcimDesc=$P(^ARCIM(+ArcimID,1,1),"^",2)
	..s ArcimDesc=##class(web.DHCPE.Public.Setting).Replace(ArcimDesc,$C(9),"")
	..s ArcimDesc=##class(web.DHCPE.Public.Setting).Replace(ArcimDesc,$C(13),"")
	..s ArcimDesc=##class(web.DHCPE.Public.Setting).Replace(ArcimDesc,$C(10),"")
	..s OneInfo=SpecNo_$C(9)_RegNo_$C(9)_Name_$C(9)_ArcimCode_$C(9)_ArcimDesc_$C(9)_HadResult_$C(9)_SetsFlag
	..d f.WriteLine(OneInfo)
	k ^TempDHCPESpec(Job)
	d f.Close()
	w "OVER"
	q
}

ClassMethod ExportUser()
{
	
	;w ##class(web.DHCPE.TempTools).ExportUser()
	s ret=""
	s rset = ##class(%ResultSet).%New()
	s rset.ClassName = "web.DHCPE.ChartAssign"
	s rset.QueryName = "SerchChartAssign"
	d rset.Execute("","","")
	While (rset.Next()) 
    {
	     s OneInfo=""
	     s OneInfo=rset.Data("TUserName") ;1
	     s OneInfo=OneInfo_"^"_rset.Data("TLocName") ;2
	     s OneInfo=OneInfo_"^"_rset.Data("TGroupName") ;3
	     w OneInfo,!
     }
     q ret
}

ClassMethod ExportItemTar()
{
	;d ##class(web.DHCPE.TempTools).ExportItemTar()
	s CurDate=+$H
	s ParRef=0
	f  s ParRef=$O(^DHCPEST(ParRef)) q:ParRef=""  d
	.s id="0" 	
	.f  s id=$O(^DHCPEST(ParRef,"O",id)) q:id=""  d
	..s CurData=$g(^DHCPEST(ParRef,"O",id))
	..//s ^zl("2010",1)=CurData
	..s iParRef=ParRef
	..s iChildsub=id
	..s iRowId=iParRef_"||"_id
	..// 医嘱编码 医嘱名称
	..s arcitmid=$p(CurData,"^",1)
	..//s ^zl("2010",2)=iARCIMDR
	..Q:(""=arcitmid)
	..s EffDate=$p(^ARCIM($p(arcitmid,"||",1),$p(arcitmid,"||",2),7),"^",1)
	..i EffDate="" s EffDate=+$H+1
	..q:EffDate<+$H
	..s TarItem=0
	..f  s TarItem=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem)) q:TarItem=""  d
	...s TarCode=$P(^DHCTARI(TarItem),"^",1)
	...s TarDesc=$P(^DHCTARI(TarItem),"^",2)
	...s StartDate=0
	...f  s StartDate=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate)) q:(StartDate="")||(StartDate>CurDate)  d
	....s OLTID=0
	....f  s OLTID=$o(^DHCOLT(0,"ARTTA",arcitmid,TarItem,StartDate,OLTID)) q:OLTID=""  d
	.....s EndDate=$p(^DHCOLT(OLTID),"^",5)
	.....q:(EndDate'="")&&(EndDate<CurDate)
	.....s qty=$p(^DHCOLT(OLTID),"^",3)
	.....s ADMFeeType=""
	.....//s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",preAdmId))
	.....s ItemADMType=6
	.....s CurPrice1=+##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"",ItemADMType,"")   //得到当前计费项金额
	.....s ItemADMType=8
	.....s CurPrice2=+##class(web.UDHCJFPRICE).GetItmPrice(TarItem,CurDate,"",ItemADMType,"")   //得到当前计费项金额
	.....w $P(^ARCIM(+arcitmid,1,1),"^",1)_"^"_$P(^ARCIM(+arcitmid,1,1),"^",2)_"^"_TarCode_"^"_TarDesc_"^"_CurPrice1_"^"_CurPrice2_"^"_qty,!
}

ClassMethod ExportSpecialItem()
{
	;d ##class(web.DHCPE.TempTools).ExportSpecialItem()
	s ItemID=""
	f  s ItemID=$O(^DHCPECTDataEx("DHCPEStationOrder","SpecialItem",ItemID)) q:ItemID=""  d
	.s EffDate=$p(^ARCIM($p(ItemID,"||",1),$p(ItemID,"||",2),7),"^",1)
	.i EffDate="" s EffDate=+$H+1
	.q:EffDate<+$H
	.s Flag=$G(^DHCPECTDataEx("DHCPEStationOrder","SpecialItem",ItemID,53))
	.q:Flag'=8
	.w $P(^ARCIM(+ItemID,1,1),"^",1)_"^"_$P(^ARCIM(+ItemID,1,1),"^",2),!
}

/// d ##class(web.DHCPE.TempTools).DeleteNOUseItem()
ClassMethod DeleteNOUseItem()
{
	s str="0000000699^0000000696^1000000099^0000000697^0000000698"
	s str=str_"^1000000097^1000000095^1000000102^0000001645^0000001647"
	s str=str_"^0000001646^0000002442^1000000247^1000000102^0000000505"
	s str=str_"^0000001551^1000000152^0000001550^1000000168^0000001644"
	s str=str_"^DCSK000079^DCSK000125^DCSK000094^FSKPF0607^0000001612"
	
	//0000002442  1000000102
	s Length=$L(str,"^")
	for i=1:1:Length
	{
		s OneCode=$P(str,"^",i)
		s ARCIMID=$O(^ARCIM(0,"Code",OneCode,0))
		continue:ARCIMID=""
		s ARCID=ARCIMID_"||"_1
		;w ARCID,i,!
		&sql(Delete From Sqluser.DHC_PE_StationOrder where STORD_ARCIM_DR=:ARCID)
		w SQLCODE,!
	}
}

/// w ##class(web.DHCPE.TempTools).DeleteNoUseDetail()
ClassMethod DeleteNoUseDetail()
{
	s ST=7
	f  s ST=$O(^DHCPEST(ST)) q:ST=""  d
	.s ODSub=0
	.f  s ODSub=$O(^DHCPEST(ST,"OD",ODSub)) q:ODSub=""  d
	..s ODID=ST_"||"_ODSub
	..s ODR=$O(^DHCPEODR(0,"OD",ODID,0))
	..q:ODR'=""
	..;w ODID,!
	..&sql(Delete From Sqluser.dhc_pe_orderdetail where od_rowid=:ODID)
}

/// w ##class(web.DHCPE.TempTools).UpdateODStandard()
ClassMethod UpdateODStandard()
{
	s ST=0
	f  s ST=$O(^DHCPEST(ST)) q:ST=""  d
	.s ODSub=0
	.f  s ODSub=$O(^DHCPEST(ST,"OD",ODSub)) q:ODSub=""  d
	..s ODID=ST_"||"_ODSub
	..s ODSSub=0
	..f  s ODSSub=$O(^DHCPEST(ST,"OD",ODSub,"ODS",ODSSub)) q:ODSSub=""  d
	...s TextVal=$P(^DHCPEST(ST,"OD",ODSub,"ODS",ODSSub),"^",2)
	...s TextVal=##class(web.DHCPE.Public.Setting).Replace(TextVal,"""","")
	...s $P(^DHCPEST(ST,"OD",ODSub,"ODS",ODSSub),"^",2)=TextVal
}

/// d ##class(web.DHCPE.TempTools).UpdateED()
ClassMethod UpdateED()
{
	s ST=0
	f  s ST=$O(^DHCPEED(ST)) q:ST=""  d
	.s TextVal=$P(^DHCPEED(ST,"Detail"),"^",1)
	.s TextVal=##class(web.DHCPE.Public.Setting).Replace(TextVal,"""","")
	.s $P(^DHCPEED(ST,"Detail"),"^",1)=TextVal
}

/// w ##class(web.DHCPE.TempTools).UpdateAmount("472||16",2032,17)
ClassMethod UpdateAmount(Strings, PAID, GID)
{
	s i=$l(Strings,"^")
	TSTART
	for j=1:1:i
	{
		s OEID=$p(Strings,"^",j)
		s ItemID=""
		&SQL(select crmo_crmori into :ItemID from dhc_pe_crmorder where crmo_oeori_dr=:OEID)
		
		continue:ItemID=""
		if SQLCODE'=0
		{
			TROLLBACK
			break 
		}
		s IPAID=""
		&SQL(select pioif_paudit_dr into :IPAID from DHC_PE_PreIOrdItemFee where pioif_parref=:ItemID)
		
		continue:IPAID=""
		if SQLCODE'=0
		{
			TROLLBACK
			break 
		}
		
		&SQL(update DHC_PE_PreIOrdItemFee set pioif_paudit_dr=:PAID where pioif_parref=:ItemID)
		if SQLCODE'=0
		{
			TROLLBACK //
			break 
		}
		w ItemID_"^"_IPAID_"^"_OEID_"^"_PAID,!
	}
	TROLLBACK:SQLCODE'=0
	q:SQLCODE'=0 SQLCODE
	s SQLCODE= ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(GID)
	TROLLBACK:SQLCODE'=0
	q:SQLCODE'=0 SQLCODE
	TCOMMIT
	q SQLCODE
}

/// w ##class(web.DHCPE.TempTools).SetGroupSort()
ClassMethod SetGroupSort()
{
	s GID=0
	f  s GID=$o(^DHCPEPreGADM(GID)) q:GID=""  d
	.d ..GetAdmList(GID,"G")
}

ClassMethod GetAdmList(ID, Type)
{
	q:ID="" ""
	s List=""
	i Type="G" d
	.s id=0
	.f  s id=$O(^DHCPEPreGADM(ID,"Team",id)) q:id=""  d
	..s TeamID=ID_"||"_id
	..d GetAdmListByTeam
	e  d
	.s TeamID=ID
	.d GetAdmListByTeam
	
	q List
GetAdmListByTeam
	s Iid=0
	f  s Iid=$o(^DHCPEPreIADM(0,"PGTeam",TeamID,Iid)) q:Iid=""  d
	.s Status=$P($G(^DHCPEPreIADM(Iid)),"^",7)
	.q:Status="CANCELPREREG"
	.s ^DHCPEDataEx("DHCPEPreIADM","GTEAM",TeamID)=+$G(^DHCPEDataEx("DHCPEPreIADM","GTEAM",TeamID))+1
	.s ^DHCPEDataEx("DHCPEPreIADM","GTEAM","IADM",Iid)=$G(^DHCPEDataEx("DHCPEPreIADM","GTEAM",TeamID))
	/*.s BaseId=$p(^DHCPEPreIADM(Iid),"^",1)
	.s RegNo=$P($g(^DHCPEPreIBI(BaseId)),"^",1)
	.s ^DHCPESortTemp(job,RegNo,Iid)=Iid
	*/
	q
}

/// d ##class(web.DHCPE.TempTools).SetEXActive() 
/// 设置激活
ClassMethod SetEXActive()
{
	s EXID=1507
	f  s EXID=$o(^DHCPEED(EXID)) q:EXID=""  d
	.s ^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EXID)="Y"
	q 0
}

/// d ##class(web.DHCPE.TempTools).SetODStanard() 
/// 设置进入小结
ClassMethod SetODStanard()
{
	s Station=0
	f  s Station=$o(^DHCPEST(Station)) q:Station=""  d
	.s OD=0
	.f  s OD=$o(^DHCPEST(Station,"OD",OD)) q:OD=""  d
	..s ODS=0
	..f  s ODS=$o(^DHCPEST(Station,"OD",OD,"ODS",ODS)) q:ODS=""  d
	...s ODSID=Station_"||"_OD_"||"_ODS
	...s ^DHCPECTDataEx("BaseData","ODStandard","ODS_Summary",ODSID)="Y"
}

/// 设置导检单排序的设置   参数为自动换人的间隔
/// w ##class(web.DHCPE.TempTools).SetTempSortStr(20)
ClassMethod SetTempSortStr(PersonTotal)
{
	s Str=""
	s RowID=""
	f  s RowID=$o(^DHCPECTDataEx("PatItem",RowID)) q:RowID=""  d
	.s AutoChangeFlag=$p(^DHCPECTDataEx("PatItem",RowID),"^",4)
	.q:AutoChangeFlag'="Y"
	.s Sort=$p(^DHCPECTDataEx("PatItem",RowID),"^",2)
	.s OneStr=RowID_"^"_Sort
	.i Str="" d
	..s Str=OneStr
	.e  d
	..s Str=Str_"&"_OneStr
	i Str'="" s Str=Str_"@"_PersonTotal
	s ^DHCPESetting("DHCPE","PatItemSort")=Str
	q Str
}

/// d ##class(web.DHCPE.TempTools).UpdateOEOrdItemStat()
ClassMethod UpdateOEOrdItemStat()
{
	&SQL(update OE_ORDItem set OEORI_ItemStat_DR='6' where OEORI_RowID='968469||3')
	&SQL(update OE_ORDItem set OEORI_ItemStat_DR='6' where OEORI_RowID='968469||12')
	&SQL(update OE_ORDItem set OEORI_ItemStat_DR='6' where OEORI_RowID='995810||3')
}

/// 设置专家诊断的Code
/// d ##class(web.DHCPE.TempTools).SetEDCode()
ClassMethod SetEDCode()
{
	s EDRowID=0
	f  s EDRowID=$o(^DHCPEED(EDRowID)) q:EDRowID=""  d
	.s EDCode=$E("00000000",1,8-$l(EDRowID))_EDRowID
	.&SQL(update DHC_PE_ExpertDiagnosis set ED_Code=:EDCode where ED_RowID=:EDRowID)
}

/// 设置诊断以及别名产生rowid使用的global
/// d ##class(web.DHCPE.TempTools).SetEXID()
ClassMethod SetEXID()
{
	//专家建议维护
	s ID=0
	&SQL(select max(ED_RowID) into :ID from DHC_PE_ExpertDiagnosis)
	s ^mdata("DHCPEEXPERTDIAGNOSIS")=ID
	w "DHC_PE_ExpertDiagnosis:"_ID,!
	
	//建议别名
	s ID=0
	&SQL(select max(EDA_RowID) into :ID from DHC_PE_EDAlias)
	s ^mdata("DHCPEEDALIAS")=ID
	w "DHC_PE_EDAlias:"_ID,!
	
	
	//建议级别
	s ID=0
	&SQL(select max(EDC_RowID) into :ID from DHC_PE_EDClass)
	s ^mdata("DHCPEEDCLASS")=ID
	w "DHC_PE_EDClass:"_ID,!

   //级别和建议关联
    s ID=0
	&SQL(select max(EDCR_RowID) into :ID from DHC_PE_EDCRelate)
	s ^mdata("DHCPEEDCRELATE")=ID
	w "DHC_PE_EDCRelate:"_ID,!
	
   
   //疾病
	s ID=0
	&SQL(select max(ILLS_RowId) into :ID from DHC_PE_IllnessStandard)
	s ^mdata("DHCPEILLNESSSTANDARD")=ID
	w "DHC_PE_IllnessStandard:"_ID,!
	
   //疾病别名 DHC_PE_ILLSAlias
	s ID=0
	&SQL(select max(ILLSA_RowID) into :ID from DHC_PE_ILLSAlias)
	s ^mdata("DHCPEILLSALIAS")=ID
	w "DHC_PE_ILLSAlias:"_ID,!

	//疾病和诊断关联
	s ID=0
	&SQL(select max(IDR_RowId) into :ID from DHC_PE_IDRelate)
	s ^mdata("DHCPEIDRELATE")=ID
	w "DHC_PE_IDRelate:"_ID,!

    //站点
	s ID=0
	&SQL(select max(ST_RowID) into :ID from DHC_PE_Station)
	s ^mdata("DHCTJSTATION")=ID
	w "DHC_PE_Station:"_ID,!
	
	//大项和细项关联
	s ID=0
	&SQL(select max(ODR_RowId) into :ID from dhc_pe_orderdetailrelate)
	s ^mdata("DHCTJORDERDETAILRELATE")=ID
	w "dhc_pe_orderdetailrelate:"_ID,!
	
	/* 随访系统涉及mdata计数器Global及新的Global
	User.DHCCRMARCIMEx.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCCRMARCIMEX"))
	^DHCCRMARCIMEx
	
	User.DHCCRMBirthSend.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCCRMBIRTHSEND"))
	^DHCCRMBS
	
	User.DHCCRMCallbackSend.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCCRMCALLBACKSEND"))
	^DHCCRMCBS
	
	User.DHCCRMFURecord.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCCRMFURECORD"))
	^DHCCRMFUR
	
	User.DHCCRMFUSubject.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCCRMFUSUBJECT"))
	^DHCCRMFUS
	
	User.DHCCRMIPSubject.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCCRMIPSUBJECT"))
	^DHCCRMIPS
	
	User.DHCCRMLabResultSend.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCCRMLABRESULTSEND"))
	^DHCCRMLRS
	
	User.DHCCRMQRecord.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCCRMQRECORD"))
	^DHCCRMQR
	*/
	
	/* 体检系统涉及mdata计数器Global及新的Global
	User.DHCPEAdvancePayment.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEADVANCEPAYMENT"))
	^DHCPEAP
	
	User.DHCPEAsChargedOrder.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEASCHARGEDORDER"))
	^DHCPEACO
	
	User.DHCPECRMOrder.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPECRMORDER"))
	^DHCPECRMO
	
	User.DHCPEEDAlias.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEEDALIAS"))
	^DHCPEEDA
	
	User.DHCPEEDClass.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEEDCLASS"))
	^DHCPEEDC
	
	User.DHCPEEDCRelate.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEEDCRELATE"))
	^DHCPEEDCR
	
	User.DHCPEExpertDiagnosis.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEEXPERTDIAGNOSIS"))
	^DHCPEED
	
	User.DHCPEGADM.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEGADM"))
	^DHCPEGADM
	
	User.DHCPEGBaseInfo.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCTJGBASEINFO"))
	^DHCPEGBI
	
	User.DHCPEGeneralAdvice.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEGENERALADVICE"))
	^DHCPEGA
	
	User.DHCPEGeneralSummarize.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEGENERALSUMMARIZE"))
	^DHCPEGS
	
	User.DHCPEGGeneralSummarize.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEGGENERALSUMMARIZE"))
	^DHCPEGGS
	
	User.DHCPEGroupChart.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEGROUPCHART"))
	^DHCPEGC
	
	User.DHCPEGSDModifiedRecords.cls(GSDMRRowID)[InitialExpression]: $i(^mdata("DHCPEGSDM"))
	^DHCPEGSDM   比较特殊
	
	User.DHCPEHealthRecord.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEHEALTHRECORD"))
	^DHCPEHR
	
	User.DHCPEHealthRecordDetail.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEHEALTHRECORDDETAIL"))
	^DHCPEHRD
	
	User.DHCPEHRDRelate.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEHRDRELATE"))
	^DHCPEHRDR
	
	User.DHCPEIADM.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEIADM"))
	^DHCPEIADM
	
	User.DHCPEIDRelate.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEIDRELATE"))
	^DHCPEIDR
	
	User.DHCPEIllnessStandard.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEILLNESSSTANDARD"))
	^DHCPEILLS
	
	User.DHCPEILLSAlias.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEILLSALIAS"))
	^DHCPEILLSA
	
	User.DHCPEINVPRT.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEINVPRT"))
	^DHCPEINVPRT
	
	User.DHCPEItemExtend.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEITEMEXTEND"))
	^DHCPEIE
	
	User.DHCPEODAdvice.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCTJODADVICE"))
	^DHCPEODA
	
	User.DHCPEOrderDetailRelate.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCTJORDERDETAILRELATE"))
	^DHCPEODR
	
	User.DHCPEOrdSetsEx.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEORDSETSEX"))
	^DHCPEOSE
	
	User.DHCPEPAPBRelate.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEPAPBRELATE"))
	^DHCPEPAPBR
	
	User.DHCPEPreAudit.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEPREAUDIT"))
	^DHCPEPreA
	
	User.DHCPEPreGADM.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEPREGADM"))
	^DHCPEPreGADM
	
	User.DHCPEPreGBaseInfo.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEPREGBASEINFO"))
	^DHCPEPreGBI
	
	User.DHCPEPreIADM.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEPREIADM"))
	^DHCPEPreIADM
	
	User.DHCPEPreIBaseInfo.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEPREIBASEINFO"))
	^DHCPEPreIBI
	
	User.DHCPEReport.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEREPORT"))
	^DHCPERPT
	
	User.DHCPEResult.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCTJRESULT"))
	^DHCPERLT
	
	User.DHCPEStation.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCTJSTATION"))
	^DHCPEST
	
	User.DHCPEStationSummarize.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPESTATIONSUMMARIZE"))
	^DHCPESS
	
	User.DHCPEUSERREPORT.cls(Storage)[SQLStorage,SqlIdExpression]: $i(^mdata("DHCPEUSERREPORT"))
	^DHCPEUSERREPORT
	*/
}

/// w ##class(web.DHCPE.TempTools).DeleteNoUserEX()
ClassMethod DeleteNoUserEX()
{
	s EDRowID=0
	s i=0
	f  s EDRowID=$o(^DHCPEED(EDRowID)) q:EDRowID=""  d
	.s AC=$G(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",EDRowID))
	.i AC'="Y" d
	..&SQL(delete from DHC_PE_ExpertDiagnosis where ED_RowID=:EDRowID)
	..&SQL(delete from DHC_PE_EDAlias where EDA_ED_DR=:EDRowID)
	..s i=i+1
	q i
}

/// d ##class(web.DHCPE.TempTools).ExportSetting()
ClassMethod ExportSetting()
{
	s Node=""
	f  s Node=$o(^DHCPESetting(Node)) q:Node=""  d
	.s Node2=""
	.f  s Node2=$o(^DHCPESetting(Node,Node2)) q:Node2=""  d
	..s Result=$G(^DHCPESetting(Node,Node2))
	..w "Set ^DHCPESetting("_""""_Node_""""_","_""""_Node2_""""_")="_""""_Result_"""",!
	q "OVER"
}

// d ##class(web.DHCPE.TempTools).StationRelateDJD(7,4,3)

// d ##class(web.DHCPE.TempTools).StationRelateDJD(8,5,"")

// d ##class(web.DHCPE.TempTools).StationRelateDJD(9,6,"")

// d ##class(web.DHCPE.TempTools).StationRelateDJD(10,7,"")

// d ##class(web.DHCPE.TempTools).StationRelateDJD(13,8,"")

// d ##class(web.DHCPE.TempTools).StationRelateDJD(14,8,"")

ClassMethod StationRelateDJD(StationID, PatItemID, OtherPatItemID)
{
	s id=0
	f  s id=$O(^DHCPEST(StationID,"O",id)) q:id=""  d
	.s CurData=$g(^DHCPEST(StationID,"O",id))
	.// 医嘱编码 医嘱名称
	.s iARCIMDR=$p(CurData,"^",1)
	.Q:(""=iARCIMDR)
	.s ^DHCPECTDataEx("PatItemSort",iARCIMDR)=PatItemID
	.Set Ext=$o(^ARCIM(+iARCIMDR,1,"EXT",0))
	.Quit:$g(Ext)=""
	.Set ExtCode=$p(^ARCIM(+iARCIMDR,1,"EXT",Ext),"^",4)
	.Set Specimendr=""
	.For  Set Specimendr=$o(^TTAB("TS",ExtCode,1,Specimendr)) Q:(Specimendr="")  Do
	..s SPECDesc=$p(^TTAB("SPEC",Specimendr),"\",1)
	..i SPECDesc'[("血") s ^DHCPECTDataEx("PatItemSort",iARCIMDR)=OtherPatItemID
	w "OVER"
}

// d ##class(web.DHCPE.TempTools).SetIMPOrderGlobal()

ClassMethod SetIMPOrderGlobal()
{
	//ARC_ItemCat
	k ^renzwangImportStationOrder
	s ^renzwangImportStationOrder("10","ArcCatDetail","LIS")="32,RF_LIS^34,RF_LIS^35,RF_LIS^36,RF_LIS^37,RF_LIS^38,RF_LIS^39,RF_LIS^40,RF_LIS^142,RF_LIS^143,RF_LIS"
	s ^renzwangImportStationOrder("11","ArcCatDetail","RIS")="20,RF_RIS"
	s ^renzwangImportStationOrder("12","ArcCatDetail","RIS")="22,RF_RIS"
	s ^renzwangImportStationOrder("13","ArcCatDetail","RIS")="29,RF_RIS"
	s ^renzwangImportStationOrder("14","ArcCatDetail","RIS")="16,RF_RIS^17,RF_RIS" //^49,RF_RIS"
	s ^renzwangImportStationOrder("15","ArcCatDetail","RIS")="18,RF_RIS"
	s ^renzwangImportStationOrder("16","ArcCatDetail","RIS")="7,RF_RIS"
	s ^renzwangImportStationOrder("17","ArcCatDetail","RIS")="27,RF_RIS" //^127,RF_RIS"
	//s ^renzwangImportStationOrder("18","ArcCatDetail","RIS")="40,RF_RIS"
	s ^renzwangImportStationOrder("19","ArcCatDetail","RIS")="21,RF_RIS"
	//s ^renzwangImportStationOrder("20","ArcCatDetail","RIS")="117,RF_RIS"
	s ^renzwangImportStationOrder("21","ArcCatDetail","RIS")="25,RF_RIS"
}

// d ##class(web.DHCPE.TempTools).Test()

ClassMethod Test()
{
	s STRowId=25
	s Sub=$o(^DHCPEST(STRowId,"O",0))
 	q:Sub=""
 	s ArcimRowId=$P(^DHCPEST(STRowId,"O",Sub),"^",1)
 	
 	s ODSub=0
 	f  s ODSub=$O(^DHCPEST(STRowId,"OD",ODSub)) q:ODSub=""  d
 	.s DetailRowId=STRowId_"||"_ODSub
 	.s Sequence=+$p(^DHCPEST(STRowId,"OD",ODSub),"^",11)
 	.s Required="N"
 	.s Cascade="",ParentDR=""
 	.&SQL(INSERT INTO DHC_PE_OrderDetailRelate(
 			ODR_ARCIM_DR,ODR_OD_DR,ODR_Sequence,ODR_Required,ODR_Cascade,ODR_Parent_DR
 		) VALUES (:ArcimRowId,:DetailRowId,:Sequence,:Required,:Cascade,:ParentDR))
	
	
	
	q
	&SQL(update sqluser.DHC_PE_PreIADM set PIADM_UpdateDate=PIADM_UpdateDate-1)
}

// d ##class(web.DHCPE.TempTools).ImportDetail()

ClassMethod ImportDetail(StationID)
{
	;s StationID="9"
	s Sub=0
	f  s Sub=$o(^DHCPEST(StationID,"O",Sub)) q:Sub=""  d
	.s ARCIM=$p(^DHCPEST(StationID,"O",Sub),"^",1)
	.q:ARCIM=""
	.q:$L(ARCIM,"||")<2
	.q:$D(^DHCPEODR(0,"ARCIM",ARCIM))
	.s ARCIMDesc=$P($G(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1)),"^",2)
	.s ARCIMDesc=$ZCVT(ARCIMDesc,"U")_"检查结果"
	.s ODDetail=""
	.&SQL(select OD_RowId into :ODDetail from sqluser.DHC_PE_Orderdetail where OD_Desc=:ARCIMDesc)
	.&SQL(insert into sqluser.DHC_PE_OrderDetailRelate (ODR_ARCIM_DR,ODR_OD_DR,ODR_Sequence,ODR_Required) values (:ARCIM,:ODDetail,'1','Y'))
}

ClassMethod IsNormal(ItemID, ItemValue, sex, StationID As %String = "") As %String
{
	Quit:(($g(ItemID)="")||($g(ItemValue)="")) 1
	Set Normal=0
	Set ResultFormat=""
	s HospCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	i (ItemValue="NEGATIVE")&&(HospCode="SHHS") s ItemValue="阴性"
	Set namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	Set LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	Set CurStation=+ItemID
	s:StationID'="" CurStation=StationID
	Set NormalStr=##class(web.DHCPE.ResultEdit).GetNormal(ItemID, sex, "",StationID)
	w "NoramlStr:"_NormalStr,!
	If LabStation'=CurStation Do
	.Set ItemType=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",2)
	.If (ItemType="N")||(ItemType="C") Do
	..Set Min=$p(NormalStr,"-",1)
	..Set Max=$p(NormalStr,"-",2)
	..If (ItemValue>=Min)&&(ItemValue<=Max) Set Normal=1
	.Else  Do
	..If NormalStr=ItemValue Set Normal=1
	..//If (ItemValue="未检")||(ItemValue="拒检") Set Normal=1
	..If ItemType="T" Set Normal=0
	Else  Do
	.Set CTTCCode=$p($G(^DHCPEST(+ItemID,"OD",$p(ItemID,"||",2))),"^",10)
	.Set ResultFormat=$p($g(^[namespaceLab]TTAB("TC",CTTCCode)),"\",3)
	.w "ResultFormat:"_ResultFormat,!
	.If ResultFormat="X" Do
	..w "X:"_X,!
	..If NormalStr=ItemValue Set Normal=1
	..///尿常规正常值临时等马
	..If $o(^TTAB("TC",CTTCCode,4,""))'="" Do
	...Set Min=$p(NormalStr,"-",1)
	...Set Max=$p(NormalStr,"-",2)
	...If (ItemValue>=Min)&&(ItemValue<=Max) Set Normal=1
	..if (ItemValue)="-" Set Normal=1
	.If $e(ResultFormat,1)="N" Do
	..//Modified
	..i NormalStr["<" d
	...s NormalStr=$p(NormalStr,"<",2)
	...s EqualFlag=0
	...i NormalStr["=" d
	....s NormalStr=$p(NormalStr,"=",2)
	....s EqualFlag=1
	...s NormalStr=+NormalStr
	...s:(EqualFlag=1)&&(ItemValue<=NormalStr) Normal=1
	...s:(EqualFlag=0)&&(ItemValue<NormalStr) Normal=1
	..e  i NormalStr[">" d
	...s NormalStr=$p(NormalStr,">",2)
	...s EqualFlag=0
	...i NormalStr["=" d
	....s NormalStr=$p(NormalStr,"=",2)
	....s EqualFlag=1
	...s NormalStr=+NormalStr
	...s:(EqualFlag=1)&&(ItemValue>=NormalStr) Normal=1
	...s:(EqualFlag=0)&&(ItemValue>NormalStr) Normal=1
	..e  d
	...Set Min=$p(NormalStr,"-",1)
	...Set Max=$p(NormalStr,"-",2)
	...If (ItemValue>=Min)&&(ItemValue<=Max) Set Normal=1
	.//End
	.If ResultFormat="S" Do
	..Set CTTCTCode=""
	..Set ResultDesc=""
	..Set NotNormal=""
	..For  Set CTTCTCode=$o(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode)) Quit:((CTTCTCode="")||(Normal=1))  Do
	...Set NotNormal=$p(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode),"\",1)
	...Set Format=$p(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode),"\",3)
	...Set ResultDesc=^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode,1)
	...If (ResultDesc=ItemValue)&(NotNormal="A") Set Normal=0
	...If ((ResultDesc=ItemValue)&(NotNormal'="A")) Set Normal=1

	Quit:($g(ItemType)'="T")&(NormalStr="")&(ResultFormat="") 1

	Quit Normal
}

// w ##class(web.DHCPE.TempTools).UpdateReport()

ClassMethod UpdateReport()
{
	TSTART
	s Parref="192"
	s SubRowID="192||4"
	&SQL(delete from DHC_PE_UserReportPayMode where rpm_rowid=:SubRowID)
	TROLLBACK:SQLCODE'=0
	q:SQLCODE'=0 "错误"_SQLCODE
	s Amount=135867.54
	&SQL(update DHC_PE_UserReport set rp_rcptsum=rp_rcptsum-:Amount,rp_normalsum=rp_normalsum-:Amount,rp_othersum=rp_othersum-:Amount where rp_rowid=:Parref)
	TROLLBACK:SQLCODE'=0
	q:SQLCODE'=0 "错误"_SQLCODE
	TCOMMIT
	q "完成"
}

// d ##class(web.DHCPE.TempTools).UpdateBaseInfo()

ClassMethod UpdateBaseInfo(SourceRegNo As %String = "", ToRegNo As %String = "")
{
	s SQLCODE=0
	q:(SourceRegNo="")||(ToRegNo="") SQLCODE
	s sourceBaseId=$o(^DHCPEPREIBI(0,"PAPMINo",SourceRegNo,0))
	s toBaseId=$o(^DHCPEPREIBI(0,"PAPMINo",ToRegNo,0))
	i sourceBaseId'="" d
	.i toBaseId="" d
	..&sql(update DHC_PE_PreIBaseInfo set PIBI_PAPMINo=:ToRegNo where PIBI_RowId=:sourceBaseId)
	.e  d
	..&sql(update DHC_PE_PreIADM set PIADM_PIBI_DR=:toBaseId where PIADM_PIBI_DR=:sourceBaseId)
	..i SQLCODE=100 s SQLCODE=0
	i SQLCODE'=0
	{
		q "更新体检信息错误"
	}
	q ""
}

/*
把以上方法拷贝到web.DHCPE.TempTools这个类里面
在Terminal下的websource下执行
w ##class(web.DHCPE.TempTools).TestWrite(58,0,1)
*/
ClassMethod TestWrite(invprtid, isReprint, AllRefund)
{
	s a="aaaa"
	s val=$S(%request.Get("PEDate")="":$zd(+$H-10,1),1:%request.Get("PEDate"))
	q val
}

// d ##class(web.DHCPE.TempTools).UpdateComponentJS("DHCPE")

ClassMethod UpdateComponentJS(ComponentNamePrefix)
{
	/*
	s Name="DHCPE"
	f  s Name=$O(^websys.ComponentI("UniqueNameIndex",Name)) q:(Name="")||(Name'["DHCPE")  d
	.w Name,!
	q */
	new rset,sql,ComponentName,ComponentNames,ComponentID
	Set rset = ##class(%ResultSet).%New()
	set sql="SELECT Name FROM websys.Component WHERE Name like '"_ComponentNamePrefix_"%'"
 	Do rset.Prepare(sql)
 	Do rset.Execute()
 	set ComponentNames=""
 	While (rset.Next(.sc)) // go to the next row of the result set
 	{
 		If ($SYSTEM.Status.IsOK(sc)) // check if this succeeded without errors
 		{
 			set ComponentName=rset.Data("Name")
 			s ComponentName=$ZCVT(ComponentName,"U")
 			s ComponentName=##class(web.DHCPE.DHCPECommon).Replace(ComponentName,".","")
 			s ID=$O(^websys.ComponentI("UniqueNameIndex",ComponentName,0))
 			s OJS=""
 			&sql(select OtherScripts into :OJS from websys.Component where id=:ID)
 			s OJS=##class(web.DHCPE.DHCPECommon).Replace(OJS,".DHCInsuPort.js",",DHCInsuPort.js")
 			s Date=+$H
 			s Time=$p($H,",",2)
 			&sql(update websys.Component set OtherScripts=:OJS,LastUpdateDate=:Date,LastUpdateTime=:Time where id=:ID)
 			i ComponentName=$ZCVT("DHCPEPreItemList_QrySet","U") w OJS_"^"_ID_"^"_SQLCODE
 			
 		}
 		Else // if there was an error, break out of the While loop
 		{
	        w "err"
	        
 			Quit
 		}
 	}
 	If $SYSTEM.Status.IsError(sc) // if there was an error, process that
 	{
 		Kill ^DHCPEComponent(ComponentName)
 	}   
	
	Quit "Export Over"
}

ClassMethod ImpOrdSets()
{
	
	...S PLIST(2)=OrdSetCode,PLIST(4)="Y",PLIST(6)=OrdSetDesc,PLIST(16)=OrdSetCatDr,PLIST(17)=OrdSetCatSubDr,PLIST(25)=+$H
 ...&SQL(INSERT INTO SQLUser.ARC_OrdSets VALUES :PLIST())
}

// d ##class(web.DHCPE.TempTools).SetStationTemplate(51)

ClassMethod SetStationTemplate(StationID)
{
	// d ##class(web.DHCPE.TempTools).SetStationTemplate(50,6)

	s id=0
	f  s id=$O(^DHCPEST(StationID,"O",id)) q:id=""  d
	.s CurData=$g(^DHCPEST(StationID,"O",id))
	.// 医嘱编码 医嘱名称
	.s iARCIMDR=$p(CurData,"^",1)
	.Q:(""=iARCIMDR)
	.//d ##class(web.DHCPE.TransOrderDetail).Main(iARCIMDR)
	.s ^DHCPECTDataEx("DHCPEStationOrder","RequestPrintType",iARCIMDR)="1"
	.//q:$G(^DHCPECTDataEx("DHCPEStationOrder","TempName",iARCIMDR))'=""
	.//s ^DHCPECTDataEx("DHCPEStationOrder","TempName",iARCIMDR)=Template
	w "OVER"
}

// d ##class(web.DHCPE.TempTools).setTemplate()

ClassMethod setTemplate()
{
	d ..SetStationTemplate(50,"DHCRisBill_Xray")
	d ..SetStationTemplate(51,"DHCRisBill_CS")
	d ..SetStationTemplate(52,"DHCRisBill_xd")
	d ..SetStationTemplate(53,"DHCRisBill_CT1")
	d ..SetStationTemplate(54,"DHCRisBill_MRI")
	d ..SetStationTemplate(55,"DHCRisBill_NJ")
	d ..SetStationTemplate(56,"DHCRisBill_ND")
	//d ..SetStationTemplate(57,"DHCRisBill_CS")
	d ..SetStationTemplate(58,"DHCRisBill_bl")
	//d ..SetStationTemplate(59,"DHCRisBill_CT1")
	d ..SetStationTemplate(60,"DHCRisBill_JDT")
	//d ..SetStationTemplate(61,"DHCRisBill_NJ")
}

// d ##class(web.DHCPE.TempTools).UpdateSpec()

ClassMethod UpdateSpec()
{
	//s Spec="SP02"
	k ^DHCPESpecTZTemp
	s id=0
	f  s id=$O(^DHCPECRMO(id)) q:id=""  d
	.s oeord=$P(^DHCPECRMO(id),"^",1)
	.q:oeord=""
	.s labno=$p($G(^OEORD(+oeord,"I",$P(oeord,"||",2),3)),"^",20)
	.q:labno=""
	.s stat=$p($G(^OEORD(+oeord,"I",$P(oeord,"||",2),1)),"^",13)
	.q:stat=4
	.i $D(^DHCPESpecTZTemp(labno)) d
	..s oneLabno="a"_labno
	..//w oneLabno,!
	..&SQL(update sqluser.OE_OrdItem set OEORI_LabEpisodeNo=:oneLabno where OEORI_RowId=:oeord)
	.s ^DHCPESpecTZTemp(labno)=$G(^DHCPESpecTZTemp(labno))+1
	.;s ^DHCPESpecInsertTemp(oeord)=Spec
}

// d ##class(web.DHCPE.TempTools).setEDLoc(238)

ClassMethod setEDLoc(loc)
{
	s EDRowID=0
	f  s EDRowID=$O(^DHCPEED(EDRowID)) q:EDRowID=""  d
	.&SQL(insert into DHC_PE_EDLoc (EDL_ParRef,EDL_Loc_DR) values (:EDRowID,:loc))
}

/// d ##class(web.DHCPE.TempTools).GetPatNameByRegNo(RegNo)
ClassMethod GetPatNameByRegNo(RegNo)
{
 
	s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	Set PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	Quit:PIBI=""
	s PatName=$p(^DHCPEPreIBI(PIBI),"^",2)
	q PatName
}

/// d ##class(web.DHCPE.TempTools).GetStatusByRegNo(RegNo)
ClassMethod GetStatusByRegNo(RegNo)
{
	s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	Set PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	Quit:PIBI="" ""
	s PIADM=""
	s CurStatus=""
	for  Set PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,""),-1) q:(PIADM="")||(CurStatus'="")  d
	.s Status=$p(^DHCPEPreIADM(PIADM),"^",8)
	.q:Status="CANCELPE"
	.s CurStatus=Status
	q CurStatus
}

/// add by lxl 20121123
ClassMethod GetPositionByRegNo(RegNo)
{
 
	s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	Set PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	Quit:PIBI=""
	s Position=$p(^DHCPEPreIBI(PIBI),"^",11)
	q Position
}

/// w ##class(web.DHCPE.TempTools).GetPAADMByRegNo(19316)
ClassMethod GetPAADMByRegNo(RegNo)
{
 
	s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	Set PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	Quit:PIBI=""
	s PIADM=""
	s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM))
	q:PIADM=""
	s IADM=""
	s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,IADM))
	q:IADM=""
	s PAADM=$P($G(^DHCPEIADM(IADM)),"^",1)
	
	q PAADM
}

ClassMethod DeleteNoUserItem()
{
	
	s i=0
	s ItemID=""
	f  s ItemID=$O(^TempDHCPEUseItem2(ItemID)) q:ItemID=""  d
	.s ItemCode=$P(^ARCIM(+ItemID,1,1),"^",1)
	.s ItemDesc=$P(^ARCIM(+ItemID,1,1),"^",2)
	.w ItemCode_$C(9)_ItemDesc,!
	.s i=i+1
	w i,!
	;d ##class(web.DHCPE.TempTools).DeleteNoUserItem()
	;20478--20544
	
	q 
	/*s i=0
	s ID=20477
	f  s ID=$O(^ARCOS(ID)) q:(ID="")||(ID>20544)  d
	.;ARC_OrdSetDate
	.s DateSub=0
	.f  s DateSub=$O(^ARCOS(ID,"DATE",DateSub)) q:DateSub=""  d
	..s ItemSub=0
	..f  s ItemSub=$O(^ARCOS(ID,"DATE",DateSub,"ITM",ItemSub)) q:ItemSub=""  d
	...s ItemID=$P(^ARCOS(ID,"DATE",DateSub,"ITM",ItemSub),"^",1)
	...q:$D(^TempDHCPEUseItem2(ItemID))
	...s ^TempDHCPEUseItem2(ItemID)=""
	...s i=i+1
	w i,!
	q 
	*/
	s i=0
	s StationID=0
	f  s StationID=$O(^DHCPEST(StationID)) q:(StationID>20)||(StationID="")  d
	.s Sub=0
	.f  s Sub=$O(^DHCPEST(StationID,"O",Sub)) q:(Sub="")  d
	..s ItemID=$P(^DHCPEST(StationID,"O",Sub),"^",1)
	..;q:$D(^TempDHCPEUseItem2(ItemID))
	..k ^TempDHCPEUseItem2(ItemID)
	..s i=i+1
	..;s ID=StationID_"||"_Sub
	..;&sql(Delete From Sqluser.DHC_PE_StationOrder where STORD_RowId=:ID)
	..;&sql(Delete From Sqluser.DHC_PE_OrderDetailRelate where ODR_ARCIM_DR=:ItemID)
	w i,!
}

ClassMethod CopyODStandard(SourceDetalCode, ToDetailCode)
{
	;d ##class(web.DHCPE.TempTools).CopyODStandard("09242","09303")
	s SouceSTID=$O(^DHCPEST(0,"OD_Code",SourceDetalCode,0))
	q:SouceSTID="" "源记录不存在"
	s SourceSub=$O(^DHCPEST(0,"OD_Code",SourceDetalCode,SouceSTID,0))
	s ToSTID=$O(^DHCPEST(0,"OD_Code",ToDetailCode,0))
	q:ToSTID="" "目标记录不存在"
	s ToSub=$O(^DHCPEST(0,"OD_Code",ToDetailCode,ToSTID,0))
	s ODSub=0
	f  s ODSub=$O(^DHCPEST(SouceSTID,"OD",SourceSub,"ODS",ODSub)) q:ODSub=""  d
	.k PLIST
	.s ID=SouceSTID_"||"_SourceSub_"||"_ODSub
	.&sql(select * into :PLIST() from sqluser.DHC_PE_ODStandard where ODS_rowid=:ID)
	.k PLIST(0)
	.k PLIST(1)
	.k PLIST(2)
	.s PLIST(0)=ToSTID_"||"_ToSub
	.&SQL(insert into sqluser.DHC_PE_ODStandard values :PLIST())
	.w SQLCODE,!
	.q:SQLCODE'=0
	.s NewID=%ROWID
	.s ^DHCPECTDataEx("BaseData","ODStandard","ODS_Summary",NewID)="Y"
}

ClassMethod MoveLocInfo(SourceLocID, ToLocID, killFlag As %String = "0")
{
	//d ##class(web.DHCPE.TempTools).MoveLocInfo("1542","53","0")
	q:(SourceLocID="")||(ToLocID="") "科室不能为空"
	s SQLCODE=0
	//Setting设置
	s Node1=""
	f  s Node1=$O(^DHCPESetting(Node1)) q:Node1=""  d
	.s Node2=""
	.f  s Node2=$O(^DHCPESetting(Node1,Node2)) q:Node2=""  d
	..s Node3=""
	..f  s Node3=$O(^DHCPESetting(Node1,Node2,Node3)) q:Node3=""  d
	...q:Node3'=SourceLocID
	...s ^DHCPESetting(Node1,Node2,ToLocID)=^DHCPESetting(Node1,Node2,Node3)
	...k:killFlag=1 ^DHCPESetting(Node1,Node2,Node3)
	//导检单类别中的注意信息
	//^DHCPECTDataEx("PatItem",RowID,"Place",loc)=$P(Strs,"^",5)
	s PatItemID=""
	f  s PatItemID=$O(^DHCPECTDataEx("PatItem",PatItemID)) q:PatItemID=""  d
	.s ^DHCPECTDataEx("PatItem",PatItemID,"Place",ToLocID)=$G(^DHCPECTDataEx("PatItem",PatItemID,"Place",SourceLocID))
	.k:killFlag=1 ^DHCPECTDataEx("PatItem",PatItemID,"Place",SourceLocID)
	//医生权限及登录科室
	s UserID=""
	f  s UserID=$O(^DHCPECFDataEx("ChartAssign",UserID)) q:(UserID="")||(SQLCODE<0)  d
	.q:'$D(^DHCPECFDataEx("ChartAssign",UserID,SourceLocID))
	.m ^DHCPECFDataEx("ChartAssign",UserID,ToLocID)=^DHCPECFDataEx("ChartAssign",UserID,SourceLocID)
	.i killFlag=1 d
	..k ^DHCPECFDataEx("ChartAssign",UserID,SourceLocID)
	..&SQL(update Sqluser.SS_UserOtherLogonLoc set othll_ctloc_dr=:ToLocID where othll_ctloc_dr=:SourceLocID and OTHLL_ParRef=:UserID)
	..q:SQLCODE<0
	..&SQL(update Sqluser.ss_user set ssusr_defaultdept_dr=:ToLocID where ssusr_defaultdept_dr=:SourceLocID and SSUSR_RowId=:UserID)
	..q:SQLCODE<0
	q:SQLCODE<0 "更新医生权限错误"
	//医生建议
	if killFlag=1
	{
		&SQL(Update Sqluser.DHC_PE_EDLoc set EDL_Loc_DR=:ToLocID where EDL_Loc_DR=:SourceLocID)
		q:SQLCODE<0 "更新建议科室错误"
	}
	else  ;重新生成一套建议数据
	{
		d ##class(web.DHCPE.Temp).ImportEXByLoc(SourceLocID,ToLocID)
	}
	//更新历史数据
	if killFlag=1
	{
		&SQL(Update Sqluser.DHC_PE_PreIADM set PIADM_DepCode_DR=:ToLocID where PIADM_DepCode_DR=:SourceLocID)
		q:SQLCODE<0 "更新个人预约记录错误"
		&SQL(Update Sqluser.DHC_PE_PreGADM set PGADM_DepCode_DR=:ToLocID where PGADM_DepCode_DR=:SourceLocID)
		q:SQLCODE<0 "更新团体预约记录错误"
		&SQL(Update Sqluser.PA_Adm set PAADM_DepCode_DR=:ToLocID where PAADM_DepCode_DR=:SourceLocID and PAADM_Type='H')
		q:SQLCODE<0 "更新就诊记录错误"
		&SQL(Update Sqluser.DHC_PE_AdvancePayment set AP_1=:ToLocID where AP_1=:SourceLocID)
		q:SQLCODE<0 "更新预缴金表错误"
		&SQL(Update Sqluser.DHC_PE_APAmountChange set APAC_2=:ToLocID where APAC_2=:SourceLocID)
		q:SQLCODE<0 "更新预缴金明细表错误"
		
	}
	q "OVER"
}

ClassMethod CheckInfo()
{
	s UserID=""
	f  s UserID=$O(^SSUSR("SSUSR",UserID)) q:UserID=""  d
	.
}

ClassMethod ExportDocInfo()
{
	;d ##class(web.DHCPE.TempTools).ExportDocInfo()
	s UserID=""
	f  s UserID=$O(^DHCPECFDataEx("ChartAssign",UserID)) q:UserID=""  d //,LocID,GroupID,"Detail",ChartId))
	.s LocID=""
	.f  s LocID=$O(^DHCPECFDataEx("ChartAssign",UserID,LocID)) q:LocID=""  d
	..q:LocID="53"
	..s GroupID=""
	..f  s GroupID=$O(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID)) q:GroupID=""  d
	...s ChartId=""
	...f  s ChartId=$O(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Write",ChartId)) q:ChartId=""  d
	....s WriteFlag=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Write",ChartId))
	....q:WriteFlag'="Y"
	....s UserCode=$P(^SSU("SSUSR",UserID),"^",1)
	....s UserDesc=$P(^SSU("SSUSR",UserID),"^",2)
	....s LocDesc=$P(^CTLOC(LocID),"^",2)
	....i ChartId="NULL" d
	.....s ChartDesc="总检"
	....e  d
	.....s ChartDesc=$P(^DHCPEST(ChartId),"^",2)
	....w UserCode_"^"_UserDesc_"^"_LocDesc_"^"_ChartDesc,!
	q
	s ChartId=0
 	f  s ChartId=$O(^DHCPEST(ChartId)) q:ChartId=""  d
 	.s Chart=$P(^DHCPEST(ChartId),"^",2)
 	.Set UseFlag=+$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Detail",ChartId))
	.Set WriteFlag=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Write",ChartId))
	.;w !,WriteFlag
	.q:(OpenType="Self")&&(WriteFlag'="Y")
	.Set Default=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"Default",ChartId))
	.s WriteWay=$G(^DHCPECFDataEx("ChartAssign",UserID,LocID,GroupID,"WriteWay",ChartId))
}

ClassMethod DeleteErrItem()
{
	;d ##class(web.DHCPE.TempTools).DeleteErrItem()
	s i=0
	s ID=107529
	f  s ID=$O(^DHCPEPreIADM(ID)) q:ID=""  d
	.s ItemSub=0
	.f  s ItemSub=$O(^DHCPEPreIADM(ID,"ORDITEM",ItemSub)) q:ItemSub=""  d
	..s ItemMastID=$P($G(^DHCPEPreIADM(ID,"ORDITEM",ItemSub)),"^",1)
	..i ItemMastID="" d
	...k ^DHCPEPreIADM(ID,"ORDITEM",ItemSub)
	...s i=i+1
	w i,!
}

Storage Default
{
<Data name="TempToolsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.TempToolsD</DataLocation>
<DefaultData>TempToolsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCP.TempToolsD</IdLocation>
<IndexLocation>^web.DHCP.TempToolsI</IndexLocation>
<StreamLocation>^web.DHCP.TempToolsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
