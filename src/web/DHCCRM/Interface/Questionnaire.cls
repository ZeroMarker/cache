/// 名称: 随访系统对外接口
/// 编写者：zhongricheng
/// 编写日期: 2021-08-13
Class web.DHCCRM.Interface.Questionnaire Extends %RegisteredObject
{

/// 满意度调查问卷ID
Parameter QuestionId = 1;

/// Description: 接口调用统一方法
/// Table：
/// Input: RequestCode 接口代码  RequestXML 接口入参
/// Return：ResultCode 0成功 其他失败    ResultDesc 接口出参
/// Creator：zhongricheng
/// CreatDate：2021-08-13
/// dubug: w ##class(web.DHCCRM.Interface.Questionnaire).Action("SF0001","<Request><RegNo>0000001435</RegNo></Request>")
///        w ##class(web.DHCCRM.Interface.Questionnaire).Action("SF0002","<Request><Id>1269</Id><PAADM>10982</PAADM></Request>")
///        w ##class(web.DHCCRM.Interface.Questionnaire).Action("SF0003","<Request><Id>1269</Id><PAADM>10982</PAADM><Detail><SubjectDetail><Id>4||1</Id><Result>满意</Result><TemplateDesc></TemplateDesc></SubjectDetail><SubjectDetail><Id>4||3</Id><Result>满意</Result><TemplateDesc></TemplateDesc></SubjectDetail></Detail>")
ClassMethod Action(RequestCode As %String = "", RequestXML As %String = "")
{
    s xml=##class(web.DHCPE.Utils.XML).New("Response")
    q:RequestCode="" ..ResXml(xml, -1, "接口代码为空")
    q:RequestXML="" ..ResXml(xml, -1, "接口入参为空")
    
    s request=##class(web.DHCPE.Utils.XML).FromXML(RequestXML)
    q:request="" ..ResXml(xml, -1, "接口入参无法解析")
    
    s obj=##class(web.DHCCRM.Interface.Questionnaire).%New()
    s resXml=$case(RequestCode, "SF0001": obj.SearchFUPlan(request, xml),
                                "SF0002": obj.GetFUSubject(request, xml),
                                "SF0003": obj.SaveFUSubject(request, xml)
                    )
    q $replace(resXml,"<?xml version=""1.0"" encoding=""utf-8""?>","")
}

/// Description: 通过登记号查询对应的随访计划
/// Table：DHC_CRM_FUPlan
/// Input: Parmas  <Request><RegNo>0000111111</RegNo></Request>
/// Return：
/// Creator：zhongricheng
/// CreatDate：2021-08-13
Method SearchFUPlan(Parmas, Response As web.DHCPE.Utils.XML)
{
    q:Parmas="" ..ResXml(Response, -1, "接口入参为空")
    s regNo=Parmas.RegNo
    q:regNo="" ..ResXml(Response, -1, "登记号不能为空")
    s patMas=$o(^PAPERi("PAPMI_PatNo",regNo,0))
    q:patMas="" ..ResXml(Response, -1, "无效登记号")
    
    s listXml=##class(web.DHCPE.Utils.XML).New()
    s Type=""
    f  s Type=$o(^PAPERdr(patMas,"ADM",Type)) q:Type=""  d
    .s patType=$case(Type,"O":"门诊","I":"住院","E":"急诊","H":"体检")
    .s PAADM=0
    .f  s PAADM=$o(^PAPERdr(patMas,"ADM",Type,PAADM)) q:PAADM=""  d
    ..s FupId=0
    ..f  s FupId=$o(^DHCCRMFUP(0,"FUP_PAADM",PAADM,FupId)) q:FupId=""  d
    ...s QRId=$o(^DHCCRMQR(0,"QR_FUP_DR",FupId,0))
    ...q:QRId'=""  // 已填写 过滤
    ...q:..#QuestionId'=$p($g(^DHCCRMFUP(FupId)),"^",2)   // 不是满意度调查则退出
    ...s QuestionIdDR=$p($g(^DHCCRMFUP(FupId)),"^",2)
    ...i $l(QuestionIdDR) s QuestionName=$p($g(^DHCCRMFUS(QuestionIdDR)),"^",2)
    ...s tempXml=##class(web.DHCPE.Utils.XML).New("CRMInfo")
    ...s tempXml.Id=FupId
	...s tempXml.PAADM=PAADM
	...s tempXml.QuestionName=QuestionName
    ...;d Response.ResultList.Insert(tempXml)
    ...d listXml.Insert(tempXml)
    ...s tempXml=""
    
    q ..ResXml(Response, 0, "成功", listXml)
}

/// Description: 根据随访计划ID获取问卷内容
/// Table：DHC_CRM_FUSubject
/// Input: Parmas  <Request><Id>1269</Id><PAADM>10982</PAADM></Request>
/// Return：code -1 失败   msg 原因
/// Creator：zhongricheng
/// CreatDate：2021-08-13
Method GetFUSubject(Parmas, Response As web.DHCPE.Utils.XML)
{
	q:Parmas="" ..ResXml(Response, -1, "接口入参为空")
	s fupId=Parmas.Id  // 随访计划ID
	q:fupId="" ..ResXml(Response, -1, "随访计划ID不能为空")
	s paadm=Parmas.PAADM  // 就诊号
	q:fupId="" ..ResXml(Response, -1, "随访计划ID不能为空")
	q:'$d(^DHCCRMFUP(fupId)) ..ResXml(Response, -1, "无效随访计划ID")
	
	s fupadm=$p($g(^DHCCRMFUP(fupId)),"^",1)
	q:paadm'=fupadm ..ResXml(Response, -1, "就诊记录不一致")
	s quesId=$p($g(^DHCCRMFUP(fupId)),"^",2)
	q:quesId="" ..ResXml(Response, -1, "无对应问卷信息")
	q:quesId'=..#QuestionId ..ResXml(Response, -1, "非满意度调查问卷")
	q:'$d(^DHCCRMFUS(quesId)) ..ResXml(Response, -1, "无效问卷信息")
	
	s subXml=##class(web.DHCPE.Utils.XML).New()
	s subXml.Title=$p($g(^DHCCRMFUS(quesId)),"^",2)
	
	s SDSequence=""
    f  s SDSequence=$o(^DHCCRMFUS(0,"SD_Sequence",quesId,SDSequence)) q:SDSequence=""  d
    .s detSub=0
    .f  s detSub=$o(^DHCCRMFUS(0,"SD_Sequence",quesId,SDSequence,detSub)) q:detSub=""  d
    ..s detData=$g(^DHCCRMFUS(quesId,"SD",detSub))
    ..s RowId=quesId_"||"_detSub
    ..q:detData=""
    ..s active=$p(detData,"^",7)
    ..q:active'="Y"
    ..s effDate=$p(detData,"^",8)
    ..q:((effDate'="")&&(effDate>+$h))
    ..s effDateTo=$p(detData,"^",9)
    ..q:((effDateTo'="")&&(effDateTo<+$h))
    ..s code=$p(detData,"^",1)
    ..s desc=$p(detData,"^",2)
    ..s type=$p(detData,"^",3)
    ..s unit=$p(detData,"^",4)
    ..s explain=$p(detData,"^",5)
    ..s sex=$p(detData,"^",6)  // M 男  F 女  N 不限
    ..s required=$p(detData,"^",10)
    ..s sequence=$p(detData,"^",11)
    ..s parentDr=$p(detData,"^",12)
    ..s cascade=$p(detData,"^",13)
    ..s selNum=$p(detData,"^",14)
    ..
    ..s detXml=##class(web.DHCPE.Utils.XML).New("SubjectDetail")
    ..s detXml.Id=RowId
    ..s detXml.Code=code
    ..s detXml.Desc=desc
    ..s detXml.Type=type
    ..s detXml.Unit=unit
    ..s detXml.Explain=explain
    ..s detXml.Sex=sex
    ..s detXml.Required=required
    ..s detXml.Sequence=sequence
    ..s detXml.ParentDr=parentDr
    ..s detXml.Cascade=cascade
    ..s detXml.selNum=selNum
    ..
    ..if ((type="S")||(type="D")||(type="DT")) d  // T 文本型  N 数值型  S 单选型  D 多选型  DT 多文本  DN 多数值
    ...s selSub=0
    ...f  s selSub=$o(^DHCCRMFUS(quesId,"SD",detSub,"SDS",selSub)) q:selSub=""  d
    ....s selData=$g(^DHCCRMFUS(quesId,"SD",detSub,"SDS",selSub))
    ....q:selData=""
    ....s text=$p(selData,"^",1)
    ....s unit=$p(selData,"^",2)
    ....s defValue=$p(selData,"^",3)
    ....s sequence=$p(selData,"^",4)
    ....s desc=$p(selData,"^",5)
    ....
    ....s selXml=##class(web.DHCPE.Utils.XML).New("DetailSelect")
    ....s selXml.Text=text
    ....s selXml.Unit=unit
    ....s selXml.DefValue=defValue
    ....s selXml.Sequence=sequence
    ....s selXml.Desc=desc
    ....
    ....s detXml.Select=selXml
    ....s selXml=""
    ..
    ..s subXml.Detail=detXml
    ..s detXml=""
	
    q ..ResXml(Response, 0, "获取成功", subXml)
}

/// Description: 保存问卷调查填写内容
/// Table：DHC_CRM_FUPlan
/// Input: Parmas  <Request><Id>1269</Id><PAADM>10982</PAADM><Detail><SubjectDetail><Id>4||1</Id><Result>满意</Result><TemplateDesc></TemplateDesc></SubjectDetail><SubjectDetail><Id>4||3</Id><Result>满意</Result><TemplateDesc></TemplateDesc></SubjectDetail></Detail></Request>
/// Return：code -1 失败   msg 原因
/// Creator：zhongricheng
/// CreatDate：2021-08-13
Method SaveFUSubject(Parmas, Response As web.DHCPE.Utils.XML)
{
	q:Parmas="" ..ResXml(Response, -1, "接口入参为空")
	s fupId=Parmas.Id  // 随访计划ID
	q:fupId="" ..ResXml(Response, -1, "随访计划ID不能为空")
	s paadm=Parmas.PAADM  // 就诊号
	q:fupId="" ..ResXml(Response, -1, "随访计划ID不能为空")
	q:'$d(^DHCCRMFUP(fupId)) ..ResXml(Response, -1, "无效随访计划ID")
	
	s fupadm=$p($g(^DHCCRMFUP(fupId)),"^",1)
	q:paadm'=fupadm ..ResXml(Response, -1, "就诊记录不一致")
	s quesId=$p($g(^DHCCRMFUP(fupId)),"^",2)
	q:quesId="" ..ResXml(Response, -1, "无对应问卷信息")
	q:quesId'=..#QuestionId ..ResXml(Response, -1, "非满意度调查问卷")
	q:'$d(^DHCCRMFUS(quesId)) ..ResXml(Response, -1, "无效问卷信息")
	
	s qrId=$o(^DHCCRMQR(0,"QR_FUP_DR",fupId,0))
	q:qrId'="" ..ResXml(Response, -1, "已保存过问卷")
	s Detail=Parmas.Detail
	q:Detail.Length()<=0 ..ResXml(Response, -1, "无问卷明细内容")
    s PAPMI=$p($g(^PAADM(paadm)),"^",1)
    s User=Parmas.User
    s:User="" User=$p($g(^DHCCRMFUP(fupId)),"^",5)
    b
    k QrList
    s QrList(2)=fupId
    s QrList(3)=paadm //PAADM
    s QrList(4)=PAPMI //PAPMI
    s QrList(5)="Finish"  // Hang Finish
    s QrList(6)=+$H
    s QrList(7)=$p($H,",",2)
    s QrList(8)=User //User
    s QrList(9)="" //Demo
    
    s errInfo=""
    TSTART
    &SQL(Insert Into sqluser.DHC_CRM_QRecord values :QrList())
    i SQLCODE {
	    TROLLBACK
	    s errInfo=$tr($tr(%msg,"<"," "),">"," ")
        q ..ResXml(Response, -1, errInfo)
    }
    s qrId=%ROWID
    
    f iD=0:1:(Detail.Length()-1) {
	    s detailList=Detail.Get(iD)
    	k DetList
		s DetList(3)=+detailList.Id
		s DetList(4)=detailList.Id
		s DetList(5)=detailList.Result
		s DetList(6)=detailList.TemplateDesc
		s DetList(7)=+$H
		s DetList(8)=$p($h,",",2)
		s DetList(9)=User
		s DetList(10)=fupId
		
		s Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR",DetList(4),qrId,0))
		i Sub>0 d
		.s QRDRowID=qrId_"||"_Sub
		.&SQL(Update sqluser.DHC_CRM_QRecordDetail values :DetList() where QRD_RowId=:QRDRowID)
		e  d
		.s DetList(0)=qrId
		.&SQL(Insert Into sqluser.DHC_CRM_QRecordDetail values :DetList())
		
		i SQLCODE {
			s errInfo=$tr($tr(%msg,"<"," "),">"," ")
			q
        }
    }
	if errInfo'="" {
		TROLLBACK
		q ..ResXml(Response, -1, errInfo)
	}
	TCOMMIT
	
    q ..ResXml(Response, 0, "保存成功")
}

/// Description: 返回信息通用方法
/// Table：
/// Input: xml    code 错误信息    msg 错误信息
/// Return：
/// Creator：zhongricheng
/// CreatDate：2021-08-13
/// dubug: w ##class(web.DHCCRM.Interface.Questionnaire).ResXml("","")
ClassMethod ResXml(xml As web.DHCPE.Utils.XML, code As %String = "", msg As %String = "", list As %String = "")
{
    s xml.ResultCode=code
    s xml.ResultDesc=msg
    s:list'="" xml.ResultList=list
    q $replace(xml.ToXML(),"<?xml version=""1.0"" encoding=""utf-8""?>","")
}

}
