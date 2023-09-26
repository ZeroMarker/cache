Class web.DHCEQ.Plat.CTLocType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建:ZY  2009-07-06   BugNo.：ZY0004
/// 描述：显示科室信息，通过参数ID、LocDR、FromDate、ToDate提供查询
/// 输入：参数ID、LocDR、FromDate、ToDate
/// 输出：科室信息
/// 返回：返回科室信息明细
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTLocType","LocType")
Query LocType(ID As %String = "", LocDR As %String = "", FromDate, ToDate) As %Query(ROWSPEC = "TRowID:%String,TType:%String,TLocDR:%String,TFromDate:%String,TToDate:%String,TRemark:%String,TRow:%String")
{
}

ClassMethod LocTypeExecute(ByRef qHandle As %Binary, ID As %String = "", LocDR As %String = "", FromDate, ToDate) As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataLocType
	Quit $$$OK
BuildDataLocType
	q:ID=""
	f  s rowid=$o(^DHCEQCCode("DHCEQCLocType",rowid))  quit:rowid=""  d
	.d ResetVariablesLocType  
	.s TRowID = rowid	                                            //rowid
	.s TType = $p($g(^DHCEQCCode("DHCEQCLocType",rowid)),"^",1)	    //类型
	.q:ID'=TType
	.s TLocDR = $p($g(^DHCEQCCode("DHCEQCLocType",rowid)),"^",2)	//科室id
	.q:((LocDR'="")&&(TLocDR'=LocDR))	//modify by mwz 2017-06-19
	.s TLocDR = $p($g(^DHCEQCCode("DHCEQCDepartment",TLocDR)),"^",2)
	.q:TLocDR=""     //modified by czf 411632
	.s TFromDate=$p($g(^DHCEQCCode("DHCEQCLocType",rowid)),"^",3)  //开始时间
	.s TToDate=$p($g(^DHCEQCCode("DHCEQCLocType",rowid)),"^",4)    //结束时间
	.q:(FromDate'="")&&(+TFromDate<+FromDate)
	.q:(ToDate'="")&&((+TToDate>+ToDate)||(TToDate=""))
	.s TFromDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCLocType",rowid)),"^",3),"date")	//开始时间输出格式转换
	.s TToDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCLocType",rowid)),"^",4),"date")	//结束时间输出格式转换
	.s TRemark= $p($g(^DHCEQCCode("DHCEQCLocType",rowid)),"^",5)	//备注
	.d OutputRowLocType
	quit
OutputRowLocType
	s Data=$lb(TRowID,TType,TLocDR,TFromDate,TToDate,TRemark,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesLocType
	s (TRowID,TType,TLocDR,TFromDate,TToDate,TRemark)=""
	quit
}

ClassMethod LocTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocTypeExecute ]
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

ClassMethod LocTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 创建:ZY  2009-07-06   BugNo.：ZY0004
/// 描述：科室类型列表
/// 返回：返回科室类型列表
/// add by wy  2017-06-19 添加列表序号
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTLocType","GetLocType")
Query GetLocType(GroupCode As %Library.String = "") As %Query(ROWSPEC = "TLocType:%String,TID:%String,TRow:%String")
{
}

ClassMethod GetLocTypeExecute(ByRef qHandle As %Binary, GroupCode As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s TRow=0
	d BuildDataGetLocType
	Quit $$$OK
BuildDataGetLocType	
	f  s rowid=$o(^DHCEQCCode("DHCEQCLocGroup",rowid)) q:rowid=""  d
	.s Code=$p($g(^DHCEQCCode("DHCEQCLocGroup",rowid)),"^",1)
	.q:(GroupCode'="")&&(Code'=GroupCode)
	.s Hidden=$p($g(^DHCEQCCode("DHCEQCLocGroup",rowid)),"^",5)
	.q:Hidden="Y"
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCLocGroup",rowid)),"^",7)
	.q:InvalidFlag="Y"
	.s LGTCode=0
	.f  s LGTCode=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",rowid,LGTCode)) q:LGTCode=""  d
	..s LGTRowID=0
	..f  s LGTRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",rowid,LGTCode,LGTRowID)) q:LGTRowID=""  d
	...d ResetVariablesGetLocType
	...s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCLocGroupType",LGTRowID)),"^",5)
	...q:InvalidFlag="Y"
	...s TLocType=$p($g(^DHCEQCCode("DHCEQCLocGroupType",LGTRowID)),"^",3)
	...s TID=LGTRowID
	...d OutputRowGetLocType
	quit
OutputRowGetLocType
    s TRow=TRow+1
	s Data=$lb(TLocType,TID,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetLocType
	s (TLocType,TID)=""
	quit
}

ClassMethod GetLocTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocTypeExecute ]
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

ClassMethod GetLocTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创建:ZY  2009-07-06   BugNo.：ZY0004
/// 描述：根据参数status对科室类型进行解析
/// 输入：科室类型status
/// 输出：解析的结果
/// 返回：成功返回科室类型
ClassMethod GetLocTypeDisplay(status As %Library.String) As %Status
{
	i status=""  q ""
	i +status=0  q "科室"
	i +status=1  q "库房"
	q "未定义"
}

/// 创建:ZY  2009-07-06   BugNo.：ZY0004
/// 描述：根据参数isDel对信息进行添加、修改删除操作
/// 访问表:DHC_EQCLocType
/// 输入：提交的数据val、列表信息rowid
/// 输出：无
/// 返回：成功返回空，否则返回出错信息
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
		
	 k PLIST,rowid
	 s rowid=$p(val,"^",1)
	 if (+isDel=1)
	 {
	 	&SQL(Delete From SQLUser.DHC_EQCLocType where LT_RowID = :rowid)
	 	if SQLCODE  q SQLCODE
 		q rowid
	 } 
	 s PLIST(2) = $p(val,"^",2)	;类型
	 s LocType= $p(val,"^",2)
	 s PLIST(3) = $p(val,"^",3)	;科室id
	 s LocDR=$p(val,"^",3)
	 s PLIST(4) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"date")  ;开始时间
	 s PLIST(5) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date")  ;结束时间
	 s PLIST(6) = $p(val,"^",6)	;备注
	 //检测是否重复
	 s LGDR=$p($g(^DHCEQCCode("DHCEQCLocGroupType",LocType)),"^",1)
	 s UniqueFlag=$p($g(^DHCEQCCode("DHCEQCLocGroup",LGDR)),"^",4)
	 s Find=0
	 i UniqueFlag="Y"  d
	 .s LGTCode=0
	 .f  s LGTCode=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",LGDR,LGTCode)) q:(LGTCode="")||(Find'=0)  d
	 ..s LGTRowID=0
	 ..f  s LGTRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",LGDR,LGTCode,LGTRowID)) q:(LGTRowID="")||(Find'=0)  d
	 ...s Find=+$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTRowID,LocDR,0))
	 ...s LGTDesc=$p($g(^DHCEQCCode("DHCEQCLocGroupType",LGTRowID)),"^",3)
	 e  d
	 .s Find=+$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType,LocDR,0))
	 .s LGTDesc=$p($g(^DHCEQCCode("DHCEQCLocGroupType",LocType)),"^",3)
	 i (Find'=0)&&(Find'=rowid) q "^"_LGTDesc
	 i (rowid="") //新增记录
	 {
		 &SQL(Insert Into SQLUSER.DHC_EQCLocType Values :PLIST())
	 }
	 else  //更新按钮操作
	 {
		 &SQL(Update SQLUSER.DHC_EQCLocType Values :PLIST() where LT_RowID = :rowid)
	 }
	 if SQLCODE  q SQLCODE
	 Set ID=$g(%ROWID)
	 q ID
}

