Class web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PataddressInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wl
/// CreatDate：2020-12-22
/// Description：根据id取患者地址表(ACC0003)
/// Table：PA_PatMas
/// Input：patRowId：患者ID
/// Output： 
/// Return：数据中心pa_address患者地址表((json)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PataddressInfo).paaddressById("10480000")
ClassMethod paaddressById(patRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Data).%New()
	set obj.theme="theme001"
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Paidentifier).%New()
	if (patRowId="")||($d(^PAPER(patRowId))=0) {
		d stream.Write("{""theme"":""theme001"",""error""patRowId病人id不能为空"":"",""data"":[]}")
		quit stream	
	}
	set tSC=..getSubAdressInfo(patRowId,.obj)
	d obj.XMLExportToString(.String)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream

Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

/// / w ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PatientInfo).getSubAdressInfo(10,.obj)
ClassMethod getSubAdressInfo(patRowId As %String, Output Arr As web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Data) As %Status
{
	set Arr=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Paaddress).%New()
	///现住址
	set subObj.papatadtypecode="09" //现住址
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                        //业务域
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId	//全局患者id
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	set UpdateUserDr=$p($g(^PAPER(patRowId,"PER",4)),"^",7)      //最后更新人编码
	set subObj.papatadupdateusercode=UpdateUserDr
	set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
	set:UpdateDate'="" subObj.papatadupdatedate=$zd(UpdateDate,3) //最后更新日期
	set UpdateTime=$p($g(^PAPER(patRowId,"PER",5)),"^",3)           
	set:UpdateTime'="" subObj.papatadupdatetime=$zt(UpdateTime,1) //最后更新时间

	set ProvinceRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",2) 
	if (ProvinceRowID'="") { 
	set subObj.papatadprovincecode=ProvinceRowID
	set Region=$P($g(^CT("PROV",ProvinceRowID)),"^",3)
	set subObj.papatadcountrycode=Region
	}
	set CityCodeRowID=$P($g(^PAPER(patRowId,"PER",1)),"^",5) 
	set subObj.papatadcitycode=CityCodeRowID
	set CityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
	set subObj.papatadcountycode=CityAreaRowID
	set subObj.papatadtown=""          //	乡（镇、街道办事处）
	set subObj.papatadvillage=""          //	村（街、路、弄等）
	set subObj.papatadhouseno=""          //	门牌号码
	set subObj.papatadzip=""          //	邮政编码
	set subObj.papataddesc=$g(^PAPER(patRowId,"PER","ADD",1))    //地址描述
	if (subObj.papataddesc'=""){
		d Arr.PaaddressList.Insert(subObj)
	}
	set DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",patRowId,""))
	//b //出生地
	if DHCPersonID'="" {
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Paaddress).%New()
	set subObj.papatadtypecode="06" //出生地址类型
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                        //业务域
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId	//全局患者id
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	set UpdateUserDr=$p($g(^PAPER(patRowId,"PER",4)),"^",7)      //最后更新人编码
	set subObj.papatadupdateusercode=UpdateUserDr
	set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
	set:UpdateDate'="" subObj.papatadupdatedate=$zd(UpdateDate,3) //最后更新日期
	set UpdateTime=$p($g(^PAPER(patRowId,"PER",5)),"^",3)           
	set:UpdateTime'="" subObj.papatadupdatetime=$zt(UpdateTime,1) //最后更新时间
	set BirthProvinceRowID=$P(^DHCPERSON(DHCPersonID),"^",13)  
	if (BirthProvinceRowID'=""){
		set subObj.papatadprovincecode=BirthProvinceRowID
		set Region=$P($g(^CT("PROV",BirthProvinceRowID)),"^",3)
		set subObj.papatadcountrycode=Region
	}
	set BirthCityRowID=$P(^DHCPERSON(DHCPersonID),"^",14) 
	set subObj.papatadcitycode=BirthCityRowID
	set CountyRowID=$P(^DHCPERSON(DHCPersonID),"^",15)
	set subObj.papatadcountycode=CountyRowID
	set subObj.papatadtown=""           //乡（镇、街道办事处）
	set subObj.papatadvillage=""       //村（街、路、弄等）
	set subObj.papatadhouseno=""       //门牌号码
	set subObj.papatadzip=""           //	邮政编码
	set subObj.papataddesc=$P(^DHCPERSON(DHCPersonID),"^",16)   //地址描述
	if ((BirthProvinceRowID'="")||(BirthCityRowID'="")){
		d Arr.PaaddressList.Insert(subObj)
	}
	 }
	//b //户口地址
	if DHCPersonID'="" {
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Paaddress).%New()
	set subObj.papatadtypecode="01" //户口地址
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                        //业务域
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId	//全局患者id
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	set UpdateUserDr=$p($g(^PAPER(patRowId,"PER",4)),"^",7)      //最后更新人编码
	set subObj.papatadupdateusercode=UpdateUserDr
	set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
	set:UpdateDate'="" subObj.papatadupdatedate=$zd(UpdateDate,3) //最后更新日期
	set UpdateTime=$p($g(^PAPER(patRowId,"PER",5)),"^",3)           
	set:UpdateTime'="" subObj.papatadupdatetime=$zt(UpdateTime,1) //最后更新时间
	set countryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	set ProvinceRowID=$P(^DHCPERSON(DHCPersonID),"^",17) 
	if (ProvinceRowID'="") { 
	set subObj.papatadprovincecode=ProvinceRowID
	set Region=$P($g(^CT("PROV",ProvinceRowID)),"^",3)
	set subObj.papatadcountrycode=Region
	}
	set CityCodeRowID=$P(^DHCPERSON(DHCPersonID),"^",18) 
	set subObj.papatadcitycode=CityCodeRowID
	set CityAreaRowID=$P(^DHCPERSON(DHCPersonID),"^",19) 
	set subObj.papatadcountycode=CityAreaRowID
	set subObj.papataddesc=$P(^DHCPERSON(DHCPersonID),"^",20)       //地址描述  
	set subObj.papatadzip=$p($g(^DHCPERSON(DHCPersonID)),"^",8)     //	邮政编码
	set subObj.papatadtown=""                        //乡（镇、街道办事处)
	set subObj.papatadvillage=""                    //村（街、路、弄等）
	set subObj.papatadhouseno=""                    //门牌号码
	if ((ProvinceRowID'="")||(CityCodeRowID'="")||(CityAreaRowID'="")){
		d Arr.PaaddressList.Insert(subObj)
		}
	}
	//b //籍贯地址
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Paaddress).%New()
	set subObj.papatadtypecode="99" //籍贯地址
		set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                        //业务域
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId	//全局患者id
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	set UpdateUserDr=$p($g(^PAPER(patRowId,"PER",4)),"^",7)      //最后更新人编码
	set subObj.papatadupdateusercode=UpdateUserDr
	set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
	set:UpdateDate'="" subObj.papatadupdatedate=$zd(UpdateDate,3) //最后更新日期
	set UpdateTime=$p($g(^PAPER(patRowId,"PER",5)),"^",3)           
	set:UpdateTime'="" subObj.papatadupdatetime=$zt(UpdateTime,1) //最后更新时间
	set jgProvinceId=$P($g(^PAPER(patRowId,"PER",2)),"^",11)
	if (jgProvinceId'="") {
	set subObj.papatadprovincecode=jgProvinceId
	set Region=$P($g(^CT("PROV",jgProvinceId)),"^",3)
	set subObj.papatadcountrycode=Region
	}
	s jgCityId=$P($g(^PAPER(patRowId,"ALL")),"^",18) 
	set subObj.papatadcitycode=jgCityId
	set subObj.papatadcountycode=""  //县（区）
	set subObj.papatadtown=""        //乡（镇、街道办事处）
	set subObj.papatadvillage=""     //村（街、路、弄等）
	set subObj.papatadhouseno=""     //门牌号码
	set subObj.papatadzip=""         //邮政编码
	set subObj.papataddesc=""        //地址描述
	if ((jgProvinceId'="")||(jgCityId'="")){
		d Arr.PaaddressList.Insert(subObj)
	}
	Quit 1
}

