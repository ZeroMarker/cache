Class EPRservice.tool.BaseData.Query Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Main(type As %String)
{
	//第一次部署综合查询模块，执行以下语句
	//d ##Class(EPRservice.tool.BaseData.Query).Main("deploy")
	if (type="deploy")
	{
		d ..DeployNewData()	
	}
	//升级综合查询模块，执行以下语句
	//d ##Class(EPRservice.tool.BaseData.Query).Main("update")
	if (type="update")
	{
		d ..UpdateNewData()	
	}
}

/// 部署电子病历综合查询模块，初始化全部数据
ClassMethod DeployNewData()
{
	
	d ..InitQueryItemType()
	d ..InitQueryCategory()
	d ..InitQueryItem()
	d ..InitWMRCodingQueryItem()
}

/// 初始化查询项目类型
ClassMethod InitQueryItemType()
{
	&sql(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) values('str','字符型','Y',''))
	&sql(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) values('num','数字型','Y',''))
	&sql(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) values('date','日期型','Y',''))
	&sql(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) values('time','时间型','Y',''))
	&sql(insert into eprmeta_query.queryitemtype (code,name,isactive,remark) values('datetime','日期时间型','Y',''))
	d ##Class(EPRmeta.Query.QueryItemType).%BuildIndices()
}

