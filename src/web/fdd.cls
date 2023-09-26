Class web.fdd Extends %RegisteredObject [ ProcedureBlock ]
{

// w ##class(web.fdd).GetMdataTable()

ClassMethod GetMdataTable() As %Integer
{
 /////做之前先merge备份一下^mdata,然后再运行下面的程序,然后再kill掉^mdata
 ////m ^mdataBAK=^mdata
 k ^fddtmpa,^fddtmpb,^fddtmpc,^fddtmpd
 s cc=0,dd=0,ee=0,ff=0,scls="",smdata="",stype="",sname=""
 &sql(declare cur cursor for select parent,SqlIdExpression,type,name into :scls,:smdata,:stype,:sname from %Dictionary.StorageDefinition where SqlIdExpression like '%mdata%')
 &sql(open cur)
 f  &sql(fetch cur) q:SQLCODE  d
 .s sGetClsCounter="",soldCounterStr="",sTblName="",stmpSchema="",stmpClsName="",sParentClsName="",sFullParentClsName="",sDataMaster="",stmpstr="",sNewCounterStr="",soldTmpMdataStr="",soldMdataStr=""
 .s oldMdataNum="",stmpoldMdataStrValue="",snewMdataStr="",newMdataNum=""
 .s cc=cc+1
 .s sGetClsCounter=..GetClsCounter(scls)
 .s soldCounterStr=$p(sGetClsCounter,"#",1),sTblName=$p(sGetClsCounter,"#",2)
 .s stmpSchema=$p(scls,".",1),stmpClsName=$p(scls,".",2,$l(scls,"."))
 .s sParentClsName=##class(web.Util.DHCJFClassGlobal).SelectParent(stmpSchema,stmpClsName)  //是否有父表,空则无父表,非空则父表类的名字
 .i $g(sParentClsName)'="" s sFullParentClsName=stmpSchema_"."_sParentClsName
 .//
 .s sDataMaster=$p(##class(web.Util.DHCJFClassGlobal).GetTableInfo(sTblName),"!",4)
 .i sDataMaster[",{" d
 ..s stmpstr=$p(sDataMaster,",{",1)
 ..s sNewCounterStr="$i("_$g(stmpstr)_"))"
 .e  i sDataMaster["({" d
 ..s stmpstr=$p(sDataMaster,"({",1)
 ..s sNewCounterStr="$i("_$g(stmpstr)_")"
 .e  d  //sDataMaster为空,User.DHCMedAdvRepNotes得到的sDataMaster为空
 ..s stmpstr=""
 ..s sNewCounterStr=""
 .;
 .//b:scls="User.PHAHERBConfig" ////////
 .i $g(soldCounterStr)["^mdata" d  //$I(^mdata("DHCPhaAgrPartyReq"))
 ..s soldTmpMdataStr=$p($p(soldCounterStr,"(^",2),"))")_")"
 .e  d  //"User.DHCMedAdvRepNotes"这个class,sqlId1定义了$i(^mdata("DHCMedAdvRepNotes"))，但真正的是$i(^User.DHCMedAdvRepNotesD)
 ..s soldTmpMdataStr=$p($p(soldCounterStr,"(^",2),")")
 .;
 .s soldMdataStr="^"_soldTmpMdataStr
 .s oldMdataNum=+$g(@soldMdataStr)  //取计数器的值
 .s stmpoldMdataStrValue=soldMdataStr_"="_oldMdataNum
 .//以下判断存储Global数据根节点是否有值
 .i sNewCounterStr["))" d  // $i(^CF("MSQL"))
 ..s snewMdataStr="^"_$p($p(sNewCounterStr,"(^",2),"))")_")"
 .e  d
 ..s snewMdataStr=stmpstr  //i(^APCVENDORINFO)
 .;
 .i snewMdataStr["({" d //^DHCADREVTWFI({DHC_AdrEvtWorkFlow.ADREW_RowID},"ADREWI")
 ..s newMdataNum=0
 .e  i snewMdataStr="" d
 ..s newMdataNum=0
 .e  d
 ..s newMdataNum=+$g(@snewMdataStr)
 .//
 .;
 .s ^fddtmpa(cc)=$g(scls)_"#"_$g(smdata)_"#"_$g(stype)_"#"_$g(sname)_"#"_$g(soldCounterStr)_"#"_$g(sTblName)_"#"_$g(sDataMaster)_"#"_$g(sNewCounterStr)_"#"_$g(oldMdataNum)_"#"_$g(newMdataNum)_"#"_$g(stmpoldMdataStrValue)_"#"_$g(sFullParentClsName)
 .;
 .i ($g(sFullParentClsName)="")&($l(sDataMaster,"{")<3) d  //需要处理的(子表暂不处理)
 ..s dd=dd+1
 ..s ^fddtmpb(dd)=$g(scls)_"#"_$g(smdata)_"#"_$g(stype)_"#"_$g(sname)_"#"_$g(soldCounterStr)_"#"_$g(sTblName)_"#"_$g(sDataMaster)_"#"_$g(sNewCounterStr)_"#"_$g(oldMdataNum)_"#"_$g(newMdataNum)_"#"_$g(stmpoldMdataStrValue)_"#"_$g(sFullParentClsName)
 ..i $g(snewMdataStr)'="" d
 ...i ((+$g(newMdataNum)=0)!(+$g(oldMdataNum)'<(+$g(newMdataNum)))) d  ////如果存储Global数据根节点的值为空或小于^mdata计数器的值则为其赋值为^mdata计数器的值,否则其自身的值做为计数器的值
 ....//s @snewMdataStr=oldMdataNum                      ////---------调试时则屏蔽该行
 ...s ee=ee+1
 ...s ^fddtmpc(ee)=$g(scls)_"#"_$g(smdata)_"#"_$g(stype)_"#"_$g(sname)_"#"_$g(soldCounterStr)_"#"_$g(sTblName)_"#"_$g(sDataMaster)_"#"_$g(sNewCounterStr)_"#"_$g(oldMdataNum)_"#"_$g(newMdataNum)_"#"_$g(stmpoldMdataStrValue)_"#"_$g(sFullParentClsName)
 ...//s ret=..updSqlIdExpression(scls,sNewCounterStr)  ////---------调试时则屏蔽该行
 ...//d $system.OBJ.Compile(scls,"fcuk")               ////---------调试时则屏蔽该行
 .e  d  //不需要处理的(子表,ChildSub)
 ..s ff=ff+1
 ..s ^fddtmpd(ff)=$g(scls)_"#"_$g(smdata)_"#"_$g(stype)_"#"_$g(sname)_"#"_$g(soldCounterStr)_"#"_$g(sTblName)_"#"_$g(sDataMaster)_"#"_$g(sNewCounterStr)_"#"_$g(oldMdataNum)_"#"_$g(newMdataNum)_"#"_$g(stmpoldMdataStrValue)_"#"_$g(sFullParentClsName)
 .//w !,$g(scls)_" "_cc_" "_dd_" "_ee_" "_ff
 &sql(close cur)
 q cc_" "_dd_" "_ee_" "_ff
}

ClassMethod GetClsCounter(sClassName) As %String
{
 s sStorage=$o(^oddDEF(sClassName,"s",""))
 s sStorageType=$g(^oddDEF(sClassName,"s",sStorage,5))
 ;b //Cache中是%Library.CacheStorage和%Library.CacheSQLStorage,IRIS中是%Storage.Persistent和%Storage.SQL
 ;i $g(sStorageType)["CacheStorage" d  //%Library.CacheStorage
 i $g(sStorageType)["%Storage.Persistent" d  ////IRIS中是%Storage.Persistent和%Storage.SQL
 .s sRowidName=$lg(^oddEXTR(sClassName,91),9)    //rowid名字 %ID
 .s sRowidExp=$lg(^oddEXTR(sClassName,"b",sRowidName,91),22)  //rowid计数器
 .//s sTableName=$lg(^oddEXTR(sClassName,91),2)                 //SQL Table Name
 .;b  //CacheStorage
 ;e  i $g(sStorageType)["CacheSQLStorage" d   //%Library.CacheSQLStorage
 e  i $g(sStorageType)["%Storage.SQL" d   ////IRIS中是%Storage.Persistent和%Storage.SQL
 .s sRowidName=$g(^oddDEF(sClassName,"s",sStorage,29))  //rowid名字
 .s sRowidExp=$g(^oddDEF(sClassName,"s",sStorage,28))   //比如$i(^mdata("DHCCARDREF"))
 .//s sTableName=$g(^oddDEF(sClassName,58))               //SQL Table Name
 .;b //CacheSQLStorage
 ;
 s sSchemaName=$lg(^oddEXTR(sClassName,91),1),sTableName=$lg(^oddEXTR(sClassName,91),2)
 s sFullTableName=$g(sSchemaName)_"."_$g(sTableName)

 q $g(sRowidExp)_"#"_$g(sFullTableName)
}

ClassMethod updSqlIdExpression(ssCls, ssCnt) As %Status
{
 &SQL(SELECT ID into :ssid from %Dictionary.StorageDefinition where parent=:ssCls)
 If 'SQLCODE {
               set s=##class(%Dictionary.StorageDefinition).%OpenId(ssid)
 			   set s.SqlIdExpression=ssCnt
               s status= s.%Save()
              }
              q 0
}

}
