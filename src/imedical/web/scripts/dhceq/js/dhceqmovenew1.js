
function log(val) {
	//console.log(val);
}
var GroupSelectID="" ;
var FIXEDNUM = 2;
var SessionObj = {
	guser : curUserID,
	group : session['LOGON.GROUPID'],
	ctLoc : curLocID,
	LANGID : session['LOGON.LANGID']
}
var QUERY_URL = {
	QUERY_GRID_URL : "./dhcbill.query.grid.easyui.csp",
	QUERY_COMBO_URL : "./dhcbill.query.combo.easyui.csp"
};
var GlobalObj = {
	objId : "",
	initGlobal : function(objId){
		this.objId = objId;
	},
	clearGlobal : function(){
		this.objId = "";
	},
	initGlobalByData : function(rowData) {
		this.objId  = rowData.objId;
	}
}
//界面入口
jQuery(document).ready(function(){
	setTimeout("initDocument();",50);
});

function initDocument() {
	var str=window.location.search.substr(1);
   	var list=str.split("&");
   	var tmp=list[0].split("=");
   	var tid=tmp[1];
  	var temp=list[1].split("=");
   	var eid=temp[1];
  	jQuery("#Rowid").val(tid);
  	jQuery("#Status").val(eid);
  	GlobalObj.clearGlobal();
	initPanel();
	FillDataInfo();
	diable();
	jQuery("#patDetBtn").off().on("click", function() {
		if(jQuery("#Rowid").val() == "") {
			return false;
		}
		//var lnk = 'dhceqmoveuser.csp?id='+jQuery("#Rowid").val();
		//window.open(lnk, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=350,left=0,top=0');
		openwindow('dhceqmoveuser.csp','id='+jQuery("#Rowid").val(),'800','400');  //Modified by HHM 2016-01-25 弹出窗口居中
	});
}
function initPanel() {
	initTopPanel();
}

