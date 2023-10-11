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
		editable:false, //hxy 2021-04-19 true->false ��Ϊ��ѡ������Ϊ��
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
	
	$HUI.combobox("#consLoc",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote'
	})
	if(Model==2){
		$HUI.combobox("#consLoc").enable();
	}else{
		$HUI.combobox("#consLoc").setValue(LocID);
	}
	
	/// ��ʼ����
	$HUI.datebox("#stDate").setValue(GetCurSystemDate(-7));
	/// ��������
	$HUI.datebox("#endDate").setValue(GetCurSystemDate(0));
}
	
function initTable(){
	var columns=[[
		{ field: 'CstRLoc',align: '', title: '�������',width:50},
		{ field: 'CsLocDesc',align: '', title: '�������',width:250,hidden:true},
		{ field: 'CareProvTpDesc',align: '', title: '����ְ��',width:50},
		{ field: 'CsUserDesc',align: '', title: '������',width:50},
		{ field: 'Number',align: 'center', title: '�������',width:50,formatter:formNumber},
		{ field: 'OverTimeNumber',align: 'center', title: '��ʱ����',width:50,formatter:formOverTimeNumber},
		{ field: 'RefNumber',align: 'center', title: '���ջ������',width:50,formatter:formRefNumber}, //hxy 2021-04-06 st
		{ field: 'RejNumber',align: 'center', title: '���ػ������',width:50,formatter:formRejNumber}, //ed
		{ field: 'OrdAllPress',align: 'center', title: '������',width:50},
		{ field: 'ConsItms',align: '', title: 'Itms',width:50,hidden:true}
	]];
	$HUI.datagrid("#consultStatisTable",{
		title:$g('����ͳ��'), //hxy 2023-02-06 st
		iconCls:'icon-paper',
		toolbar:"#toolbar",
		headerCls:'panel-header-gray', //ed
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
		{ field: 'CstRLoc',align: 'left', title: '�������',width:90},
		{ field: 'CstRUser',align: 'left', title: '������',width:50,hidden:true},
		{ field: 'CstLoc',align: 'left', title: '�������',width:90},
		{ field: 'CstRDate',align: 'left', title: '��������',width:90},
		{ field: 'CstRTime',align: 'left', title: '����ʱ��',width:70},
		{ field: 'ArrDate',align: 'left', title: '��������',width:90}, //hxy 2021-04-03 st
		{ field: 'ArrTime',align: 'left', title: '����ʱ��',width:70}, //ed
		{ field: 'CmpDate',align: 'left', title: '�������',width:90},
		{ field: 'CmpTime',align: 'left', title: '���ʱ��',width:70},
		{ field: 'OverTimeVal',align: 'left', title: '��ʱʱ��',width:70}, //hxy 2021-04-03
		{ field: 'PatName',align: 'left', title: '��������',width:70},
		{ field: 'CstType',align: 'left', title: '��������',width:70},
		//{ field: 'Detail',align: 'center', title: '��ϸ',width:60,formatter:formatDetail},
		{ field: 'Detail',align: 'left', title: '��ϸ',width:40,formatter:closedLoop},
		{ field: 'EpisodeID',align: 'left', title: '�����',width:60},
		{ field: 'RefUser',align: 'left', title: '������',width:60,hidden:true}, //hxy 2021-05-06 st
		{ field: 'RefRea',align: 'left', title: '����ԭ��',width:120,hidden:true},
		{ field: 'RejUser',align: 'left', title: '������',width:60,hidden:true},
		{ field: 'RejRea',align: 'left', title: '����ԭ��',width:120,hidden:true} //ed
	]];
	
	///������ϸ
	$HUI.datagrid("#consDetailTable",{
		bodyCls:'panel-header-gray',//hxy 2023-02-06
		url:LINK_CSP+"?ClassName=web.DHCEMConsultStatisQuery&MethodName=GetConsultDetailList",
		queryParams:{
			Params:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:false, //hxy 2021-05-06 true->false
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
	var TypeDesc = $HUI.combobox("#consultType").getText()==undefined?"":$HUI.combobox("#consultType").getText(); //2020-09-22 st
	if(TypeDesc.indexOf("Ժ��")>-1){
		$.messager.alert("��ʾ","Ժ�ʻ��ﲻ�����ͳ�Ʒ�Χ��");
		$('#consultStatisTable').datagrid('loadData', { total: 0, rows: [] });  
		return;	
	} //ed
	$HUI.datagrid("#consultStatisTable").load({"Params":getParams()});
	var statisType = $HUI.combobox("#statisType").getValue()==undefined?"":$HUI.combobox("#statisType").getValue();
	if(statisType==1){
		$('#consultStatisTable').datagrid('showColumn','CstRLoc'); 
		$('#consultStatisTable').datagrid('hideColumn','CsLocDesc');
	}else if(statisType==2){
		$('#consultStatisTable').datagrid('showColumn','CsLocDesc'); 	
		$('#consultStatisTable').datagrid('hideColumn','CstRLoc');
	}
	if(!$HUI.radio("#showDetail").getValue()){ //checkbox
		$('#consultStatisTable').datagrid('hideColumn','CsUserDesc'); 	
	}
	if($HUI.radio("#showDetail").getValue()){ //checkbox
		$('#consultStatisTable').datagrid('showColumn','CsUserDesc'); 	
	}
}

function getParams(){
	var stDate = $HUI.datebox("#stDate").getValue(); /// ��ʼ����
	var endDate = $HUI.datebox("#endDate").getValue();     /// ��������
	var statisType = $HUI.combobox("#statisType").getValue()==undefined?"":$HUI.combobox("#statisType").getValue();    	 /// ״̬
	var consultType = $HUI.combobox("#consultType").getValue()==undefined?"":$HUI.combobox("#consultType").getValue();
	var showDetail = $HUI.radio("#showDetail").getValue()?"Y":"N"; //checkbox
	var consNature = $HUI.combobox("#consNature").getValue()==undefined?"":$HUI.combobox("#consNature").getValue();
	exportShowDatail = showDetail;
	if(Model=="2") LocID=""
	LocID = $HUI.combobox("#consLoc").getValue()==undefined?"":$HUI.combobox("#consLoc").getValue();
    /// ���¼��ػ����б�
	var params = stDate+"^"+endDate+"^"+statisType+"^"+showDetail+"^"+LocID+"^"+consultType+"^"+consNature+"^"+LgHospID;
	return params;
}

function commonExport(){
	var datas = $('#consultStatisTable').datagrid("getData");
	exportData(datas.rows);
}

function formNumber(value, rowData, rowIndex){
	return '<a style="text-decoration:none" href="#" onclick="ShowConsultDetail(\''+rowData.ConsItms+'\')">&nbsp;'+value+'&nbsp;</a>'; //underline
}

function formOverTimeNumber(value, rowData, rowIndex){	
	return '<a style="text-decoration:none" href="#" onclick="ShowConsultDetail(\''+rowData.OverTimeItmIDs+'\')">&nbsp;'+value+'&nbsp;</a>';

}

function formRefNumber(value, rowData, rowIndex){	
	return '<a style="text-decoration:none" href="#" onclick="ShowConsultDetail(\''+rowData.RefItms+'\',25)">&nbsp;'+value+'&nbsp;</a>';
}

function formRejNumber(value, rowData, rowIndex){	
	return '<a style="text-decoration:none" href="#" onclick="ShowConsultDetail(\''+rowData.RejItms+'\',22)">&nbsp;'+value+'&nbsp;</a>';
}

function formatDetail(value, rowData, rowIndex){
	return '<a href="#" onclick="openCstDetail(\''+rowData.CstID+'\',\''+rowData.CstItmID+'\',\''+rowData.TypeCode+'\')"><img src="../scripts/dhcnewpro/images/adv_sel_8.png" border="0/"></a>';
}

function openCstDetail(cstID,cstItmID,TypeCode){
	OpenConsWin();
	if(TypeCode=="NUR"){ //hxy 2020-09-18 st
		if ('undefined'!==typeof websys_getMWToken){
			$("#newWinFrame").attr("src","dhcem.consultnur.csp?CstID="+cstID+"&CstItmID="+cstItmID+"&seeCstType=1"+"&MWToken="+websys_getMWToken());
		}else{
		$("#newWinFrame").attr("src","dhcem.consultnur.csp?CstID="+cstID+"&CstItmID="+cstItmID+"&seeCstType=1");
		}
	}else{ //ed
		if ('undefined'!==typeof websys_getMWToken){
			$("#newWinFrame").attr("src","dhcem.consultwrite.csp?CstID="+cstID+"&CstItmID="+cstItmID+"&seeCstType=1"+"&MWToken="+websys_getMWToken());
		}else{
		$("#newWinFrame").attr("src","dhcem.consultwrite.csp?CstID="+cstID+"&CstItmID="+cstItmID+"&seeCstType=1");
		}
	}
	return;
}

/// �ջ� bianshuai 2021-07-30
function closedLoop(value, rowData, rowIndex){
	//return '<a href="#" onclick="openClosedLoop(\''+rowData.Oeori+'\')"><img src="../scripts/dhcnewpro/images/adv_sel_8.png" border="0/"></a>';
	return '<a href="#" onclick="openClosedLoop(\''+rowData.Oeori+'\',\''+rowData.CstItmID+'\')"><img src="../scripts/dhcnewpro/images/adv_sel_8.png" border="0/"></a>';
}

/// �ջ� bianshuai 2021-07-30
function openClosedLoop(Oeori,CstItmID){

	//var lnk = "dhc.orderview.csp?ord="+Oeori; //hxy 2022-07-05 st
	var lnk = "dhc.orderview.csp?ord="+Oeori+"&ordViewType=CST&ordViewBizId="+CstItmID; //ed
	websys_showModal({
		url: lnk,
		height:640,
		width:1280, //hxy 2021-05-07 890->1280 ���õ������ɹر�
		iconCls:"icon-w-paper",
		title: $g('������ϸ'),
		closed: true,
		onClose:function(){}
	});	
}

///��ѯ������ϸ
function ShowConsultDetail(value,code){
	$('#consDetailTable').datagrid('hideColumn','RefUser'); //hxy 2021-05-06 st
	$('#consDetailTable').datagrid('hideColumn','RefRea');
	$('#consDetailTable').datagrid('hideColumn','RejUser'); 	
	$('#consDetailTable').datagrid('hideColumn','RejRea');
	if(code==25){
		$('#consDetailTable').datagrid('showColumn','RefUser'); 	
		$('#consDetailTable').datagrid('showColumn','RefRea');
	}else if(code==22){
		$('#consDetailTable').datagrid('showColumn','RejUser'); 	
		$('#consDetailTable').datagrid('showColumn','RejRea');
	} //ed
	
	$HUI.datagrid("#consDetailTable").load({"Params":value});	
	$HUI.window("#consDetailWin").open();
}

function exportData(datas){
	var stDate = $HUI.datebox("#stDate").getValue(); /// ��ʼ����
	var endDate = $HUI.datebox("#endDate").getValue();     /// ��������
	var CstType = $HUI.combobox("#consultType").getText(); ///�������� hxy 2021-04-15 st
	var Nature = $HUI.combobox("#consNature").getText();   ///��������
	var Note="";
	if((CstType!="")&&(CstType!=undefined)){
		CstType="��������:"+CstType+"  ";
	}
	if((Nature!="")&&(Nature!=undefined)){
		Nature="��������:"+Nature+"  ";
	}
	Note=CstType+Nature; //ed

	if(datas.length==0){
		$.messager.alert("��ʾ","���赼�����ݣ�");
		return;	
	}
	
	var Str = "(function test(x){"+
	"var xlApp = new ActiveXObject('Excel.Application');"+
	"var xlBook = xlApp.Workbooks.Add();"+
	"var objSheet = xlBook.ActiveSheet;";
	var beginRow=2;
	if(Note!=""){beginRow=3;} //hxy 2021-04-15
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
		"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].RefNumber+"';"+	        //���ջ������ hxy 2021-04-19 st
		"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].RejNumber+"';"+	        //���ػ������ ed
		"objSheet.Cells("+(i+beginRow+1)+","+(colNuber+=1)+").value='"+datas[i].OrdAllPress+"';";	 	//������		
	}
	
	colNuber=0;
	Str=Str+"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='"+(typeof datas[0].CstRLoc != "undefined"?"�������":"�������")+"';"+    //�������
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='����ְ��';"; 	 //����ְ��
	if(exportShowDatail=="Y"){
		Str=Str+"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='������';";	 //����ҽʦ
	}
	Str=Str+"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='�������';"+	//�������
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='��ʱ����';"+			//��ʱ����	
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='���ջ������';"+	    //���ջ������ hxy 2021-04-19 st
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='���ػ������';"+		//���ػ������ ed
	"objSheet.Cells("+beginRow+","+(colNuber+=1)+").value='������';"	 		//������	
	
	Str=Str+"xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,"+colNuber+")).MergeCells = true;"+ //�ϲ���Ԫ��
	"objSheet.Cells(1,1).value= 'ͳ��ʱ��:"+stDate+"��"+endDate+"';";
	
	if(Note!=""){ //hxy 2021-04-15
		Str=Str+"xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(2,"+colNuber+")).MergeCells = true;"+ //�ϲ���Ԫ��
		"objSheet.Cells(2,1).value= '"+Note+"';";
	}
	Str=Str+"objSheet.Columns.AutoFit;"; //hxy 2021-04-19
	
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
	var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 
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
		objSheet.Cells(beginRow,colNuber+=1).value="������";	 //����ҽʦ
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