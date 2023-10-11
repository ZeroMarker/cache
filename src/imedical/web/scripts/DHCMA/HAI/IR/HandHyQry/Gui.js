//页面Gui
var objScreen = new Object();
function InitHandHyQryWin() {
	var obj = objScreen;

	//设置开始日期和结束日期为本月第一天
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date)
	Common_SetValue('DateFrom',DateFrom);
	Common_SetValue('DateTo',Common_GetDate(new Date())); 
    //医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			Common_ComboToLoc('cboLoc',rec.ID,"","","");
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	Common_ComboDicID("cboMethod","HandHyObsMethod");
	
	
    $('#girdHandHyQry').datagrid({
        fit:true,
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
		sortOrder:'asc',
		remoteSort:false,
	    columns:[[
			{ field:"LocDesc",title:"调查科室/病区",width:240,align:'left',sortable:true},		
			{ field:"ObsMethodDesc",title:"调查方式",width:120,align:'left',sortable:true},
			{ field:"ObsDate",title:"调查日期",width:150,align:'left',sortable:true,sorter:Sort_int},
			{ field:"ObsPageDesc",title:"调查页数",width:100,align:'left',sortable:true},
			{ field:"ObsUser",title:"调查人",width:150,align:'left',sortable:true},
			{ field:"link",title:"操作",width:150,align:'left',sortable:true,
				formatter:function(value,row,index){
					return '<a href="#" onclick="objScreen.ShowHandHyReg(\'' +row.RegID + '\',\'' +row.LocID + '\',\'' +row.ObsDate + '\',\'' +row.ObsPageID + '\',\'' +row.ObsMethodID + '\',\'' +row.ObsUser + '\')">查看</a>';
				}
			}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });
    InitHandHyQryWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}