/**
 * ҽ�����ά��JS
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
	var dicurl=jsonQueryUrl+'web.INSUDicDataCom'+SplCode+"GetDicJSONInfo"+SplCode+"TariType^^"	//ArgSpl
	var diccombox=$('#insuType').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'INDIDDicCode',   
	    textField:'INDIDDicDesc', 
        rownumbers:true,
        fit: true,
        pagination: false,
        url:dicurl,
	    columns:[[   
	        {field:'INDIDDicCode',title:'����',width:60},  
	        {field:'INDIDDicDesc',title:'����',width:100}
	        
	    ]],
	    fitColumns: true,
	    onLoadSuccess:function(data){
			diccombox.combogrid('setValue',data.rows[0].INDIDDicCode)
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
			Desc: '��ҽԺICD��'
		},{
			Code: '3',
			Desc: '��ҽԺICD����'
		}]

	}); 

	//��ʼ�����յ�grid
	grid=$('#dg').datagrid({
		idField:'dgid',
		iconCls: 'icon-save',
		rownumbers:true,
		border:false,
		//width: 1000,
		//height: 580,
		fit:true,
		striped:true,
		fitColumns: true,
		singleSelect: true,
		frozenColumns:[[

		]],
		columns:[[
			{field:'INDISRowid',title:'Rowid',width:60,hidden:true},
			{field:'bztype',title:'ҽ������',width:60},
			{field:'bzbm',title:'��ϴ���',width:80},
			{field:'bzmc',title:'�������',width:260},
			{field:'srrj',title:'������',width:70},
			{field:'ActiveDate',title:'��Ч����',width:70,editor:'datebox'},
			{field:'Unique',title:'����Ψһ��',width:90,editor:'text'},
			{field:'jcbzbz',title:'���Ʒ�ʽ',width:60,editor:'text'},
			{field:'Cate',title:'��������',width:60,editor:'text'},
			{field:'SubCate',title:'����������',width:60,editor:'text'},
			{field:'srrjwb',title:'������2',width:65,hidden:true},
			{field:'Date',title:'��������',width:70},
			{field:'Time',title:'����ʱ��',width:60},
			{field:'UserDr',title:'����Ա',width:65},
			{field:'ADDIP',title:'����IP',width:80},

			{field:'XString01',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString02',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString03',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString04',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString05',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString06',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString07',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString08',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString09',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString10',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'}
		]],
		onClickRow:function(rowIndex, rowData) {
			return;
			//$('#windiv').hide();
			//ConAct("insertRow")
			//QueryINSUTarInfoNew(getEditRow(EditIndex,'INSUDigDesccon'),'INSUDigDesccon','3')
            //bgEditRow(rowIndex,rowData)
        },
		pageSize: 30,
		pagination:true,
        onSelect : function(rowIndex, rowData) {
	        if(dgselected==rowIndex){return}
	        dgselected=rowIndex
            //beginEdit(rowIndex,rowData)
        },
        onUnselect: function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
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
		HospDr : PUBLIC_CONSTANT.SESSION.HOSPID
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
function Edit(){
	rowIndex=dgselected
	if(rowIndex>=0)
	{
		if((undefined!=EditIndex)&(rowIndex!=EditIndex)){grid.datagrid('endEdit', EditIndex);}
		var editrow=grid.datagrid('getRows')[rowIndex];
		if((undefined==editrow["bztype"])||(""==editrow["bztype"])||(undefined==editrow['bzbm'])||(""==editrow['bzbm'])||(""==editrow['bzmc'])||(undefined==editrow['bzmc'])){
			$.messager.alert('��ʾ','�����ݲ��ܱ༭!');
			return;
		}
		grid.datagrid('beginEdit',rowIndex);
		EditIndex = rowIndex;
		return true
	}else{
		$.messager.alert('��ʾ','Ҫ��ѡ��һ�в��ܱ༭!');
	}
}
function SaveBak(){
	var Changes=$('#GrpInfoGV').datagrid("getChanges") ;
	if(Changes.length>0){
		var ret=SaveFun(Changes[Changes.length-1]);
		if(ret){
			$('#GrpInfoGV').datagrid("refreshRow",rowIndex)
			$('#GrpInfoGV').datagrid("acceptChanges") ;
			rowIndex=-1 ;
			return true ;
		}
		else{
			$('#GrpInfoGV').datagrid("rejectChanges") ;
			$('#GrpInfoGV').datagrid("deleteRow",rowIndex)
			rowIndex=-1 ;
			return false ;
		} 
	}
	rowIndex=-1 ;
}



//���±����¼
function Save(){
	//if(BDPAutDisableFlag('btnAdd')!=true){$.messager.alert('��ʾ','����Ȩ��,����ϵ����Ա��Ȩ!');return;}
	/*
	if(undefined==selInsuData.INDISRowid){
		$.messager.alert('��ʾ','��ѡ��һ����¼���ܶ���!');
		return;
	}
	
			{field:'INDISRowid',title:'Rowid',width:60,hidden:true},
			{field:'bztype',title:'ҽ������',width:60},
			{field:'bzbm',title:'��ϴ���',width:80},
			{field:'bzmc',title:'�������',width:200},
			{field:'srrj',title:'������',width:650},
			{field:'srrj2',title:'������2',width:65,hidden:true},
			{field:'jcbzbz',title:'���Ʒ�ʽ',width:60,editor:'text'},
			{field:'Cate',title:'��������',width:60,editor:'text'},
			{field:'SubCate',title:'����������',width:60,editor:'text'},
			{field:'Date',title:'��������',width:70},
			{field:'Time',title:'����ʱ��',width:60},
			{field:'UserDr',title:'����Ա',width:140},
			{field:'ADDIP',title:'����IP',width:140},
			{field:'ActiveDate',title:'��Ч����',width:140,editor:'datebox'},
			{field:'Unique',title:'����Ψһ��',width:140,editor:'text'},
			{field:'XString01',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString02',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString03',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString04',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString05',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString06',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString07',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString08',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString09',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'},
			{field:'XString10',title:'��չ�ֶ�',width:60,hidden:true,editor:'text'}
	
	*/
	if((undefined==EditIndex))
	{
		$.messager.alert('��ʾ','δ�༭���豣��!');
		return;
	}
	// tangzf 2019-6-2 ��ΪHISUI����
	var  rtn=$.messager.confirm('��ʾ',"��ȷ��Ҫ�޸���?",function(r){	
		if(r){
			grid.datagrid('acceptChanges');
			grid.datagrid('endEdit', EditIndex);
			grid.datagrid('updateRow',{index: EditIndex,row: {Date: GetToday(),Time: GetTimeNow(),ADDIP: IPAddress}});
			grid.datagrid('refreshRow',EditIndex)
			var editrow=grid.datagrid('getRows')[EditIndex];
			var userID=session['LOGON.USERID'];
			if((undefined==editrow['bztype'])||(""==editrow['bztype'])||(undefined==editrow['bzbm'])||(""==editrow['bzbm'])||(""==editrow['bzmc'])||(undefined==editrow['bzmc'])){
				$.messager.alert('��ʾ','��Ч���ݲ��ܱ���!');
				return;
			}
		
			//�����ַ�^�Ĵ���
			//editrow['INDISRowid']=editrow['INDISRowid'].replace(/\^/g,"");
			editrow['bztype']=editrow['bztype'].replace(/\^/g,"");
			editrow['bzmc']=editrow['bzmc'].replace(/\^/g,"");
			editrow['bzbm']=editrow['bzbm'].replace(/\^/g,"");
			editrow['srrj']=editrow['srrj'].replace(/\^/g,"");
			editrow['srrjwb']=editrow['srrjwb'].replace(/\^/g,"");
			editrow['jcbzbz']=editrow['jcbzbz'].replace(/\^/g,"");
			editrow['ActiveDate']=editrow['ActiveDate'].replace(/\^/g,"");
			editrow['Unique']=editrow['Unique'].replace(/\^/g,"");
			editrow['Cate']=editrow['Cate'].replace(/\^/g,"");
			editrow['SubCate']=editrow['SubCate'].replace(/\^/g,"");
		
			//������������JS��cspEscape()��������
			//var UpdateStr=editrow['INDISRowid']+"^"+editrow['bztype']+"^"+editrow['bzbm']+"^"+editrow['bzmc']+"^"+editrow['srrj']+"^"+editrow['srrjwb']+"^"+editrow['jcbzbz']+"^"+editrow['Cate']+"^"+editrow['SubCate']+"^^^"+userID+"^"+IPAddress+"^"+editrow['ActiveDate']+"^"+editrow['Unique']+"^^^^^^^^^^^";
			var UpdateStr=editrow['INDISRowid']+"^"+$('#insuType').combobox('getValue')+"^"+editrow['bzbm']+"^"+editrow['bzmc']+"^"+editrow['srrj']+"^"+editrow['srrjwb']+"^"+editrow['jcbzbz']+"^"+editrow['Cate']+"^"+editrow['SubCate']+"^^^"+userID+"^"+IPAddress+"^"+editrow['ActiveDate']+"^"+editrow['Unique']+"^^^^^^^^^^^";
			var savecode=tkMakeServerCall("web.INSUDiagnosis","SaveDiag",UpdateStr)
		
			if(savecode==null || savecode==undefined) savecode=-1
			if(eval(savecode)>=0){
				//$.messager.alert('��ʾ','����ɹ�');  
				//$.messager.alert('��ʾ','����ɹ�!');
				EditIndex=undefined;
				MSNShow('��ʾ','����ɹ���',2000)
			}else{
				EditIndex=-2;
				Edit();
				$.messager.alert('��ʾ','����ʧ��!');   
			}
		}else{
			grid.datagrid("rejectChanges") ;
		};
	})
}

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
            text: '�����У�����'+(rowCnt-1)+'��'
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
	 try{
		 for (i = 1; i < rowCnt; i++) 
		 {
			 var rowArr=arr[i]
			 var UpdateStr="^"+rowArr.join("^")
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
		 
		 if (ErrMsg == "") {
                    $.messager.progress("close");
                    $.messager.alert('��ʾ', '�������,����'+(rowCnt-1)+"��");
                } else {
                   $.messager.progress("close");
                     var tmpErrMsg = "����ɹ���"+sucRowNums +"����ʧ�ܣ�"+errRowNums+"����";
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