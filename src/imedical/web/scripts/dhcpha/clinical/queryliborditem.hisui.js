
/*
Creator:LiangQiang
CreatDate:2016-01-15
Description:֪ʶ�����ѯ
*/
var url='dhcpha.clinical.ckbaction.csp' ;
var levelArray=[{ "value":"", "text": "ȫ��" },{ "value": "C", "text": "����" },{ "value": "W", "text": "��ʾ" },{ "value": "S", "text": "��ʾ" }]; 
var queryDate="";
var params=""

function BodyLoadHandler()
{
	//$('#export').bind('click',Export);	 //����
	$("#stdate").datebox("setValue", formatDate(-1));  
	$("#enddate").datebox("setValue", formatDate(0));  
	
	// ����
	$('#admLoc').combobox({
		mode:"remote",
		onShowPanel:function(){
			//$('#admLoc').combobox('reload',url+'?action=SelAllLoc')
			$('#admLoc').combobox('reload',url+'?action=GetAllLocNewVersion')
		}
	}); 	
	$('#admLoc').combobox('setValue',""); 	// ���ò���Ĭ��ֵ
	
	// ������
	$('#levelMan').combobox({
		panelHeight:"auto", 
		data:levelArray
	});  
	$('#levelMan').combobox('setValue',""); // ����comboboxĬ��ֵ
	
	//Ŀ¼
	$('#label').combobox({
		onShowPanel:function(){
			$('#label').combobox('reload',url+'?action=GetLabel');
		}
 	});  
	$('#label').combobox('setText',"ȫ��"); //	����comboboxĬ��ֵ
	
	$('#Find').bind("click",Query);			// �����ѯ
	$('#reset').bind("click",Reset);  		// ����	
		
	var columns =[[  	
			  {field:'adm',title:'����id',width:50,hidden:true}, 
		      {field:'patNo',title:'�ǼǺ�',width:80,align:'center',hidden:true},
              {field:'patName',title:'��������',width:80,align:'center'},
			  {field:'medicalNo',title:'������',width:80,hidden:true}, 
			  {field:'admLoc',title:'�������',width:120},
			  {field:'admDocDesc',title:'ҽ��',width:120},
			  {field:'patDiag',title:'���',width:200,hidden:false},	//QuNiapeng  2017/5/26
			  {field:'arcDesc',title:'ҽ������',width:200},
              {field:'doseQty',title:'����',width:40,align:'center'},
			  {field:'unitDesc',title:'��λ',width:40,align:'center'},
			  {field:'instrDesc',title:'�÷�',width:50,align:'center'},
			  {field:'phFreqDesc',title:'Ƶ��',width:80,align:'center'},
			  {field:'course',title:'�Ƴ�',width:50,align:'center'},
			  {field:'rmanf',title:'��������',width:160},
			  {field:'speciFaction',title:'���',width:80},
			  {field:'labelDesc',title:'Ŀ¼',width:60,align:'center'},
			  {field:'levelDesc',title:'������',width:80,align:'center'},
			  {field:'trueMsg',title:'��ʾ��Ϣ',width:300,showTip:true,tipWidth:450},
			  {field:'rowId',title:'rowId',hidden:true}			  		 
		]];

    $('#libdatagrid').datagrid({
		title:'',
		url:url+'?action=QueryLibOrditemNew',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  
		pageList:[40,80,120],  
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		singleSelect:true,
		idField:'rowid',
		striped: true, 
		pagination:true,
		showFooter:true
		//nowrap:false
	});
	//$('#libdatagrid').datagrid('loadData', {total:0,rows:[]}); 
	//initScroll("#libdatagrid");//��ʼ����ʾ���������
	$('#Find').bind("click",Query);  //�����ѯ
}


//��ѯ
function Query()
{
    var stDate=$('#stdate').datebox('getValue');
	var endDate=$('#enddate').datebox('getValue');		// ��ֹ����
	var levelMan=$('#levelMan').combobox('getValue')	// ������
	var label=$('#label').combobox('getValue'); 		// Ŀ¼
	var labelDesc=$('#label').combobox('getText'); 
	//var errReason=$('#errReason').datebox('getValue'); 
	var admLoc=$('#admLoc').combobox('getValue'); 		// �������
	if (admLoc === undefined){
		admLoc = "";
	}	
	queryDate=stDate +"  "+endDate;

 	params=stDate+"^"+endDate+"^"+levelMan+"^"+label+"^"+labelDesc+"^"+admLoc;  //+"^"+LocID+"^"+PatNo;

	$('#libdatagrid').datagrid({
		url:url+'?action=QueryLibOrditemNew',	
		queryParams:{
			params:params}
	});
	$('#libdatagrid').datagrid('loadData', {total:0,rows:[]});  
}

// ����Excel
function ExportOld()
{
	var selItems = $('#libdatagrid').datagrid('getRows');
	if (!selItems.length){
		$.messager.alert('��ʾ',"<font style='color:red;font-weight:bold;font-size:20px;'>���Ȳ�ѯ��¼!</font>","error");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ���е�������", function (res) {//��ʾ�Ƿ񵼳�
		if (res) {
			var filePath=browseFolder();
			if (typeof filePath=="undefined"){
				$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ��·����,���ԣ�</font>","error");
				return;
			}
			ExportExcel(filePath);
			$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
		}
	})
}

