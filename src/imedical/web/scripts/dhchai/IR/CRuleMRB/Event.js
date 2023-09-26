//页面Event
function InitDictionaryWinEvent(obj){
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	

	 /*****搜索功能*****/
    $("#btnsearch_one").on('click', function(){
       $('#gridCRuleMRB').DataTable().search($('#search_one').val(),true,true).draw();
       
    });
	
    $("#search_one").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridCRuleMRB.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit_one").addClass('disabled');
    $("#btnDelete_one").addClass('disabled');	
	obj.gridCRuleMRB.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").addClass('disabled');
		$("#btnEdit_one").removeClass('disabled');
		$("#btnDelete_one").removeClass('disabled');
		obj.gridMRBBact.ajax.reload(function(){
			$("#btnAdd_two").removeClass('disabled');
		});
		obj.gridMRBAnti.ajax.reload(function(){
			$("#btnAdd_three").removeClass('disabled');
		});
		obj.gridMRBKeys.ajax.reload(function(){
			$("#btnAdd_four").removeClass('disabled');
		});
		obj.gridIsolate.ajax.reload(function(){
			$("#btnAdd_five").removeClass('disabled');
		});		
	});
	
	obj.gridCRuleMRB.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").removeClass('disabled');
        $("#btnEdit_one").addClass('disabled');
        $("#btnDelete_one").addClass('disabled');
        obj.gridMRBBact.ajax.reload(function(){
			$("#btnAdd_two").addClass('disabled');
		});
		obj.gridMRBAnti.ajax.reload(function(){
			$("#btnAdd_three").addClass('disabled');
		});
		obj.gridMRBKeys.ajax.reload(function(){
			$("#btnAdd_four").addClass('disabled');
		});		
   		obj.gridIsolate.ajax.reload(function(){
			$("#btnAdd_five").addClass('disabled');
		});
	});
	
	obj.gridCRuleMRB.on('dblclick', 'tr', function(e) {
		var rd = obj.gridCRuleMRB.row(this).data();
		
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
		var selectedRows = obj.gridCRuleMRB.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_one();
		
	});
	
	$("#btnDelete_one").on('click', function(){
		var flag = $("#btnDelete_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridCRuleMRB.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRB","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridCRuleMRB.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	//多重耐药菌分类
	obj.Layer_one = function(){
		$.form.iCheckRender();
	    $.form.SelectRender("cboMRBCat");  //渲染下拉框
		
		var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtBTCode",rd["BTCode"]);
			$.form.SetValue("txtBTDesc",rd["BTDesc"]);
			$.form.SetValue("cboMRBCat",rd["BTCatDr"],rd["BTCatDesc"]);
			$.form.SetValue("chkIsActive",rd["BTIsActive"]== 1);
			$.form.SetValue("chkIsRuleCheck",rd["IsRuleCheck"]== 1);
			$.form.SetValue("chkIsAntiCheck",rd["IsAntiCheck"]== 1);
			$.form.SetValue("txtAnitCatCnt",rd["AnitCatCnt"]);
			$.form.SetValue("txtAnitCatCnt2",rd["AnitCatCnt2"]);	
			$.form.SetValue("chkIsKeyCheck",rd["IsKeyCheck"]== 1);
		} else {
			$.form.SetValue("txtBTCode",'');
			$.form.SetValue("txtBTDesc",'');
			$.form.SetValue("cboMRBCat",'');
			$.form.SetValue("chkIsActive",true);
			$.form.SetValue("chkIsRuleCheck",'');
			$.form.SetValue("chkIsAntiCheck",'');
			$.form.SetValue("txtAnitCatCnt",'');
			$.form.SetValue("txtAnitCatCnt2",'');
			$.form.SetValue("chkIsKeyCheck",'');
		}
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '多重耐药菌分类编辑', 
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
	
	//多重耐药菌分类编辑窗体-保存
	obj.LayerOne_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
	
		var BTCode      = $.form.GetValue("txtBTCode");
		var BTDesc      = $.form.GetValue("txtBTDesc");
		var MRBCatDr    = $.form.GetValue("cboMRBCat");
		var IsActive    = $.form.GetValue("chkIsActive");
		var ActUser     = $.LOGON.USERID;
		var IsRuleCheck = $.form.GetValue("chkIsRuleCheck");
		var IsAntiCheck = $.form.GetValue("chkIsAntiCheck");
		var AnitCatCnt  = $.form.GetValue("txtAnitCatCnt");
		var AnitCatCnt2 = $.form.GetValue("txtAnitCatCnt2");
		var IsKeyCheck  = $.form.GetValue("chkIsKeyCheck");
		
		var ErrorStr = "";
		if (BTCode == '') {
			ErrorStr += '代码不允许为空!<br/>';
		}
		if (BTDesc == '') {
			ErrorStr += '名称不允许为空!<br/>';
		}
		
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + BTCode;
		InputStr += "^" + BTDesc;
		InputStr += "^" + MRBCatDr;
		InputStr += "^" + IsActive;
		InputStr += "^" + IsRuleCheck;
		InputStr += "^" + IsAntiCheck
		InputStr += "^" + AnitCatCnt;
		InputStr += "^" + AnitCatCnt2;
		InputStr += "^" + IsKeyCheck;
		InputStr += "^" +'';
		InputStr += "^" +'';
		InputStr += "^" + ActUser;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRB","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleMRB.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridCRuleMRB,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleMRB.row(rowIndex).data();
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
	//多重耐药菌分类编辑窗体-添加
	obj.LayerOne_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		
		var BTCode      = $.form.GetValue("txtBTCode");
		var BTDesc      = $.form.GetValue("txtBTDesc");
		var MRBCatDr    = $.form.GetValue("cboMRBCat");
		var IsActive    = $.form.GetValue("chkIsActive");
		var ActUser     = $.LOGON.USERID;
		var IsRuleCheck = $.form.GetValue("chkIsRuleCheck");
		var IsAntiCheck = $.form.GetValue("chkIsAntiCheck");
		var AnitCatCnt  = $.form.GetValue("txtAnitCatCnt");
		var AnitCatCnt2 = $.form.GetValue("txtAnitCatCnt2");
		var IsKeyCheck  = $.form.GetValue("chkIsKeyCheck");
	
		var ErrorStr = "";
		if (BTCode == '') {
			ErrorStr += '代码不允许为空!<br/>';
		}
		if (BTDesc == '') {
			ErrorStr += '名称不允许为空!<br/>';
		}
		
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + BTCode;
		InputStr += "^" + BTDesc;
		InputStr += "^" + MRBCatDr;
		InputStr += "^" + IsActive;
		InputStr += "^" + IsRuleCheck;
		InputStr += "^" + IsAntiCheck
		InputStr += "^" + AnitCatCnt;
		InputStr += "^" + AnitCatCnt2;
		InputStr += "^" + IsKeyCheck;
		InputStr += "^" +'';
		InputStr += "^" +'';
		InputStr += "^" + ActUser;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRB","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridCRuleMRB.ajax.reload(function(){
				var rowIndex =$.Tool.GetTableRowIndex(obj.gridCRuleMRB,retval);
				if (rowIndex > -1){
					var rd =obj.gridCRuleMRB.row(rowIndex).data();
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
	
	/************************************* 多重耐药菌-细菌 start ***************************************/	
	
	$("#btnsearch_two").on('click', function(){
       $('#gridMRBBact').DataTable().search($('#search_two').val(),true,true).draw();
       
    });
	
    $("#search_two").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridMRBBact.search(this.value).draw();
        }
    });
    $("#btnAdd_two").addClass('disabled');
    $("#btnEdit_two").addClass('disabled');
    $("#btnDelete_two").addClass('disabled');
	obj.gridMRBBact.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").addClass('disabled');
		$("#btnEdit_two").removeClass('disabled');
		$("#btnDelete_two").removeClass('disabled');
	});
	
	obj.gridMRBBact.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").removeClass('disabled');
        $("#btnEdit_two").addClass('disabled');
        $("#btnDelete_two").addClass('disabled');
	});
	obj.gridMRBBact.on('dblclick', 'tr', function(e) {
		var selectedRows = obj.gridCRuleMRB.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.alert('请先选择多重耐药菌分类，再添加数据!',{icon: 0});
			return;
		}	
		var rd = obj.gridMRBBact.row(this).data();
		obj.Bactlayer_rd = rd;
		obj.Layer_two();
	    
	});
	$("#btnAdd_two").on('click', function(){
		var flag = $("#btnAdd_two").hasClass("disabled");
		if(flag) return ;	
		obj.Bactlayer_rd = '';
		obj.Layer_two();
	});
	
	$("#btnEdit_two").on('click', function(){
		var flag = $("#btnEdit_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridMRBBact.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridMRBBact.rows({selected: true}).data().toArray()[0];
		
		obj.Bactlayer_rd = rd;
	   	obj.Layer_two();
	});

	$("#btnDelete_two").on('click', function(){
		var flag = $("#btnDelete_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridMRBBact.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridMRBBact.rows({selected: true}).data().toArray()[0];
	
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRBBact","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridMRBBact.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	obj.Layer_two = function(){

		var rd = obj.Bactlayer_rd;
		$.form.SelectRender("cboBact");  //渲染下拉框
		if (rd){
			$.form.SetValue("cboBact",rd["BactID"],rd["BacDesc"]);
		} else {
			$.form.SetValue("cboBact","");
		}
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '细菌编辑', 
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
	//保存细菌名称
	obj.LayerTwo_Save = function(){
		var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0]; //多重耐药菌
		var parref = (rd ? rd["ID"] : ''); //多重耐药菌主键
		
		var rdBact = obj.Bactlayer_rd;
		var ID = (rdBact ? rdBact["ID"] : '');
		var SubID = (ID ? ID.split("||")[1] : '');
		
		var BactDr = $.form.GetValue("cboBact");

		var ErrorStr = "";
		if (BactDr == '') {
			ErrorStr += '细菌不允许为空!<br/>';
		}
	
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = parref;
		InputStr += "^" + SubID;
		InputStr += "^" + BactDr;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		var retval =  $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRBBact","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridMRBBact.ajax.reload(function(){
				var rowIndex =  $.Tool.GetTableRowIndex(obj.gridMRBBact,retval);
				if (rowIndex > -1){
					var rd =obj.gridMRBBact.row(rowIndex).data();
					obj.Bactlayer_rd = rd;
				} else {
					obj.Bactlayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('细菌名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//保存细菌名称
	obj.LayerTwo_Add = function(){
		
		var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0]; //多重耐药菌
		var parref = (rd ? rd["ID"] : ''); //多重耐药菌主键
		
		var rdBact = "";
		var ID = (rdBact ? rdBact["ID"] : '');
		var SubID = (ID ? ID.split("||")[1] : '');
		
		var BactDr = $.form.GetValue("cboBact");

		var ErrorStr = "";
		if (BactDr == '') {
			ErrorStr += '细菌不允许为空!<br/>';
		}
	
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = parref;
		InputStr += "^" + SubID;
		InputStr += "^" + BactDr;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		var retval =  $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRBBact","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridMRBBact.ajax.reload(function(){
				var rowIndex =  $.Tool.GetTableRowIndex(obj.gridMRBBact,retval);
				if (rowIndex > -1){
					var rd =obj.gridMRBBact.row(rowIndex).data();
					obj.Bactlayer_rd = rd;
				} else {
					obj.Bactlayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('细菌名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	/************************************* 多重耐药菌-细菌 end ***************************************/
	
	/************************************* 多重耐药菌-抗生素 start ***************************************/	
	/*****搜索功能*****/
    $("#btnsearch_three").on('click', function(){
       $('#gridMRBAnti').DataTable().search($('#search_three').val(),true,true).draw();
       
    });
	
    $("#search_three").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridMRBAnti.search(this.value).draw();
        }
    });
    /**********************/
    $("#btnAdd_three").addClass('disabled');
    $("#btnEdit_three").addClass('disabled');
    $("#btnDelete_three").addClass('disabled');
	obj.gridMRBAnti.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_three").addClass('disabled');
		$("#btnEdit_three").removeClass('disabled');
		$("#btnDelete_three").removeClass('disabled');
	});

	obj.gridMRBAnti.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_three").removeClass('disabled');
        $("#btnEdit_three").addClass('disabled');
        $("#btnDelete_three").addClass('disabled');
	});
	
	obj.gridMRBAnti.on('dblclick', 'tr', function(e) {
		var selectedRows = obj.gridCRuleMRB.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.alert('请先选择多重耐药菌分类，再添加数据!',{icon: 0});
			return;
		}	
		var rd = obj.gridMRBAnti.row(this).data();
		obj.Antilayer_rd = rd;
		obj.Layer_three();
	    
	});
	
	$("#btnAdd_three").on('click', function(){
		var flag = $("#btnAdd_three").hasClass("disabled");
		if(flag) return ;	
		obj.Antilayer_rd = '';
		obj.Layer_three();
		
	});
	
	$("#btnEdit_three").on('click', function(){
		var flag = $("#btnEdit_three").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridMRBAnti.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridMRBAnti.rows({selected: true}).data().toArray()[0];
		
		obj.Antilayer_rd = rd;
	    obj.Layer_three();
	
	});

	$("#btnDelete_three").on('click', function(){
		var flag = $("#btnDelete_three").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridMRBAnti.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridMRBAnti.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRBAnti","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					 obj.gridMRBAnti.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//多重耐药菌-抗生素-初始化
	obj.Layer_three = function(){		
	    $.form.SelectRender("cboLabAntiCat");  //渲染下拉框
        $.form.SelectRender("cboLabAnti");     //渲染下拉框
		$('#cboLabAntiCat').on('change',function(){
			$.form.SelectRender("cboLabAnti");  //渲染下拉框
		});
			
        var rd = obj.Antilayer_rd;
		if (rd){
			$('#cboLabAntiCat').val(rd["AntiCatDr"]).select2();
			$.form.SelectRender("cboLabAnti");     //渲染下拉框
			$('#cboLabAnti').val(rd["AntiID"]).select2();   
		} else {
			$.form.SetValue("cboLabAntiCat",''); 
			$.form.SetValue("cboLabAnti",''); 
			
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '抗生素编辑', 
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
	
	//多重耐药菌-抗生素-保存
	obj.LayerThree_Save = function(){
		var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0]; //多重耐药菌
		var parref = (rd ? rd["ID"] : ''); //多重耐药菌主键

		var rdAnti = obj.Antilayer_rd;
		var ID = (rdAnti ? rdAnti["ID"] : '');
		var SubID = (ID ? ID.split("||")[1] : '');
		
		var AntiCatDr = $.form.GetValue("cboLabAntiCat");
        var AntiDr    = $.form.GetValue("cboLabAnti");

        if ((AntiCatDr==0)&&(AntiDr !="")) {
	        var AntiCatInfo= $.Tool.RunServerMethod("DHCHAI.DPS.LabAntiSrv","GetCatByAnti",AntiDr);
	        AntiCatDr = (AntiCatInfo ? AntiCatInfo.split("^")[0] : '');
        }
        
		var ErrorStr = "";
		
		if ((AntiCatDr == '')&&(AntiDr!="")) {
			ErrorStr += '抗生素没有关联的分类!<br/>';
		}
	    if ((AntiCatDr == 0)&&(AntiDr =='')) {
			ErrorStr += '抗生素为空时抗生素分类不允许为全部!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		var InputStr = parref;
		InputStr += "^" + SubID;
		InputStr += "^" + AntiCatDr;
		InputStr += "^" + AntiDr;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRBAnti","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridMRBAnti.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridMRBAnti,retval);
				if (rowIndex > -1){
					var rd =obj.gridMRBAnti.row(rowIndex).data();
					obj.Antilayer_rd = rd;
				} else {
					obj.Antilayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('抗生素分类重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//多重耐药菌-抗生素-添加
	obj.LayerThree_Add = function(){
		var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0]; //多重耐药菌
		var parref = (rd ? rd["ID"] : ''); //多重耐药菌主键

		var rdAnti = "";
		var ID = (rdAnti ? rdAnti["ID"] : '');
		var SubID = (ID ? ID.split("||")[1] : '');
		
		var AntiCatDr = $.form.GetValue("cboLabAntiCat");
        var AntiDr    = $.form.GetValue("cboLabAnti");
        if ((AntiCatDr==0)&&(AntiDr !="")) {
	        var AntiCatInfo= $.Tool.RunServerMethod("DHCHAI.DPS.LabAntiSrv","GetCatByAnti",AntiDr);
	        AntiCatDr = (AntiCatInfo ? AntiCatInfo.split("^")[0] : '');
        }
        
		var ErrorStr = "";
		
		if ((AntiCatDr == '')&&(AntiDr!="")) {
			ErrorStr += '抗生素没有关联的分类!<br/>';
		}
	    if ((AntiCatDr == 0)&&(AntiDr =='')) {
			ErrorStr += '抗生素为空时抗生素分类不允许为全部!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = parref;
		InputStr += "^" + SubID;
		InputStr += "^" + AntiCatDr;
		InputStr += "^" + AntiDr;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRBAnti","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridMRBAnti.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridMRBAnti,retval);
				if (rowIndex > -1){
					var rd =obj.gridMRBAnti.row(rowIndex).data();
					obj.Antilayer_rd = rd;
				} else {
					obj.Antilayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('抗生素分类重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	/************************************* 多重耐药菌-抗生素 end ***************************************/
	
	/************************************* 多重耐药菌-关键词 start ***************************************/	
	 $("#btnsearch_four").on('click', function(){
       $('#gridMRBKeys').DataTable().search($('#search_four').val(),true,true).draw();
       
    });
	
    $("#search_four").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridMRBKeys.search(this.value).draw();
        }
    });
    /**********************/
    $("#btnAdd_four").addClass('disabled');
    $("#btnEdit_four").addClass('disabled');
    $("#btnDelete_four").addClass('disabled');
	obj.gridMRBKeys.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_four").addClass('disabled');
		$("#btnEdit_four").removeClass('disabled');
		$("#btnDelete_four").removeClass('disabled');
	});

	obj.gridMRBKeys.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_four").removeClass('disabled');
        $("#btnEdit_four").addClass('disabled');
        $("#btnDelete_four").addClass('disabled');
	});
	
	obj.gridMRBKeys.on('dblclick', 'tr', function(e) {
		var selectedRows = obj.gridCRuleMRB.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.alert('请先选择多重耐药菌分类，再添加数据!',{icon: 0});
			return;
		}	
		var rd = obj.gridMRBKeys.row(this).data();
		obj.Keylayer_rd = rd;
		obj.Layer_four();
	    
	});
	
	$("#btnAdd_four").on('click', function(){
		var flag = $("#btnAdd_four").hasClass("disabled");
		if(flag) return ;	
		obj.Keylayer_rd = '';
		obj.Layer_four();
		
	});
	
	$("#btnEdit_four").on('click', function(){
		var flag = $("#btnEdit_four").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridMRBKeys.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridMRBKeys.rows({selected: true}).data().toArray()[0];
		
		obj.Keylayer_rd = rd;
	    obj.Layer_four();
	
	});

	$("#btnDelete_four").on('click', function(){
		var flag = $("#btnDelete_four").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridMRBKeys.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridMRBKeys.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRBKeys","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					 obj.gridMRBKeys.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});

  
	//多重耐药菌-关键词-初始化
	obj.Layer_four = function(){	
        var rd = obj.Keylayer_rd;
		if (rd){
			$.form.SetValue("txtKeyWord",rd["KeyWord"]);
		} else {
			$.form.SetValue("txtKeyWord",''); 
		}
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '关键字编辑', 
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
	
	//多重耐药菌-关键词-保存
	obj.LayerFour_Save = function(){
			
		var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0]; //多重耐药菌
		var parref = (rd ? rd["ID"] : ''); //多重耐药菌主键
		var rdKey = obj.Keylayer_rd;
		var ID = (rdKey ? rdKey["ID"] : '');
		var SubID = (ID ? ID.split("||")[1] : '');
		
		var KeyWord = $.form.GetValue("txtKeyWord");

		var ErrorStr = "";
		if (KeyWord == '') {
			ErrorStr += '关键词不允许为空!<br/>';
		}
	
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 2});
			return;
		}
		
		var InputStr = parref;
		InputStr += "^" + SubID;
		InputStr += "^" + KeyWord;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRBKeys","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridMRBKeys.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridMRBKeys,retval);
				if (rowIndex > -1){
					var rd =obj.gridMRBKeys.row(rowIndex).data();
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
	
	//多重耐药菌-关键词-添加
	obj.LayerFour_Add = function(){
			
		var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0]; //多重耐药菌
		var parref = (rd ? rd["ID"] : ''); //多重耐药菌主键

		var rdKey = "";
		var ID = (rdKey ? rdKey["ID"] : '');
		var SubID = (ID ? ID.split("||")[1] : '');
		
		var KeyWord = $.form.GetValue("txtKeyWord");

		var ErrorStr = "";
		if (KeyWord == '') {
			ErrorStr += '关键词不允许为空!<br/>';
		}
	
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 2});
			return;
		}
		
		var InputStr = parref;
		InputStr += "^" + SubID;
		InputStr += "^" + KeyWord;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRBKeys","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridMRBKeys.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridMRBKeys,retval);
				if (rowIndex > -1){
					var rd =obj.gridMRBKeys.row(rowIndex).data();
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
	/************************************* 多重耐药菌-关键词 end ***************************************/
	
	/************************************* 多重耐药菌-隔离医嘱 start ***************************************/	
	
	$("#btnsearch_five").on('click', function(){
       $('#gridIsolate').DataTable().search($('#search_five').val(),true,true).draw();
       
    });
	
    $("#search_five").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridIsolate.search(this.value).draw();
        }
    });
    $("#btnAdd_five").addClass('disabled');
    $("#btnEdit_five").addClass('disabled');
    $("#btnDelete_five").addClass('disabled');
	obj.gridIsolate.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_five").addClass('disabled');
		$("#btnEdit_five").removeClass('disabled');
		$("#btnDelete_five").removeClass('disabled');
	});
	
	obj.gridIsolate.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_five").removeClass('disabled');
        $("#btnEdit_five").addClass('disabled');
        $("#btnDelete_five").addClass('disabled');
	});
	obj.gridIsolate.on('dblclick', 'tr', function(e) {
		var selectedRows = obj.gridCRuleMRB.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.alert('请先选择多重耐药菌分类，再添加数据!',{icon: 0});
			return;
		}	
		var rd = obj.gridIsolate.row(this).data();
		obj.OEOrdlayer_rd = rd;
		obj.Layer_five();
	    
	});
	$("#btnAdd_five").on('click', function(){
		var flag = $("#btnAdd_five").hasClass("disabled");
		if(flag) return ;	
		obj.OEOrdlayer_rd = '';
		obj.Layer_five();
	});
	
	$("#btnEdit_five").on('click', function(){
		var flag = $("#btnEdit_five").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridIsolate.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridIsolate.rows({selected: true}).data().toArray()[0];
		
		obj.OEOrdlayer_rd = rd;
	   	obj.Layer_five();
	});

	$("#btnDelete_five").on('click', function(){
		var flag = $("#btnDelete_five").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridIsolate.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridIsolate.rows({selected: true}).data().toArray()[0];
	
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRBOEOrd","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridIsolate.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	obj.Layer_five = function(){

		var rd = obj.OEOrdlayer_rd;
		$.form.SelectRender("cboOEOrd");  //渲染下拉框
		if (rd){
			$.form.SetValue("cboOEOrd",rd["BTOrdID"],rd["BTOrdDesc"]);
		} else {
			$.form.SetValue("cboOEOrd","");
		}
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '隔离医嘱编辑', 
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
	//保存隔离医嘱名称
	obj.LayerFive_Save = function(){
		var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0]; //多重耐药菌
		var parref = (rd ? rd["ID"] : ''); //多重耐药菌主键
		
		var rdOEOrd = obj.OEOrdlayer_rd;
		var ID = (rdOEOrd ? rdOEOrd["ID"] : '');
		var SubID = (ID ? ID.split("||")[1] : '');
		
		var OEOrdDr = $.form.GetValue("cboOEOrd");

		var ErrorStr = "";
		if (OEOrdDr == '') {
			ErrorStr += '隔离医嘱不允许为空!<br/>';
		}
	
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = parref;
		InputStr += "^" + SubID;
		InputStr += "^" + OEOrdDr;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		
		var retval =  $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRBOEOrd","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridIsolate.ajax.reload(function(){
				var rowIndex =  $.Tool.GetTableRowIndex(obj.gridIsolate,retval);
				if (rowIndex > -1){
					var rd =obj.gridIsolate.row(rowIndex).data();
					obj.OEOrdlayer_rd = rd;
				} else {
					obj.OEOrdlayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('隔离医嘱名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//保存隔离医嘱名称
	obj.LayerFive_Add = function(){
		
		var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0]; //多重耐药菌
		var parref = (rd ? rd["ID"] : ''); //多重耐药菌主键
		
		var rdOEOrd = "";
		var ID = (rdOEOrd ? rdOEOrd["ID"] : '');
		var SubID = (ID ? ID.split("||")[1] : '');
		
		var OEOrdDr = $.form.GetValue("cboOEOrd");

		var ErrorStr = "";
		if (OEOrdDr == '') {
			ErrorStr += '隔离医嘱不允许为空!<br/>';
		}
	
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = parref;
		InputStr += "^" + SubID;
		InputStr += "^" + OEOrdDr;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERID;
		var retval =  $.Tool.RunServerMethod("DHCHAI.IR.CRuleMRBOEOrd","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridIsolate.ajax.reload(function(){
				var rowIndex =  $.Tool.GetTableRowIndex(obj.gridIsolate,retval);
				if (rowIndex > -1){
					var rd =obj.gridIsolate.row(rowIndex).data();
					obj.OEOrdlayer_rd = rd;
				} else {
					obj.OEOrdlayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-2'){
				layer.alert('隔离医嘱名称重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	/************************************* 多重耐药菌-隔离医嘱 end ***************************************/
	
}
