///qqa
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var CstTypeArr = [{"value":"A","text":$g('ƽ���ﳬʱ')}, {"value":"B","text":$g('�����ﳬʱ')}];
$(function(){
	
	initParams();
	
	initCombobox();
	
	initTable();

	initMethod ();
	
})



function initParams(){
	episodeID = getParam("EpisodeID");
}
	
function initCombobox(){
   var LgLocID = session['LOGON.CTLOCID'];
	/// ��ʼ����
	$HUI.datebox("#stDate").setValue(GetCurSystemDate(-7));
	/// ��������
	$HUI.datebox("#endDate").setValue(GetCurSystemDate(0));
	
	$HUI.combobox("#consultStauts",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsStatus&MethodName=jsonConsStat&HospID="+HospID,
		valueField: "value", 
		textField: "text",
		editable:true,
	})
	$HUI.combobox("#consultStauts").setValue(3);
	
	$HUI.combobox("#consultLoc",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+HospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote'
	})
	
	$HUI.combobox("#consRLoc",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+HospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote'
	})
	$HUI.combobox("#consRLoc").setValue(session['LOGON.CTLOCID']); /// Ĭ�ϵ�ǰ��¼���� bianshuai 2018-12-11
    
	if(LgLocID=="95"){
    $("#consRLoc").attr("readOnly",true); 
	}
    
   $HUI.combobox("#crsTime",{
		//url: LINK_CSP+"?ClassName=web.DHCEMConsStatus&MethodName=jsonConsStat&HospID="+HospID,
		data:CstTypeArr,
		valueField: "value", 
		textField: "text",
		editable:true
	})
}
	
function initTable(){
	
	var columns=[[
		{ field: 'CstID',align: 'center', title: 'CstID',hidden:true},
		{ field: 'CstItmID',align: 'center', title: 'CstItmID',hidden:true},
		{ field: 'Detail',align: 'center', title: '��ϸ',width:40,formatter:formatDetail},
		{ field: 'CstRLoc',align: 'center', title: '�������',width:100},
		{ field: 'CstUser',align: 'center', title: '������',width:100},
		{ field: 'CstLoc',align: 'center', title: '�������',width:200},
		{ field: 'CareProv',align: 'center', title: '����ҽ��',width:120},
		{ field: 'PatName',align: 'center', title: '��������',width:120},
		{ field: 'PatSex',align: 'center', title: '�Ա�',width:60},
		{ field: 'PatWard',align: 'center', title: '����',width:150},
		{ field: 'PatBed',align: 'center', title: '����',width:80},
		{ field: 'PatDiagDesc',align: 'center', title: '���',width:180},
		{ field: 'CstTrePro',align: 'center', title: '��Ҫ��ʷ',width:180,formatter:SetCellField},
		{ field: 'CstPurpose',align: 'center', title: '�������ɼ�Ҫ��',width:180,formatter:SetCellField},
		{ field: 'CsOpinion',align: 'center', title: '�������',width:250},
		{ field: 'CstDate',align: 'center', title: '��������',width:120},
		{ field: 'CstTime',align: 'center', title: '����ʱ��',width:120},
		{ field: 'CstNDate',align: 'center', title: '��������',width:120},
		{ field: 'CstNTime',align: 'center', title: '����ʱ��',width:120},
		{ field: 'CstStatus',align: 'center', title: '��ǰ״̬',width:120},
		{ field: 'CstType',align: 'center', title: '��������',width:120}
	]];
	$HUI.datagrid("#mainLisTable",{
		url:LINK_CSP+"?ClassName=web.DHCEMFindConsult&MethodName=GetConsultList",
		queryParams:{
			Params:getParams()
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		autoSizeColumn:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		nowrap:false,
		onClickRow:function(rowIndex, rowData){
			if(rowData.CstStatus=="���"){
				$("#bt_off").linkbutton("disable");
			}else{
				$("#bt_off").linkbutton("enable");
			}
	    },
	    onDblClickRow: function (rowIndex, rowData) {

        }
	})

}

/// ���������ַ�
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}
	
function initMethod(){
	
}
function commonPrint(){
		
}

function commonExport(){
	runClassMethod("web.DHCEMFindConsult","GetExportDate",{"UserID":UserID},function(retData){
		exportExecl(retData);
	})		
}

