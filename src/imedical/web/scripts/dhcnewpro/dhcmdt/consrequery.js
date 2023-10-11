//===========================================================================================
// ���ߣ�      yangyongtao
// ��д����:   2020-08-06
// ����:	   mdt��������ͳ��
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
	
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPatList(){
	///  ����columns
	var columns=[[
	    {field:'CstRDate',title:'ʱ��',width:120},
	    {field:'PatName',title:'��������',width:100},
	    {field:'PatNo',title:'ID��',width:100},
	    {field:'PatSex',title:'�Ա�',width:60},
		{field:'PatAge',title:'����',width:60},
		{field:'DisGrpID',title:'DisGrpID',width:100,hidden:true},
		{field:'DisGroup',title:'�����Ŷ�',width:140},
		{field:'CstUser',title:'�������',width:100,hidden:true},
		{field:'AdmType',title:'������Դ',width:100},
		{field:'PatLoc',title:'���߿�����Դ',width:140},
		{field:'AdmDoctor',title:'����ҽ��',width:100},
		{field:'itmCost',title:'�������',width:100},
		//{field:'CstUser',title:'�ϻ��˴�',width:100},
		{field:'CstNTime',title:'��ʼʱ��',width:150},
		{field:'CstCTime',title:'����ʱ��',width:150},
		{field:'ID',title:'ID',width:100},
		{field:'pid',title:'pid',width:100,hidden:true},
		
	]];
	
	///  ����datagrid
	var option = {
		rownumbers : true,
		singleSelect : true,
		pagination: true
	};
	/// ��������
	var params = getParams()
	var uniturl = $URL+"?ClassName=web.DHCMDTStatistics&MethodName=JsGetMdtData&Params="+params+"&LgParam="+LgParam+"&MWToken="+websys_getMWToken();
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// ��ѯ
function QryPatList(){
	var params = getParams()
	$("#bmDetList").datagrid("load",{"Params":params,"LgParam":LgParam}); 
}

function getParams(){
	var params="";
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	params = StartDate +"^"+ EndDate 
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
	var pid=datas.rows[0].pid
	runClassMethod("web.DHCMDTStatistics","JsonExportData",{"LgUserID":LgUserID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != ""){
           ExportData(jsonObject)
		}
	},'json',false)	

}

function ExportData(datas){
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var str ='(function test(x){'
	+'\n'+'var xlApp = new ActiveXObject("Excel.Application");'
	+'\n'+'var xlBook = xlApp.Workbooks.Add("");'
	+'\n'+'var objSheet = xlBook.ActiveSheet;'
	+'\n'+'xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,14)).MergeCells = true;'
	+'\n'+'xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,14)).Font.Bold = true;'
	+'\n'+'objSheet.cells(1,1).Font.Bold = true;'
	+'\n'+'objSheet.cells(1,1).Font.Size =24;'
	+'\n'+'objSheet.cells(1,1).HorizontalAlignment = -4108;'
	+'\n'+'objSheet.Columns(1).NumberFormatLocal="@";'
	+'\n'+'objSheet.Columns(3).NumberFormatLocal="@";'
	+'\n'+'objSheet.Columns(13).NumberFormatLocal="@";'
	+'\n'+'objSheet.Columns(14).NumberFormatLocal="@";'
	+'\n'+'objSheet.Cells(1,1).value="ͳ��ʱ��:'+StartDate+'��'+EndDate+'";'
	var beginRow=2;	
	for (var i=0;i<datas.length;i++){
		str=str
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',1).value="'+datas[i].CstRDate+'";'      			//ʱ��
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',2).value="'+datas[i].PatName+'";' 	 			//��������
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',3).value="'+datas[i].PatNo+'";' 					//ID��
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',4).value="'+datas[i].PatSex+'";' 				//�Ա�
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',5).value="'+datas[i].PatAge+'";' 	 			//����
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',6).value="'+datas[i].DisGroup+'";' 	 			//�����Ŷ�
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',7).value="'+datas[i].CstUser+'";' 	 			//�������	
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',8).value="'+datas[i].AdmType+'";' 	 			//������Դ	
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',9).value="'+datas[i].PatLoc+'";' 	 			//���߿�����Դ	
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',10).value="'+datas[i].AdmDoctor+'";' 	 		//����ҽ��	
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',11).value="'+datas[i].itmCost+'";' 	 			//�������	
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',12).value="";' 									//�ϻ��˴�	
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',13).value="'+datas[i].CstNTime+'";' 	 			//��ʼʱ��	
		+'\n'+'objSheet.Cells('+(i+beginRow+1)+',14).value="'+datas[i].CstCTime+'";'  			//����ʱ��	
		
	}
	str=str
	+'\n'+'objSheet.Cells('+beginRow+',1).value="ʱ��";' 	     		//ʱ��
	+'\n'+'objSheet.Cells('+beginRow+',2).value="��������";'	 		//��������
	+'\n'+'objSheet.Cells('+beginRow+',3).value="ID��";'	     		//ID��
	+'\n'+'objSheet.Cells('+beginRow+',4).value="�Ա�";'	     		//�Ա�
	+'\n'+'objSheet.Cells('+beginRow+',5).value="����";'	     		//����
	+'\n'+'objSheet.Cells('+beginRow+',6).value="�����Ŷ�";'	 		//�����Ŷ�
	+'\n'+'objSheet.Cells('+beginRow+',7).value="�������";'	 		//�������
	+'\n'+'objSheet.Cells('+beginRow+',8).value="������Դ";'	     	//������Դ
	+'\n'+'objSheet.Cells('+beginRow+',9).value="���߿�����Դ";'	 	//���߿�����Դ
	+'\n'+'objSheet.Cells('+beginRow+',10).value="����ҽ��";'	 		//����ҽ��
	+'\n'+'objSheet.Cells('+beginRow+',11).value="�������";'	 		//�������
	+'\n'+'objSheet.Cells('+beginRow+',12).value="�ϻ��˴�";'	 		//�ϻ��˴�
	+'\n'+'objSheet.Cells('+beginRow+',13).value="��ʼʱ��";'	 		//��ʼʱ��
	+'\n'+'objSheet.Cells('+beginRow+',14).value="����ʱ��";'	 		//����ʱ��
	
	var row1=beginRow,row2=datas.length+beginRow,c1=1,c2=14
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
