/*
ģ��:סԺҩ��
��ģ��:סԺҩ��-ֱ����ҩ
createdate:2016-05-30
creator:yunhaibao
*/
var commonInPhaUrl = "DHCST.INPHA.ACTION.csp";
var commonOutPhaUrl="DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var currEditRow=undefined; //�����б༭
var loadedFlag="";
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitTitle();
	var retReasonCombo=new ListCombobox("retReason",commonInPhaUrl+'?action=GetInRetReason','',combooption);
	retReasonCombo.init(); //��ʼ����ҩ��		
	InitPhaLoc();
    InitNeedRetList();
   	$('#patNo').bind('keypress',function(event){
        if(event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			$("#patInfo").text("")
			if (patno!=""){
				SetPatInfo(patno);
			}
        }
    });
    $('#btnReturnByReq').bind('click',function(){
		var lnk="dhcpha.inpha.returnbyreq.csp";
   		window.open(lnk,"_target","height=600,width=900,menubar=no,status=yes,toolbar=no,resizable=yes") ;
    });
    $('#btnReturnQuery').bind('click',function(){
		var lnk="dhcpha.phareturnquery.csp";
   		window.open(lnk,"_target","height=600,width=900,menubar=no,status=yes,toolbar=no,resizable=yes") ;
    });
    $('#btnFind').bind('click',function(){
		btnFindHandler();
    });
	$('#btnClear').bind('click',btnClearHandler);
    $('#btnReturn').bind('click',function(){
		btnReturnHandler();
    });
    $('#patNo').focus();
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
		}           
	});
}

