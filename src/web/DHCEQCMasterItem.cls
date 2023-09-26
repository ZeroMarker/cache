Import SQLUser

/// Modified By HZY 2011-07-29  HZY0003
/// 描述：增加“医院”和“设备类组”联合查询功能。
/// 修改：MasterItem查询。
/// -----------------------------------------------------------------------
/// Modify DJ 2010-03-29
/// 描述:选择设备项读取使用年限及折旧方法
/// 修改:GetMasterItem查询,增加方法:GetDepreMethodByEquipCat,GetYearsByEquipCat
/// -----------------------------------------------------------------------
Class web.DHCEQCMasterItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 设备项
ClassMethod MasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// modify by wl 2020-02-18 WL0051 增加EquipAttributeString
ClassMethod MasterItemExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "", EquipTypeDR As %String = "", EquipType As %String = "", CatDR As %String = "", Cat As %String = "", StatCatDR As %String = "", StatCat As %String = "", UnitDR As %String = "", Unit As %String = "", Hold2 As %String = "", Hold1 As %String = "", Hold1Code As %String = "", Hold1Desc As %String = "", EquipAttributeString As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Remark=$ZCONVERT(Remark ,"U")
 	s Cat=$ZCONVERT(Cat ,"U")
 	s StatCat=$ZCONVERT(StatCat ,"U")
 	s Unit=$ZCONVERT(Unit ,"U")
 	s EquipType=$ZCONVERT(EquipType ,"U")
	s index=1
	s TRow=1
	;Add by JDL 2012-12-20 JDL0095
	s TJob=$j
	
	;Modified by JDL 2011-6-15 JDL0083
	i (Hold2'="")		
	{
		s LTEquipTypeDR=0
		f  s LTEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hold2,LTEquipTypeDR))  quit:LTEquipTypeDR=""  d
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=LTEquipTypeDR)
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(LTEquipTypeDR,"","","2")'=0   //add by zx 2017-03-20 BUG ZX0036
		.s LTEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",LTEquipTypeDR)),"^",2)
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hold2,LTEquipTypeDR,rowid))  quit:rowid=""  d
		..d ResetVariablesGetMasterItem
		..d BuildDataGetMasterItem
	}
	else
	{
		s LTEquipTypeDR=0
		f  s LTEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",LTEquipTypeDR))  quit:LTEquipTypeDR=""  d
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=LTEquipTypeDR)
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(LTEquipTypeDR,"","","2")'=0   //add by zx 2017-03-20 BUG ZX0036
		.s LTEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",LTEquipTypeDR)),"^",2)
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",LTEquipTypeDR,rowid))  quit:rowid=""  d
		..d ResetVariablesGetMasterItem
		..d BuildDataGetMasterItem		
	}
	
	;Add by JDL 2012-12-20 JDL0095
	d ##Class(web.DHCEQCommon).SetPageInfo("DHCEQCMasterItem.MasterItem",TJob,index-1)
	
	Quit $$$OK
