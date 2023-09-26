/// 功能说明：医保目录下载临时数据存储及审核业务的逻辑处理放到都放到这个类中
/// 修改履历：董科锋 2020 02 24 新做成
Class web.InsuTaritemsDLCtl Extends %RegisteredObject
{

/// 功能说明：比较下载的数据与医保目录中的数据是否相同  并更新比较结果到下载表
/// 入参说明：TarItemDLRowid  --> 医保目录 下载表Rowid
/// 		  TarItemRowid    --> 返回医保目录表Rowid
///           objTarItm       --> 医保目录下载对象
/// 返 回 值：差异标志 1：新增 2:更新 3:有效标识变化 0：无差异 99：未比较(默认)
///       w ##class(web.InsuTaritemsDLCtl).CompareTarItem("143396")
ClassMethod CompareTarItem(TarItemDLRowid As %String, ByRef TarItemRowid As %String, objTarItm As %String = "") As %String
{
	s $ZT="CompareEx"
	
	if $isobject(objTarItm)=0 {
		if (TarItemDLRowid'="") {
			s objTarItm=##class(User.InsuTaritemsDL).%OpenId(TarItemDLRowid)
		}
	}
	
	q:$isobject(objTarItm)=0 "-1"
	;s ^TMPINSU("CompareTarItem")=objTarItm.INTIMxmmc_"^"_objTarItm.INTIMsfxmbm_"^"_objTarItm.INTIMxmbm
	s RtnFlg="99"
	s flag="0"
	s (TmpTarItmActiveFlg,TarItmActiveFlg)=1
	
	//在医保目录表中查找是否存在相同的数据，并判断出当前数据的状态(A：新增 U:更新 E:失效 0：无差异) 比较主键(医保类型、项目编码)
	
	; test code start==================
	s InsuType=objTarItm.INTIMsfxmbm   ;医保类型
	s TarItmCode=objTarItm.INTIMxmbm   ;项目编码
	s INTIMRowid=0
	s INTIMRowid=$o(^DHCINTIM("0","ITYPECODE",InsuType,TarItmCode,INTIMRowid))
	s TarItemRowid=INTIMRowid			;返回医保目录表Rowid****
	;s ^TMPINSU("CompareTarItem1")=INTIMRowid
	if (INTIMRowid=""){
		s DifferenceCom="新增数据!"
		s RtnFlg="1"
	}else{
		s rtnstr=""
		s INSUTarItemsobj=##class(User.INSUTarItems).%OpenId(INTIMRowid)
		//判断数据是否有差异
		s sc="0"
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMxmmc", .rtnstr)     ;比较对应字段值，有无差异，0:无，1:有
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMActiveDate", .rtnstr)
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMExpiryDate", .rtnstr)
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMsfdlbm", .rtnstr)
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMtjdm", .rtnstr)
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMxmlb", .rtnstr)
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMjx", .rtnstr)
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMpzwh", .rtnstr)
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMbzjg", .rtnstr)
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMsjjg", .rtnstr)
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMzgxj", .rtnstr)
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMzfbl1", .rtnstr)
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMzfbl2", .rtnstr)
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMzfbl3", .rtnstr)
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMtxbz", .rtnstr)
		s:scTmp'="0" sc=scTmp
		s scTmp=..CompareTarItemField(objTarItm,INSUTarItemsobj,"INTIMbz", .rtnstr)
		s:scTmp'="0" sc=scTmp
		;s ^TMPINSU("CompareTarItem2")=rtnstr
		if (sc="0"){
			s DifferenceCom="无差异"
		    s RtnFlg="0"
			}
		if (sc="1"){
			s DifferenceCom=rtnstr
		    s RtnFlg="2"
			}
		if (RtnFlg="2"){
			//判断数据是否无效
			;s (TmpTarItmActiveFlg,TarItmActiveFlg)=0
			s (TmpActiveFlg,ActiveFlg)=0  //代替原来的活动标志
			s curdate=$p($h,",",1)
			//若临时数据的ActiveFlg为空或者为1，则继续判断当前日期是否处于生效日期和失效日期之间
			s TmpActiveFlg=objTarItm.ActiveFlg
			if ((TmpActiveFlg=1)||(TmpActiveFlg="")){
				s TmpTarItmActiveDate=objTarItm.INTIMActiveDate
				s TmpTarItmExpiryDate=objTarItm.INTIMExpiryDate
				if (curdate>=TmpTarItmActiveDate)&&(curdate<TmpTarItmExpiryDate) s TmpTarItmActiveFlg=1,TmpActiveFlg=1
				if (curdate>=TmpTarItmActiveDate)&&(TmpTarItmExpiryDate="") s TmpTarItmActiveFlg=1,TmpActiveFlg=1
			}
			//判断医保目录是否有效
			s TarItmActiveDate=INSUTarItemsobj.INTIMActiveDate
			s TarItmExpiryDate=INSUTarItemsobj.INTIMExpiryDate
			if (curdate>TarItmActiveDate)&&(curdate<TarItmExpiryDate) s TarItmActiveFlg=1,ActiveFlg=1
			if (curdate>TarItmActiveDate)&&(TarItmExpiryDate="") s TarItmActiveFlg=1,ActiveFlg=1
			//若医保目录数据有效且临时数据无效，则返回失效状态
			if (TmpTarItmActiveFlg'=TarItmActiveFlg){
				s RtnFlg="3"   ;状态有变化
				s DifferenceCom=DifferenceCom_"有效状态发生改变;"
			}
			/*
			if ((TmpTarItmActiveFlg=0)&&(TarItmActiveFlg=1)){
				;s DifferenceCom="当前数据为无效状态,原来为有效状态；"_DifferenceCom
				s RtnFlg="3"
			}elseif ((TmpTarItmActiveFlg=1)&&(TarItmActiveFlg=0)){
				;s DifferenceCom="当前数据为有效状态,原来为无效状态；"_DifferenceCom
				s RtnFlg="3"
			}
			*/		
		}  			
	}
	//保存 比较结果到 目录下载表
	s:RtnFlg="2" TmpTarItmActiveFlg=TmpActiveFlg ;有差异时去把活动标志更新为在RtnFlg更新的TmpActiveFlg add xubinbin 2020-3-24
	;s ObjTarItem=##class(User.InsuTaritemsDL).%OpenId(flag)   ;比较结果 保存
	s objTarItm.ActiveFlg=TmpTarItmActiveFlg    ;有效标志
	s objTarItm.INTIMflzb2=TmpTarItmActiveFlg   ;有效标志(医保目录表中在这个字段中保存了有效标志，所以这里也同步一下)
    s objTarItm.DifferenceCate=RtnFlg           ;比较结果类型
    s objTarItm.DifferenceCom=DifferenceCom     ;比较结果描述
    s objTarItm.TarItmesDr =INTIMRowid			;医保目录表ID
    s state=objTarItm.%Save()
    b ;stat				;*****比较过后不做验证，直接保存*************
    i $System.Status.IsError(state) d
	.s flag="-101"
	e  d
	.s flag=TarItemDLRowid
	q flag
	
	
CompareEx
   s $ZT=""
   q "-1^"_$ze
}

/// 比较医保目录下载的数据和医保目录数据某一字段是否相同
///   0:无差异   1：有差异   
ClassMethod CompareTarItemField(objTarItm As User.InsuTaritemsDL, INSUTarItemsobj As User.INSUTarItems, TarItemField As %String, ByRef diffstr As %String) As %String
{
	s ^TMPINSU("CompareTarItem")=objTarItm.INTIMxmmc
	s flag="0"
	;b ;CompareTarItem 1
	s TMPINTIMdata=$PROPERTY(objTarItm,TarItemField)
	s INTIMdata=$PROPERTY(INSUTarItemsobj,TarItemField)
	s ^TMPINSU(TarItemField)=TMPINTIMdata_"^"_INTIMdata_"^"_(TMPINTIMdata'=INTIMdata)
	if (TMPINTIMdata'=INTIMdata){
		if (TarItemField="INTIMActiveDate")||(TarItemField="INTIMExpiryDate"){
				s TMPINTIMdata=$zd(TMPINTIMdata,3)
				s INTIMdata=$zd(INTIMdata,3)
				}
		if (diffstr=""){
				s diffstr=TarItemField_"^"_TMPINTIMdata_"^"_INTIMdata_"|"	; 
				}
			else{
				s diffstr=diffstr_TarItemField_"^"_TMPINTIMdata_"^"_INTIMdata_"|"
				}
			s flag="1"
	}
	;s ^TMPINSU(TarItemField_"1")=diffstr
	s ^TMPINSU(TarItemField,"diffstr")=diffstr
	q flag
}

/// 功能说明：保存下载的目录到临时存储表中
/// 入参说明：InputPam   --> TarItmInfo医保目录信息 XML 字符串对应的解析对象为：web.InsuTaritemsDL
///                      
///           tDocument  --> 利用XPATH读取xml字符流读出的文档结构
/// 返 回 值：0：保存成功    小于0：保存失败 
/// 	w ##class(web.InsuTaritemsDLCtl).SaveDowloadTarItem("XMLString")        
ClassMethod SaveDowload(InputPam As %String) As %String
{
	//XPath形式解析  XML字符串
	;s tDocument=""
	;set tSC=##class(%XML.XPATH.Document).CreateFromString(InputPam,.tDocument)
	;s ObjTarItem=##class(INSU.ONPAY.COM.ReadXML).ReadFromXml(tDocument)

	//对象的形式解析  XML字符串
	s RtnFlg="-1",flag="-1"
	s reader=##class(%XML.Reader).%New()
	s ObjTarItem=##class(web.InsuTaritemsDL).%New()
	
	s sc=reader.OpenString(InputPam)
	d reader.Correlate("InsuReqest","web.InsuTaritemsDL")
	if reader.Next(.obj,.sc) {
		s ObjTarItem=obj
		s RtnFlg="0"
	}
	if RtnFlg="0" {
	q:$isobject(ObjTarItem)=0 "-1"
    s flag=$$InsertTaritem^InsuTaritemsDL(ObjTarItem)
	}
    q flag
}

/// 功能说明：保存下载的目录到临时存储表中
/// 入参说明：InputPam   --> 下载医保目录数据 XML字符串   对应的解析对象为：web.InsuTaritemsDL        
///           UpdTarItmFlg  --> 医保目录临时表与目录表 同步更新标志  0：不同步   1：同步
/// 		
/// 返 回 值：0：保存成功    小于0：保存失败 
/// 	w ##class(web.InsuTaritemsDLCtl).SaveDowloadTarItem("<InsuReqest>   <INTIMsfdlbm>11</INTIMsfdlbm>   <INTIMsfxmbm>FYB</INTIMsfxmbm>   <INTIMxmbm>86905764000269</INTIMxmbm>   <INTIMxmmc>羧甲司坦片</INTIMxmmc>   <INTIMxmrj>SJSTP</INTIMxmrj>   <INTIMtxbz />   <INTIMxmlb>01</INTIMxmlb>   <INTIMjx>片剂</INTIMjx>   <INTIMgg>0.25g</INTIMgg>   <INTIMdw />   <INTIMyf />   <INTIMyl />   <INTIMsl />   <INTIMpzwh />   <INTIMbzjg />   <INTIMsjjg />   <INTIMzgxj />   <INTIMzfbl1>0</INTIMzfbl1>   <INTIMzfbl2>0</INTIMzfbl2>   <INTIMzfbl3>0</INTIMzfbl3>   <INTIMbpxe />   <INTIMbz />   <INTIMtjdm>1</INTIMtjdm>   <INTIMflzb1 />   <INTIMflzb2>1</INTIMflzb2>   <INTIMflzb3>国药准字H46020743</INTIMflzb3>   <INTIMflzb4>0</INTIMflzb4>   <INTIMflzb5>0</INTIMflzb5>   <INTIMflzb6>0</INTIMflzb6>   <INTIMflzb7 />   <INTIMspmc />   <INTIMspmcrj />   <INTIMljzfbz />   <INTIMyyjzjbz>羧甲司坦片</INTIMyyjzjbz>   <INTIMyysmbm />   <INTIMfplb />   <INTIMDicType>ZZA</INTIMDicType>   <INTIMUserDR />   <INTIMDate />   <INTIMTime />   <INTIMADDIP />   <INTIMActiveDate>20151231000000</INTIMActiveDate>   <INTIM_Unique />   <INTIMExpiryDate /> </InsuReqest>")        
ClassMethod SaveDowloadTarItem(InputPam As %String, UpdTarItmFlg As %String = "0") As %String
{
	//XPath形式解析  XML字符串
	s $ZT="SaveEx"
	
	s diffStr=""
	s tDocument=""
	s TarItemID=""
	s diffFlag="",flag="-1"
	q:InputPam="" -1
	//01 验证
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputPam,.tDocument)
	s sc =..CheckStr(tDocument)		;重要字段验证
	q:sc'=0 -1
	
	//02 保存数据 (xml 转换成逻辑对象、逻辑对象再保存成 实体类对象，进行保存)
	s SaveID=..SaveDLTarItemByXml(InputPam)		
	
	//03 调用比较方法 更新差异字段  把保存操作放在比较方法中
	s TarItemID=""
    i SaveID>0  d
    .s flag=..CompareTarItem(SaveID,.TarItemID)  ;新下载数据与原数据比较
    .;s:flag<0  '记录日志


	//04 根据差异结果  同步(更新)医保目录表数据( TarItemID : 医保目录表Rowid)
	if ((UpdTarItmFlg="1")&&(SaveID>0)){
		s SaveID=..UpdateINSUItemsByINSUTempId(SaveID,TarItemID)   ;同步数据	
	}
    q +SaveID
    
SaveEx
   s $ZT=""
   q "-1^"_$ze
}

/// 下载医保目录数据验证
/// 字段：INTIMsfdlbm:收费大类代码  INTIMsfxmbm:医保类型  INTIMxmbm:项目编码 INTIMActiveDate:生效日期 DataVersion:下载数据批次
///  0 :正常    小于0  ：有问题
///  	 w ##class(web.InsuTaritemsDLCtl).CheckStr()
ClassMethod CheckStr(tDocument As %String, ExpStr As %String = "") As %String
{
	b ;check
	//配置的方式--获取验证字段
	s Flag="0"
	s Property=""
	s PropertyString= "INTIMsfdlbm"_"^"_"INTIMsfxmbm"_"^"_"INTIMxmbm"_"^"_"INTIMActiveDate"_"^"_"DataVersion"
	s cnt=$l(PropertyString,"^")
	f int=1:1:cnt  d
	.s Property=$p(PropertyString , "^",int)
	.s InsuStr="/InsuReqest/"_Property
	.s tSC=tDocument.EvaluateExpression(InsuStr,"text()",.tRes)  ;检索根节点/InsuReqest，是否有对应节点
	.If (($$$ISERR(tSC))||(tRes.GetAt(1)="")) s Flag="-"_int

	q Flag
}

/// 功能说明：将入参的XML字符流转换为“医保目录下载表对象”，保存到表中
/// 	返回值：  大于0：保存成功    小于0：保存失败
/// w ##class(web.InsuTaritemsDLCtl)SaveDLTarItemByXml()
ClassMethod SaveDLTarItemByXml(InputPam As %String, Userdr As %String = "1") As %String
{
	s flag="0"
	s Property=""
	s INTIMsfdlbm=""
	s reader=##class(%XML.Reader).%New()
	s ObjTarItem=##class(web.InsuTaritemsDL).%New()
	
	b ;XML Read
	//  XML字符串  以对象的形式解析
	s RtnFlg="-1"
	s sc=reader.OpenString(InputPam)
	d reader.Correlate("InsuReqest","web.InsuTaritemsDL")
	if reader.Next(.obj,.sc) {
		s ObjTarItem=obj
		s RtnFlg="0"
	}
	B ;OBJ
	if RtnFlg="-1" q "-1"
	q:$isobject(ObjTarItem)=0 "-1"
	
	b ;toobj
	//逻辑目录对象 转换为 医保目录下载表实体类对象，进行保存
	s ObjTarItemDL=ObjTarItem.ToPersistentObj()  
	b ;OBJT
	q:$isobject(ObjTarItemDL)=0 "-1"
	s sc=ObjTarItemDL.%Save()
	i $System.Status.IsError(sc) d
	.s flag="-100^"_$SYSTEM.Status.GetErrorText(sc)
	e  d
	.s flag=ObjTarItemDL.%Id()

	q flag
}

/// Creator: tangzf
/// CreateDate: 2020-03-04
/// Descript: 通过医保目录下载中间表更新医保目录表
/// Table : User.INSUTarItems.cls , User.InsuTaritemsTmp
/// Input:		INSUTempId : User.InsuTaritemsTmp.RowId
/// 				INSUTarItemId : User.INSUTarItems.RowId
/// Return: 0 表示 成功 非0表示失败 ;0_"^"_INSUTarContrasErrinfo=(失效数据更新医保目录成功，失效时更新医保目录对照表失败的数据)
/// DeBug:  w ##class(web.InsuTaritemsDLCtl).UpdateINSUItemsByINSUTempId("json")
ClassMethod UpdateINSUItemsByINSUTempId(INSUTempId, INSUTarItemId) As %String
{
	set INSUTempObj=##class(User.InsuTaritemsDL).%OpenId(INSUTempId)
	b ;Update
	quit:('$IsObject(INSUTempObj)) "-1"
	set UpdateConfig="" // 配置哪些字段更新 哪些字段不更新
	set INSUContrastErrInfo="" // 更新医保目录对照表失败的数据
	set INSUItemsObj=""
	b  ;Update2
	if INSUTempObj.DifferenceCate="1"  d //新增
	.d AddINSUItems(.INSUItemsObj)
	else  if INSUTempObj.DifferenceCate="2"  d // 更新
	.d UpdateINSUItems(.INSUItemsObj)
	else  if INSUTempObj.DifferenceCate="3"  d // 失效
	.d UpdateInvalid(.INSUItemsObj,.INSUContrastErrInfo)
	else  if INSUTempObj.DifferenceCate="0"  q 0_"^"_"无差异" // 无差异
	else  if INSUTempObj.DifferenceCate="99"  q 0_"^"_"未比较" // 未比较
	quit:('$IsObject(INSUItemsObj)) "-2"  
	
	set UserObj=##class(User.SSUser).%OpenId(INSUTempObj.INTIMUserDR)
	if $IsObject(UserObj) d
	.set INSUItemsObj.INTIMUserDr=UserObj
	set INSUTempObj="",UserObj=""

	set err=INSUItemsObj.%Save()
    if $$$ISERR(err){
		set rtn="-100^"_$SYSTEM.Status.GetErrorText(err)
	}else{
		set rtn=0_"^"_INSUContrastErrInfo
	}
	set INSUItemsObj=""
	quit rtn
AddINSUItems(INSUItemsObj)
	set INSUItemsObj=##class(User.INSUTarItems).%New()
	quit:('$IsObject(INSUItemsObj)) "-1"
	set tempObj=##class(%Dictionary.CompiledClass).%OpenId("User.INSUTarItems")
	for i=1:1:tempObj.Properties.Count() {
		set property=tempObj.Properties.GetAt(i)
		set name=property.Name
		continue:($e(name,1)="%")||(name="INTIMUserDr")
		set $ZOBJPROPERTY(INSUItemsObj,name)=$ZOBJPROPERTY(INSUTempObj,name)
	}

	quit
UpdateINSUItems(INSUItemsObj)
	set INSUItemsObj=##class(User.INSUTarItems).%OpenId(INSUTarItemId)
	set tempObj=##class(%Dictionary.CompiledClass).%OpenId("User.INSUTarItems")
	for i=1:1:tempObj.Properties.Count() {
		set property=tempObj.Properties.GetAt(i)
		set name=property.Name
		continue:($e(name,1)="%")||(name="INTIMUserDr")
		b:(name="INTIMtjdm") ;001d
		s UpdFlg=..GetUpdFieldFlg(INSUTempObj.INTIMsfxmbm, "User.InsuTaritemsDL", name)  ;是否更新本字段 +dongkf 2020 03 11
		;b ;002d
		continue:UpdFlg="0"   ;有些字段不能更新
		q:name=""
		set $ZOBJPROPERTY(INSUItemsObj,name)=$ZOBJPROPERTY(INSUTempObj,name)
	}	
	quit
	;set DifferenceCom=INSUTempObj.DifferenceCom
	;quit:('$IsObject(INSUItemsObj))
	;for i=1:1:$l(DifferenceCom,"|") {
	;	set Data=$p(DifferenceCom,"|",i)
	;	set Name=$p(Data,"^",1)
	;	set Value=$p(Data,"^",2)
	;	// continue:(UpdateConfig=DifferenceCom.Name) //配置做好以后填充此部分 
	;	q:Name="" 
	;	set $ZOBJPROPERTY(INSUItemsObj,Name)=Value   ;bb
	;}
UpdateInvalid(INSUItemsObj,INSUContrastErrInfo)
	set INSUItemsObj=##class(User.INSUTarItems).%OpenId(INSUTarItemId) 
	quit:('$IsObject(INSUItemsObj)) "-1"
	set tempObj=##class(%Dictionary.CompiledClass).%OpenId("User.INSUTarItems")
	for i=1:1:tempObj.Properties.Count() {
		set property=tempObj.Properties.GetAt(i)
		set name=property.Name
		continue:($e(name,1)="%")||(name="INTIMUserDr")
		s UpdFlg=..GetUpdFieldFlg(INSUTempObj.INTIMsfxmbm, "User.InsuTaritemsDL", name)  ;是否更新本字段 +dongkf 2020 03 11
		continue:UpdFlg="0"   ;有些字段不能更新
		set $ZOBJPROPERTY(INSUItemsObj,name)=$ZOBJPROPERTY(INSUTempObj,name)
	}	
	quit
	
	;// 更新目录表失效日期
	;set INSUItemsObj.INTIMExpiryDate=INSUTempObj.INTIMExpiryDate
	;// 更新对照表失效日期
	;set INSUTarContrastId=""
	;for  set INSUTarContrastId=$o(^DHCINTCT(0,"INSUTID",INSUItemsObj.%Id(),INSUTarContrastId)) quit:INSUTarContrastId=""  d
	;.set INSUContrastObj=##class(User.INSUTarContrast).%OpenId(INSUTarContrastId) 
	;.set INSUContrastObj.INTCTExpiryDate=INSUItemsObj.INTIMExpiryDate
	;.set err=INSUContrastObj.%Save()
	;.if $$$ISERR(err) d
	;..set ErrInfo=$SYSTEM.Status.GetErrorText(err)_"|"_INSUContrastObj.%Id()_"^"_INSUContrastErrInfo
	;.set INSUContrastObj=""
	;quit
}

/// 功能说明：判断当前字段是否更新
/// 入参说明：InsuType     --> 医保类型
///           TableClsName --> 下载表的定义类名称
///           ColProCode   --> 属性列名称
///           HospitalNo   --> 医院编码
/// 返 回 值：1 更新 0 不更新
/// 修改履历：董科锋 2020-03-11 新做成
ClassMethod GetUpdFieldFlg(InsuType As %String, TableClsName As %String, ColProCode As %String, HospitalNo As %String = "") As %String
{
	s UpdFlg="1"
	q:((InsuType="")||(TableClsName="")||(TableClsName="")) UpdFlg
	s rowid=""
	f  s rowid=$o(^User.InsuDLConfigI("IDataKey", InsuType, TableClsName, ColProCode, rowid)) q:rowid=""  d
	.s objDLConfig=##class(User.InsuDLConfig).%OpenId(rowid)
	.q:$isobject(objDLConfig)=0
	.s tmpHospitalNo=objDLConfig.HospitalCD  ;医院编码
	.q:(($g(tmpHospitalNo)'="")&&(HospitalNo'="")&&(tmpHospitalNo'=HospitalNo))
	.s NotUpateFlg=objDLConfig.NotUpateFlg   ;不更新标志 1 不更新 0 更新
	.s:NotUpateFlg="1" UpdFlg="0"
	q UpdFlg
}

/// ******************************************
/// *************************************************************************************
/// 功能说明: 对象转换
/// w ##class(web.InsuTaritemsDLCtl).SavetoObj()
ClassMethod SavetoObj(obj As web.InsuTaritemsDL) As web.InsuTaritemsDL
{
	s Property=""
    s ObjTarItemDL=##class(User.InsuTaritemsDL).%New()
	f  s Property=$o(^oddDEF("web.InsuTaritemsDL","a",Property)) q:Property=""  d
    .s $ZOBJPROPERTY(ObjTarItemDL,Property)=$ZOBJPROPERTY(obj,Property)
    
    B ;Read
	;循环获取目录字段赋值
	f  s Property=$o(^oddDEF("web.InsuTaritemsDL","a",Property)) q:Property=""  d
	.s Xpath="/InsuReqest/"_Property
	.s tSC=tDocument.EvaluateExpression(Xpath,"text()",.tRes)		;获取对应字段值
	.i ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")) d  
	..s fieldValue=tRes.GetAt(1).Value
	..s $ZOBJPROPERTY(ObjTarItem,Property)=$tr(fieldValue,$c(0),"")
          
    q ObjTarItemDL
}

/// 功能说明：医保目录导入
/// 编写者：  ZhaoZW
/// 入参说明：RowDataInfo  --> 导入模板的数据拼串
///           UserDr       --> 操作员Dr
///           ErrMsg       --> 错误信息(出参)
///           ExtStr       --> 备用字符串
/// s RowDataInfo="1^ZZB^XJ01DFA194B003^氨曲南^AQN^^药品^B003^^^^^^^^^8000^0.1^0.1^0^^限有药敏试验证据^2^^1^0^^^^0^氨曲南注射用无菌粉末^^^^^^^^^^^2019-10-23^^^^20200228213325^^^^^^^^"
/// s UserDr = 1
/// s ErrMsg=""
/// w ##class(web.InsuTaritemsDLCtl).ImportInsuTarItemByExcel(RowDataInfo,UserDr,.ErrMsg,"")
ClassMethod ImportInsuTarItemByExcel(RowDataInfo As %String, UserDr As %String, ByRef ErrMsg As %String, ExtStr As %String) As %String
{
	s RtnFlg="0"
	
	s DataVersion=$p(RowDataInfo, "^", 46)  ;数据批次
	s INTIMsfxmbm=$p(RowDataInfo, "^", 2)   ;医保类型
	s INTIMxmbm=$p(RowDataInfo, "^", 3)		;项目编码
	s:(DataVersion="")||(INTIMsfxmbm="")||(INTIMxmbm="") ErrMsg="数据批次、医保类型和项目编码都不能为空。"
	q:(DataVersion="")||(INTIMsfxmbm="")||(INTIMxmbm="") RtnFlg
	
	s RowId=$o(^User.InsuTaritemsDLI("IDataKey", DataVersion, INTIMsfxmbm, INTIMxmbm, ""))
	i RowId="" d
	.s objInsuTarItem=##class(User.InsuTaritemsDL).%New()
	e  d
	.s objInsuTarItem=##class(User.InsuTaritemsDL).%OpenId(RowId)
	
	s objInsuTarItem.INTIMsfdlbm=$p(RowDataInfo, "^", 1)		;收费大类代码
	s objInsuTarItem.INTIMsfxmbm=$p(RowDataInfo, "^", 2)		;医保类型
	s objInsuTarItem.INTIMxmbm=$p(RowDataInfo, "^", 3)			;项目编码
	s objInsuTarItem.INTIMxmmc=$p(RowDataInfo, "^", 4)			;项目名称
	s objInsuTarItem.INTIMxmrj=$p(RowDataInfo, "^", 5)			;项目热键（拼音码）
	s objInsuTarItem.INTIMtxbz=$p(RowDataInfo, "^", 6)			;特殊项标志
	s objInsuTarItem.INTIMxmlb=$p(RowDataInfo, "^", 7)			;项目类别
	s objInsuTarItem.INTIMjx=$p(RowDataInfo, "^", 8)			;剂型
	s objInsuTarItem.INTIMgg=$p(RowDataInfo, "^", 9)			;规格
	s objInsuTarItem.INTIMdw=$p(RowDataInfo, "^", 10)			;单位
	s objInsuTarItem.INTIMyf=$p(RowDataInfo, "^", 11)			;用法
	s objInsuTarItem.INTIMyl=$p(RowDataInfo, "^", 12)			;用量
	s objInsuTarItem.INTIMsl=$p(RowDataInfo, "^", 13)			;数量
	s objInsuTarItem.INTIMpzwh=$p(RowDataInfo, "^", 14)			;批准文号
	s objInsuTarItem.INTIMbzjg=$p(RowDataInfo, "^", 15)			;标准价格
	s objInsuTarItem.INTIMsjjg=$p(RowDataInfo, "^", 16)			;实际价格
	s objInsuTarItem.INTIMzgxj=$p(RowDataInfo, "^", 17)			;最高限价
	s objInsuTarItem.INTIMzfbl1=$p(RowDataInfo, "^", 18)		;自付比例1
	s objInsuTarItem.INTIMzfbl2=$p(RowDataInfo, "^", 19)		;自付比例2
	s objInsuTarItem.INTIMzfbl3=$p(RowDataInfo, "^", 20)		;自付比例3
	s objInsuTarItem.INTIMbpxe=$p(RowDataInfo, "^", 21)			;报批限额
	s objInsuTarItem.INTIMbz=$p(RowDataInfo, "^", 22)			;备注
	s objInsuTarItem.INTIMtjdm=$p(RowDataInfo, "^", 23)			;统计项目 
	s objInsuTarItem.INTIMflzb1=$p(RowDataInfo, "^", 24)		;分类指标1
	s objInsuTarItem.INTIMflzb2=$p(RowDataInfo, "^", 25)		;分类指标2
	s objInsuTarItem.INTIMflzb3=$p(RowDataInfo, "^", 26)		;分类指标3
	s objInsuTarItem.INTIMflzb4=$p(RowDataInfo, "^", 27)		;分类指标4
	s objInsuTarItem.INTIMflzb5=$p(RowDataInfo, "^", 28)		;分类指标5
	s objInsuTarItem.INTIMflzb6=$p(RowDataInfo, "^", 29)		;分类指标6
	s objInsuTarItem.INTIMflzb7=$p(RowDataInfo, "^", 30)		;分类指标7
	s objInsuTarItem.INTIMspmc=$p(RowDataInfo, "^", 31)			;商品名称
	s objInsuTarItem.INTIMspmcrj=$p(RowDataInfo, "^", 32)		;商品名称热键
	s objInsuTarItem.INTIMljzfbz=$p(RowDataInfo, "^", 33)		;累计增负标志
	s objInsuTarItem.INTIMyyjzjbz=$p(RowDataInfo, "^", 34)		;医院增加标志
	s objInsuTarItem.INTIMyysmbm=$p(RowDataInfo, "^", 35)		;医院三目编码
	s objInsuTarItem.INTIMfplb=$p(RowDataInfo, "^", 36)			;发票类别
	s objInsuTarItem.INTIMDicType=$p(RowDataInfo, "^", 37)		;目录类别
	i $p(RowDataInfo, "^", 38)'="" d 
	.s objInsuTarItem.INTIMUserDR=$p(RowDataInfo, "^", 38)		;添加人
	e  d
	.s objInsuTarItem.INTIMUserDR=UserDr
	
	i $p(RowDataInfo, "^", 39)'="" d
	.s INTIMDate=$p(RowDataInfo, "^", 39)
	.s INTIMDate=##class(websys.Conversions).DateHtmlToLogical(INTIMDate)	
	.s objInsuTarItem.INTIMDate=INTIMDate						;添加日期
	e  d
	.s objInsuTarItem.INTIMDate=$p($h, ",", 1)
	
	i $p(RowDataInfo, "^", 40)'="" d
	.s INTIMTime=$p(RowDataInfo, "^", 40)
	.s INTIMTime=##class(websys.Conversions).TimeHtmlToLogical(INTIMTime)
	.s objInsuTarItem.INTIMTime=INTIMTime						;添加时间
	e  d
	.s objInsuTarItem.INTIMTime=$p($h, ",", 2)
	
	s objInsuTarItem.INTIMADDIP=$p(RowDataInfo, "^", 41)		;修改机器
	
	s ActiveDate=$p(RowDataInfo, "^", 42)
	s:ActiveDate'="" ActiveDate=##class(websys.Conversions).DateHtmlToLogical(ActiveDate)
	s objInsuTarItem.INTIMActiveDate=ActiveDate					;生效日期
	
	s objInsuTarItem.INTIMUnique=$p(RowDataInfo, "^", 43)		;医保中心唯一码
	
	s ExpiryDate=$p(RowDataInfo, "^", 44)
	s:ExpiryDate'="" ExpiryDate=##class(websys.Conversions).DateHtmlToLogical(ExpiryDate)
	s objInsuTarItem.INTIMExpiryDate=ExpiryDate					;失效日期
	
	s objInsuTarItem.ActiveFlg=$p(RowDataInfo, "^", 45)			;有效标志
	s objInsuTarItem.DataVersion=$p(RowDataInfo, "^", 46)		;下载数据批次
	s objInsuTarItem.DifferenceCate=$p(RowDataInfo, "^", 47)	;差异分类
	s objInsuTarItem.DifferenceCom=$p(RowDataInfo, "^", 48)		;差异内容
	s objInsuTarItem.AuditImportFlag=$p(RowDataInfo, "^", 49)	;审核标记
	s objInsuTarItem.RefuseCommon=$p(RowDataInfo, "^", 50)		;拒绝原因
	s objInsuTarItem.AuiditUserCode=$p(RowDataInfo, "^", 51)	;审核人编码
	
	s objInsuTarItem.AuiditDate=$p(RowDataInfo, "^", 52)		;审核日期
	s objInsuTarItem.AuiditTime=$p(RowDataInfo, "^", 53)		;审核时间
	
	///保存数据
    s sc=objInsuTarItem.%Save()
    i $System.Status.IsError(sc) d
    .s RtnFlg="0"
    e  d
    .s RtnFlg=objInsuTarItem.%Id()
    
    q RtnFlg
}

/// Creator：      ZhaoZW
/// CreatDate：    2020-02-25
/// Description:   查询医保目录数据
/// Table：        被访问的表(User.InsuTaritemsDL)
/// Input：        DicType : 目录类型, DataVer : 数据批次, DiffCate : 差异标志, AuditFlag : 审核标志
/// Output：       
/// Debug: do ##class(%ResultSet).RunQuery("web.InsuTaritemsDLCtl","QueryInsuTaritemInfo","FYB","20200318155653","ALL","ALL")
Query QueryInsuTaritemInfo(DicType As %String, DataVer As %String, DiffCate As %String, AuditFlag As %String) As websys.Query(ROWSPEC = "ind,RowID,INTIMsfdlbm,INTIMsfxmbm,INTIMxmbm,INTIMxmmc,INTIMxmrj,INTIMtxbz,INTIMxmlb,INTIMjx,INTIMgg,INTIMdw,INTIMyf,INTIMyl,INTIMsl,INTIMpzwh,INTIMbzjg,INTIMsjjg,INTIMzgxj,INTIMzfbl1,INTIMzfbl2,INTIMzfbl3,INTIMbpxe,INTIMbz,INTIMtjdm,INTIMflzb1,INTIMflzb2,INTIMflzb3,INTIMflzb4,INTIMflzb5,INTIMflzb6,INTIMflzb7,INTIMspmc,INTIMspmcrj,INTIMljzfbz,INTIMyyjzjbz,INTIMyysmbm,INTIMfplb,INTIMDicType,INTIMUserDr,INTIMDate,INTIMTime,INTIMADDIP,INTIMActiveDate,INTIMUnique,INTIMExpiryDate,ActiveFlg,DataVersion,DifferenceCate,DifferenceCom,AuditImportFlag,RefuseCommon,AuiditUserCode,AuiditDate,AuiditTime")
{
}

ClassMethod QueryInsuTaritemInfoExecute(ByRef qHandle As %Binary, DicType As %String, DataVer As %String, DiffCate As %String, AuditFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    s ^TMPQueryInsuTaritemInfo=$lb(DicType,DataVer,DiffCate,AuditFlag)
    do ##class(web.InsuDlConfigCtl).getInsuTarItemDlAllDesc()
    s:DiffCate="ALL" DiffCate=""
    s:AuditFlag="ALL" AuditFlag=""
    s RowId=""
    f  s RowId=$o(^User.InsuTaritemsDLD(RowId)) q:RowId=""  d
    .s InsuTaritemInfo=$g(^User.InsuTaritemsDLD(RowId))
    
    .s INTIMsfdlbm=$lg(InsuTaritemInfo,2)			;收费大类代码
	.s INTIMsfxmbm=$lg(InsuTaritemInfo,3)			;医保类型
	.s InsuRowid=""
	.s:INTIMsfxmbm'="" InsuRowid=$o(^DHCINDID("0","ITypeCode","DLLType",INTIMsfxmbm,InsuRowid))
	.s:InsuRowid'="" INTIMsfxmbm=$p($g(^DHCINDID(InsuRowid)),"^",4)
	.s INTIMxmbm=$lg(InsuTaritemInfo,4)				;项目编码
	.s INTIMxmmc=$lg(InsuTaritemInfo,5)				;项目名称
	.s INTIMxmrj=$lg(InsuTaritemInfo,6)				;项目热键（拼音码）
	.s INTIMtxbz=$lg(InsuTaritemInfo,7)				;特殊项标志
	.s INTIMxmlb=$lg(InsuTaritemInfo,8)				;项目类别
	.s INTIMjx=$lg(InsuTaritemInfo,9)				;剂型
	.s INTIMgg=$lg(InsuTaritemInfo,10)				;规格
	.s INTIMdw=$lg(InsuTaritemInfo,11)				;单位
	.s INTIMyf=$lg(InsuTaritemInfo,12)				;用法
	.s INTIMyl=$lg(InsuTaritemInfo,13)				;用量
	.s INTIMsl=$lg(InsuTaritemInfo,14)				;数量
	.s INTIMpzwh=$lg(InsuTaritemInfo,15)			;批准文号
	.s INTIMbzjg=$lg(InsuTaritemInfo,16)			;标准价格
	.s INTIMsjjg=$lg(InsuTaritemInfo,17)			;实际价格
	.s INTIMzgxj=$lg(InsuTaritemInfo,18)			;最高限价
	.s INTIMzfbl1=$lg(InsuTaritemInfo,19)			;自付比例1
	.s INTIMzfbl2=$lg(InsuTaritemInfo,20)			;自付比例2
	.s INTIMzfbl3=$lg(InsuTaritemInfo,21)			;自付比例3
	.s INTIMbpxe=$lg(InsuTaritemInfo,22)			;报批限额
	.s INTIMbz=$lg(InsuTaritemInfo,23)				;备注
	.s INTIMtjdm=$lg(InsuTaritemInfo,24)			;统计项目 
	.s INTIMflzb1=$lg(InsuTaritemInfo,25)			;分类指标1
	.s INTIMflzb2=$lg(InsuTaritemInfo,26)			;分类指标2
	.s INTIMflzb3=$lg(InsuTaritemInfo,27)			;分类指标3
	.s INTIMflzb4=$lg(InsuTaritemInfo,28)			;分类指标4
	.s INTIMflzb5=$lg(InsuTaritemInfo,29)			;分类指标5
	.s INTIMflzb6=$lg(InsuTaritemInfo,30)			;分类指标6
	.s INTIMflzb7=$lg(InsuTaritemInfo,31)			;分类指标7
	.s INTIMspmc=$lg(InsuTaritemInfo,21)			;商品名称
	.s INTIMspmcrj=$lg(InsuTaritemInfo,33)			;商品名称热键
	.s INTIMljzfbz=$lg(InsuTaritemInfo,34)			;累计增负标志
	.s INTIMyyjzjbz=$lg(InsuTaritemInfo,35)			;医院增加标志
	.s INTIMyysmbm=$lg(InsuTaritemInfo,36)			;医院三目编码
	.s INTIMfplb=$lg(InsuTaritemInfo,37)			;发票类别
	.s INTIMDicType=$lg(InsuTaritemInfo,38)			;目录类别
	.q:(DicType'="")&&(DicType'=INTIMDicType)
	.s TaritemRowid=""
	.s:INTIMDicType'="" TaritemRowid=$o(^DHCINDID("0","ITypeCode","TariType",INTIMDicType,TaritemRowid))
	.s:TaritemRowid'="" INTIMDicType=$p($g(^DHCINDID(TaritemRowid)),"^",3)
	.s INTIMUserDR=$lg(InsuTaritemInfo,39)			;添加人
	.s:INTIMUserDR'="" INTIMUserDR=$p($g(^SSU("SSUSR",INTIMUserDR)),"^",2)
	.s INTIMDate=$lg(InsuTaritemInfo,40)			;添加日期
	.s:INTIMDate'="" INTIMDate=$zd(INTIMDate,3)
	.s INTIMTime=$lg(InsuTaritemInfo,41)			;添加时间
	.s:INTIMTime'="" INTIMTime=$zt(INTIMTime,1)
	.s INTIMADDIP=$lg(InsuTaritemInfo,42)			;修改机器
	.s INTIMActiveDate=$lg(InsuTaritemInfo,43)		;生效日期
	.s:INTIMActiveDate'="" INTIMActiveDate=$zd(INTIMActiveDate,3)
	.s INTIMUnique=$lg(InsuTaritemInfo,44)			;医保中心唯一码
	.s INTIMExpiryDate=$lg(InsuTaritemInfo,45)		;失效日期
	.s:INTIMExpiryDate'="" INTIMExpiryDate=$zd(INTIMExpiryDate,3)
	.s ActiveFlg=$lg(InsuTaritemInfo,46)			;有效标志
	.s DataVersion=$lg(InsuTaritemInfo,47)			;下载数据批次
	.q:(DataVer'="")&&(DataVer'=DataVersion)
	.s DifferenceCate=$lg(InsuTaritemInfo,48)		;差异分类
	.q:(DiffCate'="")&&(DiffCate'=DifferenceCate)
	.s DifferenceCom=$lg(InsuTaritemInfo,49)		;差异内容
	.s:$g(DifferenceCom)'="" DifferenceCom=##class(web.InsuDlConfigCtl).getInsuTarItemDlDesc(DifferenceCom)
	.s AuditImportFlag=$lg(InsuTaritemInfo,50)		;审核标记
	.q:(AuditFlag'="")&&(AuditFlag'=AuditImportFlag)
	.s RefuseCommon=$lg(InsuTaritemInfo,51)			;拒绝原因
	.s AuiditUserCode=$lg(InsuTaritemInfo,52)		;审核人编码
	.s:AuiditUserCode'="" AuiditUserCode=$p($g(^SSU("SSUSR",AuiditUserCode)),"^",2)
	.s AuiditDate=$lg(InsuTaritemInfo,53)			;审核日期
	.s:AuiditDate'="" AuiditDate=$zd(AuiditDate,3)
	.s AuiditTime=$lg(InsuTaritemInfo,54)			;审核时间
	.s:AuiditTime'="" AuiditTime=$zt(AuiditTime,1)

	
    .d OutputRow
     k ^TMPINSUTar($j)
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ind,RowId,INTIMsfdlbm,INTIMsfxmbm,INTIMxmbm,INTIMxmmc,INTIMxmrj,INTIMtxbz,INTIMxmlb,INTIMjx,INTIMgg,INTIMdw,INTIMyf,INTIMyl,INTIMsl,INTIMpzwh,INTIMbzjg,INTIMsjjg,INTIMzgxj,INTIMzfbl1,INTIMzfbl2,INTIMzfbl3,INTIMbpxe,INTIMbz,INTIMtjdm,INTIMflzb1,INTIMflzb2,INTIMflzb3,INTIMflzb4,INTIMflzb5,INTIMflzb6,INTIMflzb7,INTIMspmc,INTIMspmcrj,INTIMljzfbz,INTIMyyjzjbz,INTIMyysmbm,INTIMfplb,INTIMDicType,INTIMUserDr,INTIMDate,INTIMTime,INTIMADDIP,INTIMActiveDate,INTIMUnique,INTIMExpiryDate,ActiveFlg,DataVersion,DifferenceCate,DifferenceCom,AuditImportFlag,RefuseCommon,AuiditUserCode,AuiditDate,AuiditTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryInsuTaritemInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInsuTaritemInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryInsuTaritemInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInsuTaritemInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      ZhaoZW
/// CreatDate：    2020-02-25
/// Description:   根据字典类型查询医保字典数据
/// Table：        被访问的表(insu_dicdata)
/// Input：        
/// Output：       
/// Debug: do ##class(%ResultSet).RunQuery("web.InsuTaritemsDLCtl","QueryInsuDicDataInfo","DLLType")
Query QueryInsuDicDataInfo(DicType As %String) As websys.Query(ROWSPEC = "ind,DicCode:%String,DicDesc:%String")
{
}

ClassMethod QueryInsuDicDataInfoExecute(ByRef qHandle As %Binary, DicType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    ;s ^TMPQueryInsuDicDataInfo=$lb(DicType)
    q:DicType="" $$$OK
    s RowId=""
    f  s RowId=$o(^DHCINDID("0","IType",DicType,RowId)) q:RowId=""  d
    .s DicCode=$p($g(^DHCINDID(RowId)),"^",2)	;字典代码
    .s DicDesc=$p($g(^DHCINDID(RowId)),"^",3)	;字典描述
    .d OutputRow
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ind,DicCode,DicDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryInsuDicDataInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInsuDicDataInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryInsuDicDataInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInsuDicDataInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      ZhaoZW
/// CreatDate：    2020-02-25
/// Description:   查询最新的10个批次号
/// Table：        被访问的表(User.InsuTaritemsDL)
/// Input：        
/// Output：       
/// Debug: do ##class(%ResultSet).RunQuery("web.InsuTaritemsDLCtl","QueryDataVersionInfo","FYB","ALL","ALL")
Query QueryDataVersionInfo(DicType As %String, DiffCate As %String, AuditFlag As %String) As websys.Query(ROWSPEC = "ind,VerCode:%String,VerDesc:%String")
{
}

ClassMethod QueryDataVersionInfoExecute(ByRef qHandle As %Binary, DicType As %String, DiffCate As %String, AuditFlag As %String) As %Status
{
	s ^TMPQueryDataVersionInfo=$lb(DicType,DiffCate,AuditFlag)	
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    s:DiffCate="ALL" DiffCate=""
    s:AuditFlag="ALL" AuditFlag=""
    s RowId=""
    s DataVersionStr=""
    f  s RowId=$o(^User.InsuTaritemsDLD(RowId),-1) q:RowId=""  d
    .s InsuTaritemInfo=$g(^User.InsuTaritemsDLD(RowId))
    .s INTIMDicType=$lg(InsuTaritemInfo,38)			;目录类别
	.q:(DicType'="")&&(DicType'=INTIMDicType)
	.s DifferenceCate=$lg(InsuTaritemInfo,48)		;差异分类
	.q:(DiffCate'="")&&(DiffCate'=DifferenceCate)
	.s AuditImportFlag=$lg(InsuTaritemInfo,50)		;审核标记
	.q:(AuditFlag'="")&&(AuditFlag'=AuditImportFlag)
    .s DataVersion=$lg(InsuTaritemInfo,47)      	;数据批次
    .q:DataVersionStr[DataVersion
    .s DataVersionStr=DataVersionStr_"^"_DataVersion
    .s VerCode=ind
    .s VerDesc=DataVersion
    .q:ind=11
    .d OutputRow
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ind,VerCode,VerDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryDataVersionInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDataVersionInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryDataVersionInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDataVersionInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 功能说明：医保目录审核
/// w ##class(web.InsuTaritemsDLCtl).AduitInsuTaritem("143396","7","1")
ClassMethod AduitInsuTaritem(RowId As %String, Index As %String, UserDr As %String) As %String
{
	s ^TMP("AduitInsuTaritem")=$lb(RowId,Index,UserDr)
	s Data=""
	s Stauts=..AuditInsuTarItemsDL(RowId,UserDr, .ErrMsg, .Data)   ;审核并同步数据
    s Result("Data")=Data
    s Result("Stauts")=Stauts
    s Result("Info")=ErrMsg
    s Result("Index")=Index
  	s Data.DifferenceCom=##class(web.InsuDlConfigCtl).getInsuTarItemDlDescTwo(Data.DifferenceCom) ;
	q ##class(web.InsuJFEncodeJson).Encode(.Result)
	
	/*
	;s ^TMPAduitInsuTaritem=$lb(RowId,Index,UserDr)
    s Data=""
    s ErrMsg=""
    s Stauts=0
    
    
    s objInsuTarItem=##class(User.InsuTaritemsDL).%OpenId(RowId)
    i objInsuTarItem d
    .s objInsuTarItem.AuditImportFlag="1"		;修改审核状态标志为"1"
    .s objInsuTarItem.AuiditUserCode=UserDr		;审核人
    .s objInsuTarItem.AuiditDate=$p($h,",",1)	;审核日期
    .s objInsuTarItem.AuiditTime=$p($h,",",2)	;审核时间
    .s Stauts=objInsuTarItem.%Save()			;保存数据
    i Stauts>0 d
    .s Data =objInsuTarItem
    .s:Data.INTIMUserDR'="" Data.INTIMUserDR=$p($g(^SSU("SSUSR",Data.INTIMUserDR)),"^",1) ;添加人
    .s:Data.AuiditUserCode'="" Data.AuiditUserCode=$p($g(^SSU("SSUSR",Data.AuiditUserCode)),"^",1) ;审核人
    .s:Data.INTIMsfxmbm'="" InsuRowid=$o(^DHCINDID("0","ITypeCode","DLLType",Data.INTIMsfxmbm,"0"))
	.s:InsuRowid'="" Data.INTIMsfxmbm=$p($g(^DHCINDID(InsuRowid)),"^",2)   	;医保类型
    .s:Data.INTIMDicType'="" TaritemRowid=$o(^DHCINDID("0","ITypeCode","TariType",Data.INTIMDicType,"0"))
	.s:TaritemRowid'="" Data.INTIMDicType=$p($g(^DHCINDID(TaritemRowid)),"^",2)   ;目录类型
	
    
    s Result("Data")=Data
    s Result("Stauts")=Stauts
    s Result("Info")=ErrMsg
    s Result("Index")=Index
    
    //01 调用比较方法 更新差异字段  把保存操作放在比较方法中
	s TarItemID=""
    s flag=..CompareTarItem(RowId,.TarItemID)  ;新下载数据与原数据比较

	//02 根据差异结果  同步(更新)医保目录表数据( TarItemID : 医保目录表Rowid)
	s SaveID=..UpdateINSUItemsByINSUTempId(RowId,TarItemID)	
    q:+SaveID'=0 "更新数据失败！"
    
    q ##class(web.InsuJFEncodeJson).Encode(.Result)
    */
}

/// 功能说明：审核下载的医保目录
///           根据比较结果，把下载的目录更新到医保目录表中
/// 入参说明：RowId   --> 医保目录下载表ID
///           UserDr  --> 审核人
///           ErrMsg  --> 错误信息(出参)
///           objInsuTarItemDl --> 审核数据对象
/// 返 回 值：0 成功 其他失败
/// 修改履历：董科锋 2020-03-11 新做成
ClassMethod AuditInsuTarItemsDL(RowId As %String, UserDr As %String, ByRef ErrMsg As %String, ByRef objInsuTarItemDl As %String) As %String
{
	s RtnFlg="-1"
	s ErrMsg=""
	
	// 01 数据合法性验证
	s:((RowId="")||(UserDr="")) ErrMsg="请求参数不正确!"
	q:ErrMsg'="" RtnFlg
	s objInsuTarItemDl=##class(User.InsuTaritemsDL).%OpenId(RowId)
	s:$isobject(objInsuTarItemDl)=0 ErrMsg="审核数据不存在!"
	q:ErrMsg'="" RtnFlg
	s TarItemID=""  ;对应的医保目录Dr
	s DifferenceCate=objInsuTarItemDl.DifferenceCate  ;差异标志 1：新增 2:更新 3:有效标识变化 0：无差异 99：未比较(默认)
	if (DifferenceCate="99"){
		s DifferenceCate=..CompareTarItem(RowId,.TarItemID, objInsuTarItemDl)  ;新下载数据与原数据比较
		s DifferenceCateTMP=+DifferenceCate
		s:((DifferenceCateTMP=99)||(DifferenceCateTMP<0)) ErrMsg="数据有误,没有比较出结果!"
	}else{
		s TarItemID=objInsuTarItemDl.TarItmesDr    ;对应的医保目录Dr
	}
	s:DifferenceCate="0" ErrMsg="数据无差异,不需要审核!"
	q:ErrMsg'="" RtnFlg
	
	//同步下载数据到医保目录表并更新下载表状态
	tstart   ;开始事务
	s UpdFlg=+..UpdateINSUItemsByINSUTempId(RowId, TarItemID)   ;把下载的医保目录同步到医保目录表中
	if (UpdFlg<0) {
		s ErrMsg="数据同步到医保目录失败!"
	}else{
	    s objInsuTarItemDl.AuditImportFlag="1"		;修改审核状态标志为"1"
	    s objInsuTarItemDl.AuiditUserCode=UserDr	;审核人
	    s objInsuTarItemDl.AuiditDate=$p($h,",",1)	;审核日期
	    s objInsuTarItemDl.AuiditTime=$p($h,",",2)	;审核时间
	    s sc=objInsuTarItemDl.%Save()		        ;保存数据
	    if ($System.Status.IsError(sc)) {
		    s ErrMsg="更新目录下载表状态失败!"
	    }else{
		    s RtnFlg="0"
	    }
	}
	
	if (RtnFlg="0") {
		tcommit     ;提交事务
	}else{
		trollback   ;回滚事务
	}
	
	q RtnFlg
}

/// Output：       
/// Debug: do ##class(%ResultSet).RunQuery("web.InsuTaritemsDLCtl","QueryProperty","User.InsuTaritemsDL")
Query QueryProperty(obj As %String) As websys.Query(ROWSPEC = "ind, PropertyStr :%String,Property :%String")
{
}

ClassMethod QueryPropertyExecute(ByRef qHandle As %Binary, obj As %String) As %Status
{
	s Property=""
	s PropertyStr=""
	f  s PropertyStr=$o(^oddDEF(obj,"a",PropertyStr)) q:PropertyStr=""  d
	.s Property=PropertyStr
	.d OutputRow
	
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ind,Property,Property)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryPropertyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPropertyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryPropertyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPropertyExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 功能说明：比较未必交的下载数据
///           根据比较结果，把下载的目录更新到医保目录表中
/// 入参说明：DicType   --> 目录类型
///           DataVer  --> 数据类型版本
/// 返 回 值：>0 成功 其他失败
/// 
ClassMethod CompareInsuTaritemInfo(DicType As %String, DataVer As %String)
{
	
    s RowId="",flag=0,sucess=0,error=0
    f  s RowId=$o(^User.InsuTaritemsDLD(RowId)) q:(RowId="")  d
    .s InsuTaritemInfo=$g(^User.InsuTaritemsDLD(RowId))
    .s INTIMsfdlbm=$lg(InsuTaritemInfo,2)			;收费大类代码
	.s INTIMsfxmbm=$lg(InsuTaritemInfo,3)			;医保类型
	.s InsuRowid=""
	.s:INTIMsfxmbm'="" InsuRowid=$o(^DHCINDID("0","ITypeCode","DLLType",INTIMsfxmbm,InsuRowid))
	.s:InsuRowid'="" INTIMsfxmbm=$p($g(^DHCINDID(InsuRowid)),"^",4)
	.s INTIMDicType=$lg(InsuTaritemInfo,38)			;目录类别
	.q:(DicType'="")&&(DicType'=INTIMDicType)
	.s DataVersion=$lg(InsuTaritemInfo,47)			;下载数据批次
	.q:(DataVer'="")&&(DataVer'=DataVersion)
	.s DifferenceCate=$lg(InsuTaritemInfo,48)		;差异分类
	.q:DifferenceCate'="99"
	.set flag=..CompareTarItem(RowId)
	.set:flag<0 error=error+1
	.set:flag>0 sucess=sucess+1
	q sucess_"^"_error
}

/// 功能说明：审核某个数据批次的所有医保目录
///           根据比较结果，把下载的目录更新到医保目录表中
/// 入参说明：DataVer   --> 数据批次号
///           InsuType  --> 医保类型
///           UserDr  --> 操作员Dr
///           DicType  --> 目录类型
/// 返 回 值：sucess_"^"_error 审核成功数量^审核失败数量
/// debug:w ##class(web.InsuTaritemsDLCtl).AduitInsuTaritemAll("20200327091823","FYB","1","FYB")
ClassMethod AduitInsuTaritemAll(DataVer As %String, InsuType As %String, UserDr As %String, DicType As %String) As %String
{
    s RowId="",flag=0,sucess=0,error=0,index=-1,INTIMxmbm="",AuditImportSucess=0,All=0,NoDiff=0
    s AuditImportError=0
    f  s INTIMxmbm=$o(^User.InsuTaritemsDLI("idxDifferenceCate",DataVer,InsuType,INTIMxmbm)) q:(INTIMxmbm="")  d
    .set DifferenceCate=$o(^User.InsuTaritemsDLI("idxDifferenceCate", DataVer,InsuType, INTIMxmbm,""))
    .q:(DifferenceCate="")
    .set All=All+1
    .;set:DifferenceCate="99" NotCompare=NotCompare+1 ;未比较
    .set:DifferenceCate="0" NoDiff=NoDiff+1 ;没差异
    .q:(DifferenceCate="99") ;(DifferenceCate="99")||(DifferenceCate="0") ;未比较和没差异过滤
    .set RowId=$o(^User.InsuTaritemsDLI("idxDifferenceCate",DataVer,InsuType,INTIMxmbm,DifferenceCate,""))
    .s InsuTaritemInfo=$g(^User.InsuTaritemsDLD(RowId))
	.s INTIMDicType=$lg(InsuTaritemInfo,38)			;目录类别
	.q:(DicType'="")&&(DicType'=INTIMDicType)
	.s AuditImportFlag=$lg(InsuTaritemInfo,50)		;审核标记
	.set:AuditImportFlag="1" AuditImportSucess=AuditImportSucess+1 ;已经审核
	.set:AuditImportFlag="2" AuditImportError=AuditImportError+1 ;审核拒接
	.q:(AuditImportFlag="1")||(AuditImportFlag="2") ;已经审核和审核拒接过滤
	.set Data=""
	.set ErrMesg=""
	.set flag=..AuditInsuTarItemsDL(RowId,UserDr, .ErrMsg, .Data)
	.set:+flag'=0 error=error+1 
	.set:+flag=0 sucess=sucess+1
	set rtn=All_"!"_"All"_"^"_AuditImportSucess_"!"_"AS"_"^"_AuditImportError_"!"_"AE"
	set rtn=rtn_"^"_NoDiff_"!"_"ND"_"^"_sucess_"!"_"SU"_"^"_error_"!"_"Err"
	q rtn
}

/// 功能说明：获得最后一次下载的时间 
///           根据比较结果，把下载的目录更新到医保目录表中
/// 入参说明：InsuType   --> 目录类型
///           DicType  --> 数据类型版本
/// 返 回 值：日期_" "_时间  ""没获取到下载时间 YYYY-MM-DD HH:MM:SS
/// debug:w ##class(web.InsuTaritemsDLCtl).QueryLastDownTime()
ClassMethod QueryLastDownTime(InsuType As %String, DicType As %String) As %String
{
	set Date="",ind=0,Time="",RowId=""
	f  s RowId=$o(^User.InsuTaritemsDLD(RowId),-1) q:(RowId="")||(ind>0)  d
    .s InsuTaritemInfo=$g(^User.InsuTaritemsDLD(RowId))
    .s INTIMsfxmbm=$lg(InsuTaritemInfo,3)
    .q:($g(InsuType)'="")&&(InsuType'=INTIMsfxmbm)
    .s INTIMDicType=$lg(InsuTaritemInfo,38)			;目录类别
	.q:($g(DicType)'="")&&(DicType'=INTIMDicType)
    .s DataVersion=$lg(InsuTaritemInfo,47)      	;数据批次
    .q:DataVersion=""
    .set Date=$Extract(DataVersion,1,4)_"-"_$Extract(DataVersion,5,6)_"-"_$Extract(DataVersion,7,8)  ;日期
    .set Time=$Extract(DataVersion,9,10)_":"_$Extract(DataVersion,11,12)_":"_$Extract(DataVersion,13,14)  ;时间
    .set ind=1

   q Date_" "_Time
}

}
