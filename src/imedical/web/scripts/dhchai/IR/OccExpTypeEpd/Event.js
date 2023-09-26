//页面Event
function InitOccExpTypeResWinEvent(obj){
	$.form.iCheckRender();
	CheckSpecificKey();
	
	obj.LoadEvent = function(args){
		$("#btnEdit").addClass('disabled');
		$("#btnDelete").addClass('disabled');
	}
	
	obj.gridOccExpTypeEpd.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").addClass('disabled');
		$("#btnEdit").removeClass('disabled');
		$("#btnDelete").removeClass('disabled');
	});
	
	obj.gridOccExpTypeEpd.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		$("#btnAdd").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
	});
	
	obj.gridOccExpTypeEpd.on('dblclick', 'tr', function(e) {
		var rd = obj.gridOccExpTypeEpd.row(this).data();
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
		/* var flag = $("#btnEdit").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridOccExpTypeEpd.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridExpTypeRes.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
	    obj.Layer(); */
	    var rd = obj.gridOccExpTypeEpd.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
		obj.Layer();
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var rd = obj.gridOccExpTypeEpd.rows({selected: true}).data().toArray()[0];	
		var ID = (rd ? rd["ID"] : '');
		if (ID == ""){
			layer.msg('请选择要删除的行!',{icon: 2});
		}else {
			layer.confirm( '确认是否删除?', {
				btn: ['确认','取消'],    //btn位置对应function的位置
				btnAlign: 'c'
			},
			function(){ 
				var retval = $.Tool.RunServerMethod("DHCHAI.IR.OccExpTypeEpd","DeleteById",ID);
				if (retval == 0){
					obj.gridOccExpTypeEpd.ajax.reload(function(){
						var rowIndex = $.Tool.GetTableRowIndex(obj.gridOccExpTypeEpd,retval);
						if (rowIndex != 0){
							var rd =obj.gridOccExpTypeEpd.row(rowIndex).data();
							obj.layer_rd = rd;
						} else {
							obj.layer_rd = '';
						}
						layer.msg('删除成功!',{icon: 1});
					},false); 
				} else {
					layer.msg('删除失败!',{icon: 2});
				}
			});	
		}
	});
	//暴露感染筛查规则弹出框体
	obj.Layer = function(){
	    $.form.iCheckRender(); //单选按钮
		$.form.SelectRender('cboEpdType');
		$.form.SelectRender('cboLabOperator');
		$.form.SelectRender('cboLabOperator2');
		$.form.SelectRender('cboLabItem');
		$.form.SelectRender('cboLabItem2');
        var rd = obj.layer_rd;
		if (rd){
			$.form.SetValue("cboEpdType",rd["EpdTypeID"],rd["EpdTypeDesc"]);
			$.form.SetValue("txtDesc",rd["BTDesc"]);
			$.form.SetValue("cboLabItem",rd["LabItemID"],rd["LabItemDesc"]);
			$.form.SetValue("cboLabOperator",rd["LabOperID"],rd["LabOperator"]);
			$.form.SetValue("txtLabItemRst",rd["LabItemRst"]);
			$.form.SetValue("cboLabItem2",rd["LabItemID2"],rd["LabItemDesc2"]);
			$.form.SetValue("cboLabOperator2",rd["LabOperID2"],rd["LabOperator2"]);
			$.form.SetValue("txtLabItemRst2",rd["LabItemRst2"]);
			$.form.SetValue("chkIsActive",(rd["IsActive"] == 1));
			$.form.SetValue("txtNote",rd["Note"]);
		} else {
			$.form.SetValue("cboEpdTypee",'');
			$.form.SetValue("txtDesc",'');
			$.form.SetValue("cboLabItem",'');
			$.form.SetValue("cboLabOperator",'');
			$.form.SetValue("txtLabItemRst",'');
			$.form.SetValue("cboLabItem2",'');
			$.form.SetValue("cboLabOperator2",'');
			$.form.SetValue("txtLabItemRst2",'');
			$.form.SetValue("chkIsActive",0);
			$.form.SetValue("txtNote",'');
		}	
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '暴露感染筛查规则维护', 
			content: $('#layer'),
			btn: ['添加','保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.Layer_Add();
			  	//layer.close(index); //关闭
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
	
	//职业感染筛查窗体-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd; 
		var ID = (rd ? rd["ID"] : '');
		var SubID = (ID ? ID.split("||")[1] : '');
		
		var EpdTypeDr    = $.form.GetValue("cboEpdType"); //暴露感染类型
		var BTDesc       = $.form.GetValue("txtDesc"); //筛查规则描述
		var LabItemDr    = $.form.GetValue("cboLabItem"); //检验项目
		var LabOperDr    = $.form.GetValue("cboLabOperator"); //比较1
		var LabItemRst   = $.form.GetValue("txtLabItemRst"); //阳性结果1		
		var LabItemDesc2 = $.form.GetValue("cboLabItem2");//检验项目2
		var LabOperDr2   = $.form.GetValue("cboLabOperator2"); //	
		var LabItemRst2  = $.form.GetValue("txtLabItemRst2");//阳性结果22
		var Note         = $.form.GetValue("txtNote");//备注
		var IsActive     = $.form.GetValue("chkIsActive");//是否有效
		
		var errInfo=""
		if (EpdTypeDr == '') errInfo += '感染类型为必选！';
		if (BTDesc == '') errInfo += '规则说明为必填！';
		if (LabItemDr == '') errInfo += '检验项目为必填！';
		if (LabOperDr == '' || LabItemRst == '') errInfo += '阳性结果为必填';
		
		if (errInfo) {
			layer.alert(errInfo, {icon: 0});
			return;
		}
		
		var InStr = Parref;
		InStr += "^" + SubID;
		InStr += "^" + EpdTypeDr;
		InStr += "^" + BTDesc;
		InStr += "^" + LabItemDr;
		InStr += "^" + LabOperDr;
		InStr += "^" + LabItemRst;
		InStr += "^" + LabItemDesc2;
		InStr += "^" + LabOperDr2;
		InStr += "^" + LabItemRst2;
		InStr += "^" + IsActive;
		InStr += "^" + Note;
		InStr += "^" + "";
		InStr += "^" + "";
		InStr += "^" + $.LOGON.USERID; // 处置人
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.OccExpTypeEpd","Update",InStr);
		if (parseInt(retval)>0){
			obj.gridOccExpTypeEpd.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridOccExpTypeEpd,retval);			
				if (rowIndex > -1){
					var rd =obj.gridOccExpTypeEpd.row(rowIndex).data();
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
	//职业感染筛查窗体-添加
	obj.Layer_Add = function(){
		var rd = obj.layer_rd; 
		var ID = (rd ? rd["ID"] : '');
		var SubID = (ID ? ID.split("||")[1] : '');
		
		var EpdTypeDr    = $.form.GetValue("cboEpdType"); //暴露感染类型
		var BTDesc       = $.form.GetValue("txtDesc"); //筛查规则描述
		var LabItemDr    = $.form.GetValue("cboLabItem"); //检验项目
		var LabOperDr    = $.form.GetValue("cboLabOperator"); //比较1
		var LabItemRst   = $.form.GetValue("txtLabItemRst"); //阳性结果1		
		var LabItemDesc2 = $.form.GetValue("cboLabItem2");//检验项目2
		var LabOperDr2   = $.form.GetValue("cboLabOperator2"); //	
		var LabItemRst2  = $.form.GetValue("txtLabItemRst2");//阳性结果22
		var Note         = $.form.GetValue("txtNote");//备注
		var IsActive     = $.form.GetValue("chkIsActive");//是否有效
		
		var errInfo=""
		if (EpdTypeDr == '') errInfo += '感染类型为必选！';
		if (BTDesc == '') errInfo += '规则说明为必填！';
		if (LabItemDr == '') errInfo += '检验项目为必填！';
		if (LabOperDr == '' || LabItemRst == '') errInfo += '阳性结果为必填';
		
		if (errInfo) {
			layer.alert(errInfo, {icon: 0});
			return;
		}
		
		var InStr = Parref;
		InStr += "^" + SubID;
		InStr += "^" + EpdTypeDr;
		InStr += "^" + BTDesc;
		InStr += "^" + LabItemDr;
		InStr += "^" + LabOperDr;
		InStr += "^" + LabItemRst;
		InStr += "^" + LabItemDesc2;
		InStr += "^" + LabOperDr2;
		InStr += "^" + LabItemRst2;
		InStr += "^" + IsActive;
		InStr += "^" + Note;
		InStr += "^" + "";
		InStr += "^" + "";
		InStr += "^" + $.LOGON.USERID; // 处置人
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.OccExpTypeEpd","Update",InStr);
		if (parseInt(retval)>0){
			obj.gridOccExpTypeEpd.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridOccExpTypeEpd,retval);			
				if (rowIndex > -1){
					var rd =obj.gridOccExpTypeEpd.row(rowIndex).data();
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

}
