Class EMRservice.Tools.DailyWorkTool Extends %RegisteredObject
{

/// d ##Class(EMRservice.Tools.DailyWorkTool).GetDocumentIndex("8")
ClassMethod GetDocumentIndex(TheECRecordID As %String)
{
	
	&sql(SELECT ID into :idxID FROM EMRinstance.DirectoryInformation WHERE ECRecordID=:TheECRecordID)
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="/tmp/DOCUMENT_Index_"_TheECRecordID_".txt"
	s obj = ##Class(EMRinstance.DirectoryInformation).%OpenId(idxID)
	d AStream.CopyFrom(obj.DirInfoData)
	s sc= AStream.SaveStream()
	w AStream.Filename,!
	w AStream.SizeGet(),!
	d AStream.%Close()
}

/// d ##Class(EMRservice.Tools.DailyWorkTool).PutDocumentIndex("25")
ClassMethod PutDocumentIndex(TheECRecordID As %String)
{
	
	&sql(SELECT ID into :idxID FROM EMRinstance.DirectoryInformation WHERE ECRecordID=:TheECRecordID)
	
	s obj = ##Class(EMRinstance.DirectoryInformation).%OpenId(idxID)
	
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="/tmp/DOCUMENT_Index_"_TheECRecordID_".txt"
	d obj.DirInfoData.CopyFrom(AStream)
	d obj.%Save()
}

/// w ##Class(EMRservice.Tools.DailyWorkTool).SaveDocument("4084||1")
ClassMethod SaveDocument(AInstanceID As %String)
{
 s saveinstanceobj=##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
 s userid=saveinstanceobj.CreateUser
 s title=saveinstanceobj.Title
 s titlecode=saveinstanceobj.TitleCode
 
 q:(userid="") -1
 s saveinstanceobj=""
 s AStream=##Class(%FileBinaryStream).%New()
 s AStream.Filename="/tmp/SAVE_DOCUMENT_"_AInstanceID_".xml"
 s IsCompressDocument=##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsCompressByInstanceID(AInstanceID)
 s status= ##Class(EMRservice.BL.BLInstanceData).SaveDoucment(AInstanceID,userid,AStream, title,titlecode,"",IsCompressDocument)

 q status
}

/// w ##Class(EMRservice.Tools.DailyWorkTool).GetDocument("1||1")
ClassMethod GetDocument(AInstanceID As %String) As %String
{
	s argOutData = ##class(%FileBinaryStream).%New() 
	s outMessage = ##class(%FileBinaryStream).%New()
	s instanceArry = ##class(%ListOfDataTypes).%New()
	d instanceArry.Insert(AInstanceID)
 	s status = ##Class(EMRservice.BL.BLInstanceData).LoadDocument(argOutData,instanceArry,outMessage)
 	
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="c:\emr\SAVE_DOCUMENT_"_$tr(AInstanceID,"||","--")_".xml"
	d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
	q status
}

/// w ##Class(EMRservice.Tools.Tool).AddTitle("58")
ClassMethod AddTitle(argCode As %String)
{
	//b "s"
	s obj=##Class(EMRmeta.Titles).%New()
	s obj.Alias="RSJL"
	s obj.Code=argCode
	s obj.Description="入室记录"
	D obj.%Save()
	
	s objTitleConfig=##Class(EMRmeta.TitleConfig).%New()
	s objTitleConfig.AutoLoad="True"
	s objTitleConfig.CategoryID="55"
	s objTitleConfig.GroupID="1"
	s objTitleConfig.PageBreak="False"
	s objTitleConfig.Sequence="53"
	s objTitleConfig.TitleCode=argCode
	d objTitleConfig.%Save()
	s rowid=objTitleConfig.%Id()
	
	s objColConfig=##Class(EMRmeta.TitleColConfig).%New()
	s objColConfig.Type="Title"
	s objColConfig.ReadOnly="False"
	s objColConfig.Format=" "
	s objColConfig.LineBreak="False"
	s objColConfig.Align="Left"
	s objColConfig.Visible="False"
	s objColConfig.SeqNum="2"
	s objColConfig.FontStyle="font-weight:bold;font-size:12pt"
	s objColConfig.TitleConfig=##Class(EMRmeta.TitleConfig).%OpenId(rowid)
	d objColConfig.%Save()
	
	s objColConfig=##Class(EMRmeta.TitleColConfig).%New()
	s objColConfig.Type="DateTime"
	s objColConfig.ReadOnly="False"
	s objColConfig.Format="yyyy-MM-dd HH:mm"
	s objColConfig.LineBreak="False"
	s objColConfig.Align="Left"
	s objColConfig.Visible="True"
	s objColConfig.SeqNum="1"
	s objColConfig.FontStyle="font-weight:bold;font-size:12pt"
	s objColConfig.TitleConfig=##Class(EMRmeta.TitleConfig).%OpenId(rowid)
	d objColConfig.%Save()

	quit
}

/// w ##Class(EMRservice.Tools.Tool).CheckUnSave()
ClassMethod CheckUnSave() As %String
{
	s problemID = ""
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRI.DirectoryInformationD(rowId))
		q:(rowId = "")
		s objDirInfo = ##Class(EMRinstance.DirectoryInformation).%OpenId(rowId)
		continue:(objDirInfo = "")
		s reader = ##class(%XML.Reader).%New()	
		s stream = ##Class(%GlobalBinaryStream).%New()
		d stream.CopyFrom(objDirInfo.DirInfoData)
		s sc = reader.OpenStream(stream)
		continue:($$$ISERR(sc))
		d reader.Correlate("NInstanceIndex","EMRservice.entity.ENInstanceIndex")
		While reader.Next(.obj,.sc)
		{
			s InstanceIndexCount = obj.InstanceIndex.Count()
			for j=1:1:InstanceIndexCount
			{
				s title = obj.InstanceIndex.GetAt(j).Title
				s title = $ZSTRIP(title,"*C")
				s:((title = "")||(title = " ")) problemID = problemID_","_rowId
			} 
		}
	}
	q problemID
}

/// Desc:      打散数据修正 EMRinstance.ICompositeSimple
/// Creator:   lfb
/// Createdate:201401111
/// ID	EpisodeID	InstanceDataID	SimpleItemCode	DataRef	DataValue	ValueCode
/// 1215	7966052	43||2	D001		2014-10-15 09:15	
/// d ##Class(EMRservice.Tools.DailyWorkTool).ModifyCompositeSimpleData("/tmp/43--2.txt")
ClassMethod ModifyCompositeSimpleData(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0,diffidcount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s spID=$p(sRec, $c(9), 1)
		s spInstanceDataID=$p(sRec, $c(9), 3)
		s spSimpleItemCode=$p(sRec, $c(9), 4)
		s spDataRef=$p(sRec, $c(9), 5)
		s spDataValue=$p(sRec, $c(9), 6)
		s spValueCode=$p(sRec, $c(9), 7)
 
		// ^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," 43||2"," V001"," V002"," D001",1215) = "" 
		s idxID=""
		s idxID=$o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_spInstanceDataID," V001"," V002"," "_spSimpleItemCode,idxID))
		s obj = ##Class(EMRinstance.ICompositeSimple).%OpenId(idxID)

		//DataFrom	DataTo	FuncName	RoleID
	    s obj.DataRef=spDataRef
	    s obj.DataValue=spDataValue
	    s obj.ValueCode=spValueCode


		s isOK = obj.%Save()
	    
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
		if (idxID'=spID) {s diffidcount=+$g(diffidcount)+1}
	}
	w "总数: "_totCount_" 成功:"_okCount_" 失败:"_failCount_" 测试库与正式ID不同个数:"_diffidcount
	quit
}

/// EMRservice.Tools.ICompositeSimpleData
/// InsertToolsCompositeSimpleData
/// InsertToolsCompositeSimpleData141||1
/// d ##Class(EMRservice.Tools.DailyWorkTool).InsertToolsCompositeSimpleData("/tmp/141--1.txt")
ClassMethod InsertToolsCompositeSimpleData(argFile As %String)
{
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0,diffidcount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s spEpisodeID=$p(sRec, $c(9), 2)
		s spInstanceDataID=$p(sRec, $c(9), 3)
		s spSimpleItemCode=$p(sRec, $c(9), 4)
		s spDataRef=$p(sRec, $c(9), 5)
		s spDataValue=$p(sRec, $c(9), 6)
		s spValueCode=$p(sRec, $c(9), 7)
 		s obj = ##Class(EMRservice.Tools.ICompositeSimpleData).%New()
		
		s obj.SectionCode="V001"
		s obj.CompositeCode="V002"
		s obj.InstanceDataID=spInstanceDataID
		s obj.SimpleItemCode=spSimpleItemCode
	    s obj.DataRef=spDataRef
	    s obj.DataValue=spDataValue
	    s obj.ValueCode=spValueCode
	    s obj.EpisodeID=spEpisodeID


		s isOK = obj.%Save()
	    
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"总数: "_totCount_" 成功:"_okCount_" 失败:"_failCount
	quit
}

/// 集中导入问题病历打散数据
/// d ##Class(EMRservice.Tools.DailyWorkTool).updateDataToToolsCmpSimpleData()
ClassMethod updateDataToToolsCmpSimpleData()
{
	//s InstanceIDs="43||2^71||2^150||1^168||1^181||1^193||2^300||1^320||1^322||2^219||3^96||2^375||1^377||3^379||2^385||1^137||3^479||2^487||1^517||4^530||1^112||5^583||1^584||1^723||1^733||1^736||1^742||1^758||2^834||1^865||1^485||3^884||2^203||12^1002||1^145||3^1021||1^1038||2^545||2^176||3^1210||2^1246||1^1272||1^1325||1^1329||2^505||4^1354||1^1360||2^1397||1^237||4^1480||1^1495||1^871||9^669||5^599||6^454||5^132||8^163||5^878||4^1547||2^1568||1^880||4^817||4^1641||1^510||3^967||2^1076||4^1357||2^1724||1^1769||2^1812||2^1812||3^1212||2^1227||2^1528||3^1938||1^1967||1^1969||1^600||4^1985||1^1988||1^1899||2^1996||1^2015||1^570||4^1629||3^2114||1^2128||3^2137||1"
	for i=1:1:$l(InstanceIDs,"^"){
			s InstanceID=$p(InstanceIDs,"^",i)
			s pathstr=""
			s pathstr=$tr(InstanceID,"|","-")
			s pathstr="/tmp/icsiptxt/"_pathstr_".txt"
			d ..ModifyCompositeSimpleData(pathstr)

		}	
	q 1
}

/// 集中导入需要对照的病历数据
/// d ##Class(EMRservice.Tools.DailyWorkTool).InsertDataToToolsCmpSimpleData()
ClassMethod InsertDataToToolsCmpSimpleData()
{
	//s InstanceIDs="141||1^160||1^227||1^372||1^378||1^399||1^431||1^484||1^509||1^547||1^580||1^610||1^453||3^729||1^730||1^751||1^755||1^762||1^844||1^846||1^884||1^337||2^934||1^934||2^934||3^934||4^934||5^941||1^957||1^844||2^846||2^932||2^203||10^1010||1^753||2^142||2^1062||1^1070||1^497||4^1120||1^101||3^1146||1^1132||2^834||2^738||7^1277||1^340||4^1366||1^1330||1^1376||2^1385||1^1416||1^1423||1^1450||2^1487||1^979||2^1523||1^254||7^1539||1^1543||1^1550||1^1565||1^1573||1^1099||2^186||4^1630||1^966||2^1677||1^1752||1^1756||1"
	for i=1:1:$l(InstanceIDs,"^"){
			s InstanceID=$p(InstanceIDs,"^",i)
			s pathstr=""
			s pathstr=$tr(InstanceID,"|","-")
			s pathstr="/tmp/icsiptxt/"_pathstr_".txt"
			d ..InsertToolsCompositeSimpleData(pathstr)

		}	
	q 1
}

/// 通过AdmID 获取 病人ID
/// d ##Class(EMRservice.Tools.DailyWorkTool).GetPatIDbyAdmID()
ClassMethod GetPatIDbyAdmID(ArgAdmid As %String = "") As %String
{
	q:(ArgAdmid="") "pig come on!!"
	s retid=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(ArgAdmid)
	s patid=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(retid)
	q patid
}

/// d ##Class(EMRservice.Tools.DailyWorkTool).GetJCAPatinfo("2014-10-27","2015-01-20")
ClassMethod GetJCAPatinfo(strDate As %String, endDate As %String)
{
	s strDate=$zdh(strDate,3)
	s endDate=$zdh(endDate,3)
	s HotCount=0,TotalCount=0
	for tmpDate=strDate:1:endDate {
		s tmpadmid=""
		for {
			s tmpadmid=$o(^PAADMi("DischDate",tmpDate,tmpadmid))
			q:tmpadmid=""
			s tmpstr=$g(^PAADM(tmpadmid))
			s pattype=$p(tmpstr,"^",2)
			continue:pattype'="I"
			s MainDiagDesc="",arr=""
			s arr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(tmpadmid,"HDSB05.10")
			continue:arr=""
			s MainDiagDesc=arr.GetAt("HDSB05.10.056")
			//如果不是结肠 癌 肿瘤 相关的 继续循环下一个患者
			
			continue:'(MainDiagDesc["结肠")
			continue:'((MainDiagDesc["肿瘤")||(MainDiagDesc["癌"))
			continue:(MainDiagDesc["结肠镜")
			//continue:((MainDiagDesc["腺癌")||(MainDiagDesc["腺瘤"))
			
			//科室、病区、姓名、病人ID、性别、出院时间、主要诊断、主诉、联系人、联系方式、住院天数
			
			
			
			s Papmi = $p(tmpstr,"^",1)
			s PatientName = $p($g(^PAPER(+Papmi,"ALL")),"^",1)			
			s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
			s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
			s DischDate = $p(tmpstr,"^",17)
			s:(DischDate '= "") DischDate = $zd(DischDate,3)
			
			
			s DisLocID = $p(tmpstr,"^",4)
			s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
			s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
			
			
			s DisWardID = $p(tmpstr,"^",70)
			s WardDesc = $p($g(^PAWARD(+DisWardID)),"^",2)			
			s WLocID = $p($g(^PAWARD(+DisWardID)),"^",5)
			s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
			s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
			
			
			//联系人、电话
			s ralationName=arr.GetAt("HDSB05.10.041")
			s ralationPhoneNum=arr.GetAt("HDSB05.10.044")
			
			// 主诉
			s arrRYJL=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(tmpadmid,"HDSD00.13.01")
			s zhusu=arrRYJL.GetAt("HDSD00.13.114")
			s HotFlag=""
			s:(zhusu["热") HotFlag="Yes"
			
			w !,LocDesc_"|"_WardDesc_"|"_PatientName_"|"_RegNo_"|"_Gender_"|"_MainDiagDesc_"|"_ralationName_"|"_ralationPhoneNum_"|"_zhusu_"|"_HotFlag
			
			s TotalCount=+$g(TotalCount)+1
			s:(HotFlag="Y") HotCount=+$g(HotCount)+1
		}
	}
	
	w !,"总数："_TotalCount_",主诉中包含发热患者总数:"_HotCount
}

/// d ##Class(EMRservice.Tools.DailyWorkTool).GetWEYEPatInfo("2015-03-01","2015-04-15")
ClassMethod GetWEYEPatInfo(AStartDate As %String, AEndDate As %String) As %String
{
  s startday=$zdh(AStartDate,3)
  s endday=$zdh(AEndDate,3)
  s iday="",count=0,InstanceDataID="",ecrecordid=""
  w !,"就诊指针|病案号|患者姓名|性别|年龄|身份证号|联系电话|地址|相关疾病|相关疾病其他说明|手术眼|裸眼OD（右眼）|裸眼OS（左眼）|矫正OD（右眼）|矫正OS（左眼）|OD（右眼）|OS（左眼）|白内障分类|白内障分类其他说明|瞳孔|瞳孔其他说明|手术日期|手术医生|手术方式|手术方式其他说明|植入人工晶状体|术中并发症|术中并发症其他说明|手术经费来源|手术经费来源其他说明|3日术后裸眼视力|3日术后矫正视力|3日术后并发症|3日术后并发症其他说明|3月术后裸眼视力|3月术后矫正视力|3月术后并发症|3月术后并发症其他说明|需要说明的其他情况|上报人（创建者）"
 
  for {
	 s ecrecordid=$o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecrecordid))

	 q:ecrecordid=""

	 s sub="",InstanceDataID=""
	 for {
		 	s sub=$o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecrecordid," 40"," SAVE",sub))
		 	q:sub=""
		 	s InstanceDataID=ecrecordid_"||"_sub
		 	s objint=##class(EMRinstance.InstanceData).%OpenId(InstanceDataID)
		 	s episodeID=objint.EpisodeID
		 	s crtDate=objint.CreateDate
		 	s (crtuserid,ctuserName)=""
		 	s crtuserid=objint.CreateUser
		 	s ctuserName=$p($g(^SSU("SSUSR",crtuserid)),"^",2)
		 	
		 	continue:('$$checkcrtDate(crtDate,startday,endday))
		 	s flag=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(episodeID,InstanceDataID,"手术眼.O006^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:O006#VTYPE:C")
	   		
	   		continue:((flag'=1)&&(flag'=2)&&(flag'=0))
	    	s count=+$g(count)+1
		 	s recordvalue=..GetWEYERecordValue(episodeID,InstanceDataID,ctuserName)
	    	w !,recordvalue
		 }
	  
	  
 }
  
  w !,count
  q "success"
  
checkcrtDate(date,sdate,edate)
	q (date>=sdate)&&(date<=edate)
}

/// w ##class(EMRservice.Tools.Tool).GetTestmm()
ClassMethod GetTestmm()
{
	s epi=8998519
	s InstanceDataID=""
	//&sql(SELECT ID into :InstanceDataID FROM EMRinstance.Instancedata WHERE TemplateID=40 AND EpisodeID=:epi AND Status="Save")	
	&sql(SELECT ID into :InstanceDataID FROM EMRinstance.Instancedata WHERE TemplateID=40 AND Status="Save")	
	
	q InstanceDataID
}

ClassMethod GetWEYERecordValue(adm As %String, Intid As %String, CtrName As %String) As %String
{
	
  //病案号
  
  s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(adm,"")
 	
  //s value1=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,".V001^#TYPE:ISectionDesc#TID:40#SCODE:V001#VTYPE:V")
  //s value2=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,".V002^#TYPE:ICompositeDesc#TID:40#SCODE:V001|CCODE:V002#VTYPE:V")
  s value3=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"姓名.L002^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:L002#VTYPE:V")
  s value4=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"年龄.L003^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:L003#VTYPE:V")
  s value5=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"身份证号.L004^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:L004#VTYPE:V")
  s value6=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"联系电话.L005^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:L005#VTYPE:V")
  s value7=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"手术眼.O006^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:O006#VTYPE:C")
  s value8=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"手术日期.D001^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:D001#VTYPE:V")
  //根据手术日期返回值
  //q:($p(($p(value8,"年",2)),"月",1)="04") ""
  s value9=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"手术医生.I001^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:I001#VTYPE:V")
  s value10=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"是否植入人工晶体.O015^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:O015#VTYPE:V")
  s value11=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3日术后裸眼视力.O033^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:O033#VTYPE:V")
  s value12=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3日术后矫正视力.O034^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:O034#VTYPE:V")
  s value13=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3月术后裸眼视力.O046^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:O046#VTYPE:V")
  s value14=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3月术后矫正视力.O047^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:O047#VTYPE:V")
  s value15=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"需要说明的其他情况.L017^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:L017#VTYPE:V")
  s value16=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"裸眼视力_右眼.O058^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:O058#VTYPE:V")
  s value17=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"裸眼视力_左眼.O059^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:O059#VTYPE:V")
  s value18=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"矫正视力_右眼.O060^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:O060#VTYPE:V")
  s value19=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"矫正视力_左眼.O061^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:O061#VTYPE:V")
  s value20=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"右眼眼压.N003^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:N003#VTYPE:V")
  s value21=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"左眼眼压.N004^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:N004#VTYPE:V")
  s value22=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"白内障分类.O062^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:O062#VTYPE:V")
  s value23=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"瞳孔.O063^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:O063#VTYPE:V")
  s value24=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"白内障分类_备注.L019^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:L019#VTYPE:V")
  s value25=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"瞳孔_备注.L020^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:L020#VTYPE:V")
  s value26=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"手术方式.O064^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:O064#VTYPE:V")
  s value27=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"手术方式_备注.L021^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:L021#VTYPE:V")
  s value28=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"术中并发症备注.L022^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:L022#VTYPE:V")
  s value29=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"手术经费来源备注.L023^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:L023#VTYPE:V")
  s value30=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3日并发症_症备注.L024^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:L024#VTYPE:V")
  s value31=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3月并发症_备注.L025^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:L025#VTYPE:V")
  s value32=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"无术前疾病.M005^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M005#VTYPE:V")
  s value33=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"术前_糖尿病.M008^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M008#VTYPE:V")
  s value34=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"术前_高血压.M009^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M009#VTYPE:V")
  s value35=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"术前其他疾病.M010^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M010#VTYPE:V")
  s value36=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"其他术前疾病.L027^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:L027#VTYPE:V")
  s value37=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"其他术中并发症.M019^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M019#VTYPE:V")
  s value38=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"晶状体后囊膜破裂或悬韧带断裂.M020^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M020#VTYPE:V")
  s value39=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"虹膜根部离断.M021^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M021#VTYPE:V")
  s value40=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"玻璃体丢失/前部玻璃体切除.M022^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M022#VTYPE:V")
  s value41=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"脉络膜上腔出血.M024^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M024#VTYPE:V")
  s value42=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"球后出血.M025^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M025#VTYPE:V")
  s value43=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"青光眼.M026^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M026#VTYPE:V")
  s value44=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"葡萄膜炎.M027^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M027#VTYPE:V")
  s value45=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"晶状体核沉入玻璃体.M028^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M028#VTYPE:V")
  s value46=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"手术经费_其它项目.M029^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M029#VTYPE:V")
  s value47=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"手术经费_医保.M030^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M030#VTYPE:V")
  s value48=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"百万贫困白内障患者复明工程.M031^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M031#VTYPE:V")
  s value49=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"中西部地区儿童先天性疾病和贫困白内障患者复明救治项目.M032^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M032#VTYPE:V")
  s value50=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"健康快车.M033^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M033#VTYPE:V")
  s value51=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"亮睛工程.M034^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M034#VTYPE:V")
  s value52=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"自费.M035^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M035#VTYPE:V")
  s value53=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"手术车.M036^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M036#VTYPE:V")
  s value54=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3日并发症_其他.M037^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M037#VTYPE:V")
  s value55=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3日并发症_切口渗漏或破裂.M038^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M038#VTYPE:V")
  s value56=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3日并发症_眼内炎.M039^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M039#VTYPE:V")
  s value57=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3日并发症_人工晶体偏位.M040^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M040#VTYPE:V")
  s value58=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3日并发症_角膜水肿.M041^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M041#VTYPE:V")
  s value59=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3日并发症_前房出血.M042^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M042#VTYPE:V")
  s value60=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3日并发症_视网膜脱离.M043^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M043#VTYPE:V")
  s value61=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3日并发症_虹膜损伤.M044^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M044#VTYPE:V")
  s value62=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3日并发症_虹膜炎.M045^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M045#VTYPE:V")
  s value63=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3日并发症_玻璃体积血.M046^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M046#VTYPE:V")
  s value64=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3日并发症_脉络膜上腔出血.M047^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M047#VTYPE:V")
  s value65=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3月并发症_其他.M048^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M048#VTYPE:V")
  s value66=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3月并发症_晶状体后囊膜浑浊.M049^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M049#VTYPE:V")
  s value67=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3月并发症_大泡性角膜病变.M050^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M050#VTYPE:V")
  s value68=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3月并发症_黄斑囊样水肿.M051^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M051#VTYPE:V")
  s value69=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3月并发症_视网膜脱离.M052^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M052#VTYPE:V")
  s value70=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3月并发症_眼内炎.M053^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M053#VTYPE:V")
  s value71=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3月并发症_人工晶状体偏位.M054^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M054#VTYPE:V")
  s value72=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3月并发症_虹膜睫状体炎.M055^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M055#VTYPE:V")
  s value73=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3月并发症_继发性闭角型青光眼.M056^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M056#VTYPE:V")
  s value74=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"3月并发症_继发性开角型青光眼.M057^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:M057#VTYPE:V")
  s value75=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"现住址省份.I002^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:I002#VTYPE:V")
  s value76=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"现住址城市.I003^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:I003#VTYPE:V")
  s value77=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"现住址区县.I004^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:I004#VTYPE:V")
  s value78=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"现住址街号.I005^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:I005#VTYPE:V")
  s value79=##Class(EMRservice.BL.BLScatterData).GetTVScatterData(adm,Intid,"性别.I006^#TYPE:ICompositeSample#TID:40#SCODE:V001|CCODE:V002|CSCODE:I006#VTYPE:V")
  
  //术前相关疾病多选
  s newvalue32=$s(value32="false":0,value32="true":1,1:0)
  s newvalue33=$s(value33="false":0,value33="true":2,1:0)
  s newvalue34=$s(value34="false":0,value34="true":3,1:0)
  s newvalue35=$s(value35="false":0,value35="true":4,1:0)
  s beforeopervalue=newvalue32_newvalue33_newvalue34_newvalue35
  
  //术中并发症多选
  s newvalue37=$s(value37="false":0,value37="true":1,1:0)
  s newvalue38=$s(value38="false":0,value38="true":2,1:0)
  s newvalue39=$s(value39="false":0,value39="true":3,1:0)
  s newvalue40=$s(value40="false":0,value40="true":4,1:0)
  s newvalue45=$s(value45="false":0,value45="true":5,1:0)
  s newvalue41=$s(value41="false":0,value41="true":6,1:0)
  s newvalue42=$s(value42="false":0,value42="true":7,1:0)
  s newvalue43=$s(value43="false":0,value43="true":8,1:0)
  s newvalue44=$s(value44="false":0,value44="true":9,1:0)
  s underopervalue=newvalue37_newvalue38_newvalue39_newvalue40_newvalue45_newvalue41_newvalue42_newvalue43_newvalue44
  
  
  //经费来源
  
  s newvalue46=$s(value46="false":0,value46="true":1,1:0)
  s newvalue47=$s(value47="false":0,value47="true":2,1:0)
  s newvalue48=$s(value48="false":0,value48="true":3,1:0)
  s newvalue49=$s(value49="false":0,value49="true":4,1:0)
  s newvalue50=$s(value50="false":0,value50="true":5,1:0)
  s newvalue51=$s(value51="false":0,value51="true":6,1:0)
  s newvalue52=$s(value52="false":0,value52="true":7,1:0)
  s newvalue53=$s(value53="false":0,value53="true":8,1:0)
  s paysource=newvalue46_newvalue47_newvalue48_newvalue49_newvalue50_newvalue51_newvalue52_newvalue53
  
  //3日术后并发症
  
  s newvalue54=$s(value54="false":0,value54="true":1,1:0)
  s newvalue55=$s(value55="false":0,value55="true":2,1:0)
  s newvalue56=$s(value56="false":0,value56="true":3,1:0)
  s newvalue57=$s(value57="false":0,value57="true":4,1:0)
  s newvalue58=$s(value58="false":0,value58="true":5,1:0)
  s newvalue59=$s(value59="false":0,value59="true":6,1:0)
  s newvalue60=$s(value60="false":0,value60="true":7,1:0)
  s newvalue61=$s(value61="false":0,value61="true":8,1:0)
  s newvalue62=$s(value62="false":0,value62="true":9,1:0)
  s newvalue63=$s(value63="false":0,value63="true":0,1:0)
  s newvalue64=$s(value64="false":0,value64="true":0,1:0)
  
  s tdayopervalue=newvalue54_newvalue55_newvalue56_newvalue57_newvalue58_newvalue59_newvalue60_newvalue61_newvalue62_newvalue63_newvalue64
  //3月术后并发症
  
  s newvalue65=$s(value65="false":0,value65="true":1,1:0)
  s newvalue66=$s(value66="false":0,value66="true":2,1:0)
  s newvalue67=$s(value67="false":0,value67="true":3,1:0)
  s newvalue68=$s(value68="false":0,value68="true":4,1:0)
  s newvalue69=$s(value69="false":0,value69="true":5,1:0)
  s newvalue70=$s(value70="false":0,value70="true":6,1:0)
  s newvalue71=$s(value71="false":0,value71="true":7,1:0)
  s newvalue72=$s(value72="false":0,value72="true":8,1:0)
  s newvalue73=$s(value73="false":0,value73="true":9,1:0)
  s newvalue74=$s(value74="false":0,value74="true":0,1:0)
  
  
  s tmonthopervalue=newvalue65_newvalue66_newvalue67_newvalue68_newvalue69_newvalue70_newvalue71_newvalue72_newvalue73_newvalue74
  
  //地址
  s address=value75_value76_value77_value78
  //q value3_"|"_value4_"|"_value5_"|"_value6_"|"_value7_"|"_value8_"|"_value9_"|"_value10_"|"_value11_"|"_value12_"|"_value13_"|"_value14_"|"_value15_"|"_value16_"|"_value17_"|"_value18_"|"_value19_"|"_value20_"|"_value21_"|"_value22_"|"_value23_"|"_value24_"|"_value25_"|"_value26_"|"_value27_"|"_value28_"|"_value29_"|"_value30_"|"_value31_"|"_value32_"|"_value33_"|"_value34_"|"_value35_"|"_value36_"|"_value37_"|"_value38_"|"_value39_"|"_value40_"|"_value41_"|"_value42_"|"_value43_"|"_value44_"|"_value45_"|"_value46_"|"_value47_"|"_value48_"|"_value49_"|"_value50_"|"_value51_"|"_value52_"|"_value53_"|"_value54_"|"_value55_"|"_value56_"|"_value57_"|"_value58_"|"_value59_"|"_value60_"|"_value61_"|"_value62_"|"_value63_"|"_value64_"|"_value65_"|"_value66_"|"_value67_"|"_value68_"|"_value69_"|"_value70_"|"_value71_"|"_value72_"|"_value73_"|"_value74_"|"_value75_"|"_value76_"|"_value77_"|"_value78_"|"_value79
  //w "就诊指针|病案号|患者姓名|性别|年龄|身份证号|联系电话|地址|相关疾病|相关疾病其他说明|手术眼|裸眼OD（右眼）|裸眼OS（左眼）|矫正OD（右眼）|矫正OS（左眼）|OD（右眼）|OS（左眼）|白内障分类|白内障分类其他说明|瞳孔|瞳孔其他说明|手术日期|手术医生|手术方式|手术方式其他说明|植入人工晶状体|术中并发症|术中并发症其他说明|手术经费来源|手术经费来源其他说明|3日术后裸眼视力|3日术后矫正视力|3日术后并发症|3日术后并发症其他说明|3月术后裸眼视力|3月术后矫正视力|3月术后并发症|3月术后并发症其他说明|需要说明的其他情况"
  s ret=adm_"|"_IPRecordNo_"|"_value3_"|"_value79_"|"_value4_"|"_value5_"|"_value6_"|"_address_"|"_beforeopervalue_"|"_value36_"|"_value7_"|"_value16_"|"_value17_"|"_value18_"|"_value19_"|"_value20_"|"_value21_"|"_value22_"|"_value24_"|"_value23_"|"_value25_"|"_value8_"|"_value9_"|"_value26_"|"_value27_"|"_value10_"|"_underopervalue_"|"_value28_"|"_paysource_"|"_value29_"|"_value11_"|"_value12_"|"_tdayopervalue_"|"_value30_"|"_value13_"|"_value14_"|"_tmonthopervalue_"|"_value31_"|"_value15_"|"_CtrName
  q ret
}

