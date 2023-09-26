/// CTOR: QP
/// DATE: 2020-06-24
/// DESC: 外院剂量业务类
Class DHCDoc.Chemo.BS.HospDose Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-06-24
/// DESC: 保存
/// IN  : [ID_$C(1)_INFO,]
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.HospDose).Save("")
ClassMethod Save(HDAry)
{
	s mRtn=0

	s HDNum=$o(HDAry(""),-1)
	Q:(HDNum="") mRtn
	for i=1:1:HDNum {
		s HDRecord=HDAry(i)
		//con
		//Q:PLNum="" mRtn
		s ID=$p(HDRecord,$C(1),1)
		s HDDosage=$p(HDRecord,$C(1),5)
		continue:HDDosage=""
		i ID="" {
			s a=##class(User.ChemoHospDose).%New()
			d a.HDPatientDRSetObjectId($p(HDRecord,$C(1),2))
			d a.HDAdmDRSetObjectId($p(HDRecord,$C(1),3))
			d a.HDArcimDRSetObjectId($p(HDRecord,$C(1),4))
		} else{
			s a=##class(User.ChemoHospDose).%OpenId(ID)
		}
		Q:'$ISObject(a) 
		s a.HDDosage=$p(HDRecord,$C(1),5)
		s a.HDUomDR=$p(HDRecord,$C(1),6)
		s sc=a.%Save()
		if ($$$ISERR(sc)) {
			s mRtn=-124
		} else {
			s mRtn=a.%Id()
		}
		d a.%Close()
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-06-25
/// DESC: 查找患者的外院记录
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.HospDose).FindRecord("")
ClassMethod FindRecord(PatientID, InArcim)
{
	s mRtn=""
	Q:PatientID="" mRtn
	s mRtn=$o(^BS.DOC.Chemo.HospDoseI("PatientArcim",PatientID,InArcim,""))
	
	Q mRtn
}

}
