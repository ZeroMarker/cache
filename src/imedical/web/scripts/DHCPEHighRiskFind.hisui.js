
//����	DHCPEHighRiskFind.hisui.js
//����	��Σ��Ϣ��ѯ
//����	2019.07.05
//������  xy

/*******************���ʽ�༭************************/
var ConditioneditIndex=undefined;
/*function ConditionendEditing(){
			if (ConditioneditIndex == undefined){return true}
			if ($('#DHCPEEDCondition').datagrid('validateRow', ConditioneditIndex)){
				
				$('#DHCPEEDCondition').datagrid('endEdit', ConditioneditIndex);
				
				ConditioneditIndex = undefined;
				return true;
			} else {
				return false;
			}
}
*/
function ConditionendEditing(){
			if (ConditioneditIndex == undefined){return true}
			if ($('#DHCPEEDCondition').datagrid('validateRow', ConditioneditIndex)){
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TItemID'});
				var name = $(ed.target).combobox('getText');
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TItem'] = name;
				
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TOperator'});
				var name = $(ed.target).combobox('getText');
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TOperatorname'] = name;
				
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TSex'});
				var name = $(ed.target).combobox('getText');
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TSexname'] = name;
				
				
				
				$('#DHCPEEDCondition').datagrid('endEdit', ConditioneditIndex);
				
				ConditioneditIndex = undefined;
				return true;
			} else {
				return false;
			}
}
/*
function ConditionClickRow(index){
		if (ConditioneditIndex!=index) {
			if (ConditionendEditing()){
				$('#DHCPEEDCondition').datagrid('selectRow',index).datagrid('beginEdit',index);
				ConditioneditIndex = index;
			} else {
				$('#DHCPEEDCondition').datagrid('selectRow',ConditioneditIndex);
			}
		}
}
*/
function ConditionClickRow(index){
		
		if (ConditioneditIndex!=index) {
			if (ConditionendEditing()){
				
				
				$('#DHCPEEDCondition').datagrid('selectRow',index).datagrid('beginEdit',index);
				ConditioneditIndex = index;
				
				
				
			} else {
				$('#DHCPEEDCondition').datagrid('selectRow',ConditioneditIndex);
			}
		}
}
/*******************���ʽ�༭************************/



$(function(){
		
	
	InitCombobox();
	
	 
	InitHighRiskGrid();
	
	InitHighRiskListGrid();
	
	InitEDConditionGrid();
	
	//��ѯ
    $('#BFind').click(function(){
    	BFind_click();
    });
    
    //�绰֪ͨ
     $('#BTel').click(function(){
    	BTel_click();
    });
   
    //����֪ͨ
     $('#BSendMessage').click(function(){
    	 BSendMessage_click();
    });
   
    //����
     $('#BExport').click(function(){
    	BExport_click();
    });
    
    //����word
    $('#BtnExportWord').click(function(){
    	BtnExportWord_click();
    });
    
     $('#DealRemark').dblclick(function(){
    	DealRemark_DBLClick();
    });
    
    
    //����
    $('#BSave').click(function(){
    	BSave_click();
    });
    
    
})

/*********************************��Σ����start*********************/

 //�绰֪ͨ
function BTel_click(){
	var PAADM=$("#PAADM").val();
	if (PAADM==""){
		$.messager.alert("��ʾ:","��ѡ���������Ա","info");
		return false;
	}
	
	var selectrow=$("#HighRiskListGrid").datagrid("getSelected");//��ȡ�������飬��������
	var PAADM=selectrow.TPAADM;
	var EDID=selectrow.TEDID;
	var SourceID=selectrow.TSourceID;
	if (SourceID==""){
		var ID=PAADM+","+EDID;
		var Type="TRC";
	}else{
		var ID=SourceID;
		var Type="THR";
	}
	var RegNo=selectrow.TRegNo;
	var TTel=$.trim($("#Tel").val());
	var MessageTemplate="";
	var MessageTemplate=$("#DealRemark").val();
	
	var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+MessageTemplate;
	
	var ret=tkMakeServerCall("web.DHCPE.SendMessage","SaveMessage",Type,InfoStr);
	if (ret!=0){
		$.messager.alert("��ʾ",ret,"info");
		return false;
	}
	var UserID=session['LOGON.USERID']
	var AllID=GetOtherRecord(PAADM,"T");
	var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","SaveOtherRecord",AllID,UserID);
	$.messager.alert("��ʾ","����ɹ�","success");
	BFind_click();
	
	
}
function GetOtherRecord(OldPAADM,OldType)
{
	var objtbl = $("#HighRiskListGrid").datagrid('getRows');
    var rows=objtbl.length
	var ret="";
	for (var i=0;i<rows;i++)
	{
		var PAADM=objtbl[i].TPAADM;
		if (OldPAADM!=PAADM) continue;
		
		var HadSend=objtbl[i].THadSend;
		var EDID=objtbl[i].TEDID;
		var SourceID=objtbl[i].TSourceID;
		
		if (SourceID==""){
			var ID=PAADM+","+EDID;
			var Type=OldType+"RC";
		}else{
			var ID=SourceID;
			var Type=OldType+"HR";
		}
		var OneInfo=ID+"^"+Type;
		if (ret==""){
			ret=OneInfo;
		}else{
			ret=ret+"$"+OneInfo
		}
	}
	return ret;
}

