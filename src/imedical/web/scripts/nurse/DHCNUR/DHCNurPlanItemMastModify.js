var RecID="";



$(function(){
	
	
    
	//��ʼ��������Ϣ����
	if (ItemMastID=="")
	{
		//��ʼ���ڸ�Ĭ��ֵ
	   var myDate = new Date();
	   var today=myDate.getFullYear()+"-"+(myDate.getMonth()+1)+"-"+myDate.getDate();
	   $CommonUI.getDateBox('#fromdate').datebox('setValue',today);
	   
	}
	else
	{
		FillText();
	}
	$CommonUI.getComboGrid('#Loc').combogrid({
		 panelWidth:450,
                           panelHeight:320,
                           url:'../dhcnurplan.getdata.csp?className=web.DHCNurPlanItemMast&methodName=FindLocList&type=Query&Sdesc=',  
                           idField:'rw',  
                           textField:'desc',
                           value:loc,
                           pagination: true,  
                           pageNumber: 1, 
                           pageSize: 10,
                           columns:[[  
                                    {field:'rw',title:'ID',width:50},  
                                    {field:'desc',title:'Desc',width:300}
                           ]],
		keyHandler: {
	      	     up: function(){

	      	     },
	             down: function(){

	             },
	             enter: function(){

	             },
	             query: function(q){
                          var gLoc = $CommonUI.getComboGrid('#Loc').combogrid('grid');	// get datagrid object
                             gLoc.datagrid('load',{'Sdesc':q});	// get the selected row
                          
	             }

	            
        }
                 
                  
	});
    
    //����ItemTyp������
	$CommonUI.getComboBox('#ItemTyp').combobox({  
                        url:'../dhcnurplan.getdata.csp?className=web.DHCNurPlanItemType&methodName=GetItemTyp&type=Method',  
                           valueField:'ID',  
                           textField:'Desc',  
                           panelHeight:'auto',
                           value:itemtyp
    }); 
    //����ItemCat������
    $CommonUI.getComboBox('#ItemCat').combobox({  
                       url:'../dhcnurplan.getdata.csp?className=web.DHCNurPlanItemCategory&methodName=GetItemCat&type=Method',  
                           valueField:'ID',  
                           textField:'Desc',  
                           panelHeight:'auto',
                           value:itemcat
    });  

    $CommonUI.getComboGrid('#Freq').combogrid({   
		                   panelWidth:450,
                           panelHeight:320,
                           
                           url:'../dhcnurplan.getdata.csp?className=web.DHCNurPlanItemMast&methodName=FindFreqList&type=Query&Sdesc=',  
                           idField:'rw',  
                           textField:'desc',  
                           value:freq,
                           pagination: true,  
                           pageNumber: 1, 
                           pageSize: 10,
                           columns:[[  
                                    {field:'rw',title:'ID',width:80},
                                    {field:'desc',title:'����',width:300}
                                    
                           ]],
	      keyHandler: {
	      	     up: function(){

	      	     },
	             down: function(){

	             },
	             enter: function(){

	             },
	             query: function(q){
                           var gFreq = $CommonUI.getComboGrid('#Freq').combogrid('grid');	// get datagrid object
                           gFreq.datagrid('load',{'Sdesc':q});
	             }

	            
        }


	});  
    //////������������

    //����TriggerFactor������
    $CommonUI.getComboBox('#TriggerFactor').combobox({  
                       url:'../dhcnurplan.getdata.csp?className=web.DHCNurPlanFactors&methodName=GetFactorsList&type=Method&factortyp=T',  
                           valueField:'ID',  
                           textField:'Desc',  
                           panelHeight:'auto'
    });  
    

     $CommonUI.getComboGrid('#TriggerArcim').combogrid({   
		                   panelWidth:450,
                           panelHeight:320,
                           
                           url:'../dhcnurplan.getdata.csp?className=web.DHCNurPlanItemMast&methodName=FindMasterItem&type=Query&ARCIMDesc=',  
                           idField:'ArcimDR',  
                           textField:'ArcimDesc',  
                           
                           pagination: true,  
                           pageNumber: 1, 
                           pageSize: 10,
                           columns:[[  
                                    {field:'ArcimDR',title:'ID',width:80},
                                    {field:'ArcimDesc',title:'ҽ����',width:300}
                                    
                           ]],
	      keyHandler: {
	      	     up: function(){

	      	     },
	             down: function(){

	             },
	             enter: function(){

	             },
              
	             query: function(q){
                           var gTriggerArcim = $CommonUI.getComboGrid('#TriggerArcim').combogrid('grid');	// get datagrid object
                           gTriggerArcim.datagrid('load',{'ARCIMDesc':q});
	             }

	            
        }


	});  
    
    $CommonUI.getComboBox('#TriggerEvent').combobox({  
                       url:'../dhcnurplan.getdata.csp?className=web.DHCNurPlanEvents&methodName=GetEventsList&type=Method',  
                           valueField:'ID',  
                           textField:'Desc',  
                           panelHeight:'auto'
    }); 

    $CommonUI.getComboGrid('#TriggerDiag').combogrid({   
		                   panelWidth:450,
                           panelHeight:320,
                           
                           url:'../dhcnurplan.getdata.csp?className=web.DHCNurPlanItemMast&methodName=FindDiagList&type=Query&Sdesc=',  
                           idField:'rw',  
                           textField:'desc',  
                           
                           pagination: true,  
                           pageNumber: 1, 
                           pageSize: 10,
                           columns:[[  
                                    {field:'rw',title:'ID',width:80},
                                    {field:'desc',title:'����',width:300}
                                    
                           ]],
	      keyHandler: {
	      	     up: function(){

	      	     },
	             down: function(){

	             },
	             enter: function(){

	             },
	             query: function(q){
                           var gTriggerDiag = $CommonUI.getComboGrid('#TriggerDiag').combogrid('grid');	// get datagrid object
                           gTriggerDiag.datagrid('load',{'Sdesc':q});
	             }

	            
        }


	});  
    
    $CommonUI.getComboBox('#TriggerConTyp').combobox('setValue','');
    $CommonUI.getComboBox('#TriggerFuncTyp').combobox('setValue','');

    $CommonUI.getComboGrid('#TriggerFreq').combogrid({   
		                   panelWidth:450,
                           panelHeight:320,
                           
                           url:'../dhcnurplan.getdata.csp?className=web.DHCNurPlanItemMast&methodName=FindFreqList&type=Query&Sdesc=',  
                           idField:'rw',  
                           textField:'desc',  
                           
                           pagination: true,  
                           pageNumber: 1, 
                           pageSize: 10,
                           columns:[[  
                                    {field:'rw',title:'ID',width:80},
                                    {field:'desc',title:'����',width:300}
                                    
                           ]],
	      keyHandler: {
	      	     up: function(){

	      	     },
	             down: function(){

	             },
	             enter: function(){

	             },
	             query: function(q){
                           var gTriggerFreq = $CommonUI.getComboGrid('#TriggerFreq').combogrid('grid');	// get datagrid object
                           gTriggerFreq.datagrid('load',{'Sdesc':q});
	             }

	            
        }


	});  
     
    $CommonUI.datagrid('#dgTrigger', urlTrigger, queryParamsTrigger, columnsTrigger, pageOptsTrigger, sortOptsTrigger, optionsTrigger);
    $CommonUI.getDataGrid('#dgTrigger').datagrid({
	      onClickRow: function(rowIndex,rowData){
	      	//alert(3)
	      	//alert(rowData['id']+"^"+rowData['emrcode']+"^"+rowData['elementcode']+"^"+rowData['contyp']+"^"+rowData['convalue']+"^"+rowData['func']+"^"+rowData['funcpara']+"^"+rowData['functyp']+"^"+rowData['funcnote']+"^"+rowData['freq']+"^"+rowData['cusfreq']+"^"+rowData['factorId']+"^"+rowData['arcimId']+"^"+rowData['eventId']+"^"+rowData['diagId'])
	      	FillTrigger(rowData['id'],rowData['emrcode'],rowData['elementcode'],rowData['contyp'],rowData['convalue'],rowData['func'],rowData['funcpara'],rowData['functyp'],rowData['funcnote'],rowData['freqid'],rowData['cusfreq'],rowData['factorId'],rowData['arcimId'],rowData['eventId'],rowData['diagId']);
	      	

	      }
      });
    
    ///�����������

    $CommonUI.getComboBox('#CompleteConTyp').combobox('setValue','');
    $CommonUI.getComboBox('#CompleteFuncTyp').combobox('setValue','');

    //����TriggerFactor������
    $CommonUI.getComboBox('#CompleteFactor').combobox({  
                       url:'../dhcnurplan.getdata.csp?className=web.DHCNurPlanFactors&methodName=GetFactorsList&type=Method&factortyp=C',  
                           valueField:'ID',  
                           textField:'Desc',  
                           panelHeight:'auto'
    });  
    

     $CommonUI.getComboGrid('#CompleteArcim').combogrid({   
		                   panelWidth:450,
                           panelHeight:320,
                           
                           url:'../dhcnurplan.getdata.csp?className=web.DHCNurPlanItemMast&methodName=FindMasterItem&type=Query&ARCIMDesc=',  
                           idField:'ArcimDR',  
                           textField:'ArcimDesc',  
                           
                           pagination: true,  
                           pageNumber: 1, 
                           pageSize: 10,
                           columns:[[  
                                    {field:'ArcimDR',title:'ID',width:80},
                                    {field:'ArcimDesc',title:'ҽ����',width:300}
                                    
                           ]],
	      keyHandler: {
	      	     up: function(){

	      	     },
	             down: function(){

	             },
	             enter: function(){

	             },
	             query: function(q){
                           var gCompleteArcim = $CommonUI.getComboGrid('#CompleteArcim').combogrid('grid');	// get datagrid object
                           gCompleteArcim.datagrid('load',{'ARCIMDesc':q});
	             }

	            
        }


	});  
    
    $CommonUI.datagrid('#dgComplete', urlComplete, queryParamsComplete, columnsComplete, pageOptsComplete, sortOptsComplete, optionsComplete);
    $CommonUI.getDataGrid('#dgComplete').datagrid({
	      onClickRow: function(rowIndex,rowData){
	      	//alert(3)
	      	//alert(rowData['id']+"^"+rowData['emrcode']+"^"+rowData['elementcode']+"^"+rowData['contyp']+"^"+rowData['convalue']+"^"+rowData['func']+"^"+rowData['funcpara']+"^"+rowData['functyp']+"^"+rowData['funcnote']+"^"+rowData['freq']+"^"+rowData['cusfreq']+"^"+rowData['factorId']+"^"+rowData['arcimId']+"^"+rowData['eventId']+"^"+rowData['diagId'])
	      	FillComplete(rowData['id'],rowData['emrcode'],rowData['elementcode'],rowData['contyp'],rowData['convalue'],rowData['func'],rowData['funcpara'],rowData['functyp'],rowData['funcnote'],rowData['factorId'],rowData['arcimId']);
	      	

	      }
      });
    //��չPnTrigger��ʱ�����
    $CommonUI.getPanel('#PnTrigger').panel({  
                      onExpand:function(){
                      	//alert(1);
                      }
    });

    //��չPnComplete��ʱ�����
    $CommonUI.getPanel('#PnComplete').panel({  
                      onExpand:function(){
                      	//alert(2);
                      }
    });
    

    
 
});

