Import sqluser

/// 
/// 根据Excel文件导入生成居民健康档案和家庭档案
/// 
Class CHSSWeb.EHRIMP Extends %RegisteredObject
{

/// fname(tab分隔的.TXT,采用UTF8格式保存) :全路径名称
///  
ClassMethod importdata(fname, streetname, roadname) As %String
{
 ;fname : the filename including data(必须是全路径)
 ;
 q:fname="" -1
 w "正在上载数据...",!
 s ret= ..upload(fname)
 
 
 w "正在初始化项目...",!
 q ""
 q:streetname="" -1
 s tempStreetDR = ..GetInitInfo(streetname)
 q:tempStreetDR="" -1
 
 s ret=..locup1(roadname,tempStreetDR)

 
 //w "正在插入EHR...",!
 //s ret=..imptEHR() 
 //q:ret<0 $g(ret)
 

 //k ^TMP($j,"INITLOCSTK")
 //w "处理完毕。",!
 q 0
}

ClassMethod GetInitInfo(streetname As %String) As %String
{
		s tempStreetDR = ""
		
		&SQL(select RowId into :tempStreetDR from CHSS.DictStreet where Description = :streetname)
	
		i tempStreetDR '= "" d
		.s result = ..InitData(tempStreetDR)
		q tempStreetDR
}

ClassMethod InitData(StreetDR As %Integer) As %String
{
	w ##class(CHSSWeb.EHRDataImport).DeletePersonRecord(StreetDR)
	w ##class(CHSSWeb.EHRDataImport).DeleteFamilyRecord(StreetDR)
	
	q "1"
}

ClassMethod upload(fname) As %String
{
  
 ;
 ;n
 k ^REJECT($zn)
 k ^zTSA($zn)
 s del="^"
 s sub="EHR"
 ; 
 s ret= ..file(fname,sub)
 q ret
}

ClassMethod file(file, sub) As %String
{
 k ^zTSA($zn,sub),^TMP($zn,sub)
 k ^tempFamily
 k ^tempFamilyERR
 k ^tempPerson
 k ^tempPersonERR
 s ^tempFamily = ""
 s ^tempFamilyERR = ""
 s ^tempPerson = ""
 s ^tempPersonERR = ""
 ;
 s key="RLOC",del="^"
 s file=file
 s $zt="close"
 ;
 o file:"RSK\UTF8\"
 u file
 
 //s ^TMP("zhwh",9999)=$zmode
 f  d
 . r a
 . s line=$o(^zTSA($zn,sub,""),-1)+1
 .
 . s ^zTSA($zn,sub,0)=line
 . 
 . //i line=447 b
 . 
 . s ^zTSA($zn,sub,line)=$tr(a,$c(9),del)
close() 
 c file
 q 0
}

ClassMethod locup1(roadname As %String, StreetDR As %String) As %String
{
  
 ;
  ; Excel Field:
  ;    ---1-----2-----3------4--------5------------6--------7---------8-----------9------10-------------11--------
  ;		姓名---性别---民族--出生日期-公民身份号码--街路巷--门楼牌号--门楼详址--户主姓名--与户主关系--居委会（村）
        
 K ^REJECT($ZN)
 s sub="EHR",del="^"
 s ind=1,cnt=0
 
 //将数据验证后存放到临时global : ^zTSA($zn,"IMPDATA")
 //
 f  s ind=$o(^zTSA($zn,sub,ind)) q:ind=""  s s=$G(^zTSA($zn,sub,ind)) d
 .
 . s sexRowid="",nationRowid="",dobDate="",relationRowid=""
 . ;
 . 
 . 
 . s name=$P(s,del,1) q:name=""
 . 
 . 
 . s sex=$P(s,del,2) 
 . s sexRowid = sex
 . ;i sex'="" s sexRowid=..getSex(sex)
 . s nation=$P(s,del,3) i nation'="" s nationRowid=..getNationRowid(nation)
 . s dob=$P(s,del,4) i dob'="" s dobDate=..getDobDate(dob)
 . s nationCardId=$P(s,del,5)  //身份证号
 . s street=$P(s,del,6)
 . s doorPlate=$P(s,del,7)
 . s addr=$P(s,del,8)
 . s masterName=$P(s,del,9)
 . 
 . s relation=$P(s,del,10) i relation'="" s relationRowid=..getRelationRowid(relation)
 . ;居委会
 . s committee=$P(s,del,11)
 . s cnt=cnt+1
 . 
 . //i sexRowid="" s ^REJECT($ZN,"ERR","CannotGetSEX",cnt)=$G(^zTSA($zn,sub,ind)) q
 . //i nationRowid="" s ^REJECT($ZN,"ERR","CannotGetATION",cnt)=$G(^zTSA($zn,sub,ind)) q
 . //i dobDate="" s ^REJECT($ZN,"ERR","CannotGetDOB",cnt)=$G(^zTSA($zn,sub,ind)) q
 . //i masterName="" s ^REJECT($ZN,"ERR","CannotGetMASTER",cnt)=$G(^zTSA($zn,sub,ind)) q
 . //i relationRowid="" s ^REJECT($ZN,"ERR","CannotGetRELATION",cnt)=$G(^zTSA($zn,sub,ind)) q
 . 
 . s familyIndent=street_doorPlate_addr_masterName  //家庭识别串
 . 
 . 
 . ;w "familyIndent:"_familyIndent,!
 . 
 . i (relation="户主")!(relation="本人") s ^zTSA($zn,"FAMILY",familyIndent,nationCardId)=nationCardId  //记录下家庭户主和其身份证号
 . e   s ^zTSA($zn,"FAMILY",familyIndent,nationCardId)=""
 .
 . s ^zTSA($zn,"IMPDATA",cnt)=name
 . s ^zTSA($zn,"IMPDATA",cnt)=^zTSA($zn,"IMPDATA",cnt)_del_sexRowid
 . s ^zTSA($zn,"IMPDATA",cnt)=^zTSA($zn,"IMPDATA",cnt)_del_nationRowid
 . s ^zTSA($zn,"IMPDATA",cnt)=^zTSA($zn,"IMPDATA",cnt)_del_dobDate
 . s ^zTSA($zn,"IMPDATA",cnt)=^zTSA($zn,"IMPDATA",cnt)_del_nationCardId
 . s ^zTSA($zn,"IMPDATA",cnt)=^zTSA($zn,"IMPDATA",cnt)_del_street
 . s ^zTSA($zn,"IMPDATA",cnt)=^zTSA($zn,"IMPDATA",cnt)_del_doorPlate
 . s ^zTSA($zn,"IMPDATA",cnt)=^zTSA($zn,"IMPDATA",cnt)_del_addr
 . s ^zTSA($zn,"IMPDATA",cnt)=^zTSA($zn,"IMPDATA",cnt)_del_relationRowid
 . s ^zTSA($zn,"IMPDATA",cnt)=^zTSA($zn,"IMPDATA",cnt)_del_familyIndent
 . s ^zTSA($zn,"IMPDATA",cnt)=^zTSA($zn,"IMPDATA",cnt)_del_masterName
 . s ^zTSA($zn,"IMPDATA",cnt)=^zTSA($zn,"IMPDATA",cnt)_del_committee

 q:cnt=0 -1
 ;
 s errMsg=$o(^REJECT($ZN,"ERR",""))
 i errMsg'="" q -2
 ;
 s i=0
 s count=0
 s AllCount=0
 f  s i=$o(^zTSA($zn,"IMPDATA",i))  q:i=""  d
 .
 .s data=^zTSA($zn,"IMPDATA",i)
 .//
 .s name=$p(data,del,1)
 .s sexRowid=$p(data,del,2)
 .s nationRowid=$p(data,del,3)
 .s dobDate=$p(data,del,4)
 .s nationCardId=$p(data,del,5)
 .s street=$p(data,del,6)
 .s street = $Piece(street,roadname, 2)
 .s doorPlate=$p(data,del,7)
 .s addr=$p(data,del,8)
 .s relationRowid=$p(data,del,9)
 .s familyIndent=$p(data,del,10)
 .s masterName=$p(data,del,11)
 .s committee=$p(data,del,12) //居委会
 .
 .s masterFlag=0   //户主标志(0:非户主,1:户主)
 .s masterNationCardId=..getMasterNationId(familyIndent,nationCardId)  //取得户主身份证号
 .
 .i nationCardId=masterNationCardId s masterFlag=1    //此居民是否户主
 .
 .
 .;如果是户主，则添加家庭档案
 .i masterFlag=1 d
 ..s count = count + 1 
 ..w masterNationCardId_":"_masterFlag_":"_count,!
 ..;w "bb",!
 ..s result = ##class(CHSSWeb.EHRDataImport).AddFamilyData(name, "", 1, 1, 1, 1, StreetDR, 1, doorPlate_addr, committee)
 ..
 ..;w result,!
 ..i result = "result1" d
 ...;s ^tempFamilyERR = ^tempFamilyERR_"^"_name_nationCardId_":ERR"
 ..e  i result = "" d
 ...s ^zTSA($zn,"IMPDATA",i) = ^zTSA($zn,"IMPDATA",i)_del_""
 ..e  d
 ...;s ^zTSA($zn,"IMPDATA",i) = ^zTSA($zn,"IMPDATA",i)_del_result
 ...s ^zTSA($zn,"FAMILYROWID",familyIndent,nationCardId)=result //记录下家庭档案号
 .
 .
 .;添加个人档案
 f  s i=$o(^zTSA($zn,"IMPDATA",i))  q:i=""  d
 .
 .s data=^zTSA($zn,"IMPDATA",i)
 .//
 .s name=$p(data,del,1)
 .s sexRowid=$p(data,del,2)
 .s nationRowid=$p(data,del,3)
 .s dobDate=$p(data,del,4)
 .s dobDate = $zd(dobDate,3)
 .s nationCardId=$p(data,del,5)
 .s street=$p(data,del,6)
 .s street = $Piece(street,roadname, 2)
 .s doorPlate=$p(data,del,7)
 .s addr=$p(data,del,8)
 .s relationRowid=$p(data,del,9)
 .s familyIndent=$p(data,del,10)
 .s masterName=$p(data,del,11)
 .
 .
 .s AllCount = AllCount + 1 
 .w nationCardId_":"_AllCount,!
 .
 .;添加个人档案
 .s familyrowid = ..getFamilyRowId(familyIndent)
 .s personResult = ##class(CHSSWeb.EHRDataImport).AddPersonData(masterName, "", 1, 1, 1, 1, StreetDR, 1, doorPlate_addr, street, name, sexRowid, dobDate, nationCardId , street_doorPlate_addr , 1,relationRowid, 1, familyrowid)	
 .i personResult '= "result2" d
 ..;s ^tempPersonERR = ^tempPersonERR_"^"_name_nationCardId_":ERR"
 ..s ^zTSA($zn,"PERSONERR",familyIndent,nationCardId)=name_nationCardId
 ..
 .//
 .
 w "FamilyCount:"_count,!
 w "PersonCount:"_AllCount,!
 Q cnt      
 ;
}

/// 取性别Rowid
ClassMethod getSex(sex) As %String
{
  s sexRowid=""
  &sql(select rowid into :sexRowid from CHSS.DictSex where description=:sex) 
  q sexRowid
}

/// 计算生日
ClassMethod getDobDate(dob As %String) As %String
{
	s dobDate=""
	i $l(dob)=8  s dobDate=$zdh(dob,8)
   q dobDate
}

/// 取"与户主关系"定义rowid
ClassMethod getRelationRowid(relaDesc As %String) As %String
{
	s relaRowid=""
	s relaDesc=..tranRelation(relaDesc) q:relaDesc="" relaRowid
	
	i relaDesc="子" s relaDesc="儿子"
	i relaDesc="女" s relaDesc="女儿"
	i relaDesc="户主" s relaDesc="本人"  //关系表中没有"户主"的称谓
	//
	//取关系rowid
	&sql(select rowid into :relaRowid from CHSS.DictKin where description=:relaDesc)
	q:'SQLCODE relaRowid 
	q relaRowid
}

/// 取民族rowid
ClassMethod getNationRowid(nation As %String) As %String
{
 s nationRowid=""
 s nation="%"_nation_"%"
 &sql( select ctnat_rowid into :nationRowid from ct_nation where ctnat_desc like :nation)
 q nationRowid
}

ClassMethod imptEHR()
{
}

ClassMethod rej(param)
{
   
  //n (param)
  s count=$o(^REJECT($ZN,""),-1)+1,^REJECT($ZN,count)=param
 
  q
}

/// 去掉原始名称中的顺序和"外"描述
ClassMethod tranRelation(relaDesc As %String) As %String
{
  s sub="长次一二三四五六七八九十1234567890"
  s relaDesc=$tr(relaDesc,sub)

  while (relaDesc["(")
  {	  
	  s pos1=$f(relaDesc,"(",1)-1
	  s pos2=$f(relaDesc,")",1)
	  s relaDesc=$e(relaDesc,1,pos1-1)_$e(relaDesc,pos2,$l(relaDesc))
  }
  
  q relaDesc
}

/// 是否户主
ClassMethod getMasterNationId(familyIndent As %String, nationCardId As %String) As %String
{

  //s familyIndent="涪城区绵州路中段２１１号３栋２单元２号王红"
 // s nationCardId="510702196109090424"
  
 //根据家庭识别串取出该家庭户主身份证号
 s tmpNationId=""
 q:'$d(^zTSA($zn,"FAMILY",familyIndent,nationCardId)) ""
 s tmpNationId=$g(^zTSA($zn,"FAMILY",familyIndent,nationCardId))
 //b
 i tmpNationId'="" q tmpNationId
 
 s na=""
 f  s na=$o(^zTSA($zn,"FAMILY",familyIndent,na)) q:(na="")!(tmpNationId'="")  d
 .s tmpNationId=^zTSA($zn,"FAMILY",familyIndent,na)
 
 q tmpNationId
}

/// 查找家庭档案
ClassMethod getFamilyRowId(familyIndent As %String) As %String
{

  //s familyIndent="涪城区绵州路中段２１１号３栋２单元２号王红"
 // s nationCardId="510702196109090424"
  
 //根据家庭识别串取出该家庭户主身份证号
 s tmpFamilyRowId=""

 
 s na=""
 f  s na=$o(^zTSA($zn,"FAMILYROWID",familyIndent,na)) q:(na="")!(tmpFamilyRowId'="")  d
 .s tmpFamilyRowId=^zTSA($zn,"FAMILYROWID",familyIndent,na)
 ;w tmpFamilyRowId,!
 q tmpFamilyRowId
}

}
