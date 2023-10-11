/**
 * ���ݺ˲�������ά��
 * FileName: dhcbill\dc\errdic.js
 * tangzf 2022-05-11
 */
 var GV = {
	CLASSNAME:"BILL.COM.BL.ErrDicCtl"	 
}
//ȫ�ֱ���
var selRowid="";
var seldictype = ""; 
var tmpselRow = -1;
$(function(){
	var tableName = "User.INSUTarContrast";
	var defHospId = session['LOGON.HOSPID'];//2;//
	$("#hospital").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			Querydic();
		}
	});
	//��ʼ��datagrid
	$HUI.datagrid("#dg",{
		data:[],
		fit: true,
		//idField:'dgid',
		rownumbers:true,
		width: '100%',
		striped:true,
		fitColumns:false,
		singleSelect: true,
		autoRowHeight:false,
		toolbar:'#toolbar',
		columns:[[
		// ErrCode,ErrDefaultDesc,ErrConfig,Demo,RuleInfo,ActiveFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid
			{field:'ErrCode',title:'��ʾ����',width:120},
			{field:'ErrDefaultDesc',title:'Ĭ����ʾ����',width:300},
			{field:'ProductLine',title:'��Ʒ��',width:120,
			formatter: function (value, row, index) {
				var rtn = tkMakeServerCall("BILL.CFG.COM.DictionaryCtl","GetDicInfoByTypeCode","ProductLine", value, getValueById('hospital'),"4");
				return rtn;
			}},
			{field:'ProductModule',title:'��Ʒģ��',width:120,
			formatter: function (value, row, index) {
				var rtn = tkMakeServerCall("BILL.CFG.COM.DictionaryCtl","GetDicInfoByTypeCode","ProductModule", value, getValueById('hospital'),"4");
				return rtn;
			}},
			{field:'ErrConfig',title:'��ʾ��ʽ',width:200},
			{field:'ErrType',title:'��ʾ����',width:200,
			formatter: function (value, row, index) {
				return (value == "SYS") ? "<font color='#21ba45'>ϵͳ</font>" : "<font color='#f16e57'>�Զ���</font>";;
			}},
			{field:'Demo',title:'��ע',width:180},
			{field:'RuleInfo',title:'��ϸ����',width:120},
			{field:'ActiveFlag',title:'�Ƿ�����',width:90,
			formatter: function (value, row, index) {
				return (value == "Y") ? "<font color='#21ba45'>��</font>" : "<font color='#f16e57'>��</font>";
			}},
			{field:'HospDr',title:'Ժ��',width:50,hidden:true},
			{field:'CRTER',title:'������',width:50,hidden:true},
			{field:'CRTEDATE',title:'��������',width:50,hidden:true},
			{field:'CRTETIME',title:'����ʱ��',width:50,hidden:true},
			{field:'UPDTID',title:'������',width:50,hidden:true},
			{field:'UPDTDATE',title:'��������',width:50,hidden:true},
			{field:'UPDTTIME',title:'����ʱ��',width:50,hidden:true},
			{field:'Rowid',title:'Rowid',width:10,hidden:true}
		]],
		pageSize: 30,
		pagination:true,
        onClickRow : function(rowIndex, rowData) {
	        if(tmpselRow==rowIndex){
		        clearform("")
		        tmpselRow=-1
		        $(this).datagrid('unselectRow',rowIndex)
		    }else{
			    $('#ErrCode').attr("disabled",true);
			    fillform(rowIndex,rowData)
			    tmpselRow=rowIndex
			}
            
        },
        onUnselect: function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        }
	});
	
	
	//�ǼǺŻس���ѯ�¼�
	$("#dicKey").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			Querydic();
		}
	});
	//Querydic();
	
	init_ActiveFlagCB();
	init_TableNameCB();
	init_PropertyCB();
	init_ProductLine();
	init_BusinessType();
	init_ErrType();

});
function init_ErrType(){
	$HUI.combobox("#ErrType", {
		panelHeight: 150,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		data:[{DicCode:"SYS",DicDesc:"ϵͳ"},{DicCode:"User",DicDesc:"�Զ���"}],
		onSelect: function (data) {
		}
	});
}
function init_ProductLine(){
	$HUI.combobox("#ProductLine", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = "QueryDicDataInfo";
			param.Type="ProductLine";
			param.ResultSetType = 'array';
			return true;
		},
		onSelect: function (data) {
		}
	});
	$HUI.combobox("#QProductLine", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = "QueryDicDataInfo";
			param.Type="ProductLine";
			param.ResultSetType = 'array';
			return true;
		},
		onSelect: function (data) {
		},
		onChange:function(newValue, oldValue){
			Querydic();	
		}
	});		
}
function init_BusinessType(){
	$HUI.combobox("#ProductModule", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = "QueryDicDataInfo";
			param.Type="ProductModule";
			param.ResultSetType = 'array';
			return true;
		},
		onSelect: function (data) {
			var rtn = getValueById('ProductLine') + data.DicCode;
			setValueById('ErrCode',rtn);
		}
	});
	$HUI.combobox("#QModule", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = "QueryDicDataInfo";
			param.Type="ProductModule";
			param.ResultSetType = 'array';
			return true;
		},
		onSelect: function (data) {
		},
		onChange:function(newValue, oldValue){
			Querydic();	
		}
	});	
}
//����
function init_TableNameCB(){
	$HUI.combobox("#TableName", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.Common";
			param.QueryName = "QueryClass";
			param.KeyCode="";
			param.ResultSetType = 'array';
			return true;
		},
		onSelect: function (data) {
			$('#Property').combobox('reload');
		}
	});
}
//�ֶ�
function init_PropertyCB(){
	$HUI.combobox("#Property", {
		panelHeight: 150,
		url: $URL,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.Common";
			param.QueryName = "QueryProperty";
			param.ClsInfo = getValueById('TableName');
			param.keyCode="";
			param.ResultSetType = 'array';
			return true;
		},
		onSelect: function (data) {
			var tmpStr= "{" + getValueById('TableName') + "||" + data.DicCode + "}";
			setValueById('ClassProperty',tmpStr)
		}
	});
}
//��Ч��־
function init_ActiveFlagCB(){
	$HUI.combobox("#ActiveFlag", {
			panelHeight: 150,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		data:[{DicCode:"Y",DicDesc:"��"},{DicCode:"N",DicDesc:"��"}],
		onSelect: function (data) {
		}
	});
}
//��ѯ�ֵ�����
function Querydic(){
	$("#dg").datagrid('unselectAll')
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	var QueryParam={
		ClassName: GV.CLASSNAME,
		QueryName: 'QueryInfo',
		HospID : getValueById("hospital"),
		KeyCode:getValueById('dicKey'),
		QProductLine:getValueById("QProductLine"),
		QProductModule:getValueById("QModule")
	}
	loadDataGridStore('dg',QueryParam);
	
}
//�����ַ�����
function SplVCFormat(FStr)
{
	return  FStr.replace(/\^/g,"");
}

