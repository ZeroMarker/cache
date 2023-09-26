Class web.CSSDHUI.CSSDType Extends %RegisteredObject [ Abstract, Not ProcedureBlock ]
{

ClassMethod sssLock(lockName As %String) As %String
{
	N (lockName)
	l +^CSSDLOCK(lockName):20 e  q -99   ;加锁失败
	q 0
}

ClassMethod sssUnLock(lockName As %String)
{
	N (lockName)
	l -^CSSDLOCK(lockName)
	q
}

/// 返回科室所在医院的RowId
ClassMethod sssHospId(ctloc As %String) As %String
{
	n (ctloc)
	q:ctloc="" ""
	s HospID=$p($G(^CTLOC(ctloc)),"^",22)
	q HospID
}

/// 备注内容"行"之间的分隔符
ClassMethod sssMemoDelim() As %String
{
	q $c(3)
}

/// 解决低版本cache的本函数缺少的问题
ClassMethod Replace(s, fr, to) As %String
{
	n (s,fr,to)
	s l=$l(s,fr)
	s result=""
	f i=1:1:l d
	.s x(i)=$P(s,fr,i)
	.
	f j=1:1:l d
	.i j=1 s result=x(j)
	.e  s result=result_to_x(j)
	q result
}

/// 获取当前日期的月底最后一天(Last_Day 5.2.4不兼容)
/// Argu:	日期(数字型)
/// Return:	月底最后一天(数字型)
ClassMethod sssLASTDAY(da) As %String
{
	n (da)
	s da=$zd(da,3)
	s $p(da,"-",3)="01"
	s da=$p($SYSTEM.SQL.DATEADD("mm",1,da)," ")
	s da=$zdh(da,3)-1
	q da
}

/// 低版本(5.0.15以下)替换$lts
ClassMethod LTS(l, del = ",") As %String
{
	n (l,del)
	s del=$g(del)
	s result=""
	s ll=$ListLength(l)
	f i=1:1:ll d
	.s x=$List(l,i)
	.s result=result_x
	.i i<ll s result=result_del
	q result
}

/// 低版本(5.0.15以下)替换$lfs
ClassMethod LFS(s, del = ",") As %List
{
	n (s,del)
	s num=$l(s,del)
	s li=$listbuild()
	f i=1:1:num d
	.s v=$p(s,del,i)
	.s $list(li,i)=v
	q li
}

/// 取登录者身份参数串
/// Date:2016-11-30
/// Author:zhwh
/// Arguments:
/// Return: 安全组ID^科室ID^用户ID^医院ID
ClassMethod sssParamStr() As %String
{
	q:'$g(%session) ""
	q $g(%session.Data("LOGON.GROUPID"))_"^"_$g(%session.Data("LOGON.CTLOCID"))_"^"_$g(%session.Data("LOGON.USERID"))_"^"_$g(%session.Data("LOGON.HOSPID"))
}

/// 取用户姓名
/// zhwh 
/// 2016-12-29
/// user - RowId Of SSUser
ClassMethod sssUserName(user As %String) As %String
{
	n (user,%session)
	q:+user=0 ""
	s name=$p($G(^SSU("SSUSR",user)),"^",2)
	s name=..%FieldTranslate("User.SSUser","SSUSRName",name)
	q name
}

/// 获取科室名称
/// zhwh
/// 2017-01-06
/// arguments:
///   Loc - RowId of CTLoc
///   
/// w ##class(web.CSSDHUI.CSSDType).sssLocDesc()   
ClassMethod sssLocDesc(Loc As %String) As %String
{
	n (Loc,%session)
	q:Loc="" ""
	s LocDesc=$p($G(^CTLOC(Loc)),"^",2)
	s LocDesc=..%FieldTranslate("User.CTLoc","CTLOCDesc",LocDesc)
	q LocDesc
}

/// 前端获取日期格式: Y-m-d, m/d/Y, d/m/Y 等
/// 目前csr中调用,赋值给websys_DateFormat
/// Creator: tsr
/// CreateDate: 2016-03-02
ClassMethod GetDateFormat() As %String
{
	n (%session)
	s format=3
	s HospId=$s($d(%session):%session.Data("LOGON.HOSPID"),1:"")
	s Param="^^^"_HospId
	;s UseIMedicalDate=##class(web.CSSDHUI.Common.AppCommon).GetCommPropValue("UseIMedicalDate",Param)
	;i (UseIMedicalDate="Y") d
	.;s methodObj=##class(%Dictionary.CompiledMethod).%OpenId("websys.Conversions||DateFormat",0)
	.;q:'$IsObject(methodObj)
	.;s format=##class(websys.Conversions).DateFormat()
	k methodObj
	s dateFormat=$s(format=3:"Y-m-d",format=4:"d/m/Y",format=1:"m/d/Y",1:"Y-m-d")
	q dateFormat
}

/// Description:格式化数字,用于$order排序(因$o按字符串处理)
/// 			ps:其他用途谨慎调用
/// Creator:	wangjiabin
/// CreateDate:	2017-12-27
/// w ##class(web.CSSDHUI.CSSDType).sssNumberSort(123.06)
ClassMethod sssNumberSort(Number As %String) As %String
{
	n (Number)
	s Number=+Number
	s Positive=$p(Number,".",1)
	s Decimal=$p(Number,".",2)
	s SortFormat=$tr($j(Positive,15)_$j(Decimal,6)," ","0")
	q SortFormat
}

/// Description:包装其他产品组的程序调用,避免因版本问题调用不到时报错
/// Creator:	wangjiabin
/// CreateDate:	2018-01-05
/// w ##class(web.CSSDHUI.CSSDType).sssWrap("web.CSSDHUI.InterfaceFromElse","Wrap1",1,2,3,4)
ClassMethod sssWrap(ClassName, MethodName, p1 = "", p2 = "", p3 = "", p4 = "", p5 = "", p6 = "", p7 = "", p8 = "", p9 = "", p10 = "")
{
	s %pcount=$zutil(141)-2		;调用方法的参数个数
	q:%pcount<0 ""
	n (%pcount,ClassName,MethodName,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,%session,%request)
	
	q:(ClassName="")||(MethodName="") ""
	s ClassMethodStr=ClassName_"||"_MethodName
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	q:'$IsObject(CompiledObj) ""
	
	s FormalSpecParsed=CompiledObj.FormalSpecParsed
	s ParsedLen=0
	i FormalSpecParsed'="" d
	.s ParsedLen=$ll(FormalSpecParsed)
	
	s ParamLen=$s(ParsedLen<%pcount:ParsedLen,1:%pcount)		;参数个数
	s ExecuteStr="s Ret=$CLASSMETHOD("_$c(34)_ClassName_$c(34)_","_$c(34)_MethodName_$c(34)
	f i=1:1:ParamLen d
	.s ExecuteStr=ExecuteStr_",p"_i
	s ExecuteStr=ExecuteStr_")"
	x ExecuteStr
	k %pcount
	
	q $g(Ret)
}

/// Description:设置日志记录id(调用基础数据相关方法)
/// 			ps:调用了Set方法,同时要调用Kill方法(见下方)
/// Creator:	wangjiabin
/// CreateDate:	2018-02-01
/// d ##class(web.CSSDHUI.CSSDType).SetLogID()
ClassMethod sssSetLogID()
{
	n (%session)
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.BDP.BDPDataChangeLog||SetLogFlagID",0)
	i $IsObject(CompiledObj) d
	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SetLogFlagID()
	q ""
}

/// Description:清除日志记录id(调用基础数据相关方法)
/// 			ps:$ZT中也添加了此调用
/// Creator:	wangjiabin
/// CreateDate:	2018-02-01
ClassMethod sssKillLogID()
{
	n (%session)
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.BDP.BDPDataChangeLog||KillLogFlagID",0)
	i $IsObject(CompiledObj) d
	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).KillLogFlagID()
	q ""
}

