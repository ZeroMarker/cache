//页面Event
function InitLabTestSetMapWinEvent(obj){
	CheckSpecificKey();
    //检验医嘱对照
    /*****搜索功能*****/
    $("#btnsearch_two").on('click', function(){
       $('#gridLabTestSetMap').DataTable().search($('#search_two').val(),true,true).draw();
       
    });
	
    $("#search_two").keyup(function(event){  
    	if ((event.keyCode == 13)||(this.value=="")) {
	    	obj.gridLabTestSetMap.search(this.value).draw();
    	}        
    });
    /**********************/

	obj.gridLabTestSetMap.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").removeClass('disabled');
		$("#btnEdit_two").removeClass('disabled');
		$("#btnDelete_two").removeClass('disabled');
	});

	obj.gridLabTestSetMap.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").addClass('disabled');
        $("#btnEdit_two").addClass('disabled');
        $("#btnDelete_two").addClass('disabled');
	});
	
	obj.gridLabTestSetMap.on('dblclick', 'tr', function(e) {
		var rd = obj.gridLabTestSetMap.row(this).data();
		obj.layer_rd = rd;
		obj.Layer_two();
	    
	});
	
	$("#btnAll").on('click', function(){	
		flg = "";
	 	obj.gridLabTestSetMap.ajax.reload($('#gridLabTestSetMap').DataTable().search($('#search_two').val(),true,true).draw());
	});
	$("#btnPend").on('click', function(){	
		flg = 0;
	 	obj.gridLabTestSetMap.ajax.reload($('#gridLabTestSetMap').DataTable().search($('#search_two').val(),true,true).draw());
	});
	$("#btnFin").on('click', function(){
		flg = 1;
	 	obj.gridLabTestSetMap.ajax.reload($('#gridLabTestSetMap').DataTable().search($('#search_two').val(),true,true).draw());
	
	});
	$("#btnSyn").on('click', function(){
		var retval = $.Tool.RunServerMethod("DHCHAI.DPS.LabTestSetSrv","SynMapRule","检验医嘱");
		if (parseInt(retval)>0){
			layer.msg('成功匹配'+retval+'条!',{icon: 1});
		} else {
			layer.msg('没有可匹配项或匹配失败!',{icon: 2});
		}
		obj.gridLabTestSetMap.ajax.reload();
	
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
		var Maprd  = obj.gridLabTestSetMap.rows({selected: true}).data().toArray()[0];	
		var Setrd = obj.gridLabTestSet.rows({selected: true}).data().toArray()[0];
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var SetID = (Setrd ? Setrd["ID"] : '');
		
		if ((MapID == "")||(SetID == "")) {
			layer.msg('设置对照关系需同时选择检验医嘱字典及对照项目!',{icon: 2});
		}else {
			var ActUser = $.LOGON.USERDESC;
			var retval = $.Tool.RunServerMethod("DHCHAI.DPS.LabTestSetSrv","UpdateMap",MapID,SetID,ActUser);
			if (parseInt(retval)>0){
				obj.gridLabTestSetMap.ajax.reload(function(){
					var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabTestSetMap,retval);
					if (rowIndex > -1){
						var rd =obj.gridLabTestSetMap.row(rowIndex).data();
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
		var selectedRows = obj.gridLabTestSetMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridLabTestSetMap.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_two();
	
	});

	$("#btnDelete_two").on('click', function(){
		var selectedRows =  obj.gridLabTestSetMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridLabTestSetMap.rows({selected: true}).data().toArray()[0];
		
	   	var ID = rd["ID"];
		if (rd["MapItemID"]=="") {
			layer.msg('没有对照关系，不可撤销!',{icon: 0});
		}else {
			layer.confirm( '确认是否撤销对照关系?', {
				btn: ['确认','取消'],    //btn位置对应function的位置
				btnAlign: 'c'
				},
				function(){ 
					var flg = $.Tool.RunServerMethod("DHCHAI.DP.LabTestSetMap","DeleteMapById",ID);
					if (parseInt(flg)>0){
						obj.gridLabTestSetMap.ajax.reload(function(){
							var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabTestSetMap,flg);
							if (rowIndex > -1){
								var rd =obj.gridLabTestSetMap.row(rowIndex).data();
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
	
	//检验医嘱对照窗体-初始化
	obj.Layer_two = function(){
	    $.form.iCheckRender(); //单选按钮
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("chkMapActive",rd["IsActive"]== 1);
			$.form.SetValue("txtMapNote",rd["MapNote"]);
		} else {
			$.form.SetValue("chkMapActive",'');
			$.form.SetValue("txtMapNote",'');

		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '检验医嘱对照编辑', 
			content: $('#layer_two'),
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.LayerTwo_Save();
			  	layer.close(index); //关闭
			}
		}); 	
	}
	
	//检验医嘱对照窗体-保存
	obj.LayerTwo_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
        
		var TestSet=rd["TestSet"];
		var OrdDesc=rd["OrdDesc"];
        var MapItemDr=rd["MapItemID"];
		var IsActive = $.form.GetValue("chkMapActive");		
		var MapNote=$.form.GetValue("txtMapNote");
		var SCode=rd["SCode"];		
	    var ActUser = $.LOGON.USERDESC;
		
		var InputStr = ID;
		InputStr += "^" + TestSet;
		InputStr += "^" + OrdDesc;
		InputStr += "^" + MapItemDr;	
		InputStr += "^" + MapNote;
		InputStr += "^" + SCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
	  
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabTestSetMap","Update",InputStr);
		
		if (parseInt(retval)>0){
			obj.gridLabTestSetMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabTestSetMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabTestSetMap.row(rowIndex).data();
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
       $('#gridLabTestSet').DataTable().search($('#search_one').val(),true,true).draw();
       
    });
	
    $("#search_one").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
	   		obj.gridLabTestSet.search(this.value).draw();
	    }
    });
}
