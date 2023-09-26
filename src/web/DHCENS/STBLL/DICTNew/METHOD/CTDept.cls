Class web.DHCENS.STBLL.DICTNew.METHOD.CTDept Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：科室字典信息
/// Table：CT_Loc
/// Input： 
/// Return：科室字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDept).GetCTDept("1").Read()
ClassMethod GetCTDept(Input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
		}
	if pList.Count()>0{
		set OutputStream=..GetCTDeptByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// 初始化导入数据时批量导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：科室字典信息
/// Table：CT_Loc
/// Input： 
/// Return：科室字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDept).SendCTDept("")
ClassMethod SendCTDept(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	if Input'=""{
		if $d(^CTLOC(Input)){
			do plist.SetAt(Input,count)
			set Instream=..GetCTDeptByID(plist)
			set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
			set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Dept",tSC)
		}
	}else{
		set rowid="0"  for  set rowid=$o(^CTLOC(rowid)) Quit:rowid=""  d
		.do plist.SetAt(rowid,count)
		.set count=count+1
		.if count>50 do
		..set Instream=..GetCTDeptByID(plist)
		..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Dept",tSC)
		..do tSC.OutputToDevice()
		..;b ;00
		..do Instream.Clear()
		..set count=1
		..do plist.Clear()
		set length=plist.Count()
		if length>0 d
		.set Instream=..GetCTDeptByID(plist)
		.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		.do tSC.OutputToDevice()
		
		.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Dept",tSC)
	}	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// 根据ID号列表取字典信息
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：科室字典信息
/// Table：CT_Loc
/// Input： 
/// Return：科室字典信息集合
ClassMethod GetCTDeptByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDept).%New()
		set insObj.CTDCode=$p($g(^CTLOC(rowid)),"^",1)
		set insObj.businessrowid=rowid
		set insObj.CTDRowId=rowid
		set insObj.CTDDesc=$p($g(^CTLOC(rowid)),"^",2)
		set insObj.CTDOfficeAddress=$p($g(^CTLOC(rowid)),"^",16) 
		set insObj.CTDCodesystemCode="CT_Dept"
		set hospId=$p(^CTLOC(rowid),"^",22)
		set:hospId="" hospId=$o(^CT("HOSP","0"))
		set hospCode=hospId  //$p(^CT("HOSP",hospId),"^",1)	
		set insObj.CTDHosCode=hospCode
		set insObj.CTDStatus="1"
		set ParentDeptInfo=..GetFirstGradeDept(rowid)
		set insObj.CTDRemarks=$p(ParentDeptInfo,"^",4)
		set insObj.CTDUpdateUserCode="无"
		set insObj.CTDCategoryCode=$p($g(^CTLOC(rowid)),"^",13)
		s:insObj.CTDCategoryCode="" insObj.CTDCategoryCode="O"	//2019-02-24加，其他分类
		set dateActiveFrom=$p($g(^CTLOC(rowid)),"^",24)
		set insObj.CTDStartDate=dateActiveFrom
		set dateActiveTo=$p($g(^CTLOC(rowid)),"^",25)
		i (dateActiveFrom'="")&&(dateActiveTo'=""){
			i dateActiveFrom>dateActiveTo{
				s dateActiveTo=dateActiveFrom+1
			}
		}
		set insObj.CTDEndDate=dateActiveTo
		set:dateActiveTo'="" insObj.CTDStatus="0"
		set insObj.CTDOfficePhone=$p($g(^CTLOC(rowid)),"^",40)
		set insObj.CTDParentDeptCode=$p(ParentDeptInfo,"^",2)
		set insObj.CTDParentDeptDesc=$p(ParentDeptInfo,"^",3)
		set insObj.CTDParentDeptType=$p(ParentDeptInfo,"^",5)
		set Phonetic=$p($g(^CTLOC(rowid)),"^",43)
		set:Phonetic="" Phonetic="无"
		set insObj.CTDPhonetic=Phonetic	;$p($g(^CTLOC(rowid)),"^",43)
		set ParentDeptRowid=$p(ParentDeptInfo,"^",1)
		set SuperDeptInfo=..GetSuperGradeDept(ParentDeptRowid)
		set insObj.CTDSuperDeptCode=$p(SuperDeptInfo,"^",1)
		set insObj.CTDSuperDeptDesc=$p(SuperDeptInfo,"^",2)
		if ##class(%Dictionary.MethodDefinition).%ExistsId("ext.util.String||ToChineseSpell")
		{
			set insObj.CTDSpell=##class(ext.util.String).ToChineseSpell(insObj.CTDDesc)
		}
		d ListInfo.CTDeptList.Insert(insObj)		
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDeptList",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Dept",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：zhengchenghou
/// CreatDate：2018—05-30
/// Description：科室字典信息
/// Table：CT_Loc
/// Input： 
/// Return：科室信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDept).CTDept("")
ClassMethod CTDept(input As %String) As %String
{
	set $zt="MsgErr"
	set List=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set rowid="0" f  set rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.Quit:((rowid'=input)&&(input'=""))
	.set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDept).%New()
	.set insObj.CTDCode=$p($g(^CTLOC(rowid)),"^",1)
	.set insObj.CTDDesc=$p($g(^CTLOC(rowid)),"^",2)
	.set insObj.CTDOfficeAddress=$p($g(^CTLOC(rowid)),"^",16) ;$g(^CTLOC(rowid,"ADDR"))
	.set insObj.CTDCodesystemCode="CT_Dept"
	.set hospId=$p(^CTLOC(rowid),"^",22)
	.set:hospId="" hospId=$o(^CT("HOSP","0"))
	.set hospCode=$p(^CT("HOSP",hospId),"^",1)	
	.set insObj.CTDHosCode=hospCode
	.set insObj.CTDStatus="1"
	.set ParentDeptInfo=..GetFirstGradeDept(rowid)
	.set insObj.CTDRemarks=$p(ParentDeptInfo,"^",4)
	.set insObj.CTDUpdateUserCode="无"
	.set insObj.CTDCategoryCode=$p($g(^CTLOC(rowid)),"^",13)
	.set dateActiveFrom=$p($g(^CTLOC(rowid)),"^",24)
	.set:dateActiveFrom'="" insObj.CTDStartDate=$zdt(dateActiveFrom,3)
	.set dateActiveTo=$p($g(^CTLOC(rowid)),"^",25)
	.set:dateActiveTo'="" insObj.CTDEndDate=$zdt(dateActiveTo,3)
	.set insObj.CTDOfficePhone=$p($g(^CTLOC(rowid)),"^",40)
	.set insObj.CTDParentDeptCode=$p(ParentDeptInfo,"^",2)
	.set insObj.CTDParentDeptDesc=$p(ParentDeptInfo,"^",3)
	.set insObj.CTDParentDeptType=$p(ParentDeptInfo,"^",5)
	.set Phonetic=$p($g(^CTLOC(rowid)),"^",43)
	.set:Phonetic="" Phonetic="无"
	.set insObj.CTDPhonetic=Phonetic	;$p($g(^CTLOC(rowid)),"^",43)
	.set ParentDeptRowid=$p(ParentDeptInfo,"^",1)
	.set SuperDeptInfo=..GetSuperGradeDept(ParentDeptRowid)
	.set insObj.CTDSuperDeptCode=$p(SuperDeptInfo,"^",1)
	.set insObj.CTDSuperDeptDesc=$p(SuperDeptInfo,"^",2)
	.if ##class(%Dictionary.MethodDefinition).%ExistsId("ext.util.String||ToChineseSpell") d
	..set insObj.CTDSpell=##class(ext.util.String).ToChineseSpell(insObj.CTDDesc)
	.d List.CTDeptList.Insert(insObj)
	.set count=List.CTDeptList.Count()
	.if count>200 d
	..d List.XMLExportToString(.SS)
	..set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",SS,"/ListInfo/CTDeptList",.Jsonobj)
	..set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	..set JsonString=$tr(JsonString,$c(13),"")
	..set JsonString=$tr(JsonString,$c(10),"")
	..set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Dept",JsonString)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..d List.CTDeptList.Clear()
	..set count=0
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode'=0 d
	...s success=-1
	..else  d
	...s success=0
	
	
	if (count>0){
		d List.XMLExportToString(.SS)
		set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",SS,"/ListInfo/CTDeptList",.Jsonobj)
		set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
		set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Dept",JsonString)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode'=0 d
		.s success=-1
		else  d
		.set success=0
	}
	Quit success
	
