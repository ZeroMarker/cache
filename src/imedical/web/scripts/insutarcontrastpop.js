/**
* FillName: insutarcontrastpop.js
* Description: 医保目录对照弹窗
* Creator JinShuai1010
* Date: 2022-11-29
*/
// 定义常量
var GetList_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarItem&pClassMethod=GetList";

var PUBLIC_CONSTANT = {
	SESSION: {
		HOSPID: session['LOGON.HOSPID'],  //院区
	}
	
}
var PUB_CNT = {
	HITYPE:'',                               //医保类型
	ChargesID:'',
	SSN: {
		USERID: session['LOGON.USERID'],	//操作员ID
	},
	SYSDTFRMT:function(){
		var _sysDateFormat=$.m({
		ClassName: "websys.Conversions",
		MethodName: "DateFormat"
	     },false);
	     return _sysDateFormat;
		}
};
var Rq = INSUGetRequest();

	var HospDr = Rq["Hospital"]
    var INTIMxmbm=Rq["INTIMxmbm"]
	var INSUType=Rq["INSUType"]
	
//入口函数

$(function(){
   

    
	GetjsonQueryUrl()
	setPageLayout();    //设置页面布局
	InsuSearch();
	$("#btnAddEnd").click(AddExpiryDate)
	

	
});


 //设置页面布局
function setPageLayout(){
	
	//医保类型
	initHiTypeCmb();
	initHisDivDetDgDg();
	
	setValueById('InsuCode',INTIMxmbm);
	
  
}


//初始化医保类型
function initHiTypeCmb()
{
	$HUI.combobox('#hiType',{
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
	    	param.HospDr=HospDr;
	    },
	    loadFilter:function(data){
			for(var i in data){
				if(data[i].cDesc=='全部'){
					data.splice(i,1)
				}
			}
			return data
		},
		onLoadSuccess:function(){
			$('#hiType').combobox('select','00A');
			},
		onSelect:function(rec){
			PUB_CNT.HITYPE = rec.cCode;
		}
		
	});
}


//初始化收费项信息dg
var Hiscolumn=[[
	        {                field:'ck',checkbox:true,width:40 },  
			{field:'TarConRowId',title:'对照id',width:90,hidden:true},     
	        {field:'INSURowId',title:'医保目录id',width:90,hidden:true},
			{field:'INTCTInsuCode',title:'医保项目编码',width:160},
			{field:'INTCTInsuDesc',title:'医保项目名称',width:160},
            {field:'HISRowId',title:'收费项id',width:90,hidden:true},
			{field:'INTCTHisDesc',title:'收费项名称',width:160},
			{field:'INTCTHisCode',title:'收费项编码',width:90},
			{field:'TARIPrice',title:'收费项价格',width:80},
			{field:'INTCTActiveDate',title:'生效日期',width:90},
			{field:'INTCTExpiryDate',title:'失效日期',width:90}
			
		]];
function initHisDivDetDgDg()
{
	 $HUI.datagrid('#HisDivDetDg',{
		autoSizeColumn:false, 
		toolbar:[],
		headerCls: 'panel-header-gray',
		rownumbers:true,
		//border: false,
		fit:true,
		striped:true,
		//url:$URL,
		singleSelect:false,
		pageSize:20,
		pageList:[10, 20, 30],
		pagination:true,
		columns:Hiscolumn
  
	});
}

function InsuSearch()
{
	
	var InsuCode=INTIMxmbm;
	$HUI.datagrid('#HisDivDetDg',{

	  columns:Hiscolumn,
	  url:$URL,
	  iconCls:'icon-save',
	  border: false,
	  fit:true,
	  striped:true,
	  autoSizeColumn:false, 
	    rownumbers:true,
	    pagination:true,
	    singleSelect:false,
	    pageSize:20,
	    pageList:[20,40,60],

		toolbar: '#tToolBar',
	  queryParams:{
		ClassName:'web.INSUTarContrastQry',
		QueryName:'GetTarConInfo',
		 'Type':INSUType,
         'InsuAlias':'',
	     'InsuCode':InsuCode,
	     'InsuDesc':'',
	     'HisAlias':'',
	     'HisCode':'',
	     'HisDesc':'',
	     'HospId':HospDr
	              },
	    onSelect:function(rowIndex, rowData) {
		     //var dgRow = dgRows[rowIndex];
		     
		     //var ChargesCode=INSUMIDataGrid.getCellVal('HisDivDetDg',dgSelectIndex,'HisCode');
		    
		     
	        
        },
	
	});
	
}


//批量关联收费项
function btnConClick(){

	var selected = $('#HisDivDetDg').datagrid('getSelected');
	if (!selected) {
	   $.messager.alert("温馨提示","请选择医保目录!", 'info');
	}
    else{


	var checkedItems = $('#HisDivDetDg').datagrid('getChecked');
	var TarConRowIdstr="";
	var HisID=""


     $.each(checkedItems, function (index, item) {
		TarConRowIdstr=TarConRowIdstr+item.TarConRowId+"^"
        HisID =HisID+item.HISRowId+"^"
      });
	  
	 // alert(HisID)
	//  alert(TarConRowIdstr)
	var url = "insutarcontrastpopup.csp?&TarConRowId="+TarConRowIdstr+"&INSUType="+ INSUType +" &HospDr="+HospDr+"&HisID="+HisID;
	websys_showModal({
		url: url,
		title: "批量关联收费项",
		iconCls: "icon-w-edit",
		width: "430",
		height: "360",
		
		//resizable:true,
		//scrollbars: true,
		//isTopZindex:true,
		//overflow:false,
		onClose: function () {
			
		}
	});
	}

	}


//添加失效日期

function AddExpiryDate(){

	var selected = $('#HisDivDetDg').datagrid('getSelected');
	if (!selected) {
	   $.messager.alert("温馨提示","请选择医保目录!", 'info');
	}
    else{
	var ExpiryDate=getValueById('EndDate')
	var checkedItems = $('#HisDivDetDg').datagrid('getChecked');
	var TarConRowIdstr="";
     $.each(checkedItems, function (index, item) {
		TarConRowIdstr=TarConRowIdstr+item.TarConRowId+"^"
      });


	 // alert("入参"+TarConRowIdstr+ExpiryDate+HospDr)
	
	  var rtn = $.m({ClassName: "web.INSUTarContrastQry", MethodName: "AddExpiry", InString:TarConRowIdstr,ExpiryDate:ExpiryDate,HospDr:HospDr,}, false);
	  if (rtn == '0'){
		$.messager.alert("温馨提示",'添加成功' , 'info');
		InsuSearch()
	}else{
		$.messager.alert("温馨提示",'添加失败'  + rtn , 'info');
		InsuSearch()
	}

}
	}
	
//加载院区
function selectHospCombHandle(){
	//$('#tInsuType').combobox('clear');
	$('#hiType').combobox('reload');
	//InsuSearch();	
}


