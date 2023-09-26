Import SQLUser

/// 名称: 婚姻状况维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.CTMarital Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.CTMarital
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.CTMarital).%New()
 s pobj = ##class(User.CTMarital).%OpenId(id)
 s eobj.CTMARRowId = id
 s eobj.CTMARCode=pobj.CTMARCode
 s eobj.CTMARDesc=pobj.CTMARDesc
 s eobj.CTMARDateFrom=pobj.CTMARDateFrom
 s eobj.CTMARDateTo=pobj.CTMARDateTo
 s:eobj.CTMARDateFrom'="" eobj.CTMARDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTMARDateFrom) //转换日期格式
 s:eobj.CTMARDateTo'="" eobj.CTMARDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTMARDateTo) //转换日期格式
 s eobj.CTMARActivity=pobj.CTMARActivity
 s:eobj.CTMARActivity="Y" eobj.CTMARActivity="true"
 s eobj.CTMARSeqNo=pobj.CTMARSeqNo
 s eobj.CTMARPYCode=pobj.CTMARPYCode
 s eobj.CTMARWBCode=pobj.CTMARWBCode
 s eobj.CTMARMark=pobj.CTMARMark
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.CTMarital
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("MAR",0,"Code",code))
 s:desc'="" flagd=$d(^CT("MAR",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("MAR",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("MAR",0,"Desc",desc,0))
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
/// Table：User.CTMarital
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("MAR",0,"Code",code))
 s:desc'="" flagd=$d(^CT("MAR",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("MAR",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("MAR",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：保存修改婚姻状况的内容
