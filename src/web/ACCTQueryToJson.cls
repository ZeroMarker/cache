Class web.ACCTQueryToJson Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/*
{results:2,rows:[{No:'GG20100706R001',ProviderId:'3',ProviderDesc:'AXWY-北京爱心伟业医药有限公司',ReceiverId:'171',ReceiverDesc:'XYK-西药库',Date:'2010-07-06',CreatUser:'Demo Group',AuditUser:'Demo Group',TempVouchNo:'4001201007   1'},{No:'GG20100706R002',ProviderId:'7',ProviderDesc:'GAYY-北京广安医药联合中心',ReceiverId:'171',ReceiverDesc:'XYK-西药库',Date:'2010-07-06',CreatUser:'Demo Group',AuditUser:'Demo Group',TempVouchNo:'4001201007   1'}]}
*/
/// w ##class(web.ACCTQueryToJson).CreateDataJson(7,"XYK-西药库",1)
ClassMethod CreateDataJson(yearPeriodId As %String, locDesc As %String, busiTypeId As %String) As %String
{
 n (yearPeriodId,locDesc,busiTypeId)
 k ^tmpwyy
 ;s ^tmpwyy(1)=yearPeriodId_","_locDesc_","_busiTypeId
 s rs=##class(%ResultSet).%New()
 s rs.ClassName="web.ACCTCreateData"
 s rs.QueryName="CreateData"
 d rs.Execute(yearPeriodId,locDesc,busiTypeId)
 s json=##class(web.com.JsonObj).%New()
 s jsonTitle=""
 s tmpCC=rs.GetColumnCount()
 f i = 1:1:tmpCC
 {
	i i=1  d
	.s jsonTitle=rs.GetColumnHeader(i)
	e  d
	.s jsonTitle=jsonTitle_"^"_rs.GetColumnHeader(i)
 }
 s jsonTitle=jsonTitle_"^TempVouchNo"
 //////////////
 s start=0
 s end=25
 
 /////////////////
 s count=0
 While (rs.Next())
 {
	s tmpData=""
	s tmpVouchNo2=""
	f j = 1:1:tmpCC
	{
		i j=1 d ///maybe change
		.s tmpData=rs.GetData(j)
		.s tmpVouchNo = $o(^User.ACCTVouchBussI("PKBussnoVouch"," "_tmpData,""))
		.;w tmpVouchNo,!
		.i (tmpVouchNo'="")&&($g(^User.ACCTVouchD(tmpVouchNo))'="") d
		..s tmpVouchNo2 = $LIST(^User.ACCTVouchD(tmpVouchNo),18)
		..;w tmpVouchNo2,!
		e  d
		.s tmpData=tmpData_"^"_rs.GetData(j)
	}
	s tmpData=tmpData_"^"_tmpVouchNo2
	i (count>=start)&(count<=end) d
	.d json.InsertRowData(tmpData)
	s count=count+1
 }
 d rs.Close()
 s resultString = json.getJsonData(jsonTitle,count)
 k json
 q resultString
}

/*
{results:3,rows:[{InvNo:'20100706',InvDate:'2010-07-06',ItmDesc:'(达菲)磷酸奥司他韦胶囊[75mg*10]',Spec:'75mg*10',TrUom:'盒(10粒)',TrQty:'20',Rp:'256',RpAmt:'5120.0000',Sp:'270',SpAmt:'5400.0000'},
				 {InvNo:'20100706',InvDate:'2010-07-06',ItmDesc:'(阿莫仙)阿莫西林胶囊[0.5g*24]',Spec:'0.5g*24',TrUom:'盒(24粒)',TrQty:'30',Rp:'23',RpAmt:'690.0000',Sp:'26',SpAmt:'780.0000'},
				 {InvNo:'20100706',InvDate:'2010-07-06',ItmDesc:'阿莫西林胶囊[0.25*30]b',Spec:'0.25g*30',TrUom:'瓶(30粒)',TrQty:'40',Rp:'3',RpAmt:'120.0000',Sp:'9.2',SpAmt:'368.0000'}
				 ]
}
*/
/// w ##class(web.ACCTQueryToJson).GetDhcDataDetailJson("GG20100706R001","1")
ClassMethod GetDhcDataDetailJson(trNo As %String, busiTypeId As %String) As %String
{
 n (trNo,busiTypeId)
 s rs=##class(%ResultSet).%New()
 s rs.ClassName="web.ACCTCreateData"
 s rs.QueryName="GetDhcDataDetail"
 d rs.Execute(trNo,busiTypeId)
 s json=##class(web.com.JsonObj).%New()
 s jsonTitle=""
 s tmpCC=rs.GetColumnCount()
 f i = 1:1:tmpCC
 {
	i i=1  d
	.s jsonTitle=rs.GetColumnHeader(i)
	e  d
	.s jsonTitle=jsonTitle_"^"_rs.GetColumnHeader(i)
 }
 s count=0
 While (rs.Next())
 {
	s tmpData=""
	f j = 1:1:tmpCC
	{
		i j=1 d
		.s tmpData=rs.GetData(j)
		e  d
		.s tmpData=tmpData_"^"_rs.GetData(j)
	}
	d json.InsertRowData(tmpData)
	s count=count+1
 }
 d rs.Close()
 s resultString = json.getJsonData(jsonTitle,count)
 k json
 q resultString
}

Storage Default
{
<StreamLocation>^web.ACCTQueryToJsonS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
