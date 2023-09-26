Import sqluser

/// Class Name:web.CSSDCommon
/// Description:common method for cssd
/// Creator:zdm
/// CreatDate:2010-06-21
Class DHCHAI.DI.DIO.CSSDCommon Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:zdm
/// CreatDate:2010-06-21
/// Description:检查某标签是否正在使用：CSSD_Trans中不存在或存在但已回收的
/// 均为没有使用
/// Table:CSSD_Trans
/// Input:label
/// Output:
/// Return:true;false
/// Others：
ClassMethod IfLabelUsed(label As %String) As %String
{
	n (label)
	s ret="false"
	
	q:label="" ret
	
	s updateDate=$o(^User.CSSDTransI("CSSDTLabelDate",$c(32)_label,""),-1)
	q:updateDate="" ret
	s transRowid=$o(^User.CSSDTransI("CSSDTLabelDate",$c(32)_label,updateDate,""))
	q:transRowid="" ret
	s objTrans=""
	s objTrans=##class(User.CSSDTrans).%OpenId(transRowid)
	q:objTrans="" ""
	
	s status=objTrans.CSSDTStatus
	s:(status'="C")&(status'="CP") ret="true" 
	q ret
}

/// sjf 2011-08-03
/// 根据userDr 获得 UserName
/// w ##Class(web.CSSDCommon).GetUserName(1)
ClassMethod GetUserName(userDr As %String) As %String
{
	n (userDr)
	q:userDr="" ""
	s userinfo=$g(^SSU("SSUSR",userDr))
	q:userinfo="" "" 
	s userName= $p(userinfo,"^",2)
	q userName
}

/// w ##Class(web.CSSDCommon).GetUserCode(1)
ClassMethod GetUserCode(dr As %String)
{
	n (dr)

	s ret=""
	s user=""
	s user=##Class(User.SSUser).%OpenId(dr)
	s ret= user.SSUSRInitials
	q ret
}

/// sjf 2011-08-03
/// 根据locDr 获得 LocName
/// w ##Class(web.CSSDCommon).GetLocName(1)
ClassMethod GetLocName(locDr As %String) As %String
{
	n (locDr)
	q:locDr="" ""
	s locinfo=$g(^CTLOC(locDr))
	q:locinfo="" ""
	s locName=$p(^CTLOC(locDr),"^",2)
	s locName=..SubName(locName)
	q locName
}

/// sjf 2011-08-03
/// 根据locDr 获得 LocName
/// w ##Class(web.CSSDCommon).GetLocName(1)
ClassMethod GetLocCode(locDr As %String) As %String
{
	n (locDr)
	q:locDr="" ""
	s locinfo=$g(^CTLOC(locDr))
	q:locinfo="" ""
	s locName=$p(^CTLOC(locDr),"^",1)
	q locName
}

/// sjf 2011-08-03
/// 根据ymdr 获得 年月的字符串形式 "201102"
/// w ##Class(web.CSSDCommon).GetStrYearMonth(1)
ClassMethod GetStrYearMonth(ymdr As %String) As %String
{
 n (ymdr)
 s yminfo=$g(^User.CSSDYearMonthD(ymdr))
 q:yminfo="" ""	
 s strYm=$li(yminfo,6)
 q strYm
}

