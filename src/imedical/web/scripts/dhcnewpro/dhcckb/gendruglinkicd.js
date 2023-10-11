///****************************************
//*	Author: 		Sunhuiyong
//*	Create: 		2022/07/15
//*	Description:	ͨ��������ICD-��Ŀ���ݲɼ�
///****************************************
/// ҳ���ʼ������
var DicCode="";
var DicDesc="";
var DicRowID="";
var spac  = "^"	 /// �ָ���
var rowFlag = "[row]"	 /// �ָ���
var mDel1 = "^"  //String.fromCharCode(1);  /// �ָ���
var mDel2 = "@@"  //String.fromCharCode(2);
function initPageDefault(){
	InitLinkList();
	InitCombobox();
}
/// ��ʼ��������
function InitLinkList(){
	// s title="num^itmCode^itmProName^itmGeneName^itmIngre^itmExcipient^itmForm^itmLibary^errMsg"

	var  columns=[[   
			{field:'Loc',title:'����',width:150,align:'center'}, 
	   		{field:'Gen',title:'ͨ����',width:150,align:'center'},
	       	{field:'Dia',title:'���',width:100,align:'center'},    
	     	{field:'DiaGen',title:'ͨ����+���',width:50,align:'center',sortable:'true',sorter:mySort}, 
	     	{field:'Lv',title:'ͨ����+���/��ͨ�������������',width:120,align:'center',sortable:'true',sorter:mySort}, 
	     	{field:'Lv2',title:'ͨ����+���/��ͨ���������д���',width:120,align:'center',sortable:'true',sorter:mySort},
	     	{field:'Operating',title:'����֪ʶ��',width:100,align:'center',formatter:SetCellOper}   
	        
	    ]]
	
	///  ����datagrid
	var option = {		
		toolbar:'#toolbar',
		border:false,
	    rownumbers:true,
	    fitColumns:true,
	    singleSelect:true,
	    pagination:true,
	    pageSize:500,
	    pageList:[500,1000,5000,10000],
	    fit:true,	
	    remoteSort:false,
	    //multiSort:true,
	    //checkbox:true,
	    onDblClickRow: function (rowIndex, rowData) {			
		
        },
	    onLoadSuccess: function (data) { //���ݼ�������¼�
     
        }
	};	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBGenDrugLinkIcd&MethodName=GetDrugLinkIcdList";
	new ListComponent('linklist', columns, uniturl, option).Init();
}
///���ò�����ϸ����
function SetCellOper(value, rowData, rowIndex){

	var btn = "<img class='mytooltip' title='����' onclick=\"ImportLinkGenRule('"+rowData.Gen+"','"+rowData.Dia+"','"+rowData.Loc+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 

 return btn;  

}
//����֪ʶ��ͨ��������
function ImportLinkGenRule(Gen,Dia,Loc)
{
	//�ж��Ƿ�ù����Ѿ�����
	//�ж��Ƿ����ͨ������Ӧ֢����
	
	//���������ֱ�Ӳ���һ������ϸ��Ϣ
	//��������������ͨ������Ӧ֢����
	var hospDesc=$HUI.combobox("#HospId").getText();   //shy 2020-12-4 ���ƥ����
	var hospDescStr=hospDesc;
	
	runClassMethod("web.DHCCKBGenDrugLinkIcd","ImportICDLink",{"Gen":Gen,"Dia":Dia,"Loc":Loc,"LoginInfo":LoginInfo,"HospStr":hospDescStr},function(getString){
					if (getString == 0){
						$.messager.alert("��ʾ","�������ɹ���")
					}else if(getString == -1){
						$.messager.alert("��ʾ","����Ӧ֢�Ѿ�����ͨ���������£�")
					}else if(getString == 1){
						$.messager.alert("��ʾ","��ͨ�����´��ھ�����ҩ��������Ӹü����������£�")
					}else{
						$.messager.alert("��ʾ","����ʧ�ܣ�")
					}
			},'text',false);
	
	
}
/// ��ʼ��LookUp
function InitCombobox(){
    
    var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
    $HUI.combobox("#HospId",{
	     url:uniturl,multiple:true,selectOnNavigation:false,editable:true,
	     valueField:'value',
						textField:'text',
						panelHeight:"150",
						mode:'remote',
						onSelect:function(ret){
							
								var hospDesc=$HUI.combobox("#HospId").getValues();   //shy 2020-12-4 ���ƥ����
								var hospDescStr=""
								for(var i=0;i<hospDesc.length;i++)
								{
									if(hospDescStr=="")
									{
										hospDescStr=hospDesc[i];
									}else
									{
										hospDescStr=hospDescStr+"^"+hospDesc[i];
									}
								}
														
							var uniturl = $URL+"?ClassName=web.DHCCKBGenDrugLinkIcd&MethodName=GetComLoc&HospStr="+hospDescStr  
						    $HUI.combobox("#queryloc",{
							     url:uniturl,multiple:false,selectOnNavigation:false,editable:true,
							    			    valueField:'value',
												textField:'text',
												panelHeight:"150",
												mode:'remote',
												onSelect:function(ret){
													
												}
							   })
													
							
						}
	   })
}


