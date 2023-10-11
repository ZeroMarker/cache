var dicArr = [{"value":"��ҩ","text":'��ҩ'},{"value":"�г�ҩ","text":'�г�ҩ'},{"value":"��ҩ","text":'��ҩ'}];

$(document).ready(function() {
	initCombobox();
   
    initButton();
    
    initdicGrid();       			 //����ͳ������ 
   
})
//���ؽ������
function initdicGrid(){
	

	///  ����columns
	var columns=[[
		{field:"itmmastId",width:100,title:"itmmastId",hidden:false},
		{field:"type",width:100,title:"ҩƷ����"},
		{field:"drugCode",width:100,title:"ҩƷ����"},
		{field:"drugDesc",width:320,title:"ҩƷ����"},
		{field:"dosform",width:100,title:"����"},
		{field:"manufact",width:150,title:"��������"},
		{field:"specificat",width:150,title:"���"},
		{field:"commonname",width:200,title:"ͨ����"},
		{field:"tradename",width:120,title:"��Ʒ��",hidden:true},
		{field:"remark",width:180,title:"��׼�ĺ�"}
	]];
	
	///  ����datagrid
	var option = {
		fitColumn:true,
		rownumbers : true,
		singleSelect : true,
		remoteSort:false,
		//fit : true,
		pageSize : [3000],
		pageList : [3000,6000,9000],
	 	onClickRow: function (rowIndex, rowData) {
					        
 	 	}  
	};
	var dicType = $HUI.combobox("#dictype").getValue();
	var hospCode = $HUI.combobox("#hosp").getValue();
	var params = dicType +"^"+ hospCode;
	var uniturl =  $URL+"?ClassName=web.DHCCKBSearchconDic&MethodName=QueryDrugList&params="+params;
	new ListComponent('maingrid', columns, uniturl, option).Init();

}

///��ѯ�ֵ�
function Query()
{
	var dicType = $HUI.combobox("#dictype").getValue();
	var hospCode = $HUI.combobox("#hosp").getValue();
	var params = dicType +"^"+ hospCode;
	$("#maingrid").datagrid('load',{'params':params});

}

///��ʼ��combobox
function initCombobox()
{
	$HUI.combobox("#dictype",{
		data:dicArr,
		valueField:'value',
		textField:'text',
		panelHeight:"160",
		mode:'remote',
		onSelect:function(ret){
			//Query();
		 }
	})	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBSearchconDic&MethodName=GetHosp"  

	$HUI.combobox("#hosp",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		panelHeight:"160",
		mode:'remote',
		onSelect:function(ret){
			
		}
	})	
	
	$HUI.combobox("#hosp").setValue(LgHospID)
	
}


///��ѯ
function initButton()
{
	$('#find').bind("click",Query);
	
	$('#export').bind("click",exportList);
}

///����
function exportList()
{
	var datas = $('#maingrid').datagrid("getData");
	exportData(datas.rows);
}
function exportData(datas)
{
	
	var stDate = "2021-06-24";
	var endDate = "2021-06-24";
	
	if(datas.length==0){
		$.messager.alert("��ʾ","���赼�����ݣ�");
		return;	
	}
	
	//var Str = "(function test(x){"+
	var xlApp = new ActiveXObject('Excel.Application');
	var xlBook = xlApp.Workbooks.Add();
	var objSheet = xlBook.ActiveSheet;
	var beginRow=2;
	var colNuber=0;;
	for (var i=0;i<datas.length;i++){
		colNuber=0;
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].type; 		//����
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].drugCode; 			//ҩƷ����
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].drugDesc;	//Ʒ����
		
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].dosform;	//����
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].manufact;			//����
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].specificat;	 	//���
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].commonname;	//ͨ����
		objSheet.Cells(i+beginRow+1,(colNuber+=1)).value=datas[i].remark;	//��׼�ĺ�
	}
	
	colNuber=0;
	objSheet.Cells(beginRow,1).value='ҩƷ����';   //ҩƷ����
	objSheet.Cells(beginRow,2).value='ҩƷ����'; 	 	   //ҩƷ����

	objSheet.Cells(beginRow,3).value='ҩƷ����';	   //ҩƷ����
	
	objSheet.Cells(beginRow,4).value='����';		   //����
	objSheet.Cells(beginRow,5).value='��������';			   //��������
	objSheet.Cells(beginRow,6).value='���';	 		       //���
	objSheet.Cells(beginRow,7).value='ͨ��';		   //ͨ����
	objSheet.Cells(beginRow,8).value='��׼�ĺ�';		   //��׼�ĺ�
	
	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,8)).MergeCells = true;
	//objSheet.Cells(1,1).value= 'ͳ��ʱ��:"+stDate+"��"+endDate+"';
	
	gridlistDetail(objSheet,beginRow,datas.length+beginRow,1,8)
	
	xlApp.Visible=true;
	xlApp=null;
	xlBook=null;
	objSheet=null;
    //"return 1;}());";
    //����Ϊƴ��Excel��ӡ����Ϊ�ַ���
    //CmdShell.notReturn = 1;   //�����޽�����ã�����������
	//var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
	return;
}


function gridlistDetail(objSheet,row1,row2,c1,c2)
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