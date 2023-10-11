//页面Gui
var obj = new Object();
function InitDischDiagWin(){
	var IsCheckFlag=false;
	//医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			obj.cboLocation = Common_ComboToLoc("cboLocation",rec.ID,"","I","E");
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	$('#cboLocation').combobox({}); //联动表格需先初始化
	//设置开始日期为当月1号
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	var DateTo=Common_GetDate(new Date());
	Common_SetValue('DateFrom',DateFrom);
    Common_SetValue('DateTo',DateTo);
	//默认日期类型
    $HUI.combobox("#cboStatus",{
		data:[
			{value:'1',text:'确诊'},
			{value:'2',text:'疑似'},
			{value:'3',text:'排除'}
		],
		valueField:'value',
		textField:'text'
	})
	//表格
	obj.gridDischDiag = $('#gridDischDiag').datagrid({
        fit:true,
        title:'',
        headerCls:'panel-header-gray',
        iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        singleSelect:true,
        nowrap:false,
        loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		sortOrder:'asc',
		remoteSort:false,
        url:$URL,
        queryParams:{
	        ClassName:'DHCHAI.IRS.INFDiagnosSrv',
	        QueryName:'QryDischInfDiag',
	        aHospIDs:$("#cboHospital").combobox('getValue'),
	        aDateFrom:$("#DateFrom").datebox('getValue'),
	        aDateTo:$("#DateTo").datebox('getValue'),
	        aAdmLoc:$("#cboLocation").combobox('getValue'),
	        aStatus:$("#cboStatus").combobox('getValue'),
	        aMrNo:$("#txtMrNO").val()
	    },
        columns:[[
        	//{field:'checked',checkbox:'true',align:'left',width:'30',auto:false},
	        { field:"MrNo",title:"病案号",width:100,align:'left',sortable:true},
			{ field:"PatName",title:"姓名",width:100,align:'left',sortable:true},
			{ field:"Sex",title:"性别",width:50,align:'left',sortable:true},
			{ field:"Age",title:"年龄",width:70,align:'left',sortable:true},
			{ field:"AdmLocDesc",title:"科室",width:150,align:'left',sortable:true},
			{ field:"ActStatus",title:"状态",width:70,align:'left',sortable:true},
            { field:"link",title:"操作",width:150,align:'left',sortable:true,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.qz(\''+row.EpisodeDr+'\',\''+index+'\')>确诊</a>&nbsp;&nbsp;<a href="#" onclick=obj.ys(\''+row.EpisodeDr+'\',\''+index+'\')>疑似</a>&nbsp;&nbsp;<a href="#" onclick=obj.pc(\''+row.EpisodeDr+'\',\''+index+'\')>排除</a>';
				}
			},
			/// InDiagList,MainDiagList,FirstDiagList,OPDiagList
			{ field:"InDiagList",title:"入院诊断",width:100,align:'left',sortable:true},
			{ field:"InfDiagList",title:"出院感染诊断",width:150,align:'left',sortable:true},
            { field:"link1",title:"摘要",width:70,align:'left',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnAbstractMsg_Click(\''+row.EpisodeDr+'\')>摘要</a>';
				}
			},
            { field:"link2",title:"电子病历",width:100,align:'left',sortable:true,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnEmrRecord_Click(\''+row.EpisodeDr+'\')>电子病历</a>';
				}
			},
            { field:"link3",title:"病例跟踪",width:100,align:'left',
                formatter:function(value,row,index){
                     return '<a href="#" onclick=obj.btnAddQuest_Click(\''+row.EpisodeDr+'\')>病例跟踪</a>';
                }
            },
			{ field:"InfPosDesc",title:"院感报告诊断",align:'left',sortable:true,width:100,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnReprot_Click(\''+row.EpisodeDr+'\')>新建</a>';
				}
			},
			{ field:"DischDate",title:"出院日期",width:100,align:'left',sortable:true,sorter:Sort_int},
			
			{ field:"FirstDiagList",title:"初步诊断",width:100,align:'left',sortable:true},
			{ field:"MainDiagList",title:"主要诊断",width:100,align:'left',sortable:true},
			{ field:"OPDiagList",title:"门诊诊断",width:100,align:'left',sortable:true}
        ]],
		onSelect:function(rowIndex,rowData){
			if(!IsCheckFlag){
				IsCheckFlag = true;
				rowIndexTo=rowIndex;
			}else if(rowIndexTo==rowIndex){
				IsCheckFlag = false;
				$('#gridDischDiag').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
			}
		}
	});
	
	InitDischDiagWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitDischDiagWin();
});
