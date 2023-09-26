Class web.INMTestComm Extends %RegisteredObject
{

/// 测试测试2
Parameter aa As STRING = "episodeID";

/// listnext测试使用方法
/// d ##class(web.INMTestComm).test3()
ClassMethod test3() As %String
{
	SET list=$LISTBUILD("Red","Blue",,"Green")
   	SET ptr=0,count=0
   	while $LISTNEXT(list,ptr,value){
	    s count=count+1
	    continue:$d(value)=0
	    w !,count,":",ptr,": ",value
   	}
}

/// MaxString
ClassMethod test1() As %String
{
	f i=1:1:1{
		w i	
	}
	
	q ""
	s a=""
	f i=1:1:3641144{
		s a=a_"1"
	}
	s ^TMP("llulin")=a
}

// w ##class(web.INMTestComm).test2()

ClassMethod test2(parr As %String) As %String
{
	q 1
	w $L(parr)
}

/// w ##class(web.INMTestComm).Password("demo")
ClassMethod Password(userCode As %String) As %String
{
	s ok="",aa="",okk=""
	s userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(userCode,"U"),""))
	q:$g(userId)="" -1
	s pin=$p($g(^SSU("SSUSR",userId)),"^",3)
	s leng=$l(pin)
	q:leng>12 ""
	f pp=1:1:leng q:okk="1"  d
	.s ppp=..Passco(aa,pp,pin)
	.s aa=$p(ppp,"#",1)
	.s pp=$p(ppp,"#",2)
	.s okk=$p(ppp,"#",3)
	q aa
}

ClassMethod Passco(aa As %String, pp As %String, pin As %String) As %String
{
	s ok="",okk=""
	s p=42
	f d=p:1:126 q:ok="1"  d
	.s h=$c(d)
	.i aa="" s ppp=h
	.e  s ppp=aa_""_h
	.s len=$l(ppp)
	.s pass=##class(web.SSUser).Encrypt(ppp)
	.i pass=pin s ok="1",okk="1"
	.i $e(pass,1,len)=$e(pin,1,len) s ok="1"
	.i ok'="1" s ppp=aa q
	.i aa="" s aa=h
	.e  s aa=aa_""_h
	q aa_"#"_pp_"#"_okk
}

/// Creator：      gaoshan
/// CreatDate：    2021-04-15
/// Description:： 初始化文件夹，不存在就新建
/// Others：       w ##class(Nur.NIS.Common.Utils).InitDirectory("/tmp/gaoshan")
ClassMethod InitDirectory(dir) As %Status
{
	s exflag = ##class(%Library.File).DirectoryExists(dir)
	if (exflag=0)
	{
		d ##class(%Library.File).CreateDirectory(dir)
	}
	q 1
}

/// d ##class(Nur.NIS.Common.Utils).GetPkgListByProject("gaoshan")
ClassMethod GetPkgListByProject(ByRef array As %String, projectName)
{
	s projectName = $zcvt(projectName,"U")
	#; 查找对应工程下的后台类
	s sqlString = " SELECT Name,Type FROM %Studio.ProjectItem WHERE %ALPHAUP(Project) = '"_projectName_"' AND Type in ('PKG','CLS') "
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Set sc=result.Prepare(sqlString)
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	Set sc=result.Execute()
  	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
  	While result.Next(.sc) {
	  	s type = result.Data("Type")
	  	s name = result.Data("Name")
	  	s array(type,name) = name
  	}
}

/// Creator：      gaoshan
/// CreatDate：    2020-2-5
/// Description:   导出包下所有类为xml文件到指定目录下
/// Table：        
/// Input：        fileNames：包名,多个包名以","分割  path：web服务器路径(c:\tmp\)。
/// Output：       
/// Return：       
/// Others：      w ##class(Nur.NIS.Common.Utils).ExportClassByPackage("CF.NUR.NIS,Nur.NIS","/tmp/gaoshan/")
ClassMethod ExportClassByPackage(fileNames As %String, path As %String)
{
	s $zt="Err"
	d ..InitDirectory(path)
	s splitChar = ","
	s count=$l(fileNames,splitChar)
	for i=1:1:count{
		s packageName=$p(fileNames,splitChar,i)
		s arrarylistcls=""
	    s clsname="",clspath=""
		d $system.OBJ.GetPackageList(.arrarylistcls,packageName)
		s clskey=""
		for
		{
			s clskey=$o(arrarylistcls(clskey))
			q:clskey=""
			s clsname=clskey_".cls"
			s clspath=path_clskey_".xml"
			d $system.OBJ.Export(clsname,clspath)
		}
	}
	q 0
Err
	q $ze
}

/// Creator：      gaoshan
/// CreatDate：    2020-2-5
/// Description:   导出文件到对应的目录下,类导出xml文件
/// Input:         fileNames:以","分割的变量   path:web服务器存放导出XML文件的路径
/// Output：       
/// Return：       
/// Others：       w ##class(Nur.NIS.Common.Utils).ExportClassByName("Nur.NIS.Common.ConstVal,Nur.NIS.Common.CommonDataUtils","/tmp/gaoshan/")
ClassMethod ExportClassByName(fileNames As %String = "", path As %String = "")
{
   s ^tmp("gs",1) = $lb(fileNames, path)
   s $zt="Error"
   d ..InitDirectory(path)
   s delim = ","
   s count =$l(fileNames,delim)
   for i=1:1:count
   {
  		s classKey=$p(fileNames,delim,i)
  		s className = classKey_".cls"
		s clspath = path_classKey_".xml"
  		d $system.OBJ.Export(className,clspath)
   }
   q 0
Error
   q $ze
}

/// Creator：      gaoshan
/// CreatDate：    2020-3-2
/// Description:   导出工程下所有类为xml文件到指定目录下
/// Table：        
/// Input：        fileNames：工程名字,多个以","分割  path：web服务器路径(c:\tmp\)。
/// Output：       
/// Return：       
/// Others：      w ##class(web.INMTestComm).ExportClassByProject("DHCINM","E:\DHCINM\")
ClassMethod ExportClassByProject(fileNames As %String, path As %String)
{
	s $zt="Err"
	d ..InitDirectory(path)
	s splitChar = ","
	s count=$l(fileNames,splitChar)
	for i=1:1:count
	{
		s projectName=$p(fileNames,splitChar,i)
		s arrarylist=""
		d ..GetPkgListByProject(.arrarylist,projectName)
		
		s type = ""
		for
		{
			s type = $o(arrarylist(type))
			q:type=""
			s key = ""
			for
			{
				s key = $o(arrarylist(type,key))
				q:key=""
				i type = "PKG" d ..ExportClassByPackage(key,path)	
				i type = "CLS" d ..ExportClassByName(key,path)
			}
		}
	}
	q 0
Err
	q $ze
}

// d ##class(web.INMTestComm).DeleteErrorArg()

