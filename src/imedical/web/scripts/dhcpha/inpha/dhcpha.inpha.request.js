/*
ģ��:סԺҩ��
��ģ��:סԺҩ��-��ҩ����
createdate:2016-06-07
creator:yunhaibao
*/
var commonInPhaUrl = "DHCST.INPHA.ACTION.csp";
var commonOutPhaUrl="DHCST.OUTPHA.ACTION.csp";
var thisUrl="dhcpha.inpha.request.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var currEditRow=undefined; //�����б༭
$(function(){
	InitPhaLoc();
    InitAdmList()
	InitReqDetail();
   	$('#patNo').bind('keypress',function(event){
        if(event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			if (isNaN(patno)==true){
				$.messager.alert("��ʾ","�ǼǺ���ҪΪ����!","info");
				$("#patInfo").text("");
				return;
			}
			$("#patInfo").text("")
			if (patno!=""){
				SetPatInfo(patno);
			}
        }
    });	
    $('#btnFind').bind('click',function(){
		btnFindHandler();
    });
    $('#btnFindRequest').bind('click',function(){
		var lnk="dhcpha.seekpharetrequest.csp";
   		window.open(lnk,"_target","height=600,width=900,menubar=no,status=yes,toolbar=no,resizable=yes") ;
    });
    $('#btnSave').bind('click',function(){
		btnSaveHandler();
    });
    $('#btnClear').bind('click',function(){
		btnClearHandler();
    });
    $('#btnSetDefault').bind('click',function(){
		btnSetDefaultHandler();
    })
    InitTitle();
})
function InitTitle(){
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: commonOutPhaUrl+'?action=GetPminoLen',//�ύ������ �����ķ���  
		data: "",
		success:function(value){     
			if (value!=""){
				hisPatNoLen=value;
				var regNo=tkMakeServerCall("web.DHCSTKUTIL","GetRegNobyEpisodeID",EpisodeID);
				SetPatInfo(regNo);
			}   
		},    
		error:function(){        
			alert("��ȡ�ǼǺų���ʧ��!");
		}
	});
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
	            SetDefaultLoc(); 
            }            
	    }
	});
}
function SetDefaultLoc(){
	var defaultloc=tkMakeServerCall("web.DHCSTKUTIL","GetDefaultPhaLoc",gGroupId)
	$('#phaLoc').combobox('select', defaultloc.split("^")[0]);
}
//��ʼ������
function InitAdmList(){
	//����columns
	var columns=[[
		{field:'Adm',title:'adm',width:60,hidden:true},
		{field:'CurrWard',title:'����',width:150},
		{field:'AdmDate',title:'��������',width:80},
		{field:'AdmTime',title:'����ʱ��',width:80},
		{field:'AdmLoc',title:'�������',width:150},
		{field:'CurrentBed',title:'����',width:100}
	]]; 
	
   //����datagrid	
   $('#admlist').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  selectOnCheck: true, 
	  checkOnSelect: false,
	  rownumbers:false,
      columns:columns,   
      pageSize:999,  // ÿҳ��ʾ�ļ�¼����
	  loadMsg: '���ڼ�����Ϣ...',
	  onSelect:function(rowIndex,rowData){
		   currEditRow=undefined
		   QueryDetail();
	  },
	  onLoadSuccess: function(){
         	//ѡ�е�һ
         	if ($('#admlist').datagrid("getRows").length>0){
	         	$('#admlist').datagrid("selectRow", 0)
         	}
         	else{
	        	$('#reqdetail').datagrid('loadData',{total:0,rows:[]}); 
				$('#reqdetail').datagrid('options').queryParams.params = ""; 
	        }
	  }  	     
  });
}

