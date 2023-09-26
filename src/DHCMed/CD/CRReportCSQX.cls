/// 名称: DHCMed.CD.CRReportCSQX
/// 描述: 出生缺陷儿报告卡（产母情况基本信息在表DHCMed.CD.CRReportPAT中）
/// 编写者：zhufei
/// 编写日期: 2019-12-02
Class DHCMed.CD.CRReportCSQX Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildCSQX ];

/// 卡片编号
Property CRKPBH As %String(MAXLEN = 100, TRUNCATE = 1);

/// 产母情况-户籍类型（户籍、暂住、流动）("CDCSQXHJLX")
Property CRHJLXDr As DHCMed.SS.Dictionary;

/// 产母情况-孕次
Property CRYC As %Integer;

/// 产母情况-产次
Property CRCC As %Integer;

/// 产母情况-是否婚检
Property CRIsHJ As %Boolean;

/// 产母情况-居住地所属区
Property CRJZDSSQ As %String(MAXLEN = 100, TRUNCATE = 1);

/// 产母情况-居住时间
Property CRJZSJ As %Integer;

/// 产母情况-是否辅助生殖
Property CRIsFZSZ As %Boolean;

/// 产母情况-家庭年人均收入（元）("CDCSQXJTNRJSR")
Property CRJTNRJSRDr As DHCMed.SS.Dictionary;

/// 缺陷儿情况-出生日期
Property CRCSRQ As %Date;

/// 缺陷儿情况-出生医院
Property CRCSYY As %String(MAXLEN = 100, TRUNCATE = 1);

/// 缺陷儿情况-胎龄*周
Property CRTL As %Integer;

/// 缺陷儿情况-体重*克
Property CRTZ As %Integer;

/// 缺陷儿情况-身长*cm
Property CRSC As %Integer;

/// 缺陷儿情况-畸形数
Property CRJXS As %Integer;

/// 缺陷儿情况-胎数（单胎、双胎、多胎）("CDCSQXTS")
Property CRTSDr As DHCMed.SS.Dictionary;

/// 缺陷儿情况-若双胎或多胎，请选（同卵、异卵）("CDCSQXTLYL")
Property CRTLYLDr As DHCMed.SS.Dictionary;

/// 缺陷儿情况-性别（男、女、不明）("CDCSQXXB")
Property CRXBDr As DHCMed.SS.Dictionary;

/// 缺陷儿情况-转归（活产、死胎、死产、七天内死亡）("CDCSQXZG")
Property CRZGDr As DHCMed.SS.Dictionary;

/// 缺陷儿情况-诊断为出生缺陷后治疗性引产（是、否）
Property CRIsZLXYC As %Boolean;

/// 缺陷儿情况-诊断依据（临床、影像学检查、实验室检查、尸解、其他）
Property CRZDYJDr As DHCMed.SS.Dictionary;

/// 缺陷儿情况-诊断依据备注
Property CRZDYJTxt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 缺陷儿情况-畸形确诊时间（产前、产后7天内、产后7天后）("CDCSQXJXQZSJ")
Property CRJXQZSJDr As DHCMed.SS.Dictionary;

/// 缺陷儿情况-产前诊断孕周*周
Property CRCQZDYZ As %Integer;

/// 缺陷儿情况-产前诊断医院
Property CRCQZDYY As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生缺陷诊断("CDCSQXZD")
Property CRZDDr As DHCMed.SS.Dictionary;

/// 出生缺陷诊断（左、右）("CDCSQXZDZY")
Property CRZDZYDr As DHCMed.SS.Dictionary;

/// 出生缺陷诊断 尿道下列类型
Property CRZDNDXL As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生缺陷诊断 先天性心脏病类型（室缺、房缺、...）("CDCSQXZDXTXZXB")
Property CRZDXTXXZBDr As DHCMed.SS.Dictionary;

/// 出生缺陷诊断 胎儿水肿综合征 是否确诊为*型（中重度）地中海贫血("CDCSQXZDDZHPX")
Property CRZDDZHPXLXDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生缺陷诊断 其他 写明病名或详细描述
Property CRZDTxt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 孕早期情况 患病 发热（>38度）
Property CRYZQHBFR As %String(MAXLEN = 100, TRUNCATE = 1);

/// 孕早期情况 患病 病毒感染类型
Property CRYZQHBBDGR As %String(MAXLEN = 100, TRUNCATE = 1);

/// 孕早期情况 患病 糖尿病
Property CRYZQHBTNB As %String(MAXLEN = 100, TRUNCATE = 1);

