Import sqluser

Class web.DHCST.INCItmLoc Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 插入	
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
///  inci  - 库存项rowid
///  loc - 科室rowid
/// Return:
///   <0 - 失败
///   串 - 科室库存项目rowid(INC_ItmLoc)
ClassMethod Insert(inci As %String, loc As %String) As %String
{
  n (inci,loc)
  &sql(select %ID into :incil from inc_itmloc where incil_inci_parref=:inci and incil_ctloc_dr=:loc)
  q:'SQLCODE -1   //已经存在
  &sqL(insert into inc_itmloc (incil_inci_parref,incil_ctloc_dr)  
   values(:inci,:loc) )
  q:SQLCODE'=0 -2 
  s incil=%ROWID
  &sql(insert into dhc_incitmloc (incil_incil_dr) values (:incil) )
  q:SQLCODE'=0 -3 
  q incil
}

/// 检索科室库存项
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
///   incil -科室库存项rowid 
/// Return:
///   科室库存项记录数据串(INC_ItmLoc)_$C(1)_科室库存项记录附加表数据串
/// 
ClassMethod Select(incil As %String) As %String
{
  n (incil)
  k PLIST
  s result=""
  &sql(select * into :PLIST() from inc_itmloc where %ID=:incil)
  q:SQLCODE ""
  s cnt=$o(PLIST(""),-1)
  f i=1:1:cnt d
  .i result="" s result=$G(PLIST(i))
  .e  s result=result_"^"_$G(PLIST(i))
  
  k PLIST
  s result1=""
  &sql(select * into :PLIST() from dhc_incitmloc where incil_incil_dr=:incil)
  s cnt=$o(PLIST(""),-1)
  f i=1:1:cnt d
  .i result1="" s result1=$G(PLIST(i))
  .e  s result1=result1_"^"_$G(PLIST(i))
  
  q result_$c(1)_result1
}

/// 删除一条记录
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
///    incil  -科室库存项rowid
/// Return:
///    0 - success
///    <0 - failure
ClassMethod Delete(incil As %String) As %String
{
 q:incil="" -1
 s lockName="INCItmLoc"_incil
 q:##class(web.DHCST.Common.AppCommon).Lock(lockName)<0 -2
 ts
 &sql(DELETE FROM DHC_INCItmLoc where INCIL_INCIL_DR=:incil)	
 i SQLCODE'=0 tro  d ..uLock(lockName)  q -2
 &sql(DELETE FROM INC_ItmLoc where %ID=:incil)	
 i SQLCODE'=0 tro  d ..uLock(lockName)  q -3
 tc
 d ..uLock(lockName)	
 q 0
}

/// 是否允许删除INC_ItmLoc记录
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
/// incil  -科室库存项rowid
/// Return:
///  0 - allowed
///  <0 - not allowed
ClassMethod AllowDel(incil As %String) As %String
{
  //检查表INC_ItmLoc是否有批次子表
  s inci=+incil
  s ilch=$P(incil,"||",2)
  s ch=$O(^INCI(inci,"IL",ilch,"LB",0))
  q:+ch>0 -1
  q 0
}

/// 批量更新科室库存项目信息
/// Author:zhangdongmei
/// Date:2012-08-23
/// Argu:
///  科室库存id^货位id^补货标准^补货数量^库存上限^库存下限
///  ^锁定标志^备用货位^强制库存标志^配液打包标志^管理药标志^管理组id^采购标志
/// Return:
///   0 : 成功
///   -1:没有要保存的数据
///   -2: - 失败
///   w ##class(web.DHCST.INCItmLoc).Save("524||3^^240^600^1200^120^N^^^^1^^^Y^^")
ClassMethod Save(ListData As %String) As %String
{
	n (ListData,%session)
	
	q:ListData="" -1
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s Len=$l(ListData,rowDelim)
	s Err=""  
	f i=1:1:Len   d
	.s Detail=$p(ListData,rowDelim,i)
	.s Incil=$p(Detail,"^",1)
	.q:Incil=""
	.s IncDesc=$p(^INCI(+Incil,1),"^",2)
	.s Data=$p(Detail,"^",2,$l(Detail))
	.s Ret=..Update(Incil,Data)
	.i Ret'=0  d
	..i Err="" d
	...s Err=IncDesc
	..e  d
	...s Err=Err_","_IncDesc
	q:Err="" 0
	q -2_":"_Err
}