//����֪ͨ
function BSendMessage_click(){
	var PAADM=$("#PAADM").val();
	if (PAADM==""){
		$.messager.alert("��ʾ:","��ѡ���������Ա","info");
		return false;
	}
	
	var selectrow=$("#HighRiskListGrid").datagrid("getSelected");//��ȡ�������飬��������
	var PAADM=selectrow.TPAADM;
	var EDID=selectrow.TEDID;
	var SourceID=selectrow.TSourceID;
	if (SourceID==""){
		var ID=PAADM+","+EDID;
		var Type="RC";
	}else{
		var ID=SourceID;
		var Type="HR";
	}
	var RegNo=selectrow.TRegNo;
	var TTel=$.trim($("#Tel").val());
	if (TTel==""){
		$.messager.alert("��ʾ:","���Ͷ��ŵ绰����Ϊ��","info");
		return false;
	}
	
	if (!isMoveTel(TTel)){
		$.messager.alert("��ʾ:","�绰�����ƶ��绰","info");
		return false;
	}
	var MessageTemplate="";
	var MessageTemplate=$("#DealRemark").val();
	if (MessageTemplate==""){
		$.messager.alert("��ʾ:","�������ݲ���Ϊ��","info");
		return false;
	}
	var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+MessageTemplate;
	var ret=tkMakeServerCall("web.DHCPE.SendMessage","SaveMessage",Type,InfoStr);
   
	if (ret!=0){
		$.messager.alert("��ʾ",ret,"info");
		return false;
	}
	var UserID=session['LOGON.USERID']
	var AllID=GetOtherRecord(PAADM,"");
	var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","SaveOtherRecord",AllID,UserID);
	
	$.messager.alert("��ʾ","����ɹ�","success");
	BFind_click();
}

//�ж��ƶ��绰
function isMoveTel(elem){
	if (elem=="") return true;
	var pattern=/^0{0,1}13|15|18[0-9]{9}$/;
	if(pattern.test(elem)){
		return true;
	}else{

	return false;
 	}
}