BuildDataGetMasterItem
	s LTRowID = rowid	//rowid
	s LTCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2) //代码
	s LTDesc=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1) //描述
	s LTCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",4) //
	i LTCatDR'=""  d
	.s LTCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",LTCatDR)),"^",2) //
	.s TCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",LTCatDR)),"^",1) //
	s LTStatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",5) //
	i LTStatCatDR'="" s LTStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",LTStatCatDR)),"^",2) //
	s LTRemark=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",6)
	s LTUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7)
	i LTUnitDR'="" s LTUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",(LTUnitDR))	;Modified By jdl 20150906 v4.1.0 规范单位取值
	s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",8)
	q:LTInvalidFlag="Y"
	q:($ZCONVERT(LTCode,"U")'[Code)&(Code'="") //
	q:($ZCONVERT(LTDesc,"U")'[Desc)&(Desc'="")
	q:($ZCONVERT(LTRemark,"U")'[Remark)&(Remark'="")
	q:($ZCONVERT(LTEquipType,"U")'[EquipType)&(EquipType'="")
	q:($ZCONVERT(LTCat,"U")'[Cat)&(Cat'="")
	q:($ZCONVERT(LTStatCat,"U")'[StatCat)&(StatCat'="")
	q:($ZCONVERT(LTUnit,"U")'[Unit)&(Unit'="")
	q:(EquipTypeDR'="")&(EquipTypeDR'=LTEquipTypeDR)
	q:(CatDR'="")&(CatDR'=LTCatDR)
	q:(StatCatDR'="")&(StatCatDR'=LTStatCatDR)
	q:(UnitDR'="")&(UnitDR'=LTUnitDR)
	;MZY0021	1304168		2020-05-06	增加类组禁止访问类型过滤
	s ENSRowID=$o(^DHCEQCCode("DHCEQETNotAccessSC",0,"StatCat",LTEquipTypeDR,LTStatCatDR,""))
	q:$p($g(^DHCEQCCode("DHCEQETNotAccessSC",+ENSRowID)),"^",4)="Y"
	
	//add by jdl 2009-9-12 JDL0029
	//TForceInspectFlag,THold1,THold2,THold3,THold4,THold5,THold1Desc
	s TForceInspectFlag=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",9)
	s THold1=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",10)
	q:(Hold1'="")&&(THold1'=Hold1)
	s THold2=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",11)
	s THold3=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",12)
	i THold3="N" s THold3="否"
	i THold3="Y" s THold3="是"
	s THold4=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",13)
	s THold5=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",14)
	s THold6=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",20)	//czf 1283059 单台计量费用
	//Mozy0110
	s THold1Desc=""
	i THold1'=""
	{
		s THold1Code=$P(^DHCEQCCode("DHCEQCTree",THold1),"^",2)
		s THold1Desc=$P(^DHCEQCCode("DHCEQCTree",THold1),"^",3)
	}

	;Modified by JDL 2011-6-15 JDL0083
	i THold2'="" s THold2Desc=$P($g(^CT("HOSP",THold2)),"^",2)
	//add by wl 2020-02-18 WL0051 设备属性查询
	set SplitNumCode=##class(web.DHCEQCommon).GetSysInfo("990026")
	i (EquipAttributeString'="")
	{
		s EALength=$L(EquipAttributeString,SplitNumCode)
		s hasFlag=1
		f i=1:1:EALength d
		.q:hasFlag'=1
		.s EquipAttributeID=$p($P(EquipAttributeString,SplitNumCode,i),"id",2)
		.i $o(^DHCEQEquipAttributeList(0,"SourceAttribute",1,rowid,EquipAttributeID,0))="" s hasFlag=0
		i hasFlag=0 {quit}
	}
	d OutputRowGetMasterItem
	quit
OutputRowGetMasterItem
	s Data=$lb(LTRowID,LTCode,LTDesc,LTEquipType,LTEquipTypeDR,LTCatDR,LTCat,LTStatCatDR,LTStatCat,LTRemark,LTUnitDR,LTUnit,LTInvalidFlag,TForceInspectFlag,THold1,THold2,THold3,THold4,THold5,THold1Desc,THold2Desc,TJob,THold1Code,TCatCode,TRow,THold6)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetMasterItem
	s (LTRowID,LTCode,LTDesc,LTCatDR,LTCat,LTStatCatDR,LTStatCat,LTRemark,LTUnitDR,LTUnit,LTInvalidFlag)=""
	s (TForceInspectFlag,THold1,THold2,THold3,THold4,THold5,THold1Desc,THold2Desc,THold1Code,TCatCode,THold6)=""
	quit
}

ClassMethod MasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MasterItemExecute ]
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

