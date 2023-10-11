/*
 * FileName:	operlist.js
 * User:		Hanzh 
 * Date:		2021-12-03	
 * Description: ҽ������ά��
 */
 
var GUser=session['LOGON.USERID'];
var HospDr=session['LOGON.HOSPID'];
var PUBLIC_CONSTANT = {
	SESSION: {
		HOSPID: session['LOGON.HOSPID'],
	}
}

$(function(){
	initKeyTypes();
	InitInOperListDg();
	//�ؼ��ֻس��¼�
	$("#OprnOprtCode").keydown(function(e) { 
	  if (e.keyCode==13)
	  {
		QryInOperList();
	  }
	});  
	//�ؼ��ֻس��¼�
	$("#OprnOprtName").keydown(function(e) { 
	  if (e.keyCode==13)
	  {
		QryInOperList();
	  }
	});
	//�ؼ��ֻس��¼�  WangXQ 20221102
	$("#Pinyin").keydown(function(e) { 
	  if (e.keyCode==13)
	  {
		QryInOperList();
	  }
	});
	//���ڳ�ʼ��
	init_Date();
	//Ժ�ڰ汾�ų�ʼ�� 20230115
	init_HisVer()
});
function init_Date(){
	//InsuDateDefault('StartDate',"");
	//InsuDateDefault('EndDate',"");
	}
//���ز�ѯ����
function initKeyTypes() {
	/*$('#QryType').combobox({  
		width: 120, 
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '0',
			Desc: 'ȫ��',
			selected: true
		},{
			Code: '1',
			Desc: '����������'
		}]

	});*/
	//ҽ������
//	var diccombox = $('#tInsuType').combobox({
//		valueField: 'cCode',
//		textField: 'cDesc',
//		url: $URL,
//		onBeforeLoad: function (param) {
//			param.ClassName = 'web.INSUDicDataCom';
//			param.QueryName = 'QueryDic';
//			param.ResultSetType = 'array';
//			param.Type = 'TariType';
//			param.Code = '';
//			param.Hospital = PUBLIC_CONSTANT.SESSION.HOSPID;
//		},
//		loadFilter: function (data) {
//			for (var i in data) {
//				if (data[i].cDesc == 'ȫ��') {
//					data.splice(i, 1);
//				}
//			}
//			return data;
//		},
//		onSelect: function (rec) {
//			if(getValueById('tKeyWords')!=""){
//			  QryInOperList();
//			}
//		},
//		onChange: function (newValue, oldValue) {
//			if ((newValue != '') &&(getValueById('tKeyWords')!="")){
//				QryInOperList();
//			}
//		}
//	});
	var tinsutypecombox=$('#tInsuType').combogrid({  
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
		    tinsutypecombox.combogrid('setValue',data.rows[0].cCode);
		},
		onSelect:function(index,data){
		}
		
	}); 
}

