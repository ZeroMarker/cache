Class dhcinterface.OrderItemMsg Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property OrderItems As list Of OrderItem;

ClassMethod Insert(XmlPara As %String) As %String
{
	;s XmlPara="<Request><OrderItems><OrderItem><PatientID>00227</PatientID><EpisodeID></EpisodeID><HISItemCode>ABOXXJD3</HISItemCode><ItemCode>xxjdyq</ItemCode><ItemName>ABO血型鉴定微柱法</ItemName><Qty>1.00</Qty><Unit>次</Unit><Price>50.0000</Price><Total>50.00</Total><DateAdd>2008-11-07</DateAdd><TimeAdd>15:22:13</TimeAdd><UserCode>23202</UserCode><Notes>查验费用</Notes></OrderItem><OrderItem><PatientID>00227</PatientID><EpisodeID></EpisodeID><HISItemCode>RHXXJD2</HISItemCode><ItemCode>rhjd</ItemCode><ItemName>Rh血型鉴定费用</ItemName><Qty>1.00</Qty><Unit>次</Unit><Price>20.0000</Price><Total>20.00</Total><DateAdd>2008-11-07</DateAdd><TimeAdd>15:22:13</TimeAdd><UserCode>23202</UserCode><Notes>查验费用</Notes></OrderItem></OrderItems></Request>"
	;s XmlPara="<Request><OrderItems><OrderItem><PatientID>00227</PatientID><EpisodeID></EpisodeID><HISItemCode>ABOXXJD3</HISItemCode><ItemCode>xxjdyq</ItemCode><ItemName></ItemName><Qty>1.00</Qty><Unit></Unit><Price>50.0000</Price><Total>50.00</Total><DateAdd>2008-11-07</DateAdd><TimeAdd>15:22:13</TimeAdd><UserCode>23202</UserCode><Notes></Notes></OrderItem></OrderItems></Request>"
	;           <Request><OrderItems><OrderItem><PatientID>04393</PatientID><EpisodeID>884695</EpisodeID><HISItemCode>XXBFLDC</HISItemCode><ItemCode>XXBFLDC</ItemCode><ItemName>FL</ItemName><Qty>1.00</Qty><Unit>ml</Unit><Price>1500.0000</Price><Total>1500.00</Total><DateAdd>2008-11-27</DateAdd><TimeAdd>21:59:52</TimeAdd><UserCode>23202 </UserCode><Notes>SG</Notes></OrderItem></OrderItems></Request>
	;s XmlPara="<Request><OrderItems><OrderItem><PatientID>43984</PatientID><EpisodeID>531581</EpisodeID><HISItemCode>6||1   </HISItemCode><DateAdd>2008-09-09</DateAdd><TimeAdd>10:00</TimeAdd><UserCode>demo</UserCode></OrderItem></OrderItems></Request>"
	;s XmlPara="<Request><OrderItems><OrderItem><PatientID>439864</PatientID></OrderItem></OrderItems></Request>"
	s ^zhou("xml")=XmlPara
	;s XmlPara=$g(^zhou("xml"))  ;cwg20081128
	s Xml=""
	SET $ZTRAP="err"
	Set reader = ##class(%XML.Reader).%New()
	Set sc=reader.OpenString(XmlPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit   
	Do reader.Correlate("Request","dhcinterface.OrderItemMsg")

	s Flag=0
 s ErrorMsg="医嘱信息有误"
 s ResultCode=1
	While reader.Next(.obj1,.sc)  {
		s Count=obj1.OrderItems.Count()
		for i=1:1:Count {
			s obj=obj1.OrderItems.GetAt(i)
			s ArcimId=obj.HISItemCode
			s EpisodeID=obj.EpisodeID
			s PatientID=obj.PatientID
			s AdmDate=$ZDH(obj.DateAdd,3)
			s AdmTime=$ZTH(obj.TimeAdd)
			s Qty=obj.Qty
			s Price=obj.Price
			s RecLocCode=$ZCVT(obj.RecLocCode,"U")
			s PatientID=+$g(^PAADM(EpisodeID))
			s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
			s AdmReason="" s AdmReason=##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
			s Price=obj.Price
			s UserCode=obj.UserCode
			s AdmDep=$P(^PAADM(EpisodeID),"^",4)
			;s RecLoc=20  cwg 2008.12.01
			;s UserRowId="1"  cwg 2008.12.01  下医嘱医生
			s UserCode=$ZCVT(UserCode,"U")
			;医嘱code转换为rowid  cwg2008.11.28
			//s UserCode="00327"
			i '$d(^ARCIM(0,"Code",ArcimId)) q
			i $d(^ARCIM(0,"Code",ArcimId)) d
			.s arcim=$o(^ARCIM(0,"Code",ArcimId,""))
			.s sub=$o(^ARCIM(0,"Code",ArcimId,arcim,""))
			.s ArcimId=arcim_"||"_sub
			;如果不传入接收科室代码则需要在此赋固定值
			s RecLoc="226"  ;输血科
			if RecLocCode'="" s RecLoc=$O(^CTLOC(0,"Code",RecLocCode,0))
			if UserCode'="" s UserRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
			s ret=$$insertitem()
			b
			If ret=0{
			   s ErrorMsg="插入医嘱成功"
			   s ResultCode=0
			}else{
			   s ResultCode=1
			   s ErrorMsg="医嘱插入失败 ReturnCode="_ret
			   s Flag=1
			   break
			}
		}
		if Flag=1 break
	} 
	s msgobj=##class(dhcinterface.ReturnMsg).%New()
	s msgobj.ResultCode=ResultCode
	s msgobj.ErrorMsg=ErrorMsg
	s status=msgobj.XMLExportToString(.Xml,"Response")
	If ($system.Status.IsError(status)) {
		Do $system.OBJ.DisplayError(status)
		s Xml=""
	}
	Q Xml
insertitem()
	s ordstr=ArcimId_"^"_Qty_"^"_RecLoc_"^"_Price_"^"_""_"^"_AdmReason_"^"_AdmDate_"^"_AdmTime
	//s ResValue=##Class(web.DHCOPCashier).Insert(EpisodeID,ordstr,UserRowId,AdmDep,"","")  //cwg20081128
	s ResValue=##Class(web.DHCOPCashier).Insert(EpisodeID,ordstr,UserRowId,AdmDep,UserRowId,"")
	s ^zhou("ResValue")=ordstr_"^"_EpisodeID_"^"_UserRowId_"^"_AdmDep
	s d=$p(ResValue,"^",1)
	b ;Insert PriceArcId
	if d'=0{
		Q "100"
	}
	d ##Class(web.DHCOPCashier).CreatePrescNo(EpisodeID)
	Q 0
err 
	s msgobj=##class(dhcinterface.ReturnMsg).%New()
	s msgobj.ResultCode=1
	s msgobj.ErrorMsg="插入失败!"
	s status=msgobj.XMLExportToString(.Xml,"Response")
	If ($system.Status.IsError(status)) {
		Do $system.OBJ.DisplayError(status)
		s Xml=""
	}
 Q Xml
}

}
