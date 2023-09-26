/// 名称: 公私有数据关联科室
/// 编写者：xy
/// 编写日期: 2021-07-29
Class web.DHCPE.CT.DHCPEMappingLoc Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：    xy
/// CreatDate：  20210729
/// Description: 获取表是公有G ，私有S，管控C，绝对私有A标识
/// Table：      表登记授权管理 User.DHCPEPowerTableList 
/// Input:       tableName : 表名或类名
/// Return：     return=公有G、私有S、管控C、绝对私有A
/// Debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).GetPowerType("DHC_PE_EDClass")
ClassMethod GetPowerType(tableName As %String) As %String
{
    n (tableName)
    s PowerType="G"
    q:tableName="" PowerType
    
    s tableName=$ZCVT(tableName,"U")
    s PTLID=$o(^CT.PE.PowerTableListI("IdxOfCode"," "_tableName,0))  //表名
    s:PTLID="" PTLID=$O(^CT.PE.PowerTableListI("IdxOfClsCode"," "_tableName,0))  //类名
    q:PTLID="" PowerType
    
    s PowerType=$listget($g(^CT.PE.PowerTableListD(PTLID)),4)
    s:PowerType="" PowerType="G"
    q PowerType
}

/// Creator： xy
/// CreatDate： 20210819
/// Description: 获取授权类型描述
/// Table： 
/// Input: Type:授权类型
/// Return： return=公有G、私有S、管控C、绝对私有A
/// debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).GetPowerTypeDesc("G")
ClassMethod GetPowerTypeDesc(Type As %String = "") As %String
{
	n (Type)
	q:Type="" ""
	s:Type="G" Desc="公有"
	s:Type="S" Desc="私有"
	s:Type="C" Desc="管控"
	s:Type="A" Desc="绝对私有"
	q Desc
}

/// Creator：    zhufei
/// CreatDate：  20210817
/// Description: 获取表登记信息（数据类型：公有G ，私有S，管控C，绝对私有A）
/// Table：      表登记授权管理 User.DHCPEPowerTableList
/// Input:       aTableName 表名或类名
/// Return：     return=Object
/// debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).GetPowerTypeObj("DHC_PE_EDClass")
ClassMethod GetPowerTypeObj(aTableName As %String) As User.DHCPEPowerTableList
{
    n (aTableName)
    s return=""
    q:aTableName="" return
    
    s PTLID=$o(^CT.PE.PowerTableListI("IdxOfCode"," "_$zcvt(aTableName,"U"),0))  //表名
    s:PTLID="" PTLID=$O(^CT.PE.PowerTableListI("IdxOfClsCode"," "_$zcvt(aTableName,"U"),0))  //类名
    q:PTLID="" return
    
    q:'##class(User.DHCPEPowerTableList).%ExistsId(PTLID) return
	s obj=##Class(User.DHCPEPowerTableList).%OpenId(PTLID)
	q:'$IsObject(obj) return
	d obj.%Close()
	
	s return=obj
	q return
}

/// Creator：    xy
/// CreatDate：  20210729
/// Description: 获取科室对应的默认科室ID
/// Table：      科室分组表 User.DHCPELocGrpConfig 
/// Input:       LocID : 科室ID
/// Return：     return=默认科室ID
/// debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocGrpByLocID("539")
ClassMethod GetLocGrpByLocID(LocID As %String) As %String
{
    n (LocID)
    q:LocID="" "-1^登录科室不能为空"
    s LocGrpID=""
    s LGLocDR=$o(^CF.PE.LocGrpConfigI("IdxOfLoc"," "_LocID,0))
    s:LGLocDR'="" LocGrpID=$listget($g(^CF.PE.LocGrpConfigD(LGLocDR)),3) //取默认科室
    q LocGrpID
}

/// Creator：    xy
/// CreatDate：  20211221
/// Description: 获取科室组下对应的科室ID
/// Table：      科室分组表 User.DHCPELocGrpConfig 
/// Input:       LocGrpID : 默认科室ID
/// Return：     return=科室ID
/// debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocIDByLocGrp("152")
ClassMethod GetLocIDByLocGrp(LocGrpID As %String) As %String
{
	
	n (LocGrpID)
 	q:LocGrpID="" "-1^默认科室为空"
 	s locidStr=""
    s locid=""
    f  s locid=$o(^CF.PE.LocGrpConfigI("IdxOfLocGrp"," "_LocGrpID,locid)) q:locid=""  d
    .s LGCID=""
    .f  s LGCID=$o(^CF.PE.LocGrpConfigI("IdxOfLocGrp"," "_LocGrpID,locid,LGCID)) q:LGCID=""  d
    ..i locidStr="" s locidStr=$lg($g(^CF.PE.LocGrpConfigD(LGCID)),2) 
    ..e  s locidStr=locidStr_"^"_$lg($g(^CF.PE.LocGrpConfigD(LGCID)),2)
	q locidStr
}

