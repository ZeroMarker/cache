//页面Event
function InitReportNWinEvent(obj){
	CheckSpecificKey();
	//初始化字典数据
	$.form.SelectRender("#cboIRBacteria"); 
	$.form.SelectRender("#cboIRBacteriaV"); 
	$.form.SelectRender("#cboIRBacteriaU"); 
	//$.form.iCheckRender();  //渲染复选框|单选钮
	//$.form.DateRender("txtIRIntuDate","");
	
	//弹出
	obj.LayerNICURep = function()
	{
		var rd = obj.layerRep_rd;
		var RepStatus = rd["RepStatus"];
		var Paadm = rd["Paadm"];
		layer.config({extend:'layerskin/style.css'});
		obj.layerIdxICURep = layer.open({
				skin: 'btn-all-blue',
				type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
				zIndex: 100,
				maxmin: false,
				title: "NICU调查表填写", 
				area: ['100%','100%'],
				content: $('#LayerNICURep'),
				btn: ['保存','提交','审核','删除'],
				btnAlign: 'c',
				yes: function(index, layero){
				  	//保存
					var ret = obj.RepSave("2","1");
					if(parseInt(ret)>0)
					{
						obj.gridLogsN.ajax.reload(function(){
							layer.msg('保存成功!',{time: 2000,icon: 1});
						},false);
						//layer.close(index);						
					}
					else if (parseInt(ret) ==0)
					{
						layer.msg('保存失败!',{icon: 2});
					}	
					
				},
				btn2: function(index, layero){
					//提交
					var ret = obj.RepSave("2","2");
				  	if(parseInt(ret)>0)
					{
						obj.gridLogsN.ajax.reload(function(){
							layer.msg('提交成功!',{time: 2000,icon: 1});
						},false);
						obj.doClose();
						return true;						
					}
					else if (parseInt(ret) ==0)
					{
						layer.msg('提交失败!',{icon: 2});
						return false;
					}	
					else
					{
						return false;
					}
				},
				btn3: function(index, layero){
					//审核
					var IsUnCheck = $.Tool.RunServerMethod("DHCHAI.IRS.INFICUSrv","GetIsUnCheck",Paadm);
					if (IsUnCheck>0) {
						layer.msg('无新内容需审核!',{icon: 0});
						return false;
					}else {
						var ret = obj.RepSave("2","3");
					  	if(parseInt(ret)>0)
						{
							obj.gridLogsN.ajax.reload(function(){
								var IsCheck = $.Tool.RunServerMethod("DHCHAI.IRS.INFICUSrv","CheckItem",Paadm);
								if (IsCheck>0) {
									layer.msg('审核成功!',{time: 2000,icon: 1});
									obj.doClose();
									return true;
								}else {
									layer.msg('审核失败!',{icon: 2});
									return false;
								}
							},false);								
						}
						else if (parseInt(ret) ==0)
						{
							layer.msg('审核失败!',{icon: 2});
							return false;
						}	
						else
						{
							return false;
						}
					}
				},
				btn4: function(index, layero){
					//删除
					var ret = obj.RepSave("2","4");
				  	if(parseInt(ret)>0)
					{
						obj.gridLogsN.ajax.reload(function(){
							layer.msg('删除成功!',{time: 2000,icon: 1});
						},false);
						obj.doClose();
						return true;						
					}
					else if (parseInt(ret) ==0)
					{
						layer.msg('删除失败!',{icon: 2});
						return false;
					}	
					else
					{
						return false;
					}
				},
				success: function(layero,index){
					var button0 = layero.find(".layui-layer-btn0"); //保存
					var button1 = layero.find(".layui-layer-btn1"); //提交
					var button2 = layero.find(".layui-layer-btn2"); //审核
					var button3 = layero.find(".layui-layer-btn3"); //删除
					//var IsUnCheck = $.Tool.RunServerMethod("DHCHAI.IRS.INFICUSrv","GetIsUnCheck",Paadm);
					
					//展示回调
					if (!RepStatus) {
						$(button2).hide();
						$(button3).hide();
					}
					else if(RepStatus=="删除")
					{
						$(button0).hide();
						$(button1).hide();
						$(button2).hide();
						$(button3).hide();
					}
					else if(RepStatus=="提交")
					{
						$(button0).hide();
						$(button1).hide();
					}
					else if(RepStatus=="审核")
					{
						$(button0).hide();
						$(button1).hide();
						/*
						if (IsUnCheck >0) {
							$(button2).hide();
						}*/
						$(button3).hide();
					}
					//layer.full(index);
					refreshGridNICUOEItems();
					refreshGridNPICC();
					refreshGridNVAP();
					refreshGridNUC();
					//赋值数据
					$.form.SetValue("FormVo.pRegNoN",rd["RegNo"]);
					$.form.SetValue("FormVo.pNameN",rd["PatientName"]);
					$.form.SetValue("FormVo.pNoN",rd["PapmiNo"]);
					$.form.SetValue("FormVo.pSexN",rd["Sex"]);
					$.form.SetValue("FormVo.pAgeN",rd["Age"]);
					$.form.SetValue("FormVo.pAdmDateN",rd["PAAdmDate"]);
					$.form.SetValue("FormVo.pDisDateN",rd["PADischDate"]);
					$.form.SetValue("FormVo.pDisDateN",rd["PADischDate"]);
					$.form.SetValue("FormVo.pPatWeight",rd["PatWeight"]);
					//选中事件
					//位置错误，导致第一次打开且点击事件关闭后，不刷新界面，再次打开点击时多次弹出layer
					/*
					obj.gridNPICC.on('dblclick', 'tr', function(e) {
						var rd = obj.gridNPICC.row(this).data();
						obj.layerNPICC_rd = rd;
						obj.LayerNPICC();
					});
					obj.gridNVAP.on('dblclick', 'tr', function(e) {
						var rd = obj.gridNVAP.row(this).data();
						obj.layerNVAP_rd = rd;
						obj.LayerNVAP();
					});
					obj.gridNUC.on('dblclick', 'tr', function(e) {
						var rd = obj.gridNUC.row(this).data();
						obj.layerNUC_rd = rd;
						obj.LayerNUC();
					});
					*/
				},
				cancel: function(index){ 
					obj.ReportID = "";
					obj.doClose();
				}
		});
		
	};
	//弹出
	obj.LayerNPICC = function()
	{
		var rd = obj.layerRep_rd;
		obj.layerIdxNPICC = layer.open({
				type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
				zIndex: 101,
				area: '600px',
				maxmin: false
				,title: "中心置管-编辑", 
				content: $('#LayerNPICC'),
				btn: ['保存','取消'],
				btnAlign: 'c',		
				yes: function(index, layero){
					//日期校验
					var IRIntuDate = $.form.GetValue("txtIRIntuDateN");
					var IRExtuDate = $.form.GetValue("txtIRExtuDateN");		
					if(IRIntuDate==""||IRExtuDate=="")
					{
						layer.msg('置管日期或拔管日期不可以为空!',{icon: 2});
						return;						
					}
					var rst = $.form.CompareDate(IRExtuDate,IRIntuDate);
					if(rst<1)
					{
						layer.msg('拔管日期不能早于置管日期!',{icon: 2});
						return;		
					}
				  	//保存数据入库
					obj.LayerNPICC_Save();
					//表格加载数据
					refreshGridNPICC();
					layer.close(index);
				}
				,success: function(layero){
					//展示回调
					$.form.DateRender("txtIRIntuDateN","");
					$.form.DateRender("txtIRExtuDateN","");
					$.form.DateRender("txtIRInfDateN","");
					$.form.clearDivInput("LayerNPICC");
					$('#chkIRIsInfN').on('ifChecked', function(event){ 
						//ifCreated 事件应该在插件初始化之前绑定 ifUnchecked
						//alert(event.type + ' callback'); 
						$('#txtIRInfDateN').attr("disabled",false);
						$('#cboIRBacteria').attr("disabled",false);
					});
					$('#chkIRIsInfN').on('ifUnchecked', function(event){ 
						//ifCreated 事件应该在插件初始化之前绑定 ifUnchecked
						//alert(event.type + ' callback'); 
						$('#txtIRInfDateN').val("");
						$.form.SetValue('cboIRBacteria','');
						$('#txtIRInfDateN').attr("disabled",true);
						$('#cboIRBacteria').attr("disabled",true);
					});
					var rdPICC = obj.layerNPICC_rd;
					var rdICUOEItems = obj.gridNICUOEItems.rows({selected: true}).data().toArray()[0];
					if ((typeof rdICUOEItems != "undefined")&&(rdICUOEItems.OeItemType == "中心静脉置管")) {
						var StartDt = rdICUOEItems.StartDt.split(" ")[0];
						var EndDate = (rdICUOEItems.TypeValue == "临时医嘱") ? StartDt : rdICUOEItems.EndDt.split(" ")[0];
						$.form.DateRender("txtIRIntuDateN",StartDt);
						$.form.DateRender("txtIRExtuDateN",EndDate);
					}
					
					if(rdPICC)
					{						
						if(rdPICC["IRIntuDate"]!="")
						{
							$.form.DateRender("txtIRIntuDateN",rdPICC["IRIntuDate"]);	
						}
						if(rdPICC["IRExtuDate"]!="")
						{
							$.form.DateRender("txtIRExtuDateN",rdPICC["IRExtuDate"]);	
						}
						
						if(rdPICC["IRIsInf"]=="1")
						{
							$("#chkIRIsInfN").iCheck("check");  //IRIsInf	"0"
						}
						else
						{
							$('#txtIRInfDateN').val("");
							$.form.SetValue('cboIRBacteria','');
							$('#txtIRInfDateN').attr("disabled",true);
							$('#cboIRBacteria').attr("disabled",true);
						}
						if(rdPICC["IRInfDate"]!="")
						{
							$.form.DateRender("txtIRInfDateN",rdPICC["IRInfDate"]);	
						}
						if(rdPICC["IRBacteria"]!="")
						{
							$("#cboIRBacteria").val(rdPICC["IRBacteria"]).trigger("change"); 
						}
					}
					else
					{
						$('#txtIRInfDateN').val("");
						$.form.SetValue('cboIRBacteria','');
						$('#txtIRInfDateN').attr("disabled",true);
						$('#cboIRBacteria').attr("disabled",true);
					}
				}
		});
	};
	//PICC数据保存
	obj.LayerNPICC_Save=function(){
		var rd = obj.layerRep_rd;
		var rdPICC = obj.layerNPICC_rd
		var ID = (rdPICC ? rdPICC["ID"] : "");
		
		var Paadm = rd.Paadm;
		var LocID = $('#ulLoc').val();  //调查科室 ？= 当前科室 rd.LocID
		var IRIntuDate = $.form.GetValue("txtIRIntuDateN");
		var IRIntuTime = "";  //插管时间
		var IRExtuDate = $.form.GetValue("txtIRExtuDateN");
		var IRExtuTime ="";   //拔管时间
		var IRPICCType = "";
		var IRPICCCnt = "";
		var IRPICCPos = "";
		var IROperDoc = "";
		var IROperLoc = "";
		var IRIsInf = $.form.GetValue("chkIRIsInfN");
		var IRInfDate = $.form.GetValue("txtIRInfDateN");
		var IRInfSymptoms = "";
		var IRBacteria = $.form.GetValue("cboIRBacteria");  //病原体 $.form.GetValue("cboIRInfSymptoms")
		var UpdateUserDr = $.LOGON.USERID;   //$.LOGON.USERID
		/*
		if (LocCode == '') {
			layer.alert("科室代码不允许为空");
			return;
		}
		*/
		
		var InputStr = ID;
		InputStr += "^" + Paadm;
		InputStr += "^" + LocID;
		InputStr += "^" + IRIntuDate;
		InputStr += "^" + IRIntuTime;
		InputStr += "^" + IRExtuDate;
		InputStr += "^" + IRExtuTime;
		InputStr += "^" + IRPICCType;
		InputStr += "^" + IRPICCCnt;
		InputStr += "^" + IRPICCPos;
		InputStr += "^" + IROperDoc;
		InputStr += "^" + IROperLoc;
		InputStr += "^" + IRIsInf;
		InputStr += "^" + IRInfDate;
		InputStr += "^" + IRInfSymptoms;
		InputStr += "^" + IRBacteria;
		InputStr += "^" + UpdateUserDr;
		InputStr += "^" + 0;     //是否审核
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.INFICUPICC","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridNPICC.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridNPICC,retval);
				if (rowIndex > -1){
					var rd =obj.gridNPICC.row(rowIndex).data();
					obj.layerNPICC_rd = rd;
				} else {
					obj.layerNPICC_rd = "";
				}
				layer.msg('保存成功!',{time: 2000,icon: 1});
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	};
	//弹出
	obj.LayerNVAP = function()
	{
		var rd = obj.layerRep_rd;
		obj.layerIdxNVAP = layer.open({
				type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
				zIndex: 101,
				area: '600px',
				maxmin: false
				,title: "气管插拔-编辑", 
				content: $('#LayerNVAP'),
				btn: ['保存','取消'],
				btnAlign: 'c',		
				yes: function(index, layero){
					//日期校验
					var IRIntuDate = $.form.GetValue("txtIRIntuDateVN");
					var IRExtuDate = $.form.GetValue("txtIRExtuDateVN");		
					if(IRIntuDate==""||IRExtuDate=="")
					{
						layer.msg('置管日期或拔管日期不可以为空!',{icon: 2});
						return;						
					}
					var rst = $.form.CompareDate(IRExtuDate,IRIntuDate);
					if(rst<1)
					{
						layer.msg('拔管日期不能早于置管日期!',{icon: 2});
						return;		
					}
				  	//保存数据入库
					obj.LayerNVAP_Save();
					//表格加载数据
					refreshGridNVAP();
					layer.close(index);
				}
				,success: function(layero){
					//展示回调
					$.form.DateRender("txtIRIntuDateVN","");
					$.form.DateRender("txtIRExtuDateVN","");
					$.form.DateRender("txtIRInfDateVN","");
					$.form.clearDivInput("LayerNVAP");
					$('#chkIRIsInfVN').on('ifChecked', function(event){ 
						//ifCreated 事件应该在插件初始化之前绑定 ifUnchecked
						//alert(event.type + ' callback'); 
						$('#txtIRInfDateVN').attr("disabled",false);
						$('#cboIRBacteriaV').attr("disabled",false);
					});
					$('#chkIRIsInfVN').on('ifUnchecked', function(event){ 
						//ifCreated 事件应该在插件初始化之前绑定 ifUnchecked
						//alert(event.type + ' callback'); 
						$('#txtIRInfDateVN').val("");
						$.form.SetValue('cboIRBacteriaV','');
						$('#txtIRInfDateVN').attr("disabled",true);
						$('#cboIRBacteriaV').attr("disabled",true);
					});
					var rdVAP = obj.layerNVAP_rd;
					var rdICUOEItems = obj.gridNICUOEItems.rows({selected: true}).data().toArray()[0];
					if ((typeof rdICUOEItems != "undefined")&&(rdICUOEItems.OeItemType == "中心静脉置管")) {
						var StartDt = rdICUOEItems.StartDt.split(" ")[0];
						var EndDate = (rdICUOEItems.TypeValue == "临时医嘱") ? StartDt : rdICUOEItems.EndDt.split(" ")[0];
						$.form.DateRender("txtIRIntuDateVN",StartDt);
						$.form.DateRender("txtIRExtuDateVN",EndDate);
					}
					
					if(rdVAP)
					{						
						if(rdVAP["IRIntuDate"]!="")
						{
							$.form.DateRender("txtIRIntuDateVN",rdVAP["IRIntuDate"]);	
						}
						if(rdVAP["IRExtuDate"]!="")
						{
							$.form.DateRender("txtIRExtuDateVN",rdVAP["IRExtuDate"]);	
						}
						
						if(rdVAP["IRIsInf"]=="1")
						{
							$("#chkIRIsInfVN").iCheck("check");  //IRIsInf	"0"
						}
						else
						{
							$('#txtIRInfDateVN').val("");
							$.form.SetValue('cboIRBacteriaV','');
							$('#txtIRInfDateVN').attr("disabled",true);
							$('#cboIRBacteriaV').attr("disabled",true);
						}
						if(rdVAP["IRInfDate"]!="")
						{
							$.form.DateRender("txtIRInfDateVN",rdVAP["IRInfDate"]);	
						}
						if(rdVAP["IRBacteria"]!="")
						{
							$("#cboIRBacteriaV").val(rdVAP["IRBacteria"]).trigger("change"); 
						}
					}
					else
					{
						$('#txtIRInfDateVN').val("");
						$.form.SetValue('cboIRBacteriaV','');
						$('#txtIRInfDateVN').attr("disabled",true);
						$('#cboIRBacteriaV').attr("disabled",true);
					}
				}
		});
	};
	//VAP数据保存
	obj.LayerNVAP_Save=function(){
		var rd = obj.layerRep_rd;
		var rdVAP = obj.layerNVAP_rd
		var ID = (rdVAP ? rdVAP["ID"] : "");
		
		var Paadm = rd.Paadm;
		var LocID = $('#ulLoc').val();  //调查科室 ？= 当前科室 rd.LocID
		var IRIntuDate = $.form.GetValue("txtIRIntuDateVN");
		var IRIntuTime = "";  //插管时间
		var IRExtuDate = $.form.GetValue("txtIRExtuDateVN");
		var IRExtuTime ="";   //拔管时间
		var IRVAPType = "";
		var IROperDoc ="";
		var IROperLoc = "";
		var IRIsInf = $.form.GetValue("chkIRIsInfVN");
		var IRInfDate = $.form.GetValue("txtIRInfDateVN");
		var IRInfSymptoms = "";
		var IRBacteria = $.form.GetValue("cboIRBacteriaV");  //病原体
		var UpdateUserDr = $.LOGON.USERID;   //$.LOGON.USERID
		/*
		if (LocCode == '') {
			layer.alert("科室代码不允许为空");
			return;
		}
		*/
		
		var InputStr = ID;
		InputStr += "^" + Paadm;
		InputStr += "^" + LocID;
		InputStr += "^" + IRIntuDate;
		InputStr += "^" + IRIntuTime;
		InputStr += "^" + IRExtuDate;
		InputStr += "^" + IRExtuTime;
		InputStr += "^" + IRVAPType;
		InputStr += "^" + IROperDoc;
		InputStr += "^" + IROperLoc;
		InputStr += "^" + IRIsInf;
		InputStr += "^" + IRInfDate;
		InputStr += "^" + IRInfSymptoms;
		InputStr += "^" + IRBacteria;
		InputStr += "^" + UpdateUserDr;
		InputStr += "^" + 0;     //是否审核
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.INFICUVAP","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridNVAP.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridNVAP,retval);
				if (rowIndex > -1){
					var rd =obj.gridNVAP.row(rowIndex).data();
					obj.layerNVAP_rd = rd;
				} else {
					obj.layerNVAP_rd = "";
				}
				layer.msg('保存成功!',{time: 2000,icon: 1});
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	};
	//弹出
	obj.LayerNUC = function()
	{
		var rd = obj.layerRep_rd;
		obj.layerIdxNUC = layer.open({
				type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
				zIndex: 101,
				area: '600px',
				maxmin: false
				,title: "脐静脉-编辑", 
				content: $('#LayerNUC'),
				btn: ['保存','取消'],
				btnAlign: 'c',		
				yes: function(index, layero){
					var IRIntuDate = $.form.GetValue("txtIRIntuDateUN");
					var IRExtuDate = $.form.GetValue("txtIRExtuDateUN");		
					if(IRIntuDate==""||IRExtuDate=="")
					{
						layer.msg('置管日期或拔管日期不可以为空!',{icon: 2});
						return;						
					}
					var rst = $.form.CompareDate(IRExtuDate,IRIntuDate);
					if(rst<1)
					{
						layer.msg('拔管日期不能早于置管日期!',{icon: 2});
						return;		
					}
				  	//保存数据入库
					obj.LayerNUC_Save();
					//表格加载数据
					refreshGridNUC();
					layer.close(index);
				}
				,success: function(layero){
					//展示回调
					$.form.DateRender("txtIRIntuDateUN","");
					$.form.DateRender("txtIRExtuDateUN","");
					$.form.DateRender("txtIRInfDateUN","");
					$.form.clearDivInput("LayerNUC");
					$('#chkIRIsInfUN').on('ifChecked', function(event){ 
						//ifCreated 事件应该在插件初始化之前绑定 ifUnchecked
						//alert(event.type + ' callback'); 
						$('#txtIRInfDateUN').attr("disabled",false);
						$('#cboIRBacteriaU').attr("disabled",false);
					});
					$('#chkIRIsInfUN').on('ifUnchecked', function(event){ 
						//ifCreated 事件应该在插件初始化之前绑定 ifUnchecked
						//alert(event.type + ' callback'); 
						$('#txtIRInfDateUN').val("");
						$.form.SetValue('cboIRBacteriaU','');
						$('#txtIRInfDateUN').attr("disabled",true);
						$('#cboIRBacteriaU').attr("disabled",true);
					});
					var rdUC = obj.layerNUC_rd;
					var rdICUOEItems = obj.gridNICUOEItems.rows({selected: true}).data().toArray()[0];
					if ((typeof rdICUOEItems != "undefined")&&(rdICUOEItems.OeItemType == "中心静脉置管")) {
						var StartDt = rdICUOEItems.StartDt.split(" ")[0];
						var EndDate = (rdICUOEItems.TypeValue == "临时医嘱") ? StartDt : rdICUOEItems.EndDt.split(" ")[0];
						$.form.DateRender("txtIRIntuDateUN",StartDt);
						$.form.DateRender("txtIRExtuDateUN",EndDate);
					}
					
					if(rdUC)
					{						
						if(rdUC["IRIntuDate"]!="")
						{
							$.form.DateRender("txtIRIntuDateUN",rdUC["IRIntuDate"]);	
						}
						if(rdUC["IRExtuDate"]!="")
						{
							$.form.DateRender("txtIRExtuDateUN",rdUC["IRExtuDate"]);	
						}
						
						if(rdUC["IRIsInf"]=="1")
						{
							$("#chkIRIsInfUN").iCheck("check");  //IRIsInf	"0"
						}
						else
						{
							$('#txtIRInfDateUN').val("");
							$.form.SetValue('cboIRBacteriaU','');
							$('#txtIRInfDateUN').attr("disabled",true);
							$('#cboIRBacteriaU').attr("disabled",true);
						}
						if(rdUC["IRInfDate"]!="")
						{
							$.form.DateRender("txtIRInfDateUN",rdUC["IRInfDate"]);	
						}
						if(rdUC["IRBacteria"]!="")
						{
							$("#cboIRBacteriaU").val(rdUC["IRBacteria"]).trigger("change"); 
						}
					}
					else
					{
						$('#txtIRInfDateUN').val("");
						$.form.SetValue('cboIRBacteriaU','');
						$('#txtIRInfDateUN').attr("disabled",true);
						$('#cboIRBacteriaU').attr("disabled",true);
					}
				}
		});
	};
	//UC数据保存
	obj.LayerNUC_Save=function(){
		var rd = obj.layerRep_rd;
		var rdUC = obj.layerNUC_rd
		var ID = (rdUC ? rdUC["ID"] : "");
		
		var Paadm = rd.Paadm;
		var LocID = $('#ulLoc').val();  //调查科室 ？= 当前科室 rd.LocID
		var IRIntuDate = $.form.GetValue("txtIRIntuDateUN");
		var IRIntuTime = "";  //插管时间
		var IRExtuDate = $.form.GetValue("txtIRExtuDateUN");
		var IRExtuTime ="";   //拔管时间
		var IRUCType = "";
		var IROperDoc = "";
		var IROperLoc = "";
		var IRIsInf = $.form.GetValue("chkIRIsInfUN");
		var IRInfDate = $.form.GetValue("txtIRInfDateUN");
		var IRInfSymptoms = "";
		var IRBacteria = $.form.GetValue("cboIRBacteriaU");  //病原体
		var UpdateUserDr = $.LOGON.USERID;   //$.LOGON.USERID  
		/*
		if (LocCode == '') {
			layer.alert("科室代码不允许为空");
			return;
		}
		*/
		
		var InputStr = ID;
		InputStr += "^" + Paadm;
		InputStr += "^" + LocID;
		InputStr += "^" + IRIntuDate;
		InputStr += "^" + IRIntuTime;
		InputStr += "^" + IRExtuDate;
		InputStr += "^" + IRExtuTime;
		InputStr += "^" + IRUCType;
		InputStr += "^" + IROperDoc;
		InputStr += "^" + IROperLoc;
		InputStr += "^" + IRIsInf;
		InputStr += "^" + IRInfDate;
		InputStr += "^" + IRInfSymptoms;
		InputStr += "^" + IRBacteria;
		InputStr += "^" + UpdateUserDr;
		InputStr += "^" + 0;     //是否审核
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.INFICUUC","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridNUC.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridNUC,retval);
				if (rowIndex > -1){
					var rd =obj.gridNUC.row(rowIndex).data();
					obj.layerNUC_rd = rd;
				} else {
					obj.layerNUC_rd = "";
				}
				layer.msg('保存成功!',{time: 2000,icon: 1});
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	};
	//链接选中方式
    $('#gridLogsN').on('click', 'a.editor_edit', function (e) {
        e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridLogsN.row(tr);
		var rowData = row.data();
		obj.layerRep_rd = rowData;
		//alert(rowData.LocID+"---"+rowData.SurveryDate);
		
		//弹出界面
		obj.LayerNICURep();
		
    });
	$("#btnNPiccAdd").on('click', function(){
		//带管日志明细
		//$('td', row).eq(7)
		var rst = "";
		obj.layerNPICC_rd = "";
		obj.LayerNPICC();
	});
	$("#btnNPiccDel").on('click', function(){
		var selectedRows = obj.gridNPICC.rows({selected: true}).count();
		if ( selectedRows !== 1 ) 
		{
			layer.msg('请选择要删除的记录!');
			return;
		}
		var rd = obj.gridNPICC.rows({selected: true}).data().toArray()[0];
		var IsCheck = rd["IsCheck"];
		if ( IsCheck == 1 ) 
		{
			layer.msg('该记录已审核，不允许删除!',{icon: 0});
			return;
		}
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消']    //btn位置对应function的位置
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.INFICUPICC","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!');
				} else {
					obj.gridNPICC.rows({selected:true}).remove().draw(false);
					obj.layerNPICC_rd = "";
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	$("#btnNVapAdd").on('click', function(){
		//带管日志明细
		//$('td', row).eq(7)
		var rst = "";
		obj.layerNVAP_rd = "";
		obj.LayerNVAP();
	});
	$("#btnNVapDel").on('click', function(){
		var selectedRows = obj.gridNVAP.rows({selected: true}).count();
		if ( selectedRows !== 1 ) 
		{
			layer.msg('请选择要删除的记录!');
			return;
		}
		var rd = obj.gridNVAP.rows({selected: true}).data().toArray()[0];
		var IsCheck = rd["IsCheck"];
		if ( IsCheck == 1 ) 
		{
			layer.msg('该记录已审核，不允许删除!',{icon: 0});
			return;
		}
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消']    //btn位置对应function的位置
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.INFICUVAP","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!');
				} else {
					obj.gridNVAP.rows({selected:true}).remove().draw(false);
					obj.layerNVAP_rd = "";
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	$("#btnNUcAdd").on('click', function(){
		//带管日志明细
		//$('td', row).eq(7)
		var rst = "";
		obj.layerNUC_rd = "";
		obj.LayerNUC();
	});
	$("#btnNUcDel").on('click', function(){
		var selectedRows = obj.gridNUC.rows({selected: true}).count();
		if ( selectedRows !== 1 ) 
		{
			layer.msg('请选择要删除的记录!');
			return;
		}
		var rd = obj.gridNUC.rows({selected: true}).data().toArray()[0];
		var IsCheck = rd["IsCheck"];
		if ( IsCheck == 1 ) 
		{
			layer.msg('该记录已审核，不允许删除!',{icon: 0});
			return;
		}
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消']    //btn位置对应function的位置
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.INFICUUC","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!');
				} else {
					obj.gridNUC.rows({selected:true}).remove().draw(false);
					obj.layerNUC_rd="";
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	/*
	$("#btnPrintN").on('click', function(){
		obj.gridLogsN.buttons(0,null)[1].node.click();
	});
	*/
	$("#btnExportN").on('click', function(){
		//导出
		obj.gridLogsN.buttons(0,null)[0].node.click();
		
	});
	//end by chenjb 20170725
	$('#ulNOeItem > li').click(function (e) {
		e.preventDefault();
		$('#ulNOeItem > li').removeClass('active');
		$(this).addClass('active');
		var val = $(this).val();
		$('#ulNOeItem').val(val);
		obj.gridNICUOEItems.ajax.reload();
	});
	
	//刷新三管医嘱表格
	function refreshGridNICUOEItems()
	{
		
		if(obj.gridNICUOEItems==undefined)
		{
			obj.gridNICUOEItems = $("#gridNICUOEItems").DataTable({
				dom: 'rt<"row"<"col-sm-10 col-xs-10"pl>>',
				select: 'single',
				paging: true,
				ordering: true,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.ICULogSrv";
						d.QueryName = "QryICUAdmOeItem";
						d.Arg1=obj.layerRep_rd.Paadm;
						d.Arg2=$('#ulNOeItem').val();
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "OeItemDesc"},
					{"data": "StartDt"},
					{"data": "EndDt"}
				]
			});
		}
		else
		{
			//存在情况下
			obj.gridNICUOEItems.ajax.reload(function(){});
		}
	}
	
	
	//刷新picc表格
	function refreshGridNPICC()
	{
		var rd = obj.layerRep_rd;
		
		if(obj.gridNPICC==undefined)
		{
			obj.gridNPICC = $("#gridNPICC").DataTable({
				dom: 'rt',
				paging:false,
				ordering: false,
				select: 'single',
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFICUPICCSrv";
						d.QueryName = "QryICUPICCByPaadm";
						d.Arg1=obj.layerRep_rd.Paadm;
						d.Arg2=$('#ulLoc').val();
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "IRIntuDate"}
					,{"data": "IRExtuDate"}
					,{"data": null,
						render: function ( data, type, row ) {
							var rst = "";
							if(data.IRIsInf=="1")
								rst = '是';
							else
								rst = '否';
							return rst
						}
					}
					,{"data": "IRInfDate"}
					,{"data": "IRBacteriaDesc"}
				],"createdRow": function ( row, data, index ) {
					if ( data.IsCheck=="1") {
						$('td', row).parent().addClass('text-success');
					}
				}	
			});
			//选中事件
			obj.gridNPICC.on('dblclick', 'tr', function(e) {
				var rd = obj.gridNPICC.row(this).data();
				obj.layerNPICC_rd = rd;
				obj.LayerNPICC();
			});
		}
		else
		{
			//存在情况下
			obj.gridNPICC.ajax.reload(function(){});
		}
	}
	//刷新picc表格
	function refreshGridNVAP()
	{
		var rd = obj.layerRep_rd;
		if(obj.gridNVAP==undefined)
		{
			obj.gridNVAP = $("#gridNVAP").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFICUVAPSrv";
						d.QueryName = "QryICUVAPByPaadm";
						d.Arg1=obj.layerRep_rd.Paadm;
						d.Arg2=$('#ulLoc').val();
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "IRIntuDate"}
					,{"data": "IRExtuDate"}
					,{"data": null,
						render: function ( data, type, row ) {
							var rst = "";
							if(data.IRIsInf=="1")
								rst = '是';
							else
								rst = '否';
							return rst
						}
					}
					,{"data": "IRInfDate"}
					,{"data": "IRBacteriaDesc"}
				],"createdRow": function ( row, data, index ) {
					if ( data.IsCheck=="1") {
						$('td', row).parent().addClass('text-success');
					}
				}	
			});
			obj.gridNVAP.on('dblclick', 'tr', function(e) {
				var rd = obj.gridNVAP.row(this).data();
				obj.layerNVAP_rd = rd;
				obj.LayerNVAP();
			});
		}
		else
		{
			//存在情况下
			obj.gridNVAP.ajax.reload(function(){});
		}
	}
	//刷新uc表格
	function refreshGridNUC()
	{
		var rd = obj.layerRep_rd;
		if(obj.gridNUC==undefined)
		{
			obj.gridNUC = $("#gridNUC").DataTable({
				dom: 'rt',
				paging:false,
				ordering: false,
				select: 'single',
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFICUUCSrv";
						d.QueryName = "QryICUUCByPaadm";
						d.Arg1=obj.layerRep_rd.Paadm;
						d.Arg2=$('#ulLoc').val();
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "IRIntuDate"}
					,{"data": "IRExtuDate"}
					,{"data": null,
						render: function ( data, type, row ) {
							var rst = "";
							if(data.IRIsInf=="1")
								rst = '是';
							else
								rst = '否';
							return rst
						}
					}
					,{"data": "IRInfDate"}
					,{"data": "IRBacteriaDesc"}
				],"createdRow": function ( row, data, index ) {
					if ( data.IsCheck=="1") {
						$('td', row).parent().addClass('text-success');
					}
				}	
			});
			obj.gridNUC.on('dblclick', 'tr', function(e) {
				var rd = obj.gridNUC.row(this).data();
				obj.layerNUC_rd = rd;
				obj.LayerNUC();
			});
		}
		else
		{
			//存在情况下
			obj.gridNUC.ajax.reload(function(){});
		}
	}
	obj.doClose =function () {
		var tt =parent.window.opener;
	   	if(EpisodeID!="") {
		   window.top.opener = null;  
		   window.top.close(); 
	   	}  
	   	obj.ReportID ="";
	   	//ShowModal 参数暂未用
	   
	};
}