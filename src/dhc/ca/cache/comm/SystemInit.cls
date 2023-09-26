Class dhc.ca.cache.comm.SystemInit Extends (%SerialObject, %Populate, %XML.Adaptor) [ ClassType = serial, Inheritance = right, Not ProcedureBlock ]
{

Projection NewProjection1 As %Projection.Java;

/// Creator：许立新
/// CreatDate：2010-2-4
/// Description: 人员数据写入
/// Table：dhc_ca_cache_data.UnitPersons
/// Input：code-代码,name-姓名,unitDr-单元
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.SystemInit).Person("a^张三^1-张三^^^^^^^^^^^^^^1^Y")
/// code^name^shortcut^gender^birthday^national^birthPlace^education^title^duty^state^preparation^phone^remark^start^stop^unitDr^active
ClassMethod Person(info) As %String
{
	n (info)
	
	k PLIST
	
	s code=$p(info,"^",1)         //代码
	i code'="" s PLIST(2)=code
	
	s name=$p(info,"^",2)         //姓名
	i name'="" s PLIST(3)=name
	
	s shortcut=$p(info,"^",3)     //快捷码
	i shortcut'="" s PLIST(4)=shortcut
	
	s gender=$p(info,"^",4)       //性别
	i gender'="" s PLIST(5)=gender
	
	s birthday=$p(info,"^",5)     //生日
	i birthday'="" s PLIST(6)=birthday
	
	s national=$p(info,"^",6)     //民族
	i national'="" s PLIST(7)=national
	
	s birthPlace=$p(info,"^",7)   //籍贯
	i birthPlace'="" s PLIST(8)=birthPlace
	
	s education=$p(info,"^",8)    //学历
	i education'="" s PLIST(9)=education
	
	s title=$p(info,"^",9)        //职称
	i title'="" s PLIST(10)=title
	
	s duty=$p(info,"^",10)        //职务
	i duty'="" s PLIST(11)=duty
	
	s state=$p(info,"^",11)       //状态
	i state'="" s PLIST(12)=state
	
	s preparation=$p(info,"^",12) //编制
	i preparation'="" s PLIST(13)=preparation
	
	s phone=$p(info,"^",13)       //电话
	i phone'="" s PLIST(14)=phone
	
	s remark=$p(info,"^",14)      //备注
	i remark'="" s PLIST(15)=remark
	
	s start=$p(info,"^",15)       //入职日期
	i start'="" s PLIST(16)=start
	
	s stop=$p(info,"^",16)        //离职日期
	i stop'="" s PLIST(17)=stop
	
	s unitDr=$p(info,"^",17)      //单位Dr
	i unitDr'="" s PLIST(18)=unitDr
	
	s active=$p(info,"^",18)      //有效标志
	i active'="" s PLIST(19)=active
	
	&SQL(INSERT INTO dhc_ca_cache_data.UnitPersons VALUES PLIST())
	q SQLCODE
}

/// Creator：许立新
/// CreatDate：2010-2-5
/// Description: 人员编制、人员科室写入
/// Table：dhc_ca_cache_data.UnitPersons
/// Input：unitDr-单位Dr,code-人员代码,unitDeptCode-部门代码,rate-比例,own-行政归属,pre-编制
/// Output：
/// Return：SQLCODE
/// Others：w ##class(dhc.ca.cache.comm.SystemInit).PreDept("1^42002^503^100^Y^在职")
/// unitDr^code^unitDeptCode^rate^own^pre
ClassMethod PreDept(info) As %String
{
	n (info)
	q:info="" 1
	
	s unitDr=$p(info,"^",1)
	s code=$p(info,"^",2)
	s unitDeptCode=$p(info,"^",3)
	s rate=$p(info,"^",4)
	s own=$p(info,"^",5)
	s pre=$p(info,"^",6)
	
	s r=0
	
	q:unitDr="" 2
	q:code="" 3
	q:unitDeptCode="" 4
	
	i rate="" s rate=100
	i own'="Y" s own="N"
	
	//找人员rowid
	s prowid=0
	s prowid=$o(^DHCCAUNITPERSONS(0,"UnitCode",unitDr,code,prowid))
	s drowid=0
	s drowid=$o(^DHCCAUNITDEPTS(0,"UnitCode",unitDr,unitDeptCode,drowid))
	
	i prowid'="" d
	.//写编制
	.&SQL(UPDATE dhc_ca_cache_data.UnitPersons SET UnitPersons_preparation=:pre WHERE %ID=:prowid)
	.i SQLCODE'=0 s r=8
	.i drowid'="" d
	..//写科室
	..&SQL(INSERT INTO dhc_ca_cache_data.PersonDepts (PersonDepts_parRef,PersonDepts_deptDr,PersonDepts_rate,PersonDepts_own) VALUES (:prowid,:drowid,:rate,:own))
	..i SQLCODE'=0 s r=9
	
	q r
}

Storage Default
{
<StreamLocation>^dhc.ca.c.SystemInitS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