/// 更新科室库存项目信息
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
///  incil  - 科室库存项rowid
///  data - 数据串
/// Return:
///   0 - 成功
///   <0 - 失败
ClassMethod Update(incil As %String, data As %String) As %String
{
 //n (%session)
 s AppName="DHCSTCOMMON"
 s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
 s incsb=$p(data,"^",1)  //货位rowid
 s repLevel=$p(data,"^",2)  //补货标准
 s repQty=$p(data,"^",3)   //补货数量
 s maxQty=$p(data,"^",4)   //库存上限
 s minQty=$p(data,"^",5)  //库存下限
 s lockFlag=$p(data,"^",6)   //锁定标志
 s spareStkBin=$p(data,"^",7)  //备用货位
 s enforceStk=$p(data,"^",8)  //强制库存标志
 s pivaPack=$p(data,"^",9)     //
 s manFlag=$p(data,"^",10)     //管理药标志
 s lmGrp=$p(data,"^",11)     //管理组rowid
 s planFlag=$p(data,"^",12)   //采购标志
 s pivaFlag=$p(data,"^",13)   //是否配液
 s drugsendFlag=$p(data,"^",14)   //发药标志
 s drugpackFlag=$p(data,"^",15)   //打包标志
 s InLockFlag=$p(data,"^",16)   //住院加锁
 s uomid=$p(^INCI(+incil,1),"^",10)
 s puruomid=$p(^INCI(+incil,3),"^",6)
 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puruomid,uomid)
 s:maxQty'="" maxQty=maxQty*fac     //转换成基本单位对应的数量  //空*任何数等于0，此处要判断是否为空再乘以fac 2020-02-15 yangsj
 s:minQty'="" minQty=minQty*fac
 s:repQty'="" repQty=repQty*fac
 s:repLevel'="" repLevel=repLevel*fac
 s OldJson=##class(web.DHCST.Common.JsonObj).GetValue("INC_ItmLoc",incil)
 s locDesc=##class(User.INCItmLoc).%OpenId(incil,0).INCILCTLOCDR.CTLOCDesc
 s inciDesc=$p(^INCI(+incil,1),"^",2)
 ts
 s $ZT="Error^DHCSTERROR"
 s obj=##class(User.INCItmLoc).%OpenId(incil)	
 s obj.INCILRepLev=repLevel
 s obj.INCILRepQty=repQty
 s obj.INCILMaxQty=maxQty
 s obj.INCILMinQty=minQty
 s obj.INCILINCSBDR=##class(User.INCStkBin).%OpenId(incsb,0)
 s sc=obj.%Save()
 if $$$ISERR(sc) q -1
 i RecordTraceFlag="Y" d
 .s JsonStr=##class(web.DHCST.Common.JsonObj).GetValue("INC_ItmLoc",incil)
 .i JsonStr'=OldJson d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("INC_ItmLoc","User.INCItmLoc","科室库存信息",incil,locDesc_":"_inciDesc,"U",JsonStr,OldJson)
 s err=0
 s dINCIL=""
 &sql(select %ID into :dINCIL from dhc_incitmloc where incil_incil_dr=:incil)
 i $G(dINCIL)'="" d
 .s obj1=##class(User.DHCIncItmLoc).%OpenId(dINCIL)
 .s OldJson=##class(web.DHCST.Common.JsonObj).GetValue("DHC_IncItmLoc",dINCIL)
 e  d
 .s obj1=##class(User.DHCIncItmLoc).%New()
 .s obj1.INCILINCILDR=##class(User.INCItmLoc).%OpenId(incil,0)
 .s OldJson=""
 s tmpLockFlag=obj1.INCILLockFlag
 s tmpInLockFlag=obj1.INCILInLock
 s obj1.INCILLockFlag=lockFlag
 s obj1.INCILLMGRPDR=##class(User.DHCLocManGrp).%OpenId(lmGrp,0)
 s obj1.INCILPIVAPack=pivaPack
 s obj1.INCILPLANFLAG=planFlag
 s obj1.INCILSpareStkBin=spareStkBin
 s obj1.INCILUSEFLAG=manFlag
 s obj1.INCILEnforceStock=enforceStk
 s obj1.INCILPIVA=pivaFlag
 s obj1.INCILDrugSendFlag=drugsendFlag
 s obj1.INCILDrugPackFlag=drugpackFlag
 s obj1.INCILInLock=InLockFlag
 i (tmpLockFlag'=lockFlag)||(tmpInLockFlag'=InLockFlag)  d
 .s obj1.INCILLockDate=+$h
 .s obj1.INCILLockTime=$p($h,",",2)
 .i $d(%session) s obj1.INCILLockUserDr=##class(User.SSUser).%OpenId($Get(%session.Data("LOGON.USERID")),0)
 
 
 s sc=obj1.%Save() 
 i err=0 tc
 s dINCIL=obj1.%Id()
 if $$$ISERR(sc) tro  s err=-2 q
 i RecordTraceFlag="Y" d
 .s JsonStr=##class(web.DHCST.Common.JsonObj).GetValue("DHC_IncItmLoc",dINCIL)
 .i OldJson'="" d
 ..i OldJson'=JsonStr d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_IncItmLoc","User.DHCIncItmLoc","科室库存附加信息",dINCIL,locDesc_":"_inciDesc,"U",JsonStr,OldJson)
 .e  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_IncItmLoc","User.DHCIncItmLoc","科室库存附加信息",dINCIL,locDesc_":"_inciDesc,"A",JsonStr)
 q err
}