//���±����¼
function UpdateDic(){
	var ErrCode = getValueById('ErrCode');
	if(ErrCode==""){
		$.messager.alert('��ʾ','�쳣���벻��Ϊ��','error');
		return;	
	}
	var ErrDefaultDesc = getValueById('ErrDefaultDesc');
	var ErrConfig = getValueById('ErrConfig');
	var Demo = getValueById('Demo');
	var RuleInfo = getValueById('RuleInfo');
	var ActiveFlag = getValueById('ActiveFlag');
	var HospDr =getValueById("hospital");
	var Rowid = getValueById('Rowid');
	var ProductLine = getValueById('ProductLine');
	var ProductModule = getValueById('ProductModule');
	var ErrType = getValueById('ErrType');
	selRowid = selRowid<0?"":selRowid;
	var saveinfo=selRowid+"^"+ErrCode+"^"+ErrDefaultDesc+"^"+ErrConfig+"^"+Demo+"^"+RuleInfo+"^"+ActiveFlag+"^"+HospDr;
	saveinfo = saveinfo + "^^^^^^^" + ProductLine + "^" + ProductModule + "^" + ErrType;
	saveinfo=saveinfo.replace(/��������Ϣ/g,"")
	///alert(saveinfo)
	var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
	if(savecode.split('^')[0]>0){
		//$.messager.alert('��ʾ','����ɹ�!');  
		Querydic();
		clearform("")
		$.messager.alert('��ʾ','����ɹ�!','info');   
	}else{
		$.messager.alert('��ʾ','����ʧ��!rtn=' + savecode,'info');   
	}
}
//ɾ����¼
function DelDic(){
	if(selRowid=="" || selRowid<0 || !selRowid){$.messager.alert('��ʾ','��ѡ��Ҫɾ���ļ�¼!','info');return;}
	$.messager.confirm('��ȷ��','��ȷ��Ҫɾ��������¼��?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall(GV.CLASSNAME,"Delete",selRowid)
			if(eval(savecode)==0){
				$.messager.alert('��ʾ','ɾ���ɹ�!','info');   
				$("#dg").datagrid('reload')
				selRowid="";
				$("#dg").datagrid("getPager").pagination('refresh');
				$("#dg").datagrid('unselectAll')
			}else{
				$.messager.alert('��ʾ','ɾ��ʧ��!','info');   
			}
		}else{
			return;	
		}
	});
}
//����±ߵ�form
function fillform(rowIndex,rowData){
	selRowid=rowData.Rowid
	setValueById('ErrCode',rowData.ErrCode);
	setValueById('ErrDefaultDesc',rowData.ErrDefaultDesc);
	setValueById('ErrConfig',rowData.ErrConfig);
	setValueById('Demo',rowData.Demo);
	setValueById('RuleInfo',rowData.RuleInfo);
	setValueById('ActiveFlag',rowData.ActiveFlag);
	setValueById('HospDr',rowData.HospDr);
	setValueById('ProductModule',rowData.ProductModule);
	setValueById('ProductLine',rowData.ProductLine);
	setValueById('ErrType',rowData.ErrType);
	
}
//����±ߵ�form
function clearform(inArgs){
	$('#ErrCode').attr("disabled",false);
	$('.editinfo input').each(function(){        
		$(this).val(inArgs)
	})
	selRowid="";
}
//��������form
function ClearQ(inArgs){
	setValueById('QProductLine','');
	setValueById('dicKey','');
	setValueById('QModule','');
}
//�쳣�����ֵ䵼��
function Export()
{
   try
   {
	   var KeyCodeValue=getValueById('dicKey')
		//window.open("websys.query.customisecolumn.csp?CONTEXT=KBILL.DC.BL.DicDataCtl:QueryInfo&PAGENAME=QueryInfo&HospID="+PUBLIC_CONSTANT.SESSION.HOSPID+"&KeyCode="+KeyCodeValue+"&PDicType="+$('#diccbx').combobox('getValue')==""?"SYS":$('#diccbx').combobox('getValue'));
		$.messager.progress({
	         title: "��ʾ",
			 msg: '���ڵ����쳣�����ֵ�',
			 text: '������....'
			   });
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:"�쳣�����ֵ�",		  
			PageName:"QueryInfo",      
			ClassName: GV.CLASSNAME,
			QueryName: 'QueryInfo',
			HospID : getValueById("hospital"),
			KeyCode:KeyCodeValue
		},function(){
			  setTimeout('$.messager.progress("close");', 3 * 1000);	
		});
		
   } catch(e) {
	   $.messager.alert("����",e.message);
	   $.messager.progress('close');
   }; 
}

