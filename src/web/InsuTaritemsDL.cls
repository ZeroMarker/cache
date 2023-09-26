Class web.InsuTaritemsDL Extends (%Populate, %XML.Adaptor, %RegisteredObject)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "InsuReqest";

/// 医保发票分类，如：西药费、中药费
Property INTIMsfdlbm As %String(XMLPROJECTION = "ELEMENT");

/// 医保类别，如：省医保、市医保
Property INTIMsfxmbm As %String(XMLPROJECTION = "ELEMENT");

Property INTIMxmbm As %String(XMLPROJECTION = "ELEMENT");

Property INTIMxmmc As %String(XMLPROJECTION = "ELEMENT");

Property INTIMxmrj As %String(XMLPROJECTION = "ELEMENT");

Property INTIMtxbz As %String(XMLPROJECTION = "ELEMENT");

/// 药品、诊疗、服务设施
Property INTIMxmlb As %String(XMLPROJECTION = "ELEMENT");

Property INTIMjx As %String(XMLPROJECTION = "ELEMENT");

Property INTIMgg As %String(MAXLEN = 300, XMLPROJECTION = "ELEMENT");

Property INTIMdw As %String(XMLPROJECTION = "ELEMENT");

Property INTIMyf As %String(XMLPROJECTION = "ELEMENT");

Property INTIMyl As %String(XMLPROJECTION = "ELEMENT");

Property INTIMsl As %String(XMLPROJECTION = "ELEMENT");

Property INTIMpzwh As %String(XMLPROJECTION = "ELEMENT");

Property INTIMbzjg As %String(XMLPROJECTION = "ELEMENT");

Property INTIMsjjg As %String(XMLPROJECTION = "ELEMENT");

Property INTIMzgxj As %String(XMLPROJECTION = "ELEMENT");

Property INTIMzfbl1 As %String(XMLPROJECTION = "ELEMENT");

Property INTIMzfbl2 As %String(XMLPROJECTION = "ELEMENT");

Property INTIMzfbl3 As %String(XMLPROJECTION = "ELEMENT");

Property INTIMbpxe As %String(XMLPROJECTION = "ELEMENT");

Property INTIMbz As %String(MAXLEN = 999, XMLPROJECTION = "ELEMENT");

/// 医保类别：甲、乙、丙
Property INTIMtjdm As %String(XMLPROJECTION = "ELEMENT");

/// 是否医保
Property INTIMflzb1 As %String(XMLPROJECTION = "ELEMENT");

/// 有效标志
Property INTIMflzb2 As %String(XMLPROJECTION = "ELEMENT");

/// 国药准字
Property INTIMflzb3 As %String(XMLPROJECTION = "ELEMENT");

Property INTIMflzb4 As %String(XMLPROJECTION = "ELEMENT");

Property INTIMflzb5 As %String(XMLPROJECTION = "ELEMENT");

Property INTIMflzb6 As %String(XMLPROJECTION = "ELEMENT");

Property INTIMflzb7 As %String(XMLPROJECTION = "ELEMENT");

Property INTIMspmc As %String(XMLPROJECTION = "ELEMENT");

Property INTIMspmcrj As %String(XMLPROJECTION = "ELEMENT");

Property INTIMljzfbz As %String(XMLPROJECTION = "ELEMENT");

Property INTIMyyjzjbz As %String(XMLPROJECTION = "ELEMENT");

/// 物价编码或药品收费项编码
Property INTIMyysmbm As %String(XMLPROJECTION = "ELEMENT");

Property INTIMfplb As %String(XMLPROJECTION = "ELEMENT");

Property INTIMDicType As %String(XMLPROJECTION = "ELEMENT");

Property INTIMUserDR As %String(XMLPROJECTION = "ELEMENT");

Property INTIMDate As %String(XMLPROJECTION = "ELEMENT");

Property INTIMTime As %String(XMLPROJECTION = "ELEMENT");

Property INTIMADDIP As %String(XMLPROJECTION = "ELEMENT");

Property INTIMActiveDate As %String(XMLPROJECTION = "ELEMENT");

Property INTIMUnique As %String(XMLPROJECTION = "ELEMENT");

Property INTIMExpiryDate As %String(XMLPROJECTION = "ELEMENT");

/// 数据批次
Property DataVersion As %String(XMLPROJECTION = "ELEMENT");