//����
function BExport_click(){
	//alert(EnableLocalWeb+"EnableLocalWeb")
	if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
try{
	 var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	 var Templatefilepath=prnpath+'DHCPEExportCommon.xls';
	var ExportName="DHCPEHighRisk"
	
	xlApp= new ActiveXObject("Excel.Application"); //�̶�
	xlApp.UserControl = true;
    xlApp.visible = true; //��ʾ
	xlBook= xlApp.Workbooks.Add(Templatefilepath); //�̶�
	xlsheet= xlBook.WorkSheets("Sheet1"); //Excel�±������
	var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo","",ExportName);
	var Row=1;
	while (Info!="")
	{
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		for (i=1;i<DataLength;i++)
		{
			xlsheet.cells(Row,i).value=DataArr[i];
		}
		var Sort=DataArr[0];
		if (Sort=="") break;
		Row=Row+1;
		var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",Sort,ExportName);
	}
	xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(Row,10)).Borders.LineStyle=1;
	xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
}catch(e)
	{
		alert(e+"^"+e.message);
	}
}
else{
	BPrintNew_click()
}
}
function BPrintNew_click(){
	//alert(11)
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	 var Templatefilepath=prnpath+'DHCPEExportCommon.xls';
	var ExportName="DHCPEHighRisk"
	var Str = "(function test(x){"+
	"xlApp= new ActiveXObject('Excel.Application');"+
	"xlApp.UserControl = true;"+
    "xlApp.visible = true;"+
	"xlBook= xlApp.Workbooks.Add('"+Templatefilepath+"');"+
	"xlsheet= xlBook.WorkSheets('Sheet1');"
	var ret=""
	var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo","",ExportName);
	var Row=1;
	while (Info!="")
	{
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		for (i=1;i<DataLength;i++)
		{
			if(ret!=""){
				ret+="xlsheet.cells("+Row+","+i+").value='"+DataArr[i]+"';"
				}
			else{
			ret="xlsheet.cells("+Row+","+i+").value='"+DataArr[i]+"';"
			}
		}
		var Sort=DataArr[0];
		if (Sort=="") break;
		Row=Row+1;
		var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",Sort,ExportName);
	}
	var Str=Str+ret+
	"xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells("+Row+",10)).Borders.LineStyle='1';"+
	"xlBook.Close(savechanges = true);"+
	"xlApp.Quit();"+
	"xlApp = null;"+
	"xlsheet = null;"+
	"return 1;}());";
           //alert(Str)
      //����Ϊƴ��Excel��ӡ����Ϊ�ַ���
       CmdShell.notReturn = 1;   //�����޽�����ã�����������
		var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
		return ; 
	
}
function BPrintWordNew_click()
{
	var wdCharacter=1;
	var Str = "(function test(x){"+
	"var WordApp=new ActiveXObject('Word.Application');"+
	"var wdOrientLandscape = 1;"+
	"WordApp.Application.Visible=true;"+
	"var myDoc=WordApp.Documents.Add();"+
	"WordApp.Selection.ParagraphFormat.Alignment=1;"+
	"WordApp.Selection.Font.Bold=true;"+ 
	"WordApp.Selection.Font.Size=20;"+
	"WordApp.Selection.TypeText('��Σ��Ϣ����');"+
	"WordApp.Selection.MoveRight("+wdCharacter+");"+
	"WordApp.Selection.TypeParagraph();"+ 
	"WordApp.Selection.Font.Size=12;"+
	"WordApp.Selection.TypeParagraph();"+ 
	"var myTable=myDoc.Tables.Add (WordApp.Selection.Range,1,7);"+
	"myTable.Style='������';"+
	"var TableRange;"+
	"myTable.Columns(1).Width=45;"+
	"myTable.Columns(2).Width=35;"+
	"myTable.Columns(3).Width=35;"+
	"myTable.Columns(4).Width=55;"+
	"myTable.Columns(5).Width=80;"+
	"myTable.Columns(6).Width=70;"+
	"myTable.Columns(7).Width=140;"+
	"myTable.Cell(1,1).Range.Text ='����';"+
	"myTable.Cell(1,2).Range.Text ='�Ա�';"+
	"myTable.Cell(1,3).Range.Text ='����';"+
	"myTable.Cell(1,4).Range.Text ='�ǼǺ�';"+
	"myTable.Cell(1,5).Range.Text ='��λ/VIP�ȼ�';"+
	"myTable.Cell(1,6).Range.Text ='�绰';"+
	"myTable.Cell(1,7).Range.Text ='��Σ���';"
	var ret=""
	var ExportName="DHCPEHighRisk";
	 var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",1,ExportName)
	
	var Row=1;
	while (Info!=""){
		//alert("Info=="+Info);
		var DataArr=Info.split("^");
		var Sort=DataArr[0];
		if (parseInt(Row)>1){
			if(ret!="")
			{
			ret=ret+"myTable.Rows.add();"
			}
			else{
				ret="myTable.Rows.add();"
				
			}
			var DataLength=DataArr.length;
			for (i=1;i<=5;i++){
				if(ret!="")
				{
				ret=ret+"myTable.Cell("+Row+","+i+").Range.Text='"+DataArr[i]+"';";
				}
				else{
				ret="myTable.Cell("+Row+","+i+").Range.Text='"+DataArr[i]+"';";
				
				}
				
			}
			for (i=6;i<=7;i++){
				if(ret!="")
				{
				ret=ret+"myTable.Cell("+Row+","+i+").Range.Text='"+DataArr[i+1]+"';";
				}
				else{
				ret="myTable.Cell("+Row+","+i+").Range.Text='"+DataArr[i+1]+"';";
				
				}
				
			}
		}
		if (Sort=="") break;
		 Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",Sort,ExportName)
		
		Row=Row+1;
	}
	//�����ͷ��ʽ
	for (i= 0;i<7;i++) {
		
				if(ret!="")
				{
				ret=ret+"myTable.Cell(1,"+i+"+1).Range.font.Size = 11;";
				ret=ret+"myTable.Cell(1,"+i+"+1).Range.Font.Bold = true;";
				}
				else{
				ret="myTable.Cell(1,"+i+"+1).Range.font.Size = 11;";
				ret=ret+"myTable.Cell(1,"+i+"+1).Range.Font.Bold = true;";
				
				}
		
		
	}
	var Str=Str+ret+
	"return 1;}());";
          // alert(Str)
      //����Ϊƴ��Excel��ӡ����Ϊ�ַ���
       CmdShell.notReturn = 0;   //�����޽�����ã�����������
		var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
		return ; 
	row_count = 0; 
	col_count = 0 
	
}

