// Creator: congyue
/// CreateDate: 2016-01-08
//  Descript: ������Ӧ��ѯ
var url = "dhcadv.repaction.csp";
var statShare = [{ "val": "δ����", "text": "δ����" },{ "val": "����", "text": "����" }];
var statArray = [{ "val": "Y", "text": "���ύ" },{ "val": "N", "text": "δ�ύ" }];
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/dhcadvExpPri.js"></script>');
var StDate=formatDate(-7);  //һ��ǰ������
var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(function(){
	$("#stdate").datebox("setValue", StDate);  //Init��ʼ����
	$("#enddate").datebox("setValue", EndDate);  //Init��������
	
	/* ���� */
	//var DeptCombobox = new ListCombobox("dept",url+'?action=SelAllLoc','',{});
	//DeptCombobox.init();
	//����  2017-08-01 cy �޸� �����򴫵ݲ�������
	$('#dept').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		mode:'remote',  //���������������
		url:url+'?action=SelAllLoc',
		onLoadSuccess:function(){  
		    var data =  $('#dept').combobox('getData'); 
		    $('#dept').combobox({disabled:true}); 
		    $("#dept").combobox('setValue',LgCtLocID);
		}   
	});
	//$('#dept').combobox({disabled:true});
	//$("#dept").combobox('setValue',LgCtLocID);
	/* ״̬ */
	var StatusCombobox = new ListCombobox("status",'',statArray,{panelHeight:"auto"});
	StatusCombobox.init();

	/* �������� */
	var TypeeventCombobox = new ListCombobox("typeevent",url+'?action=selEvent','',{});
	TypeeventCombobox.init();
	
	/* ����״̬ */  
	var ShareCombobox = new ListCombobox("Share",'',statShare,{panelHeight:"auto"});
	ShareCombobox.init();
	
	$('#Find').bind("click",Query);  //�����ѯ 
	$('#SHare').bind("click",Share);  //�������
	$('#Delete').bind("click",Delete);  //���ɾ��
	$('a:contains("����")').bind("click",Export); 	  //����
	$('a:contains("��ӡ")').bind("click",Print);     //��ӡ

	InitPatList(); //��ʼ�������б�
	
	//�ǼǺŻس��¼�
	$('#patno').bind('keypress',function(event){
	 if(event.keyCode == "13"){
		 var patno=$.trim($("#patno").val());
		 if (patno!=""){
			GetWholePatID(patno);
			Query();
		 }	
	 }
	});
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
})

//����
function Share(){
var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.each(selItems, function(index, item){
		var ID=item.ID;         //����ID
		var TypeCode=item.TypeCode;         //�������ʹ���
		var RepShareFlag=item.RepShareFlag;//����״̬
/* 		 if(RepShareFlag=="����"){
			$.messager.alert("��ʾ:","�Ѿ�������");
			return;
		} */
		
				var status=item.status //��ǰ״̬id
				var params=ID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+TypeCode+"^"+status+"^"+RepShareFlag   //������
		
				//��������
				$.post(url+'?action=InsRepShare',{"params":params},function(jsonString){
					 if(jsonString==-1){
					  $.messager.alert("��ʾ:","�Ѿ�������");
			   
				   }
			/* 		var resobj = jQuery.parseJSON(jsonString);
					if(resobj.ErrCode < 0){
						$.messager.alert("��ʾ:","<font style='font-size:20px;'>���մ���,����ԭ��:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
					} */
			
		});
	})
	$('#maindg').datagrid('reload'); //���¼���
	
	
}
//��ѯ
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	var status=$('#status').combobox('getValue');  //״̬
	var typeevent=$('#typeevent').combobox('getValue');  //��������
	var statShare=$('#Share').combobox('getValue');  //����״̬ 
	if (status==undefined){status="";} 
	if (typeevent==undefined){typeevent="";}
	if (statShare==undefined){statShare="";}
	var PatNo=$.trim($("#patno").val());
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+statShare;
	//alert(params);
	$('#maindg').datagrid({
		url:url+'?action=GetMataReport',	
		queryParams:{
			params:params}
	});
}

