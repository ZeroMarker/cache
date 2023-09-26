/// 做树——检查项目对应检查点 
Class dhc.qm.udata.uChuTest2 Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:     chuyali
/// CreateDate:  2015-09-09
/// Description: 查出检查项目
/// Table:       dhc_qm_data.Qmschem (dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail、dhc_qm_data.CheckInfo)
/// Input:       parentId:父节点id
/// Return:     json格式:[{id:'1',km:'深入浅出ExtJs',ks:'12month',js:'',uiProvider:'col',parent:'roo'}]
/// Others:  w ##class(dhc.qm.udata.uChuTest2).GetQmschem("root")
ClassMethod GetQmschem(parentId As %String) As %String
{
	//写sql查出所有的检查项目
	set sqlstr = "select QMSchem_RowID ,QMSchem_name,QMSchem_Code from dhc_qm_data.Qmschem where %ID>0 "
	//执行sql
	set result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlstr)
	d result.Execute()
	
	//拼返回的json串
	set jsonStr = "["
	set count=0
	while(result.Next()){
		set schemId = result.Data("QMSchem_RowID")
		set schemCode = result.Data("QMSchem_Code")
		set schemName =result.Data("QMSchem_name")
		
		set childrenjson = ..GetCheckInfoBySchem(schemId)
		
		set jsonStr = jsonStr_"{id:'"_schemId_"',code:'"_schemCode_"',name:'"_schemName_"',uiProvider:'col',parentId:'"_parentId_"',"_childrenjson_"},"
		
		set count= count+1

		}
	set jsonStr=jsonStr_"]"
	
	d result.Close()
	q jsonStr
}

/// Creator:     chuyali
/// CreateDate:  2015-09-11
/// Description: 查询检查点
/// Table:       dhc_qm_data.CheckInfo 
/// Input:       dataStr 格式：id^name^code^Y^Q
/// Return:     0：成功  1：失败
/// Others:  w ##class(dhc.qm.udata.uChuTest2).GetCheckInfo()
ClassMethod GetCheckInfo() As %String
{
	
	set sqlStr = "select Check_rowid,Check_name from dhc_qm_data.CheckInfo where %ID>0"	
	
	set result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	set count=0
	set resultstr = ""
	set json = ##class(dhc.pa.com.JsonObj).%New()
	while(result.Next()){
		set id = result.Data("Check_rowid")
		set name = result.Data("Check_name")
		set count=count+1
		set temp = id_"^"_name
		
		d json.InsertRowData(temp)
	}
	d result.Close()
	
	set resultstr = json.getJsonData("id^name",count)
	
	k json
	q resultstr
}

/// w ##class(dhc.qm.udata.uChuTest2).perList()
ClassMethod perList() As %String
{
	
	set sqlStr = "select Top 10 PAPMI_RowId, PAPMI_Name from pa_patmas where %ID>0"	
	
	set result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	set count=0
	set resultstr = ""
	set json = ##class(dhc.pa.com.JsonObj).%New()
	while(result.Next()){
		set id = result.Data("PAPMI_RowId")
		set name = result.Data("PAPMI_Name")
		set count=count+1
		set temp = id_"^"_name
		
		d json.InsertRowData(temp)
	}
	d result.Close()
	
	set resultstr = json.getJsonData("id^name",count)
	
	k json
	q resultstr
}

/// Creator:     chuyali
/// CreateDate:  2015-09-11
/// Description: 为检查项目添加检查点
/// Table:         dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail、
/// Input:       dataStr 格式：12^1,2,3
/// Return:     0：成功  1：失败
/// Others: w ##class(dhc.qm.udata.uChuTest2).addCheckInfoBySchem("96^1,2,3")
ClassMethod addCheckInfoBySchem(checkInfoIds) As %String
{
	
	new %ROWID
	set parentId = $p(checkInfoIds,"^",1)
	set checkInfoIds = $p(checkInfoIds,"^",2)
	set mainRowID = ""
	/*先向dhc_qm_data.LocResultMain中插入一条数据
		LocResultMain_schemDr为parentId*/
	/*  再向表dhc_qm_data.LocResultdetail中插入记录
	 	LocResultdetail_parRef为LocResultMain刚生成的rowid
	 	LocResultdetail_checkDr为checkInfoId  
	
	
	*/	
	&sql(insert into dhc_qm_data.LocResultMain (LocResultMain_schemDr) values(:parentId))	
	if SQLCODE =0 d
	.set mainRowID = %ROWID	
	.//去掉逗号的长度
	.set len = $l(checkInfoIds,",")
	.for i=1:1:len  do
	..set checkId = $p(checkInfoIds,",",i)
	..&sql(insert into dhc_qm_data.LocResultdetail (LocResultdetail_parRef,LocResultdetail_checkDr) values(:mainRowID,:checkId))
	..i SQLCODE '=0  q
	
	q SQLCODE
}