/// Description:错误陷阱$ZT调用
ClassMethod sssError() As %String
{
	q "Error^CSSDHUIERROR"
}

/// Description:html日期(date)Logical格式,转换为html格式
ClassMethod DL2H(d As %String) As %String [ Final ]
{
	n (d)
	q ##class(websys.Conversions).DateLogicalToHtml(d)
}

/// Description:html日期(date)格式,转换为Logical格式
ClassMethod DH2L(d As %String) As %String [ Final ]
{
	n (d)
	q ##class(websys.Conversions).DateHtmlToLogical(d)
}

/// Description:html时间(time)Logical格式,转换为html格式
ClassMethod TL2H(t As %String) As %String [ Final ]
{
	n (t)
	q ##class(websys.Conversions).TimeLogicalToHtml(t)
}

/// Description:html时间(time)格式,转换为Logical格式
ClassMethod TH2L(t As %String) As %String [ Final ]
{
	n (t)
	q ##class(websys.Conversions).TimeHtmlToLogical(t)
}

/// Description: 公用NewPid方法
ClassMethod NewPid()
{
	new
	s PID=$i(^CSSDTMPID("PID"))
	k ^TMPCSSD(PID)
	q PID
}

/// Description:返回HIS版本号
/// Creator:	lxt
/// CreateDate:	2021-2-26
ClassMethod sssHISVersion() As %String
{
	s HISVersion=""
	&sql(SELECT right(SMCF_Name1,5) into :HISVersion FROM SQLUser.cf_sm)
	q +HISVersion
}

