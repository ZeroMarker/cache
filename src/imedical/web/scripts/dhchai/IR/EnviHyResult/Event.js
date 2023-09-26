//页面Event
function InitEnviHyReusltWinEvent(obj){
	CheckSpecificKey();
	// 搜索功能
    $("#btnsearch").on('click', function(){
       $('#gridReuslt').DataTable().search($('#search').val(),true,true).draw();
       
    });
	
    $("#search").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.gridReuslt.search(this.value).draw();
        }
    });

    // 页签功能选择
	$('#ulOper > li').click(function (e) {
		e.preventDefault();
		$('#ulOper > li').removeClass('active');
		$(this).addClass('active');
		var val = $(this).val();
		$('#ulOper').val(val);
		if(val=="1")
		{
			//查询
			$('#IsHospitalAtt').show();
			$('#IsDateFromAtt').show();
			$('#IsDateToAtt').show();
			$('#IsApplyLocAtt').show();
			$('#IsRepStatusAtt').show();
			$('#btnHairMaterial').hide();
			$('#btnHairMaterialAll').hide();
			$('#btnRecSpecn').hide();
			$('#textSpenBarCode').hide();
			$('#textSpenBarCode').val('');
			$("#textSpenBarCode").blur();	//取消焦点
			$('#btnEnterResult').hide();
			$('#btnPrintResult').show();
			obj.RepStaus = $('#cboRepStatus').val()
			obj.FlowFlg = '';
			var wh = $(window).height();
			//$("#divPanel").height(wh-173);	
		}else if (val=="2")
		{
			// 发材料
			$('#IsRepStatusAtt').hide();
			$('#btnHairMaterial').show();
			$('#btnHairMaterialAll').show();
			$('#btnRecSpecn').hide();
			$('#textSpenBarCode').show();
			$("#textSpenBarCode").focus();
			$('#textSpenBarCode').val('');
			$('#btnEnterResult').hide();
			$('#btnPrintResult').hide();
			obj.RepStaus = 1;
			obj.FlowFlg = 1;
			var wh = $(window).height();
			//$("#divPanel").height(wh-208);
		}else if (val=="3")
		{
			// 收标本
			$('#IsRepStatusAtt').hide();
			$('#btnHairMaterial').hide();
			$('#btnHairMaterialAll').hide();
			$('#btnRecSpecn').show();
			$('#textSpenBarCode').show();
			$("#textSpenBarCode").focus();
			$('#textSpenBarCode').val('');
			$('#btnEnterResult').hide();
			$('#btnPrintResult').hide();
			obj.RepStaus = 2;
			obj.FlowFlg = 1;
			var wh = $(window).height();
			//$("#divPanel").height(wh-208);	
		}else{
			// 录结果
			$('#IsRepStatusAtt').hide();
			$('#btnHairMaterial').hide();
			$('#btnHairMaterialAll').hide();
			$('#btnRecSpecn').hide();
			$('#textSpenBarCode').show();
			$("#textSpenBarCode").focus();
			$('#textSpenBarCode').val('');
			$('#btnEnterResult').show();
			$('#btnPrintResult').hide();
			obj.RepStaus = 3;
			obj.FlowFlg = 1;
			var wh = $(window).height();
			//$("#divPanel").height(wh-208);
		}
		obj.reloadgridReuslt();
	});
	
	//查询按钮
	$("#btnQuery").on('click',function(){
		obj.reloadgridReuslt();
	});

	//重新加载表格数据
	obj.reloadgridReuslt = function(){
		
		var HospIDs	    = $("#cboHospital").val();
		var DateFrom	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		var ApplyLoc 	= $("#cboApplyLoc").val();
		
		var ErrorStr = "";
		if (HospIDs=="") {
			ErrorStr += '请选择院区!<br/>';
		}
		if (DateFrom=="") {
			ErrorStr += '请选择开始日期!<br/>';
		}
		if (DateTo == "") {
			ErrorStr += '请选择结束日期!<br/>';
		}
		if (!$.form.CompareDate(DateTo,DateFrom)){
    		ErrorStr += '起始日期不允许大于截止日期!<br>';
    	}
		
		if (ErrorStr != '') {
			layer.msg(ErrorStr,{icon: 0});
			return;
		}
		obj.gridReuslt.clear().draw();
		obj.gridReuslt.ajax.reload( function ( json ) {
		    if (json.data.length==0){
				layer.msg('没有找到相关数据！',{time: 2000,icon: 2});
				return;
			}
		});
	};
	
	//add 		查询界面结果打印
	$('#btnPrintResult').on('click',function(){
		var selectedRows = obj.gridReuslt.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.msg('请选择一条记录！');
			return;
		}

		var rd = obj.gridReuslt.rows({selected: true}).data().toArray()[0];
		var reportId = parseInt(rd['ReportID']);
		
		var url="dhccpmrunqianreport.csp?reportName=DHCHAI.EnviHyReport.raq&aReportID="+reportId;
        websys_createWindow(url,1,"width=710,height=610,top=0,left=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	});
	//end

	// 明细链接选中方式
    $('#gridReuslt').on('click','a.detail', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridReuslt.row(tr);
		var rowData = row.data();
		obj.ReportID = rowData.ReportID;
		obj.SpenBarCode='';
		layer.open({
			type: 1,
			zIndex: 100,
			area: ['700px','520px'],
			skin: 'layer-class',
			title: '标本明细', 
			content: $('#layerSpenDetail'),
			btn: ['关闭'],
			btnAlign: 'c',
			success: function(layero){
				refreshSpenDetailGrid()
			}	
		}); 
    });

    // 刷新标本明细列表
    function refreshSpenDetailGrid()
	{
		if(obj.gridSpenDetail==null)
		{
			obj.gridSpenDetail = $("#gridSpenDetail").DataTable({
				dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
				paging: true,
				ordering: false,
				info: true,
				//select: 'single',
				"processing" : true,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.EnviHyReportSrv";
						d.QueryName = "QryBarCodeStatus";
						d.Arg1 =obj.ReportID;
						d.ArgCnt = 1;
					}
				},
				"columns": [
					{"data": "BarCode"},
					{"data": "StatusDesc"},
					{"data": "LogDate"},
					{"data": "LogTime"},
					{"data": "LogUser"}
				],
				"rowCallback": function( row, data, index ) {
				    if (data.BarCode==obj.SpenBarCode) {
				     	$(row).css('background-color','#40A2DE')
				    }
				  }
			});
		} else {
			obj.gridSpenDetail.ajax.reload();
		}
	}

	// 结果链接选中方式
    $('#gridReuslt').on('click','a.result', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridReuslt.row(tr);
		var rowData = row.data();
		obj.ReportID = rowData.ReportID;
		obj.SpenBarCode='';
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
				refreshResultDetail()
			}	
		}); 
    });

    // 刷新结果明细列表
    function refreshResultDetail()
	{
		if(obj.gridResultDetail==null)
		{
			obj.gridResultDetail = $("#gridResultDetail").DataTable({
				dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
				paging: true,
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

	// 发材料
	$('#btnHairMaterial').on('click',function(){
		var selectedRows = obj.gridReuslt.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.msg('请选择一条申请记录！',{time: 2000,icon: 2});
			return;
		}
		var rd = obj.gridReuslt.rows({selected: true}).data().toArray()[0];
		if (parseInt(rd['SpecimenNum'])==0){
			var tips = '确认发放材料'+parseInt(rd['EvItemSpenNum'])+'个?';
		}else{
			var tips = '确认补发材料'+(parseInt(rd['EvItemSpenNum'])-parseInt(rd['SpecimenNum']))+'个?';
		}
		layer.confirm( tips, {
			btn: ['确认','取消'],
			btnAlign: 'c'
			},
			function(){ 
				HairMaterial(rd);
		});
	});

	// 全部发放
	$('#btnHairMaterialAll').on('click',function(){
		var num = 0;
		obj.gridReuslt.rows().data().each(function(rd,index){
				num += (parseInt(rd["EvItemSpenNum"])-parseInt(rd['SpecimenNum']));
		});
		if (num == 0) {
			layer.msg('无材料需要发放！',{time: 2000,icon: 2});
			return;
		}
		layer.confirm( '确认发放全部材料，共计'+num+'个?', {
			btn: ['确认','取消'],
			btnAlign: 'c'
			},
			function(){ 
				obj.gridReuslt.rows().data().each(function(rd,index){
				HairMaterial(rd);
			});
		});
	});

	function HairMaterial(rd){
		var inputStr = rd["ReportID"];
		inputStr = inputStr + '^' + '';
		inputStr = inputStr + '^' + $('ul .active').val();
		inputStr = inputStr + '^' + $.LOGON.LOCID;
		inputStr = inputStr + '^' + $.LOGON.USERID;

		var retval = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyReport","ReceiveSpecimen",inputStr,'^');
		if (parseInt(retval)>0){
			obj.gridReuslt.clear().draw();
			obj.gridReuslt.ajax.reload( function ( json ) {
			    layer.msg('发放材料成功!',{icon: 1});
			});
		} else {
			layer.msg('发放材料失败',{icon: 2});
		}
	}

	// 接收标本
	$('#btnRecSpecn').on('click',function(){
		var selectedRows = obj.gridReuslt.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.msg('请选择一条申请记录！',{time: 2000,icon: 2});
			return;
		}
		var rd = obj.gridReuslt.rows({selected: true}).data().toArray()[0];
		layer.confirm( '确认接收标本?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
				ReceiveSpecimen(rd);
		});
	});

	function ReceiveSpecimen(rd){
		var inputStr = rd["ReportID"];
		inputStr = inputStr + '^' + '';
		inputStr = inputStr + '^' + $('ul .active').val();
		inputStr = inputStr + '^' + $.LOGON.LOCID;
		inputStr = inputStr + '^' + $.LOGON.USERID;

		var retval = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyReport","ReceiveSpecimen",inputStr,'^');
		if (parseInt(retval)>0){
			obj.gridReuslt.clear().draw();
			obj.gridReuslt.ajax.reload( function ( json ) {
			    layer.msg('接收标本成功!',{icon: 1});
			});
		} else {
			layer.msg('接收标本失败',{icon: 2});
		}
	}

	// 结果录入
	$('#btnEnterResult').on('click',function(){
		var selectedRows = obj.gridReuslt.rows({selected: true}).count();
		if ( selectedRows !== 1 ) {
			layer.msg('请选择一条申请记录！',{time: 2000,icon: 2});
			return;
		}
		var rd = obj.gridReuslt.rows({selected: true}).data().toArray()[0];
		obj.ReportID = rd['ReportID'];
		$('#layerReuslt').remove();
		var html = '<div class="layer" id="layerReuslt" style="display:none;"><div class="modal-body"><form class="form-horizontal" role="form">';
		var SpecimenNum = rd['EvItemSpenNum'];
		var CenterNum = rd['CenterNum'];		// 中心
		var SurroundNum = rd['SurroundNum'];
		var CheckArry = [];
		for(var i=1;i<=SpecimenNum;i++){
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
			CheckArry[i] = 0;
			var SpenBar = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyReport","GetSpenBarCode",obj.ReportID,i);
			var SpenStatus = $.Tool.RunServerMethod("DHCHAI.IRS.EnviHyReportSrv","GetSpenInfo",SpenBar);
			if ((SpenStatus.split('^')[0]!=3)&&(SpenStatus.split('^')[0]!=4)){	// 还未接收
				CheckArry[i] = 1;
				continue;
			}
			html += '<div class="form-group">'
			html += '<label class="col-sm-2 control-label">'+SubItemDesc+'</label>'
			html += '<label class="col-sm-2 control-label" for="txtbacteriaNum'+i+'">菌落数</label>'
			html += '<div class="col-sm-2">'
			html += '<input class="form-control" id="txtbacteriaNum'+i+'" type="text" onkeyup="value=value.replace(/[^\\d]/g,\'\')" placeholder="菌落数..." />'
			html += '</div>'
			html += '<label class="col-sm-2 control-label" for="cboBacteria'+i+'">致病菌</label>'
			html += '<div class="col-sm-4">'
			html += '<select class="form-control" id="cboBacteria'+i+'" name="cboBacteria'+i+'" data-set="DHCHAI.DPS.LabBactSrv:QryLabBacteria" data-col="ID^BacDesc" data-param="Arg">'
			html += '</select>'
			html += '</div>'
			html += '</div>'
		}
		html += '</form></div></div>'
		$('body').append(html)
		for(var i=1;i<=SpecimenNum;i++){
			if (CheckArry[i]){	// 还未接收
				continue;
			}
			var str = '$.form.SelectRender1("cboBacteria'+i+'\",1)';
			eval(str);
		}
		layer.open({
			type: 1,
			zIndex: 100,
			area: '600px',
			skin: 'layer-class',
			title: '结果录入', 
			content: $('#layerReuslt'),
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
				var inputStr = obj.ReportID;
				inputStr = inputStr + '^' + $.LOGON.LOCID;
				inputStr = inputStr + '^' + $.LOGON.USERID;
				inputStr = inputStr + '^' + $('ul .active').val();
				for (var i=0;i<SpecimenNum;i++){
					if ($("#txtbacteriaNum"+(i+1)).length>0){
						var reuslt = $.form.GetValue("txtbacteriaNum"+(i+1));
						var BacteriaID = $.form.GetValue("cboBacteria"+(i+1));
						
						var SpenBar = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyReport","GetSpenBarCode",obj.ReportID,(i+1));
						
						if ((reuslt=="")&&(BacteriaID=="")){
							continue ;
						}
						inputStr = inputStr + '^' + reuslt + '^' + BacteriaID + '^' + SpenBar;
					}
				}
				var retval = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyReport","EnterResult",inputStr,"^");
				if (parseInt(retval)>0){
					layer.closeAll();
					obj.gridReuslt.clear().draw();
					obj.gridReuslt.ajax.reload( function ( json ) {
					    layer.msg('结果录入成功!',{icon: 1});
					});
				} else {
					layer.msg('结果录入失败',{icon: 2});
				}
			},
			btn2:function(index,layero){
			  	$("#textSpenBarCode").focus();
				$('#textSpenBarCode').val('');
			},
			success: function(layero){
				var runQuery = $.Tool.RunQuery('DHCHAI.IRS.EnviHyReportSrv','QryResultDetail',obj.ReportID);
				for (var i = 0; i <=runQuery.record.length-1; i++) {
					var Result = runQuery.record[i].Result;
					var BactID = runQuery.record[i].BactID;
					var BactDesc = runQuery.record[i].BactDesc;
					var str = '$.form.SetValue("txtbacteriaNum'+(i+1)+'",Result);'
					eval(str);
					if (BactID){
						// var str = '$.form.SetValue("cboBacteria'+(i+1)+'",BactID,BactDesc);'
						var str = '$("#cboBacteria'+(i+1)+'").append(new Option(BactDesc,BactID, false, true));'
						eval(str);
					}
				}
			}
		}); 
	});

	// 标本条码回车
	$("#textSpenBarCode").keyup(function(event){
        if (event.keyCode == 13) {
	        obj.SpenBarCode = $('#textSpenBarCode').val();
	        // 获取报告ID
	        obj.ReportID = $.Tool.RunServerMethod('DHCHAI.IRS.EnviHyReportSrv','GetRepIDBySpenBar',obj.SpenBarCode);
	        if (obj.ReportID==''){
	        	layer.msg('标本条码错误！',{icon: 0});
	        	$("#textSpenBarCode").val('');
	        	return;
	        }
	        $("#textSpenBarCode").blur();	//取消焦点
	        var OperType = $('ul .active').val();
	        var SpenBarStatus = $.Tool.RunServerMethod('DHCHAI.IRS.EnviHyReportSrv','GetSpenStatus',obj.SpenBarCode);
	        if (OperType==1){
	        }else if (OperType==2){		// 发材料
	        	layer.open({
					type: 1,
					zIndex: 100,
					area: '800px',
					skin: 'layer-class',
					title: '材料发放', 
					content: $('#layerSpenDetail'),
					btn: ['发放材料','关闭'],
					btnAlign: 'c',
					yes: function(index, layero){
						var inputStr = '';
						inputStr = inputStr + '^' + obj.SpenBarCode;
						inputStr = inputStr + '^' + $('ul .active').val();
						inputStr = inputStr + '^' + $.LOGON.LOCID;
						inputStr = inputStr + '^' + $.LOGON.USERID;
					  	var retval = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyReport","ReceiveSpecimen",inputStr,"^");
						if (parseInt(retval)>0){
							layer.closeAll();
							obj.gridReuslt.clear().draw();
							obj.gridReuslt.ajax.reload( function ( json ) {
							    layer.msg('发放材料成功!',{icon: 1});
							});
							$("#textSpenBarCode").focus();
							$('#textSpenBarCode').val('');
						} else {
							layer.msg('发放材料失败',{icon: 2});
						}
					},
					btn2:function(index,layero){
					  	$("#textSpenBarCode").focus();
						$('#textSpenBarCode').val('');
					},
					success: function(layero){
						refreshSpenDetailGrid();
					}	
				}); 
	        }else if (OperType==3){		// 接收标本
	        	layer.open({
					type: 1,
					zIndex: 100,
					area: '800px',
					skin: 'layer-class',
					title: '标本接收', 
					content: $('#layerSpenDetail'),
					btn: ['接收标本','关闭'],
					btnAlign: 'c',
					yes: function(index, layero){
					  	var inputStr = '';
						inputStr = inputStr + '^' + obj.SpenBarCode;
						inputStr = inputStr + '^' + $('ul .active').val();
						inputStr = inputStr + '^' + $.LOGON.LOCID;
						inputStr = inputStr + '^' + $.LOGON.USERID;
					  	var retval = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyReport","ReceiveSpecimen",inputStr,"^");
						if (parseInt(retval)>0){
							layer.closeAll();
							obj.gridReuslt.clear().draw();
							obj.gridReuslt.ajax.reload( function ( json ) {
							    layer.msg('标本接收成功!',{icon: 1});
							});
							$("#textSpenBarCode").focus();
							$('#textSpenBarCode').val('');
						} else {
							layer.msg('标本接收失败',{icon: 2});
						}
					},success: function(layero){
						refreshSpenDetailGrid();
						$("#textSpenBarCode").focus();
						$('#textSpenBarCode').val('');
					}	
				}); 
	        }else if (OperType==4){		// 结果录入

	        	layer.open({
					type: 1,
					zIndex: 100,
					area: '600px',
					skin: 'layer-class',
					title: '结果录入', 
					content: $('#layerEnterSingleReuslt'),
					btn: ['保存','关闭'],
					btnAlign: 'c',
					yes: function(index, layero){
						inputStr = obj.ReportID;
						inputStr = inputStr + '^' + $.LOGON.LOCID;
						inputStr = inputStr + '^' + $.LOGON.USERID;
						inputStr = inputStr + '^' + $('ul .active').val();
						inputStr = inputStr + '^' + $.form.GetValue("txtbacteriaNum");
						inputStr = inputStr + '^' + $.form.GetValue("cboBacteria");
						inputStr = inputStr + '^' + obj.SpenBarCode;
					  	var retval = $.Tool.RunServerMethod("DHCHAI.IR.EnviHyReport","EnterResult",inputStr,"^");
						if (parseInt(retval)>0){
							layer.closeAll();
							obj.gridReuslt.clear().draw();
							obj.gridReuslt.ajax.reload( function ( json ) {
							    layer.msg('结果录入成功!',{icon: 1});
							});
							$("#textSpenBarCode").focus();
							$('#textSpenBarCode').val('');
						} else {
							layer.msg('结果录入失败',{icon: 2});
						}
					},
					success: function(layero){
						var result = $.Tool.RunServerMethod("DHCHAI.IRS.EnviHyReportSrv","GetResultBySpenBar",obj.SpenBarCode);
						if (result==''){
							$.form.SetValue("txtbacteriaNum",'');
							$("#cboBacteria").append(new Option('','', false, true));
						}else{
							$.form.SetValue("txtbacteriaNum",result.split('^')[1]);
							// $.form.SetValue("cboBacteria",result.split('^')[2],result.split('^')[3]);
							$("#cboBacteria").append(new Option(result.split('^')[3],result.split('^')[2], false, true));
						}
						$("#textSpenBarCode").focus();
						$('#textSpenBarCode').val('');
					}	
				}); 
	        }
        }
    });
}

