/// 名称 : DHCWMR.MR.FrontPageAdm
/// 说明 : 住院病案首页病人信息表【P0-P1】
Class DHCWMR.MR.FrontPageAdm Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.MR.FrontPage [ Cardinality = parent, Inverse = ChildAdm ];

/// 机构名称
Property P00010000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 组织机构代码
Property P00010001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医疗付费方式
Property P00020000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医疗付费方式编码
Property P00020001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 健康卡号
Property P00030000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 住院次数
Property P00040000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病案号
Property P00050000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 姓名
Property P00060000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 性别
Property P00070000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 性别编码
Property P00070001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生日期
Property P00080000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 年龄
Property P00090000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// （年龄不足1周岁的）年龄*月
Property P00090100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 国籍
Property P00100000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 国籍编码
Property P00100001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 新生儿体重
Property P00110000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 新生儿入院体重
Property P00120000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生地-详细地址
Property P00130000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生地-省（区、市）
Property P00130100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生地-省（区、市）编码
Property P00130101 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生地-市
Property P00130200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生地-市编码
Property P00130201 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生地-县
Property P00130300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生地-县编码
Property P00130301 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 籍贯-详细地址
Property P00140000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 籍贯-省（区、市）
Property P00140100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 籍贯-省（区、市）编码
Property P00140101 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 籍贯-市
Property P00140200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 籍贯-市编码
Property P00140201 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 民族
Property P00150000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 民族编码
Property P00150001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 身份证号
Property P00160000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 职业
Property P00170000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 职业编码
Property P00170001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 婚姻
Property P00180000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 婚姻编码
Property P00180001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址-详细地址
Property P00190000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址-省（区、市）
Property P00190100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址-省（区、市）编码
Property P00190101 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址-市
Property P00190200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址-市编码
Property P00190201 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址-县
Property P00190300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址-县编码
Property P00190301 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址-其他
Property P00190400 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址-电话
Property P00190500 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址-邮编
Property P00190600 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户口地址-详细地址
Property P00200000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户口地址-省（区、市）
Property P00200100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户口地址-省（区、市）编码
Property P00200101 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户口地址-市
Property P00200200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户口地址-市编码
Property P00200201 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户口地址-县
Property P00200300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户口地址-县编码
Property P00200301 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户口地址-其他
Property P00200400 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 户口地址-邮编
Property P00200500 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 工作单位及地址
Property P00210000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 工作单位-单位电话
Property P00210100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 工作单位-邮编
Property P00210200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联系人姓名
Property P00220000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联系人-关系
Property P00220100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联系人-关系编码
Property P00220101 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联系人-地址
Property P00220200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联系人-电话
Property P00220300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院途径
Property P00230000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院途径编码
Property P00230001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 治疗类别
Property P00240000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 治疗类别编码
Property P00240001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院日期
Property P00250000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院时间(时)
Property P00250100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院科别
Property P00260000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院科别编码
Property P00260001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院病房
Property P00270000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院病房编码
Property P00270001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 转科科别
Property P00280000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 转科科别编码
Property P00280001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院日期
Property P00290000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院时间(时)
Property P00290100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院科别
Property P00300000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院科别编码
Property P00300001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院病房
Property P00310000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院病房编码
Property P00310001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 实际住院天数
Property P00320000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 实施临床路径（中医、西医、否）
Property P00330000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 实施临床路径编码
Property P00330001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 使用医疗机构中药制剂（1是、0否）
Property P00340000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 使用中医诊疗设备（1是、0否）
Property P00350000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 使用中医诊疗技术（1是、0否）
Property P00360000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 辩证施护（1是、0否）
Property P00370000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院时情况
Property P00380000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院时情况编码
Property P00380001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院后确诊日期
Property P00390000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病理号
Property P00400100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病理号2
Property P00400200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病理号3
Property P00400300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// HBsAg
Property P00410000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// HBsAg编码
Property P00410001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// HCV-Ab
Property P00420000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// HCV-Ab编码
Property P00420001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// HIV-Ab
Property P00430000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// HIV-Ab编码
Property P00430001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 门诊与出院诊断符合情况
Property P00440000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 门诊与出院诊断符合情况编码
Property P00440001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院与出院诊断符合情况
Property P00450000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院与出院诊断符合情况编码
Property P00450001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 术前与术后诊断符合情况
Property P00460000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 术前与术后诊断符合情况编码
Property P00460001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 临床与病理诊断符合情况
Property P00470000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 临床与病理诊断符合情况编码
Property P00470001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 放射与病理诊断符合情况
Property P00480000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 放射与病理诊断符合情况编码
Property P00480001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 抢救次数
Property P00490000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 抢救成功次数
Property P00500000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 药物过敏（1是、0否）
Property P00510000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 过敏药物
Property P00520000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 死亡患者尸检（1是、0否）
Property P00530000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 本院第一例（1是、0否）
Property P00540000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否随诊（1是、0否）
Property P00550000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 随诊时间年
Property P00550101 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 随诊时间月
Property P00550102 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 随诊时间周
Property P00550103 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 示教病例（1是、0否）
Property P00560000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// ABO血型
Property P00570000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// ABO血型编码
Property P00570001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// Rh血型
Property P00580000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// Rh血型编码
Property P00580001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 输血反应（1有、0无）
Property P00590000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 红细胞
Property P00590100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 血小板
Property P00590200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 血浆
Property P00590300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 全血
Property P00590400 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 其它
Property P00590500 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 科主任
Property P00600100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主任（副主任）医师
Property P00600200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主治医师
Property P00600300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 住院医师
Property P00600400 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 责任护士
Property P00600500 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 进修医师
Property P00600600 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 研究生实习医师
Property P00600700 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 实习医师
Property P00600800 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 编码员
Property P00600900 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病案质量
Property P00610000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病案质量编码
Property P00610001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 质控医师
Property P00610100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 质控护士
Property P00610200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 质控日期
Property P00610300 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 离院方式
Property P00620000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 离院方式编码
Property P00620001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医嘱转院医疗机构
Property P00620100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医嘱转社医疗机构
Property P00620200 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院再住院计划（1是、0否）
Property P00630000 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出院再住院目的
Property P00630100 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院前昏迷*天
Property P00640001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院前昏迷*小时
Property P00640002 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院前昏迷*分钟
Property P00640003 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院后昏迷*天
Property P00650001 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院后昏迷*小时
Property P00650002 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院后昏迷*分钟
Property P00650003 As %String(MAXLEN = 100, TRUNCATE = 1);

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  取病人信息
/// Table：       DHCWMR.MR.FrontPageAdm
/// Input：       Id : DHCWMR.MR.FrontPageAdm.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MR.FrontPageAdm).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MR.FrontPageAdm
{
	new (aId)
	quit:'##class(DHCWMR.MR.FrontPageAdm).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MR.FrontPageAdm).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  保存病人信息
/// Table：       DHCWMR.MR.FrontPageAdm
/// Input：       InputStr ：病人信息="..."
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.MR.FrontPageAdm).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	
	Set objParref=##class(DHCWMR.MR.FrontPage).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.MR.FrontPageAdm).%New()
	} Else {
		Set obj=##class(DHCWMR.MR.FrontPageAdm).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         = objParref
    Set obj.P00010000 = $p(aInputStr,aSeparate,3)   //机构名称
    Set obj.P00010001 = $p(aInputStr,aSeparate,4)   //组织机构代码
    Set obj.P00020000 = $p(aInputStr,aSeparate,5)   //医疗付费方式
    Set obj.P00020001 = $p(aInputStr,aSeparate,6)   //医疗付费方式编码
    Set obj.P00030000 = $p(aInputStr,aSeparate,7)   //健康卡号
    Set obj.P00040000 = $p(aInputStr,aSeparate,8)   //住院次数
    Set obj.P00050000 = $p(aInputStr,aSeparate,9)   //病案号
    Set obj.P00060000 = $p(aInputStr,aSeparate,10)  //姓名
    Set obj.P00070000 = $p(aInputStr,aSeparate,11)  //性别
    Set obj.P00070001 = $p(aInputStr,aSeparate,12)  //性别编码
    Set obj.P00080000 = $p(aInputStr,aSeparate,13)  //出生日期
    Set obj.P00090000 = $p(aInputStr,aSeparate,14)  //年龄
    Set obj.P00090100 = $p(aInputStr,aSeparate,15)  //（年龄不足1周岁的）年龄*月
    Set obj.P00100000 = $p(aInputStr,aSeparate,16)  //国籍
    Set obj.P00100001 = $p(aInputStr,aSeparate,17)  //国籍编码
    Set obj.P00110000 = $p(aInputStr,aSeparate,18)  //新生儿体重
    Set obj.P00120000 = $p(aInputStr,aSeparate,19)  //新生儿入院体重
    Set obj.P00130000 = $p(aInputStr,aSeparate,20)  //出生地-详细地址
    Set obj.P00130100 = $p(aInputStr,aSeparate,21)  //出生地-省（区、市）
    Set obj.P00130101 = $p(aInputStr,aSeparate,22)  //出生地-省（区、市）编码
    Set obj.P00130200 = $p(aInputStr,aSeparate,23)  //出生地-市
    Set obj.P00130201 = $p(aInputStr,aSeparate,24)  //出生地-市编码
    Set obj.P00130300 = $p(aInputStr,aSeparate,25)  //出生地-县
    Set obj.P00130301 = $p(aInputStr,aSeparate,26)  //出生地-县编码
    Set obj.P00140000 = $p(aInputStr,aSeparate,27)  //籍贯-详细地址
    Set obj.P00140100 = $p(aInputStr,aSeparate,28)  //籍贯-省（区、市）
    Set obj.P00140101 = $p(aInputStr,aSeparate,29)  //籍贯-省（区、市）编码
    Set obj.P00140200 = $p(aInputStr,aSeparate,30)  //籍贯-市
    Set obj.P00140201 = $p(aInputStr,aSeparate,31)  //籍贯-市编码
    Set obj.P00150000 = $p(aInputStr,aSeparate,32)  //民族
    Set obj.P00150001 = $p(aInputStr,aSeparate,33)  //民族编码
    Set obj.P00160000 = $p(aInputStr,aSeparate,34)  //身份证号
    Set obj.P00170000 = $p(aInputStr,aSeparate,35)  //职业
    Set obj.P00170001 = $p(aInputStr,aSeparate,36)  //职业编码
    Set obj.P00180000 = $p(aInputStr,aSeparate,37)  //婚姻
    Set obj.P00180001 = $p(aInputStr,aSeparate,38)  //婚姻编码
    Set obj.P00190000 = $p(aInputStr,aSeparate,39)  //现住址-详细地址
    Set obj.P00190100 = $p(aInputStr,aSeparate,40)  //现住址-省（区、市）
    Set obj.P00190101 = $p(aInputStr,aSeparate,41)  //现住址-省（区、市）编码
    Set obj.P00190200 = $p(aInputStr,aSeparate,42)  //现住址-市
    Set obj.P00190201 = $p(aInputStr,aSeparate,43)  //现住址-市编码
    Set obj.P00190300 = $p(aInputStr,aSeparate,44)  //现住址-县
    Set obj.P00190301 = $p(aInputStr,aSeparate,45)  //现住址-县编码
    Set obj.P00190400 = $p(aInputStr,aSeparate,46)  //现住址-其他
    Set obj.P00190500 = $p(aInputStr,aSeparate,47)  //现住址-电话
    Set obj.P00190600 = $p(aInputStr,aSeparate,48)  //现住址-邮编
    Set obj.P00200000 = $p(aInputStr,aSeparate,49)  //户口地址-详细地址
    Set obj.P00200100 = $p(aInputStr,aSeparate,50)  //户口地址-省（区、市）
    Set obj.P00200101 = $p(aInputStr,aSeparate,51)  //户口地址-省（区、市）编码
    Set obj.P00200200 = $p(aInputStr,aSeparate,52)  //户口地址-市
    Set obj.P00200201 = $p(aInputStr,aSeparate,53)  //户口地址-市编码
    Set obj.P00200300 = $p(aInputStr,aSeparate,54)  //户口地址-县
    Set obj.P00200301 = $p(aInputStr,aSeparate,55)  //户口地址-县编码
    Set obj.P00200400 = $p(aInputStr,aSeparate,56)  //户口地址-其他
    Set obj.P00200500 = $p(aInputStr,aSeparate,57)  //户口地址-邮编
    Set obj.P00210000 = $p(aInputStr,aSeparate,58)  //工作单位及地址
    Set obj.P00210100 = $p(aInputStr,aSeparate,59)  //工作单位-单位电话
    Set obj.P00210200 = $p(aInputStr,aSeparate,60)  //工作单位-邮编
    Set obj.P00220000 = $p(aInputStr,aSeparate,61)  //联系人姓名
    Set obj.P00220100 = $p(aInputStr,aSeparate,62)  //联系人-关系
    Set obj.P00220101 = $p(aInputStr,aSeparate,63)  //联系人-关系编码
    Set obj.P00220200 = $p(aInputStr,aSeparate,64)  //联系人-地址
    Set obj.P00220300 = $p(aInputStr,aSeparate,65)  //联系人-电话
    Set obj.P00230000 = $p(aInputStr,aSeparate,66)  //入院途径
    Set obj.P00230001 = $p(aInputStr,aSeparate,67)  //入院途径编码
    Set obj.P00240000 = $p(aInputStr,aSeparate,68)  //治疗类别
    Set obj.P00240001 = $p(aInputStr,aSeparate,69)  //治疗类别编码
    Set obj.P00250000 = $p(aInputStr,aSeparate,70)  //入院日期
    Set obj.P00250100 = $p(aInputStr,aSeparate,71)  //入院时间(时)
    Set obj.P00260000 = $p(aInputStr,aSeparate,72)  //入院科别
    Set obj.P00260001 = $p(aInputStr,aSeparate,73)  //入院科别编码
    Set obj.P00270000 = $p(aInputStr,aSeparate,74)  //入院病房
    Set obj.P00270001 = $p(aInputStr,aSeparate,75)  //入院病房编码
    Set obj.P00280000 = $p(aInputStr,aSeparate,76)  //转科科别
    Set obj.P00280001 = $p(aInputStr,aSeparate,77)  //转科科别编码
    Set obj.P00290000 = $p(aInputStr,aSeparate,78)  //出院日期
    Set obj.P00290100 = $p(aInputStr,aSeparate,79)  //出院时间(时)
    Set obj.P00300000 = $p(aInputStr,aSeparate,80)  //出院科别
    Set obj.P00300001 = $p(aInputStr,aSeparate,81)  //出院科别编码
    Set obj.P00310000 = $p(aInputStr,aSeparate,82)  //出院病房
    Set obj.P00310001 = $p(aInputStr,aSeparate,83)  //出院病房编码
    Set obj.P00320000 = $p(aInputStr,aSeparate,84)  //实际住院天数
    Set obj.P00330000 = $p(aInputStr,aSeparate,85)  //实施临床路径
    Set obj.P00330001 = $p(aInputStr,aSeparate,86)  //实施临床路径
    Set obj.P00340000 = $p(aInputStr,aSeparate,87)  //使用医疗机构中药制剂
    Set obj.P00350000 = $p(aInputStr,aSeparate,88)  //使用中医诊疗设备
    Set obj.P00360000 = $p(aInputStr,aSeparate,89)  //使用中医诊疗技术
    Set obj.P00370000 = $p(aInputStr,aSeparate,90)  //辩证施护
    Set obj.P00380000 = $p(aInputStr,aSeparate,91)  //入院时情况
    Set obj.P00380001 = $p(aInputStr,aSeparate,92)  //入院时情况编码
    Set obj.P00390000 = $p(aInputStr,aSeparate,93)  //入院后确诊日期
    Set obj.P00400100 = $p(aInputStr,aSeparate,94)  //病理号
    Set obj.P00400200 = $p(aInputStr,aSeparate,95)  //病理号2
    Set obj.P00400300 = $p(aInputStr,aSeparate,96)  //病理号3
    Set obj.P00410000 = $p(aInputStr,aSeparate,97)  //HBsAg
    Set obj.P00410001 = $p(aInputStr,aSeparate,98)  //HBsAg编码
    Set obj.P00420000 = $p(aInputStr,aSeparate,99)  //HCV-Ab
    Set obj.P00420001 = $p(aInputStr,aSeparate,100)  //HCV-Ab编码
    Set obj.P00430000 = $p(aInputStr,aSeparate,101)  //HIV-Ab
    Set obj.P00430001 = $p(aInputStr,aSeparate,102)  //HIV-Ab编码
    Set obj.P00440000 = $p(aInputStr,aSeparate,103)  //门诊与出院诊断符合情况
    Set obj.P00440001 = $p(aInputStr,aSeparate,104)  //门诊与出院诊断符合情况编码
    Set obj.P00450000 = $p(aInputStr,aSeparate,105)  //入院与出院诊断符合情况
    Set obj.P00450001 = $p(aInputStr,aSeparate,106)  //入院与出院诊断符合情况编码
    Set obj.P00460000 = $p(aInputStr,aSeparate,107)  //术前与术后诊断符合情况
    Set obj.P00460001 = $p(aInputStr,aSeparate,108)  //术前与术后诊断符合情况编码
    Set obj.P00470000 = $p(aInputStr,aSeparate,109)  //临床与病理诊断符合情况
    Set obj.P00470001 = $p(aInputStr,aSeparate,110)  //临床与病理诊断符合情况编码
    Set obj.P00480000 = $p(aInputStr,aSeparate,111)  //放射与病理诊断符合情况
    Set obj.P00480001 = $p(aInputStr,aSeparate,112)  //放射与病理诊断符合情况编码
    Set obj.P00490000 = $p(aInputStr,aSeparate,113)  //抢救次数
    Set obj.P00500000 = $p(aInputStr,aSeparate,114)  //抢救成功次数
    Set obj.P00510000 = $p(aInputStr,aSeparate,115)  //药物过敏
    Set obj.P00520000 = $p(aInputStr,aSeparate,116)  //过敏药物
    Set obj.P00530000 = $p(aInputStr,aSeparate,117)  //死亡患者尸检
    Set obj.P00540000 = $p(aInputStr,aSeparate,118)  //本院第一例
    Set obj.P00550000 = $p(aInputStr,aSeparate,119)  //是否随诊
    Set obj.P00550101 = $p(aInputStr,aSeparate,120)  //随诊时间年
    Set obj.P00550102 = $p(aInputStr,aSeparate,121)  //随诊时间月
    Set obj.P00550103 = $p(aInputStr,aSeparate,122)  //随诊时间周
    Set obj.P00560000 = $p(aInputStr,aSeparate,123)  //示教病例
    Set obj.P00570000 = $p(aInputStr,aSeparate,124)  //ABO血型
    Set obj.P00570001 = $p(aInputStr,aSeparate,125)  //ABO血型编码
    Set obj.P00580000 = $p(aInputStr,aSeparate,126)  //Rh血型
    Set obj.P00580001 = $p(aInputStr,aSeparate,127)  //Rh血型编码
    Set obj.P00590000 = $p(aInputStr,aSeparate,128)  //输血反应
    Set obj.P00590100 = $p(aInputStr,aSeparate,129)  //红细胞
    Set obj.P00590200 = $p(aInputStr,aSeparate,130)  //血小板
    Set obj.P00590300 = $p(aInputStr,aSeparate,131)  //血浆
    Set obj.P00590400 = $p(aInputStr,aSeparate,132)  //全血
    Set obj.P00590500 = $p(aInputStr,aSeparate,133)  //其它
    Set obj.P00600100 = $p(aInputStr,aSeparate,134)  //科主任
    Set obj.P00600200 = $p(aInputStr,aSeparate,135)  //主任（副主任）医师
    Set obj.P00600300 = $p(aInputStr,aSeparate,136)  //主治医师
    Set obj.P00600400 = $p(aInputStr,aSeparate,137)  //住院医师
    Set obj.P00600500 = $p(aInputStr,aSeparate,138)  //责任护士
    Set obj.P00600600 = $p(aInputStr,aSeparate,139)  //进修医师
    Set obj.P00600700 = $p(aInputStr,aSeparate,140)  //研究生实习医师
    Set obj.P00600800 = $p(aInputStr,aSeparate,141)  //实习医师
    Set obj.P00600900 = $p(aInputStr,aSeparate,142)  //编码员
    Set obj.P00610000 = $p(aInputStr,aSeparate,143)  //病案质量
    Set obj.P00610001 = $p(aInputStr,aSeparate,144)  //病案质量编码
    Set obj.P00610100 = $p(aInputStr,aSeparate,145)  //质控医师
    Set obj.P00610200 = $p(aInputStr,aSeparate,146)  //质控护士
    Set obj.P00610300 = $p(aInputStr,aSeparate,147)  //质控日期
    Set obj.P00620000 = $p(aInputStr,aSeparate,148)  //离院方式
    Set obj.P00620001 = $p(aInputStr,aSeparate,149)  //离院方式编码
    Set obj.P00620100 = $p(aInputStr,aSeparate,150)  //医嘱转院医疗机构
    Set obj.P00620200 = $p(aInputStr,aSeparate,151)  //医嘱转社医疗机构
    Set obj.P00630000 = $p(aInputStr,aSeparate,152)  //出院再住院计划
    Set obj.P00630100 = $p(aInputStr,aSeparate,153)  //出院再住院目的
    Set obj.P00640001 = $p(aInputStr,aSeparate,154)  //入院前昏迷*天
    Set obj.P00640002 = $p(aInputStr,aSeparate,155)  //入院前昏迷*小时
    Set obj.P00640003 = $p(aInputStr,aSeparate,156)  //入院前昏迷*分钟
    Set obj.P00650001 = $p(aInputStr,aSeparate,157)  //入院后昏迷*天
    Set obj.P00650002 = $p(aInputStr,aSeparate,158)  //入院后昏迷*小时
    Set obj.P00650003 = $p(aInputStr,aSeparate,159)  //入院后昏迷*分钟
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

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  删除病人信息
/// Table：       DHCWMR.MR.FrontPageAdm
/// Input：       Id : DHCWMR.MR.FrontPageAdm.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MR.FrontPageAdm).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>P00010000</Value>
</Value>
<Value name="3">
<Value>P00010001</Value>
</Value>
<Value name="4">
<Value>P00020000</Value>
</Value>
<Value name="5">
<Value>P00020001</Value>
</Value>
<Value name="6">
<Value>P00030000</Value>
</Value>
<Value name="7">
<Value>P00040000</Value>
</Value>
<Value name="8">
<Value>P00050000</Value>
</Value>
<Value name="9">
<Value>P00060000</Value>
</Value>
<Value name="10">
<Value>P00070000</Value>
</Value>
<Value name="11">
<Value>P00070001</Value>
</Value>
<Value name="12">
<Value>P00080000</Value>
</Value>
<Value name="13">
<Value>P00090000</Value>
</Value>
<Value name="14">
<Value>P00090100</Value>
</Value>
<Value name="15">
<Value>P00100000</Value>
</Value>
<Value name="16">
<Value>P00100001</Value>
</Value>
<Value name="17">
<Value>P00110000</Value>
</Value>
<Value name="18">
<Value>P00120000</Value>
</Value>
<Value name="19">
<Value>P00130000</Value>
</Value>
<Value name="20">
<Value>P00130100</Value>
</Value>
<Value name="21">
<Value>P00130101</Value>
</Value>
<Value name="22">
<Value>P00130200</Value>
</Value>
<Value name="23">
<Value>P00130201</Value>
</Value>
<Value name="24">
<Value>P00130300</Value>
</Value>
<Value name="25">
<Value>P00130301</Value>
</Value>
<Value name="26">
<Value>P00140000</Value>
</Value>
<Value name="27">
<Value>P00140100</Value>
</Value>
<Value name="28">
<Value>P00140101</Value>
</Value>
<Value name="29">
<Value>P00140200</Value>
</Value>
<Value name="30">
<Value>P00140201</Value>
</Value>
<Value name="31">
<Value>P00150000</Value>
</Value>
<Value name="32">
<Value>P00150001</Value>
</Value>
<Value name="33">
<Value>P00160000</Value>
</Value>
<Value name="34">
<Value>P00170000</Value>
</Value>
<Value name="35">
<Value>P00170001</Value>
</Value>
<Value name="36">
<Value>P00180000</Value>
</Value>
<Value name="37">
<Value>P00180001</Value>
</Value>
<Value name="38">
<Value>P00190000</Value>
</Value>
<Value name="39">
<Value>P00190100</Value>
</Value>
<Value name="40">
<Value>P00190101</Value>
</Value>
<Value name="41">
<Value>P00190200</Value>
</Value>
<Value name="42">
<Value>P00190201</Value>
</Value>
<Value name="43">
<Value>P00190300</Value>
</Value>
<Value name="44">
<Value>P00190301</Value>
</Value>
<Value name="45">
<Value>P00190400</Value>
</Value>
<Value name="46">
<Value>P00190500</Value>
</Value>
<Value name="47">
<Value>P00190600</Value>
</Value>
<Value name="48">
<Value>P00200000</Value>
</Value>
<Value name="49">
<Value>P00200100</Value>
</Value>
<Value name="50">
<Value>P00200101</Value>
</Value>
<Value name="51">
<Value>P00200200</Value>
</Value>
<Value name="52">
<Value>P00200201</Value>
</Value>
<Value name="53">
<Value>P00200300</Value>
</Value>
<Value name="54">
<Value>P00200301</Value>
</Value>
<Value name="55">
<Value>P00200400</Value>
</Value>
<Value name="56">
<Value>P00200500</Value>
</Value>
<Value name="57">
<Value>P00210000</Value>
</Value>
<Value name="58">
<Value>P00210100</Value>
</Value>
<Value name="59">
<Value>P00210200</Value>
</Value>
<Value name="60">
<Value>P00220000</Value>
</Value>
<Value name="61">
<Value>P00220100</Value>
</Value>
<Value name="62">
<Value>P00220101</Value>
</Value>
<Value name="63">
<Value>P00220200</Value>
</Value>
<Value name="64">
<Value>P00220300</Value>
</Value>
<Value name="65">
<Value>P00230000</Value>
</Value>
<Value name="66">
<Value>P00230001</Value>
</Value>
<Value name="67">
<Value>P00240000</Value>
</Value>
<Value name="68">
<Value>P00240001</Value>
</Value>
<Value name="69">
<Value>P00250000</Value>
</Value>
<Value name="70">
<Value>P00250100</Value>
</Value>
<Value name="71">
<Value>P00260000</Value>
</Value>
<Value name="72">
<Value>P00260001</Value>
</Value>
<Value name="73">
<Value>P00270000</Value>
</Value>
<Value name="74">
<Value>P00270001</Value>
</Value>
<Value name="75">
<Value>P00280000</Value>
</Value>
<Value name="76">
<Value>P00280001</Value>
</Value>
<Value name="77">
<Value>P00290000</Value>
</Value>
<Value name="78">
<Value>P00290100</Value>
</Value>
<Value name="79">
<Value>P00300000</Value>
</Value>
<Value name="80">
<Value>P00300001</Value>
</Value>
<Value name="81">
<Value>P00310000</Value>
</Value>
<Value name="82">
<Value>P00310001</Value>
</Value>
<Value name="83">
<Value>P00320000</Value>
</Value>
<Value name="84">
<Value>P00330000</Value>
</Value>
<Value name="85">
<Value>P00330001</Value>
</Value>
<Value name="86">
<Value>P00340000</Value>
</Value>
<Value name="87">
<Value>P00350000</Value>
</Value>
<Value name="88">
<Value>P00360000</Value>
</Value>
<Value name="89">
<Value>P00370000</Value>
</Value>
<Value name="90">
<Value>P00380000</Value>
</Value>
<Value name="91">
<Value>P00380001</Value>
</Value>
<Value name="92">
<Value>P00390000</Value>
</Value>
<Value name="93">
<Value>P00400100</Value>
</Value>
<Value name="94">
<Value>P00400200</Value>
</Value>
<Value name="95">
<Value>P00400300</Value>
</Value>
<Value name="96">
<Value>P00410000</Value>
</Value>
<Value name="97">
<Value>P00410001</Value>
</Value>
<Value name="98">
<Value>P00420000</Value>
</Value>
<Value name="99">
<Value>P00420001</Value>
</Value>
<Value name="100">
<Value>P00430000</Value>
</Value>
<Value name="101">
<Value>P00430001</Value>
</Value>
<Value name="102">
<Value>P00440000</Value>
</Value>
<Value name="103">
<Value>P00440001</Value>
</Value>
<Value name="104">
<Value>P00450000</Value>
</Value>
<Value name="105">
<Value>P00450001</Value>
</Value>
<Value name="106">
<Value>P00460000</Value>
</Value>
<Value name="107">
<Value>P00460001</Value>
</Value>
<Value name="108">
<Value>P00470000</Value>
</Value>
<Value name="109">
<Value>P00470001</Value>
</Value>
<Value name="110">
<Value>P00480000</Value>
</Value>
<Value name="111">
<Value>P00480001</Value>
</Value>
<Value name="112">
<Value>P00490000</Value>
</Value>
<Value name="113">
<Value>P00500000</Value>
</Value>
<Value name="114">
<Value>P00510000</Value>
</Value>
<Value name="115">
<Value>P00520000</Value>
</Value>
<Value name="116">
<Value>P00530000</Value>
</Value>
<Value name="117">
<Value>P00540000</Value>
</Value>
<Value name="118">
<Value>P00550000</Value>
</Value>
<Value name="119">
<Value>P00550101</Value>
</Value>
<Value name="120">
<Value>P00550102</Value>
</Value>
<Value name="121">
<Value>P00550103</Value>
</Value>
<Value name="122">
<Value>P00560000</Value>
</Value>
<Value name="123">
<Value>P00570000</Value>
</Value>
<Value name="124">
<Value>P00570001</Value>
</Value>
<Value name="125">
<Value>P00580000</Value>
</Value>
<Value name="126">
<Value>P00580001</Value>
</Value>
<Value name="127">
<Value>P00590000</Value>
</Value>
<Value name="128">
<Value>P00590100</Value>
</Value>
<Value name="129">
<Value>P00590200</Value>
</Value>
<Value name="130">
<Value>P00590300</Value>
</Value>
<Value name="131">
<Value>P00590400</Value>
</Value>
<Value name="132">
<Value>P00590500</Value>
</Value>
<Value name="133">
<Value>P00600100</Value>
</Value>
<Value name="134">
<Value>P00600200</Value>
</Value>
<Value name="135">
<Value>P00600300</Value>
</Value>
<Value name="136">
<Value>P00600400</Value>
</Value>
<Value name="137">
<Value>P00600500</Value>
</Value>
<Value name="138">
<Value>P00600600</Value>
</Value>
<Value name="139">
<Value>P00600700</Value>
</Value>
<Value name="140">
<Value>P00600800</Value>
</Value>
<Value name="141">
<Value>P00600900</Value>
</Value>
<Value name="142">
<Value>P00610000</Value>
</Value>
<Value name="143">
<Value>P00610001</Value>
</Value>
<Value name="144">
<Value>P00610100</Value>
</Value>
<Value name="145">
<Value>P00610200</Value>
</Value>
<Value name="146">
<Value>P00610300</Value>
</Value>
<Value name="147">
<Value>P00620000</Value>
</Value>
<Value name="148">
<Value>P00620001</Value>
</Value>
<Value name="149">
<Value>P00620100</Value>
</Value>
<Value name="150">
<Value>P00620200</Value>
</Value>
<Value name="151">
<Value>P00630000</Value>
</Value>
<Value name="152">
<Value>P00630100</Value>
</Value>
<Value name="153">
<Value>P00640001</Value>
</Value>
<Value name="154">
<Value>P00640002</Value>
</Value>
<Value name="155">
<Value>P00640003</Value>
</Value>
<Value name="156">
<Value>P00650001</Value>
</Value>
<Value name="157">
<Value>P00650002</Value>
</Value>
<Value name="158">
<Value>P00650003</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ADM")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MR.FrontPageC("ADM")</IdLocation>
<IndexLocation>^DHCWMR.MR.FrontPageI("ADM")</IndexLocation>
<StreamLocation>^DHCWMR.MR.FrontPageAdmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
