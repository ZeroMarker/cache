Import SQLUser

/// Function: 医嘱项接收科室
/// CreateDate: 2013-8-27 
/// Creator:  sunfengchao
Class web.DHCBL.CT.ARCItmRecLoc Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function:查询 医嘱项接收科室 
/// Table:  ARC_ItmRecLoc
/// Creator: sunfengchao
/// CreateDate: 2013-8-27 
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItmRecLoc","GetList","")
Query GetList(ParRef As %String, PatLoc As %String, RecLoc As %String, HospId As %String) As %Query(ROWSPEC = "ARCRLRowId,ARCRLOrdLocDR,ARCRLOrdLocDesc,ARCRLRecLocDR,ARCRLRecLocDesc,ARCRLOrderPriorityDR,ARCRLOrderPriorityDesc,ARCRLDefaultFlag,ARCRLDateFrom,ARCRLDateTo,ARCRLTimeFrom,ARCRLTimeTo,ARCRLCTHospitalDR,ARCRLCTHospitalDesc,ARCRLClinicType,ARCRLFunction")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String, PatLoc As %String, RecLoc As %String, HospId As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1

    s parref=$p(ParRef,"||",1)
    s version=$p(ParRef,"||",2)
    s rowid=0
    f  s rowid=$o(^ARCRL(parref,rowid)) q:rowid=""  d
    .s ARCRLRowId=parref_"||"_rowid
    .s ARCRLOrdLocDR=$p($g(^ARCRL(parref,rowid)),"^",1)
    .s ARCRLOrdLocDesc=""
    .s:ARCRLOrdLocDR'="" ARCRLOrdLocDesc=$p($g(^CTLOC(ARCRLOrdLocDR)),"^",2) //获取科室描述
    .s ARCRLRecLocDR=$p($g(^ARCRL(parref,rowid)),"^",2)
    .s ARCRLRecLocDesc=""
    .s:ARCRLRecLocDR'="" ARCRLRecLocDesc=$p($g(^CTLOC(ARCRLRecLocDR)),"^",2) //获取科室描述
    .s ARCRLOrderPriorityDR=$p($g(^ARCRL(parref,rowid)),"^",10)
    .s ARCRLOrderPriorityDesc=""
    .s:ARCRLOrderPriorityDR'="" ARCRLOrderPriorityDesc=$p($g(^OECPR(ARCRLOrderPriorityDR)),"^",2) //系统医嘱优先级描述
    .s ARCRLDefaultFlag=$p($g(^ARCRL(parref,rowid)),"^",4)
    .s ARCRLFunction=$p($g(^ARCRL(parref,rowid)),"^",3)	//功能
    .s ARCRLCTHospitalDR=$p($g(^ARCRL(parref,rowid)),"^",7)
    .s ARCRLCTHospitalDesc=""
    .s:ARCRLCTHospitalDR'="" ARCRLCTHospitalDesc=$p($g(^CT("HOSP",ARCRLCTHospitalDR)),"^",2)  //医院描述 
    
    .s ARCRLDateFrom=$p($g(^ARCRL(parref,rowid)),"^",8)
    .s ARCRLDateTo=$p($g(^ARCRL(parref,rowid)),"^",9)
    .s:ARCRLDateFrom'="" ARCRLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCRLDateFrom) //转换日期格式
    .s:ARCRLDateTo'="" ARCRLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCRLDateTo) //转换日期格式
    .s ARCRLTimeFrom=$p($g(^ARCRL(parref,rowid)),"^",5)
    .s ARCRLTimeTo=$p($g(^ARCRL(parref,rowid)),"^",6)
    .s:ARCRLTimeFrom'="" ARCRLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(ARCRLTimeFrom,1)  //转换时间
    .s:ARCRLTimeTo'="" ARCRLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(ARCRLTimeTo,1)      //转换时间
    .s ARCRLClinicType=$p($g(^ARCRL(parref,rowid)),"^",12)
    .s ARCRLClinicType=$case(ARCRLClinicType,"O":"门诊","E":"急诊","I":"住院","H":"体检","N":"新生儿",:"")
    .if ((ARCRLCTHospitalDR=HospId)||(HospId=""))&((ARCRLOrdLocDR=PatLoc)||(PatLoc=""))&((ARCRLRecLocDR=RecLoc)||(RecLoc=""))&((ARCRLCTHospitalDR=HospId)||(HospId="")) d
    ..d OutputRow

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ARCRLRowId,ARCRLOrdLocDR,ARCRLOrdLocDesc,ARCRLRecLocDR,ARCRLRecLocDesc,ARCRLOrderPriorityDR,ARCRLOrderPriorityDesc,ARCRLDefaultFlag,ARCRLDateFrom,ARCRLDateTo,ARCRLTimeFrom,ARCRLTimeTo,ARCRLCTHospitalDR,ARCRLCTHospitalDesc,ARCRLClinicType,ARCRLFunction)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator：钟荣枫
/// CreatDate: 2020-04-03
/// Description：数据重复验证方法
/// Table：User.ARCItmRecLoc
/// Input：ParRef 医嘱项id,id, ARCRLOrdLocDR 病人科室id, ARCRLRecLocDR 接收科室id,str
/// Return："1"(数据重复),"0"(数据不重复)
/// W ##class(web.DHCBL.CT.ARCItmRecLoc).FormValidate("4","","2","2","^^^65472^^")
ClassMethod FormValidate(ParRef As %String, id As %String, ARCRLOrdLocDR As %String, ARCRLRecLocDR As %String, Str As %String) As %String
{
    n (ParRef,id, ARCRLRecLocDR, ARCRLOrdLocDR, Str)
    q:(id="")&&(ParRef="") 0
    if ParRef="" s ParRef=$p(id,"||",1)
    s ARCRLOrderPriorityDR=$p(Str,"^",1)
    s ARCRLTimeFrom=$p(Str,"^",2)
    s ARCRLTimeTo=$p(Str,"^",3)
    s ARCRLDateFrom=$p(Str,"^",4)
    s ARCRLDateTo=$p(Str,"^",5)
    s ARCRLCTHospitalDR=$p(Str,"^",6)
    s ARCRLClinicType=$p(Str,"^",7)
	s:ARCRLDateFrom'="" ARCRLDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(ARCRLDateFrom)
	s:ARCRLDateTo'="" ARCRLDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(ARCRLDateTo)
	s:ARCRLTimeFrom'="" ARCRLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(ARCRLTimeFrom)
	s:ARCRLTimeTo'="" ARCRLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(ARCRLTimeTo)
	
	s flag=0
	if ARCRLOrdLocDR'=""  //病人科室不为空时，判断病人科室对应的医院 是否有这个医嘱项的权限
	{
		s ARCRowID=ParRef_"||1"
		s OrdLocHospitalDR=$p($g(^CTLOC(ARCRLOrdLocDR)),"^",22)     //病人科室所在医院
		s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",ARCRowID,OrdLocHospitalDR)
		if (showflag="N") //病人科室对应的医院 没有这个医嘱项的权限时返回2
		{
			s flag=2
			q flag	
		}
		
	}
	
	s Sub=0
    for
    {
        s Sub=$o(^ARCRL(ParRef,Sub)) q:(Sub="")||(flag'=0) 
        s OrdLocDR=$p($g(^ARCRL(ParRef,Sub)),"^",1) //病人科室
        continue:(OrdLocDR'=ARCRLOrdLocDR)
        s RecLocDR=$p($g(^ARCRL(ParRef,Sub)),"^",2) //接收科室
        continue:(RecLocDR'=ARCRLRecLocDR)
        s DateFrom=$p($g(^ARCRL(ParRef,Sub)),"^",8) //开始日期
        s DateTo=$p($g(^ARCRL(ParRef,Sub)),"^",9)   //结束日期
        s TimeFrom=$p($g(^ARCRL(ParRef,Sub)),"^",5) //开始时间
        s TimeTo=$p($g(^ARCRL(ParRef,Sub)),"^",6)   //结束时间
        s HospitalDR=$p($g(^ARCRL(ParRef,Sub)),"^",7)   //医院
        continue:(HospitalDR'=ARCRLCTHospitalDR)
        s PriorityDR=$p($g(^ARCRL(ParRef,Sub)),"^",10)  //医嘱优先级
        continue:(PriorityDR'=ARCRLOrderPriorityDR)     
        s ClinicType=$p($g(^ARCRL(ParRef,Sub)),"^",12)  
        continue:((ClinicType'="")&&(ARCRLClinicType'="")&&(ClinicType'=ARCRLClinicType))
        
        s Pid=ParRef_"||"_Sub
        if ((id="")||((id'="")&&(Pid'=id)))     //新增
        {
            if (ARCRLDateFrom'="")&&(DateFrom'="")  //开始日期是否为空
            {
                //日期没有交叉
                if ((ARCRLDateTo="")&&(DateTo=""))||((ARCRLDateTo'="")&&(DateFrom<=ARCRLDateTo)&&(DateFrom>=ARCRLDateFrom))||((DateTo'="")&&(ARCRLDateFrom<=DateTo)&&(ARCRLDateFrom>=DateFrom))             
                {
                    if ((ARCRLTimeFrom="")&&(ARCRLTimeTo=""))||((TimeFrom="")&&(TimeTo=""))     //时间范围为空
                    {
                        
                        s flag=1  //返回重复标志
                        q
                    }
                    //判断时间是否交叉
                    if ((TimeFrom'="")&&(TimeTo'="")&&(ARCRLTimeFrom'="")&&(ARCRLTimeTo'="")&&(((ARCRLTimeFrom>TimeTo)&&(ARCRLTimeTo>TimeTo))||((ARCRLTimeFrom<TimeFrom)&&(ARCRLTimeTo<TimeFrom))))
                    {
                        //无交叉，不重复
                    }
                    else{
                        s flag=1  //返回重复标志
                        q
                    }
                }
            }
        }
        else        //修改
        {
            s flag=0 //返回不重复标志
        }
        
    }
    q flag
}

/// Function: 新增医嘱项接收科室
/// Creator:  sunfengchao
/// CreateDate:2013-5-22 
/// Debug:    w ##class(web.DHCBL.CT.ARCItmRecLoc).AddReceiveLoc("4||1^7^3^^4/4/2020^^^^false^^3")
/// Others: 
ClassMethod AddReceiveLoc(SaveDataStr As %String) As %String
{
    n (SaveDataStr,%session)
    Set Subscript=""
    Set arcimrowid=$p(SaveDataStr,"^",1)
    Set ARCIMSub=$p(arcimrowid,"||",1)
    Set Subscript=$o(^ARCRL(ARCIMSub,Subscript),-1)
    set Subscript=Subscript+1    
    Set patlocdr=$p(SaveDataStr,"^",2)
    Set reclocdr=$p(SaveDataStr,"^",3)
    Set priordr=$p(SaveDataStr,"^",4)
    s datefrom=$p(SaveDataStr,"^",5)
    Set dateto=$p(SaveDataStr,"^",6)
    s timefrom=$p(SaveDataStr,"^",7)
    Set timeto=$p(SaveDataStr,"^",8)
    s DefaultFlag=$p(SaveDataStr,"^",9)
    //ARCRLFunction  10  add @20160623
    //ARCRLCTHospitalDR  11
    Set function=$p(SaveDataStr,"^",10)
    if function="" s function="Execute"
    Set hospditaldr=$p(SaveDataStr,"^",11)
    Set ARCRLClinicType=$p(SaveDataStr,"^",12)
    
    Set:datefrom'="" datefrom= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)
    Set:datefrom="" datefrom=+$h
    Set:dateto'="" dateto=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
    Set:timefrom'="" timefrom=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(timefrom,1)
    Set:timeto'="" timeto=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(timeto,1)

    If ((DefaultFlag="true")||(DefaultFlag="Y")) Do 
    .Set DefaultFlag="Y"
    Else  Do
    .Set DefaultFlag="N"
    s str=priordr_"^"_timefrom_"^"_timeto_"^"_datefrom_"^"_dateto _"^"_hospditaldr_"^"_ARCRLClinicType
    s flag=..FormValidate(ARCIMSub,"",patlocdr,reclocdr,str)
    if (flag=1)         //校验重复
    {
        q "{success:'false',info:'与另一条相同接收科室记录的日期时间冲突，请确认!'}"
    }
    elseif (flag=2) 
    {
	    q "{success:'false',errorinfo:'医嘱项与病人科室不在同一个医院组，请确认！'}"
    }
    if (DefaultFlag="Y")
	{
		//修改默认科室
		d ..GetDefRecLoc(ARCIMSub,"",patlocdr,priordr_"^"_timefrom_"^"_timeto_"^"_datefrom_"^"_dateto_"^"_hospditaldr_"^"_ARCRLClinicType_"^1")
	 
	}
    //新增时，日志
    s eobj = ##class(web.Entity.CT.ARCItmRecLoc).%New()
    s eobj.ARCRLRowId=""
    s eobj.ARCRLARCIMDR=arcimrowid
    s eobj.ARCRLOrdLocDR=patlocdr
    s eobj.ARCRLRecLocDR=reclocdr
    s eobj.ARCRLOrderPriorityDR=priordr
    s eobj.ARCRLDefaultFlag=DefaultFlag
    s eobj.ARCRLTimeFrom=timefrom
    s eobj.ARCRLTimeTo=timeto
    s eobj.ARCRLDateFrom=datefrom
    s eobj.ARCRLDateTo=dateto
    s eobj.ARCRLCTHospitalDR=hospditaldr
    s eobj.ARCRLClinicType=ARCRLClinicType
    s eobj.ARCRLFunction=function
    
    Tstart
    &SQL(insert into ARC_ItmRecLoc
        (ARCRL_Function,ARCRL_ARCIMSub,ARCRL_Subscript,ARCRL_OrdLoc_DR,ARCRL_RecLoc_DR,ARCRL_ARCIM_DR,ARCRL_OrderPriority_DR,ARCRL_DefaultFlag,ARCRL_DateFrom,ARCRL_DateTo,ARCRL_TimeFrom,ARCRL_TimeTo,ARCRL_CTHospitalDR,ARCRL_ClinicType)
        values(:function,:ARCIMSub,:Subscript,:patlocdr,:reclocdr,:arcimrowid,:priordr,:DefaultFlag,:datefrom,:dateto,:timefrom,:timeto,:hospditaldr,:ARCRLClinicType))
    If SQLCODE=0
    {
        Tc
        s ARCIMDesc=$p($g(^ARCIM($p(arcimrowid,"||",1),$p(arcimrowid,"||",2),1)),"^",2)
        s ARCRLOrdLocDRDesc="",ARCRLRecLocDRDesc=""
        s:eobj.ARCRLOrdLocDR'="" ARCRLOrdLocDRDesc=$p($g(^CTLOC(eobj.ARCRLOrdLocDR)),"^",2)
        s:eobj.ARCRLRecLocDR'="" ARCRLRecLocDRDesc=$p($g(^CTLOC(eobj.ARCRLRecLocDR)),"^",2)
        s DescLog=ARCIMDesc_"-"_ARCRLOrdLocDRDesc_"-"_ARCRLRecLocDRDesc
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItmRecLoc","User.ARCItmRecLoc","医嘱项接收科室",$SYSTEM.SQL.GetROWID(),DescLog,"A",eobj)
        d eobj.%Close()
        Quit "{success:'true',info:'添加成功!',id:'"_$SYSTEM.SQL.GetROWID()_"'}"
    }
    else
    {
        Trollback
        Quit "{success:'false',info:'添加失败, 请重新操作!'}"
    }
}

/// Function: 修改医嘱项接收科室
/// Creator:  sunfengchao
/// CreaeDate:2013-5-22 
/// Debug:    w ##class(web.DHCBL.CT.ARCItmRecLoc).UpdateRecLoc("4||3^2^2^^4/4/2020^^^^false")
ClassMethod UpdateRecLoc(editordrecloc As %String) As %String
{
    n (editordrecloc,%session)
    Set ARCRLRowId=$p(editordrecloc,"^",1)
    Set patlocdr=$p(editordrecloc,"^",2)
    Set reclocdr=$p(editordrecloc,"^",3)
    Set priordr=$p(editordrecloc,"^",4)
    s datefrom=$p(editordrecloc,"^",5)
    s dateto=$p(editordrecloc,"^",6) 
    Set timefrom=$p(editordrecloc,"^",7)
    Set timeto=$p(editordrecloc,"^",8)
    S DefaultFlag=$p(editordrecloc,"^",9)
    
    //ARCRLFunction  10  add @20160623
    //ARCRLCTHospitalDR  11
    Set function=$p(editordrecloc,"^",10)
    if function="" s function="Execute"
    Set hospditaldr=$p(editordrecloc,"^",11)
    
    Set ARCRLClinicType=$p(editordrecloc,"^",12)
    
    Set:datefrom'="" datefrom= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom)
    Set:datefrom="" datefrom=+$h
    Set:dateto'="" dateto= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dateto)
    Set:timefrom'="" timefrom=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(timefrom,1)
    Set:timeto'="" timeto=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(timeto,1) 
    If (DefaultFlag="true")||(DefaultFlag="Y") Do 
    .Set DefaultFlag="Y"
    Else  Do
    .Set DefaultFlag="N" 
    
    s ARCIMSub=$p(ARCRLRowId,"||",1)
    s str=priordr_"^"_timefrom_"^"_timeto_"^"_datefrom_"^"_dateto _"^"_hospditaldr_"^"_ARCRLClinicType
    s flag=..FormValidate(ARCIMSub,ARCRLRowId,patlocdr,reclocdr,str)
    if (flag=1)         //校验重复
    {
        q "{success:'false',info:'与另一条相同接收科室记录的日期时间冲突，请确认！'}"
    }
    elseif (flag=2) 
    {
	    q "{success:'false',errorinfo:'医嘱项与病人科室不在同一个医院组，请确认！'}"
    }
    if (DefaultFlag="Y")
	{
		//修改默认科室
		d ..GetDefRecLoc(ARCIMSub,ARCRLRowId,patlocdr,priordr_"^"_timefrom_"^"_timeto_"^"_datefrom_"^"_dateto_"^"_hospditaldr_"^"_ARCRLClinicType_"^1")
	 
	}
    s obj=##class(User.ARCItmRecLoc).%OpenId(ARCRLRowId)
    s bobj = ##class(web.Entity.CT.ARCItmRecLoc).%New()
    s bobj.ARCRLRowId=ARCRLRowId
    s:obj.ARCRLOrdLocDR'="" bobj.ARCRLOrdLocDR=obj.ARCRLOrdLocDR.%Id() 
    s:obj.ARCRLRecLocDR'="" bobj.ARCRLRecLocDR=obj.ARCRLRecLocDR.%Id()
    s:obj.ARCRLOrderPriorityDR'="" bobj.ARCRLOrderPriorityDR=obj.ARCRLOrderPriorityDR.%Id()
    s bobj.ARCRLDefaultFlag=obj.ARCRLDefaultFlag
    s bobj.ARCRLTimeFrom=obj.ARCRLTimeFrom
    s bobj.ARCRLTimeTo=obj.ARCRLTimeTo
    s bobj.ARCRLDateFrom=obj.ARCRLDateFrom
    s bobj.ARCRLDateTo=obj.ARCRLDateTo
    s:obj.ARCRLCTHospitalDR'="" bobj.ARCRLCTHospitalDR=obj.ARCRLCTHospitalDR.%Id()
    s bobj.ARCRLClinicType=obj.ARCRLClinicType
	s bobj.ARCRLFunction=obj.ARCRLFunction

    Tstart
    s obj = ##class(User.ARCItmRecLoc).%OpenId(ARCRLRowId)
    d obj.ARCRLOrdLocDRSetObjectId(patlocdr)
    d obj.ARCRLRecLocDRSetObjectId(reclocdr)
    d obj.ARCRLOrderPriorityDRSetObjectId(priordr)
    s obj.ARCRLDefaultFlag=DefaultFlag
    s obj.ARCRLTimeFrom=timefrom
    s obj.ARCRLTimeTo=timeto
    s obj.ARCRLDateFrom=datefrom
    s obj.ARCRLDateTo=dateto
    d obj.ARCRLCTHospitalDRSetObjectId(hospditaldr)
    s obj.ARCRLClinicType=ARCRLClinicType
    s obj.ARCRLFunction=function

    s sc=obj.%Save()
    If sc=0{
        Trollback
        Quit "{success:'false',info:'修改失败!'}"
    }
    else{
        Tc
        //修改时，日志
        s eobj = ##class(web.Entity.CT.ARCItmRecLoc).%New()
        s eobj.ARCRLRowId=ARCRLRowId
        s eobj.ARCRLOrdLocDR=patlocdr
        s eobj.ARCRLRecLocDR=reclocdr
        s eobj.ARCRLOrderPriorityDR=priordr
        s eobj.ARCRLDefaultFlag=DefaultFlag
        s eobj.ARCRLTimeFrom=timefrom
        s eobj.ARCRLTimeTo=timeto
        s eobj.ARCRLDateFrom=datefrom
        s eobj.ARCRLDateTo=dateto
        s eobj.ARCRLCTHospitalDR=hospditaldr
        s eobj.ARCRLClinicType=ARCRLClinicType
        s eobj.ARCRLFunction=function
        
        s ARCIMDesc=$p($g(^ARCIM($p(ARCRLRowId,"||",1),1,1)),"^",2)
        s ARCRLOrdLocDRDesc="",ARCRLRecLocDRDesc=""
        s:eobj.ARCRLOrdLocDR'="" ARCRLOrdLocDRDesc=$p($g(^CTLOC(eobj.ARCRLOrdLocDR)),"^",2)
        s:eobj.ARCRLRecLocDR'="" ARCRLRecLocDRDesc=$p($g(^CTLOC(eobj.ARCRLRecLocDR)),"^",2)
        s DescLog=ARCIMDesc_"-"_ARCRLOrdLocDRDesc_"-"_ARCRLRecLocDRDesc
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItmRecLoc","User.ARCItmRecLoc","医嘱项接收科室",ARCRLRowId,DescLog,"U",eobj,bobj)
        d eobj.%Close()
        Quit "{success:'true',info:'修改成功!'}"
     }
}

/// Function: 删除医嘱项接收科室
/// Creator:  sunfengchao
/// CreateDate: 2013-5-22 
/// Debug:    d ##class(web.DHCBL.CT.ARCItmRecLoc).DeleteData("")
ClassMethod DeleteData(rowid As %String) As %String
{
    N (rowid,%session)
    Quit:rowid="" "{success:'false',info:'未选择医嘱项接收科室,不能删除!'}"

    //用于保存日志
    s obj = ##class(User.ARCItmRecLoc).%OpenId(rowid)
    s eobj = ##class(web.Entity.CT.ARCItmRecLoc).%New()
    s eobj.ARCRLRowId=rowid
    s:obj.ARCRLARCIMDR'="" eobj.ARCRLARCIMDR=obj.ARCRLARCIMDR.%Id()
    s:obj.ARCRLOrdLocDR'="" eobj.ARCRLOrdLocDR=obj.ARCRLOrdLocDR.%Id()
    s:obj.ARCRLRecLocDR'="" eobj.ARCRLRecLocDR=obj.ARCRLRecLocDR.%Id()
    s:obj.ARCRLOrderPriorityDR'="" eobj.ARCRLOrderPriorityDR=obj.ARCRLOrderPriorityDR.%Id()
    s eobj.ARCRLDefaultFlag=obj.ARCRLDefaultFlag
    s eobj.ARCRLTimeFrom=obj.ARCRLTimeFrom
    s eobj.ARCRLTimeTo=obj.ARCRLTimeTo
    s eobj.ARCRLDateFrom=obj.ARCRLDateFrom
    s eobj.ARCRLDateTo=obj.ARCRLDateTo
    s eobj.ARCRLClinicType=obj.ARCRLClinicType
    s eobj.ARCRLFunction=obj.ARCRLFunction
    d obj.%Close()

    Tstart
    s sc=##class(User.ARCItmRecLoc).%DeleteId(rowid)
    if (sc=0){
        Trollback
        Quit "{success:'false',info:'删除失败!'}"
    }
    else{
        Tc
        s ARCIMDesc=$p($g(^ARCIM($p(rowid,"||",1),1,1)),"^",2)
        s ARCRLOrdLocDRDesc="",ARCRLRecLocDRDesc=""
        s:eobj.ARCRLOrdLocDR'="" ARCRLOrdLocDRDesc=$p($g(^CTLOC(eobj.ARCRLOrdLocDR)),"^",2)
        s:eobj.ARCRLRecLocDR'="" ARCRLRecLocDRDesc=$p($g(^CTLOC(eobj.ARCRLRecLocDR)),"^",2)
        s DescLog=ARCIMDesc_"-"_ARCRLOrdLocDRDesc_"-"_ARCRLRecLocDRDesc
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItmRecLoc","User.ARCItmRecLoc","医嘱项接收科室",rowid,DescLog,"D",eobj)
        d eobj.%Close()
        Quit "{success:'true',info:'删除成功!'}"
    }
}

/// Function: 批量添加医嘱项接收科室 
/// Creator:  基础数据平台 孙凤超
/// CreateDate: 2014-12-17
/// Debug: w ##class(web.DHCBL.CT.ARCItmRecLoc).MultiAddRecLoc("54523||1","3^5^^N^^^2017-03-09^2017-03-24*^1^^Y^^^2017-03-01^2017-03-15")
ClassMethod MultiAddRecLoc(rowid As %String, AddRecLocStr As %String) As %String
{
    n (AddRecLocStr,rowid,%session)
    s result=""
    q:AddRecLocStr="" "{success:'true'}"
    s RecLoclength=$length(AddRecLocStr,"*")
    for i=1:1:RecLoclength 
    {
        Set RecLocStr=$P(AddRecLocStr,"*",i)
        s addReceiveStr=rowid_"^"_$p(RecLocStr,"^",1)_"^"_$p(RecLocStr,"^",2)_"^"_$p(RecLocStr,"^",3)_"^"_$p(RecLocStr,"^",7)_"^"_$p(RecLocStr,"^",8)_"^"_$p(RecLocStr,"^",5)_"^"_$p(RecLocStr,"^",6)_"^"_$p(RecLocStr,"^",4)_"^"_"Execute"_"^"_""
        s result= ##class(web.DHCBL.CT.ARCItmRecLoc).AddReceiveLoc(addReceiveStr)
    }
    Quit result
}

/// Creator：zrf
/// CreatDate: 2022-6-29
/// Description：获取默认科室 （要求 对同一个病人科室 或者为空的，优先级相同时，不允许在同一个时间段内存在两个默认值）
/// Table：User.ARCItemCatRecLoc
/// Input:医嘱项id，，Str:优先级^开始时间^结束时间^开始日期^结束日期^医院^updateflag=1是把默认更新成N
/// w ##class(web.DHCBL.CT.ARCItmRecLoc).GetDefRecLoc("83","","366","^^^65311^65313^^") 
/// 0 不存在默认  1 存在默认
ClassMethod GetDefRecLoc(ParRef As %String, id As %String, ARCRLOrdLocDR As %String, Str As %String) As %String
{
	n (ParRef,id, ARCRLRecLocDR, ARCRLOrdLocDR, Str)
	q:(id="")&&(ParRef="") 0
	if ParRef="" s ParRef=$p(id,"||",1)
	s ARCRLOrderPriorityDR=$p(Str,"^",1)
	s ARCRLTimeFrom=$p(Str,"^",2)
	s ARCRLTimeTo=$p(Str,"^",3)
	s ARCRLDateFrom=$p(Str,"^",4)
	s ARCRLDateTo=$p(Str,"^",5)
	s ARCRLCTHospitalDR=$p(Str,"^",6)
	s ARCRLClinicType=$p(Str,"^",7)
	s updateflag=$p(Str,"^",8)
	s:ARCRLDateFrom'="" ARCRLDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(ARCRLDateFrom)
	s:ARCRLDateTo'="" ARCRLDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(ARCRLDateTo)
	s:ARCRLTimeFrom'="" ARCRLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(ARCRLTimeFrom)
	s:ARCRLTimeTo'="" ARCRLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(ARCRLTimeTo)
	
	s flag=0
	if ARCRLOrdLocDR'=""  //病人科室不为空时，判断病人科室对应的医院 是否有这个医嘱项的权限
	{
		s ARCRowID=ParRef_"||1"
		s OrdLocHospitalDR=$p($g(^CTLOC(ARCRLOrdLocDR)),"^",22)     //病人科室所在医院
		s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",ARCRowID,OrdLocHospitalDR)
		if (showflag="N") //病人科室对应的医院 没有这个医嘱项的权限时返回2
		{
			s flag=2
			q flag	
		}
	}
	
	s Sub=0
    for
    {
        s Sub=$o(^ARCRL(ParRef,Sub)) q:(Sub="")||(flag'=0) 
        s OrdLocDR=$p($g(^ARCRL(ParRef,Sub)),"^",1) //病人科室
        continue:(OrdLocDR'=ARCRLOrdLocDR)
        s RecLocDR=$p($g(^ARCRL(ParRef,Sub)),"^",2) //接收科室
        s DefaultFlag=$p($g(^ARCRL(ParRef,Sub)),"^",4)
        continue:DefaultFlag'="Y"
        s DateFrom=$p($g(^ARCRL(ParRef,Sub)),"^",8) //开始日期
        s DateTo=$p($g(^ARCRL(ParRef,Sub)),"^",9)   //结束日期
        s TimeFrom=$p($g(^ARCRL(ParRef,Sub)),"^",5) //开始时间
        s TimeTo=$p($g(^ARCRL(ParRef,Sub)),"^",6)   //结束时间
        s HospitalDR=$p($g(^ARCRL(ParRef,Sub)),"^",7)   //医院
        s PriorityDR=$p($g(^ARCRL(ParRef,Sub)),"^",10)  //医嘱优先级
        continue:(PriorityDR'=ARCRLOrderPriorityDR)     
        s ClinicType=$p($g(^ARCRL(ParRef,Sub)),"^",12)  
        
        s Pid=ParRef_"||"_Sub
        if ((id="")||((id'="")&&(Pid'=id))) 
		{
			//日期不交叉   开始日期或结束时间同一天		或开始日期同一天且结束日期同一天 但时间不交叉
			if (((ARCRLDateTo'="")&&(DateFrom>=ARCRLDateTo))||((DateTo'="")&&(ARCRLDateFrom>=DateTo)))||((TimeFrom'="")&&(TimeTo'="")&&(ARCRLTimeFrom'="")&&(ARCRLTimeTo'="")&&(((ARCRLTimeFrom>TimeTo)&&(ARCRLTimeTo>TimeTo))||((ARCRLTimeFrom<TimeFrom)&&(ARCRLTimeTo<TimeFrom))))
			{
				 continue
			}
			s flag=1 
			if (updateflag=1)	//修改默认
			{
				s rowid=ParRef_"||"_Sub
    
				s updobj=##class(User.ARCItmRecLoc).%OpenId(rowid)
				s updateeobj=##class(web.Entity.CT.ARCItmRecLoc).%New()
				s updateeobj.ARCRLRowId=rowid
				s updateeobj.ARCRLARCIMDR=ParRef_"||1"
				if $IsObject(updobj.ARCRLRecLocDR){
					s updateeobj.ARCRLRecLocDR = updobj.ARCRLRecLocDR.%Id() 
				}
				if $IsObject(updobj.ARCRLOrdLocDR){
					s updateeobj.ARCRLOrdLocDR = updobj.ARCRLOrdLocDR.%Id() 
				}
				s updateeobj.ARCRLFunction = updobj.ARCRLFunction
				s updateeobj.ARCRLDefaultFlag = "N"
				s updateeobj.ARCRLTimeFrom = updobj.ARCRLTimeFrom
				s updateeobj.ARCRLTimeTo = updobj.ARCRLTimeTo

				s:updateeobj.ARCRLTimeFrom'="" updateeobj.ARCRLTimeFrom=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(updateeobj.ARCRLTimeFrom,1)
				s:updateeobj.ARCRLTimeTo'="" updateeobj.ARCRLTimeTo=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(updateeobj.ARCRLTimeTo,1)

				if $IsObject(updobj.ARCRLCTHospitalDR){
					s updateeobj.ARCRLCTHospitalDR = updobj.ARCRLCTHospitalDR.%Id() 
				}
				s updateeobj.ARCRLDateFrom = updobj.ARCRLDateFrom
				s updateeobj.ARCRLDateTo = updobj.ARCRLDateTo
				s:updateeobj.ARCRLDateFrom'="" updateeobj.ARCRLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(updateeobj.ARCRLDateFrom)   // $tr($zd(updateeobj.RLDateFrom,3),"-","/")
				s:updateeobj.ARCRLDateTo'="" updateeobj.ARCRLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(updateeobj.ARCRLDateTo)
				if $IsObject(updobj.ARCRLOrderPriorityDR){
					s updateeobj.ARCRLOrderPriorityDR = updobj.ARCRLOrderPriorityDR.%Id() 
				}
				
				
				s updatebobj=##class(web.Entity.CT.ARCItmRecLoc).%New()
				s updatebobj.ARCRLRowId=rowid
				s updatebobj.ARCRLARCIMDR=ParRef_"||1"
				if $IsObject(updobj.ARCRLRecLocDR){
					s updatebobj.ARCRLRecLocDR = updobj.ARCRLRecLocDR.%Id() 
				}
				if $IsObject(updobj.ARCRLOrdLocDR){
					s updatebobj.ARCRLOrdLocDR = updobj.ARCRLOrdLocDR.%Id() 
				}
				s updatebobj.ARCRLFunction = updobj.ARCRLFunction
				s updatebobj.ARCRLDefaultFlag = updobj.ARCRLDefaultFlag
				s updatebobj.ARCRLTimeFrom = updobj.ARCRLTimeFrom
				s updatebobj.ARCRLTimeTo = updobj.ARCRLTimeTo

				if $IsObject(updobj.ARCRLCTHospitalDR){
					s updatebobj.ARCRLCTHospitalDR = updobj.ARCRLCTHospitalDR.%Id() 
				}
				s updatebobj.ARCRLDateFrom = updobj.ARCRLDateFrom
				s updatebobj.ARCRLDateTo = updobj.ARCRLDateTo
				if $IsObject(updobj.ARCRLOrderPriorityDR){
					s updatebobj.ARCRLOrderPriorityDR = updobj.ARCRLOrderPriorityDR.%Id() 
				}
				
				s sc=updobj.%Save()
				d updobj.%Close()
				If $$$ISOK(sc)
				{
					//保存日志
			        s ARCIMDesc=$p($g(^ARCIM($p(rowid,"||",1),1,1)),"^",2)
			        s ARCRLOrdLocDRDesc="",ARCRLRecLocDRDesc=""
			        s:updateeobj.ARCRLOrdLocDR'="" ARCRLOrdLocDRDesc=$p($g(^CTLOC(updateeobj.ARCRLOrdLocDR)),"^",2)
			        s:updateeobj.ARCRLRecLocDR'="" ARCRLRecLocDRDesc=$p($g(^CTLOC(updateeobj.ARCRLRecLocDR)),"^",2)
			        s DescLog=ARCIMDesc_"-"_ARCRLOrdLocDRDesc_"-"_ARCRLRecLocDRDesc
			        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItmRecLoc","User.ARCItmRecLoc","医嘱项接收科室",rowid,DescLog,"U",updateeobj,updatebobj)
				}
			}
		}
    }
				
	q flag
}

}
