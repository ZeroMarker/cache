Import sqluser

/// Description:消毒包公共使用方法
/// Creator:
/// CreatDate:2020-01-7
/// 消毒包公共使用方法
Class web.CSSDHUI.Common.PackageInfoCommon Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Description:根据包属性Code获取对应描述
/// Creator:ban
/// CreatDate:2020-01-7
/// Input:包属性code
/// OutPut:包属性描述
ClassMethod GetPackageDetailDesc(AttributeCode As %String) As %String
{
	n (AttributeCode,%session)
	q:AttributeCode=1 ..%Translate($CLASSNAME(),"标牌追溯包")
	q:AttributeCode=2 ..%Translate($CLASSNAME(),"普通循环包")
	q:AttributeCode=7 ..%Translate($CLASSNAME(),"非循环包")
	
	q:AttributeCode=3 ..%Translate($CLASSNAME(),"清洗架")
	q:AttributeCode=6 ..%Translate($CLASSNAME(),"灭菌架")
	
	;q:AttributeCode=4 ..%Translate($CLASSNAME(),"清洗车")
	;q:AttributeCode=5 ..%Translate($CLASSNAME(),"灭菌筐")
	;q:AttributeCode=8 ..%Translate($CLASSNAME(),"一次性")
	;q:AttributeCode=9 ..%Translate($CLASSNAME(),"急救包")
	;q:AttributeCode=10 ..%Translate($CLASSNAME(),"专科器械包")
	
	q ..%Translate($CLASSNAME(),"其他")
}

/// Description:根据包属性描述获取对应Code
/// Creator:ban
/// CreatDate:2020-03-04
/// Input:包属性描述
/// OutPut:包属性Code
ClassMethod getPackageDetailDr(PackTypeDetailDesc As %String) As %String
{
	n (PackTypeDetailDesc,%session)
	q:PackTypeDetailDesc=..%Translate($CLASSNAME(),"标牌追溯包") 1
	q:PackTypeDetailDesc=..%Translate($CLASSNAME(),"普通循环包") 2
	q:PackTypeDetailDesc=..%Translate($CLASSNAME(),"非循环包") 7
	
	q:PackTypeDetailDesc=..%Translate($CLASSNAME(),"清洗架") 3
	q:PackTypeDetailDesc=..%Translate($CLASSNAME(),"灭菌架") 6
	
	;q:PackTypeDetailDesc=..%Translate($CLASSNAME(),"清洗车") 4
	;q:PackTypeDetailDesc=..%Translate($CLASSNAME(),"灭菌筐") 5
	;q:PackTypeDetailDesc=..%Translate($CLASSNAME(),"一次性") 8
	;q:PackTypeDetailDesc=..%Translate($CLASSNAME(),"急救包") 9
	;q:PackTypeDetailDesc=..%Translate($CLASSNAME(),"专科器械包") 10
	
	q ""
}

/// Description:根据厂商类型Code获取对应类型描述
/// Creator:ban
/// CreatDate:2021-10-28
/// Input:厂商类型Code
/// OutPut:厂商类型描述
ClassMethod getMachineType(MachineType As %String) As %String
{
	n (MachineType,%session)
	q:MachineType="WL" ..%Translate($CLASSNAME(),"外来厂商")
	q:MachineType="SW" ..%Translate($CLASSNAME(),"机器厂商")	//S代表灭菌器 W代表清洗机
	q ..%Translate($CLASSNAME(),"其他")
}

/// Description:根据消毒包Id获取效期长度
/// Creator:ban
/// CreatDate:2020-01-7
/// Input:消毒包id
/// OutPut:效期长度
ClassMethod GetExpireLength(pkgdr As %String)
{
	n (pkgdr)
	q:pkgdr="" ""
	
	s pkgExpireId =$o(^User.CSSDExpireI("IndexCSSDEXPackage",pkgdr,""))
	q:pkgExpireId="" ""
	
	s pkgExpire=##Class(User.CSSDExpire).%OpenId(pkgExpireId)
	s length=pkgExpire.CSSDEXLength
	q length
}

