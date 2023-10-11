var dicArr = [{"value":"DrugPreMetData","text":'��ҩ;���ֵ�'},{"value":"DrugFreqData","text":'��ҩƵ���ֵ�'}];

$(document).ready(function() {
	initCombobox();
   
    initButton();
    
    initdicGrid();       			 //����ͳ������ 
   
})
//���ؽ������
function initdicGrid(){
	

	///  ����columns
	var columns=[[
		{field:"id",width:100,title:"id",hidden:false},	
		{field:"code",width:100,title:"��Ŀ����"},
		{field:"desc",width:320,title:"��Ŀ����"},
		{field:"type",width:100,title:"ҩƷ����"}
	]];
	
	///  ����datagrid
	var option = {		
		bordr:false,
		//fit:true,
		//fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:3000,
		pageList:[3000,6000,9000],	
	 	onClickRow: function (rowIndex, rowData) {					        
 	 	}  
	};
	var dicType = $HUI.combobox("#dictype").getValue();
	var hospCode = $HUI.combobox("#hosp").getValue();
	var params = dicType +"^"+ hospCode;
	var uniturl =  $URL+"?ClassName=web.DHCCKBSearchconDic&MethodName=QueryNewDicList&params="+params;
	new ListComponent('maingrid', columns, uniturl, option).Init();

}

///��ѯ�ֵ�
function Query()
{
	var dicType = $HUI.combobox("#dictype").getValue();
	var hospCode = $HUI.combobox("#hosp").getValue();
	var params = dicType +"^"+ hospCode;
	$("#maingrid").datagrid('load',{'params':params});

}

///��ʼ��combobox
function initCombobox()
{
	$HUI.combobox("#dictype",{
		data:dicArr,
		valueField:'value',
		textField:'text',
		panelHeight:"160",
		mode:'remote',
		onSelect:function(ret){
			//Query();
		 }
	})	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBSearchconDic&MethodName=GetHosp"  

	$HUI.combobox("#hosp",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		panelHeight:"160",
		mode:'remote',
		onSelect:function(ret){
			
		}
	})	
	
	$HUI.combobox("#hosp").setValue(LgHospID)
	
}


///��ѯ
function initButton()
{
	$('#find').bind("click",Query);
	
	$('#export').bind("click",exportList);
}

///����
function exportList()
{
	var dicType = $HUI.combobox("#dictype").getValue();
	var hospCode = $HUI.combobox("#hosp").getValue();
	var params = dicType +"^"+ hospCode;
	var name = ""
	if (dicType == "DrugPreMetData"){
		name = "��ҩ;���ֵ�"
	}
	if (dicType == "DrugFreqData"){
		name = "��ҩƵ���ֵ�"
	}
	
	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName: name+"�����ֵ�����", //Ĭ��DHCCExcel
		ClassName:"web.DHCCKBSearchconDic",
		QueryName:"ExportNewDicList",
		params:params 
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;
	
	return;
	var rtn = tkMakeServerCall("websys.Query","ToExcel","�����ֵ�����.csv","web.DHCCKBSearchconDic","ExportNewDicList",params);
	location.href = rtn;	

}
