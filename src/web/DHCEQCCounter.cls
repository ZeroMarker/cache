Import SQLUser

Class web.DHCEQCCounter Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 23;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

// 设备计数器

Parameter SQLCODE = "CNT_RowID";

Parameter SQLDESCRIPTION = "CNT_RowID";

Parameter SQLROWID = "CNT_RowID";

/// w ##class(web.DHCEQCCounter).GetNextNo("DHC_EQInStock",+$h,"1",1,1,0501)
ClassMethod GetNextNo(table, curdate, locdr As %Library.String = "", equiptype As %Library.String = "", statcat As %Library.String = "", equipcatcode As %Library.String = "", movetypecode As %Library.String = "", outtypecode As %Library.String = "", mainequipno As %Library.String = "")
{
	new type,rowid,prefix,suf,counter,len,groupflag,group,Node
	
	s type=0,rowid=0
	s type=$o(^DHCEQCCode("DHCEQCCounterType",0,"TableName",table,type))
	if type="" q ""
	s rowid=$o(^DHCEQCCode("DHCEQCCounter",0,"Type",type,rowid))
	if rowid="" q ""
	s prefix=$p(^DHCEQCCode("DHCEQCCounter",rowid),"^",4)
	s suf=$p(^DHCEQCCode("DHCEQCCounter",rowid),"^",5)
	if (prefix=$c(0)) s prefix=""
	if (suf=$c(0)) s suf=""
	s len=$p(^DHCEQCCode("DHCEQCCounter",rowid),"^",3)
	
	s groupflag=$p(^DHCEQCCode("DHCEQCCounter",rowid),"^",6)
	s group=$p(^DHCEQCCode("DHCEQCCounter",rowid),"^",7)
	if groupflag="Y"
	{
		s Node=##class(web.DHCEQCCounter).ParsePrefix(group,curdate,locdr,equiptype,statcat,equipcatcode,movetypecode,outtypecode,mainequipno)
		i Node="" s Node=0
		s counter=$g(^DHCEQCCode("DHCEQCCounter",rowid,"EX","Group",Node))
		s counter=counter+1
		s (^DHCEQCCode("DHCEQCCounter",rowid,"EX","Group",Node))=counter
	}
	else
	{
		s counter=$p(^DHCEQCCode("DHCEQCCounter",rowid),"^",1)
		s counter=counter+1
		s $p(^DHCEQCCode("DHCEQCCounter",rowid),"^",1)=counter
	}
		
	s counter=..LPAD(counter,"0",len)
	q:(counter="")
	s prefix=..ParsePrefix(prefix,curdate,locdr,equiptype,statcat,equipcatcode,movetypecode,outtypecode,mainequipno)
	s suf=..ParsePrefix(suf,curdate,locdr,equiptype,statcat,equipcatcode,movetypecode,outtypecode,mainequipno)
	
	q prefix_counter_suf
}

/// w ##class(web.DHCEQCCounter).ParsePrefix("[Date]",+$h)
ClassMethod ParsePrefix(prefix, curdate As %Library.String = "", locdr As %Library.String = "", equiptype As %Library.String = "", statcat As %Library.String = "", equipcatcode As %Library.String = "", movetypecode As %Library.String = "", outtypecode As %Library.String = "", mainequipno As %Library.String = "")
{
	if prefix="" q ""
	n LocRemark,LocType,LocTypeCode,rowid
	s (LocID,HospitalDR,HospitalCode,LocRemark)=""
	i locdr="" s locdr=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s HospitalDR=$p($g(^DHCEQCCode("DHCEQCDepartment",locdr)),"^",22)
	i HospitalDR'="" s HospitalCode=$p($g(^CT("HOSP",HospitalDR)),"^",1)
	i curdate'=""
	{
		s curdate=$zd(curdate,8)
		s prefix=##class(web.DHCEQCommon).Replace(prefix,"[Date]",curdate)
		s prefix=##class(web.DHCEQCommon).Replace(prefix,"[Date,6]",$e(curdate,3,8))
		s prefix=##class(web.DHCEQCommon).Replace(prefix,"[Month]",$e(curdate,1,6))
		s prefix=##class(web.DHCEQCommon).Replace(prefix,"[Month,4]",$e(curdate,3,6))
		s prefix=##class(web.DHCEQCommon).Replace(prefix,"[Year]",$e(curdate,1,4))
	}
	i equiptype'="" s prefix=##class(web.DHCEQCommon).Replace(prefix,"{EquipType}",equiptype)
	i ((equiptype'="")&&($Piece(statcat,"-",2)'="")) Set statcat=$Piece(statcat,"-",2)
	i statcat'="" s prefix=##class(web.DHCEQCommon).Replace(prefix,"{StatCat}",statcat)
	i equipcatcode'="" s prefix=##class(web.DHCEQCommon).Replace(prefix,"{EquipCat}",equipcatcode)	
	i HospitalCode'="" s prefix=##class(web.DHCEQCommon).Replace(prefix,"{Hospital}",HospitalCode)
	// Mozy0111		2013-11-4
	i locdr'=""  d
	.Set prefix=##class(web.DHCEQCommon).Replace(prefix,"{LocDR}",##class(web.DHCEQCCounter).LPAD(locdr,"0",3))
	.Set LocType=""
	.For  Set LocType=$Order(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType)) Quit:(LocType="")  Do
	..Set LocTypeCode=$p(^DHCEQCCode("DHCEQCLocGroupType",LocType),"^",2)
	..Quit:$e(LocTypeCode,3,4)'="01"	;只取库房科室中的库房定义的备注
	..Set rowid=""
	..For  Set rowid=$Order(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType,locdr,rowid)) Quit:(rowid="")  Do
	...Set LocRemark=$Piece(^DHCEQCCode("DHCEQCLocType",rowid),"^",5)
	...Set LocRemark=##Class(web.DHCEQCommon).Trim(LocRemark)
	Set prefix=##class(web.DHCEQCommon).Replace(prefix,"{LocRemark}",LocRemark)
	If movetypecode'="" Set prefix=##class(web.DHCEQCommon).Replace(prefix,"{MoveType}",movetypecode)
	If outtypecode'="" Set prefix=##class(web.DHCEQCommon).Replace(prefix,"{OutType}",outtypecode)
	If mainequipno'="" s prefix=##class(web.DHCEQCommon).Replace(prefix,"{EQNo}",mainequipno)		//czf 2021-11-3
	
	q prefix
}

