Import sqluser

/// 工具类
Class web.CSSDHUI.Common.UtilCommon Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

ClassMethod ComboStr(RowId As %String, Description As %String) As %Library.String
{
	n (RowId,Description)
	
	s Description=$Replace(Description,"\","\\")
	s Description=$Replace(Description,"""","\""")						;转义双引号,不需转义单引号
	s Description=$tr(Description,$c(13,10,0,9))
	i ($ISVALIDNUM(Description)&&(+Description=Description)) d
	.s tmpVal=$s(Description<0:-Description,1:Description)
	.s:($e(tmpVal,1)=".") Description=$tr($fn(Description,","),",")		;数字格式处理 .5-->0.5, -.5-->-0.5
	
	s str="{""RowId"":"""_RowId_""",""Description"":"""_Description_"""}"
	q str
}

/// Descript:返回一条record(json)
/// Creator：wangjiabin
/// CreatDate：2013-06-24
/// Table:		
/// Input:数据串, 标题串, 分隔符
/// Output:
/// Return:记录数
ClassMethod GetJsonStr(dataStr, titleStr, del = "^") As %Library.String
{
	n (dataStr,titleStr,del)
	q:dataStr="" "{}"
	q:titleStr="" "{}"
	s len=$l(dataStr,del)
	s tlen=$l(titleStr,del)
	;q:len'=tlen "{}"
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s jsonStr="{"
	f i=1:1:tlen  d
	.s data=$p(dataStr,del,i)
	.
	.s CheckJsonFlag=((data'="")&&(($e(data,1)="{")||($e(data,1)="[")))
	.i CheckJsonFlag s Sc=PJObj.%FromJSON(data)
	.s isObject=(CheckJsonFlag&&(Sc=0))
	.;s isObject=($e(data,1,9)="{""RowId"":")||(($e(data,1,2)="[{"))
	.
	.;仅当不是object格式时进行转义
	.i 'isObject d
	..s data=..Replace(data,"\","\\")
	..s data=..Replace(data,"""","\""")						;转义双引号
	..i ($ISVALIDNUM(data)&&(+data=data)) d
	...s tmpVal=$s(data<0:-data,1:data)
	...s:($e(tmpVal,1)=".") data=$tr($fn(data,","),",")		;数字格式处理 .5-->0.5, -.5-->-0.5
	.
	.s title=$p(titleStr,del,i)
	.i isObject d
	..s DataJsonStr=$c(34)_title_$c(34)_":"_data
	.e  d
	..s DataJsonStr=$c(34)_title_$c(34)_":"_$c(34)_data_$c(34)
	.
	.i i=1 d
	..s jsonStr=jsonStr_DataJsonStr
	.e  d
	..s jsonStr=jsonStr_","_DataJsonStr
	.
	s jsonStr=jsonStr_"}"
	
	s jsonStr=$tr(jsonStr,$c(13,10,0,9))
	q jsonStr
}

/// Creator:ZhanMingChao
/// Description:返回汉字的编码信息
/// Input：	HANZI:汉字
/// 			FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码6:五笔码7:区位码8:笔划数9:郑码)
/// 			SPLIT:分割符(可以为空)
/// Output：
/// 	非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
/// 	0：未找到编码信息
/// CreatDate:2011-06-08
/// w ##class(web.CSSDHUI.Common.UtilCommon).GetCNCODE("东  华",4,"")
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
	n (HANZIS,FLAG,SPLIT)
	s Rtnstr="0"
	q:$g(HANZIS)="" Rtnstr
	s Rtnstr=""
	f i=1:1:$l(HANZIS) d
	.s HANZI=$EXTRACT(HANZIS,i)
	.q:HANZI=" "	
	.s ASCIICODE=$ASCII(HANZI)
	.i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
	..s rowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
	..s tmpstr=""
	..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(rowid))
	..s:FLAG'="" tmpstr=$p(^DHCCharacterEncoding(rowid),"^",FLAG)
	..i Rtnstr=""  d
	...s Rtnstr=tmpstr
	...s Rtnstr=$tr(Rtnstr,"(")		
	...s Rtnstr=$tr(Rtnstr,")")
	...s Rtnstr=$tr(Rtnstr,"?")		//去掉括号等特殊字符带来的"?"
	..e  d
	...s Rtnstr=Rtnstr_SPLIT_tmpstr
	q Rtnstr
}

/// 根据CSP名称获取菜单信息(json格式)
/// w ##class(web.CSSDHUI.Common.UtilCommon).GetMenuInfoByCsp()
ClassMethod GetMenuInfoByCsp(CspName As %String) As %String
{
	n (CspName)
	q:CspName="" "{}"
	q:CspName="cssdhui.menu.csp" "{}"
	q:CspName'["cssdhui." "{}"				;菜单约定一下,简单控制
	s (MenuId,Caption)=""
	&sql(SELECT ID, Caption into :MenuId,:Caption FROM websys.menu WHERE LinkUrl=:CspName)
	
	s Data=MenuId_"^"_Caption
	s Title="MenuId^Caption"
	s MenuInfo=..GetJsonStr(Data,Title)
	q MenuInfo
}

///  Creator:ban
///  CreatDate:2020.8.23
///  Description:消息推送公用方法
///  Table:
///  Input: ReqType 单据类型,ReqLevel 紧急状态,ApplyLocDr 申请科室,SupplyLocDr 供应科室 Message:
///  Output:
///  Return:
/// w ##Class(web.CSSDHUI.Common.UtilCommon).PushMessageApplyToSupply()
ClassMethod PushMessageApplyToSupply(ReqType As %String, ReqLevel As %String, ApplyLocDr As %String, ApplyUserDr As %String, SupplyLocDr As %String, Message As %String)
{
	n (ReqType,ReqLevel,ApplyUserDr,ApplyLocDr,SupplyLocDr,Message)
	;ActionTypeCode为2000:消息通知 2008:紧急通知
	s ActionTypeCode="2000",Rtn=0
	s OtherInfoJson=""
	i ReqLevel=1  d
	.s Message =Message_"为紧急单"
	.s ActionTypeCode="2008"
	i ReqType=3 s Message =Message_"为手术申请单"
	i ((ReqType=3)||(ReqLevel=1)) d
	.s Rtn = ##class(web.CSSDHUI.Common.Message).Send(Message,ActionTypeCode,ApplyUserDr,"","","",OtherInfoJson,SupplyLocDr,"",ApplyLocDr)
	q Rtn
}

/// Description: Lodop打印xml条码模板调用
/// Creator:	lxt
/// CreateDate:	2021-2-26
/// w ##class(web.CSSDHUI.Common.UtilCommon).EncryptInput()
ClassMethod EncryptInput() As %String
{
	s str="<input id='InvPrintEncrypt' name='InvPrintEncrypt' type='hidden' value='"_..Encrypt()_"'>"
	s str=$tr(str,$C(13,10))
	q str
}

/// Creator:	ban
/// CreatDate:	2021-02-26
/// Description:8.3 8.4等打印条码调用的xml模板方法调整（模板外多包装一层）
/// Table:		
/// Input:		
/// Output: 
/// Return:		
/// w ##class(web.CSSDHUI.Common.UtilCommon).Encrypt()
ClassMethod Encrypt() As %String
{
	s Version = ..sssHISVersion()
	q:Version<8.4 ..sssWrap("%CSP.Page","Encrypt",$lb("web.DHCXMLIO.ReadXML"))
	q:Version>=8.4 ..sssWrap("websys.Page","Encrypt",$lb("web.DHCXMLIO.ReadXML"))
}

/// 加密
/// w ##class(web.CSSDHUI.Common.UtilCommon).EncryptPW("ab^#%123")
ClassMethod EncryptPW(Password) As %String
{
	n (Password)
	q ##Class(web.Util.Encryption).SimpleEncrypt(Password,"CSSDHUI")
}

/// 解密
/// w ##class(web.CSSDHUI.Common.UtilCommon).DecryptPW("757A707972AFC4EEA1D3F268ABF7E6")
ClassMethod DecryptPW(Password As %String)
{
	n (Password)
	q ##Class(web.Util.Encryption).SimpleDecrypt(Password,"CSSDHUI")
}

/// Descript:	获取打印模式
/// Creator:	zx
/// CreateDate:	2022-04-22
/// Input:		LocId:科室rowid
/// Output:		打印模式
/// w ##class(web.CSSDHUI.Common.UtilCommon).GetModByLoc(144)
ClassMethod GetModByLoc(LocId As %String) As %String
{
	n (LocId)
	s PtMod=""
	q:LocId="" ""
	
	s LhRId=$o(^CF.STER.CSSD.HospPrintRulesI("IndexCSSDLHPLoc",LocId,0))
	s:LhRId'="" PtMod=$lg(^CF.STER.CSSD.HospPrintRulesD(LhRId),4)
	q:PtMod'="" PtMod
	s HospId=$P(^CTLOC(LocId),"^",22)
	s LhRId=""
	s:HospId'="" LhRId=$o(^CF.STER.CSSD.HospPrintRulesI("IndexCSSDLHP",HospId,0))
	.s Loc=$lg(^CF.STER.CSSD.HospPrintRulesD(LhRId),2) ;取科室
	.q:Loc'=LocId
	.s:((LhRId'="")&(Loc="")) PtMod=$lg(^CF.STER.CSSD.HospPrintRulesD(LhRId),4)
	q PtMod
}

}
