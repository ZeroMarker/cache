/// 名称: DHCMed.NINF.Aim.ICUReport
/// 描述: ICU医院感染病例监测表
/// 编写者：ZGZ
/// 编写日期: 2012-04-11
/// update by liuyh 2012-08-09 ICU医院感染病例监测表 标准模板
Class DHCMed.NINF.Aim.ICUReport Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 临床上报表ID
Property CRReportDR As %String(TRUNCATE = 1) [ Required ];

Index CRReportDR On CRReportDR [ Unique ];

/// 转入ICU日期
Property InICUDate As %String;

/// 转出ICU日期
Property OutICUDate As %String;

/// 转出至
Property OutICUPlace As %String;

/// 转入ICU诊断
Property InICUDiag1 As %String(TRUNCATE = 1);

/// 转入ICU诊断
Property InICUDiag2 As %String(TRUNCATE = 1);

/// 转入ICU诊断
Property InICUDiag3 As %String(TRUNCATE = 1);

/// ICU诊断
Property ICUDiag1 As %String(TRUNCATE = 1);

/// ICU诊断
Property ICUDiag2 As %String(TRUNCATE = 1);

/// ICU诊断
Property ICUDiag3 As %String(TRUNCATE = 1);

/// 静脉导管类型
Property VeinCatheterType1 As %String(TRUNCATE = 1);

/// 静脉导管类型
Property VeinCatheterType2 As %String(TRUNCATE = 1);

/// 静脉导管类型
Property VeinCatheterType3 As %String(TRUNCATE = 1);

/// 静脉导管腔数
Property VeinCavityNum1 As %String(TRUNCATE = 1);

/// 静脉导管腔数
Property VeinCavityNum2 As %String(TRUNCATE = 1);

/// 静脉导管腔数
Property VeinCavityNum3 As %String(TRUNCATE = 1);

/// 静脉置管部位
Property VeinCavityPos1 As %String(TRUNCATE = 1);

/// 静脉置管部位
Property VeinCavityPos2 As %String(TRUNCATE = 1);

/// 静脉置管部位
Property VeinCavityPos3 As %String(TRUNCATE = 1);

/// 静脉置管日期
Property VeinPipeDate1 As %String(TRUNCATE = 1);

/// 静脉置管日期
Property VeinPipeDate2 As %String(TRUNCATE = 1);

/// 静脉置管日期
Property VeinPipeDate3 As %String(TRUNCATE = 1);

/// 静脉拔管日期
Property VeinOutPipeDate1 As %String(TRUNCATE = 1);

/// 静脉拔管日期
Property VeinOutPipeDate2 As %String(TRUNCATE = 1);

/// 静脉拔管日期
Property VeinOutPipeDate3 As %String(TRUNCATE = 1);

/// 静脉置管操作者
Property VeinOutPipeOper1 As %String(TRUNCATE = 1);

/// 静脉置管操作者
Property VeinOutPipeOper2 As %String(TRUNCATE = 1);

/// 静脉置管操作者
Property VeinOutPipeOper3 As %String(TRUNCATE = 1);

/// 静脉置管地点
Property VeinOutPipeAddr1 As %String(TRUNCATE = 1);

/// 静脉置管地点
Property VeinOutPipeAddr2 As %String(TRUNCATE = 1);

/// 静脉置管地点
Property VeinOutPipeAddr3 As %String(TRUNCATE = 1);

/// 感染日期
Property VeinInfDate1 As %String(TRUNCATE = 1);

/// 感染日期
Property VeinInfDate2 As %String(TRUNCATE = 1);

/// 感染日期
Property VeinInfDate3 As %String(TRUNCATE = 1);

/// 呼吸机导管类型
Property VenPipeType1 As %String(TRUNCATE = 1);

/// 呼吸机导管类型
Property VenPipeType2 As %String(TRUNCATE = 1);

/// 呼吸机导管类型
Property VenPipeType3 As %String(TRUNCATE = 1);

/// 呼吸机插管日期
Property VenPipeDate1 As %String(TRUNCATE = 1);

/// 呼吸机插管日期
Property VenPipeDate2 As %String(TRUNCATE = 1);

/// 呼吸机插管日期
Property VenPipeDate3 As %String(TRUNCATE = 1);

/// 呼吸机拔管日期
Property VenOutPipeDate1 As %String(TRUNCATE = 1);

/// 呼吸机拔管日期
Property VenOutPipeDate2 As %String(TRUNCATE = 1);