/// 创建:ZY  2009-07-06   BugNo.：ZY0004
/// 描述：根据rowid获取科室类型的信息
/// 访问表:DHC_EQCLocType
/// 输入：列表信息rowid
/// 返回：成功返回一条科室类型信息
/// 备注：
/// w ##Class(web.DHCEQ.Plat.CTLocType).GetLocTypeByID( , ,rowid)
ClassMethod GetLocTypeByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCLocType",rowid)
	s resultex=rowid
	s resultex=resultex_"^"_$p(result,"^",1)	//科室类型
	s resultex=resultex_"^"_$p($g(^DHCEQCCode("DHCEQCDepartment",$p(result,"^",2))),"^",2) //科室
	s resultex=resultex_"^"_$p(result,"^",2) //科室id
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",3),"date")	//开始时间
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCLocType",rowid)),"^",4),"date") //结束时间
	s resultex=resultex_"^"_$p($g(^DHCEQCCode("DHCEQCLocType",rowid)),"^",5) //备注
	q resultex
}

/// 新增:DJ 2010-07-01
/// 描述:判断当前科室的职能,正常则返回RowID,否则返回空
ClassMethod GetLocGroupType(GroupDR, TypeDR, LocDR)
{
	s Find=0
	s UniqueFlag=$p($g(^DHCEQCCode("DHCEQCLocGroup",GroupDR)),"^",4)
	i UniqueFlag="Y"  d ;该组唯一标识
	.s LGTCode=0
	.f  s LGTCode=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",GroupDR,LGTCode)) q:(LGTCode="")||(Find'=0)  d
	..s LGTRowID=0
	..f  s LGTRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",GroupDR,LGTCode,LGTRowID)) q:(LGTRowID="")||(Find'=0)  d
	...s Find=+$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTRowID,LocDR,0))
	e  d
	.s Find=+$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",TypeDR,LocDR,0))
	i Find=0 q ""
	q Find
}

