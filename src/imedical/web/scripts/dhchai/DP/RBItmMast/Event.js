//页面Event
function InitRBItmMastWinEvent(obj){
	CheckSpecificKey();
	 /*****搜索功能*****/
    $("#btnsearch_one").on('click', function(){
       $('#gridRBItmMast').DataTable().search($('#search_one').val(),true,true).draw();
       
    });
	
    $("#search_one").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
	   		obj.gridRBItmMast.search(this.value).draw();
	    }
    });
   /**********************/
    $("#btnEdit_one").addClass('disabled');
    $("#btnDelete_one").addClass('disabled');
    obj.gridRBItmMast.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").addClass('disabled');
		$("#btnEdit_one").removeClass('disabled');
		$("#btnDelete_one").removeClass('disabled');
	});
	
	obj.gridRBItmMast.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").removeClass('disabled');
        $("#btnEdit_one").addClass('disabled');
        $("#btnDelete_one").addClass('disabled');
	});
	
	obj.gridRBItmMast.on('dblclick', 'tr', function(e) {
		var rd = obj.gridRBItmMast.row(this).data();
		
		obj.layer_rd = rd;
		obj.Layer_one();
	    
	});
	
	$("#btnAdd_one").on('click', function(){
		var flag = $("#btnAdd_one").hasClass("disabled");
		if(flag) return ;	
		obj.layer_rd = '';
		obj.Layer_one();
		
	});
	
	$("#btnEdit_one").on('click', function(){
		var flag = $("#btnEdit_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridRBItmMast.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridRBItmMast.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_one();
		
	});
	
	$("#btnDelete_one").on('click', function(){
		var flag = $("#btnDelete_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridRBItmMast.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridRBItmMast.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.DP.RBItmMast","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridRBItmMast.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//信息编辑窗体-初始化
	obj.Layer_one = function(){
		$.form.iCheckRender();	
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtBTCode",rd["BTCode"]);
			$.form.SetValue("txtBTCName",rd["BTCName"]);
			$.form.SetValue("chkActive",rd["BTIsActive"]== 1);
		} else {
			$.form.SetValue("txtBTCode",'');
			$.form.SetValue("txtBTCName",'');
			$.form.SetValue("chkActive",true);
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '检查项目编辑', 
			content: $('#layer_one'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.LayerOne_Add();
			},
			btn2: function(index, layero){
				obj.LayerOne_Save();
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
	
	//信息编辑窗体-保存
	obj.LayerOne_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var BTCode = $.form.GetValue("txtBTCode");
		var BTCName = $.form.GetValue("txtBTCName");
		var IsActive = $.form.GetValue("chkActive");
		
		var InputStr = ID;
		InputStr += "^" + BTCode;
		InputStr += "^" + BTCName;
		InputStr += "^" + IsActive;
		
		if (BTCode == '') {
			layer.msg("检查编码不允许为空",{icon: 0});
			return;
		}
		if (BTCName == '') {
			layer.msg("检查描述不允许为空",{icon: 0});
			return;
		}
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.RBItmMast","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridRBItmMast.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridRBItmMast,retval);
				if (rowIndex > -1){
					var rd =obj.gridRBItmMast.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('检查代码、名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	
	obj.LayerOne_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var BTCode = $.form.GetValue("txtBTCode");
		var BTCName = $.form.GetValue("txtBTCName");
		var IsActive = $.form.GetValue("chkActive");
		
		var InputStr = ID;
		InputStr += "^" + BTCode;
		InputStr += "^" + BTCName;
		InputStr += "^" + IsActive;
		
		if (BTCode == '') {
			layer.msg("检查编码不允许为空",{icon: 0});
			return;
		}
		if (BTCName == '') {
			layer.msg("检查描述不允许为空",{icon: 0});
			return;
		}
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.RBItmMast","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridRBItmMast.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridRBItmMast,retval);
				if (rowIndex > -1){
					var rd =obj.gridRBItmMast.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('检查代码、名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	/****
	*    第二个grid 
	*
	***/
	 $("#btnsearch_two").on('click', function(){
       $('#gridRBItmMastMap').DataTable().search($('#search_two').val(),true,true).draw();
       
    });
	
    $("#search_two").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
	     	obj.gridRBItmMastMap.search(this.value).draw();
	    }
    });
    /**********************/

	obj.gridRBItmMastMap.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").removeClass('disabled');
		$("#btnEdit_two").removeClass('disabled');
		$("#btnDelete_two").removeClass('disabled');
	});
	
	obj.gridRBItmMastMap.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").addClass('disabled');
        $("#btnEdit_two").addClass('disabled');
        $("#btnDelete_two").addClass('disabled');
	});
	
	obj.gridRBItmMastMap.on('dblclick', 'tr', function(e) {
		var rd = obj.gridRBItmMastMap.row(this).data();
		
		obj.layer_rd = rd;
		obj.Layer_two();
	    
	});
	
	$("#btnAll").on('click', function(){	
		flg = "";
	 	obj.gridRBItmMastMap.ajax.reload($('#gridRBItmMastMap').DataTable().search($('#search_two').val(),true,true).draw());
	});
	$("#btnPend").on('click', function(){	
		flg = 0;
	 	obj.gridRBItmMastMap.ajax.reload($('#gridRBItmMastMap').DataTable().search($('#search_two').val(),true,true).draw());
	});
	$("#btnFin").on('click', function(){
		flg = 1;
	 	obj.gridRBItmMastMap.ajax.reload($('#gridRBItmMastMap').DataTable().search($('#search_two').val(),true,true).draw());
	});
	$("#btnSyn").on('click', function(){
		var retval = $.Tool.RunServerMethod("DHCHAI.DPS.RBItmMastMapSrv","SynMapRule","检查项目");
		if (parseInt(retval)>0){
			layer.msg('成功匹配'+retval+'条!',{icon: 1});
		} else {
			layer.msg('没有可匹配项或匹配失败!',{icon: 2});
		}
		obj.gridRBItmMastMap.ajax.reload();
	
	});
    $(".tab-button .tabbtn").mouseleave(function(){
		$(".tab-button .tabbtn").css("background-color","#FFFFFF");
	});
	$(".tab-button .tabbtn").focus(function(){
		$(".tab-button .tabbtn:focus").css("background-color","#B0E0E6");
	});
	$(".tab-button .tabbtn").click(function(){
		$(".tab-button .tabbtn:focus").css("background-color","#B0E0E6");
	});		
    $("#btnAdd_two").on('click', function(){
		var flag = $("#btnAdd_two").hasClass("disabled");
		if(flag) return ;
        var Maprd  = obj.gridRBItmMastMap.rows({selected: true}).data().toArray()[0];	
		var Mastrd = obj.gridRBItmMast.rows({selected: true}).data().toArray()[0];
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var MastID = (Mastrd ? Mastrd["ID"] : '');
		
		if ((MapID == "")||(MastID == "")) {
			layer.msg('设置对照关系需同时选择检验项目字典及对照项目!',{icon: 2});
		}else {
			var ActUser = $.LOGON.USERDESC;
			var retval = $.Tool.RunServerMethod("DHCHAI.DPS.RBItmMastMapSrv","UpdateMap",MapID,MastID,ActUser);
			if (parseInt(retval)>0){
				obj.gridRBItmMastMap.ajax.reload(function(){
					var rowIndex = $.Tool.GetTableRowIndex(obj.gridRBItmMastMap,retval);
					if (rowIndex > -1){
						var rd =obj.gridRBItmMastMap.row(rowIndex).data();
						obj.layer_rd = rd;
					} else {
						obj.layer_rd = '';
					}
					layer.msg('对照成功!',{icon: 1});
				},false); 
			} else {
				layer.msg('对照失败!',{icon: 2});
			}
		}

	});
	
	$("#btnEdit_two").on('click', function(){
		var flag = $("#btnEdit_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridRBItmMastMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridRBItmMastMap.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_two();
	
	});

	$("#btnDelete_two").on('click', function(){
		var flag = $("#btnDelete_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridRBItmMastMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridRBItmMastMap.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		if (rd["MapItemDr"]=="") {
			layer.msg('没有对照关系，不可撤销!',{icon: 0});
		}else {
			layer.confirm( '确认是否撤销对照关系?', {
				btn: ['确认','取消'],    //btn位置对应function的位置
				btnAlign: 'c'
				},
				function(){ 
					var flg = $.Tool.RunServerMethod("DHCHAI.DP.RBItmMastMap","DeleteMapById",ID);
					if (parseInt(flg)>0){
						obj.gridRBItmMastMap.ajax.reload(function(){
							var rowIndex = $.Tool.GetTableRowIndex(obj.gridRBItmMastMap,flg);
							if (rowIndex > -1){
								var rd =obj.gridRBItmMastMap.row(rowIndex).data();
								obj.layer_rd = rd;
							} else {
								obj.layer_rd = '';
							}
							layer.msg('撤销成功!',{icon: 1});
						},false);	
						
					} else {
						layer.msg('撤销失败!',{icon: 2});
					}
			 });
		}
	});
	
	obj.Layer_two = function(){	
		$.form.iCheckRender();
		var rd = obj.layer_rd;  
		if (rd){
			$.form.SetValue("txtMapNote",rd["BTMapNote"]);
			$.form.SetValue("chkMapActive",rd["BTIsActive"]== 1);
		} else {
			$.form.SetValue("txtMapNote",'');
			$.form.SetValue("chkMapActive",'');
		}
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '检查项目编辑', 
			content: $('#layer_two'),
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.LayerTwo_Save();
			  	layer.close(index); //关闭
			}
			
		}); 	
	}
	
	//编辑窗体-保存
	obj.LayerTwo_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var CHKItem   = rd["BTMRCHKItem"];
		var MapItemDr = rd["MapItemDr"];
		var MapNote   = $.form.GetValue("txtMapNote");
		var MapSCode  = rd["BTSCode"]
		var IsActive  = $.form.GetValue("chkMapActive");
		var ActUser   = $.LOGON.USERDESC;
		
		var InputStr = ID;
		InputStr += "^" + CHKItem;
		InputStr += "^" + MapItemDr;  
		InputStr += "^" + MapNote;  
		InputStr += "^" + MapSCode;
		InputStr += "^" + IsActive;
		InputStr += "^";
		InputStr += "^";
		InputStr += "^" + ActUser;
	
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.RBItmMastMap","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridRBItmMastMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridRBItmMastMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridRBItmMastMap.row(rowIndex).data();
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