/// 呼吸机拔管日期
Property VenOutPipeDate3 As %String(TRUNCATE = 1);

/// 呼吸机插管操作者
Property VenPipeOpe1 As %String(TRUNCATE = 1);

/// 呼吸机插管操作者
Property VenPipeOpe2 As %String(TRUNCATE = 1);

/// 呼吸机插管操作者
Property VenPipeOpe3 As %String(TRUNCATE = 1);

/// 呼吸机置管地点
Property VenPipeAddr1 As %String(TRUNCATE = 1);

/// 呼吸机置管地点
Property VenPipeAddr2 As %String(TRUNCATE = 1);

/// 呼吸机置管地点
Property VenPipeAddr3 As %String(TRUNCATE = 1);

/// 呼吸机感染日期
Property VenInfDate1 As %String(TRUNCATE = 1);

/// 呼吸机感染日期
Property VenInfDate2 As %String(TRUNCATE = 1);

/// 呼吸机感染日期
Property VenInfDate3 As %String(TRUNCATE = 1);

/// 尿管导管类型
Property CathPipeType1 As %String(TRUNCATE = 1);

/// 尿管导管类型
Property CathPipeType2 As %String(TRUNCATE = 1);

/// 尿管导管类型
Property CathPipeType3 As %String(TRUNCATE = 1);

/// 尿管插管日期
Property CathPipeDate1 As %String(TRUNCATE = 1);

/// 尿管插管日期
Property CathPipeDate2 As %String(TRUNCATE = 1);

/// 尿管插管日期
Property CathPipeDate3 As %String(TRUNCATE = 1);

/// 尿管拔管日期
Property CathOutPipeDate1 As %String(TRUNCATE = 1);

/// 尿管拔管日期
Property CathOutPipeDate2 As %String(TRUNCATE = 1);

/// 尿管拔管日期
Property CathOutPipeDate3 As %String(TRUNCATE = 1);

/// 尿管插管操作者
Property CathPipeOpe1 As %String(TRUNCATE = 1);

/// 尿管插管操作者
Property CathPipeOpe2 As %String(TRUNCATE = 1);

/// 尿管插管操作者
Property CathPipeOpe3 As %String(TRUNCATE = 1);

/// 尿管置管地点
Property CathPipeAddr1 As %String(TRUNCATE = 1);

/// 尿管置管地点
Property CathPipeAddr2 As %String(TRUNCATE = 1);

/// 尿管置管地点
Property CathPipeAddr3 As %String(TRUNCATE = 1);

/// 尿管感染日期
Property CathInfDate1 As %String(TRUNCATE = 1);

/// 尿管感染日期
Property CathInfDate2 As %String(TRUNCATE = 1);

/// 尿管感染日期
Property CathInfDate3 As %String(TRUNCATE = 1);

