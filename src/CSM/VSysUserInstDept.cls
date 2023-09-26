Class CSM.VSysUserInstDept [ ClassType = view, CompileAfter = (CSM.SysUser, CSM.MedInstitution, CSM.Department), DdlAllowed, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = VSysUserInstDept, ViewQuery = { select csm.medinstitution.id InstID, csm.medinstitution.name InstName,csm.department.name DeptName,CSM.SysUser.* from CSM.SysUser,csm.medinstitution, csm.department where csm.sysuser.deptid=*csm.department.id and csm.department.institutionid=*csm.medinstitution.id} ]
{

Parameter READONLY = 1;

}
