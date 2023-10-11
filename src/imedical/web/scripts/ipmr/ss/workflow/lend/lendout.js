/**
 * lend 病案借出
 * 
 * Copyright (c) 2018-2020 liyi. All rights reserved.
 * 
 * CREATED BY liyi 2020-09-15
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
	m_WFIConfig			:'',	  // 操作项目配置属性
	m_OperaFlag			:'',	  // 借出操作标记
	m_ToUserID			:'',	  // 验证用户
	m_RecordIDs			:''       // 工作区选中的卷
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	$('#chkRevoke').checkbox('setValue', false);
	$('#btnRevoke').linkbutton("disable");
	$('#btnRevokeQry').linkbutton("disable");
	$('#cboLendUserx').combo('disable');
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	Common_ComboGridToUser("cboLendUserx","");
	InitGridWorkList();
}

function InitEvent(){
	$HUI.combobox('#cboMrType',{
		onSelect:function(rows){
			$m({
				ClassName:"CT.IPMR.BT.WorkFItem",
				MethodName:"GetWFItemBySysOpera",
				aMrTypeID:rows["ID"],
				aSysOpera:'H',
				aWorkSubFlow:'L'
			},function(rtn){
				if (rtn==''){
					$.messager.alert("提示", "工作流维护错误，请检查工作流配置!", 'info');
					return;
				}
				rtn = JSON.parse(rtn);
				globalObj.m_WFIConfig = {
					WFItemID 	: rtn.ID,
					WFItemDesc	: rtn.BWAlias,
					ItemID		: rtn.BWItem,
					ItemType	: rtn.BWType,
					SubFlow		: rtn.BWSubFlow,
					SysOpera	: rtn.BWSysOpera,
					PreStep		: rtn.BWPreStep,
					PreItems	: rtn.BWPreItems,
					PostStep	: rtn.BWPostStep,
					CheckUser	: rtn.BWCheckUser,
					BeRequest	: rtn.BWBeRequest,
					BatchOper	: rtn.BWBatchOper,
					MRCategory	: rtn.BWMRCategory
				}
				ReLoadWorkList();
			});
		}
	});

	$HUI.combobox('#cboHospital',{
		onSelect:function(rows){
			var chkRevoke	= $('#chkRevoke').checkbox('getValue');
			if (chkRevoke) {
				RevokeQry();
			} else{
				$('#txtNumber').val('');
				ReLoadWorkList();
			}
		}
	});

	$HUI.checkbox('#chkRevoke',{
		onCheckChange:function(e,value){
			if (value) {
				$('#btnRevokeQry').linkbutton("enable");		// 借出查询按钮
				$('#btnSubmit').linkbutton("disable");			// 保存
				$('#btnDetach').linkbutton("disable");			// 删除
				$('#btnClean').linkbutton("disable");			// 清空
				$('#btnRevoke').linkbutton("enable");
				$('#txtNumber').val('');
				$('#cboLendUserx').combogrid('clear');
				$('#gridWorkList').datagrid('showColumn','HappenDate');
				$('#gridWorkList').datagrid('showColumn','HappenUserDesc');
				$('#cboLendUserx').combo('enable');
				globalObj.m_OperaFlag = '';
				$('#gridWorkList').datagrid('loadData',{"total":0,"rows":[]});

			} else{
				$('#btnRevokeQry').linkbutton("disable");		// 借出查询按钮
				$('#btnSubmit').linkbutton("enable");			// 保存
				$('#btnDetach').linkbutton("enable");			// 删除
				$('#btnClean').linkbutton("enable");			// 清空
				$('#btnRevoke').linkbutton("disable");
				$('#txtNumber').val('');
				$('#cboLendUserx').combogrid('clear');
				$('#gridWorkList').datagrid('hideColumn','HappenDate');
				$('#gridWorkList').datagrid('hideColumn','HappenUserDesc');
				$('#cboLendUserx').combo('disable');
				globalObj.m_OperaFlag = '';
				ReLoadWorkList();
			}
		}
	});
	
	// 号码导入
	$('#btnShowImport').click(function(){
		var ImportWin = $HUI.dialog('#ImportWin', {
			title :  '选择文件导入',
			iconCls : 'icon-w-edit',
			modal : true,
			minimizable : false,
			maximizable : false,
			maximizable : false,
			collapsible : false,
			onClose:function(){
				$('#file').val('');
			}
			,buttons:[{
				text:'导入',
				iconCls:'icon-w-import',
				handler:function(){
					var fileList = $('#files').filebox('files');
				    var nameStr = '';
				    if (fileList.length==0) {
				    	$.messager.popover({msg: '请选择要导入的txt文件！',type:'alert',timeout: 1000});
				    	return;
				    }
				    for (var i = 0; i < fileList.length; i++) {
				        var reader = new FileReader();
				        reader.readAsText(fileList[i], "UTF-8");
				        reader.onload = function (e) {
				            var content = e.target.result;
				            $m({
								ClassName:"MA.IPMR.SSService.OperationWL",
								MethodName:"ImportWorkList",
								aHospID:$('#cboHospital').combobox('getValue'),
								aMrTypeID:parseInt($('#cboMrType').combobox('getValue')),
								aWFItemID:globalObj.m_WFIConfig.WFItemID,
								aUserID:Logon.UserID,
								aNumberStr:content
							},function(txtData){
								if (txtData==0) {
				    				$.messager.popover({msg: '导入失败！',type:'error'});
				    				return;
								}else if (txtData==1) {
									$.messager.popover({msg: '导入完成！',type:'success'});
									$('#ImportWin').dialog("close");
									ReLoadWorkList();
								}else{
									var arr = txtData.split('|');
									var info='';
									for (i=0;i<arr.length ;i++ ){
										if (arr[i]=='') continue;
										if (info==''){
											info=arr[i];
										}else{
											info=info+'<br/>'+arr[i];
										}
									}
									$.messager.popover({msg: '未导入号码！',type: 'alert',timeout: 1000});
									$('#ImportWin').dialog("close");
									ReLoadWorkList();
								}
							});
				        }
				    }
				    // 清空
				    var obj = document.getElementById('files') ;
					obj.outerHTML=obj.outerHTML;
				}
			}]
		});
	});	

	// 借出查询
	$('#btnRevokeQry').click(function(){
		RevokeQry();
	});	
		
	// 保存
	$('#btnSubmit').click(function(){
		SubmitVols();
	});

	// 删除
	$('#btnDetach').click(function(){
		Detach();
	});	

	// 清空
	$('#btnClean').click(function(){
		Clean();
	});			

	// 撤销
	$('#btnRevoke').click(function(){
		Revoke();
	});		
		
	// 病案号|登记号|条码
	$('#txtNumber').bind('keyup', function(event) {					
	　　if (event.keyCode == "13") {
			globalObj.m_OperaFlag = 0;
			NumberSearch();
	　　}
	});
	// 姓名
	$('#txtPatName').bind('keyup', function(event) {					
	　　if (event.keyCode == "13") {
			globalObj.m_OperaFlag = 0;
			NameSearch();
	　　}
	});
}

 /**
 * NUMS: W001
 * CTOR: WHui
 * DESC: 工作列表模块
 * DATE: 2019-11-15
 * NOTE: 包括方法：InitGridWorkList，ReLoadWorkList
 * TABLE: 
 */