/// Creator：    ZGZ
/// CreatDate：   2012-04-11
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.NINF.Aim.ICUReport
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..CRReportDR_separete
	set return=return_..InICUDate_separete
	set return=return_..OutICUDate_separete
	set return=return_..OutICUPlace_separete
	set return=return_..InICUDiag1_separete
	set return=return_..InICUDiag2_separete
	set return=return_..InICUDiag3_separete
	set return=return_..ICUDiag1_separete
	set return=return_..ICUDiag2_separete
	set return=return_..ICUDiag3_separete
	
	
	set return=return_..VeinCatheterType1_separete
	set return=return_..VeinCatheterType2_separete
	set return=return_..VeinCatheterType3_separete
	set return=return_..VeinCavityNum1_separete
	set return=return_..VeinCavityNum2_separete
	set return=return_..VeinCavityNum3_separete
	set return=return_..VeinCavityPos1_separete
	set return=return_..VeinCavityPos2_separete
    set return=return_..VeinCavityPos3_separete
	set return=return_..VeinPipeDate1_separete
	set return=return_..VeinPipeDate2_separete
	set return=return_..VeinPipeDate3_separete
	set return=return_..VeinOutPipeDate1_separete
	set return=return_..VeinOutPipeDate2_separete
	set return=return_..VeinOutPipeDate3_separete
	set return=return_..VeinOutPipeOper1_separete
	set return=return_..VeinOutPipeOper2_separete
	set return=return_..VeinOutPipeOper3_separete	
	set return=return_..VeinOutPipeAddr1_separete
	set return=return_..VeinOutPipeAddr2_separete
	set return=return_..VeinOutPipeAddr3_separete
	set return=return_..VeinInfDate1_separete
	set return=return_..VeinInfDate2_separete
	set return=return_..VeinInfDate3_separete
	
	set return=return_..VenPipeType1_separete
	set return=return_..VenPipeType2_separete
	set return=return_..VenPipeType3_separete
	set return=return_..VenPipeDate1_separete
	set return=return_..VenPipeDate2_separete
	set return=return_..VenPipeDate3_separete
	set return=return_..VenOutPipeDate1_separete
	set return=return_..VenOutPipeDate2_separete
	set return=return_..VenOutPipeDate3_separete
	
	set return=return_..VenPipeOpe1_separete
	set return=return_..VenPipeOpe2_separete
	set return=return_..VenPipeOpe3_separete
	set return=return_..VenPipeAddr1_separete
	set return=return_..VenPipeAddr2_separete
	set return=return_..VenPipeAddr3_separete
	set return=return_..VenInfDate1_separete
	set return=return_..VenInfDate2_separete
	set return=return_..VenInfDate3_separete
	set return=return_..CathPipeType1_separete
	set return=return_..CathPipeType2_separete
	set return=return_..CathPipeType3_separete
	set return=return_..CathPipeDate1_separete
	set return=return_..CathPipeDate2_separete
	set return=return_..CathPipeDate3_separete
	set return=return_..CathOutPipeDate1_separete
	set return=return_..CathOutPipeDate2_separete
	set return=return_..CathOutPipeDate3_separete
	set return=return_..CathPipeOpe1_separete
	set return=return_..CathPipeOpe2_separete
	set return=return_..CathPipeOpe3_separete
	set return=return_..CathPipeAddr1_separete
	set return=return_..CathPipeAddr2_separete
	set return=return_..CathPipeAddr3_separete
	set return=return_..CathInfDate1_separete
	set return=return_..CathInfDate2_separete
	set return=return_..CathInfDate3_separete
	
	quit return
}

/// Creator：     ZGZ
/// CreatDate：   2012-04-11
/// Description:  根据ID取ICU医院感染病例监测表对象
/// Table：       DHCMed.NINF.Aim.ICUReport
/// Input：       ID:    DHCMed.NINF.Aim.ICUReport.ID
///               separete: 指定的分隔符
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Aim.ICUReport).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.Aim.ICUReport
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Aim.ICUReport).%ExistsId(id) return
	set obj=##Class(DHCMed.NINF.Aim.ICUReport).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     ZGZ
