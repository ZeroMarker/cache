// Creator: congyue
/// CreateDate: 2017-12-27
//  Descript: �����¼����� �����ֵ�ά��
var HospDr="";
var editRow = "",LinkID="";
$(function(){
    InitHosp(); 	//��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
	initParams();
	
	//initCombobx();
	
	initBindMethod();

	initDatagrid();
	
})	
// ��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
function InitHosp(){
	hospComp = GenHospComp("DHC_AdvExpFieldLink"); 
	HospDr=hospComp.getValue(); 
	//$HUI.combogrid('#_HospList',{value:"11"})
	hospComp.options().onSelect = function(){///ѡ���¼�
		HospDr=hospComp.getValue();
		$('#linkdg').datagrid('reload'); //���¼���
		reloadTopTable(); 
		$('#linkdg').datagrid({
			url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetLinkList&HospDr="+HospDr,
		});	
	}
	$("#_HospBtn").bind('click',function(){
		var rowData = $("#linkdg").datagrid('getSelected');
		if (!rowData){
			$.messager.alert("��ʾ","��ѡ��һ������ģ�嶨�����ݣ�")
			return false;
		}
		GenHospWin("DHC_AdvExpFieldLink",rowData.ID);
	})
}
function initParams(){
	editRow="";	
	inputEditor={type:'validatebox',options:{required:true}};
}

function initBindMethod(){
    $("a:contains('���Ԫ��')").bind('click',addItm);
    $("a:contains('ɾ��Ԫ��')").bind('click',delItm);
    $("a:contains('ȫ��ѡ��')").bind('click',selAllItm);
    $("a:contains('ȡ��ѡ��')").bind('click',unSelAllItm);
    $("a:contains('ȫ��ɾ��')").bind('click',delAllItm);
	$("#inslink").bind("click",inslinkRow);
	$("#dellink").bind("click",dellinkRow);
	$("#savelink").bind("click",savelinkRow);
    
}
/* function initCombobx(){
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=";
	var option = {
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			reloadTopTable();
	    }
	};
	
	var url = uniturl+"JsonGetRepotType&HospDr="+HospDr;
	new ListCombobox("reportType",url,'',option).init();
	
} */

