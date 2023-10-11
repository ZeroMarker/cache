//页面Event
function InitConfigWinEvent(obj){
	$.form.iCheckRender();
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridConfig').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridConfig.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridConfig.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridConfig.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridConfig.on('dblclick', 'tr', function(e) {
		var rd = obj.gridConfig.row(this).data();

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
		var selectedRows = obj.gridConfig.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridConfig.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
	    obj.Layer();
	
		
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridConfig.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridConfig.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.BT.Config","DeleteById",ID);
				if (parseInt(flg)<0){
					if (parseInt(flg)=='-777') {
						layer.msg('-777：当前无删除权限，请启用删除权限后再删除记录!',{icon: 2});
					}else {
						layer.msg('删除失败!',{icon: 2});
					}
				} else {
					obj.gridConfig.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
		
	});
	
	//系统参数配置窗体-初始化
	obj.Layer = function(){
		
		$.form.SelectRender('cboHospital');	
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtCode",rd["BTCode"]);
			$.form.SetValue("txtDesc",rd["BTDesc"]);
			$.form.SetValue("txtValue",rd["Value"]);
			$.form.SetValue("cboHospital",rd["HospDr"],rd["HospDesc"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
		} else {
			$.form.SetValue("txtCode",'');
			$.form.SetValue("txtDesc",'');
			$.form.SetValue("txtValue",'');
			$.form.SetValue("cboHospital",'');
			$.form.SetValue("chkActive",'');
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '参数配置编辑', 
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
	
	//系统参数配置窗体-保存
	 obj.Layer_Save = function(){
        var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var Code = $.form.GetValue("txtCode");
		var Desc = $.form.GetValue("txtDesc");
		var Value = $.form.GetValue("txtValue");
		var HospDr = $.form.GetValue("cboHospital");
		var IsActive = $.form.GetValue("chkActive");
		
		if (Code== '') {
			layer.alert("代码不允许为空",{icon: 0});
			return;
		}
		if (Desc== '') {
			layer.alert("描述不允许为空",{icon: 0});
			return;
		}
		if (Value == '') {
			layer.alert("配置值不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + Value;
		InputStr += "^" + HospDr;
		InputStr += "^" + IsActive;
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.Config","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridConfig.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridConfig,retval);
				if (rowIndex > -1){
					var rd =obj.gridConfig.row(rowIndex).data();
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
	
	//系统参数配置窗体-添加
	 obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var Code = $.form.GetValue("txtCode");
		var Desc = $.form.GetValue("txtDesc");
		var Value = $.form.GetValue("txtValue");
		var HospDr = $.form.GetValue("cboHospital");
		var IsActive = $.form.GetValue("chkActive");
		
		if (Code== '') {
			layer.alert("代码不允许为空",{icon: 0});
			return;
		}
		if (Desc== '') {
			layer.alert("描述不允许为空",{icon: 0});
			return;
		}
		if (Value == '') {
			layer.alert("配置值不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + Value;
		InputStr += "^" + HospDr;
		InputStr += "^" + IsActive;
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.Config","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridConfig.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridConfig,retval);
				if (rowIndex > -1){
					var rd =obj.gridConfig.row(rowIndex).data();
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