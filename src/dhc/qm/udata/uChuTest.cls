Class dhc.qm.udata.uChuTest Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//<Request>

//   <qmschemDr>检查项目ID(1)</qmschemDr>

//   <startDate>检查开始日期（2014-12-01）</startDate>

//   <endDate>检查开始日期（2015-02-28）</endDate>

//   <deptGroupDr>科室组ID(单条记录1)</deptGroupDr>

//   <wardDr>病区ID</wardDr>

//</Request>

/// 病人信息列表
/// 2015-8-26
/// 返回数据集rows 
/// patRowid,admNo,patName,inPatCode,Indoccode,IndocName,OperationID,OperationName,Operationdate
/// 请求参数：
/// w ##class(dhc.qm.udata.uChuTest).GetOperList("<Request><qmschemDr>333</qmschemDr><deptGroupDr>2</deptGroupDr><wardDr>19</wardDr></Request>")
ClassMethod GetOperList(Param As %String) As %String
{

	
	
	//要开始解析xml啦
	//1、创建一个读xml的类
	set readerXML = ##class(%XML.Reader).%New()
	//2、打开请求串(返回的是一个状态)
	set sc = readerXML.OpenString(Param)
	//将一个类名和xml的tag name关联起来，这样在后面才能用.request
	 d readerXML.Correlate("Request","dhc.qm.data.Request")
	//读Request类下的内容
	while readerXML.Next(.request,.sc){
		//wardDr,qmschemDr...都是dhc.qm.data.Request里面定义的属性
		set wardid= request.wardDr
		set qmschem = request.qmschemDr
		set deptGroupid = request.deptGroupDr
		
		}
		q:wardid=""
		//将处理业务的再放个方法里吧(╯﹏╰)，而且要有返回值的。
		set resultStr = ..OperList(deptGroupid,wardid)	
		
	q resultStr
}

/// 方法：用来获取返回的数据集 patRowid,admNo,patName,
/// 2015-8-26
/// w ##class(dhc.qm.udata.uChuTest).OperList("10","19")
ClassMethod OperList(deptGroupid As %String, wardid As %String) As %String
{
	
	/*******patRowid,admNo,patName,*******/
	set count=0
	 //要组成json数据
	set json = ##class(dhc.pa.com.JsonObj).%New()
	set jsonTitle = "patRowid^admNo^patName^inPatCode^indoccode^indocname"
	/******************根据当前病区id，查科室组******************/
		
	/******************根据当前病区id，查病人******************/
	//循环病区内所有病房的人员信息，再判断得到的患者id是不是在手术的表中，要是存在则输出患者信息
	set roomid =0	
	for  set roomid = $o(^PAADMi("CurrWard",wardid,roomid))  q:roomid=""  do
	.; 得到病房id之后，循环病人，得到病人id
	.set perRowid = ""
	.for  set perRowid=$o(^PAADMi("CurrWard",wardid,roomid,perRowid))  q:perRowid=""  do
	..;获取病人信息。如果不用$g,若per为空，则会报错
	..set per = $g(^PAPER(perRowid,"ALL"))
	..q:per=""
	..set patRowid=perRowid
	..set patName = $p(per,"^",1)
	..set admNo = +$p(^PAPER(perRowid,"PAT",1),1) ;+号，去掉前面的0
	..//*********inPatCode,Indoccode,IndocName,******/
	..set patmas = $g(^PAADM(perRowid))
	..set inPatCode = $p(^PAPER(perRowid,"PAT",1),"^",22)
	..set indocrowid = $p(patmas,"^",9)
	..q:indocrowid=""
	..set indoc =^CTPCP(indocrowid,1)
	..set indoccode =$p(indoc,"^",1)
	..set indocname =$p(indoc,"^",2)
	..set count=count+1
	..;定义好格式之后，要加载数据啦
	..set jsonData = patRowid_"^"_admNo_"^"_patName_"^"_inPatCode_"^"_indoccode_"^"_indocname
	..do json.InsertRowData(jsonData)	
		//取出json串
		set jsonStr = json.getJsonData(jsonTitle,count)
		/*************************json**********************************/
		
		q jsonStr
}

/**
在表PA_adm中查出前5个人信息
**/
/// 用来测试手机和数据库连接
/// w ##class(dhc.qm.udata.uChuTest).perList()
ClassMethod perList(param As %String) As %String
{
	//获得数据放入result中
	set sqlstr="select top 5 PAADM_RowID as rowid,PAADM_PAPMI_DR->PAPMI_Name as name,PAADM_ADMNo as admno from PA_adm"
	
	set result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlstr)
	d result.Execute()
	///将获得的数据转为json格式
	///json格式：{results:26,rows:[{rowid:'1'，。。。}，{}]
	set count=0
	
	s json = ##class(herp.comm.JsonObj).%New()
	s jsonTitle = "rowid^name^admno"
	
	while(result.Next()){
		//拼json格式的数据
		set rowid = result.Data("rowid")
		set name = result.Data("name")
		set admno = result.Data("admno")
		
		set pinstr = rowid_"^"_name_"^"_admno
		
		//将数据放入json格式中
		do json.InsertRowData(pinstr)
		set count=count+1
		}
	//关闭result
	d result.Close()
	//读取json
	s resultjson = json.getJsonData(jsonTitle,count)
	k json
	q resultjson
}

Storage Default
{
<StreamLocation>^dhc.qm.udata.uChuTestS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
