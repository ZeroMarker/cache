/// CreateDate: 2019-01-26
/// Descript: 	临床知识库工具类
Class web.DHCCKBCommonUtil Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	计数器
/// W ##class(web.DHCCKBCommonUtil).NewPid()
ClassMethod NewPid() As %String
{
	//Q $I(^DHCCKB("ComUtil"))
	Q $I(^CKB.PDSS("ComUtil"))
}

/// Creator:qunianpeng
/// Description:全角转半角后并返回字符串的首拼
/// Input：  HANZI:汉字
/// Output：返回字符串的首拼
/// CreatDate:2016-4-18
/// ^DHCCharacterEncoding(6814)="65360^ｐ^^P^PPPP^PPPP^^^"
/// w ##class(web.DHCCKBCommonUtil).GetPYCODE("东华1259te") --->DH1259TE
/// w ##class(web.DHCCKBCommonUtil).GetPYCODE("氨苄西林钠")
ClassMethod GetPYCODE(HANZIS As %String = "") As %String
{
    n (HANZIS)
    s Rtnstr=""
    q:$g(HANZIS)="" Rtnstr
    s Rtnstr=##class(web.DHCCKBCommonUtil).GetCNCODE(HANZIS,4,"")
    q Rtnstr
}

/// Creator:qunianeng
/// Description:全角转半角,返回转换后汉字的编码信息
/// Input：  HANZI:汉字
///             FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码,6:五笔码,7:区位码,8:笔划数,9:郑码)
///             SPLIT:分割符(可以为空)
/// Output：
///     非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
///     0：未找到编码信息
/// CreatDate:2016-4-7
/// w ##class(web.DHCCKBCommonUtil).GetCNCODE("东华1259te",4,"") --->DH1259TE
/// w ##class(web.DHCCKBCommonUtil).GetCNCODE("东华",4,"")
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
    n (HANZIS,FLAG,SPLIT)
    s Rtnstr=""
    q:$g(HANZIS)="" Rtnstr
    s HANZIS=$zcvt(HANZIS,"U")
    f i=1:1:$l(HANZIS) d
    .s HANZI=$EXTRACT(HANZIS,i)
    .s ASCIICODE=$ASCII(HANZI)
    .;to DBC  全角转半角
    .i ASCIICODE=12288 s HANZI=$c(32)
    .i (ASCIICODE<65375)&(ASCIICODE>65280) s HANZI=$c(ASCIICODE-65248)
    
    .i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
    ..s Encodingrowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
    ..s tmpstr=""
    ..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(Encodingrowid))
    ..s:FLAG'="" tmpstr=$p($g(^DHCCharacterEncoding(Encodingrowid)),"^",FLAG)
    ..i Rtnstr=""  d
    ...s Rtnstr=tmpstr
    ..e  d
    ...s Rtnstr=Rtnstr_SPLIT_tmpstr
    .e  d
    ..if (ASCIICODE=32) d    ;  $ASCII(" ")=32
    ...s tmpstr=" "
    ...i Rtnstr=""  d
    ....s Rtnstr=tmpstr
    ...e  d
    ....s Rtnstr=Rtnstr_SPLIT_tmpstr
    ..else  d
    ...if (Rtnstr="") d
    ....s Rtnstr=HANZI  ///?
    ...else  d
    ....s Rtnstr=Rtnstr_SPLIT_HANZI  ///?
    q Rtnstr
}

/// Creator:  qunianpeng
/// Description:全角转半角后并返回字符串的拼音
/// Input：  HANZI:汉字
/// Output：返回字符串的拼音
/// CreatDate:2016-4-18
/// ^DHCCharacterEncoding(6814)="65360^ｐ^^P^PPPP^PPPP^^^"
/// w ##class(web.DHCCKBCommonUtil).GetFullPYCODE("东华1259te") --->DH1259TE
/// w ##class(web.DHCCKBCommonUtil).GetFullPYCODE("氨苄西林钠")
ClassMethod GetFullPYCODE(HANZIS As %String = "") As %String
{
    n (HANZIS)
    s Rtnstr=""
    q:$g(HANZIS)="" Rtnstr
    s Rtnstr=##class(web.DHCCKBCommonUtil).GetCNCODE(HANZIS,3,"")
    q Rtnstr
}

/// d ##class(web.DHCCKBCommonUtil).R(0,1)
/// Creator：      zhouxin
/// CreatDate：    2019-03-01
/// Description:   通用后台返回前台操作结果
/// Input:         代码，消息
/// Return：       {code:0,msg:msg}
ClassMethod R(code, msg) As %String
{
	n (code, msg)
	w ##class(web.DHCEMJsonCommon).getJsonData("code^msg",code_"^"_msg)
	q ""
}

/// d ##class(web.DHCCKBCommonUtil).GetStartRow()
/// Creator：      zhouxin
/// CreatDate：    2019-03-09
/// Description:   返回起始行数
ClassMethod GetStartRow() As %String
{
	s page=+$g(%request.Data("page",1))
	s rows=+$g(%request.Data("rows",1))
	q:page=0 1
	q (page-1)*rows+1
}

/// d ##class(web.DHCCKBCommonUtil).GetEndRow()
/// Creator：      zhouxin
/// CreatDate：    2019-03-09
/// Description:   返回结束行数
ClassMethod GetEndRow() As %String
{
	s page=+$g(%request.Data("page",1))
	s rows=+$g(%request.Data("rows",1))
	q:page=0 9999
	q page*rows
}

/// d ##class(web.DHCCKBCommonUtil).CheckCurRow()
/// Creator：      zhouxin
/// CreatDate：    2019-06-21
/// Description:   判断当前行是否输出
ClassMethod CheckCurRow(count) As %String
{
	n (%request,count)
	s start=##class(web.DHCCKBCommonUtil).GetStartRow()
	s end=##class(web.DHCCKBCommonUtil).GetEndRow()
	q:(count>=start)&&(count<=end) 1
	q 0
}

