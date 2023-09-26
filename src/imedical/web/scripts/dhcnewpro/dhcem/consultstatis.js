///qqa
var exportShowDatail="";
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID //hxy 2020-05-29
$(function(){
	
	initParams();
	
	initCombobox();
	
	initTable();
	
	initMethod ();
		
})



function initParams(){
	Model = getParam("Model");   //ģʽ��1���鿴�Լ���2���鿴���У�Ĭ�ϲ鿴�Լ�
}
	
function initCombobox(){
	$HUI.combobox("#statisType",{
		valueField: "value", 
		textField: "text",
		editable:true,
		data:[
			{
				"value":1,
				"text":$g("�����������")
			},{
				"value":2,
				"text":$g("���ս��տ���")
			},
		]
	})
	
	$HUI.combobox("#consultType",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonAllCstType&HospID="+session['LOGON.HOSPID'],
		valueField: "value", 
		textField: "text",
		editable:true,
		onLoadSuccess:function(data){
	        var data = $HUI.combobox("#consultType").getData();
	        var CstType = $HUI.combobox("#consultType").getValue();
	        if(data.length>0){
			    $HUI.combobox("#consultType").select(data[0].value);
			    $HUI.datagrid("#consultStatisTable").load({"Params":getParams()});
		    }
	    }
		
	})
	
	$HUI.combobox("#statisType").setValue(1);      //Ĭ��Ϊ���˷���
	
	$HUI.combobox("#consNature",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstProp&LgHospID="+LgHospID, //hxy 2020-05-29 add LgHospID
		valueField: "itmID", 
		textField: "itmDesc",
		editable:true
		
	})
	
	/// ��ʼ����
	$HUI.datebox("#stDate").setValue(GetCurSystemDate(-7));
	/// ��������
	$HUI.datebox("#endDate").setValue(GetCurSystemDate(0));
}
	
function initTable(){
	var columns=[[
		{ field: 'CstRLoc',align: 'center', title: '�������',width:50},
		{ field: 'CsLocDesc',align: 'center', title: '�������',width:250,hidden:true},
		{ field: 'CareProvTpDesc',align: 'center', title: '����ְ��',width:50},
		{ field: 'CsUserDesc',align: 'center', title: '����ҽʦ',width:50},
		{ field: 'Number',align: 'center', title: '�������',width:50,formatter:formNumber},
		{ field: 'OverTimeNumber',align: 'center', title: '��ʱ����',width:50,formatter:formOverTimeNumber},
		{ field: 'OrdAllPress',align: 'center', title: '������',width:50},
		{ field: 'ConsItms',align: 'center', title: 'Itms',width:50,hidden:true}
	]];
	$HUI.datagrid("#consultStatisTable",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultStatisQuery&MethodName=GetConsultList",
		queryParams:{
			Params:getParams()
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:false,
		onClickRow:function(rowIndex, rowData){

	    },
	    onDblClickRow: function (rowIndex, rowData) {

        }
	})
	
	var columns=[[
		{ field: 'CstRLoc',align: 'center', title: '�������',width:50},
		{ field: 'CstRUser',align: 'center', title: '������',width:250,hidden:true},
		{ field: 'CstLoc',align: 'center', title: '�������',width:50},
		{ field: 'CstRDate',align: 'center', title: '��������',width:50},
		{ field: 'CstRTime',align: 'center', title: '����ʱ��',width:50},
		{ field: 'CmpDate',align: 'center', title: '�������',width:50},
		{ field: 'CmpTime',align: 'center', title: '���ʱ��',width:50},
		{ field: 'PatName',align: 'center', title: '��������',width:50},
		{ field: 'CstType',align: 'center', title: '��������',width:50},
		{ field: 'EpisodeID',align: 'center', title: '���˾���',width:50},
		{ field: 'Detail',align: 'center', title: '��ϸ',width:20,formatter:formatDetail}
	]];
	
	///������ϸ
	$HUI.datagrid("#consDetailTable",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultStatisQuery&MethodName=GetConsultDetailList",
		queryParams:{
			Params:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true
	})
	
}
	