/// Description: 根据检查项目查检查点
/// Table:       dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail、dhc_qm_data.CheckInfo
/// Input:       schemId:父节点id
/// Return:     json格式:children:[ 
///      					  		 {name:'ExtJs01',id:'6month',code:'lwc',uiProvider:'col',leaf:true},  
///        						  ]
/// Others:  w ##class(dhc.qm.udata.uChuTest2).GetCheckInfoBySchem("1")
ClassMethod GetCheckInfoBySchem(schemId As %String) As %String
{
	
	s sqlstr = "select LocResultdetail_checkDr->Check_rowid as id,LocResultdetail_checkDr->Check_name as name, LocResultdetail_checkDr->Check_code as code from dhc_qm_data.LocResultdetail where LocResultdetail_parRef->LocResultMain_schemDr='"_schemId_"' group by LocResultdetail_checkDr->Check_rowid"
	s result2 = ##class(%Library.ResultSet).%New()
	d result2.Prepare(sqlstr)
	d result2.Execute()
	
	set jsonChild = "children:["
	while(result2.Next()){
		set name = result2.Data("name")
		set id = result2.Data("id")
		set code = result2.Data("code")
		
		set jsonChild = jsonChild_"{id:'0"_id_"',name:'"_name_"',code:'"_code_"',uiProvider:'col',leaf:true},"
		}
		d result2.Close()
		set jsonChild = jsonChild_"]"
	
		q jsonChild
}

/// Creator:     chuyali
/// CreateDate:  2015-09-10
/// Description: 查出检查项目和检查点
/// Table:       dhc_qm_data.Qmschem (dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail、dhc_qm_data.CheckInfo)
/// Input:       parentId:父节点id
/// Return:     json格式:[{id:'1',code:'001',name:'手术知情同意书',uiProvider:'col',parentId:'root',parentName:'手术风险'}]
/// Others:  w ##class(dhc.qm.udata.uChuTest2).GetByParentId("root")
ClassMethod GetByParentId(parentId As %String) As %String
{
	/**
		想要通过父节点的id，来查找他的孩子节点的内容
		1、首先得到前台出来的parentId
		2、怎样写sql：(现在只能通过传入的parentId进行判断)
			分两种情况：
				（1）根节点查询：在表Qmschem中
				（2）枝干节点：在三个表中
		3、得到查询的结果集，就要对其行json串的组合
		4、关闭result，返回json串
		*/
		//设置标识叶子节点
		
		set leaf = ""
		i parentId '= "root"  do
		.set parentId = $p(parentId,"-",2)
		.set sqlstr = "select LocResultdetail_checkDr->Check_rowid as id,LocResultdetail_checkDr->Check_name as name, LocResultdetail_checkDr->Check_code as code from dhc_qm_data.LocResultdetail where LocResultdetail_parRef->LocResultMain_schemDr='"_parentId_"' group by LocResultdetail_checkDr->Check_rowid"
		.set leaf = "true"
		else  do
		.set sqlstr = "select QMSchem_RowID as id ,QMSchem_name as name,QMSchem_Code as code from dhc_qm_data.Qmschem where %ID>0 "
		.set leaf = "false"
			//执行sql
		set result = ##class(%Library.ResultSet).%New()
		d result.Prepare(sqlstr)
		d result.Execute()
	
		//拼返回的json串
		set jsonStr = "["
		set count=0
		while(result.Next()){
			set schemId = result.Data("id")
			set schemCode = result.Data("code")
			set schemName =result.Data("name")
			
			set count= count+1
			
			set jsonStr = jsonStr_"{id:'"_parentId_"-"_schemId_"',code:'"_schemCode_"',name:'"_schemName_"',uiProvider:'col',parentId:'"_parentId_"',parentName:'"_count_"',leaf:"_leaf_"},"
		
			}
		set jsonStr=jsonStr_"]"
	
		d result.Close()
		q jsonStr
}

