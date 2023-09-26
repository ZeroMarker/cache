Import SQLUser

/// Description:医生站文本字典数据对照业务类,参考修改于住院证字典维护功能
/// Creator:nikang
/// CreateDate：2017-09-03
Class web.DHCDocTextDicDataCtl Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
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

/// d ##class(%ResultSet).RunQuery("web.DHCDocTextDicDataCtl","QueryAll",1,"")
ClassMethod QueryAllExecute(ByRef qHandle As %Binary, SDicType As %String = "", SExtOrgId As %String = "") As %Status
{
	s RootType="SYS"
	k DHCDocTEXTDIC
	s Rowid=0
	f  s Rowid=$o(^DHCDocTEXTDIC(Rowid)) q:Rowid=""  d
	.s str=$g(^DHCDocTEXTDIC(+Rowid))
	.s Code=$p(str,"^",1)
	.s Desc=$p(str,"^",2)
	.s Type=$p(str,"^",3)
	.Q:(SDicType'="")&&(SDicType'=Type)&&(SDicType'=Code)
	.s Active=$p(str,"^",4)
	.s DateFrom=$p(str,"^",5)
	.s:DateFrom'="" DateFrom=..%ZD(DateFrom)
	.s DateTo=$p(str,"^",6)
	.s:DateTo'="" DateTo=..%ZD(DateTo)
	.s StrCode=$p(str,"^",7)
	.s StrHisFlag=$p(str,"^",8)
	.s ExtOrgId=$p(str,"^",9)
	.q:(SExtOrgId'="")&&(SExtOrgId'=ExtOrgId)&&(Type'=RootType)
	.s ExtOrg=""
	.if ExtOrgId'="" s ExtOrg=$p($g(^DHCMUCExtOrg(ExtOrgId)),"^",2)
	.s StrDesc=$p(str,"^",10)
	.s Data=$lb(Rowid,Code,Desc,Type,Active,DateFrom,DateTo,StrCode,StrHisFlag,StrDesc,ExtOrgId,ExtOrg)
	.s DHCDocTEXTDIC(Type,Rowid)=Data
	if $d(DHCDocTEXTDIC){
		s id=""
		for{
			s id=$o(DHCDocTEXTDIC(RootType,id))
			Q:id=""	
			s Data=DHCDocTEXTDIC(RootType,id)
			s Code=$lg(Data,2)
			if (SExtOrgId="") d OutputRow
			s cid=""
			for{
				s cid=$o(DHCDocTEXTDIC(Code,cid))
				Q:cid=""	
				s Data=DHCDocTEXTDIC(Code,cid)
				d OutputRow
			}
		}
	}
    Quit $$$OK
OutputRow
 	s qHandle($I(ind))=Data
 	Quit
}

ClassMethod QueryAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllExecute ]
{
 	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// Creator：    nikang
/// CreatDate：  2017-09-01
/// Description：查询DHCDocIPBDictory中所有字典项Query
/// Table：      DHCDocIPBDictory
/// Input：      无
/// Output：     Rowid,Code,Desc,Type,Active,DateFrom,DateTo,StrA,StrB,StrC,StrD
Query QueryAll(SDicType As %String = "", SExtOrgId As %String = "") As %Query(ROWSPEC = "Rowid,Code,Desc,Type,Active,DateFrom,DateTo,StrCode,StrHisFlag,StrDesc,ExtOrgId,ExtOrg")
{
}

/// Creator：    nikang
/// CreatDate：  2017-09-01
/// Description：查询DHCDocIPBDictory中所有字典项
/// Table：      DHCDocIPBDictory
/// Input：      Type(字典类型),Flag(是否有效，可以为空)
/// Output：     字典项字符串，"^"分隔;各条数据$c(1)分割
ClassMethod QueryMedDicList(Type, Flag)
{
	;^DHCDocTEXTDIC("0","TYPE",{MDIC_Type},{MDIC_Active},{MDIC_Rowid})
	n (Type,Flag)
	s ret=""	
	s Rowid=0
	s FlagTemp=""
	f  s FlagTemp=$o(^DHCDocTEXTDIC("0","TYPE",Type,FlagTemp)) q:FlagTemp=""  d
	.f  s Rowid=$o(^DHCDocTEXTDIC("0","TYPE",Type,FlagTemp,Rowid)) q:Rowid=""  d
	..s str=$g(^DHCDocTEXTDIC(Rowid))
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
/// CreatDate：  2017-09-01
/// Description：添加或修改字典项(添加数据时MedRowid设空值)
/// Table：      DHCDocIPBDictory
/// Input：      Rowid^Code^Desc^Type^Active^DateFrom^DateTo^StrA^StrB^StrC^StrD
/// Output：     -1/SQLCODE/WMRRowid
/// Debug:		 w ##class(web.DHCDocTextDicDataCtl).Update("入参")
ClassMethod Update(InPut)
{

	n (InPut)
	s s=..UpdateAA(InPut)
	q s
}

/// ***************************************
/// 功能说明：根据MedRowid获取字典项
/// 入参：MedRowid
/// 出参：Rowid^Code^Desc^Type^Active^DateFrom^DateTo^StrA^StrB^StrC^StrD
/// 调试：w ##class(web.DHCDocTextDicDataCtl).GetDataById("MedRowid")
/// *****************************************
ClassMethod GetDataById(InPut)
{

	n (InPut)
	s s=..GetDataByIdAA(InPut)
	q s
}

/// Creator：    nikang
/// CreatDate：  2017-09-01
/// Description：根据MedRowid获取字典项
/// Table：      DHCDocIPBDictory
/// Input：      Rowid
/// Output：     Rowid^Code^Desc^Type^Active^DateFrom^DateTo^StrA^StrB^StrC^StrD
/// 		     其中DateFrom和DateTo数据格式为第4种“/”分割形式(Date组件日期显示类型)
/// Debug:		 w ##class(web.DHCDocTextDicDataCtl).GetDicDataById("MedRowid")
ClassMethod GetDicDataById(Rowid)
{
	n (Rowid)
    q:'$d(^DHCDocTEXTDIC(Rowid)) ""
    s str=$g(^DHCDocTEXTDIC(Rowid))
    s:$p(str,"^",5)'="" $p(str,"^",5)=$zd($p(str,"^",5),4)
    s:$p(str,"^",6)'="" $p(str,"^",6)=$zd($p(str,"^",6),4)
    s str=Rowid_"^"_str
    q str
}

/// Creator：    nikang
/// CreatDate：  2017-09-01
/// Description：根据“字典类别”和"代码"取DHCDocIPBDictory表RowID 			 
/// Table：      DHCDocIPBDictory
/// Input：      MDicType, MDicCode
/// Return：     RowID/-1(Error)
/// Debug:		 w ##class(web.DHCDocTextDicDataCtl).GetMedDicIDByCode(MDicType, MDicCode)
ClassMethod GetMedDicIDByCode(MDicType, MDicCode)
{
	;^DHCDocTEXTDIC("0","TYPECODE",{MDIC_Type},{MDIC_Code},{MDIC_Rowid}) 
	n (MDicType,MDicCode)
	s ret=-1
	q:MDicType="" ret
	q:MDicCode="" ret
	q:'$d(^DHCDocTEXTDIC("0","TYPECODE",MDicType,MDicCode)) ret
	s RowID=0
	s RowID=$o(^DHCDocTEXTDIC("0","TYPECODE",MDicType,MDicCode,RowID))
	q RowID
}

/// ****************************************************
/// 更新字典信息
ClassMethod UpdateAA(InString)
{
    n (InString)  
    s ^tmpnk("UpdateAA")=InString
    s rtn=..CheckRepeat(InString)
    Q:rtn'=0 rtn
    
    s MDICRowid=$p(InString,"^",1)
    s PLIST(2)=$p(InString,"^",2)      ;需对照代码                  
    s PLIST(3)=$p(InString,"^",3)      ;需对照描述                 
    s PLIST(4)=$p(InString,"^",4)      ;字典类别             
    s PLIST(5)=$p(InString,"^",5)      ;状态                
    s PLIST(6)=$p(InString,"^",6)      ;起始日期
    s PLIST(7)=$p(InString,"^",7)      ;截止日期
    s:((PLIST(6)'="")&&(PLIST(6)["-")) PLIST(6)=$zdh($p(InString,"^",6),3)
    s:((PLIST(6)'="")&&(PLIST(6)["/")) PLIST(6)=$zdh($p(InString,"^",6),4)
    s:((PLIST(7)'="")&&(PLIST(7)["-")) PLIST(7)=$zdh($p(InString,"^",7),3)
    s:((PLIST(7)'="")&&(PLIST(7)["/")) PLIST(7)=$zdh($p(InString,"^",7),4)
    
    s PLIST(8)=$p(InString,"^",8)      ;对照代码  
    s PLIST(9)=$p(InString,"^",9)      ;是否外部到His对照
    s PLIST(10)=$p(InString,"^",10)    ;外部机构代码
    s PLIST(11)=$p(InString,"^",11)    ;对照描述
    
    i MDICRowid="" d
    .&sql(Insert into DHCDoc_TextDicData values :PLIST())
    e  d
    .&sql(Update DHCDoc_TextDicData values :PLIST() where TEXTDIC_Rowid=:MDICRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod CheckRepeat(InString As %String)
{
	n (InString)
	s rtn=0
	s MDICRowid=$p(InString,"^",1)
	s Code=$p(InString,"^",2)
	s Type=$p(InString,"^",4) 
	s HisFlag=$p(InString,"^",9) ;是否外部到His对照 
	s ExtOrg=$p(InString,"^",10)  ;外部机构代码 
	if MDICRowid=""{
		if ExtOrg'=""{
			if $d(^DHCDocTEXTDIC("0","EOTC",ExtOrg,Type,Code)){
				s rtn=-1	
			}
		}else{
			if $d(^DHCDocTEXTDIC("0","TYPECODE",Type,Code)){
				s rtn=-1	
			}	
		}
	}else{
		if ExtOrg'=""{
			s id=""
			for{
				s id=$o(^DHCDocTEXTDIC("0","EOTC",ExtOrg,Type,Code,id))
				Q:(id="")!(rtn'=0)
				continue:id=MDICRowid
				s rtn=-1	
			}
		}else{
			s id=""
			for{
				s id=$o(^DHCDocTEXTDIC("0","TYPECODE",Type,Code,id))
				Q:(id="")!(rtn'=0)
				continue:id=MDICRowid
				s rtn=-1	
			}
		}
	}
	Q rtn
}

/// 通过字典类型，是否活动查询字典列表
/// 按Code排序
ClassMethod QueryByTypeAA(Type, Flag, stateFlag As %String = "")
{
    ;k (Type,Flag)
    k PLIST,MLIST
    k ^CacheTemp($zn,$j)
    ;Index TYPE  : ^DHCDocTEXTDIC("0","TYPE",{MDIC_Type},{MDIC_Active},{MDIC_Rowid})                           
    q:Type="" -1
    q:'$d(^DHCDocTEXTDIC("0","TYPE",Type)) -100
    ;i Flag'="" d
    ;.q:'$d(^DHCDocTEXTDIC("0","TYPE",Type,Flag))
    s n=0
    i Flag="" d
    .s sFlag=""
    .f  s sFlag=$o(^DHCDocTEXTDIC("0","TYPE",Type,sFlag))  q:sFlag=""  d
    ..s MDICRowid=""
    ..f  s MDICRowid=$o(^DHCDocTEXTDIC("0","TYPE",Type,sFlag,MDICRowid))  q:MDICRowid=""  d
    ...;s MLIST(n)=$$GetDataById(MDICRowid)
    ...;s n=n+1
    ...q:MDICRowid=""
    ...s DicCode=$p($g(^DHCDocTEXTDIC(MDICRowid)),"^",1)
    ...q:DicCode=""
    ...s ^CacheTemp($zn,$j,DicCode,MDICRowid)=MDICRowid
    e  d
    .q:'$d(^DHCDocTEXTDIC("0","TYPE",Type,Flag)) 
    .s MDICRowid=""
    .f  s MDICRowid=$o(^DHCDocTEXTDIC("0","TYPE",Type,Flag,MDICRowid))  q:MDICRowid=""  d
    ..;s MLIST(n)=$$GetDataById(MDICRowid)
    ..;s n=n+1
    ..q:MDICRowid=""
    ..s DicCode=$p($g(^DHCDocTEXTDIC(MDICRowid)),"^",1)
    ..q:DicCode=""
    ..;Set GroupFlag=0
    ..;if Type="IPBookingState" do
    ..;.Set FZ1=$p($g(^DHCDocTEXTDIC(MDICRowid)),"^",7)
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
    ;Index Type-Code : ^DHCDocTEXTDIC("0","TYPECODE",{MDIC_Type},{MDIC_Code},{MDIC_Rowid})
    q:(Type="")!(Code="") -1
    q:'$d(^DHCDocTEXTDIC("0","TYPECODE",Type,Code)) -100
    s MDICRowid=$o(^DHCDocTEXTDIC("0","TYPECODE",Type,Code,""),-1)
    s s=..GetDataByIdAA(MDICRowid)
    q s
}

/// 通过RowID获取字典项目
ClassMethod GetDataByIdAA(MDICRowid)
{
    n (MDICRowid)
    q:'$d(^DHCDocTEXTDIC(MDICRowid)) ""
    s s=$g(^DHCDocTEXTDIC(MDICRowid))
    s:$p(s,"^",5)'="" $p(s,"^",5)=$zd($p(s,"^",5),3)
    s:$p(s,"^",6)'="" $p(s,"^",6)=$zd($p(s,"^",6),3)
    s s=MDICRowid_"^"_s
    q s
}

/// Desc:	查询对外接口文本数据对照对照数据
/// ModifyDate：2021-01-26
/// Creator：nikang
/// Input:	Type 字典类型
/// 		Code 需对照代码
/// 		HisFlag Y或空 查询外部对his对照数据；N 查询His到外部对照数据
/// 		ExtOrgId 外部机构代码ID
/// Output：对照代码^对照描述
/// Debug:	w ##class(web.DHCDocTextDicDataCtl).GetCompareData("Sex", 1,"Y")
ClassMethod GetCompareData(Type, Code, HisFlag = "", ExtOrgId As %String = "")
{
	n (Type,Code,HisFlag,ExtOrgId)
	if HisFlag="" s HisFlag="Y"
    s data=""
    q:(Type="")!(Code="") data
    if ExtOrgId'=""{
		Q ..GetCompareExtOrgData(Type, Code, HisFlag, ExtOrgId)
	}
    q:'$d(^DHCDocTEXTDIC("0","TYPECODE",Type,Code)) data
    s MDICRowid=0 for  s MDICRowid=$o(^DHCDocTEXTDIC("0","TYPECODE",Type,Code,MDICRowid)) q:MDICRowid=""  d
    .s myHisFlag=$p($g(^DHCDocTEXTDIC(MDICRowid)),"^",8)
    .s ActiveFlag=$p($g(^DHCDocTEXTDIC(MDICRowid)),"^",4)
    .Q:ActiveFlag'="Y"
    .s StartDate=$p($g(^DHCDocTEXTDIC(MDICRowid)),"^",5)
    .s EndDate=$p($g(^DHCDocTEXTDIC(MDICRowid)),"^",6)
    .Q:(StartDate'="")&&(StartDate>+$h)
    .Q:(EndDate'="")&&(EndDate'>+$h)
    .q:myHisFlag'=HisFlag
    .s data=$p($g(^DHCDocTEXTDIC(MDICRowid)),"^",7)
    q data
}

ClassMethod GetCompareExtOrgData(Type, Code, HisFlag, ExtOrgId As %String)
{
	n (Type,Code,HisFlag,ExtOrgId)
	if HisFlag="" s HisFlag="Y"
    s data=""
    q:(Type="")!(Code="") data
    
    q:'$d(^DHCDocTEXTDIC("0","EOTC",ExtOrgId,Type,Code)) data
    
    s MDICRowid=0 for  s MDICRowid=$o(^DHCDocTEXTDIC("0","EOTC",ExtOrgId,Type,Code,MDICRowid)) q:MDICRowid=""  d
    .s myHisFlag=$p($g(^DHCDocTEXTDIC(MDICRowid)),"^",8)
    .s ActiveFlag=$p($g(^DHCDocTEXTDIC(MDICRowid)),"^",4)
    .Q:ActiveFlag'="Y"
    .s StartDate=$p($g(^DHCDocTEXTDIC(MDICRowid)),"^",5)
    .s EndDate=$p($g(^DHCDocTEXTDIC(MDICRowid)),"^",6)
    .Q:(StartDate'="")&&(StartDate>+$h)
    .Q:(EndDate'="")&&(EndDate'>+$h)
    .q:myHisFlag'=HisFlag
    .s StrCode=$p($g(^DHCDocTEXTDIC(MDICRowid)),"^",7)
    .s StrDesc=$p($g(^DHCDocTEXTDIC(MDICRowid)),"^",10)
    .s data=StrCode_"^"_StrDesc
    q data
}

}