/// Modified By HZY 2011-07-29  HZY0003.
/// modify by wl 2020-02-18 WL0051
/// modified by czf 1283059 增加出参THold6
Query MasterItem(Code As %String = "", Desc As %String = "", Remark As %String = "", EquipTypeDR As %String = "", EquipType As %String = "", CatDR As %String = "", Cat As %String = "", StatCatDR As %String = "", StatCat As %String = "", UnitDR As %String = "", Unit As %String = "", Hold2 As %String = "", Hold1 As %String = "", Hold1Code As %String = "", Hold1Desc As %String = "", EquipAttributeString As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TEquipType:%String,TEquipTypeDR:%String,TCatDR:%String,TCat:%String,TStatCatDR:%String,TStatCat:%String,TRemark:%String,TUnitDR:%String,TUnit:%String,TInvalidFlag:%String,TForceInspectFlag:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,THold1Desc:%String,THold2Desc:%String,TJob:%String,THold1Code:%String,TCatCode:%String,TRow:%String,THold6:%String")
{
}

/// 添加参数 EquipAttribute 用于保存设备属性  设备属性相关调整
/// 添加事务处理用于多表操作  JYP 2019-09-02
/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录
/// modified by wy 2022-4-28 移动端增加session入参
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "", EquipAttribute As %Library.String = "", UserID As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 Set $ZT="ERROR" //add by jyp 2019-09-02  设备属性相关调整
 
 s TableName="DHC_EQCMasterItem"
 s ClassName="User.DHCEQCMasterItem"
 s CurUser=UserID
 if CurUser="" s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
 s BussID=rowid	
 s DCRRowID=""
 s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 TSTART
 i (+isDel=1)
 {
		s OldObject=##Class(User.DHCEQCMasterItem).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

 		s PLIST(9)="Y"
 		&SQL(Update SQLUSER.DHC_EQCMasterItem Values :PLIST() where MI_RowID = :rowid) 

	 	If SQLCODE
	 	{
		 	TRollback
		 	q SQLCODE
		}
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""MIInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
		TCommit
	 	Quit rowid
 } 
 i (+isDel=3) s rowid=""
 ;i $p(val,"^",2)'="" 

 
  s PLIST(2) = $p(val,"^",2)	;描述
  s Desc= $p(val,"^",2)
 i Desc="" q -9000
 s MICode=$p(val,"^",3)	//czf 2022-04-19 begin
 i MICode="" s MICode=##class(web.DHCEQCHanZiEncoding).GetEncoding(Desc,4,"","U")
 s PLIST(3) = $ZCONVERT(MICode,"U")	;代码
 s Code= $ZCONVERT(MICode,"U") //czf 2022-04-19 end
 s PLIST(4) = $p(val,"^",4) ;设备类别
 s PLIST(5) = $p(val,"^",5)	;设备分类
 s PLIST(6) = $p(val,"^",6)  //统计分类
 s PLIST(7) = $p(val,"^",7)  //备注
 s PLIST(8) = $p(val,"^",8)  //单位
 s PLIST(9) ="N"
 
 //add by jdl 2009-9-12 JDL0029
 //ForceInspectFlag
 s PLIST(10) ="N"
 if $p(val,"^",10)="true" s PLIST(10) ="Y"
 s PLIST(11) =$p(val,"^",11)	;Hold1
 s PLIST(12) =$p(val,"^",12)	;Hold2	
 s PLIST(13) ="N"  //add by zx 2016-06-15 维修设备项标志
 s PLIST(14) ="N"
 if $p(val,"^",13)="true" s PLIST(13) ="Y"
 if $p(val,"^",14)="true" s PLIST(14) ="Y"
 ;s PLIST(13) =$p(val,"^",13)	;Hold3
 ;s PLIST(14) =$p(val,"^",14)	;Hold4
 s PLIST(15) =$p(val,"^",15)	;Hold5
 s PLIST(21) =$p(val,"^",16)	;Hold6   //add by czf 1283059 单台计量费用
 
 ;Modified by JDL 2011-6-15 JDL0083
 s Rowid=""
 s HospitalFlag=##class(web.DHCEQCommon).GetSysInfo("990019")  
 i HospitalFlag'="1"
 {
 	&SQL(select MI_RowID into :Rowid from DHC_EQCMasterItem where MI_Desc=:Desc and MI_EquipTypeDR=:PLIST(4) and MI_InvalidFlag='N') // Modified 2014-9-17 HZY0064
 }
 else
 {
	 s Hospital=$p(val,"^",12)	;Hold2	 
	 i Hospital'=""
	 {
	 	&SQL(select MI_RowID into :Rowid from DHC_EQCMasterItem where MI_Desc=:Desc and MI_EquipTypeDR=:PLIST(4) and MI_HospitalDR=:Hospital and MI_InvalidFlag='N') // Modified 2014-9-17 HZY0064
	 }
	 else
	 {
		 &SQL(select MI_RowID into :Rowid from DHC_EQCMasterItem where MI_Code=:Code and MI_Desc=:Desc and MI_EquipTypeDR=:PLIST(4) and MI_HospitalDR is null and MI_InvalidFlag='N') // Modified 2014-9-17 HZY0064		 
	 }
 }
 
 if (Rowid="")
 {
 	i (rowid="")
 	{
	 	Set BussID="",OperateType="A"
		&SQL(Insert Into SQLUSER.DHC_EQCMasterItem Values :PLIST())
	} 
	else
	{
		Set BussID=rowid,OperateType="U"
		s OldObject=##Class(User.DHCEQCMasterItem).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		&SQL(Update SQLUSER.DHC_EQCMasterItem Values :PLIST() where MI_RowID = :rowid) 	 
	}
 }
 else
 {
	 q:rowid="" Rowid	//czf 2022-04-09
	 q:(rowid'="")&&(rowid'=Rowid) ""
	 Set BussID=rowid,OperateType="U"
	 s OldObject=##Class(User.DHCEQCMasterItem).%OpenId(BussID)
	 s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
	 &SQL(Update SQLUSER.DHC_EQCMasterItem Values :PLIST() where MI_RowID = :rowid)
 }
	If SQLCODE
 	{
	 	TRollback
	 	q SQLCODE
	}
	Set ID=$g(%ROWID)
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCMasterItem).%OpenId(ID))
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
 	//begin add by jyp 2019-09-02   设备属性相关调整
 	Set return=##Class(web.DHCEQ.EM.BUSEquipAttribute).SaveOpenCheckEquipAttribute(1,ID,EquipAttribute)
	if return
	{
		TROLLBACK
		Quit return
	}
	
	TCOMMIT
 //end add by jyp 2019-09-02    设备属性相关调整
 	q ID
 //begin add by jyp 2019-09-02    设备属性相关调整
