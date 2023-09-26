Class EPRservice.BLMainRoleFuntion Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Creator：      LingChen
/// CreatDate：    2010-10-22
/// Description:   查询
/// Table：        
/// Input：        roleID As %String  
/// Output：       EPRservice.dataset.MainRoleFuncDataSet
/// Return：       
/// Others：       其它说明
ClassMethod SelectFuncNameByRoleID(roleID As %String) As EPRservice.dataset.MainRoleFuncDataSet
{
	Set ds=##class(EPRservice.dataset.MainRoleFuncDataSet).%New()
	d ds.SetArgs(roleID)
	Quit ds
}

/// Creator：      LingChen
/// CreatDate：    2010-10-22
/// Description:   更新角色权限
/// Table：        
/// Input：        functions:功能列表，以^分割，如Menu_Tools_DictionarySet^Meny_View_Knowledge
///                roleID As %String 
/// Output：       
/// Return：       
/// Others：       其它说明
ClassMethod UpdataRoleFuntion(functions As %String, roleID As %String)
{
	
	if (roleID = "") q	
	set count = $Length(functions,"^")

    s $zt = "ErrorHandler"	
		
	Tstart
	s isExist = 0
	&sql(select count(*) into :isExist from EPRMeta.MainRoleFunction where RoleID = :roleID)
	if isExist > 0
	{
		&sql(delete from EPRMeta.MainRoleFunction where RoleID = :roleID)
	}
	if SQLCODE'=0
	{
		trollback
	   	q
	}
 
	f i=1:1:count
	{
		set func = $p(functions,"^",i)
	    &sql(insert into EPRMeta.MainRoleFunction (RoleID, FuncName) values(:roleID, :func))
        q:SQLCODE'=0
    }
    i SQLCODE=0 Tcommit
    e  trollback
   
    q SQLCODE
    
    
ErrorHandler
    trollback
    q SQLCODE
}

ClassMethod SelectKBTreeByRoleID(roleID As %String) As EPRservice.dataset.MainRoleKBDataSet
{
	Set ds=##class(EPRservice.dataset.MainRoleKBDataSet).%New()
	d ds.SetArgs(roleID)
	Quit ds
}

ClassMethod UpdataRoleKBTree(KBTreeIDs As %String, roleID As %String)
{
	
	if (roleID = "") q	
	set count = $Length(KBTreeIDs,"^")

    s $zt = "ErrorHandler"	
		
	Tstart
	s isExist = 0
	&sql(select count(*) into :isExist from EPRMeta.MainRoleKBTree where RoleID = :roleID)
	if isExist > 0
	{
		&sql(delete from EPRMeta.MainRoleKBTree where RoleID = :roleID)
	}
	if SQLCODE'=0
	{
		trollback
	   	q
	}
 
	f i=1:1:count
	{
		set kbTreeID = $p(KBTreeIDs,"^",i)
		if (kbTreeID '= "")
		{
			&sql(insert into EPRMeta.MainRoleKBTree (RoleID, KBTreeID) values(:roleID, :kbTreeID))
		}
        q:SQLCODE'=0
    }
    i SQLCODE=0 Tcommit
    e  trollback
   
    q SQLCODE
    
    
ErrorHandler
    trollback
    q SQLCODE
}

}