///������Ϣ����
function FillText()
{
	var obj=document.getElementById("ID");
	obj.value=ItemMastID;
	var obj=document.getElementById("Code");
	obj.value=code;
	var obj=document.getElementById("Desc");
	obj.value=desc;
	
	var obj=document.getElementById("KeyWord");
	obj.value=keyword;

	var obj=document.getElementById("Note");
	obj.value=note;
	
	
	
	
	
	
	var obj=document.getElementById("CustomFreq");
	obj.value=customfreq;

	
	$CommonUI.getDateBox('#fromdate').datebox('setValue', fromdate);
	$CommonUI.getDateBox('#todate').datebox('setValue', todate);

}

function SaveData()
{
	
	var IsValidCode=$CommonUI.getValidateBox('#Code').validatebox('isValid');
	if (!IsValidCode){
	    $CommonUI.alert("���������!"); 
	    return; 	
	}
	var IsValidDesc=$CommonUI.getValidateBox('#Desc').validatebox('isValid');
	if (!IsValidDesc){
	    $CommonUI.alert("����������!"); 
	    return; 	
	}
	var FromDat=$CommonUI.getDateBox('#fromdate').datebox('getValue');
	if (FromDat==""){
	    $CommonUI.alert("�����뿪ʼ����!"); 
	    return; 	
	}
	
	var ID=document.getElementById("ID").value;
	var Code=document.getElementById("Code").value;
	var Desc=document.getElementById("Desc").value;

	var KeyWord=document.getElementById("KeyWord").value;
	var Note=document.getElementById("Note").value;

    var ItemTypID=$CommonUI.getComboBox('#ItemTyp').combobox('getValue');
	var ItemCatID=$CommonUI.getComboBox('#ItemCat').combobox('getValue');
	
	var CustomFreq=document.getElementById("CustomFreq").value;
    var LocID;
    var LocText=$CommonUI.getComboGrid('#Loc').combogrid('getText');
    if (LocText==""){
        LocID="";
    }else{
    	LocID=$CommonUI.getComboGrid('#Loc').combogrid('getValue');
    }
	var Freq;
    var FreqText=$CommonUI.getComboGrid('#Freq').combogrid('getText');
    if (FreqText==""){
        Freq="";
    }else{
    	Freq=$CommonUI.getComboGrid('#Freq').combogrid('getValue');
    }
	var EndDat=$CommonUI.getDateBox('todate').datebox('getValue');
	
	
	var parr=ID+"^"+Code+"^"+Desc+"^"+KeyWord+"^"+Note+"^"+ItemTypID+"^"+ItemCatID+"^"+Freq+"^"+CustomFreq+"^"+LocID+"^"+FromDat+"^"+EndDat;

	
	var str=cspRunServerMethod(SaveMethod,parr);
	
	if (str>0)
	{
	    $CommonUI.alert("����ɹ�!"); 
	    window.opener.RefreshGrid(); 
	    window.close();
	    return; 	
	}
	else
	{
		$CommonUI.alert(str); 
	    return; 	
	}
	
}