/// Creator：    xy 
/// CreatDate：  20210729
/// Description: 根据科室ID判断是否有权显示表里某一条数据（暂时先不用了）
/// Table：      表记录授权表 User.DHCPEPowerControl
/// Input:       tableName : 表名称，格式如DHC_PE_StationOrder
///              dataid    : 对应表数据RowID
///              LocID     : 科室下拉列表的ID
/// Return：     ret=Y/N
/// Debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocShowDataFlag("DHC_PE_StationOrder","1||14","152")
ClassMethod xxxGetLocShowDataFlag(tableName As %String, dataid As %String, LocID As %String, ParRef As %String = "", Empower As %String = "N") As %String
{
	s ^tempdhcpe("GetLocShowDataFlag")=$lb(tableName,dataid,LocID,ParRef,Empower)
    n (tableName,dataid,LocID,ParRef,Empower)
    s return="N"
    //q:(tableName="")||(LocID="")||(dataid="") return
    q:tableName="" "-1^表名不能为空"
    q:LocID="" "-1^登录科室不能为空"
    q:dataid="" "N"
    
    //获取表登记信息（数据公有、私有类型）
    s objPowerType=..GetPowerTypeObj(tableName)
    q:'$IsObject(objPowerType) return
    s DataTypeFlag=objPowerType.PTPowerType
    s TableListDR=objPowerType.%Id()
    s ParCode=objPowerType.PTParCode  //父表表名
    
    s sameflag= ..IsSamePowerType(tableName,dataid,Empower)
    ;b ;sameflag ParCode
    if (ParCode'="")&&(sameflag="1"){
	    s objParPowerType=..GetPowerTypeObj(ParCode)
   		s TableListDR=objParPowerType.%Id()
	    s dataid=ParRef
    }  

    if (DataTypeFlag="S") { //私有数据
        //获取科室对应的科室组默认科室ID
        s LGLocID=..GetLocGrpByLocID(LocID)
        q:LGLocID="" return
        q:dataid="" "N"
        //判断是否存在科室组LGLocID的关联数据 私有数据
        q:'$d(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDR,dataid,LGLocID,"Y")) return
        /*
        //如果为单独授权记录，判断是否给本科室LocID授权
        if $d(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDR,dataid,LGLocID,"Y","Y")){
            q:'$d(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,dataid,LocID,"Y")) return
        }
        s return="Y"
        */
           
        //如果为单独授权记录，判断是否给本科室LocID授权
        if $d(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDR,dataid,LGLocID,"Y","Y")){
	         //获取单独授权科室
	        s EmpowerStr=##class(web.DHCPE.CT.DHCPEMappingLoc).GetEmpowerFlag(tableName,dataid,LocID)
            s EmpowerLocStr=$p(EmpowerStr,"^",2)
            if (EmpowerLocStr=""){
	             //单独授权科室为空,显示
	        	s return="Y"
        	}else{
	        	//单独授权科室不为空,判断是都授权给本科室
            	q:'$d(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,dataid,LocID,"Y")) return 
       	 		s return="Y"
        		}
        	}
        	s return="Y"   
    } elseif (DataTypeFlag="C") { //管控数据
        //获取单独授权科室
        s EmpowerStr=##class(web.DHCPE.CT.DHCPEMappingLoc).GetEmpowerFlag(tableName,dataid,LocID)
        s EmpowerLocStr=$p(EmpowerStr,"^",2)
        if (EmpowerLocStr=""){
	         //单独授权科室为空,显示
	         s return="Y"
        }else{
	        //单独授权科室不为空,判断是否存在本科室LocID的关联数据
        	q:'$d(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,dataid,LocID,"Y")) return
        	s return="Y"
        }
        
    } elseif (DataTypeFlag="A"){ //绝对数据
	    //判断是否存在本科室LocID的关联数据
        q:'$d(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,dataid,LocID,"Y")) return
        s return="Y"
    }else {
        s return="Y"
    }
    q return
}

