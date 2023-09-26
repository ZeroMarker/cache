Class EMRservice.Tools.InstanceSizeStat Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	统计指定就诊时间段内电子病历数据存储情况
/// Input:	AStartDate 开始日期，格式：2020-08-19
/// 		AEndDate 结束日期，格式：2020-08-20
/// Return:	统计信息输出在服务器txt文件中，具体路径执行后输出在Terminal
/// Debug：	d ##Class(EMRservice.Tools.InstanceSizeStat).CheckSize("2020-08-19","2020-08-20")
ClassMethod CheckSize(AStartDate, AEndDate) As %String
{
	s startTimeStamp = $h
	
	//检测是否可以输出文本文件，避免运行完统计结果无法正常输出
	s filetest = ..GetFileName()_"size_stat_test.txt"
	s streamtest = ##Class(%FileCharacterStream).%New()
	s streamtest.Filename = filetest
	d streamtest.WriteLine("stat test write file")
	s sc = streamtest.%Save()
	if (sc '= 1)
	{
		w !, "error on testing ouput file, please check disk operation privilege!"
		w !, "test out file name: "_filetest
		quit
	}
	
	// 转换统计日期格式
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s key = ""
	s totDayCount = endDate - startDate + 1
	s curDayCount = 0
	
	// 初始化需要的统计变量
	s arrAllDaySize = ##class(%ArrayOfDataTypes).%New()
	s arrAllDayCount = ##class(%ArrayOfDataTypes).%New()
	s arrAllInstSize = ##class(%ArrayOfDataTypes).%New()
	s arrAllTplSize = ##class(%ArrayOfDataTypes).%New()
	s arrAllTplCount = ##class(%ArrayOfDataTypes).%New()
	
	s arrOPDaySize = ##class(%ArrayOfDataTypes).%New()
	s arrOPDayCount = ##class(%ArrayOfDataTypes).%New()
	s arrOPInstSize = ##class(%ArrayOfDataTypes).%New()
	s arrOPTplSize = ##class(%ArrayOfDataTypes).%New()
	s arrOPTplCount = ##class(%ArrayOfDataTypes).%New()
	
	s arrEPDaySize = ##class(%ArrayOfDataTypes).%New()
	s arrEPDayCount = ##class(%ArrayOfDataTypes).%New()
	s arrEPInstSize = ##class(%ArrayOfDataTypes).%New()
	s arrEPTplSize = ##class(%ArrayOfDataTypes).%New()
	s arrEPTplCount = ##class(%ArrayOfDataTypes).%New()
	
	s arrIPDaySize = ##class(%ArrayOfDataTypes).%New()
	s arrIPDayCount = ##class(%ArrayOfDataTypes).%New()
	s arrIPInstSize = ##class(%ArrayOfDataTypes).%New()
	s arrIPTplSize = ##class(%ArrayOfDataTypes).%New()
	s arrIPTplCount = ##class(%ArrayOfDataTypes).%New()
	
	s arrHPDaySize = ##class(%ArrayOfDataTypes).%New()
	s arrHPDayCount = ##class(%ArrayOfDataTypes).%New()
	s arrHPInstSize = ##class(%ArrayOfDataTypes).%New()
	s arrHPTplSize = ##class(%ArrayOfDataTypes).%New()
	s arrHPTplCount = ##class(%ArrayOfDataTypes).%New()
	
	s arrCAAllDaySize = ##class(%ArrayOfDataTypes).%New()
	s arrCAAllDayCount = ##class(%ArrayOfDataTypes).%New()
	s arrCAAllInstSize = ##class(%ArrayOfDataTypes).%New()
	s arrCAAllTplSize = ##class(%ArrayOfDataTypes).%New()
	s arrCAAllTplCount = ##class(%ArrayOfDataTypes).%New()
	
	s arrCAOPDaySize = ##class(%ArrayOfDataTypes).%New()
	s arrCAOPDayCount = ##class(%ArrayOfDataTypes).%New()
	s arrCAOPInstSize = ##class(%ArrayOfDataTypes).%New()
	s arrCAOPTplSize = ##class(%ArrayOfDataTypes).%New()
	s arrCAOPTplCount = ##class(%ArrayOfDataTypes).%New()
	
	s arrCAEPDaySize = ##class(%ArrayOfDataTypes).%New()
	s arrCAEPDayCount = ##class(%ArrayOfDataTypes).%New()
	s arrCAEPInstSize = ##class(%ArrayOfDataTypes).%New()
	s arrCAEPTplSize = ##class(%ArrayOfDataTypes).%New()
	s arrCAEPTplCount = ##class(%ArrayOfDataTypes).%New()
	
	s arrCAIPDaySize = ##class(%ArrayOfDataTypes).%New()
	s arrCAIPDayCount = ##class(%ArrayOfDataTypes).%New()
	s arrCAIPInstSize = ##class(%ArrayOfDataTypes).%New()
	s arrCAIPTplSize = ##class(%ArrayOfDataTypes).%New()
	s arrCAIPTplCount = ##class(%ArrayOfDataTypes).%New()
	
	s arrCAHPDaySize = ##class(%ArrayOfDataTypes).%New()
	s arrCAHPDayCount = ##class(%ArrayOfDataTypes).%New()
	s arrCAHPInstSize = ##class(%ArrayOfDataTypes).%New()
	s arrCAHPTplSize = ##class(%ArrayOfDataTypes).%New()
	s arrCAHPTplCount = ##class(%ArrayOfDataTypes).%New()
	
	for date = startDate:1:endDate
	{
		s curDayCount = curDayCount + 1
		s tdate = $zd(date,3)
		w !, "date: "_tdate_", progress: "_curDayCount_"/"_totDayCount
		
		set admID =""
		for {
			set admID = $o(^PAADMi("PAADM_AdmDate",date,admID))
			quit:admID=""

			s admType=$p(^PAADM(admID),"^",2)
			continue:(admType = "")
			
			s AdmStatus=$P($g(^PAADM(admID)),"^",20)
			continue:(AdmStatus = "C")
			
			//w !, "admid: "_admID
			
			s emrDocID = ""
			for {
				s emrDocID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID", admID, emrDocID))
				q:(emrDocID = "")
				
				s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID", admID, emrDocID,""))
				continue:(ecRecordID = "")
				
				s happenDate = ""
				for {
					s happenDate = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecRecordID," SAVE",happenDate))
					q:(happenDate = "")
						
					s happenTime = ""
					for {	
						s happenTime = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecRecordID," SAVE",happenDate,happenTime))
						q:(happenTime = "")
						
						s childSub = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecRecordID," SAVE",happenDate,happenTime,""))
						s instanceID = ecRecordID_"||"_childSub
						s obj = ##class(EMRinstance.InstanceData).%OpenId(instanceID)
						continue:(obj = "")
						continue:(obj.Status '= "Save")
							
						s tdate = $zd(obj.CreateDate,3)
						s day = tdate
						s templateID = obj.RealTemplateID
						
						d SetInstSize(admType, obj.InstanceData.Size, templateID, day)
							
						s signLogID = ""
						for {
							s signLogID = $O(^DHCEMRCA.EMRSignLogI("IdxInstance"," "_instanceID, signLogID))
							q:(signLogID = "")
						
							s obj2 = ##class(EMRinstance.EMRSignLog).%OpenId(signLogID)
							continue:(obj2 = "")
							continue:(obj2.SignID = "")
							continue:(obj2.InstanceData = "")
							
							d SetCASize(admType, obj2.InstanceData.Size, templateID, day)
						}
					}
				}
			}
		}
	}
	
	//全部
	s fileall1 = ..GetFileName()_"size_stat_all_inst.txt"
	s fileall1ca = ..GetFileName()_"size_stat_all_instca.txt"
	s fileall2 = ..GetFileName()_"size_stat_all_tpl.txt"
	s fileall3 = ..GetFileName()_"size_stat_all_day.txt"
	
	//门诊
	s fileop1 = ..GetFileName()_"size_stat_op_inst.txt"
	s fileop1ca = ..GetFileName()_"size_stat_op_instca.txt"
	s fileop2 = ..GetFileName()_"size_stat_op_tpl.txt"
	s fileop3 = ..GetFileName()_"size_stat_op_day.txt"
	
	//急诊
	s fileep1 = ..GetFileName()_"size_stat_ep_inst.txt"
	s fileep1ca = ..GetFileName()_"size_stat_ep_instca.txt"
	s fileep2 = ..GetFileName()_"size_stat_ep_tpl.txt"
	s fileep3 = ..GetFileName()_"size_stat_ep_day.txt"
	
	//住院
	s fileip1 = ..GetFileName()_"size_stat_ip_inst.txt"
	s fileip1ca = ..GetFileName()_"size_stat_ip_instca.txt"
	s fileip2 = ..GetFileName()_"size_stat_ip_tpl.txt"
	s fileip3 = ..GetFileName()_"size_stat_ip_day.txt"
	
	//体检
	s filehp1 = ..GetFileName()_"size_stat_hp_inst.txt"
	s filehp1ca = ..GetFileName()_"size_stat_hp_instca.txt"
	s filehp2 = ..GetFileName()_"size_stat_hp_tpl.txt"
	s filehp3 = ..GetFileName()_"size_stat_hp_day.txt"
	
	d WriteFileInst(fileall1, fileall1ca, arrAllInstSize, arrCAAllInstSize)
	d WriteFileTpl(fileall2, arrAllTplSize, arrAllTplCount, arrCAAllTplSize, arrCAAllTplCount)
	d WriteFileDay(fileall3, arrAllDaySize, arrAllDayCount, arrCAAllDaySize, arrCAAllDayCount)
	
	d WriteFileInst(fileop1, fileop1ca, arrOPInstSize, arrCAOPInstSize)
	d WriteFileTpl(fileop2, arrOPTplSize, arrOPTplCount, arrCAOPTplSize, arrCAOPTplCount)
	d WriteFileDay(fileop3, arrOPDaySize, arrOPDayCount, arrCAOPDaySize, arrCAOPDayCount)
	
	d WriteFileInst(fileep1, fileep1ca, arrEPInstSize, arrCAEPInstSize)
	d WriteFileTpl(fileep2, arrEPTplSize, arrEPTplCount, arrCAEPTplSize, arrCAEPTplCount)
	d WriteFileDay(fileep3, arrEPDaySize, arrEPDayCount, arrCAEPDaySize, arrCAEPDayCount)
	
	d WriteFileInst(fileip1, fileip1ca, arrIPInstSize, arrCAIPInstSize)
	d WriteFileTpl(fileip2, arrIPTplSize, arrIPTplCount, arrCAIPTplSize, arrCAIPTplCount)
	d WriteFileDay(fileip3, arrIPDaySize, arrIPDayCount, arrCAIPDaySize, arrCAIPDayCount)
	
	d WriteFileInst(filehp1, filehp1ca, arrOPInstSize, arrCAHPInstSize)
	d WriteFileTpl(filehp2, arrHPTplSize, arrHPTplCount, arrCAHPTplSize, arrCAHPTplCount)
	d WriteFileDay(filehp3, arrHPDaySize, arrHPDayCount, arrCAHPDaySize, arrCAHPDayCount)
	
	w !
	w !,"AllPaitent: "_fileall1
	w !,"            "_fileall1ca
	w !,"            "_fileall2
	w !,"            "_fileall3
	
	w !,"OutPaitent: "_fileop1
	w !,"            "_fileop1ca
	w !,"            "_fileop2
	w !,"            "_fileop3
	
	w !,"EmergencyPat:"_fileop1
	w !,"            "_fileep1ca
	w !,"            "_fileep2
	w !,"            "_fileep3
	
	w !,"InPaitent:  "_fileip1
	w !,"            "_fileip1ca
	w !,"            "_fileip2
	w !,"            "_fileip3
	
	w !,"HealthPat:  "_filehp1
	w !,"            "_filehp1ca
	w !,"            "_filehp2
	w !,"            "_filehp3
	
	w !
	w !,"stat time span:"
	w !,"start: "_$zdt(startTimeStamp,3,1)
	w !,"end  : "_$zdt($h,3,1)
	
	w !,!,"stat finished! please download stat file!"
	
	quit ""
	
	
