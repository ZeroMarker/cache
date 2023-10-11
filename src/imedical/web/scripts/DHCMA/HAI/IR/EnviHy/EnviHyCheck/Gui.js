//页面gui
var objScreen = new Object();
function InitviewScreen(){
	//
	var obj = objScreen;
    $.parser.parse(); // 解析整个页面
    LogonHospID=$.LOGON.HOSPID;
	LogonUserID=$.LOGON.USERID;
	LogonLocID=$.LOGON.LOCID;
	LogonLocDesc=$.LOGON.LOCDESC;
	for (var row = 2; row < 21; row++){
		$('#div'+row ).css("display", "none");				
	}
	//页签切换参数值
	obj.TabArgs = new Object();
	obj.TabArgs.ContentID    = '';
	obj.TabArgs.HospIDs      = '';
	obj.TabArgs.HospDesc     = '';
	obj.TabArgs.LocID        = '';
	obj.TabArgs.LocDesc      = '';
	obj.TabArgs.StatusCode   = '';
	obj.TabArgs.StatusDesc   = '';
	obj.TabArgs.StandardCode = '';
	obj.TabArgs.StandardDesc = '';
	obj.TabArgs.SttDate      = '';
	obj.TabArgs.EndDate      = '';
	
	//报告信息、录入结果
	obj.ReportObj = null;
	obj.arrResult = null;
	
	//获取状态执行状态列表
	obj.StatusOrder = ServerObj.StatusList;
	obj.StatusDicList = ServerObj.StatusDicList;
	obj.IsValidReason = ServerObj.IsValidReason;
	//医院列表
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:LogonHospID
	},false);
	obj.HospData = HospList.rows;
    //获取报告对象
	obj.GetResult = function(aRepId,aBarcode){
		var rstInfo = $m({
			ClassName   : "DHCHAI.IRS.EnviHyReportSrv",
			MethodName  : "GetReportResults",
			aReportID  : aRepId,
			aBarcode    : aBarcode
		},false);
		if (!rstInfo) return '';
		
		var arrInfo = rstInfo.split('!!');
		var arrResult = new Array();
		for (indRow = 0; indRow < arrInfo.length; indRow++){
			var rowInfo = arrInfo[indRow];
			if (!rowInfo) continue;
			var rd = rowInfo.split('^');
			var objResult = new Object();
			objResult.SpecNumber   = rd[0];
			objResult.SpecNumDesc  = rd[1];
			objResult.RstTypeCode  = rd[2];
			objResult.RstTypeDesc  = rd[3];
			objResult.Result       = rd[4];
			objResult.BactID       = rd[5];
			objResult.BactDesc     = rd[6];
			arrResult[objResult.SpecNumber] = objResult;
		}
		return arrResult
	}
    $HUI.combobox("#cboHospital",{
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:obj.HospData,
		onSelect:function(rec){//给医院增加Select事件，更新科室列表
			obj.TabArgs.HospIDs=rec.ID
			Common_LookupToLoc('txtMonitorLocDesc','txtMonitorLocID',obj.TabArgs.HospIDs,'O|I','');
			if ($('#txtMonitorLocID').val()!="") {
				$("#txtMonitorLocDesc").lookup('clear');
				$('#txtMonitorLocID').val('');
			}
		},onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	})
		//监测项目列表
	$HUI.combobox("#cboEvItem", {
		valueField:'ID',
		textField:'ItemDesc',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		panelHeight:300,
		editable:true  ,
		onShowPanel: function () {
			if (tDHCMedMenuOper['Admin']=="1"){
				var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID="+""+"&aEvItemFL="+$('#cboEvItemFL').combobox('getValue');
			}else{
				var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID="+$('#cboMonitorLoc').combobox('getValue')+"&aEvItemFL="+$('#cboEvItemFL').combobox('getValue');
			}
			$("#cboEvItem").combobox('reload',url);
		}
	});
	var cboEvItemFLList = $cm ({
			ClassName:"DHCHAI.BTS.DictionarySrv",
			QueryName:"QryDic",
			aTypeCode:"EHItemType"
		},false);
	obj.EvItemFL = cboEvItemFLList.rows;
	$HUI.combobox("#cboEvItemFL",{
			valueField:'ID',
			textField:'DicDesc',
			editable:false,
			data:obj.EvItemFL,
			onSelect:function(rec){
				//Common_ComboToLoc('cboMonitorLoc',rec.ID);
				$HUI.combobox("#cboEvItem", {
					valueField:'ID',
					textField:'ItemDesc',
					onShowPanel: function () {
						//var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyItemSrv&QueryName=QryEvItem&aIsActive=1&ResultSetType=Array&EvItemFL="+rec.ID;
						if (tDHCMedMenuOper['Admin']=="1"){
							var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID="+""+"&aEvItemFL="+rec.ID;
						}else{
							var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID="+$('#cboMonitorLoc').combobox('getValue')+"&aEvItemFL="+rec.ID;
						}
						$("#cboEvItem").combobox('reload',url);
					}
				});
			},onLoadSuccess:function(data){
				// 院区默认选择
				//Common_ComboDicID('cboItemType','EHItemType');
				//$('#cboEvItemFL').combobox('select',data[0].ID);
			}
		});
	//状态列表
	obj.cboStatus=Common_ComboDicCode('cboStatus','EHRepStatus',true);
	//是否合格列表
	obj.cboStandard=Common_ComboDicCode('cboStandard','EHStandard');
	//开始日期、结束日期
	obj.TabArgs.SttDate    = Common_GetCalDate(-7);
	obj.TabArgs.EndDate    = Common_GetDate(new Date());
	obj.txtStartDate = $('#txtStartDate').datebox('setValue', obj.TabArgs.SttDate);
	obj.txtEndDate = $('#txtEndDate').datebox('setValue', obj.TabArgs.EndDate);
	
	obj.gridReuslt =$HUI.datagrid("#gridReuslt",{
		height:700,
		width:1810,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,  //是否允许多选
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		fitColumns: false, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		sortOrder:'asc',
		remoteSort:false,
		onLoadSuccess: function (data) {
    		$('#gridReuslt').datagrid("selectRow", 0);
    	},
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:'80',auto:false},
			{field:'ReportID',title:'ID',align:'center',width:'80',sortable:true},
			{field:"BarCode",title:"申请号",width:125,sortable:true,
	        	formatter:function(value,row,index){
		        	if (row.ReCheckSign == '1'){
						return '┏' + value+"&nbsp";
					} else if (row.ReCheckSign == '2'){
						return '┃' + value+"&nbsp";
					} else if (row.ReCheckSign == '3'){
						return '┗' + value+"&nbsp";
					} else {
						return value;
					}
		        }
	        },
			{field:'ItemDesc',title:'监测项目',width:180,sortable:true},
			{field:'ItemObjDesc',title:'监测对象',width:'80',sortable:true},
			{field:'StatusDesc',title:'&nbsp;&nbsp;状态',width:'100',align:'left',sortable:true,
				formatter: function(value,row,index){
					var btn = '<a style="padding-left:5px;" href="#" onclick="objScreen.winReportLog_show(\'' + row["ReportID"] + '\')">' + value + '</a>';
					return btn;
				}
			},
			{field:'MonitorDate',title:'监测日期',width:'100',align:'center',sortable:true,sorter:Sort_int},
			{field:'MonitorLocDesc',title:'监测科室',width:'100',sortable:true},
			{field:'SpecTypeDesc',title:'标本类型',width:'80',sortable:true},
			{field:'SpecimenNum',title:'标本数量',width:'80',align:'center',sortable:true},
			{field:'EnterTypeDesc',title:'录入方式',width:'80',align:'center',sortable:true},
			{field:'StandardDesc',title:'是否合格',width:'80',align:'center',sortable:true,
				styler: function(value,row,index){
							if (value=="不合格"){
						return 'background-color:#FF7256;';
					}else if (value=="合格"){
						return 'background-color:green;'
						}
					else{
						return 'background-color:#AAAAAA;'
					}
				},
				formatter: function(value,row,index){
					if (value=="") value="无结果";
					var btn = '<a href="#" style="color:#fff;" onclick="objScreen.winEnterResult_show(\'' + row["ReportID"] + '\')">' + value + '</a>';
					return btn;
				}
			},
			{field:'IsReCheck',title:'是否复检',width:'80',sortable:true},
			{field:'Reason',title:'不合格原因',width:'80',sortable:true,showTip:true,tipWidth:200,tipTrackMouse:true},
			{field:'Action',title:'改进措施',width:'80',sortable:true,showTip:true,tipWidth:200,tipTrackMouse:true},
			{field:'ApplyDate',title:'申请日期',width:'100',sortable:true,sorter:Sort_int},
			{field:'ApplyTime',title:'申请时间',width:'80',sortable:true,sorter:Sort_int},
			{field:'ApplyLocDesc',title:'申请科室',width:'100',sortable:true},
			{field:'ApplyUserDesc',title:'申请人',width:'80',sortable:true},
			{field:'CollDate',title:'采集日期',width:'100',sortable:true,sorter:Sort_int},
			{field:'CollTime',title:'采集时间',width:'80',sortable:true,sorter:Sort_int},
			{field:'CollUserDesc',title:'采集人',width:'80',sortable:true},
			{field:'RecDate',title:'接收日期',width:'100',sortable:true,sorter:Sort_int},
			{field:'RecTime',title:'接收时间',width:'80',sortable:true,sorter:Sort_int},
			{field:'RecUserDesc',title:'接收人',width:'80',sortable:true},
			{field:'RepDate',title:'报告日期',width:'100',sortable:true,sorter:Sort_int},
			{field:'RepTime',title:'报告时间',width:'80',sortable:true,sorter:Sort_int},
			{field:'RepLocDesc',title:'报告科室',width:'100',sortable:true},
			{field:'RepUserDesc',title:'报告人',width:'80',sortable:true}
		]],
		
		onSelect:function(rowIndex,rowData){
		obj.data=rowData
		if(rowData){
		$('#RstItem').val(rowData.ItemDesc);
		var ItemObjValue=rowData.ItemObjDesc;
		if (ItemObjValue=="") ItemObjValue=rowData.ItemObjTxt;
		$('#RstObject').val(ItemObjValue);
		obj.arrResult = obj.GetResult(rowData.ReportID,rowData.Barcode);
		if (obj.arrResult.length>8){
			$("#EnterResult .r-label").css("padding-left","0px")
		}else{
			$("#EnterResult .r-label").css("padding-left","10px")
		}
		
		if (obj.arrResult.length<1) return;
		//中心值、周边值、项目值、参照值-->赋值
		$.each($("#EnterResult tr"),function(index){
				if (index<1) {
					$(this).show();
				} else {
					var objResult = obj.arrResult[index];
					if (objResult){
						$(this).show();
						$('#RstType'+index).combobox({disabled:(true)});
						$('#Result'+index).attr("disabled",(true));
						$('#RstBactDesc'+index).lookup({disabled:(true)});
					} else {
						$(this).hide();
					}
				}
			})
			$('#RstItem').attr("disabled",true);
			$('#RstObject').attr("disabled",true);
			
			//表单设置初始值
			for (var row = 1; row <= 20; row++){
				var objResult = obj.arrResult[row];
				if (objResult){
					$("#ItemNum"+row).text(objResult.SpecNumDesc);
					$('#RstType'+row).combobox('setValue',objResult.RstTypeCode);
					$('#RstType'+row).combobox('setText',objResult.RstTypeDesc);
					$('#Result'+row).val(objResult.Result);
					$('#RstBactID'+row).val(objResult.BactID);
					$('#RstBactDesc'+row).val(objResult.BactDesc);
				}
			}
		}
		
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				//双击事件
				obj.winEnterResult_show(rowData['ReportID']);
				$("#gridReuslt").datagrid("clearSelections");
			}
		},
		onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
			$("#gridReuslt").datagrid("clearSelections");
			//控制操作按钮显示
			//1申请、2材料发放、3标本接收、4录入结果、5、审核结果、6采集标本、0删除
			var StatusCode=$('#cboStatus').combobox('getValue');
			if (obj.TabArgs.ContentID.indexOf('Qry')>-1){
			
				if (obj.StatusOrder.indexOf('|5|')>-1) {
					//需要审核
					if (StatusCode == 5){
						$('#btnPrtReps').show();
						$('#btnDelReps').show();
					} else {
						$('#btnPrtReps').hide();
						$('#btnDelReps').hide();
					}
				} else {
					//不需要审核
					if (StatusCode == 4){
						$('#btnPrtReps').show();
						$('#btnDelReps').show();
					} else {
						$('#btnPrtReps').hide();
						$('#btnDelReps').hide();
					}
				}
			} else if (obj.TabArgs.ContentID.indexOf('CheckReps')>-1){
				if (StatusCode == 5){
					$('#btnPrtReps').show();
					$('#btnDelReps').show();
					$('#btnChkReps').hide();
				}else if (StatusCode == 4){
					$('#btnChkReps').show();
					$('#btnPrtReps').hide();
					$('#btnDelReps').hide();
				} else {
					$('#btnChkReps').hide();
					$('#btnPrtReps').hide();
					$('#btnDelReps').hide();
				}
			}
		}
	});
	if (obj.IsValidReason!=1){
		 $("#gridReuslt").datagrid("hideColumn", "Reason");        //如果非必选,隐藏最后两列
		  $("#gridReuslt").datagrid("hideColumn", "Action");    
	}
	//录入结果弹出窗
	$('#winEnterResult').dialog({
		title: '录入结果',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:false,//true,
		buttons:[{
			text:'保存',
			id:'winEnterResult_btnSave',
			handler:function(){
				obj.winEnterResult_btnSave_click();
				$HUI.dialog('#winEnterResult').close();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winEnterResult').close();
			}
		}]
	});
	//报告状态列表窗
	$('#winStatusList').dialog({
		title: '状态列表',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:false
	});
	$("body").css('background-color','rgba(255, 255, 255, 1)');
	$(".layout-expand-east").css("border-radius",'5px');
	$(".layout-split-east .layout-body").css({'border-bottom-left-radius':'5px','border-bottom-right-radius':'5px'});
	$(".layout-split-east .panel-header-gray").css({'border-top-left-radius':'5px','border-top-right-radius':'5px'});
	$(".layout-panel-east .panel-tool").css("right",'540px');
	$(".layout-panel-east .icon-paper").css("left",'45px');
	$(".layout-panel-east").css("padding-left","10px");
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}