/// 知识库 药品说明书编辑器、检验编辑器、检查项目编辑器、心电编辑器、以及浏览器类
/// by caihz 2014-12-3
/// 修改：谷雪萍 2016-10-11 
/// 修改描述：加了配伍禁忌
Class web.DHCBL.KB.DHCBusMainNew Extends %RegisteredObject
{

/// 2017-12-07 by 谷雪萍
/// Description：获取菜单树,按字段'显示顺序'大小排序,用于BDPMain.js
/// Table：User.BDPMenu
/// Input：id:父节点rowid, SessionStr
/// Ohter: w ##class(web.DHCBL.KB.DHCBusMainNew).GetMenuNew("OPERATION","","Form")
ClassMethod GetMenuNew(code As %String, countInfo As %String, pointType As %String) As %String
{
	s myJsonStr = ""
	s jsonstr=""
	if (code="DRUG") //药品
	{
		s countFreq=0,countPreMet=0,countIndic=0,countUsage=0,countContr=0,countInterEach=0,countTaboo=0,
		countAdvRea=0,countMatNeAt=0,countSolvent=0,countDrgAlone=0,countEleCon=0,countMenstruum=0,countMustDrug=0,
		countAssDrugNum=0,countRepeat=0,countProcessingAct=0,countDrippingSpeed=0
		s len=$Length(countInfo,"^")
		for i=1:1:len
		{
			s info=$p(countInfo,"^",i)
			s desc = $p(info,"#",1)
			s count = $p(info,"#",2)
			if (desc="用药频率"){				
				s countFreq=count
			}
			if (desc="给药途径"){
				s countPreMet=count
			}
			if (desc="适应证"){
				s countIndic=count
			}
			if (desc="用法用量"){
				s countUsage=count
			}
			if (desc="禁忌证"){
				s countContr=count
			} 
			if (desc="相互作用"){
				s countInterEach=count
			}
			if (desc="配伍禁忌"){
				s countTaboo=count
			}
			if (desc="不良反应"){
				s countAdvRea=count
			} 
			if (desc="注意事项"){
				s countMatNeAt=count
			}
			if (desc="浓度"){
				s countSolvent=count
			} 
			if (desc="可配伍药品"){
				s countDrgAlone=count
			} 
			if (desc="成分含量(g)"){
				s countEleCon=count
			}
			if (desc="溶媒量"){
				s countMenstruum=count
			} 
			if (desc="联合用药"){
				s countMustDrug=count
			}
			if (desc="辅助用药个数"){
				s countAssDrugNum=count
			} 
			if (desc="重复用药"){
				s countRepeat=count
			}
			if (desc="炮制作用"){
				s countProcessingAct=count
			} 
			if (desc="滴速"){
				s countDrippingSpeed=count
			}  
		}
		/*s myJsonStr = "["
		_"{""id"":""1"",""text"":""成分含量(g)"",""count"":"""_countEleCon_""",""icon"":""../scripts/bdp/Framework/imgs/KB/zzndhl.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphelecon.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""2"",""text"":""适应证"",""count"":"""_countIndic_""",""icon"":""../scripts/bdp/Framework/imgs/KB/syz.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphdrugdiseaseind.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""3"",""text"":""用法用量"",""count"":"""_countUsage_""",""icon"":""../scripts/bdp/Framework/imgs/KB/yfyl.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphusagedosage.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""4"",""text"":""溶媒量"",""count"":"""_countMenstruum_""",""icon"":""../scripts/bdp/Framework/imgs/KB/rml.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphmenstruumqty.csp"",""leaf"":true,""_parentId"":""""},"
	    _"{""id"":""5"",""text"":""浓度"",""count"":"""_countSolvent_""",""icon"":""../scripts/bdp/Framework/imgs/KB/lcyy.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphdrgsolvent.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""6"",""text"":""给药途径"",""count"":"""_countPreMet_""",""icon"":""../scripts/bdp/Framework/imgs/KB/yyff.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphdiseaseuse.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""7"",""text"":""用药频率"",""count"":"""_countFreq_""",""icon"":""../scripts/bdp/Framework/imgs/KB/yypl.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphdiseasefreq.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""8"",""text"":""滴速"",""count"":"""_countDrippingSpeed_""",""icon"":""../scripts/bdp/Framework/imgs/KB/ds.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphdrippingspeed.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""9"",""text"":""不良反应"",""count"":"""_countAdvRea_""",""icon"":""../scripts/bdp/Framework/imgs/KB/blfy.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphdar.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""10"",""text"":""禁忌证"",""count"":"""_countContr_""",""icon"":""../scripts/bdp/Framework/imgs/KB/jjz.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphdrugdiseasecon.csp"",""leaf"":true,""_parentId"":""""},"		
		_"{""id"":""11"",""text"":""配伍禁忌"",""count"":"""_countTaboo_""",""icon"":""../scripts/bdp/Framework/imgs/KB/jj.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphdrugcontrain.csp"",""leaf"":true,""_parentId"":""""},"		
		_"{""id"":""12"",""text"":""注意事项"",""count"":"""_countMatNeAt_""",""icon"":""../scripts/bdp/Framework/imgs/KB/zysx.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphdmha.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""13"",""text"":""相互作用"",""count"":"""_countInterEach_""",""icon"":""../scripts/bdp/Framework/imgs/KB/xhzy.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphdiseaseinteract.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""14"",""text"":""可配伍药品"",""count"":"""_countDrgAlone_""",""icon"":""../scripts/bdp/Framework/imgs/KB/ddyy.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphdrgalone.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""15"",""text"":""联合用药"",""count"":"""_countMustDrug_""",""icon"":""../scripts/bdp/Framework/imgs/KB/lhyy.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphmustdrug.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""16"",""text"":""辅助用药个数"",""count"":"""_countAssDrugNum_""",""icon"":""../scripts/bdp/Framework/imgs/KB/fzyygs.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphassdrugnum.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""17"",""text"":""重复用药"",""count"":"""_countRepeat_""",""icon"":""../scripts/bdp/Framework/imgs/KB/cfyy.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphrepeatitm.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""18"",""text"":""炮制作用"",""count"":"""_countProcessingAct_""",""icon"":""../scripts/bdp/Framework/imgs/KB/pzzy.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphprocessingact.csp"",""leaf"":true,""_parentId"":""""}]"
		//_"{""id"":""10"",""text"":""医嘱优先级"",""icon"":""../scripts/bdp/Framework/imgs/KB/yzyxj.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseasePriority"",""leaf"":true}]"*/
	}
	if (code="LAB")  //检验
	{
		s countLabIndic=0,countLabContr=0,countLabClinical=0,countLabInterEach=0,countLabMatNeAt=0,countLabResultDiag=0
		s len=$Length(countInfo,"^")
		for i=1:1:len
		{
			s info=$p(countInfo,"^",i)
			s desc = $p(info,"#",1)
			s count = $p(info,"#",2)
			if (desc="适应证"){
				s countLabIndic=count
			}
			if (desc="禁忌证"){
				s countLabContr=count
			}
			if (desc="临床意义"){
				s countLabClinical=count
			}
			if (desc="相互作用"){
				s countLabInterEach=count
			}
			if (desc="注意事项"){
				s countLabMatNeAt=count
			}
			if (desc="检验结果辅助诊断"){
				s countLabResultDiag=count
			}
		}
		/*s myJsonStr = "["
		_"{""id"":""1"",""text"":""适应证"",""count"":"""_countLabIndic_""",""icon"":""../scripts/bdp/Framework/imgs/KB/syz.png"",""myhref"":""../csp/dhc.bdp.kb.dhclabdiseaseind.csp"",""leaf"":true,""_parentId"":""""},"	
		_"{""id"":""2"",""text"":""禁忌证"",""count"":"""_countLabContr_""",""icon"":""../scripts/bdp/Framework/imgs/KB/jjz.png"",""myhref"":""../csp/dhc.bdp.kb.dhclabdiseasecon.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""3"",""text"":""临床意义"",""count"":"""_countLabClinical_""",""icon"":""../scripts/bdp/Framework/imgs/KB/lcyy.png"",""myhref"":""../csp/dhc.bdp.kb.dhclabclinical.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""4"",""text"":""相互作用"",""count"":"""_countLabInterEach_""",""icon"":""../scripts/bdp/Framework/imgs/KB/xhzy.png"",""myhref"":""../csp/dhc.bdp.kb.dhclabdiseaseinteract.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""5"",""text"":""注意事项"",""count"":"""_countLabMatNeAt_""",""icon"":""../scripts/bdp/Framework/imgs/KB/zysx.png"",""myhref"":""../csp/dhc.bdp.kb.dhclabmha.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""6"",""text"":""检验结果辅助诊断"",""count"":"""_countLabResultDiag_""",""icon"":""../scripts/bdp/Framework/imgs/KB/fzzd.png"",""myhref"":""../csp/dhc.bdp.kb.dhcphlibresultdiag.csp"",""leaf"":true,""_parentId"":""""}]"*/
	}
	if (code="ULTR") || (code="RADI") || (code="ENDO") //检查 超声，胃镜，放射
	{
		s countCheckIndic=0,countCheckContr=0,countCheckAdvRea=0,countCheckMatNeAt=0,countCheckClinical=0,countCheckInterEach=0
		s len=$Length(countInfo,"^")
		for i=1:1:len
		{
			s info=$p(countInfo,"^",i)
			s desc = $p(info,"#",1)
			s count = $p(info,"#",2)
			if (desc="适应证"){
				s countCheckIndic=count
			}
			if (desc="禁忌证"){
				s countCheckContr=count
			}
			if (desc="不良反应"){
				s countCheckAdvRea=count
			}
			if (desc="注意事项"){
				s countCheckMatNeAt=count
			}
			if (desc="临床意义"){
				s countCheckClinical=count
			}
			if (desc="相互作用"){
				s countCheckInterEach=count
			}
		}
		/*s myJsonStr = "["
		
		_"{""id"":""1"",""text"":""适应证"",""count"":"""_countCheckIndic_""",""icon"":""../scripts/bdp/Framework/imgs/KB/syz.png"",""myhref"":""../csp/dhc.bdp.kb.dhccheckdiseaseind.csp"",""leaf"":true,""_parentId"":""""},"	
		_"{""id"":""2"",""text"":""禁忌证"",""count"":"""_countCheckContr_""",""icon"":""../scripts/bdp/Framework/imgs/KB/jjz.png"",""myhref"":""../csp/dhc.bdp.kb.dhccheckdiseasecon.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""3"",""text"":""不良反应"",""count"":"""_countCheckAdvRea_""",""icon"":""../scripts/bdp/Framework/imgs/KB/blfy.png"",""myhref"":""../csp/dhc.bdp.kb.dhccheckar.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""4"",""text"":""注意事项"",""count"":"""_countCheckMatNeAt_""",""icon"":""../scripts/bdp/Framework/imgs/KB/zysx.png"",""myhref"":""../csp/dhc.bdp.kb.dhccheckmha.csp"",""leaf"":true,""_parentId"":""""}]"*/
	}
	if (code="ELECT") //心电
	{
		s countELECTIndic=0,countELECTContr=0,countELECTInterEach=0,countELECTAdvRea=0,countELECTMatNeAt=0,countELECTClinical=0
		s len=$Length(countInfo,"^")
		for i=1:1:len
		{
			s info=$p(countInfo,"^",i)
			s desc = $p(info,"#",1)
			s count = $p(info,"#",2)
			if (desc="适应证"){
				s countELECTIndic=count
			}
			if (desc="禁忌证"){
				s countELECTContr=count
			}
			if (desc="相互作用"){
				s countELECTInterEach=count
			}
			if (desc="不良反应"){
				s countELECTAdvRea=count
			}
			if (desc="注意事项"){
				s countELECTMatNeAt=count
			}
			if (desc="临床意义"){
				s countELECTClinical=count
			}
		}
		/*s myJsonStr = "["
		
		_"{""id"":""1"",""text"":""适应证"",""count"":"""_countELECTIndic_""",""icon"":""../scripts/bdp/Framework/imgs/KB/syz.png"",""myhref"":""../csp/dhc.bdp.kb.dhcecgdiseaseind.csp"",""leaf"":true,""_parentId"":""""},"	
		_"{""id"":""2"",""text"":""禁忌证"",""count"":"""_countELECTContr_""",""icon"":""../scripts/bdp/Framework/imgs/KB/jjz.png"",""myhref"":""../csp/dhc.bdp.kb.dhcecgdiseasecon.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""3"",""text"":""相互作用"",""count"":"""_countELECTInterEach_""",""icon"":""../scripts/bdp/Framework/imgs/KB/xhzy.png"",""myhref"":""../csp/dhc.bdp.kb.dhcecginteract.csp"",""leaf"":true,""_parentId"":""""},"
		_"{""id"":""4"",""text"":""不良反应"",""count"":"""_countELECTAdvRea_""",""icon"":""../scripts/bdp/Framework/imgs/KB/blfy.png"",""myhref"":""../csp/dhc.bdp.kb.dhcecgar.csp"",""leaf"":true,""_parentId"":""""},"		
		_"{""id"":""5"",""text"":""注意事项"",""count"":"""_countELECTMatNeAt_""",""icon"":""../scripts/bdp/Framework/imgs/KB/zysx.png"",""myhref"":""../csp/dhc.bdp.kb.dhcecgmha.csp"",""leaf"":true,""_parentId"":""""}]"*/
	}
	if (code="OPERATION") //手术
	{
		s countOPERRemind=0,countPreoperLab=0,countPreoperLabContr=0,countPreoperCheck=0,countPreoperCheckContr=0
		s len=$Length(countInfo,"^")
		for i=1:1:len
		{
			s info=$p(countInfo,"^",i)
			s desc = $p(info,"#",1)
			s count = $p(info,"#",2)
			if (desc="高危提醒"){
				s countOPERRemind=count
			}
			if (desc="术前检验"){
				s countPreoperLab=count
			}
			if (desc="术前检验质控"){
				s countPreoperLabContr=count
			}
			if (desc="术前检查"){
				s countPreoperCheck=count
			}
			if (desc="术前检查质控"){
				s countPreoperCheckContr=count
			}
			
		}
		/*s myJsonStr = "["
		_"{""id"":""1"",""text"":""高危提醒"",""count"":"""_countOPERRemind_""",""icon"":""../scripts/bdp/Framework/imgs/KB/gwtx.png"",""myhref"":""../csp/dhc.bdp.kb.dhcoperremind.csp"",""leaf"":true,""_parentId"":""""}]"	*/

	}
	if (code="TREAT") //治疗项目编辑器
	{
		s countTreatIndic=0,countTreatContr=0
		s len=$Length(countInfo,"^")
		for i=1:1:len
		{
			s info=$p(countInfo,"^",i)
			s desc = $p(info,"#",1)
			s count = $p(info,"#",2)
			if (desc="适应证"){
				s countTreatIndic=count
			}
			if (desc="禁忌证"){
				s countTreatContr=count
			}
		}
		/*s myJsonStr = "["
		
		_"{""id"":""1"",""text"":""适应证"",""count"":"""_countTreatIndic_""",""icon"":""../scripts/bdp/Framework/imgs/KB/syz.png"",""myhref"":""../csp/dhc.bdp.kb.dhccheckdiseaseind.csp"",""leaf"":true,""_parentId"":""""},"	
		_"{""id"":""2"",""text"":""禁忌证"",""count"":"""_countTreatContr_""",""icon"":""../scripts/bdp/Framework/imgs/KB/jjz.png"",""myhref"":""../csp/dhc.bdp.kb.dhccheckdiseasecon.csp"",""leaf"":true,""_parentId"":""""}]"*/
	}
	
	s order=0
	for 
	{
		s order=$o(^DHCPHPINL(0,"Order",order))
		q:order=""
		s PINLRowID=0
		for 
		{
			s PINLRowID=$o(^DHCPHPINL(0,"Order",order,PINLRowID))
			q:PINLRowID=""
			s PINLCode=$p($g(^DHCPHPINL(PINLRowID)),"^",1)
			s PINLDesc=$p($g(^DHCPHPINL(PINLRowID)),"^",2)	
			s PINLIcon=$p($g(^DHCPHPINL(PINLRowID)),"^",6)
			s PHLIRowId=$p($g(^DHCPHPINL(PINLRowID)),"^",5)
			s myhref=$p($g(^DHCPHPINL(PINLRowID)),"^",11)
			s PINLGenFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",9)
			s PINLProFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",10)
			continue:(pointType="Form")&(PINLGenFlag="N")
			continue:(pointType="ProName")&(PINLProFlag="N")
			continue:PHLIRowId=""
		
			s PHLICode=$p($g(^DHCPHLIBL(PHLIRowId)),"^",1)
			if (PHLICode=code)
			{
				s mycount=""
				if (code="DRUG") //药品
				{

					if (PINLDesc="用药频率"){
						s myhref="../csp/dhc.bdp.kb.dhcphdiseasefreq.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/yypl.png"
						s mycount=countFreq
					}
					if (PINLDesc="给药途径"){
						s myhref="../csp/dhc.bdp.kb.dhcphdiseaseuse.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/yyff.png"
						s mycount=countPreMet
					}
					if (PINLDesc="适应证"){
						s myhref="../csp/dhc.bdp.kb.dhcphdrugdiseaseind.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/syz.png"
						s mycount=countIndic
					}
					if (PINLDesc="用法用量"){
						s myhref="../csp/dhc.bdp.kb.dhcphusagedosage.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/yfyl.png"
						s mycount=countUsage
					}
					if (PINLDesc="禁忌证"){
						s myhref="../csp/dhc.bdp.kb.dhcphdrugdiseasecon.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/jjz.png"
						s mycount=countContr
					} 
					if (PINLDesc="相互作用"){
						s myhref="../csp/dhc.bdp.kb.dhcphdiseaseinteract.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/xhzy.png"
						s mycount=countInterEach
					}
					if (PINLDesc="配伍禁忌"){
						s myhref="../csp/dhc.bdp.kb.dhcphdrugcontrain.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/jj.png"
						s mycount=countTaboo
					}
					if (PINLDesc="不良反应"){
						s myhref="../csp/dhc.bdp.kb.dhcphdar.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/blfy.png"
						s mycount=countAdvRea
					} 
					if (PINLDesc="注意事项"){
						s myhref="../csp/dhc.bdp.kb.dhcphdmha.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/zysx.png"
						s mycount=countMatNeAt
					}
					if (PINLDesc="浓度"){
						s myhref="../csp/dhc.bdp.kb.dhcphdrgsolvent.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/lcyy.png"
						s mycount=countSolvent
					} 
					if (PINLDesc="可配伍药品"){
						s myhref="../csp/dhc.bdp.kb.dhcphdrgalone.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/ddyy.png"
						s mycount=countDrgAlone
					} 
					if (PINLDesc="成分含量(g)"){
						s myhref="../csp/dhc.bdp.kb.dhcphelecon.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/zzndhl.png"
						s mycount=countEleCon
					}
					if (PINLDesc="溶媒量"){
						s myhref="../csp/dhc.bdp.kb.dhcphmenstruumqty.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/rml.png"
						s mycount=countMenstruum
					} 
					if (PINLDesc="联合用药"){
						s myhref="../csp/dhc.bdp.kb.dhcphmustdrug.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/lhyy.png"
						s mycount=countMustDrug
					}
					if (PINLDesc="辅助用药个数"){
						s myhref="../csp/dhc.bdp.kb.dhcphassdrugnum.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/fzyygs.png"
						s mycount=countAssDrugNum
					} 
					if (PINLDesc="重复用药"){
						s myhref="../csp/dhc.bdp.kb.dhcphrepeatitm.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/cfyy.png"
						s mycount=countRepeat
					}
					if (PINLDesc="炮制作用"){
						s myhref="../csp/dhc.bdp.kb.dhcphprocessingact.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/pzzy.png"
						s mycount=countProcessingAct
					} 
					if (PINLDesc="滴速"){
						s myhref="../csp/dhc.bdp.kb.dhcphdrippingspeed.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/ds.png"
						s mycount=countDrippingSpeed
					}  
				}
				
				if (code="LAB") //检验
				{
		    
					if (PINLDesc="适应证"){
						s myhref="../csp/dhc.bdp.kb.dhclabdiseaseind.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/syz.png"
						s mycount=countLabIndic
					}
					if (PINLDesc="禁忌证"){
						s myhref="../csp/dhc.bdp.kb.dhclabdiseasecon.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/jjz.png"
						s mycount=countLabContr
					}
					if (PINLDesc="临床意义"){
						s myhref="../csp/dhc.bdp.kb.dhclabclinical.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/lcyy.png"
						s mycount=countLabClinical
					}
					if (PINLDesc="相互作用"){
						s myhref="../csp/dhc.bdp.kb.dhclabdiseaseinteract.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/xhzy.png"
						s mycount=countLabInterEach
					}
					if (PINLDesc="注意事项"){
						s myhref="../csp/dhc.bdp.kb.dhclabmha.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/zysx.png"
						s mycount=countLabMatNeAt
					} 
					if (PINLDesc="检验结果辅助诊断"){
						s myhref="../csp/dhc.bdp.kb.dhcphlibresultdiag.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/fzzd.png"
						s mycount=countLabResultDiag
					}
				
				}
				
				if ((code="ULTR") || (code="RADI") || (code="ENDO")) //检查 超声，胃镜，放射
				{
							    
					if (PINLDesc="适应证"){
						s myhref="../csp/dhc.bdp.kb.dhccheckdiseaseind.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/syz.png"
						s mycount=countCheckIndic
					}
					if (PINLDesc="禁忌证"){
						s myhref="../csp/dhc.bdp.kb.dhccheckdiseasecon.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/jjz.png"
						s mycount=countCheckContr
					}
					if (PINLDesc="不良反应"){
						s myhref="../csp/dhc.bdp.kb.dhccheckar.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/blfy.png"
						s mycount=countCheckAdvRea
					}
					if (PINLDesc="注意事项"){
						s myhref="../csp/dhc.bdp.kb.dhccheckmha.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/zysx.png"
						s mycount=countCheckMatNeAt
					}
					if (PINLDesc="临床意义"){   //20200728-深圳肿瘤加临床意义、相互作用页签
						s myhref="../csp/dhc.bdp.kb.dhccheckclinical.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/lcyy.png"
						s mycount=countCheckClinical
					}
					if (PINLDesc="相互作用"){  //20200728-深圳肿瘤加临床意义、相互作用页签
						s myhref="../csp/dhc.bdp.kb.dhccheckinteract.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/xhzy.png"
						s mycount=countCheckInterEach
					}
				}
				
				if (code="ELECT") //心电
				{
					if (PINLDesc="适应证"){
						s myhref="../csp/dhc.bdp.kb.dhcecgdiseaseind.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/syz.png"
						s mycount=countELECTIndic
					}
					if (PINLDesc="禁忌证"){
						s myhref="../csp/dhc.bdp.kb.dhcecgdiseasecon.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/jjz.png"
						s mycount=countELECTContr
					}
					if (PINLDesc="相互作用"){
						s myhref="../csp/dhc.bdp.kb.dhcecginteract.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/xhzy.png"
						s mycount=countELECTInterEach
					}
					if (PINLDesc="不良反应"){
						s myhref="../csp/dhc.bdp.kb.dhcecgar.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/blfy.png"
						s mycount=countELECTAdvRea
					}
					if (PINLDesc="注意事项"){
						s myhref="../csp/dhc.bdp.kb.dhcecgmha.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/zysx.png"
						s mycount=countELECTMatNeAt
					}
					if (PINLDesc="临床意义"){ //20200728-深圳肿瘤加临床意义、相互作用页签
						s myhref="../csp/dhc.bdp.kb.dhccheckclinical.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/lcyy.png"
						s mycount=countELECTClinical
					}
				}

				if (code="OPERATION")  //手术
				{
					if (PINLDesc="高危提醒"){
						s myhref="../csp/dhc.bdp.kb.dhcoperremind.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/gwtx.png"
						s mycount=countOPERRemind
					}
					if (PINLDesc="术前检验"){
						s myhref="../csp/dhc.bdp.kb.dhcpreoperlab.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/lcyy.png"
						s mycount=countPreoperLab
					}
					if (PINLDesc="术前检验质控"){
						s myhref="../csp/dhc.bdp.kb.dhcpreoperlabcontr.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/xhzy.png"
						s mycount=countPreoperLabContr
					}
					if (PINLDesc="术前检查"){
						s myhref="../csp/dhc.bdp.kb.dhcpreopercheck.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/zysx.png"
						s mycount=countPreoperCheck
					} 
					if (PINLDesc="术前检查质控"){
						s myhref="../csp/dhc.bdp.kb.dhcpreopercheckcontr.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/fzzd.png"
						s mycount=countPreoperCheckContr
					}

				}
				if (code="TREAT") //治疗项目
				{
							    
					if (PINLDesc="适应证"){
						s myhref="../csp/dhc.bdp.kb.dhccheckdiseaseind.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/syz.png"
						s mycount=countTreatIndic
					}
					if (PINLDesc="禁忌证"){
						s myhref="../csp/dhc.bdp.kb.dhccheckdiseasecon.csp"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/jjz.png"
						s mycount=countTreatContr
					}
				}
				
				s mainstr="{""id"":"""_PINLRowID_""",""text"":"""_PINLDesc_""",""count"":"""_mycount_""",""icon"":"""_PINLIcon_""",""myhref"":"""_myhref_""",""_parentId"":""""}"
			    if (jsonstr'="")
				{ 
					s jsonstr=jsonstr_","_mainstr
				}
				else
				{
					s jsonstr=mainstr
				}
						
							
			}
		}
						

		
	}
	s myJsonStr="["_jsonstr_"]"

	q myJsonStr
}

/// Creator：谷雪萍
/// CreatDate: 2017-12-06
/// Description：获取主界面信息
/// Input：GenDr-通用名ID，PointerType-类别，PointerDr-剂型ID
/// w ##class(web.DHCBL.KB.DHCBusMainNew).GetDrugBookListNew(16,"Form",2)
ClassMethod GetDrugBookListNew(GenDr As %String, PointerType As %String, PointerDr As %String) As %String
{
	s jsonstr=""
	s result=""	
	s total=0
	if (GenDr="")||(PointerType="")||(PointerDr="")
	{
		q "{""rows"":[], ""total"":0}"
		
	}
	s countPreMet=0,countFreq=0,countUsage=0,countIndic=0,countContr=0,countTaboo=0,countInterEach=0,countAdvRea=0,countMatNeAt=0,countSolvent=0,countDrgAlone=0,countEleCon=0,countMenstruum=0,countMustDrug=0,countAssDrugNum=0,countRepeat=0,countProcessingAct=0,countDrippingSpeed=0 //药品
	s countLabIndic=0,countLabContr=0,countLabClinical=0,countLabInterEach=0,countLabMatNeAt=0,countLabResultDiag=0 //检验
	s countCheckContr=0,countCheckIndic=0,countCheckMatNeAt=0,countCheckAdvRea=0,countCheckClinical=0,countCheckInterEach=0 //检查
	s countELECTIndic=0,countELECTContr=0,countELECTInterEach=0,countELECTMatNeAt=0,countELECTAdvRea=0 //心电
	s countOPERRemind=0,countPreoperLab=0,countPreoperLabContr=0,countPreoperCheck=0,countPreoperCheckContr=0 //手术
	
	
	s parentPreMet="",parentFreq="",parentUsage="",parentIndic="",parentContr="",parentTaboo="",parentInterEach="",parentAdvRea="",parentMatNeAt="",parentSolvent="",parentDrgAlone="",parentEleCon="",parentMenstruum="",parentMustDrug="",parentAssDrugNum="",parentRepeat="",parentProcessingAct="",parentDrippingSpeed="" //药品
	s parentLabIndic="",parentLabContr="",parentLabClinical="",parentLabInterEach="",parentLabMatNeAt="",parentLabResultDiag="" //检验
	s parentCheckContr="",parentCheckIndic="",parentCheckMatNeAt="",parentCheckAdvRea="",parentCheckClinical="",parentCheckInterEach="" //检查
	s parentELECTIndic="",parentELECTContr="",parentELECTInterEach="",parentELECTMatNeAt="",parentELECTAdvRea="" //心电
	s parentOPERRemind="",parentPreoperLab="",parentPreoperLabContr="",parentPreoperCheck="",parentPreoperCheckContr="" //手术
	s parentStr=""
	//s TypeDr=$o(^DHCPHPINL("0","Code","USAGE",0))
	s PDFInstDr=0
	for{
		s PDFInstDr=$o(^DHCPHINSTRUC("0","GP",GenDr,PointerType,PointerDr,PDFInstDr))	q:PDFInstDr=""
		
		s PHINSTTypeDr=$p(^DHCPHINSTRUC(PDFInstDr),"^",1)
		
		//谷雪萍 2020-04-21 修改BUG：药品说明书编辑器-按药品通用名，界面显示了浓度、溶媒量，但点击编辑的时候，目录中没有这2项
		continue:PHINSTTypeDr=""
		s PHLIRowId=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",5)   //知识库标识id
		continue:PHLIRowId=""
		s PHLICode=$p($g(^DHCPHLIBL(PHLIRowId)),"^",1)   //知识库标识代码
		if (PHLICode="DRUG")  //如果是药品则判断在知识库目录字典是否设置为显示
		{
			s PINLGenFlag=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",9)  //在药品通用名显示
			s PINLProFlag=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",10)  //在药品商品名显示
			continue:(PointerType="Form")&(PINLGenFlag="N")
			continue:(PointerType="ProName")&(PINLProFlag="N")
		}

		s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
		s PHINSTSoft=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",3)  //顺序
		s id = PDFInstDr
		s PHINSTGroupDesc = $p($g(^DHCPHPINL(PHINSTTypeDr)),"^",2)
		s PHINSTSoft =""
		
		if (PINLCode="PreMet") ;给药途径
		{	
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDiseaseUse).GetData(PDFInstDr)
			//s PHINSTSoft = 6
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countPreMet=countPreMet+1
			s PHINSTCount=countPreMet
			s parentPreMet="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"

		}
		if (PINLCode="Freq") ;用药频率
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDiseaseFreq).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 7
			s countFreq=countFreq+1
			s PHINSTCount=countFreq
			s parentFreq="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="Usage") ;用法用量
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHUsageDosage).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s PHUSDORowId = $o(^DHCPHUSDO("0","Inst",PDFInstDr,0)) continue:PHUSDORowId=""
			//s PHINSTSoft = 3
			s countUsage=countUsage+1
			s PHINSTCount=countUsage
			s parentUsage="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="Indic") ;适应症
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrugDiseaseI).GetIndData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 2
			s countIndic=countIndic+1
			s PHINSTCount=countIndic
			s parentIndic="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="Contr") ;禁忌症
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).GetConData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 10
			s countContr=countContr+1
			s PHINSTCount=countContr
			s parentContr="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="Taboo") ;配伍禁忌
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrugContrain).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 11
			s countTaboo=countTaboo+1
			s PHINSTCount=countTaboo
			s parentTaboo="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="InterEach") ;相互作用
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDiseaseInteract).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 13
			s countInterEach=countInterEach+1
			s PHINSTCount=countInterEach
			s parentInterEach="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="AdvRea") ;不良反应
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDAR).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 9
			s countAdvRea=countAdvRea+1
			s PHINSTCount=countAdvRea
			s parentAdvRea="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"

		}
		if (PINLCode="MatNeAt") ;注意事项
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDMHA).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 12
			s countMatNeAt=countMatNeAt+1
			s PHINSTCount=countMatNeAt
			s parentMatNeAt="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"

		}
		if (PINLCode="Solvent") ;浓度
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrgSolvent).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 5
			s countSolvent=countSolvent+1
			s PHINSTCount=countSolvent
			s parentSolvent="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="DrgAlone") ;可配伍药品
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrgAlone).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 14
			s countDrgAlone=countDrgAlone+1
			s PHINSTCount=countDrgAlone
			s parentDrgAlone="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="EleCon") ;成分含量(g)
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHEleCon).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 1
			s countEleCon=countEleCon+1
			s PHINSTCount=countEleCon
			s parentEleCon="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="Menstruum") ;溶媒量
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHMenstruumQty).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 4
			s countMenstruum=countMenstruum+1
			s PHINSTCount=countMenstruum
			s parentMenstruum="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"
			
		}
		if (PINLCode="MustDrug") ;联合用药
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHMustDrug).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 15
			s countMustDrug=countMustDrug+1
			s PHINSTCount=countMustDrug
			s parentMustDrug="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"
			
		}
		if (PINLCode="AssDrugNum") ;辅助用药个数
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHAssDrugNum).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 16
			s countAssDrugNum=countAssDrugNum+1
			s PHINSTCount=countAssDrugNum
			s parentAssDrugNum="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"

		}
		if (PINLCode="Repeat") ;重复用药
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHRepeatItm).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 17
			s countRepeat=countRepeat+1
			s PHINSTCount=countRepeat
			s parentRepeat="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"

		}
		if (PINLCode="ProcessingAct") ;炮制作用
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHProcessingAct).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 18
			s countProcessingAct=countProcessingAct+1
			s PHINSTCount=countProcessingAct
			s parentProcessingAct="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="DrippingSpeed") ;滴速
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrippingSpeed).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			//s PHINSTSoft = 8
			s countDrippingSpeed=countDrippingSpeed+1
			s PHINSTCount=countDrippingSpeed
			s parentDrippingSpeed="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""",""_parentId"":""""}"

		}
		/*if (PINLCode="Priority") ;医嘱优先级
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDiseasePriority).GetData(PDFInstDr)
			s PHINSTSoft = 10
		}*/
		//检验
		if (PINLCode="LabContr") ;禁忌证
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCLABDiseaseC).GetConData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countLabIndic=countLabIndic+1
			s PHINSTCount=countLabIndic
			s parentLabIndic="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="LabIndic") ;适应证
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCLABDiseaseI).GetIndData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countLabContr=countLabContr+1
			s PHINSTCount=countLabContr
			s parentLabContr="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="LabClinical") ;临床意义
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCLabClinical).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countLabClinical=countLabClinical+1
			s PHINSTCount=countLabClinical
			s parentLabClinical="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
			if (PINLCode="LabInterEach") ;相互作用
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCLABDiseaseInteract).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countLabInterEach=countLabInterEach+1
			s PHINSTCount=countLabInterEach
			s parentLabInterEach="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="LabMatNeAt") ;注意事项
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCLABMHA).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countLabMatNeAt=countLabMatNeAt+1
			s PHINSTCount=countLabMatNeAt
			s parentLabMatNeAt="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="LabResultDiag") ;检验结果辅助诊断
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHLibResultDiag).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countLabResultDiag=countLabResultDiag+1
			s PHINSTCount=countLabResultDiag
			s parentLabResultDiag="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		
		//检查项目
		
		if (PINLCode="RADIContr")||(PINLCode="ULTRContr")||(PINLCode="ENDOContr")||(PINLCode="CheckContr")||(PINLCode="TreatContr") ;禁忌证
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCCheckDiseaseC).GetConData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countCheckContr=countCheckContr+1
			s PHINSTCount=countCheckContr
			s parentCheckContr="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"

		}
		if (PINLCode="RADIIndic")||(PINLCode="ULTRIndic")||(PINLCode="ENDOIndic")||(PINLCode="CheckIndic")||(PINLCode="TreatIndic") ;适应证
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCCheckDiseaseI).GetIndData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countCheckIndic=countCheckIndic+1
			s PHINSTCount=countCheckIndic
			s parentCheckIndic="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="RADIMatNeAt")||(PINLCode="ULTRMatNeAt")||(PINLCode="ENDOMatNeAt")||(PINLCode="CheckMatNeAt") ;注意事项
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCCheckMHA).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countCheckMatNeAt=countCheckMatNeAt+1
			s PHINSTCount=countCheckMatNeAt
			s parentCheckMatNeAt="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="RADIAdvRea")||(PINLCode="ULTRAdvRea")||(PINLCode="ENDOAdvRea")||(PINLCode="CheckAdvRea") ;不良反应
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCCheckAR).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countCheckAdvRea=countCheckAdvRea+1
			s PHINSTCount=countCheckAdvRea
			s parentCheckAdvRea="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="RADIClinical")||(PINLCode="ULTRClinical")||(PINLCode="ENDOClinical")||(PINLCode="CheckClinical") ;临床意义
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCCheckClinical).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countCheckClinical=countCheckClinical+1
			s PHINSTCount=countCheckClinical
			s parentCheckClinical="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		if (PINLCode="RADIInterEach")||(PINLCode="ULTRInterEach")||(PINLCode="ENDOInterEach")||(PINLCode="CheckInterEach") ;相互作用
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCCheckInteract).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countCheckInterEach=countCheckInterEach+1
			s PHINSTCount=countCheckInterEach
			s parentCheckInterEach="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		//心电
		
		if (PINLCode="ELECTIndic") ;适应症
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCECGDiseaseI).GetIndData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countELECTIndic=countELECTIndic+1
			s PHINSTCount=countELECTIndic
			s parentELECTIndic="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"			
		}
		if (PINLCode="ELECTContr") ;禁忌症
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCECGDiseaseC).GetConData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countELECTContr=countELECTContr+1
			s PHINSTCount=countELECTContr
			s parentELECTContr="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"			
		}
		if (PINLCode="ELECTInterEach") ;相互作用
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCECGInteract).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countELECTInterEach=countELECTInterEach+1
			s PHINSTCount=countELECTInterEach
			s parentELECTInterEach="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"			
		}
		if (PINLCode="ELECTMatNeAt") ;注意事项
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCECGMHA).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countELECTMatNeAt=countELECTMatNeAt+1
			s PHINSTCount=countELECTMatNeAt
			s parentELECTMatNeAt="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"			
		}
		if (PINLCode="ELECTAdvRea") ;不良反应
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCECGAR).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countELECTAdvRea=countELECTAdvRea+1
			s PHINSTCount=countELECTAdvRea
			s parentELECTAdvRea="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"			
		}
		if (PINLCode="ELECTClinical") ;临床意义
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCCheckClinical).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countCheckClinical=countCheckClinical+1
			s PHINSTCount=countCheckClinical
			s parentCheckAdvRea="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		
		//手术
		
		if (PINLCode="OPERRemind") ;高危提醒
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCOPERRemind).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countOPERRemind=countOPERRemind+1
			s PHINSTCount=countOPERRemind
			s parentOPERRemind="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"			
		}
		if (PINLCode="PreoperLab") ;术前检验
		{
			s PHINSTDesc =##class(web.DHCBL.KB.DHCPreoperLab).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countPreoperLab=countPreoperLab+1
			s PHINSTCount=countPreoperLab
			s parentPreoperLab="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"			
		}
		if (PINLCode="PreoperLabContr") ;术前检验质控
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPreoperLabContr).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countPreoperLabContr=countPreoperLabContr+1
			s PHINSTCount=countPreoperLabContr
			s parentPreoperLabContr="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"			
		}
		if (PINLCode="PreoperCheck") ;术前检查
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPreoperLab).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countPreoperCheck=countPreoperCheck+1
			s PHINSTCount=countPreoperCheck
			s parentPreoperCheck="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"			
		}
		if (PINLCode="PreoperCheckContr") ;术前检查质控
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPreoperLabContr).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countPreoperCheckContr=countPreoperCheckContr+1
			s PHINSTCount=countPreoperCheckContr
			s parentPreoperCheckContr="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"			
		}
		s parentId=""
		if (PHINSTGroupDesc'="")
		{	
			s mainstr="{""id"":"""_id_""",""PHINSTDesc"":"""_PHINSTDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""_PHINSTCount_""",""_parentId"":"""_PINLCode_"""}"
		    if (jsonstr'="")
			{ 
				s jsonstr=jsonstr_","_mainstr
			}
			else
			{
				s jsonstr=mainstr
			}
			s total=total+1
		}
		
	}
	// 药品的父节点
	s:(parentPreMet'="")&(jsonstr'="") jsonstr=jsonstr_","_parentPreMet
	s:(parentFreq'="")&(jsonstr'="") jsonstr=jsonstr_","_parentFreq
	s:(parentUsage'="")&(jsonstr'="") jsonstr=jsonstr_","_parentUsage
	s:(parentIndic'="")&(jsonstr'="") jsonstr=jsonstr_","_parentIndic
	s:(parentContr'="")&(jsonstr'="") jsonstr=jsonstr_","_parentContr
	s:(parentTaboo'="")&(jsonstr'="") jsonstr=jsonstr_","_parentTaboo
	s:(parentInterEach'="")&(jsonstr'="") jsonstr=jsonstr_","_parentInterEach
	s:(parentAdvRea'="")&(jsonstr'="") jsonstr=jsonstr_","_parentAdvRea
	s:(parentMatNeAt'="")&(jsonstr'="") jsonstr=jsonstr_","_parentMatNeAt
	s:(parentSolvent'="")&(jsonstr'="") jsonstr=jsonstr_","_parentSolvent
	s:(parentDrgAlone'="")&(jsonstr'="") jsonstr=jsonstr_","_parentDrgAlone
	s:(parentEleCon'="")&(jsonstr'="") jsonstr=jsonstr_","_parentEleCon
	s:(parentMenstruum'="")&(jsonstr'="") jsonstr=jsonstr_","_parentMenstruum
	s:(parentMustDrug'="")&(jsonstr'="") jsonstr=jsonstr_","_parentMustDrug
	s:(parentAssDrugNum'="")&(jsonstr'="") jsonstr=jsonstr_","_parentAssDrugNum
	s:(parentRepeat'="")&(jsonstr'="") jsonstr=jsonstr_","_parentRepeat
	s:(parentProcessingAct'="")&(jsonstr'="") jsonstr=jsonstr_","_parentProcessingAct
	s:(parentDrippingSpeed'="")&(jsonstr'="") jsonstr=jsonstr_","_parentDrippingSpeed	
	
	// 检验项目的父节点
	s:(parentLabIndic'="")&(jsonstr'="") jsonstr=jsonstr_","_parentLabIndic
	s:(parentLabContr'="")&(jsonstr'="") jsonstr=jsonstr_","_parentLabContr
	s:(parentLabClinical'="")&(jsonstr'="") jsonstr=jsonstr_","_parentLabClinical
	s:(parentLabInterEach'="")&(jsonstr'="") jsonstr=jsonstr_","_parentLabInterEach
	s:(parentLabMatNeAt'="")&(jsonstr'="") jsonstr=jsonstr_","_parentLabMatNeAt
	s:(parentLabResultDiag'="")&(jsonstr'="") jsonstr=jsonstr_","_parentLabResultDiag
	
	// 检查项目的父节点
	s:(parentCheckContr'="")&(jsonstr'="") jsonstr=jsonstr_","_parentCheckContr
	s:(parentCheckIndic'="")&(jsonstr'="") jsonstr=jsonstr_","_parentCheckIndic
	s:(parentCheckMatNeAt'="")&(jsonstr'="") jsonstr=jsonstr_","_parentCheckMatNeAt
	s:(parentCheckAdvRea'="")&(jsonstr'="") jsonstr=jsonstr_","_parentCheckAdvRea
	s:(parentCheckClinical'="")&(jsonstr'="") jsonstr=jsonstr_","_parentCheckClinical
	s:(parentCheckInterEach'="")&(jsonstr'="") jsonstr=jsonstr_","_parentCheckInterEach
		
	
	// 心电项目的父节点
	s:(parentELECTIndic'="")&(jsonstr'="") jsonstr=jsonstr_","_parentELECTIndic
	s:(parentELECTContr'="")&(jsonstr'="") jsonstr=jsonstr_","_parentELECTContr
	s:(parentELECTInterEach'="")&(jsonstr'="") jsonstr=jsonstr_","_parentELECTInterEach
	s:(parentELECTMatNeAt'="")&(jsonstr'="") jsonstr=jsonstr_","_parentELECTMatNeAt
	s:(parentELECTAdvRea'="")&(jsonstr'="") jsonstr=jsonstr_","_parentELECTAdvRea
	
	// 手术项目的父节点
	s:(parentOPERRemind'="")&(jsonstr'="") jsonstr=jsonstr_","_parentOPERRemind
	s:(parentPreoperLab'="")&(jsonstr'="") jsonstr=jsonstr_","_parentPreoperLab
	s:(parentPreoperLabContr'="")&(jsonstr'="") jsonstr=jsonstr_","_parentPreoperLabContr
	s:(parentPreoperCheck'="")&(jsonstr'="") jsonstr=jsonstr_","_parentPreoperCheck
	s:(parentPreoperCheckContr'="")&(jsonstr'="") jsonstr=jsonstr_","_parentPreoperCheckContr
	

    s result="{""rows"":["_jsonstr_"], ""total"":"_total_"}"
	q result
}

/// Creator：丁亚男
/// CreatDate: 2020-07-31
/// Description：获取主界面信息
/// Input：GenDr-通用名ID，PointerType-类别，PointerDr-剂型ID
/// w ##class(web.DHCBL.KB.DHCBusMainNew).GetDrugBookListForLab(16,"Form",2)
ClassMethod GetDrugBookListForLab(GenDr As %String, PointerType As %String, PointerDr As %String) As %String
{
	s jsonstr=""
	s result=""	
	s total=0
	if (GenDr="")||(PointerType="")||(PointerDr="")
	{
		q "{""rows"":[], ""total"":0}"
		
	}
	s countLabResultDiag=0 //检验
	s parentLabResultDiag="" //检验
	
	s parentStr=""
	//s TypeDr=$o(^DHCPHPINL("0","Code","USAGE",0))
	s PDFInstDr=0
	for{
		s PDFInstDr=$o(^DHCPHINSTRUC("0","GP",GenDr,PointerType,PointerDr,PDFInstDr))	q:PDFInstDr=""
		
		s PHINSTTypeDr=$p(^DHCPHINSTRUC(PDFInstDr),"^",1)
		
		//谷雪萍 2020-04-21 修改BUG：药品说明书编辑器-按药品通用名，界面显示了浓度、溶媒量，但点击编辑的时候，目录中没有这2项
		continue:PHINSTTypeDr=""
		s PHLIRowId=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",5)   //知识库标识id
		continue:PHLIRowId=""
		s PHLICode=$p($g(^DHCPHLIBL(PHLIRowId)),"^",1)   //知识库标识代码
		

		s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
		continue:PINLCode'="LabResultDiag"
		s PHINSTSoft=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",3)  //顺序
		s id = PDFInstDr
		s PHINSTGroupDesc = $p($g(^DHCPHPINL(PHINSTTypeDr)),"^",2)
		s PHINSTSoft =""
		
		
		//检验
		
		if (PINLCode="LabResultDiag") ;检验结果辅助诊断
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHLibResultDiag).GetData(PDFInstDr)
			s PHINSTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHINSTDesc)
			s countLabResultDiag=countLabResultDiag+1
			s PHINSTCount=countLabResultDiag
			s parentLabResultDiag="{""id"":"""_PINLCode_""",""PHINSTDesc"":"""_PHINSTGroupDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""",""PHINSTCount"":"""",""_parentId"":""""}"
		}
		
		

		s parentId=""
		if (PHINSTGroupDesc'="")
		{	
			s mainstr="{""id"":"""_id_""",""PHINSTDesc"":"""_PHINSTDesc_""",""PHINSTGroupDesc"":"""_PHINSTGroupDesc_""",""PHINSTSoft"":"""_PHINSTSoft_""",""PHINSTCount"":"""_PHINSTCount_""",""_parentId"":"""_PINLCode_"""}"
		    if (jsonstr'="")
			{ 
				s jsonstr=jsonstr_","_mainstr
			}
			else
			{
				s jsonstr=mainstr
			}
			s total=total+1
		}
		
	}
	
	
	// 检验项目的父节点
	s:(parentLabResultDiag'="")&(jsonstr'="") jsonstr=jsonstr_","_parentLabResultDiag
	
	

    s result="{""rows"":["_jsonstr_"], ""total"":"_total_"}"
	q result
}

/// 对JSON数据字符特殊字符处理
/// JSON 中的特殊字符
/// $c(13)
/// $c(10)
/// \
/// w ##class(web.DHCBL.KB.DHCBusMainNew).EvalJSON("a\")
ClassMethod EvalJSON(instr As %String) As %String
{
	;w ##class(web.DHCBL.MKB.TKBTrem).EvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr=$tr(mystr,"""","”")
	
	s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(13), "")
	
	s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10), "<br/>")
	
	s mystr = ##class(web.BDP.util.String).Replace(mystr,"\","\\")
	
	s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10,10,10), "")
	
	s mystr =##class(web.BDP.util.String).Replace(mystr,$c(9,9,9,9,9,9,9,9,9,9),"")
	
	q mystr
}

