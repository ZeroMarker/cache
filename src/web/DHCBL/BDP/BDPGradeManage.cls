Class web.DHCBL.BDP.BDPGradeManage Extends %RegisteredObject
{

/// w ##class(web.DHCBL.BDP.BDPGradeManage).GetTreeJson("410000171888","494")
ClassMethod GetTreeJson(LastLevel As %String, HospId As %String) As %String
{
	
	/*if (LastLevel="TreeRoot"){
		s LastLevel = ""	
	}*/
	s myJsonStr=""
	s myRowID=0
	s myCount=0
	s mySeq=0
	k myArray
	
	s RowID = $o(^CHSS.DictHospitalI("CommunityCodeIndex",LastLevel,0))
	s Name = $listget($g(^CHSS.DictHospitalD(RowID)),4)
	s Type = $listget($g(^CHSS.DictHospitalD(RowID)),5)
	s HospitalDR = $listget($g(^CHSS.DictHospitalD(RowID)),6)
	if (HospitalDR=HospId){
		s myJsonStr=myJsonStr_"{"
		s myJsonStr=myJsonStr_"""id"":"""_""_LastLevel_""",""text"":"""_Name_""","	

		if (Type="省卫生厅"){s myJsonStr=myJsonStr_"""iconCls"":""icon-treeProvince"","}
		elseif (Type="市卫生局"){s myJsonStr=myJsonStr_"""iconCls"":""icon-treeCity"","}
		elseif (Type="县（区）卫生局"){s myJsonStr=myJsonStr_"""iconCls"":""icon-treeSection"","}
		elseif (Type="乡镇卫生院"){s myJsonStr=myJsonStr_"""iconCls"":""icon-treeStreet"","}
		elseif (Type="社区卫生服务中心"){s myJsonStr=myJsonStr_"""iconCls"":""icon-treeCenter"","}
		elseif (Type="社区卫生服务站"){s myJsonStr=myJsonStr_"""iconCls"":""icon-treeStation"","}
		elseif (Type="村卫生所"){s myJsonStr=myJsonStr_"""iconCls"":""icon-treeVillage"","}
		s myJsonStr=myJsonStr_"""leaf"":false,"
		s myJsonStr=myJsonStr_"""expanded"":false,"
		s myJsonStr=myJsonStr_"""children"":["_..GetTreeJson2(LastLevel)_"]"
		s myJsonStr=myJsonStr_"}"
	}
	else{
		s myJsonStr=..GetTreeJson2(LastLevel)	
	}

	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// w ##class(web.DHCBL.BDP.BDPGradeManage).GetTreeJson2("410000171888")
ClassMethod GetTreeJson2(LastLevel As %String) As %String
{
	
	/*if (LastLevel="TreeRoot"){
		s LastLevel = ""	
	}*/
	s myJsonStr=""
	s myRowID=0
	s myCount=0
	s mySeq=0
	k myArray
	
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^CHSS.DictHospitalI("UpCommunityCodeIndex"," "_LastLevel,mySeq))
		q:(mySeq="")
		s CommunityCode = $listget($g(^CHSS.DictHospitalD(mySeq)),2)
		s CommunityType = $listget($g(^CHSS.DictHospitalD(mySeq)),5)
		s UpCommunityCode = $listget($g(^CHSS.DictHospitalD(mySeq)),9)
		if (LastLevel="") continue:CommunityType'="市卫生局"
		s n=n+1
		s myArray(n)= CommunityCode
	}
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s myJsonStr=""
	
	for {
		;q:(+mySeq>1)
		s mySeq=$o(myArray(mySeq))
		q:(mySeq="")
		s CommunityCode=$g(myArray(mySeq))
		s myRowID = $o(^CHSS.DictHospitalI("CommunityCodeIndex",CommunityCode,0))
		s myObj=##Class(CHSS.DictHospital).%OpenId(myRowID,0)
		if $IsObject(myObj) {
			s myCode = myObj.CommunityCode
			s myDesc = myObj.CommunityName
			s myType = myObj.CommunityType
			
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"
			s myJsonStr=myJsonStr_"""id"":"""_""_myCode_""",""text"":"""_myDesc_""","

			if (myType="省卫生厅"){s myJsonStr=myJsonStr_"""iconCls"":""icon-treeProvince"","}
			elseif (myType="市卫生局"){s myJsonStr=myJsonStr_"""iconCls"":""icon-treeCity"","}
			elseif (myType="县（区）卫生局"){s myJsonStr=myJsonStr_"""iconCls"":""icon-treeSection"","}
			elseif (myType="乡镇卫生院"){s myJsonStr=myJsonStr_"""iconCls"":""icon-treeStreet"","}
			elseif (myType="社区卫生服务中心"){s myJsonStr=myJsonStr_"""iconCls"":""icon-treeCenter"","}
			elseif (myType="社区卫生服务站"){s myJsonStr=myJsonStr_"""iconCls"":""icon-treeStation"","}
			elseif (myType="村卫生所"){s myJsonStr=myJsonStr_"""iconCls"":""icon-treeVillage"","}
		
			s myJsonStr=myJsonStr_"""leaf"":false,"
			s myJsonStr=myJsonStr_"""expanded"":false"
			s myJsonStr=myJsonStr_"}"
		}
		d myObj.%Close()
	
	}
	k myArray
	q myJsonStr
}

/// Creator：高姗姗
/// CreatDate: 2015-9-23
/// Description：查询根节点code
/// Other: w ##class(web.DHCBL.BDP.BDPGradeManage).GetRootId(208)
ClassMethod GetRootId(HOSPRowId As %String) As %String
{
	s RootId=""
	
	if (HOSPRowId'=""){
		s RowId = $o(^CHSS.DictHospitalI("HospitalIndex",HOSPRowId,0))
		if (RowId'=""){
			s CommunityCode = $listget($g(^CHSS.DictHospitalD(RowId)),2)
			s RootId=CommunityCode
		}else{
			s RowId=0
			for {
				s RowId=$o(^CHSS.DictHospitalI("UpCommunityCodeIndex"," ",RowId)) q:(RowId="")
				s CommunityCode = $listget($g(^CHSS.DictHospitalD(RowId)),2)
				s CommunityType = $listget($g(^CHSS.DictHospitalD(RowId)),5)
				if (CommunityType'="市卫生局") continue
				s RootId=CommunityCode
			}
		}
	}else{
		s RowId=0
		for {
			s RowId=$o(^CHSS.DictHospitalI("UpCommunityCodeIndex"," ",RowId)) q:(RowId="")
			s CommunityCode = $listget($g(^CHSS.DictHospitalD(RowId)),2)
			s CommunityType = $listget($g(^CHSS.DictHospitalD(RowId)),5)
			if (CommunityType'="市卫生局") continue
			s RootId=CommunityCode
		}
	}
	q RootId
}

/// Creator：高姗姗
/// CreatDate: 2015-9-8
/// Description：查询当前级及当前子级医院
/// Other: w ##class(web.DHCBL.BDP.BDPGradeManage).GetHospital("")
ClassMethod GetHospital(id As %String) As %String
{
    s HospitalDRs=""
    if (id'=""){
	s myRowID = $o(^CHSS.DictHospitalI("CommunityCodeIndex",id,0))
	s HospitalDR = $listget($g(^CHSS.DictHospitalD(myRowID)),6)
	s HospitalDRs = "<"_HospitalDR_">"                 //当前级医疗机构
	s RowId=0
	for {
		s RowId=$o(^CHSS.DictHospitalI("UpCommunityCodeIndex"," "_id,RowId))  q:RowId=""
		s CommunityCode = $listget($g(^CHSS.DictHospitalD(RowId)),2)
		s HospitalDR = $listget($g(^CHSS.DictHospitalD(RowId)),6)
		
		s HospitalDRs = HospitalDRs_"^<"_HospitalDR_">"	  //当前下级医疗机构
	}	
	}
	q HospitalDRs
}

/// Creator：高姗姗
/// CreatDate: 2015-10-27
/// Description：查询当前级医院
/// Other: w ##class(web.DHCBL.BDP.BDPGradeManage).GetCurrentHospital("410000171888")
ClassMethod GetCurrentHospital(id As %String) As %String
{
    s HospitalDRs=""
    if (id'=""){
	s myRowID = $o(^CHSS.DictHospitalI("CommunityCodeIndex",id,0))
	s HospitalDR = $listget($g(^CHSS.DictHospitalD(myRowID)),6)
	s HospitalDRs = "<"_HospitalDR_">"                 //当前级医疗机构
	}
	q HospitalDRs
}

}
