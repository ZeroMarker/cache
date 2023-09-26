//页面Event
function InitPatFindWinEvent(obj){
	CheckSpecificKey();
	obj.LoadEvents = function(arguments){
		$("#btnQuery").on('click',obj.btnQuery_click);
		$("#btnClear").on('click',obj.btnClear_click);
		$("#txtPatName").on('keyup',obj.txtPatName_keyup);
		$("#txtPapmiNo").on('keyup',obj.txtPapmiNo_keyup);
		$("#txtMrNo").on('keyup',obj.txtMrNo_keyup);
		$("#btnsearch").on('click',obj.btnsearch_click);
		$("#search").on('keyup',obj.search_keyup);
		$("#btnExport").on('click',obj.btnExport_click);
		$("#btnPrint").on('click',obj.btnPrint_click);

		new $.fn.dataTable.Buttons(obj.gridAdm, {
			buttons: [				
				{
					extend: 'excel',
					text:'导出',
					title:"患者列表"
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
				/*
				,{
					extend: 'print',
					text:'打印'
					,title:""
					,footer: true
				}*/
			]
		});
	}
	//导出
	obj.btnExport_click = function(){
		obj.gridAdm.buttons(0,null)[0].node.click();
	}
	/*
 	//打印
 	obj.btnPrint_click = function(){
 		obj.gridAdm.buttons(0,null)[1].node.click();
 	}
 	*/
	//搜索功能
	obj.btnsearch_click = function () {
       //当出现“||”字符时,该方法无效
	   // $('#gridAdm').DataTable().search($('#search').val(), true, true).draw();
	   obj.reloadgridAdm();
	}
	//姓名回车查询
	obj.txtPatName_keyup = function(e){
		if(e.keyCode == 13){
			obj.reloadgridAdm();
		}
	}
	//登记号校验、回车查询
	obj.txtPapmiNo_keyup = function(e){
		if (this.value.length>10){
			this.value = this.value.substring(0,10);
		}
		this.value=this.value.replace(/[^\d]/g,'');
		var Reglength=this.value.length;
		if(e.keyCode == 13){
			if (Reglength!=0) {
				for(var i=0;i<(10-Reglength);i++)   //登记号回车自动补零
				{
					this.value="0"+this.value;
				}
			}
			obj.reloadgridAdm();
		}
	}
	//病案号校验、回车查询
	obj.txtMrNo_keyup = function(e){
		this.value=this.value.replace(/[^\a-\z\A-\Z0-9]/g,'')
		if(e.keyCode == 13){
			obj.reloadgridAdm();
		}
	}
	//查询按钮
	obj.btnQuery_click = function (){
		obj.reloadgridAdm();
	}
	//重新加载表格数据
	obj.reloadgridAdm = function(){
		var HospIDs	    = $("#cboHospital").val();
		var DateType	= $("#cboDateType").val();
		var DateFrom 	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		var LocationID  = $("#cboLocation").val();
		var WardID	 	= $("#cboWard").val();
		var PatName 	= $("#txtPatName").val();
		var PapmiNo 	= $("#txtPapmiNo").val();
		var MrNo 		= $("#txtMrNo").val();
		if ((DateType!="")||(DateFrom!="")||(DateTo!=""))
		{   /*
			if ((DateType=="")||(DateFrom=="")||(DateTo=="")){
				layer.msg('请选择日期类型、开始日期、结束日期！');
				return;
			}*/
			var ErrorStr = "";
			if (DateType=="") {
				ErrorStr += '请选择日期类型!<br/>';
			}
			if (DateFrom=="") {
				ErrorStr += '请选择开始日期!<br/>';
			}
			if (DateTo == "") {
				ErrorStr += '请选择结束日期!<br/>';
			}
			if (DateFrom > DateTo) {
				ErrorStr += '开始日期不能大于结束日期!<br/>';
			}
			if (ErrorStr != '') {
				layer.msg(ErrorStr,{icon: 0});
				return;
			}
		}else{
			if ((PatName=="")&&(PapmiNo=="")&&(MrNo=="")){
				layer.msg('请选择查询条件！',{icon: 0});
				return;
			}
		}
		obj.gridAdm.clear().draw()
		obj.gridAdm.ajax.reload( function ( json ) {
		    if (json.data.length==0){
				layer.msg('没有找到相关数据！',{icon: 2});
				return;
			}
			else
			{
				$("#gridAdm").dataTable().fnAdjustColumnSizing();
			}
		} );
	};
	//清楚按钮
	obj.btnClear_click = function(){
		$.form.SetValue("cboHospital",'','');
		$.form.SetValue("cboDateType",'','');
		$.form.SetValue("cboLocation",'','');
		$.form.SetValue("cboWard",'','');
		$.form.SetValue("txtPatName",'');
		$.form.SetValue("txtPapmiNo",'');
		$.form.SetValue("txtMrNo",'');
		$("#DateFrom").val('');
		$("#DateTo").val('');
	}
	// 新建院感报告
    $('#gridAdm').on('click','a.btnReprot', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridAdm.row(tr);
		var rowData = row.data();	
		
		var EpisodeID = rowData.EpisodeID;
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
				onBeforeClose:function(){} 
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
				onBeforeClose:function(){} 
			});
        }
    });
	// 摘要点击
    $('#gridAdm').on('click','a.zy', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridAdm.row(tr);
		var rowData = row.data();	
		
		var EpisodeID = rowData.EpisodeID;
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&1=1';
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
    });
    // 电子病历点击
    $('#gridAdm').on('click','a.dzbl', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridAdm.row(tr);
		var rowData = row.data();	
		
		var EpisodeIDx = rowData.EpisodeIDx;
		var EpisodeID = EpisodeIDx.split("||")[1];
		var PatientID = rowData.PatientIDx;
		var url = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';	
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
    });
	// 手术点击
    $('#gridAdm').on('click','a.opr', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridAdm.row(tr);
		var rowData = row.data();	
		
		var EpisodeID = rowData.EpisodeID;
		var url = '../csp/dhchai.ir.inf.report4.csp?EpisodeID='+EpisodeID+'&1=1';
		//parent.
		parent.layer.open({
		      type: 2,
			  area: ['90%', '100%'],
			  title:false,
			  //closeBtn:0,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});
    });
}

