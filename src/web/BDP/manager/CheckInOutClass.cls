/// 类的导出功能
/// 类的导入功能
/// 导入类的恢复功能
Class web.BDP.manager.CheckInOutClass Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 按照时间戳导出一个类
/// 增加时间戳对比功能
ClassMethod OutSingleClass(ClassName As %String, OutPath As %String) As %String
{
	;d ##class(web.BDP.manager.CheckInOutClass).OutSingleClass("web.BDP.manager.CheckInOutClass.cls","E:")
	n (ClassName, OutPath)
	s myoutFlag = 0
	q:(ClassName="") myoutFlag
	q:(OutPath="") myoutFlag
	
	k ^TMPBDP.TempExport
	
	s myClassName = ClassName
	s mySysClsName = ClassName
	s myLeftStr = $e(ClassName,$l(ClassName)-3,$l(ClassName))
	s myLeftStr = $zconvert(myLeftStr,"U")
	i (myLeftStr'=".CLS") {
		s myClassName = ClassName_".CLS"
	}else{
		s mySysClsName = $e(ClassName,1,$l(ClassName)-4)
	}
	s:($e(OutPath,$l(OutPath),$l(OutPath))'="\") OutPath=OutPath_"\"
	
	; 注意： 文件名称、Global名称、时间戳等都使用不带 .cls的类名称；
	; 只有在导出类的函数中使用 带 .cls的
	s myFileName = OutPath_mySysClsName_".xml"
	;^DHC.BDP.Class("LastEditTime",ClassName)=""
	;^DHC.BDP.Class("OutClassTime",ClassName)=""
	
	s myTimeChanged = $$$defClassKeyGet(mySysClsName, $$$cCLASStimechanged)
	s mylastOutTime = $g(^DHC.BDP.ClassD(mySysClsName,"LastEditTime"))
	
	if ((+myTimeChanged>0)&&(myTimeChanged'=mylastOutTime)){
		;mySysClsName
		d ..SetIOTimestamp(mySysClsName)
		;s ^DHC.BDP.ClassD(ClassName,"LastEditTime") = myTimeChanged
		;s ^DHC.BDP.ClassD(ClassName, "OutClassTime") = $zts
		;为了导出Global需要
		m ^TMPBDP.TempExport(mySysClsName) = ^DHC.BDP.ClassD(mySysClsName)
		;TMPBDP.TempExport.GBL _",TMPBDP.TempExport.GBL"
		d $SYSTEM.OBJ.Export(myClassName_",TMPBDP.TempExport.GBL",myFileName)
		d ..WriteClassInLog(myClassName, "Out")
		s myoutFlag = 1
	}
	
	k ^TMPBDP.TempExport
	
	q myoutFlag
}

/// 
/// 按照时间戳导出一个CSP/CSR
/// 增加时间戳对比功能
/// 规则： 时间按照编辑时间，但是导出的csp文件
ClassMethod OutSingleCSP(CSPName As %String, OutPath As %String) As %String
{
	;d ##class(web.BDP.manager.CheckInOutClass).OutSingleCSP("web.BDP.manager.CheckInOutClass.cls","E:")
	n (CSPName, OutPath)
	s myoutFlag = 0
	q:(CSPName="") myoutFlag
	q:(OutPath="") myoutFlag
	
	k ^TMPBDP.TempExport
	
	s myClassName = ClassName
	s mySysClsName = ClassName
	s myLeftStr = $e(ClassName,$l(ClassName)-3,$l(ClassName))
	s myLeftStr = $zconvert(myLeftStr,"U")
	i (myLeftStr'=".CLS") {
		s myClassName = ClassName_".CLS"
	}else{
		s mySysClsName = $e(ClassName,1,$l(ClassName)-4)
	}
	s:($e(OutPath,$l(OutPath),$l(OutPath))'="\") OutPath=OutPath_"\"
	
	; 注意： 文件名称、Global名称、时间戳等都使用不带 .cls的类名称；
	; 只有在导出类的函数中使用 带 .cls的
	s myFileName = OutPath_mySysClsName_".xml"
	;^DHC.BDP.Class("LastEditTime",ClassName)=""
	;^DHC.BDP.Class("OutClassTime",ClassName)=""
	
	s myTimeChanged = $$$defClassKeyGet(mySysClsName, $$$cCLASStimechanged)
	s mylastOutTime = $g(^DHC.BDP.ClassD(mySysClsName,"LastEditTime"))
	
	if ((+myTimeChanged>0)&&(myTimeChanged'=mylastOutTime)){
		;mySysClsName
		d ..SetIOTimestamp(mySysClsName)
		;s ^DHC.BDP.ClassD(ClassName,"LastEditTime") = myTimeChanged
		;s ^DHC.BDP.ClassD(ClassName, "OutClassTime") = $zts
		;为了导出Global需要
		m ^TMPBDP.TempExport(mySysClsName) = ^DHC.BDP.ClassD(mySysClsName)
		;TMPBDP.TempExport.GBL _",TMPBDP.TempExport.GBL"
		d $SYSTEM.OBJ.Export(myClassName_",TMPBDP.TempExport.GBL",myFileName)
		d ..WriteClassInLog(myClassName, "Out")
		s myoutFlag = 1
	}
	
	k ^TMPBDP.TempExport
	
	q myoutFlag
}

ClassMethod InSingleClass(FileName As %String, ByRef ClassName As %String) As %String
{
	;d ##class(web.BDP.manager.CheckInOutClass).InSingleClass("E:\web.DHCBL.Test.Test.xml")
	;d ##class(web.BDP.manager.CheckInOutClass).InSingleClass("")
	n (FileName, ClassName)
	;新增类，直接导入同时记录时间戳  1
	;xml文件中的日期大于本地类的日期,导入类, 同时保存日志？   				101
	;xml文件中的日期小于本地类的日期，不能导入			102
	; xml文件中没有编辑时间，不能导入				103
	;第一步：从文件中读出类的名称 ;
	;判断类是否已经存在
	
	k myClsAry
	k myGlobalData
	k myGlobalAry
	k ^TMPBDP.TempExport
	s myInStatus = 0
	
	Set sc = ##class(%XML.TextReader).ParseFile(FileName,.reader)
	If ($$$ISOK(sc)) {
        // Read all elements within the document
        ;Rewind
        While (reader.Read()) {
	        if (reader.NodeType = "element") {
	            if (reader.Name="Class") {
					If (reader.MoveToAttributeName("name")) {
						s myClsAry(reader.Value)=""
						Write "name = ",reader.Value,!
					}
				}
				if ((reader.Name="Sub")) {
					;reader.Depth=4 Global名称
					;reader.Depth=5 Global第一个节点名称==类名称
					;reader.Depth=6  Global第二个节点名称，LastEditTime, OutClassTime
					i (reader.Depth=4) {
						d reader.Read()
						s myFirstNode = reader.Value
					}elseif (reader.Depth=5) {
						d reader.Read()
						s mySecondNode = reader.Value
					}elseif (reader.Depth=6) {
						d reader.Read()
						s myThirdNode = reader.Value
					}
					s mynode = $g(myFirstNode)_","_$g(mySecondNode)_","_$g(myThirdNode)
					if ($g(myFirstNode)'="")&&($g(mySecondNode)'="")&&($g(myThirdNode)'="") {
						s myGlobalAry($g(myFirstNode),$g(mySecondNode),$g(myThirdNode)) = ""
					}
				}
				if (reader.Name="Data") {
					if (reader.Depth=6) {
						d reader.Read()
						s myData = reader.Value
						s myGlobalData($g(mySecondNode),$g(myThirdNode)) = myData
					}
				}
			}
			
		}
		s reader= ""
		
		s myClassName = ""
		for {
			s myClassName = $o(myClsAry($g(myClassName)))
			q:(myClassName="")
			s ClassName = myClassName
			if '$$$defClassDefined(myClassName) {
				;b	;导入新类
				d $SYSTEM.OBJ.Load(FileName)
				d ..SetIOTimestamp(myClassName)
				s myInStatus = 1
			}else {
				;如果已经存在
				
				s myLastImportTime = $g(myGlobalData(myClassName, "LastEditTime"))
				s myTimeChanged = $$$defClassKeyGet(myClassName, $$$cCLASStimechanged)
				i (myLastImportTime'="") {
					s myLastDate = + myLastImportTime
					s myLastTime = +$p(myLastImportTime,",",2)
					s myChangedDate = +myTimeChanged
					s myChangedTime = +$p(myTimeChanged,",",2)
					;b	;类已经存在 w ((myLastDate>myChangedDate)||((+myLastDate = +myChangedDate)&&(myLastTime>myChangedTime)))
					;导入条件: xml编辑时间> 大于类的编辑时间
					if ((myLastDate>myChangedDate)||((+myLastDate = +myChangedDate)&&(myLastTime>myChangedTime))) {
						;b	;;;导入 XML文件中的最后编辑时间大于本地的类时间，需要导入，同时做备份
						d $SYSTEM.OBJ.Load(FileName)
						d ..SetIOTimestamp(myClassName, "In")
						d ..WriteClassInLog(myClassName, "In")
						s myInStatus = 101
					}else{
						;不导入
						s myInStatus = 102
						;b	;本地的时间比XML文件的时间大，不能导入写日志
					}
				}else{
					s myInStatus = 103
					;b	;不导入; 没有编辑时间，不能导入
					
				}
			}
		}
	}else {
		
		d $SYSTEM.OBJ.Load(FileName)
		w !
		w "XML parse File Name = "_FileName,!
		w " error ="_sc
		b	;;TextReader Error
	}
	
	;b	;;Last
	k myClsAry
	k myGlobalData
	k myGlobalAry
	k ^TMPBDP.TempExport
	
	q myInStatus
}

/// 
/// Creator：zhaocz
/// CreatDate: 2012-10-18
/// Description：批量导出类，每个类生成一个单独的文件
/// 传入数组格式：  carray(classname)=""
/// 
/// Table：
/// Input：
/// 返回信息： 本函数返回导出类的数量，  OutClassInfo 返回导出类的信息
ClassMethod OutClassByPackage(PackageName As %String, OutPath As %String, ByRef OutClassInfo As %String) As %String
{
	n (PackageName, OutPath, OutClassInfo)
	
	d ..GetClassAryByPackage(PakageName, .ClassAry)
	s myClassNum = ..OutClass(.ClassAry, myClassDir, .outinfo)
	q myClassNum
}

ClassMethod GetClassAryByPackage(PackageName As %String, ByRef ClassAry As %String) As %String
{
	n (PackageName, ClassAry)
	s myClassName = PackageName
	s myPlen = $l(PackageName)
	;$$$defClassNext
	for {
		s myClassName = $$$defClassNext(myClassName)
		
		q:(myClassName="")
		q:'($e(myClassName,1,myPlen) = PackageName)
		s ClassAry(myClassName) = ""
		
	}
	q 1
}

/// 
/// Creator：zhaocz
/// CreatDate: 2012-10-18
/// Description：批量导出类，每个类生成一个单独的文件
/// 传入数组格式：  carray(classname)=""
/// 
/// Table：
/// Input：
/// 返回信息： 本函数返回导出类的数量，  OutClassInfo 返回导出类的信息
ClassMethod OutClass(ByRef ClassArray As %String, OutPath As %String, ByRef OutClassInfo As %String) As %String
{
	n (ClassArray, OutPath, OutClassInfo)
	s myOutNum = 0
	s myClassName = ""
	
	k ^TMPBDP.TempExport
	
	for {
		s myClassName = $o(ClassArray(myClassName))
		q:(myClassName="")
		s outflag = ..OutSingleClass(myClassName, OutPath)
		if (+outflag){
			s myOutNum = myOutNum+1
			s myOutInfo(myOutNum)=myClassName
		}
	}
	if (+myOutNum>0){
		s myOutInfo = "-------共有"_myOutNum _"类被导出, 请提交SVN!-------"
	}else{
		s myOutInfo = "没有类被导出!"
	}
	
	m OutClassInfo = myOutInfo
	k ^TMPBDP.TempExport
	q myOutNum
}

ClassMethod InClass(ByRef XMLFileAry As %String, ByRef InXMLInfo As %String) As %String
{
	n (XMLFileAry, InXMLInfo)
	
	s myFileName = ""
	s myXMLInfo("New") = 0
	s myXMLInfo("Update") = 0
	s myXMLInfo("NoUpdate") = 0
	s myXMLInfo("XMLNoDate") = 0
	s myXMLInfo("ErrorClass") = 0
	for {
		s myFileName = $o(XMLFileAry(myFileName))
		q:(myFileName="")
		
		s myInStatus = ..InSingleClass(myFileName, .myClassName)
		
		;新增类，直接导入同时记录时间戳  1
		;xml文件中的日期大于本地类的日期,导入类, 同时保存日志？   				101
		;xml文件中的日期小于本地类的日期，不能导入			102
		; xml文件中没有编辑时间，不能导入				103
		if (myInStatus=1) {
			s myXMLInfo("New", $i(myXMLInfo("New"))) = $g(myClassName)
			;s myXMLInfo("New")
		}elseif (myInStatus=101){
			s myXMLInfo("Update", $i(myXMLInfo("Update")))= $g(myClassName)
		}elseif (myInStatus=102){
			s myXMLInfo("NoUpdate", $i(myXMLInfo("NoUpdate")))= $g(myClassName)
		}elseif (myInStatus=103){
			s myXMLInfo("XMLNoDate", $i(myXMLInfo("XMLNoDate")))= $g(myClassName)
		}else {
			s myXMLInfo("ErrorClass", $i(myXMLInfo("ErrorClass")))= myFileName
		}
		;b	;;;AryFile
	}
	m InXMLInfo = myXMLInfo
	q ""
}

/// 设置导入导出时间戳， 根据类的属性设置
/// 要求类名称后面不带 .Cls等信息
/// InOutFlag = In,  Out, 
/// 如果导入类信息一定要备份,按照时间戳备份
ClassMethod SetIOTimestamp(ClassName As %String, InOutFlag As %String = "Out") As %String
{
	n (ClassName, InOutFlag)
	;mySysClsName
	q:('$$$defClassDefined(ClassName)) $$$OK
	
	s myTimeChanged = $$$defClassKeyGet(ClassName, $$$cCLASStimechanged)
	s ^DHC.BDP.ClassD(ClassName,"LastEditTime") = myTimeChanged
	s myInOutTime = $zts
	i InOutFlag="Out"{
		s ^DHC.BDP.ClassD(ClassName, "OutClassTime") = myInOutTime
	}elseif (InOutFlag="In"){
		s ^DHC.BDP.ClassD(ClassName, "InClassTime") = myInOutTime
		;m ^DHC.BDP.ClassDefBackD(ClassName, "InClassLog",myInOutTime) = ^oddDEF(ClassName)
	}
	
	q $$$OK
}

/// 写类导入日志函数
ClassMethod WriteClassInLog(ClassName As %String, InOutFlag As %String = "Out") As %String
{
	n (ClassName, InOutFlag)
	; 类名称, 导入(无子Global)或导出(有子Global)标志, 导入导出时间戳, 导入导出人(获取计算机的名称)
	
	s myInOutTime = $zts
	s myComputerName = ""
	s ^DHC.BDP.ClassLogD(ClassName, InOutFlag, myInOutTime) = $lb(ClassName, InOutFlag, myInOutTime, myComputerName)
	if (InOutFlag="In") {
		m ^DHC.BDP.ClassLogD(ClassName,"DefBack",myInOutTime) = ^oddDEF(ClassName)
	}
}

ClassMethod OutTest() As %String
{
	;d ##class(web.BDP.manager.CheckInOutClass).OutTest()
	k ClassAry
	s ClassAry("web.DHCBL.Test.Test")=""
	;s ClassAry("")=""
	w ..OutClass(.ClassAry, "E:\", .outinfo)
	
	k ClassAry
}

ClassMethod InTest() As %String
{
	;d ##class(web.BDP.manager.CheckInOutClass).InTest()
	;d ##class(web.BDP.manager.CheckInOutClass).InSingleClass("E:\web.DHCBL.Test.Test.xml")
	;d ##class(web.BDP.manager.CheckInOutClass).InSingleClass("E:\web.DHCBL.Test.Test.xml")
	;E:\公司SVNClientServer\CPMCTClientServer\developer\源代码\基础维护\class\web.DHCBL.CT.CTAcuity.xml
	k myaryfile
	s myaryfile("E:\公司SVNClientServer\CPMCTClientServer\developer\源代码\基础维护\class\web.DHCBL.CT.CTAcuity.xml")=""
	s myaryfile("E:\公司SVNClientServer\CPMCTClientServer\developer\源代码\基础维护\class\web.DHCBL.CT.CTCarPrvTp.xml")=""
	d ..InClass(.myaryfile, .info)
	b	;;
	k myaryfile
}

}