function Cancel()
{
	window.close();
}


//������������///////////////////////////////////////////////////////////////////////////////

var urlTrigger = '../../csp/dhcnurplan.getdata.csp?className=web.DHCNurPlanItemTrigger&methodName=FindItemTrigger&type=Query&ItemID='+ItemMastID; 


var queryParamsTrigger = { 
 page: 1, 
 rows: 10
}; 

var columnsTrigger=[
// title|field|width|rowspan|colspan|align|
//sortable|resizable|hidden|checkbox|formatter|styler|sorter|editor 
[ //��ͷ
  {title: 'ID', field: 'id', width:50,sortable:true},
  {title: '����', field: 'factordesc',width:100, sortable:true},
  {title: 'ҽ��', field: 'arcimDesc',width:200, sortable:true},
  {title: '�¼�', field: 'eventdesc',width:100, sortable:true},
  {title: '���', field: 'diagdesc',width:200, sortable:true},
  {title: 'ģ�����', field: 'emrcode',width:100, sortable:true},
  {title: 'Ԫ�ش���', field: 'elementcode',width:100, sortable:true},
  {title: '��������', field: 'contyp', width:100,sortable:true}, 
  {title: '����ֵ', field: 'convalue', width:100,sortable:true}, 
  {title: '�ӿں���', field: 'func', width:100,sortable:true}, 
  {title: '����', field: 'funcpara', width:100,sortable:true}, 
  {title: '����', field: 'functyp', width:100,sortable:true}, 
  {title: '��ע', field: 'funcnote', width:100,sortable:true}, 
  {title: 'Ƶ��', field: 'freq', width:100,sortable:true}, 
  {title: '�Զ���Ƶ��', field: 'cusfreq', width:100,sortable:true}, 
  {title: 'factorId', field: 'factorId', width:100,sortable:true}, 
  {title: 'arcimId', field: 'arcimId', width:100,sortable:true}, 
  {title: 'eventId', field: 'eventId', width:100,sortable:true}, 
  {title: 'diagId', field: 'diagId', width:100,sortable:true},
  {title: 'freqid', field: 'freqid', width:100,sortable:true}
  
]
];