/// w ##class(web.DHCEQCCounter).LPAD(1111,"0",6)
ClassMethod LPAD(STRING, SUB, LENGTH)
{
 N RES
 q:'$g(LENGTH) ""
 i '$g(LENGTH) s LENGTH=6
 S $P(RES,SUB,LENGTH)=SUB
 Q $E(RES,1,LENGTH-$L(STRING))_$E(STRING,1,LENGTH)
}

/// Creator:ZY   2009-11-17 ZY0017
/// Description:“分类编号”使用财政部分类代码（取6位，把“-”去掉）+4位序号
/// Input:  设备rowid和时间
/// Return: 设备编号
/// w ##Class(web.DHCEQEquip).GetNextNoNew("5", +$H)
Query Counter() As %Query(ROWSPEC = "TRowID:%String,TypeDR:%String,TType:%String,TLength:%String,TPrefix:%String,TSuffix:%String,TCounterNum:%String,TGroupFlag:%String,TGroup:%String,RHold1:%String,THold2:%String,THold3:%String,TRow:%String")
{
}

ClassMethod CounterExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s TypeDR=0
	f  s TypeDR=$o(^DHCEQCCode("DHCEQCCounterType",TypeDR)) quit:TypeDR=""  d
	.s TType=$p($g(^DHCEQCCode("DHCEQCCounterType",TypeDR)),"^",2)
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQCCounter",0,"Type",TypeDR,rowid)) q:rowid=""  d
	..d ResetVariablesGetCounter
	..s TRowID = rowid												//rowid
	..s TLength=$p($g(^DHCEQCCode("DHCEQCCounter",rowid)),"^",3) 	//长度
	..s TCounterNum=$p($g(^DHCEQCCode("DHCEQCCounter",rowid)),"^",1)
	..s TPrefix=$p($g(^DHCEQCCode("DHCEQCCounter",rowid)),"^",4) 	//前缀
	..s TSuffix=$p($g(^DHCEQCCode("DHCEQCCounter",rowid)),"^",5) 	//后缀
	..s TGroupFlag=$p($g(^DHCEQCCode("DHCEQCCounter",rowid)),"^",6) //是否分组计数
	..i TGroupFlag'="" s TGroupFlag=##class(web.DHCEQCommon).TransValueToPage(TGroupFlag,"bool")		;GroupFlag
	..s TGroup=$p($g(^DHCEQCCode("DHCEQCCounter",rowid)),"^",7) 	//分组计数串
	..s THold1=$p($g(^DHCEQCCode("DHCEQCCounter",rowid)),"^",8) 	//保留1
	..s THold2=$p($g(^DHCEQCCode("DHCEQCCounter",rowid)),"^",9) 	//保留2
	..s THold3=$p($g(^DHCEQCCode("DHCEQCCounter",rowid)),"^",10) 	//保留3
    ..d OutputRowGetCounter
    
	Quit $$$OK
OutputRowGetCounter
    set Data=$lb(TRowID,TypeDR,TType,TLength,TPrefix,TSuffix,TCounterNum,TGroupFlag,TGroup,THold1,THold2,THold3,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetCounter
	s (TRowID,TLength,TPrefix,TLSuffix,TCounterNum,TGroupFlag,TGroup,THold1,THold2,THold3)=""
	quit
}

