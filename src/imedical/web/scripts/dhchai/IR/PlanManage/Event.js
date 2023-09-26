//页面Event
function InitPlanManageWinEvent(obj){
	CheckSpecificKey();
	$.form.iCheckRender();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridPlanManage').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridPlanManage.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridPlanManage.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridPlanManage.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridPlanManage.on('dblclick', 'tr', function(e) {
		var rd = obj.gridPlanManage.row(this).data();
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
		var selectedRows = obj.gridPlanManage.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridPlanManage.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
	    obj.Layer();
	
		
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridPlanManage.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridPlanManage.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.PlanManage","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridPlanManage.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
		
	});
	
	//短语分类窗体-初始化
	obj.Layer = function(){
		$.form.SelectRender('cboPlanType');	
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtPlanName",rd["IRPlanName"]);
			$.form.SetValue("txtKeys",rd["IRKeys"]);
			$.form.SetValue("txtContent",rd["IRContent"]);
			$.form.SetValue("chkActive",rd["IRIsActive"]== 1);
			$.form.SetValue("cboPlanType",rd["PlanTypeDr"],rd["PlanTypeDesc"]);
		} else {
			$.form.SetValue("txtPlanName",'');
			$.form.SetValue("txtKeys",'');
			$.form.SetValue("txtContent",'');
			$.form.SetValue("cboPlanType",'');
			$.form.SetValue("chkActive",'');
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: ['900px','500px'],
			skin: 'layer-class',
			title: 'SOP预案编辑', 
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
	
	//短语分类窗体-保存
	 obj.Layer_Save = function(){
        var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var PlanName   = $.form.GetValue("txtPlanName");
		var PlanTypeDr = $.form.GetValue("cboPlanType");
		var Keys       = $.form.GetValue("txtKeys");
		var Content    = $.form.GetValue("txtContent");
		var chkActive  = $.form.GetValue("chkActive");
		
		if (PlanName== '') {
			layer.alert("预案名不允许为空",{icon: 0});
			return;
		}
		if (PlanTypeDr== '') {
			layer.alert("预案类型不允许为空",{icon: 0});
			return;
		}
		if (Keys == '') {
			layer.alert("关键词不允许为空",{icon: 0});
			return;
		}
		Keys = Keys.replace(/\ +/g,"");        // 去除空格
		Keys = Keys.replace(/[\r\n]/g,"");     // 去除换行符
		if (Content == '') {
			layer.alert("内容不允许为空",{icon: 0});
			return;
		}
		Content = Content.replace(/\ +/g,"");    // 去除空格
		Content = Content.replace(/[\r\n]/g,""); // 去除换行符
		var InputStr = ID;
		InputStr += "^" + PlanName;
		InputStr += "^" + PlanTypeDr;
		InputStr += "^" + Keys;
		InputStr += "^" + Content;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID;
		InputStr += "^" + chkActive;
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.PlanManage","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridPlanManage.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridPlanManage,retval);
				if (rowIndex > -1){
					var rd =obj.gridPlanManage.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('预案名重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//短语分类窗体-添加
	 obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var PlanName   = $.form.GetValue("txtPlanName");
		var PlanTypeDr = $.form.GetValue("cboPlanType");
		var Keys       = $.form.GetValue("txtKeys");
		var Content    = $.form.GetValue("txtContent");
		var chkActive  = $.form.GetValue("chkActive");
		
		if (PlanName== '') {
			layer.alert("预案名不允许为空",{icon: 0});
			return;
		}
		if (PlanTypeDr== '') {
			layer.alert("预案类型不允许为空",{icon: 0});
			return;
		}
		if (Keys == '') {
			layer.alert("关键词不允许为空",{icon: 0});
			return;
		}
		if (Content == '') {
			layer.alert("内容不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + PlanName;
		InputStr += "^" + PlanTypeDr;
		InputStr += "^" + Keys;
		InputStr += "^" + Content;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID;
		InputStr += "^" + chkActive;
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.PlanManage","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridPlanManage.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridPlanManage,retval);
				if (rowIndex > -1){
					var rd =obj.gridPlanManage.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('预案名重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
}
