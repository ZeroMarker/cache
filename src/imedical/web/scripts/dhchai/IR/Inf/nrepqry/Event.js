function InitNRepQryWinEvent(obj){
	CheckSpecificKey();
	// 初始化权限
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	//赋值初始值
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //渲染下拉框	
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboLocation");  //渲染下拉框	
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboLocation").data("param",id+"^^I^E^1");
		$.form.SelectRender("cboLocation");  //渲染下拉框	
	});	
	$.form.SelectRender("#cboStatus");
	$.form.iCheckRender();  //渲染复选框|单选钮
	
	/*****搜索功能*****/
	$("#btnsearch").on('click', function(){
	   $('#gridReport').DataTable().search($('#search').val(),true,true).draw();
	   
	});

	$("#search").keyup(function(event){
	    if (event.keyCode == 13) {
	        obj.gridReport.search(this.value).draw();
	    }
	});
	refreshGridReport();
	/****************/
    //查询按钮
    $("#btnQuery").on('click', function(){
		refreshGridReport();
	});
    $("#txtMrNO").keyup(function(event){
	    if (event.keyCode == 13) {
	        $("#btnQuery").click();
	    }
	});
     //导出
    $("#btnExport").on('click', function(){
		obj.gridReport.buttons(0,null)[0].node.click();
	});

	$('#gridReport').on('dblclick', 'tr', function(e) {
		var rd = obj.gridReport.row(this).data();
		var ReportID = rd["ReportID"];
		if (!ReportID) return;
		obj.winOpenInfReport(ReportID);
	});
	
    //链接选中方式
    $('#gridReport').on('click','a.editor_report', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridReport.row(tr);
		var rowData = row.data();
		var ReportID = rowData.ReportID;
		obj.winOpenInfReport(ReportID);
    });
	
	function refreshGridReport()
	{
		if(obj.gridReport==null)
		{
			//新生儿感染报告列表
			obj.gridReport = $("#gridReport").DataTable({
				dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
				paging: true,
				ordering: true,
				info: true,
				"processing" : true,
				"scrollX": true,
				"scrollY":true, //此处可以设定最大高度值
				//"scrollY":"410px",
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFDiagnosSrv";
						d.QueryName = "QryRepInfoByDateLoc";
						d.Arg1 =$.form.GetValue("cboDateType");
						d.Arg2 =$("#DateFrom").val();
						d.Arg3 =$("#DateTo").val();
						d.Arg4 =$.form.GetValue("cboLocation");
						d.Arg5 =$.form.GetValue("cboStatus");
						d.Arg6 ="2"; //院感报告
						d.Arg7 ="";  //登记号
						d.Arg8 =$.form.GetValue("txtMrNO");  //病案号
						d.Arg9 =$.form.GetValue("txtPatName");  //
						d.Arg10 =$.form.GetValue("cboHospital"); //医院
						d.ArgCnt = 10;
					}
				},
				"columns": [
					{
						"data": "PatMrNo"
						,render: function (data, type, row) {
							return type === 'export' ?
								String.fromCharCode(2)+data:data;
						}
					},
					{"data": "PatName"},
					{"data": "PatSex"},
					{"data": "PatAge"},
					{
						"data": null,
						render: function ( data, type, row ) {
							var editHtml = '<a href="#" class="editor_report">'+data.ReportStatusDesc+'</a>';
							return editHtml;
						}
					},
					{"data": "ReportLocDesc"},
					{"data": "IRInfDate"},
					{"data": "InfDiag"},
					{"data": "AdmitDate"},
					{"data": "DischDate"}
				
				],"fnDrawCallback": function (oSettings) {
					$("#gridReport_wrapper .dataTables_scrollBody").mCustomScrollbar({
						theme : "dark-thick",
						axis: "xy",
						callbacks:{
							whileScrolling:function(){
								$('#gridReport_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
							}
						}
					});			
					$("#gridReport_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridReport tr td:first"));
					getContentSize();
		        }
					
			});
			
			new $.fn.dataTable.Buttons(obj.gridReport, {
				buttons: [					
					{
						extend: 'excel',
						text:'导出',
						title:"新生儿感染报告查询"
						,footer: true
						,exportOptions: {
							columns: ':visible'
							,width:50
							,orthogonal: 'export'
						},
						customize: function( xlsx ) {
							var sheet = xlsx.xl.worksheets['sheet.xml'];
							
						}
					}
				]
			});
		} else {
			obj.gridReport.ajax.reload( function ( json ) {
				setTimeout(function(){
				  	layer.closeAll('loading');
				}, 100);
			    if (json.data.length==0){
					layer.msg('没有找到相关数据！',{time: 2000,icon: 2});
					return;
				}
			});
		}
		
	}
	
	obj.winOpenInfReport = function(aReportID)
	{
		if (!aReportID) return;
		/*
		var url="dhchai.ir.inf.nreport.csp?1=1&ReportID="+aReportID+'&AdminPower='+ obj.AdminPower+"&2=2";
		layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:'新生儿医院感染报告',
			  fixed: false, //不固定
			  content: [url,'no'],
			  success: function(layero, index){
				$("div.layui-layer-content").css("padding-right","2px");
			  },
			 end: function () {
              	//refreshGridReport();  //导致翻页变化
              	obj.gridReport.ajax.reload(null,false);
              }
		});
		*/
		var strUrl="dhcma.hai.ir.inf.nreport.csp?1=1&ReportID="+aReportID+'&AdminPower='+ obj.AdminPower+"&2=2";
		websys_showModal({
			url:strUrl,
			title:'新生儿医院感染报告',
			iconCls:'icon-w-epr',  
			originWindow:window,
			//closable:false,
			width:1320,
			height:'95%',
			onBeforeClose:function(){
				obj.gridReport.ajax.reload(null,false);
			} 
		});
	}
}
 
function getContentSize() {
    var wh = document.documentElement.clientHeight; 
    var eh = 166;
    var ch = (wh - eh) + "px";
    obj = document.getElementById("mCSB_5");
    var dh=$('div.dataTables_scrollHead').height();
    var sh=(wh - eh + dh )+ "px"; 
    if (obj){  
   		obj.style.height = ch;
    }else {
	   $('div.dataTables_scrollBody').css('height',sh);
    }
}
