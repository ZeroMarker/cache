// Creator: congyue
/// CreateDate: 2015-11-09
//  Descript: ������Ӧ��ѯ

var url = "dhcadv.repaction.csp";
var statArray = [{ "val": "�", "text": "�" },{ "val": "ȷ��", "text": "ȷ��" },{ "val": "���", "text": "���" }, { "val": "���", "text": "���" }];
var statReceive = [{ "val": "δ����", "text": "δ����" },{ "val": "1", "text": "����" },{ "val": "2", "text": "����" }];
var statShare = [{ "val": "δ����", "text": "δ����" },{ "val": "����", "text": "����" }];
var editRow="",TranFlag=0,errflag=0 ;///TranFlag:ת����־   errflag:ת���ظ���Ա�뱻ת����Ա�Ƿ�һ��
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
		url:url+'?action=SelAllLoc'
	});
	/* ״̬ zhaowuqiang   2016-09-22*/
/* 	var StatusCombobox = new ListCombobox("status",'',statArray,{panelHeight:"auto"});
	StatusCombobox.init(); */

	/* �������� zhaowuqiang   2016-09-22*/
/* 	var TypeeventCombobox = new ListCombobox("typeevent",url+'?action=selEvent','',{});
	TypeeventCombobox.init(); */
	
	//�������������zhaowuqiang   2016-09-22
	$('#typeevent').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=QueryEvtworkFlow',
		onSelect: function(rec){  
           var TypeStatus=rec.value; 
			ComboboxEvent(TypeStatus);        
	  }
	}); 
	
	/* ����״̬ */  
	var ReceiveCombobox = new ListCombobox("receive",'',statReceive,{panelHeight:"auto"});
	ReceiveCombobox.init();
	
	/* ����״̬ */  
	var ShareCombobox = new ListCombobox("Share",'',statShare,{panelHeight:"auto"});
	ShareCombobox.init();
	
	$('#Find').bind("click",Query);  //�����ѯ
	$('#audit').bind("click",Process); //����
	$('#Audit').bind("click",Audit); //ȷ������
	$('#REceive').bind("click",REceive); //����
	$('#back').bind("click",Back); //���沵��
	$('#RepImpFlag').bind("click",RepImpFlag); //�ص��ע
	$('#SHare').bind("click",Share); //����״̬  RepShareFlag
	$('a:contains("����")').bind("click",Export); 	  //����
	$('a:contains("��ӡ")').bind("click",Print);     //��ӡ
	$('#Transcription').bind("click",Transcription); //ת������
	//$('#exportAudit').bind("click",ExportAudit); 	  //��˵���  zhaowuqiang  2016-09-22
	
	InitRepList(); //��ʼ�������б�
	
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
//���ݱ������Ͳ�ѯ  zhaowuqiang   2016-09-22
function ComboboxEvent(TypeStatus){
   //���������״̬
    $('#status').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=QueryFlowItm&params='+TypeStatus
	});    

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
	//var status=$('#status').combobox('getValue');  //״̬  zhaowuqiang   2016-09-22
	//var typeevent=$('#typeevent').combobox('getValue');  //��������
	var status=$("#status").combobox('getText');
	
	var typeevent=$('#typeevent').combobox('getValue');  //��������
	var receive=$('#receive').combobox('getValue');  //����״̬
	var statShare=$('#Share').combobox('getValue');  //����״̬ 
	if (LocID==undefined){LocID="";}
	if (status==undefined){status="";}
	if (typeevent==undefined){typeevent="";}
	if (receive==undefined){receive="";}
	if (statShare==undefined){statShare="";}
	var PatNo=$.trim($("#patno").val());
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+receive+"^"+statShare;
	$('#maindg').datagrid({
		url:url+'?action=QueryMataReport',	
		queryParams:{
			params:params}
	});
}

//ȷ������
function Audit()
{	var NextLoc=$('#matadrNextLoc').combobox('getValue');
	var LocAdvice=$('#matadrLocAdvice').val();
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
		if(LocAdvice=="")     // wangxuejian 2016-10-26
		{
		$.messager.alert("��ʾ:","�����������Ϊ�գ�");	
		return;
		}
	$.each(selItems, function(index, item){
		var ID=item.ID;         //����ID
		var typecode=item.typecode; //�������ʹ���
		var StatusNextID=item.StatusNextID; //��һ��״̬
		var Medadrreceivedr=item.Medadrreceivedr;//����״̬
		var params=ID+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+typecode;   //������
		//alert(params);
		//��������
		$.post(url+'?action=AuditMataReport',{"params":params},function(jsonString){
			var resobj = jQuery.parseJSON(jsonString);
			var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
			if(resobj.ErrCode < 0){
				$.messager.alert("��ʾ:","<font style='font-size:20px;'>��˴���,����ԭ��:</font><font style='font-size:20px;color:red;'>"+"��"+num+"������"+resobj.ErrMsg+"</font>");
			}
		});
	})
	$('#maindg').datagrid('reload'); //���¼���
	$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
	$('#Process').window('close');
}


//���
function Process()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	//$.messager.confirm("��ʾ", "�Ƿ������˲���", function (res) {//��ʾ�Ƿ�ɾ��
		//if (res) {
	$.each(selItems, function(index, item){
		$('#Process').window({
			title:'���',
			collapsible:false,
			border:false,
			closed:false,
			width:400,
			height:280
		});
		//ָ�����
		$('#matadrNextLoc').combobox({
			//panelHeight:"auto",  //���������߶��Զ�����
			url:url+'?action=SelAllLoc'
		});  
		$('#Process').window('open'); 
		$("#matadrLocAdvice").empty(); 
	});
		//}
	//})
}

