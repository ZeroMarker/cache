Class dhc.hr.PS.PersonManage Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: chinaway
/// CreatDate: 2016-08-16
/// Description: 胸卡号是否存在
/// Table: PersonInfo
/// Input: empcard-胸卡号；rev-返回值
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.hr.PS.PersonManage).IsExistEmpCard("0001")
ClassMethod IsExistEmpCard(empcard, Output rev) As %String [ SqlProc ]
{
	n (empcard,rev)
	s rev=0
	s rev=$o(^HISHR.PersonInfoI("EmpCardIDIdx"," "_empcard,rev))
	i rev="" d  s rev=0
	q rev
}

/// Creator: chinaway
/// CreatDate: 2015-09-02
/// Description: 生成PSENid
/// Table：  PersonInfo
/// Input:  
/// Return: 返回新的PSENid
/// Others: w ##class(dhc.hr.PS.PersonManage).CreatePSENid()
ClassMethod CreatePSENid(Output returnValue As %String) As %String [ SqlProc ]
{
 	s returnValue=""
	
	lock ^HISHR.SysiniInfoD(1151)

	&SQL(SELECT CONTEXT INTO :pseni FROM HISHR.SysiniInfo WHERE Flag='PersonInfo')
	i SQLCODE=0 d
 	.s temp=$E(pseni,3,9)
	.s num=temp+1
	.s length=9-$L(num)
	.s returnValue=$E("PS0000000",1,length)_num
	.&SQL(UPDATE HISHR.SysiniInfo SET CONTEXT=:returnValue WHERE Flag='PersonInfo')
	
	lock -^HISHR.SysiniInfoD(1151)
 	
 	q returnValue
}

/// w ##class(dhc.hr.PS.PersonManage).CreateUserENid()
ClassMethod CreateUserENid(Output returnValue As %String) As %String [ SqlProc ]
{
 	s returnValue=""
	
	lock ^HISHR.SysiniInfoD(1058)

	&SQL(SELECT CONTEXT INTO :psend FROM HISHR.SysiniInfo WHERE Flag='UserInfo')
	i SQLCODE=0 d
 	.s temp=$E(psend,3,8)
	.s num=temp+1
	.s length=8-$L(num)
	.s returnValue=$E("UI000000",1,length)_num
	.&SQL(UPDATE HISHR.SysiniInfo SET CONTEXT=:returnValue WHERE Flag='UserInfo')
	
	lock -^HISHR.SysiniInfoD(1058)
 	
 	q returnValue
}

/// 审核个人选中的几条信息
/// w ##class(dhc.hr.PS.PersonManage).CheckPSBase("1","('0','34','')","PS0000001","PS0000001")
ClassMethod CheckPSBase(status As %String, ids As %String, opr As %String, psenid As %String, oprdt As %String) As %String [ SqlProc ]
{
	//更新审核状态
	;s nowdt=$zd($p($h,",",1),3) ;当前日期
	;s nowdt=$p($h,",",1)
	s sqlupstatus="update hishr.PSBaseCollectInfo set status='"_status_"',CheckDate='"_oprdt_"',Operator='"_opr_"' where id in "_ids
	s upstatus=##class(%Library.ResultSet).%New()
	d upstatus.Prepare(sqlupstatus)
	d upstatus.Execute()
    d upstatus.Close() 
    i status="1"
    {
	s sqlBase1="select FieldCode,AfterName,BeforCode,AfterCode,EmpCardID from Hishr.PSBaseCollectInfo where id in "_ids
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlBase1)
	d result.Execute()
	while(result.Next())
	{
		
		s code=result.Data("AfterCode")
		//s ^lb(8)=result.Data("BeforCode")//临时global
		s name=result.Data("AfterName")
		s field=result.Data("FieldCode")
		s emp=result.Data("EmpCardID")
		s fvalue=code
		i code=""
		{
		  s fvalue=name			
	    }
	    s sqlup="update hishr.personinfo set "_field_"='"_fvalue_"' where PSENid='"_psenid_"'"
	    s upre=##class(%Library.ResultSet).%New()
	    d upre.Prepare(sqlup)
	    d upre.Execute()
	    d upre.Close()
	}
	d result.Close()
    }
	q "1"
}

/// 审核个人所有改动的信息
/// w ##class(dhc.hr.PS.PersonManage).CheckAllPS("","PS0000001","PS0000001","2016-01-01")
ClassMethod CheckAllPS(emp As %String, opr As %String, psenid As %String, oprdt As %String) As %String [ SqlProc ]
{
	;s nowdt=$p($h,",",1) ;当前日期
	s pslength=$l(psenid,",")
	s psenids="" ;psenid的集合 格式为  'ps001','ps002'
	; 将psenid的集合拼成串
	i pslength>1 d
    .s psenids=psenid
	e  d
	.s psenids="'"_psenid_"'"

	s sqlBase2="select FieldCode,AfterName,AfterCode,EmpCardID,PSENid from Hishr.PSBaseCollectInfo where status='0' and PSENid in ("_psenids_")"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlBase2)
	d result.Execute()
	
	while(result.Next())
	{
		
		s code=result.Data("AfterCode")
		s name=result.Data("AfterName")
		s field=result.Data("FieldCode")
		s psid=result.Data("PSENid")
		s fvalue=code
		i code=""
		{
		  s fvalue=name			
	    }
	    s sqlup="update hishr.personinfo set "_field_"='"_fvalue_"' where PSENid='"_psid_"'"
	    s upre=##class(%Library.ResultSet).%New()
	    d upre.Prepare(sqlup)
	    d upre.Execute()
	    d upre.Close()
	    
	}
	d result.Close()
	//更新审核状态
	s sqlupstatus="update hishr.PSBaseCollectInfo set status='1',CheckDate='"_oprdt_"',Operator='"_opr_"' where status='0' and PSENid in ("_psenids_")"
	s upstatus=##class(%Library.ResultSet).%New()
	d upstatus.Prepare(sqlupstatus)
	d upstatus.Execute()
    d upstatus.Close()
    
	q "1"
}

