Class web.DHCMedInsertData Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 30;

/// 作用：		往DHC_MedDictory表中插入数据
/// 作者：		刘宇辉
/// 日期：		2010-02-25
/// 调用方法:	d ##Class(web.DHCMedInsertData).InsertDataToMedDic()
ClassMethod InsertDataToMedDic()
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    
    s PLIST(1)="^BaseDisLoc^基础疾病科室编号^SYS^Y^^"
    s PLIST(2)="^101^呼吸^BaseDisLoc^Y^^"
    s PLIST(3)="^102^消化^BaseDisLoc^Y^^"
    s PLIST(4)="^103^心血管^BaseDisLoc^Y^^"
    s PLIST(5)="^104^内分泌^BaseDisLoc^Y^^"
    s PLIST(6)="^105^肾病^BaseDisLoc^Y^^"
    s PLIST(7)="^106^传染病^BaseDisLoc^Y^^"
    s PLIST(8)="^107^血液病^BaseDisLoc^Y^^"
    s PLIST(9)="^108^神经内^BaseDisLoc^Y^^"
    s PLIST(10)="^109^中医^BaseDisLoc^Y^^"
    s PLIST(11)="^110^其它内科^BaseDisLoc^Y^^"
    s PLIST(12)="^201^普外科^BaseDisLoc^Y^^"
    s PLIST(13)="^202^胸外科(含心血管)^BaseDisLoc^Y^^"
    s PLIST(14)="^203^神经外科^BaseDisLoc^Y^^"
    s PLIST(15)="^204^骨科^BaseDisLoc^Y^^"
    s PLIST(16)="^205^泌尿外科^BaseDisLoc^Y^^"
    s PLIST(17)="^206^其它外科^BaseDisLoc^Y^^"
    s PLIST(18)="^301^口科^BaseDisLoc^Y^^"
    s PLIST(19)="^302^产科^BaseDisLoc^Y^^"
    s PLIST(20)="^401^儿科^BaseDisLoc^Y^^"
    s PLIST(21)="^501^眼科^BaseDisLoc^Y^^"
    s PLIST(22)="^502^耳鼻喉科^BaseDisLoc^Y^^"
    s PLIST(23)="^601^其它科室^BaseDisLoc^Y^^"
    
    s PLIST(24)="^IsInfection^是否发生医院感染^SYS^Y^^"
    s PLIST(25)="^0^无^IsInfection^Y^^"
    s PLIST(26)="^1^导管相关性感染^IsInfection^Y^^"
    s PLIST(27)="^2^非导管相关性感染^IsInfection^Y^^"
    
    s PLIST(28)="^OtherInfNum^发生其它院感编号^SYS^Y^^"
    s PLIST(29)="^11^上呼吸道(感冒除外)^OtherInfNum^Y^^"
    s PLIST(30)="^21^泌尿道^OtherInfNum^Y^^"
    s PLIST(31)="^31^感染性腹泻^OtherInfNum^Y^^"
    s PLIST(32)="^32^抗生素相关性腹泻^OtherInfNum^Y^^"
    s PLIST(33)="^33^腹腔内组织^OtherInfNum^Y^^"
    s PLIST(34)="^34^腹水感染^OtherInfNum^Y^^"
    s PLIST(35)="^41^表浅切口^OtherInfNum^Y^^"
    s PLIST(36)="^42^深部切口^OtherInfNum^Y^^"
    s PLIST(37)="^43^器官腔隙^OtherInfNum^Y^^"
    s PLIST(38)="^51^血管内导管感染^OtherInfNum^Y^^"
    s PLIST(39)="^52^菌血症^OtherInfNum^Y^^"
    s PLIST(40)="^61^脑膜炎^OtherInfNum^Y^^"
    s PLIST(41)="^62^颅内脓肿^OtherInfNum^Y^^"
    s PLIST(42)="^63^椎管内感染^OtherInfNum^Y^^"
    s PLIST(43)="^71^烧伤部位^OtherInfNum^Y^^"
    s PLIST(44)="^72^皮肤软组织^OtherInfNum^Y^^"
    s PLIST(45)="^81^其它部位感染^OtherInfNum^Y^^"
   
    s PLIST(46)="^Prognosis^预后^SYS^Y^^"
    s PLIST(47)="^1^存活^Prognosis^Y^^"
    s PLIST(48)="^0^死亡^Prognosis^Y^^"
    
    s PLIST(49)="^SamNameNum^标本名称编号^SYS^Y^^"
    s PLIST(50)="^11^咽拭子^SamNameNum^Y^^"
    s PLIST(51)="^12^痰^SamNameNum^Y^^"
    s PLIST(52)="^21^尿^SamNameNum^Y^^"
    s PLIST(53)="^31^粪^SamNameNum^Y^^"
    s PLIST(54)="^41^伤口拭子/伤口脓液^SamNameNum^Y^^"
    s PLIST(55)="^42^实质脏器腔隙内脓液^SamNameNum^Y^^"
    s PLIST(56)="^43^皮肤烧伤感染标本^SamNameNum^Y^^"
    s PLIST(57)="^61^血管导管^SamNameNum^Y^^"
    s PLIST(58)="^62^血^SamNameNum^Y^^"
    s PLIST(59)="^63^骨髓^SamNameNum^Y^^"
    s PLIST(60)="^81^胸水^SamNameNum^Y^^"
    s PLIST(61)="^82^腹水^SamNameNum^Y^^"
    s PLIST(62)="^83^脑脊液^SamNameNum^Y^^"
    s PLIST(63)="^84^其它浆膜腔积液^SamNameNum^Y^^"
    s PLIST(64)="^91^其它^SamNameNum^Y^^"
    
    s PLIST(65)="^BacilliNum^细菌编号^SYS^Y^^"
    s PLIST(66)="^101^金葡菌^BacilliNum^Y^^"
    s PLIST(67)="^102^表皮葡萄球菌^BacilliNum^Y^^"
    s PLIST(68)="^103^其它葡萄球菌^BacilliNum^Y^^"
    s PLIST(69)="^111^草绿色链球菌^BacilliNum^Y^^"
    s PLIST(70)="^112^肺炎链球菌^BacilliNum^Y^^"
    s PLIST(71)="^113^溶血性链球菌^BacilliNum^Y^^"
    s PLIST(72)="^114^其它链球菌^BacilliNum^Y^^"
    s PLIST(73)="^121^粪肠球菌^BacilliNum^Y^^"
    s PLIST(74)="^122^屎肠球菌^BacilliNum^Y^^"
    s PLIST(75)="^123^其它肠球菌^BacilliNum^Y^^"
    s PLIST(76)="^131^微球菌^BacilliNum^Y^^"
    s PLIST(77)="^141^其它革兰阳性球菌^BacilliNum^Y^^"
    s PLIST(78)="^201^大肠杆菌^BacilliNum^Y^^"
    s PLIST(79)="^211^肺炎克雷伯菌^BacilliNum^Y^^"
    s PLIST(80)="^212^其它克雷伯菌^BacilliNum^Y^^"
    s PLIST(81)="^221^阴沟肠杆菌^BacilliNum^Y^^"
    s PLIST(82)="^222^其它肠杆菌^BacilliNum^Y^^"
    s PLIST(83)="^231^变形杆菌^BacilliNum^Y^^"
    s PLIST(84)="^241^沙雷杆菌^BacilliNum^Y^^"
    s PLIST(85)="^251^枸橼菌^BacilliNum^Y^^"
    s PLIST(86)="^261^伤寒杆菌^BacilliNum^Y^^"
    s PLIST(87)="^271^志贺菌^BacilliNum^Y^^"
    s PLIST(88)="^301^绿浓杆菌^BacilliNum^Y^^"
    s PLIST(89)="^302^其它假单细胞菌^BacilliNum^Y^^"
    s PLIST(90)="^311^不动杆菌^BacilliNum^Y^^"
    s PLIST(91)="^321^嗜麦芽黄单细胞菌/假单胞菌^BacilliNum^Y^^"
    s PLIST(92)="^331^黄杆菌^BacilliNum^Y^^"
    s PLIST(93)="^341^产碱杆菌^BacilliNum^Y^^"
    s PLIST(94)="^401^流感杆菌^BacilliNum^Y^^"
    s PLIST(95)="^402^副流感杆菌^BacilliNum^Y^^"
    s PLIST(96)="^411^邻单胞菌^BacilliNum^Y^^"
    s PLIST(97)="^421^气单胞菌^BacilliNum^Y^^"
    s PLIST(98)="^431^弧菌^BacilliNum^Y^^"
    s PLIST(99)="^499^其它阴性革兰杆菌^BacilliNum^Y^^"
    s PLIST(100)="^501^革兰阳性杆菌^BacilliNum^Y^^"
    s PLIST(101)="^601^革兰阴性球菌^BacilliNum^Y^^"
    s PLIST(102)="^701^厌氧菌^BacilliNum^Y^^"
    s PLIST(103)="^801^白色念珠菌^BacilliNum^Y^^"
    s PLIST(104)="^802^其它念珠菌^BacilliNum^Y^^"
    s PLIST(105)="^811^隐球菌^BacilliNum^Y^^"
    s PLIST(106)="^821^曲菌^BacilliNum^Y^^"
    s PLIST(107)="^831^毛霉菌^BacilliNum^Y^^"
    s PLIST(108)="^841^其它真菌^BacilliNum^Y^^"
    
    s PLIST(109)="^YearPrime^年^SYS^Y^^"
    s PLIST(110)="^2010^2010年^YearPrime^Y^^"
    s PLIST(111)="^2011^2011年^YearPrime^Y^^"
    s PLIST(112)="^2012^2012年^YearPrime^Y^^"
    s PLIST(113)="^2013^2013年^YearPrime^Y^^"
    s PLIST(114)="^2014^2014年^YearPrime^Y^^"
    s PLIST(115)="^2015^2015年^YearPrime^Y^^"
    s PLIST(116)="^2016^2016年^YearPrime^Y^^"
    s PLIST(117)="^2017^2017年^YearPrime^Y^^"
    s PLIST(118)="^2018^2018年^YearPrime^Y^^"
    s PLIST(119)="^2019^2019年^YearPrime^Y^^"
    
    s PLIST(120)="^MonthPrime^月份^SYS^Y^^"
    s PLIST(121)="^1^1月^MonthPrime^Y^^"
    s PLIST(122)="^2^2月^MonthPrime^Y^^"
    s PLIST(123)="^3^3月^MonthPrime^Y^^"
    s PLIST(124)="^4^4月^MonthPrime^Y^^"
    s PLIST(125)="^5^5月^MonthPrime^Y^^"
    s PLIST(126)="^6^6月^MonthPrime^Y^^"
    s PLIST(127)="^7^7月^MonthPrime^Y^^"
    s PLIST(128)="^8^8月^MonthPrime^Y^^"
    s PLIST(129)="^9^9月^MonthPrime^Y^^"
    s PLIST(130)="^10^10月^MonthPrime^Y^^"
    s PLIST(131)="^11^11月^MonthPrime^Y^^"
    s PLIST(132)="^12^12月^MonthPrime^Y^^"
    
    s PLIST(120)="^Sex^性别^SYS^Y^^"
    s PLIST(121)="^1^男^Sex^Y^^"
    s PLIST(122)="^2^女^Sex^Y^^"
    
    s PLIST(123)="^ICUYesNo^是否^SYS^Y^^"
    s PLIST(124)="^1^是^ICUYesNo^Y^^"
    s PLIST(125)="^0^否^ICUYesNo^Y^^"
    
    s PLIST(126)="^ICUYesNo1^有无^SYS^Y^^"
    s PLIST(127)="^1^有^ICUYesNo1^Y^^"
    s PLIST(128)="^0^无^ICUYesNo1^Y^^"

    f i=1:1 q:PLIST(i)=""  d
    .d Update^DHCMedDictory(PLIST(i))

	zn CurrentNS
}

}