//����word
function BtnExportWord_click(){  
	if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
	var WordApp=new ActiveXObject("Word.Application"); 
	var wdCharacter=1 
	var wdOrientLandscape = 1 
	WordApp.Application.Visible=true; //ִ�����֮���Ƿ񵯳��Ѿ����ɵ�word 
	var myDoc=WordApp.Documents.Add();//�����µĿ��ĵ� 
	//WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//ҳ�淽������Ϊ���� 
	WordApp. Selection.ParagraphFormat.Alignment=1 //1���ж���,0Ϊ���� 
	WordApp. Selection.Font.Bold=true; 
	WordApp. Selection.Font.Size=20 
	WordApp. Selection.TypeText("��Σ��Ϣ����"); 
	WordApp. Selection.MoveRight(wdCharacter);��������//��������ַ� 
	WordApp.Selection.TypeParagraph() //������� 
	WordApp. Selection.Font.Size=12 
	WordApp.Selection.TypeParagraph() //������� 
	var myTable=myDoc.Tables.Add (WordApp.Selection.Range,1,7) //1��7�еı�� 
	myTable.Style="������" 
	var aa = "��Σ��Ϣ����" 
	var TableRange;
	
	//�����п�
	myTable.Columns(1).Width=45;
	myTable.Columns(2).Width=35;
	myTable.Columns(3).Width=35;
	myTable.Columns(4).Width=55;
	myTable.Columns(5).Width=80;
	myTable.Columns(6).Width=70;
	myTable.Columns(7).Width=140;
	
	//�����ͷ��Ϣ
	myTable.Cell(1,1).Range.Text ="����";
	myTable.Cell(1,2).Range.Text ="�Ա�";
	myTable.Cell(1,3).Range.Text ="����";
	myTable.Cell(1,4).Range.Text ="�ǼǺ�";
	myTable.Cell(1,5).Range.Text ="��λ/VIP�ȼ�";
	//myTable.Cell(1,6).Range.Text ="��������";
	myTable.Cell(1,6).Range.Text ="�绰";
	myTable.Cell(1,7).Range.Text ="��Σ���";
	//myTable.Cell(1,9).Range.Text ="����";
	//myTable.Cell(1,10).Range.Text ="״̬";
	
	var ExportName="DHCPEHighRisk";
	 var Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",1,ExportName)
	
	var Row=1;
	while (Info!=""){
		//alert("Info=="+Info);
		var DataArr=Info.split("^");
		var Sort=DataArr[0];
		if (parseInt(Row)>1){
			myTable.Rows.add();//������
			var DataLength=DataArr.length;
			for (i=1;i<=5;i++){
				myTable.Cell(Row,i).Range.Text=DataArr[i];
			}
			for (i=6;i<=7;i++){
				myTable.Cell(Row,i).Range.Text=DataArr[i+1];
			}
		}
		if (Sort=="") break;
		 Info=tkMakeServerCall("web.DHCPE.DHCPECommon","GetOneExportInfo",Sort,ExportName)
		
		Row=Row+1;
	}
	//�����ͷ��ʽ
	for (i= 0;i<7;i++) {
		with (myTable.Cell(1,i+1).Range){
			font.Size = 11;
			Font.Bold = true;
		} 
	}
	row_count = 0; 
	col_count = 0 
	//myDoc.Protect(1)  
	}
	else{
	BPrintWordNew_click()
	
	}
}


function DealRemark_DBLClick(){
	
	var selectrow=$("#HighRiskListGrid").datagrid("getSelected");//��ȡ�������飬��������
	var VIPLevelID=selectrow.TVIPLevelID;
	var Active="1";
	var url='websys.lookup.csp';
	url += "?ID=&CONTEXT=K"+"web.DHCPE.MessageTemplet:FindMessageTemplet";
	url += "&TLUJSF=SetDealRemak"
	url += "&P1="+VIPLevelID
	url += "&P4="+Active
	;
	websys_lu(url,1,'');
	return websys_cancel();

}

