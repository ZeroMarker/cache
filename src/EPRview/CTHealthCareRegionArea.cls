Class EPRview.CTHealthCareRegionArea [ ClassType = view, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = CTHealthCareRegionArea, ViewQuery = { select a.hca_code,$piece(r.hcr_desc,'-',1)||$piece(a.hca_desc,'-',1)||'-'||$piece(r.hcr_desc,'-',2)||$piece(a.hca_desc,'-',2) HCA_Desc from SQLUser.CT_HealthCareArea a, SQLUser.CT_HealthCareRegion r where a.hca_hcr_dr=r.hcr_rowid } ]
{

}
