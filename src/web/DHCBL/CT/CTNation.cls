Import SQLUser

/// 名称: 民族
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.CTNation Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.CTNation
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.CTNation).%New()
 s pobj = ##class(User.CTNation).%OpenId(id)
 s eobj.CTNATRowId = id
 s eobj.CTNATCode=pobj.CTNATCode
 s eobj.CTNATDesc=pobj.CTNATDesc
 s eobj.CTNATRomanCode=pobj.CTNATRomanCode
 s eobj.CTNATRomanDesc=pobj.CTNATRomanDesc
 s eobj.CTNATForeignDesc=pobj.CTNATForeignDesc
 s eobj.CTNATStartDate=pobj.CTNATStartDate
 s eobj.CTNATEndDate=pobj.CTNATEndDate
 s:eobj.CTNATStartDate'="" eobj.CTNATStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTNATStartDate) //转换日期格式
 s:eobj.CTNATEndDate'="" eobj.CTNATEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTNATEndDate) //转换日期格式
 s eobj.CTNATActivity=pobj.CTNATActivity
 s:eobj.CTNATActivity="" eobj.CTNATActivity="Y"
 s:eobj.CTNATActivity="Y" eobj.CTNATActivity="true"
 s eobj.CTNATSeqNo=pobj.CTNATSeqNo
 s eobj.CTNATPYCode=pobj.CTNATPYCode
 s eobj.CTNATWBCode=pobj.CTNATWBCode
 s eobj.CTNATMark=pobj.CTNATMark
 
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.CTNation
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("NAT",0,"Code",code))
 s:desc'="" flagd=$d(^CT("NAT",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("NAT",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("NAT",0,"Desc",desc,0))
  if (desc="")
  {
   if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
  elseif (code="")
  {
   if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-11-7
/// Description：数据重复验证方法
/// Table：User.CTNation
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("NAT",0,"Code",code))
 s:desc'="" flagd=$d(^CT("NAT",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("NAT",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("NAT",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：保存修改民族的内容
/// Table：User.CTNation
/// Input：web.Entity.CT.CTNation 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.CTNation).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.CTNation) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.CTNATStartDate'="" eobj.CTNATStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTNATStartDate) //转换日期
  s:eobj.CTNATEndDate'="" eobj.CTNATEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTNATEndDate)      //转换日期
  s:eobj.CTNATStartDate="" eobj.CTNATStartDate=+$h
  
  s USERID=""
  s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
  
  s:eobj.CTNATLastUpdateDate="" eobj.CTNATLastUpdateDate=+$h		//系统最后更新日期
  s:eobj.CTNATLastUpdateTime="" eobj.CTNATLastUpdateTime=$p($h,",",2)		//系统最后更新时间
  s:eobj.CTNATLastUpdateUser="" eobj.CTNATLastUpdateUser=USERID	//系统最新更新人
  s:eobj.CTNATActivity="" eobj.CTNATActivity="N"		//是否有效
    
  s:eobj.CTNATPYCode="" eobj.CTNATPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.CTNATPYCode,4)
  s:eobj.CTNATWBCode="" eobj.CTNATWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.CTNATWBCode,1)
  
  s flag=..Validate(eobj.CTNATRowId,eobj.CTNATCode,eobj.CTNATDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.CTNATRowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.CTNation).%New()
    
    s:eobj.CTNATCreateDate="" eobj.CTNATCreateDate=+$h	//系统创建日期默认当前日期
	s:eobj.CTNATCreateTime="" eobj.CTNATCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
	s:eobj.CTNATCreateUser="" eobj.CTNATCreateUser= USERID		//系统创建人默认当前登录人员
	s obj.CTNATCreateDate=eobj.CTNATCreateDate		//系统创建日期
	s obj.CTNATCreateTime=eobj.CTNATCreateTime		//系统创建时间
	d obj.CTNATCreateUserSetObjectId(eobj.CTNATCreateUser)	//系统创建人
   }
   else                     //如果RowId已赋值则修改
   {
    s obj=##class(User.CTNation).%OpenId(eobj.CTNATRowId)
    s bobj=##class(web.Entity.CT.CTNation).%New()
    s bobj.CTNATRowId=eobj.CTNATRowId
    s bobj.CTNATCode = obj.CTNATCode         
    s bobj.CTNATDesc = obj.CTNATDesc 
    s bobj.CTNATRomanCode = obj.CTNATRomanCode
    s bobj.CTNATRomanDesc = obj.CTNATRomanDesc 
    s bobj.CTNATForeignDesc = obj.CTNATForeignDesc   
    s bobj.CTNATStartDate = obj.CTNATStartDate  //修改开始日期
    s bobj.CTNATEndDate = obj.CTNATEndDate      //修改结束日期 
    s bobj.CTNATActivity=obj.CTNATActivity	//是否有效(Y/N)
    s bobj.CTNATCreateDate=obj.CTNATCreateDate		//系统创建日期
	s bobj.CTNATCreateTime=obj.CTNATCreateTime		//系统创建时间
	s:$IsObject(obj.CTNATCreateUser) bobj.CTNATCreateUser = obj.CTNATCreateUser.%Id() 	//系统创建人
	s bobj.CTNATSeqNo=obj.CTNATSeqNo		//系统排序号
	s bobj.CTNATLastUpdateDate=obj.CTNATLastUpdateDate		//系统最后更新日期
	s bobj.CTNATLastUpdateTime=obj.CTNATLastUpdateTime		//系统最后更新时间
	s:$IsObject(obj.CTNATLastUpdateUser) bobj.CTNATLastUpdateUser = obj.CTNATLastUpdateUser.%Id() 	//系统最新更新人
	s bobj.CTNATPYCode=obj.CTNATPYCode		//拼音码
	s bobj.CTNATWBCode=obj.CTNATWBCode		//五笔码
	s bobj.CTNATMark=obj.CTNATMark		//备注  
   }
   Ts         
   s obj.CTNATCode = eobj.CTNATCode          //修改代码
   s obj.CTNATDesc = eobj.CTNATDesc          //修改描述  
   s obj.CTNATRomanCode = eobj.CTNATRomanCode 
   s obj.CTNATRomanDesc = eobj.CTNATRomanDesc  
   s obj.CTNATForeignDesc = eobj.CTNATForeignDesc  
   s obj.CTNATStartDate = eobj.CTNATStartDate  //修改开始日期
   s obj.CTNATEndDate = eobj.CTNATEndDate      //修改结束日期
   s obj.CTNATActivity=eobj.CTNATActivity	//是否有效(Y/N)
   s obj.CTNATSeqNo=eobj.CTNATSeqNo		//系统排序号
   s obj.CTNATLastUpdateDate=eobj.CTNATLastUpdateDate		//系统最后更新日期
   s obj.CTNATLastUpdateTime=eobj.CTNATLastUpdateTime		//系统最后更新时间
   d obj.CTNATLastUpdateUserSetObjectId(eobj.CTNATLastUpdateUser)	//系统最新更新人
   s obj.CTNATPYCode=eobj.CTNATPYCode		//拼音码
   s obj.CTNATWBCode=eobj.CTNATWBCode		//五笔码
   s obj.CTNATMark=eobj.CTNATMark		//备注   
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.CTNATRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Nation","User.CTNation","民族",id,eobj.CTNATDesc,"A",eobj)
    d:eobj.CTNATRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Nation","User.CTNation","民族",eobj.CTNATRowId,eobj.CTNATDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("民族","web.DHCBL.CT.CTNation","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }
 }
 else
 {
  s result= "{success:'false',errorinfo:'对象不存在！'}"
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("民族","web.DHCBL.CT.CTNation","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
 }
 q result
ERROE
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("民族","web.DHCBL.CT.CTNation","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// 删除时验证数据是否被引用
ClassMethod GetRefFlag(id As %String) As %String
{
 s return="",myInfo=""
 
  // 是否被"HOS人员基本信息"引用
  if $d(^CT.BDP.CT.HOSPersonI("IndexNationCode",id))
	{
	    s myInfo=myInfo_"<HOS人员基本信息>"
	}
  
  i myInfo="" s return="0^未被引用可删除!"
  else  s return="1^在"_myInfo_"表里被引用,不能删除!"
  q return
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：根据ID删除民族的内容
/// Table：User.CTNation
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
  //验证是否被引用
  s re=..GetRefFlag(id)
 if ($p(re,"^",1)) {
  s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
 }
 else
 {
	 s eobj = ##class(web.Entity.CT.CTNation).%New()
	 s pobj = ##class(User.CTNation).%OpenId(id)
	 s eobj.CTNATRowId = id
	 s eobj.CTNATCode=pobj.CTNATCode
	 s eobj.CTNATDesc=pobj.CTNATDesc
	 s eobj.CTNATRomanCode=pobj.CTNATRomanCode
	 s eobj.CTNATRomanDesc=pobj.CTNATRomanDesc
	 s eobj.CTNATForeignDesc=pobj.CTNATForeignDesc 
	 s eobj.CTNATStartDate=pobj.CTNATStartDate
	 s eobj.CTNATEndDate=pobj.CTNATEndDate
	 s eobj.CTNATActivity=pobj.CTNATActivity	//是否有效(Y/N)
	 s eobj.CTNATCreateDate=pobj.CTNATCreateDate		//系统创建日期
	 s eobj.CTNATCreateTime=pobj.CTNATCreateTime		//系统创建时间
	 s:$IsObject(pobj.CTNATCreateUser) eobj.CTNATCreateUser = pobj.CTNATCreateUser.%Id() 	//系统创建人
	 s eobj.CTNATSeqNo=pobj.CTNATSeqNo		//系统排序号
	 s eobj.CTNATLastUpdateDate=pobj.CTNATLastUpdateDate		//系统最后更新日期
	 s eobj.CTNATLastUpdateTime=pobj.CTNATLastUpdateTime		//系统最后更新时间
	 s:$IsObject(pobj.CTNATLastUpdateUser) eobj.CTNATLastUpdateUser = pobj.CTNATLastUpdateUser.%Id() 	//系统最新更新人
	 s eobj.CTNATPYCode=pobj.CTNATPYCode		//拼音码
	 s eobj.CTNATWBCode=pobj.CTNATWBCode		//五笔码
	 s eobj.CTNATMark=pobj.CTNATMark		//备注
	 
	 s sc=##class(User.CTNation).%DeleteId(id)
	 if $$$ISOK(sc)
	 {
	  s result= "{success:'true',info:'删除成功！'}"
	  //保存日志
	  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Nation","User.CTNation","民族",id,eobj.CTNATDesc,"D",eobj)
	  d eobj.%Close()
	 }
	 else
	 {
	  s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
	  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("民族","web.DHCBL.CT.CTNation","DeleteData",eobj)
	  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	 }
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：查询民族的内容
/// Table： CT_Nation
/// Input：rowid,code,desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTNation","GetList","2","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTNATRowId:%String,CTNATCode:%String,CTNATDesc:%String ,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,CTNATRomanCode,CTNATRomanDesc,CTNATForeignDesc,CTNATActivity,CTNATStartDate,CTNATEndDate,CTNATSeqNo,CTNATPYCode,CTNATWBCode,CTNATMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
 
   //获取授权Json
   s AuStr=##class(web.DHCBL.Authorize.CTNation).DHCGetDataByDefaultSession()
   s AuFlag=0
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
  
   if (rowid'="") //根据rowid返回该条记录
   {
     s CTNATRowId=rowid
     s CTNATCode=$p($g(^CT("NAT",CTNATRowId)),"^",1)
     s CTNATDesc=$p($g(^CT("NAT",CTNATRowId)),"^",2)
     s CTNATRomanCode=$p($g(^CT("NAT",CTNATRowId)),"^",3)    //民族罗马代码
     s CTNATRomanDesc=$p($g(^CT("NAT",CTNATRowId)),"^",4)    //民族罗马名称
     s CTNATForeignDesc=$p($g(^CT("NAT",CTNATRowId)),"^",5)    //民族外国名称
     s CTNATActivity=$p($g(^CT("NAT",CTNATRowId)),"^",6) 	//是否有效(Y/N)
     s:CTNATActivity="" CTNATActivity="Y"
     s CTNATStartDate=$p($g(^CT("NAT",CTNATRowId)),"^",7)     //开始日期
     s CTNATEndDate=$p($g(^CT("NAT",CTNATRowId)),"^",8)    //结束日期
     s:CTNATStartDate'="" CTNATStartDate=$zd(CTNATStartDate,1,"",4)  
     s:CTNATEndDate'="" CTNATEndDate=$zd(CTNATEndDate,1)  
     s CTNATSeqNo=$p($g(^CT("NAT",CTNATRowId)),"^",12) 		//系统排序号
	 s CTNATPYCode=$p($g(^CT("NAT",CTNATRowId)),"^",16) 		//拼音码
	 s CTNATWBCode=$p($g(^CT("NAT",CTNATRowId)),"^",17) 		//五笔码
	 s CTNATMark=$p($g(^CT("NAT",CTNATRowId)),"^",18)		//备注
     
     s BDPStandardRowId=$o(^User.BDPStandardCodeI("DataRef","CT_Nation",CTNATRowId,0)) 
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Nation",CTNATRowId)
     s BDPInternalCode =$p($g(resultStr),"^",1)       
     s BDPInternalDesc = $p($g(resultStr),"^",2)  
     s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
     d OutputRow
  }
   else
   {
      s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
      s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
      s CTNATRowId=0
      for 
      {
        s CTNATRowId=$o(^CT("NAT",CTNATRowId))
        q:CTNATRowId=""
        ;筛选授权后的数据
        s strRowId="{ID:"_CTNATRowId_"}"
        if (AuStr[strRowId)||(AuFlag=1) 
        {
           s CTNATCode=$p($g(^CT("NAT",CTNATRowId)),"^",1)
           s CTNATDesc=$p($g(^CT("NAT",CTNATRowId)),"^",2) 
           s CTNATRomanCode=$p($g(^CT("NAT",CTNATRowId)),"^",3)    //民族罗马代码
		   s CTNATRomanDesc=$p($g(^CT("NAT",CTNATRowId)),"^",4)    //民族罗马名称
		   s CTNATForeignDesc=$p($g(^CT("NAT",CTNATRowId)),"^",5)    //民族外国名称
		   s CTNATActivity=$p($g(^CT("NAT",CTNATRowId)),"^",6) 	//是否有效(Y/N)
		   s:CTNATActivity="" CTNATActivity="Y"
		   s CTNATStartDate=$p($g(^CT("NAT",CTNATRowId)),"^",7)     //开始日期
		   s CTNATEndDate=$p($g(^CT("NAT",CTNATRowId)),"^",8)    //结束日期
		   s:CTNATStartDate'="" CTNATStartDate=$zd(CTNATStartDate,1,"",4)  
		   s:CTNATEndDate'="" CTNATEndDate=$zd(CTNATEndDate,1)  
		   s CTNATSeqNo=$p($g(^CT("NAT",CTNATRowId)),"^",12) 		//系统排序号
		   s CTNATPYCode=$p($g(^CT("NAT",CTNATRowId)),"^",16) 		//拼音码
		   s CTNATWBCode=$p($g(^CT("NAT",CTNATRowId)),"^",17) 		//五笔码
		   s CTNATMark=$p($g(^CT("NAT",CTNATRowId)),"^",18)		//备注
           s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
           s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Nation",CTNATRowId)
           s BDPInternalCode =$p($g(resultStr),"^",1)       
           s BDPInternalDesc = $p($g(resultStr),"^",2)  
           s BDPHospNationalCode=$p($g(resultStr),"^",3)         
           s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
           if (desc'="")
           {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Nation",CTNATRowId,CTNATDesc,desc)
           }
           else
           {
            s AliasFlag= 1   
           }   
           if ($ZCVT(CTNATCode,"U")[code)&(AliasFlag=1)  
           {
             d OutputRow
           }
       }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(CTNATRowId,CTNATCode,CTNATDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,CTNATRomanCode,CTNATRomanDesc,CTNATForeignDesc,CTNATActivity,CTNATStartDate,CTNATEndDate,CTNATSeqNo,CTNATPYCode,CTNATWBCode,CTNATMark)
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

/// Creator：sunfengchao
/// CreatDate: 2012-12-10
/// Description：查询民族的内容,用于combox查询
/// Table：User.CTNation
/// Input：rowid,code,desc
/// Return：CTNATRowId,CTNATCode,CTNATDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTNation","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTNATRowId:%String,CTNATCode:%String,CTNATDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.CTNation).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s CTNATRowId=rowid
  s CTNATCode=$p($g(^CT("NAT",CTNATRowId)),"^",1)
  s CTNATDesc=$p($g(^CT("NAT",CTNATRowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
  s CTNATRowId=0
  for {
   s CTNATRowId=$o(^CT("NAT",CTNATRowId))
   q:CTNATRowId=""
   
   s CTNATActivity=$p($g(^CT("NAT",CTNATRowId)),"^",6) 	//是否有效(Y/N)
   s CTNATStartDate=$p($g(^CT("NAT",CTNATRowId)),"^",7)     //开始日期
   s CTNATEndDate=$p($g(^CT("NAT",CTNATRowId)),"^",8)    //结束日期
   continue:CTNATActivity="N"
   continue:(CTNATStartDate'="")&&(CTNATStartDate>+$h)
   continue:(CTNATEndDate'="")&&(CTNATEndDate<+$h)
   
   //筛选授权后的数据
   s strRowId="{ID:"_CTNATRowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) 
   {
       s CTNATCode=$p($g(^CT("NAT",CTNATRowId)),"^",1)
       s CTNATDesc=$p($g(^CT("NAT",CTNATRowId)),"^",2)
       
       if (desc'="")
       {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Nation",CTNATRowId,CTNATDesc,desc)
       }
       else
       {
        s AliasFlag= 1   
       }   
       if ($ZCVT(CTNATCode,"U")[code)&(AliasFlag=1)  
       {
          d OutputRow2
       }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(CTNATRowId,CTNATCode,CTNATDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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