var pageOptsTrigger = { 
 pagination: true, 
 pageNumber: 1, 
pageSize: 10 
}; 

var sortOptsTrigger = { 
 remoteSort: false, // ������������ 
sortName: '', // 
sortOrder: 'asc' // 
}; 

var optionsTrigger = { 
 //lastIndex: -1, 
 singleSelect: true,
 rowStyler : rowStylerTrigger, 
 //toolbar: toolbar("#datagrid1_1"), 
 title:'��������', 
 idField: 'id', // 
 //fitColumn: true, 
 //fit:true,
 method: 'post', 
 collapsible: false, 
 width: 1000, 
 height: 300 
}; 

var rowStylerTrigger = function(index,row,css) { 
 // ����ʽ 
 if (parseInt(row.id)>1){ 
  return 'background-color:#6293BB;color:#fff;font-weight:bold;'; 
 } 
}; 

function AddTrigger()
{
  var ID=document.getElementById("ID").value;
  if (ID==""){
      $CommonUI.alert("���������Ŀ!"); 
      return;   
  }
	var TriggerFactor=$CommonUI.getComboBox('#TriggerFactor').combobox('getValue');
	if (TriggerFactor==""){
	    $CommonUI.alert("��ѡ�񴥷�����!"); 
	    return; 	
	}
	
    var FactorText=$CommonUI.getComboBox('#TriggerFactor').combobox('getText');
    
    var TriggerArcim=$CommonUI.getComboGrid('#TriggerArcim').combogrid('getValue');
    if ((FactorText.indexOf("ҽ��")>-1)&&(TriggerArcim=="")){
	    $CommonUI.alert("��ѡ��ҽ��!"); 
	    return; 	
	}
	var TriggerEvent=$CommonUI.getComboBox('#TriggerEvent').combobox('getValue');
	if ((FactorText.indexOf("�¼�")>-1)&&(TriggerEvent=="")){
	    $CommonUI.alert("��ѡ���¼�!"); 
	    return; 	
	}
	var TriggerDiag=$CommonUI.getComboGrid('#TriggerDiag').combogrid('getValue');
    if ((FactorText.indexOf("���")>-1)&&(TriggerDiag=="")){
	    $CommonUI.alert("��ѡ�����!"); 
	    return; 	
	}
	
	var TriggerEmrCode=document.getElementById("TriggerEmrCode").value;
	if ((FactorText.indexOf("����")>-1)&&(TriggerEmrCode=="")){
	    $CommonUI.alert("������ģ����뼰����!"); 
	    return; 	
	}

	var TriggerElementCode=document.getElementById("TriggerElementCode").value;
	if ((FactorText.indexOf("����")>-1)&&(TriggerElementCode=="")){
	    $CommonUI.alert("������Ԫ�ش��뼰����!"); 
	    return; 	
	}

	var TriggerFunction=document.getElementById("TriggerFunction").value;

	if ((FactorText.indexOf("�ӿ�")>-1)&&(TriggerFunction=="")){
	    $CommonUI.alert("������ӿں���������!"); 
	    return; 	
	}

    var TriggerFreq=$CommonUI.getComboBox('#TriggerFreq').combobox('getValue');
    var TriggerCusFreq=document.getElementById("TriggerCusFreq").value;
	if ((FactorText.indexOf("ҽ��")<0)&&(TriggerFreq=="")&&(TriggerCusFreq=="")){
	    $CommonUI.alert("��ѡ��Ƶ�λ�¼���Զ���Ƶ��!"); 
	    return; 	
	}
    
    var TriggerConTyp=$CommonUI.getComboBox('#TriggerConTyp').combobox('getValue');
    var TriggerConValue=document.getElementById("TriggerConValue").value;

    var TriggerFuncPara=document.getElementById("TriggerFuncPara").value;
	var TriggerFuncTyp=$CommonUI.getComboBox('#TriggerFuncTyp').combobox('getValue');
	var TriggerFuncNote=document.getElementById("TriggerFuncNote").value;
	
	
	
	
	var parr=ItemMastID+"^^"+TriggerFactor+"^"+TriggerArcim+"^"+TriggerEvent+"^"+TriggerDiag+"^"+TriggerEmrCode+"^"+TriggerElementCode;
	parr=parr+"^"+TriggerConTyp+"^"+TriggerConValue+"^"+TriggerFunction+"^"+TriggerFuncPara+"^"+TriggerFuncTyp+"^"+TriggerFuncNote;
	parr=parr+"^"+TriggerFreq+"^"+TriggerCusFreq+"^"+session['LOGON.USERID'];
	
	var strifhave=tkMakeServerCall("web.DHCNurPlanItemTrigger","ifHave",parr);
	if (strifhave==1)
	{
		alert("�����Ŀ�ظ�,����!");
		return;
	}
	
	var str=cspRunServerMethod(SaveTrigger,parr);
	if (str.indexOf("||")>-1)
	{
	    $CommonUI.alert("��ӳɹ�!"); 
	    $CommonUI.getDataGrid('#dgTrigger').datagrid('reload');
	    clearTrigger();
	    return; 	
	}
	else
	{
		$CommonUI.alert(str); 
	    return; 	
	}
}