/// 孕早期情况 患病 其他
Property CRYZQHBTxt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 孕早期情况 服药 磺胺类名称
Property CRYZQFYHAL As %String(MAXLEN = 100, TRUNCATE = 1);

/// 孕早期情况 服药 抗生素名称
Property CRYZQFYKSS As %String(MAXLEN = 100, TRUNCATE = 1);

/// 孕早期情况 服药 避孕药名称
Property CRYZQFYBYY As %String(MAXLEN = 100, TRUNCATE = 1);

/// 孕早期情况 服药 镇静药名称
Property CRYZQFYZJY As %String(MAXLEN = 100, TRUNCATE = 1);

/// 孕早期情况 服药 其他
Property CRYZQFYTxt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 孕早期情况 其他有害因素 饮酒剂量
Property CRYZQQTYJ As %String(MAXLEN = 100, TRUNCATE = 1);

/// 孕早期情况 其他有害因素 农药名称
Property CRYZQQTNY As %String(MAXLEN = 100, TRUNCATE = 1);

/// 孕早期情况 其他有害因素 射线种类
Property CRYZQQTSX As %String(MAXLEN = 100, TRUNCATE = 1);

/// 孕早期情况 其他有害因素 化学制剂名称
Property CRYZQQTHXZJ As %String(MAXLEN = 100, TRUNCATE = 1);

/// 孕早期情况 其他有害因素 其他（吸烟 劳累 压力）
Property CRYZQQTTxt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 家族史 产妇异常生育史（死胎、自然流产、缺陷儿）（可多选 逗号分隔）("CDCSQXYCSYS")
Property CRJZSYYCSYSDr As %String(MAXLEN = 200, TRUNCATE = 1);

/// 家族史 产妇异常生育史 死胎*例
Property CRJZSYST As %Integer;

/// 家族史 产妇异常生育史 自然流产*例
Property CRJZSYZRLC As %Integer;

/// 家族史 产妇异常生育史 缺陷儿*例
Property CRJZSYQXE As %Integer;

/// 家族史 产妇异常生育史 缺陷儿 缺陷名
Property CRJZSYQXM As %String(MAXLEN = 100, TRUNCATE = 1);

/// 家族史 家族遗传史 缺陷名1
Property CRJZYCQXM1 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 家族史 家族遗传史 与缺陷儿亲缘关系1
Property CRJZYCQYGX1 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 家族史 家族遗传史 缺陷名2
Property CRJZYCQXM2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 家族史 家族遗传史 与缺陷儿亲缘关系2
Property CRJZYCQYGX2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 家族史 家族遗传史 缺陷名3
Property CRJZYCQXM3 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 家族史 家族遗传史 与缺陷儿亲缘关系3
Property CRJZYCQYGX3 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 家族史 近亲婚配史（是、不是）("CDCSQXYCSYS")
Property CRJZHPIsJQ As %Boolean;

/// 家族史 近亲婚配史 关系
Property CRJZHPJQGX As %String(MAXLEN = 100, TRUNCATE = 1);

/// Creator：     zhufei
/// CreatDate：   2019-12-02
/// Description:  根据ID取出生缺陷卡信息
/// Table：       DHCMed.CD.CRReportCSQX
/// Input：       ID:    DHCMed.CD.CRReportCSQX.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportCSQX).GetObjByParRef(1)
ClassMethod GetObjByParRef(ParRef As %String) As DHCMed.CD.CRReportCSQX
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set SubID=$o(^DHCMed.CD.CRReportD(+ParRef,"CSQX",0))
	Set obj=##class(DHCMed.CD.CRReportCSQX).GetObjById(ParRef_"||"_SubID)
	set return=obj
	quit return
}