//��ʼ��ҩƷ��ϸ�б�
function InitNeedRetList(){
	//����columns
	var columns=[[ 
	   	{field:'TWard',title:'����',width:150},  
    	{field:'TPaNo',title:'�ǼǺ�',width:80},  
    	{field:'TPaName',title:'��������',width:80}, 
    	{field:'TBedNo',title:'����',width:80}, 
    	{field:'TDesc',title:'ҩƷ����',width:200}, 
    	{field:'TUom',title:'��λ',width:80},
    	{field:'TReturnPrice',title:'����',width:80,align:'right'},
    	{field:'TDispQty',title:'��ҩ����',width:80,align:'right'},
    	{field:'TReturnQty',title:'��ҩ����',width:80,align:'right',
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
    	{field:'TReturnAmt',title:'��ҩ���',width:80,align:'right'},
    	{field:'TBatchNo',title:'����',width:80},	
    	{field:'TPrescNo',title:'������',width:100},	
    	{field:'TEncryptLevel',title:'�����ܼ�',width:100},
    	{field:'TPatLevel',title:'���˼���',width:100},
    	{field:'TADMDR',title:'TADMDR',width:80,hidden:true},
    	{field:'TDspid',title:'TDspid',width:80,hidden:true},
    	{field:'TINCLBDR',title:'TINCLBDR',width:80,hidden:true},
    	{field:'TRETRQDR',title:'TRETRQDR',width:80,hidden:true},
        {field:'TOEDISDR',title:'TOEDISDR',width:80,hidden:true},
        {field:'TRECLOCDR',title:'TRECLOCDR',width:80,hidden:true},
        {field:'TDEPTDR',title:'TDEPTDR',width:80,hidden:true},
        {field:'TBEDDR',title:'TBEDDR',width:80,hidden:true}
            	   
   	]];  
	
   //����datagrid	
   $('#needretlist').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  //rownumbers:true,
      columns:columns,
      pageSize:30,  // ÿҳ��ʾ�ļ�¼����
	  pageList:[30,50,100],   // ��������ÿҳ��¼�������б�
	  loadMsg: '���ڼ�����Ϣ...',
	  onLoadSuccess: function(){
		if (currEditRow!=undefined){
			$('#needretlist').datagrid('endEdit', currEditRow);
			currEditRow = undefined
		}
		
		var rowsdata = $('#needretlist').datagrid('getRows');
		if (rowsdata.length > 0){
			loadedFlag="";
			return
		}
		else{
			if (loadedFlag!=""){
				$('#needretlist').datagrid('options').queryParams.params = "";
				$('#needretlist').datagrid('loadData',{total:0,rows:[]});
				loadedFlag="1";
			}			
		}
	  },
	  onClickCell: function (rowIndex, field, value) {
		if (field!="TReturnQty"){return;}
		var selectdata=$('#needretlist').datagrid('getData').rows[rowIndex];
		if (rowIndex != currEditRow) {
			if (endEditing(field)) {
				$("#needretlist").datagrid('beginEdit', rowIndex);
				var editor = $('#needretlist').datagrid('getEditor', {index:rowIndex,field:field});
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
    if ($('#needretlist').datagrid('validateRow', currEditRow)) {
        var ed = $('#needretlist').datagrid('getEditor', { index: currEditRow, field: field });
		var selecteddata = $('#needretlist').datagrid('getRows')[currEditRow];
		var dispqty=selecteddata["TDispQty"]; 
		var retqty=selecteddata["TReturnQty"]; 
		var dispId=selecteddata["TDspid"];
        var inputtxt=$(ed.target).numberbox('getValue');
        var canreturn=1;
	    if (inputtxt<0){
	    	$.messager.alert('��ʾ',"���ֲ���С��0!");
	    	return false;
	    }
	    if ($.trim(inputtxt)!=""){
		  	var allowret=tkMakeServerCall("web.DHCSTPHARETURN","AllowReturnByDodis","","",dispId,parseFloat(inputtxt));
		  	if (allowret=="0"){
			  	if (canreturn!=0){
		  			$.messager.alert('��ʾ',"��ҩ�������ܴ��ڷ�ҩ����!");
			  	}
				canreturn=0;
		  	}
		  	var checkpartret=tkMakeServerCall("web.DHCSTPHARETURN2","GetRetParted",dispId,parseFloat(inputtxt));
			if ((checkpartret=="0")&&(canreturn!=0)){
				$.messager.alert('��ʾ',"�˼�¼�и����շ���Ŀ�����ܲ�����ҩ!");
				canreturn=0;	
			}
			if (canreturn==0){
	  			$('#needretlist').datagrid('updateRow',{
					index: currEditRow,
					row: {TReturnQty:retqty}
				});
				currEditRow=undefined;
		  		return false;		
			}
	    }
		$('#needretlist').datagrid('updateRow',{
			index: currEditRow,
			row: {TReturnQty:inputtxt}
		});
        $('#needretlist').datagrid('endEdit', currEditRow);
        currEditRow = undefined;
        return true;
    } else {
        return false;
    }
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
			if ($.trim(value)!=""){
				var painfoarr=value.split("^")	;
				if (painfoarr.length >0){
					$("#patName").val(painfoarr[0]);
					$("#patSex").val(painfoarr[1]);
					$("#patAge").val(painfoarr[2]+"("+painfoarr[3]+")")
				}
				btnFindHandler();
			} else{
				alert("�����ڸò��ˣ�");
				$('#patNo').focus();
				return;			
			}  
		},    
		error:function(){        
			alert("��ȡ���˻�������ʧ��!");
		}
	});
}
//��ѯ����ҩ�б�
function btnFindHandler(){
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
	var patNo=$.trim($("#patNo").val());
	if (patNo==""){
		$.messager.alert("��ʾ","�����벡�˵ǼǺ�!","info");
		return;
	}
	var params=startDate+"^"+endDate+"^"+patNo+"^"+phaLoc;
	$('#needretlist').datagrid({
		url:commonInPhaUrl+'?action=QueryNeedReturn',	
		queryParams:{
			params:params}
	});
	
}
//���
function btnClearHandler(){
	$("#startDate").datebox("setValue", formatDate(0));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));  //Init�������� 
	$("#patNo").val("");	
	$("#patName").val("");	
	$("#patSex").val("");	
	$("#patAge").val("");
	$("#retReason").combobox("setValue","");
	$('#needretlist').datagrid('options').queryParams.params = "";  
	$('#needretlist').datagrid('loadData',{total:0,rows:[]});	
}
//��ҩ
function btnReturnHandler(){
	var detailrowsdata=$('#needretlist').datagrid("getRows");
	var detailrows=detailrowsdata.length;
	if (detailrows<=0){
		$.messager.alert('��ʾ',"û������!","info");
		return;
	}
	var retreason=$("#retReason").combobox("getValue");
	if ($.trim($("#retReason").combobox("getText"))==""){
		retreason=""
		$.messager.alert('��ʾ',"��ѡ����ҩԭ��!","info");
		return;
	}
	var reclocdr="";
	var returnstr=""
	$.each(detailrowsdata, function(index, item){
		var retqty=$.trim(item["TReturnQty"]);
		var dispId=item["TDspid"]; 
		var tmpreturndata=dispId+"^"+retqty+"^"+retreason;
		reclocdr=item["TRECLOCDR"];
		if((retqty!="")&&(retqty!=0)){
			if (returnstr==""){
		 		returnstr=tmpreturndata;	
		 	}else{
			 	returnstr=returnstr+","+tmpreturndata;
			}
		}
	})
	if (returnstr==""){
		$.messager.alert('��ʾ',"��������Ҫ��ҩ��¼����ҩ����!","info");
		return;	
	}
	var execret=tkMakeServerCall("web.DHCSTPHARETURN","ExecReturn",reclocdr,gUserId,"RT",returnstr)
	var execretarr=execret.split("^");
	if(execretarr[0]=="success"){
	    var RetNo=execretarr[1];
	}else{
		if (execretarr[1]==-3){  
			$.messager.alert('��ʾ',"����ҩƷ��ҩ���� >  (��ҩ���� - ����ҩ����),��ˢ�º��ʵ!","info") ;
		}else if(execretarr[1]==-12){
			$.messager.alert('��ʾ',"����ִ�м�¼״̬����ִֹͣ�л���ִ�е�ҩƷ����������ҩ!","info") ;			 
		}else if(execretarr[1]==-9){
			$.messager.alert('��ʾ',"����δ�����뵥����������ʹ��ֱ����ҩ!","info") 	;		 
		}else if(execretarr[1]==-4){
			$.messager.alert('��ʾ',"�û������������ս��㣬��������ҩ!","info") ;	 
		}else if(execretarr[1]==-11){
			$.messager.alert('��ʾ',"��������ҩ:�Ѿ���;����,������ҩ!","info") ;	 
		}else{ 
			$.messager.alert('����',"��ҩʧ��,�������:"+execretarr[1],"warning");
		}
		return ;
	}
	btnFindHandler();	
	$.messager.confirm('��ʾ', '��ҩ�ɹ�!�Ƿ��ӡ?', function(r) {
    	if(r==true){
	    	PrintReturnCom(RetNo,"")
	    }else{
			return;
		}
	});
			  
}
