/// 名称: 教育水平
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台-sunfengchao
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.CTEducation Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.CTEducation
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.CTEducation).%New()
 s pobj = ##class(User.CTEducation).%OpenId(id)
 s eobj.EDURowId = id
 s eobj.EDUCode=pobj.EDUCode
 s eobj.EDUDesc=pobj.EDUDesc
 s eobj.EDUClass=pobj.EDUClass
 s eobj.EDUStatus=pobj.EDUStatus
 s eobj.EDUStartDate=pobj.EDUStartDate
 s eobj.EDUEndDate=pobj.EDUEndDate
 s:eobj.EDUStartDate'="" eobj.EDUStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.EDUStartDate) //转换日期格式
 s:eobj.EDUEndDate'="" eobj.EDUEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.EDUEndDate) //转换日期格式
 s eobj.EDUActivity=pobj.EDUActivity
 s:eobj.EDUActivity="Y" eobj.EDUActivity="true"
 s eobj.EDUSeqNo=pobj.EDUSeqNo
 s eobj.EDUPYCode=pobj.EDUPYCode
 s eobj.EDUWBCode=pobj.EDUWBCode
 s eobj.EDUMark=pobj.EDUMark
 
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-11-7
/// Description：数据重复验证方法,js调用
/// Table：User.CTEducation
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("EDU",0,"Code",code))
 s:desc'="" flagd=$d(^CT("EDU",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("EDU",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("EDU",0,"Desc",desc,0))
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
/// Table：User.CTEducation
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("EDU",0,"Code",code))
 s:desc'="" flagd=$d(^CT("EDU",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("EDU",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("EDU",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：保存修改教育水平的内容