//����
function REceive()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ���н��ղ���", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var ID=item.ID;         //����ID
				var typecode=item.typecode;         //�������ʹ���
				var Medadrreceivedr=item.Medadrreceivedr;//����״̬
				var StatusID=item.StatusID //��ǰ״̬id
				var params=ID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+typecode+"^"+StatusID;   //������
				//alert(params);
				//��������
				$.post(url+'?action=REMataReport',{"params":params},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
					var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
					if(resobj.ErrCode < 0){
						$.messager.alert("��ʾ:","<font style='font-size:20px;'>���մ���,����ԭ��:</font><font style='font-size:20px;color:red;'>"+"��"+num+"������"+resobj.ErrMsg+"</font>");
					}
				});
			})
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
		}
	})
}
//���沵��
function Back()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ���в��ز���", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var ID=item.ID;         //����ID
				var typecode=item.typecode;         //�������ʹ���
				var Medadrreceivedr=item.Medadrreceivedr;//����״̬
				var StatusID=item.StatusID //��ǰ״̬id
				var params=ID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+typecode+"^"+StatusID;   //������
				//alert(params);
				//��������
				$.post(url+'?action=ReportBack',{"params":params},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
					var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
					if(resobj.ErrCode < 0){
				$.messager.alert("��ʾ:","<font style='font-size:20px;'>���ش���,����ԭ��:</font><font style='font-size:20px;color:red;'>"+"��"+num+"������"+resobj.ErrMsg+"</font>");
					}
				});
		
			})
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
		}
	})
}


//����
function Share(){
var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("��ʾ:","�������,��ֻѡ��һ�����ݣ�");
		return;
	}
	var ID=selItems[0].ID;         //����ID
	var typecode=selItems[0].typecode;         //�������ʹ���
	var RepShareFlag=selItems[0].RepShareFlag;//����״̬				
	var StatusID=selItems[0].StatusID //��ǰ״̬id
	var params=ID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+typecode+"^"+StatusID+"^"+RepShareFlag   //������
	
  	var Sharemessage=""
     if(RepShareFlag=="δ����"){
	     Sharemessage="����";
	} 
	if(RepShareFlag=="����"){
	     Sharemessage="ȡ������";
	}
	
	$.messager.confirm("��ʾ", "�Ƿ����"+Sharemessage+"����", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			//��������
			$.post(url+'?action=InsRepShare',{"params":params},function(jsonString){
				var resobj = jQuery.parseJSON(jsonString);
				if(resobj.ErrCode < 0){
					$.messager.alert("��ʾ:","<font style='font-size:20px;'>���մ���,����ԭ��:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
				}
			});
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
		}
	})
	
	
}

//�ص��ע
function RepImpFlag()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
   	if (selItems.length>1){
		$.messager.alert("��ʾ:","��ע����,��ֻѡ��һ�����ݣ�");
		return;
	}
	var ID=selItems[0].ID;         //����ID
	var typecode=selItems[0].typecode;         //�������ʹ���
    var RepImpFlag=selItems[0].RepImpFlag;    //�ص���
  	var Impmessage=""
    if(RepImpFlag=="δ��ע"){
	     RepImpFlag="N";
	     Impmessage="��ע";
	} 
	if(RepImpFlag=="��ע"){
	     RepImpFlag="Y";
	     Impmessage="ȡ����ע";
	}
	$.messager.confirm("��ʾ", "�Ƿ����"+Impmessage+"����", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
				
			if(typecode=="drug"){ //ҩƷ
			//��������
			$.post(url+'?action=REPImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
				var resobj = jQuery.parseJSON(jsonString);
			 });
			}
			if(typecode=="blood"){//��Ѫ
			//��������
			$.post(url+'?action=BloodImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
				var resobj = jQuery.parseJSON(jsonString);
			 });
			}
			if(typecode=="med"||typecode=="bldevent"){ //ҽ��
			//��������
			$.post(url+'?action=MedImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
				var resobj = jQuery.parseJSON(jsonString);
			 });
			}
			if(typecode=="material"){//��е
			//��������
			$.post(url+'?action=MaterImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
				var resobj = jQuery.parseJSON(jsonString);
			 });
			}
			if(typecode=="drugerr"){//��ҩ����
			//��������
			$.post(url+'?action=DrugerImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
				var resobj = jQuery.parseJSON(jsonString);
			 });
			}
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ
		}
	})
}


