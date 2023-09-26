Class dhc.sync.web.Loc Extends %RegisteredObject
{

ClassMethod ExportData(SysCode, over = 0)
{
	Quit:SysCode="" "-100^请选择系统代码"
	Set rtn = ##class(dhc.sync.web.SyncInterface).ExportDept(SysCode,over)
	quit rtn
}

/// 	param: SysCode 系统代码
/// param: over  是否覆盖 0不覆盖. 1覆盖(代码一样的科室重写其它信息) 
ClassMethod ImportData(SysCode, over = 0)
{
	Quit:SysCode="" "-100^请选择系统代码"
	Set rtn = ##class(dhc.sync.web.SyncInterface).ImportDept(SysCode,over)
	quit rtn
}

ClassMethod GetSystemCodes(LocRowId)
{
	Quit:LocRowId="" ""
	Set rtn = ""
	Set LocCode = $lg(^dhcsyncLocD(LocRowId),2)
	Quit:LocCode="" ""
	Set LSRowId = $O(^dhcsyncL2SMapI("L2ScodeIndex",LocCode,0))
	while(LSRowId>0){
		Set SysCode = $lg(^dhcsyncL2SMapD(LSRowId),3)
		Set SysId = $o(^dhcsyncSystemI("syncSysCode",SysCode,""))
		Set SysActive = $lg(^dhcsyncSystemD(SysId),4)
		if (SysActive="Y"){
			if rtn="" {
				Set rtn = SysCode
			}else{
				Set rtn = rtn_","_SysCode
			}
		}
		Set LSRowId = $O(^dhcsyncL2SMapI("L2ScodeIndex",LocCode,LSRowId))
	}
	Quit rtn
}

ClassMethod GetDelData(RowId)
{
	Quit:RowId="" ""
	Set rtn = ""
	Set LocCode = $lg(^dhcsyncLocD(RowId),2)
	Set Name = $lg(^dhcsyncLocD(RowId),3)
	Set Level=$list(^dhcsyncLocD(RowId),4)
	Set Super=$list(^dhcsyncLocD(RowId),5)
	Set IsLast=$list(^dhcsyncLocD(RowId),7)	
	Set rtn = LocCode_"^"_Name_"^"_Level_"^"_Super_"^2^"_IsLast_"^^^^^^^^^^^"
	Quit rtn
	i syscode="PA" d
	.s locsync=##class(dhc.bonus.udata.uDataSync).%New()
	.s ever=locsync.BonusUnitSync(data1)
	e  d
	.s checkrec=##class(ClientService.SwitchSystemWebServiceSoap).%New() ;2表删除状态
	.s ever=checkrec.SwitchSystem("D",syscode,data1)
	i syscode="OA" d
	.&sql(delete from dhc_sync_data.Sync_L2SMap where LocCode=:code and SystemCode='OA' )
}

ClassMethod Del(RowId)
{
	Quit:RowId="" "-100^请选中记录,再删除!"
	Quit:$d(^dhcsyncLocD(RowId))=0 "-100^找不到Id="_RowId_"的科室!"
	Set LocCode = $lg(^dhcsyncLocD(RowId),2)
	&sql(select count(*) into:acount from dhc_sync_data.Sync_User where Sync_Deptcode=:LocCode)
	Quit:acount>0 "-100^有用户在该科室下,不能删除!"
	Set hasChild=0
	&sql(select count(*) into:count from dhc_sync_data.Sync_Loc where Super=:LocCode and State=1)
	if count>0 s hasChild=1
	Quit:hasChild "-100^有子科室不能删除!"
	Set Name = $lg(^dhcsyncLocD(RowId),3)
	set syncCount=0
	Set SysCodes = ..GetSystemCodes(RowId)	
	if SysCodes="" {	;没有同步过
		Set rtn = ##class(dhc.sync.data.Loc).%DeleteId(RowId)
	}else{
		Set SysCodes = "^"_$tr(SysCodes,",","^")_"^"
		Set Data = ..GetDelData(RowId)
		Set rtn = ##class(dhc.sync.web.SyncInterface).Sync("D",SysCodes,Data)
		Set LocObj = ##class(dhc.sync.data.Loc).%OpenId(RowId)
		Set LocObj.State = 2
		Set rtn = LocObj.%Save()
	} 
	if $$$ISERR(rtn) Quit "-100^删除科室错误"
	d ##class(dhc.sync.udata.SyncChangeLog).SaveLog("Sync_Loc","dhc.sync.web.Loc","科室信息维护",LocCode,Name,"D",LocCode)
	Quit 0
}

ClassMethod GenCode(Name)
{
	Quit:Name="" ""
	;生成Code
	Set Code = ##class(ext.util.String).ToChineseSpell(Name)
	Set NewCode = Code
	Set tmprowid = $o(^dhcsyncLocI("syncLocIdx",Code,0))
	if tmprowid>0{
    	Set len = $l(Code)
    	Set MaxCode = $o(^dhcsyncLocI("syncLocIdx",Code))
		;拼音相同,后面加数字
		while(($e(MaxCode,1,len)=Code) &&($e(MaxCode,len+1,)>0)){
    		Set MaxCode = $o(^dhcsyncLocI("syncLocIdx",MaxCode))
    	}
		Set MaxCode = $o(^dhcsyncLocI("syncLocIdx",MaxCode),-1)
		Set NewCode = Code_($e(MaxCode,len+1,)+1)
	}
	
	Quit NewCode
}

ClassMethod Save(Code, Name, LocLevel, Super, State, IsLast = "", Type, DGroup, Classify, Address, Phone, Mnemonics, StartDate, EndDate, Storey, Catalogue, Dept, SysCode, HospCode = "")
{
	S rowid=0
	Quit:(Code="")&&(Name="") "-100^代码与名称不能都为空"
	Set NewCode = Code
    if Code = "" {
	    ;生成Code
	    S NewCode = ..GenCode(Name)
    	S OpState = 1
    }else{
    	s rowid=$o(^dhcsyncLocI("syncLocIdx",Code,rowid))
    	if rowid>0 s OpState = 3	;修改
    	else  S OpState = 1			;增加
    }
	if rowid>0{
		Set LocObj = ##class(dhc.sync.data.Loc).%OpenId(rowid)
	}else{
		Set LocObj = ##class(dhc.sync.data.Loc).%New()
	}
	Set LocObj.Code=NewCode
	Set LocObj.Name = Name
	Set LocObj.LocLevel = LocLevel
	Set LocObj.Super = Super
	Set LocObj.State = State
	Set LocObj.IsLast = IsLast
	Set LocObj.Type = Type
	Set LocObj.DGroup = DGroup
	Set LocObj.Classify = Classify
	Set LocObj.Address = Address
	Set LocObj.Phone = Phone
	Set LocObj.Mnemonics = Mnemonics
	Set LocObj.StartDate = StartDate
	set LocObj.EndDate = EndDate
	Set LocObj.Storey=Storey
	Set LocObj.Catalogue = Catalogue
	Set LocObj.Dept = Dept
	Set LocObj.HospCode = HospCode
	S sc = LocObj.%Save()
	if $$$ISERR(sc) Quit "^-100^保存用户到统一平台出错!"
	Set rtn = LocObj.%Id()
	Set LocObj = ""
	Set Op = $case(OpState,1:"A",2:"D",3:"U")
    Set SysCode = "^"_$TR(SysCode,",","^")_"^"
    Set data=NewCode_"^"_Name_"^"_LocLevel_"^"_Super_"^"_1_"^"_IsLast_"^"_Type_"^"_DGroup_"^"_Classify_"^"_Address_"^"_Phone_"^"_Mnemonics_"^"_StartDate_"^"_EndDate_"^"_Storey_"^"_Catalogue_"^"_Dept_"^"_HospCode
	d ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_Loc","dhc.sync.web.Loc","科室信息维护",Code,"科室代码",Op,$TR(data,"^","|"))
	s rtn = ##class(dhc.sync.web.SyncInterface).Sync("D",SysCode,data)
	q rtn
}

ClassMethod SaveByData(Data, SysCode, userId, uname)
{
	q:Data="" "-100^data is null"
	Set Code = $Piece(Data,"^",1), Name = $Piece(Data,"^",2), LocLevel = $Piece(Data,"^",3)
	Set Super = $Piece(Data,"^",4), State = $Piece(Data,"^",5), IsLast = $Piece(Data,"^",6)
	Set Type =  $Piece(Data,"^",7),DGroup=$Piece(Data,"^",8),Classify=$Piece(Data,"^",9),Address = $Piece(Data,"^",10)
	Set Phone=$Piece(Data,"^",11),Mnemonics=$Piece(Data,"^",12),StartDate = $Piece(Data,"^",13)
	Set EndDate = $Piece(Data,"^",14),Storey=$Piece(Data,"^",15),Cataloguo=$Piece(Data,"^",16),Dept=$Piece(Data,"^",17)
	set HospCode=$Piece(Data,"^",18)

	Quit:Name="" "-100^Name is null"
	;s rowid=$o(^dhcsyncLocI("syncLocNameIdx",Name,"Y",""))
	;q:rowid>0 "-100^Name is Exist"
	S rowid=0
    if Code = "" {
    	 S Code = ..GenCode(Name)
    	 S OpState = 1
    }else{
    	s rowid=$o(^dhcsyncLocI("syncLocIdx",Code,rowid))
    	if rowid>0 s OpState = 3
    	else  S OpState = 1
    }
    S $p(Data,"^",1)=Code
	if rowid>0{
		Set LocObj = ##class(dhc.sync.data.Loc).%OpenId(rowid)
	}else{
		Set LocObj = ##class(dhc.sync.data.Loc).%New()
	}
	Set LocObj.Code=Code
	Set LocObj.Name = Name
	Set LocObj.LocLevel = LocLevel
	Set LocObj.Super = Super
	Set LocObj.State = State
	Set LocObj.IsLast = IsLast
	Set LocObj.Type = Type
	Set LocObj.DGroup = DGroup
	Set LocObj.Classify = Classify
	Set LocObj.Address = Address
	Set LocObj.Phone = Phone
	Set LocObj.Mnemonics = Mnemonics
	Set LocObj.StartDate = StartDate
	set LocObj.EndDate = EndDate
	Set LocObj.Storey=Storey
	Set LocObj.Catalogue = Cataloguo
	Set LocObj.Dept = Dept
	Set LocObj.HospCode = HospCode
	S rtn = LocObj.%Save()
	if $$$ISERR(rtn) Quit "-100^Save Fail"
	Set rtn = LocObj.%Id()
 	Set LocObj = ""
	Set Op = $case(OpState,1:"A",2:"D",3:"U")
	d ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_Loc","dhc.sync.web.Loc","科室信息维护",Code,"科室代码",Op,$tr(Data,"^","|"))
    for i=1:1:$l(SysCode,"^") Set item=$p(SysCode,"^",i) if item'="" Set $p(SysCode,"^",i)=$lg(^dhcsyncSystemD(item),2)
	if SysCode'="" s rtn = ##class(dhc.sync.web.SyncInterface).Sync("D",SysCode,Data)
	q rtn
}

ClassMethod GetLocData(LocId)
{
	s Code=$List(^dhcsyncLocD(LocId),2)
	s Name=$List(^dhcsyncLocD(LocId),3)
	s LocLevel=$List(^dhcsyncLocD(LocId),4)
	s Super=$List(^dhcsyncLocD(LocId),5)
	s State=$List(^dhcsyncLocD(LocId),6)
	s IsLast=$List(^dhcsyncLocD(LocId),7)
	s Type=$List(^dhcsyncLocD(LocId),8)
	s DGroup=$List(^dhcsyncLocD(LocId),9)
	s Classify=$List(^dhcsyncLocD(LocId),10)
	s Address =$List(^dhcsyncLocD(LocId),11)
	s Phone =$List(^dhcsyncLocD(LocId),12)
	s Mnemonics=$List(^dhcsyncLocD(LocId),13)
	s StartDate=$List(^dhcsyncLocD(LocId),14)
	s EndDate=$List(^dhcsyncLocD(LocId),15)
	s Storey=$List(^dhcsyncLocD(LocId),16)
	s Catalogue=$List(^dhcsyncLocD(LocId),17)
	s Dept=$List(^dhcsyncLocD(LocId),18)
	S HospCode=$List(^dhcsyncLocD(LocId),23)
	s Data=Code_"^"_Name_"^"_LocLevel_"^"_Super_"^"_State_"^"_IsLast_"^"_Type_"^"_DGroup_"^"_Classify_"^"_Address_"^"_Phone_"^"_Mnemonics_"^"_StartDate_"^"_EndDate_"^"_Storey_"^"_Catalogue_"^"_Dept_"^"_HospCode
	quit Data
}

ClassMethod SyncByLocId(SystemCodes, LocId)
{
	s ^temp("SyncLoc")=$lb(SystemCodes,LocId)
	Set LocIdData = ..GetLocData(LocId)
	Set rtn = ##class(dhc.sync.web.SyncInterface).Sync("D",SystemCodes,LocIdData)
	quit:rtn>0 0
	quit -100_"^SyncError. "_rtn
}

/// d ##class(%ResultSet).RunQuery("dhc.sync.web.Loc","Find","","","")
Query Find(Code, Name, Super, State, Type, DGroup, Classify, Address, Phone, Mnemonics, StartDate, EndDate, Storey, Catalogue, Dept, SysCode) As websys.Query(CONTAINID = 1, ROWSPEC = "LocRowId:%String,LocCode,LocName,LocLevel:%String,LocSuper,LocState,LocIsLast,LocType,LocDGroup,LocClassify,LocAddress,LocPhone,LocMnemonics,LocStartDate,LocEndDate,LocStorey,LocCatalogue,LocDept,Code1,Code2,Code3,Code0,LocHospCode,LocSysCode")
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, Code, Name, Super, State, Type, DGroup, Classify, Address, Phone, Mnemonics, StartDate, EndDate, Storey, Catalogue, Dept, SysCode) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	;State 1有效,2无效
	
	Set LocId=""
	for {
		Set LocId = $Order(^dhcsyncLocD(LocId))
		Quit:LocId=""
		If $d(^dhcsyncLocD(LocId),g){
			Set LocCode = $lg(g,2)
			Continue:(Code'="")&&(LocCode'[Code)
			Set LocName = $lg(g,3)
			Continue:(Name'="")&&(LocName'[Name)
			Set LocState = $lg(g,6)
			Continue:(State'="")&&(LocState'=State)
			Set $list(g,6)=$s(LocState="1":"有效",LocState="2":"无效",1:"无效")
			Set LocDept = $listget(g,18)
			Set $list(g,18)=$s(LocDept="Y":"科室",1:"")
			Set $list(g,1)=LocId
			Set LocSysCodes = ..GetSystemCodes(LocId)
			Set $list(g,24) = LocSysCodes
			;$LB(%%CLASSNAME,Code,Name,LocLevel,Super,State,IsLast,Type,DGroup,Classify,Address,Phone,Mnemonics,StartDate,EndDate,Storey,Catalogue,Dept,Code1,Code2,Code3,Code0,HospCode)
			Set ^CacheTemp(repid,ind)=g
			Set ind=ind+1
		}
	}
	Set QHandle=$lb(0,repid,0)
	quit $$$OK
}

}
