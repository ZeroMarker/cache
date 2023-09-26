Import SQLUser

/// 名称: 访问类型位置维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-29
Class web.DHCBL.CT.PACAdmTypeLocation Extends %RegisteredObject [ ProcedureBlock ]
{

/// Fucntion: 通过科室查询病人类型是否已经维护
/// CreateDate:2020-03-24
/// Creator: sunfengchao
/// Debug:   w ##class(web.DHCBL.CT.PACAdmTypeLocation).GetAdmTypeByLoc()
ClassMethod GetAdmTypeByLoc(CTLOCDR As %String) As %String
{
  s flag=0
  s result=""
  s ADMLOCRowId=0
  for 
  {
   s ADMLOCRowId=$o(^PAC("ADMLOC",ADMLOCRowId)) 
   q:(ADMLOCRowId="")||(flag=1)
   s ADMLOCAdmType=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",1) 
   s ADMLOCCTLOCDR=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",2) 
   if ADMLOCCTLOCDR=CTLOCDR
   {
	    s flag=1 
   		s result= flag_"^"_ADMLOCCTLOCDR_"^"_ADMLOCAdmType_"^"_ADMLOCRowId
   }
  } 
  q result
}

/*
/// Creator：sunfengchao
/// CreatDate: 2012-11-7
/// Description： 一个科室只允许有一个类型 维护了类型之后不允许再加其他的类型
/// Table：User.PACAdmTypeLocation
/// Input：id, ADMLOCAdmType, ADMLOCCTLOCDR
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.CT.PACAdmTypeLocation).Validate("1","E","1")
ClassMethod Validate(id As %String, ADMLOCAdmType As %String, ADMLOCCTLOCDR As %String) As %String
{
 s flag=""
 s VflagStr=##class(web.DHCBL.CT.PACAdmTypeLocation).GetAdmTypeByLoc(ADMLOCCTLOCDR) 
 s Vflag=$p(VflagStr,"^",1)
 s VLoc=$p(VflagStr,"^",2)
 s VType=$p(VflagStr,"^",3)
 s VRowId=$p(VflagStr,"^",4)
 if (id="") //如果为空，增加时的重复判断
 {
  if (Vflag=1) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s rowid="" 
  if (Vflag=1) // 该科室已经分配过 需要看是否是同一个数据 
  {
      if ((VLoc=ADMLOCCTLOCDR)||(ADMLOCAdmType=VType))&(VRowId'=id)  s flag=1
      else  s flag=0  
  }
  else
  { 
    s flag=0 //返回不重复标志
  }
 }
 q flag
}
*/
/// Fucntion: 获取科室类型 EHIO
/// CreateDate:2022-07-20
/// Creator: CHENYING
/// Debug:   w ##class(web.DHCBL.CT.PACAdmTypeLocation).GetAdmTypeStrByLoc(49)
ClassMethod GetAdmTypeStrByLoc(CTLOCDR As %String) As %String
{
	Q:CTLOCDR="" ""
	s AdmTypeStr=""
    s AdmType=0
    for
    {
        s AdmType=$o(^PAC("ADMLOC",0,"AdmType",AdmType)) q:((AdmType=""))
        s ADMLOCRowId=$o(^PAC("ADMLOC",0,"AdmType",AdmType,CTLOCDR,0))
        if ADMLOCRowId'=""
        {
	        if AdmTypeStr'[AdmType s AdmTypeStr=AdmTypeStr_AdmType
        }
    }
    q AdmTypeStr
}

/// Fucntion: 获取科室类型描述 门诊 住院 体检
/// CreateDate:2022-07-20
/// Creator: CHENYING
/// Debug:   w ##class(web.DHCBL.CT.PACAdmTypeLocation).GetAdmTypeDescStrByLoc(49)
ClassMethod GetAdmTypeDescStrByLoc(CTLOCDR As %String) As %String
{
	Q:CTLOCDR="" ""
	s AdmTypeStr=##class(web.DHCBL.CT.PACAdmTypeLocation).GetAdmTypeStrByLoc(CTLOCDR)
	s AdmTypeDescStr=""
	if AdmTypeStr["E" S AdmTypeDescStr="急诊"_" "_AdmTypeDescStr
	if AdmTypeStr["H" S AdmTypeDescStr="体检"_" "_AdmTypeDescStr
	if AdmTypeStr["I" S AdmTypeDescStr="住院"_" "_AdmTypeDescStr
	if AdmTypeStr["O" S AdmTypeDescStr="门诊"_" "_AdmTypeDescStr
    q AdmTypeDescStr
}

/// Creator：chenying 
/// CreatDate: 2022-07-30 
/// Description： 去掉科室只允许加一个类型的限制
/// Table：User.PACAdmTypeLocation
/// Input：id, ADMLOCAdmType, ADMLOCCTLOCDR
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.CT.PACAdmTypeLocation).Validate("1","E","1")
ClassMethod Validate(id As %String, ADMLOCAdmType As %String, ADMLOCCTLOCDR As %String) As %String
{
	s flag=""
	if ((ADMLOCAdmType="")||(ADMLOCCTLOCDR="")) q flag
	s idd=$o(^PAC("ADMLOC",0,"AdmType",ADMLOCAdmType,ADMLOCCTLOCDR,0))
	if (idd'="")&&(id'=idd) s flag=1
	q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-29
/// Description：保存修改访问类型位置的内容
/// Table：User.PACAdmTypeLocation
/// Input：web.Entity.CT.PACAdmTypeLocation 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.PACAdmTypeLocation).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.PACAdmTypeLocation) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s flag=..Validate(eobj.ADMLOCRowId,eobj.ADMLOCAdmType,eobj.ADMLOCCTLOCDR)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该科室已经分配该病人类型！'}"
  }
  else
  {
   if (eobj.ADMLOCRowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.PACAdmTypeLocation).%New()
   }
   else                      //如果RowId已赋值则修改
   {
    s obj=##class(User.PACAdmTypeLocation).%OpenId(eobj.ADMLOCRowId)
    s bobj=##class(web.Entity.CT.PACAdmTypeLocation).%New()
    s bobj.ADMLOCRowId=eobj.ADMLOCRowId
    s bobj.ADMLOCAdmType = obj.ADMLOCAdmType   
    s:obj.ADMLOCCTLOCDR'="" bobj.ADMLOCCTLOCDR=obj.ADMLOCCTLOCDR.%Id()  
   }
   Ts          
   s obj.ADMLOCAdmType = eobj.ADMLOCAdmType  //修改病人类型
   d obj.ADMLOCCTLOCDRSetObjectId(eobj.ADMLOCCTLOCDR) //修改位置
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    s AdmType = eobj.ADMLOCAdmType
    if (eobj.ADMLOCAdmType="O") s AdmType = "门诊"
    if (eobj.ADMLOCAdmType="I") s AdmType = "住院"
    if (eobj.ADMLOCAdmType="E") s AdmType = "急诊"
    if (eobj.ADMLOCAdmType="H") s AdmType = "体检"
    s LocDesc = $p($g(^CTLOC(eobj.ADMLOCCTLOCDR)),"^",2)
    d:eobj.ADMLOCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AdmTypeLocation","User.PACAdmTypeLocation","访问类型位置",id,AdmType_"->"_LocDesc,"A",eobj)
    d:eobj.ADMLOCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AdmTypeLocation","User.PACAdmTypeLocation","访问类型位置",eobj.ADMLOCRowId,AdmType_"->"_LocDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("访问类型位置","web.DHCBL.CT.PACAdmTypeLocation","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }
 }
 else
 {
   s result= "{success:'false',errorinfo:'对象不存在！'}"
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("访问类型位置","web.DHCBL.CT.PACAdmTypeLocation","SaveEntity","")
   s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 q result
ERROE
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("访问类型位置","web.DHCBL.CT.PACAdmTypeLocation","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-29
/// Description：根据ID删除访问类型位置的内容
/// Table：User.PACAdmTypeLocation
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
 s eobj = ##class(web.Entity.CT.PACAdmTypeLocation).%New()
 s eobj.ADMLOCRowId = id
 s eobj.ADMLOCAdmType = $p($g(^PAC("ADMLOC",id)),"^",1)
 s eobj.ADMLOCCTLOCDR = $p($g(^PAC("ADMLOC",id)),"^",2)
 
 s sc=##class(User.PACAdmTypeLocation).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result= "{success:'true',info:'删除成功！'}" 
  //保存日志
  s AdmType = eobj.ADMLOCAdmType
  if (eobj.ADMLOCAdmType="O") s AdmType = "门诊"
  if (eobj.ADMLOCAdmType="I") s AdmType = "住院"
  if (eobj.ADMLOCAdmType="E") s AdmType = "急诊"
  if (eobj.ADMLOCAdmType="H") s AdmType = "体检"
  s LocDesc = $p($g(^CTLOC(eobj.ADMLOCCTLOCDR)),"^",2)
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AdmTypeLocation","User.PACAdmTypeLocation","访问类型位置",id,AdmType_"->"_LocDesc,"D",eobj)
  d eobj.%Close()
 }
 else 
 {
  s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("访问类型位置","web.DHCBL.CT.PACAdmTypeLocation","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.PACAdmTypeLocation
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s eobj = ##class(web.Entity.CT.PACAdmTypeLocation).%New()
 s eobj.ADMLOCRowId = id
 s eobj.ADMLOCAdmType = $p($g(^PAC("ADMLOC",id)),"^",1)
 s eobj.ADMLOCCTLOCDR = $p($g(^PAC("ADMLOC",id)),"^",2)
 s str = eobj.JsonS()
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-29
/// Description：查询访问类型位置的内容
/// Table：  PAC_AdmTypeLocation
/// Input：rowid,AdmType,CTLOCDR
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAdmTypeLocation","GetList","","","","")
Query GetList(rowid As %String, AdmType As %String, CTLOCRowID As %String, Alias As %String, hospid As %String) As %Query(ROWSPEC = "ADMLOCRowId:%String,ADMLOCAdmType:%String,ADMLOCCTLOCDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, AdmType As %String, CTLOCRowID As %String, Alias As %String, hospid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 s:Alias'="" Alias=$zcvt(Alias,"U")
 ;s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()  
 if (rowid'="") 
 {
  s ADMLOCRowId=rowid
  s ADMLOCAdmType=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",1)
  s ADMLOCCTLOCDR=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",2)
  s ADMLOCCTLOCDesc=""
  s:ADMLOCCTLOCDR'="" ADMLOCCTLOCDesc=$p($g(^CTLOC(ADMLOCCTLOCDR)),"^",2) //获取科室描述
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AdmTypeLocation",ADMLOCRowId)
  s BDPInternalCode =$p($g(resultStr),"^",1)       
  s BDPInternalDesc = $p($g(resultStr),"^",2)  
  s BDPHospNationalCode=$p($g(resultStr),"^",3)         
  s BDPHospNationalDesc = $p($g(resultStr),"^",4)
  d OutputRow
 }
 else
 {
  s ADMLOCRowId=0
  for 
  {
   s ADMLOCRowId=$o(^PAC("ADMLOC",ADMLOCRowId)) q:ADMLOCRowId=""
   s ADMLOCCTLOCDR=""
   
   s ADMLOCCTLOCDR=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",2)
   ;s HospitalDR=$p($g(^CTLOC(ADMLOCCTLOCDR)),"^",22) 
   ;s strHospitalID = "{ID:"_HospitalDR_"}"
   ;if ((AuHospStr[strHospitalID)||(AuHospStr=1)||(AuHospStr="off")) 
   ;{  
    s ADMLOCAdmType=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",1) 
    s ADMLOCCTLOCDR=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",2)
    s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc",ADMLOCCTLOCDR,hospid)
	continue:showflag="N"
    
    s ADMLOCCTLOCDesc=""
    s:ADMLOCCTLOCDR'="" ADMLOCCTLOCDesc=$p($g(^CTLOC(ADMLOCCTLOCDR)),"^",2) //获取科室描述 
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AdmTypeLocation",ADMLOCRowId)
    s BDPInternalCode =$p($g(resultStr),"^",1)       
    s BDPInternalDesc = $p($g(resultStr),"^",2)  
    s BDPHospNationalCode=$p($g(resultStr),"^",3)         
    s BDPHospNationalDesc = $p($g(resultStr),"^",4)
    if (Alias'="")
    {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_AdmTypeLocation",ADMLOCRowId,ADMLOCCTLOCDesc,Alias)
    }
    else
    {
        s AliasFlag= 1   
    }    
    if ((ADMLOCAdmType=AdmType)||(AdmType=""))&((ADMLOCCTLOCDR=CTLOCRowID)||(CTLOCRowID=""))&(AliasFlag=1)
    {
        d OutputRow
    }
   ;}
  }
}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ADMLOCRowId,ADMLOCAdmType,ADMLOCCTLOCDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

}
