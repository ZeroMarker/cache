//页面Event
function InitDictionaryWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridDictionary').DataTable().search($('#search').val(),true,true).draw();
    });
	
    $("#search").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
	        obj.gridDictionary.search(this.value).draw();
        }
    });
    /****************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridDictionary.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled')
	});
	
	obj.gridDictionary.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
	    $("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
   
	});
	
	obj.gridDictionary.on('dblclick', 'tr', function(e) {
		var rd = obj.gridDictionary.row(this).data();
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
		var selectedRows = obj.gridDictionary.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridDictionary.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
		obj.Layer();
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridDictionary.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridDictionary.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.BT.Dictionary","DeleteById",ID);
				if (parseInt(flg)<0){
					if (parseInt(flg)=='-777') {
						layer.msg('-777：当前无删除权限，请启用删除权限后再删除记录!',{icon: 2});
					}else {
						layer.msg('删除失败!',{icon: 2});
					}
				} else {
					obj.gridDictionary.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//字典信息编辑窗体-初始化
	obj.Layer = function(){
		var rd = obj.layer_rd;
		$.form.iCheckRender();
		if (rd){
			$.form.SetValue("txtDicCode",rd["DicCode"]);
			$.form.SetValue("txtDicDesc",rd["DicDesc"]);
			$.form.SetValue("txtIndNo",rd["IndNo"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
		} else {
			$.form.SetValue("txtDicCode",'');
			$.form.SetValue("txtDicDesc",'');
			$.form.SetValue("txtIndNo",'');
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
			title: '字典信息编辑', 
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
	
	
	//字典信息编辑窗体-保存
	 obj.Layer_Save = function(rd){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var DicCode = $.form.GetValue("txtDicCode");
		var DicDesc = $.form.GetValue("txtDicDesc");
		var TypeDr  = $.form.GetValue("ulDicType");
		var IndNo   = $.form.GetValue("txtIndNo");
		var IsActive = $.form.GetValue("chkActive");
		
		var InputStr = ID;
		InputStr += "^" + DicCode;
		InputStr += "^" + DicDesc;
		InputStr += "^" + TypeDr;
		InputStr += "^" + IndNo;
		InputStr += "^" + IsActive;
		
		if (DicCode == '') {
			layer.alert("字典代码不允许为空",{icon: 0});
			return;
		}
		if (DicDesc == '') {
			layer.alert("字典名称不允许为空",{icon: 0});
			return;
		}
		if (TypeDr == '') {
			layer.alert("字典分组不允许为空",{icon: 0});
			return;
		}
		
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.Dictionary","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridDictionary.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridDictionary,retval);
				if (rowIndex > -1){
					var rd =obj.gridDictionary.row(rowIndex).data();
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
	
	//字典信息编辑窗体-添加
	 obj.Layer_Add = function(rd){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
		var DicCode = $.form.GetValue("txtDicCode");
		var DicDesc = $.form.GetValue("txtDicDesc");
		var TypeDr  = $.form.GetValue("ulDicType");
		var IndNo   = $.form.GetValue("txtIndNo");
		var IsActive = $.form.GetValue("chkActive");
		
		if (DicCode == '') {
			layer.alert("字典代码不允许为空",{icon: 0});
			return;
		}
		if (DicDesc == '') {
			layer.alert("字典名称不允许为空",{icon: 0});
			return;
		}
		if (TypeDr == '') {
			layer.alert("字典分组不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + DicCode;
		InputStr += "^" + DicDesc;
		InputStr += "^" + TypeDr;
		InputStr += "^" + IndNo;
		InputStr += "^" + IsActive;
	
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.Dictionary","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridDictionary.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridDictionary,retval);
				if (rowIndex > -1){
					var rd =obj.gridDictionary.row(rowIndex).data();
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