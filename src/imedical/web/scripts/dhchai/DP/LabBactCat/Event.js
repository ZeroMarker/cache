//页面Event
function InitLabBactCatWinEvent(obj){
	CheckSpecificKey();
    /*****搜索功能*****/
    $("#btnsearch_one").on('click', function(){
       $('#gridLabBactCat').DataTable().search($('#search_one').val(),true,true).draw();
       
    });
	
    $("#search_one").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridLabBactCat.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit_one").addClass('disabled');
    $("#btnDelete_one").addClass('disabled');
	obj.gridLabBactCat.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").addClass('disabled');
		$("#btnEdit_one").removeClass('disabled');
		$("#btnDelete_one").removeClass('disabled');
	});
	
	obj.gridLabBactCat.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").removeClass('disabled');
        $("#btnEdit_one").addClass('disabled');
        $("#btnDelete_one").addClass('disabled');
	});
	
	obj.gridLabBactCat.on('dblclick', 'tr', function(e) {
		var rd = obj.gridLabBactCat.row(this).data();
		obj.layer_rd = rd;
		obj.Layer_one();
	    
	});
	
	$("#btnAdd_one").on('click', function(){
		var flag = $("#btnAdd").hasClass("disabled");
		if(flag) return ;	
		obj.layer_rd = '';
		obj.Layer_one();
		
	});
	
	$("#btnEdit_one").on('click', function(){
		var flag = $("#btnEdit_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLabBactCat.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabBactCat.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_one();
	
	});

	$("#btnDelete_one").on('click', function(){
		var flag = $("#btnDelete_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLabBactCat.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabBactCat.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.DP.LabBactCat","DeleteById",ID);
				if (parseInt(flg)<0){
					if (parseInt(flg)=='-777') {
						layer.msg('-777：当前无删除权限，请启用删除权限后再删除记录!',{icon: 2});
					}else {
						layer.msg('删除失败!',{icon: 2});
					}
				} else {
					obj.gridLabBactCat.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//细菌分类编辑窗体-初始化
	obj.Layer_one = function(){
		
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtBCCode",rd["BCCode"]);
			$.form.SetValue("txtBCDesc",rd["BCDesc"]);
			
		} else {
			$.form.SetValue("txtBCCode",'');
			$.form.SetValue("txtBCDesc",''); 
		}
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	    
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '细菌分类编辑', 
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
	
	
	//细菌分类配置窗体-保存
	obj.LayerOne_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
			                                                                         
		var BCCode   = $.form.GetValue("txtBCCode");
		var BCDesc  = $.form.GetValue("txtBCDesc");    		
	
		if (BCCode == '') {
			layer.alert("细菌分类代码不允许为空",{icon: 0});
			return;
		}
	    if (BCDesc == '') {
			layer.alert("细菌分类名称不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + BCCode; 
		InputStr += "^" + BCDesc;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabBactCat","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLabBactCat.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabBactCat,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabBactCat.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('细菌分类代码不允许修改!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//细菌分类配置窗体-添加
	obj.LayerOne_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
		var BCCode   = $.form.GetValue("txtBCCode");
		var BCDesc  = $.form.GetValue("txtBCDesc");    		
	
		if (BCCode == '') {
			layer.alert("细菌分类代码不允许为空",{icon: 0});
			return;
		}
	    if (BCDesc == '') {
			layer.alert("细菌分类名称不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + BCCode; 
		InputStr += "^" + BCDesc;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabBactCat","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLabBactCat.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabBactCat,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabBactCat.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('细菌分类代码重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//细菌类型
	$("#btnsearch_two").on('click', function(){
	   //"+"特殊，按钮搜索报错Invalid regular expression: /^(?=.*?+).*$/: Nothing to repeat
	   obj.gridLabBactType.search($('#search_two').val()).draw();
       //$('#gridLabBactType').DataTable().search($('#search_two').val(),true,true).draw(); 
       
    });
	
    $("#search_two").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridLabBactType.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit_two").addClass('disabled');
    $("#btnDelete_two").addClass('disabled');
	obj.gridLabBactType.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").addClass('disabled');
		$("#btnEdit_two").removeClass('disabled');
		$("#btnDelete_two").removeClass('disabled');
	});
	
	obj.gridLabBactType.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").removeClass('disabled');
        $("#btnEdit_two").addClass('disabled');
        $("#btnDelete_two").addClass('disabled');
	});
	
	obj.gridLabBactType.on('dblclick', 'tr', function(e) {
		var rd = obj.gridLabBactType.row(this).data();
		obj.layer_rd = rd;
		obj.Layer_two();
	    
	});
	
	$("#btnAdd_two").on('click', function(){
		var flag = $("#btnAdd_two").hasClass("disabled");
		if(flag) return ;	
		obj.layer_rd = '';
		obj.Layer_two();
		
	});
	
	$("#btnEdit_two").on('click', function(){
		var flag = $("#btnEdit_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLabBactType.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabBactType.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_two();
	
	});

	$("#btnDelete_two").on('click', function(){
		var flag = $("#btnDelete_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLabBactType.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabBactType.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.DP.LabBactType","DeleteById",ID);
				if (parseInt(flg)<0){
					if (parseInt(flg)=='-777') {
						layer.msg('-777：当前无删除权限，请启用删除权限后再删除记录!',{icon: 2});
					}else {
						layer.msg('删除失败!',{icon: 2});
					}
				} else {
					obj.gridLabBactType.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//细菌类型编辑窗体-初始化
	obj.Layer_two = function(){
		
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtBCCode2",rd["BCCode"]);
			$.form.SetValue("txtBCDesc2",rd["BCDesc"]);
			
		} else {
			$.form.SetValue("txtBCCode2",'');
			$.form.SetValue("txtBCDesc2",''); 
		}
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	    
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '细菌类型编辑', 
			content: $('#layer_two'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.LayerTwo_Add();
			},
			btn2: function(index, layero){
				obj.LayerTwo_Save();
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
	
	
	//细菌类型配置窗体-保存
	obj.LayerTwo_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
			                                                                         
		var BCCode   = $.form.GetValue("txtBCCode2");
		var BCDesc  = $.form.GetValue("txtBCDesc2");    		
	
		if (BCCode == '') {
			layer.alert("细菌类型代码不允许为空",{icon: 0});
			return;
		}
	    if (BCDesc == '') {
			layer.alert("细菌类型名称不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + BCCode; 
		InputStr += "^" + BCDesc;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabBactType","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLabBactType.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabBactType,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabBactType.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('细菌类型代码不允许修改!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//细菌类型配置窗体-添加
	obj.LayerTwo_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
		var BCCode   = $.form.GetValue("txtBCCode2");
		var BCDesc  = $.form.GetValue("txtBCDesc2");    		
	
		if (BCCode == '') {
			layer.alert("细菌类型代码不允许为空",{icon: 0});
			return;
		}
	    if (BCDesc == '') {
			layer.alert("细菌类型名称不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + BCCode; 
		InputStr += "^" + BCDesc;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabBactType","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLabBactType.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabBactType,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabBactType.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('细菌类型代码重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
}