//��ʼ�������б�
function InitRepList()    //wangxuejian 2016-09-28
{
	//����columns   
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:'Edit',title:'�޸�',width:80,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:'AuditList',title:'������ϸ',width:80,align:'center',formatter:setCellAuditList,hidden:false},
		{field:'Assess',title:'������ϸ',width:80,align:'center',formatter:setCellAssess,hidden:false},
		{field:'PatName',title:'����',width:120},
		{field:'PatNo',title:'�ǼǺ�',width:120},
		{field:'LocDesc',title:'�������',width:220},
		{field:'Creator',title:'������',width:120},
		{field:'Typeevent',title:'��������',width:100},
		{field:'CreateDate',title:'��������',width:100},
		{field:'Medadrreceive',title:'����״̬',width:120},
		{field:'Medadrreceivedr',title:'����״̬dr',width:80,hidden:true},
		{field:'Status',title:'��ǰ״̬',width:100,hidden:false},
		{field:'StatusID',title:'��ǰ״̬ID',width:100,hidden:true},
		{field:'StatusNext',title:'��һ״̬',width:100,hidden:false},
		{field:'StatusNextID',title:'��һ״̬ID',width:100,hidden:true},
		{field:'catDesc',title:'һ������',width:100,hidden:true},
		{field:'armaCatDesc',title:'��������',width:100,hidden:true},
		{field:'armaLevelDesc',title:'�¼��ȼ�',width:100,hidden:true},
		{field:'RepImpFlag',title:'�ص��ע',width:100,align:'center',formatter:setCellColorOne,hidden:false},
		{field:'RepShareFlag',title:'����״̬',width:100,align:'center'},
		{field:'RepNo',title:'������',width:160},
		{field:'typecode',title:'�������ʹ���',width:120},
		{field:'TypeID',title:'��������ID',width:220,hidden:true},//TypeID
		{field:'Subflag',title:'�ӱ��־',width:120,hidden:true},
		{field:'SubUserflag',title:'�ӱ��û���־',width:120,hidden:true}
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
	        if (row.Medadrreceivedr==2){  
	            return 'background-color:red;';  
	        }  
    	},
        onSelect:function(rowIndex, rowData){  
			var reportID=rowData.ID;         //����ID
			var typecode=rowData.typecode;         //��������
			var params=reportID+"^"+typecode+"^"+LgUserID;
			var Subflag=rowData.Subflag;
			var SubUserflag=rowData.SubUserflag;
	        /* $.ajax({
				type: "POST",// ����ʽ
		    	url: url,
				async: false, //ͬ��
		    	data: "action=SearchAuditIUser&params="+params,
				success: function(data){
					SubUserflag=data;
				}
			}); */
			if((Subflag==1)&&(SubUserflag==1)){
				$('#REceive').hide();
				$('#back').hide();
				$('#RepImpFlag').hide();
				$('#SHare').hide();
				$('#audit').hide();
			}else{
				$('#REceive').show();
				$('#back').show();
				$('#RepImpFlag').show();
				$('#SHare').show();
				$('#audit').show();
			}
			var RepImpFlag=rowData.RepImpFlag;    //�ص��ע
	        var RepShareFlag=rowData.RepShareFlag; //����״̬
        
		    if ((RepImpFlag=="��ע")){
				$('#RepImpFlag').linkbutton({ // ʹ��js�ķ�ʽ�ܴﵽЧ�� 2016-10-17
	    			iconCls: 'icon-impflagcancel',
	    			text:'ȡ����ע'
				});
		    }else{
				$('#RepImpFlag').linkbutton({ // ʹ��js�ķ�ʽ�ܴﵽЧ�� 2016-10-17
	    			iconCls: 'icon-impflag',
	    			text:'�ص��ע'
				});
		    }
	    
		     if ((RepShareFlag=="����")){
				$('#SHare').linkbutton({ // ʹ��js�ķ�ʽ�ܴﵽЧ�� 2016-10-17
	    			iconCls: 'icon-sharecancel',
	    			text:'��������'
				});
			}else{
				$('#SHare').linkbutton({ // ʹ��js�ķ�ʽ�ܴﵽЧ�� 2016-10-17
	    			iconCls: 'icon-share',
	    			text:'����'
				});
			}
		}  
	});
	
	initScroll("#maindg");//��ʼ����ʾ���������
}

///���ñ༭����
function setCellEditSymbol(value, rowData, rowIndex)
{
		var ID=rowData.ID;         //����ID
		var typecode=rowData.typecode; //�������ʹ���
		var assessID=rowData.Assess; //��������id 2017-06-12
		var Medadrreceive=rowData.Medadrreceive; //����״̬���� 2017-06-13
		if ((assessID=="")||(Medadrreceive=="����")){
			assessID="";
		}
		return "<a href='#' onclick=\"showEditWin('"+ID+"','"+typecode+"','"+assessID+"')\"><img src='../scripts/dhcadvEvt/images/editb.png' border=0/></a>";
}

///������ǰ��ɫ���ص��ע�� 2017-04-06 �޸ļȲ����ֹ�ע�� ������ɫ
function setCellColorOne(value, rowData, rowIndex)
{     
     var RepImpFlag=rowData.RepImpFlag
     if((RepImpFlag=="��ע")&&(rowData.Medadrreceivedr!=2)){
	   return '<span style="color:red;">'+value+'</span>'; //2016-10-08
     }else if((RepImpFlag=="��ע")&&(rowData.Medadrreceivedr==2)){ 
	   return '<span style="color:white;">'+value+'</span>'; //2016-10-08
     }else{
	     
	   return  value;
	 }
}

///������ǰ��ɫ
function setCellColor(value, rowData, rowIndex)
{
	return '<span style="color:red;">'+value+'</span>';;
}