/// Creator：    xy 
/// CreatDate：  20210804
/// Description: 获取用户的权限（超级S、科室组G、科室L）
/// Table：      用户权限管理表 User.DHCPEPowerSuperUser
/// Input:       UserID : 用户ID
///              GroupID : 安全组ID
/// debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).GetUserPower("12187","164")
ClassMethod GetUserPower(UserID As %String = "", GroupID As %String = "") As %String
{
    n (UserID,GroupID)
    s PowerType="L"
    s ID=$O(^CF.PE.PowerSuperUserI("IdxOfUserGrp"," "_UserID," "_GroupID,0))
    q:ID="" PowerType
    s PowerType=$lg($g(^CF.PE.PowerSuperUserD(ID)),4)
    q PowerType
}

/// Creator：    xy
/// CreatDate：  20210729
/// Description: 科室下拉列表
/// Table：      User.DHCPELocGrpConfig
/// Input:       rowid       : 科室id检索条件
///              desc        : 科室名称检索条件
///              SessionStr  : 用户ID^安全组ID^当前登录科室ID^当前登录医院ID
///              SelectLocID : 选择科室ID
/// Return：     ROWSPEC=LocRowId(科室ID),LocDesc(科室名称)
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.DHCPEMappingLoc","GetLocDataForCombo","","","12187^164^152^2","152")
Query GetLocDataForCombo(rowid As %String, desc As %String, SessionStr As %String, SelectLocID As %String = "") As %Query(ROWSPEC = "LocRowId:%String,LocDesc:%String,LGLocId:%String,LGLocDesc:%String")
{
}

ClassMethod GetLocDataForComboExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, SessionStr As %String, SelectLocID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
    s qHandle=$lb(0,repid,0)
	
    s LocRowId="",LocDesc=""
    if (rowid'="") {
		//根据rowid返回该条记录
        s LGCID=$o(^CF.PE.LocGrpConfigI("IdxOfLoc"," "_rowid,0))
        q:LGCID="" $$$OK
        s Active=$lg($g(^CF.PE.LocGrpConfigD(LGCID)),5)
        q:Active'="Y" $$$OK
        s LocRowId=$lg($g(^CF.PE.LocGrpConfigD(LGCID)),2) 
        s LocDesc=$p($g(^CTLOC(LocRowId)),"^",2)
        s LocDesc2=$lg($g(^CF.PE.LocGrpConfigD(LGCID)),4)
        s:LocDesc2'="" LocDesc=LocDesc2
        
        //科室组默认科室
        s LGLocId=$lg($g(^CF.PE.LocGrpConfigD(LGCID)),3)
        s LGLocDesc=$p($g(^CTLOC(+LGLocId)),"^",2)
        
        d OutputRowLocCombo
	} else {
        s CurUserID=$P(SessionStr,"^",1)   //当前用户ID
        s CurLocID=$P(SessionStr,"^",3)    //当前登录科室ID
        s CurGroupID=$P(SessionStr,"^",2)  //当前登录安全组ID
        s CurPowerType=..GetUserPower(CurUserID,CurGroupID)   //当前用户&安全组对应权限类型
        
        if (CurPowerType="S"){  //超级权限
        	
            //获取选中科室对应的科室组默认科室ID
			s SelectLGLocID=""
			s:SelectLocID'="" SelectLGLocID=..GetLocGrpByLocID(SelectLocID)
			
			k arrLocList
			s xId=0
			for {
				s xId=$o(^CF.PE.LocGrpConfigD(xId))
				q:xId=""
				
                s LocRowId=$lg($g(^CF.PE.LocGrpConfigD(xId)),2)
                s LocDesc=$p($g(^CTLOC(LocRowId)),"^",2)
		        s LocDesc2=$lg($g(^CF.PE.LocGrpConfigD(xId)),4)
		        s:LocDesc2'="" LocDesc=LocDesc2
		        continue:$zcvt(LocDesc,"U")'[desc
                s Active=$lg($g(^CF.PE.LocGrpConfigD(xId)),5)
                continue:Active'="Y"
                s LGLocID=$lg($g(^CF.PE.LocGrpConfigD(xId)),3)
                continue:(SelectLocID'="")&&(LGLocID'=SelectLGLocID)
                
                s arrLocList(LGLocID,LocRowId)=LocDesc
			}
			
			s tmpCnt=0
			s xLGLocId=0
			for {
				s xLGLocId=$o(arrLocList(xLGLocId))
				q:xLGLocId=""
				
				s tmpCnt=tmpCnt+1
				s tmpChar=$e("ABCDEFGHIJKLMN",tmpCnt,tmpCnt)
				
				s xLocRowId=0
				for {
					s xLocRowId=$o(arrLocList(xLGLocId,xLocRowId))
					q:xLocRowId=""
					
	                s LocRowId=xLocRowId
	                s LocDesc=$g(arrLocList(xLGLocId,xLocRowId))
	                s:SelectLocID="" LocDesc=tmpChar_" "_LocDesc
	                
        			//科室组默认科室
			        s LGLocId=xLGLocId
			        s LGLocDesc=$p($g(^CTLOC(+LGLocId)),"^",2)
		            
					d OutputRowLocCombo
				}
			}
        } elseif (CurPowerType="G"){  //科室组权限
        	
            //获取当前登录科室对应的科室组默认科室ID
            S CurLGLocID=..GetLocGrpByLocID(CurLocID)
            q:CurLGLocID="" $$$OK
            
        	s xId=0
            for {
                s xId=$o(^CF.PE.LocGrpConfigD(xId))
                q:xId=""
                
                s LocRowId=$lg($g(^CF.PE.LocGrpConfigD(xId)),2)
                s LocDesc=$p($g(^CTLOC(LocRowId)),"^",2)
		        s LocDesc2=$lg($g(^CF.PE.LocGrpConfigD(xId)),4)
		        s:LocDesc2'="" LocDesc=LocDesc2
		        continue:$zcvt(LocDesc,"U")'[desc
                s Active=$lg($g(^CF.PE.LocGrpConfigD(xId)),5)
                continue:Active'="Y"
                s LGLocID=$lg($g(^CF.PE.LocGrpConfigD(xId)),3)
                continue:LGLocID'=CurLGLocID
                
        		//科室组默认科室
		        s LGLocId=$lg($g(^CF.PE.LocGrpConfigD(xId)),3)
		        s LGLocDesc=$p($g(^CTLOC(+LGLocId)),"^",2)
                
				d OutputRowLocCombo
            }
        } elseif (CurPowerType="L"){  //科室权限
			
            s LGCID=$O(^CF.PE.LocGrpConfigI("IdxOfLoc"," "_CurLocID,0))
            //q:LGCID="" $$$OK
            //没有维护在科室组表中的科室，直接显示登录科室，否则按照科室组表维护的科室显示
            i LGCID="" {
            s LocRowId=CurLocID
            s LocDesc=$p($g(^CTLOC(LocRowId)),"^",2)
            s LGLocId=LocRowId
            s LGLocDesc=LocDesc
            }
            i (LGCID'="") {
            	s Active=$lg($g(^CF.PE.LocGrpConfigD(LGCID)),5)
            	q:Active'="Y" $$$OK
            	s LocRowId=$lg($g(^CF.PE.LocGrpConfigD(LGCID)),2)
            	s LocDesc=$p($g(^CTLOC(LocRowId)),"^",2)
	        	s LocDesc2=$lg($g(^CF.PE.LocGrpConfigD(LGCID)),4)
	        	s:LocDesc2'="" LocDesc=LocDesc2
	       	 	q:$zcvt(LocDesc,"U")'[desc $$$OK
	       	 	        
        		//科室组默认科室
	        	s LGLocId=$lg($g(^CF.PE.LocGrpConfigD(LGCID)),3)
	        	s LGLocDesc=$p($g(^CTLOC(+LGLocId)),"^",2)
            }
           
		    
		    d OutputRowLocCombo
        }
    }
    
    Quit $$$OK
    
