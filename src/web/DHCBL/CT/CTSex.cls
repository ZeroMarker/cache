Import SQLUser

/// 名称: 性别维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-29
Class web.DHCBL.CT.CTSex Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.CTSex
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.CTSex).%New()
 s pobj = ##class(User.CTSex).%OpenId(id)
 s eobj.CTSEXRowId = id
 s eobj.CTSEXCode=pobj.CTSEXCode
 s eobj.CTSEXDesc=pobj.CTSEXDesc
 s eobj.CTSEXDateFrom=pobj.CTSEXDateFrom
 s eobj.CTSEXDateTo=pobj.CTSEXDateTo
 s:eobj.CTSEXDateFrom'="" eobj.CTSEXDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTSEXDateFrom) //转换日期格式
 s:eobj.CTSEXDateTo'="" eobj.CTSEXDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTSEXDateTo) //转换日期格式
 s eobj.CTSEXActivity=pobj.CTSEXActivity
 s:eobj.CTSEXActivity="Y" eobj.CTSEXActivity="true"
 s eobj.CTSEXSeqNo=pobj.CTSEXSeqNo
 s eobj.CTSEXPYCode=pobj.CTSEXPYCode
 s eobj.CTSEXWBCode=pobj.CTSEXWBCode
 s eobj.CTSEXMark=pobj.CTSEXMark
 
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.CTSex
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("SEX",0,"Code",code))
 s:desc'="" flagd=$d(^CT("SEX",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("SEX",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("SEX",0,"Desc",desc,0))
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
/// Table：User.CTSex
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^CT("SEX",0,"Code",code))
 s:desc'="" flagd=$d(^CT("SEX",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^CT("SEX",0,"Code",code,0))
  s:desc'="" idd=$o(^CT("SEX",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-29