/// 审核所有人的信息
/// w ##class(dhc.hr.PS.PersonManage).CheckALL("","PS0000001","more","'0','PS0000001'","2001-1-1")
ClassMethod CheckALL(ids, opr, ty, psenid, oprdt) As %String [ SqlProc ]
{
	n (ids,opr,oprdt,psenid,ty)
	;s nowdt=$p($h,",",1) ;当前日期
	i ty="more"
	 {
		 s rev=..CheckAllPS("",opr,psenid,oprdt)
	 }
	else
	{
	s sqlBase3="select FieldCode,AfterName,AfterCode,EmpCardID,PSENid from Hishr.PSBaseCollectInfo where status='0'"
	s result=##class(%Library.ResultSet).%New()
	;d result.RuntimeModeSet(1)
	d result.Prepare(sqlBase3)
	d result.Execute()
	s upre=##class(%Library.ResultSet).%New()
	while(result.Next())
	{		
		s code=result.Data("AfterCode")
		s name=result.Data("AfterName")
		s field=result.Data("FieldCode")
		s emp=result.Data("EmpCardID")
		s psid=result.Data("PSENid")
		s fvalue=code
		i code=""
		{
		  s fvalue=name			
	    }
	    s sqlup="update hishr.personinfo set "_field_"='"_fvalue_"' where PSENid='"_psid_"'"
	    d upre.Prepare(sqlup)
	    d upre.Execute()
	    d upre.Close()
	}
	d result.Close()
	//更新审核状态
	s sqlupstatus="update hishr.PSBaseCollectInfo set status='1',CheckDate='"_oprdt_"',Operator='"_opr_"' where status='0' "
	s upstatus=##class(%Library.ResultSet).%New()
	d upstatus.Prepare(sqlupstatus)
	d upstatus.Execute()
    d upstatus.Close()
	}
	q "1"
}

/// Creator: chinaway
/// CreatDate: 2016-01-29
/// Description: 人员科室调动
/// Table：  PersonInfo
/// Input: 
/// Return: 
/// Others: w ##class(dhc.hr.PS.PersonManage).PSDeptChange("PS0003289","0305","2011-1-1","","PS0000001","yes")
ClassMethod PSDeptChange(psenid, deptcode, date, reason, opr, isanysc, Output reValue As %String) As %String [ SqlProc ]
{
	n (psenid,deptcode,date,reason,opr,reValue,isanysc)
		
 	s reValue="",rowid=""
	s rowid=$o(^HISHR.PersonInfoI("PSENidIdx"," "_psenid,rowid))
	i rowid'="" d
	.s psenid=$LIST(^HISHR.PersonInfoD(rowid),2)
	.s bdeptcode=$LIST(^HISHR.PersonInfoD(rowid),5) ;修改前的科室编码
	.s pty=$LIST(^HISHR.PersonInfoD(rowid),126) ;岗位分类
	.s pname=$LIST(^HISHR.PersonInfoD(rowid),3) ;姓名
	.s emp=$LIST(^HISHR.PersonInfoD(rowid),4) ;工号

	.s field="DeptCode^"_deptcode_",CycleDept^"_deptcode
	.s psitemchange=##class(dhc.hr.PS.PSItemChangeLog).%New()
	.d psitemchange.PSItemToLog(psenid,field,date,reason,opr)
	.&SQL(UPDATE HISHR.PersonInfo SET DeptCode=:deptcode,CycleDept=:deptcode WHERE PSENid=:psenid)
	
	.s reValue=SQLCODE
	
	.i (SQLCODE=0)&&(isanysc="yes") d ;调用奖金接口
	..s ifMG=##class(dhc.hr.Interface.IFMange).%New()
	..d ifMG.BonusAnysc(emp,deptcode,bdeptcode,pty,pname)
		
 	q reValue
}

