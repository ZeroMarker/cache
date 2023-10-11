//页面Gui
var objScreen = new Object();
function InitPatFindWin(){
	var obj = objScreen;
	obj.IndexID = "";
	obj.LocID = (tDHCMedMenuOper['Admin']==1 ? '':$.LOGON.LOCID);
	var CheckFlg = 0; 
	if (tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //审核权限
	}
	// 日期赋初始值
	var date=new Date();
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	obj.dtDateFrom = $('#dtDateFrom').datebox('setValue',DateFrom);    // 日期初始赋值
	obj.dtDateTo = $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	//医院
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	
	//医院
    $HUI.combobox("#cboHospital",{
		onSelect:function(rec){
			if (CheckFlg!=1){  //非管理员权限科室不允许选择
				Common_ComboToLoc('cboAdmWard',rec.ID,"","I","E");
				Common_ComboToLoc('cboLabWard',rec.ID,"","I","E");
				$('#cboLabWard').combobox('setValue',$.LOGON.LOCID);
				$('#cboLabWard').combobox('setText',$.LOGON.LOCDESC);
				$('#cboLabWard').combobox('disable');
				$('#cboAdmWard').combobox('disable');
			}else {
				Common_ComboToLoc('cboAdmWard',rec.ID,"","I","W");
				Common_ComboToLoc('cboLabWard',rec.ID,"","I","W");
			}
		}
	});
	$HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:'送检日期',selected:true},
			{value:'2',text:'报告日期'}
		],
		valueField:'value',
		textField:'text'
	});
	
	
	$HUI.combobox("#cboIsUnRepeat",{
		data:[
			{value:'1',text:$g('启用')},
			{value:'2',text:$g('不启用'),selected:true}
		],
		valueField:'value',
		textField:'text',
		onSelect:function(rows) {
			var Type = rows.value;
			if (Type==2) {
				$('.RepeatRule').css('color','#999');
				$('#cboUnSpec').combobox('disable');
				$('#cboUnBact').combobox('disable');
			}else {
				$('.RepeatRule').css('color','black');
				$('#cboUnSpec').combobox('enable');
				$('#cboUnBact').combobox('enable');
			}
		}
	});
	
	$HUI.combobox("#cboUnSpec",{
		data:[
			{value:'1',text:$g('多种'),selected:true},
			{value:'2',text:$g('同种')}
		],
		valueField:'value',
		textField:'text'
	});
	
	$HUI.combobox("#cboUnBact",{
		data:[
			{value:'1',text:$g('多耐类型'),selected:true},
			{value:'2',text:$g('细菌')}
		],
		valueField:'value',
		textField:'text'
	});
	
	//感染类型
	$HUI.combobox("#cboInfType",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode=IRInfType&aActive=1',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		valueField:'ID',
		textField:'DicDesc'
	});
	//评估状态
	$HUI.combobox("#cboStatus",{
		data:[
			{value:'0',text:$g('未评估')},
			{value:'1',text:$g('保存')},
			{value:'2',text:$g('提交')},
			{value:'3',text:$g('审核')},
			{value:'4',text:$g('删除')},
		],
		allowNull: true,
		valueField:'value',
		textField:'text'
	});
	
	///加载细菌
	$HUI.combobox("#cboBacteria",{
		url:$URL+'?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBacteria&ResultSetType=Array',
		allowNull: true,       //再次点击取消选中
		valueField:'ID',
		textField:'BacDesc'
	});
	
	///加载多耐类型
	$HUI.combobox("#cboMRBBact",{
		url:$URL+'?ClassName=DHCHAI.IRS.CRuleMRBSrv&QueryName=QryCRuleMRB&ResultSetType=Array',
		editable:false,
		allowNull: true,       //再次点击取消选中
		valueField:'ID',
		textField:'BTDesc'
	});
	obj.gridStat = $HUI.datagrid("#gridStat",{
        fit:true,
		toolbar:[],
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        singleSelect:true,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:"DHCHAI.IRS.CtlMRBSrv",
			QueryName:"StaMRBResult",
			aHospIDs:$("#cboHospital").combobox('getValue'),
			aDateType:$("#cboDateType").combobox('getValue'),
			aDateFrom:$("#dtDateFrom").datebox('getValue'),
			aDateTo:$("#dtDateTo").datebox('getValue'),
			aLocID:obj.LocID
		},
	    columns:[[
	        { field:"DataDesc",title:"送检病区/细菌/评估状态",width:200},
			{ field:"MRBNum",title:"数量",width:60,align:'center'},
			{ field:"MRBRatio",title:"占比",width:90,align:'center'}
		]],
		onSelect:function(rindex,rowData){
			if ((rindex>-1)&(CheckFlg==1)) {   //只允许管理员切换
				obj.gridStat_onSelect();
			}
		}
    });
	//当前床号 CurrAdmBed 改为 AdmBed
	obj.gridApply=$('#gridApply').datagrid({
        fit:true,
		title:'多重耐药菌监控查询',
        toolbar:'#ToolBar',
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		pageSize: 20,
		pageList : [20,50,100,200],
	    columns:[[
			{ field:"RepStatus",title:"评估状态",width:100,sortable:true,sorter:Sort_int,
				formatter:function(value,row,index){
					var txt = $g("未评估");
					var ReportID = row["INFMBRID"];				 
					var EpisodeID=row["AdmID"];
					var LabRepID=row["LabRepID"];
					var LabResID =row["ResultID"];  //检验结果ID		
					if((value!="")&&(value!=undefined)){
						txt = value;
					}
					return '<a href="#" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\',\'' + LabRepID + '\',\'' + LabResID + '\')">'+txt+'</a>';
				}
			},
			{ field:"PapmiNo",title:"登记号",width:100,sortable:true,sorter:Sort_int},
	        { field:"MrNo",title:"病案号",width:100,sortable:true,sorter:Sort_int},
			{ field:"PatName",title:"姓名",width:100,sortable:true,sorter:Sort_int},
			{ field:"LocDesc",title:"送检科室",width:120,sortable:true},
			{ field:"CurrAdmLoc",title:"当前科室",width:120,sortable:true},
			{ field:"AdmBed",title:"当前床号",width:120,sortable:true},
			{ field:"PAAdmDoc",title:"主管医生",width:90,sortable:true},
			{ field:"LabWardDesc",title:"送检病区",width:150,sortable:true},
			{ field:"SpeDesc",title:"标本",width:100,sortable:true},
			{ field:"BacDesc",title:"细菌",width:150,sortable:true},
			{ field:"ActDateTime",title:"送检日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"RepDateTime",title:"报告日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"MRBDesc",title:"多耐类型",width:200,showTip:true,sortable:true,
				formatter:function(value,row,index){
					 var MRBDesc2 = row["MRBDesc2"];
					 var MRBDesc  = row["MRBDesc"];
					 if (MRBDesc2!=""){
						return MRBDesc+"、"+MRBDesc2;
					}else{
						return MRBDesc;
					}
				}
			}, 
			{ field:"InfTypeDesc",title:"感染类型",width:110,sortable:true,
				formatter:function(value,row,index){
					var ResultID=row["ResultID"];
					var MRBOutLabType = row["MRBOutLabType"];
					var RowID=row["ID"];		 
					if (value!=""){
						return '<a href="#" style="color:#000" onclick="objScreen.MenuEdit(\'' +index + '\',\'' + ResultID+ '\',\'' + MRBOutLabType+ '\',\'' + RowID + '\')">'+value+'</a>';
					}else{
						return '<a href="#" onclick="objScreen.MenuEdit(\'' +index + '\',\'' + ResultID+ '\',\'' + MRBOutLabType + '\',\'' + RowID + '\')">'+$g("标记")+'</a>';
					}
				}
			},
			{ field:"link",title:"发送消息",width:100,
				formatter:function(value,row,index){
					 if (CheckFlg != '1') {
						return '';
					} else {
					 	var AdmID 		= row["AdmID"];
					 	var ResultID 	= row["ID"];
					 	var MRBDesc 	= row["MRBDesc"];
					 	var Bacteria 	= row["Bacteria"];
					 	return '<a href="#" onclick="objScreen.SendMessage(\'' + ResultID + '\',\'' + AdmID + '\',\'' + MRBDesc + '\',\'' + Bacteria + '\')">'+$g("发送消息")+'</a>';
					}
				}
			},
			{ field:"link1",title:"药敏结果",width:100,
				formatter:function(value,row,index){
					 var ResultID=row["ResultID"];
					 
					return '<a href="#" onclick="objScreen.OpenReslut(\'' + ResultID + '\')">'+$g("药敏结果")+'</a>';
				}
			},
			{ field:"link2",title:"摘要",width:80,
				formatter:function(value,row,index){
					 var EpisodeID = row["AdmID"];
					 return '<a href="#" onclick="objScreen.OpenMainView(\'' + EpisodeID + '\')">'+$g("摘要")+'</a>';
				}
			},
			{field:"link3",title:'疑似筛查',width:80,
				formatter:function(value,row,index){
					 var EpisodeID = row["AdmID"];
					 return '<a href="#" onclick="objScreen.OpenCCSingle(\'' + EpisodeID + '\')">'+$g("疑似筛查")+'</a>';
				}
			}, 	
			{ field:"ISOOrdDesc",title:"隔离医嘱",width:180,sortable:true},
			{ field:"Gap",title:"报告-隔离间隔",width:180,sortable:true},
			{ field:"ISOSttDateTime",title:"隔离医嘱开始日期",width:150,sortable:true,sorter:Sort_int},
			{ field:"ISOEndDateTime",title:"隔离医嘱结束日期",width:150,sortable:true,sorter:Sort_int},			
			{ field:"Sex",title:"性别",width:50,sortable:true},
			{ field:"Age",title:"年龄",width:80,sortable:true,sorter:Sort_int},
			{ field:"AdmDate",title:"入院日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"DischDate",title:"出院日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"UpdateDate",title:"填写日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"RepUser",title:"填写人",width:100,sortable:true},
			{ field:"UpdateLoc",title:"填写科室",width:150,sortable:true},	
			{ field:"ZY",title:"操作明细",width:80,
			   formatter:function (value, row, index){
					var RepID=row["RepID"];
					return '<a href="#" onclick="objScreen.OpenMBRRepLog(\'' + RepID + '\')">'+$g("操作明细")+'</a>';
			   }
			},
			{ field:"MRBOutLabType",title:"报告方式",width:120,sortable:true}
		]],
		rowStyler: function (index, row) {
        	if (row.InfTypeDesc == "HA(院内感染)") {
         		return 'color:red;';
        	}
        },
        onSelect:function(rowIndex,rowData){
			obj.rowIndex=rowIndex;
        },
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
		}
    });
	//多耐报告操作明细
	obj.gridMBRRepLog=$('#gridMBRRepLog').datagrid({
        fit:true,
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
        columns: [[
			{ field:"SubID",title:"报告ID",width:80},
			{ field:"StatusDesc",title:"操作",width:120},
			{ field:"UpdateDate",title:"操作日期",width:120},
            { field:"UpdateTime",title:"操作时间",width:120},
            { field:"UpdateUserDesc",title:"操作人",width:120}
        ]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });
	obj.gridIRDrugSen=$('#gridIRDrugSen').datagrid({
        fit:true,
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
	    columns:[[
	        { field:"AntDesc",title:"抗生素",width:400},
			{ field:"Sensitivity",title:"药敏结果",width:320,
				formatter: function(value,row,index){
					if (row.IsInt==1) {
						return value +'<div style="display:inline;margin-left:3px;background-color:red;color:#fff;border-radius:3px;font-size:10px;padding:3px;width:20px;height:20px;font-weight: 600;">天</div>';
					}else {
						return value;
					}						
				}		
			}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });
	///加载感染类型
	$HUI.combobox("#cboMakeInfType",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode=IRInfType&aActive=1',
		allowNull: true,       //再次点击取消选中
		valueField:'DicCode',
		textField:'DicDesc'
	});
	$("#divWest>div>div").css("border","none");
	$("#divWest").prev().css("border-radius","4px 4px 0 0");
	$("#divWest").css("border-radius","0 0 4px 4px");
	
	$(".layout-split-west").css("padding-right","5px");
	InitPatFindWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