//�Զ�������,����ٷ���������׼ȷ����
function mySort(a,b) {
	a = a.split('/');
	b = b.split('/');
	if (a[2] == b[2]){
		if (a[0] == b[0]){
			a[1] = parseFloat(a[1]);
			b[1] = parseFloat(b[1]);
			return (a[1]>b[1]?1:-1);
		} else {
			a[0] = parseFloat(a[0]);
			b[0] = parseFloat(b[0]);
			return (a[0]>b[0]?1:-1);
		}
	} else {
		a[2] = parseFloat(a[2]);
		b[2] = parseFloat(b[2]);
		return (a[2]>b[2]?1:-1);
	}
}
function searchLinkList()
{
	//var hospDesc = $HUI.combobox("#HospId").getText();
	var hospDesc=$HUI.combobox("#HospId").getValues();   //shy 2020-12-4 ���ƥ����
	var hospDescStr=""
	for(var i=0;i<hospDesc.length;i++)
	{
		if(hospDescStr=="")
		{
			hospDescStr=hospDesc[i];
		}else
		{
			hospDescStr=hospDescStr+"^"+hospDesc[i];
		}
	}
	var querypara=$("#querypara").val();
	var queryloc=$HUI.combobox("#queryloc").getValue();
	$("#linklist").datagrid("load",{"HospDesc":hospDescStr,"Querypara":querypara,"Queryloc":queryloc});	
}

//����ӵ��� ���ݹȸ�
function formImpnew()
{
	var wb;				//��ȡ��ɵ�����
	var rABS = false;	//�Ƿ��ļ���ȡΪ�������ַ���
    var files = $("#filepath").filebox("files");
    if (files.length == 0){
		$.messager.alert("��ʾ:","��ѡ���ļ������ԣ�","warning");
		return;   
	} 
	var binary = "";
    var fileReader = new FileReader();
    fileReader.onload = function(ev) {
        try {
            //var data = ev.target.result;
			var bytes = new Uint8Array(ev.target.result);
			var length = bytes.byteLength;
			for(var i = 0; i < length; i++) {
				binary += String.fromCharCode(bytes[i]);
			}
			if(rABS) {
				wb = XLSX.read(btoa(fixdata(binary)), {//�ֶ�ת��
					type: 'base64'
				});
			} else {
				wb = XLSX.read(binary, {
					type: 'binary'
				});
			}
    
        } catch (e) {
			$.messager.alert("��ʾ:","�ļ����Ͳ���ȷ��","warning");
			$.messager.progress('close');
			return;
        }

		var obj = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
		if(!obj||obj==""){
			$.messager.alert("��ʾ:","��ȡ�ļ�����Ϊ�գ�","warning");
			$.messager.progress('close'); 
			return;
		}
		$('#pro').progressbar({
		text:"���ڴ����У����Ժ�...",
	    value: 0
		});
		//$.messager.progress({ title:'���Ժ�', msg:'�������ڵ�����...' });
		var Ins = function(n){
			if (n >= obj.length){			  
				//Save();
				//$.messager.progress('close');
			}else{
							
				var TmpArr = [];
				for(var m = n; m < obj.length; m++) {	
	
					// json����ת����Ҫ��ʽ������
					var mListDataArr = JsonToArr(obj[m],mDel1);
					var num=obj[m].__rowNum__+1;
					mListDataArr.push("num"+mDel1+num)
					mListDataArr = mListDataArr.join(spac)	//{"a":1,"b":2} -> a$c(1)1 [next] b$c(1)2					
					TmpArr.push(mListDataArr+mDel2);
					
					//���ó�����
					var ResultFlag = SaveRowData(mListDataArr,m,obj.length);
					
					if(ResultFlag!="1")
					{
						$("#linklist").datagrid('reload');
						break;	
					}
					if((m+1)==obj.length)
					{
						var hospId = $HUI.combobox("#HospId").getValue();
						var errFlag = serverCall("web.DHCCKBImportCompare","QueryLibDicMount",{"hospital":hospId,"type":DicCode})
						var dicMount=errFlag.split("^")[0];
						var constMount=errFlag.split("^")[1];
						
						
						$.messager.alert("��ʾ","�������,���ε�����չ�ϵ"+obj.length+"��,�ֵ�����:"+dicMount+" ��������:"+constMount+"!");
						$("#linklist").datagrid('reload');
						break;	
					}
								
				}
		
			}
		}
		Ins(0);	//�ӵ�һ�п�ʼ��		
  
   }
   fileReader.readAsArrayBuffer(files[0]);	
		
}

//�Ż��е��루��ν�����
function SaveRowData(rowData,row,rowcount){
		/*var value = $('#pro').progressbar('getValue');
			if (value < 100){
	   		 	value = ((row)/(rowcount-1))*100;
	   		 	value =parseInt(value)
	   		 	$('#pro').progressbar('setValue', value);
			}
			*/
	//var hospDesc = $HUI.combobox("#HospId").getText();
	var hospDesc=$HUI.combobox("#HospId").getValues();   //shy 2020-12-4 ���ƥ����
	if (hospDesc.length>1) 
	{
		$.messager.alert("��ʾ","��ѡ��һ��ҽԺ���룡");
		return;
	}

	var ErrFlag = serverCall("web.DHCCKBGenDrugLinkIcd","SaveDrugLink",{"RowData":rowData,"HospDesc":hospDesc})
	return 1;
}
function JsonToArr(obj,spec){

	// ����typeof�ж϶���Ҳ��̫׼ȷ
	/*
	���ʽ	                      ����ֵ
	typeof undefined	       'undefined'
	typeof null	               'object'
	typeof true	               'boolean'
	typeof 123	               'number'
	typeof "abc"	           'string'
	typeof function() {}	   'function'
	typeof {}	               'object'
	typeof []	               'object'
	*/
	
	var val=(Object.prototype.toString.call(obj) === '[Object Object]')?0:1;
	val=(JSON.stringify(obj) == "{}")?1:0;
	
	if (val){
		return "";
	}
	var strArr = [];
	for (k in obj){
		var tmpStr = k + spec + obj[k];		// {"test":"1"}-> test$c(1)1
		strArr.push(tmpStr);
	}
	
	return strArr;
	
}
 //����ļ��ϴ���·�� 
function clearFiles(){
      $('#filepath').filebox('clear');
     
} 
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
