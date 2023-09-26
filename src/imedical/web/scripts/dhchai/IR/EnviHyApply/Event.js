//页面Event
function InitEnviHyApplyWinEvent(obj){
	CheckSpecificKey();
	// 搜索功能
    $("#btnsearch").on('click', function(){
       $('#gridApply').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridApply.search(this.value).draw();
        }
    });

    // 功能按钮控制
    $("#btnEdit").addClass('disabled');
    $("#btnDelete").addClass('disabled');
    $("#btnPrintBar").addClass('disabled');
	obj.gridApply.on('select', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
		var rd = obj.gridApply.row(indexes).data();
		if (rd.RepStatusCode=='1'){
			$("#btnApply").addClass('disabled');
			$("#btnEdit").removeClass('disabled');
			$("#btnDelete").removeClass('disabled');
			$("#btnPrintBar").removeClass('disabled');
		}else{
			$("#btnApply").addClass('disabled');
			$("#btnEdit").addClass('disabled');
			$("#btnDelete").addClass('disabled');
			$("#btnPrintBar").removeClass('disabled');
		}
	});
	
	obj.gridApply.on('deselect', function(e, dt, type, indexes) {
		var selectedRows = dt.rows({selected: true}).count();
        $("#btnApply").removeClass('disabled');
        $("#btnEdit").addClass('disabled');
        $("#btnDelete").addClass('disabled');
        $("#btnPrintBar").addClass('disabled');
	});
	
	obj.gridApply.on('dblclick', 'tr', function(e) {
		var rd = obj.gridApply.row(this).data();
		if (rd['RepStatusCode']!=='1'){
			layer.msg('非申请状态不能编辑!',{icon: 2});
			return;
		}	
		obj.layer_rd = rd;
		obj.LayerEdit();
	});

	// 申请
	$("#btnApply").on('click', function(){
		obj.layer_rd = '';
		obj.LayerApply();
	});

	// 编辑
	$("#btnEdit").on('click', function(){
		var flag = $("#btnEdit").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridApply.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;	
		var rd = obj.gridApply.rows({selected: true}).data().toArray()[0];
		obj.layer_rd = rd;
		obj.LayerEdit();
		$("#btnApply").removeClass('disabled');
	});

	// 删除
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridApply.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridApply.rows({selected: true}).data().toArray()[0];

		var ID = rd["ReportID"];
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				var flg = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyReport","DeleteById",ID);
				if (parseInt(flg)<0){
					layer.msg('删除失败!',{icon: 2});
				} else {
					obj.gridApply.rows({selected:true}).remove().draw(false);
					layer.msg('删除成功!',{icon: 1});
				}
		 });
		 $("#btnApply").removeClass('disabled');
	});

	// 打印条码
	$("#btnPrintBar").on('click', function(){
		var flag = $("#btnPrintBar").hasClass("disabled");
		if(flag) return ;
		var selectedRows = obj.gridApply.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		var rd = obj.gridApply.rows({selected: true}).data().toArray()[0];

		var ID = rd["ReportID"];
		var ItemDesc = rd["EvItemDesc"];
		var NormDesc = rd["NormDesc"];
		var NormMax = rd["NormMax"];
		var NormMin = rd["NormMin"];
		var CenterNum = rd["CenterNum"];
		var SurroundNum = rd["SurroundNum"];
		var SpecimenNum = rd["EvItemSpenNum"];
		var BarCode = rd["BarCode"];
		var MonitorDate = rd['MonitorDate'];
		var ApplyLocDesc = rd['ApplyLocDesc'];
		var ItemObjDesc = rd['EvItemObjDesc'];

		SpecimenNum = SpecimenNum*1;
		CenterNum   = CenterNum*1;
		SurroundNum = SurroundNum*1;
		for(var i = 1; i <= SpecimenNum; i++){
			//条码：8位检验码+2位标本编码
			var SubBarCode = '00' + i;
			SubBarCode = SubBarCode.substring(SubBarCode.length-2,SubBarCode.length);
			vBarCode = "*"+BarCode + SubBarCode+"*";
			
			//项目名称，添加中心、周边及序号
			var SubItemNo = i;
			var SubItemDesc = '';
			if ((CenterNum>0)&&(i<=CenterNum)){
				SubItemDesc = "中心-" + SubItemNo;
			} else if ((SurroundNum>0)&&(i<=(SurroundNum+CenterNum))){
				SubItemDesc = "周边-" + SubItemNo;
			} else if ((CenterNum>0)||(SurroundNum>0)) {
				SubItemDesc = "参照-" + SubItemNo;
			} else {
				SubItemDesc = "检测-" + SubItemNo;
			}
			vItemDate   = MonitorDate + '【' + SubItemDesc + '/' + SpecimenNum + '】';
			//条码打印
			PrintXMLBar(ItemDesc,ItemObjDesc,vItemDate,ApplyLocDesc,vBarCode);
		}

	});

	function  PrintXMLBar(ItemDesc,NormObject,ItemDate,LocDesc,BarCode)
	{
 	
		 var printParam="";
	     var printList="";
	     // 获取XML模板配置
	 	 DHCP_GetXMLConfig("InvPrintEncrypt","DHCHAIEnviHyBar");
	 	 // 打印参数
	     printParam=printParam+"ItemDesc"+String.fromCharCode(2)+ItemDesc;
	     printParam=printParam+"^NormObject"+String.fromCharCode(2)+NormObject;
	     printParam=printParam+"^ItemDate"+String.fromCharCode(2)+ItemDate;
	     printParam=printParam+"^LocDesc"+String.fromCharCode(2)+LocDesc;
	     printParam=printParam+"^BarCode"+String.fromCharCode(2)+BarCode;	
	     printParam=printParam+"^BarCodeNo"+String.fromCharCode(2)+BarCode;  
	     // 打印控件
	     var printControlObj=document.getElementById("barPrintControl");	
		 DHCP_XMLPrint(printControlObj,printParam,printList);
	}

	// 链接选中方式
    $('#gridApply').on('click','a.result', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridApply.row(tr);
		var rowData = row.data();
		obj.ReportID = rowData.ReportID;
		layer.open({
			type: 1,
			zIndex: 100,
			area: ['800px','520px'],
			skin: 'layer-class',
			title: '监测结果', 
			content: $('#layerResultDetail'),
			btn: ['关闭'],
			btnAlign: 'c',
			success: function(layero){
				refreshResultDetail();
			}	
		}); 
    });

    // 刷新结果明细列表
    function refreshResultDetail()
	{
		if(obj.gridResultDetail==null)
		{
			obj.gridResultDetail = $("#gridResultDetail").DataTable({
				dom: 'rt<"row">',
				paging: false,
				ordering: false,
				info: true,
				//select: 'single',
				"processing" : true,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.EnviHyReportSrv";
						d.QueryName = "QryResultDetail";
						d.Arg1 =obj.ReportID;
						d.ArgCnt = 1;
					}
				},
				"columns": [
					{"data": "BarCode"},
					{"data": "Result"},
					{"data": "BactDesc"},
					{"data": "LogDate"},
					{"data": "LogTime"},
					{"data": "LogUserDesc"}
				],
				"rowCallback": function( row, data, index ) {
				  }
			});
		} else {
			obj.gridResultDetail.ajax.reload();
		}
	}

	obj.LayerApply = function(){
		$("#cboAEvObject").data("param","0");	
		$.form.SelectRender("#cboAEvObject");
		if ($('#cboAHospital>option').length>2){
			$.form.SetValue("cboAHospital",'');
		}
		$.form.SetValue("cboALoc",'');
		$.form.DateTimeRender('AMonitorDate',$.form.GetCurrDate('-'));
		$.form.SetValue("cboAEvItem",'');
		$.form.SetValue("cboAEvObject",'');
		$.form.SetValue("txtSpecimenNum",'');
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '监测申请', 
			content: $('#layer'),
			btn: ['添加','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.Layer_Add();
			},
			success: function(layero){
			}	
		}); 	
	}

	obj.LayerEdit= function(){
		var rd = obj.layer_rd;
		$("#cboAEvObject").data("param","0");	
		$.form.SelectRender("#cboAEvObject");
		if (rd){
			$.form.SetValue("cboAHospital",rd["HospID"],rd["HospDesc"]);
			$.form.SetValue("cboALoc",rd["ApplyLocID"],rd["ApplyLocDesc"]);
			$.form.DateTimeRender("AMonitorDate",rd["MonitorDate"]);
			$.form.SetValue("cboAEvItem",rd["EvItemID"],rd["EvItemDesc"]);
			$.form.SetValue("cboAEvObject",rd["EvItemObjID"],rd["EvItemObjDesc"]);
			$.form.SetValue("txtSpecimenNum",rd["EvItemSpenNum"]);
		}
		
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '监测申请', 
			content: $('#layer'),
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
			  	obj.Layer_Save();
			  	return false;
			},
			success: function(layero){
			}	
		}); 	
	}

	// 申请-保存
	obj.Layer_Save = function(){
		var rd = obj.layer_rd;
		var ReportID = (rd ? rd["ReportID"] : '');
		
		var HospitalDr      = $.form.GetValue("cboAHospital");
		var ApplyLocDr     	= $.form.GetValue("cboALoc");
		var MonitorDate   	= $.form.GetValue("AMonitorDate");
		var EvItemDr 		= $.form.GetValue("cboAEvItem");
		var EvObjectDr   	= $.form.GetValue("cboAEvObject");
		var SpecimenNum    	= $.form.GetValue("txtSpecimenNum");

		var ErrorStr = "";
		if (HospitalDr == '') {
			ErrorStr += '院区不允许为空！<br/>';	
		}
		if (ApplyLocDr == '') {
			ErrorStr += '科室不允许为空！<br/>';
		}
		if (MonitorDate == '') {
			ErrorStr += '监测日期不允许为空！<br/>';
		}
		if (EvItemDr == '') {
			ErrorStr += '监测项目不允许为空！<br/>';
		}
		if (EvObjectDr == '') {
			ErrorStr += '监测对象不允许为空！<br/>';
		}
		if (SpecimenNum == '') {
			ErrorStr += '标本数量不允许为空！<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ReportID;
		InputStr += "^" + EvItemDr;
		InputStr += "^" + EvObjectDr;
		InputStr += "^" + 1;
		InputStr += "^" + MonitorDate;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ApplyLocDr;
		InputStr += "^" + $.LOGON.USERID;;
		InputStr += "^" + 0;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + '';
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyReport","Update",InputStr);
		if (parseInt(retval)>0){
			// 保存日志
			var LogStr = retval;
			LogStr = LogStr + '^' + $.LOGON.LOCID;
			LogStr = LogStr + '^' + $.LOGON.USERID;
			LogStr = LogStr + '^' + 1;
			LogStr = LogStr + '^' + '';
			var retvalLog = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyReportLog","Update",LogStr);

			obj.gridApply.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridApply,retval);
				if (rowIndex > -1){
					var rd =obj.gridApply.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('保存成功!',{icon: 1});
			},false);
		} else {
			layer.msg('保存失败',{icon: 2});
		}
	}
	// 申请-添加
	obj.Layer_Add = function(){
		var rd = "";
		var ReportID = (rd ? rd["ReportID"] : '');
		
		var HospitalDr      = $.form.GetValue("cboAHospital");
		var ApplyLocDr     	= $.form.GetValue("cboALoc");
		var MonitorDate   	= $.form.GetValue("AMonitorDate");
		var EvItemDr 		= $.form.GetValue("cboAEvItem");
		var EvObjectDr   	= $.form.GetValue("cboAEvObject");
		var SpecimenNum    	= $.form.GetValue("txtSpecimenNum");

		var ErrorStr = "";
		if (HospitalDr == '') {
			ErrorStr += '院区不允许为空！<br/>';	
		}
		if (ApplyLocDr == '') {
			ErrorStr += '科室不允许为空！<br/>';
		}
		if (MonitorDate == '') {
			ErrorStr += '监测日期不允许为空！<br/>';
		}
		if (EvItemDr == '') {
			ErrorStr += '监测项目不允许为空！<br/>';
		}
		if (EvObjectDr == '') {
			ErrorStr += '监测对象不允许为空！<br/>';
		}
		if (SpecimenNum == '') {
			ErrorStr += '标本数量不允许为空！<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return;
		}
		
		var InputStr = ReportID;
		InputStr += "^" + EvItemDr;
		InputStr += "^" + EvObjectDr;
		InputStr += "^" + 1;
		InputStr += "^" + MonitorDate;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + ApplyLocDr;
		InputStr += "^" + $.LOGON.USERID;;
		InputStr += "^" + 0;
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + '';
		InputStr += "^" + '';
		
		var retval = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyReport","Update",InputStr);
		if (parseInt(retval)>0){
			// 保存日志
			var LogStr = retval;
			LogStr = LogStr + '^' + $.LOGON.LOCID;
			LogStr = LogStr + '^' + $.LOGON.USERID;
			LogStr = LogStr + '^' + 1;
			LogStr = LogStr + '^' + '';
			var retvalLog = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyReportLog","Update",LogStr);

			obj.gridApply.ajax.reload(function(){
				var rowIndex = $.Tool.GetTableRowIndex(obj.gridApply,retval);
				if (rowIndex > -1){
					var rd =obj.gridApply.row(rowIndex).data();
					obj.layer_rd = rd;
				} else {
					obj.layer_rd = '';
				}
				layer.msg('申请成功!',{icon: 1});
			},false);
		} else {
			layer.msg('申请失败',{icon: 2});
		}
	}

	//查询按钮
	$("#btnQuery").on('click',function(){
		$("#btnApply").removeClass('disabled');
		obj.reloadgridApply();
	});

	//重新加载表格数据
	obj.reloadgridApply = function(){
		var HospIDs	    = $("#cboHospital").val();
		var DateFrom	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		var ApplyLoc 	= $("#cboApplyLoc").val();
		var EvItem  	= $("#cboEvItem").val();
		
		var ErrorStr = "";
		if (HospIDs=="") {
			ErrorStr += '请选择院区!<br/>';
		}
		if (DateFrom=="") {
			ErrorStr += '请选择监测开始日期!<br/>';
		}
		if (DateTo == "") {
			ErrorStr += '请选择监测结束日期!<br/>';
		}
		if (!$.form.CompareDate(DateTo,DateFrom)){
    		ErrorStr += '起始日期不允许大于截止日期!<br>';
    	}
	
		if (ErrorStr != '') {
			layer.msg(ErrorStr,{icon: 0});
			return;
		}
		obj.gridApply.clear().draw()
		obj.gridApply.ajax.reload( function ( json ) {
		    if (json.data.length==0){
				layer.msg('没有找到相关数据！',{time: 2000,icon: 2});
				return;
			}
		} );
	};
}