MsgErr
	Quit "-1^"_$ze
}

/// 取顶级科室
/// add by lipan 2016-09-03
/// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTDept).GetSuperGradeDept(1)
ClassMethod GetSuperGradeDept(MajorDeptRowID As %String) As %String
{
	
	set Code="",Name=""
	if MajorDeptRowID="" {
		q ""
	}
	set SuperDeptRowid=$o(^DHCCTLocM(0,"Main",MajorDeptRowID,"")) 
	if SuperDeptRowid'=""{
		s Code=$p(^DHCCTLocM(SuperDeptRowid),"^",1) 
		s Name=$p(^DHCCTLocM(SuperDeptRowid),"^",2) 
	}
	
	q Code_"^"_Name
}

/// 取一级科室
/// add by lipan 2016-09-03
/// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTDept).GetFirstGradeDept(1)
ClassMethod GetFirstGradeDept(DeptRowID As %String) As %String
{
	
	set MajorRowid="",Rowid="",Code="",Name="",Profile="",Type=""
	f{
		s MajorRowid=$o(^DHCCTLoc(0,"Minor",DeptRowID,MajorRowid)) 
		q:MajorRowid=""
		s ChildSub=""
		f{
			s ChildSub=$o(^DHCCTLoc(0,"Minor",DeptRowID,MajorRowid,ChildSub)) 
			q:ChildSub=""
		
			s active=$p(^DHCCTLoc(MajorRowid,"MINOR",ChildSub),"^",2)
			if active=1{
				s Rowid=MajorRowid
				s Code=$p(^DHCCTLoc(MajorRowid),"^",1)
				s Name=$p(^DHCCTLoc(MajorRowid),"^",2)
				s Profile=$p(^DHCCTLoc(MajorRowid),"^",5)
				s Type=$p(^DHCCTLoc(MajorRowid),"^",6)
				q 
			}
		}
	}
	q Rowid_"^"_Code_"^"_Name_"^"_Profile_"^"_$g(Type)
}

ClassMethod GetFirstGradeDept1(DeptRowID As %String) As %String
{
	
	set MajorRowid="",Rowid="",Code="",Name="",Profile="",Type=""
	f{
		s MajorRowid=$o(^DHCCTLoc(MajorRowid)) 
		s MajorRowid=$o(^DHCCTLoc(MajorRowid,"Minor",DeptRowID,MajorRowid)) 
		q:MajorRowid=""
		s ChildSub=""
		f{
			s ChildSub=$o(^DHCCTLoc(MajorRowid,"Minor",DeptRowID,MajorRowid,ChildSub)) 
			q:ChildSub=""
		
			s active=$p(^DHCCTLoc(MajorRowid,"MINOR",ChildSub),"^",2)
			if active=1{
				s Rowid=MajorRowid
				s Code=$p(^DHCCTLoc(MajorRowid),"^",1)
				s Name=$p(^DHCCTLoc(MajorRowid),"^",2)
				s Profile=$p(^DHCCTLoc(MajorRowid),"^",5)
				s Type=$p(^DHCCTLoc(MajorRowid),"^",6)
				q 
			}
		}

	}
	q Rowid_"^"_Code_"^"_Name_"^"_Profile_"^"_$g(Type)
}

}
