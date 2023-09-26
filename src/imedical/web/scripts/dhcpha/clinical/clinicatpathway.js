/// Creator: bianshuai
/// CreateDate: 2014-06-22
//  Descript: �ٴ�·��

var url="dhcpha.clinical.action.csp";

var statArray = [{ "val": "I", "text": "�뾶" }, { "val": "O", "text": "����" }, { "val": "C", "text": "���" }];
var typeArray = [{ "val": "QryCPWByInDate", "text": "�뾶ʱ��" }, { "val": "QryCPWByOutDate", "text": "����ʱ��" },
	{ "val": "QryCPWByAdmDate", "text": "��Ժʱ��" }, { "val": "QryCPWByDischDate", "text": "��Ժʱ��" }]

$(function(){
	//Ĭ����ʾ���������
	function initScroll(){
		var opts=$('#dg').datagrid('options');    
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
		$('#dg').datagrid('loadData',data);  
		$("tr[datagrid-row-index='0']").css({"visibility":"hidden"});
	}
	
	initScroll();//��ʼ����ʾ���������

	$('#dg').datagrid('loadData',{total:0,rows:[]});  //��ʼ�����ݱ�� qunianpeng  2016-09-08
	
	$("#stdate").datebox("setValue", formatDate(-1));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	
	//����
	$('#dept').combobox({
		mode:'remote',	
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion')
			//$('#dept').combobox('reload',url+'?action=SelAllLoc')
		}
		//panelHeight:"auto",  //���������߶��Զ�����
		//url:url+'?actiontype=SelAllLoc' 
	}); 

	//����
	$('#ward').combobox({
		mode:'remote',	
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			$('#ward').combobox('reload',url+'?action=GetAllWardNewVersion')
			//$('#ward').combobox('reload',url+'?action=SelAllLoc&loctype=W')
			//$('#ward').combobox('reload',url+'?action=SelAllWard') //qunianpeng 2016/10/17
		}
		//panelHeight:"auto",  //���������߶��Զ�����
		//url:url+'?actiontype=SelUserByGrp&grpId='+session['LOGON.GROUPID'] 
	});

	//״̬
	$('#status').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:statArray 
	});
	$('#status').combobox('setValue',"I"); //����comboboxĬ��ֵ
	
	//����
	$('#type').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:typeArray
	});
	$('#type').combobox('setValue',"QryCPWByInDate"); //����comboboxĬ��ֵ
	
	//�ٴ�·���ֵ�
	$('#cpwdic').combobox({
		onShowPanel:function(){
			$('#cpwdic').combobox('reload',url+'?action=ClinPathWayDic')
		}
	});
	
})

//��ѯ
function Query()
{
	//1�����datagrid 
	$('#dg').datagrid('loadData',{total:0,rows:[]});  //qunianpeng  2016-09-08 
	
	var StDate=$('#stdate').datebox('getValue'); //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue'); //����ID
	var WardID=$('#ward').combobox('getValue'); //����ID
	var Status=$('#status').combobox('getValue'); //״̬
	var PathWaysQuery=$('#type').combobox('getValue'); //����
	var Select="N"; //$('#type').combobox('getValue'); //�Ƿ�ɸѡ
	var cpyicID=$('#cpwdic').combobox('getValue'); //�ٴ�·���ֵ�
	if (LocID== undefined){LocID="";}
	if (WardID== undefined){WardID="";}
	if (cpyicID== undefined){cpyicID="";}
	if (Status== undefined){Status="";}
	if (PathWaysQuery== undefined){PathWaysQuery="QryCPWByInDate";}
	var params=StDate+"^"+EndDate+"^"+Status+"^"+LocID+"^"+WardID+"^"+Select+"^"+cpyicID+"^"+PathWaysQuery;
	$('#dg').datagrid({
		url:url+'?action=CliPathWay',	
		queryParams:{
			params:params}
	});
	//$('#dg').datagrid('load',{params:params}); 
}

//��������ɫ  formatter="SetCellColor"
function SetCellColor(value, rowData, rowIndex)
{
	var color="";
	if(((value.indexOf("-")=="-1")&(value!="��"))||(value=="��")){
		color="green";
	}else{
		color="red";}
	return '<span style="font-weight:bold;color:'+color+'">'+value+'</span>';
}

//�ǼǺ��������� formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showWin("+rowData.Paadm+")'>"+value+"</a>";
}

///��ʾ���� formatter="SetCellUrl"
function showWin(AdmDr)
{
	createPatInfoWin(AdmDr); //���ô��� createPatInfoWin.js
}