//��ѯҽ������
function QryInOperList()
{
   var InRowid=""
   //var QryType=$('#QryType').datebox('getValue');
   var stdate=getValueById('StartDate');
   var endate=getValueById('EndDate');
   var key=getValueById('Pinyin'); //WangXQ 20221102
   var InsuType=$('#tInsuType').combobox("getValue");
   if(InsuType==""){
		$.messager.alert('��ʾ','ҽ�����Ͳ���Ϊ��','info');
		return;	
	}
   var OprnOprtCode=getValueById('OprnOprtCode');
   var OprnOprtName=getValueById('OprnOprtName');
   var HisVer=getValueById('HisVer');
   /*$('#tInOperList').datagrid('options').url=$URL;
   $('#tInOperList').datagrid('reload',{
	   ClassName:'INSU.MI.DTO.OPRNOPRTLIST',
	   QueryName:'QueryOPRNOPRTLISTNEW',
	   QryType:"",
	   StDate:stdate,
	   EndDate:endate,
	   HospId:PUBLIC_CONSTANT.SESSION.HOSPID,
	   HiType:InsuType,
	   Code:OprnOprtCode,
	   Desc:OprnOprtName,
	   HisBatch:"",
	   Ver:""
	   });*/
	  var queryParams = {
	   ClassName:'INSU.MI.DTO.OPRNOPRTLIST',
	   QueryName:'QueryOPRNOPRTLISTNEW',
	   QryType:"",
	   StDate:stdate,
	   EndDate:endate,
	   HospId:PUBLIC_CONSTANT.SESSION.HOSPID,
	   HiType:InsuType,
	   Code:OprnOprtCode,
	   Desc:OprnOprtName,
	   HisBatch:"",
	   Ver:"",
	   Key:key,
	   HisVer:HisVer
	}
	
	loadDataGridStore('tInOperList',queryParams);	
	   
	   
}
//��ʼ��ҽ������dg
function InitInOperListDg()
{
	//��ʼ��datagrid
   $HUI.datagrid("#tInOperList",{
	   //url:$URL,
	   fit: true,
	   width: '100%',
	   height:800,
	   border:false,
	   singleSelect: true,
	   rownumbers:true,
	   toolbar:'#dgTB',
	   data: [],
//	   frozenColumns:[[
//		 { 
//		   field:'TOpt',
//		   width:40,
//		   title:'����',
//		   align:'center',
//		   formatter: function (value, row, index) {
//					   
//			        return "<img class='myTooltip' style='width:60' title='�޸�' onclick=\"InOperListEditClick('" + index+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_pen.png' style='border:0px;cursor:pointer'>";
//					   
//				   }
//		 }
//	   
//	   ]],
	   columns:[[
		   {field:'Rowid',title:'Rowid',width:10,hidden:true},
		   {field:'HiType',title:'ҽ������',width:80,hidden:true},
		   {field:'HiTypeDesc',title:'ҽ������',width:80},
		   {field:'OprnOprtCode',title:'������������',width:120},
		   {field:'OprnOprtName',title:'������������',width:230},
		   {field:'Rid',title:'����Ψһ��¼��',width:120,hidden:true},
		   {field:'UsedStd',title:'ʹ�ñ��',width:80,
			formatter: function(value,row,index){
			   if (value=="1"){
				   return "��";
			   } else {
				   return "��";
			   }}
			   },
		   {field:'ValiFlag',title:'��Ч��־',width:80,
			formatter: function(value,row,index){
			   if (value=="1"){
				   return "��";
			   } else {
				   return "��";
			   }}
			   },
		   {field:'HisCrterId',title:'������',width:80,hidden:true},
		   {field:'HisCrterName',title:'������',width:80},
		   {field:'HisCrteDate',title:'��������',width:100},
		   {field:'HisCrteTIme',title:'����ʱ��',width:50,hidden:true},
		   {field:'HisVer',title:'�汾',width:180},
		   {field:'HisBatch',title:'��������',width:180},
		   {field:'HisUpdtId',title:'������',width:100,hidden:true},
		   {field:'HisUpdtName',title:'������',width:100},
		   {field:'HisUpdtDate',title:'��������',width:100},
		   {field:'HisupdtTime',title:'����ʱ��',width:100},
		   {field:'OprnStdListId',title:'������׼Ŀ¼ID',width:290,hidden:true},
		   {field:'Cpr',title:'��',width:30},
		   {field:'CprCodeScp',title:'�´��뷶Χ',width:80},
		   {field:'Cprname',title:'������',width:190},
		   {field:'CGyCode',title:'��Ŀ���� ',width:80},
		   {field:'CgyName',title:'��Ŀ����',width:130},
		   {field:'SorCode',title:'��Ŀ����',width:80},
		   {field:'SorName',title:'��Ŀ����',width:120},
		   {field:'DtlsCode',title:'ϸĿ����',width:80},
		   {field:'DtlsName',title:'ϸĿ����',width:210},
		   {field:'RtlOprnOprtCode',title:'�ű��������������',width:150},
		   {field:'RtlOprnOprtName',title:'�ű��������������',width:150},
		   {field:'ClncOprnOprtCode',title:'�ٴ���������������',width:150},
		   {field:'ClncOprnName',title:'�ٴ���������������',width:150},
		   {field:'Memo',title:'��ע',width:120},
		   {field:'CrteTime',title:'���ݴ���ʱ��',width:200},
		   {field:'UpdtTime',title:'���ݸ���ʱ��',width:200},
		   {field:'Ver',title:'ҽ���汾��',width:80},
		   {field:'VerName',title:'ҽ���汾����',width:200}

	   ]],
	   pageSize: 20,
	   pagination:true,
	   onClickRow : function(rowIndex, rowData) {
		   
		   //alert("rowData="+rowData.TRowid)   
		   //InLocRowid=rowData.TRowid;
		   //QryInLocRec();
		   
	   },
	   onDblClickRow:function(rowIndex, rowData){
		   InOperListEditClick(rowIndex);
		   },
	   onUnselect: function(rowIndex, rowData) {
		   //alert(rowIndex+"-"+rowData.itemid)
	   },
	   onLoadSuccess:function(data)
	   {
		   var index=0;
	   }
   }); 
}
					
