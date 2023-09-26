/// 存放地点表
/// Mozy0034	2010-11-22
/// ^DHCEQCCode("DHCEQCLocation",{L_RowID})
Class web.DHCEQCLocation Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modiied by ZY 2015-4-27 ZY0125
/// d ##class(%ResultSet).RunQuery("web.DHCEQCLocation","GetLocationDetails","","","","")
/// modify by lmm 2021-06-25 表结构修改相关代码修改
/// modified by myl 20211209  2170831
Query GetLocationDetails(Code As %String = "", Desc As %String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "", HospitalDR As %Library.String = "", LocDR As %Library.String = "", Hospital As %Library.String = "", Loc As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TType:%String,THospitalDR:%String,THospital:%String,TLocDR:%String,TLoc:%String,TBuildingDR:%String,TBuildName:%String,TBuildingUnitDR:%String,TBuildingUnitName:%String,TPlace:%String,TDateActiveFrom:%String,TDateActiveTo:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod GetLocationDetailsExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "", HospitalDR As %Library.String = "", LocDR As %Library.String = "", Hospital As %Library.String = "", Loc As %Library.String = "") As %Status
{
	;new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	;获取院区Id(多院区) CZF0138
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
	
	;Mozy0206	20180605	优化存放地点查询条件
	Set TRow=1
	Set Code=$ZCONVERT(Code,"U")
	Set Desc=$ZCONVERT(Desc,"U")
	Set rowid=0
	Do BuildDataGetLocationDetails
	Quit $$$OK
BuildDataGetLocationDetails
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCLocation",rowid))  Quit:rowid=""  Do
	.;当前登录人是否有权限查看表数据 CZF0138
	.q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCLocation",rowid,sHospID)'="Y"
	.Do ResetVariablesGetLocationDetails
	.Set TRowID = rowid
	.Set InvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",11)
	.Quit:InvalidFlag="Y"
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",1)
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",2)
	.Quit:(Code'="")&&($ZCONVERT(TCode,"U")'[Code)&&($ZCONVERT(TDesc,"U")'[Code)
	.Quit:(Desc'="")&&($ZCONVERT(TCode,"U")'[Desc)&&($ZCONVERT(TDesc,"U")'[Desc)
	.Set TType=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",3)
	.Set THospitalDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",4)
	.Quit:(HospitalDR'="")&&(HospitalDR'=THospitalDR)
	.if THospitalDR'="" set THospital=$p($g(^CT("HOSP",THospitalDR)),"^",2)
	.Set TLocDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",5)
    .Quit:(LocDR'="")&&(LocDR'=TLocDR)
	.Set TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.Set TBuildingDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",6) 
	.If TBuildingDR'="" Set TBuildName=$Piece($Get(^DHCEQBuilding(TBuildingDR)),"^",21)  
	.Set TBuildingUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",7)
	.If TBuildingUnitDR'="" Set TBuildingUnitName=$Piece($Get(^DHCEQBuildingUnit(TBuildingUnitDR)),"^",3)  
	.Set TPlace=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",8)
	.Set TDateActiveFrom=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",9)
	.If TDateActiveFrom'="" Set TDateActiveFrom=##class(web.DHCEQCommon).TransValueToPage(TDateActiveFrom,"date")
	.Set TDateActiveTo=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",10)
	.If TDateActiveTo'="" Set TDateActiveTo=##class(web.DHCEQCommon).TransValueToPage(TDateActiveTo,"date")
	.Set TRemark=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",12)
	.Set THold1=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",13)	;hold1
	.Set THold2=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",14)	;hold2
	.Set THold3=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",15)	;hold3
	.Set THold4=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",16)	;hold4
	.Set THold5=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",17)	;hold5
	.
	.Do OutputRowGetLocationDetails
	Quit
OutputRowGetLocationDetails
	Set Data=$lb(TRowID,TCode,TDesc,TType,THospitalDR,THospital,TLocDR,TLoc,TBuildingDR,TBuildName,TBuildingUnitDR,TBuildingUnitName,TPlace,TDateActiveFrom,TDateActiveTo,TRemark,THold1,THold2,THold3,THold4,THold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	Quit
ResetVariablesGetLocationDetails
	Set (TRowID,TCode,TDesc,TType,THospitalDR,THospital,TLocDR,TLoc,TBuildingDR,TBuildName,TBuildingUnitDR,TBuildingUnitName,TPlace,TDateActiveFrom,TDateActiveTo,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	Quit
}

ClassMethod GetLocationDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocationDetailsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLocationDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocationDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCEQCLocation).SaveData("","","^1^2^^^^^^^^^^^^^^^^","0")
/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录
/// modify by lmm 2021-06-25 表结构修改相关代码修改
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "")
{
	Kill PLIST,rowid
 	Set rowid=$Piece(val,"^",1)
  	s $zt="ErrorSave"
 	s TableName="DHC_EQCLocation"
 	s ClassName="User.DHCEQCLocation"
 	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
 	s BussID=rowid	
 	s DCRRowID=""
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
 	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()
 	
 	;获取院区Id(多院区) CZF0138
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
	
 	TSTART	
 	
 	If (+isDel=1)
 	{
		s OldObject=##Class(User.DHCEQCLocation).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

 		Set PLIST(12)="Y"
 		&SQL(Update SQLUSER.DHC_EQCLocation Values :PLIST() where L_RowID = :rowid)

	 	If SQLCODE
	 	{
		 	TRollback
		 	q SQLCODE
		}
		
		/*
		;删除医院对照关系 CZF0138
		s RtnCode=##class(web.DHCEQ.Util.BDPCommonUtil).DeleteHospitals("DHC_EQCLocation",rowid,sHospID)
		if RtnCode<0
		{
			TROLLBACK
			q RtnCode
		}
		*/
		
		;保存数据日志
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""LInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
		TCommit
	 	Quit rowid
 	}
 	
 	Set PLIST(2) = $Piece(val,"^",2)		;代码
  	Set Code= $Piece(val,"^",2)
 	Set PLIST(3) = $Piece(val,"^",3)		;描述
 	Set Desc= $Piece(val,"^",3)
 	Set PLIST(4) = $Piece(val,"^",4) 		;类别
	Set PLIST(5) = $Piece(val,"^",5)		;医院
	i PLIST(5)="" s PLIST(5) = sHospID		;czf 20210702 保存默认院区ID
 	Set PLIST(6) = $Piece(val,"^",6)  		;科室
 	Set PLIST(7) = $Piece(val,"^",7)  		;建筑
 	Set PLIST(8) = $Piece(val,"^",8)  		;房屋
 	Set PLIST(9) = $Piece(val,"^",9)		;详细地点
 	Set PLIST(10) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",10),"date")		;有效开始日期
 	Set PLIST(11) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",11),"date")		;截止日期
 	Set PLIST(12) = "N"						;无效标志
 	Set PLIST(13) = $Piece(val,"^",12)		;备注
 	
 	Set PLIST(14) = $Piece(val,"^",13)		;Hold1
 	Set PLIST(15) = $Piece(val,"^",14)		;Hold2
 	Set PLIST(16) = $Piece(val,"^",15)		;Hold3
 	Set PLIST(17) = $Piece(val,"^",16)		;Hold4
 	Set PLIST(18) = $Piece(val,"^",17)		;Hold5
 
 	//&SQL(select L_RowID into :Rowid from SQLUSER.DHC_EQCLocation where L_Code=:Code and L_Desc=:Desc and L_InvalidFlag = 'N')
 	;判断数据是否重复 CZF0138
	s RtnInfo=##class(web.DHCEQ.Util.BDPCommonUtil).CodeDescIsRepeat("DHC_EQCLocation",rowid,Code_"^"_Desc_"^"_PLIST(6)_"^"_PLIST(7)_"^"_PLIST(8),PLIST(5))		//增加科室、建筑、房屋唯一性判断
	s Rowid=$p(RtnInfo,"$",1)
 	If (Rowid="")
 	{
 		If (rowid="")
 		{
	 		s PLIST(15) ="N"
	 		Set BussID="",OperateType="A"
			&SQL(Insert Into SQLUSER.DHC_EQCLocation Values :PLIST())
		} 
		Else
		{
			Set BussID=rowid,OperateType="U"
			s OldObject=##Class(User.DHCEQCLocation).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			&SQL(Update SQLUSER.DHC_EQCLocation Values :PLIST() where L_RowID = :rowid)
		}
 	}
 	Else
 	{
	 	Quit:rowid="" ""
	 	Quit:(rowid'="")&&(rowid'=Rowid) ""
	 	Set BussID=rowid,OperateType="U"
		s OldObject=##Class(User.DHCEQCLocation).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
	 	&SQL(Update SQLUSER.DHC_EQCLocation Values :PLIST() where L_RowID = :rowid)
 	}
	If SQLCODE
 	{
	 	TRollback
	 	q SQLCODE
	}
	Set ID=$g(%ROWID)
	
	;保存医院对照关系 CZF0138
	s RtnCode=##class(web.DHCEQ.Util.BDPCommonUtil).SaveHOSP("DHC_EQCLocation",ID,sHospID)
    if RtnCode<0
	{
		TROLLBACK
		q RtnCode
	}
	
	;数据日志更新
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCLocation).%OpenId(ID))
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

/// modify by lmm 2021-06-25 表结构修改相关代码修改
/// w ##class(web.DHCEQCLocation).GetDocByID("","",2)
ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	Set (result,resultex)=""
	Set result= ^DHCEQCCode("DHCEQCLocation",rowid)
	Set result=result   	//0
	Set resultex=resultex_"^"	//医院
	If $Piece(result,"^",4)'="" Do
	.;Set resultex=resultex_$Piece($Get(^CTLOC($Piece(result,"^",6))),"^",2)   //modify by jyp 2019-10-18 CTLOC调整
	.Set resultex=resultex_$p($g(^CT("HOSP",$Piece(result,"^",4))),"^",2)
	Set resultex=resultex_"^"	//科室
	If $Piece(result,"^",5)'="" Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$Piece(result,"^",5))
	Set resultex=resultex_"^"	//建筑物
	If $Piece(result,"^",6)'="" Do
	.Set resultex=resultex_$Piece($Get(^DHCEQBuilding($Piece(result,"^",6))),"^",21)  
	Set resultex=resultex_"^"	//建筑单元
	If $Piece(result,"^",7)'="" Do
	.Set resultex=resultex_$Piece($Get(^DHCEQBuildingUnit($Piece(result,"^",7))),"^",3)  
	Set $Piece(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",9),"date")
	Set $Piece(result,"^",10)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",10),"date")
	Quit rowid_"^"_result_resultex
}

/// modiied by ZY0303 20220614 2709459
/// d ##class(%ResultSet).RunQuery("web.DHCEQCLocation","GetShortLocation","")
Query GetShortLocation(Desc As %String = "", HospitalDR As %String = "", LocDR As %String = "") As %Query(ROWSPEC = "Hidden:%String,TCode:%String:编码,TDesc:%String:描述,Hidden:%String,Hidden:%String,THospital:%String:医院,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String")
{
}

ClassMethod GetShortLocationExecute(ByRef qHandle As %Binary, Desc As %String = "", HospitalDR As %String = "", LocDR As %String = "") As %Status
{
	;new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	Set Desc=$ZCONVERT(Desc,"U")
	;获取院区Id(多院区) CZF0138
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId("","")
	
	Do BuildDataGetShortLocation
	Quit $$$OK
BuildDataGetShortLocation
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCLocation",rowid))  Quit:rowid=""  Do
	.;当前登录人是否有权限查看表数据 CZF0138
	.q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCLocation",rowid,sHospID)'="Y"
	.Do ResetVariablesGetShortLocation
	.Set TRowID = rowid
	.Set InvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",11)  //Modified By QW20211112 BUG:QW0155
	.Quit:InvalidFlag="Y"
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",1)
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",2)
	.Quit:(Desc'="")&&(TDesc'[Desc)&&(TCode'[Desc)
	.Set TType=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",3)
	.Set THospitalDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",4)
	.Quit:(HospitalDR'="")&&(THospitalDR'=HospitalDR)
	.if THospitalDR'="" set THospital=$p($g(^CT("HOSP",THospitalDR)),"^",2)
	.Set TLocDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",5)
	.Quit:(LocDR'="")&&(TLocDR'=LocDR)
	.Set TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.Set TBuildingDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",6) 
	.If TBuildingDR'="" Set TBuildName=$Piece($Get(^DHCEQBuilding(TBuildingDR)),"^",21)  
	.Set TBuildingUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",7)
	.If TBuildingUnitDR'="" Set TBuildingUnitName=$Piece($Get(^DHCEQBuildingUnit(TBuildingUnitDR)),"^",3)  
	.Set TPlace=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",8)
	.Set TDateActiveFrom=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",9)
	.If TDateActiveFrom'="" Set TDateActiveFrom=##class(web.DHCEQCommon).TransValueToPage(TDateActiveFrom,"date")
	.Set TDateActiveTo=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",10)
	.If TDateActiveTo'="" Set TDateActiveTo=##class(web.DHCEQCommon).TransValueToPage(TDateActiveTo,"date")
	.Set TRemark=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",12)
	.Set THold1=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",13)	;hold1
	.Set THold2=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",14)	;hold2
	.Set THold3=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",15)	;hold3
	.Set THold4=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",16)	;hold4
	.Set THold5=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",17)	;hold5	
	.
	.Do OutputRowGetShortLocation
	Quit
OutputRowGetShortLocation
	Set Data=$lb(TRowID,TCode,TDesc,TType,THospitalDR,THospital,TLocDR,TLoc,TBuildingDR,TBuildName,TBuildingUnitDR,TBuildingUnitName,TPlace,TDateActiveFrom,TDateActiveTo,TRemark,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetShortLocation
	Set (TRowID,TCode,TDesc,TType,THospitalDR,THospital,TLocDR,TLoc,TBuildingDR,TBuildName,TBuildingUnitDR,TBuildingUnitName,TPlace,TDateActiveFrom,TDateActiveTo,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	Quit
}

ClassMethod GetShortLocationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShortLocationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetShortLocationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShortLocationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 目的:系统自动录入存放地点
/// 描述:检测存放地点表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// 输入: data:存放地点
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
/// w ##Class(web.DHCEQCLocation).UpdLocation("mzl605^门诊楼605")
ClassMethod UpdLocation(data)
{
	Set lrowid=""
	s code=##class(web.DHCEQCommon).Trim($ZCONVERT($p(data,"^",1),"U"))
	s desc=##class(web.DHCEQCommon).Trim($ZCONVERT($p(data,"^",2),"U")) //modified by wy 除去字符串中的空格 2020-3-31需求1249905
	i code="" s code=##class(web.DHCEQCHanZiEncoding).GetEncoding(desc,4,"","U")
	
	Set SQLCODE=0
	Set GetLocationOperMethod=##class(web.DHCEQCommon).GetSysInfo("201008")
	If (GetLocationOperMethod=0)||(desc="") Quit ""
	s sHospID = ##Class(web.DHCEQ.Util.BDPCommonUtil).GetCurrentSYSHospitalId()	//czf 2021-09-01
	
	&SQL(Select L_RowID Into :lrowid from SQLUSER.DHC_EQCLocation Where L_InvalidFlag='N' and L_Desc=:desc and L_HospitalDR=:sHospID)
	if lrowid=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQCLocation(L_Code,L_Desc,L_InvalidFlag,L_HospitalDR) Values(:code,:desc,'N',:sHospID))
		if SQLCODE
		{
			Quit SQLCODE
		}
		Set lrowid=$Get(%ROWID)
		;保存医院对照关系 CZF 2021-09-01
		s RtnCode=##class(web.DHCEQ.Util.BDPCommonUtil).SaveHOSP("DHC_EQCLocation",lrowid,sHospID)
		i RtnCode<0
		{
			quit RtnCode
		}
	}
	Quit lrowid
}

}