//�쳣�����ֵ䵼��
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
         msg: '�쳣�����ֵ䵼��',
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
            msg: '��������ֵ䵼��',
            text: '�����У�����'+(rowCnt-1)+'��'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}

//�쳣�����ֵ����ݱ���
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
			 var ErrCode=rowArr[0]
			 if(ErrCode==""){
				$.messager.alert('��ʾ','�쳣���벻��Ϊ��','error');
				return;	
			}
			var ErrDefaultDesc = rowArr[1];
			var ErrConfig = rowArr[2];
			var Demo = rowArr[3];
			var RuleInfo = rowArr[4];
			var ActiveFlag = rowArr[5];
			var HospDr =rowArr[6];
			var Rowid = rowArr[13];
			var ProductLine = rowArr[14];
			var ProductModule = rowArr[15];
			var ErrType = rowArr[16];
			var saveinfo=Rowid+"^"+ErrCode+"^"+ErrDefaultDesc+"^"+ErrConfig+"^"+Demo+"^"+RuleInfo+"^"+ActiveFlag+"^"+HospDr;
            saveinfo = saveinfo + "^^^^^^^" + ProductLine + "^" + ProductModule + "^" + ErrType;
			saveinfo=saveinfo.replace(/��������Ϣ/g,"")
			///alert(saveinfo)
			var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
             if (savecode == null || savecode == undefined) savecode = -1
             if (savecode >= 0) {
	             sucRowNums = sucRowNums + 1;
	             } 
	        else {
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
                    $.messager.alert('��ʾ', '������ȷ�������');
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
			  $.messager.alert('��ʾ', '���������쳣���������쳣��'+ex.message,'error')
	          return ;
	      }
  return ;
	
}

function selectHospCombHandle(){

	setValueById('diccbx','');
	seldictype='';
	selRowid = -1;
	
}
$('.hisui-linkbutton').bind('click',function(){
	 switch (this.id){ 
	    case "btnUpdate" : // ����
	    	$.messager.confirm("��ʾ", "�Ƿ�������棿", function (r) { // prompt �˴���Ҫ����Ϊ��������
				if (r) {
					UpdateDic();
				} else {
					return false;
				}
			})
	    	break;
	    case "btnDelete" : //ɾ��
				DelDic(); 	
	    	break;
	    case "btnClear" :
	    	clearform();
	    	break;	
	    case "btnSeach" : //��ѯ
	    	Querydic();
	    	break;
	   	case "btnClearQ" : //�������������
	    	ClearQ();
	    	break;
	    default :
	    	break;
	    }
		
}) 