Method ToPersistentObj() As User.InsuTaritemsDL
{
	s ObjInsuTaritem=##class(User.InsuTaritemsDL).%New()
	s ObjInsuTaritem.INTIMsfdlbm=..INTIMsfdlbm
	s ObjInsuTaritem.INTIMsfxmbm=..INTIMsfxmbm
	s ObjInsuTaritem.INTIMxmbm=..INTIMxmbm
	s ObjInsuTaritem.INTIMxmmc=..INTIMxmmc
	s ObjInsuTaritem.INTIMxmrj=..INTIMxmrj
	s ObjInsuTaritem.INTIMtxbz=..INTIMtxbz
	s ObjInsuTaritem.INTIMxmlb=..INTIMxmlb
	s ObjInsuTaritem.INTIMjx=..INTIMjx
	s ObjInsuTaritem.INTIMgg=..INTIMgg
	s ObjInsuTaritem.INTIMdw=..INTIMdw
	s ObjInsuTaritem.INTIMyf=..INTIMyf
	s ObjInsuTaritem.INTIMyl=..INTIMyl
	s ObjInsuTaritem.INTIMsl=..INTIMsl
	s ObjInsuTaritem.INTIMpzwh=..INTIMpzwh
	s ObjInsuTaritem.INTIMbzjg=..INTIMbzjg
	s ObjInsuTaritem.INTIMsjjg=..INTIMsjjg
	s ObjInsuTaritem.INTIMzgxj=..INTIMzgxj
	s ObjInsuTaritem.INTIMzfbl1=..INTIMzfbl1
	s ObjInsuTaritem.INTIMzfbl2=..INTIMzfbl2
	s ObjInsuTaritem.INTIMzfbl3=..INTIMzfbl3
	s ObjInsuTaritem.INTIMbpxe=..INTIMbpxe
	s ObjInsuTaritem.INTIMbz=..INTIMbz
	s ObjInsuTaritem.INTIMtjdm=..INTIMtjdm
	s ObjInsuTaritem.INTIMflzb1=..INTIMflzb1
	s ObjInsuTaritem.INTIMflzb2=..INTIMflzb2
	s ObjInsuTaritem.INTIMflzb3=..INTIMflzb3
	s ObjInsuTaritem.INTIMflzb4=..INTIMflzb4
	s ObjInsuTaritem.INTIMflzb5=..INTIMflzb5
	s ObjInsuTaritem.INTIMflzb6=..INTIMflzb6
	s ObjInsuTaritem.INTIMflzb7=..INTIMflzb7
	s ObjInsuTaritem.INTIMspmc=..INTIMspmc
	s ObjInsuTaritem.INTIMspmcrj=..INTIMspmcrj
	s ObjInsuTaritem.INTIMljzfbz=..INTIMljzfbz
	s ObjInsuTaritem.INTIMyyjzjbz=..INTIMyyjzjbz
	s ObjInsuTaritem.INTIMyysmbm=..INTIMyysmbm
	s ObjInsuTaritem.INTIMfplb=..INTIMfplb
	s ObjInsuTaritem.INTIMDicType=..INTIMDicType
	s ObjInsuTaritem.INTIMUserDR=..INTIMUserDR
	b ;000021
	s ObjInsuTaritem.INTIMDate=$p($h,",",1)   
	s ObjInsuTaritem.INTIMTime=$p($h,",",2)
	s ObjInsuTaritem.INTIMADDIP=..INTIMADDIP
	i (..INTIMActiveDate'="")&&($L(..INTIMActiveDate)=14) d
	.s DateA=$e(..INTIMActiveDate,1,4)_"-"_$e(..INTIMActiveDate,5,6)_"-"_$e(..INTIMActiveDate,7,8)	;日期拼串
	.b ; 454
	.s ..INTIMActiveDate=$zdh(DateA,3)
	s ObjInsuTaritem.INTIMActiveDate=..INTIMActiveDate
	s ObjInsuTaritem.INTIMUnique=..INTIMUnique
	i (..INTIMExpiryDate'="")&&($L(..INTIMExpiryDate)=14) d
	.s DateE=$e(..INTIMExpiryDate,1,4)_"-"_$e(..INTIMExpiryDate,5,6)_"-"_$e(..INTIMExpiryDate,7,8)	;日期拼串
	.s ..INTIMExpiryDate=$zdh(DateE,3)
	s ObjInsuTaritem.INTIMExpiryDate=..INTIMExpiryDate
	s ObjInsuTaritem.DataVersion=..DataVersion
	
	q ObjInsuTaritem
}

}