/// Others: w ##class(dhc.hr.PS.PersonManage).MorePSDeptChange("PS0000606,PS0000630","042428","2016-03-15","科室拆分","A00001")
ClassMethod MorePSDeptChange(psenid, deptcode, date, reason, opr, Output reValue As %String) As %String [ SqlProc ]
{
	n (psenid,deptcode,date,reason,opr,reValue)
	s reValue="",rowid=""
	//s date=$ZDateH(date,3)
	
	if (psenid'="") 
	{
	 s psenidLen=$L(psenid,",")
	 
	 s field="DeptCode^"_deptcode_",CycleDept^"_deptcode
	 s psitemchange=##class(dhc.hr.PS.PSItemChangeLog).%New()
     for m=1:1:psenidLen
 	 {
 	  s PSEN=$P(psenid,",",m)
 	  
	   s qw=psitemchange.PSItemToLog(PSEN,field,date,reason,opr)	  
	   if qw'=""
	    {
	     &SQL(UPDATE HISHR.PersonInfo SET DeptCode=:deptcode,CycleDept=:deptcode WHERE PSENid=:PSEN)
         s reValue=SQLCODE           
	    }
 	 }
	}
	 	
 	q reValue
}

/// Creator: chinaway
/// CreatDate: 2016-01-29
/// Description: 离职
/// Table：  PersonInfo
/// Input: 
/// Return: 
/// Others: w ##class(dhc.hr.PS.PersonManage).PSLeave()
ClassMethod PSLeave(psenid, leavetype, date, reason, opr, Output reValue As %String) As %String [ SqlProc ]
{
	n (psenid,leavetype,date,reason,opr,reValue)
		
 	s reValue="",rowid=""
 	
	s rowid=$o(^HISHR.PersonInfoI("PSENidIdx"," "_psenid,rowid))
	i rowid'="" d
	.s psenid=$LIST(^HISHR.PersonInfoD(rowid),2)
	.s field="PersonStatus^"_leavetype
	.s psitemchange=##class(dhc.hr.PS.PSItemChangeLog).%New()
	.d psitemchange.PSItemToLog(psenid,field,date,reason,opr)
	
	.s psdimiss=##class(HISHR.DimissionInfo).%New()
	.s psdimiss.DimissionTime=$ZDH(date,3)
	.s psdimiss.FlexStrField1=leavetype
	.s psdimiss.PSENid=psenid
	.s psdimiss.DimissionReason=reason
	.s psdimiss.FlexStrField3=opr
	.d psdimiss.%Save()
	.d psdimiss.%Close()
	
	.&SQL(UPDATE HISHR.PersonInfo SET PersonStatus=:leavetype WHERE PSENid=:psenid)
	
	.s reValue=SQLCODE
	 	
 	q reValue
}

/// 根据表名和fieldinfo配置获取personinfo数据信息和对应的值
/// 获取表字段信息：表名，是否显示，是否可编辑PS0000001
/// w ##class(dhc.hr.PS.PersonManage).GetTableFieldAndValue("1","","PS0000001")
ClassMethod GetTableFieldAndValue(ivisble, iedit, psenid, Output rev As %Text) As %String [ SqlProc ]
{
	s rev="{"_$char(34)_"controls"_$char(34)_":["
	s count=1
	s sqlfield="select FFieldCode,FFieldName,FEnumDict,FEnumTitle,FDataType,FSelectStatus,FlexStrField2,FlexStrField12"
	          _" from hishr.fieldinfo where ftablecode='PersonInfo' and FlexStrField7='"_ivisble_"'"
	i (iedit'="")&&(iedit'=$c(0)) d
	.s sqlfield=sqlfield_" and FSelectStatus='"_iedit_"'"
	s resultfield=##Class(%Library.ResultSet).%New()
	d resultfield.Prepare(sqlfield)
	d resultfield.Execute()
	while(resultfield.Next())
	{
		s fname=resultfield.Data("FFieldName") ;字段名称
		s fcode=resultfield.Data("FFieldCode") ;字段编码
		s codetable=resultfield.Data("FEnumDict") ;关联表
		s codewhere=resultfield.Data("FEnumTitle")	;关联条件
		s ftype=resultfield.Data("FDataType") ;字段类型
		s fedit=resultfield.Data("FSelectStatus") ;是否可编辑
		s fvalidation=resultfield.Data("FlexStrField2") ;正则表达式
		s fisedit=resultfield.Data("FlexStrField12") ;是否必填
		s sqldata=""
		i (codetable="")||(codetable=$c(0)) d
	    .s sqldata="select "_fcode_" from hishr.personinfo where psenid='"_psenid_"'"
		e  d
		.s length=$l(codewhere,"^")
		.s code=$p(codewhere,"^",1) ;编码表code字段
		.s name=$p(codewhere,"^",2) ;编码表对应汉字字段
		.s sqldata="select b."_name_" as "_fcode_" from hishr.personinfo as a left join hishr."_codetable_" as b"
		.i length>2 d
		..s wh=$p(codewhere,"^",3) ;编码表筛选条件
		..s sqldata=sqldata_" on (a."_fcode_"=b."_code_" and b."_wh_") where a.psenid='"_psenid_"'"
		.e  d
		..s sqldata=sqldata_" on (a."_fcode_"=b."_code_") where a.psenid='"_psenid_"'"
		s resultdata=##Class(%Library.ResultSet).%New()
		d resultdata.Prepare(sqldata)
		d resultdata.Execute()
		while(resultdata.Next())
		{
			s psdata=resultdata.Data(fcode)
			i count=1 d
			.s rev=rev_"{"_$char(34)_"name"_$char(34)_":"_$char(34)_fname_$char(34)_","_$char(34)_"code"_$char(34)_":"_$char(34)_fcode_$char(34)_","_$char(34)_"value"_$char(34)_":"_$char(34)_psdata_$char(34)_"}"
		    e  d
		    .s rev=rev_",{"_$char(34)_"name"_$char(34)_":"_$char(34)_fname_$char(34)_","_$char(34)_"code"_$char(34)_":"_$char(34)_fcode_$char(34)_","_$char(34)_"value"_$char(34)_":"_$char(34)_psdata_$char(34)_"}"
		}
		d resultdata.Close()
		s count=count+1
	}
	d resultfield.Close()
	s rev=rev_"]}"
	q rev
}

/// 根据表名和fieldinfo配置获取子表某个人指定状态数据信息
/// 获取表字段信息：表名，筛选字段，筛选字段值
/// w ##class(dhc.hr.PS.PersonManage).GetTableDataByFieldInfo("FieldInfo"," a.ftablecode='PersonInfo'","0","100")
ClassMethod GetTableDataByFieldInfo(tablcode, sqlwhere, start As %Integer, limit As %Integer, Output rev As %Text) As %String [ SqlProc ]
{
	i (start="")||(start=$c(0)) d
	.s start=0
	i (limit="")||(limit=$c(0)) d
	.s limit=10 
	s tablcode=$ZCVT(tablcode,"U")
	s count=1
	s sqlselect="SELECT a.ID"
	s sqlfrom=" FROM hishr."_tablcode_" as a "
	s rid=""
	f  s rid=$O(^HISHR.FieldInfoInfoI("TableVisible"," "_tablcode," 1",rid)) q:rid=""  d
	.s fcode=$List(^HISHR.FieldInfoInfoD(rid),5)
	.s fname=$List(^HISHR.FieldInfoInfoD(rid),6)
	.s codetable=$List(^HISHR.FieldInfoInfoD(rid),17)
	.s codewhere=$List(^HISHR.FieldInfoInfoD(rid),18)
	.i fcode'="ID" d
	..i (codetable="")||(codetable=$c(0)) d
	...s sqlselect=sqlselect_",a."_fcode
	..e  d
	...s length=$l(codewhere,"^")
    ...s code=$p(codewhere,"^",1) ;编码表code字段
	...s name=$p(codewhere,"^",2) ;编码表对应汉字字段
	...s sqlselect=sqlselect_",b"_count_"."_name_" AS "_fcode
	...s sqlfrom=sqlfrom_" left join hishr."_codetable_" as b"_count_" "
	...i length>2 d
	....s sqlfrom=sqlfrom_"on (a."_fcode_"=b"_count_"."_code_" and b"_count_"."_$p(codewhere,"^",3)_") "
	...e  d
	....s sqlfrom=sqlfrom_"on (a."_fcode_"=b"_count_"."_code_") "
	...s count=count+1
	s sql=sqlselect_sqlfrom_sqlwhere
	s rejson=##Class(dhc.hr.comm.Sql2Json).%New()
	s rev=rejson.GetJsonBySql(sql,start,limit)
	q rev
}

/// 2016-09-22马琳
/// 根据表名和fieldinfo配置获取子表某个人指定状态数据信息
/// 获取表字段信息：表名，筛选字段，筛选字段值
/// w ##class(dhc.hr.PS.PersonManage).GetPSTableDataByFieldInfo("PSFamilyInfo","  left join hishr.personinfo as w on a.psenid=w.psenid where a.status='0'","0","100")
ClassMethod GetPSTableDataByFieldInfo(tablcode, sqlwhere As %Text, start As %Integer, limit As %Integer, Output rev As %Text) As %String [ SqlProc ]
{
	i (start="")||(start=$c(0)) d
	.s start=0
	i (limit="")||(limit=$c(0)) d
	.s limit=10 
	s tablcode=$ZCVT(tablcode,"U")
	s count=1
	s sqlselect="SELECT  pspic.PicType, a.ID,a.PSENid AS PSENid1"
	s sqlfrom=" FROM hishr."_tablcode_" as a "
	s rid=""
	f  s rid=$O(^HISHR.FieldInfoInfoI("TableVisible"," "_tablcode," 1",rid)) q:rid=""  d
	.s fcode=$List(^HISHR.FieldInfoInfoD(rid),5)
	.s fname=$List(^HISHR.FieldInfoInfoD(rid),6)
	.s codetable=$List(^HISHR.FieldInfoInfoD(rid),17)
	.s codewhere=$List(^HISHR.FieldInfoInfoD(rid),18)
	.i fcode'="ID" d
	..i (codetable="")||(codetable=$c(0)) d
	...s sqlselect=sqlselect_",a."_fcode
	..e  d
	...s length=$l(codewhere,"^")
    ...s code=$p(codewhere,"^",1) ;编码表code字段
	...s name=$p(codewhere,"^",2) ;编码表对应汉字字段
	...s sqlselect=sqlselect_",b"_count_"."_name_" AS "_fcode
	...s sqlfrom=sqlfrom_" left join hishr."_codetable_" as  b"_count_" "
	...i length>2 d
	....s sqlfrom=sqlfrom_"on (a."_fcode_"=b"_count_"."_code_" and b"_count_"."_$p(codewhere,"^",3)_") "
	...e  d
	....s sqlfrom=sqlfrom_"on (a."_fcode_"=b"_count_"."_code_") "
	...s count=count+1
	s sql=sqlselect_sqlfrom_sqlwhere
	s rejson=##Class(dhc.hr.comm.Sql2Json).%New()
	s rev=rejson.GetJsonBySql(sql,start,limit)
	q rev
}

/// 2016-10-14 
/// ltt
/// 根据表名和fieldinfo配置获取子表某个人指定状态数据信息
/// 获取表字段信息：表名，筛选字段，筛选字段值
/// w ##class(dhc.hr.PS.PersonManage).GetPSTableInfo("PSExperienceInfo"," where a.status='0'","0","10")
ClassMethod GetPSTableInfo(tablcode, sqlwhere As %Text, start As %Integer, limit As %Integer, Output rev As %Text) As %String [ SqlProc ]
{
	i (start="")||(start=$c(0)) d
	.s start=0
	i (limit="")||(limit=$c(0)) d
	.s limit=10 
	s tablcode=$ZCVT(tablcode,"U")
	s count=1
	s sqlselect="SELECT  pspic.PicType, a.ID,a.PSENid AS PSENid1"
	s sqlfrom=" FROM   hishr."_tablcode_" as a  left  join  HISHR.PersonInfo as  b0  on (b0.EmpCardID = a.EmpCardID) "
	s rid=""
	f  s rid=$O(^HISHR.FieldInfoInfoI("TableVisible"," "_tablcode," 1",rid)) q:rid=""  d
	.s fcode=$List(^HISHR.FieldInfoInfoD(rid),5)
	.s fname=$List(^HISHR.FieldInfoInfoD(rid),6)
	.s codetable=$List(^HISHR.FieldInfoInfoD(rid),17)
	.s codewhere=$List(^HISHR.FieldInfoInfoD(rid),18)
	.i fcode'="ID" d
	..i (codetable="")||(codetable=$c(0)) d
	...s sqlselect=sqlselect_",a."_fcode
	..e  d
	...s length=$l(codewhere,"^")
    ...s code=$p(codewhere,"^",1) ;编码表code字段
	...s name=$p(codewhere,"^",2) ;编码表对应汉字字段
	...s sqlselect=sqlselect_",b"_count_"."_name_"  AS "_fcode
	...s sqlfrom=sqlfrom_"  left  join hishr."_codetable_" as b"_count_" "
	...i length>2 d
	....s sqlfrom=sqlfrom_"on (a."_fcode_"=b"_count_"."_code_" and b"_count_"."_$p(codewhere,"^",3)_") "
	...e  d
	....s sqlfrom=sqlfrom_"on (a."_fcode_"=b"_count_"."_code_") "
	...s count=count+1
	s sql=sqlselect_sqlfrom_sqlwhere
	s rejson=##Class(dhc.hr.comm.Sql2Json).%New()
	s rev=rejson.GetJsonBySql(sql,start,limit)
	q rev
}

/// 获取头像
/// w ##class(dhc.hr.PS.PersonManage).GetPSPic("PS0000001","1","PersonInfo")
ClassMethod GetPSPic(psenid, imgty, tbname, Output reurl As %Text) As %String [ SqlProc ]
{
	s rev=""
	s psrowid=""
	&SQL(SELECT ID INTO :psrowid FROM hishr.personinfo WHERE psenid=:psenid)
    s url="../UPImg/"_tbname_"/"_tbname_"-"_psenid_"-"_psrowid_"-"_imgty
    s sqlurl="SELECT PicUrl,PicName FROM hishr.PSPictureInfo where PicUrl like '"_url_"%'"
    s result=##Class(%Library.ResultSet).%New()
    d result.Prepare(sqlurl)
    d result.Execute()
    while(result.Next())
    {
	   s rev=result.Data("PicUrl") 
	}
	d result.Close()
	s reurl="{"_$char(34)_"url"_$char(34)_":"_$char(34)_rev_$char(34)_"}"
	q reurl
}

/// 获取ps子表信息未审核数据
ClassMethod GetChildDataNoRepeat(start As %Integer, limit As %Integer, Output rev As %Text) As %String [ SqlProc ]
{
   s sql1="select a.name,b.deptname,a.psenid,a.empcardid from hishr.personinfo as a left join hishr.deptinfo as b on a.deptcode=b.deptcode left join hishr.PSFamilyInfo as c on a.psenid=c.psenid where c.status='0'"
               _" union select a.name,b.deptname,a.psenid,a.empcardid from hishr.personinfo as a left join hishr.deptinfo as b on a.deptcode=b.deptcode left join hishr.PSExperienceInfo as c on a.psenid=c.psenid where c.status='0'"
               _" union select a.name,b.deptname,a.psenid,a.empcardid from hishr.personinfo as a left join hishr.deptinfo as b on a.deptcode=b.deptcode left join hishr.PSEducateInfo as c on a.psenid=c.psenid where c.status='0'"
               _" union select a.name,b.deptname,a.psenid,a.empcardid from hishr.personinfo as a left join hishr.deptinfo as b on a.deptcode=b.deptcode left join hishr.PSPostionInfo as c on a.psenid=c.psenid where c.status='0'"
               _" union select a.name,b.deptname,a.psenid,a.empcardid from hishr.personinfo as a left join hishr.deptinfo as b on a.deptcode=b.deptcode left join hishr.PSOccupationInfo as c on a.psenid=c.psenid where c.status='0'"
    s result=##Class(%Library.ResultSet).%New()
    d result.Prepare(sqlurl)
    d result.Execute()
    d result.Close()
}

/// Creator: chinaway
/// CreatDate: 2016-08-16
/// Description: 生成EmpCardID
/// Table：  PersonInfo,SysiniInfo
/// Input:  
/// Return: 返回新的EmpCardID
/// Others: w ##class(dhc.hr.PS.PersonManage).CreatePSEmp()
ClassMethod CreatePSEmp(Output returnValue As %String) As %String [ SqlProc ]
{
 	s returnValue=""
 	 	
	&SQL(SELECT ID,CONTEXT INTO :idcode,:psemp FROM HISHR.SysiniInfo WHERE Flag='AutoEmp')	
	if (SQLCODE=0) 
	{			
		s i=1
		d  Lock ^HISHR.SysiniInfoD(idcode)
		while(1)
		{
	    	s newnum=""
	    	s num=psemp+i
        	s length=4-$L(num)
        	s newnum=$E("0000",1,length)_num
	    	s bs=..IsExistEmpCard(newnum)
	    	if (bs="0")
	    	{ 
	    		d  Lock -^HISHR.SysiniInfoD(idcode)
	    		&SQL(UPDATE HISHR.SysiniInfo SET CONTEXT=:newnum WHERE ID=:idcode)
	    		s returnValue=newnum
	    		q 
	    	}else
	    	{
		    	s i=i+1
		    }
		}
	}
 	q returnValue
}

/// Creator: chinaway
/// CreatDate: 2016-05-05
/// Description: 退休
/// Table：  PersonInfo
/// Input: 	date-退休日期；report-呈报意见；dateapp-审批日期；approve-审批意见
/// Return: 
/// Others: w ##class(dhc.hr.PS.PersonManage).PSRetire()
ClassMethod PSRetire(psenid, date, report, dateapp, approve, reason, opr, Output reValue As %String) As %String [ SqlProc ]
{
	n (psenid,date,report,dateapp,approve,reason,opr,reValue)
		
 	s reValue="",rowid=""
 	
	s rowid=$o(^HISHR.PersonInfoI("PSENidIdx"," "_psenid,rowid))
	i rowid'="" d
	.s psenid=$LIST(^HISHR.PersonInfoD(rowid),2)
	.s field="PersonStatus^05"
	.s psitemchange=##class(dhc.hr.PS.PSItemChangeLog).%New()
	.d psitemchange.PSItemToLog(psenid,field,date,reason,opr)
	
	.s psretire=##class(HISHR.PSRetireInfo).%New()
	.s psretire.AllowOrgIdea=approve
	.s psretire.ApplyOrgIdea=report
	.s psretire.PSENid=psenid
	.s psretire.Remark=reason
	.s psretire.RetireFlag="05"
	.s psretire.RetireTime=$zdh(date,3)
	.s psretire.Oprman=opr
	.d psretire.%Save()
	.d psretire.%Close()
	
	
	.&SQL(UPDATE HISHR.PersonInfo SET PersonStatus='05' WHERE PSENid=:psenid)
	
	.s reValue=SQLCODE
	 	
 	q reValue
}

/// Creator: chinaway
/// CreatDate: 2016-05-05
/// Description: 死亡
/// Table：  PersonInfo
/// Input: 	date-死亡日期；
/// Return: 
/// Others: w ##class(dhc.hr.PS.PersonManage).PSDeath()
ClassMethod PSDeath(psenid, date, type, reason, opr, Output reValue As %String) As %String [ SqlProc ]
{
	n (psenid,date,type,reason,opr,reValue)
		
 	s reValue="",rowid=""
 	
	s rowid=$o(^HISHR.PersonInfoI("PSENidIdx"," "_psenid,rowid))
	i rowid'="" d
	.s psenid=$LIST(^HISHR.PersonInfoD(rowid),2)
	.s field="PersonStatus^07"
	.s psitemchange=##class(dhc.hr.PS.PSItemChangeLog).%New()
	.d psitemchange.PSItemToLog(psenid,field,date,reason,opr)
	
	.s psdeath=##class(HISHR.PSDeathInfo).%New()
	.s psdeath.DeathReason=reason
	.s psdeath.DeathTime=$zdh(date,3)
	.s psdeath.DeathType=type
	.s psdeath.PSENid=psenid
	.d psdeath.%Save()
	.d psdeath.%Close()
	
	
	.&SQL(UPDATE HISHR.PersonInfo SET PersonStatus='07' WHERE PSENid=:psenid)
	.&SQL(UPDATE HISHR.UserInfo SET Deleted='1' WHERE PSENid=:psenid)
	.s reValue=SQLCODE
	 	
 	q reValue
}

/// Creator: zhangsiwen
/// CreatDate: 2016-09-29
/// Description: 审核不通过
/// Table： tablecode
/// Return: 返回空-返聘失败；返回1-已经返聘不能重复返聘；大于1-成功
/// Others: w ##class(dhc.hr.PS.PersonManage)RefuseCheck()
ClassMethod RefuseCheck(tablecode, rowid, remark, Output reValue As %String) As %String [ SqlProc ]
{
    
    
    q "1"
}

/// Creator: chinaway
/// CreatDate: 2016-08-24
/// Description: 返聘
/// Table：  PersonInfo；PSRetireInfo
/// Return: 返回空-返聘失败；返回1-已经返聘不能重复返聘；大于1-成功
/// Others: w ##class(dhc.hr.PS.PersonManage).PSRehired()
ClassMethod PSRehired(psenid, opr, DeptCode, Output reValue As %String) As %String [ SqlProc ]
{
	n (psenid,opr,DeptCode,reValue)
		
 	s reValue="",rowid=""
 	
	s rowid=$o(^HISHR.PersonInfoI("PSENidIdx"," "_psenid,rowid))
	i rowid'="" d
	.s status=$LIST(^HISHR.PersonInfoD(rowid),43)
	.i status'="0102" d
	..&SQL(UPDATE HISHR.PSRetireInfo SET RetireFlag='0102' WHERE PSENid=:psenid)
	..i SQLCODE="0" d
	...s field="PersonStatus^0102"
	...s date=$ZD($H,3)
	...s reason="执行返聘"
	...s psitemchange=##class(dhc.hr.PS.PSItemChangeLog).%New()
	...s Dept=psitemchange.GetValueByField("DeptCode",rowid)
	...i DeptCode'=Dept d
	....s field=field_",DeptCode^"_DeptCode
	...s reValue=psitemchange.PSItemToLog(psenid,field,date,reason,opr)
	...&SQL(UPDATE HISHR.PersonInfo SET PersonStatus='0102',DeptCode=:DeptCode WHERE ID=:rowid)
	.e  d
	..s reValue="1"
	
	 	
 	q reValue
}

/// Creator: chinaway
/// CreatDate: 2016-09-22
/// Description: 复职
/// Table：  PersonInfo；DimissionInfo(...s field="PersonStatus^01")
/// Return: 返回空-复职失败；返回1-已经复职不能重复复职；大于1-成功
/// Others: w ##class(dhc.hr.PS.PersonManage).PSReinstated("PS0002187","PS0000001","0101","0201")
ClassMethod PSReinstated(psenid, opr, DeptCode, type, Output reValue As %String) As %String [ SqlProc ]
{
	n (psenid,opr,DeptCode,type,reValue)
		
 	s reValue="",rowid=""
	s rowid=$o(^HISHR.PersonInfoI("PSENidIdx"," "_psenid,rowid))
	i rowid'="" d
	.s status=$LIST(^HISHR.PersonInfoD(rowid),43)
	.i status'="01" d
	..&SQL(UPDATE HISHR.DimissionInfo SET FlexStrField2='0101' WHERE PSENid=:psenid)
	..i SQLCODE="0" d
	...s field="PersonStatus^01"
	...s date=$ZD($H,3)
	...s reason="执行复职"
	...s psitemchange=##class(dhc.hr.PS.PSItemChangeLog).%New()
	...s Dept=psitemchange.GetValueByField("DeptCode",psenid)
	...i DeptCode'=Dept d
	....s field=field_",DeptCode^"_DeptCode
	...s reValue=psitemchange.PSItemToLog(psenid,field,date,reason,opr)
	...&SQL(UPDATE HISHR.PersonInfo SET PersonStatus='01',DeptCode=:DeptCode WHERE ID=:rowid)
	.e  d
	..s reValue="1"
	
	 	
 	q reValue
}

/// 职称调整
/// w ##class(dhc.hr.PS.PersonManage).PSSkillChange("PS0000001,PS0003232","1","2016-05-09","sa","PS0000001")
ClassMethod PSSkillChange(psenid, SkillStatusLevel, date, reason, opr, Output reValue As %String) As %String [ SqlProc ]
{
	n (psenid,SkillStatusLevel,date,reason,opr,reValue)
	s reValue="",rowid=""
	s nullValue=""
	s dates=$ZDateH(date,3)
	if (psenid'="") 
	{
	 s psenidLen=$L(psenid,",")
	 s field="SkillStatusLevel^"_SkillStatusLevel
	 s psitemchange=##class(dhc.hr.PS.PSItemChangeLog).%New()
     for m=1:1:psenidLen
 	 {
 	  s PSEN=$P(psenid,",",m)
	   s qw=psitemchange.PSItemToLog(PSEN,field,date,reason,opr)
	   if qw'=""
	    {
	     &SQL(UPDATE HISHR.PersonInfo SET SkillStatusLevel=:SkillStatusLevel,QualifiedTime=:dates,UpDataCode=:nullValue,UpDataName=:nullValue WHERE PSENid=:PSEN)
         if (SQLCODE=0) 
          {
	       s reValue=SQLCODE   
          }
	    }
 	 }
	}
	 	
 	q reValue
}

/// excel导入数据
/// 输出结果1成功2工号重复，3添加用户失败，4添加人员失败,5科室或者用工形式获取编码失败,6添加到默认角色失败
/// w ##class(dhc.hr.PS.PersonManage).CreatePSByExcel("","ceshi1","儿科","正式工","2016-01-01","2016-01-01","0001","")
ClassMethod CreatePSByExcel(emp, name, deptname, pstype, startworkday, hiretime, opr, Output reValue As %String) As %String [ SqlProc ]
{
	n (emp, name, deptname, pstype,startworkday,hiretime,opr,reValue)
	s reValue="1"
	s startworkday=$zdh(startworkday,3)
	s hiretime=$zdh(hiretime,3)
	
	///出入工号为空的情况
	i (emp="")||((emp=$c(0))) d
	.s emp=..CreatePSEmp()
	.s psenid=..CreatePSENid()
	.s deptcode=""
	.s droit=""
	.&SQL(select DeptCode into :deptcode from hishr.DeptInfo where deptname=:deptname)
	.&SQL(select PersonDroitType into :droit from hishr.PersonDroitTypeinfo where context=:pstype)
	.i (deptcode="")||(droit="")||(deptcode=$c(0))||(droit=$c(0)) d
	..s reValue="5"
	.e  d
	..&SQL(insert into hishr.personinfo(empcardid,psenid,name,deptcode,cycledept,deptname,startworkday,hiretime,persondroit,personstatus,orgcode)
	values(:emp,:psenid,:name,:deptcode,:deptcode,:deptname,:startworkday,:hiretime,:droit,'01','Org01'))
	..i SQLCODE=0 d
	...s uenid=..CreateUserENid()
	...&SQL(insert into hishr.userinfo(isadmin,isrelateperson,isroleuser,createdby,psenid,psname,userenid,userlogionname,userpassword)
	values('0','1','1',:opr,:psenid,:name,:uenid,:emp,'5D'))
	...i SQLCODE=0 d
	....&SQL(insert into hishr.userrolemapinfo(roleprenid,userprenid) values('RI0029',:uenid))
	....i SQLCODE'=0 d
	.....s reValue="6"
	...e  d
	....s reValue="3"
	..e  d
	...s reValue="4"

	///传入工号不为空的情况
	e  d
	.s isemp=""
	.&SQL(select empcardid into :isemp from hishr.personinfo where empcardid=:emp)
	.i (isemp="")||(isemp=$c(0)) d
	..s psenid=..CreatePSENid()
	..s deptcode=""
	..s droit=""
	..&SQL(select DeptCode into :deptcode from hishr.DeptInfo where deptname=:deptname)
	..&SQL(select PersonDroitType into :droit from hishr.PersonDroitTypeinfo where context=:pstype)
	..i (deptcode="")||(droit="")||(deptcode=$c(0))||(droit=$c(0)) d
	...s reValue="5"
	..e  d
	...&SQL(insert into hishr.personinfo(empcardid,psenid,name,deptcode,cycledept,deptname,startworkday,hiretime,persondroit,personstatus,orgcode)
	values(:emp,:psenid,:name,:deptcode,:deptcode,:deptname,:startworkday,:hiretime,:droit,'01','Org01'))
	...i SQLCODE=0 d
	....s uenid=..CreateUserENid()
	....&SQL(insert into hishr.userinfo(isadmin,isrelateperson,isroleuser,createdby,psenid,psname,userenid,userlogionname,userpassword,Deleted)
	values('0','1','1',:opr,:psenid,:name,:uenid,:emp,'5D','0'))
	....i SQLCODE=0 d
	.....&SQL(insert into hishr.userrolemapinfo(roleprenid,userprenid) values('RI0029',:uenid))
	.....i SQLCODE'=0 d
	......s reValue="6"
	....e  d
	.....s reValue="3"
	...e  d
	....s reValue="4"
	.e  d
	..s reValue="2"
	i reValue'="4" d ;人员添加成功后添加 工资提醒
	.&SQL(insert into hishr.messagealarminfo(EmpCardID,PSENid,MessageType,MessageSatus) values(:emp,:psenid,'7','0'))
	q reValue
}

/// 采集人员基本信息
/// 字段编码，修改后值，修改后名称，工号，psenid
/// w ##class(dhc.hr.PS.PersonManage).CollectPSBaseInfo("Name","","测试一下","0001","PS0000001","")
/// w ##class(dhc.hr.PS.PersonManage).CollectPSBaseInfo("Sex","01","男","0001","PS0000001","")
ClassMethod CollectPSBaseInfo(fieldcode, avalue, aname, emp, psenid, Output reValue As %String) As %String [ SqlProc ]
{
	n (fieldcode,aname,avalue,emp,psenid,reValue)
	s reValue="操作成功"
	s table="" ;关联表
	s condition="" ;关联条件
	s bname="" ;修改前名称
	s bvalue="" ;修改前编码
	s statu="" ;数据审核状态
	s nowdt=$p($h,",",1) ;当前日期
	&SQL(select FEnumDict,FEnumTitle into :table,:condition from hishr.fieldinfo where ftablecode='PersonInfo' and FFieldCode=:fieldcode)
	i (table'="")&&(table'=$c(0)) 
	{
		s str1=$p(condition,"^",1) ;关联条件拆分后对应编码表的编码字段
		s str2=$p(condition,"^",2) ;关联条件拆分后对应编码表的文本字段
		s sqlcode="select a."_fieldcode_" as v,b."_str2_" as n from hishr.personinfo as a left join hishr."_table_" as b on (a."_fieldcode_"=b."_str1
		i $p(condition,"^")>2 d
		.s str3=$p(condition,"^",3)
		.s sqlcode=sqlcode_" and b."_str3
		s sqlcode=sqlcode_") where psenid='"_psenid_"'"
		s result1=##Class(%Library.ResultSet).%New()
		d result1.Prepare(sqlcode)
		d result1.Execute()
		while(result1.Next())
		{
			s bname=result1.Data("n")
			s bvalue=result1.Data("v")
		}
		d result1.Close()
	}
	else
	{
		s sqlcode="select "_fieldcode_" as n from hishr.personinfo where psenid='"_psenid_"'"
		s result2=##Class(%Library.ResultSet).%New()
		d result2.Prepare(sqlcode)
		d result2.Execute()
		while(result2.Next())
		{
			s bname=result2.Data("n")
			s bvalue=bname
			s avalue=aname
		}
		d result2.Close()
    }

    &SQL(select ID ,Status into :id,:statu from hishr.PSBaseCollectInfo where psenid=:psenid and fieldcode=:fieldcode and status='0' ) 
    i (id="")||(statu="1")||(statu="3") d
    .&SQL(insert into hishr.PSBaseCollectInfo(ChangeDate,FieldCode,BeforName,BeforCode,AfterName,AfterCode,EmpCardID,PSENid,Status)
         values(:nowdt,:fieldcode,:bname,:bvalue,:aname,:avalue,:emp,:psenid,'0'))
    .i SQLCODE'=0 d
    ..s reValue="插入数据失败"
    e  d ;存在对应的未审核记录时进行修改
    .&SQL(update hishr.PSBaseCollectInfo set ChangeDate=:nowdt,BeforName=:bname,BeforCode=:bvalue,AfterName=:aname,AfterCode=:avalue where psenid=:psenid and fieldcode=:fieldcode and status='0')
    .i SQLCODE'=0 d
    ..s reValue="更新数据失败"
    q reValue
}

/// Creator: chinaway
/// CreatDate: 2016-09-29
/// Description: 根据PSENid获取其值
/// Table： PersonInfo
/// Input: 	field-字段
/// Return: 
/// Others: w ##class(dhc.hr.PS.PersonManage).GetValueByPSENid("DeptCode","PS0002187")
ClassMethod GetValueByPSENid(field, psenid, Output rvalue) As %String [ SqlProc ]
{
	n (field,psenid,rvalue)

	s rvalue=""
	
	s sql="SELECT "_field_" FROM HISHR.PersonInfo WHERE PSENid='"_psenid_"'"

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sql)
	d result.Execute()
	while(result.Next())
	{	
	   
		s rvalue=result.Data(field)
	
	}
	d result.Close()
	
	q rvalue
}

/// /获取指定字段结合fieldinfo的配置 组成的sql
///  w ##class(dhc.hr.PS.PersonManage).GetSqlFiled("PersonInfo","name^dd,empcardid^,personstatus^","")
ClassMethod GetSqlFiled(tablcode, field As %Text, as1, Output rev As %Text) As %String [ SqlProc ]
{
	i (tablcode="")||(tablcode=$c(0)) q ""
	i (field="")||(field=$c(0)) q ""
	s tbc=$ZCVT(tablcode,"U")
	s sqlselect=as1_".ID AS "_tablcode_$char(95)_"ID"
	s sqlfrom=""
	s rid=""
	s count=1
	f indx=1:1:$l(field,",") d
	.s ff=$p(field,",",indx)
	.s ff=$p(ff,"^",1)
	.s ff=$ZCVT(ff,"U")
	.f  s rid=$O(^HISHR.FieldInfoInfoI("TableField"," "_tbc," "_ff,rid)) q:rid=""  d
	..s fcode=$List(^HISHR.FieldInfoInfoD(rid),5)
	..s fname=$List(^HISHR.FieldInfoInfoD(rid),6)
	..s codetable=$List(^HISHR.FieldInfoInfoD(rid),17)
	..s codewhere=$List(^HISHR.FieldInfoInfoD(rid),18)
	..i fcode'="ID" d
	...i (codetable="")||(codetable=$c(0)) d
	....s sqlselect=sqlselect_","_as1_"."_fcode_" AS "_tablcode_$char(95)_fcode
	...e  d
	....s length=$l(codewhere,"^")
    ....s code=$p(codewhere,"^",1) ;编码表code字段
	....s name=$p(codewhere,"^",2) ;编码表对应汉字字段
	....s sqlselect=sqlselect_","_as1_"b"_count_"."_name_" AS "_tablcode_$char(95)_fcode
	....s sqlfrom=sqlfrom_" left  join hishr."_codetable_" AS "_as1_"b"_count_" "
	....i length>2 d
	.....s sqlfrom=sqlfrom_"on ("_as1_"."_fcode_"="_as1_"b"_count_"."_code_" and "_as1_"b"_count_"."_$p(codewhere,"^",3)_") "
	....e  d
	.....s sqlfrom=sqlfrom_"on ("_as1_"."_fcode_"="_as1_"b"_count_"."_code_") "
    ....s count=count+1
	s rev=sqlselect_"^"_sqlfrom
	q rev
}

/// 获取查询方案
/// w ##class(dhc.hr.PS.PersonManage).GetTempData("SearchPlan")
ClassMethod GetTempData(flag, Output rev As %Text) As %String [ SqlProc ]
{
	s rev="{"_$char(34)_"total"_$char(34)_":"
	s rows=","_$char(34)_"rows"_$char(34)_":["
	s total=0
	s count=0
	s flag=$ZCVT(flag,"U")
	s rid=""
	f  s rid=$O(^HISHR.TempDataInfoI("DTFlag"," "_flag,rid)) q:rid=""  d
	.s fd=$list(^HISHR.TempDataInfoD(rid),2) ;查询的字段
	.s sq=$list(^HISHR.TempDataInfoD(rid),3) ;查询的sql
	.s name=$list(^HISHR.TempDataInfoD(rid),7) ;方案名称
	.i count'=0 d
	..s rows=rows_","
	.s rows=rows_"{"_$char(34)_"name"_$char(34)_":"_$char(34)_name_$char(34)_","
	.s rows=rows_$char(34)_"fd"_$char(34)_":"_$char(34)_fd_$char(34)_","
	.s rows=rows_$char(34)_"sq"_$char(34)_":"_$char(34)_sq_$char(34)_"}"
	.s count=count+1
	.s total=total+1
	s rev=rev_$char(34)_total_$char(34)_rows_"]}"
	q rev
}

Storage Default
{
<StreamLocation>^dhc.hr.PS.PersonManageS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
