
var cmenu;
var grid;
var selRowid="";
var searchParam = {}; 
var seldictype=""; 
var tmpselRow=-1;
$(function(){
	//GetjsonQueryUrl();
	
	//初始化datagrid
	init_dg();
	
	$('#QueryBalanceLog').on('click',function(){
		reloadListGV();
	});
	
	var Options = {
		defaultFlag:'Y',
		hospDr:session['LOGON.HOSPID']
	}
	INSULoadDicData('InsuType','DLLType',Options); 	
	
	$HUI.combobox(('#UserNo'),{
		defaultFilter:'4',
		valueField: 'TUsrRowid',
		textField: 'TUsrName',
		url:$URL,
		onSelect:function(){
		},
		onLoadSuccess:function(data){

		}
		,onBeforeLoad: function(param) {
			param.ClassName = 'DHCBILLConfig.DHCBILLOthConfig';
			param.QueryName= 'FindGroupUser';
			param.Grp = session['LOGON.GROUPID'];
			param.Usr = "";
			param.HospId = session['LOGON.HOSPID'];
			param.ResultSetType = 'array';
			return true;
		}		
	})
	
	$('.hisui-datebox').datebox('setValue', GetConDateByConfig());
})
function init_dg(){
	grid=$('#dg').datagrid({
		rownumbers:true,
		width: '100%',
		fit:true,
		//striped:true,
		fitColumns: false,
		singleSelect: true,
		columns:[[
			{field:'INBLLRowid',title:'INBLLRowid',width:100,hidden:'true'},
			{field:'INSUTypte',title:'医保类型',width:80},
			{field:'OptDate',title:'对账日期',width:100},
			{field:'UserDr',title:'操作员ID',width:80},
			{field:'Flag',title:'对账成功标志',width:100},
			{field:'StartDate',title:'对账开始日期',width:100},
			{field:'StartTime',title:'对账开始时间',width:100},
			{field:'EndDate',title:'对账结束日期',width:100},
			{field:'EndTime',title:'对账结束时间',width:100},
			{field:'TotAmt',title:'his对账总金额',width:120,align:'right'},
			{field:'JJZFE',title:'his基金支付金额',width:120,align:'right'},
			{field:'ZHZFE',title:'his账户支付金额',width:120,align:'right'},
			{field:'GRZFE',title:'his现金支付金额',width:150,align:'right'},
			{field:'TCZF',title:'his基本统筹支付金额',width:150,align:'right'},
			{field:'DBZF',title:'his大病支付金额',width:150,align:'right'},
			{field:'GWYZF',title:'his公务员支付金额',width:150,align:'right'},
			{field:'MZJZ',title:'his民政救助金额',width:150,align:'right'},
			{field:'INSUTotAmt',title:'医保返回对账总金额',width:190,align:'right'},
			{field:'INSUJJZFE',title:'医保返回基金支付金额',width:190,align:'right'},
			{field:'INSUZHZFE',title:'医保返回账户支付金额',width:190,align:'right'},
			{field:'INSUGRZFE',title:'医保返回现金支付金额',width:190,align:'right'},
			{field:'INSUTCZF',title:'医保返回基本统筹支付金额',width:190,align:'right'},
			{field:'INSUDBZF',title:'医保返回大病支付金额',width:190,align:'right'},
			{field:'INSUGWYZF',title:'医保返回公务员支付金额',width:170,align:'right'},
			{field:'INSUMZJZ',title:'医保返回民政救助金额',width:170,align:'right'},
			{field:'Note',title:'对账失败原因',width:100},
			{field:'Str1',title:'扩展字段1',width:100,hidden:'true'},
			{field:'Str2',title:'扩展字段2',width:100,hidden:'true'},
			{field:'Str3',title:'扩展字段3',width:100,hidden:'true'},
			{field:'Str4',title:'扩展字段4',width:100,hidden:'true'},
			{field:'Str5',title:'扩展字段5',width:100,hidden:'true'}
		]],
		pageSize: 10,
		pagination:true,
		rowStyler: function(index,row){
			if ('失败'==row.Flag){
				return 'color:red;';
			}
		},
	});	
		
}
function reloadListGV(){
	
	var StDate=getValueById('StDate');
	var EndDate=getValueById('EndDate');
	var InsuType=getValueById('InsuType');
	var UserNo=getValueById('UserNo') ;
	var HospId = session['LOGON.HOSPID'];
	var queryParams = {
	    ClassName : 'web.INSUBalanceLog',
	    QueryName : 'QueryBalanceLog',
	    StDate : StDate,
	    EndDate : EndDate,
	    InsuType : InsuType,
	    HospId : HospId,
	    UserNo:UserNo,
	}	
    loadDataGridStore('dg',queryParams);
}
//导出EXCEL
function Export(){
	try
	{
		var title="";
		var tmpurl=jsonQueryUrl+'web.INSUBalanceLog'+SplCode+"QueryBalanceLog"+SplCode+cspEscape($('#StDate').datebox('getValue'))+ArgSpl+cspEscape($('#EndDate').datebox('getValue'))+ArgSpl+$('#InsuType').combobox('getValue')+ArgSpl+cspEscape($('#UserNo').val())
		ExportTitle="医保类型^对账日期^操作员ID^对账成功标志^对账开始日期^开始时间^对账结束日期^结束时间^总金额^基金支付额^账户支付额^个人支付额^统筹支付额^大病支付额^公务员补助^民政救助^医保返回总金额^医保返回基金支付额^医保返回账户支付额^医保返回个人支付额^医保返回统筹支付额^医保返回大病支付额^医保返回公务员补助^医保返回民政救助^备注^扩展1^扩展2^扩展3^扩展4^扩展5"
		ExportPrompt(tmpurl)
		return;
	} catch(e) {
		$.messager.alert("警告",e.message);
		$.messager.progress('close');
	};
}

//类似MSN的提示信息
//title:提示框的标题
//msg:提示信息
//timeout:多久后消息,单位为毫秒
function MSNShow(title,msg,timeout){
	$.messager.show({
		title:title,
		msg:msg,
		timeout:timeout,
		showType:'slide'
	});
}

///获取配置的默认生效时间
///注意：如果为空默认当前时间
function GetConDateByConfig()
{
    var rtnDate=""
	//var rtnDate=GetDicStr("SYS","INSUCONACTDATE",6); // - 20200509 DingSH
	//if(rtnDate==""){ 
	rtnDate=getDefStDate(0);
	//}
	return rtnDate; 
 }
function GetDicStr(dicCode,CodeVal,index){
	return tkMakeServerCall("web.INSUDicDataCom","GetDicByCodeAndInd",dicCode,CodeVal,index,session['LOGON.HOSPID']);
}