/// CreatDate：   2012-04-11
/// Description:  根据ID取ICU医院感染病例监测表对象
/// Table：       DHCMed.NINF.Aim.ICUReport
/// Input：       id: DHCMed.NINF.Aim.ICURepor.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.NINF.Aim.ICUReport).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     ZGZ
/// CreatDate：   2012-04-11
/// Description:  更新ICU医院感染病例监测表
/// Table：       DHCMed.NINF.Aim.ICUReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// d ##class(DHCMed.NINF.Aim.ICUReport).Update(^2^3^4^^^^^^)
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.NINF.Aim.ICUReport).%New()
		} 
	else {
		set obj=##class(DHCMed.NINF.Aim.ICUReport).%OpenId(ID)
		}
	set obj.CRReportDR=$p(InStr,"^",2)
	set obj.InICUDate=$p(InStr,"^",3)
	set obj.OutICUDate=$p(InStr,"^",4)
	set obj.OutICUPlace=$p(InStr,"^",5)
	set obj.InICUDiag1=$p(InStr,"^",6)
	set obj.InICUDiag2=$p(InStr,"^",7)
	set obj.InICUDiag3=$p(InStr,"^",8)
	set obj.ICUDiag1 =$p(InStr,"^",9)
	set obj.ICUDiag2 =$p(InStr,"^",10)
	set obj.ICUDiag3 =$p(InStr,"^",11)

	set obj.VeinCatheterType1 =$p(InStr,"^",12)
	set obj.VeinCatheterType2 =$p(InStr,"^",13)
	set obj.VeinCatheterType3=$p(InStr,"^",14)
	set obj.VeinCavityNum1=$p(InStr,"^",15)
	set obj.VeinCavityNum2=$p(InStr,"^",16)
	set obj.VeinCavityNum3=$p(InStr,"^",17)
	set obj.VeinCavityPos1=$p(InStr,"^",18)
	set obj.VeinCavityPos2=$p(InStr,"^",19)
	set obj.VeinCavityPos3=$p(InStr,"^",20)
	set obj.VeinPipeDate1=$p(InStr,"^",21)
	set obj.VeinPipeDate2=$p(InStr,"^",22)
	set obj.VeinPipeDate3=$p(InStr,"^",23)
	
	set obj.VeinPipeDate1=$tr(obj.VeinPipeDate1,"年","-")
	set obj.VeinPipeDate1=$tr(obj.VeinPipeDate1,"月","-")
	set obj.VeinPipeDate1=$tr(obj.VeinPipeDate1,"日","")
	set obj.VeinPipeDate2=$tr(obj.VeinPipeDate2,"年","-")
	set obj.VeinPipeDate2=$tr(obj.VeinPipeDate2,"月","-")
	set obj.VeinPipeDate2=$tr(obj.VeinPipeDate2,"日","")
	set obj.VeinPipeDate3=$tr(obj.VeinPipeDate3,"年","-")
	set obj.VeinPipeDate3=$tr(obj.VeinPipeDate3,"月","-")
	set obj.VeinPipeDate3=$tr(obj.VeinPipeDate3,"日","")
	
	set obj.VeinOutPipeDate1=$p(InStr,"^",24)
	set obj.VeinOutPipeDate2=$p(InStr,"^",25)
	set obj.VeinOutPipeDate3=$p(InStr,"^",26)
	
	set obj.VeinOutPipeDate1=$tr(obj.VeinOutPipeDate1,"年","-")
	set obj.VeinOutPipeDate1=$tr(obj.VeinOutPipeDate1,"月","-")
	set obj.VeinOutPipeDate1=$tr(obj.VeinOutPipeDate1,"日","")
	set obj.VeinOutPipeDate2=$tr(obj.VeinOutPipeDate2,"年","-")
	set obj.VeinOutPipeDate2=$tr(obj.VeinOutPipeDate2,"月","-")
	set obj.VeinOutPipeDate2=$tr(obj.VeinOutPipeDate2,"日","")
	set obj.VeinOutPipeDate3=$tr(obj.VeinOutPipeDate3,"年","-")
	set obj.VeinOutPipeDate3=$tr(obj.VeinOutPipeDate3,"月","-")
	set obj.VeinOutPipeDate3=$tr(obj.VeinOutPipeDate3,"日","")
	
	set obj.VeinOutPipeOper1=$p(InStr,"^",27)
	set obj.VeinOutPipeOper2=$p(InStr,"^",28)
	set obj.VeinOutPipeOper3=$p(InStr,"^",29)
	set obj.VeinOutPipeAddr1=$p(InStr,"^",30)
	set obj.VeinOutPipeAddr2=$p(InStr,"^",31)
	set obj.VeinOutPipeAddr3=$p(InStr,"^",32)
	
	set obj.VeinInfDate1=$p(InStr,"^",33)
	set obj.VeinInfDate2=$p(InStr,"^",34)
	set obj.VeinInfDate3=$p(InStr,"^",35)
	set obj.VenPipeType1=$p(InStr,"^",36)
	set obj.VenPipeType2=$p(InStr,"^",37)
	set obj.VenPipeType3=$p(InStr,"^",38)
	set obj.VenPipeDate1=$p(InStr,"^",39)
	set obj.VenPipeDate2=$p(InStr,"^",40)
	set obj.VenPipeDate3=$p(InStr,"^",41)
	
	set obj.VenPipeDate1=$tr(obj.VenPipeDate1,"年","-")
	set obj.VenPipeDate1=$tr(obj.VenPipeDate1,"月","-")
	set obj.VenPipeDate1=$tr(obj.VenPipeDate1,"日","")
	set obj.VenPipeDate2=$tr(obj.VenPipeDate2,"年","-")
	set obj.VenPipeDate2=$tr(obj.VenPipeDate2,"月","-")
	set obj.VenPipeDate2=$tr(obj.VenPipeDate2,"日","")
	set obj.VenPipeDate3=$tr(obj.VenPipeDate3,"年","-")
	set obj.VenPipeDate3=$tr(obj.VenPipeDate3,"月","-")
	set obj.VenPipeDate3=$tr(obj.VenPipeDate3,"日","")
	
	set obj.VenOutPipeDate1=$p(InStr,"^",42)
	set obj.VenOutPipeDate2=$p(InStr,"^",43)
	set obj.VenOutPipeDate3=$p(InStr,"^",44)
	
	set obj.VenOutPipeDate1=$tr(obj.VenOutPipeDate1,"年","-")
	set obj.VenOutPipeDate1=$tr(obj.VenOutPipeDate1,"月","-")
	set obj.VenOutPipeDate1=$tr(obj.VenOutPipeDate1,"日","")
	set obj.VenOutPipeDate2=$tr(obj.VenOutPipeDate2,"年","-")
	set obj.VenOutPipeDate2=$tr(obj.VenOutPipeDate2,"月","-")
	set obj.VenOutPipeDate2=$tr(obj.VenOutPipeDate2,"日","")
	set obj.VenOutPipeDate3=$tr(obj.VenOutPipeDate3,"年","-")
	set obj.VenOutPipeDate3=$tr(obj.VenOutPipeDate3,"月","-")
	set obj.VenOutPipeDate3=$tr(obj.VenOutPipeDate3,"日","")
	
	set obj.VenPipeOpe1=$p(InStr,"^",45)
	set obj.VenPipeOpe2=$p(InStr,"^",46)
	set obj.VenPipeOpe3=$p(InStr,"^",47)
	set obj.VenPipeAddr1=$p(InStr,"^",48)
	set obj.VenPipeAddr2=$p(InStr,"^",49)
	set obj.VenPipeAddr3=$p(InStr,"^",50)
	set obj.VenInfDate1=$p(InStr,"^",51)
	set obj.VenInfDate2=$p(InStr,"^",52)
	set obj.VenInfDate3=$p(InStr,"^",53)
	set obj.CathPipeType1=$p(InStr,"^",54)
	set obj.CathPipeType2=$p(InStr,"^",55)
	set obj.CathPipeType3=$p(InStr,"^",56)
	set obj.CathPipeDate1=$p(InStr,"^",57)
	set obj.CathPipeDate2=$p(InStr,"^",58)
	set obj.CathPipeDate3=$p(InStr,"^",59)
	
	set obj.CathPipeDate1=$tr(obj.CathPipeDate1,"年","-")
	set obj.CathPipeDate1=$tr(obj.CathPipeDate1,"月","-")
	set obj.CathPipeDate1=$tr(obj.CathPipeDate1,"日","")
	set obj.CathPipeDate2=$tr(obj.CathPipeDate2,"年","-")
	set obj.CathPipeDate2=$tr(obj.CathPipeDate2,"月","-")
	set obj.CathPipeDate2=$tr(obj.CathPipeDate2,"日","")
	set obj.CathPipeDate3=$tr(obj.CathPipeDate3,"年","-")
	set obj.CathPipeDate3=$tr(obj.CathPipeDate3,"月","-")
	set obj.CathPipeDate3=$tr(obj.CathPipeDate3,"日","")
	
	set obj.CathOutPipeDate1=$p(InStr,"^",60)
	set obj.CathOutPipeDate2=$p(InStr,"^",61)
	set obj.CathOutPipeDate3=$p(InStr,"^",62)
	
	set obj.CathOutPipeDate1=$tr(obj.CathOutPipeDate1,"年","-")
	set obj.CathOutPipeDate1=$tr(obj.CathOutPipeDate1,"月","-")
	set obj.CathOutPipeDate1=$tr(obj.CathOutPipeDate1,"日","")
	set obj.CathOutPipeDate2=$tr(obj.CathOutPipeDate2,"年","-")
	set obj.CathOutPipeDate2=$tr(obj.CathOutPipeDate2,"月","-")
	set obj.CathOutPipeDate2=$tr(obj.CathOutPipeDate2,"日","")
	set obj.CathOutPipeDate3=$tr(obj.CathOutPipeDate3,"年","-")
	set obj.CathOutPipeDate3=$tr(obj.CathOutPipeDate3,"月","-")
	set obj.CathOutPipeDate3=$tr(obj.CathOutPipeDate3,"日","")
	
	set obj.CathPipeOpe1=$p(InStr,"^",63)
	set obj.CathPipeOpe2=$p(InStr,"^",64)
	set obj.CathPipeOpe3=$p(InStr,"^",65)
	set obj.CathPipeAddr1=$p(InStr,"^",66)
	set obj.CathPipeAddr2=$p(InStr,"^",67)
	set obj.CathPipeAddr3=$p(InStr,"^",68)
	set obj.CathInfDate1=$p(InStr,"^",69)
	set obj.CathInfDate2=$p(InStr,"^",70)
	set obj.CathInfDate3=$p(InStr,"^",71)
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：    ZGZ
/// CreatDate：   2012-04-11
/// Description:  删除ICU医院感染病例监测表
/// Table：       DHCMed.NINF.Aim.ICUReport
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.NINF.Aim.ICUReport).%DeleteId(_Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// w ##class(DHCMed.NINF.Aim.ICUReport).UpdateDataFromEPR(1)
ClassMethod UpdateDataFromEPR(CRReportDR As %String) As %String
{
	n (CRReportDR)
	
	s ret=-1
	
	q:(CRReportDR="") ret
	s RepID=""
	i $d(^DHCMed.NINF.Aim.ICUReportI("CRReportDR"," "_CRReportDR)) d
	.s RepID=$o(^DHCMed.NINF.Aim.ICUReportI("CRReportDR"," "_CRReportDR,""),-1)
	
	s objCRReport=##class(DHCMed.CR.Report).%OpenId(CRReportDR)
	q:'$IsObject(objCRReport) ret
	s EpisodeID=objCRReport.EpisodeID
	s InstanceDataID=objCRReport.InstanceID
	q:(EpisodeID="")||(InstanceDataID="") ret
	
	s TIDValue=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("InfICUTIDValue","")
	q:TIDValue="" $$$OK
	
	s tmp = RepID
	s tmp = tmp _ "^" _ CRReportDR
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"转入ICU日期/时间D0006#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0006#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"转出ICU日期/时间D0007#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0007#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"转出至I0008#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0008#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"转入ICU的诊断1I0010#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0010#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"转入ICU的诊断2I0011#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0011#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"转入ICU的诊断3I0012#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0012#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"ICU的诊断1I0013#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0013#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"ICU的诊断2I0014#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0014#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"ICU的诊断3I0015#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0015#VTYPE:V",InstanceDataID)
	
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉导管类型1.O0065#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0065#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉导管类型2.O0066#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0066#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉导管类型3.O0067#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0067#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉导管腔数1.O0068#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0068#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉导管腔数2.O0069#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0069#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉导管腔数3.O0070#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0070#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉部位1.O0071#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0071#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉部位2.O0072#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0072#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉部位3.O0073#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0073#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉插管日期1.D0074#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0074#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉插管日期2.D0075#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0075#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉插管日期3.D0076#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0076#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉拔管或转出日期1.D0077#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0077#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉插管或转出日期2.D0079#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0079#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉插管或转出日期3.D0078#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0078#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉插管操作者1.O0080#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0080#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉插管操作者2.O0081#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0081#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉插管操作者3.O0082#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0082#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉置管地点1.O0083#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0083#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉置管地点2.O0084#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0084#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉置管地点3.O0085#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0085#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉感染日期1.D0123#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0123#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉感染日期2.D0124#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0124#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"静脉感染日期3.D0125#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0125#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机导管类型1.O0086#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0086#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机导管类型2.O0087#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0087#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机导管类型3.O0088#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0088#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机插管日期1.D0089#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0089#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机插管日期2.D0091#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0091#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机插管日期3.D0090#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0090#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机拔管或转出日期1.D0092#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0092#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机拔管或转出日期2.D0093#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0093#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机拔管或转出日期3.D0094#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0094#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机插管操作者1.O0095#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0095#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机插管操作者2.O0096#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0096#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机插管操作者3.O0097#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0097#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机置管地点1.O0098#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0098#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机置管地点2.O0099#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0099#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机置管地点3.O0100#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0100#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机感染日期1.D0129#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0129#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机感染日期2.D0130#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0130#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"呼吸机感染日期3.D0131#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0131#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管导管类型1.O0101#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0101#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管导管类型2.O0102#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0102#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管导管类型3.O0103#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0103#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管插管日期1.D0104#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0104#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管插管日期2.D0105#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0105#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管插管日期3.D0106#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0106#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管拔管或转出日期1.D0107#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0107#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管拔管或转出日期2.D0109#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0109#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管拔管或转出日期3.D0110#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0110#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管插管操作者1.O0111#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0111#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管插管操作者2.O0112#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0112#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管插管操作者3.O0113#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0113#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管置管地点1.O0114#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0114#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管置管地点2.O0115#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0115#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管置管地点3.O0116#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0116#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管感染日期1.D0139#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0139#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管感染日期2.D0140#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0140#VTYPE:V",InstanceDataID)
	s tmp = tmp _ "^" _..GetDataFromEPR(EpisodeID,"尿管感染日期3.D0141#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0141#VTYPE:V",InstanceDataID)
	
	s ret=..Update(tmp)
	
	q ret
}

ClassMethod GetDataFromEPR(EpisodeID As %String, ItemPara As %String, InstanceDataID As %String) As %String
{
	n (EpisodeID, ItemPara ,InstanceDataID)
	
	s ret=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID, ItemPara ,InstanceDataID)
	
	q ret
}