ClassMethod DeleteErrorArg() As %String
{
	s subId="" f  s subId=$O(^DHCINM.Arg.MgArrangeSubD(subId)) q:subId=""  d
	.s subObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(subId)
	.q:'$IsObject(subObj)
	.q:'$IsObject(subObj.ArgRowDR)
	.q:'$IsObject(subObj.ArgPerDR)
	.i (subObj.ArgPerDR.%Id()'=subObj.ArgRowDR.ArgPerDR.%Id()) d
	..d subObj.%DeleteId(subId)
	w "执行完成"
}

// d ##class(web.INMTestComm).ChangeErrorArg()

ClassMethod ChangeErrorArg() As %String
{
	//Arg_StTime1 IS NULL AND Arg_PostDR->Post_DR->Post_Type!="H"
	s id="" f  s id=$O(^CF.DHCINM.DB.MgArgWardPostD(id)) q:id=""  d
	.s obj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(id)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.PostDR)
	.q:obj.PostDR.PostType="H"
	.s obj.PostStTime1=obj.PostDR.PostStTime1
	.s obj.PostStTime2=obj.PostDR.PostStTime2
	.s obj.PostStTime3=obj.PostDR.PostStTime3
	.s obj.PostEndTime1=obj.PostDR.PostEndTime1
	.s obj.PostEndTime2=obj.PostDR.PostEndTime2
	.s obj.PostEndTime3=obj.PostDR.PostEndTime3
	.d obj.%Save()
	s subId="" f  s subId=$O(^DHCINM.Arg.MgArrangeSubD(subId)) q:subId=""  d
	.s subObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(subId)
	.q:'$IsObject(subObj)
	.q:'$IsObject(subObj.ArgPerDR)
	.q:'$IsObject(subObj.ArgPostDR)
	.q:'$IsObject(subObj.ArgPostDR.PostDR)
	.q:subObj.ArgPostDR.PostDR.PostType="H"
	.q:((subObj.ArgType="Y")||(subObj.ArgType="N"))
	.q:(subObj.ArgStTime1'="")&&(subObj.ArgEndTime1'="")
	.s subObj.ArgStTime1=subObj.ArgPostDR.PostStTime1
	.s subObj.ArgStTime2=subObj.ArgPostDR.PostStTime2
	.s subObj.ArgStTime3=subObj.ArgPostDR.PostStTime3
	.s subObj.ArgEndTime1=subObj.ArgPostDR.PostEndTime1
	.s subObj.ArgEndTime2=subObj.ArgPostDR.PostEndTime2
	.s subObj.ArgEndTime3=subObj.ArgPostDR.PostEndTime3
	.d subObj.%Save()
	w "执行完成"
}

/// 获取发方法注释描述
ClassMethod getMethodDescription() As %String
{
	s obj=##class(%Dictionary.CompiledMethod).%OpenId("web.INMArgComm||FindNurGroupList")
	b ;001
	s description=obj.Description
	s realDescription=""
	f i=1:1:$L(description,$c(13,10))  d
	.s rowdata=$P(description,$c(13,10),i)
	.q:rowdata=""
	.s rowdata=$TR(rowdata,"：",":")
	.s key=$P(rowdata,":",1)
	.s desc=$P(rowdata,":",2)
	.q:((key="")!(desc=""))
	.s key=$zcvt(key,"U")
	.q:key'="DESCRIPTION"
	.s realDescription=$tr(desc," ","")
	w realDescription
}

