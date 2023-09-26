Import sqluser

/// 表单记录保存
/// zhouxin
/// 2017-09-27
Class web.DHCADVFormRecord Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Description:保存表单记录
/// Author:zhouxin
/// Table:DHCAdvFormRecord,DHCAdvFormRecordItm
/// w ##class(web.DHCADVFormRecord).SaveRecord("1223","823","16","178453.94372:测试地点^178455.94374:而是任由^178459.94294:测试其他^178459.94309:测试其他^178459.94316:测试其他^178468.94376:测试个案改进^178469.94379:测试名称^178474.94384:测试转归^178478.94399.9:对象^178478.94400.9:内容^178478.94401.9:结果^178478.94403.9:人^178446.94488:2018-04-13^178451.94370:2018-04-13^178478.94398.9:2018-04-13^178459.94288:患者无管路保护意识^178459.94289:患者活动时未保护好管路^178459.94299:对患者精神与意识判断不准确^178459.94303:未评估管路留置时间^178459.94310:操做后未及时给予约束^178459.94329:无风险评估意识^178459.94330:无管路保护意识（操作时未保护好管路）^178459.94337:护理员^178459.94338:陪护人员^178460.94348:导管或固定器具在使用中出现故障^178460.94351:约束带^178461.94360:缺少制度、规范等指导性文件^178461.94361:对临床护士培训不到位^178462.94366:环境拥挤，不利于操作^178469.94378:制度","","12")
ClassMethod SaveRecord(user = "", formId = "", formVersion = "", par = "", recordId = "", linkRecordId = "")
{
	n (user,formId,formVersion,par,recordId,linkRecordId,%session)
	s $ze="Err",ret=0,newRecorId=""
	ts
	//
	i +recordId=0 d
	.s recordObj=##class(User.DHCAdvFormRecord).%New()
	.d recordObj.createUserSetObjectId(user)	
	.d recordObj.formNameSetObjectId(formId)
	.s recordObj.formVersion=formVersion
	.d recordObj.LinkRecordIdSetObjectId(linkRecordId)
	e  d
	.s recordObj=##class(User.DHCAdvFormRecord).%OpenId(recordId)
	.s recordObj.updateDate=+$h
	.s recordObj.updateTime=$p($h,",",2)

	s sc=recordObj.%Save()
	s newRecorId=recordObj.%Id()
	If $$$ISERR(sc) {
      tro
      q $System.Status.GetErrorText(sc)
 	} 
 	i +recordId'=0{ 
	  &sql(delete from DHC_AdvFormRecordItm where parrRef=:recordId)	
	}
 	s len=$l(par,"^")
	f i=1:1:len d
	.q:ret'=0
	.s str=$p(par,"^",i)
	.q:str=""
	.s key=$p(str,":",1)
	.s strL=$l(str) ;hxy 2017-11-29 st 文本框中有“:/”时，保存后，“:/”及后面的信息不显示
	.s keyL=$l(key)
	.S value=$Extract(str,keyL+2,strL) 
	.S value=$Replace(value,",","，")  ;cy 2018-03-02 
	.;s value=$p(str,":",2) ;hxy 2017-11-29 ed
	.s form=$p(key,".",1)
	.s formDic=$p(key,".",2)
	.f j=1:1:$l(value,",") d
	..q:ret'=0
	..q:$p(value,",",j)=""
	..S List=$p(value,",",j)
	..S:(List["/")&&($L(List)="10")&&($L(List,"/")="3")&&(+List'=0) List=##class(web.DHCADVCOMMONPART).GetDate(List)  //2018 cy
	..s itmObj=##class(User.DHCAdvFormRecordItm).%New()
	..d itmObj.parrRefSetObjectId(recordObj.%Id())
	..d itmObj.formSetObjectId(form)
	..d itmObj.formDicSetObjectId(formDic)
	..//s itmObj.formDic=formDic
	..s itmObj.value=$p(value,",",j)
	..s:List'="" itmObj.value=List
	..s itmObj.datagridRowKey=$p(key,".",3)
	..i +formDic'=0 d
	...s:$d(^User.DHCAdvFormDicD(formDic)) parf=$LIst(^User.DHCAdvFormDicD(formDic),6)
	...s itmObj.parrRefDic=parf
	..s sc=itmObj.%Save()
	..If $$$ISERR(sc) d
	...s ret=$System.Status.GetErrorText(sc)

	If ret'=0 {
      tro
      q ret
 	}
 	//保存子表单版本号
 	d ..SaveFormVersion(recordObj.%Id())
 	tc
 	q ret_"^"_newRecorId
Err
  tro	
  q -1
}

