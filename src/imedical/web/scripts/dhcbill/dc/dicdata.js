	/**
 * ���ݺ˲�������ά��
 * FileName: dhcbill\dc\dicdata.js
 * tangzf 2022-05-11
 */
 var GV = {
	CLASSNAME:"BILL.DC.BL.DicDataCtl"	 
}
//ȫ�ֱ���
var selRowid="";
var seldictype = ""; 
var tmpselRow = -1;
$(function(){
	initGY();
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
			Querydiccbx();
			Querydic();
		}
	});
	init_combogrid();
	init_ActiveFlagCB();
	//��ʼ��datagrid
	$HUI.datagrid("#dg",{
		data:[],
		fit: true,
		border:false,
		//idField:'dgid',
		rownumbers:true,
		width: '100%',
		striped:true,
		toolbar: '#toolbar',
		fitColumns:true,
		singleSelect: true,
		autoRowHeight:false,
		columns:[[
			{field:'DicType',title:'�ֵ�����',width:80},
			{field:'DicCode',title:'����',width:80},
			{field:'DicDesc',title:'����'},
			{field:'DicDemo',title:'��ע',width:200,showTip: true },
			{field:'ConCode',title:'���մ���',width:50},
			{field:'ConDesc',title:'��������',width:80},
			{field:'ConDemo',title:'���ձ�ע',width:150},
			{field:'ActiveFlag',title:'�Ƿ�����',width:50,
			formatter: function (value, row, index) {
				return (value == "Y") ? "<font color='#21ba45'>��</font>" : "<font color='#f16e57'>��</font>";}},
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
			    fillform(rowIndex,rowData);
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
	
	Querydic();
});
function initGY(){
	$('#GYFlag').combobox({
		valueField: 'id',
		textField: 'desc',
		editable:false,
		data:[
			{
				"id":"G",
				"desc":"����",
				selected:true	
			},
			{
				"id":"S",
				"desc":"�ǹ���"
			}	
		],
		onSelect:function(){
			Querydiccbx();
			Querydic();
		}
	})
}
function init_combogrid(){
	var DicDesc="ϵͳ";
	//��ʼ��combogrid
	$HUI.combogrid("#diccbx",{  
		
		//idField: 'diccbxid', 
	    panelWidth:520,   
	    panelHeight:300,  
	    idField:'DicCode',  
	    valueField: 'DicCode',  
	    textField:'DicDesc', 
        //rownumbers:true,
        pagination: false,
        delay:800,
	    columns:[[   
	        {field:'DicCode',title:'����',width:160},  
	        {field:'DicDesc',title:'����',width:210},
	        {field:'DicDemo',title:'��ע',width:110}    
	    ]],
	    //fitColumns: true,
        keyHandler:{  
			up: function(){},  
			down: function(){},  
			enter: function(){},  
			query:function(q){ 
				//$(this).combogrid('grid').datagrid('unselectAll');
				//�첽����
				$.cm({
					
					ClassName:GV.CLASSNAME,
					QueryName:"QueryInfo",
					KeyCode:q,
					PDicType:"SYS",
					ExpStr:"|" + getValueById('GYFlag'),
					HospID:getValueById("GYFlag")=="G"?getValueById("GYFlag"):getValueById("hospital"),
					rows:1000
				},function(jsonData){	
					$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
					$('#diccbx').combogrid('setText',q);
					
				}); 
			}  
		},
		
		onSelect: function (record,selobj) {              //ѡ�д���
			dicSelid=record
			clearform();
			//Querydic();
		},
		onLoadSuccess: function (data) {
			for(var i=0; i<data.rows.length;i++)
			{
				if(data.rows[i].DicCode=='SYS')
				{
					$(this).combogrid('grid').datagrid("selectRow", i);
				}
			}
		}
	}); 	
}
//��ѯ�ֵ�����
function Querydic(){
	//$("#dg").datagrid('unselectAll')
	//$('#dg').datagrid('loadData',{total:0,rows:[]});
	clearform();
	//zjb add 2022/08/10 ����Ǻ˲���ϸ�����п��ƣ������ݰ�����������
	if ($('#diccbx').combobox('getValue')=="CKDETCol") 
	{
		setValueById('ConDemo','USER'); //Ĭ�ϳ�USER
		setValueById('ConDescStr','������');
		var DGOptions=$('#dg').datagrid('options');
		DGOptions.sortName='ConDesc';
		DGOptions.remoteSort=false;
		$.each(DGOptions.columns[0],function(index,val){
		if (val.field=='ConDesc')
		{
			val.title="������";
			val.sortable=true;
			val.sortOrder='asc'
			val.sorter=function(a,b){
				var num1=parseFloat(a);
				var num2=parseFloat(b);
				return (num1>num2?1:-1);
			}
		}
		});
		$('#dg').datagrid(DGOptions);
	}
	else
	{
		if(getValueById('ConDescStr')=='������')
		{
			setValueById('ConDemo','');
			setValueById('ConDescStr','��������');
			 var DGOptions=$('#dg').datagrid('options');
			 DGOptions.sortName='';
			 DGOptions.remoteSort=false;
			 $.each(DGOptions.columns[0],function(index,val){
				 if (val.field=='ConDesc')
				 {
					 //val.width=90;
					 val.title="��������";
					 val.sortable=false;
					 val.sortOrder='';
					 val.sorter="";
				 }
			 });
			 $('#dg').datagrid(DGOptions);
		}
	}
	
	var QueryParam={
		ClassName: GV.CLASSNAME,
		QueryName: 'QueryInfo',
		ExpStr:"|" + getValueById('GYFlag'),
		HospID : getValueById("hospital"),
		KeyCode:getValueById('dicKey'),
		PDicType:$('#diccbx').combobox('getValue')==""?"SYS":$('#diccbx').combobox('getValue')
	}
	loadDataGridStore('dg',QueryParam);
	
}
//�����ַ�����
function SplVCFormat(FStr)
{
	return  FStr.replace(/\^/g,"");
}

//ͣ�ñ����¼
function StopDic(){
	if(selRowid=="" || selRowid<0 || !selRowid){
		$.messager.alert('��ʾ','��ѡ��Ҫͣ�õ�ָ��!','info'); 
		return;  
	}
	if(getValueById('ActiveFlag')=="N")
	{
		$.messager.alert('��ʾ','ָ����ͣ��!','info'); 
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ�ͣ�ã�", function (r) { // prompt �˴���Ҫ����Ϊ��������
	if (r) {
		var DicType = $('#diccbx').combobox('getValue');
		var DicCode = getValueById('DicCode');
		var DicDesc = getValueById('DicDesc');
		var DicDemo = getValueById('DicDemo');
		var ConDesc = getValueById('ConDesc');
		var ConDemo = getValueById('ConDemo');
		var ActiveFlag = "N";
		var Rowid = getValueById('Rowid');
		var ConCode = getValueById('ConCode');
		selRowid = selRowid<=0?"":selRowid;
		var HospDr = selRowid==""?getValueById('hospital'):$('#dg').datagrid('getSelected').HospDr;
		var GYFlag=getValueById('GYFlag');
		HospDr = (GYFlag=="G")||(HospDr=="G")?"G":HospDr;
		var saveinfo=selRowid+"^"+DicCode+"^"+DicDesc+"^"+DicDemo+"^"+ConDesc+"^"+ConDemo+"^"+ActiveFlag+"^"+HospDr;
		saveinfo = saveinfo + "^^^^^^^" + ConCode + "^" + DicType;
		saveinfo=saveinfo.replace(/��������Ϣ/g,"")
		///alert(saveinfo)
		var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
		if(savecode.split('^')[0]>0){
			if(DicType=="SYS"){
				$.cm({
					ClassName:GV.CLASSNAME,
					QueryName:"QueryInfo",
					KeyCode:'',
					PDicType:"SYS",
					HospID:getValueById("hospital"),
					rows:1000
				},function(jsonData){		
					$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
				});	
			}
			//$.messager.alert('��ʾ','����ɹ�!');  
			Querydic();
			clearform("")
			$.messager.alert('��ʾ','ͣ�óɹ�!','info');   
		}else{
			$.messager.alert('��ʾ','ͣ��ʧ��!rtn=' + savecode,'info');   
		}
	} else {
		return false;
	}
	})

}
//���±����¼
function UpdateDic(){
	var DicType = $('#diccbx').combobox('getValue');
	if(DicType==""){
		$.messager.alert('��ʾ','�ֵ����Ͳ���Ϊ��','error');
		return;	
	}
	var DicCode = getValueById('DicCode');
	if(DicCode==""){
		$.messager.alert('��ʾ','�ֵ���벻��Ϊ��','error');
		return;	
	}
	var DicDesc = getValueById('DicDesc');
	var DicDemo = getValueById('DicDemo');
	var ConDesc = getValueById('ConDesc');
	var ConDemo = getValueById('ConDemo');
	var ActiveFlag = getValueById('ActiveFlag');
	
	var Rowid = getValueById('Rowid');
	var ConCode = getValueById('ConCode');
	selRowid = selRowid<=0?"":selRowid;
	var HospDr = selRowid==""?getValueById('hospital'):$('#dg').datagrid('getSelected').HospDr;
	var GYFlag=getValueById('GYFlag');
	HospDr = (GYFlag=="G")||(HospDr=="G")?"G":HospDr;
	var saveinfo=selRowid+"^"+DicCode+"^"+DicDesc+"^"+DicDemo+"^"+ConDesc+"^"+ConDemo+"^"+ActiveFlag+"^"+HospDr;
	saveinfo = saveinfo + "^^^^^^^" + ConCode + "^" + DicType;
	saveinfo=saveinfo.replace(/��������Ϣ/g,"")
	///alert(saveinfo)
	var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
	if(savecode.split('^')[0]>0){
		if(DicType=="SYS"){
			$.cm({
				ClassName:GV.CLASSNAME,
				QueryName:"QueryInfo",
				KeyCode:'',
				PDicType:"SYS",
				HospID:getValueById("hospital"),
				rows:1000
			},function(jsonData){		
				$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
			});	
		}
		//$.messager.alert('��ʾ','����ɹ�!');  
		Querydic();
		//Querydiccbx();
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
				var DicType=$('#diccbx').combobox('getValue');
				if(DicType=="SYS"){
					$.cm({
						ClassName:GV.CLASSNAME,
						QueryName:"QueryInfo",
						KeyCode:'',
						PDicType:"SYS",
						HospID:getValueById("hospital"),
						rows:1000
					},function(jsonData){		
						$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
					});	
				}
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
	setValueById('DicCode',rowData.DicCode);
	setValueById('DicDesc',rowData.DicDesc);
	setValueById('DicDemo',rowData.DicDemo);
	setValueById('ConDesc',rowData.ConDesc);
	setValueById('ConDemo',rowData.ConDemo);
	setValueById('ActiveFlag',rowData.ActiveFlag);
	setValueById('ConCode',rowData.ConCode);	

}
//����±ߵ�form
function clearform(inArgs){
	$('#ErrCode').attr("disabled",false);
	$('.editinfo input').each(function(){        
		$(this).val(inArgs)
	})
	if ($('#diccbx').combobox('getValue')=="CKDETCol") 
	{
		setValueById('ConDemo','USER'); //Ĭ�ϳ�USER
	}
	else
	{
		setValueById('ConDemo',''); 
	}
	selRowid="";
}
//�ı��±���ʾ��ı༭״̬
function disinput(tf){
	return;
	$('#code').attr("disabled",tf);


}
//���ݺ˲��ֵ䵼��
function Export()
{
   try
   {
	   var KeyCodeValue=getValueById('dicKey')
		//window.open("websys.query.customisecolumn.csp?CONTEXT=KBILL.DC.BL.DicDataCtl:QueryInfo&PAGENAME=QueryInfo&HospID="+PUBLIC_CONSTANT.SESSION.HOSPID+"&KeyCode="+KeyCodeValue+"&PDicType="+$('#diccbx').combobox('getValue')==""?"SYS":$('#diccbx').combobox('getValue'));
		$.messager.progress({
	         title: "��ʾ",
			 msg: '���ڵ������ݺ˲��ֵ�',
			 text: '������....'
			   });
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:"���ݺ˲��ֵ�",		  
			PageName:"QueryInfo",      
			ClassName: GV.CLASSNAME,
			QueryName: 'QueryInfo',
			HospID : getValueById("hospital"),
			KeyCode:KeyCodeValue,
			ExpStr:'Y|'
			//PDicType:$('#diccbx').combobox('getValue')==""?"SYS":$('#diccbx').combobox('getValue')
		},function(date){
			  setTimeout('$.messager.progress("close");', 3 * 1000);	
		});
		
   } catch(e) {
	   $.messager.alert("����",e.message);
	   $.messager.progress('close');
   }; 
}

