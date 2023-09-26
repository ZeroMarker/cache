//页面Event
function InitOEAntiMastMapWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridOEAntiMastMap').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
	   		obj.gridOEAntiMastMap.search(this.value).draw();
	    }
    });
   /**********************/
	obj.gridOEAntiMastMap.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridOEAntiMastMap.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridOEAntiMastMap.on('dblclick', 'tr', function(e) {
		var rd = obj.gridOEAntiMastMap.row(this).data();
		
		obj.layer_rd = rd;
		obj.Layer();
	    
	});
	
	$("#btnAll").on('click', function(){	
		flg = "";
	 	obj.gridOEAntiMastMap.ajax.reload($('#gridOEAntiMastMap').DataTable().search($('#search').val(),true,true).draw());
	});
	$("#btnPend").on('click', function(){	
		flg = 0;
	 	obj.gridOEAntiMastMap.ajax.reload($('#gridOEAntiMastMap').DataTable().search($('#search').val(),true,true).draw());
	});
	$("#btnFin").on('click', function(){
		flg = 1;
	 	obj.gridOEAntiMastMap.ajax.reload($('#gridOEAntiMastMap').DataTable().search($('#search').val(),true,true).draw());
	});
	$("#btnSyn").on('click', function(){
		var retval = $.Tool.RunServerMethod("DHCHAI.DPS.OEAntiMastMapSrv","SynMapRule","抗菌药物医嘱");
		if (parseInt(retval)>0){
			layer.msg('成功匹配'+retval+'条!',{icon: 1});
		} else {
			layer.msg('没有可匹配项或匹配失败!',{icon: 2});
		}
		obj.gridOEAntiMastMap.ajax.reload();
	
	});
    $(".tab-button .tabbtn").mouseleave(function(){
		$(".tab-button .tabbtn").css("background-color","#FFFFFF");
	});
	$(".tab-button .tabbtn").focus(function(){
		$(".tab-button .tabbtn:focus").css("background-color","#B0E0E6");
	});
	$(".tab-button .tabbtn").click(function(){
		$(".tab-button .tabbtn:focus").css("background-color","#B0E0E6");
	});	
    $("#btnAdd").on('click', function(){
		var flag = $("#btnAdd").hasClass("disabled");
		if(flag) return ;
        var Maprd  = obj.gridOEAntiMastMap.rows({selected: true}).data().toArray()[0];	
		var Antird = obj.gridOEAntiMast.rows({selected: true}).data().toArray()[0];
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var AntiID = (Antird ? Antird["ID"] : '');
		
		if ((MapID == "")||(AntiID == "")) {
			layer.msg('设置对照关系需同时选择抗菌药物字典及对照项目!',{icon: 2});
		}else {
			var ActUser = $.LOGON.USERID;
			var retval = $.Tool.RunServerMethod("DHCHAI.DPS.OEAntiMastMapSrv","UpdateMap",MapID,AntiID,ActUser);
			if (parseInt(retval)>0){
				obj.gridOEAntiMastMap.ajax.reload(function(){
					var rowIndex = $.Tool.GetTableRowIndex(obj.gridOEAntiMastMap,retval);
					if (rowIndex > -1){
						var rd =obj.gridOEAntiMastMap.row(rowIndex).data();
						obj.layer_rd = rd;
					} else {
						obj.layer_rd = '';
					}
					layer.msg('对照成功!',{icon: 1});
				},false); 
			} else {
				layer.msg('对照失败!',{icon: 2});
			}
		}

	});
	$("#btnEdit").on('click', function(){
		var flag = $("#btnEdit").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridOEAntiMastMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridOEAntiMastMap.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();
	
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridOEAntiMastMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridOEAntiMastMap.rows({selected: true}).data().toArray()[0];	
	
		var ID = rd["ID"];
		if (rd["BTMapItemDr"]=="") {
			layer.msg('没有对照关系，不可撤销!',{icon: 0});
		}else {
			layer.confirm( '确认是否撤销对照关系?', {
				btn: ['确认','取消'],    //btn位置对应function的位置
				btnAlign: 'c'
				},
				function(){ 
					var flg = $.Tool.RunServerMethod("DHCHAI.DP.OEAntiMastMap","DeleteMapById",ID);
					if (parseInt(flg)>0){
						obj.gridOEAntiMastMap.ajax.reload(function(){
							var rowIndex = $.Tool.GetTableRowIndex(obj.gridOEAntiMastMap,flg);
							if (rowIndex > -1){
								var rd =obj.gridOEAntiMastMap.row(rowIndex).data();
								obj.layer_rd = rd;
							} else {
								obj.layer_rd = '';
							}
							layer.msg('撤销成功!',{icon: 1});
						},false);	
						
					} else {
						layer.msg('撤销失败!',{icon: 2});
					}
			 });
		}

	});
	
	//抗菌药物对照编辑窗体-初始化
	obj.Layer = function(){	
		$.form.iCheckRender();

		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtBTMapNote",rd["BTMapNote"]);
			$.form.SetValue("chkIsActive",rd["BTIsActive"]== 1);
		} else {
			$.form.SetValue("txtBTMapNote",'');
			$.form.SetValue("chkIsActive",true);
		}

		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '抗菌药物对照编辑', 
			content: $('#layer'),
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.Layer_Save();
			  	layer.close(index); //关闭
			}
		}); 	
		
	}
	
	//抗菌药物对照编辑窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var BTAnitDesc = rd["BTAnitDesc"];
		var BTMapItemDr =rd["BTMapItemDr"];
		var BTMapNote = $.form.GetValue("txtBTMapNote");
		var BTSCode = rd["BTSCode"];
		var IsActive = $.form.GetValue("chkIsActive");

		var InputStr = ID;
		InputStr += "^" + BTAnitDesc;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + BTMapItemDr;
		InputStr += "^" + BTMapNote;
		InputStr += "^" + BTSCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.OEAntiMastMap","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridOEAntiMastMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridOEAntiMastMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridOEAntiMastMap.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	}
	//抗菌药物医嘱字典
	/*****搜索功能*****/
	 $("#btnsearch_two").on('click', function(){
       $('#gridOEAntiMast').DataTable().search($('#search_two').val(),true,true).draw();
       
    });
	
    $("#search_two").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
	    	obj.gridOEAntiMast.search(this.value).draw();
	    }
    });
}