Class CSM.VSysUserInstDeptRole [ ClassType = view, CompileAfter = (CSM.SysUser, CSM.MedInstitution, CSM.Department, CSM.SysProject, CSM.ProjectGroup, CSM.SysRole), DdlAllowed, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = VSysUserInstDeptRole, ViewQuery = { select csm.UserProjectGroup.ID UPGID, csm.SysProject.Name ProjectName, csm.medinstitution.name InstName,csm.department.name DeptName,csm.UserProjectGroup.ProjectID, csm.UserProjectGroup.ProjGrpID, csm.ProjectGroup.Name ProjGrpName, csm.SysRole.Name RoleName, csm.UserProjectGroup.RoleID,CSM.SysUser.* from CSM.SysUser,csm.medinstitution,csm.department, csm.UserProjectGroup, csm.SysProject, csm.ProjectGroup, csm.SysRole where csm.sysuser.deptid=csm.department.id and csm.department.institutionid=csm.medinstitution.id and csm.UserProjectGroup.UserID=CSM.SysUser.ID and csm.UserProjectGroup.ProjectID = csm.SysProject.ID and csm.UserProjectGroup.ProjGrpID =csm.ProjectGroup.ID and csm.UserProjectGroup.RoleID =csm.SysRole.ID } ]
{

Parameter READONLY = 1;

}
