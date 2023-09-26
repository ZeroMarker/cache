//页面Event
function InitPACWardWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridPACWard').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridPACWard.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
    $("#btnWardSubNo").addClass('disabled');
	obj.gridPACWard.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
		var rd = obj.gridPACWard.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
		if (rd["WardID"]!=""){
			$("#btnWardSubNo").removeClass('disabled');
		}
	});
	
	obj.gridPACWard.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnWardSubNo").addClass('disabled');
        $("#btnDelete").addClass('disabled');
        obj.layer_rd = "";
	});
	
	obj.gridPACWard.on('dblclick', 'tr', function(e) {
		var rd = obj.gridPACWard.row(this).data();
		obj.layer_rd = rd;
		obj.Layer();
	    
	});
	
	$("#btnEdit").on('click', function(){
		var flag = $("#btnEdit").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridPACWard.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridPACWard.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
	    obj.Layer();
	
		
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridPACWard.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridPACWard.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["WardID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c',
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.BT.PACWard","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridPACWard.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
		
	});
	
	$("#btnWardSubNo").on('click', function(){
		var flag = $("#btnWardSubNo").hasClass("disabled");
		if(flag) return ;	
		var selectedRows =  obj.gridPACWard.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		if (obj.layer_rd["WardID"]==""){
			return;
		}
		
	    var flag=$.Tool.RunServerMethod("DHCHAI.BTS.PACWardSrv","PACWardSubNo",obj.layer_rd["WardID"]);
		if (parseInt(flag)>0){
			obj.gridPACWard.ajax.reload();
			layer.msg('分区成功!',{icon: 1});
		}else{
			layer.msg('分区失败!',{icon: 2});
		}
	});	
	// 病区分布定义-初始化
	obj.Layer = function(){
		$.form.SelectRender("#WardBuilding"); 
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("WardBuilding",rd["BuildingID"],rd["Building"]);
			$.form.SetValue("txtFloor",rd["Floor"]);
			$.form.SetValue("txtArea",rd["Area"]);
			var SubNo=rd["SubNo"];
			if (SubNo=="") {SubNo=1}  // 默认为1
			$.form.SetValue("txtSubNo",SubNo);
			$.form.SetValue("txtAreaColor",rd["AreaColor"]);
			
		} else {
			$.form.SetValue("WardBuilding",'');
			$.form.SetValue("txtFloor",'');
			$.form.SetValue("txtArea",'');
			$.form.SetValue("txtSubNo","1");
			$.form.SetValue("txtAreaColor",'');
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '病区分布定义', 
			content: $('#layer'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.Layer_Add();
			},
			btn2: function(index, layero){
				obj.Layer_Save();
			  	return false;
			},
			success: function(layero){
				var button = layero.find(".layui-layer-btn0");
				if (rd) {
					$(button).hide();
				}
				
			}	
		}); 	
		
	}
	
	// 病区分布定义-保存
	 obj.Layer_Save = function(){
        var rd = obj.layer_rd;
		var ID = (rd ? rd["WardID"] : '');
		var LocDr     = (rd ? rd["ID"] : '');
		var BuildingDr= $.form.GetValue("WardBuilding");
		var Floor     = $.form.GetValue("txtFloor");
		var Area      = $.form.GetValue("txtArea");
		var SubNo     = $.form.GetValue("txtSubNo");
		var AreaColor = $.form.GetValue("txtAreaColor");
	
		if (LocDr== '') {
			layer.alert("科室不允许为空",{icon: 0});
			return;
		}
		if (SubNo== '') {
			layer.alert("分区号不允许为空",{icon: 0});
			return;
		}
		if (BuildingDr== '') {
			layer.alert("病房大楼不允许为空",{icon: 0});
			return;
		}
		if(!/^(-|\+)?[0-9]*$/.test(Floor)){
			layer.alert("楼层必须为数字!");
			return;
		}
		if(!/^(-|\+)?[0-9]*$/.test(SubNo)){
			layer.alert("分区号必须为数字!");
			return;
		}
		var InputStr = ID;
		InputStr += "^" + LocDr;
		InputStr += "^" + BuildingDr;
		InputStr += "^" + Floor;
		InputStr += "^" + Area;
		InputStr += "^" + SubNo;
		InputStr += "^" + AreaColor;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.PACWard","Update",InputStr); 
		if (parseInt(retval)>0){
			obj.gridPACWard.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridPACWard,LocDr);
				if (rowIndex > -1){
					var rd =obj.gridPACWard.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			}, false);
			layer.close(layer.index);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	}
	
	// 科室参数设置-添加
	 obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["WardID"] : '');
		var LocDr     = (rd ? rd["ID"] : '');
		var BuildingDr= $.form.GetValue("WardBuilding");
		var Floor     = $.form.GetValue("txtFloor");
		var Area      = $.form.GetValue("txtArea");
		var SubNo     = $.form.GetValue("txtSubNo");
		var AreaColor = $.form.GetValue("txtAreaColor");
	
		if (LocDr== '') {
			layer.alert("科室不允许为空",{icon: 0});
			return;
		}
		if (SubNo== '') {
			layer.alert("分区号不允许为空",{icon: 0});
			return;
		}
		if (BuildingDr== '') {
			layer.alert("病房大楼不允许为空",{icon: 0});
			return;
		}
		if(!/^(-|\+)?[0-9]*$/.test(Floor)){
			layer.alert("楼层必须为数字!");
			return;
		}
		if(!/^(-|\+)?[0-9]*$/.test(SubNo)){
			layer.alert("分区号必须为数字!");
			return;
		}
		var InputStr = ID;
		InputStr += "^" + LocDr;
		InputStr += "^" + BuildingDr;
		InputStr += "^" + Floor;
		InputStr += "^" + Area;
		InputStr += "^" + SubNo;
		InputStr += "^" + AreaColor;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.PACWard","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridPACWard.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridPACWard,LocDr);
				if (rowIndex > -1){
					var rd =obj.gridPACWard.row(rowIndex).data();
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
	
}