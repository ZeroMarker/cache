/*
 * FileName:	priceruleconarc.js
 * User:		tanfb
 * Date:		2023-01-05
 * Function:	
 * Description: �������ҽ����Ŀ
 */

var GV = {
	SELECTEDINDEX : -1,
	EDITINDEX : -1,
	RuleId : -1,
}

$(function () {
	 
	init_hospital() //��ʼ��ҽԺ������ 
	init_dg();  //��ʼ��������
	initLoadGrid();  //�������������
	init_dg1();  //��ʼ���շ���Ŀ���
	initLoadGrid1(); //�շ���Ŀ����������
	setValueById('ActiveEndDate',"9999-12-31");	
});
	
//�س���ѯ�¼�
$("#search").keydown(function (e) {
	var key = websys_getKey(e);
	if (key == 13) {
		initLoadGrid();
	}
});	

//�س���ѯ�¼�
$("#searchi").keydown(function (e) {
	var keycode = getValueById('searchi')
	var key = websys_getKey(e);
	if (key == 13) {
		initLoadGrid1(keycode,"");
	}
});	

//��ʼ��������
function init_dg() {
	var dgColumns = [[
	        {field:'ROWID',title:'ROWID',width:70,hidden:true},
			{field:'RuleCode',title:'�������',width:70, editor: {
					type: 'text'}},
			{field:'RuleDesc',title:'��������',width:100, editor: {
					type: 'text'}},
			{field:'Priority',title:'�������ȼ�',width:90, editor: {
					type: 'text'}},
			{field:'AllowAddDesc',title:'�Ƿ��������',width:100, editor: {
					type: 'combobox',
					options: {
						valueField: 'DicCode',
						textField: 'DicDesc',
						editable:false,
						url: $URL,
						onBeforeLoad:function(param){
							param.ClassName = "BILL.CFG.COM.DictionaryCtl";
		                    param.QueryName = "QueryDicDataInfo";
		                    param.Type = "YesOrNo";
		                    param.KeyCode="";
		                    param.ResultSetType = 'array';
						},
					}
					}},
			{field:'ActiveStartDate',title:'��Ч����',width:120, editor: {
					type: 'datebox'}},
			{field:'ActiveEndDate',title:'ʧЧ����',width:120, editor: {
					type: 'datebox'}},
			{field:'RuleTypeDesc',title:'��������',width:100, editor: {
					type: 'combobox',
					options: {
						valueField: 'DicCode',
						textField: 'DicDesc',
						editable:false,
						url: $URL,
						onBeforeLoad:function(param){
							param.ClassName = "BILL.CFG.COM.DictionaryCtl";
		                    param.QueryName = "QueryDicDataInfo";
		                    param.Type = "PriceManageRuleType";
		                    param.KeyCode="";
		                    param.ResultSetType = 'array';
						},
					}
					}},
			{field:'Rate',title:'�������',width:70,align:'right',editor: {
					type: 'text'}},
			{field:'Amt',title:'������',width:70,align:'right',editor: {
					type: 'text'}},
			{field:'Memo',title:'��ע',width:90, editor: {
					type: 'text'}},					
			{field:'AllowAddCode',title:'AllowAddCode',width:150,hidden:true, editor: {
					type: 'text'}},
			{field:'RuleTypeCode',title:'RuleTypeCode',width:150,hidden:true, editor: {
					type: 'text'}},
		]];

	$('#ruletable').datagrid({
		fit: true,
		fitColumns:false,
		border: false,
		striped: false,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		columns: dgColumns,
		toolbar: '#rToolBar',
		onLoadSuccess:function(data){
		},
		onSelect:function(index,rowData){
			GV.RuleId = rowData.ROWID,
			initLoadGrid1("",GV.RuleId)
		},
		onUnselect:function(index,rowData){
		}
	});
}


