/**
* FillName: insubalancedayn.js
* Description: 医保日对账
* Creator WenYX
* Modify  DingSH
* Date: 2019-12-24
*/

var HospitalId=session['LOGON.HOSPID'];
var Guser=session['LOGON.USERID'];
var InsuType=""
var ballistdg;
var centerErrdg;
var hisErrdg;
$(function(){
	initDocument();
});

function initDocument(){
	
	//初始化日期
	initDate();
	
	//医保类型
	initInsuTypeCmb();
	
	//结算类别
	initAdmTypeCmb();
	
	//日对账结果记录
	initBallistDg();
	
	//医保中心异常记录
	initCentererrDg();
	
	//医院异常记录
	initHiserrDg()
	
	
	$('#btnDivBalDayQuery').off().on("click", DivBalDayQuery_click);
	$('#btnDivCenterDL').off().on("click", DivCenterDL_click);
	$('#btnDivBalDaySubmit').off().on("click",DivBalDaySubmit_click);
}


//初始化医保类型
function initInsuTypeCmb()
{
	$HUI.combobox('#insutype',{
		url:$URL,
		editable:false,
		valueField:'cCode',
    	textField:'cDesc',
    	panelHeight:100,
    	method:'GET',
    	onBeforeLoad:function(param)
    	{
	    	param.ClassName='web.INSUDicDataCom';
	    	param.QueryName='QueryDic';
	    	param.ResultSetType='array';
	    	param.Type='DLLType';
	    	param.Code='';
	    },
	    loadFilter:function(data){
		    for(var i in data)
		    {
			    if(data[i].cDesc=="全部")
			       {
				     data.splice(i,1)  
				    }
			    }
			    return data;
		   },
		   onSelect:function(rec)
		   {
			   InsuType=rec.cCode;
			   initCenterNoCmb();
			   
		}
	});
	
}
//初始化结算类型
function initAdmTypeCmb(){
 $HUI.combobox('#admtype',{   
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '1',
			Desc: '门诊'
		},{
			Code: '2',
			Desc: '住院'
		}],
		value: '1'
	}); 

}

//初始化医保中分中心
function initCenterNoCmb()
{
	
	$HUI.combobox('#centerno',{
		url:$URL,
		editable:false,
		valueField:'cCode',
		textField:'cDesc',
		method:'GET',
		onBeforeLoad:function(param){
			param.ClassName='web.INSUDicDataCom';
			param.QueryName='QueryDic';
			param.ResultSetType='array';
			param.Type=('YAB003'+InsuType);
			param.Code=''
			
			},
		loadFilter:function(data){
			for(var i in data){
				if(data[i].cDesc=='全部'){
					data.splice(i,1)
					}
				}
			
			return data
			},
		})
}

//初始化日对账结果dg
function initBallistDg()
{
	
	 ballistdg=$HUI.datagrid('#ballist',{
		iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		singleSelect: true,
		pageSize:10,
		pageList:[10, 20, 30],
		data:[],
		//toolbar:'#dgTB',
		pagination:true,
		fitColumns:false,
		columns:[[
			{field:'INBALSRowid',title:'Rowid',width:60,hidden:true},
			{field:'INSUType',title:'医保类型',width:80},
			{field:'INSUCenter',title:'社保经办机构',width:150},
			{field:'INSUYllb',title:'医疗类别',width:80},
			{field:'INSURylb',title:'人员类别',width:80},
			{field:'HisTotAmt',title:'HIS总金额',width:100},
			{field:'HisTotCnt',title:'HIS总人次',width:100},
			{field:'Hisjjzfe',title:'HIS基金支付',width:100},
			{field:'Hiszhzfe',title:'HIS账户支付',width:100},
			{field:'Hisgrzfe',title:'HIS个人自付',width:100},
			{field:'INSUTotAmt',title:'医保总金额',width:100},
			{field:'INSUTotCnt',title:'医保总人次',width:100},
			{field:'INSUjjzfe',title:'医保基金支付',width:100},
			{field:'INSUzhzfe',title:'医保账户支付',width:100},
			{field:'INSUgrzfe',title:'医保个人自付',width:100},
			{field:'dzlsh',title:'对账流水号',width:120},
			{field:'jylsh',title:'交易流水号',width:120},
			{field:'Flag',title:'对账状态',width:80},
			{field:'Info',title:'对账失败原因',width:120},
			{field:'StDate',title:'开始日期',width:80},
			{field:'EndDate',title:'结束日期',width:80},
			{field:'iDate',title:'对账日期',width:80},
			{field:'iTime',title:'对账时间',width:80},
			{field:'sfrm0',title:'对账操作员',width:80},
			{field:'dzqh',title:'对账周期',width:100}
		]],
        onSelect:function(rowIndex, rowData) {
			//ConGridQuery(rowIndex, rowData);
            //if($('#cked')[0].checked){ConAct("insertRow")}
            QryCenterErrDg(rowData.INBALSRowid)
            QryHisErrDg(rowData.INBALSRowid)
        },
        onUnselect:function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
	    onLoadSuccess:function(data){
			//$(this).datagrid('options').queryParams.qid="0";
		},
		onDblClickRow:function(rowIndex,rowData){
			
			
		}
	});
	
	
}
//查询日对账结果
function QryBallistDg()
{
    var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var InsuType=$('#insutype').combobox('getValue');
	
	if(StDate==""){
		$.messager.alert('注意','对账日期不能为空！');
		return;
	}
	if(InsuType==""){
		$.messager.alert('注意','医保类型不能为空！');
		return;
	}

	
	$HUI.datagrid('#ballist',{
		url:$URL+"?ClassName="+'web.DHCINSUBalanceDayCtl'+"&QueryName="+'BalanceDayInfo'+"&StDate="+StDate+"&EnDate="+EndDate+"&AdmType="+''+"&InsuType="+InsuType+"&HospId="+HospitalId,

		})
		
	
}



