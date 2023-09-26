/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 医生站交班本业务类
Class DHCDoc.PW.BS.NMain Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 自动存储当前班次
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NMain).SavePW("1","","12175"_$c(1,1),"1")
ClassMethod SavePW(ID = "", InAdd As %String, InEdit = "", IsSync = "") As %String
{
	
	s ^QP("SavePW")=$lb(ID,InAdd,InEdit,IsSync)
	s CDate=+$h
	s CTime=$P($H,",",2)
	i ID = "" {
		s LocID=$P(InAdd,$C(1),1)
		s BCDate=$P(InAdd,$C(1),2)
		s BCCode=$P(InAdd,$C(1),3)
		s UserID=$P(InAdd,$C(1),4)
		s HospID=$P(InAdd,$C(1),5)
		s SubmitNote=$P(InAdd,$C(1),6)
		s AccpetNote=$P(InAdd,$C(1),7)
		D Lock
		d ##class(DHCDoc.PW.BS.DataFunc).GetLocItemSummary(LocID, BCDate, BCDate, CTime, "", UserID, BCCode,.MDList,1)
		s InXML=##class(DHCDoc.PW.COM.Method).BuildXML(.MDList)
		TS
		s SaveOBJ = ##class(User.DHCDocPassWorkNMain).%New()
		d SaveOBJ.MAddUserSetObjectId(UserID)
		;d SaveOBJ.MSubmitUserSetObjectId(UserID)	;默认交班人为保存人
		d SaveOBJ.MLocSetObjectId(LocID)
		d SaveOBJ.MHospSetObjectId(HospID)
		s SaveOBJ.MAddDate=CDate
		S SaveOBJ.MAddTime=CTime
		S SaveOBJ.MUpdateDate=CDate
		S SaveOBJ.MUpdateTime=CTime
		s SaveOBJ.MBCCode=BCCode
		s BCInfo=##class(DHCDoc.PW.CFG.BCTime).GetBCInfoByCode(LocID,BCCode)
		s SaveOBJ.MBCName=$lg(BCInfo,3)
		s SaveOBJ.MBCSTime=$lg(BCInfo,4)
		s SaveOBJ.MBCETime=$lg(BCInfo,5)
		s SaveOBJ.MBCNextDay=$lg(BCInfo,6)
		s SaveOBJ.MBCSeqno=$lg(BCInfo,9)
		s SaveOBJ.MAccpetNote=AccpetNote
		s SaveOBJ.MSubmitNote=SubmitNote
		s SaveOBJ.MXML=InXML
		s BCDate=##class(websys.Conversions).DateHtmlToLogical(BCDate)
		s SaveOBJ.MBCDate=BCDate
		
		s sc = SaveOBJ.%Save()
		If $$$ISERR(sc) {
			//d $system.OBJ.DisplayError(sc)
			D UNLock 
			TRO
			Quit "-1^保存主表失败！"
		}
	
		s mRtn=##class(DHCDoc.PW.BS.NSub).SavePWSub(SaveOBJ.%Id(),LocID,BCDate,BCCode,UserID)
		i +mRtn'=1 {
			D UNLock
			TRO
			Quit "-1^保存明细失败！"
		}
		TC
		D UNLock
		
		q 1_"^"
	} else {
		s UserID=$P(InEdit,$C(1),1)
		s SubmitNote=$P(InEdit,$C(1),2)
		s AccpetNote=$P(InEdit,$C(1),3)
		s BCDate=$lg(^User.DHCDocPassWorkNMainD(ID),3)
		s LocID=$lg(^User.DHCDocPassWorkNMainD(ID),2)
		s BCCode=$lg(^User.DHCDocPassWorkNMainD(ID),9)
		s OldXML=$lg(^User.DHCDocPassWorkNMainD(ID),7)
		TS
		s SaveOBJ = ##class(User.DHCDocPassWorkNMain).%OpenId(ID)
		d SaveOBJ.MUpdateUserSetObjectId(UserID)
		S SaveOBJ.MUpdateDate=CDate
		S SaveOBJ.MUpdateTime=CTime
		/*i IsSync=1 {
			//旧规则：1.若有新增类型的患者，将xml里面的数值+1，否则不变
			D Lock
			d ##class(DHCDoc.PW.BS.DataFunc).GetLocItemSummary(LocID, BCDate, BCDate, "", "", UserID, BCCode,.MDList,1)
			s mRtn=##class(DHCDoc.PW.BS.NSub).SavePWSub(ID,LocID,BCDate,BCCode,UserID)
			i +mRtn'=1 {
				D UNLock
				TRO
				Quit "-1^保存明细失败！"
			}
			
			s Type="",NewXML=""
			f  s Type=$o(^||BS.PW.NMain.Sync(ID,Type)) Q:Type=""  D
			.s num=^||BS.PW.NMain.Sync(ID,Type)
			.i NewXML="" s NewXML=##class(DHCDoc.PW.BS.NMain).OperateXML(ID,Type,"+",num)
			.e  s NewXML=##class(DHCDoc.PW.BS.NMain).OperateXML(ID,Type,"+",num,NewXML)
			I NewXML="" S NewXML=OldXML
			s SaveOBJ.MXML=NewXML
		}*/
		i IsSync=1 {
			//新规则：删除所有数据，只保存交班内容
			D Lock
			//获取有交班的记录存储到Global：^||BS.PW.NSub.Sync
			K ^||BS.PW.NSub.Sync("HasSubmit")
			s HasNum=##class(DHCDoc.PW.BS.NSub).GetHasSubmitRecord(ID)
			//删除数据
			s rtn=##class(DHCDoc.PW.BS.NSub).DeleteNSub(ID)
			i +rtn'=0 {
				D UNLock
				TRO
				Quit "-1^删除子表记录失败！"
			}
			s rtn=##class(DHCDoc.PW.BS.NSubExt).DeleteNSubExt(ID)
			i +rtn'=0 {
				D UNLock
				TRO
				Quit "-1^删除子表扩展记录失败！"
			}
			//获取实时数据
			d ##class(DHCDoc.PW.BS.DataFunc).GetLocItemSummary(LocID, BCDate, BCDate, "", "", UserID, BCCode,.MDList,1)
			s NewXML=##class(DHCDoc.PW.COM.Method).BuildXML(.MDList)
			s mRtn=##class(DHCDoc.PW.BS.NSub).SavePWSub(ID,LocID,BCDate,BCCode,UserID)
			i +mRtn'=1 {
				D UNLock
				TRO
				Quit "-1^保存明细失败！"
			}
			//清楚Global
			K ^||BS.PW.NSub.Sync("HasSubmit")
			s SaveOBJ.MXML=NewXML
			
		} 
		else {
			s SaveOBJ.MSubmitNote=SubmitNote
			s SaveOBJ.MAccpetNote=AccpetNote
		}
		
		s sc = SaveOBJ.%Save()
		If $$$ISERR(sc) {
			i IsSync=1 	D UNLock
			TRO
			Quit "-1^更新主表失败！"
		}
		
		/*
		//旧规则：同步现有和出院约束
		i IsSync=1 {
			s Rtn=##class(DHCDoc.PW.BS.NSub).NowAndOutData(ID)
			if Rtn'=0 {
				D UNLock
				TRO
				Q "-1^同步现有和出院约束失败！"
			}
		}
		*/
		
		TC
			
		q 1_"^"
	}

	
	q 1_"^"