/// Description:依据类型Code获取申请单类型描述
/// Creator:
/// CreatDate:2020-01-7
/// Input:类型Code
/// OutPut:类型描述
ClassMethod getReqTypeDesc(rowId As %String) As %String
{
	n (rowId,%session)
	q:rowId=0 ..%Translate($CLASSNAME(),"回收申请单")
	q:rowId=1 ..%Translate($CLASSNAME(),"借包单")
	q:rowId=2 ..%Translate($CLASSNAME(),"非循环包申请单")
	q:rowId=4 ..%Translate($CLASSNAME(),"归还单")
	;q:rowId=5 ..%Translate($CLASSNAME(),"手术申请单")
	q ""
}

/// Description:依据Code获取紧急程度描述
/// Creator:
/// CreatDate:2020-01-7
/// Input:程度Code
/// OutPut:紧急程度描述
ClassMethod getReqLevelDesc(rowId As %String) As %String
{
	n (rowId,%session)
	q:rowId=0 ..%Translate($CLASSNAME(),"一般")
	q:rowId=1 ..%Translate($CLASSNAME(),"紧急")
	q ""
}

/// Description:依据Code获取申请单状态描述
/// Creator:
/// CreatDate:2020-01-7
/// Input:状态Code
/// OutPut:状态描述
ClassMethod getReqStatueDesc(rowId As %String) As %String
{
	n (rowId,%session)
	q:rowId=0 ..%Translate($CLASSNAME(),"未提交")
	q:rowId=1 ..%Translate($CLASSNAME(),"提交")
	q:rowId=2 ..%Translate($CLASSNAME(),"回收")
	q:rowId=3 ..%Translate($CLASSNAME(),"发放")
	q:rowId=4 ..%Translate($CLASSNAME(),"全部")
	q:rowId=5 ..%Translate($CLASSNAME(),"确认")
	q:rowId=6 ..%Translate($CLASSNAME(),"接收")
	q:rowId=7 ..%Translate($CLASSNAME(),"归还")
	q:rowId=8 ..%Translate($CLASSNAME(),"拒绝")
	q ""
}

/// Description:依据标签状态Code获取对应描述
/// Creator:
/// CreatDate:2020-01-7
/// Input:状态Code
/// OutPut:状态描述
ClassMethod GetStatusChinese(state As %String)
{
	n (state,%session)
	i state="B" d
	.s state=..%Translate($CLASSNAME(),"登记")
	e  i state="W" d
	.s state=..%Translate($CLASSNAME(),"已清洗")
	e  i state="P" d
	.s state=..%Translate($CLASSNAME(),"已配包") 
	e  i state="S" d
	.s state=..%Translate($CLASSNAME(),"已灭菌")
	e  i state="D" d
	.s state=..%Translate($CLASSNAME(),"已发放")
	e  i state="R" d
	.s state=..%Translate($CLASSNAME(),"已接收")
	e  i state="U" d
	.s state=..%Translate($CLASSNAME(),"已使用")
	e  i state="C" d
	.s state=..%Translate($CLASSNAME(),"已回收" )
	e  i state="SW" d
	.s state=..%Translate($CLASSNAME(),"二次清洗")
	e  i state="SS" d
	.s state=..%Translate($CLASSNAME(),"高水平消毒")
	e  i state="TC" d
	.s state=..%Translate($CLASSNAME(),"已过期处理")
	e  i state="RC" d
	.s state=..%Translate($CLASSNAME(),"已召回处理")
	e  i state="SP" d
	.s state=..%Translate($CLASSNAME(),"灭菌中")
	e  i state="T" d
	.s state=..%Translate($CLASSNAME(),"移交")
	e  i state="G" d
	.s state=..%Translate($CLASSNAME(),"已领用")
	q state
}