//��ʼ��ҽ����Ŀ���
function init_dg1() {
	var dgColumns = [[
	        {title: 'ѡ��', field: 'CheckOrd',checkbox:true, width: 50,showTip:true},
	        {field:'RuleId',title:'����ָ��',width:70,hidden:true,editor: {
					type: 'text'}},
			{field:'TarItemId',title:'ҽ����ָ��',width:90,hidden:true,editor: {
					type: 'text'}},
			{field:'TarItemCode',title:'ҽ�������',width:90, editor: {
					type: 'text'}},
			{field:'TarItemDesc',title:'ҽ��������',width:100,editor: {
					type: 'combobox',
					options: {
						panelHeight: 200,
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLFIND&QueryName=FindArcItm&ResultSetType=array',
						mode: 'remote',
						method: 'get',
						delay: 500,
						blurValidValue: true,
						valueField: 'TArcRowid',
						textField: 'TArcDesc',
						onBeforeLoad: function (param) {
							if (!param.q) {
								return false;
							}
							$.extend(param, {
								ArcAlias: param.q,                           
								ArcCode: "",                          
								OrderCat: "",                    
								ArcDesc: "", 
								ArcItemcat: "",              
								HospID: getValueById('hospital')  
							});
							return true;
					 	},
					 	onLoadSuccess: function(data) {
		                },
						onSelect: function (data) {
							var ed = $('#ConarcTable').datagrid('getEditor', {index:GV.EDITINDEX,field:'TarItemCode'});
							ed.target[0].value = data.TArcCode;
							var ed = $('#ConarcTable').datagrid('getEditor', {index:GV.EDITINDEX,field:'TarItemId'});
							ed.target[0].value = data.TArcRowid;
						}	
					}
				}},
			{field:'ActiveStartDate',title:'��Ч����',width:100, editor: {
					type: 'datebox'}},
			{field:'ActiveEndDate',title:'ʧЧ����',width:100, editor: {
					type: 'datebox'}},
			{field:'Rate',title:'��������',width:120,align:'right',editor: {
					type: 'text'}},
			{field:'Amt',title:'�������',width:120,align:'right',editor: {
					type: 'text'}},
			{field:'HospId',title:'Ժ��ָ��',width:120,hidden:true,editor: {
					type: 'text'}},
			{field:'AuditStatus',title:'��˱�־',width:120,},
			{field:'AuditUser',title:'�����',width:120,},
			{field:'AuditDate',title:'�������',width:120,},
			{field:'AuditTime',title:'���ʱ��',width:120,},
			{field:'Memo',title:'��˱�ע',width:120,},
			{field:'ItemType',title:'��Ŀ����',width:120,},		
			{field:'ROWID',title:'ROWID',width:150,hidden:true}
		]];

	$('#ConarcTable').datagrid({
		fit: true,
		fitColumns:false,
		border: false,
		striped: false,
		singleSelect: false, //����Ϊ true����ֻ����ѡ��һ�С�
		checkOnSelect:true,// true�����û����ĳһ��ʱ�����ѡ��/ȡ��ѡ�и�ѡ�� false ʱ��ֻ�е��û�����˸�ѡ��ʱ���Ż�ѡ��/ȡ��ѡ�и�ѡ��
		selectOnCheck:false,// true�������ѡ�򽫻�ѡ�и��С� false��ѡ�и��н�����ѡ�и�ѡ��
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		columns: dgColumns,
		toolbar: '#aToolBar',
		onLoadSuccess:function(data){
			GV.SELECTEDINDEX = -1;
			GV.EDITINDEX = -1;
		},
		onSelect:function(index,rowData){
			GV.SELECTEDINDEX = index;
		},
		onUnselect:function(index,rowData){
			GV.SELECTEDINDEX = -1;
		},
		onDblClickRow:function(index,rowData){
			GV.SELECTEDINDEX = index;
			UpdateItm();
		},
		onEndEdit:function(index,rowData,changes){
			$('#ConarcTable').datagrid('checkRow', index);
		}
	});
}



//�������������
function initLoadGrid(){
    var queryParams = {
	    ClassName : 'BILL.CFG.COM.BL.PriceRuleCtl',
	    QueryName : 'QueryInfo',
	    HospID : getValueById('hospital'),
	    KeyCode : getValueById('search'),   
	}	
    loadDataGridStore('ruletable',queryParams);
	
}