/// 初始化查询分类
ClassMethod InitQueryCategory()
{
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('HIS', '基本信息', '0', '1', 'Y', '基本信息'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('Order', '医嘱信息', '0', '2', 'N', '医嘱信息'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('EPR', '电子病历', '0', '3', 'Y', '电子病历'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LIS', '检验信息', '0', '4', 'Y', '检验信息'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('RIS', '检查信息', '0', '5', 'N', '检查信息'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('Glossary', '术语信息', '0', '6', 'Y', '术语信息'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('EPRIndexRecord', '病案首页', '3', '7', 'Y', '病案首页'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('EPRIndexRecord1', '一般情况', '7', '3001', 'Y', '一般情况'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('EPRIndexRecord2', '出院情况', '7', '3002', 'Y', '出院情况'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('EPRIndexRecord3', '手术情况', '7', '3003', 'Y', '手术情况'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('EPRIndexRecord4', '其它情况', '7', '3004', 'Y', '其它情况'))
	&sql(Insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('WMRCoding', '编目信息', '1', '1001', 'Y', '编目信息'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISBloodRoutine', '血常规', '4', '4001', 'Y', '血常规'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISUrineRoutine', '尿常规', '4', '4002', 'Y', '尿常规'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISLiverFunction', '肝功', '4', '4003', 'Y', '肝功'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISRenalFunction', '肾功', '4', '4004', 'Y', '肾功'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISBloodIon', '血离子', '4', '4005', 'Y', '血离子'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISCardiacEnzymes', '心肌酶', '4', '4006', 'Y', '心肌酶'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISIsoenzyme', '心肌酶同工酶', '4', '4007', 'Y', '心肌酶同工酶'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISMicroglobulin', 'Beta2微球蛋白测定', '4', '4008', 'N', ' Beta2微球蛋白测定(化学发光法)'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISThreeCoagulationMarkers', '凝血三项', '4', '4009', 'Y', '凝血三项'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISDextrose', '葡萄糖测定', '4', '4010', 'Y', '葡萄糖测定(空腹)'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISTumorMarker', '肿瘤标志物', '4', '4011', 'Y', '肿瘤标志物'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISFDP', '纤维蛋白(原)降解产物测定', '4', '4012', 'Y', '纤维蛋白(原)降解产物测定'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISBloodDimericDet', '血浆D-二聚体测定', '4', '4013', 'Y', '血浆D-二聚体测定(仪器法) '))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISSHSix', '性激素六项', '4', '4014', 'Y', '性激素六项'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISTCell', ' T细胞绝对值及亚群', '4', '4015', 'N', ' T细胞绝对值及亚群'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISSMb', '血清肌钙蛋白I测定', '4', '4016', 'N', '血清肌钙蛋白I测定'))
	&sql(insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('LISBloodBNP', '血浆B型钠脲肽(BNP)测定', '4', '4017', 'N', '血浆B型钠脲肽(BNP)测定'))
	d ##Class(EPRmeta.Query.QueryCategory).%BuildIndices()
}

/// 初始化查询项目
ClassMethod InitQueryItem()
{
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('EpisodeID','EpisodeID',1,'就诊指针',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('EpisodeNo','EpisodeNo',2,'就诊号',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('RegNo','RegNo',3,'登记号',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('RecordNo','RecordNo',4,'病案号',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('Name','Name',5,'姓名',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('Gender','Gender',6,'性别',1,0,1,'Y','','S06'))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('BirthDate','BirthDate',7,'出生日期',3,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('AdmType','AdmType',8,'就诊类型',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('AdmDate','AdmDate',9,'就诊日期',3,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('AdmTime','AdmTime',10,'就诊时间',4,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('AdmDept','AdmDept',11,'入院科室',1,0,1,'Y','','S07'))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('AdmWard','AdmWard',12,'入院病区',1,0,1,'Y','','S10'))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('DischDate','DischDate',13,'出院日期',3,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('DischTime','DischTime',14,'出院时间',4,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('DischDept','DischDept',15,'出院科室',1,0,1,'Y','','S07'))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('DischWard','DischWard',16,'出院病区',1,0,1,'Y','','S10'))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('MainDoc','MainDoc',17,'主管医生',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('CurRoom','CurRoom',18,'病房',1,0,1,'Y','',1))
	&sql(insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('CurBed','CurBed',19,'床位',1,0,1,'Y','',1))
}

/// 初始化经过病案编目后的查询项目
ClassMethod InitWMRCodingQueryItem()
{
	&sql(select ID into :newCategoryID from EPRmeta_Query.QueryCategory where Code='WMRCoding')
	s CategoryID = newCategoryID_"001"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OpDiagnoseDesc','OpDiagnoseDesc',:CategoryID,'BM门(急)诊诊断',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"002"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OpDiagnoseICD','OpDiagnoseICD',:CategoryID,'BM门(急)诊诊断ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"003"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('MainDiagnoseDesc','MainDiagnoseDesc',:CategoryID,'BM主要诊断',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"004"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('MainDiagnoseICD','MainDiagnoseICD',:CategoryID,'BM主要诊断ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"005"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('IpDiagnoseDesc','IpDiagnoseDesc',:CategoryID,'BM入院诊断',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"006"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('IpDiagnoseICD','IpDiagnoseICD',:CategoryID,'BM入院诊断ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"007"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('PathologyDiagnoseDesc','PathologyDiagnoseDesc',:CategoryID,'BM病理诊断',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"008"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('PathologyDiagnoseICD','PathologyDiagnoseICD',:CategoryID,'BM病理诊断ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"009"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('DamAndPoisonDiagnoseDesc','DamAndPoisonDiagnoseDesc',:CategoryID,'BM损伤中毒诊断',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"010"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('DamAndPoisonDiagnoseICD','DamAndPoisonDiagnoseICD',:CategoryID,'BM损伤中毒诊断ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"011"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('InfectDiagnoseDesc','InfectDiagnoseDesc',:CategoryID,'BM医院感染诊断',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"012"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('InfectDiagnoseICD','InfectDiagnoseICD',:CategoryID,'BM医院感染诊断ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"013"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc1','OtherDiagnoseDesc1',:CategoryID,'BM其他诊断1',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"014"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD1','OtherDiagnoseICD1',:CategoryID,'BM其他诊断1ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"015"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc2','OtherDiagnoseDesc2',:CategoryID,'BM其他诊断2',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"016"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD2','OtherDiagnoseICD2',:CategoryID,'BM其他诊断2ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"017"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc3','OtherDiagnoseDesc3',:CategoryID,'BM其他诊断3',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"018"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD3','OtherDiagnoseICD3',:CategoryID,'BM其他诊断3ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"019"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc4','OtherDiagnoseDesc4',:CategoryID,'BM其他诊断4',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"020"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD4','OtherDiagnoseICD4',:CategoryID,'BM其他诊断4ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"021"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc5','OtherDiagnoseDesc5',:CategoryID,'BM其他诊断5',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"022"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD5','OtherDiagnoseICD5',:CategoryID,'BM其他诊断5ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"023"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc6','OtherDiagnoseDesc6',:CategoryID,'BM其他诊断6',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"024"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD6','OtherDiagnoseICD6',:CategoryID,'BM其他诊断6ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"025"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc7','OtherDiagnoseDesc7',:CategoryID,'BM其他诊断7',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"026"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD7','OtherDiagnoseICD7',:CategoryID,'BM其他诊断7ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"027"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc8','OtherDiagnoseDesc8',:CategoryID,'BM其他诊断8',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"028"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD8','OtherDiagnoseICD8',:CategoryID,'BM其他诊断8ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"029"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc9','OtherDiagnoseDesc9',:CategoryID,'BM其他诊断9',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"030"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD9','OtherDiagnoseICD9',:CategoryID,'BM其他诊断9ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"031"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc10','OtherDiagnoseDesc10',:CategoryID,'BM其他诊断10',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"032"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD10','OtherDiagnoseICD10',:CategoryID,'BM其他诊断10ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"033"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc11','OtherDiagnoseDesc11',:CategoryID,'BM其他诊断11',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"034"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD11','OtherDiagnoseICD11',:CategoryID,'BM其他诊断11ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"035"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc12','OtherDiagnoseDesc12',:CategoryID,'BM其他诊断12',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"036"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD12','OtherDiagnoseICD12',:CategoryID,'BM其他诊断12ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"037"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc13','OtherDiagnoseDesc13',:CategoryID,'BM其他诊断13',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"038"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD13','OtherDiagnoseICD13',:CategoryID,'BM其他诊断13ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"039"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc14','OtherDiagnoseDesc14',:CategoryID,'BM其他诊断14',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"040"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD14','OtherDiagnoseICD14',:CategoryID,'BM其他诊断14ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"041"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc15','OtherDiagnoseDesc15',:CategoryID,'BM其他诊断15',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"042"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD15','OtherDiagnoseICD15',:CategoryID,'BM其他诊断15ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"043"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc16','OtherDiagnoseDesc16',:CategoryID,'BM其他诊断16',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"044"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD16','OtherDiagnoseICD16',:CategoryID,'BM其他诊断16ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"045"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc17','OtherDiagnoseDesc17',:CategoryID,'BM其他诊断17',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"046"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD17','OtherDiagnoseICD17',:CategoryID,'BM其他诊断17ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"047"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc18','OtherDiagnoseDesc18',:CategoryID,'BM其他诊断18',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"048"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD18','OtherDiagnoseICD18',:CategoryID,'BM其他诊断18ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"049"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc19','OtherDiagnoseDesc19',:CategoryID,'BM其他诊断19',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"050"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD19','OtherDiagnoseICD19',:CategoryID,'BM其他诊断19ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"051"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc20','OtherDiagnoseDesc20',:CategoryID,'BM其他诊断20',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"052"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD20','OtherDiagnoseICD20',:CategoryID,'BM其他诊断20ICD',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"053"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseDesc21','OtherDiagnoseDesc21',:CategoryID,'BM其他诊断21',1,0,:newCategoryID,'Y','',1))
	s CategoryID = newCategoryID_"054"
	&sql(Insert into eprmeta_query.queryitem(code,name,sequence,title,queryitemtypeid,parentid,categoryid,isactive,remark,StdDic) values('OtherDiagnoseICD21','OtherDiagnoseICD21',:CategoryID,'BM其他诊断21ICD',1,0,:newCategoryID,'Y','',1))
	
	d ##Class(EPRmeta.Query.QueryItem).%BuildIndices()
}

/// 升级电子病历综合查询模块，初始化部分数据
/// 每当升级时有需要初始化的数据时，新加一个单独的方法，保证每个方法有单独的功能；
ClassMethod UpdateNewData()
{
	d ..UpdateQueryItem()
	d ..CheckQueryCategory()
}

/// 升级时检查QueryCategory中是否存在WMRCoding(编目信息)，若有则不进行处理；若无则添加该分类，并初始化经过病案编目后的查询项目；
ClassMethod CheckQueryCategory()
{
	&sql(select ID into :CategoryID from EPRmeta_Query.QueryCategory where Code='WMRCoding')
	if (CategoryID="")
	{
		&sql(Insert into eprmeta_query.querycategory (code, name, parentid, sequence, isactive, remark) values ('WMRCoding', '编目信息', '1', '1001', 'Y', '编目信息'))
		d ##Class(EPRmeta.Query.QueryCategory).%BuildIndices()
		d ..InitWMRCodingQueryItem()
	}
}

/// 查询项目的值对应的是字典数据时的数据更新
ClassMethod UpdateQueryItem()
{
	&sql(update EPRmeta_Query.QueryItem set StdDic=1)
	&sql(update EPRmeta_Query.QueryItem set StdDic='S06' where CategoryID=1 and Code='Gender')
	&sql(update EPRmeta_Query.QueryItem set StdDic='S07' where CategoryID=1 and Code='AdmDept')
	&sql(update EPRmeta_Query.QueryItem set StdDic='S10' where CategoryID=1 and Code='AdmWard')
	&sql(update EPRmeta_Query.QueryItem set StdDic='S07' where CategoryID=1 and Code='DischDept')
	&sql(update EPRmeta_Query.QueryItem set StdDic='S10' where CategoryID=1 and Code='DischWard')
}

}