/// Description:依据标签/标牌获取对应标牌名称
/// Creator:
/// CreatDate:2020-01-7
/// Input:标签/标牌
/// OutPut:标牌名称
ClassMethod GetCodeDictName(label As %String) As %String
{
	n (label,%session)
	q:label="" ""
	
	s fixlabel=..GetFixedLabel(label)
	q:fixlabel="" ""
	
	s CodeDictId =$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",fixlabel,""))
	s CodeDictObj=##Class(User.CSSDCodeDict).%OpenId(CodeDictId)
	q:'$IsObject(CodeDictObj) ""
	
	s pkgname=CodeDictObj.CSSDCDPackName
	s pkgname=..%FieldTranslate("User.CSSDCodeDict","CSSDCDPackName",pkgname)
	q pkgname
}

/// Description:依据科室id获取科室描述
/// Creator:
/// CreatDate:2021-04-7
/// Input:科室id
/// OutPut:科室描述
ClassMethod GetLocName(locDr As %String) As %String
{
	n (locDr)
	q:locDr="" ""
	
	s locinfo=$g(^CTLOC(locDr))
	q:locinfo="" ""
	
	s locName=$p(^CTLOC(locDr),"^",2)
	q locName
}

/// Description:依据标签/标牌获取标牌绑定科室描述
/// Creator:
/// CreatDate:2020-01-7
/// Input:标签/标牌
/// OutPut:科室描述
ClassMethod GetCodeDictBindLocName(label As %String) As %String
{
	n (label,%session)
	q:label="" ""
	
	s fixlabel=..GetFixedLabel(label)
	q:fixlabel="" ""
	
	s CodeDictId =$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",fixlabel,""))
	s CodeDictObj=##Class(User.CSSDCodeDict).%OpenId(CodeDictId)
	q:'$IsObject(CodeDictObj) ""
	
	s LocObj=CodeDictObj.CSSDCDOPRLocID
	q:'$IsObject(LocObj) ""
	
	s locId = LocObj.%Id()
	s deptName=..sssLocDesc(locId)
	q deptName
}

/// Description:依据消毒包id获取消毒包绑定科室描述
/// Creator:zn
/// CreatDate:2021-12-02
/// Input:消毒包id
/// OutPut:科室描述
ClassMethod GetPackageBindLocName(pkgdr As %String) As %String
{
	n (pkgdr,%session)
	q:pkgdr="" ""
	
	s PackageObj=##Class(User.CSSDPackage).%OpenId(pkgdr)
	q:'$IsObject(PackageObj) ""
	
	s LocObj=PackageObj.CSSDPLOCDR
	q:'$IsObject(LocObj) ""
	
	s locId = LocObj.%Id()
	s deptName=..sssLocDesc(locId)
	q deptName
}

/// Description:依据材料id和消毒包id获取效期长度
/// Creator:why
/// CreatDate:2021-01-7
/// Input:材料id，消毒包id
/// OutPut:效期长度
ClassMethod GetMaterialExpireLength(MaterialDr As %String, pkgdr As %String)
{
	n (MaterialDr,pkgdr)
	q:((pkgdr="")||(MaterialDr="")) ""
	
	s pkgExpireId =$o(^User.CSSDExpireI("IndexCSSDEXPackageMat",pkgdr,MaterialDr,""))
	q:pkgExpireId="" ""
	
	s pkgExpire=##Class(User.CSSDExpire).%OpenId(pkgExpireId)
	q:'$IsObject(pkgExpire) ""
	
	s length=pkgExpire.CSSDEXLength
	s Price=pkgExpire.CSSDEXPrice
	i length="" s length=0
	i Price="" s Price=0
	
	s ret=length_"^"_Price
	q ret
}

