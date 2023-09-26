Class CHSSWeb.P8Active3 Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod ActiveAll() As %String
{
	;add by wangbo 2009-12-13
	
	;家庭档案判断重复
	w ##class(CHSSWeb.FamilyService).existFamilyCode("111")
	w ##class(CHSSWeb.FamilyService).existFamilyAddress(0,"add",1,"111","") 
	;个人档案判断重复
	w ##class(CHSSWeb.PHRService).existHouseHold("100",1,"add","",1)
	w ##class(CHSSWeb.PHRService).existColumn("IDCard","111","add","")
	w ##class(CHSSWeb.PHRService).existColumn("IDCard","111","edit","1")
	w ##class(CHSSWeb.PHRService).existCardNumber("111","add","")
	w ##class(CHSSWeb.PHRService).existCardNumber("111","edit","1")
	w ##class(CHSSWeb.PHRService).existPersonCode("111")
	;预约管理判断重复
	w ##class(CHSSWeb.PersonBookingCheckService).existHDFPRecord(26, 1, 1)
	w ##class(CHSSWeb.PersonBookingCheckService).GetBookingCount("100",0,10,""," and CHSS.PersonBookingCheck.DateOfBooking < '61709'")
	w ##class(CHSSWeb.PersonBookingCheckService).ListElder("100",0,10,""," and booking.DateOfBooking between '61711' and '61712' ","31")
	w ##class(CHSSWeb.PersonBookingCheckService).List("100",0,10,"","")
	;机构设置判断重复
	;w ##class(CHSSWeb.DictProvinceService).existCode("1")
	w ##class(CHSSWeb.DictCityService).existCode("1")
	w ##class(CHSSWeb.DictSectionService).existCode("1")
	w ##class(CHSSWeb.DictStreetService).existCode("1")
	w ##class(CHSSWeb.DictVillageService).existCode("1")
	;家庭档案导入个人档案
	w ##class(CHSSWeb.PHROtherService).SetFamilyRowId("-1","-1")
	;人员字典查询
	w ##class(CHSSWeb.CommonDictService).ListOldSearch(0,10,"SS_User"," SSUSR_Name like '%fh%' and SSUsr_Hospital_DR->HOSP_Code = '103'")
	;基本字典管理
	w ##class(CHSSWeb.DictService).delete("9999", "DictPointHospital") 
	w ##class(CHSSWeb.DictService).delete("9999", "DictCommittee") 
	w ##class(CHSSWeb.DictService).delete("9999", "DictPolice") 
	w ##class(CHSSWeb.DictService).update("9999", "9999","ceshi", "", "", "true", "", "DictPointHospital")
	w ##class(CHSSWeb.DictService).update("9999", "9999","ceshi", "", "", "true", "", "DictCommittee")
	w ##class(CHSSWeb.DictService).update("9999", "9999","ceshi", "", "", "true", "", "DictPolice") 
	;长期用药
	w ##class(CHSSWeb.PersonLongTermDrugService).ShowInfo1(0,10,26,1,"PersonTBCheckRecord")
	w ##class(CHSSWeb.PersonLongTermDrugService).ShowInfo1(0,10,26,1,"PersonTBCheckRecord")
	w ##class(CHSSWeb.PersonLongTermDrugService).ListPage1(0,10,26,1,"PersonTBCheckRecord")
	;测量血糖规律
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictBloodSurgeRate")
	w ##class(CHSSWeb.CommonDictService).ListSearch(0,100,"DictBloodSurgeRate","dd")
	;老年人症状
	w ##class(CHSSWeb.DictChronicSymptomService).ListPage(0,100,1,"eldersymptom")
	;w ##class(CHSSWeb.DictChronicSymptomService).ShowInfo(0,100,1,"DictChronicSymptom")
	;
	;饮用水来源(家庭档案)
	w ##class(CHSSWeb.DictHospitalService).ListSearch(0,100,"DictWaterSource","",1)
	w ##class(CHSSWeb.DictService).ListPage1(0,100,"DictWaterSource")
	;个人档案判断卡号是否重复 add by wangbo 2009-12-22
	w ##class(CHSSWeb.PHRService).CardNumberCheck("123","add","")
	w ##class(CHSSWeb.PHRService).CardNumberCheck("123","edit","123")
	;村机构激活
	w ##class(CHSSWeb.DictVillageService).ListPage(0,10,"")
	;虚拟卡号激活
	w ##class(CHSSWeb.CardNumberService).GetCardNumber()
	w ##class(CHSSWeb.CardNumberService).GetCardNumberWithTable("00502", "CARDNUMBER")
	w ##class(CHSSWeb.HISInfoTranCardService).HISInfoTranCardTest()
	
	,!
	w ""
	,!
	w "P8Active3的激活已执行完毕"
	,!

	q ""
}

Storage Default
{
<Data name="P8Active3DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.P8Active3D</DataLocation>
<DefaultData>P8Active3DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.P8Active3D</IdLocation>
<IndexLocation>^CHSSWeb.P8Active3I</IndexLocation>
<StreamLocation>^CHSSWeb.P8Active3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