/// ##class(web.DHCCKBCommonUtil).Upper()
ClassMethod Upper(input) As %String
{
	n (input)
	q $ZCVT(input,"U")
}

/// Creator：      qunianpeng
/// CreatDate：    2019-07-16
/// Description:   替换字符串中特殊字符(包含、,。空格)
/// w ##class(web.DHCCKBCommonUtil).ReplaceStr("test成分1、test成分2") &&
ClassMethod ReplaceStr(str, code) As %String
{
	n (str,code)
	s str = ##Class(ext.util.String).Replace(str,$c(12289),code) // 中文顿号分割  "、"的ascii替换12289
	s str = ##Class(ext.util.String).Replace(str,"、", code)	// 中文顿号分割
	s str = ##Class(ext.util.String).Replace(str,"，", code)	// 中文逗号分割
	s str = ##Class(ext.util.String).Replace(str,"。","")		// 中文句号分割
	s str = ##Class(ext.util.String).Replace(str,$c(13,10), code)	// 
	s str = ##Class(ext.util.String).Replace(str,",", code)		// 英文逗号分割
	//s str = ##Class(ext.util.String).Replace(str,".", code)		// 英文句号分割
	
	q str
}

/// Creator：      qunianpeng
/// CreatDate：    2019-07-16
/// Description:   替换字符 统一间隔符
/// w ##class(web.DHCCKBCommonUtil).ReplaceSpaceStr("a、b,c，d。e.r")_
ClassMethod ReplaceSpaceStr(str, code) As %String
{
	n (str,code)

	s str=##Class(ext.util.String).Replace(str,"~",code)	//间隔符统一用 "_" 下划线
	s str=##Class(ext.util.String).Replace(str,"～",code)
	s str=##Class(ext.util.String).Replace(str,"-",code)
	s str=##Class(ext.util.String).Replace(str,"—",code)
	s str=##Class(ext.util.String).Replace(str,"－",code)	// 输入法问题
	
	q str
}

/// Creator：      qunianpeng
/// CreatDate：    2019-07-16
/// Description:   替换字符 统一比值符号
/// w ##class(web.DHCCKBCommonUtil).ReplaceSignStr("a、b,c，d。e.r≥")
ClassMethod ReplaceSignStr(str) As %String
{
	n (str)
	
	// 统一比值符号	[> < = >= <= !=]
	s str=##Class(ext.util.String).Replace(str,"≥",">=")
	s str=##Class(ext.util.String).Replace(str,"≤","<=")
	s str=##Class(ext.util.String).Replace(str,"》",">")
	s str=##Class(ext.util.String).Replace(str,"《","<")
	s str=##Class(ext.util.String).Replace(str,"＜","<")	// 不同输入法的符号
	s str=##Class(ext.util.String).Replace(str,"＞",">")
	s str=##Class(ext.util.String).Replace(str,"＝","=")
	s str=##Class(ext.util.String).Replace(str,"≠","'=")
	q str
}

/// Creator：      qunianpeng
/// CreatDate：    2019-07-16
/// Description:   替换字符 去掉字符中的空格、回车、换行号
/// w ##class(web.DHCCKBCommonUtil).ReplaceWordStr("a、b,c，d。e.r")
ClassMethod ReplaceWordStr(str) As %String
{
	n (str)
	
	s str=##Class(ext.util.String).Replace(str," ","")
	s str=##Class(ext.util.String).Replace(str,$c(10),"")
	s str=##Class(ext.util.String).Replace(str,$c(13),"")
	s str=##Class(ext.util.String).Replace(str,"、","")
	s str=##Class(ext.util.String).Replace(str,",","")
	s str=##Class(ext.util.String).Replace(str,"。","")
	
	q str
}

/// Creator：      qunianpeng
/// CreatDate：    2019-11-2
/// Description:   获取字符串中的连续数字，含小数点，百分号
/// //未考虑千分号‰，万分号‱  ce5.0mg 5.05mg 5mg 5  5.0   0.5mg 0.05mg  0.50mg  0.5 0.05   0.5次 l片/次
/// w ##class(web.DHCCKBCommonUtil).GetNum("1:10000g")
ClassMethod GetNum(val)
{
	n (val)
	
	q:'($Number(val,,0)="") val	// val是纯数字时，原样返回
	
	// 获取字符字符串中的数字,并保留数字的格式
	s len=$length(val)
	s flag=0,mark="",start=0	

	f i=1:1:len  q:flag=1  d 
	.s word=$Extract(val,i,i)
	.q:($ascii(word)<48)||($ascii(word)>57)		//// 找到第一个数字字符  数字和小数点
	.s flag=1
	.s start=i	 // 记录位置

	q:start=0 ""	
	
	s flag=0,end=0,count=0,mark=0
	f k=start:1:len  q:flag=1  d
	.s word=$Extract(val,k,k)
	.i $ascii(word)=46  d		// 小数点
	..s count=count+1
	..i count=2  s end=k-1,flag=1
	.q:count>1
	.i $ascii(word)=37  d		// %百分号
	..s mark=mark+1
	..i mark=2  s end=k-1,flag=1
	.q:mark>1
	.q:$ascii(word)=46			// 小数点
	.q:$ascii(word)=37			// %百分号
	.q:'(($ascii(word)<48)||($ascii(word)>57))
	.s end=k-1,flag=1
	
	q:end=0 $Extract(val,start,len)
	
	q $Extract(val,start,end)	
	
	q ""
}

