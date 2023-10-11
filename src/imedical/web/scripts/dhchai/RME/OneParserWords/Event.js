//页面Event
function InitOneParserWordsWinEvent(obj){
	CheckSpecificKey();
	$.form.SelectRender('cboVerSearch');
	$('#cboVerSearch').on('change',function(){
		obj.gridOneWords.ajax.reload();
		$("#btnAdd_two").addClass('disabled');
		setTimeout( function () {
			obj.gridParserWords.ajax.reload();//延迟加载
		}, 400 );
	});
	 /*****搜索功能*****/
    $("#btnsearch_one").on('click', function(){
       $('#gridOneWords').DataTable().search($('#search_one').val(),true,true).draw();
       
    });
	
    $("#search_one").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridOneWords.search(this.value).draw();
        }
    });
    /**********************/
    $("#btnAdd_one").addClass('disabled');
    $("#btnEdit_one").addClass('disabled');
    $("#btnDelete_one").addClass('disabled');
	obj.gridOneWords.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").addClass('disabled');
		$("#btnEdit_one").removeClass('disabled');
		$("#btnDelete_one").removeClass('disabled');
		obj.gridParserWords.ajax.reload(function(){
			$("#btnAdd_two").removeClass('disabled');
		});
	});

	obj.gridOneWords.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_one").removeClass('disabled');
        $("#btnEdit_one").addClass('disabled');
        $("#btnDelete_one").addClass('disabled');
        obj.gridParserWords.ajax.reload(function(){
			$("#btnAdd_two").addClass('disabled');
		});
	});
	
	obj.gridOneWords.on('dblclick', 'tr', function(e) {
		var rd = obj.gridOneWords.row(this).data();
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
		var selectedRows = obj.gridOneWords.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridOneWords.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
	    obj.Layer_one();
	
	});

	$("#btnDelete_one").on('click', function(){
		var flag = $("#btnDelete_one").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridOneWords.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridOneWords.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.RME.OneWords","DeleteById",ID);
				if (parseInt(flg)<0){
					if (parseInt(flg)=='-777') {
						layer.msg('-777：当前无删除权限，请启用删除权限后再删除记录!',{icon: 2});
					}else {
						layer.msg('删除失败!',{icon: 2});
					}
				} else {
					 obj.gridOneWords.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});

  
	//归一词窗体-初始化
	obj.Layer_one = function(){
		$.form.SelectRender('cboVersion_One');	
		$.form.SelectRender('cboCat');	
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtOneWord",rd["OneWord"]);
			$.form.SetValue("cboVersion_One",rd["VerID"],rd["VerDesc"]);
			$.form.SetValue("cboCat",rd["CatID"],rd["CatDesc"]);		
		} else {
			$.form.SetValue("txtOneWord","");
			$.form.SetValue("cboVersion_One","");
			$.form.SetValue("cboCat",'');
		}
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	    
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '归一词编辑', 
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
	
	//归一词窗体-保存
	obj.LayerOne_Save = function(){
		var rd = obj.layer_rd;
		var ID = (rd ? rd["ID"] : '');
		                                                                
		var VersionDr  = $.form.GetValue("cboVersion_One");
		var OneWord    = $.form.GetValue("txtOneWord");   		                                                                            
	    var CatDr = $.form.GetValue("cboCat");
		
		if (VersionDr == '') {
			layer.alert("词库版本不允许为空",{icon: 0});
			return;
		}
	    if (OneWord == '') {
			layer.alert("归一词不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + VersionDr;  // 词库版本
		InputStr += "^" + OneWord;    // 归一词
		InputStr += "^" + CatDr;
		InputStr += "^" + "";         // 处置日期
		InputStr += "^" + "";         // 处置时间
		InputStr += "^" + $.LOGON.USERDESC; // 处置人姓名

		var retval = $.Tool.RunServerMethod("DHCHAI.RME.OneWords","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridOneWords.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridOneWords,retval);
				if (rowIndex > -1){
					var rd =obj.gridOneWords.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('归一词重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			};
			
		}
	}
	
	//归一词窗体-添加
	obj.LayerOne_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
	    var VersionDr  = $.form.GetValue("cboVersion_One");
		var OneWord    = $.form.GetValue("txtOneWord");    		                                                                            
	    var CatDr = $.form.GetValue("cboCat");
		
		if (VersionDr == '') {
			layer.alert("词库版本不允许为空",{icon: 0});
			return;
		}
	    if (OneWord == '') {
			layer.alert("归一词不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + VersionDr;  // 词库版本
		InputStr += "^" + OneWord;    // 归一词
		InputStr += "^" + CatDr;
		InputStr += "^" + "";         // 处置日期
		InputStr += "^" + "";         // 处置时间
		InputStr += "^" + $.LOGON.USERDESC; // 处置人姓名

		var retval = $.Tool.RunServerMethod("DHCHAI.RME.OneWords","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridOneWords.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridOneWords,retval);
				if (rowIndex > -1){
					var rd =obj.gridOneWords.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('归一词重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			};
			
		}
	}

    //语义词
    /*****搜索功能*****/
    $("#btnsearch_two").on('click', function(){
       $('#gridParserWords').DataTable().search($('#search_two').val(),true,true).draw();
       
    });
	
    $("#search_two").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridParserWords.search(this.value).draw();
        }
    });
    /**********************/
    $("#btnAdd_two").addClass('disabled');
    $("#btnEdit_two").addClass('disabled');
    $("#btnDelete_two").addClass('disabled');
	obj.gridParserWords.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").addClass('disabled');
		$("#btnEdit_two").removeClass('disabled');
		$("#btnDelete_two").removeClass('disabled');
	});

	obj.gridParserWords.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd_two").removeClass('disabled');
        $("#btnEdit_two").addClass('disabled');
        $("#btnDelete_two").addClass('disabled');
	});
	
	obj.gridParserWords.on('dblclick', 'tr', function(e) {
		var rd = obj.gridParserWords.row(this).data();
		obj.KeyLayer_rd = rd;
		obj.Layer_two();
	    
	});
	
	$("#btnAdd_two").on('click', function(){
		var flag = $("#btnAdd_two").hasClass("disabled");
		if(flag) return ;	
		obj.KeyLayer_rd = '';
		obj.Layer_two();
		
	});
	
	$("#btnEdit_two").on('click', function(){
		var flag = $("#btnEdit_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridParserWords.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridParserWords.rows({selected: true}).data().toArray()[0];
		
		obj.KeyLayer_rd = rd;
	    obj.Layer_two();
	
	});

	$("#btnDelete_two").on('click', function(){
		var flag = $("#btnDelete_two").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridParserWords.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridParserWords.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.RME.ParserWords","DeleteById",ID);
				if (parseInt(flg)<0){
					if (parseInt(flg)=='-777') {
						layer.msg('-777：当前无删除权限，请启用删除权限后再删除记录!',{icon: 2});
					}else {
						layer.msg('删除失败!',{icon: 2});
					}
				} else {
					 obj.gridParserWords.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//语义词窗体-初始化
	obj.Layer_two = function(){
	    $.form.iCheckRender(); //单选按钮
		$.form.SelectRender('cboVersion_Two');
        var rd = obj.KeyLayer_rd;
		if (rd){
			$.form.SetValue("cboVersion_Two",rd["VerID"],rd["VerDesc"]);
			$.form.SetValue("txtKeyWord",rd["KeyWord"]);
			$.form.SetValue("txtLimitWords_Two",rd["LimitWord"]);
			$.form.SetValue("txtContext",rd["Context"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
			$.form.SetValue("chkCheck",rd["IsCheck"]== 1);
		} else {
			$.form.SetValue("cboVersion_Two" ,''); 
			$.form.SetValue("txtKeyWord",'');
			$.form.SetValue("txtLimitWords_Two",'');
			$.form.SetValue("txtContext",'');
			$.form.SetValue("chkActive",'');
			$.form.SetValue("chkCheck" ,''); 
		}
		layer.config({  
			extend: 'layerskin/style.css' 
		});
	    
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '语义词编辑', 
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
	
	// 语义词窗体-保存
	obj.LayerTwo_Save = function(){
		var rd = obj.gridOneWords.rows({selected: true}).data().toArray()[0]; // 归一词ID
		var OneWdsDr = (rd ? rd["ID"] : ''); // 归一词ID
		
		var rdKey = obj.KeyLayer_rd;
		var ID = (rdKey ? rdKey["ID"] : '');
        
		var KeyWord    = $.form.GetValue("txtKeyWord");
		var LimitWords = $.form.GetValue("txtLimitWords_Two");
		var Context    = $.form.GetValue("txtContext");
        var VerDr      = $.form.GetValue("cboVersion_Two");
        var IsCheck    = $.form.GetValue("chkCheck");	
		var IsActive   = $.form.GetValue("chkActive");
		if (VerDr == '') {
			layer.alert("词库版本不允许为空",{icon: 0});
			return;
		}
		if (KeyWord == '') {
			layer.alert("语义词不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + VerDr;
		InputStr += "^" + KeyWord;
		InputStr += "^" + LimitWords;
		InputStr += "^" + Context;	
		InputStr += "^" + OneWdsDr;
		InputStr += "^" + IsCheck;
		InputStr += "^" + IsActive;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERDESC;
	  
		var retval = $.Tool.RunServerMethod("DHCHAI.RME.ParserWords","Update",InputStr);
		
		if (parseInt(retval)>0){
			obj.gridParserWords.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridParserWords,retval);
				if (rowIndex > -1){
					var rd =obj.gridParserWords.row(rowIndex).data();
					obj.KeyLayer_rd = rd;
				} else {
					obj.KeyLayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			layer.msg('保存失败!',{icon: 2});
			
		}
	}
	
	//语义词窗体-添加
	obj.LayerTwo_Add = function(){
		var rd = "";
		var ID = (rd ? rd["ID"] : '');
		var rd = obj.gridOneWords.rows({selected: true}).data().toArray()[0];
		var OneWdsDr = (rd ? rd["ID"] : ''); // 归一词ID
        
		var KeyWord    = $.form.GetValue("txtKeyWord");
		var LimitWords = $.form.GetValue("txtLimitWords_Two");
		var Context    = $.form.GetValue("txtContext");
        var VerDr      = $.form.GetValue("cboVersion_Two");
        var IsCheck    = $.form.GetValue("chkCheck");	
		var IsActive   = $.form.GetValue("chkActive");
		if (VerDr == '') {
			layer.alert("词库版本不允许为空",{icon: 0});
			return;
		}
		if (KeyWord == '') {
			layer.alert("语义词不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = ID;
		InputStr += "^" + VerDr;
		InputStr += "^" + KeyWord;
		InputStr += "^" + LimitWords;
		InputStr += "^" + Context;	
		InputStr += "^" + OneWdsDr;
		InputStr += "^" + IsCheck;
		InputStr += "^" + IsActive;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + $.LOGON.USERDESC;
	  
		var retval = $.Tool.RunServerMethod("DHCHAI.RME.ParserWords","Update",InputStr);
		
		if (parseInt(retval)>0){
			obj.gridParserWords.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridParserWords,retval);
				if (rowIndex > -1){
					var rd =obj.gridParserWords.row(rowIndex).data();
					obj.KeyLayer_rd = rd;
				} else {
					obj.KeyLayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('语义词+词库版+归一词本不允许重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
			
		}
	}
}
