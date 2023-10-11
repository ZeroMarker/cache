/**
 * ҽ�����ά��JS
 * insudiagnos.js
 * Zhan 201601
 * �汾��V1.0
 * easyui�汾:1.3.2
 */
var cmenu;
var grid;
var ConGrid;
var selHisData="";
var selInsuData=""
var IPAddress=""
//var ROOTID='TEST2';	//������
var searchParam = {}; 
var seldictype=""; 
var QParam="";
var EditIndex=undefined;

var dgselected=-2;
$(function(){
	// 2019-6-5 tangzf �༭��س��Զ�����
	$(document).keydown(function (e) {
		if(e.target.className=='datagrid-editable-input'){
			Enter_KeyDown(e);
		}
		
	});
	// 2019-6-5 tangzf 
	IPAddress=GetLocalIPAddress() 
	
	GetjsonQueryUrl();
	//�����б�
	// var dicurl=jsonQueryUrl+'web.INSUDicDataCom'+SplCode+"GetDicJSONInfo"+SplCode+"TariType^^"	//ArgSpl
	// var diccombox=$('#insuType').combogrid({  
	//     panelWidth:350,   
	//     panelHeight:238,  
	//     idField:'INDIDDicCode',   
	//     textField:'INDIDDicDesc', 
    //     rownumbers:true,
    //     fit: true,
    //     pagination: false,
    //     url:dicurl,
	//     columns:[[   
	//         {field:'INDIDDicCode',title:'����',width:60},  
	//         {field:'INDIDDicDesc',title:'����',width:100}
	        
	//     ]],
	//     fitColumns: true,
	//     onLoadSuccess:function(data){
	// 		diccombox.combogrid('setValue',data.rows[2].INDIDDicCode)
	// 	}
	// }); 
	var diccombox=$('#insuType').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'cCode',   
	    textField:'cDesc', 
        rownumbers:true,
        url:$URL,
        onBeforeLoad:function(param){
	        param.ClassName = 'web.INSUDicDataCom';
	        param.QueryName = 'QueryDic1';
	        param.Type = 'TariType';
	        param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;    
	    },
        fit: true,
        pagination: false,
	    columns:[[   
	        {field:'cCode',title:'����',width:60},  
	        {field:'cDesc',title:'����',width:100}  
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
		    diccombox.combogrid('setValue',data.rows[0].cCode);
		},
		onSelect:function(index,data){
		}
		
	}); 
	$('#QClase').combobox({   
	 	panelHeight:80, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '1',
			Desc: '��ƴ��'
		},{
			Code: '2',
			Desc: '��ϴ���'
		},{
			Code: '3',
			Desc: '�������'
		}]

	}); 

	//�汾
	$('#HisVer').combobox({
		valueField: 'VersionCode',
		textField: 'VersionName',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			console.log(param)
	      	param.ClassName = 'web.DHCINSUPortUse';
	      	param.QueryName = 'GetBDVersionDic';
	      	param.rowid = '';
	      	param.code = '';
	      	param.desc = '';
	      	param.type='User.MRCICDDx';
	      	param.IsInsuFlag='Y';
	      	param.ResultSetType = 'array';
	      	return true;

		},
		onSelect: function (data) {
			Query();
		}
	});	

	//��ʼ�����յ�grid
	grid=$('#dg').datagrid({
		idField:'dgid',
		iconCls: 'icon-save',
		toolbar:'#tToolBar',
		fit: true,
		rownumbers: true,
		border: false,
		//width: 1000,
		//height: 580,
		//fit:true,
		singleSelect: true,
		fitColumns: false,
		pagination: true,
		autoRowHeight: false,
		pageSize: 20,
		striped: true,
		// frozenColumns: [[
		// 	{
		// 		field: 'TOpt',
		// 		width: 40,
		// 		title: '����',
		// 		align: 'center',
		// 		formatter: function (value, row, index) {
		// 			return "<img class='myTooltip' style='width:60' title='�޸�' onclick=\"Edit('" + index + "')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_pen.png' style='border:0px;cursor:pointer'>";
		// 		}
		// 	}
		// ]],
		columns:[[
			{field:'INDISRowid',title:'Rowid',width:60,hidden:true},
			{field:'bztype',title:'ҽ������',width:80},
			{field:'bzbm',title:'��ϴ���',width:100},
			{field:'bzmc',title:'�������',width:260},
			{field:'srrj',title:'������',width:120},
			{field:'ActiveDate',title:'��Ч����',width:100,editor:{type:'datebox',options:{minDate:'1971-01-01',maxDate:'9999-01-01'}}},
			{field:'HisVer',title:'�汾',width:100,hidden:true},
			{field:'HisVerDesc',title:'�汾',width:140},
			{field:'Cate',title:'��������',width:80,editor:'text'},
			{field:'SubCate',title:'����������',width:80,editor:'text'},
			{field:'srrjwb',title:'������2',width:80,hidden:true},
			{field:'Date',title:'��������',width:100},
			{field:'Time',title:'����ʱ��',width:100},
			{field:'UserDr',title:'����Ա',width:80},
			{field:'ADDIP',title:'����IP',width:150},
			{field:'Unique',title:'����Ψһ��',width:90,editor:'text'},
			{field:'jcbzbz',title:'���Ʒ�ʽ',width:80,editor:'text'},
			{field:'XString01',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString02',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString03',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString04',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString05',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString06',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString07',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString08',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			//{field:'XString10',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'}
			{field:'ExpiryDate',title:'ʧЧ����',width:100,editor:{type:'datebox',options:{minDate:'1971-01-01',maxDate:'9999-01-01'}}},
			{field:'HospDr',title:'Ժ��',width:60,hidden:true,editor:'text'},
			{field:'HiType',title:'ҽ�����ʹ���',width:60,hidden:true}
		]],
		
        onSelect : function(rowIndex, rowData) {
	        if(dgselected==rowIndex){return}
	        dgselected=rowIndex;
        },
        onUnselect: function(rowIndex, rowData) {
        }, 
       	onLoadSuccess:function(data){
			$('#dg').datagrid("unselectAll"); //
	   	},
	   	onDblClickRow:function(rowIndex, rowData){
			editINSUDiagnosis(rowIndex);
		},  
	});
	
	$('#KeyWords').keyup(function(){
		if(event.keyCode==13){
			Query();
		}
	});
	if($('#QClase').combobox('getValue')==""){$('#QClase').combobox('select','1')}
	//$('#wind').window('open')
	grid.datagrid({}).datagrid("keyCtr");
	//$('#wdg').datagrid({}).datagrid("keyCtr");
});
function getSearchParam(){  
	return searchParam;  
}

