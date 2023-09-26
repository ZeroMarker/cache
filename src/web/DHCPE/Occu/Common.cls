Class web.DHCPE.Occu.Common Extends %RegisteredObject
{

/// 可用于团体导入时 调用保存职业病信息
/// BaseInfo    基本信息 		危害因素(1,2,3) 检查种类 工种 接害工龄 工号 总工龄
/// OccuHis     职业史			开始日期^结束日期^工作单位^车间^班组^工种^有害因素^防护措施$开始日期^结束日期^工作单位^车间^班组^工种^有害因素^防护措施
/// DisHis      病史			既往史^家族史^现有子女^流产^早产^死产^异常胎^吸烟史^包/天^年^饮酒史^ml/天^年^初潮^经期^周期^停经年龄 
/// OccuDisHis  职业病史		病名^诊断日期^诊断单位^是否痊愈$病名^诊断日期^诊断单位^是否痊愈
/// RadOccuHis  放射职业史		开始日期^截止日期^工作单位^部门^工种^放射线种类^每日工作时数或工作量^累计照射剂量^过量照射史^备注$开始日期^截止日期^工作单位^部门^工种^放射线种类^每日工作时数或工作量^累计照射剂量^过量照射史^备注
/// MarHis      婚姻史			结婚日期^配偶接触放射线情况^配偶职业及健康状况
/// w ##class(web.DHCPE.Occu.Common).SaveImportGOccuInfo()
ClassMethod SaveImportGOccuInfo(PreIADM, BaseInfo, OccuHis As %String = "", DisHis As %String = "", OccuDisHis As %String = "", RadOccuHis As %String = "", MarHis As %String = "")
{
	q:PreIADM="" "-1^无效病人ID"
	q:BaseInfo="" "-1^基本信息为空"
	
	s EndangerIds=$p(BaseInfo,"^",1)
	s OMEType=$p(BaseInfo,"^",2)
	s WordType=$p(BaseInfo,"^",3)
	s EndangerWorkAge=$p(BaseInfo,"^",4)
	s WorkNo=$p(BaseInfo,"^",5)
	s WordAge=$p(BaseInfo,"^",6)
	// 保存职业病-基本信息
	s ret=##class(web.DHCPE.OccupationalDisease).SaveOccu2(PreIADM, EndangerIds, OMEType, WordType, EndangerWorkAge, WorkNo, WordAge)
	q:$p(ret,"^",1)="-1" ret_" "_PreIADM_" 基本信息保存失败！"
	
	s ErrStr=""
	
	// 保存职业病-职业史
	i OccuHis'="" d
	.s ErrInfo=##class(web.DHCPE.OccupationalDisease).SaveOccuHistory(PreIADM, OccuHis)
	.s:$p(ErrInfo,"^",1)="-1" ErrStr=$p(ErrInfo,"^",2)_" "_PreIADM_" 职业史保存失败！"
	
	// 保存职业病-病史
	i DisHis'="" d
	.s DisHis=$tr(DisHis,"^","$$")
	.s ErrInfo=##class(web.DHCPE.OccupationalDisease).SaveDiseaseHistory(PreIADM, DisHis)
	.i $p(ErrInfo,"^",1)="-1" d
	..s:ErrStr'="" ErrStr=ErrStr_"；"_$p(ErrInfo,"^",2)_" "_PreIADM_" 病史保存失败！"
	..s:ErrStr="" ErrStr=$p(ErrInfo,"^",2)_" "_PreIADM_" 病史保存失败！"
	
	// 保存职业病-职业病史
	i OccuDisHis'="" d
	.s ErrInfo=##class(web.DHCPE.OccupationalDisease).SaveOccuDiseaseHistory(PreIADM, OccuDisHis)
	.i $p(ErrInfo,"^",1)="-1" d
	..s:ErrStr'="" ErrStr=ErrStr_"；"_$p(ErrInfo,"^",2)_" "_PreIADM_" 职业病史保存失败！"
	..s:ErrStr="" ErrStr=$p(ErrInfo,"^",2)_" "_PreIADM_" 职业病史保存失败！"
	
	// 保存职业病-放射职业史
	i RadOccuHis'="" d
	.s ErrInfo=##class(web.DHCPE.OccupationalDisease).SaveOccuRadialHistory(PreIADM, RadOccuHis)
	.i $p(ErrInfo,"^",1)="-1" d
	..s:ErrStr'="" ErrStr=ErrStr_"；"_$p(ErrInfo,"^",2)_" "_PreIADM_" 放射职业史保存失败！"
	..s:ErrStr="" ErrStr=$p(ErrInfo,"^",2)_" "_PreIADM_" 放射职业史保存失败！"
	
	// 保存职业病-婚姻史
	i MarHis'="" d
	.s ErrInfo=##class(web.DHCPE.OccupationalDisease).SaveMarryHistory(PreIADM, MarHis)
	.i $p(ErrInfo,"^",1)="-1" d
	..s:ErrStr'="" ErrStr=ErrStr_"；"_$p(ErrInfo,"^",2)_" "_PreIADM_" 婚姻史保存失败！"
	..s:ErrStr="" ErrStr=$p(ErrInfo,"^",2)_" "_PreIADM_" 婚姻史保存失败！"
	
	q ErrStr
}

/// 通过体检预约记录获取症状信息 默认返回 json 数组
/// w ##class(web.DHCPE.Occu.Common).GetSymptomByIDForPage(148533)
ClassMethod GetSymptomByIDForPage(PreIADM, OutFlag = "")
{
	s SymptomJson=##class(web.DHCPE.CT.Occu.DictionaryCode).GetBaseCodeObjByPIdNew("BASE", "SYMPTOM")
	
	s preIBI=$p($g(^DHCPEPreIADM(PreIADM)),"^",1)
	s Sex=$p($g(^DHCPEPreIBI(preIBI)),"^",3)
	s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
	
	s PreSymptom="",PreSymptomUser="",PreSymptomUserD="",PreSymptomTime=""
	s IADMEx=$o(^User.DHCPEPreIADMExI("PreIADMID",PreIADM,0))
	i IADMEx'="" {
		s PreSymptom=$lg($lg(^User.DHCPEPreIADMExD(IADMEx),13),1)
		s PreSymptomUser=$lg($lg(^User.DHCPEPreIADMExD(IADMEx),13),2),PreSymptomUserD=""
		s:PreSymptomUser'="" PreSymptomUserD=$p($g(^SSU("SSUSR",PreSymptomUser)),"^",2)
		s PreSymptomTime=$lg($lg(^User.DHCPEPreIADMExD(IADMEx),13),3)
		s:PreSymptomTime'="" PreSymptomTime=$zd(PreSymptomTime,3)
	}
	
	s Arr=[]
	i ($isObject(SymptomJson)) {
		s SymptomArr=SymptomJson.children
		f indx=0:1:(SymptomArr.%Size()-1) {
			s sobj=SymptomArr.%Get(indx).attributes
			continue:sobj.Active'="Y"
			s Code=sobj.Code
			s Desc=sobj.Desc
			
			continue:((sobj.Remark'="")&&(sobj.Remark'=Sex))
			
			s SelFlag="N",Remark=""
			f indy=1:1:$ll(PreSymptom) {
				s PreCode=$lg($lg(PreSymptom,indy),1)
				continue:PreCode=""
				s:Code=PreCode SelFlag="Y",Remark=$lg($lg(PreSymptom,indy),2)
				quit:SelFlag="Y"
			}
			s Obj={}
			s Obj.Code=Code
			s Obj.Desc=Desc
			s Obj.SelFlag=SelFlag
			s Obj.Remark=Remark
			d Arr.%Push(Obj)
		}
	}
	
	s ret={}
	s ret.Symptom=Arr
	s ret.SymptomUser=PreSymptomUser
	s ret.SymptomUserDesc=PreSymptomUserD
	s ret.SymptomDate=PreSymptomTime
	
	q:OutFlag="String" ret.%ToJSON()
	q ret
}

