//页面Event
function InitPACRoomBedWinEvent(obj){
	obj.WardDesc=""; // 病区名称
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
    $("#btnBuildWard").addClass('disabled');

	// 调用显示床位图
	$("#btnBuildWard").on('click', function(){
		var flag = $("#btnBuildWard").hasClass("disabled");
		if(flag) return ;
		InitBedChart(obj,obj.layerward_rd['ID'],"","","","");
	});
	
	$("#btnSyn").on('click', function(){
		var flag = $("#btnSyn").hasClass("disabled");
		if(flag) return ;
		var retval = $.Tool.RunServerMethod("DHCHAI.DI.DHS.SyncHisInfo","SyncPACBed","HIS02");
		if (parseInt(retval)>0){
			layer.msg('床位列表同步成功!',{icon: 1});
		} else {
			layer.msg('床位列表同步失败!',{icon: 2});
		}
		obj.gridBed.ajax.reload();
	});
	
    $("#btnsearch_one").on('click', function(){
       $('#gridPACWard').DataTable().search($('#search_one').val(),true,true).draw();
    });
    $("#search_one").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridPACWard.search(this.value).draw();
        }
    });
	
	obj.gridPACWard.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		var rd = obj.gridPACWard.rows({selected: true}).data().toArray()[0];
		obj.layerward_rd = rd;
		$("#cboPACWardDr").data("param",obj.layerward_rd['ID']);
		obj.gridRoom.ajax.reload(function(){
			$("#btnAdd_two").removeClass('disabled');
			$("#btnEdit_two").addClass('disabled');
			$("#btnDelete_two").addClass('disabled');
		});
		obj.gridRoom.clear().draw();
		$("#btnBuildWard").removeClass('disabled');
		obj.gridBed.ajax.reload(function(){});
	});
	
	obj.gridPACWard.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		obj.layerward_rd = "";
		obj.RoomType = "";
		$("#cboPACWardDr").data("param","");
		obj.gridRoom.ajax.reload(function(){
			$("#btnAdd_two").addClass('disabled');
			$("#btnEdit_two").addClass('disabled');
			$("#btnDelete_two").addClass('disabled');
		});
		//obj.gridRoom.clear().draw();
		$("#btnBuildWard").addClass('disabled');
		
		obj.gridBed.ajax.reload(function(){});
	});
	
	//*********************** 房间列表 stt ***********************
	$("#btnsearch_two").on('click', function(){
       $('#gridRoom').DataTable().search($('#search_two').val(),true,true).draw();
    });
	
    $("#search_two").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridRoom.search(this.value).draw();
        }
    });
    $("#btnAdd_two").addClass('disabled');
    $("#btnEdit_two").addClass('disabled');
    $("#btnDelete_two").addClass('disabled');
    
	obj.gridRoom.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").addClass('disabled');
		$("#btnEdit_two").removeClass('disabled');
		$("#btnDelete_two").removeClass('disabled');
		if ( selectedRows !== 1 ) return;
		var rdRoom = obj.gridRoom.rows({selected: true}).data().toArray()[0];
		obj.RoomType = rdRoom['RoomType'];
		obj.gridBed.ajax.reload(function(){});
		var selectedRows = obj.gridBed.rows({selected: true}).count();
		var rdBed = obj.gridBed.rows({selected: true}).data().toArray()[0];
		if ( selectedRows !== 1 ) return;
		if((rdBed['IsRoomBed'] == 0)&&(selectedRows == 1)) $("#btnPACRoomBed_two").removeClass('disabled');
	});
	obj.gridRoom.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").removeClass('disabled');
        $("#btnEdit_two").addClass('disabled');
        $("#btnDelete_two").addClass('disabled');
		obj.RoomType = "";
		obj.gridBed.ajax.reload(function(){});
	});
	obj.gridRoom.on('dblclick', 'tr', function(e) {
		var rd = obj.gridRoom.row(this).data();
		obj.RoomDxlayer_rd = rd;
		obj.Layer_two();
	});
	$("#btnAdd_two").on('click', function(){
		var flag = $("#btnAdd_two").hasClass("disabled");
		if(flag) return ;	
		obj.RoomDxlayer_rd = '';
		var rd = obj.gridPACWard.rows({selected: true}).data().toArray()[0]; // 病区
		var LocDr = (rd ? rd["ID"] : ''); // 病区主键
		if (rd["IsMainWard"]=="0"){
			var WardFlg = $.Tool.RunServerMethod("DHCHAI.BT.PACWard","Update","^"+LocDr+"^^^^1^");
			if (parseInt(WardFlg)>0){
				$.form.SelectRender("cboPACWardDr");
			}
		}
		obj.Layer_two();
	});
	$("#btnEdit_two").on('click', function(){
		var flag = $("#btnEdit_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridRoom.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridRoom.rows({selected: true}).data().toArray()[0];
		
		obj.RoomDxlayer_rd = rd;
	   	obj.Layer_two();
	});
	$("#btnDelete_two").on('click', function(){
		var flag = $("#btnDelete_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridRoom.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridRoom.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消']    //btn位置对应function的位置
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.BT.PACRoom","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridRoom.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
			}
		 );
	});
	obj.Layer_two = function(){
		$.form.SelectRender();
		$.form.SelectRender("RoomDescPos");
		var rd = obj.RoomDxlayer_rd;
		if (rd){
			$.form.SetValue("txtRoomDesc",rd["RoomDesc"]);
			$.form.SetValue("RoomDescPos",rd["RoomDescPos"]);
			$.form.SetValue("RoomType",rd["RoomTypeDr"],rd["RoomType"]);
			$.form.SetValue("txtPosTop",rd["PosTop"]);
			$.form.SetValue("txtPosLeft",rd["PosLeft"]);
			$.form.SetValue("txtPosWidth",rd["PosWidth"]);
			$.form.SetValue("txtPosHeight",rd["PosHeight"]);
			$.form.SetValue("txtPosRotate",rd["PosRotate"]);
			$.form.SetValue("txtLeftBedCnt",rd["LeftBedCnt"]);
			$.form.SetValue("txtRightBedCnt",rd["RightBedCnt"]);
			$.form.SetValue("txtBedWidth",rd["BedWidth"]);
			$.form.SetValue("txtBedHeight",rd["BedHeight"]);
			$.form.SetValue("cboPACWardDr",rd["WardDr"],rd["SubNo"]);
			$.form.SetValue("txtRoomColor",rd["RoomColor"]);
			$.form.SetValue("txtRoomIcon",rd["RoomIcon"]);
		} else {
			$.form.SetValue("txtRoomDesc","");
			$.form.SetValue("RoomDescPos","");
			$.form.SetValue("RoomType","");
			$.form.SetValue("txtPosTop","");
			$.form.SetValue("txtPosLeft","");
			$.form.SetValue("txtPosWidth","");
			$.form.SetValue("txtPosHeight","");
			$.form.SetValue("txtPosRotate","");
			$.form.SetValue("txtLeftBedCnt","");
			$.form.SetValue("txtRightBedCnt","");
			$.form.SetValue("txtBedWidth","");
			$.form.SetValue("txtBedHeight","");
			$.form.SetValue("cboPACWardDr","");
			$.form.SetValue("txtRoomColor","");
			$.form.SetValue("txtRoomIcon","");
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '房间信息编辑',
			content: $('#layer_two'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.LayerTwo_Add(index);
			},
			btn2: function(index, layero){
				obj.LayerTwo_Save(index);
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
	//保存房间信息
	obj.LayerTwo_Save = function(index){
		var rd = obj.gridPACWard.rows({selected: true}).data().toArray()[0]; // 病区
		var LocDr = (rd ? rd["ID"] : ''); // 病区主键
		
		var rdRoomDx = obj.RoomDxlayer_rd;
		var ID = (rdRoomDx ? rdRoomDx["ID"] : '');
		var RoomDesc = $.form.GetValue("txtRoomDesc");
		var RoomDescPos = $.form.GetValue("RoomDescPos");
		var RoomType = $.form.GetValue("RoomType");
		var PosTop = $.form.GetValue("txtPosTop");
		var PosLeft = $.form.GetValue("txtPosLeft");
		var PosWidth = $.form.GetValue("txtPosWidth");
		var PosHeight = $.form.GetValue("txtPosHeight");
		var PosRotate = $.form.GetValue("txtPosRotate");
		var LeftBedCnt = $.form.GetValue("txtLeftBedCnt");
		var RightBedCnt = $.form.GetValue("txtRightBedCnt");
		var BedWidth = $.form.GetValue("txtBedWidth");
		var BedHeight = $.form.GetValue("txtBedHeight");
		var PACWardDr = $.form.GetValue("cboPACWardDr");
		var RoomColor = $.form.GetValue("txtRoomColor");
		var RoomIcon = $.form.GetValue("txtRoomIcon");
		var ErrorStr = "";
		if (RoomDesc == '') {
			ErrorStr += '房间名称不允许为空!<br/>';
		}
		if (PACWardDr == '') {
			ErrorStr += '分区号不允许为空!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + LocDr;
		InputStr += "^" + RoomDesc;
		InputStr += "^" + RoomDescPos;
		InputStr += "^" + RoomType;
		InputStr += "^" + PosTop;
		InputStr += "^" + PosLeft;
		InputStr += "^" + PosWidth;
		InputStr += "^" + PosHeight;
		InputStr += "^" + PosRotate;
		InputStr += "^" + LeftBedCnt;
		InputStr += "^" + RightBedCnt;
		InputStr += "^" + BedWidth;
		InputStr += "^" + BedHeight;
		InputStr += "^" + PACWardDr;
		InputStr += "^" + RoomColor;
		InputStr += "^" + RoomIcon;
		
		var retval =  $.Tool.RunServerMethod("DHCHAI.BT.PACRoom","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridRoom.ajax.reload(function(){
				var rowIndex =  $.Tool.GetTableRowIndex(obj.gridRoom,retval);
				if (rowIndex > -1){
					var rd =obj.gridRoom.row(rowIndex).data();
					obj.RoomDxlayer_rd = rd;
				} else {
					obj.RoomDxlayer_rd = '';
				}
				layer.msg('保存成功!', { icon: 1 });
				layer.close(index);
			}, false);
			layer.close(layer.index);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	}
	// 添加房间信息
	obj.LayerTwo_Add = function(index){
		var rd = obj.gridPACWard.rows({selected: true}).data().toArray()[0]; // 病区
		var LocDr = (rd ? rd["ID"] : ''); // 病区主键

		var RoomDesc = $.form.GetValue("txtRoomDesc");
		var RoomDescPos = $.form.GetValue("RoomDescPos");
		var RoomType = $.form.GetValue("RoomType");
		var PosTop = $.form.GetValue("txtPosTop");
		var PosLeft = $.form.GetValue("txtPosLeft");
		var PosWidth = $.form.GetValue("txtPosWidth");
		var PosHeight = $.form.GetValue("txtPosHeight");
		var PosRotate = $.form.GetValue("txtPosRotate");
		var LeftBedCnt = $.form.GetValue("txtLeftBedCnt");
		var RightBedCnt = $.form.GetValue("txtRightBedCnt");
		var BedWidth = $.form.GetValue("txtBedWidth");
		var BedHeight = $.form.GetValue("txtBedHeight");
		var PACWardDr = $.form.GetValue("cboPACWardDr");
		var RoomColor = $.form.GetValue("txtRoomColor");
		var RoomIcon = $.form.GetValue("txtRoomIcon");
		var ErrorStr = "";
		if (RoomDesc == '') {
			ErrorStr += '房间名称不允许为空!<br/>';
		}
		if (PACWardDr == '') {
			ErrorStr += '分区号不允许为空!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = "";
		InputStr += "^" + LocDr;
		InputStr += "^" + RoomDesc;
		InputStr += "^" + RoomDescPos;
		InputStr += "^" + RoomType;
		InputStr += "^" + PosTop;
		InputStr += "^" + PosLeft;
		InputStr += "^" + PosWidth;
		InputStr += "^" + PosHeight;
		InputStr += "^" + PosRotate;
		InputStr += "^" + LeftBedCnt;
		InputStr += "^" + RightBedCnt;
		InputStr += "^" + BedWidth;
		InputStr += "^" + BedHeight;
		InputStr += "^" + PACWardDr;
		InputStr += "^" + RoomColor;
		InputStr += "^" + RoomIcon;
		
		var retval =  $.Tool.RunServerMethod("DHCHAI.BT.PACRoom","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridRoom.ajax.reload(function(){
				var rowIndex =  $.Tool.GetTableRowIndex(obj.gridRoom,retval);
				if (rowIndex > -1){
					var rd =obj.gridRoom.row(rowIndex).data();
					obj.RoomDxlayer_rd = rd;
				} else {
					obj.RoomDxlayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
				layer.close(index);
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	}
	//*********************** 房间列表 end ***********************
	
	
	//*********************** 床位列表 stt ***********************
    $("#btnsearch_three").on('click', function(){
       $('#gridBed').DataTable().search($('#search_three').val(),true,true).draw();
    });
    $("#search_three").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridBed.search(this.value).draw();
        }
    });
	
    $("#btnAdd_three").addClass('disabled');
    $("#btnEdit_three").addClass('disabled');
    $("#btnDelete_three").addClass('disabled');
	obj.gridBed.on('select', function(e, dt, type, indexes) {
		// 控制关联按钮是否有效
		var rd = dt.rows({selected: true}).data().toArray()[0];
		var selectRows = obj.gridRoom.rows({selected: true}).count();
		$("#btnEdit_three").removeClass('disabled');
	});
	obj.gridBed.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnEdit_three").addClass('disabled');
	});
	obj.gridBed.on('dblclick', 'tr', function(e) {
		var rd = obj.gridBed.row(this).data();
		obj.Bedlayer_rd = rd;
		obj.Layer_three();
	});
	$("#btnEdit_three").on('click', function(){
		var flag = $("#btnEdit_three").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridBed.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridBed.rows({selected: true}).data().toArray()[0];
		
		obj.Bedlayer_rd = rd;
	    obj.Layer_three();
	});
	
	//床位-初始化
	obj.Layer_three = function(){
		$.form.iCheckRender();
        var rd = obj.Bedlayer_rd;
		if (rd){
			$.form.SetValue("txtIndNo",rd["IndNo"]);
			$.form.SetValue("chkActive",(rd["IsActive"]==1));
		} else {
			$.form.SetValue("txtIndNo",'');
			$.form.SetValue("chkActive",true);
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '床位信息编辑', 
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
	// 床位-保存
	obj.LayerThree_Save = function(){		
		var rdBed = obj.Bedlayer_rd;
		var ID = (rdBed ? rdBed["ID"] : '');
		
		var LocDr = rdBed["LocID"];
		var RoomDr = rdBed["RoomID"];
		var BedDesc = rdBed["BedDesc"];
		var ActUserDr = rdBed["ActUserDr"];
		var XCode = rdBed["XCode"];
        var IndNo = $.form.GetValue("txtIndNo");
		var IsActive = $.form.GetValue("chkActive");
        
		var ErrorStr="";
		if (BedDesc == '') {
			ErrorStr += '床位名称不允许为空!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + LocDr;
		InputStr += "^" + BedDesc;
		InputStr += "^" + IndNo;
		InputStr += "^" + "";
		InputStr += "^" + RoomDr;
		InputStr += "^" + XCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.PACBed","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridBed.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridBed,retval);
				if (rowIndex > -1){
					var rd =obj.gridBed.row(rowIndex).data();
					obj.Bedlayer_rd = rd;
				} else {
					obj.Bedlayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
				obj.gridBed.ajax.reload();
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	}
	// A 关联事件
    $('#gridBed').on('click', 'a.editor_edit', function (e) {
        e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridBed.row(tr);
		var rowData = row.data();
		var IsRoomBed = rowData["IsRoomBed"];
		if (IsRoomBed !="0" ) return;
		var selectedRows = obj.gridPACWard.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rdWard = obj.gridPACWard.rows({selected: true}).data().toArray()[0];
		var LocDr = rdWard["ID"];
		
		var selectedRows = obj.gridRoom.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rdRoom = obj.gridRoom.rows({selected: true}).data().toArray()[0];
		var RoomDr = rdRoom["ID"];
		var RoomLeftCont = rdRoom["LeftBedCnt"];
		var RoomRightCont = rdRoom["RightBedCnt"];
		var RoomBedCont = rdRoom["ContBedCnt"];
		
		var rdBed =  rowData;
		var BedID = rdBed["ID"];
		
		var ErrorStr="";
		if ( parseInt(RoomBedCont) >= (parseInt(RoomLeftCont)+parseInt(RoomRightCont)) ) {
			ErrorStr += '已关联床位数不能超过该房间床位总数!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = BedID;
		InputStr += "^" + LocDr;
		InputStr += "^" + RoomDr;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.BT.PACBed","UpdateRoom",InputStr);
		if (parseInt(retval)>0){
			obj.gridBed.ajax.reload(function(){
				var rowIndex =  $.Tool.GetTableRowIndex(obj.gridBed,retval);
				if (rowIndex > -1){
					var rd =obj.gridRoom.row(rowIndex).data();
					obj.Bedlayer_rd = rd;
				} else {
					obj.Bedlayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
			
			rdRoom["ContBedCnt"] = parseInt(rdRoom["ContBedCnt"])+1;
			$("#gridRoom tr").each(function(){
				if ($(this).find("td:first").text() == RoomDr){
					$(this).find("td").eq(5).text(rdRoom["ContBedCnt"]);
				}
			});
		} else {
			layer.msg('保存失败!'+parseInt(retval),{icon: 2});
		}
		
    });
    // A 取消关联事件
    $('#gridBed').on('click', 'a.editor_canceledit', function (e) {
    	e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridBed.row(tr);
		var rowData = row.data();
		var rdBed =  rowData;
		var BedID = rdBed["ID"];
		var IsRoomFlag = rdBed["IsRoomFlag"];
		if (IsRoomFlag !=="1" ) return;
		var selectedRows = obj.gridRoom.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rdRoom = obj.gridRoom.rows({selected: true}).data().toArray()[0];
		var RoomDr = rdRoom["ID"];
		
		layer.confirm( '确认取消房间与床位的关联?', {
			btn: ['确认','取消']
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.BT.PACBed","DeleteRoom",BedID);
				if (parseInt(flg)<0){
					layer.msg('取消失败!',{icon: 2});
				} else {
					obj.gridBed.ajax.reload(function(){
						$("#btnAdd_three").addClass('disabled');
						$("#btnEdit_three").addClass('disabled');
						$("#btnDelete_three").addClass('disabled');
					});
					
					rdRoom["ContBedCnt"] = rdRoom["ContBedCnt"]>0 ? parseInt(rdRoom["ContBedCnt"])-1 : 0;
					$("#gridRoom tr").each(function(){
						if ($(this).find("td:first").text() == RoomDr){
							$(this).find("td").eq(5).text(rdRoom["ContBedCnt"]);
						}
					});
					layer.msg('取消成功!',{icon: 1});
				}
		 });
    });
	//*********************** 床位列表 end ***********************
}