/// 解锁
/// Author:zhwh
/// Date:2012-7-23
/// Argu:
/// lockName - 锁名称
ClassMethod uLock(lockName As %String)
{
 q:lockName="" 
 d ##class(web.DHCST.Common.AppCommon).UnLock(lockName)	
 q
}

/// 库存项\科室列表
/// Author:zhwh
/// Date:2012-7-23
/// Argu:
///     inci  -库存项rowid
Query ItmLoc(inci As %String) As %SQLQuery(CONTAINID = 1)
{
  SELECT %ID incil,INCIL_INCI_ParRef->inci_code inciCode,INCIL_INCI_ParRef->inci_desc inciDesc,
   incil_ctloc_dr loc,incil_ctloc_dr->ctloc_desc locDesc FROM INC_ItmLoc
    where INCIL_INCI_ParRef=:inci
}

/// 取库存项\科室列表数据(json)
/// Author:zhwh
/// Date:2012-7-23
/// Argu:
///     inci  -库存项rowid
/// Return:
///    库存项\科室列表数据串(json)
ClassMethod jsItmLoc(StrPar As %String) As %String
{
 s inci=$p(StrPar,"^",1)
 s result=##class(%Library.ResultSet).%New("web.DHCST.INCItmLoc:ItmLoc")
 s sc=result.Execute(inci)
 if $$$ISERR(sc) q ""
 //
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
 s count = 0
 s resultString = ""
 //s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  
  s tmp=ret
  s count = count+1

  //CONTINUE:count<(Start+1)
  //CONTINUE:count>end			
	
  d json.InsertRowData(tmp)
 }
 d result.Close()
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

/// 科室库存项目数据串(json)
/// Author:zhwh
/// Date:2012-07-24
/// Argu:
/// Start
/// Limit
/// Sort
/// Dir
/// StrPar
/// Return:
///   数据串(json)
ClassMethod jsLocItm(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String) As %String
{
 s qPar=Sort_"^"_Dir
 s Loc=$p(StrPar,"^",1)
 s result=##class(%Library.ResultSet).%New("web.DHCST.INCItmLoc:LocItm")
 s sc=result.Execute(qPar,Loc)
 if $$$ISERR(sc) q ""
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  
  s tmp=ret
  s count = count+1

  CONTINUE:count<(Start+1)
  CONTINUE:count>end			
	
  d json.InsertRowData(tmp)
 }
 d result.Close()
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

///  科室\库存项列表
///  Author:zhwh
///  Date:2012-7-23
///  Argu:
///      Loc  - 科室rowid
///      
Query LocItm(Loc As %String) As %Query(ROWSPEC = "incil:%String,inci:%String,code:%String,desc:%String,loc:%String,locDesc:%String")
{
}