function initMethod(){
	
}

/// ��ѯͳ���б�
function commonQuery(){
	$HUI.datagrid("#consultStatisTable").load({"Params":getParams()});
	var statisType = $HUI.combobox("#statisType").getValue()==undefined?"":$HUI.combobox("#statisType").getValue();
	if(statisType==1){
		$('#consultStatisTable').datagrid('showColumn','CstRLoc'); 
		$('#consultStatisTable').datagrid('hideColumn','CsLocDesc');
	}else if(statisType==2){
		$('#consultStatisTable').datagrid('showColumn','CsLocDesc'); 	
		$('#consultStatisTable').datagrid('hideColumn','CstRLoc');
	}
	if(!$HUI.checkbox("#showDetail").getValue()){
		$('#consultStatisTable').datagrid('hideColumn','CsUserDesc'); 	
	}
	if($HUI.checkbox("#showDetail").getValue()){
		$('#consultStatisTable').datagrid('showColumn','CsUserDesc'); 	
	}
}

function getParams(){
	var stDate = $HUI.datebox("#stDate").getValue(); /// ��ʼ����
	var endDate = $HUI.datebox("#endDate").getValue();     /// ��������
	var statisType = $HUI.combobox("#statisType").getValue()==undefined?"":$HUI.combobox("#statisType").getValue();    	 /// ״̬
	var consultType = $HUI.combobox("#consultType").getValue()==undefined?"":$HUI.combobox("#consultType").getValue();
	var showDetail = $HUI.checkbox("#showDetail").getValue()?"Y":"N"; 
	var consNature = $HUI.combobox("#consNature").getValue()==undefined?"":$HUI.combobox("#consNature").getValue();
	exportShowDatail = showDetail;
	if(Model=="2") LocID=""
    /// ���¼��ػ����б�
	var params = stDate+"^"+endDate+"^"+statisType+"^"+showDetail+"^"+LocID+"^"+consultType+"^"+consNature;
	return params;
}

function commonExport(){
	var datas = $('#consultStatisTable').datagrid("getData");
	exportData(datas.rows);
}

function formNumber(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowConsultDetail(\''+rowData.ConsItms+'\')">&nbsp;'+value+'&nbsp;</a>';
}

function formOverTimeNumber(value, rowData, rowIndex){	
	return '<a style="text-decoration:underline" href="#" onclick="ShowConsultDetail(\''+rowData.OverTimeItmIDs+'\')">&nbsp;'+value+'&nbsp;</a>';

}

function formatDetail(value, rowData, rowIndex){
	return '<a href="#" onclick="openCstDetail(\''+rowData.CstID+'\',\''+rowData.CstItmID+'\')"><img src="../scripts/dhcnewpro/images/adv_sel_8.png" border="0/"></a>';
}

function openCstDetail(cstID,cstItmID){
	OpenConsWin();
	$("#newWinFrame").attr("src","dhcem.consultwrite.csp?CstID="+cstID+"&CstItmID="+cstItmID+"&seeCstType=1");
	return;
}

///��ѯ������ϸ
function ShowConsultDetail(value){
	$HUI.datagrid("#consDetailTable").load({"Params":value});	
	$HUI.window("#consDetailWin").open();
}

function exportData(datas){
	var stDate = $HUI.datebox("#stDate").getValue(); /// ��ʼ����
	var endDate = $HUI.datebox("#endDate").getValue();     /// ��������
	if(datas.length==0){
		$.messager.alert("��ʾ","���赼�����ݣ�");
		return;	
	}
	
	var Str = "(function test(x){"+
	"var xlApp = new ActiveXObject('Excel.Application');"+
	"var xlBook = xlApp.Workbooks.Add();"+
	"var objSheet = xlBook.ActiveSheet;";
	var beginRow=2;
	var colNuber=0;;
	for (var i=0;i<datas.length;i++){
		colNuber=0;
		Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+((datas[i].CstRLoc)||(datas[i].CsLocDesc))+"';"+ //�������
		"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].CareProvTpDesc+"';";			  //����ְ��
		if(exportShowDatail=="Y"){
			Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].CsUserDesc+"';"	 //����ҽʦ
		}
		Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].Number+"';"+	//�������
		"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].OverTimeNumber+"';"+	//��ʱ����
		"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].OrdAllPress+"';";	 	//������		
	}
	
	colNuber=0;
	Str=Str+"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='"+(typeof datas[0].CstRLoc != "undefined"?"�������":"�������")+"';"+    //�������
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='����ְ��';"; 	 //����ְ��
	if(exportShowDatail=="Y"){
		Str=Str+"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='����ҽʦ';";	 //����ҽʦ
	}
	Str=Str+"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='�������';"+	//�������
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='��ʱ����';"+			//��ʱ����	
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='������';"	 		//������	
	
	Str=Str+"xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,"+colNuber+")).MergeCells = true;"+ //�ϲ���Ԫ��
	"objSheet.Cells(1,1).value= 'ͳ��ʱ��:"+stDate+"��"+endDate+"';";
	
	var row1=beginRow,row2=datas.length+beginRow,c1=1,c2=colNuber;
	Str=Str+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;"+
	"xlApp.Visible=true;"+
	"xlApp=null;"+
	"xlBook=null;"+
	"objSheet=null;"+
    "return 1;}());";
    //����Ϊƴ��Excel��ӡ����Ϊ�ַ���
    CmdShell.notReturn = 1;   //�����޽�����ã�����������
	var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
	return;
}