//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
	    {field:'consultID',title:'consultID',width:80,hidden:true},
		{field:"ck",checkbox:true,width:20},
		{field:'LkDetial',title:'����',width:100,align:'center',formatter:SetCellOpUrl},
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:'RepShareFlag',title:'����״̬',width:100,align:'center'},
		{field:'Edit',title:'�޸�',width:80,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:"status",title:'����״̬',width:90,hidden:false},
		{field:'Medadrreceive',title:'����״̬',width:100,hidden:true},
		{field:'Medadrreceivedr',title:'����״̬dr',width:80,hidden:true},
		{field:'CreateDate',title:'��������',width:100},
		{field:'RepNo',title:'������',width:160},
		{field:'PatNo',title:'�ǼǺ�',width:120},
		{field:'PatName',title:'����',width:120},
		{field:'LocDesc',title:'�������',width:220},
		{field:'Typeevent',title:'��������',width:220},
		{field:'Creator',title:'������',width:120},
		{field:'TypeCode',title:'�������ʹ���',width:120},
		{field:'Assess',title:'����id',width:120,hidden:true},
		{field:'StaFistAuditUser',title:'��������',width:120,hidden:true},
		{field:'BackAuditUser',title:'���ز�����',width:120,hidden:true}
	]];
	
	//����datagrid
	$('#maindg').datagrid({
		title:'�����б�',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		rowStyler:function(index,row){  
	        /* if (row.status.indexOf("����")>=0){  
	            return 'background-color:red;';  
	        } */
	        if ((row.StaFistAuditUser==LgUserName)||(row.BackAuditUser==LgUserName)){  
	            return 'background-color:red;';  
	        }  
    	}
	});
	
	initScroll("#maindg");//��ʼ����ʾ���������
}
//ɾ��
function Delete()
{
	var selItems = $('#maindg').datagrid('getSelections');
	var delflag=0;
	if (selItems.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.each(selItems, function(index, item){
					var ID=item.ID;         //����ID
					var TypeCode=item.TypeCode; //�������ʹ���
					var delparams=ID+"^"+LgUserID;
					if(TypeCode=="material"){
						$.ajax({
							type: "POST",// ����ʽ
					    	url: url,
					    	data: "action=DelMataReport&params="+delparams,
							async: false, //ͬ��
							success: function(data){
								if(data!=0){
									delflag=data;
								}
							}
						});
					}
					if(TypeCode=="drugerr"){
						$.ajax({
							type: "POST",// ����ʽ
					    	url: url,
					    	data: "action=DelMedsReport&params="+delparams,
							async: false, //ͬ��
							success: function(data){
								if(data!=0){
									delflag=data;
								}
							}
						});
					}
					if(TypeCode=="blood"){
						$.ajax({
							type: "POST",// ����ʽ
					    	url: url,
					    	data: "action=DelBldrptReport&params="+delparams,
							async: false, //ͬ��
							success: function(data){
								if(data!=0){
									delflag=data;
								}
							}
						});
					}
					if(TypeCode=="med"||TypeCode=="bldevent"){
						$.ajax({
							type: "POST",// ����ʽ
					    	url: url,
					    	data: "action=DelMedReport&params="+delparams,
							async: false, //ͬ��
							success: function(data){
								if(data!=0){
									delflag=data;
								}
							}
						});
					}
					if(TypeCode=="drug"){
						$.ajax({
							type: "POST",// ����ʽ
					    	url: url,
					    	data: "action=DelMadrReport&params="+delparams,
							async: false, //ͬ��
							success: function(data){
								if(data!=0){
									delflag=data;
								}
							}
						});
					}
				});	
			}
                        else    //wangxuejian 2016-09-28
			{
				
				delflag=1
			}
			if(delflag==0){
				$.messager.alert('��ʾ','ɾ���ɹ�');
				$('#maindg').datagrid('reload'); //���¼���
			}else if(delflag==-1){
				$.messager.alert('��ʾ','�Ǳ��˲�����ɾ��ʧ��','warning');
				$('#maindg').datagrid('reload'); //���¼���
			}else if(delflag==-2){
				$.messager.alert('��ʾ','�������ύ������ɾ��','warning');
				$('#maindg').datagrid('reload'); //���¼���
			}else if(delflag==-10){
				$.messager.alert('��ʾ','ɾ���ӱ�����','warning');
				$('#maindg').datagrid('reload'); //���¼���
			}else if(delflag==1){             //wangxuejian 2016-09-28
		
			}
                        else {
				$.messager.alert('��ʾ','ɾ��ʧ��','warning');
				$('#maindg').datagrid('reload'); //���¼���
			}
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
		})

	}else{
		$.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		return;
	}	
			
}		

//����
function SetCellOpUrl(value, rowData, rowIndex)
{   var ID=rowData.ID;         //����ID
	var TypeCode=rowData.TypeCode; //�������ʹ���
	var RepShareFlag=rowData.RepShareFlag  //����״̬
	var statusflag=rowData.status.indexOf("����")
	var html = "";
	if ((RepShareFlag == "����")&&(statusflag<0)){
		html = "<a href='#' onclick=\"newCreateConsultWin('"+ID+"','"+TypeCode+"')\" style='margin:0px 5px;font-weight:bold;color:red;text-decoration:none;'>�鿴�ظ��б�</a>";
	}else if ((RepShareFlag == "����")&&(statusflag>=0)){
		html = "<a href='#' onclick=\"newCreateConsultWin('"+ID+"','"+TypeCode+"')\" style='margin:0px 5px;font-weight:bold;color:yellow;text-decoration:none;'>�鿴�ظ��б�</a>";
	}
	else{
		  html = "<a href='#' onclick=\"newCreateConsultWin('"+ID+"','"+TypeCode+"')\">�鿴�ظ��б�</a>";
		}
    return html;
}