ClassMethod LocItmExecute(ByRef qHandle As %Binary, qPar As %String, Loc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 q:Loc="" $$$OK
 s Sort=$P(qPar,"^",1)
 s Dir=$P(qPar,"^",2)

 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 
 s orderFieldName=""
 s Sort=$$ALPHAUP^SSUTIL4(Sort)
 s:Sort="CODE" orderFieldName="code"
 s:Sort="DESC" orderFieldName="description"
 s:Sort="LOC" orderFieldName="loc"
 s:Sort="LOCDESC" orderFieldName="locDesc"
	 
 s sql="SELECT %ID incil,"
 s sql=sql_"INCIL_INCI_ParRef->inci_code code,"
 s sql=sql_"INCIL_INCI_ParRef->inci_desc description,"
 s sql=sql_"incil_ctloc_dr loc,"
 s sql=sql_"incil_ctloc_dr->ctloc_desc locDesc" 
 s sql=sql_" FROM INC_ItmLoc"
 s sql=sql_" where INCIL_CTLOC_DR="_Loc
 
 i orderFieldName'="" d
 .s sql=sql_" Order BY "_orderFieldName_" "_Dir
 
 //w sql,!
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute(Loc)
 while(xrs.Next())
 {
	s incil=xrs.Data("incil")
	s inci=+incil
	s code=xrs.Data("code")
	s desc=xrs.Data("description")
	s loc=xrs.Data("loc")
	s locDesc=xrs.Data("locDesc")
	d OutPutRow 
 }
 Quit $$$OK
OutPutRow
 s Data=$lb(incil,inci,code,desc,loc,locDesc)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod LocItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocItmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LocItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocItmExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 检索科室库存项目(json)
/// Author:zhwh
/// Date:2012-07-25
/// argu:
///   Start
///   Limit
///   Sort
///   Dir
///   StrPar - 参数串
/// Return:
/// 
///  科室库存项目记录串(json)
/// w ##class(web.DHCST.INCItmLoc).jsDHCSTLocItm(0,30,"","","102^^1^0^^^^","590")
ClassMethod jsDHCSTLocItm(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String, User As %String = "") As %String
{
	s pid=..NewPid()
	q:Limit=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	Set $ZT="ERRORjsDHCSTLocItm"
	s qPar=Sort_"^"_Dir
	s Loc=$p(StrPar,"^",1) 		 //	-科室RowId
	s INCI=$p(StrPar,"^",2) 	  		 //-库存项RowId
	s SCG =$p(StrPar,"^",3) 				 //- 类组rowid
	s:SCG="" SCG=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(User,..sssCode())   //用户类组串
	s IncludeNotUse=$p(StrPar,"^",4) 	   //-包含"不可用"
	s SB=$p(StrPar,"^",5) 				  //- 货位rowid
	s StkBinDesc =$p(StrPar,"^",6) 		  //- 货位名称
	s StkQtyType=$p(StrPar,"^",7) 	  	 //- 库存类型(-1:负库存,0:零库存,1:正库存,2:所有)
	s Lmg=$p(StrPar,"^",8) 	 			 //-  管理组RowId
	s LockFlagCon=$p(StrPar,"^",9)
	s result=##class(%Library.ResultSet).%New("web.DHCST.INCItmLoc:DHCSTLocItm")
	s sc=result.Execute(qPar,Loc,INCI,SCG,IncludeNotUse,SB,StkBinDesc,StkQtyType,Lmg,LockFlagCon)
	i $$$ISERR(sc) q ""
	s colNum=result.GetColumnCount()
	s end = Start+Limit 
	i $$$ISERR(sc) q ##class(web.DHCSTEXTCOMMON).GetNoJson()
	i $zcvt(Sort,"U")["QTY" s isNum="Y"
	e  s isNum=""
	d ##class(web.DHCST.Common.Display).RSToJson(result,Sort,Dir,Start,Limit,isNum)
	q ""
    
ERRORjsDHCSTLocItm
    //遇报错,则先kill TMP
    s Error=$$Error^DHCSTERROR()
    Set Method=	"##class(web.DHCST.INCItmLoc).jsDHCSTLocItm"
	Set ErrorMsg=Method_"("""_Start_""","""_Limit_""","""_StrPar_""")"_"</br>"_Error
	k ^TMP("DHCST","INCItmLoc","jsDHCSTLocItm",pid)  
	q "{Error:'"_ErrorMsg_"'}"
}

/// 检索科室库存项目
/// Author：zhwh
/// Date:2012-07-25
/// Argu:
///   Loc  			-科室RowId
///   INCI  		-库存项RowId
///   SCG 			- 类组rowid
///   IncludeNotUse  -包含"不可用"
///   SB			 - 货位rowid
///   StkBinDesc 	 - 货位名称
///   StkQtyType  	- 库存类型("-1":负库存,"0":零库存,"1":正库存,"":所有)
///   Lmg 			-  管理组RowId
/// 
Query DHCSTLocItm(qPar As %String, Loc As %String, INCI As %String, SCG As %String, IncludeNotUse As %String, SB As %String, StkBinDesc As %String, StkQtyType As %String, Lmg As %String, LockFlagCon = "") As %Query(ROWSPEC = "incil:%String,inci:%String,code:%String,desc:%String,spec:%String,manf:%String,pUom:%String,pUomDesc:%String,bUom:%String,bUomDesc:%String,maxQty:%String,minQty:%String,stkQty:%String,avaQty:%String,repQty:%String,repLev:%String,incsb:%String,sbDesc:%String,phcpoCode:%String,fsb:%String,lockFlag:%String,spStkBin:%String,pivaPack:%String,manFlag:%String,inciLmg:%String,inciLmgDesc:%String,planFlag:%String,NotUseFlag:%String,sp:%String,pivaflag:%String,drugsendflag:%String,drugpackflag:%String,lastUpdUser:%String,lastUpdDate:%String,lastUpdTime:%String,InLockFlag")
{
}

ClassMethod DHCSTLocItmExecute(ByRef qHandle As %Binary, qPar As %String, Loc As %String, INCI As %String, SCG As %String, IncludeNotUse As %String, SB As %String, StkBinDesc As %String, StkQtyType As %String, Lmg As %String, LockFlagCon = "") As %Status
{

 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:Loc="" $$$OK
 s HospId=$p(^CTLOC(Loc),"^",22)
 
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)
 
 s orderFieldName=""
 s Sort=$$ALPHAUP^SSUTIL4(Sort)
 s:Sort="CODE" orderFieldName="code"
 s:Sort="DESC" orderFieldName="descx"
 s:Sort="STKBIN" orderFieldName=""
 s:Sort="NOTUSEFLAG" orderFieldName="NotUseFlag"
 s:Sort="STKQTY" orderFieldName="stkQty"
 s:Sort="AVAQTY" orderFieldName="avaQty"
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 s sql=..GetLocItmSQL4(Loc)   //liangqiang统一调用这个
 i orderFieldName'="" d
 .s sql=sql_" Order By "_orderFieldName_" "_Dir
 .
 ;w sql,! 
 s xrs=##class(%ResultSet).%New() 
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) q $$$OK
 
 while (xrs.Next())
 {
  s incil=xrs.Data("incil")
  s inci=xrs.Data("inci")
  i INCI'="" continue:inci'=INCI
  
  s grpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci) 
  s inciScg=$P(grpInfo,"^",5)
  s scgType=$P(grpInfo,"^",3)
  continue:scgType'=..sssCode()
  continue:SCG=""
  //i SCG'=""  continue:inciScg'=SCG
  i SCG'=""  continue:("^"_SCG_"^")'[("^"_inciScg_"^")
  s inciNotUse=xrs.Data("NotUseFlag")
  i inciNotUse="" s inciNotUse="N"
  i +IncludeNotUse=0 continue:inciNotUse="Y"  //不包含"不可用"  
  s stkbinret=##class(web.DHCST.INCStkBin).GetInciBinStr(incil,SB,StkBinDesc) //liangqiang采用新货位表
  s stkchkflag=$p(stkbinret,":",1)
  s stkbinstr=$p(stkbinret,":",2)
  i SB'="" continue:stkchkflag=0
  i StkBinDesc'="" continue:stkchkflag=0
  s incsb=stkbinstr
  s sbDesc=incsb
  s code=xrs.Data("code")
  s desc=xrs.Data("descx")

  s avaQty=xrs.Data("avaQty")
  s dirtyQty=xrs.Data("dirtyQty")
  s avaQty=avaQty-dirtyQty	;可用库存减去占用数
  s maxQty=xrs.Data("maxQty")
  s minQty=xrs.Data("minQty")
  s repQty=xrs.Data("repQty")
  s repLev=xrs.Data("repLev")
  
  s phcpoCode=xrs.Data("phcpoCode")
  s fsb=xrs.Data("fsb")
  s stkQty=xrs.Data("stkQty")
  s pUom=xrs.Data("pUom")
  s pUomDesc=xrs.Data("pUomDesc")
  s bUom=xrs.Data("bUom")
  s bUomDesc=xrs.Data("bUomDesc")
  s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,bUom)
  i +fac=0 s fac=1
  //换算为入库单位
  //为空则不计算，否则空会计算成0 2020-02-15 yangsj
  s avaQty=avaQty/fac  
  s:maxQty'="" maxQty=maxQty/fac
  s:minQty'="" minQty=minQty/fac
  s:repQty'="" repQty=repQty/fac
  s:repLev'="" repLev=repLev/fac
  s stkQty=stkQty/fac
  s stkQty=$fn(stkQty,"",3)
  s avaQty=$fn(avaQty,"",3)
  s inciLmg ="",lockFlag="",spStkBin="",pivaPack="",manFlag="",inciLmgDesc="",planFlag=""
  s pivaflag="",drugsendflag="",drugpackflag="",lockUser="",lockDate="",lockTime="",inLockFlag=""
  &sql(select INCIL_LockFlag,INCIL_SpareStkBin,INCIL_PivaPack,INCIL_USEFLAG,INCIL_LMGRP_DR,INCIL_LMGRP_DR->LMG_Desc,INCIL_PlanFlag,INCIL_PIVA,INCIL_DrugSendFlag,INCIL_DrugPackFlag,INCIL_LockUser_Dr,INCIL_LockDate,INCIL_LockTime,INCIL_InLock 
    into :lockFlag,:spStkBin,:pivaPack,:manFlag,:inciLmg,:inciLmgDesc,:planFlag,:pivaflag,:drugsendflag,:drugpackflag,:lockUser,:lockDate,:lockTime,:inLockFlag From dhc_incitmloc where INCIL_INCIL_dr=:incil)
  
  i Lmg'=""  continue:Lmg'=inciLmg
  i StkQtyType="-1" continue:stkQty'<0 //负库存
  i StkQtyType="0" continue:stkQty'=0   // 0 库存
  i StkQtyType="1" continue:stkQty'>0  //  正库存
  
  continue:(LockFlagCon="ALL")&&(lockFlag'="Y")&&(inLockFlag'="Y")
  continue:(LockFlagCon="IN")&&(inLockFlag'="Y")
  continue:(LockFlagCon="OUT")&&(lockFlag'="Y")
  
   //i StkQtyType=""  //所有
  s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
  s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3)
  s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inci,+$h,pUom,HospId,"G","")
  i lockUser'="" s lockUser=$p($g(^SSU("SSUSR",lockUser)),"^",2)
  i lockDate'="" s lockDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(lockDate,"ST")
  i lockTime'="" s lockTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(lockTime,"ST")
  i manFlag="1" s manFlag="Y"
  e  i manFlag="0" s manFlag="N"
  d OutPutRow1
 }
 
 Quit $$$OK
OutPutRow1
 s Data=$lb(incil,inci,code,desc,spec,manf,pUom,pUomDesc,bUom,bUomDesc,maxQty,minQty,stkQty,avaQty,repQty,repLev,incsb,sbDesc,phcpoCode,fsb,lockFlag,spStkBin,pivaPack,manFlag,inciLmg,inciLmgDesc,planFlag,inciNotUse,sp,pivaflag,drugsendflag,drugpackflag,lockUser,lockDate,lockTime,inLockFlag)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
 q
}

ClassMethod DHCSTLocItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCSTLocItmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCSTLocItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCSTLocItmExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 检索科室库存项目的普通sql语句
/// Author: zhwh
/// Date: 2012-07-26
/// Argu:
/// Return:
///  Sql语句
ClassMethod LocItmSql() As %String
{
 s sql="select %ID incil,"
 s sql=sql_"incil_inci_parref inci,"
 s sql=sql_"incil_incsb_dr incsb,"
 s sql=sql_"incil_incsb_dr->incsb_desc sbDesc,"
 s sql=sql_"incil_inci_parref->inci_code code, "
 s sql=sql_"incil_inci_parref->inci_desc descx,"
 s sql=sql_"incil_availqty avaQty,"
 s sql=sql_"incil_dirtyqty dirtyQty,"
 s sql=sql_"incil_maxqty maxQty,"
 s sql=sql_"incil_minqty minQty,"
 s sql=sql_"incil_repqty repQty,"
 s sql=sql_"incil_replev repLev,"
 s sql=sql_"INCIL_LogQty stkQty,"
 s sql=sql_"incil_inci_parref->inci_arcim_dr->arcim_phcdf_dr->phcdf_phcd_parref->phcd_phcpo_dr->phcpo_desc phcpoCode,"
 s sql=sql_"INCIL_FreeStorageBin fsb,"
 s sql=sql_"INCIL_INCI_ParRef->INCI_NotUseFlag NotUseFlag,"
 s sql=sql_"INCIL_INCI_ParRef->INCI_CTUOM_Purch_DR pUom,"
 s sql=sql_"INCIL_INCI_ParRef->INCI_CTUOM_Purch_DR->CTUOM_Desc pUomDesc,"
 s sql=sql_"INCIL_INCI_ParRef->INCI_CTUOM_DR bUom,"
 s sql=sql_"INCIL_INCI_ParRef->INCI_CTUOM_DR->CTUOM_Desc bUomDesc"
 s sql=sql_" from inc_itmloc "
 q sql
}

/// 检索科室库存项目的sql语句(条件: 科室rowid\库存项rowid)
/// Author: zhwh
/// Date: 2012-07-26
/// Argu:
/// 	loc -科室rowid
/// 	sb -货位码rowid
/// Return:
///  Sql语句
ClassMethod GetLocItmSQL1(loc As %String, inci As %String) As %String
{
 n (loc,inci)
 s sql=..LocItmSql()_" where incil_ctloc_dr="_loc_" and incil_inci_parref="_inci 
 q sql
}

/// 检索科室库存项目的sql语句(条件: 科室rowid\货位码rowid)
/// Author: zhwh
/// Date: 2012-07-26
/// Argu:
/// 	loc -科室rowid
/// 	sb -货位码rowid
/// Return:
///  Sql语句
ClassMethod GetLocItmSQL2(loc As %String, sb As %String) As %String
{
 n (loc,sb)
 s sql=..LocItmSql()_" where incil_ctloc_dr="_loc_" and incil_incsb_dr="_sb
 q sql
}

/// 检索科室库存项目的sql语句(条件: 科室rowid\货位码名称)
/// Author: zhwh
/// Date: 2012-07-26
/// Argu:
/// 	loc -科室rowid
/// 	sbDesc -货位码
/// Return:
///  Sql语句
ClassMethod GetLocItmSQL3(loc As %String, sbDesc As %String) As %String
{
 n (loc,sbDesc)
 s sbDesc=sbDesc_"%"
 s sql=..LocItmSql()_" where incil_ctloc_dr="_loc_" and incil_incsb_dr->incsb_desc like "_"'"_sbDesc_"'"
 q sql
}

/// 检索科室库存项目的sql语句(条件:科室)
/// Author: zhwh
/// Date: 2012-07-26
/// Argu:
/// 	loc -科室rowid
/// Return:
///  Sql语句
ClassMethod GetLocItmSQL4(loc As %String) As %String
{
 n (loc)
 s sql=..LocItmSql()_" where incil_ctloc_dr="_loc
 q sql
}

/// Descript:取科室库存项集合
/// Creater:	LiangQaing
/// CreateDate:	2013-11-13
/// Table:
/// Input:开始行,限制数,入参串
/// Output:		
/// Return：
ClassMethod jsLocInciDs(Start, Limit, StrPar)
{
	n (Start, Limit, StrPar)
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
    s LocID=$p(StrPar,"^",1)
    s DrugID=$p(StrPar,"^",2)
    s DrugCode=$p(StrPar,"^",3)
    i DrugCode'="" s DrugCode=$ZCVT(DrugCode,"U")
    s DrugStkCat=$p(StrPar,"^",4)
    s h=0
	s pid=..NewPid()
	
	Set $ZT="ERRORjsLocInciDs"
	s inci=""
	f  s inci=$o(^INCI("IL_LOC",LocID,inci)) q:inci=""  d
	.q:(DrugID'="")&(DrugID'=inci)
	.s incscdr=$p(^INCI(inci,2),"^",2)
	.q:(DrugStkCat'="")&(DrugStkCat'=incscdr)
	.s chl=""
	.f  s chl=$o(^INCI("IL_LOC",LocID,inci,chl)) q:chl=""  d
	..s code=$p(^INCI(inci,1),"^",1)
	..q:(DrugCode'="")&($e(code,0,$l(DrugCode))'=DrugCode)
	..s desc=$p(^INCI(inci,1),"^",2)
	..s rowid=inci_"||"_chl
    ..s data=rowid_"^"_code_"^"_desc
    ..s h=h+1
    ..s index="Sort^"_code_"^"_h  //排序
    ..s ^TMP("DHCST","INCItmLoc","jsLocInciDs",pid,"index",index)=data
    ..

    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","INCItmLoc","jsLocInciDs",pid,"index",h)) q:h=""  d
    .s data=^TMP("DHCST","INCItmLoc","jsLocInciDs",pid,"index",h)
    .s rowid=$p(data,"^",1)
    .s code=$p(data,"^",2)
    .s desc=$p(data,"^",3)
    .
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s rowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rowid",rowid)
	.s code=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("code",code)
	.s desc=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("desc",desc)
    .s tmpstr=rowid_code_desc
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("DHCST","INCItmLoc","jsLocInciDs",pid)

    q ""
    
ERRORjsLocInciDs
    //遇报错,则先kill TMP
    Set Method=	"##class(web.DHCST.INCItmLoc).jsLocInciDs"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_StrPar_")"_","_$ZE
	k ^TMP("DHCST","INCItmLoc","jsLocInciDs",pid)    
    q ""
}

/// w ##class(web.DHCST.INCItmLoc).AutoSetloclimqty("99^2020-01-27^2020-02-27^2^2^4^P")
ClassMethod AutoSetloclimqty(inputstr) As %String
{
	s ^ws("sf")=inputstr
	q:inputstr="" ""
	s loc=$p(inputstr,"^",1)
	s startDate=$p(inputstr,"^",2)
	s endDate=$p(inputstr,"^",3)
	s maxlimt=$p(inputstr,"^",4)
	s minlimt=$p(inputstr,"^",5)
	s stkgrp=$p(inputstr,"^",6)
	s TransType=$p(inputstr,"^",7)
	s:startDate'="" startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s:endDate'="" endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	s pid=..NewPid()
	s n=0
	k ^TMP("web.DHCST.INCItmLoc","AutoSetloclimqty",pid)
	s inci=""
	f  s inci=$o(^INCI("IL_LOC",loc,inci)) q:inci=""  d
	.s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
    .s ScgType=$p(StkGrpInfo,"^",3)
    .s Scg=$p(StkGrpInfo,"^",5)
    .q:ScgType'=..sssCode()
    .q:(stkgrp'="")&(stkgrp'=Scg)
    .s transqty=..TotalItmtransqty(inci,startDate,endDate,loc,TransType)
    .
    .q:transqty=0
    .s:transqty<0 transqty=-transqty
    .s maxqty=maxlimt*transqty
    .s minqty=minlimt*transqty
    .s n=n+1
    .s ^TMP("web.DHCST.INCItmLoc","AutoSetloclimqty",pid,n)=inci_"^"_loc_"^"_maxqty_"^"_minqty
    q:n=0 "0"
    s updflag=0
    
    ts
    s index=""
    f  s index=$o(^TMP("web.DHCST.INCItmLoc","AutoSetloclimqty",pid,index)) q:index=""  d
    .s datastr=^TMP("web.DHCST.INCItmLoc","AutoSetloclimqty",pid,index)
    .s inci=$p(datastr,"^",1)
    .s loc=$p(datastr,"^",2)
    .s maxqty=$p(datastr,"^",3)
    .s minqty=$p(datastr,"^",4)
    .
    .s ch=$o(^INCI("IL_LOC",loc,inci,""))
    .q:ch=""
    .s incil=inci_"||"_ch
    .s updflag=..Updlimit(incil,maxqty,minqty)
    i updflag'=0  d
    .tro
    k ^TMP("web.DHCST.INCItmLoc","AutoSetloclimqty",pid)
    q:updflag'=0 updflag
    tc
    q 0
}

ClassMethod Updlimit(incil As %String, maxQty As %String, minQty As %String) As %String
{
    s obj=##class(User.INCItmLoc).%OpenId(incil)	
    s obj.INCILMaxQty=maxQty
    s obj.INCILMinQty=minQty
    s sc=obj.%Save()
    
    if $$$ISERR(sc) q -1
    q 0
}

ClassMethod TotalItmtransqty(inci As %String, StartDate As %String, EndDate As %String, loc As %String, TransType) As %String
{
	n (inci,StartDate,EndDate,loc,TransType)
	
	s ch=$o(^INCI("IL_LOC",loc,inci,""))
    q:ch="" 0
    s incil=inci_"||"_ch
    s uom=$p(^INCI(inci,1),"^",10) 
    s types=TransType
    s totalQty=0,trqty=0
    f i=1:1:$l(types,",") d
    .s trType=$p(types,",",i)
    .f dd=StartDate:1:EndDate  d
    ..s INTR=""
    ..f  s INTR=$o(^DHCINTR(0,"ILTYPEDATE",incil,trType,dd,INTR)) q:INTR=""  d        ; get INTR
    ...s transom=$p(^DHCINTR(INTR),"^",10)
    ...s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(transom,uom)  ; factor 
    ...s trqty=$p(^DHCINTR(INTR),"^",6)                                                           ;dispensing qty
    ...s trqty=trqty*fac
    ...s totalQty=$g(totalQty)+$g(trqty)   
    q $g(totalQty)
}

ClassMethod NewPid() As %String
{
  	q $I(^DHCSTPID("INCItmLoc"))
}

}