//�༭����
function showEditWin(ID,typecode,assessID)
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
	if(typecode=="material"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.matareport.csp?matadrID='+ID+'&editFlag='+1+'&assessID='+assessID+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(typecode=="drugerr"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medsafetyreport.csp?medsrID='+ID+'&editFlag='+1+'&assessID='+assessID+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(typecode=="blood"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.bloodreport.csp?bldrptID='+ID+'&editFlag='+1+'&assessID='+assessID+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	
	if(typecode=="med"||typecode=="bldevent"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medicalreport.csp?adrRepID='+ID+'&editFlag='+1+'&assessID='+assessID+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(typecode=="drug"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.advreport.csp?advdrID='+ID+'&editFlag='+1+'&assessID='+assessID+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}	
}
//2016-10-10
function CloseWinUpdate(){
		$('#win').window('close');
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
	     if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		 	$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		 	return;
	     }
			$.each(selItems, function(index, item){
		
				var ID=item.ID;         //����ID
				var typecode=item.typecode; //�������ʹ���
				ExportExcel(ID,typecode,filePath);
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
				var typecode=item.typecode; //�������ʹ���
				printRep(ID,typecode);
			})
		}
	})
}
//��ȡ����ʱ�� 2016-10-08 congyue
function getDateTime(){
	var tmp="";
	var time="";
  		$.ajax({
	  	async: false,
		type: "POST",// ����ʽ
    	url: url,
    	data: "action=GetDealDateTime",
		success: function(data){
		var tmp=data.split("^");
		$('#medadrDateTime').val(tmp[0]+" "+tmp[1]);   //����ʱ��
		}
  	}); 
}