/// Creator：      qunianpeng
/// CreatDate：    2019-11-20
/// Description:   常见单位系数转换
/// w ##class(web.DHCCKBCommonUtil).GetUomFactor("g","mg")
ClassMethod GetUomChangeFac(frUom, toUom)
{
	n (frUom, toUom)
	
	s frUom=$zcvt(frUom,"L")
	s toUom=$zcvt(toUom,"L")
	q:(frUom="")||(toUom="") ""
	
	// 体积单位	
	s TMPUnitArr("l","ml")=1000
	s TMPUnitArr("ml","l")=1/1000
	s TMPUnitArr("l","升")=1
	s TMPUnitArr("升","l")=1
	s TMPUnitArr("ml","毫升")=1
	s TMPUnitArr("毫升","ml")=1	
	s TMPUnitArr("升","毫升")=1000
	s TMPUnitArr("毫升","升")=1/1000	
	
	// 质量单位
	s TMPUnitArr("kg","g")=1000
	s TMPUnitArr("g","kg")=1/1000
	s TMPUnitArr("kg","千克")=1
	s TMPUnitArr("千克","kg")=1	
	s TMPUnitArr("千克","克")=1000
	s TMPUnitArr("克","千克")=1/1000
	s TMPUnitArr("g","mg")=1000
	s TMPUnitArr("mg","g")=1/1000	
	s TMPUnitArr("克","毫克")=1000
	s TMPUnitArr("毫克","克")=1/1000
	s TMPUnitArr("克","g")=1000
	s TMPUnitArr("g","克")=1000
	s TMPUnitArr("毫克","mg")=1
	s TMPUnitArr("mg","毫克")=1
	
	// 时间单位	
	s TMPUnitArr("年","岁")=1
	s TMPUnitArr("年","月")=12
	s TMPUnitArr("年","周")=48
	s TMPUnitArr("年","日")=365
	s TMPUnitArr("年","天")=365
	
	s TMPUnitArr("岁","年")=1
	s TMPUnitArr("岁","月")=12
	s TMPUnitArr("岁","周")=48
	s TMPUnitArr("岁","日")=365
	s TMPUnitArr("岁","天")=365
	
	s TMPUnitArr("月","年")=1/12
	s TMPUnitArr("月","岁")=1/12
	s TMPUnitArr("月","周")=4
	s TMPUnitArr("月","日")=30
	s TMPUnitArr("月","天")=30
	
	s TMPUnitArr("周","年")=1/48
	s TMPUnitArr("周","岁")=1/48
	s TMPUnitArr("周","月")=1/4
	s TMPUnitArr("周","日")=7
	s TMPUnitArr("周","天")=7
	
	s TMPUnitArr("日","年")=1/365
	s TMPUnitArr("日","岁")=1/365
	s TMPUnitArr("日","月")=1/30
	s TMPUnitArr("日","周")=1/7
	s TMPUnitArr("日","天")=1
	
	s TMPUnitArr("天","年")=1/365
	s TMPUnitArr("天","岁")=1/365
	s TMPUnitArr("天","月")=1/30
	s TMPUnitArr("天","周")=1/7
	s TMPUnitArr("天","日")=1
	
	// 包装单位
	//1揿/喷/吸 1瓶/支③1粒/丸④1袋/包
	s TMPUnitArr("揿","喷")=1
	s TMPUnitArr("揿","吸")=1
	s TMPUnitArr("喷","揿")=1
	s TMPUnitArr("喷","吸")=1
	s TMPUnitArr("吸","揿")=1
	s TMPUnitArr("吸","喷")=1
	
	s TMPUnitArr("瓶","支")=1
	s TMPUnitArr("支","瓶")=1
	
	s TMPUnitArr("粒","丸")=1
	s TMPUnitArr("丸","粒")=1
	
	s TMPUnitArr("袋","包")=1
	s TMPUnitArr("包","袋")=1
	q $g(TMPUnitArr(frUom,toUom))
}