/// Description:依据消毒包id获取默认包装材料id
/// Creator:ban
/// CreatDate:2021-01-7
/// Input:消毒包id
/// OutPut:包装材料id
ClassMethod GetDefaultMaterial(pkgdr As %String)
{
	n (pkgdr)
	q:pkgdr="" ""
	
	s pkgExpireId =$o(^User.CSSDExpireI("IndexCSSDEXPkgIsDefault",pkgdr,"Y",""))
	q:pkgExpireId="" ""
	
	s pkgExpire=##Class(User.CSSDExpire).%OpenId(pkgExpireId)
	q:'$IsObject(pkgExpire) ""
	
	s MaterialDr=pkgExpire.CSSDEXMaterialDrGetObjectId()
	q MaterialDr
}

/// Description:依据标签获取标牌
/// Creator:WangNing
/// CreatDate:2022-4-18
/// Input:标签
/// OutPut:标牌
ClassMethod GetFixedLabel(Label As %String) As %String
{
	n (Label)
	s CodeDictId=$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",Label,""))
	q:CodeDictId'="" Label
	
	s FixedLabel=""
	s PackId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
	i PackId'="" d
	.s CodeDictId=$lg(^User.CSSDPackagePackD(PackId),28)
	.s:CodeDictId'="" FixedLabel=$lg(^User.CSSDCodeDictD(CodeDictId),2)
	
	q FixedLabel
}

/// Description:依据标签或标牌获取标牌相关信息
/// Creator:MY
/// CreatDate:2022-7-4
/// Input:标签/标牌
/// OutPut:FixedLabel^PackTypeDetail^PackageId^UseFlag
/// 标牌^包属性^消毒包id^标牌可用标志
ClassMethod GetLabel(Label As %String) As %String
{
	n (Label)
	s FixedLabel="",PackTypeDetail="",PackageId="",UseFlag="Y"
	
	s CodeDictId=$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",Label,""))
	i CodeDictId'="" d
	.s PackageId=$lg(^User.CSSDCodeDictD(CodeDictId),5)
	.s UseFlag=$lg(^User.CSSDCodeDictD(CodeDictId),17)
	.s PackTypeDetail=$lg(^User.CSSDPackageD(PackageId),15)
	.s FixedLabel=Label
	
	i FixedLabel="" d
	.s PackId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
	.i PackId'="" d
	..s CodeDictId=$lg(^User.CSSDPackagePackD(PackId),28)
	..i CodeDictId'="" d
	...s FixedLabel=$lg(^User.CSSDCodeDictD(CodeDictId),2)
	...s PackageId=$lg(^User.CSSDCodeDictD(CodeDictId),5)
	...s UseFlag=$lg(^User.CSSDCodeDictD(CodeDictId),17)
	...s PackTypeDetail=$lg(^User.CSSDPackageD(PackageId),15)

	i FixedLabel="" d
	.s PackageId=$o(^User.CSSDPackageI("CSSDPackageCodeIndex",Label,""))
	.i PackageId'="" d
	..s PackTypeDetail=$lg(^User.CSSDPackageD(PackageId),15)
	.e  d
	..s PackId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
	..i PackId'="" d
	...s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	...s PackageId=PackObj.CSSDPPPackage.%Id()
	...s PackTypeDetail=PackObj.CSSDPPPackage.CSSDPPackTypeDetail
	.i (PackageId'="")&&((PackTypeDetail=2)||(PackTypeDetail=10)) s FixedLabel=Label
	
	q FixedLabel_"^"_PackTypeDetail_"^"_PackageId_"^"_UseFlag
}

/// Description:依据检查状态Code获取检查状态描述
/// Creator:
/// CreatDate:
/// Input:状态Code
/// OutPut:状态描述
ClassMethod GetSpecialDisease(Status As %String)
{
	n (Status,%session)
	i Status="N" d
	.s Status=..%Translate($CLASSNAME(),"未知")
	e  i Status="-" d
	.s Status=..%Translate($CLASSNAME(),"阴性")
	e  i Status="+" d
	.s Status=..%Translate($CLASSNAME(),"阳性")
	e  i Status="UR" d
	.s Status=..%Translate($CLASSNAME(),"已查未归")
	e  d
	.s Status=""
	q Status
}

/// Description:依据标牌获取相关信息
/// Creator:
/// CreatDate:
/// Input:标牌
/// OutPut:PackageId^PackTypeDetail^PkgClassdr^CodeDictId^CodeDictUseFlag
/// 消毒包id^包属性code^包分类id^标牌id^可用标志
ClassMethod GetPkgInfoByCodeDict(CodeDictLabel As %String) As %String
{
	n (CodeDictLabel)
	q:CodeDictLabel="" ""
	
	s (PackageId,PackTypeDetail,PkgClassdr,CodeDictObj,CodeDictUseFlag,IsExt)=""
	s CodeDictId=$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",CodeDictLabel,""))
	i CodeDictId'="" d
	.s CodeDictObj=##class(User.CSSDCodeDict).%OpenId(CodeDictId)
	.d CodeDictObj.%Reload()
	.q:'$IsObject(CodeDictObj)
	.s PackageObj=CodeDictObj.CSSDCDPackDR
	.s PackTypeDetail=PackageObj.CSSDPPackTypeDetail
	.s PackageId=PackageObj.%Id()
	.s PkgClassdr=PackageObj.CSSDPPackClass.%Id()
	.s CodeDictUseFlag=CodeDictObj.CSSDCDNotUseFlag
	.s IsExt=PackageObj.CSSDPIsExt
	
	q PackageId_"^"_PackTypeDetail_"^"_PkgClassdr_"^"_CodeDictId_"^"_CodeDictUseFlag_"^"_IsExt
}

/// Description:依据消毒包id获取关联器械数
/// Creator:ban
/// CreatDate:2022-11-11
/// Input:消毒包id
/// OutPut:总器械数
ClassMethod GetItmQtyByPkgId(PkgId As %String)
{
	n (PkgId)
	s SumQty=0
	s PkgItmId=""
	f  s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PkgId,PkgItmId)) q:PkgItmId=""  d
	.s PkgItmInfo=##Class(User.CSSDPackageItem).%OpenId(PkgItmId)
	.s Qty=PkgItmInfo.CSSDPIQty
	.s SumQty=SumQty+Qty
	q SumQty
}