Method ToString(separete As %String) As %String
{
	
	Set return=..CRKPBH_separete
	Set return=return_..GetDicByObj(..CRHJLXDr)_separete  
	Set return=return_..CRYC_separete	
	Set return=return_..CRCC_separete
	Set return=return_..CRIsHJ_separete
	
	Set return=return_..CRJZDSSQ_separete	
	Set return=return_..CRJZSJ_separete
	Set return=return_..CRIsFZSZ_separete
	Set return=return_..GetDicByObj(..CRJTNRJSRDr)_separete  
	Set CSRQ=..CRCSRQ
	Set:CSRQ'="" CSRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CSRQ)
	Set return=return_CSRQ_separete	//13
	
	Set return=return_..CRCSYY_separete
	Set return=return_..CRTL_separete
	Set return=return_..CRTZ_separete	
	Set return=return_..CRSC_separete
	Set return=return_..CRJXS_separete
	
	Set return=return_..GetDicByObj(..CRTSDr)_separete
	Set return=return_..GetDicByObj(..CRTLYLDr)_separete
	Set return=return_..GetDicByObj(..CRXBDr)_separete	
	Set return=return_..GetDicByObj(..CRZGDr)_separete
	Set return=return_..CRIsZLXYC_separete
	
	Set return=return_..GetDicByObj(..CRZDYJDr)_separete
	Set return=return_..CRZDYJTxt_separete
	Set return=return_..GetDicByObj(..CRJXQZSJDr)_separete
	Set return=return_..CRCQZDYZ_separete
	Set return=return_..CRCQZDYY_separete
	
	Set return=return_..GetDicByObj(..CRZDDr)_separete
	Set return=return_..GetDicByObj(..CRZDZYDr)_separete
	Set return=return_..CRZDNDXL_separete
	Set return=return_..GetDicByObj(..CRZDXTXXZBDr)_separete
	Set return=return_..CRZDDZHPXLXDr_separete
	
	Set return=return_..CRZDTxt_separete
	Set return=return_..CRYZQHBFR_separete
	Set return=return_..CRYZQHBBDGR_separete
	Set return=return_..CRYZQHBTNB_separete
	Set return=return_..CRYZQHBTxt_separete

	Set return=return_..CRYZQFYHAL_separete
	Set return=return_..CRYZQFYKSS_separete
	Set return=return_..CRYZQFYBYY_separete
	Set return=return_..CRYZQFYZJY_separete
	Set return=return_..CRYZQFYTxt_separete

	Set return=return_..CRYZQQTYJ_separete
	Set return=return_..CRYZQQTNY_separete
	Set return=return_..CRYZQQTSX_separete
	Set return=return_..CRYZQQTHXZJ_separete
	Set return=return_..CRYZQQTTxt_separete
	

	Set AbnoBirthIDs  = obj.CRJZSYYCSYSDr
	Set AbnoBirthDescs= ""
	For indDic=1:1:$l(AbnoBirthIDs,",") {
		Set tDicID=$p(AbnoBirthIDs,",",indDic)
		Continue:tDicID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(tDicID)
		If $IsObject(objDic){
			If AbnoBirthDescs'="" {
				Set AbnoBirthDescs=AbnoBirthDescs_","_objDic.Description
			} Else {
				Set AbnoBirthDescs=objDic.Description
			}
		}
	}
	Set return=return_AbnoBirthIDs_separete
	Set return=return_AbnoBirthDescs_separete
	
	
	
	Set return=return_..CRJZSYST_separete
	Set return=return_..CRJZSYZRLC_separete
	Set return=return_..CRJZSYQXE_separete
	Set return=return_..CRJZSYQXM_separete
	
	Set return=return_..CRJZYCQXM1_separete
	Set return=return_..CRJZYCQYGX1_separete
	Set return=return_..CRJZYCQXM2_separete
	Set return=return_..CRJZYCQYGX2_separete
	Set return=return_..CRJZYCQXM3_separete
	Set return=return_..CRJZYCQYGX3_separete
	
	Set return=return_..CRJZHPIsJQ_separete
	Set return=return_..CRJZHPJQGX_separete
	
	
	quit return
}

