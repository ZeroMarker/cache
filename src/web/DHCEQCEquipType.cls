Class web.DHCEQCEquipType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String:名称,HIDDEN:%String,Code:%String:编码")
{
SELECT ET_Desc,
	   ET_RowID,
	   ET_Code
FROM sqluser.DHC_EQCEquipType
where ET_InvalidFlag = 'N' and ET_Desc like nvl(:para,'')||'%'
}

ClassMethod GetEquipTypesInfo()
{
	s infos=""
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCEquipType",rowid)) q:rowid=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",4)'="N"
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(rowid)
	.Quit:(##Class(web.DHCEQCommon).CheckManageLimit("","","",rowid))
	.i infos'="" s infos=infos_"&"		//	Mozy0071	2011-12-05
	.s infos=infos_$g(^DHCEQCCode("DHCEQCEquipType",rowid))_"^"_rowid
	q infos
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCEquipType","EquipType","","")
/// modify by jyp 2018-08-16 Hisui改造：Query输出列flag显示异常
Query EquipType(Code As %String = "", Desc As %String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlag:%String,TEQType:%String,TEQFlag:%String,TMinPrice:%String,TMaxPrice:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod EquipTypeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s index=1
	s TRow=1
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)	//CZF0138 2021-04-20
	
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCEquipType",rowid)) quit:rowid=""  d
	.q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCEquipType",rowid,sHospID)'="Y"		//czf 2021-04-20
	.d ResetVariablesGetEquipType
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",2)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",3)
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",4)
	.q:TInvalidFlag="Y"
	.s TEQType=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",5)
	.s TEQType=$Case(TEQType,"":"","1":"设备","2":"土地","3":"房屋建筑物","4":"交通工具","5":"图书","9":"其他") //EQType
	.s TEQFlag=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",6)
	. // MZY0024	1312307		2020-05-09
	.i TEQFlag="Y"  s TEQFlag="是"
	.e  s TEQFlag="否"
	.///end add by jyp 2018-08-16 Hisui改造：Query输出列flag显示异常
	.s TMinPrice=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",7)
	.s TMaxPrice=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",8)
	.s THold1=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",9)
	.i THold1'="" s THold1=$p($g(^DHCEQCCode("DHCEQCFinanceType",THold1)),"^",2)
	.s THold2=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",10)
	.s THold3=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",11)
	.s THold4=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",12)
	.s THold5=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",13)
	.d OutputRowGetEquipType
	Quit $$$OK
