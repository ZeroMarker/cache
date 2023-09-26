/// Function: 关联医护人员定义,作为医疗单元的子表
/// Creator:  sunfengchao
/// CreateDate：2015-12-30
Class web.DHCBL.CT.DHCCTLocMedUnitCareProv Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function: 查询程序
/// Output:   MUCP_ParRef MUCP_RowId  MUCP_Childsub MUCP_OPFlag MUCP_IPFlag 
/// debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCCTLocMedUnitCareProv","MedUnitPerson","1||1")
Query MedUnitPerson(ParRef As %String, rowid As %String, code As %String, desc As %String, checkhistory As %String) As %Query(ROWSPEC = "MUCPParRef:%String,CTMUChildsub:%String,MUCPRowId,MUCPLeaderFlag,MUCPOPFlag,MUCPIPFlag,MUCPDateFrom,MUCPDateTo,MUCPDoctorDR,CTPCPDesc,CTPCPCode,MUCPTimeFrom,MUCPTimeTo")
{
}

ClassMethod MedUnitPersonExecute(ByRef qHandle As %Binary, ParRef As %String, rowid As %String, code As %String, desc As %String, checkhistory As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1   
  Set qHandle=$lb(0,repid,0)
  if (ParRef="")&(rowid="")
  {
    q $$$OK
  }
  else
  {
    s:code'="" code=$zcvt(code,"U")
    s:desc'="" desc=$zcvt(desc,"U")
    
	//需要翻译的语言
	s langid=20
	s langcode="CH"
	if ($d(%session))
	{
		s langid=$g(%session.Data("LOGON.LANGID"))
		s langcode=$g(%session.Data("LOGON.LANGCODE"))
	}
  
    if (rowid'="")
    {
      s CTLocDr=$p(rowid,"||",1)
      s CTMUChildsub=$p(rowid,"||",2)
      s MUCPChildsub=$p(rowid,"||",3)
      s MUCPDateFrom="",MUCPDateTo=""
      s MUCPDoctorDR=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",1)
      q:MUCPDoctorDR="" 
      s MUCPParRef=CTLocDr_"||"_CTMUChildsub
      s MUCPRowId=rowid
      s CTPCPCode=$p($g(^CTPCP(MUCPDoctorDR,1)),"^",1)
      s CTPCPDesc=$p($g(^CTPCP(MUCPDoctorDR,1)),"^",2)  
      s CTPCPDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",langcode,CTPCPDesc)
      //s MUCPDoctorDR=CTPCPDesc
      s MUCPLeaderFlag=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",2)
      s MUCPOPFlag=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",3)
      s MUCPIPFlag=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",4)
      s MUCPDateFrom=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",5)
      s:MUCPDateFrom'="" MUCPDateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MUCPDateFrom) 
      s MUCPDateTo=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",6)
      s:MUCPDateTo'="" MUCPDateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MUCPDateTo) 
      ;s MUCPDateFrom=$zd(MUCPDateFrom,1) 
      ;s:(MUCPDateTo'="") MUCPDateTo=$zd(MUCPDateTo,1)
      s MUCPTimeFrom=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",7)
      s:MUCPTimeFrom'="" MUCPTimeFrom=$zt(MUCPTimeFrom)
      s MUCPTimeTo=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",8)
      s:MUCPTimeTo'="" MUCPTimeTo=$zt(MUCPTimeTo)
      d OutPutRow
    }
    else
    {
      s MUCPParRef=ParRef
      s CTLocDr=$p(ParRef,"||",1)
      s CTMUChildsub=$p(ParRef,"||",2)
      s MUCPChildsub=0
      for
      {
        s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub))    
        q:MUCPChildsub=""  
        s MUCPDateFrom="",MUCPDateTo=""
        s MUCPDoctorDR=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",1)
        if (MUCPDoctorDR="") continue 
        s MUCPDateTo=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP",MUCPChildsub)),"^",6)
        if ((checkhistory="false")||(checkhistory=""))&((MUCPDateTo'="")&&(MUCPDateTo<+$h)) continue
        if (checkhistory="true")&((MUCPDateTo="")||(MUCPDateTo>+$h)) continue 
        s MUCPParRef=ParRef
        s MUCPRowId=ParRef_"||"_MUCPChildsub 
        s CTPCPCode=$p($g(^CTPCP(MUCPDoctorDR,1)),"^",1)
        s CTPCPDesc=$p($g(^CTPCP(MUCPDoctorDR,1)),"^",2) 
        s CTPCPDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",langcode,CTPCPDesc)
        //s MUCPDoctorDR=CTPCPDesc
        s MUCPLeaderFlag=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",2)
        s MUCPOPFlag=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",3)
        s MUCPIPFlag=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",4)
        s MUCPDateFrom=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",5)
        s:MUCPDateFrom'="" MUCPDateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MUCPDateFrom) 
        s MUCPDateTo=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",6)
        s:MUCPDateTo'="" MUCPDateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MUCPDateTo) 
        ;s MUCPDateFrom=$zd(TMPMUCPDateFrom,1) 
        ;s:(MUCPDateTo'="") MUCPDateTo=$zd(MUCPDateTo,1)
        s MUCPTimeFrom=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",7)
        s:MUCPTimeFrom'="" MUCPTimeFrom=$zt(MUCPTimeFrom) 
        s MUCPTimeTo=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",8)
        s:MUCPTimeTo'="" MUCPTimeTo=$zt(MUCPTimeTo)
      
        if (desc'="")
        {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_CTLoc_MedUnitCareProv",MUCPRowId,CTPCPDesc,desc)
        }
        else
        {
           s AliasFlag= 1   
        }    
        if (($zcvt(CTPCPCode,"U")[code)||(code=""))&(AliasFlag=1) 
        {
          d OutPutRow
        }
      }
     }
    }
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutPutRow      
  set Data=$lb(MUCPParRef,MUCPChildsub,MUCPRowId,MUCPLeaderFlag,MUCPOPFlag,MUCPIPFlag,MUCPDateFrom,MUCPDateTo,MUCPDoctorDR,CTPCPDesc,CTPCPCode,MUCPTimeFrom,MUCPTimeTo)  
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

ClassMethod MedUnitPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MedUnitPersonExecute ]
{
  
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  //
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" {       // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
  }
  Else      {       // fetch row
    Set Row=^CacheTemp(repid,ind)
  }
  // Save QHandle
  s qHandle=$lb(AtEnd,repid,ind)
  Quit $$$OK
}

ClassMethod MedUnitPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MedUnitPersonExecute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)  
  Quit $$$OK
}

/// Function: 查询医生人员: 医护人员取自所在科室及其关联科室里所关联的医护人员
/// 基础数据平台- 李可凡
/// 2022-04-08
/// 其中包含LinkMUCPArray、DoctorArray两个数组代替global
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCCTLocMedUnitCareProv","CTPCPDR","93||1","","")
Query CTPCPDR(MURowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTPCPDesc:%String,TCTPCPCode:%String,CTMUDesc:%String,RESCTPCPDR:%String,CTLOCDesc:%String,MUCPRowid:%String")
{
}

ClassMethod CTPCPDRExecute(ByRef qHandle As %Binary, MURowid As %String, code As %String, desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	
	//需要翻译的语言
	s langid=20
	s langcode="CH"
	if ($d(%session))
	{
		s langid=$g(%session.Data("LOGON.LANGID"))
		s langcode=$g(%session.Data("LOGON.LANGCODE"))
	}
  
	s CTLocDr=$p($g(MURowid),"||",1)
	q:CTLocDr="" 
	s LINKChildsub=0,LocCount=1,CTLocDrStr=CTLocDr
	for		//查询该科室的所有关联科室
	{
		s LINKChildsub=$o(^CTLOC(CTLocDr,"LINK",0,"Loc",LINKChildsub)) q:LINKChildsub=""
		s CTLocDrStr=CTLocDrStr_"^"_LINKChildsub
		s LocCount=LocCount+1
	}
	
	for i=1:1:LocCount
	{
		s CTLocDr=$p(CTLocDrStr,"^",i)
		
		//在指定科室表查询该科室的医生
		s RESRowId=0
		for
		{
			s RESRowId=$o(^RB("RES",0,"CTLOC",CTLocDr,RESRowId)) q:RESRowId=""
			s RESCTPCPDR=$p($g(^RB("RES",RESRowId)),"^",2)		//取该医生的RowId
			continue:RESCTPCPDR=""
			s CTPCPCode=$p($g(^CTPCP(RESCTPCPDR,1)),"^",1)		//医生代码
			s CTPCPDescNew=$p($g(^CTPCP(RESCTPCPDR,1)),"^",2)	//医生描述
			
			s CTMUDesc="",CTLocDesc="",MUCPRowid=""		//输出的变量
			
			//重新循环所有科室下的医疗单元及关联医护人员
			for j=1:1:LocCount
			{
				s CTLocDrAll=$p(CTLocDrStr,"^",j)
				s CTChildsub=0
				for		//查询该科室下的医疗单元
				{
					s CTChildsub=$o(^CTLOC(CTLocDrAll,"MU",CTChildsub)) q:CTChildsub=""
					s MUCPChildsub=0
					for		//查询该医疗单元关联的医护人员
					{
						s MUCPChildsub=$o(^CTLOC(CTLocDrAll,"MU",CTChildsub,"CP",MUCPChildsub))  q:MUCPChildsub=""
						s MUCPDoctorDR=$p($g(^CTLOC(CTLocDrAll,"MU",CTChildsub,"CP",MUCPChildsub)),"^",1)
						s MUCPDateTo=$p($g(^CTLOC(CTLocDrAll,"MU",CTChildsub,"CP",MUCPChildsub)),"^",6)
						continue:(MUCPDateTo'="")&&(MUCPDateTo<+$h)		//过滤无效数据
						
						if (MUCPDoctorDR=RESCTPCPDR)	//如果该医生关联了医疗单元，输出其医疗单元名，科室名，MUCPRowid
						{
							s MUCPRowid=CTLocDrAll_"||"_CTChildsub_"||"_MUCPChildsub
							s CTMUDesc=$p($g(^CTLOC(CTLocDrAll,"MU",CTChildsub)),"^",2)
							s CTLocDesc=$p($g(^CTLOC(CTLocDrAll)),"^",2)
							s LinkMUCPArray(RESCTPCPDR,CTLocDrAll,CTChildsub,MUCPChildsub)=CTMUDesc_"^"_CTLocDesc	//LinkMUCPArray数组记录已关联的医疗单元
						}
					}
				}
			}
			
			s:code'="" code=$ZCONVERT(code,"U")
			s:desc'="" desc=$ZCONVERT(desc,"U")
		 	s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTPCPDescNew)
			if ((($ZCONVERT(CTPCPDescNew,"U")[desc)||(PINYINDesc[desc))&&($ZCONVERT(CTPCPCode,"U")[code))
			{
				s DoctorArray(RESCTPCPDR)=RESCTPCPDR_"^"_CTPCPCode_"^"_CTPCPDescNew		//DoctorArray数组记录所有需显示的医护人员
			}
		}
	}
	
	//最后循环人员数组输出信息，人员去重
	s DoctorDR=0
	for
	{
		s DoctorDR=$o(DoctorArray(DoctorDR)) q:DoctorDR=""
		s RESCTPCPDR=$p(DoctorArray(DoctorDR),"^",1)		//医护人员RowId
		s CTPCPCode=$p(DoctorArray(DoctorDR),"^",2)			//医护人员工号
		s CTPCPDescNew=$p(DoctorArray(DoctorDR),"^",3)		//医护人员姓名
		s MUCPRowid=""			//所属医疗单元RowId
		s CTMUDesc=""			//医疗单元描述
		s CTLocDesc=""			//科室描述
		s loc=0
		for
		{
			s loc=$o(LinkMUCPArray(DoctorDR,loc)) q:loc=""
			s muchildsub=0
			for
			{
				s muchildsub=$o(LinkMUCPArray(DoctorDR,loc,muchildsub)) q:muchildsub=""
				s cpchildsub=0
				for
				{
					s cpchildsub=$o(LinkMUCPArray(DoctorDR,loc,muchildsub,cpchildsub)) q:cpchildsub=""
					s:MUCPRowid'="" MUCPRowid=MUCPRowid_","
					s:CTMUDesc'="" CTMUDesc=CTMUDesc_","
					s:CTLocDesc'="" CTLocDesc=CTLocDesc_","
					s MUCPRowid=MUCPRowid_loc_"||"_muchildsub_"||"_cpchildsub			//所属医疗单元RowId
					s CTMUDesc=CTMUDesc_$p(LinkMUCPArray(DoctorDR,loc,muchildsub,cpchildsub),"^",1)			//医疗单元描述
					s CTLocDesc=CTLocDesc_$p(LinkMUCPArray(DoctorDR,loc,muchildsub,cpchildsub),"^",2)			//科室描述
				}
			}
		}
		d BuildCont
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildCont
	s CTPCPDescNew=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",langcode,CTPCPDescNew)
	s CTMUDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCCTLocMedUnit","CTMUDesc",langcode,CTMUDesc)
	s CTLocDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",langcode,CTLocDesc)
  set Data=$lb(CTPCPDescNew,CTPCPCode,CTMUDesc,RESCTPCPDR,CTLocDesc,MUCPRowid)  
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

ClassMethod CTPCPDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CTPCPDRExecute ]
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

ClassMethod CTPCPDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CTPCPDRExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Function: 查询医生人员: 医护人员取自所在科室及其关联科室里所关联的医护人员
/// Creator:  sunfengchao
/// CreateDate: 2015-12-30
/// 重新写了一个CTPCPDR，这个改为CTPCPDROld暂时保留		李可凡，2020年1月17日
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCCTLocMedUnitCareProv","CTPCPDR","1||1","","")
Query CTPCPDROld(MURowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TCTPCPDescNew:%String,TCTPCPCode:%String,CTMUDesc:%String,RESCTPCPDR:%String,CTLocDesc:%String,MUCPRowid:%String")
{
}

ClassMethod CTPCPDROldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CTPCPDROldExecute ]
{
  
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  //
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" {       // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
  }
  Else      {       // fetch row
    Set Row=^CacheTemp(repid,ind)
  }
  // Save QHandle
  s qHandle=$lb(AtEnd,repid,ind)
  Quit $$$OK
}

ClassMethod CTPCPDROldExecute(ByRef qHandle As %Binary, MURowid As %String, code As %String, desc As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  Set qHandle=$lb(0,repid,0)
  s CTLocDr=$p($g(MURowid),"||",1)
  q:CTLocDr="" 
  q:$d(^RB("RES",0,"CTLOC",CTLocDr))=0 $$$OK
  s RESRowId="0"
  f  s RESRowId=$o(^RB("RES",0,"CTLOC",CTLocDr,RESRowId)) q:RESRowId=""  d
  .s RESCTPCPDR=$p($g(^RB("RES",RESRowId)),"^",2)
  .q:RESCTPCPDR=""
  .s CTPCPCode=$p($g(^CTPCP(RESCTPCPDR,1)),"^",1)   
  .s CTPCPDescNew=$p($g(^CTPCP(RESCTPCPDR,1)),"^",2)   
  .s CTChildsub="0",Flag="N",CTMUDesc="空闲",MUCPRowid=""
  .f  s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub)) q:((CTChildsub="")!(Flag'="N"))  d
  ..s MUCPChildsub=0
  ..f  s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub))  q:((MUCPChildsub="")!(Flag'="N"))  d 
  ...s MUCPRowid=""
  ...s MUCPRowid=CTLocDr_"||"_CTChildsub_"||"_MUCPChildsub
  ...s MUCPDoctorDR=$p($g(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub)),"^",1)
  ...q:(MUCPDoctorDR'=RESCTPCPDR)
  ...s Flag="Y"
  ...s CTMUDesc=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",2) 
  ...s CTLocDesc=$p($g(^CTLOC(CTLocDr)),"^",2) 
  .if (((CTPCPDescNew[desc)||(desc=""))&&((code="")||(CTPCPCode[code))) d
  ..d BuildCont2
 
 ; 先取出该科室关联的科室 然后取出关联科室里关联的医护人员
  s CTLOCRowID=CTLocDr,LINKChildsub=0, LocStr=""
  for
  {
    s LINKChildsub=$o(^CTLOC(CTLOCRowID,"LINK",0,"Loc",LINKChildsub)) 
    q:LINKChildsub=""
    
    if (LocStr="")
    {
      s LocStr="{"_LINKChildsub_"}"
    }
    else
    {
      s LocStr=LocStr_",{"_LINKChildsub_"}"
    }
  }  
   s loclen=$length(LocStr,",")
   for i=1:1:loclen
   { 
      s locid=$p($g(LocStr),",",i)
      s LINKCTLOCDR=$e(locid,2,($Length(locid)-1))
      s CTLocDr=LINKCTLOCDR
      continue:((CTLocDr="")||($d(^RB("RES",0,"CTLOC",CTLocDr))=0))    
      
      s RESRowId="0"
      f  s RESRowId=$o(^RB("RES",0,"CTLOC",CTLocDr,RESRowId)) q:RESRowId=""  d
      .s RESCTPCPDR=$p($g(^RB("RES",RESRowId)),"^",2)
      .q:RESCTPCPDR=""
      .s CTPCPCode=$p($g(^CTPCP(RESCTPCPDR,1)),"^",1)   
      .s CTPCPDescNew=$p($g(^CTPCP(RESCTPCPDR,1)),"^",2)  
      .s CTChildsub="0",Flag="N",CTMUDesc="空闲",MUCPRowid=""
      .; 应该是 用的 ref中的locdr
      .s CTLocDr=$p($g(MURowid),"||",1)
      .f  s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub)) q:((CTChildsub="")!(Flag'="N"))  d
      ..;w RESRowId_"&"_CTPCPCode_"^"_CTPCPDescNew_"^"_CTChildsub b ;CTChildsub
      ..s MUCPChildsub=0
      ..f  s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub))  q:((MUCPChildsub="")!(Flag'="N"))  d 
      ...s MUCPRowid=""
      ...s MUCPRowid=CTLocDr_"||"_CTChildsub_"||"_MUCPChildsub
      ...s MUCPDoctorDR=$p($g(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub)),"^",1)
      ...q:(MUCPDoctorDR'=RESCTPCPDR)
      ...s Flag="Y"
      ...s CTMUDesc=$p($g(^CTLOC(CTLocDr,"MU",CTChildsub)),"^",2) 
      ...s CTLocDesc=$p($g(^CTLOC(LINKCTLOCDR)),"^",2)
      .if (((CTPCPDescNew[desc)||(desc=""))&&((code="")||(CTPCPCode[code))) d
      ..d BuildCont3
   }    
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
  
BuildCont2      
  set Data=$lb(CTPCPDescNew,CTPCPCode,CTMUDesc,RESCTPCPDR,CTLocDesc,MUCPRowid)  
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
BuildCont3      
  set Data=$lb(CTPCPDescNew,CTPCPCode,CTMUDesc,RESCTPCPDR,CTLocDesc,MUCPRowid)  
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

ClassMethod CTPCPDROldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CTPCPDROldExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Function:显示打开窗口资源组信息 
/// CreateDate:2015-12-30
/// Creator:基础数据平台公共产品组 孙凤超
/// Others: w ##class(web.DHCBL.CT.DHCCTLocMedUnitCareProv).OpenData("1||1||1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCCTLocMedUnitCareProv).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCCTLocMedUnitCareProv).%New()
 s eobj.MUCPRowId=id
 s paref=$p(id,"||",1)
 s ParentSub=$P(id,"||",2)
 s eobj.MUCPParRef=paref_"||"_ParentSub
 s eobj.MUCPDoctorDR=pobj.MUCPDoctorDR.%Id()
 
 s:eobj.MUCPDoctorDR'="" eobj.CTPCPCode=$p($g(^CTPCP(eobj.MUCPDoctorDR,1)),"^",1)
 s:eobj.MUCPDoctorDR'="" eobj.CTPCPDesc=$p($g(^CTPCP(eobj.MUCPDoctorDR,1)),"^",2)  
 s eobj.MUCPIPFlag = pobj.MUCPIPFlag
 s eobj.MUCPOPFlag = pobj.MUCPOPFlag
 s eobj.MUCPLeaderFlag = pobj.MUCPLeaderFlag
 s:eobj.MUCPIPFlag="Y" eobj.MUCPIPFlag="true"
 s:(eobj.MUCPIPFlag="N"||eobj.MUCPIPFlag="") eobj.MUCPIPFlag="false"
 s:eobj.MUCPOPFlag="Y" eobj.MUCPOPFlag="true"
 s:(eobj.MUCPOPFlag="N"||eobj.MUCPOPFlag="") eobj.MUCPOPFlag="false"
 s:eobj.MUCPLeaderFlag="Y" eobj.MUCPLeaderFlag="true"
 s:(eobj.MUCPLeaderFlag="N"||eobj.MUCPLeaderFlag="") eobj.MUCPLeaderFlag="false"
 s eobj.MUCPDateFrom=pobj.MUCPDateFrom
 s eobj.MUCPDateTo=pobj.MUCPDateTo 
 s:eobj.MUCPDateFrom'="" eobj.MUCPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MUCPDateFrom)
 s:eobj.MUCPDateTo'="" eobj.MUCPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MUCPDateTo)
 s eobj.MUCPTimeFrom=pobj.MUCPTimeFrom
 s eobj.MUCPTimeTo=pobj.MUCPTimeTo
 s:eobj.MUCPTimeFrom'="" eobj.MUCPTimeFrom=$zt(eobj.MUCPTimeFrom)
 s:eobj.MUCPTimeTo'="" eobj.MUCPTimeTo=$zt(eobj.MUCPTimeTo)
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:显示打开窗口资源组信息 HISUI版用
/// CreateDate:2023-02-28
/// Creator:基础数据平台公共产品组 gss
/// Others: w ##class(web.DHCBL.CT.DHCCTLocMedUnitCareProv).OpenData2("1||1||1")
ClassMethod OpenData2(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.DHCCTLocMedUnitCareProv).%OpenId(id)
 s eobj = ##class(web.Entity.CT.DHCCTLocMedUnitCareProv).%New()
 s eobj.MUCPRowId=id
 s paref=$p(id,"||",1)
 s ParentSub=$P(id,"||",2)
 s eobj.MUCPParRef=paref_"||"_ParentSub
 s eobj.MUCPDoctorDR=pobj.MUCPDoctorDR.%Id()
 
 s:eobj.MUCPDoctorDR'="" eobj.CTPCPCode=$p($g(^CTPCP(eobj.MUCPDoctorDR,1)),"^",1)
 s:eobj.MUCPDoctorDR'="" eobj.CTPCPDesc=$p($g(^CTPCP(eobj.MUCPDoctorDR,1)),"^",2)  
 s eobj.MUCPIPFlag = pobj.MUCPIPFlag
 s eobj.MUCPOPFlag = pobj.MUCPOPFlag
 s eobj.MUCPLeaderFlag = pobj.MUCPLeaderFlag
 s eobj.MUCPDateFrom=pobj.MUCPDateFrom
 s eobj.MUCPDateTo=pobj.MUCPDateTo 
 s:eobj.MUCPDateFrom'="" eobj.MUCPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MUCPDateFrom)
 s:eobj.MUCPDateTo'="" eobj.MUCPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MUCPDateTo)
 s eobj.MUCPTimeFrom=pobj.MUCPTimeFrom
 s eobj.MUCPTimeTo=pobj.MUCPTimeTo
 s:eobj.MUCPTimeFrom'="" eobj.MUCPTimeFrom=$zt(eobj.MUCPTimeFrom)
 s:eobj.MUCPTimeTo'="" eobj.MUCPTimeTo=$zt(eobj.MUCPTimeTo)
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 q str
}

/// Function：删除数据
/// Creator： sunfengchao
/// CreateDate:2015-12-30
/// w ##class(web.DHCBL.CT.DHCCTLocMedUnitCareProv).DeleteData("63||1||1")
ClassMethod DeleteData(MUCPRowid) As %String
{
  s CTLocDr=$p(MUCPRowid,"||",1)
  s MUCTChildSub=$p(MUCPRowid,"||",2)
  s MUCTPCPChildSub=$p(MUCPRowid,"||",3)
  s DateFrom=$p($g(^CTLOC(CTLocDr,"MU",MUCTChildSub,"CP",MUCTPCPChildSub)),"^",5)
  s result=""
  s Now=$p($h,",",1)
  s obj=##class(User.DHCCTLocMedUnitCareProv).%OpenId(MUCPRowid)
  s eobj=##class(web.Entity.CT.DHCCTLocMedUnitCareProv).%New()
  s eobj.MUCPDateFrom=obj.MUCPDateFrom
  s eobj.MUCPDateTo=obj.MUCPDateTo
  s eobj.MUCPIPFlag=obj.MUCPIPFlag
  s eobj.MUCPOPFlag=obj.MUCPOPFlag
  s eobj.MUCPLeaderFlag=obj.MUCPLeaderFlag  
  if (obj.MUCPDoctorDR'="")
  { 
   s eobj.MUCPDoctorDR=obj.MUCPDoctorDR.%Id()
  }
  else 
  {    
    s eobj.MUCPDoctorDR=""
  }
  ; 不允许删除数据,只能结束日期置为当前日期
  s DateFrom=$p(^CTLOC(CTLocDr,"MU",MUCTChildSub,"CP",MUCTPCPChildSub),"^",5)
  if (DateFrom>+$H) 
  {
      TS
      s sc=obj.%DeleteId(MUCPRowid)
      if (sc=1){
         Tc
         s result="{success:'true',info:'开始日期大于当前日期,允许删除,数据删除成功！'}" 
      }
      else{
        Trollback
        s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
     }
      
  }
  else
  {
      TS
      s obj.MUCPDateTo=Now
      s obj.MUCPTimeTo=$p($H,",",2)
      s result=obj.%Save()
      if (result=1)
      {
          TC
          s result="{success:'true',info:'数据截止成功,结束日期设置为当前日期！'}"
        }
        else
        {
          Trollback
          s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
        }
  }
   q result
}

/// w ##class(web.DHCBL.CT.DHCCTLocMedUnitCareProv).CheckedDate(282,"20/12/2014","21/12/2014,9||2||3)
/// 1 可用 0 不可用
ClassMethod CheckedDate(MUCPDoctorDR, MUCPDateFrom, MUCPDateTo, MUCPRowid As %String = "") As %String
{
 
    s ^TempzogHKJK=MUCPDoctorDR_","_ MUCPDateFrom_","_MUCPDateTo_","_MUCPRowid
   s:MUCPDateFrom'="" JSDateFrom=MUCPDateFrom
    i MUCPDateTo'="" s JSDateTo= MUCPDateTo 
   e  s JSDateTo=""
    Q:(JSDateTo'="")&&(JSDateFrom>JSDateTo) "0^日期错误"
    Q:MUCPDoctorDR="" "0^医生不存在"
   
    Q:$d(^CTLOC(0,"CTPCP",MUCPDoctorDR))="0" "1^"
    s Flag=1
    s GetDescStr=""
    s CTLocDr="0"
    f  s CTLocDr=$o(^CTLOC(0,"CTPCP",MUCPDoctorDR,CTLocDr)) q:(CTLocDr="")||(Flag=0)   d
    .s CTMUChildsub="0"
    .f  s CTMUChildsub=$o(^CTLOC(0,"CTPCP",MUCPDoctorDR,CTLocDr,"MU",CTMUChildsub))  q:(CTMUChildsub="")||(Flag=0)  d
    ..s MUCPChildsub="0"
    ..f  s MUCPChildsub=$o(^CTLOC(0,"CTPCP",MUCPDoctorDR,CTLocDr,"MU",CTMUChildsub,"CP",MUCPChildsub))  q:(MUCPChildsub="")||(Flag=0)  d
    ...s MainMURowID=CTLocDr_"||"_CTMUChildsub_"||"_MUCPChildsub
    ...Q:((MUCPRowid'="")&&(MainMURowID=MUCPRowid))
    ...s DateFrom=+$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",5)
    ...s DateTo=+$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",6)
    ...s CTMUDesc=$p(^CTLOC(CTLocDr,"MU",CTMUChildsub),"^",2)
    ...s CTLOCDesc=$P($G(^CTLOC(CTLocDr)),"^",2)
    ...if DateTo=0  d
    ....s Flag=0,GetDescStr=CTLOCDesc_" "_CTMUDesc
    ...else  d
    ....if (JSDateFrom>=DateFrom)&&(JSDateFrom<=DateTo)  d
    .....s Flag=0,GetDescStr=CTLOCDesc_" "_CTMUDesc
    ....if Flag'=0 d
    .....if JSDateTo=""  d
    ......S:JSDateFrom<DateFrom Flag=0,GetDescStr=CTLOCDesc_" "_CTMUDesc
    .....else  d
    ......i (JSDateTo>=DateFrom)&&(JSDateTo<=DateTo)  d
    .......s Flag=0,GetDescStr=CTLOCDesc_" "_CTMUDesc
    q Flag_"^"_GetDescStr
}

/// Function: 检查是否是需要单元组领导
/// Creator:  sunfengchao
/// CreateDate: 2015-12-31
/// Output: 0 需要组领导 1 不需要组领导
/// w ##class(web.DHCBL.CT.DHCCTLocMedUnitCareProv).RequiredMUCPLeader("1||5")
ClassMethod RequiredMUCPLeader(Paref As %String, MURowid As %String) As %String
{
    s flag=0
    if (MURowid="")
    {
      s CTLocDr=$p(Paref,"||",1)
      s CTMUChildsub=$p(Paref,"||",2)
      s MUCPChildsub="0"
      for
      {
        s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub))    
        q:MUCPChildsub=""   
        s MUCPLeaderFlag=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",2)
        s MUCPDateTo=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",6)
        if (MUCPLeaderFlag="Y")&&((MUCPDateTo="")||(MUCPDateTo>+$h))
        {
	        s flag=1
	        q
        }
      }
    }
    else
    {
      s CTLocDr=$p(MURowid,"||",1)
      s CTMUChildsub=$p(MURowid,"||",2)
      s MUCPChildsub="0"
      s rowid=""
      for
      {
        s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub))    
        q:MUCPChildsub=""   
        s MUCPLeaderFlag=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",2)
        s MUCPDateTo=$p($g(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",6)
        if (MUCPLeaderFlag="Y")&&((MUCPDateTo="")||(MUCPDateTo>+$h))
        {
          s rowid=CTLocDr_"||"_CTMUChildsub_"||"_MUCPChildsub
          if (rowid'=MURowid) s flag=1
        }
      }
    }
    q flag
}

/// Function: 对医生指向进行重复校验
/// Creator:  sunfengchao
/// CreateDate: 2015-12-31
/// Desc：１　允许新增　　０　不允许新增
/// 　    1 如果之前的数据里结束日期不为空 则不允许再添加
///     2 之前的结束日期都不为空
///     开始日期> 之前的开始日期  开始日期< 之前的结束日期 不允许添加
///     输入的结束日期为空 则 开始日期小于之前的数据的开始日期 不允许添加
///     输入的结束日期不为空 结束日期小于之前数据的结束日期 不允许添加
/// debug: w ##class(web.DHCBL.CT.DHCCTLocMedUnitCareProv).FormValidate("6||1","","3","65378","")
ClassMethod FormValidate(Paref As %String, id As %String, doctordr As %String, MUCPDateFrom, MUCPDateTo) As %String
{
	s:(MUCPDateFrom["-")||(MUCPDateFrom["/") MUCPDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(MUCPDateFrom)
	s:(MUCPDateTo["-")||(MUCPDateTo["/") MUCPDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(MUCPDateTo)
	s Flag=1,GetDescStr=""  

	; ^CTLOC(0,"CTPCP",6,284,"MU",1,"CP",1)=""
	; ^CTLOC(0,"CTPCP",6,284,"MU",1,"CP",3)=""
	if doctordr="" q "1^医生id为空"    
	s CTMUChildsub=0
	for
	{
		s CTMUChildsub=$O(^CTLOC(0,"CTPCP",doctordr,CTMUChildsub)) q:CTMUChildsub=""
		s CTLOCRowId=CTMUChildsub
		s MUCPChildsub=0
		for
		{
			s MUCPChildsub=$O(^CTLOC(0,"CTPCP",doctordr,CTMUChildsub,"MU",MUCPChildsub)) q:MUCPChildsub=""
			s flagc=$d(^CTLOC(0,"CTPCP",doctordr,CTMUChildsub,"MU",MUCPChildsub,"CP")) ;
			if (flagc=0) 
			{
				s Flag=0 
				s GetDescStr=""
				q  
			}
			else
			{
				s childsubc=0
				for
				{
					s childsubc=$o(^CTLOC(0,"CTPCP",doctordr,CTMUChildsub,"MU",MUCPChildsub,"CP",childsubc)) q:childsubc=""

					s idc=CTMUChildsub_"||"_MUCPChildsub_"||"_childsubc 
					if (idc'=id)
					{
						
						s DateFrom=$p($g(^CTLOC(CTMUChildsub,"MU", MUCPChildsub,"CP", childsubc)),"^",5)
						s DateTo=$p($g(^CTLOC(CTMUChildsub,"MU", MUCPChildsub,"CP", childsubc)),"^",6)
						s CTMUDesc=$p($g(^CTLOC(CTMUChildsub,"MU",MUCPChildsub)),"^",2)  //医疗单元名称
						s CTLOCDesc=$P($G(^CTLOC(CTMUChildsub)),"^",2)  //科室 名称
						
						//根据科室返回访问类型(门诊/住院/急诊/体检)
						
						s NewType=""
						s OldType=""
						s ADMLOCAdmType=0
						for
						{
							s ADMLOCAdmType=$o(^PAC("ADMLOC",0,"AdmType",ADMLOCAdmType)) q:ADMLOCAdmType=""
							s ADMLOCCTLOCDR=""
							s NewLocDR=$p(Paref,"||",1)
							s ADMRowId=$o(^PAC("ADMLOC",0,"AdmType",ADMLOCAdmType,NewLocDR,0))
							if ADMRowId'=""  s NewType=ADMLOCAdmType			//取新科室的访问类型
							s ADMRowId=$o(^PAC("ADMLOC",0,"AdmType",ADMLOCAdmType,CTLOCRowId,0))
							if ADMRowId'=""  s OldType=ADMLOCAdmType			//取老科室的访问类型
						}
						if ((OldType'="")&(NewType=OldType))		//若科室访问类型相同，不允许添加
						{
							///结束日期一个或者两个为空
							if ((DateTo="")&&(MUCPDateTo=""))||((DateTo'="")&&(MUCPDateTo="")&&(MUCPDateFrom<DateTo))||((MUCPDateTo'="")&&(DateTo="")&&(DateFrom<MUCPDateTo))
							{
								s Flag=0  ; 2不可增加 时间冲突
								s GetDescStr=CTLOCDesc_"-"_CTMUDesc_"时间冲突"
							}
							else 
							{
								///结束日期都不为空，考虑时间交叉
								if ((DateTo'="")&&(MUCPDateTo'="")&&(((MUCPDateFrom>=DateFrom)&&(MUCPDateFrom<=DateTo))||((DateFrom>=MUCPDateFrom)&&(DateFrom<=MUCPDateTo))))  
								{   
									s Flag=0
									s GetDescStr=CTLOCDesc_"-"_CTMUDesc_"时间冲突"
								}
							} 
						}
						 
					}
				} ; for 结束
			}
		}
	}  
	q Flag_"^"_GetDescStr
}

/// Creator: 基础数据平台 sunfengchao
/// CreatDate: 2016-01-04
/// Description:增加/修改内容
/// Return:成功返回success:'true'和新增或修改的数据的CTCOURowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCCTLocMedUnitCareProv) As %String
{
    s result=""
    s:eobj.MUCPIPFlag="" eobj.MUCPIPFlag="N" 
    s:eobj.MUCPIPFlag="3" eobj.MUCPIPFlag="Y"
    s:eobj.MUCPLeaderFlag="1" eobj.MUCPLeaderFlag="Y" 
    s:eobj.MUCPLeaderFlag="" eobj.MUCPLeaderFlag="N"
    s:eobj.MUCPOPFlag="2" eobj.MUCPOPFlag="Y"
    s:eobj.MUCPOPFlag="" eobj.MUCPOPFlag="N"
    s:eobj.MUCPDateFrom'="" eobj.MUCPDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MUCPDateFrom)
    s:eobj.MUCPDateTo'="" eobj.MUCPDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MUCPDateTo)
    s:eobj.MUCPDateFrom="" eobj.MUCPDateFrom = +$h
    s:eobj.MUCPTimeFrom'="" eobj.MUCPTimeFrom=$zth(eobj.MUCPTimeFrom)
    s:eobj.MUCPTimeTo'="" eobj.MUCPTimeTo=$zth(eobj.MUCPTimeTo)
    s:eobj.MUCPRowId'="" eobj.MUCPParRef=$p(eobj.MUCPRowId,"||",1)_"||"_$p(eobj.MUCPRowId,"||",2)
    s resultstr= ..FormValidate(eobj.MUCPParRef,eobj.MUCPRowId,eobj.MUCPDoctorDR,eobj.MUCPDateFrom,eobj.MUCPDateTo)
    s flag=$p($g(resultstr),"^",1)
    s reason=$p($g(resultstr),"^",2)
    if (flag=1){
	    if (eobj.MUCPRowId="")       
	    {
	      s obj=##class(User.DHCCTLocMedUnitCareProv).%New(eobj.MUCPParRef) 
	     
	    }
	    else                           
	    {
	      s obj=##class(User.DHCCTLocMedUnitCareProv).%OpenId(eobj.MUCPRowId)
	      s bobj = ##class(web.Entity.CT.DHCCTLocMedUnitCareProv).%New()
	      s bobj.MUCPRowId = eobj.MUCPRowId    
	      s bobj.MUCPParRef=obj.MUCPParRef //$p($g(^CTLOC($P(rowid,"||",1),"MU",$p(rowid,"||",2))),"^",2)   ??
	      s bobj.MUCPDateFrom = obj.MUCPDateFrom
	      s bobj.MUCPDateTo = obj.MUCPDateTo
	      s bobj.MUCPIPFlag = obj.MUCPIPFlag
	      s:bobj.MUCPIPFlag="" bobj.MUCPIPFlag="N"
	      s bobj.MUCPOPFlag = obj.MUCPOPFlag
	      s:bobj.MUCPOPFlag="" bobj.MUCPOPFlag ="N"
	      s bobj.MUCPLeaderFlag = obj.MUCPLeaderFlag
	      s:bobj.MUCPLeaderFlag="" bobj.MUCPLeaderFlag ="N"
	      s bobj.MUCPTimeFrom=obj.MUCPTimeFrom
	      s bobj.MUCPTimeTo=obj.MUCPTimeTo
	      s bobj.CTPCPCode=$p($g(^CTPCP(eobj.MUCPDoctorDR,1)),"^",1)
	      s bobj.CTPCPDesc=$p($g(^CTPCP(eobj.MUCPDoctorDR,1)),"^",2) 
	    }
	      d obj.MUCPParRefSetObjectId(eobj.MUCPParRef)
	      d obj.MUCPDoctorDRSetObjectId(eobj.MUCPDoctorDR)
	      s obj.MUCPDateFrom = eobj.MUCPDateFrom
	      s obj.MUCPDateTo = eobj.MUCPDateTo
	      s obj.MUCPIPFlag = eobj.MUCPIPFlag
	      s obj.MUCPLeaderFlag = eobj.MUCPLeaderFlag
	      s obj.MUCPOPFlag = eobj.MUCPOPFlag  
	      s obj.MUCPTimeFrom=eobj.MUCPTimeFrom
	      s obj.MUCPTimeTo=eobj.MUCPTimeTo
	     
	      Tstart
	      s sc=obj.%Save()
	      do obj.%Close()
	      if $$$ISOK(sc)
	      {
	        Tcommit
	        s id=obj.%Id()
	        s result = "{success:'true',id:'"_id_"'}"
	        s DoctorDesc=$p($g(^CTPCP(eobj.MUCPDoctorDR,1)),"^",2)    //取医护人员描述，保存日志用
	        d:eobj.MUCPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_CTLoc_MedUnitCareProv","User.DHCCTLocMedUnitCareProv","医疗单元关联医护人员",id,DoctorDesc,"A",eobj,"",eobj.MUCPParRef)
	      
	        d:eobj.MUCPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_CTLoc_MedUnitCareProv","User.DHCCTLocMedUnitCareProv","医疗单元关联医护人员",eobj.MUCPRowId,DoctorDesc,"U",eobj,bobj,eobj.MUCPParRef)
	    }
	    else
	    {
	      Trollback
	      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
	    } 
	  
	 }
    else
    {
      s result = "{success:'false',errorinfo:'日期与"_reason_",请重新设置日期段或给以往记录设置结束日期'}"     
    }
  q result
}

/// Creator：高姗姗
/// CreatDate: 2016-8-30
/// Description：医护人员所属医疗单元
/// Table：User.DHCCTLocMedUnitCareProv
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCCTLocMedUnitCareProv","GetListByDoctorDR","","838")
Query GetListByDoctorDR(rowid As %String, DoctorDR As %String, ParRef As %String) As %Query(ROWSPEC = "CTMUDesc,MUCPParRef,MUCPChildsub,MUCPRowId,MUCPLeaderFlag,MUCPOPFlag,MUCPIPFlag,MUCPDateFrom,MUCPDateTo,MUCPTimeFrom,MUCPTimeTo")
{
}

ClassMethod GetListByDoctorDRExecute(ByRef qHandle As %Binary, rowid As %String, DoctorDR As %String, ParRef As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
        s MUCPRowId=rowid
        s CTMUCTLOCParRef=$p(MUCPRowId,"||",1)
  		s CTMUChildsub=$p(MUCPRowId,"||",2)
  		s MUCPChildsub=$p(MUCPRowId,"||",3)
        s MUCPParRef=CTMUCTLOCParRef_"||"_CTMUChildsub

        s CTMUDesc=$p($g(^CTLOC(CTMUCTLOCParRef,"MU",CTMUChildsub)),"^",2)      
        s MUCPLeaderFlag=$p($g(^CTLOC(CTMUCTLOCParRef,"MU",CTMUChildsub,"CP", MUCPChildsub)),"^",2)
        s MUCPOPFlag=$p($g(^CTLOC(CTMUCTLOCParRef,"MU",CTMUChildsub,"CP", MUCPChildsub)),"^",3)
        s MUCPIPFlag=$p($g(^CTLOC(CTMUCTLOCParRef,"MU",CTMUChildsub,"CP", MUCPChildsub)),"^",4)
        s MUCPDateFrom=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",5)
        s MUCPDateTo=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",6)
        s:MUCPDateFrom'="" MUCPDateFrom=$zd(MUCPDateFrom,1) 
        s:MUCPDateTo'="" MUCPDateTo=$zd(MUCPDateTo,1)
        //新增开始时间，结束时间
        s MUCPTimeFrom=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",7)
        s:MUCPTimeFrom'="" MUCPTimeFrom=$zt(MUCPTimeFrom)
        s MUCPTimeTo=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",8)
        s:MUCPTimeTo'="" MUCPTimeTo=$zt(MUCPTimeTo)
		
		d OutputRowUnit
	}
	else
	{
     	s CTMUCTLOCParRef=0
     	for{
	     	s CTMUCTLOCParRef=$o(^CTLOC(CTMUCTLOCParRef))  q:(CTMUCTLOCParRef="")
	     	s CTMUChildsub=0
	     	for{
		     	 s CTMUChildsub=$o(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub)) q:(CTMUChildsub="")
		     	 s MUCPChildsub=0
		     	 for{
			     	 s MUCPChildsub=$o(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)) q:(MUCPChildsub="")
			     	 s MUCPDoctorDR=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",1)
			     	 if (MUCPDoctorDR=DoctorDR){
    					 
    					s MUCPParRef=CTMUCTLOCParRef_"||"_CTMUChildsub
        				s MUCPRowId=CTMUCTLOCParRef_"||"_CTMUChildsub_"||"_MUCPChildsub
      
        				s CTMUDesc=$p($g(^CTLOC(CTMUCTLOCParRef,"MU",CTMUChildsub)),"^",2) 
        				s AliasRowId=0,ALIASText1=""
        				for
        				{
         					s AliasRowId=$o(^User.BDPAliasI("DataRef","DHC_CTLoc_MedUnitCareProv",MUCPRowId,AliasRowId))
         					q:AliasRowId=""
         					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
         					; 查询出对应rowid下的所有别名，用"^"进行连接
         					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
        				} 
        				s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTMUDesc)      
        				s MUCPLeaderFlag=$p($g(^CTLOC(CTMUCTLOCParRef,"MU",CTMUChildsub,"CP", MUCPChildsub)),"^",2)
        				s MUCPOPFlag=$p($g(^CTLOC(CTMUCTLOCParRef,"MU",CTMUChildsub,"CP", MUCPChildsub)),"^",3)
        				s MUCPIPFlag=$p($g(^CTLOC(CTMUCTLOCParRef,"MU",CTMUChildsub,"CP", MUCPChildsub)),"^",4)
        				s MUCPDateFrom=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",5)
        				s MUCPDateTo=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",6)
        				s:MUCPDateFrom'="" MUCPDateFrom=$zd(MUCPDateFrom,1) 
        				s:MUCPDateTo'="" MUCPDateTo=$zd(MUCPDateTo,1)
        				//新增开始时间，结束时间
				        s MUCPTimeFrom=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",7)
				        s:MUCPTimeFrom'="" MUCPTimeFrom=$zt(MUCPTimeFrom)
				        s MUCPTimeTo=$p($g(^CTLOC(CTMUCTLOCParRef,"MU", CTMUChildsub,"CP", MUCPChildsub)),"^",8)
				        s:MUCPTimeTo'="" MUCPTimeTo=$zt(MUCPTimeTo)
    					 
    					if ((MUCPParRef=ParRef)||(ParRef="")){
	    					d OutputRowUnit
	 	    			}
    				}
			     }
		     }
	     }
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUnit
    set Data=$lb(CTMUDesc,MUCPParRef,MUCPChildsub,MUCPRowId,MUCPLeaderFlag,MUCPOPFlag,MUCPIPFlag,MUCPDateFrom,MUCPDateTo,MUCPTimeFrom,MUCPTimeTo)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListByDoctorDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListByDoctorDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListByDoctorDRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