/// Table：User.CTMarital
/// Input：web.Entity.CT.CTMarital 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.CTMarital).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.CTMarital) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.CTMARDateFrom'="" eobj.CTMARDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTMARDateFrom) //转换日期
  s:eobj.CTMARDateTo'="" eobj.CTMARDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTMARDateTo)      //转换日期
  s:eobj.CTMARDateFrom="" eobj.CTMARDateFrom=+$H
  
  s USERID=""
  s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
  
  s:eobj.CTMARLastUpdateDate="" eobj.CTMARLastUpdateDate=+$h		//系统最后更新日期
  s:eobj.CTMARLastUpdateTime="" eobj.CTMARLastUpdateTime=$p($h,",",2)		//系统最后更新时间
  s:eobj.CTMARLastUpdateUser="" eobj.CTMARLastUpdateUser=USERID	//系统最新更新人
  s:eobj.CTMARActivity="" eobj.CTMARActivity="N"		//是否有效
    
  s:eobj.CTMARPYCode="" eobj.CTMARPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.CTMARPYCode,4)
  s:eobj.CTMARWBCode="" eobj.CTMARWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.CTMARWBCode,1)
  s flag=..Validate(eobj.CTMARRowId,eobj.CTMARCode,eobj.CTMARDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.CTMARRowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.CTMarital).%New()
    
    s:eobj.CTMARCreateDate="" eobj.CTMARCreateDate=+$h	//系统创建日期默认当前日期
	s:eobj.CTMARCreateTime="" eobj.CTMARCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
	s:eobj.CTMARCreateUser="" eobj.CTMARCreateUser= USERID		//系统创建人默认当前登录人员
	s obj.CTMARCreateDate=eobj.CTMARCreateDate		//系统创建日期
	s obj.CTMARCreateTime=eobj.CTMARCreateTime		//系统创建时间
	d obj.CTMARCreateUserSetObjectId(eobj.CTMARCreateUser)	//系统创建人
   }
   else                     //如果RowId已赋值则修改
   {
    s obj=##class(User.CTMarital).%OpenId(eobj.CTMARRowId)
    s bobj=##class(web.Entity.CT.CTMarital).%New()
    s bobj.CTMARRowId=eobj.CTMARRowId
    s bobj.CTMARCode = obj.CTMARCode          //修改代码
    s bobj.CTMARDesc = obj.CTMARDesc          //修改描述
    s bobj.CTMARDateFrom = obj.CTMARDateFrom  //修改开始日期
    s bobj.CTMARDateTo = obj.CTMARDateTo      //修改结束日期
    s bobj.CTMARActivity=obj.CTMARActivity	//是否有效(Y/N)
    s bobj.CTMARCreateDate=obj.CTMARCreateDate		//系统创建日期
	s bobj.CTMARCreateTime=obj.CTMARCreateTime		//系统创建时间
	s:$IsObject(obj.CTMARCreateUser) bobj.CTMARCreateUser = obj.CTMARCreateUser.%Id() 	//系统创建人
	s bobj.CTMARSeqNo=obj.CTMARSeqNo		//系统排序号
	s bobj.CTMARLastUpdateDate=obj.CTMARLastUpdateDate		//系统最后更新日期
	s bobj.CTMARLastUpdateTime=obj.CTMARLastUpdateTime		//系统最后更新时间
	s:$IsObject(obj.CTMARLastUpdateUser) bobj.CTMARLastUpdateUser = obj.CTMARLastUpdateUser.%Id() 	//系统最新更新人
	s bobj.CTMARPYCode=obj.CTMARPYCode		//拼音码
	s bobj.CTMARWBCode=obj.CTMARWBCode		//五笔码
	s bobj.CTMARMark=obj.CTMARMark		//备注
   }
   Ts          
   s obj.CTMARCode = eobj.CTMARCode          //修改代码
   s obj.CTMARDesc = eobj.CTMARDesc          //修改描述
   s obj.CTMARDateFrom = eobj.CTMARDateFrom  //修改开始日期
   s obj.CTMARDateTo = eobj.CTMARDateTo      //修改结束日期
   s obj.CTMARActivity=eobj.CTMARActivity	//是否有效(Y/N)
   s obj.CTMARSeqNo=eobj.CTMARSeqNo		//系统排序号
   s obj.CTMARLastUpdateDate=eobj.CTMARLastUpdateDate		//系统最后更新日期
   s obj.CTMARLastUpdateTime=eobj.CTMARLastUpdateTime		//系统最后更新时间
   d obj.CTMARLastUpdateUserSetObjectId(eobj.CTMARLastUpdateUser)	//系统最新更新人
   s obj.CTMARPYCode=eobj.CTMARPYCode		//拼音码
   s obj.CTMARWBCode=eobj.CTMARWBCode		//五笔码
   s obj.CTMARMark=eobj.CTMARMark		//备注   
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.CTMARRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Marital","User.CTMarital","婚姻状况",id,eobj.CTMARDesc,"A",eobj)
    d:eobj.CTMARRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Marital","User.CTMarital","婚姻状况",eobj.CTMARRowId,eobj.CTMARDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("婚姻状况","web.DHCBL.CT.CTMarital","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }   
 }
 else
 {
  s result= "{success:'false',errorinfo:'对象不存在！'}"
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("婚姻状况","web.DHCBL.CT.CTMarital","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
 }
 q result
ERROE
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("婚姻状况","web.DHCBL.CT.CTMarital","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// 删除时验证数据是否被引用
ClassMethod GetRefFlag(id As %String) As %String
{
 s return="",myInfo=""
 
  // 是否被"HOS人员基本信息"引用
  if $d(^CT.BDP.CT.HOSPersonI("IndexMarriedCode",id))
	{
	    s myInfo=myInfo_"<HOS人员基本信息>"
	}
  
  i myInfo="" s return="0^未被引用可删除!"
  else  s return="1^在"_myInfo_"表里被引用,不能删除!"
  q return
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：根据ID删除婚姻状况的内容
/// Table：User.CTMarital
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
	 s eobj = ##class(web.Entity.CT.CTMarital).%New()
	 s pobj = ##class(User.CTMarital).%OpenId(id)
	 s eobj.CTMARRowId = id
	 s eobj.CTMARCode=pobj.CTMARCode
	 s eobj.CTMARDesc=pobj.CTMARDesc
	 s eobj.CTMARDateFrom=pobj.CTMARDateFrom
	 s eobj.CTMARDateTo=pobj.CTMARDateTo
	 s eobj.CTMARActivity=pobj.CTMARActivity	//是否有效(Y/N)
	 s eobj.CTMARCreateDate=pobj.CTMARCreateDate		//系统创建日期
	 s eobj.CTMARCreateTime=pobj.CTMARCreateTime		//系统创建时间
	 s:$IsObject(pobj.CTMARCreateUser) eobj.CTMARCreateUser = pobj.CTMARCreateUser.%Id() 	//系统创建人
	 s eobj.CTMARSeqNo=pobj.CTMARSeqNo		//系统排序号
	 s eobj.CTMARLastUpdateDate=pobj.CTMARLastUpdateDate		//系统最后更新日期
	 s eobj.CTMARLastUpdateTime=pobj.CTMARLastUpdateTime		//系统最后更新时间
	 s:$IsObject(pobj.CTMARLastUpdateUser) eobj.CTMARLastUpdateUser = pobj.CTMARLastUpdateUser.%Id() 	//系统最新更新人
	 s eobj.CTMARPYCode=pobj.CTMARPYCode		//拼音码
	 s eobj.CTMARWBCode=pobj.CTMARWBCode		//五笔码
	 s eobj.CTMARMark=pobj.CTMARMark		//备注
	  
	 
	 s sc=##class(User.CTMarital).%DeleteId(id)
	 if $$$ISOK(sc)
	 {
	  s result= "{success:'true',info:'删除成功！'}"
	  //保存日志
	  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Marital","User.CTMarital","婚姻状况",id,eobj.CTMARDesc,"D",eobj)
	  d eobj.%Close()
	 }
	 else 
	 {
	    s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
	    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("婚姻状况","web.DHCBL.CT.CTMarital","DeleteData",eobj)
	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	 }
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-30
/// Description：查询婚姻状况的内容
/// Table： CT_Marital
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTMarital","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTMARRowId:%String,CTMARCode:%String,CTMARDesc:%String,CTMARDateFrom:%String,CTMARDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,CTMARActivity,CTMARSeqNo,CTMARPYCode,CTMARWBCode,CTMARMark ")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
 
  //获取授权Json
   s AuStr=##class(web.DHCBL.Authorize.CTMarital).DHCGetDataByDefaultSession()
   s AuFlag=0
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
   if (rowid'="") //根据rowid返回该条记录
   {
      s CTMARRowId=rowid
      s CTMARCode=$p($g(^CT("MAR",CTMARRowId)),"^",1)
      s CTMARDesc=$p($g(^CT("MAR",CTMARRowId)),"^",2)
      s CTMARDateFrom=$p($g(^CT("MAR",CTMARRowId)),"^",4)
      s CTMARDateTo=$p($g(^CT("MAR",CTMARRowId)),"^",5)
      s:CTMARDateFrom'="" CTMARDateFrom=$zd(CTMARDateFrom,1) 
      s:CTMARDateTo'="" CTMARDateTo=$zd(CTMARDateTo,1) 
      s CTMARActivity=$p($g(^CT("MAR",CTMARRowId)),"^",6) 	//是否有效(Y/N)
      s:CTMARActivity="" CTMARActivity="Y"
      s CTMARSeqNo=$p($g(^CT("MAR",CTMARRowId)),"^",10) 		//系统排序号
	  s CTMARPYCode=$p($g(^CT("MAR",CTMARRowId)),"^",14) 		//拼音码
	  s CTMARWBCode=$p($g(^CT("MAR",CTMARRowId)),"^",15) 		//五笔码
	  s CTMARMark=$p($g(^CT("MAR",CTMARRowId)),"^",16)		//备注
      s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Marital",CTMARRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4)
      d OutputRow
   }
    else
    {
       s:code'="" code=$$ALPHAUP^SSUTIL4(code)  
       s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc)  
       s CTMARRowId=0
       for
       {
          s CTMARRowId=$o(^CT("MAR",CTMARRowId))
          q:CTMARRowId=""
          ;筛选授权后的数据
          s strRowId="{ID:"_CTMARRowId_"}"
          if (AuStr[strRowId)||(AuFlag=1) 
          {
             s CTMARCode=$p($g(^CT("MAR",CTMARRowId)),"^",1)
             s CTMARDesc=$p($g(^CT("MAR",CTMARRowId)),"^",2)  
             s CTMARDateFrom=$p($g(^CT("MAR",CTMARRowId)),"^",4)
             s CTMARDateTo=$p($g(^CT("MAR",CTMARRowId)),"^",5)
             s:CTMARDateFrom'="" CTMARDateFrom=$zd(CTMARDateFrom,1) 
             s:CTMARDateTo'="" CTMARDateTo=$zd(CTMARDateTo,1) 
             s CTMARActivity=$p($g(^CT("MAR",CTMARRowId)),"^",6) 	//是否有效(Y/N)
             s:CTMARActivity="" CTMARActivity="Y"
		     s CTMARSeqNo=$p($g(^CT("MAR",CTMARRowId)),"^",10) 		//系统排序号
			 s CTMARPYCode=$p($g(^CT("MAR",CTMARRowId)),"^",14) 		//拼音码
			 s CTMARWBCode=$p($g(^CT("MAR",CTMARRowId)),"^",15) 		//五笔码
			 s CTMARMark=$p($g(^CT("MAR",CTMARRowId)),"^",16)		//备注 
             s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
             s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Marital",CTMARRowId)
             s BDPInternalCode =$p($g(resultStr),"^",1)       
             s BDPInternalDesc = $p($g(resultStr),"^",2)  
             s BDPHospNationalCode=$p($g(resultStr),"^",3)         
             s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
             if (desc'="")
             {
                ;需要对描述或者别名进行检索      
                s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Marital",CTMARRowId,CTMARDesc,desc)
             }
             else
             {
                s AliasFlag= 1   
             }   
             if ($ZCVT(CTMARCode,"U")[code)&(AliasFlag=1) 
             {
               d OutputRow
             }
         }
     }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(CTMARRowId,CTMARCode,CTMARDesc,CTMARDateFrom,CTMARDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,CTMARActivity,CTMARSeqNo,CTMARPYCode,CTMARWBCode,CTMARMark )
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
/// Description：查询婚姻状况的内容,用于combox查询
/// Table：User.CTMarital
/// Input：rowid,code,desc
/// Return：CTMARRowId,CTMARCode,CTMARDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTMarital","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTMARRowId:%String,CTMARCode:%String,CTMARDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.CTMarital).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s CTMARRowId=rowid
  s CTMARCode=$p($g(^CT("MAR",CTMARRowId)),"^",1)
  s CTMARDesc=$p($g(^CT("MAR",CTMARRowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
  s CTMARRowId=0
  for
  {
   s CTMARRowId=$o(^CT("MAR",CTMARRowId))
   q:CTMARRowId=""
   s CTMARDateFrom=$p($g(^CT("MAR",CTMARRowId)),"^",4)
   continue:(CTMARDateFrom'="")&&(CTMARDateFrom>+$h)
   s CTMARDateTo=$p($g(^CT("MAR",CTMARRowId)),"^",5) 
   continue:(CTMARDateTo'="")&&(CTMARDateTo<+$h)
   s CTMARActivity=$p($g(^CT("MAR",CTMARRowId)),"^",6) 	//是否有效(Y/N)
   continue:CTMARActivity="N"
   //筛选授权后的数据
   s strRowId="{ID:"_CTMARRowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) 
   {
    s CTMARCode=$p($g(^CT("MAR",CTMARRowId)),"^",1)
    s CTMARDesc=$p($g(^CT("MAR",CTMARRowId)),"^",2)
    if (desc'="")
    {
       ;需要对描述或者别名进行检索      
       s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Marital",CTMARRowId,CTMARDesc,desc)
    }
    else
    {
       s AliasFlag= 1   
    }   
    if ($ZCVT(CTMARCode,"U")[code)&(AliasFlag=1) 
    {
      d OutputRow2
    }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(CTMARRowId,CTMARCode,CTMARDesc)
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
