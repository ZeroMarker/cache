/// Desc:      取传入书写病历接口页入参DocID
/// Creator:   DongLulu
/// CreateDate:2020-7-13
Class EMRservice.HISInterface.GetInterfaceDocID Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:     根据检查医嘱ID返回知情告知DocID(广州泰和肿瘤)
/// CreatDate:2020-7-13
/// Creator:  DongLulu
/// Input:    AOeordID   医嘱ID
/// Output:   DocID      病历DocID
/// Debug:    w ##Class(EMRservice.HISInterface.GetInterfaceDocID).GetGZTHZLPacsOeordDocID("66") 
ClassMethod GetGZTHZLPacsOeordDocID(AOeordID As %String) As %String
{
	s result = ""
	q:(AOeordID = "") result
	
	if (AOeordID="271||4") {
		s result="324"  //CT增强知情同意书
	}
	elseif (AOeordID="271||5") {
		s result="324"  //CT扫描知情同意书
	}
	elseif (AOeordID="271||6") {
		s result="330"  //CT引导下肿瘤穿刺活检术知情同意书
	}
	
	q result
}

}