/// 保存表单版本
ClassMethod SaveFormVersion(recordId = "")
{
	n (recordId)
	
	s formname=""
	f  s formname=$o(^User.DHCAdvFormNameD(formname)) d  q:formname=""
	.q:+formname=0
	.s version=$List(^User.DHCAdvFormNameD(formname),4)
	.s obj=##class(User.DHCAdvFormRecordVersion).%New()
	.d obj.parrRefSetObjectId(recordId)
	.d obj.formNameSetObjectId(formname)
	.s obj.version=version
	.d obj.%Save()
}

/// Description:查询表单填写记录
/// Author:zhouxin
/// Table:FormRecord,FormRecordItm
ClassMethod listGrid(rows As %String, page As %String, queryStart = "", queryEnd = "", queryName = "")
{
  
  n (rows,page,queryStart,queryEnd,queryName)
  s End = page*rows
  s Start=(page-1)*rows+1
  
  i queryStart'=""{
	s queryStart=##class(websys.Conversions).DateHtmlToLogical(queryStart)	  
  }
  i queryEnd'=""{
	s queryEnd=##class(websys.Conversions).DateHtmlToLogical(queryEnd)	  
  }
  q:queryStart="" ""
  
  s count=0
  w "{""rows"":["
  f date=queryStart:1:queryEnd d
  .s record=""
  .f  s record=$o(^User.DHCAdvFormRecordI("IndexDate",date,record)) q:record=""  d
  ..s data=^User.DHCAdvFormRecordD(record)
  ..s formId=$LIST(data,2)
  ..q:formId=""
  ..s code=$LIST(^User.DHCAdvFormNameD(formId),2)
  ..s name=$LIST(^User.DHCAdvFormNameD(formId),3)
  ..q:(queryName'="")&&($f(name,queryName)=0)
  ..s user=$LIST(data,6)
  ..s:+user'=0 user=$p(^SSU("SSUSR",user),"^",2)
  ..s count=count+1
  ..q:count<Start
  ..q:count>End
  ..w $case(count,Start:"",:",")
  ..s tmpObj={}
  ..s tmpObj.ID=record
  ..s tmpObj.code=code
  ..s tmpObj.name=name
  ..s tmpObj.version=$LIST(data,3)
  ..s tmpObj.createDate=##class(websys.Conversions).DateLogicalToHtml($LIST(data,4))
  ..s tmpObj.createTime=##class(websys.Conversions).TimeLogicalToHtml($LIST(data,5))
  ..s tmpObj.updateDate =##class(websys.Conversions).DateLogicalToHtml($LIST(data,7))
  ..s tmpObj.updateTime=##class(websys.Conversions).TimeLogicalToHtml($LIST(data,8))
  ..s tmpObj.createUser=user
  ..s tmpObj.newVersion=$LIST(^User.DHCAdvFormNameD(formId),4)
  ..w tmpObj.%ToJSON()
  ..//w "{"
  ..//w """ID"":"_record_","
  ..//w """code"":"""_code_""","
  ..//w """name"":"""_name_""","
  ..//w """version"":"""_$LIST(data,3)_""","
  ..//w """createDate"":"""_##class(websys.Conversions).DateLogicalToHtml($LIST(data,4))_""","
  ..//w """createTime"":"""_##class(websys.Conversions).TimeLogicalToHtml($LIST(data,5))_""","
  ..//w """createUser"":"""_user_""""
  ..//w "}"
  
  w "],""total"":"_count_"}"
  q ""
}

}
