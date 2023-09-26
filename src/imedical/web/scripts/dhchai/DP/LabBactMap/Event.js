//页面Event
function InitLabBactMapWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridLabBactMap').DataTable().search($('#search').val(),true,true).draw();   
    });
	
    $("#search").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
	    	obj.gridLabBactMap.search(this.value).draw();
	    }
    });
   /**********************/
	obj.gridLabBactMap.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
		
	});

	obj.gridLabBactMap.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');	
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
		
	});
	
	obj.gridLabBactMap.on('dblclick', 'tr', function(e) {
		var rd = obj.gridLabBactMap.row(this).data();
		obj.layer_rd = rd;
		obj.Layer();
	    
	});
	
	$("#btnAll").on('click', function(){	
		flg = "";
	 	obj.gridLabBactMap.ajax.reload($('#gridLabBactMap').DataTable().search($('#search').val(),true,true).draw());
	});
	$("#btnPend").on('click', function(){	
		flg = 0;
	 	obj.gridLabBactMap.ajax.reload($('#gridLabBactMap').DataTable().search($('#search').val(),true,true).draw());
	});
	$("#btnFin").on('click', function(){
		flg = 1;
	 	obj.gridLabBactMap.ajax.reload($('#gridLabBactMap').DataTable().search($('#search').val(),true,true).draw());
	});
	$("#btnSyn").on('click', function(){
		var retval = $.Tool.RunServerMethod("DHCHAI.DPS.LabBactSrv","SynMapRule","检验细菌");
		if (parseInt(retval)>0){
			layer.msg('成功匹配'+retval+'条!',{icon: 1});
		} else {
			layer.msg('没有可匹配项或匹配失败!',{icon: 2});
		}
		obj.gridLabBactMap.ajax.reload();
	
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
        var Maprd  = obj.gridLabBactMap.rows({selected: true}).data().toArray()[0];	
		var Bactrd = obj.gridLabBacteria.rows({selected: true}).data().toArray()[0];
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var BactID = (Bactrd ? Bactrd["ID"] : '');
		
		if ((MapID == "")||(BactID == "")) {
			layer.msg('设置对照关系需同时选择细菌字典及对照项目!',{icon: 2});
		}else {
			var ActUser = $.LOGON.USERDESC;
			var retval = $.Tool.RunServerMethod("DHCHAI.DPS.LabBactSrv","UpdateMap",MapID,BactID,ActUser);
			if (parseInt(retval)>0){
				obj.gridLabBactMap.ajax.reload(function(){
					var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabBactMap,retval);
					if (rowIndex > -1){
						var rd =obj.gridLabBactMap.row(rowIndex).data();
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
		var selectedRows = obj.gridLabBactMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabBactMap.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();
	
	});

	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLabBactMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabBactMap.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		if (rd["MapItemID"]=="") {
			layer.msg('没有对照关系，不可撤销!',{icon: 0});
		}else {
			layer.confirm( '确认是否撤销对照关系?', {
				btn: ['确认','取消'],   //btn位置对应function的位置
				btnAlign: 'c'
				},
				function(){ 
					var flg = $.Tool.RunServerMethod("DHCHAI.DP.LabBactMap","DeleteMapById",ID);
					if (parseInt(flg)>0){
						obj.gridLabBactMap.ajax.reload(function(){
							var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabBactMap,flg);
							if (rowIndex > -1){
								var rd =obj.gridLabBactMap.row(rowIndex).data();
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
	
  
	//细菌字典对照编辑窗体-初始化
	obj.Layer = function(){
	    $.form.iCheckRender(); //单选按钮
	    
	    $.form.SelectRender("#layer");  //渲染下拉框
        var rd = obj.layer_rd;
		if (rd){		
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
			$.form.SetValue("txtMapNote",rd["MapNote"]);
		} else {
			$.form.SetValue("chkActive",'');
			$.form.SetValue("txtMapNote",'');
		}

		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '细菌字典对照编辑', 
			content: $('#layer'),
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.Layer_Save();
			  	layer.close(index); //关闭
			}
		}); 	
		
	}
	
	//细菌字典对照配置窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		
		var ID = (rd ? rd["ID"] : '');
      	var Bacteria  = rd["Bacteria"];
        var MapItemDr = rd["MapItemID"];
		var IsActive  = $.form.GetValue("chkActive");		
		var MapNote   = $.form.GetValue("txtMapNote");
		var SCode     = rd["SCode"];	
	    var ActUser   = $.LOGON.USERDESC;
		
		var InputStr = ID;
		InputStr += "^" + Bacteria;
		InputStr += "^" + MapItemDr;	
		InputStr += "^" + MapNote;
		InputStr += "^" + SCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabBactMap","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLabBactMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabBactMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabBactMap.row(rowIndex).data();
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
	
	
	/*****搜索功能*****/
    $("#btnsearch_two").on('click', function(){
       $('#gridLabBacteria').DataTable().search($('#search_two').val(),true,true).draw();
       
    });
	
    $("#search_two").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
	   		obj.gridLabBacteria.search(this.value).draw();
	    }
    });
    
}
