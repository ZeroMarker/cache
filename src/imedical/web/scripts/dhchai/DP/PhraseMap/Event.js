//页面Event
function InitPhraseMapWinEvent(obj){
	CheckSpecificKey();
	/*****搜索功能*****/
    $("#btnsearch").on('click', function(){
       $('#gridPhraseMap').DataTable().search($('#search').val(),true,true).draw();
       
    });
	$("#cboPhraseType").on('change', function(){
    	$.form.SelectRender('cboMapDic');
    });
    $("#search").keyup(function(event){
        if ((event.keyCode == 13)||(this.value=="")) {
	        obj.gridPhraseMap.search(this.value).draw();
        }
    });
   /**********************/
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
	obj.gridPhraseMap.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});

	obj.gridPhraseMap.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridPhraseMap.on('dblclick', 'tr', function(e) {
		var rd = obj.gridPhraseMap.row(this).data();
		obj.layer_rd = rd;
		obj.Layer();
	    
	});
	
	$("#btnAdd").on('click', function(){
		var flag = $("#btnAdd").hasClass("disabled");
		if(flag) return ;	
		obj.layer_rd = '';
		obj.Layer();
		
	});
	$("#btnEdit").on('click', function(){
		var flag = $("#btnEdit").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridPhraseMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridPhraseMap.rows({selected: true}).data().toArray()[0];
		
		obj.layer_rd = rd;
		obj.Layer();
		
	});
	

	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridPhraseMap.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridPhraseMap.rows({selected: true}).data().toArray()[0];
		
		var ID = rd["ID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.DP.PhraseMap","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridPhraseMap.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
	});
  
	//常用短语对照编辑窗体-初始化
	obj.Layer = function(){
	    $.form.iCheckRender(); //单选按钮
	    $.form.SelectRender('cboMapDic');
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("txtCode",rd["Code"]);
			$.form.SetValue("txtDesc",rd["Desc"]);	
			$.form.SetValue("cboMapDic",rd["MapDicDr"],rd["MapDicDesc"]);
			$.form.SetValue("txtSCode",rd["SCode"]);
			$.form.SetValue("chkActive",rd["IsActive"]== 1);
		} else {
			$.form.SetValue("txtCode",'');
			$.form.SetValue("txtDesc",'');
			$.form.SetValue("cboMapDic",'');
			$.form.SetValue("txtSCode",'');
			$.form.SetValue("chkActive" ,''); 
		}
	    layer.config({  
			extend: 'layerskin/style.css' 
		});
	
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '常用短语对照编辑', 
			content: $('#layer'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.Layer_Add();
			},
			btn2: function(index, layero){
				obj.Layer_Save();
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
	
	//常用短语对照窗体-保存
	 obj.Layer_Save = function(){
		var rd = obj.layer_rd;
      	var ID = (rd ? rd["ID"] : '');
      	var PhraseCode   = $.form.GetValue("txtCode");
        var PhraseDesc   = $.form.GetValue("txtDesc");
		var PhraseTypeDr = $.form.GetValue("ulPhraseType");
		var MapDicDr     = $.form.GetValue("cboMapDic");
		var SCode        = $.form.GetValue("txtSCode");
		var IsActive     = $.form.GetValue("chkActive");		
	    var ActUser      = $.LOGON.USERDESC;
		
		if (PhraseCode == '') {
			layer.alert("短语代码不允许为空",{icon: 0});
			return;
		}
		if (PhraseDesc == '') {
			layer.alert("短语名称不允许为空",{icon: 0});
			return;
		}
		if (PhraseTypeDr == '') {
			layer.alert("短语分类不允许为空",{icon: 0});
			return;
		}
		if (SCode == '') {
			layer.alert("子系统代码不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + PhraseCode;
		InputStr += "^" + PhraseDesc;
		InputStr += "^" + PhraseTypeDr;		
		InputStr += "^" + MapDicDr;
		InputStr += "^" + SCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
	   
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.PhraseMap","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridPhraseMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridPhraseMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridPhraseMap.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('子系统代码+短语分类+短语代码不唯一!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
	
	//常用短语对照窗体-添加
	 obj.Layer_Add = function(){
		var rd = "";
	
	    var ID = (rd ? rd["ID"] : '');
      	var PhraseCode   = $.form.GetValue("txtCode");
        var PhraseDesc   = $.form.GetValue("txtDesc");
	    var PhraseTypeDr = $.form.GetValue("ulPhraseType");
		var MapDicDr     = $.form.GetValue("cboMapDic");
		var SCode        = $.form.GetValue("txtSCode");
		var IsActive     = $.form.GetValue("chkActive");		
	    var ActUser      = $.LOGON.USERDESC;
		
		if (PhraseCode == '') {
			layer.alert("短语代码不允许为空",{icon: 0});
			return;
		}
		if (PhraseDesc == '') {
			layer.alert("短语名称不允许为空",{icon: 0});
			return;
		}
		if (PhraseTypeDr == '') {
			layer.alert("短语分类不允许为空",{icon: 0});
			return;
		}
		if (SCode == '') {
			layer.alert("子系统代码不允许为空",{icon: 0});
			return;
		}
		var InputStr = ID;
		InputStr += "^" + PhraseCode;
		InputStr += "^" + PhraseDesc;
		InputStr += "^" + PhraseTypeDr;		
		InputStr += "^" + MapDicDr;
		InputStr += "^" + SCode;
		InputStr += "^" + IsActive;
		InputStr += "^" + ''; 
		InputStr += "^" + '';
		InputStr += "^" + ActUser;
	  
		var retval = $.Tool.RunServerMethod("DHCHAI.DP.PhraseMap","Update",InputStr);
		if (parseInt(retval)>0){
			obj.gridPhraseMap.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridPhraseMap,retval);
				if (rowIndex > -1){
					var rd =obj.gridPhraseMap.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			if(parseInt(retval)=='-100'){
				layer.alert('子系统代码+短语分类+短语代码不唯一!',{icon: 0});
			}else {
				layer.msg('保存失败!',{icon: 2});
			}
		}
	}
}
