Class DHCIntergration.OBLDApply Extends %RegisteredObject
{

ClassMethod SendApply(AppNo As %String) As %String
{
	//^DHCBLDAPPFORM(20110110001,"P") = 
	//"\t002\男\35岁\1975-04-06\\\80\170\11/12\0\0\\0802床\0000143502\76813\\\13920365985\\汉族\8\\肝大\\\\" 
    //DBAF_PatType_DR\姓名\性别\年龄\出生日期\DBAF_PatType_DR\PatApanage\体重\身高\血压\脉搏\体温\病区\床位\登记号\就诊号\国籍\地址\电话\手机\PatPeople\科室\诊断dr\诊断\房间\abo血型\rh\其它血型
    s AdmInfo=..GetAdmInfoNew(AppNo)
    i '$l(AdmInfo) q "无病人信息"
    //申请单附加信息 
    s ExtraInfo=""
    s $p(ExtraInfo,$c(2),1)=""
}

ClassMethod GetAdmInfoOld(AppNo As %String) As %String
{
	s PatInfo=$g(^DHCBldRequest($p(AppNo,"||",1),$p(AppNo,"||",2)))
	i '$l(PatInfo) q ""
	//^DHCBldReqOrd("00050181",1,1)=11702||26^LAB00010788||B002^备全血(AB型)^200ML^61758^60461^10327
	s seq=$o(^DHCBldReqOrd($p(AppNo,"||",1),$p(AppNo,"||",2),""))
	i '$l(seq) q ""
	s OrdId=$p(^DHCBldReqOrd($p(AppNo,"||",1),$p(AppNo,"||",2),seq),"^",1)
	s AdmDr=$p(^OEORD(+OrdId),"^",1)
	s PapmiDr=$p(^PAADM(AdmDr),"^",1)
	s AdmType=$p(^PAADM(AdmDr),"^",2)
	s WardDr=$p(^PAADM(AdmDr),"^",70)
	s (WardCode,WardDesc)=""
	i $l(WardDr),$d(^PAWARD(WardDr)) d
	.s WardCode=$p(^PAWARD(WardDr),"^",1)
	.s WardDesc=$p(^PAWARD(WardDr),"^",2)
	s PatName=$p(^PAPER(PapmiDr,"ALL"),"^",1)
	s DOB=$p(^PAPER(PapmiDr,"ALL"),"^",6)
	s SexDr=$p(^PAPER(PapmiDr,"ALL"),"^",7)
	s Sex=""
	i $l(SexDr),$d(^CT("SEX",SexDr)) s Sex=$p(^CT("SEX",SexDr),"^",1)
	
	s $p(AdmInfo,$c(2),1)=$p(AppNo,"||",1) //登记号
	s $p(AdmInfo,$c(2),2)=AdmType  //就诊类型
    s $p(AdmInfo,$c(2),3)=PatName  //姓名
    s $p(AdmInfo,$c(2),4)=Sex  //性别
    s $p(AdmInfo,$c(2),5)=DOB //生日
    s $p(AdmInfo,$c(2),6)=""  //年龄
    s $p(AdmInfo,$c(2),7)=""  //身份证
    s $p(AdmInfo,$c(2),8)=$p(PatInfo,"\",4)  //属地
    s $p(AdmInfo,$c(2),9)=""  //体重
    s $p(AdmInfo,$c(2),10)=""  //身高
    s $p(AdmInfo,$c(2),11)=""  //血压
    s $p(AdmInfo,$c(2),12)=""  //脉搏
    s $p(AdmInfo,$c(2),13)=""  //体温
    s $p(AdmInfo,$c(2),14)=WardDesc  //病区
    s $p(AdmInfo,$c(2),15)=""  //床位
    s $p(AdmInfo,$c(2),16)=""  //国籍
    s $p(AdmInfo,$c(2),17)=""  //家庭住址
    s $p(AdmInfo,$c(2),18)=""  //联系电话
    s $p(AdmInfo,$c(2),19)=""  //移动电话
    s $p(AdmInfo,$c(2),20)=""  //民族
    s $p(AdmInfo,$c(2),21)=""  //申请科室
    s $p(AdmInfo,$c(2),22)=""  //诊断描述
}

ClassMethod GetAdmInfoNew(AppNo As %String) As %String
{
	
    s PatInfo=$g(^DHCBLDAPPFORM(AppNo,"P"))
    i '$l(PatInfo) q ""
    s $p(AdmInfo,$c(2),1)=$p(PatInfo,"\",15) //登记号
    s $p(AdmInfo,$c(2),2)=$p(PatInfo,"\",1)  //就诊类型
    s $p(AdmInfo,$c(2),3)=$p(PatInfo,"\",2)  //姓名
    s $p(AdmInfo,$c(2),4)=$p(PatInfo,"\",3)  //性别
    s $p(AdmInfo,$c(2),5)=$p(PatInfo,"\",5)  //生日
    s $p(AdmInfo,$c(2),6)=$p(PatInfo,"\",4)  //年龄
    s $p(AdmInfo,$c(2),7)=$p(PatInfo,"\",6)  //身份证
    s $p(AdmInfo,$c(2),8)=$p(PatInfo,"\",7)  //属地
    s $p(AdmInfo,$c(2),9)=$p(PatInfo,"\",8)  //体重
    s $p(AdmInfo,$c(2),10)=$p(PatInfo,"\",9)  //身高
    s $p(AdmInfo,$c(2),11)=$p(PatInfo,"\",10)  //血压
    s $p(AdmInfo,$c(2),12)=$p(PatInfo,"\",11)  //脉搏
    s $p(AdmInfo,$c(2),13)=$p(PatInfo,"\",12)  //体温
    s $p(AdmInfo,$c(2),14)=$p(PatInfo,"\",13)  //病区
    s $p(AdmInfo,$c(2),15)=$p(PatInfo,"\",14)  //床位
    s $p(AdmInfo,$c(2),16)=$p(PatInfo,"\",17)  //国籍
    s $p(AdmInfo,$c(2),17)=$p(PatInfo,"\",18)  //家庭住址
    s $p(AdmInfo,$c(2),18)=$p(PatInfo,"\",19)  //联系电话
    s $p(AdmInfo,$c(2),19)=$p(PatInfo,"\",20)  //移动电话
    s $p(AdmInfo,$c(2),20)=$p(PatInfo,"\",21)  //民族
    s $p(AdmInfo,$c(2),21)=$p(PatInfo,"\",22)  //申请科室
    s $p(AdmInfo,$c(2),22)=$p(PatInfo,"\",24)  //诊断描述
    Quit
}

/// 发送备血申请单
/// AppNo:申请单号 xml
/// AdmInfo:病人信息 xml
/// ExtraInfo:申请单附加信息 xml
/// OrderSets:备血信息
/// AppPurpose:备血目的
/// AppType:备血类型
/// LabResult:检验结果
/// SelfInfo:自体血信息
ClassMethod SendToBloodBank(AppNo As %String, AdmInfo As %String, ExtraInfo As %String, OrderSets As %String, AppPurpose As %String, AppType As %String, LabResult As %String, SelfInfo As %String) As %String
{
}

}
