/// creator:郭荣勇
/// date:2016-05-03
/// desc:医生站本地化参数设置,按医院区分,需要在terminal下执行才能生效
Class DHCDoc.Local.SysParams Extends DHCDoc.Util.RegisteredObject
{

/// d ##class(DHCDoc.Local.SysParams).SetSysParams()
ClassMethod SetSysParams()
{
	;APP的前一天的21:00点可以可以查询当日挂号资源
	s ^DHCDocLocalSysP("APP.Tomorrow.RegTime")=..%ZTH("21:00")
	;自助机的前一天的22:00点可以可以查询当日挂号资源
	s ^DHCDocLocalSysP("Self.Tomorrow.RegTime")=..%ZTH("22:00")
}

/// tanjishan
/// 设置一键打印中电子病历相关数据集
/// d ##class(DHCDoc.Local.SysParams).SetSysEMRInfo()
ClassMethod SetSysEMRInfo()
{
	///==============疾病诊断证明数据集
	///疾病诊断证明书签字人
	s ^DHCDocLocalSysP("EMR","EMRCertificateUserName")="HDSD00.03.504"
	////工作单位
    s ^DHCDocLocalSysP("EMR","EMRCertificateGZDW")="HDSD00.03.501"
    ////临床诊断
    s ^DHCDocLocalSysP("EMR","EMRCertificateLCZD")="HDSD00.03.502"
    ////临床建议
    s ^DHCDocLocalSysP("EMR","EMRCertificateLCJY")="HDSD00.03.503"
    ////日期
    s ^DHCDocLocalSysP("EMR","EMRCertificateRQ")="HDSD00.03.505"
	
	///=============复诊病例数据集
	///复诊病历签字人
	s ^DHCDocLocalSysP("EMR","OPEMRReturnUserName")="HDSD00.03.041"
	///复诊内容
	s ^DHCDocLocalSysP("EMR","OPEMRReturnFZNR")="HDSD00.03.241"
	///处置
	s ^DHCDocLocalSysP("EMR","OPEMRReturnCZ")="HDSD00.03.043"
	
	///=============门诊病历数据集
	///门诊病历签字人
	s ^DHCDocLocalSysP("EMR","OPEMRUserName")="HDSD00.03.041"
	////主诉
    s ^DHCDocLocalSysP("EMR","OPEMRUserZS")="HDSD00.03.057"
    ////病史
    s ^DHCDocLocalSysP("EMR","OPEMRUserBS")="HDSD00.03.038"
    ////体格检查
    s ^DHCDocLocalSysP("EMR","OPEMRUserTGJC")="HDSD00.03.037"
    ////实验室检查 
    s ^DHCDocLocalSysP("EMR","OPEMRUserSYSJC")="HDSD00.03.012"
    ////处理       
    s ^DHCDocLocalSysP("EMR","OPEMRUserCL")="HDSD00.03.242"

    ///
	
	Q
}

/// 信息总览中关于患者诊疗信息的数据源配置
/// d ##class(DHCDoc.Local.SysParams).SetOrderClassify()
ClassMethod SetOrderClassify()
{
	s ^DHCDocConfig("OrderClassify","Diet")="饮食"
	s ^DHCDocConfig("OrderClassify","TendOrd")="护理"
	s ^DHCDocConfig("OrderClassify","Drainage")="引流"
	s ^DHCDocConfig("OrderClassify","EkgOrd")="心电监测"
}

/// 初始化服务开关(调用服务之前需初始化一次，在服务超时时设置开关关闭)
/// SoapCode：服务Code、Switch：开关标识(1/0)、SoapDesc：服务描述
/// d ##class(DHCDoc.Local.SysParams).InitSoapServerSwitch()
ClassMethod InitSoapServerSwitch(SoapCode, Switch, SoapDesc, TimeOut = "2")
{
	;^DHCDocSoapServer("Switch","服务Code")=$lb("服务描述","开关标识","超时时间",错误描述)
	s ^DHCDocSoapServer("Switch",SoapCode)=$lb(SoapDesc,Switch,TimeOut,"") 
	q ""
}

/// 设置服务开关(调用服务之前需初始化一次，在服务超时时设置开关关闭)
/// d ##class(DHCDoc.Local.SysParams).SetSoapServerSwitch()
ClassMethod SetSoapServerSwitch(SoapCode, Switch, ErrMsg = "")
{
	q:$d(^DHCDocSoapServer("Switch",SoapCode))=0 ""
	s $li(^DHCDocSoapServer("Switch",SoapCode),2)=Switch
	s ErrMsg=$zdt($h,8,1)_":"_ErrMsg
	s $li(^DHCDocSoapServer("Switch",SoapCode),4)=ErrMsg
	q ""
}

/// 得到服务开关(没设置过返回开启)
/// output:1/0:开启/关闭
/// d ##class(DHCDoc.Local.SysParams).GetSoapServerSwitch()
ClassMethod GetSoapServerSwitch(SoapCode)
{
	q:$d(^DHCDocSoapServer("Switch",SoapCode))=0 1
	s Switch=$lg(^DHCDocSoapServer("Switch",SoapCode),2)
	q Switch
}

}