function exportExecl(data){
	var stDate = $HUI.datebox("#stDate").getValue(); 				/// ��ʼ����
	var endDate = $HUI.datebox("#endDate").getValue();     			/// ��������
	if(!data.length){
		$.messager.alert("��ʾ","���赼�����ݣ�");
		return;	
	}
	var Str = "(function test(x){"+
	"var xlApp = new ActiveXObject('Excel.Application');"+
	"var xlBook = xlApp.Workbooks.Add();"+
	"var objSheet = xlBook.ActiveSheet;"+
	"xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,14)).MergeCells = true;"+ //�ϲ���Ԫ��
	"objSheet.cells(1,1).Font.Bold = true;"+
	"objSheet.cells(1,1).Font.Size =24;"+
	"objSheet.cells(1,1).HorizontalAlignment = -4108;"+
	"objSheet.Cells(1,1).value='ͳ��ʱ��:"+stDate+"��"+endDate+"';";
	var beginRow=2;
	Str=Str+"objSheet.Cells(2,1).value='�������';"+ 
	"objSheet.Cells(2,2).value='������';"+    
	"objSheet.Cells(2,3).value='�������';"+	 
	"objSheet.Cells(2,4).value='��������';"+ 	
	"objSheet.Cells(2,5).value='�Ա�';"+ 	 
	"objSheet.Cells(2,6).value='����';"+ 
	"objSheet.Cells(2,7).value='����';"+ 
	"objSheet.Cells(2,8).value='���';"+ 
	"objSheet.Cells(2,9).value='��Ҫ��ʷ';"+ 
	"objSheet.Cells(2,10).value='����Ŀ��';"+ 
	"objSheet.Cells(2,11).value='��������';"+ 
	"objSheet.Cells(2,12).value='����ʱ��';"+ 	 
	"objSheet.Cells(2,13).value='��ǰ״̬';"+ 	 
	"objSheet.Cells(2,14).value='��������';";	 
	Str=Str+"objSheet.Columns(11).NumberFormatLocal='@';"; //hxy 2020-04-14
	for (var i=0;i<data.length;i++){
		Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+1+").value='"+data[i].CstRLoc+"';"+       
		"objSheet.Cells("+(i+beginRow+1)+","+2+").value='"+data[i].CstUser+"';"+      
		"objSheet.Cells("+(i+beginRow+1)+","+3+").value='"+data[i].CstLoc+"';"+  
		"objSheet.Cells("+(i+beginRow+1)+","+4+").value='"+data[i].PatName+"';"+ 	 
		"objSheet.Cells("+(i+beginRow+1)+","+5+").value='"+data[i].PatSex+"';"+ 
		"objSheet.Cells("+(i+beginRow+1)+","+6+").value='"+data[i].PatWard+"';"+ 	 
		"objSheet.Cells("+(i+beginRow+1)+","+7+").value='"+data[i].PatBed+"';"+ 	
		"objSheet.Cells("+(i+beginRow+1)+","+8+").value='"+data[i].PatDiagDesc+"';"+ 
		"objSheet.Cells("+(i+beginRow+1)+","+9+").value='"+data[i].CstTrePro.replace(/\n/g,"\\n").replace(/\'/g,"\\'")+"';"+ 			
		"objSheet.Cells("+(i+beginRow+1)+","+10+").value='"+data[i].CstPurpose.replace(/\n/g,"\\n").replace(/\'/g,"\\'")+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+11+").value='"+data[i].CstDate+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+12+").value='"+data[i].CstTime+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+13+").value='"+data[i].CstStatus+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+14+").value='"+data[i].CstType+"';";			
	}
	var row1=beginRow,row2=data.length+beginRow,c1=1,c2=14;
	Str=Str+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;"+
	"xlApp.Range(xlApp.Cells(1,8),xlApp.Cells("+data.length+beginRow+",8)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,9),xlApp.Cells("+data.length+beginRow+",9)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,10),xlApp.Cells("+data.length+beginRow+",10)).WrapText = true;"+
	"xlApp.Visible=true;"+
	"objSheet.Columns.AutoFit;"+
	"xlApp=null;"+
	"xlBook=null;"+
	"objSheet=null;"+
	"return 1;}());";
	 //����Ϊƴ��Excel��ӡ����Ϊ�ַ���
    CmdShell.notReturn = 1;   //�����޽�����ã�����������
	var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
	return;	
}

/// ��ѯͳ���б�
function commonQuery(){
	$HUI.datagrid("#mainLisTable").load({"Params":getParams()});
}

function commonOff(){
	var rows = $HUI.datagrid("#mainLisTable").getSelections();
	if(!rows.length){
		$.messager.alert("��ʾ","��ѡ��һ�����ݣ�");
		return;
	}
	var CstID = rows[0].CstID;
	runClassMethod("web.DHCEMConsult","CanCstNo",{"CstID":CstID,"UserID":UserID},function(retString){
		if(retString==0){
			$.messager.alert("��ʾ","���ϳɹ�!");
			commonQuery();    //ˢ��
		}
	},'text')	
}

function getParams(){
	var stDate = $HUI.datebox("#stDate").getValue(); 				/// ��ʼ����
	var endDate = $HUI.datebox("#endDate").getValue();     			/// ��������
	var cstRLocID = $HUI.combobox("#consRLoc").getValue()==undefined?"":$HUI.combobox("#consRLoc").getValue();   //�������
	var cstLocID = $HUI.combobox("#consultLoc").getValue()==undefined?"":$HUI.combobox("#consultLoc").getValue();      //���տ���
	var cstStauts = $HUI.combobox("#consultStauts").getValue()==undefined?"":$HUI.combobox("#consultStauts").getValue(); //״̬
	var crsTime ="" ; 
	//$HUI.combobox("#crsTime").getValue()==undefined?"":$HUI.combobox("#crsTime").getValue(); //�Ƿ�ʱ
    /// ���¼��ػ����б�
	var params = stDate+"^"+endDate+"^"+cstRLocID+"^"+cstLocID+"^"+cstStauts+"^"+UserId+"^"+crsTime+"^"+LgHospID;
	return params;
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


function formatDetail(value, rowData, rowIndex){
	return '<a href="#" onclick="openCstDetail(\''+rowData.CstID+'\',\''+rowData.CstItmID+'\')"><img src="../scripts/dhcnewpro/images/adv_sel_8.png" border="0/"></a>';
}

function openCstDetail(CstID,CstItmID){
	var lnk = "dhcem.consultwrite.csp?CstID="+CstID+"&CstItmID="+CstItmID+"&seeCstType=1"
	websys_showModal({
		url: lnk,
		height:640,
		width:890,
		iconCls:"icon-w-paper",
		title: $g('������ϸ'),
		closed: true,
		onClose:function(){}
	});	
}