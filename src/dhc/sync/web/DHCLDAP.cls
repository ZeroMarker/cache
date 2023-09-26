Include (%syLDAP, %syLDAPFunc, %sySite)

Class dhc.sync.web.DHCLDAP Extends %RegisteredObject
{

// w ##class(dhc.sync.web.DHCLDAP).SaveUser("chenwang1|陈望1|123qwe!@#|1001|1|chenwang1@chcruikang.com||||chenwang1||N|||N||chenwang1|chen|dhcc||YYK5575||123456")

// w ##class(dhc.sync.web.DHCLDAP).EnableUser("chenwang1")

Parameter code As INTEGER = "$zhex(00)";

Parameter HostName = "Ruikang.Chc.Local";

Parameter BaseDN = "OU=CHC-Ruikang,DC=Ruikang,DC=Chc,DC=Local";

Parameter AdminUser = "rk.admin";

/// oa.admin
Parameter AdminPwd = "Welcome@2k";

/// /Welcome@Oa
Parameter Domain = "ruikang";

Method Save(Type, Data)
{
	if Type="U"{
		set rtn = ..SaveUser(Data)
	}elseif(Type="D"){
		set rtn = ..SaveDep(Data)
	}
	quit rtn
}

ClassMethod ModifyPassword(UserCode, password)
{
	Set LD = ##class(%SYS.LDAP).Init(..#HostName,636)  //建立和LDAP 的链接 389
	Set UserPwd = $lb(..#AdminUser,..#Domain,..#AdminPwd)
 	Set Status = ##class(%SYS.LDAP).Binds(LD,"",UserPwd,$$$LDAPAUTHNEGOTIATE)
 	set BaseDN = ..#BaseDN
 	set scope =$$$LDAPSCOPESUBTREE
 	Set Filter="sAMAccountname="_UserCode
 	set Attr = $lb("name")
 	set Status = ##class(%SYS.LDAP).SearchExts(LD,BaseDN,scope,Filter,Attr,0,"","",10,4,.SearchResult)
 	set NumEntries=##Class(%SYS.LDAP).CountEntries(LD,SearchResult)
 	if (NumEntries>0) {
	 	set CurrentEntry=##Class(%SYS.LDAP).FirstEntry(LD,SearchResult)
	 	Set DN =##Class(%SYS.LDAP).GetDN(LD,CurrentEntry)
	 	s ChangePassword=$zcvt(""""_password_"""","o","UnicodeLittle")
		s A0=$lb(130,"unicodePwd",$lb(ChangePassword)) 
		s Status=##Class(%SYS.LDAP).ModifyExts(LD,DN,$lb(A0),"","")
 	}
 	s Status=##Class(%SYS.LDAP).MsgFree(SearchResult)
 	s Status=##Class(%SYS.LDAP).UnBinds(LD)
 	q Status
}

ClassMethod EnableUser(UserCode)
{
	Set LD = ##class(%SYS.LDAP).Init(..#HostName,636)  //建立和LDAP 的链接 389
	Set UserPwd = $lb(..#AdminUser,..#Domain,..#AdminPwd)
 	Set Status = ##class(%SYS.LDAP).Binds(LD,"",UserPwd,$$$LDAPAUTHNEGOTIATE)
 	set BaseDN = ..#BaseDN
 	set scope =$$$LDAPSCOPESUBTREE
 	Set Filter="sAMAccountname="_UserCode
 	set Attr = $lb("name")
 	set Status = ##class(%SYS.LDAP).SearchExts(LD,BaseDN,scope,Filter,Attr,0,"","",10,4,.SearchResult)
 	set NumEntries=##Class(%SYS.LDAP).CountEntries(LD,SearchResult)
 	if (NumEntries>0) {
	 	set CurrentEntry=##Class(%SYS.LDAP).FirstEntry(LD,SearchResult)
	 	Set DN =##Class(%SYS.LDAP).GetDN(LD,CurrentEntry)
	 	s A16=$lb(2,"userAccountControl",$lb(512+65536)) ;66048
	 	s Status=##Class(%SYS.LDAP).ModifyExts(LD,DN,$lb(A16),"","")
 	}
 	s Status=##Class(%SYS.LDAP).MsgFree(SearchResult)
 	s Status=##Class(%SYS.LDAP).UnBinds(LD)
 	q Status
}

// w ##class(dhc.sync.web.DHCLDAP).SaveUser("wanghuicai^汪会财^123qwe!@#^10020100^3^wanghuicai@chcruikang.com^^^01^whc^^Y^166^999^Y^^huicai^wang^dhcc^lll^FFC7687^^13807998989")

ClassMethod SaveUser(Data)
{
	
	Set Data = $tr(Data,"|","^")
	Set ^Wanghc("OALDAP","User")=Data
	Set UserCode = $Piece(Data,"^",1), Name = $Piece(Data,"^",2), Password = $Piece(Data,"^",3)
	;Set Password = ..RSADecrypt(Password)
	Set Deptcode = $Piece(Data,"^",4), State = $Piece(Data,"^",5), Email = $Piece(Data,"^",6)
	Set InvalidDate = $Piece(Data,"^",7), EegDate = $Piece(Data,"^",8), Type = $Piece(Data,"^",9),Mnemonics=$Piece(Data,"^",10)
	Set HealthType=$Piece(Data,"^",11), IsExpert=$Piece(Data,"^",12),/*专家*/ SecGroupDesc=$Piece(Data,"^",13)
	Set Certificate=$Piece(Data,"^",14)/*医师资格证号*/,IsDrugRight=$Piece(Data,"^",15)/*毒麻处方权*/,Number=$Piece(Data,"^",16)
	Set Ename = $Piece(Data,"^",17),Fname=$Piece(Data,"^",18)
	set Company = $Piece(Data,"^",19), Position = $Piece(Data,"^",20),Dleader = $Piece(Data,"^",21)
	set Cellphone = $Piece(Data,"^",22),Landline = $Piece(Data,"^",23)
	Set now = +$h,nowtime=$p($h,",",2)	
	set DeptId = $o(^dhcsyncLocI("syncLocIdx",Deptcode,""))
	SEt DeptDesc = $lg(^dhcsyncLocD(DeptId),3)
	Set UserCode = $p(Data,"^",1)
	;10.1.80.195
	Set LD = ##class(%SYS.LDAP).Init("10.1.80.195",389)  //建立和LDAP 的链接 389 636
	Set UserPwd = $lb(..#AdminUser,..#Domain,..#AdminPwd)
	Set BaseDN= ..#BaseDN
 	Set Status = ##class(%SYS.LDAP).Binds(LD,BaseDN,UserPwd,$$$LDAPAUTHNEGOTIATE)
 	set scope =$$$LDAPSCOPESUBTREE ; $zhex(02)
 	Set Filter="sAMAccountname="_UserCode
 	set Attr = $lb("name")
 	s Status = ##class(%SYS.LDAP).SearchExts(LD,BaseDN,scope,Filter,Attr,0,"","",10,4,.SearchResult)
 	s NumEntries=##Class(%SYS.LDAP).CountEntries(LD,SearchResult)
 	if ($l(Deptcode)>=4){
	 	Set levelDeptCode1 = $e(Deptcode,1,4)
		set LevelDeptId1 = $o(^dhcsyncLocI("syncLocIdx",levelDeptCode1,""))
		SEt DeptDesc1 = $lg(^dhcsyncLocD(LevelDeptId1),3)
		Set levelDeptCode0 = $e(Deptcode,1,2)
		set LevelDeptId0 = $o(^dhcsyncLocI("syncLocIdx",levelDeptCode0,""))
		SEt DeptDesc0 = $lg(^dhcsyncLocD(LevelDeptId0),3) 
 		set BaseDN = "OU="_DeptDesc1_",OU="_DeptDesc0_","_BaseDN ;"OU=CHC-Ruikang,DC=Ruikang,DC=Chc,DC=Local"
	}
 	b ;Num
 	if (NumEntries<1){
	    s op=0
	    s A1 =$lb(op,"objectClass",$lb("top","person","organizationalPerson","user"))
	    S DN = "CN="_Fname_""_Ename_" "_Name_","_BaseDN	
		s A2 =$lb(op,"distinguishedName",$lb(DN))
		s A3=$lb(op,"sAMAccountName",$lb(UserCode))
 	}elseif (NumEntries=1) {
	 	set op=2
	 	set CurrentEntry=##Class(%SYS.LDAP).FirstEntry(LD,SearchResult)
	 	Set DN =##Class(%SYS.LDAP).GetDN(LD,CurrentEntry)
		s A2 =$lb(op,"distinguishedName",$lb(DN))
	}
	s A4 =$lb(op,"company",$lb(Company)) ;"瑞康医院"
	s A5 =$lb(op,"displayName",$lb(Fname_" "_Ename_" "_Name))
   	s A6 =$lb(op,"givenName",$lb(Ename))
	s A7 =$lb(op,"homePhone",$lb(Landline))
	s A8 =$lb(op,"mobile",$lb(Cellphone))
	s A9 =$lb(op,"mail",$lb(Email))
	;s A10 =$lb(op,"name",$lb(Ename)) ; 只读
    s A11 =$lb(op,"sn",$lb(Fname))
    s A12 =$lb(op,"title",$lb(Position))
	s A13 =$lb(op,"telephoneNumber",$lb(Cellphone))
	s A14 =$lb(op,"userPrincipalName",$lb(Email))
	s A15=$lb(op,"department",$lb(DeptDesc))
	if (NumEntries<1){
	 	s Status=##Class(%SYS.LDAP).AddExts(LD,DN,$lb(A1,A2,A3,A4,A5,A6,A7,A8,A9,A11,A12,A13,A14,A15),"","")
       	b ;add
		s Status = ..ModifyPassword(UserCode,"123qwe!@#")
		b ;add password
		s A16=$lb(2,"userAccountControl",$lb(512+65536)) ;66048
		s Status=##Class(%SYS.LDAP).ModifyExts(LD,DN,$lb(A16),"","")
		b ;userAccountControl
    }elseif (NumEntries=1) {
	 	s Status=##Class(%SYS.LDAP).ModifyExts(LD,DN,$lb(A4,A5,A6,A7,A8,A9,A11,A12,A13,A14,A15),"","")
		b ;modify
		if State=2 { ;del ;if State=1 ;Ins
			s A16=$lb(op,"userAccountControl",$lb(512+4)) ;  546
			s Status=##Class(%SYS.LDAP).ModifyExts(LD,DN,$lb(A16),"","")
		}else { 
			if (Password'=""){
				s Status = ..ModifyPassword(UserCode,Password)
				b ;modify password
			}
			s A16=$lb(2,"userAccountControl",$lb(512+65536)) ;66048
			s Status=##Class(%SYS.LDAP).ModifyExts(LD,DN,$lb(A16),"","")
			b ; enable
		}
		s Status=##Class(%SYS.LDAP).RenameExts(LD,DN,"CN="_Fname_""_Ename_" "_Name,BaseDN,1)
		b ;Rename
	} else{
		g LDAPError
		quit -101
	}
	g LDAPError 
	q 0
	
LDAPError
 i $d(SearchResult) s Status=##Class(%SYS.LDAP).MsgFree(SearchResult)
 i +$d(LD) s Status=##Class(%SYS.LDAP).UnBinds(LD)
 q 0
}

//w ##class(dhc.sync.web.DHCLDAP).SaveDep("AdminDep^Administrative DepartmentsNew^^0^1^^O^^^^^XZKS^2010-05-17^^^^Y")

//w ##class(dhc.sync.web.DHCLDAP).SaveDep("1001^1001 Administration -行政部^1^10^1^^O^行政部^04^^^XZB^2010-05-17^^^^Y")

ClassMethod SaveDep(Data)
{
	Set ^Wanghc("OALDAP","Dep")=Data
	;sET Data = $tr(Data,"|",)
	Set Code = $Piece(Data,"^",1), Name = $Piece(Data,"^",2), LocLevel = $Piece(Data,"^",3)
	;0,1 sync ldap
	Q:(+LocLevel'=0)&&(+LocLevel'=1) 0
	Set Super = $Piece(Data,"^",4), State = $Piece(Data,"^",5), IsLast = $Piece(Data,"^",6)
	Set Type =  $Piece(Data,"^",7),DGroup=$Piece(Data,"^",8),Classify=$Piece(Data,"^",9),Address = $Piece(Data,"^",10)
	Set Phone=$Piece(Data,"^",11),Mnemonics=$Piece(Data,"^",12),StartDate = $Piece(Data,"^",13)
	Set EndDate = $Piece(Data,"^",14),Storey=$Piece(Data,"^",15),Cataloguo=$Piece(Data,"^",16),Dept=$Piece(Data,"^",17)
	;389端口----用10.1.80.195	   ---保存一般数据
	;636端口----用Ruikang.Chc.Local---保存密码---如果保存一般数据,会出问题，找不到Entry
	Set LD = ##class(%SYS.LDAP).Init("10.1.80.195",389)  //建立和LDAP 的链接 389 636
	Set UserPwd = $lb(..#AdminUser,..#Domain,..#AdminPwd)
	set BaseDN = ..#BaseDN  		;"OU=CHC-Ruikang,DC=Ruikang,DC=Chc,DC=Local"
 	Set Status = ##class(%SYS.LDAP).Binds(LD,BaseDN,UserPwd,$$$LDAPAUTHNEGOTIATE)
 	if (+LocLevel=1){
	 	set SuperDeptId = $o(^dhcsyncLocI("syncLocIdx",Super,""))
	 	SEt SuperDeptDesc = $lg(^dhcsyncLocD(SuperDeptId),3)
	 	Set DN = "OU="_Name_",OU="_SuperDeptDesc_","_BaseDN
	}elseif(+LocLevel=0){
 		Set DN = "OU="_Name_","_BaseDN
	}
	;Set Status = ##class(%SYS.LDAP).DeleteExts(LD,DN)
	;b ;del Status
 	set scope =$$$LDAPSCOPESUBTREE  ; $zhex(02)
 	Set Filter="displayName="_Code
 	set Attr = $lb("ou")
 	s Status = ##class(%SYS.LDAP).SearchExts(LD,BaseDN,scope,Filter,Attr,0,"","",10,1,.SearchResult)
 	s NumEntries=##Class(%SYS.LDAP).CountEntries(LD,SearchResult)
 	if (NumEntries=0){
	    s op=0							 
		;s A1 =$lb(op,"objectCategory",$lb("CN=Organizational-Unit,CN=Schema,CN=Configuration,DC=Chc,DC=Local"))
		s A2 =$lb(op,"objectClass",$lb("top","organizationalUnit"))
		s A3 =$lb(op,"ou",$lb(Name))
		s A4 =$lb(op,"displayName",$lb(Code))
	 	s Status=##Class(%SYS.LDAP).AddExts(LD,DN,$lb(A2,A4),"","")
		b ;add
    }elseif (NumEntries=1) {
	 	set CurrentEntry=##Class(%SYS.LDAP).FirstEntry(LD,SearchResult)
	 	Set CurrDN =##Class(%SYS.LDAP).GetDN(LD,CurrentEntry)
	 	s Status=##Class(%SYS.LDAP).RenameExts(LD,CurrDN,"OU="_Name,"",1)
	 	b ;mid
	} else{
		g LDAPError
		quit -101
	}
	g LDAPError 
	q 0
	
LDAPError
 i $d(SearchResult) s Status=##Class(%SYS.LDAP).MsgFree(SearchResult)
 i +$d(LD) s Status=##Class(%SYS.LDAP).UnBinds(LD)
 q Status
}

}
