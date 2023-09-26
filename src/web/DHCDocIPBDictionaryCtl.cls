Import SQLUser

/// 公共字典Ctl
/// 2008-3-27 Liyang
/// update by lxf 2008-10-15
Class web.DHCDocIPBDictionaryCtl Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 61;

/// 通过字典类型/是否活动获取字典列表
/// Type：字典类型
/// Flag：是否活动 是：Y，否：N
ClassMethod QueryByType(Type, Flag, stateFlag As %String = "")
{
		n (Type, Flag,stateFlag,%session)
	    s iCount=..QueryByTypeAA(Type, Flag,stateFlag)
		s s=""
		f i=0:1:iCount d
		.s s=s_$g(PLIST(i))_$c(1)
		q s
}

ClassMethod QueryAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryAllExecute(ByRef qHandle As %Binary, HospID = "") As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s Rowid=0
	f  s Rowid=$o(^DHCDocIPBDIC(Rowid)) q:Rowid=""  d
	.;Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHCDocIPBDictory",Rowid,HospID)
	.s str=$g(^DHCDocIPBDIC(+Rowid))
	.s Code=$p(str,"^",1)
	.s Desc=$p(str,"^",2)
	.s Type=$p(str,"^",3)
	.s Active=$p(str,"^",4)
	.s DateFrom=$p(str,"^",5)
	.s:DateFrom'="" DateFrom=..%ZD(DateFrom) //$zd(DateFrom,4)
	.s DateTo=$p(str,"^",6)
	.s:DateTo'="" DateTo=..%ZD(DateTo) //$zd(DateTo,4)
	.s StrA=$p(str,"^",7)
	.s StrB=$p(str,"^",8)
	.s StrC=$p(str,"^",9)
	.s StrD=$p(str,"^",10)
	.s Data=$lb(Rowid,Code,Desc,Type,Active,DateFrom,DateTo,StrA,StrB,StrC,StrD)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
    Quit $$$OK
}

ClassMethod QueryAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：    刘学峰
/// CreatDate：  2008-10-15
/// Description：查询DHCDocIPBDictory中所有字典项Query
/// Table：      DHCDocIPBDictory
/// Input：      无
/// Output：     Rowid,Code,Desc,Type,Active,DateFrom,DateTo,StrA,StrB,StrC,StrD
Query QueryAll(HospID = "") As %Query(ROWSPEC = "Rowid,Code,Desc,Type,Active,DateFrom,DateTo,StrA,StrB,StrC,StrD")
{
}