ERROR
 	Set ErrorMsg=$ZE	          
 	TROLLBACK		       
 	Quit "<ERROR>"_ErrorMsg     
 	//end add by jyp 2019-09-02   设备属性相关调整
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCMasterItem",rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2) //代码
	s resultex=resultex_"^"	//2
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1) //描述
	s resultex=resultex_"^"	//4
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",3) //设备类别代码
	s resultex=resultex_"^"	//5
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",3))),"^",2) //设备类别
	s resultex=resultex_"^"	//6
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",4) //设备分类代码
	s resultex=resultex_"^"	//7
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",4))),"^",2) //设备分类
	s resultex=resultex_"^"	//8
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",5) //统计分类代码
	s resultex=resultex_"^"	//9
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",5))),"^",2) //统计分类
	s resultex=resultex_"^"	//10
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",6) //备注
	s resultex=resultex_"^"	//11
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7) //单位代码
	s resultex=resultex_"^"	//11
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",($p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7)))	;Modified By jdl 20150906 v4.1.0 规范单位取值
	
	//Mozy0110
	Set Hold1Code=""
	s Hold1=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",10)
	i Hold1'=""
	{
		s Hold1Code=$P($g(^DHCEQCCode("DHCEQCTree",Hold1)),"^",2)
		s Hold1=$P($g(^DHCEQCCode("DHCEQCTree",Hold1)),"^",3)
	}
	//Add by JDL 2011-6-14 JDL0083
	s Hold2=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",11)
	i Hold2'="" s Hold2=$P($g(^CT("HOSP",Hold2)),"^",2)
	s Hold3=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",12),"bool")	// Mozy	20161111
	s Hold4=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",13),"bool")
	s Hold6=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",20)	//czf 1283059
	s Hold7=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",21)	//czf 2021-07-19
	//s Hold7=##class(web.DHCEQCommon).TransValueToPage(Hold7,"bool")
	s Hold8=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",22)
	s StandardItem=""
	i Hold8'="" d
	.s StandardItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",Hold8)),"^",1)
	q resultex_"^"_$p(result,"^",9)_"^"_$p(result,"^",10)_"^"_$p(result,"^",11)_"^"_Hold3_"^"_Hold4_"^"_$p(result,"^",14)_"^"_Hold1_"^"_Hold2_"^"_Hold1Code_"^"_Hold6_"^"_Hold7_"^"_Hold8_"^"_StandardItem	//czf 2021-07-19
}