//��ѯҽ���������
function Query(){
	var QueryParam={
		ClassName :'web.INSUDiagnosis' ,
		QueryName : 'QueryDiagnosis',
		QType : $('#insuType').combobox('getValue'), 
		QKWords : getValueById('QClase') + '@' + getValueById('KeyWords'), 
		HospDr : PUBLIC_CONSTANT.SESSION.HOSPID,
		QHisVer:$('#HisVer').combobox('getValue')
	}
	loadDataGridStore('dg',QueryParam);
}

//ȡ��������
function GetToday(){
	var myDate=new Date();
	var y = myDate.getFullYear();
	var m = myDate.getMonth()+1;
	var d = myDate.getDate();
	var DateStr=y+"-"+(m<10?('0'+m):m)+"-"+(d<10?('0'+d):d);
	var DateType=tkMakeServerCall("websys.Conversions","DateFormat")
	//alert(DateType)
	if (DateType=="4"){DateStr=(d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y}
	else if (DateType=="1"){DateStr=(m<10?('0'+m):m)+"/"+(d<10?('0'+d):d)+"/"+y}
	return DateStr
}

function GetTimeNow(){
	var myDate = new Date();
	var h=myDate.getHours();       //��ȡ��ǰСʱ��(0-23)
	var m=myDate.getMinutes();     //��ȡ��ǰ������(0-59)
	var s=myDate.getSeconds();     //��ȡ��ǰ����(0-59)
	return h+":"+(m<10?('0'+m):m)+":"+(s<10?('0'+s):s)
}

function getEditRow(lastIndex,field){  
	var tmptar=ConGrid.datagrid('getEditor', {    
        index : lastIndex,    
        field : field  
	}).target;  
	return tmptar
}  
function getEditRownew(lastIndex){  
	var tmptar=ConGrid.datagrid('getEditors',lastIndex);  
	return tmptar
}  

function isEditing(){
	if (EditIndex == undefined){return true}
	if (grid.datagrid('validateRow', EditIndex)){
		//var ed = grid.datagrid('getEditor', {index:EditIndex,field:'INSUDigCode'});
		//var productname = $(ed.target).combobox('getText');
		//grid.datagrid('getRows')[EditIndex]['INSUDigCode'] = productname;
		grid.datagrid('endEdit', EditIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
// //ҽ������޸�
// function Edit(rowIndex){
// 	var selected = $('#dg').datagrid('getSelected');
// 	var rowData = $('#dg').datagrid("getRows")[rowIndex];
// 	if (!selected&&!rowData) {
// 	   $.messager.alert("��ܰ��ʾ","��ѡ��һ��ҽ�����!", 'info');
// 	}
// 	else{
// 		if(!selected)
// 		{
// 			INDISRowid=rowData.INDISRowid
// 		}
// 		else{
// 			INDISRowid=selected.INDISRowid
// 		}
// 		//����޸ĵ���	+20230208 HanZH
// 		var url = "dhcinsu.diageditcom.csp?&INDISRowid="+INDISRowid
// 		websys_showModal({
// 			url: url,
// 			title: "ҽ�����ά���޸�",
// 			iconCls: "icon-w-edit",
// 			width: "780",
// 			height: "415",
// 			onClose: function () {
				
// 			}
// 		});
// 	}

// 	/*
// 	if(rowIndex>=0)
// 	{
// 		if((undefined!=EditIndex)&(rowIndex!=EditIndex)){grid.datagrid('endEdit', EditIndex);}
// 		var editrow=grid.datagrid('getRows')[rowIndex];
// 		if((undefined==editrow["bztype"])||(""==editrow["bztype"])||(undefined==editrow['bzbm'])||(""==editrow['bzbm'])||(""==editrow['bzmc'])||(undefined==editrow['bzmc'])){
// 			$.messager.alert('��ʾ','�����ݲ��ܱ༭!');
// 			return;
// 		}
// 		grid.datagrid('beginEdit',rowIndex);
// 		EditIndex = rowIndex;
// 		return true
// 	}else{
// 		$.messager.alert('��ʾ','Ҫ��ѡ��һ�в��ܱ༭!');
// 	}
// }
// function SaveBak(){
// 	var Changes=$('#GrpInfoGV').datagrid("getChanges") ;
// 	if(Changes.length>0){
// 		var ret=SaveFun(Changes[Changes.length-1]);
// 		if(ret){
// 			$('#GrpInfoGV').datagrid("refreshRow",rowIndex)
// 			$('#GrpInfoGV').datagrid("acceptChanges") ;
// 			rowIndex=-1 ;
// 			return true ;
// 		}
// 		else{
// 			$('#GrpInfoGV').datagrid("rejectChanges") ;
// 			$('#GrpInfoGV').datagrid("deleteRow",rowIndex)
// 			rowIndex=-1 ;
// 			return false ;
// 		} 
// 	}
// 	rowIndex=-1 ;
// 	*/
// }

//���±����¼

///******************************************************************
///����˵����
///          ���ݵ���
///******************************************************************
function importDiag(){
	//���ļ�ѡ��	
	var filePath=OpenFileDialog(); //dhcinsu.common.js	
	if (filePath == "") {
		$.messager.alert('��ʾ', '��ѡ���ļ���','info')
		return ;
	}
	//ȡ��excel   
	$.messager.progress({
		title: "��ʾ",
		msg: 'ҽ����ϵ���',
		text: '���ݶ�ȡ��...'
	}); 
	$.ajax({
	   async : true,
	   complete : function () {
           ReadDiagnosExcel(filePath);
	    }
	});
}

//��ȡDiagnosExcel����
function ReadDiagnosExcel(filePath)
{
   //��ȡexcel
   var arr;
   try 
   {
	 arr= websys_ReadExcel(filePath);
	 $.messager.progress("close");
	}
   catch(ex)
   {
	  $.messager.progress("close");
	  $.messager.alert('��ʾ', '����websys_ReadExcel�쳣��'+ex.message,'error')
	  return ;
	}
	 var rowCnt=arr.length
    $.messager.progress({
            title: "��ʾ",
            msg: 'ҽ����ϵ���',
            text: '�����У����Ժ�'
        }); 
	$.ajax({
	    async : true,
	    complete : function () {
		    DiagnosArrSave(arr);
	        }
	});
}

//ҽ��������ݱ���
function DiagnosArrSave(arr)
{
	//��ȡ��������
	var ErrMsg = "";     //��������
    var errRowNums = 0;  //��������
    var sucRowNums = 0;  //����ɹ�������
	var rowCnt=arr.length
	var EmpDataNum = 0; //������
	 try{
		 for (i = 1; i < rowCnt; i++) 
		 {
			 var rowArr=arr[i];
			 var UpdateStr="^"+rowArr.join("^");
			 if(UpdateStr.split("^")[2]==""){
				EmpDataNum = EmpDataNum + 1;	 
			}else{
			 	var savecode=tkMakeServerCall("web.INSUDiagnosis","SaveDiag",UpdateStr)
                    if (savecode == null || savecode == undefined) savecode = -1
                    
                    if (savecode >= 0) {
                        sucRowNums = sucRowNums + 1;
                    } else {
                        errRowNums = errRowNums + 1;
                        if (ErrMsg == "") {
                            ErrMsg = i+":"+savecode;
                        } else {
                            ErrMsg = ErrMsg + "<br>" + i+":"+savecode;
                        }
                    }
			}
		 }
		 
		 if (ErrMsg == "") {
                    $.messager.progress("close");
                    $.messager.alert('��ʾ', '�������,����'+(rowCnt-1-EmpDataNum)+"��");
                } else {
                   $.messager.progress("close");
                     var tmpErrMsg = "����ɹ���"+sucRowNums-EmpDataNum +"����ʧ�ܣ�"+errRowNums-EmpDataNum+"����";
                     tmpErrMsg = tmpErrMsg + "<br>ʧ�������кţ�<br>"+ ErrMsg;
                    $.messager.alert('��ʾ', tmpErrMsg,'info');
                }
		      return ;
		 }
		 catch(ex)
		 {
			  $.messager.progress("close");
			  $.messager.alert('��ʾ', '����ҽ����������쳣��'+ex.message,'error')
	          return ;
	      }
	return ;
}

function SetValue(value)
{
	if(value == undefined)
	{
		value="" ;
	}
	value=value.toString().replace(/\"/g, "");
	value=value.toString().replace(/\?/g,"");
	return value;
}

//��ȡIP��ַ����1
//��ȡ����������IP��ַ����;�ָ
//����ʵ�Ŀͻ���
function GetLocalIPAddress()  
{  
    var obj = null;  
    var rslt = "";  
    try  
    {  
		//-------Zhan 20190521-------->
		if("undefined" != typeof ClientIPAddress){
			rslt=ClientIPAddress		
		}
		if(rslt!=""){return rslt};
		//<---------------------------//
        obj = new ActiveXObject("rcbdyctl.Setting");  
        rslt = obj.GetIPAddress;  
      	rslt=rslt.split(";")[0]
        obj = null;  
    }  
    catch(e)  
    {  
        //alert("�쳣��rcbdyctl.dll��̬��δע�ᣬ����ע��!")
        rslt="";
    } 
    return rslt
}
/// �س�
function Enter_KeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		Save();
	}
}
function selectHospCombHandle(){
	//$('#insuType').combobox('clear');
	$('#insuType').combogrid('grid').datagrid('reload');
	//$('#BSYType').combobox('clear');
	//Query();
}

/*
 * ��������ҽ����� 
 * +20230308 HanZH
 */
function addINSUDiagnosis() {
	//var InsuType = getValueById('tInsuType');
	var InsuType = $('#insuType').combogrid("getValue");	//WangXQ 20221102
	if(InsuType==""){
		$.messager.alert('��ʾ','ҽ�����Ͳ���Ϊ��','info');
		return;	
	}
	var url = "dhcinsu.diageditcom.csp?&Rowid="+"&HiType="+InsuType+"&HospId="+PUBLIC_CONSTANT.SESSION.HOSPID; 
	websys_showModal({
		url: url,
		title: "����-ҽ�����ά��",
		iconCls: "icon-w-edit",
		width: "740",
		height: "425",
		onClose: function () {
			Query();
		}   
	})
}

/*
 * �޸�ҽ����� 
 * +20230308 HanZH
 */
function  editINSUDiagnosis(rowIndex){
	//LocRowIndex=rowIndex;
   	var selected = $('#dg').datagrid('getSelected');
	var rowData = $('#dg').datagrid("getRows")[rowIndex]; //$('#dg').datagrid('fixColumnSize');  
	if (!selected&&!rowData) {
	   $.messager.alert("��ܰ��ʾ","��ѡ��һ��ҽ�����!", 'info');
	}
   	//initInItmFrm(rowIndex,rowData)
	var url = "dhcinsu.diageditcom.csp?&Rowid=" + rowData.INDISRowid+"&HiType="+rowData.HiType+"&HospId="+rowData.HospDr; 
	websys_showModal({
		url: url,
		title: "�޸�-ҽ�����ά��",
		iconCls: "icon-w-edit",
		width: "740",
		height: "425",
		onClose: function()
		{
			Query();
		}
	});
   
}
function  editINSUDiagnosis(){
	var selected = $('#dg').datagrid('getSelected');
	if (!selected) {
		$.messager.alert("��ܰ��ʾ","��ѡ��һ��ҽ������!", 'info');
	}
	var url = "dhcinsu.diageditcom.csp?&Rowid=" + selected.INDISRowid+"&HiType="+selected.HiType+"&HospId="+selected.HospDr; 
	websys_showModal({
		url: url,
		title: "�޸�-ҽ�����ά��",
		iconCls: "icon-w-edit",
		width: "740",
		height: "425",
		onClose: function()
		{
			Query();
		}
	});
}

