Class dhc.pa.udata.uSchem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-07-26
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uSchem).ListRec("","","","","",0,25)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (active,searchField, searchValue,sortField, sortDir, start, limit)
		s Stratagem = ""
		s curreStratagemDr = ""
		f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
		.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
		..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
		...s curreStratagem = $p(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
		...if curreStratagem="Y" d
		....s curreStratagemDr = Stratagem
		
		s sqlStr="SELECT Schem_rowid,Schem_parRef,Schem_code,Schem_name,Schem_shortcut,Schem_appSysDr,Schem_frequency,Schem_KPIDr,Schem_desc,Schem_active,Schem_level,  Schem_ComputeType, Schem_UpSchemDr,Schem_flag   FROM dhc_pa_data.Schem WHERE Schem_childSub>0 and Schem_parRef="_curreStratagemDr
	
				
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="Schem_rowid"
		.i sortField="parRef" s sortField1="Schem_parRef"
		.i sortField="code" s sortField1="Schem_code"
		.i sortField="name" s sortField1="Schem_name"
		.i sortField="shortcut" s sortField1="Schem_shortcut"
		.i sortField="appSysDr" s sortField1="Schem_appSysDr"
		.i sortField="frequency" s sortField1="Schem_frequency"
		.i sortField="KPIDr" s sortField1="Schem_KPIDr"
		.i sortField="desc" s sortField1="Schem_desc"
		.i sortField="active" s sortField1="Schem_active"
		.i sortField="level" s sortField1="Schem_level"
		.i sortField="flag" s sortField1="Schem_flag"
	
	
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		e  d
		.s sortStr=" ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		s result=##class(%Library.ResultSet).%New()
		
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		//2013-07-15 update
		s jsonTitle="rowid^parRef^code^name^shortcut^appSysDr^frequency^KPIDr^KPIName^desc^level^appSys^quency^computeTypeDr^computeTypeName^upschemDr^upschemName^schemType^schemFlag^isStop"
		s KPIName = "",	computeTypeName=""

		While(result.Next())
		{
			s rowid=result.Data("Schem_rowid")
			s parRef=result.Data("Schem_parRef")
			s code=result.Data("Schem_code")
			s name=result.Data("Schem_name")
			s shortcut=result.Data("Schem_shortcut")
			s appSysDr=result.Data("Schem_appSysDr")
			s appSys = appSysDr
			i appSysDr="1" s appSysDr="全院"
			i appSysDr="2" s appSysDr="科室"
			i appSysDr="3" s appSysDr="护理"
			i appSysDr="4" s appSysDr="医疗"
			i appSysDr="5" s appSysDr="个人"
			s frequency=result.Data("Schem_frequency")
			s quency = frequency
			i frequency="M" s frequency="月"
			i frequency="Q" s frequency="季"
			i frequency="Y" s frequency="年"
			i frequency="H" s frequency="半年"
			s KPIDr=result.Data("Schem_KPIDr")
	
			s KPIName=""
			
			;i KPIDr'="" d
			.;s KPIName = $p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
			
			i KPIDr'="" s KPIName=..GetResultKpi(KPIDr)
			
			
			s desc=result.Data("Schem_desc")
			s level=result.Data("Schem_level")
			s isStop=result.Data("Schem_active") //2016-8-2 add cyl
			//处理方式 和 上级方案 名称   computeType   upschem
			
			s computeTypeDr=result.Data("Schem_ComputeType")
			i computeTypeDr=1  s computeTypeName="现有处理方式"
			i computeTypeDr=2  s computeTypeName="特殊处理方式"
			i computeTypeDr=3  s computeTypeName="差额处理方式"
			
			
			s upschemDr=result.Data("Schem_UpSchemDr")
			s schemFlag=""
			//2013-07-15 update
			s flag=result.Data("Schem_flag")
			i (flag="Y")||(flag="Yes") d
			.s schemFlag="调查问卷"
			i (flag="N")||(flag="No")||(flag="") d
			.s schemFlag="一般方案"
			s upschemName=""
			//上级方案名称 2012-02-01
			i upschemDr'="" s upschemName=..GetSchemName(upschemDr)
			;i rowid="1||21" b
			;w computeTypeName_"^"_upschemName ,!
			
			//2013-07-15 update
			s tmp=rowid_"^"_parRef_"^"_code_"^"_name_"^"_shortcut_"^"_appSysDr_"^"_frequency_"^"_KPIDr_"^"_KPIName_"^"_desc_"^"_level_"^"_appSys_"^"_quency_"^"_computeTypeDr_"^"_computeTypeName_"^"_upschemDr_"^"_upschemName_"^"_flag_"^"_schemFlag_"^"_isStop
			
			
			i searchValue'="" d
			.q:(searchField="code")&(code'[searchValue)
			.q:(searchField="name")&(name'[searchValue)
			.q:(searchField="shortcut")&(shortcut'[searchValue)
			.q:(searchField="desc")&(desc'[searchValue)
			.q:(searchField="flag")&(flag'[searchValue)
			.q:(searchField="active")&(isStop'[searchValue)
			.s count=count+1  //2015-05-02 update 
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.s count=count+1 //2015-05-02 update
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: wang ying
/// CreatDate: 2010-07-26
/// Description: 代码是否存在
/// Table: dhc.pa.data.Schem
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.pa.udata.uSchem).IfRepCode("201006")
ClassMethod IfRepCode(parRef, code) As %String
{
	n (code,parRef)
	s rowid=0
	s rowid=$o(^DHCCJXPASTRATAGEM(0,"SchemCode",parRef,code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: wang ying
/// CreatDate: 2010-07-26
/// Description: 名称是否存在
/// Table: dhc.pa.data.Schem
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.pa.udata.uSchem).IfRepName("工资费用")
ClassMethod IfRepName(parRef, name) As %String
{
	n (name,parRef)
	s rowid=0
	s rowid=$o(^DHCCJXPASTRATAGEM(0,"SchemName",parRef,name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: wang ying
/// CreatDate:  2010-07-26
/// Description: 插入新记录
/// Table: dhc.pa.data.Schem
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uSchem).InsertRec("20133003^合格率调查^2^M^49^1^^Y")
ClassMethod InsertRec(data) As %String
{
		n (data)
		;s ^tmpwy(1)=data
		k PLIST
		q:data="" "EmptyRecData"
		
		s Stratagem = ""
		s curreStratagemDr = ""
		f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
		.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
		..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
		...s curreStratagem = $p(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
		...if curreStratagem="Y" d
		....s curreStratagemDr = Stratagem
		
		s code=$p(data,"^",1)
		s name=$p(data,"^",2)
		s appSysDr = $p(data,"^",3)
 		s frequency = $p(data,"^",4)
 		s level=1
 		s KPIDr = $p(data,"^",5)
 		s ^chuSql=KPIDr
 		//处理方式 和 上级方案  
 		s computeType = $p(data,"^",6)
 		s upschem = $p(data,"^",7)
 		s schemFlag =$p(data,"^",8)
 		

		s rowid=0
		s rowid=..IfRepCode(curreStratagemDr,code)
		q:rowid>0 "RepCode"
		s rowid=..IfRepName(curreStratagemDr,name)
		q:rowid>0 "RepName"

		s shortcut=code_"-"_name
		s active = "Y"
		i curreStratagemDr'="" s PLIST(0)=curreStratagemDr
		i code'="" s PLIST(3)=code
		i name'="" s PLIST(4)=name
		i shortcut'="" s PLIST(5)=shortcut
		i appSysDr'="" s PLIST(6)=appSysDr
		i frequency'="" s PLIST(7)=frequency
		i KPIDr'="" s PLIST(8)=KPIDr
		i active'="" s PLIST(10)=active
		 
		
		i computeType'="" s PLIST(14)=computeType
		i upschem'="" s PLIST(15)=upschem
		;s ^TMPLY(1)=PLIST(15)_"^"_upschem
		i schemFlag'="" s PLIST(16)=schemFlag
		i (KPIDr'="")||(upschem'="") s level=2
		i level'="" s PLIST(12)=level
		&sql(INSERT INTO dhc_pa_data.Schem VALUES PLIST())
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2010-07-12
/// Description: 更新记录
/// Table: dhc.pa.data.Schem
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uSchem).UpdateRec("1||4","L-001^科研综合考评表1^2^Q^21")
ClassMethod UpdateRec(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
	
		s code=$p(data,"^",1)
		s name=$p(data,"^",2)
		s appSysDr = $p(data,"^",3)
 		s frequency = $p(data,"^",4)
 		s KPIDr = $p(data,"^",5)
 		s schemFlag=$p(data,"^",6)
 		s isStop=$p(data,"^",7) //是否有效
 		s computeType=$p(data,"^",8) //处理方式
 		s upschem=$p(data,"^",9) //上级方案
 		s curreStratagemDr = $p(rowid,"||",1)
 		s childsub = $p(rowid,"||",2)
		
		
		s shortcut=code_"-"_name
		
		s id=0
		s id=..IfRepCode(curreStratagemDr,code)
		q:(id'=0)&(id'=childsub) "RepCode"
		s id=..IfRepName(curreStratagemDr,name)
		q:(id'=0)&(id'=childsub) "RepName"
	

		i curreStratagemDr'="" s PLIST(0)=curreStratagemDr
		i code'="" s PLIST(3)=code
		i name'="" s PLIST(4)=name
		i shortcut'="" s PLIST(5)=shortcut
		i appSysDr'="" s PLIST(6)=appSysDr
		i frequency'="" s PLIST(7)=frequency
		;i KPIDr'=""
		 s PLIST(8)=KPIDr
		i isStop'="" s PLIST(10)=isStop
		i computeType'="" s PLIST(14)=computeType
		 s PLIST(15)=upschem	
        i schemFlag'="" s PLIST(16)=schemFlag
		&SQL(UPDATE dhc_pa_data.Schem VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2010-07-27
/// Description: 删除记录
/// Table: dhc.pa.data.Schem
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.pa.udata.uSchem).DelRec("1||2||2")
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_pa_data.Schem WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator：刘洋
/// CreatDate：2011-12-12
/// Description: 获取方案名称
/// Table：dhc.pa.data.Schem
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uSchem).GetSchemName("1||9,1||6")
ClassMethod GetSchemName(Id) As %String
{
	n (Id)
	
	s len=$l(Id,",")
	s IdStr=""
	s i=0
	f  s i=i+1 q:i>len  d
	.i IdStr="" s IdStr="'"_$p(Id,",",i)_"'"
	.e  s IdStr=IdStr_",'"_$p(Id,",",i)_"'"

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select *  from  dhc_pa_data.Schem"
	s whereStr=""
	i Id '="" s whereStr=" where  Schem_rowid in ("_IdStr_")" 
	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
    s nameStr=""
	While(result.Next()){
	    
		s name = result.Data("Schem_name")
		i nameStr="" s nameStr=name
		e  s nameStr=nameStr_" , "_name
	}
	d result.Close()

	q nameStr
}

/// Creator：刘洋
/// CreatDate：2012-1-10
/// Description: 获取方案名称
/// Table：dhc.pa.data.Schem
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uSchem).GetResultKpi("2,3,4")
ClassMethod GetResultKpi(KpiDr) As %String
{
	n (KpiDr)
	i KpiDr'=""  s Len=$L(KpiDr,",")
	
	s KPIName=""
	f k=1:1:Len
	{
		i KpiDr'="" d
		.s KPIdr=$p(KpiDr,",",k)
		.i KPIdr'="" d
		..s KPIName1 = $p($g(^DHCCJXPAKPIINDEX1(KPIdr)),"^",2)
		..i KPIName="" d
		...s KPIName=KPIName1
		..e  d
		...s KPIName=KPIName_","_KPIName1	
	}

	q KPIName
}

/// Creator：wang ying
/// CreatDate：2014-8-22
/// Description: 复制去年方案
/// Table：dhc.pa.data.Schem,dhc.pa.data.SchemDetail
/// Input：CycleDr:要负责到的年份Id
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uSchem).copy(2,3)
ClassMethod copy(perCyleDr, CycleDr) As %String
{
	n (perCyleDr,CycleDr)
	q:CycleDr="" "NoCycleDr"
	q:perCyleDr="" "NoperCyleDr"
	s flag=0
	
	s stragem=..deteleStratagem(CycleDr)
	s currStragem=..getStratagem(perCyleDr)
	q:currStragem=0 "NocurrStragem"
	s newStragem=..getInsertStragemId(currStragem,CycleDr)
	q:newStragem="InsertStragemError"  s flag="InsertStragemError"
	q:newStragem=0  s flag="InsertStragemFlase"
	s flag=..deteleSchem(stragem)
	s flag=..copySchem(currStragem,newStragem, CycleDr)
	
	q flag
}

/// Creator：wang ying
/// CreatDate：2014-8-22
/// Description: 获得插入后的战略ID
/// Table：dhc.pa.data.Stratagem
/// Input：
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uSchem).getInsertStragemId("1",3)
ClassMethod getInsertStragemId(currStragem, CycleDr) As %String
{
	
	n (currStragem,CycleDr)
	q:currStragem="" "NocurrStragem"
	q:CycleDr="" "NoCycleDr"
	
	s CycleCode=""
	s SQLCODE=0
	s SQLCODE = ##class(dhc.pa.udata.uStratagem).UpdateStragem() //设置所有战略为非当前战略
	q:SQLCODE'=0
	
	
	i $d(^DHCCJXPACYCLE(CycleDr)) d
	.s CycleCode=$p($g(^DHCCJXPACYCLE(CycleDr)),"^",1)
	
	s stragem=0
	s stragem=..getStratagem(CycleDr)
	q:stragem=0 0
	s UnitDr=$p(stragem,"^",1)
	s State="new"
	s MonthDr=1
	s Desc=""
	s CurrStratagem="Y"
	s Code=CycleCode
	s Name=CycleCode_"年战略目标"
	s isVFlag="N" //虚拟标志
	s NurFlag="N" //护理标示
	s MedFlag="N" //医疗标示
	s PostFlag="N" //岗位标示
	s LinkFile="" //说明文件路径
	
	s rowid=0	
	s ShortCut=Code_"-"_Name //快捷键
	
	&SQL(Insert Into dhc_pa_data.Stratagem(Stratagem_unitDr,Stratagem_cycleDr,Stratagem_code,Stratagem_name,Stratagem_shortcut,Stratagem_isVFlag,Stratagem_stateFlag,Stratagem_month,Stratagem_desc,Stratagem_linkFile,Stratagem_nurFlag,Stratagem_medFlag,Stratagem_postFlag,Stratagem_currStratagem) VAlUES(:UnitDr,:CycleDr,:Code,:Name,:ShortCut,:isVFlag,:State,:MonthDr,:Desc,:LinkFile,:NurFlag,:MedFlag,:PostFlag,:CurrStratagem))
	i SQLCODE=0 s rowid=%ROWID
	i SQLCODE'=0 s rowid="InsertStragemError"
	
	q rowid
}

/// Creator：wang ying
/// CreatDate：2014-8-25
/// Description: 插入Schem方案表数据并获得其id
/// Table：dhc.pa.data.Schem
/// Input：
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uSchem).copySchem(1,3,3)
ClassMethod copySchem(currStragemOld, currStragemNew, CycleDr) As %String
{
	
	n (currStragemOld,currStragemNew,CycleDr)
	q:currStragemOld="" "NocurrStragemOld"
	q:currStragemNew="" "NocurrStragemNew"
	q:CycleDr="" "NoCycleDr"
	
	s CycleCode=""
	s flag=0
	i $d(^DHCCJXPACYCLE(CycleDr)) d
	.s CycleCode=$p($g(^DHCCJXPACYCLE(CycleDr)),"^",1)
	s schem=0
	q:'$d(^DHCCJXPASTRATAGEM(currStragemOld,"Schem"))  s flag="NoSchem"
	f  s schem=$o(^DHCCJXPASTRATAGEM(currStragemOld,"Schem",schem)) q:schem=""  d
	.s schemStr=$g(^DHCCJXPASTRATAGEM(currStragemOld,"Schem",schem))
	.q:schemStr=""  s flag="NoSchem"
	.s schemCode=CycleCode_$p(schemStr,"^",1)
	.s schemName=$p(schemStr,"^",2)
	.s schemShort=schemCode_schemName //$p(schemStr,"^",3)
	.s schemApp=$p(schemStr,"^",4)
	.s schemPeriodType=$p(schemStr,"^",5)
	.s SchemActive="Y"
	.s schemLevel=$p(schemStr,"^",9)
	.s schemKPIDr=$p(schemStr,"^",6)
	.s schemComputeType=$p(schemStr,"^",10)
	.s schemUpSchemDr=$p(schemStr,"^",11)
	.s schemflag=$p(schemStr,"^",12)
	.&sql(insert Into dhc_pa_data.Schem(Schem_parRef,Schem_code,Schem_name,Schem_shortcut,Schem_appSysDr,Schem_frequency,Schem_KPIDr,Schem_active,Schem_level,Schem_ComputeType, Schem_UpSchemDr, Schem_flag )VAlUES(:currStragemNew,:schemCode,:schemName,:schemShort,:schemApp,:schemPeriodType,:schemKPIDr,:SchemActive,:schemLevel,:schemComputeType,:schemUpSchemDr,:schemflag))
	.i SQLCODE=0 s schemRowid=%ROWID
	.q:SQLCODE'=0  s flag="insertSchemError"
	.s schemDetail=0
	.q:'$d(^DHCCJXPASTRATAGEM(currStragemOld,"SchemDetail",schem))  s flag="NoSchemDetail"
	.f  s schemDetail=$o(^DHCCJXPASTRATAGEM(currStragemOld,"SchemDetail",schem,schemDetail)) q:schemDetail=""  d
	..s detailStr=$g(^DHCCJXPASTRATAGEM(currStragemOld,"SchemDetail",schem,schemDetail))
	..q:detailStr=""
	..s detailOrder=$p(detailStr,"^",1)
	..s KPIDr=$p(detailStr,"^",2)
	..s target=$p(detailStr,"^",3)
	..s rate=$p(detailStr,"^",4)
	..s parent=$p(detailStr,"^",5)
	..&sql(insert Into dhc_pa_data.SchemDetail(SchemDetail_parRef,SchemDetail_order,SchemDetail_KPIDr,SchemDetail_isTarget,SchemDetail_rate,SchemDetail_parent)VAlUES(:schemRowid,:detailOrder,:KPIDr,:target,:rate,:parent))
	..i SQLCODE=0 s detailRowid=%ROWID 
	..q:SQLCODE'=0  s flag="insertSchemDetailError"
	..s detailAdd=0
	..q:'$d(^DHCCJXPASTRATAGEM(currStragemOld,"SchemDetailAdd",schem,schemDetail))
	..f  s detailAdd=$o(^DHCCJXPASTRATAGEM(currStragemOld,"SchemDetailAdd",schem,schemDetail,detailAdd)) q:detailAdd=""  d
	...s detailAddStr=$g(^DHCCJXPASTRATAGEM(currStragemOld,"SchemDetailAdd",schem,schemDetail,detailAdd))
	...q:detailAddStr=""
	...s Addflag=$p(detailAddStr,"^",1)
	...s changeValue=$p(detailAddStr,"^",2)
	...s changeScore=$p(detailAddStr,"^",3)
	...s flag=..deteleSchemDetailAdd(detailRowid)
	...i flag=100 s flag=0
	...&sql(insert into dhc_pa_data.SchemDetailAdd(SchemDetailAdd_parRef,SchemDetailAdd_flag,SchemDetailAdd_changeValue,SchemDetailAdd_score)VALUES(:detailRowid,:Addflag,:changeValue,:changeScore))
	...i SQLCODE'=0 s flag="insertAddError"
	..s detailDist=0
	..f  s detailDist=$o(^DHCCJXPASTRATAGEM(currStragemOld,"SchemDetailDist",schem,schemDetail,detailDist)) q:detailDist=""  d
	...s detailDistStr=$g(^DHCCJXPASTRATAGEM(currStragemOld,"SchemDetailDist",schem,schemDetail,detailDist))
	...q:detailDistStr=""
	...s distOrder=$p(detailDistStr,"^",1)
	...s distValueLower=$p(detailDistStr,"^",2)
	...s distValueUp=$p(detailDistStr,"^",3)
	...s distScoreLower=$p(detailDistStr,"^",4)
	...s distScoreUp=$p(detailDistStr,"^",5)
	...s distRangDr=$p(detailDistStr,"^",6)
	...s flag=..deteleSchemDetailDist(detailRowid)
	...i flag=100 s flag=0
	...&sql(insert into dhc_pa_data.SchemDetailDist(SchemDetailDist_parRef,SchemDetailDist_order,SchemDetailDist_valueLower,SchemDetailDist_valueUp,SchemDetailDist_scoreLower,SchemDetailDist_scoreUp,SchemDetailDist_rangeDr )values(:detailRowid,:distOrder,:distValueLower,:distValueUp,:distScoreLower,:distScoreUp,:distRangDr))
	...i SQLCODE'=0 s flag="insertDistError"
	
	q flag
}

/// Creator：wang ying
/// CreatDate：2014-8-27
/// Description: 根据年份删除战略
/// Table：dhc.pa.data.Stratagem
/// Input：
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uSchem).deteleStratagem(3)
ClassMethod deteleStratagem(CycleDr) As %String
{
	n (CycleDr)
	s stratagem=0
	s stratagem=$o(^DHCCJXPASTRATAGEM(0,"Cycle",CycleDr,stratagem))
	q:(stratagem="")||(stratagem=0) 0
	&SQL(DELETE FROM dhc_pa_data.Stratagem WHERE %ID=:stratagem)
	i SQLCODE'=0  s stratagem=0
	q stratagem
}

/// Creator：wang ying
/// CreatDate：2014-8-26
/// Description: 根据战略删除战略
/// Table：dhc.pa.data.Stratagem
/// Input：
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uSchem).deteleSchem(3)
ClassMethod deteleSchem(currStragem) As %String
{
	n (currStragem)
	&SQL(DELETE FROM dhc_pa_data.Schem WHERE Schem_parRef=:currStragem)
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2014-8-26
/// Description: 根据方案删除方案明显
/// Table：dhc.pa.data.SchemDetail 
/// Input：
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uSchem).deteleSchem(3)
ClassMethod deteleSchemDetail(schemDr) As %String
{
	n (schemDr)
	&SQL(DELETE FROM dhc_pa_data.SchemDetail WHERE SchemDetail_parRef=:schemDr)
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2014-8-26
/// Description: 根据方案明显删除加扣分表
/// Table：dhc.pa.data.SchemDetailAdd
/// Input：
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uSchem).deteleSchem(3)
ClassMethod deteleSchemDetailAdd(schemDetail) As %String
{
	n (schemDetail)
	&SQL(DELETE FROM dhc_pa_data.SchemDetailAdd WHERE SchemDetailAdd_parRef=:schemDr)
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2014-8-26
/// Description: 根据方案明显删除加扣分表
/// Table：dhc.pa.data.SchemDetailAdd
/// Input：
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uSchem).deteleSchemDetailDist("1||1||1")
ClassMethod deteleSchemDetailDist(schemDetail) As %String
{
	n (schemDetail)
	&SQL(DELETE FROM dhc_pa_data.SchemDetailDist WHERE SchemDetailDist_parRef=:schemDetail)
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2014-8-28
/// Description: 根据年度确认战略id
/// Table：dhc.pa.data.SchemDetailAdd
/// Input：
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uSchem).getStratagem(1)
ClassMethod getStratagem(CycleDr) As %String
{
	n (CycleDr)
	
	s stragem=0
	s stragem=$o(^DHCCJXPASTRATAGEM(0,"Cycle",CycleDr,stragem))
	
	q stragem
}

/// Creator: chuyali
/// CreatDate: 2016-08-02
/// Description:绩效方案启用、停用
/// Table: dhc.pa.data.Schem
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.pa.udata.uSchem).StopSchem("1||2||2","stop")
ClassMethod StopSchem(rowid, flag) As %String
{
	n (rowid,flag)
	if flag="stop"  d   //stop为停用
	.&SQL(UPDATE dhc_pa_data.Schem SET Schem_active = 'N' WHERE %ID=:rowid)
	e  d
	.&SQL(UPDATE dhc_pa_data.Schem SET Schem_active = 'Y' WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uSchemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
