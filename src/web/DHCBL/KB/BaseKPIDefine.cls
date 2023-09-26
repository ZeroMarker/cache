Class web.DHCBL.KB.BaseKPIDefine Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2015-3-6
/// Description：查询KPI指标条件定义表
/// Table：%IHBI.BaseKPIDefine
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.BaseKPIDefine","GetList","","","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "KPIRowId,KPICode,KPIName,KPIType,DivCode,DivendCode,KPIAlias,TableName,DecDigits,ConvFactor,ShowFormat")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s KPIRowId=rowid
		s KPICode=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),1)  //代码
		s KPIName=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),2)  //名称
		s KPIType=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),3)  //指标类型
		s DivCode=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),4)  //分子
		s DivendCode=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),5)  //分母
		s KPIAlias=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),6)  //别名
		s TableName=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),7)  //数据来源
		s DecDigits=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),8)  //小数位数
		s ConvFactor=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),9)  //指标转换因子
		s ShowFormat=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),10)  //显示风格
		
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s KPIRowId=0
		for  
		{	
			s KPIRowId=$o(^IHBI.BaseKPIDefineD(KPIRowId)) q:KPIRowId="" 
				
			s KPICode=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),1)  //代码
			s KPICodeU=$ZCONVERT(KPICode,"U")
			s KPIName=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),2)  //名称
			s KPINameU=$ZCONVERT(KPIName,"U")
			s KPIType=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),3)  //指标类型
			s DivCode=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),4)  //分子
			s DivendCode=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),5)  //分母
			s KPIAlias=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),6)  //别名
			s TableName=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),7)  //数据来源
			s DecDigits=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),8)  //小数位数
			s ConvFactor=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),9)  //指标转换因子
			s ShowFormat=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),10)  //显示风格
			
			i (KPICodeU[code)&(KPINameU[desc)   //条件
			{
				d OutputRow
			}		

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(KPIRowId,KPICode,KPIName,KPIType,DivCode,DivendCode,KPIAlias,TableName,DecDigits,ConvFactor,ShowFormat)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2015-3-25
/// Description:查询
/// Input:desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.BaseKPIDefine","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "KPIRowId:%String,KPIName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s KPIRowId=rowid
		s KPIName=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),2)  //名称
		d OutputRowCmb
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s KPIRowId=0
		for
		{
			s KPIRowId=$o(^IHBI.BaseKPIDefineD(KPIRowId)) q:KPIRowId="" 
				
			s KPIName=$listget($g(^IHBI.BaseKPIDefineD(KPIRowId)),2)  //名称
			s KPINameU=$ZCONVERT(KPIName,"U")
			i (KPINameU[desc)
			{
				d OutputRowCmb
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(KPIRowId,KPIName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2015-3-6    
/// w ##class(web.DHCBL.KB.BaseKPIDefine).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^IHBI.BaseKPIDefineI("UqKPICodeIdx"," "_code))
	s:desc'="" flagd=$d(^IHBI.BaseKPIDefineI("UqKPINameIdx"," "_desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^IHBI.BaseKPIDefineI("UqKPICodeIdx"," "_code,0))
		s:desc'="" idd=$o(^IHBI.BaseKPIDefineI("UqKPINameIdx"," "_desc,0))
		if (desc="")
		{
			if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		elseif (code="")
		{
			if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2015-3-6
/// Description：保存修改内容
/// Table：%IHBI.BaseKPIDefine
/// Input：web.Entity.KB.BaseKPIDefine 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.BaseKPIDefine) As %String
{
	
	s result = ""
	if $IsObject(eobj)
	{
		Ts
		s flag=..FormValidate(eobj.KPIRowId, eobj.KPICode, eobj.KPIName)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
		}
		else
		{
			if (eobj.KPIRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(%IHBI.BaseKPIDefine).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(%IHBI.BaseKPIDefine).%OpenId(eobj.KPIRowId)

				s bobj = ##class(web.Entity.KB.BaseKPIDefine).%New()
				s bobj.KPIRowId = eobj.KPIRowId
				s bobj.KPICode = obj.KPICode
				s bobj.KPIName = obj.KPIName
				s bobj.KPIType = obj.KPIType
				s bobj.DivCode = obj.DivCode
				s bobj.DivendCode = obj.DivendCode
				s bobj.KPIAlias = obj.KPIAlias
				s bobj.TableName = obj.TableName
				s bobj.DecDigits = obj.DecDigits
				s bobj.ConvFactor = obj.ConvFactor
				s bobj.ShowFormat = obj.ShowFormat
				
			}
			s obj.KPICode = eobj.KPICode
			s obj.KPIName = eobj.KPIName
			s obj.KPIType = eobj.KPIType
			s obj.DivCode = eobj.DivCode
			s obj.DivendCode = eobj.DivendCode
			s obj.KPIAlias = eobj.KPIAlias
			s obj.TableName = eobj.TableName
			s obj.DecDigits = eobj.DecDigits
			s obj.ConvFactor = eobj.ConvFactor
			s obj.ShowFormat = eobj.ShowFormat

			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.KPIRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.BaseKPIDefine","%IHBI.BaseKPIDefine","KPI指标条件定义表",id,eobj.KPIName,"A",eobj)
				d:eobj.KPIRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.BaseKPIDefine","%IHBI.BaseKPIDefine","KPI指标条件定义表",eobj.KPIRowId,eobj.KPIName,"U",eobj,bobj)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
			}	
		}
	}	
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Creator：高姗姗
/// CreatDate: 2015-3-6
/// Description：获取修改时的记录
/// Table：%IHBI.BaseKPIDefine
/// Other: d ##class(web.DHCBL.KB.BaseKPIDefine).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.BaseKPIDefine).%New()
	s pobj = ##class(%IHBI.BaseKPIDefine).%OpenId(id)
	s eobj.KPIRowId = id
	s eobj.KPICode = pobj.KPICode
	s eobj.KPIName = pobj.KPIName
	s eobj.KPIType = pobj.KPIType
	s eobj.DivCode = pobj.DivCode
	s eobj.DivendCode = pobj.DivendCode
	s eobj.KPIAlias = pobj.KPIAlias	
	s eobj.TableName = pobj.TableName
	s eobj.DecDigits = pobj.DecDigits
	s eobj.ConvFactor = pobj.ConvFactor
	s eobj.ShowFormat = pobj.ShowFormat

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2015-3-25
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	
	s KPIRowId=0,flag=0
	for
	{
		s KPIRowId=$o(^IHBI.KPITargetValD(KPIRowId)) q:(KPIRowId="")||(flag=1)  d
		s KPIDR=$listget($g(^IHBI.KPITargetValD(KPIRowId)),2)
		i KPIDR=id
		{
			s flag=1
			s myInfo=myInfo_"[KPI目标值维护表]"
		}
	}
	
	s KPIRowId=0,flag=0
	for
	{
		s KPIRowId=$o(^IHBI.KPICondConfigD(KPIRowId)) q:(KPIRowId="")||(flag=1)  d
		s KPIDR=$listget($g(^IHBI.KPICondConfigD(KPIRowId)),2)
		i KPIDR=id
		{
			s flag=1
			s myInfo=myInfo_"[KPI指标条件配置表]"
		}
	}
		
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
 	q return
}

/// Creator:高姗姗
/// CreatDate:2015-3-6
/// Description:根据id删除
/// Table:%IHBI.BaseKPIDefine
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.BaseKPIDefine).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
	s re=##class(web.DHCBL.KB.BaseKPIDefine).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		Tstart
		s eobj = ##class(web.Entity.KB.BaseKPIDefine).%New()
		s pobj = ##class(%IHBI.BaseKPIDefine).%OpenId(id)
		s eobj.KPIRowId = id
		s eobj.KPICode = pobj.KPICode
		s eobj.KPIName = pobj.KPIName
		s eobj.KPIType = pobj.KPIType
		s eobj.DivCode = pobj.DivCode
		s eobj.DivendCode = pobj.DivendCode
		s eobj.KPIAlias = pobj.KPIAlias
		s eobj.TableName = pobj.TableName
		s eobj.DecDigits = pobj.DecDigits
		s eobj.ConvFactor = pobj.ConvFactor
		s eobj.ShowFormat = pobj.ShowFormat
	
		s sc=##class(%IHBI.BaseKPIDefine).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.BaseKPIDefine","%IHBI.BaseKPIDefine","KPI指标条件定义表",id,eobj.KPIName,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
	}
	q result
}

/// 获取数据来源
/// w ##class(web.DHCBL.KB.BaseKPIDefine).GetTableName("")
ClassMethod GetTableName(KPICode As %String) As %String
{
	s tableName=""
	if ((KPICode="'010006")||(KPICode="'010007")||(KPICode="010008")||(KPICode="010010")||(KPICode="010047")||(KPICode="010048")||(KPICode="010051")||(KPICode="'010014")||(KPICode="'010018")||(KPICode="'010030")||(KPICode="'010085")){
		s tableName="DHC_TarCate"
	}
	if ((KPICode="100003")||(KPICode="100009")){
		s tableName="DHC_ItmAddionInfo"
	}
	if (KPICode="100004"){
		s tableName="PHC_Poison"
	}
	if ((KPICode="100005")||(KPICode="100056")||(KPICode="100010")){
		s tableName="PHC_Instruc"
	}
	if ((KPICode="100006")||(KPICode="100069")){
		s tableName="OEC_OrderCategory"
	}
	if ((KPICode="020015")||(KPICode="080008")){
		s tableName="PAC_AdmReason"
	}
	/*
	if (KPICode="100002"){
		s tableName="Data.Prescription-31"
	}
	if (KPICode="040002"){
		s tableName="Data.MRBase-CYHZRS"
	}
	if (KPICode="040009"){
		s tableName="Data.MRBase-SSBFZ"
	}
	if (KPICode="'020001"){
		s tableName="Data.Register"
	}*/
	q tableName
}

}
