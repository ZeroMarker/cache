/// 名称: web.DHCEQ.Plat.CTDepreMethod
/// 描述: 设备折旧方式
/// 编写者：ZX
/// 编写日期: 2018-09-02
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTDepreMethod Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ZX
/// CreatDate：    2018-09-02
/// Description:   折旧方式LookUp所需Query
/// Table：        DHC_EQCDepreMethod
/// Input：        Desc:折旧方式描述
Query LookUp(Desc) As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
SELECT DM_Desc,
	   DM_RowID,
	   DM_Code
FROM sqluser.DHC_EQCDepreMethod
where DM_InvalidFlag = 'N' and DM_Desc like nvl(:Desc,'')||'%'
}

}
