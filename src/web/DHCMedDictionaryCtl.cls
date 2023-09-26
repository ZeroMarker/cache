Import SQLUser

/// 公共字典Ctl
/// 2008-3-27 Liyang
/// update by lxf 2008-10-15
Class web.DHCMedDictionaryCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 40;

/// 通过字典类型/是否活动获取字典列表
/// Type：字典类型
/// Flag：是否活动 是：Y，否：N
ClassMethod QueryByType(Type, Flag)
{
		n (Type, Flag)
		Set Config=##Class(websys.Configuration).%OpenId(1)
	    Set MEDDATA=Config.DataNamespace
	    Set LABDATA=Config.LabDataNamespace
	    Set CurrentNS=$ZNSPACE
	    d Config.%Close()
	    zn MEDDATA
	    s iCount=$$QueryByType^DHCMedDictory(Type, Flag)
		zn CurrentNS
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

ClassMethod QueryAllExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s Rowid=0
	f  s Rowid=$o(^DHCMDIC(Rowid)) q:Rowid=""  d
	.s str=$g(^DHCMDIC(+Rowid))
	.s Code=$p(str,"^",1)
	.s Desc=$p(str,"^",2)
	.s Type=$p(str,"^",3)
	.s Active=$p(str,"^",4)
	.s DateFrom=$p(str,"^",5)
	.s:DateFrom'="" DateFrom=$zd(DateFrom,4)
	.s DateTo=$p(str,"^",6)
	.s:DateTo'="" DateTo=$zd(DateTo,4)
	.s StrA=$p(str,"^",7)
	.s StrB=$p(str,"^",8)
	.s StrC=$p(str,"^",9)
	.s StrD=$p(str,"^",10)
	.s str=Rowid_"^"_Code_"^"_Desc_"^"_Type_"^"_Active_"^"_DateFrom_"^"_DateTo_"^"_StrA_"^"_StrB_"^"_StrC_"^"_StrD
    .d BuildData1
    Quit $$$OK
    
BuildData1
	set Data=$lb("")
 	f iBuild=1:1:$l(str,"^") d
 	.s $li(Data,iBuild)=$p(str,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
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
/// Description：查询DHC_MedDictory中所有字典项Query
/// Table：      DHC_MedDictory
/// Input：      无
/// Output：     Rowid,Code,Desc,Type,Active,DateFrom,DateTo,StrA,StrB,StrC,StrD
Query QueryAll() As %Query(ROWSPEC = "Rowid,Code,Desc,Type,Active,DateFrom,DateTo,StrA,StrB,StrC,StrD")
{
}

/// Creator：    刘学峰
/// CreatDate：  2008-10-15
/// Description：查询DHC_MedDictory中所有字典项
/// Table：      DHC_MedDictory
/// Input：      Type(字典类型),Flag(是否有效，可以为空)
/// Output：     字典项字符串，"^"分隔;各条数据$c(1)分割
ClassMethod QueryMedDicList(Type, Flag)
{
	;^DHCMDIC("0","TYPE",{MDIC_Type},{MDIC_Active},{MDIC_Rowid})
	n (Type,Flag)
	s ret=""	
	s Rowid=0
	s FlagTemp=""
	f  s FlagTemp=$o(^DHCMDIC("0","TYPE",Type,FlagTemp)) q:FlagTemp=""  d
	.f  s Rowid=$o(^DHCMDIC("0","TYPE",Type,FlagTemp,Rowid)) q:Rowid=""  d
	..s str=$g(^DHCMDIC(Rowid))
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
/// Table：      DHC_MedDictory
/// Input：      Rowid^Code^Desc^Type^Active^DateFrom^DateTo^StrA^StrB^StrC^StrD
/// Output：     -1/SQLCODE/WMRRowid
/// Debug:		 w ##class(web.DHCMedDictionaryCtl).Update("入参")
ClassMethod Update(InPut)
{

	n (InPut)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s s=$$Update^DHCMedDictory(InPut)
	zn CurrentNS
	q s
}

/// ***************************************
/// 功能说明：根据MedRowid获取字典项
/// 入参：MedRowid
/// 出参：Rowid^Code^Desc^Type^Active^DateFrom^DateTo^StrA^StrB^StrC^StrD
/// 调试：w ##class(web.DHCMedDictionaryCtl).GetDataById("MedRowid")
/// *****************************************
ClassMethod GetDataById(InPut)
{

	n (InPut)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s s=$$GetDataById^DHCMedDictory(InPut)
	zn CurrentNS
	q s
}

/// Creator：    刘学峰
/// CreatDate：  2008-10-29
/// Description：根据MedRowid获取字典项
/// Table：      DHC_MedDictory
/// Input：      Rowid
/// Output：     Rowid^Code^Desc^Type^Active^DateFrom^DateTo^StrA^StrB^StrC^StrD
/// 		     其中DateFrom和DateTo数据格式为第4种“/”分割形式(Date组件日期显示类型)
/// Debug:		 w ##class(web.DHCMedDictionaryCtl).GetDicDataById("MedRowid")
ClassMethod GetDicDataById(Rowid)
{
	n (Rowid)
    q:'$d(^DHCMDIC(Rowid)) ""
    s str=$g(^DHCMDIC(Rowid))
    s:$p(str,"^",5)'="" $p(str,"^",5)=$zd($p(str,"^",5),4)
    s:$p(str,"^",6)'="" $p(str,"^",6)=$zd($p(str,"^",6),4)
    s str=Rowid_"^"_str
    q str
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-08
/// Description：根据“字典类别”和"代码"取DHC_MedDictory表RowID 			 
/// Table：      DHC_MedDictory
/// Input：      MDicType, MDicCode
/// Return：     RowID/-1(Error)
/// Debug:		 w ##class(web.DHCMedDictionaryCtl).GetMedDicIDByCode(MDicType, MDicCode)
ClassMethod GetMedDicIDByCode(MDicType, MDicCode)
{
	;^DHCMDIC("0","TypeCode",{MDIC_Type},{MDIC_Code},{MDIC_Rowid}) 
	n (MDicType,MDicCode)
	s ret=-1
	q:MDicType="" ret
	q:MDicCode="" ret
	q:'$d(^DHCMDIC("0","TypeCode",MDicType,MDicCode)) ret
	s RowID=0
	s RowID=$o(^DHCMDIC("0","TypeCode",MDicType,MDicCode,RowID))
	q RowID
}

}