/// w ##class(EMRservice.Tools.DailyWorkTool).GetRecordSignDT(7966261,"21||1")
/// w ##class(EMRservice.Tools.DailyWorkTool).GetRecordSignDT(admid,instandedataid)
ClassMethod GetRecordSignDT(aepisodeid As %String, ainstanceid As %String = "") As %String
{
	s ret=""
	q:(ainstanceid="") ret
	
	s objintdat=##class(EMRinstance.InstanceData).%OpenId(ainstanceid)
	s tmpdate=objintdat.HappenDate
	s tmptime=objintdat.HappenTime
	s ret=$zd(tmpdate,3)_" "_$zt(tmptime,2)
	
	
	
	s ecrecordid=$p(ainstanceid,"||",1)
	s num=$p(ainstanceid,"||",2)
	s recordobj=##class(EMRinstance.ECRecord).%OpenId(ecrecordid)
	s emrdocid=recordobj.RealChartItemID
	s emrlogid=""
	s emrlogid=$o(^DHCEMRI.EMRLogsI("IdxMain"," "_aepisodeid," "_emrdocid,num,emrlogid))
	q:(emrlogid="") ret


	s retdate="",rettime=""
	s retdate=$o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",emrlogid," RESIDENTCHECK",retdate))
	q:(retdate="") ret

	s rettime=$o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",emrlogid," RESIDENTCHECK",retdate,rettime))
	q:(rettime="") ret

	
	s ret=$zd(retdate,3)_" "_$zt(rettime,2)
	
	q ret
}

/// 根据可重复模板标题取InstanceID
/// d ##class(EMRservice.Tools.DailyWorkTool).GetInsIDListByTitle("7966811","日常病程记录")
ClassMethod GetInsIDListByTitle(AEpisodeID As %String = "", ATitle As %String = "")
{
	Quit:((AEpisodeID="")||(ATitle="")) ""
	s instancedataid="",ret=""
	&sql(select ID into :instancedataid from EMRInstance.InstanceData where EpisodeID=:AEpisodeID and Title=:ATitle and Status="Save")
	q:(instancedataid="")
	s recordid=$p(instancedataid,"||",1)
	s subnum=$p(instancedataid,"||",2)
	s subcount=0
	&sql(select InstanceCount into:subcount from EMRInstance.ECRecord where ID=:recordid)
	s intobj=""
	for i=subnum:1:subcount{
		
			s intobj=##class(EMRinstance.InstanceData).%OpenId(recordid_"||"_i)
			continue:(intobj="")
			s intstatus=intobj.Status
			continue:(intstatus'="Save")
			
			s inttitle=intobj.Title
			continue:(inttitle'=ATitle)
			s ret=ret_"^"_recordid_"||"_i
		
		}
	s ret=$e(ret,2,*)
	
	Quit ret
}

/// 根据可重复模板标题取InstanceID
/// d ##class(EMRservice.Tools.DailyWorkTool).GetInsIDListByGroupItemID("7966811",)
ClassMethod GetInsIDListByGroupItemID(AEpisodeID As %String = "", AGroupItemID As %String = "")
{
	Quit:((AEpisodeID="")||(AGroupItemID="")) ""
	s instancedataid="",ret=""
	&sql(select ID into :instancedataid from EMRInstance.InstanceData where EpisodeID=:AEpisodeID and GroupItemID=:AGroupItemID and Status="Save")
	q:(instancedataid="")
	s recordid=$p(instancedataid,"||",1)
	s subnum=$p(instancedataid,"||",2)
	s subcount=0
	&sql(select InstanceCount into:subcount from EMRInstance.ECRecord where ID=:recordid)
	s intobj=""
	for i=subnum:1:subcount{
		
			s intobj=##class(EMRinstance.InstanceData).%OpenId(recordid_"||"_i)
			continue:(intobj="")
			s intstatus=intobj.Status
			continue:(intstatus'="Save")
			
			s ret=ret_"^"_recordid_"||"_i
		
		}
	s ret=$e(ret,2,*)
	
	Quit ret
}

/// Desc：	入院科室【返回: RowId^Code^Desc】
/// Table：	
/// OutPut:	RowId^Code^Desc
/// Others: not different from hospitals
/// w ##class(EMRservice.Tools.DailyWorkTool).AdmDept(10381042)
ClassMethod AdmDept(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s TRANSChildsub="",locDR="",tmplocDR="",bed="",admdept="",DeptDesc="",DeptCode=""
	
	// 遍历转科记录，取入院科室
	f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
	.s tmplocDR=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",6)
	.if tmplocDR'="" {s locDR=tmplocDR}
		
	if locDR'="" 
	{	
		s DeptCode=$p($g(^CTLOC(locDR)),"^",1)
		s DeptDesc=$p($g(^CTLOC(locDR)),"^",2)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s admdept=locDR_"^"_DeptCode_"^"_DeptDesc		
	}
	if (locDR="")&&($p(^PAADM(argAdmId),"^",2)="E")
	{
		s lcoID=$p(^PAADM(argAdmId),"^",4)
		s DeptCode=$p($g(^CTLOC(lcoID)),"^",1)
		s DeptDesc=$p($g(^CTLOC(lcoID)),"^",2)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s admdept=lcoID_"^"_DeptCode_"^"_DeptDesc
		
	}
	q admdept
}

/// 创建生成队列
/// w ##class(EMRservice.Tools.DailyWorkTool).GetPatientDocumentNotUpLoad()
ClassMethod GetPatientDocumentNotUpLoad() As %String
{
	s admid=0,count=0
	for {
			s admid=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",admid))
			q:admid=""
			s count=count+1
			s ecid=""
			s ecid=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",admid," 51",ecid))
			continue:ecid=""
			
			continue:($d(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecid," SAVE"))'=10)
			
			s Status="N"
			s admidR=$e(admid,2,*)
			s:($d(^DHCEMRI.FPageInterfaceLogI("IdxStatusEpisodeID"," 0"," "_admidR))=10) Status="Y"
			continue:($d(^DHCEMRI.FPageUploadQueueI("IdxEpisodeIDStatus"," "_admidR))=10)
			
			d ..PutPatInUpLoadQueue(admidR,ecid,Status)	
		}
	q count
}

/// 创建生成队列
/// d ##class(EMRservice.Tools.DailyWorkTool).PutPatInUpLoadQueue()
ClassMethod PutPatInUpLoadQueue(AEpisodeID As %String, AECRecordID As %String, AStatus As %String)
{
	s objqueue=""
	s objqueue=##class(EMRinstance.FirstPage.UploadQueueInfo).%New()
	s objqueue.EpisodeID=AEpisodeID
	s objqueue.TheECRecord=AECRecordID
	s objqueue.UpLoadDateTime=$zd(+$H,3)_" "_$zt($p($h,"^",1),1)
	s objqueue.UpLoadStatus=AStatus
	
	d objqueue.%Save()
	d objqueue.%Close()
}

/// 生成数据
/// w ##class(EMRservice.Tools.DailyWorkTool).UpLoadDateFromQueue(1,100)
ClassMethod UpLoadDateFromQueue(FromID As %String, EndID As %String) As %String
{
	s secccount=0,falsecount=0,total=0
	s total=EndID-FromID+1
	for id=FromID:1:EndID
	{
		s (tmpobj,tmpEpisodeID,msg)=""
		s tmpobj=##class(EMRinstance.FirstPage.UploadQueueInfo).%OpenId(id)
		continue:(tmpobj="")	
		//continue:(tmpobj.UpLoadStatus="Y")
		
		s tmpEpisodeID=tmpobj.EpisodeID
		
		s msg=##class(DHCENS.Docotor.BS.WebDoctorService).WriteAdmFirstPage(tmpEpisodeID)
		d ##class(EMRservice.FirstPage.BOInterfaceLog).SaveLog(msg,tmpEpisodeID)
		s:(msg="0^成功") tmpobj.UpLoadStatus="Y"
		s:(msg="0^成功") secccount=$g(secccount)+1
		s:(msg'="0^成功") falsecount=$g(falsecount)+1
		d tmpobj.%Save()		
		d tmpobj.%Close()
		
	}
	q "总计"_total_"，成功："_secccount_"，失败："_falsecount
}

/// D ##CLASS(EMRservice.Tools.DailyWorkTool).FindTransactionList(9480010)
ClassMethod FindTransactionList(EpisodeID As %String = "", TransType As %String = "") As %String
{

    i EpisodeID="" Quit
    s PAADMPAPMIDR=$p(^PAADM(EpisodeID),"^",1)
    s sub=0 f  s sub = $O(^PAADM(EpisodeID,"TRANS",sub)) q:sub=""  d
    .s (SSUSRName,WARDDesc,ROOMDesc,ROOMTDesc,BEDCode,TRANSParRef,TRANSEndDate,TRANSEndTime,TRANSStartDate,TRANSStartTime,BTRDesc,REQSTDesc,HOSPDesc,TRANSUpdateDate,TRANSUpdateTime,TRANSTYPCode,TRANSTYPDesc,TRANSDateAccepted,TRANSTimeAccepted,TRANSClosure,PAADMPAPMIDR,CTLOCDesc,BTRTransferRemark,BEDTPDesc,TRANSReadyForBill)=""
    .s transGlobal=^PAADM(EpisodeID,"TRANS",sub)
    .s TarDR= $p(transGlobal,"^",21)
    .s:TarDR'="" TRANSTYPCode=$p(^PAC("TRANSTYP",TarDR),"^",1)
    .b:(sub=8)
	.q:(TRANSTYPCode'="")&&(TRANSTYPCode'=TransType)&&(TransType'="")
	.s:TarDR'="" TRANSTYPDesc=$p(^PAC("TRANSTYP",TarDR),"^",2)
	.q:TRANSTYPCode="T"	//Transfer  Move "" 
    .s SSUSRDR = $p(transGlobal,"^",16)
    .s SSUSRName = $s(SSUSRDR'="":$p(^SSU("SSUSR",SSUSRDR),"^",2),1:"")
    .s WARDDR = $p(transGlobal,"^",9)
    .s:WARDDR'="" WARDDesc=$p(^PAWARD(WARDDR),"^",2)
    .s ROOMDR=$p(transGlobal,"^",7)
    .s:ROOMDR'="" ROOMDesc=$p(^PAROOM(ROOMDR),"^",2)
    .s ROOMTDR=$p(transGlobal,"^",10)
    .s:ROOMTDR'="" ROOMTDesc=$p(^PAC("ROOMT",ROOMTDR),"^",2)
    .s BEDDR=$p(transGlobal,"^",8)
    .s:BEDDR'="" BEDCode=$p(^PAWARD(+BEDDR,"BED",$p(BEDDR,"||",2)),"^",1)
    .s TRANSParRef=EpisodeID
    .s TRANSEndDate=$p(transGlobal,"^",3)
    .s TRANSEndTime=$p(transGlobal,"^",4)
    .s TRANSStartDate=$p(transGlobal,"^",1)
    .s TRANSStartTime=$p(transGlobal,"^",2)
    .s TRANSUpdateDate=$p(transGlobal,"^",14)
    .s TRANSUpdateTime=$p(transGlobal,"^",15)
    .s TRANSDateAccepted=$p(transGlobal,"^",22)
    .s TRANSTimeAccepted=$p(transGlobal,"^",23)
    .s TRANSClosure=$p(transGlobal,"^",26)
    .s TRANSReadyForBill=$p(transGlobal,"^",32)
    .s StatusDR=$p(transGlobal,"^",12) ;TRANS_Status_DRPACTransfRequestStatus
    .s:StatusDR'="" REQSTDesc=$p(^PAC("REQST",StatusDR),"^",2)
    .s CTLOCDR=$p(transGlobal,"^",6)
    .s:CTLOCDR'="" CTLOCDesc=$p(^CTLOC(CTLOCDR),"^",2)
    .s BEDTPDR=$p(transGlobal,"^",31)
    .s:(BEDTPDR'="")&&($d(^PAC("BEDTP",BEDTPDR))'=0) BEDTPDesc=$p(^PAC("BEDTP",BEDTPDR),"^",2)
    .;s BTRDesc=
    .;s HOSPDesc=
    .;s BTRTransferRemark,
    .d OutPat2
	Quit
OutPat2
	w !,EpisodeID_"||"_sub_","_SSUSRName_","_WARDDesc_","_ROOMDesc_","_ROOMTDesc_","_BEDCode_","_TRANSParRef_","_TRANSEndDate_","_TRANSEndTime_","_TRANSStartDate_","_TRANSStartTime_","_BTRDesc_","_REQSTDesc_","_HOSPDesc_","_TRANSUpdateDate_","_TRANSUpdateTime_","_TRANSTYPCode_","_TRANSTYPDesc_","_TRANSDateAccepted_","_TRANSTimeAccepted_","_TRANSClosure_","_PAADMPAPMIDR_","_CTLOCDesc_","_BTRTransferRemark_","_BEDTPDesc_","_TRANSReadyForBill
	quit
}

/* 2015-07-28 lfb&lb
/// 根据可重复模板标题Code取InstanceID
/// w ##class(EMRservice.Tools.DailyWorkTool).GetInsIDListByTitleCode("7966811","1")
ClassMethod GetInsIDListByTitleCode(AEpisodeID As %String = "", ATitleCode As %String = "")
{
	Quit:((AEpisodeID="")||(ATitleCode="")) ""
	s instancedataid="",ret=""
	&sql(select ID into :instancedataid from EMRInstance.InstanceData where EpisodeID=:AEpisodeID and TitleCode=:ATitleCode and Status="Save")
	q:(instancedataid="")
	s recordid=$p(instancedataid,"||",1)
	s subnum=$p(instancedataid,"||",2)
	s subcount=0
	&sql(select InstanceCount into:subcount from EMRInstance.ECRecord where ID=:recordid)
	s intobj=""
	for i=subnum:1:subcount{
		
			s intobj=##class(EMRinstance.InstanceData).%OpenId(recordid_"||"_i)
			continue:(intobj="")
			s intstatus=intobj.Status
			continue:(intstatus'="Save")
			
			s inttitleCode=intobj.TitleCode
			continue:(inttitleCode'=ATitleCode)
			s ret=ret_"^"_recordid_"||"_i
		
		}
	s ret=$e(ret,2,*)
	
	Quit ret
}
*/
/// d ##Class(EMRservice.Tools.DailyWorkTool).GetDocumentByID(494153)
ClassMethod GetDocumentByID(AEpisodeID As %String)
{
	s HasOld=""
	s HasOld=$O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID,""))
	if HasOld="" {
			d ##Class(EMRservice.Tools.DailyWorkTool).GetDocmentByEpisodeID(AEpisodeID)
		
		}
		else{
			d ##Class(EMRservice.Tools.DailyWorkTool).GetDocmentByEpisodeIDOld(AEpisodeID)
		}
}

/// d ##Class(EMRservice.Tools.DailyWorkTool).GetDocmentByEpisodeID(10868835)
ClassMethod GetDocmentByEpisodeID(AEpisodeID As %String = "")
{
	q:(AEpisodeID="") "未输入就诊号！"
	s TotalCount=0,SucCount=0
	s HpDate=""
	for {
		s HpDate=$o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",HpDate))
		q:(HpDate="")
		s HpTime=""
		for {
			s HpTime=$o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",HpDate,HpTime))	
			q:(HpTime="")
			s Theecid=""
			for {
				s Theecid=$o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",HpDate,HpTime,Theecid))	
				q:(Theecid="")
				s numid=""
				for {
					s numid=$o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",HpDate,HpTime,Theecid,numid))	
					q:(numid="")
					s tmpInstanceid=Theecid_"||"_numid
					s Objinstancedata=##class(EMRinstance.InstanceData).%OpenId(tmpInstanceid)
					s tmpTitleCode=Objinstancedata.TitleCode
					s tmpTitleID="",tmpTitle="",objTitle=""
					s tmpTitleID=$o(^DHCEMRM.TitlesI("IdxCode"," "_tmpTitleCode,tmpTitleID))
					s:(tmpTitleID'="") objTitle=##class(EMRmeta.Titles).%OpenId(tmpTitleID)
					s:(objTitle'="") tmpTitle=objTitle.Alias
					s tmpTitle=$tr(tmpTitle,"/",".")
					s status=..GetDocumentForPatAll(tmpInstanceid,tmpTitle,AEpisodeID,HpDate)
					//b:(tmpInstanceid="235425||1") 
					if (status=1)
					{
						
						s SucCount=SucCount+1	
					}
					s TotalCount=TotalCount+1
					
				}
			}	

		} 	
	}
	w !,"患者"_AEpisodeID_"本次导出,总计"_TotalCount_",成功"_SucCount
}

/// w ##Class(EMRservice.Tools.DailyWorkTool).GetDocumentForPatAll("235425||1",)
/// w ##Class(EMRservice.Tools.DailyWorkTool).GetDocument("235425||1")
ClassMethod GetDocumentForPatAll(AInstanceID As %String, ATitle As %String, AEpisodeID As %String, ADate As %String) As %String
{


	s argOutData = ##class(%FileBinaryStream).%New() 

	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID) 
	d argOutData.CopyFrom(##Class(EMRservice.BL.BLTemplate).GetRecordXML(objInstance.TemplateID,"Document",objInstance.Title,objInstance.TitleCode,objInstance.InstanceMetaData,objInstance.InstanceScriptData,objInstance.InstanceData,objInstance.InstanceMedia))
	
	s AStream=##Class(%FileBinaryStream).%New()
	//小机路径
	s AStream.Filename="/tmp/wbg/"_AEpisodeID_"_"_ATitle_"_"_$zd(ADate,3)_"_"_AInstanceID_".xml"
	//s AStream.Filename="/tmp/wbg/SAVE_DOCUMENT_"_AInstanceID_".xml"
	//windows路径
	//s AStream.Filename="D:\"_AEpisodeID_"_"_ATitle_"_"_$zd(ADate,3)_"_"_$tr(AInstanceID,"||","__")_".xml"
	
	d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
	q 1
}

/// d ##Class(EMRservice.Tools.DailyWorkTool).GetDocmentByEpisodeIDOld(10868835)
ClassMethod GetDocmentByEpisodeIDOld(AEpisodeID As %String = "")
{
	q:(AEpisodeID="") "未输入就诊号！"
	s TotalCount=0,SucCount=0
	s CharItemID=""
	for {
		s CharItemID=$o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID,CharItemID))
		q:(CharItemID="")
		s ECRecordID=""
		for {
			s ECRecordID=$o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID,CharItemID,ECRecordID))	
			q:(ECRecordID="")

			s ChildNum=""
			for {
				s ChildNum=$o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID,ChildNum))	
				q:(ChildNum="")
				s tmpInstanceid=ECRecordID_"||"_$e(ChildNum,2,*)
				s Objinstancedata=##class(EMRinstance.InstanceData).%OpenId(tmpInstanceid)
				q:(Objinstancedata="")
				s tmpTitle=Objinstancedata.TitleCode
				s tmpHappentDate=Objinstancedata.HappenDate			
				s status=..GetDocumentForPatAllOld(tmpInstanceid,tmpTitle,AEpisodeID,tmpHappentDate)
				if (status=1)
				{
						
					s SucCount=SucCount+1	
				}
				s TotalCount=TotalCount+1
					
			}	

		} 	
	}
	w !,"患者"_AEpisodeID_"本次导出,总计"_TotalCount_",成功"_SucCount
}

/// w ##Class(EMRservice.Tools.DailyWorkTool).GetDocumentForPatAll("235425||1",)
/// w ##Class(EMRservice.Tools.DailyWorkTool).GetDocument("235425||1")
ClassMethod GetDocumentForPatAllOld(AInstanceID As %String, ATitle As %String, AEpisodeID As %String, ADate As %String) As %String
{

	s tmpdata=##class(%GlobalCharacterStream).%New()
	s argOutData = ##class(%FileBinaryStream).%New() 
	
	s AStream=##Class(%FileBinaryStream).%New()
	//小机路径
	s AStream.Filename="/tmp/wbg/"_AEpisodeID_"_"_ATitle_"_"_$zd(ADate,3)_"_"_AInstanceID_".xml"
	
	
	s objInstance=""
	s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance="") 0
	
	s tmpdata=objInstance.InstanceData
	
	s size = tmpdata.Size
	for i=1:1:(size\32767)+1
	{
		s tmpstr=tmpdata.Read(32767)
		s tmpstr=$ZSTRIP(tmpstr,"*C")
		s tmpstr=$zcvt(tmpstr,"O","UTF8")
		d AStream.Write(tmpstr)	
	}

	d AStream.SaveStream()
	d AStream.%Close()
	q 1
}