ClassMethod GetDicByObj(obj As DHCMed.SS.Dictionary) As %String
{
	new (obj)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_obj.Description
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-12-02
/// Description:  根据ID取出生缺陷卡信息
/// Table：       DHCMed.CD.CRReportCSQX
/// Input：       ID:    DHCMed.CD.CRReportCSQX.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportCSQX).GetStringByParRef(13)
ClassMethod GetStringByParRef(ParRef As %String) As %String
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set obj=##class(DHCMed.CD.CRReportCSQX).GetObjByParRef(ParRef)
	if $IsObject(obj){
		set return=obj.ToString("^")
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-12-02
/// Description:  根据ID取出生缺陷卡信息
/// Table：       DHCMed.CD.CRReportCSQX
/// Input：       ID:    DHCMed.CD.CRReportCSQX.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportCSQX).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportCSQX
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportCSQX).%ExistsId(id) return
	set obj=##Class(DHCMed.CD.CRReportCSQX).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-12-02
/// Description:  更新出生缺陷卡信息
/// Table：       DHCMed.CD.CRReportCSQX
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportCSQX).Update("")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set Parref=$p(aInput,separete,1)
	Set SubID=$o(^DHCMed.CD.CRReportD(Parref,"CSQX",0))
	
	If (SubID="") {
		Set obj=##class(DHCMed.CD.CRReportCSQX).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReportCSQX).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	
	Set CardNo=$p(aInput,separete,2)		//卡片编号
	Set RegType=$p(aInput,separete,3)		//户籍类型
	Set Gestational=$p(aInput,separete,4)	//孕次
	Set Parity=$p(aInput,separete,5)		//产次
	Set IsPreExam=$p(aInput,separete,6)		//是否婚检
	
	Set Area=$p(aInput,separete,7)  		//居住所属地区
	Set AreaTime=$p(aInput,separete,8)		//居住时间
	Set IsReproduc=$p(aInput,separete,9)	//是否辅助生殖
	Set PreIncome=$p(aInput,separete,10)	//家庭年人均收入
	Set Birthday=$p(aInput,separete,11)		//出生日期
	Set BirHospital=$p(aInput,separete,12)	//出生医院
	Set GestAge=$p(aInput,separete,13)		//胎龄
	Set Weight=$p(aInput,separete,14)		//体重
	Set Length=$p(aInput,separete,15)		//身长
	Set Abnormal=$p(aInput,separete,16)		//畸形数
	Set FoetNum=$p(aInput,separete,17)		//胎数
	Set Multiple=$p(aInput,separete,18)		//同卵异卵
	Set ChildSex=$p(aInput,separete,19)		//缺陷儿性别
	Set OutCome=$p(aInput,separete,20)		//转归
	Set IsInduced=$p(aInput,separete,21)	//诊断为出生缺陷后治疗性引产
	Set DiagBasis=$p(aInput,separete,22)	//诊断依据
	Set DiagBasisDesc=$p(aInput,separete,23) //诊断备注
	Set MalfTime=$p(aInput,separete,24)		//畸形确诊时间
	Set PreWeek=$p(aInput,separete,25)		//产前诊断孕周
	Set DiagHos=$p(aInput,separete,26)		//产前诊断医院
	Set Defect=$p(aInput,separete,27)		//缺陷诊断
	Set Position=$p(aInput,separete,28)		//位置
	Set BelowUre=$p(aInput,separete,29)		//尿道下裂
	Set ChdType=$p(aInput,separete,30)		//先心病类型
	Set FeDSyndrome=$p(aInput,separete,31)	//胎儿水肿综合征
	Set OtherDef=$p(aInput,separete,32)		//其他缺陷名
	Set YZQHBFR=$p(aInput,separete,33)		//发热
	Set YZQHBBDGR=$p(aInput,separete,34)	//病毒感染类型
	Set YZQHBTNB=$p(aInput,separete,35)		//糖尿病
	Set YZQHB=$p(aInput,separete,36)		//其他
	Set YZQFYHAL=$p(aInput,separete,37)		//磺胺类药物名称
	Set YZQFYKSS=$p(aInput,separete,38)		//抗生素药物名称
	Set YZQFYBYY=$p(aInput,separete,39)		//避孕药药物名称
	Set YZQFYZJY=$p(aInput,separete,40)		//镇静药药物名称
	Set YZQFY=$p(aInput,separete,41)		//其他药物名称
	Set YZQQTYJ=$p(aInput,separete,42)		//有害因素饮酒剂量
	Set YZQQTNY=$p(aInput,separete,43)		//有害因素农药名称
	Set YZQQTSX=$p(aInput,separete,44)		//有害因素射线种类
	Set YZQQTHXZJ=$p(aInput,separete,45)	//有害因素化学制剂名称
	Set YZQQT=$p(aInput,separete,46)		//其他有害因素
	Set AbnoBirth=$p(aInput,separete,47)	//异常生育史
	Set Stillbirth=$p(aInput,separete,48)	//死胎
	Set Abortion=$p(aInput,separete,49)		//自然流产
	Set DefeChild=$p(aInput,separete,50)	//缺陷儿
	Set DefecName=$p(aInput,separete,51)	//缺陷名称
	Set FamGen1=$p(aInput,separete,52)		//家族遗传史1
	Set Relation1=$p(aInput,separete,53)	//与缺陷儿亲属关系1
	Set FamGen2=$p(aInput,separete,54)		//家族遗传史2
	Set Relation2=$p(aInput,separete,55)	//与缺陷儿亲属关系2
	Set FamGen3=$p(aInput,separete,56)		//家族遗传史3
	Set Relation3=$p(aInput,separete,57)	//与缺陷儿亲属关系3
	Set IsRelaMarry=$p(aInput,separete,58)	//是否是近亲结婚
	Set RelaMarry=$p(aInput,separete,59)	//近亲关系
	
	Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(Birthday) //出生日期格式转换
	Set obj.ParRef=##class(DHCMed.CD.CRReport).GetObjById(Parref)
	
	If (CardNo="") {
		Set CardNo=##class(DHCMed.CDService.Service).GetNewRepNo("CSQX")
	}
	Set obj.CRKPBH=CardNo
	Set obj.CRHJLXDr=##class(DHCMed.SS.Dictionary).GetObjById(RegType)
	Set obj.CRYC=Gestational
	Set obj.CRCC=Parity
	Set obj.CRIsHJ=IsPreExam
	Set obj.CRJZDSSQ=Area
	Set obj.CRJZSJ=AreaTime
	Set obj.CRIsFZSZ=IsReproduc
	Set obj.CRJTNRJSRDr=##class(DHCMed.SS.Dictionary).GetObjById(PreIncome)
	Set obj.CRCSRQ=Birthday
	Set obj.CRCSYY=BirHospital
	Set obj.CRTL=GestAge
	Set obj.CRTZ=Weight
	Set obj.CRSC=Length
	Set obj.CRJXS=Abnormal
	Set obj.CRTSDr=##class(DHCMed.SS.Dictionary).GetObjById(FoetNum)
	Set obj.CRTLYLDr=##class(DHCMed.SS.Dictionary).GetObjById(Multiple)
	Set obj.CRXBDr=##class(DHCMed.SS.Dictionary).GetObjById(ChildSex)
	Set obj.CRZGDr=##class(DHCMed.SS.Dictionary).GetObjById(OutCome)
	Set obj.CRIsZLXYC=IsInduced
	Set obj.CRZDYJDr=##class(DHCMed.SS.Dictionary).GetObjById(DiagBasis)
	Set obj.CRZDYJTxt=DiagBasisDesc
	Set obj.CRJXQZSJDr=##class(DHCMed.SS.Dictionary).GetObjById(MalfTime)
	Set obj.CRCQZDYZ=PreWeek
	Set obj.CRCQZDYY=DiagHos
	Set obj.CRZDDr=##class(DHCMed.SS.Dictionary).GetObjById(Defect)
	Set obj.CRZDZYDr=##class(DHCMed.SS.Dictionary).GetObjById(Position)
	Set obj.CRZDNDXL=BelowUre
	Set obj.CRZDXTXXZBDr=##class(DHCMed.SS.Dictionary).GetObjById(ChdType)
	Set obj.CRZDDZHPXLXDr=FeDSyndrome
	Set obj.CRZDTxt=OtherDef
	Set obj.CRYZQHBFR=YZQHBFR
	Set obj.CRYZQHBBDGR=YZQHBBDGR
	Set obj.CRYZQHBTNB=YZQHBTNB
	Set obj.CRYZQHBTxt=YZQHB
	Set obj.CRYZQFYHAL=YZQFYHAL
	Set obj.CRYZQFYKSS=YZQFYKSS
	Set obj.CRYZQFYBYY=YZQFYBYY
	Set obj.CRYZQFYZJY=YZQFYZJY
	Set obj.CRYZQFYTxt=YZQFY
	Set obj.CRYZQQTYJ=YZQQTYJ
	Set obj.CRYZQQTNY=YZQQTNY
	Set obj.CRYZQQTSX=YZQQTSX
	Set obj.CRYZQQTHXZJ=YZQQTHXZJ
	Set obj.CRYZQQTTxt=YZQQT
	Set obj.CRJZSYYCSYSDr=AbnoBirth
	Set obj.CRJZSYST=Stillbirth
	Set obj.CRJZSYZRLC=Abortion
	Set obj.CRJZSYQXE=DefeChild
	Set obj.CRJZSYQXM=DefecName
	Set obj.CRJZYCQXM1=FamGen1
	Set obj.CRJZYCQYGX1=Relation1
	Set obj.CRJZYCQXM2=FamGen2
	Set obj.CRJZYCQYGX2=Relation2
	Set obj.CRJZYCQXM3=FamGen3
	Set obj.CRJZYCQYGX3=Relation3
	Set obj.CRJZHPIsJQ=IsRelaMarry
	Set obj.CRJZHPJQGX=RelaMarry
	
	
	
	
	
	
	
	
	
	//***************增加存储字段***************
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CRKPBH</Value>
</Value>
<Value name="3">
<Value>CRHJLXDr</Value>
</Value>
<Value name="4">
<Value>CRYC</Value>
</Value>
<Value name="5">
<Value>CRCC</Value>
</Value>
<Value name="6">
<Value>CRIsHJ</Value>
</Value>
<Value name="7">
<Value>CRJZDSSQ</Value>
</Value>
<Value name="8">
<Value>CRJZSJ</Value>
</Value>
<Value name="9">
<Value>CRIsFZSZ</Value>
</Value>
<Value name="10">
<Value>CRJTNRJSRDr</Value>
</Value>
<Value name="11">
<Value>CRCSRQ</Value>
</Value>
<Value name="12">
<Value>CRCSYY</Value>
</Value>
<Value name="13">
<Value>CRTL</Value>
</Value>
<Value name="14">
<Value>CRTZ</Value>
</Value>
<Value name="15">
<Value>CRSC</Value>
</Value>
<Value name="16">
<Value>CRJXS</Value>
</Value>
<Value name="17">
<Value>CRTSDr</Value>
</Value>
<Value name="18">
<Value>CRTLYLDr</Value>
</Value>
<Value name="19">
<Value>CRXBDr</Value>
</Value>
<Value name="20">
<Value>CRZGDr</Value>
</Value>
<Value name="21">
<Value>CRIsZLXYC</Value>
</Value>
<Value name="22">
<Value>CRZDYJDr</Value>
</Value>
<Value name="23">
<Value>CRZDYJTxt</Value>
</Value>
<Value name="24">
<Value>CRJXQZSJDr</Value>
</Value>
<Value name="25">
<Value>CRCQZDYZ</Value>
</Value>
<Value name="26">
<Value>CRCQZDYY</Value>
</Value>
<Value name="27">
<Value>CRZDDr</Value>
</Value>
<Value name="28">
<Value>CRZDZYDr</Value>
</Value>
<Value name="29">
<Value>CRZDNDXL</Value>
</Value>
<Value name="30">
<Value>CRZDXTXXZBDr</Value>
</Value>
<Value name="31">
<Value>CRZDDZHPXLXDr</Value>
</Value>
<Value name="32">
<Value>CRZDTxt</Value>
</Value>
<Value name="33">
<Value>CRYZQHBFR</Value>
</Value>
<Value name="34">
<Value>CRYZQHBBDGR</Value>
</Value>
<Value name="35">
<Value>CRYZQHBTNB</Value>
</Value>
<Value name="36">
<Value>CRYZQHBTxt</Value>
</Value>
<Value name="37">
<Value>CRYZQFYHAL</Value>
</Value>
<Value name="38">
<Value>CRYZQFYKSS</Value>
</Value>
<Value name="39">
<Value>CRYZQFYBYY</Value>
</Value>
<Value name="40">
<Value>CRYZQFYZJY</Value>
</Value>
<Value name="41">
<Value>CRYZQFYTxt</Value>
</Value>
<Value name="42">
<Value>CRYZQQTYJ</Value>
</Value>
<Value name="43">
<Value>CRYZQQTNY</Value>
</Value>
<Value name="44">
<Value>CRYZQQTSX</Value>
</Value>
<Value name="45">
<Value>CRYZQQTHXZJ</Value>
</Value>
<Value name="46">
<Value>CRYZQQTTxt</Value>
</Value>
<Value name="47">
<Value>CRJZSYYCSYSDr</Value>
</Value>
<Value name="48">
<Value>CRJZSYST</Value>
</Value>
<Value name="49">
<Value>CRJZSYZRLC</Value>
</Value>
<Value name="50">
<Value>CRJZSYQXE</Value>
</Value>
<Value name="51">
<Value>CRJZSYQXM</Value>
</Value>
<Value name="52">
<Value>CRJZYCQXM1</Value>
</Value>
<Value name="53">
<Value>CRJZYCQYGX1</Value>
</Value>
<Value name="54">
<Value>CRJZYCQXM2</Value>
</Value>
<Value name="55">
<Value>CRJZYCQYGX2</Value>
</Value>
<Value name="56">
<Value>CRJZYCQXM3</Value>
</Value>
<Value name="57">
<Value>CRJZYCQYGX3</Value>
</Value>
<Value name="58">
<Value>CRJZHPIsJQ</Value>
</Value>
<Value name="59">
<Value>CRJZHPJQGX</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("CSQX")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("CSQX")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI("CSQX")</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportCSQXS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
