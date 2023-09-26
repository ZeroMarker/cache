Class web.DHCNurEmrMainComm Extends %Persistent
{

ClassMethod iflinkchecked(locstr As %String, inloc As %String) As %String
{
	s l=$l(locstr,"^")
	s flag=0
	f i=1:1:l
	{
		s loc=$p(locstr,"^",i)
		if (loc=inloc) d
		.s flag=1
		.break
	}
	q flag
}

//知识库关联模板

ClassMethod SaveKnowLink(locstr As %String, kncode As %String, usercode As %String) As %String
{
  //s a=##class(NurEmr.KnowledgeLoc).Save()
  //s locstr="144^145^147^149^153^154^"
  //s kncode="xhyyKn3Kn"
  s code=$ZConvert(kncode,"U")
  s rw="" f  s rw=$O(^NurEmr.KnowledgeLocI("KnCode"," "_code,rw)) q:rw=""  d
  .s a=##class(NurEmr.KnowledgeLoc).%OpenId(rw) 
  .s emrloc=a.EmrLoc
  .i usercode="admin" d
  ..s flag=..iflinkchecked(locstr,emrloc)
  ..i flag=0 d
  ...s a=##class(NurEmr.KnowledgeLoc).%DeleteId(rw)
  .i usercode'="admin" d
  ..i locstr="" d
  ...s a=##class(NurEmr.KnowledgeLoc).%DeleteId(rw)
  s l=$l(locstr,"^")
 
  for i=1:1:l
  {
    s loc=$P(locstr,"^",i)
    q:loc=""
    s rw=$O(^NurEmr.KnowledgeLocI("LocK"," "_loc," "_code,""))
    if rw="" s a=##class(NurEmr.KnowledgeLoc).%New()  
    e  s a=##class(NurEmr.KnowledgeLoc).%OpenId(rw)  
    s a.EmrLoc=loc
    s a.KnCode=kncode
    d a.%Save()
  }
 q 1
}

ClassMethod getadminpass(type)
{
	s ret=""
	if ('$d(^NurEmr.NurEmrAdminPassword("admin"))) s ^NurEmr.NurEmrAdminPassword("admin")="q000000"
	else  s ret=^NurEmr.NurEmrAdminPassword("admin")
	q ret
}

ClassMethod GetWard(type) As %String
{
 //s a=##class(web.DHCNurEmrMainComm).GetWard("W")
    s ret2=""
    s json=##class(%ListOfDataTypes).%New()
    s typ="" f  s typ=$O(^CTLOC(0,"LocType",typ)) q:typ=""  d
    .;q:(typ="D")!(typ="O")!(typ="OR")
    .//q:(typ="D")!(typ="OR")
    .q:(typ'=type)&&(typ'="")
    .s rw=""  f  s rw=$O(^CTLOC(0,"LocType",typ,rw)) q:rw=""  d
    ..s des=$P(^CTLOC(rw),"^",2)
    ..q:des["停用"
    ..//q:(des'["病房")&(des'["病区")&(des'["病")&(des'["单元")
    ..//q:(des["检验科")
    ..//q:des["组"
    ..//q:(typ="O")&(des'["治疗室")&(des'["门诊服务台")&(des'["临床药理")&(des'["门诊部门诊咨询") 
    ..s ret2=ret2_rw_"|"_des_"^"
    ..s jsonsub=##class(%ArrayOfDataTypes).%New()
    ..d jsonsub.SetAt(des,"Desc")
	..d jsonsub.SetAt(rw,"Id")
	..d json.Insert(jsonsub)
   q ##class(Nur.JSON).Encode(json)
}

ClassMethod GetWardComm(type) As %String
{
 //s a=##class(web.DHCNurEmrMainComm).GetWard("W")
    s ret2=""
    s typ="" f  s typ=$O(^CTLOC(0,"LocType",typ)) q:typ=""  d
    .;q:(typ="D")!(typ="O")!(typ="OR")
    .//q:(typ="D")!(typ="OR")
    .q:(typ'=type)&&(typ'="")
    .s rw=""  f  s rw=$O(^CTLOC(0,"LocType",typ,rw)) q:rw=""  d
    ..s des=$P(^CTLOC(rw),"^",2)
    ..q:des["停用"
    ..//q:(des'["病房")&(des'["病区")&(des'["病")&(des'["单元")
    ..//q:(des["检验科")
    ..//q:des["组"
    ..//q:(typ="O")&(des'["治疗室")&(des'["门诊服务台")&(des'["临床药理")&(des'["门诊部门诊咨询") 
    ..s ret2=ret2_rw_"|"_des_"^"
   q ret2
}

//w ##class(web.DHCNurEmrMainComm).logon("dh444444","30","W")

/// 2012 08 12 pengjunfu
/// 验证用户名密码并且返回可以登录的病区
ClassMethod logon(userName As %String, password As %String, logonLocType As %String = "W") As %String
{
		//n (userName , password , logonLocType)
		s $zt="errorLogon"
		s userId=##class(web.SSUser).IsValidUser(userName,password)
		s json=##class(%ArrayOfDataTypes).%New()
		s eflag=""
		i userId="" s userId="-100"
		i userId<0 d
		.s errorInfo=$s(userId="-100":"用户不存在",userId="-101":"密码不正确",userId="-102":"用户没有激活",1:"")
	    .d json.SetAt($g(errorInfo),"ErrorInfo")
	    .s eflag=1
	    b ;
		i eflag=1 q ##class(Nur.JSON).Encode(json)
		s locJson=..getUserLoc(userId,logonLocType)
		d json.SetAt($g(errorInfo),"ErrorInfo")
		d json.SetAt($g(locJson),"Locs")
		d json.SetAt(userId,"UserID")
		i ($g(errorInfo)="")&&(locJson.Count()=0) d
		.s errorInfo="用户没有可登陆的病区"
		.d json.SetAt($g(errorInfo),"ErrorInfo")
		q ##class(Nur.JSON).Encode(json)
errorLogon
	s error=$ze
	s json=##class(%ArrayOfDataTypes).%New()
	d json.SetAt($g(error),"ErrorInfo")
	q ##class(Nur.JSON).Encode(json)
}

/// 2012 08 12 pengjunfu
/// 根据userID查找可以登录的病区科室
/// w ##class(Nur.Iphone.Common).getWardPats(20)
ClassMethod getUserLoc(userId As %String, logonLocType As %String = "W") As %ListOfDataTypes
{
		//n (userId, logonLocType)
		s defLocId="",userName="",defLocType=""
		s locJson=##class(%ListOfDataTypes).%New()
		s userObj=##class(User.SSUser).%OpenId(userId)
		i ($IsObject(userObj)){
			s userName=userObj.SSUSRName
			s defLocObj=userObj.SSUSRDefaultDeptDR
			s defGroupObj=userObj.SSUSRGroup
		
			i ($IsObject(defLocObj)){
				s defLocDesc=defLocObj.CTLOCDesc
				i defLocDesc["-" s defLocDesc=$p(defLocDesc,"-",2)
				s defLocType=defLocObj.CTLOCType
				s defLocId=defLocObj.%Id()
				d defLocObj.%Close()
			}
			i ($IsObject(defGroupObj)){
				s defGroupId=defGroupObj.%Id()
				d defGroupObj.%Close()
			}
			i (($g(defLocType)'="")&(logonLocType'="")&(defLocType'=logonLocType)){
				s defLocId=""
				s defLocDesc=""
				s defGroupId=""
			}
			d userObj.%Close()
		}

		i (defLocId'=""){
	
			s locChildJson=##class(%ArrayOfDataTypes).%New()
			d locChildJson.SetAt(defLocId,"LocID")
			d locChildJson.SetAt(defLocDesc,"LocDesc")
			s defWardId=$o(^PAWARD(0,"WARD_LocationDR",defLocId,""))
			i defWardId="" s defWardId=0
			i defGroupId="" s defGroupId=0
			s grpdesc=0
			i defGroupId'=0 d
            .s grpdesc=$p(^SSU("SSGRP",defGroupId),"^",1) 
			d locChildJson.SetAt(defWardId,"WardID")
			d locChildJson.SetAt(defGroupId,"GroupID")
			d locChildJson.SetAt(grpdesc,"GroupDesc")
			d locJson.Insert(locChildJson)
		}
		s rs=##class(%ResultSet).%New("web.DHCNurEmrMainComm:logonCtloc")
		d rs.Execute(userId)
		while(rs.Next()){
			s locId=rs.GetDataByName("locId")
			s groupId=rs.GetDataByName("groupId")
			s grpdesc=0
			i groupId'="" d
            .s grpdesc=$p(^SSU("SSGRP",groupId),"^",1) 
			s locDesc=$p($G(^CTLOC(locId)),"^",2)
			i locDesc["-" s locDesc=$p(locDesc,"-",2)
			s locType=$p($G(^CTLOC(locId)),"^",13)
			s wardId=$o(^PAWARD(0,"WARD_LocationDR",locId,"")) 
			i wardId="" s wardId=0
			i groupId="" s groupId=0
			continue:(locType'="")&(logonLocType'="")&(logonLocType'=locType)
			continue:(defLocId'="")&(defLocId=locId)
			s locChildJson=##class(%ArrayOfDataTypes).%New()
			d locChildJson.SetAt(locId,"LocID")
			d locChildJson.SetAt(locDesc,"LocDesc")
			d locChildJson.SetAt(wardId,"WardID")
			d locChildJson.SetAt(groupId,"GroupID")
			d locChildJson.SetAt(grpdesc,"GroupDesc")
			d locJson.Insert(locChildJson)
		}
		q locJson
}

/// 2012 08 05 pengjunfu
/// userId  SS_USER dr
/// 查找病人可以登录的科室
Query logonCtloc(userId As %String) As %Query(ROWSPEC = "locId:%String,groupId:%String")
{
}

ClassMethod logonCtlocExecute(ByRef qHandle As %Binary, userId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=""  f  s chl=$O(^SSU("SSUSR",userId,"OTHLL",chl)) q:chl=""  d
    .s locId=$P(^SSU("SSUSR",userId,"OTHLL",chl),"^",1)
    .s groupId=$P(^SSU("SSUSR",userId,"OTHLL",chl),"^",2)
    
    .s locDesc=$p($G(^CTLOC(locId)),"^",2)
    .q:locDesc=""
    .s tm(locDesc)=locId_"^"_groupId
    s locId=""  f  s locId=$O(tm(locId)) q:locId=""  d
    .s id=$p(tm(locId),"^",1)
    .s groupId=$p(tm(locId),"^",2)
    .d OutRowlogonCtloc
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowlogonCtloc
	set Data=$lb(id,groupId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod logonCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = logonCtlocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod logonCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = logonCtlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//维护程序目录表读写锁定

//stat:1 锁定

//     0 解锁

//type:WinTmp:界面模板目录； PrnReport:打印模板目录 ； KnowledgeStock：知识库目录

ClassMethod LockNurEmr(type As %String, stat As %String) As %String
{
  s type=$zcvt(type,"U")
  if (stat=1)
  {
	  //如果不存在则设置globle,如果是解锁状态则锁定
	  if ('$d(^NurEmr.NurEmrMainLockState(type))||(($d(^NurEmr.NurEmrMainLockState(type)))&&($g(^NurEmr.NurEmrMainLockState(type))=0))) s ^NurEmr.NurEmrMainLockState(type)=1 
  }
  if (stat=0)
  {
	  //如果不存在则设置globle,如果是解锁状态则解锁定
	  if ('$d(^NurEmr.NurEmrMainLockState(type))||(($d(^NurEmr.NurEmrMainLockState(type)))&&($g(^NurEmr.NurEmrMainLockState(type))=1))) s ^NurEmr.NurEmrMainLockState(type)=0 
	  
  }
  q 0
}

//获取锁定状态

//type:WinTmp:界面模板目录； PrnReport:打印模板目录 ； KnowledgeStock：知识库目录

ClassMethod getlockstate(type As %String) As %String
{
   s type=$zcvt(type,"U")
   //不存在goloble则说明未锁定
   if ('$d(^NurEmr.NurEmrMainLockState(type))) q 0
   q $g(^NurEmr.NurEmrMainLockState(type))
}

ClassMethod getData(code As %String) As %String
{
 //s a=##class(NurEmr.NurEmrMain).getData()
 
  s code=$ZConvert(code,"U")
  s id=$O(^NurEmr.NurEmrMainI("EmrCode"," "_code,""))
  q id
}

//获取维护程序目录信息

ClassMethod GetGenStream(code As %String) As %Stream
{
   s code=$ZConvert(code,"U")
   s id=$O(^NurEmr.NurEmrMainI("EmrCode"," "_code,""))
   if id="" q ""
   s a=##class(NurEmr.NurEmrMain).%OpenId(id)
   q a.EmrData
}

//获取模板数据

ClassMethod GetKStream(code As %String) As %Stream
{
  s code=$ZConvert(code,"U")
  s id=$O(^NurEmr.NurEmrSubI("EmrCode"," "_code,""))
  if id'=""
  {
  }else{
       s id=$O(^NurEmr.NurEmrSubI("KCode"," "_code,""))
	  }
   if id="" q ""
   s a=##class(NurEmr.NurEmrSub).%OpenId(id)
   q a.EmrSubData
}

//获取知识库模板数据

ClassMethod GetZSKKStream(code As %String) As %Stream
{
  s code=$ZConvert(code,"U")
  s id=$O(^NurEmr.NurEmrSubItmI("EmrCode"," "_code,""))

   if id="" q ""
   s a=##class(NurEmr.NurEmrSubItm).%OpenId(id)
   q a.EmrData
}

//保存模板流数据

//w ##class(web.DHCNurEmrMainComm).SaveMBStream(^obycufkk,^obycufkk1)

ClassMethod SaveMBStream(parr, data As %GlobalCharacterStream) As %String
{
	s ^obycufkk=parr
	s ^obycufkk1=data
    s Code=$p(parr,"#*^",1)
    //s data=$p(parr,"#*^",2)
    s RowId=$p(parr,"#*^",3)
    s Desc=$p(parr,"#*^",4)
    s KCode=$p(parr,"#*^",5)
    s comFlag=$p(parr,"#*^",6)
    i comFlag="" s comFlag="N"
    s flag=""
    s id=""
    i KCode'="" s id =..getMBId(KCode)
    b ;3
    i id'="" d
    .s Itm2 =##class(NurEmr.NurEmrSub).%OpenId(id)
    .s kgjz=Itm2.EmrSubCode
    .b ;344
    .i (kgjz'=Code)&(kgjz'="")&(Code'="")  s flag=KCode
    q:flag'="" flag_"该关键字已经存在！"
    i id = "" s id =..getMBId(Code)
    b ;
    i id '= "" d
    .s Itm =##class(NurEmr.NurEmrSub).%OpenId(id)
    e  d
    .s Itm = ##class(NurEmr.NurEmrSub).%New()
   
    s Itm.EmrSubCode = Code
    s Itm.EmrSubDesc = Desc
    s Itm.EmrSubKCode = Code
    s Itm.EmrSubCom = comFlag
    i KCode '= "" s Itm.EmrSubKCode = KCode
	i id'="" d Itm.EmrSubData.Clear()
	s leng=data.Size
	b ;33
	while (data.AtEnd = 0)
	{ 
	    s leng=data.Size
	    s leng=1024
		s readstring=data.Read(leng)
		if $l(readstring)'=1024 d 
	    .s readstring=$e(readstring,0,$l(readstring))
	    d Itm.EmrSubData.Write(readstring)
	}
	d Itm.%Save()
	q 0
}

//w ##class(web.DHCNurEmrMainComm).SaveMBStreamTest(^obycufkk)

ClassMethod SaveMBStreamTest(parr) As %String
{
	//d data.Rewind()
    s ^obycufkk2=parr
    //s ^obycufkk1=data
    //k ^oby0322
    s Code=$p(parr,"#*^",1)
    //s data=$p(parr,"#*^",2)
    s RowId=$p(parr,"#*^",3)
    s Desc=$p(parr,"#*^",4)
    s KCode=$p(parr,"#*^",5)
    s comFlag=$p(parr,"#*^",6)
    i comFlag="" s comFlag="N"
    b ;33
    s id =..getMBId(KCode)
    i id = "" s id =..getMBId(Code)
    s ^ocyff2=id_"^"_KCode_"^"_Code
    B
    i id '= "" d
    .s Itm =##class(NurEmr.NurEmrSub).%OpenId(id) 
    e  d
    .s Itm = ##class(NurEmr.NurEmrSub).%New()
    s ^ocyff=id_"^"_KCode_"^"_Code_"^"_Itm
    s Itm =##class(NurEmr.NurEmrSub).%New()
    //s Itm =##class(NurEmr.NurEmrSub).%OpenId("765") 
    b ;01
    s Itm.EmrSubCode ="c123" ; Code
    s Itm.EmrSubDesc ="222222121" ; Desc
    s Itm.EmrSubKCode ="b123" ; Code
    s Itm.EmrSubCom ="N" ; comFlag
    s Itm.EmrSubRelPrnCode="555455121"
	s rw="" 
	f  s rw=$O(^oby0322("DHCNURCEEK",rw)) q:rw=""  d
	.s readstring=^oby0322("DHCNURCEEK",rw)
	.d Itm.EmrSubData.Write(readstring)
	d Itm.%Save()
	s id=Itm.%Id()
	q Itm.%Id()
}

ClassMethod getMBId(code As %String) As %String
{
	
  q:code=""
  s code=" "_$ZConvert(code,"U") 
  s id=""
  s flag=$d(^NurEmr.NurEmrSubI("EmrCode",code))
  i flag'="" s id=$O(^NurEmr.NurEmrSubI("EmrCode",code,""))
  if id="" s id=..GetMBKCode(code)
  q id
}

//根据code判断知识库是否存在

ClassMethod getZSKId(code As %String) As %String
{
	
  q:code=""
  s code=" "_$ZConvert(code,"U") 
  s id=""
  s id=$d(^NurEmr.NurEmrSubItmI("EmrCode",code))
  q id
}

ClassMethod GetMBKCode(code) As %String
{
  //##class(web.DHCNurEmrMainComm).getMBId("DHCNUREKHLBL")
  //##s flag=$listget(^NurEmr.NurEmrSubD(id),8)
    s id=$O(^NurEmr.NurEmrSubI("KCode",code,""))
    q id
}

//保存目录信息 NurEmr.NurEmrMain

// w ##class(web.DHCNurEmrMainComm).SaveEmrMian(^cyf5141,^cyf5142)

ClassMethod SaveEmrMian(code, data As %GlobalCharacterStream) As %String
{
	s ^cyf5141=code
	s ^cyf5142=data
    s code=$ZConvert(code,"U")
    s id=$O(^NurEmr.NurEmrMainI("EmrCode"," "_code,""))
    i id '= "" d
    .s Itm =##class(NurEmr.NurEmrMain).%OpenId(id) 
    e  d
    .s Itm = ##class(NurEmr.NurEmrMain).%New()
    s Itm.EmrCode = code
	//s ^objmain=code_"^"_id_"^"_Itm
	
	s aaB = ##class(NurEmr.NurEmrMainBack).%New()
	s aaB.EmrCode=code
	i id'="" d Itm.EmrData.Clear()
	s ^cyf5143=data.Size
	while (data.AtEnd = 0)
	{ 
	    
	    s leng=data.Size
	    s leng=1024
		s readstring=data.Read(leng)
		s ^cyf5144=data.Size_"&"_readstring
		if $l(readstring)'=1024 d 
	    .s readstring=$e(readstring,0,$l(readstring))
	    d Itm.EmrData.Write(readstring)
	    d aaB.EmrData.Write(readstring)
	    s ^cyf5145=2
	}
	s ^cyf5146=6
	d Itm.%Save()
	d aaB.%Save()
	s ^cyf5144=aaB.%Id()
	q 0
}

//保存知识库信息 NurEmr.NurEmrSubItm

ClassMethod SaveEmrItm(code, desc, data As %GlobalCharacterStream) As %String
{
    s code=$ZConvert(code,"U")
    s id=$O(^NurEmr.NurEmrSubItmI("EmrCode"," "_code,""))
    i id '= "" d
    .s Itm =##class(NurEmr.NurEmrSubItm).%OpenId(id) 
    e  d
    .s Itm = ##class(NurEmr.NurEmrSubItm).%New()
    s Itm.EmrItmCode = code
    s Itm.EmrItmDesc=desc
	s ^objmain=code_"^"_id_"^"_Itm
	
	i id'="" d Itm.EmrData.Clear()
	while (data.AtEnd = 0)
	{ 
	    s leng=data.Size
	    s leng=1024
		s readstring=data.Read(leng)
		if $l(readstring)'=1024 d 
	    .s readstring=$e(readstring,0,$l(readstring))
	    d Itm.EmrData.Write(readstring)
	}
	d Itm.%Save()
	q 0
}

ClassMethod GetLoc() As %String
{
 //s a=##class(web.DHCNurEmrMainComm).GetLoc
    s ret2=""
    s typ="" f  s typ=$O(^CTLOC(0,"LocType",typ)) q:typ=""  d
    .;q:(typ="D")!(typ="O")!(typ="OR")
    .q:(typ="D")!(typ="OR")
    .s rw=""  f  s rw=$O(^CTLOC(0,"LocType",typ,rw)) q:rw=""  d
    ..s des=$P(^CTLOC(rw),"^",2)
    ..q:des["停用"
    ..q:(des'["病房")&(des'["病区")&(des'["病")&(des'["单元")
    ..q:(des["检验科")
    ..q:des["组"
    ..q:(typ="O")&(des'["治疗室")&(des'["门诊服务台")&(des'["临床药理")&(des'["门诊部门诊咨询") 
    ..s ret2=ret2_rw_"|"_des_"^"
   q ret2
}

ClassMethod GetQueryHead(QueryName) As %String
{
  // n (QueryName,Parr)s a=##class(web.DHCMGPrintComm).GetQueryHead("web.DHCNurRecPrint:GetCareRecComm")
   s ret=""
   s ^oiieie=QueryName
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()
        For col = 1:1:columns {
	       // if rset.GetColumnName(col)="ItemData" continue
            s ret=ret_rset.GetColumnName(col)_"&"
        }
    s parm=""
        For i = 1 :1: rset.GetParamCount()
        {
        s parm=parm_rset.GetParamName(i)_"&"
        }

 q ret_"("_parm
}

ClassMethod getDatabytype(type As %String) As %GlobalCharacterStream
{
  //s code=$ZConvert(code,"U")
  s ret=""
  s retStream=##class(%GlobalCharacterStream).%New()
  s rw="" f  s rw=$o(^NurEmr.NurEmrSubI("EmrCode",rw)) q:rw=""  d
  .s id="" f  s id=$o(^NurEmr.NurEmrSubI("EmrCode",rw,id)) q:id=""  d
  ..s a=##class(NurEmr.NurEmrSub).%OpenId(id)
  ..s subcode=a.EmrSubCode
  ..q:subcode'[type
  ..s subdesc=a.EmrSubDesc
  ..//s subcode=$tr(subcode,type,"")
  ..s ret=subcode_"^"_subdesc_"|"
  ..//w !,ret
  ..d retStream.Write(ret)
  q retStream
}

//w ##class(web.DHCNurEmrMainComm).getbackfoldname("WINTMP","NAME")

//input:

//   code:WinTmp  界面模板  Prn

//   type:"NAME" fold节点text

//        "DATE" ver节点日期

ClassMethod getbackfoldname(code, type) As %GlobalCharacterStream
{
  //s code=$ZConvert(code,"U")
  s ret=""
  s code=$ZConvert(code,"U")
  //s retStream=##class(%GlobalCharacterStream).%New()
  s rw="" f  s rw=$o(^NurEmr.MainNameBackI("EmrCodeDT"," "_code," "_type,rw)) q:rw=""  d
  .s a=##class(NurEmr.MainNameBack).%OpenId(rw)
  .s subcode=a.EmrData
  .s ret=subcode
  .//d retStream.Write(ret)
  q ret
}

//判断是否存在

//w ##class(web.DHCNurEmrMainComm).iffoldbacked("WINTMP")

ClassMethod iffoldbacked(code) As %String
{
 s rw=0
 s code=$ZConvert(code,"U")
 i ($d(^NurEmr.MainNameBackI("EmrCodeDT"))&($d(^NurEmr.MainNameBackI("EmrCodeDT"," "_code))))  s rw=1
 q rw
}

Storage Default
{
<Data name="DHCNurEmrMainCommDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCNurEmrMainCommD</DataLocation>
<DefaultData>DHCNurEmrMainCommDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCNurEmrMainCommD</IdLocation>
<IndexLocation>^web.DHCNurEmrMainCommI</IndexLocation>
<StreamLocation>^web.DHCNurEmrMainCommS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