function exportDataOld(datas){
	var stDate = $HUI.datebox("#stDate").getValue(); /// ��ʼ����
	var endDate = $HUI.datebox("#endDate").getValue();     /// ��������
	if(datas.length==0){
		$.messager.alert("��ʾ","���赼�����ݣ�");
		return;	
	}
	//var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	//var Template = path+"DHCEM_Consult_Statis.xls";
	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add();
	var objSheet = xlBook.ActiveSheet;
	var beginRow=2;	
	var colNuber=0;
	for (var i=0;i<datas.length;i++){
		colNuber=0;
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=(datas[i].CstRLoc)||(datas[i].CsLocDesc); //�������
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].CareProvTpDesc; //����ְ��
		if(exportShowDatail=="Y"){
			objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].CsUserDesc;	 //����ҽʦ
		}
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].Number;		     //�������
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].OverTimeNumber;	 //��ʱ����
		objSheet.Cells(i+beginRow+1,colNuber+=1).value=datas[i].OrdAllPress;	 //������		
	}
	
	colNuber=0;
	objSheet.Cells(beginRow,colNuber+=1).value=(typeof datas[0].CstRLoc != "undefined"?"�������":"�������");    //�������
	objSheet.Cells(beginRow,colNuber+=1).value="����ְ��"; 	 //����ְ��
	if(exportShowDatail=="Y"){
		objSheet.Cells(beginRow,colNuber+=1).value="����ҽʦ";	 //����ҽʦ
	}
	objSheet.Cells(beginRow,colNuber+=1).value="�������";	 //�������
	objSheet.Cells(beginRow,colNuber+=1).value="��ʱ����";	 //��ʱ����	
	objSheet.Cells(beginRow,colNuber+=1).value="������";	 //������	
	
	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,colNuber)).MergeCells = true; //�ϲ���Ԫ��
	objSheet.Cells(1,1).value= "ͳ��ʱ��:"+stDate+"��"+endDate
	gridlist(objSheet,beginRow,datas.length+beginRow,1,colNuber);
	
	xlApp.Visible=true;
	xlApp=null;
	xlBook=null;
	objSheet=null;	
}

function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=2
}

/// ��MDT��дҳ��
function OpenConsWin(){
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true",
		iconCls:'icon-w-card'
	};
	new WindowUX($g('������ϸ��ѯ'), 'ConsWin', '930', '560', option).Init();
}


/// ��ȡϵͳ��ǰ����
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}