//�շ���Ŀ����������
function initLoadGrid1(KeyCode,rule){
	var queryParams = {
	    ClassName : 'BILL.CFG.COM.BL.PriceRuleConItmCtl',
	    QueryName : 'QueryInfo',
	    KeyCode : KeyCode,
	    rule : GV.RuleId,
	    type : 'ҽ����',
	}	
    loadDataGridStore('ConarcTable',queryParams);
	
}


//�����ѯ
function FindRule(){
	initLoadGrid();
}

//ҽ����Ŀ��ѯ
function FindItm(KeyCode,rule){
	var KeyCode = getValueById('searchi');
	initLoadGrid1(KeyCode,GV.RuleId);
}

//ҽ����Ŀ����
function AddItm(){
	if(GV.SELECTEDINDEX > -1 && GV.EDITINDEX !=-1){
		$.messager.alert('��ʾ','ֻ�ܲ���һ������','info');
		return;		
	}
	if(GV.RuleId == -1 ){
		$.messager.alert('��ʾ','δѡ�����,�޷�����','info');
		return;		
	}	
	$('#ConarcTable').datagrid('insertRow',{
		index: 0,	// index start with 0
		row: {
			ROWID:'',
			RuleId: GV.RuleId,
			TarItemCode: '',
			TarItemDesc: '',
			ActiveStartDate: getValueById('ActiveStartDate'),
			ActiveEndDate: getValueById('ActiveEndDate'),
			Rate: '',
			Amt: '',
			HospId: getValueById('hospital'),
			AuditStatus: '',
			AuditUser: '',
			AuditDate: '',
			AuditTime: '',
			Memo: '',
			ItemType: 'ҽ����',			
		}
	});
	$('#ConarcTable').datagrid('beginEdit', 0);
	$('#ConarcTable').datagrid('checkRow', 0);
	GV.SELECTEDINDEX = 0;
	GV.EDITINDEX = 0;
}

//ҽ����Ŀ�޸�
function UpdateItm(){
	$('#ConarcTable').datagrid('endEdit', GV.EDITINDEX);
	if(GV.SELECTEDINDEX < 0){
		$.messager.alert('��ʾ','��ѡ��һ������','info');
		return;		
	}
	$('#ConarcTable').datagrid('beginEdit', GV.SELECTEDINDEX);
	GV.EDITINDEX = GV.SELECTEDINDEX;

}

