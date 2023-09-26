//页面Event
function InitOEItmMastMapWinEvent(obj){
	CheckSpecificKey();
	 /*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridOEItmMastMap').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
	    	obj.gridOEItmMastMap.search(this.value).draw();
	    }
    });
   /**********************/
	obj.gridOEItmMastMap.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridOEItmMastMap.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridOEItmMastMap.on('dblclick', 'tr', function(e) {
		var rd = obj.gridOEItmMastMap.row(this).data();
		
		obj.layer_rd = rd;
		obj.Layer();
	    
	});
	
	$("#btnAll").on('click', function(){	
		flg = "";
	 	obj.gridOEItmMastMap.ajax.reload($('#gridOEItmMastMap').DataTable().search($('#search').val(),true,true).draw());
	});
	$("#btnPend").on('click', function(){	
		flg = 0;
	 	obj.gridOEItmMastMap.ajax.reload($('#gridOEItmMastMap').DataTable().search($('#search').val(),true,true).draw());
	});
	$("#btnFin").on('click', function(){
		flg = 1;
	 	obj.gridOEItmMastMap.ajax.reload($('#gridOEItmMastMap').DataTable().search($('#search').val(),true,true).draw());
	});
	$("#btnSyn").on('click', function(){
		var retval = $.Tool.RunServerMethod("DHCHAI.DPS.OEItmMastMapSrv","SynMapRule","医嘱项");
		if (parseInt(retval)>0){
			layer.msg('成功匹配'+retval+'条!',{icon: 1});
		} else {
			layer.msg('没有可匹配项或匹配失败!',{icon: 2});
		}
		obj.gridOEItmMastMap.ajax.reload();
	
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
        var Maprd  = obj.gridOEItmMastMap.rows({selected: true}).data().toArray()[0];	
		var Matsrd = obj.gridOEItmMast.rows({selected: true}).data().toArray()[0];
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var MastID = (Matsrd ? Matsrd["ID"] : '');
		
		if ((MapID == "")||(MastID == "")) {
			layer.msg('设置对照关系需同时选择医嘱项字典及对照项目!',{icon: 2});
		}else {
			var ActUser = $.LOGON.USERID;
			var retval = $.Tool.RunServerMethod("DHCHAI.DPS.OEItmMastMapSrv","UpdateMap",MapID,MastID,ActUser);
			if (parseInt(retval)>0){
				obj.gridOEItmMastMap.ajax.reload(function(){
					var rowIndex = $.Tool.GetTableRowIndex(obj.gridOEItmMastMap,retval);
					if (rowIndex > -1){
						var rd =obj.gridOEItmMastMap.row(rowIndex).data();
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
		var selectedRows = obj.gridOEItmMastMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridOEItmMastMap.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();
	
	});
	
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridOEItmMastMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridOEItmMastMap.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		if (rd["BTMapItemDr"]=="") {
			layer.msg('没有对照关系，不可撤销!',{icon: 0});
		}else {
			layer.confirm( '确认是否撤销对照关系?', {
				btn: ['确认','取消'],    //btn位置对应function的位置
				btnAlign: 'c'
				},
				function(){ 
					var flg = $.Tool.RunServerMethod("DHCHAI.DP.OEItmMastMap","DeleteMapById",ID);
					if (parseInt(flg)>0){
						obj.gridOEItmMastMap.ajax.reload(function(){
							var rowIndex = $.Tool.GetTableRowIndex(obj.gridOEItmMastMap,flg);
							if (rowIndex > -1){
								var rd =obj.gridOEItmMastMap.row(rowIndex).data();
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
	
	//医嘱对照编辑窗体-初始化
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
			title: '医嘱分类对照编辑', 
			content: $('#layer'),
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.Layer_Save();
			  	layer.close(index); //关闭
			}
		}); 	
		
	}
	//医嘱分类对照编辑窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var BTItmDesc = rd["BTOrdDesc"];
		var OrdCatDesc = rd["OrdCatDesc"];
		var BTMapItemDr = rd["BTMapItemDr"];
		var BTMapNote = $.form.GetValue("txtBTMapNote");
		var BTSCode = rd["BTSCode"];
		var IsActive = $.form.GetValue("chkIsActive");
		
		var InputStr = ID;
		InputStr += "^" + BTItmDesc;
		InputStr += "^" + OrdCatDesc;
		InputStr += "^" + BTMapItemDr;
		InputStr += "^" + BTMapNote;
		InputStr += "^" + BTSCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.OEItmMastMap","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridOEItmMastMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridOEItmMastMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridOEItmMastMap.row(rowIndex).data();
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

	//医嘱项字典
	/*****搜索功能*****/
	$("#btnsearch_two").on('click', function(){
       $('#gridOEItmMast').DataTable().search($('#search_two').val(),true,true).draw();
       
    });
	
    $("#search_two").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
  			obj.gridOEItmMast.search(this.value).draw();
	    }
    });
}