//ת��  2016-05-13 ����
function Transcription()
{	
	//TranFlag=0;
	//��������
	$('#medadrUser').attr("disabled",false);
	$('#medadrDateTime').attr("disabled",false);
	$("#tranLocAdvic").attr("disabled",false);
	$("#medadrUser").val("");
	$("#medadrDateTime").val("");
	$("#tranLocAdvic").val("");
	$("#tranLocDr").combobox('setValue',"");
	$("#tranReplyMess").val("");

	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("��ʾ:","ת������,��ֻѡ��һ�����ݣ�");
		return;
	}
	//$.messager.confirm("��ʾ", "�Ƿ����ת������", function (res) {//��ʾ�Ƿ�ɾ��
		//if (res) {

	$('#TranWin').window({
		title:'ת��',
		collapsible:false,
		border:false,
		closed:false,
		width:900,
		height:580
	});
	$('#TranWin').window('open');
		//}
	//})
	$.each(selItems, function(index, item){
		var reportID=item.ID;         //����ID
		var typecode=item.typecode;         //��������
		var params=reportID+"^"+typecode+"^"+LgUserID;
		var Subflag=item.Subflag;         //�ӱ��־
		var SubUserflag=item.SubUserflag;//��ǰ��¼��Ա������Ƿ�ƥ�䱻ָ����Ա�����
		TranUserList(reportID,typecode,SubUserflag);//ת��ָ����Ա
		TranLocUserList(reportID,typecode,SubUserflag);//ת��������Ա�����Ϣ

		if(SubUserflag==0){
			//��������
			//var time=
			getDateTime(); //2016-10-08 congyue
			$('#medadrUser').attr("disabled",false);
			$('#medadrDateTime').attr("disabled",false);
			$("#tranLocAdvic").attr("disabled",false);
			$("#medadrUser").val(LgUserName);//��ʾת����(��ǰ��½��)
			$("#medadrUser").attr("disabled",true);
			$("#medadrDateTime").attr("disabled",true);
			$("#tranLocAdvic").val("");
			$("#tranLocDr").combobox('setValue',"");
			$("#tranReplyMess").val("");
			$("#tranReply").hide();
			$("#tranReplyMess").hide();	
			$("#replyFlag").hide();//�Ƿ�ת���ظ�

		}
		$.ajax({
			type: "POST",// ����ʽ
	    	url: url,
	    	data: "action=SearchAuditMess&params="+params,
			success: function(data){
				var tmp=data.split("^");
				if(SubUserflag==1){
					$('#medadrUser').val(tmp[0]); //������Ա
					$('#medadrUser').attr("disabled","true");
					$('#medadrDateTime').val(tmp[1]+" "+tmp[2]);   //����ʱ��
					$('#medadrDateTime').attr("disabled","true");
					$('#tranLocAdvic').val(tmp[3]); //�������
					$('#tranLocAdvic').attr("disabled","true");
					$("#tranReply").show();
			        $("#tranReplyMess").show();
			        $("#replyFlag").show();//�Ƿ�ת���ظ�
					//var UserID=rowData.UserID;
					if ((tmp[5]!=LgUserID)&(tmp[6]!=LgCtLocID)){
						errflag=1;
						$("#tranLocDr").combobox('setValue',"");
					}else{
						errflag=0;
					}
		
				}
				else{
					errflag=0;
				}
			}
		});
		if(SubUserflag==1){
			$('#transub').hide();
			$('#tranreply').show();
			$('#tranrec').show();
	
		}else{
			$('#transub').show();
			$('#tranreply').hide();
			$('#tranrec').hide();
	    }
   });
	
}
//ת��ָ����Ա
function TranUserList(reportID,typecode,SubUserflag)
{
	//ת������
	$('#tranLocDr').combobox({
		//url:url+'?action=GetQueryLoc&RepTypeCode='+typecode,
		mode:'remote',  //���������������
		onShowPanel:function(){ 
			$('#tranLocDr').combobox('reload',url+'?action=GetQueryLoc&RepTypeCode='+typecode)
		},
		onSelect:function(){
			var tranLocDr=$('#tranLocDr').combobox('getValue');
			$('#selectdg').datagrid({
				url:url+'?action=GetUserDr',	
				queryParams:{
					params:typecode+"^"+tranLocDr}
			});
		}
	}); 
	//����columns
	var usercolumns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:"LocID",title:'LocID',width:90,hidden:true},
		{field:"Locname",title:'Locname',width:90,hidden:true},
		{field:"UserID",title:'UserID',width:90,hidden:true},
		{field:'Username',title:'������Ա',width:120}
	]];
	var titleNotes="";
	if(SubUserflag==1){
		titleNotes="";
	}else{
		titleNotes='<span style="font-size:10pt;font-family:���Ŀ���;color:red;">[˫���м��������ת����Ϣ��]</span>';
	}
	var params=reportID+"^"+typecode;
	//����datagrid
	$('#selectdg').datagrid({
		title:'ָ����Ա'+titleNotes,
		url:url+'?action=QueryUserMess&paramsuser='+params,
		fit:true,
		rownumbers:true,
		columns:usercolumns,
		border:false,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){ 
			if((SubUserflag==1)){ //(SubUserflag==1)||(TranFlag==1)
				$('#selectdg').datagrid({title:'ָ����Ա'});
				return;
			}else{
				$('#selectdg').datagrid({title:'ָ����Ա'+titleNotes});
				if ((editRow != "")||(editRow == "0")) {
	            	$("#selectdg").datagrid('endEdit', editRow);
				}
				var LocID=rowData.LocID;
				var UserID=rowData.UserID;
				var Username=rowData.Username;
			
				var tranLocDr=$('#tranLocDr').combobox('getValue');
				var tranLocDesc=$('#tranLocDr').combobox('getText');
				$('#tranmesdg').datagrid('insertRow',{
					 index: 0,	// index start with 0
					 row: {
						ID:"",
						name: Username,
						nameID: UserID,
						LocDesc: tranLocDesc,
						LocDr: tranLocDr
					}
		        });
		    }
		}
     
	});
 	/* var params=reportID+"^"+typecode;
	$('#selectdg').datagrid({
		url:url+'?action=QueryUserMess',
		queryParams:{
			params:params}
	});  
	*/ 
}
//ת��������Ա�����Ϣ
function TranLocUserList(reportID,typecode,SubUserflag)
{
	//����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:"tranDateTime",title:'ת��ʱ��',width:90,hidden:true},
		{field:'tranuser',title:'ת����',width:120,hidden:true},
		{field:"tranuserID",title:'tranuserID',width:90,hidden:true},
		{field:'LocDesc',title:'����',width:120},
		{field:"LocDr",title:'LocDr',width:90,hidden:true},
		{field:'name',title:'��Ա',width:80},
		{field:"nameID",title:'nameID',width:90,hidden:true},
		{field:'LocAdvice',title:'�������',width:100},
		{field:'advice',title:'�ظ�����',width:100},
		{field:'DutyFlag',title:'��ע',width:200},
		{field:"tranreceive",title:'����״̬',width:90,hidden:true},
		{field:"tranrecedate",title:'��������',width:90,hidden:true},
		{field:"trancompdate",title:'�������',width:90,hidden:true}
	]];
	var titleOpNotes="";
	if(SubUserflag==1){
		titleOpNotes="";
	}else{
		titleOpNotes='<span style="font-size:10pt;font-family:���Ŀ���;color:red;">[˫���м��������������]</span>';
	}
	var params=reportID+"^"+typecode;
	//����datagrid
	$('#tranmesdg').datagrid({
		title:'ת����Ϣ��'+titleOpNotes,
		url:url+'?action=QueryTranLocUser&params='+params,
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
        nowrap:false,
		onDblClickRow:function(rowIndex, rowData){  //˫�����ѡ����
			if((SubUserflag==1)){ //(SubUserflag==1)||(TranFlag==1)
				return;
			}else{
				if((rowData.LocAdvice==undefined)||(rowData.LocAdvice=="")){
					$('#tranmesdg').datagrid('deleteRow',rowIndex);
				}else{
					alert("��ת��,����ɾ��");	
				}
			}
		}
	});	
	
	/* var params=reportID+"^"+typecode;
	$('#tranmesdg').datagrid({
		url:url+'?action=QueryTranLocUser',	
		queryParams:{
			params:params}
	});
	 */
}
//ת���ύ
function TranSub()
{
	/* if(TranFlag==1){
		$.messager.alert("��ʾ:","���ύ�ɹ��������ظ����");
		return;
	} */
	if(errflag==1){
		$.messager.alert("��ʾ:","��ת����ָ����Ա����Ȩ�޲���");
		return;
	}
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	var tranReplyMess=$('#tranReplyMess').val();
	var mediReceive="",mediRecDate="",mediRecTime="",mediCompleteDate="",mediCompleteTime="",medadrList="";	
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.each(selItems, function(index, item){
		var reportID=item.ID;         //����ID
		var typecode=item.typecode; //�������ʹ���
		var Medadrreceivedr=item.Medadrreceivedr;//����״̬
		var StatusNextID=item.StatusNextID; //��һ��״̬
		var StatusID=item.StatusID //��ǰ״̬
		medadrList=reportID+"^"+typecode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+StatusID;   //������
	})		
	var rows = $("#tranmesdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].LocDr=="")||(rows[i].nameID=="")){
			$.messager.alert("��ʾ","����ָ�����Ա����Ϊ��!"); 
			return false;
		}
		if(tranLocAdvic==""){
			$.messager.alert("��ʾ","�����������Ϊ��!"); 
			return false;
		}
		var List=rows[i].ID+"^"+LgUserID+"^"+rows[i].LocDr+"^"+rows[i].nameID+"^"+tranReplyMess+"^"+mediReceive+"^"+mediRecDate+"^"+mediRecTime+"^"+mediCompleteDate+"^"+mediCompleteTime+"^"+tranLocAdvic;
		dataList.push(List);
	} 
	var medadriList=dataList.join("&&");
	var params="medadrList="+medadrList+"&medadriList="+medadriList; 
	//alert(params);
	//��������
	$.post(url+'?action=SaveTranMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode==0){
			//TranFlag=1;
			$.messager.alert("��ʾ:","�ύ�ɹ�");
			$('#maindg').datagrid('reload'); //���¼���
			$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ $('#maindg').datagrid('clearSelections')  //2017-06-09 ���ȫѡ
			
		}
		if(resobj.ErrCode < 0){
			$.messager.alert("��ʾ:","<font style='font-size:20px;'>ת���ύ����,����ԭ��:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
			return ;
		}
		//$('#selectdg').datagrid('reload'); //���¼���
		//$('#tranmesdg').datagrid('reload'); //���¼���
		
	});
	closeDrgWindow();		
}
//ת���ظ�
function TranReply(Replyflag)
{   var tranDutyFlag="N"  //ת��֮��δ�ظ�
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	var tranReplyMess=$('#tranReplyMess').val();
	if($("#reply").is(':checked')){
		tranDutyFlag="Y";
	}
	var medadriList=LgUserID+"^"+tranReplyMess+"^"+Replyflag+"^"+tranDutyFlag;
	
	var rows = $("#tranmesdg").datagrid('getRows');
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((Replyflag==1)&&(rows[i].advice!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert("��ʾ:","���ύ�ɹ��������ظ����");
			return false;
		}
		
		if((Replyflag==0)&&(rows[i].tranrecedate!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert("��ʾ:","�ѽ��ճɹ��������ظ����");
			return false;
		}
		if((Replyflag==0)&&(rows[i].advice!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert("��ʾ:","�ظ����ύ��������Ч");
			return false;
		}
	} 
	/* if((TranFlag==1)&(Replyflag==1)){
		$.messager.alert("��ʾ:","���ύ�ɹ��������ظ����");
		return;
	}
	if((TranFlag==2)&(Replyflag==0)){
		$.messager.alert("��ʾ:","�ѽ��ճɹ��������ظ����");
		return;
	}
	if((TranFlag==1)&(Replyflag==0)){
		$.messager.alert("��ʾ:","�ظ����ύ��������Ч");
		return;
	} */
	
	if((errflag==1)&(Replyflag==0)){
		$.messager.alert("��ʾ:","��ת����ָ����Ա����Ȩ�޲���");
		return;
	}
	if((Replyflag==1)&(tranReplyMess=="")){
		$.messager.alert("��ʾ:","�ظ��ύ�������ظ����ݲ���Ϊ��");
		return;
	}
	if((Replyflag==0)&(tranReplyMess!="")){
		$.messager.alert("��ʾ:","���ղ������ظ����ݲ���");
		return;
	}
	var selItems = $('#maindg').datagrid('getSelections');
	var medadrList="";
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.each(selItems, function(index, item){
		var reportID=item.ID;         //����ID
		var typecode=item.typecode; //�������ʹ���
		var Medadrreceivedr=item.Medadrreceivedr;//����״̬
		var StatusNextID=item.StatusNextID; //��һ��״̬
		medadrList=reportID+"^"+typecode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID;   //������
		//var params="medadrList="+medadrList+"&medadriList="+medadriList; 
	})
	//alert(params);
	//��������
	$.post(url+'?action=SaveReplyMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode==0){
			if(Replyflag==1){
				//TranFlag=1;
				$('#maindg').datagrid('reload'); //���¼���
				$('#maindg').datagrid('unselectAll') //2017-04-06 ���ȫѡ $('#maindg').datagrid('clearSelections')  //2017-06-09 ���ȫѡ
			}
			$.messager.alert("��ʾ:","�����ɹ�");
			   closeDrgWindow();	
		}
		if(resobj.ErrCode < 0){
			$.messager.alert("��ʾ:","<font style='font-size:20px;'>��������,����ԭ��:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
		}
		//$('#selectdg').datagrid('reload'); //���¼���
		//$('#tranmesdg').datagrid('reload'); //���¼���
		
	});
}

//2016-10-13
function closeDrgWindow()
{  
	$('#TranWin').window('close');
}
/*
 //ת������
function TranRec()
{
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	var tranReplyMess="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.each(selItems, function(index, item){
		var reportID=item.ID;         //����ID
		var typecode=item.typecode; //�������ʹ���
		var Medadrreceivedr=item.Medadrreceivedr;//����״̬
		var StatusNextID=item.StatusNextID; //��һ��״̬
		var medadrList=reportID+"^"+typecode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID;   //������
		var medadriList=LgUserID+"^"+tranReplyMess;
		var params="medadrList="+medadrList+"&medadriList="+medadriList; 
		//��������
		$.post(url+'?action=SaveTranMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
			var resobj = jQuery.parseJSON(jsonString);
			if(resobj.ErrCode==0){
				$.messager.alert("��ʾ:","���ճɹ�");
			}
			if(resobj.ErrCode < 0){
				$.messager.alert("��ʾ:","<font style='font-size:20px;'>���մ���,����ԭ��:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
			}
		});
	})	
} */

///����������ϸ����  2016-05-31
function setCellAuditList(value, rowData, rowIndex)
{
		var ID=rowData.ID;         //����ID
		var typecode=rowData.typecode; //�������ʹ���
		return "<a href='#' onclick=\"showAuditListWin('"+ID+"','"+typecode+"')\"><img src='../scripts/dhcadvEvt/images/viewlist.png' border=0/></a>";
}
//�༭����
function showAuditListWin(ID,typecode)
{
	$('#Auditwin').window({
		title:'������ϸ',
		collapsible:true,
		border:false,
		closed:"true",
		width:900,
		height:500
	});
	var columns=[[
		{field:'Status',title:'����״̬',width:80},
		{field:'StatusDR',title:'����״̬ID',width:100,hidden:true},
		{field:'AuditUser',title:'������',width:100},
		{field:'AuditUserDR',title:'������ID',width:100,hidden:true},
		{field:'AuditDateTime',title:'����ʱ��',width:150},
		{field:'NextLoc',title:'����ָ��',width:150},
		{field:'NextLocDR',title:'����ָ��ID',width:100,hidden:true},
		{field:'LocAdvice',title:'�������',width:280},
		{field:'Receive',title:'����״̬',width:60},
		{field:'Subflag',title:'Subflag',width:60,hidden:true},
		{field:'ID',title:'ID',width:50,hidden:true} 
	]]; 
	
	// ����columns
	var itmcolumns=[[
		{field:'MedIAuditDateTime',title:'����ʱ��',width:150},
		{field:'MedIAuditUser',title:'������',width:100},
		{field:'MedIAuditUserDR',title:'������ID',width:100,hidden:true},
		{field:'MedINextLoc',title:'ָ�����',width:150},
		{field:'MedINextLocDR',title:'����ָ��ID',width:100,hidden:true},
		{field:'MedILocAdvice',title:'�������',width:200},
		{field:'MedINextUser',title:'ָ����Ա',width:100},
		{field:'MedINextUserDR',title:'ָ����ԱID',width:100,hidden:true},
		{field:'MedIUserAdvice',title:'��Ա���',width:200},
		{field:'MedIReceive',title:'����״̬',width:60},
		{field:'DutyFlag',title:'��ע',width:200},
		{field:'MedIReceiveDateTime',title:'����ʱ��',width:150},
		{field:'MedICompleteDateTime',title:'���ʱ��',width:150}
	]];
	var params=ID+"^"+typecode;
	//����datagrid
	$('#AuditListdg').datagrid({
		url:url+'?action=QueryAuditMess&params='+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		//fitColumns:true,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
        view: detailview,
        subGrid: true,
        nowrap:false,
        detailFormatter:function(index,rowData){
	         if(rowData.Subflag==0) return "";
             return '<div style="padding:0px"><table class="AuditItmListdg"></table></div>';
        },
        onExpandRow:function(index,rowData){
          	var AuditID=rowData.ID;
            var Subflag=rowData.Subflag;
            if(Subflag==0){
	         	return;   
	         }
            if (Subflag==1){
            var AuditItmListdg = $(this).datagrid('getRowDetail',index).find('table.AuditItmListdg');
            AuditItmListdg.datagrid({
				url:url+'?action=QueryAudItmMess&params='+AuditID,
				columns:itmcolumns,
                singleSelect:false,
                rownumbers:true,
				loadMsg: '���ڼ�����Ϣ...',
                height:'auto',
                nowrap:false,
		        onResize:function(){
                    $('#AuditListdg').datagrid('fixDetailRowHeight',index);
                },
                onLoadSuccess:function(){
					setTimeout(function(){
						$('#AuditListdg').datagrid('fixDetailRowHeight',index);
                    },0);
                }
            });
            $('#AuditListdg').datagrid('fixDetailRowHeight',index);
	      } 
        },
        onLoadSuccess:function(data){
			var me = this;
			$(me).parent().find('span.datagrid-row-expander').trigger('click'); //ûЧ��ע���޸������ѡ����
		}
	});
	$('#Auditwin').window('open');
	
}

// ��˵���  zhaowuqiang  2016-09-22
function ExportAudit()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('��ʾ',"<font style='color:red;font-weight:bold;font-size:20px;'>����ѡ��һ�м�¼!</font>","error");
		return;
	}
	
	$.messager.confirm("��ʾ", "�Ƿ������˵�������", function (res) {//��ʾ�Ƿ���˵���
		if (res) {
			var filePath=browseFolder();
			if (typeof filePath=="undefined"){
				$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ��·����,���ԣ�</font>","error");
				return;
			}
        var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	     if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		 	$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ����Ч·����,���ԣ�</font>","error");
		 	return;
	     }
			//$.each(selItems, function(index, item){
		
				//var ID=item.ID;         //����ID
				//var typecode=item.typecode; //�������ʹ���
				ExportExcelAudit(filePath);
			//})
	
			$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
		}
	})
}

