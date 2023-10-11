$(function () {
	InitScreeningWin();
});
//页面Gui
var objScreen = new Object();
function InitScreeningWin(){
	var obj = objScreen;
	Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	
	// 日期初始赋值
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	obj.DateFrom = $('#DateFrom').datebox('setValue', DateFrom);    
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));
	
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
        	{ field:"PapmiNo",title:"登记号",width:100,align:'left',sortable:true},
			{ field:"PatName",title:"姓名",width:100,align:'left',sortable:true},
			{ field:"Sex",title:"性别",width:50,align:'left',sortable:true},
			{ field:"Age",title:"年龄",width:70,align:'left',sortable:true},
			{ field:"ZY",title:"摘要",align:'left',width:70,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=objScreen.btnAbstractMsg_Click(\''+row.EpisodeID+'\')>摘要</a>';
				}
			},
			{ field:"link",title:"电子病历",width:100,align:'left',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=objScreen.btnEmrRecord_Click(\''+row.EpisodeID+'\')>电子病历</a>';
				}
			},
			{ field:"link1",title:"疑似处置",width:100,align:'left',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=objScreen.PatScreenShow(\''+row.EpisodeID+'\')>疑似处置</a>';
				}
			},
			{ field:"AdmDate",title:"入院日期",width:100,align:'left',sortable:true,sorter:Sort_int},
			{ field:"DischDate",title:"出院日期",width:100,align:'left',sortable:true,sorter:Sort_int},
			{ field:"AdmLocDesc",title:"科室",width:140,align:'left',sortable:true},
			{ field:"AdmWardDesc",title:"病区",width:140,align:'left',sortable:true},
			{ field:"ItmScreenDesc",title:"感染指标",width:150,align:'left',sortable:true},
			{ field:"CSItmScreenTxt",title:"结果",width:150,align:'left',sortable:true},
			{ field:"BTDiagnos",title:"疑似诊断",width:120,align:'left',sortable:true},
			{ field:"ScreenStatus",title:"处置状态",width:100,align:'left',sortable:true},
			{ field:"CSRstFromDate",title:"触发日期",width:110,align:'left',sortable:true},
			{ field:"CSActDate",title:"处置日期",width:110,align:'left',sortable:true},
			{ field:"ActUserDesc",title:"处置人",width:100,align:'left',sortable:true}
        ]],
        	onSelect:function(rowIndex,rowData){
			obj.rowIndex=rowIndex;
        }
	});
	
	InitScreeningWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