// 初始化工作列表
function InitGridWorkList(){
	var columns = [[
		{field:'workList_ck',title:'sel',checkbox:true},
		{field:'PatName',title:'姓名',width:120,align:'left'},
		{field:'PapmiNo',title:'登记号',width:100,align:'left'},
		{field:'MrNo',title:'病案号',width:100,align:'left'},
		{field:'Sex',title:'性别',width:60,align:'left'},
		{field:'Age',title:'年龄',width:60,align:'left'},
		{field:'FillNo',title:'归档号',width:100,align:'left'},
		{field:'IdentityCode',title:'身份证号',width:100,align:'left'},
		{field:'DocName',title:'住院医师',width:100,align:'left'},
		{field:'VolStatusDesc',title:'当前状态',width:100,align:'left'},
		{field:'StepDesc',title:'当前步骤',width:80,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
		{field:'DischWardDesc',title:'出院病区',width:150,align:'left'},
		{field:'AdmDate',title:'入院日期',width:100,align:'left'},
		{field:'DischCondit',title:'出院情况',width:80,align:'left'},
		{field:'DischDate',title:'出院日期',width:100,align:'left'},
		{field:'HappenDate',title:$g('借出时间'),width:180,align:'left',hidden:true,
			formatter: function(value,row,index){
				return row.HappenDate+ ' ' + row.HappenTime;
			}
		},
		{field:'HappenUserDesc',title:$g('借出人员'),width:100,align:'left',hidden:true}
	]];
	var gridWorkList = $HUI.datagrid("#gridWorkList",{
		fit:true,
		//title:"病案借出",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 500,
		pageList:[100,200,500,1000],
		fitColumns:false,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
		sortName:'RowIndex',
		sortOrder:'desc',
		url:$URL,
		queryParams:{
			ClassName:"MA.IPMR.SSService.OperationQry",
		    QueryName:"QryOperaVolList",
			aHospID:'',
			aMrTypeID:'',
			aWFItemID:'',
			aDateFrom:'',
			aDateTo:'',
			aDischLoc:'',
			aDischWard:'',
			aUserID:'',
			aOperaFlag:'',
			aUserFrom:'',
			aUserTo:'',
			rows:10000
		},
		columns :columns
	});
}

// 加载工作列表
function ReLoadWorkList(){
	if ($('#chkRevoke').checkbox('getValue')) {
		var UserTo='';
		var objRetrieveUser = $('#cboLendUserx').combogrid('grid').datagrid('getSelected');
		if (objRetrieveUser!==null){
			var UserTo = objRetrieveUser.ID;
		}
		$('#gridWorkList').datagrid('reload',  {
			ClassName:"MA.IPMR.SSService.OperationQry",
			QueryName:"QryUpdoVolList",
			aHospID:$('#cboHospital').combobox('getValue'),
			aMrTypeID:parseInt($('#cboMrType').combobox('getValue')),
			aWFItemID:globalObj.m_WFIConfig.WFItemID,
			aUserFrom:'',
			aInputNo:$('#txtNumber').val(),
			aDateFrom:'',
			aDateTo:'',
			aUserTo:UserTo,
			aDischLoc:'',
			aDischWard:'',
			aPatName:$('#txtPatName').val(),
			rows:10000
		});
		$('#gridWorkList').datagrid('unselectAll');
	} else{
		$('#gridWorkList').datagrid('reload',  {
			ClassName:"MA.IPMR.SSService.OperationQry",
			QueryName:"QryOperaVolList",
			aHospID:$('#cboHospital').combobox('getValue'),
			aMrTypeID:parseInt($('#cboMrType').combobox('getValue')),
			aWFItemID:globalObj.m_WFIConfig.WFItemID,
			aDateFrom:'',
			aDateTo:'',
			aDischLoc:'',
			aDischWard:'',
			aUserID:Logon.UserID,
			aOperaFlag:globalObj.m_OperaFlag,
			aUserFrom:'',
			aUserTo:'',
			rows:10000
		});
		$('#gridWorkList').datagrid('unselectAll');
	}
}

 /**
 * NUMS: W002
 * CTOR: WHui
 * DESC: 查询表单模块
 * DATE: 2019-11-15
 * NOTE: 包括方法：NumberSearch,TodoQry,RevokeQry
 * TABLE: 
 */

// 通过号码查询
function NumberSearch(){
	var chkRevoke	= $('#chkRevoke').checkbox('getValue');
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var ItemID		= globalObj.m_WFIConfig.ItemID;
	var WFItemID	= globalObj.m_WFIConfig.WFItemID;
	var Number		= $('#txtNumber').val();
	var WFItemDesc	= globalObj.m_WFIConfig.WFItemDesc;
	var HospID		= $('#cboHospital').combobox('getValue');
	
	var errinfo		= '';
	if (!HospID) {
		errinfo = errinfo + "请选择医院!<br>";
	}
	if (!MrTypeID) {
		errinfo = errinfo + "请选择病案类型!<br>";
	}
	if (!Number) {
		errinfo = errinfo + "请输入病案号!<br>";
	}
	
	if (errinfo) {
		$.messager.alert("提示",errinfo,"info");
		return;
	}
	if (!chkRevoke) {
		InitGridVolSel(HospID,MrTypeID,globalObj.m_WFIConfig,Number,'');		// 卷选择页面Query
		$('#txtNumber').val('');
		$('#txtPatName').val('');
	} else{
		RevokeQry();		// 记录
		$('#txtNumber').val('');
		$('#txtPatName').val('');
	}
}
// 通过姓名查询
function NameSearch(){
	var chkRevoke	= $('#chkRevoke').checkbox('getValue');
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var ItemID		= globalObj.m_WFIConfig.ItemID;
	var WFItemID	= globalObj.m_WFIConfig.WFItemID;
	var PatName		= $('#txtPatName').val();
	var WFItemDesc	= globalObj.m_WFIConfig.WFItemDesc;
	var HospID		= $('#cboHospital').combobox('getValue');
	
	var errinfo		= '';
	if (!HospID) {
		errinfo = errinfo + "请选择医院!<br>";
	}
	if (!MrTypeID) {
		errinfo = errinfo + "请选择病案类型!<br>";
	}
	if (!PatName) {
		errinfo = errinfo + "请输入姓名!<br>";
	}
	
	if (errinfo) {
		$.messager.alert("提示",errinfo,"info");
		return;
	}
	if (!chkRevoke) {
		InitGridVolSel(HospID,MrTypeID,globalObj.m_WFIConfig,'',PatName);		// 卷选择页面Query
		$('#txtPatName').val('');
		$('#txtNumber').val('');
	} else{
		RevokeQry();		// 记录
		$('#txtPatName').val('');
		$('#txtNumber').val('');
	}
}


// 借出查询
function RevokeQry(){
	var chkRevoke	= $('#chkRevoke').checkbox('getValue');
	if (!chkRevoke) {return;}
	ReLoadWorkList();
}

 /**
 * NUMS: W003
 * CTOR: WHui
 * DESC: 工作列表操作按钮模块
 * DATE: 2019-11-15
 * NOTE: 包括方法：SubmitVols
 * TABLE: 
 */

// 提交卷
function SubmitVols(){
	SaveOpera(1);
}

// 保存操作(附加信息页面调用step=2,校验用户页面调用step=3,主页面"保存"step=1)
function SaveOpera(Step){
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var WFItemID	= globalObj.m_WFIConfig.WFItemID;
	var SubFlow		= globalObj.m_WFIConfig.SubFlow;	// 操作流程, 顺序O、质控Q、借阅L、复印C、封存S
	var	SysOpera	= globalObj.m_WFIConfig.SysOpera;	// 病案回收RC,病案编目FP,病历质控QC,归档上架S...
	
	if (!MrTypeID) {
		$.messager.popover({msg: '请选择病案类型！',type: 'alert',timeout: 1000});
		return;
	}
	
	var data	= $("#gridWorkList").datagrid("getData");
	var selData	= $('#gridWorkList').datagrid('getSelections');
	var length	= data.total;
	var selLen	= selData.length;

	if (length<1) {
		$.messager.popover({msg: '工作列表中无需要保存卷信息！',type: 'alert',timeout: 1000});
		return;
	}
	if (selLen==0) {
		$.messager.popover({msg: '请至少勾选一条需要保存卷信息！',type: 'alert',timeout: 1000});
		return;
	}

	var RecordIDs = '';
	for (var i = 0; i < selLen; i++) {
		var selRowArray = selData[i];
		RecordIDs += ',' + selRowArray.RecordID;
	}
	
	if (RecordIDs != '') RecordIDs = RecordIDs.substr(1,RecordIDs.length-1);
	globalObj.m_RecordIDs	= RecordIDs		// 工作区选中的卷
	if (Step<2) {
		InitLendView('L','H');
		return
	}
	if (Step<3){
		if ((globalObj.m_WFIConfig.CheckUser == '1')&&(ServerObj.EnsSysConfig=='0')){	// 独立服务器部署不校验用户
			InitCheckUser();
			return;
		}
	}
	
	var WFDetail = Lend_ArgsObj.LendInfo;	 // 附加信息
	var flg = $m({
		ClassName:"MA.IPMR.SSService.OperationWL",
		MethodName:"WorkFlowOpera",
		aMrTypeID:MrTypeID,
		aWFItemID:WFItemID,
		aWFDetail:WFDetail,
		aUserID:Logon.UserID,
		aToUserID:globalObj.m_ToUserID,
		aRecordIDs:RecordIDs
	},false);
	
	if (parseInt(flg) <= 0) {
		$.messager.alert("错误", flg.split('^')[1], 'error');
		return;
	}else{
		globalObj.m_ToUserID='';
		ReLoadWorkList();	// 重新加载工作列表
	}
}

// 移出工作列表
function Detach(){
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var WFItemID	= globalObj.m_WFIConfig.WFItemID;
	if (!MrTypeID) {
		$.messager.popover({msg: '请选择病案类型！',type: 'alert',timeout: 1000});
		return;
	}
	var rows = $('#gridWorkList').datagrid('getSelections');  		//取得所有选中行数据，返回元素记录的数组数据
	if (rows.length>0) {
		$.messager.confirm('确认', '确认移除选中数据?', function(r){
			if (r) {
				for (var i = 0; i < rows.length; i++) {
					var rowArray = rows[i];
					var RecordID = rowArray.RecordID;
					
					var flg = $m({
						ClassName:"MA.IPMR.SSService.OperationWL",
						MethodName:"DelVolume",
						aMrTypeID:MrTypeID,
						aWFItemID:WFItemID,
						aRecordIDs:RecordID,
						aUserID:Logon.UserID
					},false);
					
					if (parseInt(flg) <= 0) {
						var rowIndex = $('#gridWorkList').datagrid('getRowIndex',rowArray)+1;  //获取行号
						$.messager.alert("错误", "删除行 " + rowIndex + " 数据错误!Error=" + flg, 'error');
					} else {
						var rowindex = $('#gridWorkList').datagrid('getRowIndex', rows[i]);
						$('#gridWorkList').datagrid('deleteRow',rowindex);
						$('#gridWorkList').datagrid('unselectAll');
						$("#gridWorkList").datagrid("clearSelections");
					}
				}
			}
		});
	}else{
		$.messager.popover({msg: '请选中数据记录,再点击删除！',type: 'alert',timeout: 1000});
		return;
	}
}

// 清空工作列表
function Clean(){
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var WFItemID	= globalObj.m_WFIConfig.WFItemID;
	if (!MrTypeID) {
		$.messager.popover({msg: '请选择病案类型！',type: 'alert',timeout: 1000});
		return;
	}
	
	var data	= $("#gridWorkList").datagrid("getData");
	var length	= data.total;
	
	if (length>0) {
		$.messager.confirm('确认', '确认清空列表?', function(r){
			if (r){
				var flg = $m({
					ClassName:"MA.IPMR.SSService.OperationWL",
					MethodName:"ClearVolume",
					aMrTypeID:MrTypeID,
					aWFItemID:WFItemID,
					aUserID:Logon.UserID
				},false);
				
				if (parseInt(flg) <= 0) {
					$.messager.alert("错误", "清空失败!" + flg, 'error');
				} else {
					$('#gridWorkList').datagrid('loadData',{"total": 0, "rows": []});
					$('#gridWorkList').datagrid('unselectAll');
					$("#gridWorkList").datagrid("clearSelections");
				}
			}
		});
	} else{
		$.messager.popover({msg: '列表中无数据！',type: 'alert',timeout: 1000});
	}
}
// 撤销
function Revoke(){
	var UpdoFlag	= $('#chkRevoke').checkbox('getValue');
	if (!UpdoFlag) {return;}
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var WFItemID	= globalObj.m_WFIConfig.WFItemID;
	var SubFlow		= globalObj.m_WFIConfig.SubFlow;	// 操作流程, 顺序O、质控Q、借阅L、复印C、封存S
	var	SysOpera	= globalObj.m_WFIConfig.SysOpera;	// 病案回收RC,病案编目FP,病历质控QC,归档上架S...
	
	if (!MrTypeID) {
		$.messager.popover({msg: '请选择病案类型！',type: 'alert',timeout: 1000});
		return;
	}
	
	var data	= $("#gridWorkList").datagrid("getData");
	var selData	= $('#gridWorkList').datagrid('getSelections');
	var length	= data.total;
	var selLen	= selData.length;
	
	var RecordIDs = '';
	for (var i = 0; i < selLen; i++) {
		var selRowArray = selData[i];
		RecordIDs += ',' + selRowArray.RecordID;
	}
	if (RecordIDs != '') RecordIDs = RecordIDs.substr(1,RecordIDs.length-1);
	
	if (RecordIDs == ''){
		$.messager.popover({msg: '请选择需撤销的操作记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	$.messager.prompt("提示", "输入撤销原因:", function (r) {
		if (r) {
			var flg = $m({
				ClassName:"MA.IPMR.SSService.OperationWL",
				MethodName:"UpdoWorkFlowOpera",
				aRecordIDs:RecordIDs,
				aUserID:Logon.UserID,
				aUpdoReason:r
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "撤销失败!" + '<br>' + flg, 'error');
			} else {
				$('#gridWorkList').datagrid('reload');
				$('#gridWorkList').datagrid('unselectAll');
				$("#gridWorkList").datagrid("clearSelections");
			}
		} else {
			if (r=='') {
				$.messager.popover({msg: '输入信息为空，未做任何操作！',type: 'alert',timeout: 1000});
			}
		}
	});
}