function  InOperListEditClick(rowIndex){
	//LocRowIndex=rowIndex;
   	var selected = $('#tInOperList').datagrid('getSelected');
	var rowData = $('#tInOperList').datagrid("getRows")[rowIndex]; //$('#dg').datagrid('fixColumnSize');  
	if (!selected&&!rowData) {
	   $.messager.alert("��ܰ��ʾ","��ѡ��һ��ҽ������!", 'info');
	}
   	//initInItmFrm(rowIndex,rowData)
	var url = "dhcinsu.opereditcom.csp?&Rowid=" + rowData.Rowid+"&HiType="+rowData.HiType+"&HospId="+rowData.HospId; 
	websys_showModal({
		url: url,
		title: "�޸�-ҽ������ά��",
		iconCls: "icon-w-edit",
		width: "855",
		height: "530",
		onClose: function()
		{
		QryInOperList();
		}
	});
   
}
function  InOperListEditClick(){
	var selected = $('#tInOperList').datagrid('getSelected');
	if (!selected) {
		$.messager.alert("��ܰ��ʾ","��ѡ��һ��ҽ������!", 'info');
	 }
	var url = "dhcinsu.opereditcom.csp?&Rowid=" + selected.Rowid+"&HiType="+selected.HiType+"&HospId="+selected.HospId; 
	websys_showModal({
		url: url,
		title: "�޸�-ҽ������ά��",
		iconCls: "icon-w-edit",
		width: "855",
		height: "530",
		onClose: function()
		{
			QryInOperList();
		}
	});
}

//ҽ����������
function InItmEpot()
{
   try
   {
		var QryType="";
		var stdate=getValueById('StartDate');
		var endate=getValueById('EndDate');
		var InsuType=$('#tInsuType').combobox("getValue");
		if(InsuType==""){
			$.messager.alert('��ʾ','ҽ�����Ͳ���Ϊ��','info');
			return;	
		}
		var OprnOprtCode=getValueById('OprnOprtCode');
		var OprnOprtName=getValueById('OprnOprtName');
		var HisBatch="";
		var Ver="";
		window.open("websys.query.customisecolumn.csp?CONTEXT=KINSU.MI.DTO.OPRNOPRTLIST:QueryOPRNOPRTLISTNEW&PAGENAME=QueryOPRNOPRTLISTNEW"+"&QryType="+QryType+"&StDate="+stdate+"&EndDate="+stdate+"&HospId="+PUBLIC_CONSTANT.SESSION.HOSPID+"&HiType="+InsuType+"&Code="+OprnOprtCode+"&Desc="+OprnOprtName+"&HisBatch="+HisBatch+"&Ver="+Ver);
		$.messager.progress({
	         title: "��ʾ",
			 msg: '���ڵ���ҽ����������',
			 text: '������....'
			   });
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:"ҽ������",		  
			PageName:"QueryOPRNOPRTLISTNEW",      
			ClassName:"INSU.MI.DTO.OPRNOPRTLIST",
			QueryName:"QueryOPRNOPRTLISTNEW",
			QryType:QryType,
			StDate:stdate,
			EndDate:endate,
			HospId:PUBLIC_CONSTANT.SESSION.HOSPID,
			HiType:InsuType,
			Code:OprnOprtCode,
			Desc:OprnOprtName,
			HisBatch:HisBatch,
			Ver:Ver
		},function(){
			  setTimeout('$.messager.progress("close");', 3 * 1000);	
		});
	   
	   /*var InRowid=""
	   var KeyWords=$('#tKeyWords').val();
	   var KeyType=$('#tKeyType').combobox("getValue");
	   var InsuType=$('#tInsuType').combobox("getValue");	
	   var rtn = $cm({
	   dataType:'text',
	   ResultSetType:"Excel",
	   ExcelName:"ҽ����������", //Ĭ��DHCCExcel
	   ClassName:"web.INSUTarItemsCom",
	   QueryName:"QueryAll",
	   txt:KeyWords,
	   Class:KeyType,
	   Type:InsuType,
	   zfblTmp:""
		},false);
		location.href = rtn;
	   $.messager.progress({
				   title: "��ʾ",
				   msg: '���ڵ���ҽ����������',
				   text: '������....'
			   });
	   setTimeout('$.messager.progress("close");', 3 * 1000);	
		   
		   return;*/
   } catch(e) {
	   $.messager.alert("����",e.message);
	   $.messager.progress('close');
   }; 
}