OutputRowLocCombo
	;s LocDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.station.csp",LocDesc)
	;s LGLocDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.station.csp",LGLocDesc)
    s Data=$lb(LocRowId,LocDesc,LGLocId,LGLocDesc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetLocDataForComboFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocDataForComboExecute ]
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

ClassMethod GetLocDataForComboClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocDataForComboExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：    xy 
/// CreatDate：  20210817
/// Description: 判断父子关系表是不是同一个权限分类类型
/// Table：      表记录授权管理表DHC_PE_PowerTableList
/// Input:       tableName : 表名
/// Return：     return=0/1
/// Debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).IsSamePowerType("DHC_HM_CSCQLink")
ClassMethod IsSamePowerType(tableName As %String, dataid As %String = "", Empower As %String = "N") As %String
{
	n (tableName,dataid,Empower)
	s return=0
	q:tableName="" return
	
	s objPowerType=..GetPowerTypeObj(tableName)
	q:'$IsObject(objPowerType) return
    s PowerType=objPowerType.PTPowerType
    s TableListDR=objPowerType.%Id()
    s ParCode=objPowerType.PTParCode  //父表表名或类名
    q:ParCode="" return
    
    s objParPowerType=..GetPowerTypeObj(ParCode)
    q:'$IsObject(objParPowerType) return
    s ParPowerType=objParPowerType.PTPowerType
    q:PowerType'=ParPowerType return
    
     i (PowerType="C")||(PowerType="S") {
    	if ($d(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDR,dataid))||$d(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,dataid)))
   	 	{
	   		i Empower="N"  s return=0 
    	}else{
       		i Empower="N"  s return=1
    	}
    }else{
	    s return=1
    }
    
    q return
}

