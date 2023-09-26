//页面Event
function InitLabAntiMapWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       //$('#gridLabAntiMap').DataTable().search($('#search').val(),true,true).draw();
        //重新加载表格数据
         LabAnti=$('#search').val();
         obj.gridLabAntiMap.clear().draw()
         obj.gridLabAntiMap.ajax.reload(function (json) {
         if (json.data.length == 0) {
                layer.msg('没有找到相关数据！', { icon: 2 });
                return;
         }
         else {
               $("#gridLabAntiMap").dataTable().fnAdjustColumnSizing();
         }
      });
    });
	
    $("#search").keyup(function(event){
	    if ((event.keyCode == 13)||(this.value=="")) {
	    	obj.gridLabAntiMap.search(this.value).draw();
	    }        
    });
   /**********************/
	obj.gridLabAntiMap.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});

	obj.gridLabAntiMap.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridLabAntiMap.on('dblclick', 'tr', function(e) {
		var rd = obj.gridLabAntiMap.row(this).data();
		obj.layer_rd = rd;
		obj.Layer();
	    
	});
	
	$("#btnAll").on('click', function(){	
		flg = "";
	 	obj.gridLabAntiMap.ajax.reload($('#gridLabAntiMap').DataTable().search($('#search').val(),true,true).draw());
	});
	$("#btnPend").on('click', function(){	
		flg = 0;
	 	obj.gridLabAntiMap.ajax.reload($('#gridLabAntiMap').DataTable().search($('#search').val(),true,true).draw());
	});
	$("#btnFin").on('click', function(){
		flg = 1;
	 	obj.gridLabAntiMap.ajax.reload($('#gridLabAntiMap').DataTable().search($('#search').val(),true,true).draw());
	
	});
	$("#btnSyn").on('click', function(){
		var retval = $.Tool.RunServerMethod("DHCHAI.DPS.LabAntiSrv","SynMapRule","检验抗生素");
		if (parseInt(retval)>0){
			layer.msg('成功匹配'+retval+'条!',{icon: 1});
		} else {
			layer.msg('没有可匹配项或匹配失败!',{icon: 2});
		}
		obj.gridLabAntiMap.ajax.reload();
	
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
        var Maprd  = obj.gridLabAntiMap.rows({selected: true}).data().toArray()[0];	
		var Antird = obj.gridLabAntibiotic.rows({selected: true}).data().toArray()[0];
		var MapID  = (Maprd ? Maprd["ID"] : '');
		var AntiID = (Antird ? Antird["ID"] : '');
		
		if ((MapID == "")||(AntiID == "")) {
			layer.msg('设置对照关系需同时选择抗生素字典及对照项目!',{icon: 2});
		}else {
			var ActUser = $.LOGON.USERDESC;
			var retval = $.Tool.RunServerMethod("DHCHAI.DPS.LabAntiSrv","UpdateMap",MapID,AntiID,ActUser);
			if (parseInt(retval)>0){
				obj.gridLabAntiMap.ajax.reload(function(){
					var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabAntiMap,retval);
					if (rowIndex > -1){
						var rd =obj.gridLabAntiMap.row(rowIndex).data();
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
		var selectedRows = obj.gridLabAntiMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabAntiMap.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
		obj.Layer();
		
	});
	

	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridLabAntiMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridLabAntiMap.rows({selected: true}).data().toArray()[0];
		var ID = rd["ID"];
		if (rd["MapItemID"]=="") {
			layer.msg('没有对照关系，不可撤销!',{icon: 0});
		}else {
			layer.confirm( '确认是否撤销对照关系?', {
				btn: ['确认','取消'],    //btn位置对应function的位置
				btnAlign: 'c'
				},
				function(){ 
					var flg = $.Tool.RunServerMethod("DHCHAI.DP.LabAntiMap","DeleteMapById",ID);
					if (parseInt(flg)>0){
						obj.gridLabAntiMap.ajax.reload(function(){
							var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabAntiMap,flg);
							if (rowIndex > -1){
								var rd =obj.gridLabAntiMap.row(rowIndex).data();
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
  
	//抗生素字典对照编辑窗体-初始化
	obj.Layer = function(){
	    $.form.iCheckRender(); //单选按钮
	    $.form.SelectRender("#layer");  //渲染下拉框
        var rd = obj.layer_rd;
		if (rd){	
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
			$.form.SetValue("txtMapNote",rd["MapNote"]);
	
		} else {
			$.form.SetValue("chkActive",'');
			$.form.SetValue("txtSCode" ,''); 
		}
	 
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '抗生素对照编辑', 
			content: $('#layer'),
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.Layer_Save();
			  	layer.close(index); //关闭
			}
		}); 	
		
	}
	
	
	//抗生素字典对照配置窗体-保存
	 obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		
		var ID = (rd ? rd["ID"] : '');
      	var AntiDesc  = rd["AntiDesc"];
        var MapItemDr = rd["MapItemID"];
		var IsActive  = $.form.GetValue("chkActive");		
		var MapNote   = $.form.GetValue("txtMapNote");
		var SCode     = rd["SCode"];	
	    var ActUser   = $.LOGON.USERDESC;
	
		var InputStr = ID;
		InputStr += "^" + AntiDesc;
		InputStr += "^" + MapItemDr;		
		InputStr += "^" + MapNote;
		InputStr += "^" + SCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUser;

		var retval = $.Tool.RunServerMethod("DHCHAI.DP.LabAntiMap","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridLabAntiMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridLabAntiMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridLabAntiMap.row(rowIndex).data();
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
    $("#btnsearch_two").on('click', function(){
       $('#gridLabAntibiotic').DataTable().search($('#search_two').val(),true,true).draw();
       
    });
	
    $("#search_two").keyup(function(event){
		if ((event.keyCode == 13)||(this.value=="")) {
	  		obj.gridLabAntibiotic.search(this.value).draw();
	    }
    });
   /**********************/
}