/// hisui 改造 add by wy
/// 2017-2-7	Mozy	增加租赁中心设置
/// 20140723  Mozy0136
/// AllLocFlag:全部科室		UnCheckFlag:未匹配标志
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTLocType","EQLocDetail","0","Y")
Query EQLocDetail(QXType As %String = "", AllLocFlag As %String = "", Loc As %String = "", Hospital As %String = "", GroupIDOne As %String = "", GroupIDTwo As %String = "", GroupIDThree As %String = "", UnCheckFlag As %String = "") As %Query(ROWSPEC = "TLocDR:%String,TLocDesc:%String,THospital:%String,Title1:%String,Title2:%String,Title3:%String,TRow:%String,TLocCode:%String,TRemark:%String,TManageUser:%String,TLocation:%String,TTel:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod EQLocDetailExecute(ByRef qHandle As %Binary, QXType As %String = "", AllLocFlag As %String = "", Loc As %String = "", Hospital As %String = "", GroupIDOne As %String = "", GroupIDTwo As %String = "", GroupIDThree As %String = "", UnCheckFlag As %String = "") As %Status
{
	new repid, index, rowid, Flag
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	Set index=1
 	s TRow=1
	Kill ^DHCEQTemp("LocDetail",User)
	Set Loc=##class(web.DHCEQCommon).UnEscape(Loc)
	Set Loc=$ZCONVERT(Loc,"U")
	Set Hospital=##class(web.DHCEQCommon).UnEscape(Hospital)
	Set Hospital=$ZCONVERT(Hospital,"U")
	;按科室头字母进行排序
	If (AllLocFlag="")||(AllLocFlag="N")
	{
		;判断该科室设备的类组是在当前安全组访问权限内
		Set StoreLocDR=0
		For  Set StoreLocDR=$Order(^DHCEQEquip(0,"StoreLocStatCat",StoreLocDR)) Quit:(StoreLocDR="")  Do
		.Quit:$Piece($Get(^DHCEQCCode("DHCEQCDepartment",StoreLocDR)),"^",13)'="Y"	// Mozy		1057066		2019-10-26
		.Quit:$Piece($Get(^DHCEQCCode("DHCEQCDepartment",StoreLocDR)),"^",19)'="N"	// Mozy		1057066		2019-10-26
		.Quit:(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocDR))
		.Set Flag=0
		.Set EquipTypeDR=0
		.For  Set EquipTypeDR=$Order(^DHCEQEquip(0,"StoreLocStatCat",StoreLocDR,EquipTypeDR)) Quit:(EquipTypeDR="")||(Flag'=0)  Do
		..Quit:(##class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR))
		..Set Flag=1
		.Quit:Flag=0
		.Set Desc=$Piece($Get(^DHCEQCCode("DHCEQCDepartment",StoreLocDR)),"^",2)
		.Set Desc=$ZCONVERT(Desc,"U")
		.q:Desc=""    					;add by kdf 2018-02-08
		.Quit:(Loc'="")&(Desc'[Loc)
		.Set ^DHCEQTemp("LocDetail",User,Desc)=StoreLocDR
	}
	Else
	{
		Set StoreLocDR=0
		For  Set StoreLocDR=$Order(^DHCEQCCode("DHCEQCDepartment",StoreLocDR)) Quit:(StoreLocDR="")  Do
		.Quit:$Piece($Get(^DHCEQCCode("DHCEQCDepartment",StoreLocDR)),"^",13)'="Y"	// Mozy		1057066		2019-10-26
		.Quit:$Piece($Get(^DHCEQCCode("DHCEQCDepartment",StoreLocDR)),"^",19)'="N"	// Mozy		1057066		2019-10-26
		.Set Desc=$Piece($Get(^DHCEQCCode("DHCEQCDepartment",StoreLocDR)),"^",2)
		.Set Desc=$ZCONVERT(Desc,"U")
		.Set Code=$Piece($Get(^DHCEQCCode("DHCEQCDepartment",StoreLocDR)),"^",1)  // add by yh 2019-10-28
		.Set Code=$ZCONVERT(Code,"U") // add by yh 2019-10-28
		.Quit:(Loc'="")&(Desc'[Loc)
		.Set ^DHCEQTemp("LocDetail",User,Code)=StoreLocDR //Modify by yh 2019-10-28
	}
	
	Set Code="" //Modify by yh 2019-10-28
	For  Set Code=$Order(^DHCEQTemp("LocDetail",User,Code)) Quit:(Code="")  Do	//Modify by yh 2019-10-28	
	.Do ResetVariablesDataForEQLocDetail
	.Set TLocDR=$Get(^DHCEQTemp("LocDetail",User,Code))	//Modify by yh 2019-10-28
	.Set TLocDesc=$Piece($Get(^DHCEQCCode("DHCEQCDepartment",TLocDR)),"^",2)	////Modify by yh	 2019-10-28
	.Set THospital=$Piece($Get(^DHCEQCCode("DHCEQCDepartment",TLocDR)),"^",8)
	.If THospital'="" Set THospital=$Piece($Get(^CT("HOSP",THospital)),"^",2)
	.Set THospital=$ZCONVERT(THospital,"U")
	.Quit:(Hospital'="")&(THospital'[Hospital)
	.
	.;^DHCEQCCode("DHCEQCLocGroup",1)=01^库房科室^^Y^N^Y^N
	.;库房-科室(入库转移等业务)
	.Set lgid=$Order(^DHCEQCCode("DHCEQCLocGroup",0,"Code","01",""))
	.Set LocTypeFlag=0
	.Set Flag=0		;匹配标志
	.Set code=""
	.For  Set code=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",lgid,code)) Quit:(code="")  Do
	..Set lgtid=0
	..For  Set lgtid=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",lgid,code,lgtid)) Quit:(lgtid="")  Do
	...Set ltid=$Order(^DHCEQCCode("DHCEQCLocType",0,"LocType",lgtid,TLocDR,""))
	...Quit:ltid=""
	...Set LocTypeFlag=LocTypeFlag+1
	...Set Title1=$Piece($Get(^DHCEQCCode("DHCEQCLocGroupType",lgtid)),"^",3)
	...If (GroupIDOne'="")&(lgtid=GroupIDOne) Set Flag=1
	...Do GetLocTypeInfo
	.Quit:(GroupIDOne'="")&(Flag=0)
	.
	.;^DHCEQCCode("DHCEQCLocGroup",2)=02^职能科室^^Y^N^N^N
	.;职能科室()
	.Set lgid=$Order(^DHCEQCCode("DHCEQCLocGroup",0,"Code","02",""))
	.Set Flag=0
	.Set code=""
	.For  Set code=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",lgid,code)) Quit:(code="")  Do
	..Set lgtid=0
	..For  Set lgtid=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",lgid,code,lgtid)) Quit:(lgtid="")  Do
	...Set ltid=$Order(^DHCEQCCode("DHCEQCLocType",0,"LocType",lgtid,TLocDR,""))
	...Quit:ltid=""
	...Set LocTypeFlag=LocTypeFlag+1
	...Set Title2=$Piece($Get(^DHCEQCCode("DHCEQCLocGroupType",lgtid)),"^",3)
	...If (GroupIDTwo'="")&(lgtid=GroupIDTwo) Set Flag=1
	...;Do GetLocTypeInfo
	.Quit:(GroupIDTwo'="")&(Flag=0)
	.
	.;^DHCEQCCode("DHCEQCLocGroup",3)=03^租赁中心^^Y^N^N^N
	.;2017-2-7	Mozy	租借(租赁中心)
	.Set lgid=$Order(^DHCEQCCode("DHCEQCLocGroup",0,"Code","03",""))
	.Set Flag=0
	.s Info=""
	.Set code=""
	.For  Set code=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",lgid,code)) Quit:(code="")  Do
	..Set lgtid=0
	..For  Set lgtid=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",lgid,code,lgtid)) Quit:(lgtid="")  Do
	...Set ltid=$Order(^DHCEQCCode("DHCEQCLocType",0,"LocType",lgtid,TLocDR,""))
	...Quit:ltid=""
	...Set LocTypeFlag=LocTypeFlag+1
	...If (GroupIDThree'="")&((","_lgtid_",")[(","_GroupIDThree_",")) Set Flag=1
	...i Info="" d
	....Set Info=$Piece($Get(^DHCEQCCode("DHCEQCLocGroupType",lgtid)),"^",3)
	...e  d
	....s Info=Info_","_$Piece($Get(^DHCEQCCode("DHCEQCLocGroupType",lgtid)),"^",3)
	.s Title3=Info
	...;Do GetLocTypeInfo
	.Quit:(GroupIDThree'="")&(Flag=0)
	.
	.Quit:(UnCheckFlag="Y")&(LocTypeFlag'=0)
	.Set TLocCode=$Piece($Get(^DHCEQCCode("DHCEQCDepartment",TLocDR)),"^",1)
	.Do OutputRowDataForEQLocDetail
	
	Quit $$$OK
GetLocTypeInfo
	s TRemark=$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",5)
	s TManageUserDR=$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",6)
	i TManageUserDR'="" s TManageUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", TManageUserDR)
	s TLocation=$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",7)
	s TTel=$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",8)
	s THold1=$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",9)
	s THold2=$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",10)
	s THold3=$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",11)
	s THold4=$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",12)
	s THold5=$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",13)
	
	Quit
OutputRowDataForEQLocDetail
	Set Data=$lb(TLocDR,TLocDesc,THospital,Title1,Title2,Title3,TRow,TLocCode,TRemark,TManageUser,TLocation,TTel,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	Quit
ResetVariablesDataForEQLocDetail
	Set (TLocDR,TLocDesc,THospital,Title1,Title2,Title3,TLocCode,TRemark,id,TManageUser,TLocation,TTel,THold1,THold2,THold3,THold4,THold5)=""
	Quit
}

ClassMethod EQLocDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EQLocDetailExecute ]
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

ClassMethod EQLocDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQLocDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// hisui 改造 add by wy
/// 2017-2-7	Mozy	增加获取租赁中心科室信息
/// 创建:ZY  2009-07-06   BugNo.：ZY0004 ???
/// 描述：根据rowid获取科室类型的信息
/// 访问表:DHC_EQCLocType
/// 输入：科室rowid
/// 返回：成功返回一条科室类型信息
/// 备注：
/// w ##Class(web.DHCEQ.Plat.CTLocType).GetEQLocDetailByID("", "", 50)
ClassMethod GetEQLocDetailByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	If rowid="" Quit ""
	
	new result,Loc,Hospital,ltid,Title,Info,lgid,code,lgtid
	Set result=rowid
	Set Loc=$Piece($Get(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",2)
	Set result=result_"^"_Loc
	
	Set Hospital=$Piece($Get(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",8)
	If Hospital'="" Set Hospital=$Piece($Get(^CT("HOSP",Hospital)),"^",2)
	Set result=result_"^"_Hospital
	
	;职能科室()
	Set ltid=""
	Set Title=""
	Set Info=""
	Set result=result_"^"
	Set lgid=$Order(^DHCEQCCode("DHCEQCLocGroup",0,"Code","02",""))
	Set code=""
	For  Set code=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",lgid,code)) Quit:(code="")||(Title='"")  Do
	.Set lgtid=0
	.For  Set lgtid=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",lgid,code,lgtid)) Quit:(lgtid="")||(Title='"")  Do
	..Set ltid=$Order(^DHCEQCCode("DHCEQCLocType",0,"LocType",lgtid,rowid,""))
	..Quit:ltid=""
	..Set Title=$Piece($Get(^DHCEQCCode("DHCEQCLocGroupType",lgtid)),"^",3)
	..Set Info=ltid_"^"_lgtid_"^"_Title	;只取组信息

	If Info="" Do
	.Set result=result_"^^"
	Else  Do
	.Set result=result_Info
	/// 2017-2-7	Mozy	增加获取租赁中心科室信息
	;租借(租赁中心)
	Set ltid=""
	Set Title=""
	Set Info=""
	s (LocIDs,LGTIDs,Titles)=""
	Set result=result_"^"
	Set lgid=$Order(^DHCEQCCode("DHCEQCLocGroup",0,"Code","03",""))
	Set code=""
	For  Set code=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",lgid,code)) Quit:(code="")||(Title='"")  Do
	.Set lgtid=0
	.For  Set lgtid=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",lgid,code,lgtid)) Quit:(lgtid="")||(Title='"")  Do
	..Set ltid=$Order(^DHCEQCCode("DHCEQCLocType",0,"LocType",lgtid,rowid,""))
	..Quit:ltid=""
	..Set Title=$Piece($Get(^DHCEQCCode("DHCEQCLocGroupType",lgtid)),"^",3)
	..i LocIDs="" d
	...s LocIDs=ltid
	..e  d
	...s LocIDs=LocIDs_"#"_ltid
	..i LGTIDs="" d
	...s LGTIDs=lgtid
	..e  d
	...s LGTIDs=LGTIDs_"#"_lgtid
	..i Titles="" d
	...s Titles=Title
	..e  d
	...s Titles=Titles_"#"_Title
	s Info=LocIDs_"^"_LGTIDs_"^"_Titles
	If Info="" Do
	.Set result=result_"^^"
	Else  Do
	.Set result=result_Info
	
	;^DHCEQCCode("DHCEQCLocGroup",1)=01^库房科室^^Y^N^Y^N
	;库房-科室(入库转移等业务)
	Set ltid=""
	Set Title=""
	Set Info=""
	Set result=result_"^"
	Set lgid=$Order(^DHCEQCCode("DHCEQCLocGroup",0,"Code","01",""))
	Set code=""
	For  Set code=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",lgid,code)) Quit:(code="")||(Title='"")  Do
	.Set lgtid=0
	.For  Set lgtid=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",lgid,code,lgtid)) Quit:(lgtid="")||(Title='"")  Do
	..Set ltid=$Order(^DHCEQCCode("DHCEQCLocType",0,"LocType",lgtid,rowid,""))
	..Quit:ltid=""
	..Set Title=$Piece($Get(^DHCEQCCode("DHCEQCLocGroupType",lgtid)),"^",3)
	..Set Info=ltid_"^"_lgtid_"^"_Title
	..Set Info=Info_"^"_$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",5)
	..Set Info=Info_"^"_$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",6)_"^"
	..i $Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",6)'="" s Info=Info_##Class(web.DHCEQCommon).GetTrakNameByID("user", $Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",6))
	..Set Info=Info_"^"_$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",7)
	..Set Info=Info_"^"_$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",8)
	..Set Info=Info_"^"_$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",9)
	..Set Info=Info_"^"_$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",10)
	..Set Info=Info_"^"_$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",11)
	..Set Info=Info_"^"_$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",12)
	..Set Info=Info_"^"_$Piece($Get(^DHCEQCCode("DHCEQCLocType",ltid)),"^",13)
	If Info="" Do
	.Set result=result_"^^^^^^^^^^^^"
	Else  Do
	.Set result=result_Info
	
	
	Quit result
}

/// hisui 改造 add by wy
/// w ##Class(web.DHCEQ.Plat.CTLocType).UpdateEQLocDetail("50^71^2^502^5^937,938^10^www^4674^东方^12345678^^^^^")
ClassMethod UpdateEQLocDetail(val As %Library.String = "")
{
	Kill PLIST
	Set LocDR=$Piece(val,"^",1)
	Set PLIST(3) = LocDR				;科室id
	Set TypeIDOne=$Piece(val,"^",2)
	Set GroupIDOne=$Piece(val,"^",3)
	Set TypeIDTwo=$Piece(val,"^",4)
	Set GroupIDTwo=$Piece(val,"^",5)
	Set TypeIDThrees=$Piece(val,"^",6)	/// 2017-2-7	Mozy	设置租赁中心科室信息
	Set GroupIDThrees=$Piece(val,"^",7)
	Set PLIST(4) = +$H

	Set SQLCODE=0
	// 职能
	If GroupIDTwo=""
	{
		If TypeIDTwo'="" &SQL(Delete From SQLUser.DHC_EQCLocType where LT_RowID = :TypeIDTwo)
	}
	Else
	{
		Set PLIST(2) = GroupIDTwo		;类型
		If (TypeIDTwo="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQCLocType Values :PLIST())
		}
		Else
		{
			&SQL(Update SQLUSER.DHC_EQCLocType Values :PLIST() where LT_RowID = :TypeIDTwo)
		}
	}
	If SQLCODE Quit SQLCODE
	
	/// 2017-2-7	Mozy	增加获取租赁中心科室信息
	If GroupIDThrees=""
	{
		If TypeIDThrees'="" 
		{
			s count=$l(TypeIDThrees,",")
			f m=1:1:count d
 			.s TypeIDThree=$p(TypeIDThrees,",",m)
			.&SQL(Delete From SQLUser.DHC_EQCLocType where LT_RowID = :TypeIDThree)
		}
	}
	Else
	{
	
		s len=$l(GroupIDThrees,",")
		s count=$l(TypeIDThrees,",")
		f n=1:1:len d
 		.s GroupIDThree=$p(GroupIDThrees,",",n)
 		.q:GroupIDThree=""
		.Set PLIST(2) = GroupIDThree		;类型
		.i TypeIDThrees="" d
		..&SQL(Insert Into SQLUSER.DHC_EQCLocType Values :PLIST())
		.e  d
		..f m=1:1:count d
 		...s TypeIDThree=$p(TypeIDThrees,",",m)
 		...q:TypeIDThree=""
 		...s vGroupType=""
 		...s vGroupType=$p($g(^DHCEQCCode("DHCEQCLocType",TypeIDThree)),"^",1)
 		...i vGroupType=GroupIDThree d
		....&SQL(Update SQLUSER.DHC_EQCLocType Values :PLIST() where LT_RowID = :TypeIDThree)
	

		if (len>count)
		{
			f i=1:1:len d
 			.s vGroupIDThree=$p(GroupIDThrees,",",i)
 			.Set PLIST(2) = vGroupIDThree		;类型
			.q:$d( ^DHCEQCCode("DHCEQCLocType",0,"LocType",vGroupIDThree,LocDR))
			.&SQL(Insert Into SQLUSER.DHC_EQCLocType Values :PLIST())
		}
		elseif (len<count) 
		{
			f j=1:1:count d
 			.s vTypeIDThree=$p(TypeIDThrees,",",j)
			.q:(","_$p($g(^DHCEQCCode("DHCEQCLocType",vTypeIDThree)),"^",1)_",")[(","_GroupIDThrees_",")
			.&SQL(Delete From SQLUser.DHC_EQCLocType where LT_RowID = :vTypeIDThree)
		}
		
		
	}
	If SQLCODE Quit SQLCODE
	
	// 属性
	If GroupIDOne=""
	{
		If TypeIDOne'="" &SQL(Delete From SQLUser.DHC_EQCLocType where LT_RowID = :TypeIDOne)
	}
	Else
	{
		Set PLIST(2) = GroupIDOne			;类型
		/// 2017-2-7	Mozy	调整取值
		Set PLIST(6)=$Piece(val,"^",8)		;Remark
		Set PLIST(7)=$Piece(val,"^",9)		;ManageUserDR
		Set PLIST(8)=$Piece(val,"^",10)		;Location
		Set PLIST(9)=$Piece(val,"^",11)		;Tel
		Set PLIST(10)=$Piece(val,"^",12)	;Hold1
		Set PLIST(11)=$Piece(val,"^",13)	;Hold2
		Set PLIST(12)=$Piece(val,"^",14)	;Hold3
		Set PLIST(13)=$Piece(val,"^",15)	;Hold4
		Set PLIST(14)=$Piece(val,"^",16)	;Hold5
		If (TypeIDOne="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQCLocType Values :PLIST())
		}
		Else
		{
			&SQL(Update SQLUSER.DHC_EQCLocType Values :PLIST() where LT_RowID = :TypeIDOne)
		}
	}
	If SQLCODE Quit SQLCODE
	
	Quit LocDR
}

/// hisui 改造 add by wy
/// 2017-2-7	Mozy	调整过滤多个组类型代码
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTLocType","GetLocGroupType","1")
Query GetLocGroupType(Type As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TCode:%String")
{
}

ClassMethod GetLocGroupTypeExecute(ByRef qHandle As %Binary, Type As %Library.String = "") As %Status
{
	If Type="" Quit $$$OK
 	new repid, index, rowid, type, Code
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set Type=","_Type_","
	Set type=""
	For  Set type=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",type)) Quit:type=""  Do
	.Quit:(Type'[(","_type_","))
	.Set TCode=""
	.For  Set TCode=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",type,TCode)) Quit:TCode=""  Do
	..Set rowid=0
	..For  Set rowid=$Order(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",type,TCode,rowid)) Quit:rowid=""  Do
	...Quit:($Piece($Get(^DHCEQCCode("DHCEQCLocGroupType",rowid)),"^",5)'="N")
	...Do ResetVariablesGetLocGroupType
	...Set TRowID = rowid
	...Set TName = $Piece($Get(^DHCEQCCode("DHCEQCLocGroupType",rowid)),"^",3)
	...Do OutputRowGetLocGroupType
	Quit $$$OK
OutputRowGetLocGroupType
	Set Data=$lb(TRowID,TName,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetLocGroupType
	Quit
}

ClassMethod GetLocGroupTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocGroupTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
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

ClassMethod GetLocGroupTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocGroupTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// hisui 改造 add by wy
/// w ##Class(web.DHCEQ.Plat.CTLocType).GetLocTypeByType(3)
ClassMethod GetLocTypeByType(Type As %String = "")
{
	i Type="" q "[{}]"
	s Info=""
	s Code=0
	f  s Code=$O(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",Type,Code))  q:Code=""  d
	.s CRowID=0
	.f  s CRowID=$O(^DHCEQCCode("DHCEQCLocGroupType",0,"GroupCode",Type,Code,CRowID))  q:CRowID=""  d
	..q:$P($G(^DHCEQCCode("DHCEQCLocGroupType",CRowID)),"^",5)="Y"
	..i Info="" d
	...s Info="{id:'"_CRowID_"',text:'"_$P($G(^DHCEQCCode("DHCEQCLocGroupType",CRowID)),"^",3)_"'}"
	..e  d
	...s Info=Info_","_"{id:'"_CRowID_"',text:'"_$P($G(^DHCEQCCode("DHCEQCLocGroupType",CRowID)),"^",3)_"'}"
	i Info'="" s Info="["_Info_"]"
	q Info
}

}
