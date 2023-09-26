//页面Event
function InitInfSuPosWinEvent(obj){
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	$.form.iCheckRender();  //渲染复选框|单选钮
	
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridInfSuPos').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridInfSuPos.search(this.value).draw();
        }
    });
    /****************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridInfSuPos.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
		obj.gridSuPosKeys.ajax.reload(function(){
			$("#btnAdd_two").removeClass('disabled');
		});
	});
	
	obj.gridInfSuPos.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
        obj.gridSuPosKeys.ajax.reload(function(){
			$("#btnAdd_two").addClass('disabled');
		});
	});
	
	obj.gridInfSuPos.on('dblclick', 'tr', function(e) {
		var rd = obj.gridInfSuPos.row(this).data();
		
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
		var selectedRows = obj.gridInfSuPos.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridInfSuPos.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
		obj.Layer();
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridInfSuPos.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridInfSuPos.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.BT.InfSuPos","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridInfSuPos.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
		
	});

	//疑似诊断维护编辑窗体-初始化
	obj.Layer = function(){
		$.form.SelectRender('cboInfPos');
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtDiag",rd["Diagnos"]);
			$.form.SetValue("cboInfPos",rd["InfPosID"],rd["InfPosDesc"]);
		} else {
			$.form.SetValue("txtDiag",'');
			$.form.SetValue("cboInfPos",'');
		}
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '疑似诊断编辑', 
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
	
	//疑似诊断维护编辑窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var Diagnos  = $.form.GetValue("txtDiag");
		var InfPosDr = $.form.GetValue("cboInfPos");
		
		if (Diagnos == '') {
			layer.alert("疑似诊断不允许为空",{icon: 0});
			return;
		}
		if (InfPosDr == '') {
			layer.alert("感染部位不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Diagnos;        // 疑似诊断
		InputStr += "^" + InfPosDr;       // 感染部位
		InputStr += "^" + "";             // 处置日期
		InputStr += "^" + "";             // 处置时间
		InputStr += "^" + $.LOGON.USERID; // 处置人
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.InfSuPos","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridInfSuPos.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridInfSuPos,retval);
				if (rowIndex > -1){
					var rd =obj.gridInfSuPos.row(rowIndex).data();
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
	
	//疑似诊断维护编辑窗体-添加
	obj.Layer_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var Diagnos  = $.form.GetValue("txtDiag");
		var InfPosDr = $.form.GetValue("cboInfPos");
		
		if (Diagnos == '') {
			layer.alert("疑似诊断不允许为空",{icon: 0});
			return;
		}
		if (InfPosDr == '') {
			layer.alert("感染部位不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + Diagnos;        // 疑似诊断
		InputStr += "^" + InfPosDr;       // 感染部位
		InputStr += "^" + "";             // 处置日期
		InputStr += "^" + "";             // 处置时间
		InputStr += "^" + $.LOGON.USERID; // 处置人
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.InfSuPos","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridInfSuPos.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridInfSuPos,retval);
				if (rowIndex > -1){
					var rd =obj.gridInfSuPos.row(rowIndex).data();
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
	
	// --------------------------疑似诊断-关键词-----------------------------------
	$("#btnsearch_two").on('click', function(){
		$('#gridSuPosKeys').DataTable().search($('#search_two').val(),true,true).draw();
    });
	
    $("#search_two").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridSuPosKeys.search(this.value).draw();
        }
    });
    
    $("#btnAdd_two").addClass('disabled');
    $("#btnEdit_two").addClass('disabled');
    $("#btnDelete_two").addClass('disabled');
	obj.gridSuPosKeys.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").addClass('disabled');
		$("#btnEdit_two").removeClass('disabled');
		$("#btnDelete_two").removeClass('disabled');
	});

	obj.gridSuPosKeys.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").removeClass('disabled');
        $("#btnEdit_two").addClass('disabled');
        $("#btnDelete_two").addClass('disabled');
	});
	
	obj.gridSuPosKeys.on('dblclick', 'tr', function(e) {
		var rd = obj.gridSuPosKeys.row(this).data();
		obj.Keylayer_rd = rd;
		obj.Layer_two();
	    
	});
	
	$("#btnAdd_two").on('click', function(){
		var flag = $("#btnAdd_two").hasClass("disabled");
		if(flag) return ;	
		obj.Keylayer_rd = '';
		obj.Layer_two();
		
	});
	
	$("#btnEdit_two").on('click', function(){
		var selectedRows = obj.gridSuPosKeys.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridSuPosKeys.rows({selected: true}).data().toArray()[0];
		
		obj.Keylayer_rd = rd;
	    obj.Layer_two();
	
	});

	$("#btnDelete_two").on('click', function(){
		var selectedRows =  obj.gridSuPosKeys.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridSuPosKeys.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleInfSuPos","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					 obj.gridSuPosKeys.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});

  
	//疑似诊断-关键词-初始化
	obj.Layer_two = function(){
		$.form.iCheckRender("chkProperty");  //渲染复选框|单选钮
		$.form.SelectRender("cboKeyType");  //渲染下拉框
        var rd = obj.Keylayer_rd;
		if (rd){
			$.form.SetValue("cboKeyType",rd["TypeID"],rd["TypeDesc"]);
			$.form.SetValue("txtKeyWord",rd["KeyWord"]);
			$.form.SetValue('chkProperty',(rd["Property"] =='包含'));
		} else {
			$.form.SetValue("cboKeyType",'');
			$.form.SetValue("txtKeyWord",'');
			$.form.SetValue("chkProperty",1);
		}
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '关键字编辑', 
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
	
	//疑似诊断-关键词-保存
	obj.Layertwo_Save = function(){
		var rd = obj.gridInfSuPos.rows({selected: true}).data().toArray()[0]; // 疑似诊断
		var SuPosID = (rd ? rd["ID"] : ''); // 疑似诊断ID
		var rdKey = obj.Keylayer_rd;
		var ID = (rdKey ? rdKey["ID"] : '');
		
		var KeyWord = $.form.GetValue("txtKeyWord");
		var KeyTypeID = $.form.GetValue("cboKeyType");
		var Property = $.form.GetValue("chkProperty");
		
		var ErrorStr = "";
		if (KeyTypeID == '') {
			ErrorStr += '分类不允许为空!<br/>';
		}
		if (KeyWord == '') {
			ErrorStr += '关键词不允许为空!<br/>';
		}
	
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 2});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + KeyWord;
		InputStr += "^" + KeyTypeID;
		InputStr += "^" + Property;
		InputStr += "^" + SuPosID;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleInfSuPos","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridSuPosKeys.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridSuPosKeys,retval);
				if (rowIndex > -1){
					var rd =obj.gridSuPosKeys.row(rowIndex).data();
					obj.Keylayer_rd = rd;
				} else {
					obj.Keylayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('关键词重复!',{icon: 2});
			}else {
				layer.msg('保存失败!',{icon: 0});
			}
		}
	}
	
	//疑似诊断-关键词-添加
	obj.Layertwo_Add = function(){
			
		var rd = obj.gridInfSuPos.rows({selected: true}).data().toArray()[0]; // 疑似诊断
		var SuPosID = (rd ? rd["ID"] : '');
		var rdKey = "";
		var ID = (rdKey ? rdKey["ID"] : '');
		
		var KeyWord = $.form.GetValue("txtKeyWord");
		var KeyTypeID = $.form.GetValue("cboKeyType");
		var Property = $.form.GetValue("chkProperty");
		
		var ErrorStr = "";
		if (KeyTypeID == '') {
			ErrorStr += '分类不允许为空!<br/>';
		}
		if (KeyWord == '') {
			ErrorStr += '关键词不允许为空!<br/>';
		}
	
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 2});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + KeyWord;
		InputStr += "^" + KeyTypeID;
		InputStr += "^" + Property;
		InputStr += "^" + SuPosID;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleInfSuPos","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridSuPosKeys.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridSuPosKeys,retval);
				if (rowIndex > -1){
					var rd =obj.gridSuPosKeys.row(rowIndex).data();
					obj.Keylayer_rd = rd;
				} else {
					obj.Keylayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('关键词重复!',{icon: 2});
			}else {
				layer.msg('保存失败!',{icon: 0});
			}
		}
	}
}