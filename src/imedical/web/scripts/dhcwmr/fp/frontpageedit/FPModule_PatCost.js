function InitPatCost(obj) {
	obj.PatCost=''
		+ '<table align="center" style="border:1px solid #84C1FF;" cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div style="font-size:22px;text-align:center;margin-bottom:5px;margin-top:10px;">'
		+ '		本次住院费用信息'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportContent" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">住院费用总计</div></td><td><div id="TC-txtP60000000" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '         <table><tr>'
		+ '         	<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">综合医疗服务类</span></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">一般医疗服务费</div></td><td><div id="TC-txtP60010000" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">一般治疗操作费</div></td><td><div id="TC-txtP60020000" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">护理费</div></td><td><div id="TC-txtP60030000" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">其他费用</div></td><td><div id="TC-txtP60040000" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '         <table><tr>'
		+ '         	<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">诊断类</span></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">病理诊断费</div></td><td><div id="TC-txtP60050000" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">实验室诊断费</div></td><td><div id="TC-txtP60060000" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">影像学诊断费</div></td><td><div id="TC-txtP60070000" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">临床诊断项目费</div></td><td><div id="TC-txtP60080000" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '         <table><tr>'
		+ '         	<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">治疗类</span></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">非手术治疗项目费</div></td><td><div id="TC-txtP60090000" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">临床物理治疗费</div></td><td><div id="TC-txtP60090100" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">麻醉费</div></td><td><div id="TC-txtP60100100" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">手术费</div></td><td><div id="TC-txtP60100200" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '         <table><tr>'
		+ '         	<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">康复类</span></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">康复费</div></td><td><div id="TC-txtP60110000" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '         <table><tr>'
		+ '         	<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">中医类</span></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">中医治疗费</div></td><td><div id="TC-txtP60130000" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '         <table><tr>'
		+ '         	<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">西药类</span></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">西药费</div></td><td><div id="TC-txtP60150000" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">抗菌药物费</div></td><td><div id="TC-txtP60150100" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '         <table><tr>'
		+ '         	<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">中药类</span></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">中成药费</div></td><td><div id="TC-txtP60160000" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">中草药费</div></td><td><div id="TC-txtP60170000" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '         <table><tr>'
		+ '         	<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">血液制品类</span></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">血费</div></td><td><div id="TC-txtP60180000" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">白蛋白类制品费</div></td><td><div id="TC-txtP60190000" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">球蛋白类制品费</div></td><td><div id="TC-txtP60200000" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">凝血因子类制品费</div></td><td><div id="TC-txtP60210000" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">细胞因子类制品费</div></td><td><div id="TC-txtP60220000" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '         <table><tr>'
		+ '         	<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">耗材类</span></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">检查用一次性医用材料费</div></td><td><div id="TC-txtP60230000" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">治疗用一次性医用材料费</div></td><td><div id="TC-txtP60240000" class="TD-content"></div></td>'
		+ '				<td><div class="TD-title">手术用一次性医用材料费</div></td><td><div id="TC-txtP60250000" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '         <table><tr>'
		+ '         	<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">其他类</span></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div class="TD-title">其他费</div></td><td><div id="TC-txtP60260000" class="TD-content"></div></td>'
		+ '			</tr></table>'
		+ '		</tr></td></div>'
		+ '</table>'
		
		obj.txtP60000000=Common_TextField("txtP60000000","总费用");
		obj.txtP60250000=Common_TextField("txtP60250000","手术用一次性医用材料费");
		obj.txtP60240000=Common_TextField("txtP60240000","治疗用一次性医用材料费");
		obj.txtP60230000=Common_TextField("txtP60230000","检查用一次性医用材料费");
		obj.txtP60040000=Common_TextField("txtP60040000","其他费用");
		obj.txtP60070000=Common_TextField("txtP60070000","影像学诊断费");
		obj.txtP60100200=Common_TextField("txtP60100200","手术费");
		obj.txtP60010000=Common_TextField("txtP60010000","一般医疗服务费");
		obj.txtP60020000=Common_TextField("txtP60020000","一般治疗操作费");
		obj.txtP60030000=Common_TextField("txtP60030000","护理费");
		obj.txtP60080000=Common_TextField("txtP60080000","临床诊断项目费");
		obj.txtP60090100=Common_TextField("txtP60090100","临床物理治疗费");
		obj.txtP60060000=Common_TextField("txtP60060000","实验室诊断费");
		obj.txtP60050000=Common_TextField("txtP60050000","病理诊断费");
		obj.txtP60090000=Common_TextField("txtP60090000","非手术治疗项目费");
		obj.txtP60270000=Common_TextField("txtP60270000","介入治疗费");
		obj.txtP60100100=Common_TextField("txtP60100100","麻醉费");
		obj.txtP60110000=Common_TextField("txtP60110000","康复费");
		obj.txtP60130000=Common_TextField("txtP60130000","中医治疗费");
		obj.txtP60180000=Common_TextField("txtP60180000","血费");
		obj.txtP60260000=Common_TextField("txtP60260000","其他费");
		obj.txtP60150000=Common_TextField("txtP60150000","西药费");
		obj.txtP60150100=Common_TextField("txtP60150100","抗菌药物费");
		obj.txtP60160000=Common_TextField("txtP60160000","中成药费");
		obj.txtP60170000=Common_TextField("txtP60170000","中草药费");
		obj.txtP60190000=Common_TextField("txtP60190000","白蛋白类制品费");
		obj.txtP60200000=Common_TextField("txtP60200000","球蛋白类制品费");
		obj.txtP60210000=Common_TextField("txtP60210000","凝血因子类制品费");
		obj.txtP60220000=Common_TextField("txtP60220000","细胞因子类制品费");
}