//ҽ����������
function InItmImpt()
{
	var filePath=""
	var exec= '(function tst(){ var xlApp  = new ActiveXObject("Excel.Application");'
	           +'var fName=xlApp.GetOpenFilename("Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls");'
	           +'if (!fName){fName="";}'
	           +'xlApp.Quit();'
               +'xlSheet=null;'
               +'xlApp=null;'
	           +'return fName;}());'
	  CmdShell.notReturn = 0;
      var rs=CmdShell.EvalJs(exec);
      if(rs.msg == 'success'){
        filePath = rs.rtn;
        importItm(filePath);
      }else{
         $.messager.alert('��ʾ', '���ļ�����'+rs.msg,'error');
      }				   
}

function importItm(filePath)
{
    if (filePath == "") {
        $.messager.alert('��ʾ', '��ѡ���ļ���','info')
        return ;
    }
   $.messager.progress({
         title: "��ʾ",
         msg: 'ҽ������������',
         text: '���ݶ�ȡ��...'
        }); 
   $.ajax({
	async : true,
	complete : function () {
    ReadItmExcel(filePath);
	}
	});
  
}
//��ȡExcel����
function ReadItmExcel(filePath)
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
            msg: 'ҽ����������',
            text: '�����У�����'+(rowCnt-1)+'��'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}
//ҽ���������ݱ���
function ItmArrSave(arr)
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
			 var savecode = tkMakeServerCall("INSU.MI.DTO.OPRNOPRTLIST", "SaveInsuOper",   UpdateStr)
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
                    $.messager.alert('��ʾ', '�������,����'+(rowCnt-1-errRowNums)+"��");
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
			  $.messager.alert('��ʾ', '����ҽ�����������쳣��'+ex.message,'error')
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
/*
 * ����ҽԺԺ��combogrid
 * tangzf 2019-7-18
 */
function selectHospCombHandle(){
	//$('#tInsuType').combobox('clear');
	$('#tInsuType').combobox('reload');
	//QryInOperList();	
}
/*
 * ��������ҽ������
 * tangzf 2019-7-18
 */
function addINSUTarItems() {
	//var InsuType = getValueById('tInsuType');
	var InsuType = $('#tInsuType').combogrid("getValue");	//WangXQ 20221102
	if(InsuType==""){
		$.messager.alert('��ʾ','ҽ�����Ͳ���Ϊ��','info');
		return;	
	}
	var url = "dhcinsu.opereditcom.csp?&Rowid="+"&HiType="+InsuType+"&HospId="+PUBLIC_CONSTANT.SESSION.HOSPID; 
	websys_showModal({
		url: url,
		title: "����-ҽ������ά��",
		iconCls: "icon-w-edit",
		width: "855",
		height: "530",
		onClose: function () {
			QryInOperList();
		}   
	})
}

/*
 *�汾
 */
 function init_HisVer(){	
	//�����б�
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
	      	param.type='User.ORCOperation';
	      	param.IsInsuFlag='Y';
	      	param.ResultSetType = 'array';
	      	return true;

		},
		onSelect: function (data) {
		}
	});	
}


