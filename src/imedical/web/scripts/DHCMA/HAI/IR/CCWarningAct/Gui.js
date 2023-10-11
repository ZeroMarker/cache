var obj = new Object();   
function InitActScreen(){
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	var DateTo=Common_GetDate(new Date());
	Common_SetValue('DateFrom',DateFrom);
    Common_SetValue('DateTo',DateTo);
	//状态
	obj.Status=Common_RadioToDic('status','CCWStatus',2);
	
	//医院
    $HUI.combobox("#cboHospitalRep",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			Common_ComboToLoc('cboLocation',rec.ID,"","I","W");
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospitalRep').combobox('select',data[0].ID);
		}
	});
	//表格
	obj.gridReport = $('#gridReport').datagrid({
        fit:true,
        title:'',
        headerCls:'panel-header-gray',
        iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        singleSelect:true,
        loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		nowrap:true,
		fitColumns: true,
        url:$URL,
        queryParams:{
	       ClassName:'DHCHAI.IRS.CCWarningRepSrv',
	       QueryName:'QryFindRepByLoc',
	       aHospIDs:$("#cboHospitalRep").combobox('getValue'),
	       aLocID:$("#cboLocation").combobox('getValue'),
	       aStatus:'',
	       aDateFrom:$("#DateFrom").datebox('getValue'),
	       aDateTo:$("#DateTo").datebox('getValue')
	    },
        columns:[[
			{ field:"LocDesc",title:"病区",width:150,align:'left',
			formatter:function(value,row,index){
				// if(row.WarnItem=="主动报告"){
				// 	return row.LocDesc;
				// }else
				{
					return '<a href="#" onclick=obj.ShowWardInfo(\''+row.LocID+'\',\''+row.LocDesc+'\')>'+row.LocDesc+'</a>';
				}
			}
		},
	        { field:"WarnItem",title:"预警项目",width:150,align:'left',
	        	formatter:function(value,row,index){
					if(row.WarnItem=="主动报告"){
						return row.WarnItem;
					}else{
						return '<a href="#" onclick=obj.ShowPatInfo(\''+row.LocID+'\',\''+row.WarnDate+'\',\''+row.CCWarnItem+'\',\''+row.WarnItem+'\')>'+row.WarnItem+'</a>';
					}
				}
	        },
	        { field:"WarnDate",title:"预警日期",width:100,align:'left'},
	        { field:"ActStatus",title:"处置状态",width:80,align:'left'},
	        { field:"link",title:"操作",width:80,align:'left',
				formatter:function(value,row,index){				
					if(row.WarnItem=="主动报告"){
						return '<a href="#" onclick=obj.Delete(\''+row.xID+'\')>删除</a>';
					}else if(row.ActStatus=="暴发"){
						return '<a href="#" onclick=obj.NOutbreak(\''+row.LocID+'\',\''+row.WarnDate+'\',\''+row.WarnItem+'\',\''+row.CCWarnItem+'\')>非暴发</a>&nbsp;&nbsp;<a href="#" onclick=obj.Delete(\''+row.xID+'\')>删除</a>';	
					}else if(row.ActStatus=="非暴发"){
						return '<a href="#" onclick=obj.Outbreak(\''+row.LocID+'\',\''+row.WarnDate+'\',\''+row.WarnItem+'\',\''+row.CCWarnItem+'\')>暴发</a>&nbsp;&nbsp;<a href="#" onclick=obj.Delete(\''+row.xID+'\')>删除</a>';	
					}
					
				}
			},
	        { field:"ActUser",title:"处置人",width:100,align:'left'},
	        { field:"ActDate",title:"处置时间",width:100,align:'left'},
	        { field:"Opinion",title:"处置说明",width:300,align:'left',showTip:true},
	        { field:"RepID",title:"报告ID",width:100,align:'left',
	        	formatter:function(value,row,index){
					if(value){
						return '<span class="repoblong" onclick=obj.OpenReport_Click(\''+value+'\',\''+row.LocID+'\')>'+value+'</span>'
					}else{
						return ""
					}
				}
	        }		
        ]],
		onDblClickRow:function(rowIndex,rowData){
			$("#gridReport").datagrid('clearSelections');  //取消历史选中
        }
	});
	
	InitActScreenEvent(obj);       
	obj.LoadEvent();       
	return obj;        
}
$(function () {
	InitActScreen();
});