/// 病历打印时间统计
/// 说明：1. 统计出院患者，且书写了出院记录
///       2. 入参依次为 起始时间，结束时间，统计操作类型（默认打印）
/// debugger: w ##class(EMRservice.Tools.DailyWorkTool).ExportPatDischTimeWAndRecord("2016-01-11","2016-01-17","print")
/// 16-01-17
ClassMethod ExportPatDischTimeWAndRecord(AStartDate As %String, AEndDate As %String, AfstAction As %String = "print") As %String
{
	 s sysStartDate=$zdh(AStartDate,3)
	 s sysEndDate=$zdh(AEndDate,3)
	 
	 q:((sysEndDate-sysStartDate)>7) "考虑执行效率，请重新录入起始截止时间！"
	 s totalcount=0,count=0
	 w !,"科室,病区,病人ID,姓名,出院时间,出院记录完成时间差值（先完成后出院为正数）"
			
	 for tmpDate=sysStartDate:1:sysEndDate 
	 {
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAADMi("DischDate",tmpDate,EpisodeID))
			q:(EpisodeID = "")
			s totalcount=totalcount+1
			s tmpDischDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(EpisodeID)
			s DischDateTime=$tr(tmpDischDateTime,","," ")
			
			//协和出院记录ChartItemID=88 Template=21 
			//可输出状态病历为完成 save
			
			s ECRecordID=""
			s ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_EpisodeID," 88",""))
			
			continue:(ECRecordID="")
			//s DischRecordTypeTime=""
			s listnum=""
			s listnum=$o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ECRecordID," 21"," SAVE",listnum))
			continue:(listnum="")
			
			s logId=""
			s logId = $o(^DHCEMRI.EMRLogsI("IdxMain"," "_EpisodeID," 88",listnum,logId)) 
			continue:(logId = "") 
			
			s objLog = ##Class(EMRinstance.EMRLogs).%OpenId(logId)
			continue:(objLog = "") 
	
			s date = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",logId," "_$zcvt(AfstAction,"U"),""))
			continue:(date = "") 
			s time = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",logId," "_$zcvt(AfstAction,"U"),date,""))
			continue:(time = "") 
			s instanceLogId = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",logId," "_$zcvt(AfstAction,"U"),date,time,"")) 
			continue:(instanceLogId = "") 
			s result = ##Class(EMRinstance.InstanceLog).%OpenId(logId_"||"_instanceLogId)
			
			s tmpOpDate=result.OperateDate
			s tmpOpTime=result.OperateTime
			
			s tmpOpDateTime=tmpOpDate_" "_tmpOpTime
			
			//出院日期-病历action【打印】时间
			//1. 先打印后出院，正数
			//2. 精确到小时
			s timeGap=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DischDateTime,tmpOpDateTime)
			s timeGap=timeGap\1_"小时"
			
			
			
			s tmpstr="",Papmi="",PatientName="",RegNo="",Gender="",DisLocID="",DisWardID=""
			s tmpstr=$g(^PAADM(EpisodeID))

			
			
			s Papmi = $p(tmpstr,"^",1)
			s PatientName = $p($g(^PAPER(+Papmi,"ALL")),"^",1)			
			s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
			//s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
			
			s DisLocID = $p(tmpstr,"^",4)
			s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
			s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
				
			s DisWardID = $p(tmpstr,"^",70)
			s WardDesc = $p($g(^PAWARD(+DisWardID)),"^",2)	
			
			
			w !,LocDesc_","_WardDesc_","_RegNo_","_PatientName_","_$zdt(tmpDischDateTime,3,1)_","_timeGap
							
			s count=count+1
		}
	 }
	 q "执行完成统计数据总计:"_totalcount_"  有效统计总计:"_count
}

/// d ##Class(EMRservice.Tools.DailyWorkTool).InitQueryEyeItem()
ClassMethod InitQueryEyeItem()
{
    /*   &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.001","Y","EyeItem6001","0","1","","6001","1","姓名"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.002","Y","EyeItem6002","0","1","","6002","1","性别"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.003","Y","EyeItem6003","0","1","","6003","1","年龄"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.004","Y","EyeItem6004","0","1","","6004","1","身份证号"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.005","Y","EyeItem6005","0","1","","6005","1","联系电话"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.006","Y","EyeItem6006","0","1","","6006","1","地址-省"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.007","Y","EyeItem6007","0","1","","6007","1","地址-市"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.008","Y","EyeItem6008","0","1","","6008","1","地址-区县"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.009","Y","EyeItem6009","0","1","","6009","1","地址-街道（乡镇）"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.010","Y","EyeItem6010","0","1","","6010","1","相关疾病"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.011","Y","EyeItem6011","0","1","","6011","1","相关疾病备注"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.012","Y","EyeItem6012","0","1","","6012","1","手术眼"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.013","Y","EyeItem6013","0","1","","6013","1","术前裸眼视力-右眼"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.014","Y","EyeItem6014","0","1","","6014","1","术前裸眼视力-左眼"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.015","Y","EyeItem6015","0","1","","6015","1","术前矫正视力-右眼"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.016","Y","EyeItem6016","0","1","","6016","1","术前矫正视力-左眼"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.017","Y","EyeItem6017","0","1","","6017","1","眼压-右眼"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.018","Y","EyeItem6018","0","1","","6018","1","眼压-左眼"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.019","Y","EyeItem6019","0","1","","6019","1","白内障分类"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.020","Y","EyeItem6020","0","1","","6020","1","白内障分类备注"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.021","Y","EyeItem6021","0","1","","6021","1","瞳孔"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.022","Y","EyeItem6022","0","1","","6022","1","瞳孔备注"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.023","Y","EyeItem6023","0","1","","6023","1","手术日期"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.024","Y","EyeItem6024","0","1","","6024","1","手术方式"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.025","Y","EyeItem6025","0","1","","6025","1","手术方式备注"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.026","Y","EyeItem6026","0","1","","6026","1","手术医生"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.027","Y","EyeItem6027","0","1","","6027","1","是否植入人工晶体"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.028","Y","EyeItem6028","0","1","","6028","1","术中并发症"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.029","Y","EyeItem6029","0","1","","6029","1","术中并发症备注"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.030","Y","EyeItem6030","0","1","","6030","1","手术经费来源"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.031","Y","EyeItem6031","0","1","","6031","1","手术经费其他来源备注"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.032","Y","EyeItem6032","0","1","","6032","1","术后三日内裸眼视力"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.033","Y","EyeItem6033","0","1","","6033","1","术后三日矫正视力"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.034","Y","EyeItem6034","0","1","","6034","1","术后三日并发症"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.035","Y","EyeItem6035","0","1","","6035","1","术后三日并发症备注"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.036","Y","EyeItem6036","0","1","","6036","1","术后三个月裸眼视力"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.037","Y","EyeItem6037","0","1","","6037","1","术后三个月矫正视力"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.038","Y","EyeItem6038","0","1","","6038","1","术后三个月并发症"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.039","Y","EyeItem6039","0","1","","6039","1","术后三个月并发症备注"))
  &sql(insert Into EPRmeta_Query.QueryItem Values ("29","A10.01.040","Y","EyeItem6040","0","1","","6040","1","其他需要说明情况"))
  */
}

