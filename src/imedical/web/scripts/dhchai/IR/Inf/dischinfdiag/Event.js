function InitDischDiagWinEvent(obj){
	CheckSpecificKey();

	//赋值初始值
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //渲染下拉框	
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	// 给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		// 获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboLocation").data("param",id+"^^I^E^1");
		$.form.SelectRender("cboLocation");  //渲染下拉框	
		$("#cboInfLocation").data("param",id+"^^I^E^1");
		$.form.SelectRender("cboInfLocation");  //渲染下拉框	
	});	
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboLocation");  //渲染下拉框
	$("#cboInfLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboInfLocation");
	$.form.SelectRender("#cboStatus");
	
	/*****搜索功能*****/
	$("#btnsearch").on('click', function(){
	   $('#gridDischDiag').DataTable().search($('#search').val(),true,true).draw();
	   
	});

	$("#search").keyup(function(event){
	    if (event.keyCode == 13) {
	        obj.gridDischDiag.search(this.value).draw();
	    }
	});
	refreshgridDischDiag();
	/****************/
    //查询按钮
    $("#btnQuery").on('click', function(){
		var DateFrom = $.form.GetValue("DateFrom");
		var DateTo   = $.form.GetValue("DateTo");
		if ((DateFrom == '')||(DateTo=='')) {
			layer.alert('出院日期不允许为空!',{icon: 0});
			return ;
		}
		//add
		if(DateFrom>DateTo){
			layer.alert('开始日期不允许大于结束日期!',{icon: 0});
			return ;	
		}
		//end
	   if(obj.gridDischDiag){                                      //清空，在refreshgridDischDiag()初始化表格，防止内容过长把表格撑开又缩不回去
		    $("#gridDischDiag_wrapper .dataTables_scrollBody").mCustomScrollbar("destroy");
		    $("#gridDischDiag").dataTable().fnDestroy();
		    obj.gridDischDiag=null;
		    refreshgridDischDiag();
	    }else{
			refreshgridDischDiag();
	    }
	});
    $("#txtMrNo").keyup(function(event){
	    if (event.keyCode == 13) {
	        $("#btnQuery").click();
	    }
	});
     //导出
    $("#btnExport").on('click', function(){
		obj.gridDischDiag.buttons(0,null)[0].node.click();
	});
	
	$('#gridDischDiag').on('dblclick', 'tr', function(e) {
		return ;
	});
	
	function refreshgridDischDiag()
	{
		if(obj.gridDischDiag==null)
		{
			//出院感染诊断列表
			obj.gridDischDiag = $("#gridDischDiag").DataTable({
				dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
				paging: true,
				ordering: true,
				info: true,
				"bAutoWidth": false,	//add
				"iDisplayLength" : 50,
				"autoWidth": false,
				"processing" : true,
				"scrollX": true,
				"scrollY":($(window).height()-165)+"px",//true, //此处可以设定最大高度值
				//"scrollY":"410px",
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFDiagnosSrv";
						d.QueryName = "QryDischInfDiag";
						d.Arg1 =$.form.GetValue("cboHospital"); //医院
						d.Arg2 =$("#DateFrom").val();
						d.Arg3 =$("#DateTo").val();
						d.Arg4 =$.form.GetValue("cboLocation");
						d.Arg5 =$.form.GetValue("cboStatus");
						d.Arg6 =$.form.GetValue("txtMrNo");  //病案号
						d.ArgCnt = 6;
					}
				},
				"columns": [
					{
						"data": "MrNo"
						,render: function (data, type, row) {
							return type === 'export' ?
								String.fromCharCode(2)+data:data;
						}
					},
					{"data": "PatName"},
					{"data": "Sex"},
					{"data": "Age"},
					{"data": "AdmLocDesc"},
					{"data": "ActStatus"},
					{"data": null,   // 操作
						render: function ( data, type, row ) {
							return '<a href="#" class="qz">确诊</a>&nbsp;&nbsp;<a href="#" class="ys">疑似</a>&nbsp;&nbsp;<a href="#" class="pc">排除</a>';
						}
					},
					//{"data": "ActOpinion"},   
					{"data": "InfDiagList"},
					{"data": null,
						render: function ( data, type, row ) {
							return '<a href="#" class="zy">摘要</a>';
						}
					},
					{"data": null,
						render: function ( data, type, row ) {
							return '<a href="#" class="Emr_Record">电子病历</a>';
						}
					},
					{"data": "InfPosDesc",
						render: function ( data, type, row ) {
							if (data==""){
								return '<a href="#" class="btnReprot">新建</a>';
							}else{
								return data;
							}
							 
						}
					},
					//{"data": "IRInfDate"},
					{"data": "DischDate"}
				],"fnDrawCallback": function (oSettings) {
					$("#gridDischDiag_wrapper .dataTables_scrollBody").mCustomScrollbar({
						theme : "dark-thick",
						axis: "xy",
						callbacks:{
							whileScrolling:function(){
								$('#gridDischDiag_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
							}
						}
					});			
					$("#gridDischDiag_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridDischDiag tr td:first"));
		        }
					
			});
			
			new $.fn.dataTable.Buttons(obj.gridDischDiag, {
				buttons: [					
					{
						extend: 'excel',
						text:'导出',
						title:"出院感染诊断查询"
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
			obj.gridDischDiag.ajax.reload( function ( json ) {
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
	// 新建院感报告
    $('#gridDischDiag').on('click','a.btnReprot', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridDischDiag.row(tr);
		var rowData = row.data();	
		
		var EpisodeID = rowData.EpisodeDr;
		var IsNewBaby = rowData.IsNewBaby;
      
        if (IsNewBaby==1) {
	        var url = '../csp/dhcma.hai.ir.inf.nreport.csp?EpisodeID='+EpisodeID+'&1=1';
			websys_showModal({
				url:url,
				title:'新生儿医院感染报告',
				iconCls:'icon-w-epr',  
				originWindow:window,
				closable:false,
				width:1320,
				height:'95%',
				onBeforeClose:function(){
					obj.gridDischDiag.ajax.reload(null,false);
				} 
			});
        }else {
			var url = '../csp/dhcma.hai.ir.inf.report.csp?EpisodeID='+EpisodeID+'&1=1';
			websys_showModal({
				url:url,
				title:'医院感染报告',
				iconCls:'icon-w-epr',  
				originWindow:window,
				closable:false,
				width:1320,
				height:'95%',
				onBeforeClose:function(){
					obj.gridDischDiag.ajax.reload(null,false);
				} 
			});

        }
        obj.gridDischDiag.ajax.reload(null, false);		//add
    });
    $('#gridDischDiag').on('click','a.Emr_Record', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridDischDiag.row(tr);
		var rowData = row.data();
		var EpisodeID = rowData.EpisodeDr;
		obj.btnEmrRecord_Click(EpisodeID);
    });		
	obj.btnEmrRecord_Click = function(EpisodeID)
	{		
	    var rst = $.Tool.RunServerMethod("DHCHAI.DPS.PAAdmSrv","GetPaAdmHISx",EpisodeID);
		if(rst=="")return;
		var EpisodeID = rst.split("^")[0];
		var PatientID = rst.split("^")[1];
		var url = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&2=2';
		//var url = '../csp/emr.record.browse.csp?PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&2=2';
		showFullScreenDiag(url,"病历浏览",1);
        /*
		parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:1,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});
		*/
	};
	// 摘要
    $('#gridDischDiag').on('click','a.zy', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridDischDiag.row(tr);
		var rowData = row.data();	
		
		var EpisodeID = rowData.EpisodeDr;
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&1=1';
		/*parent.layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:0,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});*/
		showFullScreenDiag(url,"");
    });	
    // 确诊
    $('#gridDischDiag').on('click','a.qz', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridDischDiag.row(tr);
		var rowData = row.data();
		var EpisodeDr = rowData.EpisodeDr;
		
		var InputStr  = EpisodeDr;
		InputStr += "^" + "1";             // 处置状态 确诊
		InputStr += "^" + "";              // 处置意见
		InputStr += "^" + $.LOGON.USERID;  // 处置人
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCDiagnosSrv","SaveCCDiagnos",InputStr,"^");
		if (parseInt(retval)>0){
			layer.msg('确诊成功!',{time: 1000,icon: 1});
			$(this).parent().prev().html("确诊");
			//obj.gridDischDiag.ajax.reload(function(){},false);
		} else {
			layer.msg('确诊失败!',{icon: 2});
		}
    });	
    // 疑似
    $('#gridDischDiag').on('click','a.ys', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridDischDiag.row(tr);
		var rowData = row.data();	
		var EpisodeDr = rowData.EpisodeDr;
		
		var InputStr  = EpisodeDr;
		InputStr += "^" + "2";             // 处置状态 疑似
		InputStr += "^" + "";              // 处置意见
		InputStr += "^" + $.LOGON.USERID;  // 处置人
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCDiagnosSrv","SaveCCDiagnos",InputStr,"^");
		if (parseInt(retval)>0){
			layer.msg('疑似成功!',{time: 1000,icon: 1});
			$(this).parent().prev().html("疑似");
			//obj.gridDischDiag.ajax.reload(function(){},false);
		} else {
			layer.msg('疑似失败!',{icon: 2});
		}
		
    });	
    // 排除
    $('#gridDischDiag').on('click','a.pc', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridDischDiag.row(tr);
		var rowData = row.data();	
		var EpisodeDr = rowData.EpisodeDr;
		
		var InputStr  = EpisodeDr;
		InputStr += "^" + "3";             // 处置状态 排除
		InputStr += "^" + "";              // 处置意见
		InputStr += "^" + $.LOGON.USERID;  // 处置人
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IRS.CCDiagnosSrv","SaveCCDiagnos",InputStr,"^");
		if (parseInt(retval)>0){
			layer.msg('排除成功!',{time: 1000,icon: 1});
			$(this).parent().prev().html("排除");
			//obj.gridDischDiag.ajax.reload(function(){},false);
		} else {
			layer.msg('排除失败!',{icon: 2});
		}
    });	
}