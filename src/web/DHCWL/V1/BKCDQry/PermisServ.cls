Class web.DHCWL.V1.BKCDQry.PermisServ Extends %RegisteredObject
{

ClassMethod GetRptByDevTool(devTool As %String, searchV As %String, page As %Integer, rows As %Integer)
{

		s start=((page-1)*rows)
		s limit=rows
		s qryName="%DynamicQuery:SQL"  //固定写法
		s end=start+limit
		s start=start+1

		//上面是固定写法 
		//////////////////////////////////////////
		s jsonPro="ID,Name,Code,Descript,Creator"
		if devTool="bdq" {	//基础数据查询
			s sql="SELECT * FROM (SELECT ID,Name,Code,Descript,t2.SSUSR_Name As Creator, ID||Code||Name||Descript||t2.SSUSR_Name AS allInOne FROM DHCWL_BaseDataQuery.Rpt t1,SS_User t2 WHERE t1.Creator=t2.SSUSR_RowId  and Code <> 'tempSysRpt')"
			if searchV'="" {
				s sql=sql_" WHERE allInOne LIKE '%"_searchV_"%'"	
				
			}
		}elseif devTool="cdq" {	//简单数据查询
			s sql="SELECT * FROM (SELECT ID,RptName AS Name, Code, Descript, UserDr->SSUSR_Name As Creator , ID||ISNULL(Code,'')||ISNULL(RptName,'')||ISNULL(Descript,'')||ISNULL(UserDr->SSUSR_Name,'') AS allInOne "
			s sql=sql_" FROM DHCWL_CommonDataQry.RptCfg )"
			if searchV'="" {
				s sql=sql_" WHERE allInOne LIKE '%"_searchV_"%'	"
			}
		}elseif devTool="kdq" {	//指标数据查询
			
			
		}
				
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
		
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		
		i json.GetCount()=0 w "]}"
		q 1
}

ClassMethod GetGrp(searchV As %String, page As %Integer, rows As %Integer)
{
		if 1 {
			s start=((page-1)*rows)
			s limit=rows
			s end=start+limit
			s start=start+1
		}else{
			s start=0
			s limit=rows
			s end=0
			s start=0		
		}

		s qryName="%DynamicQuery:SQL"  //固定写法

		//上面是固定写法 
		//////////////////////////////////////////
		s jsonPro="ID,Name,Code,Descript"

		s sql="SELECT * FROM (SELECT ID,Name,Code,Descript, ID||Code||Name||Descript AS allInOne FROM DHCWL_PerMis.Grp)"
		if searchV'="" {
			s sql=sql_" WHERE allInOne LIKE '%"_searchV_"%'"	
			
		}
		
		//w !,sql
				
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
		
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		
		i json.GetCount()=0 w "]}"
		q 1
}