/// Creator:zdm,sjf 修改 2011-3-10,把原来用类的方式改为从global中，直接取状态
/// CreatDate:2010-06-21
/// Description:取某标签的当前状态
/// Table:CSSD_Trans
/// Input:label
/// Output:
/// Return:状态EP(配包)，P（打包）,S（灭菌）,D（发放）,C（回收）
/// Others：
ClassMethod GetLabelStatus(label As %String) As %String
{
	n (label)
	s ret=""
	
	q:label="" ret
	s lastDate=$o(^User.CSSDTransI("CSSDTLabelDate",$c(32)_label,""),-1)
	q:lastDate="" ""
	
	s id=$o(^User.CSSDTransI("CSSDTLabelDate",$c(32)_label,lastDate,""))
	q:id="" "" 
	s status=$lg(^User.CSSDTransD(id),8) 
	
	;s objTrans=##class(User.CSSDTrans).%OpenId(id)
	;q:('$IsObject(objTrans)) ""
	;s status=objTrans.CSSDTStatus
	
	;s label=objTrans.CSSDTLabel
	;d objTrans.%Close()
	
	q status
}

/// P（已配包）,S（已灭菌）,D（已发放）,C（已回收）,W(已清洗)
/// 把状态改为中文
/// w ##Class(web.CSSDCommon).GetStatusChinese("P")
ClassMethod GetStatusChinese(state As %String)
{
	 i state="P" d
	 .s state="已配包" 
	 e  i state="S" d
	 .s state="已灭菌"
	 e  i state="D" d
	 .s state="已发放"
	 e  i state="R" d
	 .s state="已接收"
	 e  i state="C" d
	 .s state="已回收" 
	 e  i state="W" d
	 .s state="已清洗"
	 e  i state="U" d
	 .s state="已使用"
	 /**
	 e  i state="EC" d
	 .s state="已进清洗机"
	 e  i state="ES" d
	 .s state="已经进灭菌器"
	 **/
	 q state
}

/// Creator:zdm,sjf 修改 2011-3-7
/// CreatDate:2010-11-23
/// Description:取某消毒包的效期
/// Table:CSSD_Trans
/// Input:label
/// Output:
/// Return:效期
/// Others：
ClassMethod GetPackageExpdate(label As %String) As %String
{
	n (label)
	s ret=""
	
	q:label="" ret
	s lastDate=$o(^User.CSSDTransI("CSSDTLabelDate",$c(32)_label,""),-1)
	q:lastDate="" ""
	s id=$o(^User.CSSDTransI("CSSDTLabelDate",$c(32)_label,lastDate,""))
	q:id="" "" 
	s objTrans=""
	s objTrans=##class(User.CSSDTrans).%OpenId(id)
	q:('$IsObject(objTrans)) ""
	;s status=objTrans.CSSDTStatus
	;s label=objTrans.CSSDTLabel
	s expdate=objTrans.CSSDTExpDate
	i expdate'="" d
	.s expdate=$zd(expdate,3)
	d objTrans.%Close()
	q expdate
}

/// Creator:zdm
/// CreatDate:2010-06-22
/// Description:对某条码加锁
/// Table
/// Input:label
/// Output:
/// Return:0，成功；-10，已经加锁；-11，失败
/// Others：
ClassMethod AddLock(lockType As %String, lockObject As %String) As %String
{
	n (lockType,lockObject)
	q:lockType="" 0
	q:lockObject="" 0
	s err=0
 	l +^CSSDLOCK(lockType,lockObject):10  e  d
 	.s err="-11"							;加锁失败
 	q err
}

/// Creator:zdm
/// CreatDate:2010-06-22
/// Description:对某对象解锁
/// Table
/// Input:label
/// Output:
/// Return:
/// Others：
ClassMethod RemoveLock(lockType As %String, lockObject As %String) As %String
{
	n (lockType,lockObject)
	q:lockType="" 0
	q:lockObject="" 0	
	;
 	l -^CSSDLOCK(lockType,lockObject)
 	;		
 	q 0
}

/// Creator:zdm
/// CreatDate:2010-06-21
/// Description:根据科室名称取rowid
/// Table:CT_Loc
/// Input:科室名称
/// Output:
/// Return:rowid
/// Others：
ClassMethod LocDescToRowid(locDesc As %String) As %String
{
	n (locDesc)
	q:locDesc="" ""
	s locDesc=$$ALPHAUP^SSUTIL4(locDesc)
	s rowid=$o(^CTLOC(0,"Desc",locDesc,""))
	q rowid
}

/// Creator:zdm
/// CreatDate:2010-06-21
/// Description:根据用户名称取rowid
/// Table:SS_User
/// Input:用户名称
/// Output:
/// Return:rowid
/// Others：
ClassMethod UserNameToRowid(userName As %String) As %String
{
	n (userName)
	q:userName="" ""
	s userName=$$ALPHAUP^SSUTIL4(userName)
	s rowid=$o(^SSU("SSUSR",0,"SSUSR_Name",userName,""))
	q rowid
}

/// Creator:zdm
/// CreatDate:2010-06-21
/// Description:根据库存项rowid取规格
/// Table:SS_User
/// Input:库存项rowid
/// Output:
/// Return:rowid
/// Others：
ClassMethod GetSpec(itmRowid As %String) As %String
{
	n (itmRowid)
	q:itmRowid="" ""
	s info=$o(^DHCITMINFO(0,"INCI",itmRowid,""))
	s spec=""
	s:info'="" spec=$p(^DHCITMINFO(info),"^",27)
	i spec=""  d
	.s spec=$p(^INCI(itmRowid,3),"^",9)
	.
	q spec
}

/// Creator:zdm
/// CreatDate:2010-11-18
/// Description:根据库存项rowid取别名
/// Table:INC_Alias
/// Input:库存项rowid
/// Output:
/// Return:别名1^别名2
/// Others：w C"8191")
ClassMethod GetAlias(itmRowid As %String) As %String
{
	n (itmRowid)
	q:itmRowid="" ""
	s strAlias=""
	s inca=""
	f  s inca=$o(^INCALIAS(0,"INCI",itmRowid,inca))  q:inca=""  d
	.q:('$d(^INCALIAS(inca)))
	.s alias=$p(^INCALIAS(inca),"^",4)
	.i strAlias=""  d
	..s strAlias=alias
	.e  d
	..s strAlias=strAlias_","_alias
	.
	q strAlias
}

/// Creator:zdm
/// CreatDate:2010-09-07
/// Description:取库存项信息
/// Table:INC_Itm
/// Input:库存项rowid
/// Output:
/// Return:库存项信息
/// Others：
ClassMethod GetItmInfo(itmRowid As %String) As %String
{
	n (itmRowid)
	q:itmRowid="" ""	
	;
	s itmDesc=$p($g(^INCI(itmRowid,1)),"^",2)
	s itmCode=$p($g(^INCI(itmRowid,1)),"^",1)
	s spec=##class(web.CSSDCommon).GetSpec(itmRowid)
	s uomDr=$p($g(^INCI(itmRowid,1)),"^",10)
	s purUomDr=$p($g(^INCI(itmRowid,3)),"^",6)
	s:uomDr'="" uomDesc=$p($g(^CT("UOM",uomDr)),"^",2)
	s:purUomDr'="" purUomDesc=$p($g(^CT("UOM",purUomDr)),"^",2)
	;
	s data=itmCode_"^"_itmDesc_"^"_spec_"^"_uomDr_"^"_$g(uomDesc)_"^"_purUomDr_"^"_$g(purUomDesc)
	;
	q data
}

ClassMethod GetItmName(itmRowid As %String) As %String
{
	s itmInfo=""
	s itmInfo=##Class(User.INCItm).%OpenId(itmRowid)
	s itmName=itmInfo.INCIDesc
	s itmName=..SubName(itmName)
	q itmName
}

/// Creator:zdm
/// CreatDate:2010-06-24
/// Description:取某消毒包的发放信息
/// Table:CSSD_PackageDisp
/// Input:
/// Output:
/// Return:SQLCODE
/// Others：
ClassMethod GetDispInfo(dispId As %String) As %String
{
	n (dispId)
	q:dispId="" ""
	s objDisp=""
	s objDisp=##class(User.CSSDPackageDisp).%OpenId(id)
	q:objDisp="" ""
	s data1=objDisp.CSSDPDLabel_"^"_objDisp.CSSDPDPackage.%Id()_"^"_objDisp.CSSDPDFromLocDr.%Id()
	s data2=objDisp.CSSDPDFromUserDr.%Id()_"^"_objDisp.CSSDPDToLocDr.%Id()_"^"_objDisp.CSSDPDToUserDr.%Id()
	d objDisp.%Close()
	q data1_"^"_data2
}

/// Creator:zdm
/// CreatDate:2010-06-24
/// Description:判断某库存项是否要回收
/// Table:inc_itm
/// Input:库存项rowid
/// Output:
/// Return:1，是；0，不是
/// Others：
ClassMethod CheckIfCallback(itmRowid As %String) As %String
{
	n (itmRowid)
	q:itmRowid="" ""
	s ret=1
	s itmDesc=$p(^INCI(itmRowid,1),"^",2)
	i $f(itmDesc,"一次性") d
	.s ret=0
	q ret
}

Query GetGroupLoc(groupId As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,Type:%String,Laundry:%String") [ SqlProc ]
{
}

ClassMethod GetGroupLocExecute(ByRef qHandle As %Binary, groupId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	;
	q:groupId="" $$$OK
	
	s ret=..GetLocByGroup(groupId)
	
	q:ret="" $$$OK
	
	d OutputRow 
	
	Quit $$$OK
OutputRow
	s i=0
	f  s i=$o(^TMPGROUPLOC("CSSD",ret,i))  q:i=""  d
	.s data=^TMPGROUPLOC("CSSD",ret,i)
	.s rowid=$p(data,"^",1)
	.s code=$p(data,"^",2)
	.s desc=$p(data,"^",3)
	.s type=$p(data,"^",4)
	.s laundry=$p(data,"^",5)
	.s data=$lb(rowid,code,desc,type,laundry)
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	.
	k ^TMPGROUPLOC("CSSD",ret)
	q
}

ClassMethod GetGroupLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGroupLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupLocExecute ]
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
	;b
	Quit $$$OK
}

/// Creator:zdm
/// CreatDate:2010-08-09
/// Description:取某安全组能访问的科室
/// Table:inc_itm
/// Input:安全组rowid
/// Output:科室
/// Return:
/// Others：w ##Class(web.CSSDCommon).GetLocByGroup("1")
ClassMethod GetLocByGroup(groupId As %String) As %String
{
	n (groupId)
	s ^tempsjfcssd=groupId
	q:groupId="" ""
	s pid=$I(^TMPGROUPLOC("CSSD"))
	s i=0
	s grpid=""
	;b
	//f  s grpid=$o(^User.CSSDGroupLocI("GroupLocIndex",$c(32)_groupId,grpid)) q:grpid=""  d
	
	f  s grpid=$o(^User.CSSDGroupLocI("GroupLocIndex",groupId,grpid)) q:grpid=""  d
	.s objGroupLoc=""
	.s objGroupLoc=##class(User.CSSDGroupLoc).%OpenId(grpid)
	.q:('$IsObject(objGroupLoc))
	.s locId=""
	.s locId=objGroupLoc.CSSDGLSRLOCDR.%Id()
	.q:locId=""
	.s code=$p(^CTLOC(locId),"^",1)
	.s desc=$p(^CTLOC(locId),"^",2)
	.s type=$p(^CTLOC(locId),"^",13)
	.s laundry=$p(^CTLOC(locId),"^",18)
	.s i=i+1
	.s ^TMPGROUPLOC("CSSD",pid,i)=locId_"^"_code_"^"_desc_"^"_type_"^"_laundry
	q pid
}

Query GetLocUser(locId As %String) As %Query(ROWSPEC = "UserId:%String,No:%String,Name:%String,Password:%String,GroupId:%String") [ SqlProc ]
{
}

ClassMethod GetLocUserExecute(ByRef qHandle As %Binary, locId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	;
	q:locId="" $$$OK
	
	s ret=..GetUserByLoc(locId)
	
	q:ret="" $$$OK
	
	d OutputRow2 
	
	Quit $$$OK
OutputRow2
	s i=0
	f  s i=$o(^TMPLOCUSER("CSSD",ret,i))  q:i=""  d
	.s data=^TMPLOCUSER("CSSD",ret,i)
	.s rowid=$p(data,"^",1)
	.s userNo=$p(data,"^",2)
	.s userName=$p(data,"^",3)
	.s password=$p(data,"^",4)
	.s groupId=$p(data,"^",5)
	.s data=$lb(rowid,userNo,userName,password,groupId)
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	.
	k ^TMPLOCUSER("CSSD",ret)
	q
}

ClassMethod GetLocUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocUserExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocUserExecute ]
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

/// Creator:zdm
/// CreatDate:2010-08-09
/// Description:取某科室下的所有用户
/// Table:
/// Input:科室rowid
/// Output:用户
/// Return:
/// Others：
ClassMethod GetUserByLoc(locId As %String) As %String
{
	n (locId)
	q:locId="" ""
	s pid=$I(^TMPLOCUSER("CSSD"))
	s i=0
 	s userid=""
 	f  s userid=$o(^SSU("SSUSR",userid))  q:userid=""  d
 	.s tmploc=$p(^SSU("SSUSR",userid),"^",4)
 	.q:tmploc'=locId
 	.
 	.s name=$p(^SSU("SSUSR",userid),"^",2)
 	.s userNo=$p(^SSU("SSUSR",userid),"^",1) 
 	.s password=$p(^SSU("SSUSR",userid),"^",3)	
 	.s groupId=$p(^SSU("SSUSR",userid),"^",5)
	.s i=i+1
	.s ^TMPLOCUSER("CSSD",pid,i)=userid_"^"_userNo_"^"_name_"^"_password_"^"_groupId
	q pid
}

/// Creator:zdm
/// CreatDate:2010-10-28
/// Description:取所有单位
/// Table:
/// Input:单位名称,开始行，一页显示记录数，排序字段，排序方向
/// Output:
/// Return:单位
/// Others：
ClassMethod GetUom(desc, startRow, limit, orderField, orderDir) As %String
{
	n (desc,startRow,limit,orderField,orderDir)
	s:orderField="rowid" orderField="CTUOM_Rowid"
	s:orderField="desc" orderField="CTUOM_Desc"
	i desc'=""  d
	.s sqlStr="SELECT CTUOM_Rowid,CTUOM_Desc From CT_Uom Where CTUOM_Desc %STARTSWITH '"_desc_"'"
	e  d
	.s sqlStr="SELECT CTUOM_Rowid,CTUOM_Desc From CT_Uom" 
	s sqlStr=sqlStr_" Order by "_orderField_" "_orderDir
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	;
	s startRow=+startRow
	s maxRow=startRow+limit
	s count=0
	s resultString=""
	s json=##class(web.com.JsonObj).%New()
	s jsonTitle="rowid^desc"
	;
	While(result.Next())
	{
		s rowid =result.Data("CTUOM_RowId")
		s desc =result.Data("CTUOM_Desc")
		;
		i (count>=startRow)&(count<maxRow) d
		.s tmp=rowid_"^"_desc
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:zdm
/// CreatDate:2010-11-24
/// Description:密码加密
/// Table:
/// Input:用户输入的密码
/// Output:
/// Return:加密后的密码
/// Others：
ClassMethod Encode(encrypyString As %String, Output newString As %String) As %String [ SqlProc ]
{
	n (encrypyString,newString)
	s const=37
	s out=""
	;
	f piece=1:1:$l(encrypyString) s char=$e(encrypyString,piece) d
	. i char="D" s char=$c(2)
	. i char="p" s char=$c(3)
	. i char="d" s char=$c(4)
	. i char="t" s char=$c(5)
	. 
	. s num=$a(char)
	. s num=(num-piece+const)#255
	. i num>127 s num=(num+128)#255
	. i num<32 s num=(num+40)#255
	. i $c(num)="^" s num=num+1
	. s $e(out,piece)=$c(num#255)
	; Pad out the length
	s len=$l(out)
	f piece=(len+1):1:12 d
	. s char=$e(out,(piece-len))
	. s num=$a(char)
	. s num=(num*2.345*const*(const-7))#255
	. i num>127 s num=(num+128)#255
	. i num<32 s num=(num+40)#255
	. i $c(num)="^" s num=num+1
	. s $e(out,piece)=$c(num#255)
	; 
	s newString=out        
	q out
}

/// 获取参数的值
/// 输入paraCode的值
ClassMethod GetParameterValue(paraCode As %String, Output retval As %String) As %String
{
	n (paraCode,retval)
	s retval=-1
	&sql(select cssdp_paraValue into :retval from cssd_parameter  where cssdp_paracode=:paraCode  )
	q retval
}

/// cksss-产科手术室 变为 产科手术室
/// w ##Class(web.CSSDCommon).SubName("cksss-产科手术室")
ClassMethod SubName(str As %String) As %String
{
	n (str)
	s ret=str
	s n=$f(str,"-")
	i n'=0 d
	.s ret=$p(str,"-",2)
	q ret
}

/// w ##Class(web.CSSDCommon).GetCodeDictName("000029005")
/// 标签对应的具体器械的名字
ClassMethod GetCodeDictName(label As %String) As %String
{
	n (label)
    s fixlabel=$e(label,1,9)
    s pkgname=""
    &sql(select cssdcd_packname into :pkgname  from cssd_codedict where cssdcd_code=:fixlabel )
    i pkgname'="" d
    . s pkgname=..SubName(pkgname)
    q pkgname
}

/// w ##Class(web.CSSDCommon).GetCodeDictBindLocName("000029005")
/// CSSD_Codedict 表里面手术包绑定的科室
ClassMethod GetCodeDictBindLocName(label As %String) As %String
{
    n (label)
    s fixlabel=$e(label,1,9)
    s deptName=""
    s locId=""
    &sql(select cssdcd_oprlocid into :locId  from cssd_codedict where cssdcd_code=:fixlabel )
    i locId'="" d
    . s deptName=..GetLocName(locId)
    q deptName
}

/// w ##Class(web.CSSDCommon).GetExpireLength("")
/// 获得一种消毒包的效期长度
ClassMethod GetExpireLength(pkgdr As %String)
{
	n (pkgdr)
	s pkgExpireId =$o(^User.CSSDExpireI("CSSDEXPackageIndex",pkgdr,""))
	q:pkgExpireId="" ""
    s pkgExpire=""
    s pkgExpire=##Class(User.CSSDExpire).%OpenId(pkgExpireId)
    s length=pkgExpire.CSSDEXLength
    q length
}

// w ##Class(web.CSSDCommon).GetExpireDate(62688,"188")

ClassMethod GetExpireDate(curdate As %Integer, pkgdr As %String) As %String
{
	s pkgExpireId =$o(^User.CSSDExpireI("CSSDEXPackageIndex",pkgdr,""))
    q:pkgExpireId="" "未定义"
    s pkgExpire=""
    s pkgExpire=##Class(User.CSSDExpire).%OpenId(pkgExpireId)
    s length=pkgExpire.CSSDEXLength
    s expireDate=curdate+length
    s strExpDate=$zd(expireDate,3)
	q strExpDate
}

/// Creator：杨旭
/// CreatDate：2012-8-23
/// Description: 根据输入时间返回下月的今天
/// Table：
/// Input：checkDate:待查询时间
/// Output：
/// Return：下个月的待查询时间间隔
/// Others：w ##class(web.CSSDCommon).getDays("2012-08-01")
ClassMethod getDays(checkDate) As %String
{
	q:checkDate="" "emptyDate"
	n (checkDate)
	//s checkDate=$zd(checkDate,3)
	
	s rs=0
	s thisYear=$p(checkDate,"-",1)
	s thisMonth=$p(checkDate,"-",2)
	s thisDay=$p(checkDate,"-",3)

	s nextDate=""
	s nextMonth=""
	s nextDay=""
	s nextYear=thisYear
	
	i thisMonth=12 d
	.s nextMonth=1
	.s nextYear=thisYear+1 
	e  s nextMonth=thisMonth+1
	s afterNextDate=""
	s afterNextMonth=""
	s afterNextDay=""
	s afterNextYear=nextYear
	
	i nextMonth=12 d
	.s afterNextMonth=1
	.s afterNextYear=nextYear+1 
	e  s afterNextMonth=nextMonth+1
	
		
	s tmpcdate=$p($zd($zdh(nextYear_"-"_nextMonth_"-01",3)-1,3),"-",3)
	i tmpcdate<thisDay s thisDay=tmpcdate
	;w "tmpcdate:"_tmpcdate,!
	
	
	s tmpParam=$zdh(thisYear_"-"_thisMonth_"-"_thisDay,3)
	s afterNextDate=afterNextYear_"-"_afterNextMonth_"-01"
	s afterNextDate=$zdh(afterNextDate,3)
	s afterNextDate=afterNextDate-1
	s endDate=afterNextDate
	s afterNextDate=$zd(afterNextDate,3)
	s nextDay=$p(afterNextDate,"-",3)
	s startDate=$p(afterNextDate,"-",1)_"-"_$p(afterNextDate,"-",2)_"-01"
	
	s thisMEnd=nextYear_"-"_nextMonth_"-01"
	s thisMEnd=$zdh(thisMEnd,3)
	s thisMEnd=thisMEnd-1
	s startDate=$zdh(startDate,3)
	
	i nextDay-thisDay>0  d
	.s nextDate=nextYear_"-"_nextMonth_"-"_thisDay
	.s nextDate=$zdh(nextDate,3)
	.s rs=nextDate-tmpParam
	e  i nextDay-thisDay=0 s rs=$p($zd(endDate,3),"-",3)+thisMEnd-tmpParam
	e  s rs=thisMEnd-tmpParam+nextDay
	q rs
}

/// Creator：苏建飞
/// CreatDate：2012-8-23
/// Description: 更改有效期的天数，使得使得灭菌日期和有效日期  日期相同，即相差一个月，如果下个月没有同一天则去下个月的最后一天
/// Table：
/// Input：
/// Output：
/// Return：
/// Others：d ##class(web.CSSDCommon).UpdateExpireLength()
ClassMethod UpdateExpireLength() As %String
{
	s curDate=+$h
	s tomorrow=curDate+1
	s tomorrow=$zd(tomorrow,3)
	s length=..getDays(tomorrow)
	&sql(update cssd_expire set cssdex_length=:length where cssdex_length in(28,29,30,31) )
	s length=..getDaysByMonths(tomorrow,3)
	&sql(update cssd_expire set cssdex_length=:length where cssdex_length >=84 and  cssdex_length<=93)
	
	;s ^CSSDTomorrow=tomorrow
}

/// Creator：杨旭
/// CreatDate：2012-8-23
/// Description: 根据输入时间返回指定月份差距时间
/// Table：
/// Input：checkDate:待查询时间
/// Output：
/// Return：下个月的待查询时间间隔
/// Others：w ##class(web.CSSDCommon).getDaysByMonths("2012-08-01",12)
ClassMethod getDaysByMonths(cDate, month) As %String
{
	n (cDate,month)
	q:cDate="" "checkDate"
	q:month="" "month"
	s y=$p(cDate,"-",1)
	s m=$p(cDate,"-",2)
	s d=$p(cDate,"-",3)
	s total=0
	f i=1:1:month d
	.s tmpM=(m+i-1)
	.i (tmpM>12) d
	..s tmpY=y+1
	..s tmpM=tmpM-12
	.e  s tmpY=y
	.;w tmpY_"-"_tmpM_"-"_d,!
	.s total=total+..getDays(tmpY_"-"_tmpM_"-"_d)
	q total
}

ClassMethod GetoprName(label As %String) As %String
{
		n (label)
    //s fixlabel=$e(label,1,9)
    s pkgname=""
    &sql(select CSSDPR_Package_DR->CSSDP_Desc into :pkgname  from cssd_packagereg where CSSDPR_Label=:label )
    i pkgname'="" d
    . s pkgname=..SubName(pkgname)
    q pkgname
}

}