//初始化医保异常数据dg
function initCentererrDg()
{

	//中心数据列表
	 centerErrdg=$HUI.datagrid('#centererrdg',{
		iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		queryParams:{qid:1},
		singleSelect: true,
		pageSize:10,
		pageList:[10, 15, 20, 30],
		data:[],
		//toolbar:'#dgTB',
		pagination:true,
		fitColumns:false,
		columns:[[
			{field:'INBALSDNRowid',title:'Rowid',width:60,hidden:true},
			{field:'zylsh',title:'住院流水号',width:150},
			{field:'djlsh',title:'结算业务号',width:150},
			{field:'jylsh',title:'交易流水号',width:150},
			{field:'INSUNo',title:'个人编号',width:80},
			{field:'Name',title:'姓名',width:80},
			{field:'INSUTotAmt',title:'总金额',width:80},
			{field:'INSUjjzfe',title:'医保金额',width:80},
			{field:'INSUgrzfe',title:'自费金额',width:80},
			{field:'INSUDateTime',title:'收费日期',width:80},
			{field:'INSUsUserDr',title:'收费员',width:100},
			{field:'INSUYllb',title:'类别(挂号/收费)',width:100}
		]],
        onSelect:function(rowIndex, rowData) {
			//ConGridQuery(rowIndex, rowData);
            //if($('#cked')[0].checked){ConAct("insertRow")}
        },
        onUnselect:function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
	    onLoadSuccess:function(data){
			//$(this).datagrid('options').queryParams.qid="0";
		}
	});
	
	
}
//查询医保异常数据
function QryCenterErrDg(INBALSDr)
{
	
	
	var urlStr=$URL+"?ClassName=web.DHCINSUBalanceUnusualCtl&QueryName=BalanceUnusualInfo&BalanceDayDr="+INBALSDr+"&UnFlag=1";
	$HUI.datagrid('#centererrdg',{
		url:urlStr
	});
	
}



//初始化HIS异常数据
function initHiserrDg(){
	
	 hisErrdg=$HUI.datagrid('#hiserrdg',{
		iconCls:'icon-save',
		rownumbers:true,
		border: false,
		fit:true,
		striped:true,
		//url:$URL,
		queryParams:{qid:1},
		singleSelect: true,
		pageSize:10,
		pageList:[10, 15, 20, 30],
		data:[],
		//toolbar:'#dgTB',
		pagination:true,
		columns:[[
			{field:'DivideDr',title:'DivDr',width:60,hidden:true},
			{field:'zylsh',title:'住院流水号',width:150},
			{field:'djlsh',title:'结算业务号',width:150},
			{field:'jylsh',title:'交易流水号',width:150},
			{field:'INSUNo',title:'个人编号',width:80},
			{field:'Name',title:'姓名',width:80},
			{field:'HisTotAmt',title:'总金额',width:80},
			{field:'Hisjjzfe',title:'医保金额',width:80},
			{field:'Hisgrzfe0',title:'自费金额',width:80},
			{field:'DivDate',title:'收费日期',width:80},
			{field:'OptName',title:'收费员',width:100},
			{field:'INSUYllb',title:'类别(挂号/收费)',width:100}
		]],
        onSelect:function(rowIndex, rowData) {
			//ConGridQuery(rowIndex, rowData);
            //if($('#cked')[0].checked){ConAct("insertRow")}
        },
        onUnselect:function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
	    onLoadSuccess:function(data){
			//$(this).datagrid('options').queryParams.qid="0";
		}
	});
	}
	
	//查询HIS异常数据
	function QryHisErrDg(INBALSDr)
	{
		
	
	var urlStr=$URL+"?ClassName=web.DHCINSUBalanceUnusualCtl&QueryName=BalanceUnusualInfo&BalanceDayDr="+INBALSDr+"&UnFlag=0";
	$HUI.datagrid('#hiserrdg',{
		url:urlStr
	});
	
		
	}
	