function UpdateTrigger()
{
	var TriggerID=document.getElementById("TriggerID").value;
	if (TriggerID==""){
	    $CommonUI.alert("��ѡ��һ����¼!"); 
	    return; 	
	}
	var TriggerFactor=$CommonUI.getComboBox('#TriggerFactor').combobox('getValue');
	if (TriggerFactor==""){
	    $CommonUI.alert("��ѡ�񴥷�����!"); 
	    return; 	
	}
	
    var FactorText=$CommonUI.getComboBox('#TriggerFactor').combobox('getText');
    
    var TriggerArcim=$CommonUI.getComboGrid('#TriggerArcim').combogrid('getValue');
    if ((FactorText.indexOf("ҽ��")>-1)&&(TriggerArcim=="")){
	    $CommonUI.alert("��ѡ��ҽ��!"); 
	    return; 	
	}
	var TriggerEvent=$CommonUI.getComboBox('#TriggerEvent').combobox('getValue');
	if ((FactorText.indexOf("�¼�")>-1)&&(TriggerEvent=="")){
	    $CommonUI.alert("��ѡ���¼�!"); 
	    return; 	
	}
	var TriggerDiag=$CommonUI.getComboGrid('#TriggerDiag').combogrid('getValue');
    if ((FactorText.indexOf("���")>-1)&&(TriggerDiag=="")){
	    $CommonUI.alert("��ѡ�����!"); 
	    return; 	
	}
	
	var TriggerEmrCode=document.getElementById("TriggerEmrCode").value;
	if ((FactorText.indexOf("����")>-1)&&(TriggerEmrCode=="")){
	    $CommonUI.alert("������ģ����뼰����!"); 
	    return; 	
	}

	var TriggerElementCode=document.getElementById("TriggerElementCode").value;
	if ((FactorText.indexOf("����")>-1)&&(TriggerElementCode=="")){
	    $CommonUI.alert("������Ԫ�ش��뼰����!"); 
	    return; 	
	}

	var TriggerFunction=document.getElementById("TriggerFunction").value;

	if ((FactorText.indexOf("�ӿ�")>-1)&&(TriggerFunction=="")){
	    $CommonUI.alert("������ӿں���������!"); 
	    return; 	
	}

    var TriggerFreq=$CommonUI.getComboBox('#TriggerFreq').combobox('getValue');
    var TriggerCusFreq=document.getElementById("TriggerCusFreq").value;
	if ((FactorText.indexOf("ҽ��")<0)&&(TriggerFreq=="")&&(TriggerCusFreq=="")){
	    $CommonUI.alert("��ѡ��Ƶ�λ�¼���Զ���Ƶ��!"); 
	    return; 	
	}
    
    var TriggerConTyp=$CommonUI.getComboBox('#TriggerConTyp').combobox('getValue');
    var TriggerConValue=document.getElementById("TriggerConValue").value;

    var TriggerFuncPara=document.getElementById("TriggerFuncPara").value;
	var TriggerFuncTyp=$CommonUI.getComboBox('#TriggerFuncTyp').combobox('getValue');
	var TriggerFuncNote=document.getElementById("TriggerFuncNote").value;
	
	
	
	
	var parr=ItemMastID+"^"+TriggerID+"^"+TriggerFactor+"^"+TriggerArcim+"^"+TriggerEvent+"^"+TriggerDiag+"^"+TriggerEmrCode+"^"+TriggerElementCode;
	parr=parr+"^"+TriggerConTyp+"^"+TriggerConValue+"^"+TriggerFunction+"^"+TriggerFuncPara+"^"+TriggerFuncTyp+"^"+TriggerFuncNote;
	parr=parr+"^"+TriggerFreq+"^"+TriggerCusFreq+"^"+session['LOGON.USERID'];
	
	var str=cspRunServerMethod(SaveTrigger,parr);
	if (str.indexOf("||")>-1)
	{
	    $CommonUI.alert("�޸ĳɹ�!"); 
	    $CommonUI.getDataGrid('#dgTrigger').datagrid('reload');
	    clearTrigger();
	    return; 	
	}
	else
	{
		$CommonUI.alert(str); 
	    return; 	
	}
}

