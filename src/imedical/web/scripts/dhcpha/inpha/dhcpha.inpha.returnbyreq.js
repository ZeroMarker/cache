/*
ģ��:סԺҩ��
��ģ��:סԺҩ��-���뵥��ҩ
createdate:2016-05-16
creator:yunhaibao,dinghongying
*/
var commonInPhaUrl = "DHCST.INPHA.ACTION.csp";
var commonOutPhaUrl="DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var RequestStatus="P";
var requestNoStr="";
var currEditRow=undefined; //�����б༭
$(function(){
	InitTitle();
	InitPhaLoc();
	InitWardList();	
    InitReqList()
	InitReqDetail();	
	InitReqTotal();
   	$('#patNo').bind('keypress',function(event){
        if(event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			$("#patInfo").text("")
			if (patno!=""){
				SetPatInfo(patno);
			}
        }
    });
    $('#checkedDocFlag').bind('click',function(){
		ChangeWardList();
    });
    $('#btnFind').bind('click',function(){
		QueryReqList();
    });
    $('#btnFindSelect').bind('click',function(){
		QuerySelectReqDetail();
    });
    $('#btnReturn').bind('click',function(){
		btnReturnHandler();
    });
    $('#reqdetail').datagrid('loadData',{total:0,rows:[]});
    $('#reqdetail').datagrid('options').queryParams.params = "";
    $('#reqtotal').datagrid('loadData',{total:0,rows:[]});
    $('#reqtotal').datagrid('options').queryParams.params = "";

})
function InitTitle(){
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: commonOutPhaUrl+'?action=GetPminoLen',//�ύ������ �����ķ���  
		data: "",
		success:function(value){     
			if (value!=""){
				hisPatNoLen=value;
			}   
		},    
		error:function(){        
			alert("��ȡ�ǼǺų���ʧ��!");
		}
	});
	$("#startDate").datebox("setValue", formatDate(0));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));  //Init�������� 
}
function InitPhaLoc(){
	$('#phaLoc').combobox({  
		width:150,
		panelWidth: 150,
		url:commonInPhaUrl+'?action=GetStockPhlocDs&groupId='+gGroupId,  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#phaLoc').combobox('getData');
            if (data.length > 0) {
                  $('#phaLoc').combobox('select', gLocId);
              }            
	    },
	    onSelect:function(){
			ChangeWardList();	          
		}
	});
}
function InitWardList()
{
	$('#wardLoc').combobox({  
		width:150,
		panelWidth: 225,
		url:commonInPhaUrl+'?action=GetWardListByDocFlag',  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){         
	    }
	})
}
function ChangeWardList()
{
	$('#wardLoc').combobox("setValue","") 
	if($("#checkedDocFlag").is(':checked')){   
		var selectloc=$('#phaLoc').combobox("getValue") 
		var params=selectloc+"^"+"1"
		$('#wardLoc').combobox('reload',commonInPhaUrl+'?action=GetWardListByDocFlag&params='+params); 
	}
	else{
		InitWardList();
	}
}


//��ʼ�����뵥�б�
function InitReqList(){
	//����columns
	var columnspat=[[
	    {field:'TSelect',title:'ѡ��',width:40,
	    	formatter:function(value,row,index){
				if (value=="Y"){
					return '<input type="checkbox" name="DispDataGridCheckbox" checked="checked" >';
				}
				else{
					return '<input type="checkbox" name="DispDataGridCheckbox" >';
				}
			}
	    },    
        {field:'TReqNo',title:'���뵥��',width:150},    
        {field:'TReqDate',title:'��������',width:75},
        {field:'TWard',title:'����',width:150},
        {field:'TReqOper',title:'������',width:60},
         ]];  
	
   //����datagrid	
   $('#reqlist').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  selectOnCheck: true, 
	  checkOnSelect: false,
	  rownumbers:false,
      columns:columnspat,   
      pageSize:30,  // ÿҳ��ʾ�ļ�¼����
	  pageList:[30,50,100],   // ��������ÿҳ��¼�������б�
	  loadMsg: '���ڼ�����Ϣ...',
	  pagination:true,
	  onClickCell: function (rowIndex, field, value) {
		if (field=="TSelect"){
			var tmpcheckvalue=""
			if (value=="Y"){tmpcheckvalue="N"}
			else{tmpcheckvalue="Y"}
			$('#reqlist').datagrid('updateRow',{
				index: rowIndex,
				row: {TSelect:tmpcheckvalue}
			})			
			return;
		}else{
			requestNoStr=$('#reqlist').datagrid('getData').rows[rowIndex]["TReqNo"];
		 	QueryReqDetail(requestNoStr)
		}
	  }
	    
  });
  InitReqListPage();
}


