//页面Event
function InitMROBSItemMapWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridMROBSItemMap').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
	    	obj.gridMROBSItemMap.search(this.value).draw();
	    }
    });
   /**********************/
	obj.gridMROBSItemMap.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridMROBSItemMap.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridMROBSItemMap.on('dblclick', 'tr', function(e) {
		var rd = obj.gridMROBSItemMap.row(this).data();
		
		obj.layer_rd = rd;
		obj.Layer();
	    
	});
	
	$("#btnAll").on('click', function(){	
		flg = "";
	 	obj.gridMROBSItemMap.ajax.reload($('#gridMROBSItemMap').DataTable().search($('#search').val(),true,true).draw());
	});
	$("#btnPend").on('click', function(){	
		flg = 0;
	 	obj.gridMROBSItemMap.ajax.reload($('#gridMROBSItemMap').DataTable().search($('#search').val(),true,true).draw());
	});
	$("#btnFin").on('click', function(){
		flg = 1;
	 	obj.gridMROBSItemMap.ajax.reload($('#gridMROBSItemMap').DataTable().search($('#search').val(),true,true).draw());
	
	});
	$("#btnSyn").on('click', function(){
		var retval = $.Tool.RunServerMethod("DHCHAI.DPS.MROBSItemMapSrv","SynMapRule","护理项目");
		if (parseInt(retval)>0){
			layer.msg('成功匹配'+retval+'条!',{icon: 1});
		} else {
			layer.msg('没有可匹配项或匹配失败!',{icon: 2});
		}
		obj.gridMROBSItemMap.ajax.reload();
	
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
	$("#btnAdd").on('click', function(){
		var flag = $("#btnAdd").hasClass("disabled");
		if(flag) return ;
		var Maprd  = obj.gridMROBSItemMap.rows({selected: true}).data().toArray()[0];	
		var Itemrd = obj.gridMROBSItem.rows({selected: true}).data().toArray()[0];
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var ItemID = (Itemrd ? Itemrd["ID"] : '');
		
		if ((MapID == "")||(ItemID == "")) {
			layer.msg('设置对照关系需同时选择护理项目字典及对照项目!',{icon: 2});
		}else {
			var ActUser = $.LOGON.USERDESC;
			var retval = $.Tool.RunServerMethod("DHCHAI.DPS.MROBSItemMapSrv","UpdateMap",MapID,ItemID,ActUser);
			if (parseInt(retval)>0){
				obj.gridMROBSItemMap.ajax.reload(function(){
					var rowIndex = $.Tool.GetTableRowIndex(obj.gridMROBSItemMap,retval);
					if (rowIndex > -1){
						var rd =obj.gridMROBSItemMap.row(rowIndex).data();
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

	
	$("#btnEdit").on('click', function(){
		var flag = $("#btnEdit").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridMROBSItemMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridMROBSItemMap.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer();
	
	});
	
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridMROBSItemMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridMROBSItemMap.rows({selected: true}).data().toArray()[0];
		var ID = rd["ID"];
		if (rd["MapItemDr"]=="") {
			layer.msg('没有对照关系，不可撤销!',{icon: 0});
		}else {
			layer.confirm( '确认是否撤销对照关系?', {
				btn: ['确认','取消'],    //btn位置对应function的位置
				btnAlign: 'c'
				},
				function(){ 
					var flg = $.Tool.RunServerMethod("DHCHAI.DP.MROBSItemMap","DeleteMapById",ID);
					if (parseInt(flg)>0){
						obj.gridMROBSItemMap.ajax.reload(function(){
							var rowIndex = $.Tool.GetTableRowIndex(obj.gridMROBSItemMap,flg);
							if (rowIndex > -1){
								var rd =obj.gridMROBSItemMap.row(rowIndex).data();
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
	
	//护理分类对照编辑窗体-初始化
	obj.Layer = function(){
		$.form.iCheckRender();

		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtMapNote",rd["MapNote"]);
			$.form.SetValue("chkIsActive",rd["BTIsActive"]== 1);
		} else {
			$.form.SetValue("txtMapNote",'');
			$.form.SetValue("chkIsActive",true);
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '护理项目对照编辑', 
			content: $('#layer'),
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.Layer_Save();
			  	layer.close(index); //关闭
			}
		}); 	
		
	}
	
	//护理分类对照编辑窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		var BTItemDesc = rd["BTItemDesc"];
		var BTMapItem =rd["MapItemDr"];
		var BTMapNote = $.form.GetValue("txtMapNote");
		var BTSCode = rd["BTSCode"];
		var IsActive = $.form.GetValue("chkIsActive");

		var InputStr = ID;
		InputStr += "^" + BTItemDesc;
		InputStr += "^" + BTMapItem;
		InputStr += "^" + BTMapNote;
		InputStr += "^" + BTSCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERDESC;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.MROBSItemMap","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridMROBSItemMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridMROBSItemMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridMROBSItemMap.row(rowIndex).data();
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
    /*****搜索*****/
    $("#btnsearch_one").on('click', function(){
       $('#gridMROBSItem').DataTable().search($('#search_one').val(),true,true).draw();
       
    });
	
    $("#search_one").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
	    	obj.gridMROBSItem.search(this.value).draw();
	    }
    });
   /**********************/
}