//readonly="readonly"
function DeleteTrigger()
{
	var TriggerID=document.getElementById("TriggerID").value;
	if (TriggerID==""){
	    $CommonUI.alert("��ѡ��һ����¼!"); 
	    return; 	
	}
	$CommonUI.confirm('��ȷ��Ҫɾ��������¼��?','warning','',function(r)
	{ 
	        
             var str=cspRunServerMethod(DeleteTrig,TriggerID);
	           if (str==0)
	           {
	                 $CommonUI.alert("ɾ���ɹ�!");
	                 $CommonUI.getDataGrid('#dgTrigger').datagrid('reload');
	                 clearTrigger(); 
	                 return; 	
	           }
	           else
	           {
		             $CommonUI.alert(str); 
	                 return; 	
	           }
            
    });  

}

function clearTrigger()
{
	$CommonUI.getForm('#ffTrigger').form('clear');
}

function FillTrigger(Sid,Semrcode,Selementcode,Scontyp,Sconvalue,Sfunc,Sfuncpara,Sfunctyp,Sfuncnote,Sfreq,Scusfreq,SfactorId,SArcimId,SEventId,SDiagId)
{
	var obj=document.getElementById("TriggerID");
	obj.value=Sid;
	var obj=document.getElementById("TriggerEmrCode");
	obj.value=Semrcode;
	var obj=document.getElementById("TriggerElementCode");
	obj.value=Selementcode;
	$CommonUI.getComboBox('#TriggerConTyp').combobox('setValue',Scontyp);
	var obj=document.getElementById("TriggerConValue");
	obj.value=Sconvalue;
	var obj=document.getElementById("TriggerFunction");
	obj.value=Sfunc;
	var obj=document.getElementById("TriggerFuncPara");
	obj.value=Sfuncpara;
	$CommonUI.getComboBox('#TriggerFuncTyp').combobox('setValue',Sfunctyp);
	var obj=document.getElementById("TriggerFuncNote");
	obj.value=Sfuncnote;

	

	var obj=document.getElementById("TriggerCusFreq");
	obj.value=Scusfreq;
	
	$CommonUI.getComboBox('#TriggerFactor').combobox('setValue',SfactorId);
  //alert(SArcimId)
	$CommonUI.getComboGrid('#TriggerArcim').combogrid({   
		            value:SArcimId
		 })
	$CommonUI.getComboBox('#TriggerEvent').combobox('setValue',SEventId);
	$CommonUI.getComboGrid('#TriggerDiag').combogrid({   
		value:SDiagId
		 })
	  if (Sfreq!=""){
	     $CommonUI.getComboGrid('#TriggerFreq').combogrid({   
		value:Sfreq
		 })
	}else{
	     $CommonUI.getComboGrid('#TriggerFreq').combogrid('setValue','');
	}
	
	
	
}
///////////////////////////////////////////////////////////////////////////////

//�����������///////////////////////////////////////////////////////////////////////////////

var urlComplete = '../../csp/dhcnurplan.getdata.csp?className=web.DHCNurPlanItemComplete&methodName=FindItemComplete&type=Query&ItemID='+ItemMastID; 


var queryParamsComplete = { 
 page: 1, 
 rows: 10
}; 