WriteFileInst(tfile1, tfile2, arrInstSize, arrCAInstSize)
	s stream1 = ##Class(%FileCharacterStream).%New()
	s stream1.Filename = tfile1
	s stream2 = ##Class(%FileCharacterStream).%New()
	s stream2.Filename = tfile2
	d stream1.WriteLine("大小(单位K)^数量")
	s key = ""
	for {
		s value = arrInstSize.GetNext(.key)
		q:(key = "")
		d stream1.WriteLine(key_"^"_value)
	}
	d stream2.WriteLine("大小(单位K)^数量")
	s key = ""
	for {
		s value = arrCAInstSize.GetNext(.key)
		q:(key = "")
		d stream2.WriteLine(key_"^"_value)
	}
	s sc = stream1.%Save()
	s sc2 = stream2.%Save()
	quit

WriteFileTpl(tfile1, arrTplSize, arrTplCount, arrCATplSize, arrCATplCount)
	s stream1 = ##Class(%FileCharacterStream).%New()
	s stream1.Filename = tfile1
	d stream1.WriteLine("病历名称^总大小(单位K)^总数量^平均大小(单位K)^CA总大小(单位K)^CA总数量^CA平均大小(单位K)")
	s key = ""
	for {
		s value = arrTplSize.GetNext(.key)
		q:(key = "")
		
		s count = arrTplCount.GetAt(key)
		s avg = +value
		s:(count > 0) avg = $fn(value / count,"",0)
		
		s value2 = arrCATplSize.GetAt(key)
		s count2 = arrCATplCount.GetAt(key)
		s avg2 = +value2
		s:(count2 > 0) avg2 = $fn(value2 / count2,"",0)
		
		s desc = key
		s obj2 = ##Class(EMRmeta.Template).%OpenId(key)
		s:(obj2 '= "") desc = desc_" "_obj2.Name
		
		d stream1.WriteLine(desc_"^"_value_"^"_count_"^"_avg_"^"_value2_"^"_count2_"^"_avg2)
	}
	s sc = stream1.%Save()
	//b
	quit

WriteFileDay(tfile1, arrDaySize, arrDayCount, arrCADaySize, arrCADayCount)
	s stream1 = ##Class(%FileCharacterStream).%New()
	s stream1.Filename = tfile1
	d stream1.WriteLine("日期^总大小(单位K)^总数量^CA总大小(单位K)^CA总数量")
	s key = ""
	for {
		s value = arrDaySize.GetNext(.key)
		q:(key = "")
		
		s count1 = arrDayCount.GetAt(key)
		s size2 = arrCADaySize.GetAt(key)
		s count2 = arrCADayCount.GetAt(key)
		d stream1.WriteLine(key_"^"_value_"^"_count1_"^"_size2_"^"_count2)
	}
	s sc = stream1.%Save()
	quit			

	
SetInstSize(admType, size, templateID, day)  
	s ksize = $fn(size / 1024, "", 0)
	if (ksize > 100)
	{
		s kint = $fn(ksize / 10, "", 0) * 10
	}
	else
	{
		s kint = ksize
	}
	
	d arrAllInstSize.SetAt(arrAllInstSize.GetAt(kint) + 1,kint)
	d arrAllDayCount.SetAt(arrAllDayCount.GetAt(day) + 1,day)
	d arrAllDaySize.SetAt(arrAllDaySize.GetAt(day) + ksize,day)
	d arrAllTplCount.SetAt(arrAllTplCount.GetAt(templateID) + 1, templateID)
	d arrAllTplSize.SetAt(arrAllTplSize.GetAt(templateID) + ksize,templateID)
	
	if (admType = "O")
	{
		d arrOPInstSize.SetAt(arrOPInstSize.GetAt(kint) + 1,kint)
		d arrOPDayCount.SetAt(arrOPDayCount.GetAt(day) + 1,day)
		d arrOPDaySize.SetAt(arrOPDaySize.GetAt(day) + ksize,day)
		d arrOPTplCount.SetAt(arrOPTplCount.GetAt(templateID) + 1, templateID)
		d arrOPTplSize.SetAt(arrOPTplSize.GetAt(templateID) + ksize,templateID)
	}
	elseif (admType = "E")
	{
		d arrEPInstSize.SetAt(arrEPInstSize.GetAt(kint) + 1,kint)
		d arrEPDayCount.SetAt(arrEPDayCount.GetAt(day) + 1,day)
		d arrEPDaySize.SetAt(arrEPDaySize.GetAt(day) + ksize,day)
		d arrEPTplCount.SetAt(arrEPTplCount.GetAt(templateID) + 1, templateID)
		d arrEPTplSize.SetAt(arrEPTplSize.GetAt(templateID) + ksize,templateID)
	}
	elseif (admType = "I")
	{
		d arrIPInstSize.SetAt(arrIPInstSize.GetAt(kint) + 1,kint)
		d arrIPDayCount.SetAt(arrIPDayCount.GetAt(day) + 1,day)
		d arrIPDaySize.SetAt(arrIPDaySize.GetAt(day) + ksize,day)
		d arrIPTplCount.SetAt(arrIPTplCount.GetAt(templateID) + 1, templateID)
		d arrIPTplSize.SetAt(arrIPTplSize.GetAt(templateID) + ksize,templateID)
	}
	elseif (admType = "H")
	{
		d arrHPInstSize.SetAt(arrHPInstSize.GetAt(kint) + 1,kint)
		d arrHPDayCount.SetAt(arrHPDayCount.GetAt(day) + 1,day)
		d arrHPDaySize.SetAt(arrHPDaySize.GetAt(day) + ksize,day)
		d arrHPTplCount.SetAt(arrHPTplCount.GetAt(templateID) + 1, templateID)
		d arrHPTplSize.SetAt(arrHPTplSize.GetAt(templateID) + ksize,templateID)
	}
	quit
	
SetCASize(admType, size, templateID, day) 
	if (size < 100) quit
	 
	s ksize = $fn(size / 1024, "", 0)
	if (ksize > 100)
	{
		s kint = $fn(ksize / 10, "", 0) * 10
	}
	else
	{
		s kint = ksize
	}
	
	d arrCAAllInstSize.SetAt(arrCAAllInstSize.GetAt(kint) + 1,kint)
	d arrCAAllDayCount.SetAt(arrCAAllDayCount.GetAt(day) + 1,day)
	d arrCAAllDaySize.SetAt(arrCAAllDaySize.GetAt(day) + ksize,day)
	d arrCAAllTplCount.SetAt(arrCAAllTplCount.GetAt(templateID) + 1, templateID)
	d arrCAAllTplSize.SetAt(arrCAAllTplSize.GetAt(templateID) + ksize,templateID)
	
	if (admType = "O")
	{
		d arrCAOPInstSize.SetAt(arrCAOPInstSize.GetAt(kint) + 1,kint)
		d arrCAOPDayCount.SetAt(arrCAOPDayCount.GetAt(day) + 1,day)
		d arrCAOPDaySize.SetAt(arrCAOPDaySize.GetAt(day) + ksize,day)
		d arrCAOPTplCount.SetAt(arrCAOPTplCount.GetAt(templateID) + 1, templateID)
		d arrCAOPTplSize.SetAt(arrCAOPTplSize.GetAt(templateID) + ksize,templateID)
	}
	elseif (admType = "E")
	{
		d arrCAEPInstSize.SetAt(arrCAEPInstSize.GetAt(kint) + 1,kint)
		d arrCAEPDayCount.SetAt(arrCAEPDayCount.GetAt(day) + 1,day)
		d arrCAEPDaySize.SetAt(arrCAEPDaySize.GetAt(day) + ksize,day)
		d arrCAEPTplCount.SetAt(arrCAEPTplCount.GetAt(templateID) + 1, templateID)
		d arrCAEPTplSize.SetAt(arrCAEPTplSize.GetAt(templateID) + ksize,templateID)
	}
	elseif (admType = "I")
	{
		d arrCAIPInstSize.SetAt(arrCAIPInstSize.GetAt(kint) + 1,kint)
		d arrCAIPDayCount.SetAt(arrCAIPDayCount.GetAt(day) + 1,day)
		d arrCAIPDaySize.SetAt(arrCAIPDaySize.GetAt(day) + ksize,day)
		d arrCAIPTplCount.SetAt(arrCAIPTplCount.GetAt(templateID) + 1, templateID)
		d arrCAIPTplSize.SetAt(arrCAIPTplSize.GetAt(templateID) + ksize,templateID)
	}
	elseif (admType = "H")
	{
		d arrCAHPInstSize.SetAt(arrCAHPInstSize.GetAt(kint) + 1,kint)
		d arrCAHPDayCount.SetAt(arrCAHPDayCount.GetAt(day) + 1,day)
		d arrCAHPDaySize.SetAt(arrCAHPDaySize.GetAt(day) + ksize,day)
		d arrCAHPTplCount.SetAt(arrCAHPTplCount.GetAt(templateID) + 1, templateID)
		d arrCAHPTplSize.SetAt(arrCAHPTplSize.GetAt(templateID) + ksize,templateID)
	}
	quit
}