function SetDealRemak(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var OldRemak=$("#DealRemark").val();
	$("#DealRemark").val(Arr[1]+";"+OldRemak);
}

function BPriewResult(PAADM){

	var wwidth=1200;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var url="dhcpenewdiagnosis.diagnosis.hisui.csp?EpisodeID="+PAADM+"&MainDoctor="+""+"&OnlyRead="+"Y";
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(url,"_blank",nwin)


}

function CRM_Click(SourceID)
{
	
	var url="dhcpecrminfo.hisui.csp?SourceID="+SourceID;
	websys_lu(url,false,'width=900,height=600,hisui=true,title=�����Ϣ')
}


function InitHighRiskListGrid(){
	
	$HUI.datagrid("#HighRiskListGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.HighRiskNew",
			QueryName:"SearchHighRisk",	    
		},
		frozenColumns:[[
			{field:'TRegNo',width:'100',title:'�ǼǺ�'},
			{field:'TName',width:'100',title:'����'},
			
		]],
		columns:[[
		
		 	{field:'TSourceID',title:'EDID',hidden: true},
		 	{field:'TEDID',title:'EDID',hidden: true},
		 	{field:'TPAADM',title:'PAADM',hidden: true},
			{field:'TSex',width:'60',title:'�Ա�'},
			{field:'TAge',width:'60',title:'����'},
			{field:'TGroup',width:'150',title:'����'},
			{field:'TDepart',width:'100',title:'����'},
			{field:'TTel',width:'120',title:'�绰'},
			{field:'TEDDesc',width:'200',title:'��Σ����'},
			{field:'TEDResult',width:'300',title:'��Σ���',
				formatter:function(value,rowData,rowIndex){	
					if(value!=""){
						return "<a href='#'  class='grid-td-text' onclick=BPriewResult("+rowData.TPAADM+"\)>"+value+"</a>";
			
					}
					
	
				}
			},
			{field:'THadSend',width:'100',title:'����ʽ'},
			{field:'TSendDate',width:'100',title:'��������'},
			{field:'TMessageDetail',title:'��������',hidden: true},
			{field:'TCheckDate',width:'100',title:'�������'},
			{field:'TVIPLevel',width:'100',title:'VIP�ȼ�'},
			{field:'TVIPLevelID',title:'TVIPLevelID',hidden: true},
			{field:'TItem',width:'120',title:'��Ŀ'},
			{field:'THHUser',width:'100',title:'�ϱ���'},
			{field:'THHRDate',width:'150',title:'�ϱ�ʱ��'},
			{field:'TSendUser',width:'100',title:'֪ͨ��'},
			{field:'TAduitUser',width:'100',title:'����ҽ��'},

				{field:'TCRMFlag',width:70,align:'center',title:'�����',
				formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			{field:'CRM',title:'���',width:'40',
			formatter:function(value,rowData,rowIndex){
				if((rowData.TSourceID!="")&&(rowData.TCRMFlag=="Y")){
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/person.png" title="" border="0" onclick="CRM_Click('+rowData.TSourceID+')"></a>';
			
				}
				}},
			{field:'TCrmFinishFlag',width:70,align:'center',title:'������',
				formatter: function (value, rec, rowIndex) {
					
						if(value=="1"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			

			
		]],
		onSelect: function (rowIndex, rowData) {
			$("#Tel").val(rowData.TTel);
			$("#PAADM").val(rowData.TPAADM);
			$("#DealRemark").val(rowData.TEDResult);		
								
		}
		
			
	})
}
/*********************************��Σ����end*********************/



/**************************************��Σ��Ϣά�� strat***********************************/
//��ѯ 
function BFind_click(){
	var HospID=session['LOGON.HOSPID']
	var StartDate=$("#StartDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	var GroupID=$("#GroupDesc").combogrid('getValue');
	if (($("#GroupDesc").combogrid('getValue')==undefined)||($("#GroupDesc").combogrid('getValue')=="")){var GroupID="";}
	var Name=$("#Name").val();
	
	var iResultFlag="N";
	
	var ResultFlag=$("#ResultFlag").checkbox('getValue');
	if (ResultFlag) {iResultFlag="Y";}
	else{iResultFlag="N";}
	
	
	var EDIDs="";
	var selectrow = $("#HighRiskGrid").datagrid("getChecked");//��ȡ�������飬��������
	
	for(var i=0;i<selectrow.length;i++){
		var EDID=selectrow[i].TEDID;
		if (EDIDs==""){
				EDIDs=EDID;
			}else{
				EDIDs=EDIDs+"^"+EDID;
			}
	}
	if ((EDIDs=="")&&(iResultFlag=="N"))
	{
		$.messager.alert("��ʾ","��ѡ���Σ��Ϣ","info");
		return false;
	}
	
	var VIPLevel=$("#VIPLevel").combobox('getValue');
	if (($("#VIPLevel").combobox('getValue')==undefined)||($("#VIPLevel").combobox('getValue')=="")){var VIPLevel="";}
	
	var IfSolve=$("#IfSolve").combobox('getValue');
	if (($("#IfSolve").combobox('getValue')==undefined)||($("#IfSolve").combobox('getValue')=="")){var IfSolve="";}
	
	var ContractID=$("#Contract").combogrid('getValue');
	if (($("#Contract").combogrid('getValue')==undefined)||($("#Contract").combogrid('getValue')=="")){var ContractID="";}
	
		
	var iCRMFlag="N";
	var CRMFlag=$("#CRMFlag").checkbox('getValue');
	if(CRMFlag) {iCRMFlag="Y";}

	$('#HighRiskListGrid').datagrid('load', {
			ClassName:"web.DHCPE.HighRiskNew",
			QueryName:"SearchHighRisk",
			StartDate:StartDate,
			EndDate:EndDate,
			GroupID:GroupID,
			EDIDs:EDIDs,
			ResultFlag:iResultFlag,
			Name:Name,
			IfSolve:IfSolve,
			VIPLevel:VIPLevel,
			ContractID:ContractID,
			CRMFlag:iCRMFlag,
			HospID:HospID
	});
}

function InitHighRiskGrid(){
		$HUI.datagrid("#HighRiskGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.HighRiskNew",
			QueryName:"SearchHighRiskED",	    
		},
		frozenColumns:[[
			{title: 'ѡ��',field: 'Select',width: 60,checkbox:true},
			{field:'TEDDesc',width:'150',title:'��Σ����'},
		]],
		columns:[[
		
		 	{field:'TEDID',title:'EDID',hidden: true},
			{field:'TEDDetail',width:'2000',title:'��Σ����'},
			
			
		]],
		onSelect: function (rowIndex, rowData) {
		
			$('#express').panel('setTitle','���ʽ - '+rowData.TEDDesc);
			$("#ParrefRowId").val(rowData.TEDID);

		   $('#DHCPEEDCondition').datagrid('load', {ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:rowData.TEDID,Type:""});
			ConditionendEditing();
		   
		    
								
		},
		onLoadSuccess:function(data){
			$('#express').panel('setTitle','���ʽ - '+rowData.TEDDesc);
			$("#ParrefRowId").val(rowData.TEDID);

			  $('#DHCPEEDCondition').datagrid('load', {ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:rowData.TEDID,Type:""});
			ConditionendEditing();
		   
			
		}
		
			
	})
	
}

/**************************************��Σ��Ϣά�� end***********************************/



/************************************���ʽά��strat***********************************/

function ConditionendEditing(){
			if (ConditioneditIndex == undefined){return true}
			if ($('#DHCPEEDCondition').datagrid('validateRow', ConditioneditIndex)){
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TItemID'});
				var name = $(ed.target).combobox('getText');
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TItem'] = name;
				
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TOperator'});
				var name = $(ed.target).combobox('getText');
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TOperatorname'] = name;
				
				
				var ed = $('#DHCPEEDCondition').datagrid('getEditor',{index:ConditioneditIndex,field:'TSex'});
				var name = $(ed.target).combobox('getText');
				$('#DHCPEEDCondition').datagrid('getRows')[ConditioneditIndex]['TSexname'] = name;
				
				
				
				$('#DHCPEEDCondition').datagrid('endEdit', ConditioneditIndex);
				
				ConditioneditIndex = undefined;
				return true;
			} else {
				return false;
			}
}

function BSave_click()
{  
	//$("#DHCPEEDCondition").datagrid('ConditionendEditing', ConditioneditIndex); //���һ�н����б༭
	//alert(ConditioneditIndex+"ConditioneditIndex")	
	ConditionendEditing();
	var Char_1=String.fromCharCode(1);
	var Express=""
	var rows = $("#DHCPEEDCondition").datagrid("getRows"); 
	
	for(var i=0;i<rows.length;i++){
		
		
		
		var OneRowInfo="",Select="N",PreBracket="",ItemID="",Operator="",ODStandardID="",Reference="",AfterBracket="",Relation="",Sex="N";
		
		ItemID=rows[i].TItemID
		
		if (ItemID=="") break;
		PreBracket=rows[i].TPreBracket
		AfterBracket=rows[i].TAfterBracket
		Relation=rows[i].TRelation
		Operator=rows[i].TOperator
		
		
		Reference=rows[i].TReference
		Sex=rows[i].TSex
		NoBloodFlag=rows[i].TNoBloodFlag
		
		ODStandardID=""
		AgeRange=rows[i].TAgeRange
		
		if(AgeRange!="") {
			if(AgeRange.indexOf("-")==-1)
			{
				$.messager.alert("��ʾ","�������䷶Χ��ʽ����ȷ,ӦΪ10-20!","info");
				return false;
			}
			var AgeMin=AgeRange.split("-")[0];
			var AgeMax=AgeRange.split("-")[1];
			if((isNaN(AgeMin))||(isNaN(AgeMax)))
			{
				$.messager.alert("��ʾ","�������䲻������!","info");
				return false;
		
			}
			
		}
		OneRowInfo=PreBracket+"^"+ItemID+"^"+Operator+"^"+ODStandardID+"^"+Reference+"^"+Sex+"^"+AfterBracket+"^"+Relation+"^"+NoBloodFlag+"^"+AgeRange;
		
		if (Express!=""){
			Express=Express+Char_1+OneRowInfo;
		}else{
			Express=OneRowInfo;
		}
		

	}
	
	var iType="ED";
	var ParrefRowId=getValueById("ParrefRowId")
	var ret=tkMakeServerCall("web.DHCPE.ExcuteExpress","SaveNewExpress",iType,ParrefRowId,Express);
		
	if (ret==0){
			
		$("#DHCPEEDCondition").datagrid("load",{ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:ParrefRowId,Type:""}); 
		ConditioneditIndex = undefined;
		return true;	
	}
	
	
	
	
	
}


function loadEDCondition(rowData){
	$('#express').panel('setTitle','���ʽ - '+rowData.TEDDesc);
	$('#DHCPEEDCondition').datagrid('load', {
		ClassName:"web.DHCPE.ExcuteExpress",
			QueryName:"FindExpress",
			ParrefRowId:rowData.TEDID,
			Type:""
		
	});
	
	$("#ParrefRowId").val(rowData.TEDID);
	ConditionendEditing();
   ConditioneditIndex = undefined;
		

	
}
function InitEDConditionGrid(){
	
	$HUI.datagrid("#DHCPEEDCondition",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		singleSelect: true,
		selectOnCheck: false,
		onClickRow: ConditionClickRow,
		queryParams:{
			ClassName:"web.DHCPE.ExcuteExpress",
			QueryName:"FindExpress",
			ParrefRowId:"",
			Type:""
		},
		columns:[[
		    {field:'TPreBracket',title:'ǰ������',
		    editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'(',text:'('},{id:'((',text:'(('},{id:'(((',text:'((('},{id:'((((',text:'(((('},{id:'(((((',text:'((((('}
						]
						
					}
				}
		    
		    
		    
		    },	
		    {field:'TItemID',title:'��Ŀ',width:130,
		    formatter:function(value,row){
						return row.TItem;
					},
					
			editor:{
					type:'combobox',
					options:{
						valueField:'OD_RowId',
						textField:'OD_Desc',
						method:'get',
						//mode:'remote',
						url:$URL+"?ClassName=web.DHCPE.Report.PosQuery&QueryName=FromDescOrderDetailA&ResultSetType=array",
						onBeforeLoad:function(param){
							//param.Desc = param.q;
							
							}
						
					}
				}		
					
			/*		
		    editor:{
					type:'combogrid',
					options:{
						
						
						panelWidth:235,
						url:$URL+"?ClassName=web.DHCPE.Report.PosQuery&QueryName=FromDescOrderDetail",
						mode:'remote',
						delay:200,
						idField:'OD_RowId',
						textField:'OD_Desc',
						onBeforeLoad:function(param){
							param.Desc = param.q;
						},
						onSelect: function (rowIndex, rowData) {
							var String="^"+rowData.OD_Code+"^"+rowData.OD_RowId
							
							var NorInfo=tkMakeServerCall("web.DHCPE.ODStandard","GetNorInfo",String);
							var obj=document.getElementById("NorInfo");
							if (obj) obj.value=NorInfo;
							
						},
			
						columns:[[
							{field:'OD_RowId',hidden:true},
							{field:'OD_Desc',title:'����',width:120},
							{field:'OD_Code',title:'����',width:100}
			
						]]
						
						
						
					}
		    }*/
		    },
		    {field:'TOperator',title:'�����',width:70,
		    
		    formatter:function(value,row){
						return row.TOperatorname;
					},
		    editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'>',text:'����'},{id:'>=',text:'���ڵ���'},{id:'<',text:'С��'},{id:'<=',text:'С�ڵ���'},{id:'[',text:'����'},{id:"'[",text:'������'},{id:'=',text:'����'},{id:"'=",text:'������'}
						]
						
					}
				}
		    },
			{field:'TReference',title:'�ο�ֵ',
			editor:'text'
			
			},
			{field:'TSex',title:'�Ա�',width:70,
			 formatter:function(value,row){
						return row.TSexname;
					},
			editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'N',text:'����'},{id:'M',text:'��'},{id:'F',text:'Ů'}
						]
						
					}
				}
			},
			{field:'TNoBloodFlag',title:'��Ѫ',
			editor:{type:'icheckbox',options:{on:'Y',off:'N'}}
			
			},
			{field:'TAgeRange',title:'����',
			editor:'text'
			},
			{field:'TAfterBracket',title:'����',
			editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:')',text:')'},{id:'))',text:'))'},{id:')))',text:')))'},{id:'))))',text:'))))'},{id:')))))',text:')))))'}
						]
						
					}
				}},
			{field:'TRelation',title:'��ϵ',width:70,
			editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'text',
						data:[
							{id:'||',text:'����'},{id:'&&',text:'����'}
						]
						
					}
				}
			},
			{field:'TAdd',title:'����һ��',width:90,
			editor:{type:'linkbutton',options:{text:'����һ��',handler:function(){
				
			var NewConditioneditIndex=ConditioneditIndex+1;
				ConditionendEditing();
				$('#DHCPEEDCondition').datagrid('insertRow',{
					index: NewConditioneditIndex,
					row: {
						TPreBracket:"",
						TItemID:"",
						TOperator:"",
						TReference:"",
						TSex:"",
						TNoBloodFlag:"",
						TAgeRange:"",
						TAfterBracket:"",
						TRelation:"",
						TAdd:"����һ��",
						TDelete:"ɾ��һ��"
						}
					});
				$('#DHCPEEDCondition').datagrid('selectRow',NewConditioneditIndex).datagrid('beginEdit',NewConditioneditIndex);
				ConditioneditIndex = NewConditioneditIndex;
				
				}}}
			
			
			},
			{field:'TDelete',title:'ɾ��һ��',width:90,
			editor:{type:'linkbutton',options:{text:'ɾ��һ��',handler:function(){
				$('#DHCPEEDCondition').datagrid('deleteRow',ConditioneditIndex);
				ConditioneditIndex = undefined;
				
				}}}
			
			}
		]],
		onAfterEdit:function(rowIndex,rowData,changes){
			
			
	
			
		},
		onSelect: function (rowIndex, rowData) {
			
		}
			
					
	})
		
}