/// 字段描述
ClassMethod getParameterDescription() As %String [ CodeMode = objectgenerator ]
{
	for i=1:1:%compiledclass.Parameters.Count()
	{
		s origin=%compiledclass.Parameters.GetAt(i).Origin
		continue:origin'=%compiledclass.Name
		s description=%compiledclass.Parameters.GetAt(i).Description
		continue:description=""
		s name=%compiledclass.Parameters.GetAt(i).Name
		d %code.WriteLine(" w """_ description_""",!")
	}
	q $$$OK
}

/// 测试
/// 测试2
ClassMethod newNsWard(rw) As DHCNS.Config.NsWard
{
	q ##class(DHCNS.Config.NsWard).%New(rw)
}

ClassMethod testDim() As %String
{
	#Dim obj As DHCNS.Config.NsWard
	s obj=..newNsWard(1)
	q obj.Desc
}

/// 固定数值内取一个随机值数组
ClassMethod test() As %String
{
	s tmp=""
	s size=10 ;取多少数值
	s all=15 ;总背景数量有多少
	s index=1 ;计数器
	s count=1
	//size>=1&&size<all。
	//size>=all,则选择所有all
	do{
		s num=$R(all)+1
		i $O(tmp(""))="" d
		.s tmp(num)=1
		e  i '$d(tmp(num))  d ;不存在此数
		.s tmp(num)=index+1
		.s index=index+1
		s count=count+1
	}while(index<size)
	w "总循环次数:"_count,!
	s a=0
	s num="" f  s num=$O(tmp(num)) q:num=""  d
	.w:a'=0 ","
	.w num
	.s a=a+1
}

// d ##class(web.INMTestComm).MoveOldToNewData()

ClassMethod MoveOldToNewData() As %String
{
	s oldClassName="DHCNMG.DB.MgSetCode"
	s id="" f  s id=$O(^DHCNMG.DB.MgSetCodeD(id)) q:id=""  d
	.s oldObj=##class(DHCNMG.DB.MgSetCode).%OpenId(id)
	.q:'$IsObject(oldObj)
	.s newObj=##class(CT.DHCINM.DB.MgSetCode).%New()
	.s p="" f  s p=$O(^oddCOM(oldClassName,"a",p)) q:p=""  d
	..q:p["%"
	..s $ZOBJPROPERTY(newObj,p)=$ZOBJPROPERTY(oldObj,p)
	.d newObj.%Save()
}

// d ##class(web.INMTestComm).MoveOldToNewDataChildren()

ClassMethod MoveOldToNewDataChildren() As %String
{
	s oldClassName="DHCNMG.DB.MgSetCode"
	s oldSubClassName="DHCNMG.DB.MgSetCodeSub"
	s id="" f  s id=$O(^DHCNMG.DB.MgSetCodeD(id)) q:id=""  d
	.s oldObj=##class(DHCNMG.DB.MgSetCode).%OpenId(id)
	.q:'$IsObject(oldObj)
	.s newObj=##class(CT.DHCINM.DB.MgSetCode).%New()
	.s p="" f  s p=$O(^oddCOM(oldClassName,"a",p)) q:p=""  d
	..q:p["%"
	..q:p["ChildSub"
	..q:p["Parref"
	..s $ZOBJPROPERTY(newObj,p)=$ZOBJPROPERTY(oldObj,p)
	.d newObj.%Save()
	.s subid="" f  s subid=$O(^DHCNMG.DB.MgSetCodeSubD(id,subid)) q:subid=""  d
	..s oldSubObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(id_"||"_subid)
	..q:'$IsObject(oldSubObj)
	..s newSubObj=##class(CT.DHCINM.DB.MgSetCodeSub).%New()
	..s p="" f  s p=$O(^oddCOM(oldSubClassName,"a",p)) q:p=""  d
	...q:p["%"
	...q:p["ChildSub"
	...q:p["Parref"
	...s $ZOBJPROPERTY(newSubObj,p)=$ZOBJPROPERTY(oldSubObj,p)
	..s newSubObj.Parref=newObj
	..d newSubObj.%Save()
}

/// w ##class(web.INMTestComm).TransNurMgData()
ClassMethod TransNurMgData() As %String
{
	;学校
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),20,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),18)
	;科室
	d ..TransSimpleData("^DHCNMG.DB.MgWardLocD",$lb(2,3,4,5,6,7,8),"^CF.DHCINM.DB.MgWardLocD",$lb(2,3,4,5,6,7,8))
	;病区
	d ..TransSimpleData("^DHCNMG.DB.MgWardD",$lb(10,3,4,17,11,12,15,13,18,8,9,19,20,21,22,23,""),"^CF.DHCINM.DB.MgWardD",$lb(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18))
	;科室病区关联关系
	d ..TransSimpleData("^DHCNMG.DB.MgWardLocUnitD",$lb(2,3,4),"^CF.DHCINM.DB.MgWardLocUnitD",$lb(2,3,4))
	;人员
	d ..TransSimpleData("^DHCNMG.HR.MgPersonsD",
	$lb(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,40,31,32,36,33,34,35,37,38,39,42,43,44,45,46,49,50,51,52,55,56,57,58,60,62,63,64,65,68,67,69,70,71,72,73,75,76,77,78,79,80,81,82,83,84,86,87,88,89,90,91,92,93,94,97,98,100,101,102,103,104,105,106,108,109,110,111,112,113,114,115,116,117,118,"","","","","","","",17,"","",51,"","",19,"","",50,"","","","","","","","","","","",""),
	"^CF.DHCINM.HR.PersonsD",
	$lb(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,134,135,136))
	;民族
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),1,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),1)
	;政治面貌
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),2,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),2)
	;岗位名称
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),26,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),24)
	;英语级别
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),27,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),25)
	;归属部门
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),29,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),27)
	;修复人员岗位名称、英语级别、归属部门
	d ..FixParId("^CF.DHCINM.HR.PersonsD",$lb(59,77,78),$lb(25,24,27))
	;修复人员状态 原状态为在护理岗 现为轮转、定科
	d ..FixValue("^CF.DHCINM.HR.PersonsD",$lb(76),$lb("62||1"))
	;创建用户,实习、进修无对应用户
	d ..CreateUser()
	;调科记录
	d ..TransSimpleData("^DHCNMG.HR.MgTransDepD",$lb(2,3,4,5,6,7,8,"","",""),"^CF.DHCINM.Trans.TransDepD",$lb(2,3,4,5,6,7,8,9,10,11))
	;学历
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),3,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),3)
	;学位
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),19,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),15)
	;教育性质
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),25,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),23)
	;专业
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),24,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),22)
	;教育
	d ..TransSimpleData("^DHCNMG.HR.MgEducateD",$lb(2,3,4,5,6,7,8,9,10,11,12),"^CF.DHCINM.HR.EducateD",$lb(2,3,4,5,6,7,8,9,10,11,12))
	;修复教育代码
	d ..FixParId("^CF.DHCINM.HR.EducateD",$lb(5,6,7,8,9),$lb(18,3,15,23,22))
	;职称
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),14,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),12)
	;人员职称
	d ..TransSimpleData("^DHCNMG.HR.MgHireDutyD",$lb(2,3,4,5,6,7,8,9,10,11,12),"^CF.DHCINM.HR.HireDutyD",$lb(2,3,4,5,6,7,8,9,10,11,12))
	;修复人员职称代码
	d ..FixParId("^CF.DHCINM.HR.HireDutyD",$lb(3),$lb(12))
	;层级
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),21,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),19)
	;人员层级
	d ..TransSimpleData("^DHCNMG.HR.MgLevelD",$lb(2,3,4,5,6,7),"^CF.DHCINM.HR.MgLevelD",$lb(2,3,4,5,6,7))
	;修复人员层级代码
	d ..FixParId("^CF.DHCINM.HR.MgLevelD",$lb(3),$lb(19))
	;职务
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),16,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),14)
	;人员职务
	d ..TransSimpleData("^DHCNMG.HR.MgPostDutyD",$lb(2,3,4,5,6,7),"^CF.DHCINM.HR.PostDutyD",$lb(2,3,4,5,6,7))
	;修复人员职务代码
	d ..FixParId("^CF.DHCINM.HR.PostDutyD",$lb(3),$lb(14))
	;人员工作经历
	d ..TransSimpleData("^DHCNMG.HR.MgWorkD",$lb(2,3,4,5,6,7,8,9),"^DHCINM.HR.MgWorkD",$lb(2,3,4,5,6,7,8,9))
	;修复人员工作经历
	d ..FixParId("^DHCINM.HR.MgWorkD",$lb(6,7),$lb(14,24))
	;科研类型
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),35,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),33)
	;科研排序
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),39,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),37)
	;人员科研基金
	d ..TransSimpleData("^DHCNMG.HR.MgResearchD",$lb(3,4,5,6,7,8,9,10),"^DHCINM.HR.MgResearchD",$lb(2,3,4,5,6,7,8,9))
	;修复人员科研基金
	d ..FixParId("^DHCINM.HR.MgResearchD",$lb(4,7),$lb(33,37))
	;专利类型
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),36,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),34)
	;获奖成绩
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),40,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),38)
	;出版社
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),33,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),31)
	;人员获奖科研
	d ..TransSimpleData("^DHCNMG.HR.MgAwardD",$lb(2,3,4,5,6,7,10,11,12,13,14,8,9,"",""),"^DHCINM.HR.MgAwardD",$lb(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16))
	;修复人员获奖科研
	d ..FixParId("^DHCINM.HR.MgAwardD",$lb(5,7,9,11),$lb(38,37,34,31))
	;人员对口支援
	d ..TransSimpleData("^DHCNMG.HR.MgSupportD",$lb(2,3,4,5,6,7,8),"^DHCINM.HR.MgSupportD",$lb(2,3,4,5,6,7,8))
	;人员类别
	d ..TransChildData("^DHCNMG.DB.MgSetCodeSubD",$lb(2,3,4,6,7,8,9,""),37,"^CT.DHCINM.DB.MgSetCodeSubD",$lb(2,3,4,5,6,7,8,9),35)
	;人员教材编辑
	d ..TransSimpleData("^DHCNMG.HR.MgTeachD",$lb(2,3,4,5,6,7,8),"^DHCINM.HR.MgTeachD",$lb(2,3,4,5,6,7,8))
	;修复人员教材编辑
	d ..FixParId("^DHCINM.HR.MgTeachD",$lb(6),$lb(35))
	;人员学术会议
	d ..TransSimpleData("^DHCNMG.HR.MgAcadMeetingD",$lb(2,3,11,5,6,7,8,9,10),"^DHCINM.HR.MgAcadMeetingD",$lb(2,3,4,5,6,7,8,9,10))
	;人员推广技术
	d ..TransSimpleData("^DHCNMG.HR.MgPromoteD",$lb(2,3,4,5,6,7,8,9),"^DHCINM.HR.MgPromoteD",$lb(2,3,4,5,6,7,8,9))
	;角色
	d ..TransSimpleData("^DHCNMG.Set.MgRolesD",$lb(2,3,4,5,6,7),"^CT.DHCINM.Set.MgRolesD",$lb(2,3,4,5,6,7))
	;人员角色
	;人员角色父表由角色表变成了人员表 之前迁移的数据有问题
	;d ..TransStanChildData("^DHCNMG.Set.MgRolesD",$lb(2,3,4),"NurseChildSub","^CF.DHCINM.DB.MgUserRoleD",$lb(2,3,4),"^CF.DHCINM.DB.MgUserD")
	;d ..TransUserRole()
	d ..TransChangeStanChildData("^DHCNMG.Set.MgRolesD",$lb(3,4),"NurseChildSub",2,"^CF.DHCINM.DB.MgUserRoleD",$lb(3,4),"^CF.DHCINM.DB.MgUserD",2)
	;人员病区权限
	d ..TransSimpleData("^DHCNMG.DB.MgDataLimitD",$lb(2,3,4),"^CF.DHCINM.Set.MgDataLimitD",$lb(2,3,4))
	;人员病区权限子表
	d ..TransAllChildData("^DHCNMG.DB.MgDataLimitD",$lb(2),"^CF.DHCINM.Set.MgDataLimitSubD",$lb(2))
	;全局班次
	d ..TransSimpleData("^DHCNMG.DB.MgArgPostD",$lb(2,3,5,32,20,21,23,24,33,34,35,11,31,16,17,39,28,36,37,38,26,27,40,30,41,"",""),"^CF.DHCINM.DB.MgArgPostD",$lb(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28))
	;病区班次
	d ..TransSimpleData("^DHCNMG.DB.MgArgWardPostD",$lb(25,2,3,31,15,16,18,19,27,28,29,20,4,32,33,34,21,22,35,36),"^CF.DHCINM.DB.MgArgWardPostD",$lb(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21))
	;迁移排班数据
	d ..TransSimpleData("^DHCNMG.Arg.MgArrangeD",$lb(2,15,4,5,16,7,8,9,10,11,12,13,14,17,18,""),"^DHCINM.Arg.MgArrangeD",$lb(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17))
	d ..TransSimpleData("^DHCNMG.Arg.MgArrangeGroupD",$lb(2,3,4,5,8,6,9),"^DHCINM.Arg.MgArrangeGroupD",$lb(2,3,4,5,6,7,8))
	d ..TransSimpleData("^DHCNMG.Arg.MgArrangeRowD",$lb(2,3,4,5,6,7,8,9,10,""),"^DHCINM.Arg.MgArrangeRowD",$lb(2,3,4,5,6,7,8,9,10,11))
	d ..TransSimpleData("^DHCNMG.Arg.MgArrangeSubD",$lb(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28),"^DHCINM.Arg.MgArrangeSubD",$lb(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28))
	d ..TransSimpleData("^DHCNMG.Arg.MgNurGroupD",$lb(2,3,4,5,6,7,8),"^DHCINM.Arg.MgNurGroupD",$lb(2,3,4,5,6,7,8))
	d ..TransSimpleData("^DHCNMG.Arg.MgArgTemplateD",$lb(2,3,4,5,6,7,8,9,10),"^DHCINM.Arg.MgArgTemplateD",$lb(2,3,4,5,6,7,8,9,10))
	;修复班次次日问题
	d ..FixNextDay()
	;工作量项目
	d ..TransSimpleData("^DHCNMG.DB.MgNurWorkLoadItmD",$lb(2,3,4,5,6,7,8,9,10),"^CF.DHCINM.DB.WorkLoadItmD",$lb(2,3,4,5,6,7,8,9,10))
	;工作量项目关联医嘱
	d ..TransSimpleData("^DHCNMG.DB.MgNurWorkLoadItmSubD",$lb(2,3,4),"^CF.DHCINM.DB.WorkLoadItmSubD",$lb(2,3,4))
	q 1
}

/// w ##class(web.INMTestComm).TransSimpleData()
/// ^OldD -> ^NewD
ClassMethod TransSimpleData(oldGloName As %String, oldPosition As %ListOfDataTypes, newGloName As %String, newPosition As %ListOfDataTypes) As %String
{
	q:(oldGloName="")||(newGloName="")||($ll(oldPosition)'=$ll(newPosition)) 0
	k @newGloName
	s oldId="" f  s oldId=$o(@oldGloName@(oldId)) q:oldId=""  d
	.s oldGlo=@oldGloName@(oldId)
	.s newGlo=$lb("")
	.s sc=..CopyData(.oldGlo,oldPosition,.newGlo,newPosition)
	.s @newGloName@(oldId)=newGlo
	s:$d(@oldGloName)#2=1 @newGloName=@oldGloName
	d $CLASSMETHOD($e(newGloName,2,*-1),"%BuildIndices")
	q 1
}

/// w ##class(web.INMTestComm).TransAllChildData()
/// oldSubGloName -> newSubGloName
ClassMethod TransAllChildData(oldParGloName As %String, oldSubPosition As %ListOfDataTypes, newSubGloName As %String, newSubPosition As %ListOfDataTypes) As %String
{
	q:(oldParGloName="")||(newSubGloName="")||($ll(oldSubPosition)'=$ll(newSubPosition)) 0
	s oldParId="" f  s oldParId=$o(@oldParGloName@(oldParId)) q:oldParId=""  d
	.s sc=..TransChildData($e(oldParGloName,1,*-1)_"SubD",oldSubPosition,oldParId,newSubGloName,newSubPosition,oldParId)
	q 1
}

/// w ##class(web.INMTestComm).TransChildData()
/// oldSubGloName(oldParId) -> newSubGloName(newParId)
ClassMethod TransChildData(oldSubGloName As %String, oldSubPosition As %ListOfDataTypes, oldParId As %Integer, newSubGloName As %String, newSubPosition As %ListOfDataTypes, newParId As %Integer) As %String
{
	q:(oldSubGloName="")||(newSubGloName="")||($ll(oldSubPosition)'=$ll(newSubPosition))||(+oldParId=0)||(+newParId=0) 0
	k @newSubGloName@(newParId)
	s oldId="" f  s oldId=$o(@oldSubGloName@(oldParId,oldId)) q:oldId=""  d
	.s oldGlo=@oldSubGloName@(oldParId,oldId)
	.s newGlo=$lb("")
	.s flag=..CopyData(.oldGlo,oldSubPosition,.newGlo,newSubPosition)
	.s @newSubGloName@(newParId,oldId)=newGlo
	s:$d(@($e(oldSubGloName,1,*-4)_"D")@(oldParId,"ChildSub"))#2=1 @($e(newSubGloName,1,*-4)_"D")@(newParId,"ChildSub")=@($e(oldSubGloName,1,*-4)_"D")@(oldParId,"ChildSub")
	d $CLASSMETHOD($e(newSubGloName,2,*-1),"%BuildIndices")
	q 1
}

/// w ##class(web.INMTestComm).TransStanChildData()
/// oldParGloName(,oldNodeName) -> newSubGloName(,NewSubId)
ClassMethod TransStanChildData(oldParGloName As %String, oldSubPosition As %ListOfDataTypes, oldNodeName As %String, newSubGloName As %String, newSubPosition As %ListOfDataTypes, newParGloName As %String) As %String
{
	q:(oldParGloName="")||(oldNodeName="")||(newSubGloName="")||(newParGloName="")||($ll(oldSubPosition)'=$ll(newSubPosition)) 0
	k @newSubGloName
	s oldParId="" f  s oldParId=$o(@oldParGloName@(oldParId)) q:oldParId=""  d
	.s max=0
	.s oldSubId="" f  s oldSubId=$o(@oldParGloName@(oldParId,oldNodeName,oldSubId)) q:oldSubId=""  d
	..s oldGlo=@oldParGloName@(oldParId,oldNodeName,oldSubId)
	..s newGlo=$lb("")
	..s sc=..CopyData(.oldGlo,oldSubPosition,.newGlo,newSubPosition)
	..s max=max+1
	..s @newSubGloName@(oldParId,max)=newGlo
	.s:max>0 @newParGloName@(oldParId,"ChildSub")=max
	d $CLASSMETHOD($e(newSubGloName,2,*-1),"%BuildIndices")
	q 1
}

/// w ##class(web.INMTestComm).TransChangeStanChildData()
/// oldParGloName(,oldNodeName) -> newSubGloName(,NewSubId)
ClassMethod TransChangeStanChildData(oldParGloName As %String, oldSubPosition As %ListOfDataTypes, oldNodeName As %String, oldParIdInNewPostion As %String, newSubGloName As %String, newSubPosition As %ListOfDataTypes, newParGloName As %String, newParIdInOldPostion As %String) As %String
{
	q:(oldParGloName="")||(oldNodeName="")||(oldParIdInNewPostion="")||(newSubGloName="")||(newParGloName="")||(newParIdInOldPostion="")||($ll(oldSubPosition)'=$ll(newSubPosition)) 0
	k @newSubGloName
	s oldParId="" f  s oldParId=$o(@oldParGloName@(oldParId)) q:oldParId=""  d
	.s max=0
	.s oldSubId="" f  s oldSubId=$o(@oldParGloName@(oldParId,oldNodeName,oldSubId)) q:oldSubId=""  d
	..s oldGlo=@oldParGloName@(oldParId,oldNodeName,oldSubId)
	..s newGlo=$lb("")
	..s $list(newGlo,oldParIdInNewPostion)=oldParId
	..s sc=..CopyData(.oldGlo,oldSubPosition,.newGlo,newSubPosition)
	..s max=max+1
	..s @newSubGloName@($lg(oldGlo,newParIdInOldPostion),max)=newGlo
	.s:max>0 @newParGloName@(oldParId,"ChildSub")=max
	d $CLASSMETHOD($e(newSubGloName,2,*-1),"%BuildIndices")
	q 1
}

/// w ##class(web.INMTestComm).FixNextDay()
ClassMethod FixNextDay() As %String
{
	s postId="" f  s postId=$o(^CF.DHCINM.DB.MgArgPostD(postId)) q:postId=""  d
	.s postObj=##class(CF.DHCINM.DB.MgArgPost).%OpenId(postId)
	.q:'$IsObject(postObj)
	.s flag=0
	.f i=1:1:3 d
	..s stTime=$PROPERTY(postObj,"PostStTime"_i)
	..s endTime=$PROPERTY(postObj,"PostEndTime"_i)
	..s:stTime["次日" flag=1
	..s:(flag=1)&&(stTime'="")&&(stTime'["次日") $PROPERTY(postObj,"PostStTime"_i)="次日"_stTime
	..s:(flag=1)&&(endTime'="")&&(endTime'["次日") $PROPERTY(postObj,"PostEndTime"_i)="次日"_endTime
	..s:endTime["次日" flag=1
	.s sc=postObj.%Save()
	
	s postId="" f  s postId=$o(^CF.DHCINM.DB.MgArgWardPostD(postId)) q:postId=""  d
	.s postObj=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(postId)
	.q:'$IsObject(postObj)
	.s flag=0
	.f i=1:1:3 d
	..s stTime=$PROPERTY(postObj,"PostStTime"_i)
	..s endTime=$PROPERTY(postObj,"PostEndTime"_i)
	..s:stTime["次日" flag=1
	..s:(flag=1)&&(stTime'="")&&(stTime'["次日") $PROPERTY(postObj,"PostStTime"_i)="次日"_stTime
	..s:(flag=1)&&(endTime'="")&&(endTime'["次日") $PROPERTY(postObj,"PostEndTime"_i)="次日"_endTime
	..s:endTime["次日" flag=1
	.s sc=postObj.%Save()
	
	s postId="" f  s postId=$o(^DHCINM.Arg.MgArrangeSubD(postId)) q:postId=""  d
	.s postObj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(postId)
	.q:'$IsObject(postObj)
	.s flag=0
	.f i=1:1:3 d
	..s stTime=$PROPERTY(postObj,"ArgStTime"_i)
	..s endTime=$PROPERTY(postObj,"ArgEndTime"_i)
	..s:stTime["次日" flag=1
	..s:(flag=1)&&(stTime'="")&&(stTime'["次日") $PROPERTY(postObj,"ArgStTime"_i)="次日"_stTime
	..s:(flag=1)&&(endTime'="")&&(endTime'["次日") $PROPERTY(postObj,"ArgEndTime"_i)="次日"_endTime
	..s:endTime["次日" flag=1
	.s sc=postObj.%Save()
	
	q 1
}

/// w ##class(web.INMTestComm).FixParId()
/// oldParId||subId -> newParId||subId
ClassMethod FixParId(toFixGloName As %String, toFixPropPoses As %ListOfDataTypes, newParIds As %ListOfDataTypes) As %String
{
	q:(toFixGloName="")||($ll(toFixPropPoses)'=$ll(newParIds)) 0
	
	s len=$ll(toFixPropPoses)
	s toFixId="" f  s toFixId=$o(@toFixGloName@(toFixId)) q:toFixId=""  d
	.s toFixGlo=@toFixGloName@(toFixId)
	.f i=1:1:len d
	..s toFixPropPos=$lg(toFixPropPoses,i)
	..s newParId=$lg(newParIds,i)
	..s oldId=$lg(toFixGlo,toFixPropPos)
	..s oldSubId=$p(oldId,"||",2)
	..q:oldSubId=""
	..s $list(@toFixGloName@(toFixId),toFixPropPos)=newParId_"||"_oldSubId
	d $CLASSMETHOD($e(toFixGloName,2,*-1),"%BuildIndices")
	
	q 1
}

/// w ##class(web.INMTestComm).FixValue()
/// oldParId||subId -> newParId||subId
ClassMethod FixValue(toFixGloName As %String, toFixPropPoses As %ListOfDataTypes, newValues As %ListOfDataTypes) As %String
{
	q:(toFixGloName="")||($ll(toFixPropPoses)'=$ll(newValues)) 0
	
	s len=$ll(toFixPropPoses)
	s toFixId="" f  s toFixId=$o(@toFixGloName@(toFixId)) q:toFixId=""  d
	.s toFixGlo=@toFixGloName@(toFixId)
	.f i=1:1:len d
	..s toFixPropPos=$lg(toFixPropPoses,i)
	..s newValue=$lg(newValues,i)
	..s $list(@toFixGloName@(toFixId),toFixPropPos)=newValue
	d $CLASSMETHOD($e(toFixGloName,2,*-1),"%BuildIndices")
	
	q 1
}

ClassMethod CopyData(ByRef oldGlo As %Global, oldPosition As %ListOfDataTypes, ByRef newGlo As %Global, newPosition As %ListOfDataTypes) As %String
{
	q:$ll(oldPosition)'=$ll(newPosition) 0
	s len=$ll(oldPosition)
	f i=1:1:len d
	.s old=$lg(oldPosition,i)
	.s new=$lg(newPosition,i)
	.s:(old="")&&(+new'=0) $list(newGlo,new)=""
	.q:(+old=0)||(+new=0)
	.s $list(newGlo,new)=$lg(oldGlo,old)
	q 1
}

/// w ##class(web.INMTestComm).CreateUser()
/// perId -> userId
ClassMethod CreateUser() As %String
{
	k ^CF.DHCINM.DB.MgUserD
	s now=+$h
	s perId="" f  s perId=$o(^CF.DHCINM.HR.PersonsD(perId)) q:perId=""  d
	.s perGlo=^CF.DHCINM.HR.PersonsD(perId)
	.s perType=$lg(perGlo,25)
	.q:perType'="N"
	.s userGlo=$lb("")
	.d ..CopyData(perGlo,$lb(2,3,50,10),.userGlo,$lb(2,3,6,9))
	.s hisID=$lg(perGlo,51)
	.i hisID'="" d
	..s ssuerId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(hisID,"U"),""))
	..s:ssuerId'="" $list(userGlo,4)=ssuerId
	.s $list(userGlo,5)=perId
	.s $list(userGlo,7)=now
	.s ^CF.DHCINM.DB.MgUserD(perId)=userGlo
	s ^CF.DHCINM.DB.MgUserD=^CF.DHCINM.HR.PersonsD
	d ##class(CF.DHCINM.DB.MgUser).%BuildIndices()
	q 1
}

/// w ##class(web.INMTestComm).TransUserRole()
ClassMethod TransUserRole() As %String
{
	s userId="" f  s userId=$o(^CF.DHCINM.DB.MgUserD(userId)) q:userId=""  d
	.k ^CF.DHCINM.DB.MgUserD(userId,"ChildSub")
	
	s oldRoleId="" f  s oldRoleId=$o(^DHCNMG.Set.MgRolesD(oldRoleId)) q:oldRoleId=""  d
	.s oldRoleNurId="" f  s oldRoleNurId=$o(^DHCNMG.Set.MgRolesD(oldRoleId,"NurseChildSub",oldRoleNurId)) q:oldRoleNurId=""  d
	..s oldGlo=^DHCNMG.Set.MgRolesD(oldRoleId,"NurseChildSub",oldRoleNurId)
	..s userRole=##class(CF.DHCINM.DB.MgUserRole).%New()
	..d userRole.ParrefSetObjectId($lg(oldGlo,2))
	..s userRole.RoleID=oldRoleId
	..s userRole.RoleStDate=$lg(oldGlo,3)
	..s userRole.RoleEndDate=$lg(oldGlo,4)
	..s sc=userRole.%Save()
	
	q 1
}

/// 迁移护士长手册说明富文本数据
ClassMethod TransHbDirections()
{
	s id="" f  s id=$o(^CF.DHCINM.HB.HbDirectionsD(id)) q:id=""  d
	.s obj=##class(CF.DHCINM.HB.HbDirections).%OpenId(id)
	.q:'$IsObject(obj)
	.q:obj.ItemContent=""
	.d obj.ItemContentExt.Write(obj.ItemContent)
	.s sc=obj.%Save()
	.w:$$$ISERR(sc) id,!
}

/// 迁移组织管理说明富文本数据
/// d ##class(web.INMTestComm).TransOrgContextExt()
ClassMethod TransOrgContextExt()
{
	s id="" f  s id=$O(^DHCINM.OrgManage.OrgSystemD(id)) q:id=""  d
	.s obj=##class(DHCINM.OrgManage.OrgSystem).%OpenId(id)
	.q:'$IsObject(obj)
	.q:obj.SystemText=""
	.d obj.ContentExt.Write(obj.SystemText)
	.s sc=obj.%Save()
	.w:$$$ISERR(sc) "制度维护"_id,!
	
	s id="" f  s id=$O(^DHCINM.OrgManage.WorkPlanningD(id)) q:id=""  d
	.s obj2=##class(DHCINM.OrgManage.WorkPlanning).%OpenId(id)
	.q:'$IsObject(obj2)
	.q:obj2.WorkText=""
	.d obj2.ContentExt.Write(obj2.WorkText)
	.s sc=obj2.%Save()
	.w:$$$ISERR(sc) "工作规划"_id,!
	
	s id="" f  s id=$O(^DHCINM.OrgManage.WorkPlanD(id)) q:id=""  d
	.s obj3=##class(DHCINM.OrgManage.WorkPlan).%OpenId(id)
	.q:'$IsObject(obj3)
	.q:obj3.WorkText=""
	.d obj3.ContentExt.Write(obj3.WorkText)
	.s sc=obj3.%Save()
	.w:$$$ISERR(sc) "工作计划"_id,!
	
	s id="" f  s id=$O(^DHCINM.OrgManage.WorkPointsD(id)) q:id=""  d
	.s obj4=##class(DHCINM.OrgManage.WorkPoints).%OpenId(id)
	.q:'$IsObject(obj4)
	.q:obj4.WorkText=""
	.d obj4.ContentExt.Write(obj4.WorkText)
	.s sc=obj4.%Save()
	.w:$$$ISERR(sc) "工作重点"_id,!
}

// w ##class(web.INMTestComm).MoveGlobalToNew()

ClassMethod MoveGlobalToNew() As %String
{
	;基础数据merge
	m ^CT.DHCINM.Set.MgArgParamSetD=^DHCINM.Set.MgArgParamSetD
	m ^CT.DHCINM.Set.MgArgParamSetI=^DHCINM.Set.MgArgParamSetI
	m ^CT.DHCINM.Set.MgRolesD=^DHCINM.Set.MgRolesD
	m ^CT.DHCINM.Set.MgRolesI=^DHCINM.Set.MgRolesI
	m ^CT.DHCINM.Set.MgSysParamD=^DHCINM.Set.MgSysParamD
	m ^CT.DHCINM.Set.MgSysParamI=^DHCINM.Set.MgSysParamI
	m ^CT.DHCINM.Set.MgSysParamSubD=^DHCINM.Set.MgSysParamSubD
	m ^CT.DHCINM.Set.MgSysParamSubI=^DHCINM.Set.MgSysParamSubI
	m ^CT.DHCINM.Set.MgModuleD=^DHCINM.Set.MgModuleD
	m ^CT.DHCINM.Set.MgModuleI=^DHCINM.Set.MgModuleI
	m ^CT.DHCINM.Set.MgMenuD=^DHCINM.Set.MgMenuD
	m ^CT.DHCINM.Set.MgMenuI=^DHCINM.Set.MgMenuI
	m ^CT.DHCINM.Set.MgMenuElementD=^DHCINM.Set.MgMenuElementD
	m ^CT.DHCINM.Set.MgMenuElementI=^DHCINM.Set.MgMenuElementI
	m ^CT.DHCINM.Set.MgFieldSetD=^DHCINM.Set.MgFieldSetD
	m ^CT.DHCINM.Set.MgFieldSetI=^DHCINM.Set.MgFieldSetI
	m ^CT.DHCINM.Set.MgLimitSetD=^DHCINM.Set.MgLimitSetD
	m ^CT.DHCINM.Set.MgLimitSetI=^DHCINM.Set.MgLimitSetI
	m ^CT.DHCINM.Set.MgLimitSetSubD=^DHCINM.Set.MgLimitSetSubD
	m ^CT.DHCINM.Set.MgLimitSetSubI=^DHCINM.Set.MgLimitSetSubI
	m ^CT.DHCINM.DB.MgSetCodeD=^DHCINM.DB.MgSetCodeD
	m ^CT.DHCINM.DB.MgSetCodeI=^DHCINM.DB.MgSetCodeI
	m ^CT.DHCINM.DB.MgSetCodeSubD=^DHCINM.DB.MgSetCodeSubD
	m ^CT.DHCINM.DB.MgSetCodeSubI=^DHCINM.DB.MgSetCodeSubI
	m ^CT.DHCINM.DB.MgReAdmItemD=^DHCINM.DB.MgReAdmItemD
	m ^CT.DHCINM.DB.MgReAdmItemI=^DHCINM.DB.MgReAdmItemI
	m ^CT.DHCINM.DB.MgQualItemD=^DHCINM.DB.MgQualItemD
	m ^CT.DHCINM.DB.MgQualItemI=^DHCINM.DB.MgQualItemI
	m ^CT.DHCINM.DB.MgQualItemSubD=^DHCINM.DB.MgQualItemSubD
	m ^CT.DHCINM.DB.MgQualItemSubI=^DHCINM.DB.MgQualItemSubI
	;配置数据
	m ^CF.DHCINM.DB.WorkLoadItmD=^DHCINM.DB.MgNurWorkLoadItmD
	m ^CF.DHCINM.DB.WorkLoadItmI=^DHCINM.DB.MgNurWorkLoadItmI
	m ^CF.DHCINM.DB.WorkLoadItmSubD=^DHCINM.DB.MgNurWorkLoadItmSubD
	m ^CF.DHCINM.DB.WorkLoadItmSubI=^DHCINM.DB.MgNurWorkLoadItmSubI
	m ^CF.DHCINM.DB.WorkLoadDepSetD=^DHCINM.DB.MgNurWorkLoadDepSetD
	m ^CF.DHCINM.DB.WorkLoadDepSetI=^DHCINM.DB.MgNurWorkLoadDepSetI
	m ^CF.DHCINM.DB.SurveyFormD=^DHCINM.DB.MgSurveyFormD
	m ^CF.DHCINM.DB.SurveyFormI=^DHCINM.DB.MgSurveyFormI
	m ^CF.DHCINM.DB.SurveyFormSubD=^DHCINM.DB.MgSurveyFormSubD
	m ^CF.DHCINM.DB.SurveyFormSubI=^DHCINM.DB.MgSurveyFormSubI
	m ^CF.DHCINM.DB.TeaOperaD=^DHCINM.DB.MgTeaOperaD
	m ^CF.DHCINM.DB.TeaOperaI=^DHCINM.DB.MgTeaOperaI
	m ^CF.DHCINM.DB.TeaOperaSubD=^DHCINM.DB.MgTeaOperaSubD
	m ^CF.DHCINM.DB.TeaOperaSubI=^DHCINM.DB.MgTeaOperaSubI
	m ^CF.DHCINM.DB.TeaTheoryD=^DHCINM.DB.MgTeaTheoryD
	m ^CF.DHCINM.DB.TeaTheoryI=^DHCINM.DB.MgTeaTheoryI
	m ^CF.DHCINM.DB.TeaTheorySubD=^DHCINM.DB.MgTeaTheorySubD
	m ^CF.DHCINM.DB.TeaTheorySubI=^DHCINM.DB.MgTeaTheorySubI
	m ^CF.DHCINM.DB.MgUserD=^DHCINM.DB.MgUserD
	m ^CF.DHCINM.DB.MgUserI=^DHCINM.DB.MgUserI
	m ^CF.DHCINM.DB.MgUserRoleD=^DHCINM.DB.MgUserRoleD
	m ^CF.DHCINM.DB.MgUserRoleI=^DHCINM.DB.MgUserRoleI
	m ^CF.DHCINM.DB.MgHospitalSetD=^DHCINM.DB.MgHospitalSetD
	m ^CF.DHCINM.DB.MgHospitalSetI=^DHCINM.DB.MgHospitalSetI
	
	m ^CF.DHCINM.HR.PersonsD=^DHCINM.HR.MgPersonsD
	m ^CF.DHCINM.HR.PersonsI=^DHCINM.HR.MgPersonsI
	m ^CF.DHCINM.DB.MgWardAreaD=^DHCINM.DB.MgWardAreaD
	m ^CF.DHCINM.DB.MgWardAreaI=^DHCINM.DB.MgWardAreaI
	m ^CF.DHCINM.DB.MgWardLocD=^DHCINM.DB.MgWardLocD
	m ^CF.DHCINM.DB.MgWardLocI=^DHCINM.DB.MgWardLocI
	m ^CF.DHCINM.DB.MgWardD=^DHCINM.DB.MgWardD
	m ^CF.DHCINM.DB.MgWardI=^DHCINM.DB.MgWardI
	m ^CF.DHCINM.DB.MgWardLocUnitD=^DHCINM.DB.MgWardLocUnitD
	m ^CF.DHCINM.DB.MgWardLocUnitI=^DHCINM.DB.MgWardLocUnitI
	m ^CF.DHCINM.DB.MgFloorD=^DHCINM.DB.MgFloorD
	m ^CF.DHCINM.DB.MgFloorI=^DHCINM.DB.MgFloorI
	m ^CF.DHCINM.DB.MgHolidaySetD=^DHCINM.DB.MgHolidaySetD
	m ^CF.DHCINM.DB.MgHolidaySetI=^DHCINM.DB.MgHolidaySetI
	m ^CF.DHCINM.DB.MgArgPostD=^DHCINM.DB.MgArgPostD
	m ^CF.DHCINM.DB.MgArgPostI=^DHCINM.DB.MgArgPostI
	m ^CF.DHCINM.DB.MgArgWardPostD=^DHCINM.DB.MgArgWardPostD
	m ^CF.DHCINM.DB.MgArgWardPostI=^DHCINM.DB.MgArgWardPostI
	m ^CF.DHCINM.CHK.CheckGroupD=^DHCINM.CHK.MgNurCheckGroupD
	m ^CF.DHCINM.CHK.CheckGroupI=^DHCINM.CHK.MgNurCheckGroupI
	m ^CF.DHCINM.CHK.CheckPlanD=^DHCINM.CHK.MgNurCheckPlanD
	m ^CF.DHCINM.CHK.CheckPlanI=^DHCINM.CHK.MgNurCheckPlanI
	m ^CF.DHCINM.CHK.CheckPlanSubD=^DHCINM.CHK.MgNurCheckPlanSubD
	m ^CF.DHCINM.CHK.CheckPlanSubI=^DHCINM.CHK.MgNurCheckPlanSubI
	m ^CF.DHCINM.CHK.CheckWardD=^DHCINM.CHK.MgNurCheckWardD
	m ^CF.DHCINM.CHK.CheckWardI=^DHCINM.CHK.MgNurCheckWardI
	m ^CF.DHCINM.Set.MgDataLimitD=^DHCINM.Set.MgDataLimitD
	m ^CF.DHCINM.Set.MgDataLimitI=^DHCINM.Set.MgDataLimitI
	m ^CF.DHCINM.Set.MgDataLimitSubD=^DHCINM.Set.MgDataLimitSubD
	m ^CF.DHCINM.Set.MgDataLimitSubI=^DHCINM.Set.MgDataLimitSubI
	m ^CF.DHCINM.Set.NightFeeFactorD=^DHCINM.Set.MgNightFeeFactorD
	m ^CF.DHCINM.Set.NightFeeFactorI=^DHCINM.Set.MgNightFeeFactorI
	m ^CF.DHCINM.Set.MgVersionD=^DHCINM.Set.MgVersionD
	m ^CF.DHCINM.HB.HbDirectionsD=^DHCINM.HB.MgHbDirectionsD
	m ^CF.DHCINM.HB.HbDirectionsI=^DHCINM.HB.MgHbDirectionsI
	m ^CF.DHCINM.HR.PostDutyD=^DHCINM.HR.MgPostDutyD
	m ^CF.DHCINM.HR.PostDutyI=^DHCINM.HR.MgPostDutyI
	m ^CF.DHCINM.HR.EducateD=^DHCINM.HR.MgEducateD
	m ^CF.DHCINM.HR.EducateI=^DHCINM.HR.MgEducateI
	m ^CF.DHCINM.HR.HireDutyD=^DHCINM.HR.MgHireDutyD
	m ^CF.DHCINM.HR.HireDutyI=^DHCINM.HR.MgHireDutyI
	m ^CF.DHCINM.HR.MgLevelD=^DHCINM.HR.MgLevelD
	m ^CF.DHCINM.HR.MgLevelI=^DHCINM.HR.MgLevelI
	m ^CF.DHCINM.Trans.TransDepD=^DHCINM.Trans.MgTransDepD
	m ^CF.DHCINM.Trans.TransDepI=^DHCINM.Trans.MgTransDepI
	;敏感指标-基础数据
	m ^CT.DHCNS.Config.NsTypeSetD=^DHCNS.Config.NsTypeSetD
	m ^CT.DHCNS.Config.NsTypeSetI=^DHCNS.Config.NsTypeSetI
	m ^CT.DHCNS.Config.NsElementD=^DHCNS.Config.NsElementD
	m ^CT.DHCNS.Config.NsElementI=^DHCNS.Config.NsElementI
	m ^CT.DHCNS.Config.NsElementSubD=^DHCNS.Config.NsElementSubD
	m ^CT.DHCNS.Config.NsElementSubI=^DHCNS.Config.NsElementSubI
	m ^CT.DHCNS.Config.NsEleTypeD=^DHCNS.Config.NsEleTypeD
	m ^CT.DHCNS.Config.NsEleTypeI=^DHCNS.Config.NsEleTypeI
	m ^CT.DHCNS.Config.NsIndexD=^DHCNS.Config.NsIndexD
	m ^CT.DHCNS.Config.NsIndexI=^DHCNS.Config.NsIndexI
	m ^CT.DHCNS.Config.NsIndexSubD=^DHCNS.Config.NsIndexSubD
	m ^CT.DHCNS.Config.NsIndexSubI=^DHCNS.Config.NsIndexSubI
	;敏感指标-配置数据
	m ^CF.DHCNS.Config.NsModelD=^DHCNS.Config.NsModelD
	m ^CF.DHCNS.Config.NsModelI=^DHCNS.Config.NsModelI
	m ^CF.DHCNS.Config.NsModelSubD=^DHCNS.Config.NsModelSubD
	m ^CF.DHCNS.Config.NsModelSubI=^DHCNS.Config.NsModelSubI
	q "完成"
}

/// w ##class(web.INMTestComm).DeletePer(224)
ClassMethod DeletePer(id) As %String
{
	s ret=1
	TS
	s date="" f  s date=$O(^DHCINM.Arg.MgArgHourI("Per",id,date)) q:((date="")||(ret'=1))  d
	.s rw="" f  s rw=$O(^DHCINM.Arg.MgArgHourI("Per",id,date,rw)) q:((rw="")||(ret'=1))  d
	..s ret=ret&&$$$ISOK(##class(DHCINM.Arg.MgArgHour).%DeleteId(rw))
	if ret'=1{
		tro
		q "删除初始化积假信息失败"	
	}
	s rw="" f  s rw=$O(^DHCINM.Arg.MgArrangeSubI("Person",id,rw))  q:((rw="")||(ret'=1))  d
	.s ret=ret&&$$$ISOK(##class(DHCINM.Arg.MgArrangeSub).%DeleteId(rw))
	if ret'=1{
		tro
		q "删除排班失败"	
	}
	s argID="" f  s argID=$O(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argID)) q:((argID="")||(ret'=1))  d
	.s rw="" f  s rw=$O(^DHCINM.Arg.MgArrangeRowI("ArgPerson",argID,id,rw))  q:((rw="")||(ret'=1))  d
	..s ret=ret&&$$$ISOK(##class(DHCINM.Arg.MgArrangeRow).%DeleteId(rw))
	if ret'=1{
		tro
		q "删除排班行数据失败"	
	}
	s rw="" f  s rw=$O(^DHCINM.HR.MgQualRegistedI("ssid"," "_id,rw))  q:((rw="")||(ret'=1))  d
	.s ret=ret&&$$$ISOK(##class(DHCINM.HR.MgQualRegisted).%DeleteId(rw))
	if ret'=1{
		tro
		q "删除注册信息失败"	
	}
	s rw="" f  s rw=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_id,rw)) q:((rw="")||(ret'=1))  d
	.s roleID="" f  s roleID=$O(^CF.DHCINM.Set.MgDataLimitI("Role",roleID)) q:((roleID="")||(ret'=1))  d
	..s limitID="" f  s limitID=$O(^CF.DHCINM.Set.MgDataLimitI("Role",roleID," "_id,limitID)) q:((limitID="")||(ret'=1))  d
	...s ret=ret&&$$$ISOK(##class(CF.DHCINM.Set.MgDataLimit).%DeleteId(limitID))
	.q:ret'=1
	.s ret=ret&&$$$ISOK(##class(CF.DHCINM.DB.MgUser).%DeleteId(rw))
	if ret'=1{
		tro
		q "删除用户信息失败"	
	}
	s rw="" f  s rw=$O(^CF.DHCINM.HR.EducateI("ssid",id,rw)) q:((rw="")||(ret'=1))  d
	.s ret=ret&&$$$ISOK(##class(CF.DHCINM.HR.Educate).%DeleteId(rw))
	if ret'=1{
		tro
		q "删除教育信息失败"	
	}
	s rw="" f  s rw=$O(^CF.DHCINM.HR.HireDutyI("ssid",id,rw)) q:((rw="")||(ret'=1))  d
	.s ret=ret&&$$$ISOK(##class(CF.DHCINM.HR.HireDuty).%DeleteId(rw))
	if ret'=1{
		tro
		q "删除职称信息失败"	
	}
	s rw="" f  s rw=$O(^CF.DHCINM.HR.PostDutyI("ssid",id,rw)) q:((rw="")||(ret'=1))  d
	.s ret=ret&&$$$ISOK(##class(CF.DHCINM.HR.PostDuty).%DeleteId(rw))
	if ret'=1{
		tro
		q "删除职务信息失败"	
	}
	s rw="" f  s rw=$O(^CF.DHCINM.HR.MgLevelI("ssid",id,rw)) q:((rw="")||(ret'=1))  d
	.s ret=ret&&$$$ISOK(##class(CF.DHCINM.HR.MgLevel).%DeleteId(rw))
	if ret'=1{
		tro
		q "删除层级信息失败"	
	}
	s rw="" f  s rw=$O(^CF.DHCINM.Trans.TransDepI("ssdr"," "_id,rw)) q:((rw="")||(ret'=1))  d
	.s ret=ret&&$$$ISOK(##class(CF.DHCINM.Trans.TransDep).%DeleteId(rw))
	if ret'=1{
		tro
		q "删除转科记录表失败"	
	}
	s ret=ret&&$$$ISOK(##class(CF.DHCINM.HR.Persons).%DeleteId(id))
	if ret'=1{
		tro
		q "删除人员信息失败"	
	}
	TC
	q "删除完成"
}

Storage Default
{
<Data name="INMTestCommDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.INMTestCommD</DataLocation>
<DefaultData>INMTestCommDefaultData</DefaultData>
<IdLocation>^web.INMTestCommD</IdLocation>
<IndexLocation>^web.INMTestCommI</IndexLocation>
<StreamLocation>^web.INMTestCommS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