/// d ##Class(EMRservice.Tools.DailyWorkTool).GetZSHotPatinfo("2012-08-31","2012-08-31")
ClassMethod GetZSHotPatinfo(strDate As %String, endDate As %String)
{
	s strDate=$zdh(strDate,3)
	s endDate=$zdh(endDate,3)
	s HotCount=0,TotalCount=0
	for tmpDate=strDate:1:endDate {
		w !,$zd(tmpDate,3)
		s tmpadmid=""
		for {
			s tmpadmid=$o(^PAADMi("DischDate",tmpDate,tmpadmid))
			q:tmpadmid=""
			s tmpstr=$g(^PAADM(tmpadmid))
			s pattype=$p(tmpstr,"^",2)
			continue:pattype'="I"
			s MainDiagDesc="",arr=""
			s arr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(tmpadmid,"HDSB05.10")
			continue:arr=""
			s firstPageAdmLoc=arr.GetAt("HDSB05.10.047")
			//如果不是结肠 癌 肿瘤 相关的 继续循环下一个患者
			
			continue:'((firstPageAdmLoc["普通内科")||(firstPageAdmLoc["感染内科"))
			
			//科室、病区、姓名、病人ID、性别、出院时间、主要诊断、主诉、联系人、联系方式、住院天数
			
			//主诉
			s arrRYJL=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(tmpadmid,"HDSD00.13.01")
			s zhusu=arrRYJL.GetAt("HDSD00.13.114")
			s HotFlag=""
			continue:(zhusu'["发热")
			
			s Papmi = $p(tmpstr,"^",1)
			s PatientName = $p($g(^PAPER(+Papmi,"ALL")),"^",1)			
			s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
			s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
			//s DischDate = $p(tmpstr,"^",17)
			//s:(DischDate '= "") DischDate = $zd(DischDate,3)
			
			
			//s DisLocID = $p(tmpstr,"^",4)
			//s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
			//s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
			
			
			//s DisWardID = $p(tmpstr,"^",70)
			//s WardDesc = $p($g(^PAWARD(+DisWardID)),"^",2)			
			//s WLocID = $p($g(^PAWARD(+DisWardID)),"^",5)
			//s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
			//s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
			
			
			//联系人、电话
			s ralationName=arr.GetAt("HDSB05.10.041")
			s ralationPhoneNum=arr.GetAt("HDSB05.10.044")
			
			s ralationPhoneNum=arr.GetAt("HDSB05.10.044")
			
			/*
			主诉包含发热 普通内科 感染内科
				患者ID
				病案号
				姓名
				性别
				身份证号 HDSB05.10.025 
				入院日期 HDSB05.10.046
				入院科室 HDSB05.10.047
				入院病房 HDSB05.10.048

				出院日期 HDSB05.10.050
				出院科室 HDSB05.10.051

				主要诊断
				管床医生
				主治医师

				HDSB05.10.075 主治医师签名
				HDSB05.10.076 住院医师签名
			*/
			s personID=arr.GetAt("HDSB05.10.025")
			s firstPageAdmWard=arr.GetAt("HDSB05.10.048")
			s firstPageAdmDate=arr.GetAt("HDSB05.10.046")
			
			s firstPageDischLoc=arr.GetAt("HDSB05.10.051")
			s firstPageDischDate=arr.GetAt("HDSB05.10.050")
			
			s firstPageAttendDoctor=arr.GetAt("HDSB05.10.075")
			s firstPageResDoctor=arr.GetAt("HDSB05.10.076")
			
			
			w !,firstPageAdmLoc_"|"_firstPageAdmWard_"|"_firstPageAdmDate_"|"_firstPageDischLoc_"|"_firstPageDischDate_"|"_PatientName_"|"_RegNo_"|"_tmpadmid_"|"_Gender_"|"_personID_"|"_MainDiagDesc_"|"_ralationName_"|"_ralationPhoneNum_"|"_firstPageResDoctor_"|"_firstPageAttendDoctor_"|"_zhusu
			s tmpobj=##class(EMRinstance.FirstPage.PatInfoData).%New()
			s tmpobj.DiachDate=tmpDate
			s tmpobj.EpisodeID=tmpadmid
			s tmpobj.PatType="DoctorZhuForZSHot"
			d tmpobj.%Save()
			d tmpobj.%Close()
			s tmpobj=""
			s TotalCount=+$g(TotalCount)+1
		}
	}
	
	w !,"总数："_TotalCount
}

/// Desc:  导出病程记录
/// Input: ALocID 科室ID
///       ADocID 病历展现结构倒数第二层ID
///       ASections 章节Code 多个以"^"分隔
///       AStartDate 开始时间点 格式如：2016-3-23
///       AEndDate   结束时间点 格式如：2016-3-23
/// Debug: w ##Class(EMRservice.Tools.DailyWorkTool).GetRecords(6,"56","S001^S002","2016-3-20","2016-3-23")
ClassMethod GetRecords(ALocID As %String, ADocID As %String, ASections As %String, AStartDate As %String, AEndDate As %String) As %String
{
	q:(ADocID = "")||(ASections = "") ""
	s startdate = $zdh(AStartDate,3)
	s enddate = $zdh(AEndDate,3)
	s episodeId = ""
	for
	{
		s episodeId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",episodeId))
		q:(episodeId = "")
		s tempEpisodeId = $tr(episodeId," ")
		if (ALocID '= "")
		{
			s locId = $P($g(^PAADM(tempEpisodeId)),"^",4)
			continue:(locId '= ALocID)	
		}	
		s AStream=##Class(%FileBinaryStream).%New()
		s AStream.Filename="/tmp/wbg/doc"_tempEpisodeId_".txt"
		s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",episodeId," "_ADocID,""))
		continue:(ecrecordId = "")
		s date = startdate
		for
		{
			s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE",date))
			q:(date = "")
			q:((enddate '= "")&&(date > enddate))
			s time = ""
			for
			{
				s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE",date,time))
				q:(time = "")
				s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE",date,time,""))
				continue:(subId = "")
				s InstanceId = ecrecordId_"||"_subId
				s count = $l(ASections,"^")
				for i=1:1:count
				{
					s code = $p(ASections,"^",i)
					s sdId = $o(^DHCEMRI.ISectionDescI("IdxForUpdate"," "_InstanceId," "_$zcvt(code,"U"),""))
					continue:(sdId = "")
					s objSd = ##Class(EMRinstance.ISectionDesc).%OpenId(sdId)
					continue:(objSd = "")
					s text = $zcvt(objSd.Text.Read(32767),"O","UTF8")
					d AStream.Write(text)
					d AStream.Write($c(13))
				}	
			}
		}
		d AStream.SaveStream()
		d AStream.%Close()	
	}
	q "1"
}

/// d ##class(%ResultSet).RunQuery("EMRservice.Tools.DailyWorkTool","GetEpisodeInfo","2015-03-09","2015-03-10")	
Query GetEpisodeInfo(Fdate As %String, Tdate As %String) As %Query(ROWSPEC = "PapmiDR,Name,Date,admID,result,PAAdmType,DisDept") [ SqlProc ]
{
}

ClassMethod GetEpisodeInfoExecute(ByRef qHandle As %Binary, Fdate As %String, Tdate As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (Fdate="")||(Tdate="" ) d
	.Set qHandle=$lb(0,repid,0)
 	i (Fdate="")||(Tdate="" ) Quit $$$OK
 	s result = ""
    s Fdate=$zdh(Fdate,3)
    s Tdate=$zdh(Tdate,3)
    f Day=Fdate:1:Tdate d
    .s rowId="",date = ""
    .s admID=0 f  s admID=$o(^PAADMi("DischDate",Day,admID)) q:(admID="")  d
    ..s PAAdmType = $P(^PAADM(admID),"^",2)
    ..q:(PAAdmType'="I")
    ..s DisDept = ##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(admID,"")
    ..s DisDeptCode = $P(DisDept,"^",1)
    ..q:(DisDeptCode'="31")&&(DisDeptCode'="44")
    ..s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(admID)
    ..s Name = ##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
    ..s rowId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_admID," 62",rowId))
    ..q:(rowId = "")
    ..s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",date))
    ..q:(date = "")
    ..s Date = $ZD(date,3)
    ..s result=##class(EMRservice.BL.BLOperationIntervene).getOperationIntervene(admID,"62")
    ..q:($P(result,"^",1)=1)
    ..Do GetClinicAccCateFee
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetClinicAccCateFee
	set Data=$lb(PapmiDR,Name,Date,admID,result,PAAdmType,DisDept)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod GetEpisodeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetClinicAccCateFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEpisodeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetClinicAccCateFeeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// 通过术语集取病案首页全部诊断接口
/// 返回值格式：手术信息1$c(1)手术信息2$c(1)手术信息3$c(1)……
/// 手术信息具体内容：
/// 	手术日期^手术名称^手术编码^麻醉方式^麻醉医师^术者^一助^二助^手术级别
/// w ##Class(EMRservice.Tools.DailyWorkTool).GetFirstPageOperByAdm(15092274)
ClassMethod GetFirstPageOperByAdm(AEpisodeID As %String = "") As %String
{
 	q:(AEpisodeID="") 0
	s tmpstr=$g(^PAADM(AEpisodeID))
	s pattype=$p(tmpstr,"^",2)
	q:(pattype'="I") -1
	s arr=""
	
	
	s (OperDate1,OperName1,OperCode1,OperAnaMethod1,OperAnaDoc1,OperDoc1,OperAssist1,OperSecAssist1,OpeLevel1)=""
	s (OperDate2,OperName2,OperCode2,OperAnaMethod2,OperAnaDoc2,OperDoc2,OperAssist2,OperSecAssist2,OpeLevel2)=""
	s (OperDate3,OperName3,OperCode3,OperAnaMethod3,OperAnaDoc3,OperDoc3,OperAssist3,OperSecAssist3,OpeLevel3)=""
	s (OperDate4,OperName4,OperCode4,OperAnaMethod4,OperAnaDoc4,OperDoc4,OperAssist4,OperSecAssist4,OpeLevel4)=""
	s (OperDate5,OperName5,OperCode5,OperAnaMethod5,OperAnaDoc5,OperDoc5,OperAssist5,OperSecAssist5,OpeLevel5)=""
	s (OperDate6,OperName6,OperCode6,OperAnaMethod6,OperAnaDoc6,OperDoc6,OperAssist6,OperSecAssist6,OpeLevel6)=""
	s (OperDate7,OperName7,OperCode7,OperAnaMethod7,OperAnaDoc7,OperDoc7,OperAssist7,OperSecAssist7,OpeLevel7)=""
	s (OperDate8,OperName8,OperCode8,OperAnaMethod8,OperAnaDoc8,OperDoc8,OperAssist8,OperSecAssist8,OpeLevel8)=""
	
	
	
	s arr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(AEpisodeID,"HDSB05.10")
	q:arr=""
	    
	s Papmi = $p(tmpstr,"^",1)
	s PatientName = $p($g(^PAPER(+Papmi,"ALL")),"^",1)

	/*
		HDSB05.10.085 手术/操作代码
		HDSB05.10.086 手术/操作名称
		HDSB05.10.087 手术/操作日期时间
		HDSB05.10.088 手术级别
		HDSB05.10.089 手术者签名
		HDSB05.10.090 Ⅰ助签名
		HDSB05.10.091 Ⅱ助签名
		HDSB05.10.092 麻醉方式
		HDSB05.10.093 麻醉医师签名
		HDSB05.10.600 手术/操作1结束日期时间
		HDSB05.10.601 手术者1签名代码
		HDSB05.10.602 Ⅰ助1签名代码
		HDSB05.10.603 Ⅱ助1签名代码
		HDSB05.10.604 麻醉医师1签名代码
	
	*/
	s OperDate1=arr.GetAt("HDSB05.10.087")
	s OperName1=arr.GetAt("HDSB05.10.086")
	s OperCode1=arr.GetAt("HDSB05.10.085")
	s OperAnaMethod1=arr.GetAt("HDSB05.10.092")
	s OperAnaDoc1=arr.GetAt("HDSB05.10.093")
	s OperDoc1=arr.GetAt("HDSB05.10.089")
	s OperAssist1=arr.GetAt("HDSB05.10.090")
	s OperSecAssist1=arr.GetAt("HDSB05.10.091")
	s OpeLevel1=arr.GetAt("HDSB05.10.088")
	
	
	/*
		
HDSB05.10.605 手术/操作2开始日期时间
HDSB05.10.606 手术/操作2结束日期时间
HDSB05.10.607 手术名称2
HDSB05.10.608 手术编码2
HDSB05.10.609 手术级别2
HDSB05.10.610 手术切口及愈合类别2
HDSB05.10.611 术者2
HDSB05.10.612 术者2编码
HDSB05.10.613 I助2
HDSB05.10.614 I助2编码
HDSB05.10.615 II助2
HDSB05.10.616 II助2编码
HDSB05.10.617 麻醉方式2
HDSB05.10.618 麻醉医师2
HDSB05.10.619 麻醉医师2编码
	
	*/
	s OperDate2=arr.GetAt("HDSB05.10.605")
	s OperName2=arr.GetAt("HDSB05.10.607")
	s OperCode2=arr.GetAt("HDSB05.10.608")
	s OperAnaMethod2=arr.GetAt("HDSB05.10.617")
	s OperAnaDoc2=arr.GetAt("HDSB05.10.618")
	s OperDoc2=arr.GetAt("HDSB05.10.611")
	s OperAssist2=arr.GetAt("HDSB05.10.613")
	s OperSecAssist2=arr.GetAt("HDSB05.10.615")
	s OpeLevel2=arr.GetAt("HDSB05.10.609")
	
	
	/*
		HDSB05.10.620 手术/操作3开始日期时间
HDSB05.10.621 手术/操作3结束日期时间
HDSB05.10.622 手术名称3
HDSB05.10.623 手术编码3
HDSB05.10.624 手术级别3
HDSB05.10.625 手术切口及愈合类别3
HDSB05.10.626 术者3
HDSB05.10.627 术者3编码
HDSB05.10.628 I助3
HDSB05.10.629 I助3编码
HDSB05.10.630 II助3
HDSB05.10.631 II助3编码
HDSB05.10.632 麻醉方式3
HDSB05.10.633 麻醉医师3
HDSB05.10.634 麻醉医师3编码
	
	*/
	s OperDate3=arr.GetAt("HDSB05.10.620")
	s OperName3=arr.GetAt("HDSB05.10.622")
	s OperCode3=arr.GetAt("HDSB05.10.623")
	s OperAnaMethod3=arr.GetAt("HDSB05.10.632")
	s OperAnaDoc3=arr.GetAt("HDSB05.10.633")
	s OperDoc3=arr.GetAt("HDSB05.10.626")
	s OperAssist3=arr.GetAt("HDSB05.10.628")
	s OperSecAssist3=arr.GetAt("HDSB05.10.630")
	s OpeLevel3=arr.GetAt("HDSB05.10.624")
	
	
	/*
		HDSB05.10.635 手术/操作4开始日期时间
HDSB05.10.636 手术/操作4结束日期时间
HDSB05.10.637 手术名称4
HDSB05.10.638 手术编码4
HDSB05.10.639 手术级别4
HDSB05.10.640 手术切口及愈合类别4
HDSB05.10.641 术者4
HDSB05.10.642 术者4编码
HDSB05.10.643 I助4
HDSB05.10.644 I助4编码
HDSB05.10.645 II助4
HDSB05.10.646 II助4编码
HDSB05.10.647 麻醉方式4
HDSB05.10.648 麻醉医师4
HDSB05.10.649 麻醉医师4编码
	
	*/
	s OperDate4=arr.GetAt("HDSB05.10.635")
	s OperName4=arr.GetAt("HDSB05.10.637")
	s OperCode4=arr.GetAt("HDSB05.10.638")
	s OperAnaMethod4=arr.GetAt("HDSB05.10.647")
	s OperAnaDoc4=arr.GetAt("HDSB05.10.648")
	s OperDoc4=arr.GetAt("HDSB05.10.641")
	s OperAssist4=arr.GetAt("HDSB05.10.643")
	s OperSecAssist4=arr.GetAt("HDSB05.10.645")
	s OpeLevel4=arr.GetAt("HDSB05.10.639")
	
	
	/*
		HDSB05.10.650 手术/操作5开始日期时间
HDSB05.10.651 手术/操作5结束日期时间
HDSB05.10.652 手术名称5
HDSB05.10.653 手术编码5
HDSB05.10.654 手术级别5
HDSB05.10.655 手术切口及愈合类别5
HDSB05.10.656 术者5
HDSB05.10.657 术者5编码
HDSB05.10.658 I助5
HDSB05.10.659 I助5编码
HDSB05.10.660 II助5
HDSB05.10.661 II助5编码
HDSB05.10.662 麻醉方式5
HDSB05.10.663 麻醉医师5
HDSB05.10.664 麻醉医师5编码
	
	*/
	s OperDate5=arr.GetAt("HDSB05.10.650")
	s OperName5=arr.GetAt("HDSB05.10.652")
	s OperCode5=arr.GetAt("HDSB05.10.653")
	s OperAnaMethod5=arr.GetAt("HDSB05.10.662")
	s OperAnaDoc5=arr.GetAt("HDSB05.10.663")
	s OperDoc5=arr.GetAt("HDSB05.10.656")
	s OperAssist5=arr.GetAt("HDSB05.10.658")
	s OperSecAssist5=arr.GetAt("HDSB05.10.660")
	s OpeLevel5=arr.GetAt("HDSB05.10.654")
	
	
	/*
		HDSB05.10.665 手术/操作6开始日期时间
HDSB05.10.666 手术/操作6结束日期时间
HDSB05.10.667 手术名称6
HDSB05.10.668 手术编码6
HDSB05.10.669 手术级别6
HDSB05.10.670 手术切口及愈合类别6
HDSB05.10.671 术者6
HDSB05.10.672 术者6编码
HDSB05.10.673 I助6
HDSB05.10.674 I助6编码
HDSB05.10.675 II助6
HDSB05.10.676 II助6编码
HDSB05.10.677 麻醉方式6
HDSB05.10.678 麻醉医师6
HDSB05.10.679 麻醉医师6编码
	
	*/
	s OperDate6=arr.GetAt("HDSB05.10.665")
	s OperName6=arr.GetAt("HDSB05.10.667")
	s OperCode6=arr.GetAt("HDSB05.10.668")
	s OperAnaMethod6=arr.GetAt("HDSB05.10.677")
	s OperAnaDoc6=arr.GetAt("HDSB05.10.678")
	s OperDoc6=arr.GetAt("HDSB05.10.671")
	s OperAssist6=arr.GetAt("HDSB05.10.673")
	s OperSecAssist6=arr.GetAt("HDSB05.10.675")
	s OpeLevel6=arr.GetAt("HDSB05.10.669")
	
	
	/*
		HDSB05.10.680 手术/操作7开始日期时间
HDSB05.10.681 手术/操作7结束日期时间
HDSB05.10.682 手术名称7
HDSB05.10.683 手术编码7
HDSB05.10.684 手术级别7
HDSB05.10.685 手术切口及愈合类别7
HDSB05.10.686 术者7
HDSB05.10.687 术者7编码
HDSB05.10.688 I助7
HDSB05.10.689 I助7编码
HDSB05.10.690 II助7
HDSB05.10.691 II助7编码
HDSB05.10.692 麻醉方式7
HDSB05.10.693 麻醉医师7
HDSB05.10.694 麻醉医师7编码
	
	*/
	s OperDate7=arr.GetAt("HDSB05.10.680")
	s OperName7=arr.GetAt("HDSB05.10.682")
	s OperCode7=arr.GetAt("HDSB05.10.683")
	s OperAnaMethod7=arr.GetAt("HDSB05.10.692")
	s OperAnaDoc7=arr.GetAt("HDSB05.10.693")
	s OperDoc7=arr.GetAt("HDSB05.10.686")
	s OperAssist7=arr.GetAt("HDSB05.10.688")
	s OperSecAssist7=arr.GetAt("HDSB05.10.690")
	s OpeLevel7=arr.GetAt("HDSB05.10.684")
	
	
	/*
		HDSB05.10.695 手术/操作8开始日期时间
HDSB05.10.696 手术/操作8结束日期时间
HDSB05.10.697 手术名称8
HDSB05.10.698 手术编码8
HDSB05.10.699 手术级别8
HDSB05.10.700 手术切口及愈合类别8
HDSB05.10.701 术者8
HDSB05.10.702 术者8编码
HDSB05.10.703 I助8
HDSB05.10.704 I助8编码
HDSB05.10.705 II助8
HDSB05.10.706 II助8编码
HDSB05.10.707 麻醉方式8
HDSB05.10.708 麻醉医师8
HDSB05.10.709 麻醉医师8编码
	
	*/
	s OperDate8=arr.GetAt("HDSB05.10.695")
	s OperName8=arr.GetAt("HDSB05.10.697")
	s OperCode8=arr.GetAt("HDSB05.10.699")
	s OperAnaMethod8=arr.GetAt("HDSB05.10.707")
	s OperAnaDoc8=arr.GetAt("HDSB05.10.708")
	s OperDoc8=arr.GetAt("HDSB05.10.701")
	s OperAssist8=arr.GetAt("HDSB05.10.703")
	s OperSecAssist8=arr.GetAt("HDSB05.10.705")
	s OpeLevel8=arr.GetAt("HDSB05.10.699")
	
	/*
HDSB05.10.710 手术/操作9开始日期时间
HDSB05.10.711 手术/操作9结束日期时间
HDSB05.10.712 手术名称9
HDSB05.10.713 手术编码9
HDSB05.10.714 手术级别9
HDSB05.10.715 手术切口及愈合类别9
HDSB05.10.716 术者9
HDSB05.10.717 术者9编码
HDSB05.10.718 I助9
HDSB05.10.719 I助9编码
HDSB05.10.720 II助9
HDSB05.10.721 II助9编码
HDSB05.10.722 麻醉方式9
HDSB05.10.723 麻醉医师9
HDSB05.10.724 麻醉医师9编码


HDSB05.10.725 手术/操作10开始日期时间
HDSB05.10.726 手术/操作10结束日期时间
HDSB05.10.727 手术名称10
HDSB05.10.728 手术编码10
HDSB05.10.729 手术级别10
HDSB05.10.730 手术切口及愈合类别10
HDSB05.10.731 术者10
HDSB05.10.732 术者10编码
HDSB05.10.733 I助10
HDSB05.10.734 I助10编码
HDSB05.10.735 II助10
HDSB05.10.736 II助10编码
HDSB05.10.737 麻醉方式10
HDSB05.10.738 麻醉医师10
HDSB05.10.739 麻醉医师10编码

HDSB05.10.910 麻醉方式代码1
HDSB05.10.911 麻醉方式代码2
HDSB05.10.912 麻醉方式代码3
HDSB05.10.913 麻醉方式代码4
HDSB05.10.914 麻醉方式代码5
HDSB05.10.915 麻醉方式代码6
HDSB05.10.916 麻醉方式代码7
HDSB05.10.917 麻醉方式代码8
HDSB05.10.918 麻醉方式代码9
HDSB05.10.919 麻醉方式代码10

	*/	

 
	s ret=OperDate1_"^"_OperName1_"^"_OperCode1_"^"_OperAnaMethod1_"^"_OperAnaDoc1_"^"_OperDoc1_"^"_OperAssist1_"^"_OperSecAssist1_"^"_OpeLevel1
	s ret=ret_$c(1)_OperDate2_"^"_OperName2_"^"_OperCode2_"^"_OperAnaMethod2_"^"_OperAnaDoc2_"^"_OperDoc2_"^"_OperAssist2_"^"_OperSecAssist2_"^"_OpeLevel2
	s ret=ret_$c(1)_OperDate3_"^"_OperName3_"^"_OperCode3_"^"_OperAnaMethod3_"^"_OperAnaDoc3_"^"_OperDoc3_"^"_OperAssist3_"^"_OperSecAssist3_"^"_OpeLevel3
	s ret=ret_$c(1)_OperDate4_"^"_OperName4_"^"_OperCode4_"^"_OperAnaMethod4_"^"_OperAnaDoc4_"^"_OperDoc4_"^"_OperAssist4_"^"_OperSecAssist4_"^"_OpeLevel4
	s ret=ret_$c(1)_OperDate5_"^"_OperName5_"^"_OperCode5_"^"_OperAnaMethod5_"^"_OperAnaDoc5_"^"_OperDoc5_"^"_OperAssist5_"^"_OperSecAssist5_"^"_OpeLevel5
	s ret=ret_$c(1)_OperDate6_"^"_OperName6_"^"_OperCode6_"^"_OperAnaMethod6_"^"_OperAnaDoc6_"^"_OperDoc6_"^"_OperAssist6_"^"_OperSecAssist6_"^"_OpeLevel6
	s ret=ret_$c(1)_OperDate7_"^"_OperName7_"^"_OperCode7_"^"_OperAnaMethod7_"^"_OperAnaDoc7_"^"_OperDoc7_"^"_OperAssist7_"^"_OperSecAssist7_"^"_OpeLevel7
	s ret=ret_$c(1)_OperDate8_"^"_OperName8_"^"_OperCode8_"^"_OperAnaMethod8_"^"_OperAnaDoc8_"^"_OperDoc8_"^"_OperAssist8_"^"_OperSecAssist8_"^"_OpeLevel8
	
	q ret
}

/// 通过术语集取病案首页全部诊断接口
/// 返回值格式：diag1desc^diag1icd_$c(1)_diag2desc^diag2icd_$c(1)_……
/// 返回值顺序
/// 	1	门（急）诊诊断
/// 	2	门急诊诊断名称2
/// 	3	门急诊诊断名称3
/// 	4	主要诊断
/// 	5	其他诊断
/// 	6	其他诊断2
/// 	7	其他诊断3
/// 	8	其他诊断4
/// 	9	其他诊断5
/// 	10	其他诊断6
/// 	11	其他诊断7
/// 	12	其他诊断8
/// 	13	其他诊断9
/// 	14	其他诊断10
/// 	15	其他诊断11
/// 	16	其他诊断12
/// 	17	其他诊断13
/// 	18	其他诊断14
/// 	19	其他诊断15
/// 	20	其他诊断16
/// 	21	其他诊断17
/// 	22	其他诊断18
/// 	23	其他诊断19
/// 	24	其他诊断20
/// 	25	其他诊断21
/// 	26	其他诊断22
/// 	27	其他诊断23
/// 	28	病理诊断
/// w ##Class(EMRservice.Tools.EMRRecordDataExport).GetFirstPageDiagByAdm(15962206)
ClassMethod GetFirstPageDiagByAdm(AEpisodeID As %String = "") As %String
{
 	q:(AEpisodeID="") 0
	s tmpstr=$g(^PAADM(AEpisodeID))
	s pattype=$p(tmpstr,"^",2)
	q:(pattype'="I") -1
	s arr=""
	s OpDiagDesc="",OpDiagICD="",OpDiag2Desc="",OpDiag2ICD="",OpDiag3Desc="",OpDiag3ICD=""
	s MainDiagDesc="",MainDiagICD=""
	s OtherDiagDesc="",OtherDiagICD=""
	s OtherDiag2Desc="",OtherDiag2ICD="",OtherDiag3Desc="",OtherDiag3ICD="",OtherDiag4Desc="",OtherDiag4ICD="",OtherDiag5Desc="",OtherDiag5ICD=""
	s OtherDiag6Desc="",OtherDiag6ICD="",OtherDiag7Desc="",OtherDiag7ICD="",OtherDiag8Desc="",OtherDiag8ICD="",OtherDiag9Desc="",OtherDiag9ICD="",OtherDiag10Desc="",OtherDiag10ICD=""
	s OtherDiag11Desc="",OtherDiag11ICD="",OtherDiag12Desc="",OtherDiag12ICD="",OtherDiag13Desc="",OtherDiag13ICD="",OtherDiag14Desc="",OtherDiag14ICD="",OtherDiag15Desc="",OtherDiag15ICD=""
	s OtherDiag16Desc="",OtherDiag16ICD="",OtherDiag17Desc="",OtherDiag17ICD="",OtherDiag18Desc="",OtherDiag18ICD="",OtherDiag19Desc="",OtherDiag19ICD="",OtherDiag20Desc="",OtherDiag20ICD=""
	s OtherDiag21Desc="",OtherDiag21ICD="",OtherDiag22Desc="",OtherDiag22ICD="",OtherDiag23Desc="",OtherDiag23ICD=""
	s phoDiagDesc="",phoDiagICD=""

	
	s arr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(AEpisodeID,"HDSB05.10","")
	q:arr=""
	    
	s Papmi = $p(tmpstr,"^",1)
	s PatientName = $p($g(^PAPER(+Papmi,"ALL")),"^",1)

	
	//HDSB05.10.054 门（急）诊诊断
	s OpDiagDesc=arr.GetAt("HDSB05.10.054")    
	//HDSB05.10.055 门（急）诊诊断（西医诊断）-疾病编码
	s OpDiagICD=arr.GetAt("HDSB05.10.055")    
	//HDSB05.10.500 门急诊诊断名称2
	s OpDiag2Desc=arr.GetAt("HDSB05.10.500")    
	//HDSB05.10.501 门急诊诊断代码2
	s OpDiag2ICD=arr.GetAt("HDSB05.10.501")    
	//HDSB05.10.502 门急诊诊断名称3
	s OpDiag2Desc=arr.GetAt("HDSB05.10.502")    
	//HDSB05.10.503 门急诊诊断代码3
	s OpDiag2ICD=arr.GetAt("HDSB05.10.503")    
	//HDSB05.10.056 出院诊断-主要诊断-疾病名称
	s MainDiagDesc=arr.GetAt("HDSB05.10.056")    
	//HDSB05.10.057 出院诊断-主要诊断-疾病编码
	s MainDiagICD=arr.GetAt("HDSB05.10.057")    
	//HDSB05.10.059 出院诊断-其他诊断-疾病名称
	s OtherDiagDesc=arr.GetAt("HDSB05.10.059")    
	//HDSB05.10.060 出院诊断-其他诊断-疾病编码
	s OtherDiagICD=arr.GetAt("HDSB05.10.060")    
	//HDSB05.10.506 其他诊断2名称
	s OtherDiag2Desc=arr.GetAt("HDSB05.10.506")    
	//HDSB05.10.507 其他诊断2代码
	s OtherDiag2ICD=arr.GetAt("HDSB05.10.507")    
	//HDSB05.10.510 其他诊断3名称
	s OtherDiag3Desc=arr.GetAt("HDSB05.10.510")    
	//HDSB05.10.511 其他诊断3代码
	s OtherDiag3ICD=arr.GetAt("HDSB05.10.511")    
	//HDSB05.10.514 其他诊断4名称
	s OtherDiag4Desc=arr.GetAt("HDSB05.10.514")    
	//HDSB05.10.515 其他诊断4代码
	s OtherDiag4ICD=arr.GetAt("HDSB05.10.515")    
	//HDSB05.10.518 其他诊断5名称
	s OtherDiag5Desc=arr.GetAt("HDSB05.10.518")    
	//HDSB05.10.519 其他诊断5代码
	s OtherDiag5ICD=arr.GetAt("HDSB05.10.519")    
	//HDSB05.10.522 其他诊断6名称
	s OtherDiag6Desc=arr.GetAt("HDSB05.10.522")    
	//HDSB05.10.523 其他诊断6代码
	s OtherDiag6ICD=arr.GetAt("HDSB05.10.523")    
	//HDSB05.10.526 其他诊断7名称
	s OtherDiag7Desc=arr.GetAt("HDSB05.10.526")    
	//HDSB05.10.527 其他诊断7代码
	s OtherDiag7ICD=arr.GetAt("HDSB05.10.527")    
	//HDSB05.10.530 其他诊断8名称
	s OtherDiag8Desc=arr.GetAt("HDSB05.10.530")    
	//HDSB05.10.531 其他诊断8代码
	s OtherDiag8ICD=arr.GetAt("HDSB05.10.531")    
	//HDSB05.10.534 其他诊断9名称
	s OtherDiag9Desc=arr.GetAt("HDSB05.10.534")    
	//HDSB05.10.535 其他诊断9代码
	s OtherDiag9ICD=arr.GetAt("HDSB05.10.535")    
	//HDSB05.10.538 其他诊断10名称
	s OtherDiag10Desc=arr.GetAt("HDSB05.10.538")    
	//HDSB05.10.539 其他诊断10代码
	s OtherDiag10ICD=arr.GetAt("HDSB05.10.539")    
	//HDSB05.10.542 其他诊断11名称
	s OtherDiag11Desc=arr.GetAt("HDSB05.10.542")    
	//HDSB05.10.543 其他诊断11代码
	s OtherDiag11ICD=arr.GetAt("HDSB05.10.543")    
	//HDSB05.10.546 其他诊断12名称
	s OtherDiag12Desc=arr.GetAt("HDSB05.10.546")    
	//HDSB05.10.547 其他诊断12代码
	s OtherDiag12ICD=arr.GetAt("HDSB05.10.547")    
	//HDSB05.10.550 其他诊断13名称
	s OtherDiag13Desc=arr.GetAt("HDSB05.10.550")    
	//HDSB05.10.551 其他诊断13代码
	s OtherDiag13ICD=arr.GetAt("HDSB05.10.551")    
	//HDSB05.10.554 其他诊断14名称
	s OtherDiag14Desc=arr.GetAt("HDSB05.10.554")    
	//HDSB05.10.555 其他诊断14代码
	s OtherDiag14ICD=arr.GetAt("HDSB05.10.555")    
	//HDSB05.10.558 其他诊断15名称
	s OtherDiag15Desc=arr.GetAt("HDSB05.10.558")    
	//HDSB05.10.559 其他诊断15代码
	s OtherDiag15ICD=arr.GetAt("HDSB05.10.559")    
	//HDSB05.10.562 其他诊断16名称
	s OtherDiag16Desc=arr.GetAt("HDSB05.10.562")    
	//HDSB05.10.563 其他诊断16代码
	s OtherDiag16ICD=arr.GetAt("HDSB05.10.563")    
	//HDSB05.10.566 其他诊断17名称
	s OtherDiag17Desc=arr.GetAt("HDSB05.10.566")    
	//HDSB05.10.567 其他诊断17代码
	s OtherDiag17ICD=arr.GetAt("HDSB05.10.567")    
	//HDSB05.10.570 其他诊断18名称
	s OtherDiag18Desc=arr.GetAt("HDSB05.10.570")    
	//HDSB05.10.571 其他诊断18代码
	s OtherDiag18ICD=arr.GetAt("HDSB05.10.571")    
	//HDSB05.10.574 其他诊断19名称
	s OtherDiag19Desc=arr.GetAt("HDSB05.10.574")    
	//HDSB05.10.575 其他诊断19代码
	s OtherDiag19ICD=arr.GetAt("HDSB05.10.575")    
	//HDSB05.10.578 其他诊断20名称
	s OtherDiag20Desc=arr.GetAt("HDSB05.10.578")    
	//HDSB05.10.579 其他诊断20代码
	s OtherDiag20ICD=arr.GetAt("HDSB05.10.579")    
	//HDSB05.10.582 其他诊断21名称
	s OtherDiag21Desc=arr.GetAt("HDSB05.10.582")    
	//HDSB05.10.583 其他诊断21代码
	s OtherDiag21ICD=arr.GetAt("HDSB05.10.583")    
	//HDSB05.10.586 其他诊断22名称
	s OtherDiag22Desc=arr.GetAt("HDSB05.10.586")    
	//HDSB05.10.587 其他诊断22代码
	s OtherDiag22ICD=arr.GetAt("HDSB05.10.587")    
	//HDSB05.10.590 其他诊断23名称
	s OtherDiag23Desc=arr.GetAt("HDSB05.10.590")    
	//HDSB05.10.591 其他诊断23代码
	s OtherDiag23ICD=arr.GetAt("HDSB05.10.591")    
	//HDSB05.10.064 病理诊断-疾病名称
	s phoDiagDesc=arr.GetAt("HDSB05.10.064")    
	//HDSB05.10.065 病理诊断-疾病编码
	s phoDiagICD=arr.GetAt("HDSB05.10.065")

	s ret=OpDiagDesc_"^"_OpDiagICD_$c(1)_OpDiag2Desc_"^"_OpDiag2ICD_$c(1)_OpDiag3Desc_"^"_OpDiag3ICD
	s ret=ret_$c(1)_MainDiagDesc_"^"_MainDiagICD
	s ret=ret_$c(1)_OtherDiagDesc_"^"_OtherDiagICD
	s ret=ret_$c(1)_OtherDiag2Desc_"^"_OtherDiag2ICD_$c(1)_OtherDiag3Desc_"^"_OtherDiag3ICD_$c(1)_OtherDiag4Desc_"^"_OtherDiag4ICD_$c(1)_OtherDiag5Desc_"^"_OtherDiag5ICD
	s ret=ret_$c(1)_OtherDiag6Desc_"^"_OtherDiag6ICD_$c(1)_OtherDiag7Desc_"^"_OtherDiag7ICD_$c(1)_OtherDiag8Desc_"^"_OtherDiag8ICD_$c(1)_OtherDiag9Desc_"^"_OtherDiag9ICD_$c(1)_OtherDiag10Desc_"^"_OtherDiag10ICD
	s ret=ret_$c(1)_OtherDiag11Desc_"^"_OtherDiag11ICD_$c(1)_OtherDiag12Desc_"^"_OtherDiag12ICD_$c(1)_OtherDiag13Desc_"^"_OtherDiag13ICD_$c(1)_OtherDiag14Desc_"^"_OtherDiag14ICD_$c(1)_OtherDiag15Desc_"^"_OtherDiag15ICD
	s ret=ret_$c(1)_OtherDiag16Desc_"^"_OtherDiag16ICD_$c(1)_OtherDiag17Desc_"^"_OtherDiag17ICD_$c(1)_OtherDiag18Desc_"^"_OtherDiag18ICD_$c(1)_OtherDiag19Desc_"^"_OtherDiag19ICD_$c(1)_OtherDiag20Desc_"^"_OtherDiag20ICD
	s ret=ret_$c(1)_OtherDiag21Desc_"^"_OtherDiag21ICD_$c(1)_OtherDiag22Desc_"^"_OtherDiag22ICD_$c(1)_OtherDiag23Desc_"^"_OtherDiag23ICD
	s ret=ret_$c(1)_phoDiagDesc_"^"_phoDiagICD
	
	q ret
}

/// 入参：就诊号
/// 出参：手术日期 ^ 手术名称 ^ 手术医师（区分不开术者 和 一助二助，建议空格分割按顺序取）^麻醉方式 ^ 麻醉医师 
/// w ##class(EMRservice.Tools.DailyWorkTool).GetOperRecordInfo(8002224)
ClassMethod GetOperRecordInfo(AEpisodeID As %String) As %String
{
	s result=""
	s tmpInsts=..GetInsIDListByGroupItemID(AEpisodeID,28)
	for tmpi=1:1:$l(tmpInsts,"^")
	{
		s tmpInstID=$p(tmpInsts,"^",tmpi)
		s tmparr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(AEpisodeID,"HDSD00.06.02",tmpInstID)
		//HDSD00.06.078 手术开始日期时间
		//HDSD00.06.079 手术名称
		//HDSD00.06.085 手术者姓名
		//HDSD00.06.044 麻醉方式
		//HDSD00.06.055 麻醉医师姓名
		
		s operDateTime=tmparr.GetAt("HDSD00.06.078")
		s operName=tmparr.GetAt("HDSD00.06.079")
		s operDoctor=tmparr.GetAt("HDSD00.06.085")
		s operAsaMethod=tmparr.GetAt("HDSD00.06.044")
		s operAsaDoctor=tmparr.GetAt("HDSD00.06.055")
		s OperInfo=operDateTime_"^"_operName_"^"_operDoctor_"^"_operAsaMethod_"^"_operAsaDoctor
		
		s:(result'="") result=result_$c(1)_OperInfo
		s:(result="") result=OperInfo
		
	
	}
	
	q result
}

/// d ##class(EMRservice.Tools.DailyWorkTool).GetMRNoDischDate("2016-09-01","2017-06-12",10)
ClassMethod GetMRNoDischDate(Astartdate As %String, AEndDate As %String, ATopNum As %String)
{
	s strDate=$zdh(Astartdate,3)
	s endDate=$zdh(AEndDate,3)
	s HotCount=0,TotalCount=0
	for tmpDate=strDate:1:endDate {
		w !,$zd(tmpDate,3)
		s tmpadmid=""
		for {
			s tmpadmid=$o(^PAADMi("DischDate",tmpDate,tmpadmid))
			q:tmpadmid=""
			s tmpstr=$g(^PAADM(tmpadmid))
			s pattype=$p(tmpstr,"^",2)
			continue:pattype'="I"
			s MainDiagDesc="",arr=""
			//b ;123
			//Index IdxForLink On (EpisodeID, TemplateID, SectionCode, CompositeCode, SimpleItemCode, InstanceDataID) [ Unique ];
			s tmpInstanceDataID=""
			for {
					s tmpInstanceDataID=$o(^DHCEMRI.ICompositeSimpleI("IdxForLink"," "_tmpadmid," 15"," V001"," V002"," I023",tmpInstanceDataID))
					q:(tmpInstanceDataID="")
					s tmpsimpleID=""
					for 
					{
						s tmpsimpleID=$o(^DHCEMRI.ICompositeSimpleI("IdxForLink"," "_tmpadmid," 15"," V001"," V002"," I023",tmpInstanceDataID,tmpsimpleID))
						q:(tmpsimpleID="")
						//q:(TotalCount>ATopNum)
						s tmpobj=##class(EMRinstance.ICompositeSimple).%OpenId(tmpsimpleID)
						s docName=tmpobj.DataValue
						continue:(docName'["宗威威")
						//b ;1
						//continue:(docName'["张晔")
						s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(tmpadmid)
						s mrno=##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(tmpadmid,"")
						s name=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
						s AdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(tmpadmid,"")
						i AdmDateTime'="" 
						{ 

							s AdmDate = $ZD($P($G(AdmDateTime),",",1),3)
							s AdmTime = $ZT($P($G(AdmDateTime),",",2),2)
							s AdmDateTime=AdmDate_" "_AdmTime

						}
						s admdate=AdmDateTime
						s DisDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(tmpadmid,"")
						i DisDateTime'="" 
						{ 
							s DisDate = $ZD($P($G(DisDateTime),",",1),3)
							s DisTime = $ZT($P($G(DisDateTime),",",2),2)
							s DisDateTime=DisDate_" "_DisTime
						}
						s dischDate=DisDateTime
						w !,"病案号："_mrno_",姓名："_name_",入院时间："_admdate_",出院时间:"_dischDate

						s TotalCount=TotalCount+1
						
						
					}
					
				
			}
		
		}
	}
	w !,"总数:"_TotalCount
}

/// w ##Class(EMRservice.Tools.DailyWorkTool).GetValueOfSetDefaultFontStyle(,"SetDefaultFontStyle")
ClassMethod GetValueOfSetDefaultFontStyle(AEpisodeID As %String = "", OptionName As %String) As %String
{
	s newret="'fontFamily':'宋体','fontSize':'12pt','lineSpace':'1.7','fontSpace':'0'"
	s oldret="'fontFamily':'宋体','fontSize':'12pt','lineSpace':'1.5','fontSpace':'0'"
	q:(AEpisodeID="") newret
	s AdmDate=$P($G(^PAADM(AEpisodeID)),"^",6)
	s AdmTime=$P($G(^PAADM(AEpisodeID)),"^",7)
	
	//2017-07-19  13:00:00
	s updateDate=64483
	s updateTime=46800
	
	if ((AdmDate>updateDate)||((AdmDate=updateDate)&&(AdmTime>updateTime)))
	{
	
		s ret=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName(OptionName)
	}
	else
	{
		s ret=oldret	
	}
	//q:(AEpisodeID=19746890) "'fontFamily':'宋体','fontSize':'12pt','fontSpace':'0'"
	q ret
}

/// w ##Class(EMRservice.Tools.DailyWorkTool).UpdateUserLevelDataFromHIS()
ClassMethod UpdateUserLevelDataFromHIS()
{
		s tmpUserID=""
		s tmpCTPCPID=""
		for {
			s tmpCTPCPID=$o(^CTPCP(tmpCTPCPID)) 
			q:(tmpCTPCPID="")
			continue:(tmpCTPCPID=0)
			continue:(tmpCTPCPID'=+tmpCTPCPID)
			s tmpCTPCPCode=$p(^CTPCP(tmpCTPCPID,1),"^",1)
			s tmpCTPCPCarPrvTpDR=$p(^CTPCP(tmpCTPCPID,1),"^",4)
			
			/*
				15	医师初级	住院医师		Resident
				16	医师副高	副主任医师		Chief
				17	医师正高	主任医师		Chief
				18	医师中级	主治医师		Attending
			*/
			s userLevel=""
			s:(tmpCTPCPCarPrvTpDR=15) userLevel="Resident"
			s:(tmpCTPCPCarPrvTpDR=16) userLevel="Chief"
			s:(tmpCTPCPCarPrvTpDR=17) userLevel="Chief"
			s:(tmpCTPCPCarPrvTpDR=18) userLevel="Attending"
			
			continue:(userLevel="")
			
			s tmpUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(tmpCTPCPCode,"U"),""))
			continue:(tmpUserID="")
			s tmpUserCode = $p(^SSU("SSUSR",tmpUserID),"^",1)
			s tmpSSgroupID=$p(^SSU("SSUSR",tmpUserID),"^",5)
			continue:(tmpSSgroupID = "")
			
			s isExit=$d(^DHCEMRM.PowerUserI("UserIDIndex"," "_tmpUserID))
			if (isExit'=0)
			{
				s tmpPowerUserID=$o(^DHCEMRM.PowerUserI("UserIDIndex"," "_tmpUserID,""))
				s powerUserObj=##class(EMRmeta.PowerUser).%OpenId(tmpPowerUserID)
				
				if (powerUserObj.UserLevel'=userLevel)
				{
					s Info="医师"_tmpUserCode_"级别与HIS不符,由"_powerUserObj.UserLevel_"更新为"_userLevel
					s powerUserObj.UserLevel=userLevel
					s powerUserObj.SSGroupID=tmpSSgroupID
					s sc = powerUserObj.%Save()
					if ($$$ISERR(sc)) w !,Info,"失败"
					d powerUserObj.%Close()
					w !,Info
				
				}	
			}
			else 
			{
				s powerUserObj=##class(EMRmeta.PowerUser).%New()

				s Info="医师"_tmpUserCode_"EMR无数据,同步HIS数据级别为"_userLevel
				s powerUserObj.UserLevel=userLevel
				s powerUserObj.SSGroupID=tmpSSgroupID
				s powerUserObj.UserID=tmpUserID
				s sc = powerUserObj.%Save()
				if ($$$ISERR(sc)) w !,Info,"失败"
				d powerUserObj.%Close()
				w !,Info
				
			} 
		}
}

/// d ##Class(EMRservice.Tools.InitStandardDataTool).InitGlossaryCatDataForSP("D:\StandardData\41_GlossaryCategory.txt")
ClassMethod InitGlossaryCatDataForSP(argFile As %String)
{
	
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj=##Class(EPRmeta.GlossaryCategory).%New()
		
		s obj.Description=""
		s obj.InternalID = $p(sRec, $c(9) , 3)
		s obj.Name = $p(sRec, $c(9) , 4)
		s pInternalID=$p(obj.InternalID,".",1,$length(obj.InternalID,".")-1)
		s tmpParentID=$o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_pInternalID,""))
		s obj.ParentID = tmpParentID
		s obj.ResChildCount = ""
		s obj.TemplateCategroyID = ""
		
	
		s isOK = obj.%Save()
		d obj.%Close()
		s obj=""

        s totCount = totCount + 1		
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"SP_Summary: "_totCount_" okCount: "_okCount_" failCount: "_failCount
	quit
}

/// 南方医院依据就诊号，模板DocID取患者最后保存的文档实例ID
/// w ##class(EMRservice.Tools.DailyWorkTool).GetCusultIntanceIDByEpisodeID(1348,102)
ClassMethod GetCusultIntanceIDByEpisodeID(AEpisodeID As %String, ADocumentID As %String)
{
	s retInt=""
	s TheECRecord=""
	s TheECRecord=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_ADocumentID,TheECRecord))
	q:(TheECRecord="")
	s objECRecord=##class(EMRinstance.ECRecord).%OpenId(TheECRecord)
	s listnum=objECRecord.InstanceCount
	s subID=""
	for tmpnum=listnum:-1:1
	{
		s subID=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",TheECRecord," "_tmpnum,subID))
		q:(subID="")
		
		s InstanceID=TheECRecord_"||"_subID
		
		s objInt=##class(EMRinstance.InstanceData).%OpenId(InstanceID)
		s Status=objInt.Status
		continue:(Status'="Save")
		s retInt=InstanceID
		q:(retInt'="")
	}
	q retInt
}

/// d ##class(EMRservice.Tools.DailyWorkTool).DiagDataToUserTemplate()
ClassMethod DiagDataToUserTemplate()
{
	s tmpdiagnosID=""
	for
	{
		s tmpdiagnosID=$o(^DHCEMRM.DiagnosD(tmpdiagnosID))
		q:(tmpdiagnosID="")
		
		s diagnosObj=##class(EMRmeta.Diagnos).%OpenId(tmpdiagnosID)
		continue:(diagnosObj="")
		s diagnosCode=diagnosObj.DiagnosCode
		s userTemplateName=diagnosObj.DiagnosName
		
		s userTemplateCode=+$g(^DHCEMRM.UserTemplateD)+1
		//将病种数据转换为模板数据
		s userTemplateObj=##class(EMRmeta.UserTemplate).%New()
		s userTemplateObj.Name=userTemplateName
		s userTemplateObj.Code=userTemplateCode
		s userTemplateObj.CreateDate=+$h
		s userTemplateObj.Sequence=userTemplateCode
		s userTemplateObj.SimpleSpelName=diagnosCode
		s userTemplateObj.Status="1"
		s userTemplateObj.TemplateData=""
		s userTemplateObj.TemplateID=96
		s userTemplateObj.UserID="demo"
		//入院记录版本号
		s userTemplateObj.VersionNumber="38"
		d userTemplateObj.%Save()
		

		//--取科室配置信息
		s tmpDiagnosCTLocID=""
		for {
			s tmpDiagnosCTLocID=$o(^DHCEMRM.DiagnosCTLocI("IdxDiagnosCode"," "_$zcvt(diagnosCode,"U"),tmpDiagnosCTLocID))
			q:(tmpDiagnosCTLocID="")
			
			s diagnosCTLocObj=##class(EMRmeta.DiagnosCTLoc).%OpenId(tmpDiagnosCTLocID)
			continue:(diagnosCTLocObj="")
			s diagnosCTLocID=diagnosCTLocObj.CTLocID
			s diagnosCTLocName=diagnosCTLocObj.CTLocName

			s userTemplateCTLocObj=##class(EMRmeta.UserTemplateCTLoc).%New()
			s userTemplateCTLocObj.Code=userTemplateCode
			s userTemplateCTLocObj.CTLocID=diagnosCTLocID
			s userTemplateCTLocObj.CTLocName=diagnosCTLocName
			d userTemplateCTLocObj.%Save()
			d userTemplateCTLocObj.%Close()
			s userTemplateCTLocObj=""

		}
		
		s tmpDiagnoseKBNodeID=""
		for 
		{
			s tmpDiagnoseKBNodeID=$o(^DHCEMRM.DiagnosKBNodeI("IdxDiagnosCode"," "_$zcvt(diagnosCode,"U"),tmpDiagnoseKBNodeID))
			q:(tmpDiagnoseKBNodeID="")
			
			s diagnosKBNodeObj=##class(EMRmeta.DiagnosKBNode).%OpenId(tmpDiagnoseKBNodeID)
			continue:(diagnosKBNodeObj="")
			s diagnoseKBNodeID=diagnosKBNodeObj.KBNodeID
			s diagnosKBTreeID=diagnosKBNodeObj.KBTreeID
			s KBTreeObj=##class(EMRmeta.KBTree).%OpenId(diagnosKBTreeID)
			continue:(KBTreeObj="")
			s diagnosKBaseID=KBTreeObj.KnowledgeBaseID
			//入院记录章节对应关系
			//"94","S002"
			//"95","S003"
			//"96","S004"
			//"97","S005"
			//"98","S009"
			//"99","S010"
			//"100","S011"
			//"101","S013"
			//"102","S026"
			//"125","S008"
			s tmpSectionCode=$case(diagnosKBaseID,"94":"S002","95":"S003","96":"S004","97":"S005","98":"S009","99":"S010","100":"S011","101":"S013","102":"S026","125":"S008",:"out")
			//--
			continue:(tmpSectionCode="out") 
			s userTemplateKBNodeObj=##class(EMRmeta.UserTemplateKBNode).%New()
			s userTemplateKBNodeObj.ActiveFlag="1"
			s userTemplateKBNodeObj.Code=userTemplateCode
			s userTemplateKBNodeObj.CompositeCode=""
			s userTemplateKBNodeObj.KbBaseID=diagnosKBaseID
			s userTemplateKBNodeObj.KBNodeID=diagnoseKBNodeID
			s userTemplateKBNodeObj.SectionCode=tmpSectionCode
			s userTemplateKBNodeObj.Sequence=userTemplateKBNodeObj.%Id()
			
			d userTemplateKBNodeObj.%Save()
			

		}

		//入院记录，无标题	
		s userTemplateTitleObj=##class(EMRmeta.UserTemplateTitle).%New()
		s userTemplateTitleObj.Code=userTemplateCode
		s userTemplateTitleObj.TitleCode=""
		s userTemplateTitleObj.TitleName=""
		d userTemplateTitleObj.%Save()
		
		
	}
}

/// d ##class(EMRservice.Tools.DailyWorkTool).ModifyUserTemplateData()
ClassMethod ModifyUserTemplateData()
{
	s userTemplateTitleID="",tmpdiagnosID="424"
	for
	{
		s tmpdiagnosID=$o(^DHCEMRM.UserTemplateD(tmpdiagnosID))
		q:(tmpdiagnosID="")
		s userTemplateTitleID=$o(^DHCEMRM.UserTemplateTitleI("IdxCode"," "_tmpdiagnosID,""))
		continue:(userTemplateTitleID'="")
		//入院记录，无标题	
		s userTemplateTitleObj=##class(EMRmeta.UserTemplateTitle).%New()
		s userTemplateTitleObj.Code=tmpdiagnosID
		s userTemplateTitleObj.TitleCode=$c(0)
		s userTemplateTitleObj.TitleName=$c(0)
		d userTemplateTitleObj.%Save()
	}
}

/// d ##class(EMRservice.Tools.DailyWorkTool).ModifyUserTemplateTitleData()
ClassMethod ModifyUserTemplateTitleData()
{
	s userTemplateTitleID=""
	for
	{
		s userTemplateTitleID=$o(^DHCEMRM.UserTemplateTitleD(userTemplateTitleID),-1)
		q:(userTemplateTitleID=424)
		k ^DHCEMRM.UserTemplateTitleD(userTemplateTitleID)
		
	}
	s ^DHCEMRM.UserTemplateTitleD=424
	
	DO ##class(EMRmeta.UserTemplateTitle).%PurgeIndices()
	DO ##class(EMRmeta.UserTemplateTitle).%BuildIndices()
	
	DO ##class(EMRmeta.UserTemplate).%PurgeIndices()
	DO ##class(EMRmeta.UserTemplate).%BuildIndices()
}

/// 手术记录手术过程内容转为模板
/// d ##class(EMRservice.Tools.DailyWorkTool).KBDataToUserTemplate(117)
ClassMethod KBDataToUserTemplate(AKnowledgeBaseID As %String)
{
	s tmpKBNodeID=""
	for
	{
		s tmpKBNodeID=$o(^DHCEMRM.KBNodeI("IdxKBKnowledgeBaseID"," "_AKnowledgeBaseID,tmpKBNodeID))
		q:(tmpKBNodeID="")
		
		s objKBNode=##class(EMRmeta.KBNode).%OpenId(tmpKBNodeID)
		continue:(objKBNode="")
		
		s kbTreeID =objKBNode.KBTreeID
		s kbNodeName=objKBNode.Name
		s kbNodeID=objKBNode.%Id()
		
		s objKBTree=##class(EMRmeta.KBTree).%OpenId(kbTreeID)
		continue:(objKBTree="")
		s kbTreeName=objKBTree.Name
		s kbTreeParentID=objKBTree.ParentID
		
		//取科室信息
		s kbTreeLocIDTitleInfo=..GetLocIDTitleCodeNameByKBNode(kbTreeID)
		s kbTreeLocID=$p(kbTreeLocIDTitleInfo,"^",1)
		s kbTreeTitleName=$p(kbTreeLocIDTitleInfo,"^",2)
		s kbTreeTitleCode=$p(kbTreeLocIDTitleInfo,"^",3)
		
		//--
		s userTemplateName=$case(kbTreeParentID,0:kbTreeName_"_"_kbNodeName,:kbNodeName)
		
		s userTemplateCode=+$g(^DHCEMRM.UserTemplateD)+1
		
		//将病种数据转换为模板数据
		s userTemplateObj=##class(EMRmeta.UserTemplate).%New()
		s userTemplateObj.Name=userTemplateName
		s userTemplateObj.Code=userTemplateCode
		s userTemplateObj.CreateDate=+$h
		s userTemplateObj.Sequence=userTemplateCode
		s userTemplateObj.SimpleSpelName=##class(ext.util.String).ToChineseSpell(userTemplateName)
		s userTemplateObj.Status="1"
		s userTemplateObj.TemplateData=""
		s userTemplateObj.TemplateID="107"
		s userTemplateObj.UserID="demo"
		//入院记录版本号
		s userTemplateObj.VersionNumber="4"
		d userTemplateObj.%Save()
		

		//--取科室配置信息
		
		for i=1:1:$l(kbTreeLocID,"$")
		{
			s tmpLocID=$p(kbTreeLocID,"$",i)
			q:(tmpLocID="")
			
			s CTLocName=$p(^CTLOC(tmpLocID),"^",2)

			s userTemplateCTLocObj=##class(EMRmeta.UserTemplateCTLoc).%New()
			s userTemplateCTLocObj.Code=userTemplateCode
			s userTemplateCTLocObj.CTLocID=tmpLocID
			s userTemplateCTLocObj.CTLocName=CTLocName
			d userTemplateCTLocObj.%Save()
			d userTemplateCTLocObj.%Close()
			s userTemplateCTLocObj=""

		}
		
		s tmpSectionCode=$case(AKnowledgeBaseID,"117":"S008",:"out")
		
		continue:(tmpSectionCode="out") 
		s userTemplateKBNodeObj=##class(EMRmeta.UserTemplateKBNode).%New()
		s userTemplateKBNodeObj.ActiveFlag="1"
		s userTemplateKBNodeObj.Code=userTemplateCode
		s userTemplateKBNodeObj.CompositeCode=""
		s userTemplateKBNodeObj.KbBaseID=AKnowledgeBaseID
		s userTemplateKBNodeObj.KBNodeID=tmpKBNodeID
		s userTemplateKBNodeObj.SectionCode=tmpSectionCode
		s userTemplateKBNodeObj.Sequence="1"	
		d userTemplateKBNodeObj.%Save()
			



		//手术记录	
		s userTemplateTitleObj=##class(EMRmeta.UserTemplateTitle).%New()
		s userTemplateTitleObj.Code=userTemplateCode
		s userTemplateTitleObj.TitleCode=kbTreeTitleName
		s userTemplateTitleObj.TitleName=kbTreeTitleCode
		d userTemplateTitleObj.%Save()
		
		
	}
}

/// w ##class(EMRservice.Tools.DailyWorkTool).GetLocIDTitleCodeNameByKBNode(985)
/// w ##class(EMRservice.Tools.DailyWorkTool).GetLocIDTitleCodeNameByKBNode(1387)
ClassMethod GetLocIDTitleCodeNameByKBNode(KBTreeID As %String) As %String
{
	
	s (CTLocID,TitleName,titleCode)=""
	s CTLocID=..GetKBTreeLocID(KBTreeID)
	
	s titleCodeL=""
	//取KBTree的Title信息
	s titleCodeL=$o(^DHCEMRM.KBTreeTitlesRuleI("IdxIDCode"," "_KBTreeID,titleCodeL))
	
	s titleCode=$e(titleCodeL,2,*)
	
	s titleID=""
	s titleID=$o(^DHCEMRM.TitlesI("IdxCode"," "_titleCode,titleID))
	
	if (titleID'="") {
		s objTitles=##class(EMRmeta.Titles).%OpenId(titleID)
		
		s titleName=objTitles.Description
	}
	s:(TitleName="") TitleName=$c(0)
	s:(titleCode="") titleCode=$c(0)
	q CTLocID_"^"_TitleName_"^"_titleCode
}

/// w ##class(EMRservice.Tools.DailyWorkTool).GetKBTreeLocID(985)
/// w ##class(EMRservice.Tools.DailyWorkTool).GetKBTreeLocID(1387)
ClassMethod GetKBTreeLocID(KBTreeID) As %String
{
	s kbTreeLocIDL="",result=""
	s objKBTree=##class(EMRmeta.KBTree).%OpenId(KBTreeID)
	s kbTreeParentID=objKBTree.ParentID
	for {
		s kbTreeLocIDL=$o(^DHCEMRM.KBTreeCTLocI("IdxKBTreeCTLocID"," "_KBTreeID,kbTreeLocIDL))
		q:(kbTreeLocIDL="")
		s kbTreeLocID=$e(kbTreeLocIDL,2,*)
		
		s:(result'="") result=result_"$"_kbTreeLocID
		s:(result="") result=kbTreeLocID
	
	}
	q:(kbTreeParentID=0) result
	q ..GetKBTreeLocID(kbTreeParentID)
}

/// /////迁移出院小结////////////////////////////////////////////////////////////////////////////////////////
/// 出院小结第一步创建模板
/// d ##class(EMRservice.Tools.DailyWorkTool).KBDataToUserTemplateDischR(112)
ClassMethod KBDataToUserTemplateDischR(AKnowledgeBaseID As %String)
{
	s tmpKBNodeID=""
	for
	{
		s tmpKBNodeID=$o(^DHCEMRM.KBNodeI("IdxKBKnowledgeBaseID"," "_AKnowledgeBaseID,tmpKBNodeID))
		q:(tmpKBNodeID="")
		
		s objKBNode=##class(EMRmeta.KBNode).%OpenId(tmpKBNodeID)
		continue:(objKBNode="")
		
		s kbTreeID =objKBNode.KBTreeID
		s kbNodeName=objKBNode.Name
		s kbNodeID=objKBNode.%Id()
		
		s objKBTree=##class(EMRmeta.KBTree).%OpenId(kbTreeID)
		continue:(objKBTree="")
		s kbTreeName=objKBTree.Name
		s kbTreeParentID=objKBTree.ParentID
		
		//取科室信息
		s kbTreeLocIDTitleInfo=..GetLocIDTitleCodeNameByKBNode(kbTreeID)
		s kbTreeLocID=$s($p(kbTreeLocIDTitleInfo,"^",1)="":"99999",1:$p(kbTreeLocIDTitleInfo,"^",1))
		s kbTreeTitleName=$p(kbTreeLocIDTitleInfo,"^",2)
		s kbTreeTitleCode=$p(kbTreeLocIDTitleInfo,"^",3)
		
		//--
		s userTemplateName=$case(kbTreeParentID,0:kbTreeName_"_"_kbNodeName,:kbNodeName)
		
		s userTemplateCode=+$g(^DHCEMRM.UserTemplateD)+1
		
		//将病种数据转换为模板数据
		s userTemplateObj=##class(EMRmeta.UserTemplate).%New()
		s userTemplateObj.Name=userTemplateName
		s userTemplateObj.Code=userTemplateCode
		s userTemplateObj.CreateDate=+$h
		s userTemplateObj.Sequence=userTemplateCode
		s userTemplateObj.SimpleSpelName=##class(ext.util.String).ToChineseSpell(userTemplateName)
		s userTemplateObj.Status="1"
		s userTemplateObj.TemplateData=""
		s userTemplateObj.TemplateID="104"
		s userTemplateObj.UserID="demo"
		//入院记录版本号
		s userTemplateObj.VersionNumber="17"
		d userTemplateObj.%Save()
		

		//--取科室配置信息
		
		for i=1:1:$l(kbTreeLocID,"$")
		{
			s tmpLocID=$p(kbTreeLocID,"$",i)
			q:(tmpLocID="")
			s:(tmpLocID=99999) CTLocName="待配置科室"
			s:(tmpLocID'=99999) CTLocName=$p(^CTLOC(tmpLocID),"^",2)

			s userTemplateCTLocObj=##class(EMRmeta.UserTemplateCTLoc).%New()
			s userTemplateCTLocObj.Code=userTemplateCode
			s userTemplateCTLocObj.CTLocID=tmpLocID
			s userTemplateCTLocObj.CTLocName=CTLocName
			d userTemplateCTLocObj.%Save()
			d userTemplateCTLocObj.%Close()
			s userTemplateCTLocObj=""

		}
		
		s tmpSectionCode=$case(AKnowledgeBaseID,"112":"S003",:"out")
		
		continue:(tmpSectionCode="out") 
		s userTemplateKBNodeObj=##class(EMRmeta.UserTemplateKBNode).%New()
		s userTemplateKBNodeObj.ActiveFlag="1"
		s userTemplateKBNodeObj.Code=userTemplateCode
		s userTemplateKBNodeObj.CompositeCode=""
		s userTemplateKBNodeObj.KbBaseID=AKnowledgeBaseID
		s userTemplateKBNodeObj.KBNodeID=tmpKBNodeID
		s userTemplateKBNodeObj.SectionCode=tmpSectionCode
		s userTemplateKBNodeObj.Sequence="1"	
		d userTemplateKBNodeObj.%Save()
			



		//手术记录	
		s userTemplateTitleObj=##class(EMRmeta.UserTemplateTitle).%New()
		s userTemplateTitleObj.Code=userTemplateCode
		s userTemplateTitleObj.TitleCode=kbTreeTitleName
		s userTemplateTitleObj.TitleName=kbTreeTitleCode
		d userTemplateTitleObj.%Save()
		
		
	}
}

/// 出院小结第二步，同名知识库关联已有模板
/// d ##class(EMRservice.Tools.DailyWorkTool).KBDataToUserTemplateDischRStep2(113)
/// d ##class(EMRservice.Tools.DailyWorkTool).KBDataToUserTemplateDischRStep2(114)
/// d ##class(EMRservice.Tools.DailyWorkTool).KBDataToUserTemplateDischRStep2(115)
/// d ##class(EMRservice.Tools.DailyWorkTool).KBDataToUserTemplateDischRStep2(119)
ClassMethod KBDataToUserTemplateDischRStep2(AKnowledgeBaseID As %String)
{
	s tmpKBNodeID=""
	for
	{
		s tmpKBNodeID=$o(^DHCEMRM.KBNodeI("IdxKBKnowledgeBaseID"," "_AKnowledgeBaseID,tmpKBNodeID))
		q:(tmpKBNodeID="")
		
		s objKBNode=##class(EMRmeta.KBNode).%OpenId(tmpKBNodeID)
		continue:(objKBNode="")
		
		s kbTreeID =objKBNode.KBTreeID
		s kbNodeName=objKBNode.Name
		s kbNodeID=objKBNode.%Id()
		
		s objKBTree=##class(EMRmeta.KBTree).%OpenId(kbTreeID)
		continue:(objKBTree="")
		s kbTreeName=objKBTree.Name
		s kbTreeParentID=objKBTree.ParentID
		
		//取科室信息
		s kbTreeLocIDTitleInfo=..GetLocIDTitleCodeNameByKBNode(kbTreeID)
		s kbTreeLocID=$s($p(kbTreeLocIDTitleInfo,"^",1)="":"99999",1:$p(kbTreeLocIDTitleInfo,"^",1))
		s kbTreeTitleName=$p(kbTreeLocIDTitleInfo,"^",2)
		s kbTreeTitleCode=$p(kbTreeLocIDTitleInfo,"^",3)
		
		//--
		s userTemplateName=$case(kbTreeParentID,0:kbTreeName_"_"_kbNodeName,:kbNodeName)
		
		
		

		s SimpleSpelName=##class(ext.util.String).ToChineseSpell(userTemplateName)
		
		s userTemplateCode=$o(^DHCEMRM.UserTemplateI("IdxSimpleSpelName"," "_SimpleSpelName,""))
		

		//--取科室配置信息
		
		for i=1:1:$l(kbTreeLocID,"$")
		{
			s tmpLocID=$p(kbTreeLocID,"$",i)
			q:(tmpLocID="")
			s:(tmpLocID=99999) CTLocName="待配置科室"
			s:(tmpLocID'=99999) CTLocName=$p(^CTLOC(tmpLocID),"^",2)

			s userTemplateCTLocObj=##class(EMRmeta.UserTemplateCTLoc).%New()
			s userTemplateCTLocObj.Code=userTemplateCode
			s userTemplateCTLocObj.CTLocID=tmpLocID
			s userTemplateCTLocObj.CTLocName=CTLocName
			d userTemplateCTLocObj.%Save()
			d userTemplateCTLocObj.%Close()
			s userTemplateCTLocObj=""

		}
		
		s tmpSectionCode=$case(AKnowledgeBaseID,"113":"S005","114":"S007","115":"S015","119":"S008",:"out")
		
		continue:(tmpSectionCode="out") 
		s userTemplateKBNodeObj=##class(EMRmeta.UserTemplateKBNode).%New()
		s userTemplateKBNodeObj.ActiveFlag="1"
		s userTemplateKBNodeObj.Code=userTemplateCode
		s userTemplateKBNodeObj.CompositeCode=""
		s userTemplateKBNodeObj.KbBaseID=AKnowledgeBaseID
		s userTemplateKBNodeObj.KBNodeID=tmpKBNodeID
		s userTemplateKBNodeObj.SectionCode=tmpSectionCode
		s userTemplateKBNodeObj.Sequence="1"	
		d userTemplateKBNodeObj.%Save()	
		
	}
}

/// 病程记录，知识库迁移。
/// 手术记录手术过程内容转为模板
/// d ##class(EMRservice.Tools.DailyWorkTool).KBDataToUserTemplateDailyRecord(107)
ClassMethod KBDataToUserTemplateDailyRecord(AKnowledgeBaseID As %String)
{
	s count=0
	s tmpKBNodeID=""
	for
	{
		s tmpKBNodeID=$o(^DHCEMRM.KBNodeI("IdxKBKnowledgeBaseID"," "_AKnowledgeBaseID,tmpKBNodeID))
		q:(tmpKBNodeID="")
		s count=count+1
		s objKBNode=##class(EMRmeta.KBNode).%OpenId(tmpKBNodeID)
		continue:(objKBNode="")
		
		s kbTreeID =objKBNode.KBTreeID
		s kbNodeName=objKBNode.Name
		s kbNodeID=objKBNode.%Id()
		
		s objKBTree=##class(EMRmeta.KBTree).%OpenId(kbTreeID)
		continue:(objKBTree="")
		s kbTreeName=objKBTree.Name
		s kbTreeParentID=objKBTree.ParentID
		
		//取科室信息
		s kbTreeLocIDTitleInfo=..GetLocIDTitleCodeNameByKBNode(kbTreeID)
		s kbTreeLocID=$p(kbTreeLocIDTitleInfo,"^",1)
		s kbTreeTitleName=$p(kbTreeLocIDTitleInfo,"^",2)
		s kbTreeTitleCode=$p(kbTreeLocIDTitleInfo,"^",3)
		
		//--
		s userTemplateName=$case(kbTreeParentID,0:kbTreeName_"_"_kbNodeName,:kbNodeName)
		
		s userTemplateCode=+$g(^DHCEMRM.UserTemplateD)+1
		
		//将病种数据转换为模板数据
		s userTemplateObj=##class(EMRmeta.UserTemplate).%New()
		s userTemplateObj.Name=userTemplateName
		s userTemplateObj.Code=userTemplateCode
		s userTemplateObj.CreateDate=+$h
		s userTemplateObj.Sequence=userTemplateCode
		s userTemplateObj.SimpleSpelName=##class(ext.util.String).ToChineseSpell(userTemplateName)
		s userTemplateObj.Status="1"
		s userTemplateObj.TemplateData=""
		s userTemplateObj.TemplateID="103"
		s userTemplateObj.UserID="demo"
		//入院记录版本号
		s userTemplateObj.VersionNumber="5"
		d userTemplateObj.%Save()
		
		w !,count

		//--取科室配置信息
		
		for i=1:1:$l(kbTreeLocID,"$")
		{
			s tmpLocID=$p(kbTreeLocID,"$",i)
			q:(tmpLocID="")
			
			s CTLocName=$p(^CTLOC(tmpLocID),"^",2)

			s userTemplateCTLocObj=##class(EMRmeta.UserTemplateCTLoc).%New()
			s userTemplateCTLocObj.Code=userTemplateCode
			s userTemplateCTLocObj.CTLocID=tmpLocID
			s userTemplateCTLocObj.CTLocName=CTLocName
			d userTemplateCTLocObj.%Save()
			d userTemplateCTLocObj.%Close()
			s userTemplateCTLocObj=""

		}
		
		s tmpSectionCode=$case(AKnowledgeBaseID,"107":"S001",:"out")
		
		continue:(tmpSectionCode="out") 
		s userTemplateKBNodeObj=##class(EMRmeta.UserTemplateKBNode).%New()
		s userTemplateKBNodeObj.ActiveFlag="1"
		s userTemplateKBNodeObj.Code=userTemplateCode
		s userTemplateKBNodeObj.CompositeCode=""
		s userTemplateKBNodeObj.KbBaseID=AKnowledgeBaseID
		s userTemplateKBNodeObj.KBNodeID=tmpKBNodeID
		s userTemplateKBNodeObj.SectionCode=tmpSectionCode
		s userTemplateKBNodeObj.Sequence="1"	
		d userTemplateKBNodeObj.%Save()
			



		//病程记录	
		s userTemplateTitleObj=##class(EMRmeta.UserTemplateTitle).%New()
		s userTemplateTitleObj.Code=userTemplateCode
		s userTemplateTitleObj.TitleCode=kbTreeTitleCode
		s userTemplateTitleObj.TitleName=kbTreeTitleName
		d userTemplateTitleObj.%Save()
		
		
	}
}

/// d ##class(EMRservice.Tools.DailyWorkTool).ModifyUserTemplateTitleDataNew()
ClassMethod ModifyUserTemplateTitleDataNew()
{
	s tmpID=""
	for 
	{
		
		s tmpID=$o(^DHCEMRM.UserTemplateTitleD(tmpID))
		q:(tmpID="")
		
		s objUserTemplateTitle=##class(EMRmeta.UserTemplateTitle).%OpenId(tmpID)
		s title=objUserTemplateTitle.TitleName
		s titleCode=objUserTemplateTitle.TitleCode
		
		continue:((title=$c(0))&&(titleCode=$c(0)))
		
		if ((titleCode=$c(0))&&(title'=""))
		{
			s tmpTitleID=$o(^DHCEMRM.TitlesI("IdxCode"," "_title,""))
			s objTitles=##class(EMRmeta.Titles).%OpenId(tmpTitleID)
			s objUserTemplateTitle.TitleName=objTitles.Description
			s objUserTemplateTitle.TitleCode=objTitles.Code
			
			d objUserTemplateTitle.%Save()
			s objUserTemplateTitle=""
		}
		
		
	}
}

/// d ##class(EMRservice.Tools.DailyWorkTool).GetALLEMRCLS("D:\EMRCacheCode")
ClassMethod GetALLEMRCLS(Afilepaht As %String = "D:\EMRCacheCode")
{
	
	
	//s ListEMR=$lb("EMRinstance","EMRmeta","EMRservice","EMRview","EPRinstance","EPRmeta","EPRservice","EPRview")
	s ListEMR=$lb("EMRinstance","EMRmeta","EMRservice","EPRinstance","EPRmeta","EPRservice")
	
	for i=1:1:$ll(ListEMR)
	{
		s packageName=$list(ListEMR,i)
		s tmpfilepath=Afilepaht_"\"_packageName
		s isExt=##Class(%Library.File).DirectoryExists(tmpfilepath)
		if ('isExt){
			w ##Class(%Library.File).CreateDirectoryChain(tmpfilepath)
			
			}
		Do $system.OBJ.ExportAllClassesIndividual(tmpfilepath,,,,packageName)
	}
}

/// d ##class(EMRservice.Tools.DailyWorkTool).OneStepUpdateSysOption()
ClassMethod OneStepUpdateSysOption() As %String
{
	//---系统参数更新
	
	//--update 18 
	//1 ResourceTabScheme
	&sql(update EMRmeta.SysOption Set OptionValue="<resource><item><id>Order</id><title>医嘱</title><source>emr.resource.medorder.csp</source><width>600</width></item><item><id>zorders</id><title>中草药</title><source>emr.resource.zorders.csp</source><width>600</width></item><item><id>Pacs</id><title>检查</title><source>emr.resource.pacsdata.csp</source><width>600</width></item><item><id>Lis</id><title>检验</title><source>emr.resource.lisdata.csp</source><width>700</width></item><item><id>vitalsigns</id><title>生命体征</title><source>emr.resource.vitalsigns.csp</source><width>700</width></item><item><id>diagnos</id><title>诊断</title><source>emr.resource.diagnos.csp</source><width>600</width></item><item><id>pathology</id><title>病理</title><source>emr.resource.pathology.csp</source><width>600</width></item><item><id>consult</id><title>会诊</title><source>emr.resource.consult.csp</source><width>600</width></item></resource>" where Name="ResourceTabScheme")

	//2 OrderScheme
	&sql(update EMRmeta.SysOption Set OptionValue="<scheme><show><parent><item><code>OrdCreateDate</code><desc>医嘱日期</desc><hidden>N</hidden><width>100</width><sortable>Y</sortable></item><item><code>OrdCreateTime</code><desc>医嘱时间</desc><hidden>N</hidden><width>100</width><sortable>Y</sortable></item><item><code>ArcimDesc</code><desc>医嘱名称</desc><hidden>N</hidden></item><item><code>DoseQty</code><desc>剂量</desc><hidden>N</hidden></item><item><code>DoseUnit</code><desc>剂量单位</desc><hidden>N</hidden></item><item><code>Instr</code><desc>服用方法</desc><hidden>N</hidden></item><item><code>PHFreq</code><desc>频率</desc><hidden>N</hidden></item><item><code>OrdXDate</code><desc>OrdXDate</desc><hidden>N</hidden></item><item><code>OrdDepProcNotes</code><desc>OrdDepProcNotes</desc><hidden>Y</hidden></item></parent><child><item><code>ArcimDesc</code><desc>医嘱名称</desc><hidden>N</hidden><width>220</width></item><item><code>DoseQty</code><desc>剂量</desc><hidden>N</hidden></item><item><code>DoseUnit</code><desc>剂量单位</desc><hidden>N</hidden></item></child></show><reference><norders><parent><item><code>OrdCreateDate</code><desc></desc><separate>blackspace</separate></item><item><code>OrdCreateTime</code><desc></desc><separate>blackspace</separate></item><item><code>ArcimDesc</code><desc></desc><separate>blackspace</separate></item><item><code>Instr</code><desc></desc><separate>blackspace</separate></item><item><code>PHFreq</code><desc></desc><separate>blackspace</separate></item><item><code>DoseQty</code><desc></desc><separate>blackspace</separate></item><item><code>DoseUnit</code><desc></desc><separate>blackspace</separate></item></parent><child><item><code>ArcimDesc</code><desc></desc><separate>blackspace</separate></item><item><code>DoseQty</code><desc></desc><separate>blackspace</separate></item><item><code>DoseUnit</code><desc></desc><separate>blackspace</separate></item></child><separate>enter</separate><seq>parent</seq></norders><sorders><parent><item><code>OrdCreateDate</code><desc></desc><separate>blackspace</separate></item><item><code>OrdCreateTime</code><desc></desc><separate>blackspace</separate></item><item><code>ArcimDesc</code><desc></desc><separate>blackspace</separate></item><item><code>Instr</code><desc></desc><separate>blackspace</separate></item><item><code>PHFreq</code><desc></desc><separate>blackspace</separate></item><item><code>DoseQty</code><desc></desc><separate>blackspace</separate></item><item><code>DoseUnit</code><desc></desc><separate>blackspace</separate></item></parent><child><item><code>ArcimDesc</code><desc></desc><separate>blackspace</separate></item><item><code>DoseQty</code><desc></desc><separate>blackspace</separate></item><item><code>DoseUnit</code><desc></desc><separate>blackspace</separate></item></child><separate>enter</separate><seq>parent</seq></sorders><oorders><parent><item><code>OrdCreateDate</code><desc></desc><separate>blackspace</separate></item><item><code>OrdCreateTime</code><desc></desc><separate>blackspace</separate></item><item><code>ArcimDesc</code><desc></desc><separate>blackspace</separate></item><item><code>Instr</code><desc></desc><separate>blackspace</separate></item><item><code>PHFreq</code><desc></desc><separate>blackspace</separate></item><item><code>DoseQty</code><desc></desc><separate>blackspace</separate></item><item><code>DoseUnit</code><desc></desc><separate>blackspace</separate></item></parent><child><item><code>ArcimDesc</code><desc></desc><separate>blackspace</separate></item><item><code>DoseQty</code><desc></desc><separate>blackspace</separate></item><item><code>DoseUnit</code><desc></desc><separate>blackspace</separate></item></child><separate>enter</separate></oorders></reference><display>Y</display><interface>HIS</interface></scheme>" where Name="OrderScheme")

	//3 LisScheme
	&sql(update EMRmeta.SysOption Set OptionValue="<scheme><show><parent><item><code>OEordItemRowID</code><desc>OEordItemRowID</desc><hidden>Y</hidden></item><item><code>ReceiveDate</code><desc>送检日期</desc><hidden>N</hidden></item><item><code>ReceiveTime</code><desc>送检时间</desc><hidden>N</hidden></item><item><code>OEordItemDesc</code><desc>医嘱名称</desc><hidden>N</hidden></item><item><code>SpecimenDesc</code><desc>标本类型</desc><hidden>N</hidden></item><item><code>LabEpisodeNo</code><desc>标本号</desc><hidden>N</hidden></item><item><code>AuthorisationDate</code><desc>审核日期</desc><hidden>N</hidden></item><item><code>AuthorisationTime</code><desc>审核时间</desc><hidden>N</hidden></item><item><code>EpisodeDate</code><desc>就诊日期</desc><hidden>N</hidden></item><item><code>DeptDesc</code><desc>就诊科室</desc><hidden>N</hidden></item><item><code>CollectionDate</code><desc>采集日期</desc><hidden>Y</hidden></item><item><code>CollectionTime</code><desc>采集时间</desc><hidden>Y</hidden></item><item><code>ExistReport</code><desc>返回报告</desc><hidden>N</hidden></item></parent><child><item><code>OeordID</code><desc>OeordID</desc><hidden>Y</hidden></item><item><code>ItemDesc</code><desc>描述</desc><hidden>N</hidden></item><item><code>Synonym</code><desc>缩写</desc><hidden>N</hidden></item><item><code>ItemResult</code><desc>结果</desc><hidden>N</hidden></item><item><code>ItemUnit</code><desc>单位</desc><hidden>N</hidden></item><item><code>AbnorFlag</code><desc>异常提示</desc><hidden>N</hidden></item><item><code>ItemRanges</code><desc>范围值</desc><hidden>N</hidden></item></child></show><reference><parent><item><code>AuthorisationDate</code><desc/><separate>blackspace</separate></item><item><code>OEordItemDesc</code><desc/><separate>:</separate></item></parent><child><item><code>Synonym</code><desc/><separate>blackspace</separate></item><item><code>ItemResult</code><desc/><separate/></item><item><code>ItemUnit</code><desc/><separate>,</separate></item></child><separate>enter</separate></reference><checkstyle></checkstyle><pageConfig></pageConfig><interface>HIS</interface></scheme>" where Name="LisScheme")

	
	//4 PacsScheme
	&sql(update EMRmeta.SysOption Set OptionValue="<scheme><show><parent><item><code>OrdCreateDate</code><desc>医嘱日期</desc><hidden>N</hidden></item><item><code>OrdCreateTime</code><desc>医嘱时间</desc><hidden>N</hidden></item><item><code>ItemName</code><desc>医嘱名称</desc><hidden>N</hidden></item><item><code>OEOrdItemDR</code><desc>OEOrdItemDR</desc><hidden>Y</hidden></item><item><code>RptRowID</code><desc>RptRowID</desc><hidden>Y</hidden></item><item><code>RrtDate</code><desc>报告日期</desc><hidden>N</hidden></item><item><code>RrtTime</code><desc>报告时间</desc><hidden>N</hidden></item><item><code>EpisodeDate</code><desc>就诊日期</desc><hidden>N</hidden></item><item><code>DeptDesc</code><desc>就诊科室</desc><hidden>N</hidden></item></parent><child><item><code>OEItemRowID</code><desc>OEItemRowID</desc><hidden>Y</hidden></item><item><code>ExamDesc</code><desc>检查所见:</desc><hidden>N</hidden></item><item><code>strResult</code><desc>诊断意见:</desc><hidden>N</hidden></item><item><code>strOrderName</code><desc>检查方法:</desc><hidden>N</hidden></item></child></show><reference><parent><item><code>RrtDate</code><desc></desc><separate>blackspace</separate></item><item><code>ItemName</code><desc></desc><separate>blackspace</separate></item></parent><child><item><code>ExamDesc</code><desc></desc><separate>blackspace</separate></item><item><code>strResult</code><desc></desc><separate>blackspace</separate></item><item><code>strOrderName</code><desc></desc><separate>enter</separate></item></child><separate>enter</separate></reference><pageConfig></pageConfig><interface>HIS</interface></scheme>" where Name="PacsScheme")
	
	//5 VitalsignsScheme
	&sql(update EMRmeta.SysOption Set OptionValue="<scheme><show><item><code>WriteDate</code><desc>采集时间</desc><hidden>N</hidden></item><item><code>TEMPERATURE</code><desc>体温</desc><hidden>N</hidden><width>100</width><sortable>Y</sortable></item><item><code>PULSE</code><desc>脉搏</desc><hidden>N</hidden><width>100</width><sortable>Y</sortable></item><item><code>BREATH</code><desc>呼吸</desc><hidden>N</hidden><width>100</width><sortable>Y</sortable></item><item><code>SYSPRESSURE</code><desc>收缩压</desc><hidden>N</hidden><width>100</width><sortable>Y</sortable></item><item><code>DIAPRESSURE</code><desc>舒张压</desc><hidden>N</hidden><width>100</width><sortable>Y</sortable></item><item><code>EpisodeDate</code><desc>就诊时间</desc><hidden>N</hidden></item><item><code>DeptDesc</code><desc>就诊科室</desc><hidden>N</hidden></item></show><reference><items><item><code>TEMPERATURE</code><desc>体温:</desc><separate>℃,</separate></item><item><code>PULSE</code><desc>脉搏:</desc><separate>次/分,</separate></item><item><code>BREATH</code><desc>呼吸:</desc><separate>次/分,</separate></item><item><code>SYSPRESSURE</code><desc>血压:</desc><separate>/</separate></item><item><code>DIAPRESSURE</code><desc></desc><separate>mmHg</separate></item></items><separate>enter</separate></reference><interface>HIS</interface></scheme>" where Name="VitalsignsScheme")
	
	//6 DiagnosScheme
	&sql(update EMRmeta.SysOption Set OptionValue="<scheme><show><item><code>ARowID</code><desc>诊断ID</desc><hidden>Y</hidden></item><item><code>ADiagnosName</code><desc>诊断名称</desc><hidden>N</hidden></item><item><code>ADiagnosType</code><desc>诊断类型</desc><hidden>N</hidden></item><item><code>AEvaluationDesc</code><desc>状态名称</desc><hidden>N</hidden><sortable>N</sortable></item><item><code>AICDCode</code><desc>诊断代码</desc><hidden>N</hidden></item><item><code>AEffectsDesc</code><desc>转归名称</desc><hidden>Y</hidden></item><item><code>AUserName</code><desc>医生</desc><hidden>N</hidden></item><item><code>ADateTime</code><desc>时间</desc><hidden>N</hidden><sortable>N</sortable></item><item><code>ADemo</code><desc>备注</desc><hidden>N</hidden></item><item><code>ALevel</code><desc>级别</desc><hidden>Y</hidden></item></show><reference><items><item><code>ADiagnosName</code><desc></desc><separate></separate></item></items><separate><layermode>enter</layermode><rowmode>,</rowmode></separate></reference><interface>HIS</interface></scheme>" where Name="DiagnosScheme")
	
	//7 KBNodeEdit
	&sql(update EMRmeta.SysOption Set OptionValue="Y" where Name="KBNodeEdit")
	
	//8 ENABLE_PASTE_LIMIT
	&sql(update EMRmeta.SysOption Set OptionValue="Y" where Name="ENABLE_PASTE_LIMIT")
	
	//9 COLOR_ELEMENT_CHOICE
	&sql(update EMRmeta.SysOption Set OptionValue="#FF00FF" where Name="COLOR_ELEMENT_CHOICE")
	
	//10 CriticallyOrdRowIDStr
	&sql(update EMRmeta.SysOption Set OptionValue="<CriticallyOrd><CriticallyOrdInfo><OrdRowID>14504||1</OrdRowID><OrdDesc>病危</OrdDesc></CriticallyOrdInfo><CriticallyOrdInfo><OrdRowID>14503||1</OrdRowID><OrdDesc>病重</OrdDesc></CriticallyOrdInfo></CriticallyOrd>" where Name="CriticallyOrdRowIDStr")
	
	
	//11 PatListTemplateIDStr
	&sql(update EMRmeta.SysOption Set OptionValue="<TemplateInfo><Type><TypeCode>OutPat</TypeCode><TypeDesc>出院患者</TypeDesc><Template><ID>95</ID><Code>HomePage</Code><Desc>病案首页</Desc><TitleCode>null</TitleCode></Template></Type><Type><TypeCode>OutPat</TypeCode><TypeDesc>出院患者</TypeDesc><Template><ID>90</ID><Code>HomePage</Code><Desc>中医病案首页</Desc><TitleCode>null</TitleCode></Template></Type><Type><TypeCode>TransPat</TypeCode><TypeDesc>转出患者</TypeDesc><Template><ID>103</ID><Code>Transfer</Code><Desc>转出记录</Desc><TitleCode>134</TitleCode></Template></Type><Type><TypeCode>TransPat</TypeCode><TypeDesc>转出患者</TypeDesc><Template><ID>91</ID><Code>Transfer</Code><Desc>旧版转出记录</Desc><TitleCode>7</TitleCode></Template></Type><Type><TypeCode>OperationPat</TypeCode><TypeDesc>手术患者</TypeDesc><Template><ID>107</ID><Code>Operation</Code><Desc>手术记录</Desc><TitleCode>null</TitleCode></Template></Type><Type><TypeCode>OperationPat</TypeCode><TypeDesc>手术患者</TypeDesc><Template><ID>93</ID><Code>Operation</Code><Desc>旧版手术记录</Desc><TitleCode>null</TitleCode></Template></Type><Type><TypeCode>OperationPat</TypeCode><TypeDesc>手术患者</TypeDesc><Template><ID>103</ID><Code>BeforeOperation</Code><Desc>术前讨论记录</Desc><TitleCode>1044</TitleCode></Template></Type><Type><TypeCode>OperationPat</TypeCode><TypeDesc>手术患者</TypeDesc><Template><ID>92</ID><Code>BeforeOperation</Code><Desc>旧版术前讨论记录</Desc><TitleCode>null</TitleCode></Template></Type><Type><TypeCode>OperationPat</TypeCode><TypeDesc>手术患者</TypeDesc><Template><ID>103</ID><Code>AfterOperation</Code><Desc>术后首程</Desc><TitleCode>1071</TitleCode></Template></Type><Type><TypeCode>OperationPat</TypeCode><TypeDesc>手术患者</TypeDesc><Template><ID>94</ID><Code>AfterOperation</Code><Desc>旧版术后首程</Desc><TitleCode>15</TitleCode></Template></Type></TemplateInfo>" where Name="PatListTemplateIDStr")
	
	
	//12 AuthorizationSSGroupID
	&sql(update EMRmeta.SysOption Set OptionValue="30^68^118" where Name="AuthorizationSSGroupID")
	
	//13 OPEmrButtons
	&sql(update EMRmeta.SysOption Set Description="界面32|门诊病历的按钮，请从[btnSave:保 存;btnPrint:打 印;btnDelete:删 除;btnTemplateclassify:模板选择;btnSpechars:特殊符号;btnRefreshRefData:刷新数据;btnTest:测试;btnAsrVoice:语音输入;btnScaleEditor:缩放编辑器;btnExportDocument:导出;btnmodelinstance:范例病历;btnPreview:预览]中挑选适用于项目的按钮" where Name="OPEmrButtons")
	
	//14 ZorderScheme
	&sql(update EMRmeta.SysOption Set OptionValue="<scheme><show><item><code>OrdCreateDate</code><desc>医嘱日期</desc><hidden>N</hidden><width>100</width><sortable>Y</sortable></item><item><code>ArcimDesc</code><desc>医嘱名称</desc><hidden>N</hidden></item><item><code>RecipeInfo</code><desc>处方信息</desc><hidden>N</hidden></item><item><code>DoseQty</code><desc>剂量</desc><hidden>N</hidden></item><item><code>DoseUnit</code><desc>剂量单位</desc><hidden>Y</hidden></item><item><code>Instr</code><desc>服用方法</desc><hidden>N</hidden></item><item><code>PHFreq</code><desc>频率</desc><hidden>N</hidden></item><item><code>OrdXDate</code><desc>OrdXDate</desc><hidden>Y</hidden></item><item><code>OrdDepProcNotes</code><desc>OrdDepProcNotes</desc><hidden>Y</hidden></item></show><reference><items><item><code>ArcimDesc</code><desc></desc><separate>enter</separate></item><item><code>RecipeInfo</code><desc></desc><separate>,</separate></item><item><code>Instr</code><desc></desc><separate>,</separate></item><item><code>DoseQty</code><desc></desc><separate></separate></item><item><code>DoseUnit</code><desc></desc><separate>,</separate></item><item><code>PHFreq</code><desc></desc><separate></separate></item></items><separate>enter</separate><space>Y</space></reference><interface>HIS</interface></scheme>" where Name="ZorderScheme")
	
	
	//15 DisableFont
	&sql(update EMRmeta.SysOption Set OptionValue="recording" where Name="DisableFont")
	
	
	//16 START_FROM_LAST_MODIFY
	&sql(update EMRmeta.SysOption Set IsEditor="FALSE" where Name="START_FROM_LAST_MODIFY")
	
	//17 SHOW_SELECT_INIT_ELEMENT_DIALOG_LIMIT
	&sql(update EMRmeta.SysOption Set OptionValue="Y" where Name="SHOW_SELECT_INIT_ELEMENT_DIALOG_LIMIT")
	
	
	//18 IsRevokeSign [重点确认，是否影响门诊病历签名规则]
	&sql(update EMRmeta.SysOption Set OptionValue="N" where Name="IsRevokeSign")
	

	
	//--insert 28
	//1 SendMessage
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("实习医师或下级医师写完病历，发消息给上级医师签字","FALSE","Y","SendMessage","<event><sign><actions><action>intern</action><action>student</action></actions><titles><code></code></titles></sign></event>"))
	
	
	//2 LevelSource
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("系统24｜取病历级别来源[默认值EMR 取电子病历级别,HIS 取his维护级别]","FALSE","Y","LevelSource","EMR"))
	
	
	//3 SignLogic
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("系统25｜设置签名逻辑[默认值EMR 使用电子病历三级医师签名逻辑,Custom项目定义逻辑，如项目设置患者固定 三级医师]","FALSE","Y","SignLogic","EMR"))
	
	
	//4 ConsultScheme
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("界面49|资源区会诊显示引用格式，<interface></interface>为接口调用设置，默认为HIS自带的接口，即<interface>HIS</interface>，调用其他接口在<interface></interface>中设置即可","FALSE","Y","ConsultScheme","<scheme><show><item><code>Diag</code><desc>诊断</desc><width>80</width><hidden>Y</hidden></item><item><code>ConDestination</code><desc>会诊目的</desc><width>120</width><hidden>N</hidden></item><item><code>ConsultDep</code><desc>会诊科室</desc><width>80</width><hidden>N</hidden></item><item><code>ConsultDoc</code><desc>会诊医生</desc><width>80</width><hidden>N</hidden></item><item><code>Attitude</code><desc>会诊意见</desc><width>120</width><hidden>N</hidden></item><item><code>ConType</code><desc>会诊类别</desc><width>80</width><hidden>N</hidden></item><item><code>ConsultDate</code><desc>会诊日期</desc><width>80</width><hidden>N</hidden></item><item><code>ConsultTime</code><desc>会诊时间</desc><width>80</width><hidden>N</hidden></item><item><code>PatDep2</code><desc>会诊申请科室</desc><width>80</width><hidden>N</hidden></item><item><code>PatDoc</code><desc>申请医生</desc><width>80</width><hidden>N</hidden></item><item><code>PatRegNo</code><desc>登记号</desc><width>80</width><hidden>N</hidden></item><item><code>PatId</code><desc>病案号</desc><width>80</width><hidden>N</hidden></item><item><code>PatName</code><desc>姓名</desc><width>80</width><hidden>N</hidden></item><item><code>SEX</code><desc>性别</desc><width>80</width><hidden>Y</hidden></item><item><code>AGE</code><desc>年龄</desc><width>80</width><hidden>Y</hidden></item><item><code>PatDep</code><desc>科别</desc><width>80</width><hidden>Y</hidden></item><item><code>PatWard</code><desc>病区</desc><width>80</width><hidden>Y</hidden></item><item><code>BedCode</code><desc>床号</desc><width>80</width><hidden>Y</hidden><sortable>N</sortable></item></show><reference><items><item><code>ConsultDep</code><desc/><separate/></item><item><code>ConsultDoc</code><desc/><separate>,</separate></item><item><code>ConDestination</code><desc/><separate>,</separate></item><item><code>ConsultDate</code><desc/><separate>,</separate></item><item><code>ConsultTime</code><desc/><separate>,</separate></item><item><code>Attitude</code><desc/><separate/></item></items><separate>enter</separate></reference><interface>HIS</interface></scheme>"))
	
	
	//5 HIDE_EDITOR_RULER
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("界面45|是否隐藏标尺，取值Y/N[隐藏->Y][显示->N]，默认为N	","TRUE","Y","HIDE_EDITOR_RULER","N"))
	
	//6 SetAppointMsgToDoc
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("系统22|病历授权模块，授权或者拒绝时，是否给申请医生发送消息到消息平台，默认为N","FALSE","Y","SetAppointMsgToDoc","Y"))
	
	//7 RequestReasonLimitStr
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("控制申请原因、修改前内容、修改后内容最少字数。格式如下：0^10^0。其中0->不控制，大于0的10->控制，三部分控制配置以^分隔。如：0^10^0,表示修改前内容最少字数为10.","FALSE","Y","RequestReasonLimitStr","0^0^0"))
	
	//8 FilterOrder
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("界面48|资源区的医嘱数据是否过滤，过滤为Y；不过滤为N；过滤顺序为作废医嘱、停止医嘱、非医生所下医嘱(护士补录医嘱等)，默认为N^N^N","FALSE","Y","FilterOrder","N^N^N"))
	
	//9 SearchAcrossDepartment
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("界面46|病历导航页面知情告知实现跨科搜索模板（code为病历展现结构的DocID）","FALSE","Y","SearchAcrossDepartment","<scheme><item><code>11</code><desc>科室模板</desc></item></scheme>"))
	
	
	//10 CardClassificationDisplay
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("界面47|病历导航页面卡片分类显示,病历模板和实例分开显示,新建卡片在上,实例病历在下（Y：开启）	","FALSE","Y","CardClassificationDisplay","N"))
	
	
	//11 MedicalRecordDocID
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("业务01|是否打印病案首页成功后，对外提供访问出院患者列表。若启用该功能，则把此系统参数的值设置为：病案首页展现结构的docID（挂靠界面模板的目录ID）,若有多个以^为分隔（例51^63）；若不启用此功能，则把值设置为空。默认为空","FALSE","Y","MedicalRecordDocID",""))
	
	
	//12 NotRemoveMinus
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("保留字典描述列中的横线","FALSE","Y","NotRemoveMinus","SQLUser.MRC_ICDDx|MRCID_Desc"))
	
	
	//13 DISABLE_PASTE_NON_EDITOR
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("界面24|是否禁止粘贴非编辑器外的数据[启用->Y][禁用->N]默认为N","TRUE","Y","DISABLE_PASTE_NON_EDITOR","N"))
	
	
	//14 RecordSequence
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("病历目录增加设置显示顺序","FALSE","Y","RecordSequence","{""NavRecord"":""DESC"",""TimeLineRecord"":""DESC""}"))
	
	
	//15 InformedConsentEmrTID
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("维护02|病历分组维护中展现结构树加载的知情告知目录ID集,类型为Category [目录1^目录2]","FALSE","Y","InformedConsentEmrTID","8"))
	
	
	//16 EnableCMVTOOL
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("如果设置为Y,才调用分词工具入口方法。","FALSE","Y","EnableCMVTOOL","N"))
	
	
	//17 SignTypeInP
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("系统34|住院病历签名类型（Graph-图片签名，Text-文字签名)","FALSE","Y","SignTypeInP","Text"))
	

	
	//18 COLOR_PAPER_BACKGROUND
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("系统35|设置客户机编辑器留痕模式，是否开启医生分级留痕显示 默认为N[启用->Y][禁用->N]","TRUE","Y","ENABLE_DOCTOR_REVISION_MODE","Y"))
	
	
	//19 DISABLE_DROP_NON_EDITOR
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("界面50|是否禁止拖拽外部数据到编辑器[启用->Y][禁用->N]默认为N","FALSE","Y","DISABLE_DROP_NON_EDITOR","N"))
	
	
	//20 ENABLE_DOCTOR_REVISION_MODE
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("系统35|设置客户机编辑器留痕模式，是否开启医生分级留痕显示 默认为N[启用->Y][禁用->N]	","FALSE","Y","ENABLE_DOCTOR_REVISION_MODE","Y"))
	
	
	//21 PatholScheme
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("界面29|资源区病理引用格式","FALSE","Y","PatholScheme","<scheme><show><parent><item><code>ordername</code><desc>医嘱项</desc><hidden>N</hidden><width>130</width></item><item><code>AppDate</code><desc>申请日期</desc><hidden>N</hidden></item><item><code>AppTime</code><desc>申请时间</desc><hidden>N</hidden></item><item><code>SpeInfo</code><desc>标本信息</desc><hidden>N</hidden></item><item><code>tmid</code><desc>申请单号</desc><hidden>N</hidden></item><item><code>ClinicDiag</code><desc>临床诊断</desc><hidden>Y</hidden></item><item><code>ClinicRecord</code><desc>临床病历</desc><hidden>Y</hidden></item></parent><child><item><code>Tmrowid</code><desc>Tmrowid</desc><hidden>Y</hidden></item><item><code>RptDate</code><desc>报告日期</desc><hidden>N</hidden><width>70</width></item><item><code>RptTime</code><desc>报告时间</desc><hidden>Y</hidden><width>70</width></item><item><code>Seeing</code><desc>检查所见:</desc><hidden>N</hidden><width>130</width></item><item><code>Diagnosis</code><desc>病理诊断:</desc><hidden>N</hidden><width>130</width></item><item><code>PathId</code><desc>病理号:</desc><hidden>N</hidden></item></child></show><reference><parent><item><code>ordername</code><desc></desc><separate>：</separate></item></parent><child><item><code>Diagnosis</code><desc></desc><separate>enter</separate><check>Y</check></item><item><code>Seeing</code><desc></desc><separate>。</separate><check>Y</check></item><item><code>RptDate</code><desc></desc><separate>enter</separate><check>Y</check></item><item><code>PathId</code><desc></desc><separate>enter</separate><check>Y</check></item></child></reference><interface>HIS</interface></scheme>"))
	
	
	//22 isSetCurrentRevisorIP
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("界面53|是否显示留痕信息中的当前操作者的IP","FALSE","Y","isSetCurrentRevisorIP","N"))
	
	
	//23 isModifyColorChangeColor
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("界面55|是否启用改变病历时间，改变目录的颜色以示区分。【Y:开启；N：关闭】","FALSE","Y","isModifyColorChangeColor","Y"))
	
	
	
	//24 CREATE_BY_USERTEMPLATE
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("是否采用用户模板加载[是->Y][不是->N]","FALSE","Y","CREATE_BY_USERTEMPLATE","Y"))
	
	
	//25 SHOW_TABLE_DOTTED_LINE
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("系统38|表格书写是否显示虚线边框 默认为Y[启用->Y][禁用->N]","TRUE","Y","SHOW_TABLE_DOTTED_LINE","N"))
	
	
	//26 GUIDE_DOCUMENT_MODE
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("设置标题引导框模式（Title/Template）","TRUE","Y","GUIDE_DOCUMENT_MODE","Template"))
	
	
	//27 SetInternToDocStation
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("系统34|提供给医生站接口，返回最新修改过病历的附属账号，用于医生站病人列表显示患者附属账号。该值为附属账号安全组RowID，以上尖号^分隔（例308^309）","FALSE","Y","SetInternToDocStation","308^309"))
	
	
	//28 DISABLE_NEAT_PRINT
	&sql(INSERT INTO EMRmeta.SysOption VALUES ("界面23|禁止自动整洁打印,默认为N	","TRUE","Y","DISABLE_NEAT_PRINT","N"))
	
	//初始化新加属性squence值
	&sql(update EMRmeta.TitleCategory set Sequence=ID where Sequence is NULL)
	
	
	d ##class(EMRmeta.EMRTemplate).%PurgeIndices()
	d ##class(EMRmeta.EMRTemplate).%BuildIndices()
	
	
	d ##class(EMRmeta.TitleConfig).%PurgeIndices()
	d ##class(EMRmeta.TitleConfig).%BuildIndices()
	
	
	d ##class(EMRmeta.TitleCategory).%PurgeIndices()
	d ##class(EMRmeta.TitleCategory).%BuildIndices()
	
	
	d ##Class(EMRservice.BL.BLClientCategory).GetCategoryNameJaneSpellAndFullFight(0)


	//GLOB-2910:电子病历病历导航界面的模板页签大小减少一半（需求网序号：272785）
	//Desc:新增EMRmeta.CategoryViewDisplay病历目录视图显示表和EMRmeta.UserPageConfig用户页面配置表，该需求需要执行一下三个步骤，如下：
	//初始化病历目录视图显示数据执行以下方法：
	 
	d ##Class(EMRservice.Tools.Tool).InitCategoryViewDisplay("/tmp/init1734/CategoryViewDisplay.txt")
	//病历目录视图显示表EMRmeta.CategoryViewDisplay重建索引：
	d ##class(EMRmeta.CategoryViewDisplay).%BuildIndices()
	//用户页面配置表EMRmeta.UserPageConfig重建索引：
	d ##class(EMRmeta.UserPageConfig).%BuildIndices()  
   
   //初始化之后依据项目情况再行修正
   d ##Class(EMRservice.BL.BLSignRoleLinkCarPrvTp).InitData()
   
   
   &sql(update EMRmeta.UserLevel set Description='主任医师' where Name='Chief')
   &sql(insert into EMRmeta.UserLevel(Description,IsValid,Name)values('副主任医师',1,'ViceChief'))


  //暂时不更新  
  //术语集接口提供病历创建时间，创建人，发生时间，修改时间，修改人（需要更新术语集程序）
  //d ##Class(EPRservice.BLL.BLGlossaryClassProperty).initData()
  
  
  //GLOB-2763 维护程序中--权限规则维护中点击“引用参数”的弹出界面的参数和实际类里的参数关键字不一致
  k ^DHCEMRM.PrivRuleListI
  k ^DHCEMRM.PrivRuleListD
  d ##Class(EMRservice.Tools.Tool).InitPrivRuleList("/tmp/init1734/PrivRuleList.txt")

  //GLOB-2713 住院病历及门诊病历支持患者手工签名
  d ##Class(EMRservice.Tools.Tool).InitEMRAction("/tmp/init1734/EMRAction.txt")
  d ##Class(EMRservice.Tools.Tool).InitEMRStatus("/tmp/init1734/EMRStatus.txt")
  d ##Class(EMRservice.Tools.Tool).InitEMRActStatusCfg("/tmp/init1734/EMRActStatusCfg.txt")
  
  
  d ##Class(EMRservice.BL.BLSignRole).IniData()
}

