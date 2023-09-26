//页面Event
function InitCRuleTestSrvWinEvent(obj){
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	obj.TestHtml="";
	/*****搜索功能*****/
    $("#btnsearch_one").on('click', function(){
       $('#gridCRuleTsAb').DataTable().search($('#search_one').val(),true,true).draw();
       
    });
	
    $("#search_one").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleTsAb.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit_one").addClass('disabled');
    $("#btnDelete_one").addClass('disabled');
	obj.gridCRuleTsAb.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").addClass('disabled');
		$("#btnEdit_one").removeClass('disabled');
		$("#btnDelete_one").removeClass('disabled');

		obj.gridCRuleTSSpec.ajax.reload(function(){
			$("#btnAdd_two").removeClass('disabled');
		});
		obj.gridCRuleTSCode.ajax.reload(function(){
			$("#btnAdd_three").removeClass('disabled');
			obj.TestHtml="";
			var Rows = obj.gridCRuleTsAb.rows().count();
			for (var ind = 0; ind < Rows; ind++){
				var rd =  obj.gridCRuleTSCode.rows().data().toArray()[ind];
				if (!rd) continue;
				obj.TestHtml = obj.TestHtml + "<option value='" + rd["TCMID"] + "'>" + rd["TCMCode"] + " " + rd["TCMDesc"] + "</option>";
			} 
		});
		obj.gridCRuleTSResult.ajax.reload(function(){
			$("#btnAdd_four").removeClass('disabled');
		});
		obj.gridCRuleTsAbRstFlag.ajax.reload(function(){
			$("#btnAdd_five").removeClass('disabled');
		});
	});
	
	obj.gridCRuleTsAb.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").removeClass('disabled');
        $("#btnEdit_one").addClass('disabled');
        $("#btnDelete_one").addClass('disabled');

        obj.gridCRuleTSSpec.ajax.reload(function(){
			$("#btnAdd_two").addClass('disabled');
		});
		obj.gridCRuleTSCode.ajax.reload(function(){
			$("#btnAdd_three").addClass('disabled');
			obj.TestHtml="";
		});
		obj.gridCRuleTSResult.ajax.reload(function(){
			$("#btnAdd_four").addClass('disabled');
		});
		obj.gridCRuleTsAbRstFlag.ajax.reload(function(){
			$("#btnAdd_five").addClass('disabled');
		});
	});
	
	obj.gridCRuleTsAb.on('dblclick', 'tr', function(e) {
		var rd = obj.gridCRuleTsAb.row(this).data();
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
		var selectedRows = obj.gridCRuleTsAb.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleTsAb.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_one();

	});

	$("#btnDelete_one").on('click', function(){
		var flag = $("#btnDelete_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridCRuleTsAb.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleTsAb.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestAb","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridCRuleTsAb.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//常规检验项目编辑窗体-初始化
	obj.Layer_one = function(){	
        
        $.form.iCheckRender();
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtTestSet",rd["TestSet"]);
			$.form.SetValue("txtTestCode",rd["TestCode"]);
			$.form.SetValue("chkIsActive",rd["IsActive"]== 1);  
			$.form.SetValue("chkTSPFlag",rd["TSPFlag"]== 1); 
			$.form.SetValue("chkTRFFlag",rd["TRFFlag"]== 1); 
			$.form.SetValue("chkTRFlag",rd["TRFlag"]== 1);  
			$.form.SetValue("chkTRMaxFlg",rd["TRVMaxFlag"]== 1);
			$.form.SetValue("txtMaxValM",rd["MaxValM"]); 
			$.form.SetValue("txtMaxValF",rd["MaxValF"]); 
			$.form.SetValue("chkTRMinFlg",rd["TRVMinFlag"]== 1);
			$.form.SetValue("txtMinValM",rd["MinValM"]); 
			$.form.SetValue("txtMinValF",rd["MinValF"]);
		} else {
			$.form.SetValue("txtTestSet",''); 
			$.form.SetValue("txtTestCode",'');
			$.form.SetValue("chkIsActive",'');
			$.form.SetValue("chkTSPFlag",'');
			$.form.SetValue("chkTRFFlag",'');
			$.form.SetValue("chkTRFlag",'');
			$.form.SetValue("chkTRMaxFlg",'');
			$.form.SetValue("txtMaxValM",'');
			$.form.SetValue("txtMaxValF",'');
			$.form.SetValue("chkTRMinFlg",'');
			$.form.SetValue("txtMinValM",'');
			$.form.SetValue("txtMinValF",'');
		}
			layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '常规检验项目维护编辑', 
			content: $('#layer'),
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

	//常规检验项目配置窗体-保存
	obj.LayerOne_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		
		var TestSet    = $.form.GetValue("txtTestSet");                                                                             
		var TestCode   = $.form.GetValue("txtTestCode");
		var IsActive   = $.form.GetValue("chkIsActive");
		var TSPFlag    = $.form.GetValue("chkTSPFlag");
		var TRFFlag    = $.form.GetValue("chkTRFFlag");
		var TRFlag     = $.form.GetValue("chkTRFlag");
		var TRVMaxFlag = $.form.GetValue("chkTRMaxFlg");
		var MaxValM	   = $.form.GetValue("txtMaxValM");
		var MaxValF	   = $.form.GetValue("txtMaxValF");
		var TRVMinFlag = $.form.GetValue("chkTRMinFlg");
		var MinValM    = $.form.GetValue("txtMinValM");
		var MinValF    = $.form.GetValue("txtMinValF");
		
		if (TestSet == '') {
			layer.alert("常规检验不允许为空",{icon: 0});
			return;
		}
		if (TestCode == '') {
			layer.alert("检验项目不允许为空",{icon: 0});
			return;
		}
		if (parseInt(MaxValM)  < parseInt(MinValM)) {
		    layer.alert("上限值(男)不能低于下限值(男)", { icon: 0 });
		    return;
		}
		if (parseInt(MaxValF)  < parseInt(MinValF)  ) {
		    layer.alert("上限值(女)不能低于下限值(女)", { icon: 0 });
		    return;
		}
		var InputStr = ID;
		InputStr += "^" + TestSet;
		InputStr += "^" + TestCode;
		InputStr += "^" + IsActive;  
		InputStr += "^" + TSPFlag; 
		InputStr += "^" + TRFFlag; 
		InputStr += "^" + TRFlag;  
		InputStr += "^" + TRVMaxFlag;
		InputStr += "^" + MaxValM; 
		InputStr += "^" + MaxValF; 
		InputStr += "^" + TRVMinFlag;
		InputStr += "^" + MinValM; 
		InputStr += "^" + MinValF; 
	   
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestAb","Update",InputStr);
		
		if (parseInt(retval)>0){
			obj.gridCRuleTsAb.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleTsAb,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleTsAb.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('检验医嘱、检验项目重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			};
			
		}
	}
	
	//常规检验项目配置窗体-添加
	obj.LayerOne_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
	   	var TestSet    = $.form.GetValue("txtTestSet");                                                                             
		var TestCode   = $.form.GetValue("txtTestCode");
		var IsActive   = $.form.GetValue("chkIsActive");
		var TSPFlag    = $.form.GetValue("chkTSPFlag");
		var TRFFlag    = $.form.GetValue("chkTRFFlag");
		var TRFlag     = $.form.GetValue("chkTRFlag");
		var TRVMaxFlag = $.form.GetValue("chkTRMaxFlg");
		var MaxValM	   = $.form.GetValue("txtMaxValM");
		var MaxValF	   = $.form.GetValue("txtMaxValF");
		var TRVMinFlag = $.form.GetValue("chkTRMinFlg");
		var MinValM    = $.form.GetValue("txtMinValM");
		var MinValF    = $.form.GetValue("txtMinValF");
		
		if (TestSet == '') {
			layer.alert("检验医嘱不允许为空",{icon: 0});
			return;
		}
		if (TestCode == '') {
			layer.alert("检验项目不允许为空",{icon: 0});
			return;
		}
		if (parseInt(MaxValM)  < parseInt(MinValM)) {
		    layer.alert("上限值(男)不能低于下限值(男)", { icon: 0 });
		    return;
		}
		if (parseInt(MaxValF)  < parseInt(MinValF)  ) {
		    layer.alert("上限值(女)不能低于下限值(女)", { icon: 0 });
		    return;
		}
		var InputStr = ID;
		InputStr += "^" + TestSet;
		InputStr += "^" + TestCode;
		InputStr += "^" + IsActive;  
		InputStr += "^" + TSPFlag; 
		InputStr += "^" + TRFFlag; 
		InputStr += "^" + TRFlag;  
		InputStr += "^" + TRVMaxFlag;
		InputStr += "^" + MaxValM; 
		InputStr += "^" + MaxValF; 
		InputStr += "^" + TRVMinFlag;
		InputStr += "^" + MinValM; 
		InputStr += "^" + MinValF; 
	  
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestAb","Update",InputStr);
		
		if (parseInt(retval)>0){
			obj.gridCRuleTsAb.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleTsAb,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleTsAb.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('检验医嘱、检验项目重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			};
			
		}
	}

	
	//标本
	/*****搜索功能*****/
    $("#btnsearch_two").on('click', function(){
       $('#gridCRuleTSSpec').DataTable().search($('#search_two').val(),true,true).draw();
       
    });
	
    $("#search_two").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleTSSpec.search(this.value).draw();
        }
    });
    /**********************/
    $("#btnAdd_two").addClass('disabled');
    $("#btnEdit_two").addClass('disabled');
    $("#btnDelete_two").addClass('disabled');
	obj.gridCRuleTSSpec.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").addClass('disabled');
		$("#btnEdit_two").removeClass('disabled');
		$("#btnDelete_two").removeClass('disabled');
	});
	
	obj.gridCRuleTSSpec.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").removeClass('disabled');
        $("#btnEdit_two").addClass('disabled');
        $("#btnDelete_two").addClass('disabled');
	});
	
	obj.gridCRuleTSSpec.on('dblclick', 'tr', function(e) {
		var selectedRows = obj.gridCRuleTsAb.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.alert('请先选择常规检验项目，再添加数据!',{icon: 0});
			return;
		}	
		var rd = obj.gridCRuleTSSpec.row(this).data();
		obj.layer_rd = rd;
		obj.Layer_two();
	    
	});
	
	$("#btnAdd_two").on('click', function(){
		var flag = $("#btnAdd_two").hasClass("disabled");
		if(flag) return ;	
		obj.layer_rd = '';
		obj.Layer_two();
		
	});
	
	$("#btnEdit_two").on('click', function(){
		var flag = $("#btnEdit_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridCRuleTSSpec.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleTSSpec.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_two();
	
	});

	$("#btnDelete_two").on('click', function(){
		var flag = $("#btnDelete_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridCRuleTSSpec.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridCRuleTSSpec.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestSpec","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridCRuleTSSpec.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//常规检验-标本编辑窗体-初始化
	obj.Layer_two = function(){	
		$.form.SelectRender("cboTestSpec");  //渲染下拉框	
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("cboTestSpec",rd["TSSpecID"],rd["SpecDesc"]);
		} else {
			$.form.SetValue("cboTestSpec",''); 
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '标本编辑', 
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
	
	
	//常规检验-标本配置窗体-保存
	obj.LayerTwo_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
        
        var Parref     = $.form.GetValue("gridCRuleTsAb");
        //var SubID      = ID.split("||")[1];   
		var SubID      = (ID ?ID.split("||")[1] : ''); 
		var SpecDescDr = $.form.GetValue("cboTestSpec");		
	    var ActUserDr  = $.LOGON.USERID;
		
		if (SpecDescDr == '') {
			layer.alert("标本不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = Parref;
		InputStr += "^" + SubID;
		InputStr += "^" + SpecDescDr;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
	
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestSpec","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleTSSpec.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleTSSpec,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleTSSpec.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if (parseInt(retval)=='-2') {
				layer.alert('该标本已关联项目,不允许再关联其他项目',{icon: 0});
			} else{
				layer.msg('保存失败!',{icon: 2});
			}
			
		}
	}
	
	//常规检验-标本配置窗体-添加
	obj.LayerTwo_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
	    var Parref     = $.form.GetValue("gridCRuleTsAb");
		var SpecDescDr = $.form.GetValue("cboTestSpec");     
	    var ActUserDr  = $.LOGON.USERID;
		
		if (SpecDescDr == '') {
			layer.alert("标本不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = Parref;
		InputStr += "^" + ID;
		InputStr += "^" + SpecDescDr;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		
	    var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestSpec","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleTSSpec.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleTSSpec,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleTSSpec.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if (parseInt(retval)=='-2') {
				layer.alert('该标本已关联项目,不允许再关联其他项目',{icon: 0});
			} else{
				layer.msg('保存失败!',{icon: 2});
			}
			
		}
	}
	
	//检验项目
	/*****搜索功能*****/
    $("#btnsearch_three").on('click', function(){
       $('#gridCRuleTSCode').DataTable().search($('#search_three').val(),true,true).draw();
       
    });
	
    $("#search_three").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleTSCode.search(this.value).draw();
        }
    });
    /**********************/
    $("#btnAdd_three").addClass('disabled');
    $("#btnEdit_three").addClass('disabled');
    $("#btnDelete_three").addClass('disabled');
	obj.gridCRuleTSCode.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_three").addClass('disabled');
		$("#btnEdit_three").removeClass('disabled');
		$("#btnDelete_three").removeClass('disabled');
	});

	obj.gridCRuleTSCode.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_three").removeClass('disabled');
        $("#btnEdit_three").addClass('disabled');
        $("#btnDelete_three").addClass('disabled');
	});
	
	obj.gridCRuleTSCode.on('dblclick', 'tr', function(e) {
		var selectedRows = obj.gridCRuleTsAb.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.alert('请先选择常规检验项目，再添加数据!',{icon: 0});
			return;
		}	
		var rd = obj.gridCRuleTSCode.row(this).data();
		obj.layer_rd = rd;
		obj.Layer_three();
	    
	});
	
	$("#btnAdd_three").on('click', function(){
		var flag = $("#btnAdd_three").hasClass("disabled");
		if(flag) return ;	
		obj.layer_rd = '';
		obj.Layer_three();
		
	});
	
	$("#btnEdit_three").on('click', function(){
		var flag = $("#btnEdit_three").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridCRuleTSCode.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridCRuleTSCode.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_three();
	
	});

	$("#btnDelete_three").on('click', function(){
		var flag = $("#btnDelete_three").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridCRuleTSCode.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridCRuleTSCode.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestCode","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.TestHtml = obj.TestHtml.replace("<option value='"+rd["TCMID"]+"'>"+rd["TCMCode"]+" "+rd["TCMDesc"]+"</option>","");
					obj.gridCRuleTSCode.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//常规检验-检验项目编辑窗体-初始化
	obj.Layer_three = function(){		
	    $.form.SelectRender("cboTestCode");  //渲染下拉框
	  
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("cboTestCode",rd["TCMID"],rd["TCMDesc"]);
		} else {
			$.form.SetValue("cboTestCode",''); 
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '检验项目编辑', 
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
	
	//常规检验-检验项目配置窗体-保存
	obj.LayerThree_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
        
        var Parref     = $.form.GetValue("gridCRuleTsAb");
        var SubID      = (ID ?ID.split("||")[1] : '');              
		var TestCodeDr = $.form.GetValue("cboTestCode");		
	    var ActUserDr  = $.LOGON.USERID;
		
		if (TestCodeDr == '') {
			layer.alert("检验项目不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = Parref;
		InputStr += "^" + SubID;
		InputStr += "^" + TestCodeDr;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
	   
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestCode","Update",InputStr);
		
		if (parseInt(retval)>0){
			obj.gridCRuleTSCode.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleTSCode,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleTSCode.row(rowIndex).data();
					obj.layer_rd = rd;
					if (obj.TestHtml.indexOf(rd["TCMCode"])<0){
						obj.TestHtml=obj.TestHtml+"<option value='"+rd["TCMID"]+"'>"+rd["TCMCode"]+" "+rd["TCMDesc"]+"</option>";
					}
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if (parseInt(retval)=='-2') {
				layer.alert('该检验项目已关联检验,不允许再关联其他检验',{icon: 0});
			} else{
				layer.msg('保存失败!',{icon: 2});
			}
			
		}
	}
	
	//常规检验-检验项目配置窗体-添加
	obj.LayerThree_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
	    var Parref     = $.form.GetValue("gridCRuleTsAb");
        var SubID      = (ID ?ID.split("||")[1] : '');              
		var TestCodeDr = $.form.GetValue("cboTestCode");		
	    var ActUserDr  = $.LOGON.USERID;
		
		if (TestCodeDr == '') {
			layer.alert("检验项目不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = Parref;
		InputStr += "^" + SubID;
		InputStr += "^" + TestCodeDr;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
	
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestCode","Update",InputStr);

		if (parseInt(retval)>0){
			obj.gridCRuleTSCode.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleTSCode,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleTSCode.row(rowIndex).data();
					obj.layer_rd = rd;
					if (obj.TestHtml.indexOf(rd["TCMCode"])<0){
						obj.TestHtml=obj.TestHtml+"<option value='"+rd["TCMID"]+"'>"+rd["TCMCode"]+" "+rd["TCMDesc"]+"</option>";
					}
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if (parseInt(retval)=='-2') {
				layer.alert('该检验项目已关联检验,不允许再关联其他检验',{icon: 0});
			} else{
				layer.msg('保存失败!',{icon: 2});
			}
			
		}
	}
	//检验结果
	/*****搜索功能*****/
    $("#btnsearch_four").on('click', function(){
       $('#gridCRuleTSResult').DataTable().search($('#search_four').val(),true,true).draw();
       
    });
	
    $("#search_four").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleTSResult.search(this.value).draw();
        }
    });
    /**********************/
    $("#btnAdd_four").addClass('disabled');
    $("#btnEdit_four").addClass('disabled');
    $("#btnDelete_four").addClass('disabled');
	obj.gridCRuleTSResult.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_four").addClass('disabled');
		$("#btnEdit_four").removeClass('disabled');
		$("#btnDelete_four").removeClass('disabled');
	});

	obj.gridCRuleTSResult.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_four").removeClass('disabled');
        $("#btnEdit_four").addClass('disabled');
        $("#btnDelete_four").addClass('disabled');
	});
	
	obj.gridCRuleTSResult.on('dblclick', 'tr', function(e) {
		var selectedRows = obj.gridCRuleTsAb.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.alert('请先选择常规检验项目，再添加数据!',{icon: 0});
			return;
		}	
		var rd = obj.gridCRuleTSResult.row(this).data();
		obj.layer_rd = rd;
		obj.Layer_four();
	    
	});
	
	$("#btnAdd_four").on('click', function(){
		var flag = $("#btnAdd_four").hasClass("disabled");
		if(flag) return ;	
		obj.layer_rd = '';
		obj.Layer_four();
		
	});
	
	$("#btnEdit_four").on('click', function(){
		var flag = $("#btnEdit_four").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridCRuleTSResult.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridCRuleTSResult.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_four();
	
	});

	$("#btnDelete_four").on('click', function(){
		var flag = $("#btnDelete_four").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridCRuleTSResult.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridCRuleTSResult.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestResult","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					 obj.gridCRuleTSResult.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});

  
	//检验结果编辑窗体-初始化
	obj.Layer_four = function(){
		$.form.SelectRender("cboTestResult");  //渲染下拉框
		$("#cboTestCode1").html(obj.TestHtml);
		$.form.SelectRender("cboTestCode1");  //渲染下拉框
		$.form.iCheckRender(); //单选按钮
		$('#cboTestCode1').on('change',function(){
			$.form.SelectRender("cboTestResult");  //渲染下拉框
		});
        var rd = obj.layer_rd;
        
        var TSrd =  obj.gridCRuleTSCode.rows({selected: true}).data().toArray()[0];
		if (rd){
			$.form.SetValue("cboTestCode1",rd["TCMapAbID"],rd["TestCode"]);
			$.form.SetValue("cboTestResult",rd["TestID"],rd["TestResult"]);
		} else {
			if (TSrd) {
				$.form.SetValue("cboTestCode1",TSrd["TCMID"],TSrd["TCMCode"]);
				$.form.SelectRender('cboTestResult');
			}else {
				$.form.SetValue('cboTestCode1');
				$.form.SetValue("cboTestResult",'');
			}	
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '检验结果编辑', 
			content: $('#layer_four'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.LayerFour_Add();
			},
			btn2: function(index, layero){
				obj.LayerFour_Save();
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
	
	//常规检验-检验结果配置窗体-保存
	obj.LayerFour_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
        
        var Parref       = $.form.GetValue("gridCRuleTsAb");
        var SubID        = (ID ?ID.split("||")[1] : '');      
		var TestResultDr = $.form.GetValue("cboTestResult");
	    var ActUserDr    = $.LOGON.USERID;
		
		if (TestResultDr == '') {
			layer.alert("检验结果不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = Parref;
		InputStr += "^" + SubID;
		InputStr += "^" + TestResultDr;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestResult","Update",InputStr);
	
		if (parseInt(retval)>0){
			obj.gridCRuleTSResult.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleTSResult,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleTSResult.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if (parseInt(retval)=='-2') {
				layer.alert('该检验结果已关联项目,不允许再关联其他项目',{icon: 0});
			} else{
				layer.msg('保存失败!',{icon: 2});
			}
			
		}
	}
	
	//常规检验-检验结果配置窗体-添加
	obj.LayerFour_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	
	    var Parref       = $.form.GetValue("gridCRuleTsAb");
        var SubID        = (ID ?ID.split("||")[1] : '');              
		var TestResultDr = $.form.GetValue("cboTestResult");
	    var ActUserDr    = $.LOGON.USERID;
		
		if (TestResultDr == '') {
			layer.alert("检验结果不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = Parref;
		InputStr += "^" + SubID;
		InputStr += "^" + TestResultDr;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestResult","Update",InputStr);
		
		if (parseInt(retval)>0){
			obj.gridCRuleTSResult.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleTSResult,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleTSResult.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if (parseInt(retval)=='-2') {
				layer.alert('该检验结果已关联项目,不允许再关联其他项目',{icon: 0});
			} else{
				layer.msg('保存失败!',{icon: 2});
			}
			
		}
	}
	//异常标记
	/*****搜索功能*****/
    $("#btnsearch_five").on('click', function(){
       $('#gridCRuleTsAbRstFlag').DataTable().search($('#search_five').val(),true,true).draw();
       
    });
	
    $("#search_five").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleTsAbRstFlag.search(this.value).draw();
        }
    });
    /**********************/
    $("#btnAdd_five").addClass('disabled');
    $("#btnEdit_five").addClass('disabled');
    $("#btnDelete_five").addClass('disabled');
	obj.gridCRuleTsAbRstFlag.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_five").addClass('disabled');
		$("#btnEdit_five").removeClass('disabled');
		$("#btnDelete_five").removeClass('disabled');
	});

	obj.gridCRuleTsAbRstFlag.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_five").removeClass('disabled');
        $("#btnEdit_five").addClass('disabled');
        $("#btnDelete_five").addClass('disabled');
	});
	
	obj.gridCRuleTsAbRstFlag.on('dblclick', 'tr', function(e) {
		var selectedRows = obj.gridCRuleTsAb.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.alert('请先选择常规检验项目，再添加数据!',{icon: 0});
			return;
		}	
		var rd = obj.gridCRuleTsAbRstFlag.row(this).data();
		obj.layer_rd = rd;
		obj.Layer_five();
	    
	});
	
	$("#btnAdd_five").on('click', function(){
		var flag = $("#btnAdd_five").hasClass("disabled");
		if(flag) return ;	
		obj.layer_rd = '';
		obj.Layer_five();
		
	});
	
	$("#btnEdit_five").on('click', function(){
		var selectedRows = obj.gridCRuleTsAbRstFlag.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridCRuleTsAbRstFlag.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_five();
	
	});

	$("#btnDelete_five").on('click', function(){
		var selectedRows =  obj.gridCRuleTsAbRstFlag.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridCRuleTsAbRstFlag.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestAbFlag","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					 obj.gridCRuleTsAbRstFlag.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});

  
    //常规检验-异常标志编辑窗体-初始化
	obj.Layer_five = function(){
		$.form.SelectRender("cboRstFlag");  //渲染下拉框
		$("#cboTestCode2").html(obj.TestHtml);
		$.form.SelectRender("cboTestCode2");  //渲染下拉框
		$('#cboTestCode2').on('change',function(){
			$.form.SelectRender("cboRstFlag");  //渲染下拉框
		});
        var rd = obj.layer_rd;
        
        var TSrd =  obj.gridCRuleTSCode.rows({selected: true}).data().toArray()[0];
		if (rd){
			$.form.SetValue("cboTestCode2",rd["TCMapAbID"],rd["TestCode"]);
			$.form.SetValue("cboRstFlag",rd["TSRstID"],rd["TSRstFlag"]);
		} else {
			if (TSrd) {
				$.form.SetValue("cboTestCode2",TSrd["TCMID"],TSrd["TCMCode"]);
				$.form.SelectRender('cboRstFlag');
			}else {
				$.form.SetValue('cboTestCode2');
				$.form.SetValue("cboRstFlag",'');
			}	
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '异常标志编辑', 
			content: $('#layer_five'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.LayerFive_Add();
			},
			btn2: function(index, layero){
				obj.LayerFive_Save();
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
		
	//常规检验-异常标志配置窗体-保存
	obj.LayerFive_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
        
        var Parref    = $.form.GetValue("gridCRuleTsAb");
        var SubID     = (ID ?ID.split("||")[1] : '');                  
		var RstFlagDr = $.form.GetValue("cboRstFlag");
	    var ActUserDr = $.LOGON.USERID;
		
		if (RstFlagDr == '') {
			layer.alert("异常标志不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = Parref;
		InputStr += "^" + SubID;
		InputStr += "^" + RstFlagDr;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
	    
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestAbFlag","Update",InputStr);
		
		if (parseInt(retval)>0){
			obj.gridCRuleTsAbRstFlag.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleTsAbRstFlag,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleTsAbRstFlag.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if (parseInt(retval)=='-2') {
				layer.alert('该异常标志已关联项目,不允许再关联其他项目',{icon: 0});
			} else{
				layer.msg('保存失败!',{icon: 2});
			}
			
		}
	}
	
	//常规检验-异常标志配置窗体-添加
	obj.LayerFive_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	     
        var Parref    = $.form.GetValue("gridCRuleTsAb");
        var SubID     = (ID ?ID.split("||")[1] : '');                  
		var RstFlagDr = $.form.GetValue("cboRstFlag");
	    var ActUserDr = $.LOGON.USERID;
		
		if (RstFlagDr == '') {
			layer.alert("异常标志不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = Parref;
		InputStr += "^" + SubID;
		InputStr += "^" + RstFlagDr;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUserDr;
	    
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleTestAbFlag","Update",InputStr);
		
		if (parseInt(retval)>0){
			obj.gridCRuleTsAbRstFlag.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleTsAbRstFlag,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleTsAbRstFlag.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if (parseInt(retval)=='-2') {
				layer.alert('该异常标志已关联项目,不允许再关联其他项目',{icon: 0});
			} else{
				layer.msg('保存失败!',{icon: 2});
			}
			
			
		}
	}
}