/// Table：User.CTEducation
/// Input：web.Entity.CT.CTEducation 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.CTEducation).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.CTEducation) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.EDUStartDate'="" eobj.EDUStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EDUStartDate) //转换日期
  s:eobj.EDUEndDate'="" eobj.EDUEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EDUEndDate)      //转换日期
  s:eobj.EDUStartDate="" eobj.EDUStartDate=+$h
  
  s USERID=""
  s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
  
  s:eobj.EDULastUpdateDate="" eobj.EDULastUpdateDate=+$h		//系统最后更新日期
  s:eobj.EDULastUpdateTime="" eobj.EDULastUpdateTime=$p($h,",",2)		//系统最后更新时间
  s:eobj.EDULastUpdateUser="" eobj.EDULastUpdateUser=USERID	//系统最新更新人
  s:eobj.EDUActivity="" eobj.EDUActivity="N"		//是否有效
    
  s:eobj.EDUPYCode="" eobj.EDUPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.EDUPYCode,4)
  s:eobj.EDUWBCode="" eobj.EDUWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.EDUWBCode,1)
	 
  s flag=..Validate(eobj.EDURowId,eobj.EDUCode,eobj.EDUDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.EDURowId="")   
   {
    s obj=##class(User.CTEducation).%New()
    
    s:eobj.EDUCreateDate="" eobj.EDUCreateDate=+$h	//系统创建日期默认当前日期
	s:eobj.EDUCreateTime="" eobj.EDUCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
	s:eobj.EDUCreateUser="" eobj.EDUCreateUser= USERID		//系统创建人默认当前登录人员
	s obj.EDUCreateDate=eobj.EDUCreateDate		//系统创建日期
	s obj.EDUCreateTime=eobj.EDUCreateTime		//系统创建时间
	d obj.EDUCreateUserSetObjectId(eobj.EDUCreateUser)	//系统创建人
   }
   else                   
   {
    s obj=##class(User.CTEducation).%OpenId(eobj.EDURowId)
    s bobj=##class(web.Entity.CT.CTEducation).%New()
    s bobj.EDURowId=eobj.EDURowId
    s bobj.EDUCode = obj.EDUCode          
    s bobj.EDUDesc = obj.EDUDesc  
    s bobj.EDUClass = obj.EDUClass 
    s bobj.EDUStatus = obj.EDUStatus   
    s bobj.EDUStartDate = obj.EDUStartDate  //修改开始日期
    s bobj.EDUEndDate = obj.EDUEndDate      //修改结束日期 
    s bobj.EDUActivity=obj.EDUActivity	//是否有效(Y/N)
    s bobj.EDUCreateDate=obj.EDUCreateDate		//系统创建日期
	s bobj.EDUCreateTime=obj.EDUCreateTime		//系统创建时间
	s:$IsObject(obj.EDUCreateUser) bobj.EDUCreateUser = obj.EDUCreateUser.%Id() 	//系统创建人
	s bobj.EDUSeqNo=obj.EDUSeqNo		//系统排序号
	s bobj.EDULastUpdateDate=obj.EDULastUpdateDate		//系统最后更新日期
	s bobj.EDULastUpdateTime=obj.EDULastUpdateTime		//系统最后更新时间
	s:$IsObject(obj.EDULastUpdateUser) bobj.EDULastUpdateUser = obj.EDULastUpdateUser.%Id() 	//系统最新更新人
	s bobj.EDUPYCode=obj.EDUPYCode		//拼音码
	s bobj.EDUWBCode=obj.EDUWBCode		//五笔码
	s bobj.EDUMark=obj.EDUMark		//备注      
   }
   Ts         
   s obj.EDUCode = eobj.EDUCode         
   s obj.EDUDesc = eobj.EDUDesc  
   s obj.EDUClass = eobj.EDUClass  
   s obj.EDUStatus = eobj.EDUStatus  
   s obj.EDUStartDate = eobj.EDUStartDate  //修改开始日期
   s obj.EDUEndDate = eobj.EDUEndDate      //修改结束日期
   s obj.EDUActivity=eobj.EDUActivity	//是否有效(Y/N)
   s obj.EDUSeqNo=eobj.EDUSeqNo		//系统排序号
   s obj.EDULastUpdateDate=eobj.EDULastUpdateDate		//系统最后更新日期
   s obj.EDULastUpdateTime=eobj.EDULastUpdateTime		//系统最后更新时间
   d obj.EDULastUpdateUserSetObjectId(eobj.EDULastUpdateUser)	//系统最新更新人
   s obj.EDUPYCode=eobj.EDUPYCode		//拼音码
   s obj.EDUWBCode=eobj.EDUWBCode		//五笔码
   s obj.EDUMark=eobj.EDUMark		//备注           
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         
    //保存日志
    d:eobj.EDURowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Education","User.CTEducation","教育水平",id,eobj.EDUDesc,"A",eobj)
    d:eobj.EDURowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Education","User.CTEducation","教育水平",eobj.EDURowId,eobj.EDUDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("教育水平","web.DHCBL.CT.CTEducation","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)    
   }
  }   
 }
 else
 {
  s result = "{success:'false',errorinfo:'对象不存在！'}"
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("教育水平","web.DHCBL.CT.CTEducation","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
 }
 q result
ERROE
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("教育水平","web.DHCBL.CT.CTEducation","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// 删除时验证数据是否被引用
ClassMethod GetRefFlag(id As %String) As %String
{
 s return="",myInfo=""
 
  // 是否被"HOS人员基本信息"引用
  if $d(^CT.BDP.CT.HOSPersonI("IndexEducationCode",id))
	{
	    s myInfo=myInfo_"<HOS人员基本信息>"
	}
  
  i myInfo="" s return="0^未被引用可删除!"
  else  s return="1^在"_myInfo_"表里被引用,不能删除!"
  q return
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：根据ID删除教育水平的内容
/// Table：User.CTEducation
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result = ""
 //验证是否被引用
  s re=..GetRefFlag(id)
 if ($p(re,"^",1)) {
  s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
 }
 else
 {
	 s eobj = ##class(web.Entity.CT.CTEducation).%New()
	 s pobj = ##class(User.CTEducation).%OpenId(id)
	 s eobj.EDURowId = id
	 s eobj.EDUCode=pobj.EDUCode
	 s eobj.EDUDesc=pobj.EDUDesc
	 s eobj.EDUClass=pobj.EDUClass
	 s eobj.EDUStatus=pobj.EDUStatus 
	 s eobj.EDUStartDate=pobj.EDUStartDate
	 s eobj.EDUEndDate=pobj.EDUEndDate
	 s eobj.EDUActivity=pobj.EDUActivity	//是否有效(Y/N)
	 s eobj.EDUCreateDate=pobj.EDUCreateDate		//系统创建日期
	 s eobj.EDUCreateTime=pobj.EDUCreateTime		//系统创建时间
	 s:$IsObject(pobj.EDUCreateUser) eobj.EDUCreateUser = pobj.EDUCreateUser.%Id() 	//系统创建人
	 s eobj.EDUSeqNo=pobj.EDUSeqNo		//系统排序号
	 s eobj.EDULastUpdateDate=pobj.EDULastUpdateDate		//系统最后更新日期
	 s eobj.EDULastUpdateTime=pobj.EDULastUpdateTime		//系统最后更新时间
	 s:$IsObject(pobj.EDULastUpdateUser) eobj.EDULastUpdateUser = pobj.EDULastUpdateUser.%Id() 	//系统最新更新人
	 s eobj.EDUPYCode=pobj.EDUPYCode		//拼音码
	 s eobj.EDUWBCode=pobj.EDUWBCode		//五笔码
	 s eobj.EDUMark=pobj.EDUMark		//备注
	 TStart
	 s sc=##class(User.CTEducation).%DeleteId(id)
	 if $$$ISOK(sc)
	 {
	  Tcommit
	  s result = "{success:'true',info:'删除成功！'}"
	  //保存日志
	  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Education","User.CTEducation","教育水平",id,eobj.EDUDesc,"D",eobj)
	  d eobj.%Close()
	 }
	 else
	 {
	  Trollback
	  s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("教育水平","web.DHCBL.CT.CTEducation","DeleteData",eobj)
	  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	 }
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：查询教育水平的内容
/// Table：CT_Education
/// Input：rowid,code,desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTEducation","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "EDURowId:%String,EDUCode:%String,EDUDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,EDUClass,EDUStatus,EDUStartDate,EDUEndDate,EDUActivity,EDUSeqNo,EDUPYCode,EDUWBCode,EDUMark ")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
   //获取授权Json
   s AuStr=##class(web.DHCBL.Authorize.CTEducation).DHCGetDataByDefaultSession()
   s AuFlag=0
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
   if (rowid'="") //根据rowid返回该条记录
   {
     s EDURowId=rowid
     s EDUCode=$p($g(^CT("EDU",EDURowId)),"^",1)
     s EDUDesc=$p($g(^CT("EDU",EDURowId)),"^",2)
     s EDUClass=$p($g(^CT("EDU",EDURowId)),"^",3)    //学历层级
     s EDUStatus=$p($g(^CT("EDU",EDURowId)),"^",4)    //状态
     s EDUStartDate=$p($g(^CT("EDU",EDURowId)),"^",6)     //开始日期
     s EDUEndDate=$p($g(^CT("EDU",EDURowId)),"^",7)    //结束日期
     s:EDUStartDate'="" EDUStartDate=$zd(EDUStartDate,1)  
     s:EDUEndDate'="" EDUEndDate=$zd(EDUEndDate,1)  
     s EDUActivity=$p($g(^CT("EDU",EDURowId)),"^",5) 	//是否有效(Y/N)
     s:EDUActivity="" EDUActivity="Y"
     s EDUSeqNo=$p($g(^CT("EDU",EDURowId)),"^",11) 		//系统排序号
	 s EDUPYCode=$p($g(^CT("EDU",EDURowId)),"^",15) 		//拼音码
	 s EDUWBCode=$p($g(^CT("EDU",EDURowId)),"^",16) 		//五笔码
	 s EDUMark=$p($g(^CT("EDU",EDURowId)),"^",17)		//备注
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Education",EDURowId)
     s BDPInternalCode =$p($g(resultStr),"^",1)       
     s BDPInternalDesc = $p($g(resultStr),"^",2)  
     s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
     d OutputRow
   }
   else
   {
     ;k ^tmp("BDPSortByParams","sort")
     s:code'="" code=$ZCONVERT(code,"U") //转换成大写
     s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
     s EDURowId=0
     for
     {
        s EDURowId=$o(^CT("EDU",EDURowId))
        q:EDURowId=""
        ;筛选授权后的数据
        s strRowId="{ID:"_EDURowId_"}"
        if (AuStr[strRowId)||(AuFlag=1) 
        { 
            s EDUCode=$p($g(^CT("EDU",EDURowId)),"^",1)
            s EDUDesc=$p($g(^CT("EDU",EDURowId)),"^",2)
            s EDUClass=$p($g(^CT("EDU",EDURowId)),"^",3)    //学历层级
		    s EDUStatus=$p($g(^CT("EDU",EDURowId)),"^",4)    //状态
		    s EDUStartDate=$p($g(^CT("EDU",EDURowId)),"^",6)     //开始日期
		    s EDUEndDate=$p($g(^CT("EDU",EDURowId)),"^",7)    //结束日期
		    s:EDUStartDate'="" EDUStartDate=$zd(EDUStartDate,1)  
		    s:EDUEndDate'="" EDUEndDate=$zd(EDUEndDate,1)  
		    s EDUActivity=$p($g(^CT("EDU",EDURowId)),"^",5) 	//是否有效(Y/N)
		    s:EDUActivity="" EDUActivity="Y"
		    s EDUSeqNo=$p($g(^CT("EDU",EDURowId)),"^",11) 		//系统排序号
			s EDUPYCode=$p($g(^CT("EDU",EDURowId)),"^",15) 		//拼音码
			s EDUWBCode=$p($g(^CT("EDU",EDURowId)),"^",16) 		//五笔码
			s EDUMark=$p($g(^CT("EDU",EDURowId)),"^",17)		//备注
           
           if (desc'="")
           {
              ;需要对描述或者别名进行检索      
              s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Education",EDURowId,EDUDesc,desc)
           }
           else
           {
              s AliasFlag= 1   
           }
          s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
          s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Education",EDURowId)
          s BDPInternalCode =$p($g(resultStr),"^",1)       
          s BDPInternalDesc = $p($g(resultStr),"^",2)  
          s BDPHospNationalCode=$p($g(resultStr),"^",3)         
          s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
          if ($ZCONVERT(EDUCode,"U")[code)&(AliasFlag=1)
          {
            d OutputRow
          }
       }
     }
  }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(EDURowId,EDUCode,EDUDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,EDUClass,EDUStatus,EDUStartDate,EDUEndDate,EDUActivity,EDUSeqNo,EDUPYCode,EDUWBCode,EDUMark )
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
/// Description：查询教育水平的内容,用于combox查询
/// Table：User.CTEducation
/// Input：rowid,code,desc
/// Return：EDURowId,EDUCode,EDUDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTEducation","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "EDURowId:%String,EDUCode:%String,EDUDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.CTEducation).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s EDURowId=rowid
  s EDUCode=$p($g(^CT("EDU",EDURowId)),"^",1)
  s EDUDesc=$p($g(^CT("EDU",EDURowId)),"^",2)
  d OutputRowCmb
 }
 else
 {
  s:code'="" code=$ZCONVERT(code,"U") //转换成大写
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s EDURowId=0
  f {
   s EDURowId=$o(^CT("EDU",EDURowId))
   q:EDURowId=""
   
   s EDUActivity=$p($g(^CT("EDU",EDURowId)),"^",5) 	//是否有效(Y/N)
   s EDUStartDate=$p($g(^CT("EDU",EDURowId)),"^",6)     //开始日期
   s EDUEndDate=$p($g(^CT("EDU",EDURowId)),"^",7)    //结束日期
   continue:EDUActivity="N"
   continue:(EDUStartDate'="")&&(EDUStartDate>+$h)
   continue:(EDUEndDate'="")&&(EDUEndDate<+$h)
	
   //筛选授权后的数据
   s strRowId="{ID:"_EDURowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) {
    s EDUCode=$p($g(^CT("EDU",EDURowId)),"^",1)
    s EDUDesc=$p($g(^CT("EDU",EDURowId)),"^",2)
		    
    if (desc'="")
    {
      ;需要对描述或者别名进行检索      
      s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Education",EDURowId,EDUDesc,desc)
    }
    else
    {
      s AliasFlag= 1   
    }
    if ($ZCONVERT(EDUCode,"U")[code)&(AliasFlag=1) 
    {
      d OutputRowCmb
    }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(EDURowId,EDUCode,EDUDesc)
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