//ҽ����Ŀ����
function SaveItm(){
	try{
		$('#ConarcTable').datagrid('acceptChanges');
		var row = $('#ConarcTable').datagrid('getChecked')
			if (row.length==0)
			{
				$.messager.alert('��ʾ','�빴ѡ��Ҫ����ļ�¼��','info');
				return;
			}
		for (var i=0;i<row.length;i++){
				var selRow = row[i];
				if(selRow.TarItemDesc == ''){
					$.messager.alert('����','�շ������Ʋ���Ϊ��','error');
			        $('#ConarcTable').datagrid('beginEdit', GV.EDITINDEX);
			        return;
			    }
			    if(selRow.ActiveStartDate == ''){
			        $.messager.alert('����','��Ч���ڲ���Ϊ��','error');
			        $('#ConarcTable').datagrid('beginEdit', GV.EDITINDEX);
			        return;
			    }
			    if(selRow.ActiveEndDate == ''){
			        $.messager.alert('����','ʧЧ���ڲ���Ϊ��','error');
			        $('#ConarcTable').datagrid('beginEdit', GV.EDITINDEX);
			        return;
			    }
		        //var tmpStDate = tkMakeServerCall("websys.Conversions", "DateHtmlToLogical", selRow.ActiveStartDate);
		        //var tmpEndDate = tkMakeServerCall("websys.Conversions", "DateHtmlToLogical", selRow.ActiveEndDate);
		        if(selRow.ActiveStartDate > selRow.ActiveEndDate){
			        $.messager.alert('����','��Ч���ڲ��ܴ���ʧЧ����','error');
			        $('#ConarcTable').datagrid('beginEdit', GV.EDITINDEX);
			        return;
		        }
		        if(selRow.Rate == '' && selRow.Amt == ''){
			        $.messager.alert('����','���������͵�������ͬʱΪ��','error');
		            return;		
     			}
		        var inputStr = selRow.ROWID + "^" + selRow.TarItemId + "^" + selRow.RuleId + "^" + selRow.ActiveStartDate + "^" + selRow.ActiveEndDate + "^" + selRow.Rate + "^" + selRow.Amt
		        var inputStr = inputStr + "^" + selRow.HospId + "^" + selRow.AuditStatus + "^" + selRow.AuditUser + "^" + selRow.AuditDate + "^" + selRow.AuditTime + "^" + selRow.Memo + "^" + selRow.ItemType   
		        var rtn=tkMakeServerCall("BILL.CFG.COM.BL.PriceRuleConItmCtl", "Save", inputStr);
		        if(rtn < "0"){
			        $.messager.alert('��ʾ', "ҽ��������Ϊ��" + selRow.TarItemDesc + "�����ݱ���ʧ��:" + rtn.split('^')[1], 'error');
			        initLoadGrid1();
			    }else{
				    $.messager.alert('��ʾ', "����ɹ�", 'info');	
			    }
		}	
		initLoadGrid1();
	}catch(e){
	}
}

//ͣ��ҽ����Ŀ
function StopItm(){
	if(GV.SELECTEDINDEX < 0){
		$.messager.alert('��ʾ','��ѡ��Ҫͣ�õļ�¼','info');
		return;		
	}
	try{
		$.messager.confirm("��ʾ", "�Ƿ�ͣ�ã�", function (r) { // prompt �˴���Ҫ����Ϊ��������
	if (r) {
		//ͣ��ҽ����
		$('#ConarcTable').datagrid('updateRow',{
               index:GV.SELECTEDINDEX,
               row: {
	               ActiveEndDate: getDefStDate(0),
               }
        });
        var selRow = $('#ConarcTable').datagrid('getSelected')	
		var inputStr = selRow.ROWID + "^" + selRow.TarItemId + "^" + selRow.RuleId + "^" + selRow.ActiveStartDate + "^" + selRow.ActiveEndDate + "^" + selRow.Rate + "^" + selRow.Amt
		        var inputStr = inputStr + "^" + selRow.HospId + "^" + selRow.AuditStatus + "^" + selRow.AuditUser + "^" + selRow.AuditDate + "^" + selRow.AuditTime + "^" + selRow.Memo + "^" + selRow.ItemType   
		        var rtn=tkMakeServerCall("BILL.CFG.COM.BL.PriceRuleConItmCtl", "Save", inputStr);
		        if(rtn < "0"){
			        $.messager.alert('��ʾ', "ͣ��ʧ��:" + rtn.split('^')[1], 'error');
			        initLoadGrid1();
			    }else{
				    $.messager.alert('��ʾ', "ͣ�óɹ�", 'info');
				    initLoadGrid1();	
			    }
			} else {
		return false;
	}
	})
	}catch(e){
	}
	
}

//�������ҽ�����
function Export()
{
   try
   {
		$.messager.progress({
	         title: "��ʾ",
			 msg: '���ڵ����������ҽ����',
			 text: '������....'
			   });
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:"�������ҽ����Ŀ��",		  
			PageName:"QueryInfo",      
			ClassName:"BILL.CFG.COM.BL.PriceRuleConItmCtl",
			QueryName: 'QueryInfo',
			rule: GV.RuleId,
			type : "ҽ����" ,
	        KeyCode : getValueById('searchi'),
		},function(date){
			  setTimeout('$.messager.progress("close");', 3 * 1000);	
		});
		
   } catch(e) {
	   $.messager.alert("����",e.message);
	   $.messager.progress('close');
   }; 
}

