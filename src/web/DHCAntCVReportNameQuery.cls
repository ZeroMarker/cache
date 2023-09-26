Class web.DHCAntCVReportNameQuery Extends %RegisteredObject
{

ClassMethod GetPanicName(DPRPType)
{
	q ##class(web.DHCAntCVOptions).GetCVTypeDesc(DPRPType)
		s DPRPTypeName=""
		i DPRPType=1 d
		.s DPRPTypeName="检验"
		i DPRPType=2 d
		.s DPRPTypeName="病理"
		i DPRPType=3 d
		.s DPRPTypeName="心电"
		i DPRPType=4 d
		.s DPRPTypeName="超声"
		i DPRPType=5 d
		.s DPRPTypeName="内镜"
		i DPRPType=6 d
		.s DPRPTypeName="放射"
		q DPRPTypeName
}

}
