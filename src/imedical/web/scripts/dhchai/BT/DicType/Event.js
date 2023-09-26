//页面Event
function InitDicTypeWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridDicType').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridDicType.search(this.value).draw();
        }
    });
    /****************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridDicType.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridDicType.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
        $("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
   
	});
	
	obj.gridDicType.on('dblclick', 'tr', function(e) {
		var rd = obj.gridDicType.row(this).data();	
		obj.layer_rd = rd;
		obj.Layer();
	});
	
	$("#btnAdd").on('click', function(){
		var flag = $("#btnAdd").hasClass("disabled");
		if(flag) return ;
		obj.layer_rd = '';
		obj.Layer();
	});
	
	$("#btnEdit").on('click', function(){
		var flag = $("#btnEdit").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridDicType.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;	
		var rd = obj.gridDicType.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
		obj.Layer();
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridDicType.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridDicType.rows({selected: true}).data().toArray()[0];

		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.BT.DicType","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridDicType.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});

	//字典分组编辑窗体-初始化
	obj.Layer = function(){
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtCode",rd["Code"]);
			$.form.SetValue("txtDesc",rd["Desc"]);
		} else {
			$.form.SetValue("txtCode",'');
			$.form.SetValue("txtDesc",'');
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '字典类型编辑', 
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
	
	//字典分组编辑窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var Code = $.form.GetValue("txtCode");
		var Desc = $.form.GetValue("txtDesc");
		
		if (Code == '') {
			layer.alert('字典类型代码不允许为空',{icon: 0});
			return;
		}
		if (Desc == '') {
			layer.alert('字典类型名称不允许为空',{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.DicType","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridDicType.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridDicType,retval);
				if (rowIndex > -1){
					var rd =obj.gridDicType.row(rowIndex).data();
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
	
	//字典分组编辑窗体-添加
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var Code = $.form.GetValue("txtCode");
		var Desc = $.form.GetValue("txtDesc");
		
		if (Code == '') {
			layer.alert('字典类型代码不允许为空',{icon: 0});
			return;
		}
		if (Desc == '') {
			layer.alert('字典类型名称不允许为空',{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.DicType","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridDicType.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridDicType,retval);
				if (rowIndex > -1){
					var rd =obj.gridDicType.row(rowIndex).data();
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
}