/// d ##class(EMRservice.Tools.DailyWorkTool).MoveLastVersionTemplateToFirst()
ClassMethod MoveLastVersionTemplateToFirst()
{
	w !,"开始迁移最新发布模板到此模板版本一"
	s templateID=""
	for {
		s templateID=$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion",templateID))
		q:(templateID="")
		
		s version=""
		for 
		{
			s version=$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion",templateID,version),-1)
			q:(version="")
			
			s templateVersionID=""
			s templateVersionID=$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion",templateID,version,templateVersionID))
			s objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(templateVersionID)
			s status=objTemplateVersion.Status
			continue:(status'=2)
			q:(objTemplateVersion.VersionNumber=1)
			s firstTmpltVerID=$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion",templateID,1,""),-1)
			s objFirstTmpltVer=##class(EMRmeta.TemplateVersion).%OpenId(firstTmpltVerID)
			
			//直接赋值
			s objFirstTmpltVer.Author = objTemplateVersion.Author
			s objFirstTmpltVer.CreateDate = objTemplateVersion.CreateDate
			s objFirstTmpltVer.CreateTime = objTemplateVersion.CreateTime
			s objFirstTmpltVer.LastSaveDate = objTemplateVersion.LastSaveDate
			s objFirstTmpltVer.LastSaveTime = objTemplateVersion.LastSaveTime
			s objFirstTmpltVer.PublicationDate = objTemplateVersion.PublicationDate
			s objFirstTmpltVer.PublicationTime = objTemplateVersion.PublicationTime
			s objFirstTmpltVer.TemplateSummary = objTemplateVersion.TemplateSummary
			
			//流数据处理
			/*s objFirstTmpltVer.GridData = objTemplateVersion.GridData
			s objFirstTmpltVer.InitialData = objTemplateVersion.InitialData
			s objFirstTmpltVer.MediasData = objTemplateVersion.MediasData
			s objFirstTmpltVer.MetaData = objTemplateVersion.MetaData
			s objFirstTmpltVer.PresentationData = objTemplateVersion.PresentationData
			s objFirstTmpltVer.ScriptData = objTemplateVersion.ScriptData
			*/
			
			
			//流数据处理
			d objFirstTmpltVer.GridData.Clear()
			d objFirstTmpltVer.GridData.CopyFromAndSave(objTemplateVersion.GridData)
			
			d objFirstTmpltVer.InitialData.Clear()
			d objFirstTmpltVer.InitialData.CopyFromAndSave(objTemplateVersion.InitialData)
			
			d objFirstTmpltVer.MediasData.Clear()
			d objFirstTmpltVer.MediasData.CopyFromAndSave(objTemplateVersion.MediasData)
			
			d objFirstTmpltVer.MetaData.Clear()
			d objFirstTmpltVer.MetaData.CopyFrom(objTemplateVersion.MetaData)
			
			d objFirstTmpltVer.PresentationData.Clear()
			d objFirstTmpltVer.PresentationData.CopyFromAndSave(objTemplateVersion.PresentationData)
			
			d objFirstTmpltVer.ScriptData.Clear()
			d objFirstTmpltVer.ScriptData.CopyFromAndSave(objTemplateVersion.ScriptData)
			
			d objFirstTmpltVer.%Save()
			d objFirstTmpltVer.%Close()
			
			q	
			
		}
		w !,"模板："""_##class(EMRmeta.Template).%OpenId($e(templateID,2,$length(templateID))).Name_""",迁移完成"	
		
	}
	w !,"迁移完成"
	
	w !,"开始清除非版本一模板"
	&sql(delete from EMRmeta.TemplateVersion where VersionNumber != "1")
	
	w:(SQLCODE>=0) !,"清除完成"
	w:(SQLCODE<0) !,"清除失败"
	
	w !,"初始化模板信息，发布版本和最终版本均为1"
	&sql(UPDATE EMRmeta.Template SET LastVersion = 1 ,PublishVersion = 1)
	w !,"初始化模板信息结束"
}

/// w ##Class(EMRservice.Tools.DailyWorkTool).InitQueryItem()
ClassMethod InitQueryItem() As %String
{
    s tmpGlossaryID="",Count=20000
    for    {
        s tmpGlossaryID=$o(^DHCEPRM.GlossaryD(tmpGlossaryID))
        q:(tmpGlossaryID="")
        
        s tmpobj=""
        s tmpobj=##class(EPRmeta.Glossary).%OpenId(tmpGlossaryID)
        continue:(tmpobj="")
        
        s internalID=tmpobj.InternalID
        s name=tmpobj.Name
        s glocategory=tmpobj.GlossaryCategoryID
        s tmpCategoryID=0
        //73        HDSD00.11    住院病案首页
        //66        HDSD00.14.13    出院记录
        //13        HDSD00.13.01    入院记录    
        //40, 'GlossaryCate1', 'Y', '入院记录', '6', '入院记录', 6001
        //41, 'GlossaryCate2', 'Y', '病案首页', '6', '病案首页', 6002
        //42, 'GlossaryCate3', 'Y', '出院记录', '6', '出院记录', 6003
        s tmpGlossaryCategoryobj="",CateInternalID=""
        s tmpGlossaryCategoryobj=##class(EPRmeta.GlossaryCategory).%OpenId(glocategory)
        s CateInternalID=tmpGlossaryCategoryobj.InternalID
        continue:(CateInternalID="")
        
        s tmpCategoryID=$s(CateInternalID="HDSD00.03.01":499,CateInternalID="HDSD00.03.02":500,1:0)
        continue:(tmpCategoryID=0)
        
        s tmpQueryobj=""
        s tmpQueryobj=##class(EPRmeta.Query.QueryItem).%New()
        
        s tmpQueryobj.CategoryID=tmpCategoryID
        s tmpQueryobj.Code=$p(name," ",1)
        s tmpQueryobj.IsActive="Y"
        s tmpQueryobj.Name="GlossaryItem"_$i(Count)
        s tmpQueryobj.ParentID=0
        
        // 时间 4 日期 3
        s tmptypeid=$s(name["日期":3,name["时间":4,1:"1")
        s tmpQueryobj.QueryItemTypeID=tmptypeid
        
        
        s tmpQueryobj.Remark=""
        s tmpQueryobj.Sequence=Count
        s tmpStddic="1"
        s tmpStddic=$s(name["性别":"S06",name["科室":"S07",name["病区":"S10",1:"1")
        s tmpQueryobj.StdDic=tmpStddic
        
        s tmpQueryobj.Title=$p(name," ",2)
        
        d tmpQueryobj.%Save()
        d tmpQueryobj.%Close()
        s tmpQueryobj="" 
    }
    q Count-10000
}

/// 清除病历相关配置数据（HIS科室、HIS安全组）
/// 入参：AIsCleanLoc,Y\N，Y清除科室相关配置数据。
/// 	 AIsCleanGroup,Y\N，Y清除安全组相关配置数据。
/// date20170703
/// ceatet:lifengbo	
/// debugger
/// d ##class(EMRservice.Tools.DaiworkTool).EMRCleanMetaDataOnLocGrp("Y","N")	
ClassMethod EMRCleanMetaDataOnLocGrp(AIsCleanLoc As %String = "", AIsCleanGroup As %String = "N")
{
	q:(AIsCleanLoc="") "是否清楚科室关联数据"
	if (AIsCleanLoc="Y")
	{
		//1. 知识库可见科室配置
		//EMRmeta.KBTreeCTLoc
		k ^DHCEMRM.KBTreeCTLocD
		k ^DHCEMRM.KBTreeCTLocI
		k ^DHCEMRM.KBTreeCTLocS
		
		//2. 病历展现结构，模板组科室配置 
		//EMRmeta.EMRDocRestriction.CatalogSSGroup
		k ^DHCEMRM.DocRes.DocRestrictionD
		k ^DHCEMRM.DocRes.DocRestrictionI
		k ^DHCEMRM.DocRes.DocRestrictionS

		//3. 病历导航分类，分类科室配置
		//EMRmeta.EMRNavigationSchemeItemLoc
		k ^DHCEMRM.EMRNavItemLocD
		k ^DHCEMRM.EMRNavItemLocI
		k ^DHCEMRM.EMRNavItemLocS
		//EMRmeta.EMROrganizationSchemeLoc
		k ^DHCEMRM.EMROrgSchemeLocD
		k ^DHCEMRM.EMROrgSchemeLocI
		k ^DHCEMRM.EMROrgSchemeLocS
		//4. 标题科室配置
		//EMRmeta.TitleLoc
		k ^DHCEMRM.TitleLocD
		k ^DHCEMRM.TitleLocI


		//5. 病种科室配置
		//EMRmeta.DiagnosCTLoc
		k ^DHCEMRM.DiagnosCTLocD
		k ^DHCEMRM.DiagnosCTLocI
		k ^DHCEMRM.DiagnosCTLocS
		
		//6.批量创建病历方案关联科室
		k ^DHCEMRM.EMRTemplateGroupLocD
		k ^DHCEMRM.EMRTemplateGroupLocI
		k ^DHCEMRM.EMRTemplateGroupLocS
		
		w !,"Loc Clean Over"
	
	}
	
	if (AIsCleanGroup="Y")
	{
	
		
		//3. 病历导航分类，分类科室配置
		//EMRmeta.EMRNavigationSchemeItemSSGroup
		k ^DHCEMRM.EMRNavItemSSGroupD
		k ^DHCEMRM.EMRNavItemSSGroupI
		k ^DHCEMRM.EMRNavItemSSGroupS
		
		//5. 病种科室配置
		//EMRmeta.DiagnosGroup [?是否在用]
		k ^DHCEMRM.DiagnosGroupD
		k ^DHCEMRM.DiagnosGroupI
		k ^DHCEMRM.DiagnosGroupS
		
		w !,"SSGroup Clean Over"
	
	}
	w !,"Finish"
}

/// 清除病历相关配置数据（HIS科室、HIS安全组）
/// 入参：AIsCleanLoc,Y\N，Y清除科室相关配置数据。
/// 	 AIsCleanGroup,Y\N，Y清除安全组相关配置数据。
/// 	 AIsCleanSSUSer,Y\N，Y清除用户相关配置数据。
/// date20170703
/// ceatet:lifengbo	
/// debugger
/// d ##class(EMRservice.Tools.DaiworkTool).TestGroupCleanMetaData("Y","N","Y")	
ClassMethod TestGroupCleanMetaData(AIsCleanLoc As %String = "", AIsCleanGroup As %String = "N", AIsCleanSSUSer As %String = "N")
{
	q:(AIsCleanLoc="") "是否清楚科室关联数据"
	if (AIsCleanLoc="Y")
	{
		//1. 知识库可见科室配置
		//EMRmeta.KBTreeCTLoc
		k ^DHCEMRM.KBTreeCTLocD
		k ^DHCEMRM.KBTreeCTLocI
		k ^DHCEMRM.KBTreeCTLocS
		
		//2. 病历展现结构，模板组科室配置 
		//EMRmeta.EMRDocRestriction.CatalogSSGroup
		k ^DHCEMRM.DocRes.DocRestrictionD
		k ^DHCEMRM.DocRes.DocRestrictionI
		k ^DHCEMRM.DocRes.DocRestrictionS

		//3. 病历导航分类，分类科室配置
		//EMRmeta.EMRNavigationSchemeItemLoc
		k ^DHCEMRM.EMRNavItemLocD
		k ^DHCEMRM.EMRNavItemLocI
		k ^DHCEMRM.EMRNavItemLocS
		//EMRmeta.EMROrganizationSchemeLoc
		k ^DHCEMRM.EMROrgSchemeLocD
		k ^DHCEMRM.EMROrgSchemeLocI
		k ^DHCEMRM.EMROrgSchemeLocS
		//4. 标题科室配置
		//EMRmeta.TitleLoc
		k ^DHCEMRM.TitleLocD
		k ^DHCEMRM.TitleLocI


		//5. 病种科室配置
		//EMRmeta.DiagnosCTLoc
		k ^DHCEMRM.DiagnosCTLocD
		k ^DHCEMRM.DiagnosCTLocI
		k ^DHCEMRM.DiagnosCTLocS
		
		//6.批量创建病历方案关联科室
		k ^DHCEMRM.EMRTemplateGroupLocD
		k ^DHCEMRM.EMRTemplateGroupLocI
		k ^DHCEMRM.EMRTemplateGroupLocS
		
		//7.科室短语
		k ^DHCEMRM.DPCTLocD
		k ^DHCEMRM.DPCTLocI
		k ^DHCEMRM.DPCTLocS
		
		w !,"Loc Clean Over"
	
	}
	
	if (AIsCleanGroup="Y")
	{
	
		
		//3. 病历导航分类，分类科室配置
		//EMRmeta.EMRNavigationSchemeItemSSGroup
		k ^DHCEMRM.EMRNavItemSSGroupD
		k ^DHCEMRM.EMRNavItemSSGroupI
		k ^DHCEMRM.EMRNavItemSSGroupS
		
		//5. 病种科室配置
		//EMRmeta.DiagnosGroup [?是否在用]
		k ^DHCEMRM.DiagnosGroupD
		k ^DHCEMRM.DiagnosGroupI
		k ^DHCEMRM.DiagnosGroupS
		
		w !,"SSGroup Clean Over"
	
	}
	
	if (AIsCleanSSUSer="Y")
	{
		//1.删除 个人知识库
		//EMRmeta.KBNode KBTree中包含UserID的目录和节点
		s kbtreeId=""
		for
		{
			s kbtreeId = $o(^DHCEMRM.KBTreeD(kbtreeId))
			q:(kbtreeId="")
			s objKBTree=##class(EMRmeta.KBTree).%OpenId(kbtreeId)
			continue:(objKBTree.PersonalKBUserID = "")
			
			s kbnodeId=""
			for
			{
				s kbnodeId = $o(^DHCEMRM.KBNodeI("IdxKBTreeID"," "_kbtreeId,kbnodeId))
				q:(kbnodeId="")
				s objKBNode = ##class(EMRmeta.KBNode).%OpenId(kbnodeId)
				s sc1 = objKBNode.%DeleteId(kbnodeId)
			}
			s sc = objKBTree.%DeleteId(kbtreeId)
		}
		
		//2. 删除科室短语
		//EMRmeta.DBCategory
		//EMRmeta.DBContent
		s dpcategoryId=""
		for
		{
			s dpcategoryId = $o(^DHCEMRM.DPCategoryI("IdxType"," PERSONALDPTREE",dpcategoryId))
			q:(dpcategoryId="")
			s objDPCategory = ##class(EMRmeta.DPContent).%OpenId(dpcategoryId)
			continue:(objDPCategory="")
			
			s subdpcategoryId=""
			for
			{
				s subdpcategoryId = $o(^DHCEMRM.DPCategoryI("IdxParentID",dpcategoryId,subdpcategoryId))
				q:(subdpcategoryId="")
				
				s objSubDPCategory = ##class(EMRmeta.DPContent).%OpenId(subdpcategoryId)
				continue:(objSubDPCategory="")
				
				s dpcontentId=""
				for
				{
					s dpcontentId=$o(^DHCEMRM.DPContentI("IdxCategoryID",subdpcategoryId,dpcontentId))
					q:(dpcontentId="")
					
					s objDPContent = ##class(EMRmeta.DPContent).%OpenId(dpcontentId)
					continue:(objDPContent="")
					d objDPContent.%DeleteId(dpcontentId)
				}
				
				d objSubDPCategory.%DeleteId(subdpcategoryId)
				
			}
			
			d objDPCategory.%DeleteId(dpcategoryId)
		}
		
		w !,"SSUSer Clean Over"
	
	}
	//科室模板待审核数据，还原为未申请。
	s userTemplateId=""
	for
	{
		s userTemplateId = $o(^DHCEMRM.UserTemplateD(userTemplateId))
		q:(userTemplateId="")
		
		s objUserTemplate = ##class(EMRmeta.UserTemplate).%OpenId(userTemplateId)
		continue:(objUserTemplate="")
		
		s status= objUserTemplate.Status
		if ((status=2)||(status=3))
		{
			s objUserTemplate.Status = 0
			d objUserTemplate.%Save()
			s objUserTemplate=""
		}
		
	}
	//（清除个人模板 测试组清测试数据可用，项目部署标库谨慎执行。）
	s Key="" //"TestGroup"
	if (Key="TestGroup")
	{
		//EMRmeta.ExampleInsSecRelation
		k ^DHCEMRM.ExampleInsSecRelationD
		k ^DHCEMRM.ExampleInsSecRelationI
		k ^DHCEMRM.ExampleInsSecRelationS
		
		//EMRmeta.ExampleInstance
		k ^DHCEMRM.ExampleInstanceD
		k ^DHCEMRM.ExampleInstanceI
		k ^DHCEMRM.ExampleInstanceS
		
		//EMRmeta.ExampleInstanceCategory
		k ^DHCEMRM.ExamInsCategoryD
		k ^DHCEMRM.ExamInsCategoryI
		k ^DHCEMRM.ExamInsCategoryS
		
		//EMRmeta.ExampleInstanceCategoryLoc
		k ^DHCEMRM.ExamInsCategoryLocD
		k ^DHCEMRM.ExamInsCategoryLocI
		k ^DHCEMRM.ExamInsCategoryLocS
		
		//EMRmeta.ExampleInstanceLoc
		k ^DHCEMRM.ExamInsLocD
		k ^DHCEMRM.ExamInsLocI
		k ^DHCEMRM.ExamInsLocS
		
		//EMRmeta.ExampleInstanceSection
		k ^EMRmeta.ExampleInstanceSectionD
		k ^EMRmeta.ExampleInstanceSectionI
		k ^EMRmeta.ExampleInstanceSectionS
	}
	
	w !,"Finish"
}

/// d ##class(EMRservice.Tools.DailyWorkTool).AppendGlossayData("HDSD00.11","D:\HDSD00.11住院病案首页.csv")
/// d ##class(EMRservice.Tools.DailyWorkTool).AppendGlossayData("HDSD00.11","D:\initGlossary.txt")
/// d ##class(EMRservice.Tools.DailyWorkTool).AppendGlossayData("HDSD00.12","/tmp/initglossary.txt")
ClassMethod AppendGlossayData(AGlossaryCategoryInteranlID As %String, argFile As %String)
{
	s glCateID=""
	s glCateID = $o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_AGlossaryCategoryInteranlID,glCateID))	
	q:(glCateID="") "<error> 无对应术语集目录</error>"
	
	
	s Stream=##class(%FileBinaryStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		
		//HDSD00.11.118|DE08.10.013.00|医疗机构名称||患者在住院诊疗所在的医疗机构名称||||
		s sRec=$zcvt(sRec,"I")
		s glossaryItemInternalID = $p(sRec, "|", 1)
		s glossaryItemMetaID = $p(sRec, "|", 2)
		s glossaryItemName = $p(sRec, "|", 3)
		s glossaryItemDescription = $p(sRec, "|", 5)
		
		s objgloId=""
		s objgloId = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_glossaryItemInternalID," "_glCateID,objgloId))
		
		continue:(objgloId '="")
		
		s obj = ##Class(EPRmeta.Glossary).%New()
		s obj.BindItemData=""
		s obj.CreateDate=+$h
		s obj.CreateTime = $p($h,",",2)
		
		s obj.Description = glossaryItemDescription
		s obj.GUID = ..BuildGUID()
		
		s obj.GlossaryCategoryID = glCateID
		s obj.GlossaryType = "TG"
		s obj.InternalID = glossaryItemInternalID
		
		s obj.LastModifyDate=+$h
		s obj.LastModifyTime = $p($h,",",2)
		
		s obj.MetaID = glossaryItemMetaID
		s obj.MetaItemData = ""
		
		s obj.Name = glossaryItemInternalID_" "_glossaryItemName
		s obj.ParentID=""
		

		s isOK = obj.%Save()
	    
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"GlossaryAppendSummary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

/// w ##class(EMRservice.Tools.DailyWorkTool).BuildGUID()
ClassMethod BuildGUID() As %String
{
	s guid=""
	//数字生成
	//$c($random(10)+48)
	
	//字符生成
	//$c($random(26)+97)
	for i=1:1:32
	{
		s guid=guid_$s($random(2)=0:$c($random(26)+97),1:$c($random(10)+48))	
	}
	s retguid=$e(guid,1,8)_"-"_$e(guid,9,12)_"-"_$e(guid,13,16)_"-"_$e(guid,17,20)_"-"_$e(guid,21,32)
	q retguid
}

/// d ##class(EMRservice.Tools.DailyWorkTool).InitEMR07Data()
ClassMethod InitEMR07Data()
{
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_公共告知部分'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_呼吸系统_呼吸系统通用知情同意书'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_呼吸系统_呼吸科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_呼吸系统_胸外科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_循环系统_心内科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_循环系统_心外科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_循环系统_血管外科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_消化系统_消化内科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_消化系统_肝病科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_消化系统_血液系统'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_消化系统_内分泌系统'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_神经系统_神经内科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_神经系统_神经外科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_泌尿与男性生殖系统_肾内科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_泌尿与男性生殖系统_泌尿外科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_女性生殖系统_妇科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_女性生殖系统_产科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_女性生殖系统_计划生育科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_骨骼系统_创伤骨科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_骨骼系统_骨关节科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_骨骼系统_骨肿瘤科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_骨骼系统_脊柱外科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_儿科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_中医科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_皮科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_麻醉科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_重症医学科（ICU）'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_普通外科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_眼科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_耳鼻喉科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_口腔科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_医疗美容科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_放射科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_放疗科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_核医学科'))
    &sql(INSERT INTO EMRmeta_EMRDocRestriction.DocGroup VALUES ('知情同意_各科通用知情同意书'))
}

/// 将知情同意的模板Docid加入模板组
/// d ##class(EMRservice.Tools.DailyWorkTool).InitEMR07TemplateInDocGroup(6)
ClassMethod InitEMR07TemplateInDocGroup(AParentEMRTempCateId As %String = "6")
{
	s parentemrcateId=AParentEMRTempCateId
	
	s emrcateId=""
	for
	{
		s emrcateId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_parentemrcateId,emrcateId))
		q:(emrcateId="")
		
		s objEMRCate =""
		s objEMRCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(emrcateId)
		if (objEMRCate.CategoryType '= "TempCate")
		{
			d ..InitEMR07TemplateInDocGroup(emrcateId)
		}
		else
		{
			
			s templateId=""
			for
			{
				s templateId =  $o(^DHCEMRM.EMRTemplateI("IdxCategoryTemplate"," "_emrcateId,templateId))
				q:(templateId = "")

				s stemplateId = $e(templateId,2,*)
				s objTemplate = ##class(EMRmeta.Template).%OpenId(stemplateId)
				
				continue:(objTemplate="")
				
				s cateId = objTemplate.TemplateCategoryID
				s objCate = ##class(EMRmeta.TemplateCategory).%OpenId(cateId)
				s cateName = objCate.Name
				
				s groupId=""
				for 
				{
					s groupId=$o(^DHCEMRM.DocRes.DocGroupD(groupId))
					q:(groupId="")
						
					s objDocGroup= ^DHCEMRM.DocRes.DocGroupD(groupId)
					s name = $lg(objDocGroup,2)
					continue:'(name["知情同意")
					q:(name[cateName)
				}
				continue:(groupId="")
				//s retstring= name_"  | "_cateName_"  |  "_objTemplate.Name
				//w !,retstring
				s docId = emrcateId	
				continue:($d(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx"," "_docId," "_groupId))=10)
				
				s obj = ##class(EMRmeta.EMRDocRestriction.DocsInGroup).%New()
				s obj.DocID = docId
				s obj.GroupID = groupId
				d obj.%Save()
				s obj=""

			}
		}	
	}
}

/// 验证，还未加入模板组的模板
/// w ##class(EMRservice.Tools.DailyWorkTool).checkNotInDocGroup()
ClassMethod checkNotInDocGroup()
{
	s parentemrcateId=""
	
	for
	{
		s parentemrcateId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID",parentemrcateId))
		q:(parentemrcateId="")
		
		s emrcateId=""
		for
		{
			s emrcateId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID",parentemrcateId,emrcateId))
			q:(emrcateId="")
			
			s objEMRCate =""
			s objEMRCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(emrcateId)
			continue:(objEMRCate.CategoryType '= "TempCate")
			
			s groupId=""
			
			s groupId = $o(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx"," "_emrcateId,groupId))
			
			if (groupId="")			
			{
				w !,objEMRCate.CategoryName_"未添加入模板组"
			}
			else
			{
				// w !,objEMRCate.CategoryName_"添加入模板组"
			}
		}
	}
}

/// 删除无效病历目录
/// d ##class(EMRservice.Tools.DailyWorkTool).DeleteTemplateCateByIDs()
ClassMethod DeleteTemplateCateByIDs() As %String
{

	s IDs = "1^3^4^21^6^7$111-246^11^15$220-222^12$196-196^84^254^20$156-190^336^10$183-337"
	
	for i=1:1:$l(IDs)
	{
		s tmpIdInfo = $p(IDs,"^",i)
		s (tmpId,startsubId,endsubId)=""
		
		s tmpId = $p(tmpIdInfo,"$",1)
		s startsubId = $p($p(tmpIdInfo,"$",2),"-",1)
		s endsubId = $p($p(tmpIdInfo,"$",3),"-",2)
		
		d ..DeleteTemplateCategoryData(tmpId,startsubId,endsubId)
		
		if ((startsubId="")&&(endsubId=""))
		{
			s sc = ##class(EMRmeta.TemplateCategory).%DeleteId(tmpId)
			if ($$$ISOK(sc))
			{
				w !,"Delete TemplateCategory RootData Suc:"_tmpId
			}
		}
	}
	
	q "export suc"
}

/// d ##class(EMRservice.Tools.DailyWorkTool).DeleteTemplateCategoryData(7,111,111)
ClassMethod DeleteTemplateCategoryData(AParentID As %String, StartTCId As %String = "", EndTCId As %String = "")
{
	q:(AParentID="") 
	
	s tcateId=""
	s:(StartTCId'="") tcateId=(StartTCId-1)
	for 
	{
		s tcateId=$o(^DHCEMRM.TemplateCategoryI("IdxParentId"," "_AParentID,tcateId))
		q:(tcateId = "")
		q:((EndTCId'="")&&(tcateId>EndTCId))
		
		d ..DeleteTemplateCategoryData(tcateId)
		
		s objTempCate=""
		s objTempCate = ##class(EMRmeta.TemplateCategory).%OpenId(tcateId)
		continue:(objTempCate="")
		
		s TemplateCount = objTempCate.ResChildCount
		s CateName = objTempCate.Name
		s newCount="0"
		if (TemplateCount>0)	
		{
			s newCount = ..DeleteTemplate(tcateId)
		}
		
		if (newCount = 0)
		{
			d objTempCate.%Close()
			s sc = ##class(EMRmeta.TemplateCategory).%DeleteId(tcateId)
			if ($$$ISOK(sc))
			{
				w !,"Delete TemplateCategory Suc:"_tcateId
			}
		}	
	}
	q
}

/// w ##class(EMRservice.Tools.DailyWorkTool).DeleteTemplate(191)
ClassMethod DeleteTemplate(ACategoryID As %String) As %String
{
	q:(ACategoryID="")
	s objCategory = ##class(EMRmeta.TemplateCategory).%OpenId(ACategoryID)
	q:(objCategory = "")
	
	s templateId=""
	for
	{
		s templateId = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_ACategoryID,templateId))
		q:(templateId="")
		
		s objTemplate=""
		s objTemplate = ##class(EMRmeta.Template).%OpenId(templateId)
		continue:(objTemplate="")
		
		s verNum=""
		
		for 
		{
			s verNum =  $o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_templateId,verNum))
			q:(verNum="")
			
			s templateVerId=""
			for
			{
				s templateVerId=$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_templateId,verNum,templateVerId))
				q:(templateVerId="")
				s sc = ##class(EMRmeta.TemplateVersion).%DeleteId(templateVerId)
				if ($$$ISOK(sc))
				{
					w !,"Delete TemplateVersion Suc:"_templateId_"|"_verNum_"|"_templateVerId
				}
			}
		}
		d objTemplate.%Close()
		s sct = ##class(EMRmeta.Template).%DeleteId(templateId)
		if ($$$ISOK(sct))
		{
			
			w !,"Delete Template Suc:"_templateId
			s objCategory.ResChildCount = objCategory.ResChildCount - 1
			d objCategory.%Save()
		}
	}
	s finalCount= objCategory.ResChildCount
	d objCategory.%Close()
	
	q finalCount
}

/// 更新病历目录
/// d ##class(EMRservice.Tools.DailyWorkTool).UpdateTemplateCateName()
ClassMethod UpdateTemplateCateName() As %String
{
	
	//14|EMR14 诊断证明
	//78|EMR140001 诊断证明书
	
	s updateInfo = "14|EMR14 诊断证明$78|EMR140001 诊断证明书"
	s updateInfo = updateInfo_"$"_"12|EMR12 出院小结$76|EMR120001 出院小结"
	for i=1:1:$l(updateInfo,"$")
	{
		s updatesub = $p(updateInfo,"$",i)
		s tcId=$p(updatesub,"|",1)
		s newName=$p(updatesub,"|",2)
		
		s objTemplateCategory= ##class(EMRmeta.TemplateCategory).%OpenId(tcId)
		s objTemplateCategory.Name = newName
		d objTemplateCategory.%Save()
		d objTemplateCategory.%Close()
	}
	q "update suc"
}

/// 更新病历目录
/// d ##class(EMRservice.Tools.DailyWorkTool).UpdateTemplateCateName()
ClassMethod AddTemplateCateName() As %String
{
	
	//14|EMR14 诊断证明
	//78|EMR140001 诊断证明书
	//parentId|name
	s updateInfo = "14|EMR14 诊断证明$78|EMR140001 诊断证明书"
	s updateInfo = updateInfo_"$"_"12|EMR12 出院小结$76|EMR120001 出院小结"
	
	for i=1:1:$l(updateInfo,"$")
	{
		s updatesub = $p(updateInfo,"$",i)
		s tcId=$p(updatesub,"|",1)
		s newName=$p(updatesub,"|",2)
		
		s objTemplateCategory= ##class(EMRmeta.TemplateCategory).%New()
		s objTemplateCategory.Name = newName
		d objTemplateCategory.%Save()
		d objTemplateCategory.%Close()
	}
	q "update suc"
}

/// 更新病历目录
/// d ##class(EMRservice.Tools.DailyWorkTool).MoveTemplateToRightCate()
ClassMethod MoveTemplateToRightCate() As %String
{
	
	//103|170
	s objTemplate = ##class(EMRmeta.Template).%OpenId(103)
	s objTemplate.TemplateCategoryID = 66
	
	//更新目录数据
	s objTemplateToCate = ##class(EMRmeta.TemplateCategory).%OpenId(66)
	s objTemplateToCate.ResChildCount = objTemplateToCate.ResChildCount +1
	d objTemplateToCate.%Save()
	
	s objTemplateFromCate = ##class(EMRmeta.TemplateCategory).%OpenId(215)
	s objTemplateFromCate.ResChildCount = objTemplateFromCate.ResChildCount -1
	d objTemplateFromCate.%Save()

	//保存移动文档
	d objTemplate.%Save()
	
	//保存移动文档展现相关数据
	s objEMRTemplate = ##class(EMRmeta.EMRTemplate).%OpenId(170)
	s objEMRTemplate.BindTemplateCategoryID = 66
	d objEMRTemplate.%Save()
	
	q "update suc"
}

/// 删除无效病历目录
/// d ##class(EMRservice.Tools.DailyWorkTool).DeleteTemplateCateByIDs()
ClassMethod DeleteKBCateByIDs() As %String
{

	s IDs = "1^3^4^21^6^11"
	
	for i=1:1:$l(IDs)
	{
		s tmpIdInfo = $p(IDs,"^",i)
		s (tmpId,startsubId,endsubId)=""
		
		s tmpId = $p(tmpIdInfo,"$",1)
		s startsubId = $p($p(tmpIdInfo,"$",2),"-",1)
		s endsubId = $p($p(tmpIdInfo,"$",3),"-",2)
		
		d ..DeleteKBCategoryData(tmpId,startsubId,endsubId)
		
		if ((startsubId="")&&(endsubId=""))
		{
			s sc = ##class(EMRmeta.KBCategory).%DeleteId(tmpId)
			if ($$$ISOK(sc))
			{
				w !,"Delete KBCategory RootData Suc:"_tmpId
			}
		}
	}
	
	q "export suc"
}

/// d ##class(EMRservice.Tools.DailyWorkTool).DeleteKBCategoryData(7,111,111)
/// d ##class(EMRservice.Tools.DailyWorkTool).DeleteKBCategoryData(6)
ClassMethod DeleteKBCategoryData(AParentID As %String, StartTCId As %String = "", EndTCId As %String = "")
{
	q:(AParentID="") 
	
	s kbcateId=""
	s:(StartTCId'="") kbcateId=(StartTCId-1)
	for 
	{
		s kbcateId=$o(^DHCEMRM.KBCategoryI("IdxParentId"," "_AParentID,kbcateId))
		q:(kbcateId = "")
		q:((EndTCId'="")&&(kbcateId>EndTCId))
		
		d ..DeleteKBCategoryData(kbcateId)
		
		s objKBCate=""
		s objKBCate = ##class(EMRmeta.KBCategory).%OpenId(kbcateId)
		continue:(objKBCate ="")
		
		s kbBaseCount = objKBCate.ResChildCount
		s KBCateName = objKBCate.Name
		
		s newCount="0"
		if (kbBaseCount>0)	
		{
			s newCount = ..DeleteKnowlegeBase(kbcateId)
		}
		
		if (newCount = 0)
		{
			d objKBCate.%Close()
			s sc = ##class(EMRmeta.KBCategory).%DeleteId(kbcateId)
			if ($$$ISOK(sc))
			{
				w !,"Delete KBCategory Suc:"_kbcateId
			}
		}	
	}
	q
}

/// w ##class(EMRservice.Tools.DailyWorkTool).DeleteKnowlegeBase(47)
ClassMethod DeleteKnowlegeBase(ACategoryID As %String) As %String
{
	q:(ACategoryID="")
	s objKBCategory = ##class(EMRmeta.KBCategory).%OpenId(ACategoryID)
	q:(objKBCategory = "")
	
	s kbaseId=""
	for
	{
		s kbaseId = $o(^DHCEMRM.KnowledgeBaseI("IndexCategoryId"," "_ACategoryID,kbaseId))
		q:(kbaseId="")
		
		s objKBase=""
		s objKBase = ##class(EMRmeta.KnowledgeBase).%OpenId(kbaseId)
		continue:(objKBase="")
		
		s kbtreeId=""
		for 
		{
			s kbtreeId =  $o(^DHCEMRM.KBTreeI("IdxKnowledgeBaseID"," "_kbaseId,kbtreeId))
			q:(kbtreeId="")
			
			s kbnodeId=""
			for
			{
				s kbnodeId=$o(^DHCEMRM.KBNodeI("IdxKBTreeID"," "_kbtreeId,kbnodeId))
				q:(kbnodeId="")
				//1删除知识库相关节点
				s kbnodeDiagId=""
				for
				{
					s kbnodeDiagId=$o(^DHCEMRM.KBNodeDiagnosI("IdxKBNodeID"," "_kbnodeId,kbnodeDiagId))
					q:(kbnodeDiagId="")
					
					s kbnodeDiagRuleId=""
					for
					{
						s kbnodeDiagRuleId = $o(^DHCEMRM.KBNodeDiagnosRuleI("IdxKBNodeDiagnosID"," "_kbnodeDiagId,kbnodeDiagRuleId))
						q:(kbnodeDiagRuleId="")
						
						s sc1 = ##class(EMRmeta.KBNodeDiagnosRule).%DeleteId(kbnodeDiagRuleId)
						if ($$$ISOK(sc1))
						{
							w !,"Delete KBNodeDiagnosRule Suc:"_kbnodeDiagRuleId
						}
						
					}
					
					s sc2 = ##class(EMRmeta.KBNodeDiagnos).%DeleteId(kbnodeDiagId)
					if ($$$ISOK(sc2))
					{
						w !,"Delete KBNodeDiagnos Suc:"_kbnodeDiagId
					}
				
				}
				
				
				//删除知识库节点
				s sc3 = ##class(EMRmeta.KBNode).%DeleteId(kbnodeId)
				
				if ($$$ISOK(sc3))
				{
					w !,"Delete KBNode Suc:"_kbnodeId
				}
			}
			
			
			//删除KBTree关联数据
			s kbtreeCTLocId=""
			for
			{
				s kbtreeCTLocId = $o(^DHCEMRM.KBTreeCTLocI("IdxKBTreeID"," "_kbtreeId,kbtreeCTLocId))
				q:(kbtreeCTLocId="")
				s sc4 = ##class(EMRmeta.KBTreeCTLoc).%DeleteId(kbtreeCTLocId)
				if ($$$ISOK(sc4))
				{
					w !,"Delete KBTreeCTLoc Suc:"_kbtreeId
				}
			}
			s kbtreeTitleRuleId=""
			for
			{
				s kbtreeTitleRuleId = $o(^DHCEMRM.KBTreeTitlesRuleI("IdxKBTreeID"," "_kbtreeId,kbtreeTitleRuleId))
				q:(kbtreeTitleRuleId="")
				s sc5 = ##class(EMRmeta.KBTreeTitlesRule).%DeleteId(kbtreeTitleRuleId)	
				if ($$$ISOK(sc5))
				{
					w !,"Delete kbtreeTitleRuleId Suc:"_kbtreeTitleRuleId
				}
			}
			
			s scktr = ##class(EMRmeta.KBTree).%DeleteId(kbtreeId)
			if ($$$ISOK(scktr))
			{
				
				w !,"Delete KBtree Suc:"_kbtreeId
			}
			
		}
		
		s sckb = ##class(EMRmeta.KnowledgeBase).%DeleteId(kbaseId)
		
		if ($$$ISOK(sckb))
		{
			
			w !,"Delete KBase Suc:"_kbaseId
			s objKBCategory.ResChildCount = objKBCategory.ResChildCount - 1
			d objKBCategory.%Save()
		}
		
	}
	
	s finalCount= objKBCategory.ResChildCount
	d objKBCategory.%Close()
	
	q finalCount
}

/// 更新病历目录
/// d ##class(EMRservice.Tools.DailyWorkTool).UpdateKBCateName()
ClassMethod UpdateKBCateName() As %String
{
	
	//14|EMR14 诊断证明
	//78|EMR140001 诊断证明书
	
	s updateInfo = "14|EMR14 诊断证明$78|EMR140001 诊断证明书"
	s updateInfo = updateInfo_"$"_"12|EMR12 出院小结$76|EMR120001 出院小结"
	for i=1:1:$l(updateInfo,"$")
	{
		s updatesub = $p(updateInfo,"$",i)
		s kbcId=$p(updatesub,"|",1)
		s newName=$p(updatesub,"|",2)
		
		s objKBCategory= ##class(EMRmeta.KBCategory).%OpenId(kbcId)
		s objKBCategory.Name = newName
		d objKBCategory.%Save()
		d objKBCategory.%Close()
	}
	q "update suc"
}

/// d ##class(EMRservice.Tools.DailyWorkTool).OneStepFixCateData()
ClassMethod OneStepFixCateData()
{
	
	d ##class(EMRservice.Tools.DailyWorkTool).MoveTemplateToRightCate()
	d ##class(EMRservice.Tools.DailyWorkTool).UpdateTemplateCateName()
	d ##class(EMRservice.Tools.DailyWorkTool).DeleteTemplateCateByIDs()
	
	d ##class(EMRservice.Tools.DailyWorkTool).UpdateKBCateName()
	d ##class(EMRservice.Tools.DailyWorkTool).DeleteKBCateByIDs()
}

/// d ##class(EMRservice.Tools.DailyWorkTool).GetTODeleteEMRCateTemplate()
ClassMethod GetTODeleteEMRCateTemplate()
{
	s docidstring ="" 
	s emrTemplatestring ="" 
	s tmpId=""
	for
	{
		s tmpId = $o(^DHCEMRM.EMRTemplateD(tmpId))
		q:(tmpId="")
		s objEMRTemplate = ##class(EMRmeta.EMRTemplate).%OpenId(tmpId)
		s bindTemplateID = objEMRTemplate.BindTemplateID
		continue:(bindTemplateID="")
		s live = $d(^DHCEMRM.TemplateD(bindTemplateID))
		
		if (live = 0)
		{
			//s docidstring = docidstring_","_objEMRTemplate.CategoryID
			
			//s emrTemplatestring = emrTemplatestring_","_objEMRTemplate.%Id()
			
			//1.取到EMRTemplate ID
			//3.查询ParCate 如果没有其他子项删除
			//4.清除病历模板组中的DocID
			//2.删除EMRTemplate obj
			s docId = objEMRTemplate.CategoryID
			s otherId1=""
			s otherId2=""
			
			s otherId1 = $o(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_docId,tmpId))
			s otherId2 = $o(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_docId,tmpId),-1)
			
			if ((otherId1 = "")&&(otherId2 = ""))
			{
				//删除emrcate
				//删除docgroup
				s groupId=""
				for
				{
					s groupId=$o(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx"," "_docId,groupId))
					q:(groupId="")
					s docingroupId=""
					for
					{
						s docingroupId=$o(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx"," "_docId,groupId,docingroupId))
						q:(docingroupId="")
						s objDocInGroup = ##class(EMRmeta.EMRDocRestriction.DocsInGroup).%OpenId(docingroupId)
						s checkDocId = objDocInGroup.DocID
						if (checkDocId = docId)
						{
							d ##class(EMRmeta.EMRDocRestriction.DocsInGroup).%DeleteId(docingroupId)
							//w !,"Delete Doc In Group:"_docingroupId
						}
					
					}
				}
				d ##class(EMRmeta.EMRTemplateCategory).%DeleteId(docId)
				d ##class(EMRmeta.EMRTemplate).%DeleteId(tmpId)
				//w !,"Delete DocId:"_docId
				//w !,"Delete EMRTemplate:"_tmpId
			}
			else
			{
				d ##class(EMRmeta.EMRTemplate).%DeleteId(tmpId)
				//w !,"Delete EMRTemplate:"_tmpId
			}
			
			
		}
		
	}
}

/// d ##class(EMRservice.Tools.DailyWorkTool).GetTODeleteEMRCateTemplate()
ClassMethod BuildData()
{
	///清除索引
	d ##class(EMRinstance.ECRecord).%PurgeIndices()
	d ##class(EMRinstance.InstanceData).%PurgeIndices()
	d ##class(EMRinstance.EMRLogs).%PurgeIndices()
	d ##class(EMRinstance.InstanceLog).%PurgeIndices()
	
	
	///生成索引
	d ##class(EMRinstance.ECRecord).%BuildIndices()
	d ##class(EMRinstance.InstanceData).%BuildIndices()
	d ##class(EMRinstance.EMRLogs).%BuildIndices()
	d ##class(EMRinstance.InstanceLog).%BuildIndices()
}

}