function ExportExcel(filePath)
{
	
    var stDate=$('#stdate').datebox('getValue');
	var endDate=$('#enddate').datebox('getValue'); //��ֹ����
	var levelMan=$('#levelMan').datebox('getValue') //������
	var label=$('#label').datebox('getValue'); 
	var errReason=$('#errReason').datebox('getValue'); 
	
	var params=stDate+"^"+endDate+"^"+levelMan+"^"+label+"^"+errReason;  //+"^"+LocID+"^"+PatNo;
	
	var Datalist="";
	$.ajax({
   	   type: "POST",
       url: url,
       async: false, //ͬ��
       data: "action=GetLibOidItemExp&params="+params,
       success: function(val){
	      	 Datalist=eval(val);
       }
	});	
	if(Datalist==null){
		$.messager.alert("��ʾ:","ȡ���ݴ���");
		return;
	} 
	//1����ȡXLS��ӡ·�� 
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCPH_MR_OrdItmInfo.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet; 

	objSheet.Cells(2,2).value="'"+stDate+"��"+endDate; //��ѯ����  
	objSheet.Cells(2,7).value=session['LOGON.USERNAME']; //�Ʊ���
	objSheet.Cells(2,14).value=formatDate(0); //�Ʊ�����
	xlApp.Range(xlApp.Cells(5,1),xlApp.Cells(5+Datalist.length-1,17)).Borders.Weight = 1;//���õ�Ԫ��߿�*()
	xlApp.Range(xlApp.Cells(5,1),xlApp.Cells(5+Datalist.length-1,17)).WrapText=true; //����Ϊ�Զ�����*
	xlApp.Range(xlApp.Cells(5,1),xlApp.Cells(5+Datalist.length-1,17)).HorizontalAlignment=2; //ˮƽ���뷽ʽö��* (1-���棬2-����3-���У�4-���ң�5-��� 6-���˶��룬7-���о��У�8-��ɢ����)
	xlApp.Range(xlApp.Cells(5,1),xlApp.Cells(5+Datalist.length-1,17)).VerticalAlignment=2; //��ֱ���뷽ʽö��*(1-���ϣ�2-���У�3-���£�4-���˶��룬5-��ɢ����) �У�������Ӧ����:

	for(var k=0;k<Datalist.length;k++){
		objSheet.Cells(5+k,1).value=Datalist[k].patNo;   //�ǼǺ�
		objSheet.Cells(5+k,2).value=Datalist[k].patName; //����
		objSheet.Cells(5+k,3).value=Datalist[k].medicalNo //������		
		objSheet.Cells(5+k,4).value=Datalist[k].admLoc   //�������
		objSheet.Cells(5+k,5).value=Datalist[k].admDate; //��������
		objSheet.Cells(5+k,6).value=Datalist[k].groupFlag; //�������
		objSheet.Cells(5+k,7).value=Datalist[k].arcDesc;  //ҽ������(��Ʒ��)		
		objSheet.Cells(5+k,8).value=Datalist[k].doseQty;  //����
		objSheet.Cells(5+k,9).value=Datalist[k].unitDesc; //������λ
		objSheet.Cells(5+k,10).value=Datalist[k].phFreqDesc; //Ƶ��
		objSheet.Cells(5+k,11).value=Datalist[k].instrDesc; //�÷�
		objSheet.Cells(5+k,12).value=Datalist[k].courseDesc; //�Ƴ�
		objSheet.Cells(5+k,13).value=Datalist[k].rmanf;     //��������
		objSheet.Cells(5+k,14).value=Datalist[k].speciFaction; //�������
		objSheet.Cells(5+k,15).value=Datalist[k].levelDesc; //������
		objSheet.Cells(5+k,16).value=Datalist[k].labelDesc; //Ŀ¼
		objSheet.Cells(5+k,17).value=Datalist[k].errMsg; //��ʾ��Ϣ	
    }
    var array=formatDate(0).split("-");
	var exportName="������ҩ����¼��"+array[0]+""+array[1]+""+array[2];
	xlBook.SaveAs(filePath+exportName+".xls");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;

}

/// Description:	ʹ����Ǭ������
/// Creator:		QuNianpeng
/// CreateDate:		2017-05-26
function Export()
{
	user=session['LOGON.USERNAME']; //�Ʊ���
	markDate=formatDate(0); //�Ʊ�����
	
	var selItems = $('#libdatagrid').datagrid('getRows');
	if (!selItems.length){
		$.messager.alert('��ʾ',"<font style='color:red;font-weight:bold;font-size:20px;'>���Ȳ�ѯ��¼!</font>","error");
		return;
	}	
	$.messager.confirm("��ʾ", "�Ƿ���е�������", function (res) {//��ʾ�Ƿ񵼳�
		if(res){
			var parameter="DHCPH_MR_OrdItmInfo.raq"+"&params="+params+"&queryDate="+queryDate+"&user="+user+"&markDate="+markDate;
				DHCCPM_RQPrint(parameter);		
		}
		else{
			return;
		}
	})
}

/// Description:	��ѯ��������
/// Creator:		QuNianpeng
/// CreateDate:		2017-09-18
function Reset()
{
	$("#stdate").datebox("setValue", formatDate(-1));  
	$("#enddate").datebox("setValue", formatDate(0));  	
	$('#levelMan').combobox('setValue',"");
	$('#label').combobox('setValue',"");
	$('#admLoc').combobox('setValue',"");
	$('#label').combobox('setText',"ȫ��"); //	����comboboxĬ��ֵ	
	Query();
}

