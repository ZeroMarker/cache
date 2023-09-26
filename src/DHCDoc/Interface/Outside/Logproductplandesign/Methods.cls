/// 后勤产品规划设计组接口提供
Class DHCDoc.Interface.Outside.Logproductplandesign.Methods Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Creater: 	pj
/// CreateDate: 2023.02.20
/// Descript: 	后勤产品规划设计接口获取住院最新就诊id
/// Input: 		{IDCardNo:"证件号码",PatName:"姓名"}
/// OutPut: 	就诊IDjson串
/// ##class(DHCDoc.Interface.Outside.Logproductplandesign.Methods).GetAdmInfo("{IDCardNo:350781196403076469,PatName:马亭(演示)}")
ClassMethod GetAdmInfo(PatInfoJson As %String) As %String
{
	s PatInfoData = ##class(PHA.COM.Object).FromJSON(PatInfoJson)
    s IDCardNo = PatInfoData.IDCardNo
    s PatName = PatInfoData.PatName
    s RetObj={}
    if (IDCardNo=""){
	   s RetObj.msg="证件号码不能为空！"
	   s RetObj.code="-1"
	   Q RetObj.%ToJSON()
	}
    s PatNameErr=""
	s PersonRowId=""
	f  s PersonRowId=$o(^PAPERi("DVA",IDCardNo,PersonRowId)) q:PersonRowId=""  d
	.s Patname=$p($g(^PAPER(PersonRowId,"ALL")),"^",1)
	.i PatName'=Patname s PatNameErr="姓名不一致" q
	.s AdmID=$O(^PAPERdr(PersonRowId,"ADM","I",""),-1)
	.q:AdmID=""
	.s Status=$p($g(^PAADM(AdmID)),"^",20)
	.q:Status'="A"
	.s PatAdmArr(AdmID)=""
	if (PatNameErr'=""){
	   s RetObj.msg=PatNameErr
	   s RetObj.code="-1"
	   Q RetObj.%ToJSON()
	}
	s RetObj.msg="成功！"
	s RetObj.code="0"
	s admid=0
	f  s admid=$O(PatAdmArr(admid)) q:admid=""  d
	.s RetObj.AdmNo=admid
    Q RetObj.%ToJSON()
}

/// Creater: 	pj
/// CreateDate: 2023.02.20
/// Descript: 	后勤产品规划设计接口获取膳食医嘱信息
/// Input: 		{AdmNo:"就诊id"}
/// OutPut: 	膳食医嘱json串
/// ##class(DHCDoc.Interface.Outside.Logproductplandesign.Methods).GetFoodOrderInfo("{AdmNo:1}")
ClassMethod GetFoodOrderInfo(AdmInfoJson As %String) As %String
{
	s AdmInfoData = ##class(PHA.COM.Object).FromJSON(AdmInfoJson)
    s AdmNo = AdmInfoData.AdmNo
    
    s RetObj={}
    if (AdmNo=""){
	   s RetObj.msg="就诊号不能为空！"
	   s RetObj.code="-1"
	   Q RetObj.%ToJSON()
	}
    s Ord=$O(^OEORD(0,"Adm",AdmNo,0))
	if (Ord=""){
	   s RetObj.msg="此就诊不存在医嘱！"
	   s RetObj.code="-1"
	   Q RetObj.%ToJSON()
	}
	s HospId=""
	s admLoc=$p(^PAADM(AdmNo),"^",4)	
	i admLoc'="" s HospId=$p(^CTLOC(admLoc),"^",22)
	s HospId=2
	s HospCodeNode="HospDr_"_HospId
	s Index=0
	s FoodArcStr=""
	for {
		s Index=$O(^DHCDocConfig(HospCodeNode,"OrderClassify","Diet","Detail",Index))
		q:(Index="")
		s Val=$g(^DHCDocConfig(HospCodeNode,"OrderClassify","Diet","Detail",Index))
		s FoodArcimid=$P(Val,"^",1)
		s FoodArcStr=$case(FoodArcStr,"":FoodArcimid,:FoodArcStr_"^"_FoodArcimid)
		
	}
	s FoodArcStr="^"_FoodArcStr_"^"
	s OrdNameStr=""
    s Sub=0 for{
        s Sub=$O(^OEORD(+Ord,"I",Sub)) Q:Sub=""
        s StatusDr=$P($G(^OEORD(+Ord,"I",Sub,1)),"^",13)
        continue:StatusDr=""
        s StatusCode=$P(^OEC("OSTAT",StatusDr),"^",1)
		continue:(StatusCode'="V")&&(StatusCode'="E")
		s ARCIMRowid=$p($g(^OEORD(+Ord,"I",Sub,1)),"^",2)
		s ARCIMRowidStr="^"_ARCIMRowid_"^"
		continue:FoodArcStr'[ARCIMRowidStr
		s OrderDesc=$P($G(^ARCIM(+ARCIMRowid,1,1)),"^",2)
		//s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		s OrdNameStr=OrderDesc

    }
	s RetObj.msg="成功！"
	s RetObj.code="0"
	s RetObj.OrdName=OrdNameStr
    Q RetObj.%ToJSON()
}

/// Creater: 	pj
/// CreateDate: 2023.02.20
/// Descript: 	后勤产品规划设计接口获取膳食配置医嘱信息
/// Input: 		{HospId:"院区id"}
/// OutPut: 	膳食医嘱配置json串
/// ##class(DHCDoc.Interface.Outside.Logproductplandesign.Methods).GetFoodOrderConfigInfo("{HospId:2}")
ClassMethod GetFoodOrderConfigInfo(HosInfoJson As %String) As %String
{
	s AdmInfoData = ##class(PHA.COM.Object).FromJSON(HosInfoJson)
    s HospId = AdmInfoData.HospId
	s HospCodeNode="HospDr_"_HospId
	s OrderArr=##Class(DHCDoc.Util.ListData).%New()
		;[]	
	
	s flag=0
	s RetObj=##Class(DHCDoc.Util.ArrayData).%New()
	s Index=0
	for {
		s Index=$O(^DHCDocConfig(HospCodeNode,"OrderClassify","Diet","Detail",Index))
		q:(Index="")
		s OrdInfoObj=##Class(DHCDoc.Util.ArrayData).%New()
		s Val=$g(^DHCDocConfig(HospCodeNode,"OrderClassify","Diet","Detail",Index))
		s FoodArcimid=$P(Val,"^",1)
		s flag=flag+1
		s OrderDesc=$P($G(^ARCIM(+FoodArcimid,1,1)),"^",2)
		s OrdInfoObj.OrderDesc=OrderDesc
		d OrderArr.Insert(OrdInfoObj)
		
	}
	s RetObj.OrdInfo=OrderArr
	s RetObj.msg="成功！"
	s RetObj.code="0"
    Q RetObj.%ToJSON()
}

}
