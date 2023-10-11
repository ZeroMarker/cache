//页面Event
function InitKeyWordWinEvent(obj){
	CheckSpecificKey();
     /*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridKeyWord').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridKeyWord.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridKeyWord.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridKeyWord.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridKeyWord.on('dblclick', 'tr', function(e) {
		var rd = obj.gridKeyWord.row(this).data();
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
		var selectedRows = obj.gridKeyWord.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridKeyWord.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();

	});

	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridKeyWord.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridKeyWord.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CCKeyWord","DeleteById",ID);
				if (parseInt(flg)<0){
					if (parseInt(flg)=='-777') {
						layer.msg('关键词-777：当前无删除权限，请启用删除权限后再删除记录!',{icon: 2});
					}else {
						layer.msg('删除失败!',{icon: 2});
					}
				} else {
					obj.gridKeyWord.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//关键词信息编辑窗体-初始化
	obj.Layer = function(){
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtDesc",rd["Desc"]);
			$.form.SetValue("txtNote",rd["Note"]);
			
		} else {
			$.form.SetValue("txtDesc",'');
			$.form.SetValue("txtNote",'');
		}
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '关键词配置编辑', 
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
	
	
	//关键词信息配置窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var Desc = $.form.GetValue("txtDesc");
		var Note = $.form.GetValue("txtNote");

		if (Desc == '') {
			layer.alert("关键词名称不允许为空",{icon: 0});
			return;
		}
		if (Note == '') {
			layer.alert("关键词说明不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + Desc;
		InputStr += "^" + Note;
	
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CCKeyWord","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridKeyWord.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridKeyWord,retval);
				if (rowIndex > -1){
					var rd =obj.gridKeyWord.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//关键词信息配置窗体-添加
    obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
	    var Desc = $.form.GetValue("txtDesc");
		var Note = $.form.GetValue("txtNote");

		if (Desc == '') {
			layer.alert("关键词名称不允许为空",{icon: 0});
			return;
		}
		if (Note == '') {
			layer.alert("关键词说明不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + Desc;
		InputStr += "^" + Note;
	
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CCKeyWord","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridKeyWord.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridKeyWord,retval);
				if (rowIndex > -1){
					var rd =obj.gridKeyWord.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
}
