//页面Event
function InitCRuleOperWinEvent(obj){
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	
	//*********************** 手术列表 stt ***********************
	$("#btnsearch_two").on('click', function(){
       $('#gridCRuleOper').DataTable().search($('#search_two').val(),true,true).draw();
    });
	
    $("#search_two").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleOper.search(this.value).draw();
        }
    });
	
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
    $("#btnLocOper_two").addClass('disabled');
	obj.gridCRuleOper.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
		if ( selectedRows !== 1 ) return;
		
		obj.gridCRuleOperKeys.ajax.reload(function(){
			$("#btnAdd_Keys").removeClass('disabled');
		});
	});
	obj.gridCRuleOper.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
        $("#btnLocOper_two").addClass('disabled');
		obj.gridCRuleOperKeys.ajax.reload(function(){
			$("#btnAdd_Keys").addClass('disabled');
		});
	});
	obj.gridCRuleOper.on('dblclick', 'tr', function(e) {
		var rd = obj.gridCRuleOper.row(this).data();
		obj.OperDxlayer_rd = rd;
		obj.Layer_two();
	});
	$("#btnAdd").on('click', function(){
		var flag = $("#btnAdd").hasClass("disabled");
		if(flag) return ;	
		obj.OperDxlayer_rd = '';
		obj.Layer_two();
	});
	$("#btnEdit").on('click', function(){
		var selectedRows =  obj.gridCRuleOper.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleOper.rows({selected: true}).data().toArray()[0];
		
		obj.OperDxlayer_rd = rd;
	   	obj.Layer_two();
	});
	$("#btnDelete").on('click', function(){
		var selectedRows =  obj.gridCRuleOper.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridCRuleOper.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleOper","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridCRuleOper.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
			}
		 );
	});
	obj.Layer_two = function(){
		$.form.SelectRender("#cboType");
		$.form.SelectRender("#cboOperInc");
		$.form.SelectRender("#cboLocation");
		//$.form.SelectRender("#cboOperDx");
		$.form.iCheckRender();
		
		var rd = obj.OperDxlayer_rd;
		if (rd){
			$.form.SetValue("cboType",rd["Type"]);
			$.form.SetValue("cboLocation",rd["LocID"],rd["LocDesc"]);
			$.form.SetValue("txtOperDesc",rd["Operation"]);
			$.form.SetValue("cboOperInc",rd["IncID"],rd["IncDesc"]);
			//$.form.SetValue("cboOperDx",rd["ID"],rd["BTOperDesc"]);
			$.form.SetValue("chkActive",(rd["IsActive"]==1));
		} else {
			$.form.SetValue("cboType",'');
			$.form.SetValue("cboLocation",'');
			$.form.SetValue("txtOperDesc","");
			$.form.SetValue("cboOperInc","","");
			//$.form.SetValue("cboOperDx","","");
			$.form.SetValue("chkActive",true);
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '手术信息编辑',
			content: $('#layer_two'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.LayerTwo_Add();
			},
			btn2: function(index, layero){
				obj.LayerTwo_Save();
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
	//保存手术信息
	obj.LayerTwo_Save = function(){
		var rdOperDx = obj.OperDxlayer_rd;
		var ID = (rdOperDx ? rdOperDx["ID"] : '');
		var Type      = $.form.GetValue("cboType");
		var LocDr     = $.form.GetValue("cboLocation");
		var OperIncDr = $.form.GetValue("cboOperInc");
		var OperDxDr  = '' //$.form.GetValue("cboOperDx");
		var OperDesc  = $.form.GetValue("txtOperDesc");
		var IsActive  = $.form.GetValue("chkActive");
		
		if (LocDr== '') {
			layer.alert("科室不允许为空",{icon: 0});
			return;
		}
		
		var ErrorStr = "";
		if ((!OperIncDr)&&(!OperDxDr)&&(!OperDesc)) {
			ErrorStr += '切口类型、手术名称不允许同时为空!<br/>';
		}
		
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Type;
		InputStr += "^" + LocDr;
		InputStr += "^" + OperIncDr;
		InputStr += "^" + OperDxDr;
		InputStr += "^" + OperDesc;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERDESC;
		
		var retval =  $.Tool.RunServerMethod("DHCHAI.IR.CRuleOper","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleOper.ajax.reload(function(){
				var rowIndex =  $.Tool.GetTableRowIndex(obj.gridCRuleOper,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleOper.row(rowIndex).data();
					obj.OperDxlayer_rd = rd;
				} else {
					obj.OperDxlayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('手术名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	// 添加手术信息
	obj.LayerTwo_Add = function(){
		var rdOperDx = "";
		var ID = (rdOperDx ? rdOperDx["ID"] : '');
		var Type      = $.form.GetValue("cboType");
		var LocDr     = $.form.GetValue("cboLocation");
		var OperIncDr = $.form.GetValue("cboOperInc");
		var OperDxDr  = '' //$.form.GetValue("cboOperDx");
		var OperDesc  = $.form.GetValue("txtOperDesc");
		var IsActive = $.form.GetValue("chkActive");
		
		if (LocDr== '') {
			layer.alert("科室不允许为空",{icon: 0});
			return;
		}
		
		var ErrorStr = "";
		if ((!OperIncDr)&&(!OperDxDr)&&(!OperDesc)) {
			ErrorStr += '切口类型、手术名称不允许同时为空!<br/>';
		}
		
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + Type;
		InputStr += "^" + LocDr;
		InputStr += "^" + OperIncDr;
		InputStr += "^" + OperDxDr;
		InputStr += "^" + OperDesc;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERDESC;
		
		var retval =  $.Tool.RunServerMethod("DHCHAI.IR.CRuleOper","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleOper.ajax.reload(function(){
				var rowIndex =  $.Tool.GetTableRowIndex(obj.gridCRuleOper,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleOper.row(rowIndex).data();
					obj.OperDxlayer_rd = rd;
				} else {
					obj.OperDxlayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('手术名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	//*********************** 手术列表 end ***********************
	
	
	//*********************** 手术关键词 stt ***********************
    $("#btnsearch_three").on('click', function(){
       $('#gridCRuleOperKeys').DataTable().search($('#search_three').val(),true,true).draw();
    });
    $("#search_three").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleOperKeys.search(this.value).draw();
        }
    });
	
    $("#btnAdd_Keys").addClass('disabled');
    $("#btnEdit_Keys").addClass('disabled');
    $("#btnDelete_Keys").addClass('disabled');
	obj.gridCRuleOperKeys.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_Keys").addClass('disabled');
		$("#btnEdit_Keys").removeClass('disabled');
		$("#btnDelete_Keys").removeClass('disabled');
	});
	obj.gridCRuleOperKeys.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_Keys").removeClass('disabled');
        $("#btnEdit_Keys").addClass('disabled');
        $("#btnDelete_Keys").addClass('disabled');
	});
	obj.gridCRuleOperKeys.on('dblclick', 'tr', function(e) {
		var selectedRows = obj.gridCRuleOper.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.alert('请先选择手术筛查规则，再添加数据!',{icon: 0});
			return;
		}	
		var rd = obj.gridCRuleOperKeys.row(this).data();
		obj.Keylayer_rd = rd;
		obj.Layer_three();
	});
	$("#btnAdd_Keys").on('click', function(){
		var flag = $("#btnAdd_Keys").hasClass("disabled");
		if(flag) return ;	
		obj.Keylayer_rd = '';
		obj.Layer_three();
	});
	$("#btnEdit_Keys").on('click', function(){
		var selectedRows = obj.gridCRuleOperKeys.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridCRuleOperKeys.rows({selected: true}).data().toArray()[0];
		
		obj.Keylayer_rd = rd;
	    obj.Layer_three();
	});
	$("#btnDelete_Keys").on('click', function(){
		var selectedRows =  obj.gridCRuleOperKeys.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridCRuleOperKeys.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleOperKeys","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					 obj.gridCRuleOperKeys.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//关键词-初始化
	obj.Layer_three = function(){
		$.form.iCheckRender();
        var rd = obj.Keylayer_rd;
		if (rd){
			$.form.SetValue("txtInWord",rd["InWord"]);
			$.form.SetValue("txtExWords",rd["ExWords"]);
		} else {
			$.form.SetValue("txtInWord",'');
			$.form.SetValue("txtExWords",'');
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '关键词编辑', 
			content: $('#layer_three'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.LayerThree_Add();
			},
			btn2: function(index, layero){
				obj.LayerThree_Save();
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
	
	// 关键词-保存
	obj.LayerThree_Save = function(){
		var rd = obj.gridCRuleOper.rows({selected: true}).data().toArray()[0]; // 标准手术
		var CRuleOperDr = (rd ? rd["ID"] : ''); // 标准手术主键
		
		var rdKey = obj.Keylayer_rd;
		var ID = (rdKey ? rdKey["ID"] : '');
        var InWord = $.form.GetValue("txtInWord");
        var ExWords = $.form.GetValue("txtExWords");
        
		var ErrorStr="";
		if (InWord == '') {
			ErrorStr += '关键词(包含)不允许为空!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + CRuleOperDr;
		InputStr += "^" + InWord;
		InputStr += "^" + ExWords;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERDESC;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleOperKeys","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleOperKeys.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleOperKeys,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleOperKeys.row(rowIndex).data();
					obj.Keylayer_rd = rd;
				} else {
					obj.Keylayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('标准手术+关键词重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	// 关键词-添加
	obj.LayerThree_Add = function(){
		var rd = obj.gridCRuleOper.rows({selected: true}).data().toArray()[0]; // 标准手术
		var CRuleOperDr = (rd ? rd["ID"] : ''); // 标准手术主键
		
		var rdKey = '';
		var ID = (rdKey ? rdKey["ID"] : '');
        var InWord = $.form.GetValue("txtInWord");
        var ExWords = $.form.GetValue("txtExWords");
        
		var ErrorStr="";
		if (InWord == '') {
			ErrorStr += '关键词(包含)不允许为空!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + CRuleOperDr;
		InputStr += "^" + InWord;
		InputStr += "^" + ExWords;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleOperKeys","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleOperKeys.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleOperKeys,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleOperKeys.row(rowIndex).data();
					obj.Keylayer_rd = rd;
				} else {
					obj.Keylayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('标准手术+关键词重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	//*********************** 手术关键词 end ***********************
}
