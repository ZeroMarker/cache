Class EMRservice.BL.BLMainRoleFuntion Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Creator：      LingChen
/// CreatDate：    2010-10-22
/// Description:   查询
/// Table：        
/// Input：        roleID As %String  
/// Output：       EMRservice.dataset.EMainRoleFuncDataSet
/// Return：       
/// Others：       其它说明
ClassMethod SelectFuncNameByRoleID(roleID As %String) As EMRservice.dataset.EMainRoleFuncDataSet
{
	Set ds=##class(EMRservice.dataset.EMainRoleFuncDataSet).%New()
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
	&sql(select count(*) into :isExist from EMRmeta.MainRoleFunction where RoleID = :roleID)
	if isExist > 0
	{
		&sql(delete from EMRmeta.MainRoleFunction where RoleID = :roleID)
	}
	if SQLCODE'=0
	{
		trollback
	   	q
	}
 
	f i=1:1:count
	{
		set func = $p(functions,"^",i)
	    &sql(insert into EMRmeta.MainRoleFunction (RoleID, FuncName) values(:roleID, :func))
        q:SQLCODE'=0
    }
    i SQLCODE=0 Tcommit
    e  trollback
   
    q SQLCODE
    
    
ErrorHandler
    trollback
    q SQLCODE
}

ClassMethod SelectKBTreeByRoleID(roleID As %String) As EMRservice.dataset.EMainRoleKBDataSet
{
	Set ds=##class(EMRservice.dataset.EMainRoleKBDataSet).%New()
	d ds.SetArgs(roleID)
	Quit ds
}

ClassMethod InsertKBTreeRole(KBTreeID As %String, roleID As %String)
{
	if (KBTreeID= "")||(roleID = "") q

    &sql(UPDATE EMRmeta.MainRoleKBTree SET RoleID = :roleID WHERE KBTreeID = :KBTreeID)
}

ClassMethod DeleteKBTreeRole(KBTreeID As %String)
{
	if (KBTreeID = "") q
	
    &sql(delete from EMRmeta.MainRoleKBTree where KBTreeID = :KBTreeID)
}

ClassMethod UpdataRoleKBTree(KBTreeIDs As %String, roleID As %String)
{
	
	if (roleID = "") q	
	set count = $Length(KBTreeIDs,"^")

    s $zt = "ErrorHandler"	
		
	Tstart
	s isExist = 0
	&sql(select count(*) into :isExist from EMRmeta.MainRoleKBTree where RoleID = :roleID)
	if isExist > 0
	{
		&sql(delete from EMRmeta.MainRoleKBTree where RoleID = :roleID)
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
			&sql(insert into EMRmeta.MainRoleKBTree (RoleID, KBTreeID) values(:roleID, :kbTreeID))
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

Query SelectFuncNameByRoleID(roleID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "FuncName:%String")
{
	SELECT FuncName
	FROM EMRMeta.MainRoleFunction
	WHERE RoleID = :roleID
	ORDER BY ID
}

Query SelectKBTreeByRoleID(roleID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "KBTreeID:%String")
{
	SELECT KBTreeID
	FROM EMRmeta.MainRoleKBTree
	WHERE RoleID = :roleID
	ORDER BY ID
}

}
