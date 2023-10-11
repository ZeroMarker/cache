//页面Event
function InitPatFindWinEvent(obj){
	CheckSpecificKey();
	
	var CheckFlg = 0; 
	if (tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //审核权限
	}
	else
	{
		$.form.SetValue('cboLocation',$.LOGON.LOCID,"");
		$("#cboLocation").attr('disabled','disabled');
		$("#cboWard").attr('disabled','disabled');
		$("#cboHospital").attr('disabled','disabled');
		//触发查询
		$("#btnQuery").click();
	}
	
	obj.LoadEvents = function(arguments){
		$("#btnQuery").on('click',obj.btnQuery_click);
		$("#btnClear").on('click',obj.btnClear_click);
		//$("#txtPatName").on('keyup',obj.txtPatName_keyup);
		//$("#txtPapmiNo").on('keyup',obj.txtPapmiNo_keyup);
		//$("#txtMrNo").on('keyup',obj.txtMrNo_keyup);
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
 	//打印床旁调查表按钮
	$("#btnPrintRep").on('click',function(){
		var HospIDs	    = $("#cboHospital").val();
		var LocationID  = $("#cboLocation").val();
		var SurvNumber 	= $("#cboSurvNumber").val();
		if ((HospIDs=="")){
			layer.msg('请选择调查院区！');
			return;
		}
		if (SurvNumber==""){
			layer.msg('请选择调查编号！');
			return;
		}
		if (LocationID==""){
			layer.msg('请选择调查科室！');
			return;
		}
		obj.Layer_Export();
	});
	// 打印床旁调查表
	obj.Layer_Export =function() {
		var HospIDs 	= $("#cboHospital").val();
		var LocationID  = $("#cboLocation").val();
		var SEID	 	= $("#cboSurvNumber").val();
		var PatName 	= "";
		var PapmiNo 	= "";
		var MrNo 		= "";
		var aYear = $.form.GetCurrDate('-');
		aYear = aYear.split("-")[0]; 
		var aLocDesc = $.form.GetText("cboLocation");
		var aInputs = HospIDs+'^'+LocationID+'^'+SEID+'^'+PatName+'^'+PapmiNo+'^'+MrNo;
		var url="dhccpmrunqianreport.csp?reportName=DHCHAICSSSurvTable.raq&aInputs="+aInputs+"&aPatSum="+""+"&aLocDesc="+aLocDesc+"&aYear="+aYear;
		websys_createWindow(url,1,"width=710,height=610,top=0,left=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	}
	//搜索功能
	obj.btnsearch_click =  function(){
	   $('#gridAdm').DataTable().search($('#search').val().replace('||','\\|\\|'),true,true).draw();
	   
	};
	obj.search_keyup = function(e){
		if(e.keyCode == 13){
			$('#gridAdm').DataTable().search($('#search').val().replace('||','\\|\\|'),true,true).draw();
		}
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
			for(var i=0;i<(10-Reglength);i++)   //登记号回车自动补零
			{
				this.value="0"+this.value;
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
		var LocationID  = $("#cboLocation").val();
		var WardID	 	= $("#cboWard").val();
		var SurvNumber 	= $("#cboSurvNumber").val();
		var PatName 	= "";  //$("#txtPatName").val()
		var PapmiNo 	= "";
		var MrNo 		= "";
		if ((HospIDs=="")){
			layer.msg('请选择调查院区！');
			return;
		}
		if ((LocationID=="")&&(WardID=="")){
			layer.msg('请选择调查科室或病区！');
			return;
		}
		if (SurvNumber==""){
			layer.msg('请选择调查编号！');
			return;
		}
		obj.gridAdm.clear().draw()
		obj.gridAdm.ajax.reload( function ( json ) {
		    if (json.data.length==0){
				layer.msg('没有找到相关数据！');
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
		$.form.SetValue("cboLocation",'','');
		$.form.SetValue("cboWard",'','');
		$.form.SetValue("cboSurvNumber",'','');
		$.form.SetValue("txtPatName",'');
		$.form.SetValue("txtPapmiNo",'');
		$.form.SetValue("txtMrNo",'');
	}
	// 新建报告
    $('#gridAdm').on('click','a.btnReprot', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridAdm.row(tr);
		var rowData = row.data();	
		
		var EpisodeID = rowData.EpisodeID;
		var SurvNumber = rowData.SurvNumber;
		var ReportID =rowData.RepID;
		var url = '../csp/dhchai.ir.cssreport.csp?EpisodeID='+EpisodeID+'&SurvNumber='+$("#cboSurvNumber").val()+'&ReportID='+ReportID+'&1=1';
		layer.open({
		      type: 2,
			  area: ['95%', '99%'],
			  title:'横断面调查:'+SurvNumber,
			  fixed: false, //不固定
			  content: [url,'no'],
			  success: function(layero, index){
				$("div.layui-layer-content").css("padding-right","2px");
			  },
			  cancel: function(index){ 
				obj.reloadgridAdm();
			  }
		});
    });
	// 摘要点击
    $('#gridAdm').on('click','a.zy', function (e) {
	    //e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridAdm.row(tr);
		var rowData = row.data();	
		
		var EpisodeID = rowData.EpisodeID;
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&1=1';
		layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  title:false,
			  closeBtn:0,
			  fixed: false, //不固定
			  maxmin: false,
			  maxmin: false,
			  content: [url,'no']
		});
    });
	// 手术点击
    $('#gridAdm').on('click','a.opr', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridAdm.row(tr);
		var rowData = row.data();	
		
		var EpisodeID = rowData.EpisodeID;
		var SurvNumber = rowData.SurvNumber;
		var url = '../csp/dhchai.ir.inf.report4.csp?EpisodeID='+EpisodeID+'&SurvNumber='+SurvNumber+'&1=1';
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

