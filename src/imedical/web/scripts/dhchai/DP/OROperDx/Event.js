//页面Event
function InitOROperDxWinEvent(obj){
	CheckSpecificKey();
	 /*****搜索功能*****/
    $("#btnsearch_one").on('click', function(){
       $('#gridOROperDx').DataTable().search($('#search_one').val(),true,true).draw();
       
    });
	
    $("#search_one").keyup(function(event){
	   if ((event.keyCode == 13)||(this.value=="")) {
	   	obj.gridOROperDx.search(this.value).draw();
	   }
    });
   /**********************/
    $("#btnEdit_one").addClass('disabled');
    $("#btnDelete_one").addClass('disabled');
    obj.gridOROperDx.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").addClass('disabled');
		$("#btnEdit_one").removeClass('disabled');
		$("#btnDelete_one").removeClass('disabled');
	});
	
	obj.gridOROperDx.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").removeClass('disabled');
        $("#btnEdit_one").addClass('disabled');
        $("#btnDelete_one").addClass('disabled');
	});
	
	obj.gridOROperDx.on('dblclick', 'tr', function(e) {
		var rd = obj.gridOROperDx.row(this).data();
		
		obj.layer_rd = rd;
		obj.Layer_one();
	    
	});
	
	$("#btnAdd_one").on('click', function(){
		var flag = $("#btnAdd_one").hasClass("disabled");
		if(flag) return ;	
		obj.layer_rd = '';
		obj.Layer_one();
		
	});
	
	$("#btnEdit_one").on('click', function(){
		var flag = $("#btnEdit_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridOROperDx.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridOROperDx.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_one();
		
	});
	
	$("#btnDelete_one").on('click', function(){
		var flag = $("#btnDelete_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridOROperDx.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridOROperDx.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.DP.OROperDx","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridOROperDx.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//信息编辑窗体-初始化
	obj.Layer_one = function(){
		$.form.iCheckRender();
		$.form.SelectRender('cboBTOperIncDr');
		
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtBTOperCode",rd["BTOperCode"]);
			$.form.SetValue("txtBTOperDesc",rd["BTOperDesc"]);
			$.form.SetValue("cboBTOperIncDr",rd["BTOperIncDr"],rd["BTMapOperDesc"]);
			$.form.SetValue("chkActive",rd["BTIsActive"]== 1);
		} else {
			$.form.SetValue("txtBTOperCode",'');
			$.form.SetValue("txtBTOperDesc",'');
			$.form.SetValue("cboBTOperIncDr",'');
			$.form.SetValue("chkActive",true);
		}
		layer.config({  
			extend: 'layerskin/style.css' 
		});
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '手术分类编辑', 
			content: $('#layer_one'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.LayerOne_Add();
			},
			btn2: function(index, layero){
				obj.LayerOne_Save();
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
	
	//手术分类信息编辑窗体-保存
	obj.LayerOne_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var BTCode = $.form.GetValue("txtBTOperCode");
		var BTDesc = $.form.GetValue("txtBTOperDesc");
		var BTOperIncDr = $.form.GetValue("cboBTOperIncDr");
		var IsActive = $.form.GetValue("chkActive");
		
		var InputStr = ID;
		InputStr += "^" + BTCode;
		InputStr += "^" + BTDesc;
		InputStr += "^" + BTOperIncDr;
		InputStr += "^" + IsActive;
		
		var ErrorStr = "";
		if (BTCode == '') {
			ErrorStr += '手术编码不允许为空!<br/>';
		}
		if (BTDesc == '') {
			ErrorStr += '手术名称不允许为空!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.OROperDx","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridOROperDx.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridOROperDx,retval);
				if (rowIndex > -1){
					var rd =obj.gridOROperDx.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('代码、名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//手术分类信息编辑窗体-添加
	obj.LayerOne_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var BTCode = $.form.GetValue("txtBTOperCode");
		var BTDesc = $.form.GetValue("txtBTOperDesc");
		var BTOperIncDr = $.form.GetValue("cboBTOperIncDr");
		var IsActive = $.form.GetValue("chkActive");
		
		var InputStr = ID;
		InputStr += "^" + BTCode;
		InputStr += "^" + BTDesc;
		InputStr += "^" + BTOperIncDr;
		InputStr += "^" + IsActive;
		
		var ErrorStr = "";
		if (BTCode == '') {
			ErrorStr += '手术编码不允许为空!<br/>';
		}
		if (BTDesc == '') {
			ErrorStr += '手术名称不允许为空!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.OROperDx","Update",InputStr);
	
		if (parseInt(retval)>0){
			obj.gridOROperDx.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridOROperDx,retval);
				if (rowIndex > -1){
					var rd =obj.gridOROperDx.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('代码、名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	/****
	*    第二个grid 
	*
	***/
	 /*****搜索功能*****/
    $("#btnsearch_two").on('click', function(){
       $('#gridOROperDxMap').DataTable().search($('#search_two').val(),true,true).draw();
       
    });
	
    $("#search_two").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
	   		obj.gridOROperDxMap.search(this.value).draw();
	    }
    });
    /**********************/
	obj.gridOROperDxMap.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").removeClass('disabled');
		$("#btnEdit_two").removeClass('disabled');
		$("#btnDelete_two").removeClass('disabled');
	});
	
	obj.gridOROperDxMap.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").addClass('disabled');
        $("#btnEdit_two").addClass('disabled');
        $("#btnDelete_two").addClass('disabled');
	});
	
	obj.gridOROperDxMap.on('dblclick', 'tr', function(e) {
		var rd = obj.gridOROperDxMap.row(this).data();
		
		obj.layer_rd = rd;
		obj.Layer_two();
	    
	});
	
	$("#btnAll").on('click', function(){	
		flg = "";
	 	obj.gridOROperDxMap.ajax.reload($('#gridOROperDxMap').DataTable().search($('#search_two').val(),true,true).draw());
	});
	$("#btnPend").on('click', function(){	
		flg = 0;
	 	obj.gridOROperDxMap.ajax.reload($('#gridOROperDxMap').DataTable().search($('#search_two').val(),true,true).draw());
	});
	$("#btnFin").on('click', function(){
		flg = 1;
	 	obj.gridOROperDxMap.ajax.reload($('#gridOROperDxMap').DataTable().search($('#search_two').val(),true,true).draw());
	});
	$("#btnSyn").on('click', function(){
		var retval = $.Tool.RunServerMethod("DHCHAI.DPS.OROperDxMapSrv","SynMapRule","手术项目");
		if (parseInt(retval)>0){
			layer.msg('成功匹配'+retval+'条!',{icon: 1});
		} else {
			layer.msg('没有可匹配项或匹配失败!',{icon: 2});
		}
		obj.gridOROperDxMap.ajax.reload();
	
	});
    	
    $("#btnAdd_two").on('click', function(){
		var flag = $("#btnAdd_two").hasClass("disabled");
		if(flag) return ;
        var Maprd  = obj.gridOROperDxMap.rows({selected: true}).data().toArray()[0];	
		var OperDxrd = obj.gridOROperDx.rows({selected: true}).data().toArray()[0];
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var OperDxID = (OperDxrd ? OperDxrd["ID"] : '');
		
		if ((MapID == "")||(OperDxID == "")) {
			layer.msg('设置对照关系需同时选择手术项目字典及对照项目!',{icon: 2});
		}else {
			var ActUser = $.LOGON.USERDESC;
			var retval = $.Tool.RunServerMethod("DHCHAI.DPS.OROperDxMapSrv","UpdateMap",MapID,OperDxID,ActUser);
			if (parseInt(retval)>0){
				obj.gridOROperDxMap.ajax.reload(function(){
					var rowIndex = $.Tool.GetTableRowIndex(obj.gridOROperDxMap,retval);
					if (rowIndex > -1){
						var rd =obj.gridOROperDxMap.row(rowIndex).data();
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
	
	$("#btnEdit_two").on('click', function(){
		var flag = $("#btnEdit_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridOROperDxMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridOROperDxMap.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_two();
	
	});

					
	$("#btnDelete_two").on('click', function(){
		var flag = $("#btnDelete_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridOROperDxMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridOROperDxMap.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		 if (rd["BTMapOperDr"]=="") {
			layer.msg('没有对照关系，不可撤销!',{icon: 0});
		}else {
			layer.confirm( '确认是否撤销对照关系?', {
				btn: ['确认','取消'],    //btn位置对应function的位置
				btnAlign: 'c'
				},
				function(){ 
					var flg = $.Tool.RunServerMethod("DHCHAI.DP.OROperDxMap","DeleteMapById",ID);
					if (parseInt(flg)>0){
						obj.gridOROperDxMap.ajax.reload(function(){
							var rowIndex = $.Tool.GetTableRowIndex(obj.gridOROperDxMap,flg);
							if (rowIndex > -1){
								var rd =obj.gridOROperDxMap.row(rowIndex).data();
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
	//编辑窗体-初始化
	obj.Layer_two = function(){	
		$.form.iCheckRender();
		var rd = obj.layer_rd;  
		if (rd){
			$.form.SetValue("txtMapNote",rd["BTMapNote"]);
			$.form.SetValue("chkMapActive",rd["BTIsActive"]== 1);
		} else {
			$.form.SetValue("txtMapNote",'');
			$.form.SetValue("chkMapActive",'');
		}
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '手术对照项目编辑', 
			content: $('#layer_two'),
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.LayerTwo_Save();
			  	layer.close(index); //关闭
			}
			
		}); 	
	}
	//手术对照编辑窗体-保存
	obj.LayerTwo_Save = function(){
		
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var OperDesc = rd["BTOperDesc"];
		var MapOperDr = rd["BTMapOperDr"];
		var MapNote  = $.form.GetValue("txtMapNote");
		var MapSCode = rd["BTSCode"];
		var IsActive = $.form.GetValue("chkMapActive");
		var ActUser = $.LOGON.USERDESC;
		
		var InputStr = ID;
		InputStr += "^" + OperDesc;
		InputStr += "^" + MapOperDr;  
		InputStr += "^" + MapNote;  
		InputStr += "^" + MapSCode;
		InputStr += "^" + IsActive;
		InputStr += "^";
		InputStr += "^";
		InputStr += "^" + ActUser;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.OROperDxMap","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridOROperDxMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridOROperDxMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridOROperDxMap.row(rowIndex).data();
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