/************************************���ʽά�� end***********************************/

function InitCombobox(){
	//VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
		
	//����
	var GroupObj = $HUI.combogrid("#GroupDesc",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
				param.GBIDesc=param.q;
			param.ShowPersonGroup="1";

		},
		onShowPanel:function()
		{
			$('#GroupDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'TRowId',title:'ID',width:80},
			{field:'TGDesc',title:'��������',width:100},	
			{field:'TGStatus',title:'״̬',width:80},	
			{field:'TAdmDate',title:'����',width:100},	
		]]
		});
	
	//��ͬ 
	var ContractObj = $HUI.combogrid("#Contract",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.Contract&QueryName=SerchContractNew",
		mode:'remote',
		delay:200,
		idField:'TID',
		textField:'TName',
		onBeforeLoad:function(param){
			param.Name=param.q;
		},
		onShowPanel:function()
		{
			$('#Contract').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'TID',title:'ID',width:80},
			{field:'TNo',title:'��ͬ���',width:100},	
			{field:'TName',title:'��ͬ����',width:100},	
			{field:'TSignDate',title:'ǩ������',width:100},	
		]]
		});
		
	
	//�Ƿ���
	var IfSolveObj = $HUI.combobox("#IfSolve",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'1',text:'�Ѵ���'},
            {id:'2',text:'δ����'},
           
        ]

	});	
}

