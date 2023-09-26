//页面Event
function InitReportWinEvent(obj){
	CheckSpecificKey();
	var LocID=$.LOGON.LOCID; //登录科室
	var LocDesc=$.LOGON.LOCDESC; //登录科室
	var IsAdmin = 0;
	if (tDHCMedMenuOper['Admin']==1) {
		IsAdmin = 1;  //管理员权限
	}
	if(EpisodeID!="")
	{
		$("#divLeft").hide();
		//$("#divLeft").css("visibility","hidden");
	}
	//初始化字典数据
	$.form.SelectRender("#LayerPICC");  //渲染下拉框
	$.form.SelectRender("#LayerVAP");  //渲染下拉框
	$.form.SelectRender("#LayerUC");  //渲染下拉框
	$.form.CheckBoxRender("#divpInfEffect");
	$.form.iCheckRender();  //渲染复选框|单选钮
	//$.form.DateRender("txtIRIntuDate","");
	//日期切换刷新
	$("#startDate").change(function(){
		dateChange();
	});
	$("#endDate").change(function(){
		dateChange();
	});
	$("#cboIntuType").change(function(){
		dateChange();
	});
	function dateChange(){
	    var txt=$('#ulLoc > li.active').attr("text");
	    var arr = txt.split("^");
		myLoading();
		if ($(".Loading_animate_content").length != 0) {
			myLoadingBug();
			$(".Loading_animate_content").css("display","block");
		}
		if(arr.length==2){
			var locID = arr[0];
			var nicuFlag = arr[1];
			$('#ulLoc').val(locID);
			if(nicuFlag=="1"){  //NICU科室
				var objGrid = $('#gridLogsN');
				if (objGrid){
					objGrid.DataTable().clear().draw();
				}
				$('.icu-mode-list').hide();
				$('.nicu-mode-list').show();
				setTimeout(refreshGridLogsN,0.2*1000);  //错开达到异步
			}else if (nicuFlag=="0"){  //ICU科室
				var objGrid = $('#gridLogs');
				if (objGrid){
					objGrid.DataTable().clear().draw();
				}
				$('.nicu-mode-list').hide();
				$('.icu-mode-list').show();
				setTimeout(refreshGridLogs,0.2*1000);  //错开达到异步
			}else{  //未配置
				var objGrid = $('#gridLogs');
				if (objGrid){
					objGrid.DataTable().clear().draw();
				}
				$('.nicu-mode-list').hide();
				$('.icu-mode-list').show();
				//setTimeout(refreshGridLogs,0.2*1000);  //错开达到异步
				myLoadHiden();
			}
		}	    			
	}
	
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		refreshLocList();
	});
	refreshLocList();
	//科室列表
	function refreshLocList() {
		if (IsAdmin!=1) {
			$.form.SetValue("cboHospital",$.LOGON.HOSPID,$.LOGON.HOSPDESC);// 默认加载登录院区
			$("#cboHospital").attr('disabled','disabled');
			var hospId = $.form.GetValue("cboHospital");
			var runQuery = $.Tool.RunQuery('DHCHAI.BTS.LocationSrv','QryICULoc',hospId,$.LOGON.LOCID);
		}else{
			var hospId = $.form.GetValue("cboHospital");
			var runQuery = $.Tool.RunQuery('DHCHAI.BTS.LocationSrv','QryICULoc',hospId);
		}
		if(runQuery){
			$("#ulLoc").empty();
			var icuLocFlag = 0;
			var arrDT = runQuery.record;
			for (var idx = 0; idx < arrDT.length; idx++){
				var obj = arrDT[idx];
				if((IsAdmin!=1)&&(LocID!=obj.ID)) {
					continue;
				}
				icuLocFlag = 1;
				if (obj.IsNICU=="1"){
					$("#ulLoc").append('<li class="active" text="' + obj.ID + '^1">' + obj.LocDesc2 + '<small class="pull-right bg-yellow">NICU</small></li>');
				} else {
					$("#ulLoc").append('<li text="'+obj.ID+'^0">' + obj.LocDesc2 + '</li>');
				}
			}
			if (icuLocFlag<1){
				$("#ulLoc").append('<li text="'+$.LOGON.LOCID+'^-1">' + $.LOGON.LOCDESC + '(未配置)</li>');
			}
		}
		//科室选中逻辑
		$('#ulLoc > li').click(function (e) {
			e.preventDefault();
			$('#ulLoc > li').removeClass('active');
			$(this).addClass('active');
			myLoading();
			if ($(".Loading_animate_content").length != 0) {
				myLoadingBug();
				$(".Loading_animate_content").css("display","block");
			}
			var txt = $(this).attr("text");
			var arr = txt.split("^");
			if(arr.length==2){
				var locID = arr[0];
				var nicuFlag = arr[1];
				$('#ulLoc').val(locID);
				//暂时写死
				if (nicuFlag=="1"){  //NICU科室
					$('.icu-mode-list').hide();
					$('.nicu-mode-list').show();
					setTimeout(refreshGridLogsN,0.1*1000);  //错开达到异步
				}else if (nicuFlag=="0"){  //ICU科室
					$('.nicu-mode-list').hide();
					$('.icu-mode-list').show();
					setTimeout(refreshGridLogs,0.1*1000);  //错开达到异步
				}else{  //未配置
					var objGrid = $('#gridLogs');
					if (objGrid){
						objGrid.DataTable().clear().draw();
					}
					$('.nicu-mode-list').hide();
					$('.icu-mode-list').show();
					//setTimeout(refreshGridLogs,0.1*1000);  //错开达到异步
					myLoadHiden();
				}
			}	    		
		});
		//科室第一条选中触发
		$('#ulLoc li:first-child').click();
	}
	
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridLogs').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridLogs.search(this.value).draw();
        }
    });
	$("#btnsearchN").on('click', function(){
       $('#gridLogsN').DataTable().search($('#searchN').val(),true,true).draw();
       
    });
	
    $("#searchN").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridLogsN.search(this.value).draw();
        }
    });
    /****************/
	//弹出
	obj.LayerICURep = function()
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
				title: "ICU调查表填写", 
				area: ['100%','100%'],
				content: $('#LayerICURep'),
				btn: ['保存','提交','审核','删除'],
				btnAlign: 'c',
				yes: function(index, layero){
				  	//保存
					var ret = obj.RepSave("3","1");
					if(parseInt(ret)>0)
					{
						obj.gridLogs.ajax.reload(function(){
							layer.msg('保存成功!',{time: 2000,icon: 1});
						},false);
						
					}
					else
					{
						layer.msg('保存失败!',{icon: 2});
					}
				},
				btn2: function(index, layero){
					//提交
					var ret = obj.RepSave("3","2");
					if(parseInt(ret)>0)
					{
						obj.gridLogs.ajax.reload(function(){
							layer.msg('提交成功!',{time: 2000,icon: 1});
						},false);
						obj.doClose();
						return true;						
					}
					else
					{
						layer.msg('提交失败!',{icon: 2});
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
						var ret = obj.RepSave("3","3");
						if(parseInt(ret)>0)
						{
							obj.gridLogs.ajax.reload(function(){
								var IsCheck = $.Tool.RunServerMethod("DHCHAI.IRS.INFICUSrv","CheckItem",Paadm);
								if (IsCheck>0) {
									layer.msg('审核成功!',{time: 2000,icon: 1});									
									return true;
								}else {
									layer.msg('审核失败!',{icon: 2});
									return false;
								}
							},false);								
						}
						else
						{
							layer.msg('审核失败!',{icon: 2});
							return false;
						}
					}	
				},
				btn4: function(index, layero){
					//删除
					var ret = obj.RepSave("3","4");
				  	if(parseInt(ret)>0)
					{
						obj.gridLogs.ajax.reload(function(){
							layer.msg('删除成功!',{time: 2000,icon: 1});
						},false);
						obj.doClose();
						return true;						
					}
					else
					{
						layer.msg('删除失败!',{icon: 2});
						return false;
					}	
				},
				success: function(layero,index){
					//展示回调	RepStatus
					var button0 = layero.find(".layui-layer-btn0"); //保存
					var button1 = layero.find(".layui-layer-btn1"); //提交
					var button2 = layero.find(".layui-layer-btn2"); //审核
					var button3 = layero.find(".layui-layer-btn3"); //删除
					//var IsUnCheck = $.Tool.RunServerMethod("DHCHAI.IRS.INFICUSrv","GetIsUnCheck",Paadm);
				
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
						}
						*/
						$(button3).hide();
					}
					
					//layer.full(index);
					refreshGridICUOEItems();
					refreshGridPICC();
					refreshGridVAP();
					refreshGridUC();
					//赋值数据
					$.form.SetValue("FormVo.pRegNo",rd["RegNo"]);
					$.form.SetValue("FormVo.pName",rd["PatientName"]);
					$.form.SetValue("FormVo.pNo",rd["PapmiNo"]);
					$.form.SetValue("FormVo.pSex",rd["Sex"]);
					$.form.SetValue("FormVo.pAge",rd["Age"]);
					$.form.SetValue("FormVo.pAdmDate",rd["PAAdmDate"]);
					$.form.SetValue("FormVo.pDisDate",rd["PADischDate"]);
					$.form.SetValue("FormVo.pDisDate",rd["PADischDate"]);
				},
				cancel: function(index){ 
					obj.ReportID ="";
					obj.doClose();
				}
		});
		
	};
	obj.LayerInfRep = function()
	{
		var rd = obj.layerRep_rd;
		
		obj.layerIdxInfRep = layer.open({
				type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
				zIndex: 100,
				maxmin: false,
				title: "院感报告填写", 
				area: ['100%','100%'],
				content: $('#LayerInfRep'),
				btn: ['保存','提交','审核','删除'],
				btnAlign: 'c',
				yes: function(index, layero){
				  	//保存						
					var ret = obj.InfRepSave("1","1");
					if(parseInt(ret)>0)
					{
						obj.gridLogs.ajax.reload(function(){
							layer.msg('保存成功!',{time: 2000,icon: 1});
						},false);
						layer.close(index);
					}
					else
					{
						layer.msg('保存失败!',{icon: 2});
					}
				},
				btn2: function(index, layero){
					//提交
					var ret = obj.InfRepSave("1","2");
					if(parseInt(ret)>0)
					{
						obj.gridLogs.ajax.reload(function(){
							layer.msg('提交成功!',{time: 2000,icon: 1});
						},false);
						return true;						
					}
					else
					{
						layer.msg('提交失败!',{icon: 2});
						return false;
					}				  	
				},
				btn3: function(index, layero){
					//审核
					var ret = obj.InfRepSave("1","3");
					if(parseInt(ret)>0)
					{
						obj.gridLogs.ajax.reload(function(){
							layer.msg('审核成功!',{time: 2000,icon: 1});
						},false);
						return true;						
					}
					else
					{
						layer.msg('审核失败!',{icon: 2});
						return false;
					}	
				},
				btn4: function(index, layero){
					//删除
					var ret = obj.InfRepSave("1","4");
				  	if(parseInt(ret)>0)
					{
						obj.gridLogs.ajax.reload(function(){
							layer.msg('删除成功!',{time: 2000,icon: 1});
						},false);
						return true;						
					}
					else
					{
						layer.msg('删除失败!',{icon: 2});
						return false;
					}	
				},
				success: function(layero,index){
					//展示回调 绑定事件	互斥事件
					/*
					$("#divpInfEffect input:checkbox").on('ifChecked', function(event){		
						var $this = $(this);
						$("#divpInfEffect input:checkbox").each(function (){							
							if($this===$(this)||$this.get(0)==$(this).get(0))	
							{
								//同一个情况下
							}
							else{
								$(this).iCheck("uncheck");
								$(this).iCheck("update");
							}							
						});							
					});
					*/	
					
					
					$.form.DateRender("FormVopInfDate","");	
					$.form.DateRender("FormVopIRInfXDate","");					
					//赋值数据
					$.form.SetValue("FormVo.pIRegNo",rd["RegNo"]);
					$.form.SetValue("FormVo.pIName",rd["PatientName"]);
					$.form.SetValue("FormVo.pINo",rd["PapmiNo"]);
					$.form.SetValue("FormVo.pISex",rd["Sex"]);
					$.form.SetValue("FormVo.pIAge",rd["Age"]);
					$.form.SetValue("FormVo.pIAdmDate",rd["PAAdmDate"]);
					$.form.SetValue("FormVo.pIDisDate",rd["PADischDate"]);
					$.form.SetValue("FormVo.pIDisDate",rd["PADischDate"]);
					$.form.SetValue("FormVo.pIRepUser",$.LOGON.USERDESC);
					//下拉框动态赋值
					//alert(rd["LocID"]); 列表是病区ID
					$("#cbopInfLoc").data("param",rd["Paadm"]+"^E");					
					$.form.SelectRender("#cbopInfLoc");
					$.form.SelectRender("#cbopInfPos");
					$.form.SelectRender("#cbopInfPosSub");
					//$("#cbopInfLoc").val("9").trigger("change"); 
				}
		});
		
	};
	//弹出
	obj.LayerPICC = function()
	{
		var rd = obj.layerRep_rd;
		obj.layerIdxPICC = layer.open({
				type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
				zIndex: 101,
				area: '600px',
				maxmin: false
				,title: "中心静脉置管-编辑", 
				content: $('#LayerPICC'),
				btn: ['保存','关闭'],
				btnAlign: 'c',				
				yes: function(index, layero){
					/*
					var $el = $("#chkGrp");
					$('input:checkbox',$el).each( function (){
						alert($(this).is(":checked"));
					});
					return;
					*/
					//日期校验
					var IRIntuDate = $.form.GetValue("txtIRIntuDate");
					var IRExtuDate = $.form.GetValue("txtIRExtuDate");		
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
					//必填校验
					var IRPICCType = $.form.GetValue("cboIRPICCType");
					if(IRPICCType=="")
					{
						layer.msg('导管类型不可以为空!',{icon: 2});
						return;	
					}
					var IRPICCCnt = $.form.GetValue("cboIRPICCCnt");
					if(IRPICCCnt=="")
					{
						layer.msg('导管腔数不可以为空!',{icon: 2});
						return;	
					}
					var IRPICCPos = $.form.GetValue("cboIRPICCPos");
					if(IRPICCPos=="")
					{
						layer.msg('置管部位不可以为空!',{icon: 2});
						return;	
					}
					var IROperDoc = $.form.GetValue("cboIROperDoc");
					if(IROperDoc=="")
					{
						layer.msg('置管人员不可以为空!',{icon: 2});
						return;	
					}
					var IROperLoc = $.form.GetValue("cboIROperLoc");
					if(IROperLoc=="")
					{
						layer.msg('置管地点不可以为空!',{icon: 2});
						return;	
					}
				  	//保存数据入库
					obj.LayerPICC_Save();
					//表格加载数据
					refreshGridPICC();
					layer.close(index);
				}
				,success: function(layero){
					//展示回调
					$.form.DateRender("txtIRIntuDate","");
					$.form.DateRender("txtIRExtuDate","");
					$.form.DateRender("txtIRInfDate","","top-right");
					//$("#LayerPICC input").val("");					
					$.form.clearDivInput("LayerPICC");
					$('#chkIRIsInf').on('ifChecked', function(event){ 
						//ifCreated 事件应该在插件初始化之前绑定 ifUnchecked
						//alert(event.type + ' callback'); 
						$('#txtIRInfDate').attr("disabled",false);
						$('#cboIRInfSymptoms').attr("disabled",false);
					});
					$('#chkIRIsInf').on('ifUnchecked', function(event){ 
						//ifCreated 事件应该在插件初始化之前绑定 ifUnchecked
						//alert(event.type + ' callback'); 
						$('#txtIRInfDate').val("");
						$.form.SetValue('cboIRInfSymptoms','');
						$('#txtIRInfDate').attr("disabled",true);
						$('#cboIRInfSymptoms').attr("disabled",true);
					});
					var rdPICC = obj.layerPICC_rd;
					var rdICUOEItems = obj.gridICUOEItems.rows({selected: true}).data().toArray()[0];
					if ((typeof rdICUOEItems != "undefined")&&(rdICUOEItems.OeItemType == "中心静脉置管")) {
						var StartDt = rdICUOEItems.StartDt.split(" ")[0];
						var EndDate = (rdICUOEItems.TypeValue == "临时医嘱") ? StartDt : rdICUOEItems.EndDt.split(" ")[0];
						$.form.DateRender("txtIRIntuDate",StartDt);
						$.form.DateRender("txtIRExtuDate",EndDate);
					}
					
					if(rdPICC)
					{
						if(rdPICC["IRPICCType"]!="")
						{
							$("#cboIRPICCType").val(rdPICC["IRPICCType"]).trigger("change"); 
						}
						if(rdPICC["IRPICCCnt"]!="")
						{
							$("#cboIRPICCCnt").val(rdPICC["IRPICCCnt"]).trigger("change"); 
						}
						if(rdPICC["IRPICCPos"]!="")
						{
							$("#cboIRPICCPos").val(rdPICC["IRPICCPos"]).trigger("change"); 
						}
						if(rdPICC["IRIntuDate"]!="")
						{
							$.form.DateRender("txtIRIntuDate",rdPICC["IRIntuDate"]);	
						}
						if(rdPICC["IRExtuDate"]!="")
						{
							$.form.DateRender("txtIRExtuDate",rdPICC["IRExtuDate"]);	
						}
						if(rdPICC["IROperDoc"]!="")
						{
							$("#cboIROperDoc").val(rdPICC["IROperDoc"]).trigger("change"); 
						}
						if(rdPICC["IROperLoc"]!="")
						{
							$("#cboIROperLoc").val(rdPICC["IROperLoc"]).trigger("change"); 
						}
						if(rdPICC["IRIsInf"]=="1")
						{
							$("#chkIRIsInf").iCheck("check");  //IRIsInf	"0"
							
						}
						else
						{
							$('#txtIRInfDate').val("");
							$.form.SetValue('cboIRInfSymptoms','');
							$('#txtIRInfDate').attr("disabled",true);
							$('#cboIRInfSymptoms').attr("disabled",true);
						}
						if(rdPICC["IRInfDate"]!="")
						{
							$.form.DateRender("txtIRInfDate",rdPICC["IRInfDate"],"top-right");	
						}
						if(rdPICC["IRInfSymptoms"]!="")
						{
							$("#cboIRInfSymptoms").val(rdPICC["IRInfSymptoms"]).trigger("change"); 
						}
					}
					else
					{
						$('#txtIRInfDate').val("");
						$.form.SetValue('cboIRInfSymptoms','');
						$('#txtIRInfDate').attr("disabled",true);
						$('#cboIRInfSymptoms').attr("disabled",true);
					}
				}
		});
	};
	//PICC数据保存
	obj.LayerPICC_Save=function(){
		var rd = obj.layerRep_rd;
		var rdPICC = obj.layerPICC_rd;
		var ID = (rdPICC ? rdPICC["ID"] : "");
		
		var Paadm = rd.Paadm;
		var LocID = $('#ulLoc').val();  //调查科室 ？= 当前科室 rd.LocID
		var IRIntuDate = $.form.GetValue("txtIRIntuDate");
		var IRIntuTime = "";  //插管时间
		var IRExtuDate = $.form.GetValue("txtIRExtuDate");
		var IRExtuTime ="";   //拔管时间
		var IRPICCType = $.form.GetValue("cboIRPICCType");
		var IRPICCCnt = $.form.GetValue("cboIRPICCCnt");
		var IRPICCPos = $.form.GetValue("cboIRPICCPos");
		var IROperDoc = $.form.GetValue("cboIROperDoc");
		var IROperLoc = $.form.GetValue("cboIROperLoc");
		var IRIsInf = $.form.GetValue("chkIRIsInf");
		var IRInfDate = $.form.GetValue("txtIRInfDate");
		var IRInfSymptoms = $.form.GetValue("cboIRInfSymptoms");
		var IRBacteria = "";  //病原体
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
			obj.gridPICC.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridPICC,retval);
				if (rowIndex > -1){
					var rd =obj.gridPICC.row(rowIndex).data();
					obj.layerPICC_rd = rd;
				} else {
					obj.layerPICC_rd = "";
				}
				layer.msg('保存成功!',{time: 2000,icon: 1});
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	};
	//弹出
	obj.LayerVAP = function()
	{
		var rd = obj.layerRep_rd;
		obj.layerIdxVAP = layer.open({
				type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
				zIndex: 101,
				area: '600px',
				maxmin: false
				,title: "呼吸机-编辑", 
				content: $('#LayerVAP'),
				btn: ['保存','关闭'],
				btnAlign: 'c',
				yes: function(index, layero){
					//日期校验
					var IRIntuDate = $.form.GetValue("txtIRIntuDateV");
					var IRExtuDate = $.form.GetValue("txtIRExtuDateV");		
					if(IRIntuDate==""||IRExtuDate=="")
					{
						layer.msg('上机日期或脱机日期不可以为空!',{icon: 2});
						return;						
					}
					var rst = $.form.CompareDate(IRExtuDate,IRIntuDate);
					if(rst<1)
					{
						layer.msg('脱机日期不可以大于上机日期!',{icon: 2});
						return;		
					}
					//必填校验
					var IRVAPType = $.form.GetValue("cboIRVAPType");
					if(IRVAPType=="")
					{
						layer.msg('气道类型不可以为空!',{icon: 2});
						return;						
					}
					var IROperDoc = $.form.GetValue("cboIROperDocV");
					if(IROperDoc=="")
					{
						layer.msg('置管人员不可以为空!',{icon: 2});
						return;						
					}
					var IROperLoc = $.form.GetValue("cboIROperLocV");
					if(IROperLoc=="")
					{
						layer.msg('置管地点不可以为空!',{icon: 2});
						return;						
					}
				  	//保存数据入库
					obj.LayerVAP_Save();
					//表格加载数据
					refreshGridVAP();
					layer.close(index);
				}
				,success: function(layero){
					//展示回调
					$.form.DateRender("txtIRIntuDateV","");
					$.form.DateRender("txtIRExtuDateV","");
					$.form.DateRender("txtIRInfDateV","","top-right");
					$.form.clearDivInput("LayerVAP");
					$('#chkIRIsInfV').on('ifChecked', function(event){ 
						//ifCreated 事件应该在插件初始化之前绑定 ifUnchecked
						//alert(event.type + ' callback'); 
						$('#txtIRInfDateV').attr("disabled",false);
					});
					$('#chkIRIsInfV').on('ifUnchecked', function(event){ 
						//ifCreated 事件应该在插件初始化之前绑定 ifUnchecked
						//alert(event.type + ' callback'); 
						$('#txtIRInfDateV').val("");
						$('#txtIRInfDateV').attr("disabled",true);
					});
					var rdVAP = obj.layerVAP_rd;
					var rdICUOEItems = obj.gridICUOEItems.rows({selected: true}).data().toArray()[0];
					if ((typeof rdICUOEItems != "undefined")&&(rdICUOEItems.OeItemType == "呼吸机")) {
						var StartDt = rdICUOEItems.StartDt.split(" ")[0];
						var EndDate = (rdICUOEItems.TypeValue == "临时医嘱") ? StartDt : rdICUOEItems.EndDt.split(" ")[0];
						$.form.DateRender("txtIRIntuDateV",StartDt);
						$.form.DateRender("txtIRExtuDateV",EndDate);
					}
					
					if(rdVAP)
					{
						if(rdVAP["IRVAPType"]!="")
						{
							$("#cboIRVAPType").val(rdVAP["IRVAPType"]).trigger("change"); 
						}
						
						if(rdVAP["IRIntuDate"]!="")
						{
							$.form.DateRender("txtIRIntuDateV",rdVAP["IRIntuDate"]);	
						}
						if(rdVAP["IRExtuDate"]!="")
						{
							$.form.DateRender("txtIRExtuDateV",rdVAP["IRExtuDate"]);	
						}
						if(rdVAP["IROperDoc"]!="")
						{
							$("#cboIROperDocV").val(rdVAP["IROperDoc"]).trigger("change"); 
						}
						if(rdVAP["IROperLoc"]!="")
						{
							$("#cboIROperLocV").val(rdVAP["IROperLoc"]).trigger("change"); 
						}
						if(rdVAP["IRIsInf"]=="1")
						{
							$("#chkIRIsInfV").iCheck("check");  //IRIsInf	"0"
						}
						else
						{
							$('#txtIRInfDateV').val("");
							$('#txtIRInfDateV').attr("disabled",true);
						}
						if(rdVAP["IRInfDate"]!="")
						{
							$.form.DateRender("txtIRInfDateV",rdVAP["IRInfDate"],"top-right");	
						}
						
					}
					else
					{
						$('#txtIRInfDateV').val("");
						$('#txtIRInfDateV').attr("disabled",true);
					}
				}
		});
	};
	//VAP数据保存
	obj.LayerVAP_Save=function(){
		var rd = obj.layerRep_rd;
		var rdVAP = obj.layerVAP_rd
		var ID = (rdVAP ? rdVAP["ID"] : "");
		
		var Paadm = rd.Paadm;
		var LocID = $('#ulLoc').val();  //调查科室 ？= 当前科室 rd.LocID
		var IRIntuDate = $.form.GetValue("txtIRIntuDateV");
		var IRIntuTime = "";  //插管时间
		var IRExtuDate = $.form.GetValue("txtIRExtuDateV");
		var IRExtuTime ="";   //拔管时间
		var IRVAPType = $.form.GetValue("cboIRVAPType");
		var IROperDoc = $.form.GetValue("cboIROperDocV");
		var IROperLoc = $.form.GetValue("cboIROperLocV");
		var IRIsInf = $.form.GetValue("chkIRIsInfV");
		var IRInfDate = $.form.GetValue("txtIRInfDateV");
		var IRInfSymptoms = "";
		var IRBacteria = "";  //病原体
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
			obj.gridVAP.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridVAP,retval);
				if (rowIndex > -1){
					var rd =obj.gridVAP.row(rowIndex).data();
					obj.layerVAP_rd = rd;
				} else {
					obj.layerVAP_rd = "";
				}
				layer.msg('保存成功!',{time: 2000,icon: 1});
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	};
	//弹出
	obj.LayerUC = function()
	{
		var rd = obj.layerRep_rd;
		obj.layerIdxUC = layer.open({
				type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
				zIndex: 101,
				area: '600px',
				maxmin: false
				,title: "泌尿道插管-编辑", 
				content: $('#LayerUC'),
				btn: ['保存','关闭'],
				btnAlign: 'c',
				yes: function(index, layero){
					//日期校验
					var IRIntuDate = $.form.GetValue("txtIRIntuDateU");
					var IRExtuDate = $.form.GetValue("txtIRExtuDateU");		
					if(IRIntuDate==""||IRExtuDate=="")
					{
						layer.msg('插管日期或拔管日期不可以为空!',{icon: 2});
						return;						
					}
					var rst = $.form.CompareDate(IRExtuDate,IRIntuDate);
					if(rst<1)
					{
						layer.msg('拔管日期不能早于置管日期!',{icon: 2});
						return;		
					}
					//必填校验
					var IRUCType = $.form.GetValue("cboIRUCType");
					if(IRUCType=="")
					{
						layer.msg('尿管类型不可以为空!',{icon: 2});
						return;						
					}
					var IROperDoc = $.form.GetValue("cboIROperDocU");
					if(IROperDoc=="")
					{
						layer.msg('置管人员不可以为空!',{icon: 2});
						return;						
					}
					var IROperLoc = $.form.GetValue("cboIROperLocU");
					if(IROperLoc=="")
					{
						layer.msg('置管地点不可以为空!',{icon: 2});
						return;						
					}
				  	//保存数据入库
					obj.LayerUC_Save();
					//表格加载数据
					refreshGridUC();
					layer.close(index);
				}
				,success: function(layero){
					//展示回调
					$.form.DateRender("txtIRIntuDateU","");
					$.form.DateRender("txtIRExtuDateU","");
					$.form.DateRender("txtIRInfDateU","","top-right");
					$.form.clearDivInput("LayerUC");
					$('#chkIRIsInfU').on('ifChecked', function(event){ 
						//ifCreated 事件应该在插件初始化之前绑定 ifUnchecked
						//alert(event.type + ' callback'); 
						$('#txtIRInfDateU').attr("disabled",false);
					});
					$('#chkIRIsInfU').on('ifUnchecked', function(event){ 
						//ifCreated 事件应该在插件初始化之前绑定 ifUnchecked
						//alert(event.type + ' callback'); 
						$('#txtIRInfDateU').val("");
						$('#txtIRInfDateU').attr("disabled",true);
					});
					var rdUC = obj.layerUC_rd;
					var rdICUOEItems = obj.gridICUOEItems.rows({selected: true}).data().toArray()[0];
					if ((typeof rdICUOEItems != "undefined")&&(rdICUOEItems.OeItemType == "导尿管")) {
						var StartDt = rdICUOEItems.StartDt.split(" ")[0];
						var EndDate = (rdICUOEItems.TypeValue == "临时医嘱") ? StartDt : rdICUOEItems.EndDt.split(" ")[0];
						$.form.DateRender("txtIRIntuDateU",StartDt);
						$.form.DateRender("txtIRExtuDateU",EndDate);
					}
					
					if(rdUC)
					{
						if(rdUC["IRUCType"]!="")
						{
							$("#cboIRUCType").val(rdUC["IRUCType"]).trigger("change"); 
						}
						
						if(rdUC["IRIntuDate"]!="")
						{
							$.form.DateRender("txtIRIntuDateU",rdUC["IRIntuDate"]);	
						}
						if(rdUC["IRExtuDate"]!="")
						{
							$.form.DateRender("txtIRExtuDateU",rdUC["IRExtuDate"]);	
						}
						if(rdUC["IROperDoc"]!="")
						{
							$("#cboIROperDocU").val(rdUC["IROperDoc"]).trigger("change"); 
						}
						if(rdUC["IROperLoc"]!="")
						{
							$("#cboIROperLocU").val(rdUC["IROperLoc"]).trigger("change"); 
						}
						if(rdUC["IRIsInf"]=="1")
						{
							$("#chkIRIsInfU").iCheck("check");  //IRIsInf	"0"
						}
						else
						{
							$('#txtIRInfDateU').val("");
							$('#txtIRInfDateU').attr("disabled",true);
						}
						if(rdUC["IRInfDate"]!="")
						{
							$.form.DateRender("txtIRInfDateU",rdUC["IRInfDate"],"top-right");	
						}
						
					}
					else
					{
						$('#txtIRInfDateU').val("");
						$('#txtIRInfDateU').attr("disabled",true);
					}
				}
		});
	};
	//UC数据保存
	obj.LayerUC_Save=function(){
		var rd = obj.layerRep_rd;
		var rdUC = obj.layerUC_rd
		var ID = (rdUC ? rdUC["ID"] : "");
		
		var Paadm = rd.Paadm;
		var LocID = $('#ulLoc').val();  //调查科室 ？= 当前科室 rd.LocID
		var IRIntuDate = $.form.GetValue("txtIRIntuDateU");
		var IRIntuTime = "";  //插管时间
		var IRExtuDate = $.form.GetValue("txtIRExtuDateU");
		var IRExtuTime ="";   //拔管时间
		var IRUCType = $.form.GetValue("cboIRUCType");
		var IROperDoc = $.form.GetValue("cboIROperDocU");
		var IROperLoc = $.form.GetValue("cboIROperLocU");
		var IRIsInf = $.form.GetValue("chkIRIsInfU");
		var IRInfDate = $.form.GetValue("txtIRInfDateU");
		var IRInfSymptoms = "";
		var IRBacteria = "";  //病原体
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
			obj.gridUC.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridUC,retval);
				if (rowIndex > -1){
					var rd =obj.gridUC.row(rowIndex).data();
					obj.layerUC_rd = rd;
				} else {
					obj.layerUC_rd = "";
				}
				layer.msg('保存成功!',{time: 2000,icon: 1});
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	};
	//链接选中方式
    $('#gridLogs').on('click', 'a.editor_edit', function (e) {
        e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridLogs.row(tr);
		var rowData = row.data();
		obj.layerRep_rd = rowData;
		//alert(rowData.LocID+"---"+rowData.SurveryDate);
		//初始化数据
		
		//弹出界面
		obj.LayerICURep();
		
    });
	//链接选中方式
    $('#gridLogs').on('click', 'a.editor_report', function (e) {
        e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridLogs.row(tr);
		var rowData = row.data();
		obj.layerRep_rd = rowData;		
		//弹出界面
		obj.LayerInfRep();
		
    });
	$("#btnPiccAdd").on('click', function(){
		//带管日志明细
		//$('td', row).eq(7)
		var rst = "";
		obj.layerPICC_rd = "";
		obj.LayerPICC();
		if ((typeof InitSelectLoad) == "function"){
			InitSelectLoad();
		}
	});
	$("#btnPiccDel").on('click', function(){
		var selectedRows = obj.gridPICC.rows({selected: true}).count();
		if ( selectedRows !== 1 ) 
		{
			layer.msg('请选择要删除的记录!');
			return;
		}
		var rd = obj.gridPICC.rows({selected: true}).data().toArray()[0];
		var IsCheck = rd["IsCheck"];
		if ( IsCheck == 1 ) 
		{
			layer.msg('该记录已审核，不允许删除!',{icon: 0});
			return;
		}
		var ID = rd["ID"];
		
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.INFICUPICC","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!');
				} else {
					obj.gridPICC.rows({selected:true}).remove().draw(false);
					obj.layerPICC_rd = "";
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	$("#btnVapAdd").on('click', function(){
		//带管日志明细
		//$('td', row).eq(7)
		var rst = "";
		obj.layerVAP_rd = "";
		obj.LayerVAP();
		if ((typeof InitSelectLoad) == "function"){
			InitSelectLoad();
		}
	});
	$("#btnVapDel").on('click', function(){
		var selectedRows = obj.gridVAP.rows({selected: true}).count();
		if ( selectedRows !== 1 ) 
		{
			layer.msg('请选择要删除的记录!');
			return;
		}
		var rd = obj.gridVAP.rows({selected: true}).data().toArray()[0];
		var IsCheck = rd["IsCheck"];
		if ( IsCheck == 1 ) 
		{
			layer.msg('该记录已审核，不允许删除!',{icon: 0});
			return;
		}
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.INFICUVAP","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!');
				} else {
					obj.gridVAP.rows({selected:true}).remove().draw(false);
					obj.layerVAP_rd = "";
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	$("#btnUcAdd").on('click', function(){
		//带管日志明细
		//$('td', row).eq(7)
		var rst = "";
		obj.layerUC_rd = "";
		obj.LayerUC();
		if ((typeof InitSelectLoad) == "function"){
			InitSelectLoad();
		}
	});
	$("#btnUcDel").on('click', function(){
		var selectedRows = obj.gridUC.rows({selected: true}).count();
		if ( selectedRows !== 1 ) 
		{
			layer.msg('请选择要删除的记录!');
			return;
		}
		var rd = obj.gridUC.rows({selected: true}).data().toArray()[0];
		var IsCheck = rd["IsCheck"];
		if ( IsCheck == 1 ) 
		{
			layer.msg('该记录已审核，不允许删除!',{icon: 0});
			return;
		}
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.INFICUUC","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!');
				} else {
					obj.gridUC.rows({selected:true}).remove().draw(false);
					obj.layerUC_rd="";
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	/*
	$("#btnPrint").on('click', function(){
		obj.gridLogs.buttons(0,null)[2].node.click();
	});
	*/
	$("#btnExport").on('click', function(){
		//导出
		obj.gridLogs.buttons(0,null)[1].node.click();
		
	});
	
	$('#ulOeItem > li').click(function (e) {
		e.preventDefault();
		$('#ulOeItem > li').removeClass('active');
		$(this).addClass('active');
		var val = $(this).val();
		$('#ulOeItem').val(val);
		obj.gridICUOEItems.ajax.reload();
	});
	
	$('#ulPaadmStatus > li').click(function (e) {
		e.preventDefault();
		$('#ulPaadmStatus > li').removeClass('active');
		$(this).addClass('active');
		var val = $(this).val();
		$('#ulPaadmStatus').val(val);
		$('#ulLoc li:first-child').click();
	});
	//刷新三管医嘱表格
	function refreshGridICUOEItems()
	{
		var rd = obj.layerRep_rd;
		if(obj.gridICUOEItems==undefined)
		{
			obj.gridICUOEItems = $("#gridICUOEItems").DataTable({
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
						d.Arg2=$('#ulOeItem').val();
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
			obj.gridICUOEItems.ajax.reload(function(){});
		}
	}
	
	//刷新ICU患者列表
	function refreshGridLogs()
	{
		//var rd = obj.layerRep_rd;
		if(obj.gridLogs==undefined)
		{
			obj.gridLogs = $("#gridLogs").DataTable({
			dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
			paging:true,
			ordering: true,
			"iDisplayLength" : 50,
			"deferRender": true,
			"processing" : true,
			"scrollX": true,
			"scrollY": true,
			columnDefs: [
				{"className": "dt-center", "targets": "_all"}
			],
			ajax: {
				"url": "dhchai.query.datatables.csp",
				"data": function (d) {
					d.ClassName = "DHCHAI.IRS.INFICUPICCSrv";
					d.QueryName = "QryICUAdmByStatus";
					d.Arg1=$("#startDate").val();
					d.Arg2=$("#endDate").val();
					d.Arg3=$('#ulLoc').val();  //NICU调查表
					d.Arg4=$('#ulPaadmStatus').val();
					d.Arg5="3";
					d.Arg6=$("#cboIntuType").val();
					d.Arg7=EpisodeID;
					d.ArgCnt = 7;
				}
			},
			columns: [
				{"data": "PapmiNo"},
				{"data": "PatientName"},
				{"data": "Sex"},
				{"data": "Age"},
				{"data": "PAAdmDate"},
				{"data": "PADischDate"},
				{"data": "AdmWardDesc"},
				{"data": "PAAdmBed"},
				{
					"data": null,
					 render: function ( data, type, row ) {
						var rst = "";
						if(data.IsVAP=="1")
							rst = '新开';
						else if(data.IsVAP=="2")
							rst = '新停';
						return rst
					}
				},
				{
					"data": null,
					 render: function ( data, type, row ) {
						var rst = "";
						if(data.IsUC=="1")
							rst = '新开';
						else if(data.IsUC=="2")
							rst = '新停';
						return rst
					}
				},
				{
					"data": null,
					 render: function ( data, type, row ) {
						var rst = "";
						if(data.IsPICC=="1")
							rst = '新开';
						else if(data.IsPICC=="2")
							rst = '新停';
						return rst
					}
				},
				{"data": "RepStatus"},
				{"data": "RepUserName"},
				{"data": "RepDate"},
				{
					"data": null,
					 render: function ( data, type, row ) {
						if(data.RepID) {
							return '<a href="#" class="editor_edit">'+data.RepID+'</a>'+'';
						}else{
							return '<a href="#" class="editor_edit">编辑</a>'+'';
						}
					}
				}
			],"columnDefs": [{
				"type":"date-euro",
				"targets": [4,5]
			},
			{
				"orderable":false,
				"visiable":true,
				"targets":3	
			}],
			"createdRow": function ( row, data, index ) {
				if ( data.IsNewIn=="1") {
					$('td', row).eq(4).addClass('success');
				}
				if ( data.IsNewOut=="1") {
					$('td', row).eq(5).addClass('warning');
				}
				if ( data.IsVAP=="1") {
					$('td', row).eq(8).addClass('success');
				}
				else if(data.IsVAP=="2")
				{
					$('td', row).eq(8).addClass('warning');
				}
				if ( data.IsUC=="1") {
					$('td', row).eq(9).addClass('success');
				}
				else if(data.IsUC=="2")
				{
					$('td', row).eq(9).addClass('warning');
				}
				if ( data.IsPICC=="1") {
					$('td', row).eq(10).addClass('success');
				}
				else if(data.IsPICC=="2")
				{
					$('td', row).eq(10).addClass('warning');
				}
			}
			,"fnDrawCallback": function (oSettings) {
				
				$("#gridLogs_wrapper .dataTables_scrollBody").mCustomScrollbar({
					//scrollButtons: { enable: true },
					theme : "dark-thick",
					axis: "xy",
					callbacks:{
						whileScrolling:function(){
							$('#gridLogs_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
						}
					}
				});
				$("#gridLogs_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridLogs tr td:first"));
				//调整div高度
				var wh = $('#divMain').height();
				var arr1 = $('#gridLogs_wrapper .dataTables_scrollBody').children();
				if (arr1.length){
					var dh = $('#gridLogs_wrapper .dataTables_scrollHead').height();
					var hh = (wh - dh - 135) + "px";
					var divID = "#" + arr1[0].id;
					$(divID).height(hh);
				}
				var arr2 = $('#divMain').children();
				if (arr2.length){
					var hh = wh + "px";
					var divID = "#" + arr2[0].id;
					$(divID).height(hh);
				}
				//新加
				var api = this.api(); 
				if(api.rows({page:'current'}).data().length==1)
				{
					obj.ClickCnt =obj.ClickCnt+1;
					//一条时候触发选中一条	
					if(obj.ClickCnt==1 && EpisodeID !="")
						$("#gridLogs a.editor_edit").trigger( 'click');					
				}
	        }
		});
		
		//增加ICU表格导出打印
		new $.fn.dataTable.Buttons( obj.gridLogs, {
			buttons: [
				{
					extend: 'csv',
					text:'导出'
				},
				{
					extend: 'excel',
					text:'导出',
					title:"ICU调查登记表"
					,footer: true
					,exportOptions: {
						columns: ':visible'
						,width:50
						,orthogonal: 'export'
					},
					customize: function( xlsx ) {
						//console.log(xlsx);
						var sheet = xlsx.xl.worksheets['sheet1.xml'];
						
					}
				},
				{
					extend: 'print',
					text:'打印'
					,title:""
					,footer: true
				}
			]
		});
		myLoadHiden();
		}
		else
		{
			//存在情况下
			obj.gridLogs.ajax.reload(function(){myLoadHiden();});
		}
		
	}
	
	//刷新NICU患者列表
	function refreshGridLogsN()
	{
		//var rd = obj.layerRep_rd;
		if(obj.gridLogsN==undefined)
		{
			//Nicu日志列表
			obj.gridLogsN = $("#gridLogsN").DataTable({
				dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
				paging:true,
				ordering: true,
				"iDisplayLength" : 50,
				"scrollX": true,
				"scrollY": true,
				columnDefs: [
					{"className": "dt-center", "targets": "_all"}
				],
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFICUPICCSrv";
						d.QueryName = "QryICUAdmByStatus";
						d.Arg1=$("#startDate").val();
						d.Arg2=$("#endDate").val();
						d.Arg3=$('#ulLoc').val();  //NICU调查表
						d.Arg4=$('#ulPaadmStatus').val();
						d.Arg5="3";
						d.Arg6=$("#cboIntuType").val();
						d.Arg7=EpisodeID;
						d.ArgCnt = 7;
					}
				},
				columns: [
					{"data": "PapmiNo"
					,render: function (data, type, row) {
						return type === 'export' ?
							String.fromCharCode(2)+row.PapmiNo:data;
					}
					},
					{"data": "PatientName"},
					{"data": "Sex"},
					{"data": "Age"},
					{"data": "PAAdmDate"},
					{"data": "PADischDate"},
					{"data": "AdmWardDesc"},
					{"data": "PAAdmBed"},
					{"data": "PatWeight"},
					{
						"data": null,
						 render: function ( data, type, row ) {
							var rst = "";
							if(data.IsVAP=="1")
								rst = '新开';
							else if(data.IsVAP=="2")
								rst = '新停';
							return rst
						}
					},
					{
						"data": null,
						 render: function ( data, type, row ) {
							var rst = "";
							if(data.IsPICC=="1")
								rst = '新开';
							else if(data.IsPICC=="2")
								rst = '新停';
							return rst
						}
					},
					{"data": "RepStatus"},
					{"data": "RepUserName"},
					{"data": "RepDate"},
					{
						"data": null,
						 render: function ( data, type, row ) {
							if(data.RepID) {
								return '<a href="#" class="editor_edit">'+data.RepID+'</a>'+'';
							}else{
								return '<a href="#" class="editor_edit">编辑</a>'+'';
							}
						}
					}
				],"columnDefs": [{
					"type":"date-euro",
					"targets": [4,5]
				},
				{
					"orderable":false,
					"visiable":true,
					"targets":3	
				}],
				"createdRow": function ( row, data, index ) {
					if ( data.IsNewIn=="1") {
						$('td', row).eq(4).addClass('success');
					}
					if ( data.IsNewOut=="1") {
						$('td', row).eq(5).addClass('warning');
					}
					if ( data.IsVAP=="1") {
						$('td', row).eq(9).addClass('success');
					}
					else if(data.IsVAP=="2")
					{
						$('td', row).eq(9).addClass('warning');
					}
					if ( data.IsPICC=="1") {
						$('td', row).eq(10).addClass('success');
					}
					else if(data.IsPICC=="2")
					{
						$('td', row).eq(10).addClass('warning');
					}
				}
				,"fnDrawCallback": function (oSettings) {
					$("#gridLogsN_wrapper .dataTables_scrollBody").mCustomScrollbar({
						//scrollButtons: { enable: true },
						theme : "dark-thick",
						axis: "xy",
						callbacks:{
							whileScrolling:function(){
								$('#gridLogsN_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
							}
						}
					});
					$("#gridLogsN_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridLogsN tr td:first"));
					//调整div高度
					var wh = $('#divMain').height();
					var arr1 = $('#gridLogsN_wrapper .dataTables_scrollBody').children();
					if (arr1.length){
						var dh = $('#gridLogsN_wrapper .dataTables_scrollHead').height();
						var hh = (wh - dh - 135) + "px";
						var divID = "#" + arr1[0].id;
						$(divID).height(hh);
					}
					var arr2 = $('#divMain').children();
					if (arr2.length){
						var hh = wh + "px";
						var divID = "#" + arr2[0].id;
						$(divID).height(hh);
					}
					//新加
					var api = this.api(); 
					if(api.rows({page:'current'}).data().length==1)
					{
						obj.ClickCnt =obj.ClickCnt+1;
						//一条时候触发选中一条	
						if(obj.ClickCnt==1 && EpisodeID !="")
							$("#gridLogsN a.editor_edit").trigger( 'click');					
					}
		        }
			});
			
			//增加NICU表格导出打印
			new $.fn.dataTable.Buttons( obj.gridLogsN, {
				buttons: [
					{
						extend: 'excel',
						text:'导出',
						title:"NICU调查表"
						,footer: true
						,exportOptions: {
							columns: ':visible'
							,width:50
							,orthogonal: 'export'
						},
						customize: function( xlsx ) {
							var sheet = xlsx.xl.worksheets['sheet1.xml'];
							
						}
					},
					{
						extend: 'print',
						text:'打印'
						,title:""
						,footer: true
						,exportOptions: { orthogonal: 'export' }				
					}
				]
			});
			myLoadHiden();
		}
		else
		{
			//存在情况下
			obj.gridLogsN.ajax.reload(function(){myLoadHiden();});
		}
		//myLoadHiden();
	}
	//刷新picc表格
	function refreshGridPICC()
	{
		var rd = obj.layerRep_rd;
		
		if(obj.gridPICC==undefined)
		{
			obj.gridPICC = $("#gridPICC").DataTable({
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
					{"data": "IRPICCTypeDesc"},
					{"data": "IRPICCCntDesc"},
					{"data": "IRPICCPosDesc"}
					,{"data": "IRIntuDate"}
					,{"data": "IRExtuDate"}
					,{"data": "IROperDocDesc"}
					,{"data": "IROperLocDesc"}
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
					,{"data": "IRInfSymptomsDesc"}
				]
				,"createdRow": function ( row, data, index ) {
					if ( data.IsCheck=="1") {
						$('td', row).parent().addClass('text-success');
					}
				}	
			});
			obj.gridPICC.on('dblclick', 'tr', function(e) {
				var rd = obj.gridPICC.row(this).data();
				obj.layerPICC_rd = rd;
				obj.LayerPICC();
			});			
		}
		else
		{
			//存在情况下
			obj.gridPICC.ajax.reload(function(){});
		}
	}
	//刷新picc表格
	function refreshGridVAP()
	{
		var rd = obj.layerRep_rd;
		if(obj.gridVAP==undefined)
		{
			obj.gridVAP = $("#gridVAP").DataTable({
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
					{"data": "IRVAPTypeDesc"}
					,{"data": "IRIntuDate"}
					,{"data": "IRExtuDate"}
					,{"data": "IROperDocDesc"}
					,{"data": "IROperLocDesc"}
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
				]
				,"createdRow": function ( row, data, index ) {
					if ( data.IsCheck=="1") {
						$('td', row).parent().addClass('text-success');
					}
				}	
			});
			obj.gridVAP.on('dblclick', 'tr', function(e) {
				var rd = obj.gridVAP.row(this).data();
				obj.layerVAP_rd = rd;
				obj.LayerVAP();
			});
		}
		else
		{
			//存在情况下
			obj.gridVAP.ajax.reload(function(){});
		}
	}
	//刷新picc表格
	function refreshGridUC()
	{
		var rd = obj.layerRep_rd;
		if(obj.gridUC==undefined)
		{
			obj.gridUC = $("#gridUC").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
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
					{"data": "IRUCTypeDesc"}
					,{"data": "IRIntuDate"}
					,{"data": "IRExtuDate"}
					,{"data": "IROperDocDesc"}
					,{"data": "IROperLocDesc"}
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
				],"createdRow": function ( row, data, index ) {
					if ( data.IsCheck=="1") {
						$('td', row).parent().addClass('text-success');
					}
				}	
			});
			obj.gridUC.on('dblclick', 'tr', function(e) {
				var rd = obj.gridUC.row(this).data();
				obj.layerUC_rd = rd;
				obj.LayerUC();
			});
		}
		else
		{
			//存在情况下
			obj.gridUC.ajax.reload(function(){});
		}
	}
	//ICU调查报告 保存失败返回 小于等于 0
	obj.RepSave = function (repType,repStatus)
	{
		var rd = obj.layerRep_rd;  //选中的上报病人信息及报告
		// = ##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",IRStatusDr)
		
		//var staID = $.Tool.RunServerMethod("DHCHAI.BT.Dictionary","GetIDByCode","InfReportStatus",repStatus);
		var ID = (rd.RepID ? rd.RepID :obj.ReportID);
	
		var Paadm = rd.Paadm;
		var IRRepType = "3";   //ICU调查表类型
		var IRRepDate = "";
		var IRRepTime = "";  //报告时间
		var IRRepLocDr = $('#ulLoc').val();  //调查科室 ？= 当前科室 rd.LocID
		var IRRepUser = $.LOGON.USERID;   //$.LOGON.USERID
		var IRStatusDr = repStatus; 
		var IRLinkDiags = "";   // 感染诊断
		var IRLinkICDs = "";    //疾病诊断
		var IRLinkLabs = "";    //IRLinkAntis
		var IRLinkAntis = "";
		var IRLinkOPSs = "";  //
		var IRLinkMRBs = "";
		var IRLinkInvOpers = "";  //
		var IRLinkICUUCs = "";  //
		
		var IRLinkICUVAPs ="";  //呼吸机
		
		var IRLinkICUPICCs = "";
		
		var IRDiagnosisBasis =""; //诊断依据
		var IRDiseaseCourse = ""; //
		var IRInLocDr = "";  //入科来源
		var IROutLocDr ="";    //出科方向
		var IRInDate =""; //入科时间
		var IROutDate=""; //出科时间 
		var IRAPACHEScore="";   //APACHEⅡ评分
		var IROutIntubats=""; //出ICU带管情况 List # 分割多个值
		var IROut48Intubats=""; //出ICU48带管情况 list  # 分割多个值
			
		if(repType == "2")
		{
			//新生儿
			obj.gridNUC.data().each( function (d) {
				if(IRLinkICUUCs=="")
				{
					IRLinkICUUCs = d.ID;
				}
				else{
					IRLinkICUUCs=IRLinkICUUCs+","+d.ID;
				}
			});
			obj.gridNVAP.data().each( function (d) {
				if(IRLinkICUVAPs=="")
				{
					IRLinkICUVAPs = d.ID;
				}
				else{
					IRLinkICUVAPs=IRLinkICUVAPs+","+d.ID;
				}
			});
			obj.gridNPICC.data().each( function (d) {
				if(IRLinkICUPICCs=="")
				{
					IRLinkICUPICCs = d.ID;
				}
				else{
					IRLinkICUPICCs=IRLinkICUPICCs+","+d.ID;
				}
			});
			if(true)
			{
				//没有体重=体重必填 and 回写到护理记录 出生体重里  去除
				var patWeight = $.form.GetValue("FormVo.pPatWeight");
				if(patWeight=="")
				{
					layer.alert("出生体重不允许为空",{icon: 0});
					return "-1";
				}
				else{
					//保存体重			
					var rstW = $.Tool.RunServerMethod("DHCHAI.DPS.PAAdmSrv","UpdateWeight",Paadm,patWeight);					
					if(rstW=="1")
					{
						//成功
					}
					else
					{
						//失败
						layer.alert("出生体重保存失败！",{icon: 0});
						//return "-1";  继续后续保存不影响后续代码
					}
				}
			}
		}
		else if(repType == "3"){
			obj.gridUC.data().each( function (d) {
				if(IRLinkICUUCs=="")
				{
					IRLinkICUUCs = d.ID;
				}
				else{
					IRLinkICUUCs=IRLinkICUUCs+","+d.ID;
				}
			});
			obj.gridVAP.data().each( function (d) {
				if(IRLinkICUVAPs=="")
				{
					IRLinkICUVAPs = d.ID;
				}
				else{
					IRLinkICUVAPs=IRLinkICUVAPs+","+d.ID;
				}
			});
			obj.gridPICC.data().each( function (d) {
				if(IRLinkICUPICCs=="")
				{
					IRLinkICUPICCs = d.ID;
				}
				else{
					IRLinkICUPICCs=IRLinkICUPICCs+","+d.ID;
				}
			});
		}
		var InputStr = ID;
		InputStr += "^" + Paadm;
		InputStr += "^" + IRRepType;
		InputStr += "^" + IRRepDate;
		InputStr += "^" + IRRepTime;
		InputStr += "^" + IRRepLocDr;
		InputStr += "^" + IRRepUser;  //
		InputStr += "^" + IRStatusDr;
		InputStr += "^" + IRLinkDiags;
		InputStr += "^" + IRLinkICDs;
		InputStr += "^" + IRLinkLabs;
		InputStr += "^" + IRLinkAntis;
		InputStr += "^" + IRLinkOPSs;
		InputStr += "^" + IRLinkMRBs;
		InputStr += "^" + IRLinkInvOpers;
		InputStr += "^" + IRLinkICUUCs;
		InputStr += "^" + IRLinkICUVAPs;
		InputStr += "^" + IRLinkICUPICCs;
		InputStr += "^" + IRDiagnosisBasis;
		InputStr += "^" + IRDiseaseCourse;
		InputStr += "^" + IRInLocDr;
		InputStr += "^" + IRInDate;
		InputStr += "^" + IROutDate;
		InputStr += "^" + IRAPACHEScore;  
		InputStr += "^" + IROutIntubats; 
		InputStr += "^" + IROut48Intubats; 
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.INFReportSrv","UpdateReport",InputStr);
		obj.ReportID = retval ;
		return retval;
	}
	//感染报告 保存失败返回 小于等于 0
	obj.InfRepSave = function (repType,repStatus)
	{
		var rd = obj.layerRep_rd;  //选中的上报病人信息及报告
		
		var ID = rd.RepID;
		var Paadm = rd.Paadm;
		var IRRepType = "1";   //调查表类型
		var IRRepDate = "";
		var IRRepTime = "";  //报告时间
		var IRRepLocDr = $.LOGON.LOCID;  //调查科室 ？= 当前科室 rd.LocID
		var IRRepUser = $.LOGON.USERID;   //$.LOGON.USERID
		var IRStatusDr = repStatus;
		var IRLinkDiags = "";   // 感染诊断
		var IRLinkICDs = "";    //疾病诊断
		var IRLinkLabs = "";    //IRLinkAntis
		var IRLinkAntis = "";
		var IRLinkOPSs = "";  //
		var IRLinkMRBs = "";
		var IRLinkInvOpers = "";  //
		var IRLinkICUUCs = "";  //
		
		var IRLinkICUVAPs ="";  //呼吸机
		
		var IRLinkICUPICCs = "";
		
		var IRDiagnosisBasis =""; //诊断依据
		var IRDiseaseCourse = ""; //
		var IRInLocDr = "";  //入科来源
		var IROutLocDr ="";    //出科方向
		var IRInDate =""; //入科时间
		var IROutDate=""; //出科时间 
		var IRAPACHEScore="";   //APACHEⅡ评分
		var IROutIntubats=""; //出ICU带管情况 List # 分割多个值
		var IROut48Intubats=""; //出ICU48带管情况 list  # 分割多个值
		
		//保存感染部位信息
		var IRInfPosDr = $.form.GetValue("cbopInfPos");
		var IRInfSubDr = $.form.GetValue("cbopInfPosSub");
		var IRInfDate = $.form.GetValue("FormVopInfDate");
		var IRInfLocDr = $.form.GetValue("cbopInfLoc");
		var IRInfXDate = $.form.GetValue("FormVopIRInfXDate");		
		var IRInfEffectDr = "";
		$("#divpInfEffect input").each( function (){
			if($(this).is(":checked"))
			{
				IRInfEffectDr = $(this).attr("id");
			}
		});
		var InputInfDiag = ID;
		InputInfDiag += "^" + rd.Paadm;
		InputInfDiag += "^" + IRInfPosDr; 
		InputInfDiag += "^" +IRInfSubDr;
		InputInfDiag += "^" +IRInfDate;
		InputInfDiag += "^" +IRInfLocDr;
		InputInfDiag += "^" +IRInfXDate;
		InputInfDiag += "^" +IRInfEffectDr
		InputInfDiag += "^" +"";
		InputInfDiag += "^" +"";
		InputInfDiag += "^" +$.LOGON.USERID
		var retinfID = $.Tool.RunServerMethod("DHCHAI.IR.INFDiagnos","Update",InputInfDiag);
		//感染信息和报告关联
		IRLinkDiags = retinfID;
		
		var InputStr = ID;
		InputStr += "^" + Paadm;
		InputStr += "^" + IRRepType;
		InputStr += "^" + IRRepDate;
		InputStr += "^" + IRRepTime;
		InputStr += "^" + IRRepLocDr;
		InputStr += "^" + IRRepUser;  //
		InputStr += "^" + IRStatusDr;
		InputStr += "^" + IRLinkDiags;
		InputStr += "^" + IRLinkICDs;
		InputStr += "^" + IRLinkLabs;
		InputStr += "^" + IRLinkAntis;
		InputStr += "^" + IRLinkOPSs;
		InputStr += "^" + IRLinkMRBs;
		InputStr += "^" + IRLinkInvOpers;
		InputStr += "^" + IRLinkICUUCs;
		InputStr += "^" + IRLinkICUVAPs;
		InputStr += "^" + IRLinkICUPICCs;
		InputStr += "^" + IRDiagnosisBasis;
		InputStr += "^" + IRDiseaseCourse;
		InputStr += "^" + IRInLocDr;
		InputStr += "^" + IRInDate;
		InputStr += "^" + IROutDate;
		InputStr += "^" + IRAPACHEScore;  
		InputStr += "^" + IROutIntubats; 
		InputStr += "^" + IROut48Intubats; 
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.INFReportSrv","UpdateReport",InputStr);
		return retval;
	};
	function myLoading() {
		if ($(".Loading_animate_content").length != 0) {
			if ($(".Loading_animate_bg").length == 0) {
				var html = '<div class="Loading_animate_bg">'
				    +'<div class="loading">'
					+	'<img src="../scripts/dhchai/img/loading.gif"/>'
				    +'</div>'
				    +'</div>'
					+ '<div class="Loading_animate_font">加载中...</div>';
				$(".Loading_animate_content").append(html);
			}
		}
	}
	function myLoadingBug() {		
		$('.Loading_animate_bg').css({ height: $(document).height() });
		$('.Loading_animate_font').css({ left: ($(document).width() - 36) / 2 });
	}
	function myLoadHiden()
	{
		if ($(".Loading_animate_content").length != 0) {
				$(".Loading_animate_content").css("display", "none");
				$(".Loading_animate_font").text("加载中...");
		}
	}
}