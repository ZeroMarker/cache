/// CreateDate:2012-08-13
/// Creator:基础数据平台 ，孙凤超
/// Function:帐单子组维护
/// Tables:ARC_BillSub，
Class web.DHCBL.CT.ARCBillSub Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "ARC_BillSub";

/// Function:进行数据的模糊查询检索，查询账单组的信息
/// CreateDate:2012-08-13
/// Creator:基础数据平台组 孙凤超
/// Tables: ARC_BillSub
/// Input: rowid, code, desc, query, ArcbgAbbrev, ARCSGARCBGParRef
/// Output：ARCSG_ARCBG_ParRef ARCSG_RowId ，ARCSG_ChildSub ARCSG_Code ARCSG_Desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCBillSub", "GetList","",","qtcl","61")
Query GetList(rowid As %String, code As %String, desc As %String, ParRef As %String, hospid As %String) As %Query(ROWSPEC = "ARCSGRowId:%String,ParRef2:%String,ARCSGCode:%String,ARCSGDesc:%String,ARCSGAbbrev:%String")
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

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, ParRef As %String, hospid As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 if (rowid '="") 
 {
   s ChildSub=$p($g(rowid),"||",2)
   s ParRef2=$p($g(rowid),"||",1)
   s ARCSGRowId=rowid
   s ARCSGCode=$P($g(^ARCBG(ParRef2,"SG",ChildSub)),"^",1)
   s ARCSGDesc=$P($g(^ARCBG(ParRef2,"SG",ChildSub)),"^",2)
   s ARCSGAbbrev=$P($g(^ARCBG(ParRef2,"SG",ChildSub)),"^",3)
   d OutputRow
 }
 else  
 {
   s:code'="" code=$ZCVT(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U")  
   if ParRef'=""
   {
	   s ChildSub =0
	   for 
	   {
		   s ChildSub=$o(^ARCBG(ParRef,"SG",ChildSub)) q:((ChildSub="")||(ChildSub'>0))
		   
		   s ARCSGRowId=ParRef_"||"_ChildSub
	       s ParRef2=ParRef
	       s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCSGRowId,hospid)
		   continue:(showflag="N")
		   s ARCSGCode=$P($g(^ARCBG(ParRef,"SG",ChildSub)),"^",1)
		   s ARCSGDesc=$P($g(^ARCBG(ParRef,"SG",ChildSub)),"^",2)
		   S PINYINCODE=""
		   s:desc'="" PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ARCSGDesc)
		   s ARCSGAbbrev=$P($g(^ARCBG(ParRef,"SG",ChildSub)),"^",3)
		   i (($ZCVT(ARCSGDesc,"U")[desc)||(PINYINCODE[desc))&(($ZCVT(ARCSGCode,"U")[code))  
		   {
		   		d OutputRow	
		   }
	   }
	   
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow   
 set Data=$lb(ARCSGRowId,ParRef2,ARCSGCode,ARCSGDesc,ARCSGAbbrev)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:进行数据检索，查询账单组的信息
/// CreateDate:2012-08-13
/// Creator:基础数据平台组 孙凤超
/// Tables: ARC_BillSub
/// Input: rowid 
/// Output：ARCSG_ARCBG_ParRef ARCSG_RowId ，ARCSG_ChildSub ARCSG_Code ARCSG_Desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCBillSub", "GetDataForCmb1","","","","66||1")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, ParRef As %String, hospid As %String) As %Query(ROWSPEC = "ARCSGRowId:%String,ARCSGCode:%String,ARCSGDesc:%String")
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

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, ParRef As %String, hospid As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   s ind=1
   s:code'="" code=$ZCVT(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U")  
   if (rowid '="") 
   {
     s ParRef2=$p($g(rowid),"||",1)
     s ChildSub=$p($g(rowid),"||",2) 
     s ARCSGRowId=rowid
     s ARCSGCode=$P($g(^ARCBG(ParRef2,"SG",ChildSub)),"^",1)
     s ARCSGDesc=$P($g(^ARCBG(ParRef2,"SG",ChildSub)),"^",2) 
     s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ARCSGDesc) 
     d OutputRowCmb
   }
   else  
   { 
     if (ParRef'="")
     {
         s ChildSub =0
         for
         {
	         s ChildSub=$o(^ARCBG(ParRef,"SG",ChildSub)) q:((ChildSub="")||(ChildSub'>0))
	         s ARCSGRowId=ParRef_"||"_ChildSub
	         s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCSGRowId,hospid)
		     continue:(showflag="N")
	         s ARCSGCode=$P($g(^ARCBG(ParRef,"SG",ChildSub)),"^",1)
	         s ARCSGDesc=$P($g(^ARCBG(ParRef,"SG",ChildSub)),"^",2)
	         S PINYINCODE=""
	         s:desc'="" PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ARCSGDesc)
	         if (($ZCVT(ARCSGDesc,"U")[desc)||(PINYINCODE[desc))&(($ZCVT(ARCSGCode,"U")[code)) 
         	 {
	         	 d OutputRowCmb
         	 }
         }
        
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
  set Data2=$lb(ARCSGRowId,ARCSGCode,ARCSGDesc)
  Set ^CacheTemp(repid,ind)=Data2
  Set ind=ind+1
  q
}

/// Function:用于数据删除时的逻辑判断
/// CreateDate:2013-6-28
/// Ctreator:BDP-Sunfengchao
/// Input:rowid  （账单子组的rowid)
/// Output:返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
ClassMethod GetRefFlag(id As %String) As %String
{
   s return="",myInfo=""
   s found1=0
   if ($d(^ARCIM(0,"ARCSG_DR",id))) s found1=1
   if (found1=1)  s myInfo=myInfo_"<医嘱项>"
   if (myInfo="")
   {
     s return="0^未被引用可删除！"
   }
   else 
   {
    s return="1^在"_myInfo_"表里被引用,不能删除!"
   }
    q return
}

/// Function:实现对账单子组信息的删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-13
/// Desc:通过ARCSG_RowId来删除付款人的信息
/// Input: ARCSG_RowId
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables:ARC_BillSub， 
/// Others:d ##class(web.DHCBL.CT.ARCBillSub).DeleteData("66||6")
ClassMethod DeleteData(id) As %String
{
 s result="",flag=""
 s re=##class(web.DHCBL.CT.ARCBillSub).GetRefFlag(id)
 s RefFlag=$p(re,"^",1)
 if (RefFlag=1)
 {
  s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
 }
 else
 {
  s ParentRowid=$p($g(id),"||",1)        
  s eobj = ##class(web.Entity.CT.ARCBillSub).%New()
  s obj=##class(User.ARCBillSub).%OpenId(id)  
  s eobj.ARCSGRowId=id
  s eobj.ARCSGCode =obj.ARCSGCode  //代码
  s eobj.ARCSGDesc=obj.ARCSGDesc 
  s eobj.ARCSGAbbrev =obj.ARCSGAbbrev   
  s ARCBGDesc=$p($g(^ARCBG(ParentRowid)),"^",2) 
 
  Tstart
  s sc=##class(User.ARCBillSub).%DeleteId(id)

  if $$$ISOK(sc)
  {
   Tc
   s result="{success:'true',info:'删除成功！'}"
   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_BillSub","User.ARCBillSub","账单子组",id,ARCBGDesc_"->"_eobj.ARCSGDesc,"D",eobj)
  }
  else
  {
    Trollback
    s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
  }
 }
 q result
}

/// Function:显示账单子组信息的打开窗口
/// CreateDate:2012-08-13
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:输入sid
/// Tables:  ARC_BillGrp
/// Others: w ##class(web.DHCBL.CT.ARCBillSub).OpenData("66||1")
ClassMethod OpenData(sid As %String) As %String
{
 s str=""
 s ParRef=$p(sid,"||",1)
 s ChildSub=$p(sid,"||",2)
 s eobj = ##class(web.Entity.CT.ARCBillSub).%New()
 s eobj.ARCSGRowId=sid
 s eobj.ARCSGCode =$P($g(^ARCBG(ParRef,"SG",ChildSub)),"^",1)  //代码
 s eobj.ARCSGDesc=$P($g(^ARCBG(ParRef,"SG",ChildSub)),"^",2)   
 s eobj.ARCSGAbbrev = $P($g(^ARCBG(ParRef,"SG",ChildSub)),"^",3)    ///缩写
    
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：孙凤超
/// CreatDate: 2012-12-7
/// Description：数据重复校验
/// Table： ARC_BillSub
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复) ","输血费",56,1)
/// Other: w ##class(web.DHCBL.CT.ARCBillSub).FormValidate("59||1","","诊疗费","诊疗费")
ClassMethod FormValidate(id As %String, ParRef As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
	if id'="" s ParRef=$p(id,"||",1)
	if $$ALPHAUP^SSUTIL4(code)'=""
	{
		s parref=0
		for
		{
			s parref=$o(^ARCBG("SG_Code",$$ALPHAUP^SSUTIL4(code),parref)) q:parref=""
			s sub=0
			for
			{
				s sub=$o(^ARCBG("SG_Code",$$ALPHAUP^SSUTIL4(code),parref,sub)) q:sub=""
				s idc=parref_"||"_sub
				if (parref=ParRef)&&(id'=idc)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
					continue:showflag="N"
					s flag=1
				}
			}
		}
	}
	
	if $$ALPHAUP^SSUTIL4(desc)'=""
	{
		s parref=0
		for
		{
			s parref=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(desc),parref)) q:parref=""
			s sub=0
			for
			{
				s sub=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(desc),parref,sub)) q:sub=""
				s idd=parref_"||"_sub
				if (parref=ParRef)&&(id'=idd)
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
					continue:showflag="N"
					s flag=1
				}
			}
		}
		
	}
	q flag
}

/// Function:实现对账单子组信息的添加和修改操作
/// Creator:孙凤超
/// CreateDate:2012-08-13
/// Output:success:'true',info:'添加成功！' 失败时输出添加失败！
///        success:'false',info:'修改 成功' 失败时输出修改失败！
/// Tables: ARC_BillSub
/// Others:d ##class(web.DHCBL.CT.ARCBillSub).SaveEntity("")
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCBillSub) As %String
{
     s result="" 
     if (eobj.ARCSGRowId="")      
     {
       Ts
       s obj=##class(User.ARCBillSub).%New(eobj.ParentRowId)
       d obj.ARCSGARCBGParRefSetObjectId(eobj.ParentRowId)
       s obj.ARCSGCode = eobj.ARCSGCode                     
       s obj.ARCSGDesc = eobj.ARCSGDesc  
       s obj.ARCSGAbbrev = eobj.ARCSGAbbrev
       s oobj=##class(User.ARCBillGrp).%OpenId(eobj.ParentRowId)
       s oobj.ARCBGDesc=$p($g(^ARCBG(eobj.ParentRowId)),"^",2) 
       
       s sc=obj.%Save()
       d obj.%Close()
       If $$$ISOK(sc)
       {  
         Tc
         s id = obj.%Id()
         s result = "{success:'true',id:'"_id_"'}"         
         d:eobj.ARCSGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_BillSub","User.ARCBillSub","帐单子组",id,oobj.ARCBGDesc_"->"_eobj.ARCSGDesc,"A",eobj)
       }
      else 
      {
        Trollback
        s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
      }
     } 
  ///如果RowId已赋值则修改
  else                                                 
  {
      s obj=##class(User.ARCBillSub).%OpenId(eobj.ARCSGRowId) ///修改的是单条数据如“66||1”的数据
      s bobj=##class(web.Entity.CT.ARCBillSub).%New()
      s bobj.ARCSGRowId=eobj.ARCSGRowId
      s bobj.ARCSGCode=obj.ARCSGCode
      s bobj.ARCSGDesc=obj.ARCSGDesc
      s bobj.ARCSGAbbrev=obj.ARCSGAbbrev
      
      d:eobj.ParentRowId'="" obj.ARCSGARCBGParRefSetObjectId(eobj.ParentRowId) //修改数据时ParentRowId为空
      s obj.ARCSGCode = eobj.ARCSGCode                     
      s obj.ARCSGDesc = eobj.ARCSGDesc  
      s obj.ARCSGAbbrev = eobj.ARCSGAbbrev
      s ParentRowID=$p(eobj.ARCSGRowId,"||",1)
      s ARCBGDesc=$p($g(^ARCBG(ParentRowID)),"^",2) 
      Ts
      s sc=obj.%Save()
      d obj.%Close()
      if $$$ISOK(sc)
      {  
        s id = obj.%Id()
        Tc
        s result = "{success:'true',id:'"_id_"'}"         
        d:eobj.ARCSGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_BillSub","User.ARCBillSub","账单子组",eobj.ARCSGRowId,ARCBGDesc_"->"_eobj.ARCSGDesc,"U",eobj,bobj)
      }
      else ///如果保存不成功的话
      {
       Trollback
       s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
       s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("账单子组","web.DHCBL.CT.ARCBillSub","SaveEntity",eobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
      }  
    }
     q result
}

/// Function:获取父表的描述
/// CreateDate:2016-10-12
/// Creator:sunfengchao
/// Debug: w ##class(web.DHCBL.CT.ARCBillSub).GetParentDesc("35")
ClassMethod GetParentDesc(ParentId As %String) As %String
{
   s result=""
   s result=$p($g(^ARCBG(ParentId)),"^",2)
   q result
}

}
