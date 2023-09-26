Class dhc.bonus.uinter.uGetZYGZLData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 住院处工作量接口
/// w ##class(dhc.bonus.uinter.uGetZYGZLData).GetZYGZLData("2013-03-01","2013-03-31","4")
ClassMethod GetZYGZLData(sttdate As %String, enddate As %String, sMethodDr As %String) As %String
{
	n (sttdate,enddate,sMethodDr)
	s MethodDr=sMethodDr
    s CurrentDate=sttdate
	s CurrentY=$p(CurrentDate,"-",1)
	s CurrentM=$p(CurrentDate,"-",2)
	s CurrentD=$p(CurrentDate,"-",3)
	s Month="M"_CurrentM
	s YM=CurrentY_CurrentM
	s YMD=CurrentY_CurrentM_CurrentD
	
	s sttdate=$zdh(sttdate,3)
    s enddate=$zdh(enddate,3)
    k ^TMPBONUSZYGZL
    
    
    
    ;b ;w !,"统计入,退院部分" 
    f date=sttdate:1:enddate  d
	.s adm=""  f  s adm=$o(^PAADMi("NNType","I",date,adm)) q:adm=""  d
	..s VisitStatus="",RegUserdr="",RegUserdr="",CancelUserdr="",RegUser="",CancelUser=""
	..s VisitStatus=$P(^PAADM(adm),"^",20)
	..s RegUserdr=$P(^PAADM(adm),"^",43)
	..s:$g(VisitStatus)="C" CancelUserdr=$P(^PAADM(adm,1),"^",44)
	..s:$g(RegUserdr)'="" RegUser=$P(^SSU("SSUSR",RegUserdr),"^",1)
	..s:$g(CancelUserdr)'="" CancelUser=$P(^SSU("SSUSR",CancelUserdr),"^",1)
	..s:RegUser'="" ^TMPBONUSZYGZL("XZ006",RegUser)=+$g(^TMPBONUSZYGZL("XZ006",RegUser))+1
	..s:(CancelUser)'="" ^TMPBONUSZYGZL("XZ008",CancelUser)=+$g(^TMPBONUSZYGZL("XZ008",CancelUser))+1
	.//---------------------------------------------------------------
	;b ;w !,"统计结算,取消结算部分" 
	f date=sttdate:1:enddate  d
    .s prtid=""  f  s prtid=$o(^DHCINVPRTZY(0,"DATE",date,prtid))  q:prtid=""  d
    ..s prtflag="",JSusrdr="",HCusrdr="",JSUser="",HCUser=""
    ..s prtflag=$P(^DHCINVPRTZY(prtid),"^",8)
    ..q:prtflag="A"
    ..s:prtflag="N" JSusrdr=$P(^DHCINVPRTZY(prtid),"^",7)
    ..s:prtflag="S" HCusrdr=$P(^DHCINVPRTZY(prtid),"^",7)
    ..s:$g(JSusrdr)'="" JSUser=$P(^SSU("SSUSR",JSusrdr),"^",1)
    ..s:$g(HCusrdr)'="" HCUser=$P(^SSU("SSUSR",HCusrdr),"^",1)
    ..s:$g(JSUser)'="" ^TMPBONUSZYGZL("XZ004",JSUser)=+$g(^TMPBONUSZYGZL("XZ004",JSUser))+1
    ..s:$g(HCUser)'="" ^TMPBONUSZYGZL("XZ005",HCUser)=+$g(^TMPBONUSZYGZL("XZ005",HCUser))+1
    
    
    
    .//---------------------------------------------------------------
    
    ;b ;w !,"统计交,退押金部分" 
    f date=sttdate:1:enddate  d
    .s prtyjid="" f  s prtyjid=$O(^DHCSFPRINTDETAIL(0,"PrtDate",date,prtyjid))  q:prtyjid=""  d
    ..s prtstatus="",yjadduserdr="",yjadduser=""
    ..s prtstatus=$p(^DHCSFPRINTDETAIL(prtyjid),"^",8)
    ..s yjadduserdr=$p(^DHCSFPRINTDETAIL(prtyjid),"^",14)
    ..s yjadduser=$P(^SSU("SSUSR",yjadduserdr),"^",1)
    ..s:((prtstatus=1)!(prtstatus=4))&(yjadduser'="") ^TMPBONUSZYGZL("XZ002",yjadduser)=+$g(^TMPBONUSZYGZL("XZ002",yjadduser))+1
    ..s:((prtstatus=2)!(prtstatus=3))&(yjadduser'="") ^TMPBONUSZYGZL("XZ007",yjadduser)=+$g(^TMPBONUSZYGZL("XZ007",yjadduser))+1
    
    
    
    .//------------------------------------------------------------------
    
    
    
    ;b ;w !,"统计担保部分" 
    f date=sttdate:1:enddate  d
    .s dbprtid=""  f  s dbprtid=$O(^DHCWARRANT(0,"DATA",date,dbprtid)) q:dbprtid=""  d
    ..s warrstatus="",warruserdr="",warruser=""
    ..s warrstatus=$P(^DHCWARRANT(dbprtid),"^",8)
    ..s warruserdr=$P(^DHCWARRANT(dbprtid),"^",7)
    ..s warruser=$P(^SSU("SSUSR",warruserdr),"^",1)
    ..s:warruser'="" ^TMPBONUSZYGZL("XZ001",warruser)=+$g(^TMPBONUSZYGZL("XZ001",warruser))+1
    .//------------------------------------------------------------------
    
    ;b ;w !,"统计接收执行部分" 
    f date=sttdate:1:enddate  d
    .s ord=""  f  s ord=$O(^OEORDi(0,"StDt",date,ord))  q:ord=""  d
    ..s sub=""  f  s sub=$O(^OEORDi(0,"StDt",date,ord,sub))  q:sub=""  d
    ...s reloc="",RecUserdr="",RecUser=""
    ...s reloc=$p(^OEORD(ord,"I",sub,3),"^",6)
    ...q:reloc'=14
    ...s RecUserdr=$p(^OEORD(ord,"I",sub,6),"^",4)
    ...s:RecUserdr'="" RecUser=$P(^SSU("SSUSR",RecUserdr),"^",1)
    ...s:RecUser'="" ^TMPBONUSZYGZL("XZ003",RecUser)=+$g(^TMPBONUSZYGZL("XZ003",RecUser))+1
    
    
    
    /*----------------------------------------------------------------------------------------*/
    k ^TMPDHCENSJX(YMD,"ZYGZLATA")
    s num=0
    s type=""  f  s type=$O(^TMPBONUSZYGZL(type)) q:type=""  d
    .s user="" f  s user=$O(^TMPBONUSZYGZL(type,user)) q:user=""  d
    ..;w !,$e($zd(sttdate,3),1,7)_$c(9)_type_$c(9)_user_$c(9)_$g(^TMPDHCBONUS(type,user))
    ..s num=num+1
    ..s ^TMPDHCENSJX(YM,"ZYGZLATA",num)=YM_",14,"_user_","_type_","_$g(^TMPDHCBONUS(type,user))	
	..;w !,^TMPDHCENSJX(YM,"ZYGZLATA",num)
	
	..;s ^TMPBONUSZYGZL(YMD,"ZYGZL",userCode)=$G(^TMPBONUSZYGZL(YMD,"ZYGZL",userCode))+1
	
	//-----------------------------------------------------------
	;
	
	
	;导入数据前清除
	&sql(delete from dhc_bonus_subs.BonusSubExpendCollect where BonusYear=:CurrentY and BonusPeriod=:Month and ExpendItemCode in ('08010','08020','08030','08040','08050','08060','08070','08080') )
	
	;插入住院退院数据
	s ItemCode="" 
	f  s ItemCode=$O(^TMPBONUSZYGZL(ItemCode)) q:ItemCode=""  d
	.s DorCode=""
	.f  s DorCode=$O(^TMPBONUSZYGZL(ItemCode,DorCode)) q:DorCode=""  d
    ..s DorName=""
	..i $D(^dhcbsBonusUnitI("BonusUnitCode",DorCode)) d 
	...s rowid="" 
	...s rowid=$O(^dhcbsBonusUnitI("BonusUnitCode",DorCode,rowid))
	...i rowid'="" d
	....s DorName=$LI(^dhcbsBonusUnitD(rowid),3)
	
	..s itemValue=$G(^TMPBONUSZYGZL(ItemCode,DorCode))
	..i ItemCode="XZ001"  d
	...s ItemNo="08010",ItemDesc="担保数量" ; 
	..i ItemCode="XZ002"  d
	...s ItemNo="08020",ItemDesc="交押金数量" ; 
	..i ItemCode="XZ003"  d
	...s ItemNo="08030",ItemDesc="接收数量" ; 
	..i ItemCode="XZ004"  d
	...s ItemNo="08040",ItemDesc="结算数量" ; 
	..i ItemCode="XZ005"  d
	...s ItemNo="08050",ItemDesc="取消结算数量" ; 
	..i ItemCode="XZ006"  d
	...s ItemNo="08060",ItemDesc="入院数量" ; 
	..i ItemCode="XZ007"  d
	...s ItemNo="08070",ItemDesc="退押金数量" ; 
	..i ItemCode="XZ008"  d
	...s ItemNo="08080",ItemDesc="退院数量" ; 
	..s UnitType=5
	..&sql(insert into dhc_bonus_subs.BonusSubExpendCollect( ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear, BonusPeriod,ItemValue,CollectDate,State,UnitType,InterLocMethodID)
 		values(:ItemNo,:ItemDesc,:DorCode,:DorName,:CurrentY, :Month,:itemValue,getdate(), 0,:UnitType,:MethodDr)
		)

	//--------------------------------------------------------------------------
	
	q num
}

Storage Default
{
<StreamLocation>^dhc.bonus.uin649.uGetZYGZLDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
