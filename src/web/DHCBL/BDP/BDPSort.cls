Class web.DHCBL.BDP.BDPSort Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:高姗姗
/// CreatDate:2015-8-7
/// Description:查询 排序类型 
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPSort","GetDataForCmb1","","","User.MRCICDDxType","") //User.CTLoc
Query GetDataForCmb1(rowid As %String, desc As %String, tableName As %String, hospid As %String) As %Query(ROWSPEC = "ID:%String,SortType:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, tableName As %String, hospid As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    
    
    s tablecode= ##class(web.DHCBL.BDP.BDPTableList).GetCodeByTableName(tableName)
    s HospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
    s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tablecode)  //获取数据公有私有类型
    if (rowid'="")
    {
        s SortId=rowid
        s ID=rowid
        s SortType=$listget($g(^User.BDPSortD(SortId)),4)
        d OutputRowCmb
    }
    else
    {

        k TMPSORTTYPE
        s SortId=0
        for
        {
            s SortId=$o(^User.BDPSortD(SortId)) q:SortId=""
            
            s TableName=$listget($g(^User.BDPSortD(SortId)),2)
            s SortType=$listget($g(^User.BDPSortD(SortId)),4)
            s RowId=$listget($g(^User.BDPSortD(SortId)),3)
            s Desc=""
            ///2020-07-01根据医院过滤非公有数据
            if ((hospid'="")&&(HospAutflag="Y")&&(DataTypeFlag'="G"))
            {
                if tableName="User.ARCItmMast"
                {
                    s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(tablecode,RowId_"||1",hospid)
                }
                else
                {
                    s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(tablecode,RowId,hospid)
                }
                continue:showflag="N"
            }
            if ($ZCONVERT(TableName,"U")[$ZCONVERT(tableName,"U"))
            {
                s TMPSORTTYPE(tableName,SortType)= SortId
            }
        }
        
        s SortType = 0
        for 
        { 
            s SortType=$o(TMPSORTTYPE(tableName,SortType)) q:SortType="" 
            S ID=$g(TMPSORTTYPE(tableName,SortType))
            d OutputRowCmb      
        }
        K TMPSORTTYPE  
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(ID,SortType)
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

/// Creator：高姗姗
/// CreatDate: 2015-8-7
/// Description：查询各表描述，还不支持子表
/// Table：表结构登记
/// Input：rowid, tableName
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPSort","GetList","User.CTHospital","","","2","") 
Query GetList(tableName, type, dir, hospid, desc) As %Query(ROWSPEC = "SortId,RowId,Desc,SortType,SortNum")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, tableName, type, dir, hospid, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    s:desc'="" desc=$zcvt(desc,"U")
    s tablecode= ##class(web.DHCBL.BDP.BDPTableList).GetCodeByTableName(tableName)
    s HospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
    s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(tablecode)  //获取数据公有私有类型
    k array
    
    
    s RowIdStr=""
    if (type'="")
    {
        s n=0
        s SortNum=""     //排序表中内容
        for
        {
            s SortNum=$o(^User.BDPSortI("SortNumIdx",tableName,type,SortNum)) q:(SortNum="")
            s n=n+1
            s a(n)= SortNum     
        }
        
        s left=1,right=n
        if (dir="DESC")
        {
            d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSortDesc(.a,left,right) //排序 降序
        }
        else
        {
            d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序 升序
        }
        s count=0
        s SortId=0
        s n=0
        for 
        {
            s n=$o(a(n)) q:n=""
            s SortNum=$g(a(n))
            for
            {
                s SortId = $o(^User.BDPSortI("SortNumIdx",tableName,type,SortNum,SortId)) q:SortId=""
                s count=count+1
                s array(count)=SortId
                
            }
        }
        s SortId=0
        s num=0
        for 
        {
            s num=$o(array(num)) q:num=""
            s SortId=$g(array(num))
            s RowId=$listget($g(^User.BDPSortD(SortId)),3)
            s Desc=""
            ///2020-07-01根据医院过滤非公有数据
            if ((hospid'="")&&(HospAutflag="Y")&&(DataTypeFlag'="G"))
            {
	            if tableName="User.ARCItmMast"
                {
                    s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(tablecode,RowId_"||1",hospid)
                }
                elseif tableName="User.CTHospital"  //医院单独处理2021-11-11
                {
	                s showflag="N"
	                s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	                s AuStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
			s strRowId = "{ID:"_RowId_"}"
			i ((AuStr[strRowId)||(AuStr=""))&((AuHospStr="off")||(AuHospStr[strRowId)||(AuHospStr=1))
			{
				s showflag ="Y"
			}
                }
                else
                {
                    s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(tablecode,RowId,hospid)
                }
                continue:showflag="N"
            }
            s DescProName=$o(^User.BDPTableListI("SubProDescIndex",tableName,0))
            s xobjStr="s dataobj=##class("_tableName_").%OpenId("""_RowId_""")"
            if (tableName="User.ARCItmMast")&&(RowId'["||") s xobjStr="s dataobj=##class("_tableName_").%OpenId("""_RowId_"||1"_""")"  //医嘱项特殊
            x xobjStr
            if (dataobj)&&(DescProName'="")
            {
                s DescXstr="s Desc=dataobj."_DescProName
                x DescXstr
                d dataobj.%Close()
            }
            continue:Desc=""
            if (tableName="User.DHCTimeRange") {
                s TRValidStartDate=$p($g(^DHCTimeRange(RowId)),"^",7)
                continue:(TRValidStartDate'="")&&(TRValidStartDate>+$h)
                s TRValidEndDate=$p($g(^DHCTimeRange(RowId)),"^",8)
                continue:(TRValidEndDate'="")&&(TRValidEndDate<=+$h)
            }
            s SortType=$listget($g(^User.BDPSortD(SortId)),4)
            s SortNum=$listget($g(^User.BDPSortD(SortId)),5)
            
            i ($ZCONVERT(SortType,"U")[$ZCONVERT(type,"U"))
            {
                if $zcvt(Desc,"U")[desc
                {
                    	d OutputRow  
                }
            }
        }
        s RowIdStr = ##class(web.DHCBL.BDP.BDPSort).GetSortReference(tableName,type)
    }
    s BDPTableListid = $o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(tableName,"U"),0))
    if BDPTableListid'=""
    {
        S xGlobal=$listget($g(^User.BDPTableListD(BDPTableListid)),9)  
        s DescProName=$o(^User.BDPTableListI("SubProDescIndex",tableName,0))
        if xGlobal'=""
        {
            s RowId=0            //原表内容
            if $e(xGlobal,$l(xGlobal))=")" s xRowIdStr="s RowId=$o("_$e(xGlobal,1,$l(xGlobal)-1)_",RowId)"_")"
            else  s xRowIdStr="s RowId=$o("_xGlobal_"(RowId)"_")"
            for 
            {       
                x xRowIdStr q:(RowId="")||(RowId'>0)
                s Id = "["_RowId_"]"
                s Desc=""
                s Code=""
                if (RowIdStr[Id) continue
                ///2020-07-01根据医院过滤非公有数据
                if ((hospid'="")&&(HospAutflag="Y")&&(DataTypeFlag'="G"))
                {
	                if tableName="User.ARCItmMast"
                    {
                        s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(tablecode,RowId_"||1",hospid)
                    }
                    elseif tableName="User.CTHospital"
	                {
		                s showflag="N"
		                s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		                s AuStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
						s strRowId = "{ID:"_RowId_"}"
						i ((AuStr[strRowId)||(AuStr=""))&((AuHospStr="off")||(AuHospStr[strRowId)||(AuHospStr=1))
						{
	                   		s showflag ="Y"
						}
	                }
                    else
                    {
                        s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(tablecode,RowId,hospid)
                    }
                    continue:showflag="N"
                }
        
                s xobjStr="s dataobj=##class("_tableName_").%OpenId("""_RowId_""")"
                if (tableName="User.ARCItmMast")&&(RowId'["||") s xobjStr="s dataobj=##class("_tableName_").%OpenId("""_RowId_"||1"_""")"  //医嘱项特殊
                x xobjStr
                if (dataobj)&&(DescProName'="")
                {
                    s DescXstr="s Desc=dataobj."_DescProName
                    x DescXstr
                    d dataobj.%Close()
                }
                if (tableName="User.MRCICDDx")  //ICD诊断代码
                {
                    s Code =$p($g(^MRC("ID",RowId)),"^",1)
                    continue:(Code="-")||(Desc="-") //屏蔽垃圾数据
                    s Valid=$p($g(^MRC("ID",RowId)),"^",27)
                    continue:Valid="N"  
                }
                if (tableName="User.DHCTimeRange") {
                    s TRValidStartDate=$p($g(^DHCTimeRange(RowId)),"^",7)
                    continue:(TRValidStartDate'="")&&(TRValidStartDate>+$h)
                    s TRValidEndDate=$p($g(^DHCTimeRange(RowId)),"^",8)
                    continue:(TRValidEndDate'="")&&(TRValidEndDate<=+$h)
                }
                s SortType = ""
                s SortNum = ""
                continue:Desc=""
                if $zcvt(Desc,"U")[desc
                {
                	d OutputRow    
                } 
            }   
        }
        
    }

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(SortId,RowId,Desc,SortType,SortNum)
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

/// w ##class(web.DHCBL.BDP.BDPSort).GetSortReference("User.PHCInstruc","测试")
ClassMethod GetSortReference(tableName As %String, type As %String) As %String
{
	q:(tableName="")||(type="") ""
    s RowIdStr=""
    s SortId=0
    for
    {
        s SortId=$o(^User.BDPSortI("TableTypeIdx",tableName,type,SortId))   q:SortId=""
        s RowId=$listget($g(^User.BDPSortD(SortId)),3)
        s RowIdStr="["_RowId_"],"_RowIdStr
    }
    q RowIdStr
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2015-8-11 
/// w ##class(web.DHCBL.BDP.BDPSort).FormValidate("","User.CTLoc","病案科室","3")
ClassMethod FormValidate(id As %String, tableName As %String, type As %String, reference As %String) As %String
{
    s flag=""
    s flagd=""
    s flagd=$d(^User.BDPSortI("ReferenceIdx",tableName,type,reference))
    if (id="") //如果为空，增加时的重复判断
    {
        if (flagd>0)
        {
            s flag=1  //返回重复标志
        }
        else
        {
            s flag=0 //返回不重复标志
        }
    }
    else //如果不为空，修改时的重复判断
    {
        s idd=""    
        s idd=$o(^User.BDPSortI("ReferenceIdx",tableName,type,reference,0))
        if ((idd'=id)&(flagd>0))
        {
            s flag=1  //返回重复标志
        }
        else
        {
            s flag=0 //返回不重复标志
        }
    }
    q flag
}

/// d ##class(web.DHCBL.BDP.BDPSort).SaveData("User.SSLanguage^56^test^^7*User.SSLanguage^20^test^2^")
ClassMethod SaveData(sortstr As %String, type As %String = "") As %String
{
    s result=""
    if (sortstr'=""){
        s sortlength=$Length(sortstr,"*")
        for i=1:1:sortlength
        {
            s sort=$p(sortstr,"*",i)
            s TableName = $p(sort,"^",1)
            s DataReference = $p(sort,"^",2)
            s SortType = $p(sort,"^",3)
            s SortNum = $p(sort,"^",4)
            s SortId = $p(sort,"^",5)
            if (SortType="")&(type'="") s SortType=type
            s flag=..FormValidate(SortId,TableName,SortType,DataReference)  //调用重复验证
            if (flag=1)
            {
                s result = "{success:'false',errorinfo:'该记录已经存在！'}"
            }
            else{
                if (SortId="") //SortId为空新增
                {
                    s obj=##class(User.BDPSort).%New()
                    s obj.TableName = TableName
                    s obj.DataReference = DataReference
                    s obj.SortType = SortType
                    s obj.SortNum = SortNum 
                    s logJson="{TableName:"""_TableName_""",DataReference:"""_DataReference_""",SortType:"""_SortType_""",SortNum:"""_SortNum_""",SortId:"""_SortId_"""}"
        
                    s sc=obj.%Save()
                    d obj.%Close()
                    If $$$ISOK(sc){
                        s id = obj.%Id()
                        s result = "{success:'true',id:'"_id_"'}"
                        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("User.BDPSort","User.BDPSort","排序",id,TableName_":"_DataReference,"A",logJson)
                    }
                    else{
                        s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"  
                    }
                }
                else{ //SortId不为空
                    if (SortNum=""){//顺序号为空时删除
                        s result = ..DeleteData(SortId)
                    }else{ //顺序号不为空时修改
                        s obj=##class(User.BDPSort).%OpenId(SortId)
                        s bTableName = obj.TableName
                        s bDataReference = obj.DataReference
                        s bSortType = obj.SortType
                        s bSortNum = obj.SortNum
                        s blogJson="{TableName:"""_bTableName_""",DataReference:"""_bDataReference_""",SortType:"""_bSortType_""",SortNum:"""_bSortNum_""",SortId:"""_SortId_"""}"                  
                        s obj.TableName = TableName
                        s obj.DataReference = DataReference
                        s obj.SortType = SortType
                        s obj.SortNum = SortNum 
                        s logJson="{TableName:"""_TableName_""",DataReference:"""_DataReference_""",SortType:"""_SortType_""",SortNum:"""_SortNum_""",SortId:"""_SortId_"""}"
        
                        s sc=obj.%Save()
                        d obj.%Close()
                        If $$$ISOK(sc){
                            s id = obj.%Id()
                            s result = "{success:'true',id:'"_id_"'}"
                            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("User.BDPSort","User.BDPSort","排序",SortId,TableName_":"_DataReference,"U",logJson,blogJson)
                        }
                        else{
                            s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"  
                        }
                    }           
                } //SortId不为空判断 
            } //重复校验判断  
        }
        q result
    }
}

ClassMethod DeleteData(id) As %String
{
    s result=""
    s pobj=##class(User.BDPSort).%OpenId(id)
    s bTableName = pobj.TableName
    s bDataReference = pobj.DataReference
    s bSortType = pobj.SortType
    s bSortNum = pobj.SortNum
    s blogJson="{TableName:"""_bTableName_""",DataReference:"""_bDataReference_""",SortType:"""_bSortType_""",SortNum:"""_bSortNum_""",SortId:"""_id_"""}"                  
    s sc=##class(User.BDPSort).%DeleteId(id)
    IF $$$ISOK(sc){
        s result="{success:'true',info:'删除成功！'}"
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("User.BDPSort","User.BDPSort","排序",id,bTableName_":"_bDataReference,"D",blogJson)
    }
    else{
        s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
    }
    q result
}

/// d ##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.CTLoc","急诊科室","4")
ClassMethod GetSortNum(tableName As %String, type As %String, rowid As %String) As %String
{
    s num = ""
    s SortId=$o(^User.BDPSortI("ReferenceIdx",tableName,type,rowid,0))
    s:SortId'="" num=$listget($g(^User.BDPSortD(SortId)),5)
    q num
}

/// Creator:高姗姗
/// CreatDate:2018-9-11
/// Description:查询排序后的id串
/// Input：表名,排序类型
/// Other: w ##class(web.DHCBL.BDP.BDPSort).GetSortStr("User.PHCInstruc","测试")
ClassMethod GetSortStr(tableName As %String, type As %String) As %String
{
    q:tableName="" ""
    q:type="" ""
    s tableNameU=$ZCONVERT(tableName,"U")
    s typeU=$ZCONVERT(type,"U")
    k array
    s n=0
    s SortNum=0     //排序表中内容
    for
    {
        s SortNum=$o(^User.BDPSortI("SortNumIdx",tableName,type,SortNum)) q:(SortNum="")
        s n=n+1
        s a(n)= SortNum     
    }
    
    s left=1,right=n
    d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序 升序
    s count=0
    
    s n=0
    for 
    {
        s n=$o(a(n)) q:n=""
        s SortNum=$g(a(n))
        s SortId=0
        for
        {
            s SortId = $o(^User.BDPSortI("SortNumIdx",tableName,type,SortNum,SortId)) q:SortId=""
            s count=count+1
            s array(count)=SortId   
        }
    }
    s SortStr=""
    s num=0
    for 
    {
        s num=$o(array(num)) q:num=""
        s SortId=$g(array(num))
        s RowId=$listget($g(^User.BDPSortD(SortId)),3)
        s SortType=$listget($g(^User.BDPSortD(SortId)),4)
        s:SortType'="" SortTypeU=$ZCONVERT(SortType,"U")
        i (SortTypeU[typeU)
        {
            s:SortStr'="" SortStr=SortStr_"^"_RowId
            s:SortStr="" SortStr=RowId
        }
    }
    q SortStr
}

/// Creator：高姗姗
/// CreatDate: 2018-09-11
/// Description：测试用例：查询药品用法排序后的列表信息
/// Input：表名，排序类型
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPSort","GetSortList","User.PHCInstruc","测试") 
Query GetSortList(tableName, type) As %Query(ROWSPEC = "PHCINRowId,PHCINDesc1")
{
}

ClassMethod GetSortListExecute(ByRef qHandle As %Binary, tableName, type) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    if ((tableName'="")&(type'="")){
        ;取排序过的数据RowId
        s SortStr=##class(web.DHCBL.BDP.BDPSort).GetSortStr(tableName,type)
        s SortLen=$Length(SortStr,"^")
        for i=1:1:SortLen{
            s RowId=$p(SortStr,"^",i)
            s PHCINRowId=RowId
            s PHCINDesc1 = $p($g(^PHCIN(PHCINRowId)),"^",2)
            d OutputRowSortList
        }
        ;取排序外的数据RowId
        s RowIdStr ="^"_SortStr_"^"
        s PHCINRowId=0
        for
        {
            s PHCINRowId=$o(^PHCIN(PHCINRowId)) q:PHCINRowId=""
            s Id = "^"_PHCINRowId_"^"
            if (RowIdStr[Id) continue
            s PHCINDesc1 = $p($g(^PHCIN(PHCINRowId)),"^",2)
            d OutputRowSortList
        }
    }   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowSortList
    set Data=$lb(PHCINRowId,PHCINDesc1)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSortListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSortListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetSortListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSortListExecute ]
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

}