/// Creator：    刘学峰
/// CreatDate：  2008-10-15
/// Description：查询DHCDocIPBDictory中所有字典项
/// Table：      DHCDocIPBDictory
/// Input：      Type(字典类型),Flag(是否有效，可以为空)
/// Output：     字典项字符串，"^"分隔;各条数据$c(1)分割
ClassMethod QueryMedDicList(Type, Flag)
{
	;^DHCDocIPBDIC("0","TYPE",{MDIC_Type},{MDIC_Active},{MDIC_Rowid})
	n (Type,Flag)
	s ret=""	
	s Rowid=0
	s FlagTemp=""
	f  s FlagTemp=$o(^DHCDocIPBDIC("0","TYPE",Type,FlagTemp)) q:FlagTemp=""  d
	.f  s Rowid=$o(^DHCDocIPBDIC("0","TYPE",Type,FlagTemp,Rowid)) q:Rowid=""  d
	..s str=$g(^DHCDocIPBDIC(Rowid))
	..s IsActive=$p(str,"^",4)
	..q:(IsActive'=Flag)&&(Flag'="")	//此句话保证根据传入Flag为空、"Y","N"时查询
	..s Code=$p(str,"^",1)
	..s Desc=$p(str,"^",2)
	..s Type=$p(str,"^",3)
	..s Active=$p(str,"^",4)
	..s DateFrom=$p(str,"^",5)
	..s DateTo=$p(str,"^",6)
	..s StrA=$p(str,"^",7)
	..s StrB=$p(str,"^",8)
	..s StrC=$p(str,"^",9)
	..s StrD=$p(str,"^",10)
	..s ret=ret_Rowid_"^"_Code_"^"_Desc_"^"_Type_"^"_Active_"^"_DateFrom_"^"_DateTo_"^"_StrA_"^"_StrB_"^"_StrC_"^"_StrD_$c(1)
	s ret=$e(ret,1,$l(ret)-1)
	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2008-10-21
/// Description：添加或修改字典项(添加数据时MedRowid设空值)
/// Table：      DHCDocIPBDictory
/// Input：      Rowid^Code^Desc^Type^Active^DateFrom^DateTo^StrA^StrB^StrC^StrD
/// Output：     -1/SQLCODE/WMRRowid
/// Debug:		 w ##class(web.DHCDocIPBDictionaryCtl).Update("1^IPBookingDataType^住院预约数据类型^SYS^true^2009-01-01^2099-01-01^1^2^3^2")
ClassMethod Update(InPut, HospID = "")
{

	n (InPut,HospID)
	;s ^TEMP("QP",111)=InPut
	s s=..UpdateAA(InPut,HospID)
	q s
}

/// ***************************************
/// 功能说明：根据MedRowid获取字典项
/// 入参：MedRowid
/// 出参：Rowid^Code^Desc^Type^Active^DateFrom^DateTo^StrA^StrB^StrC^StrD
/// 调试：w ##class(web.DHCDocIPBDictionaryCtl).GetDataById("MedRowid")
/// *****************************************
ClassMethod GetDataById(InPut)
{

	n (InPut)
	s s=..GetDataByIdAA(InPut)
	q s
}

/// Creator：    刘学峰
/// CreatDate：  2008-10-29
/// Description：根据MedRowid获取字典项
/// Table：      DHCDocIPBDictory
/// Input：      Rowid
/// Output：     Rowid^Code^Desc^Type^Active^DateFrom^DateTo^StrA^StrB^StrC^StrD
/// 		     其中DateFrom和DateTo数据格式为第4种“/”分割形式(Date组件日期显示类型)
/// Debug:		 w ##class(web.DHCDocIPBDictionaryCtl).GetDicDataById("MedRowid")
ClassMethod GetDicDataById(Rowid)
{
	n (Rowid)
    q:'$d(^DHCDocIPBDIC(Rowid)) ""
    s str=$g(^DHCDocIPBDIC(Rowid))
    s:$p(str,"^",5)'="" $p(str,"^",5)=..%ZD($p(str,"^",5)) //$zd($p(str,"^",5),4)
    s:$p(str,"^",6)'="" $p(str,"^",6)=..%ZD($p(str,"^",6)) //$zd($p(str,"^",6),4)
    s str=Rowid_"^"_str
    q str
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-08
/// Description：根据“字典类别”和"代码"取DHCDocIPBDictory表RowID 			 
/// Table：      DHCDocIPBDictory
/// Input：      MDicType, MDicCode
/// Return：     RowID/-1(Error)
/// Debug:		 w ##class(web.DHCDocIPBDictionaryCtl).GetMedDicIDByCode(MDicType, MDicCode)
ClassMethod GetMedDicIDByCode(MDicType, MDicCode)
{
	;^DHCDocIPBDIC("0","TypeCode",{MDIC_Type},{MDIC_Code},{MDIC_Rowid}) 
	n (MDicType,MDicCode)
	s ret=-1
	q:MDicType="" ret
	q:MDicCode="" ret
	q:'$d(^DHCDocIPBDIC("0","TypeCode",MDicType,MDicCode)) ret
	s RowID=0
	s RowID=$o(^DHCDocIPBDIC("0","TypeCode",MDicType,MDicCode,RowID))
	q RowID
}

/// ****************************************************
/// 更新字典信息
ClassMethod UpdateAA(InString, HospID = "")
{
    n (InString,HospID)  
    s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHCDocIPBDictory",HospID)
    s MDICRowid=$p(InString,"^",1)
    s PLIST(2)=$p(InString,"^",2)      ;代码                  
    s PLIST(3)=$p(InString,"^",3)      ;描述                 
    s PLIST(4)=$p(InString,"^",4)      ;字典类别             
    s PLIST(5)=$p(InString,"^",5)      ;状态                
    s PLIST(6)=$p(InString,"^",6)      ;起始日期 	update by lxf 2008-10-29
    s PLIST(7)=$p(InString,"^",7)      ;截止日期  	update by lxf 2008-10-29
    if (PLIST(6)'="") s PLIST(6)=..%ZDH(PLIST(6))
    if (PLIST(7)'="") s PLIST(7)=..%ZDH(PLIST(7))
    Q:(PLIST(6)'="")&&(PLIST(7)'="")&&(PLIST(6)>PLIST(7)) "截止日期不能早于起始日期!"
    s PLIST(8)=$p(InString,"^",8)      ;            
    s PLIST(9)=$p(InString,"^",9)      ;            
    s PLIST(10)=$p(InString,"^",10)   ;            
    s PLIST(11)=$p(InString,"^",11)    ;  
    q:($d(^DHCDocIPBDIC("0","TypeCode",PLIST(4),PLIST(2))))&(MDICRowid="") -1
    i MDICRowid="" d
    .&sql(Insert into DHCDocIPBDictory values :PLIST())
    .if 'SQLCODE d
    ..d ##class(DHCDoc.Common.Hospital).SaveHOSP("DHCDocIPBDictory",$p(%ROWID,$c(1)),HospID)
    e  d
    .&sql(Update DHCDocIPBDictory values :PLIST() where MDIC_Rowid=:MDICRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

/// 通过字典类型，是否活动查询字典列表
/// update by zf 2008-12-09 按Code排序
ClassMethod QueryByTypeAA(Type, Flag, stateFlag As %String = "")
{
    ;k (Type,Flag)
    k PLIST,MLIST
    k ^CacheTemp($zn,$j)
    ;Index TYPE  : ^DHCDocIPBDIC("0","TYPE",{MDIC_Type},{MDIC_Active},{MDIC_Rowid})                           
    q:Type="" -1
    q:'$d(^DHCDocIPBDIC("0","TYPE",Type)) -100
    ;i Flag'="" d
    ;.q:'$d(^DHCDocIPBDIC("0","TYPE",Type,Flag))
    s n=0
    i Flag="" d
    .s sFlag=""
    .f  s sFlag=$o(^DHCDocIPBDIC("0","TYPE",Type,sFlag))  q:sFlag=""  d
    ..s MDICRowid=""
    ..f  s MDICRowid=$o(^DHCDocIPBDIC("0","TYPE",Type,sFlag,MDICRowid))  q:MDICRowid=""  d
    ...;s MLIST(n)=$$GetDataById(MDICRowid)
    ...;s n=n+1
    ...q:MDICRowid=""
    ...s DicCode=$p($g(^DHCDocIPBDIC(MDICRowid)),"^",1)
    ...q:DicCode=""
    ...s ^CacheTemp($zn,$j,DicCode,MDICRowid)=MDICRowid
    e  d
    .q:'$d(^DHCDocIPBDIC("0","TYPE",Type,Flag)) 
    .s MDICRowid=""
    .f  s MDICRowid=$o(^DHCDocIPBDIC("0","TYPE",Type,Flag,MDICRowid))  q:MDICRowid=""  d
    ..;s MLIST(n)=$$GetDataById(MDICRowid)
    ..;s n=n+1
    ..q:MDICRowid=""
    ..s DicCode=$p($g(^DHCDocIPBDIC(MDICRowid)),"^",1)
    ..q:DicCode=""
    ..;Set GroupFlag=0
    ..;if Type="IPBookingState" do
    ..;.Set FZ1=$p($g(^DHCDocIPBDIC(MDICRowid)),"^",7)
    ..;.Set GroupDesc=%session.Get("LOGON.GROUPDESC")
    ..;.if (","_FZ1_",")[(","_GroupDesc_",") do
    ..;..Set GroupFlag=1
    ..;Quit:(Type="IPBookingState")&&(GroupFlag'=1)
    ..s ^CacheTemp($zn,$j,DicCode,MDICRowid)=MDICRowid
    
    s tmpCode=""
    f  s tmpCode=$o(^CacheTemp($zn,$j,tmpCode)) q:tmpCode=""  d
    .s tmpRowid=0
    .f  s tmpRowid=$o(^CacheTemp($zn,$j,tmpCode,tmpRowid)) q:tmpRowid=""  d
    ..s MLIST(n)=..GetDataByIdAA(tmpRowid)
    ..s n=n+1
    k ^CacheTemp($zn,$j)
    
    m PLIST=MLIST
    k MLIST
    q n-1
}

/// 通过字典类型、代码查询字典项
ClassMethod QueryByTypeCodeAA(Type, Code)
{
    n (Type,Code)
    k PLIST,MLIST
    ;Index Type-Code : ^DHCDocIPBDIC("0","TypeCode",{MDIC_Type},{MDIC_Code},{MDIC_Rowid})
    q:(Type="")!(Code="") -1
    q:'$d(^DHCDocIPBDIC("0","TypeCode",Type,Code)) -100
    s MDICRowid=$o(^DHCDocIPBDIC("0","TypeCode",Type,Code,""),-1)
    s s=..GetDataByIdAA(MDICRowid)
    q s
    ;s MDICRowid=""
    ;f  s MDICRowid=$o(^DHCDocIPBDIC("0","TypeCode",Type,Code,MDICRowid))  q:MDICRowid=""  d
    ;.s MLIST(n)=$$GetDataById(MDICRowid)
    ;.s n=n+1
    ;m PLIST=MLIST
    ;q n-1
}

/// 通过RowID获取字典项目
ClassMethod GetDataByIdAA(MDICRowid)
{
    n (MDICRowid,%session)
    q:'$d(^DHCDocIPBDIC(MDICRowid)) ""
    Set langid=..%LanguageID()
    s s=$g(^DHCDocIPBDIC(MDICRowid))
    s:$p(s,"^",5)'="" $p(s,"^",5)=$zd($p(s,"^",5),3)
    s:$p(s,"^",6)'="" $p(s,"^",6)=$zd($p(s,"^",6),3)
    s:$p(s,"^",2)'="" $p(s,"^",2)=##class(User.DHCDocIPBDictory).GetTranByDesc("MDICDesc",$p(s,"^",2),langid)
    s s=MDICRowid_"^"_s
    q s
}

ClassMethod GetStateByGroupDesc(GroupDesc As %String)
{
	Set MDICRowid=0
	Set rtn=""
	f  s MDICRowid=$o(^DHCDocIPBDIC("0","TYPE","IPBookingState","Y",MDICRowid))  q:MDICRowid=""  d
    .q:MDICRowid=""
    .s DicCode=$p($g(^DHCDocIPBDIC(MDICRowid)),"^",1)
    .q:DicCode=""
    .Set GroupFlag=0
    .Set FZ1=$p($g(^DHCDocIPBDIC(MDICRowid)),"^",7)
    .Set GroupDesc=%session.Get("LOGON.GROUPDESC")
    .if (","_FZ1_",")[(","_GroupDesc_",") do
    ..Set GroupFlag=1
    .Quit:GroupFlag'=1
    .if rtn="" Set rtn=MDICRowid
    .else  Set rtn=rtn_"^"_MDICRowid
    Quit rtn
}

/// CTOR: QP
/// DATE: 2018-08-14
/// DESC: 查询DHCDocIPBDictory中所有字典项
/// IN  : Type(字典类型),Flag(是否有效，可以为空)
/// TABL: DHCDocIPBDictory
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("web.DHCDocIPBDictionaryCtl","QryIPBDic","SYS")
Query QryIPBDic(type As %String, flag As %String = "") As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryIPBDicExecute(ByRef qHandle As %Binary, type As %String, flag As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1 
    Set qHandle=$lb(0,repid,0)
    
	s Rowid=0
	s FlagTemp=""
	f  s FlagTemp=$o(^DHCDocIPBDIC("0","TYPE",type,FlagTemp)) q:FlagTemp=""  d
	.f  s Rowid=$o(^DHCDocIPBDIC("0","TYPE",type,FlagTemp,Rowid)) q:Rowid=""  d
	..s str=$g(^DHCDocIPBDIC(Rowid))
	..s IsActive=$p(str,"^",4)
	..q:(IsActive'=flag)&&(flag'="")	//此句话保证根据传入Flag为空、"Y","N"时查询
	..s Code=$p(str,"^",1)
	..s Desc=$p(str,"^",2)
	..s Type=$p(str,"^",3)
	..s Active=$p(str,"^",4)
	..s DateFrom=$p(str,"^",5)
	..s DateTo=$p(str,"^",6)
	..s StrA=$p(str,"^",7)
	..s StrB=$p(str,"^",8)
	..s StrC=$p(str,"^",9)
	..s StrD=$p(str,"^",10)
	..d OutputRow1
   	s Code="SYS",Desc="根字典"
   	d OutputRow1
    Quit $$$OK
OutputRow1
    set Data=$lb(Code,Desc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryIPBDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIPBDicExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryIPBDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIPBDicExecute ]
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

}
