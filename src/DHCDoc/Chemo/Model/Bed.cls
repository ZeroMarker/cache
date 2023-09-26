/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 床位模板
Class DHCDoc.Chemo.Model.Bed Extends DHCDoc.Util.RegisteredObject
{

/// 类型
Property BType As %String;

/// 地址
Property BAddress As %String;

/// 药品
Property BDrugList As %String;

/// 常用科室
Property BComLoc As %String;

/// 其余科室
Property BOtherLoc As %String;

/// 录入人
Property BEditUser As %String;

/// 化疗方案
Property BPlanDR As %String;

/// 化疗方案名称
Property BPlanName As %String;

/// w ##class(DHCDoc.Chemo.Model.Bed).GetInfo(1731)
ClassMethod GetInfo(ID) As DHCDoc.Chemo.Model.Bed
{
	S MObj=##class(DHCDoc.Chemo.Model.Bed).%New()
	Q:ID="" MObj
	s langid=..%LanguageID()
	S DObj=##class(User.ChemoBed).%OpenId(ID)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.BAddress=DObj.BAddress
	S MObj.BType=DObj.BType
	S MObj.BDrugList=DObj.BDrugList
	S AdmLoc = DObj.BAdmLocGetObjectId()
	S MObj.BPlanDR=DObj.BPlanDRGetObjectId()
	
	i MObj.BPlanDR'="" {
		s AdmLoc=$p(^BS.DOC.Chemo.PlanD(MObj.BPlanDR),"^",4)
		s MObj.BOtherLoc=AdmLoc
		s BPlanName=$p(^BS.DOC.Chemo.PlanD(MObj.BPlanDR),"^",2)
		s MObj.BPlanName=##class(User.ChemoTemplate).GetTranByDesc("TPName",BPlanName,langid)
	}

	
	Q MObj
}

}
