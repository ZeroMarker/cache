Import SQLUser

/// 取库存项
Class web.DHCSTCOMINC Extends %RegisteredObject
{

ClassMethod GetSpec(inci As %String) As %String
{
	S info=$O(^DHCITMINFO(0,"INCI",inci,""))
	Q:info="" ""
	Q:'$D(^DHCITMINFO(info)) ""
	S spec=$P(^DHCITMINFO(info),"^",27)
	Q spec
}

/// Description :根据某库存项的基本单位库存数换算成带有入库单位和基本单位的库存数
/// Input: inci - INCI_Rowid ;  buomqty - 基本单位库存数
/// Output:qty - 带有单位的库存数 ,如  XX合XX片
/// Creator: zyg
/// CreatDate:20090402
ClassMethod GetQtyIncUom(inci As %String, buomqty As %String) As %String
{
   s qty=0
   s incibuomdr=$p(^INCI(inci,1),"^",10) ;基
   Q:incibuomdr="" ""
   s incipuomdr=$p(^INCI(inci,3),"^",6)  ;入
   Q:incipuomdr="" ""
   s buomdesc=$p($G(^CT("UOM",incibuomdr)),"^",2)
   s puomdesc=$p($G(^CT("UOM",incipuomdr)),"^",2)
   s factor=+##Class(DHCSTCOMMONSRV).UOMFac(incipuomdr,incibuomdr)
   Q:factor=0 ""
   S nFlag=0
   I buomqty<0 D
   .S buomqty=-buomqty
   .S nFlag=1
   s remainder=buomqty#factor
   S:nFlag=1 remainder=-remainder
   i remainder=0 d
   .S:nFlag=1 buomqty=-buomqty
   .s qty=buomqty/factor_puomdesc  ;XX合
   e  d
   .s qtyint=(buomqty/factor)\1
   .S:nFlag=1 qtyint=-qtyint
   .i qtyint=0 S qty=remainder_buomdesc
   .E  s qty=qtyint_puomdesc_remainder_buomdesc  ;XX合XX片
   q qty
}

/// 药学分类
ClassMethod GetPhcCatDesc(inci As %String) As %String
{
 q:inci="" ""
 s arcim=$p(^INCI(inci,1),"^",3) q:arcim="" ""
 s sub=$p(arcim,"||",1) q:sub="" ""
 s ver=$p(arcim,"||",2)  q:ver="" ""
 s drgfrm=$p(^ARCIM(sub,ver,1),"^",12) q:drgfrm="" ""
 s drg=$P(drgfrm,"||",1) q:drg="" ""
 s subcat=$p(^PHCD(drg,1),"^",3) q:subcat="" ""
 s cat=$P(subcat,"||",1),sub=$p(subcat,"||",2)
 Q:cat="" ""
 Q:'$D(^PHCC(cat)) ""
 s catdesc=$p(^PHCC(cat),"^",2)
 q cat_"^"_catdesc
}

/// 药学子类名称
ClassMethod GetPhcSCDesc(inci As %String) As %String
{
 s subcatdesc=""
 q:inci="" subcatdesc
 s arcim=$p(^INCI(inci,1),"^",3) q:arcim="" ""
 s sub=$p(arcim,"||",1) q:sub="" ""
 s ver=$p(arcim,"||",2)  q:ver="" ""
 s drgfrm=$p(^ARCIM(sub,ver,1),"^",12) q:drgfrm="" ""
 s drg=$P(drgfrm,"||",1) q:drg="" ""
 s subcat=$p(^PHCD(drg,1),"^",3) q:subcat="" ""
 s cat=$P(subcat,"||",1),sub=$p(subcat,"||",2)
 q:(cat="")!(sub="") subcatdesc
 i $d(^PHCC(cat,"SC",sub)) d
 .s subcatdesc=$p(^PHCC(cat,"SC",sub),"^",2)
 e  d
 .s subcatdesc=""
 q subcat_"^"_subcatdesc
}

/// Creator:Liang Qiang
/// CreatDate:2009-08-04
/// Descriprtion:根据医嘱项Rowid获得库存项Rowid
/// Input:医嘱项Rowid
/// Return:库存项Rowid
ClassMethod GetInciByOrditm(orditmRowid As %String) As %String
{
   s ord=+orditmRowid
   s chl=$p(orditmRowid,"||",2)
   s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                 
   s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
   q inci
}

/// Creator:	zhouyonggang
/// CreatDate:	2011-03-16
/// Description:获得库存项的类组信息
/// Table:		INC_Itm，DHC_StkCatGrpRelations
/// Input:		库存项ID
/// Return:		类组代码^类组描述^类组类型
ClassMethod GetIncStkCatGrp(inci As %String) As %String
{
 Q:inci="" ""
 Q:'$d(^INCI(inci,2)) ""
 s inccat=$p(^INCI(inci,2),"^",2)
 s scg=$o(^DHCSCG("STKCAT",inccat,""))
 q:scg="" ""
 s scgdesc=$p(^DHCSCG(scg),"^",2)
 s scgcode=$p(^DHCSCG(scg),"^",1)
 s scgtype=$p(^DHCSCG(scg),"^",3)
 S scgtypeDesc=""
 I scgtype="G" D
 .S scgtypeDesc="Drug"
 Else  If scgtype="M" D
 .S scgtypeDesc="Material"
 Else  D
 .S scgtypeDesc="Other"
 q $g(scgcode)_"^"_$g(scgdesc)_"^"_$g(scgtype)_"^"_scgtypeDesc
}

/// Descript:	根据库存项ID取入库单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	入库单位ID^入库单位描述
ClassMethod GetIncPuom(InciDr As %String) As %String
{
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S puomdr=$P(^INCI(InciDr,3),"^",6)
 Q:puomdr="" ""
 Q:'$D(^CT("UOM",puomdr)) ""
 S puomdesc=$P(^CT("UOM",puomdr),"^",2)
 Q puomdr_"^"_puomdesc
}

/// Descript:	根据库存项ID取基本单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	基本单位ID^基本单位描述
ClassMethod GetIncBuom(InciDr As %String) As %String
{
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S buomdr=$P(^INCI(InciDr,1),"^",10)
 Q:buomdr="" ""
 Q:'$D(^CT("UOM",buomdr)) ""
 S buomdesc=$P(^CT("UOM",buomdr),"^",2)
 Q buomdr_"^"_buomdesc
}

/// Descript:	根据库存项描述取代码
/// Creater:	Zhouyg
/// CreateDate:	20100313
/// Input:		InciDesc-库存项描述
/// Output:		Return
/// Return：	库存项代码
ClassMethod GetInciCode(InciDesc As %String) As %String
{
 Q:InciDesc="" ""
 S InciDr=..GetInciRID(InciDesc)
 Q:InciDr="" ""
 S InciStr=..GetInciDesc(InciDr)
 S InciCode=$P(InciStr,"^",1)
 Q InciCode
}

/// Descript:	根据库存项描述取RowID
/// Creater:	Zhouyg
/// CreateDate:	20100313
/// Input:		InciDesc-库存项描述
/// Output:		Return
/// Return：	库存项RowID
ClassMethod GetInciRID(InciDesc As %String) As %String
{
 S InciDesc=$$ALPHAUP^SSUTIL4(InciDesc)
 Q:InciDesc="" ""
 S InciDr=$O(^INCI(0,"Desc",InciDesc,""))
 Q InciDr
}

/// Descript:	根据库存项RowID取代码和描述
/// Creater:	Zhouyg
/// CreateDate:	20100313
/// Input:		InciDr-库存项RowID
/// Output:		Return
/// Return：	库存项代码^库存项描述
ClassMethod GetInciDesc(InciDr As %String) As %String
{
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S InciCode=$P(^INCI(InciDr,1),"^",1)
 S InciDesc=$P(^INCI(InciDr,1),"^",2)
 Q InciCode_"^"_InciDesc
}

/// Descript:	根据inc_itmlcbt表RowID取inc_itmbat表rowid
/// Creater:	Zhouyg
/// CreateDate:	20110630
/// Input:		Inclb-inc_itmlcbt表RowID
/// Output:		Return
/// Return：	inc_itmbat表rowid
ClassMethod GetIncib(Inclb As %String) As %String
{
 q:Inclb="" ""
 s InciID=$p(Inclb,"||",1)
 s ILSub=$p(Inclb,"||",2)
 s LBSub=$p(Inclb,"||",3)
 q:InciID="" ""
 q:ILSub="" ""
 q:LBSub="" ""
 s Incib=$p($g(^INCI(InciID,"IL",ILSub,"LB",LBSub)),"^",1)
 q Incib
}

/// Descript:	根据医嘱项RowID取库存项ID
/// Creater:	Zhouyg
/// CreateDate:	20130301
/// Input:		医嘱项RowID
/// Return：	库存项ID
ClassMethod GetInciID(ArcID As %String) As %String
{
 Q:ArcID="" ""
 s ArcIDM=$p(ArcID,"||",1)
 q:ArcIDM="" ""
 S IncID=$o(^INCI(0,"ARCIM_DR",ArcIDM,""))
 Q IncID
}

/// Descript:	根据库存项ID取库存项别名
/// Creater:	Zhouyg
/// CreateDate:	20130301
/// Input:		库存项RowID
/// Return:		库存项别名字符串,用逗号分隔
ClassMethod GetAliasByInci(IncID As %String) As %String
{
 s incadr="",incatext=""
 f  s incadr=$o(^INCALIAS(0,"INCI",IncID,incadr)) q:incadr=""  d
 .i incatext="" d 
 ..s incatext=$p(^INCALIAS(incadr),"^",4)
 .e  d 
 ..s tmptext=$p(^INCALIAS(incadr),"^",4)
 ..i $f(incatext,tmptext)=0 d
 ...s incatext=incatext_","_tmptext
 q incatext
}

/// Descript:	取药品或材料的基础信息
/// Creater:	Zhouyg
/// CreateDate:	2013-03-01
/// Input:		IncID(INCI_Itm表ID),ArcID(Arc_ItmMast表ID),gFlag(0-全部,1-药学项信息,2-医嘱项信息,3-库存项信息)
/// 			IncID和ArcID至少有一个不为空值，医嘱项信息暂时没有提供
/// Return：	ResStr= //最好改成user对象，方便字段的扩展
ClassMethod GetItmBaseInfo(IncID As %String, ArcID As %String, gFlag As %String) As %String
{
	q:(IncID="")&(ArcID="") ""
	i IncID="" d
	.s IncID=..GetInciID(ArcID)
	.s PhcID=##Class(web.DHCSTCOMMPHC).GetPhcdfByArcim(ArcID)
	e  d
	.s ArcID=##Class(web.DHCSTCOMMARC).GetArcim(IncID)
	.s PhcID=##Class(web.DHCSTCOMMPHC).GetPhcdfByArcim(ArcID)
	//
	s (incStr,incAddStr,PhcStr)=""
	i (gFlag=0)!(gFlag=3) d
	.s incStr=..GetIncItmInfo(IncID)	//库存项信息
	.s incAddStr=..GetIncAddInfo(IncID)	//库存项附加信息
	i (gFlag=0)!(gFlag=1) d
	.s PhcStr=##Class(web.DHCSTCOMMPHC).GetPhcInfo(PhcID)
	i (gFlag=0)!(gFlag=2) d
	.s ArcStr=##Class(web.DHCSTCOMMARC).GetArcInfo(ArcID)	//此方法未完成，暂不能用
	s ExtStr=""
	//RetStr的赋值不能修改，如果有扩展字段都赋值到ExtStr变量，连接到RetStr后面
	s $p(RetStr,"^",1,15)=$p(incStr,"^",1,15)	//库存项基本信息，参见GetIncItmInfo方法说明
	s $p(RetStr,"^",16,67)=$p(incAddStr,"^",1,52)	//库存项附加信息，参见GetIncAddInfo方法说明
	s $p(RetStr,"^",68,105)=$p(PhcStr,"^",1,38)	//药学项基本信息，参见GetPhcInfo方法说明
	//s RetStr=$p(incStr,"^",15)_"^"_$p(incAddStr,"^",52)_"^"_$p(PhcStr,"^",38)_"^"_$p(ArcStr,"^",52)_"^"_ExtStr
	q RetStr
}

/// Descript:	取药品或材料的库存项信息
/// Creater:	Zhouyg
/// CreateDate:	2013-03-01
/// Input:		IncID(INCI_Itm表ID)
/// Return：	ResStr=
/// 			1库存项rowid^2库存项代码^3库存项描述^4基本单位描述^5入库单位描述
/// 			6类组类型^7类组描述^8库存类别^9规格^10别名
/// 			11作废标记^12用户代码^13用户名称^14库存项更新日期^15库存项更新时间 
/// Others:     w ##class(web.DHCSTCOMINC).GetIncItmInfo(5)
ClassMethod GetIncItmInfo(IncID As %String) As %String
{
	q:IncID="" ""
	q:'$d(^INCI(IncID,1)) ""
	s IncCode=$p(^INCI(IncID,1),"^",1)
	s IncDesc=$p(^INCI(IncID,1),"^",2)
	s IncBuomID=$p(^INCI(IncID,1),"^",10)
	s IncPuomID=$p(^INCI(IncID,3),"^",6)
	s IncscID=$p(^INCI(IncID,2),"^",2)
	s IncNotUseFlag=$p(^INCI(IncID,2),"^",9)
	s IncUpDate=$p(^INCI(IncID,3),"^",1)
	s IncUpTime=$p(^INCI(IncID,3),"^",2)
	s IncUpUserID=$p(^INCI(IncID,3),"^",3)
	s IncBarCode=$p(^INCI(IncID,3),"^",9)
	s IncAlias=..GetAliasByInci(IncID)
	s (IncBuomDesc,IncPuomDesc,IncscDesc,IncUpUserCode,IncUpUserName)=""
	i IncBuomID'="" d
	.s IncBuomDesc=$P($g(^CT("UOM",IncBuomID)),"^",2)
	i IncPuomID'="" d
	.s IncPuomDesc=$P($g(^CT("UOM",IncPuomID)),"^",2)
	i IncscID'="" d
	.s IncscDesc=$p($g(^INC("SC",IncscID)),"^",2)
	i IncUpUserID'="" d
	.s IncUpUserCode=$p(^SSU("SSUSR",IncUpUserID),"^",1)
	.s IncUpUserName=$p(^SSU("SSUSR",IncUpUserID),"^",2)
	i IncNotUseFlag'="Y" s IncNotUseFlag="N"
	s catGrpStr=..GetIncStkCatGrp(IncID)
	s catGrpDesc=$p(catGrpStr,"^",2)
	s catGrpType=$p(catGrpStr,"^",4)
	i IncUpDate'="" s IncUpDate=$zd(IncUpDate,3)
	i IncUpTime'="" s IncUpTime=$zt(IncUpTime,1)
	s IncStr1=IncID_"^"_IncCode_"^"_IncDesc_"^"_IncBuomDesc_"^"_IncPuomDesc        
	s IncStr2=catGrpType_"^"_catGrpDesc_"^"_IncscDesc_"^"_IncBarCode_"^"_IncAlias
	s IncStr3=IncNotUseFlag_"^"_IncUpUserCode_"^"_IncUpUserName_"^"_IncUpDate_"^"_IncUpTime
	s IncStr=IncStr1_"^"_IncStr2_"^"_IncStr3
	q IncStr
}

/// Descript:	取药品或材料的库存扩展信息
/// Creater:	Zhouyg
/// CreateDate:	2013-03-01
/// Input:		IncID(INCI_Itm表ID),扩展表(DHC_ItmAddionInfo)
/// Return：	ResStr=
/// 			1rowid^2进口标志(描述)^3质量层次^4基本药物标志^5处方药分类
/// 			6临床验证用药标志^7中国药典标记^8质标编号^9国(省)别^10备注
/// 			11处方购药标志^12高值类标记^13院长签字标志^14用在患者头上^15定价类型
/// 			16最高售价^17售价确认标志^18售价确认用户姓名^19售价确认日期^20售价确认时间
/// 			21本院药品目录标志^22招标进价^23招标名称^24招标供应商名称^25招标生产商名称
/// 			26招标配送商名称27规格^28存储条件^29阳光采购(Y,N)^30招标级别代码
/// 			31库存项截止日期^32有效期长度^33物价文件号^34物价文件备案日期^35皮试标志(Y,N)
/// 			36账簿分类^37皮试备注(免试液、皮试液)^38用药说明^39TPN标志(Y,N)^40省基本药物标志(1是)
/// 				41市基本药物标志(1是)^42区县基本药物标志(1是)^43挂网标志^44药品本位码^45进药依据
/// 				46不可退药原因^47不可用原因^48厂商(后勤材料用)^49医保类别(材料用)^50高危标志(后勤材料用Y/N)
/// 				51大包装单位^52大包装转换因子
/// Others:     w ##class(web.DHCSTCOMINC).GetIncAddInfo(903)   ;罗红霉素
ClassMethod GetIncAddInfo(IncID As %String) As %String
{
	q:IncID="" ""
	q:'$d(^INCI(IncID,1)) ""
	s infoID=$o(^DHCITMINFO(0,"INCI",IncID,""))
	q:infoID="" ""
	s infoStr=$g(^DHCITMINFO(infoID))
	i $p(infoStr,"^",4)'="Y" s $p(infoStr,"^",4)="N"   ;1rowid^2进口标志^3质量层次^4国家基本药物标志^5处方药分类
	i $p(infoStr,"^",6)'="Y" s $p(infoStr,"^",6)="N"   ;6临床验证用药标志
	i $p(infoStr,"^",7)'="Y" s $p(infoStr,"^",7)="N"   ;7中国药典标记^8质标编号^9国(省)别
	i $p(infoStr,"^",11)'="Y" s $p(infoStr,"^",11)="N"   ;11INFO_REC
	i $p(infoStr,"^",12)'="Y" s $p(infoStr,"^",12)="N"  ;12高值类标记
	i $p(infoStr,"^",13)'="Y" s $p(infoStr,"^",13)="N"
	i $p(infoStr,"^",14)'="Y" s $p(infoStr,"^",14)="N"    ;14^15^16最高售价
	i $p(infoStr,"^",17)'="Y" s $p(infoStr,"^",17)="N"
	i $p(infoStr,"^",21)'="Y" s $p(infoStr,"^",21)="N"   ;21本院药品目录标志^22招标进价
	i $p(infoStr,"^",29)'="Y" s $p(infoStr,"^",29)="N"
	i $p(infoStr,"^",35)'="Y" s $p(infoStr,"^",35)="N"     ;35皮试标志
	i $p(infoStr,"^",39)'="Y" s $p(infoStr,"^",39)="N"
	i $p(infoStr,"^",40)'="1" d
	.s $p(infoStr,"^",40)="N"	//基本药物标志2->改为省省基本药物
	e  d
	.s $p(infoStr,"^",40)="Y"
	i $p(infoStr,"^",41)'="1" d
	.s $p(infoStr,"^",41)="N"	//省基本药物标志->改为市基本药物
	e  d
	.s $p(infoStr,"^",41)="Y"
	i $p(infoStr,"^",42)'="1" d
	.s $p(infoStr,"^",42)="N"	//省基本药物标志2->改为区县基本药物
	e  d
	.s $p(infoStr,"^",42)="Y"
	i $p(infoStr,"^",43)'="1" d
	.s $p(infoStr,"^",43)="N"	//挂网标志
	e  d
	.s $p(infoStr,"^",43)="Y"
	s MTID=$p(infoStr,"^",15)
	s AckSpUserID=$p(infoStr,"^",18)
	s PBLID=$p(infoStr,"^",23)			;23招标名称
	s PBVendID=$p(infoStr,"^",24)     ;24招标供应商DR
	s PbManfID=$p(infoStr,"^",25)	   ;25招标厂商DR
	s PbCarrierID=$p(infoStr,"^",26)   ;26招标配送商DR
	s ISCID=$p(infoStr,"^",28)     ;29阳光采购标记
	s BCID=$p(infoStr,"^",36)
	s OecActID=$p(infoStr,"^",37)
	s RRReasonID=$p(infoStr,"^",46)    ;46以后已不存在
	s NUReasonID=$p(infoStr,"^",47)
	s CLPHMNFID=$p(infoStr,"^",48)
	s CLInsuCatID=$p(infoStr,"^",49)
	s PackUomID=$p(infoStr,"^",51)
	s (MTypeDesc,AckSpUserName,PBLDesc,PbVendorDesc,PbManfDesc,PbCarrierDesc,StoreCond,BookCatDesc,OecActCode,RefRetReason,NotUseReason,CLPHMNFDesc,CLInsuCat,PackUom)=""
	i MTID'="" d
	.s MTypeDesc=$p($g(^DHCINMT(MTID)),"^",2)
	.s $p(infoStr,"^",15)=MTypeDesc     ;15定价类型
	i AckSpUserID'="" d
	.s AckSpUserName=$p($g(^SSU("SSUSR",AckSpUserID)),"^",2)
	.s $p(infoStr,"^",18)=AckSpUserName
	i PBLID'="" d
	.s PBLDesc=$p($g(^DHCPBLIST(PBLID)),"^",2)
	.s $p(infoStr,"^",23)=PBLDesc   ;23招标名称
	i PBVendID'="" d
	.s PbVendorDesc=$p($g(^APC("APCVM",PBVendID)),"^",3)
	.s $p(infoStr,"^",24)=PbVendorDesc    ;24招标供应商名称
	i PbManfID'="" d
	.s PbManfDesc=$p($g(^PHMNF(PbManfID)),"^",2)  
	.s $p(infoStr,"^",25)=PbManfDesc				;25招标生产厂商名称
	i PbCarrierID'="" d   
	.s PbCarrierDesc=$p($g(^DHCCARR(PbCarrierID)),"^",2)
	.s $p(infoStr,"^",26)=PbCarrierDesc				;26招标配送商名称^27规格
	i ISCID'="" d
	.s StoreCond=..GetOneCode(ISCID)
	.s $p(infoStr,"^",28)=StoreCond     ;28存储条件
	i BCID'="" d
	.s BookCatDesc=$p($g(^DHCSTBC(BCID)),"^",2)     
	.s $p(infoStr,"^",36)=BookCatDesc    ;36
	i OecActID'="" d
	.s OecActCode=$p($g(^OEC("ACT",OecActID)),"^",2)
	.s $p(infoStr,"^",37)=OecActCode         ;37免试液,原液^38用药说明
	i RRReasonID'="" d
	.s RefRetReason=$p($g(^DHCRFRETREASON(RRReasonID)),"^",2)
	.s $p(infoStr,"^",46)=RefRetReason      ;46不可退药原因
	i NUReasonID'="" d
	.s NotUseReason=$p($g(^DHCNUR(NUReasonID)),"^",1)
	.s $p(infoStr,"^",47)=NotUseReason      ;47不可用原因
	i CLPHMNFID'="" d
	.s CLPHMNFDesc=$p($g(^PHMNF(CLPHMNFID)),"^",2)
	.s $p(infoStr,"^",48)=CLPHMNFDesc
	i CLInsuCatID'="" d
	.s CLInsuCat=$p($g(^DHCITMIC(CLInsuCatID)),"^",2)
	.s $p(infoStr,"^",49)=CLInsuCat
	i PackUomID'="" d
	.s PackUom=$p($g(^CT("UOM",PackUomID)),"^",2)
	.s $p(infoStr,"^",51)=PackUom    ;入库单位
	q infoStr
}

/// Descript:	取储存条件的描述
/// Creater:	Zhouyg
/// CreateDate:	2013-03-01
/// Input:		ISCID(DHC_ItmStoreCond表的ID)
/// Return：	ResStr=
ClassMethod GetOneCode(ISCID As %String) As %String
{
 q:+ISCID<1 ""
 s common="常温"
 s dry="干燥"
 s seal="密封"
 s ventilate="通风"
 s dark="遮光"
 s coolgloomy="阴凉"
 s coldst="冷藏"
 s airtight="密闭"
 s gloomycool="凉暗"
 s radiation="防辐射"
 s meltpack="熔封"
 s retcode=""
 i $d(^DHCItemSC(ISCID)) d
 .i $p(^DHCItemSC(ISCID),"^",1)="Y" s retcode=retcode_common
 .i $p(^DHCItemSC(ISCID),"^",4)="Y" s retcode=retcode_dry
 .i $p(^DHCItemSC(ISCID),"^",7)="Y" s retcode=retcode_ventilate
 .i $p(^DHCItemSC(ISCID),"^",8)="Y" s retcode=retcode_airtight
 .i $p(^DHCItemSC(ISCID),"^",9)="Y" s retcode=retcode_dark
 .i $p(^DHCItemSC(ISCID),"^",10)="Y" s retcode=retcode_radiation
 .i $p(^DHCItemSC(ISCID),"^",11)="Y" s retcode=retcode_coldst
 .i $p(^DHCItemSC(ISCID),"^",12)="Y" s retcode=retcode_coolgloomy
 .i $p(^DHCItemSC(ISCID),"^",13)="Y" s retcode=retcode_gloomycool
 .i $p(^DHCItemSC(ISCID),"^",14)="Y" s retcode=retcode_meltpack
 .i $p(^DHCItemSC(ISCID),"^",15)="Y" s retcode=retcode_seal
 q retcode
}

/// Descript:	根据库存项ID和医院取本院最后一个批次
/// Creater:	Zhouyg
/// CreateDate:	20141201
/// Input:		InciDr-inci_rowid,HospID,日期
/// Return：	批次ID(INC_ItmBat的ID)
ClassMethod GetLastIncib(InciDr As %String, HospID As %String = "", dah As %String = "") As %String
{
 Q:InciDr="" ""
 s RetIncib="",BakIncib=""
 i HospID="" d
 .s ibSub=""
 .f  s ibSub=$o(^INCI(InciDr,"IB",ibSub),-1) q:(+ibSub=0)!(RetIncib'="")  d
 ..s INCIB=InciDr_"||"_ibSub
 ..s BakIncib=INCIB
 ..s IBAddDate=0
 ..s dhcIB=$o(^DHCINCIB(0,"INCIB",INCIB,""))
 ..i dhcIB'="" s IBAddDate=$p(^DHCINCIB(dhcIB),"^",10)
 ..q:(dah'="")&(IBAddDate>dah)
 ..s RetIncib=INCIB
 e  d
 .s ibSub=""
 .f  s ibSub=$o(^INCI(InciDr,"IB",ibSub),-1) q:(+ibSub=0)!(RetIncib'="")  d
 ..s INCIB=InciDr_"||"_ibSub
 ..s BakIncib=INCIB
 ..s IBAddDate=0
 ..s dhcIB=$o(^DHCINCIB(0,"INCIB",INCIB,""))
 ..i dhcIB'="" s IBAddDate=$p(^DHCINCIB(dhcIB),"^",10)
 ..q:(dah'="")&(IBAddDate>dah)
 ..s ilSub=""
 ..f  s ilSub=$o(^INCI("LB_IB",INCIB,InciDr,ilSub)) q:(ilSub="")!(RetIncib'="")  d
 ...s locID=$p($g(^INCI(InciDr,"IL",ilSub)),"^",1)
 ...q:locID=""
 ...s ilHosp=$p(^CTLOC(locID),"^",22)
 ...q:(HospID'=ilHosp)
 ...s RetIncib=INCIB
 i RetIncib="" s RetIncib=BakIncib
 q RetIncib
}

/// Descript:	根据科室库存项ID取科室最后一个批次
/// Creater:	Zhouyg
/// CreateDate:	20141224
/// Input:		IncilDr-inc_itmloc
/// Return：	批次ID(INC_ItmLcBt的ID)
ClassMethod GetLastInclbByLoc(IncilDr As %String) As %String
{
 Q:IncilDr="" ""
 s RetInclb=""
 ////2015-11-16 ws
 s InciDr=$p(IncilDr,"||",1)
 s ILSub=$p(IncilDr,"||",2)
 q:(InciDr="")||(ILSub="") ""
 s ILBSub=""
 f  s ILBSub=$o(^INCI(InciDr,"IL",ILSub,"LB",ILBSub),-1) q:(+ILBSub=0)||(RetInclb'="")  d
 .s inclb=InciDr_"||"_ILSub_"||"_ILBSub
 .s active=""
 .s dhcinclb=$o(^DHCINCLB(0,"LB",inclb,""))
 .i dhcinclb'="" d
 ..s active=$p($g(^DHCINCLB(dhcinclb)),"^",2)
 .q:active'="Y"
 .s RetInclb=inclb
 i RetInclb="" d
 .s ILBSub=$o(^INCI(InciDr,"IL",ILSub,"LB",""),-1)
 .s RetInclb=InciDr_"||"_ILSub_"||"_ILBSub
 q RetInclb
}

/// Descript:	根据库存项ID取DrgForm的ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-库存项RowID
/// Output:		Return
/// Return：	PHC_DrgForm的ID
ClassMethod GetPhcdf(InciDr As %String) As %String
{
 S ArcimDr=..GetArcim(InciDr)
 Q:ArcimDr="" ""
 S Phcdf=..GetPhcdfByArcim(ArcimDr)
 Q Phcdf
}

/// Descript:	根据库存项ID取医嘱项ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	医嘱项ID
ClassMethod GetArcim(InciDr) As %String
{
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S ArcimDr=$P(^INCI(InciDr,1),"^",3)
 S Arcsub=$P(ArcimDr,"||",1)
 S Arcver=$P(ArcimDr,"||",2)
 Q:Arcsub="" ""
 Q:Arcver="" ""
 Q:'$D(^ARCIM(Arcsub,Arcver)) ""
 Q Arcsub_"||"_Arcver
}

/// Descript:	根据医嘱项ID取DrgForm的ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		ArcimDr-Arc_ItmMast的RowID
/// Output:		Return
/// Return：	PHC_DrgForm的ID
ClassMethod GetPhcdfByArcim(ArcimDr As %String) As %String
{
 Q:ArcimDr="" ""
 S Arcsub=$P(ArcimDr,"||",1)
 S Arcver=$P(ArcimDr,"||",2)
 Q:Arcsub="" ""
 Q:Arcver="" ""
 Q:'$D(^ARCIM(Arcsub,Arcver)) ""
 S Phcdf=$P(^ARCIM(Arcsub,Arcver,1),"^",12)
 Q Phcdf
}

}