//�������ҽ����Ŀ����
function Import()
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
         msg: '�������ҽ����Ŀ����',
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
            msg: '�������ҽ����Ŀ����',
            text: '�����У�����'+(rowCnt-1)+'��'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}

//�������ݱ���
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
			 var ROWID=rowArr[0]
			 var TarItemId=rowArr[1]
			 var TarItemCode=rowArr[2]
			 var TarItemDesc=rowArr[3]
			 var RuleId=rowArr[4]
			 var RuleDesc=rowArr[5]
			 var ActiveStartDate=rowArr[6]
			 var ActiveEndDate=rowArr[7]
			 var Rate=rowArr[8]
			 var Amt=rowArr[9]
			 var HospId=rowArr[10]
			 var AuditStatus=rowArr[11]
			 var AuditUser=rowArr[12]
			 var AuditDate=rowArr[13]
			 var AuditTime=rowArr[14]
			 var Memo=rowArr[15]
			 var ItemType=rowArr[16]
			 var inputStr = ROWID + "^" + TarItemId + "^" + RuleId + "^" + ActiveStartDate + "^" + ActiveEndDate + "^" + Rate + "^" + Amt
		     var inputStr = inputStr + "^" + HospId + "^" + AuditStatus + "^" + AuditUser + "^" + AuditDate + "^" + AuditTime + "^" + Memo + "^" + ItemType   
		     var rtn=tkMakeServerCall("BILL.CFG.COM.BL.PriceRuleConItmCtl", "Save", inputStr);
                    if (rtn == null || rtn == undefined) rtn = -1                    
                    if (rtn >= 0) {
                        sucRowNums = sucRowNums + 1;
                    } else {
                        errRowNums = errRowNums + 1;
                        if (ErrMsg == "") {
                            ErrMsg = i+":"+rtn;
                        } else {
                            ErrMsg = ErrMsg + "<br>" + i+":"+rtn;
                        }
                    }
		 }
		 
		 if (ErrMsg == "") {
                    $.messager.progress("close");
                    $.messager.alert('��ʾ', '������ȷ�������');
                } else {
                   $.messager.progress("close");
                     var tmpErrMsg = "����ɹ���"+sucRowNums +"����ʧ�ܣ�"+errRowNums+"����";
                     tmpErrMsg = tmpErrMsg + "<br>ʧ�������кţ�<br>"+ ErrMsg;
                    $.messager.alert('��ʾ', tmpErrMsg,'info');
                }
              initLoadGrid1();
		      return ;
		 }
		 catch(ex)
		 {
			  $.messager.progress("close");
			  $.messager.alert('��ʾ', '����������ҽ����Ŀ�������쳣��'+ex.message,'error')
	          return ;
	      }
  return ;
	
}

//��ʼ��ҽԺ������
function init_hospital() {
	var tableName = "CF_BILL_COM.PriceRuleConItm";
	var defHospId = session['LOGON.HOSPID'];
	var SessionStr = session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.LOCID'] + "^" + defHospId; // �û�ID^��ȫ��ID^����ID^��ǰ��¼ҽԺID
	$("#hospital").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName + '&SessionStr=' + SessionStr,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			initLoadGrid()
		}
	});
}


//�ж��ĸ���ť����
$('.hisui-linkbutton').bind('click',function(){
	 switch (this.id){ 
	    case "btnFind" : // ��ѯ����
	            FindRule();	         
	    	break;
	    case "aBtnAdd" : // �շ���Ŀ����
	            AddItm();	         
	    	break;
	    case "aBtnUpdate" : // �շ���Ŀ�޸�
	            UpdateItm();	         
	    	break;
	    case "aBtnSave" : // �շ���Ŀ����
	           SaveItm();	         
	    	break;
	    case "aBtnStop" : // �շ���Ŀ����
	           StopItm();	         
	    	break;
	    case "btnFindItm" : // ��ѯ�շ���Ŀ
	           FindItm();	         
	    	break;	    	
	    default :
	    	break;
	    }
		
}) 