Lock
	k ^||BS.PW.NMain("RealCount",LocID)
	lock +^||BS.PW.NMain("RealCount",LocID,BCDate,BCCode)
	Q
UNLock
	lock -^||BS.PW.NMain("RealCount",LocID,BCDate,BCCode)
	Q
}

/// CTOR: QP
/// DATE: 2021-07-17
/// DESC: 补交
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.PW.BS.NMain).ReSubmit("D,M,N,S","2021-07-13"_$c(1)_"113"_$c(1)_"12175"_$c(1)_"2")
ClassMethod ReSubmit(BCCodeStr, InPara)
{
	Q:BCCodeStr="" "-1^参数为空"
	s ^QP("ReSubmit")=$LB(BCCodeStr,InPara)
	s BCDate=$P(InPara,$C(1),1)
	s LocID=$P(InPara,$C(1),2)
	s UserID=$P(InPara,$C(1),3)
	s HospID=$P(InPara,$C(1),4)
	s mRtn="1^"
	s BCDate=##class(websys.Conversions).DateHtmlToLogical(BCDate)
	i BCDate>+$H {
		Q "_1^只能补交小于当天的班次！"	
	}
	f i=1:1:$l(BCCodeStr,",") {
		s BCCode=$p(BCCodeStr,",",i)
		s InAdd=LocID_$C(1)_BCDate_$C(1)_BCCode_$C(1)_UserID_$C(1)_HospID
		s isAdd=..IsAdd("",InAdd)
		continue:+isAdd<0
		s mRtn=..SavePW("",InAdd,"")
		q:+mRtn<0
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-17
/// DESC: 判断能否添加
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSub).IsAdd("","1^1")
ClassMethod IsAdd(ID = "", InAdd) As %String
{
	s LocID=$P(InAdd,$C(1),1)
	s BCDate=$P(InAdd,$C(1),2)
	s BCCode=$P(InAdd,$C(1),3)
	s UserID=$P(InAdd,$C(1),4)
	s HospID=$P(InAdd,$C(1),5)
	s BCDate=##class(websys.Conversions).DateHtmlToLogical(BCDate)
	i ID="" {
		i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",LocID,BCDate,BCCode)) {
			Q "-1^班次已存在！"
		}
	} else {
		
	}
	
	Q 0
}

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 更新XML
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.PW.BS.NMain).UpdateXML()
ClassMethod UpdateXML(NID, XML)
{
	Q:NID=""||XML="" 0
	&SQL(UPDATE SQLUser.DHCDocPassWorkNMain SET M_XML=:XML WHERE ID=:NID)
	
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 更新XML
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.PW.BS.NMain).OperateXML(1,"CritiNum,DeathNum","+",1)
ClassMethod OperateXML(NID, PTypeS, Operate, Num, OldXML = "")
{
	i OldXML="" s OldXML=$lg(^User.DHCDocPassWorkNMainD(NID),7) 
	Q:PTypeS="" OldXML
	d ##class(DHCDoc.PW.COM.Method).ParseXML(OldXML,.TList)
	f i=1:1:$l(PTypeS,",") {
		s node=$p(PTypeS,",",i)
		i Operate="+" {
			i '$d(TList(node)) {
				s TList(node)=Num
			} else {
				s TList(node)=TList(node)+Num
			}
		} 
		i Operate="-" {
			i '$d(TList(node)) {
				//不存在这种情况
			} else {
				s TList(node)=TList(node)-Num
			}
		} 
	}
	s mRtn=""
	s node=""
	f  s node=$o(TList(node)) q:node=""  d
	.s val=TList(node)
	.s rec=node_":"_val
	.i mRtn="" s mRtn=rec
	.e  s mRtn=mRtn_"^"_rec
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 交班
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NMain).SumbitPW("3","12175"_$c(1,1))
ClassMethod SumbitPW(NID = "", InPara = "") As %String
{
	s mRtn=0
	s ^QP("SumbitPW")=$lb(NID,InPara)
	Q:(NID="")||(InPara="") "-1^参数为空"
	s UserId=$p(InPara,$C(1),1)
	s SubmitUser=$p(InPara,$C(1),2)
	s AcceptUser=$p(InPara,$C(1),3)
	s CurDate=$p($h,",",1),CurTime=$p($h,",",2)
	s (ADate,SDate)=CurDate
	s (ATime,STime)=CurTime
	i AcceptUser="" {
		s ADate=""
		s ATime=""
	}
	i SubmitUser="" {
		s SDate=""
		s STime=""
	}

	&SQL(UPDATE SQLUser.DHCDocPassWorkNMain(M_SubmitUser,M_SubmitDate,M_SubmitTime,M_UpdateUser,M_UpdateDate,M_UpdateTime,M_AcceptUser,M_AccpetDate,M_AccpetTime) 
			VALUES(:SubmitUser,:SDate,:STime,:UserId,:CurDate,:CurTime,:AcceptUser,:ADate,:ATime)
			WHERE ID=:NID)
	
	i SQLCODE {
		Q "-1^保存失败，SQLCODE为："_SQLCODE
	}
	
	Q 1_"^"
}

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 交班
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NMain).SumbitPW("3","12175"_$c(1,1))
ClassMethod FixBC(NID = "", InPara = "") As %String
{
	s mRtn=0
	Q:(NID="")||(InPara="") "-1^参数为空"
	s UserId=$p(InPara,$C(1),1)
	s STime=$p(InPara,$C(1),2)
	s ETime=$p(InPara,$C(1),3)
	s NextDay=$p(InPara,$C(1),4)
	s CurDate=$p($h,",",1),CurTime=$p($h,",",2)
	i STime'="" s STime = ..%ZTH(STime,2)
	i ETime'="" s ETime = ..%ZTH(ETime,2)
	
	&SQL(UPDATE SQLUser.DHCDocPassWorkNMain(M_BCSTime,M_BCETime,M_UpdateUser,M_UpdateDate,M_UpdateTime,M_BCNextDay) 
			VALUES(:STime,:ETime,:UserId,:CurDate,:CurTime,:NextDay)
			WHERE ID=:NID)
	
	i SQLCODE {
		Q "-1^保存失败，SQLCODE为："_SQLCODE
	}
	
	Q 1_"^"
}

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 得到病人类型
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NMain).GetPatTypeList(1)
ClassMethod GetTabList(MID, LocId) As %String
{
	s BPNum=""
	s langid=##class(DHCDoc.PW.COM.Method).%LanguageID()
	i MID="" s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocId)
	Q:MID="" ""
	s mRtn="["
	s Count=0
	f  s BPNum=$o(^User.DHCDocPassWorkBCPatTypeI("BPNum",BPNum)) Q:BPNum=""  D
	.s ch=""
	.f  s ch=$o(^User.DHCDocPassWorkBCPatTypeI("BPNum",BPNum,MID,ch)) Q:ch=""  D
	..s PName=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",ch),3)
	..s PCode=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",ch),2)
	..s PActive=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",ch),4)
	..s PURL=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",ch),7)
	..s PSelected=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",ch),8)
	..s PName= ##class(User.DHCDocPassWorkBCPatType).GetTranByDesc("BPDesc",PName,langid)
	..q:PActive'=1
	..s Count=Count+1   
	..s ClassName="tab"
	..i PSelected=1 s ClassName="tab selectedItem"
	..i PCode="ALL" s PCode=""
	..s record="{""code"":"""_PCode_""",""name"":"""_PName_""",""ClassName"":"""_ClassName_""",""url"":"""_PURL_"""}"
	..i mRtn="[" s mRtn=mRtn_record
	..e  s mRtn=mRtn_","_record
	s mRtn=mRtn_"]"
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 得到病人类型
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NMain).GetPatTypeList(1)
ClassMethod GetPatTypeList(MID, LocId, ByRef PTList, ByRef MDList) As %String
{
	s BPNum=""
	i MID="" s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocId)
	Q:MID="" ""
	s mRtn="["
	s Count=0
	f  s BPNum=$o(^User.DHCDocPassWorkBCPatTypeI("BPNum",BPNum)) Q:BPNum=""  D
	.s ch=""
	.f  s ch=$o(^User.DHCDocPassWorkBCPatTypeI("BPNum",BPNum,MID,ch)) Q:ch=""  D
	..s PName=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",ch),3)
	..s PCode=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",ch),2)
	..s PActive=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",ch),4)
	..s PURL=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",ch),7)
	..q:PActive'=1
	..q:PCode="ALL"
	..s Count=Count+1
	..s PTList(Count)=$lb(PName,PCode)
	..s PTList(Count,"Item"_Count)=$g(MDList(PCode))
	..;s upPCode=$$ALPHAUP^SSUTIL4(PCode)    
	..s record="{""code"":"""_PCode_""",""name"":"""_PName_""",""url"":"""_PURL_"""}"
	..i mRtn="[" s mRtn=mRtn_record
	..e  s mRtn=mRtn_","_record
	s mRtn=mRtn_"]"
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 得到病人类型
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NMain).GetPatTypeList(1)
ClassMethod GetPatTypeListNID(MID, LocId, XML, ByRef CList) As %String
{
	d ##class(DHCDoc.PW.COM.Method).ParseXML(XML,.XMList)
	s BPNum=""
	i MID="" s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocId)	
	s Count=0
	f  s BPNum=$o(^User.DHCDocPassWorkBCPatTypeI("BPNum",BPNum)) Q:BPNum=""  D
	.s ch=""
	.f  s ch=$o(^User.DHCDocPassWorkBCPatTypeI("BPNum",BPNum,MID,ch)) Q:ch=""  D
	..s PName=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",ch),3)
	..s PCode=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",ch),2)
	..s PActive=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",ch),4)
	..s PURL=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",ch),7)
	..q:PActive'=1
	..q:PCode="ALL"
	..s Count=Count+1
	..s CList(Count)=$lb(PName,PCode)
	..s CList(Count,"Item"_Count)=$g(XMList(PCode))
	
	Q 0
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 得到数据统计表格列
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NMain).GetColumns(113)
ClassMethod GetColumns(LocId)
{
	s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocId)
	d ..GetPatTypeList(MID,LocId,.PTList)
	s count=$o(PTList(""),-1)
	
	s mRtn="{""field"":""BCText"",""title"":""班次"",""width"":200}"
	s mRtn=mRtn_$C(1)_"{""field"":""status"",""title"":""状态"",""width"":100}"
	s id=""
	f  s id=$o(PTList(id)) q:id=""  d
	.s PName=$lg(PTList(id),1)
	.s PCode=$lg(PTList(id),2)
	.s PW=##class(DHCDoc.PW.CFG.BCPatType).GetWidthByCode(MID,PCode)
	.s DisplayCode="Item"_id
	.s record="{""field"":"""_DisplayCode_""",""title"":"""_PName_""",""width"":"_PW_"}"
	.s mRtn=mRtn_$C(1)_record
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 自动设置表格高度
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NMain).SetItemCountPanel("113","2021-07-13")
ClassMethod SetItemCountPanel(LocId, BCDate)
{
	
	s TotalBCNum=##class(DHCDoc.PW.COM.Method).GetBCTotalNum(LocId,BCDate)
	Q:TotalBCNum=0 "-1^请检查交班本配置！"
	i TotalBCNum=1 {
		s mRtn=80
	} elseif (TotalBCNum=2) {
		s mRtn=TotalBCNum*54
	} elseif (TotalBCNum=3) {
		s mRtn=TotalBCNum*48
	} elseif (TotalBCNum=4) {
		s mRtn=TotalBCNum*45
	} elseif (TotalBCNum=5)  {
		s mRtn=TotalBCNum*43
	} else {
		s mRtn=TotalBCNum*44
	}

	
	q "1^"_mRtn
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 得到实时数据
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NMain).GetRealData(113,"2021-07-14","1","TEST",.MDList)
ClassMethod GetRealData(LocId, BCDate, UserId, BCCode, ByRef MDList)
{
	s CTime=$p($h,",",2)
	d ##class(DHCDoc.PW.BS.DataFunc).GetLocItemSummary(LocId, BCDate, BCDate, CTime, "", UserId, BCCode,.MDList)
	b ;001
	/*
	s MDList("PreSum")=$p(mRtn,"^",1)
	s MDList("NowSum")=$p(mRtn,"^",2)
	s MDList("OutHospNum")=$p(mRtn,"^",3)
	s MDList("InHospNum")=$p(mRtn,"^",4)
	s MDList("OutWardNum")=$p(mRtn,"^",5)
	s MDList("InWardNum")=$p(mRtn,"^",6)
	s MDList("OperNum")=$p(mRtn,"^",7)
	s MDList("SeverityNum")=$p(mRtn,"^",8)
	s MDList("CritiNum")=$p(mRtn,"^",9)
	s MDList("DeathNum")=$p(mRtn,"^",10)
	*/
	
	q 0
}

/// CTOR: QP
/// DATE: 2021-07-15
/// DESC: 查询历史还是实时数据
/// IN  : 
/// OUT : 1实时，2历史
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NMain).GetRealData(113,"2021-07-14","1","TEST",.MDList)
ClassMethod IsNeedRealData(BCDate, DefaultDate)
{
	s mRtn=1
	s CDate=+$H
	i CDate=BCDate {
		s mRtn=1	
	} elseif BCDate<CDate {
		i BCDate=DefaultDate {
			s mRtn=1	
		} else {
			s mRtn=2
		}
	} else {
		//不可能，前台出错
		s mRtn=2
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 查询实时各项统计值
/// IN  : 
/// OUT : 
/// TABL: DHC_DocPassWorkBcs
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.BS.NMain","ItemCountQry","2021-08-26",113,12175,"TEST")
Query ItemCountQry(BCDate, LocId, UserId, InBCCode) As %Library.Query(ROWSPEC = "NID,MID,BCID,BCText,BCCode,BCName,status,Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16,Item17,Item18,Item19,Item20")
{
}

ClassMethod ItemCountQryExecute(ByRef qHandle As %Library.Binary, BCDate, LocId, UserId, InBCCode) As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocId)
	i MID="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s langid=##class(DHCDoc.PW.COM.Method).%LanguageID()
	s BCDate=##class(websys.Conversions).DateHtmlToLogical(BCDate)
	s DefaultStr=##class(DHCDoc.PW.COM.Method).GetDefaultDate(LocId)
	s DefaultDate=$p(DefaultStr,"^",1)
	s DefaultDate=##class(websys.Conversions).DateHtmlToLogical(DefaultDate)
	s NeedReal = ..IsNeedRealData(BCDate,DefaultDate)
	i NeedReal = 1 {
		/*k MDList,PTList
		d ..GetRealData(LocId,BCDate,UserId,InBCCode,.MDList)
		d ..GetPatTypeList(MID,LocId,.PTList,.MDList)
		s count=$o(PTList(""),-1)
		*/
		s NID=""
		;预留支持20个类型
		s (Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10)=""
		s (Item11,Item12,Item13,Item14,Item15,Item16,Item17,Item18,Item19,Item20)=""
		s seqno=""
		f  s seqno=$o(^User.DHCDocPassWorkBCTimeI("BCSeqno",seqno)) q:seqno=""  d
		.s sub="" 
		.f  s sub=$o(^User.DHCDocPassWorkBCTimeI("BCSeqno",seqno,MID,sub)) q:sub=""  d
		..s active=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub),8)
		..Q:active'=1
		..s BCCode=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub),2)
		..s BCName=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub),3)
		..s BCSTime=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub),4)
		..s BCETime=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub),5)
		..i BCSTime'="" s BCSTime=$zt(BCSTime,2)
		..i BCETime'="" s BCETime=$zt(BCETime,2)
		..;s BCName=##class(websys.Translation).Get("dhcdoc.passwork.nmain.csp",BCName)
		..s BCName= ##class(User.DHCDocPassWorkBCTime).GetTranByDesc("BCName",BCName,langid)
		..s BCText="<span class='radusBorder'>"_BCName_"</span>"_BCSTime_"~"_BCETime
		..s BCID=MID_"||"_sub
		..s status=""
		..s NID=##class(DHCDoc.PW.COM.Method).GetNID(LocId,BCDate,BCCode)
		..i NID="" d
		...k MDList,PTList
		...d ..GetRealData(LocId,BCDate,UserId,BCCode,.MDList)
		...d ..GetPatTypeList(MID,LocId,.PTList,.MDList)
		...;s status="<span class='c-no'>未保存</span>"
		...s status="<span class='c-no'>"_##class(websys.Translation).Get("dhcdoc.passwork.nmain.csp","未保存")_"</span>"
		...s Item1 = $g(PTList(1,"Item1")),Item2 = $g(PTList(2,"Item2")),Item3 = $g(PTList(3,"Item3"))
		...s Item4 = $g(PTList(4,"Item4")),Item5 = $g(PTList(5,"Item5")),Item6 = $g(PTList(6,"Item6"))
		...s Item7 = $g(PTList(7,"Item7")),Item8 = $g(PTList(8,"Item8")),Item9 = $g(PTList(9,"Item9"))
		...s Item10 = $g(PTList(10,"Item10")),Item11 = $g(PTList(11,"Item11")),Item12 = $g(PTList(12,"Item12"))
		...s Item13 = $g(PTList(13,"Item13")),Item14 = $g(PTList(14,"Item14")),Item15 = $g(PTList(15,"Item15"))
		...s Item16 = $g(PTList(16,"Item16")),Item17 = $g(PTList(17,"Item17")),Item18 = $g(PTList(18,"Item18"))
		...s Item19 = $g(PTList(19,"Item19")),Item20 = $g(PTList(20,"Item20"))
		..e  d
		...s status="<span class='c-ok'>已保存</span>"
		...s status="<span class='c-ok'>"_##class(websys.Translation).Get("dhcdoc.passwork.nmain.csp","已保存")_"</span>"
		...s BCSTime=$lg(^User.DHCDocPassWorkNMainD(NID),11)
		...s BCETime=$lg(^User.DHCDocPassWorkNMainD(NID),12)
		...i BCSTime'="" s BCSTime=$zt(BCSTime,2)
		...i BCETime'="" s BCETime=$zt(BCETime,2)
		...s BCText="<span class='radusBorder'>"_BCName_"</span>"_BCSTime_"~"_BCETime
		...s XML=$lg(^User.DHCDocPassWorkNMainD(NID),7)
		...d ..GetPatTypeListNID(MID,LocId,XML,.CList)
		...s Item1 = $g(CList(1,"Item1")),Item2 = $g(CList(2,"Item2")),Item3 = $g(CList(3,"Item3"))
		...s Item4 = $g(CList(4,"Item4")),Item5 = $g(CList(5,"Item5")),Item6 = $g(CList(6,"Item6"))
		...s Item7 = $g(CList(7,"Item7")),Item8 = $g(CList(8,"Item8")),Item9 = $g(CList(9,"Item9"))
		...s Item10 = $g(CList(10,"Item10")),Item11 = $g(CList(11,"Item11")),Item12 = $g(CList(12,"Item12"))
		...s Item13 = $g(CList(13,"Item13")),Item14 = $g(CList(14,"Item14")),Item15 = $g(CList(15,"Item15"))
		...s Item16 = $g(CList(16,"Item16")),Item17 = $g(CList(17,"Item17")),Item18 = $g(CList(18,"Item18"))
		...s Item19 = $g(CList(19,"Item19")),Item20 = $g(CList(20,"Item20"))
		..d OuputRow1
	} else {
		//查询历史数据
		s seqno=""
		s count=0
		f  s seqno=$O(^User.DHCDocPassWorkNMainI("MLocMBCDateSeqno",LocId,BCDate,seqno)) q:seqno=""  d
		.s NID=""
		.f  s NID=$O(^User.DHCDocPassWorkNMainI("MLocMBCDateSeqno",LocId,BCDate,seqno,NID)) q:NID=""  d
		..;s status="<span class='c-ok'>已保存</span>"
		..s status="<span class='c-ok'>"_##class(websys.Translation).Get("dhcdoc.passwork.nmain.csp","已保存")_"</span>"
		..s BCName=$lg(^User.DHCDocPassWorkNMainD(NID),10)
		..s BCName= ##class(User.DHCDocPassWorkBCTime).GetTranByDesc("BCName",BCName,langid)
		..s BCSTime=$lg(^User.DHCDocPassWorkNMainD(NID),11)
		..s BCETime=$lg(^User.DHCDocPassWorkNMainD(NID),12)
		..s BCCode=$lg(^User.DHCDocPassWorkNMainD(NID),9)
		..i BCSTime'="" s BCSTime=$zt(BCSTime,2)
		..i BCETime'="" s BCETime=$zt(BCETime,2)
		..s BCID=""
		..s count=count+1
		..s BCText="<span class='radusBorder'>"_BCName_"</span>"_BCSTime_"~"_BCETime
		..s XML=$lg(^User.DHCDocPassWorkNMainD(NID),7)
		..d ..GetPatTypeListNID(MID,LocId,XML,.CList)
		..s Item1 = $g(CList(1,"Item1")),Item2 = $g(CList(2,"Item2")),Item3 = $g(CList(3,"Item3"))
		..s Item4 = $g(CList(4,"Item4")),Item5 = $g(CList(5,"Item5")),Item6 = $g(CList(6,"Item6"))
		..s Item7 = $g(CList(7,"Item7")),Item8 = $g(CList(8,"Item8")),Item9 = $g(CList(9,"Item9"))
		..s Item10 = $g(CList(10,"Item10")),Item11 = $g(CList(11,"Item11")),Item12 = $g(CList(12,"Item12"))
		..s Item13 = $g(CList(13,"Item13")),Item14 = $g(CList(14,"Item14")),Item15 = $g(CList(15,"Item15"))
		..s Item16 = $g(CList(16,"Item16")),Item17 = $g(CList(17,"Item17")),Item18 = $g(CList(18,"Item18"))
		..s Item19 = $g(CList(19,"Item19")),Item20 = $g(CList(20,"Item20"))
		..d OuputRow1
		
		i count=0 {
			s (NID,MID,BCID,BCText,BCCode,BCName,status,Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16,Item17,Item18,Item19,Item20)=""
			s BCText="<span class='c-no'>"_##class(websys.Translation).Get("dhcdoc.passwork.nmain.csp","当天没有保存班次数据！")_"</span>"	
			d OuputRow1
		}	
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1	
	set Data=$lb(NID,MID,BCID,BCText,BCCode,BCName,status,Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16,Item17,Item18,Item19,Item20)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod ItemCountQryFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ItemCountQryExecute ]
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

ClassMethod ItemCountQryClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ItemCountQryFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-08-27
/// DESC: 自动同步当日数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NMain).SyncByDate()
ClassMethod SyncByDate(UserID, LocID, InDate) As %String
{
	s InDate=##class(websys.Conversions).DateHtmlToLogical(InDate)
	S NID=""
	f  s NID=$O(^User.DHCDocPassWorkNMainI("MLocBCDate",LocID,InDate,NID)) Q:NID=""  D
	.s mRtn=##class(DHCDoc.PW.BS.NMain).SavePW(NID,"",UserID,1)
	
	
	Q 1
}

}