/**
  * �½����۴���
  */
function newCreateConsultWin(ID,TypeCode){
/* 	alert(ID)
	var option = {
		minimizable : true,
		maximizable : true
		};
	var newConWindowUX = new WindowUX('�б�', 'newConWin', '1110', '620', option);
	newConWindowUX.Init();
	                                             
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.onlinereview.csp?ID='+ID+'"></iframe>';
	$('#newConWin').html(iframe); */
	
	
	if($('#winonline').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:'�б�',
		collapsible:true,
		border:false,
		closed:"true",
		width:1110,
		height:620
	});
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.onlinereview.csp?ID='+ID+'&TypeCode='+TypeCode+'"></iframe>';
		$('#winonline').html(iframe);
		$('#winonline').window('open');
	
}




///���ñ༭����
function setCellEditSymbol(value, rowData, rowIndex)
{
		var ID=rowData.ID;         //����ID
		var TypeCode=rowData.TypeCode; //�������ʹ���
		var assessID=rowData.Assess; //��������id 2017-06-12
		var status=rowData.status; //����״̬���� 2017-06-13
		var Medadrreceivedr=rowData.Medadrreceivedr //����״̬dr
		var StaFistAuditUser=rowData.StaFistAuditUser  //��������
		var BackAuditUser=rowData.BackAuditUser //���ز�����
		var satatusButton=0;  //�޸ı�־  0�����޸� 1�������޸�
		if ((assessID=="")||(status.indexOf("����") > 0)){
			assessID="";
		}
		if((Medadrreceivedr==2)&&(StaFistAuditUser!=LgUserName)&&(BackAuditUser!=LgUserName)){
			satatusButton=1;
		}
		return "<a href='#' onclick=\"showEditWin('"+ID+"','"+TypeCode+"','"+assessID+"','"+satatusButton+"')\"><img src='../scripts/dhcadvEvt/images/editb.png' border=0/></a>";
}
///������ǰ��ɫ
function setCellColor(value, rowData, rowIndex)
{
	return '<span style="color:red;">'+value+'</span>';;
}

//�༭����
function showEditWin(ID,TypeCode,assessID,satatusButton)
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'����༭',
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600
	});
	if(TypeCode=="material"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.matareport.csp?matadrID='+ID+'&editFlag='+1+'&assessID='+assessID+'&satatusButton='+satatusButton+'""></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(TypeCode=="drugerr"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medsafetyreport.csp?medsrID='+ID+'&editFlag='+1+'&assessID='+assessID+'&satatusButton='+satatusButton+'""></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}
	if(TypeCode=="blood"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.bloodreport.csp?bldrptID='+ID+'&editFlag='+1+'&assessID='+assessID+'&satatusButton='+satatusButton+'""></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}	
	if(TypeCode=="med"||TypeCode=="bldevent"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medicalreport.csp?adrRepID='+ID+'&editFlag='+1+'&assessID='+assessID+'&satatusButton='+satatusButton+'""></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}	
	if(TypeCode=="drug"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.advreport.csp?advdrID='+ID+'&editFlag='+1+'&assessID='+assessID+'&satatusButton='+satatusButton+'""></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}
}



///��0���˵ǼǺ�
function GetWholePatID(RegNo)
{
	var len=RegNo.length;
	var  reglen=10
	var zerolen=reglen-len
	var zero=""
	for (var i=1;i<=zerolen;i++)
	{zero=zero+"0" ;
		}
	var RegNo=zero+RegNo ;
	$("#patno").val(RegNo);
}

 
// ����Excel
function Export()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('��ʾ',"<font style='color:red;font-weight:bold;font-size:20px;'>����ѡ��һ�м�¼!</font>","error");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ���е�������", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			var filePath=browseFolder();
			if (typeof filePath=="undefined"){
				$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ��·����,���ԣ�</font>","error");
				return;
			}
       var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	     if ((filePath==undefined)||(filePath.match(re)=="")||(filePath.match(re)==null)){
		 	$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		 	return;
	     }
			$.each(selItems, function(index, item){
		
				var ID=item.ID;         //����ID
				var TypeCode=item.TypeCode; //�������ʹ���
				ExportExcel(ID,TypeCode,filePath);
			})
			$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
		}
	})
}
/// ��ӡ
function Print(){
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('��ʾ',"<font style='color:red;font-weight:bold;font-size:20px;'>����ѡ��һ�м�¼!</font>","error");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ���д�ӡ����", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var ID=item.ID;         //����ID
				var TypeCode=item.TypeCode; //�������ʹ���
				printRep(ID,TypeCode);
			})
		}
	})
}
//2016-10-10
function CloseWinUpdate(){
		$('#win').window('close');
}