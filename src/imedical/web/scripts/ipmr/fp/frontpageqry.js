/**
 * frontpageqry 编目查询
 * 
 * Copyright (c) 2018-2022 liyi. All rights reserved.
 * 
 * CREATED BY liyi 2022-01-17
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
	m_wfitemid		: '',			// 编目工作流项目id
	m_QryType		: ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	var tdateFrom	= Common_GetDate(-30,"");
	var tdateTo		= Common_GetDate(0,"");	
	$('#dfDateFrom').datebox('setValue', tdateFrom);		// 给日期框赋值
	$('#dfDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	if (ServerObj.ToCodeQueryLogic!=='2') {
		document.getElementById("btnReciveFrontPage").style.display='none';  //标签隐藏
	}
	Common_ComboToHosp('cboHosp','',Logon.HospID);
	Common_ComboToMrType('cboMrType',ServerObj.MrClass);
	Common_ComboToLocGroup('cboLocgroup','E','-');
	Common_ComboGridToUser("cboEncoder","");
	InitGridVolume();
	Common_Focus('txtMrNo');
}

function InitEvent(){
	// 医院、科室联动
	$('#cboHosp').combobox({
	    onSelect:function(rows){
	    	var LocGroup = $("#cboLocgroup").combobox('getValue');
			Common_ComboToLoc('cboLocation','','E',rows["HospID"],ServerObj.MrClass,LocGroup);
	    }
	})
	
	// 科室组、科室联动
	$('#cboLocgroup').combobox({
	    onSelect:function(rows){
	    	var Hosp = $("#cboHosp").combobox('getValue');
			Common_ComboToLoc('cboLocation','','E',Hosp,ServerObj.MrClass,rows["ID"]);
	    }
	})
	
	// 病案类型选择
	$('#cboMrType').combobox({
	    onSelect:function(rows){
			$cm({
				ClassName:"CT.IPMR.BT.WorkFItem",
				MethodName:"GetWFItemBySysOpera",
				aMrTypeID:rows["ID"],
				aSysOpera:'FP'
			},function(rtn){
				globalObj.m_wfitemid = rtn.ID;
			});
	    }
	})
	
	// 已编按钮
	$('#btnQry').click(function(){
		QueryVolume(1);
		globalObj.m_QryType =1;
	});
	
	// 未编按钮
	$('#btnUnCodeQry').click(function(){
		$('#cboEncoder').combogrid('clear');
		QueryVolume(2);
		globalObj.m_QryType =2;
	});
	
	// 出院查询按钮
	$('#btnDischQry').click(function(){
		$('#cboEncoder').combogrid('clear');
		QueryVolume(3);
		globalObj.m_QryType =3;
	});
	
	// 接收首页按钮
	$('#btnReciveFrontPage').click(function(){
		var aDateFrom = $("#dfDateFrom").datebox('getValue');
 		var aDateTo = $("#dfDateTo").datebox('getValue');
 		if (aDateFrom==''){
			$.messager.popover({msg: '请选择查询日期！',type: 'alert',timeout: 1000});
			return false;
		}
		if (aDateTo==''){
			$.messager.popover({msg: '请选择结束日期！',type: 'alert',timeout: 1000});
			return false;
		}
		$m({
			ClassName:"MA.IPMR.FPS.EmrFrontPageSrv",
			MethodName:"BachRecieve",
			aDateFrom:aDateFrom,
			aDateTo:aDateTo
		},function(txtData){
			$.messager.popover({msg: '接收完成！',type: 'success',timeout: 1000});
			// 自动加载待编列表
			$('#btnUnCodeQry').click();
		});
	});
	
	// 草稿查询按钮
	$('#btnDraftQry').click(function(){
		QueryVolume(4);
		globalObj.m_QryType =4;
	});
	
	// 病案号回车事件
	$('#txtMrNo').keyup(function(e){
		$('#cboEncoder').combogrid('clear');
		if(event.keyCode == 13) {
	      QueryVolume(0);
	    }
	});
	
	// 姓名回车事件
	$('#txtPatName').keyup(function(e){
		$('#cboEncoder').combogrid('clear');
		if(event.keyCode == 13) {
	      QueryVolume(5);
	    }
	});

	// 导出按钮 add20201224
	$('#btnExport').click(function(){
		var data = $('#GridVolume').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		
		var filename ='';
		switch (globalObj.m_QryType)
		{
		case 1:
			filename='已编目病历'
			break;
		case 2:
			filename='未编目病历';
			break;
		case 3:
			filename='出院病历';
			break;
		case 4:
			filename='草稿病历';
			break;
		default:
			filename='病案号查询导出';
			break;
		}
		$('#GridVolume').datagrid('Export', {
			filename: filename,
			extension:'xls'
		});
	});
	
}
 /**
 * NUMS: R001
 * CTOR: liyi
 * DESC: 编目列表
 * DATE: 2021-01-17
 * NOTE: 包括一个方法：InitGridVolume
 * TABLE: 
 **/
 // 初始化病历列表表格
 function InitGridVolume(){
 	var columns = [[
		{field:'PapmiNo',title:'登记号',width:90,align:'left'},
 		{field:'MrNo',title:'病案号',width:80,align:'left'},
 		{field:'PatName',title:'姓名',width:80,align:'left',
			formatter: function(value,row,index){
				if (row.IsDeath==1){
					return row.PatName + "<span style='color: #FF4500'>(死亡)</span>";
				}else{
					return row.PatName;
				}
			}
 		}, 
 		{field:'Sex',title:'性别',width:60,align:'left'},
 		{field:'Age',title:'年龄',width:80,align:'left'},
 		{field:'AdmLocDesc',title:'入院科室',width:150,align:'left'},
 		{field:'DischLocDesc',title:'出院科室',width:150,align:'left',sortable:true},
 		{field:'AdmDate',title:'入院日期',width:100,align:'left'},
 		{field:'DischDate',title:'出院日期',width:100,align:'left'},
 		{field:'FinishDate',title:'首页提交日期',width:100,align:'left',hidden:ServerObj.ToCodeQueryLogic=='2'?false:true,
			formatter:function(value,row,index){
				var FinishDate = row.FinishDate;
				var FinishTime = row.FinishTime;
				return FinishDate+' '+FinishTime;
		}},
 		{field:'IPTimes',title:'住院次数',width:80,align:'left'},
 		{field:'AdmDays',title:'住院天数',width:80,align:'left'},
 		{field:'DocName',title:'医生',width:80,align:'left'},
		{field:'FillNo',title:'归档号',width:100,align:'left',hidden:ServerObj.CreatFillNo==1?false:true},
		{field:'Status1',title:ServerObj.ConfigDesc1,width:80,align:'left',type:'btn',hidden:ServerObj.ConfigDesc1?false:true,
			formatter:function(value,row,index){
				var EpisodeID = row.EpisodeID;
				var VolID = row.VolID;
				return "<a href='#' onclick='openFrontPageEdit(\"" + EpisodeID +"\""+",\"" +VolID + "\");'>"+value+"</a>";
			}
		},
		{field:'Status2',title:ServerObj.ConfigDesc2,width:80,align:'left',type:'btn',hidden:ServerObj.ConfigDesc2?false:true,
			formatter:function(value,row,index){
				var EpisodeID = row.EpisodeID;
				var VolID = row.VolID;
				return "<a href='#' onclick='openFrontPageEdit(\"" + EpisodeID +"\""+",\"" +VolID + "\");'>"+value+"</a>";
			}
		},
		{field:'Status3',title:ServerObj.ConfigDesc3,width:80,align:'left',type:'btn',hidden:ServerObj.ConfigDesc3?false:true,
			formatter:function(value,row,index){
				var EpisodeID = row.EpisodeID;
				var VolID = row.VolID;
				return "<a href='#' onclick='openFrontPageEdit(\"" + EpisodeID +"\""+",\"" +VolID + "\");'>"+value+"</a>";
			}
		},
		{field:'Status4',title:ServerObj.ConfigDesc4,width:80,align:'left',type:'btn',hidden:ServerObj.ConfigDesc4?false:true,
			formatter:function(value,row,index){
				var EpisodeID = row.EpisodeID;
				var VolID = row.VolID;
				return "<a href='#' onclick='openFrontPageEdit(\"" + EpisodeID +"\""+",\"" +VolID + "\");'>"+value+"</a>";
			}
		},
		{field:'Status5',title:ServerObj.ConfigDesc5,width:80,align:'left',type:'btn',hidden:ServerObj.ConfigDesc5?false:true,
			formatter:function(value,row,index){
				var EpisodeID = row.EpisodeID;
				var VolID = row.VolID;
				return "<a href='#' onclick='openFrontPageEdit(\"" + EpisodeID +"\""+",\"" +VolID + "\");'>"+value+"</a>";
			}
		}
		//,{field:'VolStausDesc',title:'卷状态',width:60,align:'left'}
  ]];
 	var GridVolume =$HUI.datagrid("#GridVolume",{
 		fit: true,
 		headerCls:'panel-header-gray',
 		iconCls:'icon-paper',
 		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
 		rownumbers: true, //如果为true, 则显示一个行号列
 		singleSelect: true,
 		//title:'病历查询',
 		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
 		loadMsg:'数据加载中...',
 		pageSize: 10,
 		fitColumns:true,
 	    url:$URL,
 	    queryParams:{
 		    ClassName:"MA.IPMR.FPS.DataMasterSrv",
 			QueryName:"QryVoulueList",
 			aHospID:'',
 			aMrTypeID:'',
 			aDateFrom:'',
 			aDateTo:'',
 			aLocGroupID:'',
 			aDischLocID:'',
 			aInputNum:'',
 			aQryFlg:-1,
 			aEncoder:'',
 			aIsDeath:'',
 			aPatName:'',
 			rows:10000
 	    },
 	    columns :columns,
 		onClickRow:function(rowIndex,rowData){
 			//selectVol(rowData);
 		},
 		onLoadSuccess:function(data) {
 			var queryParams=$(this).datagrid('options').queryParams;
 			if ((data.total==1)&&(queryParams.aQryFlg==0)){
				var EpisodeID = data.rows[0].EpisodeID;
				var VolID = data.rows[0].VolID;
 				openFrontPageEdit(EpisodeID,VolID);
 			}
 		}
 	});
 	return GridVolume;
 }
 
 // 加载病历列表
 function QueryVolume(atypeflg){
 	var objEncoder = $('#cboEncoder').combogrid('grid').datagrid('getSelected');
 	var EncoderID ='',Encoder ='';
 	if (objEncoder!==null){
 		EncoderID = objEncoder.ID;
 		Encoder = objEncoder.Desc;
 	}
 
 	$("#GridVolume").datagrid("reload", {
 		ClassName:"MA.IPMR.FPS.DataMasterSrv",
 		QueryName:"QryVoulueList",
 		aHospID:$("#cboHosp").combobox('getValue'),
 		aMrTypeID:$("#cboMrType").combobox('getValue'),
 		aDateFrom:$("#dfDateFrom").datebox('getValue'),
 		aDateTo:$("#dfDateTo").datebox('getValue'),
 		aLocGroupID:$("#cboLocgroup").combobox('getValue'),
 		aDischLocID:$("#cboLocation").combobox('getValue'),
 		aInputNum:$("#txtMrNo").val(),
 		aQryFlg:atypeflg,
 		aEncoder:EncoderID,
 		aIsDeath:$("#cboIsDeath").combobox('getValue'),
 		aPatName:$("#txtPatName").val()
 	})
   	$('#GridVolume').datagrid('unselectAll');
 }
 
 function openFrontPageEdit(EpisodeID,VolID)
 {
	var strURL = "./ma.ipmr.fp.frontpage.main.csp?EpisodeID=" + EpisodeID;
	// 获取编目锁定状态
	var ret = $m({
    	ClassName:"MA.IPMR.FPS.DataMasterSrv",
    	MethodName:"getLock",
    	aVolumeID:VolID,
    	aUserID:Logon.UserID
    },false);
	if (ret==1){
		$.messager.popover({msg: '多个用户不能同时编一份病案！',type: 'alert',timeout: 1500});
		return
	}
	/*
	var iWidth=(window.screen.availWidth-10)*0.6;                         //弹出窗口的宽度;
	var iHeight=(window.screen.availHeight-50)*0.8;                        //弹出窗口的高度;
	var iTop = (window.screen.height-30-iHeight)/2;       //获得窗口的垂直位置;
	var iLeft = (window.screen.width-10-iWidth)/2;        //获得窗口的水平位置;
	window.open(strURL,"_blank", "height="+iHeight+",width="+iWidth+',top='+iTop+',left='+iLeft+",status=yes,toolbar=no,menubar=no,scrollbars=yes");
	*/
	 var title='病案编目';
	 websys_showModal({
	 	url:strURL,
	 	title:title,
	 	iconCls:'icon-w-epr',  
	 	originWindow:window,
	 	closable:false,
	 	//minimizable:true, 最小化后不见了
	 	width:'100%',
	 	height:'100%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
	 });
 }

/// 刷新病历列表
function ReloadVolume() {
	var queryParams = $('#GridVolume').datagrid('options').queryParams;
	$('#GridVolume').datagrid('load',{
		ClassName:queryParams.ClassName,
		QueryName:queryParams.QueryName,
		aHospID:queryParams.aHospID,
		aMrTypeID:queryParams.aMrTypeID,
		aDateFrom:queryParams.aDateFrom,
		aDateTo:queryParams.aDateTo,
		aLocGroupID:queryParams.aLocGroupID,
		aDischLocID:queryParams.aDischLocID,
		aInputNum:queryParams.aInputNum,
		aQryFlg:queryParams.aQryFlg,
	});
	$('GridVolume').datagrid('unselectAll');
}