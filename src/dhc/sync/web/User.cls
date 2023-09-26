Class dhc.sync.web.User Extends %RegisteredObject
{

/// 返回用户id,判断用户有效,有效日期
ClassMethod GetIdByCode(ucode)
{
	Quit:ucode="" ""
	
	Set userid=$o(^dhcsyncUserI("SyncUserCode",ucode,""))
	Quit:userid'>0 -108
	Set statu = $lg(^dhcsyncUserD(userid),6)
	Set StDate = $lg(^dhcsyncUserD(userid),8)
	If StDate'="" Set StDate=$zdh(StDate,3)
	Set EndDate = $lg(^dhcsyncUserD(userid),10)
	If EndDate'="" Set EndDate=$zdh(EndDate,3)
	Set now = +$h
	Quit:(StDate'="")&&(StDate>now) -109
	Quit:(EndDate'="")&&(EndDate<now) -110
	Quit:statu'=1 -111
	q userid
}

/// param: SysCode 系统代码
/// param: over  是否覆盖 0不覆盖. 1覆盖(代码一样的用户重写其它信息) 
/// 把数据从数据平台导出到syscode中
ClassMethod ExportData(SysCode, over = 0)
{
	Quit:SysCode="" "-100^请选择系统代码"
	Set rtn = ##class(dhc.sync.web.SyncInterface).ExportUser(SysCode,over)
	quit rtn
}

/// param: SysCode 系统代码
/// param: over    是否覆盖 0不覆盖. 1覆盖(代码一样的用户重写其它信息) 
/// 把数据从syscode中导入到统一平台
ClassMethod ImportData(SysCode, over = 0)
{
	Quit:SysCode="" "-100^请选择系统代码"
	Set rtn = ##class(dhc.sync.web.SyncInterface).ImportUser(SysCode,over)
	quit rtn
}

/// @author : wanghc
/// 2015-01-16
ClassMethod GetUserData(UserId)
{
	s userCode=$list(^dhcsyncUserD(UserId),2)
	s name=$List(^dhcsyncUserD(UserId),3)
	s password=$List(^dhcsyncUserD(UserId),4)
	s Deptcode=$List(^dhcsyncUserD(UserId),5)
	s State=$List(^dhcsyncUserD(UserId),6)
	s Email=$List(^dhcsyncUserD(UserId),7)
	s InvalidDate=$List(^dhcsyncUserD(UserId),8)
	s UpdateDate=$List(^dhcsyncUserD(UserId),9)
	s EegDate=$List(^dhcsyncUserD(UserId),10)
	s Type=$List(^dhcsyncUserD(UserId),11)
	s Mnemonics=$List(^dhcsyncUserD(UserId),12)
	s HealthType=$List(^dhcsyncUserD(UserId),13)
	s IsExpert=$List(^dhcsyncUserD(UserId),14)
	s Secgroup=$List(^dhcsyncUserD(UserId),15)
	s Certificate=$List(^dhcsyncUserD(UserId),16)
	s ISDrugRight=$List(^dhcsyncUserD(UserId),17)
	s Number=$List(^dhcsyncUserD(UserId),18)
	s Ename=$List(^dhcsyncUserD(UserId),19)
	s Fname=$List(^dhcsyncUserD(UserId),20)
	s Company=$List(^dhcsyncUserD(UserId),21)
	s Position=$List(^dhcsyncUserD(UserId),22)
	s Dleader=$List(^dhcsyncUserD(UserId),23)
	s Cellphone=$List(^dhcsyncUserD(UserId),24)
	s Landline=$Listget(^dhcsyncUserD(UserId),25)
	S PasswordDate =$Listget(^dhcsyncUserD(UserId),26)
	If PasswordDate'="" Set PasswordDate=$zd(PasswordDate,3)
	s userCode= ##class(ext.util.String).EvalJSON(userCode)
	s name= ##class(ext.util.String).EvalJSON(name)
	s password=##class(ext.util.String).EvalJSON(password)
	//Mnemonics HealthType IsExpert Secgroup Certificate ISDrugRight Number
	s userData=userCode_"^"_name_"^"_password_"^"_Deptcode_"^"_State_"^"_Email_"^"_InvalidDate_"^"_EegDate_"^"_Type_"^"_Mnemonics_"^"_HealthType_"^"_IsExpert_"^"_Secgroup_"^"_Certificate_"^"_ISDrugRight_"^"_Number_"^"_Ename_"^"_Fname_"^"_Company_"^"_Position_"^"_Dleader_"^"_Cellphone_"^"_Landline_"^"_PasswordDate
	q userData
}

ClassMethod GetSystemCodes(UserId)
{
	Quit:UserId="" ""
	Set rtn = ""
	Set UserCode = $lg(^dhcsyncUserD(UserId),2)
	Quit:UserCode="" ""
	Set USRowId = $O(^dhcsyncU2SMapI("U2SUcodeIndex",UserCode,0))
	while(USRowId>0){
		Set SysCode = $lg(^dhcsyncU2SMapD(USRowId),3)
		Set SysId = $o(^dhcsyncSystemI("syncSysCode",SysCode,""))
		Set SysActive = $lg(^dhcsyncSystemD(SysId),4)
		if (SysActive="Y"){
			if rtn="" {
				Set rtn = SysCode
			}else{
				Set rtn = rtn_","_SysCode
			}
		}
		Set USRowId = $O(^dhcsyncU2SMapI("U2SUcodeIndex",UserCode,USRowId))
	}
	Quit rtn
}

/// d ##class(%ResultSet).RunQuery("dhc.sync.web.User","Find","","","")
Query Find(Code = "", Name = "", Deptcode = "", State = "", Email = "", Type = "", Mnemonics = "", HealthType = "", Secgroup = "", Ename = "", Fname = "", Company = "", Cellphone = "", SysCode = "") As websys.Query(CONTAINID = 1, ROWSPEC = "UserRowId:%String,UserCode,UserName,UserPassword,UserDeptcode,UserState,UserEmail,UserInvalidDate,UserUpdateDate,UserEegDate,UserType,UserMnemonics,UserHealthType,UserIsExpert,UserSecgroup,UserCertificate,UserISDrugRight,UserNumber,UserEname,UserFname,UserCompany,UserPosition,UserDleader,UserCellphone,UserLandline,UserPasswordDate,UserSysCode,UserHealthTypeDesc")
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, Code = "", Name = "", Deptcode = "", State = "", Email = "", Type = "", Mnemonics = "", HealthType = "", Secgroup = "", Ename = "", Fname = "", Company = "", Cellphone = "", SysCode = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	;State 1有效,2无效
	If State="on" Set State=1
	Set UserId=""
	for {
		Set UserId = $Order(^dhcsyncUserD(UserId))
		Quit:UserId=""
		If $d(^dhcsyncUserD(UserId),g){
			Set UserCode = $lg(g,2)
			Continue:(Code'="")&&(UserCode'[Code)
			Set UserName = $lg(g,3)
			Continue:(Name'="")&&(UserName'[Name)
			Set UserState = $lg(g,6)
			Continue:(State'="")&&(UserState'=State)
			Set $list(g,6)=$s(UserState="1":"有效",UserState="2":"无效",1:"无效")
			Set UserDeptcode = $listget(g,5)
			Continue:(Deptcode'="")&&(UserDeptcode'[Deptcode)
			Set $list(g,1)=UserId
			Set UserType = $lg(g,11)
			Set $list(g,11)=$s((UserType="01"):"护士",(UserType="02"):"医生",(UserType="07"):"其它",1:UserType) 
			Set UserSysCodes = ..GetSystemCodes(UserId)
			
			Set TPasswordDate = $lg(g,26)
			Set TPasswordDate = ##class(websys.Conversions).DateLogicalToHtml(TPasswordDate)
			Set $list(g,26) = TPasswordDate 
			Set $list(g,27) = UserSysCodes
			Set THealthType=$lg(g,13)
			Set UserHealthTypeDesc=""
			if (THealthType'=""){
				Set THealthTypeId = $O(^CT("CPT",0,"Code",$$ALPHAUP^SSUTIL4(THealthType),""))
				if (THealthTypeId>0) Set UserHealthTypeDesc= $p(^CT("CPT",THealthTypeId),"^",2)
			}
			Set $list(g,28) = UserHealthTypeDesc
			;$LB(%%CLASSNAME,Code,Name,Password,Deptcode,State,Email,InvalidDate,UpdateDate,EegDate,Type,Mnemonics,HealthType,IsExpert,Secgroup,Certificate,ISDrugRight,Number,Ename,Fname,Company,Position,Dleader,Cellphone,Landline,PasswordDate)
			Set ^CacheTemp(repid,ind)=g
			Set ind=ind+1
		}
	}
	Set QHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod SaveByData(Data, SysCode, userId, uname)
{
	q:Data="" "-100^data is null"
	Set Code = $Piece(Data,"^",1), Name = $Piece(Data,"^",2), Password = $Piece(Data,"^",3)
	Set Deptcode = $Piece(Data,"^",4), State = $Piece(Data,"^",5), Email = $Piece(Data,"^",6)
	Set InvalidDate = $Piece(Data,"^",7), EegDate = $Piece(Data,"^",8), Type = $Piece(Data,"^",9),Mnemonics=$Piece(Data,"^",10)
	Set HealthType=$Piece(Data,"^",11), IsExpert=$Piece(Data,"^",12),/*专家*/ SecGroupDesc=$Piece(Data,"^",13)
	Set Certificate=$Piece(Data,"^",14)/*医师资格证号*/,IsDrugRight=$Piece(Data,"^",15)/*毒麻处方权*/,Number=$Piece(Data,"^",16)
	Set Ename = $Piece(Data,"^",17),Fname = $Piece(Data,"^",18),Company=$Piece(Data,"^",19),Position=$Piece(Data,"^",20)
	Set Dleader=$Piece(Data,"^",21),Cellphone =$Piece(Data,"^",22)/*手机*/,Landline = $Piece(Data,"^",23) /*座机*/
	Quit:Name="" "-100^Name is null"
    Quit:Code="" "-100^Code is Null"
    Set rowid=0
	Set rowid=$o(^dhcsyncUserI("SyncUserCode",Code,rowid))
	If rowid>0 s OpState = 3
	else  S OpState = 1
	if rowid>0{
		Set Obj = ##class(dhc.sync.data.User).%OpenId(rowid)
	}else{
		Set Obj = ##class(dhc.sync.data.User).%New()
	}
	Set Obj.Code=Code
	Set Obj.Name = Name
	Set Obj.Password = Password,Obj.Deptcode = Deptcode, Obj.State = State,Obj.Email = Email
	Set Obj.InvalidDate = InvalidDate,Obj.EegDate = EegDate,Obj.Type = Type,Obj.Mnemonics=Mnemonics
	Set Obj.HealthType = HealthType,Obj.IsExpert=IsExpert,Obj.Secgroup = SecGroupDesc
	Set Obj.Certificate = Certificate,Obj.ISDrugRight = IsDrugRight,Obj.Number = Number
	Set Obj.Ename = Ename,Obj.Fname = Fname,Obj.Company = Company,Obj.Position = Position
	Set Obj.Dleader = Dleader,Obj.Cellphone = Cellphone,Obj.Landline=Landline
	Set Obj.UpdateDate = $zd(+$h,3)
	S rtn = Obj.%Save()
	if $$$ISERR(rtn) Quit "-100^Save Fail"
	Set rtn = Obj.%Id()
 	Set Obj = ""
	Set Op = $case(OpState,1:"A",2:"D",3:"U")
	;dhc_sync_data
	d ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_User","dhc.sync.web.User","用户信息维护",Code,"用户代码",Op,$tr(Data,"^","|"))
    ;for i=1:1:$l(SysCode,"^") Set item=$p(SysCode,"^",i) if item'="" Set $p(SysCode,"^",i)=$lg(^dhcsyncSystemD(item),2)
	if SysCode'="" s rtn = ##class(dhc.sync.web.SyncInterface).Sync("U",SysCode,Data)
	q rtn
}

ClassMethod Save(RowId, Code, Name, Password, Deptcode, State, Email, InvalidDate, UpdateDate, EegDate, Type, Mnemonics, HealthType, IsExpert, Secgroup, Certificate, ISDrugRight, Number, Ename, Fname, Company, Position, Dleader, Cellphone, Landline, SysCode, PasswordChange)
{
	Quit:Code="" "-100^Code Is Null"
	Set RowId=$o(^dhcsyncUserI("SyncUserCode",Code,0))
	if RowId>0{
		Set Obj = ##class(dhc.sync.data.User).%OpenId(RowId)
		Set OpState = 3
	}else{
		Set Obj = ##class(dhc.sync.data.User).%New()
		Set OpState = 1
	}
	Set Obj.Code=Code
	Set Obj.Name = Name
	if PasswordChange=1 {
		Set Obj.Password = Password
		Set Obj.PasswordDate = +$h
	}
	if PasswordChange=0,RowId>0{
		Set Password = Obj.Password  //没有修改时则取表中pwd
	}
	Set Obj.Deptcode = Deptcode, Obj.State = State,Obj.Email = Email
	Set Obj.InvalidDate = InvalidDate,Obj.EegDate = EegDate,Obj.Type = Type,Obj.Mnemonics=Mnemonics
	Set Obj.HealthType = HealthType,Obj.IsExpert=IsExpert,Obj.Secgroup = Secgroup
	Set Obj.Certificate = Certificate,Obj.ISDrugRight = ISDrugRight,Obj.Number = Number
	Set Obj.Ename = Ename,Obj.Fname = Fname,Obj.Company = Company,Obj.Position = Position
	Set Obj.Dleader = Dleader,Obj.Cellphone = Cellphone,Obj.Landline=Landline
	Set Obj.UpdateDate = $zd(+$h,3)
	S rtn = Obj.%Save()
	if $$$ISERR(rtn) Quit "-100^Save Fail"
	Set rtn = Obj.%Id()
	Set Obj = ""
	Set Op = $case(OpState,1:"A",2:"D",3:"U")
	;dhc_sync_data.Sync_User
    Set SysCode = "^"_$TR(SysCode,",","^")_"^"
    ;for i=1:1:$l(SysCode,"^") Set item=$p(SysCode,"^",i) if item'="" Set $p(SysCode,"^",i)=$lg(^dhcsyncSystemD(item),2)
    Set Data = Code_"^"_Name_"^"_Password_"^"_Deptcode_"^"_State_"^"_Email_"^"_InvalidDate_"^"_EegDate_"^"_Type
    _"^"_Mnemonics_"^"_HealthType_"^"_IsExpert_"^"_Secgroup_"^"_Certificate_"^"_ISDrugRight_"^"_Number
	_"^"_Ename_"^"_Fname_"^"_Company_"^"_Position_"^"_Dleader_"^"_Cellphone_"^"_Landline
	d ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_User","dhc.sync.web.User","用户信息维护",Code,"用户代码",Op,$tr(Data,"^","|"))
	if SysCode'="" s rtn = ##class(dhc.sync.web.SyncInterface).Sync("U",SysCode,Data)
	q rtn
}

ClassMethod Del(RowId)
{
	Quit:RowId="" "-100^请选中记录,再删除!"
	Quit:$d(^dhcsyncUserD(RowId))=0 "-100^找不到Id="_RowId_"的用户!"
	Set UserCode = $lg(^dhcsyncUserD(RowId),2)
	Set Name = $lg(^dhcsyncUserD(RowId),3)
	set syncCount=0
	Set SysCodes = ..GetSystemCodes(RowId)	
	if SysCodes="" {	;没有同步过
		Set rtn = ##class(dhc.sync.data.User).%DeleteId(RowId)
	}else{
		Set SysCodes = "^"_$tr(SysCodes,",","^")_"^"
		Set UserObj = ##class(dhc.sync.data.User).%OpenId(RowId)
		Set UserObj.State = 2
		Set rtn = UserObj.%Save()
		Set Data = ..GetUserData(RowId)
		Set rtn = ##class(dhc.sync.web.SyncInterface).Sync("U",SysCodes,Data)
	} 
	if $$$ISERR(rtn) Quit "-100^删除用户错误"
	d ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_User","dhc.sync.web.User","用户信息维护",UserCode,"用户代码","D","")
	Quit 0
}

/// name^usercode^Mnemonics^Number^Secgroup
ClassMethod GetInitInfoByName(name)
{
	set Mnemonics = ##class(ext.util.String).ToChineseSpell(name)
	if $l(Mnemonics)=2 {Set Mnemonics = $e(Mnemonics,1,1)_Mnemonics	}
	if $l(Mnemonics)>3 {Set Mnemonics = $e(Mnemonics,1,3)}
	set Number = $r(9999)
	if $l(Number)<4 Set Number = $e("0000",1,4-$l(Number))_Number
	Set UserCode = Mnemonics_Number
	Set Secgroup=""
	set json = ##class(ext.util.JsonObject).%New()
	d json.Put("name",name).Put("UserCode",UserCode).Put("UserMnemonics",Mnemonics).Put("UserNumber",Number)
	d json.Put("UserInvalidDate",$zd(+$h,3))
	;.Put("UserSecgroup","计算机中心").Put("UserPassword","123qwe!@#$%")
	s rtn = json.Json()
	q rtn
}

ClassMethod SavePassword(UserCode, UserPassword)
{
	Quit:UserCode="" "-1^UserCode is null"
	Set UserId = ..GetIdByCode(UserCode)
	Quit:(UserId=-108) "-2^用户不存在"
	Quit:(UserId=-109)||(UserId=-110) "-21^用户不在有效期内" 
	Quit:(UserId=-111) "-22^用户未激活"
	Quit:(UserId'>0) "-2^用户不存在"
	SEt SysCode = "^"_$TR(..GetSystemCodes(UserId),",","^")_"^"
	Set Data = ..GetUserData(UserId)
	Set $p(Data,"^",3)=UserPassword
	Set rtn = ..SaveByData(Data,SysCode,"","")
	quit rtn
}

ClassMethod SavePasswordBySrc(UserCode, SrcPassword, UserPassword)
{
	Quit:UserCode="" "-1^UserCode is null"
	
	Set UserId = ..GetIdByCode(UserCode)
	Quit:(UserId=-108) "-2^用户不存在"
	Quit:(UserId=-109)||(UserId=-110) "-21^用户不在有效期内" 
	Quit:(UserId=-111) "-22^用户未激活"

	Quit:(UserId'>0) "-2^用户不存在"
	Set password=$List(^dhcsyncUserD(UserId),4)
    Quit:(SrcPassword'=password) "-3^SrcPassword Error"
	SEt SysCode = "^"_$TR(..GetSystemCodes(UserId),",","^")_"^"
	Set Data = ..GetUserData(UserId)
	Set $p(Data,"^",3)=UserPassword
	Set rtn = ..SaveByData(Data,SysCode,"","")
	quit rtn
}

}