/// Creator:谷雪萍
/// CreatDate:2017-12-01
/// Description：根据知识库标识查询药品通用名关联字典表内容
/// Input: lib=DRUG/LAB/CHECK
/// Table：User.DHCGenLinkPointer
/// Return: json串
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).GetGenListNew("Drug","","","1","1")
ClassMethod GetGenListNew(lib, desc, point, cats, rows, page) As %String
{
	s jsonstr=""
	s result=""	
	s total=0
	//s:rows="NaN" rows=20
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s:lib'="" lib=$ZCONVERT(lib,"U")	
	s:desc'="" desc=$ZCONVERT(desc,"U")
	//s:pointer'="" text=$ZCONVERT(pointer,"U")
	s GlPRowId=0
	for  
	{	
		s GlPRowId=$o(^DHCGENLINP(GlPRowId)) q:(GlPRowId="")

		s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
		s GlPGenDrU=$ZCONVERT(GlPGenDr,"U")
		s PHEGDesc=""
		s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
		s PHEGDesc=##class(web.DHCBL.KB.DHCBusMainNew).EvalJSON(PHEGDesc)	
		s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7)
	 
		s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 药品
		s PHLICode1=$ZCONVERT(PHLICode,"U")	
		;b
		s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
		s PHEFDesc=""
		if (PHLICode1="DRUG")
		{
			s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2) //指针名称 
		}
		if (PHLICode1="LAB")
		{
			s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEGEN(GlPPointer)),"^",2) //指针名称 
		}
		if (PHLICode1="ULTR") || (PHLICode1="RADI") || (PHLICode1="ENDO") || (PHLICode1="ELECT") || (PHLICode1="OPERATION")|| (PHLICode1="TREAT")
		{
			s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEPA(GlPPointer)),"^",2) //指针名称 
		} 
		s PHEFDesc=##class(web.DHCBL.KB.DHCBusMainNew).EvalJSON(PHEFDesc)	
		
		s GlPPointerU=$ZCONVERT(GlPPointer,"U")
		s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
		continue:GlPActiveFlag="N"
		s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
		
		s PINYINPHEG=""
		s:desc'="" PINYINPHEG= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDesc))
		//s PINYINPHEF= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEFDesc))
		//别名查询
		s ALIASText1=""
		s ALIASText=""
		if (GlPGenDr'=""){
			for{
				s ALIASText=$o(^DHCPHEGALi(0,"GenText",GlPGenDr,ALIASText))
				q:ALIASText=""
				s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
			}
		}
		
		//类别
		s catflag=""
		if (cats'="")
		{
			s argsLen=$Length(cats,",")
			for i=1:1:argsLen   
			{
			  s cat=$p(cats,",",i)  
			  
			  if ($d(^DHCPHDGPi(0,"Cat",cat,GlPGenDr)))
			  {
				  s catflag="Y"
			  }
			}
		}
		else
		{
			s catflag="Y"	
		}
		s:PHEGDesc'="" PHEGDescU=$zconvert(PHEGDesc,"U")
		i (PHLICode1=lib)&((PHEGDescU[desc)||(ALIASText1[desc)||(PINYINPHEG[desc))&((GlPPointer=point)||(point=""))&(catflag="Y")   //条件
		{
			s total=total+1
		    if (total<stpage) continue
		    if (total<=endpage)
		    {
				s mainstr="{""GlPRowId"":"""_GlPRowId_""",""PHEGDesc"":"""_PHEGDesc_""",""GlPGenDr"":"""_GlPGenDr_""",""GlPPointer"":"""_GlPPointer_""",""PHEFDesc"":"""_PHEFDesc_"""}"
			    if (jsonstr'="")
				{ 
					s jsonstr=jsonstr_","_mainstr
				}
				else
				{
					s jsonstr=mainstr
				}
		    }
		}	
	}
	s result="{""rows"":["_jsonstr_"], ""total"":"_total_"}"
	q result
}

/// Creator:谷雪萍
/// CreatDate:2017-12-01
/// Description：商品名字典
/// Input: code, desc, form, rows, page
/// Table：User.DHCPHProName
/// Return: json串
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).GetProListNew("","","","1","1")
ClassMethod GetProListNew(code, desc, form, rows, page) As %String
{
	s jsonstr=""
	s result=""	
	s total=0
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	//s:pointer'="" text=$ZCONVERT(pointer,"U")
	s PHNRowId=0
	for  
	{	
		s PHNRowId=$o(^DHCPHPNA(PHNRowId)) q:PHNRowId="" 
		s strRowId = "{ID:"_PHNRowId_"}"
		//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
		//{
			s PHNCode=$p($g(^DHCPHPNA(PHNRowId)),"^",1)  //代码
			s PHNCodeU=$ZCONVERT(PHNCode,"U")
			s PHNDesc=$p($g(^DHCPHPNA(PHNRowId)),"^",2)  //描述
			s PHNDescU=$ZCONVERT(PHNDesc,"U")
			s PHNActiveFlag=$p($g(^DHCPHPNA(PHNRowId)),"^",3)  //是否可用
			continue:PHNActiveFlag="N"
			s PHNSysFlag=$p($g(^DHCPHPNA(PHNRowId)),"^",4)  //是否系统标识
			s FormDr=$p($g(^DHCPHPNA(PHNRowId)),"^",5)  //剂型
			s PHNFormDr=""
			s:FormDr'="" PHNFormDr=$p($g(^DHCPHEF(FormDr)),"^",2) 
			s PHNFactory=$p($g(^DHCPHPNA(PHNRowId)),"^",6)  //厂家
			s PHNGenericDr=$p($g(^DHCPHPNA(PHNRowId)),"^",7)  //通用名
			s:PHNGenericDr'="" PHNGenericDr=$p($g(^DHCPHEGEN(PHNGenericDr)),"^",2) 
			s PHNToxicity=$p($g(^DHCPHPNA(PHNRowId)),"^",8)  //毒性
			s:PHNToxicity'="" PHNToxicity=$p($g(^DHCPHTOX(PHNToxicity)),"^",2) 
			s PHNManfDR = $p($g(^DHCPHPNA(PHNRowId)),"^",10) //厂家字典
        	s:PHNManfDR'="" PHNManfDR=$p($g(^DHCPHMANF(PHNManfDR)),"^",2)
       		s PHNWholeFlag = $p($g(^DHCPHPNA(PHNRowId)),"^",9) //是否整支
			//别名查询
			s ALIASText1=""
			s AliasRowId=0
			for{
				s AliasRowId=$o(^User.BDPAliasI("DataRef","DHC_PHProName",PHNRowId,AliasRowId))
				q:AliasRowId=""
				S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
				s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				
			}
			
			s PINYIN=""
			if ((ALIASText1="")&(desc'=""))
			{
			 	s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHNDescU))
			}
			i (PHNCodeU[code)&((PHNDescU[desc)||(PINYIN[desc)||(ALIASText1[desc))&((FormDr=form)||(form=""))   //条件
			{
				s total=total+1
				if (total<stpage) continue
			    if (total<=endpage)
			    {
					s mainstr="{""PHNRowId"":"""_PHNRowId_""",""PHNDesc"":"""_PHNDesc_""",""PHNFormDr"":"""_PHNFormDr_""",""PHNFactory"":"""_PHNFactory_""",""PHNToxicity"":"""_PHNToxicity_""",""PHNManfDR"":"""_PHNManfDR_"""}"
				    if (jsonstr'="")
					{ 
						s jsonstr=jsonstr_","_mainstr
					}
					else
					{
						s jsonstr=mainstr
					}
		    	}
			}		
		//}
	}
	s result="{""rows"":["_jsonstr_"], ""total"":"_total_"}"
	q result
}

/// Creator:谷雪萍
/// CreatDate:2017-12-01
/// Description：剂型字典
/// Input: code, desc, form, rows, page
/// Table：User.DHCPHProName
/// Return: json串
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).GetGenFormCombo("","","","1","1")
ClassMethod GetGenFormCombo(code, desc) As %String
{
	s jsonstr=""
	s result=""
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s PHEFRowId=0
	for  
	{	
		s PHEFRowId=$o(^DHCPHEF(PHEFRowId)) q:PHEFRowId="" 
		s strRowId = "{ID:"_PHEFRowId_"}"

		s PHEFCode=$p($g(^DHCPHEF(PHEFRowId)),"^",1)  //代码
		s PHEFCodeU=$ZCONVERT(PHEFCode,"U")
		s PHEFDesc=$p($g(^DHCPHEF(PHEFRowId)),"^",2)  //描述
		s PHEFDescU=$ZCONVERT(PHEFDesc,"U")
		s PHEFActiveFlag=$p($g(^DHCPHEF(PHEFRowId)),"^",3)  //是否可用
		
		s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEFDescU))
		i (PHEFCodeU[code)&((PHEFDescU[desc)||(PINYIN[desc))&(PHEFActiveFlag'="N")  //条件
		{
			s mainstr="{""id"":"""_PHEFRowId_""",""text"":"""_PHEFDesc_"""}"
		    if (jsonstr'="")
			{ 
				s jsonstr=jsonstr_","_mainstr
			}
			else
			{
				s jsonstr=mainstr
			}
		}					

	}

	s result="["_jsonstr_"]"
	q result
}

/// Description：打开适应症数据 
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenIndData("1")
/// 来源：web.DHCBL.KB.DHCPHDrugDiseaseI
ClassMethod OpenIndData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHDrugDiseaseI).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTSex=pobjIns.PHINSTSex
	s eobj.PHINSTDocUseTips=pobjIns.PHINSTDocUseTips
	s eobj.PHINSTNote=pobjIns.PHINSTNote
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	//通过索引获取年龄业务表的RowId——PDARowId
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",id,0))
	s eobj.PDAAgeDr=""
	if (PDARowId'="")
	{
		s pobjAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
		if $IsObject(pobjAge.PDAAgeDr)
		{
			s eobj.PDAAgeDr =pobjAge.PDAAgeDr.%Id() 
		}
		s eobj.PDAMaxVal=pobjAge.PDAMaxVal
		s eobj.PDAMinVal=pobjAge.PDAMinVal
		if $IsObject(pobjAge.PDAUomDr)
		{
			s eobj.PDAUomDr = pobjAge.PDAUomDr.%Id() 
		}
		d pobjAge.%Close()
		k pobjAge
	}
	;病症
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",id,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") 
		{
			if (eobj.PHDDDiseaDr'="")
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_","_eobj.PHDDDiseaDr
			}
			else
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		} 
	}
	;治疗手术
	s RowId=0
	for
	{
		s RowId=$o(^DHCPHCU(0,"Inst",id,RowId)) q:RowId=""
		s PDCUKeyWordDr=$p(^DHCPHCU(RowId),"^",2)
		if (PDCUKeyWordDr'="") 
		{
			if (eobj.PDCUKeyWordDr'="")
			{
				s eobj.PDCUKeyWordDr = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)_","_eobj.PDCUKeyWordDr
			}
			else
			{
				s eobj.PDCUKeyWordDr = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)
			}
		} 
	}
	;症状
	s RowId=0
	for
	{
		s RowId=$o(^DHCPHSYM(0,"Inst",id,RowId)) q:RowId=""
		s PSYMKeyWordDr=$p(^DHCPHSYM(RowId),"^",2)
		if (PSYMKeyWordDr'="") 
		{
			if (eobj.PSYMKeyWordDr'="")
			{
				s eobj.PSYMKeyWordDr = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)_","_eobj.PSYMKeyWordDr
			}
			else
			{
				s eobj.PSYMKeyWordDr = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)
			}
		} 
	}
	;细菌
	s RowId=0
	for
	{
		s RowId=$o( ^DHCPHORGBUS(0,"Inst",id,RowId)) q:RowId=""
		s PHORGOrgDr=$p(^DHCPHORGBUS(RowId),"^",2)
		if (PHORGOrgDr'="") 
		{
			if (eobj.PHORGOrgDr'="")
			{
				s eobj.PHORGOrgDr = $p(^DHCPHBTORG(PHORGOrgDr),"^",2)_","_eobj.PHORGOrgDr
			}
			else
			{
				s eobj.PHORGOrgDr = $p(^DHCPHBTORG(PHORGOrgDr),"^",2)
			}
		} 
	}
	;菌属
	s RowId=0
	for
	{
		s RowId=$o(^DHCPHGENUSBUS(0,"Inst",id,RowId)) q:RowId=""
		s PHGENGenusDr=$p(^DHCPHGENUSBUS(RowId),"^",2)
		if (PHGENGenusDr'="") 
		{
			if (eobj.PHGENGenusDr'="")
			{
				s eobj.PHGENGenusDr = $p(^DHCPHBTGE(PHGENGenusDr),"^",2)_","_eobj.PHGENGenusDr
			}
			else
			{
				s eobj.PHGENGenusDr = $p(^DHCPHBTGE(PHGENGenusDr),"^",2)
			}
		} 
	}
	;检验指标
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",id,0))
	if (LABIRowId'="")
	{
		s objlab = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
		if $IsObject(objlab.LABILabDr)
		{
			s eobj.LABILabDr = objlab.LABILabDr.%Id()
		}
		s eobj.LABIMinVal=objlab.LABIMinVal
		s eobj.LABIMaxVal=objlab.LABIMaxVal
		s eobj.LABIRelation=objlab.LABIRelation
		if $IsObject(objlab.LABIUomDr)
		{
			s eobj.LABIUomDr = objlab.LABIUomDr.%Id()
		}
		
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开成分含量
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHEleCon).OpenData("809")
ClassMethod OpenEleConData(id As %String) As %String
{
	s str=""
		
	s eobj = ##class(web.Entity.KB.DHCPHEleCon).%New()
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	s PHECRowId=$o(^DHCPHEC(0,"Inst",id,0))
	if (PHECRowId'=""){	
		s pobj = ##class(User.DHCPHEleCon).%OpenId(PHECRowId)
		s eobj.PHECRowId=PHECRowId
		if $IsObject(pobj.PHECInstDr){
			s eobj.PHECInstDr = pobj.PHECInstDr.%Id() 
			}
		if $IsObject(pobj.PHECPHExtIngr){
			s eobj.PHECPHExtIngr = pobj.PHECPHExtIngr.%Id() 
			}
		s eobj.PHECIngrQty=pobj.PHECIngrQty
		if $IsObject(pobj.PHECUomDr){
			s eobj.PHECUomDr = pobj.PHECUomDr.%Id() 
			}
		s eobj.PHECRelation=pobj.PHECRelation
		s eobj.PHECTotalQty=pobj.PHECTotalQty
		d pobj.%Close()
		k pobj
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// 快速排序
ClassMethod QuickSort(ByRef a As %String, left As %String, right As %String) As %String
{
 s m=a(left),temp=0
 s i=left,j=right
 
 while (i<j)
 {
  for
  {
   if ((i<j)&(a(j)>=m))  s j=j-1        //a(j)>=m ,不加=号的话，当输入相等的数时会报错
    else  s temp=m,a(i)=a(j),a(j)=temp 
    quit:a(j)=m
  }
   for
  {
    if ((i<j)&(a(i)<=m)) s i=i+1         //a(i)<=m ,不加=号的话，当输入相等的数时会报错
    else  s temp=m,a(j)=a(i),a(i)=temp
    quit:a(i)=m 
  }
 }
  s a(i)=m
  if ((i-left)> 1)
    {
   d ..QuickSort(.a,left,i-1)
 }
  if ((right-i)> 1)  
 {
   d ..QuickSort(.a,i+1,right)
 }
    quit i
}

/// Creator:谷雪萍
/// CreatDate:2017-12-25
/// Description：获取药品成分字典树形下拉框的数据
/// Input: ParentID,nodeid 
/// Table：User.DHCPHExtIngr
/// Return: json串
/// 来源: w ##class(web.DHCBL.KB.DHCPHExtIngr).GetTreeComboJson("CatTreeRoot","")
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).GetIngrComboJson("1")
ClassMethod GetIngrComboJson(ParentID As %String) As %String
{
	if (ParentID="") s ParentID=-100000000000000
	s myJsonStr=""
	s myRowID=0
	s myCount=0
	s mySeq=0
	k myArray
	
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.DHCPHExtIngrI("ParSeqIdx",ParentID,mySeq))
		q:(mySeq="")
		s n=n+1
		s a(n)= $p(mySeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ..QuickSort(.a,left,right) //排序
	s myRowID=0
	s n=0
	s mySeq=0
	for {
		s n=$o(a(n))
		q:(n="")
		s mySeq=$g(a(n))
		for {
			s myRowID=$o(^User.DHCPHExtIngrI("ParSeqIdx",ParentID," "_mySeq,myRowID))
			q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
			;w !,myRowID
		}
	}

	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s myJsonStr=""
	
	for {
		;q:(+mySeq>1)
		s mySeq=$o(myArray(mySeq))
		q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		
		s myObj=##Class(User.DHCPHExtIngr).%OpenId(myRowID,0)
		if $IsObject(myObj) {
			s myCode = myObj.PHEINGCode
			s myDesc = myObj.PHEINGDesc
			s myLastLevel=myObj.PHEINGLastLevel
			s myLevel = myObj.PHEINGLevel
			s myActiveFlag = myObj.PHEINGActiveFlag
			s mySysFlag = myObj.PHEINGSysFlag
			continue:myActiveFlag="N"
			
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"
			s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
			s myJsonStr=myJsonStr_"""state"":""open"""
			
			if $d(^User.DHCPHExtIngrI("ParCatIdx",myRowID)){ //如果有子节点
				s myJsonStr=myJsonStr_",""children"":"_..GetIngrComboJson(myRowID)
			}
			s myJsonStr=myJsonStr_"}"

			d myObj.%Close()
		}
	}
	k myArray

	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// Description：打开溶媒量数据
/// Input：id
/// 来源: w ##class(web.DHCBL.KB.DHCPHMenstruumQty).OpenData("1")
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenMenstruumData("1")
ClassMethod OpenMenstruumData(id As %String) As %String
{
	s str=""
		
	s eobj = ##class(web.Entity.KB.DHCPHMenstruumQty).%New()
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTText=pobjIns.PHINSTText
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	
	s PHMQRowId=$o(^DHCPHMQ(0,"Inst",id,0))
	if (PHMQRowId'=""){	
		s pobj = ##class(User.DHCPHMenstruumQty).%OpenId(PHMQRowId)
		s eobj.PHMQRowId=PHMQRowId
		if $IsObject(pobj.PHMQInstDr){
			s eobj.PHMQInstDr = pobj.PHMQInstDr.%Id() 
			}
		if $IsObject(pobj.PHMQCatDr){
			s eobj.PHMQCatDr = pobj.PHMQCatDr.%Id() 
			}
		s eobj.PHMQCatQtyMin=pobj.PHMQCatQtyMin
		s eobj.PHMQCatQtyMax=pobj.PHMQCatQtyMax
		if $IsObject(pobj.PHMQCatQtyUomDr){
			s eobj.PHMQCatQtyUomDr = pobj.PHMQCatQtyUomDr.%Id() 
			}
		d pobj.%Close()
		k pobj
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开溶媒数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDrgSolvent).OpenData("1")
ClassMethod OpenSolventData(id As %String) As %String
{
	s eobj = ##class(web.Entity.KB.DHCPHDrgSolvent).%New()
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	s PDINTRowId=$o(^DHCPHDST("0","Inst",id,0))
	if (PDINTRowId'=""){	
		s pobj = ##class(User.DHCPHDrgSolvent).%OpenId(PDINTRowId)
		s eobj.PDINTRowId=PDINTRowId
		if $IsObject(pobj.PDINTInstDr){
			s eobj.PDINTInstDr = pobj.PDINTInstDr.%Id() 
			}
		if $IsObject(pobj.PDINTDrgDr){
			s eobj.PDINTDrgDr = pobj.PDINTDrgDr.%Id() 
			}
		if $IsObject(pobj.PDINTMustUomDr){
			s eobj.PDINTMustUomDr = pobj.PDINTMustUomDr.%Id() 
			}
		s eobj.PDINTRelation=pobj.PDINTRelation
		s eobj.PDINTManage=pobj.PDINTManage
		s eobj.PDINTDosage=pobj.PDINTDosage
		s eobj.PDINTDosageMax=pobj.PDINTDosageMax
		s eobj.PDINTDosageMin=pobj.PDINTDosageMin
		d pobj.%Close()
		k pobj
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// w ##class(web.DHCBL.KB.DHCPHLibCat).GetTreeProComboJson("CatTreeRoot")
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).GetTreeProComboJson("6","10")
ClassMethod GetTreeProComboJson(ParentID As %String, lib As %String) As %String
{
	if (ParentID="") s ParentID=-100000000000000
    s:lib="" lib="DRUG"
	s:lib="SPEC" lib="LAB" 
	
	s myJsonStr=""
	s myRowID=0
	s myCount=0
	s mySeq=0
	k myArray
	
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.DHCPHLibCatI("ParSeqIdx",ParentID,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= $p(mySeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ..QuickSort(.a,left,right) //排序
	s myRowID=0
	s n=0
	s mySeq=0
	for {
		s n=$o(a(n))
		q:(n="")
		s mySeq=$g(a(n))
		for {
			s myRowID=$o(^User.DHCPHLibCatI("ParSeqIdx",ParentID," "_mySeq,myRowID)) q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
			;w !,myRowID
		}
	}

	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s myJsonStr=""
	
	for {
		;q:(+mySeq>1)
		s mySeq=$o(myArray(mySeq))
		q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		
		s myObj=##Class(User.DHCPHLibCat).%OpenId(myRowID,0)
		if $IsObject(myObj) {
			s myCode = myObj.PHICCode
			s myDesc = myObj.PHICDesc
			s myLastLevel=myObj.PHICLastLevel
			s myLevel = myObj.PHICLevel
			s myLibDr=""
			s:myObj.PHICLibDr'="" myLibDr = myObj.PHICLibDr.%Id()
			s myPHLICode=""
			s:myLibDr'="" myPHLICode = $p($g(^DHCPHLIBL(myLibDr)),"^",1)
			s myActiveFlag = myObj.PHICActiveFlag
			s mySysFlag = myObj.PHICSysFlag
			

			if (myPHLICode=lib){

	
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
				s myJsonStr=myJsonStr_"""state"":""open"""
				if ($d(^User.DHCPHLibCatI("ParCatIdx",myRowID))){
					s myJsonStr=myJsonStr_",""children"":"_..GetTreeProComboJson(myRowID,lib)
				}

				s myJsonStr=myJsonStr_"}"
			}
			d myObj.%Close()
		}
	}
	k myArray

	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// w ##class(web.DHCBL.KB.DHCBusMainNew).GetTreeComboJson("","10")
ClassMethod GetTreeComboJson(ParentID As %String, libDr As %String) As %String
{
    if (ParentID="") s ParentID=-100000000000000
    s myJsonStr=""
    s myRowID=0
    s myCount=0
    s mySeq=0
    k myArray
    
    //生成菜单索引数组
    s mySeq=0
    s n=0
    for {
        s mySeq=$o(^User.DHCPHLibCatI("ParSeqIdx",ParentID,mySeq))
        q:(mySeq="")
        s n=n+1
        s a(n)= $p(mySeq," ",2)
    }
    set left=1,right=n
    d:$d(a) ..QuickSort(.a,left,right) //排序
    s myRowID=0
    s n=0
    s mySeq=0
    for {
        s n=$o(a(n))
        q:(n="")
        s mySeq=$g(a(n))
        for {
            s myRowID=$o(^User.DHCPHLibCatI("ParSeqIdx",ParentID," "_mySeq,myRowID))
            q:(myRowID="")
            s myCount=myCount+1
            s myArray(myCount)=myRowID
            ;w !,myRowID
        }
    }
    
    //输出菜单JSON串
    s myRowID=0
    s mySeq=0
    s myJsonStr=""
    
    for {
        s mySeq=$o(myArray(mySeq))
        q:(mySeq="")
        s myRowID=$g(myArray(mySeq))
        
        s myObj=##Class(User.DHCPHLibCat).%OpenId(myRowID,0)
        if $IsObject(myObj) {
            s myCode = myObj.PHICCode
            s myDesc = myObj.PHICDesc
            s:myObj.PHICLastLevel'="" myLastLevel=myObj.PHICLastLevel.%Id()
            s myLevel = myObj.PHICLevel
            s:myObj.PHICLibDr'="" myLibDr = myObj.PHICLibDr.%Id()
            s myPHLICode = $p($g(^DHCPHLIBL(myLibDr)),"^",1)
            s myActiveFlag = myObj.PHICActiveFlag
            continue:myActiveFlag="N"
            s mySysFlag = myObj.PHICSysFlag
            
            s:libDr'="" PHLICode = $p($g(^DHCPHLIBL(libDr)),"^",1)
            
            if (myPHLICode=PHLICode){
           
                s:(myJsonStr'="") myJsonStr=myJsonStr_","
                s myJsonStr=myJsonStr_"{"
                s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
                s myJsonStr=myJsonStr_"""state"":""open"""
                if ($d(^User.DHCPHLibCatI("ParCatIdx",myRowID))){
	                s lib=PHLICode
					s myJsonStr=myJsonStr_",""children"":"_..GetTreeProComboJson(myRowID,lib)
				}
                
                s myJsonStr=myJsonStr_"}"
            }
            d myObj.%Close()
        }
    }
    k myArray

    s myJsonStr="["_myJsonStr_"]"
    
    q myJsonStr
}

/// Description：打开配伍禁忌数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDrugContrain).OpenData("1")
ClassMethod OpenDrugContrainData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.DHCPHDiseaseInteract).%OpenId(id)	
	s eobj = ##class(web.Entity.KB.DHCPHDrugContrain).%New()
	s eobj.PDINTRowId=id
	if $IsObject(pobj.PDINTInstDr){
		s eobj.PDINTInstDr = pobj.PDINTInstDr.%Id() 
		}
	s eobj.PDINTType=pobj.PDINTType
	s eobj.PDINTFlag=pobj.PDINTFlag
	if $IsObject(pobj.PDINTGenDr){
		s eobj.PDINTGenDr = pobj.PDINTGenDr.%Id() 
		}
	if $IsObject(pobj.PDINTDrugDr){
		s eobj.PDINTDrugDr = pobj.PDINTDrugDr.%Id() 
	}
	s eobj.PDINTManage=pobj.PDINTManage
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(eobj.PDINTInstDr)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	//通过索引获取分类业务表的RowId——CATIRowId
	s CATIRowId=$o(^DHCLIBCATI("0","Inst",eobj.PDINTInstDr,0))
	s pobjCat = ##class(User.DHCLibCatItm).%OpenId(CATIRowId)
	if $IsObject(pobjCat.CATICatDr){
		s eobj.PDINTCatDr =pobjCat.CATICatDr.%Id() 
		}

	d pobj.%Close()
	d pobjIns.%Close()
	k pobj
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2014-11-7
/// Description:查询 通用名标识 
/// Input:desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtGeneric","GetGenForCmb1","","lab","")
Query GetGenForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHEGRowId:%String,PHEGDesc:%String")
{
}

ClassMethod GetGenForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s PHEGRowId=rowid
		s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)
		s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)
		
		s PHEGDesc=##class(web.DHCBL.KB.DHCBusMainNew).EvalJSON(PHEGDesc)
		if (PHEGActiveFlag="Y")	{
			d OutputRowGen
		}
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		
		//s AuStr=##class(web.DHCBL.Authorize.SSGroup).DHCGetDataByDefaultSession()
		//s AuFlag=0
		;未授权情况下，默认显示全部数据
		//if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		
		s PHEGRowId=0
		for
		{
			s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId=""
			s strRowId="{ID:"_PHEGRowId_"}"
			//if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			//{
				s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)
				s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)
				s PHEGDesc=##class(web.DHCBL.KB.DHCBusMainNew).EvalJSON(PHEGDesc)	
				s PHEGDesc1=$ZCONVERT(PHEGDesc,"U")
				s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7) 
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) 
				s PHLICode1=$ZCONVERT(PHLICode,"U")
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDesc1))
				i (PHEGActiveFlag="Y")&(PHLICode1[code)&((PHEGDesc1[desc)||(PINYIN[desc))
				{
					d OutputRowGen
				}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGen
    set Data=$lb(PHEGRowId,PHEGDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetGenForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGenForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetGenForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGenForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description：打开相互作用数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseInteract).OpenData("1")
ClassMethod OpenInteractData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.DHCPHDiseaseInteract).%OpenId(id)	
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseInteract).%New()
	s eobj.PDINTRowId=id
	if $IsObject(pobj.PDINTInstDr){
		s eobj.PDINTInstDr = pobj.PDINTInstDr.%Id() 
	}
	s eobj.PDINTType=pobj.PDINTType
	s eobj.PDINTFlag=pobj.PDINTFlag
	if $IsObject(pobj.PDINTGenDr){
		s eobj.PDINTGenDr = pobj.PDINTGenDr.%Id() 
	}
	if $IsObject(pobj.PDINTDrugDr){
		s eobj.PDINTDrugDr = pobj.PDINTDrugDr.%Id() 
	}
	s eobj.PDINTManage=pobj.PDINTManage
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(eobj.PDINTInstDr)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	//通过索引获取分类业务表的RowId——CATIRowId
	s CATIRowId=$o(^DHCLIBCATI("0","Inst",eobj.PDINTInstDr,0))
	s pobjCat = ##class(User.DHCLibCatItm).%OpenId(CATIRowId)
	if $IsObject(pobjCat.CATICatDr){
		s eobj.PDINTCatDr =pobjCat.CATICatDr.%Id() 
		}

	d pobj.%Close()
	d pobjIns.%Close()
	k pobj
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开重复用药数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHRepeatItm).OpenData("1")
ClassMethod OpenRepeatData(id As %String) As %String
{
	s str=""
		
	s eobj = ##class(web.Entity.KB.DHCPHRepeatItm).%New()
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	s PHRIRowId=0
	for
	{
		s PHRIRowId=$o(^DHCPHRITM("0","Inst",id,PHRIRowId)) q:PHRIRowId=""

		s PHRIProDr=$p($g(^DHCPHRITM(PHRIRowId)),"^",2)
		if (PHRIProDr'="") 
		{
			if (eobj.PHRIProDr'="")
			{
				s eobj.PHRIProDr =$p($g(^DHCPHPNA(PHRIProDr)),"^",2)_","_eobj.PHRIProDr
			}
			else
			{
				s eobj.PHRIProDr =$p($g(^DHCPHPNA(PHRIProDr)),"^",2)
			}
		} 
		s pobj = ##class(User.DHCPHRepeatItm).%OpenId(PHRIRowId)
		s eobj.PHRIRowId=PHRIRowId
		if $IsObject(pobj.PHRIInstDr){
			s eobj.PHRIInstDr = pobj.PHRIInstDr.%Id() 
			}
		s eobj.PHRIManage=pobj.PHRIManage
		if $IsObject(pobj.PHRIRuleDr){
			s eobj.PHRIRuleDr = pobj.PHRIRuleDr.%Id() 
			}
		d pobj.%Close()
		k pobj
	
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开单独用药数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDrgAlone).OpenData("1")
ClassMethod OpenDrgAloneData(id As %String) As %String
{
	s str=""
		
	s eobj = ##class(web.Entity.KB.DHCPHDrgAlone).%New()
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	s PHDALRowId=0
	for
	{
		s PHDALRowId=$o(^DHCPHDAL("0","Inst",id,PHDALRowId)) q:PHDALRowId=""

		s PHDALDrgDr=$p($g(^DHCPHDAL(PHDALRowId)),"^",1)
		if (PHDALDrgDr'="") 
		{
			if (eobj.PHDALDrgDr'="")
			{
				s eobj.PHDALDrgDr =$p($g(^DHCPHPNA(PHDALDrgDr)),"^",2)_","_eobj.PHDALDrgDr
			}
			else
			{
				s eobj.PHDALDrgDr =$p($g(^DHCPHPNA(PHDALDrgDr)),"^",2)
			}
		} 
		s pobj = ##class(User.DHCPHDrgAlone).%OpenId(PHDALRowId)
		s eobj.PHDALRowId=PHDALRowId
		if $IsObject(pobj.PHDALInstDr){
			s eobj.PHDALInstDr = pobj.PHDALInstDr.%Id() 
			}
		s eobj.PHDALManage=pobj.PHDALManage
		if $IsObject(pobj.PHDALCatDr){
			s eobj.PHDALCatDr = pobj.PHDALCatDr.%Id() 
			}
		s eobj.PHDALGrpNo=pobj.PHDALGrpNo
		d pobj.%Close()
		k pobj
	
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开辅助用药个数数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHAssDrugNum).OpenData("1")
ClassMethod OpenPHAssDrugNumData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCPHAssDrugNum).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)	
	s eobj.PHINSTText=pobjIns.PHINSTText
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	//通过索引获取辅助用药个数表的RowId
	s PHADRowId=$o(^DHCPHADN(0,"Inst",id,0))
	s eobj.PHADNum=""
	if (PHADRowId'="")
	{
		s pobj = ##class(User.DHCPHAssDrugNum).%OpenId(PHADRowId)
		s eobj.PHADNum=pobj.PHADNum
		d pobj.%Close()
		k pobj
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开滴速数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDrippingSpeed).OpenData("1")
ClassMethod OpenDrippingSpeedData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCPHDrippingSpeed).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)	
	s eobj.PHINSTText=pobjIns.PHINSTText

	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开炮制作用数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHProcessingAct).OpenData("1")
ClassMethod OpenProcessingActData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCPHProcessingAct).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)	
	s eobj.PHINSTText=pobjIns.PHINSTText

	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开禁忌症数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).OpenIndData("1")
ClassMethod OpenConData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCPHDrugDiseaseC).%New()
	s eobj.PHDDInstDr=id
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTSex=pobjIns.PHINSTSex
	s eobj.PHINSTDocUseTips=pobjIns.PHINSTDocUseTips
	s eobj.PHINSTNote=pobjIns.PHINSTNote
	s eobj.PHINSTText=pobjIns.PHINSTText	
	d pobjIns.%Close()
	k pobjIns
	
	;病症,病症业务表^DHCPHDDIS，病症字典表^DHCPHDISL
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",id,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") 
		{
			if (eobj.PHDDDiseaDr'="")
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_","_eobj.PHDDDiseaDr
			}
			else
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		}
		s eobj.PHDDType=$p($g(^DHCPHDDIS(PHDDRowId)),"^",6) 
	}
	//成分业务表^DHCPHINI，成分字典表^DHCPHEING
	s IngrRowId=$o(^DHCPHINI(0,"Inst",eobj.PHDDInstDr,0))
	s eobj.PHINIIngrDr=""
	if (IngrRowId'="")
	{
		s pobjIngr = ##class(User.DHCPHIngrItm).%OpenId(IngrRowId)
		if $IsObject(pobjIngr.PHINIIngrDr){
			s eobj.PHINIIngrDr =pobjIngr.PHINIIngrDr.%Id() 
		}
	}
	
	/*s PHINIRowId=0
	for 
	{
		s PHINIRowId=$o(^DHCPHINI(0,"Inst",id,PHINIRowId)) q:PHINIRowId=""
		s IngrDr=$p($g(^DHCPHINI(PHINIRowId)),"^",2)
		if (IngrDr'="")
		{
			if (eobj.PHINIIngrDr'="")
			{
				s eobj.PHINIIngrDr=$p($g(^DHCPHEING(IngrDr)),"^",2)_","_eobj.PHINIIngrDr  
			}
			else
			{
				s eobj.PHINIIngrDr=$p($g(^DHCPHEING(IngrDr)),"^",2)
			}
		}
	}*/
	//获取既往史(多选)既往史业务表^DHCLIBDISHISI，既往史字典表^DHCDISHISF
	s LDHRowId=0
	for
	{
		s LDHRowId=$o(^DHCLIBDISHISI("0","Inst",id,LDHRowId)) q:LDHRowId=""	
		s DhDr=$p($g(^DHCLIBDISHISI(LDHRowId)),"^",2)  //病症指针		
		if (DhDr'="")
		{
			if (eobj.LDHDhDr'="")
			{
				s eobj.LDHDhDr=$p($g(^DHCDISHISF(DhDr)),"^",2)_","_eobj.LDHDhDr
			}
			else
			{
				s eobj.LDHDhDr=$p($g(^DHCDISHISF(DhDr)),"^",2)
			}
		}			
	}
		
	;特殊人群
	s SPEPIRowId=0
	for
	{
		s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",eobj.PHDDInstDr,SPEPIRowId)) q:SPEPIRowId=""
		//s eobj.SpecialPopu=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)_"^"_eobj.SpecialPopu	
		s SPEPISpecDr=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)
		s:SPEPISpecDr'="" eobj.SpecialPopu=$p(^DHCSPEP(SPEPISpecDr),"^",2)_","_eobj.SpecialPopu	
	}

	//通过索引获取年龄业务表的RowId——PDARowId
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",eobj.PHDDInstDr,0))
	s eobj.PDAAgeDr=""
	if (PDARowId'="")
	{
		s pobjAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
		if $IsObject(pobjAge.PDAAgeDr)
		{
			s eobj.PDAAgeDr =pobjAge.PDAAgeDr.%Id() 
		}
		s eobj.PDAMaxVal=pobjAge.PDAMaxVal
		s eobj.PDAMinVal=pobjAge.PDAMinVal
		if $IsObject(pobjAge.PDAUomDr)
		{
			s eobj.PDAUomDr = pobjAge.PDAUomDr.%Id() 
		}
		d pobjAge.%Close()
		k pobjAge
	}	
	//通过索引获取过敏史业务表的RowId——LALCRowId
	s LALCRowId=$o(^DHCLIBALLI(0,"Inst",eobj.PHDDInstDr,0))
	s eobj.LALCAllergyDr=""
	if (LALCRowId'="")
	{
		s pobjAgy = ##class(User.DHCLibAllergyItm).%OpenId(LALCRowId)
		if $IsObject(pobjAgy.LALCAllergyDr)
		{
			s eobj.LALCAllergyDr =pobjAgy.LALCAllergyDr.%Id() 
		}
		d pobjAgy.%Close()
		k pobjAgy
		
	}

	//通过索引获取生理参数业务表DHC_PhysiologyVal的RowId——PHYVRowId
	s PHYVRowId=$o(^DHCPHYVAL(0,"Inst",eobj.PHDDInstDr,0))
	s eobj.PHYVFeildDr=""
	if (PHYVRowId'="")
	{
		s pobjPhy = ##class(User.DHCPhysiologyVal).%OpenId(PHYVRowId)
		if $IsObject(pobjPhy.PHYVFeildDr)
		{
			s eobj.PHYVFeildDr =pobjPhy.PHYVFeildDr.%Id() 
		}
		s eobj.PHYVMinVal=pobjPhy.PHYVMinVal
		s eobj.PHYVMaxVal=pobjPhy.PHYVMaxVal
		d pobjPhy.%Close()
		k pobjPhy
	}
	;检验指标
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",eobj.PHDDInstDr,0))
	if (LABIRowId'="")
	{
		s objlab = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
		if $IsObject(objlab.LABILabDr)
		{
			s eobj.LABILabDr = objlab.LABILabDr.%Id()
		}
		s eobj.LABIMinVal=objlab.LABIMinVal
		s eobj.LABIMaxVal=objlab.LABIMaxVal
		s eobj.LABIRelation=objlab.LABIRelation
		if $IsObject(objlab.LABIUomDr)
		{
			s eobj.LABIUomDr = objlab.LABIUomDr.%Id()
		}
		
	}
	;治疗手术
	s RowId=0
	for
	{
		s RowId=$o(^DHCPHCU(0,"Inst",id,RowId)) q:RowId=""
		s PDCUKeyWordDr=$p(^DHCPHCU(RowId),"^",2)
		if (PDCUKeyWordDr'="") 
		{
			if (eobj.PDCUKeyWordDr'="")
			{
				s eobj.PDCUKeyWordDr = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)_","_eobj.PDCUKeyWordDr
			}
			else
			{
				s eobj.PDCUKeyWordDr = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)
			}
		} 
	}
	;症状
	s RowId=0
	for
	{
		s RowId=$o(^DHCPHSYM(0,"Inst",id,RowId)) q:RowId=""
		s PSYMKeyWordDr=$p(^DHCPHSYM(RowId),"^",2)
		if (PSYMKeyWordDr'="") 
		{
			if (eobj.PSYMKeyWordDr'="")
			{
				s eobj.PSYMKeyWordDr = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)_","_eobj.PSYMKeyWordDr
			}
			else
			{
				s eobj.PSYMKeyWordDr = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)
			}
		} 
	}
	
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开联合用药数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHMustDrug).OpenData("1")
ClassMethod OpenMustDrugData(id As %String) As %String
{
	s str=""
		
	s eobj = ##class(web.Entity.KB.DHCPHMustDrug).%New()
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	s PHMDRowId=$o(^DHCPHMD("0","Inst",id,0))
	if (PHMDRowId'=""){	
		s pobj = ##class(User.DHCPHMustDrug).%OpenId(PHMDRowId)
		s eobj.PHMDRowId=PHMDRowId
		if $IsObject(pobj.PHMDInstDr){
			s eobj.PHMDInstDr = pobj.PHMDInstDr.%Id() 
			}
		if $IsObject(pobj.PHMDAssDrugDr){
			s eobj.PHMDAssDrugDr = pobj.PHMDAssDrugDr.%Id() 
			}
		if $IsObject(pobj.PHMDMustUomDr){
			s eobj.PHMDMustUomDr = pobj.PHMDMustUomDr.%Id() 
			}
		s eobj.PHMDRelation=pobj.PHMDRelation
		if $IsObject(pobj.PHMDMustDrugDr){
			s eobj.PHMDMustDrugDr = pobj.PHMDMustDrugDr.%Id() 
		}
		s eobj.PHMDMustQty=pobj.PHMDMustQty
		d pobj.%Close()
		k pobj
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开禁忌数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHUsageDosage).OpenData("9")
ClassMethod OpenUsageDosageData(id As %String) As %String
{
	s str=""
	
	s eobj = ##class(web.Entity.KB.DHCPHUsageDosage).%New()
	;用法用量表
	s objdos = ##class(User.DHCPHUsageDosage).%OpenId(id)	
	s eobj.PHUSDORowId=id
	s:objdos.PHUSDOInstDr'="" eobj.PHUSDOInstDr = objdos.PHUSDOInstDr.%Id() 
	s eobj.PHUSDOOneDayTimeMin = objdos.PHUSDOOneDayTimeMin
	s eobj.PHUSDOOneDayTimeMax = objdos.PHUSDOOneDayTimeMax
	s eobj.PHUSDOOnceQtyMin = objdos.PHUSDOOnceQtyMin
	s eobj.PHUSDOOnceQtyMax = objdos.PHUSDOOnceQtyMax
	s:objdos.PHUSDOOnceQtyUomDr'="" eobj.PHUSDOOnceQtyUomDr = objdos.PHUSDOOnceQtyUomDr.%Id()
	s eobj.PHUSDOOneDayQtyMin = objdos.PHUSDOOneDayQtyMin
	s eobj.PHUSDOOneDayQtyMax = objdos.PHUSDOOneDayQtyMax
	s:objdos.PHUSDOOneDayQtyUomDr'="" eobj.PHUSDOOneDayQtyUomDr = objdos.PHUSDOOneDayQtyUomDr.%Id()
	s eobj.PHUSDOOnceMaxQty = objdos.PHUSDOOnceMaxQty
	s:objdos.PHUSDOOnceMaxQtyUomDr'="" eobj.PHUSDOOnceMaxQtyUomDr = objdos.PHUSDOOnceMaxQtyUomDr.%Id()
	s eobj.PHUSDOOneDayMaxQty = objdos.PHUSDOOneDayMaxQty
	s:objdos.PHUSDOOneDayMaxQtyUomDr'="" eobj.PHUSDOOneDayMaxQtyUomDr = objdos.PHUSDOOneDayMaxQtyUomDr.%Id()
	s eobj.PHUSDOFristTimeQtyMin = objdos.PHUSDOFristTimeQtyMin
	s eobj.PHUSDOFristTimeQtyMax = objdos.PHUSDOFristTimeQtyMax
	s:objdos.PHUSDOFristTimeQtyUomDr'="" eobj.PHUSDOFristTimeQtyUomDr = objdos.PHUSDOFristTimeQtyUomDr.%Id()
	s eobj.PHUSDODurationQtyMin = objdos.PHUSDODurationQtyMin
	s eobj.PHUSDODurationQtyMax = objdos.PHUSDODurationQtyMax
	s:objdos.PHUSDODurationQtyUomDr'="" eobj.PHUSDODurationQtyUomDr = objdos.PHUSDODurationQtyUomDr.%Id()
	s eobj.PHUSDOSpaceQtyMin = objdos.PHUSDOSpaceQtyMin
	s eobj.PHUSDOSpaceQtyMax = objdos.PHUSDOSpaceQtyMax
	s:objdos.PHUSDOSpaceQtyUomDr'="" eobj.PHUSDOSpaceQtyUomDr = objdos.PHUSDOSpaceQtyUomDr.%Id()
	s eobj.PHUSDOWeightMin = objdos.PHUSDOWeightMin
	s eobj.PHUSDOWeightMax = objdos.PHUSDOWeightMax
	s eobj.PHUSDOBodyAreaMin = objdos.PHUSDOBodyAreaMin
	s eobj.PHUSDOBodyAreaMax = objdos.PHUSDOBodyAreaMax
	s eobj.PHUSDOPeriod = objdos.PHUSDOPeriod
	;主索引
	s:eobj.PHUSDOInstDr'="" objins = ##class(User.DHCPHInstructions).%OpenId(eobj.PHUSDOInstDr)
	s eobj.PHINSTMode=objins.PHINSTMode //级别			
	s eobj.PHINSTSex=objins.PHINSTSex //性别			
	s eobj.PHINSTDocUseTips=objins.PHINSTDocUseTips //提示（医生）		
	s eobj.PHINSTNurseUseTips=objins.PHINSTNurseUseTips //提示（护士患者）
	s eobj.PHINSTText=objins.PHINSTText //描述
	;病症
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",eobj.PHUSDOInstDr,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		s:PHDDDiseaDr'="" eobj.PHDISLDisea = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_","_eobj.PHDISLDisea 
		/*s eobj.PHDISLDisea = $p(^DHCPHDDIS(PHDDRowId),"^",3)_","_eobj.PHDISLDisea*/
	}
	;用法
	s PDIRowId=$o(^DHCPHDISUSE(0,"Inst",eobj.PHUSDOInstDr,0)) 
	s:PDIRowId'="" objuse = ##class(User.DHCPHDiseaseUse).%OpenId(PDIRowId)
	s:objuse.PDIUseDR'="" eobj.PHEINInstruc=objuse.PDIUseDR.%Id()
	
	;年龄
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",eobj.PHUSDOInstDr,0))
	if (PDARowId'=""){
		s objage = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
		if $IsObject(objage.PDAAgeDr){
			s eobj.PDAAge=objage.PDAAgeDr.%Id()
		}
		s eobj.PDAMinVal=objage.PDAMinVal
		s eobj.PDAMaxVal=objage.PDAMaxVal
		if $IsObject(objage.PDAUomDr){
			s eobj.PDAUomDr=objage.PDAUomDr.%Id()
		}
	}
	;特殊人群
	s SPEPIRowId=0
	for
	{
		s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",eobj.PHUSDOInstDr,SPEPIRowId)) q:SPEPIRowId=""
		s SPEPISpecDr=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)
		s:SPEPISpecDr'="" eobj.SpecialPopu=$p(^DHCSPEP(SPEPISpecDr),"^",2)_","_eobj.SpecialPopu	
		//s eobj.SpecialPopu=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)_"^"_eobj.SpecialPopu	
	}
	
	;检验指标
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",eobj.PHUSDOInstDr,0))
	s:LABIRowId'="" objlab = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
	s:objlab.LABILabDr'="" eobj.LABILabDr = objlab.LABILabDr.%Id()
	s:objlab.LABIMinVal'="" eobj.LABIMinVal=objlab.LABIMinVal
	s:objlab.LABIMaxVal'="" eobj.LABIMaxVal=objlab.LABIMaxVal
	s:objlab.LABIUomDr'="" eobj.LABIUomDr = objlab.LABIUomDr.%Id()
	s:objlab.LABIRelation'="" eobj.LABIRelation=objlab.LABIRelation
	
	s str = eobj.JsonS()
	//s str = "{data:["_str_"]}"
    /*s str="{""PHINSTMode"":"""_eobj.PHINSTMode_""",""PHUSDOInstDr"":"""_eobj.PHUSDOInstDr_""",""PDAAge"":"""_eobj.PDAAge_""",""PDAMinVal"":"""_eobj.PDAMinVal_""",""PDAMaxVal"":"""_eobj.PDAMaxVal_""",""PDAUomDr"":"""_eobj.PDAUomDr_""",""PHINSTSex"":"""_eobj.PHINSTSex
    s str=str_""",""PHUSDOOneDayTimeMin"":"""_eobj.PHUSDOOneDayTimeMin_""",""PHUSDOOneDayTimeMax"":"""_eobj.PHUSDOOneDayTimeMax_""",""PHUSDOOnceQtyMin"":"""_eobj.PHUSDOOnceQtyMin_""",""PHUSDOOnceQtyMax"":"""_eobj.PHUSDOOnceQtyMax_""",""PHUSDOOnceQtyUomDr"":"""_eobj.PHUSDOOnceQtyUomDr
    s str=str_""",""PHUSDOOneDayQtyMin"":"""_eobj.PHUSDOOneDayQtyMin_""",""PHUSDOOneDayQtyMax"":"""_eobj.PHUSDOOneDayQtyMax_""",""PHUSDOOneDayQtyUomDr"":"""_eobj.PHUSDOOneDayQtyUomDr
    s str=str_""",""PHUSDOFristTimeQtyMin"":"""_eobj.PHUSDOFristTimeQtyMin_""",""PHUSDOFristTimeQtyMax"":"""_eobj.PHUSDOFristTimeQtyMax_""",""PHUSDOFristTimeQtyUomDr"":"""_eobj.PHUSDOFristTimeQtyUomDr
    s str=str_""",""PHUSDODurationQtyMin"":"""_eobj.PHUSDODurationQtyMin_""",""PHUSDODurationQtyMax"":"""_eobj.PHUSDODurationQtyMax_""",""PHUSDODurationQtyUomDr"":"""_eobj.PHUSDODurationQtyUomDr
    s str=str_""",""PHUSDOSpaceQtyMin"":"""_eobj.PHUSDOSpaceQtyMin_""",""PHUSDOSpaceQtyMax"":"""_eobj.PHUSDOSpaceQtyMax_""",""PHUSDOSpaceQtyUomDr"":"""_eobj.PHUSDOSpaceQtyUomDr
    s str=str_""",""PHUSDOOnceMaxQty"":"""_eobj.PHUSDOOnceMaxQty_""",""PHUSDOOnceMaxQtyUomDr"":"""_eobj.PHUSDOOnceMaxQtyUomDr_""",""PHUSDOOneDayMaxQty"":"""_eobj.PHUSDOOneDayMaxQty_""",""PHUSDOOneDayMaxQtyUomDr"":"""_eobj.PHUSDOOneDayMaxQtyUomDr
    s str=str_""",""PHUSDOWeightMin"":"""_eobj.PHUSDOWeightMin_""",""PHUSDOWeightMax"":"""_eobj.PHUSDOWeightMax_""",""PHUSDOBodyAreaMin"":"""_eobj.PHUSDOBodyAreaMin_""",""PHUSDOBodyAreaMax"":"""_eobj.PHUSDOBodyAreaMax
    s str=str_""",""LABILabDr"":"""_eobj.LABILabDr_""",""LABIRelation"":"""_eobj.LABIRelation_""",""LABIMinVal"":"""_eobj.LABIMinVal_""",""LABIMaxVal"":"""_eobj.LABIMaxVal_""",""LABIUomDr"":"""_eobj.LABIUomDr
    s str=str_""",""PHINSTDocUseTips"":"""_eobj.PHINSTDocUseTips_""",""PHINSTNurseUseTips"":"""_eobj.PHINSTNurseUseTips_""",""PHINSTText"":"""_eobj.PHINSTText_"""}"*/

	q str
}

/// Description：打开放射适应症数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenCheckIndData("1")
ClassMethod OpenCheckIndData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCCheckDiseaseI).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTSex=pobjIns.PHINSTSex
	s eobj.PHINSTDocUseTips=pobjIns.PHINSTDocUseTips
	s eobj.PHINSTNote=pobjIns.PHINSTNote
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	//通过索引获取年龄业务表的RowId——PDARowId
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",id,0))
	s eobj.PDAAgeDr=""
	if (PDARowId'="")
	{
		s pobjAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
		if $IsObject(pobjAge.PDAAgeDr)
		{
			s eobj.PDAAgeDr =pobjAge.PDAAgeDr.%Id() 
		}
		s eobj.PDAMaxVal=pobjAge.PDAMaxVal
		s eobj.PDAMinVal=pobjAge.PDAMinVal
		d pobjAge.%Close()
		k pobjAge
	}
	;病症
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",id,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") 
		{
			if (eobj.PHDDDiseaDr'="")
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_","_eobj.PHDDDiseaDr
			}
			else
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		} 
	}
	;治疗手术
	s RowId=0
	for
	{
		s RowId=$o(^DHCPHCU(0,"Inst",id,RowId)) q:RowId=""
		s PDCUKeyWordDr=$p(^DHCPHCU(RowId),"^",2)
		if (PDCUKeyWordDr'="") 
		{
			if (eobj.PDCUKeyWordDr'="")
			{
				s eobj.PDCUKeyWordDr = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)_","_eobj.PDCUKeyWordDr
			}
			else
			{
				s eobj.PDCUKeyWordDr = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)
			}
		} 
	}
	;症状
	s RowId=0
	for
	{
		s RowId=$o(^DHCPHSYM(0,"Inst",id,RowId)) q:RowId=""
		s PSYMKeyWordDr=$p(^DHCPHSYM(RowId),"^",2)
		if (PSYMKeyWordDr'="") 
		{
			if (eobj.PSYMKeyWordDr'="")
			{
				s eobj.PSYMKeyWordDr = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)_","_eobj.PSYMKeyWordDr
			}
			else
			{
				s eobj.PSYMKeyWordDr = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)
			}
		} 
	}

	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开放射禁忌症数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenCheckConData("1")
ClassMethod OpenCheckConData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCCheckDiseaseC).%New()
	s eobj.PHDDInstDr=id
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTSex=pobjIns.PHINSTSex
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	;病症,病症业务表^DHCPHDDIS，病症字典表^DHCPHDISL
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",id,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") 
		{
			if (eobj.PHDDDiseaDr'="")
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_","_eobj.PHDDDiseaDr
			}
			else
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		}
		s eobj.PHDDType=$p($g(^DHCPHDDIS(PHDDRowId)),"^",6) 
	}
	;治疗手术
	s RowId=0
	for
	{
		s RowId=$o(^DHCPHCU(0,"Inst",id,RowId)) q:RowId=""
		s PDCUKeyWordDr=$p(^DHCPHCU(RowId),"^",2)
		if (PDCUKeyWordDr'="") 
		{
			if (eobj.PDCUKeyWordDr'="")
			{
				s eobj.PDCUKeyWordDr = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)_","_eobj.PDCUKeyWordDr
			}
			else
			{
				s eobj.PDCUKeyWordDr = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)
			}
		} 
	}
	;症状
	s RowId=0
	for
	{
		s RowId=$o(^DHCPHSYM(0,"Inst",id,RowId)) q:RowId=""
		s PSYMKeyWordDr=$p(^DHCPHSYM(RowId),"^",2)
		if (PSYMKeyWordDr'="") 
		{
			if (eobj.PSYMKeyWordDr'="")
			{
				s eobj.PSYMKeyWordDr = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)_","_eobj.PSYMKeyWordDr
			}
			else
			{
				s eobj.PSYMKeyWordDr = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)
			}
		} 
	}	
	;特殊人群
	s SPEPIRowId=0
	for
	{
		s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",eobj.PHDDInstDr,SPEPIRowId)) q:SPEPIRowId=""
		//s eobj.SpecialPopu=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)_"^"_eobj.SpecialPopu
		s SPEPISpecDr=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)
		s:SPEPISpecDr'="" eobj.SpecialPopu=$p(^DHCSPEP(SPEPISpecDr),"^",2)_","_eobj.SpecialPopu		
	}

	//通过索引获取年龄业务表的RowId——PDARowId
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",eobj.PHDDInstDr,0))
	s eobj.PDAAgeDr=""
	if (PDARowId'="")
	{
		s pobjAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
		if $IsObject(pobjAge.PDAAgeDr)
		{
			s eobj.PDAAgeDr =pobjAge.PDAAgeDr.%Id() 
		}
		s eobj.PDAMaxVal=pobjAge.PDAMaxVal
		s eobj.PDAMinVal=pobjAge.PDAMinVal
		if $IsObject(pobjAge.PDAUomDr)
		{
			s eobj.PDAUomDr = pobjAge.PDAUomDr.%Id() 
		}
		d pobjAge.%Close()
		k pobjAge
	}	
	//通过索引获取过敏史业务表的RowId——LALCRowId
	s LALCRowId=$o(^DHCLIBALLI(0,"Inst",eobj.PHDDInstDr,0))
	s eobj.LALCAllergyDr=""
	if (LALCRowId'="")
	{
		s pobjAgy = ##class(User.DHCLibAllergyItm).%OpenId(LALCRowId)
		if $IsObject(pobjAgy.LALCAllergyDr)
		{
			s eobj.LALCAllergyDr =pobjAgy.LALCAllergyDr.%Id() 
		}
		d pobjAgy.%Close()
		k pobjAgy
		
	}
	d pobjIns.%Close()
	k pobjIns

	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开检验项目编辑器检验结果辅助诊断数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenDHCPHLibResultDiagData("1")
ClassMethod OpenDHCPHLibResultDiagData(id As %String) As %String
{
	s str=""
	
	s eobj = ##class(web.Entity.KB.DHCPHLibResultDiag).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)	
	s eobj.PHINSTText=pobjIns.PHINSTText
	s PLRDRowId=$o(^DHCPHLRD("0","Inst",id,0))
	if (PLRDRowId'=""){
		s pobj=##class(User.DHCPHLibResultDiag).%OpenId(PLRDRowId)	
		s eobj.PLRDNormal=pobj.PLRDNormal
		s eobj.PLRDHigh=pobj.PLRDHigh
		s eobj.PLRDLow=pobj.PLRDLow
		s eobj.PLRDNegative=pobj.PLRDNegative
		s eobj.PLRDPositive=pobj.PLRDPositive
		s eobj.PLRDOther=pobj.PLRDOther
		d pobj.%Close()
		k pobj
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开检验项目相互作用数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenLABDiseaseInteractData("1")
ClassMethod OpenLABDiseaseInteractData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.DHCPHDiseaseInteract).%OpenId(id)	
	s eobj = ##class(web.Entity.KB.DHCLABDiseaseInteract).%New()
	s eobj.PDINTRowId=id
	if $IsObject(pobj.PDINTInstDr){
		s eobj.PDINTInstDr = pobj.PDINTInstDr.%Id() 
		}
	s eobj.PDINTType=pobj.PDINTType
	if $IsObject(pobj.PDINTGenDr){
		s eobj.PDINTGenDr = pobj.PDINTGenDr.%Id() 
		}
	s eobj.PDINTManage=pobj.PDINTManage
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(eobj.PDINTInstDr)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	//通过索引获取分类业务表的RowId——CATIRowId
	s CATIRowId=$o(^DHCLIBCATI("0","Inst",eobj.PDINTInstDr,0))
	s pobjCat = ##class(User.DHCLibCatItm).%OpenId(CATIRowId)
	if $IsObject(pobjCat.CATICatDr){
		s eobj.PDINTCatDr =pobjCat.CATICatDr.%Id() 
		}

	d pobj.%Close()
	d pobjIns.%Close()
	k pobj
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开检验编辑器适应症数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenLABDiseaseIndData("1")
ClassMethod OpenLABDiseaseIndData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCLABDiseaseI).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTSex=pobjIns.PHINSTSex
	s eobj.PHINSTDocUseTips=pobjIns.PHINSTDocUseTips
	s eobj.PHINSTNote=pobjIns.PHINSTNote
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	//通过索引获取年龄业务表的RowId——PDARowId
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",id,0))
	s eobj.PDAAgeDr=""
	if (PDARowId'="")
	{
		s pobjAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
		if $IsObject(pobjAge.PDAAgeDr)
		{
			s eobj.PDAAgeDr =pobjAge.PDAAgeDr.%Id() 
		}
		s eobj.PDAMaxVal=pobjAge.PDAMaxVal
		s eobj.PDAMinVal=pobjAge.PDAMinVal
		if $IsObject(pobjAge.PDAUomDr)
		{
			s eobj.PDAUomDr = pobjAge.PDAUomDr.%Id() 
		}
		d pobjAge.%Close()
		k pobjAge
	}
	;病症
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",id,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") 
		{
			if (eobj.PHDDDiseaDr'="")
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_","_eobj.PHDDDiseaDr
			}
			else
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		} 
	}

	;特殊人群
	s SPEPIRowId=0
	for
	{
		s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",id,SPEPIRowId)) q:SPEPIRowId=""
		//s eobj.SpecialPopu=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)_"^"_eobj.SpecialPopu
		s SPEPISpecDr=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)
		s:SPEPISpecDr'="" eobj.SpecialPopu=$p(^DHCSPEP(SPEPISpecDr),"^",2)_","_eobj.SpecialPopu		
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开检验禁忌症数据
/// Input：id 
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenDHCLABDiseaseConData("1")
ClassMethod OpenDHCLABDiseaseConData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCLABDiseaseC).%New()
	s eobj.PHDDInstDr=id
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTSex=pobjIns.PHINSTSex
	s eobj.PHINSTDocUseTips=pobjIns.PHINSTDocUseTips
	s eobj.PHINSTNote=pobjIns.PHINSTNote
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	;病症,病症业务表^DHCPHDDIS，病症字典表^DHCPHDISL
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",id,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") 
		{
			if (eobj.PHDDDiseaDr'="")
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_","_eobj.PHDDDiseaDr
			}
			else
			{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		}
		s eobj.PHDDType=$p($g(^DHCPHDDIS(PHDDRowId)),"^",6) 
	}
	
	;特殊人群
	s SPEPIRowId=0
	for
	{
		s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",eobj.PHDDInstDr,SPEPIRowId)) q:SPEPIRowId=""
		//s eobj.SpecialPopu=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)_"^"_eobj.SpecialPopu	
		s SPEPISpecDr=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)
		s:SPEPISpecDr'="" eobj.SpecialPopu=$p(^DHCSPEP(SPEPISpecDr),"^",2)_","_eobj.SpecialPopu	
	}

	//通过索引获取年龄业务表的RowId——PDARowId
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",eobj.PHDDInstDr,0))
	s eobj.PDAAgeDr=""
	if (PDARowId'="")
	{
		s pobjAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
		if $IsObject(pobjAge.PDAAgeDr)
		{
			s eobj.PDAAgeDr =pobjAge.PDAAgeDr.%Id() 
		}
		s eobj.PDAMaxVal=pobjAge.PDAMaxVal
		s eobj.PDAMinVal=pobjAge.PDAMinVal
		if $IsObject(pobjAge.PDAUomDr)
		{
			s eobj.PDAUomDr = pobjAge.PDAUomDr.%Id() 
		}
		d pobjAge.%Close()
		k pobjAge
	}	
	
	d pobjIns.%Close()
	k pobjIns

	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开检验临床意义数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenLabClinicalData("1")
ClassMethod OpenLabClinicalData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCLabClinical).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)	
	s eobj.PHINSTText=pobjIns.PHINSTText

	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开不良反应数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenData("1")
ClassMethod OpenECGARData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCECGAR).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)	
	s eobj.PHINSTText=pobjIns.PHINSTText

	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：打开禁忌症数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenConData("128")
ClassMethod OpenECGConData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCECGDiseaseC).%New()
	s eobj.PHDDInstDr=id
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	;病症
	s PHDDRowId=0
	for{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",id,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") {
			if (eobj.PHDDDiseaDr'=""){
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_","_eobj.PHDDDiseaDr
			}
			else{
				s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		} 
	}
	;检查结果
	s EXAIRowId=0
	for{
		s EXAIRowId=$o(^DHCLIBEXAI(0,"Inst",id,EXAIRowId)) q:EXAIRowId=""
		s EXAIExamDr=$p(^DHCLIBEXAI(EXAIRowId),"^",2)
		if (EXAIExamDr'="") {
			if (eobj.PHDDExamDr'=""){
				s eobj.PHDDExamDr = $p(^DHCEXAMINE(EXAIExamDr),"^",2)_","_eobj.PHDDExamDr
			}
			else{
				s eobj.PHDDExamDr = $p(^DHCEXAMINE(EXAIExamDr),"^",2)
			}
		} 
	}

	//通过索引获取生理参数业务表DHC_PhysiologyVal的RowId——PHYVRowId
	s PHYVRowId=$o(^DHCPHYVAL(0,"Inst",eobj.PHDDInstDr,0))
	s eobj.PHYVFeildDr=""
	if (PHYVRowId'=""){
		s pobjPhy = ##class(User.DHCPhysiologyVal).%OpenId(PHYVRowId)
		if $IsObject(pobjPhy.PHYVFeildDr){
			s eobj.PHYVFeildDr =pobjPhy.PHYVFeildDr.%Id() 
		}
		s eobj.PHYVMinVal=pobjPhy.PHYVMinVal
		s eobj.PHYVMaxVal=pobjPhy.PHYVMaxVal
		d pobjPhy.%Close()
	}
	;检验指标
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",eobj.PHDDInstDr,0))
		if (LABIRowId'=""){ 
			s labobj = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
			s:labobj.LABILabDr'="" eobj.LABILabDr=labobj.LABILabDr.%Id()
			s eobj.LABIMinVal=labobj.LABIMinVal
			s eobj.LABIMaxVal=labobj.LABIMaxVal
			s:labobj.LABIUomDr'="" eobj.LABIUomDr=labobj.LABIUomDr.%Id()	
			d labobj.%Close()
		}

	d pobjIns.%Close()

	s str = eobj.JsonS()
	//s str = "{data:["_str_"]}"
	q str
}

/// Description：打开相互作用数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenData("1")
ClassMethod OpenECGInteractData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.DHCPHDiseaseInteract).%OpenId(id)	
	s eobj = ##class(web.Entity.KB.DHCECGInteract).%New()
	s eobj.PDINTRowId=id
	if $IsObject(pobj.PDINTInstDr){
		s eobj.PDINTInstDr = pobj.PDINTInstDr.%Id() 
		}
	s eobj.PDINTType=pobj.PDINTType
		if $IsObject(pobj.PDINTGenDr){
			s eobj.PDINTGenDr = pobj.PDINTGenDr.%Id() 
			}
		s eobj.PDINTManage=pobj.PDINTManage
		
		s pobjIns = ##class(User.DHCPHInstructions).%OpenId(eobj.PDINTInstDr)
		s eobj.PHINSTMode=pobjIns.PHINSTMode
		s eobj.PHINSTText=pobjIns.PHINSTText
		
		//通过索引获取分类业务表的RowId——CATIRowId
		s CATIRowId=$o(^DHCLIBCATI("0","Inst",eobj.PDINTInstDr,0))
		s pobjCat = ##class(User.DHCLibCatItm).%OpenId(CATIRowId)
		if $IsObject(pobjCat.CATICatDr){
			s eobj.PDINTCatDr =pobjCat.CATICatDr.%Id() 
			}

		d pobj.%Close()
		d pobjIns.%Close()
		k pobj
		k pobjIns
		s str = eobj.JsonS()
		//s str = "{list:["_str_"]}"
		q str
}

/// Description：打开注意事项数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenData("1")
ClassMethod OpenECGMHAData(id As %String) As %String
{
		s str=""
		s eobj = ##class(web.Entity.KB.DHCECGMHA).%New()
		s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)	
		s eobj.PHINSTText=pobjIns.PHINSTText

		d pobjIns.%Close()
		k pobjIns
		s str = eobj.JsonS()
		//s str = "{list:["_str_"]}"
		q str
}

/// Description：打开高危提醒数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenRemindData("1")
ClassMethod OpenOperRemindData(id As %String) As %String
{
		s str=""	
		s eobj = ##class(web.Entity.KB.DHCOPERRemind).%New()
		s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
		s eobj.PHINSTMode=pobjIns.PHINSTMode
		s eobj.PHINSTText=pobjIns.PHINSTText
		s eobj.PHINSTBMIMin=pobjIns.PHINSTBMIMin
		s eobj.PHINSTBMIMax=pobjIns.PHINSTBMIMax
		
		//通过索引获取年龄业务表的RowId——PDARowId
		s PDARowId=$o(^DHCPHDISAGE(0,"Inst",id,0))
		s eobj.PDAAgeDr=""
		if (PDARowId'="")
		{
			s pobjAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
			if $IsObject(pobjAge.PDAAgeDr)
			{
				s eobj.PDAAgeDr =pobjAge.PDAAgeDr.%Id() 
			}
			s eobj.PDAMaxVal=pobjAge.PDAMaxVal
			s eobj.PDAMinVal=pobjAge.PDAMinVal
			if $IsObject(pobjAge.PDAUomDr)
			{
				s eobj.PDAUomDr = pobjAge.PDAUomDr.%Id() 
			}
			d pobjAge.%Close()
			k pobjAge
		}
		//通过索引获取生理业务表的RowId——PHYVRowId
		s PHYVRowId=0
		for {
			s PHYVRowId=$o(^DHCPHYVAL(0,"Inst",id,PHYVRowId)) q:PHYVRowId="" 
			s objPhy=##class(User.DHCPhysiologyVal).%OpenId(PHYVRowId)
			if (objPhy.PHYVType="S")
			{
				s eobj.SysPressMinVal=objPhy.PHYVMinVal
				s eobj.SysPressMaxVal=objPhy.PHYVMaxVal
					
				d objPhy.%Close()
				k objPhy			
			}
			else
			{
				s eobj.DiaPressMinVal=objPhy.PHYVMinVal
				s eobj.DiaPressMaxVal=objPhy.PHYVMaxVal
				
				d objPhy.%Close()
				k objPhy		
			}
		}
	
		;病症
		s PHDDRowId=0
		for
		{
			s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",id,PHDDRowId)) q:PHDDRowId=""
			s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
			if (PHDDDiseaDr'="") 
			{
				if (eobj.PHDDDiseaDr'="")
				{
					s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_","_eobj.PHDDDiseaDr
				}
				else
				{
					s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
				}
			} 
		}

		;特殊人群
		s SPEPIRowId=0
		for
		{
			s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",id,SPEPIRowId)) q:SPEPIRowId=""
			//s eobj.SpecialPopu=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)_"^"_eobj.SpecialPopu
			s SPEPISpecDr=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)
			s:SPEPISpecDr'="" eobj.SpecialPopu=$p(^DHCSPEP(SPEPISpecDr),"^",2)_","_eobj.SpecialPopu		
		}
		d pobjIns.%Close()
		k pobjIns
		s str = eobj.JsonS()
		//s str = "{list:["_str_"]}"
		q str
}

/// Description：打开适应症数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCBusMainNew).OpenIndData("1")
ClassMethod OpenECGIndData(id As %String) As %String
{
		s str=""	
		s eobj = ##class(web.Entity.KB.DHCECGDiseaseI).%New()
		s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
		s eobj.PHDDInstDr=id
		s eobj.PHDDRowId=$o(^DHCPHDDIS("0","Inst",id,0))
		s eobj.PHINSTMode=pobjIns.PHINSTMode
		s eobj.PHINSTText=pobjIns.PHINSTText

		;病症
		s PHDDRowId=0
		for{
			s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",id,PHDDRowId)) q:PHDDRowId=""
			s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
			if (PHDDDiseaDr'="") {
				if (eobj.PHDDDiseaDr'=""){
					s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_","_eobj.PHDDDiseaDr
				}
				else{
					s eobj.PHDDDiseaDr = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
				}
			} 
		}
		
		;检查结果
		s EXAIRowId=0
		for{
			s EXAIRowId=$o(^DHCLIBEXAI(0,"Inst",id,EXAIRowId)) q:EXAIRowId=""
			s EXAIExamDr=$p(^DHCLIBEXAI(EXAIRowId),"^",2)
			if (EXAIExamDr'="") {
				if (eobj.PHDDExamDr'=""){
					s eobj.PHDDExamDr = $p(^DHCEXAMINE(EXAIExamDr),"^",2)_","_eobj.PHDDExamDr
				}
				else{
					s eobj.PHDDExamDr = $p(^DHCEXAMINE(EXAIExamDr),"^",2)
				}
			} 
		}

		d pobjIns.%Close()
		k pobjIns
		s str = eobj.JsonS()
		//s str = "{data:["_str_"]}"
		q str
}

}
