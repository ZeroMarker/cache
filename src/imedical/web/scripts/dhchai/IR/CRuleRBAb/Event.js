//页面Event
function InitCRuleRBAbWinEvent(obj){
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	/*****搜索功能*****/
	$.form.SelectRender("cboRBCodeDr");  //渲染下拉框
    $("#btnsearch").on('click', function(){
       $('#gridCRuleRBAb').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleRBAb.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridCRuleRBAb.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
		obj.gridCRuleRBCode.ajax.reload(function(){
			$("#btnAdd_two").removeClass('disabled');
		});
	});
	
	obj.gridCRuleRBAb.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
        obj.gridCRuleRBCode.ajax.reload(function(){
			$("#btnAdd_two").addClass('disabled');
		});
	});
	
	obj.gridCRuleRBAb.on('dblclick', 'tr', function(e) {
		var rd = obj.gridCRuleRBAb.row(this).data();
		
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
		var selectedRows = obj.gridCRuleRBAb.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleRBAb.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();
	
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridCRuleRBAb.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleRBAb.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleRBAb","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridCRuleRBAb.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//影像学筛查标准编辑窗体-初始化
	obj.Layer = function(){
		$.form.iCheckRender();
		$.form.SelectRender("#layer");  //渲染下拉框

		var rd = obj.layer_rd;
		
		if (rd){
			$.form.SetValue("txtRBCode",rd["RBCode"]);
			$.form.SetValue("txtRBPos",rd["RBPos"]);
			$.form.SetValue("txtRBNote",rd["RBNote"]);
			$.form.SetValue("chkRBCFlag",rd["RBCFlag"]== 1);
		} else {
			$.form.SetValue("txtRBCode",'');   
			$.form.SetValue("txtRBPos",''); 
			$.form.SetValue("txtRBNote",''); 
			$.form.SetValue("chkRBCFlag",'');  
		}
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '影像学筛查编辑', 
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
	
	//影像学筛查标准窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var RBCode   = $.form.GetValue("txtRBCode");
		var RBPos    = $.form.GetValue("txtRBPos");
		var RBNote   = $.form.GetValue("txtRBNote");
		var RBCFlag  = $.form.GetValue("chkRBCFlag");
		
		var InputStr = ID;
		InputStr += "^" + RBCode;      // 检查项目
		InputStr += "^" + RBPos;       // 检查部位
		InputStr += "^" + RBNote;      // 说明
		InputStr += "^" + RBCFlag;     // 筛查标志
		
		if (RBCode == '') {
			layer.alert("检查项目不允许为空",{icon: 0});
			return;
		}
		if (RBPos == '') {
		    layer.alert("检查部位不允许为空", { icon: 0 });
			return;
		}
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleRBAb","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleRBAb.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleRBAb,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleRBAb.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.msg('检查项目重复，保存失败!',{icon: 0});
			}else{
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//影像学筛查标准窗体-添加
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var RBCode   = $.form.GetValue("txtRBCode");
		var RBPos    = $.form.GetValue("txtRBPos");
		var RBNote   = $.form.GetValue("txtRBNote");
		var RBCFlag  = $.form.GetValue("chkRBCFlag");
		
		var InputStr = ID;
		InputStr += "^" + RBCode;      // 检查项目
		InputStr += "^" + RBPos;       // 检查部位
		InputStr += "^" + RBNote;      // 说明
		InputStr += "^" + RBCFlag;     // 筛查标志
		
		if (RBCode == '') {
			layer.alert("检查项目不允许为空",{icon: 0});
			return;
		}
		if (RBPos == '') {
		    layer.alert("检查部位不允许为空", { icon: 0 });
			return;
		}
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleRBAb","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleRBAb.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleRBAb,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleRBAb.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.msg('检查项目重复，保存失败!',{icon: 0});
			}else{
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	// --------------------------影像学筛查-检查项目维护-----------------------------------
	$("#btnsearch_two").on('click', function(){
		$('#gridCRuleRBCode').DataTable().search($('#search_two').val(),true,true).draw();
    });
	
    $("#search_two").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleRBCode.search(this.value).draw();
        }
    });
    
    $("#btnAdd_two").addClass('disabled');
    $("#btnEdit_two").addClass('disabled');
    $("#btnDelete_two").addClass('disabled');
	obj.gridCRuleRBCode.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").addClass('disabled');
		$("#btnEdit_two").removeClass('disabled');
		$("#btnDelete_two").removeClass('disabled');
	});

	obj.gridCRuleRBCode.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").removeClass('disabled');
        $("#btnEdit_two").addClass('disabled');
        $("#btnDelete_two").addClass('disabled');
	});
	
	obj.gridCRuleRBCode.on('dblclick', 'tr', function(e) {
		var selectedRows = obj.gridCRuleRBAb.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.alert('请先选择影像学项目，再添加数据!',{icon: 0});
			return;
		}	
		var rd = obj.gridCRuleRBCode.row(this).data();
		obj.Codelayer_rd = rd;
		obj.Layer_two();
	    
	});
	
	$("#btnAdd_two").on('click', function(){
		var flag = $("#btnAdd_two").hasClass("disabled");
		if(flag) return ;	
		obj.Codelayer_rd = '';
		obj.Layer_two();
		
	});
	
	$("#btnEdit_two").on('click', function(){
		var flag = $("#btnEdit_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridCRuleRBCode.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridCRuleRBCode.rows({selected: true}).data().toArray()[0];
		
		obj.Codelayer_rd = rd;
	    obj.Layer_two();
	
	});

	$("#btnDelete_two").on('click', function(){
		var flag = $("#btnDelete_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridCRuleRBCode.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridCRuleRBCode.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleRBCode","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					 obj.gridCRuleRBCode.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});

  
	//影像学筛查-检查项目-初始化
	obj.Layer_two = function(){	
        var rd = obj.Codelayer_rd;
		if (rd){
			$.form.SetValue("cboRBCodeDr",rd["RBCodeDr"],rd["RBCode"]); 
		} else {
			$.form.SetValue("cboRBCodeDr",''); 
		}
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '检查项目编辑', 
			content: $('#layer_two'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.Layertwo_Add();
			},
			btn2: function(index, layero){
				obj.Layertwo_Save();
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
	
	//影像学筛查-检查项目-保存
	obj.Layertwo_Save = function(){
		var rd = obj.gridCRuleRBAb.rows({selected: true}).data().toArray()[0]; // 影像学筛查
		var RBAbID = (rd ? rd["ID"] : ''); // 影像学筛查ID
		var rdKey = obj.Codelayer_rd;
		var ID = (rdKey ? rdKey["ID"] : '');
		if (ID.indexOf("||")>-1) {
			var SubID=ID.split('||')[1];
		} else {
			var SubID='';
		}
		
		var RBCodeDr = $.form.GetValue("cboRBCodeDr");

		var ErrorStr = "";
		if (RBCodeDr == '') {
			ErrorStr += '检查项目不允许为空!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 2});
			return;
		}
		
		var InputStr = RBAbID;              // 父表ID
		InputStr += "^" + SubID;            // 子表ID
		InputStr += "^" + RBCodeDr;         // 检验项目
		InputStr += "^" + '';               // 更新日期
		InputStr += "^" + '';               // 更新时间
		InputStr += "^" + $.LOGON.USERID;   // 更新人
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleRBCode","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleRBCode.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleRBCode,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleRBCode.row(rowIndex).data();
					obj.Codelayer_rd = rd;
				} else {
					obj.Codelayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('检查项目重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//影像学筛查-关键词-添加
	obj.Layertwo_Add = function(){
		var rd = obj.gridCRuleRBAb.rows({selected: true}).data().toArray()[0]; // 影像学筛查
		var RBAbID = (rd ? rd["ID"] : ''); // 影像学筛查ID
		var rdKey = obj.Codelayer_rd;
		var ID = (rdKey ? rdKey["ID"] : '');
		if (ID.indexOf("||")>-1) {
			var SubID=ID.split('||')[1];
		} else {
			var SubID='';
		}
		
		var RBCodeDr = $.form.GetValue("cboRBCodeDr");

		var ErrorStr = "";
		if (RBCodeDr == '') {
			ErrorStr += '检查项目不允许为空!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 2});
			return;
		}
		
		var InputStr = RBAbID;              // 父表ID
		InputStr += "^" + SubID;            // 子表ID
		InputStr += "^" + RBCodeDr;         // 检验项目
		InputStr += "^" + '';               // 更新日期
		InputStr += "^" + '';               // 更新时间
		InputStr += "^" + $.LOGON.USERID;   // 更新人
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleRBCode","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleRBCode.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleRBCode,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleRBCode.row(rowIndex).data();
					obj.Codelayer_rd = rd;
				} else {
					obj.Codelayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('检查项目重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
}