/// Description：保存修改性别的内容
/// Table：User.CTSex
/// Input：web.Entity.CT.CTSex 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.CTSex).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.CTSex) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.CTSEXDateFrom'="" eobj.CTSEXDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTSEXDateFrom) //转换日期
  s:eobj.CTSEXDateTo'="" eobj.CTSEXDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTSEXDateTo)      //转换日期
  s:eobj.CTSEXDateFrom="" eobj.CTSEXDateFrom=+$h
  
  s USERID=""
  s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
  
  s:eobj.CTSEXLastUpdateDate="" eobj.CTSEXLastUpdateDate=+$h		//系统最后更新日期
  s:eobj.CTSEXLastUpdateTime="" eobj.CTSEXLastUpdateTime=$p($h,",",2)		//系统最后更新时间
  s:eobj.CTSEXLastUpdateUser="" eobj.CTSEXLastUpdateUser=USERID	//系统最新更新人
  s:eobj.CTSEXActivity="" eobj.CTSEXActivity="N"		//是否有效
    
  s:eobj.CTSEXPYCode="" eobj.CTSEXPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.CTSEXPYCode,4)
  s:eobj.CTSEXWBCode="" eobj.CTSEXWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.CTSEXWBCode,1)
  
  s flag=..Validate(eobj.CTSEXRowId,eobj.CTSEXCode,eobj.CTSEXDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.CTSEXRowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.CTSex).%New()
    s:eobj.CTSEXCreateDate="" eobj.CTSEXCreateDate=+$h	//系统创建日期默认当前日期
	s:eobj.CTSEXCreateTime="" eobj.CTSEXCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
	s:eobj.CTSEXCreateUser="" eobj.CTSEXCreateUser= USERID		//系统创建人默认当前登录人员
	s obj.CTSEXCreateDate=eobj.CTSEXCreateDate		//系统创建日期
	s obj.CTSEXCreateTime=eobj.CTSEXCreateTime		//系统创建时间
	d obj.CTSEXCreateUserSetObjectId(eobj.CTSEXCreateUser)	//系统创建人
   }
   else                     //如果RowId已赋值则修改
   {
    s obj=##class(User.CTSex).%OpenId(eobj.CTSEXRowId)
    s bobj=##class(web.Entity.CT.CTSex).%New()
    s bobj.CTSEXRowId=eobj.CTSEXRowId
    s bobj.CTSEXCode = obj.CTSEXCode          //修改代码
    s bobj.CTSEXDesc = obj.CTSEXDesc          //修改描述
    s bobj.CTSEXDateFrom = obj.CTSEXDateFrom  //修改开始日期
    s bobj.CTSEXDateTo = obj.CTSEXDateTo      //修改结束日期 
    s bobj.CTSEXActivity=obj.CTSEXActivity	//是否有效(Y/N)
    s bobj.CTSEXCreateDate=obj.CTSEXCreateDate		//系统创建日期
	s bobj.CTSEXCreateTime=obj.CTSEXCreateTime		//系统创建时间
	s:$IsObject(obj.CTSEXCreateUser) bobj.CTSEXCreateUser = obj.CTSEXCreateUser.%Id() 	//系统创建人
	s bobj.CTSEXSeqNo=obj.CTSEXSeqNo		//系统排序号
	s bobj.CTSEXLastUpdateDate=obj.CTSEXLastUpdateDate		//系统最后更新日期
	s bobj.CTSEXLastUpdateTime=obj.CTSEXLastUpdateTime		//系统最后更新时间
	s:$IsObject(obj.CTSEXLastUpdateUser) bobj.CTSEXLastUpdateUser = obj.CTSEXLastUpdateUser.%Id() 	//系统最新更新人
	s bobj.CTSEXPYCode=obj.CTSEXPYCode		//拼音码
	s bobj.CTSEXWBCode=obj.CTSEXWBCode		//五笔码
	s bobj.CTSEXMark=obj.CTSEXMark		//备注
   }
   Ts          
   s obj.CTSEXCode = eobj.CTSEXCode          //修改代码
   s obj.CTSEXDesc = eobj.CTSEXDesc          //修改描述
   s obj.CTSEXDateFrom = eobj.CTSEXDateFrom  //修改开始日期
   s obj.CTSEXDateTo = eobj.CTSEXDateTo      //修改结束日期
   s obj.CTSEXActivity=eobj.CTSEXActivity	//是否有效(Y/N)
   s obj.CTSEXSeqNo=eobj.CTSEXSeqNo		//系统排序号
   s obj.CTSEXLastUpdateDate=eobj.CTSEXLastUpdateDate		//系统最后更新日期
   s obj.CTSEXLastUpdateTime=eobj.CTSEXLastUpdateTime		//系统最后更新时间
   d obj.CTSEXLastUpdateUserSetObjectId(eobj.CTSEXLastUpdateUser)	//系统最新更新人
   s obj.CTSEXPYCode=eobj.CTSEXPYCode		//拼音码
   s obj.CTSEXWBCode=eobj.CTSEXWBCode		//五笔码
   s obj.CTSEXMark=eobj.CTSEXMark		//备注   
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.CTSEXRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Sex","User.CTSex","性别",id,eobj.CTSEXDesc,"A",eobj)
    d:eobj.CTSEXRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Sex","User.CTSex","性别",eobj.CTSEXRowId,eobj.CTSEXDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("性别","web.DHCBL.CT.CTSex","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }
 }
 else
 {
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("性别","web.DHCBL.CT.CTSex","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
  s result= "{success:'false',errorinfo:'对象不存在！'}"
 }
 q result
ERROE
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("性别","web.DHCBL.CT.CTSex","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// 删除时验证数据是否被引用
ClassMethod GetRefFlag(id As %String) As %String
{
 s return="",myInfo=""
 
 //1 是否被"手术/过程"引用
 s found1=0
  s sub1=0 f  s sub1=$o(^ORC("OPER",sub1)) q:sub1=""  q:found1  d
  .i ($p($g(^ORC("OPER",sub1)),"^",12)=id) s found1=1
  i (found1) s myInfo=myInfo_"<手术/过程>"
  
 //2 是否被"ICD诊断代码"引用
 s found2=0
  s sub1=0 f  s sub1=$o(^MRC("ID",sub1)) q:sub1=""  q:found2  d
  .i ($p($g(^MRC("ID",sub1)),"^",10)=id) s found2=1
  i (found2) s myInfo=myInfo_"<ICD诊断代码>"
  
  //3 是否被"HOS人员基本信息"引用
  if $d(^CT.BDP.CT.HOSPersonI("IndexGenderCode",id))
	{
	    s myInfo=myInfo_"<HOS人员基本信息>"
	}
  
  i myInfo="" s return="0^未被引用可删除!"
  else  s return="1^在"_myInfo_"表里被引用,不能删除!"
  q return
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-29
/// Description：根据ID删除性别的内容
/// Table：User.CTSex
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id) As %String
{
 s result=""
 //验证是否被引用
  s re=..GetRefFlag(id)
 if ($p(re,"^",1)) {
  s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
 }
 else
 {
  s eobj = ##class(web.Entity.CT.CTSex).%New()
  s pobj = ##class(User.CTSex).%OpenId(id)
  s eobj.CTSEXRowId = id
  s eobj.CTSEXCode=pobj.CTSEXCode
  s eobj.CTSEXDesc=pobj.CTSEXDesc
  s eobj.CTSEXDateFrom=pobj.CTSEXDateFrom
  s eobj.CTSEXDateTo=pobj.CTSEXDateTo
  s eobj.CTSEXActivity=pobj.CTSEXActivity	//是否有效(Y/N)
  s eobj.CTSEXCreateDate=pobj.CTSEXCreateDate		//系统创建日期
  s eobj.CTSEXCreateTime=pobj.CTSEXCreateTime		//系统创建时间
  s:$IsObject(pobj.CTSEXCreateUser) eobj.CTSEXCreateUser = pobj.CTSEXCreateUser.%Id() 	//系统创建人
  s eobj.CTSEXSeqNo=pobj.CTSEXSeqNo		//系统排序号
  s eobj.CTSEXLastUpdateDate=pobj.CTSEXLastUpdateDate		//系统最后更新日期
  s eobj.CTSEXLastUpdateTime=pobj.CTSEXLastUpdateTime		//系统最后更新时间
  s:$IsObject(pobj.CTSEXLastUpdateUser) eobj.CTSEXLastUpdateUser = pobj.CTSEXLastUpdateUser.%Id() 	//系统最新更新人
  s eobj.CTSEXPYCode=pobj.CTSEXPYCode		//拼音码
  s eobj.CTSEXWBCode=pobj.CTSEXWBCode		//五笔码
  s eobj.CTSEXMark=pobj.CTSEXMark		//备注
  
  s sc=##class(User.CTSex).%DeleteId(id)
  if $$$ISOK(sc)
  {
   s result= "{success:'true',info:'删除成功！'}" 
   //保存日志
   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Sex","User.CTSex","性别",id,eobj.CTSEXDesc,"D",eobj)
   d eobj.%Close()
  }
  else 
  {
   s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
   s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("性别","web.DHCBL.CT.CTSex","DeleteData",eobj)
   s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
  }
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-29
/// Description：查询性别的内容
/// Table： CT_Sex
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTSex","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTSEXRowId:%String,CTSEXCode:%String,CTSEXDesc:%String,CTSEXDateFrom:%String,CTSEXDateTo:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,CTSEXActivity,CTSEXSeqNo,CTSEXPYCode,CTSEXWBCode,CTSEXMark ")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
   
   s AuStr=##class(web.DHCBL.Authorize.CTSex).DHCGetDataByDefaultSession()
   s AuFlag=0
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
   if (rowid'="") //根据rowid返回该条记录
   {
     s CTSEXRowId=rowid
     s CTSEXCode=$p($g(^CT("SEX",CTSEXRowId)),"^",1)
     s CTSEXDesc=$p($g(^CT("SEX",CTSEXRowId)),"^",2)
     s CTSEXDateFrom=$p($g(^CT("SEX",CTSEXRowId)),"^",4)
     s CTSEXDateTo=$p($g(^CT("SEX",CTSEXRowId)),"^",5)
     s:CTSEXDateFrom'="" CTSEXDateFrom=$zd(CTSEXDateFrom,1)  
     s:CTSEXDateTo'="" CTSEXDateTo=$zd(CTSEXDateTo,1)  
     s CTSEXActivity=$p($g(^CT("SEX",CTSEXRowId)),"^",8) 	//是否有效(Y/N)
     s:CTSEXActivity="" CTSEXActivity="Y"
     s CTSEXSeqNo=$p($g(^CT("SEX",CTSEXRowId)),"^",12) 		//系统排序号
	 s CTSEXPYCode=$p($g(^CT("SEX",CTSEXRowId)),"^",16) 		//拼音码
	 s CTSEXWBCode=$p($g(^CT("SEX",CTSEXRowId)),"^",17) 		//五笔码
	 s CTSEXMark=$p($g(^CT("SEX",CTSEXRowId)),"^",18)		//备注
     
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Sex",CTSEXRowId)
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
      s CTSEXRowId=0
      for 
      {
        s CTSEXRowId=$o(^CT("SEX",CTSEXRowId))
        q:CTSEXRowId=""
        ;筛选授权后的数据
        s strRowId="{ID:"_CTSEXRowId_"}"
        if (AuStr[strRowId)||(AuFlag=1) 
        {
          s CTSEXCode=$p($g(^CT("SEX",CTSEXRowId)),"^",1)
          s CTSEXDesc=$p($g(^CT("SEX",CTSEXRowId)),"^",2) 
          s CTSEXDateFrom=$p($g(^CT("SEX",CTSEXRowId)),"^",4)
          s CTSEXDateTo=$p($g(^CT("SEX",CTSEXRowId)),"^",5)
          s:CTSEXDateFrom'="" CTSEXDateFrom=$zd(CTSEXDateFrom,1) 
          s:CTSEXDateTo'="" CTSEXDateTo=$zd(CTSEXDateTo,1)  
          s CTSEXActivity=$p($g(^CT("SEX",CTSEXRowId)),"^",8) 	//是否有效(Y/N)
          s:CTSEXActivity="" CTSEXActivity="Y"
      	  s CTSEXSeqNo=$p($g(^CT("SEX",CTSEXRowId)),"^",12) 		//系统排序号
	 	  s CTSEXPYCode=$p($g(^CT("SEX",CTSEXRowId)),"^",16) 		//拼音码
	 	  s CTSEXWBCode=$p($g(^CT("SEX",CTSEXRowId)),"^",17) 		//五笔码
	 	  s CTSEXMark=$p($g(^CT("SEX",CTSEXRowId)),"^",18)		//备注

          
          s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""
          s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Sex",CTSEXRowId)
          s BDPInternalCode =$p($g(resultStr),"^",1)       
          s BDPInternalDesc = $p($g(resultStr),"^",2)  
          s BDPHospNationalCode=$p($g(resultStr),"^",3)         
          s BDPHospNationalDesc = $p($g(resultStr),"^",4)
          if (desc'="")
          {
              ;需要对描述或者别名进行检索      
              s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Sex",CTSEXRowId,CTSEXDesc,desc)
          }
          else
          {
              s AliasFlag= 1   
          }   
          if ($ZCVT(CTSEXCode,"U")[code)&(AliasFlag=1) 
          {
            d OutputRow
          }
       } 
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(CTSEXRowId,CTSEXCode,CTSEXDesc,CTSEXDateFrom,CTSEXDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,CTSEXActivity,CTSEXSeqNo,CTSEXPYCode,CTSEXWBCode,CTSEXMark )
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
/// Description：查询性别的内容,用于combox查询
/// Table：User.CTSex
/// Input：rowid,code,desc
/// Return：CTSEXRowId,CTSEXCode,CTSEXDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTSex","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTSEXRowId:%String,CTSEXCode:%String,CTSEXDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.CTSex).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s CTSEXRowId=rowid
  s CTSEXCode=$p($g(^CT("SEX",CTSEXRowId)),"^",1)
  s CTSEXDesc=$p($g(^CT("SEX",CTSEXRowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
  s CTSEXRowId=0
  for 
  {
   s CTSEXRowId=$o(^CT("SEX",CTSEXRowId))
   q:CTSEXRowId="" 
   s CTSEXDateFrom=$p($g(^CT("SEX",CTSEXRowId)),"^",4)
   continue:(CTSEXDateFrom'="")&&(CTSEXDateFrom>+$h)
   s CTSEXDateTo=$p($g(^CT("SEX",CTSEXRowId)),"^",5)
   continue:(CTSEXDateTo'="")&&(CTSEXDateTo<+$h)
   s CTSEXActivity=$p($g(^CT("SEX",CTSEXRowId)),"^",8) 	//是否有效(Y/N)
   continue:CTSEXActivity="N"
   //筛选授权后的数据
   s strRowId="{ID:"_CTSEXRowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) 
   {
    s CTSEXCode=$p($g(^CT("SEX",CTSEXRowId)),"^",1)
    s CTSEXDesc=$p($g(^CT("SEX",CTSEXRowId)),"^",2)
    if (desc'="")
    {
      ;需要对描述或者别名进行检索      
      s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Sex",CTSEXRowId,CTSEXDesc,desc)
    }
    else
    {
      s AliasFlag= 1   
    }   
    if ($ZCVT(CTSEXCode,"U")[code)&(AliasFlag=1) 
    {
      d OutputRow2
    }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(CTSEXRowId,CTSEXCode,CTSEXDesc)
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
