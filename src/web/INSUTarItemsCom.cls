Import SQLUser

Class web.INSUTarItemsCom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 232;

ClassMethod QueryAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// Modify: tangzf
/// ModifyDate: 2020-02-19
/// Descript: 查询 医保目录
/// Input:		txt : 	检索关键字	
/// 			Class : 检索类型(例如 按类型)
/// 			Type : 	医保类型
/// 				zfblTmp : 	INSUTarItems.INTIMzfbl1  自付比例1（js没有传入）
/// 			ExpStr : 收费项大类DR | 收费项大类描述
///             HospDr:院区指针 +20200507 DingSH 
/// Output: 
/// Return: 
/// DeBug: 
///  d ##class(%ResultSet).RunQuery("web.INSUTarItemsCom","QueryAll","","3","00A","","0|全部","")
ClassMethod QueryAllExecute(ByRef qHandle As %Binary, txt As %String, Class As %String, Type As %String, zfblTmp As %String, ExpStr As %String = "", HospDr) As %Status
{
	Set repid=$I(^CacheTemp)
	s zfblTmp=$tr(zfblTmp," ")
	kill ^CacheTemp("QueryAllExecute")
	set ^CacheTemp("QueryAllExecute")=$lb(txt , Class , Type , zfblTmp , ExpStr , HospDr)
	set ^CacheTemp("INSUTarItem")=$p($h,",",2)
	
	s INTIMsfdlbm="",INTIMsfxmbm="",INTIMxmbm="",INTIMxmmc="",INTIMxmrj="",INTIMtxbz="",INTIMxmlb="",INTIMjx="",INTIMgg="",INTIMdw="",INTIMyf="",INTIMyl="",INTIMsl=""
	s INTIMpzwh="",INTIMbzjg="",INTIMsjjg="",INTIMzgxj="",INTIMzfbl1="",INTIMzfbl2="",INTIMzfbl3="",INTIMbpxe="",INTIMbz="",INTIMtjdm="",INTIMflzb1="",INTIMflzb2=""
	s INTIMflzb3="",INTIMflzb4="",INTIMflzb5="",INTIMflzb6="",INTIMflzb7="",INTIMspmc="",INTIMspmcrj="",INTIMljzfbz="",INTIMyyjzjbz="",INTIMyysmbm="",INTIMfplb="",INTIMDicType=""
	s INTIMUserDr="",INTIMDate="",INTIMTime="",INTIMADDIP="",INTIMActiveDate="",INTIMUnique=""
	s INTIMsfxmbmdesc="",INTIMUserName="",INTIMHospDr="",INTIMXmlbDesc=""
	s FilterByTarCate = ##class(web.INSUDicDataCom).GetDicByCodeAndInd("SYS","FilterByTarCate",6,HospDr) //tangzf 20200219 是否根据费用分类 过滤医保目录数据。 字典配置 
	s TarCateDr=$p(ExpStr,"|",1) // 收费项大类
	s TarCateDesc=$p(ExpStr,"|",2) // 收费项大类
	
	//根据院区取医保分组默认院区的ID
	s PageNum=1000 //+最大查询条数 20220909
	s:(HospDr="")&&($g(%session)'="") HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_TarItems",HospDr)
	s ^CacheTemp("INSUQueryAllExecute")=$lb(txt, Class , Type , zfblTmp ,ExpStr,GroupHospDr)
	s ind=1
	s job=$$QueryAll^DHCINSUTarItems(txt,Class,Type,HospDr,PageNum)
	set ^CacheTemp("INSUTarItem",1)=$p($h,",",2)-^CacheTemp("INSUTarItem")
	s index=0
	s id=""
	i +Class="10" d	//按rowid查询
	.s job=$j
	.s ^CacheTemp("INSUDIC",job,+txt)=+txt_"^"_$g(^DHCINTIM(+txt))
	f  s id=$o(^CacheTemp("INSUDIC",job,id)) q:id=""  d
	.s s=$g(^CacheTemp("INSUDIC",job,id))
	.s rowid=$p(s,"^",1)
	.;+2019-7-30 tangzf 医院授权判断 start
	.s TmpHospital=$p(s,"^",46)
	.q:GroupHospDr'=TmpHospital
	.;+2019-7-30 tangzf 医院授权判断 end
	.s INTIMsfdlbm=$p(s,"^",2)
    .s INTIMsfxmbm=$p(s,"^",3)
    .s INTIMsfdlbmDesc=""
    .s:INTIMsfdlbm'="" INTIMsfdlbmDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("med_chrgitm_type"_INTIMsfxmbm,INTIMsfdlbm,4,HospDr)	//tangzf 2019-7-19 FeeType
    .//tangzf 20200219 是否根据费用分类 过滤医保目录数据，通过描述筛选。 字典配置 start add
    .s FilterTarCateDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("med_chrgitm_typeCon"_INTIMsfxmbm,TarCateDr,7,HospDr) // FeeTypeCon如果该医保类型费用分类需要对照且已经对照，则优先根据对照的费用分类进行筛选
    .s:FilterTarCateDesc="" FilterTarCateDesc=TarCateDesc
    .q:(FilterByTarCate="1")&&(TarCateDesc'="")&&(TarCateDesc'="全部")&&(INTIMsfdlbmDesc'[FilterTarCateDesc)&&((FilterTarCateDesc'[INTIMsfdlbmDesc)||(INTIMsfdlbmDesc="")) // FilterByTarCate =1生效 ，费用分类不是全部，大类不一致 。才筛选
    .;b //tangzf 20200219 是否根据费用分类 过滤医保目录数据。 字典配置 end
    .s INTIMxmbm=$p(s,"^",4)
    .s INTIMxmmc=$p(s,"^",5)
    .s INTIMxmrj=$p(s,"^",6)
    .s INTIMtxbz=$p(s,"^",7)
    .s INTIMxmlb=$p(s,"^",8)
    .//s INTIMXmlbDesc=$case(INTIMxmlb,"1":"药品","2":"诊疗","3":"服务设施",:INTIMxmlb)
    .s INTIMXmlbDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("list_type"_INTIMsfxmbm,INTIMxmlb,4,HospDr)
    .s:INTIMXmlbDesc="" INTIMXmlbDesc=INTIMxmlb
    .s INTIMjx=$p(s,"^",9)
    .s INTIMjxDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("drug_dosform"_INTIMsfxmbm,INTIMjx,4,HospDr) //DosageCon
    .s:INTIMjxDesc="" INTIMjxDesc=INTIMjx  //+DingSH 20201119 
    .s INTIMgg=$p(s,"^",10)
    .s INTIMdw=$p(s,"^",11)
    .s INTIMyf=$p(s,"^",12)
    .s INTIMyl=$p(s,"^",13)
    .s INTIMsl=$p(s,"^",14)
    .s INTIMpzwh=$p(s,"^",15)
    .s INTIMbzjg=$p(s,"^",16)
    .s INTIMsjjg=$p(s,"^",17)
    .s INTIMzgxj=$p(s,"^",18)
    .s INTIMzfbl1=$tr($p(s,"^",19)," ")
    .q:((zfblTmp'="")&(INTIMzfbl1'=zfblTmp))
    .s:(+INTIMzfbl1)<=1 INTIMzfbl1=(+INTIMzfbl1)*100_"%"
    .s INTIMzfbl2=$p(s,"^",20)
    .s:(+INTIMzfbl2)<=1 INTIMzfbl2=(+INTIMzfbl2)*100_"%"
    .s INTIMzfbl3=$p(s,"^",21)
    .s:(+INTIMzfbl3)<=1 INTIMzfbl3=(+INTIMzfbl3)*100_"%"
    .s INTIMbpxe=$p(s,"^",22)
    .s INTIMbz=$p(s,"^",23)
    .s INTIMtjdm=$p(s,"^",24)
    .s TmpINTIMtjdm=""
    .s:INTIMtjdm'="" TmpINTIMtjdm=##class(web.INSUDicDataCom).GetDicByCodeAndInd("chrgitm_lv"_INTIMsfxmbm,INTIMtjdm,4,HospDr)	//AKA065 Zhan 20141204
    .s:TmpINTIMtjdm'="" INTIMtjdm=TmpINTIMtjdm
    .s INTIMflzb1=$p(s,"^",25)
    .s INTIMflzb2=$p(s,"^",26)
    .;w ",INTIMflzb2:"_INTIMflzb2
    .s INTIMflzb3=$p(s,"^",27)
    .s INTIMflzb4=$p(s,"^",28)
    .s INTIMflzb5=$p(s,"^",29)
    .s INTIMflzb6=$p(s,"^",30)
    .s INTIMflzb7=$p(s,"^",31)
    .s INTIMspmc=$p(s,"^",32)
    .s INTIMspmcrj=$p(s,"^",33)
    .s INTIMljzfbz=$p(s,"^",34)
    .s INTIMyyjzjbz=$p(s,"^",35)
    .s INTIMyysmbm=$p(s,"^",36)
    .s INTIMfplb=$p(s,"^",37)
    .s INTIMDicType=$p(s,"^",38)
    .s INTIMUserDr=$p(s,"^",39)
    .i INTIMUserDr'="" d
    ..i $d(^SSU("SSUSR",INTIMUserDr)) d
    ...;s INTIMUserDr=$p(^SSU("SSUSR",INTIMUserDr),"^",2)
    ...s INTIMUserName=$p(^SSU("SSUSR",INTIMUserDr),"^",2)
    .s:+$p(s,"^",40)>0 INTIMDate=##class(websys.Conversions).DateLogicalToHtml($p(s,"^",40)) ;;Zhan 20170309 ;INTIMDate=$zd($p(s,"^",40),3) 
    .s:+$p(s,"^",41)>0 INTIMTime=##class(websys.Conversions).TimeLogicalToHtml($p(s,"^",41)) ;Zhan 20170309	;$zt($p(s,"^",41),1)
    .s INTIMADDIP=$p(s,"^",42)
    .s:+$p(s,"^",43)>0 INTIMActiveDate=##class(websys.Conversions).DateLogicalToHtml($p(s,"^",43)) ;Zhan 20170309	;$zd($p(s,"^",43),3)
    .s INTIMUnique=$p(s,"^",44) 
    .s INTIMExpiryDate=$p(s,"^",45)
    .s:(+INTIMExpiryDate'=0)&(+$h>+INTIMExpiryDate) INTIMflzb2="N"	;Zhan 20160505
    .s:+INTIMExpiryDate>0 INTIMExpiryDate=##class(websys.Conversions).DateLogicalToHtml(INTIMExpiryDate) ;Zhan 20170309 ;$zd(INTIMExpiryDate,3)
    .s:INTIMExpiryDate=0 INTIMExpiryDate=""
    .s INTIMHospDr=$p(s,"^",46)
	.s index=index+1
	.d Build
	set ^CacheTemp("INSUTarItem",2)=$p($h,",",2)-^CacheTemp("INSUTarItem")
	b ;end
	Set qHandle=$lb(0,repid,0)
	k ^CacheTemp("INSUDIC",job)
	Quit $$$OK
Build   
	s:INTIMbzjg=0 INTIMbzjg=""
	s:INTIMsjjg=0 INTIMsjjg=""
	s:INTIMzgxj=0 INTIMzgxj=""
	s:INTIMsl=0 INTIMsl=""
	s:INTIMbpxe=0 INTIMbpxe=""
	s:INTIMsfxmbm'="" INTIMsfxmbmdesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("TariType",INTIMsfxmbm,4,HospDr)
	set Data=$lb(0,rowid,INTIMsfdlbm,INTIMsfxmbm,INTIMxmbm,INTIMxmmc,INTIMxmrj,INTIMtxbz,INTIMxmlb,INTIMjx,INTIMgg,INTIMdw,INTIMyf,INTIMyl,INTIMsl,INTIMpzwh,INTIMbzjg,INTIMsjjg,INTIMzgxj,INTIMzfbl1,INTIMzfbl2,INTIMzfbl3,INTIMbpxe,INTIMbz,INTIMtjdm,INTIMflzb1,INTIMflzb2,INTIMflzb3,INTIMflzb4,INTIMflzb5,INTIMflzb6,INTIMflzb7,INTIMspmc,INTIMspmcrj,INTIMljzfbz,INTIMyyjzjbz,INTIMyysmbm,INTIMfplb,INTIMDicType,index,INTIMtxbz,INTIMUserDr,INTIMDate,INTIMTime,INTIMADDIP,INTIMActiveDate,INTIMUnique,INTIMExpiryDate,INTIMsfxmbmdesc,INTIMUserName,INTIMsfdlbmDesc,INTIMHospDr,INTIMjxDesc,INTIMXmlbDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllExecute ]
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
 	 	s RecordSum=$o(^CacheTemp(repid,""),-1)     //新增ㄛ获取总记录数   2010 08 26
		s $List(^CacheTemp(repid,ind),1)=RecordSum  //新增ㄛ替换每条记录的第一列数据  2010 08 26
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query QueryAll(txt As %String, Class As %String, Type As %String, zfblTmp As %String, ExpStr As %String = "", HospDr) As %Query(ROWSPEC = "RecordSum:%String:记录,rowid:%String,INTIMsfdlbm:%String:收费大类编码,INTIMsfxmbm:%String:医保类型,INTIMxmbm:%String:项目编码,INTIMxmmc:%String:项目名称,INTIMxmrj:%String:拼音码,INTIMtxbz:%String:限制用药标识,INTIMxmlb:%String:项目类别,INTIMjx:%String:剂型,INTIMgg:%String:规格,INTIMdw:%String:单位,INTIMyf:%String:用法,INTIMyl:%String:用量,INTIMsl:%String:数量,INTIMpzwh:%String:批准文号,INTIMbzjg:%String:标准价格,INTIMsjjg:%String:实际价格,INTIMzgxj:%String:最高限价,INTIMzfbl1:%String:自付比例1,INTIMzfbl2:%String:自付比例2,INTIMzfbl3:%String:自付比例3,INTIMbpxe:%String:报批限额,INTIMbz:%String:备注,INTIMtjdm:%String:项目等级,INTIMflzb1:%String:是否医保,INTIMflzb2:%String:有效标志,INTIMflzb3:%String:分类指标3,INTIMflzb4:%String:分类指标4,INTIMflzb5:%String:分类指标5,INTIMflzb6:%String:分类指标6,INTIMflzb7:%String:分类指标7,INTIMspmc:%String:商品名称,INTIMspmcrj:%String:商品拼音码,INTIMljzfbz:%String:累计增负标志,INTIMyyjzjbz:%String:医院增加标识,INTIMyysmbm:%String:医院三目标识,INTIMfplb:%String:发票类别,INTIMDicType:%String:目录类别,Index:%String:序号,LimitFlag:%String:限价标志,INTIMUserDr:%String:录入人,INTIMDate:%String:录入日期,INTIMTime:%String:录入时间,INTIMADDIP:%String:IP地址,INTIMActiveDate:%String:有效日期,INTIMUnique:%String:中心唯一码,INTIMExpiryDate:%String:失效日期,INTIMsfxmbmdesc:%String:医保类型描述,INTIMUserName:%String:操作员,INTIMsfdlbmDesc:%String:收费大类名称,INTIMHospDr:%String:院区指针,INTIMjxDesc:%String:剂型描述,INTIMXmlbDesc:%String:项目类别描述")
{
}

ClassMethod Get(itmjs As %Library.String = "", itmjsex As %Library.String = "", Rowid As %Library.String = "")
{
	
	q:$d(^DHCINTIM(Rowid))=0 100
	s s=$g(^DHCINTIM(Rowid))
	
	s s=$tr(s,$c(10),"")
	s $p(s,"^",42)=##class(websys.Conversions).DateLogicalToHtml($p(s,"^",42)) ;Zhan 20170309 ;$zd($p(s,"^",42),3)
	s:$p(s,"^",44)'="" $p(s,"^",44)=##class(websys.Conversions).DateLogicalToHtml($p(s,"^",44)) ;Zhan 20170309 ;$zd($p(s,"^",44),3)
	;st DingSH 20160329 自付比例 .6 显示成 0.6
	s INTIMzfbl1=$tr($p(s,"^",18)," ")
    i (INTIMzfbl1[".")&&($P(INTIMzfbl1,".",1)="") s $p(s,"^",18)="0"_INTIMzfbl1
    s INTIMzfbl2=$tr($p(s,"^",19)," ")
    i (INTIMzfbl2[".")&&($P(INTIMzfbl2,".",1)="") s $p(s,"^",19)="0"_INTIMzfbl2
    s INTIMzfbl3=$tr($p(s,"^",20)," ")
    i (INTIMzfbl3[".")&&($P(INTIMzfbl3,".",1)="") s $p(s,"^",20)="0"_INTIMzfbl3
    ;ed DingSH 20160329 自付比例 .6 显示成 0.6
	s INTIMsfdlbm=$p(s,"^",1)
	;-----Zhan 20160831----->
	s:$p(s,"^",13)=0 $p(s,"^",13)=""
	s:$p(s,"^",15)=0 $p(s,"^",15)=""
	s:$p(s,"^",16)=0 $p(s,"^",16)=""
	s:$p(s,"^",17)=0 $p(s,"^",17)=""
	s:$p(s,"^",21)=0 $p(s,"^",21)=""
	s fpdescs=$$QueryByCode^DHCINSUDicData("FeeType"_$p(s,"^",2),INTIMsfdlbm,$p(s,"^",45))
	s fpdesc=$p(fpdescs,"^",4)
	;<----------------------//
	s s=s_"^"_fpdesc
	s val=itmjs_"('"_s_"');"	
	b
	&javascript<#(val)#>
	q 0
}

ClassMethod GetInItemById(Rowid As %Library.String = "")
{
	q:Rowid="" -1
	q:$d(^DHCINTIM(Rowid))=0 -1
	s s=$g(^DHCINTIM(Rowid))
	s s=$tr(s,$c(10),"")
	
	;日期格式化
	s $p(s,"^",39)=##class(websys.Conversions).DateLogicalToHtml($p(s,"^",39)) ;
	s $p(s,"^",42)=##class(websys.Conversions).DateLogicalToHtml($p(s,"^",42)) ;Zhan 20170309 ;$zd($p(s,"^",42),3)
	s:$p(s,"^",44)'="" $p(s,"^",44)=##class(websys.Conversions).DateLogicalToHtml($p(s,"^",44)) ;Zhan 20170309 ;$zd($p(s,"^",44),3)
	;st DingSH 20160329 自付比例 .6 显示成 0.6
	s INTIMzfbl1=$tr($p(s,"^",18)," ")
    i (INTIMzfbl1[".")&&($P(INTIMzfbl1,".",1)="") s $p(s,"^",18)="0"_INTIMzfbl1
    s INTIMzfbl2=$tr($p(s,"^",19)," ")
    i (INTIMzfbl2[".")&&($P(INTIMzfbl2,".",1)="") s $p(s,"^",19)="0"_INTIMzfbl2
    s INTIMzfbl3=$tr($p(s,"^",20)," ")
    i (INTIMzfbl3[".")&&($P(INTIMzfbl3,".",1)="") s $p(s,"^",20)="0"_INTIMzfbl3
    ;ed DingSH 20160329 自付比例 .6 显示成 0.6
	s INTIMsfdlbm=$p(s,"^",1)
	;-----Zhan 20160831----->
	s:$p(s,"^",13)=0 $p(s,"^",13)=""
	s:$p(s,"^",15)=0 $p(s,"^",15)=""
	s:$p(s,"^",16)=0 $p(s,"^",16)=""
	s:$p(s,"^",17)=0 $p(s,"^",17)=""
	s:$p(s,"^",21)=0 $p(s,"^",21)=""
	
	
	s fpdescs=$$QueryByCode^DHCINSUDicData("FeeType"_$p(s,"^",2),INTIMsfdlbm,$p(s,"^",45))
	s fpdesc=$p(fpdescs,"^",4)
	s UserName=""
	s UserDr=$p(s,"^",38)
    i UserDr'="" d
    .i $d(^SSU("SSUSR",UserDr)) d
    ..s UserName=$p(^SSU("SSUSR",UserDr),"^",2)
    
    s tjdm=$p(s,"^",23)
    s tjdmdesc=tjdm
	s:tjdm'="" tjdmdesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA065"_$p(s,"^",2),tjdm,4,$p(s,"^",45))	//Zhan 20141204
   
	s s=Rowid_"^"_s_"^"_fpdesc_"^"_tjdmdesc_"^"_UserName
	
	q s
}

/// gcj 2009-09-01 获取HIS收费项目信息
ClassMethod GetTar(itmjs As %Library.String = "", itmjsex As %Library.String = "", Rowid As %Library.String = "") As %String
{
	q:$d(^DHCTARI(Rowid))=0 ""
	s s=$g(^DHCTARI(Rowid))
	q s
}

/// gcj 2009-09-01 修改限制药品标志和备注
ClassMethod UpdateTar(itmjs As %Library.String = "", itmjsex As %Library.String = "", LimitFlag As %Library.String = "", Demo As %Library.String = "", Rowid As %Library.String = "") As %String
{
  //&sql(update dhc_taritem set TARI_ExternalCode=:LimitFlag,TARI_InsuName=:Demo where TARI_RowId=:Rowid)
  //q SQLCODE
}

/// 入参第46位=院区 tangzf 2020-03-19
ClassMethod Update(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String) As %Library.String
{
	;w ##class(web.INSUTarItemsCom).Update("","","439812^0^QZA^15001336^立体定向脑深部核团毁损术^LTDXNSBHTHSS^#^1^^^^^^0^^0^0^0^40^1^保守治疗无效的以下疾病：①难治性帕金森氏病；②难治性舞蹈病；③难治性扭转痉挛；④难治性癫痫。^1^^^^")
	;s ^zmc("edit")=InString
	q:InString="" -100
	s:($p(InString,"^",46)="")&&($g(%session.Data("DHCBILLINSUCloud.Hospital"))'="") $p(InString,"^",46)=$g(%session.Data("DHCBILLINSUCloud.Hospital")) // tangzf 2019-8-2
    s flag=$$SaveINTIM^DHCINSUTarItems(InString)
	s Update=flag
	q Update
}

ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", Rowid As %Library.String = "")
{
	q:$d(^DHCINTIM(Rowid))=0 -100
	&sql(delete from INSU_TarItems where INTIM_Rowid=:Rowid)
	;&sql(select * from INSU_TarItems)
	q SQLCODE
}

ClassMethod Updatebm(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String) As %Library.String
{
	q:InString="" -100
    s Rowid=$p(InString,"^",2)
    s Bm=$p(InString,"^",7)
    &sql(update INSU_TarItems set INTIM_xmrj=:Bm  where INTIM_Rowid=:Rowid)
	s Updatebm=SQLCODE
	q Updatebm
}

/// tangzf 2020-5-26 add HospDr 必须是最小院区，未分组的院区
ClassMethod CheckInsu(InStr As %Library.String, HospDr) As %Library.String
{
	q:InStr="" -1 
	s sfxmbm=$p(InStr,"^",3)
	q:sfxmbm="" -100
	s xmbm=$p(InStr,"^",4)
	q:xmbm="" -101
	s exitRowid=0
	s HospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_TarItems",HospDr)
	s code=$$ALPHAUP^SSUTIL4($p(InStr,"^",4)) 
	s Actdatestr=$p(InStr,"^",43)
	;s:Actdatestr'="" Actdatestr=$zdh(Actdatestr,3)
	s:Actdatestr'="" Actdatestr=##class(websys.Conversions).DateHtmlToLogical(Actdatestr)
	s Enddatestr=$p(InStr,"^",45)
	s HospDr=$p(InStr,"^",46)
	;s:Enddatestr'="" Enddatestr=$zdh(Enddatestr,3)
	s:Enddatestr'="" Enddatestr=##class(websys.Conversions).DateHtmlToLogical(Enddatestr)
	s INTIMID="" 
	f  s INTIMID=$o(^DHCINTIM("0","CODE",code,INTIMID))   q:INTIMID=""  d
	.s INTIMsfxmbm=$p(^DHCINTIM(INTIMID),"^",2)
	.s INTIMxmbm=$p(^DHCINTIM(INTIMID),"^",3)
	.s Actdate=$p(^DHCINTIM(INTIMID),"^",42)
	.s enddate=$p(^DHCINTIM(INTIMID),"^",44)
	.s DataHospDr = $p(^DHCINTIM(INTIMID),"^",45)
	.quit:DataHospDr'=HospDr
	.;q:(Actdatestr'="")&(Actdate'="")&(Actdatestr'=Actdate)	//增加判断生效日期是否一样
	.q:(+Actdatestr'=0)&(+enddate'=0)&(enddate<Actdatestr)	;新增加项目的生效日期如果大于原项目的结束日期就增加，否则更新原项目，具体以医保要求来定
	.i (INTIMsfxmbm=sfxmbm)&(INTIMxmbm=xmbm)  d
	..s exitRowid=INTIMID
	q exitRowid
}

}
