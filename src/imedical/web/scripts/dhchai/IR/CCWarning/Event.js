//页面Event
function InitCCScreeningWinEvent(obj){
	CheckSpecificKey();
	//$.form.CheckBoxRender("#cjb");	
	//初始化字典数据
	$("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //渲染下拉框
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		obj.qryWarning();
	});
	
	obj.qryDate = $.form.DateTimeRender("qryDate",$.form.DateArr($.form.GetCurrDate("-"),2)[0]);
	//obj.qryDate = $.form.DateTimeRender("qryDate",$.form.GetCurrDate("-"));
	obj.qryDate.on('changeDate',function(ev){
		obj.qryWarning();
	});
	
	obj.qryWarning = function(){
		obj.selLocID="";
		var HospIDs = $("#cboHospital").val();
		if (HospIDs == ''){
			layer.alert('暴发预警院区不允许为空！');
			return;
		}
		var qryDate=$("#qryDate").val();
		var qryDate1 = new Date(qryDate.replace(/\-/g, "\/"));
		if(qryDate1 == ''){
			layer.alert('暴发预警日期不允许为空！');
			return;
		}
		var today =$.form.GetCurrDate("-");
		var flg=$.form.CompareDate(today,qryDate);
		if(flg == 0){
			layer.tips('查询日期大于当前日期,按当前日期查询！', '#qryDate', {tips: [1,'#3595CC'],time: 3000});
			obj.qryDate = $.form.DateTimeRender("qryDate",$.form.GetCurrDate("-"));
		}
		myLoading();
		if ($(".Loading_animate_content").length != 0) {
			myLoadingBug();
			$(".Loading_animate_content").css("display","block");
		}		
		setTimeout(refreshgridBfyj,0.3*1000);  //错开达到异步
		//obj.refreshgridBfyj();
		obj.reportChart();
	}
	//过滤非数字
	function filterNum(obj){
		obj.value = obj.value.replace(/[^\d]/g, '');
	}
	//初始化参数值
	obj.initParam = function(){
		
		// 监控项目字段说明
		// retval[0]=obj.CCDesc      // 项目名称
		// retval[1]=obj.CCDesc2     // 项目名称2
		// retval[2]=obj.CCKeyWords  // 关键词(多值“,”分割)
		// retval[3]=obj.CCIndNo     // 排序码
		// retval[4]=obj.CCArg1      // 参数1
		// retval[5]=obj.CCArg2      // 参数2
		// retval[6]=obj.CCArg3      // 参数3
		// retval[7]=obj.CCArg4      // 参数4
		// retval[8]=obj.CCArg5      // 参数5
		// retval[9]=obj.CCIsActive // 是否有效
		
		//实时现患
		var IsHideFlag = 0;
		var retStr = $.Tool.RunServerMethod("DHCHAI.IRS.CCItmWarnSrv","GetStrByDesc","实时现患");
		if (retStr != ''){
			var retval = retStr.split('^');
			if (retval[9]=="1") {
				$("#WarnItem_InfCnt").val(retval[5]);
				$("#WarnItem_InfName").html(retval[0]);
				IsHideFlag = 1;
				$("#WarnItem_InfCnt").keyup(function(){filterNum(this); });
			}
		}
		if (IsHideFlag == 0) $("#WarnItem_Inf").hide();
		
		//发热标准差
		var IsHideFlag = 0;
		var retStr = $.Tool.RunServerMethod("DHCHAI.IRS.CCItmWarnSrv","GetStrByDesc","发热标准差");
		if (retStr != ''){
			var retval = retStr.split('^');
			if (retval[9]=="1") {
				$("#WarnItem_FerverDay2").val(retval[4]);
				$("#WarnItem_FerverCnt2").val(retval[5]);
				$("#WarnItem_FerverName2").html(retval[0]);
				IsHideFlag = 1;
				$("#WarnItem_FerverDay2").keyup(function(){filterNum(this); });
				$("#WarnItem_FerverCnt2").keyup(function(){filterNum(this); });
			}
		}
		if (IsHideFlag == 0) $("#WarnItem_Ferver2").hide();
		
		//发热人数
		var IsHideFlag = 0;
		var retStr = $.Tool.RunServerMethod("DHCHAI.IRS.CCItmWarnSrv","GetStrByDesc","发热人数");
		if (retStr != ''){
			var retval = retStr.split('^');
			if (retval[9]=="1") {
				$("#WarnItem_FerverDay").val(retval[4]);
				$("#WarnItem_FerverCnt").val(retval[5]);
				$("#WarnItem_FerverName").html(retval[0]);
				IsHideFlag = 1;
				$("#WarnItem_FerverDay").keyup(function(){filterNum(this); });
				$("#WarnItem_FerverCnt").keyup(function(){filterNum(this); });
			}
		}
		if (IsHideFlag == 0) $("#WarnItem_Ferver").hide();
		
		//检出同种同源菌
		var IsHideFlag = 0;
		var retStr = $.Tool.RunServerMethod("DHCHAI.IRS.CCItmWarnSrv","GetStrByDesc","检出同种同源菌");
		if (retStr != ''){
			var retval = retStr.split('^');
			if (retval[9]=="1") {
				$("#WarnItem_BactDay").val(retval[4]);
				$("#WarnItem_BactCnt").val(retval[5]);
				$("#WarnItem_BactName").html(retval[0]);
				IsHideFlag = 1;
				$("#WarnItem_BactDay").keyup(function(){filterNum(this); });
				$("#WarnItem_BactCnt").keyup(function(){filterNum(this); });
			}
		}
		if (IsHideFlag == 0) $("#WarnItem_Bact").hide();
		
		//便常规异常
		var IsHideFlag = 0;
		var retStr = $.Tool.RunServerMethod("DHCHAI.IRS.CCItmWarnSrv","GetStrByDesc","便常规异常");
		if (retStr != ''){
			var retval = retStr.split('^');
			if (retval[9]=="1") {
				$("#WarnItem_STRDay").val(retval[4]);
				$("#WarnItem_STRCnt").val(retval[5]);
				$("#WarnItem_STRName").html(retval[0]);
				IsHideFlag = 1;
				$("#WarnItem_STRDay").keyup(function(){filterNum(this); });
				$("#WarnItem_STRCnt").keyup(function(){filterNum(this); });
			}
		}
		if (IsHideFlag == 0) $("#WarnItem_STR").hide();
		
		//呼吸机使用
		var IsHideFlag = 0;
		var retStr = $.Tool.RunServerMethod("DHCHAI.IRS.CCItmWarnSrv","GetStrByDesc","呼吸机使用");
		if (retStr != ''){
			var retval = retStr.split('^');
			if (retval[9]=="1") {
				$("#WarnItem_VAPDay").val(retval[4]);
				$("#WarnItem_VAPCnt").val(retval[5]);
				$("#WarnItem_VAPName").html(retval[0]);
				IsHideFlag = 1;
				$("#WarnItem_VAPDay").keyup(function(){filterNum(this); });
				$("#WarnItem_VAPCnt").keyup(function(){filterNum(this); });
			}
		}
		if (IsHideFlag == 0) $("#WarnItem_VAP").hide();
		
		//中心静脉置管
		var IsHideFlag = 0;
		var retStr = $.Tool.RunServerMethod("DHCHAI.IRS.CCItmWarnSrv","GetStrByDesc","中心静脉置管");
		if (retStr != ''){
			var retval = retStr.split('^');
			if (retval[9]=="1") {
				$("#WarnItem_PICCDay").val(retval[4]);
				$("#WarnItem_PICCCnt").val(retval[5]);
				$("#WarnItem_PICCName").html(retval[0]);
				IsHideFlag = 1;
				$("#WarnItem_PICCDay").keyup(function(){filterNum(this); });
				$("#WarnItem_PICCCnt").keyup(function(){filterNum(this); });
			}
		}
		if (IsHideFlag == 0) $("#WarnItem_PICC").hide();
		
		//泌尿道插管
		var IsHideFlag = 0;
		var retStr = $.Tool.RunServerMethod("DHCHAI.IRS.CCItmWarnSrv","GetStrByDesc","泌尿道插管");
		if (retStr != ''){
			var retval = retStr.split('^');
			if (retval[9]=="1") {
				$("#WarnItem_UCDay").val(retval[4]);
				$("#WarnItem_UCCnt").val(retval[5]);
				$("#WarnItem_UCName").html(retval[0]);
				IsHideFlag = 1;
				$("#WarnItem_UCDay").keyup(function(){filterNum(this); });
				$("#WarnItem_UCCnt").keyup(function(){filterNum(this); });
			}
		}
		if (IsHideFlag == 0) $("#WarnItem_UC").hide();
		// 上呼吸道感染
		var IsHideFlag = 0;
		var retStr = $.Tool.RunServerMethod("DHCHAI.IRS.CCItmWarnSrv","GetStrByDesc","上呼吸道感染");
		if (retStr != ''){
			var retval = retStr.split('^');
			if (retval[9]=="1") {
				$("#WarnItem_URTIDay").val(retval[4]);
				$("#WarnItem_URTICnt").val(retval[5]);
				$("#WarnItem_URTIName").html(retval[0]);
				IsHideFlag = 1;
				$("#WarnItem_URTIDay").keyup(function(){filterNum(this); });
				$("#WarnItem_URTICnt").keyup(function(){filterNum(this); });
			}
		}
		if (IsHideFlag == 0) $("#WarnItem_URTI").hide();
		// 下呼吸道感染
		var IsHideFlag = 0;
		var retStr = $.Tool.RunServerMethod("DHCHAI.IRS.CCItmWarnSrv","GetStrByDesc","下呼吸道感染");
		if (retStr != ''){
			var retval = retStr.split('^');
			if (retval[9]=="1") {
				$("#WarnItem_DRTIDay").val(retval[4]);
				$("#WarnItem_DRTICnt").val(retval[5]);
				$("#WarnItem_DRTIName").html(retval[0]);
				IsHideFlag = 1;
				$("#WarnItem_DRTIDay").keyup(function(){filterNum(this); });
				$("#WarnItem_DRTICnt").keyup(function(){filterNum(this); });
			}
		}
		if (IsHideFlag == 0) $("#WarnItem_DRTI").hide();
		// 泌尿道感染
		var IsHideFlag = 0;
		var retStr = $.Tool.RunServerMethod("DHCHAI.IRS.CCItmWarnSrv","GetStrByDesc","泌尿道感染");
		if (retStr != ''){
			var retval = retStr.split('^');
			if (retval[9]=="1") {
				$("#WarnItem_UTIDay").val(retval[4]);
				$("#WarnItem_UTICnt").val(retval[5]);
				$("#WarnItem_UTIName").html(retval[0]);
				IsHideFlag = 1;
				$("#WarnItem_UTIDay").keyup(function(){filterNum(this); });
				$("#WarnItem_UTICnt").keyup(function(){filterNum(this); });
			}
		}
		if (IsHideFlag == 0) $("#WarnItem_UTI").hide();
		// 血管相关性感染
		var IsHideFlag = 0;
		var retStr = $.Tool.RunServerMethod("DHCHAI.IRS.CCItmWarnSrv","GetStrByDesc","血管相关性感染");
		if (retStr != ''){
			var retval = retStr.split('^');
			if (retval[9]=="1") {
				$("#WarnItem_VRTIDay").val(retval[4]);
				$("#WarnItem_VRTICnt").val(retval[5]);
				$("#WarnItem_VRTIName").html(retval[0]);
				IsHideFlag = 1;
				$("#WarnItem_VRTIDay").keyup(function(){filterNum(this); });
				$("#WarnItem_VRTICnt").keyup(function(){filterNum(this); });
			}
		}
		if (IsHideFlag == 0) $("#WarnItem_VRTI").hide();
		// 手术切口感染
		var IsHideFlag = 0;
		var retStr = $.Tool.RunServerMethod("DHCHAI.IRS.CCItmWarnSrv","GetStrByDesc","手术切口感染");
		if (retStr != ''){
			var retval = retStr.split('^');
			if (retval[9]=="1") {
				$("#WarnItem_SIIDay").val(retval[4]);
				$("#WarnItem_SIICnt").val(retval[5]);
				$("#WarnItem_SIIName").html(retval[0]);
				IsHideFlag = 1;
				$("#WarnItem_SIIDay").keyup(function(){filterNum(this); });
				$("#WarnItem_SIICnt").keyup(function(){filterNum(this); });
			}
		}
		if (IsHideFlag == 0) $("#WarnItem_SII").hide();
		//入院24H内计入统计
		$.form.iCheckRender();
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.Config","GetValByCode","CCWarningFlag");
		if (retval=="1") {
			$("#WarnItem_24Hour").iCheck("check");
		} else {
			$("#WarnItem_24Hour").iCheck("uncheck");
		}
	};
	
	//显示报表图
	obj.reportChart = function(){
		//报表		
    	obj.myChart = echarts.init(document.getElementById('main'));
        obj.myChart.resize();
        // 指定图表的配置项和数据 $.form.GetCurrDate("-")
        var option = {
			title: {
				text: '人数',
				show: true,
				x: 'center',
				textStyle: {
					fontSize: 14,
					fontWeight: 'bold',
				},
			},
			tooltip: {
				trigger: 'axis'
			},
			legend: {
				data:['发热']
			},
			toolbox: {
				show: true,
				padding: 5,
				feature: {
					dataZoom: {
						yAxisIndex: 'none'
					},
					dataView: {show: false,readOnly: false},
					magicType: {type: ['line', 'bar']},
					saveAsImage: {},
					restore: {}
				}
			},
			xAxis:  {
				type: 'category',
				boundaryGap: false,
				data: $.form.DateArr($.form.GetValue("qryDate"),7)
			},
			yAxis: {
				type: 'value',
				axisLabel: {
					formatter: '{value}'
				}
			},
			series: [
				{
					name:'发热人数',
					type:'line',
					data:[],  //11, 11, 15, 13, 12, 13, 10
					markPoint: {
						data: [
							{type: 'max', name: '最大值'},
							{type: 'min', name: '最小值'}
						]
					},
					markLine: {
						data: [
							{type: 'average', name: '平均值'}
						]
					}
				}
			]
		};
		
        // 使用刚指定的配置项和数据显示图表。
        obj.myChart.setOption(option);
		obj.myChart.on('click', function (params) {
			// 控制台打印数据的名称
			//alert(params.name);
		});
	};
	
	//查询按钮
	$("#btnQryWarn").click(function (e) {
		obj.qryWarning();
	});
	
	//导出
	$("#btnExport").click(function(e){
		if(obj.gridBfyj)
		{
			//导出
			obj.gridBfyj.buttons(0,null)[0].node.click();
		}
	});
	
	//刷新患者列表
	function refreshGridLocPatients(){
		
		if (obj.gridLocPatients==undefined){
			obj.gridLocPatients = $("#gridLocPatients").DataTable({
				dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
				select:true,
				paging:true,
				ordering: false,
				processing: true,
				info: true,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.CCWarningSrv";
						d.QueryName = "QryWarnPatList";
						d.Arg1=obj.selLocID;
						d.Arg2=obj.qryWarnDate;
						d.Arg3=obj.qryWarnItems;
						d.Arg4=obj.selItems;
						d.ArgCnt = 4;
					}
				},
				columns: [
					{"data": "RegNo"},
					{"data": "PatName"},
					{"data": "MrNo"},
					{"data": "Sex"},
					{"data": "Age"},
					{"data": "WarnLocDesc"},
					{"data": "WarnBedDesc"},
					{"data": null,
						render: function ( data, type, row ) {
							var EpisodeDr=row['EpisodeDr'];
							return '<a href="#" onclick="objScreen.OperZYWinByEpis(\'' + EpisodeDr + '\')">摘要</a>';
						}
					},
					{"data": "InfInfo"},
					{"data": "AdmDate"},
					{"data": "AdmLoc"},
					{"data": "AdmWard"},
					{"data": "AdmBed"},
					{"data": "DischDate"}
				]
			});
		} else {
			obj.gridLocPatients.clear().draw();
			obj.gridLocPatients.ajax.reload();
			
		}
	};
	
	obj.OperZYWinByEpis = function(aEpisodeDr){
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID=' + aEpisodeDr + '&1=1';
		showFullScreenDiag(url,"");

		/*
		parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:0,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});
		*/
	}
	
	//动态表格创建
	refreshgridBfyj = function(){
		//刷新前清空
		if(obj.gridBfyj!=undefined){
			obj.gridBfyj.clear().draw();
			obj.gridBfyj.destroy();
		}
		var HospIDs = $.form.GetValue("cboHospital");  //  $.LOGON.HOSPID
		//alert(HospIDs);
		var WarnDate=$.form.GetValue("qryDate");
		var WarnItems = $("#WarnItem_InfName").html() + "|" + "" + "|" + $.form.GetValue("WarnItem_InfCnt");
		WarnItems += "^" + $("#WarnItem_FerverName2").html() + "|" + $.form.GetValue("WarnItem_FerverDay2") + "|" + $.form.GetValue("WarnItem_FerverCnt2");  //发热标准差
		WarnItems += "^" + $("#WarnItem_FerverName").html() + "|" + $.form.GetValue("WarnItem_FerverDay") + "|" + $.form.GetValue("WarnItem_FerverCnt");     //发热人数
		WarnItems += "^" + $("#WarnItem_BactName").html() + "|"  + $.form.GetValue("WarnItem_BactDay") + "|" + $.form.GetValue("WarnItem_BactCnt");
		WarnItems += "^" + $("#WarnItem_STRName").html() + "|"  + $.form.GetValue("WarnItem_STRDay") + "|" + $.form.GetValue("WarnItem_STRCnt");
		WarnItems += "^" + $("#WarnItem_VAPName").html() + "|"  + $.form.GetValue("WarnItem_VAPDay") + "|" + $.form.GetValue("WarnItem_VAPCnt");
		WarnItems += "^" + $("#WarnItem_PICCName").html() + "|"  + $.form.GetValue("WarnItem_PICCDay") + "|" + $.form.GetValue("WarnItem_PICCCnt");
		WarnItems += "^" + $("#WarnItem_UCName").html() + "|"  + $.form.GetValue("WarnItem_UCDay") + "|" + $.form.GetValue("WarnItem_UCCnt");
		WarnItems += "^" + $("#WarnItem_URTIName").html() + "|"  + $.form.GetValue("WarnItem_URTIDay") + "|" + $.form.GetValue("WarnItem_URTICnt");
		WarnItems += "^" + $("#WarnItem_DRTIName").html() + "|"  + $.form.GetValue("WarnItem_DRTIDay") + "|" + $.form.GetValue("WarnItem_DRTICnt");
		WarnItems += "^" + $("#WarnItem_UTIName").html() + "|"  + $.form.GetValue("WarnItem_UTIDay") + "|" + $.form.GetValue("WarnItem_UTICnt");
		WarnItems += "^" + $("#WarnItem_VRTIName").html() + "|"  + $.form.GetValue("WarnItem_VRTIDay") + "|" + $.form.GetValue("WarnItem_VRTICnt");
		WarnItems += "^" + $("#WarnItem_SIIName").html() + "|"  + $.form.GetValue("WarnItem_SIIDay") + "|" + $.form.GetValue("WarnItem_SIICnt");
		WarnItems += "^入院24H内计入|" + $.form.GetValue("WarnItem_24Hour");
		obj.WarnItemsArray = new Array();
		obj.qryWarnDate = WarnDate;
		obj.qryWarnItems = WarnItems;
		var runQuery = $.Tool.RunQuery('DHCHAI.IRS.CCWarningSrv','QryWarnResult',HospIDs,WarnDate,WarnItems);
		if(runQuery){
			if(runQuery.total>0){
				//输出列
				var objH=runQuery.record[0];//表格头  --header
				var titleStr = "科室ID"+"^科室^"+objH.DataStr
				var columnList = [];      //显示列对应的json字段
				colArr = titleStr.split("^");
				obj.gridTitle = colArr;
				for (var i = 0; i < colArr.length; i++){
					var objC = {};
					objC["title"] = colArr[i];
					
					if (colArr[i]=="科室ID"){
						objC["visible"]=false;
					}
					if (colArr[i]=="科室"){
						objC["width"]='150px';
						objC["render"]= function ( data, type, row ) {
							return '<a href="#" class="editor_edit">'+data+'</a>';
						};
					} else {
						objC["width"]='30px';
					}
					if(i>1) {
						obj.WarnItemsArray.push(colArr[i]);
						objC["render"]= function ( data, type, row ) {
							return '<a href="#" class="editor_edit">'+data+'</a>';
						};
					}
					columnList.push(objC);
				}
				
				//预警值
				var dataSet =[];
				for (var j=1; j< runQuery.record.length; j++){
					 var objD=runQuery.record[j];
					 var objSet=[];
					 objSet[objSet.length]=objD.LocID;
					 objSet[objSet.length]=objD.LocDesc;
					 var cobjSet = objSet.concat(objD.DataStr.split("^"));
					 dataSet.push(cobjSet);
				}
				
				//科室暴发预警DataTable
				var settings = {
					select: true,
					data: dataSet,
					retrieve: true,
					columns: columnList
					,columnDefs: [
						{"className": "dt-center", "targets": "_all"}
					]
					,dom:"rt"
					,order:([ 2, 'desc'])
					//,ordering:false
					,paging:false
					//,scrollY: "200px"
					,scrollY: true
					,scrollCollapse: true
					,autoWidth: false
					,select: {
						style: 'os',
						items: 'cell'
				    }
					,"fnDrawCallback": function (oSettings) {
						$("#gridBfyj_wrapper .dataTables_scrollBody").mCustomScrollbar({
							//scrollButtons: { enable: true },
							theme: "dark-thick",
							axis: "y",
							scrollInertia: 100
						});
						getContentSize();
					},"createdRow": function ( row, data, index ) {
						var Len = data.length;
						for (var i=2; i <= Len ;i++ ) {
							if ( data[i] > 3) {
								$('td', row).eq(i-1).addClass('danger');
							}
						}
					}
				};
				obj.gridBfyj = $("#gridBfyj").DataTable(settings);
				
				//增加导出功能
				new $.fn.dataTable.Buttons( obj.gridBfyj, {
					buttons: [
						{
							extend: 'excel',
							text:'导出',
							title:"暴发预警监测"
							,exportOptions: {
								columns: ':visible'
								,width:50
								,orthogonal: 'export'
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
				obj.gridBfyj.on( 'user-select', function ( e, dt, type, cell, originalEvent ) {
					//debugger
					//获得选中行
					var tr = $(originalEvent.target).closest('tr');
					var row = obj.gridBfyj.row( tr );
					var rowData = row.data();
					var idx =$(originalEvent.target).index();
					obj.selLocID = rowData[0];
					obj.selItems=obj.gridTitle[idx+1];
					if ( idx === 0 ) {
						//科室列取消选中
						e.preventDefault();
					}
					else{
						//alert("科室ID:"+obj.selLocID+","+obj.qryWarnDate+","+obj.selItems);
						refreshChart();
					}
				});
				
			}
		}
		obj.selItems = "发热人数";  //图表默认指标
		obj.aflag =$.form.GetValue("WarnItem_24Hour");
		refreshChart();
		myLoadHiden();
		$("#gridBfyj").dataTable().fnAdjustColumnSizing();
	};
	refreshChart = function ()
	{
		if (obj.selLocID == null) return;
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCWarningSrv","GetCurrItemIndex",obj.selLocID,obj.qryWarnDate,"",obj.selItems,obj.aflag);
		var dataY = [];						
		if(retval!="")
		{
			dataY =retval.split("^");
		}
		var option = {
			title: {
				text: obj.selItems,
				subtext: ''
			},
			series: [
				{
					name:"人数",
					type:'line',
					data:dataY,  //11, 11, 15, 13, 12, 13, 10
					markPoint: {
						data: [
							{type: 'max', name: '最大值'},
							{type: 'min', name: '最小值'}
						]
					},
					markLine: {
						data: [
							{type: 'average', name: '平均值'}
						]
					}
				}
			]
		};
		obj.myChart.setOption(option);
	};
	$('#gridBfyj').on('click', 'a.editor_edit', function (e) {
		e.preventDefault();
		//同时会触发选中单元格					
		var idx = obj.gridBfyj.cell($(this).closest("td")).index();  //columnVisible row		
		
		var tr = $(this).closest('tr');
		var row = obj.gridBfyj.row(tr);
		var rowData = row.data();
		obj.selLocID = rowData[0];
		obj.selItems=obj.gridTitle[idx.column];
		// 点击科室展现床位图信息
		if (obj.selItems=="科室") {
			InitBedChart(obj,obj.selLocID,obj.qryWarnDate,obj.qryWarnItems,obj.WarnItemsArray,"1");
			return;
		}
		
		refreshGridLocPatients();
		var QueryDate = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateHtmlToLogical",$("#qryDate").val());
		var QryDate = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateLogicalToHtml",QueryDate);
		obj.layerIdxPat = layer.open({
			type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
			zIndex: 101,
			area: ['100%','100%'],
			maxmin: false,
			title: "预警患者情况("+rowData[1]+" "+QryDate+")", 
			content: $('#LayerPatInfo'),
			success: function(layero){
				//展示回调
				
			}
		});
		//alert("科室ID:"+rowData[0]+"项目:"+obj.gridTitle[idx.column]);
	});
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
		$('.Loading_animate').css({ left: ($(document).width()) / 2 });
	}
	function myLoadHiden()
	{
		if ($(".Loading_animate_content").length != 0) {
				$(".Loading_animate_content").css("display", "none");
				$(".Loading_animate_font").text("加载中...");
		}
	}
	obj.initParam();
	obj.qryWarning();
}

function getContentSize() {
    var wh = document.documentElement.clientHeight; 
    var eh = 300;
    var ch = (wh - eh) + "px"; 
    obj = document.getElementById("tab-content");
    var dh=$('div.dataTables_scrollHead').height();
    var sh=(wh - eh - dh)+ "px"; 
    if (dh){  
    	$('div.dataTables_scrollBody').css('height',sh);
    }else {
	    obj.style.height = ch;
    }
}
/*
//Chrome在窗口改变大小时会执行两次       
var isResizing = false;
window.onresize =function(){
  if (!isResizing) {
    setTimeout(function () {
	  getContentSize();   
      isResizing = false;
    }, 100);
  }
  isResizing = true;
}
window.onload = function(){
	 setTimeout(function () {
      getContentSize();
    }, 100);
}
*/
