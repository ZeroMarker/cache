/// 抗菌药物敏感试验
/// 取结果、对照
Class web.DHCMedDrugSen Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 30;

//w ##class(web.DHCMedDrugSen).GetTestRest("2233671||M010||1")

ClassMethod GetTestRest(TestSetRow)
{
		Set Config=##Class(websys.Configuration).%OpenId(1)
	    Set MEDDATA=Config.DataNamespace
	    Set LABDATA=Config.LabDataNamespace
	    Set CurrentNS=$ZNSPACE
	    d Config.%Close()
	    zn LABDATA
		s ldata=$$GetMic^DHCMedInfection(TestSetRow)
		zn CurrentNS
		s data=""
		f i=1:1:$l(ldata,$c(1))  d
		.s row=$p(ldata,$c(1),i)
		.q:row=""
		.s germ=$p(row,"^",1)
		.s anti=$p(row,"^",2)
		.s res=$p(row,"^",4)
		.q:germ=""!anti=""
		.s germTmp=$$ALPHAUP^SSUTIL4(germ)
		.s antiTmp=$$ALPHAUP^SSUTIL4(anti)
		.s germMap=$o(^DHCMInfPM(0,"Desc",germTmp,""))
		.s antiMap=$o(^DHCMInfAM(0,"AntiName",antiTmp,""))
		.i (germMap="")!(antiMap="") d
		..s tmpRow="" //"2^"_germ_"^"_anti_"^"_res
		.e  d
		..s tmpRow=germMap_"^"_antiMap_"^"_res //"1^"_germMap_"^"_antiMap_"^"_res
		.s:((data'="")&&(tmpRow'="")) data=data_$c(1)
		.s:tmpRow'="" data=data_tmpRow
		q data
}

}
