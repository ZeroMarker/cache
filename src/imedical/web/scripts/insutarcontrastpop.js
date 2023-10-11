/**
* FillName: insutarcontrastpop.js
* Description: ҽ��Ŀ¼���յ���
* Creator JinShuai1010
* Date: 2022-11-29
*/
// ���峣��
var GetList_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarItem&pClassMethod=GetList";

var PUBLIC_CONSTANT = {
	SESSION: {
		HOSPID: session['LOGON.HOSPID'],  //Ժ��
	}
	
}
var PUB_CNT = {
	HITYPE:'',                               //ҽ������
	ChargesID:'',
	SSN: {
		USERID: session['LOGON.USERID'],	//����ԱID
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
	
//��ں���

$(function(){
   

    
	GetjsonQueryUrl()
	setPageLayout();    //����ҳ�沼��
	InsuSearch();
	$("#btnAddEnd").click(AddExpiryDate)
	

	
});


 //����ҳ�沼��
function setPageLayout(){
	
	//ҽ������
	initHiTypeCmb();
	initHisDivDetDgDg();
	
	setValueById('InsuCode',INTIMxmbm);
	
  
}


//��ʼ��ҽ������
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
				if(data[i].cDesc=='ȫ��'){
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


//��ʼ���շ�����Ϣdg
var Hiscolumn=[[
	        {                field:'ck',checkbox:true,width:40 },  
			{field:'TarConRowId',title:'����id',width:90,hidden:true},     
	        {field:'INSURowId',title:'ҽ��Ŀ¼id',width:90,hidden:true},
			{field:'INTCTInsuCode',title:'ҽ����Ŀ����',width:160},
			{field:'INTCTInsuDesc',title:'ҽ����Ŀ����',width:160},
            {field:'HISRowId',title:'�շ���id',width:90,hidden:true},
			{field:'INTCTHisDesc',title:'�շ�������',width:160},
			{field:'INTCTHisCode',title:'�շ������',width:90},
			{field:'TARIPrice',title:'�շ���۸�',width:80},
			{field:'INTCTActiveDate',title:'��Ч����',width:90},
			{field:'INTCTExpiryDate',title:'ʧЧ����',width:90}
			
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


//���������շ���
function btnConClick(){

	var selected = $('#HisDivDetDg').datagrid('getSelected');
	if (!selected) {
	   $.messager.alert("��ܰ��ʾ","��ѡ��ҽ��Ŀ¼!", 'info');
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
		title: "���������շ���",
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


//���ʧЧ����

function AddExpiryDate(){

	var selected = $('#HisDivDetDg').datagrid('getSelected');
	if (!selected) {
	   $.messager.alert("��ܰ��ʾ","��ѡ��ҽ��Ŀ¼!", 'info');
	}
    else{
	var ExpiryDate=getValueById('EndDate')
	var checkedItems = $('#HisDivDetDg').datagrid('getChecked');
	var TarConRowIdstr="";
     $.each(checkedItems, function (index, item) {
		TarConRowIdstr=TarConRowIdstr+item.TarConRowId+"^"
      });


	 // alert("���"+TarConRowIdstr+ExpiryDate+HospDr)
	
	  var rtn = $.m({ClassName: "web.INSUTarContrastQry", MethodName: "AddExpiry", InString:TarConRowIdstr,ExpiryDate:ExpiryDate,HospDr:HospDr,}, false);
	  if (rtn == '0'){
		$.messager.alert("��ܰ��ʾ",'��ӳɹ�' , 'info');
		InsuSearch()
	}else{
		$.messager.alert("��ܰ��ʾ",'���ʧ��'  + rtn , 'info');
		InsuSearch()
	}

}
	}
	
//����Ժ��
function selectHospCombHandle(){
	//$('#tInsuType').combobox('clear');
	$('#hiType').combobox('reload');
	//InsuSearch();	
}