//��ʼ��ҩƷ��ϸ�б�
function InitReqDetail(){
	//����columns
	var columns=[[
	    {field:'TSelect',title:'<a id="AllSelect" href="#" style="font-weight:bold;color:black" onclick="SetSelectAll()">ȫ��</a>',width:40,
	    	formatter:function(value,row,index){
				if (value=="Y"){
					return '<input type="checkbox" name="ReqDetailDataGridCheckbox" checked="checked" >';
				}
				else{
					return '<input type="checkbox" name="ReqDetailDataGridCheckbox" >';
				}
			}
	    },    
        {field:'TRegNo',title:'�ǼǺ�',width:80},    
        {field:'TBedNo',title:'����',width:80},
        {field:'TName',title:'����',width:80},
        {field:'TDesc',title:'����',width:250},
        {field:'TUom',title:'��λ',width:75},
        {field:'TRetQty',title:'������ҩ����',width:85,align:'right',
        	editor:{
				type:'numberbox',
				options:{
					precision:2
				}
			},
			formatter: function(value,row,index){
				return  '<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ value+'</span>';
			}
        },
        {field:'TQty',title:'��������',width:60},
        {field:'TReturnqty',title:'��������',width:60},
        {field:'TSurqty',title:'δ������',width:65},
        {field:'TReqDate',title:'��������',width:75},
        {field:'TReqTime',title:'����ʱ��',width:75},
        {field:'TStatus',title:'״̬',width:40},
        {field:'TRetReason',title:'��ҩԭ��',width:60},
        {field:'TOECPRCode',title:'ҽ�����ȼ�����',width:90},
        {field:'TEncryptLevel',title:'�����ܼ�',width:60},
        {field:'TPatLevel',title:'���˼���',width:60},
        {field:'Tpid',title:'Tpid',width:60,hidden:true},
        {field:'Tretrqrowid',title:'Tretrqrowid',width:60,hidden:true},
        {field:'TDEPTDR',title:'TDEPTDR',width:60,hidden:true},
        {field:'TDodis',title:'TDodis',width:60,hidden:true},
        {field:'TBEDDR',title:'TBEDDR',width:60,hidden:true},
        {field:'TADMDR',title:'TADMDR',width:60,hidden:true},
        {field:'TADMLOCDR',title:'TADMLOCDR',width:60,hidden:true},
        {field:'TRECLOCDR',title:'TRECLOCDR',width:60,hidden:true},
        {field:'TRetPartFlag',title:'TRetPartFlag',width:60,hidden:true}
        
   ]];  
	
   //����datagrid	
   $('#reqdetail').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  //rownumbers:true,
      columns:columns,
      pageSize:50,  // ÿҳ��ʾ�ļ�¼����
	  pageList:[50,100,300],   // ��������ÿҳ��¼�������б�
	  loadMsg: '���ڼ�����Ϣ...',
	  pagination:true,    
	  onLoadSuccess: function(){
		if (currEditRow!=undefined){
			$('#reqdetail').datagrid('endEdit', currEditRow);
			currEditRow = undefined
		}
		var data = $('#reqdetail').datagrid('getRows');
		if (data.length > 0){
		    var pid=$('#reqdetail').datagrid('getData').rows[0]["Tpid"];
	 		QueryReqTotal(pid);
		}
		else{
			$('#reqtotal').datagrid('options').queryParams.params = "";
			$('#reqtotal').datagrid('loadData',{total:0,rows:[]});			
		}
	  },
  	  onClickCell: function (rowIndex, field, value) {
	  	if (field=="TSelect"){
			var tmpcheckvalue=""
			if (value=="Y"){tmpcheckvalue="N"}
			else{tmpcheckvalue="Y"}
			$('#reqdetail').datagrid('updateRow',{
				index: rowIndex,
				row: {TSelect:tmpcheckvalue}
			})			
			return;
		}
		if (field!="TRetQty"){return;}
		var selectdata=$('#reqdetail').datagrid('getData').rows[rowIndex];
		var prioritycode=selectdata["TOECPRCode"];
		var dodis=selectdata["TDodis"];
		var retqty=selectdata["TRetQty"];
		var surqty=selectdata["TSurqty"];
		var retpartflag=selectdata["TRetPartFlag"];
		if (retpartflag=="0"){						
			$.messager.alert("��ʾ","�˼�¼�и����շ���Ŀ���������޸���ҩ����!","info")
			return ;	
		}
	  	if (rowIndex != currEditRow) {
        	if (endEditing(field)) {
				$("#reqdetail").datagrid('beginEdit', rowIndex);
				var editor = $('#reqdetail').datagrid('getEditor', {index:rowIndex,field:field});
	     	    editor.target.focus();
	     	    editor.target.select();
				$(editor.target).bind("blur",function(){
                	endEditing(field);        
            	});
				currEditRow=rowIndex;  
        	}
		}		
			  	  
  	  }  
   });
 }

