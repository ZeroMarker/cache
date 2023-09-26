/// 类导入导出功能
/// 名称: 配合SVN导入导出类
/// 描述: 配合SVN导入导出类
/// 编写者：  zhaocz
/// 编写日期: 2012-10-18
Class web.DHCBL.BDP.ClassCheckIO Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：zhaocz
/// CreatDate: 2012-10-18
/// Description：批量导出类，每个类生产一个文件
/// Table：
/// Input：
ClassMethod BatchOut(FilePath As %String) As %String
{
	;d ##class(web.DHCBL.BDP.ClassCheckIO).BatchOut("E:\")
	n (FilePath)
	
	k ClassAry
	d ..SetClassAry(.ClassAry)
	
	d ##class(web.BDP.manager.CheckInOutClass).OutClass(.ClassAry, FilePath, .outinfo)
	w !
	w "导出类清单列表:",!
	zw outinfo
	
	k ClassAry
}

/// Creator：zhaocz
/// CreatDate: 2012-10-18
/// Description：批量导出类，每个类生产一个文件
/// Table：
/// Input：
ClassMethod BatchIn(FilePath As %String) As %String
{
	n (FilePath)
	;d ##class(web.DHCBL.BDP.ClassCheckIO).BatchIn("E:\")
	;d ##class(web.DHCBL.BDP.ClassCheckIO).BatchIn("E:\公司SVNClientServer\CPMCTClientServer\developer\源代码\基础维护\class")
	
	k ClassAry, myXMLFileAry
	
	d ..SetClassAry(.ClassAry)
	
	s myDirFlag = ##class(%File).DirectoryExists(FilePath)
	if (myDirFlag){
		;d ##class(%ResultSet).RunQuery("%File", "FileSet", FilePath)
		Set result = ##class(%ResultSet).%New("%File:FileSet")
		Do result.Execute(FilePath)
		While (result.Next()) {
			;Name:%String,Type:%String,Size:%Integer,DateCreated:%TimeStamp,DateModified:%TimeStamp,ItemName
			s myType = result.Data("Type")
			i (myType="F") {
				s myFileName = result.Data("ItemName")
				
				s myClassName = $e(myFileName,1, $l(myFileName)-4)
				
				i (('$d(ClassAry(myClassName)))&&($zconvert($e(myFileName,$l(myFileName)-3, $l(myFileName)) ,"U")=".XML")){
					s myXMLFileAry(result.Data("Name"))=""
				}else {
					b	;不导入的类和文件
				}
				
			}
		}
		k result
	}
	b	;;XMLFileAry
	d ##class(web.BDP.manager.CheckInOutClass).InClass(.myXMLFileAry, .ininfo)
	zw ininfo
	
	k ClassAry, myXMLFileAry
	
	q ""
}

/// Creator：zhaocz
/// CreatDate: 2012-10-18
/// Description：传入数组格式：  s ClassAry(classname)=""
/// Table：
/// Input：
ClassMethod SetClassAry(ByRef ClassAry As %String) As %String
{
	n (ClassAry)
	s ClassAry("web.DHCBL.BDP.ClassCheckIO")=""
	s ClassAry("web.BDP.manager.CheckInOutClass")=""
	s ClassAry("web.DHCBL.BDP.ClassIOchenying")=""
	
	q ""
}

ClassMethod SetFileAry()
{
}

}
