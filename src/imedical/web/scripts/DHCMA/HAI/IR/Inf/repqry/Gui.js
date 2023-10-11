//页面Gui
var objScreen = new Object();
var obj = new Object();

function InitCtlResultWin(){
	obj.AdminPower=0;
	if (tDHCMedMenuOper['Admin']==1) {
		obj.AdminPower =1;
	}
	//医院
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
    $HUI.combobox("#cboHospital",{
		onSelect:function(rec){
			Common_ComboToLoc('cboLocation',rec.ID,"","I","E");
			Common_ComboToLoc('cboInfLocation',rec.ID,"","I","E");
			if (obj.AdminPower!=1) {
				$('#cboLocation').combobox('disable');
				$('#cboLocation').combobox('setValue',$.LOGON.LOCID);
			}
		}
	});
	//感染诊断
	obj.cboInfDiags  = $HUI.combobox("#cboInfDiags", {
		url: $URL,
		editable: true,
		allowNull: true, 
		multiple:true,
		rowStyle:'checkbox',
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.InfPosSrv';
			param.QueryName = 'QryInfPosToSelect';
			param.aPosFlg = 2;
			param.ResultSetType = 'array';
		}
	});
	//报告类型
	obj.cboStatus = Common_ComboDicID("cboStatus","InfReportStatus");
	// 日期初始赋值
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	obj.DateFrom = $('#DateFrom').datebox('setValue', DateFrom);    
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));
    //默认日期类型
    $HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:$g('报告日期'),selected:true},
			{value:'2',text:$g('入院日期')},
			{value:'3',text:$g('出院日期')},
			{value:'4',text:$g('感染日期')}
		],
		valueField:'value',
		textField:'text'
	})
	
	//表格
	obj.gridReport = $('#gridReport').datagrid({
        fit:true,
        title:'',
        headerCls:'panel-header-gray',
        iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        singleSelect:false,
        loadMsg:'数据加载中...',
        //是否是服务器对数据排序
        sortOrder:'asc',
		remoteSort:false, 
		pageSize: 20,
		pageList : [20,50,100,200],
        columns:[[
        	{field:'checked',checkbox:'true',align:'left',width:30,auto:false},
			{ field:"ReportStatusDesc",title:"报告状态",width:100,align:'left',sortable:true,
				formatter:function(value,row,index){
					 return '<a href="#"  onclick=obj.ShowResutlDtl(\''+row.ReportID+'\')>'+row.ReportStatusDesc+'</a>';
				}
			},
	        { field:"PatMrNo",title:"病案号",width:100,align:'left',sortable:true},
			{ field:"PatName",title:"姓名",width:100,align:'left',sortable:true},
			{ field:"PatSex",title:"性别",width:50,align:'left',sortable:true},
			{ field:"PatAge",title:"年龄",width:70,align:'left',sortable:true},
			{ field:"AdmitDate",title:"入院日期",width:100,align:'left',sortable:true,sorter:Sort_int},
			{ field:"DischDate",title:"出院日期",width:100,align:'left',sortable:true,sorter:Sort_int},
			{ field:"ReportLocDesc",title:"报告科室",width:100,align:'left',sortable:true},
			{ field:"ReportDate",title:"报告日期",width:100,align:'left',sortable:true,sorter:Sort_int},
			{ field:"InfLocDesc",title:"感染科室",width:100,align:'left',sortable:true},
			{ field:"IRInfDate",title:"感染日期",width:100,align:'left',sortable:true,sorter:Sort_int},
			{ field:"InfPos",title:"感染诊断",width:100,align:'left',sortable:true,showTip:true,tipWidth:200,tipTrackMouse:true,
				formatter: function (value,row,index) {
					var rs = row["ReportStatusCode"];
					var InfPos = row["InfPos"];
					var DiasID = row["DiasID"];
					var InfPosArray = InfPos.split(",");
					var DiasIDArray = DiasID.split(",");
					var InfPosHtml = "";
					for (var i=0; i<InfPosArray.length; i++) {
						if ((rs == 4)||(rs ==5)||(rs == 6)) {
							InfPosHtml += InfPosArray[i];
							if (i !== InfPosArray.length-1) InfPosHtml += '<br>';
						} else {
							InfPosHtml += '<a href="#" onclick=obj.OpenInfPosDialog(\''+row.EpisodeID+'\',\''+DiasIDArray[i]+'\',\''+row.AdmitDate+'\',\''+row.DischDate+'\',\''+rs+'\')>'+InfPosArray[i]+'</a>';
							if (i !== InfPosArray.length-1) InfPosHtml += '<br>';
						}
					}
					return InfPosHtml;
				}
			},
			//添加病原学检验、手术、抗菌用药信息
			{ field:"INFLabDesc",title:"病原学检验",width:100,align:'left',sortable:true,showTip:true,tipWidth:200,tipTrackMouse:true},
			{ field:"INFOPSDesc",title:"手术信息",width:100,align:'left',sortable:true,showTip:true,tipWidth:200,tipTrackMouse:true},
			{ field:"INFAntiDesc",title:"抗菌用药",width:100,align:'left',sortable:true,showTip:true,tipWidth:200,tipTrackMouse:true},
			
			{ field:"link1",title:"摘要",align:'left',width:70,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnAbstractMsg_Click(\''+row.EpisodeID+'\')>'+$g("摘要")+'</a>';
				}
			},
			{ field:"link",title:"电子病历",width:100,align:'left',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnEmrRecord_Click(\''+row.EpisodeID+'\')>'+$g("电子病历")+'</a>';
				}
			},
			{ field:"expander",title:"沟通记录",width:100,align:'left',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnMsgSend_Click(\''+row.PatName+'\',\''+row.EpisodeID+'\')>'+$g("沟通记录")+'</a>';
				}
			},
			{ field:"ReportUserDesc",title:"报告人",width:150,align:'left',sortable:true},
			{ field:"CheckUser",title:"审核人",width:100,align:'left',sortable:true},
			{ field:"CheckDate",title:"审核日期",width:100,align:'left',sortable:true,sorter:Sort_int},
			{ field:"ReturnReason",title:"退回原因",width:100,align:'left',sortable:true,showTip:true,tipWidth:100,tipTrackMouse:true}
        ]],
		onDblClickRow:function(rowIndex,rowData){
			$("#gridReport").datagrid('clearSelections');  //取消历史选中
			if(rowIndex>-1){
				obj.ShowResutlDtl(rowData.ReportID,rowData.RepType)	
			}	
        },
        	onSelect:function(rowIndex,rowData){
			obj.rowIndex=rowIndex;
        },
        onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	InitCtlResultWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