var columnsComplete=[
// title|field|width|rowspan|colspan|align|
//sortable|resizable|hidden|checkbox|formatter|styler|sorter|editor 
[ //��ͷ
  {title: 'ID', field: 'id', width:50,sortable:true},
  {title: '����', field: 'factordesc',width:100, sortable:true},
  {title: 'ҽ��', field: 'arcimDesc',width:200, sortable:true},
  {title: 'ģ�����', field: 'emrcode',width:100, sortable:true},
  {title: 'Ԫ�ش���', field: 'elementcode',width:100, sortable:true},
  {title: '��������', field: 'contyp', width:100,sortable:true}, 
  {title: '����ֵ', field: 'convalue', width:100,sortable:true}, 
  {title: '�ӿں���', field: 'func', width:100,sortable:true}, 
  {title: '����', field: 'funcpara', width:100,sortable:true}, 
  {title: '����', field: 'functyp', width:100,sortable:true}, 
  {title: '��ע', field: 'funcnote', width:100,sortable:true}, 
  {title: 'factorId', field: 'factorId', width:100,sortable:true}, 
  {title: 'arcimId', field: 'arcimId', width:100,sortable:true} 
  
  
]
];

var pageOptsComplete = { 
 pagination: true, 
 pageNumber: 1, 
pageSize: 10 
}; 

var sortOptsComplete = { 
 remoteSort: false, // ������������ 
sortName: '', // 
sortOrder: 'asc' // 
}; 

var optionsComplete = { 
 //lastIndex: -1, 
 singleSelect: true,
 rowStyler : rowStylerComplete, 
 //toolbar: toolbar("#datagrid1_1"), 
 title:'�������', 
 idField: 'id', // 
 //fitColumn: true, 
 //fit:true,
 method: 'post', 
 collapsible: false, 
 width: 1000, 
 height: 300 
}; 

var rowStylerComplete = function(index,row,css) { 
 // ����ʽ 
 if (parseInt(row.id)>1){ 
  return 'background-color:#6293BB;color:#fff;font-weight:bold;'; 
 } 
}; 

function AddComplete()
{
  var ID=document.getElementById("ID").value;
  if (ID==""){
      $CommonUI.alert("���������Ŀ!"); 
      return;   
  }
	var CompleteFactor=$CommonUI.getComboBox('#CompleteFactor').combobox('getValue');
	if (CompleteFactor==""){
	    $CommonUI.alert("��ѡ���������!"); 
	    return; 	
	}
	
    var FactorText=$CommonUI.getComboBox('#CompleteFactor').combobox('getText');
    
    var CompleteArcim=$CommonUI.getComboGrid('#CompleteArcim').combogrid('getValue');
    if ((FactorText.indexOf("ҽ��")>-1)&&(CompleteArcim=="")){
	    $CommonUI.alert("��ѡ��ҽ����!"); 
	    return; 	
	}
	
	
	var CompleteEmrCode=document.getElementById("CompleteEmrCode").value;
	if ((FactorText.indexOf("����")>-1)&&(CompleteEmrCode=="")){
	    $CommonUI.alert("������ģ����뼰����!"); 
	    return; 	
	}

	var CompleteElementCode=document.getElementById("CompleteElementCode").value;
	if ((FactorText.indexOf("����")>-1)&&(CompleteElementCode=="")){
	    $CommonUI.alert("������Ԫ�ش��뼰����!"); 
	    return; 	
	}

	var CompleteFunction=document.getElementById("CompleteFunction").value;

	if ((FactorText.indexOf("�ӿ�")>-1)&&(CompleteFunction=="")){
	    $CommonUI.alert("������ӿں���������!"); 
	    return; 	
	}

   
    
    var CompleteConTyp=$CommonUI.getComboBox('#CompleteConTyp').combobox('getValue');
    var CompleteConValue=document.getElementById("CompleteConValue").value;

    var CompleteFuncPara=document.getElementById("CompleteFuncPara").value;
	var CompleteFuncTyp=$CommonUI.getComboBox('#CompleteFuncTyp').combobox('getValue');
	var CompleteFuncNote=document.getElementById("CompleteFuncNote").value;
	
	
	
	
	var parr=ItemMastID+"^^"+CompleteFactor+"^"+CompleteArcim+"^"+CompleteEmrCode+"^"+CompleteElementCode+"^"+CompleteConTyp+"^"+CompleteConValue;
	parr=parr+"^"+CompleteFunction+"^"+CompleteFuncPara+"^"+CompleteFuncTyp+"^"+CompleteFuncNote+"^"+session['LOGON.USERID'];
	
	var strifhave=tkMakeServerCall("web.DHCNurPlanItemComplete","ifHave",parr);
	if (strifhave==1)
	{
		alert("�����Ŀ�ظ�,����!");
		return;
	}
	var str=cspRunServerMethod(SaveComplete,parr);
	if (str.indexOf("||")>-1)
	{
	    $CommonUI.alert("��ӳɹ�!"); 
	    $CommonUI.getDataGrid('#dgComplete').datagrid('reload');
	    clearComplete();
	    return; 	
	}
	else
	{
		$CommonUI.alert(str); 
	    return; 	
	}
}

