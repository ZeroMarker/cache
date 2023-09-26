﻿//页面Event
function InitCCItmWarnWinEvent(obj){
	$.form.iCheckRender(); //单选按钮
	CheckSpecificKey();
     /*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridCCItmWarn').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCCItmWarn.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridCCItmWarn.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridCCItmWarn.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridCCItmWarn.on('dblclick', 'tr', function(e) {
		var rd = obj.gridCCItmWarn.row(this).data();
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
		var selectedRows = obj.gridCCItmWarn.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCCItmWarn.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();

	});

	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridCCItmWarn.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCCItmWarn.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CCItmWarn","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridCCItmWarn.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//暴发预警项目编辑窗体-初始化
	obj.Layer = function(){
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtDesc",rd["Desc"]);
			$.form.SetValue("txtDesc2",rd["Desc2"]);
			$.form.SetValue("txtKeyWords",rd["KeyWords"]);
			$.form.SetValue("txtIndNo",rd["IndNo"]);
			$.form.SetValue("txtArg1",rd["Arg1"]);
			$.form.SetValue("txtArg2",rd["Arg2"]);
			$.form.SetValue("txtArg3",rd["Arg3"]);
			$.form.SetValue("txtArg4",rd["Arg4"]);
			$.form.SetValue("txtArg5",rd["Arg5"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
		
		} else {

			$.form.SetValue("txtDesc",'');
			$.form.SetValue("txtDesc2",'');
			$.form.SetValue("txtKeyWords",'');
			$.form.SetValue("txtIndNo","");
			$.form.SetValue("txtArg1",'');
			$.form.SetValue("txtArg2",'');
			$.form.SetValue("txtArg3",'');
			$.form.SetValue("txtArg4",'');
			$.form.SetValue("txtArg5",'');
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
			title: '暴发预警项目编辑', 
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
	
	
	//暴发预警项目配置窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var Desc      = $.form.GetValue("txtDesc");
		var Desc2     = $.form.GetValue("txtDesc2");
		var KeyWords  = $.form.GetValue("txtKeyWords");
		var IndNo  	  = $.form.GetValue("txtIndNo");
		var Arg1      = $.form.GetValue("txtArg1");
		var Arg2      = $.form.GetValue("txtArg2");
		var Arg3      = $.form.GetValue("txtArg3");
		var Arg4      = $.form.GetValue("txtArg4");
		var Arg5      = $.form.GetValue("txtArg5");
		var IsActive  = $.form.GetValue("chkActive");	
		var ActUserDr = $.LOGON.USERID;
		
		if (Desc == '') {
			layer.alert("暴发预警项目名称不允许为空",{icon: 0});
			return;
		}
		if (Desc2 == '') {
			layer.alert("暴发预警项目名称2不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + Desc;
		InputStr += "^" + Desc2;
		InputStr += "^" + KeyWords;
		InputStr += "^" + IndNo;
		InputStr += "^" + Arg1;
		InputStr += "^" + Arg2;
		InputStr += "^" + Arg3;
		InputStr += "^" + Arg4;
		InputStr += "^" + Arg5;
		InputStr += "^" + IsActive;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + ActUserDr;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CCItmWarn","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCCItmWarn.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCCItmWarn,retval);
				if (rowIndex > -1){
					var rd =obj.gridCCItmWarn.row(rowIndex).data();
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
	
	//暴发预警项目配置窗体-添加
    obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
	    var Desc      = $.form.GetValue("txtDesc");
		var Desc2     = $.form.GetValue("txtDesc2");
		var KeyWords  = $.form.GetValue("txtKeyWords");
		var IndNo  	  = $.form.GetValue("txtIndNo");
		var Arg1      = $.form.GetValue("txtArg1");
		var Arg2      = $.form.GetValue("txtArg2");
		var Arg3      = $.form.GetValue("txtArg3");
		var Arg4      = $.form.GetValue("txtArg4");
		var Arg5      = $.form.GetValue("txtArg5");
		var IsActive  = $.form.GetValue("chkActive");
		var ActUserDr = $.LOGON.USERID;
		
		if (Desc == '') {
			layer.alert("暴发预警项目名称不允许为空",{icon: 0});
			return;
		}
		if (Desc2 == '') {
			layer.alert("暴发预警项目名称2不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + Desc;
		InputStr += "^" + Desc2;
		InputStr += "^" + KeyWords;
		InputStr += "^" + IndNo;
		InputStr += "^" + Arg1;
		InputStr += "^" + Arg2;
		InputStr += "^" + Arg3;
		InputStr += "^" + Arg4;
		InputStr += "^" + Arg5;
		InputStr += "^" + IsActive;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + ActUserDr;
	
	    var retval = $.Tool.RunServerMethod("DHCHAI.IR.CCItmWarn","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCCItmWarn.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCCItmWarn,retval);
				if (rowIndex > -1){
					var rd =obj.gridCCItmWarn.row(rowIndex).data();
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
