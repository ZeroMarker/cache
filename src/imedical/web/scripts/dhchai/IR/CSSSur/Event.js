//页面Event
function InitCSSSurWinEvent(obj){
	
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridCSSSur').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCSSSur.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridCSSSur.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridCSSSur.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridCSSSur.on('dblclick', 'tr', function(e) {
		var rd = obj.gridCSSSur.row(this).data();

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
		var selectedRows = obj.gridCSSSur.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCSSSur.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
	    obj.Layer();
	
		
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridCSSSur.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCSSSur.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.SurveyExec","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridCSSSur.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
		
	});
	
	//系统参数配置窗体-初始化
	obj.Layer = function(){
		
		$.form.SelectRender('cboHospital');	
        var rd = obj.layer_rd;
		if (rd){
			//$.form.SetValue("txtCode",rd["BTCode"]);
			$.form.DateTimeRender("txtSESurvSttDate",rd["SESurvSttDate"]);
			$.form.DateTimeRender("txtSESurvEndDate",rd["SESurvEndDate"]);
			$.form.SetValue("cboHospital",rd["HospDr"],rd["HospDesc"]);
		} else {
			$.form.DateTimeRender("txtSESurvSttDate",$.form.GetCurrDate('-'));  //默认当天
			$.form.DateTimeRender("txtSESurvEndDate","");  //
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '横断面定义编辑', 
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
		
		var SESurvSttDate = $.form.GetValue("txtSESurvSttDate");
		var SESurvEndDate = $.form.GetValue("txtSESurvEndDate");
		var HospDr = $.form.GetValue("cboHospital");
		
		if (SESurvSttDate== '') {
			layer.alert("开始日期不允许为空",{icon: 2});
			return;
		}
		if (SESurvEndDate== '') {
			layer.alert("结束日期不允许为空",{icon: 2});
			return;
		}	
		if (HospDr== '') {
			layer.alert("医院不允许为空",{icon: 2});
			return;
		}	
		if (!$.form.CompareDate(SESurvEndDate,SESurvSttDate)){
    		layer.msg('【结束日期】要在【开始日期】之后.',{icon: 2});
			return;
    	}
		var InputStr = ID;
		InputStr += "^" + HospDr;
		InputStr += "^" + "";
		InputStr += "^" + SESurvSttDate;
		InputStr += "^" + SESurvEndDate;
		InputStr += "^" + $.LOGON.USERID;
		InputStr += "^" + ""
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.SurveyExec","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCSSSur.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCSSSur,retval);
				if (rowIndex > -1){
					var rd =obj.gridCSSSur.row(rowIndex).data();
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
	
	//系统参数配置窗体-添加
	 obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var SESurvSttDate = $.form.GetValue("txtSESurvSttDate");
		var SESurvEndDate = $.form.GetValue("txtSESurvEndDate");
		var HospDr = $.form.GetValue("cboHospital");
		
		if (SESurvSttDate== '') {
			layer.alert("开始日期不允许为空",{icon: 0});
			return;
		}
		if (SESurvEndDate== '') {
			layer.alert("结束日期不允许为空",{icon: 0});
			return;
		}
		if (HospDr== '') {
			layer.alert("医院不允许为空",{icon: 2});
			return;
		}
		if (!$.form.CompareDate(SESurvEndDate,SESurvSttDate)){
    		layer.msg('【结束日期】要在【开始日期】之后.',{icon: 2});
			return;
    	}
		
		var InputStr = ID;
		InputStr += "^" + HospDr;
		InputStr += "^" + "";
		InputStr += "^" + SESurvSttDate;
		InputStr += "^" + SESurvEndDate;
		InputStr += "^" + $.LOGON.USERID;
		InputStr += "^" + ""
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.SurveyExec","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCSSSur.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCSSSur,retval);
				if (rowIndex > -1){
					var rd =obj.gridCSSSur.row(rowIndex).data();
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