/// Mozy0145	20141017  新增参数AssetType
/// add by zx  2016-06-15 新增参数MaintFlag
/// w ##class(%Library.ResultSet).RunQuery("web.DHCEQCMasterItem","GetMasterItem","","","")
Query GetMasterItem(EquipTypeDR, StatCatDR, Name, AssetType As %Library.String = "", MaintFlag As %Library.String = "") As %Query(ROWSPEC = "Name:%String:名称,Hidden:%String,Code:%String:编码,Hidden:%String,Cat:%String:设备类型,Hidden:%String,Unit:%String:单位,Hidden:%String,EquipType:%String:类组,Hidden:%String,StatCat:%String:类型,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String")
{
}

ClassMethod GetMasterItemExecute(ByRef qHandle As %Binary, EquipTypeDR, StatCatDR, Name, AssetType As %Library.String = "", MaintFlag As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;Modified by JDL 2011-6-15 JDL0083
	s Hospital=##Class(web.DHCEQCommon).GetHospital()
	i Hospital'=""
	{
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hospital,TEquipTypeDR))  quit:TEquipTypeDR=""  d
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
		.;add by jdl 2010-3-17  JDL0048
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
		.
		.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hospital,TEquipTypeDR,rowid))  quit:rowid=""  d
		..d ResetVariablesGetItem
		..d BuildDataGetItem
	}
	else
	{
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR))  quit:TEquipTypeDR=""  d
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
		.;add by jdl 2010-3-17  JDL0048
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
		.
		.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR,rowid))  quit:rowid=""  d
		..d ResetVariablesGetItem
		..d BuildDataGetItem
	}
	
	Quit $$$OK
	