function initDatagrid(){
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	/// ��Combobox
	var FormEditor={  //������Ϊ�ɱ༭
		//��� 		
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCADVDicContrast&MethodName=jsonForm&HospID="+HospDr,
			required:true,
			//panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#linkdg").datagrid('getEditor',{index:editRow,field:'FormNameDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#linkdg").datagrid('getEditor',{index:editRow,field:'FormNameCode'});
				$(ed.target).val(option.code);
				
				/* ///���ü���ָ��
				var FormID=option.value;  //Ԫ��
				var FormDicDesced=$("#linkdg").datagrid('getEditor',{index:editRow,field:'FormDicDesc'});
				$(FormDicDesced.target).combobox('setValue', "");
				var unitUrl=LINK_CSP+"?ClassName=web.DHCADVFormDicContrast&MethodName=jsonFormDic&FormID="+FormID;
				$(FormDicDesced.target).combobox('reload',unitUrl);
				var FormDicCodeed=$("#linkdg").datagrid('getEditor',{index:editRow,field:'FormDicCode'});
				$(FormDicCodeed.target).val(""); */
				
			}
		}
	}
	var linkcolumns=[[
		{field:'ID',title:'ID',width:80,hidden:true},
		{field:'Code',title:'����',width:120,editor:inputEditor,hidden:false},
		{field:'Desc',title:'����',width:120,editor:inputEditor},
		{field:'FormNameCode',title:'������',width:220,editor:textEditor,hidden:true},
		{field:'FormNameDesc',title:'������',width:220,editor:FormEditor}
	]];
	
	$("#linkdg").datagrid({
		title:'����ģ�嶨��',
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetLinkList&HospDr="+HospDr,
		fit:true,
		columns:linkcolumns,
		loadMsg: '���ڼ�����Ϣ...',
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
		pagination:true,
		singleSelect:true,
		onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
			LinkID=rowData.ID;
			reloadTopTable();
		},
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) {
            	if(CheckEdit("linkdg",editRow)){
		        	$.messager.alert("��ʾ","����д��������Ϣ!"); 
					return false;	    
	            }
            	$("#linkdg").datagrid('endEdit', editRow);
			}
            $("#linkdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
		}
	});	
	
	var columns=[[
		{field:'FormDicID',title:'FormDicID',width:80,hidden:true},
		{field:'DicField',title:'DicField',width:120,hidden:true},
		{field:'DicDesc',title:'ȫ����',width:200}
	]];
	
	$("#allItmTable").datagrid({
		title:'����ȫ����',
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetAllItmByFormID",
		queryParams:{
			LinkID:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: '���ڼ�����Ϣ...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});	
	
	var setcolumns=[[
		{field:'RowID',title:'RowID',width:80,hidden:true},
		{field:'FormDicDr',title:'FormDicDr',width:120,hidden:true},
		{field:'DicField',title:'DicField',width:120,hidden:true},
		{field:'DicDesc',title:'������',width:200},
		{field:'num',title:'˳���',width:80},
		{field:'pri',title:'���ȼ�',width:120,
			formatter:function(value,rec,index){
			var a = '<a href="#" mce_href="#" onclick="upclick(\''+ index + '\')">����</a> ';
			var b = '<a href="#" mce_href="#" onclick="downclick(\''+ index + '\')">����</a> ';
			return a+b;  
        }  
		,hidden:false}
	]];

	$("#setItmTable").datagrid({
		title:'���浼����',
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetSetFiel&LinkID="+"",
		fit:true,
		rownumbers:true,
		columns:setcolumns,
		loadMsg: '���ڼ�����Ϣ...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});
	$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
		
}
///���Ԫ��
function addItm(){
	var linkdata = $("#linkdg").datagrid("getSelections");
	if(linkdata.length<1){
		$.messager.alert("��ʾ","δѡ�е���ģ�嶨�����ݣ�");
		return;	    
	}
	LinkID=linkdata[0].ID;
	
	var datas = $("#allItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("��ʾ","δѡ�б���ȫ�������ݣ�");
		return;	    
	}
	var dataArray=[],param="";
	for(x in datas){ 
		param = datas[x].DicField;
		dataArray.push(param);
	}
	
	var params = dataArray.join("&&");
	runClassMethod("web.DHCADVEXPFIELD","SaveExpField",{"Params":params,"LinkID":LinkID},
	function(ret){
		if(ret=="0"){
			$.messager.alert("��ʾ","�����ɹ���");
			reloadTopTable();
		}
	},'text');
	

}
function delItm(){
	var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("��ʾ","δѡ���Ҳ����ݣ�");
		return;	    
	}
	var dataArray=[],param="";
	for(x in datas){ 
		param = datas[x].RowID;
		dataArray.push(param);
	}
	
	var params = dataArray.join("&&");
	runClassMethod("web.DHCADVEXPFIELD","DelExpField",{"Params":params},
	function(ret){
		if(ret=="0"){
			$.messager.alert("��ʾ","ɾ���ɹ���");
			reloadTopTable();
		}
	},'text');
}

function delAllItm(){
	$("#setItmTable").datagrid("checkAll");
	delItm();
}
function selAllItm(){
	$("#allItmTable").datagrid("checkAll");
}
function unSelAllItm(){
	$("#allItmTable").datagrid("uncheckAll");
}
//reload ���ϱ�
function reloadAllItmTable(){
	$("#allItmTable").datagrid('load',{
		LinkID:LinkID
	})
}

function reloadSetFielTable(){
	$("#setItmTable").datagrid('load',{
		LinkID:LinkID
	})
}
///ˢ�� field��fieldVal
function reloadTopTable(){
	reloadSetFielTable();
	reloadAllItmTable();
}

//����
function upclick(index)
{
	/* var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("��ʾ","δѡ��������ݣ�");
		return;	    
	}
	if(datas.length>1){
		$.messager.alert("��ʾ","ֻ��ѡ��һ��������ݣ�");
		return;	    
	}
	var index=$('#setItmTable').datagrid('getRowIndex',datas[0]); */
	
	var newrow=parseInt(index)-1     
	var curr=$("#setItmTable").datagrid('getData').rows[index];
	var currowid=curr.RowID;
	var currordnum=curr.num;
	var up =$("#setItmTable").datagrid('getData').rows[newrow];
	var uprowid=up.RowID;
	var upordnum=up.num;

	var input=currowid+"^"+upordnum+"^"+uprowid+"^"+currordnum ;
	SaveUp(input);
	mysort(index, 'up', 'setItmTable');
	
}
//����
function downclick(index)
{
	/* var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("��ʾ","δѡ��������ݣ�");
		return;	    
	}
	if(datas.length>1){
		$.messager.alert("��ʾ","ֻ��ѡ��һ��������ݣ�");
		return;	    
	}
	var index=$('#setItmTable').datagrid('getRowIndex',datas[0]); */
	
	var newrow=parseInt(index)+1 ;
	var curr=$("#setItmTable").datagrid('getData').rows[index];
	var currowid=curr.RowID;
	var currordnum=curr.num;
	var down =$("#setItmTable").datagrid('getData').rows[newrow];
	var downrowid=down.RowID;
	var downordnum=down.num;

	var input=currowid+"^"+downordnum+"^"+downrowid+"^"+currordnum ;
	SaveUp(input);
	mysort(index, 'down', 'setItmTable');
}
function SaveUp(input,datas)
{
	 /* $.post(url+'?action=UpdEventWorkFlowItmNum',{"input":input},function(data){
	}); */
	runClassMethod("web.DHCADVEXPFIELD","UpdExpFieldNum",{"input":input},
	function(ret){
		reloadTopTable();
	},'text');
	 
}
function mysort(index, type, gridname) {

    if ("up" == type) {

        if (index != 0) {
			var nextrow=parseInt(index)-1 ;
			var lastrow=parseInt(index);
            var toup = $('#' + gridname).datagrid('getData').rows[lastrow];
            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
            $('#' + gridname).datagrid('getData').rows[lastrow] = todown;
            $('#' + gridname).datagrid('getData').rows[nextrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    } else if ("down" == type) {
        var rows = $('#' + gridname).datagrid('getRows').length;
        if (index != rows - 1) {
		    var nextrow=parseInt(index)+1 ;
			var lastrow=parseInt(index);
            var todown = $('#' + gridname).datagrid('getData').rows[lastrow];
            var toup = $('#' + gridname).datagrid('getData').rows[nextrow];
            $('#' + gridname).datagrid('getData').rows[nextrow] = todown;              
            $('#' + gridname).datagrid('getData').rows[lastrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    }
}


/// ����༭��
function savelinkRow(){
	
	if(editRow>="0"){
		$("#linkdg").datagrid('endEdit', editRow);
	}

	var rowsData = $("#linkdg").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	if(editRow>="0"){
		if(CheckEdit("linkdg",editRow)){
        	$.messager.alert("��ʾ","����д��������Ϣ!"); 
			return false;	    
        }
		$("#linkdg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if((rowsData[i].FormNameCode=="")){
			$.messager.alert("��ʾ","����д��������Ϣ!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].FormNameCode;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");
	//��������
	runClassMethod("web.DHCADVEXPFIELD","SaveExpFieldLink",{"Params":params,"HospDr":HospDr},function(jsonString){

		if ((jsonString == "11")||((jsonString == "12"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			//return;	
		}else if (jsonString !="0"){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
			//return;
		}
		$('#linkdg').datagrid('reload'); //���¼���
	})
}

/// ��������
function inslinkRow(){
	
	if(editRow>="0"){
		$("#linkdg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#linkdg").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].aitCode == ""){
			$('#linkdg').datagrid('selectRow',0);
			$("#linkdg").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	if(editRow>="0"){
		if(CheckEdit("linkdg",editRow)){
        	$.messager.alert("��ʾ","����д��������Ϣ!"); 
			return false;	    
        }
		$("#linkdg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	var rows = $("#linkdg").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].FormNameCode=="")){
			$.messager.alert("��ʾ","����д��������Ϣ!"); 
			return false;
		}
	} 
	$("#linkdg").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', Code:'', Desc:'', FormNameCode:'',FormNameDesc:''}
	});
	$("#linkdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
//���༭���Ƿ�༭��ȫ 2018-07-18 cy
function CheckEdit(id,index){
	var flag=0;
	var editors = $('#'+id).datagrid('getEditors', index); 
	for (i=0;i<editors.length;i++){
		if(((editors[i].type=="validatebox")&&(editors[i].target.val()==""))){  ///|| ((editors[i].type=="text")&&(editors[i].target.val()==""))||((editors[i].type=="combobox")&&(editors[i].target.combobox('getText')==""))
			flag=-1;
			return flag;	
		}
	}
	return flag; 
} 
/// ɾ��ѡ����
function dellinkRow(){
	
	var rowsData = $("#linkdg").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCADVEXPFIELD","DelExpFieldLink",{"ID":rowsData.ID},function(jsonString){
					if (jsonString !=0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
						return;
					}
					$('#linkdg').datagrid('reload'); //���¼���
					LinkID="";
					reloadTopTable();
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
