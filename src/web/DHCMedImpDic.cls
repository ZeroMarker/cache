Import sqluser

/// 名称: 	  DHCMedImpDic
/// 描述: 	  将字典数据写入DHC_MedDictory表中
/// 编写者：  刘学峰
/// 编写日期: 2010-06-09
Class web.DHCMedImpDic Extends %RegisteredObject
{

/// Creator：    刘学峰
/// CreatDate：  2010-06-09
/// Description：将字典数据写入DHC_MedDictory表中
/// Table：      DHC_MedDictory
/// Input：      无
/// Debug:       w ##class(web.DHCMedImpDic).UpdateMedDictory()
/// 说明：		 首先将要导入的数据使用\03-病案管理2.0\基础数据\数据导入程序\VB_Import导入到临时Global
ClassMethod UpdateMedDictory()
{
	s index=0
	k ^DHCMedTmpDataErr
	f  s index=$o(^DHCMedTmpData(index)) q:index=""  d
	.s DataString=$g(^DHCMedTmpData(index))
	.q:DataString=""
	.s ret=..Update(DataString)
	.s:ret<0 ^DHCMedTmpDataErr(index)=ret_"*"_DataString
	.w:ret<0 "Err! Index="_index_";ErrCode="_ret,!
	q "导入成功!"
}

/// 更新程序
ClassMethod Update(InString)
{
    s MDICRowid=$p(InString,"^",1)
    s PLIST(2)=$p(InString,"^",2)      ;代码                  
    s PLIST(3)=$p(InString,"^",3)      ;描述                 
    s PLIST(4)=$p(InString,"^",4)      ;字典类别  
    s IsActive=$p(InString,"^",5)
    s IsActive=$s(IsActive["Y":"Y",1:"N")         
    s PLIST(5)=IsActive      ;状态                
    ;s:$p(InString,"^",6)'="" PLIST(6)=$zdh($p(InString,"^",6),3)      ;起始日期  delete by lxf 2008-10-29       
    ;s:$p(InString,"^",7)'="" PLIST(7)=$zdh($p(InString,"^",7),3)      ;截止日期  delete by lxf 2008-10-29
    s PLIST(6)=$p(InString,"^",6)      ;起始日期 	update by lxf 2008-10-29
    s PLIST(7)=$p(InString,"^",7)      ;截止日期  	update by lxf 2008-10-29
    s:((PLIST(6)'="")&&(PLIST(6)["-")) PLIST(6)=$zdh($p(InString,"^",6),3) 	;update by lxf 2008-10-29
    s:((PLIST(6)'="")&&(PLIST(6)["/")) PLIST(6)=$zdh($p(InString,"^",6),4) 	;update by lxf 2008-10-29
    s:((PLIST(7)'="")&&(PLIST(7)["-")) PLIST(7)=$zdh($p(InString,"^",7),3) 	;update by lxf 2008-10-29
    s:((PLIST(7)'="")&&(PLIST(7)["/")) PLIST(7)=$zdh($p(InString,"^",7),4) 	;update by lxf 2008-10-29
    
    s PLIST(8)=$p(InString,"^",8)      ;            
    s PLIST(9)=$p(InString,"^",9)      ;            
    s PLIST(10)=$p(InString,"^",10)   ;            
    s PLIST(11)=$p(InString,"^",11)    ;  
    q:($d(^DHCMDIC("0","TypeCode",PLIST(4),PLIST(2))))&(MDICRowid="") -1
    i MDICRowid="" d
    .&sql(Insert into DHC_MedDictory values :PLIST())
    e  d
    .&sql(Update DHC_MedDictory values :PLIST() where MDIC_Rowid=:MDICRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

}