BuildDataGetItem
	s TRowID = rowid
	s TFlag = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",8)
	q:TFlag="Y"
	s TName = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1)
	s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2)
	q:(Name'="")&&(($ZCONVERT(TName ,"U")'[$ZCONVERT(Name,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Name,"U")))
	
	s TStatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",5)
	q:(StatCatDR'="")&&(TStatCatDR'="")&&(TStatCatDR'=StatCatDR)
	q:(TStatCatDR'="")&(+AssetType>0)&(AssetType'=$Piece(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",5))	/// Mozy0145	20141017
	i TStatCatDR'="" s TStatCat=$P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
	s TCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",4)
	i TCatDR'="" d
	.s TCat=$P(^DHCEQCCode("DHCEQCEquipeCat",TCatDR),"^",2)
	.s TLimitYearsNum=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TCatDR,TStatCatDR)	;Modified by jdl 2012-3-7 JDL0120
	.s TDepreMethodDR=##Class(web.DHCEQCEquipeCat).GetDepreMethodByCatID(TCatDR)
	.i TDepreMethodDR'="" d
	..s TDepreMethod=$p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7)
	i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	
	s THold2=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",11)
	i THold2'="" s THold2Desc=$P($g(^CT("HOSP",THold2)),"^",2)
	Quit:(##Class(web.DHCEQCommon).CheckManageLimit("","","",TEquipTypeDR,TStatCatDR,TCatDR,"","",rowid)) 
	q:(MaintFlag'="")&&($p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",12)'=MaintFlag) //add by zx  2016-06-15 维修时过滤
	q:(MaintFlag="")&&($p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",12)="Y") //add by zx  2016-06-15  验收时过滤
	d OutputRowGetItem
	quit
OutputRowGetItem
	s Data=$lb(TName,TRowID,TCode,TCatDR,TCat,TUnitDR,TUnit,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TDepreMethodDR,TDepreMethod,TLimitYearsNum,THold2,THold2Desc) //,ModelDR,ManageLocDR,UseLocDR,GroupDR,ManageUserDR,Model,ManageLoc,UseLoc,ManageUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetItem
	s (TName,TRowID,TCode,TCatDR,TCat,TUnitDR,TUnit,TStatCatDR,TStatCat,TDepreMethodDR,TDepreMethod,TLimitYearsNum,THold2,THold2Desc)=""
	quit
}

ClassMethod GetMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMasterItemExecute ]
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

ClassMethod GetMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add by jdl 2010-11-23 JDL0060
/// 根据设备项描述 来获取设备项及其相关信息
/// w ##Class(web.DHCEQCMasterItem).GetMasterInfoByDesc("pc机")
/// 增加入参EquipTypeID及过滤 modified by czf 1466713 2020-08-18
ClassMethod GetMasterInfoByDesc(ItemDesc, EquipTypeID As %String = "")
{
	n RowID,Result,ResultEx
	n DepreMethodDR
	
	i ItemDesc="" q ""
	s ItemDesc=$ZConvert(ItemDesc,"U")
	s ItemID=0
	s RowID=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Desc",ItemDesc,RowID))  quit:((RowID="")||(ItemID'=0))  d
	.q:$p($g(^DHCEQCCode("DHCEQCMasterItem",RowID)),"^",8)="Y"
	.q:(EquipTypeID'="")&&(EquipTypeID'=$p($g(^DHCEQCCode("DHCEQCMasterItem",RowID)),"^",3))
	.s ItemID=RowID
	if ItemID=0 q ""
	s Result=$g(^DHCEQCCode("DHCEQCMasterItem",ItemID))
	if Result="" q ""
	
	s ResultEx="^"
	;EquipTypeDR
	i $p(Result,"^",3)'="" s ResultEx=ResultEx_$P(^DHCEQCCode("DHCEQCEquipType",$p(Result,"^",3)),"^",2)
	s ResultEx=ResultEx_"^"
	;EquiCatDR
	i $p(Result,"^",4)'=""  s ResultEx=ResultEx_$P(^DHCEQCCode("DHCEQCEquipeCat",$p(Result,"^",4)),"^",2)
	
	s ResultEx=ResultEx_"^"
	;StatCatDR
	i $p(Result,"^",5)'=""  s ResultEx=ResultEx_$P(^DHCEQCCode("DHCEQCStatCat",$p(Result,"^",5)),"^",2)
	s ResultEx=ResultEx_"^"
	;UnitDR
	i $p(Result,"^",7)'=""  s ResultEx=ResultEx_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(Result,"^",7))
	
	;Hold1 辅助分类树
	s ResultEx=ResultEx_"^"
	i $p(Result,"^",10)'=""  s ResultEx=ResultEx_$P($g(^DHCEQCCode("DHCEQCTree",$p(Result,"^",10))),"^",3)
	
	;EquiCatDR
	i $p(Result,"^",4)'=""  d
	.;LimitYearsNum
	.s ResultEx=ResultEx_"^"_##Class(web.DHCEQCEquipeCat).GetYearsByCatID($p(Result,"^",4),$p(Result,"^",5))	;Modified by jdl 2012-3-7 JDL0120
	.;DepreMethodDR
	.s DepreMethodDR=##Class(web.DHCEQCEquipeCat).GetDepreMethodByCatID($p(Result,"^",4))
	.s ResultEx=ResultEx_"^"_DepreMethodDR
	.s ResultEx=ResultEx_"^"
	.i DepreMethodDR'="" s ResultEx=ResultEx_$p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",2)
	e  d
	.s ResultEx=ResultEx_"^^^"
	
	s ResultEx=ResultEx_"^"_ItemID
	
	q Result_ResultEx
}

/// Add By HZY 2011-07-27  HZY0003
/// 获取医院的信息
/// 增加序号TRow的输出  add by sjh 2019-10-21
Query GetHospital(GroupCode As %Library.String = "") As %Query(ROWSPEC = "THospital:%String,TID:%String,TRow:%String")
{
}

// {%row} =  ^CT("HOSP",{HOSP_RowId})

ClassMethod GetHospitalExecute(ByRef qHandle As %Binary, GroupCode As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetHospital
	Quit $$$OK
BuildDataGetHospital	
	s TID=0
	s TRow=1 //设置 TID为0时的序号为1 add by sjh 2019-10-21
	s THospital="无医院项"
	d OutputRowGetHospital

	f  s rowid=$o( ^CT("HOSP",rowid)) q:rowid=""  d
	.d ResetVariablesGetHospital
	.s TRow=index //设置索引值为序号值 add by sjh 2019-10-21
	.s Code=$p($g( ^CT("HOSP",rowid)),"^",1)
	.q:(GroupCode'="")&&(Code'=GroupCode)
	.s InvalidFlag=$p($g( ^CT("HOSP",rowid)),"^",4)
	.q:InvalidFlag="Y"
	.s TID=rowid
	.s THospital=$p($g( ^CT("HOSP",rowid)),"^",2)
	.d OutputRowGetHospital
	quit
OutputRowGetHospital
	s Data=$lb(THospital,TID,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetHospital
	s (THospital,TID,TRow)=""
	quit
}

ClassMethod GetHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospitalExecute ]
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

ClassMethod GetHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospitalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By jyp 2019-09-02  设备属性相关调整
/// 描述:生成类方法JSON统一返回值格式,用于在组件界面上给关键字列表取设备属性的关键字选择按钮
/// 入参:vSQLCODE 错误代码
/// 		vData 错误信息
/// 返回值:JSON格式串{"SQLCODE":错误代码,"Data":错误信息}
ClassMethod ReturnJsonEquipAttribute()
{
	//s ReturnInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetNewJSONObj()  // modify by jyp 2019-08-26
	s ReturnInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s ReturnData="["
	s GroupID=%session.Get("LOGON.GROUPID")  //add by lmm 2020-05-07
	s EquipAttributeList=##class(web.DHCEQCommon).GetSysInfo("990065")
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCEquipAttribute",rowid)) quit:rowid=""  d
	.q:($p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",5)="Y")
	.s EALGroup = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",3)
	.q:((","_EquipAttributeList_",")'[(","_EALGroup_","))
	.//add by lmm 2020-05-07 begin
	.s TRowID=""
	.i $D(^DHCEQCCode("DHCEQCGroupEquipAttribute",0,"Group",GroupID,rowid))  d
	..s TRowID=$o(^DHCEQCCode("DHCEQCGroupEquipAttribute",0,"Group",GroupID,rowid,0))
	.i TRowID="" d
	..s TEditFlag="N"
	.e  d
	..s TEditFlag=$p($g(^DHCEQCCode("DHCEQCGroupEquipAttribute",TRowID)),"^",3) 
	.q:(TEditFlag="N")
	.//add by lmm 2020-05-07 end	
	.s EALName = $p($g(^DHCEQCCode("DHCEQCEquipAttribute",rowid)),"^",2)
	.if ReturnData'="["  d
	..s ReturnData=ReturnData_","
	.s ReturnData=ReturnData_"{text:'"_EALName_"',id:'id"_rowid_"'}"
	s ReturnData=ReturnData_"]"
	d ReturnInfo.%Set("Data",ReturnData)
	q ReturnInfo.%ToJSON()
}

/// Add By czf 2022-04-12  设备属性分类相关调整
/// 描述:生成类方法JSON统一返回值格式,用于在组件界面上给关键字列表取设备属性的关键字选择按钮
/// 入参:vSQLCODE 错误代码
/// 		vData 错误信息
/// 返回值:JSON格式串{"SQLCODE":错误代码,"Data":错误信息}
/// w ##class(web.DHCEQCMasterItem).GetEquipAttributeCat("22")
ClassMethod GetEquipAttributeCat(Type As %String = "")
{
	i Type="" q "{""Data"":""[]""}"
	s ReturnInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s ReturnData="["
	
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCInHospitalType",rowid)) quit:rowid=""  d
	.q:($p($g(^DHCEQCCode("DHCEQCInHospitalType",rowid)),"^",4)="Y")
	.q:(Type'="")&&(Type'=$p($g(^DHCEQCCode("DHCEQCInHospitalType",rowid)),"^",3))	
	.s TDesc = $p($g(^DHCEQCCode("DHCEQCInHospitalType",rowid)),"^",2)
	.if ReturnData'="["  d
	..s ReturnData=ReturnData_","
	.s ReturnData=ReturnData_"{text:'"_TDesc_"',id:'id"_rowid_"'}"
	s ReturnData=ReturnData_"]"
	d ReturnInfo.%Set("Data",ReturnData)
	q ReturnInfo.%ToJSON()
}

}