Storage Default
{
<Data name="ICUReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ICUDiag</Value>
</Value>
<Value name="3">
<Value>ICUInfType</Value>
</Value>
<Value name="4">
<Value>InICUDiag</Value>
</Value>
<Value name="5">
<Value>InPipeDate</Value>
</Value>
<Value name="6">
<Value>InfDate</Value>
</Value>
<Value name="7">
<Value>InfPos</Value>
</Value>
<Value name="8">
<Value>InfReason</Value>
</Value>
<Value name="9">
<Value>Infection</Value>
</Value>
<Value name="10">
<Value>Operation</Value>
</Value>
<Value name="11">
<Value>OperationDCDR</Value>
</Value>
<Value name="12">
<Value>OperationDate</Value>
</Value>
<Value name="13">
<Value>OperationName</Value>
</Value>
<Value name="14">
<Value>OutPipeDate</Value>
</Value>
<Value name="15">
<Value>PaadmDR</Value>
</Value>
<Value name="16">
<Value>PathDate1</Value>
</Value>
<Value name="17">
<Value>PathDate2</Value>
</Value>
<Value name="18">
<Value>Result1</Value>
</Value>
<Value name="19">
<Value>Result2</Value>
</Value>
<Value name="20">
<Value>Sample1</Value>
</Value>
<Value name="21">
<Value>Sample2</Value>
</Value>
<Value name="22">
<Value>TransSubID</Value>
</Value>
<Value name="23">
<Value>Treatment</Value>
</Value>
<Value name="24">
<Value>WeekFourA</Value>
</Value>
<Value name="25">
<Value>symptom</Value>
</Value>
<Value name="26">
<Value>ICUInfDate</Value>
</Value>
<Value name="27">
<Value>ICUDiag1</Value>
</Value>
<Value name="28">
<Value>ICUDiag2</Value>
</Value>
<Value name="29">
<Value>ICUDiag3</Value>
</Value>
<Value name="30">
<Value>InICUDiag1</Value>
</Value>
<Value name="31">
<Value>InICUDiag2</Value>
</Value>
<Value name="32">
<Value>InICUDiag3</Value>
</Value>
<Value name="33">
<Value>InstanceDataID</Value>
</Value>
<Value name="34">
<Value>InICUDate</Value>
</Value>
<Value name="35">
<Value>InICUTime</Value>
</Value>
<Value name="36">
<Value>OutICUDate</Value>
</Value>
<Value name="37">
<Value>OutICUTime</Value>
</Value>
<Value name="38">
<Value>PipeDay</Value>
</Value>
<Value name="39">
<Value>OutPipeByCutDate</Value>
</Value>
<Value name="40">
<Value>OutPipeByMouthDate</Value>
</Value>
<Value name="41">
<Value>OutPipeByNoseDate</Value>
</Value>
<Value name="42">
<Value>PipeByCutDate</Value>
</Value>
<Value name="43">
<Value>PipeByMouthDate</Value>
</Value>
<Value name="44">
<Value>PipeByNoseDate</Value>
</Value>
<Value name="45">
<Value>OutHosptial</Value>
</Value>
<Value name="46">
<Value>OutICUPlace</Value>
</Value>
<Value name="47">
<Value>OperationDocDR</Value>
</Value>
<Value name="48">
<Value>OutICUPipe</Value>
</Value>
<Value name="49">
<Value>OutICUPipeType</Value>
</Value>
<Value name="50">
<Value>CatOutPipeDate</Value>
</Value>
<Value name="51">
<Value>CatPipeDate</Value>
</Value>
<Value name="52">
<Value>VenOutPipeDate</Value>
</Value>
<Value name="53">
<Value>VenPipeDate</Value>
</Value>
<Value name="54">
<Value>CRReportDR</Value>
</Value>
<Value name="55">
<Value>VeinCatheterType1</Value>
</Value>
<Value name="56">
<Value>VeinCatheterType2</Value>
</Value>
<Value name="57">
<Value>VeinCatheterType3</Value>
</Value>
<Value name="58">
<Value>VeinCavityNum1</Value>
</Value>
<Value name="59">
<Value>VeinCavityNum2</Value>
</Value>
<Value name="60">
<Value>VeinCavityNum3</Value>
</Value>
<Value name="61">
<Value>VeinCavityPos1</Value>
</Value>
<Value name="62">
<Value>VeinCavityPos2</Value>
</Value>
<Value name="63">
<Value>VeinCavityPos3</Value>
</Value>
<Value name="64">
<Value>VeinPipeDate1</Value>
</Value>
<Value name="65">
<Value>VeinPipeDate2</Value>
</Value>
<Value name="66">
<Value>VeinPipeDate3</Value>
</Value>
<Value name="67">
<Value>VeinOutPipeDate1</Value>
</Value>
<Value name="68">
<Value>VeinOutPipeDate2</Value>
</Value>
<Value name="69">
<Value>VeinOutPipeDate3</Value>
</Value>
<Value name="70">
<Value>VeinOutPipeOper1</Value>
</Value>
<Value name="71">
<Value>VeinOutPipeOper2</Value>
</Value>
<Value name="72">
<Value>VeinOutPipeOper3</Value>
</Value>
<Value name="73">
<Value>VeinOutPipeAddr1</Value>
</Value>
<Value name="74">
<Value>VeinOutPipeAddr2</Value>
</Value>
<Value name="75">
<Value>VeinOutPipeAddr3</Value>
</Value>
<Value name="76">
<Value>VeinInfDate1</Value>
</Value>
<Value name="77">
<Value>VeinInfDate2</Value>
</Value>
<Value name="78">
<Value>VeinInfDate3</Value>
</Value>
<Value name="79">
<Value>VenPipeType1</Value>
</Value>
<Value name="80">
<Value>VenPipeType2</Value>
</Value>
<Value name="81">
<Value>VenPipeType3</Value>
</Value>
<Value name="82">
<Value>VenPipeDate1</Value>
</Value>
<Value name="83">
<Value>VenPipeDate2</Value>
</Value>
<Value name="84">
<Value>VenPipeDate3</Value>
</Value>
<Value name="85">
<Value>VenOutPipeDate1</Value>
</Value>
<Value name="86">
<Value>VenOutPipeDate2</Value>
</Value>
<Value name="87">
<Value>VenOutPipeDate3</Value>
</Value>
<Value name="88">
<Value>VenPipeOpe1</Value>
</Value>
<Value name="89">
<Value>VenPipeOpe2</Value>
</Value>
<Value name="90">
<Value>VenPipeOpe3</Value>
</Value>
<Value name="91">
<Value>VenPipeAddr1</Value>
</Value>
<Value name="92">
<Value>VenPipeAddr2</Value>
</Value>
<Value name="93">
<Value>VenPipeAddr3</Value>
</Value>
<Value name="94">
<Value>VenInfDate1</Value>
</Value>
<Value name="95">
<Value>VenInfDate2</Value>
</Value>
<Value name="96">
<Value>VenInfDate3</Value>
</Value>
<Value name="97">
<Value>CathPipeType1</Value>
</Value>
<Value name="98">
<Value>CathPipeType2</Value>
</Value>
<Value name="99">
<Value>CathPipeType3</Value>
</Value>
<Value name="100">
<Value>CathPipeDate1</Value>
</Value>
<Value name="101">
<Value>CathPipeDate2</Value>
</Value>
<Value name="102">
<Value>CathPipeDate3</Value>
</Value>
<Value name="103">
<Value>CathOutPipeDate1</Value>
</Value>
<Value name="104">
<Value>CathOutPipeDate2</Value>
</Value>
<Value name="105">
<Value>CathOutPipeDate3</Value>
</Value>
<Value name="106">
<Value>CathPipeOpe1</Value>
</Value>
<Value name="107">
<Value>CathPipeOpe2</Value>
</Value>
<Value name="108">
<Value>CathPipeOpe3</Value>
</Value>
<Value name="109">
<Value>CathPipeAddr1</Value>
</Value>
<Value name="110">
<Value>CathPipeAddr2</Value>
</Value>
<Value name="111">
<Value>CathPipeAddr3</Value>
</Value>
<Value name="112">
<Value>CathInfDate1</Value>
</Value>
<Value name="113">
<Value>CathInfDate2</Value>
</Value>
<Value name="114">
<Value>CathInfDate3</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.ICUReportD</DataLocation>
<DefaultData>ICUReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.ICUReportD</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.ICUReportI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.ICUReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
