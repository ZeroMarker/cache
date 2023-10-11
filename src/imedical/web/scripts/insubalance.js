
/**
 * 医保对账查询JS
 * FileName:insubalance.js
 * Huang SF 2018-03-12
 * 版本：V1.0
 * hisui版本:0.1.0
 */
 
 var tabIdArr=[];
 var tabTitleArr=[];
 var iconClsArr=[];
 var PIDStr="";
 var HospDr=session['LOGON.HOSPID']; 
$(function(){
	initData();
	initPanel();
});

//初始化并加载当前时间
function initData(){
	
	var Now=new Date();
	$('#stdate').datebox('setValue',Now.getFullYear()+"-"+(Now.getMonth()+1)+"-"+Now.getDate());
	$('#endate').datebox('setValue',Now.getFullYear()+"-"+(Now.getMonth()+1)+"-"+Now.getDate());
	var stdate=$('#stdate').datebox('getValue');
	var endate=$('#endate').datebox('getValue');
}


//初始化面板
function initPanel(){
	//医保结算数据面板
	$HUI.datagrid("#InsuError",{
		fit: true,
		border:false,
		toolbar:[],
		striped: true, //是否显示斑马线效果
		singleSelect: true,
		selectOnCheck: false,
		fitColumns: true,
		autoRowHeight: false,
		showFooter: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		pageSize: 10,
		pageList: [10,20,30,40],
		columns:[[
			{field:'PAPMINO',title:'登记号'},
			{field:'PAPMIName',title:'姓名'},
			{field:'INSUiDate',title:'医保业务日期'},
			{field:'HISFlag',title:'HIS结算状态'},
			{field:'INSUFlag',title:'医保结算状态'},
			{field:'DHCINVPRTDr',title:'INVPRTDr'},
			{field:'INSUDivDr',title:'医保结算表Dr'},
			{field:'PrtInsDivDr',title:'发票医保结算表Dr'},
			{field:'INSUUser',title:'医保操作员'},
			{field:'INSUAdmType',title:'医疗类别'},
			{field:'InsuId',title:'医保号'},
			{field:'FairType',title:'业务类型'},
			{field:'INSUAmount',title:'总金额'},
			//{field:'HISiDate',title:'HIS业务日期'},
			//{field:'HISUser',title:'HIS操作员'},
			{field:'AdmDr',title:'就诊表Dr'},
			
		]],
		data:[]
	});
	
	//默认加载His结算数据一个普通门诊标签
	initTabDatagrid("INVDiv");
}


//查找事件
function Inquriy(){
	var stdate=$('#stdate').datebox('getValue');
	var endate=$('#endate').datebox('getValue');
	PIDStr=tkMakeServerCall("web.DHCINSUBalance","GetBalanceALLHISOPErrorByDate",stdate,endate,HospDr);
	$HUI.datagrid("#InsuError",{url:$URL+"?ClassName=web.DHCINSUBalance&QueryName=QryBalanceINSUErrorByDate&STDate="+stdate+"&EndDate="+endate+"&HospDr="+HospDr});
	
	//加载tab标签
	var tabIdStr=tkMakeServerCall("web.DHCINSUBalance","GetBalanceALLHISOPErrorTabStr",PIDStr)
	if((""!=tabIdStr)&(undefined!=tabIdStr)){tabIdArr=tabIdStr.split("|")};
	var titleTemp="",iconClsTemp="";
	for(var i=0;i<tabIdArr.length;i++){
		switch(tabIdArr[i]){
			case "INVReg":
				titleTemp="挂号";
				iconClsTemp="icon-apply-adm";
				break;
			case "INVDiv":
				titleTemp="普通门诊";
				iconClsTemp="icon-add-note";
				break;
			case "INVPE":
				titleTemp="体检";
				iconClsTemp="icon-add-note";
				break;
			case "AccPay":
				titleTemp="集中打印";
				iconClsTemp="icon-copy-drug";
				break;
			case "Mobile":
				titleTemp="移动支付";
				iconClsTemp="icon-cancel-order";
				break;
			default:
	    		break;
		}
		tabTitleArr[i]=titleTemp;
		iconClsArr[i]=iconClsTemp;
	}
	
	//动态加载tab
	for(var i=0;i<tabIdArr.length;i++){
		var tabObj=$HUI.tabs("#HisTabs");
		if(!tabObj.exists(tabTitleArr[i])){
			var content="<div class='hisui-layout' fit='true'><table id='"+tabIdArr[i]+"' class='hisui-datagrid'></table></div>"
			tabObj.add({
    			title:tabTitleArr[i],
    			iconCls:iconClsArr[i],
    			closable:false,
    			content:content
			});	
			initTabDatagrid(tabIdArr[i]);
		}
		$HUI.datagrid("#"+tabIdArr[i],{
			url:$URL+"?ClassName=web.DHCINSUBalance&QueryName=QryBalanceHISErrorByDate&Type="+tabIdArr[i]+"&PID="+PIDStr
		});
	}	
	
	//默认选中第一个标签
	$HUI.tabs("#HisTabs").select("普通门诊");
}

//初始化标签里的datagrid
function initTabDatagrid(id){
	$HUI.datagrid("#"+id,{
		fit:true,
		border:false,
		toolbar:[],
		striped: true, //是否显示斑马线效果
		singleSelect: true,
		selectOnCheck: false,
		fitColumns: true,
		autoRowHeight: false,
		showFooter: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		pageSize: 10,
		pageList: [10,20,30,40],
		columns:[[//PAPMINO,PAPMIName,AdmDr,HISiDate,HISFlag,DHCINVPRTDr,PRTInsDivDR,HISUser,BLLDateRowid,INSUFlag,INSUiDate,INSUUser,INSUAdmType,PID
			{field:'PAPMINO',title:'登记号',height:50},
			{field:'PAPMIName',title:'姓名',height:50},
			{field:'HISiDate',title:'HIS业务日期'},
			{field:'HISFlag',title:'HIS结算状态'},
			{field:'INSUFlag',title:'医保结算状态'},
			{field:'BLLDataRowid',title:'数据来源表Dr'},
			{field:'PRTInsDivDR',title:'医保结算表Dr'},
			{field:'HISUser',title:'HIS操作员'},
			{field:'INSUiDate',title:'医保业务日期'},
			{field:'INSUUser',title:'医保操作员'},
			{field:'INSUAdmType',title:'医疗类别'},
			{field:'HISAmount',title:'总金额'},
			{field:'AdmDr',title:'就诊表Dr',height:50},
			//{field:'DHCINVPRTDr',title:'INVPRTDr'},
			{field:'PID',title:'PID',hidden:true}
		]],
	   data:[]
	});
}