//初始化查询头面板
function initTopPanel() {
	jQuery("#btnSave").linkbutton({
		 iconCls: 'icon-save'
	});
	/*jQuery("#btnDelete").linkbutton({
		iconCls: 'icon-cancel'
	});
	jQuery("#btnDelete").linkbutton('disable');*/
	jQuery('#btnCancelSub').linkbutton({
		inconCls:'icon-cancel'
	});
	jQuery('#btnCancelSub').on('click',CancelSubClick);
	jQuery("#btnSave").on("click", SaveClick);	
	jQuery("#btnCancel").on("click", CloseClick);
	jQuery("#No").attr("disabled", "disabled");
	jQuery("#InvalidReason").attr("disabled", "disabled");
	initObjID();
	//initObjIDData()
	initSourceID();
	initSourceType();
	initEventType();
	initDeptIDInfo("FromDeptID");
	initDeptIDInfo("ToDeptID");
	initDeptType("FromDeptType");
	initDeptType("ToDeptType");
	initLocationDR("FromLocationDR");
	initLocationDR("ToLocationDR");
	initUserDR("SendUserDR");
	initUserDR("AcceptUserDR");
	initUserDR("MoveUserDR");
	setDefVal();
}
function FillDataInfo() {
	var rowid = jQuery("#Rowid").val();
	if (rowid!= "") {
		cleardata();
		var info = tkMakeServerCall("web.DHCEQMove", "GetMoveInfo",rowid);
		var InfoStr = info.split("^");
		//messageShow("","","",InfoStr);
		var sort=39;
		jQuery("#No").val(InfoStr[0]);
		if(InfoStr[2]!="")
		{
			GlobalObj.initGlobal(InfoStr[2]);
			initObjIDData();
			jQuery("#ObjID").combogrid('setValue',InfoStr[2]);
			jQuery("#ObjID").combogrid('setText',InfoStr[sort+2]);
		}
		jQuery("#SourceType").combobox('setValue',InfoStr[3]);
		initSourceIDData();
		jQuery("#SourceID").combogrid('setValue',InfoStr[4]);
		jQuery("#SourceID").combogrid('setText',InfoStr[sort+4]);
		jQuery("#EventType").combobox('setValue',InfoStr[5]);
		jQuery("#FromDeptType").combobox('setValue',InfoStr[7]);
		initDeptIDData("FromDeptType","FromDeptID");
		jQuery("#FromDeptID").combobox('setValue',InfoStr[8]);
		//jQuery("#FromDeptID").combobox('setText',InfoStr[sort+7]);
		jQuery("#FromLocationDR").combobox('setValue',InfoStr[9]);
		jQuery("#StartDate").datebox('setValue',InfoStr[sort+9]);
		jQuery("#StartTime").val(InfoStr[sort+10]);
		jQuery("#ToLocationDR").combobox('setValue',InfoStr[12]);
		jQuery("#ToDeptType").combobox('setValue',InfoStr[13]);
		if(InfoStr[13]!="")
		{
			initDeptIDData("ToDeptType","ToDeptID");
			jQuery("#ToDeptID").combobox('setValue',InfoStr[14]);
		}
		//jQuery("#ToDeptID").combobox('setText',InfoStr[sort+11]);
		jQuery("#EndDate").datebox('setValue',InfoStr[sort+14]);
		jQuery("#EndTime").val(InfoStr[sort+15]);
		jQuery("#SendUserDR").combobox('setValue',InfoStr[17]);	
		jQuery("#AcceptUserDR").combobox('setValue',InfoStr[18]);
		jQuery("#Remark").val(InfoStr[28]);	
		jQuery("#sid").val(InfoStr[sort+18]);
		jQuery("#eid").val(InfoStr[sort+19]);
		if(InfoStr[29]>1)
		{
			diable()
			disCombobox("AcceptUserDR");
			disCombobox("ToLocationDR");
			disCombobox("ToDeptType");
			disCombobox("ToDeptID");
			disDatebox("EndDate");
			disElement("EndTime");
		}
		if(InfoStr[29]<2)
		{
			//jQuery("#btnSave").on("click", SaveClick);
		}
		else
		{
			jQuery("#btnSave").linkbutton('disable');
			//jQuery("#btnDelete").linkbutton('disable');		
		}
	}
}
function diable()
{
	disCombogrid("ObjID");
	disCombobox("SourceType");
	disCombogrid("SourceID");
	disCombobox("EventType");
	disCombobox("SourceType");
	disCombogrid("SourceID");
	disCombobox("EventType");
	disCombobox("FromDeptType");
	disCombobox("FromDeptID");
	disCombobox("FromLocationDR");
	disCombobox("SendUserDR");
	disElement("Remark");
	disDatebox("StartDate");
	disElement("StartTime");
	//disButton("btnSave");
	//jQuery("#btnSave").linkbutton('disable');	
}
function disElement(argName) {
	jQuery("#" + argName).attr("disabled", "disabled");
}
function disCombobox(argName) {
	jQuery("#" + argName).combobox("disable")
}
function disCombogrid(argName) {
	jQuery("#" + argName).combogrid("disable")
}
function disDatebox(argName) {
	jQuery("#" + argName).datebox("disable");
}
function cleardata(){

  	jQuery("#EventType").combobox('setValue',"");		
  	jQuery("#StartDate").datebox('setValue',"");		
  	jQuery("#EndDate").datebox('setValue',"");		
}
function initLocationDR(comboxid) {
	jQuery("#"+comboxid).combobox({
		url:'dhceq.jquery.operationtype.csp?&action=GetLocation',
	    valueField: 'id',    
	    textField: 'text'
	});
}
function initDeptIDInfo(comboxid) {
	jQuery("#"+comboxid).combobox({
	    valueField: 'id',    
	    textField: 'text'
	});
}
function initUserDR(comboxid) {
	jQuery("#"+comboxid).combobox({
		url:'dhceq.jquery.operationtype.csp?&action=GetUser',
	    valueField: 'id',    
	    textField: 'text'
	});
}
function initDeptID(comboxid) {
	if (comboxid=="FromDeptType")
	{
		initDeptIDData("FromDeptType","FromDeptID");
	}
	if (comboxid=="ToDeptType")
	{
		initDeptIDData("ToDeptType","ToDeptID");
	}
}
function initDeptIDData(comboid,comboxid)
{
	var id=jQuery("#"+comboid).combobox('getValue');
	jQuery("#"+comboxid).combobox({
	url:'dhceq.jquery.operationtype.csp?&action=GetDeptID&str='+id,
	valueField: 'id',    
	textField: 'text'
	});
}
function initSourceID() {
	jQuery("#SourceID").combogrid({
		fit:true,
		panelWidth:450,
		border:false,
		//checkOnSelect: false, 
		//selectOnCheck: false,
		striped: true,
		singleSelect : true,
		url: null,
		//fitColumns:false,
		autoRowHeight:false,
		cache: false,
		//editable: false,
		loadMsg:'数据加载中……', 
		rownumbers: true,  //如果为true，则显示一个行号列。
	    idField: 'rowid',    
	    textField: 'no',
	    columns:[[    
	        {field:'rowid',title:'rowid',width:60,hidden:true},  
	        {field:'no',title:'业务单号',width:120},    
	        {field:'locname',title:'申请科室',width:140},      
	        {field:'date',title:'制单时间',width:120}
	    ]],
	    onLoadSuccess:function(data) {
	    	
	    },
	    onLoadError:function() {
	    	jQuery.messager.alert("业务", "加载业务信息失败");
	    },
	    onSelect: function(rowIndex, rowData) {
		    GlobalObj.objId="";
		    jQuery("#ObjID").combogrid('clear');
		    jQuery("#FromDeptType").combobox('clear');
			jQuery("#FromDeptID").combobox('clear');
			jQuery("#FromLocationDR").combobox('clear');
			jQuery("#ToLocationDR").combobox('clear');
			jQuery("#ToDeptType").combobox('clear');
			jQuery("#ToDeptID").combobox('clear');
		    var tid=jQuery("#SourceType").combobox('getValue');
	    	var id=jQuery("#SourceID").combogrid('getValue');
	    	//var tmp=jQuery("#EventType").combogrid('getValue');
			filldata(tid,id);
	    }
	});

}
function filldata(isDel,id){
	var info = tkMakeServerCall("web.DHCEQMove", "GetEquipInfo",isDel,id);
	//messageShow("","","",info);
	var InfoStr = info.split("^");
	jQuery("#FromDeptType").combobox('setValue',1);
	initDeptIDData("FromDeptType","FromDeptID");
	jQuery("#FromDeptID").combobox('setValue',InfoStr[5]);
	jQuery("#FromLocationDR").combobox('setValue',InfoStr[6]);
	//var equipdr=jQuery("#ObjID").combogrid('getText');
	//messageShow("","","",equipdr);
	if(isDel==3)
	{
		jQuery("#ToDeptType").combobox('setValue',1);
		initDeptIDData("ToDeptType","ToDeptID");
		jQuery("#ToDeptID").combobox('setValue',InfoStr[7]);
		jQuery("#FromLocationDR").combobox('setValue',InfoStr[8]);	
	}
	if(InfoStr[0]!="")
	{
		GlobalObj.objId=InfoStr[0];
		initObjIDData();
		jQuery("#ObjID").combogrid('setValue',InfoStr[0]);
		jQuery("#ObjID").combogrid('setText',InfoStr[1]);
	}
}	
//Modified 2015-01-26 by HHM 添加EventType参数
function initSourceIDData() {
	var ctlocid=SessionObj.ctloc;
	var groupid=SessionObj.group;
	var id=jQuery("#SourceType").combobox('getValue');
	if(id==1)
	{
		var queryParams = new Object();
		var ClassName="web.DHCEQMove";
		var QueryName="GetMaintRequest"; 
		queryParams.ClassName = ClassName;
		queryParams.QueryName = QueryName;
		queryParams.Arg1 = "";
		queryParams.Arg2 = "";
		queryParams.Arg3 = "";
		queryParams.Arg4 ="";
		queryParams.ArgCnt = 4;
		loadComboGridStore("SourceID",queryParams);	
	}
	if(id==2)
	{
		var queryParams = new Object();
		var ClassName="web.DHCEQMove";
		var QueryName="GetRent"; 
		queryParams.ClassName = ClassName;
		queryParams.QueryName = QueryName;
		queryParams.Arg1 = "";
		queryParams.Arg2 = "";
		queryParams.Arg3 = "";
		queryParams.Arg4 ="";
		queryParams.ArgCnt = 4;
		loadComboGridStore("SourceID",queryParams);	
	}
	if(id==3)
	{
		var queryParams = new Object();
		var ClassName="web.DHCEQMove";
		var QueryName="GetStoreMove"; 
		queryParams.ClassName = ClassName;
		queryParams.QueryName = QueryName;
		queryParams.Arg1 = "";
		queryParams.Arg2 = "";
		queryParams.Arg3 = "";
		queryParams.Arg4 ="";
		queryParams.ArgCnt = 4;
		loadComboGridStore("SourceID",queryParams);		
	}	
}
function initObjID() {
	jQuery("#ObjID").combogrid({
		fit:true,
		panelWidth:450,
		border:false,
		checkOnSelect: false, 
		selectOnCheck: false,
		striped: true,
		singleSelect : true,
		url:'dhcbill.query.grid.easyui.csp',
		fitColumns:false,
		autoRowHeight:false,
		cache: false,
		//editable: false,
		loadMsg:'数据加载中……', 
		rownumbers: true,  //如果为true，则显示一个行号列。
	    idField: 'rowid',    
	    textField: 'name',
	    columns:[[    
	        {field:'rowid',title:'rowid',width:60,hidden:true},    
	        {field:'name',title:'设备名称',width:140},    
	        {field:'no',title:'设备编号',width:120},    
	        {field:'model',title:'型号',width:120}
	    ]],
	    onSelect: function(rowIndex, rowData) {
	    	GlobalObj.clearGlobal();
	    }
	});

}	
function initObjIDData() {
	var queryParams = new Object();
	var ClassName="web.DHCEQMove";
	var QueryName="GetEquip"; 
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 = GlobalObj.objId;
	queryParams.Arg2 = "";
	queryParams.Arg3 = "";
	queryParams.ArgCnt = 3;
	loadComboGridStore("ObjID",queryParams);
}	  	
function SaveClick(){
    if(jQuery("#ToDeptType").combobox('getValue')==""){
           jQuery.messager.alert("提示", "目的单位类型不能为空！")
           return false;
    }
    
    if(jQuery("#ToDeptID").combogrid('getValue')==""){
           jQuery.messager.alert("提示", "目的单位不能为空！")
           return false;
    }
    /*if(jQuery("#ToLocationDR").combobox('getValue')==""){
           jQuery.messager.alert("提示", "目的位置不能为空！")
           return false;
    }*/
    if(jQuery("#EndDate").datebox('getValue')==""){
           jQuery.messager.alert("提示", "开始日期不能为空！")
           return false;
    }
     if(jQuery("#AcceptUserDR").combogrid('getValue')==""){
           jQuery.messager.alert("提示", "接受负责人不能为空！")
           return false;
    }
	if(CheckTime("StartTime")==false)
	{
		jQuery.messager.alert("提示", "开始时间格式有误");
				return false;
	}
	if(CheckTime("EndTime")==false)
	{
		jQuery.messager.alert("提示", "结束时间格式有误");
				return false;
	}
	if(jQuery("#EndDate").datebox('getValue')!="")
    {
	    if(jQuery("#EndTime").val()=="")
	    {
		   jQuery.messager.alert("提示", "结束时间不能为空");
				return false;  
		}
	    /*if(changeDateformat(jQuery("#StartDate").datebox('getValue'))>changeDateformat(jQuery("#EndDate").datebox('getValue')))
    	{
	   		jQuery.messager.alert("提示", "结束日期必须大于开始日期");
				return false; 
		}*/
	    var StartDate=changeDateformat(jQuery("#StartDate").datebox('getValue'));
	    var EndDate=changeDateformat(jQuery("#EndDate").datebox('getValue'));
	    if(Date.parse(StartDate)>Date.parse(EndDate))
    	{
	   		jQuery.messager.alert("提示", "结束日期不能小于开始日期！");
				return false; 
		}
		else if(changeDateformat(jQuery("#StartDate").datebox('getValue'))==changeDateformat(jQuery("#EndDate").datebox('getValue')))
		{
			var starttime=jQuery("#StartDate").datebox('getValue')+" "+jQuery("#StartTime").val();
			var endtime=jQuery("#EndDate").datebox('getValue')+" "+jQuery("#EndTime").val();
			var stdt=new Date(starttime.replace("-","/"));
			var etdt=new Date(endtime.replace("-","/"));
			//modified by HHM 2016-01-18  时间比较
			stdt=stdt.getTime();
			etdt=etdt.getTime();
			//***********************
			if(stdt>etdt)
			{
				jQuery.messager.alert("提示", "开始时间必须小于结束时间");
				return false; 
			}
		}
	}
	var combindata=CombinData();
	var frowid=jQuery("#sid").val();
	var erowid=jQuery("#eid").val();
	var user=SessionObj.guser;
	//messageShow("","","",combindata)
	var result = tkMakeServerCall("web.DHCEQMove", "SaveMoveInfo",combindata,user,frowid,erowid);
	if(result>0) {
				jQuery.messager.alert("提示", "保存成功");
				//CloseClick();    //Modified by HHM 2016-01-25 更新后不关闭当前窗口
				//window.location.href='dhceqmovefind.csp';
				return false;
			}
	else if (result=="-3003") {
			jQuery.messager.alert("提示", "单据有重复");
				return false;
		}		
	else{
		jQuery.messager.alert("提示", "保存失败");
				return false;
	}
}
function changeDateformat(Date)
{
	var date=Date.split("-")
	var temp=date[0]+"/"+date[1]+"/"+date[2];   //日期格式变换
	return temp;
}
function CancelSubClick(){
	var rowid=jQuery("#Rowid").val();
	var result=tkMakeServerCall("web.DHCEQMove", "CancelSub",rowid);
	messageShow("","","",result)
}
/*function DeleteClick(){
	var rowid=jQuery("#Rowid").val();
	var user=SessionObj.guser;
	var frowid=jQuery("#sid").val();
	var erowid=jQuery("#eid").val();
	var invalidreason=jQuery("#InvalidReason").val();
	var result = tkMakeServerCall("web.DHCEQMove", "DeleteMoveInfo",rowid,invalidreason,user,frowid,erowid);
	if(result==0) {
				jQuery.messager.alert("提示", "删除成功");
				CloseClick();
				return false;
			}
	else{
				jQuery.messager.alert("提示", "删除失败");
				return false;
	}
}*/
function CombinData()
{
	var combindata="";
	combindata=jQuery("#Rowid").val();											//1
  	combindata=combindata+"^"+jQuery("#No").val();								//2		
  	combindata=combindata+"^"+jQuery("#ObjID").combogrid('getValue');			//3
  	combindata=combindata+"^"+jQuery("#SourceType").combobox('getValue'); 		//4	
  	combindata=combindata+"^"+jQuery("#SourceID").combogrid('getValue');		//5
  	combindata=combindata+"^"+jQuery("#EventType").combobox('getValue');		//6
  	combindata=combindata+"^"+"";						//7
  	combindata=combindata+"^"+jQuery("#FromDeptType").combobox('getValue'); 	//8
  	combindata=combindata+"^"+jQuery("#FromDeptID").combobox('getValue');		//9
  	combindata=combindata+"^"+jQuery("#FromLocationDR").combobox('getValue');	//10
  	combindata=combindata+"^"+jQuery("#StartDate").datebox('getValue');			//11
  	combindata=combindata+"^"+jQuery("#StartTime").val();			//12
  	combindata=combindata+"^"+jQuery("#ToLocationDR").combobox('getValue');		//13
  	combindata=combindata+"^"+jQuery("#ToDeptType").combobox('getValue');		//14
  	combindata=combindata+"^"+jQuery("#ToDeptID").combobox('getValue');		//15
  	combindata=combindata+"^"+jQuery("#EndDate").datebox('getValue');			//16
  	combindata=combindata+"^"+jQuery("#EndTime").val();			//17
  	combindata=combindata+"^"+jQuery("#SendUserDR").combobox('getValue');		//18
  	combindata=combindata+"^"+jQuery("#AcceptUserDR").combobox('getValue');		//19
  	combindata=combindata+"^"+jQuery("#Remark").val();							//20
  	combindata=combindata+"^"+jQuery("#Status").val();							//21
	return combindata;
}
function CloseClick(){
	if (window.opener && !window.opener.closed) {
        window.parent.opener.location.reload();
    }
    window.close();
}
function initSourceType() {
	jQuery("#SourceType").combobox({
		fit: true,
		height: 24,
		multiple: false,
		editable: false,
		disabled: false,
		readonly: false,
    	valueField:'id', 
    	url:null,   
    	textField:'text',
		data: [{
			id: '',
			text: ''
		},{
			id: '1',
			text: '维修'
		},{
			id: '2',
			text: '租赁'
		},{
			id: '3',
			text: '转移单'
		}],
		onSelect:function(){
			jQuery("#SourceID").combogrid('clear');
			jQuery("#ObjID").combogrid('clear');
			jQuery("#FromDeptType").combobox('clear');
			jQuery("#FromDeptID").combobox('clear');
			jQuery("#FromLocationDR").combobox('clear');
			jQuery("#ToLocationDR").combobox('clear');
			jQuery("#ToDeptType").combobox('clear');
			jQuery("#ToDeptID").combobox('clear');
			initSourceIDData();
		}
	});
}
function initEventType() {
	jQuery("#EventType").combobox({
		fit: true,
		height: 24,
		multiple: false,
		editable: false,
		disabled: false,
		readonly: false,
    	valueField:'id', 
    	url:null,   
    	textField:'text',
		data: [{
			id: '',
			text: ''
		},{
			id: '1',
			text: '送出'
		},{
			id: '2',
			text: '返还'
		}]
	});
}
function initDeptType(comboxid){
	jQuery("#"+comboxid).combobox({
		fit: true,
		height: 24,
		multiple: false,
		//editable: false,
		disabled: false,
		readonly: false,
    	valueField:'id', 
    	url:null,   
    	textField:'text',
		data: [{
			id: '',
			text: ''
		},{
			id: '1',
			text: '科室'
		},{
			id: '2',
			text: '服务商'
		},{
			id: '3',
			text: '供应商'
		},{
			id: '4',
			text: '生产厂商'
		}],
	onSelect: function(record) {
			initDeptID(comboxid);
		}
	});
}
function CheckTime(argName)
{
	var str=jQuery("#"+argName).val();
	var InfoStr = str.split(":");
	var len=InfoStr.length;
	if(len>3)
	{
		return false;
	}
	if((len!=0)&&(str!=""))
	{
		if(isNaN(InfoStr[0]))
		{
			return false;
		}
		if((InfoStr[0]<0)||(InfoStr[0]>23))
		{
			return false;
		}
		if(isNaN(InfoStr[1]))
		{
			return false;
		}
		if((InfoStr[1]<0)||(InfoStr[1]>59))
		{
			return false;
		}
		if(len==3)
		{
			if(isNaN(InfoStr[2]))
			{
				return false;
			}
			if((InfoStr[2]<0)||(InfoStr[2]>59))
			{
				return false;
			}	
		}
	}
	return true;
}
//设置默认下拉框值
function setDefVal() {
	var curr_time = new Date();
   	var strDate = curr_time.getFullYear()+"-";
   	strDate += curr_time.getMonth()+1+"-";
   	strDate += curr_time.getDate()+"-";
   	strDate += curr_time.getHours()+":";
   	strDate += curr_time.getMinutes()+":";
   	strDate += curr_time.getSeconds();
   	jQuery("#StartDate").datebox('setValue', strDate);
	//jQuery("#EndDate").datebox('setValue', strDate);
	jQuery("#EventType").combobox('setValue','1');
}
/**
*加载DataGrid数据
*/
function loadDataGridStore(DataGridID, queryParams){
	window.setTimeout(function(){
		var jQueryGridObj = jQuery("#" + DataGridID);
		jQuery.extend(jQueryGridObj.datagrid("options"),{
			url : QUERY_URL.QUERY_GRID_URL,
			queryParams : queryParams
		});
		jQueryGridObj.datagrid("load");
	},0);
}
/**
*加载ComboGrid数据
*/
function loadComboGridStore(ComboGridID, queryParams) {
	var jQueryComboGridObj = jQuery("#" + ComboGridID);
	var grid = jQueryComboGridObj.combogrid('grid');	// 获取数据表格对象
	var opts = grid.datagrid("options");
	opts.url = QUERY_URL.QUERY_GRID_URL;

	grid.datagrid('load', queryParams);
}
//add by HHM 2016-01-21 弹出窗口居中显示
function openwindow(url,str,iWidth,iHeight){
	//var iWidth=800;
	//var iHeight=400;
	//window.screen.height获得屏幕的高，window.screen.width获得屏幕的宽  
	var iTop = (window.screen.height-30-iHeight)/2; //获得窗口的垂直位置;  
	var iLeft = (window.screen.width-10-iWidth)/2; //获得窗口的水平位置; 
	window.open(''+url+'?'+str+'', '_blank', 'width='+iWidth+',height='+iHeight+',left='+iLeft+',top='+iTop+'');	
}