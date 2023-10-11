//页面Event
function InitOEItmCatWinEvent(obj){
	CheckSpecificKey();
	 /*****搜索功能*****/
    $("#btnsearch_one").on('click', function(){
       $('#gridOEItmCat').DataTable().search($('#search_one').val(),true,true).draw();
       
    });
	
    $("#search_one").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridOEItmCat.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit_one").addClass('disabled');
    $("#btnDelete_one").addClass('disabled');
	obj.gridOEItmCat.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").addClass('disabled');
		$("#btnEdit_one").removeClass('disabled');
		$("#btnDelete_one").removeClass('disabled');
	});
	
	obj.gridOEItmCat.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").removeClass('disabled');
        $("#btnEdit_one").addClass('disabled');
        $("#btnDelete_one").addClass('disabled');
	});
	
	obj.gridOEItmCat.on('dblclick', 'tr', function(e) {
		var rd = obj.gridOEItmCat.row(this).data();
		
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
		var selectedRows = obj.gridOEItmCat.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridOEItmCat.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_one();
	
	});
	
	
	$("#btnDelete_one").on('click', function(){
		var flag = $("#btnDelete_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridOEItmCat.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridOEItmCat.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.DP.OEItmCat","DeleteById",ID);
				if (parseInt(flg)<0){
					if (parseInt(flg)=='-777') {
						layer.msg('-777：当前无删除权限，请启用删除权限后再删除记录!',{icon: 2});
					}else {
						layer.msg('删除失败!',{icon: 2});
					}
				} else {
					obj.gridOEItmCat.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//医嘱分类字典编辑窗体-初始化
	obj.Layer_one = function(){	
		$.form.SelectRender("#cboOEType");  //渲染下拉框
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtBTCode",rd["BTCode"]);
			$.form.SetValue("txtBTDesc",rd["BTDesc"]);
			$.form.SetValue("cboOEType",rd["TypeID"],rd["TypeDesc"]);
		} else {
			$.form.SetValue("txtBTCode",'');
			$.form.SetValue("txtBTDesc",'');
			$.form.SetValue("cboOEType",'');
		}
		
	    layer.config({  
			extend: 'layerskin/style.css' 
		});
	    
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '医嘱分类编辑', 
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
	
	//医嘱分类字典编辑窗体-保存
	obj.LayerOne_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var BTCode = $.form.GetValue("txtBTCode");
		var BTDesc = $.form.GetValue("txtBTDesc");
		var TypeDr  = $.form.GetValue("cboOEType");
		var ErrorStr = "";
		if (BTCode == '') {
			ErrorStr += '分类代码不允许为空!<br/>';	
		}
		if (BTDesc == '') {
			ErrorStr += '分类名称不允许为空!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + BTCode;
		InputStr += "^" + BTDesc;
		InputStr += "^" + TypeDr;
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.OEItmCat","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridOEItmCat.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridOEItmCat,retval);
				if (rowIndex > -1){
					var rd =obj.gridOEItmCat.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('代码重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	
	//医嘱分类字典编辑窗体-添加
	obj.LayerOne_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var BTCode = $.form.GetValue("txtBTCode");
		var BTDesc = $.form.GetValue("txtBTDesc");
		var TypeDr  = $.form.GetValue("cboOEType");
		var ErrorStr = "";
		if (BTCode == '') {
			ErrorStr += '分类代码不允许为空!<br/>';	
		}
		if (BTDesc == '') {
			ErrorStr += '分类名称不允许为空!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + BTCode;
		InputStr += "^" + BTDesc;
		InputStr += "^" + TypeDr;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.OEItmCat","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridOEItmCat.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridOEItmCat,retval);
				if (rowIndex > -1){
					var rd =obj.gridOEItmCat.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('代码重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
    //医嘱类型
	$("#btnsearch_two").on('click', function(){
       $('#gridOEItmType').DataTable().search($('#search_two').val(),true,true).draw();
       
    });
	
    $("#search_two").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridOEItmType.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit_two").addClass('disabled');
    $("#btnDelete_two").addClass('disabled');
	obj.gridOEItmType.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").addClass('disabled');
		$("#btnEdit_two").removeClass('disabled');
		$("#btnDelete_two").removeClass('disabled');
	});
	
	obj.gridOEItmType.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").removeClass('disabled');
        $("#btnEdit_two").addClass('disabled');
        $("#btnDelete_two").addClass('disabled');
	});
	
	obj.gridOEItmType.on('dblclick', 'tr', function(e) {
		var rd = obj.gridOEItmType.row(this).data();
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
		var selectedRows = obj.gridOEItmType.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridOEItmType.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_two();
	
	});

	$("#btnDelete_two").on('click', function(){
		var flag = $("#btnDelete_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridOEItmType.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridOEItmType.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.DP.OEItmType","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridOEItmType.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//医嘱类型编辑窗体-初始化
	obj.Layer_two = function(){
		
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtBTCode2",rd["BTCode"]);
			$.form.SetValue("txtBTDesc2",rd["BTDesc"]);
			
		} else {
			$.form.SetValue("txtBTCode2",'');
			$.form.SetValue("txtBTDesc2",''); 
		}
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	    
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '医嘱类型编辑', 
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
	
	
	//医嘱类型配置窗体-保存
	obj.LayerTwo_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
			                                                                         
		var BTCode   = $.form.GetValue("txtBTCode2");
		var BTDesc  = $.form.GetValue("txtBTDesc2");    		
	
		if (BTCode == '') {
			layer.alert("医嘱类型代码不允许为空",{icon: 0});
			return;
		}
	    if (BTDesc == '') {
			layer.alert("医嘱类型名称不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + BTCode; 
		InputStr += "^" + BTDesc;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.OEItmType","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridOEItmType.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridOEItmType,retval);
				if (rowIndex > -1){
					var rd =obj.gridOEItmType.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('医嘱类型代码不允许修改!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//医嘱类型配置窗体-添加
	obj.LayerTwo_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
		var BTCode  = $.form.GetValue("txtBTCode2");
		var BTDesc  = $.form.GetValue("txtBTDesc2");    		
	
		if (BTCode == '') {
			layer.alert("医嘱类型代码不允许为空",{icon: 0});
			return;
		}
	    if (BTDesc == '') {
			layer.alert("医嘱类型名称不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + BTCode; 
		InputStr += "^" + BTDesc;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.OEItmType","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridOEItmType.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridOEItmType,retval);
				if (rowIndex > -1){
					var rd =obj.gridOEItmType.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('医嘱类型代码重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}

}