/**
* FillName: insubalancedayn.js
* Description: ҽ���ն���
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
	
	//��ʼ������
	initDate();
	
	//ҽ������
	initInsuTypeCmb();
	
	//�������
	initAdmTypeCmb();
	
	//�ն��˽����¼
	initBallistDg();
	
	//ҽ�������쳣��¼
	initCentererrDg();
	
	//ҽԺ�쳣��¼
	initHiserrDg()
	
	
	$('#btnDivBalDayQuery').off().on("click", DivBalDayQuery_click);
	$('#btnDivCenterDL').off().on("click", DivCenterDL_click);
	$('#btnDivBalDaySubmit').off().on("click",DivBalDaySubmit_click);
}


//��ʼ��ҽ������
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
			    if(data[i].cDesc=="ȫ��")
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
//��ʼ����������
function initAdmTypeCmb(){
 $HUI.combobox('#admtype',{   
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '1',
			Desc: '����'
		},{
			Code: '2',
			Desc: 'סԺ'
		}],
		value: '1'
	}); 

}

//��ʼ��ҽ���з�����
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
				if(data[i].cDesc=='ȫ��'){
					data.splice(i,1)
					}
				}
			
			return data
			},
		})
}

//��ʼ���ն��˽��dg
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
			{field:'INSUType',title:'ҽ������',width:80},
			{field:'INSUCenter',title:'�籣�������',width:150},
			{field:'INSUYllb',title:'ҽ�����',width:80},
			{field:'INSURylb',title:'��Ա���',width:80},
			{field:'HisTotAmt',title:'HIS�ܽ��',width:100},
			{field:'HisTotCnt',title:'HIS���˴�',width:100},
			{field:'Hisjjzfe',title:'HIS����֧��',width:100},
			{field:'Hiszhzfe',title:'HIS�˻�֧��',width:100},
			{field:'Hisgrzfe',title:'HIS�����Ը�',width:100},
			{field:'INSUTotAmt',title:'ҽ���ܽ��',width:100},
			{field:'INSUTotCnt',title:'ҽ�����˴�',width:100},
			{field:'INSUjjzfe',title:'ҽ������֧��',width:100},
			{field:'INSUzhzfe',title:'ҽ���˻�֧��',width:100},
			{field:'INSUgrzfe',title:'ҽ�������Ը�',width:100},
			{field:'dzlsh',title:'������ˮ��',width:120},
			{field:'jylsh',title:'������ˮ��',width:120},
			{field:'Flag',title:'����״̬',width:80},
			{field:'Info',title:'����ʧ��ԭ��',width:120},
			{field:'StDate',title:'��ʼ����',width:80},
			{field:'EndDate',title:'��������',width:80},
			{field:'iDate',title:'��������',width:80},
			{field:'iTime',title:'����ʱ��',width:80},
			{field:'sfrm0',title:'���˲���Ա',width:80},
			{field:'dzqh',title:'��������',width:100}
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
//��ѯ�ն��˽��
function QryBallistDg()
{
    var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var InsuType=$('#insutype').combobox('getValue');
	
	if(StDate==""){
		$.messager.alert('ע��','�������ڲ���Ϊ�գ�');
		return;
	}
	if(InsuType==""){
		$.messager.alert('ע��','ҽ�����Ͳ���Ϊ�գ�');
		return;
	}

	
	$HUI.datagrid('#ballist',{
		url:$URL+"?ClassName="+'web.DHCINSUBalanceDayCtl'+"&QueryName="+'BalanceDayInfo'+"&StDate="+StDate+"&EnDate="+EndDate+"&AdmType="+''+"&InsuType="+InsuType+"&HospId="+HospitalId,

		})
		
	
}



//��ʼ��ҽ���쳣����dg
function initCentererrDg()
{

	//���������б�
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
			{field:'zylsh',title:'סԺ��ˮ��',width:150},
			{field:'djlsh',title:'����ҵ���',width:150},
			{field:'jylsh',title:'������ˮ��',width:150},
			{field:'INSUNo',title:'���˱��',width:80},
			{field:'Name',title:'����',width:80},
			{field:'INSUTotAmt',title:'�ܽ��',width:80},
			{field:'INSUjjzfe',title:'ҽ�����',width:80},
			{field:'INSUgrzfe',title:'�Էѽ��',width:80},
			{field:'INSUDateTime',title:'�շ�����',width:80},
			{field:'INSUsUserDr',title:'�շ�Ա',width:100},
			{field:'INSUYllb',title:'���(�Һ�/�շ�)',width:100}
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
//��ѯҽ���쳣����
function QryCenterErrDg(INBALSDr)
{
	
	
	var urlStr=$URL+"?ClassName=web.DHCINSUBalanceUnusualCtl&QueryName=BalanceUnusualInfo&BalanceDayDr="+INBALSDr+"&UnFlag=1";
	$HUI.datagrid('#centererrdg',{
		url:urlStr
	});
	
}



//��ʼ��HIS�쳣����
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
			{field:'zylsh',title:'סԺ��ˮ��',width:150},
			{field:'djlsh',title:'����ҵ���',width:150},
			{field:'jylsh',title:'������ˮ��',width:150},
			{field:'INSUNo',title:'���˱��',width:80},
			{field:'Name',title:'����',width:80},
			{field:'HisTotAmt',title:'�ܽ��',width:80},
			{field:'Hisjjzfe',title:'ҽ�����',width:80},
			{field:'Hisgrzfe0',title:'�Էѽ��',width:80},
			{field:'DivDate',title:'�շ�����',width:80},
			{field:'OptName',title:'�շ�Ա',width:100},
			{field:'INSUYllb',title:'���(�Һ�/�շ�)',width:100}
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
	
	//��ѯHIS�쳣����
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
		$.messager.alert('ע��','�������ڲ���Ϊ�գ�');
		return;
	}
	if(InsuType==""){
		$.messager.alert('ע��','ҽ�����Ͳ���Ϊ�գ�');
		return;
	}
	
	ExpString=StDate+"^"+EndDate+"^^"+"10"+"^"+"";
	rtn=InsuDivLoad(0,Guser,HospitalId,InsuType,ExpString);
	if(rtn!=0){
		$.messager.alert('����','��ȡҽ�����Ľ�������ʧ�ܣ�rtn='+rtn);
	}else{
		$.messager.alert('��ܰ��ʾ','��ȡҽ�����Ľ����������');
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
		$.messager.alert('ע��','�������ڲ���Ϊ�գ�');
		return;
	}
	if(InsuType==""){
		$.messager.alert('ע��','ҽ�����Ͳ���Ϊ�գ�');
		return;
	}
	var urlStr=$URL+"?ClassName=web.DHCINSUBalanceDayCtl&QueryName=BalanceDayInfo&StDate="+StDate+"&EnDate="+EndDate+"&AdmType="+""+"&InsuType="+InsuType+"&HospId="+HospitalId;
	$HUI.datagrid('#ballist',{
		url:urlStr
	});
}

function DivQuery(){
	$.messager.alert('��ܰ��ʾ','��ѯhisҽ����������');
	var StDate=$('#stdate').datebox('getValue');
	var EndDate=$('#endate').datebox('getValue');
	var InsuType=$('#insutype').combobox('getValue');
	var AdmType=$('#AdmType').combobox('getValue');
	
	if(StDate==""){
		$.messager.alert('ע��','�������ڲ���Ϊ�գ�');
		return;
	}
	if(InsuType==""){
		$.messager.alert('ע��','ҽ�����Ͳ���Ϊ�գ�');
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
		$.messager.alert('����','����ʧ�ܣ�');
	}else{
		$.messager.alert('��ܰ��ʾ','�ύ�������');
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