/// Creator：wl
/// CreatDate：2020-12-22
/// Description：根据id取患者地址表(ACC0003)历史数据 Global
/// Table：PA_PatMas
/// Input：patRowId：患者ID
/// Output： 
/// Return：数据中心pa_address患者地址表((Global)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PataddressInfo).paaddressGlobal("1","1486515")
ClassMethod paaddressGlobal(strpatRowId As %String, endpatRowId As %String) As %String
{
	set $zt="Exception"
	set ^ExportHistoryData("paaddress")=$lb("全局患者id","地址类型","国家","省（自治区、直辖市）","市（地区、州）","县（区）","乡（镇、街道办事处）","村（街、路、弄等）","门牌号码","邮政编码","地址描述","最后更新人编码","最后更新日期","最后更新时间","时间戳","时间戳")
	if (strpatRowId="")||(endpatRowId="") {
		quit "-1^patRowId病人id不能为空"
	}
	set patRowId="",con=0,strtime=$zt($p($now(),",",2))
	for patRowId=strpatRowId:1:endpatRowId{
		set int=0
		continue:$d(^PAPER(patRowId))=0
		continue:$p($g(^PAPER(patRowId,"PAT",1)),"^",1)=""
		set int=..getSubAdressGlobal(patRowId)
		set con=con+int
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strpatRowId, endpatRowId, con, patRowId)
		}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