/*
ClassMethod IsSamePowerType(tableName As %String) As %String
{
	n (tableName)
	s return=0
	q:tableName="" return
	
	s objPowerType=..GetPowerTypeObj(tableName)
	q:'$IsObject(objPowerType) return
    s PowerType=objPowerType.PTPowerType
    s ParCode=objPowerType.PTParCode  //父表表名或类名
    q:ParCode="" return
    
    s objParPowerType=..GetPowerTypeObj(ParCode)
    q:'$IsObject(objParPowerType) return
    s ParPowerType=objParPowerType.PTPowerType
    q:PowerType'=ParPowerType return
    
    s return=1
    q return
}
*/
/// Creator：    zhufei
/// CreatDate：  20210817
/// Description: 保存数据到表记录授权管理表
/// Table：      DHC_PE_PowerControl
/// Input:       aInputStr ：授权信息
/// Return：     return=0/1
/// debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).SavePowerCtl(aInputStr)
ClassMethod SavePowerCtl(aInputStr As %String) As %String
{
	n (aInputStr)
	s return=0
	q:aInputStr="" return
	s ID           = $p(aInputStr,"^",1)   //表名称
	s TableDR      = $p(aInputStr,"^",2)   //表名称
	s RecordID     = $p(aInputStr,"^",3)   //表记录ID
	s LocGrpDR     = $p(aInputStr,"^",4)   //授权科室组/科室组默认科室
	s Empower      = $p(aInputStr,"^",5)   //是否单独授权
	s LocDR        = $p(aInputStr,"^",6)   //授权科室
	s EffPower     = $p(aInputStr,"^",7)   //是否有效授权
	s UpdateDate   = $p(aInputStr,"^",8)   //更新日期
	s UpdateTime   = $p(aInputStr,"^",9)   //更新时间
	s UpdateUserDR = $p(aInputStr,"^",10)  //更新人
	q:(TableDR="")||(RecordID="") return
	q:(LocGrpDR="")&&(LocDR="") return
	
	s:LocGrpDR'="" Empower=$s(Empower["Y":"Y",1:"N")
	s EffPower=$s(EffPower["N":"N",1:"Y")
	s:UpdateDate["-" UpdateDate = $zdh(UpdateDate,3)
	s:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)
	s:UpdateDate="" UpdateDate=+$h
	s:UpdateTime="" UpdateTime=$p($h,",",2)
	
	if (LocGrpDR'=""){
		s (tEffPower,tEmpower,tID)=""
		s tEffPower=$o(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableDR,RecordID,LocGrpDR,""))
		s:tEffPower'="" tEmpower=$o(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableDR,RecordID,LocGrpDR,tEffPower,""))
		s:tEmpower'="" tID=$o(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableDR,RecordID,LocGrpDR,tEffPower,tEmpower,""))
		s:tID'="" ID=tID
	} elseif (LocDR'=""){
		s (tEffPower,tID)=""
		s tEffPower=$o(^CF.PE.PowerControlI("IdxOfLocPower",TableDR,RecordID,LocDR,""))
		s:tEffPower'="" tID=$o(^CF.PE.PowerControlI("IdxOfLocPower",TableDR,RecordID,LocDR,tEffPower,""))
		s:tID'="" ID=tID
	}
	
	if ID="" {
		s obj=##class(User.DHCPEPowerControl).%New()
	}else{
		s obj=##class(User.DHCPEPowerControl).%OpenId(ID)
	}
	q:'$IsObject(obj) return
	
	d obj.PCTableDRSetObjectId(TableDR)
	s obj.PCRecordID	    = RecordID
	s obj.PCLocGrpDR		= LocGrpDR
	s obj.PCEmpower			= Empower
	s obj.PCLocDR		    = LocDR
	s obj.PCEffPower		= EffPower
	s obj.PCUpdateDate		= UpdateDate
	s obj.PCUpdateTime		= UpdateTime
	s obj.PCUpdateUserDR	= UpdateUserDR
	
	s sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		d $system.OBJ.DisplayError(sc)
   		s return=-1
	}else{
		s return=obj.%Id()
	}
	d obj.%Close()
	
	q return
}

