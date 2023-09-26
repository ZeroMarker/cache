Import SQLUser

/// CreateDate:2013-05-31
/// Creator:基础数据平台 ，孙凤超
/// Function: 科室列表关联科室维护
/// Tables: CT_LocationList_Locations
Class web.DHCBL.CT.CTLocationListLocations Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据的模糊查询检索，查询科室列表关联科室的信息
/// CreateDate:2013-05-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  CT_LocationList_Locations
/// Input: rowid, code, desc, ParRef 
/// Output:LOC_ParRef LOC_RowId LOC_Childsub CTLOC_DR HospitalCT_DR 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocationListLocations", "GetList","","","","2")  
Query GetList(rowid As %String, code As %String, desc As %String, hosp As %String, ParRef As %String) As %Query(ROWSPEC = "LOCRowId:%String,ParRef2:%String,HospitalCTDR:%String,CTLOCDR:%String")
{
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
  If ind="" {    // if there are no more rows, finish fetching
   Set AtEnd=1
   Set Row=""
  }
  Else      {    // fetch row
   Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hosp As %String, ParRef As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   s ind=1 
   ; 子表,只进行医院级授权,无基础数据授权
   s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
   if (rowid '="") 
   {
     s ChildSub=$p($g(rowid),"||",2) 
     s ParRef2=$p($g(rowid),"||",1)  
     s LOCRowId=rowid
     s HospitalCTDR=$p($g(^CT("LL",ParRef2,"LOC",ChildSub)),"^",2)
     s CTLOCDR=$p($g(^CT("LL",ParRef2,"LOC",ChildSub)),"^",1)
     s:CTLOCDR'="" CTLOCDR=$p($g(^CTLOC(CTLOCDR)),"^",2)       //科室名
     s:CTLOCDR="" CTLOCDR=""
     s:HospitalCTDR'="" HospitalCTDR=$p($g(^CT("HOSP",HospitalCTDR)),"^",2)
     s:HospitalCTDR="" HospitalCTDR=""
     d Build1
   }
   else  
   {
     s:code'="" code2=$p($g(^CT("HOSP",code)),"^",2)
     s:desc'="" desc2=$p($g(^CTLOC(desc)),"^",2)    
     s ChildSub=0
     for  
     { 
       s ChildSub=$o(^CT("LL",ParRef,"LOC",ChildSub)) 
       q:ChildSub=""  
       s HospitalCTDR=""
       s LOCRowId=ParRef_"||"_ChildSub
       s ParRef2=ParRef
       s HospitalCTDR=$P($g(^CT("LL",ParRef,"LOC",ChildSub)),"^",2)
       s strHospitalID = "{ID:"_HospitalCTDR_"}"
       s AuHospFlag=0
       if (AuHospStr[strHospitalID) s AuHospFlag=1
       if (AuHospFlag=1)||(AuHospStr=1)||(AuHospStr="off")  
       {
         s CTLOCDR=$P($g(^CT("LL",ParRef,"LOC",ChildSub)),"^",1)
         s:CTLOCDR="" CTLOCDR=""
         s:CTLOCDR'="" CTLOCDR=$p($g(^CTLOC(CTLOCDR)),"^",2)   
         s:HospitalCTDR'="" HospitalCTDR=$p($g(^CT("HOSP",HospitalCTDR)),"^",2)
         s:HospitalCTDR="" HospitalCTDR=""
         
         if ((CTLOCDR[desc)||(CTLOCDR[desc2)&((hosp="")||(hosp=$P($g(^CT("LL",ParRef,"LOC",ChildSub)),"^",2)))) 
         {
           d Build1
         }
       }
     }
   }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
Build1   
   
  set Data=$lb(LOCRowId,ParRef2,HospitalCTDR,CTLOCDR)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:进行数据检索，查询科室列表关联科室的信息
/// CreateDate:2013-6-4
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:CT_LocationList_Locations   
/// Input: rowid 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocationListLocations", "GetDataForCmb1","","","","10")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, ParRef As %String) As %Query(ROWSPEC = "LOCRowId:%String,ParRef2:%String,HospitalCTDR:%String,CTLOCDR:%String")
{
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)  
  Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" {    // if there are no more rows, finish fetching
   Set AtEnd=1
   Set Row=""
  }
  Else      {    // fetch row
   Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

// (rowid As %String, code As %String, desc As %String, ParRef As %String) As %Query(ROWSPEC = "LOCRowId:%String,ParRef2:%String,HospitalCTDR:%String,CTLOCDR:%String")

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, ParRef As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   s ind=1
   s:code'="" code=$p($g(^CT("HOSP",HospitalCTDR)),"^",2)
   s:desc'="" desc=$p($g(^CTLOC(CTLOCDR)),"^",2)  
   if (rowid '="") 
   {
     s ChildSub=$p($g(rowid),"||",2)  
     s ParRef2=$p($g(rowid),"||",1)  
     s LOCRowId=rowid
     s HospitalCTDR=$p($g(^CT("LL",ParRef2,"LOC",ChildSub)),"^",2)
     s CTLOCDR=$p($g(^CT("LL",ParRef2,"LOC",ChildSub)),"^",1)
     s:CTLOCDR'="" CTLOCDR=$p($g(^CTLOC(CTLOCDR)),"^",2)       //科室名
     s:CTLOCDR="" CTLOCDR=""
     s:HospitalCTDR'="" HospitalCTDR=$p($g(^CT("HOSP",HospitalCTDR)),"^",2)
     s:HospitalCTDR="" HospitalCTDR=""
     d Build2
 }
 else  
 { 
    s ChildSub =0
    for
    {  
      s ChildSub=$o(^CT("LL",ParRef,"LOC",ChildSub)) 
      q:ChildSub=""  
      s LOCRowId=ParRef_"||"_ChildSub
      s ParRef2=ParRef
      s HospitalCTDR=$P($g(^CT("LL",ParRef,"LOC",ChildSub)),"^",2)
      s CTLOCDR=$P($g(^CT("LL",ParRef,"LOC",ChildSub)),"^",1)
      s:CTLOCDR'="" CTLOCDR=$p($g(^CTLOC(CTLOCDR)),"^",2) ///取Desc  
      s:HospitalCTDR'="" HospitalCTDR=$p($g(^CT("HOSP",HospitalCTDR)),"^",2)
    
      if ((HospitalCTDR[code)||($$ALPHAUP^SSUTIL4(HospitalCTDR)[code))&((CTLOCDR[desc)||($$ALPHAUP^SSUTIL4(CTLOCDR)[desc))  
      {
         d Build2
      }
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
Build2   
   
 set Data2=$lb(LOCRowId,ParRef2,HospitalCTDR,CTLOCDR)
  Set ^CacheTemp(repid,ind)=Data2
  Set ind=ind+1
  q
}

/// Function:实现对科室列表关联科室信息的删除操作
/// Creator:孙凤超
/// CreateDate:2013-05-31
/// Desc:通过RowId来删除科室列表关联科室的信息
/// Input: LOC_RowId
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables:  CT_LocationList_Locations 
/// Others:d ##class(web.DHCBL.CT.CTLocationListLocations).DeleteData("1||2")
ClassMethod DeleteData(id) As %String
{
    s result="",eobjCTLOCDR=""
    s eobj = ##class(web.Entity.CT.CTLocationListLocations).%New()
    s ParRef=$p(id,"||",1) /// 取父节点
    s ChildSub=$p(id,"||",2) ///取子节点
    
    s eobj.LOCRowId=id
    s eobj.HospitalCTDR=$p($g(^CT("LL",ParRef,"LOC",ChildSub)),"^",2) ///取医院的指向
    s eobj.CTLOCDR=$p($g(^CT("LL",ParRef,"LOC",ChildSub)),"^",1)   /// 取科室的指向
    S LLDesc=$p($g(^CT("LL",ParRef)),"^",2)  
    s eobjCTLOCDR=$p($g(^CTLOC(eobj.CTLOCDR)),"^",2) 
    s obj=##class(User.CTLocationListLocations).%OpenId(id) 
    Tstart
    s sc=##class(User.CTLocationListLocations).%DeleteId(id)
    IF $$$ISOK(sc)
    {
      Tc
      s result="{success:'true',info:'删除成功！'}"
      s eobj.ParentRowId= ParRef
      s eobj.LOCChildsub=ChildSub
      s eobj.LOCParRef=ParRef
     
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocationList_Locations","User.CTLocationListLocations","科室列表关联科室",id,LLDesc_"->"_eobjCTLOCDR,"D",eobj)
    }
    else
    {
      Trollback
      s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室列表关联科室","web.DHCBL.CT.CTLocalityType","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    }
    q result
}

/// Function:显示科室列表关联科室的打开窗口
/// CreateDate:2013-05-31
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid
/// Tables: CT_LocationList_Locations  
/// Others: w ##class(web.DHCBL.CT.CTLocationListLocations).OpenData("1||1")
ClassMethod OpenData(sid As %String) As %String
{
 s eobj = ##class(web.Entity.CT.CTLocationListLocations).%New()
 s obj=##class(User.CTLocationListLocations).%OpenId(sid)
 s ParRef=$p(sid,"||",1)
 s ChildSub=$p(sid,"||",2)
 s eobj.LOCRowId=sid
 s:obj.LOCHospitalCTDR'="" eobj.HospitalCTDR = obj.LOCHospitalCTDR.%Id()
 s:obj.LOCCTLOCDR'="" eobj.CTLOCDR = obj.LOCCTLOCDR.%Id()
 s str = eobj.JsonS() 
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-6-4
/// Description：数据重复校验
/// Table： CT_LocationList_Locations  
/// Input：id,desc只验证 科室是否重复
/// Other: w ##class(web.DHCBL.CT.CTLocationListLocations).FormValidate("15||2","","2")
ClassMethod FormValidate(id As %String, ParRef As %String, hosiptal As %String, code As %String) As %String
{
 s flag="", flagc="",flagd=""  
 if (id'="") 
 {
  s ParRef2=$p(id,"||",1)  ///父ID
  s ChildSub=$p(id,"||",2) ///孩子数
  s HospitalCTDR=$p($g(^CT("LL",ParRef2,"LOC",ChildSub)),"^",2)   
  if (code'="")
  {
     if (hosiptal'="")
     {
       if (HospitalCTDR=hosiptal)
       {
         s flagc=$d(^CT("LL",ParRef2,"LOC",0,"Loc",code))
         s ChildSub2=0
         s ChildSub2=$o(^CT("LL",ParRef2,"LOC",0,"Loc",code,0)) 
         if ((flagc=0)||((flagc>0)&(ChildSub2=ChildSub)))
         {
            s flag=0 //返回不重复标志
         }
         else  
         {
            s flag=1
         }
        }
      }
      else
      {
         s flagc=$d(^CT("LL",ParRef2,"LOC",0,"Loc",code))
         s ChildSub2=0
         s ChildSub2=$o(^CT("LL",ParRef2,"LOC",0,"Loc",code,0)) 
         if ((flagc=0)||((flagc>0)&(ChildSub2=ChildSub)))
         {
            s flag=0 //返回不重复标志
         }
         else  
         {
            s flag=1
         }
      }
    }
 } 
 else //如果不为空，添加时的重复判断 
 {  
       if (hosiptal'="")    
       { //增加时的重复校验 医院存在的情况 
         S ChildSub=0
         s flag=0
         for 
         { 
           S ChildSub=$o(^CT("LL",ParRef,"LOC",ChildSub))
           q:ChildSub=""
           s CTLOCDR=$p($g(^CT("LL",ParRef,"LOC",ChildSub)),"^",1) 
           s HospitalCTDR=$p($g(^CT("LL",ParRef,"LOC",ChildSub)),"^",2) 
           if (HospitalCTDR=hosiptal)
           {  
               if (CTLOCDR=code)
               {
                 s flag=1
                 q
               }
               else
               {
                 continue
               }
          }
          else{
              s flag=0  
          }
       }  
   }
   else
   {
    //增加时的重复校验 医院不存在的情况 
         S ChildSub=0
         for 
         { 
           S ChildSub=$o(^CT("LL",ParRef,"LOC",ChildSub))
           q:ChildSub=""
           s HospitalCTDR=$p($g(^CT("LL",ParRef,"LOC",ChildSub)),"^",2)  
           if (HospitalCTDR=""){
           
              if ($d(^CT("LL",ParRef,"LOC",0,"Loc",code))>0)
              { 
                 s flag=1  
              }
              else{
                 s flag=0
              }
           } 
           else{
                continue
             }
         }
       }
    }
  q flag
}

/// Function:实现对科室列表信息的添加和修改操作
/// Creator:孙凤超
/// CreateDate:2013-05-31
/// Output:success:'true',info:'添加成功！' 失败时输出添加失败！
///        success:'false',info:'修改 成功' 失败时输出修改失败！
/// Tables: CT_LocationList_Locations 
/// Others:d ##class(web.DHCBL.CT.CTLocationListLocations).SaveEntity("")
ClassMethod SaveEntity(eobj As web.Entity.CT.CTLocationListLocations) As %String
{
   s result=""  
   if (eobj.LOCRowId="")                            
   {
       s obj=##class(User.CTLocationListLocations).%New(eobj.ParentRowId)
       d obj.LOCParRefSetObjectId(eobj.ParentRowId)
       d:eobj.HospitalCTDR'="" obj.LOCHospitalCTDRSetObjectId(eobj.HospitalCTDR)
       d:eobj.CTLOCDR'="" obj.LOCCTLOCDRSetObjectId(eobj.CTLOCDR)
       s oobj=##class(User.CTLocationList).%OpenId(eobj.ParentRowId) 
       s oobj.LLDesc=$p($g(^CT("LL",eobj.ParentRowId)),"^",2) 
       Tstart
       s sc=obj.%Save()
       d obj.%Close()
       If $$$ISOK(sc)
       {  
         Tcommit
         s id = obj.%Id()
         s result = "{success:'true',id:'"_id_"'}"  
         s eobjCTLOCDR=""
         s:eobj.CTLOCDR'="" eobjCTLOCDR=$p($g(^CTLOC(eobj.CTLOCDR)),"^",2) ///取Desc  
         s eobj.LOCParRef=$tr($p($g(^CT("LL",eobj.ParentRowId)),"^",2),$c(13,10))
         s eobj.LOCRowId=id
         s eobj.LOCChildsub=$p(id,"||",2)  
         d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocationList_Locations","User.CTLocationListLocations","科室列表关联科室",id,oobj.LLDesc_"->"_eobjCTLOCDR,"A",eobj)
       }
       else  
       {
         Trollback  //返回错误信息
         s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
         s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室列表关联科室","web.DHCBL.CT.CTLocationListLocations","SaveEntity",eobj)
         s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
       }
     }
  ///如果RowId已赋值则修改
  else                                                 
  { 
    s obj=##class(User.CTLocationListLocations).%OpenId(eobj.LOCRowId)  
    s bobj=##class(web.Entity.CT.CTLocationListLocations).%New()
    s bobj.LOCRowId=eobj.LOCRowId
    s:obj.LOCCTLOCDR'="" bobj.CTLOCDR=obj.LOCCTLOCDR.%Id()
    s:obj.LOCHospitalCTDR'="" bobj.HospitalCTDR=obj.LOCHospitalCTDR.%Id()
    
    d:eobj.ParentRowId'="" obj.LOCParRefSetObjectId(eobj.ParentRowId) 
    d:eobj.HospitalCTDR'="" obj.LOCHospitalCTDRSetObjectId(eobj.HospitalCTDR) 
    d:eobj.CTLOCDR'="" obj.LOCCTLOCDRSetObjectId(eobj.CTLOCDR)
    
    S LLDesc=$p($g(^CT("LL",$p(eobj.LOCRowId,"||",1))),"^",2) 
    s CTLOCDR=$p($g(^CTLOC(eobj.CTLOCDR)),"^",2)
    Tstart
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc)
    { 
      Tc
      s id = obj.%Id()
      s result = "{success:'true',id:'"_id_"'}" 
      s eobj.ParentRowId=$p(id,"||",1)
      s eobj.LOCParRef=$tr($p($g(^CT("LL",eobj.ParentRowId)),"^",2),$c(13,10))
      s eobj.LOCChildsub=$p(id,"||",2)  
      s bobj.ParentRowId=eobj.ParentRowId
      s bobj.LOCChildsub=eobj.LOCChildsub
      s bobj.LOCParRef=eobj.LOCParRef    
      d:eobj.LOCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocationList_Locations","User.CTLocationListLocations","科室列表关联科室",eobj.LOCRowId,LLDesc_"->"_CTLOCDR,"U",eobj,bobj)
   }
   else ///如果保存不成功的话
   {
     Trollback
     s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室列表关联科室","web.DHCBL.CT.CTLocationListLocations","SaveEntity",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
    } 
  }
 
 q result
}

/// Function:获取父表的描述
/// CreateDate:2016-10-12
/// Creator:sunfengchao
/// Debug: w ##class(web.DHCBL.CT.CTLocationListLocations).GetParentDesc("35")
ClassMethod GetParentDesc(ParentId As %String) As %String
{
   s result=""
   s result=$tr($p($g(^CT("LL",ParentId)),"^",2),$c(13,10))
   q result
}

/// 描述：获取科室列表-批量关联科室的Json串，提供给树，按科室部门组级联
/// 编写者：基础数据平台-李可凡
/// 日期：2020-12-07
/// 表：CT_Loc
/// 入参：loclistid:科室列表RowId	 FilterCK:是否勾选, hospid 医院id,根据医院过滤科室
/// 出参：Json串，包含安全组id，科室id，科室描述，是否勾选，例如{"id":"248^1","text":"静脉药物配置中心","checked":true,"leaf":true}
/// w ##class(web.DHCBL.CT.CTLocationListLocations).GetTreeJson("","")
ClassMethod GetTreeJson(loclistid As %String, FilterCK As %String, hospid As %String = "", depgrpid As %String = "") As %String
{
	if (loclistid="") q ""
	s AuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
    s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
    s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
	s AuRBCDepartmentGroupStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
    s AuCTHospitalStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
    
    
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    s AuRBCDepartmentGroupFlag=0
    if (AuRBCDepartmentGroupStr="")||(AuRBCDepartmentGroupStr["limited:0") s AuRBCDepartmentGroupFlag=1
    s AuCTHospitalFlag=0
    if (AuCTHospitalStr="")||(AuCTHospitalStr["limited:0") s AuCTHospitalFlag=1
    w "["
    s count1=0	//科室部门组计数
    s DEPRowId=0
	for  
	{
		s DEPRowId=$o(^RBC("DEP",DEPRowId)) q:DEPRowId=""
		if (depgrpid'="")
		{
			continue:DEPRowId'=depgrpid
		}
		s DEPDesc=$p($g(^RBC("DEP",DEPRowId)),"^",2)	//科室部门组描述
		s DEPDateTo=$p($g(^RBC("DEP",DEPRowId)),"^",4)	//结束日期
		continue:(DEPDateTo'="")&&(DEPDateTo<+$h)
		if (hospid'="")
		{
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("RBC_DepartmentGroup",DEPRowId,hospid)
	  		continue:showflag="N"
		}
		if $d(^CTLOC(0,"DepGrp",DEPRowId))		//如果该科室部门组下有科室，才输出科室部门组信息
		{
			w:count1'=0 ","		//多条科室部门组用逗号隔开
			s count1=count1+1
			w "{""id"":"""_""_DEPRowId_""",""text"":"""_DEPDesc_""",""leaf"":false,""expanded"":true,""children"":["
			s count2=0	//科室计数
			s listcheckflag="false"		//科室部门组是否勾选
			s CTLOCRowID=0
			for
			{
				s CTLOCRowID=$o(^CTLOC(0,"DepGrp",DEPRowId,CTLOCRowID)) q:CTLOCRowID=""
				s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
				s strRowId = "{ID:"_CTLOCRowID_"}"
		        s strCTLOCDepDR = "{ID:"_DEPRowId_"}"
		        s strHospitalID = "{ID:"_CTLOCHospitalDR_"}" 
				if (hospid'="")
				{
					continue:CTLOCHospitalDR'=hospid
				}
				else
				{
					if '((AuHospStr="off")||(AuHospStr[strHospitalID)||(AuHospStr=1)) continue   ;医院级授权
				}
				
		        i ((AuStr[strRowId)||(AuFlag=1))&&((AuRBCDepartmentGroupStr[strCTLOCDepDR)||(AuRBCDepartmentGroupFlag=1))&&((AuCTHospitalStr[strHospitalID)||(AuCTHospitalFlag=1))
		        {
			        s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)
		            s CTLOCContactName=$p($g(^CTLOC(CTLOCRowID)),"^",43)   //科室检索码
		            s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期
		            continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
		            
					//过滤已选、未选
					s CheckedFlag=0
					s CheckedFlag=##class(web.DHCBL.CT.CTLocationListLocations).GetCheckedFlag(loclistid,CTLOCRowID)
					if (FilterCK="checked") //如果为checked，只显示勾选的数据
					{	
						if (CheckedFlag) 
						{
							
						}
						else 
						{
							continue
						}
					}
					elseif (FilterCK="unchecked") //如果为checked，只显示未勾选的数据
					{	
						if (CheckedFlag) 
						{
							continue
						}
					}
					if (CTLOCHospitalDR'="")&(BDPHospAutflag="Y")
			        {
			            s HOSPDesc=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)   //开了医院级授权，科室后面显示医院信息
			            s HOSPShortName=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",39)   //简称
			            if HOSPShortName'="" s CTLOCDesc=CTLOCDesc_"【"_HOSPShortName_"】"
			            else  s CTLOCDesc=CTLOCDesc_"【"_HOSPDesc_"】"
			        }
			        s CTLOCDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(CTLOCDesc)
					w:count2'=0 ","		//多条科室用逗号隔开
					s count2=count2+1
					s mid=CTLOCRowID_"^"_loclistid
					w "{""id"":"""_""_mid_""",""text"":"""_CTLOCDesc_""","
					if (CheckedFlag)
					{
						w """checked"":true,"		//根据CheckedFlag判断树的节点是否被勾选
						s listcheckflag="true"		//同时父节点也勾选
					}else
					{
						w """checked"":false,"
					}
					w """leaf"":true}"
		        }
			}
			w "],""checked"":"_listcheckflag_"}"
		}
	}
	w "]"
	q ""
}

/// 判断科室列表与科室是否关联
/// CheckedFlag=1 checked：true
/// 2020-12-10 likefan
/// input：科室列表id，科室id
/// output：1 关联 / 0 未关联
/// w ##class(web.DHCBL.CT.CTLocationListLocations).GetCheckedFlag("3","2")
ClassMethod GetCheckedFlag(loclistid As %String, locid As %String) As %String
{
	s CheckedFlag=0
	q:(loclistid="")||(locid="") CheckedFlag
	if $d(^CT("LL",0,"Loc1",locid,loclistid))
	{
		s CheckedFlag=1
	}
	q CheckedFlag
}

/// Description:保存新增树节点
/// CheckedFlag=1 checked：true
/// 2020-12-10 likefan
/// input：科室列表id，科室id
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
/// w ##class(web.DHCBL.CT.CTLocationListLocations).SaveTreePanel("3","2")
ClassMethod SaveTreePanel(loclistid As %String, locid As %String) As %String
{
	s result=""
	q:(loclistid="")||(locid="") result
	s CTLOCHospitalDR=$p($g(^CTLOC(locid)),"^",22)     //医院
	s eobj=##class(web.Entity.CT.CTLocationListLocations).%New()
	s eobj.ParentRowId=loclistid
	s eobj.CTLOCDR=locid
	s eobj.HospitalCTDR=CTLOCHospitalDR
	s flag=##class(web.DHCBL.CT.CTLocationListLocations).FormValidate("",loclistid,CTLOCHospitalDR,locid)
	s:flag=0 result=##class(web.DHCBL.CT.CTLocationListLocations).SaveEntity(eobj)
	s:flag=1 result="数据已存在"
	q result
}

/// Description：删除树节点
/// CheckedFlag=1 checked：true
/// 2020-12-10 likefan
/// input：科室列表id，科室id
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
/// w ##class(web.DHCBL.CT.CTLocationListLocations).DeleteTreePanel("55","2")
ClassMethod DeleteTreePanel(loclistid As %String, locid As %String) As %String
{
	s result=""
	q:(loclistid="")||(locid="") result
	s childsub=$o(^CT("LL",0,"Loc1",locid,loclistid,0))
	if (childsub'="")
	{
		s id=loclistid_"||"_childsub
		s result=##class(web.DHCBL.CT.CTLocationListLocations).DeleteData(id)
	}
	q result
}

/// Description：保存或删除树节点，供前台js调用
/// 2021-01-21 likefan
/// input：科室id^科室列表id^true$科室id^科室列表id^true$科室id^科室列表id^false$……
/// Return:1
/// w ##class(web.DHCBL.CT.CTLocationListLocations).UpdateTree()
ClassMethod UpdateTree(savestr As %String) As %String
{
	q:savestr="" ""
	s ^templkf(1)=savestr
	for i=1:1:$l(savestr,"$")
	{
		s str=$p(savestr,"$",i)
		s locid=$p(str,"^",1)
		s listid=$p(str,"^",2)
		s checked=$p(str,"^",3)
		if (checked="true")
		{
			d ##class(web.DHCBL.CT.CTLocationListLocations).SaveTreePanel(listid,locid)
		}
		if (checked="false")
		{
			d ##class(web.DHCBL.CT.CTLocationListLocations).DeleteTreePanel(listid,locid)
		}
	}
	q 1
}

}
