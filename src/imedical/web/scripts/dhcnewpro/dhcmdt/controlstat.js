//===========================================================================================
// ���ߣ�      yangyongtao
// ��д����:   2020-08-17
// ����:	   mdt��������ʿ�ͳ��
//===========================================================================================
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ�����˻�����Ϣ
	InitPatInfoPanel();
	
	/// ��ʼ�����ز����б�
	InitPatList();
}

/// ��ʼ�����˻�����Ϣ
function InitPatInfoPanel(){
	
	/// ��ʼ����
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-7));
	
	/// ��������
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// ���Ѳ���
	$HUI.combobox("#mdtDisGrp",{
		//url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+LgHospID,
		url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+LgHospID+"&MWToken="+websys_getMWToken(),
		valueField:'value',
		textField:'text',
		onSelect:function(option){

	    }	
	})
	
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPatList(){
	///  ����columns
	var columns=[[
	    {field:'DisGroup',title:'MDT��',width:120},
	    {field:'GrpNum',title:'������',width:80},
	    //{field:'OneNum',title:'ռ��',width:80},
	    //{field:'OneNum',title:'���ﲡ����',width:120},
		//{field:'OneGdp',title:'ռ��',width:80},
		{field:'OneNum',title:'���ڲ�����',width:100},
		{field:'OneGdp',title:'ռ��',width:80},
		{field:'TwoNum',title:'�ֲ����ڲ�����',width:120},
		{field:'TwoGdp',title:'ռ��',width:80},
		{field:'ThreeNum',title:'���ڲ�����',width:100},
		{field:'ThreeGdp',title:'ռ��',width:80}
	
		
	]];
	
	///  ����datagrid
	var option = {
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		fitColumns:true
	};
	/// ��������
	var params = getParams()
	var uniturl = $URL+"?ClassName=web.DHCMDTStatistics&MethodName=JsGetControlStat&Params="+params+"&MWToken="+websys_getMWToken();
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// ��ѯ
function QryPatList(){
	var params = getParams()
	$("#bmDetList").datagrid("load",{"Params":params}); 
}

function getParams(){
	var params="";
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue()||"";  /// ���Ѳ���
	params = StartDate +"^"+ EndDate +"^"+ mdtDisGrp
	return params;	
}

/// ��ȡϵͳ��ǰ����
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCMDTCom","GetCurSysTime",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

//����
function Export(){
	var datas = $('#bmDetList').datagrid("getData");
	ExportData(datas.rows);
}


function ExportData(datas){
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var str ='(function test(x){'
	+'\n'+'var xlApp = new ActiveXObject("Excel.Application");'
	+'\n'+'var xlBook = xlApp.Workbooks.Add("");'
	+'\n'+'var objSheet = xlBook.ActiveSheet;'
	+'\n'+'xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,8)).MergeCells = true;'
	+'\n'+'xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,8)).Font.Bold = true;'
	+'\n'+'objSheet.cells(1,1).Font.Bold = true;'
	+'\n'+'objSheet.cells(1,1).Font.Size =24;'
	+'\n'+'objSheet.cells(1,1).HorizontalAlignment = -4108;'
	+'\n'+'objSheet.Columns(3).NumberFormatLocal="@";'
	+'\n'+'objSheet.Cells(1,1).value="ͳ��ʱ��:'+StartDate+'��'+EndDate+'";'
	var beginRow=2;	
	for (var i=0;i<datas.length;i++){
		str=str
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',1).value="'+datas[i].DisGroup+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',2).value="'+datas[i].GrpNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',3).value="'+datas[i].OneNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',4).value="'+datas[i].OneGdp+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',5).value="'+datas[i].TwoNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',6).value="'+datas[i].TwoGdp+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',7).value="'+datas[i].ThreeNum+'";'
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',8).value="'+datas[i].ThreeGdp+'";'	
	}
	str=str
	+'\n'+'objSheet.Cells('+beginRow+',1).value="MDT��";'
	+'\n'+'objSheet.Cells('+beginRow+',2).value="������";'
	+'\n'+'objSheet.Cells('+beginRow+',3).value="���ڲ�����";'
	+'\n'+'objSheet.Cells('+beginRow+',4).value="ռ��";'
	+'\n'+'objSheet.Cells('+beginRow+',5).value="�ֲ����ڲ�����";'
	+'\n'+'objSheet.Cells('+beginRow+',6).value="ռ��";'
	+'\n'+'objSheet.Cells('+beginRow+',7).value="���ڲ�����";'
	+'\n'+'objSheet.Cells('+beginRow+',8).value="ռ��";'

	
	var row1=beginRow,row2=datas.length+beginRow,c1=1,c2=8
	str=str
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(1).LineStyle=1;'
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(1).Weight=2;'
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(2).LineStyle=1;'
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(2).Weight=2;'
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(3).LineStyle=1;'
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(3).Weight=2;'
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(4).LineStyle=1;'
	+'\n'+'objSheet.Range(objSheet.Cells('+row1+','+c1+'), objSheet.Cells('+row2+','+c2+')).Borders(4).Weight=2;'
	+'\n'+'xlApp.Visible=true;'
	+'\n'+'objSheet.Columns.AutoFit;'   //����Ӧ
	+'\n'+'xlApp=null;'
	+'\n'+'xlBook=null;'
	+'\n'+'objSheet=null;'	
	+'\n'+'return 1;}());'
	CmdShell.notReturn = 1;   //�����޽�����ã�����������
	var obj = CmdShell.EvalJs(str);
	return;
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
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