function InitReturnReason(){
	 retReasonEditor={  //������Ϊ�ɱ༭
		type: 'combobox', //���ñ༭��ʽ
		options: {
			panelHeight:"auto",
			valueField: "value",  
			textField: "text",
			url:commonInPhaUrl+'?action=GetInRetReason&Type=gridcombobox',
			onSelect:function(option){
				var ed=$("#reqdetail").datagrid('getEditor',{index:currEditRow,field:'TReasonDR'});
				$(ed.target).val(option.value);  //����ID
				var ed=$("#reqdetail").datagrid('getEditor',{index:currEditRow,field:'TReason'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
			}
		}
	}
}

//��ʼ��ҩƷ��ϸ�б�
function InitReqDetail(){
	InitReturnReason();
	//����columns
	var columns=[[
	    {field:'TSelect',title:'<a id="AllSelect" href="#" style="font-weight:bold;color:black" onclick="SetSelectAll()">ȫѡ</a>',width:40,
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
        {field:'TName',title:'����',width:80},
        {field:'TPrescNo',title:'������',width:100},
        {field:'TDesc',title:'ҩƷ����',width:200},
        {field:'TDispQty',title:'��ҩ����',width:75,align:'right'},
        {field:'TReqQty',title:'��������',width:75,align:'right',
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
        {field:'TReason',title:'��ҩԭ��',width:100,editor:retReasonEditor},
        {field:'TReasonDR',title:'TReasonDR',width:100,editor:{type:'text'},hidden:true},
        {field:'TUom',title:'��λ',width:75},
        {field:'TStatus',title:'ҽ��״̬',width:60,align:'center'},
        {field:'Toedis',title:'Toedis',width:75,hidden:true},
        {field:'Tdspid',title:'Tdspid',width:75,hidden:true},
        {field:'TUserDept',title:'��������',width:125},
        {field:'Treqflag',title:'���뵥״̬',width:150},
        {field:'Titmcode',title:'ҩƷ����',width:80,hidden:true},
        {field:'TEncryptLevel',title:'�����ܼ�',width:80},
        {field:'TPatLevel',title:'���˵ȼ�',width:80},
        {field:'TRecLocDr',title:'TRecLocDr',width:80,hidden:true},
        {field:'TWardLocDr',title:'TWardLocDr',width:80,hidden:true}
   ]];  
	
   //����datagrid	
   $('#reqdetail').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  //rownumbers:true,
	  checkOnSelect:false,
	  selectOnCheck:false,
      columns:columns,
      pageSize:999,  // ÿҳ��ʾ�ļ�¼����
	  loadMsg: '���ڼ�����Ϣ...',
	  //pagination:true,    
	  onLoadSuccess: function(){
		if (currEditRow!=undefined){
			$('#reqdetail').datagrid('endEdit', currEditRow);
			currEditRow = undefined
		}
	  },
  	  onClickCell: function (rowIndex, field, value) {
	  	if (field=="TSelect"){
			if (currEditRow!=undefined){
				$('#reqdetail').datagrid('endEdit', currEditRow);
				currEditRow=undefined;
			}
			var tmpcheckvalue=""
			if (value=="Y"){tmpcheckvalue="N"}
			else{tmpcheckvalue="Y"}
			$('#reqdetail').datagrid('updateRow',{
				index: rowIndex,
				row: {TSelect:tmpcheckvalue}
			})			
			return;	  
		}
		if ((field!="TReqQty")&&(field!="TReason")){return;}
		if (currEditRow!=undefined){
			$('#reqdetail').datagrid('endEdit', currEditRow);
		}
	  	if (rowIndex != currEditRow) {
			$("#reqdetail").datagrid('beginEdit', rowIndex);
			var editor = $('#reqdetail').datagrid('getEditor', {index:rowIndex,field:field});
     	    editor.target.focus();
     	    editor.target.select();
			$(editor.target).bind("blur",function(){
				CheckInputInfo();   
			})
			currEditRow=rowIndex;  
		}	  	  
  	  }  
   });
}
function CheckInputInfo(){
	if (currEditRow==undefined){return;}
    if ($('#reqdetail').datagrid('validateRow', currEditRow)) {
	    var ed = $('#reqdetail').datagrid('getEditor', { index: currEditRow, field: "TReqQty" });
	    var selecteddata = $('#reqdetail').datagrid('getRows')[currEditRow];
	    var dispid=selecteddata["Tdspid"];
	    var inputtxt = $(ed.target).numberbox('getValue');
	    var warnflag=""
	    if ((inputtxt<0)&&(warnflag=="")){
	    	$.messager.alert('������ʾ',"���ֲ���С��0!","warning");
	    	warnflag=1;
	    }
	    if ((CheckReqQty(dispid,inputtxt)==false)&&(warnflag=="")){
		    $.messager.alert("��ʾ","�����������ܴ��ڷ�ҩ����!","warning") 
		    warnflag=1;
		}
		if ((CheckRetParted(dispid,inputtxt)==false)&&(warnflag=="")){
		    $.messager.alert("��ʾ","�˼�¼�и����շ���Ŀ�����ܲ�����ҩ!","warning") 
		    warnflag=1;
		}
		
    }
}
function CheckReqQty(dispid,reqqty){
	var checkret=tkMakeServerCall("web.DHCSTPHARETURN","AllowReturnByDodis","","",dispid,reqqty)
	if (checkret==0){
		return false;
	}else{
		return true;
	}	
}
//�ж��Ƿ��и�����Ŀ
function CheckRetParted(dispid,reqqty){
  	var checkpartret=tkMakeServerCall("web.DHCSTPHARETURN2","GetRetParted",dispid,parseFloat(reqqty));
	if (checkpartret=="0"){
		return false;	
	}
	return true;
}
//��ΪĬ�Ͽ���
function btnSetDefaultHandler(){
	var phaLoc=$("#phaLoc").combobox("getValue");
	var phaLocDesc=$.trim($("#phaLoc").combobox("getText"))
	if (phaLocDesc==""){
		phaLoc="";
	}
	if (phaLoc==""){
		$.messager.alert("��ʾ","����ѡ��ҩ����!","info") ;	
		return;
	}
	$.messager.confirm('��ʾ', "ȷ�Ͻ� " + phaLocDesc +" ���ó�Ĭ�Ͽ�����?", function(r) {
		if(r==true){
	    	var ret=tkMakeServerCall("web.DHCSTRETREQUEST","SetDefaultPhaLoc",phaLoc,gGroupId)
	    	if (ret==0){
		    	$.messager.alert("��ʾ","���óɹ�!") ;
		    }
	    }else{
			return;
		}
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
			if ($.trim(value)!=""){
				var painfoarr=value.split("^")	;
				if (painfoarr.length >0){
					$("#patName").val(painfoarr[0]);
					$("#patSex").val(painfoarr[1]);
					$("#patAge").val(painfoarr[2]+"("+painfoarr[3]+")")
				}
				btnFindHandler();
			} else{
				$.messager.alert("��ʾ","�����ڸò���!","info");
				$("#patName").val("");
				$("#patSex").val("");
				$("#patAge").val("");
				$('#admlist').datagrid('loadData',{total:0,rows:[]});
				$('#admlist').datagrid('options').queryParams.params = "";  
				$('#reqdetail').datagrid('loadData',{total:0,rows:[]});
				$('#reqdetail').datagrid('options').queryParams.params = ""; 
			}  
		},    
		error:function(){        
			alert("��ȡ���˻�������ʧ��!");
		}
	});
}
//��ѯ��ϸ
function QueryDetail(){
	var selecteddata = $('#admlist').datagrid('getSelected');
	if(selecteddata==null){
		$.messager.alert('��ʾ',"��ѡ�о����¼��","info");
		return;
	}
	var phaLoc=$("#phaLoc").combobox("getValue");
	var phaLocDesc=$.trim($("#phaLoc").combobox("getText"))
	if (phaLocDesc==""){
		phaLoc="";
	}
	var patNo=$.trim($("#patNo").val());
	var adm=selecteddata["Adm"];
	var params=patNo+"^"+adm+"^"+phaLoc+"^"+gLocId;
	$('#reqdetail').datagrid({
		url:thisUrl+'?action=QueryNeedReqList',	
		queryParams:{
			params:params}
	});
}
//��ѯ�����б�
function btnFindHandler(){
	var patNo=$("#patNo").val();
	var params=patNo
	$('#admlist').datagrid({
		url:commonInPhaUrl+'?action=QueryDispAdmList',	
		queryParams:{
			params:params}
	});
}
//���
function btnClearHandler(){
	SetDefaultLoc();
	$("#patName").val("");
	$("#patNo").val("");
	$("#patSex").val("");
	$("#patAge").val("");
	$('#admlist').datagrid('loadData',{total:0,rows:[]});
	$('#admlist').datagrid('options').queryParams.params = "";  
	$('#reqdetail').datagrid('loadData',{total:0,rows:[]});
	$('#reqdetail').datagrid('options').queryParams.params = "";  
}
 //��������
function btnSaveHandler(){
	var detailrowsdata=$('#reqdetail').datagrid("getRows");
	var detailrows=detailrowsdata.length;
	if (detailrows<=0){
		$.messager.alert('��ʾ',"û������!","info");
		return;
	}
	$("#reqdetail").datagrid("acceptChanges");
	if (currEditRow!=undefined){
		$('#reqdetail').datagrid('endEdit', currEditRow);
	}	
	var requeststr="";
	var reclocdr="";
	var reqlocdr="";
	var quitFlag="";
	$.each(detailrowsdata, function(index, item){
		if (item["TSelect"]=="Y"){
			var reqqty=$.trim(item["TReqQty"]);
			var dspid=item["Tdspid"];
			var reasondesc=$.trim(item["TReason"]);
			var reason=item["TReasonDR"];
		    reclocdr=item["TRecLocDr"];
			reqlocdr=item["TWardLocDr"];
			var exist=tkMakeServerCall("web.DHCSTRETREQUEST","CheckReqExist",dspid)
			if(exist!=""){
				alert("��"+(index+1)+"����ҩ�����Ѿ�����!");
				$("#reqdetail").datagrid('selectRow',index);
				quitFlag=1;
				return false;
			}
			if (reasondesc==""){
				reason="";
			}
			if ((reason=="")||(reason==null)){
				alert("��"+(index+1)+"����ҩԭ��Ϊ��!");
				$("#reqdetail").datagrid('selectRow',index);
				quitFlag=1;
				return false;
			}
			if (reqqty<0){
				alert("��"+(index+1)+"����ҩ������������С��0!");
				$("#reqdetail").datagrid('selectRow',index);
				return false;
		    }
		    if (reqqty==""){
				alert("��"+(index+1)+"����ҩ��������������Ϊ��!");
				$("#reqdetail").datagrid('selectRow',index);
				quitFlag=1;
				return false;   
			}
		    if (CheckReqQty(dspid,reqqty)==false){
			    alert("��"+(index+1)+"�������������ܴ��ڷ�ҩ����!") ;
			    $("#reqdetail").datagrid('selectRow',index);
			    quitFlag=1;
			    return false;
			}
			if (CheckRetParted(dspid,reqqty)==false){
			    alert("��"+(index+1)+"���и����շ���Ŀ�����ܲ�����ҩ!") ;
			    $("#reqdetail").datagrid('selectRow',index);
			    quitFlag=1;
			    return false;
			}
			if(requeststr==""){
				requeststr=dspid+"^"+reqqty+"^"+reason;
			}else{
				requeststr=requeststr+","+dspid+"^"+reqqty+"^"+reason;
			}
		} 	 
	});
	if(quitFlag==1){
		return;
	}
	if (requeststr==""){
		$.messager.alert('��ʾ',"û����Ҫ���������!","info");
		return;	
	}
	/*
	if(reclocdr==""){
		$.messager.alert('��ʾ',"�޷���ȡ��¼�з�ҩ����!","info");
		return;	
	}*/
	if(reqlocdr==""){
		$.messager.alert('��ʾ',"�޷���ȡ��¼�в���!","info");
		return;	
	}
	var saveret=tkMakeServerCall("web.DHCSTRETREQUEST","InsDetail2",gUserId,reqlocdr,requeststr)
	var savearr=saveret.split("^");
	if (savearr[0]=="success"){
		$.messager.alert('��ʾ',"����ɹ�!���뵥��:"+savearr[1]);
		$("#reqdetail").datagrid("reload");
	}else{
		$.messager.alert('��ʾ',"����ʧ��,�������:"+savearr[1],"error");
	}
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
