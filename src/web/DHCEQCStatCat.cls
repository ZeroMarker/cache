Class web.DHCEQCStatCat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para, para1) As %SQLQuery(ROWSPEC = "Description:%String:设备类型,HIDDEN:%String,Code:%String:编码,Years:%String:使用年限,Remark:%String:备注")
{
SELECT SC_Desc,
	   SC_RowID,
	   SC_Code,
	   SC_Hold1,
	   SC_Remark
FROM sqluser.DHC_EQCStatCat,sqluser.DHC_EQCEquipType
where (SC_Desc like nvl(:para,'')||'%') and sc_invalidflag='N' and et_rowid=:para1 and sc_Hold4=et_hold1 and sc_rowid not in (select ens_statcatdr from sqluser.DHC_EQETNotAccessSC where ens_equiptypedr=:para1 and ens_notaccessflag='Y')
}

Query StatCat(Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlag:%String,TEQType:%String,TEQFlag:%String,TMinPrice:%String,TMaxPrice:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod StatCatExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s index=1
	s TRow=1
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCStatCat",rowid)) quit:rowid=""  d
	.d ResetVariablesGetStatCat
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",2)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",3)
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",4)
	.q:TInvalidFlag="Y"
	.s TEQType=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",5) //GR0015 2014-11-24 标准库卫计委与无心资产更新之间兼容
	.Set TEQType=##class(web.DHCEQCommon).GetAssetType(TEQType)	/// Mozy0145	20141017
	.//s TEQType=$Case(TEQType,"":"","1":"设备","2":"土地","3":"房屋建筑物","4":"交通工具","5":"图书","9":"其他") //EQType
	.s TEQFlag=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",6)
	.s TMinPrice=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",7)
	.s TMaxPrice=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",8)
	.s THold1=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",9)
	.s THold2=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",10)
	.i THold2'="" s THold2=$p($g(^DHCEQCCode("DHCEQForCWJW",THold2)),"^",2)		//Add By DJ 2015-07-14 DJ0147
	.s THold3=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",11)
	.i THold3'="" s THold3=$p($g(^DHCEQCCode("DHCEQCDepreMethod",THold3)),"^",2)	// MZY0030	1340074		2020-06-01
	.s THold4=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",12)
	.i THold4'="" s THold4=$p($g(^DHCEQCCode("DHCEQCFinanceType",THold4)),"^",2)
	.s THold5=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",13)
	.d OutputRowGetStatCat
	Quit $$$OK
OutputRowGetStatCat
	s Data=$lb(TRowID,TCode,TDesc,TRemark,TInvalidFlag,TEQType,TEQFlag,TMinPrice,TMaxPrice,THold1,THold2,THold3,THold4,THold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetStatCat
	s (TRowID,TCode,TDesc,TRemark,TInvalidFlag,TEQType,TEQFlag,TMinPrice,TMaxPrice,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod StatCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatCatExecute ]
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

ClassMethod StatCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// w ##Class(web.DHCEQCStatCat).SaveData("3^03^交通工具^^false^^true^1000^^^^^^1","")
/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录 
ClassMethod SaveData(val, isDel)
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	s $zt="ErrorSave"
 	s TableName="DHC_EQCStatCat"
 	s ClassName="User.DHCEQCStatCat"
 	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
 	s BussID=rowid	
 	s DCRRowID=""
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	TSTART
	i (+isDel=1)
	{

		s OldObject=##Class(User.DHCEQCStatCat).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

		s PLIST(5)="Y"
		&SQL(Update sqluser.DHC_EQCStatCat Values :PLIST() where SC_RowID = :rowid) 

	 	If SQLCODE
	 	{
		 	TRollback
		 	q SQLCODE
		}
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""SCInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
		TCommit
	 	Quit rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s Code=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s Desc=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"bool")
	s PLIST(6)=$p(val,"^",6)
	s PLIST(7)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"bool")
	s PLIST(8)=$p(val,"^",8)
	s PLIST(9)=$p(val,"^",9)
	s PLIST(10)=$p(val,"^",10)
	s PLIST(11)=$p(val,"^",11)
	s PLIST(12)=$p(val,"^",12)
	s PLIST(13)=$p(val,"^",13)
	s PLIST(14)=$p(val,"^",14)
	s tmpid=""
	&SQL(select SC_RowID into :tmpid from sqluser.DHC_EQCStatCat where SC_Code=:Code and SC_Desc=:Desc and SC_InvalidFlag!='Y')
	if ((tmpid="")||(tmpid=rowid))
	{
		i (rowid="")
		{
	 		Set BussID="",OperateType="A"
			&SQL(Insert Into sqluser.DHC_EQCStatCat Values :PLIST())
		} 
		else
		{
			Set BussID=rowid,OperateType="U"
			s OldObject=##Class(User.DHCEQCStatCat).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			&SQL(Update sqluser.DHC_EQCStatCat Values :PLIST() where SC_RowID = :rowid)
		}
	}
	If SQLCODE
 	{
	 	TRollback
	 	q SQLCODE
	}
	Set ID=$g(%ROWID)
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCStatCat).%OpenId(ID))
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
	else			//插入数据
	{
		s BussID=ID
		s NewObj=FinalObj
	}
	
	i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
	{
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
		If Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
	}
	TCommit
	q ID
ErrorSave
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQCStatCat).GetDocByID(rowid)
ClassMethod GetDocByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCStatCat",rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p(result,"^",1) //code
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p(result,"^",2) //描述
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p(result,"^",3) //备注
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).TransValueFromPage($p(result,"^",4),"bool") //InvalideFlag
	s resultex=resultex_"^"	//5
	s resultex=resultex_$p(result,"^",5) //GR0015 2014-11-24
	/*
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$Case($p(result,"^",5),"":"","1":"设备","2":"土地","3":"房屋建筑物","4":"交通工具","5":"图书","9":"其他") //EQType
	*/
	s resultex=resultex_"^"	//6
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).TransValueFromPage($p(result,"^",6),"bool") //EQFlag
	s resultex=resultex_"^"	//7
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p(result,"^",7) //MinPeice
	s resultex=resultex_"^"	//8
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p(result,"^",8) //MaxPeice
	s resultex=resultex_"^"	//9
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p(result,"^",9) //hold1
	s resultex=resultex_"^"	//10
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_$p(result,"^",10) //hold2
	s resultex=resultex_"^"	//11
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$p(result,"^",11) //hold3
	s resultex=resultex_"^"	//12
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_$p(result,"^",12) //hold4
	s resultex=resultex_"^"	//13
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_$p(result,"^",13) //hold5
	//add by zy zy0114 2014-07-31
	s resultex=resultex_"^"	//14
	i $p(result,"^",10)'="" d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQForCWJW",$p(result,"^",10))),"^",2)
	s resultex=resultex_"^"	//15
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFinanceType",$p(result,"^",12))),"^",2) //hold4Desc
	// MZY0030	1340074		2020-06-01
	s resultex=resultex_"^"	//16
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDepreMethod",$p(result,"^",11))),"^",2)
	q resultex
}

}