/// Creator：      qunianpeng
/// CreatDate：    2019-11-20
/// Description:   常见单位系数转换
/// w ##class(web.DHCCKBCommonUtil).GetUomChangeFacNew("g","mg")
ClassMethod GetUomChangeFacNew(frUom, toUom)
{
	n (frUom, toUom)
	q:(frUom="")||(toUom="") ""
	
	s unitDataID=##class(web.DHCCKBCommon).GetUnitData()
	s ofrUom=frUom,otoUom=toUom
	s frUom=##class(web.DHCCKBCommon).GetDicIdByDesc(frUom,unitDataID)
	s toUom=##class(web.DHCCKBCommon).GetDicIdByDesc(toUom,unitDataID)
	q:(+frUom=0)||(+toUom=0) ""
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",frUom))&('$d(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",toUom))) ""
	s uomList=$LB(frUom,toUom)
	
	s unitChangeFac=##class(web.DHCCKBCommon).GetUnitChangeFacProp()	// 单位转换系数属性
	s linkProp=##class(web.DHCCKBCommon).GetLinkProp()					// 属性关联
	s linkAttr=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",unitChangeFac,linkProp,""))	// 单位转换系数关联的属性
	s toUomProp=##class(web.DHCCKBCommon).GetToUnitProp()
	s facProp=##class(web.DHCCKBCommon).GetFactorUnitProp()
	
	q:linkAttr="" ""	
	s unitChangeTemp=linkAttr		// 单位转换模板
	k tmpUnitArr
	s childProp=""
	f  s childProp=$o(^CT.CKB.PDSS.CommonDictionI("Parref",unitChangeTemp,childProp))  q:childProp=""  d
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",frUom,childProp))&('$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",toUom,childProp)))
	.f i=1:1:$ListLength(uomList)  d
	..s uom=$list(uomList,i)
	..q:+uom=0
	..s attrId=""
	..f  s attrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",uom,childProp,attrId))  q:attrId=""   d
	...s group=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),6)
	...i childProp=toUomProp s $p(tmpUnitArr(uom,group),"^",1)=$case(attrId'="",1:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4),:"")
	...i childProp=facProp s $p(tmpUnitArr(uom,group),"^",2)=$case(attrId'="",1:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),5),:"")

	k unitArr
	s index=""
	f   s index=$o(tmpUnitArr(index))  q:index=""  d
	.s group=""
	.f  s group=$o(tmpUnitArr(index,group)) q:group=""  d
	..s num=$p($g(tmpUnitArr(index,group)),"^",2)
	..s getUom=$p($g(tmpUnitArr(index,group)),"^",1)	// 转换到的单位
	..q:getUom=""
	..s unitArr(index,getUom)=$case(+num=0,1:1,:+num)
	..s unitArr(getUom,index)=$case(+num=0,1:1,:(1/num))
	..
	..//判断转换到的单位的别名
	..s getUomExt=##class(web.DHCCKBCommon).GetDicSecondName(getUom)
	..i $lf(getUomExt,ofrUom)>0 d
	...s unitArr(index,ofrUom)=$case(+num=0,1:1,:+num)
	...s unitArr(ofrUom,index)=$case(+num=0,1:1,:(1/num))
	
	i $g(unitArr(frUom,toUom))'="" s fac=$g(unitArr(frUom,toUom))				
	e  s fac=$g(unitArr(ofrUom,toUom))	
		
	k tmpUnitArr,unitArr

	q fac
}

/// Creator：      qunianpeng
/// CreatDate：    2020-3-5
/// Description:   药品的等效数量
/// Input:			药品id,药品单位,转换单位
/// w ##class(web.DHCCKBCommonUtil).GetEqFactor(95471,"g","ml")
ClassMethod GetEqFactor(drugId, frUom, toUom)
{
	
	n (drugId,frUom, toUom)
	q:(drugId="")||(frUom="")||(toUom="") ""
	
	s unitDataID=##class(web.DHCCKBCommon).GetUnitData()
	s ofrUom=frUom,otoUom=toUom
	s frUom=##class(web.DHCCKBCommon).GetDicIdByDesc(frUom,unitDataID)
	s toUom=##class(web.DHCCKBCommon).GetDicIdByDesc(toUom,unitDataID)
	q:(+frUom=0)||(+toUom=0) ""
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",frUom))&('$d(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",toUom))) ""
	s uomList=$LB(frUom,toUom)
	
	s eqUnitProp=##class(web.DHCCKBCommon).GetEqUnitProp()	// 等效单位属性
	s linkProp=##class(web.DHCCKBCommon).GetLinkProp()			// 属性关联
	s linkAttr=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",eqUnitProp,linkProp,""))	// 单位转换系数关联的属性（模板）
	s frUomProp=##class(web.DHCCKBCommon).GetEqFromUnitProp()
	s toUomProp=##class(web.DHCCKBCommon).GetEqToUnitProp()
	s facProp=##class(web.DHCCKBCommon).GetEqFactorProp()
	
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,frUomProp))||('$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,toUomProp))) ""

	
	q:linkAttr="" ""	
	s unitChangeTemp=linkAttr		// 单位转换模板
	k tmpUnitArr
	s childProp=""
	f  s childProp=$o(^CT.CKB.PDSS.CommonDictionI("Parref",unitChangeTemp,childProp))  q:childProp=""  d
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,childProp))
	.s attrId=""
	.f  s attrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,childProp,attrId))  q:attrId=""   d
	..s group=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),6)
	..i childProp=frUomProp s $p(tmpUnitArr(group),"^",1)=$case(attrId'="",1:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4),:"")
	..i childProp=toUomProp s $p(tmpUnitArr(group),"^",2)=$case(attrId'="",1:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4),:"")
	..i childProp=facProp s $p(tmpUnitArr(group),"^",3)=$case(attrId'="",1:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),5),:"")

	k unitArr
	s index=""
	f   s index=$o(tmpUnitArr(index))  q:index=""  d
	.s fUnit=$p(tmpUnitArr(index),"^",1)
	.s tUnit=$p(tmpUnitArr(index),"^",2)
	.s num=$p(tmpUnitArr(index),"^",3)
	.q:(fUnit="")||(tUnit="")
	.s unitArr(fUnit,tUnit)=$case(+num=0,1:"",:+num)
	.s unitArr(tUnit,fUnit)=$case(+num=0,1:"",:(1/num))

	s fac=$g(unitArr(frUom,toUom))	
	i fac="" s fac=..GetEqFactorByBasicUnit(.unitArr,frUom,toUom)	// 通过基本单位找到转换系数			
	k tmpUnitArr,unitArr

	q fac
}

/// Creator：      qunianpeng
/// CreatDate：    2020-3-5
/// Description:   比较两个集合是否有交集
/// Retrun:		   1有交集 0 没有交集
/// w ##Class(web.DHCCKBCommonUtil).CompareBothList($lb(1,2,3),"")	
ClassMethod CompareBothList(olist As %String, clist As %String) As %String
{
	n (olist,clist)
	// 如果不是list,转成list计算
	i $LISTVALID(olist)=0 s olist=$LISTFROMSTRING(olist)
	i $LISTVALID(clist)=0 s clist=$LISTFROMSTRING(clist)
	
	s ptr=0,ret=0
	while $LISTNEXT(olist,ptr,value){
		s ret=$LISTFIND(clist,value)
		q:ret>0
	}	
	q:ret>0 1
	q ret
}

/// Creator：      qunianpeng
/// CreatDate：    2020-3-5
/// Description:   比较两个集合的交集
/// Retrun:		   集合交集
/// w ##Class(web.DHCCKBCommonUtil).GetMixList()
ClassMethod GetMixList(olist As %String, clist As %String) As %String
{
	n (olist,clist)
	// 如果不是list,转成list计算
	i $LISTVALID(olist)=0 s olist=$LISTFROMSTRING(olist)
	i $LISTVALID(clist)=0 s clist=$LISTFROMSTRING(clist)
	
	s ptr=0,eqlist=""
	while $LISTNEXT(olist,ptr,value){
		s ret=$LISTFIND(clist,value)
		continue:value=""
		i ret'=0 d	
		.s $list(eqlist,*+1)=value
	}	
	
	q eqlist
}

/// Creator：      qunianpeng
/// CreatDate：    2020-3-5
/// Description:   获取两个集合的并集(并集)
/// Retrun:		   并集集合
/// w ##Class(web.DHCCKBCommonUtil).GetUnionList($lb(1,2,3),"")	
ClassMethod GetUnionList(olist As %String, clist As %String) As %String
{
	n (olist,clist)
	
	q:(olist="")&(clist="") ""
	q:(olist="")&(clist'="") clist
	q:(olist'="")&(clist="") olist
	// 如果不是list,转成list计算
	i $LISTVALID(olist)=0 s olist=$LISTFROMSTRING(olist)
	i $LISTVALID(clist)=0 s clist=$LISTFROMSTRING(clist)
	
	s ostr=$listtostring(olist,"@@")
	s cstr=$listtostring(clist,"@@")
	s tlist=$listfromstring(ostr_"@@"_cstr,"@@")

	s ptr=0,unionlist=""
	while $LISTNEXT(tlist,ptr,value){
		s ret=$LISTFIND(unionlist,value)
		continue:value=""
		i ret=0 d	
		.s $list(unionlist,$listlength(unionlist)+1)=value
	}	
	q unionlist
}

/// Creator：      qunianpeng
/// CreatDate：    2020-3-5
/// Description:   比较两个list的内容是否相同(元素个数相同，内容相同,顺序无关)
/// Retrun:		   1 相同  0 不相同
/// w ##Class(web.DHCCKBCommonUtil).CompareEqualList()
ClassMethod CompareEqualList(olist As %String, clist As %String) As %String
{
	n (olist,clist)
	// 如果不是list,转成list计算
	i $LISTVALID(olist)=0 s olist=$LISTFROMSTRING(olist)
	i $LISTVALID(clist)=0 s clist=$LISTFROMSTRING(clist)
	q:$listlength(olist)'=$listlength(clist) 0
	s ptr=0,ret=0,eqlist=""
	while $LISTNEXT(olist,ptr,value){
		s ret=$LISTFIND(clist,value)
		q:ret=0
		s $list(eqlist,*+1)=value
	}	
	
	i $listlength(eqlist)=$listlength(olist)  d
	.i $listsame(eqlist,olist)||$listsame(eqlist,clist) s ret=1
	
	q $case(ret>0,1:1,:0)
}

/// 获取单位转化系数
/// w ##class(web.DHCCKBCommonUtil).GetFactorToLib("mg","片","81646")
ClassMethod GetFactorToLib(hisUomDesc, libUomDesc, drugId = "")
{
	n (hisUomDesc,libUomDesc,drugId)
	
	//s:libUomDesc["/" libUomDesc=$p(libUomDesc,"/")
	s fac=""
	i drugId'=""  d		// 药品的取等效单位数量
	.s fac=##class(web.DHCCKBCommonUtil).GetEqFactor(drugId,hisUomDesc,libUomDesc)
	
	q:fac'="" fac		// 否则从单位中数量取
	s fac=##class(web.DHCCKBCommonUtil).GetUomChangeFac(hisUomDesc,libUomDesc)
	q:fac'="" fac	
	s fac=##class(web.DHCCKBCommonUtil).GetUomChangeFacNew(hisUomDesc,libUomDesc)
	q:fac'="" fac
	
	q fac
}

/// d ##class(web.DHCCKBCommonUtil).InitGlobalData()
ClassMethod InitGlobalData()
{
	s ^mdata("DHCCKBCD")=$o(^DHCCKBCD(""),-1)	//DHC_CKBCommonDiction
	s ^mdata("DHCCKBDLA")=$o(^DHCCKBDLA(""),-1)	//CT_CKB_PDSS.DicLinkAttr	
	s ^mdata("DHCCKBRULE")=$o(^DHCCKBRule(""),-1)	//DHCCKBRule
	s ^mdata("DHCCKBRD")=$o(^DHCCKBRD(""),-1)	//	DHCCKBRuleData
	s ^mdata("DHCCKBRULENODE")=$o(^DHCCKBRULENODE(""),-1)	//DHCCKBRuleNode
	s ^mdata("DHCCKBRULEDIC")=$o(^DHCCKBRULEDIC(""),-1)		//DHCCKBRULEDIC
	s ^mdata("DHCCKBRULEDATALOG")=$o(^DHCCKBRULEDATALOG(""),-1)	//DHCCKBRULEDATALOG
	s ^mdata("DHCCKBRULELOG")=$o(^DHCCKBRULELOG(""),-1)	//DHCCKBRuleNode
	s ^mdata("DHCCKBRULENODE")=$o(^DHCCKBRULENODE(""),-1)	//DHC_CKBRuleLog
	s ^mdata("DHCCKBCC")=$o(^DHCCKBCC(""),-1)	//User.DHCCKBComContrast	
	s ^mdata("DHCCKBDLG")=$o(^DHCCKBDLG(""),-1)	//User.DHCCKBDicLog
	s ^mdata("DHCCKBEXD")=$o(^DHCCKBEXD(""),-1)	//User.DHCCKBExtDiction
	s ^mdata("DHCCKBRULEACTION")=$o(^DHCCKBRULEACTION(""),-1)	//User.DHCCKBRuleAction
	s ^DHCCKBRULEDETAIL(0)=$o(^DHCCKBRULEDETAIL(""),-1)	//User.DHCCKBRuleDetail
	s ^DHCCKBRULEMAINTAIN(0)=$o(^DHCCKBRULEMAINTAIN(""),-1)	//User.DHCCKBRuleMaintain
	
	q "初始化成功"
}

/// Descript:js 获取登录信息
/// w ##Class(web.DHCPUECommon).getCtLocDesc()
ClassMethod getCtLocDesc() As %String
{
	n (%session)
	q:'$d(%session) ""
	q:+%session.Get("LOGON.CTLOCID")=0 ""
	w "<SCRIPT Language='JavaScript'> var LgCtLocDesc='"_$p(^CTLOC(%session.Get("LOGON.CTLOCID")),"^",2)_"';</SCRIPT>"
}

/// Desc:日期转为 M中的日期数字
/// Others:	w ##class(web.DHCCKBCommonUtil).DateHtmlToLogical("2017-03-03")	
ClassMethod DateHtmlToLogical(date As %String) As %String
{
	N (date)
	q:date=""""
	s DHCCKBCommonDate=""
	s DHCCKBCommonDate=##class(websys.Conversions).DateHtmlToLogical(date)
	q DHCCKBCommonDate
}

/// Desc:时间转为 M中的日期数字
/// Others:	w ##class(web.DHCCKBCommonUtil).TimeHtmlToLogical("15:30:00")	
ClassMethod TimeHtmlToLogical(time As %String) As %String
{
	N (time)
	q:time=""""
	s DHCCKBCommonTime=""
	s DHCCKBCommonTime=##class(websys.Conversions).TimeHtmlToLogical(time)
	q DHCCKBCommonTime
}

/// Description: 公共 (M中的日期数字 转为 日期)
/// Others:	w ##class(web.DHCCKBCommonUtil).DateLogicalToHtml("15:30:00")	
ClassMethod DateLogicalToHtml(date As %String) As %String
{
	N (date)
	q:date=""""
	s CommonDate=""
	s CommonDate=##class(websys.Conversions).DateLogicalToHtml(date) ;$zd(date,3) ;
	q CommonDate
}

/// Creator:		qunianpeng
/// CreatDate:		2020-03-23
/// Description:： 	字典数据进行医院授权
/// Input:
/// Other:	w ##class(web.DHCCKBCommonUtil).GetSessionInfo()
ClassMethod GetSessionInfo()
{

	n (%session)	
	q:'$d(%session) ""
		
	s OldLgHospID=$g(%session.Data("LOGON.HOSPID"))		// 医院
	s OldLgHospCode=$p($g(^CT("HOSP",+OldLgHospID)),"^",1)
	s OldLgHospDesc=##class(web.DHCCKBCommon).GetHospitalDesc(+OldLgHospID)	// 医院描述
	
	s OldLgCtLocID=$g(%session.Data("LOGON.CTLOCID"))		// 科室
	s OldLgCtLocCode=$p($g(^CTLOC(+OldLgCtLocID)),"^",1)
	s OldLgCtLocDesc=##class(web.DHCCKBCommon).GetCtLocDesc(OldLgCtLocID)	// 科室描述
	s OldLgUserID=$g(%session.Data("LOGON.USERID"))		// 用户
	s OldLgUserCode=$g(%session.Data("LOGON.USERCODE"))	// 用户code
	s OldLgUserDesc=$g(%session.Data("LOGON.USERNAME"))	// 用户名称
	s OldLgGroupID=$g(%session.Data("LOGON.GROUPID"))		// 安全组
	s OldLgGroupDesc=$g(%session.Data("LOGON.GROUPDESC"))	// 安全组描述
	s OldLgProfessID=##class(web.DHCCKBCommon).GetProfessID(OldLgUserID)
	s OldLgProfessCode=##class(web.DHCCKBCommon).GetProfessCode(OldLgUserID)
	s OldLgProfessDesc=##class(web.DHCCKBCommon).GetProfessDesc(OldLgUserID)	// 职称描述
	
	/*
	s LgHospID=##class(web.DHCCKBCommon).GetDicIdByCode(OldLgHospCode,##class(web.DHCCKBCommon).GetHospitalData())
	s LgHospDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+LgHospID)),3)
	s LgCtLocID=##class(web.DHCCKBCommon).GetDicIdByCode(OldLgCtLocCode,##class(web.DHCCKBCommon).GetLocData())
	s LgCtLocDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+LgCtLocID)),3)
	s LgUserID=##class(web.DHCCKBCommon).GetDicIdByCode(OldLgUserCode,##class(web.DHCCKBCommon).GetDocData()) // 用户
	s LgUserCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+LgUserID)),2)	// 用户code
	s LgUserDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+LgUserID)),3)	// 用户名称
	s LgGroupID=##class(web.DHCCKBCommon).GetDicIdByCode(OldLgGroupDesc,##class(web.DHCCKBCommon).GetGroupData()) // 安全组
	s LgGroupDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+LgGroupID)),3)	// 安全组描述
	s LgProfessID=##class(web.DHCCKBCommon).GetDicIdByCode(OldLgProfessCode,##class(web.DHCCKBCommon).GetCarePrvData())
	s LgProfessDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+LgProfessID)),3) // 职称描述
	*/
	
	set ClientIPAdd=""
	s ssuserLoginId = $G(%session.Data("LOGON.SSUSERLOGINID"))
	if ssuserLoginId>0 {
		Set ClientIPAdd = $p($g(^SST("LOG",ssuserLoginId,"ADDR")),"^",1)
	}
	If (ClientIPAdd="")||(ClientIPAdd="undefined") Set ClientIPAdd = %request.CgiEnvs("REMOTE_ADDR") ;$g(%request.Data("REMOTE_ADDR",1))
	Set ServerIPAdd = ##class(ext.util.String).ServerIP() ;$zu(54,0) ;##class(ext.util.String).ServerIP()
	/*
	s sessionInfo="<SCRIPT Language='JavaScript'>"
	s sessionInfo=sessionInfo_" var LgHospID='"_LgHospID_"';"_" var LgHospDesc='"_LgHospDesc_"';"
	s sessionInfo=sessionInfo_" var LgCtLocID='"_LgCtLocID_"';"_" var LgCtLocDesc='"_LgCtLocDesc_"';"
	s sessionInfo=sessionInfo_" var LgUserID='"_LgUserID_"';"_" var LgUserCode='"_LgUserCode_"';"_" var LgUserDesc='"_LgUserDesc_"';"
	s sessionInfo=sessionInfo_" var LgGroupID='"_LgGroupID_"';"_" var LgGroupDesc='"_LgGroupDesc_"';"
	s sessionInfo=sessionInfo_" var LgProfessID='"_LgProfessID_"';"_" var LgProfessDesc='"_LgProfessDesc_"';"
	s sessionInfo=sessionInfo_" var ClientIPAdd='"_ClientIPAdd_"';"_" var ServerIPAdd='"_ServerIPAdd_"';"
	s sessionInfo=sessionInfo_"</SCRIPT>"
	*/
	s LoginInfo=OldLgUserID_"^"_OldLgProfessID_"^"_OldLgCtLocID_"^"_OldLgGroupID_"^"_OldLgHospID
	s sessionInfo="<SCRIPT Language='JavaScript'>"
	s sessionInfo=sessionInfo_" var LgHospID='"_OldLgHospID_"';"_" var LgHospDesc='"_OldLgHospDesc_"';"
	s sessionInfo=sessionInfo_" var LgCtLocID='"_OldLgCtLocID_"';"_" var LgCtLocDesc='"_OldLgCtLocDesc_"';"
	s sessionInfo=sessionInfo_" var LgUserID='"_OldLgUserID_"';"_" var LgUserCode='"_OldLgUserCode_"';"_" var LgUserDesc='"_OldLgUserDesc_"';"
	s sessionInfo=sessionInfo_" var LgGroupID='"_OldLgGroupID_"';"_" var LgGroupDesc='"_OldLgGroupDesc_"';"
	s sessionInfo=sessionInfo_" var LgProfessID='"_OldLgProfessID_"';"_" var LgProfessDesc='"_OldLgProfessDesc_"';"
	s sessionInfo=sessionInfo_" var ClientIPAdd='"_ClientIPAdd_"';"_" var ServerIPAdd='"_ServerIPAdd_"';"
	s sessionInfo=sessionInfo_" var LoginInfo='"_LoginInfo_"';"
	s sessionInfo=sessionInfo_"</SCRIPT>"
	w sessionInfo
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2020-05-21
/// Description:： 	获取客户端ip
/// Input:
/// Other:	w ##class(web.DHCCKBCommonUtil).GetClientIp()
ClassMethod GetClientIp() As %String
{

	n (%session)	
	q:'$d(%session) ""	

	set ClientIPAdd=""
	s ssuserLoginId = $G(%session.Data("LOGON.SSUSERLOGINID"))
	if ssuserLoginId>0 {
		Set ClientIPAdd = $p($g(^SST("LOG",ssuserLoginId,"ADDR")),"^",1)
	}
	If (ClientIPAdd="")||(ClientIPAdd="undefined") Set ClientIPAdd = %request.CgiEnvs("REMOTE_ADDR") ;$g(%request.Data("REMOTE_ADDR",1))
	//Set ServerIPAdd = ##class(ext.util.String).ServerIP() ;$zu(54,0) ;##class(ext.util.String).ServerIP()

	q ClientIPAdd
}

/// Creator: 	sufan
/// CreateDate: 2020-07-16
/// Descript: 	查询医院列表
/// w ##class(web.DHCCKBCommonUtil).QueryHospList()
ClassMethod QueryHospList(q = "") As %String
{
  
	n (q)
  	s count=0
  	s HospId=0
  	w "["
  	for  s HospId=$o(^CT("HOSP",HospId) ) q:(HospId="")||(+HospId=0)  d
  	.s Code=$p(^CT("HOSP",HospId),"^",1)
  	.s Desc=$p(^CT("HOSP",HospId),"^",2)
  	.s QuitStr = Code_Desc
  	.Q:(q'="")&&(QuitStr'[q)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",HospId_"^"_Desc)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",HospId_"^"_Desc)
 	w "]"
	q ""
}

/// Creator: 	qunianpeng 
/// CreateDate: 2020-10-22
/// Descript: 	根据等效单位,获取转换系数
/// w ##class(web.DHCCKBCommonUtil).GetEqFactorByBasicUnit()
ClassMethod GetEqFactorByBasicUnit(unitArr, frUom, toUom) As %String
{
	n (unitArr,frUom,toUom)
	
	// 药品的单位的第一位是等效单位
	s fac = ""
	s basicUnit = ""
	f  s basicUnit=$o(unitArr(basicUnit))	q:(basicUnit="")||(fac'="")  d
	.q:'$d(unitArr(basicUnit,frUom))||('$d(unitArr(basicUnit,toUom)))
	.q:$g(unitArr(basicUnit,frUom))=""	
	.s fac = $g(unitArr(basicUnit,toUom))/$g(unitArr(basicUnit,frUom))
	
	q fac
	// 支 = 5*mg =10 ml
	// 支 = 10*ml
}

/// Creator: 	qunianpeng 
/// CreateDate: 2021-5-24
/// Descript: 	数组拼接
/// w ##class(web.DHCCKBCommonUtil).Concat()
ClassMethod Concat(leftArr, rightArr) As %String
{
	n (leftArr,rightArr)
	s lefttype = ..GetTypeOf(leftArr)
	s righttype = ..GetTypeOf(rightArr)
	
	q:(lefttype="array")&(righttype'="array") leftArr
	q:(lefttype'="array")&(righttype="array") rightArr
	q:(lefttype'="array")&(righttype'="array") []
	
	f i=0:1:rightArr.%Size()-1  d
	.d leftArr.%Push(rightArr.%Get(i))
		
	q leftArr
}

/// Creator: 	qunianpeng 
/// CreateDate: 2021-05-24
/// Descript: 	判断变量类型
/// w ##class(web.DHCCKBCommonUtil).GetTypeOf(##class(PHA.HERB.MOB.Rule).%New())
/// w ##class(web.DHCCKBCommonUtil).GetTypeOf([])
/// w ##class(web.DHCCKBCommonUtil).GetTypeOf({})
/// w ##class(web.DHCCKBCommonUtil).GetTypeOf("0")
/// w ##class(web.DHCCKBCommonUtil).GetTypeOf("1")
ClassMethod GetTypeOf(str As %String) As %String
{
	q [(str)].%GetTypeOf(0)
}

/// Creator: 	qunianpeng 
/// CreateDate: 2021-06-09
/// Descript: 	list转换为数组
/// w ##class(web.DHCCKBCommonUtil).ListToArr()
ClassMethod ListToArr(dataList, TmpArr) As %String
{
	n (dataList, TmpArr)
	
	f i=1:1:$listlength(dataList)  d
	.s value = $lg(dataList,i)
	.s TmpArr(value) = value
	
	q ""
}

/// Creator: 	yuliping
/// CreateDate: 2021-07-22
/// Descript: 	查询药品分类
/// w ##class(web.DHCCKBCommonUtil).QueryDrugType()
ClassMethod QueryDrugType(q = "") As %String
{
  
	n (q)
  	s count=0
  	s HospId=0
  	w "["
	w ##class(web.DHCEMJsonCommon).getJsonData("value^text",##class(web.DHCCKBCommon).GetDrug()_"^西药")
	w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",##class(web.DHCCKBCommon).GetChineseDrug()_"^中成药")
	w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",##class(web.DHCCKBCommon).GetChineseHerbalMedicine()_"^中药饮片")
 	w "]"
	q ""
}

/// Creator：      qunianpeng
/// CreatDate：    2021-9-13
/// Description:   比较两个集合是否有交集(使用模糊匹配)
/// Retrun:		   1有交集 0 没有交集
/// w ##Class(web.DHCCKBCommonUtil).CompareFuzzyBothList($lb(1,2,3),"")	
ClassMethod CompareFuzzyBothList(olist As %String, clist As %String) As %String
{
	n (olist,clist)
	// 如果不是list,转成list计算
	i $LISTVALID(olist)=0 s olist=$LISTFROMSTRING(olist)
	i $LISTVALID(clist)=0 s clist=$LISTFROMSTRING(clist)
	
	s ptr=0,ret=0
	while $LISTNEXT(olist,ptr,value){
		s clistPtr = 0
		while $LISTNEXT(clist,clistPtr,cValue){
			if (value[cValue){
				s ret = 1
			}
			q:ret=1
		}	
		q:ret=1		
	}	

	q ret
}

/// Creator：      xww
/// CreatDate：    2021-10-28
/// Description:   把疾病里的交集存在TmpArr中
/// Retrun:		   1有交集 0 没有交集
/// w ##Class(web.DHCCKBCommonUtil).CompareBothListToArr($lb(1,2,3),$lb(1,2),"")	
ClassMethod CompareBothListToArr(olist As %String, clist As %String, TmpArr) As %String
{
	n (olist,clist,TmpArr)
	s CheckDicID=TmpArr("CheckDicID")	// 审查项目(药品)	
	s RulID=TmpArr("RulID")				// 规则序号		
	// 如果不是list,转成list计算
	i $LISTVALID(olist)=0 s olist=$LISTFROMSTRING(olist)
	i $LISTVALID(clist)=0 s clist=$LISTFROMSTRING(clist)
	s matchData=$g(TmpArr("MatchDisease",CheckDicID,RulID))
	s ptr=0,ret=0
	while $LISTNEXT(olist,ptr,value){
		s clistPtr = 0
		while $LISTNEXT(clist,clistPtr,cValue){
			if (value[cValue){
				i $listfind(matchData,value)=0	s $list(matchData,*+1)=value
			}
		}		
	}	
	s TmpArr("MatchDisease",CheckDicID,RulID)=matchData
	q ""
}

/// Creator：      qunianpeng
/// CreatDate：    2022-03-28
/// Description:   设置必须审查的计算项目
/// Retrun:		   必须检查的计算项目
/// w ##Class(web.DHCCKBCommonUtil).MustCheckItemList()	
ClassMethod MustCheckItemList() As %String
{
	// 每日最大量、每日极量、单次最大量、单次极量
	s list = $lb("DayDoseMax","DayDoseLimit","OnceDoseMax","OnceDoseLimit")
		
	q list
}

/// Creator：      xww
/// CreatDate：    2022-09-02
/// Description:   替换符号，把中英文百分号和括号统一
/// Retrun:		   
/// zw ##Class(web.DHCCKBCommonUtil).ReplaceDrugSymbol($lb("5％葡萄糖注射液","葡萄糖类","溶媒类"))	
ClassMethod ReplaceDrugSymbol(list As %String) As %String
{
	n (list)		
	// 如果是list,转成String计算
	i $LISTVALID(list)'=0 s list = $LISTTOSTRING(list)
	s list = $replace(list,"％","%")
	s list = $replace(list,"（","(")   // 转换括号
	s list = $replace(list,"）",")")
	s list=$LISTFROMSTRING(list)
	q list
}

/// Descript:返回Json串起始符
/// W ##class(web.DHCCKBCommonUtil).getJsonTreeStartNew()
ClassMethod getJsonTreeStartNew(id, text, code, flag = "") As %String
{
	N (id, text, code ,flag)
	S del=""""
	q "{"_del_"id"_del_":"_del_id_del_","_del_"text"_del_":"_del_text_del_","_del_"code"_del_":"_del_code_del_","_del_"flag"_del_":"_del_flag_del
}

/// Description:： 字符串补零
/// Creator：      qunianpeng
/// CreatDate：    2022-08-18
/// Input:		   model: prev前补零,after后补零
/// 	               len:补零位数
/// 				   需要补零的字符串
/// w ##class(web.DHCCKBCommonUtil).AddZero()
ClassMethod AddZero(model, len, str)
{
	s strlen = $l(str)
	q:strlen>len str
	
	s cur = len - strlen
	
	s zero = ""
	f i=1:1:cur  d
	.s zero = zero_"0"
	
	s str = $select(model="prev":zero_str,model="after":str_zero,1:str)
	q str
}

}