var endEditing = function (field) {
    if (currEditRow == undefined) { return true }
    if ($('#reqdetail').datagrid('validateRow', currEditRow)) {
        var ed = $('#reqdetail').datagrid('getEditor', { index: currEditRow, field: field });
		var selecteddata = $('#reqdetail').datagrid('getRows')[currEditRow];
		var surqty=selecteddata["TSurqty"]; 
		var retqty=selecteddata["TRetqty"];
        var inputtxt=$(ed.target).numberbox('getValue');
	    if (inputtxt<0){
	    	$.messager.alert('������ʾ',"���ֲ���С��0!");
	    	return false;
	    }
	    if (inputtxt!=""){
		    var diffqty=parseFloat(inputtxt)-parseFloat(surqty);
		    diffqty=diffqty.toFixed(2)
		   	if (parseFloat(diffqty)>0){
		    	$.messager.alert('������ʾ',"��ҩ�������ܴ���δ������!");
		    	$('#reqdetail').datagrid('updateRow',{
					index: currEditRow,
					row: {TRetQty:retqty}
				});
				currEditRow=undefined;
		    	return false;
		    }
	    }else{
			$.messager.alert('������ʾ',"��ҩ����Ϊ��!");
			$('#reqdetail').datagrid('updateRow',{
				index: currEditRow,
				row: {TRetQty:retqty}
			});
			currEditRow=undefined;
	    	return false;
		}
		$('#reqdetail').datagrid('updateRow',{
			index: currEditRow,
			row: {TRetQty:inputtxt}
		});
        $('#reqdetail').datagrid('endEdit', currEditRow);
        currEditRow = undefined;
        return true;
    } else {
        return false;
    }
}
//��ʼ����Ʒ�����б�
function InitReqTotal(){
	//����columns
	var columnspat=[[
	    {field:'Tdesc',title:'ҩƷ����',width:250},    
        {field:'Tuom',title:'��λ',width:75},    
        {field:'Treqqty',title:'��������',width:80},
        {field:'Treturnedqty',title:'��������',width:80},
        {field:'TSurqty',title:'δ������',width:80},
        {field:'Tform',title:'����',width:100},
        {field:'Tmanf',title:'����',width:150},
        {field:'Tprice',title:'����',width:100,align:'right'},
        {field:'Tamount',title:'���',width:100,align:'right'}
    ]];  
   //����datagrid	
   $('#reqtotal').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  //rownumbers:true,
      columns:columnspat,
      pageSize:30,  // ÿҳ��ʾ�ļ�¼����
	  pageList:[30,50,100],   // ��������ÿҳ��¼�������б�
	  loadMsg: '���ڼ�����Ϣ...',
	  pagination:true    
	});
}
function SetPatInfo(RegNo)
{    
	if (RegNo=="") {
		return;
	}
	var patLen = hisPatNoLen;
	var plen=RegNo.length;
	if (plen>patLen){
		$.messager.alert('������ʾ',"�ǼǺ��������");
		return;
	}
	for (i=1;i<=patLen-plen;i++){
		RegNo="0"+RegNo;  
	}
	$("#patNo").val(RegNo);
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: commonInPhaUrl+'?action=GetPatInfoByNo&patNo='+RegNo,//�ύ������ �����ķ���  
		data: "",
		success:function(value){     
			if (value!=""){
				var painfoarr=value.split("^")	;
				if (painfoarr.length >0){
					$("#patName").val(painfoarr[0]);
				}
				QueryReqList();
			}   
		},    
		error:function(){        
			alert("��ȡ���˻�������ʧ��!");
		}
	});
}
 //��ѯ���뵥�б�
function QueryReqList(){
	var startDate=$("#startDate").datebox("getValue");
	var endDate=$("#endDate").datebox("getValue");
	if ((startDate=="")||(endDate=="")){
		$.messager.alert("��ʾ","���ڲ���Ϊ��!","info");
		return;
	}
	var phaLoc=$('#phaLoc').combobox("getValue");
	if ($.trim($('#phaLoc').combobox("getText"))=="") {
		phaLoc="";
		$.messager.alert("��ʾ","ҩ������Ϊ��!","info");
		return;
	}
	var wardLoc=$('#wardLoc').combobox("getValue");
	if ($.trim($('#wardLoc').combobox("getText"))=="") {
		wardLoc="";
	} 
	var patNo=$("#patNo").val();
	var patName=$("#patName").val();
	var docFlag=""
	if ($("#checkedDocFlag").is(':checked')){ 
		docFlag="1"
	}
	var params=startDate+"^"+endDate+"^"+phaLoc+"^"+wardLoc+"^"+patNo+
			   "^"+docFlag+"^"+RequestStatus;
	$('#reqlist').datagrid({
		url:commonInPhaUrl+'?action=QueryReqListForReturn',	
		queryParams:{
			params:params}
	});	
	InitReqListPage();
}
//��ѯ���뵥��ϸ
function QueryReqDetail(params){
	$('#reqdetail').datagrid({
		url:commonInPhaUrl+'?action=QueryReqDetail',	
		queryParams:{
			params:params}
	});	
}  
//��ѯ���뵥��Ʒ����
function QueryReqTotal(params){
	$('#reqtotal').datagrid({
		url:commonInPhaUrl+'?action=QueryReqTotal',	
		queryParams:{
			params:params}
	});	
}  
//�鿴ѡ������뵥��ϸ
function QuerySelectReqDetail(){
	var reqrowsdata=$('#reqlist').datagrid("getRows");
	var reqrows=reqrowsdata.length;
	if (reqrows<=0){
		$.messager.alert('��ʾ',"û������!","info");
		return;
	}
	var reqnostr=""
	for (var reqi=0;reqi<reqrows;reqi++){
		var selectdata=reqrowsdata[reqi];
		var select=selectdata["TSelect"];
		if (select=="Y"){
			var reqno=selectdata["TReqNo"]
			if (reqnostr==""){
				reqnostr=reqno
			}
			else{
				reqnostr=reqnostr+"^"+reqno
			}
		}		
	}
	if (reqnostr==""){
		$.messager.alert('��ʾ',"�빴ѡ��Ҫ��ҩ����ҩ����!","info");
		return;
	}
	requestNoStr=reqnostr
	QueryReqDetail(requestNoStr);	
}
function InitReqListPage(){
	var reqlistpager = $('#reqlist').datagrid('getPager'); 
	reqlistpager.pagination({  
		beforePageText:'',
		afterPageText:'/{pages}', 
  		displayMsg:''  
	}); 
}
function SetSelectAll()
{
	var detailrowsdata=$('#reqdetail').datagrid("getRows");
	var detailrows=detailrowsdata.length;
	if (detailrows<=0){
		return;
	}
	var tmpSelectFlag=""
	if($("#AllSelect").text()=="ȫѡ"){
		$("#AllSelect").text("ȫ��")
		tmpSelectFlag="Y"
	}else{
		$("#AllSelect").text("ȫѡ")
		tmpSelectFlag="N"
	}
	var columns = $('#reqdetail').datagrid("options").columns;
	var columnsstr=$('#reqdetail').datagrid('getColumnFields',false);
	var columni=columnsstr.indexOf("TSelect");
	$.each(detailrowsdata, function(index, item){
		detailrowsdata[index][columns[0][columni].field]=tmpSelectFlag;
		$('#reqdetail').datagrid('refreshRow', index);
	})
}
//ִ����ҩ
function btnReturnHandler(){
	var detailrowsdata=$('#reqdetail').datagrid("getRows");
	var detailrows=detailrowsdata.length;
	if (detailrows<=0){
		$.messager.alert('��ʾ',"û������!","info");
		return;
	}
	var quitFlag="";
	var returnstr=""
	$.each(detailrowsdata, function(index, item){
		if (item["TSelect"]=="Y"){
			var retqty=$.trim(item["TRetQty"]);
			var surqty=$.trim(item["TSurQty"]);
			var reqitmrowid=$.trim(item["Tretrqrowid"]); //�����ӱ�id
			if (retqty==""){
				$.messager.alert('��ʾ',"��"+(index+1)+"������Ϊ��!","info");
				quitFlag=1;
				return;
			}
			var tmpreturndata=reqitmrowid+"^"+retqty;
			if (returnstr==""){
		 		returnstr=tmpreturndata;	
		 	}else{
			 	returnstr=returnstr+","+tmpreturndata;
			}
		}
	})
	if (quitFlag==1){
		return;
	}
	if (returnstr==""){
		$.messager.alert('��ʾ',"�빴ѡ��Ҫ��ҩ������!","info");
		return;
	}
	var detaildata=detailrowsdata[0]
	var reclocdr=detaildata["TRECLOCDR"]
	if (reclocdr==""){
		$.messager.alert('��ʾ',"ҽ�����տ���Ϊ��!","info");
		return;
	}
	var excuteret=tkMakeServerCall("web.DHCSTPHARETURN","ExecReturnByReq","","",reclocdr,gUserId,"RT",returnstr)
	var retarr=excuteret.split(",");
	var retNo=""
	if(retarr[0]=="failure")
	{
		if (retarr[1]==-3){  
	 		$.messager.alert("��ʾ","��������ҩ:��ҩ����������ҩ����,��δ��ҩ","info") ;	
		}else if (retarr[1]==-2){  
			$.messager.alert("��ʾ","���������¼�Ѿ���ҩ��ܾ���ҩ!","info") ; 		
		}else if (retarr[1]==-4){
			$.messager.alert("��ʾ","���������ս���,��������ҩ,����ϵ���㴦","info");
		}else if (retarr[1]==-5){  
			$.messager.alert("��ʾ","������ҩ��ϸʧ��","info");
		}else if ((retarr[1]==-6)){ 	
			$.messager.alert("��ʾ","�������뵥״̬ʧ��","info") ;	
		}else if ((retarr[1]==-7)){ 
			$.messager.alert("��ʾ","�����ҩ��ʧ��","info");	
		}else if ((retarr[1]==-10)){ 
			$.messager.alert("��ʾ","�и����շ���Ŀִ�м�¼����������ҩ",info);	
		}else if ((retarr[1]==-11)){ 
			$.messager.alert("��ʾ","��������ҩ:�Ѿ���;����,������ҩ!") ;	
		}else if (retarr[1]!=0){
			 $.messager.alert("��ʾ","��ҩʧ��:"+retarr,"info") ;	
		}		
		return;
	}else{ 
		retNo=retarr[1];
		QueryReqDetail(requestNoStr)
		$.messager.confirm('��ʾ', '��ҩ�ɹ�!�Ƿ��ӡ?', function(r) {
	    	if(r==true){
		    	PrintReturnCom(retNo,"")
		    }else{
				return;
			}
		});
	}					  
	
}