ClassMethod getSubAdressGlobal(patRowId As %String)
{
	
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Paaddress).%New()
	set int=0
	///现住址
	set subObj.papatadtypecode="09" //现住址
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                        //业务域
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId	//全局患者id
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	set subObj.papatadupdateusercode="",subObj.papatadupdatedate="",subObj.papatadupdatetime=""
	set UpdateUserDr=$p($g(^PAPER(patRowId,"PER",4)),"^",7)      //最后更新人编码
	set subObj.papatadupdateusercode=UpdateUserDr
	set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
	set:UpdateDate'="" subObj.papatadupdatedate=$zd(UpdateDate,3) //最后更新日期
	set UpdateTime=$p($g(^PAPER(patRowId,"PER",5)),"^",3)           
	set:UpdateTime'="" subObj.papatadupdatetime=$zt(UpdateTime,1) //最后更新时间
	set ProvinceRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",2) 
	if (ProvinceRowID'="") { 
	set subObj.papatadprovincecode=ProvinceRowID
	set Region=$P($g(^CT("PROV",ProvinceRowID)),"^",3)
	s subObj.papatadcountrycode="",subObj.papatadcitycode="",subObj.papatadcountycode=""
	set subObj.papatadcountrycode=Region
	}
	set CityCodeRowID=$P($g(^PAPER(patRowId,"PER",1)),"^",5) 
	set subObj.papatadcitycode=CityCodeRowID
	set CityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
	set subObj.papatadcountycode=CityAreaRowID
	set subObj.papatadtown=""          //	乡（镇、街道办事处）
	set subObj.papatadvillage=""          //	村（街、路、弄等）
	set subObj.papatadhouseno=""          //	门牌号码
	set subObj.papatadzip=""          //	邮政编码
	set subObj.papataddesc=$g(^PAPER(patRowId,"PER","ADD",1))    //地址描述
	if (subObj.papataddesc'=""){
		set int=int+1
		set ^ExportHistoryData("paaddress",patRowId_subObj.papatadtypecode)=$lb(subObj.papatrelpatientid,subObj.papatadtypecode,subObj.papatadcountrycode,subObj.papatadprovincecode,subObj.papatadcitycode,subObj.papatadcountycode,subObj.papatadtown,subObj.papatadvillage,subObj.papatadhouseno,subObj.papatadzip,subObj.papataddesc,subObj.papatadupdateusercode,subObj.papatadupdatedate,subObj.papatadupdatetime,subObj.updatedate,subObj.updatetime)
	}
	set DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",patRowId,""))

	//b //出生地
	if DHCPersonID'="" {
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Paaddress).%New()
	set subObj.papatadtypecode="06" //出生地址类型
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                        //业务域
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId	//全局患者id
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	set UpdateUserDr=$p($g(^PAPER(patRowId,"PER",4)),"^",7)      //最后更新人编码
	set subObj.papatadupdateusercode=UpdateUserDr
	set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
	set:UpdateDate'="" subObj.papatadupdatedate=$zd(UpdateDate,3) //最后更新日期
	set UpdateTime=$p($g(^PAPER(patRowId,"PER",5)),"^",3)           
	set:UpdateTime'="" subObj.papatadupdatetime=$zt(UpdateTime,1) //最后更新时间
	set BirthProvinceRowID=$P(^DHCPERSON(DHCPersonID),"^",13)  
	if (BirthProvinceRowID'=""){
		set Region=$P($g(^CT("PROV",BirthProvinceRowID)),"^",3)
		set subObj.papatadcountrycode=Region
	}
	set BirthCityRowID=$P(^DHCPERSON(DHCPersonID),"^",14) 
	set subObj.papatadcitycode=BirthCityRowID 
	set CountyRowID=$P(^DHCPERSON(DHCPersonID),"^",15)
	set subObj.papatadcountycode=CountyRowID
	set subObj.papatadtown=""           //乡（镇、街道办事处）
	set subObj.papatadvillage=""       //村（街、路、弄等）
	set subObj.papatadhouseno=""       //门牌号码
	set subObj.papatadzip=""           //	邮政编码
	set subObj.papataddesc=$P(^DHCPERSON(DHCPersonID),"^",16)   //地址描述
	if ((BirthProvinceRowID'="")||(BirthCityRowID'="")){
		set int=int+1
		set ^ExportHistoryData("paaddress",patRowId_subObj.papatadtypecode)=$lb(subObj.papatrelpatientid,subObj.papatadtypecode,subObj.papatadcountrycode,subObj.papatadprovincecode,subObj.papatadcitycode,subObj.papatadcountycode,subObj.papatadtown,subObj.papatadvillage,subObj.papatadhouseno,subObj.papatadzip,subObj.papataddesc,subObj.papatadupdateusercode,subObj.papatadupdatedate,subObj.papatadupdatetime,subObj.updatedate,subObj.updatetime)
	}
	 }
	//b //户口地址
	if DHCPersonID'="" {
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Paaddress).%New()
	set subObj.papatadtypecode="01" //户口地址
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                        //业务域
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId	//全局患者id
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	set UpdateUserDr=$p($g(^PAPER(patRowId,"PER",4)),"^",7)      //最后更新人编码
	set subObj.papatadupdateusercode=UpdateUserDr
	set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
	set:UpdateDate'="" subObj.papatadupdatedate=$zd(UpdateDate,3) //最后更新日期
	set UpdateTime=$p($g(^PAPER(patRowId,"PER",5)),"^",3)           
	set:UpdateTime'="" subObj.papatadupdatetime=$zt(UpdateTime,1) //最后更新时间
	set countryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	set ProvinceRowID=$P(^DHCPERSON(DHCPersonID),"^",17) 
	if (ProvinceRowID'="") { 

	set subObj.papatadprovincecode=ProvinceRowID
	set Region=$P($g(^CT("PROV",ProvinceRowID)),"^",3)
	set subObj.papatadcountrycode=Region
	}
	set CityCodeRowID=$P(^DHCPERSON(DHCPersonID),"^",18) 
	set subObj.papatadcitycode=CityCodeRowID
	set CityAreaRowID=$P(^DHCPERSON(DHCPersonID),"^",19) 
	set subObj.papatadcountycode=CityAreaRowID
	set subObj.papataddesc=$P(^DHCPERSON(DHCPersonID),"^",20)       //地址描述  
	set subObj.papatadzip=$p($g(^DHCPERSON(DHCPersonID)),"^",8)     //	邮政编码
	set subObj.papatadtown=""                        //乡（镇、街道办事处)
	set subObj.papatadvillage=""                    //村（街、路、弄等）
	set subObj.papatadhouseno=""                    //门牌号码
	if ((ProvinceRowID'="")||(CityCodeRowID'="")||(CityAreaRowID'="")){
		set int=int+1
		set ^ExportHistoryData("paaddress",patRowId_subObj.papatadtypecode)=$lb(subObj.papatrelpatientid,subObj.papatadtypecode,subObj.papatadcountrycode,subObj.papatadprovincecode,subObj.papatadcitycode,subObj.papatadcountycode,subObj.papatadtown,subObj.papatadvillage,subObj.papatadhouseno,subObj.papatadzip,subObj.papataddesc,subObj.papatadupdateusercode,subObj.papatadupdatedate,subObj.papatadupdatetime,subObj.updatedate,subObj.updatetime)		
	}
	}
	
	//b //籍贯地址
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Paaddress).%New()
	set subObj.papatadtypecode="99" //籍贯地址
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                        //业务域
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId	//全局患者id
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	set UpdateUserDr=$p($g(^PAPER(patRowId,"PER",4)),"^",7)      //最后更新人编码
	set subObj.papatadupdateusercode=UpdateUserDr
	set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
	set:UpdateDate'="" subObj.papatadupdatedate=$zd(UpdateDate,3) //最后更新日期
	set UpdateTime=$p($g(^PAPER(patRowId,"PER",5)),"^",3)           
	set:UpdateTime'="" subObj.papatadupdatetime=$zt(UpdateTime,1) //最后更新时间
	set jgProvinceId=$P($g(^PAPER(patRowId,"PER",2)),"^",11)
	if (jgProvinceId'="") {
	set subObj.papatadprovincecode=jgProvinceId
	set Region=$P($g(^CT("PROV",jgProvinceId)),"^",3)
	set subObj.papatadcountrycode=Region
	}
	s jgCityId=$P($g(^PAPER(patRowId,"ALL")),"^",18) 
	set subObj.papatadcitycode=jgCityId
	set subObj.papatadcountycode=""  //县（区）
	set subObj.papatadtown=""        //乡（镇、街道办事处）
	set subObj.papatadvillage=""     //村（街、路、弄等）
	set subObj.papatadhouseno=""     //门牌号码
	set subObj.papatadzip=""         //邮政编码
	set subObj.papataddesc=""        //地址描述
	if ((jgProvinceId'="")||(jgCityId'="")){
		set int=int+1
		set ^ExportHistoryData("paaddress",patRowId_subObj.papatadtypecode)=$lb(subObj.papatrelpatientid,subObj.papatadtypecode,subObj.papatadcountrycode,subObj.papatadprovincecode,subObj.papatadcitycode,subObj.papatadcountycode,subObj.papatadtown,subObj.papatadvillage,subObj.papatadhouseno,subObj.papatadzip,subObj.papataddesc,subObj.papatadupdateusercode,subObj.papatadupdatedate,subObj.papatadupdatetime,subObj.updatedate,subObj.updatetime)
	}
	Quit int
}

}