ClassMethod CounterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CounterExecute ]
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

ClassMethod CounterClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CounterExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录 
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
	new rowid,Len,SQLCODE
	k PLIST
	s SQLCODE=0
	s Len=$L(val,";")
	Set $ZT="ERROR"
	s TableName="DHC_EQCCounter"
 	s ClassName="User.DHCEQCCounter"
 	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))		
 	s DCRRowID=""
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	TSTART
	for i = 1:1:Len
	{
		s PLIST(i)=$p(val,";",i)
		quit:PLIST(i)=""
		quit:SQLCODE'=0
		s rowid=$p(PLIST(i),"^",2)
		s BussID=rowid
		s Vale(2)=$p(PLIST(i),"^",3)		;CounterNum	
		s Vale(3)=$p(PLIST(i),"^",4)		;TypeDR
		s Vale(4)=$p(PLIST(i),"^",5)		;Length
		s Vale(5)=$p(PLIST(i),"^",6)		;Prefix
		s Vale(6)=$p(PLIST(i),"^",7)		;Suffix
		s Vale(7)=##class(web.DHCEQCommon).TransValueFromPage($p(PLIST(i),"^",8),"bool")		;GroupFlag
		s Vale(8)=$p(PLIST(i),"^",9)		;Group
		s Vale(9)=$p(PLIST(i),"^",10)		;Hold1
		s Vale(10)=$p(PLIST(i),"^",11)	;Hold2
		s Vale(11)=$p(PLIST(i),"^",12)	;Hold3
		if (rowid'="") 
 		{
	 		Set OperateType="U"
			s OldObject=##Class(User.DHCEQCCounter).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			&SQL(Update SQLUSER.DHC_EQCCounter Values :Vale() where CNT_RowID = :rowid) 	 	
		}
 		else
		{
			&SQL(Insert Into SQLUSER.DHC_EQCCounter Values :Vale())
		}
		Set ID=$g(%ROWID)
		s OldObject=""	//先关闭对象 czf 2021-01-21
		s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCCounter).%OpenId(ID))

		i BussID'=""	//更新数据获取更新字段Json串
		{
			s key=""
			For
			{
				s value=FinalObj.GetNext(.key)
				q:key=""
    			i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
			}
		}
		i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
		{
			d ##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
		}
			  
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q SQLCODE
ERROR
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERROR"_ErrorMsg     //返回错误消息 ;
}

/// w ##class(web.DHCEQCCounter).GetNextNoToPage("DHC_EQTempCode",+$h,"1","","","","","","")
ClassMethod GetNextNoToPage(table, curdate, locdr As %Library.String = "", equiptype As %Library.String = "", statcat As %Library.String = "", equipcatcode As %Library.String = "", movetypecode As %Library.String = "", outtypecode As %Library.String = "", masteritemno As %Library.String = "")
{
	new type,rowid,prefix,suf,counter,len,groupflag,group,Node
	//s equipcatcode=$e(equipcatcode,1,5)
	
	s type=0,rowid=0
	s type=$o(^DHCEQCCode("DHCEQCCounterType",0,"TableName",table,type))
	if type="" q ""
	s rowid=$o(^DHCEQCCode("DHCEQCCounter",0,"Type",type,rowid))
	if rowid="" q ""
	s prefix=$p(^DHCEQCCode("DHCEQCCounter",rowid),"^",4)
	s suf=$p(^DHCEQCCode("DHCEQCCounter",rowid),"^",5)
	if (prefix=$c(0)) s prefix=""
	if (suf=$c(0)) s suf=""
	s len=$p(^DHCEQCCode("DHCEQCCounter",rowid),"^",3)
	
	s groupflag=$p(^DHCEQCCode("DHCEQCCounter",rowid),"^",6)
	s group=$p(^DHCEQCCode("DHCEQCCounter",rowid),"^",7)
	if groupflag="Y"
	{
		s Node=##class(web.DHCEQCCounter).ParsePrefix(group,curdate,locdr,equiptype,statcat,equipcatcode,movetypecode,outtypecode,masteritemno)
		i Node="" s Node=0
		s counter=$g(^DHCEQCCode("DHCEQCCounter",rowid,"EX","Group",Node))
		s counter=counter+1
	}
	else
	{
		s counter=$p(^DHCEQCCode("DHCEQCCounter",rowid),"^",1)
		s counter=counter+1
	}
		
	s counter=..LPAD(counter,"0",len)
	q:(counter="")
	s prefix=..ParsePrefix(prefix,curdate,locdr,equiptype,statcat,equipcatcode,movetypecode,outtypecode,masteritemno)
	s suf=..ParsePrefix(suf,curdate,locdr,equiptype,statcat,equipcatcode,movetypecode,outtypecode,masteritemno)
	
	q prefix_counter_suf
}

}