/// Creator：    xy
/// CreatDate：  20210730
/// Description: 保存数据到表记录授权管理表DHC_PE_PowerControl
/// Table：      表记录授权管理表DHC_PE_PowerControl
/// Input:       tableName ：表名
///              dataid    ：数据ID
///              LocID     ：科室ID
///              UserID    ：登录用户ID
///              Empower   ：是否单独授权
/// Return：
/// Debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).SaveDataToPowerControl("DHC_PE_ILLSExplain","4","152","12187","N")
ClassMethod SaveDataToPowerControl(tableName As %String, dataid As %String, LocID As %String, UserID As %String, Empower As %String = "N") As %String
{
    n (tableName,dataid,LocID,UserID,Empower)
    s return=1
    q:tableName="" "-1^表名不能为空"
    q:dataid="" "-1^对应表数据RowID不能为空"
    q:LocID="" "-1^科室不能为空"
    
    //根据科室下拉列表获取科室组默认科室ID
    s LocGrpID=..GetLocGrpByLocID(LocID)
    
    //获取表登记信息（数据公有、私有类型）
    s objPowerType=..GetPowerTypeObj(tableName)
    
    q:'$IsObject(objPowerType) return
    s DataTypeFlag=objPowerType.PTPowerType
    s TableListDR=objPowerType.%Id()
    q:DataTypeFlag="G" return
    
    //如果是父子表数据权限类型相同（公/私/管控），只存父表授权记录，不存子表授权数据;
    //如果子表单独授权，则需要插入数据
    s sameflag= ..IsSamePowerType(tableName,dataid,Empower)
    q:sameflag="1" return
    
    if (DataTypeFlag="S"){  //私有数据
    	s aInputStr=""_"^"_TableListDR_"^"_dataid_"^"_LocGrpID_"^"_Empower_"^"_""_"^"_"Y"_"^^^"_UserID
    } elseif (DataTypeFlag="A")||(DataTypeFlag="C") { //绝对私有、管控数据
    	s aInputStr=""_"^"_TableListDR_"^"_dataid_"^"_""_"^"_""_"^"_LocID_"^"_"Y"_"^^^"_UserID
    }
	s return=..SavePowerCtl(aInputStr)
	if (return>0){
    	s return=return_"^添加成功"
    } else {
		s return="-1^添加失败"
	}
	
    q return
}

/// Creator：    xy
/// CreatDate：  20210730
/// Description: 私有数据授权、管控数据授权到表记录授权管理表
/// Table：      DHC_PE_PowerControl
/// Input:       tableName : 表名
///              dataid    : 数据ID
///              LocIDStr  : 授权科室1,Y^授权科室2,Y^未授权科室3,N
///              UserID    : 登录用户ID
/// Return：     
/// debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).SaveSDataToPowerControl("DHC_PE_EDClass","51","152,Y^539,Y^1,N","12187")
ClassMethod SaveSDataToPowerControl(tableName As %String, dataid As %String, LocIDStr As %String, UserID As %String) As %String
{
    n (tableName,dataid,LocIDStr,UserID)
    s return=-1
    //q:(tableName="")||(LocIDStr="")||(dataid="") return
    q:tableName="" "-1^表名不能为空"
    q:dataid="" "-1^对应表数据RowID不能为空"
    q:LocIDStr="" "-1^授权科室不能为空"
    q:UserID="" "-1^登录用户不能为空"
    
    s $ZT="SaveSDataToPowerControlErr"
    
    //获取表登记信息（数据公有、私有类型）
    s objPowerType=..GetPowerTypeObj(tableName)
    q:'$IsObject(objPowerType) return
    s DataTypeFlag=objPowerType.PTPowerType
    s TableListDR=objPowerType.%Id()
    
    s return=0
    for num=1:1:$length(LocIDStr,"^") {
	    s LocIDArr=$p(LocIDStr,"^",num)
        s LocID=$p(LocIDArr,",",1)
        s LocCheckFlag=$p(LocIDArr,",",2)  //是否有效授权
        s aInputStr=""_"^"_TableListDR_"^"_dataid_"^"_""_"^"_"Y"_"^"_LocID_"^"_LocCheckFlag_"^^^"_UserID
        s flg=..SavePowerCtl(aInputStr)
	    s:flg<1 return=-1
	}
	q:return<0 return
	
    s return="0^授权成功"
    q return
    
SaveSDataToPowerControlErr
    s $ZT=""
    q return_"^"_$ZError
}