ClassMethod InsertGrp(Name As %String, Code As %Integer, Descript As %Integer)
{
	s inParam("Name")=Name
	s inParam("Code")=Code
	s inParam("Descript")=Descript
	
	s ret=##class(DHCWL.PerMis.Grp).Insert(.inParam)
	if ret'="" {
		w "{""msg"":"""_ret_""",""success"":""0""}"
	}else{
		w "{""msg"":"""_ret_""",""success"":""1""}"
	}
	
	q 1
}

ClassMethod delGrp(ID As %String)
{
	s inParam("ID")=ID
	s ret=##class(DHCWL.PerMis.Grp).DelByID(.inParam)
	if ret'="" {
		w "{""msg"":"""_ret_""",""success"":""0""}"
	}else{
		w "{""msg"":"""_ret_""",""success"":""1""}"
	}
	
	q 1
}

ClassMethod updateGrp(ID As %String, Name As %String, Descript As %String) As %String
{
	s inParam("ID")=ID
	s inParam("Name")=Name
	s inParam("Descript")=Descript
	s ret=##class(DHCWL.PerMis.Grp).Update(.inParam)
	if ret'="" {
		w "{""msg"":"""_ret_""",""success"":""0""}"
	}else{
		w "{""msg"":"""_ret_""",""success"":""1""}"
	}
	
	q 1
}

ClassMethod getUnMapGrp(rptTool As %String, rptID As %String, searchV As %String, page As %Integer, rows As %Integer)
{
	
		if 0 {
			s start=((page-1)*rows)
			s limit=rows
			s end=start+limit
			s start=start+1
		}else{
			s start=0
			s end=0
			s start=0	
			s page=1	
		}

		s qryName="%DynamicQuery:SQL"  //固定写法

		//上面是固定写法 
		//////////////////////////////////////////
		s jsonPro="ID,Name,Code,Descript"

		s sql="SELECT * FROM (SELECT ID,Name,Code,Descript,Code||Descript||Name AS allInOne FROM DHCWL_PerMis.Grp) "
		s sql=sql_"WHERE ID NOT IN (SELECT GrpDr FROM DHCWL_PerMis.RGMap WHERE RptTool='"_rptTool_"' AND RptID='"_rptID_"') "

		if searchV'="" {
			s sql=sql_" AND allInOne LIKE '%"_searchV_"%'" 	
		}

		//w !,sql		
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
		
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		
		i json.GetCount()=0 w "]}"
		q 1
}

ClassMethod insertRGMap(rptID As %String, grpIDs As %String, rptTool As %String) As %String
{
	s inParam("rptID")=rptID
	s inParam("grpIDs")=grpIDs
	s inParam("rptTool")=rptTool
	TSTART
	s ret=##class(DHCWL.PerMis.RGMap).Insert(.inParam,.outParam)
	if ret'="" {
		w "{""msg"":"""_ret_""",""success"":""0""}"
		TROLLBACK
	}else{
		w "{""msg"":"""_ret_""",""success"":""1""}"
	}
	TCOMMIT
	q 1
}

ClassMethod delRGMap(ID As %String)
{
	s inParam("ID")=ID
	s ret=##class(DHCWL.PerMis.RGMap).DelByID(.inParam)
	if ret'="" {
		w "{""msg"":"""_ret_""",""success"":""0""}"
	}else{
		w "{""msg"":"""_ret_""",""success"":""1""}"
	}
	
	q 1
}

ClassMethod GetMapedGrp(rptTool As %String, rptID As %String, searchV As %String, page As %Integer, rows As %Integer) As %String
{
		if 1 {
			s start=((page-1)*rows)
			s limit=rows
			s end=start+limit
			s start=start+1
		}else{
			s start=0
			s end=0
			s start=0	
			s page=1	
		}

		s qryName="%DynamicQuery:SQL"  //固定写法

		//上面是固定写法 
		//////////////////////////////////////////
		s jsonPro="ID,GrpID,Code,Descript,Name"

		//s sql="SELECT ID,GrpDr->ID As GrpID,GrpDr->Code,GrpDr->Descript,GrpDr->Name,GrpDr->Code||GrpDr->Descript||GrpDr->Name AS allInOne "
		//s sql=sql_"FROM DHCWL_PerMis.RGMap WHERE RptID='"_rptID_"' AND RptTool='"_rptTool_"'"
		s sql="SELECT * FROM (SELECT ID,GrpDr->ID As GrpID,GrpDr->Code,GrpDr->Descript,GrpDr->Name,GrpDr->Code||GrpDr->Descript||GrpDr->Name "
		s sql=sql_"AS allInOne FROM DHCWL_PerMis.RGMap WHERE RptID="_rptID_" AND RptTool='"_rptTool_"')"
		if searchV'="" {
			s sql=sql_" where allInOne LIKE '%"_searchV_"%'" 	
		}

		//w !,sql		
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
		
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		
		i json.GetCount()=0 w "]}"
		q 1
}

ClassMethod getUnMapMember(grpID As %String, searchV As %String, page As %Integer, rows As %Integer) As %String
{
		if 1 {
			s start=((page-1)*rows)
			s limit=rows
			s end=start+limit
			s start=start+1
		}else{
			s start=0
			s end=0
			s start=0	
			s page=1	
		}

		s qryName="%DynamicQuery:SQL"  //固定写法

		//上面是固定写法 
		//////////////////////////////////////////
		s jsonPro="SSUSR_RowId,SSUSR_Name,CTLOC_Desc,CTCPT_Desc,SSGRP_Desc"
		
		s sql="SELECT * FROM (SELECT SSUSR_RowId, SSUSR_Name, SSUSR_DefaultDept_DR->CTLOC_Desc, SSUSR_CareProv_DR->CTPCP_CarPrvTp_DR->CTCPT_Desc,SSUSR_Group->SSGRP_Desc,"
		s sql=sql_"SSUSR_RowId||SSUSR_Name||ISNULL(SSUSR_DefaultDept_DR->CTLOC_Desc,'')||ISNULL(SSUSR_CareProv_DR->CTPCP_CarPrvTp_DR->CTCPT_Desc,'')||ISNULL(SSUSR_Group->SSGRP_Desc,'') AS allInOne FROM ss_user)"
		s sql=sql_"WHERE SSUSR_RowId NOT IN (SELECT userDr FROM DHCWL_PerMis.GMMAP WHERE GrpDr='"_grpID_"')"
		if searchV'="" {
			s sql=sql_" AND allInOne LIKE '%"_searchV_"%'" 	
		}

		//w !,sql		
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
		
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		
		i json.GetCount()=0 w "]}"
		q 1
}

ClassMethod insertGMMap(grpID As %String, userIDs As %String) As %String
{
	s inParam("grpID")=grpID
	s inParam("userIDs")=userIDs
	TSTART
	s ret=##class(DHCWL.PerMis.GMMAP).Insert(.inParam,.outParam)
	if ret'="" {
		w "{""msg"":"""_ret_""",""success"":""0""}"
		TROLLBACK
	}else{
		w "{""msg"":"""_ret_""",""success"":""1""}"
		TCOMMIT
	}
	q 0
}

ClassMethod GetMapedMember(grpID As %String, searchV As %String, page As %Integer, rows As %Integer)
{

	if 1 {
		s start=((page-1)*rows)
		s limit=rows
		s end=start+limit
		s start=start+1
	}else{
		s start=0
		s end=0
		s start=0	
		s page=1	
	}	
	
	s qryName="%DynamicQuery:SQL" 
	//上面是固定写法 
	//////////////////////////////////////////
	s jsonPro="ID,SSUSR_Name,CTLOC_Desc,CTCPT_Desc,SSGRP_Desc"
	
	s sql="SELECT * from "
	s sql=sql_"(SELECT ID,userDr->SSUSR_Name, userDr->SSUSR_DefaultDept_DR->CTLOC_Desc, userDr->SSUSR_CareProv_DR->CTPCP_CarPrvTp_DR->CTCPT_Desc,userDr->SSUSR_Group->SSGRP_Desc FROM DHCWL_PerMis.GMMAP"
	s sql=sql_" WHERE GrpDr='"_grpID_"')" 
	if searchV'="" {
		s sql=sql_" WHERE SSUSR_Name LIKE '%"_searchV_"%' OR CTLOC_Desc LIKE '%"_searchV_"%' OR CTCPT_Desc LIKE '%"_searchV_"%' OR SSGRP_Desc LIKE '%"_searchV_"%'  "
	}
	s sql=sql_" order by ID"
	

	//w !,sql		
	s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
	
	w json.GetHead()
	d{
		s obj=json.Next()
		w obj
	}while(obj'="")
	
	i json.GetCount()=0 w "]}"
	q 1
}

ClassMethod DelMember(mapID As %String) As %String
{
	s ret=""
	s sc=##class(DHCWL.PerMis.GMMAP).%DeleteId(mapID)
	If $$$ISERR(sc) {
		s ret="组-组内用户失败:"_$System.Status.GetErrorText(sc)
 	}
 	
	if ret'="" {
		w "{""msg"":"""_ret_""",""success"":""0""}"
	}else{
		w "{""msg"":"""_ret_""",""success"":""1""}"
	} 	
 	
 	q ""
}

/*
ClassMethod GetMapCfg(rptTool As %String, mapItem As %String, searchV As %String, page As %Integer, rows As %Integer)
{
	if 1 {
		s start=((page-1)*rows)
		s limit=rows
		s end=start+limit
		s start=start+1
	}else{
		s start=0
		s end=0
		s start=0	
		s page=1	
	}
}
*/
Query GetMapCfg(rptTool As %String, mapItem As %String, searchV As %String) As %Query(ROWSPEC = "rptTool:%String,rptID:%String,rptName:%String,rptCode:%String,grpID:%String,grpName:%String,grpCode:%String,userID:%String,userName:%String")
{
}

ClassMethod GetMapCfgExecute(ByRef qHandle As %Binary, rptTool As %String, mapItem As %String, searchV As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	if (rptTool="") || (mapItem="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	} 
	
	k ^||TEMPDHCWL("GetMapCfg")
	K ^||TEMPDHCWL("QryData")
	s ^||TEMPDHCWL("GetMapCfg","searchV")=searchV
	s ^||TEMPDHCWL("GetMapCfg","rptTool")=rptTool
	//1、拼接header
	d ..IFBuildHeader(mapItem)
	
	//2、加载报表-组，组-人员的配置
	d ..IFLoadMapCfg()
	
	//3、读取数据并保存到global
	//d ..IFGetMapData()
	//4、拼接数据
	d ..IFBuildColData()
	
	s rptTool="",rptID="",rptName="",rptCode="",grpID="",grpName="",grpCode="",userID="",userName=""
	s data=""
	f {			  
		s data=$o(^||TEMPDHCWL("QryData",data))
		q:data=""
		if $d(^||TEMPDHCWL("GetMapCfg","rgmap","header")) {
			s pos=^||TEMPDHCWL("GetMapCfg","rgmap","header","rptType")
			s rptTool=$p(data,"^",pos)
			s pos=^||TEMPDHCWL("GetMapCfg","rgmap","header","rptID")
			s rptID=$p(data,"^",pos)
			s pos=^||TEMPDHCWL("GetMapCfg","rgmap","header","rptName")
			s rptName=$p(data,"^",pos)
			s pos=^||TEMPDHCWL("GetMapCfg","rgmap","header","rptCode")
			s rptCode=$p(data,"^",pos)
		}
		if $d(^||TEMPDHCWL("GetMapCfg","grp","header")) {
			s pos=^||TEMPDHCWL("GetMapCfg","grp","header","grpID")
			s grpID=$p(data,"^",pos)
			s pos=^||TEMPDHCWL("GetMapCfg","grp","header","grpName")
			s grpName=$p(data,"^",pos)
			s pos=^||TEMPDHCWL("GetMapCfg","grp","header","grpCode")
			s grpCode=$p(data,"^",pos)
		}
		if $d(^||TEMPDHCWL("GetMapCfg","gmmap","header")) {
			s pos=^||TEMPDHCWL("GetMapCfg","gmmap","header","userID")
			s userID=$p(data,"^",pos)
			s pos=^||TEMPDHCWL("GetMapCfg","gmmap","header","userName")
			s userName=$p(data,"^",pos)
		}
		s Data=$lb(rptTool,rptID,rptName,rptCode,grpID,grpName,grpCode,userID,userName)
		Do OutRow

	}
	
	
	
	
    Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetMapCfgClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMapCfgExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMapCfgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMapCfgExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/*
 		^||TEMPDHCWL("GetMapCfg","grp","header",PropertyName)=colPos
		^||TEMPDHCWL("GetMapCfg","rgmap","header",PropertyName)=colPos
		^||TEMPDHCWL("GetMapCfg","gmmap","header",PropertyName)=colPos			
 */
ClassMethod IFBuildHeader(mapItem)
{
	//^||TEMPDHCWL("GetMapCfg")
	s colPos=0
	s cnt=$l(mapItem,",")
	f i=1:1:cnt {
		s item=$p(mapItem,",",i)
		if item="rpt" {
			///报表
			s colPos=colPos+1
			s ^||TEMPDHCWL("GetMapCfg","rgmap","header","rptType")=colPos
			s colPos=colPos+1
			s ^||TEMPDHCWL("GetMapCfg","rgmap","header","rptID")=colPos
			s colPos=colPos+1
			s ^||TEMPDHCWL("GetMapCfg","rgmap","header","rptName")=colPos
			s colPos=colPos+1
			s ^||TEMPDHCWL("GetMapCfg","rgmap","header","rptCode")=colPos
			//s ^||TEMPDHCWL("GetMapCfg","rgmap","itemPos")=i
			s ^||TEMPDHCWL("GetMapCfgItems",i,"rgmap")=""
		}elseif item="grp" {
			//组
			s colPos=colPos+1
			s ^||TEMPDHCWL("GetMapCfg","grp","header","grpID")=colPos
			s colPos=colPos+1
			s ^||TEMPDHCWL("GetMapCfg","grp","header","grpName")=colPos
			s colPos=colPos+1
			s ^||TEMPDHCWL("GetMapCfg","grp","header","grpCode")=colPos
			//s ^||TEMPDHCWL("GetMapCfg","grp","itemPos")=i
			s ^||TEMPDHCWL("GetMapCfgItems",i,"grp")=""
		}elseif item="user" {
			//用户
			s colPos=colPos+1
			s ^||TEMPDHCWL("GetMapCfg","gmmap","header","userID")=colPos
			s colPos=colPos+1
			s ^||TEMPDHCWL("GetMapCfg","gmmap","header","userName")=colPos
			//s ^||TEMPDHCWL("GetMapCfg","gmmap","itemPos")=i
			s ^||TEMPDHCWL("GetMapCfgItems",i,"gmmap")=""
		}
	}
}

ClassMethod IFLoadMapCfg()
{
	
	if $d(^||TEMPDHCWL("GetMapCfg","rgmap")) {
		s id=""
		f {
			s id=$o(^DHCWL.PerMis.RGMapD(id))
			q:id=""
			s obj=##class(DHCWL.PerMis.RGMap).%OpenId(id)
			s rptTool=obj.RptTool
			continue:(rptTool'=^||TEMPDHCWL("GetMapCfg","rptTool") && (^||TEMPDHCWL("GetMapCfg","rptTool")'="adq"))
			s rptID=obj.RptID
			s grpID=obj.GrpDr.%Id()
			
			if rptTool="bdq"  {
				s obj=##class(DHCWL.BaseDataQuery.Rpt).GetById(rptID)
				s name=obj.Name
				s code=obj.Code
			}elseif rptTool="cdq" {
				//通用数据查询
				s obj=##class(DHCWL.CommonDataQry.RptCfg).GetById(rptID)
				s name=obj.RptName
				s code=obj.Code
			}elseif rptTool="odq" {
				///其他数据查询
			}
			//过滤
			if $d(^||TEMPDHCWL("GetMapCfgItems",1,"rgmap")) && (^||TEMPDHCWL("GetMapCfg","searchV")'="") {
				s SV=^||TEMPDHCWL("GetMapCfg","searchV")
				continue:(name'[SV && (code'[SV))
			}

			s ^||TEMPDHCWL("GetMapCfg","rgmap","data",grpID,rptID_"^"_rptTool,"rptID")=rptID
			s ^||TEMPDHCWL("GetMapCfg","rgmap","data",grpID,rptID_"^"_rptTool,"rptName")=name
			s ^||TEMPDHCWL("GetMapCfg","rgmap","data",grpID,rptID_"^"_rptTool,"rptCode")=code
			s ^||TEMPDHCWL("GetMapCfg","rgmap","data",grpID,rptID_"^"_rptTool,"rptType")="基础数据查询"
		}
	}
	
	//加载组-成员
	if $d(^||TEMPDHCWL("GetMapCfg","gmmap")) {
		s id=""
		f {
			s id=$o(^DHCWL.PerMis.GMMAPD(id))
			q:id=""
			s obj=##class(DHCWL.PerMis.GMMAP).%OpenId(id)
			s grpObj=obj.GrpDr
			s userObj=obj.UserDr
			s userID=userObj.%Id()
			s grpID=grpObj.%Id()
			//s obj=##class(User.SSUser).%OpenId(userID)
			continue:'$ISOBJECT(userObj)
			s name=userObj.SSUSRName
			
			if $d(^||TEMPDHCWL("GetMapCfgItems",1,"gmmap")) && (^||TEMPDHCWL("GetMapCfg","searchV")'="") {
				s SV=^||TEMPDHCWL("GetMapCfg","searchV")
				b:userID=4649
				continue:(name'[SV && (userID'=SV))
			}
			s ^||TEMPDHCWL("GetMapCfg","gmmap","data",grpID,userID,"userID")=userID
			s ^||TEMPDHCWL("GetMapCfg","gmmap","data",grpID,userID,"userName")=name
		}
	}
	
	//加载组配置
	s grpID=""
	f {
		s grpID=$o(^DHCWL.PerMis.GrpD(grpID))
		q:grpID=""
		s obj=##class(DHCWL.PerMis.Grp).%OpenId(grpID)
		s name=obj.Name
		s code=obj.Code

		//过滤
		if $d(^||TEMPDHCWL("GetMapCfgItems",1,"grp")) && (^||TEMPDHCWL("GetMapCfg","searchV")'="") {
			s SV=^||TEMPDHCWL("GetMapCfg","searchV")
			continue:(name'[SV && (code'[SV))
		}

		s ^||TEMPDHCWL("GetMapCfg","grp","data",grpID,"grpID")=grpID
		s ^||TEMPDHCWL("GetMapCfg","grp","data",grpID,"grpName")=name
		s ^||TEMPDHCWL("GetMapCfg","grp","data",grpID,"grpCode")=code
	}
}

ClassMethod IFBuildColData()
{
  /*旧版本。使用间接访问global实现。
  
	s i=""
	f {
		s i=$o(^||TEMPDHCWL("GetMapCfgItems",i))
		q:i=""
		s node=	$o(^||TEMPDHCWL("GetMapCfgItems",i,""))
		//continue:(node="grp")
		if '$d(g1) s g1="^||TEMPDHCWL(""GetMapCfg"","""_node_""""
		else  if '$d(g2) s g2="^||TEMPDHCWL(""GetMapCfg"","""_node_""""
		else  if '$d(g3) s g3="^||TEMPDHCWL(""GetMapCfg"","""_node_""""
	}
	

		s rowV=""

		if $g(g1)'="" {
			s grpID="""""" 
			f {
				s grpID=$o(@(g1_",""data"","_grpID_")"))
				q:grpID=""
				
				s nodeID1=""
				f {
					s nodeID1=$o(@(g1_",""data"","_grpID_","""_nodeID1_""")"))
					q:nodeID1=""
					s colName=""
					f {
						s colName=$o(@(g1_",""data"","_grpID_","""_nodeID1_""","""_colName_""")"))
						q:colName=""
						
						s colValue=@(g1_",""data"","_grpID_","""_nodeID1_""","""_colName_""")")
						s colPos=@(g1_",""header"","""_colName_""")")
						s $p(rowV,"^",colPos)=colValue 
					}
				
					if $g(g2)'="" {				
						s nodeID2=""
						f {
							s nodeID2=$o(@(g2_",""data"","_grpID_","""_nodeID2_""")"))	
							q:nodeID2=""
							s colName=""
							f {
								s colName=$o(@(g2_",""data"","_grpID_","""_nodeID2_""","""_colName_""")"))
								q:colName=""
								
								s colValue=@(g2_",""data"","_grpID_","""_nodeID2_""","""_colName_""")")
								s colPos=@(g2_",""header"","""_colName_""")")
								s $p(rowV,"^",colPos)=colValue 
							}
							s ^||TEMPDHCWL("QryData",rowV)=""
							//s rowV=""
						}

						if $g(g3)'="" {
							s nodeID3=""
							f {
								s nodeID3=$o(@(g3_",""data"","_grpID_","""_nodeID3_""")"))	
								q:nodeID3=""
								s colName=""
								f {
									s colName=$o(@(g3_",""data"","_grpID_","""_nodeID3_""","""_colName_""")"))
									q:colName=""
									
									s colValue=@(g3_",""data"","_grpID_","""_nodeID3_""","""_colName_""")")
									s colPos=@(g3_",""header"","""_colName_""")")
									s $p(rowV,"^",colPos)=colValue 
								}
								s ^||TEMPDHCWL("QryData",rowV)=""
								//s rowV=""
							}
						}else{
							s ^||TEMPDHCWL("QryData",rowV)=""
						}
					}else{
						s ^||TEMPDHCWL("QryData",rowV)=""
					}
				}
			}
		}else{
			s ^||TEMPDHCWL("QryData",rowV)=""
			//s rowV=""
		}
	*/

  

	s grpID=""
	f {
		s grpID=$o(^||TEMPDHCWL("GetMapCfg","grp","data",grpID))
		q:grpID=""
		
		s rowV=""
		if $d(^||TEMPDHCWL("GetMapCfg","grp","header")) 
		{
			s colName=""
			f {
				s colName=$o(^||TEMPDHCWL("GetMapCfg","grp","data",grpID,colName))
				q:colName=""
				
				s colValue=^||TEMPDHCWL("GetMapCfg","grp","data",grpID,colName)
				s colPos=^||TEMPDHCWL("GetMapCfg","grp","header",colName)
				s $p(rowV,"^",colPos)=colValue 
			}
		}
		
		s itemInx1=""
		s itemInx1=$o(^||TEMPDHCWL("GetMapCfgItems",itemInx1))
		s item=$o(^||TEMPDHCWL("GetMapCfgItems",itemInx1,""))
		
		if item="grp" {
			s itemInx1=$o(^||TEMPDHCWL("GetMapCfgItems",itemInx1))
			continue:(itemInx1="")
			s item=$o(^||TEMPDHCWL("GetMapCfgItems",itemInx1,""))

		}
		
		/*
		if '$d(^||TEMPDHCWL("GetMapCfg",item,"data",grpID)) {
			s $p(rowV,"^",colPos)=colValue 
			continue	
		}
		*/
		
		s item1=item
		s nodeID1=""
		f {
			s nodeID1=$o(^||TEMPDHCWL("GetMapCfg",item1,"data",grpID,nodeID1))
			q:nodeID1=""
			
			s colName=""
			f {
				s colName=$o(^||TEMPDHCWL("GetMapCfg",item1,"data",grpID,nodeID1,colName))
				q:colName=""
				
				s colValue=^||TEMPDHCWL("GetMapCfg",item1,"data",grpID,nodeID1,colName)
				s colPos=^||TEMPDHCWL("GetMapCfg",item1,"header",colName)
				s $p(rowV,"^",colPos)=colValue 
			}
			
			
			s itemInx2=$o(^||TEMPDHCWL("GetMapCfgItems",itemInx1))
			if itemInx2="" {
				s ^||TEMPDHCWL("QryData",rowV)=""
				continue
			}
			
			s item=$o(^||TEMPDHCWL("GetMapCfgItems",itemInx2,""))
			
			if item="grp" {
				s itemInx2=$o(^||TEMPDHCWL("GetMapCfgItems",itemInx2))
				if itemInx2=""{
					s ^||TEMPDHCWL("QryData",rowV)=""
					continue
				}  
				s item=$o(^||TEMPDHCWL("GetMapCfgItems",itemInx2,""))
			}			
			
			
			s item2=item
			s nodeID2=""
			f {
				s nodeID2=$o(^||TEMPDHCWL("GetMapCfg",item2,"data",grpID,nodeID2))
				q:nodeID2=""
				
				s colName=""
				f {
					s colName=$o(^||TEMPDHCWL("GetMapCfg",item2,"data",grpID,nodeID2,colName))
					q:colName=""
					
					s colValue=^||TEMPDHCWL("GetMapCfg",item2,"data",grpID,nodeID2,colName)
					s colPos=^||TEMPDHCWL("GetMapCfg",item2,"header",colName)
					s $p(rowV,"^",colPos)=colValue 
				}			
				s ^||TEMPDHCWL("QryData",rowV)=""

			}
		}	
	}
}

}