function DivBalDayQuery_click(){
	//BalQuery();
	QryBallistDg();
}

function DivCenterDL_click(){
	//DivLoad();
}
function DivBalDaySubmit_click(){
	//DivSubmit();
}

function DivLoad(){
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var InsuType=$('#insutype').combobox('getValue');
	var rtn="-1";
	var ExpString;
	
	if(StDate==""){
		$.messager.alert('注意','对账日期不能为空！');
		return;
	}
	if(InsuType==""){
		$.messager.alert('注意','医保类型不能为空！');
		return;
	}
	
	ExpString=StDate+"^"+EndDate+"^^"+"10"+"^"+"";
	rtn=InsuDivLoad(0,Guser,HospitalId,InsuType,ExpString);
	if(rtn!=0){
		$.messager.alert('错误','提取医保中心结算数据失败！rtn='+rtn);
	}else{
		$.messager.alert('温馨提示','提取医保中心结算数据完成');
	}
	
	var urlStr=$URL+"?ClassName=web.DHCINSUCenterSubCtl&QueryName=CenterDivInfo&StDate="+StDate+"&EnDate="+EndDate+"&AdmType="+""+"&InsuType="+InsuType+"&HospId="+HospId;
	$HUI.datagrid('#centerdg',{
		url:urlStr
	});
}

function BalQuery(){
	
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var InsuType=$('#insutype').combobox('getValue');
	
	if(StDate==""){
		$.messager.alert('注意','对账日期不能为空！');
		return;
	}
	if(InsuType==""){
		$.messager.alert('注意','医保类型不能为空！');
		return;
	}
	var urlStr=$URL+"?ClassName=web.DHCINSUBalanceDayCtl&QueryName=BalanceDayInfo&StDate="+StDate+"&EnDate="+EndDate+"&AdmType="+""+"&InsuType="+InsuType+"&HospId="+HospitalId;
	$HUI.datagrid('#ballist',{
		url:urlStr
	});
}

function DivQuery(){
	$.messager.alert('温馨提示','查询his医保结算数据');
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var InsuType=$('#insutype').combobox('getValue');
	var AdmType=$('#AdmType').combobox('getValue');
	
	if(StDate==""){
		$.messager.alert('注意','对账日期不能为空！');
		return;
	}
	if(InsuType==""){
		$.messager.alert('注意','医保类型不能为空！');
		return;
	}
	var urlStr=$URL+"?ClassName=web.DHCINSUBalance&QueryName=InsuDivInfoQuery&StDate="+StDate+"&EnDate="+EndDate+"&AdmType="+AdmType+"&InsuType="+InsuType+"&HospId="+HospId;
	$HUI.datagrid('#hisdg',{
		url:urlStr
	});
}

function DivSubmit(){
	
	var rtn;
	var ExpString;
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var InsuType=$('#insutype').combobox('getValue');
	var AdmType=$('#AdmType').combobox('getValue');
	
	ExpString=StDate+"^"+EndDate+"^"+InsuType+"^"+"10"+"^^"+AdmType;
	rtn=BalSubmit(0,Guser,InsuType,ExpString);
	if(rtn<0){
		$.messager.alert('错误','对账失败！');
	}else{
		$.messager.alert('温馨提示','提交对账完成');
	}
	
	var urlStr=$URL+"?ClassName=web.DHCINSUBalanceDayCtl&QueryName=BalanceDayInfo&StDate="+StDate+"&EnDate="+EndDate+"&AdmType="+""+"&InsuType="+InsuType+"&HospId="+HospitalId;
	$HUI.datagrid('#ballist',{
		url:urlStr
	});
}

function initDate(){
	var date=new Date();
	var s=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
	$('#stdate').datebox({
		formatter: function(date){
			var year=date.getFullYear();
			var month=date.getMonth()+1;
			var day=date.getDate();
			return year+"-"+(month<10 ? ("0"+month) : month)+"-"+(day<10?("0"+day):day);
		},
		onSelect:function(date){
			var StDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
			$('#endate').datebox('setValue',StDate);
		},
		value: s
	});
	
	$('#endate').datebox({
		disabled: true,
		value: s,
		formatter: function(date){
			var year=date.getFullYear();
			var month=date.getMonth()+1;
			var day=date.getDate();
			return year+"-"+(month<10 ? ("0"+month) : month)+"-"+(day<10?("0"+day):day);
		}
	});
}

