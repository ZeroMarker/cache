Import SQLUser

Class web.DHCBL.CT.PACRoom Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "PAC_Room";

/// Function:床位维护 获取grid列表
/// Creator:基础数据平台组  
/// Table:PAC_Room 
/// Input:RowId,code ,desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACRoom", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "ROOMRowID:%String,ROOMCode:%String,ROOMDesc:%String,ROOMRoomTypeDR:%String,ROOMDifferentSexPatients:%String,ROOMQuery:%String,ROOMNoOfRows:%String,ROOMDateFrom:%String,ROOMDateTo:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String,ROOMFloorDR:%String")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.PACRoom).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="")  
	{
		s ROOMRowID=rowid
		s ROOMCode=$p($g(^PAROOM(ROOMRowID)),"^",1)
		s ROOMDesc=$p($g(^PAROOM(ROOMRowID)),"^",2)
		s ROOMRoomTypeDR=$p($g(^PAROOM(ROOMRowID)),"^",3)
		s:ROOMRoomTypeDR'="" ROOMRoomTypeDR=$p($g(^PAC("ROOMT",ROOMRoomTypeDR)),"^",2)
	    s ROOMDifferentSexPatients=$p($g(^PAROOM(ROOMRowID)),"^",4)
	    
		s ROOMQuery=$p($g(^PAROOM(ROOMRowID)),"^",5)
		s ROOMNoOfRows=$p($g(^PAROOM(ROOMRowID)),"^",6)
		s ROOMDateFrom=$p($g(^PAROOM(ROOMRowID)),"^",8)
		s ROOMDateTo=$p($g(^PAROOM(ROOMRowID)),"^",9)
		s:ROOMDateFrom'="" ROOMDateFrom=$zd(ROOMDateFrom,1)
		s:ROOMDateTo'="" ROOMDateTo=$zd(ROOMDateTo,1)
		//楼层
		s ROOMFloorDR=$p($g(^PAROOM(ROOMRowID)),"^",11)
		if (ROOMFloorDR'="")
		{
			s CTLBFParRef=$p(ROOMFloorDR,"||",1)
			s CTLBFChildsub=$p(ROOMFloorDR,"||",2)
			s CTLBDesc=$p($g(^CT("CTLB",CTLBFParRef)),"^",2)	//医院楼描述
			s ROOMFloorDR=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",1)  //楼层
			s ROOMFloorDR=CTLBDesc_"-"_ROOMFloorDR
		}
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
    	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_Room",ROOMRowID)
    	s BDPInternalCode =$p($g(resultStr),"^",1)       
    	s BDPInternalDesc = $p($g(resultStr),"^",2)  
    	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
    	s BDPHospNationalDesc = $p($g(resultStr),"^",4)
 		s:ROOMCode'="" Bcode=$ZCONVERT(ROOMCode,"U")
		s:ROOMDesc'="" Bdesc=$ZCONVERT(ROOMDesc,"U")
	 	d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s ROOMRowID=0
		for  
		{	
			s ROOMRowID=$o(^PAROOM(ROOMRowID)) q:ROOMRowID=""
			
			s strRowId = "{ID:"_ROOMRowID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ROOMRowID,hospid)
	  			continue:showflag="N"
	  			
				s ROOMCode=$p($g(^PAROOM(ROOMRowID)),"^",1)
				s ROOMDesc=$p($g(^PAROOM(ROOMRowID)),"^",2)
				s ROOMRoomTypeDR=$p($g(^PAROOM(ROOMRowID)),"^",3)
			 	s:ROOMRoomTypeDR'="" ROOMRoomTypeDR=$p($g(^PAC("ROOMT",ROOMRoomTypeDR)),"^",2)   
		   		s ROOMDifferentSexPatients=$p($g(^PAROOM(ROOMRowID)),"^",4)
	    
				s ROOMQuery=$p($g(^PAROOM(ROOMRowID)),"^",5)
				s ROOMNoOfRows=$p($g(^PAROOM(ROOMRowID)),"^",6)
				s ROOMDateFrom=$p($g(^PAROOM(ROOMRowID)),"^",8)
				s ROOMDateTo=$p($g(^PAROOM(ROOMRowID)),"^",9)
				s:ROOMDateFrom'="" ROOMDateFrom=$zd(ROOMDateFrom,1)
				s:ROOMDateTo'="" ROOMDateTo=$zd(ROOMDateTo,1)
				//楼层
				s ROOMFloorDR=$p($g(^PAROOM(ROOMRowID)),"^",11)
				if (ROOMFloorDR'="")
				{
					s CTLBFParRef=$p(ROOMFloorDR,"||",1)
					s CTLBFChildsub=$p(ROOMFloorDR,"||",2)
					s CTLBDesc=$p($g(^CT("CTLB",CTLBFParRef)),"^",2)	//医院楼描述
					s ROOMFloorDR=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",1)  //楼层
					s ROOMFloorDR=CTLBDesc_"-"_ROOMFloorDR
				}
		 		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
            	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_Room",ROOMRowID)
            	s BDPInternalCode =$p($g(resultStr),"^",1)       
            	s BDPInternalDesc = $p($g(resultStr),"^",2)  
            	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
            	s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		 		s:ROOMCode'="" Bcode=$ZCONVERT(ROOMCode,"U")
				s:ROOMDesc'="" Bdesc=$ZCONVERT(ROOMDesc,"U")
				/*
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_Room",ROOMRowID,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Bdesc)
				*/
				if (desc'="")
		       {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_Room",ROOMRowID,ROOMDesc,desc)
		       }
			   	else
		       {
		         	s AliasFlag= 1   
		       } 
				i (Bcode[code)&(AliasFlag=1)
				/*((Bdesc[desc)||(PINYIN[desc)||(ALIASText1[desc))*/
				{
					d OutputRow
				}
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ROOMRowID,ROOMCode,ROOMDesc,ROOMRoomTypeDR,ROOMDifferentSexPatients,ROOMQuery,ROOMNoOfRows,ROOMDateFrom,ROOMDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,ROOMFloorDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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

/// Function:进行数据检索，为combo查询提供接口
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组  sunfengchao
/// Table:PAC_Room 
/// Input: rowid, code 
/// Output:   
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACRoom", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "ROOMRowID:%String,ROOMCode:%String,ROOMDesc:%String")
{
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1  
	
   //获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.PACRoom).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	if (rowid'="")  
	{
		s ROOMRowID = rowid
		s ROOMDesc=$p($g(^PAROOM(ROOMRowID)),"^",2)
	 	d OutputRow1
	}
	else 
	{
		s ROOMRowID=0
		for  
		{	
			s ROOMRowID=$o(^PAROOM(ROOMRowID)) q:ROOMRowID=""
			s strRowId = "{ID:"_ROOMRowID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ROOMRowID,hospid)
	 			continue:showflag="N"
	 			
				s ROOMCode=$p($g(^PAROOM(ROOMRowID)),"^",1)
				s ROOMDesc=$p($g(^PAROOM(ROOMRowID)),"^",2)
				s ROOMRoomTypeDR=$p($g(^PAROOM(ROOMRowID)),"^",3)
			 	s:ROOMRoomTypeDR'="" ROOMRoomTypeDR=$p($g(^PAC("ROOMT",ROOMRoomTypeDR)),"^",2)   
		   		s ROOMDifferentSexPatients=$p($g(^PAROOM(ROOMRowID)),"^",4)
    
				s ROOMQuery=$p($g(^PAROOM(ROOMRowID)),"^",5)
				s ROOMNoOfRows=$p($g(^PAROOM(ROOMRowID)),"^",6)
				s ROOMDateFrom=$p($g(^PAROOM(ROOMRowID)),"^",8)
				s ROOMDateTo=$p($g(^PAROOM(ROOMRowID)),"^",9)
				continue:(ROOMDateFrom'="")&&(ROOMDateFrom>+$h)
				continue:(ROOMDateTo'="")&&(ROOMDateTo<+$h)
				s:ROOMDateFrom'="" ROOMDateFrom=$zd(ROOMDateFrom,1)
				s:ROOMDateTo'="" ROOMDateTo=$zd(ROOMDateTo,1)	
				
				
				s:ROOMCode'="" Bcode=$ZCONVERT(ROOMCode,"U")
				s:ROOMDesc'="" Bdesc=$ZCONVERT(ROOMDesc,"U")
				/*
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_Room",ROOMRowID,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Bdesc)
				*/
				if (desc'="")
		       {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_Room",ROOMRowID,ROOMDesc,desc)
		       }
			   	else
		       {
		         	s AliasFlag= 1   
		       } 
				i (Bcode[code)&(AliasFlag=1)
				/*((Bdesc[desc)||(PINYIN[desc)||(ALIASText1[desc)*/
				{
					d OutputRow1
				}
			}
		}
	}		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1   
	set Data=$lb(ROOMRowID,ROOMCode,ROOMDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:蔡昊哲
/// CreatDate:2013-8-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	
	i $d(^PAWARD("BED_Room_DR",+id)) s myInfo=myInfo_"<床位表>"  ;原索引CTLocationListLocations    ; PACBED
	i $d(^PAWARD(0,"BED_Room_DR",+id)) s myInfo=myInfo_"<床位表>"  ;CTLocationListLocations    ; PACBED
	
	s found1=0
	S WARDRowID=0
	f  s WARDRowID=$o(^PAWARD(WARDRowID)) q:WARDRowID=""  d
	.i $d(^PAWARD(WARDRowID,"ROOM",0,"Room",+id)) s found1=0
	i (found1) s myInfo=myInfo_"<病区房间表>"  ;CTLocationListLocations 
	  
    
    		
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
 	q return
}

/// Function:实现对房间 的删除操作
/// Creator: 基础数据平台组 sunfengchao
/// CreateDate:2012-08-30
/// Desc:通过rowid来删除房间 
/// Input: rowid
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: PAC_Room 
/// Others:do ##class(web.DHCBL.CT.PACRoom).DeleteData("")
ClassMethod DeleteData(id) As %String
{
	s result=""
	
	s re=##class(web.DHCBL.CT.PACRoom).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		s pobj = ##class(User.PACRoom).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PACRoom).%New()
		s eobj.ROOMRowID = id
		s eobj.ROOMCode = pobj.ROOMCode
		s eobj.ROOMDesc = pobj.ROOMDesc
		s:pobj.ROOMRoomTypeDR'="" eobj.ROOMRoomTypeDR = pobj.ROOMRoomTypeDR
		s eobj.ROOMDifferentSexPatients = pobj.ROOMDifferentSexPatients
		s eobj.ROOMQuery=pobj.ROOMQuery
		s eobj.ROOMNoOfRows=pobj.ROOMNoOfRows
		s:pobj.ROOMFloorDR'="" eobj.ROOMFloorDR = pobj.ROOMFloorDR.%Id()
	
		s sc=##class(User.PACRoom).%DeleteId(id)
		IF $$$ISOK(sc){
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Room","User.PACRoom","房间",id,eobj.ROOMDesc,"D",eobj)
			s result="{success:'true',info:'删除成功！'}"
		}
		else{
			//s result= "{success:'false',info:'删除失败！'}"
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("房间","web.DHCBL.CT.PACRoom","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Function:双击时显示弹出窗口的信息
/// CreateDate:2012-08-30
/// Input:输入 id
/// Tables: PAC_Room
/// Others:do ##class(web.DHCBL.CT.PACRoom).OpenData("")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.PACRoom).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PACRoom).%New()
	s eobj.ROOMRowID=id
	s eobj.ROOMCode = pobj.ROOMCode
	s eobj.ROOMDesc = pobj.ROOMDesc
	s:pobj.ROOMRoomTypeDR'="" eobj.ROOMRoomTypeDR = pobj.ROOMRoomTypeDR.%Id()
	s eobj.ROOMDifferentSexPatients = pobj.ROOMDifferentSexPatients
	s eobj.ROOMQuery=pobj.ROOMQuery
	s eobj.ROOMNoOfRows=pobj.ROOMNoOfRows
	s:pobj.ROOMFloorDR'="" eobj.ROOMFloorDR = pobj.ROOMFloorDR.%Id()
	;s:pobj.ROOMDateFrom'="" eobj.ROOMDateFrom = $zd(pobj.ROOMDateFrom,1)
	;s:pobj.ROOMDateTo'="" eobj.ROOMDateTo = $zd(pobj.ROOMDateTo,1)
	s:pobj.ROOMDateFrom'="" eobj.ROOMDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ROOMDateFrom)
	s:pobj.ROOMDateTo'="" eobj.ROOMDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ROOMDateTo)
    d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 蔡昊哲 
/// CreateDate:2013-1-16    
/// d ##class(web.DHCBL.CT.PACRoom).Validate("","","")
ClassMethod Validate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
    if $ZCONVERT(code,"U")'=""
    {
        s idc=0
        for
        {
            s idc=$o(^PAROOM(0,"ROOM_Code",$ZCONVERT(code,"U"),idc)) q:idc=""
            if (idc'=id)
            {
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
				continue:showflag="N"
				s flag=1
            }
        }
    }
    
    if $ZCONVERT(desc,"U")'=""
    {
        s idd=0
        for
        {
    
            s idd=$o(^PAROOM(0,"ROOM_Desc",$ZCONVERT(desc,"U"),idd)) q:idd=""
            if (idd'=id)
            {
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
				continue:showflag="N"
				s flag=1
            }
        }
    }
    q flag
}

/// Creator：基础数据平台组 
/// CreatDate: 2013-1-23
/// Description：保存修改房屋内容
/// Table：PAC_BedType
ClassMethod SaveEntity(eobj As web.Entity.CT.PACRoom) As %String
{
   
	//s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{ 
		s flag=..Validate(eobj.ROOMRowID,eobj.ROOMCode,eobj.ROOMDesc,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			;s:eobj.ROOMDateFrom'="" eobj.ROOMDateFrom=$zdh(eobj.ROOMDateFrom,15)  //转换日期
			;s:eobj.ROOMDateTo'="" eobj.ROOMDateTo=$zdh(eobj.ROOMDateTo,15)      //转换日期
			s:eobj.ROOMDateFrom'="" eobj.ROOMDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ROOMDateFrom)  //转换日期
			s:eobj.ROOMDateTo'="" eobj.ROOMDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ROOMDateTo)      //转换日期
			s:eobj.ROOMDateFrom="" eobj.ROOMDateFrom=+$h
			if (eobj.ROOMRowID="")  //如果RowId未赋值则增加
			{
		        	s obj=##class(User.PACRoom).%New()	
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.PACRoom).%OpenId(eobj.ROOMRowID)
				s bobj=##class(web.Entity.CT.PACRoom).%New()
				s bobj.ROOMRowID=eobj.ROOMRowID
				s bobj.ROOMCode = obj.ROOMCode
				s bobj.ROOMDesc = obj.ROOMDesc
				s:obj.ROOMRoomTypeDR'="" bobj.ROOMRoomTypeDR = obj.ROOMRoomTypeDR.%Id()
				s bobj.ROOMDifferentSexPatients=obj.ROOMDifferentSexPatients
				s bobj.ROOMQuery=obj.ROOMQuery
				s bobj.ROOMNoOfRows=obj.ROOMNoOfRows
				s bobj.ROOMDateFrom=obj.ROOMDateFrom
				s bobj.ROOMDateTo=obj.ROOMDateTo
				s:obj.ROOMFloorDR'="" bobj.ROOMFloorDR = obj.ROOMFloorDR.%Id()
			}
        	Ts    
        	s obj.ROOMCode = eobj.ROOMCode
			s obj.ROOMDesc = eobj.ROOMDesc    	 	 
  	 		if (eobj.ROOMRoomTypeDR'="")
  	 		{
	  	 		d obj.ROOMRoomTypeDRSetObjectId(eobj.ROOMRoomTypeDR) 
			}
			else
			{
				s obj.ROOMRoomTypeDR=""
			}
       		s obj.ROOMDifferentSexPatients=eobj.ROOMDifferentSexPatients
			;s:eobj.ROOMDifferentSexPatients="Does Not Matter" obj.ROOMDifferentSexPatients="D"
			;s:eobj.ROOMDifferentSexPatients="Warning" obj.ROOMDifferentSexPatients="W"
			;s:eobj.ROOMDifferentSexPatients="Not Allowed" obj.ROOMDifferentSexPatients="N"
			s obj.ROOMQuery=eobj.ROOMQuery
			s obj.ROOMNoOfRows=eobj.ROOMNoOfRows
			s obj.ROOMDateFrom=eobj.ROOMDateFrom
			s obj.ROOMDateTo=eobj.ROOMDateTo
			d obj.ROOMFloorDRSetObjectId(eobj.ROOMFloorDR) 
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				d:eobj.ROOMRowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Room","User.PACRoom","房间",id,obj.ROOMDesc,"A",eobj)
				d:eobj.ROOMRowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Room","User.PACRoom","房间",eobj.ROOMRowID,obj.ROOMDesc,"U",eobj,bobj)
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("房间","web.DHCBL.CT.PACRoom","SaveEntity",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
			}			
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
	;ERROE
	;q "{success:'false',errorinfo:'保存失败！'}"
}

}