/// Creator：    xy 
/// CreatDate：  20210806
/// Description: 判断数据是否是单独授权？？？？
/// Table：      表记录授权表 User.DHCPEPowerControl
/// Input:       tableName : 表名
///              DataId    : 数据ID
///              LocID     : 科室ID
/// Return：     return=Y/N
/// debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).GetEmpowerFlag("DHC_PE_ODStandard","1||32||2","1")
ClassMethod GetEmpowerFlag(tableName As %String, DataId As %String, LocID As %String) As %String
{
    n (tableName,DataId,LocID)
    s return="N"
    q:tableName="" return
    
    //获取表登记信息（数据公有、私有类型）
    s objPowerType=..GetPowerTypeObj(tableName)
    q:'$IsObject(objPowerType) return
    s PowerType=objPowerType.PTPowerType
    s TableListDR=objPowerType.%Id()
    
    s LocDescStr="",Empower="N"
    if (PowerType="S"){  //私有数据
    	
        //根据科室下拉列表获取科室组默认ID
        s LocGrpID=..GetLocGrpByLocID(LocID)
        q:LocGrpID="" return
        
        if $d(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDR,DataId,LocGrpID,"Y","Y")) {
	        s Empower="Y"
	        
	        s xLocDR=0
	        for {
		        s xLocDR=$o(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,DataId,xLocDR))
		        q:xLocDR=""
		        
		        s PCRowid=$o(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,DataId,xLocDR,"Y",0))
		        continue:PCRowid=""
		        
		        s LocDR=$listget($g(^CF.PE.PowerControlD(PCRowid)),6)
	            s tLGLocID=$listget($g(^CF.PE.PowerControlD(PCRowid)),4)
	            //continue:(LocGrpID'=tLGLocID)
	            s LocDesc=$p($g(^CTLOC(LocDR)),"^",2)
	            if LocDescStr="" {
		            s LocDescStr=LocDesc
	            } else {
	            	s LocDescStr=LocDescStr_","_LocDesc
	            }
		    }
        }
    }elseif(PowerType="C") { //管控数据
    	
        //根据索引判断是否存在登录科室LocID的关联数据
        if $d(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,DataId,LocID,"Y")){
	        s Empower="Y"
        }
        s xLocDR=0
        for {
	        s xLocDR=$o(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,DataId,xLocDR))
	        q:xLocDR=""
	        
	        s PCRowid=$o(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,DataId,xLocDR,"Y",0))
	        continue:PCRowid=""
	        
	        s LocDR=$listget($g(^CF.PE.PowerControlD(PCRowid)),6)
            s tLGLocID=$listget($g(^CF.PE.PowerControlD(PCRowid)),4)
            //continue:(LocGrpID'=tLGLocID)
            s LocDesc=$p($g(^CTLOC(LocDR)),"^",2)
            if LocDescStr="" {
	            s LocDescStr=LocDesc
            } else {
            	s LocDescStr=LocDescStr_","_LocDesc
            }
	    }
    }
    
    q Empower_"^"_LocDescStr
}

/// Description: 获取私有/管控数据的授权
/// Table：表记录授权表 DHCPEPowerControl
/// Input:  tableName(表名),dataid（记录授权数据ID）,LocID(科室ID)
/// Return：     
/// Creator：xy 
/// CreatDate：20210805
/// Debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).GetSDataPowerControl("DHC_PE_EDClass","80","539")
ClassMethod GetSDataPowerControl(tableName As %String, dataid As %String, LocID As %String)
{
    s ^tempdhcpe("GetSDataPowerControl")=$lb(tableName, dataid, LocID)
    s EffPowerFlag="N"
    //获取数据公有、私有类型
    s DataTypeFlag=##class(web.DHCPE.CT.DHCPEMappingLoc).GetPowerType(tableName)
    s tableName=$zcvt(tableName,"U")
    s TableListDR=$o(^CT.PE.PowerTableListI("IdxOfCode"," "_tableName,0))
    
    if (DataTypeFlag="S") {
        q:$d(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,dataid,LocID,"N")) "N"
        s PowerConID=$o(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,dataid,LocID,"Y",0))
        q:PowerConID="" "N"
        s Empower=$listget($g(^CF.PE.PowerControlD(PowerConID)),5) 
        i Empower="Y"  S EffPowerFlag="Y"     
        
    }elseif(DataTypeFlag="C"){
	    q:'$d(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,dataid,LocID)) "N"  
        q:$d(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,dataid,LocID,"N")) "N"
        s PowerConID=$o(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,dataid,LocID,"Y",0))
        q:PowerConID="" "N"
        s Empower=$listget($g(^CF.PE.PowerControlD(PowerConID)),5) 
        i Empower="Y"  S EffPowerFlag="Y"   
    }
    
     q EffPowerFlag
}

/// Creator:	 wangguoying
/// CreateDate:	 2021-08-16
/// Description: 是否存在授权记录
/// Input:   
/// TableDR：    表名
/// RecordDR：   记录ID
/// Return:		 0 不存在  1 存在
/// Debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).ExistPowerCtrl(1)
ClassMethod ExistPowerCtrl(TableDR, RecordDR)
{
	q:'$D(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableDR,RecordDR)) 0
	q 1
}

