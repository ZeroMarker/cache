//页面Event
function InitPatFindWinEvent(obj){
	CheckSpecificKey();
	obj.LoadEvents = function(arguments){
		$("#btnQuery").on('click',obj.btnQuery_click);
		$("#btnClear").on('click',obj.btnClear_click);
		$("#btnsearch").on('click',obj.btnsearch_click);
		$("#search").on('keyup',obj.search_keyup);
		$("#btnExport").on('click',obj.btnExport_click);

		new $.fn.dataTable.Buttons(obj.gridAdm, {
			buttons: [				
				{
					extend: 'excel',
					text:'导出',
					title:"高危患者列表"
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
	obj.btnsearch_click =  function(){
	   $('#gridAdm').DataTable().search($('#search').val(),true,true).draw();
	   
	};
	obj.search_keyup = function(e){
		if(e.keyCode == 13){
			$('#gridAdm').DataTable().search($('#search').val(),true,true).draw();
		}
	}
	
	//查询按钮
	obj.btnQuery_click = function (){
		obj.reloadgridAdm();
	}
	//重新加载表格数据
	obj.reloadgridAdm = function(){
		var HospIDs	    = $("#cboHospital").val();
		var DateType	= "1";
		var DateFrom 	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		var LocationID  = $("#cboLocation").val();		
		var Items 		= "";
		var reslist	 	= $("#cboItems").select2("data");
		
		for(var i = 0;i<reslist.length;i++){
			var dataObj = reslist[i];
			var id = dataObj.id;
			if(id!="")
			{
				if(Items=="")
				{
					Items = id;
				}
				else
				{
					Items = Items +"|"+id;
				}
			}
		}
		var ErrorStr = "";
		if (Items=="") {
			ErrorStr += '请选择监测项目!<br/>';
		}
		if (DateFrom=="") {
			ErrorStr += '请选择开始日期!<br/>';
		}
		if (DateTo == "") {
			ErrorStr += '请选择结束日期!<br/>';
		}
		if (ErrorStr != '') {
			layer.msg(ErrorStr,{icon: 0});
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
		$("#DateFrom").val('');
		$("#DateTo").val('');
	}
	
	// 摘要点击
    $('#gridAdm').on('click','a.zy', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridAdm.row(tr);
		var rowData = row.data();
		
		var EpisodeID = rowData.EpisodeID;
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
}