/// 保存症状
/// w ##class(web.DHCPE.Occu.Common).SaveSymptom("148533","[{""code"":""10001"",""text"":""1""},{""code"":""10016"",""text"":""2""},{""code"":""10041"",""text"":""""},{""code"":""10046"",""text"":""""}]","1")
ClassMethod SaveSymptom(PreIADM, Result, UserID = "")
{
	q:PreIADM="" ..OutJson(-1,"预约ID为空","")
	q:Result="" ..OutJson(0,"无症状信息","")
	s:UserID="" UserID=%session.Get("LOGON.USERID")
	
	s Arr=[].%FromJSON(Result)
	q:Arr.%Size()=0 ..OutJson(0,"无症状信息","")
	
	s SymptomList=""
	f ind=1:1:(Arr.%Size()) d
	.s Obj=Arr.%Get(ind-1)
	.s Code=Obj.code
	.q:Code=""
	.s Remark=Obj.text
	.s $LIST(SymptomList,ind)=$lb(Code,Remark)
	q:$ll(SymptomList)=0 ..OutJson(0,"无获取到症状信息","")
	
	s IADMEx=$o(^User.DHCPEPreIADMExI("PreIADMID",PreIADM,0))
	i (IADMEx="") s obj=##class(User.DHCPEPreIADMEx).%New()
	e  s obj=##class(User.DHCPEPreIADMEx).%OpenId(IADMEx)
	
	d obj.PIEPreIADMIDSetObjectId(PreIADM)
	d obj.PIESymptom.Clear()
	d obj.PIESymptom.Insert(SymptomList)
	d obj.PIESymptom.Insert(UserID)
	s DateTime=$h
	d obj.PIESymptom.Insert($h)
	
	s sc=obj.%Save()
	if ($System.Status.IsError(sc)) {
		Set rtn=..OutJson(-1,$System.Status.GetErrorText(sc),"")
	} else {
		Set rtn = ..OutJson(obj.%Id(),$zd(DateTime,3),"")
	}
	d obj.%Close()
	q rtn
}

ClassMethod OutJson(code, msg, data)
{
	s json={}
	s json.code=code
	s json.msg=msg
	s json.data=data
	q json.%ToJSON()
}

}
