/// CTOR: QP
/// DATE: 2020-08-24
/// DESC: 患者生命体征信息
Class DHCDoc.Chemo.Model.VSInfo Extends %RegisteredObject
{

/// 采集日期
Property CareDate As %String;

/// 采集时间
Property CareTime As %String;

/// 体温(℃)	
Property Temprature As %String;

/// 脉搏(次/分)
Property Pulse As %String;

/// 呼吸
Property Breath As %String;

/// 血氧(%)
Property SPO2 As %String;

/// 血压(mmHg)
Property BloodPressure As %String;

/// 身高(cm)
Property Height As %String;

/// 体重(kg)
Property Weight As %String;

/// BMI
Property BMI As %String;

/// BSA
Property BSA As %String;

/// 科室
Property LocDesc As %String;

/// W ##class(DHCDoc.Chemo.Model.VSInfo).GetOBJ(397)
ClassMethod GetOBJ(EpisodeID, PAAdmType = "") As DHCDoc.Chemo.Model.VSInfo
{
	S MObj=##class(DHCDoc.Chemo.Model.VSInfo).%New()
	Q:EpisodeID="" MObj
	i PAAdmType="" s PAAdmType=$p(^PAADM(EpisodeID),"^",2)
	Q:PAAdmType="" MObj
	i PAAdmType="O" {
		s OResult=##class(NurMp.CustomingConfig).getLastTempratureData(EpisodeID)
		q:OResult="" MObj
		s PList=##class(DHCDoc.Chemo.COM.Func).GetClassPropertyList("DHCDoc.Chemo.Model.VSInfo",0)
		f i=1:1:$l(OResult,"^") {
			s cInfo=$p(OResult,"^",i)
			s cName=$p(cInfo,"@",1)
			s cValue=$P(cInfo,"@",2)
			continue:PList'[cName
			s $ZOBJPROPERTY(MObj, cName)=cValue
		}
	} else {
		s Temperature=##Class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"Temperature")	
		s Weight=##Class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"Weight")
		s height=##Class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"height")
		s Pulse=##Class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"Pulse")
		S MObj.Temprature=Temperature
		S MObj.Height=height
		S MObj.Weight=Weight
		S MObj.Pulse=Pulse
		
	}
	
	Q MObj
}

}
