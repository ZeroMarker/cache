var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var CstOutFlagarr = [{ "value": "Y", "text": $g("��") },{ "value": "N", "text": $g("��") }];
/// ҳ���ʼ������
function initPageDefault(){
	
	InitForm();      /// ��ʼ������Ϣ
	InitDataGrid(); /// ��ʼ�����
}

/// ��ʼ������Ϣ
function InitForm(){
	var myDate = new Date();
	var myYear=myDate.getFullYear();
	var yearArr = [];//�����������
    for(year=parseInt(myYear)-9;year<=parseInt(myYear);year++)
	{
		yearArr.push({"value":year,"text":year});
	}
	/// ���
	$HUI.combobox("#Year",{
		data : yearArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	$HUI.combobox("#Year").setValue(myYear);
	
	///����
	$HUI.combobox("#Loc",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
		valueField: "value", 
		textField: "text",
		
	})
	$HUI.combobox("#Loc").setValue(session['LOGON.CTLOCID']); //Ĭ�ϵ�ǰ��¼����
	
	///�Ƿ�Ժ��
	$HUI.combobox("#CstOutFlag",{
		valueField: "value", 
		textField: "text",
		data:CstOutFlagarr
	})
	
	///����
	$HUI.combobox("#Type",{
		valueField: "value", 
		textField: "text",
		editable:false,
		data:[
			{"value":"R","text":$g("�����������")},
			{"value":"C","text":$g("���ս��տ���")}
		]
	})
	$HUI.combobox("#Type").setValue("R"); 
	
}

/// ҳ��DataGrid��ʼ����
function InitDataGrid(){
	
	/// ����columns
	var columns=[[
		{field:'CstRLoc',title:'����',width:140},
		{field:'OneMonNum',title:'1��',width:80,formatter:formNumberOne},
		{field:'TwoMonNum',title:'2��',width:80,formatter:formNumberTwo},
		{field:'ThreeMonNum',title:'3��',width:80,formatter:formNumberThree},
		{field:'FourMonNum',title:'4��',width:80,formatter:formNumberFour},
		{field:'FiveMonNum',title:'5��',width:80,formatter:formNumberFive},
		{field:'SixMonNum',title:'6��',width:80,formatter:formNumberSix},
		{field:'SevenMonNum',title:'7��',width:80,formatter:formNumberSeven},
		{field:'EightMonNum',title:'8��',width:80,formatter:formNumberEight},
		{field:'NineMonNum',title:'9��',width:80,formatter:formNumberNine},
		{field:'TenMonNum',title:'10��',width:80,formatter:formNumberTen},
		{field:'ElevenMonNum',title:'11��',width:80,formatter:formNumberEleven},
		{field:'TwelveMonNum',title:'12��',width:80,formatter:formNumberTwelve},
		{field:'TotleNum',title:'�ϼ�',width:80},
		
	]];
	/// ����datagrid
	var option = {
		fit: true,
		border:true,
		title:"����ͳ�ư���",
		toolbar:"#toolbar",
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		rownumbers : true,
		singleSelect : true,
		fitColumns:true,
		pagination: true
	};
	/// ��������
	var params = getParams();
	var uniturl = $URL+"?ClassName=web.DHCEMConsultStatisQuery&MethodName=GetDataByMon&Params="+params;
	new ListComponent('Table', columns, uniturl, option).Init(); 
	
	/// ��ϸ��
	var columns=[[ ///  ����columns
		{field:'Loc',title:'����',width:140},
		{field:'Num',title:'����',width:100,formatter:formNumber},	
	]];
	///  ����datagrid
	var option = {
		toolbar: [],
		title:'��ϸ',
		border:true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		rownumbers : true,
		singleSelect : true,
		fitColumns:true,
		pagination: true
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCEMConsultStatisQuery&MethodName=GetDetail&Params=";
	new ListComponent('Detail', columns, uniturl, option).Init(); 
	
	/// ������ϸ��
	///  ����columns
	var columns=[[ 
		{field:'PatNo',title:'���ߵǼǺ�',width:140},
		{field:'PatName',title:'����',width:120},
		{field:'CstRDate',title:'��������',width:120},
		{field:'CstRUser',title:'����ҽʦ',width:120},
		{field:'CstCDate',title:'��������',width:120},
		{field:'CstUser',title:'����ҽʦ',width:120},
		{field:'Opinion',title:'������ɽ���',width:520}		
	]];
	var option = {
		toolbar: [],
		title:'������ϸ',
		border:true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			BindTips(); /// ����ʾ��Ϣ
		}
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCEMConsultStatisQuery&MethodName=GetPatDetail&Params=";
	new ListComponent('PatDetail', columns, uniturl, option).Init(); 
}

/// ��ѯ
function QryList(){
	var params = getParams();
	$("#Table").datagrid("load",{"Params":params});
	$HUI.datagrid("#Detail").load({"Params":""});
	$HUI.datagrid("#PatDetail").load({"Params":""});
}

function getParams(){
	var params="";
	var SeYear = $HUI.combobox("#Year").getValue()||""; //���
	var SeLocID = $HUI.combobox("#Loc").getValue()==undefined?"":$HUI.combobox("#Loc").getValue(); //����
	var SeOutflag = $HUI.combobox("#CstOutFlag").getValue()==undefined?"":$HUI.combobox("#CstOutFlag").getValue(); //�Ƿ�Ժ������
	var SeType = $HUI.combobox("#Type").getValue()==undefined?"":$HUI.combobox("#Type").getValue(); // ����
	if(SeYear==""){
		$.messager.alert("��ʾ","��ѡ����ݣ�");
		return;	
	}
	if(SeType==""){
		$.messager.alert("��ʾ","��ѡ�����ͣ�");
		return;	
	}
	params = LgUserID+"^"+SeYear+"^"+SeLocID+"^"+SeOutflag+"^"+SeType+"^"+LgHospID;
	return params;	
}

function formNumber(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowPatDetail(\''+rowData.ItmStr+'\')">&nbsp;'+value+'&nbsp;</a>';
}

function formNumberOne(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.OneMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberTwo(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.TwoMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberThree(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.ThreeMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberFour(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.FourMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberFive(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.FiveMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberSix(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.SixMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberSeven(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.SevenMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberEight(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.EightMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberNine(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.NineMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberTen(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.TenMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberEleven(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.ElevenMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function formNumberTwelve(value, rowData, rowIndex){
	return '<a style="text-decoration:underline" href="#" onclick="ShowDetail(\''+rowData.TwelveMon+'\')">&nbsp;'+value+'&nbsp;</a>';
}
function ShowDetail(value){
	var staType = $HUI.combobox("#Type").getValue()==undefined?"":$HUI.combobox("#Type").getValue();   /// ����
	$HUI.datagrid("#Detail").load({"Params":value+"^"+staType});
	$HUI.datagrid("#PatDetail").load({"Params":""});
}
function ShowPatDetail(value){
	$HUI.datagrid("#PatDetail").load({"Params":value});
}
//����
function Export(){
	var datas = $('#Table').datagrid("getData");
	ExportData(datas.rows);
}

function ExportData(datas){
    var Year = $HUI.combobox("#Year").getValue()||"";            /// ���
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add("");
	var objSheet = xlBook.ActiveSheet;
	
	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,14)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,14)).Font.Bold = true; //����Ϊ����
	objSheet.Cells(1,1).value= Year+"����һ�������ͳ��"
	var beginRow=2;	
	for (var i=0;i<datas.length;i++){

		objSheet.Cells(i+beginRow+1,1).value=datas[i].CstRLoc;       //�����Ŷ�
		objSheet.Cells(i+beginRow+1,2).value=datas[i].OneMonNum;	 //1��
		objSheet.Cells(i+beginRow+1,3).value=datas[i].TwoMonNum;	 //2��
		objSheet.Cells(i+beginRow+1,4).value=datas[i].ThreeMonNum;	 //3��
		objSheet.Cells(i+beginRow+1,5).value=datas[i].FourMonNum;	 //4��
		objSheet.Cells(i+beginRow+1,6).value=datas[i].FiveMonNum;	 //5��
		objSheet.Cells(i+beginRow+1,7).value=datas[i].SixMonNum;	 //6��	
		objSheet.Cells(i+beginRow+1,8).value=datas[i].SevenMonNum;	 //7��	
		objSheet.Cells(i+beginRow+1,9).value=datas[i].EightMonNum;	 //8��	
		objSheet.Cells(i+beginRow+1,10).value=datas[i].NineMonNum;	 //9��	
		objSheet.Cells(i+beginRow+1,11).value=datas[i].TenMonNum;	 //10��	
		objSheet.Cells(i+beginRow+1,12).value=datas[i].ElevenMonNum; //11��	
		objSheet.Cells(i+beginRow+1,13).value=datas[i].TwelveMonNum; //12��
		objSheet.Cells(i+beginRow+1,14).value=datas[i].TotleNum;	 //�ϼ�		
	}

	objSheet.Cells(beginRow,1).value="����"; 	     	    //����
	objSheet.Cells(beginRow,2).value="1��";	 			 	//1��
	objSheet.Cells(beginRow,3).value="2��";	     		 	//2��
	objSheet.Cells(beginRow,4).value="3��";	     			//3��
	objSheet.Cells(beginRow,5).value="4��";	     			//4��
	objSheet.Cells(beginRow,6).value="5��";	 				//5��
	objSheet.Cells(beginRow,7).value="6��";	 				//6��	
	objSheet.Cells(beginRow,8).value="7��";	     			//7��
	objSheet.Cells(beginRow,9).value="8��";	 				//8��
	objSheet.Cells(beginRow,10).value="9��";	 			//9��	
	objSheet.Cells(beginRow,11).value="10��";	 			//10��	
	objSheet.Cells(beginRow,12).value="11��";	 			//11��	
	objSheet.Cells(beginRow,13).value="12��";	 			//12��	
	objSheet.Cells(beginRow,14).value="�ϼ�";	 			//�ϼ�	
	
	gridlist(objSheet,beginRow,datas.length+beginRow,1,14)
	xlApp.Visible=true;
	objSheet.Columns.AutoFit;   //����Ӧ
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

/// ����ʾ��
function BindTips(){
	
	var html='<div id="tip" style="word-break:break-all;border-radius:3px; display:none; border:1px solid #000; padding:10px; margin:5px; position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	
	/// ����뿪
	$('td[field="Opinion"]').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// ����ƶ�
	$('td[field="Opinion"]').on({
		'mousemove':function(){
			var tleft=(event.clientX + 10);
			if ($(this).text().length <= 20){
				return;
			}
			if ( window.screen.availWidth - tleft < 600){ tleft = tleft - 600;}
			/// tip ��ʾ��λ�ú������趨
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 0.8
			}).text($(this).text());
		}
	})
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