OutputRowGetEquipType
	s Data=$lb(TRowID,TCode,TDesc,TRemark,TInvalidFlag,TEQType,TEQFlag,TMinPrice,TMaxPrice,THold1,THold2,THold3,THold4,THold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetEquipType
	s (TRowID,TCode,TDesc,TRemark,TInvalidFlag,TEQType,TEQFlag,TMinPrice,TMaxPrice,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod EquipTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EquipTypeExecute ]
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

ClassMethod EquipTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EquipTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// w ##Class(web.DHCEQCEquipType).SaveData("3^03^交通工具^^false^^true^1000^^^^^^1","")
/// modified by sjh SJH0038 2020-11-10 增加数据修改日志记录
/// modified by CZF0138 2021-04-20 入参增加gHospId：登录医院ID  BDPHospId:医院组件选中医院ID
ClassMethod SaveData(val, isDel, gHospId As %Library.String = "", BDPHospId As %Library.String = "")
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	s $zt="ErrorSave"
	s TableName="DHC_EQCEquipType"
	s ClassName="User.DHCEQCEquipType"
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	s BussID=rowid	
	s DCRRowID=""
	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	;获取院区Id(多院区) CZF0138
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
	TSTART
	i (+isDel=1)
	{

		s OldObject=##Class(User.DHCEQCEquipType).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

		s PLIST(5)="Y"
		&SQL(Update sqluser.DHC_EQCEquipType Values :PLIST() where ET_RowID = :rowid) 
	 	If SQLCODE
	 	{
		 	TRollback
		 	q SQLCODE
		}
		;删除医院对照关系 czf 2021-04-20
		s RtnCode=##class(web.DHCEQ.Util.BDPCommonUtil).DeleteHospitals("DHC_EQCEquipType",rowid,sHospID)
		if RtnCode<0
		{
			TROLLBACK
			Quit RtnCode
		}
		
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""ETInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
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
	
	;判断数据是否重复
	s RtnInfo=##class(web.DHCEQ.Util.BDPCommonUtil).CodeDescIsRepeat("DHC_EQCEquipType",rowid,Code_"^"_Desc,sHospID)
	s Rowid=$p(RtnInfo,"$",1)
	if Rowid'="" q $p($p(RtnInfo,"$",2),"^",1)
	
	/*
	s tmpid=""
	&SQL(select ET_RowID into :tmpid from sqluser.DHC_EQCEquipType where ET_Code=:Code and ET_Desc=:Desc and ET_InvalidFlag!='Y')
	if ((tmpid'="")&&(tmpid'=rowid)) q -3003	;重复记录
	*/
	i (rowid="")
	{
		Set BussID="",OperateType="A"
		Set PLIST(5) =##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"bool")
		&SQL(Insert Into sqluser.DHC_EQCEquipType Values :PLIST())
	} 
	else
	{
		Set BussID=rowid,OperateType="U"
		s OldObject=##Class(User.DHCEQCEquipType).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		&SQL(Update sqluser.DHC_EQCEquipType Values :PLIST() where ET_RowID = :rowid)
	}
	If SQLCODE
 	{
	 	TRollback
	 	q -3001
	}
	Set ID=$g(%ROWID)
	
	;保存医院对照关系 CZF0138 2021-04-20
	s RtnCode=##class(web.DHCEQ.Util.BDPCommonUtil).SaveHOSP("DHC_EQCEquipType",ID,sHospID)
    if RtnCode<0
	{
		TROLLBACK
		Quit RtnCode
	}
	
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCEquipType).%OpenId(ID))

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

/// w ##Class(web.DHCEQCEquipType).GetDocByID(rowid)
ClassMethod GetDocByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCEquipType",rowid)
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
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$Case($p(result,"^",5),"":"","1":"设备","2":"土地","3":"房屋建筑物","4":"交通工具","5":"图书","9":"其他") //EQType
	s resultex=resultex_"^"	//6
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"bool") //EQFlag	2012-5-31	Mozy0083
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
	s resultex=resultex_"^"	//14
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFinanceType",$p(result,"^",9))),"^",2) //hold1
	q resultex
}

ClassMethod EQTypeDisplay(name, width)
{
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=1>设备</option>"
	w "<option value=2>土地</option>"
	w "<option value=3>房屋建筑物</option>"
	w "<option value=4>交通工具</option>"
	w "<option value=5>图书</option>"
	w "<option value=9>其他</option>"
	w "</select>",!
}

/// Add by czf 20180601
ClassMethod GetEquipTypes(EquipTypeIDs As %String = "")
{
	s EquipTypes=""
	i EquipTypeIDs="" q EquipTypes
	s len=$l(EquipTypeIDs)
	f i=1:1:len d
	.s EquipTypeDR=$p(EquipTypeIDs,",",i)
	.s EquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	.i EquipTypeIDs="" s EquipTypes=EquipType
	.e  s EquipTypes=EquipTypes_","_EquipType
	
	q EquipTypes
}

Storage Default
{
<Data name="DHCEQCEquipTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQCEquipTypeD</DataLocation>
<DefaultData>DHCEQCEquipTypeDefaultData</DefaultData>
<IdLocation>^web.DHCEQCEquipTypeD</IdLocation>
<IndexLocation>^web.DHCEQCEquipTypeI</IndexLocation>
<StreamLocation>^web.DHCEQCEquipTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