/// Description:依据消毒包id获取外来器械标志
/// Creator:lxt
/// CreatDate:2022-12-15
/// Input:消毒包id
/// OutPut:W-外来器械，其他-非外来器械
ClassMethod GetExtFlag(PkgId As %String) As %String
{
	n (PkgId,%session)
	q:PkgId="" ""
	
	s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
	d PkgObj.%Reload()
	s IsExt=PkgObj.CSSDPIsExt
	i IsExt="" s IsExt="N"
	q IsExt
}

/// Description:依据线路id获取科室id串
/// Creator:ljl
/// CreatDate:2022-12-14
/// Input:线路id
/// OutPut:科室id串
ClassMethod GetLocByLine(LineMainId) As %String
{
	n (LineMainId)
	q:LineMainId="" ""
	
	s LineDetailId="",LinLocDesc="",str=""
	f  s LineDetailId=$o(^User.CSSDSendRoadLineDetailI("IndexRoadLineDR",LineMainId,LineDetailId))  q:(LineDetailId="")  d
	.s LineDetailObj=##Class(User.CSSDSendRoadLineDetail).%OpenId(LineDetailId)
	.d LineDetailObj.%Reload()
	.q:'$IsObject(LineDetailObj)
	.s LineLocId=LineDetailObj.CSSDSRLDLocDRGetObjectId()
	.i str'="" d
	..s str=str_"^"_LineLocId
	.e  d
	..s str="^"_LineLocId
	s str=str_"^"
	
	q str
}

}