/// d ##Class(EMRservice.Tools.InstanceSizeStat).CheckInstSize()
ClassMethod CheckInstSize()
{
	s arrSize = ##class(%ArrayOfDataTypes).%New()
	s arrTplSize = ##class(%ArrayOfDataTypes).%New()
	s arrTplCount = ##class(%ArrayOfDataTypes).%New()
	
	s ecRecordID = ""
	for {
		s ecRecordID = $O(^DHCEMRI.ECRecordD(ecRecordID))
		q:(ecRecordID = "")
		
		w !, ecRecordID
		s listNo = ""
		for {
			s listNo = $o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID,listNo))
			q:(listNo = "")
			
			s sub = $o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID,listNo,""))
			s instID = ecRecordID_"||"_sub
			
			s obj = ##Class(EMRinstance.InstanceData).%OpenId(instID)
			continue:(obj = "")
			continue:(obj.Status '= "Save")
			
			s ksize = $fn(obj.InstanceData.Size / 1024, "", 0)
			s kint = ksize \ 10
			
			s count = arrSize.GetAt(kint) + 1
			d arrSize.SetAt(count,kint)
			
			s tplCount = arrTplCount.GetAt(obj.RealTemplateID) + 1
			d arrTplCount.SetAt(tplCount, obj.RealTemplateID)
			
			s tplSize = arrTplSize.GetAt(obj.RealTemplateID) + ksize
			d arrTplSize.SetAt(tplSize,obj.RealTemplateID)
		}
	}
	
	s file1 = ..GetFileName()_"statresult1.txt"
	s file2 = ..GetFileName()_"statresult2.txt"
	s file3 = ..GetFileName()_"statresult3.txt"
	
	s stream1 = ##Class(%FileCharacterStream).%New()
	s stream1.Filename = file1
	s stream2 = ##Class(%FileCharacterStream).%New()
	s stream2.Filename = file2
	
	d stream1.WriteLine("大小(单位K)^数量")
	s key = ""
	for {
		s value = arrSize.GetNext(.key)
		q:(key = "")
		
		d stream1.WriteLine(key_"^"_value)
	}
	
	d stream2.WriteLine("病历名称^总大小(单位K)^总数量^平均大小(单位K)")
	s key = ""
	for {
		s value = arrTplSize.GetNext(.key)
		q:(key = "")
		
		s count = arrTplCount.GetAt(key)
		s avg = value
		s:(count > 0) avg = $fn(value / count,"",0)
		
		s desc = key
		s obj2 = ##Class(EMRmeta.Template).%OpenId(key)
		s:(obj2 '= "") desc = desc_" "_obj2.Name
		
		d stream2.WriteLine(desc_"^"_value_"^"_count_"^"_avg)
	}
	
	b "s"
	s sc = stream1.%Save()
	s sc = stream2.%Save()
	
	w !,"file1:"_file1
	w !,"file2:"_file2
}

ClassMethod GetKSize(count) As %Integer
{
	q $fn(count / 1024,"",0)
}

ClassMethod GetFileName() As %String
{
 	s AOSString = ##class(%SYSTEM.Version).GetOS()
 	s WindowsFlag =$Find(AOSString,"Windows") 
 	S UNIXFlag =$Find(AOSString,"UNIX") 
	set FilePath=$ZUTIL(12,"")_"Temp"
	if '##Class(%Library.File).DirectoryExists(FilePath)
	{
		s Result = ##Class(%Library.File).CreateDirectoryChain(FilePath) 
	}
	
	if (UNIXFlag > 0)
	{	q FilePath_"/"}
	else
	{	q FilePath_"\"}
}

}