/// Description:返回汉字对应的翻译
/// Creator:	lxt
/// CreateDate:	2022-10-24
/// 把item当成键写入翻译, 并获得对应会话的翻译。
/// 如果KEY在当前page下不存在插入空数据
/// @param String  page为当前csp名字(也可是类名)
/// @param String  item为要翻译的键
/// @param Int     langid语言ID
/// @param Int     userid用户ID
/// w ##class(web.CSSDHUI.CSSDType).%Translate("aaaa","哈喽")
ClassMethod %Translate(page = "", item = "", langid = "", userid = "")
{
	n (page, item, langid, userid, %session)
	q:(page="")||(item="") item
	
	s HISVersion=""
	i '$d(^||TMPCSSD("TranslateFlag")) d
	.s HISVersion=..sssHISVersion()
	.s ^||TMPCSSD("TranslateFlag")=HISVersion
	e  d
	.s HISVersion=$p(^||TMPCSSD("TranslateFlag"),"^",1)
	
	s Ret=""
	i '$d(^||TMPCSSD("TranslateFlag",page_item)) d
	.i (HISVersion<8.4) d
	..s Ret=item q
	.e  d
	..s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("websys.Translation||Get",0)
	..i '$IsObject(CompiledObj) s Ret=item q
	..//插入要翻译信息
	..job ##class(websys.Translation).Get(page, item, langid, userid)
	..//获取翻译信息（9.0.0新增一个参数Flag，判断是插入并获取还是仅获取）
	..s Flag="1"
	..i (HISVersion>=9.0) s Ret=##class(websys.Translation).Get(page, item, langid, userid,Flag) q
	..//获取翻译信息（8.4-9.0之前版本，Get方法少一个Flag参数）
	..s Ret=##class(websys.Translation).Get(page, item, langid, userid) q
	.s ^||TMPCSSD("TranslateFlag",page_item)=Ret
	e  d
	.s Ret=$p(^||TMPCSSD("TranslateFlag",page_item),"^",1)
	
	i Ret="" s Ret=item,^||TMPCSSD("TranslateFlag",page_item)=item
	
	q Ret
}

/// Description:返回字段对应的翻译
/// Creator:	lxt
/// CreateDate:	2022-11-25
/// TableName  类名
/// FieldName  字段名
/// FieldDesc  字段值
/// w ##class(web.CSSDHUI.CSSDType).%FieldTranslate("User.CSSDPackage","CSSDPDesc","开口器")
ClassMethod %FieldTranslate(TableName, FieldName, FieldDesc)
{
	n (TableName, FieldName, FieldDesc, %session)
	q:(TableName="")||(FieldName="")||(FieldDesc="") FieldDesc
	s Languages="",HISVersion=""

	i '$d(^||TMPCSSD("FieldTranslateFlag")) d
	.s HISVersion=..sssHISVersion()
	.s ^||TMPCSSD("FieldTranslateFlag")=HISVersion
	e  d
	.s HISVersion=$p(^||TMPCSSD("FieldTranslateFlag"),"^",1)

	s TransStr=TableName_"-"_FieldName_"-"_FieldDesc
	
	s Ret=""
	i '$d(^||TMPCSSD("FieldTranslateFlag",TransStr)) d
	.i (HISVersion<8.4) d
	..s Ret=FieldDesc q
	.e  d
	..s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.Authorize.BDPTranslation||GetTransDesc",0)
	..i '$IsObject(CompiledObj) s Ret=FieldDesc q
	..s Ret=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc(TableName, FieldName, Languages, FieldDesc) q
	.s ^||TMPCSSD("FieldTranslateFlag",TransStr)=Ret
	e  d
	.s Ret=$p(^||TMPCSSD("FieldTranslateFlag",TransStr),"^",1)
	
	i Ret="" s Ret=FieldDesc,^||TMPCSSD("FieldTranslateFlag",TransStr)=FieldDesc
	
	q Ret
}

}
