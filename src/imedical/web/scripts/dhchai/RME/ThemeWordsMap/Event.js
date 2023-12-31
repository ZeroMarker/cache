//页面Event
function InitThemeWordsMapEvent(obj){
	CheckSpecificKey();
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	
	$.form.SelectRender('cboThemeType');
	$('#cboThemeType').on('change',function(){
		obj.gridThWordsMap.ajax.reload();
		
		gridThWordsMapArgs.ThemeTypeDr = $.form.GetValue("cboThemeType");
		obj.gridThemeWords.ajax.reload();
		obj.gridOneWords.ajax.reload();
	});
	
    // 主题词映射
	//*********************搜索功能Stt*********************
    $("#btnsearch_TWMap").on('click', function(){
       $('#gridThWordsMap').DataTable().search($('#search_TWMap').val(),true,true).draw();
    });
	
    $("#search_TWMap").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridThWordsMap.search(this.value).draw();
        }
    });
	//*********************搜索功能End*********************
	$("#btnAdd").addClass('disabled');
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridThWordsMap.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridThWordsMap.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridThWordsMap.on('dblclick', 'tr', function(e) {
		var rd = obj.gridThWordsMap.row(this).data();
		obj.KeyLayer_rd = rd;
		obj.Layer();
	});
	
	$("#btnEdit").on('click', function(){
		var flag = $("#btnEdit").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridThWordsMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridThWordsMap.rows({selected: true}).data().toArray()[0];
		
		obj.KeyLayer_rd = rd;
	    obj.Layer();
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows =  obj.gridThWordsMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd =  obj.gridThWordsMap.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.RME.ThWordsMap","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridOneWords.ajax.reload();  // 刷新归一词
					 obj.gridThWordsMap.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
	
	// 主题词映射窗体-初始化
	obj.Layer = function(){
		$.form.SelectRender('cboDocType');
		$.form.SelectRender('cboSectionType');
		$.form.SelectRender('cboPropertyType');
        var rd = obj.KeyLayer_rd;
		if (rd){
			$.form.SetValue("cboDocType" ,rd["DocTypeDr"],rd["DocTypeDesc"]); 
			$.form.SetValue("cboSectionType" ,rd["SectionTypeDr"],rd["SectionTypeDesc"]);
			$.form.SetValue("cboPropertyType" ,rd["PropertyTypeDr"],rd["PropertyTypeDesc"]);
			$.form.SetValue("txtDocProperty",rd["DocProperty"]);
		} else {
			$.form.SetValue("cboDocType" ,'');
			$.form.SetValue("cboSectionType" ,'');
			$.form.SetValue("cboPropertyType" ,'');
			$.form.SetValue("txtDocProperty",'');
		}
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '主题词映射编辑', 
			content: $('#layer'),
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
	// 主题词映射窗体-保存
	obj.LayerTwo_Save = function(){
		
		var rd = obj.KeyLayer_rd;
		var ID = (rd ? rd["ID"] : '');
		var ThemeWordDr = (rd ? rd["ThemeWordDr"] : '');
		var OneWordDr   = (rd ? rd["OneWordDr"] : '');
		
		var DocTypeDr      = $.form.GetValue("cboDocType");
		var SectionTypeDr  = $.form.GetValue("cboSectionType");
        var PropertyTypeDr = $.form.GetValue("cboPropertyType");
        var DocProperty    = $.form.GetValue("txtDocProperty");
		
		var InputStr = ID;
		InputStr += "^" + ThemeWordDr;      // 主题词
		InputStr += "^" + OneWordDr;        // 归一词
		InputStr += "^" + DocTypeDr;        // 文档类型
		InputStr += "^" + SectionTypeDr;    // 段落类型
		InputStr += "^" + PropertyTypeDr;   // 属性类型
		InputStr += "^" + DocProperty;      // 限定属性
		InputStr += "^" + '';               // 更新日期
		InputStr += "^" + '';               // 更新时间
		InputStr += "^" + $.LOGON.USERDESC; // 更新人
		var retval = $.Tool.RunServerMethod("DHCHAI.RME.ThWordsMap","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridThWordsMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridThWordsMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridThWordsMap.row(rowIndex).data();
					obj.KeyLayer_rd = rd;
				} else {
					obj.KeyLayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('唯一性不允许重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//主题词库列表
	//*********************搜索功能Stt*********************
    $("#btnsearch_TW").on('click', function(){
       $('#gridThemeWords').DataTable().search($('#search_TW').val(),true,true).draw();
    });
	
    $("#search_TW").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridThemeWords.search(this.value).draw();
        }
    });
	//*********************搜索功能End*********************
	
	obj.gridThemeWords.on('select', function(e, dt, type, indexes) {
		var rd =  obj.gridThemeWords.rows({selected: true}).data().toArray()[0];
		var ThemeWordDr = rd["ID"];
		if (!ThemeWordDr) return;
		if (($("#btnAdd").hasClass("disabled"))&&(gridThWordsMapArgs.Flag==1)){
			$("#btnAdd").removeClass('disabled');
		}
		gridThWordsMapArgs.ThemeWordsDr=ThemeWordDr;
		obj.gridThWordsMap.ajax.reload();
	});
	
	obj.gridThemeWords.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		gridThWordsMapArgs.ThemeWordsDr="";
        obj.gridThWordsMap.ajax.reload();
	});
	
	//归一词库列表
	//*********************搜索功能Stt*********************
    $("#btnsearch_OW").on('click', function(){
       $('#gridOneWords').DataTable().search($('#search_OW').val(),true,true).draw();
    });
	
    $("#search_OW").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridOneWords.search(this.value).draw();
        }
    });
	//*********************搜索功能End*********************
	obj.gridOneWords.on('select', function(e, dt, type, indexes) {
		gridThWordsMapArgs.Flag=1;
		if (gridThWordsMapArgs.ThemeWordsDr!=""){
			$("#btnAdd").removeClass('disabled');
		}
	});
	
	obj.gridOneWords.on('deselect', function(e, dt, type, indexes) {
		$("#btnAdd").addClass('disabled');
		gridThWordsMapArgs.Flag=0;
	});
	//增加对照信息
	$("#btnAdd").on('click', function(){
		$("#btnAdd").addClass('disabled');
		var rd =  obj.gridThemeWords.rows({selected: true}).data().toArray()[0];
		var ThemeWordDr = rd["ID"];
		
		var rd =  obj.gridOneWords.rows({selected: true}).data().toArray()[0];
		var OneWordDr = rd["ID"];
		
		if (ThemeWordDr == '') {
			layer.alert("主题词不允许为空",{icon: 0});
			return;
		}
		if (OneWordDr == '') {
			layer.alert("归一词不允许为空",{icon: 0});
			return;
		}
		
		var InputStr = "";
		InputStr += "^" + ThemeWordDr;   // 主题词
		InputStr += "^" + OneWordDr;     // 归一词
		InputStr += "^" + '';            // 文档类型
		InputStr += "^" + '';            // 段落类型
		InputStr += "^" + '';            // 属性类型
		InputStr += "^" + '';            // 关联属性
		InputStr += "^" + '';            // 更新日期
		InputStr += "^" + '';            // 更新时间
		InputStr += "^" + $.LOGON.USERDESC; // 更新人
		
		var retval = $.Tool.RunServerMethod("DHCHAI.RME.ThWordsMap","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridOneWords.ajax.reload();
			obj.gridThWordsMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridThWordsMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridThWordsMap.row(rowIndex).data();
					obj.KeyLayer_rd = rd;
				} else {
					obj.KeyLayer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('唯一性不允许重复!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	});
}