/// Creator:     chuyali
/// CreateDate:  2015-09-10
/// Description: 查出检查项目新增
/// Table:       dhc_qm_data.Qmschem 
/// Input:       dataStr 格式：name^code^Y^Q
/// Return:     0：成功  1：失败
/// Others:  w ##class(dhc.qm.udata.uChuTest2).AddQmschem("name^code^Y^Q")
ClassMethod AddQmschem(dataStr) As %String
{
	//分解数据
	set name = $p(dataStr,"^",1)
	set code = $p(dataStr,"^",2)
	//set active = $p(dataStr,"^",3)
	//set peroidType = $p(dataStr,"^",4)
	
	&sql(insert into dhc_qm_data.Qmschem (QMSchem_name,QMSchem_Code) values(:name,:code) )
	q SQLCODE
}

/// Creator:     chuyali
/// CreateDate:  2015-09-10
/// Description: 查出检查项目删除
/// Table:       dhc_qm_data.Qmschem 
/// Input:       dataStr 格式：name^code^Y^Q
/// Return:     0：成功  1：失败
/// Others:  w ##class(dhc.qm.udata.uChuTest2).DelQmschem("23")
ClassMethod DelQmschem(schemId) As %String
{
	//分解数据
	
	&sql(delete from dhc_qm_data.Qmschem where %ID=:schemId )
	q SQLCODE
}

/// Creator:     chuyali
/// CreateDate:  2015-09-11
/// Description: 修改检查项目
/// Table:       dhc_qm_data.Qmschem 
/// Input:       dataStr 格式：id^name^code^Y^Q
/// Return:     0：成功  1：失败
/// Others:  w ##class(dhc.qm.udata.uChuTest2).EditQmschem("23")
ClassMethod EditQmschem(dataStr) As %String
{
	
	set id = $p(dataStr,"^",1)
	set name = $p(dataStr,"^",2)
	set code = $p(dataStr,"^",3)
	
	&sql(update  dhc_qm_data.Qmschem  set QMSchem_name=:name,QMSchem_Code=:code where %ID=:id )
	
	q SQLCODE
}

/// Creator:     chuyali
/// CreateDate:  2015-09-11
/// Description: 修改检查项目和对应的检查点
/// Table:       dhc_qm_data.Qmschem ，dhc_qm_data.LocResultMain、dhc_qm_data.LocResultdetail
/// Input:       dataStr 格式：id^name^code^1,2,3（检查点rowid）
/// Return:     0：成功  1：失败
/// Others:  w ##class(dhc.qm.udata.uChuTest2).EditQmschemCheck("29^kkk^123^1,2,3")
ClassMethod EditQmschemCheck(dataStr) As %String
{

	/*
	*修改检查项对应的检查点分下面几步骤
	1、处理入参
	2、要将id，name，code更新到表dhc_qm_data.Qmschem里面
	3、查出改id对应表dhc_qm_data.LocResultMain的rowid
	4、删除表dhc_qm_data.LocResultdetail中LocResultdetail_parRef=rowid的记录
	5、在将新的数据插入
	*/	
	

	//====1、
	set id = $p(dataStr,"^",1)
	set name = $p(dataStr,"^",2)
	set code = $p(dataStr,"^",3)
	set checkInfoIds = $p(dataStr,"^",4)
	//====2、
	&sql(update  dhc_qm_data.Qmschem  set QMSchem_name=:name,QMSchem_Code=:code where %ID=:id )
	if (SQLCODE=0){
		//更新成功
		//====3
		&sql(select LocResultMain_rowid INTO :mainRowid from dhc_qm_data.LocResultMain where LocResultMain_schemDr = :id)
		if (SQLCODE=0){
			//====4
			&sql(delete  from dhc_qm_data.LocResultdetail where LocResultdetail_parRef =:mainRowid)
			if (SQLCODE=0){
				//去掉逗号的长度
				set len = $l(checkInfoIds,",")
				for i=1:1:len  do
				.set checkId = $p(checkInfoIds,",",i)
				.&sql(insert into dhc_qm_data.LocResultdetail (LocResultdetail_parRef,LocResultdetail_checkDr) values(:mainRowid,:checkId))
				.i SQLCODE '=0  q
				q SQLCODE
			}else{
				//删除不成功
				q "删除不成功"
			}
		}else{
			//查询不成功	
			q "查询不成功"
		}
	}else{
		//更新不成功
		q "更新不成功"	
	}
}

Storage Default
{
<StreamLocation>^dhc.qm.udata.uChuTest2S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