//zjb 2023/11/11 ԭ���ĵ���ѡ���ļ������ö�״̬������
function Import()
{
	ImportObj.ImportFile(
		{
			FileSuffixname: /^(.xls)|(.xlsx)$/,///^(.txt)$/,
			harset: 'utf-8'
		}, function(arr){
			SaveArr(arr);
		}
	);
}
//ѭ�������淽��
function SaveArr(arr)
{
	var ErrMsg = "";     //��������
    var errRowNums = 0;  //��������
    var sucRowNums = 0;  //����ɹ�������
	var rowCnt=arr.length
	try{
		$.messager.progress({
            title: "��ʾ",
            msg: '����շ�/ҽ����Ŀ�����ֵ䵼��',
            text: '�����У�����'+(rowCnt-1)+'��'
        }); 
		for (i = 0; i < rowCnt; i++) 
		{
			var rowArr=arr[i];
			var DicType = rowArr.DicType?rowArr.DicType:"";
			var DicCode = rowArr.DicCode?rowArr.DicCode:"";
			var DicDesc = rowArr.DicDesc?rowArr.DicDesc:"";
			var DicDemo = rowArr.DicDemo?rowArr.DicDemo:"";
			var ConDesc = rowArr.ConDesc?rowArr.ConDesc:"";
			var ConDemo = rowArr.ConDemo?rowArr.ConDemo:"";
			var ActiveFlag = rowArr.ActiveFlag?rowArr.ActiveFlag:"";
			var HospDr = rowArr.HospDr?rowArr.HospDr:""; 
			var CRTER = rowArr.CRTER?rowArr.CRTER:"";
			var CRTEDATE = rowArr.CRTEDATE?rowArr.CRTEDATE:"";
			var CRTETIME = rowArr.CRTETIME?rowArr.CRTETIME:"";
			var UPDTID = rowArr.UPDTID?rowArr.UPDTID:"";
			var UPDTDATE = rowArr.UPDTDATE?rowArr.UPDTDATE:"";
			var UPDTTIME = rowArr.UPDTTIME?rowArr.UPDTTIME:"";
			var Rowid = rowArr.Rowid?rowArr.Rowid:"";
			var ConCode = rowArr.ConCode?rowArr.ConCode:"";
			var DicNum = rowArr.DicNum?rowArr.DicNum:"";
			var saveinfo=Rowid+"^"+DicCode+"^"+DicDesc+"^"+DicDemo+"^"+ConDesc+"^"+ConDemo+"^"+ActiveFlag+"^"+HospDr;
			 saveinfo = saveinfo + "^^^^^^^" + ConCode + "^" + DicType;
			 var savecode =tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
            if (savecode == null || savecode == undefined) savecode = -1;
            if (savecode >= 0) {
	        	sucRowNums = sucRowNums + 1;
	        } 
	        else {
		        errRowNums = errRowNums + 1;
		        if (ErrMsg == "") {
			        ErrMsg = i+":"+savecode;
			    }
			    else {
                    ErrMsg = ErrMsg + "<br>" + i+":"+savecode+"�Ѵ��ڣ�";
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
	}
	catch(ex)
	{
		$.messager.progress("close");
		$.messager.alert('��ʾ', '�������ݺ˲��ֵ������쳣��'+ex.message,'error');
	}
}


//���ݺ˲��ֵ䵼��
function Import2()
{
	/* var grid = $('#dg');  
    grid.datagrid('getPager').data("pagination").options.pageNumber=2;  

	return; */
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
         msg: '���ݺ˲��ֵ䵼��',
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
            msg: '���ݺ˲��ֵ䵼��',
            text: '�����У�����'+(rowCnt-1)+'��'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}

//���ݺ˲��ֵ����ݱ���
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
			 var DicType=rowArr[0]
			 var DicCode=rowArr[1]
			 var DicDesc=rowArr[2]
			 var DicDemo=rowArr[3]
			 var ConDesc=rowArr[4]
			 var ConDemo=rowArr[5]
			 var ActiveFlag=rowArr[6]
			 var HospDr=rowArr[7]
			 var SelectRow=rowArr[14]
			 var ConCode=rowArr[15]
			 var saveinfo=SelectRow+"^"+DicCode+"^"+DicDesc+"^"+DicDemo+"^"+ConDesc+"^"+ConDemo+"^"+ActiveFlag+"^"+HospDr;
			 saveinfo = saveinfo + "^^^^^^^" + ConCode + "^" + DicType;
			 var savecode =tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID'])
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
			  $.messager.alert('��ʾ', '�������ݺ˲��ֵ������쳣��'+ex.message,'error')
	          return ;
	      }
  return ;
	
}
function addClear4Combogrid(theId,onChangeFun)
{
 var theObj = $(theId);
  
 //���ݵ�ǰֵ��ȷ���Ƿ���ʾ���ͼ��
 var showIcon = function(){  
  var icon = theObj.combogrid('getIcon',0);
  if (theObj.combogrid('getValue')){
   icon.css('visibility','visible');
  } else {
   icon.css('visibility','hidden');
  }
 };
  
 theObj.combogrid({
  //������ͼ��
  icons:[{
   iconCls:'icon-clear',
   handler: function(e){
    theObj.combogrid('clear');
   }
  }],
   
  //ֵ�ı�ʱ������ֵ��ȷ���Ƿ���ʾ���ͼ��
  onChange:function(){
   if(onChangeFun)
   {
    onChangeFun();
   }
   showIcon();
  }
   
 }); 
  
 //��ʼ��ȷ��ͼ����ʾ
 showIcon();
}

function onChangeFun(){
	
}
function Querydiccbx(){

	//$('#editinfo').form('clear');
	$('#diccbx').combogrid('grid').datagrid('unselectAll');
	setValueById('diccbx','');
	seldictype='';
	selRowid = -1;
	
	//�첽����

	$.cm({
		ClassName:GV.CLASSNAME,
		QueryName:"QueryInfo",
		KeyCode:"",
		PDicType:"SYS",
		HospID:getValueById("hospital"),
		ExpStr:"|" + getValueById("GYFlag"),
		rows:1000
	},function(jsonData){	
		$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
	}); 
	//����grid

	//Querydic();
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
	    case "btnStop" : // ͣ��
	    	StopDic();
	    	break;
	    default :
	    	break;
	    }
		
}) 

//����Ϸ���ѯ
function ClearQ(){
	setValueById('diccbx','SYS'); 	
	setValueById('dicKey',''); 
	var defHospId = session['LOGON.HOSPID'];
	setValueById('hospital',defHospId);
	setValueById('GYFlag','G');
	Querydic();
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
