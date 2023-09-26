//页面Event
function InitOccExpRemindWinEvent(obj){
	CheckSpecificKey();
	// 渲染checkbox
	$.form.CheckBoxRender();
	$.form.iCheckRender();  //渲染复选框|单选钮

	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridExpRemind').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridExpRemind.search(this.value).draw();
        }
    });
	
	//导出
    $("#btnExport").on('click', function(){
		obj.gridExpRemind.buttons(0,null)[0].node.click();
	});
    
    $("#btnQuery").on('click', function(){
        var DateFrom 	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		obj.gridExpRemind.clear().draw();
		if(DateFrom > DateTo){
			layer.msg('开始日期应小于或等于结束日期！',{time: 2000,icon: 2});
			return;
		}
		
		var DateType =$.form.GetValue("cboDateType");
		/*
		var currDate = $.form.GetCurrDate('-');
		if (DateType ==1) {
			if ($.form.DateDiff(DateTo,currDate)>AftDay) {
    			layer.msg('待提醒查询结束日期不能在当前日期'+AftDay+'日之后!',{time: 2000,icon: 2});
				return ;
    		}
    		if ($.form.DateDiff(currDate,DateFrom)>PerDay) {
    			layer.msg('待提醒查询开始日期不应在当前日期'+PerDay+'日之前!',{time: 2000,icon: 2});
				return ;
    		}
		}
		*/
	    var mylayer = layer.load(1);
		obj.gridExpRemind.ajax.reload(function ( json ){
			setTimeout(function(){
			  	layer.closeAll('loading');
			}, 100);
		    if (json.data.length==0){
				layer.msg('没有找到相关数据！',{time: 2000,icon: 2});
				return;
			}
		});
	});
	
   /**********************/
    $('#gridExpRemind').on('click','a.btnRemind', function (e) {	  //提醒
		var tr = $(this).closest('tr');
		var row = obj.gridExpRemind.row(tr);
		var rd = row.data();
	    var ReportID  = rd["ID"];
	    var LabTimList = rd["LabTimList"];
	   
		var StatusDr = $.Tool.RunServerMethod("DHCHAI.BT.Dictionary","GetIDByCode","OERegStatus",11);		
		var Opinion  = '已提醒'+"#"+LabTimList;
		var InputRegLog = ReportID;
		InputRegLog = InputRegLog + "^" + '';
		InputRegLog = InputRegLog + "^" + StatusDr;		//状态
		InputRegLog = InputRegLog + "^" + Opinion;
		InputRegLog = InputRegLog + "^" + '';
		InputRegLog = InputRegLog + "^" + '';
		InputRegLog = InputRegLog + "^" + $.LOGON.USERID;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.OccExpRegLog","Update",InputRegLog);
		if(parseInt(retval)>0) {
			obj.gridExpRemind.ajax.reload(null,false);
	        layer.msg('提醒成功！',{time: 2000,icon: 1});
        }else{
			layer.msg('提醒失败！',{time: 2000,icon: 2});
		}
		
    });
    
    obj.gridExpRemind.on('dblclick', 'tr', function(e) {
		var rd = obj.gridExpRemind.row(this).data();
		var RepTypeID = rd["RegTypeID"];
		var ReportID  = rd["ID"];
	    var url = '../csp/dhchai.ir.occexpreport.csp?1=1&RegTypeID='+RepTypeID+'&ReportID='+ReportID+"&AdminPower="+obj.AdminPower+"&2=2"
		layer.open({
		      type: 2,
			  area: ['95%', '95%'],
			  closeBtn: 1,
			  title:'职业暴露报告',
			  fixed: false, //不固定
			  content: [url,'no'],
			  success: function(layero, index){
			  		$("div.layui-layer-content").css("padding-right","2px");
			  },
			  end: function () {
              	obj.gridExpRemind.ajax.reload(null,false);
              }
		});
	    
	});
	
	//操作明细
    $('#gridExpRemind').on('click','a.btnOperation', function (e) {	  
		var tr = $(this).closest('tr');
		var row = obj.gridExpRemind.row(tr);
		var rd = row.data();
		obj.RepID  = rd["ID"];
		obj.Status =11;
		obj.gridExpRepLog.ajax.reload();
		layer.open({
			type: 1,
			zIndex: 100,
			area: '800px',
			title:'已提醒明细',
			content: $('#layer_one')		
		});	
    });
}