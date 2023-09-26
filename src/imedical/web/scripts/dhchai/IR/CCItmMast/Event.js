﻿//页面Event
function InitCCItmMastWinEvent(obj){
	$.form.iCheckRender(); //单选按钮
	CheckSpecificKey();
     /*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridCCItmMast').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCCItmMast.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridCCItmMast.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridCCItmMast.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridCCItmMast.on('dblclick', 'tr', function(e) {
		var rd = obj.gridCCItmMast.row(this).data();
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
		var selectedRows = obj.gridCCItmMast.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCCItmMast.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();

	});

	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridCCItmMast.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCCItmMast.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CCItmMast","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridCCItmMast.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//监控项目信息编辑窗体-初始化
	obj.Layer = function(){
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtCode",rd["Code"]);
			$.form.SetValue("txtDesc",rd["Desc"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
		
		} else {
			$.form.SetValue("txtCode",'');
			$.form.SetValue("txtDesc",'');
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
			title: '监控项目配置编辑', 
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
	
	
	//监控项目信息配置窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var Code = $.form.GetValue("txtCode");
		var Desc = $.form.GetValue("txtDesc");
		var IsActive = $.form.GetValue("chkActive");
		var ActUserDr = $.LOGON.USERID;
		
		if (Code == '') {
			layer.alert("监控项目代码不允许为空",{icon: 0});
			return;
		}
		if (Desc == '') {
			layer.alert("监控项目名称不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + IsActive;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + ActUserDr;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CCItmMast","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCCItmMast.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCCItmMast,retval);
				if (rowIndex > -1){
					var rd =obj.gridCCItmMast.row(rowIndex).data();
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
	
	//监控项目信息配置窗体-添加
    obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
	    var Code = $.form.GetValue("txtCode");
		var Desc = $.form.GetValue("txtDesc");
		var IsActive = $.form.GetValue("chkActive");
		var ActUserDr = $.LOGON.USERID;
		
		if (Code == '') {
			layer.alert("监控项目代码不允许为空",{icon: 0});
			return;
		}
		if (Desc == '') {
			layer.alert("监控项目名称不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Code;
		InputStr += "^" + Desc;
		InputStr += "^" + IsActive;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + ActUserDr;
	    var retval = $.Tool.RunServerMethod("DHCHAI.IR.CCItmMast","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCCItmMast.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCCItmMast,retval);
				if (rowIndex > -1){
					var rd =obj.gridCCItmMast.row(rowIndex).data();
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