/// Creator：    xy
/// CreatDate：  20221115
/// Description: 删除表记录授权表相关数据
/// Input:       ClassCode      : 类名
///              aId            : 待删除数据ID
///              LocID          : 科室ID
/// Return：     0/1(删除成功/删除失败)
/// Debug:w ##class(web.DHCPE.CT.DHCPEMappingLoc).DeletePowerControl()
ClassMethod DeletePowerControl(ClassCode, aId, LocID)
{
    
     Set return="0"
     
    //获取表登记信息（数据公有、私有类型）
    s TableListDr=$o(^CT.PE.PowerTableListI("IdxOfClsCode"," "_$zcvt(ClassCode,"U"),0))  //类名
    q:TableListDr="" ""  //未维护权限的表都当做公有数据
    s DataTypeFlag=$lg($g(^CT.PE.PowerTableListD(TableListDr)),4)  //数据类型
    
    if (DataTypeFlag="S") { //私有数据
        Set LGLocID=""
        Set LGLocDR=$o(^CF.PE.LocGrpConfigI("IdxOfLoc"," "_LocID,0))
        Set:LGLocDR'="" LGLocID=$listget($g(^CF.PE.LocGrpConfigD(LGLocDR)),3) //科室组ID
        Quit:LGLocID="" return
        
        //判断是否本科室组LGLocID的授权数据
        Quit:'$d(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDr,aId,LGLocID,"Y")) return
        
        //没单独授权
         if $d(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDr,aId,LGLocID,"Y","N")) {
          
            Set ID=$O(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDr,aId,LGLocID,"Y","N",0))
            &SQL(delete from sqluser.DHC_PE_PowerControl where ID=:ID)  //删除表记录授权表数据
            if SQLCODE'=0 Set return=1      
        
        }
        
        //单独授权
        if $d(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDr,aId,LGLocID,"Y","Y")) {
          
            Set ID=$O(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDr,aId,LGLocID,"Y","Y",0))
            &SQL(delete from sqluser.DHC_PE_PowerControl where ID=:ID)  //删除表记录授权表数据
            if SQLCODE'=0 Set return=1 
        
            Set locid=""
            for {
                Set locid=$o(^CF.PE.LocGrpConfigI("IdxOfLocGrp"," "_LGLocDR,locid))
                Quit:locid=""
                Set ID=""
                for{
                    Set ID=$O(^CF.PE.PowerControlI("IdxOfLocPower",TableListDr,aId,locid,ID))
                    Quit:ID=""
                    &SQL(delete from sqluser.DHC_PE_PowerControl where ID=:ID)  //删除表记录授权表数据
                    if SQLCODE'=0 Set return=1 
                }
             
            }
        }
	}ElseIf (DataTypeFlag="A") { //绝对私有
        Set ID=$O(^CF.PE.PowerControlI("IdxOfLocPower",TableListDr,aId,LocID,"Y",0))
        if (ID'="" ){
            &SQL(delete from sqluser.DHC_PE_PowerControl where ID=:ID)  //删除表记录授权表数据
            if SQLCODE'=0 Set return=1 
            
        }
}

   Quit return
}

/// Creator:	 xy
/// CreateDate:	 2021-08-28
/// Description: 获取医院下拉列表
/// Debug: w ##class(%ResultSet).RunQuery("web.DHCPE.CT.DHCPEMappingLoc","GetHospDataForCombo")
Query GetHospDataForCombo() As websys.Query(ROWSPEC = "HOSPRowId,HOSPDesc")
{
}

ClassMethod GetHospDataForComboExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    i $g(ind)="" s ind=1 
    s RowId=0
    f  s RowId=$o(^CT("HOSP",RowId))  q:RowId=""  d
    .s HOSPDateTo=$p($g(^CT("HOSP",RowId)),"^",10)
    .q:(HOSPDateTo'="")&&(HOSPDateTo<+$h)
	.s HOSPDesc=$p($g(^CT("HOSP",RowId)),"^",2)
	.s ^CacheTemp(repid,ind)=$lb(RowId,HOSPDesc)
    .s ind=ind+1 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Creator:	 xy
/// CreateDate:	 2021-10-13
/// Description: 根据科室获取院区ID
/// Debug: w ##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID()
ClassMethod GetHospIDByLocID(LocID As %String = "")
{
	q:LocID="" ""
	q $p($g(^CTLOC(LocID)),"^",22)
}

}
