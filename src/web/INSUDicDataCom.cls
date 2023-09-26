Import SQLUser

Class web.INSUDicDataCom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 353;

ClassMethod QueryDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryDic","InsuDicAuthorityFlag","")
ClassMethod QueryDicExecute(ByRef qHandle As %Binary, Type As %String, Code As %String, HospDr As %String = "", ExpStr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	set QueryAllType=$p(ExpStr,"|",1)
	set RelationDic=$p(ExpStr,"|",2) // 关联字典
	s ^CacheTemp("QueryDicExecute")=ExpStr
	s:($g(%session)'="")&&(+HospDr=0) HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	;s ^liusf("sdfsdfsafd")=$h_"^"_Type_"^"_Code
	q:Type="" $$$OK
	;s OutString=##class(web.INSUDicDataCtl).Query(Type,Code)
	s OutString=$$Query^DHCINSUDicData(Type,Code,HospDr)	
	s JustId=+$p(OutString,"^",2)
	s Index=""
	f  s Index=$o(^CacheTemp("INSUDic",JustId,Index)) q:Index=""  d
	.s DataString=$g(^CacheTemp("INSUDic",JustId,Index))
	.s id=$p(DataString,"^",1)
    .s cType=$p(DataString,"^",2)
    .s cCode=$p(DataString,"^",3)
    .s cDesc=$p(DataString,"^",4)
    .s cDemo=$p(DataString,"^",5)
    .s cBill1=$p(DataString,"^",6)
    .s cBill2=$p(DataString,"^",7)
    .s DicAuthorityFlag=$p(DataString,"^",8)
    .s DicOPIPFlag=$p(DataString,"^",9)
    .s DicDefaultFlag=$p(DataString,"^",10)
    .s DicUseFlag=$p(DataString,"^",11)
    .s DicRelationFlag=$p(DataString,"^",12)
    .q:(RelationDic'="")&&(RelationDic'=DicRelationFlag)
    .s DicBill3=$p(DataString,"^",13)
    .s DicBill4=$p(DataString,"^",14)
    .s DicBill5=$p(DataString,"^",15) ;
	.d Build
	// 是否输出全部 tangzf2020115 add 非N输出全部
	if QueryAllType'="N" d
	.s id=""
	.s cDesc="全部"
	.s cCode=""
	.s cType=""
	.s cDemo=""
	.s cBill1=""
	.s cBill2=""
	.d Build
	k ^CacheTemp("INSUDic",JustId)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	set Data=$lb(id,cType,cCode,cDesc,cDemo,cBill1,cBill2,"","全部",DicAuthorityFlag,DicOPIPFlag,DicDefaultFlag,DicUseFlag,DicRelationFlag,DicBill3,DicBill4,DicBill5)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDicExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query QueryDic(Type As %String, Code As %String, HospDr, ExpStr As %String = "") As %Query(ROWSPEC = "id:%String,cType:%String,cCode:%String,cDesc:%String,cDemo:%String,cBill1:%String,cBill2:%String,NULL:%String,Space:%String,DicAuthorityFlag:%String,DicOPIPFlag:%String,DicDefaultFlag:%String,DicUseFlag:%String,DicRelationFlag:%String,DicBill3:%String,DicBill4:%String,DicBill5:%String") [ SqlProc ]
{
}

ClassMethod QueryDicForRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDicForRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryDicForRepExecute(ByRef qHandle As %Binary, Type As %String, InsuType As %String = "", Code As %String, HospDr) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ^TEMP("QueryDicForRep")=$h_"^"_Type_"^"_InsuType_"^"_Code
	q:Type="" $$$OK
	q:(InsuType="")&&(Type'="TariType")&&(Type'="DLLType") $$$OK
	s DicType=Type_""_InsuType ;医保字典类型
	
	;s OutString=##class(web.INSUDicDataCtl).Query(Type,Code)
	s OutString=$$Query^DHCINSUDicData(DicType,Code,HospDr)	
	s JustId=+$p(OutString,"^",2)
	s Index=""
	f  s Index=$o(^CacheTemp("INSUDic",JustId,Index)) q:Index=""  d
	.s DataString=$g(^CacheTemp("INSUDic",JustId,Index))
	.s id=$p(DataString,"^",1)
    .s cType=$p(DataString,"^",2)
    .s cCode=$p(DataString,"^",3)
    .s cDesc=$p(DataString,"^",4)
    .s cDemo=$p(DataString,"^",5)
    .s cBill1=$p(DataString,"^",6)
    .s cBill2=$p(DataString,"^",7)
	.d BuildForRep
	s id=""
	s cDesc="全部"
	s cCode=""
	s cType=""
	s cDemo=""
	s cBill1=""
	s cBill2=""
	d BuildForRep
	k ^CacheTemp("INSUDic",JustId)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildForRep
	set Data=$lb(id,cType,cCode,cDesc,cDemo,cBill1,cBill2,"","全部")
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryDicForRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDicForRepExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// 根据医保字典类型获取字典信息
/// Type:DicType 字典类型固定部分(例如AKA130ZZB,那么Type="AKA130")
/// InsuType:字典类型的医保类型
/// Code:字典类型DicCode(可为空)
/// 特别说明(仅供医保报表使用)
/// DingSH 20171123
Query QueryDicForRep(Type As %String, InsuType As %String, Code As %String) As %Query(ROWSPEC = "id:%String,cType:%String,cCode:%String,cDesc:%String,cDemo:%String,cBill1:%String,cBill2:%String,NULL:%String,Space:%String") [ SqlProc ]
{
}

/// 更新
ClassMethod Update(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	q:InString="" -100
	s:($p(InString,"^",16)="")&&($g(%session)'="") $p(InString,"^",16)=$g(%session.Data("DHCBILLINSUCloud.Hospital")) // tangzf 2019-8-2
	s flag=$$Save^DHCINSUDicData(InString)	
	q flag
}

/// 新增方法,用于新加医保字典界面保存数据使用
ClassMethod UpdateIn(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	q:InString="" -100
	s:($p(InString,"^",16)="")&&($g(%session)'="") $p(InString,"^",16)=$g(%session.Data("DHCBILLINSUCloud.Hospital")) // tangzf 2019-8-2
	s flag=$$SaveIn^DHCINSUDicData(InString)	
	q flag
}

/// 删除
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	q:InString="" -100
	s flag=$$Delete^DHCINSUDicData(InString)
	q flag
}

/// w ##class(web.INSUDicDataCom).GetSys("","","HISPROPertyHTA")
ClassMethod GetSys(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "", HospDr) As %String
{
	s flag=$$GetSys^DHCINSUDicData(InString,"",HospDr)
	q flag
}

/// 根据授权类型取对应系统代码
/// w ##class(web.INSUDicDataCom).GetDicAuthority("Con")
ClassMethod GetDicAuthority(InString As %Library.String = "", HospDr) As %String
{
	s flag=$$GetDicAuthority^DHCINSUDicData(InString,HospDr)
	q flag
}

/// 数据导入
ClassMethod CheckInDic(Instring As %Library.String) As %Library.String
{
	s CheckInDic=$$Save^DHCINSUDicData(Instring)
	q CheckInDic
}

// VB查询基础数据

ClassMethod QueryDicData(Type As %String, Code As %String, HospDr) As %String
{
	s flag=$$Query^DHCINSUDicData(Type,Code,HospDr)
	q flag
}

ClassMethod GetDicData(JustId As %String, Index As %String) As %String
{
 s GetDicData=^CacheTemp("INSUDic",JustId,Index)
 k ^CacheTemp("INSUDic",JustId,Index)
 q GetDicData
}

/// w ##class(web.INSUDicDataCom).GetDicDataDescByCode("Skc516","")
ClassMethod GetDicDataDescByCode(Type As %String, CodeStr As %String, HospDr) As %String
{
 s CodeStr=$tr(CodeStr,"，",",")
 s j=$l(CodeStr,",")
 s DescStr=""
 f i=1:1:j  d
 .s Code=$p(CodeStr,",",i)
 .s Str=$$QueryByCode^DHCINSUDicData(Type,Code,HospDr)
 .s Desc=$p(Str,"^",4)
 .i DescStr=""  d
 ..s DescStr=Desc
 .e             d
 ..s DescStr=DescStr_","_Desc
 i (CodeStr'="")&(DescStr="")  d
 .s DescStr=CodeStr
 q DescStr
}

/// w ##class(web.INSUDicDataCom).QueryByCode("Sys","DBEncrypt")
ClassMethod QueryByCode(Type As %String, Code As %String, HospDr = "") As %String
{
	n (Type,Code,HospDr)	
	s OutStr=$$QueryByCode^DHCINSUDicData(Type,Code,HospDr)	
	s QueryByCode=OutStr
	q QueryByCode
}

/// 20091212
/// yangjianzhang
/// 取医保诊断
/// Input:
/// w ##class(web.INSUDicDataCom).QueryDicListByType("YLZZT")</Description>
ClassMethod QueryDicListByType(DicType As %String, TariType As %String, HospDr) As %String
{
	n (DicType,TariType , HospDr)
	s OutStr=""
	q:DicType="" OutStr
	s INDIDDr=""
	q:'$d(^DHCINDID("0","IType",DicType)) OutStr
	f  s INDIDDr=$o(^DHCINDID("0","IType",DicType,INDIDDr)) q:INDIDDr=""  d
	.s s=$g(^DHCINDID(INDIDDr))
	.s tmpDicType=$p(s,"^",1)
	.s tmpDicCode=$p(s,"^",2)
	.s tmpDicDesc=$p(s,"^",3)
	.s tmpDicBill1=$p(s,"^",4)
	.s tmpDicBill2=$p(s,"^",5)
	.s tmpDicDemo=$p(s,"^",6)
	.//tangzf 2020-5-20 start
	.s BusinessType=DicType
	.s:DicType="SYS" BusinessType=tmpDicCode
	.s ParamHospital=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(BusinessType,HospDr) 
	.s DataHospital=$p(s,"^",15)
 	.q:ParamHospital'=DataHospital
 	.//tangzf 2020-5-20 end
	.i OutStr=""        d 
	..s OutStr=INDIDDr_"^"_tmpDicType_"^"_tmpDicCode_"^"_tmpDicDesc_"^"_tmpDicDemo_"^"_tmpDicBill1_"^"_tmpDicBill2
	.e                  d
	..s OutStr=OutStr_"!"_INDIDDr_"^"_tmpDicType_"^"_tmpDicCode_"^"_tmpDicDesc_"^"_tmpDicDemo_"^"_tmpDicBill1_"^"_tmpDicBill2
	q OutStr
}

/// 根据医保读卡返回的参保地，获取参保地汉字描述
/// w ##class(web.INSUDicDataCom).GetAdmdvsByCode("510000")
ClassMethod GetAdmdvsByCode(Code) As %String
{
	s rtn=Code
	
	q:'$d(^DHCINDID("0","ITypeCode","insuplcadmdvs00A")) rtn
	///如果返回的市一级的，则显示省和市。暂异地病人返回的市
	s id=$o(^DHCINDID("0","ITypeCode","insuplcadmdvs00A",Code,""),-1)
	i id'="" d
	.s pro=$p(^DHCINDID(id),"^",5)
	.s city=$p(^DHCINDID(id),"^",3)
	.s rtn=pro_"-"_city
 	
 	///如果返回的是区县一级的，则显示市和区。暂本地市医保病人返回的区县
 	i $e(Code,5,6)'="00" d
 	.s tmpCode=$e(Code,1,4)_"00"
	.s id=$o(^DHCINDID("0","ITypeCode","insuplcadmdvs00A",tmpCode,""),-1)
	.i id'="" d
	..i $g(city)'="" d
	...s rtn=$p(^DHCINDID(id),"^",3)_"-"_city
	..e  d
	...s rtn=$p(^DHCINDID(id),"^",5)_"-"_$p(^DHCINDID(id),"^",3)

	q rtn
}

Query QueryDic1(Type As %String, Code As %String = "", OPIPFlag As %String = "", HospDr) As %Query(ROWSPEC = "id,cType,cCode,cDesc,cDemo,cBill1,cBill2,selected:%Boolean,DicAuthorityFlag,DicOPIPFlag,DicUseFlag,DicRelationFlag,DicBill3,DicBill4,DicBill5") [ SqlProc ]
{
}

ClassMethod QueryDic1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDic1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryDic1","Skc516","","OP")
ClassMethod QueryDic1Execute(ByRef qHandle As %Binary, Type As %String, Code As %String = "", OPIPFlag As %String = "", HospDr) As %Status
{
	set ^CacheTemp("QueryDic1Execute")=$lb(Type, Code , OPIPFlag , HospDr)
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	q:Type="" $$$OK
	s OutString=$$Query^DHCINSUDicData(Type,Code,HospDr)	
	s JustId=+$p(OutString,"^",2)
	s Index=""
	f  s Index=$o(^CacheTemp("INSUDic",JustId,Index)) q:Index=""  d
	.s DataString=$g(^CacheTemp("INSUDic",JustId,Index))
	.s id=$p(DataString,"^",1)
    .s cType=$p(DataString,"^",2)
    .s cCode=$p(DataString,"^",3)
    .s cDesc=$p(DataString,"^",4)
    .s cDemo=$p(DataString,"^",5)
    .s cBill1=$p(DataString,"^",6)  
    .s cBill2=$p(DataString,"^",7)
    .s DicAuthorityFlag=$p(DataString,"^",8)
    .s ParentDicId=$o(^DHCINDID("0","ITypeCode","SYS",Type,"")) // 对照类型字典 备注保存对照人|对照日期|对照时间 2021-1-27
    .if ParentDicId'=""  d
    ..s ParentDicAuthorityFlag=$p($g(^DHCINDID(ParentDicId)),"^",7)
    .if $g(ParentDicAuthorityFlag)="Con"  d
    ..s ConUser=$p(cDemo,"|",1)
    ..s ConDate=$p(cDemo,"|",2)
    ..s ConTime=$p(cDemo,"|",3)
    ..s:ConUser'="" ConUser=$p($g(^SSU("SSUSR",ConUser)),"^",2) 
    ..s:ConDate'="" ConDate=##class(websys.Conversions).DateLogicalToHtml(ConDate)
    ..s:ConTime'="" ConTime=$zt(ConTime)
    ..s cDemo=ConUser_"|"_ConDate_"|"_ConTime
    .s DicOPIPFlag=$p(DataString,"^",9)
    .q:(OPIPFlag'=DicOPIPFlag)&&(OPIPFlag'="")
    .s DicDefaultFlag=$p(DataString,"^",10)
    .s IsDefaultFlag="false"
    .s:DicDefaultFlag="Y" IsDefaultFlag="true"
    .s DicUseFlag=$p(DataString,"^",11)
    .s DicRelationFlag=$p(DataString,"^",12)
    .s DicBill3=$p(DataString,"^",13)
    .s DicBill4=$p(DataString,"^",14)
    .s DicBill5=$p(DataString,"^",15)
	.d Build1
	k ^CacheTemp("INSUDic",JustId)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build1
	set Data=$lb(id,cType,cCode,cDesc,cDemo,cBill1,cBill2,IsDefaultFlag,DicAuthorityFlag,DicOPIPFlag,DicUseFlag,DicRelationFlag,DicBill3,DicBill4,DicBill5)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryDic1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDic1Execute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryDic2","BearingTypeWHA")

// Dese^Code^cBill2^cBill1^cType^cDemo^id

Query QueryDic2(Type As %String, HospDr) As %SQLQuery(CONTAINID = 1, ROWSPEC = "cDesc:%String,cCode:%String")
{
   
	SELECT INDID_DicDesc,INDID_DicCode  FROM INSU_DicData
	WHERE  INDID_DicType=:Type
}

/// w ##class(web.INSUDicDataCom).GetDHCctcareprovInfo()
ClassMethod GetDHCctcareprovInfo() As %CharacterStream
{
	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	
	s Ret="<Response><ResultCode>-1</ResultCode><ErrorMsg>未找到信息 </ErrorMsg></Response>"
	d objstream.Write(Ret)
	
	//q:$g(BillNo)="" objstream

	s Ret="<Response><ResultCode>0</ResultCode>"
    d objstream.Clear()
	d objstream.Write(Ret)
	
	s RowId=0
	s i=1
	f  s RowId=$o(^CTPCP(RowId)) q:(RowId="")  d
    .s Info=$g(^CTPCP(RowId,1))
    .s SSUSRRowId=0
    .s SSUSRRowId=$o(^SSU("SSUSR",0,"CTPCP",RowId,SSUSRRowId))
    .q:SSUSRRowId=""
    .s SSUSRInfo=$g(^SSU("SSUSR",SSUSRRowId))
    .s SSUSRDefaultDeptDR=$p(SSUSRInfo,"^",4)
    .q:((SSUSRDefaultDeptDR="")||('$d(^CTLOC(SSUSRDefaultDeptDR))))
    .i (SSUSRDefaultDeptDR="") || ('$d(^CTLOC(SSUSRDefaultDeptDR)))   d
	..;s Depcode="空"
	..;s DepDesc="空"
	.e    d
	..s Depcode=SSUSRDefaultDeptDR		;$p(^CTLOC(SSUSRDefaultDeptDR),"^",1) //科室编号
	..s DepDesc=$p(^CTLOC(SSUSRDefaultDeptDR),"^",2) //科室
	
    .s Code=$p(Info,"^",1)				;	1		医师编号
    .s Desc=$p(Info,"^",2)				;	2		医师姓名
	.s CtcpString1="1"					;	3		医师医保服务资格状态
	.s CtcpString2="235"				;	4		卫生技术人员专业技术职务
	.s CtcpString3=DepDesc				;	5		科室名称
	
	.s CtcpString4="5"				;	6		行政职务
	.s CtcpString5="" 					;	7		医师资格证编码
	.s CtcpString6="" 				;	8		毕业院校
	.s CtcpString7="" 					;	9		科室编号
	.s CtcpString8="9" 					;	10		性别
	
	.s CtcpString9="" 					;	11		联系电话
	.s CtcpString10="20120101"			;	12		医师身份证号码
	.s CtcpString11=""					;	13		药师执业类别    
   	
   	.//--------------------循环写XML------------->
	.s Ret="<Row>"
	.s Ret=Ret_"<Number>"_i_"</Number>"
	.s Ret=Ret_"<Code>"_Code_"</Code>"
	.s Ret=Ret_"<Desc>"_Desc_"</Desc>"
	.s Ret=Ret_"<CtcpString1>"_CtcpString1_"</CtcpString1>"
	.s Ret=Ret_"<CtcpString2>"_CtcpString1_"</CtcpString2>"
	.s Ret=Ret_"<CtcpString3>"_CtcpString1_"</CtcpString3>"
	.s Ret=Ret_"<CtcpString4>"_CtcpString1_"</CtcpString4>"
	.s Ret=Ret_"<CtcpString5>"_CtcpString1_"</CtcpString5>"
	.s Ret=Ret_"<CtcpString6>"_CtcpString1_"</CtcpString6>"
	.s Ret=Ret_"<CtcpString7>"_CtcpString1_"</CtcpString7>"
	.s Ret=Ret_"<CtcpString8>"_CtcpString1_"</CtcpString8>"
	.s Ret=Ret_"<CtcpString9>"_CtcpString1_"</CtcpString9>"
	.s Ret=Ret_"<CtcpString10>"_CtcpString1_"</CtcpString10>"
	.s Ret=Ret_"<CtcpString11>"_CtcpString1_"</CtcpString11>"
	.s Ret=Ret_"</Row>"
	.s ^CacheTemp("StrToXML",i)=Ret
	.d objstream.Write(Ret)
	.s i=i+1
	.//<------------------循环结束 -------------------------------//
	s Ret="</Response>"
	d objstream.Write(Ret)
	q objstream
}

/// w ##class(web.INSUDicDataCom).GetCTLocInfo()
ClassMethod GetCTLocInfo() As %CharacterStream
{
	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	
	s Ret="<Response><ResultCode>-1</ResultCode><ErrorMsg>未找到信息 </ErrorMsg></Response>"
	d objstream.Write(Ret)
	
	//q:$g(BillNo)="" objstream

	s Ret="<Response><ResultCode>0</ResultCode>"
    d objstream.Clear()
	d objstream.Write(Ret)
	
	s RowId=0
	s i=1
	f  s RowId=$o(^CTLOC(RowId)) q:(RowId="")  d
    .s Info=$g(^CTLOC(RowId))
    .s Code=RowId		;$p(Info,"^",1)	科室编码
    .s Desc=$p(Info,"^",2)		;科室名称
    .s CTLocCate=""				;科室分类
    .s CTLocNum=""				;科室床位数
    .s Demo=""					;备注
    .s UserId=""				;医院经办人
 
   	
   	.//--------------------循环写XML------------->
	.s Ret="<Row>"
	.s Ret=Ret_"<Number>"_i_"</Number>"
	.s Ret=Ret_"<Code>"_Code_"</Code>"
	.s Ret=Ret_"<Desc>"_Desc_"</Desc>"
	.s Ret=Ret_"<CTLocCate>"_CTLocCate_"</CTLocCate>"
	.s Ret=Ret_"<CTLocNum>"_CTLocNum_"</CTLocNum>"
	.s Ret=Ret_"<Demo>"_Demo_"</Demo>"
	.s Ret=Ret_"<UserId>"_UserId_"</UserId>"
	.s Ret=Ret_"</Row>"
	.s ^CacheTemp("StrToXML",i)=Ret
	.d objstream.Write(Ret)
	.s i=i+1
	.//<------------------循环结束 -------------------------------//
	s Ret="</Response>"
	d objstream.Write(Ret)
	q objstream
}

/// w ##class(web.INSUDicDataCom).GetJXInfo()
ClassMethod GetJXInfo() As %CharacterStream
{
	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	
	s Ret="<Response><ResultCode>-1</ResultCode><ErrorMsg>未找到信息 </ErrorMsg></Response>"
	d objstream.Write(Ret)
	
	//q:$g(BillNo)="" objstream

	s Ret="<Response><ResultCode>0</ResultCode>"
    d objstream.Clear()
	d objstream.Write(Ret)
	
	s PHCFRowId=0
	s i=1
	f  s PHCFRowId=$o(^PHCF(PHCFRowId)) q:(PHCFRowId="")  d
    .s PHCFInfo=$g(^PHCF(PHCFRowId))
    .s Code=PHCFRowId
    .s Desc=$p(PHCFInfo,"^",2)
   	
   	.//--------------------循环写XML------------->
	.s Ret="<Row>"
	.s Ret=Ret_"<Number>"_i_"</Number>"
	.s Ret=Ret_"<Code>"_Code_"</Code>"
	.s Ret=Ret_"<Desc>"_Desc_"</Desc>"
	.s Ret=Ret_"</Row>"
	.s ^CacheTemp("StrToXML",i)=Ret
	.d objstream.Write(Ret)
	.s i=i+1
	.//<------------------循环结束 -------------------------------//
	s Ret="</Response>"
	d objstream.Write(Ret)
	q objstream
}

ClassMethod GetTarCateInfo() As %CharacterStream
{
	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	
	s Ret="<Response><ResultCode>-1</ResultCode><ErrorMsg>未找到信息 </ErrorMsg></Response>"
	d objstream.Write(Ret)
	
	//q:$g(BillNo)="" objstream

	s Ret="<Response><ResultCode>0</ResultCode>"
    d objstream.Clear()
	d objstream.Write(Ret)
	
	s RowId=0
	s i=1
	f  s RowId=$o(^DHCTarC("CC",RowId)) q:(RowId="")  d
    .s Info=$g(^DHCTarC("CC",RowId))
    .s Code=RowId
    .s Desc=$p(Info,"^",2)
	.s tmpStr=Code_"^"_Desc   	
   	.//--------------------循环写XML------------->
	.s Ret="<Row>"
	.s Ret=Ret_"<Number>"_i_"</Number>"
	.s Ret=Ret_"<Code>"_Code_"</Code>"
	.s Ret=Ret_"<Desc>"_Desc_"</Desc>"
	.s Ret=Ret_"</Row>"
	.;s ^CacheTemp("StrToXML",i)=Ret
	.d objstream.Write(Ret)
	.s i=i+1
	.//<------------------循环结束 -------------------------------//
	s Ret="</Response>"
	d objstream.Write(Ret)
	q objstream
}

/// 根据代码类别和位置取字典的值
/// SysType:SYS代码
/// Code:代码
/// Zhan 2012-06-20
/// 取值的位置
/// w ##class(web.INSUDicDataCom).GetDicByCodeAndInd("QueryByCode","SYS","DBEncrypt",2)
/// 20221123 增加 入参 语言Id
ClassMethod GetDicByCodeAndInd(SysType, Code, Ind, HospDr = "", langId = "") As %String
{
	n (SysType,Code,Ind,HospDr,langId,%session)
	s QueryByCode="-1"	
	s:($g(%session)'="")&&(+HospDr=0) HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s OutStr=$$QueryByCode^DHCINSUDicData(SysType,Code,HospDr,langId)	
	i ($l(OutStr,"^")>1)&(Ind'=0) d
	.s QueryByCode=$p(OutStr,"^",Ind)
	e  d
	.s QueryByCode=OutStr
	q QueryByCode
}

/// w ##class(web.INSUDicDataCom).GetDicBybillAndInd("AdmReasonDrToTariType","ZZB",0)
ClassMethod GetDicBybillAndInd(DicType, Code, Ind, HospDr) As %String
{
	n (DicType,Code,Ind,HospDr)
	
	s QueryByCode="-1",OutStr=""
	q:$d(^DHCINDID(0,"IType",DicType))=0 QueryByCode

	s rowid=0
	f  s rowid=$o(^DHCINDID(0,"IType",DicType,rowid))	q:rowid=""  d
	.s s=$g(^DHCINDID(rowid))
	.s DicType=$p(s,"^",1)
	.s DicCode=$p(s,"^",2)
	.s DicDesc=$p(s,"^",3)
	.s DicBill1=$p(s,"^",4)
	.q:(DicBill1'=Code)&(Code'="")
	.s DicBill2=$p(s,"^",5)
	.s DicDemo=$p(s,"^",6) 
	.//tangzf 2020-5-20 start
	.s BusinessType=DicType
	.s:DicType="SYS" BusinessType=DicCode
	.s ParamHospital=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(BusinessType,HospDr) 
 	.s DataHospital=$p(s,"^",15)
 	.q:ParamHospital'=DataHospital
 	.//tangzf 2020-5-20 end
	.s:OutStr'="" OutStr=OutStr_"$"_rowid_"^"_DicType_"^"_DicCode_"^"_DicDesc_"^"_DicDemo_"^"_DicBill1_"^"_DicBill2
	.s:OutStr="" OutStr=rowid_"^"_DicType_"^"_DicCode_"^"_DicDesc_"^"_DicDemo_"^"_DicBill1_"^"_DicBill2

	i ($l(OutStr,"^")>1)&(Ind'=0) d
	.s QueryByCode=$p(OutStr,"^",Ind)
	e  d
	.s QueryByCode=OutStr
	q QueryByCode
}

/// 查询并生成字典的JSON数据串，简单模式
/// Zhan 20140719
ClassMethod GetDicSYSJSONInfo(RootID As %String, DicType As %String, kwords As %String = "", HospDr) As %String
{
	s j=0
	;s ^zmc(55)=RootID_","_DicType_","_kwords
	i $d(^CacheTemp("INSUINFO",RootID)) k ^CacheTemp("INSUINFO",RootID)
	s sKeyWord=$$ALPHAUP^SSUTIL4(kwords)
	s INDIDDr="0"
	q:'$d(^DHCINDID("0","IType",DicType)) j
	f  s INDIDDr=$o(^DHCINDID("0","IType",DicType,INDIDDr)) q:INDIDDr=""  d
	.S obj=##class(User.INSUDicData).%OpenId(INDIDDr)
	.s BusinessType=obj.DicType
	.s:DicType="SYS" BusinessType=obj.INDIDDicCode
	.s ParamHospital=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(BusinessType,HospDr)
	.q:ParamHospital'=obj.INDIDHospDr
	.q:((sKeyWord'="")&&(($$ALPHAUP^SSUTIL4(obj.INDIDDicCode)'[sKeyWord)&&($$ALPHAUP^SSUTIL4(obj.INDIDDicDesc)'[sKeyWord)))
	.S jsonString =obj.GetJSONFromObject()
 	.s ^CacheTemp("INSUINFO",RootID,j)=jsonString
 	.s j=j+1
	q j
}

/// 查询并生成字典的JSON数据串
/// Zhan 20140905改写
/// w ##class(web.INSUDicDataCom).GetDicJSONInfo("","SYS^^")
ClassMethod GetDicJSONInfo(RootID As %String, InArgs As %String = "", HospDr As %String = "") As %String
{
	s ^temp("GetDicJSONInfo") = $lb(RootID,InArgs,HospDr)
	s:($g(%session)'="")&&(+HospDr=0) HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s ^temp("GetDicJSONInfoHosp") = $lb(HospDr)
    s ^temp("GetDicJSONInfoHosp1") = $lb($g(%session.Data("LOGON.HOSPID")))
	s ^CacheTemp("GetDicJSONInfo")=$lb(InArgs , HospDr)
	s j=0
	//DicType As %String, kwords As %String = ""
	s DicType=$p(InArgs,"^",1)
	s kwords=$p(InArgs,"^",2)
	s tmpflag=+$p(InArgs,"^",3)
	;s tmp=$i(^zmc("RootID"))
	;s AuStr=$g(%session.Data("LOGON.USERID"))
	;s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	;s ^zmc("RootID",tmp)=RootID_","_DicType_","_kwords_";"_AuStr ;_";"_AuHospStr
	;s ^zmc(1233)=RootID_"_"_InArgs
	s AuFlag=1
	S AuStr="" //##class(web.DHCBL.BDP.Authorize).DHCGetBDDataByDefaultSession("INSU_DICDATA")
	s ^zmc(11111)=AuStr_"_"_InArgs
	if (AuStr="")||(AuStr["limited:0") d
	.s AuFlag=1
	
	i $d(^CacheTemp("INSUINFO",RootID)) k ^CacheTemp("INSUINFO",RootID)
	s KeyWords=$$ALPHAUP^SSUTIL4(kwords)
	q:'$d(^DHCINDID("0","IType",DicType)) j
	i (DicType="SYS")&(tmpflag=1)&((("SYS"[KeyWords)&(KeyWords'=""))||(KeyWords="")) d
	.s INDIDDr=""
	.s tmpdic="SYS^SYS^系统^^^^^^^^^"
	.d dicbuild
	s INDIDDr="0"
	f  s INDIDDr=$o(^DHCINDID("0","IType",DicType,INDIDDr)) q:INDIDDr=""  d
	.;S obj=##class(User.INSUDicData).%OpenId(INDIDDr)
	.;S jsonString =obj.GetJSONFromObject()	//,最简单的方法，但表的定义中没有ROWID属性，无法生成ROWID
	.s tmpdic=^DHCINDID(INDIDDr)
	.s INDIDDicCode=$p(tmpdic,"^",2)
	.s INDIDDicDesc=$p(tmpdic,"^",3)
	.;+2019-7-30 tangzf 医院授权判断 start
	.s BusinessType=DicType
	.s:DicType="SYS" BusinessType=INDIDDicCode
	.s ParamHospital=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(BusinessType,HospDr)
	.s TmpHospital=$p($g(^DHCINDID(INDIDDr)), "^", 15)
	.q:TmpHospital'=ParamHospital ; 该院区无权查看该数据
	.;+2019-7-30 tangzf 医院授权判断 end
	.s tmpjsonDicCode="{INDIDDicCode:"_INDIDDicCode_"}"
	.if (AuStr[tmpjsonDicCode)||(AuFlag=1) d
	..q:((KeyWords'="")&&(($$ALPHAUP^SSUTIL4(INDIDDicCode)'[KeyWords)&&($$ALPHAUP^SSUTIL4(INDIDDicDesc)'[KeyWords)))
	..d dicbuild
	q j

	
dicbuild
	i j=0 d
	.s ^CacheTemp("INSUINFOTitle",RootID)="Rowid^INDIDDicType^INDIDDicCode^INDIDDicDesc^INDIDDicBill1^INDIDDicBill2^INDIDDicDemo^INDIDDicAuthorityFlag^INDIDDicOPIPFlag^INDIDDicDefaultFlag^INDIDDicUseFlag^INDIDDicRelationFlag^INDIDDicBill3^INDIDDicBill4^INDIDDicBill5"
 	s ^CacheTemp("INSUINFO",RootID,j)=INDIDDr_"^"_tmpdic
 	s j=j+1
}

/// add by Huang SF
/// Desc:查看医保字典的系统代码
ClassMethod QueryDicSysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDicSysExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryDicSys","PacAdmReason到","")
ClassMethod QueryDicSysExecute(ByRef qHandle As %Binary, CodeAndDesc As %String, queryFlag As %String = "", HospDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s:($g(%session)'="")&&(+HospDr=0) HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s ^CacheTemp("QueryDicSys")=CodeAndDesc_","_queryFlag
	;s CodeAndDesc=$$ALPHAUP^SSUTIL4(CodeAndDesc)
	
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(CodeAndDesc)
	
	
	s (INDIDDicCode,INDIDDicDesc,INDIDDicDemo)=""
	// - DingSH 20191118 删除如下 
	/*s HANZIFlag=0
	f i=1:1:$l(CodeAndDesc) d
	.s CodeAndDescTemp=$EXTRACT(CodeAndDesc,i)
	.i '((CodeAndDescTemp?.A)||(CodeAndDescTemp?.N)) d
	..s HANZIFlag=1
	
	i HANZIFlag=0 d  ;英文和数字
	.b ;英文
	.i queryFlag="" d
	..s INDIDDicCode="SYS"
	..s INDIDDicDesc="系统"
	..s INDIDDicDemo=""
	..s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(INDIDDicDesc,4,"")
	..s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(INDIDDicDesc,3,"")
	..i (($$ALPHAUP^SSUTIL4(INDIDDicCode)[CodeAndDesc)||(HZSPCode[CodeAndDesc)||(HZPYCode[CodeAndDesc)) d
	...d Output
	.s Rowid=""
	.f  s Rowid=$o(^DHCINDID("0","IType","SYS",Rowid)) q:Rowid=""  d
	..s InsuDicInfo=$g(^DHCINDID(Rowid))
	..s INDIDDicCode=$p(InsuDicInfo,"^",2)
	..s INDIDDicDesc=$p(InsuDicInfo,"^",3)
	..s INDIDDicDemo=$p(InsuDicInfo,"^",6)
	..s INDIDDicAuthorityFlag=$p(InsuDicInfo,"^",7)
	..s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(INDIDDicDesc,4,"")
	..s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(INDIDDicDesc,3,"")
	..q:(queryFlag'="")&(INDIDDicAuthorityFlag'=queryFlag)
	..q:($$ALPHAUP^SSUTIL4(INDIDDicCode)'[CodeAndDesc)&&(HZSPCode'[CodeAndDesc)&&(HZPYCode'[CodeAndDesc)
	..d Output
	e   d   ;汉字
	.b ;汉字
	.i ((queryFlag="")&("系统"[CodeAndDesc)) d
	..s INDIDDicCode="SYS"
	..s INDIDDicDesc="系统"
	..s INDIDDicDemo=""
	..d Output
	.s Rowid=""
	.f  s Rowid=$o(^DHCINDID("0","IType","SYS",Rowid)) q:Rowid=""  d
	..s InsuDicInfo=$g(^DHCINDID(Rowid))
	..s INDIDDicCode=$p(InsuDicInfo,"^",2)
	..s INDIDDicDesc=$p(InsuDicInfo,"^",3)
	..s INDIDDicDemo=$p(InsuDicInfo,"^",6)
	..s INDIDDicAuthorityFlag=$p(InsuDicInfo,"^",7)
	..q:(queryFlag'="")&(INDIDDicAuthorityFlag'=queryFlag)
	..q:INDIDDicDesc'[CodeAndDesc
	..d Output
	*/
	// + DingSH 更改如下 
    i ((queryFlag="")) d
	.s INDIDDicCode="SYS"
	.s INDIDDicDesc="系统"
	.s INDIDDicDemo=""
	.s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(INDIDDicDesc,4,"")
	.s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(INDIDDicDesc,3,"")
	.i (($$ALPHAUP^SSUTIL4(INDIDDicCode)[CodeAndDesc)||(HZSPCode[CodeAndDesc)||(HZPYCode[CodeAndDesc)||("系统"[CodeAndDesc)) d
	..d Output
	s Rowid=""
	f  s Rowid=$o(^DHCINDID("0","IType","SYS",Rowid)) q:Rowid=""  d
	.s InsuDicInfo=$g(^DHCINDID(Rowid))
	.s INDIDDicCode=$p(InsuDicInfo,"^",2)
	.s INDIDDicDesc=$p(InsuDicInfo,"^",3)
	.s INDIDDicDemo=$p(InsuDicInfo,"^",6)
	.s INDIDDicAuthorityFlag=$p(InsuDicInfo,"^",7)
	.;+2019-7-30 tangzf 医院授权判断 start
	.s ParamHospital=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(INDIDDicCode,HospDr)
	.s TmpHospital=$p(InsuDicInfo, "^", 15)
	.q:TmpHospital'=ParamHospital ; 该院区无权查看该数据
	.q:(queryFlag'="")&(INDIDDicAuthorityFlag'=queryFlag)
	.s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(INDIDDicDesc,4,"")
	.s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(INDIDDicDesc,3,"")
	.q:($$ALPHAUP^SSUTIL4(INDIDDicCode)'[tCodeAndDesc)&&(HZSPCode'[tCodeAndDesc)&&(HZPYCode'[tCodeAndDesc)&&(INDIDDicDesc'[CodeAndDesc)
	.d Output
	
	
	
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	set Data=$lb(INDIDDicCode,INDIDDicDesc,INDIDDicDemo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryDicSysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDicSysExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query QueryDicSys(CodeAndDesc As %String, queryFlag As %String = "", HospDr As %String = "") As %Query(ROWSPEC = "INDIDDicCode,INDIDDicDesc,INDIDDicDemo") [ SqlProc ]
{
}

ClassMethod QueryDicAuthorityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDicAuthorityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryDicAuthority","PRO")
ClassMethod QueryDicAuthorityExecute(ByRef qHandle As %Binary, Type As %String, HospDr) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
		
	 s i=0,id=""
 	q:'$d(^DHCINDID("0","DicAuthority",Type)) $$$OK
 	s ParamHospital=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("DicAuthority",HospDr)
 	f  s id=$o(^DHCINDID("0","DicAuthority",Type,id)) q:id=""  d
 	.s s=$g(^DHCINDID(id))
 	.s INDIDDicCode=$p(s,"^",2)
 	.s INDIDDicDesc=$p(s,"^",3)
 	.s INDIDDicDemo=$p(s,"^",6)
 	.;+2019-7-30 tangzf 医院授权判断 start
	.s TmpHospital=$p($g(^DHCINDID(id)), "^", 15)
	.q:TmpHospital'=ParamHospital ; 该院区无权查看该数据
	.;+2019-7-30 tangzf 医院授权判断 end 
	.d Output11
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output11
	set Data=$lb(INDIDDicCode,INDIDDicDesc,INDIDDicDemo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryDicAuthorityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDicAuthorityExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query QueryDicAuthority(Type As %String, HospDr) As %Query(ROWSPEC = "INDIDDicCode,INDIDDicDesc,INDIDDicDemo") [ SqlProc ]
{
}

/// Creator: tangzf
/// CreateDate: 2020-03-09
/// Descript: 更新医保字典数据
/// Table : User.INSUDicData.cls
/// Input:		JsonStr : User.INSUDicData字段对应的json串
/// Output: 
/// Return: 0 表示 成功 非0表示失败
/// DeBug:  w ##class(web.INSUDicDataCom).UpdaDicInfoByJson("{name:"a",b:"b"}","3334")
ClassMethod UpdaDicInfoByJson(JsonStr, DicDataId) As %String
{
	set ^CacheTemp("UpdaDicInfoByJson")=$lb(JsonStr, DicDataId)
	set rtn=0
	set obj=##class(%DynamicAbstractObject).%FromJSON(JsonStr)
	set INSUDicData=##class(User.INSUDicData).%OpenId(DicDataId)
	quit:('$IsObject(INSUDicData)) "-1"
	
	set iter = obj.%GetIterator()
	while iter.%GetNext(.key , .value ) {
	   set $ZOBJPROPERTY(INSUDicData,key)=$ZOBJPROPERTY(obj,key)
	}
	set err=INSUDicData.%Save()
    if $$$ISERR(err){
		set rtn="-100^"_$SYSTEM.Status.GetErrorText(err)
	}else{
		set rtn=0
	}
	set obj=""
	set INSUDicData=""
	quit rtn
}

/// Creator: tangzf
/// CreateDate: 2020-03-09
/// Descript: 查询医保字典数据
/// Table : User.INSUDicData.cls
/// Input:		JsonStr : User.INSUDicData字段对应的json串
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryDicAllInfo","","")
Query QueryDicAllInfo(CodeAndDesc As %String, queryFlag As %String = "", HospDr As %String = "") As websys.Query(ROWSPEC = "Rowid,INDIDDicType,INDIDDicCode,INDIDDicDesc,INDIDDicDemo,INDIDDicAuthorityFlag,INDIDDicOPIPFlag,INDIDDicDefaultFlag,INDIDDicUseFlag,DicOPIPFlag,DicUseFlag,INDIDDicRelationFlag,INDIDDicBill3,INDIDDicBill4,INDIDDicBill5,INDIDInsuType") [ SqlProc ]
{
}

ClassMethod QueryDicAllInfoExecute(ByRef qHandle As %Binary, CodeAndDesc As %String, queryFlag As %String = "", HospDr As %String = "") As %Status
{
	s:($g(%session)'="")&&(+HospDr=0) HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s ^CacheTemp("QueryDicSys")=CodeAndDesc_","_queryFlag
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(CodeAndDesc)
	s (INDIDDicCode,INDIDDicDesc,INDIDDicDemo)=""

    i ((queryFlag="")) d
	.s INDIDDicCode="SYS"
	.s INDIDDicDesc="系统"
	.s INDIDDicDemo=""
	.s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(INDIDDicDesc,4,"")
	.s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(INDIDDicDesc,3,"")
	.i (($$ALPHAUP^SSUTIL4(INDIDDicCode)[CodeAndDesc)||(HZSPCode[CodeAndDesc)||(HZPYCode[CodeAndDesc)||("系统"[CodeAndDesc)) d
	..d Output
	s Rowid=""
	f  s Rowid=$o(^DHCINDID("0","IType","SYS",Rowid)) q:Rowid=""  d
	.s InsuDicInfo=$g(^DHCINDID(Rowid))
	.s INDIDDicType=$p(InsuDicInfo,"^",1)
	.s ParamHospital=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId($p(InsuDicInfo,"^",2),HospDr)
	.;+2019-7-30 tangzf 医院授权判断 start
	.s TmpHospital=$p(InsuDicInfo, "^", 15)
	.q:TmpHospital'=ParamHospital ; 该院区无权查看该数据
	.;+2019-7-30 tangzf 医院授权判断 end 
	.s INDIDDicCode=$p(InsuDicInfo,"^",2)
	.s INDIDDicDesc=$p(InsuDicInfo,"^",3)
	.s INDIDDicBill1=$p(InsuDicInfo,"^",4)
	.s INDIDDicBill2=$p(InsuDicInfo,"^",5)
	.s INDIDDicDemo=$p(InsuDicInfo,"^",6)
	.s INDIDDicAuthorityFlag=$p(InsuDicInfo,"^",7)
	.s INDIDDicOPIPFlag=$p(InsuDicInfo,"^",8)
	.s INDIDDicDefaultFlag=$p(InsuDicInfo,"^",9)
	.s INDIDDicUseFlag=$p(InsuDicInfo,"^",10)
	.s INDIDDicRelationFlag=$p(InsuDicInfo,"^",11)
	.s INDIDDicBill3=$p(InsuDicInfo,"^",12)
	.s INDIDDicBill4=$p(InsuDicInfo,"^",13)
	.s INDIDDicBill5=$p(InsuDicInfo,"^",14)
	.q:(queryFlag'="")&(INDIDDicAuthorityFlag'=queryFlag)
	.s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(INDIDDicDesc,4,"")
	.s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(INDIDDicDesc,3,"")
	.q:($$ALPHAUP^SSUTIL4(INDIDDicCode)'[tCodeAndDesc)&&(HZSPCode'[tCodeAndDesc)&&(HZPYCode'[tCodeAndDesc)&&(INDIDDicDesc'[CodeAndDesc)
 	.;+2019-7-30 tangzf 医院授权判断 start
	.;s TmpHospital=$p(InsuDicInfo, "^", 15)
	.;q:TmpHospital'=ParamHospital ; 该院区无权查看该数据
	.;+2019-7-30 tangzf 医院授权判断 end 
	.;取值医保类型
	.s DicSysDicType = ..GetDicByCodeAndInd("INSUConBDPTableList",INDIDDicCode,6,HospDr)
    .s InsuType=""
	.//b ;ttt
    .s tmpDicSysDicType="INSU_DicSys_"_INDIDDicCode
    .i (DicSysDicType'="")&&(DicSysDicType'=tmpDicSysDicType) d
    ..s InsuType = $e(tmpDicSysDicType,$l(DicSysDicType)+1,*)
	.d QueryDicAllInfo
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryDicAllInfo
	set Data=$lb(Rowid,INDIDDicType,INDIDDicCode,INDIDDicDesc,INDIDDicDemo,INDIDDicAuthorityFlag,INDIDDicOPIPFlag,INDIDDicDefaultFlag,INDIDDicUseFlag,DicOPIPFlag,DicUseFlag,INDIDDicRelationFlag,INDIDDicBill3,INDIDDicBill4,INDIDDicBill5,InsuType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator: tangzf
/// CreateDate: 2020-03-09
/// Descript: 查询医保字典数据（医保代码与平台配置对照） 该查询不判断院区
/// Table : User.INSUDicData.cls
/// Input:	CodeAndDesc : 代码、描述
/// 			ConFlag : 是否对照 Y="已对照"	
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryDicINSUBDPTableList","","")
Query QueryDicINSUBDPTableList(type, CodeAndDesc As %String, ConFlag As %String = "") As websys.Query(ROWSPEC = "id,cType,cCode,cDesc,cDemo,cBill1,cBill2,selected:%Boolean,DicAuthorityFlag,DicOPIPFlag,DicUseFlag,DicRelationFlag,DicBill3,DicBill4,DicBill5") [ SqlProc ]
{
}

ClassMethod QueryDicINSUBDPTableListExecute(ByRef qHandle As %Binary, type, CodeAndDesc As %String, ConFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s ^CacheTemp("QueryDicINSUBDPTableList")=$lb(type,CodeAndDesc,ConFlag)
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(CodeAndDesc)
	s (INDIDDicCode,INDIDDicDesc,INDIDDicDemo)=""
	s Rowid=""
	f  s Rowid=$o(^DHCINDID("0","IType",type,Rowid)) q:Rowid=""  d
	.s InsuDicInfo=$g(^DHCINDID(Rowid))
	.s cType=$p(InsuDicInfo,"^",1)
	.s cCode=$p(InsuDicInfo,"^",2)
	.q:cCode=""
	.s cDesc=$p(InsuDicInfo,"^",3)
	.s cBill1=$p(InsuDicInfo,"^",4)
	.s cBill2=$p(InsuDicInfo,"^",5)
	.s cDemo=$p(InsuDicInfo,"^",6)
	.s DicAuthorityFlag=$p(InsuDicInfo,"^",7)
	.s DicOPIPFlag=$p(InsuDicInfo,"^",8)
	.s IsDefaultFlag=$p(InsuDicInfo,"^",9)
	.s DicUseFlag=$p(InsuDicInfo,"^",10)
	.s DicRelationFlag=$p(InsuDicInfo,"^",11)
	.s DicBill3=$p(InsuDicInfo,"^",12)
	.s DicBill4=$p(InsuDicInfo,"^",13)
	.s DicBill5=$p(InsuDicInfo,"^",14)
	.q:(ConFlag="Y")&&(cBill1="")
	.q:(ConFlag'="Y")&&(cBill1'="")
	.s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(cDesc,4,"")
	.s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(cDesc,3,"")
	.q:($$ALPHAUP^SSUTIL4(cCode)'[tCodeAndDesc)&&(HZSPCode'[tCodeAndDesc)&&(HZPYCode'[tCodeAndDesc)&&(cDesc'[CodeAndDesc)
	.d QueryDicINSUConInfo
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryDicINSUConInfo
	set Data=$lb(Rowid,cType,cCode,cDesc,cDemo,cBill1,cBill2,IsDefaultFlag,DicAuthorityFlag,DicOPIPFlag,DicUseFlag,DicRelationFlag,DicBill3,DicBill4,DicBill5)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator: tangzf
/// CreateDate: 2022-04-18
/// Descript: 校验 字典  是否有需要新增的医保代码与平台对照数据 ，该表只需要对照带医保类型的字典数据
/// Input: 
/// Output: 
/// Return:  
/// DeBug: w ##class(web.INSUDicDataCom).CheckAddINSUConBDPTableList()
ClassMethod CheckAddINSUConBDPTableList() As %String
{
	//取医保类型
	s Rowid=""
	f  s Rowid=$o(^DHCINDID("0","IType","DLLType",Rowid)) q:Rowid=""  d
	.s InsuDicInfo=$g(^DHCINDID(Rowid))
	.s cType=$p(InsuDicInfo,"^",1)
	.s cCode=$p(InsuDicInfo,"^",2)
	.s DLLTypeArr(cCode)=""
	s InsertArrI=0
	
	s Rowid=""
	f  s Rowid=$o(^DHCINDID("0","IType","SYS",Rowid)) q:Rowid=""  d
	.s InsuDicInfo=$g(^DHCINDID(Rowid))
	.s cType=$p(InsuDicInfo,"^",1)
	.s cCode=$p(InsuDicInfo,"^",2)
	.q:cCode=""
	.s cDesc=$p(InsuDicInfo,"^",3)
	.s cBill1=$p(InsuDicInfo,"^",4)
	.s cBill2=$p(InsuDicInfo,"^",5)
	.s cDemo=$p(InsuDicInfo,"^",6)
	.s DicAuthorityFlag=$p(InsuDicInfo,"^",7)
	.s DicOPIPFlag=$p(InsuDicInfo,"^",8)
	.s IsDefaultFlag=$p(InsuDicInfo,"^",9)
	.s DicUseFlag=$p(InsuDicInfo,"^",10)
	.s DicRelationFlag=$p(InsuDicInfo,"^",11)
	.s DicBill3=$p(InsuDicInfo,"^",12)
	.s DicBill4=$p(InsuDicInfo,"^",13)
	.s DicBill5=$p(InsuDicInfo,"^",14)
	.s HospDr=$p(InsuDicInfo,"^",15)
	.q:+HospDr=0 ;公有数据不需要对照
	.s QuitFlag=""
	.;剔出已经进行过表结构登记的
	.set DicCfgCode="INSU_DicSys_"_cCode
	.set tmpTableListID=$o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(DicCfgCode,"U"),0))
	.i +tmpTableListID'=0  d
	..s QuitFlag="Y"
	.q:QuitFlag="Y"
	.;剔除已有的
	.s INSUConBDPTableList=$o(^DHCINDID("0","ITypeCode","INSUConBDPTableList",cCode,""))
	.q:+INSUConBDPTableList'=0 
	.;剔除不带医保类型的数据
	.s checkCode=""
	.for  s checkCode=$o(DLLTypeArr(checkCode))  q:checkCode=""  d
	..s checkCodeLen=($l(checkCode)-1)
	..s DicCodeSplit=$e(cCode,*-checkCodeLen,*)
	..i DicCodeSplit=checkCode  d
	...s QuitFlag="N" ;该字典带医保类型
	.q:QuitFlag'="N"
	.s Obj=##class(User.INSUDicData).%New()
	.s Obj.INDIDDicType="INSUConBDPTableList"
	.s Obj.INDIDDicCode=cCode
	.s Obj.INDIDDicDesc=cDesc
	.d Obj.%Save()
	.;s SQLStr="INSERT INTO insu_dicdata (INDID_DicType,INDID_DicCode,INDID_DicDesc) VALUES ('INSUConBDPTableList','"_cCode_"','"_cDesc_"')"

	q 0
}

/// Creator: tangzf
/// CreateDate: 2019-07-18
/// Descript: 数据授权
/// Input: 
/// Output: 
/// Return:  
/// DeBug: w ##class(web.INSUDicDataCom).Authorize()
ClassMethod Authorize(rowId, Hospital) As %String
{
	q:+Hospital=0 "-1"
	s ^CacheTemp("diagAuthorize")=$lb(rowId, Hospital)
	set args="^"_$g(^DHCINDID(rowId))
	// 授权子类 必须先授权分类
	set Flag="N"
	set DicType=$p(args,"^",2)
	set DicId="" 
	for  set DicId=$o(^DHCINDID("0","ITypeCode","SYS",DicType,DicId)) quit:(DicId="")||(DicType="SYS")  d
	.set TmpHospitalDr=$p(^DHCINDID(DicId),"^",15)
	.quit:Hospital'=TmpHospitalDr
	.set Flag="Y"
	quit:(Flag'="Y")&&(DicType'="SYS") -99 
	// 授权子类 必须先授权分类
	set $p(args,"^",16)=Hospital
	s rtn=..Update("","",args)
	quit rtn
}

/// Creator: tangzf
/// CreateDate: 2020-06-17
/// Descript: 医保系统配置界面-密码校验-只有密码正确才可以进行增删改
/// 				目前规则是 当前日期反转 例如:20200617 ,实际密码为7160202
/// Input: EncodeType : 加密类型
/// Output: 
/// Return: "Y" 有权操作 ， "N" 无权操作  
/// DeBug: w ##class(web.INSUDicDataCom).CehckPassWard()
ClassMethod CehckPassWard(PassWard, EncodeType = "") As %String
{
	new (PassWard,EncodeType)
	set rtn="N"
	set TmpPassWard=$$ALPHAUP^SSUTIL4($reverse($zd(+$h,3)))
	if TmpPassWard=PassWard  d
	.set rtn="Y"
	quit rtn
}

/// Creator: tangzf
/// CreateDate: 2020-06-17
/// Descript: 获取对照类型字典对照日期
/// 				
/// Input: 
/// Output: 
/// Return:  
/// DeBug: w ##class(web.INSUDicDataCom).GetConDateTime()
ClassMethod GetConDateTime() As %String
{
	quit +$h_"|"_$p($h,",",2)
}

/// w ##class(web.INSUDicDataCom).GetSysExt("","","HISPROPertyHBA","2")
ClassMethod GetSysExt(itmjs As %Library.String = "", itmjsex As %Library.String = "", DicType As %Library.String = "", HospDr As %Library.String = "") As %String
{
	s DicStr="",SpecialDicStr=""
	S CommonDicStr=$$GetSys^DHCINSUDicData(DicType,"",HospDr)                      //先取通用的字典数据

	i HospDr'="" {
		s HospitalCode=$p($g(^CT("HOSP",HospDr)),"^",1)
		s SpecialDicStr=$$GetSys^DHCINSUDicData(DicType_HospitalCode,"",HospDr)    //按字典类型+院区取字典数据
		i SpecialDicStr="0" s SpecialDicStr=""
	}
	k ^Temp($j,"Dic")
    s SCnt=$l(SpecialDicStr,"!")
    s CCnt=$l(CommonDicStr,"!")
    f i=2:1:CCnt d
    .s RInfo=$P(CommonDicStr,"!",i)
    .s DicCode=$P(RInfo,"^",3)
    .s ^Temp($j,"Dic",DicCode)=RInfo
    f i=2:1:SCnt d
    .s RInfo=$P(SpecialDicStr,"!",i)
    .s DicCode=$P(RInfo,"^",3)
    .s ^Temp($j,"Dic",DicCode)=RInfo
    s DicCode="",DicStr=""
    f  s DicCode=$O(^Temp($j,"Dic",DicCode)) q:DicCode=""  d
    .s DicStr=DicStr_"!"_^Temp($j,"Dic",DicCode)
	i DicStr="" d
	.s DicStr="0"
	k ^Temp($j,"Dic")
	q DicStr
}

/// 根据代码类别和位置取字典的值
/// SysType:SYS代码
/// Code:代码
/// Zhan 2012-06-20
/// 取值的位置
/// w ##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPertyGZA","isCanReadCardByDLL",4)
/// w ##class(web.INSUDicDataCom).GetDicByDescAndInd("AKC02100A","在职",3,2)
ClassMethod GetDicByDescAndInd(SysType, Desc, Ind, HospDr) As %String
{
	n (SysType,Desc,Ind,HospDr)
	
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(SysType,HospDr)
	
	s QueryByCode="-1",OutStr=""
	q:$d(^DHCINDID(0,"IType",SysType))=0 QueryByCode
	s rowid=0
	f  s rowid=$o(^DHCINDID(0,"IType",SysType,rowid))	q:rowid=""  d
	.s s=$g(^DHCINDID(rowid))
	.s DicType=$p(s,"^",1)
	.s DicCode=$p(s,"^",2)
	.s DicDesc=$p(s,"^",3)
	.s DicBill1=$p(s,"^",4)
	.q:(Desc'=DicDesc)&(Desc'="")
	.s DicBill2=$p(s,"^",5)
	.s DicDemo=$p(s,"^",6) 
	.s tHospDr=$p(s,"^",15) 
	.;q:GroupHospDr'=HospDr 
	.q:GroupHospDr'=tHospDr	;upt 20221128 HanZH
	.s:OutStr'="" OutStr=OutStr_"$"_rowid_"^"_DicType_"^"_DicCode_"^"_DicDesc_"^"_DicDemo_"^"_DicBill1_"^"_DicBill2
	.s:OutStr="" OutStr=rowid_"^"_DicType_"^"_DicCode_"^"_DicDesc_"^"_DicDemo_"^"_DicBill1_"^"_DicBill2

	i ($l(OutStr,"^")>1)&(Ind'=0) d
	.s QueryByCode=$p(OutStr,"^",Ind)
	e  d
	.s QueryByCode=OutStr
	q QueryByCode
}

Query QueryDicByTypeOrCodeDesc(Type As %String, HospDr, dicKey = "", keyDemo = "") As websys.Query(ROWSPEC = "id,cType,cCode,cDesc,cDemo,cBill1,cBill2,selected:%Boolean,DicAuthorityFlag,DicOPIPFlag,DicUseFlag,DicRelationFlag,DicBill3,DicBill4,DicBill5") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryDicByTypeOrCodeDesc","Skc516","","OP")
ClassMethod QueryDicByTypeOrCodeDescExecute(ByRef qHandle As %Binary, Type As %String, HospDr, dicKey = "", keyDemo = "") As %Status
{
	set ^CacheTemp("QueryDicByTypeOrCodeDesc")=$lb(Type,  HospDr,dicKey,keyDemo)
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	q:Type="" $$$OK
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(dicKey)
	s tDemo=$$ALPHAUP^SSUTIL4(keyDemo)
	s OutString=$$Query^DHCINSUDicData(Type,"",HospDr)	
	
	s JustId=+$p(OutString,"^",2)
	s Index=""
	f  s Index=$o(^CacheTemp("INSUDic",JustId,Index)) q:Index=""  d
	.s DataString=$g(^CacheTemp("INSUDic",JustId,Index))
	.s id=$p(DataString,"^",1)
    .s cType=$p(DataString,"^",2)
    .s cCode=$p(DataString,"^",3)
    .s cDesc=$p(DataString,"^",4)
    .s cDemo=$p(DataString,"^",5)
    .s cBill1=$p(DataString,"^",6)  
    .s cBill2=$p(DataString,"^",7)
    .s DicAuthorityFlag=$p(DataString,"^",8)
    .s DicOPIPFlag=$p(DataString,"^",9)
    .s DicDefaultFlag=$p(DataString,"^",10)
    .s IsDefaultFlag="false"
    .s:DicDefaultFlag="Y" IsDefaultFlag="true"
    .s DicUseFlag=$p(DataString,"^",11)
    .s DicRelationFlag=$p(DataString,"^",12)
    .s DicBill3=$p(DataString,"^",13)
    .s DicBill4=$p(DataString,"^",14)
    .s DicBill5=$p(DataString,"^",15)
    .s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(cCode,4,"")
	.s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(cDesc,3,"")
	.q:($$ALPHAUP^SSUTIL4(cCode)'[tCodeAndDesc)&&(HZSPCode'[tCodeAndDesc)&&(HZPYCode'[dicKey)&&(cDesc'[dicKey)&&($$ALPHAUP^SSUTIL4(cDemo)'[tCodeAndDesc)&&(cDemo'[dicKey)
	.s HZPYDemo=##class(web.DHCINSUPort).GetCNCODE(cDemo,3,"")
	.q:($$ALPHAUP^SSUTIL4(cDemo)'[tDemo)&&(HZPYDemo'[tDemo)&&(cDemo'[keyDemo)
	.d Build2
	k ^CacheTemp("INSUDic",JustId)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build2
	set Data=$lb(id,cType,cCode,cDesc,cDemo,cBill1,cBill2,IsDefaultFlag,DicAuthorityFlag,DicOPIPFlag,DicUseFlag,DicRelationFlag,DicBill3,DicBill4,DicBill5)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 根据关键字查询查询区划
/// w ##class(web.INSUDicDataCom).GetAdmdvsForNet("NC","","4","5",2)
ClassMethod GetAdmdvsForNet(QKWords As %String, PCCode As %String = "", ELen As %String, PageNum As %String = "10", HospDr As %String) As %String
{
	q:(QKWords="")!(HospDr="") "0!-1"
	Set repid=$I(^CacheTemp(0,"Admdvs"))
	k ^CacheTemp(0,"Admdvs",repid)
 s ^TEMP("DingSHAdmdvs")=QKWords_","_PCCode_","_ELen_","_PageNum_","_HospDr
	
 s ind=1
 s DicType="admdvs00A"  
 s aliQWord=$$ALPHAUP^SSUTIL4(QKWords)
 q:'$d(^DHCINDID("0","ITypeCode",DicType)) 0
 
 
 s CCCodeDefault=""
 s DicCC=##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty00A","CenterNoDefault",4,HospDr)
 i PCCode=""  d
 .s PCCode=$e(DicCC,1,2)_"0000"
 .s CCCodeDefault=$e(DicCC,1,4)_"00"
 

  s PageIndex=0, DicCode=""
  i PCCode'=""    d
  .f  s DicCode=$o(^DHCINDID("0","ITypeCode",DicType,DicCode)) q:(DicCode="")||(+PageIndex=+PageNum)  d
  ..q:$e(PCCode,1,2)'=$e(DicCode,1,2)
  ..q:(CCCodeDefault'="")&&(CCCodeDefault=DicCode)
  ..d BuildAdmdvs
  e   d
  .f  s DicCode=$o(^DHCINDID("0","ITypeCode",DicType,DicCode)) q:(DicCode="")||(+PageIndex=+PageNum)  d 
  ..d BuildAdmdvs
  
 q (ind-1)_"!"_repid
 
BuildAdmdvs
  s ParamHospital=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(DicType,HospDr) 
 s id=""
 f  s id=$o(^DHCINDID("0","ITypeCode",DicType,DicCode,id)) q:(id="")||(+PageIndex=+PageNum)  d
 .s DataHospital=$p($g(^DHCINDID(id)),"^",15)
 .q:ParamHospital'=DataHospital 
 .s DicInfo=$g(^DHCINDID(id))
 .s DicCode=$p(DicInfo,"^",2)
 .//b ;000
 .s FilterDicCode=$e(DicCode,1,ELen)_$e("000000",ELen+1,$l(DicCode))
 .q:FilterDicCode'=DicCode
 .s DicDesc=$p(DicInfo,"^",3)
 .s DicRJ=##class(web.DHCINSUPort).GetCNCODE(DicDesc,4,"")
 .//b ;ll
 .q:(DicRJ'[aliQWord)&&(DicDesc'[aliQWord)&&(DicCode'[aliQWord)
 .s DicType=$p(DicInfo,"^",1)
 .s DicBill1=$p(DicInfo,"^",4)
 .s DicBill2=$p(DicInfo,"^",5)
 .s DicDemo=$p(DicInfo,"^",6) 
 .s PageIndex=PageIndex+1 
 .d BuildForNet
 q 
 
 
BuildForNet
 	Set ^CacheTemp(0,"Admdvs",repid,ind)=DicType_"^"_DicCode_"^"_DicDesc_"^"_DicRJ_"^"_DicBill1_"^"_DicBill2_"^"_DicDemo
 	Set ind=ind+1
 	q
}

/// w ##class(web.INSUDicDataCom).GetAdmdvsForNetFromCacheTmp("2",1)
ClassMethod GetAdmdvsForNetFromCacheTmp(ID As %String, index As %String) As %String
{
	 n (ID,index)
     s mCurrRowCacheTemp=""
     s outstr=""
     s mCurrRowCacheTemp=$g(^CacheTemp(0,"Admdvs",ID ,index))
     s outstr=mCurrRowCacheTemp
     i $o(^CacheTemp(0,"Admdvs",ID,""),-1)=index d
  	 .k ^CacheTemp(0,"Admdvs",ID)			
     q outstr
}

/// 加载省字典数据
/// w ##class(web.INSUDicDataCom).GetPCCodeInfo("","2")
ClassMethod GetPCCodeInfo(KWords, HospDr) As %String
{
  s DicType="admdvs00A" 
  q:'$d(^DHCINDID("0","ITypeCode",DicType))
  s aliQWord=$$ALPHAUP^SSUTIL4(KWords)	
  s Rtn=""
  s ParamHospital=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(DicType,HospDr) 
  s DicCode=""
  f  s DicCode=$o(^DHCINDID("0","ITypeCode",DicType,DicCode)) q:(DicCode="")  d
  .q:($e(DicCode,1,2)_"0000")'=DicCode
  .s id=""
  .f  s id=$o(^DHCINDID("0","ITypeCode",DicType,DicCode,id)) q:id=""  d
  ..s DataHospital=$p($g(^DHCINDID(id)),"^",15)
  ..q:ParamHospital'=DataHospital 
  ..s s=$g(^DHCINDID(id))
  ..s DicType=$p(s,"^",1)
  ..s DicCode=$p(s,"^",2)
  ..s DicDesc=$p(s,"^",3)
  ..s DicBill1=$p(s,"^",4)
  ..s DicBill2=$p(s,"^",5)
  ..s DicDemo=$p(s,"^",6) 
  ..s DicAuthorityFlag=$p(s,"^",7)
  ..s DicOPIPFlag=$p(s,"^",8)
  ..s DicDefaultFlag=$p(s,"^",9)
  ..s DicUseFlag=$p(s,"^",10)
  ..s DicRelationFlag=$p(s,"^",11)
  ..s DicBill3=$p(s,"^",12)
  ..s DicBill4=$p(s,"^",13)
  ..s DicBill5=$p(s,"^",14)
  ..s Rtn=Rtn_"!"_id_"^"_DicType_"^"_DicCode_"^"_DicDesc_"^"_DicDemo_"^"_DicBill1_"^"_DicBill2_"^"_DicAuthorityFlag_"^"_DicOPIPFlag_"^"_DicDefaultFlag_"^"_DicUseFlag_"^"_DicRelationFlag_"^"_DicBill3_"^"_DicBill4_"^"_DicBill5
  q Rtn
}

/// 获取医保医疗类别信息
/// 丁少华 20221206 
/// KeyWords:拼音，代码，描述 等关键字（为空：查询全部）
/// AdmDr：Pa_Adm.Rowid 
/// PrtDr: 门诊发票Id或者集中打印进程Id 
/// AdmReadId:就诊或发票费别 (PAC_AdmReason.Rowid)（如果为空，先取发票上费别，其次取就诊上的费别）
/// HospDr:院区指针（如果为空，先取发票上院区，其次取就诊上的院区）
/// ExpStr:门诊住院标识（OP:门诊/IP:住院,"":全部）^CPPFlag(集中打印标识 Y 或 【N或""】)^退费标识(收费:,退费传S)^医保结算表Id:(退费不为空)
/// Return: $lb(id:rowid,cCodec:医疗类别代码,cDesc:医疗类别描述,cDemo:备注,cBill1:预留1,cBill2:预留2,selected:true or false)
/// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryMedType","","","","4","2","OP^^^")
/// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryMedType","","","17","4","2","OP^^^")
/// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryMedType","","5408","","4","2","OP^^S^^")
Query QueryMedType(KeyWords As %String = "", PrtDr As %String = "", AdmDr As %String = "", AdmReadId As %String = "", HospDr As %String = "", ExpStr As %String = "", langId = "") As %Query(ROWSPEC = "id,cCode,cDesc,cDemo,cBill1,cBill2,selected:%Boolean") [ SqlProc ]
{
}

ClassMethod QueryMedTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMedTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryMedType","","","","4","2","OP^^^")
/// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryMedType","","","17","4","2","OP^^^")
/// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryMedType","","5408","","4","2","OP^^S^^")
ClassMethod QueryMedTypeExecute(ByRef qHandle As %Binary, KeyWords As %String = "", PrtDr As %String = "", AdmDr As %String = "", AdmReadId As %String = "", HospDr As %String = "", ExpStr As %String = "", langId = "") As %Status
{
	set ^CacheTemp("QueryMedTypeExecute")=$lb(KeyWords, PrtDr , AdmDr,AdmReadId, HospDr,ExpStr)
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s OPIPFlag=$P(ExpStr,"^",1)     //字典数据的门诊住院标识 OP、IP、""
	s CPPFlag=$P(ExpStr,"^",2)      //集中打印标识  Y、 N或空
	s StrikeFlag=$P(ExpStr,"^",3)   //退费标识 N或""、S
	s InsuDivideId=$P(ExpStr,"^",4) //医保结算表Rowid
    s InsuType="",InAdmDr = ""
	q:(StrikeFlag="S")&&((PrtDr="")&&(InsuDivideId="")) $$$OK  //退费时发票或医保结算表Id不能为空
	if (+InsuDivideId > 0) {
      s HospDr = $P(^DHCINDIV(InsuDivideId),"^",71)
	  s InAdmDr = $P(^DHCINDIV(InsuDivideId),"^",2)
	  s InsuType = $P(^DHCINADM(InAdmDr),"^",18)
   }
   // 取院区 按门诊发票
   if ((+PrtDr> 0)&&((CPPFlag="")||(CPPFlag="N"))&&(HospDr=""))
	{
        s HospDr = $P(^DHCINVPRT(+PrtDr),"^",39)
	}
   //取院区 按集中打印发票
  if (+PrtDr>0)&&(CPPFlag="Y")&&(HospDr=""){
 	  s JustThread=+PrtDr
 	  s tmpAdmReasonId="",myIdx="",tmpPrtDr = ""
 	  s tmpAdmReasonId = $O(^DHCTMPACCColPRT("IP",JustThread,""),-1)
 	  s:+tmpAdmReasonId>0 myIdx =$O(^DHCTMPACCColPRT("IP",JustThread,tmpAdmReasonId,""),-1)
 	  s:+myIdx>0 tmpPrtDr =$O(^DHCTMPACCColPRT("IP",JustThread,tmpAdmReasonId,myIdx,"PrtRowID",""),-1)
	  s:+tmpPrtDr>0 HospDr = $P(^DHCINVPRT(+tmpPrtDr),"^",39)
   }
  //取院区 按就诊
  if ((+AdmDr> 0)&&(HospDr=""))
	{
         s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
	}

  //取费别 按门诊发票
  if ((+PrtDr>0)&&((CPPFlag="")||(CPPFlag="N"))&&(AdmReadId="")){
      s AdmReadId = $P(^DHCINVPRT(+PrtDr),"^",9)
   }
   //取费别 按集中打印
  if (+PrtDr>0)&&(CPPFlag="Y")&&(AdmReadId=""){
 	  s JustThread=+PrtDr
 	  s tmpAdmReasonId="",myIdx="",tmpPrtDr = ""
 	  s tmpAdmReasonId = $O(^DHCTMPACCColPRT("IP",JustThread,""),-1)
 	  s:+tmpAdmReasonId>0 myIdx =$O(^DHCTMPACCColPRT("IP",JustThread,tmpAdmReasonId,""),-1)
 	  s:+myIdx>0 tmpPrtDr =$O(^DHCTMPACCColPRT("IP",JustThread,tmpAdmReasonId,myIdx,"PrtRowID",""),-1)
	  s:+tmpPrtDr>0 AdmReadId = $P(^DHCINVPRT(+tmpPrtDr),"^",9)
   }
   //取费别 按就诊
   if (AdmDr>0)&&(AdmReadId=""){
     s AdmReadId=$P(^PAADM(AdmDr,1),"^",7)
   }
   q:((InsuType="") &&(AdmReadId="")) $$$OK 
   q:(HospDr="") $$$OK 
   if (StrikeFlag="S")&&(InsuDivideId=""){
	  s InsuDivideId = $P(^DHCINVPRT(+PrtDr),"^",30)  //PRTInsDivDR
      s:+InsuDivideId=0 InsuDivideId = $O(^DHCINDIV("0","DHCInvPrt",PrtDr,""),-1)
	  s:InsuDivideId>0 InAdmDr = $P(^DHCINDIV(InsuDivideId),"^",2)
	  s:InsuDivideId>0 InsuType = $P(^DHCINADM(InAdmDr),"^",18)
   }
   //从医保就诊信息获取最近医就诊的医疗类别
   s InsuAdmType = ""
   if (InAdmDr = "")&&(AdmDr > 0)
   {
	 s InAdmDr = $O(^DHCINADM("0","ADM",AdmDr,""),-1)
   }
   if +InAdmDr > 0
   {
	 s ActFlag=""
	 s ActFlag =$P(^DHCINADM(InAdmDr),"^",11)
	 if (ActFlag="A")||(ActFlag="O"){
       s InsuAdmType =$P(^DHCINADM(InAdmDr),"^",14)
	 }
   }
   if InsuType = ""{
     s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReadId,6,HospDr,langId)
   }
	s OutString=$$Query^DHCINSUDicData("med_type"_InsuType,"",HospDr,langId)	
	s JustId=+$p(OutString,"^",2)
	s Index=""
	f  s Index=$o(^CacheTemp("INSUDic",JustId,Index)) q:Index=""  d
	.s DataString=$g(^CacheTemp("INSUDic",JustId,Index))
	.s id=$p(DataString,"^",1)
    .s cType=$p(DataString,"^",2)
    .s cCode=$p(DataString,"^",3)
    .s cDesc=$p(DataString,"^",4)
	.s cDescPinYin=##class(web.DHCINSUPort).GetCNCODE(cDesc,4,"")
    .q:(KeyWords'="")&&(cDescPinYin'[$ZCVT(KeyWords,"U"))&&(cDesc'[KeyWords)&&(cCode'[KeyWords)
    .s cDemo=$p(DataString,"^",5)
    .s cBill1=$p(DataString,"^",6)  
    .s cBill2=$p(DataString,"^",7)
    .s DicOPIPFlag=$p(DataString,"^",9)
    .q:(OPIPFlag'="")&&(OPIPFlag'=DicOPIPFlag)
    .s DicDefaultFlag=$p(DataString,"^",10)
	.s IsDefaultFlag="false"
	.//根据最近一次医保就诊默认医疗类别
	.i InsuAdmType = cCode d 
	..s IsDefaultFlag = "true"
    .s:(InsuAdmType="")&&(DicDefaultFlag="Y") IsDefaultFlag="true"
	.d BuildMedType
	k ^CacheTemp("INSUDic",JustId)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildMedType
	set Data=$lb(id,cCode,cDesc,cDemo,cBill1,cBill2,IsDefaultFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryMedTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMedTypeExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// 获取医保慢特病病种信息
/// 丁少华 20221206 
/// KeyWords:拼音，代码，描述 等关键字（为空：查询全部）
/// AdmDr：Pa_Adm.Rowid 
/// PrtDr: 门诊发票Id或者集中打印进程Id 
/// AdmReadId:就诊或发票费别 (PAC_AdmReason.Rowid)（如果为空，先取发票上费别，其次取就诊上的费别）
/// PapmiDr:患者基本信息表.Rowid 
/// InsuNo:医保号
/// HospDr:院区指针（如果为空，先取发票上院区，其次取就诊上的院区）
/// ExpStr:门诊住院标识（OP:门诊/IP:住院,"":全部）^CPPFlag(集中打印标识 Y 或 【N或""】)^退费标识(收费:,退费传S)^医保结算表Id:(退费不为空)
/// Return: $lb(DiagCode:病种代码,DiagDesc:病种名称,DiagType:病种类型,selected:true or false)
/// 调用 示例：
/// 医生站调用，有就诊的情况：d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryChronic","","","4153","4","","","2","OP^^^")
/// 医生站调用，无就诊的情况：d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryChronic","","","","4","518","","2","OP^^^")
/// 门诊收费调用：d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryChronic","","","4153","4","","","2","OP^N^^")
/// 集中收费调用：d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryChronic","","进程号","","4","","","2","OP^Y^^")
/// 门诊退费调用：d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryChronic","","发票号","","4","","","2","OP^^S^")
Query QueryChronic(KeyWords As %String = "", PrtDr As %String = "", AdmDr As %String = "", AdmReadId As %String = "", PapmiDr As %String = "", InsuNo As %String = "", HospDr As %String = "", ExpStr As %String = "", langId = "") As %Query(ROWSPEC = "DiagCode:%String,DiagDesc:%String,DiagType:%String,selected:%Boolean") [ SqlProc ]
{
}

ClassMethod QueryChronicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryChronicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryChronicExecute(ByRef qHandle As %Binary, KeyWords As %String = "", PrtDr As %String = "", AdmDr As %String = "", AdmReadId As %String = "", PapmiDr As %String = "", InsuNo As %String = "", HospDr As %String = "", ExpStr As %String = "", langId = "") As %Status
{
	set ^CacheTemp("QueryChronicExecute")=$lb(KeyWords, PrtDr , AdmDr,AdmReadId,PapmiDr,InsuNo, HospDr,ExpStr)
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s OPIPFlag=$P(ExpStr,"^",1)     //字典数据的门诊住院标识 OP、IP、""
	s CPPFlag=$P(ExpStr,"^",2)      //集中打印标识  Y、 N或空
	s StrikeFlag=$P(ExpStr,"^",3)   //退费标识 N或""、S
	s InsuDivideId=$P(ExpStr,"^",4) //医保结算表Rowid
	q:(StrikeFlag="S")&&((PrtDr="")&&(InsuDivideId="")) $$$OK  //退费时发票或医保结算表Id不能为空
	 s InAdmDr = ""
	if (+InsuDivideId > 0) {
      s HospDr = $P(^DHCINDIV(InsuDivideId),"^",71)
	  s InAdmDr = $P(^DHCINDIV(InsuDivideId),"^",2)
	  s AdmDr = $P(^DHCINDIV(InsuDivideId),"^",1)
   }
   // 取病人基本信息表Id和院区 按门诊发票
   if ((+PrtDr> 0)&&((CPPFlag="")||(CPPFlag="N"))&&(PapmiDr=""))
	{
        s HospDr = $P(^DHCINVPRT(+PrtDr),"^",39)
		s PapmiDr = $P(^DHCINVPRT(+PrtDr),"^",15)
	}
   //取病人基本信息表Id和院区 按集中打印发票
  if (+PrtDr>0)&&(CPPFlag="Y")&&(PapmiDr=""){
 	  s JustThread=+PrtDr
 	  s tmpAdmReasonId="",myIdx="",tmpPrtDr = ""
 	  s tmpAdmReasonId = $O(^DHCTMPACCColPRT("IP",JustThread,""),-1)
 	  s:+tmpAdmReasonId>0 myIdx =$O(^DHCTMPACCColPRT("IP",JustThread,tmpAdmReasonId,""),-1)
 	  s:+myIdx>0 tmpPrtDr =$O(^DHCTMPACCColPRT("IP",JustThread,tmpAdmReasonId,myIdx,"PrtRowID",""),-1)
	  s:+tmpPrtDr>0 HospDr = $P(^DHCINVPRT(+PrtDr),"^",39)
	  s:+tmpPrtDr>0 PapmiDr = $P(^DHCINVPRT(+PrtDr),"^",15)
   }
  //病人基本信息表Id和院区 按就诊
  if ((+AdmDr> 0)&&(PapmiDr=""))
	{
         s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
		 s PapmiDr =$P(^PAADM(AdmDr),"^",1)
	}
  //取费别 按门诊发票
  if ((+PrtDr>0)&&((CPPFlag="")||(CPPFlag="N"))&&(AdmReadId="")){
      s AdmReadId = $P(^DHCINVPRT(+PrtDr),"^",9)
   }
   //取费别 按集中打印
  if (+PrtDr>0)&&(CPPFlag="Y")&&(AdmReadId=""){
 	  s JustThread=+PrtDr
 	  s tmpAdmReasonId="",myIdx="",tmpPrtDr = ""
 	  s tmpAdmReasonId = $O(^DHCTMPACCColPRT("IP",JustThread,""),-1)
 	  s:+tmpAdmReasonId>0 myIdx =$O(^DHCTMPACCColPRT("IP",JustThread,tmpAdmReasonId,""),-1)
 	  s:+myIdx>0 tmpPrtDr =$O(^DHCTMPACCColPRT("IP",JustThread,tmpAdmReasonId,myIdx,"PrtRowID",""),-1)
	  s:+tmpPrtDr>0 AdmReadId = $P(^DHCINVPRT(+tmpPrtDr),"^",9)
   }
   //取费别 按就诊
   if (AdmDr>0)&&(AdmReadId=""){
     s AdmReadId=$P(^PAADM(AdmDr,1),"^",7)
   }
   if (((PapmiDr="")&&(InsuNo=""))||(AdmReadId=""))  quit $$$OK
   //从医保就诊信息获取最近一次医保就诊的病种信息
   s AdmChronicCode = ""
   if (StrikeFlag="S")&&(InsuDivideId=""){
	  s InsuDivideId = $P(^DHCINVPRT(+PrtDr),"^",30)  //PRTInsDivDR
      s:+InsuDivideId=0 InsuDivideId = $O(^DHCINDIV("0","DHCInvPrt",PrtDr,""),-1)
	  s:InsuDivideId>0 InAdmDr = $P(^DHCINDIV(InsuDivideId),"^",2)
   }
  if (InAdmDr="")&&(AdmDr>0)
   {
	 s InAdmDr = $O(^DHCINADM("0","ADM",AdmDr,""),-1)
   }
   if +InAdmDr>0
   {
	 s ActFlag =$P(^DHCINADM(InAdmDr),"^",11)
	  i (ActFlag="A")||(ActFlag="O"){
        s InsuAdmType =$P(^DHCINADM(InAdmDr),"^",14)
        s INXStr9 =$P(^DHCINADM(InAdmDr),"^",38)  //病种编码|病种描述|手术操作代码|手术操作名称
	    s AdmChronicCode=$P(INXStr9,"|",1)
	 }
   }
    set PatientNo=$s((+PapmiDr'=0):$p($g(^PAPER(PapmiDr,"PAT",1)),"^",1),1:"")
    set HospCode=$s((+HospDr'=0):$p($g(^CT("HOSP",HospDr)),"^",1),1:"")
	set rset=##class(%ResultSet).%New("insuqc.service.ServicePort:GetChronicList")
	do rset.Execute(PatientNo, InsuNo, AdmReadId, HospCode,langId) //+20230103 增加多语言支持 
	while (rset.Next()) {
		set diagCode=rset.Get("DiagCode")
		set diagDesc=rset.Get("DiagDesc")
		set diagDescPinYin=##class(web.DHCINSUPort).GetCNCODE(diagDesc,4,"")
        continue:(KeyWords'="")&&(diagDescPinYin'[$ZCVT(KeyWords,"U"))&&(diagDesc'[KeyWords)&&(diagCode'[KeyWords)
		set diagType=rset.Get("DiagType")
	    s IsDefaultFlag="false"
	   //根据最近一次医保就诊默认病种信息
	    i AdmChronicCode = diagCode {
          s IsDefaultFlag = "true"
	    } 
		do OutputChronicList
	}
	quit $$$OK
   
OutputChronicList
	set Data=$lb(diagCode,diagDesc,diagType,IsDefaultFlag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

ClassMethod QueryChronicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryChronicExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// 通过科室描述获取医保科室信息
/// 汪新强 20221216 
/// Type:  字典类别
/// Desc： 科室描述
/// HospDr:院区指针
Query QueryDicForDesc(Type As %String, Desc As %String = "", HospDr) As %Query(ROWSPEC = "cCode,cDesc,") [ SqlProc ]
{
}

ClassMethod QueryDicForDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDicForDescExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)  
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.INSUDicDataCom","QueryDicForDesc","dept00A","内科","2")
ClassMethod QueryDicForDescExecute(ByRef qHandle As %Binary, Type As %String, Desc As %String = "", HospDr) As %Status
{
    set ^CacheTemp("QueryDic1Execute")=$lb(Type, Desc , HospDr)
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    q:Type="" $$$OK
    q:'$d(^DHCINDID("0","ITypeCode",Type)) 0  
    s ParamHospital=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId(Type,HospDr)
    s DicCode=""
    s id=""
    f  s DicCode=$o(^DHCINDID("0","ITypeCode",Type,DicCode)) q:DicCode=""  d
    .f  s id=$o(^DHCINDID("0","ITypeCode",Type,DicCode,id)) q:id=""  d
    ..s DicInfo=$g(^DHCINDID(id))
    ..q:ParamHospital'=$p(DicInfo,"^",15)
    ..s cDesc=$p(DicInfo,"^",3)
    ..q:'(cDesc[Desc)
    ..s cCode=$p(DicInfo,"^",2)
    ..d BuildDicForDesc
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
BuildDicForDesc
    set Data=$lb(cCode,cDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod QueryDicForDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDicForDescExecute ]
{
    
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

}
