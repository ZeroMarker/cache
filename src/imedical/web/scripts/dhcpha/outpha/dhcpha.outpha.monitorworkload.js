/// Creator: bianshuai
/// CreateDate: 2014-06-22
/// �����󷽹�����ͳ��js

var url="dhcpha.clinical.action.csp";
var TypeArray = [{ "val": "P", "text": "ͨ��" }, { "val": "R", "text": "�ܾ�" }, { "val": "N", "text": "δ��" }];
$(function(){
	//Ĭ����ʾ���������
	function initScroll(){
		var opts=$('#dgUser').datagrid('options');    
		var text='{';    
		for(var i=0;i<opts.columns.length;i++)
		{    
			var inner_len=opts.columns[i].length;    
			for(var j=0;j<inner_len;j++)
			{    
				if((typeof opts.columns[i][j].field)=='undefined')break;    
				text+="'"+opts.columns[i][j].field+"':''";    
				if(j!=inner_len-1){
					text+=",";    
				}    
			}    
		}    
		text+="}";    
		text=eval("("+text+")");    
		var data={"total":1,"rows":[text]};    
		$('#dgUser').datagrid('loadData',data);  
		$("tr[datagrid-row-index='0']").css({"visibility":"hidden"});
	}
	
	initScroll();//��ʼ����ʾ���������
	
	$("#stdate").datebox("setValue", formatDate(-1));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	
	/*
	//����
	$('#Dept').combobox({
		onShowPanel:function(){
			$('#Dept').combobox('reload',url+'?actiontype=SelAllLoc&loctype=D');
		}
	}); 
	*/
	//�û�
	$('#User').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?actiontype=SelUserByGrp&grpId='+session['LOGON.GROUPID']
	});  
	
	//����
	$('#Type').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:TypeArray
	});
	$('#Type').combobox('setValue',"P"); //����comboboxĬ��ֵ
})

/// ��ʽ������
function formatDate(t)
{
	var curr_time = new Date();  
	var Year = curr_time.getFullYear();
	var Month = curr_time.getMonth()+1;
	var Day = curr_time.getDate()+parseInt(t);
	return Month+"/"+Day+"/"+Year;
}

//��ѯ
function Query()
{
	var tab = $('#tab').tabs('getSelected');  // ��ȡѡ������
	var tbId = tab.attr("id");  //ѡ������ID
	var StDate=$('#stdate').datebox('getValue'); //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID="";  //$('#Dept').combobox('getValue'); //����ID
	var UserID=$('#User').combobox('getValue');       //UserID
	var Type=$('#Type').combobox('getValue');         //״̬
	
	if((StDate=="")||(StDate=="")){
		$.messager.alert("��ʾ:","��ʼ���ڻ��ֹ���ڲ���Ϊ�գ�");
		return;
	}

	if(Type==""){
		$.messager.alert("��ʾ:","���Ͳ���Ϊ�գ�");
		return;
	}
		
	var dgID="";
	var params=StDate+"^"+EndDate+"^"+session['LOGON.CTLOCID']+"^"+UserID+"^"+Type+"^"+tbId;
	if(tbId=="tabUser"){
		dgID='#dgUser';
	}else{
		dgID='#dgDept';
	}
	
	//$(dgID).datagrid('load',{params:params});  

	$(dgID).datagrid({
		url:url+'?actiontype=MonitoWorkLoad',
		queryParams:{
			params:params}
	});
}

//�������� formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showWin("+rowData.TPid+","+rowData.TLocDr+")'>"+value+"</a>";
}

///��ʾ���� formatter="SetCellUrl"
function showWin(pid,LocID)
{
	$('#win').append('<div id="dg"></div>');
	$('#win').window({
		title:'��ϸ�б�',
		collapsible:true,
		border:true,
		closed:"true",
		width:900,
		height:550,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		toolbar:[{text: 'ȡ��'}]
	});
	$('#dg').datagrid({
		rownumbers:'true',
		pagination:'true',
		url:url+'?actiontype=QueryLocDetail',
		fit:'true',
		pageList:[30,60],
		pageSize:30,
		singleSelect:'true',
		columns: [[
			{field:"TPatNo",title:'�ǼǺ�',width:'100'},
			{field:"TPatName",title:'��������',width:'100'},
			{field:"TPrescNo",title:'������',width:'100'}
		]],
		queryParams:{
			LocID:LocID,
			pid:pid
		}
	})
	$('#win').window('open');   

}