// ��˵���Excel  zhaowuqiang  2016-09-22
function ExportExcelAudit(filePath)
{
/* 	if(ID==""){
		$.messager.alert("��ʾ:","����IDΪ�գ�");
		return;
	}
	
 */  
       //��ȡϵͳ������
    var now = new Date();
    var year = now.getFullYear();       //��
    var month = now.getMonth() + 1;     //��
    if(month<=9){
	    month="0"+month
	} 
    var day = now.getDate();            //��
    if(day<=9){
     day="0"+day
    } 
    var  yearDate=year+""+month+""+day
   	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	var status=$('#status').combobox('getValue');  //״̬
	var typeevent=$('#typeevent').combobox('getValue');  //��������
	var receive=$('#receive').combobox('getValue');  //����״̬
	var statShare=$('#Share').combobox('getValue');  //����״̬ 
	if (LocID==undefined){LocID="";}
	if (status==undefined){status="";}
	if (typeevent==undefined){typeevent="";}
	if (receive==undefined){receive="";}
	if (statShare==undefined){statShare="";}
	var PatNo=$.trim($("#patno").val());
	
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+receive+"^"+statShare;

		var retval=tkMakeServerCall("web.DHCADVSEARCHREPORT","QueryMataRepExport",params);
		if(retval==""){
			$.messager.alert("��ʾ:","ȡ���ݴ���");
			return;
		 }
		 
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_AuditReport.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		//xlApp.Range(objSheet.Cells(2,1),objSheet.Cells(2,16)).Interior.Pattern = 2; //�б���ⱳ����ɫ  
	    var auditRepItmArr=retval.split("&&");
	    for(var k=0;k<auditRepItmArr.length;k++){
			var auditArr=auditRepItmArr[k].split("^");
			var auditArr=auditRepItmArr[k].split("^");
			objSheet.Cells(3+k,1).value=auditArr[1]; //�ϱ�����
			objSheet.Cells(3+k,2).value=auditArr[2]; //�ϱ�����
			objSheet.Cells(3+k,3).value=auditArr[3]; //������
			objSheet.Cells(3+k,4).value=auditArr[4]; //��������
			objSheet.Cells(3+k,5).value=auditArr[17]; //�����Ա�
			objSheet.Cells(3+k,6).value=auditArr[18]; //��������
			objSheet.Cells(3+k,7).value=auditArr[5]; //�Ľ�����
			objSheet.Cells(3+k,8).value=auditArr[6]; //��ϵ�绰
			objSheet.Cells(3+k,9).value=auditArr[7]; //�ϱ���
			objSheet.Cells(3+k,10).value=auditArr[19]; //�ϱ���ְҵ���
			objSheet.Cells(3+k,11).value=auditArr[20]; //�ϱ���ְ��
			objSheet.Cells(3+k,12).value=auditArr[8]; //�¼������ص�
			objSheet.Cells(3+k,13).value=auditArr[9]; //�¼���������
			objSheet.Cells(3+k,14).value=auditArr[10]; //��������
			objSheet.Cells(3+k,15).value=auditArr[11]; //�¼�����
			objSheet.Cells(3+k,16).value=auditArr[12]; //�¼��ȼ�
			objSheet.Cells(3+k,17).value=auditArr[13]; //һ������
			objSheet.Cells(3+k,18).value=auditArr[14]; //��������
			objSheet.Cells(3+k,19).value=auditArr[15]; //���ܲ����������
			objSheet.Cells(3+k,20).value=auditArr[16]; //�����Ľ���ʩ 
	 
	    }
		
		xlBook.SaveAs(filePath+"�����¼��벡�˰�ȫ�����ϱ����������"+yearDate+".xls");
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;

}
///���ñ༭����(������ϸ) 2016-10-13
function setCellAssess(value, rowData, rowIndex)
{          
  
		var ID=rowData.ID;         //����ID
		var typecode=rowData.typecode; //�������ʹ���  Typeevent
	    var TypeID=rowData.TypeID;  //��������ID
		var AssessRowID=rowData.Assess //����ID
		//return "<a href='#' onclick=\"showAssessWin('"+ID+"','"+typecode+"')\"><img src='../scripts/dhcadvEvt/images/viewlist.png' border=0/></a>";
		var html = "";
		if ((AssessRowID != "")){
			html = "<a href='#' onclick=\"showAssessWin('"+ID+"','"+typecode+"','"+TypeID+"','"+AssessRowID+"')\" style='margin:0px 5px;font-weight:bold;color:red;text-decoration:none;'>������</a>";
		}else{
			  html = "δ����";
			}
	    return html;
}
//�༭����(������ϸ) 2016-10-13
function showAssessWin(ID,typecode,TypeID,AssessRowID)
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'������ϸ',
		collapsible:true,
		border:false,
		closed:"true",
		width:900,
		height:500
	});
	if(typecode=="material"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+ID+'&RepType='+TypeID+'&AssessID='+AssessRowID+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(typecode=="drugerr"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+ID+'&RepType='+TypeID+'&AssessID='+AssessRowID+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(typecode=="blood"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+ID+'&RepType='+TypeID+'&AssessID='+AssessRowID+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	
	if(typecode=="med"||typecode=="bldevent"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+ID+'&RepType='+TypeID+'&AssessID='+AssessRowID+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(typecode=="drug"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+ID+'&RepType='+TypeID+'&AssessID='+AssessRowID+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}	
}