function UpdateComplete()
{
	var CompleteID=document.getElementById("CompleteID").value;
	if (CompleteID==""){
	    $CommonUI.alert("��ѡ��һ����¼!"); 
	    return; 	
	}
	var CompleteFactor=$CommonUI.getComboBox('#CompleteFactor').combobox('getValue');
	if (CompleteFactor==""){
	    $CommonUI.alert("��ѡ�񴥷�����!"); 
	    return; 	
	}
	
    var FactorText=$CommonUI.getComboBox('#CompleteFactor').combobox('getText');
    
    var CompleteArcim=$CommonUI.getComboGrid('#CompleteArcim').combogrid('getValue');
    if ((FactorText.indexOf("ҽ��")>-1)&&(CompleteArcim=="")){
	    $CommonUI.alert("��ѡ��ҽ��!"); 
	    return; 	
	}
	
	
	var CompleteEmrCode=document.getElementById("CompleteEmrCode").value;
	if ((FactorText.indexOf("����")>-1)&&(CompleteEmrCode=="")){
	    $CommonUI.alert("������ģ����뼰����!"); 
	    return; 	
	}

	var CompleteElementCode=document.getElementById("CompleteElementCode").value;
	if ((FactorText.indexOf("����")>-1)&&(CompleteElementCode=="")){
	    $CommonUI.alert("������Ԫ�ش��뼰����!"); 
	    return; 	
	}

	var CompleteFunction=document.getElementById("CompleteFunction").value;

	if ((FactorText.indexOf("�ӿ�")>-1)&&(CompleteFunction=="")){
	    $CommonUI.alert("������ӿں���������!"); 
	    return; 	
	}

   
    
    var CompleteConTyp=$CommonUI.getComboBox('#CompleteConTyp').combobox('getValue');
    var CompleteConValue=document.getElementById("CompleteConValue").value;

    var CompleteFuncPara=document.getElementById("CompleteFuncPara").value;
	var CompleteFuncTyp=$CommonUI.getComboBox('#CompleteFuncTyp').combobox('getValue');
	var CompleteFuncNote=document.getElementById("CompleteFuncNote").value;
	
	
	
	
	var parr=ItemMastID+"^"+CompleteID+"^"+CompleteFactor+"^"+CompleteArcim+"^"+CompleteEmrCode+"^"+CompleteElementCode+"^"+CompleteConTyp+"^"+CompleteConValue;
	parr=parr+"^"+CompleteFunction+"^"+CompleteFuncPara+"^"+CompleteFuncTyp+"^"+CompleteFuncNote+"^"+session['LOGON.USERID'];
	
	//alert(parr)
	var str=cspRunServerMethod(SaveComplete,parr);
	if (str.indexOf("||")>-1)
	{
	    $CommonUI.alert("�޸ĳɹ�!"); 
	    $CommonUI.getDataGrid('#dgComplete').datagrid('reload');
	    clearComplete();
	    return; 	
	}
	else
	{
		$CommonUI.alert(str); 
	    return; 	
	}
}

//readonly="readonly"
function DeleteComplete()
{
	var CompleteID=document.getElementById("CompleteID").value;
	if (CompleteID==""){
	    $CommonUI.alert("��ѡ��һ����¼!"); 
	    return; 	
	}
	$CommonUI.confirm('��ȷ��Ҫɾ��������¼��?','warning','',function(r)
	{ 
	        
             var str=cspRunServerMethod(DeleteComp,CompleteID);
	           if (str==0)
	           {
	                 $CommonUI.alert("ɾ���ɹ�!");
	                 $CommonUI.getDataGrid('#dgComplete').datagrid('reload');
	                 clearComplete(); 
	                 return; 	
	           }
	           else
	           {
		             $CommonUI.alert(str); 
	                 return; 	
	           }
            
    });  

}

function clearComplete()
{
	$CommonUI.getForm('#ffComplete').form('clear');
}

function FillComplete(Sid,Semrcode,Selementcode,Scontyp,Sconvalue,Sfunc,Sfuncpara,Sfunctyp,Sfuncnote,SfactorId,SArcimId)
{
	var obj=document.getElementById("CompleteID");
	obj.value=Sid;
	var obj=document.getElementById("CompleteEmrCode");
	obj.value=Semrcode;
	var obj=document.getElementById("CompleteElementCode");
	obj.value=Selementcode;
	$CommonUI.getComboBox('#CompleteConTyp').combobox('setValue',Scontyp);
	var obj=document.getElementById("CompleteConValue");
	obj.value=Sconvalue;
	var obj=document.getElementById("CompleteFunction");
	obj.value=Sfunc;
	var obj=document.getElementById("CompleteFuncPara");
	obj.value=Sfuncpara;
	$CommonUI.getComboBox('#CompleteFuncTyp').combobox('setValue',Sfunctyp);
	var obj=document.getElementById("CompleteFuncNote");
	obj.value=Sfuncnote;

	

	
	
	$CommonUI.getComboBox('#CompleteFactor').combobox('setValue',SfactorId);
	$CommonUI.getComboGrid('#CompleteArcim').combogrid({   
		value:SArcimId
		 })
	
	
	
	
	
}
