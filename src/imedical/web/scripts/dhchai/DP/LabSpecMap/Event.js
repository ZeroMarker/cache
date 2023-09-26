//页面Event
function InitLabSpecMapWinEvent(obj){
	CheckSpecificKey();
	//标本对照
	/*****搜索功能*****/
    $("#btnsearch_two").on('click', function(){
       $('#gridLabSpecMap').DataTable().search($('#search_two').val(),true,true).draw();
       
    });
	
    $("#search_two").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
			obj.gridLabSpecMap.search(this.value).draw();
	    }
    });
    /**********************/
	obj.gridLabSpecMap.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").removeClass('disabled');
		$("#btnEdit_two").removeClass('disabled');
		$("#btnDelete_two").removeClass('disabled');
	});

	obj.gridLabSpecMap.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").addClass('disabled');
        $("#btnEdit_two").addClass('disabled');
        $("#btnDelete_two").addClass('disabled');
	});
	
	obj.gridLabSpecMap.on('dblclick', 'tr', function(e) {
		var rd = obj.gridLabSpecMap.row(this).data();
		obj.layer_rd = rd;
		obj.Layer_two();
	    
	});
	
	$("#btnAll").on('click', function(){	
		flg = "";
	 	obj.gridLabSpecMap.ajax.reload($('#gridLabSpecMap').DataTable().search($('#search_two').val(),true,true).draw());
	});
	$("#btnPend").on('click', function(){	
		flg = 0;
	 	obj.gridLabSpecMap.ajax.reload($('#gridLabSpecMap').DataTable().search($('#search_two').val(),true,true).draw());
	});
	$("#btnFin").on('click', function(){
		flg = 1;
	 	obj.gridLabSpecMap.ajax.reload($('#gridLabSpecMap').DataTable().search($('#search_two').val(),true,true).draw());
	
	});
	$("#btnSyn").on('click', function(){
		var retval = $.Tool.RunServerMethod("DHCHAI.DPS.LabSpecSrv","SynMapRule","检验标本");
		if (parseInt(retval)>0){
			layer.msg('成功匹配'+retval+'条!',{icon: 1});
		} else {
			layer.msg('没有可匹配项或匹配失败!',{icon: 2});
		}
		obj.gridLabSpecMap.ajax.reload();
	
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
        var Maprd  = obj.gridLabSpecMap.rows({selected: true}).data().toArray()[0];	
		var Sperd = obj.gridLabSpecimen.rows({selected: true}).data().toArray()[0];
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var SpeID = (Sperd ? Sperd["ID"] : '');
		
		if ((MapID == "")||(SpeID == "")) {
			layer.msg('设置对照关系需同时选择标本字典及对照项目!',{icon: 2});
		}else {
			var ActUser = $.LOGON.USERDESC;
			var retval = $.Tool.RunServerMethod("DHCHAI.DPS.LabSpecSrv","UpdateMap",MapID,SpeID,ActUser);
			if (parseInt(retval)>0){
				obj.gridLabSpecMap.ajax.reload(function(){
					var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabSpecMap,retval);
					if (rowIndex > -1){
						var rd =obj.gridLabSpecMap.row(rowIndex).data();
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
		var selectedRows = obj.gridLabSpecMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridLabSpecMap.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_two();
	
	});

	$("#btnDelete_two").on('click', function(){
		var flag = $("#btnDelete_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridLabSpecMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridLabSpecMap.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		if (rd["MapItemID"]=="") {
			layer.msg('没有对照关系，不可撤销!',{icon: 0});
		}else {
			layer.confirm( '确认是否撤销对照关系?', {
				btn: ['确认','取消'],    //btn位置对应function的位置
				btnAlign: 'c'
				},
				function(){ 
					var flg = $.Tool.RunServerMethod("DHCHAI.DP.LabSpecMap","DeleteMapById",ID);
					if (parseInt(flg)>0){
						obj.gridLabSpecMap.ajax.reload(function(){
							var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabSpecMap,flg);
							if (rowIndex > -1){
								var rd =obj.gridLabSpecMap.row(rowIndex).data();
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

  
	//标本对照编辑窗体-初始化
	obj.Layer_two = function(){	
	    $.form.iCheckRender(); //单选按钮
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("chkActive_two",rd["IsActive"]== 1);
			$.form.SetValue("txtMapNote",rd["MapNote"]);
		} else {
		
			$.form.SetValue("chkActive_two",'');
			$.form.SetValue("txtMapNote",'');
		}
	    
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '标本对照编辑', 
			content: $('#layer_two'),
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.LayerTwo_Save();
			  	layer.close(index); //关闭
			}
			
		}); 	
		
	}
	
	
	//标本对照配置窗体-保存
	obj.LayerTwo_Save = function(){
		var rd = obj.layer_rd;
		
		var ID = (rd ? rd["ID"] : '');
      	var SpecDesc  = rd["SpecDesc"];
        var MapItemDr = rd["MapItemID"];
		var IsActive  = $.form.GetValue("chkActive_two");		
		var MapNote   = $.form.GetValue("txtMapNote");
		var SCode     = rd["SCode"];		
	    var ActUser   = $.LOGON.USERDESC;
		
		var InputStr = ID;
		InputStr += "^" + SpecDesc;
		InputStr += "^" + MapItemDr;	
		InputStr += "^" + MapNote;
		InputStr += "^" + SCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
	
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabSpecMap","Update",InputStr);

		if (parseInt(retval)>0){
			obj.gridLabSpecMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabSpecMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabSpecMap.row(rowIndex).data();
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
	

	/*****搜索功能*****/
    $("#btnsearch_one").on('click', function(){
       $('#gridLabSpecimen').DataTable().search($('#search_one').val(),true,true).draw();
       
    });
	
    $("#search_one").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
	    	obj.gridLabSpecimen.search(this.value).draw();
	    }
    });
   /**********************/
    $("#btnEdit_one").addClass('disabled');
    $("#btnDelete_one").addClass('disabled');
	obj.gridLabSpecimen.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").addClass('disabled');
		$("#btnEdit_one").removeClass('disabled');
		$("#btnDelete_one").removeClass('disabled');
		
	});
	
	obj.gridLabSpecimen.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").removeClass('disabled');
        $("#btnEdit_one").addClass('disabled');
        $("#btnDelete_one").addClass('disabled');
  
	});
	
	obj.gridLabSpecimen.on('dblclick', 'tr', function(e) {
		var rd = obj.gridLabSpecimen.row(this).data();
		
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
		var selectedRows = obj.gridLabSpecimen.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabSpecimen.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_one();
	
	});
	
	$("#btnDelete_one").on('click', function(){
		var flag = $("#btnDelete_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLabSpecimen.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabSpecimen.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.DP.LabSpecimen","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridLabSpecimen.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//标本编辑窗体-初始化
	obj.Layer_one = function(){
		$.form.iCheckRender();
		$.form.SelectRender("cboProperty");  //渲染下拉框
		var rd = obj.layer_rd;
		
		if (rd){
			$.form.SetValue("txtSpecCode",rd["SpecCode"]);
			$.form.SetValue("txtSpecDesc",rd["SpecDesc"]);
			$.form.SetValue("txtWCode",rd["WCode"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
			$.form.SetValue("cboProperty",rd["PropertyID"],rd["PropertyDesc"]);
		} else {
			$.form.SetValue("txtSpecCode",'');   
			$.form.SetValue("txtSpecDesc",'');   
			$.form.SetValue("txtWCode",'');   
			$.form.SetValue("chkActive",'');
			$.form.SetValue("cboProperty",'');    
		}
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '标本编辑', 
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
	
	//标本编辑窗体-保存
	obj.LayerOne_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var SpecCode  = $.form.GetValue("txtSpecCode");
		var SpecDesc  = $.form.GetValue("txtSpecDesc");
		var WCode     = $.form.GetValue("txtWCode");
		var IsActive  = $.form.GetValue("chkActive");
		var Property  = $.form.GetValue("cboProperty");
		
		var InputStr = ID;
		InputStr += "^" + SpecCode;
		InputStr += "^" + SpecDesc;
		InputStr += "^" + WCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + Property;
	
		if (SpecCode == '') {
			layer.alert("代码不允许为空",{icon: 0});
			return;
		}
		if (SpecDesc == '') {
			layer.alert("名称不允许为空",{icon: 0});
			return;
		}
    
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabSpecimen","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLabSpecimen.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabSpecimen,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabSpecimen.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('标本代码、名称不允许修改!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//标本编辑窗体-添加
	obj.LayerOne_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var SpecCode  = $.form.GetValue("txtSpecCode");
		var SpecDesc  = $.form.GetValue("txtSpecDesc");
		var WCode     = $.form.GetValue("txtWCode");
		var IsActive  = $.form.GetValue("chkActive");
		var Property  = $.form.GetValue("cboProperty");
		
		var InputStr = ID;
		InputStr += "^" + SpecCode;
		InputStr += "^" + SpecDesc;
		InputStr += "^" + WCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + Property;
		
		if (SpecCode == '') {
			layer.alert("代码不允许为空",{icon: 0});
			return;
		}
		if (SpecDesc == '') {
			layer.alert("名称不允许为空",{icon: 0});
			return;
		}
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabSpecimen","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLabSpecimen.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabSpecimen,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabSpecimen.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('标本代码、名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	
}
